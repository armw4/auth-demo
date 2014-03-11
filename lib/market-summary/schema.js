var Schema = mongoose.Schema;

var schema = new Schema({
  userId: { type: String, required: true },
  preferences: { type: [String], required: true }
});

schema.path('preferences').validate(function(value) {
  return value && value.length < 4;
});

var MarketSummarySchema = mongoose.model('MarketSummary', schema);

module.exports = MarketSummarySchema;
