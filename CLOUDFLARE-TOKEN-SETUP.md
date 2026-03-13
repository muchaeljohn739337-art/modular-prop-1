# Cloudflare API Token Setup

Use environment variables for the token and zone metadata. Do not paste tokens into scripts.

```powershell
$env:CLOUDFLARE_API_TOKEN="<new-token>"
$env:CLOUDFLARE_ZONE_ID="<zone-id>"
$env:CLOUDFLARE_ACCOUNT_ID="<account-id>"
```

Domain: `advanciapayledger.com`

---

## Quick Setup

### **Step 1: Go to API Tokens**
1. Visit: https://dash.cloudflare.com/profile/api-tokens
2. Click: **Create Token**

### **Step 2: Choose Custom Token**
1. Click: **Custom token**
2. Token name: `advancia-workspace-api`

### **Step 3: Set Permissions**
Add these permissions:

| Permission | Effect |
|------------|--------|
| Zone | Zone:Read |
| Zone | Email Routing:Edit |
| Zone | Email Routing:Read |
| Account | Account Settings:Read |

### **Step 4: Set Zone Resources**
1. **Zone Resources** section
2. Select: **Include** 
3. Choose: `advanciapayledger.com`
4. Save the selected zone ID in `CLOUDFLARE_ZONE_ID`

### **Step 5: Set TTL**
1. **Token TTL** section
2. Select: **Custom**
3. Set: **1 year**

### **Step 6: Create Token**
1. Click: **Create token**
2. Copy the token once and store it in `CLOUDFLARE_API_TOKEN`

---

## Validate The Token

### PowerShell
```powershell
$env:CLOUDFLARE_API_TOKEN="<new-token>"
$env:CLOUDFLARE_ZONE_ID="<zone-id>"
$env:CLOUDFLARE_ACCOUNT_ID="<account-id>"
pwsh -File "test-cloudflare-api.ps1"
```

---

## ✅ EXPECTED RESULTS

**After updating with new token, you should see:**
```
Testing API token permissions...
1. Token verification...
   Token verified: [token-id]
   Permissions:
     - zone:read: allow
     - zone:email_routing:edit: allow
     - zone:email_routing:read: allow
     - account:account_settings:read: allow
2. Zone access...
   Zone: advanciapayledger.com
   Status: active
3. Email routing permissions...
   Email routing enabled: true
4. Email addresses permissions...
   Can read addresses: True
5. Email rules permissions...
   Can read rules: True
```

---

## 🆘 TROUBLESHOOTING

### **If you still get 401/403 errors:**
1. **Double-check permissions** - Make sure all 4 permissions are added
2. **Check zone resources** - Must include advanciapayledger.com
3. **Token TTL** - Set to custom (not default)
4. **Account access** - Make sure account permissions are correct

### **If token creation fails:**
1. **Account permissions** - You need admin access to the account
2. **Zone access** - Make sure you have access to advanciapayledger.com
3. **Browser issues** - Try incognito mode or different browser

---

## 🎯 NEXT STEPS

1. Token validates through `test-cloudflare-api.ps1`
2. DNS records follow your current Hostinger VPS layout
3. Optional email routing uses the same token if you keep Cloudflare Email Routing

### DNS Records Needed
| Type | Name | Content | Proxy |
|------|------|---------|-------|
| A | @ | `<HOSTINGER_VPS_IP>` | Proxied |
| CNAME | www | `@` | Proxied |
| A | api | `<HOSTINGER_VPS_IP>` | DNS only or Proxied |

---

## 📞 QUICK LINKS

**Create Token:** https://dash.cloudflare.com/profile/api-tokens  
**DNS Setup:** CLOUDFLARE_DNS_SETUP.md  
**Test Script:** test-cloudflare-api.ps1

---

Rotate any old Cloudflare token that was pasted into scripts or chat after you validate the new one.
