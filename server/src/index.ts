import express from 'express';

const app = express();

// Routes
const apiPrefix = '/v1/';

const generalStats = require('./routes/stats/general');
const serverStats = require('./routes/stats/server');
const userStats = require('./routes/stats/user');

app.use(apiPrefix + 'stats/general', generalStats);
app.use(apiPrefix + 'stats/server', serverStats);
app.use(apiPrefix + 'stats/user', userStats);

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log('Listening on port: ' + port);
});
