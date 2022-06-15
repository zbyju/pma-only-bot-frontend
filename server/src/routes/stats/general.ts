import express from 'express';
import { generateGeneralStats } from '../../db/generateGeneral';
const router = express.Router();

router.get('/', (req, res) => {
  res.json(generateGeneralStats());
});

export default router;
