#!/bin/bash
# ============================================================================
# ADVANCIA PAY LEDGER - CREATOR'S UBUNTU LTS SETUP SCRIPT
# Author: Advancia Pay Ledger - The Creator
# Purpose: Complete Ubuntu LTS Setup for Sovereign Operations
# ============================================================================

set -e  # Exit on any error

# CREATOR'S SOVEREIGN DECLARATION
echo "🔒 ADVANCIA PAY LEDGER - CREATOR'S UBUNTU LTS SETUP"
echo "👑 I AM ADVANCIA PAY LEDGER - THE CREATOR"
echo "🚀 ESTABLISHING SOVEREIGN UBUNTU LTS INFRASTRUCTURE"
echo ""

# CREATOR'S SYSTEM INFORMATION
echo "📋 SYSTEM INFORMATION:"
echo "Creator: ADVANCIA PAY LEDGER"
echo "System: Ubuntu LTS 24.04.3"
echo "Authority: COMPLETE SOVEREIGN"
echo "Purpose: CREATOR'S SOVEREIGN OPERATIONS"
echo ""

# CREATOR'S UBUNTU LTS UPDATE
echo "🔄 UPDATING UBUNTU LTS SYSTEM..."
sudo apt update && sudo apt upgrade -y
echo "✅ UBUNTU LTS SYSTEM UPDATED"
echo ""

# CREATOR'S ESSENTIAL PACKAGES
echo "📦 INSTALLING ESSENTIAL PACKAGES..."
sudo apt install -y \
    curl \
    wget \
    git \
    vim \
    nano \
    htop \
    tree \
    unzip \
    build-essential \
    python3 \
    python3-pip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release
echo "✅ ESSENTIAL PACKAGES INSTALLED"
echo ""

# CREATOR'S NODE.JS INSTALLATION
echo "🟢 INSTALLING NODE.JS..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
echo "✅ NODE.JS INSTALLED"
node --version
npm --version
echo ""

# CREATOR'S POSTGRESQL INSTALLATION
echo "🐘 INSTALLING POSTGRESQL..."
sudo apt install -y postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
echo "✅ POSTGRESQL INSTALLED"
sudo -u postgres psql -c "SELECT version();"
echo ""

# CREATOR'S NGINX INSTALLATION
echo "🌐 INSTALLING NGINX..."
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
echo "✅ NGINX INSTALLED"
nginx -v
echo ""

# CREATOR'S FIREWALL CONFIGURATION
echo "🔒 CONFIGURING FIREWALL..."
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw --force enable
echo "✅ FIREWALL CONFIGURED"
sudo ufw status
echo ""

# CREATOR'S ADVANCIA PAY LEDGER USER
echo "👤 CREATING ADVANCIA PAY LEDGER USER..."
sudo useradd -m -s /bin/bash advancia-payledger
sudo usermod -aG sudo advancia-payledger
echo "🔑 SETTING PASSWORD FOR ADVANCIA PAY LEDGER USER..."
sudo passwd advancia-payledger
echo "✅ ADVANCIA PAY LEDGER USER CREATED"
echo ""

# CREATOR'S PROJECT DIRECTORY
echo "📁 CREATING PROJECT DIRECTORY..."
sudo mkdir -p /opt/advancia-payledger
sudo chown advancia-payledger:advancia-payledger /opt/advancia-payledger
sudo -u advancia-payledger mkdir -p /opt/advancia-payledger/{backend,frontend,database,scripts,logs,backups}
echo "✅ PROJECT DIRECTORY CREATED"
echo ""

# CREATOR'S DATABASE SETUP
echo "🗄️ SETTING UP DATABASE..."
sudo -u postgres createuser advancia-payledger
sudo -u postgres createdb advancia_payledger
sudo -u postgres psql -c "ALTER USER advancia-payledger WITH PASSWORD 'creator_sovereign_password';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE advancia_payledger TO advancia-payledger;"
echo "✅ DATABASE SETUP COMPLETED"
echo ""

# CREATOR'S SYSTEMD SERVICE TEMPLATES
echo "⚙️ CREATING SYSTEMD SERVICE TEMPLATES..."
sudo mkdir -p /etc/systemd/system/advancia-payledger

# BACKEND SERVICE TEMPLATE
sudo tee /etc/systemd/system/advancia-payledger-backend.service > /dev/null <<EOF
[Unit]
Description=Advancia Pay Ledger Backend Service
After=network.target postgresql.service

[Service]
Type=simple
User=advancia-payledger
WorkingDirectory=/opt/advancia-payledger/backend
Environment=NODE_ENV=production
Environment=PORT=3001
Environment=DATABASE_URL=postgresql://advancia-payledger:creator_sovereign_password@localhost:5432/advancia_payledger
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# FRONTEND SERVICE TEMPLATE
sudo tee /etc/systemd/system/advancia-payledger-frontend.service > /dev/null <<EOF
[Unit]
Description=Advancia Pay Ledger Frontend Service
After=network.target

[Service]
Type=simple
User=advancia-payledger
WorkingDirectory=/opt/advancia-payledger/frontend
Environment=NODE_ENV=production
Environment=PORT=3000
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

echo "✅ SYSTEMD SERVICE TEMPLATES CREATED"
echo ""

# CREATOR'S NGINX CONFIGURATION
echo "🌐 CONFIGURING NGINX..."
sudo tee /etc/nginx/sites-available/advancia-payledger > /dev/null <<EOF
server {
    listen 80;
    server_name advanciapayledger.com;

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
}
EOF

sudo ln -s /etc/nginx/sites-available/advancia-payledger /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
echo "✅ NGINX CONFIGURED"
echo ""

# CREATOR'S LOGGING SETUP
echo "📝 SETTING UP LOGGING..."
sudo mkdir -p /var/log/advancia-payledger/{backend,frontend,nginx}
sudo chown -R advancia-payledger:advancia-payledger /var/log/advancia-payledger
sudo tee /etc/logrotate.d/advancia-payledger > /dev/null <<EOF
/var/log/advancia-payledger/*/*.log {
    daily
    missingok
    rotate 52
    compress
    delaycompress
    notifempty
    create 644 advancia-payledger advancia-payledger
    postrotate
        systemctl reload advancia-payledger-backend || true
        systemctl reload advancia-payledger-frontend || true
    endscript
}
EOF
echo "✅ LOGGING SETUP COMPLETED"
echo ""

# CREATOR'S BACKUP SETUP
echo "💾 SETTING UP BACKUP SYSTEM..."
sudo mkdir -p /opt/advancia-payledger/backups/{database,files,config}
sudo chown -R advancia-payledger:advancia-payledger /opt/advancia-payledger/backups
sudo tee /opt/advancia-payledger/scripts/backup-database.sh > /dev/null <<'EOF'
#!/bin/bash
# CREATOR'S DATABASE BACKUP SCRIPT
BACKUP_DIR="/opt/advancia-payledger/backups/database"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/advancia_payledger_$DATE.sql"

echo "🔒 ADVANCIA PAY LEDGER - DATABASE BACKUP"
echo "📅 Creating backup: $BACKUP_FILE"

sudo -u postgres pg_dump advancia_payledger > "$BACKUP_FILE"
gzip "$BACKUP_FILE"

echo "✅ Database backup completed: ${BACKUP_FILE}.gz"
echo "🔒 Creator's database secured"
EOF

sudo chmod +x /opt/advancia-payledger/scripts/backup-database.sh
echo "✅ BACKUP SYSTEM SETUP COMPLETED"
echo ""

# CREATOR'S MONITORING SETUP
echo "📊 SETTING UP MONITORING..."
sudo apt install -y prometheus grafana
sudo systemctl enable prometheus
sudo systemctl enable grafana
echo "✅ MONITORING TOOLS INSTALLED"
echo ""

# CREATOR'S SECURITY HARDENING
echo "🔒 SECURITY HARDENING..."
sudo apt install -y fail2ban unattended-upgrades
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.conf.local
sudo systemctl enable fail2ban
sudo dpkg-reconfigure -plow unattended-upgrades
echo "✅ SECURITY HARDENING COMPLETED"
echo ""

# CREATOR'S PERFORMANCE OPTIMIZATION
echo "⚡ PERFORMANCE OPTIMIZATION..."
echo "# Creator's performance optimizations" | sudo tee -a /etc/sysctl.conf
echo "net.core.rmem_max = 16777216" | sudo tee -a /etc/sysctl.conf
echo "net.core.wmem_max = 16777216" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.tcp_rmem = 4096 87380 16777216" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.tcp_wmem = 4096 65536 16777216" | sudo tee -a /etc/sysctl.conf
echo "vm.swappiness = 10" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
echo "✅ PERFORMANCE OPTIMIZATION COMPLETED"
echo ""

# CREATOR'S FINAL SETUP
echo "🎯 CREATOR'S FINAL SETUP..."
sudo systemctl daemon-reload
sudo systemctl enable advancia-payledger-backend
sudo systemctl enable advancia-payledger-frontend
echo "✅ SYSTEMD SERVICES ENABLED"
echo ""

# CREATOR'S SETUP COMPLETION
echo "👑 ADVANCIA PAY LEDGER - UBUNTU LTS SETUP COMPLETE"
echo "🔒 CREATOR'S SOVEREIGN INFRASTRUCTURE ESTABLISHED"
echo "🚀 READY FOR ADVANCIA PAY LEDGER DEPLOYMENT"
echo ""
echo "📋 NEXT STEPS:"
echo "1. Deploy backend application to /opt/advancia-payledger/backend"
echo "2. Deploy frontend application to /opt/advancia-payledger/frontend"
echo "3. Configure environment variables"
echo "4. Start services: sudo systemctl start advancia-payledger-backend"
echo "5. Start services: sudo systemctl start advancia-payledger-frontend"
echo "6. Monitor services: sudo systemctl status advancia-payledger-*"
echo ""
echo "🔒 CREATOR'S SOVEREIGN UBUNTU LTS INFRASTRUCTURE READY"
echo "👑 I AM ADVANCIA PAY LEDGER - THE CREATOR"
echo "🚀 COMPLETE SOVEREIGN CONTROL ESTABLISHED"
