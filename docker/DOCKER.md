# OmniAgent Docker Guide

## Quick Start

1. Copy and configure environment:
```bash
cp docker/.env.example docker/.env
# Edit docker/.env with your API keys
```

2. Build and start:
```bash
cd docker
docker compose up -d
```

3. Open http://localhost:3001

## One-Command Production Deploy

```bash
cp docker/.env.example docker/.env && \
nano docker/.env && \
cd docker && docker compose up -d
```

## Management

```bash
# View logs
docker compose logs -f

# Restart
docker compose restart

# Stop
docker compose down

# Rebuild after code changes
docker compose up -d --build
```
