var Q = require('q');

var MarketSummaryService = {
  get: function() {
    return Q(['State Street Bank', 'Aola Hedge Fund']);
  }
};

module.exports = MarketSummaryService;
