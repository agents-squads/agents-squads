# Agents Squads

**AI systems you can learn, understand & trust.**

> Trust requires understanding. Understanding requires learning.
>
> We build AI systems designed to be learned — not black boxes, but transparent systems your team can study, modify, and own.

## What is Agents Squads?

Agents Squads is a framework for building and running AI agent teams using simple markdown files. No complex infrastructure, no microservices — just prompts that execute.

```
.agents/
├── squads/              # Squad definitions
│   └── research/
│       ├── SQUAD.md     # Squad mission & config
│       ├── analyst.md   # Agent definition
│       └── scout.md     # Agent definition
├── memory/              # Persistent cross-session memory
└── outputs/             # Squad outputs
```

## Quick Start

```bash
# Install the CLI
npm install -g squads-cli

# Initialize a project
squads init

# Check status
squads status

# Run a squad
squads run research
```

## Example Output

```
  squads status

  10/10 squads  │  memory: enabled

  ┌────────────────────────────────────────────────────────┐
  │ SQUAD           AGENTS  MEMORY        ACTIVITY         │
  ├────────────────────────────────────────────────────────┤
  │ engineering     5       1 entries     today            │
  │ research        6       1 entries     yesterday        │
  │ product         2       1 entries     2d ago           │
  └────────────────────────────────────────────────────────┘
```

## Core Concepts

### Squads = Domain-Aligned Teams

Each squad owns a domain and contains specialized agents:

| Squad | Purpose |
|-------|---------|
| engineering | Systems, infrastructure, code |
| research | Analysis, insights, intelligence |
| product | Features, roadmap, specifications |
| customer | Leads, outreach, relationships |

### Agents = Markdown Prompts

An agent is just a markdown file with a prompt:

```markdown
# Research Analyst

## Purpose
Analyze market data and produce actionable insights.

## Model
claude-sonnet-4

## Tools
- WebSearch
- Read
- Write

## Instructions
1. Search for recent developments in the target market
2. Analyze trends and patterns
3. Write findings to outputs/
```

### Memory = Persistent Context

Squads remember across sessions. No more starting from scratch:

```bash
# Query existing knowledge before researching
squads memory query "competitor analysis"

# Memory syncs automatically from git commits
```

## CLI Commands

| Command | Purpose |
|---------|---------|
| `squads init` | Initialize a squad project |
| `squads status` | Overview of all squads |
| `squads dash` | Full operational dashboard |
| `squads run <squad>` | Execute a squad |
| `squads memory query "<topic>"` | Search squad memory |
| `squads goal set <squad> "<goal>"` | Set a goal |

## Philosophy

1. **Simple over complex** — Markdown files, not microservices
2. **Transparent over magic** — Readable prompts, not black boxes
3. **Ownable over dependent** — Your team learns and maintains it
4. **Execute over advise** — Systems that do work, not just chat

## Installation

```bash
npm install -g squads-cli
```

Requires:
- Node.js 18+
- Claude Code CLI (for agent execution)

## Links

- [Website](https://agents-squads.com)
- [Documentation](https://agents-squads.com/docs)
- [squads-cli](https://github.com/agents-squads/squads-cli)

## License

MIT
