var Q             = require('q');
var MarketSummary = require('./schema');

var MarketSummaryModel = {
  get: function(individualKey) {
    var filter  = { userId: individualKey };
    var promise = Q.ninvoke(MarketSummary, 'findOne', filter);

    return promise;
  },

  save: function(marketSummary) {
    // we want validations triggered so will stick with traditional
    // save instead of findOneAndUpdate
    var that = this;

    return Q
            .ninvoke(MarketSummary, 'findOne', { userId: marketSummary.userId })
            .then(function(currentMarketSummary) {
              var doc;

              if (currentMarketSummary) {
                currentMarketSummary.preferences = marketSummary.preferences;

                doc = currentMarketSummary;
              }

              else
                doc = new MarketSummary(marketSummary);

              return that._save(doc);
           });
  },

  _save: function(doc) {
    var deferred = Q.defer();

    doc.save(function(error) {
      if (error)
        deferred.reject(error);
      else
        deferred.resolve(doc); // publish the hydrated model back to the client. it should have an id now.
    });

    return deferred.promise;
  }
};

module.exports = MarketSummaryModel;
