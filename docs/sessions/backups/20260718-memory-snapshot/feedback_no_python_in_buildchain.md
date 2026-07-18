---
name: feedback_no_python_in_buildchain
description: "PRT-ART/Diplomarbeit: Python in der Build-/Codegen-/Toolchain-Pipeline VERBOTEN (Ziel Talos OS hat kein Python). Stattdessen: CMake-Funktionen (add_custom_command/configure_file/add_subdirectory) als primäre Codegen-Sprache + Shell synchron .sh(POSIX)/.bat(Windows, identisches Verhalten) + zur Not kompilierter C++23-Helper. Keine *.py als Build-Pipeline-Tooling."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**Architekt-Direktive (2026-05-08):** In der PRT-ART-Diplomarbeit ist Python in der Build-/Codegen-/Toolchain-Pipeline VERBOTEN.

**Stattdessen:**
- **CMake-Funktionen** (`add_custom_command`, `configure_file()`, `add_subdirectory()`) als primäre Codegen-Sprache.
- **Shell** synchron in `*.sh` (POSIX) und `*.bat` (Windows) — beide müssen identisches Verhalten zeigen.
- Nicht in CMake/Shell ausdrückbar → kompilierter **C++23-Helper** als BuildSystem-Tool (nie Python).

**Why:** Talos OS (Production-Plattform des Diplomarbeit-Clusters) ist minimalistisch — Python ist NICHT standardmäßig verfügbar und schwer nachzurüsten. Deckt sich mit dem Pre-Build-Codegen-Tool-Pattern aus [[feedback_compile_time_only_no_runtime]] (das Tool ist ein C++-Binary, kein Python).

**How to apply:** Bei jedem neuen Tooling-Stub (Permutation-Codegen, Datasets-Generator, LaTeX-Toolchain) NIEMALS `*.py` anbieten — zuerst CMake-eigene Mittel prüfen, sonst sh/bat synchron. Frühere Setup-Skripte (`_generate_stubs.py`, `_copy_ext_repos.py`, `_analyze_licenses.py`, `_generate_legacy_reimpl.py`) waren EINMALIG; für Build-Pipeline-Tooling gilt strikt sh/bat/CMake/C++.

**Herkunft:** konsolidiert aus Infra-Agent-Handover (Cluster `docs/agent-memories-infra/`, cwd `C--WINDOWS-system32`), übernommen 2026-07-08. Verwandt: [[feedback_immer_schwerer_offizieller_weg_keine_behelfswege]], [[reference_buildsystem_scripts_posix_no_grep_p]].
