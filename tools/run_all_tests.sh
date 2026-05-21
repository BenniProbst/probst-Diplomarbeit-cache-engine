#!/usr/bin/env bash
# V34.C.1 (2026-05-21) - All-in-one Test-Runner (3 Repos)
#
# Verwendung:
#   tools/run_all_tests.sh
#
# Ruft direkt die V32/V33/V34-Test-Executables auf (nicht via ctest, weil
# gtest_discover_tests *_NOT_BUILT-Markierungen erzeugt die ctest stoeren).
# Voraussetzung: Tests sind bereits gebaut.

set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Fallback: erst Diplomarbeit-Submodule, dann Research-Klon
RESEARCH_ROOT="$REPO_ROOT/../Projekte/Research"

red() { printf '\033[31m%s\033[0m' "$1"; }
green() { printf '\033[32m%s\033[0m' "$1"; }
yellow() { printf '\033[33m%s\033[0m' "$1"; }
bold() { printf '\033[1m%s\033[0m' "$1"; }

TOTAL_PASS=0
TOTAL_FAIL=0
TOTAL_NOT_FOUND=0

run_test_exe() {
    local label="$1"
    local exe="$2"
    if [[ ! -x "$exe" && ! -f "$exe" ]]; then
        yellow "  [NOT FOUND] $label  ($exe)"
        echo
        TOTAL_NOT_FOUND=$((TOTAL_NOT_FOUND + 1))
        return
    fi
    local output
    output=$("$exe" --gtest_brief=1 2>&1)
    local passed
    passed=$(echo "$output" | grep -oE '\[  PASSED  \] [0-9]+ test' | grep -oE '[0-9]+' || echo 0)
    local failed
    failed=$(echo "$output" | grep -oE '\[  FAILED  \] [0-9]+ test' | grep -oE '[0-9]+' || echo 0)
    [[ -z "$passed" ]] && passed=0
    [[ -z "$failed" ]] && failed=0
    TOTAL_PASS=$((TOTAL_PASS + passed))
    TOTAL_FAIL=$((TOTAL_FAIL + failed))
    if [[ $failed -gt 0 ]]; then
        echo "  $(red "[FAIL]") $label  -> $passed passed, $failed failed"
        echo "$output" | tail -10
    else
        echo "  $(green "[ OK ]") $label  -> $passed passed"
    fi
}

# === comdare-cache-engine V32/V34 ===
echo
bold "=== comdare-cache-engine V32/V34 (build/msvc-release) ==="
echo
CE_BUILD="$REPO_ROOT/Code/external/comdare-cache-engine/build/msvc-release"
[[ -d "$CE_BUILD" ]] || CE_BUILD="$RESEARCH_ROOT/comdare-cache-engine/build/msvc-release"

run_test_exe "test_permutation_flags_v32" \
    "$CE_BUILD/libs/cache_engine/builder/commands/tests/Release/test_permutation_flags_v32.exe"
run_test_exe "test_commands" \
    "$CE_BUILD/libs/cache_engine/builder/commands/tests/Release/test_commands.exe"
run_test_exe "test_engine_adapters" \
    "$CE_BUILD/libs/cache_engine/builder/commands/tests/Release/test_engine_adapters.exe"

# === comdare-prt-art V33 ===
echo
bold "=== comdare-prt-art V33 (build/msvc-release) ==="
echo
PA_BUILD="$REPO_ROOT/Code/external/comdare-prt-art/build/msvc-release"
[[ -d "$PA_BUILD" ]] || PA_BUILD="$RESEARCH_ROOT/comdare-prt-art/build/msvc-release"

run_test_exe "test_default_lookup_registry" \
    "$PA_BUILD/tests/unit/Release/test_default_lookup_registry.exe"
run_test_exe "test_leaf_only_counter" \
    "$PA_BUILD/tests/unit/Release/test_leaf_only_counter.exe"

# === Diplomarbeit V33/V34 ===
echo
bold "=== Diplomarbeit V33/V34 (Code/build/msvc-release-v32) ==="
echo
DA_BUILD="$REPO_ROOT/Code/build/msvc-release-v32"

run_test_exe "test_v32_orchestrator" \
    "$DA_BUILD/tests/Release/test_v32_orchestrator.exe"
run_test_exe "test_messreihe_v32_validator" \
    "$DA_BUILD/tests/Release/test_messreihe_v32_validator.exe"
run_test_exe "test_dataset_filter" \
    "$DA_BUILD/tests/Release/test_dataset_filter.exe"
run_test_exe "test_messreihe_report_exporter" \
    "$DA_BUILD/tests/Release/test_messreihe_report_exporter.exe"

# === Bilanz ===
echo
bold "=== Bilanz V34.C all-in-one ==="
echo
echo "passed: $(green "$TOTAL_PASS")"
if [[ $TOTAL_FAIL -gt 0 ]]; then
    echo "failed: $(red "$TOTAL_FAIL")"
else
    echo "failed: $TOTAL_FAIL"
fi
if [[ $TOTAL_NOT_FOUND -gt 0 ]]; then
    echo "not found (rebuild needed): $(yellow "$TOTAL_NOT_FOUND")"
fi
echo

if [[ $TOTAL_FAIL -gt 0 ]]; then
    exit 1
fi
exit 0
