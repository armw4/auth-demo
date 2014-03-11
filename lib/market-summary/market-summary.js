var MarketSummaryModel   = require('./model');
var MarketSummaryService = require('./service');
var _                    = require('lodash');
var Q                    = require('q');

var MarketSummary = {
  get: function() {
    var transaction = [MarketSummaryService.get(), MarketSummaryModel.get()];

    return Q.spread(transaction, function(availablePreferences, marketSummaryModel) {
      if(!availablePreferences || _.isEmpty(availablePreferences)) return Q([]);
      else {
        var persistedPreferences = (marketSummaryModel && marketSummaryModel.preferences) || [];

        var results = _.map(availablePreferences, function(preference) {
          return { name: preference, selected: _.contains(persistedPreferences, preference) };
        });

        return _.sortBy(results, 'name');
      }
    });
  }
};

module.exports = MarketSummary;
