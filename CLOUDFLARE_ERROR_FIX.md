# 🚨 Cloudflare Error Fix - Advancia Pay Ledger

## ❌ Current Issues

### API Token Errors
- **401 Unauthorized** - Token verification failed
- **403 Forbidden** - Zone access denied
- **Email routing permissions** - All failed

### Root Cause
An old Cloudflare API token is invalid or expired.

## 🔧 Fix Steps

### 1. Generate New API Token
Go to Cloudflare Dashboard → My Profile → API Tokens → Create Token

**Required Permissions:**
- **Zone:** Zone:Read (for zone `0bff66558872c58ed5b8b7942acc34d9`)
- **Zone:** Email Routing:Edit
- **Zone:** Email Routing:Read
- **Account:** Account Settings:Read

**Token Settings:**
- Zone Resources: Include `advanciapayledger.com` (Zone ID: `0bff66558872c58ed5b8b7942acc34d9`)
- TTL: Custom (set to 1 year)

### 2. Update Test Script
Use environment variables before running `test-cloudflare-api.ps1`:
```powershell
$env:CLOUDFLARE_API_TOKEN="<new-token>"
$env:CLOUDFLARE_ZONE_ID="<zone-id>"
$env:CLOUDFLARE_ACCOUNT_ID="<account-id>"
```

### 3. Deploy Email Worker
The worker code exists but needs deployment:
```bash
# Install Wrangler
npm install -g wrangler

# Login to Cloudflare
wrangler login

# Deploy worker
wrangler deploy cloudflare-email-worker.js --compatibility-date=2023-05-18
```

### 4. Configure Worker Environment
Set worker secrets:
```bash
wrangler secret put SLACK_WEBHOOK_URL
wrangler secret put DISCORD_WEBHOOK_URL  
wrangler secret put ANALYTICS_ENDPOINT
```

### 5. Update Email Worker Configuration
In `cloudflare-email-worker.js`, change line 21:
```javascript
destinationEmail: "your-actual-email@gmail.com", // ⚠️ CHANGE THIS
```

## 📋 Email Addresses Configured
- ✅ livechat@advanciapayledger.com
- ✅ support@advanciapayledger.com  
- ✅ billing@advanciapayledger.com
- ✅ admin@advanciapayledger.com
- ✅ info@advanciapayledger.com
- ✅ noreply@advanciapayledger.com

## 🧪 Verification Steps
1. Generate new API token
2. Load the token into environment variables
3. Run: `.\test-cloudflare-api.ps1`
4. Should see all green checkmarks
5. Deploy email worker
6. Test email routing

## 🚨 Priority
**HIGH** - Email system is critical for:
- Payment notifications
- User support  
- Billing communications
- System alerts

## 📞 Next Actions
1. Create new Cloudflare API token
2. Rotate any old token that was pasted into files or chat
3. Deploy email worker
4. Test email routing

**Email system will be fully functional once API token is fixed!**
