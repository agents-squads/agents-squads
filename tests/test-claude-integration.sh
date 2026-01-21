#!/bin/bash
# Test: Claude Code integration with squads
# Run this FROM the agents-squads directory

set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0

echo "=== Claude Code Integration Tests ==="
echo ""

# Test 1: squads CLI is available
echo -n "Test 1: squads CLI is installed... "
if command -v squads &>/dev/null; then
    echo "PASS"
    ((PASS++))
else
    echo "FAIL (install with: npm install -g squads-cli)"
    ((FAIL++))
fi

# Test 2: squads status runs without error
echo -n "Test 2: 'squads status' runs successfully... "
if squads status &>/dev/null; then
    echo "PASS"
    ((PASS++))
else
    echo "FAIL"
    ((FAIL++))
fi

# Test 3: CLAUDE.md contains expected sections
echo -n "Test 3: CLAUDE.md has Overview section... "
if grep -q "## Overview" "$REPO_ROOT/CLAUDE.md"; then
    echo "PASS"
    ((PASS++))
else
    echo "FAIL"
    ((FAIL++))
fi

# Test 4: CLAUDE.md has CLI commands
echo -n "Test 4: CLAUDE.md documents CLI commands... "
if grep -q "squads status" "$REPO_ROOT/CLAUDE.md"; then
    echo "PASS"
    ((PASS++))
else
    echo "FAIL"
    ((FAIL++))
fi

# Test 5: .claude/settings.json hooks are executable
echo -n "Test 5: SessionStart hook command is executable... "
HOOK_CMD=$(jq -r '.hooks.SessionStart[0].hooks[0].command' "$REPO_ROOT/.claude/settings.json" | cut -d' ' -f1)
if command -v "$HOOK_CMD" &>/dev/null; then
    echo "PASS"
    ((PASS++))
else
    echo "FAIL (command not found: $HOOK_CMD)"
    ((FAIL++))
fi

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
echo ""
echo "Manual verification:"
echo "  1. Open Claude Code in this directory"
echo "  2. Verify 'squads status' runs on session start"
echo "  3. Verify CLAUDE.md instructions are loaded (ask Claude about squads)"

if [[ $FAIL -gt 0 ]]; then
    exit 1
fi
