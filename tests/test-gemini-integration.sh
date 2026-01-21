#!/bin/bash
# Test: Gemini CLI integration with squads
# Run this FROM the agents-squads directory

set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0

echo "=== Gemini CLI Integration Tests ==="
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

# Test 2: gemini CLI is available
echo -n "Test 2: gemini CLI is installed... "
if command -v gemini &>/dev/null; then
    echo "PASS"
    ((PASS++))
else
    echo "FAIL (install from: https://github.com/google-gemini/gemini-cli)"
    ((FAIL++))
fi

# Test 3: squads status runs without error
echo -n "Test 3: 'squads status' runs successfully... "
if squads status &>/dev/null; then
    echo "PASS"
    ((PASS++))
else
    echo "FAIL"
    ((FAIL++))
fi

# Test 4: Gemini config reads CLAUDE.md (not GEMINI.md)
echo -n "Test 4: Gemini configured to read CLAUDE.md... "
FILENAME=$(jq -r '.context.fileName' "$REPO_ROOT/.gemini/settings.json" 2>/dev/null)
if [[ "$FILENAME" == "CLAUDE.md" ]]; then
    echo "PASS"
    ((PASS++))
else
    echo "FAIL (reading: $FILENAME)"
    ((FAIL++))
fi

# Test 5: Gemini hooks are enabled
echo -n "Test 5: Gemini hooks are enabled... "
HOOKS_ENABLED=$(jq -r '.hooks.enabled' "$REPO_ROOT/.gemini/settings.json" 2>/dev/null)
TOOLS_HOOKS=$(jq -r '.tools.enableHooks' "$REPO_ROOT/.gemini/settings.json" 2>/dev/null)
if [[ "$HOOKS_ENABLED" == "true" && "$TOOLS_HOOKS" == "true" ]]; then
    echo "PASS"
    ((PASS++))
else
    echo "FAIL (hooks.enabled: $HOOKS_ENABLED, tools.enableHooks: $TOOLS_HOOKS)"
    ((FAIL++))
fi

# Test 6: SessionStart hook has required fields
echo -n "Test 6: SessionStart hook has name and command... "
HOOK_NAME=$(jq -r '.hooks.SessionStart[0].hooks[0].name' "$REPO_ROOT/.gemini/settings.json" 2>/dev/null)
HOOK_CMD=$(jq -r '.hooks.SessionStart[0].hooks[0].command' "$REPO_ROOT/.gemini/settings.json" 2>/dev/null)
if [[ -n "$HOOK_NAME" && "$HOOK_NAME" != "null" && "$HOOK_CMD" == "squads status" ]]; then
    echo "PASS"
    ((PASS++))
else
    echo "FAIL (name: $HOOK_NAME, command: $HOOK_CMD)"
    ((FAIL++))
fi

# Test 7: CLAUDE.md notes cross-tool support
echo -n "Test 7: CLAUDE.md mentions Gemini CLI... "
if grep -qi "gemini" "$REPO_ROOT/CLAUDE.md"; then
    echo "PASS"
    ((PASS++))
else
    echo "FAIL (add note about Gemini CLI reading this file)"
    ((FAIL++))
fi

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
echo ""
echo "Manual verification:"
echo "  1. Open Gemini CLI in this directory: gemini"
echo "  2. Check if 'squads status' output appears (may be plain text)"
echo "  3. Ask Gemini: 'What is the squads CLI?' to verify CLAUDE.md loaded"
echo "  4. Run '/memory show' to see loaded context"

if [[ $FAIL -gt 0 ]]; then
    exit 1
fi
