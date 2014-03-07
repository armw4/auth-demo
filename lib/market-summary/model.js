var Q                   = require('q');
var MarketSummarySchema = require('./schema');

var MarketSummaryModel = {
  get: function() {
    var filter  = { userId: User.current().individualKey };
    var promise = Q.ninvoke(MarketSummarySchema, 'findOne', filter);

    return promise;
  },

  save: function(marketSummary) {
    var deferred = Q.defer();
    var model    = new MarketSummarySchema(marketSummary);

    model.save(function(error) {
      if (error)
        deferred.reject(error);
      else
        deferred.resolve(model); // publish the hydrated model back to the client. it should have an id now.
    });

    return deferred.promise;
  }
};

module.exports = MarketSummaryModel;
