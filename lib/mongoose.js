mongoose = require('mongoose');
_        = require('lodash');

var mixin = {
  connect2: function() {
    // FIXME: read host, port, database, etc. from grunt config
    // accept config hash and set sensible defaults

    var host = 'localhost';
    var port = 27017;
    var database = 'lux';
    var uri = 'mongodb://' + host + ':' + port + '/' + database;

    // the event loop will block until we call disconnect. just an FYI.
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

    // convenience key just in case we need to access this guy.
    this.uri = uri;
  }
};

module.exports = _.extend(mongoose, mixin);
