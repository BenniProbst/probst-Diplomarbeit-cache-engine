# LESER 02 -- Extraktion (Batch i%12==1 der gb_dateiliste.json, 13 Dateien)

BATCH-DATEILISTE (Index in gb_dateiliste.json, Name, Groesse Bytes):
- i=1   wktkhd1cj.json  589739  (80-Seiten-Gesamt-Dossier der Session 5a19728e, Stand 06./07.08.)
- i=13  wa91q7g1p.json  155061  (SIMD-Versionen-Web-Recherche, Owner-Auftrag)
- i=25  wwbu56lus.json  106479  (Offene Rueckfragen gegen Ledger+Plan+Memories pruefen)
- i=37  w2zv55j8v.json   87240  (#29 Zielstruktur-Schnitt 4 Traeger-Unterprojekte + G-1-Grammatik)
- i=49  w2kgif6e9.json   69874  (KON19: 5 Explore-Auftraege IO-Meta-Meta/Hybrid-K2/dump-plan/Pruefdock-Retry/OD-7)
- i=61  wk2fvgrgv.json   46918  (Doku-Sortierung Umbrella vs. Cache Engine)
- i=73  wtdpeiotj.json   36152  (Sequentielle Konsolidierung Gesamt-Dossier, Fable-Fold)
- i=85  ws4t2r8ry.json   30748  (F5-Planung GOLDEN-UPDATE-Fenster, bindender Bauplan)
- i=97  won0hr04n.json   23243  (LUECKE: baut die Thesis? LaTeX/blg/alphadin/Gate-8)
- i=109 whfxvxf8q.json   18051  (Pflicht-Behebung 22 Lens-Funde am S-14a-Riegel)
- i=121 wtpunni0p.json   13068  (B14-NB2-Verifikation nach Spend-Limit-Abriss, Commit 953ce412)
- i=133 wapd7pd7p.json    8737  (T2-A-Fortsetzung nach Spend-Limit-Abriss: K2+F4)
- i=145 wouqomuwl.json    5375  (Posten 92 Option A: Registry-Modelle comment-only harmonisieren)

WORKFLOW-METADATEN-BEFUND (alle 13 Dateien gescannt): nur w2kgif6e9.json traegt
Agent-Fehler (2x), alle anderen Steps state=done, logs leer bzw. nur informativ.

---

### [wouqomuwl.json] 1
GEGENSTAND: Posten 92 Option A umgesetzt -- 2er-vs-3er-Registry-Modelle in validate_profile.hpp dokumentarisch harmonisiert (comment-only), Commit existiert, aber NICHT gepusht.
ORT: Branch b-p92-registry-kanon, Worktree /home/comdare/wt-b-p92, SHA 8065aec04566d5b3ad7effc6c14c2d785cce55dc, Basis c837d830; Dateien libs/cache_engine/profile_facade/CMakeLists.txt (+8) und libs/cache_engine/profile_facade/validate_profile.hpp (+25)
SOLL/FIX: Landung des Commits (33 Einfuegungen, 0 Loeschungen, comment-only bewiesen: RC_grep=1 = keine Code-Zeile; ASCII-Check der addierten Zeilen 0; TABU xml/csv 0). Keine ctest-Vollgates gefahren, Begruendung: 0 Code-Zeilen.
STATUS LT. QUELLE: behoben@8065aec0, KEIN Push -- landereif-vorbereitet, nicht gelandet
ABHAENGIGKEIT/FLAECHE: Merge-Flaeche validate_profile.hpp -- kollidiert potenziell mit B14/organ_subaxes-Kartierung (siehe [wtpunni0p.json] 6, dort ist validate_profile.hpp als Einbauort gelistet)

### [wouqomuwl.json] 2
GEGENSTAND: Vorzustand-Defekt: die vorhandenen Build-Baeume build/gcc-release und build/generated sind STALE (pre-L17 generated_source_catalog.hpp) und koennen die TU-Kette nicht mehr uebersetzen.
ORT: ce-Repo, build/gcc-release und build/generated (Haupt-Checkout)
SOLL/FIX: Quelle umging es via frischem CMake-Baum im Worktree (cmake --preset gcc-release -B /home/comdare/wt-b-p92/build/p92, RC=0). Kein Fix des Vorzustands selbst genannt -- Re-Configure der stalen Baeume steht aus (deckt sich mit Memory J-1..J-4 Vollbau-Luecken).
STATUS LT. QUELLE: offen (als Vorzustand deklariert, unabhaengig vom P92-Diff)
ABHAENGIGKEIT/FLAECHE: jeder weitere Bau am ce-Haupt-Checkout

### [wouqomuwl.json] 3
GEGENSTAND: Befund-Verifikation am Objekt: 2er-Modell (validate_profile.hpp:872 Kopf-Doku, :1137-1164 map_mode-Zweig; Aufrufer super 02_messung_driver/main.cpp:1212-1220 und apps/experiment_planner/main.cpp:192-193) und 3er-Modell (struct RegistryTrio organ/system/measurement, prt ABWESEND; Konsum profile_run_facade.cpp:864-866) bestaetigt; Single-Source: COMDARE_CE_AXIS_REGISTRY (profile_facade/CMakeLists.txt:156) und COMDARE_CE_AXIS_REGISTRY_PATH (02_messung_driver/CMakeLists.txt:41, apps/experiment_planner/CMakeLists.txt:37) zeigen literal beide auf libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml, OHNE gemeinsame CMake-Variable.
ORT: siehe Pfad:Zeile-Angaben im Gegenstand
SOLL/FIX: nur dokumentarisch harmonisiert (Option A). Die fehlende gemeinsame CMake-Variable bleibt als strukturelle Doppelung bestehen (kein Auftrag).
STATUS LT. QUELLE: nur-hinweis (bestaetigt, comment-only adressiert)
ABHAENGIGKEIT/FLAECHE: -

### [wouqomuwl.json] 4
GEGENSTAND: Abweichung vom woertlichen Auftrag: CMake-Kommentar wurde zuerst mitten in den bestehenden "# S3 P-RESOLVER"-Satz gesetzt, erkannt und korrigiert (neuer Block jetzt VOR dem bestehenden, durch #-Leerzeile getrennt); Worktree enthaelt unversionierten Build-Baum /home/comdare/wt-b-p92/build/p92 (nicht committet, bei Bedarf loeschbar).
ORT: /home/comdare/wt-b-p92 (Worktree), libs/cache_engine/profile_facade/CMakeLists.txt
SOLL/FIX: Build-Baum bei Bedarf loeschen; Kommentar-Position bereits korrigiert.
STATUS LT. QUELLE: behoben (Kommentar) / nur-hinweis (Build-Baum-Rest)
ABHAENGIGKEIT/FLAECHE: Worktree-Lebenszyklus-Regel (erst loeschen wenn gruen+gemergt)

### [wapd7pd7p.json] 1
GEGENSTAND: T2-A-Fortsetzung abgeschlossen: K2 (Mess-Resume haengt am VOLLEN Fingerprint, resume-v5->v6) als Commit b4c343b9 und F4 (Batch-Plan VOR dem Lauf + Phasenzaehler) als Commit 3a42bf90; Worktree /home/comdare/wt-b2-neuanker, Branch b2-neuanker-format3, HEAD=3a42bf90, Working Tree LEER, KEIN Push (origin/development unveraendert c837d830).
ORT: Branch b2-neuanker-format3 @ 3a42bf90 (K2=b4c343b9, Basis-Kette faa525d7^..HEAD, WIP-Uebernahme ab 61a95bae)
SOLL/FIX: Landung steht aus; Gates liefen gruen: 2-Pass-Configure RC=0, Voll-Bau 0x error:, ctest 2x "100% tests passed, 0 tests failed out of 408", golden 3/3+CRC+Roundtrip 5/5, TABU/Frozen/Nicht-ASCII je 0; Gate-Basis 408 unveraendert; clang-format-22.1.8 format-diff-Zeilen=0 (heilt 47 Zeilen K2-WIP-Drift).
STATUS LT. QUELLE: behoben@3a42bf90 (Bau fertig), Landung offen
ABHAENGIGKEIT/FLAECHE: Merge-Flaeche cache_engine_builder_iterator.hpp / batch_planner.hpp / SlicePlanner -- T2-A-Hoheit; kollidiert mit B14-ce-Anteil-Kartierung (wtpunni0p verweist explizit, dass diese Dateien T2-A-Hoheit sind)

### [wapd7pd7p.json] 2
GEGENSTAND: OFFENER PUNKT 1 (verbatim): "Host-Belegung von `batch_plan_datei` fehlt (Facade/CEB, super-Repo -- ausserhalb dieses Worktrees). Bis dahin ist die Plan-Ablage gebaut+bewiesen, im Produktions-Lauf aber inert -- dasselbe Opt-in-Muster wie die uebrigen bestandslog-Injektionen. Ohne diese Belegung traegt F4 im Voll-Bau-4 noch keinen Resume."
ORT: super-Repo, Facade/CEB (LazyRunConfig::batch_plan_datei bleibt unbelegt)
SOLL/FIX: Host-Belegung von batch_plan_datei im super-Repo nachziehen, damit F4-Resume im Voll-Bau-4 wirkt.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: super-Repo-Aenderung noetig, abhaengig von Landung b2-neuanker-format3

### [wapd7pd7p.json] 3
GEGENSTAND: OFFENER PUNKT 2: BatchPlanner (B5-Zwilling) ist weiterhin nur test-verdrahtet; hat Konsolidierung-vor-Strom bekommen, aber bewusst KEINE eigene Ablage (waere toter Code); Ablage-Substanz liegt geteilt in batch_planner.hpp.
ORT: ce batch_planner.hpp (Branch b2-neuanker-format3)
SOLL/FIX: kein Fix noetig lt. Quelle (bewusste Entscheidung), aber als Zustand festgehalten.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

### [wapd7pd7p.json] 4
GEGENSTAND: OFFENER PUNKT 3: Gate-Spiegel liegt auf Platte, NICHT committet -- 29 Dateien t2a-* + 3 DOPPELLAUF-LITERALE-T2A-{K2,F4,GESAMT}.txt unter /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/backups/20260806-neuanker-teil2/gates/ (gitleaks-Ersatzpruefung: 0 Token-Treffer). "Commit in super dev steht dem Lead zu."
ORT: super docs/sessions/backups/20260806-neuanker-teil2/gates/ (untracked)
SOLL/FIX: Commit in super development durch den Lead.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: super development (lokal voraus) -- Landungs-/BU-SOFORT-Regel

### [wapd7pd7p.json] 5
GEGENSTAND: OFFENER PUNKT 4: Dual-Review (Fable + Codex) ueber faa525d7^..HEAD steht aus; danach L1-Buendel.
ORT: Branch b2-neuanker-format3, Bereich faa525d7^..3a42bf90
SOLL/FIX: Dual-Review fahren, danach L1-Buendel.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Landungsreihenfolge T2-A; CODE-REVIEW-ANALYSE-Regel (Opus 5 max EXPLORE + Fable 5 max ANALYST)

### [wapd7pd7p.json] 6
GEGENSTAND: OFFENER PUNKT 5: Zaehler `gemessen` ist per Konstruktion BILANZ, nicht zweite Resume-Autoritaet (feinkoerniger Mess-Resume bleibt die per-Binary result.csv+stamp-Naht aus K2); im Code und in der Commit-Nachricht explizit so benannt, "falls der Review das anders gewichtet sehen will".
ORT: ce batch_planner.hpp / run_planer_driven_provision (b2-neuanker-format3)
SOLL/FIX: Review-Entscheid, ob Gewichtung anders gewollt; sonst kein Fix.
STATUS LT. QUELLE: nur-hinweis (Review-Vorbehalt)
ABHAENGIGKEIT/FLAECHE: Dual-Review aus Punkt 4

### [wapd7pd7p.json] 7
GEGENSTAND: SHA-/Beweis-Behauptungen: Eintritts-Gate HEAD war 61a95bae mit GENAU 5 angekuendigten WIP-Dateien; Frozen-Fixtures blob-identisch zu faa525d7 (test_g3_sha512_index.cpp 27cfbecb61f8c2276d4e01f6f4d6b7437d02923b, test_w10_system_cell_values.cpp 9555a696cb1ae34fac6377c0fcb9b505c4a0e57d, test_m_w12_stamp_bausteine.cpp 60e18132dabd90520a85ad40d552462ad8df6c93); Frozen-Preimage 560 Bytes, Digest 17148e5a...89374; WIP-Diffs bewertet: alle UEBERNOMMEN (test-Datei erweitert, 47 Zeilen Format-Drift geheilt), VERWORFEN: nichts.
ORT: Branch b2-neuanker-format3
SOLL/FIX: -
STATUS LT. QUELLE: nur-hinweis (Quittung ohne Restzweifel)
ABHAENGIGKEIT/FLAECHE: -

### [wtpunni0p.json] 1
GEGENSTAND: B14-NB2-Verifikation: alle 6 Befunde des super-Commits 953ce412 (Diff d8073913..953ce412) unabhaengig GEDECKT (N=2^17 maschinenlesbar via run_options cap="131072" + XSD; search_algo-Pin auf k_ary/interpolation; leere/abgeschnittene XML hart ROT; Gesamtzahl 4x4x2^17=2097152 korrigiert, 524288 als line_size-Teilprodukt umgewidmet; CDATA-/Attribut->-Haertung; fehlende SCHEMA/MASTER -> FAIL statt Skip). Zusaetzlich alle 34 neuen allowed_variants-Namen gegen cache_engine_axis_registry.xml aufgeloest: 18/18 Achsen OK und 18/18 FIRST2-MATCH gegen mp_take_c<EnabledStrategies,2>; Produkt = 131072 = cap beider Traeger.
ORT: super, Commit 953ce412; Wachen comdare_read_markup (:127,:134), comdare_collect_instance_names (:268,:277), comdare_scan_tags (:202,:154), comdare_strip_cdata (:76), golden_n_consistency_check.cmake; Fixtures test_data_xml/ und thesis_tiere/ experiment_golden_kern.xml + experiment_golden.xml
SOLL/FIX: keine Nachbesserung noetig auf super-Seite ("No nachbesserung was needed").
STATUS LT. QUELLE: behoben@953ce412, verifiziert
ABHAENGIGKEIT/FLAECHE: -

### [wtpunni0p.json] 2
GEGENSTAND: Gates literal nachgefahren (Build-Dir Code/build/b14): ctest -L fixture_sync -> 5/5 Passed (Auftrag nannte "4/4", Ist ist 5/5 wegen neuer Wache test_golden_n_consistency, keine bestehende verschwunden); ctest -L da_unit -j3 und -j1 je 116/116; xmllint XSD RC=0; 4/4 Instanzen validieren; ASCII-Check Additions 0.
ORT: super, Code/build/b14
SOLL/FIX: Auftragstext (4/4) gegen Ist (5/5) im Ledger nachfuehren.
STATUS LT. QUELLE: nur-hinweis (Diskrepanz Auftrag vs. Ist, positiv)
ABHAENGIGKEIT/FLAECHE: Ledger-Nachfuehrung

### [wtpunni0p.json] 3
GEGENSTAND: Biss-Beweise erbracht (/tmp/b14biss, tracked files unberuehrt): 7 Praeparate je ALT RC=0 vs. NEU RC=1 (leere XML, CDATA-Trick, > im Attributwert, trunkierte Wurzel, < ohne > am Dateiende, fehlender MASTER, fehlendes SCHEMA); Kontrolle fehlende FIXTURE bleibt der EINE legitime SKIP (RC=0). Kettenwache golden_n_consistency_check.cmake: Positivkontrolle RC=0 (18 Achsen deckungsgleich, Produkt=131072) + 6 Praeparate RC=1; entscheidender H1-Beweis: nach Loeschen der run_options-Zeile stehen weiterhin 5 Vorkommen von cap="131072" im Fliesstext -- Wache lehnt trotzdem ab ("ein Kommentar ist keine Bauanleitung").
ORT: super 953ce412, Praeparate /tmp/b14biss (fluechtig)
SOLL/FIX: -
STATUS LT. QUELLE: behoben/bewiesen
ABHAENGIGKEIT/FLAECHE: /tmp-Fluechtigkeit der Beweis-Praeparate (nur Beweis, kein Bestand)

### [wtpunni0p.json] 4
GEGENSTAND: KONFLIKT/Commit-Text-Regression: Der Commit-Text von 953ce412 behauptet "ce UNBERUEHRT: HEAD 7969b399..., git status --porcelain = 0 Zeilen" -- DAS STIMMT NICHT MEHR. Der Vorgaenger legte NACH dem super-Commit (10:31:21) um 10:32:16 den ce-Worktree /home/comdare/wt-b14-ce (Branch b14-ce-anteil, HEAD c837d830) an, mit 2 UNCOMMITTED Dateien +101/-15: libs/cache_engine/anatomy/abi_adapter.hpp (mtime 10:47) und libs/cache_engine/axes/layout/axis_05_memory_layout_observable.hpp (mtime 10:36).
ORT: /home/comdare/wt-b14-ce, Branch b14-ce-anteil @ c837d830, uncommitted
SOLL/FIX: verbatim Auflage: "die Zeile `ce UNBERUEHRT ... git status --porcelain = 0 Zeilen` war zum Commit-Zeitpunkt wahr, ist aber jetzt falsch. Sie darf nicht als Ist-Aussage in den Ledger wandern."
STATUS LT. QUELLE: offen (Ledger-Hygiene)
ABHAENGIGKEIT/FLAECHE: Ledger; ce-Worktree-Bestand

### [wtpunni0p.json] 5
GEGENSTAND: Auflage kLbufBytes/abi_adapter: INHALTLICH FERTIG, aber UNCOMMITTED -- alle neun 64-Literale in den drei Mess-Pfaden (run_workload, run_workload_segmented, run_workload_segmented_v2) auf line_bytes_of<MemLayout>() abgeleitet, je Pfad static_assert-Untergrenze; Forwarding-Fix real und noetig (class ObservableMemoryLayout hat KEINE Basisklasse, ALT fiel line_bytes_of zwangslaeufig auf kDefaultLineBytes = stiller 64er = stiller OOB). Verifiziert: g++ -fsyntax-only RC=0; static_asserts halten (16384*round_up(48,64)==1048576). Uncommitted-Stand gesichert als /tmp/b14-ce-rettung/b14-ce-anteil-uncommitted-20260806-1058.patch -- ACHTUNG: /tmp ist nicht neustartfest.
ORT: /home/comdare/wt-b14-ce/libs/cache_engine/anatomy/abi_adapter.hpp + axes/layout/axis_05_memory_layout_observable.hpp (uncommitted)
SOLL/FIX: verbatim: "Entscheid noetig: ce-Anteil committen (dann `b14-ce-anteil`, eigene Gates, ce-Doppellauf) oder verwerfen -- der Stand haengt derzeit uncommitted und nur in /tmp gesichert." "wenn der Stand ueberleben soll, braucht er einen Commit auf `b14-ce-anteil` oder eine Kopie ausserhalb von /tmp."
STATUS LT. QUELLE: teilweise (inhaltlich fertig, nicht committet, Sicherung fluechtig)
ABHAENGIGKEIT/FLAECHE: Ein-Schreiber-/T2-A-Hoheit auf ce in diesem Fenster (Owner-Entscheidung); Kollision mit b2-neuanker-format3-Landung

### [wtpunni0p.json] 6
GEGENSTAND: Auflage organ_subaxes-Parser: OFFEN, 0 Zeilen Arbeit -- grep -rn "organ_subaxes" ueber gesamtes ce-Repo = 0 Treffer; parse_experiment_profile (xml_config_parser.cpp:444ff) liest axes_default_lookup bei :486, kennt aber weder organ_subaxes noch run_options; die run_options-Lesung :424-432 gehoert dem thesis-Dialekt (tp), nicht dem Experiment-Dialekt. Das neue <run_options> des super-Commits 953ce412 ist damit heute rein deklarativ. Kartierung der Einbauorte (nur Dateiliste, T2-A-Hoheit gemieden): xml_config_parser.hpp (struct ExperimentProfile :441, Feld analog axes_default_lookup :452, ThesisRunOptions :192 als Wiederverwendungs-Typ); xml_config_parser.cpp (parse_experiment_profile :444ff, Einbau neben :486); validate_profile.hpp (Pruefungen (5)/(12)-Analogon); experiment_plan_director.hpp (Weiterreichung); tests test_experiment_parser.cpp + test_experiment_kern_seam.cpp; Fixture thesis_tiere/experiment_golden_kern.xml. NICHT in der Liste: cache_engine_builder_iterator.hpp, profile_run_entry.hpp, batch_planner.hpp (T2-A-Hoheit).
ORT: ce libs/common/serialization/xml_config_parser/* + profile_facade/* (Einbau fehlt komplett)
SOLL/FIX: organ_subaxes- (und run_options-) Lesung im ce-Experiment-Dialekt implementieren gem. Kartierung.
STATUS LT. QUELLE: offen (0 Zeilen)
ABHAENGIGKEIT/FLAECHE: validate_profile.hpp-Flaeche (Kollision mit P92-Commit 8065aec0, comment-only); T2-A-Hoheit auf builder_iterator/batch_planner

### [wtpunni0p.json] 7
GEGENSTAND: Gesamt-Verdikt-Vorschlag: "LANDEBEREIT-fuer-Codex-Lens" fuer super-Anteil 953ce412, mit 2 Auflagen (Commit-Text-Regression nicht in Ledger; Entscheid ce-Anteil committen oder verwerfen). Offener Owner-Punkt aus dem Commit unveraendert gueltig: bleibt der search_algo-Pin {k_ary, interpolation} oder wechselt er auf Kontrast {k_ary, linear_scan}? Ein Wechsel bewegt beide Traeger. Kein Blocker. Rescue-Ref beidseitig vorhanden (origin + github); TABU 6/6 unberuehrt (inkl. all_axes_golden.profile.xml nur gelesen), kein Gitlink im Diff.
ORT: super 953ce412; Owner-Frage search_algo-Pin
SOLL/FIX: Codex-Lens fahren; Owner-Frage search_algo-Pin entscheiden (bewegt beide Traeger).
STATUS LT. QUELLE: offen (Lens + Owner-Frage)
ABHAENGIGKEIT/FLAECHE: Owner-Frage; beide golden-Traeger (test_data_xml + thesis_tiere)

### [whfxvxf8q.json] 1
GEGENSTAND: Pflicht-Behebung aller 22 Lens-Funde am S-14a-Riegel (Codex 8 + Fable-Lens 16, 4 ERNST live) -- Commit b12afd32 "fix(s14): Pflicht-Fixup 2 -- sieben Fund-Gruppen am Riegel geschlossen (Rot-zuerst, 2 Lenses): Ruhelage-Pruefung, Exit 3 REGEN ERFORDERLICH + CI-Byte-Identitaets-Zwang, Literal-Liste, Marker-Strenge, Mindest-Nenner, Scanner-Robustheit, Test-Luecken; Koeder A-S; golden 158 byte-stabil".
ORT: ce, tools/axis_version_lock/ (axis_version.lock, Tripwire-Test #169), SHA b12afd32; Branch nicht im Result genannt (S-14a-Riegel-Strecke)
SOLL/FIX: Landung mit Auflagen; landefaehig-Feld = "JA_MIT_AUFLAGEN".
STATUS LT. QUELLE: behoben@b12afd32, Landung mit bindenden Auflagen offen
ABHAENGIGKEIT/FLAECHE: KON55-Kombibau (siehe naechster Posten); CI-Job-Umstellung --write + git diff --exit-code

### [whfxvxf8q.json] 2
GEGENSTAND: KON55-KOMBIBAU NICHT ABGESCHLOSSEN: gcc-Debug-Vollbau lief bei erzwungener Abgabe (2401 Ninja-Ziele, zuletzt ~1791 gebaut, 0 Warnungen/Fehler in den geaenderten Dateien, ctest-Gesamtbilanz stand aus; Log /tmp/s14_kombi_gcc-deb.log, Monitor bgx93vlhl aktiv); gcc-Release, clang-Debug, clang-Release NICHT gestartet (Skript build-s14-kombi.sh liegt bereit: je Kombination J-1..J-4 + volle ctest-Suite, df-Wache <8G eingebaut). Dedizierter Riegel-ctest bestanden: Test #169 test_s14_axis_version_lock_tripwire Passed, 100% out of 1 (Nenner 1 von 1; Koeder A-S alle im -V-Log mit erwarteten Exit-Codes).
ORT: ce Worktree der S-14-Strecke, build-s14-redfirst / build-s14-gcc-deb; /tmp/s14_kombi_gcc-deb.log
SOLL/FIX: verbatim offener Punkt 1: "KON55-Kombibau nachholen (bindende Auflage vor Merge): sh build-s14-kombi.sh gcc g++ Release gcc-rel / clang clang++ Debug clang-deb / clang clang++ Release clang-rel im Worktree fahren, je volle ctest-Bilanz literal protokollieren; gcc-Debug-Lauf (/tmp/s14_kombi_gcc-deb.log) zu Ende lesen -- die Abgabe wurde vom Orchestrator erzwungen, waehrend er lief."
STATUS LT. QUELLE: offen (bindende Auflage vor Merge)
ABHAENGIGKEIT/FLAECHE: Merge des S-14a-Riegels; /tmp-Fluechtigkeit des Logs

### [whfxvxf8q.json] 3
GEGENSTAND: Offener Punkt 2: Warnungs-Review zweiter Durchgang (clang) steht mit den clang-Kombinationen aus; gcc-Seite bis Abbruch 0 Treffer auf die geaenderten Dateien.
ORT: ce S-14-Strecke
SOLL/FIX: clang-Kombinationen fahren, Warnungs-Review clang durchfuehren (Memory-Regel: GCC -> aufraeumen+clang-Bau -> clang).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: haengt an KON55-Kombibau (Posten 2)

### [whfxvxf8q.json] 4
GEGENSTAND: Offener Punkt 3: Aufraeumen nach Belegpruefung (git ls-files unter build-s14* == 0, bereits gemessen): build-s14-redfirst/, build-s14-gcc-deb/ und das untrackte Hilfsskript build-s14-kombi.sh entfernen; /tmp/s14_*-Logs koennen weg.
ORT: ce Worktree S-14
SOLL/FIX: Aufraeumen NACH Kombibau (Skript wird vorher noch gebraucht).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: erst nach Posten 2/3

### [whfxvxf8q.json] 5
GEGENSTAND: Offener Punkt 4 (Owner-Frage, kein Defekt): Lock-KOPFTEXT bewusst auf v2-Erstform eingefroren ("erstes Literal"), weil die golden Baseline byte-identisch regenerierbar bleiben MUSS (CI erzwingt jetzt --write + git diff --exit-code); geltende Listen-Semantik steht im Tool-Kopf. Beim naechsten LEGITIMEN Lock-Regen entscheiden, ob der Kopftext nachgezogen wird (waere ein Lock-Byte-Ereignis).
ORT: ce tools/axis_version_lock, Lock-Datei axis_version.lock
SOLL/FIX: Owner-Entscheid beim naechsten legitimen Lock-Regen.
STATUS LT. QUELLE: offen (Owner-Frage)
ABHAENGIGKEIT/FLAECHE: Owner-Frage; golden-158-Byte-Stabilitaet

### [whfxvxf8q.json] 6
GEGENSTAND: Offener Punkt 5: Deklarierte Scanner-Grenzen (dokumentiert im Tool-Kopf, bewusst nicht gebaut): Raw-Strings und Praefix-Char-Literale mit Hex-Buchstaben-Inhalt (u8'a') -- beide im Bestand nicht vorhanden; ein Auftauchen faellt ueber die neue Ruhelage-Versionspruefung bzw. Digest-Drift laut auf, nie als stilles Gruen. Apostrophe in #error/#pragma-Texten bleiben wie bisher (Minimal-Eingriff, golden-neutral).
ORT: ce tools/axis_version_lock (Scanner)
SOLL/FIX: keine (deklarierte Grenze); bei Auftauchen wird es laut.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

### [whfxvxf8q.json] 7
GEGENSTAND: Offener Punkt 6 (Verhaltensaenderung): Exit-3-Semantik ("REGEN ERFORDERLICH") ist eine bewusste Verhaltensaenderung von --check: ein akzeptierter Bump ohne Lock-Regen ist nie mehr gruen -- Konsumenten sind nur CI-Job + ctest (verifiziert per Repo-Grep), beide umgestellt; falls externe Nutzer den alten Exit-0-Bump-Zweig erwarteten, muessen sie auf 0/3 unterscheiden.
ORT: ce tools/axis_version_lock --check; CI-Job
SOLL/FIX: keine weitere Arbeit lt. Quelle; Hinweis fuer etwaige externe Konsumenten.
STATUS LT. QUELLE: nur-hinweis (Restzweifel externe Nutzer)
ABHAENGIGKEIT/FLAECHE: CI-Vertragsflaeche

### [whfxvxf8q.json] 8
GEGENSTAND: Koeder-Protokoll (17 Eintraege, alle Rot-zuerst + Gegenprobe, Dauer-Koeder A-S im ctest): G1a Ruhelage/Register-Verfaelschung (Koeder I); G1b Sentinel trotz Digest-Gleichheit + --write-Truncate (Koeder J, Byte-Identitaet geprueft); G2 Bump-Dauerloch (schwerster Fund; Koeder H, exit 3/3/0/1; Koeder B auf Exit 3 umgestellt; CI faehrt --write + git diff --exit-code); G3 Nur-erstes-Literal k_ary (BESTAND multi=1 von 152; Koeder K); G4a Prosa-Zitat stellt heuristik-Version (Koeder L8); G4b Ueberlauf-Marker modulo 2^64 (Koeder L9); G4c Marker fehlt => 0+Warnung (Koeder L6/L7, L10 mehrdeutig); G5a Nenner-0-Gruen (Mindest-Nenner heuristik>=6, organ>=120, Exit 2; Koeder M); G5b unlesbares Unterverzeichnis (vorher Abort/core dump Exit 134, jetzt sauber Exit 2; Koeder N mit K13-Probe); G5c fremde Endung unsichtbar (Koeder O; Beifang: Wache fing eigene .orig-Sicherung; Bestand 0 Nicht-hpp mit Literal, Nenner 40); G5d Verzeichnis-Symlink still uebersprungen (Exit 2, Ort via lexically_relative; Bestand 0 Symlinks; Koeder P); G6a Digit-Separator verschluckt Literal (Koeder Q; ZUSATZBEFUND: der balancierte Fall 1'000'000.0 wie Bestand adaptive_lsm:105 biss NICHT -- Biss braucht ungerade Quote-Lage, so protokolliert); G6b Literal in #if 0 stellt Version (Exit 1; Bestand 0; Koeder R); G6c read_file_bytes ohne Streamzustand (am Code verifiziert, kein Live-Koeder moeglich; Fix badbit + Laenge==fs::file_size); G7b Koeder-F-Beweis zu schwach (jetzt Byte-Identitaet; v1-Abweisung als Dauer-Koeder S/S2); REGRESSION alle Bestands-Koeder gruen, ANKER "heuristik discovered=6, organ discovered=153 (traeger=123)" gehalten, kAllRegisteredOrganVariantCount=126 nur geloggt; GOLDEN-NACHWEIS: --check echter Baum GRUEN 158 Dateien (heuristik=6, organ=152), --write-Zweitdatei BYTE-IDENTISCH zum committeten Lock, git diff leer.
ORT: ce tools/axis_version_lock @ b12afd32
SOLL/FIX: alles behoben; Restzweifel nur G6a-Grenzfall (balancierte Separatoren beissen nicht, dokumentiert) und G6c (kein Live-Repro moeglich, Code-verifiziert).
STATUS LT. QUELLE: behoben@b12afd32
ABHAENGIGKEIT/FLAECHE: -

### [whfxvxf8q.json] 9
GEGENSTAND: Design-Entscheide D1-D9 protokolliert (fuer Review/Harmonisierung relevant): D1 BEIDE Wege gebaut (--check Exit 3 fail-closed + CI --write+git-diff-Tiefenstaffelung); D2 kanonische Komprimierung der Literal-Liste (k_ary 2x 1.0.0.c => "1.0.0.c"; Aritaetswechsel gegen Listen-Register hat KEINEN Bump-Pfad = bewusster Regen; "ehrlicherer" Weg mehrere-Literale=ROT schied aus, k_ary erfuellt ihn nicht); D3 Marker nur als dedizierte zeilen-verankerte Kommentar-Zeile; D4 Mindest-Nenner als Konstanten im Werkzeug, Verletzung Exit 2, Werte spiegeln ctest-Anker, sodass #16-Umgliederung sie bewusst anfassen MUSS; D5 Literal unter #if => ROT nicht entscheidbar; D6 Endungs-Grenze ERZWUNGEN statt erweitert; D7 Verzeichnis-Symlinks Exit 2 fail-closed; D8 Lock-Kopf byte-stabil (Abschnitt "LOCK-KOPF BLEIBT BYTE-STABIL"); D9 Phantom-Pruefpflicht eingehalten (G6c am Code verifiziert statt Phantom-Bau).
ORT: ce tools/axis_version_lock @ b12afd32 (Tool-Kopf + Kommentare + Commit-Message)
SOLL/FIX: -
STATUS LT. QUELLE: nur-hinweis (dokumentierte Entscheide)
ABHAENGIGKEIT/FLAECHE: #16-Umgliederung (Mindest-Nenner-Konstanten muessen dort bewusst angefasst werden)

### [wtdpeiotj.json] 1
GEGENSTAND: Gesamt-Dossier-Konsolidierung erzeugt: Ziel /home/comdare/wt-super-landung/docs/sessions/20260807-GESAMTDOSSIER-aktuell-jetzt-konsolidiert.md (5 Vorgeschichte-Epochen, 5 Fold-Schritte, 2 Korrektur-Loops, Redaktion + Verify).
ORT: super docs/sessions/20260807-GESAMTDOSSIER-aktuell-jetzt-konsolidiert.md
SOLL/FIX: -
STATUS LT. QUELLE: erzeugt; Verify fand Restfehler (folgende Posten)
ABHAENGIGKEIT/FLAECHE: Dossier ist Quelle fuer weitere Konsolidierungen (KON-Reihe)
ANMERKUNG LESER 02: die Felder korrektur_loop1/korrektur_loop2 und beide verify-Reports sind IM JSON SELBST ABGESCHNITTEN (enden mitten im Wort: "Widerspruchskla", "an den offe", "und meld", "struct PermResult") -- die Vollfassungen liegen nur in den damaligen Agent-Returns; Restzweifel, ob weitere Diskrepanzen hinter dem Schnitt stehen.

### [wtdpeiotj.json] 2
GEGENSTAND: Korrektur-Loop 1 (Dossier 3370 Z. vs. 43 Owner-Aussagen): KEIN harter Architektur-Widerspruch; 3 substanzielle + 2 geringfuegige Diskrepanzen. Nr. 1: Paragraph 17.12 PR-3 gibt Owner-Aussage 3 verfaelscht wieder -- Dossier: "alle Wellenplaene komplett in den Kontext laden"; Owner woertlich: "Bitte lade ALLE Aufgaben mit Kontext in deinen Kontext und kippen die letzten 3 Wellenplaene in deinen Kontext" (das ALLE gehoert zu den Aufgaben, Wellenplaene waren "die letzten 3"); zudem unterschlaegt PR-3 den vom Owner verlangten "Explore Agenten mit Opus max Effort very thourough". Nr. 2: Paragraph 17.9 fuehrt "T-2 Frist 15.09. bestaetigen" als OFFENEN Owner-Entscheid, obwohl Owner-Aussage 12 den Endtermin woertlich festgelegt hat ("der End-Termin ist der 15.09.2026 und wir muessen JEDEN Freitag neue Ergebnisse liefern"). Nr. 3 im JSON abgeschnitten.
ORT: Dossier Paragraph 17.12 PR-3 und Paragraph 17.9
SOLL/FIX: "Korrektur: PR-3 auf den Wortlaut praezisieren"; Paragraph 17.9-Eintrag als entschieden fuehren.
STATUS LT. QUELLE: teilweise (Loop lief, Einarbeitung im Dossier-Folgestand; Nr. 3 unbekannt)
ABHAENGIGKEIT/FLAECHE: Owner-Wortlaut-Autoritaet; Ledger

### [wtdpeiotj.json] 3
GEGENSTAND: Korrektur-Loop 2 (Dossier 3424 Z. vs. 43 Owner-Aussagen, alle 43 kontiert Paragraph 17.12 lueckenlos): DREI Diskrepanzen + zwei Trivial-Notizen. Nr. 1 (MITTEL): Paragraph 17.10 Ordnungs-Prinzip (4) misappliziert Owner-Aussage 39 als T4-Deckung -- Dossier rueckt Auswertungs-/Hybrid-Kette V-09a-1..7, HY-B1a..B4 nach T4 (nach 15.09.) mit Zitat "nach der Abgabe morgen dran"; "die Abgabe morgen" ist aber die Abgabe 07./08.08. (deren Bedeutung das Dossier selbst als OFFENEN Entscheid T-1 fuehrt, Paragraph 17.9 "bleibt LEGITIM offen"); Paragraph 16.2 nutzt dieselbe Aussage 39 GEGENTEILIG, um F8 in Klasse T3 (VOR 15.09.) zu ruecken. Wenn "Abgabe morgen" die Zwischenabgabe ist, hat der Owner die Auswertung als unmittelbar NACH dem 07./08.08. anstehend sequenziert -- im 40-Tage-Fenster. Korrektur: In Paragraph 17.10 das Owner-Zitat als T4-Begruendung streichen (Rest abgeschnitten). Nr. 2/3 im JSON abgeschnitten.
ORT: Dossier Paragraph 17.10 / Paragraph 16.1 / Paragraph 16.2
SOLL/FIX: Owner-Zitat 39 nicht als T4-Deckung verwenden; Einordnung der Auswertungs-/Hybrid-Kette (T3 vs. T4) klaeren -- beruehrt Priorisierung VOR/NACH 15.09.
STATUS LT. QUELLE: teilweise/offen (Widerspruch im Dossier benannt)
ABHAENGIGKEIT/FLAECHE: Owner-Entscheid T-1 (Bedeutung "Abgabe morgen"); Planungsreihenfolge Hybrid-Kette

### [wtdpeiotj.json] 4
GEGENSTAND: Verify "vollstaendigkeit" -- Dossier FEHLT WESENTLICHES gegen den Ledger-Nachtrag "morgen-1" (docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:7250-7285; morgen-1 wurde 02:32 committet [835686ba], neues Dossier 04:39 -- morgen-1 lag dem Fold VOR, ist aber in Fold-Chronik 0.1 NICHT als Quelle gelistet): (1) SELBST-AUDIT-Verdikte komplett verloren (Ledger :7272-7276): 30%-Anker-Fehlerquote (6/20 Stichproben), zwei abgeschnittene KERNe (KERN 1 "Das schliesst den Kreis" -- auch im neuen Dossier 0 Treffer; KERN 12 ultracode/Fable5-Auftrag), Gesamt-Verdikt "NICHT VOLLSTAENDIG / ersetzt keine frische Owner-Ruecklesung"; Owner-Nachricht "kippe ALLE workflow ergebnisse" fehlt auch im 43er-Register Paragraph 17.12 (0 Treffer). (2) F-01 DRITTER WEG fehlt und wird widersprochen (:7256): morgen-1 = "Rollentrennung, nichts streichen" (Talos=Bau/CI, root-Linux=Erhebung; nur der Allquantor "erhoben" falsch) mit DREI PDF-wirksamen Stellen + VIER Drift-Stellen + Nebenbefund minio.comdare.de=dev-MinIO; das Dossier sagt stattdessen "A-1 Talos zuruecknehmen" und "existiert nirgends im Ist" (:2807, :3329). (3) B-3-Objektbefunde fehlen (:7264): NON-KONGRUENZ-Beleg, HeteroCoreDispatch-Enum (nur None instanziiert), Namens-Diskrepanz Code None vs CSV Unpinned, pe_policy-Traeger, [p053]/Barnard-Referenz -- D-7 (:3326) traegt nur die zwei Faktorisierungen. (4) B-5a/O-4 Anhang-A-Reichweite (:7270): morgen-1 = OFFEN (44 Fragmente, 16 belegt, 28 leer-gegatet; Weg-1-Empfehlung OHNE Owner-Freigabe, per Checkheft C-3 neu zu stellen; O-4-Nummern-Kollision); Dossier bucht R-5 als erledigt (Rest abgeschnitten).
ORT: super docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:7250-7285 vs. Dossier (u.a. :2807, :3326, :3329)
SOLL/FIX: Dossier um die 4 Verlust-Klassen ergaenzen bzw. korrigieren; Konflikt A-1-Talos vs. F-01-Rollentrennung aufloesen; Vollstaendigkeits-Warnung des Dossiers ist "nachweislich zu eng".
STATUS LT. QUELLE: offen (Verify-Fund am fertigen Dossier)
ABHAENGIGKEIT/FLAECHE: Ledger morgen-1; Thesis-PDF-wirksame Stellen (F-01); spaetere KON-Stufen konsumieren das Dossier

### [wtdpeiotj.json] 5
GEGENSTAND: Verify "anker" (am Objekt, ce=54106bc9, super=2871fabf/dd107862): Kern-Check BESTANDEN (allow_failure genau experiment_plan_director.hpp:1373); der befuerchtete falsche Anker :1333 kommt im Dossier nicht vor (alle 6 allow_failure-Stellen Prosa ohne Datei:Zeile). ZWEI falsche Anker gefunden: (a) Dossier Z.983-985 (Paragraph 12.3 N-16, Mess-Kette): behauptet measurement/system_axis.hpp:2837 SystemAxis<Derived> + :2667 MeasurementRegime + :2882 SystemAxisConcept -- Datei hat bei 54106bc9 nur 431 Zeilen; real MeasurementRegime :22, struct SystemAxis : topics::Axis<Derived> :193, SystemAxisConcept :238 (sehen wie Stale-Zeilennummern eines Vor-Split-Monolithen aus). (b) Dossier Z.945-946 (Paragraph 12 N-Viren-Absatz): behauptet anatomy/abi_adapter.hpp:230 SearchAlgorithmAbiAdapter; :230 ist Churn-Segment-Kommentar, class SearchAlgorithmAbiAdapter final steht bei :386 (Doku-Block :337-341). Alle uebrigen Datei:Zeile-Anker VERIFIZIERT KORREKT (u.a. system_axis_order.hpp:44-45+:93-94, topics/axis.hpp:17+:39, anatomy_module_abi_v1_decl.hpp:196/:232/:234/:241 sizeof 120, anatomy_fingerprint.hpp:71/:89/:341 GliedCount 8, xml_config_parser.cpp:426, profile_runner.hpp:163, perm_runner.hpp:113; Liste im JSON abgeschnitten).
ORT: Dossier Z.983-985 und Z.945-946; ce measurement/system_axis.hpp, anatomy/abi_adapter.hpp @ 54106bc9
SOLL/FIX: die zwei falschen Anker im Dossier auf die realen Zeilen korrigieren.
STATUS LT. QUELLE: offen (Fund am fertigen Dossier)
ABHAENGIGKEIT/FLAECHE: Dossier-Konsumenten (KON-Reihe, Thesis)

### [won0hr04n.json] 1
GEGENSTAND: Thesis-Bau-Befund: DIE ARBEIT BAUT, beide Sprachen -- DE "Output written on diplomarbeit-de.pdf (202 pages, 919275 bytes)", EN 192 pages/885362 bytes, RC_DE=0/RC_EN=0; Gates: LaTeX-Warning-Zaehler 0/0 (erlaubt <=1), .blg 0/0, alphadin.bst im DE, Undefined refs/No file/!-Fehler je 0/0/0; 180 bibitem aus 182 @-Eintraegen; Kreuzprobe byte-identisch mit CI-Laeufen 15032/15033 auf demselben SHA. ABER: pwsh FEHLT lokal -- der dokumentierte build.ps1/build_all.ps1-Weg ist lokal nicht fahrbar, nur der CI-Weg (.gitlab-ci.yml thesis:pdf, latexmk). Repo unberuehrt, HEAD 8970465.
ORT: Thesis-Repo (Code/external/20260931-overleaf-diplomarbeit) @ 8970465
SOLL/FIX: einzige Warnung "Package scrlayer-scrpage Warning: \headheight to low" norm-neutral heilbar per \section[Kurztitel]{Voller Titel} (B-7, Kosmetik, kein Abgabe-Risiko).
STATUS LT. QUELLE: Bau gruen; pwsh-Luecke nur-hinweis
ABHAENGIGKEIT/FLAECHE: super-Branch bau/texlive-gate-haertung (landereif) beruehrt dieselbe Gate-Flaeche

### [won0hr04n.json] 2
GEGENSTAND: ABBILDUNGS-LOCH Anhang A: anhang/{de,en}/A_measurements.tex fuehrt 28 echte InputIfFileExists-Makro-Aufrufe je Sprache (29 Treffer minus 1 Kommentar :71) -- VON DIESEN 28 EXISTIERT 0 ALS DATEI (beide Sprachen identisch). Gate 8 (Commit 8970465) fuegte exakt 23 je Sprache hinzu (Vorstand 29a1700 hatte 5 Makros + 1 Kommentar; 5+23=28); die 5 aelteren (seg_attribution, observer_detail, latency_range, latency_ecdf, exchange_forest) fehlen EBENSO -- das Loch ist aelter als Gate 8 und groesser als die 23. Nicht .gitignore-verursacht (git check-ignore RC=1). Sichtbarkeitsfolge: 11 Eintraege mit sichtbarem Kursiv-Ersatztext, 17 VOELLIG STUMM ({}{} leerer 3. Arg -- keine Spur im PDF). Gegenprobe am PDF: .lof 34 gesamt, davon Anhang A nur 8; .lot 22, davon Anhang A 8; die 8 stammen ausnahmslos aus den 16 harten \input{}; die 28 weichen Eintraege tragen 0 Abbildungen bei. Anhang A traegt heute 8 von 36 moeglichen Abbildungen.
ORT: Thesis anhang/{de,en}/A_measurements.tex (DE-Zeilen der stummen Gruppen: 93-97, 110-111, 177-181, 192-196; EN entsprechend)
SOLL/FIX: Bau-Anweisungen B-1..B-4 (siehe Posten 6); O-4-Entscheid auf Basis des B-2-Messwerts.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: O-4 Owner-Entscheid; super bau/f1-1x1-honest-empty (honest-empty-Semantik); F1-Frist

### [won0hr04n.json] 3
GEGENSTAND: UMGEKEHRTE FALLE (genau 1 Fall): Erzeuger appendix_generator.cpp:423 schreibt axis_inventory.tex, aber KEIN Eintrag in irgendeiner .tex/.cls/.ps1 des Thesis-Repos (grep RC=1, 0 Treffer). Vollbilanz gegen den Erzeuger (16 Schreib-Aufrufstellen): 12 hartes \input (alle vorhanden) + 28 InputIfFileExists (0 vorhanden) + 1 ungebunden = 41; Bestand anhang/{de,en}/tabellen/ = 18 Dateien = 12 Erzeuger + 4 nicht-erzeugte (v5_pipeline_demo_*, cartesian_smoke43_*) + 2 _body; keine unreferenzierte Datei sonst (Reverse-Scan 0/18). ABWEICHUNG ZUR LEDGER-ZAHL: mittag-3 nennt "16 Bestand + 23 neu = 39 Dateien je Sprache"; Zaehlung am Erzeuger ergibt 41 (Delta 2 = observer_detail + axis_inventory); Test-Liste expected_files(12)+expected_extra_files(17)=29 (tests/test_08_appendix_generator.cpp:327) deckt sich: 29+12=41.
ORT: super Code/08_appendix_generator/appendix_generator.cpp:423 (+ .hpp:48,56); Thesis anhang/
SOLL/FIX: B-5: axis_inventory.tex nach B-2 einbinden nach dem Muster der 28, beide Sprachen -- ABER: "Der Abschnitt, in den die Tabelle gehoert, ist ein Owner-Entscheid (Ledger mittag-3, Aufraeumpass-Kandidat Nr. 9) -- bis er vorliegt: nicht einbinden, sonst landet eine Achsen-Inventar-Tabelle an willkuerlicher Stelle in der Abgabe." Ledger-Zahl 39 auf 41 korrigieren.
STATUS LT. QUELLE: offen (Owner-Entscheid Verortung)
ABHAENGIGKEIT/FLAECHE: Owner-Entscheid; Ledger-Korrektur

### [won0hr04n.json] 4
GEGENSTAND: DE/EN-PARITAET: kein Risiko, vollstaendig deckungsgleich (Dateilisten identisch je 24/14; Struktur 12/12 OK; \label-Anker byte-genau 12/12; Zitat-Schluessel identisch; .lof/.lot 34/22 beide Sprachen). NEBENBEFUND (Abgabe-Hygiene): in kapitel/{de,en}/ liegen 8 weitere NICHT eingebundene Kapitel-Dateien je Sprache (01_introduction ... 08_conclusion, ~162 KB DE) mit dem VERALTETEN Achsen-Stand "neunzehn Achsen" (aktiver Text: durchgaengig "achtzehn Organ-Achsen", 11 Fundstellen); nur 1 von 8 (06_evaluation_methodology) traegt den Kopfvermerk "% NICHT eingebunden (Stand 02.08.2026)", die anderen 7 sind unmarkiert und beginnen direkt mit \chapter{...} samt \label -- beim Draufschauen nicht von aktivem Text zu unterscheiden.
ORT: Thesis kapitel/{de,en}/ (8 Alt-Dateien je Sprache)
SOLL/FIX: Owner-Entscheid: deprecaten (Kopfvermerk wie bei 06_evaluation_methodology) oder belassen; Loeschung scheidet aus (Memory feedback_never_delete_documentation).
STATUS LT. QUELLE: offen (Owner-Entscheid)
ABHAENGIGKEIT/FLAECHE: 18-vs-19-Achsen-Konsistenz (Memory: 18 Organ-Achsen)

### [won0hr04n.json] 5
GEGENSTAND: PMC-ABGABE-RISIKO BESTAETIGT, empirisch am Korpus measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv (16 Datenzeilen): pmc_available=1 in allen 16; pmc_cache_misses_l1 echte Werte (43.579.367..761.540.182), pmc_dtlb_misses echte Werte (70..2.225.379); pmc_cache_misses_l2, _l3, pmc_coherence_invalidations, pmc_energy_micro_joules = 0 IN ALLEN 16. Owner-These damit Messwert: mit Flag liefert die Apparatur L1D + dTLB, sonst nichts. Der Text sagt an VIER Stellen weniger, als wahr ist (nennt nur den Schalter als Ursache; die dritte, reale Klasse "verdrahtet, aber ohne Zaehler-Mapping" fehlt): (1) kapitel/de/06_fazit.tex:157-161 / en:153-157 (schwerste Stelle: baut nur zwei Klassen "geplant, derzeit nicht erfasst" und "default-abgeschaltet" -- Leseart "Schalter umlegen, dann sind sie da" ist falsch fuer 4 von 6 Metriken); (2) kapitel/de/03_messsystem_prtart.tex:1051-1053 / en:1036-1038 + TikZ-Kachel de:1065/en:1050 "HW-PMC standardmaessig aus"; (3) 03_messsystem_prtart.tex de:1003-1004 / en:989-990 "an Hardware-Zaehler-Zugriff gebunden" (Zugriff nachweislich vorhanden, pmc_available=1); (4) kapitel/de/05_evaluation.tex:179-182 / en:177-179 (formal korrekt, aber 4 dauerhaft-0-Spalten gleichrangig neben 2 gefuellten). Ehrlich und unbeanstandet: anhang/de/A_measurements.tex:12-13 und 06_fazit.tex:160.
ORT: Thesis, 4 Stellen je DE+EN (siehe Gegenstand)
SOLL/FIX: B-6 (einzige Textaenderung mit Abgabe-Rang), verbatim: "Einzufuegen ist die fehlende dritte Klasse: dass auch bei eingeschalteter Erfassung derzeit nur L1D und dTLB reale Werte tragen, waehrend L2, L3, Kohaerenz-Invalidierungen und Energie mangels Zaehler-Mapping auf 0 bleiben (I-PMC-2 / I-PMC-3)." Rein additiv-praezisierend, ohne Struktur-/Label-Aenderung (Paritaet bleibt); nach B-3 erneut bauen, Gates duerfen nicht kippen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: LEDGER:4544ff Abschnitt H PMC-Sperrposten (3 Teile: Flag als Invariante; Wache "Quelle nicht gebaut"=Fehler statt Skip; Anhangs-Umfang angesichts I-PMC-2/3); Owner-Antworten 10.08. (PMC=Meta-Meta-Achse)

### [won0hr04n.json] 6
GEGENSTAND: Node-Shape-Risiko NICHT VORHANDEN: 4 Shape-Achsen (btree_order, skip_list_shape, bst_shape, hash_probe_shape) DefinitionOnly (axis_observer_classification.hpp:93-96, :35, :55); Shaped-Emission default-OFF (tests/unit/CMakeLists.txt:2417); alle 4 golden-XML 0 shape-Treffer; im aktiven Thesis-Text 0 Treffer auf die Achsennamen (einziger shape-Treffer ist \itshape TikZ, 04_implementierung.tex:267); Achsen-Zaehlung durchgaengig "achtzehn Organ-Achsen"; "neunzehn" nur in nicht eingebundenen Alt-Dateien. Ergebnis: keine Textstelle zu korrigieren; Erwaehnung der Shape-Achsen waere additiver Owner-Wunsch, kein Fehler.
ORT: Thesis aktiver Text; ce axis_observer_classification.hpp
SOLL/FIX: keiner.
STATUS LT. QUELLE: nur-hinweis (Risiko widerlegt)
ABHAENGIGKEIT/FLAECHE: -

### [won0hr04n.json] 7
GEGENSTAND: BAU-ANWEISUNG B-1..B-7 (ohne Rueckfrage ausfuehrbar; $SUPER=/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine, $THESIS=$SUPER/Code/external/20260931-overleaf-diplomarbeit): B-1 PFLICHT Erzeuger neu bauen -- das vorhandene Binary $SUPER/Code/build-test/08_appendix_generator/appendix-generator ist STALE (Binary 03.08. 15:29, Quellen 06.08. 17:46; strings 0 Treffer auf lc_surface3d|lc_normbar|ld_sweep -- kann die 23 neuen Dateien nicht schreiben); cmake -B build-anhang -DCOMDARE_V32_ENABLE=ON Release, Target appendix_generator_cli; Abnahme strings-Zaehler >0. B-2 Erzeugen direkt in den Thesis-Baum (out_root=$THESIS/anhang, --langs=de,en, 3 Registry-Pfade) und je Sprache LITERAL zaehlen, welche der 28 Pfade existieren; Erwartung >0 aber NICHT 28 (mindestens ld_sweep x3 honest-empty, working_set_n konstant 4096); "Ein honest-empty-Ausfall ist KEIN Fehler und darf nicht als solcher gemeldet werden". B-3 Bau-Gate wiederholen beide Sprachen in /tmp-Kopie; Abnahme: .lof-Zaehler numberline {A. gewachsen gegenueber 8, sonst war B-2 wirkungslos. B-4 die 17 stummen Eintraege hoerbar machen -- erst nach B-2-Messwert entscheidbar, nicht blind aendern (Gruppen-Ersatztext ggf. auf Einzelaussage umstellen). B-5 axis_inventory.tex einbinden NUR nach Owner-Verortungs-Entscheid. B-6 PMC-Textstellen (Posten 5). B-7 headheight-Kosmetik.
ORT: super Code/08_appendix_generator + Thesis-Repo
SOLL/FIX: siehe Gegenstand (verbatim uebernommene Kernauflagen)
STATUS LT. QUELLE: offen (Bau-Aufgaben B-1, B-2, B-3, B-6, B-7 sofort; B-4/B-5 nach Messwert/Entscheid)
ABHAENGIGKEIT/FLAECHE: d03-Korpus; O-4; F1-Lieferung

### [won0hr04n.json] 8
GEGENSTAND: Offene Entscheide + UNBELEGTES: O-4 Anhang-A-Reichweite (Register-Begruendung "Anhang A ist gefuellt und kompiliert" ist seit Gate 8 nur noch zur Haelfte wahr -- Datei wuchs 137->237 Zeilen, Zuwachs vollstaendig unbefuellt; Entscheidungsgrundlage 8 real von 36 moeglichen, 11 sichtbare Platzhalter, 17 stumme Luecken; Quelle der Frage docs/sessions/20260806-REGISTER-todo-konsolidierung-14-tage.md:432). Weitere offene Punkte lt. docs/sessions/20260806-PAUSE-abbruchsicher-nachmittag-nach-vierfach-review.md:37: F6, F8, B14-Bump-Frage, Cacheline-Achse (alle ausserhalb des Thesis-Bandes). UNBELEGT lt. Quelle: (a) ob der d03-Korpus die Default-Referenz linear_scan fuehrt (entscheidet, ob die 6 lc_normbar_* und exchange_forest_vs_reference entstehen -- "genau das entscheidet, ob 14 oder mehr der 23 materialisieren"); (b) ob die 4 ld_exchange_*- und lc_surface_*-Bestandsdateien aus genau diesem Korpus stammen (Inhalt nicht rueckgerechnet). series in allen 16 Zeilen "-".
ORT: super docs/sessions/20260806-REGISTER-todo-konsolidierung-14-tage.md:432; LEDGER:4544ff Abschnitt H
SOLL/FIX: B-2-Messwert erheben, dann O-4 entscheiden; UNBELEGTE Punkte pruefen (linear_scan-Probe = Schritt 1 der Bau-Anweisung).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Owner-Entscheide O-4 + Verortung + Granularitaet + Alt-Kapitel

### [ws4t2r8ry.json] 1
GEGENSTAND: F5-GOLDEN-PLANUNG (Welle wf_6a3096f7, Ledger:4209): wichtigster Einzelfund -- im blockierten Worktree /home/comdare/wt-b14-golden (Branch b14-golden-kf6, HEAD 953ce412) liegt ein fast fertiger, NICHT landefaehiger Entwurf fuer genau dieses Fenster (search_algo-Pin-Fix, N=2^17-Kodierung, organ_subaxes-XSD, target_isa); Codex-Verdikt LEDGER:4207 "SUPER=BLOCKER / CE=NACHBESSERN". Dazu /home/comdare/wt-b14-ce (Branch b14-ce-anteil) -- beide ungelandet.
ORT: /home/comdare/wt-b14-golden @ 953ce412; /home/comdare/wt-b14-ce; Erhebungsstand super HEAD 161247c5 / ce HEAD 3bbcb8ed
SOLL/FIX: Entwurf als Planungsgrundlage Phase 2 nutzen; Blocker/Nachbesserungen abtragen (siehe Folgeposten). QUERVERWEIS LESER 02: wtpunni0p.json meldet SPAETER die B14-NB2-Verifikation von 953ce412 mit 6/6 GEDECKT -- Teile dieses Ist-Berichts (z.B. Validator-Bruch) sind dort bereits als behoben verifiziert; Landung von 953ce412 selbst blieb offen.
STATUS LT. QUELLE: offen (blockiert)
ABHAENGIGKEIT/FLAECHE: B14-NB2/NB3-Wellen; F3-SCHEIBE-6-PLANUNG (wf_41e47ee7) beruehrt DIESELBEN Dateien (LEDGER:4210) -- Koordinationspflicht

### [ws4t2r8ry.json] 2
GEGENSTAND: Wachen-Luecke im landenden Stand: KEINE Wache verankert experiment_golden_kern.xml (das KANONISCHE File seit #48/27.07.) -- fixture_sync_check.cmake bewacht nur die DEPRECATED experiment_golden.xml (die zugleich real produktiv den 02_messung_driver treibt, COMDARE_V32_EXPERIMENT_GOLDEN_XML, wt-b14 tests/CMakeLists.txt:144-146). Genau das ist der A7-Owner-Befund ("muss staendig geupdated werden"). ce thesis_tiere/experiment_golden_kern.xml ist KEINE Kopie, sondern eigenstaendige Naht-Fixture mit absichtlich divergenten Werten (15 TEST-Faelle in test_experiment_kern_seam.cpp -- Ledger:4385 nennt "12", veraltet).
ORT: super Code/tests/fixture_sync_check.cmake + Code/tests/CMakeLists.txt:146-158; super Code/test_data_xml/experiment_golden_kern.xml
SOLL/FIX: Wachen aus dem wt-b14-Entwurf landen (fixture_schema_subset_check.cmake 336 Z. + golden_n_consistency_check.cmake 293 Z.); Wachen ZULETZT ankern (Plan-Schritt S5). Ledger-Zahl 12->15 nachfuehren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Codex-SUPER-HOCH an fixture_schema_subset_check (Regex-Lexer 4 Luecken: CDATA-im-Kommentar-Kollision, keine Entity-Expansion, ASCII-Namensgrenze uebersieht Nicht-ASCII, Truncation-Riegel nur textuell); Plan S1 ersetzt Regex-Lexer durch xmllint

### [ws4t2r8ry.json] 3
GEGENSTAND: Validator-Bruch im landenden Master (Erhebungszeitpunkt): experiment_golden_kern.xml:96 traegt allowed_variants="binary_search linear_search" -- beide KEINE gueltigen Registry-Namen (Registry search_algo fuehrt nur k_ary/interpolation/eytzinger/linear_scan; binary_search_fanout liegt unter der ANDEREN Achse cache_traversal, golden_wired="false"); validate_profile.hpp:1249-1258 lehnt hart ab (Codex-HOCH LEDGER:4409, dort Zeile 156 = Zwischenversion, aktuell :96). GEGENBEFUND: die ce-Fixture ist bereits korrekt (thesis_tiere/experiment_golden_kern.xml:45 = "k_ary interpolation") -- der kanonische super-Master ist der stale Teil.
ORT: super Code/test_data_xml/experiment_golden_kern.xml:96; ce validate_profile.hpp:1234-1261; cache_engine_axis_registry.xml:9-13
SOLL/FIX: Pin-Fix auf k_ary/interpolation (in 953ce412 enthalten, lt. wtpunni0p verifiziert); Owner-Entscheid E-1 siehe Posten 8.
STATUS LT. QUELLE: offen im landenden Stand / behoben im ungelandeten 953ce412
ABHAENGIGKEIT/FLAECHE: Landung b14-golden-kf6

### [ws4t2r8ry.json] 4
GEGENSTAND: TABU-/Anker-Kartierung: CRC64-TABU kNewGolden131072Crc64 = 0x56F1B721C72DC10EULL (source_catalog.hpp:190) haengt an der ce-Registry-Reihenfolge der ersten-2-Enabled-Bausteine, NICHT an der XML -- ein reiner XML-Pin-Fix loest ihn NICHT aus (k_ary/interpolation SIND die ersten 2 Enabled); bewacht von test_e24_c10_g6_identitaets_bilanz.cpp:93,178-180; Neu-Anker-Verfahren dokumentiert (gen_golden_fullpilot --crc64, Wert in source_catalog.hpp:190 UND test :93). golden_320_catalog (Produkt 320, source_catalog.hpp:144) hart-TABU, KEIN Bewegungsbedarf im F5-Fenster (Ledger:4218). Owner-Auflage F5 verbatim (LEDGER:4218): "die golden-320-Byte-Wachen/CRC-Anker werden in diesem Fenster kontrolliert NEU geankert (Alt-golden-darf-brechen-Doktrin: erst additiv, Aufraeumen unter Absprache) -- NICHT nebenbei, eigenes Fenster mit Gates."
ORT: ce libs/cache_engine/profile_facade/source_catalog.hpp:139,144,169-173,190,209-212
SOLL/FIX: bei Registry-Bewegung kontrolliert neu ankern, eigenes Fenster mit Gates.
STATUS LT. QUELLE: nur-hinweis (Verfahren dokumentiert), Auflage offen
ABHAENGIGKEIT/FLAECHE: TABU-Liste; Registry-Reihenfolge

### [ws4t2r8ry.json] 5
GEGENSTAND: organ_subaxes/run_options fehlen dem ce-Interpreter KOMPLETT: parse_experiment_profile (xml_config_parser.cpp:444-520 bzw. :454-558) liest beide nicht; struct ExperimentProfile (xml_config_parser.hpp:441-473) hat keine Felder; unbekannte Wurzel-Kinder werden vom DOM-Reader STILL ignoriert (xml_config_parser.hpp:490-492 "Fehlertolerant..."); run_options existiert nur im thesis-Dialekt (:425); ThesisRunOptions (xml_config_parser.hpp:188-198,275) als Wiederverwendungs-Typ vorhanden. Der wt-b14-XSD-Entwurf (RunOptionsType +43-53, OrganSubAxesType +54ff, minOccurs=0, rueckwaerts-neutral) ist selbst als "HEUTE DEKLARATIV" markiert. Fehlender Kanal: Parse-Zweige + Validierung (validate_profile.hpp) + Codegen-/Build-Matrix-Konsum (line_size in binary_id via profile_to_tree.hpp is_static=true) -- "komplett offen, keine Zeile davon existiert im landenden ce-Stand".
ORT: ce libs/common/serialization/xml_config_parser/*; wt-b14/Code/test_data_xml/experiment_schema.xsd
SOLL/FIX: Plan-Schritt S4 Interpreter ce; deckungsgleich mit [wtpunni0p.json] 6 (Kartierung).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: T2-A-Hoheit; E-3/E-4-Entscheide

### [ws4t2r8ry.json] 6
GEGENSTAND: KF-6 line_sizes -- die MESSWIRKSAME Haelfte fehlt: CacheLineAlignedMemoryLayout::scan_field_sum (ce axes/axis_05_memory_layout_cache_line_aligned.hpp:60) traegt weiterhin kCacheLine=64 hart und fragt die Achse NICHT ab -- ohne sie erzeugt KF-6 line_size-Permutationen, die den CLA-Scan gar nicht differenzieren = MESS-VALIDITAETSLOCH (B14-NB3-Befund LEDGER:4206); B14-NB3-Welle (wf_afd2df95) laeuft bereits ("CE = scan_field_sum-Achsenbindung + Wrapper-Audit + 32/128/256-Tests ueber alle 3 Pfade + catch-Leak-RAII"). Erste Haelfte gebaut: abi_adapter kLbufBytes via line_bytes_of<MemLayout>() (Commit 6a40071f in wt-b14-ce, Ledger 4204/4216). Zusaetzlich offen: bei line=32 bleibt Alloc-Stride 64, Alignment saenke auf 32 -- bewusster Entscheid noetig. Codex-CE-MITTEL (LEDGER:4207) NOCH UNBEHOBEN: Forwarding von line_bytes_of heilt nur EINE Huelle -- jeder weitere Wrapper faellt lautlos auf 64 zurueck; keine Tests fuer 32/128/256 ueber alle 3 Pfade; catch(...) { return 0; } ohne RAII leakt jetzt bis zu 4x groessere Puffer (abi_adapter.hpp:517,578).
ORT: ce axes/axis_05_memory_layout_cache_line_aligned.hpp:60; ce anatomy/abi_adapter.hpp:462/464/528,562/563/606,693/694/913,517,578
SOLL/FIX: E-2-Entscheid (Empfehlung A: Stride aus Achse, Alignment >=64, Aequivalenzklasse {32,64}->64, 2 von 4 Zellen messtechnisch entartet als darstellbares Ergebnis; B strikt = Nach-Abgabe mit Wrapper-Voll-Audit; C 32-streichen widerspricht Owner-A4); Wrapper-Audit + RAII-Fix.
STATUS LT. QUELLE: offen (Welle lief an)
ABHAENGIGKEIT/FLAECHE: wt-b14-ce uncommitted Stand (wtpunni0p Posten 5); Mess-Validitaet

### [ws4t2r8ry.json] 7
GEGENSTAND: Weitere golden-Instanz-Funde: (a) N=2^17 im landenden Stand NIRGENDS maschinenlesbar (Codex-HOCH LEDGER:4409); wt-b14 loest zweifach (18 Achsen allowed_variants Produkt exakt 131072 + <run_options cap="131072" build_version="golden_kern"/>); Gesamtzahl-Kette von stale "524288" auf line_size 4 x system 4 x N 131072 = 2097152 korrigiert. (b) F-3-REGRESSION Mess-Tooling: golden_kern trug DREI separate Ein-Tool-Combos (wallclock/macro/micro einzeln) statt EINER Vollmengen-Combo -- Verstoss gegen Sektion-64/Owner-Direktive 22.07. (Ledger:4433); Fix <combo tools="wallclock macro micro"/>. (c) 17->18-Achsen-Drift in Kommentaren, persistence_target (Slot T17, seit 26.07.) fehlte in Aufzaehlung und axes_default_lookup -- geheilt im Entwurf. (d) datasets-Falschbehauptung "1:1 aus all_axes_golden" (DREI Datasets inkl. english_words gegen ZWEI) -- Herkunftsbehauptung falsch, Datei korrekt, reiner Kommentarfix. (e) DELTA C: atomic128 + target_isa fehlen in der golden-XML-INSTANZ (Schema hat beide, XSD:355/:421); wt-b14 ergaenzt target_isa x86_64, laesst atomic128 bewusst leer -- kein Ist-Beleg welcher Wert Baseline ist, offener Owner-Punkt (LEDGER:4433).
ORT: super Code/test_data_xml/experiment_golden_kern.xml + experiment_schema.xsd
SOLL/FIX: alles im wt-b14-Entwurf enthalten; Landung offen; atomic128-Baseline = Owner-Entscheid E-5 (Empfehlung A: leer lassen, CEB-Default, mit Kommentar).
STATUS LT. QUELLE: teilweise (im ungelandeten Entwurf behoben)
ABHAENGIGKEIT/FLAECHE: Landung 953ce412; Owner-Entscheide

### [ws4t2r8ry.json] 8
GEGENSTAND: PLAN (Phase 2, bindend): docs/plaene/20260806-PLAN-golden-update-fenster.md (580 Zeilen, ASCII-Selbstcheck 0, UNTRACKED -- "Lead committet"). DAG: S0 Entsperrung wt-b14 (merge dev, ce-Zeiger 7969b399->3bbcb8ed) -> S1 xmllint statt Regex-Lexer (Wurzel aller 4 Codex-HOCH) || S2 XSD additiv -> S3 Instanz golden_kern (Pin+2^17+F-3+target_isa) || S4 Interpreter ce -> S5 Wachen ZULETZT ankern (Dreifach-Biss-Beweis) ===== ABGABE-SCHNITT Fr 08.08. ===== S6 line_size-Konsum (bricht binary_id-Grammatik, TABU-6, nur unter E-4) -> S7 Aufraeumpass (F3/Scheibe-6, unter Absprache). Kanten-Kern: Vokabular vor Instanz; Interpreter vor Konsum; Wachen zuletzt; S3||S4 parallel baubar, seriell landbar. OWNER-ENTSCHEIDE E-1..E-5 mit Empfehlungen: E-1 search_algo-Pin EMPFEHLUNG A (k_ary interpolation; B=k_ary linear_scan bewegt BEIDE Traeger + Registry-Reihenfolge -> TABU-5 offen, kNewGolden131072Crc64 bricht, Archive entwertet; C=alle 4 bricht static_assert); E-2 Alignment line=32 EMPFEHLUNG A jetzt/B nach Abgabe; E-3 XSD-Umfang EMPFEHLUNG B (run_options+organ_subaxes; C xs:enumeration abzulehnen = zweite Wertraum-Quelle gegen cacheline_config.hpp); E-4 binary_id-Grammatik-Bruch (NEU, nicht im Ist-Bericht): line_size-Konsum erzeugt statische Ebene (profile_to_tree.hpp:82-86), Archive tragen 18 Segmente ohne cacheline -> kein roher Join alt-gegen-neu; EMPFEHLUNG A (S6 hinter die Abgabe); E-5 atomic128 EMPFEHLUNG A.
ORT: super docs/plaene/20260806-PLAN-golden-update-fenster.md (untracked!)
SOLL/FIX: Plan committen (Lead); Owner-Entscheide einholen; DAG abfahren.
STATUS LT. QUELLE: offen (Plan geliefert, Bau nicht begonnen; Datei untracked)
ABHAENGIGKEIT/FLAECHE: F1/F5-Fenster; TABU-6; Archiv-Joinbarkeit

### [ws4t2r8ry.json] 9
GEGENSTAND: VIER Funde, die den Ist-Bericht KORRIGIEREN: (1) VIER ungelandete Commits in wt-b14, nicht drei -- 71617a1b bringt fixture_schema_subset_check.cmake mit; im gelandeten super existiert NUR fixture_sync_check.cmake; es sind DREI Wachen ungelandet. (2) wt-b14 traegt einen VERALTETEN ce-Submodul-Zeiger 7969b399 gegen den gelandeten 3bbcb8ed, Branch steht auf merge-base 3585541b -- "ohne S0 landet man eine Submodul-Ruecksetzung". (3) parse_experiment_profile liest weder run_options noch organ_subaxes (Abschnitt-4-Frage beantwortet). (4) TABU-Ergebnis besser als geplant: die in Ledger:4193 angekuendigte kontrollierte TABU-Oeffnung ist fuer S0-S5 GAR NICHT noetig -- 5 von 6 Posten bleiben geschlossen (je git diff --exit-code-Gate), geoeffnet wird nur TABU-6 (Wire/binary_id) und nur in S6; von 8 Ankern 3 additiv neu, 4 unberuehrt, genau 1 harter Schnitt hinter dem Abgabe-Schnitt. Abgabe-Einordnung: realistisch vor Fr 08.08. = S0/S2/S3/S5; Grenzfall S1 (xmllint auf allen 8 Docker-Distros; lokal verifiziert libxml 20914 mit Schemas) und S4 (ce-Slot belegt; Interpreter zur Abgabe nicht funktional noetig); nach der Abgabe = S6, S7, E-1B, E-2B.
ORT: /home/comdare/wt-b14-golden (Submodul-Zeiger!); Ledger:4193
SOLL/FIX: S0 zwingend vor Landung (Submodul-Ruecksetzungs-Gefahr).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Submodul-Branch-Pruefung vor Worktree-Loeschung (Memory-Regel); Landereihenfolge

### [wk2fvgrgv.json] 1
GEGENSTAND: Doku-Sortierung Umbrella(288)/CE(286), Stand 08.08.: RICHTIGSTELLUNG der Owner-Annahme -- die Doku ist NICHT ungetrackt (git status --porcelain docs ?? = 0 in BEIDEN Repos); einzige echte Luecke waren 2 Analysen, vom Lead mit Commit a15a74a0 nachgezogen (daher 119 statt der im Auftrag genannten 117 plaene). ECHTER BEFUND stattdessen: getrackt heisst nicht auffindbar -- docs/INDEX.md Umbrella (Stand 2026-05-15) nennt plaene 0 Mal (119 Plandokumente unsichtbar); docs/INDEX.md CE (Stand 2026-05-08) nennt plaene/sessions/audits/ledger-sections je 0 und verschweigt 99 von 160 eigenen Dateien; docs/plaene/INDEX.md existiert in KEINEM Repo. "Es fehlt kein Push -- es fehlt ein Eintrittspunkt." Zahlen: Umbrella 3047 docs-Dateien (2359 sessions, 309 termine, 119 plaene, 54 architektur, 48 audits, 3 ledger-sections), CE 160 (90 sessions, 3 plaene, 43 architecture + 1 architektur, 3 audits, 3 ledger-sections).
ORT: super docs/INDEX.md; ce docs/INDEX.md; (nicht existent) docs/plaene/INDEX.md beidseitig
SOLL/FIX: Plan S1-S2: docs/plaene/INDEX.md (Umbrella, NEU, 119 Zeilen, Abnahme Tabellenzeilen == git ls-files-Zaehler) + beide docs/INDEX.md nachziehen (Abnahme: Verzeichnis-Differenz leer).
STATUS LT. QUELLE: offen (Plan geliefert, kein Bau)
ABHAENGIGKEIT/FLAECHE: -

### [wk2fvgrgv.json] 2
GEGENSTAND: SCHWERERER BEFUND Scope-Bruch am CE-Quellcode: git grep "super docs/" in ce libs/tests/apps/tools/cmake = 12 Stellen mit Etiketten "QUELLE (bindend)", "Plan-Quelle", "Bau-Vorlage", "Quelle des Verbots" (8x super docs/sessions/, 2x docs/audits/, 2x docs/plaene/) -- ein 286-only-Klon kann 10 von 12 bindende Quellen nicht aufloesen. BISSBEWEIS: libs/cache_engine/heuristik/break_even.hpp:27 nennt super docs/audits/20260709-axes-optimization-deep-research-BEFUND.md:83-101; die WERTE sind uebertragen (axis_optimization_catalog.hpp, 29 KB, T0..T18), die Spalte "Optimum haengt ab von" NICHT (im Header: haengt ab 0, Zipf 0, Fuellstand 0, scan_share 0; Gegenprobe Parameter-Art 2, CatalogAxis 94 -- Suche nicht stumm). "Die Frage 'wovon haengt das Optimum ab?' ist aus dem CE-Klon allein heute nicht beantwortbar."
ORT: ce libs/cache_engine/heuristik/break_even.hpp:27 + 11 weitere Stellen; ce axis_optimization_catalog.hpp
SOLL/FIX: Plan S4: ce/docs/architecture/20260808-KONTRAKTE-an-der-super-naht.md (NEU) -- je geteiltem Dokument EIN Absatz aus sich heraus verstaendlich (Vorbild validate_profile.hpp:572-573 "ce darf super nicht inkludieren ... Kontrakt im eigenen Repo neu aussprechen und Autoritaet benennen"); Pflicht-Inhalt die 12 belegten Quellen, insbesondere die break_even-Spalte. Owner-Frage 6: Spalte als Kontrakt-Absatz oder in den Katalog-Header selbst -- "der einzige Punkt, an dem diese Sortierung die Messung beruehrt".
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Owner-Frage 6; Mess-Vorbereitung

### [wk2fvgrgv.json] 3
GEGENSTAND: CE hat KEIN docs-only-Gate: grep changes:|docs-only in .gitlab-ci.yml -- Umbrella 30, CE 0; jeder reine Doku-Commit in der CE zieht die VOLLE Pipeline (lint/build/sanitize/contract/test/chaos). Gegenproben: kein Job liest docs/ (Umbrella-CI 0 Treffer; CE-CI 2, beide Kommentar :146/:156; Anti-stille-Null-Probe thesis/diplomarbeit 11 Treffer) -- "Eine Doku-Sortierung kann keine Pipeline brechen -- sie kostet in der CE aber volle Laufzeit."
ORT: ce .gitlab-ci.yml
SOLL/FIX: Owner-Frage 4: docs-only-changes:-Gate fuer die CE-Pipeline (billig, aber Eingriff in gruene Pipeline); bis dahin EIN Buendel-Commit statt 12.
STATUS LT. QUELLE: offen (Owner-Frage)
ABHAENGIGKEIT/FLAECHE: CE-Pipeline; PIPELINES-STRENG-SEQUENTIELL-Regel

### [wk2fvgrgv.json] 4
GEGENSTAND: Bewertung der drei Plan-Vorlagen: minimal-bewegung 0/3 Stimmen -- sein Schritt S5 (5 Kopfzeilen vor den Titel) verschiebt jede Zeile um +5 und entwertet STILL die Zeilenanker; gemessen 808 zeilenverankerte Verweise (docs/plaene/X.md:NN) auf 81 von 119 Dateien; die vorgeschlagene Abnahme numstat==5 0 kann Prepend und Append NICHT unterscheiden und geht gruen durch, waehrend 808 Belege falsch werden. scope-rein 1/3, abgabe-erst 1/3 -- KEINE Vorlage gewinnt unveraendert. Verweislast: 357 Dateien nennen docs/plaene/ (308 sessions, 45 Ledger-Nennungen, 2 bau-nahe: Code/tests/fixture_schema_subset_check.cmake + Code/test_data_xml/experiment_golden_kern.xml).
ORT: super docs/plaene/ (Anker-Gefuege)
SOLL/FIX: Empfohlener Zuschnitt "INDEX ZUERST, KOPIE NUR WO BEWIESEN": 0 Dateien bewegt (git mv kann Repo-Grenzen nicht ueberschreiten; Loeschen Doktrin-verboten), 0 Bestandsdokumente geaendert (kein Kopf-Banner, kein Trailer -- Zeiger-Info nur im Index, alle 808 Anker + 357 Verweise bleiben bitgenau gueltig), NEU 4+N Dateien; nur 9-12 BEWIESENE Volltext-Kopien statt 59 (Klasse-A-Liste zu ~53/59 NICHT gegengelesen; Ketten gemeinsam ziehen: neun 20260702-Dossiers+MASTERPLAN, go4-f-abc+NACHTRAG-F-B, OPT-OPTIMIERUNGSSTUFE+OPT-KORRIGIERT); Schritte S0-S7 mit literalen Abnahmen; Landung erst CE (Merge nie Rebase, Dateiliste explizit, kein git add -A, K8), dann Umbrella mit gehobenem Gitlink.
STATUS LT. QUELLE: offen (Empfehlung, GO ausstehend)
ABHAENGIGKEIT/FLAECHE: Owner-GO (Frage 1); 808-Anker-Flaeche

### [wk2fvgrgv.json] 5
GEGENSTAND: Objekt-Zustands-Funde aus S0: wt-ce-s2 steht auf bau/a1-m64-medien-basis (NICHT development) und wird vom Bau-Agenten beschrieben; wt-super-landung traegt FREMDE GESTAGETE RENAMES -- daher zwei neue Worktrees Branch doku/scope-sortierung noetig, Basis SELBST rechnen (git merge-base HEAD origin/development), keine vorgegebene SHA zurueckspiegeln (K9). Grenzfaelle einzeln entschieden: Doku darf ueber die Grenze zeigen, die Bauflaeche nicht (Nullbefund mit Gegenprobe: probst-diplomarbeit 0, CMAKE_SOURCE_DIR}/../../.. 0, 02_messung_driver 4 alle Kommentar); Sessions wandern NICHT (Praezedenzschaden; Extrakt in CE-Kontrakt-Datei); experiment_golden_kern.xml: Umbrella fuehrt, CE bekommt Absatz "unsere Datei ist Fixture, nicht Master"; Dokumente mit zwei Eigentuemern kapitelweise schneiden, nie ganz verdoppeln.
ORT: /home/comdare/wt-ce-s2; /home/comdare/wt-super-landung (gestagete Renames!)
SOLL/FIX: eigene Arbeitsflaeche S0; Abnahme git status --short leer in beiden neuen Worktrees.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: EIN-SCHREIBER-JE-WORKTREE-Regel; fremde Renames in wt-super-landung = Landeflaeche-Konflikt

### [wk2fvgrgv.json] 6
GEGENSTAND: Wache-Vorschlag doc-anchor-check (heute existiert KEINE Wache fuer Doku-Verweise): sammelt alle docs/**/*.md:NN-Anker; Test A hart (Zieldatei existiert), Test B hart (Zeile NN <= wc -l), Test C weich (Zeilen-Fingerabdruck gegen getrackte docs/.anchors.sha -- der Test, der die 808 stillen Falschzitate sichtbar macht). Verortung [SETZUNG 6]: NUR im Umbrella in der bestehenden docs-only-Lane; in der CE nicht als Job (kein docs-Gate vorhanden), dort lokal aufrufbares Skript bis Owner ein Gate will. Ohne Python (Buildchain-Doktrin).
ORT: super .gitlab-ci.yml docs-only-Lane (neu zu bauen)
SOLL/FIX: Wache bauen gem. Vorschlag.
STATUS LT. QUELLE: offen (Vorschlag)
ABHAENGIGKEIT/FLAECHE: SETZUNG-6-Veto des Owners

### [wk2fvgrgv.json] 7
GEGENSTAND: Aufwands-/Prioritaets-Einordnung: voller Vorlagen-Plan (59 Kopien) 10-14 h -- ABGERATEN; SECHS rote/gelbe Posten sperren die Messung (#21 --check-size, #46 compare/D2, #49 Paper-XMLs, #52 Experiment-Groesse, #45 LaTeX-Anlage, #48 L3-Asymmetrie) und der volle Plan bewegt KEINEN davon; docs/plaene/ ist aktive Arbeitsflaeche (33 von 119 Dateien in den letzten 7 Tagen geaendert -- Einfrier-Mechanik bricht in der naechsten Woche); empfohlene Fassung S0-S7 3-4 h. Owner-Entscheide (echt offen): (1) GO/Timing jetzt schlank, voll nach 15.09.; (2) zweite Welle ~47 Kandidaten nach ~53 Gegenlesungen ja/nein; (3) Namenskollision architecture/ vs architektur/ in der CE + dasselbe Wort entsteht neu im Umbrella durch fremde Renames -- Zusammenlegen ist Owner-Sache; (4) docs-only-Gate CE; (5) tote Overleaf-Einbindung Code/external/20260931-overleaf-diplomarbeit -- von .gitmodules selbst als TOT markiert, Entfernung ausdruecklich Owner-Entscheid (Loeschung=GO), loest bei JEDEM Umbrella-Commit die Submodul-Wache aus (git submodule status zeigt drei - und ein +); (6) break_even-Spalte (Posten 2). SETZUNGEN 1-6 nur Veto noetig. UNSICHER-Deklaration: Zuordnung der 119 zu ~53/59 aus nicht gegengelesener Kartierung; Formregel "CE-Dateiliste -> Bauplan" die schwaechste Regel, nicht autonom anwenden.
ORT: super/ce Repos; .gitmodules (super)
SOLL/FIX: Owner-Fragen 1-6 vorlegen; Submodul-Wache-Dauerausloeser beachten.
STATUS LT. QUELLE: offen (6 Owner-Fragen)
ABHAENGIGKEIT/FLAECHE: 15.09.-Frist; Mess-Sperrposten #21/#45/#46/#48/#49/#52

### [w2kgif6e9.json] 1
GEGENSTAND: Workflow-Ausfaelle im KON19-Explore: 2 Agenten hart gestorben (wp[5] EA-io-metameta:roh und wp[14] ED-pruefdock-retry:roh, je "StructuredOutput retry cap (5) exceeded"); zusaetzlich waren 3 von 15 Agent-Antworten TEST-STUBS ("TEST", Belege "a/b": E-B Fund 3, E-E Funde 1+2) -- die Gegenproben haben sie verworfen und die Luecken selbst am Objekt geschlossen; "Kein Stub ist in die Ergebnisse eingeflossen". Lesehinweis der Quelle: Ledger wuchs waehrend der Gegenproben 22386->22856 Zeilen; stabile Anker sind Abschnitts-IDs, nicht Zeilennummern; Alt-Zitate um 235-322 Zeilen verschoben (Punkt 19: Regel "Abschnitts-ID + Datum zitieren").
ORT: Workflow w2kgif6e9 (KON19-Explore, 12.08.); Erhebung ce-HEAD 670483c0
SOLL/FIX: Platzhalter-Lieferungen = Ausfall-Klasse; kuenftige Referenzen per Abschnitts-ID.
STATUS LT. QUELLE: behoben (durch Gegenproben kompensiert), Prozess-Fund
ABHAENGIGKEIT/FLAECHE: Workflow-Qualitaet; Ledger-Zitier-Doktrin

### [w2kgif6e9.json] 2
GEGENSTAND: E-A/O-4 Festplatten-IO als Organ-Meta-Meta: das Owner-"hatten wir doch gesagt" ist als woertliche Meta-Meta-Entscheidung NICHT auffindbar (dreifach geprueft: docs inkl. Backups, Code, beide Roh-Transkripte 46375cdc=314MB + 5a19728e=224MB); die SUBSTANZ existiert als 26.07.-Entscheidung persistence_target als 18. Organ-HAUPTACHSE (binary_id 17->18); Chronologie zwingend (26.07. Definition E-08 + Erstbeleg E-10; 27.07. OP-11-Verbot RF-7; 02.08. Owner-E2 hebt Verbot auf; 12.08. erster Inhaltsvorschlag) -- Owner benennt echte alte Entscheidung erstmals als Meta-Meta um = Praezisierung. Am Objekt: SIMD als System-Meta-Meta GEBAUT (SimdExternalUtilsFamily, external_utils_family_axis.hpp:71,96-105,150-213; 17 static_asserts) mit 2 ehrlichen Einschraenkungen: axis_kind() meldet noch system_config (Umschaltung bewusst ins Byte-Fenster hinter O-8, Tripwire :115-119) und Hub hat "heute NULL Konsumenten" (:198) -- reale -mavx2/-mavx512f-Flags laufen ueber profile_run_facade.cpp:200,702-720,1262-1280 (Kommentar-Verweis permutation_codegen_tool.cpp ist STALE, 0 Treffer). OrganMetaMetas = MetaMetaMembers<> LEER (3x wortgleich); Bindungsmechanismen inert (meta_meta_admission.hpp "KEINEN Produktions-Konsumenten"; simd_organ_requirement.hpp alle 9 kRequiredNone). io_dispatch T12 (4 Bausteine ON) + persistence_target T17 (DiskWritebackTarget gebaut aber per Q-1/Fall B OFF) sind regulaere Hauptachsen; IO-Strategien ehrlich deklarierte RAM-Simulationen; liburing gehoert zum CEB-Spool-Writer (Grep-Falle).
ORT: ce topics/organ_meta_meta_axis.hpp; external_utils_family_axis.hpp; cache_engine_axis_registry.xml:83,125
SOLL/FIX: OFFEN Owner-Entscheid (Punkt 1): Festplatten-IO als NEUER additiver OrganMetaMetaAxis-Typ bauen (neben T12/T17) ODER nur konzeptionelle Verwandtschaft -- "bis dahin kein Bau an OrganMetaMetas". Punkt 2: Verhaeltnis SimdExternalUtilsFamily vs. axis_09b_simd_extension-Familie (verschmelzen/getrennt) -- Folge-Explore. Punkt 3: stale Verweise + T-Nummern-Drift (T14->T12) datiert vermerken.
STATUS LT. QUELLE: offen (Owner-Zwei-Wege-Frage)
ABHAENGIGKEIT/FLAECHE: O-8-Byte-Fenster; Additiv-Doktrin

### [w2kgif6e9.json] 3
GEGENSTAND: E-B/K2 Hybrid-Loader-Schicht: BEANTWORTET, zweimal (09.08. Ledger ~:8396 "Loader wandert in stufen-neutrale Bibliothek"; 12.08. KON21-01 "K2 BEANTWORTET" -- geltende reichere Fassung: CEB orchestriert direkt ODER delegiert an Hybrid, Loader-Faehigkeit als wiederverwendetes CEB-Modul (Schicht 2), CEB behaelt direkten Weg (Schicht 1) + Steuerhoheit ueber Sync-Kanal; Betriebsarten, kein Fork; Verfeinerung, kein Widerspruch). Die Owner-Rueckfrage entstand, weil die 11.08.-Owner-Vorlage die 09.08.-Antwort nicht mitfuehrte (O-5-Abschnitt ohne Verweis, docs/plaene/20260811-OWNER-VORLAGE-...:160-171) -- K2 lief in KON18/KON19 faelschlich als offen weiter. Am Objekt existiert: Enums HeuristikAdapter=3/FunctionInterfaceReroute=5; Weg C statisch erzwungen (KEIN sechstes Pruefdock, Registry bleibt 5); Concept-Gate S1-S3 + Negativ-Compile-Test; 5 Strategy-Spezialisierungen; 2D-Synthese-Matrix; ABI-Slot visit_hybrid_reroute seit Major 9 (Emitter bewusst 0 bis HY-A2); K1 im Lager umgesetzt; Break-Even-Scaffolds unangebunden. FEHLT: hybrid_dock_factory/hybrid_dock_array/hybrid_binary_proxy (0 Treffer); jede Produktiv-Verdrahtung; <hybrid_tier>-XML-Typ (nur Kommentar-Reserve XSD:102-124); SYNC-KANAL CEB<->Hybrid (neues Bauteil, bisher nirgends erwaehnt); HY-A2-Emitter.
ORT: ce anatomy_base.hpp:89,169,196-199; pruef_dock_version.hpp:199-206; hybrid/README.md (Stand 09.08., fuehrt K2 noch offen = Doku-Rueckstand)
SOLL/FIX: Doku-Nachzug README + Konformitaets-Register datiert auf KON21-01; Sync-Kanal als NEUES Bauteil in die Postenliste; offene Punkte: KON21-01 ohne Transkript-Zeilenreferenz (grep in 5a19728e nachholen); Zahlen-Widerspruch Dock-Obergrenze 32 (09.08. XML-Default) vs. 8 (Q6, 02.08.) im Code als "OFFEN FUER DEN OWNER" markiert (synthese_matrix.hpp:33-51) -- Owner-Frage vor HY-A2; 24-vs-48 Rekombinationen auf Planungs-Simulation vertagt (KON19-08); <hybrid>-XML-Schalter Bauauftrag ohne Datum; L1/L2-Bedeutung im lager_baum_writer-Kommentar Mini-Klaerung.
STATUS LT. QUELLE: beantwortet (K2), Bau + Doku offen
ABHAENGIGKEIT/FLAECHE: HY-A2; Owner-Fragen Dock-Obergrenze

### [w2kgif6e9.json] 4
GEGENSTAND: E-C/O-13 --dump-plan/PlanTextBuilder-Herkunft: beide Begriffe NICHT vom Owner -- --dump-plan von Opus-Subagent 16.07. 22:52 UTC gepraegt (Dossier "Read-only (Opus)"; Auftrags-Prompt enthielt das Wort nicht); PlanTextBuilder+"Fork B" aus 7-Agenten-Syntheselauf 19.07. 03:03 UTC; ALLE 353 Fundstellen klassifiziert: 0 mit Owner-Herkunft; Fork B agentisch entschieden und gebaut (ce c9240477, 19.07.), NIE owner-bestaetigt. Zwei getrennte Schicksale: (a) Flag-Wort TOT seit W1 (05.08., super 1a3f1f42; Alt-Treiber antwortet Verweiszeile+rc=1, main.cpp:472-486; in neuer Planer-Binary bewusst nicht mitgewandert, main.cpp:681) -> Ledger-Posten: O-13 fuers FLAG als UEBERHOLT markieren mit Herkunftsvermerk. (b) Substanz LEBT und ist produktionskritisch: PlanTextBuilder final : IPlanBuilder (experiment_plan_director.hpp:389), 1 von 6 Buildern; CLI "comdare-experiment-planner plan dump"; Byte-Determinismus-Tests; hart gegateter CI-Job visibility:tier-binaries OHNE allow_failure (.gitlab-ci.yml:1394-1436); Downstream-Parser parse_plan_dump() (tier_binary_report.hpp:132); gelandet 05.08. (3bf03b01 + Hotfix 60c7c56a, Pipeline 14674 success); 55 Commits bis 11.08. (346b6da9). "Streichung waere Abriss aktiver, hart gegateter Funktionalitaet"; Ersatz (Planungs-Simulation) nirgends belegt -- selbst NEUER Posten mit Bestandspflicht. Owner-Satz "sollte eine Director Methode sein" = die am 19.07. NICHT gewaehlte Fork-B-Alternative -> BAUFORM-ENTSCHEID an den Owner (loeschen/refaktorieren/belassen), KEIN Loesch-Entscheid; bis dahin kein Rueckbau. Kleiner Doku-Posten: Code/07_tier_binary_report/main.cpp:8,47 Usage-Hilfe nennt noch "comdare-messung-driver plan dump" (seit W1 nicht lauffaehig; richtig: comdare-experiment-planner).
ORT: ce experiment_plan_director.hpp:389,:2049; super Code/07_tier_binary_report/main.cpp:8,47
SOLL/FIX: siehe Gegenstand (Ledger-Markierung, Owner-Bauform-Frage, Usage-Fix).
STATUS LT. QUELLE: teilweise (Flag vollzogen; Substanz-Entscheid offen)
ABHAENGIGKEIT/FLAECHE: Owner-Frage; Planungs-Simulations-Posten (PlanSizeBuilder als Bestandsspur, Punkt 10)

### [w2kgif6e9.json] 5
GEGENSTAND: E-D/T-15b Pruefdock-Retry: die Owner-5 ist heute FALSCH VERDRAHTET -- sie liegt auf der Drift-Instabilitaets-Achse (DriftGateConfig::max_reruns=5, drift_gated_cell.hpp:120, eingezogen mit ce 4cd1ab91 am 09.08.; gespiegelt xml_config_parser.hpp:288/.cpp:361, planner_mengen_types.hpp:127,319-324, gepinnt test_t15_drift_gate_messschleife.cpp:249-257 "Owner-Zahl 5"; 3 weitere Ripple-Stellen: iterator :372-383, checkpoint_speicher.hpp:119-123 Arena-Formel 3x(5+1)=18, profile_run_facade.cpp:1564,1577). Ein failed-Retry des GESAMTEN Pruefdock-Durchlaufs einer Tier-Binary existiert NIRGENDS (jeder Aufrufpfad endet nach genau einem Versuch; 0 Retry-Treffer in pruef_dock/, apps/, ci/). Der damalige Bau-Agent dokumentierte die richtige Lesart selbst und baute sie bewusst nicht (drift_gated_cell.hpp:112-116); Zwei-Lesarten-Ambiguitaet seit KON18-02 aktenkundig -- "der damalige Agent waehlte die falsche der zwei vorgedachten Lesarten".
ORT: ce drift_gated_cell.hpp:108-120; cache_engine_builder_iterator.hpp:3127,:372-383,:2948-2958
SOLL/FIX: BAU-POSTEN 3.1 "Pruefdock-Retry (Robustheitskriterium)": Wiederholungs-Klammer UM measure_one_binary(builds[j], ctx.get()) (heute Einzelaufruf iterator :3127 in collect_ordered<CellOutcome> :3124-3131); Ausloeser = gesamter Durchlauf EINER Tier-Binary failed, Kandidat-Praedikat oc.load_failed==1 ueber die 3 fruehen SourceUnavailable-Pfade; bis zu 5 Wiederholungen als je eigener Versuch; nach Erschoepfung bestehende failed-Doktrin (Zelle "failed", nie null, Lauf misst weiter). AUSDRUECKLICH UNBERUEHRT: Drift-Gate max_reruns, KF-10 n_repeats=3, T-15a. RIPPLE-LISTE (8 Posten, sonst bleibt eine zweite falsche Owner-Zahl-5-Behauptung liegen): (1) drift_gated_cell.hpp:108-120 Kommentar + max_reruns-Default zurueck auf Mechanismus-Wert 3 -- Owner-/Planungs-Entscheid, nicht stillschweigend; (2) iterator :372-383 sechste Kommentarstelle; (3) xml_config_parser drift_gate_max_reruns von Owner-5 entkoppeln, ggf. eigenes XML-Attribut; (4) planner_mengen_types NEUER separater Kosten-Faktor fuer Binary-Retry + Quellenangabe :320; (5) checkpoint_speicher Arena-Formel muss binary-weiten x5 ZUSAETZLICH abdecken (sonst Unterdimensionierung); (6) profile_run_facade.cpp:1564,1577; (7) test_t15 Pin umschreiben + NEUER Test; (8) Register S5-06 + Ledger-T-15-Abschnitte datiert korrigieren. OFFENE OWNER-FRAGEN vor Bau: (12) zaehlt auch SampleStatus::Failed einzelner Einstellungen als failed? (13) "bis zu 5" = 5 gesamt oder 1+5? (14) welche "3" ist die success-Messung (KF-10 wahrscheinlich, unbewiesen)? (15) T-15a-Granularitaet (Zelle|Batch|Kampagnentag|Kampagne) weiter offen (KON18-02), strikt getrennt halten.
STATUS LT. QUELLE: offen (Bau-Posten definiert, 4 Owner-Fragen davor)
ABHAENGIGKEIT/FLAECHE: Mess-Kette; Arena-Dimensionierung; T2-A-Flaeche (iterator)

### [w2kgif6e9.json] 6
GEGENSTAND: E-E/OD-7 16-Kerne: eine fruehere 16-Kerne-ENTSCHEIDUNG existiert NICHT -- Timeline (4 echte Owner-Aeusserungen + KON19-09): 22.07. "prod1 32 Threads und 24 Kerne" (Ursprung der falschen 24, Werte zwischen Maschinen vertauscht); 26.07. "OD-7: 24 WORKER fuer prod1..." (woertlich Ledger Paragraph 69.6); 06.08. "direktive durchsetzen"; 10.08. "OD-7 lassen wir so" (in Kenntnis des 16-Kerne-Befunds); 12.08. "schon entschieden - explore. Aber es muessten 16 Kerne sein". ENTSCHEIDENDER BEFUND: beide Male, als gefragt wurde, beschrieb der ASSISTANT OD-7 als "setzt 24 KERNE voraus" -- der Owner-Originalwortlaut sagt durchgehend "Worker", nie "Kerne"; die zwei scheinbar widerspruechlichen Antworten sind moeglicherweise Antworten auf zwei nie sauber getrennte Fragen (operativer HEAVY-Worker-Deckel vs. Hardware-Kernzahl). Hardware seit 09.08. gemessen: prod1 = 16 Kerne/32 Threads (Ryzen 9 9950X3D). Am Objekt haengt an der 24: Paragraph 69.6 (~:14206), runner-mode.sh:43 HEAVY_J=24 (Commit 0d7c577, KEINE 16-Kappung), W-2-Block inkl. Warnung "Wer die 24 pauschal streicht, streicht OD-7 mit", zwei unkorrigierte Zitate (~:13907, ~:13972), N-3/N-4-Kapazitaetsrechnung auf 24 Worker; ETA-Kernformel rechnet mit Threads (32, korrekt). prod2 braucht keine Korrektur (16K/24T, i9-12900K; i9-14900KS-Nennungen vermutlich pre-RMA-stale).
ORT: super runner-mode.sh:43; Ledger Paragraph 69.6/W-2/N-3/N-4
SOLL/FIX: KORREKTURLISTE 3.3 (7 Posten): (1) KEINE stillschweigende Aenderung von Paragraph 69.6/runner-mode.sh -- ZUERST EINE gezielte Owner-Rueckfrage OHNE Kerne/Worker-Konflation: (a) sinkt der operative HEAVY-Deckel auf 16 oder (b) bleibt 24 als bewusste Ueberbuchung und "16 Kerne" meint nur die Hardware-Tatsache; (2) bis zur Antwort nur die reinen Hardware-Fakten-Zitate ADDITIV korrigieren (~:13907, ~:13972, datierter Vermerk); (3) W-2-Tabelle datierter Nachtrag; (4) N-3/N-4-Vermerk + bei Wechsel auf 16 FRISCHE Kalibrier-Slice mit 16 Workern statt linearer Umrechnung; (5) Handout-5d-Live-Verifikation (CMAKE_BUILD_PARALLEL_LEVEL nach runner-mode.sh heavy) nachholen -- nie zurueckgemeldet; (6) KON-20 (GitLab-Runner-NORMAL-Concurrency Ist 4/4 vs. SOLL 2/2) getrennt halten; (7) Memory-Datei reference_prod1_16_kerne... per datiertem Nachtrag praezisieren, nicht streichen.
STATUS LT. QUELLE: offen (Owner-Rueckfrage noetig; Konflikt Memory OD-7-setzt-24 dokumentiert)
ABHAENGIGKEIT/FLAECHE: Betriebs-/Kapazitaetsplanung N-3/N-4; KON-20

---

### [w2zv55j8v.json] 1
GEGENSTAND: Workflow "#29 Zielstruktur-Schnitt der 4 Traeger-Unterprojekte + G-1-Grammatik-Design" -- beide Designs read-only als Return erzeugt (der Lead persistiert), 4 Agenten alle done, beide Reviews Urteil TRAEGT_MIT_FIXES; logs: "Beide Designs fertig".
ORT: w2zv55j8v.json; ce-Baum @ 5f3f26a5 (nur lesend vermessen), Ledger-Kopf KON59
SOLL/FIX: Lead persistiert Design #29 als Plan-Dokument; G-1-Zielpfad nach Freigabe: docs/plaene/20260813-DESIGN-g1-grammatik-dreiphasige-messachse.md (Schwester zu 20260807-DESIGN-flag-grammatik-v2-punkt-notation-komposit.md). Beide Designs tragen Review-Fixes, die VOR Owner-Vorlage einzuarbeiten sind.
STATUS LT. QUELLE: teilweise (Designs fertig, Fixes und Persistierung offen)
ABHAENGIGKEIT/FLAECHE: S-8-Bau (Strecke P.31 Mo 17.-Mi 19.08.); S-6d/#67; KON43-01/-02

### [w2zv55j8v.json] 2
GEGENSTAND: Nummern-Warnung V12 -- im Wellenplan existieren ZWEI "#29": W7-Zaehl-Posten "wide_aggregat-Dedup" (Paragraph 13.3, Z. 1452/1756) und der Paragraph-18.4-Posten "Zielstruktur-Schnitt" (Z. 2152).
ORT: super Wellenplan Paragraph 13.3 Z. 1452/1756 und Paragraph 18.4 Z. 2152
SOLL/FIX: "In jeder Task-Liste den GEGENSTAND mitfuehren, nie die Nummer allein."
STATUS LT. QUELLE: nur-hinweis (Review-verifiziert: Doppel-#29 real)
ABHAENGIGKEIT/FLAECHE: alle Task-Listen des Komplex-Fix

### [w2zv55j8v.json] 3
GEGENSTAND: #29-Schnitt-Plan VOR S-8 (bewusst minimal): (1) Zielbild+Besitzkarte als Plan-Dokument landen; (2) Skeleton-Commit libs/traeger/{planer,ceb,tier,hybrid}/CMakeLists.txt + je README, add_subdirectory-Kette in Stufenreihenfolge, leere INTERFACE-Ziele comdare_planer/_ceb/_tier_emission/_hybrid, target_link_libraries bildet Stufenkette N+1->N ab; (3) Bruecken-Regel fuer S-8/S-9: Neubauten unter traeger/planer bzw. traeger/ceb, Bestands-Wiederverwendung aus builder/ nur mit greppbarem ASCII-Marker "// TRAEGER-BRUECKE(#88): <Zielort>"; (4) Grenz-Wache als Google-Test (kein Shell, KON6-05), zieht MIT dem ersten S-8-Commit ein, NE-16 (KON59-02): neuer ctest/CI-Job zuerst in den Wachen-Inventar-Nenner; (5) Neutralitaets-Beleg preimage-/golden-neutral. NICHT vor S-8: kein Datei-Umzug, keine K1-K4-Aufloesung, keine Test-Umzuege, keine CI-Job-Aenderungen, keine modules/-Bereinigung.
ORT: Design #29 Paragraph 4; Ziel libs/traeger/ (NEU); Monolith libs/cache_engine bleibt bis #88
SOLL/FIX: Skeleton-Commit im WE-15./16.-Fenster VOR dem ersten S-8-Commit; Review-Fix 3 korrigiert: "nur NEUE Dateien" ist UNBAUBAR -- es gibt KEIN libs/CMakeLists.txt, libs/* haengt direkt an der Repo-Wurzel-CMakeLists.txt (Z. 737-753); der Skeleton braucht GENAU EINE Anschluss-Zeile add_subdirectory(libs/traeger) in der Wurzel-CMakeLists = Ein-Schreiber-Konfliktflaeche, vor dem Commit gegen parallele WE-Straenge pruefen; Voraussetzung: ce-Schreibsperre der laufenden Wellen-Landung (KON59-02) aufgehoben.
STATUS LT. QUELLE: offen (Design steht, Skeleton nicht gebaut)
ABHAENGIGKEIT/FLAECHE: Wurzel-CMakeLists.txt (Ein-Schreiber); KON59-02-Schreibsperre; WE-Kapazitaet (R6: WE 15./16. bereits P-belegt mit S-7, S-5, #16, 21b)

### [w2zv55j8v.json] 4
GEGENSTAND: IST-Aufmass Monolith libs/cache_engine @ 5f3f26a5: 1.292 C++-Dateien / 157.192 Zeilen, Zerlegung exakt in Traeger-Substanz 219 D./58.633 Z. (37%), Querschnitt include/ 209 D./31.168 Z., Fach 864 D./67.391 Z.; Review-Gegenprobe: alle Zahlen exakt bestaetigt.
ORT: ce libs/cache_engine @ 5f3f26a5
SOLL/FIX: Besitzkarte ist Referenz gegen die "ceb haengt an tier"-Fehllesart (R8: die 134 builder->Fach-Kanten sind CEB->FACH, kein Stufenbruch).
STATUS LT. QUELLE: nur-hinweis (Quittung, Review-verifiziert)
ABHAENGIGKEIT/FLAECHE: -

### [w2zv55j8v.json] 5
GEGENSTAND: Schmutz-Kanten-Familie K1 -- Richtungs-Inversion PLANER->CEB, 49 Lib- + 2 App-Kanten (experiment_tree 26, bestandslog 8, build_orchestrator 6, codegen 2, driver_build_variant_signature 2, je 1 workload_driver/measure_storage/lager_ablage/ceb_version_stamp/artifact_transport); dichteste Dateien profile_run_facade.cpp (8), profile_run_entry.hpp (7), lazy_adhoc_source_gen.hpp (6), planner/experiment_plan_director.hpp (5). Der Code deklariert die heutige Schichtung woertlich "TEIL2 lebt in der BUILDER-Schicht (Layering: planner -> builder)" -- Zitatort lt. Review: profile_facade/planner/experiment_dock_payload.hpp:24 (nicht "progress_cursor-Umfeld").
ORT: ce profile_facade/** -> builder/**; experiment_dock_payload.hpp:24
SOLL/FIX: Aufloesung ist #88 (plan-seitige Single-Source-Header axis_path_serialization/kCompositionAxisNames, progress_delta, slice_marker -> Planer/Querschnitt; Builder-/Iterator-Seite bleibt CEB); bis dahin S-8-Regel Bruecken-Marker. Risiko R1: jede neue planer->builder-Kante ohne Marker vergroessert die Inversion unsichtbar -- Grenz-Wache im SELBEN Paket wie erster S-8-Commit.
STATUS LT. QUELLE: offen (deklariert, Aufloesung #88)
ABHAENGIGKEIT/FLAECHE: S-8; #88; Grenz-Wache

### [w2zv55j8v.json] 6
GEGENSTAND: Schmutz-Kanten-Familie K2 -- Zyklus builder<->mess (3 Kanten): builder/measure_storage/checkpoint_measure.hpp:48 -> mess/konfiguration.hpp UND mess/konfiguration.hpp:58 -> builder/measure_storage/mess_arena.hpp + mess/mess_naht.hpp:40 -> builder/measure_storage/checkpoint_measure.hpp. Egal wie mess/ zugeordnet wird, EINE Haelfte ist verboten.
ORT: ce, Zeilen 48/58/40 (Review: exakt bestaetigt)
SOLL/FIX: geteilte Typen (MessEbene, MessCheckpointZeile, Arena-Formel-PODs) in den Querschnitt include/cache_engine/measurement/ heben -- Zeitfenster: mit #18/S-13 oder spaetestens #88. Risiko R2: #13 (T-15b checkpoint_speicher-Ripple :119-123) und #18/S-13 (measurement_sink) bauen genau an dieser Naht -- beide Tasks erhalten den K2-Befund als Auflage ("Typ-Hebung mitdenken, Knoten nicht verdicken").
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: #13 (T-15b), #18/S-13, #88 -- Merge-Flaeche measure_storage

### [w2zv55j8v.json] 7
GEGENSTAND: Review-HART-Fund F1 -- K3 (Querschnitt->CEB) ist UNTERZAEHLT: 6 Kanten aus 2 Dateien, nicht "exakt 3": zusaetzlich zu include/cache_engine/api/i_cache_engine_tools.hpp:23-25 zieht include/cache_engine/abi/cache_engine_execution_engine_adapter.hpp:14-16 via relativer Pfade builder/commands/{execute_engine_command,execution_result,workload}.hpp -- ein abi/-Header der S-1..S-7-Zone. Summe verbotene Richtung: 59 Lib- + 2 App-Kanten = 61, nicht 58. Design-Messmethode uebersah relative Includes in include/.
ORT: include/cache_engine/api/i_cache_engine_tools.hpp:23-25; include/cache_engine/abi/cache_engine_execution_engine_adapter.hpp:14-16
SOLL/FIX: Review-Fix 1 verbatim-Kern: "K3 -- QUERSCHNITT->CEB (6 Kanten, 2 Dateien) ... Aufloesung (#88): beide Koepfe entkoppeln." Paragraph-3b(5) ersetzen (Querschnitt ist Richtung FACH NICHT rein, s. Fund F3).
STATUS LT. QUELLE: offen (Design-Korrektur vor Owner-Vorlage)
ABHAENGIGKEIT/FLAECHE: #88

### [w2zv55j8v.json] 8
GEGENSTAND: Review-HART-Fund F2 -- Matrix-Zeile TIER falsch: tier->Fach = 4 und tier->Querschnitt = 1, nicht 0/0 (harness/perm_runner.hpp:26-29 -> anatomy/{observable_tier,measurable_workload,rollbackable_tier,scannable_tier}.hpp, :30 -> cache_engine/measurement/axis_error.hpp). Stufen-neutral erlaubt, aber Matrix-Nullen am Objekt widerlegt.
ORT: ce harness/perm_runner.hpp:26-30
SOLL/FIX: Review-Fix: "harness/ ist NICHT fach-frei ... wandert beim Tier-Umzug einfach mit"; Messmethoden-Klammer ergaenzen: "Zaehlweise: nur echte #include-Direktiven (Zeilenanfang), direkte UND relative Pfade aufgeloest; Kommentar-Erwaehnungen zaehlen nicht (fruehere Werte 58/51/4 enthielten solche)."
STATUS LT. QUELLE: offen (Design-Korrektur)
ABHAENGIGKEIT/FLAECHE: -

### [w2zv55j8v.json] 9
GEGENSTAND: Review-HART-Fund F3 -- Querschnitt->Fach = 20 Kanten, NICHT 0 (anatomy 13, topics 4, axes 3, alle via relative Includes, Schwerpunkt abi/: anatomy_module_abi_v1_decl.hpp:17-20, anatomy_module_abi_v1.hpp:28-30, subaxis_valueset_segment.hpp:25-27, measurement/{ceb_system_axis,system_axis,measurement_meta_meta_axis}.hpp -> topics/axis.hpp). Der Querschnitt ist keine bodenstaendige Schicht, er lehnt am Fach -- das Design verschweigt diese Abhaengigkeit.
ORT: ce include/cache_engine/abi+measurement (Zeilen s.o.)
SOLL/FIX: Review-Fix: Folgerung "keine Compile-Kante CEB->TIER noetig" bleibt, aber ausschreiben: "wer Querschnitt konsumiert, bekommt anatomy transitiv mit; bei #88 entscheiden: Vertraege heben oder Kante deklarieren."
STATUS LT. QUELLE: offen (Design-Korrektur; #88-Entscheid)
ABHAENGIGKEIT/FLAECHE: #88; Stempel-Zone S-1..S-7

### [w2zv55j8v.json] 10
GEGENSTAND: Review-MITTEL-Fund F4 -- CEB->Fach = 147, nicht 134 (anatomy real 85 = 74 direkt + 11 relativ; + topics 48 + axes 12 + compositions 1 + src 1); planer-Zeile: ->Querschnitt 56 echte Direktiven (die "58" enthalten 2 Kommentar-Treffer), ->Fach 25. Methodenfehler doppelt: lockeres grep zaehlt Kommentar-Erwaehnungen mit, relative Kanten fehlen teils.
ORT: ce builder/** (u.a. cache_engine_builder_iterator.hpp 3x ../../anatomy)
SOLL/FIX: Review-Fix 0: Paragraph-3a-Matrix KOMPLETT ersetzen mit einer Zaehlweise (echte #include-Direktiven, direkt+relativ, Produktionscode ohne Tests); Summenzeile "59 Lib-Kanten + 2 App-Kanten = 61" plus Zaehlentscheid-Satz: die ->builder-Kanten der drei Bau-Modul-Werkzeug-Apps (adhoc_emitter 2, catalog_codegen_tool 2, anatomy_codegen_tool 1) bewusst NICHT gezaehlt (Behelfs-CLIs, Absorption W7/#88).
STATUS LT. QUELLE: offen (Design-Korrektur)
ABHAENGIGKEIT/FLAECHE: -

### [w2zv55j8v.json] 11
GEGENSTAND: Review-MITTEL-Fund F6 -- Bruecken-Whitelist Paragraph 4.3 kollidiert mit Bestands-Pflicht A2.2: die "vier Naht-Familien" decken nur 41 der 49 K1-Kanten; ungedeckt: codegen 2 (adhoc_emitter+type_name -- genau der Bestand, den S-8s 2-Pass/Emission wiederverwenden muss), driver_build_variant_signature 2, workload_driver 1, lager_ablage 1, ceb_version_stamp 1, artifact_transport 1. Wo S-8 diese braucht, verbietet 4.3 die Bruecke und erzwingt Neuimplementierung.
ORT: Design #29 Paragraph 4.3
SOLL/FIX: Review-Fix 4 verbatim-Kern: Klammer ersetzen durch die am Objekt gemessene K1-Vollmenge "(experiment_tree 26, bestandslog 8, build_orchestrator/orch_make_stem 6, codegen/adhoc_emitter+type_name 2, driver_build_variant_signature 2, je 1 workload_driver, measure_storage/checkpoint_speicher, lager_ablage, ceb_version_stamp, artifact_transport)"; jede Familie brueckenfaehig MIT Marker; eine Bruecke AUSSERHALB der Liste ist erlaubt, wenn sie im selben Commit in die Besitzkarte nachgetragen wird (lauter Zugang statt Verbot).
STATUS LT. QUELLE: offen (Design-Korrektur)
ABHAENGIGKEIT/FLAECHE: S-8 (2-Pass braucht codegen-Emitter-Bestand); A2.2

### [w2zv55j8v.json] 12
GEGENSTAND: Review-KLEIN-Fund F7 -- Praezision+Anker: (a) Mini-Pipeline-Festlegung ist KON10-02 (Owner 11.08., D17 fuenf CI-Stufen), nicht KON25-04/-08 allein; (b) TEIL2-Zitatort experiment_dock_payload.hpp:24; (c) Monolith hat 18 Unterverzeichnisse, 16 mit C++; (d) builder 35 Unterverzeichnisse = 22 C++-tragende + 13 leere Skelette (#88-Triage-relevant); (e) R5 unvollstaendig: DRITTE Include-Wurzel libs/cache_engine/src macht <measurement/...>, <concepts/...>, <permutations/...>, <sha512/...> mehrdeutig (src/measurement/measurable_concept.hpp von axes 77x als <measurement/...> gezogen; "concepts" kollidiert mit C++-Std-Header); (f) Apps-Zaehlung inkonsequent (Werkzeug-Apps-Kanten 2+1+2=5 nicht gezaehlt).
ORT: Design #29 Paragraphen 1/2/3c/5
SOLL/FIX: Review-Fix 5: Anker ergaenzen (KON10-02/KON25-08/KON25-04 differenziert), Zitatort praezisieren, Nenner-Saetze 18/16 und 22/35 einfuegen, R5 um dritte Wurzel ergaenzen ("neue traeger/-Projekte erben KEINE der Alt-Wurzeln"), planer->src 2 (sha512, permutations) als eigene Mini-Familie in K1 nennen.
STATUS LT. QUELLE: offen (Design-Korrektur)
ABHAENGIGKEIT/FLAECHE: -

### [w2zv55j8v.json] 13
GEGENSTAND: Offene Owner-/Abstimm-Punkte des #29-Designs (8 Stueck): (1) Wurzel+Namen libs/traeger/{planer,ceb,tier,hybrid}, finale Namen mit S-6d/#67 -- dessen Alt-Zahlen "142 Include-Kanten / 29 Wanderungen" haben im Ledger 0 Belegstellen und sind per Owner-Wort "Bitte explore und schaerfen, behalten" neu zu erheben; Kollision planner(EN, Bestand profile_facade/planner) vs planer(DE, Ziel) VOR dem ersten Umzug entscheiden; (2) heuristik/ (6 D./1.961 Z.) Default HYBRID, Planer-Mitnutzung Break-Even-Bereichskarte (KON7-05) spaetestens bei HY-A bestaetigen; (3) mess/-Schnitt Default Kaskade->TIER, Naht-Typen->Querschnitt (loest K2); (4) Stufen-Kanten-Strenge Default adjazent-only, transitives Durchgreifen entscheidet erster Bedarfsfall LAUT (heute 0 gemessen); (5) experiment_tree-Besitz (26 der 49 Kanten); (6) Lager-Substanz (bestandslog 23 D./7.203 Z. + lager_ablage 2 D./929 Z.): Querschnitt-Kandidat vs CEB-Eigentum -- bei S-17 festzurren; (7) Timing-Lesart: Skeleton WE 15./16. VOR erstem S-8-Commit statt Paragraph-18.4-Blockzeile WE 22./23. -- Inhalts-Regel "VOR dem S-8-Bau" bindet, Owner-Einspruch moeglich; (8) Abweichung: apps/ traegt an 5f3f26a5 exakt 9 add_executable, KON47-01 nannte "10 Binaries" -- bei naechster Ledger-Fortschreibung korrigieren oder die 10. Binary benennen.
ORT: Design #29 Paragraph 6 + offen[0..7]
SOLL/FIX: Defaults stehen, Owner kann drehen; Punkt 8 als Ledger-Korrektur-Posten.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: S-6d/#67, HY-A, #18/S-13, S-17, Ledger-Fortschreibung

### [w2zv55j8v.json] 14
GEGENSTAND: Risiko R4 (Namens-Drift bricht S-12): Mini-Pipeline-Jobs haengen an Target-Namen; wenn S-6d/#67 spaeter Namen dreht, nur ueber ALIAS-Ziele drehen, nie die Erst-Namen brechen. R7: Verwechslung mit modules/-Altskelett (6 Saeulen, nur README) -- README-Hinweis im Skeleton + Deprecation bei #88 (nie loeschen, Doku-Policy).
ORT: Design #29 Paragraph 5
SOLL/FIX: siehe Gegenstand (verbatim uebernommen).
STATUS LT. QUELLE: nur-hinweis (Gegenmittel benannt)
ABHAENGIGKEIT/FLAECHE: S-12 (4 Mini-Pipelines, IST 12.08.: 0 von 4 Traegern mit eigenem Bau-/Test-Job; super 45 Jobs, ce 25, "hybrid" 0 Treffer, KON23-05/E)

### [w2zv55j8v.json] 15
GEGENSTAND: G-1-Design (dreiphasige Mess-Achse) als OWNER-VORLAGE, KEIN BAU: G-1 = PROFIL der Flag-Grammatik v2 (EIN Parser parse_algo_semver, Vereinfachung lebt in Katalog+Pruefsyntax des Mess-Homes); EBNF: mess_version := UINT.UINT.UINT.'c'[cpu_sub].mess_flag, mess_flag := 'm{' stufe[.stufe]* '}', stufen_token b|h|t, instrument w|ma|mi; Regeln M-1..M-10 (u.a. M-6 Anordnung ist Information, kein Sortieren; M-8 Projektion; M-9 EXAKTHEIT statt Teilmengen-Skip); Wert wohnt als Flag-Schwanz im measurement_tooling-Eintrag der Mess-Stempel-Zeile; Durchsetzung in 6 Stufen A-F ohne neuen Parser (Stufe B eigener kMessGrammarCatalog mit 13 (token,eltern)-Paaren, AUSDRUECKLICH NICHT m in den Hardware-Katalog; Stufe C neues Praedikat mess_version_is_wellformed, ce_owned_version_is_wellformed bleibt hardware-only; Stufe E S-3-Relation flag_menge_ist_teilmenge NUR freigabeseitig wiederverwendet).
ORT: w2zv55j8v.result.g1.design; ce algo_semver.hpp, flag_grammar_catalog.hpp (62 Eintraege :176), flag_menge_ordnung.hpp:76-84, anatomy_version_stamp.hpp:256-307, measurement_tooling_registry.hpp:47-49, plan_legend.hpp:74-100
SOLL/FIX: Bau erst nach Owner-GO, dann als Stempel-Strecken-Posten unter KON38 (Fable 5 max). Review-Fixes 1-5 (s. Eintraege 17-21) VOR Owner-Vorlage einarbeiten.
STATUS LT. QUELLE: offen (Entwurf; kein Bau erfolgt, READ-ONLY erfuellt)
ABHAENGIGKEIT/FLAECHE: Stempel-Strecke S-2; KON13-03; KON37-01/-02/-03; KON25-03 (Nenner 32=2^5)

### [w2zv55j8v.json] 16
GEGENSTAND: G-1-IST-Befunde: (a) canonical_combo() (plan_legend.hpp:74-100) dedupliziert und SORTIERT, kollabiert zu [all] -- zerstoert die Anordnungs-Information aus KON37-03; als CI-Legende in Ordnung, als Stempel-Quelle UNTAUGLICH, darf NIE Stempel-Quelle werden; (b) measurement_tooling_registry fuehrt 3 Eintraege wallclock/macro/micro alle "1.0.0.c" OHNE Stufen-Dimension -- Neubau mit Stufen-Dimension tier/hybrid/ceb und Belegungs-Zaehlung <= 32 ist owner-beschlossen (KON37-02: erweitern + neu + altes archivieren); (c) G-1-Grammatik existiert nicht (Nichtfund mit Gegenprobe: 0 Treffer fuer 6 Begriffe ueber libs/+tests/, Gegenprobe canonical_combo -> 2 Dateien).
ORT: ce plan_legend.hpp:74-100; measurement_tooling_registry.hpp:47-49
SOLL/FIX: Registry-Neubau = Tabellen-Seite der Grammatik (Stufe F); canonical_combo bleibt Legende.
STATUS LT. QUELLE: offen (Registry-Neubau beschlossen, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: KON37-02-Registry-Neubau; Bau-Reihenfolge gegen B1-B5 (KON34) beim Zuschnitt festlegen (offen[11])

### [w2zv55j8v.json] 17
GEGENSTAND: G-1-Review-HAUPTFUND (tragend): M-8-Projektion verliert Owner-Semantik -- der Owner-Satz "CEB gibt wallclock build auf der naechsten Traeger-Stufe frei" (Ledger :2148) wurde im Design-Zitat per "[...]" AUSGELASSEN; Konditional: KEIN CEB-w => KEINE Flaeche-3-Wallclock in den Tier-Binaries; Kontraposition + B3-Konsequenz (:2169-2173 "Die Tier-Gates bleiben -- gebaut werden sie nur noch, wenn die erzeugende CEB Wallclock traegt"): CEB-w => tier-seitige Wallclock-Gates WERDEN GEBAUT. Das Tier-KOMPILAT ist w-abhaengig, der M-8-Projektions-Stempel aber w-blind: m{b{w}.t{ma.mi}} und m{b.t{ma.mi}} projizieren BEIDE auf 1.0.0.c.m{t{ma.mi}} -- zwei verschiedene Tier-Kompilate, EIN Stempel = Alias-Identitaets-Klasse, die KON34-05 :3229 und die B11-Doktrin (algo_semver.hpp:533-537) verbieten. Design an dieser Stelle in sich inkonsistent (B-1 Phase 3 widerspricht dem Owner-Umkehrschluss; B-3 argumentiert selbst mit der Kind-Wirkung).
ORT: Design G-1 M-8/B-1/B-3; Ledger :2148-2173; ce algo_semver.hpp:533-537
SOLL/FIX: Review-Fix 1 verbatim-Kern: verdecktes Owner-Wort in Paragraph 0 sichtbar machen; Projektions-Regel so fassen, dass die CEB-w-Entscheidung im KIND-Stempel ankommt -- drei ehrliche Optionen als NEUER Owner-Entscheid F-G1-11 vorlegen: (i) Kinder stempeln den VOLLEN Vertrags-Ausdruck (loest auch den Anordnungs-Verlust), (ii) Projektion fuehrt vertragswirksame Fremd-Slot-Instrumente als Kontext mit, (iii) w gilt als reines CEB-Selbst-Instrument OHNE tier-seitige Naht -- dann B3-Konsequenz ausdruecklich als widersprochen ausweisen. B-1 Phase-3-Zeile ("keinen mehr, keinen weniger") korrigieren.
STATUS LT. QUELLE: offen (neuer Owner-Entscheid F-G1-11 noetig)
ABHAENGIGKEIT/FLAECHE: Lager-Identitaet/Stempel (Alias-Kollision); F-G1-10; KON34-05

### [w2zv55j8v.json] 18
GEGENSTAND: G-1-Review-Ambiguitaeten: (a) Nicht-Injektivitaet der Projektion -- 1.0.0.c.m{t{ma.mi}} ist ZUGLEICH gueltiger CEB-Voll-Vertragsausdruck (Ein-Slot-Vertrag, M-4) und Tier-Projektions-Stempel JEDES Vertrags mit t{ma.mi}; Anordnung und Fremd-Slots gehen per M-8 restlos verloren, obwohl M-6 sie zur Identitaets-Information erklaert -- mit dem w-Fund eine echte Lager-Identitaets-Kollision; (b) Sprachumfang der Mess-Zeile unterspezifiziert -- EBNF erlaubt zwischen c[cpu_sub] und m NICHTS, Stufe C liest sich aber als "beliebige katalog-gedeckte Hardware-Flags vor m zulaessig"; B-5 prueft nur die Organ-Richtung, nie die Spiegel-Richtung; (c) c{p.p}-Duplikate von der EBNF ableitbar, von keiner M-Regel und keiner Bestands-Wache verboten (v2 kennt kein Geschwister-Duplikat-Verbot, algo_semver :1571) -- 1.0.0.c{p.p}.m{...} waere heute form- UND katalog-gruen.
ORT: Design G-1 Paragraphen 3.1/6-Stufe-C/B-5
SOLL/FIX: Fix 3: Nicht-Injektivitaet als Eigenschaft ausschreiben (Rolle/Herkunft liegen am TRAEGER, nicht im Wert), an F-G1-10 anschliessen, haengt an F-G1-11. Fix 2: EBNF gilt (NUR c[{p|e|p.e}] vor genau einem m); in B-5 Spiegel-Negativ-Probe aufnehmen: 1.0.0.c.x512{f}.m{...} ist AUCH AUF DER MESS-ZEILE ROT. Fix 4: M-Regel/Wache "jedes cpu_sub-Token hoechstens einmal" in mess_version_is_wellformed ergaenzen ODER Luecke ausdruecklich als G-2-Erbe an #17 adressieren.
STATUS LT. QUELLE: offen (Design-Korrektur)
ABHAENGIGKEIT/FLAECHE: #17 (G-2-Semantik-Nachzug); B12-Wachen

### [w2zv55j8v.json] 19
GEGENSTAND: G-1-Review-Kleinfunde: (1) "Knotenzahl maximal 13" zaehlt nur den m-Baum (volle Zeile bis 16; Deckel 96 haelt); (2) B-5 verweist auf "Paragraph 6.2", die nicht existiert (Stufen A-F); (3) VERSCHWIEGENE NAHT: die Registry-B12-Batterie (tooling_versionen_wohlgeformt, measurement_tooling_registry.hpp:58-62) ruft heute ce_owned_version_is_wellformed und wuerde jeden m-Schwanz ABLEHNEN -- Umstellung auf mess_version_is_wellformed nur implizit in Stufe C/F, sonst ist der Registry-Neubau mit m-Schwanz compile-rot; (4) offen, welche <id> der measurement_tooling-Eintrag traegt, wenn der m-Ausdruck mehrere Toolings ueber Stufen mischt (heute GENAU EINE gewaehlte Tooling-id, anatomy_version_stamp.hpp:256-259).
ORT: ce measurement_tooling_registry.hpp:58-62; anatomy_version_stamp.hpp:256-259
SOLL/FIX: Fix 5 (a)-(d): Verweis berichtigen, Knotenzahl praezisieren, Wachen-Umstellung in Stufe C/F benennen, <id>-Frage festlegen bzw. als Teil des Registry-Neubau-Entscheids fragen.
STATUS LT. QUELLE: offen (Design-Korrektur; Punkt 4 Owner-/Design-Frage)
ABHAENGIGKEIT/FLAECHE: KON37-02-Registry-Neubau

### [w2zv55j8v.json] 20
GEGENSTAND: G-1 offene Owner-Entscheide F-G1-1 bis F-G1-10 (verbatim-Kurzform): F-G1-1 Profil-Entscheid (G-1 als Profil der v2, Empfehlung ja); F-G1-2 Vokabular m/b h t/w ma mi (0 von 8 Kandidaten kollidieren im 62er-Katalog); F-G1-3 kein Planer-Slot (spaeterer Planer-Messfuehler = additives viertes Stufen-Token); F-G1-4 Vererbungs-Lesart Projektions-GLEICHHEIT; F-G1-5 Exaktheit als Gueltigkeits-Relation (kein Teilmengen-Lager-Skip, Filter B, KON9-09); F-G1-6 leere Slots zulaessig, leeres m verboten; F-G1-7 CPU-Pflicht .c bleibt vor .m{...} (Empfehlung) oder m ersetzt c (dann Ausnahme-Mechanik in beiden B12-Wachen); F-G1-8 PMC ausserhalb des m-Flags (Empfehlung aussen; Vendor-Permutation ist keine an/aus-Belegung); F-G1-9 Lastsequenz bleibt load_framework-Meta-Meta; F-G1-10 Anordnungs-Deklaration (String traegt, Home-Tabelle pinnt, Vorbild kFlagVoraussetzungsKetten). Dazu per Review NEU: F-G1-11 (s. Eintrag 17).
ORT: Design G-1 Paragraph 8; offen[0..9]
SOLL/FIX: Owner-Vorlage nach Einarbeitung der 5 Review-Fixes.
STATUS LT. QUELLE: offen (Owner-Entscheide)
ABHAENGIGKEIT/FLAECHE: S-6-Fenster (Position der Mess-Zeile: an S-6 wird NICHTS gebaut, offen[10]); S-19 Planer-Simulation (Nenner-Umfang, offen[13]); #17 (offen[12])

### [w2zv55j8v.json] 21
GEGENSTAND: G-1-Review-Quittungen (Restzweifel-frei bestaetigt): alle G-2-Fundstellen exakt; Kollisions-Erhebung 0/8 reproduziert (Achtung Falsch-Null: erstes Suchmuster des Reviewers biss nicht, Design-Erhebung selbst korrekt); alle 5 Beispiele nachgerechnet, Kern-These "der bestehende Parser parst jede G-1-Form heute schon" am Objekt WAHR (parse_algo_semver prueft weder Katalog :66-71 noch CPU-Pflicht :695-708 noch Geschwister-Duplikate take_flag_node :632-650; auch Tiefe 3 parst); alle Owner-Zitate verbatim korrekt an den angegebenen Ledger-Zeilen; Nichtfund G-1-Bestand plausibel (ce_owned_version_is_wellformed :1042 lehnt katalogfremdes m heute ueberall ab).
ORT: w2zv55j8v.result.g1.review.funde[0-2,7,9]
SOLL/FIX: -
STATUS LT. QUELLE: nur-hinweis (Quittung)
ABHAENGIGKEIT/FLAECHE: -

---

### [wwbu56lus.json] 1
GEGENSTAND: Workflow "Offene Rueckfragen gegen Ledger+Plan+Memories" (3 Phasen Suche/Gegenprobe/Vorlage, 3 Opus-Agenten, alle done) -- ACHTUNG DATIERUNG: Lauf vom 06.08. (Timestamps), Bezugsrahmen war die alte Abgabe-Frist Fr 08.08.; Status-Angaben sind gegen den 13.08.-Stand zu pruefen. Ergebnis: 20 Fragen, 13 eliminiert; Gegenprobe: 15 geprueft, 6 Zitat-Fehler, 5 neue Funde, 1 gekipptes Verdikt; Vorlage: Liste 1 = 16 beantwortet (geht NICHT an Owner), Liste 2 = 5 Owner-Posten (O-1..O-5), Liste 3 = 3 neue (N-1..N-3).
ORT: wwbu56lus.json; Ledger wuchs waehrend des Laufs 5692->5840 Zeilen (Zitate ueber Anker, nicht Zeilen)
SOLL/FIX: Bei Widerspruch zwischen Erst-Explore und Gegenprobe gilt die Gegenprobe.
STATUS LT. QUELLE: teilweise (Owner-Vorlage erstellt; Vollzug der Ausfuehrungs-Posten offen)
ABHAENGIGKEIT/FLAECHE: -

### [wwbu56lus.json] 2
GEGENSTAND: A1 allow_failure am emittierten Voll-Mess-Batch -- es FAELLT: der JOB muss fallen, die CSV-Zelle bleibt "failed" (#278 Owner 06.07. PFLICHT; Ledger Z.692 "0 allow_failure im GESAMTEN Matrix-System, einzige Ausnahme by design: ce is_original:relock"; Z.686 Praezedenz "Pipeline-success mit allow_failure LUEGT"). Gegenprobe-Korrektur: der Uebertrag auf den Batch ist als OFFENER Posten markiert (ANKLAGE V-C: "Die Doktrin ist an der Stelle erfuellt, an der sie nichts kostet, und an der Stelle verletzt, an der sie zaehlt") -- zu VOLLZIEHEN, nicht wegzudefinieren; braucht aber keine Owner-Frage (#278 deckt).
ORT: super experiment_plan_director.hpp:1333 (Posten i-3)
SOLL/FIX: "Posten i-3, experiment_plan_director.hpp:1333, gemeinsam mit i-1/i-2 in EINER Welle."
STATUS LT. QUELLE: offen (Bau-Posten i-3)
ABHAENGIGKEIT/FLAECHE: i-1/i-2 (PMC-Welle); Memory allow_failure-VERBOTEN

### [wwbu56lus.json] 3
GEGENSTAND: O-A Teile (1)+(2) PMC-Pflicht: PMC-Flag als INVARIANTE in die dynamische Kette (Owner F9 16.07.: "MUSS als PFLICHT fuer die Vollstaendigkeit aller perf-Messwerte mit in die Ergebnisse"); Wurzel-Befund: "die PMC-Pflicht war an ZWEI JOB-NAMEN geheftet statt an eine Invariante ... Exakt die Fehlerklasse von R4"; Gegenstelle "honest-0 bis #26" ist UEBERHOLT (#26 am 12.07. vollzogen, Ledger Z.570). Trigger darf vor dem Fix NICHT feuern (V7.4 "PMC-AND hart" als Trigger-Auflage).
ORT: super experiment_plan_director.hpp:1342 (danach 841/877/1194); m3v2_pmc_smoke.cpp:71
SOLL/FIX: "i-1 (experiment_plan_director.hpp:1342, danach 841/877/1194) + i-2 (m3v2_pmc_smoke.cpp:71, Preflight auf pmc_available=1 verengen, den 13.07.-Inversionsfix NICHT zuruecknehmen) + i-3 als EINE Welle; Biss = Director-Test auf die emittierte YAML und ein Preflight, der ohne Flag rot wird."
STATUS LT. QUELLE: offen (Bau-Welle i-1..i-3)
ABHAENGIGKEIT/FLAECHE: Voll-Bau-4-Trigger; A3/G4a (per-Lane-PMC-Preflight in emittierten Mess-Batch-Jobs, Task #37, Stand 03.08. GEBAUT)

### [wwbu56lus.json] 4
GEGENSTAND: A2 Invalidierungs-Fenster BEANTWORTET: Owner 05.08. abend-5 "O-2 = OPTION A JETZT" (vor dem Trigger = letzter billiger Moment; Neuanker mit A2-Fixen F1/F3/F4/F5 GEBUENDELT, EIN Shift, EIN Fenster); Bestands-Invalidierung ist eine der sieben Trigger-Auflagen (Ledger V7.4 Z.104). Zitat-Korrektur der Gegenprobe: die "GN-11"-Klausel im Erst-Explore-Verbatim war Zutat (Original endet "...verdienen sich Gruendlichkeit und saubere Architektur viel eher, als ein verfruehter Start").
ORT: Ledger abend-5/:4131; V7.4 Z.104
SOLL/FIX: kein neuer Posten; Doktrin: waehrend eines laufenden Batches keine Invalidierung (Paragraph 74).
STATUS LT. QUELLE: behoben/entschieden (O-2 Option A)
ABHAENGIGKEIT/FLAECHE: Nummern-Kollision O-2 (codegen-Minor 19.07. vs Preimage-Neuanker 05.08.)

### [wwbu56lus.json] 5
GEGENSTAND: C1 codegen-Minor-Bump-Politik: Owner waehlte 19.07. den MECHANISMUS, nicht Einzelfreigabe -- Paragraph-32-F4: "codegen-Minor = CI-Tripwire hart-rot (Lock tools/axis_version_lock/axis_version.lock)". DIESE WACHE LAEUFT IN KEINER PIPELINE (ANKLAGE V-D: doppelter Job-Key .gitlab-ci.yml:343 vs :502, gewinnende Definition rules-gated auf COMDARE_AXIS_LOCK_CHECK == "true", das in ce+super NIRGENDS gesetzt ist). B14-Bump a402cfbc (kCebContractCodegenMinor 0->1, 8.0->8.1) ist gelandet (ce development e7aa1244 via Merge f577f886, Pipelines 15025/15029/15031 gruen). Erst-Explore-Behauptung "keine Freigabepflicht in irgendeiner Doktrin-Zeile" widerlegt (Plan-Tabelle 20260806-PLAN-versionierungs-interface-stempel.md:407 Spalte Owner-Entscheid = JA). V6.5-TABU "ABI-MAJOR==4" DOPPELT superseded: heute ABI-7 (Magic .A7.), Observer-POD 1344 Version 8, 18 Organ-Achsen.
ORT: super/ce .gitlab-ci.yml:343+:502; tools/axis_version_lock/axis_version.lock; ce anatomy_module_abi_v1_decl.hpp:440-443
SOLL/FIX: "Posten i-4 -- Tripwire scharfstellen, mit rotem Erstlauf rechnen (Header koennen seit Wochen driften); Heilung = Lock-Regeneration nach F4, kein Owner-Gate. Dem Owner gehoert davon eine Meldezeile, keine Frage."
STATUS LT. QUELLE: offen (i-4; Bump selbst behoben@a402cfbc)
ABHAENGIGKEIT/FLAECHE: contract:axis-version-lock-Job; Nummern-Kollision O-2

### [wwbu56lus.json] 6
GEGENSTAND: C2 additive kV3AxisSchema-Slot-Belegung [5][5] durch B14: JA erlaubt (DOSSIER 04.08.:696 "T5 (3 frei): optionaler Alignment-/Split-Zaehler [5][5]; Rest Reserve"; Ereignis-Klasse A layout-neutral; Praezedenzen #268 und [2][6]). Gegenprobe-Korrekturen: geltender POD ist 1344 (Version 8, ABI-7), NICHT 1416; Praezedenz-Kommentar steht abi_adapter.hpp:1468 (nicht :1193); NEBENFUND: die "1272" in diesem Kommentar ist ihrerseits STALE -- :1501 und :2069 derselben Datei sagen 1344.
ORT: ce libs/cache_engine/anatomy/abi_adapter.hpp:1468 (stale), :1501/:2069 (richtig)
SOLL/FIX: "Lead-Folgeposten: den stale Kommentar im Aufraeumpass mitziehen."
STATUS LT. QUELLE: teilweise (Berechtigung bestaetigt; stale Kommentar offen)
ABHAENGIGKEIT/FLAECHE: Aufraeumpass Paragraph 75

### [wwbu56lus.json] 7
GEGENSTAND: D1 Plan-Zaehler ist KEINE eigenstaendige Resume-Autoritaet -- Owner-Gruendungssatz (abend-10 05.08., A1 verbatim): Zaehler nur "sofern die Binary Reihenfolge und der Faecher fuer das Batch klar und persistiert geplant sind. Freigabe."; Leitsatz "der Zaehler-Resume darf NIE mehr behaupten, als der Fingerprint deckt" (Quellen-Korrektur: steht in mittag-13/LEDGER:5086, NICHT mittag-18); Inventar-Blick ist die Autoritaet, der Plan nur die Beschleunigung.
ORT: Ledger abend-10, mittag-13, mittag-15/-16, nachmittag-6
SOLL/FIX: "offen > 0"-Abschneidung und Formwache bleiben getrennt ("(b) UND (d) ERSETZEN EINANDER NICHT"); present_-Gate ausdruecklich NACH der Abgabe (nachmittag-10 Abschnitt G, nicht F).
STATUS LT. QUELLE: entschieden; present_-Gate offen (nach Abgabe)
ABHAENGIGKEIT/FLAECHE: T2-A-Strecke; Bestandslog

### [wwbu56lus.json] 8
GEGENSTAND: D2/D3/D5 Plan-Datei-Ablage (Lead-Entscheide, kein Owner): Ort = "neben dem Bestandslog-Ausgabebaum, PRO Cluster-Zelle getrennt" und die Datei wandert IN die gelandete Single-Source lager_pfad_grammatik.hpp (EIN Owner L5, TU test_lb0_lager_pfad_grammatik, 33 TEST-Makros), nicht daneben; Env-Var statt XML (Muster der Nachbarn; XML-Variante waere Architektur-Entscheid weit ueber die Welle hinaus -- als eigener Nach-Abgabe-Posten notieren); F7-Staffelung: Zwischenstand ist Option 1 (fail-closed), Option b nach Interface-Bau, Option 2 NICHT vorziehen (dieselbe Nach-Abgabe-Welle wie Host-Belegung). D3-Zusatz (Punkt 11): Host-Belegung von pa.batch_plan_datei NICHT vor der Abgabe scharf (gemessene Pass-Zahl 18 statt 1 -- revidierte Empfehlung des Plans selbst).
ORT: docs/plaene/20260806-PLAN-host-belegung-batch-plan-ablage.md 2.1/3.3/5.2/5.3
SOLL/FIX: siehe Gegenstand (verbatim-Kerne uebernommen).
STATUS LT. QUELLE: entschieden (Lead), Bau nach Abgabe
ABHAENGIGKEIT/FLAECHE: lager_pfad_grammatik (L5); Versionierungs-Interface F7

### [wwbu56lus.json] 9
GEGENSTAND: D4/N-1 O-C "Faehrt der Trigger-Lauf mit COMDARE_BESTANDSLOG?": Rezept liegt zweifach vor (KONSOLIDIERT 01.08. Paragraph 8 + FAHRPLAN :65-67, Variable als Trigger-POST-Variable, bewusst NICHT im YAML -- Repo-grep kann sie prinzipiell nicht finden); Code-Kette existiert und ist getestet (experiment_plan_director.hpp:952-955 append_forward_var_literal, test_experiment_plan_director.cpp:845-860); ABER Vollzug unbestaetigt -- juengster Ledger-Stand (nachmittag-8, K-01 WIDERLEGT) erklaert die Frage ausdruecklich fuer "vom Repo aus nicht entscheidbar" (Runner-Env/Projekt-Variablen/Aufrufskript ausserhalb). "O-C ist nicht erledigt, sondern verengt auf: Rezept liegt vor, Vollzug unbestaetigt." Die vier Folgefragen KK-4/K-06/K-07/T-ii-3 NICHT mit-abraeumen.
ORT: super experiment_plan_director.hpp:952-955; test_experiment_plan_director.cpp:845-860
SOLL/FIX: N-1-Empfehlung: "Provider hart Pflicht im Voll-Lauf -- nicht per Env-Zufall, sondern per Wache: Env-Gate umkehren (Default AN, Abschalten nur explizit) UND im Planer harte Wache, die einen Voll-Lauf ohne Provider ABBRICHT statt stumm zu degradieren; parallel cfg.bestand_fingerprint_fn in bestandslog_active aufnehmen (fail-closed)." Posten i-5 + i-6, NACH T2-A-Landung und NACH i-1..i-4 ("ein scharfes Skip-Gate ohne PMC-Fix misst nur schneller falsch"). Vom Owner nur Bestaetigung + ggf. Ist-Wert der Variable auf den Runnern.
STATUS LT. QUELLE: offen (Owner-/Infra-Frage + Bau i-5/i-6)
ABHAENGIGKEIT/FLAECHE: T2-A-Landung; i-1..i-4; ANKLAGE V-B (Opt-in-Deckung G-C1 ist VERDRAENGTER Vorschlag)

### [wwbu56lus.json] 10
GEGENSTAND: Liste 2 Owner-Posten (Stand 06.08.): O-1 Anhangs-Umfang PMC (Anhang kann bestenfalls L1D+dTLB zeigen; Empfehlung: Limitierung 1 praezisieren statt Anhang kuerzen -- DE+EN umschreiben auf "L1D und dTLB erhoben; L2/L3/Kohaerenz/Energie erfordern Zen-5-RAW-Events (I-PMC-2/3)"); O-2 Anhang-A-Reichweite M-8/M-9/M-15-Writer (Default NACH-ABGABE; Anhang A 137 Z. gefuellt, baut gruen, diplomarbeit-de.pdf 202 Seiten, LaTeX-Warnings=0); O-3 F6 Paragraph-47-Mess-Tooling-CT-Achse (Empfehlung: nur die Auffaecherung ist verworfen, die Achse bleibt -- Streichung wuerde die entschiedene Single-Source Paragraph-32-F6 rueckabwickeln); O-4 F8 Fingerprint-Uebertragbarkeit (Empfehlung: JA uneingeschraenkt, Doktrin im Code festschreiben + Regressionstest + Parser-Test mit literalem v5-On-Disk-Stamp, ~2h; NEIN wuerde jede Cross-Run-Wiederaufnahme entwerten); O-5 Scrub-Ref (s. Eintrag 12).
ORT: wwbu56lus.result.vorlage Liste 2
SOLL/FIX: je Posten Empfehlung + Konsequenz beider Wege dokumentiert; Dringlichkeiten: O-1/O-4 vor Phase 6, O-2/O-3 vor Abgabe, O-5 danach.
STATUS LT. QUELLE: offen (Owner-Entscheide; gegen 13.08.-Ledger auf zwischenzeitliche Beantwortung pruefen)
ABHAENGIGKEIT/FLAECHE: F6-Dreifach-Namenskollision; A4-Korrektur "bis #26" (Sperre abgelaufen, #26 am 12.07. vollzogen)

### [wwbu56lus.json] 11
GEGENSTAND: N-2 (NEU, Owner): das USER-GO fuer die 320er-Abgabemessung wurde NIE erteilt; Voll-Lauf (2^17 x 12 System-Perms + mehrtaegige Messung) wird bis zur (alten) Frist nicht fertig. N-3 (NEU, Owner): I-PMC-2/I-PMC-3 (#187) Zen-5-RAW-Nachruestung L2/L3/Kohaerenz -- Empfehlung NEIN vor dem Voll-Lauf (falsch kodiertes RAW-Event liefert plausible falsche Zahlen statt ehrlicher 0; Quelle schuetzt bewusst "kein RAW-Rateversuch").
ORT: Ledger V7.4 Z.104; linux_perf_pmc_source.hpp:191-194 (L1+LL real, L2 ehrlich 0)
SOLL/FIX: N-2-Empfehlung: "Zwei getrennte GOs, und die Abgabe faehrt auf der 320er" (Trigger feuert sobald i-1..i-4 + LB-Stufe-1 gelandet; 2^17-Matrix als laufendes Experiment beschreiben).
STATUS LT. QUELLE: offen (Owner-GOs)
ABHAENGIGKEIT/FLAECHE: i-1..i-4; LB-Stufe-1; Anhang A

### [wwbu56lus.json] 12
GEGENSTAND: B-Sicherheit: (a) O-5/B1 Scrub 02.08.: refs/backup/pre-secret-scrub-20260802 liegt auf origin (5ba3d03f, github leer; heute-Abend-Kontrollzeile nachmittag-10 G) -- UEBERWACHTER Zustand, kein vergessener (Erst-Explore-Aussage "0 Treffer/kein Nachtrag" FALSCH, 3 Treffer in 2 Dateien); Verfahrens-Delta bleibt: dokumentiertes Scrub-Verfahren verlangt lokale Bundles chmod 700, nicht Remote-Refs; KEINE Abschluss-Erklaerung, KEINE Rest-Expositions-Aussage existiert. Empfehlung: stehen lassen bis nach der Abgabe, dann Bundle + Remote-Ref loeschen (Remote-Loeschung NUR mit explizitem Owner-GO). (b) B3 refs/original/ (filter-branch-Rest, lokal refs/original/refs/heads/development): 0 Treffer Regel in docs/+Memories -- Lead-Entscheid: wie refs/backup behandeln (additiv stehen lassen), Aufraeumen fruehestens Paragraph-75-Aufraeumpass mit GO. (c) B2 Token-Rotation: E5 entschieden -- Infra rotiert NACH Messfenster, Handout an Infra JETZT; terminiert, nicht unentschieden.
ORT: origin refs/backup/pre-secret-scrub-20260802 (5ba3d03f); lokal refs/original/refs/heads/development
SOLL/FIX: siehe Gegenstand.
STATUS LT. QUELLE: O-5 offen (Owner kennt-Pflicht); B2 entschieden; B3 Lead-entschieden
ABHAENGIGKEIT/FLAECHE: Remote-Loeschung=GO-Doktrin; Paragraph-75-Aufraeumpass

### [wwbu56lus.json] 13
GEGENSTAND: Fehlende Fragen der 19er/20er-Liste (Gegenprobe-Tabelle): O-A Kappung 2.097.152 vs cap=131072 (zu 2/3 beantwortet via Paragraph 41 "bauen alles new golden, messen alles mit der 320er"; offen nur ob cap die neue 4x-line_size-Multiplikation KF-6/A4 traegt); E-1 search_algo-Pin BLOCKER (kanonische golden-XML heute nicht validierbar; Empfehlung A; B oeffnet TABU-5 UND bricht kNewGolden131072Crc64); E-3/E-4/E-5 (XSD additiv, TABU-6 Wire/binary_id-Grammatik in S6 = das einzige TABU das geoeffnet wuerde, leere System-Kanaele target_isa/compiler/atomic128); E-A..E-F Versions-Plan 5.2 -- SECHS nicht fuenf, E-F fehlt in jeder Sammlung; Gate-Regel verbatim: "STOPP (generell): ohne Entscheid kein Byte."; i-5 Provider-Opt-in (Zwilling zu D4, fehlte komplett); R2-WIDERSPRUCH: Register fuehrt E-18-Zielbranch-Gate offen, das laut eigenem Befund B-1 HOCH am 06.08. frueh gefallen ist -- ungeklaert; O-B/O-E (A1-Scope 24x-reallocate, Phase-6-GO-Stopp) offen; B14-Teil-2: mittag-22/LEDGER:5000 nennt ZWEI B14-Entscheide (codegen-Minor + additive TABU-Beruehrung) -- die Liste hat nur den Bump; Quellen-Korrektur: der Satz steht in mittag-22, nicht nachmittag-6, und ist von nachmittag-10 NICHT zurueckgezogen.
ORT: wwbu56lus.result.gegen Tabelle "FRAGEN, DIE IN DER LISTE FEHLEN"
SOLL/FIX: jede Referenz braucht Datum UND Sachbezug -- 4 Nummern-Kollisionen im Korpus: O-2 (doppelt), F6 (dreifach), B12 (Register-xlsx vs Paragraph-55-alt), R2 (E-18-Zielbranch vs Driver-Split).
STATUS LT. QUELLE: offen (mehrere Owner-/Klaer-Posten)
ABHAENGIGKEIT/FLAECHE: golden-Plan E-1..E-5; Versions-Plan E-A..E-F; TABU-5/TABU-6

### [wwbu56lus.json] 14
GEGENSTAND: Nicht-Owner, aber terminkritisch und in keiner Liste (Stand 06.08.): (a) Kalibrier-Stichprobe vor dem Trigger -- 200 Binaries bauen, Zeit stoppen; bei 5 s/Binary 7,6 h, bei 30 s 45,5 h: "Der Unterschied zwischen geht und geht nicht haengt an einer Zahl, die niemand gemessen hat"; (b) contract:axis-version-lock laeuft in keiner Pipeline (= die vom Owner in Paragraph-32-F4 bestellte Wache, s. Eintrag 5); (c) axis_inventory.tex wird geschrieben und ist in keine .tex eingebunden; (d) B12 xlsx-Writer: Owner abend-5 entschied "mit in die Abgabe vor der Messung", Register fuehrt B12 weiter als offen -- Termin-Kollision.
ORT: FAHRPLAN Paragraph 5; ANKLAGE V-D; Register
SOLL/FIX: siehe Gegenstand (jeder Punkt ein eigener Posten).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Trigger-Vorbereitung; Thesis-Bau

### [wwbu56lus.json] 15
GEGENSTAND: Cacheline-Achse (Owner-Frage vom 06.08. mittags, Punkt 13): beantwortet -- "NEIN als Hardware-Line, JA als Alignment" (prod1 Zen 5: alle vier Cache-Ebenen 64 Byte im Silizium); ENTSCHAERFUNG: die Achse dringt heute gar nicht bis zur Tier-Binary durch (catalog_codegen_tool/main.cpp:183-190 weist cacheline in permute_axes HART zurueck); "line_size als ZAEHL-Einheit -- HIER UND NUR HIER Phantom" = die CLU-Quelle des B14-Blockers.
ORT: super apps/catalog_codegen_tool/main.cpp:183-190; docs/architektur/20260806-DEEP-RESEARCH-cacheline-hardware-vs-achse.md (580 Z.)
SOLL/FIX: "Zaehl-Dimension an die echte Hardware-Line binden oder ehrlich als Zaehl-Granularitaet benennen; Alignment-Dimension bleibt legitim permutiert und gehoert in die Auswertung (Folly-Praezedenz, Adjacent-Line-Prefetcher)." Bau-Auftrag im Doc 3.3 "ausfuehrbar ohne Rueckfrage". NEUER BAU-POSTEN: die Freigabe-Kette "gibt die System-Achse frei, was die Hardware kann?" existiert fuer cacheline "NICHT EINE ZEILE".
STATUS LT. QUELLE: offen (2 Bau-Posten)
ABHAENGIGKEIT/FLAECHE: B14; KF-6/A4 line_size-Multiplikation

### [wwbu56lus.json] 16
GEGENSTAND: LB-Lager-Basis-Tests (Punkt 14): Vor-Trigger-Pflicht per Owner-Wort (OE-B GO: Dummy-Lager im temp-Verzeichnis, Binaries als TEXTDATEIEN mit Stempel-String, Google-Test nicht Shell; LB-6 "der Voll-Bau-Trigger IST der Baum-Vollausbau"; Kollisionsregel Variante B: Substanz gewinnt, Trigger darf rutschen). Ist: Header LB-0..LB-3 gebaut, Beweise NUR bis LB-1 (33+23 TEST-Makros), KEIN eigener test_lb2/test_lb3; Kette fehlt in Ledger UND Register ("Muster LB-[0-9]: 0/0"). Stufe 2 (Binary-Stub) haengt am Versionierungs-Interface (F7 Option b) -- Interface-Bau und Stub-Test in dieselbe Planung, Termin nach der Abgabe; Stufe 1 unabhaengig davon. Generalregel (gilt sofort): "Kosten-Klammern um Stempel-Bildung sind gegen die Testwelle zu pruefen, BEVOR sie eingebaut werden."
ORT: ce/super LB-Header; Memory project_lager_basis_tests_dummy_strategien_stempel
SOLL/FIX: test_lb2/test_lb3 nachziehen ("Restarbeit ist klein und golden-neutral"); Ledger/Register-Buchung der LB-Kette nachtragen.
STATUS LT. QUELLE: teilweise (LB-0/LB-1 bewiesen; LB-2/LB-3 offen)
ABHAENGIGKEIT/FLAECHE: Versionierungs-Interface; Trigger

### [wwbu56lus.json] 17
GEGENSTAND: Landestand-Quittung (Punkt 16, 06.08.): ce c837d830..e7aa1244 -> main (origin+github), super 030d2c62..5534c23c -- beide echte Fast-Forwards (merge-base --is-ancestor geprueft), sieben gruene Pipeline-Laeufe, zwei gruene Bridges. Dauer-Regeln aus demselben Nachtrag: "Eine rescue-Ref ist KEINE Landung" und "Ein Submodul-Zeiger im Working Tree kann RUECKWAERTS zeigen. M heisst nicht neuer." (an Abgabe-Substanz gelernt: 78 Commits Rueckstand im Thesis-Submodul, um ein Haar ueberschrieben).
ORT: ce/super main@06.08.
SOLL/FIX: Dauer-Regeln in Landungs-Workflows mitfuehren.
STATUS LT. QUELLE: nur-hinweis (Quittung + 2 Dauer-Regeln)
ABHAENGIGKEIT/FLAECHE: Landungs-/Merge-Flaeche Submodul-Zeiger

### [wwbu56lus.json] 18
GEGENSTAND: E4 A1-Bump-Policy (beantwortet): generisches Kriterium lebt im Code-Header aller 26 Allokator-Varianten ("Aenderung dieser Variante ODER eines von ihr allein genutzten Helfers ... binary_id bleibt unberuehrt (Version lebt im Sidecar). Startwert v1; Bump-Disziplin ab dem 1. Bump."); flankiert von Paragraph 43.b (X.Y.Z-Semantik, Z-Bumps invalidieren ebenso), OE-C ("Version-Bump EINER Haupt-Achse => Neubau ALLER Binaries, die sie beinhalten"), B6-Nachtrag DOPPEL-ABSICHT (Literal + Assert im selben Commit + Deklaration des Byte-Ereignisses), "algo_version-Bump-Frage NICHT stillschweigend" (S5-04-Praezedenz). Ehrliche Grenze: keine Entscheidungstabelle Aenderungsart->X/Y/Z-Stelle -- dokumentierte Methode, keine Luecke.
ORT: a1-nb-wip.patch (Kontextzeilen, 26 Varianten)
SOLL/FIX: -
STATUS LT. QUELLE: entschieden (nur-hinweis)
ABHAENGIGKEIT/FLAECHE: -

---

### [wa91q7g1p.json] 1
GEGENSTAND: Owner-Auftrag SIMD-Web-Recherche (alle SIMD-Versionen + Vorgaenger fuer 32-bit UND 64-bit ISA, Komposit-Basen x128/x256/x512 + Sub-Flags): 6 Agenten (5 Lenses + Synthese), alle done; 186 Flag-Eintraege ueber 5 Lenses (Lens0 x86-Gesamt 41, Lens1 AVX512-Subsets 24, Lens2 Grammatik/32-bit 56, Lens3 Companions/AMD 25, Lens4 ARM/RISC-V 40), davon 70 mit Vermerk "FEHLT im Ist-Katalog"; je Lens explizite luecken-Listen (11/6/9/11/11) und Quellenlisten.
ORT: wa91q7g1p.json; Ist-Katalog ce libs/cache_engine/include/cache_engine/measurement/simd_feature_flag.hpp
SOLL/FIX: Ergebnis ist Katalog-Erweiterungs-Grundlage; Owner-Entscheide unter katalog.offen[0..9] VOR Bau.
STATUS LT. QUELLE: offen (Recherche fertig, Katalog-Erweiterung nicht gebaut)
ABHAENGIGKEIT/FLAECHE: Flag-Grammatik v2 / S2-Katalog; G-2-Semantik

### [wa91q7g1p.json] 2
GEGENSTAND: HARTE BESTANDSKORREKTUR (wichtigster Befund, von 3 Lenses unabhaengig + Synthese bestaetigt): Der Auftrag nannte "30 Flags in vier Tiers (17 Avx512, 5 Avx256, 5 Companion, 3 Scalar)" -- FALSCH. Bestand ist 23 (14 Avx512, 4 Avx256, 3 Companion, 2 Scalar), zementiert durch static_assert(kSimdFeatureFlagCatalog.size() == 23) und count_flags_of_tier(Avx512) == 14; geprueft in ALLEN 39 Kopien im Dateisystem (26 Worktrees, jobs-Klone, Backups) -- ausnahmslos 23; Git-Historie: Datei in Commit 3111adba MIT 23 Flags geboren, nie anders versioniert. Eine 30-Flag-Fassung existiert NIRGENDS.
ORT: ce simd_feature_flag.hpp (172 Z.); Commit 3111adba
SOLL/FIX: "Vor jeder Planung klaeren, sonst wird gegen einen Phantom-Bestand gebaut." (Herkunft der 30er-Zahl im Auftragstext klaeren.)
STATUS LT. QUELLE: offen (Klaerungs-Posten)
ABHAENGIGKEIT/FLAECHE: jeder Katalog-Erweiterungs-Task; Auftrags-/Ledger-Text

### [wa91q7g1p.json] 3
GEGENSTAND: STRUKTURELLER BLOCKER vor jeder Katalog-Erweiterung: SimdFeatureFlag.cpuinfo ist die IDENTITAET (operator== vergleicht nur cpuinfo; MachineSimdSignature::has_flag matcht darauf). Elf der interessantesten Neuzugaenge haben KEINEN /proc/cpuinfo-String (live geprueft, alle elf abwesend): avx_ifma, avxvnniint8, avxvnniint16, avxneconvert, sha512, sm3, sm4, avx512_bmm, avx10.1, avx10.2, apx -- ueber den heutigen Erhebungsweg NICHT signaturfaehig; ein Katalogeintrag koennte nie matchen.
ORT: ce simd_feature_flag.hpp; machine_simd_signature.hpp
SOLL/FIX: "Entweder Erhebung auf CPUID direkt umstellen oder diese Flags bewusst draussen lassen -- aber nicht stillschweigend aufnehmen."
STATUS LT. QUELLE: offen (Struktur-Entscheid vor Erweiterung)
ABHAENGIGKEIT/FLAECHE: Signatur-Matching; Katalog-Erweiterung

### [wa91q7g1p.json] 4
GEGENSTAND: Katalog-Luecken-Inventar (fehlt_im_bestand): (a) x128 KOMPLETT ABWESEND -- 10 Flags, alle live in /proc/cpuinfo vorhanden = sofort signaturfaehig, alle in beiden Bitbreiten baubar: sse, sse2, pni(-msse3; cpuinfo heisst pni NICHT sse3), ssse3, sse4_1, sse4_2, sse4a (AMD, in Zen NICHT gestrichen), aes, pclmulqdq(-mpclmul), sha_ni(-msha); ohne aes/pclmulqdq ist die Voraussetzungskette aes->vaes und pclmulqdq->vpclmulqdq nicht abbildbar, obwohl beide Nachfolger im Katalog stehen; (b) x256-WURZEL avx selbst fehlt (Katalog beginnt bei avx2); (c) 7 x256-Neuzugaenge baubar aber nicht signaturfaehig (avx_ifma, avxvnniint8/16, avxneconvert, sha512, sm3, sm4); (d) 6 Scalar-Luecken (bmi1 fehlt obwohl bmi2 da -- unabhaengige CPUID-Bits; abm, movbe, adx, rdrand(-mrdrnd), rdseed) mit Namensfallen (bmi1 MIT Ziffer, -mbmi OHNE); (e) x512-Vokabular-Reserve NICHT baubar und ZURECHT fehlend: avx512er/pf/4vnniw/4fmaps (gcc 15.3 lehnt ab, KNL-Erbe) + avx512_bmm (erst GCC 16); (f) AVX10.1/10.2 fehlen ganz (Strukturbruch s. Eintrag 6); (g) apx 64-bit-exklusiv (EINZIGE harte 32-bit-Grenze: "-mapxf is not supported for 32-bit code"); AMX-Falle: gcc akzeptiert -mamx-tile auch unter -m32 -- Schalter-Akzeptanz ist KEIN Verfuegbarkeitsbeweis; (h) historische Vorgaenger bewusst NICHT empfohlen (mmx, 3dnow*, xop, fma4, tbm, lwp -- Zen strich sie 2017); EINE Ausnahme pruefen: 3dnowprefetch/-mprfchw als Software-Prefetch-Achse unmittelbar einschlaegig.
ORT: wa91q7g1p.result.katalog.fehlt_im_bestand[0..9]
SOLL/FIX: Aufnahme-Empfehlungen wie im Gegenstand; Baubarkeits-Messung: von 66 getesteten Schaltern 60 in BEIDEN Bitbreiten akzeptiert (gcc 15.3.0, -m32/-m64, headerfrei), 5 tot, 1 64-bit-only.
STATUS LT. QUELLE: offen (Katalog-Erweiterungs-Posten)
ABHAENGIGKEIT/FLAECHE: kFlagVoraussetzungsKetten; Eintrag 3 (Signaturfaehigkeit)

### [wa91q7g1p.json] 5
GEGENSTAND: Komposit-Tabelle/Synthese-Empfehlung: KLASSE A echte Companions (Breite FOLGT der Basis) = NUR gfni, vaes, vpclmulqdq (Test: EIN CPUID-Bit deckt mehrere Breiten; gfni Musterfall -- kein separates avx512-gfni-Bit; Owner-Notation ...{x512.f.vl.bw.dq}.gfni durch die ISA GEDECKT, "x512.gfni" IN der Klammer waere falsch; Aufloesungsregel: {x256...}.vaes = VEX.256, {x512.f}.vaes = EVEX.512, {x512.f.vl}.vaes = zusaetzlich EVEX.128/256). KLASSE B Skalare (keine Vektorbreite): popcnt, bmi1, bmi2, abm, movbe, adx, rdrand, rdseed -- eigenes Etikett scalar, NICHT mit A vermischen. SYNTHESE-KORREKTUR eines Lens-Widerspruchs: aes/pclmulqdq/sha sind x128 (nicht Companion) -- AESENC/SHA256RNDS2 kennen keine 256/512-Form unter ihrem Bit. ZWEI PHANTOME duerfen NICHT in den Katalog: tzcnt (kein eigenes CPUID-Bit, Feature-Spalte BMI1; dekodiert auf alten CPUs still als BSF -- "laeuft ist kein Beleg fuer unterstuetzt") und lzcnt (dasselbe Bit heisst abm; als eigener Token entstuende ein Eintrag, den kein Signatur-Matching je trifft). Grammatikregel: "{x512.f}.fma ist semantisch falsch bzw. redundant" (512-FMA kommt aus AVX512F); avx512vl ist der Bruecken-Token, der EVEX auf 128/256 herunterreicht.
ORT: wa91q7g1p.result.katalog.basen[0..2] + companion[0..10] + empfehlung
SOLL/FIX: Schreibweise-Vorschlag (Owner-Entscheid): "kurze Tokens NUR innerhalb der Klammer zulassen, Companions immer voll ausschreiben, und fuer x128 die Punkte tilgen (41/42 statt 4.1/4.2)."
STATUS LT. QUELLE: offen (Owner-Vorlage)
ABHAENGIGKEIT/FLAECHE: Flag-Grammatik v2; S2-Katalog-Wachen

### [wa91q7g1p.json] 6
GEGENSTAND: Owner-Entscheide der Notation (katalog.offen, nicht recherchierbar): (0) PUNKT-KOLLISION -- der Punkt ist Trenner der Komposit-Grammatik, steckt aber in -msse4.1/-msse4.2/-mavx10.1/-mavx10.2 (Vorschlag 41/42, avx10_1/avx101 = Setzung); (1) TOKEN-KOLLISIONEN vnni (x512 UND x256), ifma (x512 UND x256), "2" (sse2 UND avx2) -- in der Klammer disambiguiert die Basis, ausserhalb nicht; (2) STRIPPING-REGEL unvollstaendig (fuehrendes "v": vpopcntdq behaelt v, vpclmulqdq aus anderem Grund; sha_ni -> shani oder sha? g++-Flag -msha); (3) AVX10-STRUKTURBRUCH, Lens-Widerspruch NICHT aufloesbar: GCC aliast -mavx10.1 auf 512 bit (lokal bestaetigt, woertliche GCC-15.3-Warnung), MSVC-Primaerquelle sagt Default-Vektorlaenge 256 mit eigenem /vlen-Schalter -- DASSELBE Feature hat Basis x512 unter GCC und x256 unter MSVC; /arch:AVX512 /vlen=256 macht sogar klassisches AVX-512 zur 256-bit-Basis; "die Breite ist bei AVX10 KEINE Eigenschaft des Features mehr, sondern ein separater Compiler-Schalter" -- Owner-Entscheidung mit Messfolgen; (4) VEKTORLAENGEN-AGNOSTISCHE ISA: ARM SVE (-msve-vector-bits={scalable,...}) und RISC-V RVV (Zvl*-Extensions + vlenb-CSR) entkoppeln Breite und Featureset wie AVX10 -- tragfaehiges Muster: Basis-Slot muss Wert "scalable" aufnehmen koennen UND Breite eigener expliziter Slot; OB umgebaut wird = Owner.
ORT: wa91q7g1p.result.katalog.offen[0..4]
SOLL/FIX: je Punkt Owner-Vorlage; keine stille Setzung.
STATUS LT. QUELLE: offen (Owner-Entscheide)
ABHAENGIGKEIT/FLAECHE: Grammatik-Design G-2/S-2; Stempel-Preimage

### [wa91q7g1p.json] 7
GEGENSTAND: Nicht-x86-Zustand des Projekts (Code-Befund): Aarch64TargetIsa existiert als System-Achse (target_isa_system_axis.hpp), emittiert aber NUR do_target_march() == "-march=armv8-a" ohne NEON/SVE/SVE2-Modifier; kAllSimdIds in simd_sub_axis.hpp = {no_extension, avx2, avx512} (reines x86-Vokabular); "Ziel != x86_64 => avx*/cx16 degradieren"; fuer aarch64 kann die Grammatik heute AUSSCHLIESSLICH no_extension ausdruecken. Realer Messpark rein x86-64 (prod1 Zen5, prod2 Raptor Lake, odroid Gracemont -- alle drei in machine_simd_signature.hpp). Ob ARM/RISC-V in den Flag-Katalog sollen: offen (Owner).
ORT: ce target_isa_system_axis.hpp; simd_sub_axis.hpp; machine_simd_signature.hpp
SOLL/FIX: Owner-Entscheid; ARM-Flanke zusaetzlich offen: ARM-Feature-Namen sind LINUX-hwcap-Namen (BETRIEBSSYSTEM-Quelle), x86 hat mit CPUID eine ISA-Quelle -- Asymmetrie fuer plattformneutrale Grammatik.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: target_isa-System-Kanal (heute leer, s. golden-Plan E-5-Umfeld)

### [wa91q7g1p.json] 8
GEGENSTAND: 32-bit-Antwort (Auftragspunkt 5): x128 ist fuer DIESES Projekt heute Reserve, aber NICHT wegen 32-bit: (a) MSVC-Default fuer 32-bit ist SSE2, x86-Liste offiziell bis AVX10.2; (b) 32-bit begrenzt NICHT die Breite sondern die ANZAHL der Register (selbst gemessen: gcc -m32 -mavx512f erzeugt echtes EVEX mit zmm0, aber nur bis zmm7; -m64 bis zmm19+; xmm8-Clobber unter -m32 abgelehnt) -- die 32/64-Achse ist ORTHOGONAL zur Breiten-Achse; (c) das Repo hat KEIN einziges 32-bit-Ziel (jeder -m32/i686/i386-Treffer liegt in vendored ext/-Fremdcode: liburing, unodb, jemalloc). VERBLEIBENDE OWNER-KERN-LUECKE (keine der 5 Lenses konnte es belegen): ob 32-bit-Windows-10 die AVX-512-XSAVE-Zustaende (XCR0 Bits 5/6/7) freischaltet -- braucht Messung auf echter 32-bit-Windows-10-Installation oder Microsoft-Primaerquelle; ohne OS-Freigabe meldet CPUID die Flags, die Instruktion stirbt mit #UD. Indien-Verbreitung 32-bit-Win10 nicht quantifizierbar (Statcounter schluesselt nach Version, nicht Bitbreite; Steam-Survey fuehrt keinen 32-bit-Eintrag mehr, aber Gamer-Stichprobe nicht repraesentativ).
ORT: wa91q7g1p.result.katalog.offen[6..7]; lenses[0].luecken[10], lenses[1].luecken[1], lenses[2].luecken[2..3]
SOLL/FIX: vor "x512 fuer Windows-32-bit lieferbar"-Erklaerung Messung/Primaerquelle; Owner-Aussage "In Indien ist 32bit noch aktuell" bleibt unbestaetigt UND unwiderlegt.
STATUS LT. QUELLE: offen (einzige verbliebene echte Unsicherheit der 32-bit-Frage)
ABHAENGIGKEIT/FLAECHE: Owner-Frage

### [wa91q7g1p.json] 9
GEGENSTAND: Quellen-Restzweifel (Quittungen mit Vorbehalt, vor Code-Zementierung zu schliessen): (a) Intel SDM und AMD APM NIE als PDF-Primaerquelle gelesen -- fuer die 3 gewichtigsten Aussagen (Companion-Einordnung gfni/vaes/vpclmulqdq, Breitenfestigkeit aes/sha, AVX10-Leaf-0x24-Struktur) "waere die Primaerquelle vor der Zementierung im Code angezeigt"; AVX10.2-Spec heruntergeladen aber auf der Maschine NICHT lesbar (kein pdftotext/mutool/pypdf; intel.com HTTP 403); (b) cpuinfo-Strings fuer sha512/sm3/sm4 im Kernel-Header nur als Makronamen -- realen /proc/cpuinfo-String an echter Maschine verifizieren, BEVOR er Signatur-Schluessel wird; (c) f16c/fma bit32 nur aus VEX-Regel abgeleitet -- beide Instruktionsseiten direkt lesen; (d) fma4/xop/tbm/lwp bit32 bewusst weggelassen statt geraten; (e) XOP-Basis x128 Naeherung; (f) MOVBE-Atom-2008 nicht uebernommen (unbelegt); (g) "Zen-Dekoder verarbeiten FMA4 noch trotz CPUID-aus" unbestaetigt; (h) AVX-512-Registeranzahl im 32-bit-Modus (nur zmm0-7, EVEX.R'/V' brauchen Long Mode) -- "fuer die Owner-Frage die wichtigste Einzelaussage ueberhaupt", vor Verwendung gegen SDM Vol.1 Kap. 15 pruefen; (i) EIGENER MESSFEHLER offengelegt: -m32-Tests mit libc-Headern auf dieser Maschine ungueltig (gcc-multilib fehlt) -- Lens-3-AMX-Beleg nicht reproduzierbar, AMX-32-bit-Nichtverfuegbarkeit UNBELEGT (nur SDM-Spalte V/N.E. fuer LDTILECFG); mit gcc-multilib nachpruefen; (j) MSVC/ICX-Flag-Namen nicht erhoben (Katalog behandelt gpp/clang als deckungsgleich -- fuer neue Flags unverifiziert); (k) ob eine der 8 Docker-Matrix-Distributionen noch ein 32-bit-Image anbietet: unbelegt (Ubuntu i386 ab 19.10 weg, Arch i686 ab 2017, Debian 13 ohne i386-Kernel).
ORT: lenses[0..4].luecken; katalog.offen[8..9]
SOLL/FIX: Liste als Verifikations-Auflagen an den Katalog-Erweiterungs-Task haengen.
STATUS LT. QUELLE: nur-hinweis (deklarierte Restzweifel)
ABHAENGIGKEIT/FLAECHE: Katalog-Erweiterung; Unterstrich-Falle-Doku (sse4_1 vs -msse4.1)

---

### [wktkhd1cj.json] 1
GEGENSTAND: 80-Seiten-Gesamt-Dossier der Session 5a19728e (12 Agenten; persistiert als docs/sessions/20260806-GESAMTDOSSIER-session-architektur-und-befunde.md, 2991 Z./321.109 B) -- Stand 06./07.08.; drei Kapitel-Widersprueche als Abschnitt 0 nachgemessen: W-1 Anhang-A-Zaehler 28 vs 30 (beide korrekt, Zaehlmethode fehlte; verbindlich 28), W-2 Referenz-Staende bba4d90f vs c4c04315 (8 Minuten Versatz; ZUSATZ-Fehl-Label: 71591a24 ist super origin/MAIN, nicht development), W-3 Mess-Kette Ebene 2 "gebaut" vs "fehlt" -- Ursache ZWEI Owner-Saetze 6m53s auseinander (23:20:06Z "ueber die Schritte und checkpoints" vs 23:26:59Z "fuer jeden Funktionsaufruf"); NIEMAND hat entschieden, welcher das Abnahmekriterium ist -> NEUER Owner-Entscheid W-3 (Fenster vor Freitag 3; nur die strenge Lesart traegt Break-Even auf Achsen-Ebene und damit H2). Nebenbefund: Checkheft-Posten N-AD (beide Hauptklone auf fremden Wellen-Branches: super 18a0bdf3, ce 90bca126) ist nachweislich MESSFEHLER-QUELLE (Kapitel V mass gegen den Arbeitsbaum auf 90bca126).
ORT: super docs/sessions/20260806-GESAMTDOSSIER-session-architektur-und-befunde.md
SOLL/FIX: W-3 als Owner-Entscheid einreihen; N-AD beheben (Hauptklone zurueck auf Haupt-Branches).
STATUS LT. QUELLE: offen (W-3 Owner; N-AD)
ABHAENGIGKEIT/FLAECHE: Break-Even/H2; alle Messungen aus Hauptklonen

### [wktkhd1cj.json] 2
GEGENSTAND: Verdikt 1 (20 Stichproben hart nachgemessen, 07.08. 01:00-01:15Z): 14 exakt, 6 falsch/nicht reproduzierbar -- ALLE 6 sind ANKER-Fehler, keine Sachfehler; 3 sitzen an Bau-Ankern der naechsten Handlung: F-1 seg_ns=326 ist auf KEINEM Ref erreichbar (korrekt 308 Zeilen/368 Vorkommen; Abschnitt 0 sprach den Zaehl-Widerspruch frei OHNE die zweite Zahl zu messen -- Satz "beide Zahlen sind richtig" streichen, durch Liste ersetzen); F-2 m3v2_pmc_smoke.cpp-Zitate sind einen Commit alt (Stand VOR der Heilung 06.08. 22:16; das Paar steht an :62/:69, die [PMC-FEHLER]-Liste an :124-125; :12 sagt heute das GEGENTEIL -- R-11-Anker); F-3 allow_failure: true steht NICHT an experiment_plan_director.hpp:1333 sondern :1373 (Doktrin-Begruendung :1372; :1332-1333 ist Kommentar zum Paragraph-62-B-Mess-BATCH) -- das ist der Anker fuer Owner-Entscheid D-4; F-4 ungeslictes [0:COMDARE_GN_TOTAL)-Fenster steht an :631/:1024/:1187, nicht :1367-1369; F-5 Anhang-A.4-Landkarte: 3 von 18 ce-Pfaden verlieren das Segment include/cache_engine/ (axis_error.hpp, pmc_source.hpp -- NICHT builder/, anatomy_fingerprint.hpp); F-6 pmc_source.hpp Flag-Spanne korrekt :37-43 (nicht :36-42; energy an :43); F-7 Gegenprobe swisstable = 11 Dateien, nicht 5 (Verdikt F-02 "FEHLT" bleibt; flat_hash_map in ext/: 21 Dateien/82 Zeilen, nicht "zehnmal"); F-8 "104 von 265 result-Ereignissen" unerreichbar (real 100/266 bzw. 92/257); F-9 kMeasurementToolingCount=3 an :34, Registry-Tabelle :46-:50; F-10 Erstellungsfenster liegt 66 min in der Zukunft; F-11 wc -l=105 vs 106 (Datei ohne End-Newline).
ORT: wktkhd1cj.result.verdikte[0]; Refs ce c4c04315/bba4d90f/2b5ecd29, super 5a98036d/71591a24, thesis 19e15920
SOLL/FIX: "Vor dem naechsten Aufschlagen sind F-1, F-3 und F-2 zu korrigieren -- sie stehen an den drei Stellen, die als naechste Handlung gelesen werden. F-5/F-6 Zwei-Minuten-Korrekturen. F-8 und F-1 nicht korrigieren, sondern durch die Liste ersetzen."
STATUS LT. QUELLE: offen (Dossier-Korrekturen)
ABHAENGIGKEIT/FLAECHE: D-4-Owner-Entscheid; R-11; i-3-Bau-Anker (allow_failure :1373)

### [wktkhd1cj.json] 3
GEGENSTAND: Verdikt 2 (Transkript-Treue des Kapitels VI): kein Owner-Satz erfunden, kein Zeitstempel falsch -- ABER 4 schwere Defekte: A-1 KERN 1 ohne Ellipse abgeschnitten -- es fehlt die vorbehaltlose Ratifizierung 'Uebernimm "Das schliesst den Kreis" vorbehaltslos' (live 7601, 23:10:06Z; "schliesst den Kreis" = 0 Treffer im Dossier); A-2 KERN 12 abgeschnitten -- es fehlt der URSPRUNGSAUFTRAG der Wellen-Kette ("Bitte starte nochmal einen ultracode workflow ... mit Fable 5 xhigh ein Dossier ... konsolidiert", live 7761); A-3 ZWEI Owner-Nachrichten fehlen vollstaendig: live 7989 23:55:46Z "fahre statt Fable 5 besser Opus 5 max effort" (Werkzeugwahl-Aufhebung) und live 6539 21:07:21Z "Bitte kippe ALLE workflow ergebnisse aus dem letzten Kontext in diesen Kontext hinein, sonst koennen wir nicht arbeiten"; A-4 Z.942 leitet einen Owner-Entscheid aus GEKUERZTEM Zitat ab -- der Owner nennt "Berechnung" ausdruecklich (best_binary_selector: "...die Orchestration der Auswahl und Berechnung ueber das Lager durchfuehren", live 7889) -- das Dossier traegt den vollen Wortlaut selbst bei N-14 und widerspricht sich. MITTEL: B-1 fuenf live-Fundstellen zeigen ins Nichts (korrekte: 7235, 6978-6996, 7026/7033, 7042, 7048/7052); B-2 KERN 7 Beauftragungssatz fuer PLAN-warnungen-und-ausgabe-bei-messfehlern.md gekappt; B-3 N-16 mitten im Satz gekappt (Kriterium ist konjunktiv: "nicht gefunden UND nicht beantworten kannst"); B-8 verbindlich "43 von 106"; B-9 Zaehlung 34/14/20 reproduziert nicht (real 24/14/10), ABER Schluss STAERKER als behauptet: kanonischer Filter findet 0 von 8 KERNen -- alle acht liegen NUR als queue-operation vor (gehoert als W-4 in Abschnitt 0). KLEIN: C-1..C-10 (Details in Quelle). Quellen-Befund E: der in Kapitel VI genannte Transkript-Pfad ist aus dem Hauptklon nicht zu oeffnen (HEAD auf 18a0bdf3) -- N-AD trifft auch den Zitat-Apparat.
ORT: wktkhd1cj.result.verdikte[1]; Transkripte backups-workflow/20260806-session-transkript/... (3847 Z., md5 0c317851...) + 5a19728e-...jsonl
SOLL/FIX: "A-1 bis A-4 und B-1 bis B-4 vor jeder Weiterverwendung korrigieren -- acht punktuelle Textaenderungen"; B-9 als W-4 einreihen.
STATUS LT. QUELLE: offen (Dossier-Korrekturen)
ABHAENGIGKEIT/FLAECHE: Extraktor-Doktrin (queue-operation-UNION, deckt Memory-Eintrag DREI PFADE)

### [wktkhd1cj.json] 4
GEGENSTAND: Verdikt 3 (Vollstaendigkeit): NICHT VOLLSTAENDIG -- unterschlagene Befunde: A-1 R-3 "Fingerprint traegt die Mess-Defines nicht" (COMDARE_MEASUREMENT_ON ABI-wirksam => Release-Nachmessung erzeugt andere Binary mit IDENTISCHEM Fingerprint; dll_is_current = genau ein Vergleich => STILLER FALSCH-SKIP; heute 0 .fingerprint-Sidecars => Fix kostenlos, danach 34,4 h Neubau; nachgemessen an ce 54106bc9: Mess-Defines in anatomy_fingerprint.hpp+toolchain_stamp_glied.hpp = 0 Treffer, M-1 hat das NICHT geschlossen; Dossier-Satz "der einzige offene Punkt, der das Fingerprint-Fenster beruehrt" FALSCH -- es sind ZWEI: D-1 PMU-Domaene UND R-3); A-2 SW-5/E-14 active_telemetry_is_silent() liefert literal false ("return false; // Default = Active", profile_run_facade.cpp:240, einziger Aufrufer :505) waehrend ELF Thesis-Profile silent="true" deklarieren (u.a. all_axes_golden.profile.xml:127) -- "die XML sagt silent, gemessen wird Active"; golden-brechend, braucht GOLDEN-UPDATE-Fenster; A-3 die dritte Fehlerklasse "WENN DIE HEILUNG NEBEN DIE WUNDE TRIFFT" (H-1..H-7; H-4 Kollisions-Eimer ohne-anker, H-6 PlanFach::offen erhoben-persistiert-verworfen, H-7 Fassaden-Test) fehlt komplett + Anhang nennt SW-1..SW-4 statt SW-1..SW-6; A-4 Checkheft VII.5 "Drei Gestalten deckt die These nicht" (tautologische Messung; korrekt-aber-verfallen; zwei Schreiber) gestrichen -- Kapitel III behauptet faelschlich EINE Gestalt als vollstaendige Typologie; Merksatz erweitert: "Gruen ist keine Aussage ueber den Pruefbereich -- und kein Gruen ist eine Aussage ueber den Zeitpunkt, den Pruefer oder die Gelegenheit zu beissen."; A-5 ObservableTier-Vertrag (Owner-KERN): abi_adapter.hpp:393 "#if COMDARE_MEASUREMENT_ON" entscheidet, ob der ABI-Adapter IObservableTier/IMeasurableWorkload/V2/V3 ueberhaupt erbt -- "Was gemessen werden kann, entscheidet heute eine CMake-Option, nicht die Mess-Achse"; Owner: Vertrag ist KERN-Achse, zu korrigieren ist die ORCHESTRIERUNG, nicht das Interface.
ORT: wktkhd1cj.result.verdikte[2] A-1..A-5; ce profile_run_facade.cpp:240/:505; abi_adapter.hpp:393
SOLL/FIX: Nachtrags-Liste D des Verdikts (7 Punkte, s. Eintrag 6).
STATUS LT. QUELLE: offen (unterschlagene Befunde reaktivieren)
ABHAENGIGKEIT/FLAECHE: Fingerprint-Fenster (vor der ersten .fingerprint-Datei); GOLDEN-UPDATE-Fenster; Mess-Achsen-Orchestrierung

### [wktkhd1cj.json] 5
GEGENSTAND: Verdikt 3 Fortsetzung -- weitere unterschlagene Sperr-/Einzel-Befunde: A-6 halbierte Sperrposten: (a) run_options cap="131072" build_version="golden_kern" -- EIN Element traegt Mess-Obergrenze UND Bau-Identitaet ("eine Mess-Aenderung kann eine Bau-Identitaet mitverschieben, ohne dass es jemand als Neubau liest"); (b) DREI eingecheckte allow_failure PLUS einer emittiert, darunter super .gitlab-ci.yml:1344 ergebnis:holen = der Job, der die Mess-CSVs einsammelt (im Dossier 0 Treffer); (c) DREI SPERREN am fail-closed-Umbau: fail-closed NUR ueber kPmcExpected-Praedikat, NIE durch Ruecknahme von "|| counters_all_zero"; m3v2_pmc_smoke.cpp:71 NICHT anfassen; Inversionsfix vom 13.07. NICHT zuruecknehmen -- ein Bauauftrag nach D-5 ohne diese Sperren kann den 13.07.-Fix rueckbauen; A-7 320er-Grundlage bestritten: 304 der 320 Mess-Binaries liegen AUSSERHALB des gebauten 2^17-Raums (nur 16 drin) => Fingerprint-KERN traegt fuer ~95% der Mess-Zeilen nicht; Empfehlung additiv: alte 320 als m3v2_study unangetastet, NEUE golden_kern_320.profile.xml als echte Teilmenge; Dossier-D-3/04.09.-Messlauf traegt den Vorbehalt NICHT; A-8 Einzelbefunde je 0 Treffer: bytes_in_use_peak falsch etikettiert (axis_stats[6][1] Momentanwert als "ECHT aus Observer"); ns_per_op im Workload-Pfad EXAKT HALBIERT (total_ns/(2*n_ops), 120.960 Zeilen betroffen -- y-Achse jeder Break-Even-Kurve); SW-6/E-15 COMDARE_LEGACY_MESSREIHEN nur in EINEM von zwei Repos gemessen (Gate lebt in super main.cpp:701,718,1372; erzeugt R-7 "Ein Gate-Umfang ist repo-spezifisch"); D-6 all_axes_golden.profile.xml NICHT wohlgeformt ("--" in Kommentaren Z.62/64/207; libxml2 lehnt ab, alte Regex-Wache lief GRUEN; Interim PROFILE_ALLOW_COMMENT_TEXT_DEFECT=ON schlaegt nach ce-Fix FATAL um); D-15 gitleaks 89 Funde bei EXIT 0 (vierte stille Null); E-5 G-E3 Host-Binder fehlt -- Messwert->Lager-Verdrahtung existiert nicht, Schreiber dcbaa728 toter Code, P2 VOR Messbeginn; B-9 observer_detail skaliert nicht (~97 LaTeX-Zeilen je Messzeile, im Voll-Lauf unbaubar); C-5/C-7/C-9 xlsx/B12 = 0 Zeilen Code bei Owner-Terminierung "vor der Messung, mit in die Abgabe" + pruefling_type durchgaengig "-" (keine std::map-Baseline-Zeile) + Schema-Versatz 173 vs >=174 Spalten; G-8/G-9 zwei Wellen an der Kostenklammer verloren ohne Bericht (result.bau = null), drei doppelt belegte Worktrees, Snapshots nur in /tmp; F-2 der Scrub vom 02.08. hat den LEAK-COMMIT NICHT ERFASST -- Re-Scan aller 4 Klone + thesis fehlt; seg_ns-Deklarations-Drift: measurable_workload.hpp:101 seg_ns[18] vs :87 Kommentar seg_ns[17] vs static_assert-Texte :118/:120 "17-Segment"; lebende Namenskollision phase=bau|pruef|mess vs Dossier-Definition "Phase = Kettenposition" (Vorschlag Rename schritt=, CSV-/Marker-wirksam, abstimmungspflichtig).
ORT: wktkhd1cj.result.verdikte[2] A-6..A-8; Zeilen s. Gegenstand
SOLL/FIX: als eigene Zeilen in die offene-Posten-Liste einreihen (Nachtrag D2 des Verdikts).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: PMC-Welle (Sperren!); GOLDEN-Fenster; 320er-Messlauf; B12/xlsx; Scrub-Reste

### [wktkhd1cj.json] 6
GEGENSTAND: Verdikt 3 -- V.6 nennt sich "vollstaendige Sammlung" und verliert 14+ Paragraph-J-Kennungen (je 0 Treffer): R-3, O-4/F8 Fingerprint-Uebertragbarkeit, N-1/O-C COMDARE_BESTANDSLOG, N-2 USER-GO 320er nie erteilt, R-6 Ebene-B-Push, E-1..E-5 GOLDEN-UPDATE-Fenster, E-A..E-F Versionierungs-Interface (6 Vorlagen), E2/E3/E9, OF-M3-1/-2, DV-3, O-2/O-4 Anhang-A-Reichweite, xlsx-in-die-Abgabe, search_algo-Pin, PMC-Flagwechsel-Neubaufenster, zweites Churn-Leck. ZWEI wiegen schwer, weil sie Kapitel I direkt widersprechen: E11 "Phasen-Kardinalitaet ==3 ist laut Owner komplett falsch -- blockiert S4 seit 16.07." (Dossier setzt genau 3 als "Nicht dehnbar" fest) und Q6 "Hybrid = Stufe gegen Systemachse" (offener Owner-Entscheid, den I.3.5/I.8 als erledigt darstellen). A-10: die 0-Sidecar-Zahl wird NUR als Entlastung gelesen -- die Quelle sagt: Provider opt-in ueber COMDARE_BESTANDSLOG, nur in 2 Tests gesetzt => "Resume existiert nicht, jeder Lauf baut alle 131.072 Binaries neu"; Owner-Entscheid N-1/O-C Provider Pflicht; ACHTUNG Kopplung: E-2 wird scharf, sobald das repariert wird -- beide in DERSELBEN Welle landen.
ORT: wktkhd1cj.result.verdikte[2] A-9/A-10
SOLL/FIX: Nachtrag D5: V.6 um die 14 Kennungen ergaenzen, E11 und Q6 ausdruecklich gegen I.3.5 stellen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: E11/Q6 vs Dossier-Architektur-Kapitel; N-1/O-C+E-2-Kopplung

### [wktkhd1cj.json] 7
GEGENSTAND: Verdikt 3 Teil B -- als OFFEN gefuehrt obwohl ERLEDIGT (Stand 07.08. 00:50): B-1 S-1 (ce-main-FF + super-Gitlink-Bump + super-main-FF) war um 00:40:56Z geschlossen (ce origin/development=origin/main=54106bc9, Bump cabba179, super main 2871fabf) -- Rest nur super development dd107862 einen Doku-Commit vor main; B-2 S-3 drei Plandokumente WAREN versioniert (super 1aba34f8, 00:30:30Z: "drei Wellen-Dokumente sichern, die auf KEINEM Zweig lagen") -- damit auch Freitag-1-Auflage V.5.4/(4) ueberholt; Nebenbefund: Ueberschrift "vier Bestaende", Tabelle hat FUENF Zeilen; WEITER KORREKT OFFEN (07.08. verifiziert): S-2 (experiment_schema.xsd modifiziert, kein Commit), S-4 (Code/measure_out_d03: 66 Dateien/3.651.143 B, git log --all = 0 -- Rohmessdaten ohne jede Sicherung), S-5/N-AD (super HEAD 18a0bdf3, ce HEAD 90bca126); B-3 rote M-1-Pipeline fehlt in der Landungsbilanz -- ce fe5f9e7c/54106bc9 "Merge b-m1h-ci-heal: die rote M-1-Pipeline heilen -- lint:format whole-file + falsches pmc-Label" 00:34:58Z; die Pipeline zu c4c04315 WAR ROT, B-1 schickt den Leser auf genau diesen Commit; B-4 V-08 steht unter "Entlastungen", obwohl W-19 es ausdruecklich verbietet ("Das Register fuehrt V-08 als erledigt, obwohl es am Objekt widerlegt ist ... Wer das Register liest statt den Audit, haelt M-3 fuer erledigt") -- korrekt: teilwiderlegt, gehoert zu M-3a; B-5 V.1.3/V.5.4 ordnen die Buchung der 23 Paragraph-63-T-Zeilen + 8 V-09a-Zeilen in die SSOT an, obwohl Paragraph-63-T-15 im Schwester-Dokument (Wallclock-Dossier :388) als WIDERLEGT gefuehrt wird ("am Datensatz widerlegt (16/16 gefuellt); stehen bleibt nur seg_persistence_target_ns = 0/16 (T17)") -- der Auftrag bucht eine widerlegte Zeile.
ORT: wktkhd1cj.result.verdikte[2] B-1..B-5
SOLL/FIX: Nachtrag D7: IV.5.1 neu erheben (S-1/S-3 ERLEDIGT); IV.1 um 54106bc9 ergaenzen; V-08 zu M-3a verschieben; Paragraph-63-T-15-Vorbehalt in V.1.3/V.5.4 setzen.
STATUS LT. QUELLE: teilweise (2 von 5 SOFORT-Posten vollzogen; S-2/S-4/S-5 offen)
ABHAENGIGKEIT/FLAECHE: Ledger-SSOT-Buchung; Rohmessdaten-Sicherung S-4

### [wktkhd1cj.json] 8
GEGENSTAND: Bau-Stand 06./07.08. (bestand[1]) -- ungelandete Substanz: NUR noch (1) E-18-SNAP super b-e18-snap (3 Commits ahead, wt-b-e18snap; ci/anhang_forward_core.sh 18.503 B auf development vs 83.951 B auf Zweig, +2673/-37; Codex-NICHT-LANDEN-Verdikt mit Pruefgrenze "kein Shell-Exec"; offene Punkte: Patch landen, .gitignore-Negation, COMDARE_TEXLIVE_AVAILABLE=true noetig sonst baut auto nichts, Repo-Wachstum 1-5 MB/Lauf, PENDING-*.txt-Politik, falsche AF_SNAPSHOT_ROOT jetzt rot; 3 rescue-Refs beidseitig); (2) OD-11-RT numa_process_probe ce b-numa-process-probe b4cebdc4 (1 ahead, 18 Dateien +2800/-33, test_od11 841 Z. neu) = Unter-Achse core_class (Owner-KERN 06.08.) -- EIN PAKET, ZWEI REPOS: die super-Haelfte (experiment_schema.xsd +24 Z., xs:element core_class, offener xs:string statt Enum; Namensfalle scheduling/hetero_core_dispatch=CT-POLICY vs core_class=RT-FAKTUM) liegt UNCOMMITTET im Hauptklon-Arbeitsbaum, KEIN rescue-Ref -- "Wenn jemand den Hauptklon zuruecksetzt, ist die super-Haelfte weg"; (3) PMC-L3-Ehrlichmachung NUR als WIP-Patch (backups-workflow/20260806-pause-wip/pmc-l3-honest-WIP.patch, 18.294 B, identisch 5 dirty Dateien in wt-pmc-l3-honest @ 2b5ecd29; +136/-13) -- Owner-Auftrag "wt-pmc-l3-honest NICHT aufraeumen" gilt weiter; Patch-Selbstkorrektur verbatim: Zusage "PmcCounters ERHEBT branch_misses real" war FALSCH -- Spalte traegt IMMER Default 0, offener Posten M-3a; Sachgehalt: 4 der 7 PMC-Zellen (l2,l3,coherence,energy) nur mit eigenem Quellen-Flag fuellen, sonst SourceUnavailable/n-a statt erfundener 0.
ORT: wt-b-e18snap; wt-numa-process (b4cebdc4); wt-pmc-l3-honest + backups-workflow/20260806-pause-wip/
SOLL/FIX: drei Landungs-/Sicherungs-Posten; super-Haelfte von core_class ZUERST committen/sichern.
STATUS LT. QUELLE: offen (Stand 07.08.; gegen 13.08.-Staende abgleichen)
ABHAENGIGKEIT/FLAECHE: experiment_schema.xsd (Merge-Flaeche, auch S-2-Posten); PMC-Welle; GOLDEN-Fenster (E-14)

### [wktkhd1cj.json] 9
GEGENSTAND: Rohmessdaten ohne jede Sicherung (NS-2-Rest): Code/measure_out_d03/ = 66 Dateien / 3.651.143 Byte, untracked; find backups-workflow -iname 'measure_out_d03*' = 0; git log --all = 0 Commits; .gitignore:39 "*.csv" verschluckt sie STRUKTURELL (Negationen nur measurement/** und Code/**/tests/fixtures/**) -- der Owner-KERN "Messdaten nie loeschen" hat hier KEIN Netz. Ebenfalls offen (Stand 07.08.): 3 Plandokumente 2433 Z. (lt. Verdikt 3 B-2 am 07.08. 00:30 als 1aba34f8 GELANDET -- Widerspruch zugunsten Verdikt 3 aufgeloest, measure_out_d03 und .gitignore-Negation blieben offen).
ORT: super Code/measure_out_d03/; .gitignore:39/:43/:46
SOLL/FIX: Rohdaten additiv sichern + .csv-Negation fuer Messpfade ergaenzen (BU-additiv-Doktrin).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Backup-Doktrin; Mess-Pfad-gitignore

### [wktkhd1cj.json] 10
GEGENSTAND: Branch-/Worktree-/Refs-Inventar (Stand 07.08.): 32/32 ce-SHAs + 15/18 super-SHAs der "ungelandet"-Liste GELANDET (Liste zu 94% ueberholt); ce rescue-Refs 18/18 gelandet, super 8 (nur die 3 E18-SNAP-Refs ungelandet); Karteileichen-Branches w2-* vom 02.08. (inhaltlich ueber W5/W3-Vereinigung 124711ed/7969b399 eingegangen, SHAs nicht); b-m2-pmc-invariante/b-m3v2-pmc-window/b-pmc-errno-diag inhaltsgleich gelandet (als 8894d983/2b5ecd29/22e17f57); 23 Worktrees alle sauber ausser wt-pmc-l3-honest (5 dirty); wt-landcheck ist KEIN git-Repo (Leiche); BEIDE Hauptklone auf Arbeitszweigen (super b-ci-rueckschrieb-beide-zeiger, ce b-m2-pmc-invariante; super lokaler main 425 zurueck) = NS-3 offen; Empirischer Nenner zu R-9: 13 von 18 ce-rescue-Refs waren ROT (Vor-Format-Nachzug-Schnappschuesse), alle inhaltlich korrekt -- "eine rescue-Ref ist keine Landung".
ORT: bestand[1] II.5-II.8
SOLL/FIX: NS-3 heilen; wt-landcheck entfernen (nach Pruefung); 21 von 84 Live-Journalen sind NUR live vorhanden (Repo-Sicherung deckt 63) -- sichern.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Worktree-Lebenszyklus-Doktrin; Journal-Backups

### [wktkhd1cj.json] 11
GEGENSTAND: Pipeline-Lage 06.08. (251 Laeufe: 229 gruen/21 rot/1 laufend): ALLE 5 super-Roten = lint:format (kein einziger Bau-/Testfehler); 13 von 16 ce-Roten = rescue-Ref-Format-Schnappschuesse; 3 echte: 15022 (geheilt), 15104 8894d983 pmc:intel+test:coverage-guard (Diff-Hygiene-Wache ERSTER ECHTER BISS: ">120-SPALTEN CMakeLists.txt:82 (127 Byte)", Nenner literal "362 Zusatzzeilen ... davon 1 ueber 120 Spalten"), 15110 pmc:intel rot. pmc:intel-Befund (wertvollstes Pipeline-Ergebnis): NICHT allow_failure; die PMC-Invariante machte den Smoke rot, 2b5ecd29 heilte; Intel-Trace literal: l1=6701028, l2=0, l3=4048837, dtlb=3314004, coherence=0, energy=0, "SMOKE_OK (live PMC, >=1 counter populated)" -- DREI von sechs Zaehlern auch auf Intel-mit-perf still 0, Smoke besteht trotzdem (Kriterium >=1 populated) = harter Beleg fuer WIP-Patch und "Messung korrekt, falsche Frage". Gruen-Aussagen-Falle: Lauf 15130 (development-Kopf 71591a24) fuhr NUR 3 von 14 Jobs (rules:changes, reiner Doku-Commit) -- die Gruen-Aussage steht auf 15128 (14/14) + 15131, nicht auf 15130.
ORT: bestand[1] IV; GitLab-Pipelines 14817..15135
SOLL/FIX: Smoke-Kriterium auf per-Zaehler-Flags verengen (Aufgabe #26 / kPmcExpected, MIT den drei Sperren aus Verdikt-3 A-6); Doku-Commit-Laeufe nie als Vollbeweis werten.
STATUS LT. QUELLE: teilweise (Stand 07.08.)
ABHAENGIGKEIT/FLAECHE: PMC-Welle; EIN-GRUENES-GATE-Doktrin

### [wktkhd1cj.json] 12
GEGENSTAND: Widersprueche beim Messen (bestand[1] V): (1) der VIERTE Klon ist stale -- Research/20260931-overleaf-diplomarbeit auf 29a1700d (03.08.), 19e1592 dort nicht vorhanden; Agent, der die Thesis ueber den Standalone-Klon prueft, misst 4 Tage alten Stand (Owner-Regel "4 Klone in Sync" verletzt; Lesefallen-Risiko); (2) UEBERBLICK Paragraph 3.1 Gitlink-Aussage dreimal ueberholt; (3) Journal-Vollstaendigkeitszusage "genau b-a1-wurf-vertrag und b-e18-snap ungelandet" war korrekt zum Erhebungszeitpunkt, heute 5 neue ce-Zweige (R-18-Musterfall: Befund traegt Erhebungsdatum); (4) Checkheft-Tabelle 0.3 traegt Nachtrag "Jede Zeile ueberholt", dessen Zahlen ihrerseits ueberholt sind -- SECHSTE Auspraegung der main-hinter-development-Klasse an einem Tag; (5) Trigger auf branch: main (super .gitlab-ci.yml:297-315: trigger:cache-engine, trigger:prt-art, trigger:thesis) -- "Zeitbombe heute Nacht live scharf": jeder super-Lauf prueft ce OHNE M-1; Z-2/D-2 OFFEN.
ORT: bestand[1] V + III.4
SOLL/FIX: Klon-Sync; Trigger-Zielzweig-Entscheid (R2-Widerspruch, s.a. wwbu56lus Eintrag 13); C-1(b) Zaehl-Gate fuer Anhang A im thesis:pdf-Job fehlt weiter; Z-8: 28 Eintraege / 0 existierende Zieldateien (eingebunden sind 3D-Varianten, vorhanden nur 2D) -- Abbildungen fehlen.
STATUS LT. QUELLE: offen (Stand 07.08.)
ABHAENGIGKEIT/FLAECHE: Trigger-Branch-Politik; Thesis-Anhang

### [wktkhd1cj.json] 13
GEGENSTAND: Kapitel I.10 -- offene Architektur-Punkte, die NUR der Owner entscheiden kann: (1) PMU-Domaene (P-/E-Kern-Klasse) in die Mess-IDENTITAET? (Reproduzierbarkeits-KERN "identische Ergebnisse uneingeschraenkt" vs zwei Kerne derselben Maschine mit verschiedenen Zaehlern; binary_id="never" schliesst Neubau aus, Frage der MESSZEILEN-Identitaet bleibt; FENSTERKRITISCH: heute 0 h, nach erstem Batch Neubau + alle Messdaten); (2) "Drittes Glied" -- Stempel-Glied [3] oder drittes Kettenglied? (Rekonstruktion unbelegt); (3) M-1-Zuordnung wallclock->nur G1 widerspricht dem KERN und ist am Objekt widerlegt (I.7.5); (4) Ebene 2 "AUF dem Pruefdock" -- wandert der Messpunkt dorthin oder TESTIERT das Dock nur (pruef_dock.hpp:74-79 erlaubt beide Lesarten); (5) Verortungs-Zeile (live 7776) im Ledger nicht nachgetragen.
ORT: wktkhd1cj kapitel[0] I.10
SOLL/FIX: als Owner-Entscheide fuehren (deckt sich mit D-1/W-3-Einreihung).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Fingerprint-Fenster; Mess-Kette Ebene 2

### [wktkhd1cj.json] 14
GEGENSTAND: Kapitel II -- haerteste Befunde der Auswertungs-Kette: (a) II.8.2: die Break-Even-Mathematik hat KEINEN Input aus strukturellem Grund -- gesamte reale Messdatenbasis = 2 CSVs mit je 16 Datenzeilen, 16 Gruppen, je GENAU 1 Punkt, working_set_n hat EINEN Wert (4096); Spline verlangt >=2 Knoten => 16/16 Gruppen nullopt, NULL Splines, NULL Schnittpunkte -- fehlender SWEEP, kein Wiederholungs-Mangel; Entlastung: golden-XML plant den Sweep (working_set_sweep 16384 131072 1048576 8388608 = VIER Stuetzstellen je Gruppe) -- "jeder Switch-Threshold der Arbeit wird aus vier Messpunkten je Kurve interpoliert; gehoert in die Limitierungen der Thesis, ist nirgends notiert; VOR dem ersten Batch entscheiden, ob vier x-Punkte genuegen oder der Sweep verlaengert wird -- danach kostet es einen Neu-Lauf"; (b) II.8.3: MICRO halb (die angelegten Orte benchmarks/microbenchmarks + runtime_micro_benchmarks sind leere Skelette), MACRO-timed fehlt (0 Treffer alle Muster; fill_checkpoints exportiert 2 von 18 Achsen, hartkodiert axis_stats[0]+[6]), MACRO-large-scope: 21 Lastprofil-XML, aber KEIN Aggregations-Artefakt; POINTE: diagram_generator.hpp:397-405 ZEICHNET die Kurven, die sich schneiden muessten -- NIEMAND schneidet sie (break.even|schnittpunkt|crossover|intersect ueber den super-Auswertungspfad = 0 Treffer; ce >50); (c) II.8.6: (1) STILLER GRUPPEN-KOLLAPS im Kurven-Loader (fehlt eine Gruppen-Spalte, verschmelzen alle Lasten still zu einer Gruppe -- Empfehlung: Kollaps zaehlen und diagnostizieren analog skipped_rows); (2) MEDIAN-DIVERGENZ REV-DATA-12: best_binary_selector.cpp:184 lower_median vs csv_to_latex.cpp:48-54 + diagram_generator.cpp:414-420 nearest-rank-obere-Mitte -- "die Zahl, die als Median in einer Thesis-Tabelle steht, kann von der Zahl abweichen, mit der der Sieger bestimmt wurde"; (3) Tripwire lief 18 Tage in KEINEM Lauf -- measurement_curve_loader.hpp driftete ZWEIMAL semantisch ohne Versions-Bump (150b0ede 26.07., 0fdeccff 02.08.); geheilt 597ecffe (ci_yaml_key_guard.sh) + 557d8023 (AXIS_ALGO_VERSION 1->2 + Lock-Regen; ABER Sollwert aus demselben Commit wie Istwert = gruen per Konstruktion, Regel R-13).
ORT: ce measurement_curve_loader.hpp:50-51; best_binary_selector.cpp:184; super Code/05_diagram_generator; all_axes_golden.profile.xml:112
SOLL/FIX: siehe je Punkt (Sweep-Entscheid vor Batch; Gruppen-Kollaps-Diagnose; Median-Vereinheitlichung; Thesis-Limitierung 4 Stuetzstellen).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Break-Even/H2; Thesis-Tabellen; Aufraeumpass (T-7 Synthese-Stack-Kanon VOR Paragraph-75-Pass)

### [wktkhd1cj.json] 15
GEGENSTAND: Kapitel II.8.5 -- "Break-Even kommt in der Pruefungsarbeit nicht vor" (0 Treffer in allen 14 eingebundenen Dateien, Gegenprobe greift): das Verfahren, das laut Ledger :3284 das Ziel des Gesamtprojekts traegt, ist in der Pruefungsarbeit NAMENLOS -- keine Falschaussage, aber Luecke; Owner O-097: "das ist geplant und muss dokumentiert werden". Die best_binary_selector-Zusagen halten dagegen (dreimal vorsichtig formuliert, Werkzeug existiert). METHODEN-FALLE (verhinderte einen Falschbefund): LaTeX maskiert Unterstriche -- Suche nach best_binary_selector lieferte falsche 0, erst Muster best.binary.selector fand die 6 Stellen; "Jede Thesis-Suche nach einem Bezeichner muss die TeX-Maskierung mitdenken." Dazu IV.5.5-Verzeichnis-Falle: kapitel/en/01_einleitung.tex IST der englische Text (Verzeichnisse tragen die Sprache, Dateinamen durchgaengig deutsch); nur SECHS Kapitel eingebunden (per .fls-Dateien eines echten Laufs belegt).
ORT: thesis kapitel/; wktkhd1cj kapitel[1] II.8.5 + kapitel[3] IV.5.5
SOLL/FIX: Break-Even-Mechanismus in der Thesis dokumentieren (O-097); TeX-Maskierungs-Regel in Suchdoktrin.
STATUS LT. QUELLE: offen (Thesis-Doku-Posten)
ABHAENGIGKEIT/FLAECHE: Thesis-Kapitel; Fallen-Register

### [wktkhd1cj.json] 16
GEGENSTAND: Kapitel IV.3.3 -- Bau-Reihenfolge B-1..B-10 (Stand 07.08. 00:20): B-1 Kette T-1 Gitlink-Nachzug + main-FF beide Repos (blockiert ALLES; lt. Verdikt 3 B-1 bereits 00:40Z vollzogen); B-2 Bau-Menge klaeren -- zaehlen statt addieren (drei Quellen nennen drei Zahlen 131.072/524.288/2.097.152, KEINE gemessen); B-3 M-6 XML trennt Bau und Messung; B-4 M-3a branch_misses + M-3d RAPL-Probe + Zugriffs-Beweis auf beiden Lanes; B-5 OD-11-RT numa_cpu_pin_process_probe BEIDE Haelften landen; B-6 Core-Permutation in der CEB (einmal E-Core, einmal P-Core); B-7 getrennte Ablage je PMU-Domaene im CSV-/Lager-Schema; B-8 M-5a Pruefdock-Testat als Batch-Preflight + O-1 allow_failure entfernen; B-9 M-3b/c L2+Kohaerenz ueber RAW-Events je Mikroarchitektur (blockiert auf I113 P-6 amd_l3-Uncore-PMU); B-10 vierter Observer-Layer (Gattung/Genus) als deklarierte zweite Bau-Kampagne. IV.5.2-T1-Zusatz: m3v2_pmc_smoke-Zweitbefund steht -- "Auf AMD besteht derselbe Test DURCH ZUFALL (Rausch-Overhead der ioctl/read-Syscalls; 7/7 AMD nonzero, 6/6 Intel exakt null, deterministisch). Die intel-Lane hat diesen Test NIE bestanden -- sie hat ihn stillgeschaltet." Ob die Heilung das Kriterium (>=1 counter populated) mitkorrigiert hat, ist NACHZUPRUEFEN, nicht anzunehmen. Verwurfs-Beschluss fuer Kalibrier-Batch muss VOR dem Batch schriftlich erklaert werden; Klarstellung: verworfen werden Binaries+Sidecars, NICHT Messwerte (CSV additiv sichern, als "Vor-Buendel" kennzeichnen).
ORT: wktkhd1cj kapitel[3] IV.3.3/IV.5.2
SOLL/FIX: Reihenfolge mit Kanten einhalten; B-Titel s. Gegenstand.
STATUS LT. QUELLE: offen (Stand 07.08.; B-1 vollzogen)
ABHAENGIGKEIT/FLAECHE: PMC-Welle; Fingerprint-Fenster; OD-11-Paket

### [wktkhd1cj.json] 17
GEGENSTAND: Kapitel V.6 -- kollisionsfreie Owner-Entscheid-Sammlung (mit Empfehlung+Fenster): RANG 1: A-1 Talos zuruecknehmen (6 Textstellen, unter 1 h; "jeder Tag ... ein Tag mit einer unwahren Abgabe"); A-2 flat_hash_map BEIDES (Baustein bis 21.08. registrieren + Abweichung benennen). RANG 2 -- die SECHS Planungs-Rueckfragen (vom Owner per O-100 ausdruecklich erbeten, ALLE unbeantwortet; Dauerregel "keine Unklarheiten" fuer diesen Bereich befristet aufgehoben): B-1 je Achsenaufruf timen vs Aggregat (Empf.: Aggregat innerhalb der echten Last; heute: echte tier_lookup macht 7 Achsenaufrufe, davon 0 gemessen); B-2 Messung ins Pruefdock? (Empf.: ins Dock, aber T4; Pruefdock hat null Zeitmessung in 17 Dateien, IPruefDock::measure() im Produktionspfad TOT -- 12 Aufrufer alle in Tests); B-3 Break-Even je Ebene (Empf.: eine Ebene bis 15.09.); B-4 Break-Even-Tabelle als Lager-Objekt mit eigenem Schluessel (Empf.: ja; EINZIGE abgabekritische der sechs -- Identitaet ist T1, VOR den ersten Batch); B-5 Hybrid-Adapter CT-einkompiliert vs Laufzeit-Lager (schaerfste; offen lassen bis nach Abgabe, jetzt buchen -- entscheidet Bauform HY-B2); B-6 Kanal = ein Parameter vs mehrdimensionale Kipp-Flaechen (Empf.: ein Parameter, als Einschraenkung dokumentiert). RANG 3 Thesis: C-1 "alle erdenklichen Binary-Permutationen" in aufgabenstellung/de.tex:74-75 ohne Einschraenkung -- Deckelung ausdruecklich gegen den Aufgabenstellungs-Wortlaut stellen; C-2 std::map-Vertrag praezisieren (5er-Kern vs 17 Operationen); C-3 bias-freie Vollmatrix ueber den 320er-Katalog hochstufen; C-4 H2 mit Abbruchkriterium 21.08. (Durchsatz-Spalte existiert nicht); C-5 vier fehlende Lastprofile LP02/LP03/LP07/LP13 bauen; C-6 PRT-ART ChainRef bauen, Prefetch textlich zuruecknehmen (28.08., danach faellt H3); C-7 WIDE-Rohdaten ein Tag Suche dann Wiederholungslauf ("entweder alles neu oder alles gefunden, nicht gemischt"); C-8 Schnitt 28.08. bestaetigen. RANG 4: D-1 PMU-Domaene als FELD DER MESS-ACHSE, nicht Preimage-Glied (VOR ERSTEM BATCH, 0 h vs 34,4 h + Messdaten); D-2 Bau-Menge messen; D-3 Mess-Teilmenge Weg C (~3,1 d; einzige Variante, die den 15.09. haelt); D-4 allow_failure: Preflight in eigenen harten Job trennen ("stiller Rueckfall in CI-Form, Owner hat ihn ausdruecklich verboten O-094"); D-5 fail-closed via kPmcExpected, SKIP->FAIL; D-6 branch_misses NICHT verdrahten sondern EHRLICH deklarieren (M-3a); D-7 Core-Achsen-Faktorisierung {Unpinned|PCoresOnly|ECoresOnly|HybridAware} (Dossier-Fassung; Unpinned unverzichtbar per O-085) mit dokumentierter Abbildung auf die Betreuer-Matrix {P|E}x{Single|All}; D-8 E14 gegenstandslos (gebaut ed67661c), golden-Neuanker-Frage: Empfehlung NEIN vor Abgabe; D-9 Scrub-Ref (s. wwbu56lus O-5). RANG 5: T-1 "Abgabe morgen"-Klaerung; T-2 Frist 15.09. bestaetigen; T-3 Hybrid-Lane Maschine-oder-Gate 21.08. ("Schweigen ist laut M2 keine der erlaubten Optionen"); T-4 T1-H4 als nicht bearbeitete Hypothese ausweisen, nicht streichen; T-5 Wiederholungen: bei 3 bleiben, aber MINDESTENS 3 wirklich fahren (real gefahren wurde 1); T-6 docs/termine/INDEX.md additiv nachziehen; T-7 Synthese-Stack-Kanon: heuristik/ kanonisch -- Entscheid MUSS vor dem Paragraph-75-Aufraeumpass fallen, sonst entscheidet der Pass implizit; T-8 Pareto-Front vs Einzelsieger (ERST 21_SESSION_PLAN_TYPSYSTEM lesen -- sieben Paragraph-H-Forks dort evtl. entschieden, NICHT am Objekt geprueft); T-9 Min/Max-Semantik je Achse (ohne sie ist der Kurvenvergleich fuer Max-Achsen SYSTEMATISCH FALSCH HERUM; break_even.hpp:17 setzt "kleiner=besser" als Konvention; O-026 Deep-Research frueh starten); T-10 Last-Erkennungsheuristik NICHT detailliert geplant (0 Code/0 Design/0 Register -- einziger Posten der Kette OHNE BODEN, blockt HY-B2; Deep-Research ab 21.08.).
ORT: wktkhd1cj kapitel[4] V.6
SOLL/FIX: je Posten Empfehlung + Fenster wie im Gegenstand (verbatim-Kerne uebernommen).
STATUS LT. QUELLE: offen (Owner-Entscheide; gegen 13.08.-Ledger auf zwischenzeitliche Beantwortung pruefen -- mehrere sind per KON-Serie inzwischen entschieden)
ABHAENGIGKEIT/FLAECHE: HY-B2; Lager-Schluessel-Schema; Thesis-Abgabe; Paragraph-75-Aufraeumpass

### [wktkhd1cj.json] 18
GEGENSTAND: Kapitel V.6.6/V.7 -- beim Zusammenziehen als erledigt erkannt: UEBERBLICK C-1 (Gitlink-Paritaet, bewacht via ci/thesis_gitlink_parity.sh), C-2 (Anhang-A-Eintraege, honest-100% mechanisch erfuellt; offen allein F-07: zwei Begruendungen sachlich falsch), PLAN-messkurven F-7 (gegenstandslos). UNBEWIESENER BISS: chktex-Blocker (EXIT 123, 31 Warnungen/8 Dateien) -- der Job lint:latex traegt rules auf COMDARE_TEXLIVE_AVAILABLE == "true"; ob die Variable auf den Runnern gesetzt ist, ist nicht entscheidbar -- "Der Blocker ist entweder scharf oder inert, und niemand hat es gemessen. Naechste Handlung: einen Lauf ansehen, nicht die Datei." V.7-Fenster-Tabelle (Ordnung nach VERFALLSDATUM): vor der ersten .fingerprint-Datei D-1+B-4 (0 h vs 34,4 h+Messdaten); vor dem ersten 4096er-Batch D-2/D-3/D-4/D-5/D-7; Freitag-1-Block A-1/A-2/C-1/C-2/C-8/T-1/T-2/T-6 + 31 Register-Zeilen buchen (MIT Paragraph-63-T-15-Vorbehalt, s. Verdikt 3 B-5); vor 21.08. C-4/A-2-Bau/T-3; 28.08. C-6 (sonst H3 streichen); T4 B-1/B-2/B-3/B-5/B-6/T-8/T-9/T-10 (T-9+T-10 trotzdem am 21.08. starten). Schluss-Regel: "Zwei Wege sind zulaessig -- bauen ODER die Aussage in der Arbeit korrigieren. Aber einer muss gegangen werden." + O-094 "Stiller Rueckfall geht fuer uns nicht." Von den zwoelf Falschaussage-Positionen sind zehn in einem Arbeitstag Text zu heilen, zwei brauchen Owner-Entscheidung.
ORT: wktkhd1cj kapitel[4] V.6.6/V.7
SOLL/FIX: siehe Gegenstand.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: TEXLIVE-Gate (beruehrt landereifen super-Branch bau/texlive-gate-haertung!)

### [wktkhd1cj.json] 19
GEGENSTAND: bestand[2] Fehler+Lehren -- einzigartige offene Reste: (a) A.4 Zwei-Schreiber-Klasse trat DREIMAL auf (A1-NB-Alarm mit verwaistem Schreiber; SendMessage-Resume erzeugte ZWEITE Agenten-Instanz, beide schrieben dieselben Dateien; Lead committete zweimal in fremde Wellen-Branches -- Folgekosten trug ein Dritter: inhaltsgleiche Dubletten e36071f9/1c7cdcb6, repariert ohne rebase via commit-tree) -- "Strukturelle Antwort erst im dritten Fall"; Konsequenz bindend: Landungen laufen ueber eigene Worktrees, Hauptklone werden nicht angefasst; N-AD-Vorbedingung stand zum Erhebungszeitpunkt weiter live. (b) W-1b Format-Bump-Stopp "richtig gestoppt, falsch begruendet" OFFEN -- drei fruehere Berichte empfahlen den Bump, "nicht weil Glied [3] fehlt, sondern weil Glied [3] NICHT AUSREICHT"; der Glied-[3]-Stand gilt nur auf dem T2-A-Stand. (c) W-4 publizierte Bestandszahl "845 Nicht-ASCII / 174 Breiten" NICHT reproduzierbar -- --bestand bricht IMMER bei Eintrag 134/4759 (2,8%) ab (Gitlink-Eintraege + getline), Zahl beschreibt hoechstens einen abgebrochenen Anfang; Wache scheitert LAUT, nur hat niemand den Ausgang gelesen. (d) W-5 super-ASCII-Wache GELANDET, obwohl zwei gemeldete Review-Befunde ungeheilt: Luecke A Arbeitsbaum-Modus zeigt Untracked nie (nackte gruene Null im typischen Paket-Fall), Luecke B 897 Fremdcode-Dateien im Scope (is_scoped() reine Endungspruefung; Entlastung nur durch GIT_SUBMODULE_STRATEGY none = "Zufall der Job-Konfiguration") -- neue Klasse "ein Review-Befund, der gemeldet wurde und trotzdem mitgelandet ist". (e) W-6 vorgeschlagene Gitlink-Richtungswache wuerde den Live-Fall DURCHWINKEN -- "Vorwaerts ist keine Aussage ueber den ZWEIG"; richtig: merge-base --is-ancestor <zeiger> origin/development. (f) W-7 Doktrin-Aussage aus CODE-KOMMENTAR uebernommen (R-20), Owner holte den Befund zurueck; W-7b Befund kippte ZWEIMAL (read_batch_plan WIRD produktiv gerufen, 2x). (g) TEIL C: 11 zurueckgewiesene Auftragspraemissen P-1..P-11 (P-4 "pmc_branch_misses real" -- drei Kommentare am selben HEAD, zwei behaupten das Gegenteil des dritten, Abgabe-relevant OFFEN; P-5 Anhang-A haengt NICHT an M-8/M-9/M-15 -- 28/28 bedient; P-6 numa_node-Namensfalle: zweite voll verdrahtete Unterachse alloc_hw.numa_node an der ORGAN-Achse, 152 vs 23 Treffer -- "wer ungeprueft anschliesst, trifft die falsche Achse") + N-AC-Klasse "eine abgelaufene Sperre wirkt weiter" (bis-#26-Zitat).
ORT: wktkhd1cj bestand[2] A.4/A.5/TEIL C
SOLL/FIX: W-1b/W-4/W-5/W-6-Reste als Posten; Zwei-Schreiber-Doktrin halten.
STATUS LT. QUELLE: offen (Teilposten)
ABHAENGIGKEIT/FLAECHE: ASCII-Wache super; Gitlink-Wachen (NS-4); Fingerprint-Glied-[3]-Frage

### [wktkhd1cj.json] 20
GEGENSTAND: TEIL G -- abgeleitete Regeln R-1..R-20 + RZ-15..RZ-18 mit Anlassfaellen (Auswahl der neuen: R-11 "Keine Ursache ohne Messung" -- hartkodierte [PMC-FEHLER]-Ursachenliste erzeugte 3 Fehldiagnosen + 1 beinahe ausgefuehrten Cluster-Eingriff, waehrend errno an der Quelle verworfen wird; R-13 Wache darf nicht im Gegenstand ihrer eigenen Fehlerklasse wohnen + Sollwert nie aus demselben Commit wie Istwert (557d8023 gruen per Konstruktion, axis_version_lock-Tests = 0); R-14 "Eine Migration erbt die Fehlerklasse, die sie beseitigt" -- xmllint-Migration baute 11 neue False-Green-Pfade ein (Commit 2c631551 sagt es selbst); R-15 Identitaets-Stempel nur so gut wie die Menge der Eingaenge (FUENF Faelle an einem Tag, Checkheft fuehrt EINEN); R-16 gespiegelte Wache = zweite Quelle (die SCHWAECHERE bewacht das groessere Repo); R-19 Anzahl-Zusage durch Liste ersetzen; R-20 Code-Kommentar ist Beleg fuer den Code, nie fuer die Absicht). META-REGEL N-Y OFFEN: "Der Weg 'Regel dokumentieren' ist nachweislich beschritten worden und hat nicht getragen" -- Regel-Zeile 15 binnen zwei Stunden zweimal verletzt; "Was getragen hat, war jedes Mal ein WERKZEUG (Nenner-Ausgabe, fail-closed, test -x-Gate, awk statt Regex), nie ein Merksatz."
ORT: wktkhd1cj bestand[2] TEIL G
SOLL/FIX: Regeln als Werkzeuge/Wachen materialisieren, nicht als Merksaetze (N-Y).
STATUS LT. QUELLE: nur-hinweis (Regel-Katalog; N-Y offen)
ABHAENGIGKEIT/FLAECHE: Wachen-Inventar (NE-16)

### [wktkhd1cj.json] 21
GEGENSTAND: bestand[0] Owner-KERNE der Session (vollstaendige Erhebung; von Verdikt 2 wortgenau gegengeprueft): TEIL I = zehn+1 KERNe, die eine Lead-Lesart widerlegten (W-1 "Verstaendnis-Problem ueber die CEB"; W-2 KERN-Achse des Planers wird nicht gestrichen; W-3 Gattung+Genus = vierter Layer; W-4 "Es existiert kein CSV Lager. xlsx ist default."; W-5/W-6 "keine Unklarheiten -- nur Gedaechtnisluecken / alles ist geplant, mit explore lesen"; W-7 numa page = Cache-Seiten-Koordination = fehlende neue Unterachse; W-8 best_binary_selector hat ganz andere Aufgaben; W-9 "die letzte ist nicht superseded, sondern nur vorlaeufig"; W-10 "Ein Ausschluss loest die Wurzel NICHT, das ist verboten"; W-11 "Ein skip ist keine Loesung. Wir machen das richtig"). TEIL II thematisch: A-1 Acht-Punkte-KERN (dichteste Nachricht) + Kalibrier-Zahl; B Stufen-Vertraege + Schlangen-Mechanik; C PMC (C-2 ZWEI PMC nicht eins; C-3 Identitaetskrise C-2 gegen A-1/F6; C-4 Plan-Erfuellung seit April ausstehend); D Warnungen/Fehlerstufen (D-2 Definition ERROR/FATAL; D-3 stiller Rueckfall verboten); E Auswertung/Break-Even/drei Benchmark-Ebenen (E-2 Kette Messung->Synthese->Konfiguration->Binary; E-5 Observer-Optimalitaets-KERN); F Stempel/Versionierungs-Interface/Lager-Basis-Tests (F-2 "wurde nicht gelesen??"; F-3 Batch-Inventar-Cache); G Quellen-Doktrin (G-1 Diplomarbeit ist die Anforderung an den Code; G-2..G-5 Backups/Neu-Gruendung); H Arbeitsweise/Delegation (H-3 Modell-Regime; H-5 Disjunktheits-Beweispflicht; H-6 Rueckfragen erst nach Explore; H-7 verpasste Nachrichten sequentiell nachholen); I Git/CI-Doktrin; J Doku-/Konsolidierungs-Auftraege. TEIL III = Liste aller 104 Owner-Nachrichten (verbindlich 43 von 106, s. Verdikt 2 B-8). Transkript-Verdikt: Substanz wortgenau, aber 4 schwere Kappungen (s. Eintrag 3).
ORT: wktkhd1cj bestand[0]; Wortlaut-Quelle Transkript-Backups (Pfad nur auf development/main, nicht im Hauptklon-Arbeitsbaum)
SOLL/FIX: als Referenz nutzen NUR mit den Verdikt-2-Korrekturen (A-1..A-4, B-1..B-9).
STATUS LT. QUELLE: nur-hinweis (Referenz-Karte; weitgehend in KON-Konsolidierungen aufgegangen)
ABHAENGIGKEIT/FLAECHE: Konsolidierung IV / KON-Ledger (Dedup dort)

---

NACHTRAG WIEDERANLAUF 14.08.: Die Eintraege fuer wouqomuwl/wapd7pd7p/wtpunni0p/whfxvxf8q/won0hr04n/ws4t2r8ry/wtdpeiotj/wk2fvgrgv/w2kgif6e9 stammen aus dem ersten Lauf (13.08.); die Eintraege fuer w2zv55j8v/wwbu56lus/wa91q7g1p/wktkhd1cj aus dem Wiederanlauf (14.08.). Batch damit vollstaendig: 13 von 13 Dateien gelesen und extrahiert. ACHTUNG DATIERUNG: wwbu56lus (06.08.) und wktkhd1cj (06./07.08.) dokumentieren aeltere Staende -- der Designer muss ihre Status-Felder gegen den KON58/KON59-Ledger-Stand und die gelandeten Wellen abgleichen (Redundanz/Dedup ist Designer-Sache).

SELBSTCHECK: Datei ASCII-only (Nicht-ASCII-Bytes = 0, per Python-Byte-Scan verifiziert); 13 von 13 Batch-Dateien vollstaendig gelesen (4 davon via treue pp_leser02-Voll-Flattenings, Stichproben gegen JSON-Struktur geprueft); 131 Extraktions-Eintraege im Format der Vorgabe (per grep -c "^### [" verifiziert); keine Platzhalter; jede Zahl traegt ihren Nenner aus der Quelle.
