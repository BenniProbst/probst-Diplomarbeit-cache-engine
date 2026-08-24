# URSACHE: CI 16073 test:unit:debug -- 509 test_vl3_debug_stdout_bytegleich (Failed)

Datum: 22.08.2026 · Strang: cifix2 · Stand: ce development @ ed9f1a3c (Arbeitsbaum, KEIN Commit)

## Befund in einem Satz

Die PMC-Host-Probe des Planers (`probe_pmc_host()`, eine echte perf_event_open+Koeder-Erhebung je
Planer-Lauf) lieferte auf dem Intel-CI-Runner unter PMU-Multiplexing lauf-zu-lauf VERSCHIEDENE
Biss-Vektoren, und dieser flatternde Befund stand als `[dump-*] PMC-BEFUND ...`-Zeile und als
`pmc_befund=... events=N/4 ...`-Planzeile auf STDOUT -- der Bytevergleich des Tests (und schon sein
Determinismus-Anker OHNE --debug) brach an genau diesen Bytes.

## Die abweichenden Bytes (literal aus Job 382856, ein und derselbe Job)

Determinismus-Anker (Zeile 115, zwei Laeufe OHNE Flag):
```
-[dump-plan] PMC-BEFUND lage=intel vendor=GenuineIntel events=3/4 biss=[cache_misses_l1=1;cache_misses_l3_ll=1;dtlb_misses=0;branch_misses=1] ...
+[dump-plan] PMC-BEFUND lage=intel vendor=GenuineIntel events=4/4 biss=[cache_misses_l1=1;cache_misses_l3_ll=1;dtlb_misses=1;branch_misses=1] ...
-pmc_befund=intel events=3/4 erhoben=1
+pmc_befund=intel events=4/4 erhoben=1
```
PlanDump mit/ohne --debug (Zeile 104): drittes Muster `events=2/4` mit `cache_misses_l3_ll=0`.
Drei verschiedene Vektoren in EINEM Job; alle uebrigen Plan-Zeilen byte-identisch (Nenner 1828 == 1828).
Das --debug-Flag selbst war NIE die Ursache (der [debug]-Vermerk liegt auf stderr; die Paare brachen
an der PMC-Zeile, die in beiden Laeufen jedes Paars unabhaengig neu erhoben wurde).

## Mechanik

`RealePmcHostStrategie::event_beisst()` (pmc_host_probe.hpp) oeffnete EIN Event, fuhr EIN kurzes
Koeder-Fenster (~ms) und las den nackten Zaehlerwert. Bekommt das Event im Fenster keine PMU-Zeit
(Multiplexing-Verdraengung durch fremde perf-Nutzer -- in der CI-Zelle die parallelen ctest-Nachbarn),
liest read() exakt 0, obwohl das Event auf dem Host funktioniert => biss=0 in DIESEM Lauf, biss=1 im
naechsten. Der Probe-Kopf verlangt woertlich "die Kette muss REPRODUZIERBAR beissen" -- verletzt.

Repro-Grenze lokal (LAUT deklariert): prod1 ist AMD Zen 5 (6 Counter/Thread, l3_ll strukturell
ENOENT); 141 lokale Laeufe (seriell, Kern-gepinnt, mit perf-stat-Kontention) blieben byte-stabil
`events=3/4`. Das Flattern ist auf dieser Hardware nicht kippbar -- der Beweis des Nichtdeterminismus
ist der CI-Trace selbst (drei Vektoren in einem Job, Kopie liegt bei).

## Warum die Debug-Zelle traf

Kein Debug-Spezifikum: Die Probe ist bauform-unabhaengig; Release-Zellen wuerfelten bisher konsistente
Fenster (aktenkundige PMC-Flakes 15810/15814 = dieselbe Klasse). Der Test kam mit W1L (B04); die lokale
W1L-Debug-Pruefung fuhr nur die 12er-Auswahl ohne ihn (Vollbau-Luecken-Klasse), CI-Debug fuhr ihn zuerst.

## Fix (sauberste Loesung, Ursache im Produkt; Test UNVERAENDERT)

1. `pmc_host_probe.hpp` -- `event_beisst()` misst die Gueltigkeit des Fensters mit
   (`read_format = PERF_FORMAT_TOTAL_TIME_ENABLED|TOTAL_TIME_RUNNING`):
   `zeit_gelaufen==0` => Fenster leer, KEINE Messung => naechstes Koeder-Fenster (Deckel
   kKoederFenster=5); `zeit_gelaufen>0` => gemessen: wert>0 Biss, wert==0 ehrliche Absage.
   Nach Deckel fail-closed. Erfuellt das eigene K13-SOLL unter Multiplexing; Fake-Strategien
   und Signatur unveraendert.
2. `profile_run_facade.cpp` (construct_plan_into) -- der `[what] PMC-BEFUND ...`-LOG-Vermerk wandert
   von `os` (Datenkanal; bei allen acht Fassaden das ARTEFAKT, ein `plan ci > child.yml` bekaeme eine
   Nicht-YAML-Erstzeile) nach std::cerr -- dieselbe clig.dev-Trennung wie beim [debug]-Vermerk.
   Die Emission behaelt ihre Befund-Aussage voll: `pmc_befund=`-Planzeile (deklarierte Owner-Ausnahme,
   Format unveraendert inkl. events=N/4) und `# PMC-BEFUND ...`-YAML-Kommentar (T-2/V-1).

KEINE Test-Aufweichung, KEIN Skip, KEINE golden-/axes-/topics-/heuristik-Beruehrung.
