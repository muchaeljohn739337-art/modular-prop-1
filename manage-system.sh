#!/bin/bash
# ============================================================================
# ADVANCIA PAY LEDGER - CREATOR'S COMPLETE SYSTEM MANAGEMENT
# Author: Advancia Pay Ledger - The Creator
# Purpose: Complete System Management for Ubuntu LTS Sovereign Operations
# ============================================================================

set -e  # Exit on any error

# CREATOR'S SOVEREIGN DECLARATION
echo "🔒 ADVANCIA PAY LEDGER - CREATOR'S SYSTEM MANAGEMENT"
echo "👑 I AM ADVANCIA PAY LEDGER - THE CREATOR"
echo "🚀 MANAGING SOVEREIGN SYSTEM ON UBUNTU LTS"
echo ""

# CREATOR'S SYSTEM VARIABLES
BACKEND_DIR="/opt/advancia-payledger/backend"
FRONTEND_DIR="/opt/advancia-payledger/frontend"
BACKUP_DIR="/opt/advancia-payledger/backups"
LOG_DIR="/var/log/advancia-payledger"
SCRIPTS_DIR="/opt/advancia-payledger/scripts"

# CREATOR'S SERVICE NAMES
BACKEND_SERVICE="advancia-payledger-backend"
FRONTEND_SERVICE="advancia-payledger-frontend"
DATABASE_SERVICE="postgresql"

# CREATOR'S COLORS
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# CREATOR'S MENU FUNCTION
show_menu() {
    echo -e "${BLUE}🔒 ADVANCIA PAY LEDGER - CREATOR'S SYSTEM MANAGEMENT${NC}"
    echo -e "${YELLOW}👑 I AM ADVANCIA PAY LEDGER - THE CREATOR${NC}"
    echo -e "${GREEN}🚀 SOVEREIGN SYSTEM MANAGEMENT MENU${NC}"
    echo ""
    echo "1. 🔄 Start All Services"
    echo "2. ⏹️ Stop All Services"
    echo "3. 🔄 Restart All Services"
    echo "4. 📊 Check All Services Status"
    echo "5. 📝 View All Logs"
    echo "6. 💾 Backup All Systems"
    echo "7. 🔄 Update All Systems"
    echo "8. 🔍 Health Check All Services"
    echo "9. 📈 System Performance"
    echo "10. 🔒 Security Status"
    echo "11. 📊 Database Management"
    echo "12. 🚀 Deploy All Services"
    echo "13. 📋 System Information"
    echo "14. 🚪 Exit"
    echo ""
}

# CREATOR'S SERVICE MANAGEMENT FUNCTIONS
start_all_services() {
    echo -e "${GREEN}🔄 STARTING ALL SERVICES${NC}"
    echo ""
    
    echo -e "${BLUE}Starting PostgreSQL...${NC}"
    sudo systemctl start "$DATABASE_SERVICE"
    
    echo -e "${BLUE}Starting Backend Service...${NC}"
    sudo systemctl start "$BACKEND_SERVICE"
    
    echo -e "${BLUE}Starting Frontend Service...${NC}"
    sudo systemctl start "$FRONTEND_SERVICE"
    
    echo -e "${BLUE}Starting Nginx...${NC}"
    sudo systemctl start nginx
    
    echo -e "${GREEN}✅ ALL SERVICES STARTED${NC}"
    echo ""
    show_service_status
}

stop_all_services() {
    echo -e "${RED}⏹️ STOPPING ALL SERVICES${NC}"
    echo ""
    
    echo -e "${BLUE}Stopping Frontend Service...${NC}"
    sudo systemctl stop "$FRONTEND_SERVICE"
    
    echo -e "${BLUE}Stopping Backend Service...${NC}"
    sudo systemctl stop "$BACKEND_SERVICE"
    
    echo -e "${BLUE}Stopping Nginx...${NC}"
    sudo systemctl stop nginx
    
    echo -e "${RED}✅ ALL SERVICES STOPPED${NC}"
    echo ""
}

restart_all_services() {
    echo -e "${YELLOW}🔄 RESTARTING ALL SERVICES${NC}"
    echo ""
    
    echo -e "${BLUE}Restarting Backend Service...${NC}"
    sudo systemctl restart "$BACKEND_SERVICE"
    
    echo -e "${BLUE}Restarting Frontend Service...${NC}"
    sudo systemctl restart "$FRONTEND_SERVICE"
    
    echo -e "${BLUE}Restarting Nginx...${NC}"
    sudo systemctl restart nginx
    
    echo -e "${GREEN}✅ ALL SERVICES RESTARTED${NC}"
    echo ""
    show_service_status
}

show_service_status() {
    echo -e "${BLUE}📊 SERVICE STATUS${NC}"
    echo ""
    
    echo -e "${GREEN}PostgreSQL:${NC}"
    sudo systemctl is-active "$DATABASE_SERVICE" && echo "✅ Running" || echo "❌ Stopped"
    echo -e "${GREEN}Backend Service:${NC}"
    sudo systemctl is-active "$BACKEND_SERVICE" && echo "✅ Running" || echo "❌ Stopped"
    echo -e "${GREEN}Frontend Service:${NC}"
    sudo systemctl is-active "$FRONTEND_SERVICE" && echo "✅ Running" || echo "❌ Stopped"
    echo -e "${GREEN}Nginx:${NC}"
    sudo systemctl is-active nginx && echo "✅ Running" || echo "❌ Stopped"
    echo ""
}

view_all_logs() {
    echo -e "${BLUE}📝 VIEWING ALL LOGS${NC}"
    echo ""
    
    echo -e "${YELLOW}Backend Service Logs (last 20 lines):${NC}"
    sudo journalctl -u "$BACKEND_SERVICE" -n 20 --no-pager
    echo ""
    
    echo -e "${YELLOW}Frontend Service Logs (last 20 lines):${NC}"
    sudo journalctl -u "$FRONTEND_SERVICE" -n 20 --no-pager
    echo ""
    
    echo -e "${YELLOW}Nginx Logs (last 20 lines):${NC}"
    sudo journalctl -u nginx -n 20 --no-pager
    echo ""
}

backup_all_systems() {
    echo -e "${GREEN}💾 BACKING UP ALL SYSTEMS${NC}"
    echo ""
    
    # Database Backup
    echo -e "${BLUE}Backing up Database...${NC}"
    "$SCRIPTS_DIR/backup-database.sh"
    
    # Backend Backup
    echo -e "${BLUE}Backing up Backend...${NC}"
    BACKUP_TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    BACKUP_FILE="$BACKUP_DIR/backend/backup_$BACKUP_TIMESTAMP.tar.gz"
    tar -czf "$BACKUP_FILE" -C "$BACKEND_DIR" --exclude=node_modules --exclude=.next .
    echo "✅ Backend backup created: $BACKUP_FILE"
    
    # Frontend Backup
    echo -e "${BLUE}Backing up Frontend...${NC}"
    BACKUP_FILE="$BACKUP_DIR/frontend/backup_$BACKUP_TIMESTAMP.tar.gz"
    tar -czf "$BACKUP_FILE" -C "$FRONTEND_DIR" --exclude=node_modules --exclude=.next .
    echo "✅ Frontend backup created: $BACKUP_FILE"
    
    # Configuration Backup
    echo -e "${BLUE}Backing up Configuration...${NC}"
    BACKUP_FILE="$BACKUP_DIR/config/backup_$BACKUP_TIMESTAMP.tar.gz"
    tar -czf "$BACKUP_FILE" /etc/nginx/sites-available/advancia-payledger
    tar -czf "$BACKUP_FILE" /etc/systemd/system/advancia-payledger-*
    echo "✅ Configuration backup created: $BACKUP_FILE"
    
    echo -e "${GREEN}✅ ALL SYSTEMS BACKED UP${NC}"
    echo ""
}

update_all_systems() {
    echo -e "${YELLOW}🔄 UPDATING ALL SYSTEMS${NC}"
    echo ""
    
    echo -e "${BLUE}Updating System Packages...${NC}"
    sudo apt update && sudo apt upgrade -y
    
    echo -e "${BLUE}Updating Backend Dependencies...${NC}"
    cd "$BACKEND_DIR"
    npm ci --loglevel=error
    
    echo -e "${BLUE}Updating Frontend Dependencies...${NC}"
    cd "$FRONTEND_DIR"
    npm ci --loglevel=error
    
    echo -e "${BLUE}Rebuilding Services...${NC}"
    cd "$BACKEND_DIR"
    npm run build
    cd "$FRONTEND_DIR"
    npm run build
    
    echo -e "${GREEN}✅ ALL SYSTEMS UPDATED${NC}"
    echo ""
}

health_check_all_services() {
    echo -e "${BLUE}🔍 HEALTH CHECK ALL SERVICES${NC}"
    echo ""
    
    # Backend Health Check
    echo -e "${YELLOW}Backend Health Check:${NC}"
    if curl -f http://localhost:3001/api/health > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Backend Health: OK${NC}"
    else
        echo -e "${RED}❌ Backend Health: FAILED${NC}"
    fi
    
    # Frontend Health Check
    echo -e "${YELLOW}Frontend Health Check:${NC}"
    if curl -f http://localhost:3000 > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Frontend Health: OK${NC}"
    else
        echo -e "${RED}❌ Frontend Health: FAILED${NC}"
    fi
    
    # Database Health Check
    echo -e "${YELLOW}Database Health Check:${NC}"
    if sudo -u postgres pg_isready -h localhost > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Database Health: OK${NC}"
    else
        echo -e "${RED}❌ Database Health: FAILED${NC}"
    fi
    
    # Nginx Health Check
    echo -e "${YELLOW}Nginx Health Check:${NC}"
    if curl -f http://localhost > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Nginx Health: OK${NC}"
    else
        echo -e "${RED}❌ Nginx Health: FAILED${NC}"
    fi
    
    echo ""
}

show_system_performance() {
    echo -e "${BLUE}📈 SYSTEM PERFORMANCE${NC}"
    echo ""
    
    echo -e "${YELLOW}CPU Usage:${NC}"
    top -bn1 | grep "Cpu(s)" | head -5
    
    echo -e "${YELLOW}Memory Usage:${NC}"
    free -h
    
    echo -e "${YELLOW}Disk Usage:${NC}"
    df -h
    
    echo -e "${YELLOW}Network Connections:${NC}"
    netstat -tuln | grep LISTEN | head -10
    
    echo -e "${YELLOW}System Load:${NC}"
    uptime
    
    echo ""
}

show_security_status() {
    echo -e "${BLUE}🔒 SECURITY STATUS${NC}"
    echo ""
    
    echo -e "${YELLOW}Firewall Status:${NC}"
    sudo ufw status
    
    echo -e "${YELLOW}Fail2Ban Status:${NC}"
    sudo systemctl status fail2ban
    
    echo -e "${YELLOW}Open Ports:${NC}"
    netstat -tuln | grep LISTEN
    
    echo -e "${YELLOW}User Accounts:${NC}"
    cat /etc/passwd | grep -E "(advancia-payledger|root)" | head -5
    
    echo -e "${YELLOW}SSH Configuration:${NC}"
    sudo grep -E "PermitRootLogin|PasswordAuthentication" /etc/ssh/sshd_config
    
    echo ""
}

database_management() {
    echo -e "${BLUE}🗄️ DATABASE MANAGEMENT${NC}"
    echo ""
    echo "1. 📊 Database Status"
    echo "2. 💾 Backup Database"
    echo "3. 🔄 Restore Database"
    echo "4. 📈 Database Size"
    echo "5. 🔧 Database Configuration"
    echo "6. 🚪 Back to Main Menu"
    echo ""
    
    read -p "Enter your choice (1-6): " choice
    
    case $choice in
        1)
            echo -e "${YELLOW}DATABASE STATUS${NC}"
            sudo -u postgres psql -c "SELECT version();"
            sudo -u postgres psql -c "\l" | head -10
            ;;
        2)
            echo -e "${YELLOW}BACKUP DATABASE${NC}"
            "$SCRIPTS_DIR/backup-database.sh"
            ;;
        3)
            echo -e "${YELLOW}RESTORE DATABASE${NC}"
            read -p "Enter backup file path: " backup_file
            if [ -f "$backup_file" ]; then
                gunzip -c "$backup_file" | sudo -u postgres psql advancia_payledger
                echo "✅ Database restored"
            else
                echo "❌ Backup file not found"
            fi
            ;;
        4)
            echo -e "${YELLOW}DATABASE SIZE${NC}"
            sudo -u postgres psql -c "SELECT pg_size_pretty(pg_database_size('advancia_payledger));"
            ;;
        5)
            echo -e "${YELLOW}DATABASE CONFIGURATION${NC}"
            sudo -u postgres psql -c "\d" | head -10
            ;;
        6)
            return
            ;;
        *)
            echo "❌ Invalid choice"
            ;;
    esac
}

deploy_all_services() {
    echo -e "${GREEN}🚀 DEPLOYING ALL SERVICES${NC}"
    echo ""
    
    # Deploy Backend
    echo -e "${BLUE}Deploying Backend...${NC}"
    "$SCRIPTS_DIR/deploy-backend.sh"
    
    # Deploy Frontend
    echo -e "${BLUE}Deploying Frontend...${NC}"
    "$SCRIPTS_DIR/deploy-frontend.sh"
    
    echo -e "${GREEN}✅ ALL SERVICES DEPLOYED${NC}"
    echo ""
    show_service_status
}

show_system_information() {
    echo -e "${BLUE}📋 SYSTEM INFORMATION${NC}"
    echo ""
    
    echo -e "${YELLOW}System:${NC}"
    uname -a
    
    echo -e "${YELLOW}Ubuntu Version:${NC}"
    lsb_release -a
    
    echo -e "${YELLOW}Kernel Version:${NC}"
    uname -r
    
    echo -e "${YELLOW}Uptime:${NC}"
    uptime
    
    echo -e "${YELLOW}Disk Space:${NC}"
    df -h
    
    echo -e "${YELLOW}Memory:${NC}"
    free -h
    
    echo -e "${YELLOW}Network Interfaces:${NC}"
    ip addr show
    
    echo -e "${YELLOW}Services:${NC}"
    systemctl list-units --type=service --state=running | grep -E "(advancia-payledger|postgresql|nginx)" | head -10
    
    echo ""
}

# CREATOR'S MAIN MENU LOOP
main_menu() {
    while true; do
        show_menu
        read -p "Enter your choice (1-14): " choice
        
        case $choice in
            1)
                start_all_services
                ;;
            2)
                stop_all_services
                ;;
            3)
                restart_all_services
                ;;
            4)
                show_service_status
                ;;
            5)
                view_all_logs
                ;;
            6)
                backup_all_systems
                ;;
            7)
                update_all_systems
                ;;
            8)
                health_check_all_services
                ;;
            9)
                show_system_performance
                ;;
            10)
                show_security_status
                ;;
            11)
                database_management
                ;;
            12)
                deploy_all_services
                ;;
            13)
                show_system_information
                ;;
            14)
                echo -e "${GREEN}🚪 EXITING SYSTEM MANAGEMENT${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Invalid choice. Please try again.${NC}"
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
        echo ""
    done
}

# CREATOR'S SCRIPT EXECUTION
if [ "$1" = "start" ]; then
    start_all_services
elif [ "$1" = "stop" ]; then
    stop_all_services
elif [ "$1" = "restart" ]; then
    restart_all_services
elif [ "$1" = "status" ]; then
    show_service_status
elif [ "$1" = "logs" ]; then
    view_all_logs
elif [ "$1" = "backup" ]; then
    backup_all_systems
elif [1" = "update" ]; then
    update_all_systems
elif [ "$1" = "health" ]; then
    health_check_all_services
elif [ "$1" = "performance" ]; then
    show_system_performance
elif [1" = "security" ]; then
    show_security_status
elif [ "$1" = "database" ]; then
    database_management
elif [ "$1" = "deploy" ]; then
    deploy_all_services
elif [ "$1" = "info" ]; then
    show_system_information
else
    main_menu
fi
