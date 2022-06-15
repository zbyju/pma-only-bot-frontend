import express from 'express';
import { generateDayStats } from '../../db/generateServerStats';

const router = express.Router();

router.get('/:serverId', (req, res) => {
  if (req.params.serverId?.length === 0) return res.status(400).send('No server ID provided.');
  const date = req.query.date?.toString() || new Date().toUTCString();
  res.json(generateDayStats(date, req.params.serverId));
});

export default router;
