export type ServerId = string;
export type ChannelId = string;
export type EmoteId = string;
export type UserId = string;

export interface Server {
  serverId: string;
  name: string;
}

export interface Emote {
  emoteId: EmoteId;
  name: string;
  url: string;
}

export interface User {
  userId: UserId;
  name: string;
}

export interface Channel {
  channelId: ChannelId;
  name: string;
}
