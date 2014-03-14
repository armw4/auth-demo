module.exports = function(app) {
  app.set('connection', {
    host: 'vavt-mongo-comp',
    database: 'lux-test'
  });
};
