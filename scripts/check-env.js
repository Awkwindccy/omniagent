#!/usr/bin/env node

/**
 * OmniAgent — Environment Check
 * Run before `npm run dev` to ensure all prerequisites are met.
 * Usage: node scripts/check-env.js
 */

const { execSync } = require("child_process");
const fs = require("fs");
const path = require("path");
const net = require("net");

const ROOT = path.resolve(__dirname, "..");
const OK = "\x1b[32m✅\x1b[0m";
const FAIL = "\x1b[31m❌\x1b[0m";
const WARN = "\x1b[33m⚠️\x1b[0m";

let errors = 0;

function check(label, fn) {
  try {
    fn();
    console.log(`  ${OK} ${label}`);
  } catch (e) {
    console.log(`  ${FAIL} ${label} — ${e.message}`);
    errors++;
  }
}

console.log("\n🔍 OmniAgent — 环境检查\n");

// ─── Node.js version ───
check("Node.js >= 18.12.1", () => {
  const v = process.versions.node.split(".").map(Number);
  if (v[0] < 18 || (v[0] === 18 && v[1] < 12)) {
    throw new Error(`Node ${process.version} 太旧，请升级到 18.12.1+`);
  }
  console.log(`     (当前: ${process.version})`);
});

// ─── Yarn ───
check("Yarn 已安装", () => {
  try {
    execSync("yarn --version", { stdio: "ignore" });
  } catch {
    throw new Error("请先安装 Yarn: npm install -g yarn");
  }
});

// ─── server/.env ───
check("server/.env 配置文件", () => {
  const envFile = path.join(ROOT, "server", ".env");
  if (!fs.existsSync(envFile)) {
    throw new Error("缺少 server/.env，请复制 .env.example 并填入配置");
  }
  const content = fs.readFileSync(envFile, "utf8");
  const required = ["LLM_PROVIDER", "JWT_SECRET"];
  for (const key of required) {
    if (!content.includes(key + "=")) {
      throw new Error(`server/.env 缺少配置项: ${key}`);
    }
  }
});

// ─── Node modules ───
check("server node_modules", () => {
  if (!fs.existsSync(path.join(ROOT, "server", "node_modules", "express"))) {
    throw new Error("请先运行: npm run setup");
  }
});

check("frontend node_modules", () => {
  if (!fs.existsSync(path.join(ROOT, "frontend", "node_modules", "react"))) {
    throw new Error("请先运行: npm run setup");
  }
});

// ─── Port availability ───
function isPortFree(port) {
  return new Promise((resolve) => {
    const server = net.createServer();
    server.once("error", () => resolve(false));
    server.once("listening", () => {
      server.close();
      resolve(true);
    });
    server.listen(port);
  });
}

// Port check is async
(async () => {
  console.log("");
  for (const port of [3000, 3001, 8888]) {
    const free = await isPortFree(port);
    if (free) {
      console.log(`  ${OK} 端口 ${port} 可用`);
    } else {
      console.log(`  ${WARN} 端口 ${port} 被占用（启动可能失败）`);
    }
  }

  console.log("");
  if (errors > 0) {
    console.log(`  ${FAIL} 发现 ${errors} 个问题，请修复后重试\n`);
    process.exit(1);
  } else {
    console.log(`  ${OK} 环境就绪，可以启动: npm run dev\n`);
  }
})();
