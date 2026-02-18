import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';

// ── JWT configuration ──────────────────────────────────────────────
function getJwtSecret(): string {
  const secret = process.env.JWT_SECRET;
  if (!secret) {
    throw new Error(
      'FATAL: JWT_SECRET environment variable is not set. ' +
        'Refusing to start with an insecure default.'
    );
  }
  return secret;
}

export function getJwtExpiresIn(): string {
  return process.env.JWT_EXPIRES_IN || '7d';
}

export { getJwtSecret };

// ── Typed request with user info ───────────────────────────────────
export interface AuthRequest extends Request {
  userId?: string;
  userEmail?: string;
}

// ── Auth middleware – verifies JWT, attaches userId ────────────────
export function authMiddleware(
  req: Request,
  res: Response,
  next: NextFunction
) {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'No authorization header' });
    }

    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, getJwtSecret()) as {
      userId: string;
      email: string;
    };

    (req as AuthRequest).userId = decoded.userId;
    (req as AuthRequest).userEmail = decoded.email;
    return next();
  } catch (error) {
    return res.status(401).json({ error: 'Invalid or expired token' });
  }
}

// ── Admin middleware – checks email against allow-list ─────────────
function getAdminEmails(): string[] {
  const raw = process.env.ADMIN_EMAILS || process.env.ADMIN_EMAIL || '';
  const list = raw
    .split(',')
    .map((s) => s.trim().toLowerCase())
    .filter(Boolean);
  return list.length > 0 ? list : ['admin@advanciapayledger.com'];
}

export function adminMiddleware(
  req: Request,
  res: Response,
  next: NextFunction
) {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'No authorization header' });
    }

    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, getJwtSecret()) as {
      userId: string;
      email: string;
    };

    const email = (decoded.email || '').toLowerCase();
    const admins = getAdminEmails();

    if (!email || !admins.includes(email)) {
      return res.status(403).json({ error: 'Not authorized' });
    }

    (req as AuthRequest).userId = decoded.userId;
    (req as AuthRequest).userEmail = email;
    return next();
  } catch (_err) {
    return res.status(401).json({ error: 'Invalid or expired token' });
  }
}
