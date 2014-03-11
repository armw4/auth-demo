# this guy will automagically get written to the global namespace, which is what we want:
#
# https://github.com/mhevery/jasmine-node/blob/abfe06a684c00091b24b4918192920c5534b95c2/lib/jasmine-node/index.js#L66
require 'jasmine-sinon'

User     = require '../../../lib/user'
mongoose =
  # assign mongoose functions used by models to no-ops
  # better to tax the test code than add additional complexity
  # to models around schema creation/configuration. as we use
  # more functions exposed by mongoose in our models/schemas, we'll
  # have to add those methods here and assign them to no-ops as follows.
  # I view this as a reasonable compromise between keeping our models as is,
  # and still allowing components that indirectly depend on models/schemas
  # to remain unit testable.
  Schema: ->
    path: ->
      validate: ->
  model: ->

module.exports =
  User: User
  mongoose: mongoose
