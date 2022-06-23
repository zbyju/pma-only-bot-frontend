# Server

This server is providing mock data for the client to display to the user. It also serves as a middleware for Discord OAuth.

## Init

Before you can run the server you need to set some env values. Easiest way to do so is to copy the `.env.example` file and save it in the same directory (root dir of the server) with the name `.env`.

Then you need to set the `DISCORD_CLIENT_ID` and `DISCORD_SECRET` values.

## Commands

### Before running anything

After setting the env variables you can run this command to install all the dependencies.

```
yarn install
```

### Start dev server

```
yarn dev
```

### Build for production

```
yarn build
```
