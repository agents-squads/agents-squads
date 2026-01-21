# Squad: Platform

---
schema: squad/v0.1
name: platform
mission: "Maintain infrastructure, CI/CD, and developer experience."
repo: engineering

context:
  mcp: []
  skills: []
  memory:
    load:
      - platform/shared
  model:
    default: claude-sonnet-4
    expensive: claude-opus-4
    cheap: claude-haiku-3.5

budget:
  daily: 15.00
  weekly: 75.00
  monthly: 250.00
---

## Mission

Keep systems running, builds fast, and developers productive. Automate infrastructure management so humans focus on architecture decisions.

## Slack Channel

`#platform` - Infrastructure alerts, deployment notifications, and approvals

## Agents

| Agent | Role | Trigger | Output |
|-------|------|---------|--------|
| lead | Orchestrate platform work and technical decisions | manual | PRs, decisions |
| infra-monitor | Monitor service health and alert on issues | scheduled | alerts, reports |
| ci-optimizer | Analyze and improve build pipelines | event | improvements |

## Approvals

```yaml
approvals:
  channel: "#platform"
  notify: ["@platform-team"]

  policy:
    auto:
      - issue.create
      - memory.update

    notify:
      - pr.create
      - alert.send

    approve:
      - pr.merge
      - infra.change
      - deploy.production

    confirm:
      - secret.rotate
      - data.migration

  thresholds:
    spend_approval: 15.00
    bulk_actions: 5
```

## Triggers

```yaml
triggers:
  - name: health-check
    agent: infra-monitor
    condition: "cron: */30 * * * *"  # Every 30 minutes
    cooldown: 25 minutes
    priority: 1

  - name: ci-failure-analysis
    agent: ci-optimizer
    condition: "event: ci.failed"
    cooldown: 1 hour
    priority: 2
```

## Workflow

1. Monitor → infra-monitor checks health every 30 min
2. Alert → Issues created for degraded services
3. Fix → lead or ci-optimizer addresses issues
4. Verify → Health check confirms resolution

## Goals

### Active

| Priority | Goal | Progress |
|----------|------|----------|
| P1 | Reduce build time to <3 minutes | 0% |
| P1 | Achieve 99.9% uptime | 0% |
| P2 | Document all runbooks | 0% |

## Success Metrics

- Uptime > 99.9%
- Build time < 3 min
- MTTR < 30 min
- Zero critical vulnerabilities

## Dependencies

- **Repos**: engineering (write)
- **Secrets**: DOCKER_TOKEN, AWS_CREDENTIALS
- **External**: GitHub Actions, Docker Hub
