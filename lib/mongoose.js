mongoose = require('mongoose');
_        = require('lodash');

// NOTE: this should be exported as a global in the
// node app (app.js). jasmine will automatically export
// it as such due to the helpers directory.
//
// https://github.com/mhevery/jasmine-node/blob/abfe06a684c00091b24b4918192920c5534b95c2/lib/jasmine-node/index.js#L66/
//
// global.mongoose = require('./relative/path/to/mongoose');
var mixin = {
  connect2: function() {
    // FIXME: read host, port, database, etc. from express app configuration
    // (or some environment based config).
    var host = 'localhost';
    var port = 27017;
    var database = 'lux';
    var uri = 'mongodb://' + host + ':' + port + '/' + database;

    this.connect(uri);

    mongoose.connection.on('connected', function () {
      console.log('Established connection to %s.', uri);
    });

    mongoose.connection.on('error',function (err) {
      console.log('Encountered error while connecting to %s.\n%s', uri, err);
    });

    mongoose.connection.on('disconnected', function () {
      console.log('Disconnected from %s.', uri);
    });
    //
    // convenience key just in case we need to access this guy.
    this.uri = uri;
  }
};

module.exports = _.extend(mongoose, mixin);
