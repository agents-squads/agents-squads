# MCP Servers

Model Context Protocol (MCP) servers extend agent capabilities with external tools.

## Recommended Servers

| Server | Purpose | Install |
|--------|---------|---------|
| **firecrawl** | Web scraping & search | `npx -y firecrawl-mcp` |
| **supabase** | Database operations | `npx -y @supabase/mcp-server-supabase` |
| **context7** | Documentation lookup | `npx -y @context7/mcp` |
| **github** | GitHub operations | `npx -y @anthropic/mcp-server-github` |
| **postgres** | Direct SQL queries | `npx -y @anthropic/mcp-server-postgres` |
| **filesystem** | File operations | `npx -y @anthropic/mcp-server-filesystem` |

## Installation

Add to `.claude/settings.json`:

```json
{
  "mcpServers": {
    "firecrawl": {
      "command": "npx",
      "args": ["-y", "firecrawl-mcp"],
      "env": {
        "FIRECRAWL_API_KEY": "${FIRECRAWL_API_KEY}"
      }
    },
    "supabase": {
      "command": "npx",
      "args": ["-y", "@supabase/mcp-server-supabase"],
      "env": {
        "SUPABASE_ACCESS_TOKEN": "${SUPABASE_ACCESS_TOKEN}"
      }
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/mcp"]
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

## Usage in Agents

Reference MCP tools in agent definitions:

```markdown
## Tools
- mcp__firecrawl__firecrawl_scrape
- mcp__firecrawl__firecrawl_search
- mcp__supabase__execute_sql
- mcp__context7__query-docs
```

## Custom MCP Servers

Create your own MCP server for domain-specific tools:

```
mcp/
├── custom-server/
│   ├── package.json
│   ├── src/
│   │   └── index.ts
│   └── README.md
```

See [MCP Documentation](https://modelcontextprotocol.io) for details.
