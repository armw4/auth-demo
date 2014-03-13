mongoose = require('mongoose');
_        = require('lodash');

var mixin = {
  _defaults: {
    host: 'localhost',
    port: 27017,
    database: 'lux'
  },

  connect2: function(options) {
    localOptions = _.merge(this._defaults, options);

    var uri = 'mongodb://' + localOptions.host + ':' + localOptions.port + '/' + localOptions.database;

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
