# Agents Squads

**AI systems you can learn, understand & trust.**

> Trust requires understanding. Understanding requires learning.
>
> We build AI systems designed to be learned — not black boxes, but transparent systems your team can study, modify, and own.

## Quick Start

```bash
# Install the CLI
npm install -g squads-cli

# Start infrastructure
docker compose up -d

# Initialize a project
squads init

# Check status
squads status

# View dashboard
squads dash
```

## Structure

```
agents-squads/
├── hq/                      # Headquarters (coordination)
│   ├── .agents/
│   │   ├── squads/          # HQ-level squads
│   │   └── memory/          # Cross-domain memory
│   └── CLAUDE.md
│
├── domains/                 # Domain-specific squads
│   ├── engineering/
│   ├── research/
│   ├── marketing/
│   ├── operations/
│   └── finance/
│
├── mcp/                     # MCP server configs
├── docker/                  # Infrastructure configs
├── docker-compose.yml       # Local services
└── .env.example             # Environment template
```

## Infrastructure

Local development stack:

| Service | Port | Purpose |
|---------|------|---------|
| PostgreSQL | 5432 | Primary data store |
| Redis | 6379 | Cache, queues |
| Neo4j | 7474/7687 | Knowledge graph |
| Langfuse | 3000 | LLM observability |
| Jaeger | 16686 | Distributed tracing |
| OTEL Collector | 4317 | Telemetry |

```bash
# Start all services
docker compose up -d

# View Langfuse (LLM costs/traces)
open http://localhost:3000

# View Jaeger (distributed traces)
open http://localhost:16686
```

## Squads & Agents

### Squad Definition (SQUAD.md)

```markdown
# Squad: Platform

## Mission
Maintain infrastructure and developer experience.

## Goals

### Active
| Priority | Goal | Progress |
|----------|------|----------|
| P1 | Reduce build time to <3min | 60% |

## Agents

| Agent | Role | Trigger |
|-------|------|---------|
| infra-monitor | Monitor health | Scheduled |
| ci-optimizer | Optimize builds | Manual |
```

### Agent Definition ({agent}.md)

```markdown
# CI Optimizer

## Purpose
Analyze and optimize CI/CD pipeline performance.

## Model
claude-sonnet-4

## Tools
- Read
- Bash
- mcp__github__*

## Instructions
1. Analyze current build times
2. Identify bottlenecks
3. Implement optimizations
4. Verify improvements
```

## CLI Commands

```bash
# Status & Dashboard
squads status              # All squads overview
squads status engineering  # Single squad
squads dash                # Full dashboard

# Running
squads run engineering     # Run a squad
squads run engineering/ci-optimizer  # Run specific agent

# Memory
squads memory query "deployment"  # Search memory
squads memory show engineering    # Squad memory

# Goals
squads goal list                          # All goals
squads goal set engineering "Ship v2.0"   # Set goal
squads goal progress engineering 75       # Update progress
squads goal complete engineering          # Mark done
```

## MCP Servers

Extend agent capabilities with MCP:

```json
{
  "mcpServers": {
    "firecrawl": {
      "command": "npx",
      "args": ["-y", "firecrawl-mcp"]
    },
    "supabase": {
      "command": "npx",
      "args": ["-y", "@supabase/mcp-server-supabase"]
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"]
    }
  }
}
```

See [mcp/README.md](mcp/README.md) for full configuration.

## Environment

Copy `.env.example` to `.env` and configure:

```bash
# AI Providers
ANTHROPIC_API_KEY=sk-ant-...

# Infrastructure
DATABASE_URL=postgresql://squads:squads@localhost:5432/squads
REDIS_URL=redis://localhost:6379

# Observability
LANGFUSE_PUBLIC_KEY=pk-lf-...
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317

# Squads
SQUADS_DAILY_BUDGET=50.00
```

## Philosophy

1. **Simple over complex** — Markdown files, not microservices
2. **Transparent over magic** — Readable prompts, not black boxes
3. **Ownable over dependent** — Your team learns and maintains it
4. **Execute over advise** — Systems that do work, not just chat

## Links

- [Website](https://agents-squads.com)
- [CLI](https://github.com/agents-squads/squads-cli)
- [Documentation](https://agents-squads.com/docs)

## License

MIT
