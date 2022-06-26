import express from 'express';
import passport from 'passport';
import { isAuthenticated } from '../../utils/middlewares';
const router = express.Router();

router.get('/', passport.authenticate('discord'), (req, res) => {
  res.send(200);
});

router.get('/redirect', passport.authenticate('discord'), (req, res) => {
  return res.redirect('http://localhost:3000/');
});

router.get('/status', (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', 'http://localhost:3000');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
  res.setHeader('Access-Control-Allow-Credentials', 'true');
  res.json({ isAuthenticated: isAuthenticated(req) });
});

export default router;
