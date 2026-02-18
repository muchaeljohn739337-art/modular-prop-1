export default function PrivacyPage() {
  return (
    <main className="min-h-screen bg-gray-50 py-12 px-4">
      <article className="max-w-3xl mx-auto prose prose-gray">
        <h1 className="text-3xl font-bold text-gray-900 mb-6">Privacy Policy</h1>
        <p className="text-sm text-gray-500 mb-8">
          Last updated: {new Date().toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })}
        </p>

        <section className="space-y-4 text-gray-700">
          <h2 className="text-xl font-semibold text-gray-900">1. Information We Collect</h2>
          <p>
            When you create an account we collect your name, email address, and
            an encrypted version of your password. Transaction and wallet data is
            stored to provide our services.
          </p>

          <h2 className="text-xl font-semibold text-gray-900">2. How We Use Your Information</h2>
          <p>
            We use your information solely to operate and improve Advancia
            PayLedger — including authenticating your sessions, processing
            transactions, and displaying your balances.
          </p>

          <h2 className="text-xl font-semibold text-gray-900">3. Data Security</h2>
          <p>
            All data is transmitted over HTTPS. Passwords are hashed with bcrypt.
            Access tokens are signed with industry-standard JWT. We follow
            security best practices and regularly audit our infrastructure.
          </p>

          <h2 className="text-xl font-semibold text-gray-900">4. Third Parties</h2>
          <p>
            We do not sell your personal data. We may share anonymous, aggregated
            analytics with partners to improve our platform.
          </p>

          <h2 className="text-xl font-semibold text-gray-900">5. Your Rights</h2>
          <p>
            You may request access to, correction of, or deletion of your
            personal data at any time by contacting us at{' '}
            <a href="mailto:support@advanciapayledger.com" className="text-blue-600 hover:underline">
              support@advanciapayledger.com
            </a>.
          </p>

          <h2 className="text-xl font-semibold text-gray-900">6. Changes</h2>
          <p>
            We may update this policy from time to time. Material changes will be
            announced via email or a notice on our website.
          </p>
        </section>
      </article>
    </main>
  );
}
