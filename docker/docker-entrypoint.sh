#!/bin/bash
set -e

echo "🚀 OmniAgent starting..."

# Generate Prisma client and run migrations
echo "📦 Setting up database..."
npx prisma generate
npx prisma migrate deploy

# Start the server
echo "✅ Starting OmniAgent on port 3001..."
exec node index.js
