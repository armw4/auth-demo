var MarketSummaryModel   = require('./model');
var MarketSummaryService = require('./service');
var _                    = require('lodash');
var Q                    = require('q');

var MarketSummary = {
  get: function() {
    return MarketSummaryService.get().then(function(availablePreferences) {
      if(!availablePreferences || _.isEmpty(availablePreferences)) return Q([]);
      else
        return  Q([
              { name: 'State Street Bank', selected: true },
              { name : 'Aohal Drift Hedge Fund', selected: true }
            ]);
    });
  }
};

module.exports = MarketSummary;
