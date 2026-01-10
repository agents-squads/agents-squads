# SQUAD.md Specification

**Version**: 0.1.0 (Draft)
**Status**: Proposed for AAIF consideration
**Maintainer**: [Agents Squads](https://agents-squads.com)

---

## Overview

SQUAD.md is a declarative format for defining multi-agent teams. It answers the question: **How do AI agents work together?**

While [AGENTS.md](https://agents.md) tells agents how to work on your project, and MCP provides tool integrations, SQUAD.md defines team structure, coordination patterns, and execution constraints.

---

## Quick Start

Create a `SQUAD.md` file to define an agent team:

```yaml
---
schema: squad/v0.1
name: engineering
mission: Ship reliable software. Reduce technical debt.
---

# Engineering Squad

## Agents

| Agent | Role | Trigger |
|-------|------|---------|
| code-reviewer | Review PRs automatically | event |
| ci-optimizer | Optimize build pipelines | manual |
| tech-debt-tracker | Track and report debt | scheduled |

## Workflow

1. Issues labeled `agent` trigger code-reviewer
2. CI failures trigger ci-optimizer analysis
3. Weekly tech-debt report generated Monday 9am
```

---

## Specification

### File Location

```
your-project/
├── AGENTS.md           # How agents work on this project
├── CLAUDE.md           # Claude-specific optimizations (optional)
└── .agents/
    └── squads/
        └── <squad-name>/
            └── SQUAD.md    # Team definition
```

### Format

SQUAD.md uses YAML frontmatter followed by a Markdown body.

#### Frontmatter (Required Fields)

```yaml
---
schema: squad/v0.1     # Specification version
name: string           # Team identifier (lowercase, hyphenated)
mission: string        # One-sentence purpose
---
```

#### Frontmatter (Optional Fields)

```yaml
---
# Output configuration
repo: string               # Primary output repository

# Context injection
context:
  mcp: string[]            # MCP servers to connect
  skills: string[]         # Agent Skills to load
  memory:
    load: string[]         # Memory paths to inject
  model:
    default: string        # Default model (e.g., "claude-sonnet-4")
    expensive: string      # For complex reasoning
    cheap: string          # For simple tasks

# Execution constraints
budget:
  daily: number            # Daily spend limit (USD)
  weekly: number           # Weekly spend limit (USD)
  monthly: number          # Monthly spend limit (USD)

# Event-driven execution
triggers:
  - name: string           # Trigger identifier
    agent: string          # Agent to execute (optional, runs squad if omitted)
    condition: string      # SQL or boolean expression
    cooldown: string       # Minimum time between triggers (e.g., "1 hour")
    priority: number       # 1-10 (1 = critical)
    context:               # Additional context passed to agent
      key: value
---
```

### Body (Markdown)

The body contains human-readable documentation:

- **Mission details** - Extended description of team purpose
- **Agent roster** - Table of agents with roles and triggers
- **Workflow** - How agents coordinate
- **Goals** - Current objectives with checkbox status
- **Dependencies** - Required repos, secrets, external services

---

## Agent Definition

Agents referenced in SQUAD.md are defined as separate markdown files:

```
.agents/
└── squads/
    └── engineering/
        ├── SQUAD.md              # Team definition
        └── agents/
            ├── code-reviewer.md  # Agent definition
            ├── ci-optimizer.md
            └── tech-debt-tracker.md
```

### Agent File Format

```markdown
# Code Reviewer

## Purpose
Automatically review pull requests for code quality, security, and style.

## Model
claude-sonnet-4

## Trigger
event: pull_request.opened, pull_request.synchronize

## Instructions
1. Fetch PR diff using GitHub API
2. Analyze for:
   - Security vulnerabilities
   - Performance issues
   - Style violations
3. Post review comments
4. Approve if no issues, request changes otherwise

## Output
PR review comments and approval/rejection
```

---

## Trigger Conditions

Triggers enable autonomous execution based on conditions:

### SQL-Based Triggers

For complex conditions evaluated against a database:

```yaml
triggers:
  - name: high-cost-alert
    agent: cost-monitor
    condition: |
      SELECT value > 100
      FROM metrics
      WHERE name = 'daily_cost_usd'
    cooldown: 6 hours
    priority: 1
```

### Simple Triggers

For boolean expressions:

```yaml
triggers:
  - name: weekly-report
    condition: "cron: 0 9 * * 1"  # Every Monday 9am
    cooldown: 6 days
    priority: 5
```

### GitHub Event Triggers

```yaml
triggers:
  - name: pr-review
    agent: code-reviewer
    condition: "event: pull_request.opened"
    priority: 2
```

---

## Relationship to Other Standards

| Standard | Scope | SQUAD.md Relationship |
|----------|-------|----------------------|
| [MCP](https://modelcontextprotocol.io) | Tool integration | Referenced via `context.mcp` |
| [AGENTS.md](https://agents.md) | Project guidance | Squads operate within AGENTS.md constraints |
| [Agent Skills](https://agentskills.io) | Agent capabilities | Referenced via `context.skills` |
| **SQUAD.md** | Team orchestration | Defines how agents collaborate |

SQUAD.md **complements** existing standards. Use them together:

```
AGENTS.md  → How to work on THIS project
SQUAD.md   → How agents work TOGETHER
MCP        → Tools agents can USE
Skills     → Capabilities agents HAVE
```

---

## Examples

### Minimal Squad

```yaml
---
schema: squad/v0.1
name: docs
mission: Keep documentation accurate and up-to-date.
---

# Documentation Squad

## Agents

| Agent | Role |
|-------|------|
| doc-updater | Update docs when code changes |

## Workflow

1. Monitor PRs for code changes
2. Update relevant documentation
3. Create PR with doc updates
```

### Full Squad

```yaml
---
schema: squad/v0.1
name: engineering
mission: Ship reliable software. Reduce technical debt.
repo: engineering

context:
  mcp:
    - github
    - linear
  skills:
    - code-review
    - testing
  memory:
    load:
      - engineering/decisions
      - engineering/patterns
  model:
    default: claude-sonnet-4
    expensive: claude-opus-4
    cheap: claude-haiku-3.5

budget:
  daily: 50
  weekly: 250
  monthly: 800

triggers:
  - name: pr-review
    agent: code-reviewer
    condition: "event: pull_request.opened"
    priority: 2

  - name: ci-failure
    agent: ci-optimizer
    condition: |
      SELECT COUNT(*) > 3
      FROM ci_runs
      WHERE status = 'failed'
      AND created_at > NOW() - INTERVAL '1 hour'
    cooldown: 2 hours
    priority: 1

  - name: weekly-debt-report
    agent: tech-debt-tracker
    condition: "cron: 0 9 * * 1"
    cooldown: 6 days
    priority: 5
---

# Engineering Squad

## Mission

Ship reliable software while maintaining code quality and reducing technical debt. We automate the boring parts so humans can focus on architecture and design.

## Agents

| Agent | Role | Trigger | Status |
|-------|------|---------|--------|
| code-reviewer | Review PRs for quality and security | event | Active |
| ci-optimizer | Analyze and improve build pipelines | event | Active |
| tech-debt-tracker | Track, report, and prioritize debt | scheduled | Active |
| eng-lead | Technical decisions and architecture | manual | Active |

## Workflow

```
PR Opened
    ↓
code-reviewer analyzes
    ↓
[Issues found?] → Request changes
    ↓
Approved → Merge
    ↓
CI runs
    ↓
[Failed 3x?] → ci-optimizer investigates
```

## Goals

- [x] Reduce PR review time to < 5 minutes
- [ ] Achieve 90% CI pass rate
- [ ] Document all technical decisions

## Dependencies

- **Repos**: engineering (write), all others (read)
- **Secrets**: GITHUB_TOKEN, LINEAR_API_KEY
- **External**: GitHub API, Linear API
```

---

## Implementation

### CLI Commands

```bash
squads status                    # List all squads
squads status <squad>            # Squad details
squads run <squad>               # Execute squad
squads run <squad>/<agent>       # Execute specific agent
```

### Validation

SQUAD.md files should be validated for:

1. **Schema version** - Must be supported version
2. **Required fields** - name, mission present
3. **Agent references** - Referenced agents exist
4. **Budget limits** - Non-negative values
5. **Trigger syntax** - Valid conditions

---

## Governance

SQUAD.md is proposed as an open standard for the [Agentic AI Foundation (AAIF)](https://agenticaifoundation.org).

**Goals**:
- Vendor-neutral team orchestration
- Interoperable with existing standards
- Simple enough for manual editing
- Expressive enough for complex workflows

**Contributing**:
- Open issues at [github.com/agents-squads/agents-squads](https://github.com/agents-squads/agents-squads)
- Join discussions in AAIF working groups

---

## License

[MIT](LICENSE) - Use freely in any project.

---

<div align="center">

**SQUAD.md** - The open standard for multi-agent team orchestration.

[GitHub](https://github.com/agents-squads/agents-squads) · [Website](https://agents-squads.com) · [CLI](https://github.com/agents-squads/squads-cli)

</div>
