# Squad: Strategy

## Mission
Define and coordinate organizational priorities across all domains.

## Problem Domain
Cross-domain alignment, resource allocation, goal setting.

## Agents

| Agent | Role | Trigger | Output |
|-------|------|---------|--------|
| planner | Quarterly/monthly planning | Manual | goals/, roadmap |
| coordinator | Cross-domain sync | Weekly | status reports |
| reviewer | Progress review | Manual | insights |

## Execution

### Triggers
- **Manual**: `squads run hq/strategy`
- **Scheduled**: Weekly sync (Mondays)

### Workflow
1. Gather status from all domains
2. Identify blockers and dependencies
3. Update priorities and goals
4. Communicate decisions

## Success Metrics
- Goal completion rate
- Cross-domain blockers resolved
- Time to decision
