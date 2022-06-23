import express from 'express';
import passport from 'passport';
const router = express.Router();

router.get('/', passport.authenticate('discord'), (req, res) => {
  res.send(200);
});

router.get('/redirect', passport.authenticate('discord'), (req, res) => {
  return res.redirect('http://localhost:3000/');
});

export default router;
