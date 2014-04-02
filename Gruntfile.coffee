path     = require 'path'

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    start:
      express: 'express'
      mongod: 'mongod'
    stop:
      express: 'express'
      mongod: 'mongod'
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
    done = this.async()

    exec command: 'forever', args: ['start', "bin/#{this.target}.js"], done

  grunt.registerMultiTask 'stop', ->
    done = this.async()

    exec command: 'forever', args: ['stop', "bin/#{this.target}.js"], done

  grunt.registerTask 'default', 'jasmine:unit'

  grunt.registerTask 'jasmine:integration:development', ['start:mongod', 'jasmine:integration', 'stop:mongod']

  grunt.registerTask 'start:app', ['start:mongod', 'start:express']

  grunt.registerTask 'stop:app', ['stop:express', 'stop:mongod']

  # in ci enviroment (i.e. Team City), mongo server will already be running on remote computer; so no need to start/stop
  grunt.registerTask 'jasmine:integration:ci', ['jasmine:integration']

  exec = (options, done) ->
    child =
      grunt.util.spawn
        cmd: options.command
        args: options.args
        opts:
          stdio: 'pipe'
        (error, result, code) ->
          done()
