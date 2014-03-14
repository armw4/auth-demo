var mongoose = require('../mongoose');
var Schema   = mongoose.Schema;

var schema = new Schema({
  // likely need to create an index for this guy
  // so we don't scan all documents when querying
  userId: { type: String, required: true },
  preferences: { type: [String], required: true }
});

schema.path('preferences').validate(function(value) {
  return value && value.length < 5;
});

var MarketSummary = mongoose.model('MarketSummary', schema);

module.exports = MarketSummary;
