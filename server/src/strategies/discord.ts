import { Profile, Strategy } from 'passport-discord';
import passport from 'passport';
import { VerifyCallback } from 'passport-oauth2';
import { db } from '../index';
import { User } from '../types/users/user.types';

passport.serializeUser((user: User, done) => {
  return done(null, user.id);
});

passport.deserializeUser((id: string, done) => {
  const user = db.getUser(id);
  user ? done(null, user) : done(null, null);
});

passport.use(
  new Strategy(
    {
      clientID: process.env.DISCORD_CLIENT_ID!,
      clientSecret: process.env.DISCORD_SECRET!,
      callbackURL: process.env.DISCORD_CALLBACK_REDIRECT,
      scope: ['identify', 'guilds'],
    },
    async (accessToken: string, refreshToken: string, profile: Profile, done: VerifyCallback) => {
      const user = { ...profile, accessToken, refreshToken };
      const existingUser = db.getUserAndUpdate(user);
      if (existingUser) return done(null, existingUser);
      db.addUser(user);
      return done(null, user);
    },
  ),
);
