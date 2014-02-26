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
    var deferred = Q.defer();
    var model    = new MarketSummary(marketSummary);

    model.save(function(error) {
      if (error)
        deferred.reject(error);
      else
        deferred.resolve(model); // publish the hydrated model back to the client. it should have an id now.
    });

    return deferred.promise;
  }
};

module.exports = marketSummary;
