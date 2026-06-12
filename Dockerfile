# ─── Frontend Build ───
FROM node:18-slim AS frontend-build
WORKDIR /app/frontend
COPY frontend/package.json frontend/yarn.lock ./
RUN yarn install --network-timeout 100000 && yarn cache clean
COPY frontend/ ./
RUN yarn build

# ─── Production ───
FROM node:18-slim
WORKDIR /app/server

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install server deps
COPY server/package.json server/yarn.lock ./
RUN yarn install --network-timeout 100000 && yarn cache clean

# Copy source
COPY server/ ./

# Copy built frontend
COPY --from=frontend-build /app/frontend/dist ./public

# Generate Prisma client
RUN npx prisma generate

# Startup
COPY docker/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

ENV NODE_ENV=production
ENV STORAGE_DIR=/app/server/storage
EXPOSE 3001

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://localhost:3001/api/ping || exit 1

ENTRYPOINT ["/usr/local/bin/start.sh"]
