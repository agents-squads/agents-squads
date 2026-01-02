# Agents Squads

## Overview

This is the public showcase repository for the Agents Squads framework.

**Mantra**: "AI systems you can learn, understand & trust."

## Structure

```
.agents/
├── squads/              # Squad definitions
│   └── example/         # Example squad
│       ├── SQUAD.md     # Squad mission
│       ├── researcher.md
│       └── writer.md
├── memory/              # Persistent memory
├── outputs/             # Squad outputs
└── commit-template.txt  # Git commit format
```

## Squads CLI

```bash
# Install
npm install -g squads-cli

# Commands
squads status            # Overview
squads dash              # Dashboard
squads run <squad>       # Execute
squads memory query "x"  # Search memory
```

## Git Commit Format

All commits should use:

```
<type>(<scope>): <subject>

<body>

🤖 Generated with [Agents Squads](https://agents-squads.com)

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
```

## Links

- Website: https://agents-squads.com
- CLI: https://github.com/agents-squads/squads-cli
- HQ: https://github.com/agents-squads/hq (private)
