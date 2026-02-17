# PowerShell Deployment Helper
# Run this to upload files and deploy

$ServerIP = "147.182.193.11"
$Domain = "advanciapayledger.com"
$ProjectRoot = "c:\Users\mucha.DESKTOP-H7T9NPM\Downloads\mdsiles\myproject$new"

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
        scp "$ProjectRoot\deploy-all.sh" "root@${ServerIP}:/tmp/" 2>$null
        
        # Upload backend
        Write-Host "  - Uploading backend (this may take a minute)..." -ForegroundColor Cyan
        scp -r "$ProjectRoot\backend-clean\*" "root@${ServerIP}:/opt/backend/" 2>$null
        
        # Upload frontend
        Write-Host "  - Uploading frontend (this may take a minute)..." -ForegroundColor Cyan
        scp -r "$ProjectRoot\frontend-clean\*" "root@${ServerIP}:/opt/frontend/" 2>$null
        
        Write-Host ""
        Write-Host "✓ Files uploaded! Now running deployment script..." -ForegroundColor Green
        Write-Host ""
        
        # SSH and run script
        ssh "root@${ServerIP}" @"
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
        Write-Host "scp `"$ProjectRoot\deploy-all.sh`" `"root@${ServerIP}:/tmp/`"" -ForegroundColor Green
        Write-Host "scp -r `"$ProjectRoot\backend-clean\*`" `"root@${ServerIP}:/opt/backend/`"" -ForegroundColor Green
        Write-Host "scp -r `"$ProjectRoot\frontend-clean\*`" `"root@${ServerIP}:/opt/frontend/`"" -ForegroundColor Green
        Write-Host ""
        Write-Host "# Then SSH and run:" -ForegroundColor Cyan
        Write-Host "ssh root@$ServerIP" -ForegroundColor Green
        Write-Host "chmod +x /tmp/deploy-all.sh" -ForegroundColor Green
        Write-Host "/tmp/deploy-all.sh" -ForegroundColor Green
        Write-Host ""
    }
    
    "3" {
        Write-Host ""
        Write-Host "📤 Uploading files..." -ForegroundColor Yellow
        
        scp "$ProjectRoot\deploy-all.sh" "root@${ServerIP}:/tmp/"
        scp -r "$ProjectRoot\backend-clean\*" "root@${ServerIP}:/opt/backend/"
        scp -r "$ProjectRoot\frontend-clean\*" "root@${ServerIP}:/opt/frontend/"
        
        Write-Host ""
        Write-Host "✓ Files uploaded!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Cyan
        Write-Host "1. SSH to server: ssh root@$ServerIP" -ForegroundColor Green
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
