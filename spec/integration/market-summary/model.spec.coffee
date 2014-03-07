describe 'market-summary-model', ->
  sinon              = require 'sinon'
  MarketSummaryModel = require '../../../lib/market-summary/model'
  db                 = mongoose.connection.db
  Q                  = require 'q'
  marketSummary      = null

  persistPreferencesForCurrentUser = (done) ->
    marketSummary =
      userId: User.current().individualKey
      preferences: ['STATE STREET BANK', 'OLEAH BRANCH']

    MarketSummaryModel
      .save marketSummary
      .fin done

  afterEach (done) ->
    Q.ninvoke db, 'dropCollection', 'marketsummaries'
     .fin done

  describe 'get', ->
    describe 'preferences exist for current user', ->
      beforeEach (done) ->
        sinon.stub User, 'current', ->
          individualKey: '999999999999'
          socialSecurityNumber: '000000009'

        persistPreferencesForCurrentUser done

      afterEach ->
        User.current.restore()

      it 'returns preferences', (done) ->
        MarketSummaryModel
          .get()
          .fin done
          .done (hydratedMarketSummary) ->
            expect(marketSummary.userId).toEqual hydratedMarketSummary.userId
            expect(marketSummary.preferences.length).toEqual hydratedMarketSummary.preferences.length

    describe 'no preferences exist for current user', ->
      beforeEach (done) ->
        sinon.stub User, 'current', ->
          individualKey: '8888888888'
          socialSecurityNumber: '000000009'

        persistPreferencesForCurrentUser done

      afterEach ->
        User.current.restore()

      it 'does not return preferences', (done) ->
        MarketSummaryModel
          .get()
          .fin done
          .done (hydratedMarketSummary) ->
            expect(hydratedMarketSummary).toBeNull
