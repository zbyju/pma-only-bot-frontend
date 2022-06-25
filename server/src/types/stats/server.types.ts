import { Channel, ChannelId, Emote, Server, User } from '../discord.types';

export interface ServerStats {
  stats: DayStats[]
}

export interface DayStats extends DayStatsHeaders {
  perUser: StatsPerUserPerDay[];
  serverStats: ServerStatsPerDay;
}

export interface DayStatsHeaders {
  server: Server;
  date: string;
}

export interface ServerStatsPerDay {
  perChannel: StatsPerChannel[];
  count: number;
}

export interface StatsPerChannel {
  channel: Channel;
  count: number;
}

export interface StatsPerUserPerDay {
  user: User;
  emotes: EmoteCount[];
  channels: ChannelCount[];
}

export interface EmoteCount {
  emote: Emote;
  count: number;
}

export interface ChannelCount {
  channel: Channel;
  count: number;
}
