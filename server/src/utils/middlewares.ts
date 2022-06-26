import { NextFunction, Request, Response } from 'express';

export const isAuthenticatedMiddleware = (req: Request, res: Response, next: NextFunction) => {
  return isAuthenticated(req) ? next() : res.status(403).send('Unauthorized');
};

export const isAuthenticated = (req: Request): boolean => {
  return req.user ? true : false;
};
