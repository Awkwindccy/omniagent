# OmniAgent

<p align="center">
  <img src="https://img.shields.io/badge/license-MIT-blue" alt="License">
  <img src="https://img.shields.io/badge/node-%3E%3D18.12.1-green" alt="Node">
  <img src="https://img.shields.io/badge/PRs-welcome-brightgreen" alt="PRs">
  <img src="https://img.shields.io/badge/status-active-success" alt="Status">
</p>

An AI agent platform with RAG, multi-model support, and autonomous tool execution. Built on top of [AnythingLLM](https://github.com/Mintplex-Labs/anything-llm).

## Quick Start

### Prerequisites

- **Node.js** >= 18.12.1
- **Yarn**: `npm install -g yarn`
- **Git**

### 3 步启动

```bash
# 1. 克隆项目
git clone https://github.com/Awkwindccy/omniagent.git
cd omniagent

# 2. 安装依赖 + 初始化数据库
npm run setup

# 3. 启动
npm run dev
```

打开 **http://localhost:3000** → 按网页引导选择模型、填入 API Key → 开始聊天。

> 💡 **API Key 可以在网页上配**，不用手动编辑 `.env`。如果你更习惯配置文件的，在 `server/.env` 里填你的 Key 也可以。

### 推荐 LLM

| Provider | Cost | Signup |
|----------|------|--------|
| **DeepSeek** | ~$0.14/1M tokens | [platform.deepseek.com](https://platform.deepseek.com) |
| **Ollama** | Free (local) | [ollama.com](https://ollama.com) |

### 文档上传（可选）

文本文件上传无需额外配置。PDF/Word/图片处理需要单独启动 Collector：

```bash
cd collector && yarn install && node index.js
```

> Mac/Linux 开箱即用。Windows 需安装 [Visual Studio Build Tools](https://visualstudio.microsoft.com/zh-hans/downloads/)（勾选"使用 C++ 的桌面开发"）。

### Troubleshooting

| 问题 | 解决 |
|------|------|
| `yarn: command not found` | `npm install -g yarn` |
| 端口 3000 被占用 | `cd frontend && npx vite --port 3002` |
| 页面循环回到引导页 | 确认 `server/.env` 里有 `NODE_ENV=development` |
| Collector 装不上 | 不影响核心聊天功能，跳过即可 |

### Troubleshooting

| Issue | Fix |
|-------|-----|
| Port 3000 already in use | Change Vite port: `cd frontend && npx vite --port 3002` |
| Collector not starting | It's optional — chat still works without it |
| `yarn: command not found` | `npm install -g yarn` |

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
