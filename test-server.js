#!/usr/bin/env node

/**
 * Test script for Locazur server
 * Run: node test-server.js
 */

const http = require('http');

const BASE_URL = 'http://localhost:3000';

console.log('🧪 Testing Locazur Server\n');

// Test 1: Health check
function testHealth() {
  return new Promise((resolve) => {
    http.get(`${BASE_URL}/api/health`, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          const json = JSON.parse(data);
          console.log('✅ Health check:', json.message);
          console.log('   Stats:', json.stats);
          resolve(true);
        } catch (e) {
          console.log('❌ Health check failed');
          resolve(false);
        }
      });
    }).on('error', () => {
      console.log('❌ Server not running on port 3000');
      resolve(false);
    });
  });
}

// Test 2: Get destinations
function testGetDestinations() {
  return new Promise((resolve) => {
    http.get(`${BASE_URL}/api/destinations`, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          const json = JSON.parse(data);
          if (json.success && Array.isArray(json.data)) {
            console.log(`✅ Get destinations: ${json.data.length} destinations found`);
            json.data.forEach(dest => {
              console.log(`   - ${dest.name} (${dest.latitude}, ${dest.longitude})`);
            });
            resolve(true);
          } else {
            console.log('❌ Get destinations: invalid response');
            resolve(false);
          }
        } catch (e) {
          console.log('❌ Get destinations: parse error');
          resolve(false);
        }
      });
    }).on('error', (e) => {
      console.log('❌ Get destinations:', e.message);
      resolve(false);
    });
  });
}

// Test 3: Add destination
function testAddDestination() {
  return new Promise((resolve) => {
    const postData = JSON.stringify({
      name: 'Lyon',
      latitude: 45.7640,
      longitude: 4.8357,
      country: 'France'
    });

    const options = {
      hostname: 'localhost',
      port: 3000,
      path: '/api/destinations',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': postData.length
      }
    };

    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          const json = JSON.parse(data);
          if (json.success) {
            console.log('✅ Add destination:', json.data.name);
            resolve(true);
          } else {
            console.log('❌ Add destination failed');
            resolve(false);
          }
        } catch (e) {
          console.log('❌ Add destination: parse error');
          resolve(false);
        }
      });
    });

    req.on('error', (e) => {
      console.log('❌ Add destination:', e.message);
      resolve(false);
    });

    req.write(postData);
    req.end();
  });
}

// Test 4: Get devices
function testGetDevices() {
  return new Promise((resolve) => {
    http.get(`${BASE_URL}/api/devices`, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          const json = JSON.parse(data);
          if (json.success) {
            console.log(`✅ Get devices: ${json.data.length} device(s) connected`);
            resolve(true);
          } else {
            console.log('❌ Get devices: invalid response');
            resolve(false);
          }
        } catch (e) {
          console.log('❌ Get devices: parse error');
          resolve(false);
        }
      });
    }).on('error', (e) => {
      console.log('❌ Get devices:', e.message);
      resolve(false);
    });
  });
}

// Run all tests
async function runTests() {
  const results = [];

  results.push(await testHealth());
  results.push(await testGetDestinations());
  results.push(await testAddDestination());
  results.push(await testGetDevices());

  console.log('\n' + '='.repeat(50));
  const passed = results.filter(r => r).length;
  const total = results.length;
  console.log(`📊 Results: ${passed}/${total} tests passed`);

  if (passed === total) {
    console.log('🎉 All tests passed! Server is working correctly.');
  } else {
    console.log('⚠️  Some tests failed. Check server logs.');
  }
}

runTests();
