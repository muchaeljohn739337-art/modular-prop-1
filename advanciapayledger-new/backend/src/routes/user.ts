import { Router, Request, Response } from 'express';
import { store } from '../store';
import { authMiddleware, AuthRequest } from '../middleware/auth';
import { updateProfileValidation } from '../middleware/validate';

const router = Router();

// Update user profile
router.put('/profile', authMiddleware, updateProfileValidation, async (req: Request, res: Response) => {
  try {
    const userId = (req as AuthRequest).userId!;
    const { firstName, lastName, phoneNumber, avatar } = req.body;

    const user = await store.updateUser(userId, { 
      firstName, 
      lastName, 
      phoneNumber, 
      avatar 
    });

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    return res.json({
      message: 'Profile updated successfully',
      user: {
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        phoneNumber: user.phoneNumber,
        avatar: user.avatar
      }
    });
  } catch (error: any) {
    console.error('Update profile error:', error);
    return res.status(500).json({ error: 'Failed to update profile' });
  }
});

export default router;
