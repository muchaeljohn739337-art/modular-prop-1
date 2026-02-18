'use client';

import { useState, useEffect, FormEvent } from 'react';
import { loadStripe, Stripe } from '@stripe/stripe-js';
import {
  Elements,
  PaymentElement,
  useStripe,
  useElements,
} from '@stripe/react-stripe-js';

const API = process.env.NEXT_PUBLIC_API_URL || 'https://api.advanciapayledger.com';

function CheckoutForm({ amount, onSuccess }: { amount: number; onSuccess: () => void }) {
  const stripe = useStripe();
  const elements = useElements();
  const [error, setError] = useState<string | null>(null);
  const [processing, setProcessing] = useState(false);

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    if (!stripe || !elements) return;

    setProcessing(true);
    setError(null);

    const { error: submitError } = await stripe.confirmPayment({
      elements,
      confirmParams: {
        return_url: `${window.location.origin}/payments?success=true`,
      },
    });

    if (submitError) {
      setError(submitError.message || 'Payment failed');
      setProcessing(false);
    } else {
      onSuccess();
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <PaymentElement />
      {error && (
        <div className="p-3 bg-red-50 text-red-700 rounded-lg text-sm">{error}</div>
      )}
      <button
        type="submit"
        disabled={!stripe || processing}
        className="w-full bg-blue-600 text-white py-3 px-4 rounded-lg font-medium hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
      >
        {processing ? 'Processing...' : `Pay $${amount.toFixed(2)}`}
      </button>
    </form>
  );
}

export default function PaymentsPage() {
  const [token, setToken] = useState<string | null>(null);
  const [stripePromise, setStripePromise] = useState<Promise<Stripe | null> | null>(null);
  const [clientSecret, setClientSecret] = useState<string | null>(null);
  const [amount, setAmount] = useState('25.00');
  const [currency, setCurrency] = useState('usd');
  const [loading, setLoading] = useState(false);
  const [success, setSuccess] = useState(false);
  const [paymentMode, setPaymentMode] = useState<'stripe' | 'crypto'>('stripe');
  const [cryptoCurrency, setCryptoCurrency] = useState('BTC');
  const [cryptoAddress, setCryptoAddress] = useState('');
  const [cryptoResult, setCryptoResult] = useState<{ txHash: string; status: string } | null>(null);

  useEffect(() => {
    const t = localStorage.getItem('token');
    setToken(t);

    // Load Stripe config
    if (t) {
      fetch(`${API}/api/payments/config`, {
        headers: { Authorization: `Bearer ${t}` },
      })
        .then((r) => r.json())
        .then((data) => {
          if (data.publishableKey) {
            setStripePromise(loadStripe(data.publishableKey));
          }
        })
        .catch(console.error);
    }

    // Check for success redirect
    const params = new URLSearchParams(window.location.search);
    if (params.get('success') === 'true') {
      setSuccess(true);
    }
  }, []);

  const createPaymentIntent = async () => {
    if (!token) return;
    setLoading(true);
    try {
      const res = await fetch(`${API}/api/payments/create-intent`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({
          amount: parseFloat(amount),
          currency,
        }),
      });
      const data = await res.json();
      if (data.clientSecret) {
        setClientSecret(data.clientSecret);
      }
    } catch (err) {
      console.error('Failed to create payment intent:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleCryptoPayment = async () => {
    if (!token || !cryptoAddress) return;
    setLoading(true);
    try {
      const res = await fetch(`${API}/api/payments/crypto`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({
          currency: cryptoCurrency,
          amount: parseFloat(amount),
          toAddress: cryptoAddress,
        }),
      });
      const data = await res.json();
      setCryptoResult(data);
    } catch (err) {
      console.error('Crypto payment failed:', err);
    } finally {
      setLoading(false);
    }
  };

  if (!token) {
    return (
      <div className="max-w-lg mx-auto mt-20 p-8 bg-white rounded-xl shadow text-center">
        <h1 className="text-2xl font-bold text-gray-900 mb-4">Payments</h1>
        <p className="text-gray-600 mb-6">Please sign in to make payments.</p>
        <a href="/login" className="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700">
          Sign In
        </a>
      </div>
    );
  }

  if (success) {
    return (
      <div className="max-w-lg mx-auto mt-20 p-8 bg-white rounded-xl shadow text-center">
        <div className="text-5xl mb-4">&#10003;</div>
        <h1 className="text-2xl font-bold text-green-700 mb-2">Payment Successful!</h1>
        <p className="text-gray-600 mb-6">Your payment has been processed successfully.</p>
        <a href="/dashboard" className="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700">
          Back to Dashboard
        </a>
      </div>
    );
  }

  return (
    <div className="max-w-2xl mx-auto mt-10 px-4">
      <h1 className="text-3xl font-bold text-gray-900 mb-8">Make a Payment</h1>

      {/* Payment Mode Toggle */}
      <div className="flex gap-2 mb-8">
        <button
          onClick={() => setPaymentMode('stripe')}
          className={`flex-1 py-3 px-4 rounded-lg font-medium transition-colors ${
            paymentMode === 'stripe'
              ? 'bg-blue-600 text-white'
              : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
          }`}
        >
          Card Payment
        </button>
        <button
          onClick={() => setPaymentMode('crypto')}
          className={`flex-1 py-3 px-4 rounded-lg font-medium transition-colors ${
            paymentMode === 'crypto'
              ? 'bg-blue-600 text-white'
              : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
          }`}
        >
          Crypto Payment
        </button>
      </div>

      {/* Amount Input */}
      <div className="bg-white rounded-xl shadow p-6 mb-6">
        <label className="block text-sm font-medium text-gray-700 mb-2">Amount</label>
        <div className="flex gap-3">
          <div className="relative flex-1">
            <span className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-500">$</span>
            <input
              type="number"
              step="0.01"
              min="0.50"
              value={amount}
              onChange={(e) => setAmount(e.target.value)}
              className="w-full pl-8 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>
          {paymentMode === 'stripe' && (
            <select
              value={currency}
              onChange={(e) => setCurrency(e.target.value)}
              className="px-4 py-3 border border-gray-300 rounded-lg bg-white"
            >
              <option value="usd">USD</option>
              <option value="eur">EUR</option>
              <option value="gbp">GBP</option>
            </select>
          )}
        </div>
      </div>

      {/* Stripe Card Payment */}
      {paymentMode === 'stripe' && (
        <div className="bg-white rounded-xl shadow p-6">
          {!clientSecret ? (
            <button
              onClick={createPaymentIntent}
              disabled={loading || !parseFloat(amount)}
              className="w-full bg-blue-600 text-white py-3 px-4 rounded-lg font-medium hover:bg-blue-700 disabled:opacity-50 transition-colors"
            >
              {loading ? 'Setting up payment...' : 'Continue to Payment'}
            </button>
          ) : stripePromise ? (
            <Elements stripe={stripePromise} options={{ clientSecret }}>
              <CheckoutForm amount={parseFloat(amount)} onSuccess={() => setSuccess(true)} />
            </Elements>
          ) : (
            <div className="text-center py-8 text-gray-500">
              <p>Stripe not configured. Contact support.</p>
            </div>
          )}
        </div>
      )}

      {/* Crypto Payment */}
      {paymentMode === 'crypto' && (
        <div className="bg-white rounded-xl shadow p-6 space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Cryptocurrency</label>
            <select
              value={cryptoCurrency}
              onChange={(e) => setCryptoCurrency(e.target.value)}
              className="w-full px-4 py-3 border border-gray-300 rounded-lg bg-white"
            >
              <option value="BTC">Bitcoin (BTC)</option>
              <option value="ETH">Ethereum (ETH)</option>
              <option value="USDT">Tether (USDT)</option>
              <option value="USDC">USD Coin (USDC)</option>
            </select>
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Recipient Address</label>
            <input
              type="text"
              value={cryptoAddress}
              onChange={(e) => setCryptoAddress(e.target.value)}
              placeholder="0x... or bc1..."
              className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>
          <button
            onClick={handleCryptoPayment}
            disabled={loading || !cryptoAddress || !parseFloat(amount)}
            className="w-full bg-orange-600 text-white py-3 px-4 rounded-lg font-medium hover:bg-orange-700 disabled:opacity-50 transition-colors"
          >
            {loading ? 'Processing...' : `Send ${cryptoCurrency}`}
          </button>

          {cryptoResult && (
            <div className="mt-4 p-4 bg-green-50 rounded-lg">
              <p className="text-sm font-medium text-green-800">Transaction Submitted</p>
              <p className="text-xs text-green-600 mt-1 break-all">TX: {cryptoResult.txHash}</p>
              <p className="text-xs text-green-600">Status: {cryptoResult.status}</p>
            </div>
          )}
        </div>
      )}
    </div>
  );
}
