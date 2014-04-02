
/**
 * Module dependencies.
 */

// business/domain layer config (no dependency on express/app)
require('./lib/config');

var express  = require('express');
var routes   = require('./routes');
var user     = require('./routes/user');
var http     = require('http');
var path     = require('path');
var mongoose = require('./lib/mongoose');

// node/express app config
var config   = require('./config/config');

var app = express();

config.load(app);

// all environments
app.set('port', process.env.PORT || 3000);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.json());
app.use(express.urlencoded());
app.use(express.methodOverride());
app.use(app.router);
app.use(express.static(path.join(__dirname, 'public')));

// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
}

app.get('/', routes.index);
app.get('/users', user.list);

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});

mongoose.connect2(app.get('connection'));

process.on('exit', function() {
  mongoose.disconnect();
});
