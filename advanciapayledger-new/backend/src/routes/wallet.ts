import { Router, Request, Response } from 'express';
import { store } from '../store';
import { authMiddleware, AuthRequest } from '../middleware/auth';
import { createWalletValidation } from '../middleware/validate';

const router = Router();

// Get all wallets for user
router.get('/', authMiddleware, async (req: Request, res: Response) => {
  try {
    const userId = (req as AuthRequest).userId!;
    const wallets = await store.findWalletsByUser(userId);
    
    return res.json({ wallets });
  } catch (error: any) {
    console.error('Get wallets error:', error);
    return res.status(500).json({ error: 'Failed to retrieve wallets' });
  }
});

// Create new wallet
router.post('/', authMiddleware, createWalletValidation, async (req: Request, res: Response) => {
  try {
    const userId = (req as AuthRequest).userId!;
    const { type, currency, address } = req.body;

    // Check if wallet already exists
    const existingWallet = await store.findWallet(userId, currency);
    if (existingWallet) {
      return res.status(409).json({ error: 'Wallet already exists for this currency' });
    }

    const wallet = await store.createWallet({
      userId,
      type,
      currency: currency.toUpperCase(),
      address,
      balance: 0
    });

    return res.status(201).json({
      message: 'Wallet created successfully',
      wallet
    });
  } catch (error: any) {
    console.error('Create wallet error:', error);
    return res.status(500).json({ error: 'Failed to create wallet' });
  }
});

// Get wallet balance
router.get('/:currency', authMiddleware, async (req: Request, res: Response) => {
  try {
    const userId = (req as AuthRequest).userId!;
    const currency = String((req.params as any).currency);

    const wallet = await store.findWallet(userId, currency.toUpperCase());
    
    if (!wallet) {
      return res.status(404).json({ error: 'Wallet not found' });
    }

    return res.json({ 
      currency: wallet.currency,
      balance: wallet.balance,
      type: wallet.type,
      address: wallet.address
    });
  } catch (error: any) {
    console.error('Get wallet balance error:', error);
    return res.status(500).json({ error: 'Failed to retrieve wallet balance' });
  }
});

export default router;
