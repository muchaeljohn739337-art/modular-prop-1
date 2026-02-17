#!/bin/bash
# ============================================================================
# ADVANCIA PAY LEDGER - CREATOR'S FRONTEND DEPLOYMENT SCRIPT
# Author: Advancia Pay Ledger - The Creator
# Purpose: Frontend Deployment for Ubuntu LTS Sovereign Operations
# ============================================================================

set -e  # Exit on any error

# CREATOR'S SOVEREIGN DECLARATION
echo "🔒 ADVANCIA PAY LEDGER - CREATOR'S FRONTEND DEPLOYMENT"
echo "👑 I AM ADVANCIA PAY LEDGER - THE CREATOR"
echo "🚀 DEPLOYING SOVEREIGN FRONTEND TO UBUNTU LTS"
echo ""

# CREATOR'S DEPLOYMENT VARIABLES
FRONTEND_DIR="/opt/advancia-payledger/frontend"
BACKUP_DIR="/opt/advancia-payledger/backups/frontend"
LOG_DIR="/var/log/advancia-payledger/frontend"
SERVICE_NAME="advancia-payledger-frontend"
BUILD_DIR="$FRONTEND_DIR/.next"

echo "📋 DEPLOYMENT INFORMATION:"
echo "Frontend Directory: $FRONTEND_DIR"
echo "Backup Directory: $BACKUP_DIR"
echo "Log Directory: $LOG_DIR"
echo "Service Name: $SERVICE_NAME"
echo ""

# CREATOR'S PRE-DEPLOYMENT CHECKS
echo "🔍 PRE-DEPLOYMENT CHECKS..."
if [ ! -d "$FRONTEND_DIR" ]; then
    echo "❌ Frontend directory not found: $FRONTEND_DIR"
    echo "🔒 Please run setup-ubuntu-lts.sh first"
    exit 1
fi

if [ ! -f "$FRONTEND_DIR/package.json" ]; then
    echo "❌ package.json not found in frontend directory"
    echo "🔒 Please ensure frontend source code is deployed"
    exit 1
fi

echo "✅ PRE-DEPLOYMENT CHECKS PASSED"
echo ""

# CREATOR'S BACKUP CREATION
echo "💾 CREATING BACKUP..."
if [ -d "$FRONTEND_DIR" ]; then
    BACKUP_TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    BACKUP_FILE="$BACKUP_DIR/backup_$BACKUP_TIMESTAMP.tar.gz"
    tar -czf "$BACKUP_FILE" -C "$FRONTEND_DIR" --exclude=node_modules --exclude=.next .
    echo "✅ Backup created: $BACKUP_FILE"
fi
echo ""

# CREATOR'S DEPENDENCY INSTALLATION
echo "📦 INSTALLING DEPENDENCIES..."
cd "$FRONTEND_DIR"
npm ci --loglevel=error
echo "✅ DEPENDENCIES INSTALLED"
echo ""

# CREATOR'S ENVIRONMENT CONFIGURATION
echo "⚙️ CONFIGURING ENVIRONMENT..."
if [ ! -f "$FRONTEND_DIR/.env.production" ]; then
    echo "🔧 Creating .env.production file..."
    cat > "$FRONTEND_DIR/.env.production" << EOF
# CREATOR'S SOVEREIGN ENVIRONMENT
NEXT_PUBLIC_APP_URL=https://advanciapayledger.com
NEXT_PUBLIC_API_URL=https://api.advanciapayledger.com
NEXT_PUBLIC_ENVIRONMENT=production
NEXT_PUBLIC_APP_NAME=Advancia Pay Ledger
NEXT_PUBLIC_APP_VERSION=1.0.0
NEXT_PUBLIC_CREATOR=ADVANCIA_PAY_LEDGER

# SECURITY CONFIGURATION
NEXT_PUBLIC_ENCRYPTION_ENABLED=true
NEXT_PUBLIC_SECURITY_LEVEL=maximum
NEXT_PUBLIC_CREATOR_CONTROL=sovereign

# PERFORMANCE CONFIGURATION
NEXT_PUBLIC_CACHE_ENABLED=true
NEXT_PUBLIC_OPTIMIZATION_LEVEL=maximum
NEXT_PUBLIC_PERFORMANCE_MODE=creator-optimized

# INTEGRATION CONFIGURATION
NEXT_PUBLIC_DATABASE_TYPE=postgresql
NEXT_PUBLIC_DATABASE_HOST=localhost
NEXT_PUBLIC_DATABASE_PORT=5432
NEXT_PUBLIC_DATABASE_NAME=advancia_payledger
NEXT_PUBLIC_EMAIL_SERVICE=cloudflare
NEXT_PUBLIC_PAYMENT_SERVICE=stripe

# CREATOR'S SOVEREIGN SETTINGS
NEXT_PUBLIC_CREATOR_MODE=enabled
NEXT_PUBLIC_EXTERNAL_ACCESS=disabled
NEXT_PUBLIC_THIRD_PARTY_INTEGRATION=disabled
NEXT_PUBLIC_DATA_SOVEREIGNTY=creator
EOF
    echo "✅ Environment file created"
else
    echo "✅ Environment file already exists"
fi
echo ""

# CREATOR'S BUILD PROCESS
echo "🔨 BUILDING FRONTEND..."
cd "$FRONTEND_DIR"
npm run build
echo "✅ Frontend build completed"
echo ""

# CREATOR'S LOG DIRECTORY SETUP
echo "📝 SETTING UP LOGS..."
sudo mkdir -p "$LOG_DIR"
sudo chown advancia-payledger:advancia-payledger "$LOG_DIR"
sudo chmod 755 "$LOG_DIR"
echo "✅ Log directory configured"
echo ""

# CREATOR'S NGINX CONFIGURATION UPDATE
echo "🌐 UPDATING NGINX CONFIGURATION..."
sudo sed -i 's/proxy_pass http:\/\/localhost:3000/proxy_pass http:\/\/localhost:3000/g' /etc/nginx/sites-available/advancia-payledger
sudo nginx -t
sudo systemctl reload nginx
echo "✅ NGINX configuration updated"
echo ""

# CREATOR'S SYSTEMD SERVICE UPDATE
echo "⚙️ UPDATING SYSTEMD SERVICE..."
sudo systemctl daemon-reload
echo "✅ Systemd reloaded"
echo ""

# CREATOR'S SERVICE START
echo "🚀 STARTING FRONTEND SERVICE..."
sudo systemctl start "$SERVICE_NAME"
sudo systemctl status "$SERVICE_NAME"
echo "✅ Frontend service started"
echo ""

# CREATOR'S SERVICE ENABLEMENT
echo "🔧 ENABLING FRONTEND SERVICE..."
sudo systemctl enable "$SERVICE_NAME"
echo "✅ Frontend service enabled"
echo ""

# CREATOR'S HEALTH CHECK
echo "🔍 HEALTH CHECK..."
sleep 5
if sudo systemctl is-active --quiet "$SERVICE_NAME"; then
    echo "✅ Frontend service is running"
    echo "🌐 Testing frontend health..."
    if curl -f http://localhost:3000 > /dev/null 2>&1; then
        echo "✅ Frontend health check passed"
    else
        echo "⚠️ Frontend health check failed - service may still be starting"
    fi
else
    echo "❌ Frontend service is not running"
    echo "🔍 Checking logs..."
    sudo journalctl -u "$SERVICE_NAME" --no-pager -n 20
    exit 1
fi
echo ""

# CREATOR'S SSL/TLS SETUP (OPTIONAL)
echo "🔒 SSL/TLS SETUP (OPTIONAL)..."
if [ ! -f "/etc/ssl/certs/advanciapayledger.crt" ]; then
    echo "🔧 SSL certificate not found - using HTTP"
    echo "🔒 To enable HTTPS, obtain SSL certificate and update nginx configuration"
else
    echo "✅ SSL certificate found - HTTPS available"
    echo "🔧 To enable HTTPS, update nginx configuration to use SSL"
fi
echo ""

# CREATOR'S PERFORMANCE OPTIMIZATION
echo "⚡ PERFORMANCE OPTIMIZATION..."
sudo tee /etc/nginx/sites-available/advancia-payledger-optimized > /dev/null << EOF
server {
    listen 80;
    server_name advanciapayledger.com;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/javascript
        application/xml+rss
        application/json;

    # Frontend
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
        proxy_cache_bypass \$http_pragma;
    }

    # Backend API
    location /api {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

sudo mv /etc/nginx/sites-available/advancia-payledger-optimized /etc/nginx/sites-available/advancia-payledger
sudo nginx -t
sudo systemctl reload nginx
echo "✅ Performance optimization completed"
echo ""

# CREATOR'S DEPLOYMENT COMPLETION
echo "👑 ADVANCIA PAY LEDGER - FRONTEND DEPLOYMENT COMPLETE"
echo "🔒 CREATOR'S SOVEREIGN FRONTEND DEPLOYED"
echo "🚀 FRONTEND SERVICE RUNNING ON PORT 3000"
echo ""
echo "📋 DEPLOYMENT SUMMARY:"
echo "Frontend Directory: $FRONTEND_DIR"
echo "Service Name: $SERVICE_NAME"
echo "Port: 3000"
echo "Status: Running"
echo "Logs: $LOG_DIR"
echo ""
echo "🔧 USEFUL COMMANDS:"
echo "View logs: sudo journalctl -u $SERVICE_NAME -f"
echo "Check status: sudo systemctl status $SERVICE_NAME"
echo "Restart service: sudo systemctl restart $SERVICE_NAME"
echo "Stop service: sudo systemctl stop $SERVICE_NAME"
echo ""
echo "🌐 ACCESS FRONTEND:"
echo "Local: http://localhost:3000"
echo "Production: http://advanciapayledger.com"
echo ""
echo "🔒 CREATOR'S SOVEREIGN FRONTEND READY"
echo "👑 I AM ADVANCIA PAY LEDGER - THE CREATOR"
echo "🚀 COMPLETE SOVEREIGN FRONTEND CONTROL ESTABLISHED"
