import { generateRandomInt, shuffleArray } from '../utils/random';
import { channels, emotes, servers, users } from './discord';

export const getRandomFromArray = <T extends unknown>(arr: T[]): T => {
  const randomIndex = generateRandomInt(0, arr.length - 1);
  return arr[randomIndex];
};

export const getNRandomFromArray = <T extends unknown>(arr: T[]): T[] => {
  const randomIndex = generateRandomInt(0, arr.length - 1);
  const shuffled = shuffleArray(arr);
  return shuffled.slice(0, randomIndex);
};

export const generateRandomEmotes = () => getNRandomFromArray(emotes);
export const generateRandomServers = () => getNRandomFromArray(servers);
export const generateRandomUsers = () => getNRandomFromArray(users);
export const generateRandomChannels = () => getNRandomFromArray(channels);
