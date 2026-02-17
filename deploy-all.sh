#!/bin/bash
# ============================================
# ADVANCIA PAYLEDGER - COMPLETE DEPLOYMENT
# Server: 147.182.193.11
# ============================================

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
SERVER_IP="147.182.193.11"
DOMAIN="advanciapayledger.com"
API_DOMAIN="api.advanciapayledger.com"
BACKEND_PORT="3001"
FRONTEND_PORT="3000"
BACKEND_DIR="/opt/backend"
FRONTEND_DIR="/opt/frontend"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}ADVANCIA PAYLEDGER - DEPLOYMENT${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# ============================================
# STEP 1: System Setup
# ============================================
echo -e "${YELLOW}[1/7] System Setup${NC}"
apt-get update -qq
apt-get install -y -qq curl wget git nodejs npm nginx certbot python3-certbot-nginx
npm install -g pm2

echo -e "${GREEN}✓ System ready${NC}"
echo ""

# ============================================
# STEP 2: Backend Setup
# ============================================
echo -e "${YELLOW}[2/7] Backend Setup${NC}"
mkdir -p $BACKEND_DIR
cd $BACKEND_DIR

if [ -f "package.json" ]; then
    echo "  - Backend already extracted"
else
    echo "  - Waiting for backend files via SCP..."
    echo "  - From your machine: scp -r backend-clean/* root@$SERVER_IP:$BACKEND_DIR/"
fi

if [ -f "package.json" ]; then
    echo "  - Installing dependencies..."
    npm install --production --silent
    
    if [ -f ".env.example" ] && [ ! -f ".env" ]; then
        cp .env.example .env
        echo "  - .env file created (update with your settings)"
    fi
    
    echo "  - Starting backend..."
    pm2 start npm --name "backend" -- start || pm2 restart backend
fi

echo -e "${GREEN}✓ Backend ready${NC}"
echo ""

# ============================================
# STEP 3: Frontend Setup
# ============================================
echo -e "${YELLOW}[3/7] Frontend Setup${NC}"
mkdir -p $FRONTEND_DIR
cd $FRONTEND_DIR

if [ -f "package.json" ]; then
    echo "  - Frontend already extracted"
else
    echo "  - Waiting for frontend files via SCP..."
    echo "  - From your machine: scp -r frontend-clean/* root@$SERVER_IP:$FRONTEND_DIR/"
fi

if [ -f "package.json" ]; then
    echo "  - Installing dependencies..."
    npm install --production --silent
    
    echo "  - Building frontend..."
    npm run build
    
    echo "  - Starting frontend..."
    pm2 start "node .next/standalone/server.js" --name "frontend" || pm2 restart frontend
fi

echo -e "${GREEN}✓ Frontend ready${NC}"
echo ""

# ============================================
# STEP 4: Nginx Configuration
# ============================================
echo -e "${YELLOW}[4/7] Nginx Setup${NC}"

cat > /etc/nginx/sites-available/advancia-app <<'NGINX_CONFIG'
upstream backend {
    server localhost:3001;
}

upstream frontend {
    server localhost:3000;
}

server {
    listen 80;
    server_name advanciapayledger.com www.advanciapayledger.com;

    # Frontend
    location / {
        proxy_pass http://frontend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # API endpoints
    location /api {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # WebSocket support
    location /ws {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
    }
}

# API subdomain
server {
    listen 80;
    server_name api.advanciapayledger.com;

    location / {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
NGINX_CONFIG

ln -sf /etc/nginx/sites-available/advancia-app /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl restart nginx

echo -e "${GREEN}✓ Nginx configured${NC}"
echo ""

# ============================================
# STEP 5: SSL Certificates
# ============================================
echo -e "${YELLOW}[5/7] SSL Setup${NC}"

certbot --nginx \
    -d advanciapayledger.com \
    -d www.advanciapayledger.com \
    -d api.advanciapayledger.com \
    --non-interactive \
    --agree-tos \
    --email admin@advanciapayledger.com \
    --redirect \
    || echo "SSL already configured or error occurred"

echo -e "${GREEN}✓ SSL configured${NC}"
echo ""

# ============================================
# STEP 6: PM2 Configuration
# ============================================
echo -e "${YELLOW}[6/7] PM2 Setup${NC}"

pm2 startup systemd -u root --hp /root
pm2 save

echo -e "${GREEN}✓ PM2 configured${NC}"
echo ""

# ============================================
# STEP 7: Verification
# ============================================
echo -e "${YELLOW}[7/7] Verification${NC}"
echo ""

echo "Service Status:"
pm2 list
echo ""

echo "Testing connectivity:"
curl -s http://localhost:3000 > /dev/null && echo -e "${GREEN}✓ Frontend accessible${NC}" || echo -e "${RED}✗ Frontend not responding${NC}"
curl -s http://localhost:3001 > /dev/null && echo -e "${GREEN}✓ Backend accessible${NC}" || echo -e "${RED}✗ Backend not responding${NC}"

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}✓ DEPLOYMENT COMPLETE${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo "URLs:"
echo "  - Frontend: https://$DOMAIN"
echo "  - API: https://$API_DOMAIN"
echo ""
echo "Commands:"
echo "  pm2 logs backend       - Backend logs"
echo "  pm2 logs frontend      - Frontend logs"
echo "  pm2 restart all        - Restart services"
echo "  pm2 stop all           - Stop services"
echo ""
