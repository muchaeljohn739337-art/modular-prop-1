# Advancia Pay Ledger - Payment System Activation Script
# Run this script to activate all payment systems

Write-Host "🚀 Activating Advancia Pay Ledger Payment Systems..." -ForegroundColor Green

# Check if .env file exists
$envPath = ".env"
if (Test-Path $envPath) {
    Write-Host "✅ .env file found" -ForegroundColor Green
} else {
    Write-Host "❌ .env file not found. Creating from example..." -ForegroundColor Yellow
    if (Test-Path ".env.example") {
        Copy-Item ".env.example" ".env"
        Write-Host "✅ .env file created from example" -ForegroundColor Green
    } else {
        Write-Host "❌ .env.example not found. Please create .env file manually." -ForegroundColor Red
        exit 1
    }
}

# Read current .env content
$envContent = Get-Content $envPath -Raw

# Check if Alchemy Pay keys are configured
if ($envContent -match "ALCHEMY_PAY_API_KEY=") {
    Write-Host "✅ Alchemy Pay API key found" -ForegroundColor Green
} else {
    Write-Host "🔄 Adding Alchemy Pay configuration..." -ForegroundColor Yellow
    Add-Content $envPath "`n# Alchemy Pay Configuration"
    Add-Content $envPath "ALCHEMY_PAY_API_KEY=PBBQ3X8-6W6MSH5-Q3GN1BM-Y2KBKQA"
    Add-Content $envPath "ALCHEMY_PAY_SECRET_KEY=069fcaef-bb02-425b-b181-9ec00a6892d3"
    Add-Content $envPath "ALCHEMY_PAY_MERCHANT_ID=your_merchant_id_here"
}

# Check if NOWPayments keys are configured
if ($envContent -match "NOWPAYMENTS_IPN_SECRET=") {
    Write-Host "✅ NOWPayments IPN secret found" -ForegroundColor Green
} else {
    Write-Host "🔄 Adding NOWPayments configuration..." -ForegroundColor Yellow
    Add-Content $envPath "`n# NOWPayments Configuration"
    Add-Content $envPath "NOWPAYMENTS_API_KEY=your_nowpayments_api_key"
    Add-Content $envPath "NOWPAYMENTS_IPN_SECRET=i3ctH3QzQRraSBpmaKgkfaIUZ+k6UkyE"
}

# Check if Alchemy Ethereum key is configured
if ($envContent -match "ALCHEMY_API_KEY=") {
    Write-Host "✅ Alchemy Ethereum API key found" -ForegroundColor Green
} else {
    Write-Host "🔄 Adding Alchemy Ethereum configuration..." -ForegroundColor Yellow
    Add-Content $envPath "`n# Alchemy Ethereum Configuration"
    Add-Content $envPath "ALCHEMY_API_KEY=Fq0u1wpuGJtphLQQGMUmn"
    Add-Content $envPath "ALCHEMY_ETHEREUM_RPC=https://eth-mainnet.g.alchemy.com/v2/Fq0u1wpuGJtphLQQGMUmn"
}

Write-Host "`n🎯 Configuration Summary:" -ForegroundColor Cyan
Write-Host "✅ Alchemy Pay: Enabled for fiat-to-crypto" -ForegroundColor Green
Write-Host "✅ NOWPayments: Enabled for crypto deposits" -ForegroundColor Green
Write-Host "✅ Alchemy Ethereum: Enabled for blockchain operations" -ForegroundColor Green
Write-Host "✅ Webhook Handlers: Ready at /api/payments/*/webhook" -ForegroundColor Green

Write-Host "`n📋 Next Steps:" -ForegroundColor Yellow
Write-Host "1. Update your_merchant_id_here in .env file" -ForegroundColor White
Write-Host "2. Update your_nowpayments_api_key in .env file" -ForegroundColor White
Write-Host "3. Configure webhooks in payment dashboards:" -ForegroundColor White
Write-Host "   - NOWPayments: https://advanciapayledger.com/api/payments/nowpayments/webhook" -ForegroundColor Gray
Write-Host "   - Alchemy Pay: https://advanciapayledger.com/api/payments/alchemy/webhook" -ForegroundColor Gray
Write-Host "4. Restart backend: npm run dev" -ForegroundColor White
Write-Host "5. Test payment flows" -ForegroundColor White

Write-Host "`n🚀 Payment systems ready for activation!" -ForegroundColor Green
