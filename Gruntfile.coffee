path     = require 'path'
mongoose = require './lib/mongoose'

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    files:
      mongo:
        # in case mongod writes relative files to it's own special place
        # could not get this to work with relative file path.
        pid: '<%= process.cwd() %>/mongod.pid'
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
    done = this.async()

    autotest = grunt.config "jasmine.#{this.target}.autotest"
    specdir  = path.join "spec", grunt.config "jasmine.#{this.target}.specdir"

    options         = [specdir, '--coffee', '--verbose', '--captureExceptions']
    autotestOptions = ['--watch', 'lib', '--autotest']

    options = options.concat autotestOptions if autotest is true

    grunt.util.spawn
      cmd: 'jasmine-node'
      args: options
      opts:
        stdio: 'inherit'
      (error, result, code) ->
        done()

  grunt.registerTask 'mongo:start', ->
    done = this.async()

    checkForExpiredDaemon()

    grunt.log.writeln 'Starting mongod...'

    pidPath = grunt.config 'files.mongo.pid'

    grunt.util.spawn
      cmd: 'mongod'
      args: ['--fork', '--pidfilepath', pidPath]
      opts:
        stdio: 'inherit'
      (error, result, code) ->
        done()

    freeResourcesOnProcessExit()

  grunt.registerTask 'mongo:connect', ->
    mongoose.connect2();

  grunt.registerTask 'mongo:disconnect', ->
    mongoose.disconnect()

  grunt.registerTask 'mongo:stop', ->
    stopMongoDaemon()

  grunt.registerTask 'default', 'jasmine:unit'

  # NOTE: this should only be run during development.
  # we'll refrain from executing the mongo:connect task
  # during test runs. the jasmine:integration target will
  # assume the responsibility (spec-helper). otherwise we'd
  # end up connecting to the database twice as jasmine-node
  # is executed in a separate process. if starting node app,
  # then do execute mongo:connect prior to doing so.
  grunt.registerTask 'jasmine:integration:development', ['mongo:start', 'jasmine:integration', 'mongo:disconnect', 'mongo:stop']

  # in ci enrionment (i.e. Team City), mongo server will already be running on remote computer; so no need to start/stop
  grunt.registerTask 'jasmine:integration:ci', ['jasmine:integration', 'mongo:disconnect']

  checkForExpiredDaemon = ->
    pidPath = grunt.config 'files.mongo.pid'

    grunt.log.writeln 'Checking for existing pid file.'

    if grunt.file.exists pidPath
      grunt.log.writeln 'Detected existing pid file for mongod.'
      grunt.log.writeln 'Attempting to kill expired instance.'

      stopMongoDaemon()
    else
      grunt.log.writeln 'No pid file found. Assuming mongod was either cleanly shutdown, or is being started for the first time.'

  stopMongoDaemon = ->
    pidPath = grunt.config 'files.mongo.pid'

    unless grunt.file.exists pidPath
      grunt.log.error 'Aborting. No pid file found.'
      return

    pid = grunt.file.read pidPath
    pid = parseInt pid

    grunt.log.writeln "Killing mongod instance with pid #{pid}."

    process.kill pid

    grunt.file.delete pidPath
  
  freeResourcesOnProcessExit = ->
    # we should only get SIGINT signal in development Ctl+C, so blindly
    # executing the stop task should be ok. in addition, this code is
    # only executed on mongo:start, which is again a development environment
    # only task (nice invariant here). need to test on Windows. I think SIGINT
    # may only work on *nix platforms.
    process.on 'SIGINT', ->
      grunt.task.run 'mongo:disconnect', 'mongo:stop'

      process.exit 0
