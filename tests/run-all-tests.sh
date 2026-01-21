#!/bin/bash
# Run all squads integration tests

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TOTAL_PASS=0
TOTAL_FAIL=0

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║           Agents Squads - Multi-Tool Test Suite              ║"
echo "║                                                              ║"
echo "║  Tests Claude Code and Gemini CLI integration                ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

run_test() {
    local test_file="$1"
    local test_name="$2"

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Running: $test_name"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    if bash "$test_file"; then
        echo ""
        return 0
    else
        echo ""
        return 1
    fi
}

# Make test scripts executable
chmod +x "$SCRIPT_DIR"/*.sh

# Run tests
echo ""

if run_test "$SCRIPT_DIR/test-config-validity.sh" "Configuration Validity"; then
    ((TOTAL_PASS++))
else
    ((TOTAL_FAIL++))
fi

if run_test "$SCRIPT_DIR/test-claude-integration.sh" "Claude Code Integration"; then
    ((TOTAL_PASS++))
else
    ((TOTAL_FAIL++))
fi

if run_test "$SCRIPT_DIR/test-gemini-integration.sh" "Gemini CLI Integration"; then
    ((TOTAL_PASS++))
else
    ((TOTAL_FAIL++))
fi

if run_test "$SCRIPT_DIR/test-agents-md.sh" "AGENTS.md Alternative Pattern"; then
    ((TOTAL_PASS++))
else
    ((TOTAL_FAIL++))
fi

# Summary
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                      TEST SUMMARY                            ║"
echo "╠══════════════════════════════════════════════════════════════╣"
printf "║  Test Suites: %d passed, %d failed                            ║\n" "$TOTAL_PASS" "$TOTAL_FAIL"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

if [[ $TOTAL_FAIL -gt 0 ]]; then
    echo "Some tests failed. Review output above for details."
    exit 1
else
    echo "All automated tests passed!"
    echo ""
    echo "Next steps - Manual verification:"
    echo "  1. Open Claude Code: claude"
    echo "  2. Open Gemini CLI:  gemini"
    echo "  3. Verify both load squads context and run hooks"
fi
