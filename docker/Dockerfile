# ─── Frontend Build Stage ───
FROM node:18-slim AS frontend-build
WORKDIR /app/frontend
COPY frontend/package.json frontend/yarn.lock ./
RUN yarn install --network-timeout 100000 && yarn cache clean
COPY frontend/ ./
RUN yarn build

# ─── Backend Build Stage ───
FROM node:18-slim AS backend-build
WORKDIR /app/server
COPY server/package.json server/yarn.lock ./
RUN yarn install --production --network-timeout 100000 && yarn cache clean
COPY server/ ./
# Remove dev-only files
RUN rm -rf __tests__

# ─── Production Stage ───
FROM node:18-slim
WORKDIR /app

# Install runtime deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl netcat-openbsd && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy server
COPY --from=backend-build --chown=node:node /app/server /app/server

# Copy built frontend into server/public
COPY --from=frontend-build --chown=node:node /app/frontend/dist /app/server/public

# Copy startup script
COPY docker/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

USER node
WORKDIR /app/server

ENV NODE_ENV=production

EXPOSE 3001
ENTRYPOINT ["/bin/bash", "/usr/local/bin/docker-entrypoint.sh"]
