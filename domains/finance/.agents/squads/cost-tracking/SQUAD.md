# Squad: Cost Tracking

---
schema: squad/v0.1
name: cost-tracking
mission: "Monitor and optimize AI/infrastructure spending."
repo: finance

context:
  mcp: []
  skills: []
  memory:
    load:
      - cost-tracking/budgets
  model:
    default: claude-sonnet-4
    cheap: claude-haiku-3.5

budget:
  daily: 5.00
  weekly: 25.00
  monthly: 75.00
---

## Mission

Track spending, alert on anomalies, and identify optimization opportunities. Keep AI costs sustainable while maximizing value.

## Slack Channel

`#finance` - Budget alerts, cost reports, and spending approvals

## Agents

| Agent | Role | Trigger | Output |
|-------|------|---------|--------|
| lead | Orchestrate cost analysis and reporting | manual | reports |
| cost-monitor | Track daily spend and alert on anomalies | scheduled | alerts |
| budget-analyzer | Compare budget vs actual spending | scheduled | weekly reports |

## Approvals

```yaml
approvals:
  channel: "#finance"
  notify: ["@finance-team"]

  policy:
    auto:
      - alert.cost
      - memory.update

    notify:
      - report.generate

    approve:
      - budget.change
      - spend.over_limit

    confirm:
      - budget.increase
```

## Triggers

```yaml
triggers:
  - name: daily-cost-check
    agent: cost-monitor
    condition: "cron: 0 8 * * *"  # Daily 8am
    cooldown: 20 hours
    priority: 2

  - name: weekly-budget-review
    agent: budget-analyzer
    condition: "cron: 0 9 * * 1"  # Monday 9am
    cooldown: 6 days
    priority: 3

  - name: cost-spike-alert
    agent: cost-monitor
    condition: |
      SELECT daily_cost > daily_budget * 1.5
      FROM cost_metrics
      WHERE date = CURRENT_DATE
    cooldown: 4 hours
    priority: 1
```

## Workflow

1. Monitor → cost-monitor checks daily spend
2. Alert → Notify if over budget or anomaly detected
3. Analyze → Weekly budget vs actual review
4. Optimize → Identify cost reduction opportunities

## Goals

### Active

| Priority | Goal | Progress |
|----------|------|----------|
| P1 | Establish daily cost monitoring | 0% |
| P2 | Set up budget alerts | 0% |

## Success Metrics

- Budget adherence > 90%
- Cost per execution trending down
- No surprise overages

## Dependencies

- **Repos**: finance (write)
- **Secrets**: LANGFUSE_API_KEY (optional)
- **External**: Langfuse, cloud billing APIs
