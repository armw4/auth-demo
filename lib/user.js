// NOTE: this should be exported as a global in the
// node app (app.js). jasmine will automagically export
// it as such due to the helpers directory.
//
// https://github.com/mhevery/jasmine-node/blob/abfe06a684c00091b24b4918192920c5534b95c2/lib/jasmine-node/index.js#L66
//
// global.User = require('./relative/path/to/user');
module.exports = {
  current: function() {
    return { roles: [] };
  }
};
