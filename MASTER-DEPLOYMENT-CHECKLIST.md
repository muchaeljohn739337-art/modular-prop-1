🎯 ADVANCIA PAYLEDGER - DEPLOYMENT MASTER CHECKLIST
================================================

> Reference-only legacy checklist. The IPs and hosting split below may not match the current production decision. Use [WORKSPACE_CONTROL_TOWER.md](../WORKSPACE_CONTROL_TOWER.md) first.

## PRE-DEPLOYMENT ✅

- [x] DNS configured in Cloudflare
  - Root domain: advanciapayledger.com → 147.182.193.11
  - API subdomain: api.advanciapayledger.com → 147.182.193.11
  - WWW CNAME configured
  
- [x] Backend ready
  - Enterprise framework verified
  - All services in place
  - Database connection config ready
  
- [x] Frontend built
  - .next folder created
  - Production build complete
  - Environment variables set
  
- [x] Server prepared
  - IP: 147.182.193.11
  - SSH access confirmed
  - Node.js environment ready

---

## DEPLOYMENT STEPS

### Step 1: Prepare Files (Windows Machine)
```powershell
cd "c:\Users\mucha.DESKTOP-H7T9NPM\Downloads\mdsiles\myproject$new"

# Option A: Use helper script
.\deploy.ps1

# Option B: Manual commands
scp deploy-all.sh root@147.182.193.11:/tmp/
scp -r backend-clean/* root@147.182.193.11:/opt/backend/
scp -r frontend-clean/* root@147.182.193.11:/opt/frontend/
```
⏱️ Time: 5-10 minutes

### Step 2: SSH to Server
```bash
ssh root@147.182.193.11
```

### Step 3: Run Deployment
```bash
chmod +x /tmp/deploy-all.sh
/tmp/deploy-all.sh
```
⏱️ Time: 5-10 minutes

### Step 4: Verify
```bash
# Check services
pm2 list

# Test frontend
curl https://advanciapayledger.com

# Test API
curl https://api.advanciapayledger.com/api/health

# View logs
pm2 logs
```
⏱️ Time: 2-3 minutes

---

## DEPLOYMENT CHECKLIST

### Before Upload
- [ ] All files backed up
- [ ] SSH key accessible
- [ ] Network connectivity verified
- [ ] Enough disk space on server (5GB+)

### During Upload
- [ ] deploy-all.sh uploaded
- [ ] backend-clean/* uploaded
- [ ] frontend-clean/* uploaded
- [ ] File permissions correct

### During Deployment
- [ ] System packages installing
- [ ] Node.js installing
- [ ] npm packages installing
- [ ] Backend starting
- [ ] Frontend building
- [ ] Frontend starting
- [ ] Nginx configuring
- [ ] SSL certificates installing

### After Deployment
- [ ] pm2 list shows 2 services
- [ ] Frontend responds to curl
- [ ] API responds to curl
- [ ] Nginx reverse proxy working
- [ ] SSL certificates valid
- [ ] DNS resolves correctly
- [ ] Logs show no errors

---

## SYSTEM ARCHITECTURE (After Deployment)

```
┌─────────────────────────────────────────┐
│          Internet / Users                │
└────────────────┬────────────────────────┘
                 │
         HTTPS (443) / HTTP (80)
                 │
        ┌────────▼─────────┐
        │  Nginx Reverse   │
        │      Proxy       │
        │  (port 80/443)   │
        └─┬──────────┬─────┘
          │          │
    HTTP  │          │ HTTP
    3000  │          │ 3001
          │          │
    ┌─────▼─┐  ┌────▼──────┐
    │Frontend│  │  Backend   │
    │App     │  │  API Server│
    │:3000   │  │  :3001     │
    │(PM2)   │  │  (PM2)     │
    └────────┘  └───┬────────┘
                    │
            ┌───────▼────────┐
            │   PostgreSQL   │
            │   Database     │
            └────────────────┘

SSL Certificates: Auto-renew via Let's Encrypt
Process Manager: PM2 (auto-restart on crash)
Reverse Proxy: Nginx
```

---

## FILES & LOCATIONS

### Server Directories
| Path | Contains |
|------|----------|
| /opt/backend | Backend API code |
| /opt/frontend | Frontend app code |
| /etc/nginx/sites-available/advancia-app | Nginx config |
| /root/.pm2 | PM2 configuration |
| /var/log/nginx | Nginx logs |

### Key Commands
| Command | Purpose |
|---------|---------|
| pm2 list | Show running services |
| pm2 logs backend | View backend logs |
| pm2 logs frontend | View frontend logs |
| pm2 restart all | Restart services |
| pm2 stop all | Stop services |
| nginx -t | Test nginx config |
| systemctl restart nginx | Restart nginx |
| certbot renew | Renew SSL certs |

---

## MONITORING & MAINTENANCE

### Daily
- Check pm2 status: `pm2 list`
- Review logs: `pm2 logs --lines 50`
- Monitor performance: `pm2 monit`

### Weekly
- Check SSL certificate: `certbot certificates`
- Review nginx logs: `tail -f /var/log/nginx/access.log`
- Verify DNS: `nslookup advanciapayledger.com`

### Monthly
- Update packages: `apt-get update && apt-get upgrade`
- Renew SSL certificates: `certbot renew --dry-run`
- Backup data
- Review security logs

### Quarterly
- Full system audit
- Performance review
- Database maintenance
- Security assessment

---

## TROUBLESHOOTING

### Frontend not loading
```bash
pm2 logs frontend
# Check for errors
curl http://localhost:3000
```

### API not responding
```bash
pm2 logs backend
# Check for database connection
curl http://localhost:3001/api/health
```

### SSL certificate errors
```bash
certbot renew --force-renewal
systemctl restart nginx
```

### High memory usage
```bash
pm2 list  # Check which process
pm2 restart <app-name>
```

### DNS not resolving
```bash
# Wait 10-60 minutes for DNS propagation
nslookup advanciapayledger.com
# Check Cloudflare dashboard settings
```

---

## SUCCESS INDICATORS ✅

After successful deployment, you should see:

✅ **Frontend Working**
- [ ] Page loads in <3 seconds
- [ ] No console errors
- [ ] HTTPS with valid certificate
- [ ] Responsive on all devices

✅ **API Working**
- [ ] /api/health returns 200
- [ ] Response time <500ms
- [ ] Authentication working
- [ ] Database connected

✅ **Infrastructure**
- [ ] pm2 list shows 2 processes
- [ ] Both processes in "online" state
- [ ] SSL certificates valid
- [ ] Nginx serving traffic
- [ ] Auto-restart on failure

✅ **Monitoring**
- [ ] Logs showing normal operation
- [ ] No error messages
- [ ] CPU usage <30%
- [ ] Memory usage <500MB

---

## PERFORMANCE TARGETS 🎯

| Metric | Target | Actual |
|--------|--------|--------|
| Frontend Load | <3 seconds | - |
| API Response | <500ms | - |
| Uptime | 99.9% | - |
| CPU Usage | <30% | - |
| Memory Usage | <500MB | - |
| SSL Score | A+ | - |

---

## NEXT STEPS AFTER DEPLOYMENT

1. **Mobile Apps**
   - Update API URL in mobile app code
   - Test connections
   - Submit to app stores

2. **Analytics**
   - Setup Google Analytics
   - Setup Sentry for error tracking
   - Setup monitoring dashboards

3. **Backups**
   - Setup automated database backups
   - Setup code repository backups
   - Test backup restoration

4. **Security**
   - Enable 2FA for server
   - Setup firewall rules
   - Enable DDoS protection
   - Regular security audits

5. **Documentation**
   - Create runbooks
   - Document configurations
   - Create incident response plans
   - Update team documentation

---

## CONTACT & SUPPORT 📞

### Important URLs
- Frontend: https://advanciapayledger.com
- API: https://api.advanciapayledger.com
- Admin Panel: https://admin.advanciapayledger.com (if applicable)

### Server Access
- SSH: ssh root@147.182.193.11
- Provider: DigitalOcean
- OS: Ubuntu

### Certificates
- Provider: Let's Encrypt
- Auto-renewal: Enabled via certbot
- Renewal check: Monthly

### Support Resources
- Nginx docs: https://nginx.org/en/docs/
- PM2 docs: https://pm2.io/docs/
- Certbot docs: https://certbot.eff.org/docs/
- DigitalOcean docs: https://docs.digitalocean.com/

---

## TIMELINE ⏱️

| Phase | Duration | Status |
|-------|----------|--------|
| File Upload | 5-10 min | Ready |
| Script Execution | 5-10 min | Ready |
| Services Starting | 1-2 min | Ready |
| SSL Configuration | 1-2 min | Ready |
| DNS Propagation | 5-60 min | Depends |
| **TOTAL TO LIVE** | **15-20 min** | ✅ Ready |

---

## DEPLOYMENT STATUS 🟢

**ALL SYSTEMS GO FOR DEPLOYMENT**

Execute deployment script and your Advancia PayLedger platform will be live in 15-20 minutes!

---

**Checklist completed:** January 27, 2026
**Status:** READY FOR PRODUCTION
**Next Action:** Run `./deploy.ps1` on your Windows machine
