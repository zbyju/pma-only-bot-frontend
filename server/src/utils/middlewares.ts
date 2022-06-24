import { NextFunction, Request, Response } from 'express';

export const isAuthenticated = (req: Request, res: Response, next: NextFunction) => {
  return req.user ? next() : res.status(403).send('Unauthorized');
};
