import { ServerId } from '../types/discord.types';
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

export function generateDayStatsFrom(from: string, serverId: ServerId = generateRandomId()): DayStats[] {
  const dates = getArrayOfDatesFrom(new Date(from));
  return dates.map((d) => generateDayStats(d.toString(), serverId));
}

export function generateDayStats(date: string, serverId: ServerId = generateRandomId()): DayStats {
  return {
    serverId,
    date,
    perUser: generateStatsPerUserPerDay(),
    server: generateServerStatsPerDay(),
  };
}

export function generateServerStatsPerDay(): ServerStatsPerDay {
  let count = 0;
  const perChannel: StatsPerChannel[] = generateNRandomId(generateRandomInt(1, 5)).map((channelId) => {
    const c = generateRandomInt(10, 1000);
    count += c;
    return {
      channelId,
      count: c,
    };
  });
  return {
    perChannel,
    count,
  };
}

export function generateStatsPerUserPerDay(): StatsPerUserPerDay[] {
  const users = generateNRandomId(generateRandomInt(2, 10)).map((u) => {
    return {
      user: u,
      emotes: generateEmoteCount(),
      channels: generateChannelCount(),
    };
  });
  return users;
}

export function generateEmoteCount(): EmoteCount[] {
  return generateNRandomId(generateRandomInt(1, 25)).map((emoteId) => {
    return {
      emoteId,
      count: generateRandomInt(1, 200),
    };
  });
}

export function generateChannelCount(): ChannelCount[] {
  return generateNRandomId(generateRandomInt(1, 25)).map((channelId) => {
    return {
      channelId,
      count: generateRandomInt(1, 200),
    };
  });
}
