module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    files:
      mongo:
        # in case mongod write relative files to it's own special place
        pid: '<%= process.cwd() %>/mongod.pid'
    testdrive:
      unit:
        autotest: true
      continuous:
        autotest: false
  # jasmine-contrib/grunt-jasmine-node has not been updated for 10 months.
  # it does not support the latest options for jasmine-node like growl support.
  grunt.registerMultiTask 'testdrive', ->
    done = this.async()

    autotest = grunt.config "testdrive.#{this.target}.autotest"

    options         = ['spec', '--coffee', '--verbose', '--captureExceptions']
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
    pidPath = grunt.config 'files.mongo.pid'
    pid     = grunt.file.read pidPath
    pid     = parseInt pid

    grunt.log.writeln "Killing mongod instance with pid #{pid}."

    process.kill pid

    grunt.log.writeln 'Deleting mongod pid file.'

    grunt.file.delete pidPath

  grunt.registerTask 'default', 'testdrive:unit'
