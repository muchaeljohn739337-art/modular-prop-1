"use client";

import React, { useState, useEffect, useMemo } from "react";
import { motion } from "framer-motion";
import {
  TrendingUp,
  TrendingDown,
  DollarSign,
  Users,
  Activity,
  PieChart,
  CreditCard,
  Hospital,
  BedDouble,
  Calendar,
  ArrowUpRight,
  ArrowDownRight,
  Wallet,
  Award,
  Target,
  Zap,
  Shield,
  Globe,
  BarChart3,
  Eye,
  Clock,
  CheckCircle,
  AlertCircle,
  TrendingUpIcon,
  Coins,
  Building2,
  Stethoscope,
  HeartPulse,
  FileText,
  Settings,
  Bell,
  Search,
  Filter,
  Download,
  RefreshCw,
  ChevronUp,
  ChevronDown,
  MoreVertical,
  Star,
  Users2,
  Briefcase,
  Rocket,
  Lightbulb,
  Brain,
  Cpu,
  Database,
  Lock,
  Unlock,
  Wifi,
  WifiOff,
  Battery,
  BatteryCharging,
  Cloud,
  Server,
  Code,
  Terminal,
  GitBranch,
  Package,
  Box,
  Truck,
  ShoppingCart,
  Receipt,
  Calculator,
  Percent,
  DollarSignIcon,
  EuroIcon,
  PoundSterlingIcon,
  YenIcon,
  Bitcoin,
  Ethereum,
  LucideIcon,
} from "lucide-react";

// Types
interface MetricCard {
  title: string;
  value: string;
  change: number;
  icon: LucideIcon;
  color: string;
  trend: "up" | "down" | "neutral";
}

interface Transaction {
  id: string;
  type: "payment" | "deposit" | "withdrawal" | "transfer";
  amount: number;
  currency: string;
  status: "completed" | "pending" | "failed";
  timestamp: string;
  description: string;
  facility?: string;
}

interface Facility {
  id: string;
  name: string;
  type: "hospital" | "clinic" | "surgical_center";
  beds: {
    total: number;
    occupied: number;
    available: number;
  };
  revenue: number;
  patients: number;
  status: "active" | "inactive" | "maintenance";
  efficiency: number;
}

interface BlockchainNetwork {
  name: string;
  symbol: string;
  status: "active" | "inactive" | "maintenance";
  transactions: number;
  volume: number;
  fees: number;
  uptime: number;
}

const AdvanciaVisualDashboard: React.FC = () => {
  const [selectedTimeRange, setSelectedTimeRange] = useState<"24h" | "7d" | "30d" | "90d">("7d");
  const [selectedMetric, setSelectedMetric] = useState<"revenue" | "transactions" | "users" | "facilities">("revenue");
  const [searchQuery, setSearchQuery] = useState("");
  const [showNotifications, setShowNotifications] = useState(false);
  const [refreshing, setRefreshing] = useState(false);

  // Mock data - in real app, this would come from API
  const metrics: MetricCard[] = [
    {
      title: "Monthly Recurring Revenue",
      value: "$247,000",
      change: 42,
      icon: DollarSign,
      color: "text-green-600",
      trend: "up"
    },
    {
      title: "Active Facilities",
      value: "24",
      change: 8,
      icon: Hospital,
      color: "text-blue-600",
      trend: "up"
    },
    {
      title: "Total Transactions",
      value: "12,847",
      change: 15,
      icon: CreditCard,
      color: "text-purple-600",
      trend: "up"
    },
    {
      title: "Cost Reduction",
      value: "82%",
      change: 5,
      icon: TrendingDown,
      color: "text-orange-600",
      trend: "up"
    },
    {
      title: "Patient Satisfaction",
      value: "94%",
      change: 3,
      icon: HeartPulse,
      color: "text-pink-600",
      trend: "up"
    },
    {
      title: "Network Uptime",
      value: "99.9%",
      change: 0.1,
      icon: Wifi,
      color: "text-green-600",
      trend: "neutral"
    }
  ];

  const recentTransactions: Transaction[] = [
    {
      id: "1",
      type: "payment",
      amount: 12500,
      currency: "USD",
      status: "completed",
      timestamp: "2024-01-27T10:30:00Z",
      description: "Healthcare payment processing",
      facility: "St. Mary's Hospital"
    },
    {
      id: "2",
      type: "deposit",
      amount: 50000,
      currency: "USDC",
      status: "completed",
      timestamp: "2024-01-27T09:15:00Z",
      description: "Crypto deposit settlement",
      facility: "Medical Center Plaza"
    },
    {
      id: "3",
      type: "withdrawal",
      amount: 8500,
      currency: "ETH",
      status: "pending",
      timestamp: "2024-01-27T08:45:00Z",
      description: "Facility withdrawal request",
      facility: "Urgent Care Plus"
    },
    {
      id: "4",
      type: "transfer",
      amount: 32000,
      currency: "USD",
      status: "completed",
      timestamp: "2024-01-27T07:20:00Z",
      description: "Inter-facility transfer",
      facility: "City General Hospital"
    }
  ];

  const facilities: Facility[] = [
    {
      id: "1",
      name: "St. Mary's Hospital",
      type: "hospital",
      beds: { total: 150, occupied: 132, available: 18 },
      revenue: 45000,
      patients: 892,
      status: "active",
      efficiency: 94
    },
    {
      id: "2",
      name: "Medical Center Plaza",
      type: "clinic",
      beds: { total: 50, occupied: 38, available: 12 },
      revenue: 22000,
      patients: 342,
      status: "active",
      efficiency: 87
    },
    {
      id: "3",
      name: "Surgical Solutions Center",
      type: "surgical_center",
      beds: { total: 75, occupied: 58, available: 17 },
      revenue: 38000,
      patients: 156,
      status: "active",
      efficiency: 91
    },
    {
      id: "4",
      name: "Urgent Care Plus",
      type: "clinic",
      beds: { total: 25, occupied: 18, available: 7 },
      revenue: 15000,
      patients: 234,
      status: "maintenance",
      efficiency: 82
    }
  ];

  const blockchainNetworks: BlockchainNetwork[] = [
    {
      name: "Ethereum",
      symbol: "ETH",
      status: "active",
      transactions: 3421,
      volume: 1250000,
      fees: 0.5,
      uptime: 99.9
    },
    {
      name: "Polygon",
      symbol: "MATIC",
      status: "active",
      transactions: 5892,
      volume: 890000,
      fees: 0.1,
      uptime: 99.8
    },
    {
      name: "Binance Smart Chain",
      symbol: "BSC",
      status: "active",
      transactions: 2156,
      volume: 670000,
      fees: 0.3,
      uptime: 99.7
    },
    {
      name: "Arbitrum",
      symbol: "ARB",
      status: "active",
      transactions: 1234,
      volume: 450000,
      fees: 0.2,
      uptime: 99.9
    },
    {
      name: "Optimism",
      symbol: "OP",
      status: "active",
      transactions: 987,
      volume: 340000,
      fees: 0.2,
      uptime: 99.8
    },
    {
      name: "Stellar",
      symbol: "XLM",
      status: "maintenance",
      transactions: 0,
      volume: 0,
      fees: 0.1,
      uptime: 0
    }
  ];

  const handleRefresh = async () => {
    setRefreshing(true);
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 2000));
    setRefreshing(false);
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case "active":
      case "completed":
        return "text-green-600 bg-green-100";
      case "pending":
      case "maintenance":
        return "text-yellow-600 bg-yellow-100";
      case "failed":
      case "inactive":
        return "text-red-600 bg-red-100";
      default:
        return "text-gray-600 bg-gray-100";
    }
  };

  const formatCurrency = (amount: number, currency: string) => {
    return new Intl.NumberFormat("en-US", {
      style: "currency",
      currency: currency === "USDC" ? "USD" : currency === "ETH" ? "ETH" : currency,
    }).format(amount);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-slate-100 p-6">
      {/* Header */}
      <div className="mb-8">
        <div className="flex justify-between items-center mb-6">
          <div>
            <h1 className="text-4xl font-bold text-slate-900 mb-2">Advancia Pay Ledger</h1>
            <p className="text-slate-600">Healthcare Blockchain Payment Platform Dashboard</p>
          </div>
          <div className="flex gap-4">
            <button
              onClick={() => setShowNotifications(!showNotifications)}
              className="relative p-3 bg-white rounded-lg shadow-sm hover:shadow-md transition-shadow"
            >
              <Bell className="w-5 h-5 text-slate-600" />
              <span className="absolute top-2 right-2 w-2 h-2 bg-red-500 rounded-full"></span>
            </button>
            <button
              onClick={handleRefresh}
              className="p-3 bg-white rounded-lg shadow-sm hover:shadow-md transition-shadow"
            >
              <RefreshCw className={`w-5 h-5 text-slate-600 ${refreshing ? 'animate-spin' : ''}`} />
            </button>
            <button className="p-3 bg-white rounded-lg shadow-sm hover:shadow-md transition-shadow">
              <Settings className="w-5 h-5 text-slate-600" />
            </button>
          </div>
        </div>

        {/* Time Range Selector */}
        <div className="flex gap-2 p-1 bg-white rounded-lg shadow-sm">
          {(["24h", "7d", "30d", "90d"] as const).map((range) => (
            <button
              key={range}
              onClick={() => setSelectedTimeRange(range)}
              className={`px-4 py-2 rounded-md transition-colors ${
                selectedTimeRange === range
                  ? "bg-blue-600 text-white"
                  : "text-slate-600 hover:bg-slate-100"
              }`}
            >
              {range}
            </button>
          ))}
        </div>
      </div>

      {/* Metrics Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-6 mb-8">
        {metrics.map((metric, index) => {
          const Icon = metric.icon;
          return (
            <motion.div
              key={metric.title}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.1 }}
              className="bg-white rounded-xl shadow-sm p-6 hover:shadow-lg transition-shadow"
            >
              <div className="flex items-center justify-between mb-4">
                <div className={`p-2 rounded-lg ${metric.color} bg-opacity-10`}>
                  <Icon className={`w-5 h-5 ${metric.color}`} />
                </div>
                <div className={`flex items-center text-sm ${
                  metric.trend === "up" ? "text-green-600" : 
                  metric.trend === "down" ? "text-red-600" : "text-slate-600"
                }`}>
                  {metric.trend === "up" ? <ArrowUpRight className="w-4 h-4 mr-1" /> : 
                   metric.trend === "down" ? <ArrowDownRight className="w-4 h-4 mr-1" /> : null}
                  {metric.change}%
                </div>
              </div>
              <h3 className="text-2xl font-bold text-slate-900 mb-1">{metric.value}</h3>
              <p className="text-sm text-slate-600">{metric.title}</p>
            </motion.div>
          );
        })}
      </div>

      {/* Main Content Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
        {/* Revenue Chart */}
        <div className="lg:col-span-2 bg-white rounded-xl shadow-sm p-6">
          <div className="flex justify-between items-center mb-6">
            <h2 className="text-xl font-semibold text-slate-900">Revenue Overview</h2>
            <div className="flex gap-2">
              {["revenue", "transactions", "users", "facilities"].map((metric) => (
                <button
                  key={metric}
                  onClick={() => setSelectedMetric(metric as any)}
                  className={`px-3 py-1 rounded-lg text-sm capitalize transition-colors ${
                    selectedMetric === metric
                      ? "bg-blue-600 text-white"
                      : "text-slate-600 hover:bg-slate-100"
                  }`}
                >
                  {metric}
                </button>
              ))}
            </div>
          </div>
          <div className="h-80 flex items-center justify-center bg-slate-50 rounded-lg">
            <div className="text-center">
              <BarChart3 className="w-16 h-16 text-slate-400 mx-auto mb-4" />
              <p className="text-slate-600">Revenue chart visualization</p>
              <p className="text-sm text-slate-500 mt-2">Interactive chart would render here</p>
            </div>
          </div>
        </div>

        {/* Quick Stats */}
        <div className="space-y-6">
          <div className="bg-white rounded-xl shadow-sm p-6">
            <h3 className="text-lg font-semibold text-slate-900 mb-4">Quick Stats</h3>
            <div className="space-y-4">
              <div className="flex justify-between items-center">
                <span className="text-slate-600">Avg. Transaction</span>
                <span className="font-semibold text-slate-900">$2,847</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-slate-600">Success Rate</span>
                <span className="font-semibold text-green-600">98.7%</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-slate-600">Processing Time</span>
                <span className="font-semibold text-slate-900">&lt; 2s</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-slate-600">Active Networks</span>
                <span className="font-semibold text-slate-900">5/6</span>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-xl shadow-sm p-6">
            <h3 className="text-lg font-semibold text-slate-900 mb-4">Network Status</h3>
            <div className="space-y-3">
              {blockchainNetworks.slice(0, 3).map((network) => (
                <div key={network.name} className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className={`w-2 h-2 rounded-full ${
                      network.status === "active" ? "bg-green-500" : "bg-yellow-500"
                    }`}></div>
                    <span className="text-sm text-slate-600">{network.name}</span>
                  </div>
                  <span className="text-sm font-medium text-slate-900">{network.uptime}%</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Recent Transactions */}
      <div className="bg-white rounded-xl shadow-sm p-6 mb-8">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-xl font-semibold text-slate-900">Recent Transactions</h2>
          <button className="text-blue-600 hover:text-blue-700 text-sm font-medium">
            View All
          </button>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-slate-200">
                <th className="text-left py-3 px-4 text-sm font-medium text-slate-600">Type</th>
                <th className="text-left py-3 px-4 text-sm font-medium text-slate-600">Amount</th>
                <th className="text-left py-3 px-4 text-sm font-medium text-slate-600">Facility</th>
                <th className="text-left py-3 px-4 text-sm font-medium text-slate-600">Status</th>
                <th className="text-left py-3 px-4 text-sm font-medium text-slate-600">Time</th>
              </tr>
            </thead>
            <tbody>
              {recentTransactions.map((transaction) => (
                <tr key={transaction.id} className="border-b border-slate-100 hover:bg-slate-50">
                  <td className="py-3 px-4">
                    <div className="flex items-center gap-2">
                      {transaction.type === "payment" && <CreditCard className="w-4 h-4 text-blue-600" />}
                      {transaction.type === "deposit" && <ArrowDownRight className="w-4 h-4 text-green-600" />}
                      {transaction.type === "withdrawal" && <ArrowUpRight className="w-4 h-4 text-red-600" />}
                      {transaction.type === "transfer" && <RefreshCw className="w-4 h-4 text-purple-600" />}
                      <span className="text-sm text-slate-900 capitalize">{transaction.type}</span>
                    </div>
                  </td>
                  <td className="py-3 px-4">
                    <span className="text-sm font-medium text-slate-900">
                      {formatCurrency(transaction.amount, transaction.currency)}
                    </span>
                  </td>
                  <td className="py-3 px-4">
                    <span className="text-sm text-slate-600">{transaction.facility}</span>
                  </td>
                  <td className="py-3 px-4">
                    <span className={`inline-flex px-2 py-1 text-xs font-medium rounded-full ${getStatusColor(transaction.status)}`}>
                      {transaction.status}
                    </span>
                  </td>
                  <td className="py-3 px-4">
                    <span className="text-sm text-slate-600">
                      {new Date(transaction.timestamp).toLocaleTimeString()}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Facilities Overview */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white rounded-xl shadow-sm p-6">
          <div className="flex justify-between items-center mb-6">
            <h2 className="text-xl font-semibold text-slate-900">Facilities Overview</h2>
            <button className="text-blue-600 hover:text-blue-700 text-sm font-medium">
              Manage Facilities
            </button>
          </div>
          <div className="space-y-4">
            {facilities.map((facility) => (
              <div key={facility.id} className="border border-slate-200 rounded-lg p-4 hover:bg-slate-50">
                <div className="flex justify-between items-start mb-3">
                  <div>
                    <h3 className="font-medium text-slate-900">{facility.name}</h3>
                    <span className={`inline-flex px-2 py-1 text-xs font-medium rounded-full ${getStatusColor(facility.status)}`}>
                      {facility.status}
                    </span>
                  </div>
                  <div className="text-right">
                    <p className="text-sm font-medium text-slate-900">{formatCurrency(facility.revenue, "USD")}</p>
                    <p className="text-xs text-slate-600">Revenue</p>
                  </div>
                </div>
                <div className="grid grid-cols-3 gap-4 text-sm">
                  <div>
                    <p className="text-slate-600">Beds</p>
                    <p className="font-medium text-slate-900">{facility.beds.occupied}/{facility.beds.total}</p>
                  </div>
                  <div>
                    <p className="text-slate-600">Patients</p>
                    <p className="font-medium text-slate-900">{facility.patients}</p>
                  </div>
                  <div>
                    <p className="text-slate-600">Efficiency</p>
                    <p className="font-medium text-green-600">{facility.efficiency}%</p>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Blockchain Networks */}
        <div className="bg-white rounded-xl shadow-sm p-6">
          <div className="flex justify-between items-center mb-6">
            <h2 className="text-xl font-semibold text-slate-900">Blockchain Networks</h2>
            <button className="text-blue-600 hover:text-blue-700 text-sm font-medium">
              Configure Networks
            </button>
          </div>
          <div className="space-y-4">
            {blockchainNetworks.map((network) => (
              <div key={network.name} className="border border-slate-200 rounded-lg p-4 hover:bg-slate-50">
                <div className="flex justify-between items-center mb-3">
                  <div className="flex items-center gap-3">
                    <div className={`w-3 h-3 rounded-full ${
                      network.status === "active" ? "bg-green-500" : 
                      network.status === "maintenance" ? "bg-yellow-500" : "bg-red-500"
                    }`}></div>
                    <div>
                      <h3 className="font-medium text-slate-900">{network.name}</h3>
                      <p className="text-sm text-slate-600">{network.symbol}</p>
                    </div>
                  </div>
                  <div className="text-right">
                    <p className="text-sm font-medium text-slate-900">{network.uptime}%</p>
                    <p className="text-xs text-slate-600">Uptime</p>
                  </div>
                </div>
                <div className="grid grid-cols-3 gap-4 text-sm">
                  <div>
                    <p className="text-slate-600">Transactions</p>
                    <p className="font-medium text-slate-900">{network.transactions.toLocaleString()}</p>
                  </div>
                  <div>
                    <p className="text-slate-600">Volume</p>
                    <p className="font-medium text-slate-900">{formatCurrency(network.volume, "USD")}</p>
                  </div>
                  <div>
                    <p className="text-slate-600">Fees</p>
                    <p className="font-medium text-slate-900">{network.fees}%</p>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default AdvanciaVisualDashboard;
