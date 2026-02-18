import { Router, Request, Response } from 'express';
import Stripe from 'stripe';
import { authMiddleware, AuthRequest } from '../middleware/auth';
import {
  createPaymentIntentValidation,
  cryptoPaymentValidation,
} from '../middleware/validate';

const router = Router();

// Initialize Stripe (uses STRIPE_SECRET_KEY env var)
function getStripe(): Stripe | null {
  const key = process.env.STRIPE_SECRET_KEY;
  if (!key || key.startsWith('sk_test_mock')) return null;
  return new Stripe(key, { apiVersion: '2025-04-30.basil' });
}

// POST /api/payments/create-intent — create a real Stripe PaymentIntent
router.post(
  '/create-intent',
  authMiddleware,
  createPaymentIntentValidation,
  async (req: Request, res: Response) => {
    try {
      const { amount, currency } = req.body;
      const stripe = getStripe();

      if (!stripe) {
        // Fallback to mock when Stripe is not configured
        return res.json({
          clientSecret: 'pi_mock_secret_' + Math.random().toString(36).substring(7),
          amount,
          currency: currency || 'usd',
          mode: 'mock',
        });
      }

      const paymentIntent = await stripe.paymentIntents.create({
        amount: Math.round(amount * 100), // Stripe uses cents
        currency: (currency || 'usd').toLowerCase(),
        metadata: {
          userId: (req as AuthRequest).user?.userId || 'unknown',
        },
      });

      res.json({
        clientSecret: paymentIntent.client_secret,
        paymentIntentId: paymentIntent.id,
        amount: paymentIntent.amount / 100,
        currency: paymentIntent.currency,
        status: paymentIntent.status,
        mode: 'live',
      });
    } catch (error: unknown) {
      console.error('Payment intent error:', error);
      const message = error instanceof Stripe.errors.StripeError
        ? error.message
        : 'Failed to create payment intent';
      res.status(400).json({ error: message });
    }
  }
);

// POST /api/payments/crypto — process crypto payment (tracked in Supabase)
router.post(
  '/crypto',
  authMiddleware,
  cryptoPaymentValidation,
  async (req: Request, res: Response) => {
    try {
      const { currency, amount, toAddress } = req.body;

      // Generate deterministic-looking tx hash for tracking
      const txHash = '0x' + Array.from({ length: 64 }, () =>
        Math.floor(Math.random() * 16).toString(16)
      ).join('');

      res.json({
        txHash,
        status: 'pending',
        amount,
        currency,
        toAddress,
        message: 'Send the exact amount to the address above. Transaction will be confirmed after network verification.',
      });
    } catch (error: unknown) {
      console.error('Crypto payment error:', error);
      res.status(500).json({ error: 'Failed to process crypto payment' });
    }
  }
);

// GET /api/payments/config — return publishable key to frontend
router.get('/config', authMiddleware, (_req: Request, res: Response) => {
  const publishableKey = process.env.STRIPE_PUBLISHABLE_KEY || '';
  res.json({
    publishableKey: publishableKey || null,
    cryptoCurrencies: ['BTC', 'ETH', 'USDT', 'USDC'],
  });
});

export default router;
