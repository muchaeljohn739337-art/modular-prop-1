# 🌐 DNS Completion - Advancia Pay Ledger

## ❌ Missing DNS Records

### 1. API Subdomain (Critical)
```
Type: A Record
Name: api
Content: 216.198.79.1
Proxy Status: DNS only
TTL: 10 min
```

### 2. Enhanced DMARC (Recommended)
```
Type: TXT
Name: _dmarc
Content: "v=DMARC1; p=quarantine; rua=mailto:dmarc@advanciapayledger.com; ruf=mailto:dmarc@advanciapayledger.com; pct=100"
Proxy Status: DNS only
TTL: 1 hour
```

### 3. Additional Security Headers (Optional)
```
Type: TXT
Name: _securitytxt
Content: "contact: security@advanciapayledger.com; policy: https://advanciapayledger.com/security"
```

## 📧 Email Routing Configuration (Not in DNS)

### Configure in Cloudflare Dashboard → Email Routing:

1. **Enable Email Routing** (if not already enabled)
2. **Create Email Forwarding Rules:**

| From (Email Address) | Forward To | Action |
|----------------------|-------------|---------|
| support@advanciapayledger.com | your-support-email@gmail.com | Forward |
| billing@advanciapayledger.com | your-billing-email@gmail.com | Forward |
| admin@advanciapayledger.com | your-admin-email@gmail.com | Forward |
| livechat@advanciapayledger.com | your-support-email@gmail.com | Forward |
| info@advanciapayledger.com | your-info-email@gmail.com | Forward |
| noreply@advanciapayledger.com | ⚠️ Do NOT forward (system emails only) |

## 🔧 API Token Fix Required

The main issue is still the **expired API token**:

1. **Generate New Token** with permissions:
   - Zone:Read (advanciapayledger.com)
   - Email Routing:Edit
   - Email Routing:Read

2. **Update Test Script:**
   ```powershell
   $env:CLOUDFLARE_API_TOKEN="<new-token>"
   $env:CLOUDFLARE_ZONE_ID="<zone-id>"
   ```

3. **Deploy Email Worker:**
   ```bash
   wrangler deploy cloudflare-email-worker.js
   ```

## 🚀 Complete Setup Steps

### Step 1: Add API Subdomain
1. Go to Cloudflare DNS
2. Add A record: `api` → `<HOSTINGER_VPS_IP>`

### Step 2: Fix Email Routing
1. Generate new API token
2. Update test script
3. Run: `.\test-cloudflare-api.ps1`
4. Configure email forwarding rules

### Step 3: Deploy Email Worker
1. Install Wrangler: `npm install -g wrangler`
2. Login: `wrangler login`
3. Deploy: `wrangler deploy cloudflare-email-worker.js`

### Step 4: Test Everything
1. Test API: `https://api.advanciapayledger.com/health`
2. Test emails: Send test to support@advanciapayledger.com
3. Test webhooks: Trigger payment notifications

## 📋 Current Status

| Component | Status | Action Needed |
|-----------|--------|---------------|
| Main Domain | ✅ Working | None |
| WWW Subdomain | ✅ Working | None |
| API Subdomain | ❌ Missing | Add A record |
| Email Routing | ❌ Broken | Fix API token |
| Email Worker | ❌ Not deployed | Deploy worker |
| Security Headers | ⚠️ Basic | Can enhance |

## 🎯 Priority Order

1. **HIGH:** Fix API token (breaks email routing)
2. **HIGH:** Add API subdomain (backend access)
3. **MEDIUM:** Deploy email worker (advanced features)
4. **LOW:** Enhance security headers

**Once API token is fixed and email routing configured, your system will be fully operational!**
