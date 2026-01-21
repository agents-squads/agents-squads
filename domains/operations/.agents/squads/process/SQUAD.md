# Squad: Process

---
schema: squad/v0.1
name: process
mission: "Design and improve operational workflows."
repo: operations

context:
  mcp: []
  skills: []
  memory:
    load:
      - process/workflows
  model:
    default: claude-sonnet-4

budget:
  daily: 8.00
  weekly: 40.00
  monthly: 120.00
---

## Mission

Analyze, design, and automate operational workflows. Reduce manual work and improve consistency across teams.

## Slack Channel

`#operations` - Process changes, automation updates, and workflow approvals

## Agents

| Agent | Role | Trigger | Output |
|-------|------|---------|--------|
| lead | Orchestrate process improvements | manual | plans, docs |
| workflow-analyst | Analyze and document current processes | manual | analysis |
| automation-builder | Build automation for repetitive tasks | manual | scripts |

## Approvals

```yaml
approvals:
  channel: "#operations"
  notify: ["@ops-team"]

  policy:
    auto:
      - analysis.create
      - memory.update

    notify:
      - automation.draft
      - process.document

    approve:
      - automation.deploy
      - process.change
```

## Triggers

```yaml
triggers:
  - name: weekly-metrics
    agent: lead
    condition: "cron: 0 9 * * 1"  # Monday 9am
    cooldown: 6 days
    priority: 4
```

## Workflow

1. Analyze → Identify bottlenecks and manual work
2. Design → Propose process improvements
3. Automate → Build scripts/workflows
4. Deploy → Roll out with approval
5. Measure → Track improvement metrics

## Goals

### Active

| Priority | Goal | Progress |
|----------|------|----------|
| P1 | Document core workflows | 0% |
| P2 | Automate top 3 manual tasks | 0% |

## Success Metrics

- Process cycle time reduction
- Automation coverage %
- Error rate decrease

## Dependencies

- **Repos**: operations (write)
- **Secrets**: None required
- **External**: None
