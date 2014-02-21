path     = require 'path'
mongoose = require 'mongoose'
_        = require 'lodash'

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    # FIXME: read host, port, database, etc. from express app configuration
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
    test:
      # you want this guy in development since it watches files
      # for changes and autoruns tests
      unit:
        autotest: true
        specdir: 'unit'
      integration:
        specdir: 'integration'
      # you'll want to run this on CI server (one time run)
      ci:
        specdir: 'unit'
  # jasmine-contrib/grunt-jasmine-node has not been updated for 10 months.
  # it does not support the latest options for jasmine-node like growl support.
  grunt.registerMultiTask 'test', ->
    done = this.async()

    autotest = grunt.config "test.#{this.target}.autotest"
    specdir  = path.join "spec", grunt.config "test.#{this.target}.specdir"

    options         = [specdir, '--coffee', '--verbose', '--captureExceptions']
    autotestOptions = ['--watch', 'lib', '--autotest']

    options = options.concat autotestOptions if autotest is true

    grunt.util.spawn
      cmd: 'jasmine-node'
      args: options
      opts:
        stdio: 'inherit'
      (error, result, code) ->
        grunt.task.run 'mongo:disconnect', 'mongo:stop' if this.target is 'integration'
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

  grunt.registerTask 'default', 'test:unit'

  grunt.registerTask 'test:live', ['mongo:start', 'mongo:connect', 'test:integration', 'mongo:disconnect', 'mongo:stop']

  checkForExpiredDaemon = ->
    pidPath = grunt.config 'files.mongo.pid'

    grunt.log.writeln 'Checking for existing pid file.'

    if grunt.file.exists pidPath
      grunt.log.writeln 'Detected existing pid file for mongod.'
      grunt.log.writeln 'Attempting to kill expired instance.'

      stopMongoDaemon()
    else
      grunt.log.write   'No pid file found. Assuming mongod was either cleanly shutdown,'
      grunt.log.writeln 'or is being started for the first time.'

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
