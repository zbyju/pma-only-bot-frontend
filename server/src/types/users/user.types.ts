export interface User {
  id: string;
  accessToken: string;
  refreshToken: string;
  username: string;
  avatar?: string;
  guilds?: Guild[];
}

export interface Guild {
  id: string;
  name: string;
  icon: string;
}
