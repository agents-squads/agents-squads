#!/bin/bash
# Test: Validate configuration files are valid JSON and have required fields

set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0

echo "=== Configuration Validity Tests ==="
echo ""

# Test 1: .claude/settings.json is valid JSON
echo -n "Test 1: .claude/settings.json is valid JSON... "
if jq empty "$REPO_ROOT/.claude/settings.json" 2>/dev/null; then
    echo "PASS"
    ((PASS++))
else
    echo "FAIL"
    ((FAIL++))
fi

# Test 2: .gemini/settings.json is valid JSON
echo -n "Test 2: .gemini/settings.json is valid JSON... "
if jq empty "$REPO_ROOT/.gemini/settings.json" 2>/dev/null; then
    echo "PASS"
    ((PASS++))
else
    echo "FAIL"
    ((FAIL++))
fi

# Test 3: Claude hooks has SessionStart
echo -n "Test 3: Claude config has SessionStart hook... "
if jq -e '.hooks.SessionStart' "$REPO_ROOT/.claude/settings.json" >/dev/null 2>&1; then
    echo "PASS"
    ((PASS++))
else
    echo "FAIL"
    ((FAIL++))
fi

# Test 4: Gemini hooks has SessionStart
echo -n "Test 4: Gemini config has SessionStart hook... "
if jq -e '.hooks.SessionStart' "$REPO_ROOT/.gemini/settings.json" >/dev/null 2>&1; then
    echo "PASS"
    ((PASS++))
else
    echo "FAIL"
    ((FAIL++))
fi

# Test 5: Gemini reads CLAUDE.md
echo -n "Test 5: Gemini configured to read CLAUDE.md... "
FILENAME=$(jq -r '.context.fileName' "$REPO_ROOT/.gemini/settings.json" 2>/dev/null)
if [[ "$FILENAME" == "CLAUDE.md" ]]; then
    echo "PASS"
    ((PASS++))
else
    echo "FAIL (got: $FILENAME)"
    ((FAIL++))
fi

# Test 6: CLAUDE.md exists
echo -n "Test 6: CLAUDE.md exists... "
if [[ -f "$REPO_ROOT/CLAUDE.md" ]]; then
    echo "PASS"
    ((PASS++))
else
    echo "FAIL"
    ((FAIL++))
fi

# Test 7: Both hooks run same command (squads status)
echo -n "Test 7: Both tools run 'squads status' on start... "
CLAUDE_CMD=$(jq -r '.hooks.SessionStart[0].hooks[0].command' "$REPO_ROOT/.claude/settings.json" 2>/dev/null)
GEMINI_CMD=$(jq -r '.hooks.SessionStart[0].hooks[0].command' "$REPO_ROOT/.gemini/settings.json" 2>/dev/null)
if [[ "$CLAUDE_CMD" == "squads status" && "$GEMINI_CMD" == "squads status" ]]; then
    echo "PASS"
    ((PASS++))
else
    echo "FAIL (claude: $CLAUDE_CMD, gemini: $GEMINI_CMD)"
    ((FAIL++))
fi

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="

if [[ $FAIL -gt 0 ]]; then
    exit 1
fi
