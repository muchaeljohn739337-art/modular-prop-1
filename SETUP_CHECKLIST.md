# Advancia Pay Ledger - Setup Checklist

## ✅ Completed
- [x] Alchemy API key configured and tested
- [x] NOWPayments webhook handler added to `/api/payments/nowpayments/webhook`
- [x] Alchemy Pay service enabled with API credentials
- [x] Backend payment routes configured

## 🔄 In Progress
- [ ] Smart wallets app creation (dependency conflicts to resolve)

## ❌ Still Needed

### Environment Variables
Add these to your `.env` file:

```bash
# Alchemy Pay (Fiat to Crypto)
ALCHEMY_PAY_API_KEY=PBBQ3X8-6W6MSH5-Q3GN1BM-Y2KBKQA
ALCHEMY_PAY_SECRET_KEY=069fcaef-bb02-425b-b181-9ec00a6892d3
ALCHEMY_PAY_MERCHANT_ID=your_merchant_id_here

# NOWPayments (Crypto Deposits)
NOWPAYMENTS_API_KEY=your_nowpayments_api_key
NOWPAYMENTS_IPN_SECRET=i3ctH3QzQRraSBpmaKgkfaIUZ+k6UkyE

# Alchemy Ethereum (for Smart Wallets)
ALCHEMY_API_KEY=Fq0u1wpuGJtphLQQGMUmn
```

### Webhook URLs to Configure
1. **NOWPayments Dashboard**: `https://advanciapayledger.com/api/payments/nowpayments/webhook`
2. **Alchemy Pay Dashboard**: `https://advanciapayledger.com/api/payments/alchemy/webhook`

### Smart Wallets App
- Create app with compatible dependencies
- Configure with Alchemy API key
- Integrate with existing Advancia Pay Ledger backend

## 🚀 Next Actions
1. Fix smart wallets app dependency conflicts
2. Add environment variables to `.env`
3. Configure webhook URLs in respective dashboards
4. Test payment flows
5. Deploy smart wallets app

## 📋 Priority Order
1. **High**: Environment variables configuration
2. **High**: Smart wallets app creation
3. **Medium**: Webhook URL configuration
4. **Low**: Testing and deployment
