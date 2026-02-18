export default function TermsPage() {
  return (
    <main className="min-h-screen bg-gray-50 py-12 px-4">
      <article className="max-w-3xl mx-auto prose prose-gray">
        <h1 className="text-3xl font-bold text-gray-900 mb-6">Terms of Service</h1>
        <p className="text-sm text-gray-500 mb-8">
          Last updated: {new Date().toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })}
        </p>

        <section className="space-y-4 text-gray-700">
          <h2 className="text-xl font-semibold text-gray-900">1. Acceptance</h2>
          <p>
            By accessing or using Advancia PayLedger you agree to be bound by
            these Terms of Service. If you do not agree, please do not use the
            platform.
          </p>

          <h2 className="text-xl font-semibold text-gray-900">2. Accounts</h2>
          <p>
            You are responsible for maintaining the confidentiality of your
            credentials and for all activities that occur under your account.
          </p>

          <h2 className="text-xl font-semibold text-gray-900">3. Acceptable Use</h2>
          <p>
            You agree not to misuse the platform, including attempting
            unauthorized access, interfering with other users, or using the
            service for unlawful purposes.
          </p>

          <h2 className="text-xl font-semibold text-gray-900">4. Transactions</h2>
          <p>
            Cryptocurrency transactions are irreversible once confirmed on the
            blockchain. You acknowledge that Advancia PayLedger is not
            responsible for errors resulting from incorrect wallet addresses.
          </p>

          <h2 className="text-xl font-semibold text-gray-900">5. Healthcare Plans</h2>
          <p>
            Healthcare plan subscriptions are subject to the terms of the
            respective provider. Advancia PayLedger acts as a facilitator and
            does not provide medical advice.
          </p>

          <h2 className="text-xl font-semibold text-gray-900">6. Limitation of Liability</h2>
          <p>
            To the maximum extent permitted by law, Advancia PayLedger shall not
            be liable for indirect, incidental, or consequential damages arising
            from your use of the platform.
          </p>

          <h2 className="text-xl font-semibold text-gray-900">7. Changes</h2>
          <p>
            We reserve the right to modify these terms at any time. Continued
            use after changes constitutes acceptance.
          </p>

          <h2 className="text-xl font-semibold text-gray-900">8. Contact</h2>
          <p>
            For questions about these terms, contact us at{' '}
            <a href="mailto:support@advanciapayledger.com" className="text-blue-600 hover:underline">
              support@advanciapayledger.com
            </a>.
          </p>
        </section>
      </article>
    </main>
  );
}
