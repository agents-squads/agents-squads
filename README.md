<div align="center">

# Agents Squads

### AI systems you can learn, understand, and trust.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![CLI](https://img.shields.io/npm/v/squads-cli?label=squads-cli&color=purple)](https://www.npmjs.com/package/squads-cli)
[![Docs](https://img.shields.io/badge/docs-mintlify-green)](https://docs.agents-squads.com)
[![Website](https://img.shields.io/badge/web-agents--squads.com-black)](https://agents-squads.com)

[Website](https://agents-squads.com) · [Documentation](https://docs.agents-squads.com) · [CLI](https://github.com/agents-squads/squads-cli)

</div>

---

> Trust requires understanding. Understanding requires learning.
>
> We build AI systems designed to be learned — not black boxes, but transparent systems your team can study, modify, and own.

## What is this?

A framework for organizing autonomous AI agents into domain-aligned teams (squads) with persistent memory, goal tracking, and observability. Built for Claude Code.

**No complex infrastructure.** Agents are markdown files. Memory is markdown files. Run locally with Docker.

```
┌─────────────────────────────────────────────────────────────┐
│                      AGENTS SQUADS                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │ Engineering │  │  Research   │  │  Marketing  │  ...    │
│  │    Squad    │  │    Squad    │  │    Squad    │         │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘         │
│         │                │                │                 │
│         ▼                ▼                ▼                 │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                 Shared Memory (Engram)               │   │
│  └─────────────────────────────────────────────────────┘   │
│                           │                                 │
│                           ▼                                 │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Observability (Langfuse)                │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Quick Start

```bash
# Install the CLI
npm install -g squads-cli

# Initialize in your project
squads init

# Check status
squads dash
```

<details>
<summary><strong>Full setup with infrastructure</strong></summary>

```bash
# Clone for local infrastructure (Postgres, Redis, Langfuse)
git clone https://github.com/agents-squads/agents-squads
cd agents-squads

# Start services
docker compose up -d

# View dashboards
open http://localhost:3000  # Langfuse (costs, traces)
```

</details>

## How It Works

### 1. Define Squads (Markdown)

```markdown
# Engineering Squad

## Mission
Ship reliable software. Reduce technical debt.

## Agents
- ci-optimizer: Optimize build pipelines
- code-reviewer: Review PRs automatically
- tech-debt-tracker: Track and report debt
```

### 2. Define Agents (Markdown)

```markdown
# CI Optimizer

## Purpose
Analyze and optimize build pipelines.

## Model
claude-sonnet-4

## Instructions
1. Analyze .github/workflows/
2. Identify slow steps
3. Add caching where beneficial
4. Open PR with improvements
```

### 3. Run

```bash
squads run engineering           # Run full squad
squads run engineering/ci-optimizer  # Run single agent
```

## CLI

```bash
squads status              # All squads overview
squads dash                # Full dashboard with metrics

squads run <squad>         # Execute a squad
squads run <squad>/<agent> # Execute specific agent

squads memory query "auth" # Search across memory
squads memory show <squad> # View squad memory

squads goal set <squad> "Ship v2"
squads goal progress <squad> 75
```

See [squads-cli](https://github.com/agents-squads/squads-cli) for full docs.

## Infrastructure (Optional)

Run locally with Docker for full observability:

| Service | Port | Purpose |
|---------|------|---------|
| PostgreSQL | 5432 | Primary data store |
| Redis | 6379 | Cache & rate limiting |
| Langfuse | 3000 | LLM observability |

```bash
docker compose up -d
```

## Philosophy

| Principle | Meaning |
|-----------|---------|
| **Simple over complex** | Markdown files, not microservices |
| **Transparent over magic** | Readable prompts you can audit |
| **Ownable over dependent** | Your team learns and maintains it |
| **Execute over advise** | Systems that do work, not just chat |

## Ecosystem

| Project | Description |
|---------|-------------|
| [squads-cli](https://github.com/agents-squads/squads-cli) | CLI for managing squads |
| [engram](https://github.com/agents-squads/engram) | Persistent memory for agents |
| [docs](https://docs.agents-squads.com) | Full documentation |

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

[MIT](LICENSE)

---

<div align="center">

**[agents-squads.com](https://agents-squads.com)**

AI systems you can learn, understand, and trust.

</div>
