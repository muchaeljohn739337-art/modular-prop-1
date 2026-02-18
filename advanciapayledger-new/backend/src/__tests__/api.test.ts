/// <reference types="jest" />
import request from 'supertest';
import app from '../index';

// Override JWT_SECRET for tests
process.env.JWT_SECRET = 'test-jwt-secret-for-unit-tests';

describe('Health endpoint', () => {
  it('GET /health returns ok', async () => {
    const res = await request(app).get('/health');
    expect(res.status).toBe(200);
    expect(res.body.status).toBe('ok');
    expect(res.body).toHaveProperty('timestamp');
    expect(res.body).toHaveProperty('storage');
  });
});

describe('Root endpoint', () => {
  it('GET / returns API info', async () => {
    const res = await request(app).get('/');
    expect(res.status).toBe(200);
    expect(res.body.message).toBe('Advancia PayLedger API');
    expect(res.body).toHaveProperty('endpoints');
  });
});

describe('404 handler', () => {
  it('returns 404 for unknown routes', async () => {
    const res = await request(app).get('/nonexistent');
    expect(res.status).toBe(404);
    expect(res.body.error).toBe('Not Found');
  });
});

describe('Auth routes', () => {
  const testUser = {
    email: `jest-${Date.now()}@test.com`,
    password: 'TestPass123',
    firstName: 'Jest',
    lastName: 'User',
  };
  let token: string;

  it('POST /api/auth/register - validates input', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send({ email: 'bad', password: 'x' });
    expect(res.status).toBe(400);
    expect(res.body.error).toBe('Validation failed');
    expect(res.body.details.length).toBeGreaterThan(0);
  });

  it('POST /api/auth/register - creates user', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send(testUser);
    expect(res.status).toBe(201);
    expect(res.body).toHaveProperty('token');
    expect(res.body.user.email).toBe(testUser.email);
    token = res.body.token;
  });

  it('POST /api/auth/register - rejects duplicate', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send(testUser);
    expect(res.status).toBe(409);
  });

  it('POST /api/auth/login - validates input', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({ email: 'bad', password: '' });
    expect(res.status).toBe(400);
  });

  it('POST /api/auth/login - succeeds with valid credentials', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({ email: testUser.email, password: testUser.password });
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('token');
    token = res.body.token;
  });

  it('POST /api/auth/login - rejects wrong password', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({ email: testUser.email, password: 'Wrong123!' });
    expect(res.status).toBe(401);
  });

  it('GET /api/auth/me - returns user with valid token', async () => {
    const res = await request(app)
      .get('/api/auth/me')
      .set('Authorization', `Bearer ${token}`);
    expect(res.status).toBe(200);
    expect(res.body.user.email).toBe(testUser.email);
  });

  it('GET /api/auth/me - rejects no token', async () => {
    const res = await request(app).get('/api/auth/me');
    expect(res.status).toBe(401);
  });

  it('GET /api/auth/me - rejects invalid token', async () => {
    const res = await request(app)
      .get('/api/auth/me')
      .set('Authorization', 'Bearer invalid-token');
    expect(res.status).toBe(401);
  });
});

describe('Wallet routes', () => {
  let token: string;

  beforeAll(async () => {
    const email = `wallet-${Date.now()}@test.com`;
    const reg = await request(app)
      .post('/api/auth/register')
      .send({ email, password: 'TestPass123', firstName: 'W', lastName: 'U' });
    token = reg.body.token;
  });

  it('GET /api/wallet - returns empty array', async () => {
    const res = await request(app)
      .get('/api/wallet')
      .set('Authorization', `Bearer ${token}`);
    expect(res.status).toBe(200);
    expect(res.body.wallets).toEqual([]);
  });

  it('POST /api/wallet - creates wallet', async () => {
    const res = await request(app)
      .post('/api/wallet')
      .set('Authorization', `Bearer ${token}`)
      .send({ type: 'crypto', currency: 'BTC' });
    expect(res.status).toBe(201);
    expect(res.body.wallet.currency).toBe('BTC');
  });

  it('POST /api/wallet - rejects duplicate currency', async () => {
    const res = await request(app)
      .post('/api/wallet')
      .set('Authorization', `Bearer ${token}`)
      .send({ type: 'crypto', currency: 'BTC' });
    expect(res.status).toBe(409);
  });

  it('GET /api/wallet/:currency - returns balance', async () => {
    const res = await request(app)
      .get('/api/wallet/BTC')
      .set('Authorization', `Bearer ${token}`);
    expect(res.status).toBe(200);
    expect(res.body.currency).toBe('BTC');
    expect(res.body.balance).toBe(0);
  });

  it('rejects unauthenticated access', async () => {
    const res = await request(app).get('/api/wallet');
    expect(res.status).toBe(401);
  });
});

describe('Payment routes require auth', () => {
  it('POST /api/payments/create-intent rejects unauthenticated', async () => {
    const res = await request(app)
      .post('/api/payments/create-intent')
      .send({ amount: 100 });
    expect(res.status).toBe(401);
  });

  it('POST /api/payments/crypto rejects unauthenticated', async () => {
    const res = await request(app)
      .post('/api/payments/crypto')
      .send({ currency: 'BTC', amount: 1, toAddress: '0x123' });
    expect(res.status).toBe(401);
  });
});
