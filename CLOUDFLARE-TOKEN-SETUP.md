# 🔑 CLOUDFLARE API TOKEN SETUP

**Your Account Details:**
- Account ID: `74ecde4d46d4b399c7295cf599d2886b`
- Zone ID: `0bff66558872c58ed5b8b7942acc34d9`
- Domain: `advanciapayledger.com`

---

## ⚡ QUICK SETUP (2 minutes)

### **Step 1: Go to API Tokens**
1. Visit: https://dash.cloudflare.com/profile/api-tokens
2. Click: **Create Token**

### **Step 2: Choose Custom Token**
1. Click: **Custom token**
2. Token name: `Advancia Pay Ledger API`

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
4. Zone ID should auto-populate: `0bff66558872c58ed5b8b7942acc34d9`

### **Step 5: Set TTL**
1. **Token TTL** section
2. Select: **Custom**
3. Set: **1 year**

### **Step 6: Create Token**
1. Click: **Create token**
2. **COPY THE TOKEN** (you won't see it again!)

---

## 🔄 UPDATE YOUR SCRIPT

### **Replace in test-cloudflare-api.ps1:**
```powershell
# Line 2 - Replace with your new token
$API_TOKEN = "YOUR_NEW_TOKEN_HERE"
```

### **Test the new token:**
```powershell
powershell -ExecutionPolicy Bypass -File "test-cloudflare-api.ps1"
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

### **After token works:**
1. ✅ API token working
2. ⏳ Add DNS records (follow CLOUDFLARE_DNS_SETUP.md)
3. ⏳ Deploy email worker
4. ⏳ Test email routing

### **DNS Records Needed:**
| Type | Name | Content | Proxy |
|------|------|---------|-------|
| A | @ | `<VERCEL_IP>` | Proxied |
| CNAME | www | cname.vercel-dns.com | Proxied |
| A | api | 147.182.193.11 | Proxied |

---

## 📞 QUICK LINKS

**Create Token:** https://dash.cloudflare.com/profile/api-tokens  
**Your Zone:** https://dash.cloudflare.com/0bff66558872c58ed5b8b7942acc34d9  
**DNS Setup:** CLOUDFLARE_DNS_SETUP.md  
**Test Script:** test-cloudflare-api.ps1

---

## 🚀 GO CREATE YOUR TOKEN!

**This should only take 2 minutes, then your Cloudflare setup will be 100% working!** ⚡

**Remember:** Copy the token immediately - you won't see it again!
