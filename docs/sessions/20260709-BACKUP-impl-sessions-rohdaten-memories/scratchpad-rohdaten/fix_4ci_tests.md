# NACHFIX #188-4c-i-T — 5 Tests an die honest-0-/Routing-Semantik seit 4c-i anpassen (Repo comdare-cache-engine)

**workspace-write. Der uncommittete 4c-i-Diff (Weiche/Trait/Gate-Flip) ist KORREKT und TABU — NICHT anfassen:**
libs/** komplett tabu, ebenso tests/unit/test_188_4c0_known_compositions_conformance.cpp, tests/unit/CMakeLists.txt,
.gitlab-ci.yml, modules/**, ext/**, golden, Registry. NUR die unten genannten 5 Test-Dateien ändern. Kein git.

## Kontext
Seit #188-4c-i sind Reference-/PaperBinding-Kompositionen (search_algo = ObservableComposedContainer<XOrgan>,
z. B. ArtComposition/HotComposition) container_-authoritativ: container_t = die Hülle selbst, KEIN
LayoutAwareChunkedStore-Spiegel mehr. Folge: `container_is_store_backed_ == false` → T4/T5/T6 (node/layout/
allocator), T7-prefetch-descent und die store_observe_*-Achsen (T11/T12/T13… soweit store-gescannt) sind für
diese Kompositionen HONEST-0 (etablierte Konvention wie bei den Pool-Familien seit #188-4b-b; real erst mit den
observe-Hooks aus #188-4b-c/#234). Store-traversierbare Kompositionen (LinearScan/Interpolation/k-ary) und die
markerlose Flachgruppe (Array256/Vector*/Array65535, AdHoc) tragen WEITER einen echten Store — dort leben die
Echtheits-Beweise unverändert.

5 Tests asserten noch die ALTE Spiegel-Semantik (Stats>0 für Hüllen-Kompositionen, bezogen aus dem eliminierten
Spiegel = Apparat-Artefakt, Doc 34 §9). Sie sind semantisch nachzuziehen — **Beweis-Absicht ERHALTEN**:

## Fix-Prinzip (bindend)
(P1) Wo ein Test die ECHTHEIT einer Achse beweist (T6-allocator real, T7-prefetch real, …): den Beweis auf eine
     Komposition umziehen, die weiterhin store-backed ist — bevorzugt eine im selben Test-File schon verwendete
     store-traversierbare/AdHoc-Flach-Komposition; sonst minimal eine geeignete bestehende Komposition inkludieren
     (KEINE neue Komposition erfinden; nichts an libs/ ändern).
(P2) Für die Hüllen-Komposition zusätzlich/ersatzweise EXPLIZIT honest-0 asserten (EXPECT_EQ(...,0u)) mit
     Kommentar `#188-4c-i: Huellen-Komposition container_-authoritativ -> store-Achsen honest-0 (bis observe-Hooks #234)`.
     honest-0-Asserts NUR für Hüllen — Asserts für Nicht-Hüllen-Kompositionen NICHT lockern.
(P3) Minimal-invasiv: keine Test-Fälle löschen, keine Umbenennungs-Orgien; Kommentar-Stil der Datei übernehmen.

## Die 5 Dateien (Befunde des adversarischen Reviews, Zeilen am HEAD+Diff verifiziert)
1. tests/unit/test_v41_anatomy_f15_measurement.cpp:303-304 — `EXPECT_GT(snap.axis_stats[6][0/2], 0u)` auf
   ArtComposition-Anatomie (:323 u. a.). R6-Inkrement-2b-Beweis (allocator über ABI-Grenze) per (P1) auf eine
   store-backed Komposition; für Art per (P2) honest-0. Prüfe die GANZE Datei auf weitere store-Achsen-Asserts
   für Hüllen-Kompositionen (gleiches Muster).
2. tests/unit/test_prefetch_real.cpp:219-223 (+ drive_tier_and_observe-Komposition) — Hot-Komposition erwartet
   axis_stats[7][5/6/7] > 0. T7-Echtheits-Beweis per (P1) umziehen; Hülle per (P2). Standalone-main-Stil (tr()).
3. tests/unit/test_prefetch_adversarial_verify.cpp:146ff — HW/Distance/Path >0 für HotComposition → wie (2).
4. tests/unit/test_seg_coverage.cpp:96ff — behauptet algorithmische T4/T5-seg-Zeit >0 für Reference-Hüllen →
   Erwartung/Coverage-Menge per (P2) anpassen (die Coverage-Aussage für store-backed Kompositionen NICHT schwächen).
5. tests/unit/test_obs_phaseB_pilot.cpp:87ff — erwartet filled_axis_count==19 + T13-T16 row_sum>0 auf
   Reference-Kompositionen. LIES die fill_observer-Mechanik (welche Achsen zählen als filled, unabhängig von
   Werten) und passe NUR das an, was durch honest-0 real kippt; dokumentiere je Assert warum.

## Zusätzlich (EOL-Hygiene, Review-Befund 6)
`git ls-files --eol` meldet Worktree-CRLF für .gitlab-ci.yml + test_188_4c0_known_compositions_conformance.cpp.
Diese beiden Dateien NICHT inhaltlich ändern, aber ihre Zeilenenden im Worktree auf LF normalisieren
(Bytes-only-Rewrite; Inhalt byte-identisch bis auf CRLF→LF). Ebenso für die 5 gefixten Dateien LF sicherstellen.

## Bericht
(a) je Datei: was geändert + warum (P1/P2-Zuordnung); (b) auf welche Komposition je Echtheits-Beweis umgezogen
wurde; (c) verbleibende Risiken; (d) Bestätigung: keine Tabu-Datei berührt, keine Nicht-Hüllen-Asserts gelockert.
Increment-Tag `#188-4c-i-T (2026-07-02)`.
