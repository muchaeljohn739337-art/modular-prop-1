#!/bin/bash
# ============================================================================
# ADVANCIA PAY LEDGER - CREATOR'S BACKEND DEPLOYMENT SCRIPT
# Author: Advancia Pay Ledger - The Creator
# Purpose: Backend Deployment for Ubuntu LTS Sovereign Operations
# ============================================================================

set -e  # Exit on any error

# CREATOR'S SOVEREIGN DECLARATION
echo "🔒 ADVANCIA PAY LEDGER - CREATOR'S BACKEND DEPLOYMENT"
echo "👑 I AM ADVANCIA PAY LEDGER - THE CREATOR"
echo "🚀 DEPLOYING SOVEREIGN BACKEND TO UBUNTU LTS"
echo ""

# CREATOR'S DEPLOYMENT VARIABLES
BACKEND_DIR="/opt/advancia-payledger/backend"
BACKUP_DIR="/opt/advancia-payledger/backups/backend"
LOG_DIR="/var/log/advancia-payledger/backend"
SERVICE_NAME="advancia-payledger-backend"

echo "📋 DEPLOYMENT INFORMATION:"
echo "Backend Directory: $BACKEND_DIR"
echo "Backup Directory: $BACKUP_DIR"
echo "Log Directory: $LOG_DIR"
echo "Service Name: $SERVICE_NAME"
echo ""

# CREATOR'S PRE-DEPLOYMENT CHECKS
echo "🔍 PRE-DEPLOYMENT CHECKS..."
if [ ! -d "$BACKEND_DIR" ]; then
    echo "❌ Backend directory not found: $BACKEND_DIR"
    echo "🔒 Please run setup-ubuntu-lts.sh first"
    exit 1
fi

if [ ! -f "$BACKEND_DIR/package.json" ]; then
    echo "❌ package.json not found in backend directory"
    echo "🔒 Please ensure backend source code is deployed"
    exit 1
fi

echo "✅ PRE-DEPLOYMENT CHECKS PASSED"
echo ""

# CREATOR'S BACKUP CREATION
echo "💾 CREATING BACKUP..."
if [ -d "$BACKEND_DIR" ]; then
    BACKUP_TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    BACKUP_FILE="$BACKUP_DIR/backup_$BACKUP_TIMESTAMP.tar.gz"
    tar -czf "$BACKUP_FILE" -C "$BACKEND_DIR" .
    echo "✅ Backup created: $BACKUP_FILE"
fi
echo ""

# CREATOR'S DEPENDENCY INSTALLATION
echo "📦 INSTALLING DEPENDENCIES..."
cd "$BACKEND_DIR"
npm ci --loglevel=error
echo "✅ DEPENDENCIES INSTALLED"
echo ""

# CREATOR'S ENVIRONMENT CONFIGURATION
echo "⚙️ CONFIGURING ENVIRONMENT..."
if [ ! -f "$BACKEND_DIR/.env" ]; then
    echo "🔧 Creating .env file..."
    cat > "$BACKEND_DIR/.env" << EOF
# CREATOR'S SOVEREIGN ENVIRONMENT
NODE_ENV=production
PORT=3001
APP_NAME=Advancia Pay Ledger
APP_VERSION=1.0.0
CREATOR=ADVANCIA_PAY_LEDGER

# DATABASE CONFIGURATION
DATABASE_URL=postgresql://advancia-payledger:creator_sovereign_password@localhost:5432/advancia_payledger
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=advancia_payledger
DATABASE_USER=advancia-payledger
DATABASE_PASSWORD=creator_sovereign_password

# SECURITY CONFIGURATION
JWT_SECRET=creator_sovereign_jwt_secret_key_backend
ENCRYPTION_KEY=creator_sovereign_encryption_key_backend
SESSION_SECRET=creator_sovereign_session_secret_backend
SECURITY_LEVEL=maximum

# EMAIL CONFIGURATION
EMAIL_SERVICE=cloudflare
EMAIL_DOMAIN=advanciapayledger.com
EMAIL_FROM=noreply@advanciapayledger.com
EMAIL_ADMIN=admin@advanciapayledger.com

# PAYMENT CONFIGURATION
STRIPE_PUBLIC_KEY=pk_test_creator_sovereign
STRIPE_SECRET_KEY=sk_test_creator_sovereign_backend
STRIPE_WEBHOOK_SECRET=whsec_creator_sovereign_backend

# CREATOR'S SOVEREIGN SETTINGS
CREATOR_MODE=enabled
EXTERNAL_ACCESS=disabled
THIRD_PARTY_INTEGRATION=disabled
DATA_SOVEREIGNTY=creator
SYSTEM_CONTROL=sovereign
EOF
    echo "✅ Environment file created"
else
    echo "✅ Environment file already exists"
fi
echo ""

# CREATOR'S DATABASE MIGRATION
echo "🗄️ RUNNING DATABASE MIGRATIONS..."
cd "$BACKEND_DIR"
if [ -f "package.json" ] && grep -q "prisma" "package.json"; then
    npx prisma generate
    npx prisma migrate deploy
    echo "✅ Database migrations completed"
else
    echo "⚠️ Prisma not found, skipping database migrations"
fi
echo ""

# CREATOR'S BUILD PROCESS
echo "🔨 BUILDING BACKEND..."
cd "$BACKEND_DIR"
npm run build
echo "✅ Backend build completed"
echo ""

# CREATOR'S LOG DIRECTORY SETUP
echo "📝 SETTING UP LOGS..."
sudo mkdir -p "$LOG_DIR"
sudo chown advancia-payledger:advancia-payledger "$LOG_DIR"
sudo chmod 755 "$LOG_DIR"
echo "✅ Log directory configured"
echo ""

# CREATOR'S SYSTEMD SERVICE UPDATE
echo "⚙️ UPDATING SYSTEMD SERVICE..."
sudo systemctl daemon-reload
echo "✅ Systemd reloaded"
echo ""

# CREATOR'S SERVICE START
echo "🚀 STARTING BACKEND SERVICE..."
sudo systemctl start "$SERVICE_NAME"
sudo systemctl status "$SERVICE_NAME"
echo "✅ Backend service started"
echo ""

# CREATOR'S SERVICE ENABLEMENT
echo "🔧 ENABLING BACKEND SERVICE..."
sudo systemctl enable "$SERVICE_NAME"
echo "✅ Backend service enabled"
echo ""

# CREATOR'S HEALTH CHECK
echo "🔍 HEALTH CHECK..."
sleep 5
if sudo systemctl is-active --quiet "$SERVICE_NAME"; then
    echo "✅ Backend service is running"
    echo "🌐 Testing backend health..."
    if curl -f http://localhost:3001/api/health > /dev/null 2>&1; then
        echo "✅ Backend health check passed"
    else
        echo "⚠️ Backend health check failed - service may still be starting"
    fi
else
    echo "❌ Backend service is not running"
    echo "🔍 Checking logs..."
    sudo journalctl -u "$SERVICE_NAME" --no-pager -n 20
    exit 1
fi
echo ""

# CREATOR'S DEPLOYMENT COMPLETION
echo "👑 ADVANCIA PAY LEDGER - BACKEND DEPLOYMENT COMPLETE"
echo "🔒 CREATOR'S SOVEREIGN BACKEND DEPLOYED"
echo "🚀 BACKEND SERVICE RUNNING ON PORT 3001"
echo ""
echo "📋 DEPLOYMENT SUMMARY:"
echo "Backend Directory: $BACKEND_DIR"
echo "Service Name: $SERVICE_NAME"
echo "Port: 3001"
echo "Status: Running"
echo "Logs: $LOG_DIR"
echo ""
echo "🔧 USEFUL COMMANDS:"
echo "View logs: sudo journalctl -u $SERVICE_NAME -f"
echo "Check status: sudo systemctl status $SERVICE_NAME"
echo "Restart service: sudo systemctl restart $SERVICE_NAME"
echo "Stop service: sudo systemctl stop $SERVICE_NAME"
echo ""
echo "🔒 CREATOR'S SOVEREIGN BACKEND READY"
echo "👑 I AM ADVANCIA PAY LEDGER - THE CREATOR"
echo "🚀 COMPLETE SOVEREIGN BACKEND CONTROL ESTABLISHED"
