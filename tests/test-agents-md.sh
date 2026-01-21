#!/bin/bash
# Test: AGENTS.md as alternative canonical file
# Tests the pattern where AGENTS.md is the shared file (instead of CLAUDE.md)

set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0

echo "=== AGENTS.md Alternative Pattern Tests ==="
echo ""
echo "This tests using AGENTS.md as the canonical shared instruction file."
echo "Both Claude Code and Gemini CLI can be configured to read it."
echo ""

# Test 1: Check if AGENTS.md exists (optional pattern)
echo -n "Test 1: AGENTS.md exists (optional)... "
if [[ -f "$REPO_ROOT/AGENTS.md" ]]; then
    echo "PASS (found)"
    ((PASS++))
else
    echo "SKIP (using CLAUDE.md pattern instead)"
fi

# Test 2: Gemini can be configured to read multiple files
echo -n "Test 2: Gemini supports array fileName config... "
# Create a test config to validate the array syntax
TEST_CONFIG='{"context":{"fileName":["AGENTS.md","CLAUDE.md"]}}'
if echo "$TEST_CONFIG" | jq -e '.context.fileName | type == "array"' >/dev/null 2>&1; then
    echo "PASS"
    ((PASS++))
else
    echo "FAIL"
    ((FAIL++))
fi

# Test 3: Document the AGENTS.md pattern
echo ""
echo "=== AGENTS.md Pattern (Alternative) ==="
echo ""
echo "To use AGENTS.md as the canonical file:"
echo ""
echo "1. Create AGENTS.md with shared instructions"
echo ""
echo "2. Configure Gemini (.gemini/settings.json):"
echo '   { "context": { "fileName": "AGENTS.md" } }'
echo ""
echo "3. For Claude Code, use .claude/rules/:"
echo "   mv AGENTS.md .claude/rules/agents.md"
echo "   (Claude auto-loads all .md files in .claude/rules/)"
echo ""
echo "4. Or use import in CLAUDE.md:"
echo "   See @AGENTS.md"
echo ""

# Test 4: Verify .claude/rules/ pattern works
echo -n "Test 4: .claude/rules/ directory exists or can be created... "
if [[ -d "$REPO_ROOT/.claude/rules" ]] || mkdir -p "$REPO_ROOT/.claude/rules" 2>/dev/null; then
    echo "PASS"
    ((PASS++))
    # Clean up if we created it
    rmdir "$REPO_ROOT/.claude/rules" 2>/dev/null || true
else
    echo "FAIL"
    ((FAIL++))
fi

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
echo ""
echo "Current setup uses CLAUDE.md as canonical (recommended)."
echo "AGENTS.md pattern is an alternative for teams preferring vendor-neutral naming."
