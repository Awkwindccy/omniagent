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
RUN rm -rf __tests__

# ─── Collector Build Stage ───
FROM node:18-slim AS collector-build
WORKDIR /app/collector
COPY collector/package.json collector/yarn.lock ./
RUN yarn install --production --network-timeout 100000 && yarn cache clean
COPY collector/ ./

# ─── Production Stage ───
FROM node:18-slim
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl netcat-openbsd supervisor && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy all services
COPY --from=backend-build --chown=node:node /app/server /app/server
COPY --from=frontend-build --chown=node:node /app/frontend/dist /app/server/public
COPY --from=collector-build --chown=node:node /app/collector /app/collector

# Startup script
COPY docker/docker-entrypoint.sh /usr/local/bin/
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN mkdir -p /app/collector/hotdir /app/collector/outputs /app/collector/storage && \
    chown -R node:node /app

USER node
ENV NODE_ENV=production
EXPOSE 3001 8888

ENTRYPOINT ["/bin/bash", "/usr/local/bin/docker-entrypoint.sh"]
