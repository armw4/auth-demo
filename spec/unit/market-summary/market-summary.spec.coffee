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
        sinon.stub MarketSummaryService, 'get', ->
          Q ['State Street Bank', 'Aohal Drift Hedge Fund']

      afterEach ->
        MarketSummaryService.get.restore()

      it 'gives each preference a selected key', (done) ->
        MarketSummary
          .get()
          .fin done
          .done (preferences) ->
            allPreferencesContainSelectedKey = _.every preferences, (preference) -> preference.hasOwnProperty 'selected'

            expect(allPreferencesContainSelectedKey).toBe true

      it 'returns each preference the market summary service returns', (done) ->
        preferences = MarketSummary
          .get()
          .fin done
          .done (preferences) ->
            preferenceNames = _.pluck preferences, 'name'

            expect(preferenceNames).toEqual ['State Street Bank', 'Aohal Drift Hedge Fund']

    describe 'market summary service returns a falsy result (null, undefined, etc.)', ->
      beforeEach ->
        sinon.stub MarketSummaryService, 'get', ->
          Q null

      afterEach ->
        MarketSummaryService.get.restore()

      it 'returns an empty array', (done) ->
        MarketSummary
          .get()
          .fin done
          .done (preferences) ->
            expect(preferences).toEqual []

    describe 'market summary service returns an empty result', ->
      beforeEach ->
        sinon.stub MarketSummaryService, 'get', ->
          Q []

      afterEach ->
        MarketSummaryService.get.restore()

      it 'returns an empty result', (done) ->
        MarketSummary
          .get()
          .fin done
          .done (preferences) ->
            expect(preferences).toEqual []
