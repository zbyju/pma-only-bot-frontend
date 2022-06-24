import { Channel, ServerId } from '../types/discord.types';
import {
  ChannelCount,
  DayStats,
  EmoteCount,
  ServerStatsPerDay,
  StatsPerChannel,
  StatsPerUserPerDay,
} from '../types/stats/server.types';
import { getArrayOfDatesFrom } from '../utils/dates';
import { generateNRandomId, generateRandomId, generateRandomInt } from '../utils/random';
import { servers } from './discord';
import {
  generateRandomChannels,
  generateRandomEmotes,
  generateRandomUsers,
  getRandomFromArray,
} from './generateDiscord';

export function generateDayStatsFrom(from: string, serverId: ServerId = generateRandomId()): DayStats[] {
  const dates = getArrayOfDatesFrom(new Date(from));
  return dates.map((d) => generateDayStats(d.toString(), serverId));
}

export function generateDayStats(date: string, serverId: ServerId = generateRandomId()): DayStats {
  const randomServer = getRandomFromArray(servers);
  return {
    server: {
      serverId,
      name: randomServer.name,
    },
    date,
    perUser: generateStatsPerUserPerDay(),
    serverStats: generateServerStatsPerDay(),
  };
}

export function generateServerStatsPerDay(): ServerStatsPerDay {
  let count = 0;
  const perChannel: StatsPerChannel[] = generateRandomChannels().map((channel) => {
    const c = generateRandomInt(10, 1000);
    count += c;
    return {
      channel,
      count: c,
    };
  });
  return {
    perChannel,
    count,
  };
}

export function generateStatsPerUserPerDay(): StatsPerUserPerDay[] {
  const users = generateRandomUsers().map((user) => {
    return {
      user,
      emotes: generateEmoteCount(),
      channels: generateChannelCount(),
    };
  });
  return users;
}

export function generateEmoteCount(): EmoteCount[] {
  return generateRandomEmotes().map((emote) => {
    return {
      emote,
      count: generateRandomInt(1, 200),
    };
  });
}

export function generateChannelCount(): ChannelCount[] {
  return generateRandomChannels().map((channel) => {
    return {
      channel,
      count: generateRandomInt(1, 200),
    };
  });
}
