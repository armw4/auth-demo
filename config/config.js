var fs   = require('fs');
var path = require('path');

module.exports = {
  load: function (app) {
    // mongo env may differ from app env, hence the separate configuration
    this._load('app', app);
    this._load('mongo', app, process.env.LUX_ENV);
  },

  _load: function(type, app, env) {
    var targetEnv = env || app.get('env');
    var configPath = path.join(__dirname, type, targetEnv);

    if (fs.existsSync(configPath + '.js')) {
      var configuration = require(configPath);

      configuration.call(app);

      console.log('Loaded "%s" %s configuration.', targetEnv, type);
    }
  }
};
