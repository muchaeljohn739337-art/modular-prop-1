# Ubuntu VPS Auto-Configuration Script
# Runs SSH commands on the VPS to install Docker and configure firewall

$VPS_IP = "76.13.77.8"
$VPS_USER = "root"
$VPS_PASS = "gXF?5ZPRwVNRTv4"

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Configuring Ubuntu VPS at $VPS_IP" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Setup commands to run on VPS
$Commands = @"
export DEBIAN_FRONTEND=noninteractive && \
apt-get update -qq && \
apt-get upgrade -y -qq && \
apt-get install -y curl git wget nano ufw net-tools && \
curl -fsSL https://get.docker.com -o /tmp/get-docker.sh && \
sh /tmp/get-docker.sh && \
rm /tmp/get-docker.sh && \
apt-get install -y docker-compose-plugin && \
systemctl enable docker && \
systemctl start docker && \
ufw --force enable && \
ufw allow 22/tcp && \
ufw allow 80/tcp && \
ufw allow 443/tcp && \
ufw allow 3000/tcp && \
ufw allow 3001/tcp && \
ufw allow 5432/tcp && \
mkdir -p /opt/advancia && \
echo "" && \
echo "=== Configuration Complete ===" && \
echo "Docker version:" && docker --version && \
echo "Docker Compose version:" && docker compose version && \
echo "Firewall status:" && ufw status numbered
"@

# Try using plink (PuTTY) if available
if (Get-Command plink -ErrorAction SilentlyContinue) {
    Write-Host "Using PuTTY plink for automated SSH..." -ForegroundColor Yellow
    echo y | plink -ssh -pw $VPS_PASS ${VPS_USER}@${VPS_IP} $Commands
} else {
    Write-Host "PuTTY plink not found. Trying alternative method..." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "MANUAL STEPS REQUIRED:" -ForegroundColor Red
    Write-Host "1. Open PuTTY or your SSH client"
    Write-Host "2. Connect to: ${VPS_USER}@${VPS_IP}"
    Write-Host "3. Password: $VPS_PASS"
    Write-Host "4. Run this command:"
    Write-Host ""
    Write-Host $Commands -ForegroundColor Green
    Write-Host ""
    Write-Host "OR download PuTTY from https://www.putty.org/ and run this script again"
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
