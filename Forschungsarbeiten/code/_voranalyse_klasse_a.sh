#!/usr/bin/env bash
# _voranalyse_klasse_a.sh — Voranalyse aller 12 geklonten Originalcode-Repos
#
# NO-PYTHON-DIREKTIVE (Memory feedback_no_python_in_buildchain):
#   Voranalyse via find / wc / grep / head — KEIN Python.
#
# Output pro Repo: _voranalyse_output_klasse_a/<paper>.txt
# Aufruf: bash _voranalyse_klasse_a.sh

set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT_DIR="${SCRIPT_DIR}/_voranalyse_output_klasse_a"
mkdir -p "${OUT_DIR}"

# Klasse-A-Repos (12 Stueck)
declare -a CLASS_A_DIRS=(
  "P01-ART/unodb"
  "P02-HOT/hot"
  "P03-Masstree/masstree-beta"
  "P04-CoCo-trie/CoCo-trie"
  "P05-START/START"
  "P06-B2tree/b2-tree-master"
  "P06-B2tree/bart-master"
  "P07-Wormhole/wormhole"
  "P10-SuRF/SuRF"
  "P20-BTreesAreBack/leanstore"
  "P25-Mahling-FillBuffer/prefetching"
  "P29-RCU-McKenney/userspace-rcu"
  "P30-Hazard-Pointers/haz_ptr"
)

analyze_repo() {
  local rel="$1"
  local repo_path="${SCRIPT_DIR}/${rel}"
  local p_id="${rel%%/*}"           # z.B. P01-ART
  local sub="${rel##*/}"            # z.B. unodb
  local out_file="${OUT_DIR}/${p_id}__${sub}.txt"

  if [[ ! -d "${repo_path}" ]]; then
    echo "[SKIP] ${rel} — Verzeichnis fehlt"
    return
  fi

  {
    echo "================================================================"
    echo "VORANALYSE: ${rel}"
    echo "Pfad: ${repo_path}"
    echo "Stand: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "================================================================"
    echo

    echo "## TOP-LEVEL-VERZEICHNIS"
    ls -la "${repo_path}" 2>/dev/null | head -30
    echo

    echo "## VERZEICHNIS-HIERARCHIE (max Tiefe 3)"
    find "${repo_path}" -maxdepth 3 -type d -not -path '*/\.*' 2>/dev/null | sed "s|${repo_path}|.|"
    echo

    echo "## SOURCE-FILE-INVENTAR (.cpp .hpp .h .cc .c)"
    find "${repo_path}" -type f \( -name '*.cpp' -o -name '*.hpp' -o -name '*.h' -o -name '*.cc' -o -name '*.c' \) -not -path '*/\.*' -not -path '*/third_party/*' 2>/dev/null | sed "s|${repo_path}|.|" | head -50
    echo

    echo "## LINES-OF-CODE-SUMMARY (top 20 by LOC)"
    find "${repo_path}" -type f \( -name '*.cpp' -o -name '*.hpp' -o -name '*.h' -o -name '*.cc' -o -name '*.c' \) -not -path '*/\.*' -not -path '*/third_party/*' -exec wc -l {} + 2>/dev/null | sort -rn | head -21 | sed "s|${repo_path}|.|"
    echo

    echo "## BUILD-SYSTEM"
    for f in CMakeLists.txt Makefile configure.ac autogen.sh meson.build BUILD; do
      if [[ -f "${repo_path}/${f}" ]]; then
        echo "  ✓ ${f} ($(wc -l < "${repo_path}/${f}") Zeilen)"
      fi
    done
    echo

    echo "## LIZENZ"
    for f in LICENSE LICENSE.md LICENSE.txt COPYING COPYING.md; do
      if [[ -f "${repo_path}/${f}" ]]; then
        echo "  Datei: ${f}"
        head -3 "${repo_path}/${f}" | sed 's/^/    /'
        break
      fi
    done
    if [[ ! -f "${repo_path}/LICENSE" && ! -f "${repo_path}/LICENSE.md" && ! -f "${repo_path}/COPYING" ]]; then
      echo "  ⚠ KEINE LICENSE-Datei gefunden"
    fi
    echo

    echo "## README EXCERPT"
    for f in README README.md README.txt README.rst; do
      if [[ -f "${repo_path}/${f}" ]]; then
        echo "  Datei: ${f}"
        head -40 "${repo_path}/${f}" | sed 's/^/    /'
        break
      fi
    done
    echo

    echo "## GREP-INDIKATOREN (Bausteine-Hints)"
    for kw in "Node4" "Node16" "Node48" "Node256" "CompoundNode" "MacroNode" "BorderNode" \
              "BPlusTree" "BPlus" "Patricia" "DenseByte" "SparseNode" \
              "OLC" "ROWEX" "RCU" "Hazard" "Atomic" \
              "Prefetch" "prefetch" "popcnt" "BMI2" "AVX2" "AVX-512" "AVX512" \
              "rank_select" "rank/select" "succinct" "bitmap" \
              "Histogram" "Counter" "HotPath" "ReadCount"; do
      cnt=$(grep -r --include='*.cpp' --include='*.hpp' --include='*.h' --include='*.cc' --include='*.c' -l "${kw}" "${repo_path}" 2>/dev/null | wc -l)
      if [[ ${cnt} -gt 0 ]]; then
        printf "  %-20s in %d Dateien\n" "${kw}" "${cnt}"
      fi
    done
    echo

    echo "## C++-STANDARD-INDIKATOREN"
    grep -h -r --include='CMakeLists.txt' "CMAKE_CXX_STANDARD\|cxx_std_" "${repo_path}" 2>/dev/null | head -5 | sed 's/^/  /'
    echo

    echo "## END VORANALYSE ${rel}"
  } > "${out_file}"

  printf "[OK] %-40s -> %s\n" "${rel}" "$(basename "${out_file}")"
}

echo "Voranalyse Klasse A — 12 Repos"
echo "Output-Verzeichnis: ${OUT_DIR}"
echo

for rel in "${CLASS_A_DIRS[@]}"; do
  analyze_repo "${rel}"
done

echo
echo "Voranalyse abgeschlossen. Pro Repo eine .txt-Datei in:"
echo "  ${OUT_DIR}"
