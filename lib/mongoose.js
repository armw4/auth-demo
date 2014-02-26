mongoose = require('mongoose');

// NOTE: this should be exported as a global in the
// node app (app.js). jasmine will automatically export
// it as such due to the helpers directory.
//
// https://github.com/mhevery/jasmine-node/blob/abfe06a684c00091b24b4918192920c5534b95c2/lib/jasmine-node/index.js#L66/
//
// global.mongoose = require('./relative/path/to/mongoose');
module.exports = (function() {
  // FIXME: read host, port, database, etc. from express app configuration
  // (or some environment based config).
  var host = 'localhost';
  var port = 27017;
  var database = 'lux';
  var uri = 'mongodb://' + host + ':' + port + '/' + database;

  mongoose.connect(uri);

  // convenience key just in case we need to access this guy.
  mongoose.uri = uri;

  return mongoose;
}());
