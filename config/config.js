var fs   = require('fs');
var path = require('path');

module.exports = {
  load: function (app) {
    // mongo env may differ from app env, hence the separate configuration
    var appConfigpath   = path.join(__dirname, app.get('env'));
    var mongoConfigPath = path.join(__dirname, 'mongo', process.env.MONGO_ENV);

    console.log(mongoConfigPath);

    this._load('app', app.get('env'), appConfigpath, app);
    this._load('mongo', process.env.MONGO_ENV, mongoConfigPath, app);
  },

  _load: function(type, env, configPath, app) {
    if (fs.existsSync(configPath + '.js')) {
      console.log('Loading %s %s configuration.', env, type);

      var configuration = require(configPath);

      configuration(app);
    }
  }
};
