# FULL-JOIN-ENDPROBE MERGES 6-10 + ENDSTAND -- PRUEFER-URTEIL

Pruefer: Endstand-Pruefer (Beobachter-Rolle, read-only; Lead-Order K31 23.08. abends).
Erhoben: 2026-08-23 20:07-20:09 UTC am ce-Hauptklon. Methode K18: jede Zahl selbst am
Objekt gemessen; Rezept = K29-Uebergabe Abschn. 3 (a)-(d). ASCII-only.
Rohdaten: probe-a-ours-theirs.txt / probe-b-diffstat.txt / probe-c-leitsymbole.txt /
probe-d-ctestN-live.txt (dieses Verzeichnis).

## GEGENSTAND

Endstand zum Messzeitpunkt: HEAD == origin/development == github/development ==
**3841d7175086d5141fb28d6a401ae1ab4d137b30**, porcelain 0. CI dazu: Pipeline **16101**
@ 3841d717 = **success** (started 14:02:03Z, finished 14:43:46Z, duration 2503 s;
27 Jobs = 26 success + 1 manual is_original:relock; API-Kopien in
~/backups-workflow/20260822-lande-zug/Z10/endstand-beweis/ci16101-*.json).
Job-Tafel ist deckungsgleich mit dem 16097-Soll; namentlich gruen: lint:static 383137,
test:unit 383145, test:unit:debug 383146, test:unit:clang 383147, test:unit:clang:debug
383148 -- beide 16095-Rotstellen bleiben geheilt, beide Compiler gedeckt.

Merges 6-10 (Zaehlung des Zugs): 6/10 vollzug91 85a67b08 (Strang-Tip 6713156b),
7/10 ph89 a58f77b5 (2809e4d4), 8/10 trigfix f7b64039 (0f900dcf), 9/10 skip97 cf524bd1
(1c9f58a5), 10/10 kampvor b4c593f5 (1e1bc199). Gemeinsame Merge-Basis aller fuenf: 66de5c09.

## (a) OURS/THEIRS-DETEKTION -- 5/5 SAUBER, KEIN VERWERF-MERGE

Fuer jeden Merge M: tree(M) gegen tree(P1), tree(P2) und gegen
`git merge-tree --write-tree P1 P2` gehalten.

| Merge | tree==P1 (ours)? | tree==P2 (theirs)? | auto-merge clean? | tree(M)==auto? |
|---|---|---|---|---|
| 85a67b08 vollzug91 | NEIN | NEIN | NEIN (Konflikt) | NEIN (manuelle Aufloesung) |
| a58f77b5 ph89 | NEIN | NEIN | NEIN (Konflikt) | NEIN (manuelle Aufloesung) |
| f7b64039 trigfix | NEIN | NEIN | NEIN (Konflikt) | NEIN (manuelle Aufloesung) |
| cf524bd1 skip97 | NEIN | NEIN | NEIN (Konflikt) | NEIN (manuelle Aufloesung) |
| b4c593f5 kampvor | NEIN | NEIN | JA | **JA -- byte-exakt die automatische Vereinigung** |

Die manuellen Aufloesungen sind ATTRIBUIERT: bei ALLEN vier Konflikt-Merges nennt
merge-tree als einzige Konfliktdatei **tests/unit/CMakeLists.txt** -- exakt die
dokumentierte H-9-Zaehlwerk-Union (Z05 "1 H-9-Union", Z07 "Zaehlwerk 263", Z08
"8158+50=8208"; bei ph89 dazu Auto-Merge von profile_run_facade.cpp, konfliktfrei).
kampvor bestaetigt die Z09-Behauptung "merge-tree KONFLIKTFREI, Tree byte-exakt
Vorhersage" am Objekt.

## (b) MERGE-DIFFSTAT GEGEN STRANG-DIFFSTAT -- 5/5 EXAKT, KEIN SCHRUMPF

`git diff M^1..M` (was der Merge in den Zielzweig brachte) gegen
`git diff merge-base..Strang-Tip` (was der Strang hatte):

| Merge | Merge bringt | Strang hatte | Urteil |
|---|---|---|---|
| 85a67b08 | 10 Dateien, +914/-0 | 10 Dateien, +914/-0 | IDENTISCH |
| a58f77b5 | 42 Dateien, +2246/-12 | 42 Dateien, +2246/-12 | IDENTISCH |
| f7b64039 | 5 Dateien, +687/-2 | 5 Dateien, +687/-2 | IDENTISCH |
| cf524bd1 | 7 Dateien, +811/-1 | 7 Dateien, +811/-1 | IDENTISCH |
| b4c593f5 | 2 Dateien, +166/-1 | 2 Dateien, +166/-1 | IDENTISCH |

Kein 0-Datei-Merge, kein Schrumpf -- Datei-Zahl, Insertions und Deletions sind je Merge
DECKUNGSGLEICH mit dem Strang. (Die Ziel-Tafel der ZUG-BILANZ nennt fuer Z06 "42 Dateien
+2246/-12" identisch; ihre Z05-Zeile "+914/-0" identisch.)

ERGAENZEND, INHALTS-EBENE (bereits 14:0x gefahren, ZUG-BILANZ Abschn. 8a): alle 3770
Strang-Zusatzzeilen (>=12 Zeichen) der 66 Strang-Dateien am Endstand nachgewiesen;
4 Abweichungen, alle vier namentlich attribuiert und gewollt (a84f1119 npos-Haertung,
db66714a NSDMI-{}, 2x ed79090c F-14-Breiten-Heilung). Kein unerklaerter Verlust.

## (c) LEITSYMBOL-GREPS AM ENDSTAND -- ALLE FUENF STRAENGE PRAESENT

git grep ueber getrackte Dateien (NIE `grep -v /build` -- die Falle frisst /builder/):

| Leitsymbol (Lead-Liste) | Treffer/Dateien | Kern-Fundort |
|---|---|---|
| pmc_raw_event_katalog | 14/7 | include/cache_engine/measurement/pmc_raw_event_katalog.hpp + tests/unit/test_pmc_raw_event_katalog.cpp |
| paper_pruefling_registry | 43/39 | u.a. algorithm_profiles/paper_experiments/*.experiment.xml (ph89) |
| e07_gate_kriterien | 10/4 | libs/cache_engine/profile_facade/e07_gate_kriterien.hpp + Test + Floor-Anker + CMakeLists (trigfix) |
| test_c13_selektiver_rebuild | 10/3 | Test + CMakeLists + Floor-Anker (skip97) |
| test_c14_lager_presence_wache | 13/5 | inkl. Produktiv-Naht lager_presence.hpp |
| test_c14_messwert_presence_wache | 8/4 | inkl. Produktiv-Naht messwert_registrierung.hpp (S97-F1: MesswertRunState::lager_contains Z.134) |
| PinPflichtDeklarationR15ImMessBatch (kampvor) | 1/1 | tests/unit/thesis_tiere/test_experiment_plan_director.cpp |
| window_belongs_to (kampvor) | 21/4 | batch_planner.hpp + experiment_plan_director.hpp + 2 Tests |

Dazu (ZUG-BILANZ 8c): 69 neue TEST()-Faelle der Merges 6-10 mechanisch aus den
Strang-Diffs gezogen, 0 fehlen am Endstand.

## (d) ctest-N-ZAEHLUNG -- EINMAL LIVE, KEIN DELTA-ADDIEREN

Ein einziger Lauf `ctest --test-dir build-l1 -N` am Endstand-konfigurierten Baum
(build-l1 = r4-gcc-Release @ 3841d717; Host-Klasse aus DEMSELBEN Baum belegt:
CMakeCache COMDARE_HOST_RUNS_AVX2:INTERNAL=1 + COMDARE_HOST_RUNS_AVX512F:INTERNAL=1):

    Total Tests: 544        (Gegenzaehlung grep '^  Test #' = 544)

gegen den Anker scripts/ci_test_inventory_floor.txt Z.792 `avx512f 544`:
**544 == 544 EXAKT.** (Union-Kontrolle aus den gesicherten Namenslisten, ZUG-BILANZ 8b:
UNION(avx512f,avx2,basis) = 544 = avx512f; strenge Schachtelung 538 in 540 in 544.)

## GESAMTURTEIL

**FULL-JOIN BESTANDEN, 5/5 Merges, Endstand konsistent.** Kein ours/theirs-Verwurf,
kein Schrumpf-Merge, alle manuellen Konflikt-Aufloesungen liegen ausschliesslich in der
dokumentierten Zaehlwerk-Datei, alle Leitsymbole der fuenf Straenge stehen am Endstand,
der live enumerierte ctest-Nenner trifft den Anker exakt, und CI 16101 ist am selben
SHA terminal gruen (26 success + 1 manual). Die Schlussstrecke (1f51eb3d Riegel-cherry +
3841d717 Verschaerfung) hat den Nenner nicht bewegt und keine Strang-Substanz beruehrt.

Bekannte, DOKUMENTIERTE Restpunkte (kein Full-Join-Mangel): die r4-Zellen-Logs tragen
die ctest-Bilanzzeile nicht (Nenner ueber gerettete LastTest.log-Kopien fuer 3 von 4
Zellen literal geschlossen, gcc-dbg per Laufzeit-Indiz + rc=0; ZUG-BILANZ 8e) und die
gcc-dbg-LastTest-Kopie wurde vom Test-509-3x-Lauf ueberschrieben (8f).
