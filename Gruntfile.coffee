path     = require 'path'
mongoose = require './lib/mongoose'

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    # you may set host, port, & database name for each enviroment
    # environments must coincide with process.env.NODE_ENV (test, development, production, etc.)
    #
    # default values:
    #
    # host: 'localhost'
    # port: 27017
    # database: 'lux'
    connection:
      test:
        host: 'vavt-mongo-comp'
        database: 'lux-test'
      mock:
        host: 'vavt-mongo-comp'
        database: 'lux-mock'
      production:
        host: 'vavp-mongo-comp'
    start:
      mongod:
        args: ['--fork', '--pidfilepath', '<%= files.pid.mongod %>']
      express:
        command: 'node'
        args: 'app.js'
    stop:
      mongod:
        processname: 'mongod'
      express:
        processname: 'express'
    files:
      pid:
        # in case mongod writes relative files to it's own special place
        # could not get this to work with relative file path.
        mongod: '<%= process.cwd() %>/mongod.pid'
    jasmine:
      # you want this guy in development since it watches files for changes and autoruns tests
      unit:
        autotest: true
        specdir: 'unit'
      # use jasmine:integration:development target to trigger this guy
      integration:
        specdir: 'integration'
      # you'll want to run this on CI server (does not watch files or autorun test suite...one time run)
      ci:
        specdir: 'unit'
  # jasmine-contrib/grunt-jasmine-node has not been updated for 10 months.
  # it does not support the latest options for jasmine-node like growl support.
  # so shelling out to subprocess instead. easier than working directly against
  # API (IMHO).
  grunt.registerMultiTask 'jasmine', ->
    done              = this.async()
    autotest          = grunt.config "jasmine.#{this.target}.autotest"
    specdir           = path.join "spec", grunt.config "jasmine.#{this.target}.specdir"
    args              = [specdir, '--coffee', '--verbose', '--captureExceptions']
    autotestArguments = ['--watch', 'lib', '--autotest']

    args = args.concat autotestArguments if autotest is true

    exec command: 'jasmine-node', args: args, done

  grunt.registerMultiTask 'start', ->
    done    = this.async()
    command = grunt.config "start.#{this.target}.command"
    command ?= this.target

    checkForExpiredProcess command

    grunt.log.writeln "Starting #{command}..."

    pidPath = grunt.config "files.pid.#{command}"
    args    = grunt.config "start.#{command}.args"

    exec command: command, args: args, done

  grunt.registerMultiTask 'stop', ->
    processName = grunt.config "stop.#{this.target}.processname"

    killProcess processName

  # environment can be overriden at task level.
  # to connect using the 'test' connection, invoke
  # the task as follows:
  #
  # mongo:connect:test
  #
  # syntax is:
  #
  # mongo:connect:<environment>
  #
  # we'll likely need to do this in Team City since exporting
  # the NODE_ENV enviroment variable would cause UI tests to run
  # with non-development configuration. this causes an issue due
  # to assets being built/compiled in later build step.
  grunt.registerTask 'mongo:connect', ->
    connectionOptions = grunt.config "connection.#{this.args[0] || process.env.NODE_ENV}"

    mongoose.connect2 connectionOptions

  grunt.registerTask 'mongo:disconnect', ->
    mongoose.disconnect()

  grunt.registerTask 'default', 'jasmine:unit'

  # NOTE: this should only be run during development.
  # we'll refrain from executing the mongo:connect or
  # mongo:disconnect task during integration test runs.
  # the jasmine:integration target will assume this responsibility
  # via a helper file (see integration/helpers directory). otherwise we'd
  # end up connecting to the database twice as jasmine-node
  # is executed in a separate process. if starting node app,
  # then do execute mongo:connect prior to doing so, and mongo:disconnect
  # after app terminates.
  grunt.registerTask 'jasmine:integration:development', ['start:mongod', 'jasmine:integration', 'stop:mongod']

  # in ci enviroment (i.e. Team City), mongo server will already be running on remote computer; so no need to start/stop
  grunt.registerTask 'jasmine:integration:ci', ['jasmine:integration']

  exec = (options, done) ->
    child =
      grunt.util.spawn
        cmd: options.command
        args: options.args
        opts:
          stdio: 'inherit'
        (error, result, code) ->
          done()

    logPid options.command, child.pid if options.logpid

  logPid = (command, pid) ->
    pidPath = grunt.config "files.pid.#{command}"

    grunt.log.writeln "Generating pid file for \"#{command}\"."

    grunt.file.write pidPath, pid

  checkForExpiredProcess = (processName) ->
    pidPath = grunt.config "files.pid.#{processName}"

    grunt.log.writeln 'Checking for existing pid file.'

    if grunt.file.exists pidPath
      grunt.log.writeln "Detected existing pid file for \"#{processName}\"."
      grunt.log.writeln 'Attempting to kill expired instance.'

      killProcess processName
    else
      grunt.log.writeln "No pid file found. Assuming \"#{processName}\" was either cleanly shutdown, or is being started for the first time."

  killProcess = (processName)->
    pidPath = grunt.config "files.pid.#{processName}"

    unless grunt.file.exists pidPath
      grunt.log.error 'Aborting. No pid file found.'
      return

    pid = grunt.file.read pidPath
    pid = parseInt pid

    grunt.log.writeln "Killing \"#{processName}\" process with pid #{pid}."

    process.kill pid

    grunt.file.delete pidPath
