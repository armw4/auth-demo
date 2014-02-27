describe 'market-summary', ->
  sinon         = require 'sinon'
  MarketSummary = require '../../../lib/repositories/market-summary'
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

    MarketSummary
      .save marketSummary
      .fin done

  afterEach (done) ->
    User.current.restore()
    Q.ninvoke db, 'dropCollection', 'marketsummaries'
     .fin done

  describe 'get', ->
    it 'gets market summary preferences for the current user', (done) ->
      MarketSummary
        .get()
        .fin done
        .done (hydratedMarketSummary) ->
          expect(marketSummary.userId).toEqual hydratedMarketSummary.userId
          expect(marketSummary.preferences.length).toEqual hydratedMarketSummary.preferences.length

    #describe 'no preferences exist for current user', ->
      #beforeEach ->
        #User.current.restore()
        #sinon.stub User, 'current', ->
          #individualKey: '8888888888'
          #socialSecurityNumber: '000000009'

      #it 'does not return market summary preferences', ->
        #hydratedMarketSummary = MarketSummary.get()

        #expect(hydratedMarketSummary).toBeNull
