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

  dropCollection = (done) ->
    Q.ninvoke mongoose.connection.db, 'dropCollection', 'marketsummaries'
     .fin done

  describe 'get', ->
    describe 'preferences exist for current user', ->
      beforeEach (done) ->
        sinon.stub User, 'current', ->
          individualKey: '999999999999'
          socialSecurityNumber: '000000009'

        persistPreferencesForCurrentUser done

      afterEach (done) ->
        User.current.restore()

        dropCollection done

      it 'returns preferences', (done) ->
        MarketSummaryModel
          .get()
          .fin done
          .done (hydratedMarketSummary) ->
            expect(marketSummary.userId).toEqual hydratedMarketSummary.userId
            expect(marketSummary.preferences.length).toEqual hydratedMarketSummary.preferences.length

    describe 'no preferences exist for current user', ->
      beforeEach ->
        sinon.stub User, 'current', ->
          individualKey: '8888888888'
          socialSecurityNumber: '000000009'

      afterEach ->
        User.current.restore()

      it 'does not return preferences', (done) ->
        MarketSummaryModel
          .get()
          .fin done
          .done (hydratedMarketSummary) ->
            expect(hydratedMarketSummary).toBeNull

  describe 'save', ->
    describe 'userId is not set', ->
      it 'triggers a validation error', (done) ->
        marketSummary =
          preferences: ['One', 'Two', 'Three', 'Four']

        failCallback = sinon.spy()

        MarketSummaryModel
          .save marketSummary
          .fin done
          .fail failCallback
          .done ->
            expect(failCallback).toHaveBeenCalled()

    describe 'preferences is not set', ->
      it 'triggers a validation error', (done) ->
        marketSummary =
          userId: '21EC2020-3AEA-4069-A2DD-08002B30309D'
          preferences: undefined

        failCallback = sinon.spy()

        MarketSummaryModel
          .save marketSummary
          .fin done
          .fail failCallback
          .done ->
            expect(failCallback).toHaveBeenCalled()

    describe 'more than 4 preferences are selected', ->
      it 'triggers a validation error', (done) ->
        marketSummary =
          userId: '21EC2020-3AEA-4069-A2DD-08002B30309D'
          preferences: ['One', 'Two', 'Three', 'Four', 'Five']

        failCallback = sinon.spy()

        MarketSummaryModel
          .save marketSummary
          .fin done
          .fail failCallback
          .done ->
            expect(failCallback).toHaveBeenCalled()

    describe 'preferences exist for the current user', ->
      beforeEach (done) ->
        marketSummary =
          userId: '21EC2020-3AEA-4069-A2DD-08002B30309D'
          preferences: ['One', 'Two', 'Three', 'Four']

        MarketSummaryModel
          .save marketSummary
          .fin done

      afterEach (done) ->
        dropCollection done

      it "updates the existing preferences", (done) ->
        marketSummary =
          userId: '21EC2020-3AEA-4069-A2DD-08002B30309D'
          preferences: ['One', 'Two', 'Three']

        # Q.spread won't work since it does not enforce order. we need the record
        # saved BEFORE we read the count from the database.
        MarketSummaryModel
          .save marketSummary
          .fin done
          .done (rehydratedMarketSummary) ->
            collection = mongoose.connection.db.collection 'marketsummaries'

            Q.ninvoke(collection, 'count')
             .done (recordCount) ->
                expect(recordCount).toEqual 1

   describe 'preferences do not exist for the current user', ->
    beforeEach (done) ->
      marketSummary =
        userId: '31EC2020-3AEF-4069-A2DD-07102D50809D'
        preferences: ['One', 'Two', 'Three', 'Four']

      MarketSummaryModel
        .save marketSummary
        .fin done

    afterEach (done) ->
      dropCollection done

    it "adds new preferences", (done) ->
      marketSummary =
        userId: '21EC2020-3AEA-4069-A2DD-08002B30309D'
        preferences: ['One', 'Two', 'Three']

      MarketSummaryModel
        .save marketSummary
        .fin done
        .done (rehydratedMarketSummary) ->
          collection = mongoose.connection.db.collection 'marketsummaries'

          Q.ninvoke(collection, 'count')
           .done (recordCount) ->
              expect(recordCount).toEqual 2
              expect(rehydratedMarketSummary.preferences.length).toEqual 3
