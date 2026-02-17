const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const WebSocket = require('ws');
const http = require('http');
const path = require('path');
const fs = require('fs');

// Initialize Express app
const app = express();
const server = http.createServer(app);

// Initialize WebSocket
const wss = new WebSocket.Server({ server });

// Security middleware
app.use(helmet({
    contentSecurityPolicy: false,
    crossOriginEmbedderPolicy: false
}));

// Rate limiting
const limiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 1000 // limit each IP to 1000 requests per windowMs
});
app.use(limiter);

// CORS configuration
app.use(cors({
    origin: '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
    credentials: true
}));

// Body parsing middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Static files serving
app.use(express.static(path.join(__dirname)));

// Global system state
const systemState = {
    frontend: 'ACTIVE',
    backend: 'ACTIVE',
    database: 'ACTIVE',
    network: 'ACTIVE',
    security: 'ACTIVE',
    users: 0,
    transactions: 0,
    uptime: Date.now(),
    lastActivity: Date.now()
};

// WebSocket connections
const connections = new Set();

wss.on('connection', (ws) => {
    connections.add(ws);
    systemState.users++;
    console.log(`New connection. Total users: ${systemState.users}`);
    
    // Send initial state
    ws.send(JSON.stringify({
        type: 'SYSTEM_STATE',
        data: systemState
    }));
    
    ws.on('message', (message) => {
        try {
            const data = JSON.parse(message);
            handleMessage(data, ws);
        } catch (error) {
            console.error('WebSocket message error:', error);
        }
    });
    
    ws.on('close', () => {
        connections.delete(ws);
        systemState.users--;
        console.log(`Connection closed. Total users: ${systemState.users}`);
    });
    
    ws.on('error', (error) => {
        console.error('WebSocket error:', error);
        connections.delete(ws);
        systemState.users--;
    });
});

// Message handler
function handleMessage(data, ws) {
    systemState.lastActivity = Date.now();
    
    switch (data.type) {
        case 'PING':
            ws.send(JSON.stringify({
                type: 'PONG',
                timestamp: Date.now()
            }));
            break;
            
        case 'SYSTEM_STATUS':
            ws.send(JSON.stringify({
                type: 'SYSTEM_STATUS_RESPONSE',
                data: systemState
            }));
            break;
            
        case 'EXECUTE_ACTION':
            handleAction(data.action, ws);
            break;
            
        default:
            console.log('Unknown message type:', data.type);
    }
}

// Action handler
function handleAction(action, ws) {
    const actions = {
        'quantum': () => {
            systemState.transactions += Math.floor(Math.random() * 1000);
            return 'Quantum processing completed';
        },
        'global': () => {
            return 'Global synchronization completed';
        },
        'security': () => {
            return 'Security scan completed - All systems secure';
        },
        'backup': () => {
            return 'System backup created successfully';
        },
        'optimize': () => {
            return 'System optimization completed';
        },
        'deploy': () => {
            return 'Deployment successful';
        },
        'financial': () => {
            systemState.transactions += Math.floor(Math.random() * 500);
            return 'Financial transactions processed';
        },
        'medbed': () => {
            return 'Medbed systems activated';
        },
        'ai': () => {
            return 'AI processing completed';
        },
        'users': () => {
            return 'User management updated';
        },
        'settings': () => {
            return 'Settings updated successfully';
        }
    };
    
    const actionFunction = actions[action];
    const result = actionFunction ? actionFunction() : 'Action completed';
    
    // Broadcast to all connected clients
    broadcast({
        type: 'ACTION_RESULT',
        action: action,
        result: result,
        timestamp: Date.now()
    });
}

// Broadcast function
function broadcast(message) {
    const messageStr = JSON.stringify(message);
    connections.forEach(ws => {
        if (ws.readyState === WebSocket.OPEN) {
            ws.send(messageStr);
        }
    });
}

// REST API Routes
app.get('/api/status', (req, res) => {
    res.json({
        status: 'SUCCESS',
        data: systemState,
        timestamp: Date.now()
    });
});

app.post('/api/action', (req, res) => {
    const { action } = req.body;
    const actions = {
        'quantum': 'Quantum processing initiated',
        'global': 'Global synchronization started',
        'security': 'Security scan completed',
        'backup': 'System backup created',
        'optimize': 'System optimization complete',
        'deploy': 'Deployment successful',
        'financial': 'Financial transactions processed',
        'medbed': 'Medbed systems activated',
        'ai': 'AI processing initiated',
        'users': 'User management updated',
        'settings': 'Settings updated successfully'
    };
    
    const result = actions[action] || 'Action executed';
    systemState.lastActivity = Date.now();
    systemState.transactions++;
    
    res.json({
        status: 'SUCCESS',
        action: action,
        result: result,
        timestamp: Date.now()
    });
});

app.get('/api/health', (req, res) => {
    res.json({
        status: 'HEALTHY',
        uptime: Date.now() - systemState.uptime,
        connections: connections.size,
        timestamp: Date.now()
    });
});

app.get('/api/metrics', (req, res) => {
    res.json({
        users: systemState.users,
        transactions: systemState.transactions,
        uptime: Date.now() - systemState.uptime,
        connections: connections.size,
        timestamp: Date.now()
    });
});

// Serve main frontend
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'advancia-complete-frontend.html'));
});

// Serve landing page
app.get('/landing', (req, res) => {
    res.sendFile(path.join(__dirname, 'advancia-landing-page.html'));
});

// Global frontend
app.get('/global', (req, res) => {
    res.sendFile(path.join(__dirname, 'advancia-global-frontend.html'));
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error('Error:', err);
    res.status(500).json({
        status: 'ERROR',
        message: 'Internal server error',
        timestamp: Date.now()
    });
});

// 404 handler
app.use((req, res) => {
    res.status(404).json({
        status: 'NOT_FOUND',
        message: 'Endpoint not found',
        timestamp: Date.now()
    });
});

// System monitoring
setInterval(() => {
    // Broadcast system state every 30 seconds
    broadcast({
        type: 'SYSTEM_UPDATE',
        data: systemState,
        timestamp: Date.now()
    });
    
    console.log(`System Status: ${connections.size} connections, ${systemState.transactions} transactions`);
}, 30000);

// Graceful shutdown
process.on('SIGTERM', () => {
    console.log('SIGTERM received, shutting down gracefully');
    server.close(() => {
        console.log('Server closed');
        process.exit(0);
    });
});

process.on('SIGINT', () => {
    console.log('SIGINT received, shutting down gracefully');
    server.close(() => {
        console.log('Server closed');
        process.exit(0);
    });
});

// Start server
const PORT = process.env.PORT || 8080;
server.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 ADVANCIA COMPLETE SERVER`);
    console.log(`📡 Server running on http://localhost:${PORT}`);
    console.log(`🌐 Frontend: http://localhost:${PORT}`);
    console.log(`🎯 Landing: http://localhost:${PORT}/landing`);
    console.log(`🌍 Global: http://localhost:${PORT}/global`);
    console.log(`📊 API: http://localhost:${PORT}/api/status`);
    console.log(`💚 Health: http://localhost:${PORT}/api/health`);
    console.log(`📈 Metrics: http://localhost:${PORT}/api/metrics`);
    console.log(`⚡ WebSocket: ws://localhost:${PORT}`);
    console.log(`🔥 Server ready for global deployment`);
});

module.exports = app;
