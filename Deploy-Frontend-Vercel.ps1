# 🚀 Advancia PayLedger - Vercel Frontend Deployment Script
# This script deploys the frontend to Vercel

Write-Host "`n🚀 ADVANCIA PAYLEDGER - VERCEL DEPLOYMENT`n" -ForegroundColor Cyan
Write-Host "=========================================`n" -ForegroundColor Cyan

# Check prerequisites
Write-Host "Checking prerequisites..." -ForegroundColor Yellow

# Check Node.js
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Node.js not found. Please install Node.js from https://nodejs.org" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Node.js found: $(node --version)" -ForegroundColor Green

# Check npm
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "❌ npm not found" -ForegroundColor Red
    exit 1
}
Write-Host "✓ npm found: $(npm --version)" -ForegroundColor Green

# Check Git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git not found. Please install Git" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Git found: $(git --version | Select-Object -First 1)" -ForegroundColor Green

# Navigate to frontend directory
Write-Host "`nNavigating to frontend directory..." -ForegroundColor Yellow
cd frontend-clean

# Check if already a Git repo
if (-not (Test-Path .git)) {
    Write-Host "Initializing Git repository..." -ForegroundColor Yellow
    git init
    git add .
    git commit -m "Initial commit"
}

# Install dependencies
Write-Host "`nInstalling dependencies..." -ForegroundColor Yellow
npm install

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Dependencies installed" -ForegroundColor Green

# Build project
Write-Host "`nBuilding Next.js project..." -ForegroundColor Yellow
npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Build successful" -ForegroundColor Green

# Install Vercel CLI
Write-Host "`nInstalling Vercel CLI..." -ForegroundColor Yellow
npm install -g vercel

# Deploy to Vercel
Write-Host "`n" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "Ready to deploy to Vercel" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "`nPlease ensure you have:" -ForegroundColor Yellow
Write-Host "  1. Vercel account (https://vercel.com)" -ForegroundColor White
Write-Host "  2. GitHub repository pushed" -ForegroundColor White
Write-Host "  3. Environment variables configured in Vercel dashboard" -ForegroundColor White
Write-Host "`nEnvironment Variables to set in Vercel:" -ForegroundColor Yellow
Write-Host "  - NEXT_PUBLIC_API_URL=https://api.advanciapayledger.com" -ForegroundColor White
Write-Host "  - NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live_..." -ForegroundColor White
Write-Host "  - NEXT_PUBLIC_APP_NAME=Advancia PayLedger" -ForegroundColor White
Write-Host "  - NEXT_PUBLIC_APP_VERSION=2.0.0" -ForegroundColor White

$response = Read-Host "`nReady to deploy? (yes/no)"

if ($response -eq "yes") {
    Write-Host "`nDeploying to Vercel..." -ForegroundColor Yellow
    vercel --prod
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n✓ Deployment successful!" -ForegroundColor Green
        Write-Host "`nAccess your application at:" -ForegroundColor Green
        Write-Host "  - https://advanciapayledger.vercel.app" -ForegroundColor White
        Write-Host "  - https://yourdomain.vercel.app (after DNS configuration)" -ForegroundColor White
    } else {
        Write-Host "`n❌ Deployment failed" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "`nDeployment cancelled" -ForegroundColor Yellow
}

Write-Host "`nNext steps:" -ForegroundColor Green
Write-Host "  1. Configure custom domain in Vercel dashboard" -ForegroundColor White
Write-Host "  2. Update DNS records to point to Vercel" -ForegroundColor White
Write-Host "  3. Verify SSL certificate is active" -ForegroundColor White
Write-Host "  4. Test API connectivity" -ForegroundColor White
Write-Host "  5. Enable analytics in Vercel" -ForegroundColor White

Write-Host "`n✅ Deployment script complete!`n" -ForegroundColor Green

