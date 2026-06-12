#!/bin/bash
set -e

echo "🚀 OmniAgent starting..."

# Run database migrations
cd /app
echo "📦 Running database migrations..."
npx prisma migrate deploy 2>/dev/null || echo "   (migrations skipped - first run?)"

# Start collector in background
echo "📄 Starting document processor..."
cd /app/collector && node index.js &

# Start server
echo "✅ Starting OmniAgent on port 3001..."
cd /app && exec node index.js
