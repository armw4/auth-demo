module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

  # Default task(s).
  # starts the karma server and the watch task
  grunt.registerTask 'testdrive', ['karma:unit:start', 'watch:unit']

  grunt.registerTask 'default', 'testdrive'
