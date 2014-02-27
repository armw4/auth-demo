# monkey patches jasmine to provide beforeAll and afterAll hooks
#
# be sure to add this file as a helper as described in my answer on SO:
#
# http://stackoverflow.com/a/22054113/389103
#
# inspired by https://groups.google.com/forum/#!msg/jasmine-js/1LvuiUPunwU/SXPo6PMGSSMJ
#
# targets jasmine-node@1.13.1 and jasmine@1.3.1
#
# https://github.com/mhevery/jasmine-node/blob/abfe06a684c00091b24b4918192920c5534b95c2/lib/jasmine-node/jasmine-1.3.1.js

beforeAll = (done) ->
  # establish connection to database for integration tests
  mongoose.connect2()

  done()

env = jasmine.getEnv()

execute = env.execute

env.execute = ->
  beforeAll ->
    execute.call env

afterAll = (done) ->
  # disconnect from database for integration tests
  mongoose.disconnect()

  done()

runner = env.currentRunner();

postExecute = runner.finishCallback;

runner.finishCallback = ->
  afterAll ->
    postExecute.call runner
