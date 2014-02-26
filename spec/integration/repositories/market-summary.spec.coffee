describe 'market-summary', ->
  sinon         = require 'sinon'
  User          = require '../../../lib/user'
  MarketSummary = require '../../../lib/repositories/market-summary'
  mongoose      = require 'mongoose'
  db            = mongoose.connection.db
  Q             = require 'q'
  marketSummary = null

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
    it 'gets market summary preferences for the current user', ->
      hydratedMarketSummary = MarketSummary.get()

      expect(hydratedMarketSummary.userId).toEqual marketSummary.userId
      expect(hydratedMarketSummary.preferences).toEqual marketSummary.preferences

    describe 'no preferences exist for current user', ->
      beforeEach ->
        sinon.stub User, 'current', ->
          individualKey: '8888888888'
          socialSecurityNumber: '000000009'

      afterEach ->
        User.current.restore()

      it 'does not return market summary preferences', ->
        hydratedMarketSummary = MarketSummary.get()

        expect(hydratedMarketSummary).toBeNull
