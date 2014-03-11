describe 'market-summary', ->
  MarketSummary        = require '../../../lib/market-summary/market-summary'
  MarketSummaryService = require '../../../lib/market-summary/service'
  MarketSummaryModel   = require '../../../lib/market-summary/model'
  sinon                = require 'sinon'
  Q                    = require 'q'
  _                    = require 'lodash'

  describe 'get', ->
    describe 'available preferences are returned by the market summary service', ->
      beforeEach ->
        sinon.stub MarketSummaryService, 'get', -> Q ['State Street Bank', 'Aohal Drift Hedge Fund']
        sinon.stub MarketSummaryModel, 'get', -> Q null

      afterEach ->
        MarketSummaryService.get.restore()
        MarketSummaryModel.get.restore()

      it 'gives each preference a selected key', (done) ->
        MarketSummary
          .get()
          .fin done
          .done (preferences) ->
            allPreferencesContainSelectedKey = _.every preferences, (preference) -> preference.hasOwnProperty 'selected'

            expect(allPreferencesContainSelectedKey).toBe true

      it 'returns each preference the market summary service returns', (done) ->
        MarketSummary
          .get()
          .fin done
          .done (preferences) ->
            preferenceNames = _.pluck preferences, 'name'

            expect(preferenceNames).toEqual ['Aohal Drift Hedge Fund', 'State Street Bank']

    describe 'market summary service returns a falsy result (null, undefined, etc.)', ->
      beforeEach ->
        sinon.stub MarketSummaryService, 'get', -> Q null
        sinon.stub MarketSummaryModel, 'get', -> Q null

      afterEach ->
        MarketSummaryService.get.restore()
        MarketSummaryModel.get.restore()

      it 'returns an empty array', (done) ->
        MarketSummary
          .get()
          .fin done
          .done (preferences) ->
            expect(preferences).toEqual []

    describe 'the current user has preferences in the database that match preferences returned by the market summary service', ->
      beforeEach ->
        sinon.stub MarketSummaryService, 'get', -> Q ['State Street Bank', 'Aohal Drift Hedge Fund']

        sinon.stub MarketSummaryModel, 'get', ->
          Q
            userId: '21EC2020-3AEA-4069-A2DD-08002B30309D'
            preferences: ['State Street Bank']

      afterEach ->
        MarketSummaryService.get.restore()
        MarketSummaryModel.get.restore()

      it "marks each preference as selected", (done) ->
        MarketSummary
          .get()
          .fin done
          .done (preferences) ->
            preference1 =
              name: 'Aohal Drift Hedge Fund'
              selected: false
            preference2 =
              name: 'State Street Bank'
              selected: true

            expect(preferences).toEqual [preference1, preference2]

    describe 'market summary service returns an empty result', ->
      beforeEach ->
        sinon.stub MarketSummaryService, 'get', -> Q []
        sinon.stub MarketSummaryModel, 'get', -> Q null

      afterEach ->
        MarketSummaryService.get.restore()
        MarketSummaryModel.get.restore()

      it 'returns an empty result', (done) ->
        MarketSummary
          .get()
          .fin done
          .done (preferences) ->
            expect(preferences).toEqual []

