# Quick Deploy to VPS - PowerShell Script
# Run this script from Windows to deploy to your Hostinger VPS

$VPS_IP = "76.13.77.8"
$VPS_USER = "root"
$PROJECT_DIR = "advanciapayledger-new"
$DEPLOY_PACKAGE = "advancia-deploy.tar.gz"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Advancia PayLedger - VPS Deployment" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Package the project
Write-Host "[1/3] Packaging project..." -ForegroundColor Yellow
if (Test-Path $DEPLOY_PACKAGE) {
    Remove-Item $DEPLOY_PACKAGE -Force
}

tar -czf $DEPLOY_PACKAGE $PROJECT_DIR
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Package created: $DEPLOY_PACKAGE" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to create package" -ForegroundColor Red
    exit 1
}

# Step 2: Upload to VPS
Write-Host ""
Write-Host "[2/3] Uploading to VPS ($VPS_IP)..." -ForegroundColor Yellow
Write-Host "You will be prompted for the VPS password: gXF?5ZPRwVNRTv4"
Write-Host ""

scp $DEPLOY_PACKAGE ${VPS_USER}@${VPS_IP}:/root/
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Upload complete" -ForegroundColor Green
} else {
    Write-Host "✗ Upload failed" -ForegroundColor Red
    exit 1
}

# Step 3: Deploy on VPS
Write-Host ""
Write-Host "[3/3] Deploying on VPS..." -ForegroundColor Yellow
Write-Host "Connecting to VPS to extract and start containers..."
Write-Host ""

$DEPLOY_COMMANDS = @"
cd /root && \
tar -xzf $DEPLOY_PACKAGE && \
cd $PROJECT_DIR && \
echo '=== Installing Docker ===' && \
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh && \
echo '=== Installing Docker Compose ===' && \
apt-get update -qq && apt-get install -y docker-compose-plugin && \
echo '=== Setting up environment ===' && \
cp .env.template .env 2>/dev/null || cp .env.example .env 2>/dev/null || echo 'No env template found' && \
echo '=== Starting containers ===' && \
docker compose up -d --build && \
echo '=== Deployment complete ===' && \
echo '' && \
echo 'Services running:' && \
docker ps && \
echo '' && \
echo 'Access your application at:' && \
echo '  Frontend: http://$VPS_IP:3000' && \
echo '  Backend:  http://$VPS_IP:3001' && \
echo '' && \
echo 'View logs with: docker logs advancia-frontend -f'
"@

ssh ${VPS_USER}@${VPS_IP} $DEPLOY_COMMANDS

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Deployment Script Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Edit environment variables: ssh root@$VPS_IP 'nano /root/$PROJECT_DIR/.env'"
Write-Host "2. Check logs: ssh root@$VPS_IP 'docker logs advancia-backend -f'"
Write-Host "3. Visit: http://$VPS_IP:3000"
Write-Host ""
Write-Host "SECURITY: Change your VPS root password!" -ForegroundColor Red
