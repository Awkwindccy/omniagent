#!/usr/bin/env node

/**
 * OmniAgent Development Launcher
 * Starts server + collector + frontend simultaneously.
 * Usage: npm run dev
 */

const { spawn } = require("child_process");
const path = require("path");

const ROOT = path.resolve(__dirname, "..");

const services = [
  {
    name: "Server",
    cwd: path.join(ROOT, "server"),
    command: "node",
    args: ["index.js"],
    color: "\x1b[36m",
  },
  {
    name: "Collector",
    cwd: path.join(ROOT, "collector"),
    command: "node",
    args: ["index.js"],
    color: "\x1b[33m",
  },
  {
    name: "Frontend",
    cwd: path.join(ROOT, "frontend"),
    command: "npx",
    args: ["vite", "--host"],
    color: "\x1b[32m",
  },
];

console.log("\n🚀 Starting OmniAgent development services...\n");

services.forEach(({ name, cwd, command, args, color }) => {
  const child = spawn(command, args, {
    cwd,
    stdio: "pipe",
    shell: true,
  });

  child.stdout.on("data", (data) => {
    data
      .toString()
      .split("\n")
      .filter(Boolean)
      .forEach((line) => console.log(`${color}[${name}]\x1b[0m ${line}`));
  });

  child.stderr.on("data", (data) => {
    data
      .toString()
      .split("\n")
      .filter(Boolean)
      .forEach((line) => console.error(`${color}[${name}]\x1b[0m ${line}`));
  });

  child.on("error", (err) =>
    console.error(`${color}[${name}]\x1b[0m Failed to start: ${err.message}`)
  );
});

console.log("✅ All services started!\n");
console.log("   Frontend : http://localhost:3000");
console.log("   Server   : http://localhost:3001");
console.log("   Collector: http://localhost:8888\n");
