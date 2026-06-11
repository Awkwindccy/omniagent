#!/bin/bash
set -e

echo "🚀 OmniAgent starting..."

# Setup database
echo "📦 Setting up database..."
cd /app/server
npx prisma generate
npx prisma migrate deploy

# Start both server and collector via supervisord
echo "✅ Starting OmniAgent services..."
exec supervisord -c /etc/supervisor/conf.d/supervisord.conf
