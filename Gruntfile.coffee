util = require 'util'

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

  # jasmine-contrib/grunt-jasmine-node has not been updated for 10 months.
  # it does not support the latest options for jasmine-node like growl support.
  grunt.registerTask 'testdrive', ->
    done = this.async()

    grunt.util.spawn
      cmd: 'jasmine-node'
      args: ['spec', '--coffee', '--verbose', '--captureExceptions']
      opts:
        stdio: 'inherit',
      (error, result, code) ->
        done()

  grunt.registerTask 'default', 'testdrive'
