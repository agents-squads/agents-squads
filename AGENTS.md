---
kind: product
lifecycle: active
owner: maintainers
---

# agents-squads

Open-source framework for autonomous AI agent squads. Build systems that execute, not just inform.

# Agents Squads

> This file is read by both **Claude Code** and **Gemini CLI** (via `context.fileName` config).

## Overview

Open-source framework for building AI agent teams.

**Mantra**: "AI systems you can learn, understand & trust."

## Structure

```
agents-squads/
├── hq/                  # Headquarters (coordination)
├── domains/             # Domain squads
│   ├── engineering/
│   ├── research/
│   ├── marketing/
│   ├── operations/
│   └── finance/
├── mcp/                 # MCP server configs
├── docker/              # Infrastructure configs
└── docker-compose.yml   # Local services
```

## Getting Started

```bash
# Start infrastructure
docker compose up -d

# Install CLI
npm install -g squads-cli

# Initialize
squads init

# Check status
squads status
```

## Infrastructure

| Service | URL |
|---------|-----|
| PostgreSQL | localhost:5432 |
| Redis | localhost:6379 |
| Neo4j | localhost:7474 |
| Langfuse | localhost:3000 |

## CLI Commands

```bash
squads status           # Overview
squads dash             # Dashboard
squads run <squad>      # Execute
squads memory query "x" # Search
squads goal list        # Goals
```

## Git Commit Format

```
<type>(<scope>): <subject>

<body>

🤖 Generated with [Agents Squads](https://agents-squads.com)

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
```
