require 'jasmine-sinon'

# this guy will automagically get written to the global namespace, which is what we want:
#
# https://github.com/mhevery/jasmine-node/blob/abfe06a684c00091b24b4918192920c5534b95c2/lib/jasmine-node/index.js#L66
User     = require '../../../lib/user'
mongoose = require '../../../lib/mongoose'

module.exports =
  User: User
  mongoose: mongoose
