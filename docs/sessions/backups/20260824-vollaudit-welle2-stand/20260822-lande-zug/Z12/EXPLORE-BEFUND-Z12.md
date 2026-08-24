# Z12 EXPLORE-BEFUND (3 Achsen, VOR dem Eingriff) — 23.08.2026

ZIEL: E-7 — ce bau/o2-standard @ fa48a551 --no-ff in development (ce-Hauptklon).
Auftrag: Briefing Z12 des Lande-Zugs; Inventur L11; #117 (O2 Default, O3 unter
Warnung erhalten), #121-O2-Konflikt-Check (O3 darf NICHT entfallen).

## 1. STRUKTURELL

- Merge-Base: ed9f1a3c (W1L-CI-16069-Heilung). development (3841d717, CI 16101
  SUCCESS, origin==github==lokal) ist 37 Commits voraus.
- Strang-Umfang: 15 Dateien, +190/-31 (git diff ed9f1a3c..fa48a551 --stat).
- git merge-tree --write-tree development bau/o2-standard: GENAU ZWEI Konflikte:
  1. scripts/ci_test_inventory_floor.txt — ZAEHLWERK. o2-Seite bumpt 523/519/517
     -> 524/520/518 (Strang-Messung 22.08., +1 test_o2_standard_opt_default);
     dev-Seite steht auf 544/540/538 (W2-Nachzug 1f0424a2). Aufloesung nach
     A2.1b + Praezedenz 1f0424a2/b02b7523: Merge loest auf DEV-Stand (544) auf,
     der Strang-Block-TEXT wird NICHT woertlich getragen (seine 524er-Aussage
     galt nur der Strang-Welt); das KONTO (test_o2_standard_opt_default,
     unbedingt, oberste Ebene, kein ISA-Gate, kein Opt-in-Label, +1 je Sprosse)
     wandert in einen NEUEN Merge-Stand-NACHZUG-Block; Werte EINMAL LIVE am
     Merge-Stand gemessen (Erwartung 545/541/539), separater Anker-Commit im
     SELBEN Push (Muster 1f0424a2).
  2. tests/unit/CMakeLists.txt — bekannte Dateiende-Harmonisierungs-Flaeche:
     dev-Ende = C-13/C-14-Bloecke (skip97), o2-Block (comdare_add_test
     test_o2_standard_opt_default) dahinter VOLL anfuegen, Trenner dazwischen
     (Muster 881d1a15/61d5d139). o2-KONTO-Aussage "am CMakeLists-DATEIENDE"
     bleibt damit wahr.
- 8 Auto-Merge-Dateien gesichtet: profile_run_entry/facade, validate_profile,
  experiment_run_entry, experiment_plan_director, build_orchestrator,
  thesis_tiere-Parser-Tests. KEINE semantische Kollision: dev-seitig (base..dev)
  0 neue Treffer auf DefaultOptLevelOption / rohe "O3"-Literale (unified=0-grep).
- Timing-Empfindlichkeit geprueft: test_all19_segment_timer traegt EXPLIZITES
  per-Target-Flag comdare_apply_optimization_level_flags(... O3) — vom
  Release-Default entkoppelt; c3a/c3b uebergeben "-O3" explizit als Achsen-WERT.
  Alle drei Dateien existierten an der Merge-Base und liefen im o2-eigenen
  524/524-Gruen unter -O2-Release.
- TABU-Flaechen: KEINE beruehrt (kein golden_fullpilot_320*, permutation_axes.xml,
  m3v2_study.profile.xml, Registry-XML, CRC-Anker; planner_thesis_min.profile.xml
  = NUR XML-Kommentar-Text, nicht in der TABU-Liste).

## 2. DESIGN

- Owner-Entscheid 21.08.2026 (Primaerquelle Thesis-Kommentar 728fc74): "O2 ist
  Standard fuer alle Builds, O3 wird unter Warnung angeboten. Maximale
  Optimierung muss waehlbar bleiben."
- Umsetzung auf BEIDEN Flaechen:
  a) Haus-Bauwelt cmake/compiler_flags.cmake: Release-Default -O2; Opt-in
     COMDARE_OPT_O3=ON mit lauter Configure-WARNING (4 Konsequenzen benannt:
     Fingerprint-Glied [5] '+opt=', Codegroesse/Laufzeit, binary_id/golden-320
     unberuehrt, MSVC bleibt /O2). Aufloesung nie leer (kein stilles -O0).
  b) CEB-XML-Achse optimization_level_sub_axis.hpp: DefaultOptLevelOption =
     OptO2Option (war OptO3Option); O3/Ofast bleiben waehlbare Achsen-Werte;
     static_asserts nachgezogen; UEBERHOLT-Marker AM ORT (Doku-Doktrin, nichts
     geloescht). Single-Source-Heilung: rohes "O3"-Literal in
     profile_run_entry.hpp durch DefaultOptLevelOption::opt_level_id() ersetzt.
- O3-WAEHLBARKEIT ERHALTEN (E-7/#91, #121): Test GegeneingangO3BleibtWaehlbar
  (Teil von test_o2_standard_opt_default) + O3-Opt-in-Probe
  o3probe-configure.log (WARNING feuert, "Release-Optimierung: -O3").
- TDD-Beweiskette ~/backups-workflow/20260822-o2std-beweise/ (22.08.):
  rot (t1-rot-lauf, rot-all) -> gruen 524/524 (gruen-ctest-voll) ->
  Mutationsprobe a (Alias O1: static_assert beisst zur COMPILE-Zeit) ->
  Mutationsprobe b (msvc /O1: Test rot zur LAUFZEIT) -> Wiederherstellung
  gruen (final-nachbau + final-ctest-voll 524/524). Beide Mutanten beissen.
- KEIN Audit-Bericht unter 20260821-w2-audit-fixverify/ (Strang entstand NACH
  der Audit-Runde, 22.08., auf Owner-Entscheid 21.08.); Design-Beleg = die
  o2std-Beweiskette + #117/#121-Inhalte (im Briefing wiedergegeben).

## 3. HISTORISCH

- fa48a551 ist der JUENGSTE und EINZIGE o2-Tip: lokal == origin (ls-remote);
  keine weitere o2-/opt-Branch (git branch -a-Scan). Kein Ueberholt-Marker.
- Commit 22.08. 11:39:40Z durch den Lead ("Lead-Sicherungs-Commit, Agent im
  Limit gestorben; Schreiberwechsel protokolliert") — Schreiberschaft liegt
  seither beim Lead; das Z12-Briefing uebergibt sie diesem Workflow.
  K16: Klaerungs-Anfrage an o2-umbau gesendet (msg 46fef698, 23.08.); Agent
  laeuft nicht (ListAgents), Schreiberwechsel bereits im Sicherungs-Commit
  protokolliert -> nicht blockierend.
- Die finalen Beweise (11:47-11:48Z) entstanden am fa48a551-Stand MIT dem
  Dirty-Delta (Datei-mtime 11:43:11Z zwischen Commit und final-nachbau).

## 4. DIRTY-DELTA-ENTSCHEID (offene Frage 3 des Briefings)

Delta = 19-Zeilen-clang-format-Alignment an profile_facade/profile_run_entry.hpp
(4+/4-, byte-inhaltsgleich formatiert; Sicherung untracked-sicherung/wt-ce-o2std/).
MESSUNG: clang-format-22.1.8 ueber die COMMITTETE Fassung reproduziert das
Dirty EXAKT (diff -q leer) -> Delta ist reine Formathygiene; die committete
Fassung ist NICHT format-clean. CI erzwingt Format (Job lint:format; Gate [2/6]
CLANG-FORMAT in CI-Formel-Paritaet). Format-Wache --nur=format auf dem DIRTY
Baum: GRUEN (rc=0).
=> ENTSCHEID: COMMITTEN (verwerfen wuerde einen format-unsauberen Stand landen
-> Gate 2/6 / lint:format rot). Commit auf bau/o2-standard vor dem Merge;
Merge traegt dann den Format-Tip (Parent fa48a551).

## 5. LANDEFORM

Merge --no-ff in development im HAUPTKLON (kein Worktree-Bau); danach
T-11b-Endstand-Kombibau {gcc,clang}x{Release,Debug} (Rezept kombibau-z10-
endstand.sh: J-1-7er LITERAL, PRUEFLINGE-Var, RECONFIGURE, all, Facade
comdare_profile_run_facade, comdare_tests, ctest --no-tests=error, df-Gate je
Zelle); Floor-Treppe (floor-treppe-z10.sh-Rezept) -> Anker-Nachzug-Commit
545/541/539 (erwartet) im SELBEN Push; Gates 6/6; gitleaks-Koeder glpat-+20
(rc=1) + Echt-Scan (rc=0, commits-scanned == rev-list --count --no-merges);
R4-Pipelines-Lage; Dual-Push origin+github; CI 286 gruen; Beweise nach
~/backups-workflow/20260822-lande-zug/Z12/; danach Raeumung wt-ce-o2std nach
rekursiver Pruef-Doktrin. Restposten-Traeger: GN-9/##47-Kalibrierlauf in
O2-Zielform (entblockt NACH dieser Landung, NICHT Teil dieses Zugs).
