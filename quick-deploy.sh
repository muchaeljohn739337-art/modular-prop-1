#!/bin/bash
# Quick Deploy Script for Advancia PayLedger
# Run on your Linux VPS after uploading backend/frontend artifacts

set -e

echo "========================================="
echo "🚀 ADVANCIA PAYLEDGER - QUICK DEPLOY"
echo "========================================="
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "❌ This script must be run as root"
   exit 1
fi

# Variables
BACKEND_DIR="${BACKEND_DIR:-/opt/backend-clean}"
FRONTEND_DIR="${FRONTEND_DIR:-/opt/frontend-clean}"
API_PORT="${API_PORT:-3001}"
FRONTEND_PORT="${FRONTEND_PORT:-3000}"
DOMAIN="${DOMAIN:-advanciapayledger.com}"
API_DOMAIN="${API_DOMAIN:-api.${DOMAIN}}"
LETSENCRYPT_EMAIL="${LETSENCRYPT_EMAIL:-admin@advanciapayledger.com}"

echo "📦 Step 1: Update system packages"
apt-get update -qq
apt-get install -y -qq curl wget git nodejs npm

echo "🔧 Step 2: Install PM2 globally"
npm install -g pm2 --silent

echo "📁 Step 3: Create application directories"
mkdir -p $BACKEND_DIR
mkdir -p $FRONTEND_DIR

echo "🗄️  Step 4: Setup Backend"
if [ -d "$BACKEND_DIR/.git" ]; then
    echo "   - Backend already exists, pulling latest..."
    cd $BACKEND_DIR
    git pull origin main
else
    echo "   - Extracting backend files..."
    # Assumes backend is uploaded as zip or tar
fi

cd $BACKEND_DIR
echo "   - Installing dependencies..."
npm install --production --silent

if [ -f ".env.example" ]; then
    echo "   - Creating .env file..."
    cp .env.example .env
    echo "   ⚠️  Please update .env with your database credentials"
fi

echo "   - Starting backend with PM2..."
pm2 start npm --name "advancia-backend" -- start || true

echo ""
echo "🎨 Step 5: Setup Frontend"
if [ -d "$FRONTEND_DIR/.git" ]; then
    echo "   - Frontend already exists, pulling latest..."
    cd $FRONTEND_DIR
    git pull origin main
else
    echo "   - Extracting frontend files..."
    # Assumes frontend is uploaded as zip or tar
fi

cd $FRONTEND_DIR
echo "   - Installing dependencies..."
npm install --production --silent

echo "   - Building frontend..."
npm run build

echo "   - Starting frontend with PM2..."
pm2 start "node .next/standalone/server.js" --name "advancia-frontend" || true

echo ""
echo "🔄 Step 6: Setup Nginx Reverse Proxy"

if ! command -v nginx &> /dev/null; then
    echo "   - Installing Nginx..."
    apt-get install -y -qq nginx
fi

cat > /etc/nginx/sites-available/advancia <<'EOF'
upstream backend {
    server localhost:3001;
}

upstream frontend {
    server localhost:3000;
}

server {
    listen 80;
    server_name ${DOMAIN} www.${DOMAIN};

    # Frontend
    location / {
        proxy_pass http://frontend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    # API
    location /api {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

server {
    listen 80;
    server_name ${API_DOMAIN};

    location / {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

ln -sf /etc/nginx/sites-available/advancia /etc/nginx/sites-enabled/
nginx -t
systemctl restart nginx

echo ""
echo "🔒 Step 7: Setup SSL with Let's Encrypt"

if ! command -v certbot &> /dev/null; then
    echo "   - Installing Certbot..."
    apt-get install -y -qq certbot python3-certbot-nginx
fi

certbot --nginx -d ${DOMAIN} -d www.${DOMAIN} -d ${API_DOMAIN} --non-interactive --agree-tos --email ${LETSENCRYPT_EMAIL}

echo ""
echo "✅ Step 8: Verify Services"
pm2 list
echo ""
echo "🌐 Checking connectivity..."
curl -s http://localhost:3000 > /dev/null && echo "✅ Frontend accessible on :3000"
curl -s http://localhost:3001 > /dev/null && echo "✅ Backend accessible on :3001"

echo ""
echo "========================================="
echo "✨ DEPLOYMENT COMPLETE!"
echo "========================================="
echo ""
echo "📊 Service Status:"
pm2 status
echo ""
echo "🔗 URLs:"
echo "   - Frontend: https://${DOMAIN}"
echo "   - API: https://${API_DOMAIN}"
echo ""
echo "📝 View logs:"
echo "   pm2 logs advancia-backend"
echo "   pm2 logs advancia-frontend"
echo ""
echo "🔄 Restart services:"
echo "   pm2 restart all"
echo ""
echo "💾 Save PM2 state:"
pm2 save
echo ""
echo "Done! 🎉"
