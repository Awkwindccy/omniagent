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

# System deps for sharp + puppeteer
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl python3 make g++ chromium ca-certificates \
    fonts-liberation libasound2 libatk-bridge2.0-0 libcups2 libdrm2 \
    libgbm1 libnss3 libxcomposite1 libxdamage1 libxrandr2 xdg-utils && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Server deps
COPY server/package.json server/yarn.lock ./
RUN yarn install --production --network-timeout 100000 && yarn cache clean

# Collector deps
COPY collector/package.json collector/yarn.lock ../collector/
RUN cd ../collector && yarn install --production --network-timeout 100000 && yarn cache clean

# Copy all source
COPY server/ ./
COPY collector/ ../collector/

# Frontend static files
COPY --from=frontend-build /app/frontend/dist ./public

# Prisma client
RUN npx prisma generate

# Startup script
COPY docker/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

ENV NODE_ENV=production
ENV STORAGE_DIR=/app/server/storage
EXPOSE 3001

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://localhost:3001/api/ping || exit 1

ENTRYPOINT ["/usr/local/bin/start.sh"]
