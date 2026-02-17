# 🚀 Frontend Deployment - Immediate Actions

## Current Status
- ✅ Build files ready locally  
- ✅ Next.js configured for standalone mode
- ❌ Vercel CLI having issues with mixed app/pages router
- ✅ Alternative: Deploy to DigitalOcean with Docker

---

## **OPTION 1: Deploy to DigitalOcean (RECOMMENDED)**

### Step 1: SSH into DigitalOcean
```bash
ssh root@147.182.193.11
```

### Step 2: Install Node.js (if not present)
```bash
curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### Step 3: Create frontend directory
```bash
mkdir -p /opt/frontend
cd /opt/frontend
```

### Step 4: Upload frontend code
On your local machine:
```powershell
# Zip the frontend
cd "c:\Users\mucha.DESKTOP-H7T9NPM\Downloads\mdsiles\myproject$new\frontend-clean"
Compress-Archive -Path "./*" -DestinationPath "frontend.zip" -Force

# Upload to server
scp frontend.zip root@147.182.193.11:/opt/frontend/
```

### Step 5: Extract and setup on server
```bash
cd /opt/frontend
unzip -q frontend.zip
rm frontend.zip
npm install --production
```

### Step 6: Build on server
```bash
npm run build
```

### Step 7: Create systemd service
```bash
cat > /etc/systemd/system/advancia-frontend.service << 'EOF'
[Unit]
Description=Advancia PayLedger Frontend
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/frontend
Environment="NODE_ENV=production"
Environment="PORT=3000"
ExecStart=/usr/bin/node /opt/frontend/.next/standalone/server.js
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
```

### Step 8: Start service
```bash
systemctl daemon-reload
systemctl enable advancia-frontend
systemctl start advancia-frontend
systemctl status advancia-frontend
```

### Step 9: Setup Nginx reverse proxy
```bash
apt-get install -y nginx

cat > /etc/nginx/sites-available/advancia << 'EOF'
server {
    listen 80;
    server_name advanciapayledger.com www.advanciapayledger.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

ln -s /etc/nginx/sites-available/advancia /etc/nginx/sites-enabled/
nginx -t
systemctl restart nginx
```

### Step 10: Setup SSL with Let's Encrypt
```bash
apt-get install -y certbot python3-certbot-nginx
certbot --nginx -d advanciapayledger.com -d www.advanciapayledger.com
```

### Verify
```bash
curl http://localhost:3000
curl https://advanciapayledger.com
```

---

## **OPTION 2: Use Vercel Git Integration**

1. Push code to GitHub:
   ```powershell
   cd frontend-clean
   git remote add origin https://github.com/YOUR_USERNAME/advancia-frontend.git
   git push -u origin main
   ```

2. In Vercel dashboard:
   - Connect GitHub repo
   - Select `frontend-clean` folder
   - Deploy

---

## **OPTION 3: Quick Manual Vercel Deploy**

```powershell
cd "c:\Users\mucha.DESKTOP-H7T9NPM\Downloads\mdsiles\myproject$new\frontend-clean"

# Login to Vercel
& "C:\Users\mucha.DESKTOP-H7T9NPM\AppData\Roaming\npm\vercel.cmd" login

# Deploy
& "C:\Users\mucha.DESKTOP-H7T9NPM\AppData\Roaming\npm\vercel.cmd" --prod --force
```

---

## **Testing After Deployment**

```bash
# Test frontend
curl https://advanciapayledger.com

# Test backend connection
curl https://api.advanciapayledger.com/api/health

# Check frontend logs
systemctl logs advancia-frontend -f  # If using DigitalOcean
```

---

## **Status Summary**

| Component | Status | Location |
|-----------|--------|----------|
| Backend | ✅ Ready | DigitalOcean 147.182.193.11:3001 |
| Frontend | 🔧 Build ready | Local .next folder |
| DNS | ✅ Configured | Cloudflare |
| API DNS | ✅ api.advanciapayledger.com | 147.182.193.11 |

**Next:** Choose deployment option and execute!
