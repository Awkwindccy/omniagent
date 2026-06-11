# OmniAgent

<p align="center">
  <img src="https://img.shields.io/badge/license-MIT-blue" alt="License">
  <img src="https://img.shields.io/badge/node-%3E%3D18.12.1-green" alt="Node">
  <img src="https://img.shields.io/badge/PRs-welcome-brightgreen" alt="PRs">
  <img src="https://img.shields.io/badge/status-active-success" alt="Status">
</p>

An AI agent platform with RAG, multi-model support, and autonomous tool execution. Built on top of [AnythingLLM](https://github.com/Mintplex-Labs/anything-llm).

## Quick Start (30 seconds)

```bash
# 1. Clone
git clone https://github.com/Awkwindccy/omniagent.git
cd omniagent

# 2. Configure
cp .env.example server/.env
# Edit server/.env → add your DeepSeek API key

# 3. Install & Run
npm run setup     # Install all dependencies
npm run dev       # Start server + collector + frontend
```

Open http://localhost:3000 — that's it.

> 💡 Need an API key? [DeepSeek](https://platform.deepseek.com) offers cheap API access. Or use [Ollama](https://ollama.com) for free local models.

## Features

- **Multi-LLM Support** — 30+ AI providers (OpenAI, Claude, DeepSeek, Ollama, etc.)
- **RAG Pipeline** — Upload documents, auto-chunk, embed, and chat with your data
- **Agent System** — AI autonomously uses tools: web search, file operations, email, calendar, SQL
- **Multi-User** — Team workspaces with role-based access control
- **Extensible** — MCP protocol support for custom tools, embeddable chat widgets

## Architecture

```
┌──────────────┐     ┌──────────────────┐     ┌───────────────┐
│  React (Vite) │────▶│  Node.js/Express  │────▶│  SQLite/Prisma │
│  Frontend     │     │  Backend API      │     │  Database      │
└──────────────┘     └───────┬──────────┘     └───────────────┘
                             │
          ┌──────────────────┼──────────────────┐
          ▼                  ▼                  ▼
   ┌────────────┐    ┌────────────┐    ┌────────────────┐
   │ Collector  │    │ Vector DB  │    │  30+ LLMs      │
   │ 文档解析    │    │ 向量存储    │    │  AI 提供商      │
   └────────────┘    └────────────┘    └────────────────┘
            ┌────────────────┼────────────────┐
            ▼                ▼                ▼
     ┌──────────┐    ┌──────────┐    ┌──────────────┐
     │Vector DB │    │Embedding │    │  30+ LLMs    │
     │LanceDB   │    │Engine    │    │  Providers   │
     └──────────┘    └──────────┘    └──────────────┘
```

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | React 18, Vite 4, Tailwind CSS, React Router |
| Backend | Node.js, Express, Prisma ORM |
| Database | SQLite (default), PostgreSQL, MySQL, MSSQL |
| Vector DB | LanceDB, Pinecone, Chroma, Qdrant, Weaviate, Milvus |
| AI/ML | LangChain, OpenAI SDK, Anthropic SDK, Ollama |
| Agent Framework | Custom AIbitat multi-agent system |

## Quick Start

### Prerequisites

- Node.js >= 18.12.1
- Yarn

### Backend

```bash
cd server
yarn install
cp .env.example .env
# Edit .env with your LLM provider and API key (e.g. DeepSeek, OpenAI, etc.)
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

Open http://localhost:3000 in your browser.

## Project Structure

```
omniagent/
├── frontend/          # React + Vite frontend
├── server/            # Express backend API
├── collector/         # Document processing service
├── docker/            # Docker deployment config
├── .github/workflows/ # CI/CD pipeline
├── scripts/           # Dev utilities
├── package.json       # Root orchestration (npm run dev)
├── .env.example       # Environment template
├── .editorconfig      # Code style
└── .prettierrc        # Code formatting
```

## Environment Variables

See `server/.env.example` for the full list. Key variables:

| Variable | Description |
|----------|-------------|
| `LLM_PROVIDER` | AI provider (openai, anthropic, deepseek, ollama, etc.) |
| `EMBEDDING_ENGINE` | Embedding provider (native, openai, ollama, etc.) |
| `VECTOR_DB` | Vector database (lancedb, pinecone, chroma, etc.) |

## License

MIT — See [LICENSE](./LICENSE) for details.

Originally based on [AnythingLLM](https://github.com/Mintplex-Labs/anything-llm) by Mintplex Labs.
