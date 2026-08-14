# LESER 5 von 12 -- Extraktion (Batch i % 12 == 4)

## Batch-Dateiliste (Index in gb_dateiliste.json, Name, Groesse in Bytes)
| idx | datei | bytes |
|-----|-------|-------|
| 4   | wv3ha243c.json | 262758 |
| 16  | wjjqbvdb7.json | 137848 |
| 28  | wr08h0dkm.json | 98522 |
| 40  | wjjsi0tpp.json | 82512 |
| 52  | w210ypdj1.json | 59982 |
| 64  | w7gt8fx1n.json | 44761 |
| 76  | wpe8akoch.json | 34574 |
| 88  | wn5hdyswe.json | 29222 |
| 100 | wv1iqrso9.json | 22175 |
| 112 | w4lq4gi7g.json | 15605 |
| 124 | wzmkd5hfd.json | 12351 |
| 136 | wmneau5l7.json | 8506 |
| 148 | wmjsu2y29.json | 4401 |

Quelle: /home/comdare/.claude/jobs/5a19728e/tmp/regressions-gesamtbild/<name>
Alle 13 Dateien vollstaendig gelesen (result + summary + workflowProgress); Extraktion unten.

## Datei wv3ha243c.json (262758 B) -- "Vorarbeit-Abgleich fuer JEDE laufende/geplante Aufgabe aus 121 gesicherten Workflow-Ergebnissen"
Struktur: 10 Treffer-Abschnitte (M-1-identitaetsnaht, M-2-PMC, M-6-XML-Trennung, M-3-zaehler,
M-5-pruefdock, G-E3-und-lager, messbeginn-und-batch, thesis-und-abgabe, sicherheit-und-ci,
owner-entscheide) + Widerspruchs-Kurzform W-01..W-22. Synthese-Datei lt. Quelle:
docs/sessions/20260806-ANKNUEPFPUNKTE-vorarbeit-je-aufgabe.md. Alle Aussagen sind dort als
BEHAUPTUNGEN frueherer Agenten deklariert, nicht am Code nachgeprueft.

### [wv3ha243c] 1
GEGENSTAND: W-02/M-1: "Format-Bump 3->4 nicht noetig" steht gegen DREI Berichte -- Glied [3] existiert, reicht aber nicht (kein Mess-Define im Toolchain-Glied; COMDARE_MEASUREMENT_ON veraendert die ABI via abi_adapter.hpp:393).
ORT: anatomy_fingerprint.hpp:462-472; toolchain_stamp_glied.hpp:246-248; profile_run_facade.cpp:274; abi_adapter.hpp:393; anatomy_fingerprint.hpp:80-88
SOLL/FIX: "Toolchain-Glied um ein Feld mess erweitern; Format-Bump 3->4, eine ce-Welle, Fixtures ziehen nach"; Dringlichkeit "VOR DEM ERSTEN BATCH -- das Fenster schliesst mit der ersten geschriebenen .fingerprint-Datei"; heute 0 Sidecars = kostenlos, danach 34,4 h (bzw. 68,8 h + Entwertung). Bump ist als OFFENER OWNER-ENTSCHEID gefuehrt (R-3), nicht beschlossen. Traegt nur, wenn D-1-Fix MEASUREMENT_ON deterministisch aus Tooling-Combo ableitet.
STATUS LT. QUELLE: offen (Owner-Entscheid)
ABHAENGIGKEIT/FLAECHE: Kopplung an M-2/PMC (COMDARE_ENABLE_PMC muss mit B-B in denselben Bump); Fenster = erste .fingerprint-Datei

### [wv3ha243c] 2
GEGENSTAND: D-1-Fix-Ort moeglicherweise unvollstaendig: ZWEITE Quelle von COMDARE_MEASUREMENT_ON in CMakeLists.txt:135/141 (add_compile_definitions) neben perm_mess_defines() (profile_run_facade.cpp:273-275).
ORT: ce CMakeLists.txt:135+141; profile_run_facade.cpp:273-275
SOLL/FIX: Vor dem Bau am Objekt klaeren, welche Quelle der ABI-Adapter in der .so tatsaechlich sieht (Tier-.rsp tragen -DCOMDARE_MEASUREMENT_ON=1 8/8; CMake-Zeile trifft vermutlich CEB/Treiber-Teilbaum).
STATUS LT. QUELLE: offen (nicht entscheidbar aus Berichten)
ABHAENGIGKEIT/FLAECHE: M-1-Welle

### [wv3ha243c] 3
GEGENSTAND: "Glied [3] von 8" gilt nur auf T2-A-Stand: ce development@3bbcb8ed = Format 2 / 6 Glieder (kein Toolchain-, kein bvset-Glied); T2-A wt-b2-neuanker@847c93c9 = Format 3 / 8 Glieder; spaeter als GELANDET gemeldet (a9a352bb 6c300e68 86be2420) und ce steht auf e7aa124445e5ddab461251bdb43f81e4562b9213.
ORT: ce development; SHAs 3bbcb8ed, 847c93c9, a9a352bb, 6c300e68, 86be2420, e7aa1244
SOLL/FIX: Vor Bau HEAD belegen (kAnatomyFingerprintGliedCount = 6 oder 8), sonst baut M-1 gegen falsche Preimage-Ordnung.
STATUS LT. QUELLE: teilweise (basis-abhaengig; W-22)
ABHAENGIGKEIT/FLAECHE: alle Fingerprint-Wellen

### [wv3ha243c] 4
GEGENSTAND: Ursprung D-1/D-2/D-4 (Diff-Tabelle Par.5.1): D-1 = 0 funktionale Konsumenten MeasurementTooling + MEASUREMENT_ON hart; D-2 = measurement_line/entries 0 produktive Leser, kein Gate; D-4 = kCebFingerprint rendert Angebot statt Wahl, nicht injektiv ueber Combos (zwei CEBs [wallclock] vs [macro] tragen denselben ceb_key_sha512).
ORT: profile_run_facade.cpp:274; anatomy_module_abi_v1_decl.hpp:221-222; ceb_version_stamp.hpp:3-5+:73-88; tests/unit/test_m_w12_stamp_bausteine.cpp:1055; test_w10_system_cell_values.cpp:330
SOLL/FIX: ObservableTier-Audit S0-S5 VERWENDEN, nicht wiederholen: S2.1 MeasurementTooling bekommt Bau-Semantik (Define-Satz an EINER Stelle, Biss = nm/readelf Symbolmengen-Differenz [wallclock] vs [all]); S2.3 Tooling-Konsistenz-Gate CEB<->Tier am Dock (Mismatch => Fehlerklasse, keine Messung); S4.2 kCebFingerprint als Glied ODER kCebContractCodegenMinor ableiten (Owner-Entscheid, LEDGER:5792 schliesst kCebFingerprint begruendet aus).
STATUS LT. QUELLE: offen (D-1/D-2/D-4 NICHT gebaut, kein Bericht meldet Aenderung)
ABHAENGIGKEIT/FLAECHE: D-2 braucht S1.1 als Vorbedingung (iterator:2394 umgeht Registry/accepts/dock_genus/measure); D-4 allein wirkungslos (kein CEB-seitiges Skip-Gate); Capability-Bit (A-9) = neues extern-C-Symbol => mit ABI-Major buendeln

### [wv3ha243c] 5
GEGENSTAND: Drei Frozen-Vektoren (17148e5a...) an DREI Stellen -- jeder Preimage-Dreh kostet drei Anker.
ORT: test_m_w12_stamp_bausteine.cpp:663; test_g3_sha512_index.cpp:68; test_w10_system_cell_values.cpp:432
SOLL/FIX: bei Preimage-Aenderung alle drei Anker nachziehen.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: M-1/Format-Bump

### [wv3ha243c] 6
GEGENSTAND: Offene Owner-Frage F6 (Vormittags-Runde): Verwirft "Micro-/Macro-Benchmarking sind FALSCH" auch das Par.47-Auswahl-Achsen-Konzept? Kein Supersede-Vermerk auf Par.47 im Ledger. S2 baut die Achse als CT-Auswahl-Traeger -- setzt voraus, dass Par.47 gilt.
ORT: LEDGER:5365
SOLL/FIX: Owner-Entscheid einholen vor S2.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: S2/Mess-Achse; W-18 Nummern-Kollision (F6 dreifach vergeben)

### [wv3ha243c] 7
GEGENSTAND: Namens-Kollisionen der M-Nummern (W-17): heutiges M-1 = dort M-7; M-3 = M-14; M-5 = M-13; dortiges M-1 = PMC-Flag, M-3 = allow_failure am Mess-Batch (:1333), M-5 = P-KAL Kalibrier-Stichprobe.
ORT: wf_ebe2aced-d4b/a6847e8d9e5bcb322 Abschnitt 5.1
SOLL/FIX: Vor jeder Vollzugs-Buchung Nummernsystem klaeren; Referenzen brauchen Datum UND Sachbezug.
STATUS LT. QUELLE: nur-hinweis (Dauer-Verwechslungsquelle)
ABHAENGIGKEIT/FLAECHE: alle Wellen-Register

### [wv3ha243c] 8
GEGENSTAND: W-01/M-2-PMC: Auftrag "Flag-Zeile -DCOMDARE_ENABLE_PMC=ON in jede Emission" steht gegen Owner-KERN 06.08. ("PMC MUSS eingebaut ... in die CEB fuer deren Pruefdock ... NIE abkuerzen, immer mit deep research fixen" -- also NICHT eine Flag-Zeile, sondern Mess-Achse gibt frei, CEB kompiliert ein, Pruefdock testiert). Weg A (Flag, Owner-KERN-widrig, ~13 TUs) vs Weg B (Mess-Haupt-Achse, voller Matrix-Neubau) schliessen sich aus; Faktor 131072:0.
ORT: wf_b242700f-3a0/ae007fa589f7024e5 A-1 (T1, blockiert Messbeginn); wf_514dab7d-8a0/ad4d5f57cd9699a9c Par.5.3
SOLL/FIX: Entweder Weg-A-Zwischenschritt EXPLIZIT im Ledger deklarieren (sonst entwertet spaeteres Weg B den Voll-Bau) oder stoppen; Weg B nur VOR dem Voll-Bau-Trigger zeitlich moeglich.
STATUS LT. QUELLE: offen/ungeklaert
ABHAENGIGKEIT/FLAECHE: Owner-Frage; M-1-Fingerprint-Bump (PMC bau-wirksam => muss mit B-B in denselben Bump, sonst zweiter Voll-Bau)

### [wv3ha243c] 9
GEGENSTAND: W-05: "beide Smokes fail-closed drehen" kollidiert mit 13.07.-Inversionsfix M-CE-25; m3v2_pmc_smoke.cpp:71 darf nur ueber kPmcExpected-Praedikat gedreht werden, nie durch Ruecknahme von "|| counters_all_zero".
ORT: m3v2_pmc_smoke.cpp:71 (+:62-67, :428 ANKLAGE i-2); linux_perf_pmc_smoke.cpp:58-63
SOLL/FIX: Verifizierte Bau-Anweisung B3 (wf_d5d5761c-1aa/a89e6be5a24b83d4d): constexpr bool kPmcExpected aus "#if defined(COMDARE_ENABLE_PMC) && defined(__linux__)" in beide Smokes; linux_perf faellt bei kPmcExpected && !available auf SMOKE_FAIL statt Exit 0; m3v2:71 wird "available || (!kPmcExpected && counters_all_zero)".
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: M-2-Welle; Widerspruch Wellenplan-M-2 ("m3v2 NICHT anfassen") vs B3 (inversions-sicher anfassen)

### [wv3ha243c] 10
GEGENSTAND: W-21: Spalten-Erwartung PMC uneinheitlich -- realer d03-Korpus (26.07., 16 Zeilen): pmc_available=1 (16x), l1 + dtlb REAL, l2/l3/coherence/energy 0 in allen 16; pmc_seam_ok = available||all_zero faengt strukturelle Nullspalten nicht; pmc_branch_misses = "Zusage ohne Deckung", keine PMC-Quelle weist das Feld je zu, Kommentar cache_engine_builder_iterator.hpp:499 ("PmcCounters ERHEBT branch_misses real") am Objekt falsch.
ORT: Code/measure_out_d03/e4_xml/measurements.csv; cache_engine_builder_iterator.hpp:499-500
SOLL/FIX: M-2 muss Spalten-Erwartung deklarieren, sonst "PMC=ON"-Erfolgssignal mit weiter 0-Spalten vorprogrammiert; Kommentar :499-500 korrigieren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: M-3/M-14-Zaehler-Nachruestung; Register-Fehlbuchung V-08 (W-19)

### [wv3ha243c] 11
GEGENSTAND: Doku-Drift-Widerspruch: B5(a) sagt "Kommentar linux_perf_pmc_smoke.cpp:4 korrigieren, NICHT die Registrierung (sonst braeche der Preflight am fehlenden Target)"; ObservableTier-Audit S0.2 empfiehlt das GEGENTEIL (Registrierung unter COMDARE_ENABLE_PMC); abweichende Zeilennummern 3553 vs 3568.
ORT: linux_perf_pmc_smoke.cpp:4; ce tests/unit/CMakeLists.txt:3553 bzw. :3568
SOLL/FIX: Kommentar korrigieren, nicht Registrierung (B5(a)-Fassung); tests/unit/CMakeLists.txt ist bis A1-Landung EIN-SCHREIBER-Revier (P-A1) -- S0.2-Variante wuerde Sperre verletzen; neuer Invarianten-Test darf kein pmc-Label tragen (test:unit faehrt -LE pmc).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Ein-Schreiber-Regel tests/unit/CMakeLists.txt; test:coverage-guard-Nenner (heute 407) verschiebt sich je neuem Test

### [wv3ha243c] 12
GEGENSTAND: PMC-Vorarbeit vorhanden: verifizierte Bau-Anweisung P-PMC-1 ("Kein fehlender Schritt gefunden") + Plan docs/plaene/20260806-PLAN-p-pmc-1-messkette.md (651 Z., NICHT committet, VERLUSTRISIKO git clean); Invarianten-Test ausformuliert (kein Zahl-Pin "4", sondern "jede cmake -B build-Zeile, deren Folgezeile den Mess-Treiber baut, traegt das Flag" + EXPECT_GT(geprueft,0u)); PMC-Preflight #37 GEBAUT (experiment_plan_director.hpp:1269-1280) -- M-2 verengt ihn nur (:1352-1364).
ORT: docs/plaene/20260806-PLAN-p-pmc-1-messkette.md; experiment_plan_director.hpp:1269-1280,:1352-1364
SOLL/FIX: vorhandene Fassung ziehen, nicht neu schreiben; Plan committen (Verlustrisiko).
STATUS LT. QUELLE: teilweise (Plan da, Bau offen, Plan uncommitted)
ABHAENGIGKEIT/FLAECHE: Kollisionsflaeche experiment_plan_director.hpp (B-C/B-E/B-F schreiben ALLE dieselbe Datei -- EIN PAKET, K-1); sequentiell nach w2-codex-fixes-Landung

### [wv3ha243c] 13
GEGENSTAND: allow_failure deckt am Mess-Batch-Job auch CMake-Fehler, fehlenden Driver UND den PMC-Preflight selbst (:1342-1363) -- fail-closed gedrehter Smoke faerbt den Batch trotzdem nicht rot; Invariante haengt allein am Unit-Test.
ORT: experiment_plan_director.hpp:1333,:1342-1363
SOLL/FIX: explizit deklarieren, dass allow_failure den Preflight mit abdeckt (Owner-Entscheid O-B/O-PMC-1), sonst neue Scheinsicherheit.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: HARTE SPERRE AP-12: super .gitlab-ci.yml:651/:738 (measure:smoke/golden-320) tragen das EINZIGE -DCOMDARE_ENABLE_PMC=ON des Mess-Pfads (:677,:768) -- Aufraeumpass darf sie bis M-2-Landung nicht loeschen

### [wv3ha243c] 14
GEGENSTAND: Reihenfolge-Auflage N-3 vor N-4 (Ehrlichkeit vor Scharfschaltung): system_axis.hpp:410/:413 rufen mark_ok(l2)/mark_ok(branch_misses) -- sobald irgendein Counter liefert, werden L2+BRANCH als Ok mit Wert 0 ausgewiesen (Phantom-Ok). PMC einschalten macht L2/branch_misses aktiv zu Phantom-Ok.
ORT: system_axis.hpp:410,:413; linux_perf_pmc_source.hpp:287
SOLL/FIX: N-3 (Ehrlichkeit, mark_source_unavailable) -> N-2 (Probe) -> N-1 (Kategorie) -> N-4 (Freigabe/Gate). "Wer N-4 vor N-3 landet, schaltet ein Gate scharf, dessen Urteil noch mark_ok(0) lautet."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: M-2 + M-3; honest-0 an dieser Stelle unzulaessig (Owner: honest-0 nur wo genuin 0; O-A auf FIXEN entschieden, "honest-0 bis #26" SUPERSEDED)

### [wv3ha243c] 15
GEGENSTAND: Weitere M-2-Vorbedingungen: D-3 (:1194 und :1342 muessen GEMEINSAM landen -- einseitiges Flag loest praktischen Vollneubau des Treiber-Graphen aus; empirisch 12/13 Objektdateien recompiliert); D-7 (ohne super-Submodul-Bump W-5 Landung wirkungslos); D-8 (PMC-Zugriff beider Lanes UNBELEGT -- fail-closed Smoke kann Trigger blockieren); D-11 (realer Lauf mit available=1 ohne Flag in Logs -- Ursache unidentifiziert).
ORT: experiment_plan_director.hpp:1194,:1342; pmc:amd/pmc:intel-Lanes
SOLL/FIX: gemeinsame Landung; W-5-Bump; Vorab-Beweis auf beiden Lanes (pmc-Jobs <3 min); Ursache des d03-Laufs klaeren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: AUFLAGE T-1: nach JEDER ce-Landung ce-main-FF UND super-Gitlink-Bump im selben Arbeitsgang

### [wv3ha243c] 16
GEGENSTAND: W-04+W-08/M-6-XML-Trennung: Auftragszeile nennt falsches Schema -- Trigger-Traeger all_axes_golden.profile.xml (comdare_thesis_profile) hat GAR KEIN XSD (0 xsi:-Attribute; Autoritaet allein parse_thesis_profile+validate_profile); experiment_golden_kern.xml laeuft in keiner Pipeline (0 Referenzen in .gitlab-ci.yml); "Selektion=Teilmenge der Bau-Menge" ist OFFENE Owner-Frage R-2/R-1, und 304 von 320 Mess-Binaries liegen AUSSERHALB des 2^17-Raums (Sonde: 320 total, 16 im Raum, 304 nicht; 16/320 = 5,0%) -- fail-closed Teilmengen-Wache ohne neue Mess-Selektion macht Mess-Weg ROT.
ORT: Code/test_data_xml/experiment_schema.xsd; all_axes_golden.profile.xml; m3v2_study.profile.xml; .gitlab-ci.yml:1152 (COMDARE_GOLDEN_N_PROFILE)
SOLL/FIX: Empfehlung additiv statt ersetzend: alte 320 als m3v2_study unangetastet, NEUE golden_kern_320.profile.xml als echte Teilmenge des 2^17; Element-Name unklar (measure_selection vs measure_axes+measure_options cap -- vokabular-zeichengleich zu permute_axes); fertiger Bauplan B-2 liegt vor (ThesisProfile += measure_axes+measure_options, Abwesend=leer=byte-identisch, basis_view/mess_view, HARTE Teilmengen-Wache fail-closed, Emitter :1366-1369 liest Mess-Menge, 3 Tests inkl. Golden-Neutralitaet).
STATUS LT. QUELLE: offen (nichts gebaut; measure_axes/measure_selection nur in 2 Planungs-Berichten)
ABHAENGIGKEIT/FLAECHE: Owner-Fragen R-1/R-2 (Mess-Menge-Zahl fehlt: Vollmenge 71,7 Tage Wanduhr auf 2 Lanes vs 40 Tage verfuegbar); Kollision wt-b14/F5 an experiment_schema.xsd + xml_config_parser.{hpp,cpp}; golden_n_consistency_check.cmake muss um measure_axes erweitert werden (B-5)

### [wv3ha243c] 17
GEGENSTAND: Mess-Batch 4096er-Scheibung fehlt (B-3): Bau slict korrekt (:1240-1252, SLICE=4096), Mess-Batch faehrt volles Fenster in EINEM Treiber-Aufruf je Perm (:1367-1369) -- Mess-Lauf = ungeteilte Einheit von Wochen ohne Wiederaufnahme-Korn.
ORT: experiment_plan_director.hpp:1238-1256 (Bau), :1366-1369 (Mess)
SOLL/FIX: dieselbe while-START<TOTAL-Schleife als EINE gemeinsame Emitter-Funktion (nicht zwei Kopien -- Plan-Stempel haengt am Korn, iterator:1126 plan_slice_korn); Test EXPECT_EQ(count_occurrences(yaml,"SLICE=4096"),4u); Korn beider Phasen gleich halten (R-6), kleineres Mess-Korn nur mit fail-loud-Wache.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: vier entkoppelte 4096-Literale ohne static_assert (director:610, batch_planner.hpp:51 ZWEITE Definition, planer_driven_build.hpp:60, source_catalog.hpp:205); Korn-Divergenz iterator:2340 vs :1109 lt. T2-A-NB2 GEHEILT via LazyRunConfig::batch_plan_korn+plan_slice_korn (Branch b2-neuanker-format3 HEAD a9a352bb, damals NICHT gepusht, Format-Bump batchplan-v2->v3, clang-format-Gate stand aus)

### [wv3ha243c] 18
GEGENSTAND: Fenster wirkt nur im Basis-Pass: profile_run_entry.hpp:761 (golden_range_count>0 && pass_axis.empty()) -- 17 axis_sweep-Paesse laufen je Scheibe ungefenstert voll durch; im Mess-Batch ~78 zusaetzlich gemessene Zellen je Perm-Aufruf.
ORT: profile_run_entry.hpp:761
SOLL/FIX: Scheibung, die nur COMDARE_GOLDEN_N_RANGE setzt, schneidet Sweep-Paesse nicht ab -- mitdenken.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: M-6/B-3; Fingerprint-Skip (Bau billig) ist ohne COMDARE_BESTANDSLOG=true toter Pfad

### [wv3ha243c] 19
GEGENSTAND: Mess-Batch findet gebaute Binaries lokal nicht: Bau output_dir=Code/gn_out/<slug>/<host>/perm<idx> (:1234), Mess output_dir=Code/measure_out/<slug>/perm<idx> (:1391) -- verschiedene Baeume; Bruecke nur Lager-Pull (COMDARE_STORAGE_CACHE=true + minio); ohne Lager baut Mess-Batch 131072 je Perm NEU; Emitter-Kommentar :1440-1442 ("der Mess-Batch findet sie vor") ist heute FALSCH.
ORT: main.cpp:1275 (dll_dir); experiment_plan_director.hpp:1234,:1391,:1440-1442
SOLL/FIX: B-4 (Lager-Bruecke) vor Mess-Scheibung, sonst scheibt man Neubauten.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: M-6/B-4; MinIO/STORAGE_CACHE-Owner-Frage (Zwilling zu O-C)

### [wv3ha243c] 20
GEGENSTAND: W-03+W-09/M-3-zaehler: L3 ist BEREITS verdrahtet (PERF_COUNT_HW_CACHE_LL, linux_perf_pmc_source.hpp:192,:263-266) und liefert trotzdem 0 in allen 16 Zeilen => L3 = Ursachen-DIAGNOSE; L2+coherence bewusst nicht geoeffnet (:194-195,:208,:295) => RAW-Event-NEUBAU; branch_misses nie geoeffnet (PERF_COUNT_HW_BRANCH_MISSES fehlt, kein RAW noetig -- B6/S0.3); Kohaerenz hat KEINE MeasurementCategory (Kategorie-Erweiterung, bricht compile-hart an 4-5 Stellen: measurement_axis_registry.hpp:23,:61, system_axis.hpp:27-36,:38-42 kPmcCounterCategories 7->8,:132-134; ABI-neutral).
ORT: linux_perf_pmc_source.hpp; measurement_category.hpp:10-27; system_axis.hpp
SOLL/FIX: S0.3: branch_misses real erheben neben :202-207 ODER Spalte auf n/a via SampleStatus; falschen Kommentar iterator:499-500 korrigieren; Biss: pmc_branch_misses>0 bei zweiglastiger Last, Kontrast linear_scan. RAW-Events nicht hartkodieren, sondern via /sys/bus/event_source/devices/cpu/events/ beziehen (dort UNBELEGT, nie aufgelistet).
STATUS LT. QUELLE: offen (nirgends gebaut; 4x geplant: B6+O-PMC-3, S0.3, N-1..N-4, M-14 -- vorhandene Fassung ziehen)
ABHAENGIGKEIT/FLAECHE: M-14 setzt M-7 (Mess-Glied Fingerprint) voraus, sonst wird Nachruestung nicht in Flotte gebaut; branch_misses = Schema-Bruch (Korpus 173 Spalten ohne pmc_branch_misses, neu >=174 -- alt/neu-Vergleich muss projizieren); Thesis-Text an 4 Stellen falsch

### [wv3ha243c] 21
GEGENSTAND: W-19: Register V-01/A15 + Task #8 fuehren V-08 als "erledigt-belegt: L1/L3/branch_misses real erhoben" -- von zwei Berichten am Objekt widerlegt (keine PMC-Quelle schreibt branch_misses; einzige Zuweisungen in Tests).
ORT: Register/Task-Liste; measurement_snapshot.hpp:145
SOLL/FIX: Register-Korrektur; wer Register statt Audit liest, haelt M-3 fuer erledigt.
STATUS LT. QUELLE: offen (Fehlbuchung)
ABHAENGIGKEIT/FLAECHE: M-3/M-14

### [wv3ha243c] 22
GEGENSTAND: RAPL/Energie: pmc_energy_micro_joules 0 in allen 16 trotz available=1; intel-rapl:0-Zone auf AMD-Lane UNBELEGT (O-PMC-3(c): vor Trigger cat-Einzeiler im pmc-Job); Korpus-Provenienz UNBELEGT (Host unbekannt, nur perm.dll.version m3v2+ext=no_extension+cxx=g++-16+opt=O3+ceb=7.0); "Last-Level==L3 auf prod1/prod2" widerspruechlich (ein Bericht: korrekt; anderer: UNBELEGT, lscpu-Probe noetig).
ORT: /sys/class/powercap/intel-rapl:0/energy_uj; Code/measure_out_d03
SOLL/FIX: cat-Einzeiler + lscpu-Probe im pmc-Job vor Trigger; danach Spalte real ODER honest-0 fuehren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: O-PMC-3 (Owner-Teilfragen a/b/c unbeantwortet); perf_event_paranoid/Rechtelage Runner nicht nachgemessen

### [wv3ha243c] 23
GEGENSTAND: W-06+W-10/M-5-pruefdock: Dock-Einbau ist kein Refactoring sondern Verhaltenswechsel mit Datenwirkung -- Container-Genus-DLLs werden heute gemessen wie SearchAlgorithm, nach Fix dock_status_wrong_genus (Reject); iterator:2394 umgeht Registry/accepts()/dock_genus()/measure() vollstaendig; 4 Dock-Dateien (set/sequence/adapter/view, 545 Z.) produktiv unerreichbar; genus() im Produktionspfad nie gelesen.
ORT: cache_engine_builder_iterator.hpp:2394; search_algorithm_dock.hpp:75-76,:81-84
SOLL/FIX: ObservableTier-Audit S1.1 verwenden (Audit BEREITS GEFAHREN: A-1..A-9, G-1..G-6, S0-S5 mit Biss und Rebuild-Bilanz "Host/CEB neu, ABI-Major bleibt 8"); Negativ-Probe mit Container-Genus-DLL-Fixture test_e24_c10_genus_dll_roundtrip.cpp.
STATUS LT. QUELLE: offen (nirgends Vollzug zu S1.1 gemeldet)
ABHAENGIGKEIT/FLAECHE: Reihenfolge zwingend S0 (PMC-Ehrlichkeit) vor S1; im Messfenster Datenwirkung-Risiko; Widerspruch produktive-Aufrufer f15_compare main.cpp:234 (ein Bericht: produktiv; anderer: 0 produktive, :249 "Sonstige") -- am Objekt aufloesen

### [wv3ha243c] 24
GEGENSTAND: M-5-Vorbedingungen: V1 Pruefstand VOR Messung ist Owner-Gesetz (Par.68b, LEDGER:3319: erst Build+Pruef-Batch via Google-Tests am Pruefdock, dann Messung) -- heute faehrt pruef_only.hpp:29-40 nur run_conformance_gate gegen std::map, keine Testate/kein PMC; V2 Tooling-Konsistenz CEB<->Tier fehlt am Dock (CEB [all] vs Tier [wallclock] laeuft stumm durch); V3 Aufraeumpass-Posten 33 (SetDock-Doppelschicht) + 35 (SA-Dock ohne dock_version()-Member) OFFEN; V4 Capability-Bit fehlt (A-9, 5. extern-C-Symbol => mit S3/ABI-Charge buendeln); V6 F6 offen; V7 Basis-Drift (Anker aus 47c4ef1d/b241a272, heute e7aa1244/3bbcb8ed -- Re-Anker-Pass Pflicht).
ORT: pruef_only.hpp:29-40; pruef_dock.hpp:74-79; pruef_dock_version.hpp:11-16; g8_negativliste:239,:241
SOLL/FIX: S1.2 Pruefstand-Zweig mitbauen; S2.3-Gate; Posten 35 vor/mit M-5; Signatur-Frage (traegt measure() den PMC-/Zwei-Phasen-Weg?) ungeklaert -- vor Bau beantworten.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: W3-Testate GEBAUT+GELANDET (#340/#341 Passed, 408 Tests) -- Landeplatz existiert, nur produktive Verdrahtung fehlt; "Pruef-Dock" im Baum DOPPELT belegt (simd_build_gate.hpp nennt sich auch so -- grep-Falle); Experiment-Dock (Planer<->CEB) existiert NICHT als ABI-Grenze (in-process statisch)

### [wv3ha243c] 25
GEGENSTAND: W-11+W-12/G-E3: "make_messwert_key_fn() als Schwester" -- Key-Ableitungs-Schwester EXISTIERT bereits (MesswertKeyPolicy in bestandslog_factory.hpp, make_messwert_bestand(), Test test_g3_sha512_index.cpp TwoGeneraSeparate PASSED); gesucht ist ein PROVIDER analog make_fingerprint_key_fn (liest .fingerprint-Sidecar) -- aber fuer Mess-Genus existiert KEIN Sidecar (Baum-Writer schreibt keine; 0 Treffer sidecar in lager_baum_writer.hpp); WOGEGEN der Mess-Provider lesen soll ist in keinem der 121 Berichte benannt.
ORT: libs/cache_engine/builder/bestandslog/bestandslog_factory.hpp; fingerprint_key_source.hpp
SOLL/FIX: vor Bau klaeren: Lese-Quelle des Mess-Genus-Providers (unklar); make_messwert_key_fn/messwert_key_hex = 0 Treffer im Korpus.
STATUS LT. QUELLE: offen/unklar
ABHAENGIGKEIT/FLAECHE: Owner-Entscheide D6: (1) Stufe 2 jetzt gegen comdare_anatomy_version_lines() oder warten auf S1/S3; (2) Writer+Reader EINE Factory oder zwei; (3) libxlsxwriter kann nicht lesen -> eigener ZIP/XML-Leser oder zweiter Vendor; (4) eigenes Dossier fuer Lager-Basis-Test-Welle

### [wv3ha243c] 26
GEGENSTAND: G-E3-Host-Binder: Schreiber existiert seit dcbaa728 (03.08., messwert_registrierung.hpp, verdrahtet iterator:1667-1669/1871/2565-2571), ABER 0 Stellen setzen mess_bestand_key_of/mess_bestand_doc_key/mess_bestand_versions (grep 0 Treffer) -- toter Code; Genus-1-Pendant bestand_key_of ist via profile_run_facade.cpp:723 -> profile_run_entry.hpp:650 durchgereicht; VIER Naehte statt drei: mess_bestandslog_active (:1665-1668) hat dieselbe Luecke wie bestandslog_active (:1658-1660) -- "der Fix muss BEIDE Gates fassen, sonst heilt er die Haelfte"; cfg.bestand_fingerprint_fn bzw. mess_bestand_fingerprint_fn in BEIDE Aktiv-Bedingungen fail-closed aufnehmen (Biss: T2-C-Fall + na-Fall halten Lager stumm). Ob cfg.mess_bestand_fingerprint_fn als Feld existiert: unklar.
ORT: cache_engine_builder_iterator.hpp:1658-1660,:1665-1669,:1870,:2561-2571; profile_run_facade.cpp:723
SOLL/FIX: Host-Verdrahtung nachbauen (Kette benannt, kein Neubau); beide Gates fassen.
STATUS LT. QUELLE: offen ("weiterhin real offen"; Owner-Regel: 0 Konsumenten bei Pflicht-Features = unverdrahtet/unfertig, nicht tot -- LEDGER Z.555)
ABHAENGIGKEIT/FLAECHE: K-5 (B-T strikt NACH ce-Buendel B-B..B-G); profile_run_facade.cpp = Kollisionsdatei mit B-B/M-1; G-E3/P2-P8/B14/E8-PMC/Ebene-B beruehren alle iterator+director (heisseste Dateien, kein Paar dateidisjunkt); Bestandslog Opt-in Default AUS (profile_run_entry.hpp:435) -- O-C beantwortet "aktiv", i-5+i-6 Pflicht

### [wv3ha243c] 27
GEGENSTAND: LB-6-Stand: Stufe 1 GEBAUT+GELANDET (b-lb6-stufe1 Spitze 3558466d, 3 Commits, +506/-37, als b241a272 gemerged, beide Remotes) inkl. echter 2/4-Thread-FS-Konkurrenz (Race-Statistik 79 von 200 Laeufen >1 Thread; bewusst KEINE Ausschluss-Assertion -- nicht rueckgaengig machen); LB-6 ALS GANZES NICHT erfuellt: Beweis 1 (Driver-E2E, OE-A "PFLICHT zu konstruieren") als B10 offen, Beweis 4 (echtes minio, Cluster-read-only) offen; deklarierte HERABSTUFUNG im Ledger+VOR-TRIGGER-CHECKLISTE gefordert und NICHT vollzogen (B-U "blockiert die Abgabe 15.09.").
ORT: ce b-lb6-stufe1/3558466d -> b241a272; docs/plaene/20260806-PLAN-lb6-stufe1-oeb-baumform.md (521 Z.)
SOLL/FIX: Herabstufungs-Vermerk nachziehen; Beweis 1+4 als B-U weiterfuehren.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: LB-0..LB-6 im 14-Tage-Register 0 Treffer (nicht verbucht); kein test_lb2/test_lb3 (Beweise nur bis LB-1, Zahlen 34/26 Makros); LB-4/LB-5 ohne jeden inhaltlichen Befund

### [wv3ha243c] 28
GEGENSTAND: Lager Stufe 2 (Binary-Stubs) EXISTIERT NICHT: keine gebaute .so traegt COMDARE_ANATOMY_VERSION_STAMP (0 Treffer), 11 dlopen-TUs, 0 lesen Stempel-Symbol; Owner-Verweis "laut Plan" zeigt auf nicht-existentes Dokument (7 Zeilen in 1/1096 super-docs, 0/153 ce-docs); Bauplan liegt aber vollstaendig vor (Vorlage genus_buildvariant_avx2.cpp 30 Z.; neue Quelle tests/unit/version_stamp_stub_module.cpp; dlopen+dlsym comdare_anatomy_version_lines vs lazy_adhoc_fingerprint_for lazy_adhoc_source_gen.hpp:358-379; Leerheits-Beweis dlsym comdare_create_anatomy==nullptr); Stufe 2 owner-terminiert NACH Abgabe + an F7 Option b gekoppelt ("Stub ist genau die Binary, die NUR dieses Interface traegt; Interface-Bau und Stub-Test gehoeren in dieselbe Planung"); Terminbasis 08.08. ueberholt (neu 15.09.) -- neu bewerten.
ORT: tests/unit/CMakeLists.txt:3583/:3599 (Kollisionsgebiet, Ein-Schreiber-Regel)
SOLL/FIX: vorhandenen Bauplan ziehen; Owner-Entscheide D6 vorher.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: F7 Option b; xlsx-Lese-Haelfte (Stempel aus xlsx-Legenden-Sheet) NIRGENDS geplant/gebaut

### [wv3ha243c] 29
GEGENSTAND: W-13/messbeginn: Bau-Umfang ist ENTSCHIEDEN 524288 (nicht 131072 = Fenster je System-Perm; nicht 2097152 = line_size-Faktor an ungelesenem XML-Block; vierte Zahl 1572864 = 12-Perm-V7.4-Variante -- Owner-Entscheid 26.07. D-34 "12 System-Perms" NICHT aufgeloest, R-4 empfiehlt bei 4 zu bleiben); COMDARE_GN_TOTAL ist Fenster JE PERM (director:989-990, while-Schleife innerhalb for-perms :1230-1272); KEINE Kappung existiert (cap ungeparst im experiment-Dialekt, wirkungslos im thesis-Dialekt min(131072,131072); COMDARE_E4_CAP nirgends gesetzt, EIN Name zwei Bedeutungen); Zeit je Binary GEMESSEN seit 23.07. Pipeline 12690: 19,4 min/4096 amd, 32,25 min/4096 intel (0,284/0,472 s je Binary; Voll-Bau ~34,4 h Wanduhr; ueber ZWEI Dokumente verknuepft, morgen literal nachmessen).
ORT: experiment_plan_director.hpp:989-990,:1230-1272; profile_runner.hpp:163-169; Pfad-Korrektur: director liegt unter libs/cache_engine/profile_facade/planner/ (nicht builder/planner/)
SOLL/FIX: 524288 als Abgabe-Menge festschreiben, XML-Kommentar :285 korrigieren; offener Owner-Soll-Entscheid nur line_size/12 Perms.
STATUS LT. QUELLE: behoben in der Sache (gemessen), offen nur Owner-Soll
ABHAENGIGKEIT/FLAECHE: W-06-Ableitung des Berichts: GN_TOTAL=4096 => je Perm eine 4096er-Scheibe (2 Perms/Lane => 16384 ueber 4 Perms) -- mit Trockenlauf B-1/T-0(a) klaeren ("B-1 vor allem anderen", einziger Posten ohne Code-Aenderung)

### [wv3ha243c] 30
GEGENSTAND: Kalibrier-Batch-Vorbedingungen: D-1 ohne COMDARE_BESTANDSLOG=true traegt Batch GAR KEINEN Fingerprint ("jeder produktive Lauf ohne die Variable baut jede Binary neu"; Variable ist Trigger-POST-Variable, per git grep nicht findbar); bestandslog_active prueft bestand_fingerprint_fn NICHT (fail-closed nachziehen, in derselben Welle wie Provider-Scharfschaltung F-9); D-5 PMC-Zusage der Scheibe-0-Lieferung nicht erfuellbar solange PMC-Welle nicht gelandet (grep -c COMDARE_ENABLE_PMC am Stand e7aa1244 = 0); D-8 Gitlink-Drift super-CI baut veraltete ce (L-0 B-A Gitlink-Nachzug auf b241a272 sofort); D-9 planner_status_reader.hpp:322 vergleicht GOLDEN_N_RANGE mit PlanPerm::index (falsches Koordinatensystem; bei 4096:4096 alle realen Zellen Fremdfenster -- Stand nach T2-A-Landungen unklar); D-10 df/avg-.so-Groesse UNBELEGT (nach erstem Batch rechnen BEVOR Matrix weiterlaeuft); D-11 Frist 15.09. mit woechentlicher Freitagslieferung (08.08. war Zwischenziel).
ORT: profile_run_entry.hpp:435; planner_status_reader.hpp:322; iterator:1658-1660
SOLL/FIX: siehe je Punkt; Verwerfbarkeits-Rahmung des ersten Batch existiert in keinem Bericht (Batch = Lieferung + Messinstrument; verwerfbar nur wenn weder Lager-Push noch Messgrundlage -- Luecke, keine Deckung).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: R-3-Fenster (erste .fingerprint-Datei); Runner-Kapazitaet 34,4h-Bau ohne Timeout ungeprueft (timeout: 7d emittiert, director:1183); 7,3 s/Mess-Zelle bei 2^17 UNBELEGT

### [wv3ha243c] 31
GEGENSTAND: W-14/Thesis Anhang A: Generator wurde GEFAHREN -- 28/28 Positionen bedient, PDF DE+EN 0 Fehler (DE 246 statt 202 Seiten, EN 238 statt 192); 20 von 29 Deficit-Positionen mit echten Werten baubar, 6 ehrlicher Vermerk, 3 honest-empty; nur Ersatztexte setzen waere andere Entscheidung als der Auftrag glaubt -- Owner-gebunden (O-4). Einschraenkungen: ld_sweep = Kurve mit EINEM Punkt (working_set_n konstant 4096); Flaechen 4x2 statt 4x21; erase/scan/rmw nie ausgefuehrt.
ORT: thesis anhang/{de,en}/A_measurements.tex; 08-Facade seit 06.08. 17:46
SOLL/FIX: O-4 dem Owner vorlegen bevor 17 stumme Eintraege Ersatztext statt Daten bekommen; vierter Weg "44/44 aus ZWEI deklarierten Korpora" mit Pflicht-Auflage: Naht zwischen zwei Messlaeufen muss im Dokument stehen.
STATUS LT. QUELLE: offen (O-4 unentschieden; vier gegensaetzliche Empfehlungen, Owner-Zitat "Ja bitte mit in die Abgabe ... Aber erst die Messdaten beheben" = Weg 2 Vollausbau)
ABHAENGIGKEIT/FLAECHE: Generator-Binary STALE (build-test vom 03.08. 15:29, Quellen 06.08. 17:46, strings 0 Treffer lc_surface3d -- kann die 23 neuen Dateien nicht schreiben); axis_inventory.tex entsteht im CI NIE (:711,:803, anhang_forward_core.sh:173 rufen Generator ohne --*-registry; \InputIfFileExists = stumm)

### [wv3ha243c] 32
GEGENSTAND: W-15/Thesis zwei Mounts: KEIN Bericht empfiehlt "beide behalten und konsistent halten" -- zwei empfehlen Reduktion auf EINEN (git rm --cached, vierten .gitmodules-Block loeschen, Arbeitsbaum VERSCHIEBEN nicht loeschen, Doku deprecaten, Verifikation git submodule status = genau 3 Zeilen); zweiter Mount 0 Konsumenten (CI 0, CMake 0), Test schliesst ihn aktiv aus (test_experiment_plan_director.cpp:1854-1856 EXPECT_EQ npos); .gitmodules asymmetrisch (4. Block ohne branch/update => submodule update --remote driftet auf Remote-HEAD -- zweite Driftquelle, SHA-Gleichziehen heilt das nicht; so wurde Board-#74 schon einmal scheingeschlossen); Drift-RICHTUNG hat sich am Abend umgedreht (rueckwaerts -> vorwaerts) -- je Gitlink neu messen (git merge-base --is-ancestor), nie uebernehmen.
ORT: super .gitmodules; Code/external/20260931-overleaf-diplomarbeit
SOLL/FIX: Reduktion (Owner-Entscheid noetig falls Behalten); falls Behalten: Wache in verify:submodules (Gleichheit zweier Gitlinks derselben URL, rot bei Ungleichheit).
STATUS LT. QUELLE: offen (Owner-Entscheid)
ABHAENGIGKEIT/FLAECHE: d-1: im selben Baum liegt UNGESICHERTE Anhang-A-Arbeit (b-thesis-ehrlichkeit-anhang a6c7598c, 3 Commits + 2 dirty A_measurements.tex, auf KEINEM Remote; Rescue-Ref a6c7598c:refs/rescue/thesis-ehrlichkeit-a6c7598c auf BEIDE Remotes, 15 min, vor allem anderen; 8e58f691 ebenfalls nur 1 lokale Ref); mv des Arbeitsbaums wuerde sie mitnehmen

### [wv3ha243c] 33
GEGENSTAND: Gate 8 (23 Anhang-A-Abbildungen, thesis 8970465d, +199/-2): IST GELANDET (origin/main==origin/development==8970465d) -- "nicht gelandet" war widerlegte Zwischenaussage; fehlte nur super-Gitlink; ABER Gate 8 NICHT auf GitHub (github/main=29a1700d, 1 Commit Delta) => nicht in Overleaf; Overleaf-Sync-Mechanik ("synct GitHub/main", LEDGER:5768) UNBELEGT; super origin/main trug noch 29a1700d (VOR Gate 8) -- main-FF auf 72eab9ae als Rang-1-Handlung genannt (laufende Task-Liste behauptet geheilt -- neu messen).
ORT: thesis-Repo 8970465d/29a1700d; super 72eab9ae/5534c23c
SOLL/FIX: Overleaf-FF (R5-2) sofort, unabhaengig von allem; main-FF-Stand neu messen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: drei Bridges triggern branch:main fest verdrahtet (super .gitlab-ci.yml:255/:273/:291) -- Deckung auf Zweigname statt SHA strukturell entwertet; T-1-Auflage

### [wv3ha243c] 34
GEGENSTAND: d-2 chktex = HARTER Abgabe-Blocker: overleaf .gitlab-ci.yml:63 faehrt chktex -q -n36 -n17 ohne || true; Baseline 0; Variante A 18 Befunde, Variante B 55; zweite Messung: 38 generierte .tex => EXIT 123, 31 Warnungen ueber 8 Dateien; "Sobald Anhang A committet wird, geht lint:latex rot"; anhang:forward-Kanal wuerde rot erst nachtraeglich melden; Ersatztext-Klassen W18 (Anfuehrungszeichen) und W11 (...) leicht eingeschleppt -- chktex lokal fahren vor Push; chktex ueber A_measurements.tex MIT neuen Ersatztexten nirgends gemessen.
ORT: Code/external/20260931-overleaf-diplomarbeit/.gitlab-ci.yml:63
SOLL/FIX: chktex -q -n36 -n17 lokal vor jedem Push; bei Anhang-A-Commit vorher Befunde tilgen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: O-4/Anhang-A-Commit; observer_detail.tex reisst Breite (12 Overfull hbox a 1563,6 pt, ~470-Zeichen-String diagram_generator.cpp:2045-2047; skaliert nicht bei 131072)

### [wv3ha243c] 35
GEGENSTAND: Thesis-Restposten: Ersatztexte fuer VIER Gruppen bereits geschrieben (Commit 8e58f691 ungepusht, "er gehoert gelandet" -- heute nur Rest bauen, nicht ab 11 anfangen); 17 stumme Eintraege ({}{}) erzeugen keinerlei Spur im PDF; Gruppen-Ersatztext war BEWUSSTE Entscheidung (28/28-Einzeltexte waeren Umkehrung -- Entscheid, kein Fix); Alt-Kapitel-Markierung V-03/R-T5 gebaut (16 Dateien +74 Z. additiv); Task-Liste-SHAs 19e1592/123b2f32 kommen im Backup 0-mal vor (nach Backup entstanden -- vor Neu-Beauftragung am Objekt pruefen); Voll-Korpus-PDF-Gate steht aus; b-6 Limitierungs-Zeilen heute widerlegt (Korpus available=1 real L1+dTLB; le_limitierung.tex "4 Achsen variieren" falsch, es sind 3) -- drei Berichte, drei PMC-Staende, selbst nachmessen.
ORT: thesis 8e58f691, 19e1592; super 123b2f32; anhang/de/A_measurements.tex:12-13 (EN :11-12)
SOLL/FIX: 8e58f691 landen; Limitierungstexte nach eigener Messung korrigieren.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: O-4; d03-Korpus-Referenz linear_scan UNBELEGT

### [wv3ha243c] 36
GEGENSTAND: W-07/Sicherheit Runner-Token: "390 Token nicht rotiert (heute verifiziert)" -- Bezugsgroesse falsch: 776 Vorkommen runners_token (386 group_projects.ndjson + 390 projects_all.ndjson) vs 390 GitLab-Projekte; KEINE Rotations-Verifikation existiert im Bestand (nur Abwesenheit eines Belegs); Owner-Entscheid 5 (02.08. 09:25): "nach Messfenster rotieren und handout an infra" (T3, vor 15.09.); Backup-Ref refs/backup/pre-secret-scrub-20260802 = 5ba3d03f live auf origin (enthaelt 44820451; github leer); Owner-Entscheid bindend: stehen lassen, nach Abgabe in rechtebeschraenktes Bundle (chmod 700), dann Remote-Ref loeschen (Loeschung nur mit explizitem GO); M-3-Empfehlung: V-11 + Token-Posten auf festen Freitag ziehen (Terminierung mit verzehnfachter Bezugsgroesse ist keine mehr).
ORT: docs/sessions/backups/20260802-e23-suchlauf-belege/e23/{group_projects,projects_all}.ndjson; refs/backup/pre-secret-scrub-20260802=5ba3d03f
SOLL/FIX: Praemisse "heute verifiziert nicht rotiert" fallen lassen bzw. echte Verifikation erheben; Termin fixieren.
STATUS LT. QUELLE: offen (terminiert, nicht dringend)
ABHAENGIGKEIT/FLAECHE: E-23-Inventar Verfallsklausel max 7 Tage (Erhebung 02.08., abgelaufen 09.08.); A11-Nachtrag 0/0 gebucht

### [wv3ha243c] 37
GEGENSTAND: W-16/ASCII-Wache super: super hat KEINE Kopie der ci_diff_ascii_width_guard (find = 0); 1:1-Spiegeln verboten -- Wache hat 2 gemessene Defekte: N-1 $0-basierter Repo-Root (:141-142) => in jedem Worktree gruen ueber FREMDEN Baum (gemessen 12578 statt 1450 Zeilen); korrekte Worktree-Nutzung nur --stdin-Pfad; Regel 6: gruenes Gate deckt nur eigenen Gegenstand (Wache 3x gruen, lint:format fand trotzdem 94 Verstoesse/13 Dateien); CI-Variablen-Verdrahtung nie scharf gelaufen ("der erste echte Lauf ist der Beweis"); ZWEI verschiedene fehlende super-Wachen: ASCII-Wache != Abdeckungs-Invariante (super: kein scripts/ci_test_coverage_*; 144 super-Tests Luecke 0, aber nichts haelt die Null; im ce 2x nachgewachsen: 21 Tests 13.07., 9 am 06.08.).
ORT: ce scripts/ci_diff_ascii_width_guard.sh:141-142; super (Fehlstelle)
SOLL/FIX: Spiegelung muss --stdin erzwingen oder Root aus Aufrufer-cwd; super-Abdeckungs-Spiegel: fertiger Bauplan existiert (super_test_coverage_manifest.sh + Job test:coverage-guard, FROZEN-Block 9 Rot-Tests, 3 Beweise) MIT Sonderregeln: ce/prt-art-Submodul-Tests aus Nenner (sonst 313 falsch-ungedeckte); AUSSCHLUSS-Block zaehlt nur wenn verify:gitlink-vs-downstream gruen (Job existiert noch nicht).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Nenner-Verschiebung je neuem ce-Test; Abdeckungswache kann eigene Anwesenheit nicht erzwingen

### [wv3ha243c] 38
GEGENSTAND: contract:axis-version-lock: Doppelschluessel GEHEILT auf development UND (nach FF) main (597ecffe+557d8023, strengere Wirkung, AXIS_ALGO_VERSION: 2, Lock-Regen); offen ist T-i-2 MUTATIONSPROBE: "dass die ueberlebende Definition beisst, ist ungeprueft" (grep axis.?version.?lock ueber Test-Baeume 0 Treffer; gruener Job von inertem ununterscheidbar -- exakt der Ursprungsschaden: 18 Tage nicht vorhanden, 2 semantische Drifts an measurement_curve_loader.hpp ohne Bump durchgelassen 150b0ede 26.07. + 0fdeccff 02.08. -- "Ergebnis-Problem, kein CI-Problem").
ORT: ce .gitlab-ci.yml:447; ce tools/axis_version_lock/ + tests/unit/ (Zielort)
SOLL/FIX: Mutationsprobe ~1-3 h: ein Byte in measurement_curve_loader.hpp ohne AXIS_ALGO_VERSION-Bump aendern -> Lock muss rot; exklusiv eigene Bahn P-LOCK-A ("wer ihn scharfstellt riskiert Rot").
STATUS LT. QUELLE: teilweise (Heilung ja, Biss-Beweis offen)
ABHAENGIGKEIT/FLAECHE: P-LOCK-A separat; ci_yaml_key_guard.sh existiert+verdrahtet (30 Schluessel gruen)

### [wv3ha243c] 39
GEGENSTAND: gitleaks: Submodul-Falle dokumentiert mit Rezept (erster Scan "0 commits scanned" bei Pointer-.git => Hauptrepo mounten + Submodul-Pfad => "5 commits scanned"); Betriebsdoktrin: IMMER mit Repo-.gitleaks.toml UND ueber Push-Inhalt (git log -p remote..HEAD); belegte stille Null war MANUELLER Agentenlauf, NICHT CI ("Kein CI-Job war betroffen"); ob lint:secrets im super Submodule mitscannt: unklar, kein Bericht; WIDERSPRUCH 5: .gitleaks.toml:23-29 traegt ccache-Allowlist mit Kommentar "MUSS hier stehen" gegen A11-"Drop"-Plan -- Owner-Entscheid ob A11 noch gilt.
ORT: .gitleaks.toml:23-29
SOLL/FIX: bei "stille Null"-Auftraegen Bezug klaeren (CI vs Agentenlauf); A11-Owner-Frage stellen; ruckwirkender Pruefauftrag ueber Gate-Zusagen laeuft bereits -- nicht doppelt starten.
STATUS LT. QUELLE: teilweise/unklar
ABHAENGIGKEIT/FLAECHE: ugrep-Falle betrifft nur agenten-gemessene Gate-Zusagen

### [wv3ha243c] 40
GEGENSTAND: owner-entscheide-Inventar (Status lt. Berichten): OFFEN: O-D (xmllint vs 5-6 Fixture-Wachen; Ausweg SKIP-Marker ohne Owner), O-E (falsch gefasst: target_isa-Unterachsen HABEN Konsumenten registry_gen main.cpp:375-376 + numa_page_probe.hpp; Namensfalle alloc_hw.numa_node 152 vs 23 Treffer -- wer ungeprueft anschliesst trifft falsche Achse), O-4, Vormittags-F6+F8, B14-Bump, Map-Gattungs-Kern-Reichweite, E-A..E-F (6 Versions-Interface-Entscheide, "STOPP: ohne Entscheid kein Byte", E-F fehlt in jeder Sammlung), 3 Overlay-Festlegungen (anatomy_fingerprint.hpp:103-107), E7 Multi-Thread, op_types OP-4-Frage, COMDARE_STORAGE_CACHE+MinIO (Zwilling O-C), i-5 Provider-Umkehr, "welche P2-Posten duerfen hinter Messbeginn rutschen", xlsx-in-Abgabe, E14 vor/nach Trigger, N-2 USER-GO 320er-Abgabemessung NIE erteilt. ERLEDIGT: O-G (FF freigegeben; Vollzug wiederholt faellig -- spaeter erneut 10/6 Commits Rueckstand), O-H gegenstandslos, O-3 Loesch-GO erteilt (bedingt: alte Version committed+gepusht), A1-Freigabe, R2 E-18-Zielbranch=development, Vormittags-F1/F3/F4/F5/F7 (F7=Option b), OD-7 streichen (stale), O-F/Shaped-Emission owner-entschieden default-OFF (G-234V-b; Bau-Restposten NACH Abgabe).
ORT: diverse (siehe Journal-Register im Quelltext)
SOLL/FIX: Owner-Vorlage 1D-1 (O-A drei Teilfragen, O-B, O-C, O-D, O-E, O-F, O-3, O-4, O-Token, Anhang-A-Kopplung) -- nie als uebergeben gemeldet.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: W-20: gesamte P0-P4-Prioritaetsordnung auf 08.08. geeicht, Frist ist 15.09. ("groesste stille Fehlerquelle"); E-1 search_algo-Pin BLOCKER (golden_kern:96 binary_search/linear_search vs Registry k_ary/interpolation/eytzinger/linear_scan; validate_profile.hpp:1249-1258 lehnt hart ab)

### [wv3ha243c] 41
GEGENSTAND: P2-Band komplett ungebaut aber Vor-Messbeginn-Pflicht: P2-P8-Schema, xlsx-Lager-Geruest (B12: find Code -iname *xlsx* = nur 1 Doku-Datei), B5, #46b-Rest, G-E3-Host-Binder, Posten 77/78 -- "groesster ehrlicher Riss zwischen Plan und Fenster, gehoert in die Owner-Vorlage, nicht in stille Verschiebung".
ORT: Register P2-P8
SOLL/FIX: Owner-Vorlage.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Messbeginn

## Datei wjjqbvdb7.json (137848 B) -- DEEP RESEARCH: 3-phasig/2-phasig-Fortpflanzung, PMC ins CEB-Pruefdock, ObservableTier-Vertrags-Audit
Struktur: 4 result-Teile: "ph" (Phasen-Fortpflanzung, Stand ce 47c4ef1d/super 72eab9ae), "pmc"
(Mess-Layer/PMC-Nachruestweg), "audit" (ObservableTier-Audit A-1..A-9/G-1..G-6/S0-S5, Stand ce
b241a272), "syn" (Synthese-Plan). Dies ist die ORIGINALQUELLE vieler in wv3ha243c referierter
Befunde -- Details dort teils schon extrahiert; hier die tragenden und NEUEN Posten.

### [wjjqbvdb7] 1
GEGENSTAND: Kanonische Stufen-Doktrin (Owner-abgenommen LEDGER:4082/:4089/:4095): MESS=DREISTUFIG dehnbar (Planer RT-Freigabe -> CEB CT-Einbau inkl. Pruefdock-Konfiguration -> [Hybrid CT] -> Tier CT), SYSTEM=ZWEISTUFIG (CEB RT -> [Hybrid CT] -> Tier CT), ORGAN=ZWEISTUFIG hybrid-unberuehrt; Gesetz: erste Stufe IMMER RT-Freigabe, alle nachfolgenden CT-Einbau; Hybrid = eingeschobene 4. Stufe, erbt ALLES, reicht Mess+System CT weiter, Factory-Pattern-Facade-Adapter, organ-frei. DREI verschiedene drei/zwei-Stufigkeiten im Plan (A Achsen-Doktrin=gemeint, B CI-Legenden-Kette Par.40b/42, C Testat-Klammer-Grammatik Par.62-B). Falle LEDGER:4194: stale mittag-8-Lesart steht in DATEI-Reihenfolge NACH mittag-9/-10, chronologisch aelter, SUPERSEDED.
ORT: LEDGER:4082-4096,:2253,:4194
SOLL/FIX: Phasen==Stufen lesen; nie sequenziell-letzte Ledger-Form uebernehmen.
STATUS LT. QUELLE: nur-hinweis (Definition geklaert)
ABHAENGIGKEIT/FLAECHE: Grundlage aller Mess-Wellen

### [wjjqbvdb7] 2
GEGENSTAND: Kausalkette K1-K7 (aus dem Plan belegt): Mess-Achsen-Aenderung => anderes Messsystem => Messsystem ist CT-Merkmal der CEB (Par.57 LEDGER:3095) => andere CEB-Binary (Planer kompiliert HART je Messsystem, BAUPLAN:243, kein Runtime-Konfigurieren) => andere Pflicht-Ausstattung ALLER Tier-Binaries (Par.62-B LEDGER:3319 Tooling-Konsistenz; Par.64 LEDGER:3402-3404 Ausrichtungs-Mechanik, EIN durchgereichter statischer Draht) => alle Tiers neu; Hybrid erbt und reicht CT weiter. Asymmetrie: System-Achsen-Aenderung ist RT-Freigabe IN der CEB => CEB muss NICHT neu, nur Tiers.
ORT: LEDGER:2498,:2501,:3066,:3069-3070,:3095,:3319,:3402-3404,:4084,:4090; BAUPLAN:243
SOLL/FIX: Owner-KERN (A) exakt gedeckt: bei neuem Messsystem CEB + ALLE Binaries neu.
STATUS LT. QUELLE: nur-hinweis (Soll-Definition)
ABHAENGIGKEIT/FLAECHE: M-1/M-2-Design

### [wjjqbvdb7] 3
GEGENSTAND: Dock-/Stempel-/Replay-Vertraege: Experiment-Dock (Planer->CEB) EINDIMENSIONAL -- existiert NUR als Doku-Beschriftung (IExperimentDock nicht im Baum, BAUPLAN:18); Pruef-Dock (CEB<->Tier) BIDIREKTIONAL real (AbiTierTraceConfig/ComdareResourceControlV1/ComdareTierObserverSnapshot 1416); Stempel: CEB=Mess-Array je EINKOMPILIERTER Achse (Par.58-V), Tier=System-Array+Organ-Array, binary_id Organ-only; Replay Par.62-D: CEB<-Mess, Tier<-System (innerhalb CEB-Sicht), Messwerte<-System+Organ+HW-Identitaet; Sharing stempel-gekeyt, Replay hardware-gekeyt. Hybrid-Vertrag: identitaetserhaltende Delegation, kein eigener ABI-Schritt, einziger Freiheitsgrad = Dock-ANZAHL (std::variant nur im Hybrid erlaubt, in plain Tiers verboten).
ORT: LEDGER:517,:1881,:1985,:3108-3110,:3120-3121,:3345-3354; hybrid-design :22-30,:61-68,:261-270
SOLL/FIX: Vertragsgrundlage fuer M-5/S1; Vermengung Experiment-Dock/Pruef-Dock vermeiden.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: M-5, Hybrid-Wellen

### [wjjqbvdb7] 4
GEGENSTAND: OFFENER WIDERSPRUCH C1 im ce (hoechste Prioritaet der Stufen-Doktrin-Konsolidierung): hybrid-Soll-Design :286-288 sagt Hybrid-Identitaet = normale Tier-Stempel-Form [[System],[Organ]]+SHA512 -- korrekt waere Mess- UND System-Stempel, KEINE Organ-Permutations-Identitaet; Nachzug Posten 90 seit 05.08. offen, per sed an 47c4ef1d verifiziert nicht vollzogen.
ORT: ce docs/architecture/20260802-hybrid_tier_stufe_soll_design.md:286-288; super docs/sessions/backups/20260805-stufen-doktrin-konsolidierung/ce-nachzieh-liste.md:19-39
SOLL/FIX: Doku-Nachzug Posten 90 (D-5 im Diff, Schwere HOCH).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Hybrid-Design; Stempel-Wellen

### [wjjqbvdb7] 5
GEGENSTAND: IST-Stand Fingerprint (an 47c4ef1d gemessen): Mess-Achse IST Tier-Preimage-Glied [3] von 8 (kAnatomyFingerprintGliedCount=8, anatomy_fingerprint.hpp:341,:463-473; dll_is_current fail-closed build_orchestrator.hpp:330-336); NICHT in binary_id (plan-konform, anatomy_version_stamp.hpp:243-244); IM CEB-Preimage aber als ANGEBOT statt WAHL (kCebFingerprint consteval ohne Abhaengigkeit von COMDARE_MEASUREMENT_COMBO_CT -- zwei CEBs [wallclock]/[macro] tragen denselben ceb_key_sha512; Par.58-Verstoss); Objekt-Cache dagegen combo-bewusst (+mtool, artifact_cache.hpp:324) -- zwei Schluessel-Welten.
ORT: anatomy_fingerprint.hpp:341,:425-438,:463-473; ceb_version_stamp.hpp:3-5,:159-161,:199-201; profile_run_facade.cpp:901; artifact_cache.hpp:324
SOLL/FIX: D-4-Fix: CEB-Stempel je einkompilierter Achse rendern; plus CEB-seitiges Skip-Gate fehlt gaenzlich (Neubau haengt nur an ccache/Ninja).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: M-1/D-4

### [wjjqbvdb7] 6
GEGENSTAND: SCHWERSTER Objekt-Befund: Mess-Tooling-Achse hat KEINEN funktionalen Konsumenten (27 Treffer, alle Legende/Stempel/XML-Trage-Pfad; kein Treffer schaltet Messcode); perm_mess_defines() setzt hart -DCOMDARE_MEASUREMENT_ON=1 (+CE_ENABLE_STATISTICS+EXPERIMENT_MODE_ON, konstanter Vier-Define-Vektor) => Tier traegt IMMER volle Observer-Ausstattung egal ob Stempel [wallclock] oder [all]; measurement_line/entries 0 produktive Leser => Tooling-Konsistenz CEB<->Tier (Par.62-B) existiert im Code NICHT; Achse = Etikett (wirkt auf Job-Namen, Stempel, Cache-Keys, measure_host_lane-Maschinen-Zuteilung -- nicht auf das, was gemessen wird). Zusatz: measure_host_lane routet no_extension je Combo (macro->intel, sonst amd) -- Mess-Achsen-Aenderung verschiebt HARDWARE bei unveraenderter Instrumentierung (koppelt KERN C an KERN E).
ORT: profile_run_facade.cpp:273-275; experiment_plan_director.hpp:566-573,:1996-2013; validate_profile.hpp:497-499,:1285-1287
SOLL/FIX: S2.1/S2.2/S2.3 (Define-Satz aus Combo, abi_adapter differenziert, Konsistenz-Gate am Dock).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Owner-KERN (C); alle Mess-Wellen

### [wjjqbvdb7] 7
GEGENSTAND: Neubau-Zahl: Weg (a) heutige P-PMC-1-Bauform = ~13 Treiber-TUs, 0 CEB-Stempel-Aenderung, 0 Tier-Binaries (Flag erreicht g++-Subprozess-Tier-Pfad nicht); Weg (b) plan-konform (PMC in Mess-Haupt-Achse) = ALLE Tiers (131072/524288/2097152 je Lesart) + 6 CEB-Kompilationen je Combo + Neu-Verschluesselung Binaries-Realm; Faktor mindestens 131072:0. Gesamtzahl der Bau-Matrix im Plan selbst als UNENTSCHEIDBAR deklariert (PLAN-thesis-posten:242,:280-283) -- Bericht hat das NICHT aufgeloest (kein Trockenlauf, read-only).
ORT: PLAN-p-pmc-1-messkette.md:428-453,:459-465; experiment_golden_kern.xml:285,:275-278,:363-379,:415-417
SOLL/FIX: Weg-Entscheid Owner (Weg A vs B); Fenster schliesst mit Trigger.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: W-01; Zusatz-Grenze: auch mit Flag bleiben L2/coherence 0 (KERN D separater Posten oberhalb Weg B)

### [wjjqbvdb7] 8
GEGENSTAND: PMC-Kette: die Stufe-1->2-Schiene ist GEBAUT und live (Registry 3 Toolings; 16 Kategorien static_assert; Fan-out measurement_combos_of; ceb_combo_compile_define an allen 4 Emissionen :842/:878/:1195/:1343; CMake-Empfang CMakeLists.txt:143-149; Widerspruchs-Wache measurement_stamp_from_env fail-loud; Stufe 3 Stempel-Zeile) -- PMC faehrt nur nicht darauf (grep -c COMDARE_ENABLE_PMC im director = 0). F2: 16 Kategorien gesetzt, nie gelesen (einziger Leser ein Test). F3: PmcSystemAxis produktiv tot (0 Produktions-Konsumenten); realer Weg daneben: perm_runner.hpp:130 roher IPmcSource*, iterator:481-504 schreibt 8 pmc_*-Spalten unkonditioniert ins CSV an MeasurementCategory/SampleStatus vorbei -- FK-2-Ehrlichkeits-Maschinerie erreicht PMC-Werte nie.
ORT: siehe Gegenstand
SOLL/FIX: PMC-Zustand aus derselben Emissions-Funktion ableiten (N-4.2), pmc_flags.hpp.in nach 27-fach erprobtem Muster (existiert NICHT, einziger nie ausgefuehrter Spec-Schritt; Spec 20260601-26-pmc-counter-beschaffungs-spec.md), Stempel-Segment ergaenzen, Pruefdock-Testat (8. Testat) nach W3-Muster mit Anti-Leerlauf, Invarianten-Test statt Zahl-Pin.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: N-3 vor N-2 vor N-1 vor N-4 (Reihenfolge traegt)

### [wjjqbvdb7] 9
GEGENSTAND: 16-Kategorien-Bilanz (Bezug 16 deklarierte): 3 real immer (CLU, LATENCY_MEAN, THROUGHPUT); 3 real nur mit Flag (L1, L3=LL, DTLB); 1 best-effort (ENERGY_J RAPL); 9 strukturell nicht lieferbar (L2, BRANCH, IPC_CPI, MEMORY_FOOTPRINT, P50/P95/P99/P999, FILL_BUFFER). Registry-XML meldet trotzdem alle 16 enabled=true; KEINE Stelle sagt "diese Kategorie kann diese CEB auf dieser Maschine nicht liefern". Schein-0: system_axis.hpp:410/:413 mark_ok(l2)/mark_ok(branch) sobald irgendein Counter lieferte. Kohaerenz hat keine MeasurementCategory (Kategorie-Erweiterung noetig, N-1, 16->17, bricht compile-hart beabsichtigt, ABI-neutral).
ORT: measurement_axis_registry.xml:11-26; system_axis.hpp:275-420; linux_perf_pmc_source.hpp:152-208,:279-293
SOLL/FIX: N-1..N-4 (Kategorie, Probe via PerfCounter::open je Feld, benanntes Urteil QuelleFehlt/Rechte-fail-loud/Ok, Freigabe+Einbau+Testat); RAW-Codes via /sys/bus/event_source/devices/cpu/events/ beziehen, nie hartkodieren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: M-3/M-14; UNBELEGT: LL==L3 auf prod1/prod2 (lscpu-Probe), sysfs-Events je Maschine, Runner-Rechtelage, P50..P999-Parallelpfad (HdrHistogramm AP-8/#242 nicht ausgeschlossen)

### [wjjqbvdb7] 10
GEGENSTAND: Audit-Abweichungen A-1..A-9 (Stand b241a272): A-1 Achse=Etikett; A-2 Pruef-Dock aus Mess-Weg herausgefallen (iterator:2394 roh, genus() nie gelesen, 4 Dock-Dateien 545 Z. unerreichbar, vierter Layer ohne Eintrittspunkt); A-3 Observer+Operation GETRENNTE Proben (ein tier_observe am Lauf-Ende statt korrelierter Zeitreihe; seg_ns = dritte eigene Treibfahrt in fill_segment_timing_v3 -- Zeiten gehoeren nicht zur gemessenen Op; Trigger-Mechanik existiert nur im toten Dock-Zweig tier_observe_trace_abi.hpp:179/:268); A-4 vierter Layer nicht implementierbar (POD kumulativ, ITierTraceSink 0 Treffer; GenusObserverAggregate gebaut aber Schreiber nur via Container-Docks=nie); A-5 PMC nicht im Dock + Preflight strukturell blind (linux_perf_pmc_smoke unter UNIX-Gate registriert :3568 nicht unter ENABLE_PMC; m3v2:70 seam_ok=available||all_zero => NullPmcSource=SMOKE_OK); A-6 L2/coherence per Entwurf 0, branch_misses nie geschrieben, system_axis-Apparat 0 Produktions-Konsumenten; A-7 Rueckwirkung "neues Messsystem => alle neu" NICHT verdrahtet (Overlay-Glied [7] konstant leer ""; kCebFingerprint per LEDGER:5792 begruendet NICHT im Tier-Preimage; +ceb= handgepflegt; Praezedenz A8-S3 843fe06c aenderte reale Messwerte OHNE Bump -- Cache haette alte DLLs weiter geliefert); A-8 Hybrid existiert nicht (3 Treffer Kommentar/Grammatik); A-9 Capability-Bit fehlt (2 Ursachen 1 CSV-Zelle) + Doku-Drift observable_tier.hpp:17 "Major 6" vs decl:89 Major 8.
ORT: siehe je Punkt
SOLL/FIX: Bau-Anweisung S0-S5 (siehe naechster Posten).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: M-5/M-13; Owner-KERN (C)

### [wjjqbvdb7] 11
GEGENSTAND: Gefahren G-1..G-6: G-1 LIVE systematischer Bias -- 6 von 11 Profilen deklarieren nur wallclock, DLL enthaelt trotzdem vollen Observer-Apparat INNERHALB der Wallclock-Klammer (cacheline_study misst ihr eigenes Messwerkzeug, Bias korreliert mit Achsen-Aktivitaet); G-2 drei Ein-Tool-Combos waeren 393216 Binaries mit identischem Verhalten und verschiedenen Fingerprints (KERN E in beide Richtungen verletzt); G-3 gleicher Fingerprint anderes Messsystem => Cache liefert stille Alt-Daten, gemischte Korpora unter EINER Identitaet; G-4 KERN-Achse des Planers in Thesis nicht belegbar (3 Auspraegungen messtechnisch ununterscheidbar); G-5 Voll-Matrix misst ohne Cache-Zaehler und meldet pmc=ok; G-6 vierter Layer spaeter = zweites Wire-/Major-Ereignis (sizeof!=1344 => Major 8->9 => alle DLLs neu).
ORT: siehe Audit
SOLL/FIX: S-Stufen; G-1-Groesse UNBELEGT bis S2.1-Biss (nm/readelf [wallclock] vs [all]).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Messfenster; O-A

### [wjjqbvdb7] 12
GEGENSTAND: Bau-Anweisung S0-S5 mit Rebuild-Bilanz: S0 Ehrlichkeit sofort (S0.1 Flag in alle 4 Emissionen + Emissions-Test; S0.2 Preflight scharf inkl. Gegenprobe Bau-ohne-Flag=>rot; S0.3 branch_misses real ODER n/a + Kommentar korrigieren; S0.4 L2+Kohaerenz RAW hinter HwDetect-Factory nie statisch, sonst mark_source_unavailable; S0.5 Doku-Drift Major 6->8) -- Rebuild Host/CEB, Tiers unberuehrt, Fingerprints bewegen sich NICHT => S4 Pflicht; S1 Dock zurueck in Mess-Weg (S1.1 select_for statt acquire; S1.2 pruef_only faehrt 7 testat_*; S1.3 PMC-Testat als 8.; S1.4 Capability-Bit MIT S3 buendeln); S2 Achse zum Traeger (S2.1 Define-Satz; S2.2 IObservableTier nur bei Micro-Anteil; S2.3 Konsistenz-Gate; S2.4 Tooling-ids validieren gegen Registry -- heute faellt "wallclok" still auf @0.0.0; S2.5 Par.64 Default Vollmenge EINE CEB) -- Rebuild CEB+ALLE Tiers; S3 EIN ABI-Major 8->9 gebuendelt (korrelierter Observer-Kanal, vierter Layer, seg_ns ehrlich, Capability-Bit; golden-CRC neu = Owner-Fenster F5); S4 Rueckwirkungs-Kopplung (S4.1 Overlay-Glied scharf -- 3 Owner-Festlegungen :103-107 nicht raten; S4.2 kCebFingerprint-Weg = Owner-Entscheid); S5 Hybrid erst nach S2/S3.
ORT: Audit-Teil, Tabellen S0-S5
SOLL/FIX: verbatim uebernommen (siehe Gegenstand); Reihenfolge zwingend.
STATUS LT. QUELLE: offen (nichts gebaut)
ABHAENGIGKEIT/FLAECHE: F6 offen (S2 setzt Par.47 voraus); Overlay-Owner-Entscheid

### [wjjqbvdb7] 13
GEGENSTAND: Synthese-Plan geschrieben: docs/plaene/20260806-PLAN-messkette-ceb-observabletier.md (1019 Z., untracked ??, NICHT committet -- Verlustrisiko). STAND-KORREKTUR: ce Checkout==origin/development==b241a272 (+6 gegen 47c4ef1d das nur noch origin/main ist); super lief waehrend der Arbeit 3x weiter (699edaa2 -> e110cf6d -> 4589e079), parallele Instanz committet; super-Gitlink zeigt 47c4ef1d vs Checkout b241a272 = 6 Commits Drift vorwaerts, uncommittet; main-FF-Rueckstaende ce 6, super 12. Zeilendrift: Mess-Fenster :1367-1369 -> :1365.
ORT: docs/plaene/20260806-PLAN-messkette-ceb-observabletier.md
SOLL/FIX: Plan committen; Gitlink nachziehen; Zeilen-Anker je Stand neu verifizieren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: alle Anker-Zeilennummern altern

### [wjjqbvdb7] 14
GEGENSTAND: Buendel-Reihenfolge der Synthese: M-1 IDENTITAETS-NAHT -> M-6 XML-TRENNUNG -> M-2 PMC-INVARIANTE -> M-3a/d branch_misses+RAPL-Probe -> M-5a DOCK-TESTAT = ALLES EIN Buendel, EIN Branch, EIN Voll-Gate, EIN Bump (Datei-Kollision: M-1c, M-6, M-2 schreiben alle experiment_plan_director.hpp). Nachgelagert ohne Flotten-Folge: M-3b/c (L2+Kohaerenz T2), M-5b (Loop-Umbau T2), M-5c (4. Layer T3). Neubau-Klassen: CEB-ONLY (M-6, M-2, M-3a/b/c, M-5a/b: 1 CEB, 0 Tiers, ~77 s) / TIER (M-1a, M-5c: 524288, ~34,4 h) / FINGERPRINT (M-1b, M-1c: heute 0 h, nach erstem Batch 34,4 h + Messdaten wertlos). Eigene Messung: find *.fingerprint = 0 -- Fenster offen, schliesst mit erstem Sidecar (schreibt auch provision_only-Bau, build_orchestrator.hpp:378-385).
ORT: Synthese-Plan Abschnitt 2/3
SOLL/FIX: buendeln was TIER oder FINGERPRINT ist; CEB-ONLY nachziehbar AUSSER M-3b/c (Datenbruch: Spalten-Semantik vor/nach -- muss vor der zu behaltenden Messung stehen).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Kadenz: Fr 07.08 K-1..K-5, Fr 14.08 Buendel L-1 Format 4, Fr 21.08 Voll-Bau+Messbeginn+M-3b/c, ... Di 15.09 Abgabe; setzt R-1-Weg (C) voraus

### [wjjqbvdb7] 15
GEGENSTAND: KORREKTUR am Vertiefungs-Plan: "PMC = KLASSE ALPHA (entwertet 100% der Flotte)" ist AM OBJEKT FALSCH -- add_compile_definitions(COMDARE_ENABLE_PMC) wirkt nur auf CMake-Teilbaum/Treiber; Tier-.so entsteht via eigenem g++-Subprozess (grep 0), perm_mess_defines fuehrt das Flag nicht => PMC ist heute CEB-ONLY (1 CEB, 0 Tiers). Buendelung bleibt trotzdem zwingend, WEIL M-1b es zur Identitaet erhebt. Richtige Formulierung: "PMC ist heute billig und wird durch M-1 teuer."
ORT: 20260806-PLAN-owner-antworten-vertiefung.md Par.2.5 (korrigierte Stelle); CMakeLists.txt:77; build_orchestrator.hpp
SOLL/FIX: Klassen-Zuordnung in Plaenen korrigieren.
STATUS LT. QUELLE: teilweise (Korrektur dokumentiert, Plaene nicht angepasst)
ABHAENGIGKEIT/FLAECHE: W-01/W-02-Aufloesung

### [wjjqbvdb7] 16
GEGENSTAND: Weg K (Kalibrier-Batch Fr 07.08.): K-1 Gitlink-Nachzug (Minuten), K-2 super-Push + main-FF beide Repos (~1 h), K-3 PMC-Flag als Invariante in die 4 Emissionen + Test (halber Tag, CEB-ONLY), K-4 RAPL-Probe + Zugriffs-Beweis beide Lanes (Minuten), K-5 EINE 4096er-Scheibe deklariert VERWERFBAR (~20-33 min). Volles Buendel passt NICHT bis morgen (7 Pakete, 2 mit neuer Grammatik/Format-Bump, max EIN ce-Voll-Gate). Begruendung gegen "nur M-1b sofort": Format-Bump erst richtig, wenn feststeht WAS er stempelt (M-1a Define-Satz + M-3 Zaehler-Menge); Preimage zweimal anfassen kostet 34,4 h + gebaute Scheibe. Datums-Korrektur: 07.08. ist Freitag, 08.08. Samstag (alte Plaene: beide Wochentage falsch).
ORT: Synthese Abschnitt 4
SOLL/FIX: verbatim Weg K.
STATUS LT. QUELLE: offen (Vorschlag)
ABHAENGIGKEIT/FLAECHE: O-5

### [wjjqbvdb7] 17
GEGENSTAND: Owner-Entscheide der Synthese (5 neue; R-1/R-2/R-3 bleiben offen): O-1 allow_failure (:1333) entfernen? Empfehlung Weg A entfernen mit L-1 (#278 verlangt 0 allow_failure; Code-Begruendung ist Zell- nicht Job-Doktrin; 20 Ledger-Treffer, keiner autorisiert die Zeile) T1; O-2 PMC-Wache fail-closed? JA aber erst NACH Zugriffs-Beweis K-4 T1; O-3 Zaehler-Menge dreiteilig: (a) branch_misses jetzt JA (generisch, kein RAW), (b) L2+Kohaerenz JA als T2 mit Intel-Vorbehalt (14900KS-RMA bis ~September, LEDGER:865-872), (c) Fingerprint traegt Zaehler-Menge? NEIN -- er traegt den Define-Satz (haelt M-3b/c nachziehbar); O-4 vierter Observer-Layer (Klasse TIER 524288): Empfehlung B deklarierte zweite Bau-Kampagne (A = ~3 Wochen Verschiebung ohne fertiges Design; C Verzicht) bis Fr 14.08.; O-5 Kalibrier-Batch: Empfehlung verwerfbar (Weg K), Auflage: Verwurf VOR dem Batch schriftlich (Ledger+Checkliste); verworfen werden Binaries+Sidecars, NICHT Messwerte (CSV additiv als "Format 3 / Vor-L-1" sichern) HEUTE ABEND.
ORT: Synthese Abschnitt 5
SOLL/FIX: verbatim.
STATUS LT. QUELLE: offen (Owner)
ABHAENGIGKEIT/FLAECHE: R-1/R-2/R-3 weiter offen; UNBELEGT-Liste: 34,4 h, ~77 s, 109,4 ms, Runner-Rechtelage/RAPL-AMD, LL==L3, Defines ausserhalb perm_mess_defines, Ebene-B-Bestand

### [wjjqbvdb7] 18
GEGENSTAND: PMC-Preflight-Blindstellen konkret: linux_perf_pmc_smoke unter if(UNIX AND NOT APPLE) registriert (tests/unit/CMakeLists.txt:3568 -- Audit-Zeilennummer; B5(a) anderswo nennt :3553), nicht unter COMDARE_ENABLE_PMC -- baut immer, meldet ohne PMC "sauberer Skip Exit 0"; m3v2_pmc_smoke.cpp:70 pmc_seam_ok = delta.available || counters_all_zero -- NullPmcSource (available=0, alles 0) => SMOKE_OK. Testat kann den Fehlzustand, gegen den es gebaut wurde, nicht anzeigen. Flag gesetzt nur in super .gitlab-ci.yml:677 (measure:smoke DEPRECATED) + :768 (measure:golden-320) + ce .gitlab-ci.yml:119 (.pmc-Gate).
ORT: siehe Gegenstand
SOLL/FIX: S0.2 + kPmcExpected-Weg (Konflikt mit B5(a)-Fassung beachten -- siehe wv3ha243c Posten 11).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: M-2

## Datei wr08h0dkm.json (98522 B) -- Explore-Fanout: "sind meine offenen Fragen laengst geplant?" (7 Lose)
Lose: plattform-matrix, gattung-container, fenster0-preimage, baumenge-messumfang, auswertung-hybrid,
thesis-hypothesen, core-achse-pinning. Status-Vokabular: GEPLANT_UND_BEANTWORTET / TEILWEISE_GEPLANT / ECHT_OFFEN.

### [wr08h0dkm] 1
GEGENSTAND: Plattform-Matrix (a/b): 7-vs-8-Distro-Zahl MEHRFACH und verschieden gescoped (User-Direktive 03.07. + Ledger 21.07. sagen 8 = Ubuntu+7; reale Cluster-Buildtools-Liste = 7 benannte Images debian-sid/ubuntu-2404/fedora-42/alpine-321/archlinux/opensuse-tw/rocky-9; ce-eigene reale Testmatrix = 18 Images 6x3; 8er-Liste gehoert zum SEPARATEN Produkt comdare-db, dort nicht final); Diskrepanz ist selbst als offenes Gate W10-00 gefuehrt und auf NACH DER ABGABE vertagt; Thesis committet sich auf KEINE Zahl; keine Liste als DIE massgebliche markiert.
ORT: LEDGER:3364,:5423-5424,:5540; docs/sessions/20260706-276-VOLL-PLATTFORM-MATRIX.md
SOLL/FIX: nicht neu entscheiden -- als erkannt+geparkt behandeln.
STATUS LT. QUELLE: teilweise (geparkt NACH ABGABE)
ABHAENGIGKEIT/FLAECHE: W10-00/#276

### [wr08h0dkm] 2
GEGENSTAND: Windows auf prod1/prod2 (c): GEPLANT+BEANTWORTET -- Zugang per VM (KVM, 12vCPU/12G), 4 Windows-VMs existieren als eigene GitLab-Runner (id53 prod1-win2022, id55 prod1-win11, id54 prod2-win2022, id19 prod2-win11); Stand 26.07. nur id19 online, drei registriert-nie-verbunden (Auth-Token-Reset + Vault-Creds + In-VM-runner-Install fehlen); 0 Windows-Jobs in der ce-Mess-CI.
ORT: Cluster docs/sessions/2026-07-26-INFRA-runner-matrix-DONE.md:26-31,:97-104
SOLL/FIX: Verdrahtung in Mess-CI aussteht (kein Termin).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Plattform-Matrix Stufe 2

### [wr08h0dkm] 3
GEGENSTAND: macOS/RISC-V/Pi5 (d): physisch vorhanden, T6 "9 Pflichtplattformen" unwiderrufen ABER als SELBSTAUFLAGE (nicht Betreuer-Auflage) eingestuft -- Empfehlung "als vorbereitete, nicht eingeloeste Matrix ausweisen"; Mess-Modus fuer diese Maschinen nirgends benannt. (e) DEBUG-MODE-MESSUNG als "OS support build": ECHT_OFFEN -- keine Definition, keine CSV-/Anhang-Kennzeichnung; Owner-Aussage ist neue Synthese, nicht fixierte Regel.
ORT: docs/plaene/20260806-KANON-termine-plan-soll-gegen-ist.md:166-171,:817
SOLL/FIX: (e) muesste neu definiert werden (CSV-Spalte/Kennzeichnung), falls gewollt.
STATUS LT. QUELLE: (d) teilweise, (e) offen
ABHAENGIGKEIT/FLAECHE: Debug/Mess-Modus-Doktrin (Threading) ist NICHT dasselbe

### [wr08h0dkm] 4
GEGENSTAND: Talos (f/g): Owner-Formulierung deckt sich fast woertlich mit comdare-db-SOLL (ANDERES Produkt); fuer die Diplomarbeit das GEGENTEIL: Thesis behauptet an 6 Stellen (3 Positionen DE+EN, Praesens Passiv + Allquantor "jede Messung") Talos+root-Linux-Zweiregime als ERFUELLTE Praxis -- Audit F-01: 0 Code-/CI-/Datenspur, "Falschaussage, nicht unerfuellte Planung"; Empfehlung (b) zurueckziehen statt bauen; Owner-Entscheid O-1 auf "Freitag 1 07.08." terminiert. Talos laeuft als VM/K8s auf beiden Maschinen (Infra da, nicht eingehaengt).
ORT: thesis kapitel/de/01_einleitung.tex:225-226; 05_evaluation.tex:83-86; anhang E ADR-12; DIFF-thesis-soll:64-83,:328-334,:798-802
SOLL/FIX: O-1: Aussage zurueckziehen (Empfehlung b) ODER bauen -- Owner faellig.
STATUS LT. QUELLE: offen (Owner-Entscheid)
ABHAENGIGKEIT/FLAECHE: Thesis-Ehrlichkeit; heutige Owner-Aussage koennte die Entscheidung sein -- gegen O-1-Katalog abgleichen

### [wr08h0dkm] 5
GEGENSTAND: Pilot-Ansatz (h): Struktur "prod1/prod2 zuerst, Rest nach Abgabe" mehrfach festgelegt ohne das Wort Pilot (#276/W10-00 = LETZTE Ledger-Aufgabe, NACH DER ABGABE; 6-Freitage-Fahrplan nur AMD/Intel-x86).
ORT: LEDGER:5540; 20260706-276:3,:49; DIFF:705-789
SOLL/FIX: keiner (dokumentiert).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -

### [wr08h0dkm] 6
GEGENSTAND: Gattung/Genus (a/b): Zwei-Ebenen-Modell im Code umgesetzt (Gattung Map|Container|Graph-Stub; Genus SearchAlgorithm in Map, Set/Sequence/Adapter/View in Container; C7-1-Umbenennung vollzogen anatomy_base.hpp:50). SwissTable liegt NICHT unter Container -- Owner-Vermutung widerlegt: S22 unter Genus SearchAlgorithm/Gattung MAP (3 Quellen konvergieren; gebundener Thesis-Text "innerhalb der SearchAlgorithm-Gattung", "keine eigene Gattung").
ORT: anatomy_base.hpp:49-134; tier_to_organ_mapping.hpp:82; kapitel/de/03_messsystem_prtart.tex:395-406,:457
SOLL/FIX: keiner (beantwortet).
STATUS LT. QUELLE: behoben/beantwortet
ABHAENGIGKEIT/FLAECHE: C7-Auflagen bindend

### [wr08h0dkm] 7
GEGENSTAND: flat_hash_map (c/d): Aufgabenstellungs-Zusage WOERTLICH auffindbar (aufgabenstellung/de.tex:113-114: "nicht-baumartige Hash-Tabelle (flat_hash_map) als Gegenprobe innerhalb derselben Gattung"); am Code existiert flat_hash_map NICHT (0 Treffer), real = eigene SwissTable-Reimpl S22 mit AP-7b-Mess-Pfad offen; doktrinaere Grundlage der Owner-Argumentation existiert (Substitutions-Prinzip LEDGER:3817/:3898 + vendor->faithful->self-Doktrin), aber KEINE Stelle verknuepft sie explizit mit flat_hash_map/"verzerrt die Messung"; urspruengliche Termin-3-Zusage (echter Wrapper, Pflicht) widerspricht der spaeteren Linie; O-2 (bauen/Text nachziehen/beides -- Empfehlung c beides: Baustein bis 21.08., Abweichung benennen) faellig 07.08.
ORT: aufgabenstellung/de.tex:113-114 en.tex:104-105; axis_03a_search_algo_swisstable.hpp:12-19; GESAMTDOSSIER:2598
SOLL/FIX: O-2 Entscheid; Empfehlung (c) beides.
STATUS LT. QUELLE: offen (Owner)
ABHAENGIGKEIT/FLAECHE: Thesis-Aufgabenstellung = bindender Pflicht-Abgabetext

### [wr08h0dkm] 8
GEGENSTAND: Fenster-0/Preimage D-1: PMU-Domaene (cpu_core/cpu_atom) gehoert lt. fertiger Empfehlung als Feld in die MESS-Identitaet (Zeilenschluessel: binary_fingerprint, Maschine, pe_policy, pmu_domain, Mess-Setting), NICHT ins Preimage/binary_id (sonst 524288 Phantom-Binaries); EINE CEB, dieselbe Tier-Binary zweimal gepinnt = Permutation, kein zweiter Bau (KERN 5/6 korrigierte "zwei CEB-Kompilate"); als offener fensterkritischer Owner-Entscheid D-1 gefuehrt (VOR DEM ERSTEN BATCH; heute 0 Sidecars = 0 h, danach 34,4 h + alle Messdaten).
ORT: GESAMTDOSSIER:737,:1979,:2632; PLAN-hybrid-architektur-pmc:810-812
SOLL/FIX: Empfehlung ratifizieren lassen VOR erstem Batch.
STATUS LT. QUELLE: offen (Empfehlung fertig, nicht ratifiziert)
ABHAENGIGKEIT/FLAECHE: Fingerprint-Fenster; O-C/pe_policy

### [wr08h0dkm] 9
GEGENSTAND: R-3 Mess-Defines im Fingerprint: dediziert durchgeplant (8-Glieder-Liste; weder Glied [3] noch Toolchain-Glied tragen MEASUREMENT_ON/ENABLE_PMC; Empfehlung Feld "mess" in Glied [5] + Format-Bump 3->4) -- NICHT umgesetzt: gelandetes Paket ce bba4d90f verzichtete auf Bump gestuetzt auf "Glied [3] traegt die Mess-Zeile bereits"; juengster Stand widerspricht der Begruendung selbst ("nicht weil Glied [3] fehlt, sondern weil es NICHT AUSREICHT... Der Posten bleibt offen") = im Korpus benannter UNGELOESTER Widerspruch zweier Deep-Research-Staende.
ORT: PLAN-owner-antworten-vertiefung.md:212-244; GESAMTDOSSIER:1460-1463,:2166; ce bba4d90f
SOLL/FIX: Widerspruch aufloesen (Owner R-3); Posten offen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: M-1/W-02; SHA-Behauptung bba4d90f = gelandetes M-1-Paket OHNE Format-Bump

### [wr08h0dkm] 10
GEGENSTAND: B-4 Break-Even-Tabelle als Lager-Objekt mit eigenem Schluessel: wortwoertlich als Posten gefuehrt, Empfehlung fertig ("Lesen und ablegen, nicht verwalten; sonst hat das Ergebnis keine Identitaet, Reproduzierbarkeits-Doktrin greift nicht"); einzige der 6 Planungs-Rueckfragen die fensterkritisch ist (mit D-1 in "vor der ersten .fingerprint-Datei"); alle 6 ausdruecklich UNBEANTWORTET (Owner erbeten 06.08. 23:47).
ORT: GESAMTDOSSIER:2600-2613,:2678
SOLL/FIX: Owner-Ratifizierung vor erstem Batch.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: best_binary_selector O-100; Lager

### [wr08h0dkm] 11
GEGENSTAND: D-2 Bau-Menge: Herleitung doppelt dokumentiert (Ledger N-4 + PLAN R-4): 524288 kanonisch, KEINE Kappung, 2097152 = Kommentar-Deklaration eines nicht gelesenen Kanals, "gekappt auf 131072" zurueckgezogen; ABER juengstes Dokument (GESAMTDOSSIER 07.08. 01:04) fuehrt D-2 weiter als offenen roten Owner-Entscheid ("Erst messen, dann entscheiden -- Binaries zaehlen statt addieren 2-3 h; cap muss wirken oder laut abgelehnt werden") und nutzt 524288 zugleich als Arbeitszahl.
ORT: LEDGER:4964-5005; PLAN-owner-antworten-vertiefung:264-288; GESAMTDOSSIER:2633
SOLL/FIX: Trockenlauf/Zaehlung vor erstem Batch; formale Ratifizierung.
STATUS LT. QUELLE: teilweise (Empfehlung klar, Ratifizierung offen)
ABHAENGIGKEIT/FLAECHE: T-0(a)/B-1

### [wr08h0dkm] 12
GEGENSTAND: D-3 Mess-Teilmenge: Weg C geplant (320er tief volle 216er-Kartesik ~2,1 h + flacher 9er-Sweep ueber ALLE 524288 ~3,0 d = ~3,1 d gegen 71,7 d Vollmessung bei ~40 Tagen) -- einzige Variante die 15.09. haelt, deckt Thesis-Zusage; als offener roter Owner-Entscheid vor erstem Batch.
ORT: PLAN-owner-antworten-vertiefung:74,:143-146; GESAMTDOSSIER:2634
SOLL/FIX: Weg C ratifizieren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: R-1

### [wr08h0dkm] 13
GEGENSTAND: Mess-Slicing 4096 (c): GEPLANT+GEDECKT durch woertliche Owner-Doktrin ("maximal 4096 jobs fuer compile und Messung", ARBEITSWEISE-GESAMT-DOKTRIN.md:360); heute nur Bau-Seite umgesetzt; benannter Bau-Posten B-E (ce-Voll-Gate).
ORT: ARBEITSWEISE-GESAMT-DOKTRIN.md:360; PLAN-owner-antworten-vertiefung:182-186,:483
SOLL/FIX: B-E bauen.
STATUS LT. QUELLE: offen (Umsetzung)
ABHAENGIGKEIT/FLAECHE: M-6/B-3 (identischer Posten)

### [wr08h0dkm] 14
GEGENSTAND: T-5 Wiederholungen: Owner-Entscheid E3 (16.07., LEDGER:534) = 3 Wiederholungen PFLICHT (ersetzt Betreuer-5); Profile count="3"; real gefahren 1 (repetition=0 in allen Zeilen) = dokumentierte Abweichung; Empfehlung: bei 3 bleiben, Abweichung von 5 im Methodikkapitel benennen, mindestens 3 tatsaechlich fahren (Termin 04.09.).
ORT: LEDGER:534; all_axes_golden.profile.xml:160; KANON:511,:720,:859-862; GESAMTDOSSIER:2650
SOLL/FIX: n_repeats>=3 Pflicht-Validierung im Experiment-Pfad; 3 real fahren.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Welch-Auswertung auf WIDE-CSV

### [wr08h0dkm] 15
GEGENSTAND: F4 Lager-Orchestrierung (a): Rolle entschieden (O-100: best_binary_selector nimmt Messwerte + orchestriert Auswahl+Berechnung UEBER das Lager, keine eigene Break-Even-Rechnung); Mechanismus teils gebaut (TiereDllRepository + ShippedArtifactBuilder publizieren gewaehlte Binary mit Sidecars+Manifest); Hybrid liest per binary_id aus dem Lager (Pull); einzige echte Luecke: umfasst "Orchestration" auch aktives Schreiben IN die (ungebaute) Hybrid-Struktur? -- nur Lead-Empfehlung B-4, unbestaetigt.
ORT: GESAMTDOSSIER:768,:916-921,:2609; hybrid-Soll-Design Abschnitt 6 Punkt 5; 20260807-BILANZ-vergessene-arbeit.md:327-329
SOLL/FIX: B-4-Ratifizierung.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Hybrid HY-B*; Lager

### [wr08h0dkm] 16
GEGENSTAND: F2 Messpunkt ans Pruefdock (b): zwei Owner-Quellen fuer "testiert/benennt, wandert NICHT" (Mai-Direktive "KEIN NEUBAU nur Benennung"; Owner-Klarstellung 23:28:07Z "Micro-Wallclock zusaetzlich IN der Tier-Binary, ansonsten wie gehabt in der CEB"); juengste Analyse fuehrt Frage trotzdem offen (measure()-Vertrag pruef_dock.hpp:74-79 erlaubt beide Lesarten; muss E2 zwingend durch IPruefDock::measure()?).
ORT: GESAMTDOSSIER:626,:630,:661,:740; pruef_dock.hpp:4-8,:74-79
SOLL/FIX: operative Festlegung vor M-5-Bau.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: M-5/S1.1

### [wr08h0dkm] 17
GEGENSTAND: F5 CT-Schaltlogik vs RT-Dock-Tausch (c): Architektur Owner-entschieden+eingefroren (E1 02.08.): Router = CT-Chain-of-Responsibility; physischer Tausch der plain-Tier-Binary = RT (dlopen/dlclose via HybridBinaryProxy); std::visit nur zu Umschalt-Zeitpunkten, Hot-Path variant-frei; offen NUR B-5: Break-Even-SCHWELLENWERTE einkompiliert (CT) oder zur Laufzeit aus Lager? -- ausdruecklich bis nach Abgabe offen gelassen, entscheidet Bauform von HY-B2.
ORT: hybrid-Soll-Design:1-7,:22-30, Abschn. 3.2/3.4; GESAMTDOSSIER:2610
SOLL/FIX: B-5 buchen, nach Abgabe entscheiden.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: HY-B2

### [wr08h0dkm] 18
GEGENSTAND: T-8 "beste Binary": ENTSCHIEDEN Pareto-Front (Fork H6, User 10.07., ALLE 7 Fork-Entscheidungen getroffen; tuple<property,time,objective_tag> + Front-Menge je Schluessel, keine Mittelung); Caveat: heutiger Code rank_binaries im best_binary_selector implementiert de facto Einzelsieger je Metrik = Bau-Rueckstand gegen getroffenen Entscheid.
ORT: docs/architektur/21_SESSION_PLAN_TYPSYSTEM_ACHSEN_ENTSCHEIDUNGEN.md:40,:49; GESAMTDOSSIER:950,:2653
SOLL/FIX: rank_binaries auf Pareto-Front umbauen (Bau-Rueckstand, keine Planungsfrage).
STATUS LT. QUELLE: offen (Implementierung)
ABHAENGIGKEIT/FLAECHE: Auswertungsphase

### [wr08h0dkm] 19
GEGENSTAND: T-9 Min/Max-Katalog: EXISTIERT vollstaendig (DOSSIER 04.08., T0-T17 je Achse explizite Min/Max-Zeile, multi-objektive T5/T6/T18 als Pareto; Doktrin "Min/Max erforschen nie erfinden" LEDGER:431); Caveat: Katalog NICHT in break_even.hpp eingespeist -- dort pauschal "kleinerer y-Wert = besser" (Implementierungsluecke).
ORT: docs/sessions/20260804-DOSSIER-achsen-qualitaets-parameter-katalog.md; heuristik/break_even.hpp:17
SOLL/FIX: Katalog in Break-Even-Code einspeisen.
STATUS LT. QUELLE: offen (Implementierung)
ABHAENGIGKEIT/FLAECHE: T-8/Pareto

### [wr08h0dkm] 20
GEGENSTAND: T-10 Last-Erkennungsheuristik: Design EXISTIERT entgegen Lead-0-Befund -- 327-zeiliger committeter Deep-Research-BEFUND 09.07. (docs/audits/20260709-workload-cluster-research-BEFUND.md, Commit c9536bb0): Merkmalsvektor, offline agglomerativ+k-Means, online modifiziertes DBSCAN (QueryBot-5000), Nearest-Cluster + sicherer Default bei noise; von PLAN-messkurven-synthese S-3 und GESAMTDOSSIER T-10 wegen Terminologie uebersehen ("Workload-Cluster" statt "Last-Erkennung") = klassische Gedaechtnisluecke; Status [EMPF]/[LIT] nicht Owner-ratifiziert; Umsetzung erst NACH E4->E1 + Messlauf #156.
ORT: docs/audits/20260709-workload-cluster-research-BEFUND.md (:131-144,:225-266); Gegenprobe-Nenner 1124 md-Dateien, 2 Treffer
SOLL/FIX: BEFUND als Vorarbeit ziehen, nicht neu entwerfen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Hybrid-Auswertung

### [wr08h0dkm] 21
GEGENSTAND: W-3 Akzeptanzkriterium Ebene 2: KERN 11 (23:20:06Z, Checkpoints innerhalb des Aufrufs) vs KERN 12 (23:26:59Z, ein Zeitpunkt je Aufruf) -- 6 min 53 s auseinander, beide woertlich; niemand hat entschieden welches das Abnahmekriterium ist; als offener Owner-Entscheid Fenster "vor Freitag 3 (21.08.)"; "juenger schlaegt aelter" waere unzulaessige Extrapolation.
ORT: GESAMTDOSSIER:254-257,:2656
SOLL/FIX: Owner-Entscheid W-3.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Observer-Ebene-2-Bau

### [wr08h0dkm] 22
GEGENSTAND: Thesis-Hypothesen: C-4 H2 (Score<->Durchsatz) -- Durchsatz-Spalte existiert nicht; Kriterium: Spalte bis Fr 2 (14.08.) bauen + Score auf cppcheck umschreiben; steht sie nicht bis Fr 3 (21.08.) => H2 streichen. C-5 LP02/03/07/13 -- textlich vollstaendig in 14er-Tabelle, fehlen NUR als Profil-XML (real 10 von 14; ~0,5-1 Tag reine XML-Arbeit, Termin 21.08.). C-6 PRT-ART: ChainRef bauen (traegt H3), Prefetch textlich zuruecknehmen; Termin 28.08. -- danach faellt H3.
ORT: kapitel/de/05_evaluation.tex:13-14; 03_messsystem_prtart.tex:359-380; DIFF:605,:828-843; GESAMTDOSSIER:2622-2624,:2681
SOLL/FIX: verbatim je Posten.
STATUS LT. QUELLE: offen (terminierte Lead-Empfehlungen)
ABHAENGIGKEIT/FLAECHE: H2/H3-Hypothesen; Freitags-Kadenz

### [wr08h0dkm] 23
GEGENSTAND: O-4 Anhang-A-Reichweite (d): zahlengenaue Soll-Empfehlung existiert (44 Fragmente je Sprache: 16 hart via input, 28 weich via InputIfFileExists; 28 fehlende = 23 Gate-8 + 5 aeltere #24; Lead WEG 1 = bei 16/44 bleiben + 16. Limitierungs-Zeile in le_limitierung.tex DE+EN) -- kein bestaetigter Abschluss; DREI abweichende Zaehlungen im Korpus (28/41 vs 16/44 vs 16+23=39).
ORT: PLAN-thesis-posten:111-207; FAHRPLAN:512; ANKNUEPFPUNKTE:1259; UEBERBLICK:474-476
SOLL/FIX: Owner-Entscheid O-4; Zaehlungen abgleichen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: W-14 (28/28-Generator-Lauf aus wv3ha243c widerspricht der 16/44-Praemisse teilweise)

### [wr08h0dkm] 24
GEGENSTAND: T-1 Abgabe-Begriff (e): Endtermin 15.09.2026 mit woechentlicher Freitagslieferung dreifach belegt; UNGEKLAERT was O-095 "nach der Abgabe morgen" (06.08. 23:06) bedeutet -- ob 07./08.08. ein Betreuer-Dokument abgeht; als ungeloeste Mehrdeutigkeit mit Fenster "sofort" gebucht, keine Aufloesung in juengsten Dokumenten. Namensfalle: "T-1" existiert doppelt (Termin-Frage vs Git-main-FF-Kette).
ORT: KONTEXTUEBERGABE-abend-praezise.md:67-68; LEDGER:4867-4890; GESAMTDOSSIER:756,:2515,:2646
SOLL/FIX: klaeren ob Betreuer-Dokument am 07./08.08. abgeht.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: W-20-Termin-Eichung

### [wr08h0dkm] 25
GEGENSTAND: C-1/C-2 Thesis-Textkorrekturen: C-1 Aufgabenstellung verspricht "alle erdenklichen Binary-Permutationen", Kapitel 3 gesteht "gedeckelte Teilmenge" -- Aufloesung: Deckelung ausdruecklich gegen Aufgabenstellungs-Wortlaut stellen (Textkorrektur, Termin 07.08.); C-2 "std::map-Vertrag" mehrdeutig -- Code prueft 5 Kern-Ops (conformance_gate.hpp:10), Fazit :101 nennt 17 als Folgeschritt -- Aufloesung: Formulierung auf "Kern-Vertrag (Einfuegen, Suchen, Loeschen, Leeren, Groesse)" praezisieren, 17 als Folgeschritt daneben (07.08., "Freitag 1 < 1 Arbeitstag gesamt").
ORT: aufgabenstellung/de.tex:74-75; 06_fazit.tex:91-101; conformance_gate.hpp:10; DIFF:811-821; GESAMTDOSSIER:2619-2620
SOLL/FIX: beide Textkorrekturen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Thesis-Ehrlichkeit

### [wr08h0dkm] 26
GEGENSTAND: D-7 Core-/Pinning-Achse: ENTSCHIEDEN zugunsten Achsen-Dossier-Faktorisierung {Unpinned|PCoresOnly|ECoresOnly|HybridAware} (PeCorePolicySubAxis) gegen Betreuer-Plan {P|E}x{Single|All}+Referenz (Rangfolge V.2: Dossier 16.07. Rang 2, Termin 3 09.04. Rang 3; KERN 7 definiert "kann nicht pinnen" als gueltigen WARN-Zustand => Unpinned unverzichtbar); Code: nur HeteroCoreDispatch::None hart, Unter-Achse UNGEBAUT ("vor dem Bau der Unter-Achse"). P/E-Trennung ist PFLICHT dreifach fixiert (Termin-3-Regel+Pflichtachse+Risikotabelle "strikte Trennung cpu_core/cpu_atom"; Thesis 05_evaluation.tex:76-78; Owner KERN 4 06.08. verbatim).
ORT: scheduling_strategy.hpp:39 (DEPRECATED); scheduling_system_axis.hpp:76-78; system_axis_registry.xml:34; GESAMTDOSSIER:2638,:453; e17-e18-DOSSIER:11
SOLL/FIX: Unter-Achse nach Dossier-Faktorisierung bauen.
STATUS LT. QUELLE: teilweise (entschieden, ungebaut)
ABHAENGIGKEIT/FLAECHE: O-C/pe_policy; D-1/PMU-Domaene

### [wr08h0dkm] 27
GEGENSTAND: O-C pe_policy Default: "schwerste Frage des Dokuments", NICHT entschieden; Empfehlung: Pflicht-Pinning auf prod2 (hybrid), Default Unpinned auf uniformen Maschinen (Unpinned global hielte KERN E auf prod2 strukturell verletzt; Pflicht-Pinning aendert Messgroesse "ein Kerntyp der Maschine"); Autor entschied bewusst nicht (aendert Semantik der Intel-Spalte aller Anhangs-Diagramme); nirgendwo sonst aufgeloest (3 grep-Treffer alle in derselben Passage).
ORT: PLAN-hybrid-architektur-pmc:909-922
SOLL/FIX: Owner-Entscheid O-C(pe_policy).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: D-1-Zeilenschluessel; Anhangs-Diagramme

### [wr08h0dkm] 28
GEGENSTAND: HybridCorePinning-Baustein: vollstaendig geplant (Signatur pin_thread(thread_id, core_class{Performance|Efficient}) + measure_per_class()->{p_core,e_core}; 3 Domaenenmodell-Revisionen wortgleich); Code-Skelett existiert unter libs/common/platform/hybrid_core_pinning/ (INTERFACE-Target + .gitkeep, "Skelett Phase 4.B -- keine Implementation"); Klasse ungeschrieben.
ORT: Domaenenmodell_PRT_ART.txt:441-447,:589-592; libs/common/platform/hybrid_core_pinning/CMakeLists.txt
SOLL/FIX: Implementation bei Bau der Unter-Achse.
STATUS LT. QUELLE: offen (Skelett only)
ABHAENGIGKEIT/FLAECHE: D-7/O-C

## Datei wjjsi0tpp.json (82512 B) -- Break-Even-Schnittpunkte + drei Benchmark-Ebenen (Explore + Doku-Phase)
Ergebnis-Teile: Break-Even-Plan-Befund, Drei-Ebenen-Erhebung, Ist-Stand am Objekt, Doku-Verweis
(geschriebenes Plandokument docs/plaene/20260806-PLAN-break-even-und-drei-benchmark-ebenen.md, 825 Z.).

### [wjjsi0tpp] 1
GEGENSTAND: Break-Even-Plan existiert, mathematisch spezifiziert (LEDGER:2301 F8: Switch-Thresholds = Schnittpunkte der f(x)-Spline-Funktionen zweier Algorithmen DERSELBEN Achse) und ZWEIFACH implementiert; Status LEDGER:2958 "ENTSCHEIDEN / IMPL-OFFEN"; Par.49: Optionen 1+3 freigegeben, std::variant NICHT fuer Algo-Swapping (nur Pruefdock-Vertragsvarianz); ABGABE-PFLICHT (LEDGER:3284 "Messwerte -> Break-Even-Heuristik -> Hybrid-Tier-Binaries -> final schnellste Binary").
ORT: LEDGER:2296-2301,:2692-2696,:2958,:3284,:4178; heuristik/break_even.hpp; axis_spline.hpp (Fritsch-Carlson gegen Schein-Schnittpunkte); measurement_curve_loader.hpp (x=working_set_n, y=ns_per_op, Gruppe sweep_axis/binary_id/workload)
SOLL/FIX: Einspeisung in CT-CoR hybrid_router.hpp per XML <router><break_even source="measurement_store" curves="axis_splines"/></router> (HY-B2) -- Router existiert NICHT (find hybrid_router* leer).
STATUS LT. QUELLE: teilweise (Code ja, Kette nein)
ABHAENGIGKEIT/FLAECHE: Par.75-Schutz: heuristik-Header duerfen weder entfernt noch umbenannt werden (LEDGER:3602, CI-Tripwire)

### [wjjsi0tpp] 2
GEGENSTAND: ZWEI divergierende Break-Even-Implementierungen ohne Klaerung welche massgeblich: heuristik::BreakEvenPoint (Hermite/Fritsch-Carlson, Vereinigungs-Knotengitter, 100 Iter., Par.75-geschuetzt) vs best_binary::BreakEvenPoint (stueckweise LINEAR, festes 256-Raster -- kann Schnittpunkte zwischen Rasterpunkten UEBERSPRINGEN, 60 Iter., ungeschuetzt); SOLL-Design legt Router auf die ERSTE fest => zweite = toter ungegateter Parallelpfad. Zusatz (geheilt): Tripwire war 3 Wochen wirkungslos (doppelter YAML-Key), measurement_curve_loader lief 2x semantisch ohne Version-Bump (v1->v2 am 06.08. nachgezogen).
ORT: heuristik/break_even.hpp:43-48; best_binary_selector.hpp:321-327,.cpp:434-453; .gitlab-ci.yml:433-443
SOLL/FIX: Massgeblichkeit klaeren/Parallelpfad gaten.
STATUS LT. QUELLE: offen (Risiko)
ABHAENGIGKEIT/FLAECHE: HY-B2/Router-Speisung

### [wjjsi0tpp] 3
GEGENSTAND: Break-Even NIRGENDS in der Thesis benannt (0 Treffer break-even/schnittpunkt/umschaltpunkt/spline in allen eingebundenen Kapiteln DE 3371 Z. + EN + aufgabenstellung; Gegenprobe greift); in docs/termine heisst es durchgaengig Umschaltpunkt/Schwellwert (Termin 1 Forschungsfrage "wann umschalten", Termin 2 I5 "feste universelle Schwellwerte werden nicht behauptet", Termin 3 "Umschaltpunkt als eigene Messachse", Termin 6 Modi 1-3); KEIN Break-Even-Artefakt (kein Serialisierer/CSV/XML/constexpr-Array -- nur lokale vector-Rueckgaben); einzige Aufrufer = 2 Unit-Tests (Nenner 187 bzw. 203 Tests, 10 apps); super-Auswertungspfad (04/05/08/tools/02) kennt den Begriff nicht (0 Treffer) -- Diagramm-Generator zeichnet die Kurven uebereinander, NIEMAND schneidet sie.
ORT: siehe Gegenstand; O-10 "Der Schnittpunkt" DIFF:849 Owner-Entscheid offen, Freitag 4 = 28.08.
SOLL/FIX: Thesis-Dokumentation des Mechanismus + Persistenz-Artefakt + Konsumenten-Kette; O-10-Entscheid.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Thesis-Zusage/Abgabe-Pflicht vs. 0 Namensnennung

### [wjjsi0tpp] 4
GEGENSTAND: Keine Hysterese/Schaltstabilitaet geplant: Router der exakt am Schnittpunkt umschaltet flattert bei Last nahe x_be; weder Hysterese-Band noch Mindest-Verweildauer noch Konfidenzintervall auf x_be irgendwo geplant (1 unverwandter Treffer; LEDGER:2298 loest ueber Option 2/3 mehr-Binaries-hot, nicht Schaltstabilitaet).
ORT: LEDGER:2298; hybrid_tier_stufe_soll_design.md
SOLL/FIX: Design-Luecke fuer Router-Bau notieren.
STATUS LT. QUELLE: offen (Luecke)
ABHAENGIGKEIT/FLAECHE: HY-B2

### [wjjsi0tpp] 5
GEGENSTAND: Owner-KERN verlangt mehr Schnitt-Arten als geplant: geplant/gebaut nur Schnitt INNERHALB einer Achse (bzw. Binary-Ebene im Selector-Strang); achsen-KREUZENDER Schnitt und Gattungs-/Genus-Funktionsinterface-Schnitt = 0 Treffer ueberall ("moeglicherweise ... System-Achsen" ist Konjunktiv, kein Plan).
ORT: break_even.hpp:3; LEDGER:2301
SOLL/FIX: Owner-Abgleich ob Achsen-Kreuzung gefordert bleibt.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: G.5; Break-Even-Design

### [wjjsi0tpp] 6
GEGENSTAND: Min/Max-Semantik: break_even.hpp:17 fixiert hart "besser = KLEINERER y-Wert" -- Max-Achsen (z.B. Kompressionsverhaeltnis) NICHT abgedeckt; LEDGER:6425/:6431: T17-Min/Max-Semantik = DEEP-RESEARCH-Posten NACH Trigger/vor Auswertung (offen).
ORT: break_even.hpp:17; LEDGER:6425,:6431
SOLL/FIX: Min/Max-Katalog (existiert lt. wr08h0dkm Posten 19) einspeisen; Deep-Research-Posten.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: T-9-Katalog

### [wjjsi0tpp] 7
GEGENSTAND: Drei-Ebenen-Plan: Owner-Ebenen MICRO/MACRO-timed/MACRO-large-scope = Thesis-Granularitaeten Mikro-/Makro-/Gesamt-Benchmarking (aufgabenstellung de.tex:87-96); ABER "large scope" existierte vor 06.08. 23:25 NIRGENDS -- der tragende Ledger-Abschnitt (NACHTRAG abend-4 :4202,:4580-4643) entstand WAEHREND der Erhebung ("Mitschrift von heute Abend, KEIN Beleg dass das geplant war"); Bau-Posten dort: B-7 Micro je Achsen-Parameter, B-8 Checkpoint-Instrumentierung Macro-timed, B-9 Funktions-Synthese+Break-Even, B-10 Hybrid-Schaltungs-Adapter -- ALLE "nach Abgabe"; Kette B-10 braucht B-9 braucht B-7/B-8 braucht Messung braucht B-3/B-5.
ORT: LEDGER:4202,:4580-4643; aufgabenstellung/de.tex:87-96; 03_messsystem_prtart.tex:1300-1312
SOLL/FIX: B-7..B-10 nach Abgabe; Ebenen-Vokabular fixieren.
STATUS LT. QUELLE: offen (nach Abgabe)
ABHAENGIGKEIT/FLAECHE: F6

### [wjjsi0tpp] 8
GEGENSTAND: Owner-MACRO(timed) existiert heute NICHT: Checkpoints im Ist sind FUELLSTANDS-Stuetzpunkte ({10,100,1000} Elemente, CEB-/Dock-seitig in C++ gesetzt, kein XML-Feld), nicht Schritte INNERHALB einer Funktionsausfuehrung; Checkpoint-CSV exportiert 2 von 18 Achsen (15 Spalten hartkodiert); seg_ns[18] misst je Achse aber lauf-aggregiert; 0 Treffer lap/split/phase/stage/step/marker-Zeiten (Gegenprobe seg_ns=326); "Checkpoint" in Thesis 0 von 80 .tex => Owner-Ebene ist VERSCHAERFUNG ueber die Thesis-Zusage hinaus.
ORT: tier_observe_trace_abi.hpp:34-52,:281-290; f15_compare/main.cpp:241; 24_messmodell:468-491 (2 Trigger-Modi seit 30.05. geplant, nur im toten Dock-Zweig)
SOLL/FIX: B-8 Checkpoint-Instrumentierung (nach Abgabe); zwei Halbstuecke (op_lat[6] p50/p99 + seg_ns[18]) sind nicht zu Schritt-Profil verbunden.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: W-3-Abnahmekriterium (KERN 11 vs 12); S3.1-Charge

### [wjjsi0tpp] 9
GEGENSTAND: DREI kollidierende Dreiergruppen: (1) Granularitaeten Micro/Makro/Gesamt, (2) Wallclock-Ebenen E1/E2/E3 (F2-Gesetz -- die eigentliche Zuordnung der Owner-Ebenen), (3) Mess-Tooling-Achse {WallClock,Macro,Micro}; Thesis 03:992 setzt (3)=(1) -- am Code NICHT gedeckt (0 Konsumenten; Micro dort als PMC deklariert = widerspricht F2; golden kollabiert auf 1 Combo [all] => Achse faktisch rangfrei); Kapitel 04:496-502 stellt es selbst richtig ("Implementierungs-Stand, nicht Soll") = ZWEI eingebundene Kapitel, zwei Aussagen; Owner-Korrektur vormittags (LEDGER:6290 "Micro- und Macro-Benchmarking sind FALSCH...") + offene F6 (LEDGER:6260); Abend-KERN beantwortet F6 faktisch mit "nur die Fehl-Deutung" -- dem Owner vorlegen, da F6 noch offen gefuehrt.
ORT: measurement_tooling_registry.hpp:27-31; 03_messsystem_prtart.tex:992; 04_implementierung.tex:496-502; a8_f2-Dossier:66-68,:93-118
SOLL/FIX: F6-Vorlage; Thesis-Stelle 03:992 korrigieren oder Registry nachziehen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: F6; S2/Par.47

### [wjjsi0tpp] 10
GEGENSTAND: Micro je Achsen-PARAMETER ueber Achsen-Interface NICHT vorhanden: beide Orte leere Skelette (benchmarks/microbenchmarks/ = .gitkeep + 1-Zeilen-CMakeLists; runtime_micro_benchmarks/ = INTERFACE-Target); heutiges "Micro" sweept Algorithmen-WAHL und misst am Gattungs-Interface (17 axis_sweeps + seg-Spalten); Vertragskern je Achse als 18-Zeilen-Tabelle spezifiziert (a8_f2:187-206).
ORT: ce/benchmarks/microbenchmarks/; libs/cache_engine/builder/runtime_micro_benchmarks/
SOLL/FIX: B-7 (nach Abgabe); B-2/B-3 im A8-Dossier.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: A8-Dossier-Befunde B-1..B-7

### [wjjsi0tpp] 11
GEGENSTAND: Aufbaurichtung + Invariante belegt: micro -> makro -> gesamt mit Summen-Invariante Sum(E1-konstitutiv) <= E2 <= E3, jeder Rest EXPLIZIT benannt (P-MD3-Prinzip); Rangbildung ueber die drei Granularitaeten => Empfehlung von Standard-Konfigurationen je Workload-Klasse.
ORT: a8_f2:229-230; 03:1315-1318; 05_evaluation.tex:241-242
SOLL/FIX: bei Ebenen-Bau Invariante mitbauen.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: E1-E3

### [wjjsi0tpp] 12
GEGENSTAND: Lastprofil-Traegerschicht vollstaendig (21 XML + SCHEMA.md; 14er-Katalog LP01-LP14; workloads-Achse fail-closed validiert exit 4; 6 ycsb im golden) -- FEHLT: Aggregation "Gesamtheit der Macro-Charts eines Lastprofils" (kein Writer, kein Schema; CSV traegt workload-Spalte 155, kein Konsument fasst je Lastprofil zusammen).
ORT: load_profiles/; experiment_golden_kern.xml:382; profile_run_facade.cpp:552-553; validate_profile.hpp:463
SOLL/FIX: Aggregations-Artefakt entwerfen (Owner-large-scope).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Owner-Ebene 3

### [wjjsi0tpp] 13
GEGENSTAND: best_binary_selector SORTIERT statt schneidet: rank_binaries = Median-je-Zelle -> Median der Zell-Mediane -> Rangliste (+ ehrliches Vollstaendigkeits-Gate: unvollstaendige Kandidaten disqualifiziert); CLI (best_binary_selector_main.cpp) erreicht Break-Even-Teil GAR NICHT (find_break_evens/HybridBinarySelector vom main aus tot).
ORT: best_binary_selector.cpp:167-219,:455-580; best_binary_selector_main.cpp
SOLL/FIX: Owner-KERN verlangt "wo die Fuehrung wechselt", nicht "die beste" -- Kette anschliessen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: T-8 Pareto-Front (Selector muesste zusaetzlich auf Front umgestellt werden)

### [wjjsi0tpp] 14
GEGENSTAND: Nebenbefunde am Objekt: (1) B-6 T17-Messwert-Verlust GEFIXT (abi_adapter.hpp:1102-1106,:2023-2027,:2087 iterieren jetzt kV3AxisCount; Alt-Defekt-Beleg: CSV 26.07. seg_persistence_target_ns=0 bei coverage 0.999963); (2) A8-S5 teilweise gelandet (14 axis_q1_queuing-Header geschnitten, 70-Header-Bestand nicht abgearbeitet); (3) reale Messdatenbasis WINZIG (2x 17-Zeilen-CSV) => Kurven-Synthese hat heute KEINEN tragfaehigen Input; (4) Sequenz-Konflikte OF-A8-1 (drei unvertraegliche Ordnungen A8 vor/parallel/nach), OF-A8-2 (E1-Lesart, Owner-OK vor S3), OF-A8-3 (ext/-Scope) UNAUFGELOEST, Eskalation "bisher UNVERSENDET -- Task #22".
ORT: abi_adapter.hpp; a8_f2-Dossier:296-301,:387; measurement/20260726-164259-d03-*/measurements.csv
SOLL/FIX: OF-A8-1..3 eskalieren; Messdatenbasis vor Kurven-Synthese aufbauen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: A8-Welle; Trigger

### [wjjsi0tpp] 15
GEGENSTAND: Doku-Lieferung: docs/plaene/20260806-PLAN-break-even-und-drei-benchmark-ebenen.md geschrieben (825 Z., Abschnitte 1-9, Belege selbst nachgeprueft, 3 Korrekturen ggue. Explore: hybrid/ existiert als reservierter Stub mit README; <17-Verlust gefixt; Nenner 203 Tests / 10 apps / 21 Lastprofil-XML / 30 eingebundene .tex).
ORT: docs/plaene/20260806-PLAN-break-even-und-drei-benchmark-ebenen.md
SOLL/FIX: als Vorarbeit ziehen.
STATUS LT. QUELLE: behoben (Doku geliefert)
ABHAENGIGKEIT/FLAECHE: -

## Datei w210ypdj1.json (59982 B) -- KON17-04: letzte 5 Kontexte einlesen, Owner-Schaerfungen extrahieren, Unverbuchtes finden
Ergebnis: Dossier ueber K-5a..K-0 (Z. 34711-43798), 10 unverbuchte Owner-Aussagen, 23 verbucht bestaetigt,
1 Widerspruch, XML->PDF-Ketten-Konsolidierung, 13 ungeklaerte Punkte. Bilanz-Felder: leser=7, unverbucht=10.

### [w210ypdj1] 1
GEGENSTAND: UNVERBUCHT 1 (sicherheitskritisch): Rotation-GOs A-2/A-3 -- Owner "volles GO" (Z. 35912) zu A-2 (Rotation der 7 CI/CD-Variablen Gruppe 3 + Projekt 288: MINIO_SECRET_KEY, MINIO_ACCESS_KEY, GITLAB_DEPLOY_TOKEN, CE_SUBMODULE_TOKEN, COMDARE_NFS_DROP_TOKEN, COMDARE_THESIS_WRITEBACK_TOKEN) und A-3 (Rotation der 776 Runner-Token via reset_registration_token je Projekt); Ledger fuehrt KON2-01/KON2-02 als FEHLT -- weder GO noch Ausfuehrung gebucht.
ORT: Transkript Z. 35912 (K-5b); Ledger KON2-01/KON2-02
SOLL/FIX: Ledger-Nachtrag (GO + Ausfuehrungsstatus klaeren) + falls unerledigt sofortiger Wellenplan-Posten.
STATUS LT. QUELLE: offen (unverbucht)
ABHAENGIGKEIT/FLAECHE: E23-Scrub; "solange Werte gueltig sind, nuetzt ein History-Scrub nichts"

### [w210ypdj1] 2
GEGENSTAND: UNVERBUCHT 2: Minio-Keys vom Scrub mitgenommen -- Owner Z. 37651: "aus Cluster git cred vault neu suchen und neu einsetzen, um das System zu testen"; operativer Blocker, 0 Ledger-Treffer trotz 115 Minio-Erwaehnungen.
ORT: Transkript Z. 37651 (K-4); Folge-GO vaultextract Z. 37918
SOLL/FIX: Ledger-Nachtrag Vorfall+Ausgang; Erledigung pruefen.
STATUS LT. QUELLE: offen (unverbucht)
ABHAENGIGKEIT/FLAECHE: Lager-/minio-Tests (B-4-Bruecke)

### [w210ypdj1] 3
GEGENSTAND: UNVERBUCHT 3-5 (CI): D-1 "prod2 test:secrets aus dem CI-Job-Pool herausnehmen" (Owner-Entscheid; Grundbefund prod1 16s gruen / prod2 102 min haengend als FEHLT markiert -- Job haengt vermutlich weiter); D-2 "gcc UND clang Pflicht, gebaut wird immer, Skip ist VERBOTEN" (Haertung nirgends gebucht); D-3 "-Wall/-Werror ueberall einfuehren" (Owner-GO -- Ledger-Vorlage wartet erkennbar auf laengst gefallene Entscheidung).
ORT: Transkript Z. 35912 (K-5b)
SOLL/FIX: Ledger-Marker auf ENTSCHIEDEN drehen mit Zeilenbeleg 35912; CI-Posten (test:secrets-Pool, -Wall/-Werror-Rollout).
STATUS LT. QUELLE: offen (unverbucht)
ABHAENGIGKEIT/FLAECHE: CI-Pipeline

### [w210ypdj1] 4
GEGENSTAND: UNVERBUCHT 6-9 (Lizenz/Abgabe): C-2 "cache engine nach 5 Jahren frei verfuegbar ab heute" (Sessionstag 10.08.2026 => frei ab 10.08.2031; 0 Ledger-Treffer, abgaberelevant Thesis-Lizenzkapitel); C-3 Pruefungsunterlagen mitveroeffentlichen = Owner-JA (KON2-26 im Ledger noch OFFEN; datenschutzrelevant, namentliche Dritte @tu-dresden); C-4 Research-and-Teaching-Klausel bleibt (0 Ledger-Treffer); D-4 "Abgabe wird das Ausfertigungsdatum" = 15.09.2026 (KON3-09 als FEHLT gefuehrt obwohl beantwortet).
ORT: Transkript Z. 35912 (K-5b); Ledger RANG C, KON2-26, KON3-09
SOLL/FIX: Ledger schliessen + Thesis-Lizenzkapitel + Release-Checkliste super + docs/termine.
STATUS LT. QUELLE: offen (unverbucht)
ABHAENGIGKEIT/FLAECHE: P6-Lizenz-Welle (landereifer Branch bau/p6-lizenz-umsetzung -- Abgleich noetig)

### [w210ypdj1] 5
GEGENSTAND: UNVERBUCHT 10: 0-Byte-/Platten-Vorfall (Z. 34792 K-5a) -- weder Ursache noch Entwarnung dokumentiert, kein sichtbarer Ruecklaeufer; potenziell offener Datenverlust-Vorfall.
ORT: Transkript Z. 34792
SOLL/FIX: Ledger: Abschluss dokumentieren oder als offen fuehren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Platten-Doktrin (Memory vorhanden)

### [w210ypdj1] 6
GEGENSTAND: WIDERSPRUCH A-1 Backup-Ref: Ledger O-5 "STEHEN LASSEN, nach Lieferphase Bundle, dann loeschen" (gestuft+terminiert) vs Owner "volles GO" zu einer als "Loeschung nach Vollscan-Beleg" rekonstruierten Vorlage A-1 -- Vorlagetext liegt NICHT im Auszug, nur das GO.
ORT: Transkript ~Z. 35872-35912; Ledger O-5
SOLL/FIX: VOR jeder Ref-Loeschung Vorlagetext im Roh-Transkript (~Z. 35872) gegenlesen; erst bei Beleg O-5 auf neuere Fassung korrigieren (Nummern sind kein Autoritaetsbeleg).
STATUS LT. QUELLE: offen (Widerspruch)
ABHAENGIGKEIT/FLAECHE: refs/backup/pre-secret-scrub-20260802; Sicherheits-Welle

### [w210ypdj1] 7
GEGENSTAND: Owner-intern ERSETZTE Doktrin (Lesefalle): "Bau sequentiell" (Z. 38861) ersetzt durch "parallel bauen, sequentiell landen" (Z. 40165, als Doktrin verankert) -- aeltere Fassung darf nirgends mehr als geltend zitiert werden; Grammatik-Regel "Neu schlaegt grundsaetzlich alte Aussage" (Z. 43026).
ORT: Transkript Z. 38861 vs 40165
SOLL/FIX: bei Zitaten stets neuere Fassung.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Workflow-Landestufe

### [w210ypdj1] 8
GEGENSTAND: XML->PDF-Ketten-Konsolidierung (Owner-Worte, KON17 Frage 10): XML (super=Anwender; je Gattung+Genus separates permutierbares Experiment, je einen CEB->Tier-Vertrag in SEPARATEN CEBs/Experimenten) -> PLANER (einzige direkt kompilierte Stufe; X.Y.Z+Fingerprint-SHA; gibt DREIPHASIG Mess-Achsen frei; Experiment-B+-Baum simulation/freigabe/umsetzung lazy, Planer<->CEB synchronisiert; Planungs-Simulation berechnet Tier-Binary-Zahl, Pflicht NACH Stempel-Aufgabe) -> emittiert PROZESS (keine YAML) via EIN zentrales Baumodul (C++23-Planer-Bibliothek, Builder-Pattern; Filterkette=concept=Selbstkompilation; je Stufe eigene Mini-Pipeline) -> 6 CEBs (3-Fakultaet Wallclock/Macro/Micro fuer checkpoint_measure; Bau sequentiell wegen RAM; CEB selbst kein AVX; doppelte System-Achsen-Anzeige; genau EIN Pruefdock) -> TIER-BINARIES (Zahl aus Planungs-Simulation) -> danach HYBRID (durch CEB, gleiche Stufe, Tiefe 3; oertlich VOR Tier, zeitlich NACH Einzelmessung) -> LAGER (=Emissions-Abschluss; Stempel=Schluessel; Neubau nur bei X.Y.Z-Bump; Runner lesen NUR ccache minio.comdare.de + Buildsystem-NAS) -> MESSUNG -> EXPORT (xlsx Messwerte; finale Zusammenfassung+LaTeX+PDF in dritten XML-einstellbaren Zielort cache-engine-experiment im Cluster_NFS).
ORT: Transkript Z. 43439,:43753,:41864,:41905,:42174,:42298,:43026,:43254 (K-0/K-1/K-2)
SOLL/FIX: Kette von vorn nach hinten durchbauen "mit allen Abzweigungen" (juengster Owner-Auftrag Z. 43753).
STATUS LT. QUELLE: offen (Arbeitsauftrag)
ABHAENGIGKEIT/FLAECHE: Stempel-Reimplementierung = zentraler Blocker (Z. 41018); Vollbau-Gate 4 Bedingungen (Lagerhaltung fertig + Stempel fertig + Algorithmen versioniert + Messung einbaubar, Z. 35912)

### [w210ypdj1] 9
GEGENSTAND: Prioritaets-Struktur: 1. Stempel zuerst (Pflicht+Abgabe-Basis, hoechste Denk-Prioritaet, KEIN Restore sondern Neubau nach geschaerfter Architektur -- Implementierung war vom Assistenten versehentlich geloescht, Z. 41017); 2. direkt nach Stempel-Planung Pipeline-Debug, dann Konsolidierung; 3. Planungs-Simulation Pflicht nach Stempel; 4. Vollbau-Gate; 5. "volles Risiko, MIT ALLEN TEILEN IN REIHENFOLGE, direkt ins Zielbild" (Variante B; risikoaermere Alternativen abgelehnt Z. 42691).
ORT: Transkript Z. 41018,:41098,:42005,:42691,:43753
SOLL/FIX: Reihenfolge einhalten.
STATUS LT. QUELLE: nur-hinweis (bindend)
ABHAENGIGKEIT/FLAECHE: S7-Stempel-Welle (landereifer Branch bau/s7-algo-hardware-stempel -- Abgleich)

### [w210ypdj1] 10
GEGENSTAND: Abzweigungen/Vertraege (Owner): nur Mess-Achse traegt Vertrag (DREIPHASIG); Hybrid+Tier = 2 parallele DREIPHASIGE Vertraege, "echte Vier-Parteien-Kette mit theoretisch weiterhin DREIPHASIGEM Kern"; oertlich VIERPHASIGER Vertragskomplex; System/Organ nur Freigabe->Umsetzung ohne Synchronvertrag; zwei Grammatiken fuer DREIPHASIG+VIERPHASIG, eine fuer ZWEIPHASIG; Teilmengen/Minimum-Konzept grundsaetzlich (Minimum=einfachste CPU-Variante; Ausnahme Messfuehler-Latenz -> Filterkette+Strategy); Cache-Landschaft drei Orte, zwei Backends, XML-konfigurierbar, beide Caches muessen S3 UND Filesystem koennen; Funktionsvariablen-Reihenfolge f(system,organ) -- NUR Lager hat Ausnahme; Organ-Algorithmen tragen volle Grammatik (Owner korrigierte eigene fruehere Annahme) + Hardware-Spezifikations-Stempel X.Y.Z mit voller System-Achsen-Syntax je Algorithmus; Hybrid NICHT stempelfrei (selbst Genus mit Flaeche 2); measurement_tooling_registry = EINZIGE Mess-Achse mit System-Achsen-Syntax/Haupt-Achsen-Semantik, andere Mess-Achsen nur X.Y.Z ohne komplexe Tags; "Es kann nur eine gerade Anzahl an Pruefdocks geben, 5 = Regression".
ORT: Transkript Z. 41905,:41990,:42174,:43026,:40977,:41838,:35440,:35020
SOLL/FIX: als Design-Leitplanken; Pruefdock-Zaehlung VOR jedem Dock-Bau am Roh-Transkript klaeren (Widerspruch "gerade Anzahl" vs "genau EIN Pruefdock je CEB" vs "ein Dock je Gattung, Soll=2" -- Punkt 5.4).
STATUS LT. QUELLE: teilweise (Zaehl-Gegenstand offen)
ABHAENGIGKEIT/FLAECHE: M-5/Dock-Wellen

### [w210ypdj1] 11
GEGENSTAND: Ungeklaerte Punkte (Auswahl, 5.1-5.13): GOs ohne benannten Gegenstand (Z. 36292, 42737); E-1..E-4 unentschieden (OV-4 Mess-Deckel, Ledger-Selbstwiderspruch :9468/:8941, W-6 vier lokale Klone; Neuvorlage "mit viel Kontext" verlangt -- ob je neu vorgelegt: unbelegbar); "Die suche wirkt nicht" (Z. 37733, ungeklaert welche); K-2-Abbruch Z. 41953 mitten im Fluss; B/C/F/O/W-Vorlagen-Inhalte nicht in Owner-Datei (nur Urteile); Transkript-Artefakte "[C" = Token-Redaktionsfilter, kein Inhalt; letzte Owner-Frage OFFEN: "Welche Entscheidungen und Fragen hatte ich vergessen? Bitte stelle mir diese hier." (Z. 43798) -- gehoert in die aktuelle Session; K-0-Zusagen (Frage 7 Emissions-Kriterium, Frage 11 Einhaengepunkt "6 von 11") sind aus Owner-Bestaetigungen REKONSTRUIERT.
ORT: Transkript diverse
SOLL/FIX: je Punkt Roh-Transkript-Gegenprobe vor Bau.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: KON-Ledger-Fortschreibung

## Datei w7gt8fx1n.json (44761 B) -- WF7: Schnitt-2 nachliefern (SOLL aus Plaenen) + Konsolidierung IV auf vergessene Fakten pruefen (KON36-Entwurf)
Ergebnis: Heilung der KON34-Deckungsluecke (c), adversarialer Abgleich (Urteil TEILS), 56 nachzutragende
Fakten (Kapitel B-M), 1 Korrektur, KON36-Entwurfstext. luecken=5.

### [w7gt8fx1n] 1
GEGENSTAND: KON36-01 Heilung: SOLL-Chronologie der Mess-Instrumente nachgeliefert -- 01.08. F2-Gesetz (3 Wallclock-Ebenen), 03.08. A8-SOLL-Matrix (KEINE volle 3x3), 06.08. Owner-KERN Wallclock DREIPHASIG (instrumentiert CEB UND Tier), 07/08.08. GO-3 (Hybrid EIGENE Macro-Schicht = fruehester Beleg "Instrumente nicht an einem Ort"), 09.08. Owner-Modell "3 Fakultaet CEB-Versionen" (Ein-Ort-Praemisse, 6 Steuerdocks je CEB), 10.08. KON25-03 JUENGSTER Stand: Tier Micro/Macro an/aus (4) x Hybrid eigene Micro/Macro an/aus (4) x CEB Wallclock an/aus (2) = 32 ueber 4 Traeger-Stufen. KON34-Kernbefund HAELT (6 verliert Gegenstand; 32 = 5 Schalter; B1-B5); Ein-Ort-Praemisse war OWNER-Modell, durch KON25-03 UEBERHOLT (nicht von Anfang an falsch); Teilmengen-Ausweg war am 09.08. im Code-Kommentar als Eventualitaet vorgesehen (konfiguration.hpp:40-44 "GEGEN DIE ANTWORT INVARIANT", eine Alias-Zeile CebVersionen steuer_dock.hpp:230-231).
ORT: ce libs/cache_engine/mess/steuer_dock.hpp:1-241; konfiguration.hpp:1-272; Ledger:446-582(KON34),:1300-1343(KON25),:12040-12055(GO-3),:10910(D-3)
SOLL/FIX: KON36 in Ledger nachtragen; Deckungsluecke (c) GESCHLOSSEN, (a)(b)(d) offen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: System A/B (KON34-01 bestaetigt: A/B-Split, 0 Produktionsaufrufer)

### [w7gt8fx1n] 2
GEGENSTAND: ANFECHTBAR: KON34-02-SOLL-Spalte "Wallclock -> CEB, an/aus" kollidiert mit F2-Gesetz 06.08. ("Wallclock DREIPHASIG in die TIER-BINARIES", echte Fundstelle DOSSIER-messachse:44-50, NICHT :38-40) -- gilt nur ueber Vorrang von KON25-03, Konflikt NIE explizit aufgeloest => praezise Owner-Frage (Sektion M). ZWEIDEUTIG: Spaltenkopf "Wallclock/G1" -- "Vier Dreien"-Warnung (DOSSIER:107-117) trennt Tooling-Werte von Erhebungs-Ebenen E1-E3 ("kein Dokument darf sie unbenannt mischen"); 16_E1_E4-Dossier:95-119 belegt DRITTE Bedeutung derselben E-Labels => E-Label-Doppelbedeutung = Owner-Frage-Kandidat. [MEMORY-Hinweis: lt. MEMORY.md sind Wallclock-SOLL + E-Label per KON37-01/-05 BEANTWORTET (Merge bzw. Umbenennung genehmigt) -- Designer muss KON37 gegenpruefen.]
ORT: docs/plaene/20260806-DOSSIER-messachse-wallclock-und-mess-kette.md:44-50,:107-117; docs/architektur/16_E1_E4_KONSOLIDIERUNG_DOSSIER.md:95-119
SOLL/FIX: Owner-Fragen (bzw. KON37-Antworten anwenden).
STATUS LT. QUELLE: offen (Stand KON36; spaeter lt. Memory beantwortet)
ABHAENGIGKEIT/FLAECHE: KON34-02; Mess-Wellen

### [w7gt8fx1n] 3
GEGENSTAND: VERSCHAERFT: R-1 (Ordnungs- vs Auswahl-Subsystem fortfuehren, KON29-06 Ledger:924-929) bleibt offen -- KON34/B4 beantwortet nur die ORDNUNGS-Seite (System B umstellen, nicht loeschen); zum AUSWAHL-Subsystem (measurement_tooling_registry/canonical_combo/XSD, 18 Dateien vs 3) KEINE Aussage; canonical_combo reihenfolge-unabhaengig, max 2^3 Teilmengen -- deckt weder die 6 noch die 32; B1-Luecke bestaetigt (Element kennt nur "tools", nicht tier/hybrid/ceb -- keine Stufen-Dimension im Auswahl-Subsystem).
ORT: measurement_tooling_registry.hpp:1-13; plan_legend.hpp:71-92; Ledger:906-912,:924-929
SOLL/FIX: R-1-Entscheid Owner; XSD/Element um Stufen-Achse erweitern falls Auswahl-Subsystem fortgefuehrt.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: S5/S6-Wellen (beide Subsysteme dormant/inert)

### [w7gt8fx1n] 4
GEGENSTAND: Verify-Korrekturen am Schnitt 2 selbst: zwei Zitatanker falsch (:38-40 -> :44-50; :19 -> :93-99); These "ob 32 auch die 12 ersetzt, nirgends explizit" am Ledger WIDERLEGT (KON25-03 ersetzt 12-These ausdruecklich, Ledger:1331-1333; Zwischen-Chronologie 10.08. 07:27 "12" / 12:40 "6" in KON29-05 Ledger:901-904 verbucht).
ORT: Ledger:901-904,:1331-1333
SOLL/FIX: Zitate nachziehen.
STATUS LT. QUELLE: behoben (im KON36-Text korrigiert)
ABHAENGIGKEIT/FLAECHE: -

### [w7gt8fx1n] 5
GEGENSTAND: KON36-02: 56 nachzutragende Fakten in Konsolidierung IV (Kapitel B 8 / C 15 / D 6 / E 2 / F 1 / G 3 / H 1 / I 4 / J 9 / K 3 / M 4). Auswahl mit eigenem Gewicht: B: Q6-MaxN=8 zu korrigieren auf 32 (synthese_matrix.hpp:33-51, kleiner Bau-Posten); nur GERADE CEB-Anzahl (Hybrid-Docks ausgenommen); PlanTextBuilder+plan dump+visibility:tier-binaries+parse_plan_dump PRODUKTIONSKRITISCH und BLEIBEN (nur --dump-plan-Flag ueberholt); KORREKTUR: "eigenstaendig+Sync-Kanal" = AUTONOMIE-STUFE SPAETER, JETZT orchestriert CEB direkt/delegiert (Sync-Kanal S-20 = Neubau); CEB-Bau sequentiell (RAM); System-Achse sitzt IN der CEB (keine Querkante); 0 von 4 Traegern haben eigenen Bau-/Test-Job (super 45, ce 25 Jobs, "hybrid" 0 Treffer); Selbstkompilations-Blaupause gebaut (catalog_codegen.cmake; Director/2 ConcreteBuilder/Interpreter/Template-Method/Abstract-Factory; Filterkette concept+mp11 IST der Mechanismus).
ORT: Ledger-Konsolidierung IV Z. 20-445; Quellverweise je Posten im Text
SOLL/FIX: 56 Fakten in Kapitel B-M einarbeiten; Sektion M erhaelt (d) + 2 neue WF7-Offen-Punkte.
STATUS LT. QUELLE: offen (Nachtrag faellig)
ABHAENGIGKEIT/FLAECHE: KON-Ledger; laut MEMORY inzwischen KON58-Kopf -- Stand pruefen

### [w7gt8fx1n] 6
GEGENSTAND: Kapitel-C-Fakten (Stempel/Versionierung): S-6 vollstaendig geschnitten (S-6a Umstellung, S-6b Transpositions-Sperre, S-6c Kategorien-Ordnungs-Wache Owner-GO, S-6d #67 behalten; Kosten: Makro billig, POD=ABI-Bruch, Preimage-Glieder=jeder SHA-512 aendert sich); S-6-VERBOTSZONEN (Lager-Kaskaden, kOrganGruppen*, kSystemAxisOrder, kCompositionAxisNames, Hash-Mechanik, Messwert-2-Tupel); SOLL-Versionierung: CEB-Zeile nur Mess+System, Genus CT-zusammengesetzt, alle VIER Binaries mit Fingerprint-SHA -- drei IST-Luecken (Planer ohne SHA; CEB-System-Anteil leer; Genus handgeschrieben 5 Literale/1 Test-Aufrufer); Stempel-Basis-Pflicht unerfuellt (5 lose Stempel-Strukturen ohne gemeinsame Basis); ABI: 5. Symbol (Stempel) darf heute nullptr sein -- SOLL Pflicht (konkreter Bauauftrag, KON7-01); 7 Flaeche-2-Interfaces (version_xyz nur Planer, mess/system/organ_zeile, fingerprint_sha, gesamt_stempel je constexpr, angeschlossene() NUR Hybrid); Hybrid-Stempel = BEREICHS-KARTE (Grenzen=Break-Even; 4 eigene Zeilen sofort baubar, Karte erst nach HY-B/C; leer/einbereichig davor = SOLLVERHALTEN); CEB ZWEI System-Anzeigen (CT->Stempel, Laufzeit/RAM->NICHT in Stempel); Stempel FAELLT AN als Resultat der B+-Baum-Materialisierung, KEIN Freigabe-Feld; Composite-Zulassungsmatrix DREIWERTIG (PFLICHT-in-MIN/ERLAUBT/VERBOTEN); POD AnatomyVersionLines asymmetrisch ("gewachsen, nicht entworfen"); 3 Geschwister-Gatter produktiv (conformance_gate, mess_interface_testate, mess_konsistenz_gate -- letzteres faehrt VOR JEDER MESSUNG fail-closed); W12-B halb (System-Aenderung loest weiter VOLLBAU aus); Flaeche-3-Deckungsluecke (Zweig CEB=AUS/Tier=AN von keinem Testziel uebersetzt).
ORT: KON2/KON5-KON9/KON20/KON21/KON25/KON27-Quellverweise im Text
SOLL/FIX: je Posten Bauauftraege wie benannt.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: S7-Stempel-Welle; S-6 (Explore-Pflicht lt. Memory)

### [w7gt8fx1n] 7
GEGENSTAND: Kapitel-D/E/F/G/H-Fakten: C-4-Wache (contract:axis-version-lock) sichert nur 6 Heuristik-Header, Schnitt mit axes/ = 0 (>=152 ungedeckt; 130 axes-Organ-Header + 22 fehlplatzierte topics/queuing-Traeger); Owner: EINE Wache MODULAR erweitern + Detail-Klassen-Split, Autodiscovery via Registry-Typlisten; io-Substanz = ZWEI Organ-Hauptachsen (io_dispatch T12 RAM 4 Bausteine ON; persistence_target T17 DiskWriteback GEBAUT per Owner OFF); Rang-1-Owner-Pflicht: je Achsen-Kategorie definiert freigegebene Syntax UND Semantik ("Pflicht und Basis fuer die Abgabe"); MIN = Querschnittskonzept mit ZWEI Filtern (System+Organ additiv monoton; Mess zweischneidig); Flag-Katalog: 59 Knoten alle im c-Zweig, g/f/n ohne Sub-Token, Namenskollision f=FPGA vs AVX-512-Foundation wird Risiko; S-14 = 7 von 130 Headern markiert, Wache CI-verdrahtet (ce/.gitlab-ci.yml:768-786) = reiner Ausroll-Auftrag; PMC in CI OHNE Vendor = Uebergangszustand mit WARNING; MergeStrategy-Werte (CeOnly/PrueflingReplace/FullJoin) SIND die Prueflings-Verbund-Varianten; COMDARE_STORAGE_CACHE heute AUS (fuer S-13/Tests explizit setzen); LagerBaumWriter 0 Produktionsaufrufer (S-17, setzt O-9 NAS/MinIO-Bucket voraus -- Messdaten-Kaskade hat KEINEN Einsortier-Pfad); Bestandslog schreibt je binary_id EINEN Eintrag mit leerer Zelle obwohl ID ueber ganze opt-x-simd-Matrix gebaut (320 IDs bit-identisch, SKIP kann falsch begruendet sein); 8 von 9 thesis_profiles xlsx-blind (Blocker jeder echten Kampagne).
ORT: KON2-19/KON23/KON25-27/KON12/KON26/KON30/KON33/KON3-06/KON4-07-Quellverweise
SOLL/FIX: je Posten.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Wachen-Welle (bau/wachen-floor-inventar -- Abgleich); Lager-Wellen

### [w7gt8fx1n] 8
GEGENSTAND: Kapitel-I/J/K/M-Fakten: S-14/S-18 = BUILD-BLOCKER ("sonst ist der Build unmoeglich"); S-13/Ablage = KERN der Bau-Reihenfolge nach Stempel (1. Stempel, 2. Planungs-Simulation, 3. XML->PDF-Kette; ausdruecklich NICHT Post-Abgabe -- Ruege); P-0-Rest: super-Skelett v32_messreihe_antrieb.hpp auf ce-Skelett ziehen WENN S-8 gebaut; V-1: F1-Liefergegenstand ##25-Durchstich (Fr 14.08.) seit der Stempel-Nacht OHNE BESITZER -- "dringendster Posten" (W0b/#11); test:coverage-guard aus stempelFREMDEM ISA/Host-Grund rot -- Fix-Reihenfolge ERST F1 (Operanden vergleichbar) DANN F2 (when:always); test:secrets verlaesst prod2-Pool (Umsetzung ungeprueft); main-FF beider Repos offen (super ~25 Commits zurueck; vor jedem FF Diff-Hygiene-Wache ueber KUMULATIVEN Bereich); ZWEI divergente Wachen-Fassungen (ce 779 Z. --bereich vs super 558 Z. --seit-basis/--bestand; gemeinsamer --stdin ohne Abbruch; vor main-FF misst die SCHWAECHERE super-Fassung); Kampagnen-Kapazitaet prod1 20,7 h / prod2 34,4 h (Engpass; prod2 = i9-12900K seit RMA); stehende Regression C++/CMake-only: 13 Shell-Testdateien (7967 Z.) gegen 517 Google Tests, tr-Shim (exit 127) liess 5/5 Mutanten faelschlich als gefangen durch; XML-Wache: zwei Zweighaelften unbeobachtbar (grep-Zweig braucht root; Nenner-Mismatch-Mutant ueberlebt; Owner-Frage unbeantwortet); Stage-Topologie: ctest_unit_inventar.txt ohne Verbraucher, coverage-guard in FRUEHERER Stage als test:unit; MinIO-Keys Neu-Einsetzen UNGEPRUEFT, 776-Token-Rotation UNGEPRUEFT; Backup-Ref-Loeschung gestuft (KEINE Loeschung vor Lieferphase); Betreuer-PDFs in Release-Checkliste; Lizenz-Widerspruch am Objekt: ce/NOTICE "Apache 2.0" vs ce/LICENSE Dual-Lizenz (36/28 SPDX-Header); 5. Schalter COMDARE_CE_ENABLE_ORIGINAL_CODE_VALIDATION=ON kopiert bei jedem Configure GPL-3-Code (wh.c) -- Vier-Schalter-Gate deckt ihn NICHT; Register-Luecken K2 (P/E-Core-Cluster ohne Implementierer, W7/#21), K4 (mess/ ohne S-Position), K5 (3 Skelett-Testverzeichnisse seit 06.07. ohne Eigentuemer); W-6 (vier lokale Klone) ungeloest; KON34-06(d) 17-vs-18-Dateizaehlung unaufgeklaert.
ORT: KON-Quellverweise je Posten (Ledger-Zeilen im Quelltext)
SOLL/FIX: je Posten; V-1/##25-Besitzer SOFORT (F1 = morgen).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: F1-Lieferung (wt-f1-1x1, bau/f1-1x1-honest-empty); P6-Lizenz-Branch; Wachen-Branch

### [w7gt8fx1n] 9
GEGENSTAND: Von der Gegenpruefung VERWORFENE Berichts-Behauptungen (NICHT nachtragen): "S-6 bleibt gesperrt" (KON21 hat entsperrt); "P/E-Core ohne Wellen-Posten" (KON27-04: W7/#21 existiert); "MinIO-Keys 0 Ledger-Treffer" (KON22-01/5 + KON27-04/#10 fuehren sie). Schwerpunkt der Auslassungen: KON2 (36 Positionen) + KON3 (18) fast unintegriert; KON7-KON12-Substanz.
ORT: KON36-02-Text
SOLL/FIX: Dedup beim Nachtragen beachten.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Konsolidierung IV

## Datei wpe8akoch.json (34574 B) -- R-3: Mess-Defines ins Fingerprint-Preimage -- Design/Bau/Review (GEBAUT, LANDEBEREIT)
Bau-Workflow mit Ergebnis: Branch b-r3-mess-defines-preimage, Commit 2e1f9c1dda0587f9189fa066cc165cee4796f83e
(Parent aa223961 = development-Design-Ref), Worktree /home/comdare/wt-r3-preimage. Verdict GRUEN, landebereit=True.

### [wpe8akoch] 1
GEGENSTAND: R-3-Design: ABI-wirksame Mess-Defines kartiert -- MEASUREMENT_ON (30 gated Bloecke abi_adapter), CE_ENABLE_STATISTICS (39 Vorkommen, G2+G3), EXPERIMENT_MODE_ON (Marker, verlangt MEASUREMENT_ON per #error), ENABLE_PMC NICHT tier-ABI-wirksam (0 Treffer anatomy/, gehoert NICHT ins Tier-Preimage; CEB-Identitaet = eigene Owner-Scheibe), 16 measurement_categories keine Compile-Defines. KERNBEFUND: kein Gate-Makro stand im Preimage -- dasselbe .cpp mit/ohne -DCOMDARE_MEASUREMENT_ON=1 => identischer kFP, verschiedene Binary => STILLER FALSCH-SKIP via dll_is_current (Sidecar-Vergleich, Sidecar aus Host-Erwartung). Format-Bump 3->4 NOETIG (Gegenposition zur M-1-Lehre: M-1/bba4d90f bewegte kein Preimage-Byte, R-3 MUSS ein Byte in die Identitaet bringen; kein bestehendes Glied kann das Feld tragen) -- NEUNTES Glied [8] "mess-gates" als TU-WAHRHEIT (per Praeprozessor aus real wirksamen Makros der TU, kann konstruktiv nicht luegen; Default = LEERE Identitaet gegen ODR-Falle/kCebFingerprint).
ORT: ce development@aa223961; abi/anatomy_fingerprint.hpp:80-95,:341,:462-471; abi/anatomy_module_abi_v1.hpp:150-157; mess_achsen_naht.hpp:383-466
SOLL/FIX: Bauplan S1-S9 + Wachen W1-W7 (verbatim im Quelltext); Sidecar-Bestand literal 0 gemessen => Bump heute kostenlos.
STATUS LT. QUELLE: behoben@2e1f9c1d (gebaut, landereif -- NICHT gelandet)
ABHAENGIGKEIT/FLAECHE: loest R-3/W-02-Widerspruch der aelteren Berichte AUF (Format-Bump nun vollzogen); R5 Merge-Kollision mit b-m2-pmc-invariante@90bca126 (parallel, beruehrt mess_achsen_naht-Umfeld + director) -- vor Landung gegen aktuellen development mergen (nie rebase)

### [wpe8akoch] 2
GEGENSTAND: Bissbeweis DOPPELT durch Ausfuehrung: Eltern-Stand ROT (fp GATES AN == fp GATES AUS = 6739cae7..., .so sha256-verschieden 820533fb/e92658ce = ZWEI Binaries EIN Fingerprint, RUN_EXIT=1); mit Fix GRUEN (3c9f0577... vs e1bef625...); Spiegel-Wache Host-Vorhersage==TU-Wahrheit ueber echte .so-Grenze (6 Paare, 0 Kollisionen); test_d4_ceb_schluessel_wahl ging am Format-Bump deklariert ROT (Pin 004251f4... -> db7bac00..., im selben Commit neu gepinnt); frisches Build-Dir 415/415 Tests GRUEN (ctest -LE pmc); golden-CRC64-Anker 0x56F1B721C72DC10E UNBERUEHRT (Auftrags-Korrektur: 0xF1C1F26A1232073B ist ALT-Anker/17 Slots, nur Historik).
ORT: wt-r3-preimage; tests/unit/test_r3_mess_gate_fingerprint_biss (#372), test_r3_mess_gates_spiegel (#373); Frozen-Vektor 17148e5a->5b18feac mitgewandert (deklariert, 3 Fundstellen, 1 Commit)
SOLL/FIX: Landung; R3-Fenster (Sidecar 0) VOR dem naechsten GOLDEN-UPDATE nutzen.
STATUS LT. QUELLE: behoben@2e1f9c1d
ABHAENGIGKEIT/FLAECHE: kCebFingerprint bewegt sich zwangslaeufig mit (traegbar: ceb_key_sha512 gemessen 0 Lese-Stellen, additiv)

### [wpe8akoch] 3
GEGENSTAND: Review-Restposten (beide NIEDRIG, nicht blockierend): (1) mess_gates_glied_for_legend erkennt Gates ueber LITERALE Define-Strings -- kuenftige Schreibweisen-Aenderung => Host sagt m0 voraus waehrend TU m1 traegt; Fehlrichtung FAIL-CLOSED (Sidecar-Mismatch -> Dauer-Neubau sichtbar teuer, kein stiller Falsch-Skip); zwei Gate-Strings doppelt buchstabiert (Naht :456/:461 vs :502). (2) Kein E2E-Test haelt eine ueber den REALEN Perm-Baukanal gebaute Tier-DLL gegen live_mess_gates_glied() -- R6-Folge-Scheibe: build_orchestrator liest die gebaute DLL nicht zurueck (Host-Erwartung und Sidecar aus derselben Komposition -- Host kann weiterhin luegen); Orchestrator-seitige Nachlese der gebauten DLL = vollstaendige Schliessung.
ORT: mess_achsen_naht.hpp:502; build_orchestrator.hpp(:707)
SOLL/FIX: R6-Folge-Scheibe (deklariert, benannt); R7: kuenftige Gate-Verfeinerung (G3-eigenes Makro) muss Glied erweitern (W3/W4 machen Vergessen compile-/test-hart).
STATUS LT. QUELLE: offen (Folge-Scheibe)
ABHAENGIGKEIT/FLAECHE: R8: EXPERIMENT_MODE_ON im Glied diskriminiert Experiment- von Nicht-Experiment-Kompilaten (gewollt; fuer handgebaute Vergleiche dokumentieren); R3-Invalidierungswelle nach erstem golden-Batch ~34,4 h + Messdaten-Entwertung -- Fix VOR das naechste GOLDEN-UPDATE-Fenster einreihen

## Datei wn5hdyswe.json (29222 B) -- A1-Scheibe: layout_aware-Wurf-Vertrag + OOM-Posten 64/71-74 (Kartierung/Bau/Review)
Bau-Workflow: Branch b-a1-wurf-vertrag, Commit 0b5ed5574b7c3aafaf58b15f20b1abfface897d0 (1 Commit ueber
origin/development@7969b399), Worktree /home/comdare/wt-b-a1, KEIN Push. Review-Verdikt LANDEBEREIT.

### [wn5hdyswe] 1
GEGENSTAND: A1-Wurf-Vertrag umgesetzt: F1/P.71 PmrResourceAdapter::do_allocate nullptr->bad_alloc; F2/P.72 n*sizeof(T)-Ueberlaufwache->bad_array_new_length; F4/F5/P.74 append_slot+copy_from_ ueber neues allocate_or_throw + Kopier-Ctor-Leck via clear()-Rollback; F6/NEU PoolResourceAllocatorBody als einziger Strategie-Ausreisser auf OOM==nullptr angeglichen (allocate+reallocate; beseitigt latenten std::terminate-Pfad: abi_adapter.hpp:464-468 ruft roh in noexcept-run_workload); F3/P.73 Default-Literal 64 -> kDefaultLineBytes (verhaltensneutral, andere Entscheid-Klasse, im selben Commit als markierter Abschnitt). Architektur: DREI Uebersetzungsstellen in der CRTP-Wurzel statt je Konsument; achsen-innen ausnahmslos OOM==nullptr, achsen-aussen wirft genau eine Stelle je Zugriffsweg.
ORT: axes/alloc/axis_06_allocator_strategy_base.hpp (:262,:298,:155); axes/alloc/axis_06_allocator_pool_resource.hpp; axes/node/axis_04_node_type_layout_aware_store.hpp; axes/cacheline/node_width_config.hpp:54; tests/unit/test_a1_wurf_vertrag_allokator_store.cpp
SOLL/FIX: Landung des Branches b-a1-wurf-vertrag.
STATUS LT. QUELLE: behoben@0b5ed557 (landereif, NICHT gepusht)
ABHAENGIGKEIT/FLAECHE: disjunkt bewiesen (TABU-Diff leer, nur 4 axes-Header + Test); golden-320 md5 dd60c04f identisch; CRC64 0x56F1B721C72DC10E + kOrganAxisCount=18 unbewegt; fingerprint_format=2 am Basis-Stand 7969b399 (VOR Format-3/4-Wellen -- Merge-Reihenfolge beachten!)

### [wn5hdyswe] 2
GEGENSTAND: Gates literal: Voll-Bau 1816/1816 Ninja; ctest 2x seriell 405/405 in beiden Laeufen; Gegenprobe am Alt-Stand: SIGSEGV Exit 139 + g++-Warnung "writing 8 bytes into a region of size 0 ... destination object is likely at address zero" (Review hat Gegenprobe SELBST via Shadow-Include reproduziert); Leck-Beweis als Bilanz 4->4 Live-Bloecke; Zusatzbefund selbst gefunden+geheilt: append_slot ZWEITE Wurf-Quelle (chunks_.push_back wirft seit Posten 64; dieselbe Leck-Klasse eine Zeile spaeter -- ohne Fix waere die eigene "starke Ausnahme-Garantie"-Zusage falsch gewesen).
ORT: wt-b-a1/build/gate (2,4 GB, bleibt fuer Landung stehen, gitignoriert)
SOLL/FIX: -
STATUS LT. QUELLE: behoben@0b5ed557
ABHAENGIGKEIT/FLAECHE: pgrep-Selbstmatch-Falle dokumentiert (Zeitverlust, kein Gate-Einfluss)

### [wn5hdyswe] 3
GEGENSTAND: Offene Randnotizen: (a) rebuild_() (insert_slot_at/erase_slot_at) ruft clear()+append_slot-Schleife -- wirft die Schleife, bleibt Store teil-rebuilt (schwaechere Garantie als "unveraendert"; Verhaltens-Neugestaltung, bewusst NICHT geheilt, als offener Punkt fuehrbar); (b) operator=-Pfad bei Teil-Wurf mit chunks_.size()==k-1 gegen size_==0 inkonsistent (Randnotiz, kein Pflichtfix); (c) vorbestehende all-Ziel-Luecken: test_profile_roundtrip, comdare_profile_run_facade + neuer Test haengen am comdare_tests-Sammler statt an all -- blanker "cmake --build . && ctest" meldet ***Not Run (bekannte Falle J-1..J-4).
ORT: axis_04_node_type_layout_aware_store.hpp (rebuild_); tests/unit/CMakeLists.txt
SOLL/FIX: (a)/(b) als Folge-Posten fuehren; (c) RE-CONFIGURE-Doktrin beachten.
STATUS LT. QUELLE: offen (Randnotizen)
ABHAENGIGKEIT/FLAECHE: Vollbau-Luecken-Doktrin

### [wn5hdyswe] 4
GEGENSTAND: Kartierungs-Wissen: Posten 64 (Referenz-Heilung) deckt bereits das gesamte std::vector-Konsummuster (~30 Konsumenten-Dateien dokumentieren "seit Posten 64 wirft StdAllocatorAdapter bad_alloc"); topics/ ist reine Weiterleitungs-Schicht (0 Substanz) ueber axes/ -- topics-Spiegel brauchten 0 Aenderungen; AllocatorStrategy-Concept erzwingt die OOM==nullptr-Konvention NICHT typsystemisch (Abweichung bleibt compile-clean unsichtbar) -- moeglicher Folge-Posten Concept-Haertung.
ORT: axis_06_allocator_concept.hpp:81
SOLL/FIX: ggf. Concept-Haertung als Folge-Posten.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: axes/-Wellen

## Datei wv1iqrso9.json (22175 B) -- LB-6 Stufe 1: Zeilen-Ruecklesung, mehrzeiliger Stempel, echte FS-Konkurrenz (Bau+Verifikation)
Bau: Branch b-lb6-stufe1 in /home/comdare/wt-lb6, Basis e7aa1244, 3 Commits ed9fca8e -> 5e6048ff ->
3558466d (Spitze). Verify-Verdikt: LANDEN. [Lt. wv3ha243c spaeter als b241a272 gemerged, beide Remotes.]

### [wv1iqrso9] 1
GEGENSTAND: LB-6 Stufe 1 gebaut: split_lines-Utility ausgelagert (oeb_stempel_zeilen.hpp, mehrzeiliger OE-B-Stempel-Fixture 4 Zeilen, lies_blatt_datei ueber ifstream = bewusst ANDERER Weg als Schreibweg); Ruecklese-Biss-Tests (Byte-Vergleich, count-Zeilen zuerst, jede Zeile einzeln benannt, Label je Position); echte FS-Konkurrenz (2 std::thread erzwungene Ueberschneidung + 4-Thread-Spin); TempLager/TempKnoten auf user_tmp_dir() (Posten 69/#278/#24 -- beide TUs hielten Haus-Regel bisher nicht ein). Produktions-Mutations-Bisse belegt (lager_baum_writer.hpp:489, bestandslog_lock.hpp:192) mit Delta-Beweis (Bestand blind fuer diese Fehlerklasse).
ORT: wt-lb6; tests/unit/support/oeb_stempel_zeilen.hpp; test_lb0/test_lb1/test_g1
SOLL/FIX: gelandet (b241a272) -- nicht neu beauftragen.
STATUS LT. QUELLE: behoben@3558466d
ABHAENGIGKEIT/FLAECHE: Probe-Merge gegen 47c4ef1d konfliktfrei; nach Merge ASCII-Wache + Voll-ctest einmal nachfahren

### [wv1iqrso9] 2
GEGENSTAND: ECHTES Rest-Race gemessen (nicht umgangen): bestandslog_lock kein CAS, store->Zweit-Verify nicht atomar; Bau 79/200 Laeufe >1 Thread im Alleinschreiber-Abschnitt (bis 3 von 4), Verify unabhaengig 69/200 -- gleiche Groessenordnung; Test assertiert BEWUSST keinen wechselseitigen Ausschluss (Design gibt die Zusicherung nicht; alle 200 Laeufe konvergieren byte-identisch, kein Lock-Leichnam; 1000/1000 stabil).
ORT: bestandslog_lock.hpp (Kopf-Deklaration Rest-Race-Fenster)
SOLL/FIX: Entscheidung nicht rueckgaengig machen (kein Ausschluss-Assert nachruesten).
STATUS LT. QUELLE: nur-hinweis (dokumentiertes Design-Fenster)
ABHAENGIGKEIT/FLAECHE: TSan-Vorschlag offen: .gitlab-ci.yml:625 fuehrt feste 3-Target-Liste (test_concurrency_disciplines, test_rcu, test_v41_axis_08_concurrency) -- test_lb1_knoten_heuristik_log FEHLT; Aufnahme = CI-Aenderung ausserhalb des Mandats, sachlich richtig, OFFEN

### [wv1iqrso9] 3
GEGENSTAND: KORREKTUR am Bau-Bericht (Messfehler, kein Baufehler): "gtest-Faelle suiteweit 8439->8444" NICHT reproduzierbar und als Invariante untauglich -- 178 der 407 ctest-Binaries sind KEINE gtest-Binaries (ignorieren --gtest_list_tests und fuehren sich aus); je Zaehlregel 3137/7967/8463, nie 8444; Zahl misst teils Programmausgaben statt Testfaelle. Empfehlung: Nenner kuenftig ueber Namensmengen je TU fuehren (60->65, verschwunden=leer), nie ueber Suite-Gesamtzahl.
ORT: Verify-Bericht
SOLL/FIX: Zaehl-Doktrin fuer kuenftige Gates uebernehmen.
STATUS LT. QUELLE: nur-hinweis (Doktrin)
ABHAENGIGKEIT/FLAECHE: Gate-Nenner-Regel (jede Zahl mit Nenner)

### [wv1iqrso9] 4
GEGENSTAND: Bewusst NICHT gebaut (Abgrenzungen): kein g1_binary_version_block()-Aufruf in Lager-TUs (Planer-Selbst-Stempel maschinenabhaengig, 8er-Docker-Matrix; waere profile_facade-Kante); keine Sidecar-Rueckluese (.fingerprint/.version/.algos/.variant -- Baum-Writer schreibt keine; eigener Posten bei build_orchestrator/fingerprint_sidecar.hpp); kein CI-YAML. Nachrangig: Frist-Marge 10 s (section_budget 30 s, A wartet 20 s -- pathologisch ueberlasteter Runner theoretisch deadline_exceeded); M4-Defekt kostet 20 s CI-Zeit.
ORT: siehe Gegenstand
SOLL/FIX: Sidecar-Ruecklese als eigener Posten falls gewuenscht.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: LB-6-Restposten (Beweis 1+4, Herabstufung -- siehe wv3ha243c Posten 27)

## Datei w4lq4gi7g.json (15605 B) -- Pflicht-Fixup 3: S-14a-Riegel bewacht Overlay-Grundgesamtheit (152->718 Records) + KON55-Kombibau
Bau-Workflow: Commit 8cc564d5 auf Branch bau/golden-s14a-riegel. landefaehig=JA_MIT_AUFLAGEN.

### [w4lq4gi7g] 1
GEGENSTAND: S-14a-Riegel geheilt: VORHER bewachte die Wache 152 von 387 Achsen-Headern und meldete GRUEN (Inhalts-Substring-Filter "algo_version" verengte auf Literal-Zitierer; 235 = 60% unbewacht); NACHHER Grundgesamtheit = Overlay-Schnitt (kOverlaySourceSet) 712 Quell-Dateien + 6 heuristik = 718 Records (organ 640, system 16, mess 1, tier_substanz 55, heuristik 6); D1-D6 umgesetzt (Overlay-Schnitt als Grundgesamtheit; Traeger-Austritt ROT beidseitig ohne --write-Weg; Aufwertung Exit 3; Deckungs-Beleg "deckt N von N"; Mindest-Nenner/ctest-Anker; Lock-Format v2->v3 Dreizeilen-Record mit Pfad-Split wegen 120-Spalten-Diff-Hygiene, laengste Zeile 92 Byte, v1+v2 werden laut abgewiesen); Differenz beidseitig benannt: 26 Alt-Home-Dateien BEWUSST unbewacht (telemetry 10, simd/isa 10, cacheline 3, axis_centric_namespaces, queuing-Huelle 2 -- 0 gelockt, 0 Literal; kehrt telemetry/isa in die Komposition zurueck, nimmt der Schnitt sie automatisch auf); 560 NEU unter Bewachung. Koeder-Protokoll ROT-ZUERST am alten Tool (Kern-Defekt literal: GRUEN bei fehlender neuer Datei) + T1-T5/O/M-Koeder + Mutationsprobe K13 beidseitig (Mutant A/B reissen an definierten Schritten).
ORT: tools/axis_version_lock/axis_version_lock.cpp (Filter ex-Zeilen 431/435); axis_version.lock (sha256 e7263b82..., --write 2x byte-identisch); builder/overlay_source_set.hpp
SOLL/FIX: Landung mit AUFLAGE: Formatwechsel v3 ist Zweig-uebergreifendes Ereignis -- nach Merge auf Zielzweig einmal contract:axis-version-lock (bzw. --check + --write + git diff) fahren; alte v2-Erwartungen in Zweig-Skripten werden LAUT abgewiesen.
STATUS LT. QUELLE: behoben@8cc564d5 (landefaehig mit Auflagen)
ABHAENGIGKEIT/FLAECHE: jeder parallele Zweig der das Lock regeneriert/liest; Anker-Pflege: organ traeger==123 EXAKT im ctest, Mindest-Nenner (600/12/1/50/6) bei #16-Umgliederung nachziehen

### [w4lq4gi7g] 2
GEGENSTAND: KON55-Kombibau NACHGEHOLT auf 8cc564d5: 4 Zellen sequentiell (gcc-deb/gcc-rel/clang-deb/clang-rel) je nach J-1..J-4 (Werkzeuge zuerst -> RE-CONFIGURE -> Vollbau -> comdare_tests -> volle Suite): 4x "100% tests passed, 0 tests failed out of 486"; Warnungs-Review zweimal: eigener Quelltext 0 clang-Warnungen; df-Wache je Zelle; Bauverzeichnisse geraeumt (Belegpruefung 0 getrackt/0 csv-xlsx); /tmp-Scratch inkl. Altbestaende entfernt; kein Push/Merge/Ledger-Edit; 6 Dateien einzeln gestagt.
ORT: wt (bau/golden-s14a-riegel)
SOLL/FIX: -
STATUS LT. QUELLE: behoben@8cc564d5
ABHAENGIGKEIT/FLAECHE: -

### [w4lq4gi7g] 3
GEGENSTAND: Offene Punkte: (a) VORBESTEHENDE gcc-Release-Warnung -Wstringop-overflow in libstdc++ stl_algobase.h:426 via test_v41_topic_traversal.cpp:132 (InterpolationSearchAlgo) ueber axis_06_allocator_exgen.hpp:87 -- NICHT aus diesem Diff (zuletzt 7d4dd809; gcc-Release wurde in Fixup 2 nie voll gebaut); Behebung braucht eigene Ursachen-Analyse; Pragma-Schnellfix am gelockten Traeger waere Literal-loser Byte-Drift = kein Weg; (b) Vendor-Warnung gtest-printers.h:524 char8_t->char32_t (fremd, verschwindet mit gtest-Update); (c) LEDGER-NACHTRAG zu Fixup 3 (KON-Faden S-14a) war per Auftrag ausgeschlossen -- dieser Bericht ist die Vorlage; (d) Lock-Regen aendert keine Golden-/Messdaten.
ORT: axis_06_allocator_exgen.hpp:87; test_v41_topic_traversal.cpp:132
SOLL/FIX: (a) eigener Ursachen-Posten; (c) Ledger-Nachtrag faellig.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: S-14a/KON-Faden; Wachen-Inventar-Branch

## Datei wzmkd5hfd.json (12351 B) -- Codex-Befunde am honest-empty-Paket heilen (echte-0-Klassifikation, 3D-Phantomboden) + Fable-Re-Review
Bau: EIN Commit 838612f3 auf b-honest-empty (Vorgaenger ba5e48eb), kein Push. Review-Verdikt LANDEBEREIT.

### [wzmkd5hfd] 1
GEGENSTAND: E-2b-Heilung: [HOCH] echt gemessene 0 -- HeatmapData traegt executed[y][x]-Maske; drei Zell-Klassen (ausgefuehrt>0 / ausgefuehrt==0 mit eigener 0-Farbklasse eine Dekade unter kleinster Mess-Dekade, Colorbar-Tick literal $0$ / nicht ausgefuehrt z=0+meta=nan); gemeinsame Wache cell_displayable/heatmap_mask_matches (2D+3D urteilen wortgleich); fehlende Maske = alte >0-Heuristik (Bestand). [MITTEL] 3D-Phantom: 1.0e-3 getilgt, Loecher via z=nan + unbounded coords=jump; explizite Gitter-Grenzen + Entartungs-Wache; 3D-z-Achse faellt bei echter 0 auf LINEAR (zmode=log liesse die 0 lautlos herausfallen -- per Gegen-Gegen-Probe belegt: RC=0 OHNE Warnung = verschwiegener Messwert). 3 neue Grenzfall-Tests; Gates: 28 Tests 2x, ctest 41 + 156 da_unit gruen; D-03-Probe + echt-0-Probe pdflatex RC=0 0 dropped.
ORT: Code/05_diagram_generator/{diagram_generator.cpp,.hpp,tests/...cached_fixtures.cpp}; wt-b-honest-empty ba5e48eb..838612f3
SOLL/FIX: Landung (ahead 2 / behind 14 gegen origin/development zum Review-Zeitpunkt).
STATUS LT. QUELLE: behoben@838612f3 (landebereit)
ABHAENGIGKEIT/FLAECHE: super-Branch bau/f1-1x1-honest-empty (landereif lt. Auftrag) -- Verhaeltnis 838612f3 zu diesem Branch vom Designer abzugleichen

### [wzmkd5hfd] 2
GEGENSTAND: Randbefunde (keine Blocker): (a) leeres \caption{} im 3D-Pfad (write_surface3d_search_algo_x_workload setzt data.title nie) -- vorbestehend, Kandidat Aufraeumpass; (b) clang-format lokal NICHT installiert (bekannte prod1-Luecke) -- Stil manuell angeglichen, nicht maschinell verifiziert; (c) voller ctest (560) zeigt 402 Fehler/Not Run AUSSCHLIESSLICH im ce-Submodul-Bereich (Ursache literal: Generator-Tool nicht gebaut, 2-Pass-Bau fehlt in diesem Worktree) -- vorbestehend, ausserhalb des Diffs.
ORT: diagram_generator.cpp (Caption-Zeile); Worktree-Bauluecke
SOLL/FIX: (a) Aufraeumpass; (b) clang-format-Installation prod1; (c) J-1..J-4 bei Vollpruefung.
STATUS LT. QUELLE: offen (Randbefunde)
ABHAENGIGKEIT/FLAECHE: F1-Welle/honest-empty

## Datei wmneau5l7.json (8506 B) -- Verlorene Buchfuehrung in den Ledger nachtragen (Owner-Auftrag)
Ergebnis: Commit 4589e079 auf super development (1 ahead, NICHT gepusht), nur Ledger-Datei; 433 Zugaenge /
0 Streichungen, append-only per sha256 bewiesen; abend-1 auf Z. 4202.

### [wmneau5l7] 1
GEGENSTAND: Zehn nachgetragene Posten N-1..N-10: N-1 FRIST-KORREKTUR 15.09. + Freitagslieferung (war 0/0 -- ordnet ALLES; zwingt Neusortierung der 33 gegen 08.08. sortierten Positionen = Lead-/Owner-Entscheidung, nur als To-do vermerkt); N-2 Kalibrier-Stichprobe = ERLEDIGT bevor beauftragt (Posten streichen, O-A bleibt offen); N-3 Zeit-Bilanz (19,4/32,25 min je 4096; 6,8/11,3 s 1-Thread; ~34,4 h Engpass intel; beim ersten Batch nachkalibrieren); N-4 Bau-Umfang 524288 kanonisch, KEINE Kappung (war falsch gebucht; Task #11 umformulieren); N-5 Batch-Semantik 4096=BINARIES, Jobs O(Maschinen)=4; N-6 XML-Trennung Bau/Messung fehlt = BAU-POSTEN T2 (XSD+Parser+Emission+Wache, war 0/0); N-7 LB-Status konsolidiert (LB-0..LB-3 Header da, Tests nur LB-0/34+LB-1/26; LB-6 Stufe 1 GELANDET ce b241a272; LB-4/LB-5 offen; ins Register, Task #9 umschreiben); N-8 A10/HW-Erkennung P4-P6 nicht gebaut (ins Register, T2); N-9 A11/ccache-Drop = OWNER-ENTSCHEID (Code widerspricht Plan; Empfehlung A11 zurueckziehen, T3); N-10 A12/E-14 NAS-Creds Status unklar (Owner-Frage gilt/erledigt/verworfen, T3). Zwei neue Regel-Zeilen 13 (Termine fallen durch Session-Doc-Ritze) + 14 (jede Trefferzahl traegt Bezugsgroesse).
ORT: super docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md @4589e079
SOLL/FIX: je Posten wie benannt; Push des Commits ausstehend.
STATUS LT. QUELLE: teilweise (gebucht, To-dos offen)
ABHAENGIGKEIT/FLAECHE: W-20-Termineichung; Register-Nachzuege

### [wmneau5l7] 2
GEGENSTAND: 9+3 Selbst-Korrekturen beim Nachpruefen (Zitier-Anker fuer Designer): LB-0..LB-6 = 11 Ledger-Treffer (nicht 0/0; 0 gilt nur Register); A10/A11/A12 stehen seit 699edaa2 im Ledger (nicht 0/0); Ledger 6169 Zeilen (nicht 5840), Register 474 (nicht 475); Par.62-B-Zitat "NIEMALS Einzel-Jobs je Binary" steht LEDGER:3318 (nicht 3320); .gitleaks-ccache-Eintrag auf :29; build_orchestrator-Kommentar :124; "Pipeline fasst experiment_golden_kern.xml nie an" ZU WEIT -- 4 super-ctest-Wachen konsumieren sie (Code/tests/CMakeLists.txt:170/:173/:211 + golden_n_consistency_check/fixture_schema_subset_check/fixture_sync_check in test:unit); belastbar nur "nicht das Profil der golden-Bau-/Mess-Kette" (das ist all_axes_golden.profile.xml); test_lb1 = 26 Faelle (nicht 23), test_lb0 = 34; LB-6 Stufe 1 hat KEIN eigenes Test-TU; Owner-Zahl "11 s trifft intel exakt" in der ZUORDNUNG UNBELEGT ("die grosse Maschine" = prod1/amd = 6,8 s). UNBELEGT gekennzeichnet: Zahl 4 der unvermessenen PRUEF-Durchlaeufe; "cap==Basis-Kardinalitaet" abgeleitet nicht gemessen (hart belegt: comdare_experiment-Dialekt hat GAR KEIN cap-Feld in struct ExperimentProfile, xml_config_parser.hpp:440-473); Zeit-Werte aus ZWEI Pipelines (12690 amd, 12713 intel). Zusatzfund: Slice 4096 am Objekt belegt (Session 20260723:33-34).
ORT: siehe je Anker
SOLL/FIX: Anker bei Weiterverwendung korrekt zitieren.
STATUS LT. QUELLE: nur-hinweis (Korrektur-Liste)
ABHAENGIGKEIT/FLAECHE: alle Berichte, die die alten Anker zitieren

### [wmneau5l7] 3
GEGENSTAND: Entlastung waehrend der Arbeit: fremde Commits 1517071b + e110cf6d versionierten alle drei zuvor unversionierten Dispositionsdokumente INKLUSIVE PLAN-kostenklammer-restposten.md (schaerfster Strukturbefund von nachmittag-11) -- gebucht, "weil eine ungebuchte Heilung genauso verlorengeht wie ein ungebuchter Defekt".
ORT: super 1517071b, e110cf6d
SOLL/FIX: -
STATUS LT. QUELLE: behoben
ABHAENGIGKEIT/FLAECHE: -

## Datei wmjsu2y29.json (4401 B) -- Codex-Zweitlens fuer die A1-Scheibe (0b5ed557, wt-b-a1)
Zweitlens-Review zur A1-Wurf-Vertrag-Scheibe. WICHTIG: Befunde stehen GEGEN das LANDEBEREIT-Verdikt
des Fable-Reviews (wn5hdyswe) -- Designer muss abwaegen.

### [wmjsu2y29] 1
GEGENSTAND: HOCH: Tier-DLL-Semantik aendert sich (Wurf-Vertrag), aber KEIN produktives algo_version-/Fingerprint-Glied wird invalidiert -- da der Source-Hash (Overlay-Glied) derzeit leer ist, kann ein VOR dem Commit gebautes Binary mit identischem Fingerprint wiederverwendet werden und behaelt die alten nullptr-UB-/Leck-/Pool-Wurfpfade. Es fehlt ein cachewirksamer Versions-Bump fuer alle betroffenen Allokatorvarianten bzw. ein gemeinsamer Vertragsstempel.
ORT: axis_06_allocator_strategy_base.hpp:153; axis_06_allocator_pool_resource.hpp:97
SOLL/FIX: Versions-Bump/Vertragsstempel vor/mit Landung der A1-Scheibe; Zusammenhang mit Overlay-Glied-Scharfschaltung (S4.1) und X.Y.Z-Bump-Doktrin ("update von X.Y.Z im Stempel Pflicht, sodass das Binary ueberhaupt neu gebaut wird").
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: A1-Scheibe-Landung (b-a1-wurf-vertrag); Fingerprint-/Stempel-Wellen; heute praktisch entschaerft solange Sidecar-Bestand 0 (kein Skip moeglich) -- Designer pruefen

### [wmjsu2y29] 2
GEGENSTAND: MITTEL (2x): (a) PMR-Adapter darf nullptr auch fuer bytes==0 nicht zurueckgeben (memory_resource::do_allocate verlangt Zeiger oder Wurf; PMR hat KEINE Nullgroessen-Ausnahme; neuer Test zementiert das falsche Oracle und ruft sogar deallocate(nullptr,0,...) auf) -- PMR muss bei jedem nullptr werfen, raw/Std behalten Zero-Size-Ausnahme; (b) neuer Compile-Regress fuer strukturell konforme Allokatoren: Store verlangt nur AllocatorStrategy<A>, Concept fordert weder CRTP-Ableitung noch allocate_or_throw -- ein zuvor funktionierendes konformes A scheitert mit "no member named allocate_or_throw" (registrierte CRTP-Varianten nicht betroffen). copy_from_: OHNE BEFUND (Basic, nicht Strong Guarantee; kein Double-free). Erfolgspfade wegen zusaetzlicher Pruefungen/EH-Code NICHT literal instruktions-/timingneutral (gegen die "byte-identisch"-Behauptung der Kartierung abzuwaegen).
ORT: axis_06_allocator_strategy_base.hpp:298; axis_04_node_type_layout_aware_store.hpp:276,:665
SOLL/FIX: (a) PMR-Zero-Size-Semantik fixen + Test-Oracle korrigieren; (b) Concept um allocate_or_throw erweitern ODER Store-Anforderung dokumentieren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: A1-Scheibe vor Landung nachbessern oder Befunde als Folge-Posten deklarieren

## BILANZ LESER 5
- 13 von 13 Batch-Dateien vollstaendig gelesen (result + summary + workflowProgress via strukturiertem Dump
  unter /home/comdare/.claude/jobs/5a19728e/tmp/komplexfix_design_arbeit/leser05_dumps/, Rohquelle unveraendert).
- 143 Extraktions-Posten (je Datei: wv3ha243c 41, wjjqbvdb7 18, wr08h0dkm 28, wjjsi0tpp 15, w210ypdj1 11,
  w7gt8fx1n 9, wpe8akoch 3, wn5hdyswe 4, wv1iqrso9 4, w4lq4gi7g 3, wzmkd5hfd 2, wmneau5l7 3, wmjsu2y29 2).
- Commit-SHA-Behauptungen (Auswahl, zu verifizieren): 2e1f9c1d (b-r3-mess-defines-preimage, landereif),
  0b5ed557 (b-a1-wurf-vertrag, landereif MIT Codex-Gegenbefunden), 8cc564d5 (bau/golden-s14a-riegel,
  JA_MIT_AUFLAGEN), 838612f3 (b-honest-empty, landebereit), 3558466d->b241a272 (LB-6 St.1 GELANDET),
  4589e079 (Ledger-Nachtrag, ungepusht), bba4d90f (M-1 ohne Format-Bump), dcbaa728 (G-E3-Schreiber),
  aa223961/7969b399/e7aa1244/47c4ef1d/b241a272/3bbcb8ed (ce-Staende), 8970465d/29a1700d/8e58f691/
  a6c7598c/19e1592 (thesis), 72eab9ae/123b2f32/699edaa2/e110cf6d/1517071b (super).
- Kern-Konfliktlinien fuer den Designer: (1) Format-Bump-Streit R-3 ist durch wpe8akoch AUFGELOEST
  (gebaut, 9. Glied, Format 4) -- aeltere W-02-Befunde als ueberholt markieren, aber Merge-Reihenfolge
  gegen Basis-Staende (aa223961 vs 7969b399 vs b241a272) klaeren; (2) Codex-Zweitlens wmjsu2y29 steht
  gegen Fable-LANDEBEREIT der A1-Scheibe; (3) M-/F-/O-Nummern-Kollisionen (W-17/W-18) durchgaengig;
  (4) Wallclock-SOLL + E-Label lt. KON36 offen, lt. MEMORY per KON37 beantwortet -- KON37 gegenlesen;
  (5) Owner-GOs aus w210ypdj1 (A-2/A-3-Rotation, D-1..D-4, C-2..C-4) vielfach unverbucht.
LUECKEN/RESTZWEIFEL DIESES LESERS:
- Die JSON-Felder logs/agentCount/totalTokens wurden nicht extrahiert (kein Befund-Gehalt).
- w7gt8fx1n Posten 5-8 fassen die 56-Fakten-Liste komprimiert; der volle KON36-Wortlaut steht im Dump
  (leser05_dumps/w7gt8fx1n.txt) fuer den Designer bereit.
- Keine Objekt-Verifikation der SHA-/Zeilen-Behauptungen (Auftrag: NUR LESEN); alle Staende altern.

SELBSTCHECK: Datei ASCII-only geprueft, 13/13 Dateien gelesen, 143 Posten, Format je Posten eingehalten.
HINWEIS: leser05_dumps/*.txt sind VERBATIM-Auszuege der Quell-JSONs (enthalten deren Original-Umlaute) --
Lese-Hilfsmaterial, kein eigener Bericht; die ASCII-Regel gilt fuer diese Extraktionsdatei (geprueft: 0 Nicht-ASCII).
