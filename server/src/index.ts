import express from 'express';
import session from 'express-session';
import passport from 'passport';
import { userDb } from './db/users';
import 'dotenv/config';
require('./strategies/discord');

//Route files
import generalStatsRoute from './routes/stats/general';
import serverStatsRoute from './routes/stats/server';
import discordRoute from './routes/auth/discord';

const app = express();

// Database
export const db = userDb();

// Express Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(
  session({
    secret: process.env.SESSION_SECRET,
    resave: false,
    saveUninitialized: false,
    cookie: {
      maxAge: 1000 * 60 * 24 * 7,
    },
  }),
);

app.use(passport.initialize());
app.use(passport.session());

// Routes
const apiPrefix = '/api/v1';

app.use(apiPrefix + '/stats/general', generalStatsRoute);
app.use(apiPrefix + '/stats/server', serverStatsRoute);
app.use(apiPrefix + '/auth/discord', discordRoute);

const port = process.env.PORT || 3001;
app.listen(port, () => {
  console.log('Listening on port: ' + port);
});
