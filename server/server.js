const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const cors = require('cors');
require('dotenv').config();

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"]
  }
});

// Middleware
app.use(cors());
app.use(express.json());

// In-memory storage for destinations
let destinations = [
  { id: 1, name: "Paris", latitude: 48.8566, longitude: 2.3522, country: "France" },
  { id: 2, name: "New York", latitude: 40.7128, longitude: -74.0060, country: "USA" },
  { id: 3, name: "Tokyo", latitude: 35.6762, longitude: 139.6503, country: "Japan" },
  { id: 4, name: "London", latitude: 51.5074, longitude: -0.1278, country: "UK" },
  { id: 5, name: "Sydney", latitude: -33.8688, longitude: 151.2093, country: "Australia" },
  { id: 6, name: "Dubai", latitude: 25.2048, longitude: 55.2708, country: "UAE" },
  { id: 7, name: "Rome", latitude: 41.9028, longitude: 12.4964, country: "Italy" },
  { id: 8, name: "Barcelona", latitude: 41.3851, longitude: 2.1734, country: "Spain" }
];

// Connected devices tracking
const connectedDevices = new Map();

// API Routes

// Get all destinations
app.get('/api/destinations', (req, res) => {
  res.json({
    success: true,
    data: destinations
  });
});

// Get single destination
app.get('/api/destinations/:id', (req, res) => {
  const destination = destinations.find(d => d.id === parseInt(req.params.id));
  if (!destination) {
    return res.status(404).json({ success: false, error: 'Destination not found' });
  }
  res.json({ success: true, data: destination });
});

// Add new destination
app.post('/api/destinations', (req, res) => {
  const { name, latitude, longitude, country } = req.body;

  if (!name || !latitude || !longitude) {
    return res.status(400).json({
      success: false,
      error: 'Name, latitude, and longitude are required'
    });
  }

  const newDestination = {
    id: destinations.length > 0 ? Math.max(...destinations.map(d => d.id)) + 1 : 1,
    name,
    latitude: parseFloat(latitude),
    longitude: parseFloat(longitude),
    country: country || ''
  };

  destinations.push(newDestination);
  res.json({ success: true, data: newDestination });
});

// Delete destination
app.delete('/api/destinations/:id', (req, res) => {
  const index = destinations.findIndex(d => d.id === parseInt(req.params.id));
  if (index === -1) {
    return res.status(404).json({ success: false, error: 'Destination not found' });
  }
  destinations.splice(index, 1);
  res.json({ success: true, message: 'Destination deleted' });
});

// Device registration
app.post('/api/devices/register', (req, res) => {
  const { deviceId, deviceName } = req.body;
  const deviceInfo = {
    deviceId: deviceId || `device_${Date.now()}`,
    deviceName: deviceName || 'iPhone',
    connectedAt: new Date().toISOString(),
    currentLocation: null
  };
  connectedDevices.set(deviceInfo.deviceId, deviceInfo);
  res.json({ success: true, data: deviceInfo });
});

// Get all connected devices
app.get('/api/devices', (req, res) => {
  const devices = Array.from(connectedDevices.values());
  res.json({ success: true, data: devices });
});

// Health check
app.get('/api/health', (req, res) => {
  res.json({
    success: true,
    message: 'Locazur Location Server is running',
    timestamp: new Date().toISOString(),
    stats: {
      destinations: destinations.length,
      connectedDevices: connectedDevices.size
    }
  });
});

// WebSocket connection handling
io.on('connection', (socket) => {
  console.log('New client connected:', socket.id);

  // Device joins with its ID
  socket.on('device:join', (deviceId) => {
    socket.join(deviceId);
    console.log(`Device ${deviceId} joined room`);
  });

  // Location update from device
  socket.on('location:update', (data) => {
    const { deviceId, latitude, longitude, simulated } = data;
    const device = connectedDevices.get(deviceId);
    if (device) {
      device.currentLocation = { latitude, longitude, simulated, timestamp: new Date().toISOString() };
      // Broadcast to all devices in the room
      io.to(deviceId).emit('location:current', device.currentLocation);
    }
  });

  // Request location change from admin/client
  socket.on('location:set', (data) => {
    const { deviceId, destinationId, latitude, longitude } = data;
    console.log(`Location set request for device ${deviceId}`);

    // Send to specific device
    socket.to(deviceId).emit('location:change', {
      latitude: latitude || null,
      longitude: longitude || null,
      destinationId: destinationId || null,
      timestamp: new Date().toISOString()
    });

    // Confirm to requester
    socket.emit('location:set:ack', {
      success: true,
      message: `Location change sent to device ${deviceId}`,
      timestamp: new Date().toISOString()
    });
  });

  socket.on('disconnect', () => {
    console.log('Client disconnected:', socket.id);
  });
});

// Start server
const PORT = process.env.PORT || 3000;
const HOST = process.env.HOST || '0.0.0.0';

server.listen(PORT, HOST, () => {
  console.log(`🚀 Locazur Location Server running on http://${HOST}:${PORT}`);
  console.log(`📡 WebSocket server ready`);
  console.log(`🌍 CORS enabled for all origins`);
});

module.exports = { app, server, io };
