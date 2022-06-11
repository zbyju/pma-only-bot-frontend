import express from 'express';

//Route files
import generalStatsRoute from './routes/stats/general';
import serverStatsRoute from './routes/stats/server';

const app = express();

// Routes
const apiPrefix = '/v1/';

app.use(apiPrefix + 'stats/general', generalStatsRoute);
app.use(apiPrefix + 'stats/server', serverStatsRoute);

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log('Listening on port: ' + port);
});
