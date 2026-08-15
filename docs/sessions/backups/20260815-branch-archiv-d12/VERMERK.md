# BRANCH-ARCHIV D12 -- 5 ce-origin-Branches (Task #50, GO 14.08. mit Archiv-Auflage)

Datum: 2026-08-15 (Strang D, D12)
Repo: comdare-cache-engine (ce), gemessen gegen origin/development = 04f76b65bf6c29d2844fdedd80efa2b34f17968d
GO: Owner 14.08. (#50) -- ERNEUTE Wert-Pruefung je Branch, Inhalt ins Archiv (Bundle + Vermerk),
DANN Remote-Loeschung origin. GitHub-Seite gemessen: KEINER der 5 Branches existiert dort
(git ls-remote --heads github: 21 heads, 0 exakte Namenstreffer -- nichts zu loeschen).

## Form der Bundles

Duenne Bundles: je Branch genau die Commits, die origin/development (04f76b65) NICHT enthaelt
(`git bundle create <f> ^04f76b65 refs/remotes/origin/<branch>`). Alle Voraussetzungs-Commits
(prerequisites) sind per `git merge-base --is-ancestor <p> 04f76b65` als Vorfahren von
development belegt (5/5 rc=0) -- Wiederherstellung gelingt aus jedem Klon, der development
traegt: `git fetch <bundle> 'refs/remotes/origin/*:refs/heads/restored/*'`.
Integritaet: SHA256SUMS in diesem Verzeichnis, `sha256sum -c` rc=0 (5x OK).
`git bundle verify` je Datei rc=0.

## Urteile (dreiwertig: ENTHALTEN / NICHT-ENTHALTEN+WIEDERVERWENDBAR / NICHT-ENTHALTEN+TEIL-UEBERHOLT)

### 1. b-m2-pmc-invariante @ 90bca126 -- ENTHALTEN
2 einzigartige Commits (rev-list --count 04f76b65..tip = 2), Fork-Punkt 6ddd7fd4.
- 4fd42896 "M-2/P-PMC-1: PMC-Pflicht als INVARIANTE ..." ist patch-aequivalent (patch-id
  6f1c4dbf, git cherry "-") zu dev-Commit 8894d983 (gleicher Betreff) -- gelandet.
- Merge-Tip 90bca126 traegt 18 merge-eigene Zeilen in cmake/catalog_codegen.cmake
  (racy Codegen-Datei -> generated/limits): ALLE 18 Zeilen woertlich in
  04f76b65:cmake/catalog_codegen.cmake vorhanden (missing-count=0).
Kein Stand, der development fehlt. Loeschung verlustfrei; Bundle nur wegen Archiv-Auflage.

### 2. b-m3v2-pmc-window @ 81651f6e -- ENTHALTEN
1 einzigartiger Commit "fix(pmc): m3v2_pmc_smoke misst jetzt ein echtes Fenster ...",
patch-aequivalent (patch-id d3c6d1f8, git cherry "-") zu dev-Commit 2b5ecd29 (gleicher
Betreff). Fork-Punkt 22e17f57 liegt auf development. Loeschung verlustfrei.

### 3. b-pmc-errno-diag @ 3f0d989d -- ENTHALTEN
1 einzigartiger Commit "diag(pmc): errno-Sichtbarkeit bei perf_event_open-Fehlschlag",
patch-aequivalent (patch-id 7a5ca2ab, git cherry "-") zu dev-Commit 22e17f57 (gleicher
Betreff). Loeschung verlustfrei.

### 4. bau/p2-warnstufe-aufteilen @ 237d0952 -- NICHT ENTHALTEN + WIEDERVERWENDBAR
1 einzigartiger Commit (Fork 95cb3039, 10.08.), git cherry "+" (kein Patch-Aequivalent in dev).
Am Objekt gemessen NICHT in development:
- COMDARE_set_default_optimization: 0 Treffer in 04f76b65 (git grep rc=1);
  Gegenprobe: die UNGETEILTE COMDARE_set_default_warnings existiert weiter
  (compiler_flags.cmake + gtest_setup.cmake, je 1 Treffer) -- der Split ist NICHT gelandet,
  d.h. die Warn-Funktion setzt in dev weiterhin auch die Optimierungsstufe (-O0/-O3/-O2,
  target_compile_options PRIVATE nach CMAKE_CXX_FLAGS_<CONFIG>) -- das im Commit belegte
  Zustaendigkeits-Problem einer Laufzeit-messenden Arbeit besteht fort.
- op_kind_name-Deklaration fehlt in 04f76b65:tools/ycsb_cli/ycsb_cli.hpp (grep rc=1;
  Datei existiert, cat-file -e rc=0).
Wiederverwendbar: Anliegen gueltig, Methode dokumentiert (Flag-Multiset-Vergleich je TU aus
compile_commands.json, 2x593 TUs, 0 abweichend). Direkter Merge wird nach der dev-Evolution
seit 95cb3039 Konflikte tragen -- Re-Anwendung als Patch-Vorlage aus diesem Bundle.

### 5. bau/p3-ci-clang-pflicht @ 708cf156 -- NICHT ENTHALTEN + TEIL-UEBERHOLT
1 einzigartiger Commit (Fork 95cb3039, 10.08.), git cherry "+".
- tests/unit/test_ci_invarianten.cpp (933 Z., Invarianten I1-I5 als Google Test): existiert
  in 04f76b65 NICHT (ls-tree 0 Treffer) -- WIEDERVERWENDBARES Material; deckt sich mit dem
  geplanten S-12-Posten (CompilerPin-Invarianten E1-E5, bau/ci-dual-emission, Task #3).
- needs-Fix fuer build:clang: in dev NICHT enthalten (build:clang in 04f76b65:.gitlab-ci.yml
  hat weiterhin KEIN needs:, nur rules "- when: on_success"), aber die Architektur wurde
  durch die CI-DUAL-Landung 14.08. veraendert (Writer-Wechsel: test:unit:clang faehrt die
  Voll-Suite; 2 Treffer test:unit:clang in dev-CI) -- der konkrete needs-Patch ist damit
  TEIL-UEBERHOLT und nicht 1:1 anwendbar; die Invarianten-Idee I3 (needs-Paritaet clang==gcc)
  bleibt als Pruefgedanke offen und wandert sinnvoll in S-12/#3.

## Konsequenz

Alle 5 Branches sind archiviert (Bundle + SHA256SUMS + dieser Vermerk). Remote-Loeschung
origin je Branch einzeln gemaess GO #50; GitHub traegt keinen der Branches (gemessen, s.o.).
Die LOKALEN Branches/Worktrees im ce-Store bleiben unberuehrt (ce-Stores READ; Triage der
lokalen Branches ist Task #31, nicht D12).
