---
name: project-thesis-19-26-22-deferred-until-cluster
description: Thesis-TODOs
metadata: 
  node_type: memory
  type: project
  originSessionId: 78cf67f8-571e-4fcd-a907-1556dbc5be72
---

User-Entscheidung 2026-06-01 (autonomer TODO-Sweep, /goal „übrige TODOs abarbeiten"):

- **#19** (jemalloc/tcmalloc/hoard/scalloc echt linken) + **#26** (reale PMC-Hardware-Counter): lokal physisch
  NICHT abschließbar (literal verifiziert: kein vcpkg/WSL-gcc/nativer gcc/autoconf für #19; kein Intel-PCM/MSR-Device
  für #26). **Bleiben per Compile-Flag abgeschaltet** (`USE=ENABLE&&HAVE`, HAVE=OFF → Stubs; PMC = `NullPmcSource`).
  **Beschaffungs-Specs GELIEFERT 2026-06-01** (User-Freigabe Opt.3, Workflow `wtgq51wnz`, web+code-verifiziert):
  `docs/sessions/20260601-19-vendor-allokatoren-beschaffungs-spec.md` (Option-Matrix je Vendor + mimalloc-Vorbild +
  Verifikations-Checkliste) + `docs/sessions/20260601-26-pmc-counter-beschaffungs-spec.md` (reale 6 POD-Felder →
  IntelPcm/LinuxPerf/PAPI/likwid-Drop-ins). **Nur noch die UMSETZUNG (echtes Linking / echte Counter) ist
  zurückgestellt** bis Cluster/GitLab/ZIH-Toolchain+HW+Rechte da sind. Mechanik real bewiesen an mimalloc/snmalloc/
  dlmalloc. NIE fälschen ([[feedback_no_quick_fixes]], [[feedback_no_success_marks_without_literal_output]]).

- **#22** (6 cache-engine-Submodule-Repos `comdare-{cache-engine-core,search-engine,measurement,isa-dispatch,
  build-tools,test-system}`): **KERN-BEFÜLLUNG DONE 2026-06-01** (User-Freigabe „doch befüllen" → Doku-25-Option A).
  Alle 6 Repos mit kuratiertem Public-Header-Set (120 Header) + Scope-README + INTERFACE-CMakeLists befüllt+gepusht,
  Parent-Pointer gebumpt (CE `ce32e84`/DA `129b597`). Non-destruktiv: Monolith libs/ unverändert, modules/ NICHT im
  Build-Graph (kein add_subdirectory/Wurzel-GLOB) → Build grün (Smoke 5/5). Workflow `wvwn8ntln` (6 Explore).
  Entscheidungsdoku `docs/architecture/25_modul_aufteilung_submodule_vs_dependencymanager.md`. **VERBLEIBT
  (Option-B-Folgephase):** echte Konsumptions-Migration (Monolith baut FROM Submodulen via DependencyManager) +
  nested-cleanup — gated auf GitLab-/DependencyManager-Reife.

**Cluster-Kontext (User 2026-06-01):** Cluster-dev läuft; Cluster-prod fast bereit; GitLab-Server läuft; ZIH-externe-
Ressourcen bald bereit. Sobald das steht: #19/#26-Beschaffung + #22-Befüllung (gemäß Architektur-Entscheidung) wieder aufnehmen.

**Diese Session ABGESCHLOSSEN + gepusht (3 Repos synchron):** #49-E/F (YCSB Scan/RMW via IScannableTier), #4 (masstree
is_original 4/4), #9 (axis_04 Node{N}Layout→NodeType). Alle anderen lokal-machbaren TODOs erledigt. Verbindet [[project-active-goal-directive]].
