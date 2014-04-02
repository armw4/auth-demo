var child_process = require('child_process');

child_process.spawn('mongod', null, { stdio: 'inherit' });
