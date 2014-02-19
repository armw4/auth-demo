var Q = require('q');

module.exports = (function() {
  var mixin = {
    connect: function() {
      // FIXME: read host, port, database, etc. from express app configuration
      this.connect({
        host: 'localhost',
        database: 'lux'
      });
    },

    disconnect: function() {
      var deferred = Q.defer();

      this.connection.close(function() {
        deferred.resolve();
      });

      return deferred;
    }
  };

  return mixin;
}());
