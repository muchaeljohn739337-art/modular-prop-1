'use client';

import { useEffect, useState } from 'react';
import { useAuth } from '@/app/hooks/useAuth';
import AuthForm from '@/app/components/AuthForm';
import { walletApi } from '@/app/lib/api';

interface Wallet {
  id: string;
  currency: string;
  balance: number;
  type: string;
  address?: string;
}

export default function WalletPage() {
  const { user, isAuthenticated, isLoading } = useAuth();
  const [wallets, setWallets] = useState<Wallet[]>([]);
  const [loadingWallets, setLoadingWallets] = useState(false);
  const [showCreate, setShowCreate] = useState(false);
  const [creating, setCreating] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [form, setForm] = useState({ type: 'crypto', currency: '', address: '' });

  useEffect(() => {
    if (!isAuthenticated) return;
    loadWallets();
  }, [isAuthenticated]);

  async function loadWallets() {
    setLoadingWallets(true);
    const res = await walletApi.getWallets();
    setWallets(res.data?.wallets || []);
    setLoadingWallets(false);
  }

  async function handleCreate(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    setSuccess('');
    setCreating(true);
    const res = await walletApi.createWallet(
      form.type as 'crypto' | 'fiat',
      form.currency.toUpperCase(),
      form.address || undefined
    );
    setCreating(false);
    if (res.error) {
      setError(res.error);
    } else {
      setSuccess(`${form.currency.toUpperCase()} wallet created!`);
      setForm({ type: 'crypto', currency: '', address: '' });
      setShowCreate(false);
      loadWallets();
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
          <h1 className="text-2xl font-bold text-gray-900 mb-2">Wallets</h1>
          <p className="text-gray-600 mb-6">Sign in to manage your wallets.</p>
          <AuthForm redirectTo="/wallet" />
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
            <h1 className="text-2xl font-bold text-gray-900">Wallets</h1>
            <p className="text-gray-600 text-sm">Manage your crypto and fiat wallets</p>
          </div>
          <button
            onClick={() => setShowCreate(!showCreate)}
            className="px-4 py-2 rounded-lg bg-blue-600 text-white font-medium hover:bg-blue-700 transition"
          >
            {showCreate ? 'Cancel' : '+ New Wallet'}
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

        {/* Create form */}
        {showCreate && (
          <div className="bg-white border border-gray-200 rounded-xl p-6">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">Create Wallet</h2>
            <form onSubmit={handleCreate} className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Type</label>
                <select
                  value={form.type}
                  onChange={(e) => setForm({ ...form, type: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                >
                  <option value="crypto">Crypto</option>
                  <option value="fiat">Fiat</option>
                  <option value="custodial">Custodial</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Currency</label>
                <input
                  type="text"
                  value={form.currency}
                  onChange={(e) => setForm({ ...form, currency: e.target.value })}
                  placeholder="BTC, ETH, USDT..."
                  required
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div className="sm:col-span-2">
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Address <span className="text-gray-400">(optional)</span>
                </label>
                <input
                  type="text"
                  value={form.address}
                  onChange={(e) => setForm({ ...form, address: e.target.value })}
                  placeholder="Wallet address"
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div className="sm:col-span-2">
                <button
                  type="submit"
                  disabled={creating}
                  className="px-6 py-2 rounded-lg bg-gray-900 text-white font-medium hover:bg-gray-800 disabled:bg-gray-400 transition"
                >
                  {creating ? 'Creating...' : 'Create Wallet'}
                </button>
              </div>
            </form>
          </div>
        )}

        {/* Wallets grid */}
        {loadingWallets ? (
          <div className="text-gray-600">Loading wallets...</div>
        ) : wallets.length === 0 ? (
          <div className="bg-white border border-gray-200 rounded-xl p-10 text-center text-gray-500">
            No wallets yet. Create your first wallet to get started.
          </div>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {wallets.map((w) => (
              <div
                key={w.id}
                className="bg-white border border-gray-200 rounded-xl p-6"
              >
                <div className="flex items-center justify-between mb-3">
                  <span className="text-sm font-medium text-gray-500 uppercase">
                    {w.type}
                  </span>
                  <span className="text-xs bg-gray-100 text-gray-600 px-2 py-0.5 rounded">
                    {w.currency}
                  </span>
                </div>
                <div className="text-3xl font-bold text-gray-900 mb-1">
                  {Number(w.balance).toLocaleString(undefined, {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 8,
                  })}
                </div>
                <div className="text-sm text-gray-500">{w.currency}</div>
                {w.address && (
                  <div className="mt-3 text-xs text-gray-400 truncate" title={w.address}>
                    {w.address}
                  </div>
                )}
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
