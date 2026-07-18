---
name: project_diplomarbeit_modules_mirrors_deleted_reuse_comdare_modules
description: Die 6 cache-engine modules/-Pseudo-Spiegel sind gelöscht; Diplomarbeit soll existierende comdare-*-all-Module via Produkt-Referenz wiederverwenden (Matrix schema)
metadata: 
  node_type: memory
  type: project
  originSessionId: 78cf67f8-571e-4fcd-a907-1556dbc5be72
---

Entscheidung 2026-07-04 (User). Die 6 GitHub-only Sub-Submodule unter `cache-engine/modules/` (comdare-build-tools/cache-engine-core/isa-dispatch/measurement/search-engine/test-system) waren **0/6 legit** — reine stale Header-Spiegel von `libs/cache_engine/` (ultracode-Audit wf_9f28bd31: 0 externe Refs in Projekte\, nur Mirror-Commit-Historie, build-tools/include leer → Salvage=∅).

**A ERLEDIGT:** entnestet (cache-engine `53ff03a3`, --cached wegen OneDrive-FS-Lock) + Super-Bump (`8f07f8c`) + **alle 6 GitHub-Remotes gelöscht** (`gh repo delete`). `ext/queuing/Q01-concurrentqueue` bleibt (echtes Third-Party cameron314). ABI/golden-320/Mess-Pfad unberührt (reine Repo-Struktur).

**B (in Arbeit, wcjse6hzc):** statt thesis-interner Eigenbau-Spiegel → existierende, reifere **comdare-*-all-Module** ermitteln + via **Produkt-Referenz-Module** sauber in die Diplomarbeit linken (**comdare Matrix schema**, Fassade/buildsystem.xml, Baseline-INV-3) → Wiederverwendbarkeit auf Maximum.

**Wichtig:** cache-engine == comdare-cacheengine-all (GLEICHES Remote, zwei Arbeitskopien: Diplomarbeit-Submodul aktuell vs. `Projekte/Modules/comdare-cacheengine-all/comdare-cache-engine` stale `c6634d8`); Repo-Split deferred #12. Baseline-Konvention „in Stein" (`baseline-system.md`): Modul in `Projekte/Modules/comdare-<x>-all/`, eigenes GitLab/`development`, `buildsystem.xml` + Baseline-Schichtordner, generischer Namespace + `comdare::<x>`-Alias, INV-2 nur abwärts, INV-3 via Fassade konsumiert. [[feedback_baseline_system_in_stein_gemeisselt_layering]] · [[feedback_consult_analysis_backups_via_ultracode_before_decisions]] · [[project_cache_engine_research_vs_cacheengine_all_split_todo]]
