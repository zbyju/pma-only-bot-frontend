import express from 'express';
import passport from 'passport';
const router = express.Router();

router.get('/', passport.authenticate('discord'), (req, res) => {
  res.send(200);
});

router.get('/redirect', passport.authenticate('discord'), (req, res) => {
  return req.user
    ? res.send(req.user)
    : res.status(401).send({
        msg: 'Unauthorized',
      });
});

export default router;
