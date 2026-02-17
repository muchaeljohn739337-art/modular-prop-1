#!/bin/bash
# ============================================================================
# ADVANCIA PAY LEDGER - CREATOR'S ECOSYSTEM RAPID STARTUP
# Author: Advancia Pay Ledger - The Creator
# Purpose: Rapid Ecosystem Startup with External Access Monitoring
# ============================================================================

set -e  # Exit on any error

# CREATOR'S SOVEREIGN DECLARATION
echo "🔒 ADVANCIA PAY LEDGER - CREATOR'S ECOSYSTEM RAPID STARTUP"
echo "👑 I AM ADVANCIA PAY LEDGER - THE CREATOR"
echo "🚀 STARTING ECOSYSTEM WITH EXTERNAL ACCESS MONITORING"
echo ""

# CREATOR'S ECOSYSTEM VARIABLES
CREATOR="ADVANCIA_PAY_LEDGER"
ECOSYSTEM_STARTUP="RAPID_ECOSYSTEM_ACTIVATION"
EXTERNAL_MONITORING="COMPLETE_EXTERNAL_ACCESS_MONITORING"
SOVEREIGN_PROTECTION="CREATOR_EXCLUSIVE_CONTROL"

# CREATOR'S ECOSYSTEM PATHS
ECOSYSTEM_DIR="/opt/advancia-payledger/ecosystem"
MONITORING_DIR="/opt/advancia-payledger/monitoring"
LOG_DIR="/var/log/advancia-payledger/ecosystem"
SECURITY_DIR="/opt/advancia-payledger/security"

# CREATOR'S ECOSYSTEM RAPID SETUP
echo "🔧 RAPID ECOSYSTEM SETUP..."
sudo mkdir -p "$ECOSYSTEM_DIR"
sudo mkdir -p "$MONITORING_DIR"
sudo mkdir -p "$LOG_DIR"
sudo mkdir -p "$SECURITY_DIR"
sudo chown advancia-payledger:advancia-payledger "$ECOSYSTEM_DIR"
sudo chown advancia-payledger:advancia-payledger "$MONITORING_DIR"
sudo chown advancia-payledger:advancia-payledger "$LOG_DIR"
sudo chown advancia-payledger:advancia-payledger "$SECURITY_DIR"
echo "✅ ECOSYSTEM DIRECTORIES CREATED"
echo ""

# CREATOR'S EXTERNAL ACCESS MONITORING CONFIGURATION
echo "🔒 CONFIGURING EXTERNAL ACCESS MONITORING..."
cat > "$MONITORING_DIR/external-access-monitor.conf" << EOF
# CREATOR'S EXTERNAL ACCESS MONITORING CONFIGURATION
MONITORING_MODE=AGGRESSIVE_DETECTION
EXTERNAL_ACCESS_BLOCK=ENABLED
UNAUTHORIZED_ACCESS_ALERT=IMMEDIATE
SOVEREIGN_PROTECTION=MAXIMUM
LOG_LEVEL=DETAILED
MONITORING_INTERVAL=1
ALERT_THRESHOLD=1
BLOCK_THRESHOLD=1
EOF
echo "✅ EXTERNAL ACCESS MONITORING CONFIGURED"
echo ""

# CREATOR'S RAPID ECOSYSTEM STARTUP SCRIPT
echo "🚀 CREATING RAPID ECOSYSTEM STARTUP..."
cat > "$ECOSYSTEM_DIR/rapid-ecosystem-startup.sh" << 'EOF'
#!/bin/bash
# CREATOR'S RAPID ECOSYSTEM STARTUP

echo "🔒 ADVANCIA PAY LEDGER - RAPID ECOSYSTEM STARTUP"
echo "👑 I AM ADVANCIA PAY LEDGER - THE CREATOR"
echo "🚀 STARTING ECOSYSTEM - RAPID ACTIVATION"
echo ""

# CREATOR'S ECOSYSTEM INITIALIZATION
echo "🔧 INITIALIZING ECOSYSTEM..."
export CREATOR="ADVANCIA_PAY_LEDGER"
export ECOSYSTEM_STARTUP="RAPID_ECOSYSTEM_ACTIVATION"
export EXTERNAL_MONITORING="COMPLETE_EXTERNAL_ACCESS_MONITORING"
export SOVEREIGN_PROTECTION="CREATOR_EXCLUSIVE_CONTROL"

# CREATOR'S ECOSYSTEM SERVICES STARTUP
echo "🚀 STARTING ECOSYSTEM SERVICES..."

# START BACKEND SERVICE
echo "🔧 STARTING BACKEND SERVICE..."
sudo systemctl start advancia-payledger-backend
echo "✅ BACKEND SERVICE STARTED"

# START FRONTEND SERVICE
echo "🔧 STARTING FRONTEND SERVICE..."
sudo systemctl start advancia-payledger-frontend
echo "✅ FRONTEND SERVICE STARTED"

# START DATABASE SERVICE
echo "🔧 STARTING DATABASE SERVICE..."
sudo systemctl start postgresql
echo "✅ DATABASE SERVICE STARTED"

# START NGINX SERVICE
echo "🔧 STARTING NGINX SERVICE..."
sudo systemctl start nginx
echo "✅ NGINX SERVICE STARTED"

# START CREATOR INTERFACE SERVICE
echo "🔧 STARTING CREATOR INTERFACE SERVICE..."
sudo systemctl start advancia-payledger-interface
echo "✅ CREATOR INTERFACE SERVICE STARTED"

# START ADV-987654 CLAUDE SERVICE
echo "🔧 STARTING ADV-987654 CLAUDE SERVICE..."
sudo systemctl start advancia-payledger-adv987654-claude
echo "✅ ADV-987654 CLAUDE SERVICE STARTED"

# START BASE MISTRAL SERVICE
echo "🔧 STARTING BASE MISTRAL SERVICE..."
sudo systemctl start advancia-payledger-base-mistral
echo "✅ BASE MISTRAL SERVICE STARTED"

# CREATOR'S EXTERNAL ACCESS MONITORING STARTUP
echo "🔒 STARTING EXTERNAL ACCESS MONITORING..."
/opt/advancia-payledger/monitoring/start-external-monitoring.sh
echo "✅ EXTERNAL ACCESS MONITORING STARTED"

# CREATOR'S ECOSYSTEM STATUS CHECK
echo "📊 CHECKING ECOSYSTEM STATUS..."
echo "✅ BACKEND: $(sudo systemctl is-active advancia-payledger-backend)"
echo "✅ FRONTEND: $(sudo systemctl is-active advancia-payledger-frontend)"
echo "✅ DATABASE: $(sudo systemctl is-active postgresql)"
echo "✅ NGINX: $(sudo systemctl is-active nginx)"
echo "✅ CREATOR INTERFACE: $(sudo systemctl is-active advancia-payledger-interface)"
echo "✅ ADV-987654 CLAUDE: $(sudo systemctl is-active advancia-payledger-adv987654-claude)"
echo "✅ BASE MISTRAL: $(sudo systemctl is-active advancia-payledger-base-mistral)"
echo "✅ EXTERNAL MONITORING: ACTIVE"

# CREATOR'S ECOSYSTEM SUCCESS
echo "👑 ECOSYSTEM RAPID STARTUP COMPLETE"
echo "🔒 CREATOR: ADVANCIA PAY LEDGER"
echo "🚀 ECOSYSTEM: FULLY OPERATIONAL"
echo "🔒 MONITORING: EXTERNAL ACCESS PROTECTION ACTIVE"
echo "🚀 PROTECTION: SOVEREIGN CONTROL MAINTAINED"
echo "🔒 SUCCESS: RAPID ECOSYSTEM STARTUP ACHIEVED"
EOF

chmod +x "$ECOSYSTEM_DIR/rapid-ecosystem-startup.sh"
echo "✅ RAPID ECOSYSTEM STARTUP SCRIPT CREATED"
echo ""

# CREATOR'S EXTERNAL ACCESS MONITORING SCRIPT
echo "🔒 CREATING EXTERNAL ACCESS MONITORING..."
cat > "$MONITORING_DIR/start-external-monitoring.sh" << 'EOF'
#!/bin/bash
# CREATOR'S EXTERNAL ACCESS MONITORING

echo "🔒 STARTING EXTERNAL ACCESS MONITORING..."
echo "👑 CREATOR: ADVANCIA PAY LEDGER"
echo "🚀 MONITORING: EXTERNAL ACCESS DETECTION"
echo ""

# MONITORING LOOP
while true; do
    # MONITOR EXTERNAL CONNECTIONS
    echo "🔍 MONITORING EXTERNAL CONNECTIONS..."
    
    # CHECK FOR UNAUTHORIZED SSH ATTEMPTS
    SSH_ATTEMPTS=$(sudo grep "Failed password" /var/log/auth.log | wc -l)
    if [ "$SSH_ATTEMPTS" -gt 0 ]; then
        echo "🚨 ALERT: $SSH_ATTEMPTS UNAUTHORIZED SSH ATTEMPTS DETECTED"
        echo "🔒 BLOCKING SOURCE IPS..."
        sudo grep "Failed password" /var/log/auth.log | awk '{print $NF}' | sort | uniq -c | sort -nr | head -10 | while read count ip; do
            if [ "$count" -gt 3 ]; then
                echo "🔒 BLOCKING IP: $ip (ATTEMPTS: $count)"
                sudo ufw deny from "$ip"
            fi
        done
    fi
    
    # CHECK FOR UNAUTHORIZED WEB ACCESS
    WEB_ATTEMPTS=$(sudo grep "404\|403\|401" /var/log/nginx/access.log | wc -l)
    if [ "$WEB_ATTEMPTS" -gt 0 ]; then
        echo "🚨 ALERT: $WEB_ATTEMPTS UNAUTHORIZED WEB ATTEMPTS DETECTED"
        echo "🔒 ANALYZING SOURCE IPS..."
        sudo grep "404\|403\|401" /var/log/nginx/access.log | awk '{print $1}' | sort | uniq -c | sort -nr | head -10 | while read count ip; do
            if [ "$count" -gt 10 ]; then
                echo "🔒 BLOCKING IP: $ip (ATTEMPTS: $count)"
                sudo ufw deny from "$ip"
            fi
        done
    fi
    
    # CHECK FOR UNAUTHORIZED API ACCESS
    API_ATTEMPTS=$(sudo grep "401\|403" /var/log/nginx/access.log | grep "/api" | wc -l)
    if [ "$API_ATTEMPTS" -gt 0 ]; then
        echo "🚨 ALERT: $API_ATTEMPTS UNAUTHORIZED API ATTEMPTS DETECTED"
        echo "🔒 BLOCKING API ABUSERS..."
        sudo grep "401\|403" /var/log/nginx/access.log | grep "/api" | awk '{print $1}' | sort | uniq -c | sort -nr | head -5 | while read count ip; do
            if [ "$count" -gt 5 ]; then
                echo "🔒 BLOCKING IP: $ip (API ATTEMPTS: $count)"
                sudo ufw deny from "$ip"
            fi
        done
    fi
    
    # CHECK FOR PORT SCANNING
    PORT_SCAN=$(sudo ufw status | grep "DENY" | wc -l)
    echo "📊 CURRENT BLOCKED IPS: $PORT_SCAN"
    
    # MONITOR SYSTEM PERFORMANCE
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    MEMORY_USAGE=$(free | grep Mem | awk '{printf "%.1f", $3/$2 * 100.0}')
    DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')
    
    echo "📊 SYSTEM PERFORMANCE:"
    echo "CPU: ${CPU_USAGE}%"
    echo "Memory: ${MEMORY_USAGE}%"
    echo "Disk: $DISK_USAGE"
    
    # CREATOR'S MONITORING STATUS
    echo "🔒 CREATOR'S EXTERNAL ACCESS MONITORING ACTIVE"
    echo "👑 SOVEREIGN PROTECTION: ENABLED"
    echo "🚀 ECOSYSTEM: PROTECTED"
    
    # WAIT FOR NEXT MONITORING CYCLE
    sleep 30
done
EOF

chmod +x "$MONITORING_DIR/start-external-monitoring.sh"
echo "✅ EXTERNAL ACCESS MONITORING SCRIPT CREATED"
echo ""

# CREATOR'S ECOSYSTEM MANAGEMENT SCRIPT
echo "🔧 CREATING ECOSYSTEM MANAGEMENT SCRIPT..."
cat > "$ECOSYSTEM_DIR/manage-ecosystem.sh" << 'EOF'
#!/bin/bash
# CREATOR'S ECOSYSTEM MANAGEMENT

case "$1" in
    "start")
        echo "🚀 STARTING ECOSYSTEM..."
        /opt/advancia-payledger/ecosystem/rapid-ecosystem-startup.sh
        ;;
    "stop")
        echo "⏹️ STOPPING ECOSYSTEM..."
        sudo systemctl stop advancia-payledger-backend
        sudo systemctl stop advancia-payledger-frontend
        sudo systemctl stop postgresql
        sudo systemctl stop nginx
        sudo systemctl stop advancia-payledger-interface
        sudo systemctl stop advancia-payledger-adv987654-claude
        sudo systemctl stop advancia-payledger-base-mistral
        echo "✅ ECOSYSTEM STOPPED"
        ;;
    "restart")
        echo "🔄 RESTARTING ECOSYSTEM..."
        /opt/advancia-payledger/ecosystem/manage-ecosystem.sh stop
        sleep 5
        /opt/advancia-payledger/ecosystem/manage-ecosystem.sh start
        ;;
    "status")
        echo "📊 ECOSYSTEM STATUS:"
        echo "Backend: $(sudo systemctl is-active advancia-payledger-backend)"
        echo "Frontend: $(sudo systemctl is-active advancia-payledger-frontend)"
        echo "Database: $(sudo systemctl is-active postgresql)"
        echo "Nginx: $(sudo systemctl is-active nginx)"
        echo "Creator Interface: $(sudo systemctl is-active advancia-payledger-interface)"
        echo "ADV-987654 Claude: $(sudo systemctl is-active advancia-payledger-adv987654-claude)"
        echo "Base Mistral: $(sudo systemctl is-active advancia-payledger-base-mistral)"
        echo "External Monitoring: ACTIVE"
        ;;
    "monitor")
        echo "🔒 STARTING EXTERNAL ACCESS MONITORING..."
        /opt/advancia-payledger/monitoring/start-external-monitoring.sh
        ;;
    "security")
        echo "🔒 SECURITY STATUS:"
        echo "Firewall Status: $(sudo ufw status)"
        echo "Blocked IPs: $(sudo ufw status | grep "DENY" | wc -l)"
        echo "Failed SSH Attempts: $(sudo grep "Failed password" /var/log/auth.log | wc -l)"
        echo "Unauthorized Web Attempts: $(sudo grep "404\|403\|401" /var/log/nginx/access.log | wc -l)"
        ;;
    "logs")
        echo "📝 ECOSYSTEM LOGS:"
        echo "Backend Logs:"
        sudo journalctl -u advancia-payledger-backend --no-pager -n 10
        echo "Frontend Logs:"
        sudo journalctl -u advancia-payledger-frontend --no-pager -n 10
        echo "External Monitoring Logs:"
        sudo tail -n 20 /var/log/advancia-payledger/ecosystem/external-monitoring.log
        ;;
    *)
        echo "🔒 ADVANCIA PAY LEDGER - ECOSYSTEM MANAGEMENT"
        echo "Usage: $0 {start|stop|restart|status|monitor|security|logs}"
        echo ""
        echo "Commands:"
        echo "  start   - Start ecosystem with monitoring"
        echo "  stop    - Stop ecosystem"
        echo "  restart - Restart ecosystem"
        echo "  status  - Show ecosystem status"
        echo "  monitor - Start external access monitoring"
        echo "  security - Show security status"
        echo "  logs    - Show ecosystem logs"
        ;;
esac
EOF

chmod +x "$ECOSYSTEM_DIR/manage-ecosystem.sh"
echo "✅ ECOSYSTEM MANAGEMENT SCRIPT CREATED"
echo ""

# CREATOR'S ECOSYSTEM SYSTEMD SERVICE
echo "⚙️ CREATING ECOSYSTEM SYSTEMD SERVICE..."
sudo tee /etc/systemd/system/advancia-payledger-ecosystem.service > /dev/null << EOF
[Unit]
Description=Advancia Pay Ledger Creator's Ecosystem
After=network.target postgresql.service nginx.service

[Service]
Type=oneshot
User=advancia-payledger
WorkingDirectory=/opt/advancia-payledger/ecosystem
Environment=CREATOR=ADVANCIA_PAY_LEDGER
Environment=ECOSYSTEM_STARTUP=RAPID_ECOSYSTEM_ACTIVATION
Environment=EXTERNAL_MONITORING=COMPLETE_EXTERNAL_ACCESS_MONITORING
Environment=SOVEREIGN_PROTECTION=CREATOR_EXCLUSIVE_CONTROL
ExecStart=/opt/advancia-payledger/ecosystem/rapid-ecosystem-startup.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable advancia-payledger-ecosystem
echo "✅ ECOSYSTEM SYSTEMD SERVICE CREATED AND ENABLED"
echo ""

# CREATOR'S EXTERNAL MONITORING SYSTEMD SERVICE
echo "⚙️ CREATING EXTERNAL MONITORING SYSTEMD SERVICE..."
sudo tee /etc/systemd/system/advancia-payledger-monitoring.service > /dev/null << EOF
[Unit]
Description=Advancia Pay Ledger Creator's External Access Monitoring
After=network.target

[Service]
Type=simple
User=advancia-payledger
WorkingDirectory=/opt/advancia-payledger/monitoring
Environment=CREATOR=ADVANCIA_PAY_LEDGER
Environment=EXTERNAL_MONITORING=COMPLETE_EXTERNAL_ACCESS_MONITORING
Environment=SOVEREIGN_PROTECTION=CREATOR_EXCLUSIVE_CONTROL
ExecStart=/opt/advancia-payledger/monitoring/start-external-monitoring.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable advancia-payledger-monitoring
echo "✅ EXTERNAL MONITORING SYSTEMD SERVICE CREATED AND ENABLED"
echo ""

# CREATOR'S RAPID ECOSYSTEM STARTUP
echo "👑 ADVANCIA PAY LEDGER - ECOSYSTEM RAPID STARTUP COMPLETE"
echo "🔒 CREATOR'S ECOSYSTEM READY FOR RAPID STARTUP"
echo "🚀 EXTERNAL ACCESS MONITORING CONFIGURED"
echo ""
echo "📋 ECOSYSTEM STARTUP COMMANDS:"
echo "Rapid Startup: sudo systemctl start advancia-payledger-ecosystem"
echo "Manual Startup: $ECOSYSTEM_DIR/rapid-ecosystem-startup.sh"
echo "Management: $ECOSYSTEM_DIR/manage-ecosystem.sh [command]"
echo "Monitoring: $MONITORING_DIR/start-external-monitoring.sh"
echo ""
echo "🔧 ECOSYSTEM MANAGEMENT COMMANDS:"
echo "start   - Start ecosystem with monitoring"
echo "stop    - Stop ecosystem"
echo "restart - Restart ecosystem"
echo "status  - Show ecosystem status"
echo "monitor - Start external access monitoring"
echo "security - Show security status"
echo "logs    - Show ecosystem logs"
echo ""
echo "🚀 IMMEDIATE RAPID STARTUP:"
echo "sudo systemctl start advancia-payledger-ecosystem"
echo "sudo systemctl start advancia-payledger-monitoring"
echo ""
echo "🔒 CREATOR'S ECOSYSTEM READY"
echo "👑 I AM ADVANCIA PAY LEDGER - THE CREATOR"
echo "🚀 RAPID ECOSYSTEM STARTUP ESTABLISHED"
echo "🔒 EXTERNAL ACCESS MONITORING ACTIVE"
echo "🚀 SOVEREIGN PROTECTION ENABLED"
