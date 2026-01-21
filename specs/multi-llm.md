# Multi-LLM Support Specification

**Version**: 0.2.0 (Proposed)
**Status**: Draft
**Extends**: SQUAD.md v0.1

---

## Overview

Multi-LLM enables squads to use different LLM providers by delegating to their native CLIs. No SDK integrations needed - just shell out to `claude`, `gemini`, `codex`, `vibe`, etc.

**Philosophy**: Unix-style composition. Each provider maintains their own CLI. We orchestrate.

---

## Supported CLIs

| Provider | CLI | Install | Non-Interactive Flag |
|----------|-----|---------|---------------------|
| Anthropic | `claude` | `npm i -g @anthropic-ai/claude-code` | `--print` |
| Google | `gemini` | `npm i -g @google/gemini-cli` | `--prompt` |
| OpenAI | `codex` | `npm i -g @openai/codex` | `exec` subcommand |
| Mistral | `vibe` | `curl -LsSf https://mistral.ai/vibe/install.sh \| bash` | `--prompt --auto-approve` |
| xAI | `grok` | `bun add -g @vibe-kit/grok-cli` | `--prompt` |
| Multi | `aider` | `pip install aider-install && aider-install` | `--message --yes` |
| Local | `ollama` | `brew install ollama` | `run <model> "<prompt>"` |

---

## Schema

### Squad-Level

```yaml
---
schema: squad/v0.2
name: intelligence
mission: Market research and competitive analysis

providers:
  default: anthropic      # CLI: claude
  vision: openai          # CLI: codex (for image analysis)
  realtime: xai           # CLI: grok (for real-time data)
  cheap: google           # CLI: gemini (for high-volume)
---
```

### Agent-Level Override

```markdown
---
provider: xai
---

# Social Monitor

## Purpose
Real-time X/Twitter trend detection using Grok.
```

Or with header syntax:

```markdown
# Social Monitor

## Provider
xai

## Purpose
Real-time X/Twitter trend detection.
```

---

## CLI Mapping

```typescript
// src/lib/providers.ts

interface CLIConfig {
  command: string;
  buildArgs: (prompt: string, options: RunOptions) => string[];
  available: () => boolean;
}

const PROVIDERS: Record<string, CLIConfig> = {
  anthropic: {
    command: 'claude',
    buildArgs: (prompt) => ['--print', prompt],
    available: () => commandExists('claude'),
  },

  google: {
    command: 'gemini',
    buildArgs: (prompt) => ['--prompt', prompt],
    available: () => commandExists('gemini'),
  },

  openai: {
    command: 'codex',
    buildArgs: (prompt) => ['exec', prompt],
    available: () => commandExists('codex'),
  },

  mistral: {
    command: 'vibe',
    buildArgs: (prompt) => ['--prompt', prompt, '--auto-approve'],
    available: () => commandExists('vibe'),
  },

  xai: {
    command: 'grok',
    buildArgs: (prompt) => ['--prompt', prompt],
    available: () => commandExists('grok'),
  },

  aider: {
    command: 'aider',
    buildArgs: (prompt) => ['--message', prompt, '--yes'],
    available: () => commandExists('aider'),
  },

  ollama: {
    command: 'ollama',
    buildArgs: (prompt, opts) => ['run', opts.model || 'llama3.1', prompt],
    available: () => commandExists('ollama'),
  },
};
```

---

## Execution Flow

```
squads run intelligence/social-monitor
         │
         ▼
┌─────────────────────────────┐
│ 1. Parse agent config       │
│    - provider: xai          │
│    - prompt: <from file>    │
└─────────────────────────────┘
         │
         ▼
┌─────────────────────────────┐
│ 2. Resolve CLI              │
│    - xai → grok             │
│    - check: grok available? │
└─────────────────────────────┘
         │
         ▼
┌─────────────────────────────┐
│ 3. Build command            │
│    grok --prompt "<prompt>" │
└─────────────────────────────┘
         │
         ▼
┌─────────────────────────────┐
│ 4. Execute                  │
│    spawn(cmd, args, opts)   │
│    inherit stdio            │
└─────────────────────────────┘
```

---

## Implementation

### Provider Check

```bash
squads providers

# Output:
# Provider    CLI       Status
# ─────────────────────────────
# anthropic   claude    ✓ ready
# google      gemini    ✓ ready
# openai      codex     ✗ not installed
# mistral     vibe      ✗ not installed
# xai         grok      ✗ not installed
# aider       aider     ✓ ready
# ollama      ollama    ✓ ready
#
# Install missing:
#   npm i -g @openai/codex
#   curl -LsSf https://mistral.ai/vibe/install.sh | bash
#   bun add -g @vibe-kit/grok-cli
```

### Run with Provider

```bash
# Use agent's configured provider
squads run intelligence/social-monitor

# Override for this run
squads run intelligence/analyst --provider=google

# Dry run to see what command would execute
squads run intelligence/analyst --dry-run
# → Would run: gemini --prompt "Analyze market trends..."
```

### Core Implementation

```typescript
// src/commands/run.ts

import { spawnSync } from 'child_process';
import { PROVIDERS } from '../lib/providers.js';

export async function runAgent(squad: string, agent: string, options: RunOptions) {
  // 1. Parse configs
  const squadConfig = parseSquad(squad);
  const agentConfig = parseAgent(squad, agent);

  // 2. Determine provider (agent override > option > squad default > anthropic)
  const providerId =
    agentConfig.provider ||
    options.provider ||
    squadConfig.providers?.default ||
    'anthropic';

  // 3. Get CLI config
  const cli = PROVIDERS[providerId];
  if (!cli) {
    throw new Error(`Unknown provider: ${providerId}`);
  }

  // 4. Check availability
  if (!cli.available()) {
    console.error(`CLI '${cli.command}' not found.`);
    console.error(`Install: ${getInstallCommand(providerId)}`);
    process.exit(1);
  }

  // 5. Build prompt from agent file
  const prompt = buildPrompt(agentConfig, squadConfig);

  // 6. Execute
  if (options.dryRun) {
    console.log(`Would run: ${cli.command} ${cli.buildArgs(prompt).join(' ')}`);
    return;
  }

  const result = spawnSync(cli.command, cli.buildArgs(prompt, options), {
    stdio: 'inherit',
    cwd: options.cwd || process.cwd(),
  });

  return result.status;
}
```

---

## Agent Prompt Building

The agent markdown becomes the prompt:

```markdown
# Social Monitor

## Provider
xai

## Purpose
Monitor X/Twitter for trending topics in AI and tech.

## Instructions
1. Search for trending topics related to AI agents
2. Identify key discussions and sentiment
3. Summarize top 5 trends with links
4. Note any mentions of competitors

## Output
Markdown report with trends, links, and analysis.
```

Becomes prompt:

```
You are Social Monitor.

Purpose: Monitor X/Twitter for trending topics in AI and tech.

Instructions:
1. Search for trending topics related to AI agents
2. Identify key discussions and sentiment
3. Summarize top 5 trends with links
4. Note any mentions of competitors

Output: Markdown report with trends, links, and analysis.
```

---

## Working Directory

Each CLI executes in the appropriate context:

```typescript
const cwd = options.cwd || squadConfig.repo
  ? path.join(process.cwd(), '..', squadConfig.repo)
  : process.cwd();

spawnSync(cli.command, args, { stdio: 'inherit', cwd });
```

---

## Environment Variables

CLIs read their own API keys:

```bash
# .env (or shell profile)
ANTHROPIC_API_KEY=sk-ant-...   # claude
GOOGLE_API_KEY=AIza...          # gemini (or OAuth)
OPENAI_API_KEY=sk-...           # codex
MISTRAL_API_KEY=...             # vibe
XAI_API_KEY=...                 # grok
```

squads-cli doesn't need to know about keys - each CLI handles its own auth.

---

## File Structure

```
.agents/
└── squads/
    └── intelligence/
        ├── SQUAD.md              # providers.default: anthropic
        └── agents/
            ├── analyst.md        # (uses squad default)
            ├── social-monitor.md # provider: xai
            └── summarizer.md     # provider: google
```

---

## Examples

### Intelligence Squad

```yaml
---
schema: squad/v0.2
name: intelligence
mission: Market research and competitive analysis

providers:
  default: anthropic
  realtime: xai
  cheap: google
---

# Intelligence Squad

## Agents

| Agent | Provider | Purpose |
|-------|----------|---------|
| analyst | anthropic | Deep market research |
| social-monitor | xai | Real-time social trends |
| summarizer | google | Fast summarization |
```

### Running

```bash
# Run analyst with Claude
squads run intelligence/analyst
# → claude --print "You are analyst..."

# Run social-monitor with Grok
squads run intelligence/social-monitor
# → grok --prompt "You are social-monitor..."

# Run summarizer with Gemini
squads run intelligence/summarizer
# → gemini --prompt "You are summarizer..."

# Override: run analyst with Gemini instead
squads run intelligence/analyst --provider=google
# → gemini --prompt "You are analyst..."
```

---

## Implementation Plan

### Phase 1: Provider Registry (1 day)
- [ ] Create `src/lib/providers.ts` with CLI mappings
- [ ] Add `commandExists()` utility
- [ ] Add `squads providers` command

### Phase 2: Parser Extension (1 day)
- [ ] Parse `providers:` from SQUAD.md frontmatter
- [ ] Parse `provider:` from agent frontmatter/headers
- [ ] Build prompt from agent markdown

### Phase 3: Run Command (1 day)
- [ ] Update `squads run` to use provider
- [ ] Add `--provider` flag
- [ ] Add `--dry-run` to preview command
- [ ] Handle missing CLI with install instructions

### Phase 4: Documentation (0.5 day)
- [ ] Update docs/guides/multi-llm.mdx
- [ ] Update CLI reference
- [ ] Add examples

---

## Future Extensions

### v0.2.1: Model Selection
```yaml
providers:
  default:
    cli: anthropic
    model: claude-sonnet-4
```

Pass model to CLI: `claude --print --model claude-opus-4 "..."`

### v0.2.2: Fallback
```yaml
providers:
  default: anthropic
  fallback: google
```

If `claude` fails, retry with `gemini`.

### v0.2.3: Output Capture
```typescript
const result = spawnSync(cli.command, args, { stdio: 'pipe' });
saveToMemory(squad, agent, result.stdout);
```

---

## License

MIT - Same as SQUAD.md specification.
