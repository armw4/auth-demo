path     = require 'path'
mongoose = require 'mongoose'
_        = require 'lodash'

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    # FIXME: read host, port, database, etc. from express app configuration (or some environment based config)
    mongo:
      host: 'localhost'
      port: 27017
      database: 'lux'
      uri: 'mongodb://<%= mongo.host %>:<%= mongo.port %>/<%= mongo.database %>'
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

  grunt.registerTask 'mongo:connect', ->
    uri = grunt.config 'mongo.uri'

    grunt.log.writeln "Attempting to connect to #{uri}."

    mongoose.connect uri

    grunt.log.writeln "Successfully connected to #{uri}."

  grunt.registerTask 'mongo:disconnect', ->
    uri = grunt.config 'mongo.uri'

    grunt.log.writeln "Attempting to disconnect from #{uri}."

    mongoose.disconnect()

    grunt.log.writeln "Successfully disconnected from #{uri}."

  grunt.registerTask 'mongo:stop', ->
    stopMongoDaemon()

  grunt.registerTask 'default', 'jasmine:unit'

  # NOTE: this should only be run during development.
  grunt.registerTask 'jasmine:integration:development', ['mongo:start', 'mongo:connect', 'jasmine:integration', 'mongo:disconnect', 'mongo:stop']

  # in ci enrionment (i.e. Team City), mongo server will already be running on remote computer; so no need to start/stop
  grunt.registerTask 'jasmine:integration:ci', ['mongo:connect', 'jasmine:integration', 'mongo:disconnect']

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
