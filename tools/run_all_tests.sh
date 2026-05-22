#!/usr/bin/env bash
# V34.C.1 (2026-05-21) + V35.C.1 (2026-05-22) - All-in-one Test-Runner (3 Repos)
#
# Verwendung:
#   tools/run_all_tests.sh                                  # autodetect Build-Config
#   tools/run_all_tests.sh --config Debug                   # explizit Debug
#   tools/run_all_tests.sh --config RelWithDebInfo
#   BUILD_TYPE=Debug tools/run_all_tests.sh                 # via ENV
#
# Ruft direkt die V32/V33/V34-Test-Executables auf (nicht via ctest, weil
# gtest_discover_tests *_NOT_BUILT-Markierungen erzeugt die ctest stoeren).
#
# Build-Type-Logik (V35.C):
# 1. CLI --config <X> hat Vorrang
# 2. Sonst ENV BUILD_TYPE
# 3. Sonst Autodetect: erstes existierendes Verzeichnis in der Suchreihenfolge
#    Release > Debug > RelWithDebInfo > MinSizeRel
# 4. Bei Single-Config-Generatoren (Ninja) ist der Pfad ohne Subverzeichnis,
#    dann faellt das Skript auf "" (Single-Config-Modus) zurueck.

set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Fallback: erst Diplomarbeit-Submodule, dann Research-Klon
RESEARCH_ROOT="$REPO_ROOT/../Projekte/Research"

red() { printf '\033[31m%s\033[0m' "$1"; }
green() { printf '\033[32m%s\033[0m' "$1"; }
yellow() { printf '\033[33m%s\033[0m' "$1"; }
bold() { printf '\033[1m%s\033[0m' "$1"; }

# V35.C.1 — Build-Type Resolution
BUILD_TYPE_OVERRIDE=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --config) BUILD_TYPE_OVERRIDE="$2"; shift 2 ;;
        --config=*) BUILD_TYPE_OVERRIDE="${1#*=}"; shift ;;
        -h|--help)
            sed -n '1,20p' "$0"
            exit 0
            ;;
        *) echo "unknown arg: $1" >&2; exit 2 ;;
    esac
done

# Resolve Build-Type: CLI > ENV > Autodetect
DESIRED_BUILD_TYPE="${BUILD_TYPE_OVERRIDE:-${BUILD_TYPE:-}}"

# Pro Test-Verzeichnis: finde passenden Pfad
# Multi-config (MSVC): tests/Release/test.exe | tests/Debug/test.exe | tests/test.exe
# Single-config (Ninja): tests/test.exe (kein Sub-Dir)
resolve_test_exe() {
    local base_dir="$1"
    local test_name="$2"
    local candidates=()
    if [[ -n "$DESIRED_BUILD_TYPE" ]]; then
        candidates+=("$base_dir/$DESIRED_BUILD_TYPE/$test_name.exe")
        candidates+=("$base_dir/$DESIRED_BUILD_TYPE/$test_name")
    fi
    # Autodetect-Reihenfolge
    for cfg in Release Debug RelWithDebInfo MinSizeRel; do
        candidates+=("$base_dir/$cfg/$test_name.exe")
        candidates+=("$base_dir/$cfg/$test_name")
    done
    # Single-config (Ninja)
    candidates+=("$base_dir/$test_name.exe")
    candidates+=("$base_dir/$test_name")
    for c in "${candidates[@]}"; do
        if [[ -f "$c" ]]; then
            echo "$c"
            return 0
        fi
    done
    # nichts gefunden -> erste Kandidate-Variante zurueckgeben (fuer Fehlermeldung)
    echo "${candidates[0]}"
    return 1
}

TOTAL_PASS=0
TOTAL_FAIL=0
TOTAL_NOT_FOUND=0
RESOLVED_BUILD_TYPE=""

run_test_exe() {
    local label="$1"
    local base_dir="$2"
    local test_name="$3"
    local exe
    exe="$(resolve_test_exe "$base_dir" "$test_name")"
    if [[ ! -f "$exe" ]]; then
        yellow "  [NOT FOUND] $label  ($exe)"
        echo
        TOTAL_NOT_FOUND=$((TOTAL_NOT_FOUND + 1))
        return
    fi
    # Build-Type aus dem Pfad ableiten (fuer Bilanz-Anzeige)
    if [[ -z "$RESOLVED_BUILD_TYPE" ]]; then
        for cfg in Release Debug RelWithDebInfo MinSizeRel; do
            if [[ "$exe" == *"/$cfg/"* ]]; then
                RESOLVED_BUILD_TYPE="$cfg"
                break
            fi
        done
        [[ -z "$RESOLVED_BUILD_TYPE" ]] && RESOLVED_BUILD_TYPE="<single-config>"
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
bold "=== comdare-cache-engine V32/V34 ==="
echo
CE_BUILD="$REPO_ROOT/Code/external/comdare-cache-engine/build/msvc-release"
[[ -d "$CE_BUILD" ]] || CE_BUILD="$RESEARCH_ROOT/comdare-cache-engine/build/msvc-release"
CE_TESTS="$CE_BUILD/libs/cache_engine/builder/commands/tests"

run_test_exe "test_permutation_flags_v32" "$CE_TESTS" "test_permutation_flags_v32"
run_test_exe "test_commands"              "$CE_TESTS" "test_commands"
run_test_exe "test_engine_adapters"       "$CE_TESTS" "test_engine_adapters"

# === comdare-prt-art V33/V34 ===
echo
bold "=== comdare-prt-art V33/V34 ==="
echo
PA_BUILD="$REPO_ROOT/Code/external/comdare-prt-art/build/msvc-release"
[[ -d "$PA_BUILD" ]] || PA_BUILD="$RESEARCH_ROOT/comdare-prt-art/build/msvc-release"
PA_TESTS="$PA_BUILD/tests/unit"

run_test_exe "test_default_lookup_registry" "$PA_TESTS" "test_default_lookup_registry"
run_test_exe "test_leaf_only_counter"       "$PA_TESTS" "test_leaf_only_counter"

# === Diplomarbeit V33/V34 ===
echo
bold "=== Diplomarbeit V33/V34 ==="
echo
DA_BUILD="$REPO_ROOT/Code/build/msvc-release-v32"
DA_TESTS="$DA_BUILD/tests"

run_test_exe "test_v32_orchestrator"           "$DA_TESTS" "test_v32_orchestrator"
run_test_exe "test_messreihe_v32_validator"    "$DA_TESTS" "test_messreihe_v32_validator"
run_test_exe "test_dataset_filter"             "$DA_TESTS" "test_dataset_filter"
run_test_exe "test_messreihe_report_exporter"  "$DA_TESTS" "test_messreihe_report_exporter"

# === Diplomarbeit V35.D — Pro-Stufe-Tests mit gecachten Fixtures ===
echo
bold "=== Diplomarbeit V35.D Per-Stage-Fixtures ==="
echo
DA_03="$DA_BUILD/03_binary_to_csv"
DA_04="$DA_BUILD/04_csv_to_latex"
DA_05="$DA_BUILD/05_diagram_generator"
DA_06="$DA_BUILD/06_latex_to_pdf"

run_test_exe "test_03_binary_to_csv_cached_fixtures"    "$DA_03" "test_03_binary_to_csv_cached_fixtures"
run_test_exe "test_04_csv_to_latex_cached_fixtures"     "$DA_04" "test_04_csv_to_latex_cached_fixtures"
run_test_exe "test_05_diagram_generator_cached_fixtures" "$DA_05" "test_05_diagram_generator_cached_fixtures"
run_test_exe "test_06_latex_to_pdf_cached_fixtures"     "$DA_06" "test_06_latex_to_pdf_cached_fixtures"

# === Bilanz ===
echo
bold "=== Bilanz V35.C all-in-one ==="
echo
echo "Build-Type: ${RESOLVED_BUILD_TYPE:-<none-found>}  (Override: ${DESIRED_BUILD_TYPE:-<autodetect>})"
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
