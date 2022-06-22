import { User } from '../types/users/user.types';

export function userDb() {
  const db: User[] = [];
  return {
    addUser(user: User): void {
      db.push(user);
    },
    getUser(userId: string): User | undefined {
      return db.find((u) => u.id === userId);
    },
    getAll(): User[] {
      return db;
    },
    getUserAndUpdate(user: User): User | undefined {
      for (let i = 0; i < db.length; ++i) {
        if (db[i].id === user.id) {
          db[i] = user;
          return db[i];
        }
      }
      return undefined;
    },
  };
}
