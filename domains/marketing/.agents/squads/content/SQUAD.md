# Squad: Content

---
schema: squad/v0.1
name: content
mission: "Create and optimize content that attracts and converts."
repo: marketing

context:
  mcp: []
  skills:
    - content-writing
  memory:
    load:
      - content/brand-voice
  model:
    default: claude-sonnet-4

budget:
  daily: 10.00
  weekly: 50.00
  monthly: 150.00
---

## Mission

Produce high-quality content that builds authority, attracts leads, and supports the sales process. Maintain consistent brand voice across all channels.

## Slack Channel

`#content` - Content drafts, reviews, and publishing approvals

## Agents

| Agent | Role | Trigger | Output |
|-------|------|---------|--------|
| lead | Orchestrate content strategy and production | manual | content plans |
| writer | Draft blog posts and documentation | manual | drafts |
| seo-optimizer | Optimize content for search | event | improvements |

## Approvals

```yaml
approvals:
  channel: "#content"
  notify: ["@marketing-team"]

  policy:
    auto:
      - draft.create
      - memory.update

    notify:
      - draft.review

    approve:
      - content.publish
      - social.post

    confirm:
      - content.publish.external
      - paid.promotion
```

## Triggers

```yaml
triggers:
  - name: seo-check
    agent: seo-optimizer
    condition: "event: content.published"
    cooldown: 1 hour
    priority: 3
```

## Workflow

1. Plan → lead creates content calendar
2. Draft → writer produces content
3. Optimize → seo-optimizer improves for search
4. Review → Human approval required
5. Publish → Content goes live

## Goals

### Active

| Priority | Goal | Progress |
|----------|------|----------|
| P1 | Establish content calendar | 0% |
| P2 | Document brand voice guidelines | 0% |

## Success Metrics

- Content published per week
- Organic traffic growth
- Conversion rate from content

## Dependencies

- **Repos**: marketing (write), website (read)
- **Secrets**: None required
- **External**: CMS, analytics
