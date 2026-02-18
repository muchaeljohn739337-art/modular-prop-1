import { body, validationResult } from 'express-validator';
import { Request, Response, NextFunction } from 'express';

// ── Shared validation result handler ───────────────────────────────
export function handleValidation(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({
      error: 'Validation failed',
      details: errors.array().map((e) => ({
        field: (e as any).path || (e as any).param,
        message: e.msg,
      })),
    });
  }
  return next();
}

// ── Auth validators ────────────────────────────────────────────────
export const registerValidation = [
  body('email')
    .isEmail()
    .withMessage('Valid email is required')
    .normalizeEmail(),
  body('password')
    .isLength({ min: 8 })
    .withMessage('Password must be at least 8 characters')
    .matches(/[A-Z]/)
    .withMessage('Password must contain an uppercase letter')
    .matches(/[0-9]/)
    .withMessage('Password must contain a number'),
  body('firstName')
    .trim()
    .notEmpty()
    .withMessage('First name is required')
    .isLength({ max: 50 })
    .withMessage('First name too long'),
  body('lastName')
    .trim()
    .notEmpty()
    .withMessage('Last name is required')
    .isLength({ max: 50 })
    .withMessage('Last name too long'),
  body('phoneNumber')
    .optional()
    .isMobilePhone('any')
    .withMessage('Invalid phone number'),
  handleValidation,
];

export const loginValidation = [
  body('email')
    .isEmail()
    .withMessage('Valid email is required')
    .normalizeEmail(),
  body('password')
    .notEmpty()
    .withMessage('Password is required'),
  handleValidation,
];

// ── Wallet validators ──────────────────────────────────────────────
export const createWalletValidation = [
  body('type')
    .trim()
    .notEmpty()
    .withMessage('Wallet type is required')
    .isIn(['crypto', 'fiat', 'custodial'])
    .withMessage('Invalid wallet type'),
  body('currency')
    .trim()
    .notEmpty()
    .withMessage('Currency is required')
    .isLength({ min: 2, max: 10 })
    .withMessage('Invalid currency code'),
  body('address')
    .optional()
    .trim()
    .isLength({ max: 200 }),
  handleValidation,
];

// ── Transaction validators ─────────────────────────────────────────
export const createTransactionValidation = [
  body('type')
    .trim()
    .notEmpty()
    .withMessage('Transaction type is required')
    .isIn(['send', 'receive', 'swap', 'payment'])
    .withMessage('Invalid transaction type'),
  body('currency')
    .trim()
    .notEmpty()
    .withMessage('Currency is required'),
  body('amount')
    .isFloat({ gt: 0 })
    .withMessage('Amount must be a positive number'),
  body('toAddress')
    .optional()
    .trim()
    .isLength({ max: 200 }),
  body('metadata')
    .optional()
    .isObject()
    .withMessage('Metadata must be an object'),
  handleValidation,
];

// ── Healthcare validators ──────────────────────────────────────────
export const createSubscriptionValidation = [
  body('plan')
    .trim()
    .notEmpty()
    .withMessage('Plan is required')
    .isIn(['basic', 'premium', 'family', 'enterprise'])
    .withMessage('Invalid plan'),
  body('provider')
    .trim()
    .notEmpty()
    .withMessage('Provider is required')
    .isLength({ max: 100 }),
  body('monthlyPremium')
    .isFloat({ gt: 0 })
    .withMessage('Monthly premium must be a positive number'),
  body('dependents')
    .optional()
    .isInt({ min: 0, max: 20 })
    .withMessage('Dependents must be 0-20'),
  handleValidation,
];

// ── Payment validators ─────────────────────────────────────────────
export const createPaymentIntentValidation = [
  body('amount')
    .isFloat({ gt: 0 })
    .withMessage('Amount must be a positive number'),
  body('currency')
    .optional()
    .trim()
    .isLength({ min: 2, max: 10 }),
  handleValidation,
];

export const cryptoPaymentValidation = [
  body('currency')
    .trim()
    .notEmpty()
    .withMessage('Currency is required'),
  body('amount')
    .isFloat({ gt: 0 })
    .withMessage('Amount must be a positive number'),
  body('toAddress')
    .trim()
    .notEmpty()
    .withMessage('Destination address is required'),
  handleValidation,
];

// ── User profile validators ────────────────────────────────────────
export const updateProfileValidation = [
  body('firstName')
    .optional()
    .trim()
    .isLength({ min: 1, max: 50 })
    .withMessage('Invalid first name'),
  body('lastName')
    .optional()
    .trim()
    .isLength({ min: 1, max: 50 })
    .withMessage('Invalid last name'),
  body('phoneNumber')
    .optional()
    .isMobilePhone('any')
    .withMessage('Invalid phone number'),
  body('avatar')
    .optional()
    .isURL()
    .withMessage('Avatar must be a valid URL'),
  handleValidation,
];
