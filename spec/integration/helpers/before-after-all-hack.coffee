# monkey patches jasmine to provide beforeAll and afterAll hooks
#
# inspired by https://groups.google.com/forum/#!msg/jasmine-js/1LvuiUPunwU/SXPo6PMGSSMJ
#
# targets jasmine-node@1.13.1 and jasmine@1.3.1
#
# https://github.com/mhevery/jasmine-node/blob/abfe06a684c00091b24b4918192920c5534b95c2/lib/jasmine-node/jasmine-1.3.1.js

#beforeAll = (done) ->
  ## execute your stuff (i.e. datase connection)

#execute = jasmine.Runner.prototype.execute

#jasmine.Runner.prototype.execute = ->
  #beforeAll ->
    #execute()

#afterAll = (done) ->
  ## execute your stuff (i.e. database disconnect)

#postExecute = jasmine.Runner.prototype.finishCallback

#jasmine.Runner.prototype.finishCallback = ->
  #afterAll ->
#    postExecute()
