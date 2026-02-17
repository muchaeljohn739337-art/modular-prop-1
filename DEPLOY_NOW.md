# Complete VPS Deployment Steps

## Quick Start - Copy & Paste These Commands

### Step 1: Connect to your VPS
```bash
ssh root@76.13.77.8
# Password: gXF?5ZPRwVNRTv4
```

### Step 2: Run Ubuntu Setup (copy entire block)
```bash
curl -fsSL https://get.docker.com | sh && \
apt-get update && apt-get install -y docker-compose-plugin git wget nano ufw && \
ufw --force enable && \
ufw allow 22/tcp && ufw allow 80/tcp && ufw allow 443/tcp && ufw allow 3000/tcp && \
mkdir -p /opt/advancia && \
docker --version && docker compose version && \
echo "Setup complete! Now clone your repository."
```

### Step 3: Get your code on the VPS

**Option A: Direct upload from Windows (recommended)**
Open a NEW PowerShell window on your Windows machine and run:
```powershell
cd C:\Users\mucha.DESKTOP-H7T9NPM\Downloads\mdsiles\myproject$new
scp -r advanciapayledger-new root@76.13.77.8:/opt/advancia/
```

**Option B: Use Git (if repository is accessible)**
```bash
cd /opt/advancia
git clone https://github.com/advancia-devuser/advanciapayledger-new.git
cd advanciapayledger-new
```

### Step 4: Configure environment (back on VPS)
```bash
cd /opt/advancia/advanciapayledger-new
cp .env.template .env
nano .env
```

**Edit these key values in .env:**
- `POSTGRES_PASSWORD=` (set a strong password)
- `JWT_SECRET=` (generate a random string)
- `REDIS_PASSWORD=` (set a password)

Press `Ctrl+X`, then `Y`, then `Enter` to save.

### Step 5: Deploy with Docker
```bash
docker compose up -d --build
```

### Step 6: Check deployment
```bash
docker ps
docker logs advancia-backend -f
# Press Ctrl+C to exit logs
```

### Step 7: Access your app
- Frontend: http://76.13.77.8:3000
- Backend API: http://76.13.77.8:3001
- Database: localhost:5432 (internal only)

## Troubleshooting

### If Docker build fails:
```bash
docker compose down
docker compose up -d --build --no-cache
```

### Check logs:
```bash
docker logs advancia-frontend
docker logs advancia-backend
docker logs advancia-db
```

### Restart services:
```bash
docker compose restart
```

### Stop everything:
```bash
docker compose down
```

## Setup Nginx for domain (optional)

```bash
apt-get install -y nginx certbot python3-certbot-nginx

# Copy nginx config
cp nginx/advancia.conf /etc/nginx/sites-available/advancia
ln -s /etc/nginx/sites-available/advancia /etc/nginx/sites-enabled/

# Edit with your domain
nano /etc/nginx/sites-available/advancia
# Change: server_name yourdomain.com;

# Test and reload
nginx -t
systemctl reload nginx

# Get SSL
certbot --nginx -d yourdomain.com
```

## Security Checklist

1. Change root password:
```bash
passwd
```

2. Create non-root user:
```bash
adduser deploy
usermod -aG sudo,docker deploy
```

3. Setup SSH keys (disable password auth later)

4. Keep secrets in .env file, never commit to git
