# ─── Frontend Build ───
FROM node:18-slim AS frontend-build
WORKDIR /app/frontend
COPY frontend/package.json frontend/yarn.lock ./
RUN yarn install --network-timeout 100000 && yarn cache clean
COPY frontend/ ./
RUN yarn build

# ─── Production ───
FROM node:18-slim
WORKDIR /app

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl python3 make g++ && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Server deps
COPY server/package.json server/yarn.lock server/.env.example ./
RUN yarn install --production --network-timeout 100000 && yarn cache clean

# Collector deps
COPY collector/package.json collector/yarn.lock ./collector/
RUN cd collector && yarn install --production --network-timeout 100000 && yarn cache clean

# Copy source
COPY server/ ./
COPY collector/ ./collector/

# Frontend static files
COPY --from=frontend-build /app/frontend/dist ./server/public

# Setup
COPY docker/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh && \
    cd /app && npx prisma generate

ENV NODE_ENV=production
EXPOSE 3001

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://localhost:3001/api/ping || exit 1

ENTRYPOINT ["/usr/local/bin/start.sh"]
