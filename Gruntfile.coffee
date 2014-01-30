module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    karma:
      options:
        configFile: 'karma.conf.coffee'
      # for development (TDD)
      unit:
        # forks karma as a child process so as not to block main grunt process
        background: true
      # for single run on build server or even during development
      # if you don't want watch loop.
      continuous:
        singleRun: true
        browsers: ['PhantomJS']
    watch:
      # run unit tests with karma (server needs to already be running)
      unit:
        # re-run unit tests if we change source or specs
        files: [ 'lib/**/*.js', 'specs/**/*.spec.coffee' ]
        tasks: ['karma:unit:run'] # NOTE: the :run flag

  # load custom npm tasks. see devDependencies hash in package.json
  grunt.loadNpmTasks 'grunt-karma'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  # Default task(s).
  # starts the karma server and the watch task
  grunt.registerTask 'testdrive', ['karma:unit:start', 'watch:unit']

  grunt.registerTask 'default', 'testdrive'
