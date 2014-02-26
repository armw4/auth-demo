describe 'market-summary', ->
  sinon         = require 'sinon'
  User          = require '../../../lib/user'
  MarketSummary = require '../../../lib/repositories/market-summary'
  mongoose      = require 'mongoose'
  db            = mongoose.connection.db
  Q             = require 'q'

  beforeEach (done) ->
    sinon.stub User, 'current', ->
      individualKey: '999999999999'
      socialSecurityNumber: '000000009'

    marketSummary =
      userId: User.current().individualKey
      preferences: ['STATE STREET BANK', 'OLEAH BRANCH']

    MarketSummary.save(marketSummary).done done

  afterEach (done) ->
    User.current.restore()
    Q.nfcall(db.dropCollection, 'users').done done

  describe 'get', ->
    it 'gets market summaries for the current user', ->
      expect().toEqual 'iiiii'
