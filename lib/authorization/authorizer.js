var _    = require('lodash');
var User = require('../user');

module.exports = (function() {
  var authorizer = {
    authorize: function (whiteList) {
      var roles = User.current().roles;

      // we'll refactor to loadash later. want to practice
      // vanilla js from time to time. the old fashioned way.
      // the fact that we've got specs to cover our tracks
      // gives us the right to refactor at any given moment.
      for(var i = 0; i < roles.length; roles++) {
        for(var j = 0; j < whiteList.length; j++) {
          if (roles[i] == whiteList[j]) {
            return true;
          }
        }
      }

      return false;
    }
  };

  return authorizer;
}());
