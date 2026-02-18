'use client';

import { useEffect, useState } from 'react';
import { useAuth } from '@/app/hooks/useAuth';
import AuthForm from '@/app/components/AuthForm';
import { healthcareApi } from '@/app/lib/api';

interface Plan {
  id: string;
  name: string;
  monthlyPremium: number;
  coverage: string[];
  dependents: number;
}

interface Subscription {
  id: string;
  plan: string;
  provider: string;
  status: string;
  monthlyPremium: number;
  dependents: number;
  startDate?: string;
  renewalDate?: string;
}

export default function HealthcarePage() {
  const { user, isAuthenticated, isLoading } = useAuth();
  const [plans, setPlans] = useState<Plan[]>([]);
  const [subscriptions, setSubscriptions] = useState<Subscription[]>([]);
  const [loading, setLoading] = useState(false);
  const [subscribing, setSubscribing] = useState('');
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  useEffect(() => {
    if (!isAuthenticated) return;
    loadData();
  }, [isAuthenticated]);

  async function loadData() {
    setLoading(true);
    const [planRes, subRes] = await Promise.all([
      healthcareApi.getPlans(),
      healthcareApi.getSubscriptions(),
    ]);
    setPlans(planRes.data?.plans || []);
    setSubscriptions(subRes.data?.subscriptions || []);
    setLoading(false);
  }

  async function handleSubscribe(plan: Plan) {
    setError('');
    setSuccess('');
    setSubscribing(plan.id);
    const res = await healthcareApi.subscribe(
      plan.id,
      plan.name + ' Healthcare',
      plan.monthlyPremium,
      plan.dependents
    );
    setSubscribing('');
    if (res.error) {
      setError(res.error);
    } else {
      setSuccess(`Subscribed to ${plan.name} plan!`);
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
          <h1 className="text-2xl font-bold text-gray-900 mb-2">Healthcare</h1>
          <p className="text-gray-600 mb-6">Sign in to view healthcare plans.</p>
          <AuthForm redirectTo="/healthcare" />
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 py-10 px-4">
      <div className="max-w-5xl mx-auto space-y-8">
        {/* Header */}
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Healthcare</h1>
          <p className="text-gray-600 text-sm">
            Browse plans and manage your subscriptions
          </p>
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

        {/* Active Subscriptions */}
        {subscriptions.length > 0 && (
          <div>
            <h2 className="text-lg font-semibold text-gray-900 mb-3">
              Your Subscriptions
            </h2>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              {subscriptions.map((sub) => (
                <div
                  key={sub.id}
                  className="bg-white border border-gray-200 rounded-xl p-6"
                >
                  <div className="flex items-center justify-between mb-2">
                    <h3 className="font-semibold text-gray-900 capitalize">
                      {sub.plan}
                    </h3>
                    <span
                      className={`text-xs px-2 py-0.5 rounded font-medium ${
                        sub.status === 'active'
                          ? 'bg-green-100 text-green-700'
                          : 'bg-gray-100 text-gray-600'
                      }`}
                    >
                      {sub.status}
                    </span>
                  </div>
                  <p className="text-sm text-gray-600 mb-1">
                    Provider: {sub.provider}
                  </p>
                  <p className="text-2xl font-bold text-gray-900">
                    ${sub.monthlyPremium}
                    <span className="text-sm font-normal text-gray-500">
                      /month
                    </span>
                  </p>
                  {sub.dependents > 0 && (
                    <p className="text-sm text-gray-500 mt-1">
                      {sub.dependents} dependent{sub.dependents > 1 ? 's' : ''}
                    </p>
                  )}
                  {sub.renewalDate && (
                    <p className="text-xs text-gray-400 mt-2">
                      Renews: {new Date(sub.renewalDate).toLocaleDateString()}
                    </p>
                  )}
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Plans */}
        <div>
          <h2 className="text-lg font-semibold text-gray-900 mb-3">
            Available Plans
          </h2>
          {loading ? (
            <div className="text-gray-600">Loading plans...</div>
          ) : plans.length === 0 ? (
            <div className="text-gray-500">No plans available.</div>
          ) : (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
              {plans.map((plan) => {
                const alreadySubscribed = subscriptions.some(
                  (s) => s.plan === plan.id && s.status === 'active'
                );
                return (
                  <div
                    key={plan.id}
                    className="bg-white border border-gray-200 rounded-xl p-6 flex flex-col"
                  >
                    <h3 className="text-lg font-semibold text-gray-900 mb-1">
                      {plan.name}
                    </h3>
                    <p className="text-3xl font-bold text-gray-900 mb-3">
                      ${plan.monthlyPremium}
                      <span className="text-sm font-normal text-gray-500">
                        /mo
                      </span>
                    </p>
                    <ul className="text-sm text-gray-600 space-y-1 mb-4 flex-1">
                      {plan.coverage.map((item) => (
                        <li key={item} className="flex items-start gap-1">
                          <span className="text-green-500 mt-0.5">&#10003;</span>
                          {item}
                        </li>
                      ))}
                    </ul>
                    {plan.dependents > 0 && (
                      <p className="text-xs text-gray-500 mb-3">
                        Up to {plan.dependents} dependents
                      </p>
                    )}
                    <button
                      onClick={() => handleSubscribe(plan)}
                      disabled={alreadySubscribed || subscribing === plan.id}
                      className={`w-full py-2 rounded-lg text-sm font-medium transition ${
                        alreadySubscribed
                          ? 'bg-gray-100 text-gray-400 cursor-not-allowed'
                          : 'bg-blue-600 text-white hover:bg-blue-700 disabled:bg-gray-400'
                      }`}
                    >
                      {alreadySubscribed
                        ? 'Subscribed'
                        : subscribing === plan.id
                        ? 'Subscribing...'
                        : 'Subscribe'}
                    </button>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
