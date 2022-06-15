import {
  ChannelCount,
  DayStats,
  EmoteCount,
  ServerId,
  ServerStatsPerDay,
  StatsPerChannel,
  StatsPerUserPerDay,
} from '../types/stats/server.types';
import { generateNRandomId, generateRandomId, generateRandomInt } from '../utils/random';

export function generateDayStats(date: Date, serverId: ServerId = generateRandomId()): DayStats {
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
