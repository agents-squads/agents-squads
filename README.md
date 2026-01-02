# Agents Squads

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![CLI](https://img.shields.io/npm/v/squads-cli?label=squads-cli)](https://www.npmjs.com/package/squads-cli)

**AI systems you can learn, understand, and trust.**

> Trust requires understanding. Understanding requires learning.
>
> We build AI systems designed to be learned — not black boxes, but transparent systems your team can study, modify, and own.

## What is this?

A framework for organizing autonomous AI agents into domain-aligned teams (squads) with persistent memory, goal tracking, and observability. Built for Claude Code.

**No complex infrastructure.** Agents are markdown files. Memory is markdown files. Run locally with Docker.

```
┌─────────────────────────────────────────────────────────────┐
│                     AGENTS SQUADS                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │ Engineering │  │  Research   │  │  Marketing  │  ...     │
│  │    Squad    │  │    Squad    │  │    Squad    │          │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘          │
│         │                │                │                  │
│         ▼                ▼                ▼                  │
│  ┌─────────────────────────────────────────────────────┐    │
│  │                 Shared Memory (Engram)               │    │
│  └─────────────────────────────────────────────────────┘    │
│                           │                                  │
│                           ▼                                  │
│  ┌─────────────────────────────────────────────────────┐    │
│  │              Observability (Langfuse)                │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Quick Start

```bash
# Install the CLI
npm install -g squads-cli

# Clone this repo for infrastructure
git clone https://github.com/agents-squads/agents-squads
cd agents-squads

# Start services (Postgres, Redis, Neo4j, Langfuse)
docker compose up -d

# Initialize your project
squads init

# Check status
squads dash
```

## Project Structure

```
agents-squads/
├── hq/                      # Headquarters (coordination)
│   ├── .agents/
│   │   ├── squads/          # Squad definitions
│   │   └── memory/          # Cross-domain memory
│   └── CLAUDE.md
│
├── domains/                 # Domain outputs
│   ├── engineering/
│   ├── research/
│   ├── marketing/
│   └── finance/
│
├── mcp/                     # MCP server configs
├── docker/                  # Infrastructure
├── docker-compose.yml       # Local services
└── .env.example             # Environment template
```

## Infrastructure

Local development stack:

| Service | Port | Purpose |
|---------|------|---------|
| PostgreSQL | 5432 | Primary data store |
| Redis | 6379 | Cache, queues, rate limiting |
| Neo4j | 7474 | Knowledge graph |
| Langfuse | 3000 | LLM observability |

```bash
# Start everything
docker compose up -d

# View Langfuse dashboard (costs, traces, evals)
open http://localhost:3000

# View Neo4j browser (knowledge graph)
open http://localhost:7474
```

## Defining Squads

### SQUAD.md

```markdown
# Engineering Squad

## Mission
Ship reliable software. Reduce technical debt. Improve developer experience.

## Goals

| Priority | Goal | Progress |
|----------|------|----------|
| P1 | Reduce build time to <3min | 60% |
| P2 | 90% test coverage on core | 45% |

## Agents

| Agent | Purpose | Trigger |
|-------|---------|---------|
| ci-optimizer | Optimize CI/CD | Manual |
| code-reviewer | Review PRs | On PR |
| tech-debt-tracker | Track debt | Weekly |
```

### Agent Definition

```markdown
# CI Optimizer

## Purpose
Analyze and optimize build pipelines.

## Model
claude-sonnet-4

## Tools
- Bash(gh:*, git:*)
- Read
- Edit

## Instructions
1. Analyze .github/workflows/
2. Identify slow steps
3. Add caching where beneficial
4. Test changes locally
5. Open PR with improvements
```

## CLI Commands

```bash
# Status
squads status              # All squads
squads dash                # Full dashboard

# Execution
squads run engineering     # Run squad
squads run engineering/ci-optimizer  # Run agent

# Memory
squads memory query "auth" # Search
squads memory show eng     # View

# Goals
squads goal set eng "Ship v2"
squads goal progress eng 75
squads goal complete eng
```

See [squads-cli](https://github.com/agents-squads/squads-cli) for full documentation.

## Environment Setup

```bash
cp .env.example .env
```

Required variables:

```bash
# AI Provider
ANTHROPIC_API_KEY=sk-ant-...

# Database
DATABASE_URL=postgresql://squads:squads@localhost:5432/squads
REDIS_URL=redis://localhost:6379

# Observability (optional but recommended)
LANGFUSE_PUBLIC_KEY=pk-lf-...
LANGFUSE_SECRET_KEY=sk-lf-...

# Budget controls
SQUADS_DAILY_BUDGET=50.00
```

## MCP Servers

Extend agent capabilities:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_TOKEN": "..." }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": { "DATABASE_URL": "..." }
    },
    "engram": {
      "command": "npx",
      "args": ["-y", "@agents-squads/engram-mcp"]
    }
  }
}
```

## Philosophy

1. **Simple over complex** — Markdown files, not microservices
2. **Transparent over magic** — Readable prompts you can audit
3. **Ownable over dependent** — Your team learns and maintains it
4. **Execute over advise** — Systems that do work, not just chat

## Ecosystem

| Project | Description |
|---------|-------------|
| [squads-cli](https://github.com/agents-squads/squads-cli) | CLI for managing squads |
| [engram](https://github.com/agents-squads/engram) | Persistent memory system |
| [agents-squads-web](https://agents-squads.com) | Website & docs |

## License

[MIT](LICENSE)

---

Built by [Agents Squads](https://agents-squads.com) — AI systems you can learn, understand, and trust.
