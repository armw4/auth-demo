var Schema = mongoose.Schema;

var schema = new Schema({
  userId: String,
  preferences: [String]
});

var MarketSummarySchema = mongoose.model('MarketSummary', schema);

module.exports = MarketSummarySchema;
