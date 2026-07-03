# SESSION FULL COPY (2026-07-03) — lint-Pflicht komplett · Runner-Fix · /goal Parallelstrategie · 4 Kartierungen · Worktree-Debakel

> Vollständige chronologische Chronik dieser Session (User-Wunsch „session full copy"). Komprimierte
> Übergaben: SE-22 (`c746f2b`), MASTER-EXECUTION-PLAN (`6bd92f7`), SE-22b (`4fb5d6c`). Diese Datei = die
> lückenlose Verlaufs-Fassung mit allen Commits/Pipelines/Entscheidungen/Fundstellen.

---

## PHASE 0 — Einstieg (Fortsetzung + /compact)
Fortgesetzt aus Vorsession (SE-21/21b: #188-4c KOMPLETT `3ee71c6`, lint-Pflicht-Strecke #203 in Arbeit).
/compact-Args: „lies alle referenzierten Planungsquellen". Erster Schritt lt. SE-21b §0: Verify-Job 192563
(Projekt 286, lint:static auf Pipeline 7474, cppcheck-Template-Fix `968b333`) prüfen.

## PHASE 1 — lint-Pflicht-Strecke #203 (Hauptarbeit)
### 1a Diagnose Verify-Job 192563
- Job 192563 = **failed**, aber cppcheck LIEF (std.cfg-Fix `968b333` bestätigt): 37 ECHTE Findings statt
  Crash — 27 uninitMemberVarNoCtor + 4 ctuOneDefinitionRuleViolation + 2 syntaxError(TEST_F) + 3 unknownMacro
  + 1 internalAstError. Alle in tests/. Der std.cfg-Template-Bug ist damit erledigt.
### 1b ci-templates-Fixes (comdare/cluster/ci-templates@development, Scratchpad-Klon)
- **LLVM-SHA256-Pin:** von api.github.com llvm/llvm-project llvmorg-22.1.8 → `LLVM-22.1.8-Linux-X64.tar.xz`
  digest `df0e1ecf16caf3489a272a5eea4eec9b0d82878f6477fa309504f918a0006384`. Als `COMDARE_LLVM_SHA256_PIN`
  Template-Default + `--library=googletest` (behebt TEST_F-syntaxError) → **`0595811`**.
- **COMDARE_CPPCHECK_IGNORE_DIRS** variabilisiert (cppcheck rekursiert selbst, -i-Liste war hart; super
  scannte Submodule mit) → **`237b6ec`**; super setzt `ext build _archive… modules external thesis` (`e64e995`).
### 1c Format-Pass (#179-Teil, clang-format 22.1.8)
- clang-format.exe aus OFFIZIELLEM `clang+llvm-22.1.8-x86_64-pc-windows-msvc.tar.xz` (SHA `d96c2cc1…`
  verifiziert) in Scratchpad extrahiert (v22.1.8).
- **cache-engine `c4ad45e`** (71 nicht-konforme von 1331 Dateien; dry-run -Werror über CI-identische Liste = exit 0).
- **super:** kanonische `.clang-format` NEU (`b7500d4` — sonst prüft CI gegen LLVM-Default-Fallback!) + Format-Pass
  36 Dateien (`cc05146`) + Submodul-Bump (`7a3f449`).
- **prt-art:** kanonische .clang-format (`96212c5`) + 71 Dateien (`55ce94c`); GitHub war 7 ahead → gepusht.
### 1d static-Findings cache-engine (`d73ffef`)
- 27× uninitMemberVarNoCtor → Default-Member-Init `{}`/`=0`/`=false`.
- 4× ODR: MockTier (test_d13/test_kf7) + PFComposition (test_prefetch_patha_t7/real) → anonyme Namespaces;
  die v5-MockTier waren schon TU-lokal (Doppel-Wrap zurückgebaut).
- 3× unknownMacro (COMDARE-Codegen-Emitter) + 1× internalAstError (cppcheck-2.21-C++23-Grenze) → begründete
  inline-Suppressions. 2× syntaxError schon durch --library=googletest.
- **Nachfix `18de252`:** cppcheck-CTU wertet anonyme NS bei CLASS TEMPLATES NICHT → PFComposition (T7-Datei)
  → PFCompositionT7 umbenannt (distinkt statt suppress).
### 1e static-Findings super (`e5ef645`)
- USE_BOOST-Bruch zuerst: cppcheck-Bootstrap fand Host-Boost (HAVE_BOOST), PCH-Build brach → Template
  `-DUSE_BOOST=Off` (**`09f3bae`**, portabler std::vector-Fallback).
- Dann 15 ECHTE super-Findings: 14× uninit (SampleProfile/PairwiseRow/CsvRow in Auswerte-Tools 01/02/05) →
  `{}`-Init; 1× ignoredReturnValue test_messreihe_report_exporter:112 → `auto status = …; EXPECT_TRUE(status.ok())`.
- + prt-art-Submodul-Pointer-Bump (`29fdf27`) + cache-engine-Bumps (`d397691`, `753d3bf`).
### 1f prod2-HW-DEBAKEL (der teure Nebenschauplatz)
- super lint:static crashte auf prod2 (i9-14900KS): cppcheck-from-source-Build cc1plus-Segfault an
  WECHSELNDEN Dateien (mc_valueflow/mc_tokenize/mc_checkother/mc_programmemory), unabhängig von Compiler
  (g++-16-Trunk r16-8100 UND g++-13) und -jN/-O. Beide prod-Runner = experimenteller g++-16-Trunk.
- Manuelle Beweise auf prod2: -j4 crasht, -O1 crasht, g++-13 crasht, -j2 crasht (aber jeder Versuch kam
  KUMULATIV weiter: 90→112→141 von 170). **Wurzel = earlyoom `--prefer cc1plus` killt Compiler bei VM-RAM-
  Druck** (Host-Runner konkurriert mit ~48G VM-Last um ~14G frei). Retry-Schleife-Beweis: Versuch 1 ERFOLG.
- **FIX `6709248`:** g++-13 (stabil statt Trunk) + `-DUSE_BOOST=Off` + -j2 + **4× ninja-Resume-Retry**
  (überlebt Kill; Build einmalig + gecacht). In `project_prod2_hardware_verdict_io_not_cpu` (K-lint-UPDATE) dokumentiert.
### 1g texlive-Infra (thesis-Gate)
- Runner-Klärung: Tag `baremetal` = NUR prod1(16)+prod2(17); pve1 trägt `bare-metal` (SE-21b „pve1"-Annahme war falsch).
- prod1 hatte TL2026 scheme-full (4.6G) — nur chktex-Symlink fehlte → gesetzt. **prod2 leer → LAN-Spiegelung
  prod1→prod2** (zstd-tar-Pipe via Desktop, `tlmgr path add` = offizielle Voll-Symlinks). `COMDARE_TEXLIVE_AVAILABLE=true`
  auf 289+288. **thesis:pdf 193105 = SUCCESS** (§7-Hard-Gate, 0 LaTeX-Fehler). chktex 978 Stilwarnungen → advisory.
### 1h UMSCHALTUNG auf Pflicht + Verifikation
- 6 lint-Verify-Runden (jede deckte ein Problem auf): std.cfg → boost → ODR-Templates → HW-ICE → echte Findings.
- Umschaltung (allow_failure+when:manual RAUS bei lint:format/lint:static; andere allow_failure-Jobs
  [ce Sanitize:90/codegen:234, prt-art:71] unangetastet; YAML 3/3 valide via Windows-python-yaml):
  **cache-engine `1e3b839` · prt-art `7997a0b` · super `5ff9e1f`.**
- Frische Push-Pipelines **7539/7540/7541 → 6/6 lint-Jobs AUTOMATISCH GRÜN** (format+static × 3). #203 completed.
- Literal-Beleg super lint:static 193621: „cppcheck-Tool-Compiler: g++-13" + „Job succeeded".

## PHASE 2 — Runner-Korrektur (User: „-j2 zu streng, prod 8 Kerne concurrency 1")
- RAM-Modell: ≥12G/VM, ~2 belegt → ~10 frei; 1G/Kern → 8 Kerne = 8G sicher bei concurrent=1.
- **prod1 config.toml concurrent 2→1** (Backup `config.toml.bak-20260703-concurrent`; SIGHUP via `kill -HUP <MainPID>`;
  journal „Configuration loaded builds=1 max_builds=1"). prod2 war schon 1.
- **cppcheck -j2→-j8 (`4666192`)** + **super CMAKE_BUILD_PARALLEL_LEVEL 4→8 (`c9a317a`)**.
- Memory `feedback_runner_concurrency_half_cores_concurrency2` revidiert (concurrent=2-Teil für prod ersetzt).
- Runner-Info: prod1(16)=prod,baremetal,amd 32 Kerne 60G; prod2(17)=prod,baremetal,intel 32 Kerne 62G.

## PHASE 3 — /goal (User: „strategisch günstig alle TODOs top-down")
Erst TODO-Überblick top-down gegeben (A #188-Strang · B M3-Gate-Welle AP-1..7 · C P1 AP-8..15 · D Audit-Reste
· E gated/extern). Masterplan `20260702-…-cmd-visitor.md` gelesen: alle E1/E2/E3/F1-Entscheide getroffen, VOLLES GO.

## PHASE 4 — Parallelstrategie + 4 KARTIERUNGEN (User: „max Parallelität disjunkt, GO für alles, warte auf Kartierung")
Vier Kartierungen PARALLEL gestartet (Explore-Agenten + 1 Codex-Gegenprüfung):
### 4a #216-H2 (Explore a29f0654 + Codex bwswokrmn — KONVERGENT)
- Problem: `run_workload_perm` ruft `tier_clear()` nur VOR Load (`perm_runner.hpp:261`); Load-Inserts (`:262`)
  treiben Observer-Stat; Observer-Read am Run-Ende (`workload_orchestrator.hpp:155`) → axis_stats = LOAD+RUN.
  `tier_clear()` löscht auch DATEN → ungeeignet. Doku-Widerspruch `iterator.hpp:177-185`.
- Fix: NEUE daten-erhaltende `tier_reset_statistics()` in abi_adapter.hpp (extrahiert die `.reset()`-Aufrufe
  aus `tier_clear() :902-933` ohne Daten-clears) + Host-Aufruf nach Load. seg_ns n>1 BEREITS aktiv (`:1275`
  kBatches=8). Stale-Kommentare `perm_runner.hpp:12/165/188/191` (search_organ_→container_algorithm_). god-header.
  **Voll-Dossier = SE-22 §4.**
### 4b AP-Disjunktheits-Matrix (Explore a3a0ff1c)
- SERIAL (abi_adapter/POD): #217 (container_algorithm_t), #221 (RC-apply/applied_rc_), #224 (Querschnitt, zuletzt),
  AP-1 (measurement_snapshot POD), AP-7 (nach #217, Registry), AP-8-POD-Teil (T10 hat KEIN p50/95/99).
- PARALLEL (dateidisjunkt): AP-2 (EE-Adapter), AP-3 (platform_probe), AP-6 (algorithm_profiles/sota+allocators),
  AP-10 (dataset_loader), AP-11 (load_profiles/lp_*.xml), AP-13 (Pinning+platform). Nähte: AP-3∥AP-13 (platform/),
  AP-1/2/8 (execution_result.hpp), CMake/CI. **Voll = SE-22 §3.** ⚠️ Pfade korrigiert: real `libs/cache_engine/
  algorithm_profiles/sota` (30) / allocators (10) / load_profiles lp_ (8).
### 4c CMD-1-Ist-Architektur (Explore a4da6baa)
- Andock-Header: execution_engine_base.hpp (IExecutionEngine:98 — F1-Mess-Wurzel abspalten), anatomy_base.hpp,
  idriveable_tier.hpp, observable_tier.hpp, measurable_concept.hpp:60/113 (Mess-Slot), resource_controllable_tier.hpp:56,
  axis_base.hpp:64/78, abi_adapter.hpp (god-header, erbt alle 3 Belange :145/:150/:158), anatomy_execution_context.hpp:116
  (einzige CMD-1-Code-Marke). Subsumieren/stilllegen: i_command.hpp, anatomy_commands/, strategy_command/ (vestigial),
  algorithm_visitor/ (LEER + Audit-Kommentar „kein GoF-Visitor"). Behalten: WorkloadOp-switch (:75-152), MeasurableComponent.
  RuntimeMeasureVisitor = kein Visitor (umbenennen). modules/comdare-* = ZWEITE KOPIE aller Header (TABU). **Voll = SE-22 §5.**
### 4d Strategie festgelegt
Zwei-Spuren + Worktree-Git-Isolation. Spur S (seriell god-header) + Spur P (parallel disjunkt). Details PHASE 6.

## PHASE 5 — GROSSES GO (User: „großes GO für alle Aufgaben")
MASTER-EXECUTION-PLAN geschrieben + committet (**`6bd92f7`**): Spur S (#216-H2→#217→AP-7→#221→CMD-1[5 Teil-Inc]
→CMD-2+AP-1+AP-8-POD→#234→#215→#224) + Spur P (P-A: AP-2/3/13/8-Vendoring; P-B: AP-6/10/11; P-C: Rest) +
Verify-/Merge-Protokoll (Worktree→Dossier→Codex→Review→commit→merge→Pipeline→Bump).

## PHASE 6 — Ausführung gestartet + WORKTREE-DEBAKEL
- Worktree `wt-216h2` im FLÜCHTIGEN Scratchpad angelegt; #216-H2-Dossier; Codex (bx2epn7kc, workspace-write,
  „kein git") gestartet.
- 🔴 Codex HATTE #216-H2 fertig implementiert (5 Dateien +48/−23: perm_runner.hpp + tests/unit/CMakeLists.txt +
  abi_adapter.hpp mit `occupied_count()` + …), aber committete nicht.
- 🛑 Mein `git worktree remove --force` LÖSCHTE die uncommitteten Dateien → **VERLOREN**. main UNBERÜHRT (`1e3b839`).
- Lektion (SE-22b §C, bindend): Worktrees an `/c/Users/benja/comdare-wt/<task>` (persistent, angelegt); Codex
  MUSS im Worktree committen (Branch=Sicherung); NIE remove --force auf uncommitted.

## PHASE 7 — Übergaben geschrieben (alle super, beide Remotes)
- **SE-22** `c746f2b` (lint-DONE + Strategie + 4 Kartierungen §3/§4/§5 + Fallstricke + Direktiven + TODO-Liste).
- **MASTER-EXECUTION-PLAN** `6bd92f7` (GO-Gesamtumfang).
- **SE-22b** `4fb5d6c` (GO-Status + Worktree-Lektion + #216-H2-neu + START-Befehl).
- Memory `feedback_command_pattern_achsen_mess_visitor_container_in_sa` (⚡⚡ lint-DONE, 🧭🧭 Strategie, ✅✅ GO+Worktree)
  + `project_prod2_hardware_verdict_io_not_cpu` (K-lint) + `feedback_runner_concurrency_half_cores_concurrency2` (revidiert).

## ALLE COMMITS DIESER SESSION
**ci-templates@development:** 0595811 · 237b6ec · 09f3bae · bcc690b · 6709248 · 4666192 (+ Vorsession 968b333/5ddfd4a).
**cache-engine main:** c4ad45e · d73ffef · 18de252 · 1e3b839 (lint-Pflicht).
**prt-art main:** 96212c5 · 55ce94c · 7997a0b.
**super main:** cc05146 · b7500d4 · 7a3f449 · d397691 · e64e995 · 753d3bf · e5ef645 · 29fdf27 · 5ff9e1f · c9a317a
· c746f2b(SE-22) · 6bd92f7(Master) · 4fb5d6c(SE-22b) · +diese Full-Copy.
**Pipelines-Belege:** lint 6/6 grün (7539/7540/7541); thesis:pdf 193105; super static 193621 (g++-13).

## NÄCHSTE SESSION — START (SE-22b §D)
1. Memory + MASTER-EXECUTION-PLAN + SE-22 §3/§4/§5 lesen (Kartierungen NICHT neu machen).
2. Worktree-Reste prüfen (`git worktree prune`; `branch --list 'wt-*'`).
3. Welle 1: **S1 #216-H2** (persistenter Worktree `/c/Users/benja/comdare-wt/216h2`, Codex-commit-im-Worktree,
   aus SE-22-§4-Dossier; `occupied_count()`-Hinweis) PARALLEL zu **P-A** (AP-2/AP-3/AP-13/AP-8-Vendoring, je Worktree).
4. Dann S2 #217 → S3 AP-7 → S4 #221 → CMD-1-0…iv. Merges sequenziell, je Pipeline-Beleg + Submodul-Bump.
**Direktive (neu, User 03.07.): REGELMÄSSIG commit + push** (nicht nur am Session-Ende).
