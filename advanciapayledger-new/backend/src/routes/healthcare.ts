import { Router, Request, Response } from 'express';
import { store } from '../store';
import { authMiddleware, AuthRequest } from '../middleware/auth';
import { createSubscriptionValidation } from '../middleware/validate';

const router = Router();

// Get user's healthcare subscriptions
router.get('/subscriptions', authMiddleware, async (req: Request, res: Response) => {
  try {
    const userId = (req as AuthRequest).userId!;
    const subscriptions = await store.findHealthcareByUser(userId);
    
    return res.json({ subscriptions });
  } catch (error: any) {
    console.error('Get subscriptions error:', error);
    return res.status(500).json({ error: 'Failed to retrieve subscriptions' });
  }
});

// Create healthcare subscription
router.post('/subscriptions', authMiddleware, createSubscriptionValidation, async (req: Request, res: Response) => {
  try {
    const userId = (req as AuthRequest).userId!;
    const { plan, provider, monthlyPremium, dependents } = req.body;

    const startDate = new Date();
    const renewalDate = new Date();
    renewalDate.setFullYear(renewalDate.getFullYear() + 1);

    const subscription = await store.createHealthcare({
      userId,
      plan,
      provider,
      monthlyPremium,
      dependents: dependents || 0,
      startDate,
      renewalDate,
      status: 'active'
    });

    return res.status(201).json({
      message: 'Healthcare subscription created successfully',
      subscription
    });
  } catch (error: any) {
    console.error('Create subscription error:', error);
    return res.status(500).json({ error: 'Failed to create subscription' });
  }
});

// Get available plans
router.get('/plans', async (_req: Request, res: Response) => {
  try {
    const plans = [
      {
        id: 'basic',
        name: 'Basic',
        monthlyPremium: 99,
        coverage: ['Basic medical', 'Emergency care', 'Prescription drugs'],
        dependents: 0
      },
      {
        id: 'premium',
        name: 'Premium',
        monthlyPremium: 199,
        coverage: ['Comprehensive medical', 'Dental', 'Vision', 'Mental health'],
        dependents: 0
      },
      {
        id: 'family',
        name: 'Family',
        monthlyPremium: 349,
        coverage: ['Full family coverage', 'Dental', 'Vision', 'Pediatric care'],
        dependents: 4
      },
      {
        id: 'enterprise',
        name: 'Enterprise',
        monthlyPremium: 599,
        coverage: ['Premium for all employees', 'Customizable', 'Wellness programs'],
        dependents: 10
      }
    ];

    return res.json({ plans });
  } catch (error: any) {
    console.error('Get plans error:', error);
    return res.status(500).json({ error: 'Failed to retrieve plans' });
  }
});

export default router;
