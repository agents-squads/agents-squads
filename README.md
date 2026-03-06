<div align="center">

# Agents Squads

### Your AI workforce.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![CLI](https://img.shields.io/npm/v/squads-cli?label=squads-cli&color=purple)](https://www.npmjs.com/package/squads-cli)
[![SQUAD.md](https://img.shields.io/badge/SQUAD.md-v0.1-purple)](SQUAD.md)
[![Website](https://img.shields.io/badge/web-agents--squads.com-black)](https://agents-squads.com)

[Website](https://agents-squads.com) · [SQUAD.md Spec](SQUAD.md) · [CLI](https://github.com/agents-squads/squads-cli)

</div>

---

One person + AI teammates = a real business. Finance, marketing, engineering, operations — for the cost of API calls, not salaries. Our company is the proof.

## Quick Start

```bash
npm install -g squads-cli
squads init
squads dash
```

Agents are markdown files. Memory is markdown files. Runs locally.

## What Makes Squads Different

| Feature | Agents Squads | CrewAI | AutoGen | LangGraph |
|---------|:---:|:---:|:---:|:---:|
| **No code required** | ✅ Markdown only | ❌ Python classes | ❌ Python classes | ❌ Python graphs |
| **Persistent memory** | ✅ File-based, git-tracked | ⚠️ Optional | ⚠️ Optional | ❌ |
| **Multi-tool support** | ✅ Claude Code + Gemini CLI | ❌ | ❌ | ❌ |
| **Domain-aligned teams** | ✅ Squad architecture | ⚠️ Flat agents | ⚠️ Flat agents | ⚠️ Nodes |
| **Goal + memory tracking** | ✅ Built-in CLI | ❌ | ❌ | ❌ |
| **Self-hostable** | ✅ Docker, no SaaS required | ⚠️ Cloud-first | ❌ Azure-first | ❌ LangSmith |
| **Open standard** | ✅ SQUAD.md spec | ❌ | ❌ | ❌ |

**Key difference**: CrewAI, AutoGen, and LangGraph are orchestration libraries — you write code to wire agents together. Agents Squads is an operating system for AI workers — you write markdown to define teams, and the CLI handles orchestration.

## How It Works

### 1. Define your squad (markdown)

```markdown
# Engineering Squad

## Mission
Ship reliable software.

## Agents
- ci-optimizer: Optimize CI pipelines
- code-reviewer: Review PRs
- tech-debt-tracker: Track and report debt
```

### 2. Define your agents (markdown)

```markdown
# CI Optimizer

## Purpose
Analyze and optimize build pipelines.

## Model
claude-sonnet-4-5

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

## CLI Reference

```bash
squads init                    # Set up squads in your project
squads dash                    # Full dashboard with metrics
squads status <squad>          # Squad overview

squads run <squad>             # Execute a squad
squads run <squad>/<agent>     # Execute specific agent

squads memory query "auth"     # Search across memory
squads memory show <squad>     # View squad memory

squads goal set <squad> "Ship v2"
squads goal progress <squad> 75
```

Full docs: [squads-cli](https://github.com/agents-squads/squads-cli)

## Multi-Tool Support

Same agents, same memory, same CLI — works with Claude Code and Gemini CLI.

| Tool | Config | Instructions |
|------|--------|--------------|
| **Claude Code** | `.claude/settings.json` | `CLAUDE.md` |
| **Gemini CLI** | `.gemini/settings.json` | `CLAUDE.md` (configured) |

## Infrastructure (Optional)

```bash
git clone https://github.com/agents-squads/agents-squads
cd agents-squads
docker compose up -d     # Postgres, Redis, Langfuse
```

| Service | Port | Purpose |
|---------|------|---------|
| PostgreSQL | 5432 | Agent memory + state |
| Redis | 6379 | Rate limiting |
| Langfuse | 3000 | LLM cost + trace observability |

## SQUAD.md Standard

SQUAD.md is the open standard for multi-agent team orchestration. It complements [AGENTS.md](https://agents.md) and [MCP](https://modelcontextprotocol.io).

```
AGENTS.md  → How to work on THIS project
SQUAD.md   → How agents work TOGETHER as a team
```

See the full [SQUAD.md Specification](SQUAD.md).

## Philosophy

| Principle | Meaning |
|-----------|---------|
| **Simple over complex** | Markdown files, not microservices |
| **Transparent over magic** | Readable prompts you can audit and own |
| **Execute over advise** | Agents do work, they don't just chat |
| **Results over promises** | We run our own company on this — customer zero |

## Contributing

Contributions welcome. Open an issue or submit a PR.

## License

[MIT](LICENSE)

---

<div align="center">

**[agents-squads.com](https://agents-squads.com)**

Your AI workforce.

</div>
