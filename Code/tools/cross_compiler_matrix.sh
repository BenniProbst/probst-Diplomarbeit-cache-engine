#!/usr/bin/env bash
# V41.B4 (2026-05-25) — Cross-Compiler × Cross-BuildType Matrix
#
# Faehrt systematisch alle definierten Compiler/Generator/BuildType-Combos
# durch: configure + comdare_perms_all build + run_all_tests. Ergebnis
# als CSV in build/matrix-results.csv (pro Combo eine Zeile).
#
# Verwendung:
#   Code/tools/cross_compiler_matrix.sh                # alle Combos
#   Code/tools/cross_compiler_matrix.sh --only msvc    # nur MSVC-Combos
#   Code/tools/cross_compiler_matrix.sh --only mingw   # nur MinGW-Combos
#   Code/tools/cross_compiler_matrix.sh --skip-build   # nur configure+test

set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$CODE_ROOT/.." && pwd)"

red()    { printf '\033[31m%s\033[0m' "$1"; }
green()  { printf '\033[32m%s\033[0m' "$1"; }
yellow() { printf '\033[33m%s\033[0m' "$1"; }
bold()   { printf '\033[1m%s\033[0m' "$1"; }

FILTER=""
SKIP_BUILD=0
while [[ $# -gt 0 ]]; do
    case "$1" in
        --only)       FILTER="$2"; shift 2 ;;
        --only=*)     FILTER="${1#*=}"; shift ;;
        --skip-build) SKIP_BUILD=1; shift ;;
        -h|--help)
            sed -n '1,15p' "$0"
            exit 0 ;;
        *) echo "unknown arg: $1" >&2; exit 2 ;;
    esac
done

# MinGW + Ninja Tooling (CLion-Default)
MINGW_BIN="C:/Users/benja/AppData/Local/Programs/CLion/bin/mingw/bin"
NINJA_BIN="C:/Users/benja/AppData/Local/Programs/CLion/bin/ninja/win/x64"
export PATH="${NINJA_BIN}:${MINGW_BIN}:${PATH:-}"

# Definition der 8 Combos: family|generator|buildtype|build_dir|extra_args
declare -a COMBOS=(
    "msvc|Visual Studio 17 2022|Debug|build/matrix-msvc-debug|-A x64"
    "msvc|Visual Studio 17 2022|Release|build/matrix-msvc-release|-A x64"
    "msvc|Visual Studio 17 2022|MinSizeRel|build/matrix-msvc-minsizerel|-A x64"
    "msvc|Visual Studio 17 2022|RelWithDebInfo|build/matrix-msvc-relwithdebinfo|-A x64"
    "mingw|Ninja|Debug|build/matrix-mingw-debug|-DCMAKE_C_COMPILER=${MINGW_BIN}/gcc.exe -DCMAKE_CXX_COMPILER=${MINGW_BIN}/g++.exe -DCMAKE_MAKE_PROGRAM=${NINJA_BIN}/ninja.exe"
    "mingw|Ninja|Release|build/matrix-mingw-release|-DCMAKE_C_COMPILER=${MINGW_BIN}/gcc.exe -DCMAKE_CXX_COMPILER=${MINGW_BIN}/g++.exe -DCMAKE_MAKE_PROGRAM=${NINJA_BIN}/ninja.exe"
    "mingw|Ninja|MinSizeRel|build/matrix-mingw-minsizerel|-DCMAKE_C_COMPILER=${MINGW_BIN}/gcc.exe -DCMAKE_CXX_COMPILER=${MINGW_BIN}/g++.exe -DCMAKE_MAKE_PROGRAM=${NINJA_BIN}/ninja.exe"
    "mingw|Ninja|RelWithDebInfo|build/matrix-mingw-relwithdebinfo|-DCMAKE_C_COMPILER=${MINGW_BIN}/gcc.exe -DCMAKE_CXX_COMPILER=${MINGW_BIN}/g++.exe -DCMAKE_MAKE_PROGRAM=${NINJA_BIN}/ninja.exe"
)

RESULT_CSV="${CODE_ROOT}/build/matrix-results.csv"
mkdir -p "$(dirname "$RESULT_CSV")"
echo "family,generator,buildtype,build_dir,configure_status,configure_seconds,build_status,build_seconds,perm_count,test_passed,test_failed" > "$RESULT_CSV"

cd "$CODE_ROOT"

total_combos=0
ok_combos=0

for combo in "${COMBOS[@]}"; do
    IFS='|' read -r family generator buildtype build_dir extra <<< "$combo"
    if [[ -n "$FILTER" && "$family" != "$FILTER" ]]; then continue; fi
    total_combos=$((total_combos + 1))

    echo
    bold "=== ${family} ${buildtype} (${generator}) ==="
    echo

    rm -rf "$build_dir" 2>/dev/null
    t0=$(date +%s)
    cfg_log="$(mktemp)"
    eval cmake -B "$build_dir" -G \"$generator\" $extra \
        -DCMAKE_BUILD_TYPE=$buildtype \
        -DCOMDARE_V32_ENABLE=ON \
        > "$cfg_log" 2>&1
    cfg_rc=$?
    cfg_sec=$(($(date +%s) - t0))
    if [[ $cfg_rc -ne 0 ]]; then
        echo "  $(red '[CONFIGURE FAIL]') in ${cfg_sec}s — siehe $cfg_log"
        echo "$family,$generator,$buildtype,$build_dir,FAIL,$cfg_sec,SKIP,0,0,0,0" >> "$RESULT_CSV"
        continue
    fi
    echo "  $(green '[configure ok]') ${cfg_sec}s"

    build_status="SKIP"
    build_sec=0
    perm_count=0
    if [[ $SKIP_BUILD -eq 0 ]]; then
        t0=$(date +%s)
        build_log="$(mktemp)"
        if [[ "$family" == "msvc" ]]; then
            cmake --build "$build_dir" --target comdare_perms_all --config "$buildtype" --parallel 16 > "$build_log" 2>&1
        else
            cmake --build "$build_dir" --target comdare_perms_all --parallel 16 > "$build_log" 2>&1
        fi
        build_rc=$?
        build_sec=$(($(date +%s) - t0))
        if [[ $build_rc -eq 0 ]]; then
            build_status="OK"
            perm_count=$(find "$build_dir/perm" \( -name "perm_*.dll" -o -name "libperm_*.so" -o -name "libperm_*.a" -o -name "perm_*.lib" \) 2>/dev/null | wc -l)
            echo "  $(green '[build ok]') ${build_sec}s — ${perm_count} perm-artifacts"
        else
            build_status="FAIL"
            echo "  $(red '[build FAIL]') ${build_sec}s — siehe $build_log"
            echo "$family,$generator,$buildtype,$build_dir,OK,$cfg_sec,FAIL,$build_sec,$perm_count,0,0" >> "$RESULT_CSV"
            continue
        fi
    fi

    # Tests — derzeit nur run_all_tests.sh wenn das aktuelle build msvc-release-v32 ist;
    # fuer Matrix-Combos: nur Quick-Smoke der test_v32_orchestrator wenn existent
    test_passed=0
    test_failed=0
    test_exe=""
    if [[ "$family" == "msvc" ]]; then
        test_exe="$build_dir/tests/${buildtype}/test_v32_orchestrator.exe"
    else
        test_exe="$build_dir/tests/test_v32_orchestrator.exe"
    fi
    if [[ -f "$test_exe" ]]; then
        out=$("$test_exe" --gtest_brief=1 2>&1)
        p=$(echo "$out" | grep -oE '\[  PASSED  \] [0-9]+' | grep -oE '[0-9]+' | head -1)
        f=$(echo "$out" | grep -oE '\[  FAILED  \] [0-9]+' | grep -oE '[0-9]+' | head -1)
        test_passed=${p:-0}
        test_failed=${f:-0}
    fi

    echo "$family,$generator,$buildtype,$build_dir,OK,$cfg_sec,$build_status,$build_sec,$perm_count,$test_passed,$test_failed" >> "$RESULT_CSV"
    if [[ "$build_status" == "OK" || $SKIP_BUILD -eq 1 ]]; then
        ok_combos=$((ok_combos + 1))
    fi
done

echo
bold "=== Matrix-Bilanz ==="
echo
echo "Combos getestet: $total_combos"
echo "Erfolg:          $(green "$ok_combos")"
echo "Result-CSV:      $RESULT_CSV"
echo
cat "$RESULT_CSV"
