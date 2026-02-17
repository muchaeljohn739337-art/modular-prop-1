# Environment Variables Setup Guide

## Required GitHub Secrets

Go to **GitHub → Repository → Settings → Secrets and variables → Actions** and add these secrets:

### Vercel (Frontend Deployment)
| Secret | Description |
|--------|-------------|
| `VERCEL_TOKEN` | Your Vercel personal access token (https://vercel.com/account/tokens) |
| `VERCEL_ORG_ID` | Your Vercel team/org ID (found in `.vercel/project.json` after `vercel link`) |
| `VERCEL_PROJECT_ID` | Your Vercel project ID (found in `.vercel/project.json` after `vercel link`) |

### Frontend Environment
| Secret | Description |
|--------|-------------|
| `NEXT_PUBLIC_API_URL` | Backend API URL (e.g. `https://api.advanciapayledger.com`) |
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase project URL |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase anonymous/public key |

### Backend Deployment (SSH)
| Secret | Description |
|--------|-------------|
| `SERVER_HOST` | Production server IP or hostname |
| `SERVER_USER` | SSH username (e.g. `root` or `deploy`) |
| `SSH_PRIVATE_KEY` | SSH private key for server access |

### Cloudflare (Email Worker)
| Secret | Description |
|--------|-------------|
| `CLOUDFLARE_API_TOKEN` | Cloudflare API token |
| `CLOUDFLARE_ACCOUNT_ID` | Cloudflare account ID |

### Notifications (Optional)
| Secret | Description |
|--------|-------------|
| `SLACK_WEBHOOK_URL` | Slack incoming webhook URL |
| `DISCORD_WEBHOOK_URL` | Discord webhook URL |

---

## Vercel Environment Variables

In your **Vercel Dashboard → Project → Settings → Environment Variables**, add:

| Variable | Value | Environments |
|----------|-------|-------------|
| `NEXT_PUBLIC_API_URL` | `https://api.advanciapayledger.com` | Production, Preview |
| `NEXT_PUBLIC_SUPABASE_URL` | Your Supabase URL | Production, Preview |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Your Supabase anon key | Production, Preview |

---

## Quick Setup Steps

### 1. Link Vercel Project
```bash
cd advanciapayledger-new
npx vercel link
```
This creates `.vercel/project.json` with your `orgId` and `projectId`.

### 2. Add GitHub Secrets
Copy the `orgId` and `projectId` from step 1 into GitHub Secrets as `VERCEL_ORG_ID` and `VERCEL_PROJECT_ID`.

### 3. Generate Vercel Token
Go to https://vercel.com/account/tokens → Create → copy token → add as `VERCEL_TOKEN` in GitHub Secrets.

### 4. Push to Main
```bash
git add . && git commit -m "Update CI/CD" && git push origin main
```
The workflow will automatically lint, build, and deploy on every push to `main`.
