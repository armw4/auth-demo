var mongoose = require('mongoose');
var Schema   = mongoose.Schema;

var schema = new Schema({
  userId: String,
  preferences: [String]
});

var MarketSummary = mongoose.model('MarketSummary', schema);

module.exports = MarketSummary;
