# Squad: {SQUAD_NAME}

---
schema: squad/v0.1
name: {squad-name}
mission: "{One sentence describing what this squad accomplishes}"
repo: {domain-repo}

context:
  mcp: []
  skills: []
  memory:
    load:
      - {squad-name}/shared
  model:
    default: claude-sonnet-4
    expensive: claude-opus-4
    cheap: claude-haiku-3.5

budget:
  daily: 10.00
  weekly: 50.00
  monthly: 150.00
---

## Mission

{What problem space does this squad address? 2-3 sentences.}

## Slack Channel

`#{squad-name}` - All squad activity, briefs, approvals, and coordination

## Agents

| Agent | Role | Trigger | Output |
|-------|------|---------|--------|
| {agent-name} | {what it does} | manual/scheduled/event | {where output goes} |

## Approvals

```yaml
approvals:
  channel: "#{squad-name}"
  notify: ["@team"]

  policy:
    # Auto: No approval needed, just notify
    auto:
      - issue.create
      - memory.update
      - goal.set

    # Notify: Auto-approve but post to channel
    notify:
      - pr.create
      - brief.publish
      - agent.run.readonly

    # Approve: Require human approval before execution
    approve:
      - pr.merge
      - trigger.fire
      - agent.run.write

    # Confirm: Require approval + "are you sure" confirmation
    confirm:
      - content.publish.external
      - outreach.send
      - spend.over_budget

  thresholds:
    spend_approval: 10.00
    bulk_actions: 3
    external_api_calls: true
```

## Triggers

```yaml
triggers:
  - name: {trigger-name}
    agent: {agent-name}
    condition: "cron: 0 9 * * 1"  # Weekly Monday 9am
    cooldown: 6 days
    priority: 5
    context:
      key: value
```

## Workflow

1. {Step 1}
2. {Step 2}
3. {Step 3}

## Goals

### Active

| Priority | Goal | Progress |
|----------|------|----------|
| P1 | {Primary goal} | 0% |
| P2 | {Secondary goal} | 0% |

### Completed

- [ ] {First milestone}

## Success Metrics

- {Metric 1}
- {Metric 2}

## Dependencies

- **Repos**: {which repos does this squad write to?}
- **Secrets**: {which .env secrets are needed?}
- **External**: {any external APIs or services?}
