---
name: feedback_comdare_products_house_buildsystem_mandatory
description: comdare-Produkte (explizit comdare-web wie comdare-db) MÜSSEN das hauseigene cd-buildsystem statt fremder Build-Tools verwenden — Lizensierung + Code-Optimierung von Haus aus
metadata: 
  node_type: memory
  type: feedback
  originSessionId: c6f15797-7fa1-4e66-874f-55631afe1d28
---

**User-Direktive (2026-07-05, wörtlich sinngemäß):** comdare-web ist — wie auch die comdare-db — VERPFLICHTET, die hauseigene buildsystem-Implementierung (`cd-buildsystem-core` v3.4.15 via `buildsystem.xml`, Produkt `cd-buildsystem-construct`) statt anderer Build-Tools zu verwenden.

**Why:** Das hauseigene BuildSystem führt **Lizensierung** (comdare-licensing/isLicensed/BEP-EULA) und **Code-Optimierung von Haus aus** mit. Fremde Build-Tools (reines CMake, Bazel, etc.) verlieren diese eingebauten Produkt-Eigenschaften.

**How to apply:** In JEDEM comdare-Produkt (comdare-web, comdare-db, Steuerrater A/B, …) von Anfang an: `buildsystem.xml` pflegen + cd-buildsystem-Delegation als offiziellen Produkt-Build in Goal-Text/Ledger/Invarianten verankern. CMake/CMakePresets sind nur der Light-/Dev-Unterbau (lokale Iteration), NICHT der offizielle Build-Weg. Bei Planungen (FEATURES-MASTER/Wellenpläne) die BuildSystem-Pflicht als Invariante aufnehmen. [[feedback_all_comdare_cpp_drogon_other_langs_are_feature_sources]] [[feedback_baseline_system_in_stein_gemeisselt_layering]] [[project_deferred_steuerrater_buildsystem_***REDACTED***]]
