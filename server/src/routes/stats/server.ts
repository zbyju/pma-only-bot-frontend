import express from 'express';
import { generateDayStats, generateDayStatsFrom } from '../../db/generateServerStats';

const router = express.Router();

router.get('/:serverId', (req, res) => {
  if (req.params.serverId?.length === 0) return res.status(400).send('No server ID provided.');
  const from = req.query.from?.toString() || new Date().toUTCString();
  res.json(generateDayStatsFrom(from, req.params.serverId));
});

export default router;
