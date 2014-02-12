module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
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
        stdio: 'inherit',
      (error, result, code) ->
        done()

  grunt.registerTask 'default', 'testdrive:unit'
