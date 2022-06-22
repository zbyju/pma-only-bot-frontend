import { Profile, Strategy } from 'passport-discord';
import passport from 'passport';
import { VerifyCallback } from 'passport-oauth2';

passport.use(
  new Strategy(
    {
      clientID: process.env.DISCORD_CLIENT_ID!,
      clientSecret: process.env.DISCORD_SECRET!,
      callbackURL: process.env.DISCORD_CALLBACK_REDIRECT,
      scope: ['identify', 'guilds'],
    },
    async (accessToken: string, refreshToken: string, profile: Profile, done: VerifyCallback) => {
      console.log(accessToken);
      console.log(refreshToken);
      console.log(profile);
    },
  ),
);
