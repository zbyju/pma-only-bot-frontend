export type ServerId = string;
export type ChannelId = string;
export type EmoteId = string;
export type UserId = string;

export interface DayStats extends DayStatsHeaders {
  perUser: StatsPerUserPerDay[];
  server: ServerStatsPerDay;
}

export interface DayStatsHeaders {
  serverId: ServerId;
  date: string;
}

export interface ServerStatsPerDay {
  perChannel: StatsPerChannel[];
  count: number;
}

export interface StatsPerChannel {
  channelId: ChannelId;
  count: number;
}

export interface StatsPerUserPerDay {
  user: UserId;
  emotes: EmoteCount[];
  channels: ChannelCount[];
}

export interface EmoteCount {
  emoteId: EmoteId;
  count: number;
}

export interface ChannelCount {
  channelId: ChannelId;
  count: number;
}
