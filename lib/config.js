var config = {
  _storage: {},

  get: function(key) {
    return this._storage[key];
  },

  set: function(key, value) {
    this._storage[key] = value;
  }
};

config.set('market-summary-defaults', ['State Street Bank', 'S1', 'S2']);

global.config = config;
