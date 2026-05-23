# V37.G (2026-05-23) - Aggregator-Manifest fuer drei Wurzeln
# Wird via POST_BUILD vom comdare_perms_all Target aufgerufen.
#
# Eingaben (per -D):
#   PERM_CE_MANIFEST   - cache-engine manifest
#   PERM_PA_MANIFEST   - prt-art manifest
#   PERM_ALL_OUT       - Aggregator-Output
#   PERM_ROOT          - perm/ root dir

cmake_minimum_required(VERSION 3.28)

# Lade beide Manifests
set(_ce_lines "")
if(EXISTS "${PERM_CE_MANIFEST}")
    file(STRINGS "${PERM_CE_MANIFEST}" _ce_lines)
endif()
set(_pa_lines "")
if(EXISTS "${PERM_PA_MANIFEST}")
    file(STRINGS "${PERM_PA_MANIFEST}" _pa_lines)
endif()

# Filtere Kommentare/leere Zeilen
set(_ce_perms "")
foreach(_l IN LISTS _ce_lines)
    if(NOT _l STREQUAL "" AND NOT _l MATCHES "^#")
        list(APPEND _ce_perms "${_l}")
    endif()
endforeach()
set(_pa_perms "")
foreach(_l IN LISTS _pa_lines)
    if(NOT _l STREQUAL "" AND NOT _l MATCHES "^#")
        list(APPEND _pa_perms "${_l}")
    endif()
endforeach()

list(LENGTH _ce_perms _n_ce)
list(LENGTH _pa_perms _n_pa)
math(EXPR _n_total "${_n_ce} + ${_n_pa}")

# manifest_all.txt
set(_content "# perm/all/manifest_all.txt - V37.G Aggregator (drei Wurzeln)\n")
string(APPEND _content "# Wurzel 1 cache_engine: ${_n_ce} Permutationen\n")
string(APPEND _content "# Wurzel 2 prt_art:      ${_n_pa} Permutationen\n")
string(APPEND _content "# Wurzel 3 all (diese):  ${_n_total} Permutationen total\n")
string(APPEND _content "\n## cache_engine\n")
foreach(_p IN LISTS _ce_perms)
    string(APPEND _content "cache_engine/${_p}\n")
endforeach()
string(APPEND _content "\n## prt_art\n")
foreach(_p IN LISTS _pa_perms)
    string(APPEND _content "prt_art/${_p}\n")
endforeach()
file(WRITE "${PERM_ALL_OUT}" "${_content}")

# Zusatz: perm/README.md mit Wurzel-Uebersicht + Build-Label
set(_label_content "")
if(EXISTS "${PERM_ROOT}/BUILD_LABEL.txt")
    file(READ "${PERM_ROOT}/BUILD_LABEL.txt" _label_content)
endif()

file(WRITE "${PERM_ROOT}/README.md"
"# Permutations-Filesystem-Baum (V37.G)

Drei Wurzeln:

| Wurzel | Subsystem | Anzahl |
|--------|-----------|--------|
| `cache_engine/` | comdare-cache-engine Permutationen | ${_n_ce} |
| `prt_art/`      | comdare-prt-art Pruefling-Permutationen | ${_n_pa} |
| `all/`          | Aggregator-Manifest beider | ${_n_total} |

Achsen-Hierarchie pro Wurzel:

**cache_engine:** `simd_<v>/layout_<v>/alloc_<v>[/node_<v>/concur_<v>]/perm_<id>.lib`

**prt_art:** `node_<v>/pc_<v>/lookup_<v>/telem_<v>/perm_pa_<id>.lib`

## Build-Label

\`\`\`
${_label_content}
\`\`\`

## Aggregator-Manifest

Siehe `all/manifest_all.txt`.
")

message(STATUS "V37.G: ${_n_ce} cache-engine + ${_n_pa} prt-art = ${_n_total} Permutationen aggregiert")
