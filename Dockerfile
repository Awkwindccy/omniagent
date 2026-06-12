# ─── Frontend Build ───
FROM node:18-slim AS frontend-build
WORKDIR /app/frontend
COPY frontend/package.json frontend/yarn.lock ./
RUN yarn install --network-timeout 100000 && yarn cache clean
COPY frontend/ ./
RUN yarn build

# ─── Production ───
FROM node:18-slim

# System deps for server + collector (sharp, puppeteer, chromium)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl python3 make g++ chromium ca-certificates \
    fonts-liberation libasound2 libatk-bridge2.0-0 libcups2 libdrm2 \
    libgbm1 libnss3 libxcomposite1 libxdamage1 libxrandr2 xdg-utils \
    libvips-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# ─── Server ───
WORKDIR /app/server
COPY server/package.json server/yarn.lock ./
RUN yarn install --network-timeout 100000 && yarn cache clean
COPY server/ ./
COPY --from=frontend-build /app/frontend/dist ./public
RUN npx prisma generate

# ─── Collector ───
WORKDIR /app/collector
COPY collector/package.json collector/yarn.lock ./
RUN yarn install --network-timeout 100000 && yarn cache clean
COPY collector/ ./

# ─── Startup ───
COPY docker/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

ENV NODE_ENV=production
ENV STORAGE_DIR=/app/server/storage
EXPOSE 3001

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://localhost:3001/api/ping || exit 1

ENTRYPOINT ["/usr/local/bin/start.sh"]
