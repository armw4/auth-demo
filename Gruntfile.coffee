path = require 'path'

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    files:
      mongo:
        # in case mongod writes relative files to it's own special place
        # could not get this to work with relative file path.
        pid: '<%= process.cwd() %>/mongod.pid'
    testdrive:
      unit:
        autotest: true
        specdir: 'unit'
      continuous:
        autotest: false
        specdir: 'unit'
  # jasmine-contrib/grunt-jasmine-node has not been updated for 10 months.
  # it does not support the latest options for jasmine-node like growl support.
  grunt.registerMultiTask 'testdrive', ->
    done = this.async()

    autotest = grunt.config "testdrive.#{this.target}.autotest"
    specdir  = path.join "spec", grunt.config "testdrive.#{this.target}.specdir"

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

  grunt.registerTask 'mongo:stop', ->
    stopMongoDaemon()

  grunt.registerTask 'default', 'testdrive:unit'

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

    grunt.log.writeln 'Deleting mongod pid file.'

    grunt.file.delete pidPath
