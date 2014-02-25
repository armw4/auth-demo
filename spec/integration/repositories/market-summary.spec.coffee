describe 'market-summary', ->
  sinon         = require 'sinon'
  User          = require '../../../lib/user'
  MarketSummary = require '../../../lib/repositories/market-summary'
  mongoose      = require 'mongoose'
  db            = mongoose.connection.db

  beforeEach ->
    sinon.stub User, 'current', ->
      individualKey: '999999999999'
      socialSecurityNumber: '000000009'

    marketSummary =
      userId: User.current().individualKey
      preferences: ['STATE STREET BANK', 'OLEAH BRANCH']

    marketSummaryModel = new MarketSummarySchema marketSummary
    marketSummaryModel.save()

  afterEach ->
    User.current.restore()
    db.dropCollection 'users'

  describe 'get', ->
    it 'gets market summaries for the current user', ->
      expect(User.current().individualKey).toEqual 'iiiii'
