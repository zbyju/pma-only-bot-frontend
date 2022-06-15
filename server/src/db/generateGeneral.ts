import { GeneralStats } from '../types/stats/general.types';
import { generateRandomInt } from '../utils/random';

export function generateGeneralStats(): GeneralStats {
  const servers = generateRandomInt(0, 50);
  return {
    counts: {
      servers,
      channels: servers * generateRandomInt(1, 15),
      users: servers * generateRandomInt(1, 60),
      messages: servers * generateRandomInt(1000, 1000000),
      emotes: servers * generateRandomInt(50, 50000),
    },
  };
}
