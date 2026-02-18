'use client';

import Link from 'next/link';
import { useAuth } from '@/app/hooks/useAuth';

export default function HomePage() {
  const { isAuthenticated } = useAuth();

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Hero */}
      <section className="py-20 px-4">
        <div className="max-w-4xl mx-auto text-center">
          <h1 className="text-4xl sm:text-5xl font-bold text-gray-900 mb-4">
            Crypto Payments &amp; Healthcare
          </h1>
          <p className="text-lg text-gray-600 mb-8 max-w-2xl mx-auto">
            Manage wallets, send transactions, and access healthcare plans — all
            in one secure platform powered by Advancia PayLedger.
          </p>
          <div className="flex justify-center gap-3">
            {isAuthenticated ? (
              <Link
                href="/dashboard"
                className="px-6 py-3 rounded-lg bg-gray-900 text-white font-semibold hover:bg-gray-800 transition"
              >
                Go to Dashboard
              </Link>
            ) : (
              <>
                <Link
                  href="/dashboard"
                  className="px-6 py-3 rounded-lg bg-blue-600 text-white font-semibold hover:bg-blue-700 transition"
                >
                  Get Started
                </Link>
                <Link
                  href="/about"
                  className="px-6 py-3 rounded-lg border border-gray-300 text-gray-700 font-semibold hover:bg-gray-100 transition"
                >
                  Learn More
                </Link>
              </>
            )}
          </div>
        </div>
      </section>

      {/* Features */}
      <section className="py-16 px-4 bg-white border-t border-gray-200">
        <div className="max-w-5xl mx-auto">
          <h2 className="text-2xl font-bold text-gray-900 text-center mb-10">
            Everything You Need
          </h2>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            {[
              {
                title: 'Multi-Currency Wallets',
                desc: 'Create and manage BTC, ETH, USDT and fiat wallets in one place.',
                icon: '💰',
              },
              {
                title: 'Instant Transactions',
                desc: 'Send and receive crypto with low fees and real-time tracking.',
                icon: '⚡',
              },
              {
                title: 'Healthcare Plans',
                desc: 'Browse and subscribe to Basic, Premium, Family, or Enterprise plans.',
                icon: '🏥',
              },
              {
                title: 'Secure by Default',
                desc: 'JWT auth, encrypted transport, rate limiting, and input validation.',
                icon: '🔒',
              },
            ].map((f) => (
              <div
                key={f.title}
                className="border border-gray-200 rounded-xl p-6 text-center"
              >
                <div className="text-3xl mb-3">{f.icon}</div>
                <h3 className="font-semibold text-gray-900 mb-1">{f.title}</h3>
                <p className="text-sm text-gray-600">{f.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className="py-16 px-4">
        <div className="max-w-3xl mx-auto text-center">
          <h2 className="text-2xl font-bold text-gray-900 mb-3">
            Ready to get started?
          </h2>
          <p className="text-gray-600 mb-6">
            Create your free account in seconds and start managing your finances.
          </p>
          <Link
            href="/dashboard"
            className="inline-block px-6 py-3 rounded-lg bg-blue-600 text-white font-semibold hover:bg-blue-700 transition"
          >
            {isAuthenticated ? 'Open Dashboard' : 'Create Free Account'}
          </Link>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-gray-200 py-8 px-4 text-center text-sm text-gray-500">
        <div className="max-w-5xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-4">
          <span>&copy; {new Date().getFullYear()} Advancia PayLedger</span>
          <div className="flex gap-4">
            <Link href="/privacy" className="hover:text-gray-700">Privacy</Link>
            <Link href="/terms" className="hover:text-gray-700">Terms</Link>
            <Link href="/about" className="hover:text-gray-700">About</Link>
          </div>
        </div>
      </footer>
    </div>
  );
}