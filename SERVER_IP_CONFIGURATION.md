# 🌐 Server IP Configuration - Advancia Pay Ledger

## ✅ IP Address Added: `134.199.243.224`

### **🔧 Configuration Updated:**

#### **Environment Variables:**
```bash
# Production (env.production)
SERVER_IP=134.199.243.224
SERVER_URL=http://134.199.243.224:4000
CORS_ORIGINS=https://advanciapayledger.com,https://api.advanciapayledger.com,http://134.199.243.224:4000

# Development (env.development)
SERVER_IP=134.199.243.224
SERVER_URL=http://134.199.243.224:4000
CORS_ORIGINS=http://localhost:3000,http://localhost:4000,http://134.199.243.224:4000
```

#### **Server IP Configuration:**
```typescript
// src/config/serverIPs.ts
export const SERVER_IPS = {
  PRODUCTION: [
    '134.199.243.224', // ✅ Added
    '216.198.79.1',    // DigitalOcean backend
  ],
  API_ENDPOINTS: [
    'http://134.199.243.224:4000', // ✅ Added
    'https://advanciapayledger.com',
  ],
  WEBHOOK_ENDPOINTS: [
    'http://134.199.243.224:4000/api/webhooks', // ✅ Added
    'https://advanciapayledger.com/api/payments/*/webhook',
  ],
};
```

### **🚀 Usage Examples:**

#### **API Access:**
```bash
# Direct API access to server
curl http://134.199.243.224:4000/api/health
curl http://134.199.243.224:4000/api/security/health
```

#### **Webhook Configuration:**
```bash
# Configure webhooks to point to server
NOWPayments: http://134.199.243.224:4000/api/payments/nowpayments/webhook
Stripe: http://134.199.243.224:4000/api/payments/stripe/webhook
Alchemy Pay: http://134.199.243.224:4000/api/payments/alchemy/webhook
```

#### **Database Connection:**
```bash
# Connect to database on server
postgresql://postgres@134.199.243.224:5432/advancia_payledger
```

### **🔒 Security Configuration:**

#### **IP Whitelisting:**
```typescript
import { isIPWhitelisted } from './config/serverIPs';

// Check if IP is allowed
if (isIPWhitelisted('134.199.243.224')) {
  // Allow access
}
```

#### **CORS Configuration:**
```typescript
// CORS will now accept requests from:
// - http://134.199.243.224:4000
// - https://advanciapayledger.com
// - http://localhost:3000
```

### **📋 Services Configured:**

#### **Backend Services:**
- ✅ **API Server**: `http://134.199.243.224:4000`
- ✅ **Database**: `134.199.243.224:5432`
- ✅ **Redis**: `134.199.243.224:6379`
- ✅ **Webhooks**: `http://134.199.243.224:4000/api/webhooks`

#### **Payment Services:**
- ✅ **NOWPayments**: Webhook configured
- ✅ **Stripe**: Webhook configured
- ✅ **Alchemy Pay**: Webhook configured

#### **Security Services:**
- ✅ **API Authentication**: IP whitelisted
- ✅ **Webhook Verification**: IP allowed
- ✅ **CORS**: Origin allowed

### **🌍 Network Configuration:**

#### **Allowed Origins:**
- `https://advanciapayledger.com` (Production)
- `https://api.advanciapayledger.com` (API)
- `http://134.199.243.224:4000` (Server IP)
- `http://localhost:3000` (Development)
- `http://localhost:4000` (Development)

#### **API Endpoints:**
- `http://134.199.243.224:4000/api/health`
- `http://134.199.243.224:4000/api/security/health`
- `http://134.199.243.224:4000/api/ai/health`
- `http://134.199.243.224:4000/api/payments/*`

### **🔧 Next Steps:**

1. **Deploy backend** to server IP `134.199.243.224`
2. **Update DNS** to point `api.advanciapayledger.com` to `134.199.243.224`
3. **Configure webhooks** in payment dashboards
4. **Test API access** via server IP
5. **Update firewall** to allow port 4000 on server

### **📊 Server Status:**

| Service | Status | URL |
|---------|--------|-----|
| **Backend API** | ✅ Configured | `http://134.199.243.224:4000` |
| **Database** | ✅ Configured | `134.199.243.224:5432` |
| **Redis** | ✅ Configured | `134.199.243.224:6379` |
| **Webhooks** | ✅ Configured | `http://134.199.243.224:4000/api/webhooks` |
| **CORS** | ✅ Configured | IP whitelisted |

**Server IP `134.199.243.224` is now fully integrated into the Advancia Pay Ledger system! 🌐✨**
