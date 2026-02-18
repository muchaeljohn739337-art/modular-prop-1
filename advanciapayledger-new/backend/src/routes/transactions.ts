import { Router, Request, Response } from 'express';
import { store } from '../store';
import { authMiddleware, AuthRequest } from '../middleware/auth';
import { createTransactionValidation } from '../middleware/validate';

const router = Router();

// Get all transactions for user
router.get('/', authMiddleware, async (req: Request, res: Response) => {
  try {
    const userId = (req as AuthRequest).userId!;
    const { limit = 50, offset = 0, status, type } = req.query;

    const transactions = await store.findTransactionsByUser(userId, {
      status: status as string,
      type: type as string
    });

    const paginatedTxs = transactions.slice(Number(offset), Number(offset) + Number(limit));

    return res.json({
      transactions: paginatedTxs,
      pagination: {
        total: transactions.length,
        limit: Number(limit),
        offset: Number(offset)
      }
    });
  } catch (error: any) {
    console.error('Get transactions error:', error);
    return res.status(500).json({ error: 'Failed to retrieve transactions' });
  }
});

// Create new transaction
router.post('/', authMiddleware, createTransactionValidation, async (req: Request, res: Response) => {
  try {
    const userId = (req as AuthRequest).userId!;
    const { type, currency, amount, toAddress, metadata } = req.body;

    // Validate sufficient balance for send transactions
    if (type === 'send') {
      const wallet = await store.findWallet(userId, currency);
      if (!wallet || wallet.balance < amount) {
        return res.status(400).json({ error: 'Insufficient balance' });
      }
    }

    const transaction = await store.createTransaction({
      userId,
      type,
      currency: currency.toUpperCase(),
      amount,
      fee: amount * 0.01, // 1% fee
      toAddress,
      status: 'pending',
      metadata
    });

    // Update wallet balance (simplified)
    if (type === 'send') {
      const wallet = await store.findWallet(userId, currency);
      if (wallet) {
        await store.updateWalletBalance(wallet.id, -(amount + transaction.fee));
      }
    } else if (type === 'receive') {
      const wallet = await store.findWallet(userId, currency);
      if (wallet) {
        await store.updateWalletBalance(wallet.id, amount);
      }
    }

    // Simulate transaction completion after 2 seconds
    setTimeout(async () => {
      try {
        await store.updateTransaction(transaction.id, { status: 'completed' });
      } catch (err) {
        console.error('Failed to auto-complete transaction:', err);
      }
    }, 2000);

    return res.status(201).json({
      message: 'Transaction created successfully',
      transaction
    });
  } catch (error: any) {
    console.error('Create transaction error:', error);
    return res.status(500).json({ error: 'Failed to create transaction' });
  }
});

// Get transaction by ID
router.get('/:id', authMiddleware, async (req: Request, res: Response) => {
  try {
    const userId = (req as AuthRequest).userId!;
    const id = String((req.params as any).id);

    const transaction = await store.findTransactionById(id, userId);
    
    if (!transaction) {
      return res.status(404).json({ error: 'Transaction not found' });
    }

    return res.json({ transaction });
  } catch (error: any) {
    console.error('Get transaction error:', error);
    return res.status(500).json({ error: 'Failed to retrieve transaction' });
  }
});

export default router;
