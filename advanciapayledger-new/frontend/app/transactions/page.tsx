'use client';

import { useEffect, useState } from 'react';
import { useAuth } from '@/app/hooks/useAuth';
import AuthForm from '@/app/components/AuthForm';
import { transactionApi, walletApi } from '@/app/lib/api';

interface Transaction {
  id: string;
  type: string;
  currency: string;
  amount: number;
  fee: number;
  status: string;
  toAddress?: string;
  createdAt?: string;
}

const statusColor: Record<string, string> = {
  completed: 'bg-green-100 text-green-700',
  pending: 'bg-yellow-100 text-yellow-700',
  failed: 'bg-red-100 text-red-700',
};

export default function TransactionsPage() {
  const { user, isAuthenticated, isLoading } = useAuth();
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [loading, setLoading] = useState(false);
  const [showSend, setShowSend] = useState(false);
  const [sending, setSending] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [currencies, setCurrencies] = useState<string[]>([]);
  const [form, setForm] = useState({
    type: 'send',
    currency: '',
    amount: '',
    toAddress: '',
  });

  useEffect(() => {
    if (!isAuthenticated) return;
    loadData();
  }, [isAuthenticated]);

  async function loadData() {
    setLoading(true);
    const [txRes, walletRes] = await Promise.all([
      transactionApi.getTransactions(),
      walletApi.getWallets(),
    ]);
    setTransactions(txRes.data?.transactions || []);
    const curs = (walletRes.data?.wallets || []).map(
      (w: any) => w.currency as string
    );
    setCurrencies(curs);
    if (curs.length > 0 && !form.currency) {
      setForm((f) => ({ ...f, currency: curs[0] }));
    }
    setLoading(false);
  }

  async function handleSend(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    setSuccess('');
    setSending(true);
    const res = await transactionApi.createTransaction(
      form.type as any,
      form.currency,
      Number(form.amount),
      form.toAddress || undefined
    );
    setSending(false);
    if (res.error) {
      setError(res.error);
    } else {
      setSuccess('Transaction created!');
      setForm((f) => ({ ...f, amount: '', toAddress: '' }));
      setShowSend(false);
      loadData();
    }
  }

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-lg text-gray-600">Loading...</div>
      </div>
    );
  }

  if (!isAuthenticated || !user) {
    return (
      <div className="min-h-screen bg-gray-50 py-10 px-4">
        <div className="max-w-3xl mx-auto">
          <h1 className="text-2xl font-bold text-gray-900 mb-2">Transactions</h1>
          <p className="text-gray-600 mb-6">Sign in to view your transaction history.</p>
          <AuthForm redirectTo="/transactions" />
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 py-10 px-4">
      <div className="max-w-5xl mx-auto space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Transactions</h1>
            <p className="text-gray-600 text-sm">View history and send funds</p>
          </div>
          <button
            onClick={() => setShowSend(!showSend)}
            className="px-4 py-2 rounded-lg bg-blue-600 text-white font-medium hover:bg-blue-700 transition"
          >
            {showSend ? 'Cancel' : '+ New Transaction'}
          </button>
        </div>

        {/* Messages */}
        {error && (
          <div className="p-3 bg-red-50 border border-red-200 rounded-lg text-red-700 text-sm">
            {error}
          </div>
        )}
        {success && (
          <div className="p-3 bg-green-50 border border-green-200 rounded-lg text-green-700 text-sm">
            {success}
          </div>
        )}

        {/* Send form */}
        {showSend && (
          <div className="bg-white border border-gray-200 rounded-xl p-6">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">
              New Transaction
            </h2>
            <form onSubmit={handleSend} className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Type
                </label>
                <select
                  value={form.type}
                  onChange={(e) => setForm({ ...form, type: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                >
                  <option value="send">Send</option>
                  <option value="receive">Receive</option>
                  <option value="swap">Swap</option>
                  <option value="payment">Payment</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Currency
                </label>
                {currencies.length > 0 ? (
                  <select
                    value={form.currency}
                    onChange={(e) => setForm({ ...form, currency: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                  >
                    {currencies.map((c) => (
                      <option key={c} value={c}>
                        {c}
                      </option>
                    ))}
                  </select>
                ) : (
                  <input
                    type="text"
                    value={form.currency}
                    onChange={(e) => setForm({ ...form, currency: e.target.value })}
                    placeholder="BTC"
                    required
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                  />
                )}
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Amount
                </label>
                <input
                  type="number"
                  step="any"
                  min="0.000001"
                  value={form.amount}
                  onChange={(e) => setForm({ ...form, amount: e.target.value })}
                  required
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  To Address <span className="text-gray-400">(optional)</span>
                </label>
                <input
                  type="text"
                  value={form.toAddress}
                  onChange={(e) => setForm({ ...form, toAddress: e.target.value })}
                  placeholder="0x..."
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div className="sm:col-span-2">
                <button
                  type="submit"
                  disabled={sending}
                  className="px-6 py-2 rounded-lg bg-gray-900 text-white font-medium hover:bg-gray-800 disabled:bg-gray-400 transition"
                >
                  {sending ? 'Sending...' : 'Submit Transaction'}
                </button>
              </div>
            </form>
          </div>
        )}

        {/* Transaction history */}
        {loading ? (
          <div className="text-gray-600">Loading transactions...</div>
        ) : transactions.length === 0 ? (
          <div className="bg-white border border-gray-200 rounded-xl p-10 text-center text-gray-500">
            No transactions yet.
          </div>
        ) : (
          <div className="bg-white border border-gray-200 rounded-xl overflow-hidden">
            <table className="w-full text-sm">
              <thead className="bg-gray-50 text-gray-600">
                <tr>
                  <th className="text-left px-4 py-3 font-medium">Type</th>
                  <th className="text-left px-4 py-3 font-medium">Currency</th>
                  <th className="text-right px-4 py-3 font-medium">Amount</th>
                  <th className="text-right px-4 py-3 font-medium">Fee</th>
                  <th className="text-center px-4 py-3 font-medium">Status</th>
                  <th className="text-left px-4 py-3 font-medium hidden sm:table-cell">
                    Date
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {transactions.map((tx) => (
                  <tr key={tx.id} className="hover:bg-gray-50">
                    <td className="px-4 py-3 capitalize text-gray-900">
                      {tx.type}
                    </td>
                    <td className="px-4 py-3 text-gray-700">{tx.currency}</td>
                    <td className="px-4 py-3 text-right font-medium text-gray-900">
                      {Number(tx.amount).toLocaleString(undefined, {
                        minimumFractionDigits: 2,
                        maximumFractionDigits: 8,
                      })}
                    </td>
                    <td className="px-4 py-3 text-right text-gray-500">
                      {Number(tx.fee).toFixed(4)}
                    </td>
                    <td className="px-4 py-3 text-center">
                      <span
                        className={`inline-block px-2 py-0.5 rounded text-xs font-medium ${
                          statusColor[tx.status] || 'bg-gray-100 text-gray-600'
                        }`}
                      >
                        {tx.status}
                      </span>
                    </td>
                    <td className="px-4 py-3 text-gray-500 hidden sm:table-cell">
                      {tx.createdAt
                        ? new Date(tx.createdAt).toLocaleDateString()
                        : '—'}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}
