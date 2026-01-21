# Squad: Intelligence

---
schema: squad/v0.1
name: intelligence
mission: "Monitor external signals and surface actionable insights."
repo: research

context:
  mcp: []
  skills:
    - web-research
  memory:
    load:
      - intelligence/findings
  model:
    default: claude-sonnet-4
    cheap: claude-haiku-3.5

budget:
  daily: 10.00
  weekly: 50.00
  monthly: 150.00
---

## Mission

Track market signals, competitor moves, and emerging trends. Transform noise into actionable intelligence that drives decisions.

## Slack Channel

`#intelligence` - Research briefs, competitor alerts, and trend reports

## Agents

| Agent | Role | Trigger | Output |
|-------|------|---------|--------|
| lead | Orchestrate research and synthesize findings | manual | briefs, reports |
| market-scanner | Monitor industry news daily | scheduled | daily briefs |
| competitor-tracker | Track competitor activity | scheduled | weekly reports |

## Approvals

```yaml
approvals:
  channel: "#intelligence"
  notify: ["@research-team"]

  policy:
    auto:
      - issue.create
      - memory.update
      - brief.draft

    notify:
      - brief.publish
      - report.generate

    approve:
      - outreach.competitor
      - spend.research_tool
```

## Triggers

```yaml
triggers:
  - name: daily-scan
    agent: market-scanner
    condition: "cron: 0 7 * * *"  # Daily 7am
    cooldown: 20 hours
    priority: 3

  - name: weekly-competitor
    agent: competitor-tracker
    condition: "cron: 0 9 * * 1"  # Monday 9am
    cooldown: 6 days
    priority: 4
```

## Workflow

1. Scan → market-scanner collects signals daily
2. Analyze → lead synthesizes patterns
3. Report → Weekly intelligence brief published
4. Act → Insights inform strategy decisions

## Goals

### Active

| Priority | Goal | Progress |
|----------|------|----------|
| P1 | Establish daily monitoring routine | 0% |
| P2 | Build competitor profiles | 0% |

## Success Metrics

- Signal-to-noise ratio > 80%
- Time to insight < 24 hours
- Actionability score > 7/10

## Dependencies

- **Repos**: research (write)
- **Secrets**: None required
- **External**: Web search, news APIs
