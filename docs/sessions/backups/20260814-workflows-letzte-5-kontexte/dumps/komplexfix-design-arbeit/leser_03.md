# LESER 3 von 12 -- Extraktion Regressions-Gesamtbild (Batch i%12==2)

Quellverzeichnis: /home/comdare/.claude/jobs/5a19728e/tmp/regressions-gesamtbild/
Batch-Dateiliste (Groesse in Bytes, Reihenfolge = Index in gb_dateiliste.json):

| Index | Datei | Groesse |
|---|---|---|
| 2 | wmf14wrxt.json | 317301 |
| 14 | wmphtm0ki.json | 140565 |
| 26 | wisfvjd8z.json | 105971 |
| 38 | wykmftn98.json | 86135 |
| 50 | w8v4vkn3p.json | 66245 |
| 62 | w56km2g9g.json | 45923 |
| 74 | w4m1xz6m1.json | 35750 |
| 86 | w41d6x1yq.json | 29700 |
| 98 | wn7jy2yah.json | 23179 |
| 110 | w72yytmwm.json | 18305 |
| 122 | wtpunni0p.json | 13068 |
| 134 | w4ffuvkx9.json | 9130 |
| 146 | wc2xbd4ay.json | 4838 |

13 von 13 Dateien. Extraktion je Fund im Format GEGENSTAND/ORT/SOLL-FIX/STATUS/ABHAENGIGKEIT.
Hinweis: Nicht-ASCII-Zeichen aus den Quellen wurden bei VERBATIM-Zitaten in ASCII
transliteriert (ue/oe/ae/ss, -> fuer Pfeile); Wortlaut sonst unveraendert.

## Datei wc2xbd4ay.json (Codex-Zweitlens B14/KF-6, b14-golden-kf6: 71617a1b+6558c4ae+d8073913, wt-b14-golden)

### [wc2xbd4ay.json] 1
GEGENSTAND: Codex HOCH: N=2^17 ist in experiment_golden_kern.xml nicht kodiert; template mode="full" ohne Verweis auf all_axes_golden; CI-Trigger zeigt weiter direkt auf all_axes_golden.profile.xml; 524288 weder deklarativ noch operativ herleitbar; zudem sind allowed_variants "binary_search linear_search" (Zeile 156) keine Namen der gepinnten CE-Registry.
ORT: /home/comdare/wt-b14-golden/Code/test_data_xml/experiment_golden_kern.xml:185 + .gitlab-ci.yml:1152 | Branch b14-golden-kf6
SOLL/FIX: N maschinenlesbar kodieren, Registry-kanonische Pins.
STATUS LT. QUELLE: offen (zum Zeitpunkt dieses Reviews); lt. wtpunni0p.json spaeter behoben@953ce412 (siehe dort)
ABHAENGIGKEIT/FLAECHE: B14/KF-6-Strang; Nachbesserung 953ce412 (wtpunni0p)

### [wc2xbd4ay.json] 2
GEGENSTAND: Codex HOCH: fixture_schema_subset_check.cmake hat keine Nichtleer-/Wohlgeformtheitspruefung fuer Instanzen; leere/abgeschnittene XML wird an Zeile 163 als OK gemeldet -- stumm-gruener Wachverlust.
ORT: /home/comdare/wt-b14-golden/Code/tests/fixture_schema_subset_check.cmake:138
SOLL/FIX: Nichtleer-/Wohlgeformtheitspruefung ergaenzen, hart ROT statt stumm-gruen.
STATUS LT. QUELLE: offen (Review); lt. wtpunni0p behoben@953ce412
ABHAENGIGKEIT/FLAECHE: B14/KF-6

### [wc2xbd4ay.json] 3
GEGENSTAND: Codex MITTEL: 4 x 2^17 = 524288 sind nur Organ-/Cacheline-binary_ids; Systemblock multipliziert zusaetzlich mit 2x2x1=4 (Zeile 241) => nach zukuenftigem Konsum 4 x 4 x 2^17 = 2.097.152 System-Bauvarianten; F-3 traegt danach korrekt nur Faktor 1 bei.
ORT: /home/comdare/wt-b14-golden/Code/test_data_xml/experiment_golden_kern.xml:185 (+ Zeile 241)
SOLL/FIX: Gesamtzahl korrekt ausweisen (2.097.152), 524288 als Teilprodukt umwidmen.
STATUS LT. QUELLE: offen (Review); lt. wtpunni0p behoben@953ce412
ABHAENGIGKEIT/FLAECHE: B14/KF-6

### [wc2xbd4ay.json] 4
GEGENSTAND: Codex MITTEL: Kommentar-Strip umgehbar -- gueltiges "<!--" in CDATA wird faelschlich als Kommentarstart behandelt und kann aktives unbekanntes Markup ausblenden; Tag-Regex (Zeile 105) endet am ersten ">", obwohl ">" in quotiertem Attributwert zulaessig ist -- nachfolgende unbekannte Attribute werden nicht gesehen.
ORT: /home/comdare/wt-b14-golden/Code/tests/fixture_schema_subset_check.cmake:58 (+ :105)
SOLL/FIX: CDATA-Strip vor Kommentar-Strip; quote-bewusstes Tag-Scanning.
STATUS LT. QUELLE: offen (Review); lt. wtpunni0p behoben@953ce412
ABHAENGIGKEIT/FLAECHE: B14/KF-6

### [wc2xbd4ay.json] 5
GEGENSTAND: Codex MITTEL: Fehlendes SCHEMA, MASTER oder FIXTURE wird als CTest-Skip behandelt; Rename/Loeschung der repo-eigenen XSD oder Master-Datei deaktiviert die Wache statt hart fehlzuschlagen.
ORT: /home/comdare/wt-b14-golden/Code/tests/fixture_schema_subset_check.cmake:44
SOLL/FIX: SCHEMA/MASTER-Fehlen => FAIL statt Skip (nur FIXTURE darf legitim skippen).
STATUS LT. QUELLE: offen (Review); lt. wtpunni0p behoben@953ce412
ABHAENGIGKEIT/FLAECHE: B14/KF-6

### [wc2xbd4ay.json] 6
GEGENSTAND: Codex-Hinweis: der neue organ_subaxes-Block ist aktuell wirkungslos, weil parse_experiment_profile ihn nicht liest. Vier Fokusfragen sonst OHNE BEFUND (XSD-Additivitaet; Subset-Richtung MASTER teilmenge XSD, FIXTURE teilmenge XSD; 17->18 korrekt = 17 zweifache Achsen + persistence_target x1 = 2^17; F-3 Vollmengen-Combo = eine CEB-Lane).
ORT: ce parse_experiment_profile (xml_config_parser.cpp) | super test_data_xml
SOLL/FIX: organ_subaxes-Parser im ce nachziehen (siehe wtpunni0p Kartierung).
STATUS LT. QUELLE: nur-hinweis / offen (ce-Seite 0 Zeilen Arbeit lt. wtpunni0p)
ABHAENGIGKEIT/FLAECHE: ce-Parser-Flaeche unter T2-A-Hoheit; Codex-threadId 019fd661-4766-7883-89cf-6d1f5a52dda9

## Datei w4ffuvkx9.json (S-3-Auflagen: KON55-Kombibau 4 Zellen, Inventory-Floor, Aufraeumen; wt-ce-mess-ordnung, bau/s3-ordnungsrelation)

### [w4ffuvkx9.json] 7
GEGENSTAND: Kombibau-Quittung: 4 Zellen (gcc-15 Debug/Release, clang 22.1.8 Debug/Release) auf 4a89aed5, je ctest -N = 487 (485 Bestand + test_s3_ordnung_relation + test_s3_ordnung_freigabe), Bilanz LITERAL je Zelle "100% tests passed, 0 tests failed out of 485" (Auswahl test_unit = -LE pmc; 485 = 487 minus 2 pmc-Tests linux_perf_pmc_smoke, m3v2_pmc_smoke); Namensmengen aller 4 Zellen BYTE-GLEICH.
ORT: /home/comdare/wt-ce-mess-ordnung @ 4a89aed5, Branch bau/s3-ordnungsrelation
SOLL/FIX: - (Quittung ohne Restzweifel im Kern; Warnungs-Review zweimal bestanden: GCC-Release genau EINE Diagnose -Wstringop-overflow= stl_algobase.h:426 via vector::erase, TU test_v41_topic_traversal.cpp, baseline-identisch belegt; clang je 3x -Wcharacter-conversion aus gtest-printers.h:524 = Fremdcode; neue Flaeche 0 Warnungen)
STATUS LT. QUELLE: erledigt, landefaehig JA
ABHAENGIGKEIT/FLAECHE: Landung folgt Wellen-Form A2.1a

### [w4ffuvkx9.json] 8
GEGENSTAND: Inventory-Floor neu gemessen und committet: avx512f 479->488 | avx2 475->484 | basis 473->482 (Abstaende -4/-2 unveraendert); Namensdiffs exakt die dokumentierten 4 bzw. 2, Gegenrichtungen leer; +9 je Sprosse statt +2: +2 S-3 plus +7 aus FUENF frueheren Paketen seit 6c010cdc ohne Sprossen-Nachzug.
ORT: scripts/ci_test_inventory_floor.txt, Commit 965cd6da (nur diese Datei, 40+/6-) auf bau/s3-ordnungsrelation
SOLL/FIX: -
STATUS LT. QUELLE: behoben@965cd6da
ABHAENGIGKEIT/FLAECHE: ci_test_coverage_guard.sh sieht neue Sprossen erst in der Pipeline (offener Punkt 10)

### [w4ffuvkx9.json] 9
GEGENSTAND: PROZESS-BEFUND (Wiederholungsmuster): FUENF Pakete seit Sammellandung 6c010cdc registrierten zusammen 7 Tests OHNE den vom Datei-Kopf geforderten Sprossen-Nachzug im selben Zug (test_anker_marke_statt_ledgerzeile, test_d37b_modus_riegel, test_pa1_tote_ausnahme, test_vor_push_gate, test_vs_taxonomie_klassen_grep, test_bvset_teilmenge, test_s1_stempel_basis_vertrag) -- derselbe Versaeumnis-Typ wie ca6d8af1.
ORT: dokumentiert im Floor-Commit 965cd6da; Baum selbst ist nachgezogen
SOLL/FIX: VERBATIM: "fuer Landung/Owner als Wiederholungsmuster benennen (Kandidat: Wache/Hook, der Registrierungs-Diffs ohne Floor-Anfassung meldet)."
STATUS LT. QUELLE: offen (Prozess-Luecke; Baum nachgezogen)
ABHAENGIGKEIT/FLAECHE: Wachen-Flaeche (ci_test_inventory_floor); Owner-Meldung bei Landung

### [w4ffuvkx9.json] 10
GEGENSTAND: pmc-Klasse NICHT GEFAHREN (linux_perf_pmc_smoke + m3v2_pmc_smoke ungeprueft) -- offizieller make-check-Weg schliesst -LE pmc aus; Klasse braucht COMDARE_PMC_LANES/Vendor-Lanes und laeuft im eigenen CI-Job.
ORT: bau/s3-ordnungsrelation (Testauswahl)
SOLL/FIX: Deckung kommt mit der Pipeline nach der Landung.
STATUS LT. QUELLE: offen (bis Pipeline-Lauf)
ABHAENGIGKEIT/FLAECHE: Landung bau/s3-ordnungsrelation; CI-pmc-Job

### [w4ffuvkx9.json] 11
GEGENSTAND: scripts/ci_test_coverage_guard.sh lief lokal NICHT (nur Mess-Rezept und Datei-Parser nachvollzogen); die neuen Sprossen 488/484/482 sieht die Wache erstmals in der Pipeline ueber 965cd6da.
ORT: scripts/ci_test_coverage_guard.sh | Commit 965cd6da
SOLL/FIX: VERBATIM: "nach der Landung Pipeline-gruen verifizieren."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Landung bau/s3-ordnungsrelation -> Pipeline

### [w4ffuvkx9.json] 12
GEGENSTAND: clang-Fremdcode-Warnung -Wcharacter-conversion (gtest-printers.h:524, googletest in _deps, 3 Vorkommen je clang-Zelle) -- Bestand, nicht S-3.
ORT: _deps googletest (gtest-all.cc)
SOLL/FIX: kein Handlungsbedarf in P1; verschwindet ggf. mit googletest-Update.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

### [w4ffuvkx9.json] 13
GEGENSTAND: KEIN Push, KEIN Merge, KEIN Ledger-Edit erfolgt (auftragsgemaess); Landung des Zweigs (2 Commits: 4a89aed5 Bau + 965cd6da Floor) steht aus. Golden-Endkontrolle: tests/unit/thesis_tiere Diff 0 Zeilen, golden_fullpilot_320* byte-unberuehrt. Aufraeumen komplett (6 Bauverzeichnisse mit Belegpruefung entfernt, 38G frei); Worktree wt-ce-mess-ordnung NICHT geloescht; wt-ce-golden-s14a nie beruehrt.
ORT: /home/comdare/wt-ce-mess-ordnung, Branch bau/s3-ordnungsrelation (4a89aed5+965cd6da)
SOLL/FIX: Landung folgt Wellen-Form A2.1a.
STATUS LT. QUELLE: offen (Landung ausstehend), landefaehig JA
ABHAENGIGKEIT/FLAECHE: A2.1a-Landestufe; Merge-Flaeche ce development

## Datei wtpunni0p.json (B14-NB2-Verifikation nach Spend-Limit-Abriss; Commit 953ce412, wt-b14-golden + wt-b14-ce)

### [wtpunni0p.json] 14
GEGENSTAND: Diff-Audit d8073913..953ce412: alle 6 Codex-Befunde GEDECKT (1: N=2^17 maschinenlesbar via run_options cap="131072" + XSD RunOptionsType + neue Wache golden_n_consistency_check.cmake prueft Produkt==cap beider Traeger; 2: search_algo-Pin auf k_ary/interpolation Registry-kanonisch; 3: leere/abgeschnittene XML hart ROT; 4: Gesamtzahl 4x4x2^17=2.097.152 in XML+SCHEMA.md; 5: CDATA-/Attribut->-Haertung via comdare_strip_cdata + quote-bewusstes comdare_scan_tags; 6: fehlende SCHEMA/MASTER => FATAL statt Skip). Zusaetzlich alle 34 neuen allowed_variants-Namen gegen cache_engine_axis_registry.xml aufgeloest: 18/18 OK + 18/18 FIRST2-MATCH gegen mp_take_c<EnabledStrategies,2>; Produkt 131072 = cap.
ORT: super Commit 953ce412 (wt-b14-golden), Branch b14-golden-kf6
SOLL/FIX: -
STATUS LT. QUELLE: behoben@953ce412; Gates literal nachgefahren (fixture_sync 5/5; da_unit 116/116 j3+j1; xmllint 4/4 validates; ASCII 0 Nicht-ASCII); Biss-Beweise ALT-RC=0/NEU-RC=1 fuer 7 Praeparate + Kettenwache 6 Praeparate + Positivkontrolle
ABHAENGIGKEIT/FLAECHE: B14/KF-6; Verdikt "LANDEBEREIT-fuer-Codex-Lens" fuer super-Anteil 953ce412 mit 2 Auflagen (Funde 16, 17)

### [wtpunni0p.json] 15
GEGENSTAND: Hinweis: Auftrag nannte "fixture_sync 4/4", Ist ist 5/5 (4 alte + neue Wache test_golden_n_consistency); keine bestehende verschwunden.
ORT: super Code/build/b14, ctest -L fixture_sync
SOLL/FIX: -
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

### [wtpunni0p.json] 16
GEGENSTAND: Commit-Text-Regression: Die Commit-Aussage "ce UNBERUEHRT: HEAD 7969b399..., git status --porcelain = 0 Zeilen" war zum Commit-Zeitpunkt wahr, ist jetzt falsch -- der Vorgaenger legte NACH dem super-Commit den ce-Worktree /home/comdare/wt-b14-ce (Branch b14-ce-anteil, HEAD c837d830) an, 2 Dateien uncommitted (+101/-15): abi_adapter.hpp, axis_05_memory_layout_observable.hpp.
ORT: /home/comdare/wt-b14-ce, Branch b14-ce-anteil, HEAD c837d830 (uncommitted)
SOLL/FIX: VERBATIM: "die Zeile ... darf nicht als Ist-Aussage in den Ledger wandern."
STATUS LT. QUELLE: offen (Auflage 1, nicht Commit-Inhalt)
ABHAENGIGKEIT/FLAECHE: Ledger-Eintrag B14; ce Ein-Schreiber-/T2-A-Hoheit

### [wtpunni0p.json] 17
GEGENSTAND: ce-Anteil kLbufBytes/abi_adapter INHALTLICH FERTIG aber UNCOMMITTED: alle neun 64-Literale in run_workload/run_workload_segmented/run_workload_segmented_v2 auf line_bytes_of<MemLayout>() abgeleitet, je Pfad static_assert-Untergrenze; Forwarding-Fix real und noetig (ObservableMemoryLayout hat keine Basisklasse, ALT fiel line_bytes_of auf kDefaultLineBytes durch = stiller 64er/OOB). Stand nur als Patch in /tmp gesichert: /tmp/b14-ce-rettung/b14-ce-anteil-uncommitted-20260806-1058.patch -- /tmp ist NICHT neustartfest.
ORT: /home/comdare/wt-b14-ce/libs/cache_engine/anatomy/abi_adapter.hpp + libs/cache_engine/axes/layout/axis_05_memory_layout_observable.hpp (uncommitted)
SOLL/FIX: VERBATIM: "Entscheid noetig: ce-Anteil committen (dann b14-ce-anteil, eigene Gates, ce-Doppellauf) oder verwerfen -- der Stand haengt derzeit uncommitted und nur in /tmp gesichert." Wenn ueberleben soll: Commit auf b14-ce-anteil oder Kopie ausserhalb /tmp.
STATUS LT. QUELLE: offen (Owner-Entscheid; Verlustrisiko /tmp)
ABHAENGIGKEIT/FLAECHE: ce Ein-Schreiber-/T2-A-Hoheit; Owner-Entscheidung

### [wtpunni0p.json] 18
GEGENSTAND: Auflage organ_subaxes-Parser: OFFEN, 0 Zeilen Arbeit; grep -rn "organ_subaxes" ueber gesamtes ce-Repo = 0 Treffer; parse_experiment_profile (xml_config_parser.cpp:444ff) liest axes_default_lookup bei :486, kennt weder organ_subaxes noch run_options (run_options-Lesung :424-432 gehoert dem thesis-Dialekt tp); das neue <run_options> des super-Commits ist heute rein deklarativ.
ORT: ce xml_config_parser.cpp:444ff | Kartierung (Dateiliste): xml_config_parser.hpp (:441 ExperimentProfile, :452 Feld analog axes_default_lookup, :192 ThesisRunOptions), xml_config_parser.cpp (:486), validate_profile.hpp (Pruefungen 5/12-Analogon), experiment_plan_director.hpp, tests test_experiment_parser.cpp + test_experiment_kern_seam.cpp, Fixture experiment_golden_kern.xml
SOLL/FIX: organ_subaxes + run_options im Experiment-Dialekt lesen; NICHT anzufassen (T2-A-Hoheit): cache_engine_builder_iterator.hpp, profile_run_entry.hpp, batch_planner.hpp.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: T2-A-Hoheit ce; B14-Kette wird erst mit Parser-Konsum operativ

### [wtpunni0p.json] 19
GEGENSTAND: Offener Owner-Punkt aus dem Commit: bleibt der search_algo-Pin {k_ary, interpolation} oder wechselt er auf den Kontrast {k_ary, linear_scan}? Ein Wechsel bewegt beide Traeger. Kein Blocker.
ORT: super test_data_xml/experiment_golden_kern.xml + all_axes_golden.profile.xml
SOLL/FIX: Owner-Entscheid.
STATUS LT. QUELLE: offen (kein Blocker)
ABHAENGIGKEIT/FLAECHE: Owner-Frage; beide golden-Traeger

## Datei w72yytmwm.json (LB-6 Stufe 1: OE-B-Dummy-Lager auf Baum-Form + Zeilen-Ruecklesung, Vor-Trigger-Pflicht; ce HEAD e7aa1244)

### [w72yytmwm.json] 20
GEGENSTAND: LB-6-Luecke: kein einziger Test vereint "echtes Dateisystem" + "Stempel-Zeilen zurueckgelesen und einzeln ausgewertet". test_g1_binary_version_stamp.cpp hat Zeilen-Anker (split_lines :28-40, 4 Zeilen EXPECT_EQ :84-104) aber in-process (nichts geschrieben/gelesen); test_lb0_lager_pfad_grammatik.cpp:542 schreibt Stempel real, liest Inhalt nie zurueck; test_lb1_knoten_heuristik_log.cpp:522 liest nur Knoten-Log via lade_knoten_log(), nicht den Stempel-Text zeilenweise.
ORT: ce tests/unit/test_g1_binary_version_stamp.cpp, test_lb0_lager_pfad_grammatik.cpp:542, test_lb1_knoten_heuristik_log.cpp:522 @ e7aa1244
SOLL/FIX: Delta D1-D6 / Bau-Schritte B-1..B-6 (siehe Funde 24-25): Rueckles-Biss in beiden TUs, mehrzeiliger Stempel-Fixture, kollisionsfeste Temp-Wurzel, optional echte Nebenlaeufigkeit. Kein neuer Header ausser geteiltem Test-Helfer, keine CMake-Registrierung, keine Produktivdatei.
STATUS LT. QUELLE: offen (Design fertig, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: LB-6 Vor-Trigger; Plan-Dokument docs/plaene/20260806-PLAN-lb6-stufe1-oeb-baumform.md (521 Zeilen, nur ?? im Arbeitsbaum, NICHT committet)

### [w72yytmwm.json] 21
GEGENSTAND: Beweis 1 (lueckenlose BATCH-Wiederaufnahme-Konstruktion, PFLICHT laut OE-A 01.08., kein Minimal-Ersatz; Ersatz-Gate-Rezept K1: Doppellauf-Idempotenz DIFF-RC=0, rm .version-Kontrolltest, literales built_new=0) und Beweis 4 (Bestandslog-E2E gegen echtes minio + Takeover-Zweig) sind WEITERHIN UNBELEGT; Ledger B10 (VOR-TRIGGER-CHECKLISTE B1-B13) fuehrt sie offen: "V7.4-4+1-Beweise + G6(J-0..J-5) auf GEEICHTEM Stand NEU erbringen (Variant-Gate-E2E seit A2 inert)." test_a2_sha512_skip_gate.cpp ist NICHT der geforderte Driver-E2E-Doppellauf. Beweis 4 strukturell ausserhalb (Cluster-read-only, echtes minio = Infra). Beweis 2 real durch test_g3_prune.cpp abgedeckt (K2 Fake-mc-Weg akzeptiert).
ORT: super docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md B10 (B-Checkliste bei :5775, Stand 05.08. abend-4) | Quellen: docs/sessions/20260801-FAHRPLAN-vollbau4-beweise-g6-trigger.md:200-201 (OE-B), 20260801-KONSOLIDIERT-...md:76 (F9/LB-6)
SOLL/FIX: Beweis 1 als Driver-E2E-Paket konstruieren; Beweis 4 = Infra-Posten; VERBATIM-Auflage: "eine deklarierte Herabstufung von Beweis 1, Beweis 4 und der echten Nebenlaeufigkeit im Ledger UND in der VOR-TRIGGER-CHECKLISTE" wenn nur Stufe 1 geliefert wird -- sonst wird "Stufe 1 fertig" beim naechsten Lesen zu "LB-6 fertig".
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: B10 Vor-Trigger-Block; Cluster-read-only-Doktrin; Ledger + VOR-TRIGGER-CHECKLISTE

### [w72yytmwm.json] 22
GEGENSTAND: Truncate-/Spin-Lock-Konkurrenz-Test deckt nur einen Teil: TruncateZustandsmaschine (:420) + Crash-Marke (:448) laufen auf FakeAblage (in-memory), zweiter Schreiber ist verschachtelter sequenzieller Aufruf, kein std::thread (0 Treffer in TU) -- Konkurrenz auf echtem Dateisystem (Spin-Lock-Datei, zwei parallele Prozesse/Threads) ist NICHT bewiesen.
ORT: ce tests/unit/test_lb1_knoten_heuristik_log.cpp:420,:448
SOLL/FIX: optional neue TEST mit make_filesystem_ablage() + TempKnoten + std::thread (zwei echte Threads, mit_knoten_lock gegeneinander); B-6 mit Flake-Auflage ("genau einer gewinnt", nie "A gewinnt", kein sleep). B-6 ist der einzige Kandidat fuer eine deklarierte Verschiebung, NICHT der Rueckles-Biss.
STATUS LT. QUELLE: offen (Teilabdeckung)
ABHAENGIGKEIT/FLAECHE: LB-6; Fund 23 (Temp-Wurzel-Kollision blockiert die Konkurrenz-Stufe)

### [w72yytmwm.json] 23
GEGENSTAND: NEUBEFUND (blockiert Konkurrenz-Stufe): beide Fixtures (TempLager test_lb0:118-137, TempKnoten test_lb1:106-124) bilden ihre Wurzel als festen Namen direkt unter temp_directory_path() und rufen im Konstruktor fs::remove_all(basis); die geheilte Klasse comdare_test_tmp.hpp (user_tmp_dir(), #278/#24 + Haertung Posten 69) wird von 39 TUs benutzt, 12 nicht -- test_lb0/test_lb1 gehoeren zu den 12. Auf einem Runner mit zwei Bau-Baeumen misst ein Nebenlaeufigkeits-Test sonst die Kollision zweier ctest-Laeufe statt der Spin-Lock-Semantik.
ORT: ce tests/unit/test_lb0_lager_pfad_grammatik.cpp:118-137 + test_lb1_knoten_heuristik_log.cpp:106-124
SOLL/FIX: B-4: Wurzel auf user_tmp_dir() (15 min).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: LB-6 B-4; comdare_test_tmp.hpp-Migrationsrest (12 TUs gesamt)

### [w72yytmwm.json] 24
GEGENSTAND: LB-6-Bauplan (Delta, keine Neuerfindung): B-1 geteilter split_lines-Helfer tests/unit/stempel_zeilen.hpp (wortgleich aus test_g1:28-40, dort Kopie loeschen); B-2 test_lb0:542 Ablage als benannte Variable, Stempel auf Vier-Zeilen-Block heben, ablage.datei_lesen(b.blatt_pfad) -> split_lines -> Zeile-fuer-Zeile-EXPECT_EQ gegen Erwartungs-Array (nie gegen die geschriebene Variable) + Negativ-Probe; B-3 dasselbe auf perm.dll in test_lb1:522 NACH Truncate+Inventur; B-4 user_tmp_dir(); B-5 Doppellauf -LE pmc (erwartet 0 failed out of 405), ctest -N-Namens-Diff, cf22 ueber ganze Dateien (Lehre aus Ledger :4335-4345), ASCII-Selbstcheck, Ledger-Nachtrag; B-6 optional 2-Thread-Konkurrenz. AUFWAND Stufe 1 ~110-140 Testzeilen, 0 Produktivzeilen, ~2,0-2,5 h; B-6 +1,5-2,0 h.
ORT: Plan: super docs/plaene/20260806-PLAN-lb6-stufe1-oeb-baumform.md (uncommitted)
SOLL/FIX: wie beschrieben; CI-Auflage VERBATIM: "keinem beruehrten Test ein Label geben -- das war die R4-Wurzel (baaaea62+dcb2f08f)."
STATUS LT. QUELLE: offen (Plan liegt, Bau ausstehend; Plan-Datei selbst uncommitted!)
ABHAENGIGKEIT/FLAECHE: R4-CI-Wurzel-Fix (gelandet baaaea62+dcb2f08f, deckt test_lb0/lb1 via -LE pmc, kein eigener CI-Change noetig); golden-neutral belegt

### [w72yytmwm.json] 25
GEGENSTAND: Korrekturen an der Codex-Analyse: (a) Codex zitierte B10 als "Ledger :5696, juengster Eintrag" -- falsch herum, Ledger haengt Nachtraege OBEN an, :5775 ist B-Checkliste 05.08. abend-4, juengster Eintrag :4199; B10 bleibt inhaltlich offen. (b) Zahlen praezisiert: 407 Tests registriert, 2 pmc, 405 im Schnitt -LE pmc. (c) Zeilennummern: TempLager test_lb0:118-137, TempKnoten test_lb1:106-124, temp_directory_path test_lb1:109.
ORT: ce @ e7aa1244; Ledger
SOLL/FIX: -
STATUS LT. QUELLE: nur-hinweis (Korrektur der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [w72yytmwm.json] 26
GEGENSTAND: Termin-Urteil LB-6: Stufe 1 passt vor Do 07.08., LB-6 als Ganzes NICHT. Kleinster Umfang, der die Zusage einloest: B-1+B-2+B-3 (Rueckles-Biss MIT mehrzeiligem Fixture -- ohne D4 ist die Owner-Forderung nicht erfuellt) + B-5 + deklarierte Herabstufung von Beweis 1/Beweis 4/echter Nebenlaeufigkeit in Ledger UND VOR-TRIGGER-CHECKLISTE. Stufe 2 nur Folgeposten: Vorlage genus_buildvariant_avx2.cpp (30 Zeilen, "dieser Stub"), haengt am Versionierungs-Interface (F7 Option b), nach der Abgabe.
ORT: ce tests/unit/genus_buildvariant_avx2.cpp, CMakeLists.txt:3583/:3599
SOLL/FIX: siehe GEGENSTAND.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: F7 Option b (Versionierungs-Interface); Abgabe-Termin

## Datei wn7jy2yah.json (Nachlese: ungelesene/unvollstaendig gelesene Workflow-Ergebnisse der letzten 4 Kontexte; 4 Lose, Los 4 "journale-voriger-kontext" = 0 Posten)

### [wn7jy2yah.json] 27
GEGENSTAND: CMake-Ballast-Zensus landete nirgends: 220 Ziele geprueft, 141 brauchen '${PROJECT_BINARY_DIR}/generated' wirklich, 79 sind toter Ballast (35 literale Ziele + 44 Schleifen-generierte, alle mit Zeilenangabe); am ce-development-HEAD aa223961 noch 150x das Muster (Bericht mass 146) -- keine Bereinigung erfolgt; einziger verwerteter Teil war die Korrektur "build_provenance.hpp hat einen realen Konsumenten (test_ap9_provenance_manifest)" in Commit 6ddd7fd4.
ORT: ce tests/unit/CMakeLists.txt @ aa223961 | Quelle: docs/sessions/backups/20260807-workflow-endberichte/diese-session-5a19728e/a007bfb20ae8ddc74.md
SOLL/FIX: VERBATIM: "Die vom Bericht namentlich gelistete 79er-Liste ... in die Ledger-Aufraeumpass-Kandidatenliste (Par. 75, docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:3602ff) aufnehmen."
STATUS LT. QUELLE: TEILWEISE_VERWERTET / offen
ABHAENGIGKEIT/FLAECHE: Ledger Par.-75-Aufraeumpass; keine der Zahlen 220/141/79 in Ledger/Gesamtdossier/Checkheft

### [wn7jy2yah.json] 28
GEGENSTAND: COMDARE_VARIANT_GATE (funktional obsolet seit F7-(b)/bvset-Preimage-Glied) fehlt in der Par.-75-Aufraeumpass-Kandidatenliste; die beiden substanziellen Berichtsteile sind gelandet (Validierungs-Riegel numa_node/page existiert in validate_profile.hpp:208 @ aa223961; 234-V-b und VARIANT_GATE brauchen keinen Bau).
ORT: docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:3602-3790 (0 Treffer) | Quelle: a11735fcdd4f54b3a.md
SOLL/FIX: 5-Minuten-Ledger-Zeile: COMDARE_VARIANT_GATE auf die Par.-75-Kandidatenliste setzen. Niedrige Prioritaet, kein Blocker.
STATUS LT. QUELLE: TEILWEISE_VERWERTET / offen (Mini-Rest ~5 Min)
ABHAENGIGKEIT/FLAECHE: Ledger; einzige Ledger-Treffer betreffen aelteren CODEX-Befund C6 (Ledger:4135)

### [wn7jy2yah.json] 29
GEGENSTAND: Talos-Rollentrennung im Thesis-Text entschieden (dritter Weg = ROLLENTRENNUNG: Talos = immutable Bau-/CI-/Cache-Schicht, root-Linux = zaehlerbasierte Erhebung; falscher Allquantor "jede Messung unter beiden Regimes" entfernen, nichts streichen), aber an KEINER der 3 PDF-Stellen + 4 Drift-Stellen (DE+EN) eingetragen; 01_einleitung.tex:226 traegt am HEAD 29a1700 noch den alten Wortlaut.
ORT: Thesis-Klon /home/comdare/Projekte/Research/20260931-overleaf-diplomarbeit (development, HEAD 29a1700): kapitel/de/01_einleitung.tex:225-226, kapitel/de/05_evaluation.tex:82-89, anhang/de/E_architecture_decisions.tex:143-148 + EN-Pendants + 2 Drift-Kopien 01_introduction.tex/06_evaluation_methodology.tex DE+EN
SOLL/FIX: Praezisierung an allen 3+4 Stellen eintragen; als Freitag-1-Aufgabe "<1 h" vorgemerkt (Dossier :3369-3372, N-M2 :3650-3666).
STATUS LT. QUELLE: TEILWEISE_VERWERTET / offen (Entscheidung ja, Textkorrektur nein)
ABHAENGIGKEIT/FLAECHE: Thesis-Repo; Gesamtdossier Freitag-1-Fenster

### [wn7jy2yah.json] 30
GEGENSTAND: Zwei fertig gebaute Staende liegen nur auf Rescue-/Feature-Branches, nicht in development: (1) super b-e18-snap (Commit 5c4cf900, E18-SNAP-NB2) -- super development 397710d2 enthaelt ihn nicht (merge-base --is-ancestor = NO); (2) thesis b-gate8-graph-abbildungen (Commit 8970465d, \InputIfFileExists-Gate fuer neue Graph-Abbildungen BEIDE Sprachen) -- thesis-HEAD 29a1700 enthaelt ihn nicht; ohne dieses Gate fehlen die neuen Graph-Abbildungen im PDF trotz vorhandener .tex-Dateien. Graph-Umbau selbst (super 31af5a92) IST gelandet.
ORT: super Branch b-e18-snap @ 5c4cf900 (+ remotes/*/rescue/e18snap-nb2-5c4cf900) | thesis Branch b-gate8-graph-abbildungen @ 8970465d (+ remotes/*/rescue/gate8-graph-abbildungen-8970465d)
SOLL/FIX: Beide Merges nach development ausfuehren. E18-SNAP-Rest zusaetzlich im Ledger als B-6-Sammellisten-Posten ("Patch landen; .gitignore-Negation; PENDING-*.txt-Aufraeumpolitik", OFFEN).
STATUS LT. QUELLE: offen (fertig gebaut, UNGELANDET)
ABHAENGIGKEIT/FLAECHE: Merge-Flaeche super development + thesis development; Vergleich gelandet: T2-A (faa525d7, aa46c524, a9a352bb, 71b5586a, 6c300e68), B14-NB3 super 1ba29b63 + ce 16a173f2, A1-NB2 fdfa68ee, CI-Invariante dcb2f08f, Graph-Umbau 31af5a92

### [wn7jy2yah.json] 31
GEGENSTAND: P2-P8-CSV-Schema-Katalog (K-1..K-14): blockierende Owner-Entscheide E2 (T6-Slot-Vergabe: Peak on-wire vs. Host-Append), E3 (Fenster-Zuordnung A8-S3 vs. E-24-b), E9 (frag_milli-Stille-0-Heilung) fehlen im als vollstaendig deklarierten Entscheid-Register (Dossier Sec.17.9 + OWNER-VORLAGE 07.08.); aelterer Ledger:3833-Triage-Vermerk ("E2/E3->A8-S3 Host/CSV-Klasse C", "E9->A8-S3") existiert -- ob als abschliessende Owner-Entscheidung zaehlend, am Objekt nicht entscheidbar.
ORT: docs/sessions/20260807-GESAMTDOSSIER-...md Sec.16.4 (~Z.2641) vs. Sec.17.9 (Z.3355ff) + docs/sessions/20260807-OWNER-VORLAGE-alle-offenen-entscheide-und-falschaussagen.md
SOLL/FIX: VERBATIM: "E2 ... E3 ... und E9 ... explizit in die naechste Fortschreibung von Dossier-Sec.17.9 bzw. die naechste Owner-Vorlage aufnehmen -- oder den aelteren Ledger:3833-Triage-Vermerk ... ausdruecklich als bereits ausreichende Disposition bestaetigen und den Katalog von 'wartet auf Owner-Entscheid' auf 'reine Bau-TODO' umetikettieren".
STATUS LT. QUELLE: TEILWEISE_VERWERTET / offen
ABHAENGIGKEIT/FLAECHE: Owner-Vorlage; ACHTUNG: w41d6x1yq meldet spaeter E2/E3 als gedeckt (Ledger:7016), NUR E9 offen-klein -> mit P6 geheilt (Konflikt-/Zeitschichten-Hinweis fuer Designer)

### [wn7jy2yah.json] 32
GEGENSTAND: Versionierungs-Interface: sechs STOPP-Gate-Entscheidungen E-A..E-F fehlen in JEDER Owner-Entscheid-Sammlung und blockieren das Owner-KERN "gesondertes Versionierungs-Interface" komplett (Plandokument woertlich: "STOPP (generell): ohne Entscheid kein Byte"). E-A Hex-Laenge Stempel-Name 16/24/32 bit; E-B Name auch im Symbol?; E-C drei Provenienz-Sidecars auf den POD ziehen?; E-D Ordnernamen/CSV-Spalten auf Stempel-Namen umstellen?; E-E Overlay-Glied jetzt scharfschalten?; E-F traegt die Planer-Stufe honest-empty-Glieder oder ein eigenes kuerzeres Set? Lead-Empfehlungen bereits ausgearbeitet: b/ii/b/a/b/a.
ORT: docs/plaene/20260806-PLAN-versionierungs-interface-stempel.md Abschnitt 5 | OWNER-VORLAGE bcaae1e7 nennt unter F7 nur "Option b im GRUNDSATZ; offen bleiben Termin/Ablageort/Env-vs-XML und der ungebaute super-Host-Binder" -- E-A..E-F kommen nicht vor (grep 'E-F\b' = 0 echte Treffer)
SOLL/FIX: Die sechs Gate-Fragen mitsamt Lead-Empfehlungen in die naechste Owner-Entscheid-Vorlage aufnehmen bzw. dem Owner vorlegen.
STATUS LT. QUELLE: NIE_VERWERTET / offen (Blocker fuer F7=b)
ABHAENGIGKEIT/FLAECHE: Owner-KERN F7=b Versionierungs-Interface; Luecke ueberlebte drei unabhaengige Konsolidierungs-Durchgaenge

### [wn7jy2yah.json] 33
GEGENSTAND: PMC-Zugriffsbeweis K-4: konkrete Job-Trace-Belege nicht ins Register/CI uebernommen: (a) Job 364757 (pmc:intel, Pipeline 15071) Status success trotz "SMOKE_SKIP (no PMC access - honest available=0)", 1 von 5 Intel-Laeufen = ~20% Trefferquote; Anti-Korrelation der beiden Smoke-Tests auf prod2 (5/5 widerspruechlich); (b) vorgeschlagene RAPL-Probe (ls -l /sys/class/powercap/intel-rapl:0/energy_uj; cat ... || true, an .bare_metal.before_script in ce/.gitlab-ci.yml) nicht eingebaut -- grep intel-rapl|powercap in .gitlab-ci.yml @ aa223961 = 0 Treffer; Dossier 16.7 behauptet "RAPL energy_uj ist root-only" als gesetzte Tatsache, obwohl Ursprungsbericht "KEINE Probe existiert. UNGEPRUEFT" vermerkt.
ORT: ce .gitlab-ci.yml (.bare_metal.before_script) | Register O-PMC-2 | Quelle Journal wf_7daeeecc-a83, Agent a23eb650238f49f8a
SOLL/FIX: (a) Zahlen-Beleg zu O-PMC-2 nachtragen; (b) RAPL-Probe ("Minuten, ein cat im Job-Trace") tatsaechlich einbauen, um die root-only-Ursache fuer energy=0 zu belegen statt als Hypothese fortzuschreiben.
STATUS LT. QUELLE: TEILWEISE_VERWERTET / offen
ABHAENGIGKEIT/FLAECHE: CI-Flaeche ce/.gitlab-ci.yml; Dossier 16.7 (Tatsachen-Behauptung ohne Probe)

### [wn7jy2yah.json] 34
GEGENSTAND: Thesis: vier PMC-Textstellen (je DE+EN) noch nicht auf die ehrlichere 3-Klassen-Fassung korrigiert, obwohl sofort ausfuehrbar (kein Owner-Entscheid noetig); 06_fazit.tex traegt bei Submodul-Ziel 19e15920 weiterhin "...ist default-abgeschaltet..." ohne dritte Klasse; Text-Fix in keiner Owner-Entscheid-Liste als offene AUSFUEHRUNGS-Aufgabe verbucht (nur Problemklasse O-PMC-3/O-1 registriert).
ORT: kapitel/{de,en}/06_fazit.tex (~155-159), kapitel/{de,en}/03_messsystem_prtart.tex (2 Stellen ~995-1010, ~1045-1060), kapitel/{de,en}/05_evaluation.tex (~179-182/177-179)
SOLL/FIX: VERBATIM einzufuegende Ergaenzung: "auch bei eingeschalteter Erfassung tragen derzeit nur L1D und dTLB reale Werte, waehrend L2, L3, Kohaerenz-Invalidierungen und Energie mangels Zaehler-Mapping auf 0 bleiben" -- strukturneutral, ohne Label-Aenderung, ohne Owner-Freigabe-Bedarf.
STATUS LT. QUELLE: TEILWEISE_VERWERTET / offen
ABHAENGIGKEIT/FLAECHE: Thesis-Repo; Register O-PMC-3/O-1 (UEBERBLICK Z.207)

### [wn7jy2yah.json] 35
GEGENSTAND: Los 4 (journale-voriger-kontext) lieferte 0 Posten -- leere Liste im Ergebnis.
ORT: wn7jy2yah.json result[3]
SOLL/FIX: -
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

## Datei w41d6x1yq.json (Doku-Korrektur-Workflow: Anker-Fehler :1333->:1373, Widersprueche D-1..D-9, verlorene Konsolidierungen; alles am ce-HEAD 54106bc9 neu gemessen + adversarische Verify-Phase)
QUELLEN-DEFEKT: Alle 5 korrektur_gruppen-Reports sind in der Quelle bei 2500 Zeichen, beide verifikation-Reports bei 3000 Zeichen HART ABGESCHNITTEN (Strings enden mitten im Wort, z.B. "kMeasurementToolingC", "H-3-Ausga", "DOSSIER-checkh", "3. **Residual,"). Extraktion unten = alles Verfuegbare.

### [w41d6x1yq.json] 36
GEGENSTAND: G1 Gesamtdossier korrigiert (20260806-GESAMTDOSSIER-session-architektur-und-befunde.md, alle Werte @ ce 54106bc9): F-3 allow_failure sitzt bei experiment_plan_director.hpp:1373 nicht :1333 (git grep = genau 1 Treffer); F-4 Messfenster [0:COMDARE_GN_TOTAL) real :1410-1413 nicht :1367-1369; F-1 seg_ns ueber 6 Verzeichnisse = 308 Treffer nicht 326 (libs allein 117, ganzer Baum 424 in 65 Dateien), falscher "beide Zahlen sind richtig"-Freispruch entfernt; F-5 fallengelassenes Pfadsegment include/cache_engine/ wiederhergestellt (axis_error.hpp, pmc_source.hpp inkl. falscher builder/-Ordner, anatomy_fingerprint.hpp); F-6 vier Flags = pmc_source.hpp:37-43 (L2 :37, L3 :38, coherence :39, energy :43) nicht :36-42; F-7 swisstable in libs = 11 Dateien nicht 5; F-8 ASCII-Marker-Rezept ueber 265 result-Events = 101 von 265 nicht 104 (Umlaut-Varianten 108); F-9 kMeasurementToolingC... [QUELLE HIER ABGESCHNITTEN].
ORT: /home/comdare/wt-super-landung/docs/sessions/20260806-GESAMTDOSSIER-session-architektur-und-befunde.md
SOLL/FIX: angewandt und verifiziert lt. Quelle ("All corrections applied and verified").
STATUS LT. QUELLE: behoben (uncommitted? -- siehe Fund 42: Lead committet zentral)
ABHAENGIGKEIT/FLAECHE: ce 54106bc9 als Messstand; F-9-Inhalt unbekannt (Quelle abgeschnitten)

### [w41d6x1yq.json] 37
GEGENSTAND: G2 Ledger-Nachtrag "### NACHTRAG 07.08.2026 morgen-1" append-only an Ledger angehaengt; neu gemessen: R-3 OFFEN bestaetigt (COMDARE_MEASUREMENT_ON|mess_tooling|measurement_tooling in anatomy_fingerprint.hpp + toolchain_stamp_glied.hpp = 0/2 Treffer; Zusatzbefund: measurement_tooling steht in abi/anatomy_version_stamp.hpp -- im Stempel, aber NICHT im Preimage, das schaerft den Befund; git ls-files '*.fingerprint' = leer -> Fix kostenlos solange 0 Sidecars); SW-5/E-14 OFFEN verbucht (profile_run_facade.cpp:241-242 active_telemetry_is_silent(){return false;}, Aufrufer :533; >=10 thesis_profiles mit silent="true" u.a. all_axes_golden; Konstante-false-trotz-silent, golden-beruehrend, Kommentar :236-240: Wiring bricht Byte-Identitaet). Abweichungen: vierter Berichts-Hash a2ac148a6dcedebb9.md existiert NICHT, inhaltsgleich ist a2a9678e69e6ed72c.md; B-4 fuehrt VIER Bau-Mengen-Kandidaten (131072/524288/1572864/2097152) nicht drei. Selbst-Audit: 6/20 Anker-Fehler, KERN 1 + KERN 12 abgeschnitten, zwei fehlende Owner-Nachrichten, NICHT VOLLSTAENDIG.
ORT: /home/comdare/wt-super-landung/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md Z.7250-7286 (kein git add/commit/push)
SOLL/FIX: R-3 und SW-5/E-14 bleiben OFFENE Mess-Sperrposten.
STATUS LT. QUELLE: Nachtrag geschrieben; R-3 + SW-5/E-14 offen
ABHAENGIGKEIT/FLAECHE: golden-Byte-Identitaet (SW-5); Fingerprint/Preimage-Flaeche (R-3)

### [w41d6x1yq.json] 38
GEGENSTAND: G3 UEBERBLICK korrigiert: (1) generated/-Zensus a007bfb20 ist VOLLSTAENDIG, nicht abgebrochen (146 Wurzel-Vorkommen = 145 target_include_directories + 1 set(COMDARE_MCE24_INCLUDES); 220 Ziele -- 141 noetig / 79 Ballast, Blockebene 145 = 99/45/1; MCE24-Kanal 52 Ziele / 26 noetig; die aeltere voriger-kontext-Erfassung war vor dem Schlussblock abgeschnitten) -- 5 Stellen geaendert (Z.78, Z.117, Z.188, Z.334 I-5, Z.683); (2) E2/E3/E9 nicht mehr Blocker: Ledger:7016 "E3 durch Owner-E-4 gedeckt, E2 durch E-4-SHORTCUT-R1 gedeckt (n/a + Nach-Abgabe-TODO), NUR E9 offen-klein -> wird mit P6 geheilt" (SHORTCUT-R1 auch :7103), Zeile auf E9 reduziert; (3) H-3 erledigt (Z.315): LB-0..6 im Ledger 66 Vorkommen, OE-A..F 13 (reconcile-lokale Bilanz 11/6) -- H-3-Ausga... [ABGESCHNITTEN].
ORT: /home/comdare/wt-super-landung/docs/sessions/20260806-UEBERBLICK-workflow-ergebnisse.md
SOLL/FIX: angewandt lt. Quelle.
STATUS LT. QUELLE: behoben, aber UNCOMMITTED (siehe Fund 42)
ABHAENGIGKEIT/FLAECHE: Konflikt-Aufloesung zu wn7jy2yah Fund 31 (E2/E3 gedeckt, E9->P6)

### [w41d6x1yq.json] 39
GEGENSTAND: G4 Handover-Bilanz korrigiert: D-2: "run_options cap=131072 ist dekorativ -- kein Parser liest es" ist FALSCH -- cap WIRD im comdare_thesis_profile-Zweig geparst UND angewandt (xml_config_parser.cpp:426 tp.run_options.cap; Fluss profile_runner.hpp:148 -> profile_effective_cap :163, Aufruf profile_run_entry.hpp:388 = min(cap, basis_count); SCHEMA.md:41); nur der comdare_experiment-Zweig liest run_options gar nicht (parse_experiment_profile ab :448 = 0 Treffer; alle 8 run_options-Zeilen in :424-432). ABWEICHUNG notiert: "kappt aber nichts (No-op)" ist zu eng; ob 131072 N verkleinert, haengt per min an der nicht gemessenen basis_count. D-3: statt "sechs Planungs-Rueckfragen unbeantwortet": vier dokumentiert (F1 ROH:7716/7761, F3 PLAN-BREAK:334-339, F5 PLAN-KURVEN:250-252, F6 ROH:7601/7603); wirklich offen nur F4 (Phrase "Orchestration ueber das Lager" = 0 Treffer) plus Restentscheide F2 (wandert vs. testiert) und F5 (CT-Einbau vs. RT-Tausch). [Dateiliste am Ende ABGESCHNITTEN]
ORT: Handover-Dateien a+b unter /home/comdare/wt-super-l... [abgeschnitten]
SOLL/FIX: angewandt lt. Quelle (nur Edit, kein git).
STATUS LT. QUELLE: behoben (uncommitted)
ABHAENGIGKEIT/FLAECHE: B14-Kette (run_options-Semantik); Planungs-Rueckfragen F2/F4/F5 weiter offen

### [w41d6x1yq.json] 40
GEGENSTAND: G5 Anker-1333-Korrektur: realer allow_failure-Anker = 1373 (@54106bc9, genau 1 Treffer; Kommentar "Sichtbarkeits-Doktrin" = 1372, rules: = 1368; Drift +40 uniform); 30 echte Anker in 10 von 10 Dateien korrigiert: PLAN-p-pmc-1-messkette.md (3), PLAN-messkette-ceb-observabletier.md (2), PLAN-owner-antworten-vertiefung.md (3; nicht mandatierte Nachbar-Anker :1362/:1367/:1240-1252/:952-955 NICHT nachgemessen), PLAN-testoffensive-und-gruene-pipeline.md (3), PLAN-kostenklammer-restposten.md (3; Hinweis: :1300, :1336-1364 auf Alt-Stand), PLAN-wellenplan-vollbild-und-parallelisierung.md (6; Z.1201 war falsche Live-Messbehauptung), ANKLAGE-kostenklammern-plan-diff.md (5), KONTEXTUEBERGABE-abend-praezise.md (1), ANKNUEPFPUNKTE-vorarbeit-je-aufgabe.md (1), DOSSIER-regressionen-checkheft.md (3 korrigiert, 2 bewusst NICHT: Z.405 + Z.1734 tragen :1333 als ALTEN Wert im Korrektur-Record).
ORT: 10 Plan-/Dossier-Dateien unter /home/comdare/wt-super-landung/docs/
SOLL/FIX: angewandt lt. Quelle.
STATUS LT. QUELLE: behoben (uncommitted)
ABHAENGIGKEIT/FLAECHE: nicht nachgemessene Nachbar-Anker bleiben Alt-Stand (Restrisiko)

### [w41d6x1yq.json] 41
GEGENSTAND: VERIFY (anker), adversarisch: ZWEI ECHTE REST-FEHLER nach der Korrektur: (1) LEDGER:5328 schreibt experiment_plan_director.hpp:1332-1333 als Ist-Zustand ("CODE-STAND: unveraendert") -- real @54106bc9: allow_failure 1373, Kommentar 1372, STALE nicht gefixt; (2) DOSSIER-regressionen-checkheft.md:1302 "der Kommentar darueber (:1332)" als aktuelle Tatsache -- real 1372, STALE; dieselbe Datei hat bei Z.405/543 bereits :1373 -- interner Widerspruch. Nebenbefund F-02 (GESAMTDOSSIER Z.2382): Behauptung "Repoweit trifft flat_hash_map zehnmal ... 3 Thesis-Spiegel/1 googletest/6 tcmalloc" NICHT belegbar -- real @54106bc9: 82 Zeilen in 21 Dateien, ausnahmslos unter ext/allocator/A06-tcmalloc, keine .tex/googletest-Treffer (Z.2378 "flat_hash_map libs apps tools tests -> 0" dagegen korrekt). F-1 (117/308/424 in 65) und F-7 (11) selbst nachgemessen KORREKT.
ORT: LEDGER:5328 | DOSSIER-regressionen-checkheft.md:1302 | GESAMTDOSSIER Z.2382
SOLL/FIX: VERBATIM: "Zu behebende konkrete Rest-Fehler: LEDGER:5328 (1332-1333 -> 1372/1373) und DOSSIER-checkh..." [QUELLE ABGESCHNITTEN -- gemeint offenbar DOSSIER-checkheft:1302]; F-02-Behauptung korrigieren.
STATUS LT. QUELLE: offen (2 Rest-Fehler + 1 Nebenbefund)
ABHAENGIGKEIT/FLAECHE: Ledger + Checkheft-Doku; ce 54106bc9

### [w41d6x1yq.json] 42
GEGENSTAND: VERIFY (konsolidierung): Nachtrag morgen-1 vollstaendig (Ledger Z.7250-7286, alle drei Gruppen). Zwei Zahl-Ungenauigkeiten: measurement_tooling in anatomy_version_stamp.hpp = 7 Treffer nicht 8 (off-by-one, Substanz haelt); silent="true"-Profile exakt 12 (Nachtrag sagt "mindestens 10" -- korrekt aber untertrieben). E2/E3/E9- und H-3-Korrektur inhaltlich JA, ABER: (1) Zeilenanker "Zeile 327" falsch -- Korrektur sitzt auf Z.369 (Baseline Z.365); (2) BEIDE Korrekturen UNCOMMITTED -- git status M docs/sessions/20260806-UEBERBLICK-workflow-ergebnisse.md auf development, letzter Datei-Commit b5e02c06 enthaelt sie NICHT ("Der Lead committet zentral" -- solange nicht committet/gepusht ist die Heilung nur lokal). Punkt 3 "Residual," ABGESCHNITTEN in der Quelle.
ORT: /home/comdare/wt-super-landung docs/sessions/20260806-UEBERBLICK-workflow-ergebnisse.md (uncommitted M) | Ledger Z.7250-7286
SOLL/FIX: Commit der Doku-Heilungen durch den Lead; Rest-Fehler aus Fund 41 beheben.
STATUS LT. QUELLE: teilweise (Heilung lokal, nicht committet)
ABHAENGIGKEIT/FLAECHE: super development Landung; Verlustrisiko bei Worktree-/Kontextwechsel

## Datei w4m1xz6m1.json (Thesis-Posten: zwei Einbindungen im super + Anhang-A-Abbildungen ehrlich machen; Lage @ super 2a6f35d8, Bau + adversarischer Verify 06.08. 21:19 UTC)

### [w4m1xz6m1.json] 43
GEGENSTAND: Doppel-Einbindung derselben Thesis im super: thesis/diplomarbeit (branch=development, update=merge) und Code/external/20260931-overleaf-diplomarbeit (weder branch noch update in .gitmodules = "tote" Einbindung); Divergenz war am 06.08. 20:03 UTC durch super-Commit 46824fba geheilt (beide Gitlinks 8e58f691), ABER STRUKTURBEFUND BESTEHT FORT: der Rueckschreib-Job anhang:forward (.gitlab-ci.yml:1111) bumpt NUR thesis/diplomarbeit; der zweite Zeiger wird von keinem CI-Pfad nachgezogen; verify:submodules (:309) prueft nur thesis/diplomarbeit -- Divergenz entsteht bei JEDEM CI-Rueckschrieb stumm neu.
ORT: super .gitmodules Z.11-18 | .gitlab-ci.yml:102,181,285,309,560,565,901,1102,1111 (thesis/diplomarbeit; Code/external/20260931 = 0 Pfad-Treffer)
SOLL/FIX: Wache, die beide Zeiger vergleicht / verify:submodules erweitern -- NICHT gebaut (CI-Verhalten aendern war nicht beauftragt). Owner-Entscheide: (a) darf die tote Einbindung entfallen? (Loeschung = GO; Diskrepanz: PLAN-owner-antworten-vertiefung.md:61 stuft als E-8 "kein Owner-Entscheid noetig, Bau-Entscheidung mit Deprecation" ein -- widerspricht der Auflage, gehoert auf den Owner-Tisch); (b) soll die Drift-Wache gebaut werden?
STATUS LT. QUELLE: offen (benannt, nicht geheilt)
ABHAENGIGKEIT/FLAECHE: CI-Flaeche super .gitlab-ci.yml; Owner-Fragen

### [w4m1xz6m1.json] 44
GEGENSTAND: Anhang A: 28 \InputIfFileExists-Eintraege je Sprache, 0 von 28 Zieldateien existieren (harte 16 \input-Ziele 16/16 DA -- kein Bau-Blocker; Ledger :6075 Fallback-Probe: Voll-Lauf ohne alle 23 -> RC=0, 202/192 Seiten); "17 stumm" war als Wertung falsch (4 Gruppenkoepfe 5+2+5+5 decken sie ab), wurde aber im Bau trotzdem auf 0 gebracht: Thesis-Commit 19e15920 (development, FF von 29a1700d auf 8e58f691 vorher) macht alle 28 Eintraege mit eigenem Ersatztext (WAS + WARUM je Familie verschieden), 156+/67-, Ziel-Pfade diff-gleich (0 Abbildungen hinzu/entfernt, O-4-Grenze unberuehrt); super-Commit 123b2f32 bumpt BEIDE Gitlinks 8e58f691->19e1592 + .gitmodules-Kommentare (nichts geloescht, 14=14 Werte). KEIN Datum im Text genannt (Auftrag schlug "21.08." vor -- kein Beleg; Voll-Mess-Lauf im Ledger gegatet #156/HELD ohne Termin).
ORT: thesis anhang/{de,en}/A_measurements.tex @ 19e15920 | super 123b2f32
SOLL/FIX: -
STATUS LT. QUELLE: behoben@19e15920+123b2f32, beide UNGEPUSHT
ABHAENGIGKEIT/FLAECHE: O-4 Anhang-A-Reichweite (Owner, Ledger :5804/:5911, verknuepft mit V-04 Auswertungs-Writer M-8/M-9/M-15: "falls er in die Abgabe soll, rutscht V-04 hoch = OWNER-ENTSCHEID"); die 28 Dateien entstehen je Messlauf via Writer Code/08_appendix_generator/appendix_generator.cpp + anhang:forward-Kanal (.gitlab-ci.yml:1088-1120)

### [w4m1xz6m1.json] 45
GEGENSTAND: Bau-Nachweis lokal: 3-Pass pdflatex + BibTeX, TeXLive 2026; de 202 Seiten/932897 B, en 192 Seiten/899349 B; LaTeX-Warnings=0, BibTeX .blg 0, chktex 0; Verify bestaetigt am PDF-Objekt (202/192 /Type/Page gezaehlt; pdfinfo etc. NICHT installiert). Verify-Praezisierungen: (a) Baseline-Zahlen 921803/888094 B NICHT nachpruefbar (Baseline-PDFs ueberschrieben) -- "Seitenzahl identisch" unbelegt; (b) "0 Warnungen" ist nur die Gate-Zahl (Literal 'LaTeX Warning'); real vorhanden: je 1 'Package .* Warning' (scrlayer-scrpage \headheight to low) + Overfull de=5/en=3; (c) EN nutzt planmaessig alpha.bst, DE alphadin.bst (diplomarbeit.tex:102) -- pauschale alphadin-Doktrin auf beide Sprachen ergaebe Falschbefund; (d) Ersatztexte im PDF-Textlayer 28/28 je Sprache nachweisbar (Ligatur-Falle \x02=fi/\x03=fl + ss/sz-Faltung + Seitenumbruch 103->104 dokumentiert).
ORT: thesis Repo, lokale PDFs 21:05 UTC
SOLL/FIX: -
STATUS LT. QUELLE: bestaetigt (mit Praezisierungen)
ABHAENGIGKEIT/FLAECHE: kein CI-Bau-Beleg fuer 19e1592 (ungepusht, keine Pipeline); Zahlen decken sich mit CI-Stand des Vorfahren 8970465d (Pipelines 15032/15033, Projekt 289, success; Ledger :5279-5284)

### [w4m1xz6m1.json] 46
GEGENSTAND: ABGABEKRITISCHER NEUBEFUND (Verify P3): 19e1592 existiert auf KEINEM Remote (beide Thesis-Remotes stehen auf 8e58f691). Wird super zuerst gepusht, zeigt der Gitlink ins Leere und jeder CI-Submodul-Fetch bricht.
ORT: thesis Remotes origin+github (Heads: development=8e58f691, main=8e58f691, rescue/gate8-...=8970465d)
SOLL/FIX: VERBATIM: "Reihenfolge bei Freigabe zwingend: Thesis zuerst, super danach."
STATUS LT. QUELLE: offen (Push-Reihenfolge-Auflage)
ABHAENGIGKEIT/FLAECHE: super 123b2f32-Push haengt an Thesis-19e1592-Push

### [w4m1xz6m1.json] 47
GEGENSTAND: Verify P5 WIDERLEGT die Ungepusht-Bilanz "Thesis 1 / Super 1" -- real: thesis/diplomarbeit 2 ungepusht (19e1592 development + 0e39e1d w2-E02-Ledger im Worktree /home/comdare/wt-w2-E02-thesis "Repo-lokales Architektur-Ziele-/Offene-Punkte-Ledger angelegt (Vier-Ledger-Struktur)"); Code/external/20260931 1 ungepusht (19e1592 auf Branch b-thesis-ehrlichkeit-anhang, NICHT development; lokales main [behind 83]); super development 1 (123b2f32); super HEAD-Branch b-super-ascii-wache 2 (123b2f32 + 7780c6af "feat(ci): super-eigene ASCII-/Breiten-Wache", fremder Agent). Arbeitsbaum NICHT sauber: m Code/external/comdare-cache-engine (fremder Gitlink-Drift) + ?? Code/measure_out_d03/. Stale tracking ref real (github/development lokal 29a1700d, "5 ahead"-Meldung Schrott, echt 1). super main remote-seitig 2a6f35d8 = 1 hinter remote-development 76b68e57.
ORT: thesis + super, diverse Branches/Worktrees (Messstand 06.08. 21:19 UTC)
SOLL/FIX: alle genannten ungepushten Staende bei Landung beruecksichtigen; 0e39e1d (w2-E02-Ledger) nicht verlieren.
STATUS LT. QUELLE: offen (ungepushte Commits, mehrere Orte)
ABHAENGIGKEIT/FLAECHE: Merge-/Push-Flaeche thesis development + super development; Mehr-Agenten-Arbeitsbaum

### [w4m1xz6m1.json] 48
GEGENSTAND: PROZESS-VORFALL: Commit landete zunaechst auf fremdem Branch -- waehrend der Arbeit wechselte ein anderer Agent im GETEILTEN Arbeitsbaum von development auf b-super-ascii-wache (reflog belegt); Commit fiel auf dessen Feature-Branch; per echtem FF (merge-base --is-ancestor rc=0, exakt 1 Commit) wurde development auf 123b2f32 nachgezogen, HEAD nicht angefasst. Warnung: in diesem Arbeitsbaum arbeiten mehrere Agenten gleichzeitig; .gitlab-ci.yml und scripts/ von fremder Hand veraendert, bewusst nicht mitgenommen.
ORT: super Arbeitsbaum (geteilt), Branches development / b-super-ascii-wache
SOLL/FIX: Beinahe-Verlust-Klasse; Ein-Schreiber-je-Worktree-Regel tangiert.
STATUS LT. QUELLE: behoben (korrigiert), Prozess-Risiko offen
ABHAENGIGKEIT/FLAECHE: EIN SCHREIBER JE WORKTREE (Memory-Regel); Mehr-Agenten-Arbeitsbaum super

## Datei w56km2g9g.json (WF2-Synthese KON15-02 "Zwei Welten der Glieder-Reihenfolge" (J) + KON15-01 "Register der leeren Klassen" (K); 12.08., ce 670483c0, super Snapshot 2ae55a9c / HEAD 012f61c0)

### [w56km2g9g.json] 49
GEGENSTAND: Glieder-Reihenfolge-Karte: IM LAGER zwei Realm-Kaskaden CT-erzwungen (concept LagerRealmPolicy, lager_baum_writer.hpp:688): Messdaten MESS->SYSTEM->ORGAN(5 Gruppen)->Blatt, Binaries SYSTEM->ORGAN(5 Gruppen)->MESS tiefst (D-12); Owner-bestaetigt 08.08. AUSSERHALB durchgaengig ORGAN->SYSTEM->MEASUREMENT an 11 Belegstellen (anatomy_fingerprint.hpp:591-596/:607-608/:733-738, anatomy_module_abi_v1_decl.hpp:200-243 POD APPEND-ONLY, anatomy_module_abi_v1.hpp:162/213 Makros); Preimage = 9 Glieder (kAnatomyFingerprintGliedCount=9). SOLL (Owner 11.08., KON6-02 Punkt 4): MESS,SYSTEM,ORGAN nach Stufigkeit, "nur das Lager hat hier eine Ausnahme" -- Neuordnung, keine Wiederherstellung. IST != SOLL fuer Aussen-Welt ("gewachsen, nicht entworfen", KON7-09). Aussen-IST ist die EINZIGE Ordnung im Haus, die "System vor Organ" nicht haelt.
ORT: ce @ 670483c0, Fundstellen-Karte mit ~30 Zeilenankern (Details in Quelle)
SOLL/FIX: Eingriffs-Ebenen falls SOLL bestaetigt: (1) Makro-Argumentfolge anatomy_module_abi_v1.hpp:162/:213 (golden-Bruch); (2) POD-Feldfolge ..._decl.hpp:200-243 (ABI-Bruch, APPEND-ONLY => Umordnung nur mit Layout-Bump); (3) Preimage-Glied-Folge anatomy_fingerprint.hpp:591-603 samt Zwillingen (consteval :733, static_asserts :607/:641, adhoc_emitter.hpp, lazy_adhoc_source_gen.hpp, Testliterale test_m_w12/test_d4) -- invalidiert alle Fingerprints, laut Wellenplan preimage-wirksam und VOR F2-Freeze faellig (:1375-1376,:1625,:1867). Bestandslog/Lager-Schluessel wandert automatisch mit -- dort NICHTS aendern. VERBOTEN: Lager-Kaskaden + kOrganGruppen*, kSystemAxisOrder, kCompositionAxisNames, Hash-Mechanik (kein zweiter Preimage-Weg, A13-M3), Messwert-2-Tupel.
STATUS LT. QUELLE: offen -- S-6 bleibt bis Owner-Entscheid GESPERRT; Explore-Auflage aus KON15-02 mit diesem Dokument erfuellt
ABHAENGIGKEIT/FLAECHE: F2-Freeze (Umbauten heute kostenlos); Owner-Fragen J1 (5 Stueck, Fund 51)

### [w56km2g9g.json] 50
GEGENSTAND: Kategorien-Ebene (welcher Block zuerst) hat KEINE gemeinsame Quelle, KEINE Konversion, KEINE Wache: lager_pfad_grammatik.hpp (594 Z. voll gelesen) 0 Treffer anatomy_fingerprint; die zwei kaskade()-Aufrufsequenzen und die Preimage-Parameterfolge sind vollstaendig unabhaengig gepflegt -- heute konsistent zu D-12, aber nur durch Disziplin und Kopf-Kommentar (:30-48), nicht Mechanik; kein static_assert spiegelt sie. Der vom Owner befuerchtete verdeckte Bruch sitzt GENAU dort, nicht in der Hash-Berechnung (Hash = eine Welt: Writer rechnet nichts nach, derive_key_from_lines ordnungsblind, BinaryKeyPolicy wirft bei !=9 Gliedern). Zusatz: die 3 vorderen Glieder (organ, system, measurement -- Streitgegenstand S-6) sind rohe typgleiche std::string_view ohne Positions-Pin: eine Vertauschung kompiliert unbemerkt; CEB-Pfad uebergibt organ+system leer.
ORT: ce lager_baum_writer.hpp + lager_pfad_grammatik.hpp + anatomy_fingerprint.hpp
SOLL/FIX: (J2) Kategorien-Ordnungs-Wache als neuer unbenannter Posten (Vorbild organ_gruppen_decken_die_komposition) -- Owner-GO noetig; (J-Frage 4) Transpositions-Sperre fuer die 3 rohen string_view-Glieder: ordnungsunabhaengig, bereits Ledger-gedeckt (KON7-10 Punkt 4, L2334-2336@HEAD) -- mit S-6 oder vorgezogen?
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: S-6; KON7-10 Punkt 4

### [w56km2g9g.json] 51
GEGENSTAND: Fuenf Owner-Fragen (J1), ohne die S-6 gesperrt bleibt: (1) Gilt SOLL=MESS,SYSTEM,ORGAN fuer alle drei Aussen-Ebenen -- meint #87 die Funktions-/Makro-Argumentfolge, #78 die Zeilen-/POD-Folge? (Wellenplan-Wortlaut mehrdeutig); (2) welcher Realm gibt die Preimage-Ordnung vor? (derselbe Fingerprint ist Binary-Identitaet S,O,M UND Messdaten-Skip-Marke M,S,O -- in keinem Dokument beantwortet); (3) Kategorien-Ordnungs-Wache als neuer Posten zu S-6?; (4) Transpositions-Sperre Timing; (5) Posten #67 (Benennung, "4 Familien, 142 Include-Kanten", in S-6 gebuendelt) laut KON13-08 im Ledger unbelegt -- streichen, entkoppeln oder belegen?
ORT: Wellenplan :1577 (S-6-Zeile uebernimmt den Lager-Vorbehalt aus KON6-02(4) NICHT -- belegte Luecke im Plan-Text)
SOLL/FIX: Synthese mit Fundstellen-Karte dem Owner vorlegen; bis Antwort S-6 gesperrt.
STATUS LT. QUELLE: offen (Owner)
ABHAENGIGKEIT/FLAECHE: S-6; Wellenplan; Namenskollisionen beachten: zweiter "S-6" (gcc|clang, Dossier-23, Ledger L10486/L11786@HEAD), zweites "D-12" (L4839-4841@alt), drei S-/W-Zaehlungen -- Gegenstand pruefen, nie die Nummer

### [w56km2g9g.json] 52
GEGENSTAND: Zitat-Anker-Korrektur: Satz "nur das Lager hat hier eine Ausnahme..." wird in KON15-02 und im Memory als "KON7" zitiert; wahrer Fundort ist KON6-02 Punkt 4 (L2366-2392@HEAD). Inhalt zweifach bestaetigt, nur Anker ungenau. KON14-02 ("S-6 falsch herum, an beiden Stellen reproduziert"): Messung war korrekt (beide Aussen-Stellen), zu einfach nur das Pauschalurteil ohne Lager-Vorbehalt.
ORT: Ledger/Memory KON15-02-Zitat
SOLL/FIX: Anker im Ledger/Memory korrigieren (KON7 -> KON6-02 Punkt 4).
STATUS LT. QUELLE: nur-hinweis / offen (Doku-Korrektur)
ABHAENGIGKEIT/FLAECHE: Ledger

### [w56km2g9g.json] 53
GEGENSTAND: Register der leeren Klassen (K, Erstbefuellung): 1351 Quelldateien gescannt, 164 Klassen/Structs mit leerem Rumpf, davon 117 Tag-Dispatch; KEINE einzige unbenannte Huelle -- jede ist deklariert (DEFERRED/SKELETT/Stub/[[deprecated]]/"bewusst ungesetzt"); Luecken liegen in Wellen-Zuordnung und Eigentuemerschaft. Echte Huellen/Teil-Huellen: ISearchEngineProvider + ICacheEngineCoreProvider (api/i_cache_engine.hpp:92-99, DEFERRED-#274/Fork-4, keine S-/O-Position); V32Orchestrator::submit_to_builder + execute_messreihe (super v32_orchestrator.hpp:96-108, "Diesen Stub NICHT fuellen", Klasse [[deprecated]]); 3 Test-Verzeichnis-Skelette tests/{integration,generic_module_tests,module_specific_tests} (Phase-4.B-Marker 06.07., KEIN Posten => Eigentuemer fehlt); CI-Job ergebnis:holen (super .gitlab-ci.yml:2736-2769, Job-Skelett, terminiert scharf mit D3-8 in W2, Spannung zu KON16-03/KON18 keine-YAML offen); XSD-Attribut active Teile 3+4 (Teil-Huelle, XSD-Kommentar selbst veraltet = Doku-Drift, KEIN Posten, unterminierte benannte Grenze); best_binary::BreakEvenPoint SKELETON (S-15=HY-B, echte Kurven erst HY-C); decision_lambda_trees.hpp (HY-C-Substrat); hybrid_router.hpp EXISTIERT NICHT (0 Treffer, HY-C nur geplant); P/E-Core-Cluster (ICpuCore/ICoreLayout/CoreClass, has_hybrid_cores, CPUID 0x1A: Interface ohne Implementierer, Leaf 0x1A nirgends gelesen, Feld nie gesetzt -- KEIN Posten in S-1..S-18/O/HY = ECHTE ZUORDNUNGS-LUECKE, Paragraph 16.3-E17 "deep research Pflicht" nicht eingeloest); CodegenEngine KEINE Klassen-Huelle (nur Stub-Gate-Pfad profile.id=="prtart" quarantaenisiert, "NICHT erweitern").
ORT: ce + super, Register-Tabelle mit Zeilenankern (Details in Quelle)
SOLL/FIX: Register als gepflegtes Repo-Dokument anlegen (KON15-01 "anlegen"); Ablageort + Pflegeregel vom Owner bestaetigen (Doku-Policy: docs nur auf User-Geheiss), dann Erstbefuellung landen.
STATUS LT. QUELLE: teilweise (Erstbefuellung liegt in dieser Synthese, Dokument existiert nicht)
ABHAENGIGKEIT/FLAECHE: K1-Owner-Frage; KON17-05 (L194@HEAD) + KON18-02 (L80@HEAD) fuehren WF2 als laufende Bringschuld

### [w56km2g9g.json] 54
GEGENSTAND: Offene K-Posten: K2 P/E-Core-Cluster ohne Wellen-Zuordnung (Owner: eigener Posten oder Nach-F2); K3 i_command.hpp-Einordnung (laut KON13-08 L744@alt im Ledger offen; real aber default-OFF; Nachfolger AxisCommand steht); K4 mess/-Subsystem (konfiguration.hpp + steuer_dock.hpp, 6 Steuerdocks 3!-permutiert, substanziell) ohne S-Position -- S-9/S-10 naheliegend, unbelegt; Owner: zuordnen oder als 19. Position benennen; K5 drei Skelett-Testverzeichnisse ohne Eigentuemer (fuellen, terminieren oder deprecaten); K6 ergebnis:holen vs. KON16-03/KON18-01 (kein YAML) -- vor W2 klaeren; K7 nicht erschoepfend geprueft: ~1175 kleine Structs, 132 Testdateien + 6847-Z.-CMakeLists nicht zeilenweise (markerlose leere TEST()-Koerper waeren Grep entgangen), 14 super/ci/tests/*.sh nur Umfang, super-CMakeLists 01..09 nicht auf verwaiste add_test, Kandidatenliste-75 Posten 42 (16 Duenn-Verzeichnisse builder/) nicht auf Klassenebene; K8 Buchhaltung: 164-117-34=13 nicht aufgeschluesselt, Grosszahlen nur Sanity-gestuetzt -- beim Landen des Registers Zaehlung reproduzierbar (Skript + Ausgabe) ablegen.
ORT: siehe Fund 53
SOLL/FIX: je Posten Owner-Entscheid bzw. Nach-Explore wo Welle real anfasst.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: W2 (K6); F2 (K2)

### [w56km2g9g.json] 55
GEGENSTAND: Praezisierungen an Vorbefunden: (1) "Drei CoR-Implementierungen (eine verdrahtet)" haelt nicht: zwei gebaut (resolve_selection 4 Produktionsaufrufer profile_run_entry.hpp:957,1009,1074 + experiment_run_entry.hpp:441, stets leere Kette, per Doku #156 strukturell Identitaet, Owner-bestaetigt KON16-07 "Ja wir nutzen es jetzt aktiv, genau das ist der Plan", Welle S-8/W1 CoR-Einhaengung Wellenplan :1579, Termin WE 22./23.08.; ram_probe_chain produktiv via hardware_probe_factory.hpp:433), eine nur geplant (hybrid_router, 0 Treffer); (2) KON11-Elf: keine strukturell hohl -- Verdrahtungs-Leere != Inhalts-Leere; (3) v32_messreihe_antrieb wird von main.cpp:669 real gerufen -- KON12-01-Angabe "kein Produktionspfad" (L785-803@alt) ist ZU AKTUALISIEREN; (4) Testkommentar test_v32_orchestrator.cpp:16-19 ("echte Konsumenten im Produktivcode", 5 Dateien) haelt Gegenprobe nicht stand: alle 5 nur Kommentar-Erwaehnungen; (5) Plandokument-Zeilen veralten (best_binary_selector.hpp SKELETON heute :361-373) -- Code-Gegenprobe vor jedem Zitat.
ORT: ce diverse (siehe GEGENSTAND)
SOLL/FIX: KON12-01 im Ledger aktualisieren; Register-Abgrenzungen uebernehmen.
STATUS LT. QUELLE: offen (Ledger-Korrektur) / nur-hinweis
ABHAENGIGKEIT/FLAECHE: Ledger

### [w56km2g9g.json] 56
GEGENSTAND: Offene J-Restposten: J3 anatomy_version_stamp.hpp:149-169 -- 18er-Literalliste nur ueber Anzahl (kOrganAxisCount) verankert, nicht Element fuer Element gegen kCompositionAxisNames; ob Umsortierung still durchginge, NICHT geprueft -> kleiner eigener Pruef-/Wachen-Kandidat. J4 Kommentar-Drift bestandslog_factory.hpp:11-12 ("[d,e,f]+[g,h,i]+HW" vs. tatsaechliches 2-Tupel) + veralteter XSD-Kommentar zu active -> Doku-Korrektur (deprecaten/nachfuehren, nie loeschen). J5 Restmengen ungelesen: ~40 XML-Instanzdokumente, cache_engine_builder_iterator.hpp (3257 Z., nur Co-Occurrence-Grep), experiment_schema.xsd ab Z.426 nur strukturell -- kein Blocker fuer S-6.
ORT: ce anatomy_version_stamp.hpp:149-169; bestandslog_factory.hpp:11-12; experiment_schema.xsd
SOLL/FIX: siehe GEGENSTAND.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: S-6-Umfeld

## Datei w8v4vkn3p.json (K-3: PMC-Flag als INVARIANTE in alle Mess-Emissionen, Paket M-2/B1+B2+B3+B5 + K-4 RAPL/PMC-Zugriffsbeweis aus CI-Traces; Branch b-m2-pmc-invariante)

### [w8v4vkn3p.json] 57
GEGENSTAND: Paket M-2 (B1+B2+B3+B5) GEBAUT: Branch b-m2-pmc-invariante (aus development=b241a272), Commit 4fd4289668cc7af768c9f2c026094c70f5bbe4cb, NICHT gepusht/gemergt; 6 Dateien +362/-31 (CMakeLists.txt, linux_perf_pmc_source.hpp, experiment_plan_director.hpp, linux_perf_pmc_smoke.cpp, m3v2_pmc_smoke.cpp, test_experiment_plan_director.cpp). 4 Emissionsstellen (director :843,:879,:1196,:1344), B1 Single-Source ceb_pmc_compile_define(); B2-Invariante als TEST(PmcPflichtInvariante) mit 3 Haertungen; Biss-Nachweis B2 4/4 rot; B3 fail-closed via seccomp bewiesen (4 Quadranten literal); Voll-Suite 2x "100% tests passed, 0 tests failed out of 409" (409 statt 407 aus 19 Commits e7aa1244..b241a272, kein add_test in diesem Paket); clang-format 22.1.8 OK x5; ASCII 0/368.
ORT: ce Branch b-m2-pmc-invariante @ 4fd42896 (spaeter HEAD 90bca126 durch fremde Commits, 4fd42896 Vorfahr)
SOLL/FIX: Landung ausstehend.
STATUS LT. QUELLE: gebaut+verifiziert, NICHT gelandet; Adversarial-Verdikte fanden Luecken (Funde 60-63)
ABHAENGIGKEIT/FLAECHE: ce development; B4 (allow_failure) NICHT angefasst (Fund 58)

### [w8v4vkn3p.json] 58
GEGENSTAND: B4-Befund am emittierten Objekt: allow_failure: true sitzt an BEIDEN Mess-Batch-Jobs der Stufe-2-Emission (467 Z., :159+:381; Bau-Batches und Stufe 1 tragen es nicht) und klammert ~103 Zeilen je Lane ein INKLUSIVE des gesamten #37-PMC-Preflights -- der Kommentar reklamiert "HART in BEIDEN Profilen (Paragraph 66-N2 'beide hart')", am Job NICHT eingeloest; bestehender Test :1537 faengt nur ||true, nicht allow_failure (0 Treffer im Testfile). FOLGE: B3 macht den Preflight scharf, aber die Pipeline-Ampel bleibt gruen -- Job faellt rot, Ampel gruen; Kopplung B3->B4 strenger als Plan Paragraph 4.1 (W-2=B3 sofort, W-3=B4 erst nach O-PMC-1).
ORT: ce experiment_plan_director.hpp:1333 (allow_failure-Emission; nach Anker-Korrektur :1373) | emittiert /tmp/m2_stufe2.yml:159,:381
SOLL/FIX: EMPFEHLUNG Weg A VERBATIM: "die Zeile entfernen, gebuendelt mit dieser Welle" -- Deckung: #278 (Owner 06.07. PFLICHT: kein allow_failure in harter Pipeline, Advisory NUR mit eingebuchter Fix-Strecke -- existiert hier nicht) + Paragraph 66-N2 (23.07. KERN=Gesetz: PMC-Strecke "BEIDE hart"); Sichtbarkeits-Doktrin ist ZELL-Doktrin, traegt die Job-Ebene nicht; Risiko asymmetrisch (7-Tage-Lauf stirbt Stunde 2, Ampel gruen, Messfenster unwiederholbar); Aenderung = 1 Zeile + Wache in TEST(TierCiYamlBuilder,G4a...) "der emittierte Mess-Batch traegt kein allow_failure: true". Bewusst NICHT gebaut (Auftrag "nicht anfassen").
STATUS LT. QUELLE: offen (Owner-Entscheid Weg A/B)
ABHAENGIGKEIT/FLAECHE: O-PMC-1; Ledger schweigt zu dieser Zeile (20 allow_failure-Treffer, keiner einschlaegig)

### [w8v4vkn3p.json] 59
GEGENSTAND: Plan-Korrekturen aus dem Bau: (1) P-PMC-1 Paragraph 2.5 / 4/B5(a): tests/unit/CMakeLists.txt:3553 stale -- @ b241a272 real :3568/:3569 (Drift +15/+16); im Code Suchbegriff statt Zeilennummer hinterlegt; (2) P-PMC-1 Paragraph 4/B3 "Biss (a)" widerspricht eigener Spezifikation: "Preflight-Bau ohne Flag -> ctest -L pmc muss ROT" ist mit kPmcExpected-Anker unmoeglich und nicht wuenschenswert -- tragfaehiger Biss: MIT Flag + ohne Zugriff -> rot; identisch blockiert OHNE Flag -> gruen.
ORT: docs/plaene/20260806-PLAN-p-pmc-1-messkette.md Paragraph 2.5 + 4
SOLL/FIX: Plan-Text nachfuehren.
STATUS LT. QUELLE: nur-hinweis / offen (Plan-Doku)
ABHAENGIGKEIT/FLAECHE: -

### [w8v4vkn3p.json] 60
GEGENSTAND: NICHT-BELEGBARES aus dem Bau: (1) Zugriffs-Beweis auf echten Lanes stand zum Bauzeitpunkt aus (spaeter durch K-4 erbracht, Fund 64); (2) gitleaks NICHT installiert -- nur Ersatzwache ueber Credential-Muster (0 Treffer in 368 +Zeilen, Gegenprobe biss); (3) RAPL blieb auch mit Flag 0 lokal -- O-PMC-3(c)-Probe steht aus; (4) Neubau-Kosten des Flags nicht gemessen (CEB-ONLY-Klassenaussage nur an Quelle geprueft); (5) branch_misses strukturell 0 (M-3a): falsche Zusage in cache_engine_builder_iterator.hpp:499 "ERHEBT branch_misses real" NICHT angefasst (B5(d) haengt am Owner-Entscheid) -- steht weiter im Quelltext, waehrend die Daten es widerlegen.
ORT: ce cache_engine_builder_iterator.hpp:499 (falsche Zusage) u.a.
SOLL/FIX: B5(d) nach Owner-Entscheid; gitleaks-Lauf mit Originalwerkzeug nachholen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: O-PMC-3; T2-A-Hoheit builder_iterator

### [w8v4vkn3p.json] 61
GEGENSTAND: ADVERSARIAL-VERDIKT 1 (LUECKE GEFUNDEN, 4 Klassen): Der B2-Test prueft TEXT, der Bau folgt SEMANTIK. L1 (schwerste): angehaengtes " -UCOMDARE_ENABLE_PMC" hinter dem Flag laesst Test gruen (64/64), aber real COMDARE_ENABLE_PMC:BOOL=OFF -> NullPmcSource, alle HW-Spalten 0 -- exakt der Zustand, gegen den B2 gebaut wurde. L2: teilweise Umbenennung --target -> -t: Nenner sinkt still von 4 auf 2, EXPECT_EQ erfuellt; EXPECT_GT(driver_builds,0) faengt nur das Alles-oder-nichts-Verschwinden. L3: Paragraph-61-Debug-Zweig von keiner der 4 Plan-Konfigurationen erfasst (run_methodology=debug hat measurement_on=true; ?:-Sabotage cmake_build_type=="Debug" bleibt gruen) -- ein messender Modus faellt komplett aus der Wache. L4: kConfigure="cmake -B build" ist Substring-Suche, matcht jedes build* -- Configure-Dir und Bau-Dir nicht gegeneinander geprueft. WAS HAELT: naive Flag-Entfernung rot; Zwischenzeilen-Haertung haelt; beide Builder/Kanaele + Gegenprobe im Test real.
ORT: ce test_experiment_plan_director.cpp (Pruefer pmc_invariant) + experiment_plan_director.hpp:874/:912/:1233/:1386
SOLL/FIX: VERBATIM: "Tragfaehiger waere ein Pruefer, der (a) die Configure-Zeile parst statt sucht (Bau-Dir extrahieren, -D/-U in Reihenfolge auswerten, letzter Wert gewinnt), (b) den Nenner plan-unabhaengig gegen die Zahl der Mess-Jobs stellt, und (c) run_methodology=debug mit in die Kanalliste nimmt." Luecke 1+3 fensterkritisch (7-Tage-Messung mit pmc_available=1-Erwartung und strukturell 0 in allen HW-Spalten bei gruener Wache).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: M-2-Paket vor Landung nachbessern; Wurzel wie 16.07.: Pflicht haengt an Schreibweise statt Sache

### [w8v4vkn3p.json] 62
GEGENSTAND: ADVERSARIAL-VERDIKT 2 (LUECKE GEFUNDEN): CI-Kanal vollstaendig (6/6 bestaetigt; Korrektur: ce .gitlab-ci.yml hat 17 nicht 19 cmake -B-Zeilen), aber der BARE-METAL-KANAL (Paragraph 61 Dual-Weg) ist ueberhaupt nicht abgedeckt: CMakeGraphBuilder (:439) + TierCmakeGraphBuilder (:1593) emittieren 0 cmake-B-Zeilen, 1 bzw. 12 Treiber-Aufrufe via COMDARE_PLAN_DRIVER (davon 4 scharfe Messungen), COMDARE_ENABLE_PMC 0x erwaehnt; Treiber kommt aus aeusserem Configure, den der Plan nirgends auf PMC verpflichtet; Mechanismus fuer Hinweis-Zeilen existiert (:492-494, Combo-Hinweis) und wird fuer Nachbar-Pflicht benutzt; die neue Wache konstruiert 10/10 CiYaml-Builder, 0 CMakeGraph -- Auslassung ist Reichweite, nicht Unkenntnis. Repro: Bare-Metal-Bau ohne Flag -> nm LinuxPerfPmcSource=0/NullPmcSource=10; tier cmake emittiert 4 scharfe Mess-COMMANDs auf genau diesen Treiber ohne Meldung; #37-Preflight existiert im CMake-Kanal gar nicht (grep pmc_smoke = 0). ENTLASTUNG nachgeholt: add_compile_definitions verzeichnis-skopiert, main.cpp bekommt Makro nicht -- folgenlos, make_pmc_source() liegt in ce-Fassaden-TU (nm/strings-Doppelbeweis).
ORT: ce experiment_plan_director.hpp:476-497,:510,:1596-1613,:1743,:1756,:1800,:1818 + test :2244-2290
SOLL/FIX: VERBATIM empfohlener Schnitt: "(1) im CMake-Kanal die Hinweis-Zeile analog :492-494 emittieren (Stufe 1 UND Stufe-2-Kopf ...) und im Stufe-2-Kopf in die Eingabe-Liste aufnehmen. (2) expect_pmc_invariant um eine Kanal-Variante erweitern, die fuer CMakeGraphBuilder/TierCmakeGraphBuilder den Nenner 'Treiber-Aufrufe (COMDARE_PLAN_DRIVER)' zaehlt und verlangt, dass die Emission die PMC-Auflage benennt. (3) Kommentar :281-284 / :2134-2136 korrigieren (die zitierte super-Stelle BAUT den Treiber -- analyse:thesis-data :386/:388). (4) super Code/MANUAL_RUN.md:20/71/72 auf denselben Stand wie ce CMakeLists.txt:57-84 ziehen."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Paragraph-61-Dual-Weg; super-Nenner: Treiber-Bau-Zeilen .gitlab-ci.yml:388,421,731,822 + gh-actions ci.yml:27 + Archiv :95; geflaggt nur :729/731 + :820/822; B5-Doku-Drift super MANUAL_RUN.md nur im ce geheilt

### [w8v4vkn3p.json] 63
GEGENSTAND: ADVERSARIAL-VERDIKT 3 (DREI LUECKEN, eine ist HEUTE realer Zustand der Mess-Lane): L1 Teilverfuegbarkeit wird als pmc=ok testiert -- Smoke fordert >=1 Counter statt alle moeglichen; auf AMD 9950X3D ist LL/L3 ENOENT (strace + perf-Gegenprobe literal), Produktiv-CSV 20260726-164259-d03-strukt-r-erstbeleg: 16/16 Zeilen pmc_available=1 UND pmc_cache_misses_l3=0; B5-Doku-Korrektur (Kopf linux_perf_pmc_source.hpp "DREI generische Counter ... ehrlich LL") ist auf der Haupt-Mess-Lane damit selbst wieder falsch -- im Anhang stuende L3 als gemessen. L2 RAPL erkauft das Testat: linux_perf_pmc_smoke.cpp:115-116 zaehlt energy_micro_joules (sysfs-Lesung, kein PMC) in any_counter; S4-Szenario (Counter offen, alle 0, RAPL lesbar auf root-Executor) -> SMOKE_OK, ctest-Exit 0, mehrtaegiger Lauf startet mit null HW-Zaehlern. L3 m3v2_pmc_smoke.cpp:87 blind sobald available==1 (pmc_seam_ok unabhaengig von Werten). NEBENBEFUND: ctest -L <label ohne Treffer> = Exit 0 ("No tests were found!!!") -- Preflight liefe bei Label-Umbau still gruen; --no-tests=error kostet nichts. Trennmatrix 6 Zustaende gemessen (BASELINE/S1-S5).
ORT: ce linux_perf_pmc_smoke.cpp:115-116 | m3v2_pmc_smoke.cpp:87 | linux_perf_pmc_source.hpp:219,:302,:305
SOLL/FIX: VERBATIM empfohlene Reparatur: "(1) linux_perf_pmc_smoke.cpp:115 -- delta.energy_micro_joules aus any_counter streichen. RAPL ist kein PMC. (2) Die Quelle muss ihre Teilverfuegbarkeit ausgeben ... opened_mask auf der IPmcSource-Naht, dann kann der Smoke fordern: jeder geoeffnete Counter liefert !=0, und die Zahl der geoeffneten Counter wird namentlich ins Testat geschrieben (pmc=ok l1=1 ll=0 dtlb=1 statt pmc=ok). (3) Owner-Entscheid ...: ist LL=ENOENT auf AMD ein harter Abbruch oder ein deklarierter honest-0-Posten? Empfehlung: kein Abbruch, aber Pflicht-Deklaration ... (4) m3v2_pmc_smoke.cpp:87 -- bei kPmcExpected zusaetzlich !counters_all_zero fordern. (5) --no-tests=error an den Preflight-ctest."
STATUS LT. QUELLE: offen (Owner-Entscheid Punkt 3; Rest Bau)
ABHAENGIGKEIT/FLAECHE: Anhang-Spalten-Deklaration (L3 lane-abhaengig); ohne Reparatur "ist der Trigger ein Blindflug"

### [w8v4vkn3p.json] 64
GEGENSTAND: K-4 Zugriffs-Beweis aus 10 echten Job-Traces (Projekt 286, GitLab-API, alle HTTP 200): pmc:amd/pmc:intel je 5 Laeufe, 10/10 success, 0/10 allow_failure; beide Lanes perf_event_paranoid=1; beide bauen literal mit -DCOMDARE_ENABLE_PMC=ON; pmc_available=1 literal (AMD 365148:431, Intel 365149:457); cache_misses_l1 != 0 in 9/10 Traces (AMD 5/5 ~4.19M, Intel 4/5 ~6.6M). Spalten-Bilanz: l1+dtlb REAL beide Lanes; cache_misses_l3 honest-0 auf AMD 5/5, REAL auf Intel 4/5 (=> LANE-ABHAENGIG zu fuehren, Plan-Tabelle "REAL als Last-Level" gilt nur prod2); l2+coherence honest-0 10/10; branch_misses nicht einmal erhoben (keine delta.branch_misses-Zeile, CSV nonzero=0); energy honest-0 10/10, Ursache UNGEPRUEFT.
ORT: GitLab Projekt 286, Jobs 365148/365149 (Pipeline 15099) u.a.; Traces /tmp/k4_trace_<jobid>.txt
SOLL/FIX: RAPL-Probe einbauen: VERBATIM "Eine dritte Zeile im selben Muster -- ls -l /sys/class/powercap/intel-rapl:0/energy_uj; cat /sys/class/powercap/intel-rapl:0/energy_uj || true -- laeuft dann automatisch auf BEIDEN Lanes ... exakt M-3d aus 20260806-PLAN-messkette-ceb-observabletier.md Abschnitt 2.1" (an .bare_metal.before_script, .gitlab-ci.yml:92-93).
STATUS LT. QUELLE: teilweise (Faehigkeits-Beweis erbracht; RAPL-Frage UNGEPRUEFT/offen)
ABHAENGIGKEIT/FLAECHE: Traces = Vor-B3-Stand (77ed15fa/b241a272 enthalten B3 nicht; 90bca126 kein Nachfahre von 77ed15fa); B1 bleibt noetig (Faehigkeits-Lanes belegen nicht, dass der Mess-Lauf das Flag setzt)

### [w8v4vkn3p.json] 65
GEGENSTAND: K-4 F-2: Die fail-open-Wache W2 hat in freier Wildbahn gefeuert und der Job blieb gruen: Job 364757 (pmc:intel, Pipeline 15071, success): delta.available=0, "SMOKE_SKIP (no PMC access -- honest available=0)" -- 1 von 5 Intel-Laeufen = ~20% Trefferquote. F-2b: Anti-Korrelation der beiden Smokes auf prod2 in 5/5 Intel-Laeufen (m3v2 vs. linux_perf widersprechen sich; AMD 0/5); Hypothese t_running==0 auf hybrider P/E-Core-CPU i9-12900K -- UNGEPRUEFT.
ORT: Job-Trace 364757:430,:437
SOLL/FIX: O-2/B3 schliessen den Zustand; Zahlen-Beleg zu O-PMC-2 nachtragen (deckt sich mit wn7jy2yah Fund 33).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: B3/B4-Landung; O-PMC-2

### [w8v4vkn3p.json] 66
GEGENSTAND: PROZESS-WARNUNGEN aus den Verdikten: (a) Branch b-m2-pmc-invariante wanderte WAEHREND der Pruefung weiter (HEAD 90bca126 statt 4fd42896; dazwischen 6ddd7fd4 + Merge, fremder Agent b-genroots-explore, nur cmake/catalog_codegen.cmake +18/-1; PMC-Flaeche unberuehrt) -- Bau-Berichts-Aussage "nicht gepusht, nicht gemergt, rev-list=1" gilt so nicht mehr; (b) Verdikt-3-Pruefer fand ' M experiment_plan_director.hpp' im Arbeitsbaum: Diff traegt "// ADVERSARIAL-PROBE V2 (temporaer, wird zurueckgenommen)" (--target -> -t + Flag -> std::string{}), mtime 21:22 = paralleler Pruefer an DERSELBEN Arbeitskopie; bewusst nicht zurueckgesetzt -- VERBATIM: "Wer den Baum schliesst, muss diesen Rest von jenem Agenten abholen."
ORT: ce Arbeitskopie b-m2-pmc-invariante (Stand 06.08. ~21:22)
SOLL/FIX: Vor Landung des Zweigs den ADVERSARIAL-PROBE-Rest pruefen/entfernen; Ein-Schreiber-Regel.
STATUS LT. QUELLE: offen (Restzweifel am Arbeitsbaum-Zustand)
ABHAENGIGKEIT/FLAECHE: Landung b-m2-pmc-invariante; EIN SCHREIBER JE WORKTREE

## Datei wykmftn98.json (Explore: Micro/Macro/Wallclock-Zuordnung + HW-Flag-Grammatik "cpe" im Versions-Stempel; 4 Lose, Refs 85847715/aa223961)

### [wykmftn98.json] 67
GEGENSTAND: Benchmark-Ebenen GEPLANT+BEANTWORTET (Owner-KERNe 11+12, 06.08. 23:20/23:26/23:28 + 07.08. 09:20:41): MICRO = eine Organ-Achse ueber ihr Achsen-Interface, IN der Tier-Binary einkompiliert (Wallclock zusaetzlich in Tier, sonst CEB), gemischt Wallclock+PMC; MACRO(timed) = jeder Funktionsaufruf in der CEB-Kette am Pruefdock gegen die Tier-Binary, W-3/II-12 verbindlich zugunsten der STRENGEREN Form (Checkpoints INNERHALB der Ausfuehrung) entschieden ("Die Strengere Variante ist es"); MACRO large scope = ein Lastprofil ueber alle aufgerufenen Funktionen, aggregiert die Macro-Charts; NEU 07.08.: "Das Profil wird je Mess-Layer aufgezeichnet und in einem zeitlich orientierten chart als Profil abgespeichert, der formal als xlsx Messwerte gilt" (beantwortet O-3 Chart-Frage). Reihenfolge: methodisch Micro vor Macro vor LargeScope (Ungleichung Summe(E1)<=E2<=E3); Bau-Reihenfolge B-10<-B-9<-B-7/B-8<-Messung<-B-3/B-5; Zwei-Phasen-Op-Schleife ist HOMONYM (nichts mit der Kette). Stufigkeit: Mess=3, System=2, Organ=2 (Owner 05.08. abgenommen); alle drei Ebenen erben die EINE Mess-Stufigkeit.
ORT: Ledger :4580-4643 (Paragraph 11+12); Live-Transkript jsonl:11321 (09:20:41Z); Plan-Dokumente 20260806-PLAN-break-even-*.md u.a.
SOLL/FIX: - (dokumentierter Plan-Kanon)
STATUS LT. QUELLE: GEPLANT_UND_BEANTWORTET (Kanon)
ABHAENGIGKEIT/FLAECHE: Namenskollision beachten: Mess-Tooling-Registry definiert EIGENEN 'Micro'-Wert (Instrument statt Ebene, measurement_tooling_registry.hpp:30, "widerspricht F2" aktenkundig)

### [wykmftn98.json] 68
GEGENSTAND: IST-LUECKEN am Code (Ref 85847715, je mit Nenner): (1) Schritt-/Checkpoint-Instrumentierung INNERHALB eines Funktionsaufrufs existiert nicht (0 Treffer lap_ns/split_ns/phase_ns/stage_ns/step_ns/marker_ns/trace_point; Gegenprobe seg_ns=39 Dateien); fill_checkpoints{10,100,1000} sind Fuellstands-Stuetzpunkte, keine Ausfuehrungs-Checkpoints; nicht-bindender Vorschlag V-1..V-5 (Checkpoint=Achsen-Interface-Aufruf-Grenze, op_axis_lat[6][18]) liegt vor. (2) xlsx-Writer-Code: 0 Treffer unter libs/ (nur 3 Doku-Dateien); (3) Vierter Observer-Layer (Gattung/Genus, zeitlich geloggtes Profil je Interface-Aufruf): 0 Code, "T3, eigenes Design", Wege A/B/C unentschieden, VERBATIM "Dringlichkeit: bis Fr 14.08."; (4) MACRO-large-scope-Aggregat: 0 Treffer (Nenner 24 Dateien, Gegenprobe kurve|curve=36); (5) Break-Even-Persistenz: 0 Serialisierer (nur lokale std::vector-Rueckgabe); (6) Fuellstands-Trace-CSV exportiert hartkodiert NUR 2 von 18 Achsen (search_algo+allocator); (7) .measure( 8 Treffer ausschliesslich unter tests/unit/ = toter Produktionspfad.
ORT: ce tier_observe_trace_abi.hpp:34,:131,:180,:279-291; PLAN-messkette-ceb-observabletier.md:582,:934-947; PLAN-break-even:750-752
SOLL/FIX: Vierter-Layer-Owner-Entscheid O-4 (Wege A/B/C) bis Fr 14.08.; Checkpoint-Definition "Was ist ein Schritt/Checkpoint innerhalb einer Funktion?" (anderes O-4) offen; Format Spalten/Sheets/Achsen fuer Zeitreihe nirgends spezifiziert.
STATUS LT. QUELLE: offen (Bau + 2 Owner-Entscheide)
ABHAENGIGKEIT/FLAECHE: F1-Frist 14.08. (Vierter Layer); B-7/B-8-Bau-Kette

### [wykmftn98.json] 69
GEGENSTAND: xlsx-Bruecke ECHT_OFFEN: KEINE Quelle verbindet "Profil je Mess-Layer als zeitlich orientierter Chart" mit xlsx; a9-Sheet-Struktur (IErgebnisMappe::blatt(SheetSchluessel)) ist Zeile-pro-Messergebnis-Transkription der WIDE-CSV, kein Zeitreihen-/Checkpoint-Traeger, keine nativen Excel-Chart-Objekte; Break-Even-Dossier: "Es gibt keine Datenstruktur namens Chart/Diagramm im Mess-Kern"; O-6 Persistenz-Kandidaten (CSV-Sidecar/XML-Rueckschrieb/constexpr-Header) nennen xlsx NICHT. Die 3 Einzelbausteine (xlsx-Default; Drei-/Vier-Ebenen; korrelierte Zeitreihe) sind je real geplant -- ihre Verschraenkung ist als offene Owner-Entscheidung an 2 Stellen notiert.
ORT: ce docs/architecture/20260803-a9_xlsx_writer_f3_soll_design.md (559 Z., 0 Treffer chart/zeitlich); PLAN-break-even :287-295, O-6 :758-760
SOLL/FIX: Owner-Entscheid Verschraenkung Chart<->xlsx.
STATUS LT. QUELLE: ECHT_OFFEN
ABHAENGIGKEIT/FLAECHE: Owner-Aussage 07.08. 09:20:41 ("formal als xlsx Messwerte") ist die JUENGSTE Vorgabe -- Designer muss sie gegen O-6-Kandidaten harmonisieren

### [wykmftn98.json] 70
GEGENSTAND: Flag-Grammatik Q3 (02.08., dreifach ratifiziert Code/Ledger/Thesis): Versionen IMMER vX.Y.Z + GENAU EIN Hardware-Flag (c/g/f/n, Enum), optional 'e' (experimental, Pruefling-Markierung), Kurzform verboten, CPU-only: alle enden auf c oder ce; Migration vollzogen A13-M3/C4 03.08.; Parser nimmt GENAU EIN Zeichen (take_hardware_flag), 'cpe' wird HEUTE abgelehnt (Sentinel/consteval throw, Fehlerklasse "zweites Hardware-Flag"); POD-Kodierung 2 Bits. OWNER-AUSSAGE 07.08. 09:20:41 (O-F): "cpe ist ein Kuerzel wie g, e, f, n ebenfalls. Es erweitert das c CPU kuerzel einer Algorithmus-Versionierung im Stempel mit Spezifikationen. Es ist ein string und nicht nur ein character. Jeder Buchstabe steht fuer eine unterstuetzte Hardware Art, die durch die Systemachse freigegeben wurde an die Tier-Binary." = WOERTLICHER WIDERSPRUCH zur gebauten+Thesis-fixierten Ein-Zeichen-Grammatik (D_building_block_matrix.tex:1138 "genau ein Kleinbuchstabe") -- 'cpe' ist eine NEUE, nirgends dokumentierte Grammatik-Erweiterung (Suche ueber 4 Quellenstufen: 0 echte Treffer; letzter Hardware-Flag-Ledger-Eintrag Z.3647 vom 02.08.).
ORT: ce algo_semver.hpp (:182,:186-195,:287-294,:304-316,:391-405,:514-515) + abi/anatomy_stamp_entries.hpp (:24-29,:109-129,:492) | Thesis D_building_block_matrix.tex:1131,:1138
SOLL/FIX: Bauteile fuer cpe-Konformitaet (nach A13-Praezedenz): (1) Grammatik-Entscheidung: 5. Einzelzeichen ODER HWFLAG als 'hw_char [spec_suffix]' -- KOLLISION: Position nach dem HW-Flag ist durch 'e' belegt (B12-Wache "ce-Registry traegt nie e" bindend) -- zuerst aufloesen (Trennzeichen? Position? ...); (2) Parser-Umbau algo_semver.hpp (take_hardware_flag/take_flag_tail Mini-Grammatik; HardwareFlag Enum -> Verbund-Typ); (3) POD anatomy_stamp_entries.hpp: reserved uint32_t nur 6/32 Bit belegt, 26 frei -- sizeof=48 nicht zwingend gebrochen, aber deklariertes Byte-Ereignis mit neuer CT-Wachen-Batterie; (4) Wachen an allen 4 Registries + Meta-Meta-Zwilling; (5) Migration NUR falls verpflichtend, als EIN Byte-Ereignis. NENNER Bestand: 138 Literale (122 Organ + 3 System + 1 MetaMeta + 3 Tooling + 1 Framework + 1 Planer + 2 Probe + 5 PruefDock; 96x v1.0.0c, 24x v1.0.2c, 2x v1.0.1c), 0 mehrstellig.
STATUS LT. QUELLE: TEILWEISE_GEPLANT / offen (Semantik von cpe ECHT_OFFEN; Owner-Entscheid noetig)
ABHAENGIGKEIT/FLAECHE: Q3/A13-Praezedenz; Thesis-Text muesste mitziehen; B12-Wache; Stempel-POD

### [wykmftn98.json] 71
GEGENSTAND: Freigabe-Kette Hardware-Art TEILWEISE_GEPLANT: heute nur GLOBALE CPU-only-Politik (version_satisfies_cpu_only_policy an jedem ce-Literal), KEIN Code-Pfad, der eine System-Achse befragt ("welche Hardware-Art ist fuer DIESE Tier-Binary freigegeben?") und daraus das Organ-Flag ableitet/prueft; das Owner-beschriebene Muster existiert gebaut fuer die BENACHBARTE TargetIsa-Achse ("TargetIsa gibt die Ziel-ISA frei, Host-Gate prueft Lauffaehigkeit"); Erweiterungshardware-Achse (6. CEB-System-Achse, SIMD) bleibt CPU-intern, flache Form DEPRECATED, GPU nur "spaeter".
ORT: ce algo_semver.hpp:362-371,:387 | hardware_isa_system_axis.hpp:1-7 | extension_hardware_system_axis.hpp:1-23
SOLL/FIX: Differenzierender Mechanismus (mehrere Hardware-Arten je System-Achsen-Konfiguration) nicht gebaut -- Teil der cpe-Design-Frage (Fund 70).
STATUS LT. QUELLE: TEILWEISE_GEPLANT / offen
ABHAENGIGKEIT/FLAECHE: cpe-Grammatik; P/E-Core-System-Achse (core_class, gebaut @ aa223961, seit 16.07. geplant als DYNAMISCHE Unter-Achse unter der Hardware-Systemachse, Ledger Paragraph 16.3-E17)

### [wykmftn98.json] 72
GEGENSTAND: Session-Log-Beleg-Kette zu cpe (Los 4): Owner fuehrte 07.08. 07:39:30 den Tag "cpe" (cpu-performance-efficiency, Intel Cores) ein ("D-1: TOTAL FALSCH ... Die Tags sind bereits geplant, alles Gedaechtnisluecken"); Workflow wpmmeh33j bestaetigte System-Achsen-Verortung seit 16.07. geplant+gebaut, Token 'cpe' aber 0 echte Code-Treffer; der Lead rahmte 'cpe' FEHLERHAFT als CSV-Spalten-Frage (ZWISCHENSTAND-Datei :70-74 + Ledger-Rueckfrage 09:11:43); Owner-Korrektur 09:20:41 (O-F, Fund 70) stellte klar: Versions-Stempel-Grammatik, nicht Mess-/CSV-Spalte; "Option B ebenfalls korrekt, aber der Kern der Frage ist total verkehrt."
ORT: Live-Transkript jsonl:10772,:10833,:10874,:11317,:11321,:11333/11343 | docs/sessions/20260807-ZWISCHENSTAND-aufgeloeste-architektur-entscheide.md:70-74 (traegt die Fehlrahmung!)
SOLL/FIX: ZWISCHENSTAND-Datei-Fehlrahmung korrigieren (Lead-Fehler dokumentiert in jsonl:11333/11343).
STATUS LT. QUELLE: offen (Doku-Korrektur der Fehlrahmung)
ABHAENGIGKEIT/FLAECHE: cpe-Design (Fund 70)

### [wykmftn98.json] 73
GEGENSTAND: "Drittes Glied"-Feinpunkt offen: zwei dokumentierte, vom Owner textlich nicht entschiedene Lesarten von "Wallclock = das dritte Glied" koexistieren -- (i) drittes von acht/neun Gliedern im Stempel-/Fingerprint-Preimage (anatomy_fingerprint.hpp:341,428-431 Glied[3]), (ii) drittes Kettenglied Planer->CEB->Tier. Kernaussage (WO der Timer lebt) vollstaendig geklaert; nur dieser Feinpunkt offen. Zusatz-Hinweis Quelle: "Der zweite Satz -- die Verortung -- fehlt bis heute in der Ledger-Konsolidierung, weil er sechs Minuten nach dem Konsolidierungsauftrag eintraf" (GESAMTDOSSIER:2831).
ORT: DOSSIER-messachse-wallclock-und-mess-kette.md Paragraph 8.3 :350-359
SOLL/FIX: Owner-Entscheid des Feinpunkts; KERN-12-Satz-2 in Ledger-Konsolidierung nachtragen.
STATUS LT. QUELLE: offen (Feinpunkt)
ABHAENGIGKEIT/FLAECHE: Ledger-Konsolidierung

## Datei wisfvjd8z.json (VIER-LEDGER-AUDIT 07.08.: vermisst das Gesamt-Ledger unbearbeitete Arbeit? 43 Roh-Funde = 36 Unikate; Diff gegen lebenden Stand wt-super-landung)
WICHTIG fuer Dedup: Die 43 Roh-Funde (Items 0-42) wurden vom Diff-Teil gegen den LEBENDEN Stand geprueft; 14 sind VORHANDEN/entschieden (Bruecken-Register unten, Fund 87), 7 TEIL, 13 echt offen, 2 Owner-Fragen, 5 erledigt-nicht-abgehakt. Die operative Wahrheit sind L-1..L-11 + 5 Owner-Fragen (Funde 79-86). Roh-Funde hier dennoch einzeln extrahiert (Redundanz OK).

### [wisfvjd8z.json] 74 (Roh-Funde 0-16, Kurzregister mit Diff-Status)
GEGENSTAND: (0) A15/Paragraph-55-Gesamt-Reconcile nie ueberfuehrt, "prominentester Verlust" -> Diff: Reconcile IST vollzogen, aber NUR im Session-Doc (s. L-5). (1) #152/V-08 branch_misses als erledigt gefuehrt, am Objekt widerlegt ("von KEINER Quelle je geschrieben"; Kommentar cache_engine_builder_iterator.hpp:499-500 falsch) -> L-2. (2) FF0-Multi-Plattform "Abgabe-Blocker" + Anhaenge-B/E-Stubs "superseded?" nie beantwortet -> L-9. (3) GN-9 Kalibrier-/Feasibility-Gate vor 2^17-Voll-Matrix ohne Slot -> Diff: SUPERSEDED durch ETA-Erst-Batch-Abnahme (DOSSIER:3340). (4) M-8/M-9/M-15 Auswertungs-Writer, Anhang A haengt daran -> Diff: ENTSCHIEDEN Anhang A in die Abgabe; M-9 JETZT verdrahten, M-8/M-15 nach echtem Korpus (DOSSIER:2602-2606 R-5). (5+20) #327 Vault-PAT-Rotation widerspruechlich -> Diff: Owner-terminiert "nach Messfenster" (E5), mittag-19-Zeile SUPERSEDED; prod1/prod2-PW-Rotation 07.08. betraf ANDERES Credential. (6) O-A Bau-/Mess-Matrix-Umfang (524288 vs 2097152, keine Kappung) -> Diff: entschieden via D-3 ("nur die 320er"), Restfragen D-2/R-4. (7) KK-5/P-1 allow_failure am Voll-Mess-Batch (director :1373) -> Diff: getrackt als D-4 (T1) + O-PMC-1 "allow_failure raus". (8) PMC-Bauposten B-1..B-10 ohne Statusverfolgung + Namenskollision mit B1-B13 -> Diff: numa/core_class GELANDET (ce aa223961), Rest 16.7-B1..B6 + D-5; I-PMC-2/3 nach Abgabe. (9) N-1 Frist 15.09. ohne Ledger-Fortsetzung -> Diff: verankert (morgen-1 B-5a). (10) E-07/B10-Abnahmekriterien K1-K5/N1-N3 nur einmalig -> Diff: normative Gate-Definition in DOSSIER:2231-2249. (11+39) A11 ccache-Allowlist-Drop Owner-Entscheid aus -> Owner-Frage 1. (12+40) A12/E-14 NAS-Creds Owner-Frage offen -> Owner-Frage 2. (13+35) A10 HW-Erkennung P4-P6 T2-vs-T4-Fensterfehler -> L-3. (14) N-6 XML-Trennung Bau-/Mess-Menge (Owner-Regression) -> Diff: getrackt als R-2 (T1) inkl. Mess-Slicing 4096 (LEDGER:7571). (15) DEG-3 composed_masstree_search.hpp 0x for_each_record trotz eingetretener Nachzieh-Bedingung -> L-11. (16) REV-CXX/-DATA/-CI/-TEX 30 Review-TODOs (P0 "vor jeder wissenschaftlichen Vollmessung") -> Diff: getrackt als P-1 DRINGENDST (DOSSIER:1125-1132).
ORT: Ledger-/Dossier-Anker je Item in Quelle; Code: cache_engine_builder_iterator.hpp:499-500, hardware_probe_factory.hpp:118/:331-333, experiment_plan_director.hpp:1368-1373
SOLL/FIX: siehe L-Posten + Bruecken-Register (Funde 79-87).
STATUS LT. QUELLE: je Item (siehe GEGENSTAND)
ABHAENGIGKEIT/FLAECHE: Ledger/Register-Buchfuehrung; Mess-Trigger-Fenster

### [wisfvjd8z.json] 75 (Roh-Funde 17-26)
GEGENSTAND: (17+34) Pfad-Diskrepanz/stale Checkouts: offizieller Pfad ~/Projekte/.../probst-diplomarbeit-cache-engine steht auf b-ci-rueckschrieb-beide-zeiger (super, 18a0bdf3) bzw. b-m2-pmc-invariante (ce, 90bca126); Ledger dort 7248 Zeilen, lebender Stand NUR in /home/comdare/wt-super-landung (development, 7615->7723 Zeilen waehrend des Audits) -> L-4. (18) A15 zum ZWEITEN Mal verloren, fehlt auch in mittag-2 -> L-5. (19) B-6-Restliste (O-1/PMC, O-3/F6, O-4/F8, O-B, O-PMC-2, N-1..N-3, R-6, E-1..E-5, E11) fehlt in Vollkonsolidierung mittag-2 -> L-8. (21) E-18 anhang:forward ("HAUPT-ZIEL des Gesamt-Systems") Aktivierungsstatus verschwindet aus 07.08.-Abschnitten; Job inert-by-default (:1115 COMDARE_ANHANG_FORWARD); R2-Ziel-Branch-Frage offen -> Diff: getrackt mit Fehlglied-Liste (Push nach anhang/, 289-Write-Token, Post-measure-Rebuild) + Trigger-Kopplungs-Empfehlung (b). (22) Namenskollision R-2 (E-18-Ziel-Branch 06.08. vs. XML-Trennung/4096er 07.08.) -> L-11: aeltere Kette fortan R2-ZIELBRANCH. (23) D-4-ID-Kollision: kCebFingerprint-Injektivitaet (ANGEBOT statt einkompilierter WAHL; zwei CEBs [wallclock]/[macro] tragen denselben ceb_key_sha512; bricht Owner-KERN F6/Paragraph 58-V) ohne Aufloesung, ID D-4 neu belegt (allow_failure) -> L-6, NEUE ID D-4-ALT-FPRINT; am Objekt ceb_version_stamp.hpp:159-161 pruefen BEVOR Fingerprint als Provenienz in Messdaten reist. (24) Scheibe-6/F3 Weg a (ce-Umbenennung) vs. Weg b offen -> Diff: bindend sequenziert B14/NB3 -> Weg a -> F5; Rename NACH der Abgabe (DOSSIER:2706-2716). (25) V-02 A14 FF0 -> L-9. (26) prt-art M3: E-24-Container-Gattungs-Zuordnung fuer Pruefling-Slots (alle 5 Achsen genus=SearchAlgorithm); ABI-Fenster (Major 7->8, Magic .A7.->.A8.) bereits GESCHLOSSEN -> Owner-Frage 3.
ORT: siehe GEGENSTAND; prt-art-Ledger :167-180
SOLL/FIX: siehe L-Posten + Owner-Fragen.
STATUS LT. QUELLE: je Item
ABHAENGIGKEIT/FLAECHE: E-24-ABI-Fenster; wt-super-landung als kanonische Quelle

### [wisfvjd8z.json] 76 (Roh-Funde 27-33)
GEGENSTAND: (27) thesis C1-Rest: Verifikation der Rahmen-Pass-Entwuerfe 761cecc (Danksagung/Sperrvermerk/Lizenz-Matrix/EN-Abstract-Sync/F10) super-seitig 0 Treffer, obwohl "Statusfuehrung super-seitig" delegiert -> L-7. (28) thesis T5: Cross-Repo-Lizenz-Matrix-Konsistenzpruefung vor Abgabe -- super-Ledger 0 Treffer -> L-7. (29) prt-art M1: LICENSE erst seit 7f6c703 (02.08.), Repo seit 12.05.; SPDX-Header 28/68 -> L-7 + Owner-Frage 5. (30) prt-art M2a/b/c: Ergebnis-Weg ins Paragraph-59-Mess-Schema, fehlendes Versions-Attribut der generierten Registry (c/ce-Flag-Pflicht D2 nicht abbildbar), golden_wired="false" bei 4/5 Achsen Soll? -> L-7 + Owner-Frage 4. (31) 1 gtest_discover-Insel builder/commands (seit F75-Audit 16.07.) nirgends verbucht -> L-11. (32) ce B4.1 MinGW/ESET blockiert, nie geschlossen -> L-11: als OBSOLET markieren (Messkette laeuft ueber prod1/Cluster). (33) F-01/Talos-Reparaturanweisung widerspricht sich am selben Tag: morgen-1 (LEDGER:7256) "DRITTER WEG = Rollentrennung, nichts streichen" vs. mittag-2 (LEDGER:7491) "Tempus/Status praezisieren -- NICHT streichen, NICHT Rollentrennung"; Dossier 17.9 A-1 uebernimmt Rollentrennung -> L-1 BLOCKIEREND.
ORT: thesis-Ledger :70,:79-80,:143-145; prt-art-Ledger :141-165; ce-Ledger :167,:210; LEDGER:7256 vs :7491
SOLL/FIX: siehe L-Posten.
STATUS LT. QUELLE: je Item
ABHAENGIGKEIT/FLAECHE: Freitag-1-PDF-Edit (F-01); Lizenz-Schluss-Pass

### [wisfvjd8z.json] 77 (Roh-Funde 35-42)
GEGENSTAND: (35) A10 T2-vs-T4 (Dossier stuft herab, Ledger Z.5244 sagt T2; Namenskollision A10/E-3 MSVC im Register) -> L-3. (36) T-9 Min/Max-Katalog break_even.hpp: Ledger mittag-2 "Der Kurvenvergleich ist fuer JEDE Max-Achse systematisch FALSCH HERUM. Hoechste Prioritaet." vs. Dossier T4-Sammeltopf -> Diff: Ledger fuehrt korrekt "hoechste Prio", nur aeltere Dossier-Landkarte ueberholt; VOR der ersten Auswertung gegen eine Max-Achse ziehen. (37) V-8 w2b-E04-P1: Fold-Behauptung (LEDGER:3656 "zur Falte 037300a6 vereinigt") von git cherry widerlegt (92ad8357+63406ce3 weiter '+' = NICHT in development) -> L-10: Entscheid nachziehen-oder-superseden faellig. (38) V-6 B12/xlsx-Writer: zwei falsche Entlastungszeilen (LEDGER:7016 "xlsx-Writer braucht KEINE Aenderung", :7096 Rueckstufung) stehen unveraendert; Writer EXISTIERT NICHT (0 Treffer in 1583 libs/-Dateien); Owner hat B12 dreimal verlangt ("CSV laesst sich schlechter auswerten, das muss auch noch mit in die Abgabe vor der Messung") -> L-10: Zeilen als ERLEDIGT-STALE markieren, Writer bauen. (39) A11 -> Owner-Frage 1. (40) A12-Dossier-Formulierung "0 Treffer in Ledger+Register" fuer Ledger-Teil widerlegt (real 4 Treffer; nur Register=0) -> praezisieren. (41) V-9 Thesis-Klon: Fetch nachgeholt (07:33), lokaler FF auf 19e1592 fehlt -> L-11: FF ziehen oder Klon offiziell stilllegen. (42) V-7 b-e18-snap geparkt ohne Register-Zeile/Wiedervorlage-Anker -> Diff: geparkt MIT Anker "NB3 im P4-Fenster" (DOSSIER:3220-3222).
ORT: siehe GEGENSTAND
SOLL/FIX: siehe L-Posten.
STATUS LT. QUELLE: je Item
ABHAENGIGKEIT/FLAECHE: Phase-6-Auswertung (T-9); development-Merges

### [wisfvjd8z.json] 78
GEGENSTAND: Diff-Bilanz: 43 gemeldete Posten = 36 Unikate (7 Doppelmeldungen: A15, #327, FF0, A10, A11, A12, Pfad/Checkouts); 14 VORHANDEN unter anderem Vokabular/entschieden, 7 TEIL-vorhanden mit Handlungsrest, 13 ECHT fehlend/widerspruechlich, 2 getrackte unbeantwortete Owner-Fragen; echte Widersprueche nach Pruefung 5 (statt 14 gemeldet); Erledigt-aber-nicht-abgehakt 5 (#327, GN-9, O-A/D-3, Anhang-A/M-Writer, V-9-Fetch). Methoden-Notiz VERBATIM: "Verlust-Audits MUESSEN gegen wt-super-landung UND das Gesamt-Dossier UND alle vier Teil-Ledger laufen, sonst produzieren sie genau die Falschbefunde, die sie suchen."
ORT: wisfvjd8z result.diff
SOLL/FIX: empfohlener Nachtrag "NACHTRAG 07.08.2026 nachmittag-1 -- VIER-LEDGER-AUDIT" liegt komplett formuliert in der Quelle (Bruecken-Register + L-1..L-11 + 3 Owner-Fragen-Sektion).
STATUS LT. QUELLE: Audit fertig; Nachtrag-Eintragung offen
ABHAENGIGKEIT/FLAECHE: Ledger wt-super-landung

### [wisfvjd8z.json] 79 (L-1, BLOCKIEREND)
GEGENSTAND: F-01 Talos DREIFACH-Widerspruch (Rollentrennung vs. Tempus/Status) ueber Ledger morgen-1, Ledger mittag-2, Dossier 17.9 A-1; der <1h-Freitag-1-Edit schreibt in die Abgabe-PDF (3 wirksame + 4 Drift-Stellen DE+EN).
ORT: LEDGER:7256 vs :7491 vs DOSSIER:3368-3371
SOLL/FIX: VERBATIM: "GELTEND nach Quellen-Rangfolge (neuester Stand schlaegt aelteren): mittag-2 = Tempus/Status praezisieren. VOR dem <1h-Edit Supersede-Vermerk an morgen-1 Sec.1 und Dossier 17.9 A-1 anbringen -- sonst geht die falsche Fassung in beide Sprachfassungen + 4 Drift-Stellen der Abgabe-PDF."
STATUS LT. QUELLE: offen, BLOCKIEREND
ABHAENGIGKEIT/FLAECHE: KONFLIKT zu wn7jy2yah Fund 29 (der die Rollentrennungs-Fassung als beschlossen fuehrt!) -- Designer muss die juengste Owner-Linie klaeren

### [wisfvjd8z.json] 80 (L-2, HOCH)
GEGENSTAND: branch_misses: Dossier widerspricht sich selbst (17.8 "V-08 ... L1/L3/branch_misses real" vs. 16.7 "KEINE PMC-Quelle weist das Feld je zu ... Entweder B6 ODER Zusage zuruecknehmen -- beides NUR vor dem Lauf; nach dem Trigger ist die Spalte fuer diesen Datensatz endgueltig 0"); Entscheid D-6 steht im falschen Verfallsfenster (T4 statt vor dem Lauf); Task #8/Register fuehren als erledigt.
ORT: DOSSIER:3338 vs :2744-2748 vs :3398
SOLL/FIX: VERBATIM: "17.8-Zeile korrigieren; D-6 nach T1 ziehen; Task-#8-/Register-Eintrag von 'erledigt' auf OFFEN zuruecksetzen."
STATUS LT. QUELLE: offen, HOCH (vor Messlauf)
ABHAENGIGKEIT/FLAECHE: Mess-Trigger; deckt sich mit w8v4vkn3p Fund 60(5)

### [wisfvjd8z.json] 81 (L-3, HOCH)
GEGENSTAND: A10 HW-Erkennung P4-P6 (CSV-Provenienz-Spalten, Mess-Stempel-Segment): Fensterfehler -- eigene Auflage "fuenfmal Pflicht vor Trigger", platziert im T4-Topf; LEDGER:5244 sagt T2 = vor Voll-Messung; dritter Beinahe-Verlust desselben Postens; Code sagt selbst "nicht gebaut" (hardware_probe_factory.hpp:118, :331-333).
ORT: DOSSIER:3402-3403 vs LEDGER:5244; ce hardware_probe_factory.hpp
SOLL/FIX: VERBATIM: "Ins T1/T2-Fenster ziehen und bauen, oder mit Begruendung ausdruecklich zurueckstufen."
STATUS LT. QUELLE: offen, HOCH (vor Messlauf)
ABHAENGIGKEIT/FLAECHE: Messdaten-Provenienz dauerhaft fehlend, wenn nicht vor Trigger

### [wisfvjd8z.json] 82 (L-4, HOCH)
GEGENSTAND: Hauptcheckouts stale (V-10): super auf b-ci-rueckschrieb-beide-zeiger, ce auf b-m2-pmc-invariante; offizieller Ledger-Pfad 7248 Zeilen vs. lebend 7723 (wt-super-landung development@8b56f948); "URSACHE der Falschdiagnosen, nicht Kosmetik".
ORT: /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine (Hauptcheckout) vs /home/comdare/wt-super-landung
SOLL/FIX: VERBATIM: "development-FF beider Hauptcheckouts (Arbeitsbaum-Diffs laut BILANZ inhaltlich dupliziert); bis dahin gilt: JEDE Ledger-Lesung NUR gegen wt-super-landung."
STATUS LT. QUELLE: offen, HOCH
ABHAENGIGKEIT/FLAECHE: alle Audits/Agenten am offiziellen Pfad

### [wisfvjd8z.json] 83 (L-5, HOCH)
GEGENSTAND: V-01..V-20-Disposition (Paragraph-55-Reconcile) existiert NUR im Session-Doc (DOSSIER:3333-3343: 10 UEBERNOMMEN / 4 SUPERSEDED / 5 BEREITS ERLEDIGT / 1 OWNER-ENTSCHEID), keine Ledger-Zeile; V-08-Zeile darin nachweislich falsch; ohne Ledger-Bruecke faellt die 20er-Liste beim naechsten Fold zum DRITTEN Mal aus; Einzel-Dispositionen V-02 und V-13..V-19 nicht ausgewiesen.
ORT: DOSSIER:3333-3343; LEDGER Z.7250-7723 = 0 Treffer A15/wf_abbabbb4/V-0[1-9]
SOLL/FIX: Nachtrag als Ledger-Bruecke eintragen; beim naechsten Registerpass V-02 + V-13..V-19 einzeln ausweisen.
STATUS LT. QUELLE: offen, HOCH
ABHAENGIGKEIT/FLAECHE: Ledger-Fold-Mechanik (Falle Session-Doc != Register)

### [wisfvjd8z.json] 84 (L-6, MITTEL)
GEGENSTAND: D-4-ALT kCebFingerprint-Injektivitaet: Fingerprint rendert das ANGEBOT der Registry statt der einkompilierten WAHL; gleicher ceb_key_sha512 fuer [wallclock] vs [macro]; bricht Owner-KERN F6 auf CEB-Ebene (Paragraph 58-V); keine Aufloesungs-Zeile, ID D-4 neu belegt; Dossier mildert nur ("kein Gate vergleicht ihn"), Fingerprint reist als Provenienz in die Messdaten.
ORT: LEDGER:4728; ce ceb_version_stamp.hpp:159-161
SOLL/FIX: NEUE ID D-4-ALT-FPRINT; am Objekt pruefen BEVOR der Fingerprint als Provenienz in Messdaten reist.
STATUS LT. QUELLE: offen, MITTEL (vor Messlauf pruefen)
ABHAENGIGKEIT/FLAECHE: CEB-Schluessel-Welt; F6

### [wisfvjd8z.json] 85 (L-7..L-11, MITTEL/NIEDRIG)
GEGENSTAND: L-7 Satelliten-Ledger nicht konsolidiert (prt-art M1/M2a-c/M3, thesis C1-Rest/T5; Owner-KERN E-02 bestaetigt; M3 fensterkritisch) -- BUENDEL-VORSCHLAG: EIN Lizenz-/Rahmen-/Pruefling-Schluss-Pass vor 15.09. L-8 B-6-Restliste Einzel-Disposition fehlt (nur R-3, O-B/W-3, O-4, R-6 geklaert) -- Dispositions-Pass ueber UEBERBLICK:304-337. L-9 FF0/A14-Bruecke gesetzt (gedeckt durch Plattform-Matrix mittag-2 Sec.2.5 + O-C=21 Images + Pilot-Entscheid); OFFEN am Objekt: sind Anhang B/E noch 4-Zeilen-Stubs, wo lebt das Mess-Manifest? L-10 zwei stale xlsx-Entlastungszeilen als ERLEDIGT-STALE markieren + B12-Writer bauen + V-8-Entscheid. L-11 Hygiene: R-2-Doppelbelegung (aeltere Kette -> R2-ZIELBRANCH), DEG-3, gtest_discover-Insel, B4.1 MinGW/ESET obsolet markieren, V-7-Registerzeile, V-9-Klon-FF, M-9-Verdrahtung in Bau-Rueckstands-Liste, Dossier 17.9 T-9/T-10 stale.
ORT: siehe Einzelanker in Funde 74-77
SOLL/FIX: VERBATIM Reihenfolge: "L-1-Supersede-Vermerke VOR dem Freitag-1-Edit; L-2/L-3 ins T1-Fenster; L-4 Checkout-FF; Owner-Fragen 1-5 in die naechste Owner-Runde; L-7-Buendel als T3-Paket."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: 15.09.-Lieferkette

### [wisfvjd8z.json] 86 (Owner-Fragen 1-5)
GEGENSTAND: (1) A11 ccache-Allowlist: Plan 02.08. will .gitleaks.toml-Eintrag weg, Code-Kommentar 27.07. sagt er MUSS bleiben (Job waehlt bei Projekt-toml AUSSCHLIESSLICH diese; Entfernen schaltete Secret-Scanning faktisch ab) -- Empfehlung: A11 zurueckziehen, Code-Kommentar gilt. (2) A12/E-14 NAS-Creds backup1/backup2: gilt/erledigt/verworfen? -- bei 'gilt' als T3 vor 15.09. (3) prt-art M3/E-24: Nicht-Zuordnung von Container-Genus-Slots bewusst? ABI-Fenster zu; spaeterer Touch entwertet Voll-Bau-Bestand -- bestaetigen ODER fuers naechste ABI-Fenster (nach 15.09.). (4) prt-art M2c golden_wired=false Soll? -- Empfehlung: fuer Abgabe belassen, M2a/M2b als T4. (5) prt-art M1a Lizenz-Rueckwirkung vor 7f6c703 -- Empfehlung: Apache-2.0 rueckwirkend per NOTICE, Halter BEP Venture UG analog Rahmen-Entscheid 02.08.
ORT: .gitleaks.toml:24-29; prt-art-Ledger :141-180; thesis-Ledger :143-145
SOLL/FIX: in die naechste Owner-Runde.
STATUS LT. QUELLE: offen (Owner)
ABHAENGIGKEIT/FLAECHE: Security (A11); Lizenz-Schluss-Pass

### [wisfvjd8z.json] 87 (Bruecken-Register, vom Audit als KEIN Verlust bestaetigt)
GEGENSTAND: 14 Alt-Posten mit geltender Fundstelle: GN-9 SUPERSEDED (ETA-Erst-Batch, DOSSIER:3340); #327 owner-terminiert nach Messfenster (DOSSIER:3343); O-A via D-3 (LEDGER:7502); KK-5 als D-4 + O-PMC-1 (LEDGER:7570); N-6 als R-2 (LEDGER:7571); PMC B-1..B-10: numa/core_class gelandet aa223961, Rest 16.7-B1..B6+D-5; Frist 15.09. verankert (LEDGER:7270); E-07-Kriterien (DOSSIER:2231-2249); REV als P-1 (DOSSIER:1125-1132); M-8/M-9/M-15+Anhang A entschieden (DOSSIER:2602-2606); E-18 getrackt mit Fehlglied-Liste (DOSSIER:1885-1887); Scheibe-6 Weg a sequenziert (DOSSIER:2716); T-9 hoechste Prio korrekt im Ledger; V-7 geparkt mit Anker.
ORT: siehe GEGENSTAND
SOLL/FIX: - (Bruecken als Nachtrag verbuchen)
STATUS LT. QUELLE: entschieden/getrackt
ABHAENGIGKEIT/FLAECHE: Dedup-Grundlage fuer den Designer

## Datei wmphtm0ki.json (Wellenplan-Vollerhebung 06.08. abends: Erst-Explore "plan" + Gegen-Explore "gegen" + Design 20260806-PLAN-wellenplan-vollbild-und-parallelisierung.md, 1226 Z.)
ZEITSCHICHT-WARNUNG: Stand 06.08. abends. Viele Posten sind laut juengeren Quellen (wisfvjd8z-Audit 07.08., KON-Serie bis 13.08.) inzwischen weiter. Extraktion behaelt die damaligen Befunde; Dedup/Zeitabgleich beim Designer.

### [wmphtm0ki.json] 88
GEGENSTAND: VERLUSTRISIKO (Erst- und Gegen-Explore bestaetigt): vier Dokumente UNVERSIONIERT im super-Baum: docs/plaene/20260806-PLAN-testoffensive-und-gruene-pipeline.md (18:06, JUENGSTER Plan), docs/plaene/20260806-PLAN-versionierungs-interface-stempel.md (13:59, 60 KB), docs/sessions/20260806-ANKLAGE-kostenklammern-plan-diff.md (16:58), docs/sessions/20260806-FAHRPLAN-hauptstrang-landung.md (16:24) + Code/measure_out_d03/. "Ein git clean oder Worktree-Abbau vernichtet sie." Zudem Design-Dokument selbst (PLAN-wellenplan-vollbild) nicht committet.
ORT: super Arbeitsbaum (git status --porcelain ??-Eintraege)
SOLL/FIX: Welle 0.2: committen mit explizitem Pathspec, nie git add . (Regel 8).
STATUS LT. QUELLE: offen (06.08.)
ABHAENGIGKEIT/FLAECHE: Wellenplan-Traeger; Verlust-Klasse .gitignore-*.log

### [wmphtm0ki.json] 89
GEGENSTAND: Code/measure_out_d03/ = ECHTE Messdaten, unversioniert, NICHT gitignored: 66 Dateien, 3,7 MB, 26.07. 16:37/16:38, u.a. measurements.csv (16 Zeilen, 173 Spalten), je Permutation result.csv/.stamp/perm.cpp/perm.dll/.rsp/.version/.cxx.log; nur durch git clean -fdx gefaehrdet; .rsp-Dateien sind genau das REGISTER-P0-Pflicht-Artefakt ("E2E-.rsp-Beweis").
ORT: super Code/measure_out_d03/
SOLL/FIX: VERBATIM: "Sicherungsposten, vor jedem Worktree-Abbau." Welle 0.3: sichern oder .gitignore-Eintrag mit Begruendungszeile; Doktrin Messdaten nie loeschen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Memory-Doktrin BU additiv

### [wmphtm0ki.json] 90
GEGENSTAND: PMC-Praezisierung am Messobjekt (Gegen-Explore Paragraph 2): measure_out_d03/e4_xml/measurements.csv beweist: LinuxPerfPmcSource hat real gemessen (pmc_available=1 16/16, L1 16 reale Werte, dTLB real) -- Sperr-Aussage "gar keine PMC-Quelle" ist bedingt, nicht absolut; O-A-Frage verengt sich auf "traegt der Treiber-Bau des Voll-Mess-Laufs das Flag". Fix-Ort ENTLASTET: Tier-.rsp tragen weder COMDARE_ENABLE_PMC noch V32_ENABLE (8/8) -- kein zweiter Defekt, make_pmc_source() lebt im Treiber (iterator:2586, perm_runner.hpp:130); die vier cmake-Emissionen sind die richtige und einzige Fix-Stelle. NEU UND UNGEMELDET: L3-Luecke -- cache_misses_l3 geoeffnet und deklariert "ehrlich LL" (:192,:204-205), aber 0 in allen 16 realen Zeilen bei available=1; keine Wache faengt das (pmc_seam_ok = available||all_zero); "trifft die zentrale Messgroesse einer Cache-Engine-Diplomarbeit"; Ursache UNBELEGT.
ORT: ce linux_perf_pmc_source.hpp:191-208,:295 | measure_out_d03/e4_xml/measurements.csv
SOLL/FIX: Anhang kann selbst im besten Fall nur L1D + dTLB zeigen -- VERBATIM Ledger nachmittag-10 E: "das gehoert vor Phase 6 entschieden, nicht nach der Messung entdeckt."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: O-A; deckt sich mit w8v4vkn3p Fund 63 L1 (spaeter vertieft) und Fund 64 (K-4-Lanes-Beweis)

### [wmphtm0ki.json] 91
GEGENSTAND: Doppel-Gitlink-Befund (Gegen-Explore 3.1, HOCH, Stand 06.08. 18:34): super hat ZWEI Submodul-Eintraege auf 20260931-overleaf-diplomarbeit; 85b74237 bumpte NUR Code/external/... auf 8970465d, thesis/diplomarbeit blieb 29a1700d -- aber thesis:pdf baut aus thesis/diplomarbeit (:560), trigger:thesis ist changes:-gegatet auf thesis/diplomarbeit (:285), anhang:forward bumpt ebenfalls nur thesis/diplomarbeit (:1102/:1111). "Gate 8 ist im Thesis-Repo gelandet, aber aus super heraus nicht erreichbar. Die 23 Anhang-A-Abbildungen fehlen im PDF, das super baut. Heilung ist ein Einzeiler (zweiter Gitlink nachziehen)."
ORT: super .gitmodules + .gitlab-ci.yml:285,:560,:565,:1082,:1102,:1111 @ 85b74237
SOLL/FIX: zweiten Gitlink nachziehen (Einzeiler).
STATUS LT. QUELLE: offen (06.08.); lt. w4m1xz6m1 (06.08. 20:03) durch 46824fba geheilt -- Strukturproblem (anhang:forward bumpt nur einen Zeiger) bleibt (w4m1xz6m1 Fund 43)
ABHAENGIGKEIT/FLAECHE: Doppel-Einbindung; Drift-Wache

### [wmphtm0ki.json] 92
GEGENSTAND: K-05 target_isa.numa_node "null Leser" ist am Objekt FALSCH (Gegen-Explore 3.3): vollstaendiges RT-Erhebungs-Paket existiert (target_isa_sub_axes.hpp:79, numa_page_probe.hpp inkl. ANSCHLUSS-WACHE :440-451, test_od10_numa_page_probe.cpp, system_cell_values.hpp:164); Defekt ist "zwei unverbundene Haelften derselben Achse" (XML-Pfad parst in ungelesene Felder; RT-Sonde erhebt ohne XML); Parser deklariert Luecke selbst (xml_config_parser.cpp:127 "Resolver-Schritt folgt"). NAMENSFALLE: zweite voll verdrahtete Unterachse alloc_hw.numa_node (152 numa_node-Treffer vs. 23 target_isa-bezogene) -- "Wer hier ungeprueft anschliesst, trifft die falsche Achse."
ORT: ce target_isa_sub_axes.hpp, numa_page_probe.hpp, xml_config_parser.cpp:127-132, alloc_hw_config.hpp:49/77
SOLL/FIX: O-E braucht diese Fassung, nicht die des Plans; K-05-Fassung korrigieren bevor jemand die falsche numa_node-Achse anschliesst.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: O-E; Resolver-Schritt

### [wmphtm0ki.json] 93
GEGENSTAND: i-6/T-ii-3-ERGAENZUNG (in keiner Liste): direkt neben bestandslog_active (:1658-1660, fetch&&store&&bestand_key_of&&!bestand_doc_key.empty(), bestand_fingerprint_fn fehlt) sitzt mess_bestandslog_active (:1665-1668) mit DERSELBEN Luecke ("G-E3: der Messwert-Genus-Zustand. EIGENES Gate") -- "der i-6-Fix muss BEIDE Gates fassen, sonst heilt er die Haelfte." G-E3-Host-Binder (3 iterator-cfg-Felder mess_bestand_*, 0 Konsumenten) = die Messwert->Lager-Verdrahtung, haengt direkt an i-6.
ORT: ce cache_engine_builder_iterator.hpp:1658-1668
SOLL/FIX: i-5+i-6 als EINE Welle (nach O-C), i-6 fasst beide Gates.
STATUS LT. QUELLE: offen, gated O-C
ABHAENGIGKEIT/FLAECHE: O-C (COMDARE_BESTANDSLOG im Trigger?); T2-A-Kollision aufgeloest

### [wmphtm0ki.json] 94
GEGENSTAND: allow_failure/Preflight-Doktrin-Praezisierungen (Gegen-Explore): (a) m3v2_pmc_smoke.cpp:62-67 sagt das GEGENTEIL der Testplan-Unterstellung -- das fruehere honest_null-Verdikt kippte ehrlich-live-PMC auf SMOKE_FAIL, 13.07.-Fix (M-CE-25) heilte genau das; ANKLAGE i-2: "Den 13.07.-Inversionsfix NICHT ruecknehmen" -- Fix an den Preflight-Ort verengen. (b) allow_failure :1333 hat ZWEI Doktrinen gegeneinander: Sichtbarkeits-Doktrin (:1332, CSV 'failed' + Log, Pipeline gruen) vs. Paragraph 66-N2 "BEIDE hart"; ANKLAGE V-C schraenkt selbst ein: "Paragraph 66-N2 gilt fuer die ce-Jobs, nicht fuer den Mess-Batch"; Auflage i-3: "Vorher pruefen, ob eine Pipeline-Politik (Landewarteschlange) daran haengt"; Batch ohnehin rules-gegated (:1329-1331). -> UNENTSCHIEDEN, O-B braucht beide Doktrin-Seiten.
ORT: ce m3v2_pmc_smoke.cpp:62-71 | experiment_plan_director.hpp:1329-1333
SOLL/FIX: O-B-Owner-Vorlage mit beiden Seiten.
STATUS LT. QUELLE: offen (O-B)
ABHAENGIGKEIT/FLAECHE: KONTRAST zu w8v4vkn3p Fund 58 (dort einseitige Weg-A-Empfehlung "Zeile entfernen") -- Designer muss beide Fassungen + spaetere Owner-Aussagen abwaegen

### [wmphtm0ki.json] 95
GEGENSTAND: Widersprueche F-1..F-17 (Auswahl mit Bestand): F-1 Kostenklammer-Nummern K-01..K-07 UNDEFINIERT -- vor jedem Bau-Auftrag auf KK-x zurueckfuehren "sonst baut jemand am falschen Posten"; F-5 KK-2-Ebene ERREICHBAR (K-01 widerlegt: append_forward_var_literal :952-955), offen nur O-C; F-6 SF-1 (anatomy->builder-Aufwaertskante): Owner 06.08. vormittag-22 Nr.4 verbatim "Vor Abgabe bitte ein eigenes Fenster" vs. REGISTER "NACH-ABGABE (A6, 05.08.)" -- juengere Owner-Aussage nicht nachgezogen, OWNER-RUECKFRAGE NOETIG; F-7 OD-7 Runner: SOLL normal 2/2x12 + heavy prod1 24; runner-mode.sh@0d7c577 zeigt 4/4 normal + HEAVY_J=24 ungekappt, fuer 16-Kerne-Cap KEIN Code-Beleg, Live-Verifikation offen; F-9 I-PMC-1 im Ledger ERLEDIGT gebucht, am Objekt unwirksam (Haken gilt fuer measure:smoke DEPRECATED + golden-320; dynamische Kette setzt Flag nirgends); F-10 "Default-Modus-Konsequenz owner-gedeckt (F7)" -- zitierter F7-Kanon verwirft den Vorschlag ausdruecklich (G-C1), Ledger-Zeile traegt kein Owner-Zitat; F-11 B4-Termin P4 vs. "vor Messung" ungeloest; F-13 KF-6-Bau-Slot fehlt im DAG (spaeter entschaerft: siehe Fund 97); F-14 B14-super-Heilung ist 2c631551, nicht 9934a7e5 (=Gate-Spiegel).
ORT: siehe Einzelanker in Quelle
SOLL/FIX: je Widerspruch: juengste Fassung gilt; F-6 Owner-Rueckfrage.
STATUS LT. QUELLE: offen (F-6, F-7, F-11); Rest aufgeloest/dokumentiert
ABHAENGIGKEIT/FLAECHE: Owner-Vorlage

### [wmphtm0ki.json] 96
GEGENSTAND: Design-Dokument (1226 Z., ASCII-sauber) mit bewiesener Disjunktheit: Bahnen-Obergrenze "max EIN ce-Voll-Gate + max EIN super-Slot + EINE Landebahn + n READ-ONLY"; Datei-Mengen D(P-A1)/D(P-XXE)/D(P-LOCK-A/B)/D(P-PMC)/D(P-BEST)/D(P-DASH-ce/super)/D(P-KAL)/D(P-DOC) mit expliziten Schnitten; Hotspots: ce tests/unit/CMakeLists.txt (EIN SCHREIBER: P-A1 bis Landung), super Code/tests/CMakeLists.txt (erst P-XXE dann P-DASH-super), ce .gitlab-ci.yml (exklusiv P-LOCK-A; P-PMC schreibt sie NICHT -- schreibt den Emitter), super .gitlab-ci.yml (GESPERRT bis nach Trigger), golden-XMLs (nur mit Voll-Gate), LEDGER (EIN SCHREIBER Lead, append-only). AUFLAGE W-1: ein Worktree = ein Schreiber; reset/checkout -f/clean in fremden Baeumen verboten. AUFLAGE W-2: "Liegt auf origin" beantwortet "ist es gelandet?" nicht -- nur merge-base --is-ancestor. AUFLAGE T-1 (NEU BINDEND): nach JEDER ce-Landung gehoeren ce-main-FF UND super-Gitlink-Bump in denselben Arbeitsgang (Trigger zeigt auf main). Wellen: W0 Verlustvermeidung (~15 min) -> W1 vier Bahnen (1A A1-Landung=kritischer Pfad, 1B XXE, 1C Axis-Lock Form A, 1D READ-ONLY 1D-1..1D-9) -> W2 (2C Kalibrier-Stichprobe ZUERST, 2A/2B Dash-Heilung) -> W3 owner-gated (3A PMC=i-1+i-2+i-3, 3B BEST=i-5+i-6, 3C O-Token, 3D O-1) -> W4 Trigger-Vorlauf (+ ein hart gruener Voll-Lauf).
ORT: docs/plaene/20260806-PLAN-wellenplan-vollbild-und-parallelisierung.md (damals uncommitted!)
SOLL/FIX: - (Plan-Dokument; heutiger Wellenplan ist Paragraph 18 lt. Memory)
STATUS LT. QUELLE: geschrieben; Einordnung historisch
ABHAENGIGKEIT/FLAECHE: Wellenplan-Historie; G) NICHT-parallel-Liste (14 Punkte) als Dauerregeln wertvoll

### [wmphtm0ki.json] 97
GEGENSTAND: KF-6/OOB-Registerzeile STALE zugunsten des Projekts: OOB-Fix IST GELANDET (B14-NB2/NB3: kLbufBytes in allen drei Pfaden abgeleitet :622/:731/:873 via layout_scan_stride_bytes<MemLayout>() + static_assert je Pfad); line_size-Block der golden-XML ist INERT (organ_subaxes 0 Treffer im ce; XML sagt selbst "HEUTE DEKLARATIV"); "Der Trigger baut heute line_size=64 und laeuft NICHT in den OOB. KF-6-NTTP-Codegen ist ein Nach-Abgabe-Posten, kein Trigger-Blocker. Muss ins Ledger, sonst baut die naechste Runde ihn unter Zeitdruck."
ORT: ce abi_adapter.hpp:622/:731/:873; golden-XML organ_subaxes-Block
SOLL/FIX: Ledger-Nachtrag KF-6-Befund.
STATUS LT. QUELLE: entschaerft; Ledger-Eintrag offen
ABHAENGIGKEIT/FLAECHE: organ_subaxes-Parser (siehe wtpunni0p Fund 18: weiterhin 0 Zeilen)

### [wmphtm0ki.json] 98
GEGENSTAND: Neue Posten N-1..N-16 (Design H): N-1 Kalibrier-Stichprobe (~200 Binaries, "bisher in keiner Liste"); N-2 Lock-Regel ins Ledger (Heuristik-Header => Lock regenerieren; zweimal passiert 13.07./06.08.); N-3 AUFLAGE T-1; N-4 mess_bestandslog_active-Luecke; N-5 KF-6-Zeile stale; N-6 PMC-CSV-Befund; N-7 unversionierte Docs + measure_out_d03; N-8 axis_inventory.tex geschrieben (appendix_generator.cpp:423) aber von KEINER .tex eingebunden ("dieselbe Klasse wie Gate 8, nur aelter", Aufraeumpass-Kandidat 9); N-9 referenzlose using SearchAlgo-Aliase abi_adapter.hpp:440/:545 (Kandidat 10); N-10 1xN-/Nx1-Matrix-Fatal diagram_generator; N-11 DELTA C golden-XML system_axes (atomic128/target_isa fehlen -- billigstes Fenster B14-Landung VERPASST); N-12 Regeln 8+9 (Zeiger kann rueckwaerts zeigen; rescue-Ref ist keine Landung); N-14 fehlende Stufe im Bau-Ritual: lint:format prueft ganze Dateien, T2-A und B14 gelandet ohne cf22-Lauf -- "dieselbe Fehlerklasse am selben Tag in beiden Repos unabhaengig" (ce 94, super 160); N-15 gitleaks immer mit Repo-toml UND ueber Push-Inhalt; N-16 ce-Auflage '--' in XML-Kommentaren (Defekt besteht: xmllint "Double hyphen" Z.62/64 all_axes_golden).
ORT: siehe GEGENSTAND
SOLL/FIX: je Posten; Ledger-Nachtraege.
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: Aufraeumpass; golden-Anker (N-11, N-16 nur mit Voll-Gate)

### [wmphtm0ki.json] 99
GEGENSTAND: Sonstige tragende Punkte: (a) Bau-Block-Doktrin verbatim: "R4, T2-A, B14-ce und A1 bilden einen einzigen Bau-Block, der VOLLSTAENDIG vor dem Trigger gelandet sein muss ... Landet auch nur eines davon nach dem Voll-Bau-4, ist der gesamte Bau zu wiederholen"; A1-Verdikt: LANDEN MIT BUMP-AUFLAGE (24 Strategien v1.0.2c, 2 reallocate-lose v1.0.1c, VIER neue Sub-Concepts; Zahlen 27/24/26 = drei Gegenstaende); (b) 776 Runner-Token in refs/backup/pre-secret-scrub-20260802 = 5ba3d03f auf gitlab origin bestaetigt -- Loeschung nur mit explizitem Owner-GO; (c) P2-Band-Riss verbatim: "Das REGISTER fuehrt P2-P8-Schema, xlsx-Lager-Geruest, B5, #46b-Rest, G-E3-Host-Binder, Posten-77/78 als VOR Messbeginn Pflicht (Leitplanke 4). Nichts davon ist gebaut ... Das ist der groesste ehrliche Riss zwischen Plan und Fenster -- er gehoert in die Owner-Vorlage, nicht in eine stille Verschiebung."; (d) fuenf verwaiste w2-*-Branches: alle 26 Commits patch-aequivalent in development (git cherry '-') = reine Aufraeum-Kandidaten; (e) Erfassungsluecken: Ledger ohne Header 28.-31.07.+01.08.; Zeilennummern wandern -- ueber Wortlaut suchen; (f) Lager-Basis-Tests Owner-KERN: Stufe-2-Stub IST die Binary mit nur dem Versionierungs-Interface -- "der Stub ist zugleich der erste echte Abnahmetest des Versionierungs-Interfaces" (F7-Kopplung); (g) Namenskollisionen: B5!=B-5, R2!=R2, G5!=G5/#274, A14!=A14, B12!=B12, Posten 36!=#36, 37!=#37, #27 mehrfach, A8-S2 nie vergeben.
ORT: siehe GEGENSTAND
SOLL/FIX: siehe GEGENSTAND.
STATUS LT. QUELLE: gemischt (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: O-Token (Security); F7/LB-6 (f); Owner-Vorlage (c)

## Datei wmf14wrxt.json (Betreuer-Termine-Vollerhebung: 11 Termine / 309 Dateien lesen + 3 Diff-Spuren + Synthese KANON-termine; Ergebnis-Kanon: /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/plaene/20260806-KANON-termine...)

### [wmf14wrxt.json] 100 (Lese T1+T2)
GEGENSTAND: T1/T2-Kanon (6/6 Dateien): T2 (05.04.) = Architektur-Freeze, gilt bei Konflikt ueber T1; T1 bleibt massgeblich fuer Forschungsfragen-Wortlaut, H1-H4, 4-Ebenen-Metrikmatrix, Datensatzliste, Leseliste L1-L16. Kern-Normen: Invarianten I1-I6 (I2 "genau ein ValueHandle"; I4 Ordnungsrelation der rohen Byte-Keys; I5 "feste universelle Schwellwerte werden nicht behauptet" -- jede hartkodierte Konstante in einer Umschaltregel ist Abweichung von T2); Cache-Engine mit ABSCHLIESSEND definierter Eingabemenge (lokale Dichte/Fanout, Praefixentropie, erwartete beruehrte Cache-Lines/Pages, Key-/Value-Groesse+Inline-Eignung, ISA-/HW-Profil) und Ausgabemenge (Seitentyp, Alignment, lokale Ordnung, Inline-vs-Pointer, Reorganisation) -- 10-Punkte-Checkliste gegen Ist-Stand; "keine statischen Architekturannahmen -- Hardware-Discovery" (05.04. = Wurzel der Hybrid-Regel und "HW nie statisch"); 4-Ebenen-Pflichtmetrik (Lookup/CRUD p50/p95/p99; SPEICHER: Bytes/Key, Poolgroessen getrennt Suchseiten/Redirects/Values, Tombstones, Konsolidierungskosten -- "Ohne saubere Speicherbilanz bleibt der Layout-Anspruch unglaubwuerdig"; CPU-Counter inkl. IPC; Cache-Modell CLU/modellierte Misses/Advisor MAP); Neuheitsanspruch klein, Beweis in der Messung; Baseline-Pflicht "mindestens ART, HOT, eine cache-sensitive B+-Variante und eine einfache B+-/Hash-Referenz"; FAIRNESSREGEL fuer Inline-/Pointer-Values dreimal gestellt, nirgends beantwortet -> an T3 delegiert. Befunde: Begriff "Cache-Engine" entsteht 05.04. in T2 (T1: 0 Treffer); Termin 2 war WIEDERHOLUNGSTERMIN ("Literatur allein genuegte nicht, verlangt war ein Freeze"); Datums-Widerspruch Ordnername 20260330 vs. Datei-Datum 05.04. (es gilt die Datei); KEIN Betreuer-Wortlaut in T1/T2 (alle 6 Dokumente vom Studenten); ValueHandle::ChainRef explizit vertagt; 5 Seitentypen (T2 zaehlt Redirect-Page mit, T1 nur 4 -> T2 gilt); Referenz-CPU i7-1270P (AVX2), optional AVX-512/ZIH; Kardinalitaeten/Wiederholungszahlen in T1/T2 NIRGENDS festgelegt (kommen in T3); Hybrid/P-E-Core/Sapphire in T1/T2 = 0 Treffer.
ORT: docs/termine/20260330 Termin 1+2 (6 Dateien); Extraktionen /tmp/t1t2/
SOLL/FIX: - (Kanon-Lesebericht)
STATUS LT. QUELLE: gelesen (Nenner 6/6)
ABHAENGIGKEIT/FLAECHE: I1-I6 als maschinell pruefbare Testfamilie (Vorschlag); Cache-Engine-Checkliste

### [wmf14wrxt.json] 101 (Lese T3)
GEGENSTAND: T3-Kanon (09.04., 3/3 Dateien, 653 Text-Runs verifiziert): (1) HYBRID-REGEL ist MESSREGEL, kein Infrastrukturdetail ([p016]/[p019]): "P- und E-Cores werden nicht zusammenaggregiert. perf dokumentiert dafuer getrennte PMUs cpu_core und cpu_atom; gruppierte Events ueber beide PMUs werden vermieden" + Pinning-Matrix Single P/Single E/All-P/All-E -- "Ein perf-Job, der ueber beide PMUs gruppiert, ist kein Cluster-Problem -- er ist ein Verstoss gegen T3." (2) Zwei Pflichtplattformen (i7-1270P hybrid + ZIH Barnard 2x Xeon 8470 Sapphire Rapids 512 GiB AVX-512/Slurm), drei ISA-Pfade, Feature-Erkennung beim Build + Laufzeit-Ausweis im Harness -- eine Plattform allein erfuellt T3 nicht. (3) ACHT Pflicht-Messachsen inkl. Core-Modus (9 Ops, 6 YCSB, 3 Ordnung, 2 Value, 3 ISA, 5 Core-Modi, 5 Wiederholungen, 2 Plattformen) + Kern-/Erweiterungsmatrix getrennt; Core-Modus-Achse fehlt in BEIDEN Kurzformeln ([p012], slide4) -- "genau der Verlustpfad, der heute zum Fehlgriff gefuehrt hat." (4) Drei nicht verhandelbare Auswertungsregeln: Perzentile nie mitteln; 5 Laeufe NEBENEINANDER (Abweichungen sind Teil der Aussage); 64-Byte-Advisor-Modell ersetzt nicht die Hardware-Discovery. (5) Fairness: Common-Denominator vs. Native strikt getrennt; N/A statt Emulation; Compiler/Flags/ISA/Allocator/Commit-Hash jeder Fremdbibliothek mitloggen; 9-Feld-Datensatz-Akte; Roh-CSV/JSON + HDR-Histogramme separat. Nullbefunde: HybridCorePinning/core_class 0 (T3 normativ, T7 konstruktiv); Prefetch 0 (erst T4); Hypothese 0 (H1-H4 aus T4); Forschungsfrage nur als Ausblick; ZEITBUDGET 0; "97.200 Konfigurationen" ist ABGELEITETE Rechnung eines spaeteren Agenten, kein T3-Zitat (eigene Nachrechnung 81.000; Seitentyp-Achse in T3 nicht als Tabellenzeile). Widersprueche: Sekundaerquelle extract_termin3_4.md FALSCH ("T4 ergaenzt Core-Typ und Wiederholung" -- beide seit 09.04. T3-Pflicht); T3-intern: Tabelle [p053] massgeblich vs. Kurzformeln. Kein Betreuer-Feedback in T3 (Selbst-Vorlage-Termin).
ORT: docs/termine/20260409 Termin 3 (3 Dateien); /tmp/t3x/
SOLL/FIX: - (Kanon)
STATUS LT. QUELLE: gelesen (3/3)
ABHAENGIGKEIT/FLAECHE: PMC-/Mess-Architektur (KON34 System A/B); MESS-NENNER; P/E-Core-Cluster (w56km2g9g K2)

### [wmf14wrxt.json] 102 (Lese T4+T5)
GEGENSTAND: T4-Scope-Freeze (12.04.) = bindend: finale Forschungsfrage "...auf Hybrid-CPUs und Sapphire-Rapids-Systemen?" (3 Fassungen, Hybrid/Sapphire gilt); H1-H4 eingefroren (H2: Seiten gewinnen abhaengig von Datensatz/ISA/Core-Typ/Ordnungsmodus; H4: Relocation+Prefetch helfen NUR bei gemeinsamer Modellierung mit Affinity); 4 Schichten A-D; 6 Seitentypen mit Prio P0/P1/P2; Value-Pfad eingefroren, ValueHandle=P0, Umschaltpunkt "global, pro Seitentyp und pro Node-Familie parametrierbar"; Owner-Block P71: "Die Cache-Engine darf live Pages umbauen und verschieben ... nicht Optional, sondern Teil des Forschungsbeitrags" (einzige Optional-Komponente: Multiwriter); P0+P1 unantastbar (P1 = Cache-Engine v1, START-Multilevel, Inline-vs-Handle, DREI Ordnungsmodi, P-/E-Core-Trennung, Barnard-AVX-512, Baseline-Wrapper); Cut-Regeln; 5-Punkte-Definition der Cache-Engine (P4); 7 T4-Experimente inkl. Policy-Ablation 5 Stufen ("Kausaler Nachweis active > passive") + Hybrid-Split + Prefetch-Distanz {1,2,4,8}; Erfolgskriterien CLU signifikant hoch + Footprint runter (Advisor); Reader-vs-Mover/Overfetch/Hybrid-Fehlerklassen benannt; "Cacheline = optimale Node" explizit widerlegt. T5 friert NICHTS ein (professionalisiert Begruendung): Designregeln R1-R6 (R2 universelle Schwellwerte unwissenschaftlich; R5 "zuerst messen, dann aktivieren. Mehr Prefetch ist kein Forschungsbeitrag"; R1 Control Plane, kein Kernel); Sprachauflagen (nicht "Cache direkt verwalten"); Spannung T5 "aggressive Online-Umlagerung sekundaer" vs. T4 P71 -> Aufloesung: Online-Relocation bleibt Pflicht (P2), nur aggressive Varianten sekundaer. UNTERBESTIMMT: "drei Ordnungsmodi" in T4/T5 nirgends benannt -- Definition muss aus T3 kommen.
ORT: docs/termine/20260412 Termin 4+5 (8 Dateien)
SOLL/FIX: - (Kanon)
STATUS LT. QUELLE: gelesen (8/8)
ABHAENGIGKEIT/FLAECHE: Diff-Positionen (Funde 110-115)

### [wmf14wrxt.json] 103 (Lese T6+T7 Kern)
GEGENSTAND: T6 (16.04.) = geltende Fassung fuer Plattformen/ISA/Benchmarks/Messstack/Auswertungsregeln: 9 Pflichtplattformen (inkl. Barnard + Grace Hopper GH200 PFLICHT; i9-14900KS; Ryzen 9 9950X3D), 5 Pflicht-ISA-Pfade (scalar/avx2/avx512/arm_neon/arm_sve2), 3 Verifikationsmodi (passiv/warm-up/online-adaptiv); Pflicht-Auswertung "fuenf Rohlaeufe, keine Mittelung von Perzentilen, getrennte Ausweisung nach Plattform, Core-Typ, ISA und Cache-Engine-Modus"; Hybrid-Regel als Merksatz "Alder-Lake-aehnliche Systeme werden nie als ein homogener CPU-Block ausgewertet"; ZIH-Regel exclusive+no_monitoring; Erfolgskriterium UND (Latenz UND Miss-/CLU-/Footprint gleichzeitig); 4 Nichtziele (u.a. KEIN Multiwriter als Pflichtkern, keine erzwungene Neuimplementierung). T7 (08.05.): Habich-Auflagen H1-H6 (H1 UML-Vollausarbeitung "das volle Programm" + ER-Modell; H2 BAUSTEIN_BEWERTUNG.md mit Habich-Sign-Off; H3 LaTeX-Toolchain mit \PRTARTPlot NUR im Appendix; H4 Repo-Separation; H5 ABI-stabiler Production-Container; H6 KEIN PYTHON (Talos OS) -- revidiert F-EXTRA-5/D-4); ADRs F1-F15 + F-EXTRA (F15 = Forschungskern: Bausteine-Zerlegung nach Domaenenmodell, jeder Baustein einzeln tauschbar; F-EXTRA-8 ABI-Test + Habich-Log bei Bit-Abweichung -- "Habich entscheidet"; F5 KEINE externe DB; F13 Dual-Modus ZIH=Runtime/sonst Compile-Time); HybridCorePinning-Baustein (Domaenenmodell v1 Z.441-447: pin_thread(core_class), measure_per_class -> {p_core,e_core}) -- Audit: Skelett ohne Code; MeasurementRecord 32-Byte-POD mit cpu_class {0=core,1=atom}, telemetry_strategy, sampling_n; K3.2 "Cache-Engine darf KEINE plattform-spezifischen Klassen tragen" (Auto-Discovery-Properties statt RyzenX3DProbe/IntelHybridProbe); Kuehn-Erkenntnisse (Cacheline-Ping-Pong, LeafOnly/Sampling, "Naive Pro-Knoten-Histogramm-Implementierung ist UNBRAUCHBAR fuer parallele Workloads"); i9-14900KS-Warnungen (AVX-512 disabled; STRONG-Prefetch + grosse Knoten Slowdown 0.4-1x -> kleine Knoten <1 KiB bevorzugen); REV-Kette bis 7.6, T9 zitiert spaeter REV7.7 als geltend; 5 drawio-only-Beschluesse 18.-21.05. (N-Phase 14 Achsen/82-bit-ID; AA.2 CacheEngine = GLEICHRANGIGE ExecutionEngine; AA.3 Default-Achsen-Lookup; O-Phase 9/19; R.12 Anti-Vermischung) OHNE .md-Pendant im T7-Ordner; REV-7.5-Ehrlichkeitsnotiz: die 54 gemessenen Module waren MOCK-Stubs (op_count=0).
ORT: docs/termine/20260416 Termin 6 (3/3) + 20260508 Termin 7 (61 von 270 substanziell + ~150 grep-geprueft)
SOLL/FIX: - (Kanon); Chronologie-Regeln D.1-D.11 in Quelle
STATUS LT. QUELLE: gelesen
ABHAENGIGKEIT/FLAECHE: I6-Praezisierung REV6 Paragraph 5.23 (Multi-Writer nicht mehr ausgeschlossen) vs. T6-SF "Kein Multiwriter als Pflichtkern" -> Betreuer-Fassung abgabe-verbindlich

### [wmf14wrxt.json] 104 (Lese T8+T9)
GEGENSTAND: T8 (15.05.): Drei-Repo-Doktrin (WIE/Pruefling/WAS); ARCHITEKT-DIREKTIVE II (Zerschneiden = neues Werk, alle Lizenztypen freigegeben); "Tier-1"/"Rang-1"-Terminologie-Kollision beginnt hier; MessreihenMode-Regel: "Defined fuer Manuskript-Plots, Full-Mode NUR fuer ZIH-Cluster-Laeufe"; Adapter-Vertrag COMDARE_HAVE_<X>=OFF default; Habich-Genehmigungsantraege (libs/-Layout Option C+, GPL-Freigabe, P27) NIE beantwortet; #109/#111 YCSB-Provider INFRA-offen; _archive_chatgpt als "inhaltlich falsch" etikettiert, enthaelt aber die EINZIGEN reproduzierten Zahlen des Termins (54 Permutationen, 109 generierte Dateien, scalar-only-ISA-Befund) und die von T9 uebernommene Priorisierung -- Etikett irrefuehrend. T9 (29.05.): Rede-Verbote (nicht behaupten: 35.000+ experimentreif / Original-Baselines belastbar / PRT-ART fertig); Achsen-GOLDSTANDARD = 7 Pflichtbestandteile (Registry, StrategyBase, ConfigSet, Flags, Wrappers, Concept-Conformance, CMake-Integration; Referenz axis_06_allocator); OperationOutcome = Latenzsamples + Cache-Miss-Delta + Bytes-touched; Welch-Test zur Builder-Saeule; Risiko "Zu viele Achsen vor erster Messung" (hoch) -> "erste Messung vor Vollausbau erzwingen"; P0 Build-Konsistenz / P1 vertikaler Pfad / P2 erst danach Achsenbreite; AKZEPTANZKRITERIUM "Ein Workload erzeugt ueber CEB ein PRT-ART-Ergebnisartefakt, das in CSV/LaTeX/TikZ/PDF landet"; Vendoring-Doktrin-Ursprung (FetchContent-Risiko); Include-Pfad-Drift prt-art (T8-Vollzugsmeldung war unvollstaendig); Ist-Stichprobe: HybridCorePinning=0, cpu_atom=0, cpu_core nur als bewusst ungesetztes Feld (AP-13) + EXPECT_FALSE-Tests -- "Gruene Tests zementieren hier die falsche Ordnung."
ORT: docs/termine/20260515 Termin 8 (9/9) + 20260529 Termin 9 (3/3)
SOLL/FIX: - (Kanon)
STATUS LT. QUELLE: gelesen (12/12)
ABHAENGIGKEIT/FLAECHE: INDEX.md kennt T9-T11 NICHT (mechanischer Erzeuger der Gedaechtnisluecke)

### [wmf14wrxt.json] 105 (Lese T10+T11)
GEGENSTAND: T10 (05.06.): Achsen-Delegations-Audit (axis_03a-Suchorgane waren Monolithen mit Eigenspeicher = "echter Architektur-Verstoss gegen das Organ-/Achsenmodell"); 4 Fehlerklassen mit Reststatus (V2-POD offen; "Suchmetriken muessen ebenfalls aus demselben delegierenden Store kommen" offen); NodeChunkedStore-Teilfix (alloc_cnt ~ ceil(n/node_capacity)); A_defined = 8 Tier-1-SOTA, A_full = 30; einzige reale Messung: 8 DLL-Tiere, 24 result_ingest-Zeilen, nur Strukturzaehler. T11 (19.06., GELTENDE Fassung): FF0 ausformuliert; 132 Seiten DE / 128 EN; 19 Achsen + 3 Build-Achsen; P0-P4 (P0 ein realer Messpfad geschlossen "nicht nur Demo/Smoke"; P1/M2 PMC oder begruendeter Fallback -- "Die Forschungsfrage ist cache-zentriert; ohne Counter bleibt es indirekt"; M1-DoD Commit/Compiler/Seed dokumentiert; M5 "DE fuehrt. EN darf nicht auseinanderlaufen"); P4 = EINZIGE direkte Habich-Auflage: "Rang statt Tier" (Kapitel 1-3) -- Diff spaeter: im Manuskript VOLLZOGEN, Code-"Tier" ist die Lebewesen-Metapher, konform; 13 Limitierungs-Vorbehalte (NullPmcSource, gepinnte Achsen, Pseudo-Prefetch "darf nicht als echter Speicher-Prefetch verkauft werden", Q2-Schritt-4-Apparate-Konfundierung bei node_type+memory_layout); benannte Fehlerklassen uint16-Sekundaerorgan-Saettigung + intern verschlucktes OOM (nur dokumentiert, nicht behoben); 5 Interface-Ops insert/lookup/erase/scan/rmw verbindlich; Hybrid-Regel in T10/T11 mit KEINEM Wort -- T3/T4 bleiben unwidersprochen geltend; Wiederholungszahl hat in T10/T11 keine Grundlage.
ORT: docs/termine/20260605 Termin 10 + 20260618 Termin 11 (6/6)
SOLL/FIX: - (Kanon)
STATUS LT. QUELLE: gelesen
ABHAENGIGKEIT/FLAECHE: T10-Restpunkte nie als erledigt gemeldet

### [wmf14wrxt.json] 106 (Diff Spur mess-und-plattform, 20 Positionen)
GEGENSTAND: KRITISCH: (1) echter Messlauf FEHLT (einziger persistierter Lauf = m3v2-smoke 16 Zeilen; golden-320 #9916 nie persistiert, "KEIN legitimer Systembeweis"); (2) Pflicht-Datensaetze FEHLEN im Messpfad (Akten da, Loader-MESS-Konsum "dokumentierter offener Folge-Schritt"; gemessen wird algo.lookup(rng()&0xFF) = 256er-Zufallsraum; golden fuehrt nur 2-3 Akten); (3) CLU+Footprint als Erfolgs-Metrik FEHLEN (173 CSV-Spalten ohne CLU/Footprint/Advisor; MeasurementCategory::CLU nur namensvalidiert); (4) 3 Verifikationsmodi/Ablation FEHLEN (Enum da, keine Modus-Spalte, ablation=0 Treffer); (5) LLC/L3 TEILWEISE (L1+dTLB echt; l2/l3/energy honest-0 in allen 16 Zeilen). HOCH: (6) Hybrid-Regel FEHLT (cpu_atom 0/1265; PMC-Quelle oeffnet ohne PMU-Wahl; AP-13 bewusst ungesetzt; G-270a User-Gate); (7) Core-Modus-Achse FEHLT (thread_pinning.hpp existiert, Konsument nur f15_compare+Test; keine Core-Spalte); (8) Barnard/Sapphire FEHLT (0 Treffer barnard|slurm|zih; Mess-Jobs tags amd); (9) Hybrid-Messmaschine: 14900KS GESTORBEN/RMA, "bis ~September BLOCKIERT" -- ABER prod2 ist heute i9-12900K (Alder Lake-S, HYBRID) mit gruenem pmc:intel: "der Hybrid-Anteil der Forschungsfrage ist nicht hardware-, sondern job-definitions-gated. Das ist der billigste Hebel im ganzen Diff: eine zweite Lane auf [baremetal, intel] plus PMU-getrennte Counter-Oeffnung wuerde Position 6, 7 und 9 zugleich adressieren."; (10) Wiederholungen ABGEWICHEN (Plan 5, Owner-E3 16.07. = 3 Pflicht, Ist repetition=0 = faktisch 1 -- Abweichung im Methodikkapitel benennen); (11) Repro-Stempel TEILWEISE (kein commit/compiler/seed als Spalte); (12) cycles/instructions/IPC/branch-misses FEHLEN; (13) ISA ABGEWICHEN (avx512 "bleibt draussen" trotz prod1=zen5-avx512; arm allow_failure); (14) p95 fehlt (nur p50/p99); (15) cpu_class/telemetry_strategy/sampling_n-Spalten FEHLEN; (16) fairness_mode TEILWEISE (nur Beispielprofil); (20) Speicherbilanz TEILWEISE (kein bytes_per_key, keine Poolgroessen). ERFUELLT: (17) vereinte CEB wallclock+macro+micro (F-3-Regression geheilt 06.08.); (18) keine Perzentil-Mittelung (repetition_plan.hpp separat); (19) YCSB A-F.
ORT: Diff-Tabelle mit Belegen (siehe Quelle); ce libs 1265 Dateien
SOLL/FIX: je Position; Hebel-Empfehlung Position 9 VERBATIM oben.
STATUS LT. QUELLE: offen (5 KRITISCH, 8 HOCH, Rest MITTEL/erfuellt)
ABHAENGIGKEIT/FLAECHE: O-A/PMC-Strecke; T11 M2; golden-Matrix

### [wmf14wrxt.json] 107 (Diff Achsen+Bausteine, A1-D4)
GEGENSTAND: KRITISCH: A1 kein PRT-ART-/SOTA-Messartefakt (0 Treffer in allen measurements.csv; pruefling_type='-' 16/16; Messreihe A existiert nicht); A2 PMC-Quelle aggregiert genau so, wie T3 verbietet (keine PMU-Typ-Ermittlung /sys/devices/cpu_core/type; cpu_class-Erzeuger fehlt ganz); A3 Prefix-Operationen existieren NIRGENDS (OperationKind ohne Prefix; Ops-Kanon OP-1..6 ohne Prefix/Exact-Miss; golden nutzt OP-1+OP-3) -- "der Dominanzanspruch der Arbeit ist so nicht messbar"; A4 alle SOTA-Adapter default OFF -- im Default-Build laeuft kein einziger Original-Baseline-Code. HOCH: B1 Core-Modus im XSD nicht ausdrueckbar; B2 Wiederholungen 3 statt 5, real 1; B3 Ordnungsmodus-Achse existiert ueberhaupt nicht (H2/H4/T1-H4 haengen daran); B4 12 Sub-Engine-Interfaces C01-C12 mit 0 Implementierungen (ohne Gegenstueck: C02 Pinning, C04 Coherence, C10 Topologie); B5 Fairness-Mechanik gebaut, nie benutzt; B6 Datensaetze 3/6 verwendet (davon 2 nicht aus der Pflichtliste); B7 Messreihe B als Duplikat von A_full deklariert. MITTEL: C1 Goldstandard-Bilanz ueber 28 Achsen (Registry 28/28, StrategyBase 23/28, ConfigSet 0/28, Flags 8/28, Wrappers 0/28, axis-CMakeLists 0/28 -- selbst Referenzachse unvollstaendig); C2 vier unvereinbare Achsen-Zaehlstaende (17 Themen/28 axis_*/424 hpp vs. 18 golden vs. 11 permutation_axes.xml vs. 19+3 T11) -- jede Thesis-Zahl braucht die Ebene; C3 sechster Seitentyp heisst _bplus (Masstree), nicht B2-Decision/Span; C4 Advisor-Wrapper = leeres Skelett, CLU strukturell modelliert (ehrlicher Ersatz); C5 zwei Exporter ungleich (binary_to_csv 16 Spalten, 12/13 honest-0); C6 commit/compiler/seed fehlen als Spalten; C7 Pseudo-Prefetch unveraendert; C8 AVX-512 in keiner Mess-Deklaration; C9 PRT-ART Map-Pfad weiter std::map + Codegen-Stub (realer Pfad CE-seitig prt_art_reference); C10 migration adaptive/tier_based nicht in Messmenge; C11 CacheEngineMode keine Mess-Dimension. NIEDRIG: D1 libs/search_engine = 8 leere Skelett-Ordner (Namensdrift); D2 num_p_cores/num_e_cores tote Deklaration; D3 prt_art->art.profile.xml irrefuehrend aber wirkungslos; D4 "Rang statt Tier" im Manuskript ERFUELLT. ERFUELLT-Liste (E): Seitentypfamilie 5/6, ValueHandle inkl. chain_ref, Flag-System 10 Baenke, 32-Byte-POD exakt wie geplant (ohne Erzeuger), Anatomy/ABI, Welch, PMC weiter als Plan-Stand (T11-Limitierung ueberholt), Datensatz-Akten mechanisch, NodeChunkedStore fortentwickelt, Kern-/Erweiterungsmatrix abbildbar. Ledger-Luecken: Ordnungsmodi/Common-Denominator/Ablation/Relocation/Prefix-Lookup/art.profile.xml = je 0 Ledger-Treffer.
ORT: Diff-Tabellen (siehe Quelle); super 18a0bdf3, ce 90bca126
SOLL/FIX: "Die drei am billigsten zu schliessenden Luecken mit dem groessten Abgabe-Hebel ... : fairness= in die produktiven Profile eintragen (B5), <repetitions count=5> statt 3 (B2, ein Attribut), und die drei fehlenden Pflichtdatensaetze in <datasets> des Golden aufnehmen (B6) -- alle drei reine Deklarationen."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: golden-Anker (Voll-Gate); MESS-NENNER; S-Wellen

### [wmf14wrxt.json] 108 (Diff Hypothesen+Abgabe)
GEGENSTAND: Hypothesen-Datengrundlage heute: T4-H1 KEINE (Kontrastbedingung fehlt); T4-H2 KEINE -- "alle vier Bedingungsvariablen fehlen oder sind konstant ... die am vollstaendigsten unbelegte Hypothese des Korpus"; Thesis-H1 KEINE (page_type build-only); T1-H1 TEILWEISE (L1+dTLB real, aber Position 9: physikalisch unmoegliche Zeile -- total_ns=46ms bei L1-Misses=1.17e9 => >6 Misses/Zyklus; l3=0 trotz geoeffnetem Counter -- Mess-Validitaet VOR jedem Voll-Lauf klaeren); T1-H3/FF3 KEINE fuer Prefix; T1-H4 KEINE; T4-H3 SCHWACH; T4-H4 KEINE; FF1 TRAGFAEHIG (einzige belegbare FF); FF2/FF4 TEILWEISE. Weitere: Kapitel 7 leer (05_evaluation.tex:182-186 "vollstaendige Laeufe stehen aus"); 8-Rang-1-SOTA nur 6 gebaut (sota_catalog.hpp:272; CoCo-Trie + B2-Baum fehlen als Lebewesen -- Ledger-DoD-4 ">=8" nicht erfuellbar ohne Nachzug); H1/H2/H3-Auswertungsfelder ohne Erzeuger (nur Test setzt sie; h1_clu_validated() liefert dauerhaft false); Thesis-H2-Qualitaets-Audit: implementiert ist EINE cppcheck-Zahl statt 7-Achsen-Audit, docs/quality_audit existiert nicht; EN stale ("neunzehn" vs. DE "achtzehn"); 3 Widersprueche Plan<->Notiz: Ledger:68 "honest-0 bis #26" UND Anhang "NullPmcSource" BEIDE von der CSV widerlegt (pmc_available=1, L1/dTLB real) -- beide Aussagen heute unrichtig in verschiedene Richtungen; Thesis behauptet String-Datensaetze ohne Code-Konsument; DoD-4 >=8 vs. 6 gebaut.
ORT: TH/kapitel + CE (siehe Quelle)
SOLL/FIX: kuerzester Weg VERBATIM: "(a) page_type von build-only in die permutierende Achsenmenge heben ...; (b) Prefix-Lookup/-Enumeration in WorkloadGenerator + OperationKind + Mess-POD ergaenzen ...; (c) CacheEngineMode als Mess-Dimension mit BASELINE_NO_ENGINE verdrahten ...; (d) pmc:intel/prod2 ... fuer EINEN Lauf oeffnen und cpu_class in die CSV nehmen ...; (e) die L1-Zaehler-Plausibilitaet (#9) klaeren, BEVOR ein mehrtaegiger Voll-Lauf 131.072 Permutationen mit demselben Zaehler schreibt."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Abgabe/Thesis; O-A; Mess-Trigger

### [wmf14wrxt.json] 109 (Kanon-Synthese)
GEGENSTAND: KANON-Dokument geschrieben: docs/plaene/20260806-KANON-termine-plan-soll-gegen-ist.md mit den ZEHN SCHWERSTEN FEHLSTELLEN: 1 kein PRT-ART/SOTA-Messergebnis; 2 Hybrid-Term per Test auf false zementiert; 3 Prefix-Ops existieren nirgends; 4 page_type build-only ("groesster Einzelhebel im Diff"); 5 Ablationsstufe keine Mess-Dimension ("ohne die Off-Stufe ist FF0 kausal unbeantwortbar"); 6 sechs Pflichtdatensaetze nicht gemessen; 7 einzige reale PMC-Daten physikalisch unmoeglich; 8 Pruefling unterscheidet sich von ART in einer von 18 Achsen; 9 zweite Pflichtplattform fehlt + Wiederholungen unterschritten; 10 docs/termine/INDEX.md = mechanischer Erzeuger der Luecke (endet bei T8).
ORT: /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/plaene/20260806-KANON-termine-plan-soll-gegen-ist.md
SOLL/FIX: Fehlstellen 1-10 als Design-Grundlage.
STATUS LT. QUELLE: Kanon geschrieben (im Hauptcheckout-Pfad! -- Verortung gegen wt-super-landung pruefen); Fehlstellen offen
ABHAENGIGKEIT/FLAECHE: alle Mess-/Abgabe-Straenge; Stand 06.08. -- gegen KON58-Stand abgleichen

## SCHLUSS-BILANZ LESER 3
13 von 13 Batch-Dateien vollstaendig gelesen (Quell-JSONs via strukturtreuem Dump; ueberlange Zeilen per fold aufgeloest und vollstaendig nachgelesen). 109 nummerierte Extraktions-Posten.
LUECKEN/QUELLEN-DEFEKTE: (1) w41d6x1yq.json: alle 5 korrektur_gruppen-Reports bei 2500 Zeichen und beide verifikation-Reports bei 3000 Zeichen in der QUELLE hart abgeschnitten (F-9-Inhalt, G3-H-3-Rest, G4-Dateiliste, Anker-Restfehler-Liste, Verify-Punkt-3-Residual unvollstaendig). (2) wn7jy2yah.json Los 4 = 0 Posten (leer in der Quelle). (3) wmphtm0ki: Gegen-Explore erhielt den Erst-Bericht selbst nur abgeschnitten (Abschnitte C+D fehlten ihm; im Dump vollstaendig vorhanden und extrahiert). Keine weiteren Luecken.
ZEITSCHICHTEN-WARNUNG fuer den Designer: Batch enthaelt Staende vom 06.08. bis 13.08.; juengere Quellen (wisfvjd8z-Diff 07.08., w4ffuvkx9/KON55 13.08.) ueberholen aeltere (wmphtm0ki, wmf14wrxt 06.08.) in Einzelpunkten -- Konflikt-Hinweise sind in den ABHAENGIGKEIT-Zeilen markiert (insb. Fund 79 vs. 29: Talos-Fassung; Fund 94 vs. 58: allow_failure-Empfehlung; Fund 91 vs. 43: Gitlink-Heilung).
SELBSTCHECK: Datei ASCII-only geschrieben (Transliteration ue/oe/ae/ss, -> fuer Pfeile); jede Zahl traegt ihren Nenner aus der Quelle; VERBATIM-Markierungen kennzeichnen woertliche Auflagen; /usr/bin/grep-Doktrin und K11 (kein rc nach Pipe) eingehalten; nur unter komplexfix_design_arbeit geschrieben; Repos nicht angefasst.
