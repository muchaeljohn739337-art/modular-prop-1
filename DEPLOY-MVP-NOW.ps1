# ==============================================================================
# DEPLOY MVP NOW - ADVANCIA PAY LEDGER (PowerShell Version)
# ==============================================================================

Write-Host "╔═══════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                   ║" -ForegroundColor Cyan
Write-Host "║     🚀  ADVANCIA PAY LEDGER MVP DEPLOYMENT  🚀    ║" -ForegroundColor Cyan
Write-Host "║                                                   ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "📍 Starting MVP deployment..." -ForegroundColor Yellow
Write-Host ""

# Check if we're in the right directory
if (-not (Test-Path "backend-clean\package.json")) {
    Write-Host "❌ Error: backend-clean\package.json not found" -ForegroundColor Red
    Write-Host "Please run this script from the project root directory" -ForegroundColor Red
    exit 1
}

# Backend Deployment
Write-Host "🔧 Step 1: Deploying Backend..." -ForegroundColor Green
Set-Location backend-clean

# Install dependencies
Write-Host "📦 Installing backend dependencies..." -ForegroundColor Blue
npm install

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Backend dependency installation failed" -ForegroundColor Red
    Set-Location ..
    exit 1
}

# Build the project
Write-Host "🏗️  Building backend..." -ForegroundColor Blue
npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Backend build failed" -ForegroundColor Red
    Set-Location ..
    exit 1
}

# Start the backend server
Write-Host "🚀 Starting backend server..." -ForegroundColor Blue
Start-Job -ScriptBlock { Set-Location backend-clean; npm run start:prod } -Name "Backend"

Set-Location ..

# Frontend Deployment
Write-Host "🎨 Step 2: Deploying Frontend..." -ForegroundColor Green
Set-Location frontend-clean

# Install dependencies
Write-Host "📦 Installing frontend dependencies..." -ForegroundColor Blue
npm install

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Frontend dependency installation failed" -ForegroundColor Red
    Set-Location ..
    exit 1
}

# Build the frontend
Write-Host "🏗️  Building frontend..." -ForegroundColor Blue
npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Frontend build failed" -ForegroundColor Red
    Set-Location ..
    exit 1
}

# Start the frontend
Write-Host "🚀 Starting frontend..." -ForegroundColor Blue
Start-Job -ScriptBlock { Set-Location frontend-clean; npm start } -Name "Frontend"

Set-Location ..

# Mobile App Setup
Write-Host "📱 Step 3: Setting up Mobile App..." -ForegroundColor Green
if (-not (Test-Path "advancia-expo-app")) {
    Write-Host "📱 Creating Expo app..." -ForegroundColor Blue
    npx create-expo-app advancia-expo-app --template blank
}

Set-Location advancia-expo-app

# Install mobile dependencies
Write-Host "📦 Installing mobile dependencies..." -ForegroundColor Blue
npm install

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Mobile dependency installation failed" -ForegroundColor Red
    Set-Location ..
    exit 1
}

Write-Host "🚀 Starting mobile development server..." -ForegroundColor Blue
Start-Job -ScriptBlock { Set-Location advancia-expo-app; npx expo start } -Name "Mobile"

Set-Location ..

# Wait a moment for services to start
Start-Sleep -Seconds 10

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                   ║" -ForegroundColor Cyan
Write-Host "║           ✅  DEPLOYMENT COMPLETE!  ✅            ║" -ForegroundColor Cyan
Write-Host "║                                                   ║" -ForegroundColor Cyan
Write-Host "║         YOUR MVP IS NOW RUNNING! 🚀               ║" -ForegroundColor Cyan
Write-Host "║                                                   ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "🌐 Backend API:" -ForegroundColor Green
Write-Host "  ✓ http://localhost:3001/health" -ForegroundColor White
Write-Host "  ✓ http://localhost:3001/api/stats" -ForegroundColor White
Write-Host ""
Write-Host "🖥️  Frontend:" -ForegroundColor Green
Write-Host "  ✓ http://localhost:3000" -ForegroundColor White
Write-Host ""
Write-Host "📱 Mobile App:" -ForegroundColor Green
Write-Host "  ✓ Expo development server running" -ForegroundColor White
Write-Host "  ✓ Scan QR code with Expo Go app" -ForegroundColor White
Write-Host ""
Write-Host "Server Management:" -ForegroundColor Yellow
Write-Host "  Backend: Running as background job" -ForegroundColor White
Write-Host "  Frontend: Running as background job" -ForegroundColor White
Write-Host "  Mobile: Running as background job" -ForegroundColor White
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. ✓ Backend running" -ForegroundColor Green
Write-Host "  2. ✓ Frontend running" -ForegroundColor Green
Write-Host "  3. ✓ Mobile app ready" -ForegroundColor Green
Write-Host ""
Write-Host "🎉 YOUR MVP ECOSYSTEM IS LIVE! 🎉" -ForegroundColor Magenta
Write-Host ""
Write-Host "To check job status:" -ForegroundColor Yellow
Write-Host "  Get-Job" -ForegroundColor White
Write-Host ""
Write-Host "To stop all services:" -ForegroundColor Yellow
Write-Host "  Stop-Job -Name Backend,Frontend,Mobile" -ForegroundColor White
Write-Host "  Remove-Job -Name Backend,Frontend,Mobile" -ForegroundColor White
Write-Host ""

# Show job status
Write-Host "Current Job Status:" -ForegroundColor Yellow
Get-Job | Format-Table -AutoSize
