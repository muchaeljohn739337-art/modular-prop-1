# 🚀 EXECUTE DEPLOYMENT NOW

## Prerequisites ✅
- SSH key configured for root@147.182.193.11
- Backend code ready in `/backend-clean`
- Frontend code ready in `/frontend-clean`
- Domain DNS configured in Cloudflare

---

## ⚡ QUICK START (Copy & Paste)

### Step 1: Upload Files to Server
```bash
# From your Windows machine (PowerShell)
cd "c:\Users\mucha.DESKTOP-H7T9NPM\Downloads\mdsiles\myproject$new"

# Upload deployment script
scp deploy-all.sh root@147.182.193.11:/tmp/

# Upload backend
scp -r backend-clean/* root@147.182.193.11:/opt/backend/

# Upload frontend  
scp -r frontend-clean/* root@147.182.193.11:/opt/frontend/
```

### Step 2: Run Deployment
```bash
# SSH to server
ssh root@147.182.193.11

# Run deployment script
chmod +x /tmp/deploy-all.sh
/tmp/deploy-all.sh
```

**Time: ~10-15 minutes** ⏱️

---

## 📊 What Gets Deployed

| Component | Location | Port | URL |
|-----------|----------|------|-----|
| Frontend | /opt/frontend | 3000 | https://advanciapayledger.com |
| Backend API | /opt/backend | 3001 | https://api.advanciapayledger.com |
| Nginx Proxy | N/A | 80/443 | All traffic |
| SSL Certs | Certbot | - | Auto-renew |
| Process Manager | PM2 | - | Auto-restart |

---

## 🔍 Verification After Deployment

```bash
# SSH to server
ssh root@147.182.193.11

# Check services
pm2 list

# View logs
pm2 logs backend
pm2 logs frontend

# Test endpoints
curl https://advanciapayledger.com
curl https://api.advanciapayledger.com/api/health

# Verify DNS
nslookup advanciapayledger.com
nslookup api.advanciapayledger.com
```

---

## 📝 During Upload/Deployment

The script will:
1. ✅ Update system packages
2. ✅ Install Node.js, npm, Nginx, Certbot
3. ✅ Extract backend files to /opt/backend
4. ✅ Extract frontend files to /opt/frontend
5. ✅ Install dependencies for both
6. ✅ Build frontend
7. ✅ Start backend with PM2
8. ✅ Start frontend with PM2
9. ✅ Configure Nginx reverse proxy
10. ✅ Setup SSL certificates
11. ✅ Configure PM2 for auto-restart

---

## 🆘 If Something Goes Wrong

### Backend not starting
```bash
ssh root@147.182.193.11
cd /opt/backend
npm install
npm start
```

### Frontend not building
```bash
ssh root@147.182.193.11
cd /opt/frontend
npm install --production
npm run build
```

### Nginx issues
```bash
ssh root@147.182.193.11
nginx -t  # Test config
systemctl restart nginx
```

### SSL certificate errors
```bash
ssh root@147.182.193.11
certbot renew --dry-run
```

---

## ✨ Post-Deployment

### 1. Test Frontend
- Visit https://advanciapayledger.com
- Should see your landing page
- Check browser console for errors

### 2. Test API
```bash
curl -X GET https://api.advanciapayledger.com/api/health
# Should return: {"status":"ok"}
```

### 3. Check Performance
- Frontend should load in <3 seconds
- API responses in <500ms
- Use Chrome DevTools to verify

### 4. Monitor Logs
```bash
# Real-time backend logs
pm2 logs backend --lines 50

# Real-time frontend logs  
pm2 logs frontend --lines 50
```

---

## 🔄 Daily Operations

### Restart services
```bash
pm2 restart all
```

### Stop services
```bash
pm2 stop all
```

### Start services
```bash
pm2 start all
```

### View all logs
```bash
pm2 monit
```

### Clear logs
```bash
pm2 flush
```

---

## 🎯 Success Checklist

After deployment, verify:
- [ ] Frontend loads at https://advanciapayledger.com
- [ ] Backend API responds at https://api.advanciapayledger.com/api/health
- [ ] SSL certificates valid (green lock)
- [ ] pm2 list shows 2 services running
- [ ] DNS resolves correctly (nslookup)
- [ ] Nginx reverse proxy working
- [ ] Auto-restart on failure works (kill process and verify restart)

---

## 📞 Key Information

- **Server**: 147.182.193.11
- **Domain**: advanciapayledger.com
- **API Domain**: api.advanciapayledger.com
- **Backend Port**: 3001 (internal only)
- **Frontend Port**: 3000 (internal only)
- **Nginx Ports**: 80 → 443 (external)
- **PM2 Config**: /root/.pm2/conf.js

---

## ⏱️ Timeline

| Step | Duration |
|------|----------|
| Upload files | 2-5 min |
| Run deployment | 5-10 min |
| SSL certificate | 1-2 min |
| Full verification | 2-3 min |
| **TOTAL** | **10-20 min** |

---

**Status: 🟢 READY FOR IMMEDIATE DEPLOYMENT**

Execute the commands above to go live!
