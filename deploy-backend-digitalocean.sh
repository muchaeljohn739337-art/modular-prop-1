#!/bin/bash

# 🚀 Advancia PayLedger - Quick Deployment Script for DigitalOcean
# This script automates the backend deployment process

set -e

echo "🚀 ADVANCIA PAYLEDGER - DIGITALOCEAN DEPLOYMENT"
echo "================================================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

if ! command -v node &> /dev/null; then
    echo -e "${RED}Node.js not found. Installing...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

if ! command -v psql &> /dev/null; then
    echo -e "${RED}PostgreSQL not found. Installing...${NC}"
    sudo apt install -y postgresql postgresql-contrib
fi

if ! command -v nginx &> /dev/null; then
    echo -e "${RED}Nginx not found. Installing...${NC}"
    sudo apt install -y nginx
fi

echo -e "${GREEN}✓ All prerequisites installed${NC}"

# Clone and setup
echo -e "${YELLOW}Setting up application...${NC}"

INSTALL_DIR="/var/www/advanciapayledger-backend"

if [ -d "$INSTALL_DIR" ]; then
    echo "Updating existing installation..."
    cd "$INSTALL_DIR"
    git pull origin main
else
    echo "Creating new installation..."
    sudo mkdir -p "$INSTALL_DIR"
    sudo git clone https://github.com/yourusername/advanciapayledger-backend.git "$INSTALL_DIR"
    sudo chown -R $USER:$USER "$INSTALL_DIR"
fi

cd "$INSTALL_DIR"

# Install dependencies
echo -e "${YELLOW}Installing dependencies...${NC}"
npm install

# Build
echo -e "${YELLOW}Building application...${NC}"
npm run build

# Environment configuration
echo -e "${YELLOW}Configuring environment...${NC}"

if [ ! -f ".env" ]; then
    cat > .env << EOF
NODE_ENV=production
PORT=3001
DATABASE_URL=postgresql://advancia_user:PASSWORD_HERE@localhost:5432/advancia_payledger
JWT_SECRET=$(openssl rand -hex 32)
SESSION_SECRET=$(openssl rand -hex 32)
STRIPE_SECRET_KEY=sk_live_YOUR_KEY
STRIPE_PUBLISHABLE_KEY=pk_live_YOUR_KEY
FRONTEND_URL=https://advanciapayledger.com
EOF
    echo -e "${YELLOW}⚠️  Environment file created. Please edit .env with your actual values:${NC}"
    echo "   - DATABASE_URL"
    echo "   - STRIPE_SECRET_KEY"
    echo "   - STRIPE_PUBLISHABLE_KEY"
    echo "   - FRONTEND_URL"
fi

# Database migrations
echo -e "${YELLOW}Running database migrations...${NC}"
npm run prisma:migrate || echo "Migrations may need manual attention"

# Setup PM2
echo -e "${YELLOW}Setting up PM2 process manager...${NC}"

if ! command -v pm2 &> /dev/null; then
    sudo npm install -g pm2
fi

pm2 delete advancia-api 2>/dev/null || true
pm2 start dist/index.js --name "advancia-api" --output /var/log/advancia/out.log --error /var/log/advancia/error.log

# Setup startup
pm2 startup
pm2 save

# Create logs directory
sudo mkdir -p /var/log/advancia
sudo chown -R nobody:nogroup /var/log/advancia

# Configure Nginx
echo -e "${YELLOW}Configuring Nginx...${NC}"

sudo tee /etc/nginx/sites-available/advanciapayledger > /dev/null << EOF
server {
    listen 80;
    server_name api.advanciapayledger.com;
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name api.advanciapayledger.com;
    
    ssl_certificate /etc/letsencrypt/live/api.advanciapayledger.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.advanciapayledger.com/privkey.pem;
    
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "DENY" always;
    
    location / {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
        
        add_header 'Access-Control-Allow-Origin' '*' always;
        add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS' always;
        add_header 'Access-Control-Allow-Headers' 'Content-Type, Authorization' always;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/advanciapayledger /etc/nginx/sites-enabled/advanciapayledger
sudo rm -f /etc/nginx/sites-enabled/default

sudo nginx -t
sudo systemctl restart nginx

# Setup SSL
echo -e "${YELLOW}Setting up SSL certificate...${NC}"

if ! sudo test -f /etc/letsencrypt/live/api.advanciapayledger.com/fullchain.pem; then
    sudo apt install -y certbot python3-certbot-nginx
    sudo certbot certonly --nginx -d api.advanciapayledger.com --non-interactive --agree-tos -m admin@advanciapayledger.com
    sudo systemctl reload nginx
fi

# Setup firewall
echo -e "${YELLOW}Configuring firewall...${NC}"

sudo ufw enable -y || true
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Verification
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}✓ Deployment Complete!${NC}"
echo -e "${GREEN}================================================${NC}"

echo ""
echo -e "${YELLOW}Application Status:${NC}"
pm2 list

echo ""
echo -e "${YELLOW}Access your application:${NC}"
echo "  API: https://api.advanciapayledger.com"
echo "  Health: https://api.advanciapayledger.com/api/health"

echo ""
echo -e "${YELLOW}Useful Commands:${NC}"
echo "  View logs: pm2 logs advancia-api"
echo "  Restart: pm2 restart advancia-api"
echo "  Stop: pm2 stop advancia-api"
echo "  Monitor: pm2 monit"

echo ""
echo -e "${YELLOW}⚠️  IMPORTANT:${NC}"
echo "  1. Edit .env file with your actual credentials"
echo "  2. Configure DNS records to point to this server"
echo "  3. Update FRONTEND_URL if different"
echo "  4. Run: pm2 restart advancia-api (after updating .env)"

