---
name: reference_ce_facade_super_subbuild_verify_and_clang_format_prod1_gap
description: "Zwei CI-Verifikations-Lücken auf prod1 (09.07., Phase-1-#230-Revert-Anlass): (1) ce-Umbrella-ziehende Targets MÜSSEN im super-Sub-Build verifiziert werden, nicht nur Standalone-ce — Include-Pfade divergieren (vendored ext/-Adapter fehlen); (2) clang-format ist auf prod1 NICHT installiert → CI-lint:format ist die einzige Prüfung"
metadata:
  node_type: memory
  type: reference
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**Anlass:** Phase 1 (#230) run_profile-Fassade (ce 698977fe/super 5b5dc9c) baute lokal grün (Standalone-ce `build-conf`), aber die super-CI failte → sauberer Revert (ce fc6f2e45/super fac49e6).

**Lücke 1 — Standalone-ce ≠ super-Sub-Build (Include-Pfade divergieren):** Ein ce-Target, das den `all_axes_umbrella` zieht (alle 19 Achsen compile-time), braucht die **vendored ext/-Adapter-Include-Pfade** (z. B. `axis_06_allocator_mimalloc.hpp` → `#include <mimalloc.h>`, liegt in `ext/allocator/A04-mimalloc/include/`). Im **Standalone-ce** sind diese Pfade global verfügbar (die ce-CMake-Umgebung), im **super-Sub-Build** (`add_subdirectory`, `_cache_engine_external/`) NICHT — dort `fatal error: mimalloc.h: No such file`. **Fix:** das Target muss die ~15 vendored Adapter-Targets linken, die der Umbrella zieht: `comdare::adapter::{a01_hoard,a03_michael_lockfree,a04_mimalloc,a05_jemalloc,a06_tcmalloc,a07_snmalloc,a08_scalloc,a10_rpmalloc,a11_lrmalloc,p07_wormhole,p10_surf,p20_btreesareback,p25_mahling,p29_rcu,p30_hazardpointers}` (volle Liste = das `m3v2_pmc_smoke`-Target spiegeln, `tests/unit/CMakeLists.txt:286-300`). **Konsequenz:** Bei Fassaden-/Umbrella-Arbeit IMMER den super-Sub-Build (super `Code/` konfigurieren + `messung_driver` bauen) verifizieren, nicht nur ce-`build-conf`.

**Lücke 2 — clang-format-Bezug auf prod1 (GELÖST 2026-07-09):** `pip`/`npm`/`clang-format` sind nicht installiert, ABER das **exakte CI-Paket liegt als `.deb`** unter `/home/comdare/tools/clang-format-22*.deb`. Ohne sudo extrahieren: `dpkg-deb -x <deb> ~/tools/cf22` → Binary **`~/tools/cf22/usr/bin/clang-format-22`** (Ubuntu clang-format **version 22.1.8**, CI-identisch; verifiziert `--dry-run --Werror` auf Bestandsdatei == 0). **DIESEN Pfad für alle lokalen Format-Checks/-Fixes nutzen** (`clang-format-22 -i <files>` zum In-Place-Formatieren, dann diff prüfen). `.clang-format` = `BasedOnStyle:LLVM, ColumnLimit:120, AlignConsecutiveAssignments/Declarations/Macros:Consecutive` (User 06-29 „maximale penible Sauberkeit" — aligned POD-Member exakt). Impl-Agenten diesen Pfad mitgeben + vor jedem C++-Commit `clang-format-22 -i` + super-Sub-Build.

**Prozess-Lehre:** Impl-Agent-Artefakte für ce-Code vor Commit gegen den **super-Sub-Build** UND (falls formatierungspflichtig) gegen clang-format-22 prüfen — der Standalone-ce-Build + fehlendes lokales clang-format verstecken genau diese zwei Fehlerklassen. Siehe [[feedback_codex_implements_from_dossier_claude_corrects]] [[feedback_e4_xml_autoritative_bauanleitung_ceb_orchestriert]] [[reference_ci_runner_ice_cold_cache_instability]].
