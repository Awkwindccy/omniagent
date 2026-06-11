# OmniAgent

An AI agent platform with RAG, multi-model support, and autonomous tool execution.

Built on top of [AnythingLLM](https://github.com/Mintplex-Labs/anything-llm).

## Setup

### Backend
```bash
cd server
yarn install
cp .env.example .env
# Edit .env with your API keys
npx prisma generate
npx prisma migrate deploy
node index.js
```

### Frontend
```bash
cd frontend
yarn install
npx vite --host
```
