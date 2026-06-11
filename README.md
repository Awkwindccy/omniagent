# OmniAgent

An AI agent platform with RAG, multi-model support, and autonomous tool execution. Built on top of [AnythingLLM](https://github.com/Mintplex-Labs/anything-llm).

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
│   ├── src/
│   │   ├── components/   # UI components
│   │   ├── pages/        # Page components
│   │   ├── hooks/        # Custom React hooks
│   │   ├── models/       # API interaction layer
│   │   ├── locales/      # 25+ language translations
│   │   └── media/        # Images, icons, animations
│   └── public/           # Static assets
├── server/            # Express backend
│   ├── endpoints/        # API route handlers
│   ├── models/           # Database models
│   ├── utils/
│   │   ├── AiProviders/      # 30+ LLM integrations
│   │   ├── vectorDbProviders/# 10+ vector DB integrations
│   │   ├── EmbeddingEngines/ # 15+ embedding providers
│   │   ├── agents/           # Agent framework (AIbitat)
│   │   ├── chats/            # Chat/streaming logic
│   │   └── DocumentManager/  # Document processing
│   └── prisma/           # Database schema & migrations
└── LICENSE
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
