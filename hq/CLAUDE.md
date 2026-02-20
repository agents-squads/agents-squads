# Headquarters (HQ)

## Overview

HQ is the central coordination point for all domain squads. It manages:
- Cross-domain goals and priorities
- Resource allocation and budgets
- Squad orchestration
- Memory and knowledge base

## Structure

```
hq/
├── .agents/
│   ├── squads/          # HQ-level squads (strategy, coordination)
│   ├── memory/          # Cross-domain memory
│   └── goals/           # Organization-wide goals
└── CLAUDE.md
```

## Domains

| Domain | Purpose | Repo |
|--------|---------|------|
| engineering | Systems, infrastructure, code | `domains/engineering/` |
| research | Analysis, insights, intelligence | `domains/research/` |
| marketing | Content, brand, growth | `domains/marketing/` |
| operations | Processes, efficiency | `domains/operations/` |
| finance | Budgets, costs, reporting | `domains/finance/` |

## Cross-Domain Coordination

HQ squads coordinate work across domains:

```bash
# Check all domain status
squads status

# Set organization-wide goal
squads goal set hq "Launch v1.0 by Q1"

# Query memory across all domains
squads memory query "customer feedback"
```

## Infrastructure

All domains share infrastructure via docker-compose:
- PostgreSQL (data)
- Redis (cache/queues)
- Langfuse (LLM observability)

```bash
# Start infrastructure
docker compose up -d

# View Langfuse
open http://localhost:3000
```
