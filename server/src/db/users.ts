import { User } from '../types/users/user.types';

export function userDb() {
  const db: User[] = [];
  return {
    addUser(user: User) {
      db.push(user);
    },
    getUser(userId: string) {
      return db.find((u) => u.id === userId);
    },
    getAll() {
      return db;
    },
  };
}
