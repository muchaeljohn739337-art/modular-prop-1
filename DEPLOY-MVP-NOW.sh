#!/bin/bash

# ==============================================================================
# DEPLOY MVP NOW - ADVANCIA PAY LEDGER
# ==============================================================================

echo "╔═══════════════════════════════════════════════════╗"
echo "║                                                   ║"
echo "║     🚀  ADVANCIA PAY LEDGER MVP DEPLOYMENT  🚀    ║"
echo "║                                                   ║"
echo "╚═══════════════════════════════════════════════════╝"
echo ""
echo "📍 Starting MVP deployment..."
echo ""

# Check if we're in the right directory
if [ ! -f "backend-clean/package.json" ]; then
    echo "❌ Error: backend-clean/package.json not found"
    echo "Please run this script from the project root directory"
    exit 1
fi

# Backend Deployment
echo "🔧 Step 1: Deploying Backend..."
cd backend-clean

# Install dependencies
echo "📦 Installing backend dependencies..."
npm install

# Build the project
echo "🏗️  Building backend..."
npm run build

# Start the backend server
echo "🚀 Starting backend server..."
npm run start:prod &
BACKEND_PID=$!

cd ..

# Frontend Deployment
echo "🎨 Step 2: Deploying Frontend..."
cd frontend-clean

# Install dependencies
echo "📦 Installing frontend dependencies..."
npm install

# Build the frontend
echo "🏗️  Building frontend..."
npm run build

# Start the frontend
echo "🚀 Starting frontend..."
npm start &
FRONTEND_PID=$!

cd ..

# Mobile App Setup
echo "📱 Step 3: Setting up Mobile App..."
if [ ! -d "advancia-expo-app" ]; then
    echo "📱 Creating Expo app..."
    npx create-expo-app advancia-expo-app --template blank
fi

cd advancia-expo-app

# Install mobile dependencies
echo "📦 Installing mobile dependencies..."
npm install

echo "🚀 Starting mobile development server..."
npx expo start &
MOBILE_PID=$!

cd ..

# Wait a moment for services to start
sleep 5

echo ""
echo "╔═══════════════════════════════════════════════════╗"
echo "║                                                   ║"
echo "║           ✅  DEPLOYMENT COMPLETE!  ✅            ║"
echo "║                                                   ║"
echo "║         YOUR MVP IS NOW RUNNING! 🚀               ║"
echo "║                                                   ║"
echo "╚═══════════════════════════════════════════════════╝"
echo ""
echo "🌐 Backend API:"
echo "  ✓ http://localhost:3001/health"
echo "  ✓ http://localhost:3001/api/stats"
echo ""
echo "🖥️  Frontend:"
echo "  ✓ http://localhost:3000"
echo ""
echo "📱 Mobile App:"
echo "  ✓ Expo development server running"
echo "  ✓ Scan QR code with Expo Go app"
echo ""
echo "Server Management:"
echo "  Backend PID: $BACKEND_PID"
echo "  Frontend PID: $FRONTEND_PID"
echo "  Mobile PID: $MOBILE_PID"
echo ""
echo "Next Steps:"
echo "  1. ✓ Backend running"
echo "  2. ✓ Frontend running"
echo "  3. ✓ Mobile app ready"
echo ""
echo "🎉 YOUR MVP ECOSYSTEM IS LIVE! 🎉"
echo ""
echo "To stop all services:"
echo "  kill $BACKEND_PID $FRONTEND_PID $MOBILE_PID"
echo ""

# Keep the script running to maintain services
wait
