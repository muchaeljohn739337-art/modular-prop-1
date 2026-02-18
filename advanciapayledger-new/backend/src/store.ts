// Unified data store – uses Supabase (app_* tables) when configured,
// otherwise falls back to an in-memory store for local development.

import {
  isSupabaseEnabled,
  dbCreateUser, dbFindUserByEmail, dbFindUserById, dbUpdateUser, dbListUsers,
  dbCreateWallet, dbFindWalletsByUser, dbFindWallet, dbUpdateWalletBalance,
  dbCreateTransaction, dbFindTransactionsByUser, dbFindTransactionById, dbUpdateTransaction,
  dbCreateHealthcare, dbFindHealthcareByUser,
  dbGetStats,
} from './supabase';

import type {
  User, Wallet, Transaction, HealthcareSubscription,
} from './supabase';

// Re-export types so route files can import from './store'
export type { User, Wallet, Transaction, HealthcareSubscription };
export { isSupabaseEnabled };

// ─── In-memory fallback (dev / no Supabase) ─────────────────
class InMemoryStore {
  private users: Map<string, User> = new Map();
  private wallets: Map<string, Wallet> = new Map();
  private transactions: Map<string, Transaction> = new Map();
  private healthcare: Map<string, HealthcareSubscription> = new Map();
  private idCounter = 1;

  generateId(): string {
    return (this.idCounter++).toString().padStart(24, '0');
  }

  createUser(data: Omit<User, 'id' | 'createdAt'>): User {
    const user: User = { ...data, id: this.generateId(), createdAt: new Date() };
    this.users.set(user.id, user);
    return user;
  }
  findUserByEmail(email: string): User | undefined {
    return Array.from(this.users.values()).find((u) => u.email === email);
  }
  findUserById(id: string): User | undefined {
    return this.users.get(id);
  }
  updateUser(id: string, data: Partial<User>): User | undefined {
    const user = this.users.get(id);
    if (!user) return undefined;
    const updated = { ...user, ...data };
    this.users.set(id, updated);
    return updated;
  }
  listUsers() {
    return Array.from(this.users.values()).map((u) => ({
      id: u.id, email: u.email, firstName: u.firstName, lastName: u.lastName,
      kycVerified: u.kycVerified, twoFactorEnabled: u.twoFactorEnabled, createdAt: u.createdAt,
    }));
  }

  createWallet(data: Omit<Wallet, 'id' | 'createdAt'>): Wallet {
    const wallet: Wallet = { ...data, id: this.generateId(), createdAt: new Date() };
    this.wallets.set(wallet.id, wallet);
    return wallet;
  }
  findWalletsByUser(userId: string): Wallet[] {
    return Array.from(this.wallets.values()).filter((w) => w.userId === userId);
  }
  findWallet(userId: string, currency: string): Wallet | undefined {
    return Array.from(this.wallets.values()).find(
      (w) => w.userId === userId && w.currency.toUpperCase() === currency.toUpperCase()
    );
  }
  updateWalletBalance(id: string, amount: number): Wallet | undefined {
    const wallet = this.wallets.get(id);
    if (!wallet) return undefined;
    wallet.balance += amount;
    this.wallets.set(id, wallet);
    return wallet;
  }

  createTransaction(data: Omit<Transaction, 'id' | 'createdAt' | 'updatedAt'>): Transaction {
    const tx: Transaction = { ...data, id: this.generateId(), createdAt: new Date(), updatedAt: new Date() };
    this.transactions.set(tx.id, tx);
    return tx;
  }
  findTransactionsByUser(userId: string, filters?: { status?: string; type?: string }): Transaction[] {
    let txs = Array.from(this.transactions.values()).filter((t) => t.userId === userId);
    if (filters?.status) txs = txs.filter((t) => t.status === filters.status);
    if (filters?.type) txs = txs.filter((t) => t.type === filters.type);
    return txs.sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime());
  }
  findTransactionById(id: string, userId: string): Transaction | undefined {
    const tx = this.transactions.get(id);
    if (!tx || tx.userId !== userId) return undefined;
    return tx;
  }
  updateTransaction(id: string, data: Partial<Transaction>): Transaction | undefined {
    const tx = this.transactions.get(id);
    if (!tx) return undefined;
    const updated = { ...tx, ...data, updatedAt: new Date() };
    this.transactions.set(id, updated);
    return updated;
  }

  createHealthcare(data: Omit<HealthcareSubscription, 'id' | 'createdAt'>): HealthcareSubscription {
    const sub: HealthcareSubscription = { ...data, id: this.generateId(), createdAt: new Date() };
    this.healthcare.set(sub.id, sub);
    return sub;
  }
  findHealthcareByUser(userId: string): HealthcareSubscription[] {
    return Array.from(this.healthcare.values()).filter((h) => h.userId === userId);
  }

  getStats() {
    return {
      users: this.users.size, wallets: this.wallets.size,
      transactions: this.transactions.size, healthcare: this.healthcare.size,
    };
  }
}

const memStore = new InMemoryStore();

// ─── Unified async store (Supabase-first, in-memory fallback) ─
export const store = {
  // Users
  async createUser(data: Omit<User, 'id' | 'createdAt'>): Promise<User> {
    if (isSupabaseEnabled()) return dbCreateUser(data);
    return memStore.createUser(data);
  },
  async findUserByEmail(email: string): Promise<User | undefined> {
    if (isSupabaseEnabled()) return dbFindUserByEmail(email);
    return memStore.findUserByEmail(email);
  },
  async findUserById(id: string): Promise<User | undefined> {
    if (isSupabaseEnabled()) return dbFindUserById(id);
    return memStore.findUserById(id);
  },
  async updateUser(id: string, data: Partial<User>): Promise<User | undefined> {
    if (isSupabaseEnabled()) return dbUpdateUser(id, data);
    return memStore.updateUser(id, data);
  },
  async listUsers() {
    if (isSupabaseEnabled()) return dbListUsers();
    return memStore.listUsers();
  },

  // Wallets
  async createWallet(data: Omit<Wallet, 'id' | 'createdAt'>): Promise<Wallet> {
    if (isSupabaseEnabled()) return dbCreateWallet(data);
    return memStore.createWallet(data);
  },
  async findWalletsByUser(userId: string): Promise<Wallet[]> {
    if (isSupabaseEnabled()) return dbFindWalletsByUser(userId);
    return memStore.findWalletsByUser(userId);
  },
  async findWallet(userId: string, currency: string): Promise<Wallet | undefined> {
    if (isSupabaseEnabled()) return dbFindWallet(userId, currency);
    return memStore.findWallet(userId, currency);
  },
  async updateWalletBalance(id: string, amount: number): Promise<Wallet | undefined> {
    if (isSupabaseEnabled()) return dbUpdateWalletBalance(id, amount);
    return memStore.updateWalletBalance(id, amount);
  },

  // Transactions
  async createTransaction(data: Omit<Transaction, 'id' | 'createdAt' | 'updatedAt'>): Promise<Transaction> {
    if (isSupabaseEnabled()) return dbCreateTransaction(data);
    return memStore.createTransaction(data);
  },
  async findTransactionsByUser(userId: string, filters?: { status?: string; type?: string }): Promise<Transaction[]> {
    if (isSupabaseEnabled()) return dbFindTransactionsByUser(userId, filters);
    return memStore.findTransactionsByUser(userId, filters);
  },
  async findTransactionById(id: string, userId: string): Promise<Transaction | undefined> {
    if (isSupabaseEnabled()) return dbFindTransactionById(id, userId);
    return memStore.findTransactionById(id, userId);
  },
  async updateTransaction(id: string, data: Partial<Transaction>): Promise<Transaction | undefined> {
    if (isSupabaseEnabled()) return dbUpdateTransaction(id, data);
    return memStore.updateTransaction(id, data);
  },

  // Healthcare
  async createHealthcare(data: Omit<HealthcareSubscription, 'id' | 'createdAt'>): Promise<HealthcareSubscription> {
    if (isSupabaseEnabled()) return dbCreateHealthcare(data);
    return memStore.createHealthcare(data);
  },
  async findHealthcareByUser(userId: string): Promise<HealthcareSubscription[]> {
    if (isSupabaseEnabled()) return dbFindHealthcareByUser(userId);
    return memStore.findHealthcareByUser(userId);
  },

  // Stats
  async getStats() {
    if (isSupabaseEnabled()) return dbGetStats();
    return memStore.getStats();
  },
};
