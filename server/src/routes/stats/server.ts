import express from 'express';

// Route files
import userRoute from './user';

const router = express.Router();

// Nested user route
router.use('/:serverId/user', userRoute);

router.get('/', (req, res) => {
  res.send('Hello from server');
});

export default router;
