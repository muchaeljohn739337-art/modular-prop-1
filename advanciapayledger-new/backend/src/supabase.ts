import { createClient, SupabaseClient } from '@supabase/supabase-js';

// ─── App-level types (camelCase) ────────────────────────────
export interface User {
  id: string;
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  phoneNumber?: string;
  avatar?: string;
  kycVerified: boolean;
  twoFactorEnabled: boolean;
  createdAt: Date;
}

export interface Wallet {
  id: string;
  userId: string;
  type: 'crypto' | 'fiat';
  currency: string;
  address?: string;
  balance: number;
  createdAt: Date;
}

export interface Transaction {
  id: string;
  userId: string;
  type: 'send' | 'receive' | 'swap' | 'payment' | 'healthcare';
  currency: string;
  amount: number;
  fee: number;
  status: 'pending' | 'completed' | 'failed' | 'cancelled';
  fromAddress?: string;
  toAddress?: string;
  txHash?: string;
  metadata?: any;
  createdAt: Date;
  updatedAt: Date;
}

export interface HealthcareSubscription {
  id: string;
  userId: string;
  plan: 'basic' | 'premium' | 'family' | 'enterprise';
  status: 'active' | 'inactive' | 'cancelled' | 'suspended';
  provider: string;
  policyNumber?: string;
  startDate: Date;
  renewalDate: Date;
  monthlyPremium: number;
  dependents: number;
  createdAt: Date;
}

// ─── DB row types (snake_case, matching Supabase columns) ───
interface DbUser {
  id: string; email: string; password: string;
  first_name: string; last_name: string;
  phone_number: string | null; avatar: string | null;
  kyc_verified: boolean; two_factor_enabled: boolean;
  created_at: string;
}
interface DbWallet {
  id: string; user_id: string; type: string; currency: string;
  address: string | null; balance: number; created_at: string;
}
interface DbTransaction {
  id: string; user_id: string; type: string; currency: string;
  amount: number; fee: number; status: string;
  from_address: string | null; to_address: string | null;
  tx_hash: string | null; metadata: any;
  created_at: string; updated_at: string;
}
interface DbHealthcare {
  id: string; user_id: string; plan: string; status: string;
  provider: string; policy_number: string | null;
  start_date: string; renewal_date: string;
  monthly_premium: number; dependents: number;
  created_at: string;
}

// ─── Row → App mappers ─────────────────────────────────────
function toUser(r: DbUser): User {
  return {
    id: r.id, email: r.email, password: r.password,
    firstName: r.first_name, lastName: r.last_name,
    phoneNumber: r.phone_number || undefined,
    avatar: r.avatar || undefined,
    kycVerified: r.kyc_verified,
    twoFactorEnabled: r.two_factor_enabled,
    createdAt: new Date(r.created_at),
  };
}
function toWallet(r: DbWallet): Wallet {
  return {
    id: r.id, userId: r.user_id,
    type: r.type as Wallet['type'],
    currency: r.currency,
    address: r.address || undefined,
    balance: r.balance,
    createdAt: new Date(r.created_at),
  };
}
function toTransaction(r: DbTransaction): Transaction {
  return {
    id: r.id, userId: r.user_id,
    type: r.type as Transaction['type'],
    currency: r.currency, amount: r.amount, fee: r.fee,
    status: r.status as Transaction['status'],
    fromAddress: r.from_address || undefined,
    toAddress: r.to_address || undefined,
    txHash: r.tx_hash || undefined,
    metadata: r.metadata,
    createdAt: new Date(r.created_at),
    updatedAt: new Date(r.updated_at),
  };
}
function toHealthcare(r: DbHealthcare): HealthcareSubscription {
  return {
    id: r.id, userId: r.user_id,
    plan: r.plan as HealthcareSubscription['plan'],
    status: r.status as HealthcareSubscription['status'],
    provider: r.provider,
    policyNumber: r.policy_number || undefined,
    startDate: new Date(r.start_date),
    renewalDate: new Date(r.renewal_date),
    monthlyPremium: r.monthly_premium,
    dependents: r.dependents,
    createdAt: new Date(r.created_at),
  };
}

// ─── Supabase client (singleton) ────────────────────────────
let _client: SupabaseClient | null = null;

export function isSupabaseEnabled(): boolean {
  return !!(process.env.SUPABASE_URL && process.env.SUPABASE_SERVICE_ROLE_KEY);
}

function getClient(): SupabaseClient {
  if (!_client) {
    const url = process.env.SUPABASE_URL!;
    const key = process.env.SUPABASE_SERVICE_ROLE_KEY!;
    _client = createClient(url, key, {
      auth: { persistSession: false, autoRefreshToken: false },
    });
  }
  return _client;
}

// ─── User CRUD ──────────────────────────────────────────────
export async function dbCreateUser(
  data: Omit<User, 'id' | 'createdAt'>
): Promise<User> {
  const sb = getClient();
  const { data: row, error } = await sb
    .from('app_users')
    .insert({
      email: data.email,
      password: data.password,
      first_name: data.firstName,
      last_name: data.lastName,
      phone_number: data.phoneNumber || null,
      avatar: data.avatar || null,
      kyc_verified: data.kycVerified,
      two_factor_enabled: data.twoFactorEnabled,
    })
    .select()
    .single();
  if (error) throw error;
  return toUser(row as DbUser);
}

export async function dbFindUserByEmail(
  email: string
): Promise<User | undefined> {
  const sb = getClient();
  const { data: row, error } = await sb
    .from('app_users')
    .select('*')
    .eq('email', email)
    .maybeSingle();
  if (error) throw error;
  return row ? toUser(row as DbUser) : undefined;
}

export async function dbFindUserById(
  id: string
): Promise<User | undefined> {
  const sb = getClient();
  const { data: row, error } = await sb
    .from('app_users')
    .select('*')
    .eq('id', id)
    .maybeSingle();
  if (error) throw error;
  return row ? toUser(row as DbUser) : undefined;
}

export async function dbUpdateUser(
  id: string,
  data: Partial<{
    firstName: string;
    lastName: string;
    phoneNumber: string;
    avatar: string;
    kycVerified: boolean;
    twoFactorEnabled: boolean;
  }>
): Promise<User | undefined> {
  const sb = getClient();
  const update: Record<string, any> = {};
  if (data.firstName !== undefined) update.first_name = data.firstName;
  if (data.lastName !== undefined) update.last_name = data.lastName;
  if (data.phoneNumber !== undefined) update.phone_number = data.phoneNumber;
  if (data.avatar !== undefined) update.avatar = data.avatar;
  if (data.kycVerified !== undefined) update.kyc_verified = data.kycVerified;
  if (data.twoFactorEnabled !== undefined)
    update.two_factor_enabled = data.twoFactorEnabled;

  const { data: row, error } = await sb
    .from('app_users')
    .update(update)
    .eq('id', id)
    .select()
    .maybeSingle();
  if (error) throw error;
  return row ? toUser(row as DbUser) : undefined;
}

export async function dbListUsers(): Promise<
  Array<{
    id: string;
    email: string;
    firstName: string;
    lastName: string;
    kycVerified: boolean;
    twoFactorEnabled: boolean;
    createdAt: Date;
  }>
> {
  const sb = getClient();
  const { data, error } = await sb
    .from('app_users')
    .select(
      'id,email,first_name,last_name,kyc_verified,two_factor_enabled,created_at'
    )
    .order('created_at', { ascending: false });
  if (error) throw error;
  return (data || []).map((r: any) => ({
    id: r.id,
    email: r.email,
    firstName: r.first_name,
    lastName: r.last_name,
    kycVerified: r.kyc_verified,
    twoFactorEnabled: r.two_factor_enabled,
    createdAt: new Date(r.created_at),
  }));
}

// ─── Wallet CRUD ────────────────────────────────────────────
export async function dbCreateWallet(
  data: Omit<Wallet, 'id' | 'createdAt'>
): Promise<Wallet> {
  const sb = getClient();
  const { data: row, error } = await sb
    .from('app_wallets')
    .insert({
      user_id: data.userId,
      type: data.type,
      currency: data.currency,
      address: data.address || null,
      balance: data.balance,
    })
    .select()
    .single();
  if (error) throw error;
  return toWallet(row as DbWallet);
}

export async function dbFindWalletsByUser(
  userId: string
): Promise<Wallet[]> {
  const sb = getClient();
  const { data, error } = await sb
    .from('app_wallets')
    .select('*')
    .eq('user_id', userId);
  if (error) throw error;
  return (data || []).map((r: any) => toWallet(r as DbWallet));
}

export async function dbFindWallet(
  userId: string,
  currency: string
): Promise<Wallet | undefined> {
  const sb = getClient();
  const { data: row, error } = await sb
    .from('app_wallets')
    .select('*')
    .eq('user_id', userId)
    .ilike('currency', currency)
    .maybeSingle();
  if (error) throw error;
  return row ? toWallet(row as DbWallet) : undefined;
}

export async function dbUpdateWalletBalance(
  id: string,
  delta: number
): Promise<Wallet | undefined> {
  const sb = getClient();
  // Read current balance then apply delta
  const { data: current, error: readErr } = await sb
    .from('app_wallets')
    .select('balance')
    .eq('id', id)
    .single();
  if (readErr) throw readErr;
  if (!current) return undefined;

  const newBalance = (current as any).balance + delta;
  const { data: row, error } = await sb
    .from('app_wallets')
    .update({ balance: newBalance })
    .eq('id', id)
    .select()
    .single();
  if (error) throw error;
  return toWallet(row as DbWallet);
}

// ─── Transaction CRUD ───────────────────────────────────────
export async function dbCreateTransaction(
  data: Omit<Transaction, 'id' | 'createdAt' | 'updatedAt'>
): Promise<Transaction> {
  const sb = getClient();
  const { data: row, error } = await sb
    .from('app_transactions')
    .insert({
      user_id: data.userId,
      type: data.type,
      currency: data.currency,
      amount: data.amount,
      fee: data.fee,
      status: data.status,
      from_address: data.fromAddress || null,
      to_address: data.toAddress || null,
      tx_hash: data.txHash || null,
      metadata: data.metadata || null,
    })
    .select()
    .single();
  if (error) throw error;
  return toTransaction(row as DbTransaction);
}

export async function dbFindTransactionsByUser(
  userId: string,
  filters?: { status?: string; type?: string }
): Promise<Transaction[]> {
  const sb = getClient();
  let query = sb
    .from('app_transactions')
    .select('*')
    .eq('user_id', userId);
  if (filters?.status) query = query.eq('status', filters.status);
  if (filters?.type) query = query.eq('type', filters.type);
  query = query.order('created_at', { ascending: false });

  const { data, error } = await query;
  if (error) throw error;
  return (data || []).map((r: any) => toTransaction(r as DbTransaction));
}

export async function dbFindTransactionById(
  id: string,
  userId: string
): Promise<Transaction | undefined> {
  const sb = getClient();
  const { data: row, error } = await sb
    .from('app_transactions')
    .select('*')
    .eq('id', id)
    .eq('user_id', userId)
    .maybeSingle();
  if (error) throw error;
  return row ? toTransaction(row as DbTransaction) : undefined;
}

export async function dbUpdateTransaction(
  id: string,
  data: Partial<{ status: string; metadata: any }>
): Promise<Transaction | undefined> {
  const sb = getClient();
  const update: Record<string, any> = {
    updated_at: new Date().toISOString(),
  };
  if (data.status !== undefined) update.status = data.status;
  if (data.metadata !== undefined) update.metadata = data.metadata;

  const { data: row, error } = await sb
    .from('app_transactions')
    .update(update)
    .eq('id', id)
    .select()
    .maybeSingle();
  if (error) throw error;
  return row ? toTransaction(row as DbTransaction) : undefined;
}

// ─── Healthcare CRUD ────────────────────────────────────────
export async function dbCreateHealthcare(
  data: Omit<HealthcareSubscription, 'id' | 'createdAt'>
): Promise<HealthcareSubscription> {
  const sb = getClient();
  const { data: row, error } = await sb
    .from('app_healthcare')
    .insert({
      user_id: data.userId,
      plan: data.plan,
      status: data.status,
      provider: data.provider,
      policy_number: data.policyNumber || null,
      start_date: data.startDate.toISOString(),
      renewal_date: data.renewalDate.toISOString(),
      monthly_premium: data.monthlyPremium,
      dependents: data.dependents,
    })
    .select()
    .single();
  if (error) throw error;
  return toHealthcare(row as DbHealthcare);
}

export async function dbFindHealthcareByUser(
  userId: string
): Promise<HealthcareSubscription[]> {
  const sb = getClient();
  const { data, error } = await sb
    .from('app_healthcare')
    .select('*')
    .eq('user_id', userId);
  if (error) throw error;
  return (data || []).map((r: any) => toHealthcare(r as DbHealthcare));
}

// ─── Stats ──────────────────────────────────────────────────
export async function dbGetStats(): Promise<{
  users: number;
  wallets: number;
  transactions: number;
  healthcare: number;
}> {
  const sb = getClient();
  const [u, w, t, h] = await Promise.all([
    sb.from('app_users').select('id', { count: 'exact', head: true }),
    sb.from('app_wallets').select('id', { count: 'exact', head: true }),
    sb.from('app_transactions').select('id', { count: 'exact', head: true }),
    sb.from('app_healthcare').select('id', { count: 'exact', head: true }),
  ]);
  return {
    users: u.count || 0,
    wallets: w.count || 0,
    transactions: t.count || 0,
    healthcare: h.count || 0,
  };
}
