var MarketSummary = require('../lib/market-summary/market-summary');

module.exports = function(app) {
  app.get('/market-summary', function(req, res, next) {
    MarketSummary
    .get('21EC2020-3AEA-4069-A2DD-08002B30309D')
    .then(function(marketSummary) {
      res.json(marketSummary);
    })
    .fail(function(error) {
      // push error through rest of middleware stack so it
      // can be handled and or logged.
      next(error);
    });
  });
};
