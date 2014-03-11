var Schema = mongoose.Schema;

var schema = new Schema({
  userId: { type: String, required: true },
  preferences: { type: [String], required: true }
});

var MarketSummarySchema = mongoose.model('MarketSummary', schema);

module.exports = MarketSummarySchema;
