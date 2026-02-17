# Advancia PayLedger

A full-stack cryptocurrency payment and healthcare management platform with Web3 wallet integration, built with Next.js and Express.

**Live:** [advanciapayledger-new.vercel.app](https://advanciapayledger-new.vercel.app)

---

## Tech Stack

| Layer | Technologies |
|-------|-------------|
| **Frontend** | Next.js 16 (App Router), React 18, TypeScript, Tailwind CSS, Framer Motion, Zustand, Recharts |
| **Backend** | Express 4, TypeScript, JWT auth, Helmet, bcrypt, rate limiting |
| **Web3** | ethers.js v6 (browser wallet connection) |
| **Database** | In-memory store (default) / Supabase (optional persistence) |
| **CI/CD** | GitHub Actions → Vercel |

## Features

- **Dashboard** — User profile, crypto balances (BTC, ETH, USDT)
- **Authentication** — Email/password (JWT) + Supabase auth + Web3 wallet connect
- **Admin Panel** — Email-whitelist admin access, user management
- **Crypto Wallets** — Create/manage wallets, transactions
- **Healthcare** — Subscription plans (basic, premium, family, enterprise)
- **Payments** — Payment intents, crypto payments
- **API Proxy** — Next.js catch-all route proxies to Express backend (no CORS issues)

## Project Structure

```
advanciapayledger-new/
├── frontend/          # Next.js app (deployed to Vercel)
│   ├── app/
│   │   ├── dashboard/ # Main dashboard page
│   │   ├── admin/     # Admin panel
│   │   ├── about/     # About page
│   │   ├── api/       # Catch-all proxy to backend
│   │   └── lib/       # Auth, API client, Supabase
│   └── package.json
├── backend/           # Express API server
│   ├── src/
│   │   ├── routes/    # Auth, wallet, transactions, healthcare, payments
│   │   ├── store.ts   # In-memory data store
│   │   └── server.ts  # Entry point
│   └── package.json
├── database/          # Supabase schema & linter
└── vercel.json        # Vercel config with security headers
```

## Getting Started

### Frontend

```bash
cd advanciapayledger-new/frontend
npm install
npm run dev
```

### Backend

```bash
cd advanciapayledger-new/backend
npm install
npm run dev
```

The backend runs on `http://localhost:4000` by default. The frontend API proxy forwards `/api/*` requests to it.

## Environment Variables

### Frontend (Vercel)

| Variable | Required | Description |
|----------|----------|-------------|
| `NEXT_PUBLIC_API_URL` | Yes | Backend API base URL |
| `NEXT_PUBLIC_SUPABASE_URL` | No | Supabase project URL |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | No | Supabase anonymous key |
| `NEXT_PUBLIC_ADMIN_EMAILS` | No | Comma-separated admin emails |

### Backend

| Variable | Required | Description |
|----------|----------|-------------|
| `PORT` | No | Server port (default: 4000) |
| `JWT_SECRET` | Yes | Secret for JWT signing |
| `CORS_ORIGIN` | No | Allowed CORS origin |
| `SUPABASE_URL` | No | Supabase project URL |
| `SUPABASE_SERVICE_KEY` | No | Supabase service role key |

## CI/CD Pipeline

GitHub Actions on push to `main`:

1. **Lint** — TypeScript type-check + ESLint
2. **Build** — `next build` with env vars
3. **Deploy** — Vercel CLI production deployment

Backend deployment (SSH + PM2) is available but currently disabled — configure `SERVER_HOST`, `SERVER_USER`, and `SSH_PRIVATE_KEY` secrets to enable.

## Security

- Helmet HTTP security headers
- Content Security Policy (CSP)
- HSTS with preload
- Rate limiting (100 req/15 min)
- JWT authentication with bcrypt password hashing
- Request body size limit (10 MB)
- X-Frame-Options: DENY

## License

Private — All rights reserved.
