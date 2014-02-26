var Q             = require('q');
var MarketSummary = require('../schemas/market-summary');
var User          = require('../user');

var marketSummary = {
  get: function() {
    var filter = { userId: User.current().individualKey };
    var promise = Q.nfcall(MarketSummary.findOne, filter);

    return promise;
  },

  save: function(marketSummary) {
    MarketSummary.save(marketSummary);
  }
};

module.exports = marketSummary;
