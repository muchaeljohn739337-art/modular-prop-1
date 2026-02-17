# Advancia Pay Ledger - Environment Configuration

## 🎯 Required Environment Variables

Add these to your `.env` file in `backend-clean/`:

### Alchemy Pay (Fiat to Crypto Payments)
```bash
ALCHEMY_PAY_API_KEY=PBBQ3X8-6W6MSH5-Q3GN1BM-Y2KBKQA
ALCHEMY_PAY_SECRET_KEY=069fcaef-bb02-425b-b181-9ec00a6892d3
ALCHEMY_PAY_MERCHANT_ID=your_merchant_id_here
ALCHEMY_PAY_WEBHOOK_URL=https://advanciapayledger.com/api/payments/alchemy/webhook
```

### NOWPayments (Crypto Deposits)
```bash
NOWPAYMENTS_API_KEY=your_nowpayments_api_key
NOWPAYMENTS_IPN_SECRET=i3ctH3QzQRraSBpmaKgkfaIUZ+k6UkyE
NOWPAYMENTS_WEBHOOK_URL=https://advanciapayledger.com/api/payments/nowpayments/webhook
```

### Alchemy Ethereum (Smart Wallets & Blockchain)
```bash
ALCHEMY_API_KEY=Fq0u1wpuGJtphLQQGMUmn
ALCHEMY_ETHEREUM_RPC=https://eth-mainnet.g.alchemy.com/v2/Fq0u1wpuGJtphLQQGMUmn
```

## ✅ Current Status

### Completed Services:
- ✅ Alchemy Pay service enabled
- ✅ NOWPayments webhook handler: `/api/payments/nowpayments/webhook`
- ✅ Alchemy Pay webhook handler: `/api/payments/alchemy/webhook`
- ✅ Payment routes configured

### Ready to Activate:
- 🔄 Environment variables need to be added
- 🔄 Webhook URLs need dashboard configuration

## 🚀 Activation Steps

1. **Add API Keys to .env**
   - Copy the variables above to your `.env` file
   - Replace `your_merchant_id_here` with actual Alchemy Pay merchant ID
   - Replace `your_nowpayments_api_key` with actual NOWPayments API key

2. **Configure Webhooks**
   - NOWPayments Dashboard: Set webhook to `https://advanciapayledger.com/api/payments/nowpayments/webhook`
   - Alchemy Pay Dashboard: Set webhook to `https://advanciapayledger.com/api/payments/alchemy/webhook`

3. **Restart Backend**
   ```bash
   cd backend-clean
   npm run dev
   ```

4. **Test Payment Flows**
   - Test Alchemy Pay fiat-to-crypto conversion
   - Test NOWPayments crypto deposit processing
   - Verify webhook endpoints are receiving events

## 📋 API Endpoints Ready

### Alchemy Pay
- `POST /api/payments/alchemy/create` - Create payment
- `GET /api/payments/alchemy/status/:orderId` - Check status
- `POST /api/payments/alchemy/webhook` - Webhook handler

### NOWPayments
- `POST /api/payments/nowpayments/webhook` - Webhook handler
- Existing crypto endpoints in `/api/crypto/`

## 🔧 What This Enables

1. **Fiat to Crypto Conversion** - Users can buy crypto with fiat
2. **Crypto Deposits** - Users can deposit crypto directly
3. **Automatic Balance Updates** - Webhooks update user balances
4. **Transaction Tracking** - All payments recorded in database
5. **Multi-Currency Support** - USD, EUR, BTC, ETH, USDT, USDC, etc.

## ⚡ Next Priority

1. **IMMEDIATE**: Add environment variables to `.env`
2. **HIGH**: Configure webhook URLs in dashboards
3. **MEDIUM**: Test payment flows
4. **LOW**: Deploy to production

The backend is ready - just needs the API keys to activate!
