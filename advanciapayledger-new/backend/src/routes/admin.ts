import { Router, Request, Response } from 'express';
import { store } from '../store';
import { adminMiddleware } from '../middleware/auth';

const router = Router();

router.get('/users', adminMiddleware, async (_req: Request, res: Response) => {
  try {
    const users = await store.listUsers();
    return res.json({ users });
  } catch (err) {
    console.error('List users failed:', err);
    return res.status(500).json({ error: 'Failed to list users' });
  }
});

export default router;
