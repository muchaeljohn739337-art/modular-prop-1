# Advancia Pay Ledger - Payment System Verification Script

Write-Host "🔍 Verifying Advancia Pay Ledger Payment Systems..." -ForegroundColor Cyan

# Check backend directory
$backendPath = "backend-clean"
if (Test-Path $backendPath) {
    Write-Host "✅ Backend directory found" -ForegroundColor Green
    Set-Location $backendPath
} else {
    Write-Host "❌ Backend directory not found" -ForegroundColor Red
    exit 1
}

# Check if .env file exists
if (Test-Path ".env") {
    Write-Host "✅ .env file found" -ForegroundColor Green
    
    # Read .env content
    $envContent = Get-Content ".env" -Raw
    
    # Check for required environment variables
    $requiredVars = @(
        "NOWPAYMENTS_API_KEY",
        "NOWPAYMENTS_PUBLIC_KEY", 
        "NOWPAYMENTS_IPN_SECRET",
        "ALCHEMY_API_KEY",
        "ALCHEMY_ETHEREUM_RPC",
        "STRIPE_SECRET_KEY"
    )
    
    Write-Host "`n📋 Environment Variables Check:" -ForegroundColor Yellow
    
    foreach ($var in $requiredVars) {
        if ($envContent -match "$var=") {
            Write-Host "✅ $var - Found" -ForegroundColor Green
        } else {
            Write-Host "❌ $var - Missing" -ForegroundColor Red
        }
    }
    
} else {
    Write-Host "❌ .env file not found" -ForegroundColor Red
    Write-Host "💡 Copy ENVIRONMENT_ADDITIONS.txt content to .env file" -ForegroundColor Yellow
}

# Check if payment service files exist
Write-Host "`n📁 Payment Services Check:" -ForegroundColor Yellow

$serviceFiles = @(
    "src/services/stripe.service.ts",
    "src/services/nowPaymentsService.ts", 
    "src/services/alchemy-pay.service.ts"
)

foreach ($file in $serviceFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file - Found" -ForegroundColor Green
    } else {
        Write-Host "❌ $file - Missing" -ForegroundColor Red
    }
}

# Check if payment routes exist
Write-Host "`n🛣️ Payment Routes Check:" -ForegroundColor Yellow

$routeFiles = @(
    "src/routes/payments.ts",
    "src/routes/payments/stripe-cards.routes.ts",
    "src/routes/crypto.ts"
)

foreach ($file in $routeFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file - Found" -ForegroundColor Green
    } else {
        Write-Host "❌ $file - Missing" -ForegroundColor Red
    }
}

Write-Host "`n🚀 Next Steps:" -ForegroundColor Cyan
Write-Host "1. Add missing environment variables to .env file" -ForegroundColor White
Write-Host "2. Configure webhooks in payment dashboards:" -ForegroundColor White
Write-Host "   - NOWPayments: https://advanciapayledger.com/api/payments/nowpayments/webhook" -ForegroundColor Gray
Write-Host "   - Stripe: https://advanciapayledger.com/api/payments/stripe/webhook" -ForegroundColor Gray
Write-Host "3. Restart backend: npm run dev" -ForegroundColor White
Write-Host "4. Test payment endpoints" -ForegroundColor White

Write-Host "`n✅ Payment system verification complete!" -ForegroundColor Green
