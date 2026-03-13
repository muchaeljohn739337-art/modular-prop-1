# PowerShell Deployment Helper
# Run this to upload files and deploy

$ServerHost = if ($env:DEPLOY_HOST) { $env:DEPLOY_HOST } else { Read-Host "Enter target VPS host or IP" }
$DeployUser = if ($env:DEPLOY_USER) { $env:DEPLOY_USER } else { "root" }
$Domain = if ($env:DEPLOY_DOMAIN) { $env:DEPLOY_DOMAIN } else { "advanciapayledger.com" }
$ProjectRoot = if ($env:PROJECT_ROOT) { $env:PROJECT_ROOT } else { (Get-Location).Path }
$TargetRoot = if ($env:DEPLOY_TARGET_ROOT) { $env:DEPLOY_TARGET_ROOT } else { "/opt/advancia-payledger" }

if ([string]::IsNullOrWhiteSpace($ServerHost)) {
    Write-Host "Target VPS host is required" -ForegroundColor Red
    exit 1
}

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "ADVANCIA PAYLEDGER - DEPLOYMENT HELPER" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Check if files exist
Write-Host "📋 Checking files..." -ForegroundColor Yellow
$files = @(
    @{Name="backend-clean"; Path="$ProjectRoot\backend-clean"},
    @{Name="frontend-clean"; Path="$ProjectRoot\frontend-clean"},
    @{Name="deploy-all.sh"; Path="$ProjectRoot\deploy-all.sh"}
)

foreach ($file in $files) {
    if (Test-Path $file.Path) {
        Write-Host "  ✓ $($file.Name)" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $($file.Name) NOT FOUND" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "🚀 DEPLOYMENT OPTIONS:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Full Automated Deploy (Recommended)" -ForegroundColor Yellow
Write-Host "   - Uploads all files"
Write-Host "   - Runs deployment script"
Write-Host "   - Verifies everything"
Write-Host ""
Write-Host "2. Manual Upload & Deploy" -ForegroundColor Yellow
Write-Host "   - Upload files manually"
Write-Host "   - Run script on server"
Write-Host ""
Write-Host "3. Upload Only" -ForegroundColor Yellow
Write-Host "   - Just transfer files"
Write-Host "   - You'll run script manually"
Write-Host ""

$choice = Read-Host "Select option (1-3)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "📤 Starting full deployment..." -ForegroundColor Yellow
        
        # Upload deployment script
        Write-Host "  - Uploading deploy-all.sh..." -ForegroundColor Cyan
            scp "$ProjectRoot\deploy-all.sh" "${DeployUser}@${ServerHost}:/tmp/" 2>$null
        
        # Upload backend
        Write-Host "  - Uploading backend (this may take a minute)..." -ForegroundColor Cyan
            scp -r "$ProjectRoot\backend-clean\*" "${DeployUser}@${ServerHost}:${TargetRoot}/backend/" 2>$null
        
        # Upload frontend
        Write-Host "  - Uploading frontend (this may take a minute)..." -ForegroundColor Cyan
            scp -r "$ProjectRoot\frontend-clean\*" "${DeployUser}@${ServerHost}:${TargetRoot}/frontend/" 2>$null
        
        Write-Host ""
        Write-Host "✓ Files uploaded! Now running deployment script..." -ForegroundColor Green
        Write-Host ""
        
        # SSH and run script
        ssh "${DeployUser}@${ServerHost}" @"
chmod +x /tmp/deploy-all.sh
/tmp/deploy-all.sh
"@
        
        Write-Host ""
        Write-Host "✨ DEPLOYMENT COMPLETE!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Your application is now running at:" -ForegroundColor Green
        Write-Host "  - Frontend: https://$Domain" -ForegroundColor Cyan
        Write-Host "  - API: https://api.$Domain" -ForegroundColor Cyan
        Write-Host ""
    }
    
    "2" {
        Write-Host ""
        Write-Host "📤 Manual Upload - Copy these commands:" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "# From PowerShell:" -ForegroundColor Cyan
        Write-Host "scp `"$ProjectRoot\deploy-all.sh`" `"${DeployUser}@${ServerHost}:/tmp/`"" -ForegroundColor Green
        Write-Host "scp -r `"$ProjectRoot\backend-clean\*`" `"${DeployUser}@${ServerHost}:${TargetRoot}/backend/`"" -ForegroundColor Green
        Write-Host "scp -r `"$ProjectRoot\frontend-clean\*`" `"${DeployUser}@${ServerHost}:${TargetRoot}/frontend/`"" -ForegroundColor Green
        Write-Host ""
        Write-Host "# Then SSH and run:" -ForegroundColor Cyan
        Write-Host "ssh ${DeployUser}@$ServerHost" -ForegroundColor Green
        Write-Host "chmod +x /tmp/deploy-all.sh" -ForegroundColor Green
        Write-Host "/tmp/deploy-all.sh" -ForegroundColor Green
        Write-Host ""
    }
    
    "3" {
        Write-Host ""
        Write-Host "📤 Uploading files..." -ForegroundColor Yellow
        
        scp "$ProjectRoot\deploy-all.sh" "${DeployUser}@${ServerHost}:/tmp/"
        scp -r "$ProjectRoot\backend-clean\*" "${DeployUser}@${ServerHost}:${TargetRoot}/backend/"
        scp -r "$ProjectRoot\frontend-clean\*" "${DeployUser}@${ServerHost}:${TargetRoot}/frontend/"
        
        Write-Host ""
        Write-Host "✓ Files uploaded!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Cyan
        Write-Host "1. SSH to server: ssh ${DeployUser}@$ServerHost" -ForegroundColor Green
        Write-Host "2. Run: /tmp/deploy-all.sh" -ForegroundColor Green
        Write-Host ""
    }
    
    default {
        Write-Host "Invalid option" -ForegroundColor Red
    }
}

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Done!" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
