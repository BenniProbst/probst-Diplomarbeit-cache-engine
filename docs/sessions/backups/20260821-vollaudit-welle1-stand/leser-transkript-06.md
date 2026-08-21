# Sammelstrecke Vollaudit — Leser gruppe_06.txt

Quelle: `/home/comdare/.claude/jobs/5a19728e/tmp/vollaudit/gruppe_06.txt` (3911 Zeilen, KONTEXT-FENSTER 9ff., Z14222 ff.)

| KUERZEL/Name | Klasse | Quelle (Z-Anker/Abschnitt) | Status LAUT QUELLE | Traeger/Task |
|---|---|---|---|---|
| Flag-Grammatik v2 (Punkt-Notation, Komposit) | FEATURE | Z14222 Summary §2/§3, Z14300 | GEPLANT->GEBAUT (Design fertig 423Z., Bau gestartet Branch bau/flag-grammatik-v2) | Task #36, Agent "Bau-Grammatik-v2" |
| SIMD-Katalog (30 Flags, 4 Tiers: 17 Avx512/5 Avx256/5 Companion/3 Scalar) | FEATURE | Z14222 Summary §2, Z14326 | GEBAUT (6 Lenses fertig, 596k Tokens) | wf_93522b50-447 |
| POD-Kodierung anatomy_stamp_entries.hpp (Bit0 experimental, Bit1-2 HW-Flag, Bit3-5 Meta-Meta-Ebene) | FEATURE | Z14222 Summary §2 | GEBAUT | - |
| Drei Realm-Zeilen + SHA512 ueber neun Preimage-Glieder (consteval, fingerprint_format=4) | FEATURE | Z14222 Summary §2 | GEBAUT | - |
| kOrganAxisCount = 18 | FEATURE | Z14222 Summary §2 | GEBAUT (Konstante) | - |
| vor_push_alle_wachen.sh (Sammel-Gate, nennt ungeprüfte Gates) | FEATURE | Z14222 Summary §3 | GEBAUT (NEU) | - |
| W4-Gate Quarantaene (codegen.cpp, kQuarantinedPrtArtProfileId) | FEATURE | Z14222 Summary §3 | GEBAUT | AP-2-neu/#236 |
| csv_to_latex.cpp Generator (drei Drifts, Row um trailer erweitert) | REGRESSION | Z14222 Summary §3 | BEHOBEN | super/Code/04_csv_to_latex |
| simd_organ_sensibility.hpp (neun Organ-Klassen, prefetch=leere Menge) | FEATURE | Z14222 Summary §3 | GEBAUT | - |
| simd_build_gate.hpp/simd_organ_requirement.hpp (static_assert Gate) | FEATURE | Z14222 Summary §3 | GEBAUT, aber INERT (alle Organ-Klassen heute leer) | - |
| Stille Null durch falschen Suchpfad ($CE/include existiert nicht) | REGRESSION | Z14222 Summary §4.1 | BEHOBEN (Fix: libs/cache_engine/) | - |
| grep -v '/build' frisst '/builder/' | REGRESSION | Z14222 Summary §4.2 | BEHOBEN (Fix: /build/ beidseitig), mehrfach getreten laut Memory | - |
| Falscher Checkout auf Feature-Branch statt development | REGRESSION | Z14222 Summary §4.3 | BEHOBEN | - |
| V-08-Fehlalarm (behauptet keine PMC-Quelle, real L1/L3/DTLB/RAPL erhoben) | REGRESSION | Z14222 Summary §4.4 | BEHOBEN (erkannt+korrigiert) | - |
| --force-Loeschung mit ungetrackter Arbeit (1104 Zeilen) | REGRESSION | Z14222 Summary §4.5 | BEHOBEN (aus Agenten-Transkript geborgen) | - |
| Erfundener SHA bei update-index --cacheinfo | REGRESSION | Z14222 Summary §4.6 | BEHOBEN (Fix: git rev-parse + cat-file -e) | - |
| Format-Abweichung mit-committet (clang-format) | REGRESSION | Z14222 Summary §4.7 | BEHOBEN (erkannt, Commit lief im selben Block) | - |
| cppcheck-Rot Pipeline 15199 (7x uninitMemberVarNoCtor) | REGRESSION | Z14222 Summary §4.8 | OFFEN-REGRESSION ("meine Wache faehrt kein cppcheck") | - |
| Zu weites Suchmuster x512 trifft avx512 (119 Schein-Treffer) | REGRESSION | Z14222 Summary §4.9 | BEHOBEN (Fix: Wortgrenzen) | - |
| Design-Fehler Meta-Meta-Gruppe am Eintrag statt Zeilenende | REGRESSION | Z14222 Summary §4.10 | BEHOBEN (Bestand korrekt) | - |
| Stale Generator-Binary -> Roundtrip-Test falsch rot | REGRESSION | Z14222 Summary §4.11 | BEHOBEN | - |
| EXCLUDE_FROM_ALL-Targets haengen nicht am Default-Target | REGRESSION | Z14222 Summary §4.12 | dokumentiert, Status nicht explizit (vermutlich BEHOBEN) | - |
| Hardware-Flags gelten fuer Stempel UND xlsx/CSV | OWNER-ENTSCHEID | Z14222 Summary §6.1 (User-Zitat) | GESETZT | - |
| Wellen so parallel wie moeglich fahren + 2 Kontexte nach vergessener Arbeit durchsuchen | OWNER-ENTSCHEID | Z14222 Summary §6.2 | GESETZT | - |
| Doppel-Audit pausieren, keine neue Arbeit annehmen, Rest auslaufen lassen | OWNER-ENTSCHEID | Z14222 Summary §6.3 | GESETZT | - |
| Pruefen ob T-9 abgearbeitet + liegengebliebene Arbeit beheben | AUFGABE | Z14222 Summary §6.4 | AUFTRAG | - |
| Welle D per Audit wiederholen, zum Abschluss bringen | AUFGABE | Z14222 Summary §6.5 | AUFTRAG (Audit bestaetigte UNGEPRUEFT-Vermerk: gtest-Makros an Komma-Template-Argumenten nicht uebersetzbar) | - |
| Alle Rueckfragen und Entscheidungen direkt vorlegen | OWNER-ENTSCHEID | Z14222 Summary §6.6 | GESETZT (Prozessregel) | - |
| Zeitstempel-Frage: Uhrzeit/Datum in Stempel einkompilieren war dumm | OWNER-ENTSCHEID | Z14222 Summary §6.7 | WIDERLEGT (anatomy_fingerprint_hex ist consteval, alle 9 Glieder zeitfrei) | - |
| Temporaere Branches parallel entwickeln, bei Erfolg mergen+loeschen | OWNER-ENTSCHEID | Z14222 Summary §6.7 | GESETZT | - |
| Ultracode-Doppel-Audit (Fable 5 xhigh + Codex) ueber 3 Kontexte | OWNER-ENTSCHEID | Z14222 Summary §6.8 | GESETZT/AUFTRAG | - |
| e-Flag hoechste Prioritaet, ganz vorn (jedes Zeichen = Filter fuer HW-Bereich) | OWNER-ENTSCHEID | Z14222 Summary §6.9 | GESETZT | - |
| Zurueck zur Claude Code Arbeitsweise strikt | OWNER-ENTSCHEID | Z14222 Summary §6.9 (Frage 9) | GESETZT | - |
| Explore-Doktrin: Sonnet 5 max effort very thorough kartiert, Lead liest danach selbst tief gegen | OWNER-ENTSCHEID | Z14222 Summary §6.10 | GESETZT (Dauerregel) | - |
| c{p.e} Notation: e=efficiency-core (deprecated als 'experimental'), Trennung durch '.' | OWNER-ENTSCHEID | Z14222 Summary §6.12 | GESETZT | - |
| Explore + Vereinigung mit Planung der letzten 4 Wochen | AUFGABE | Z14222 Summary §6.13 | AUFTRAG | - |
| Eckige Klammern = ganze Achsen-Kategorie; '=code' ergaenzt | OWNER-ENTSCHEID | Z14222 Summary §6.14 | GESETZT | - |
| Systemachse: mind. x512 irgendwie freigegeben (simd=x512.f@1.0.0) | OWNER-ENTSCHEID | Z14222 Summary §6.15 | GESETZT | - |
| ZWEIPHASIG/DREIPHASIG-Definition fuer alle 3 Achsen-Kategorien lesen | AUFGABE | Z14222 Summary §6.16 | AUFTRAG | - |
| 'code' = Name der Implementierungs-Klasse, compile-time auslesbar; 1 Achse = 1 CT-Algo im Tier-Binary | OWNER-ENTSCHEID | Z14222 Summary §6.17 | GESETZT | - |
| Hybrid kapselt alle moeglichen Tier-Binaries in [] Klammern | OWNER-ENTSCHEID | Z14222 Summary §6.18 | GESETZT | - |
| Alte Wege komplett ersetzen (Stempel-Zeilen-Struktur bleibt: Achsen+SHA) | OWNER-ENTSCHEID | Z14222 Summary §6.19 | GESETZT | - |
| Compiler-Unterschiede NICHT weg-normalisieren (jeder Compiler eigener Permutationszweig) | OWNER-ENTSCHEID | Z14222 Summary §6.20 | GESETZT | - |
| Punkt vor erstem Flag; hinter [ kein fuehrender Punkt; hinter { kein fuehrender Punkt; 'v' faellt weg | OWNER-ENTSCHEID | Z14222 Summary §6.20-21 | GESETZT | - |
| F-1..F-10 Rueckfragen-Bloecke (string_view Wache, efficiency-cores als sub-Flag unter c, Hash, a UND b, SIMD-Webrecherche, Hybride eigene Adapter-Gattung) | OWNER-ENTSCHEID | Z14222 Summary §6.22 | GESETZT | - |
| Wellenplan/Phasenplan Hauptstrang fortsetzen, Hybrid hat eigene Organ-Achsen+Fingerprint+Mess/System/Organ/SHA-Zeilen | OWNER-ENTSCHEID/AUFGABE | Z14222 Summary §6.23 | GESETZT | - |
| c{p.e}: {p}=Default (performance cores), p/e je eigenes Komposit-Flag | OWNER-ENTSCHEID | Z14222 Summary §6.24 | GESETZT | - |
| Explore-Agenten: Plaene letzte 3 Wochen + vergessene Aufgaben; Frage Phase 3/4; reiche Kontextuebergabe, dennoch weiterarbeiten | AUFGABE/OWNER-ENTSCHEID | Z14222 Summary §6.25 | AUFTRAG, GESETZT | - |
| Ledger-Nachtrag "Phase 3/4 richtig zugeordnet" (Lead-Fehlzuordnung) | REGRESSION | Z14240-Z14242, Commit 3864f7f0 | BEHOBEN (Korrektur committet), spaeter von Verify als teilweise unvollstaendig markiert | - |
| S1/S3-Kopplung Flag-Grammatik (Parser lehnt v1.0.0c ab -> gesamter Bestand unparsbar) | AUFGABE | Z14271 | AUFTRAG (Bau-Reihenfolge-Aenderung, S1+S3 nicht getrennt landbar) | Task #36 |
| Verifikation Korrektur Phasenzuordnung (Explore-Agent) | AUFGABE | Z14285-Z14287 | AUFTRAG (Nenner 338 Literale statt 138 gefunden) | Agent "Korrektur der Fehlzuordnung verifizieren" |
| Bestand invalidieren ist gewollt, kein Migrationszwang | OWNER-ENTSCHEID | Z14314, Memory-Datei angelegt Z14342-Z14344 | GESETZT | - |
| E4-XML-Roadmap Dossier 17 (#229) existiert real | REGRESSION/UNKLAR | Z14299 | Praezisiert: zwei reale Nummerierungen statt "eine richtig, eine erfunden" | - |
| Verify-Phasen-Korrektur Bericht: Korrektur RICHTIG, ein Punkt unvollstaendig (nur 2 statt >=3 Phase-Nummernkreise genannt) | REGRESSION | Z14383-Z14383 (teammate-message) | OFFEN-REGRESSION bzgl. Vollstaendigkeitsanspruch, sonst BEHOBEN | Verify-Phasen-Korrektur (Peer-Session) |
| Dossier 16 (16_E1_E4_KONSOLIDIERUNG_DOSSIER.md) dritter Phase-Nummernkreis (Phase 4=#31/E4-XML) uebersehen | REGRESSION | Z14383 F7 | OFFEN erkannt, praktisch inaktiv laut LEDGER:6855 (historisch/superseded) | - |
| Lead committet unverifizierte Behauptung vor Verifikations-Rueckkehr (Wendung 1 vor Ergebnis) | REGRESSION | Z14383 F4 Punkt 4 | erkannt/dokumentiert, als "prozessual fragwuerdig" vermerkt | - |
| Task #40 PHASE 4 KLEMMT AN DREI STELLEN | AUFGABE | Z14373-Z14374 | ANGELEGT, spaeter umbenannt (Z14403) zu "PHASE 4 (XML-Lesart) IST OWNER-GATED" | Task #40 |
| Task #41 DER EINE VERGESSENE POSTEN: allocators/*.profile.xml (23 Akten) | AUFGABE | Z14376-Z14377 | OFFEN (0 Treffer im Code UND ...) | Task #41 |
| Task #36 Flag-Grammatik v2 im Bau (Branch bau/flag-grammatik...) | AUFGABE | Z14378-Z14379 | in_progress | Task #36 |
| Nachtrag abend-3 Ledger (Verify-Befund gebucht) | AUFGABE | Z14395-Z14397 | GEBUCHT | - |
| Memory feedback_eigene_arbeitsfehler_lead (Klasse 1: Berichte als Tatsachen uebernehmen) | REFERENCE/UNKLAR | Z14406-Z14408 | dokumentiert als Dauerlehre | - |

| Limits-Entkopplung (6-Stufen-Gate-Plan, Schicht E3 Paket C) | FEATURE | Z14423-Z14498 | GEBAUT/ERLEDIGT (Gates 1-3 gebaut+adversarial reviewed, urspruengl. Gate 6 gesucht, dann Fehlbefund: bereits VOLLZOGEN) | Task #40 |
| source_catalog.hpp / comdare_profile_run_facade (generierter Katalog produktiv verdrahtet) | FEATURE | Z14460-Z14482 | GEBAUT, CI-BEWIESEN (profile_run_entry.hpp:29 inkludiert, Messtreiber linkt, FATAL bei Fehlen) | - |
| Dossier 17 Roadmap (17_E4_XML_VOLLVISION_ROADMAP.md) als stale erkannt | REGRESSION | Z14494-Z14500, Commit 00d2a83f | BEHOBEN (deprecatet, nicht geloescht) | - |
| Task #40 Fehlbefund widerrufen: Limits-Entkopplung ist vollzogen | REGRESSION | Z14483-Z14492 | BEHOBEN (Ledger-Nachtrag abend-4) | Task #40 |
| Task #38 Generator-Ruckfall (csv_to_latex.cpp) nachgeprueft | REGRESSION | Z14513-Z14524 | BEHOBEN, bestaetigt/CI-BEWIESEN (super 6d837e7d) | Task #38 |
| Objektpruefung + Lageplan-Sichtung, bis zu 8 Arbeitstraenge parallel | OWNER-ENTSCHEID | Z14528 (User-Zitat) | GESETZT | - |
| 8 parallele Straenge hochgezogen (Flag-Grammatik, Allocators-Gate, Trigger/Restposten, PMC-Ehrlichkeit, Lageplaene, Stale-Doku, STOPP-Gates-Vorlage, DE/EN-Drift) | AUFGABE | Z14536-Z14567 | GESTARTET | - |
| allocators-Coverage-Gate (test_allocator_profile_bestand.cpp, 23 Akten) | FEATURE | Z14509, Z14583-Z14606, Commit 077e6e61 | GEBAUT (Abdeckungs-Gate), Befund: alle 23 Akten tragen DOKU-AKTE-Kopf seit 22.07. -> "vergessener Posten" war nie vergessen | Task #41, Bau-Allocators-Gate |
| Architektur-Doku ABI-Stand-Korrektur (ABI-MAJOR==4 falsch, Code-Ist=8) | REGRESSION | Z14396 teammate Lageplan-Disjunkt | OFFEN in 2 Dateien (16_...md:189/271, 18_...md:104/144), ~31 weitere Dateien UNGEPRUEFT | Strang "Doku-Stale-Sweep" |
| STOPP-Gates E-A..E-F in Owner-Vorlage (Task #39) | AUFGABE | Z14396 (Lageplan-Bericht) | OWNER-GATED, kein Bau ohne Entscheid | Task #39 |
| 43-Positionen-Audit (20260807-AUDIT-ledger-vollstaendigkeit) | REFERENCE/UNKLAR | Z14396 | TEILWEISE offen, ueberwiegend Owner-Fragen/Ueberschneidung mit PMC-Bereich; NICHT pauschal vergeben empfohlen | - |
| 16 verwaiste Thesis-Alt-Kapitel (01_introduction..08_conclusion, DE+EN) | REGRESSION | Z14396 Punkt "SCHEINBAR OFFEN" #1 | GESTRICHEN als offener Posten (bereits dokumentiert+selbstmarkiert seit 20260806-DIFF, deprecated nicht geloescht) | - |
| Sibling-XML-Verzeichnisse sota/(34)/load_profiles/(21)/thesis_profiles/(11) | FEATURE | Z14396 Punkt "SCHEINBAR OFFEN" #2 | GEPRUEFT, aktiv verdrahtet, kein offener Posten | - |
| A15/§55-Reconcile (43 Positionen, "17 ungeprueft") | AUFGABE | Z14396 Punkt "SCHEINBAR OFFEN" #3 | TEILWEISE offen, braucht eigene Vorab-Triage | - |
| §58-REPLAY (Planer-Caching-Replay, kOrganAxisVersionLine) | AUFGABE | Z14396 "Zusaetzlich geprueft und verworfen" | ZURUECKGESTELLT (Kollision mit Flag-Grammatik-v2) | - |
| M-3a branch_misses, V-03/V-05-Reste, GN-9, A14/FF0 | AUFGABE | Z14396 "Zusaetzlich geprueft und verworfen" | ZURUECKGESTELLT (Kollision mit Verify-PMC-Ehrlichkeit) | Task-Board #8/#25/#27/#28 |
| Thesis DE/EN-Drift Kartierung | AUFGABE | Z14563-Z14631 teammate Thesis-DE-EN-Drift | ABGESCHLOSSEN: Gesamturteil "DRIFT IST KLEIN" (Struktur 100% identisch, Wortverhaeltnis 1,08-1,27 normal) | Thesis-DE-EN-Drift |
| F_comparison_interfaces Wortverhaeltnis-Ausreisser (1,08) | UNKLAR | Z14396 Tabelle/§Nachzieh-Liste | OFFEN klein (empfohlen: manueller Zweitblick, Struktur aber 1:1) | - |
| C_glossary Wortverhaeltnis (1,27), nicht wort-fuer-wort verglichen | UNKLAR | Z14396 §Nachzieh-Liste | OFFEN klein | - |
| 2^17 vs 2^18 Organ-Permutationen Formulierung (18 Achsen, persistence_target gepinnt auf 1) | REGRESSION | Z14615-Z14625 | AUFGEKLAERT (Thesis rechnet richtig 2^17x1, Formulierung verschweigt nur die Pinnung) | - |
| Commit 8197a2c: zwei falsche Achsen-Nummern in EN-Fassung nachgezogen | REGRESSION | Z14396 (Thesis-Drift-Bericht, historischer Fund) | BEHOBEN (historisch, EN lag zeitweise hinter DE) | - |
| P-1 branch_misses wird nicht real erhoben (M-3a) | REGRESSION | Z14633 teammate Verify-PMC-Ehrlichkeit | BESTAETIGT/OFFEN-REGRESSION (kein perf_event_open mit PERF_COUNT_HW_BRANCH_MISSES; Feld kann strukturell nie n/a werden, immer PmcCounters-Default 0; Anhang-Kennzeichnung fehlt, aber kein Downstream-Konsument liest Spalte aktuell) | linux_perf_pmc_source.hpp, cache_engine_builder_iterator.hpp:868-871 |
| P-2 pmc_cache_misses_l3 auf AMD falscher Wert (Pipeline A vs B) | REGRESSION | Z14633 P-2 | TEILWEISE: Pipeline A (golden/CI) BEHOBEN (Guard B5/M-2-KORREKTUR-2, 06.08., format_csv_row rendert n/a); Pipeline B (f15_compare, measurement_snapshot.hpp, NICHT CI-verdrahtet) weiterhin OFFEN-REGRESSION (kopiert blind ohne source_available-Pruefung) | linux_perf_pmc_source.hpp:280, measurement_snapshot.hpp:136-151 |
| m3v2_pmc_smoke.cpp akzeptierte counters_all_zero als Erfolg (Aufgabe #26) | REGRESSION | Z14633 P-2 | BEHOBEN (echtes 32-MiB Pointer-Chasing, kPmcExpected-Gate) | Aufgabe #26 |
| P-3 getrennte P/E-Core-Messung (Scope-Freeze P1, seit 09.04. Pflicht) | REGRESSION/AUFGABE | Z14633 P-3 | BESTAETIGT nie gebaut (Messung selbst fehlt: kein HybridCorePinning/measure_per_class); Erkennungs-Vorstufe (numa_cpu_pin_process_probe_linux.hpp) HEUTE 07.08. gebaut, Status Review-Befund L-1 | hardware_probe_factory.hpp |
| hybrid_core_aware Feld (i_measurement_source.hpp:55) defaultet false, nie true gesetzt | REGRESSION | Z14633 P-3 | OFFEN-REGRESSION | - |
| P-4 PMC-Preflight "vier Wachen, keine beisst" (SW-3, Dossier 20260806) | REGRESSION | Z14633 P-4 | Wache1 (Compile-Flag fehlte) BEHOBEN (Commit 8894d983, alle 4 Emissionsstellen); Wache2 BEHOBEN (s.o. #26); Wache3 (allow_failure:true) WEITERHIN VORHANDEN, jetzt bewusst kommentiert als Absicht; Wache4 (Preflight-Logik) unveraendert, aber durch Wache1-Heilung jetzt sinnvoll | experiment_plan_director.hpp:895/933/1254/1407 |
| Gegenprobe-Tabelle Guard-Abdeckung (l2/l3/coherence/energy vs branch_misses, Pipeline A/B) | REGRESSION | Z14633 "GEGENPROBE" | ZUSAMMENFASSUNG: Pipeline A voll gedeckt (ausser branch_misses), Pipeline B bei KEINEM Feld gedeckt, branch_misses nirgends gedeckt | - |

| M-3a branch_misses PMC-Ehrlichkeit bauen (Worktree bau/m3a-branch-misses-ehrlichkeit) | AUFGABE | Z14650-Z14664 | GESTARTET (baubar, generischer portabler Zaehler ueber PERF_TYPE_HW_CACHE) | Task #8/#28 |
| T-A P3-TRIGGER-Blocker (plan_resume_skips, Tripwire, Teil-Resume-Test) | AUFGABE | Z14631 teammate Verify-Block-Trigger | BESTAETIGT, produktiv verdrahtet+CI-getestet (ctest -LE pmc) | - |
| T-B Restposten 3 Codex-Focus-Scopes (5 Punkte) | AUFGABE | Z14631 T-B | TEILWEISE: 3/5 erledigt (Doku-Drift-Fix, P-PMC-1-Paket, LB-6 Stufe1); 2 OFFEN (fail-closed-Wache target_isa.numa_node/.page fehlt in validate_profile.hpp; COMDARE_VARIANT_GATE fehlt in Aufraeumpass-Kandidatenliste) | - |
| T-C Entlastungen des Tages (COMDARE_BESTANDSLOG-Forward, COMDARE_VARIANT_GATE obsolet, Shaped-Emission default-OFF) | AUFGABE | Z14631 T-C | BESTAETIGT 3/3 (Randbefund: tote Env-Var COMDARE_VARIANT_GATE selbst nicht entfernt) | - |
| T-D Bau-Menge/Zahlenkonflikt Faktor 16 (2^17 vs 524.288 vs 2.097.152) | AUFGABE | Z14631 T-D, Z14703-Z14705 | OFFEN (Zahlenkonflikt besteht), aber Dringlichkeit korrigiert: faellig vor Voll-Messung, NICHT vor erstem Batch | Task #21 |
| T-E Frist-Korrektur 15.09. verankert | OWNER-ENTSCHEID | Z14631 T-E | BESTAETIGT (keine aktive 08.08.-Referenz mehr) | - |
| T-F R-3 xlsx-Writer | AUFGABE | Z14631 T-F | OFFEN (kein Writer gebaut, nur Design-Doc 20260803-a9_xlsx_writer) | - |
| T-F G-1 E-A..E-F Owner-Vorlage | AUFGABE | Z14631 T-F | weiterhin 🔴 OFFEN | Task #39 |
| T-F G-2 T19 persistence_target | OWNER-ENTSCHEID | Z14631 T-F | OFFEN, "NICHT ERFUNDEN...honest-empty" (axis_optimization_catalog.hpp:50-53) | - |
| T-F G-3 Pareto (best_binary_selector 6 Metriken hart Minimize) | REGRESSION | Z14631 T-F | BESTAETIGT 4/4 (keine CSV->Katalog-Id-Bridge, Default-Metrikmenge hartcodiert, nur 1 Artefakt versandt) | best_binary_selector.hpp:236-254 |
| T-F G-4 Cluster (kein k-Konsens, Linkage ohne Default) | REGRESSION | Z14631 T-F | BESTAETIGT 5/5 | workload_cluster_offline.hpp |
| T-F G-5 Enum RunMethodology {Debug,Measure,Release,Compare} | OWNER-ENTSCHEID | Z14631 T-F | verifiziert unveraendert, O-A (07.08.) klaerte Stufen-Doktrin ohne Enum-Aenderung | run_methodology_registry.hpp:54-59 |
| T-F G-6 Dual-Review Codex+Fable | AUFGABE | Z14631 T-F | LEDGER:4114 verifiziert, aber 5 heutige Wellenplan-Landungen OHNE Dual-Review-Vermerk (Audit-Workflow wf_355205a7 pausiert) | - |
| T-F G-7 cpe-Widerspruch (LEDGER:7330 "OFFEN (Bau-Auftrag, kein Entscheid)") | REGRESSION | Z14631 T-F, Z14679-Z14695 | BEHOBEN (Zeile korrigiert, Commit "G-7 korrigiert an Zeile 7330") | - |
| Owner-Vorlage STOPP-Gates E-A..E-F (537 Z., 20260807-OWNER-VORLAGE) | FEATURE/AUFGABE | Z14700 teammate Vorlage-STOPP-Gates | GEBAUT (Vorlage fertig), alle 6 Entscheide selbst weiterhin OFFEN (keiner beantwortet sich selbst) | Vorlage-STOPP-Gates |
| Plangrundlage STOPP-Gates ueberholt (Format 3/8 Glieder statt real Format 4/9, R-3) | REGRESSION | Z14700 | OFFEN-REGRESSION: POD-Entwurf Sec.3.1 waere nicht kompilierbar (8 != 9 Kategorien) | - |
| E-C ENTLASTET (dll_is_current mismatcht-Annahme widerlegt, Sidecars entscheiden ueber keinen Skip mehr) | OWNER-ENTSCHEID | Z14700 | Empfehlung (b)->(a) geaendert, Auflage: S6 muss kCebContractCodegenMinor unberuehrt ausweisen | - |
| E-E groesser als angenommen (3 Unterfragen: Verzeichnis-Schnitt/Sortier-Ordnung/Hash je Datei vs Konkatenation) | OWNER-ENTSCHEID | Z14700 | OFFEN, teuerster Aufschub (Fenster 0 = 0 .fingerprint-Dateien, nach 1. Batch ~34,4h Voll-Neubau) | - |
| E-F kollidiert mit Section43.b (Planer traegt keine Achsen-Arrays) | OWNER-ENTSCHEID | Z14700 | OFFEN mit Auflage (Owner muss Section43.b fuer gerenderte Zeile bestaetigen) | planner_version.hpp:4-7,61-70 |
| E-A (b) 24 Hex traegt, Begruendung "2^17" zu schmal | OWNER-ENTSCHEID | Z14700 | Empfehlung bleibt (b), Begruendung praezisiert (96bit deckt 2^21) | build_orchestrator.hpp:231 |
| VS-A..VS-F Umbenennungs-Vorschlag (3. Kollision E-A..E-F mit DD-A..DD-E/E0-E4) | OWNER-ENTSCHEID | Z14700 §(B) | VORSCHLAG, nicht entschieden | - |
| allocators-coverage-gate: 7 Bissproben (alle rot, alle zurueckgebaut) | FEATURE | Z14748 teammate Bau-Allocators-Gate | CI-BEWIESEN (Nenner 23, Thesis-Anker 10/10, Adapter 10/10) | test_allocator_profile_bestand.cpp |
| KF-1-Reader ist fehlertolerant, nicht validierend (Randbefund Biss B) | REGRESSION | Z14748 | dokumentiert im Code, Falschaussage in erster Kommentarfassung zurueckgenommen (nie gelandet) | - |
| README allocators nachgezogen (23 Doku-Akten vs 10 implementiert vs 13 reine Doku, 3 tote Querverweise) | REGRESSION | Z14748 §3 | BEHOBEN | README.md |
| README-Pruefung im Gate mitgebaut (ueber urspruengl. Scope hinaus) | FEATURE | Z14748 §4 | GEBAUT | - |
| Eigener Fehler: git checkout -- README.md waehrend uncommitted Aenderung -> 2 ungueltige Bisse | REGRESSION | Z14748 "EIGENER FEHLER" | BEHOBEN (README neu geschrieben, committed, Bisse wiederholt) | - |
| cppcheck lokal nicht verfuegbar (Allocators-Strang) | REGRESSION | Z14748 "NICHT GESCHAFFT" | OFFEN (faellt in CI) | - |
| Drei Lizenz-Abweichungen Thesis<->Akte (michael_lockfree LGPL/BSD-3, tcmalloc Apache/BSD-3, lrmalloc MIT/BSD-3) | REGRESSION | Z14748 "OFFEN FUER DEN OWNER" | OFFEN (Gate faengt/meldet es nicht, Thesis in anderem Repo) | - |
| ext/A05-jemalloc getrackte Dublette zu ext/allocator/A05-jemalloc | REGRESSION | Z14748 "Nebenbefund" | OFFEN (Altlast, ausserhalb Scope) | - |
| allocators-coverage-gate gelandet (development nach Push) | FEATURE | Z14723-Z14729 | GELANDET | - |

| Task #42 DREI LIZENZ-ABWEICHUNGEN Thesis <-> Akte | AUFGABE | Z14761-Z14762 | ANGELEGT | Task #42 |
| Eigentum: Thesis privat (Benjamin-Elias Probst), CacheEngine BEP Venture UG (Comdare) | OWNER-ENTSCHEID | Z14767, Memory reference_eigentum_thesis_privat | GESETZT (Lizenzfrage fuer Lizenz-Abweichungen strikt getrennt von Comdare-Lizenz-Entscheidung) | - |
| Flag-Grammatik v2 Repraesentation (std::array<FlagToken,96>+uint8 count, Pre-Order+Tiefe) | FEATURE | Z14831 teammate Bau-Grammatik-v2 §1 | GEBAUT | algo_semver.hpp |
| kMaxFlagDepth = 4 (Tiefen-Deckel, CT-bewiesen) | FEATURE | Z14831 §1 | GEBAUT | algo_semver.hpp:278-280,477 |
| Negativ-Batterie Q3 neu gedacht statt umgeschrieben (v1.0.0e->positiv, v1.0.0ec ersatzlos etc.) | FEATURE | Z14831 §2 | GEBAUT | - |
| Der laute Bruch: ECHTE LUECKE gefunden (organ_stamp_line<Comp> ohne Wache, stiller Sentinel bei Alt-Literal moeglich) | REGRESSION | Z14831 §3, Z14838-Z14848 verifiziert | BEHOBEN (in Commit 44397f58 geschlossen, 4->7 static_asserts, CT-bewiesen) | anatomy_version_stamp.hpp:125 |
| 422/422 Tests gruen, vor_push_alle_wachen.sh gruen (Flag-Grammatik v2) | FEATURE | Z14831 §4 | CI-BEWIESEN | - |
| Vier SIMD-Faelle CT-bewiesen (Basis+Sub-Liste, Companion ohne Basis, Skalar ohne Breite, ohne Registerbreite) | FEATURE | Z14831 §5 | GEBAUT | algo_semver.hpp:955-1000 |
| MMX-Basis-Frage (Fall 4: Token oder eigene Basis?) | OWNER-ENTSCHEID | Z14831 §5, §7 | OFFEN, im Header markiert, nicht praejudiziert | - |
| Knoten-Deckel zu klein war (kMaxFlagNodes=32 haette legit. Eingabe abgelehnt) | REGRESSION | Z14831 §5 | BEHOBEN (jetzt 96, Vollausbau 58 Knoten CT-bewiesen) | - |
| sse4.1-Token=sse41, drei Namensraeume (Compiler-Schalter/cpuinfo/eigen) dokumentiert | FEATURE | Z14831 §6 | GEBAUT | algo_semver.hpp:671-690,995-998 |
| avx10.1/avx10.2 Punkt-Fund (Token braucht mind. 1 Buchstabe, verhindert Fehllesung als 2 Geschwister) | REGRESSION | Z14831 §6 | BEHOBEN (Regel CT-bewiesen, algo_semver.hpp:993-994) | - |
| Praefix-Stripping-Kurzform x128{2.3.41.42} | OWNER-ENTSCHEID | Z14831 §6 | OFFEN (nicht schreibbar mit aktueller Regel, Abwaegung im Header nicht entschieden) | - |
| Massen-Migration 143 Bestands-Quellen (v-Praefix weg, Punkt vor Flag), rein mechanisch | FEATURE | Z14831 "ZUR MASSEN-MIGRATION" | GEBAUT, 181 Dateien/2537 Einfuegungen | - |
| Katalog-Wache S2 nicht gebaut (wie beauftragt, Andockstelle vorbereitet) | AUFGABE | Z14831 "WAS ICH NICHT GESCHAFFT HABE" #1 | OFFEN (bewusst keine Attrappe gebaut) | - |
| S3b inhaltliche Anreicherung nicht angefasst | AUFGABE | Z14831 #2 | OFFEN | - |
| cppcheck/lint:static lokal nicht fahrbar (Flag-Grammatik-Strang) | REGRESSION | Z14831 #3 | OFFEN (Werkzeug fehlt, letzter roter Pipeline-Lauf aus dieser Klasse) | - |
| Nur gcc-release gefahren, keine clang-/MSVC-Bahn (Flag-Grammatik) | REGRESSION | Z14831 #4 | OFFEN (Dual-Compiler-Beweis fehlt lokal) | - |
| 96er-Knoten-Deckel an heutigem Katalog bemessen (58), nicht an AVX10/APX-Vollausbau | UNKLAR | Z14831 #5 | Risiko dokumentiert, bricht LAUT falls gesprengt | - |
| Flag-Grammatik v2 gelandet (ce development=5060489e), Task #36 completed | FEATURE | Z14849-Z14855 | GELANDET (178 Dateien, 422/422 gruen, gitleaks sauber) | Task #36 |
| ce Pipeline 15221 (Grammatik) laeuft, 15218 (allocators) gruen | AUFGABE | Z14861-Z14876 | CI-status: 15218 CI-BEWIESEN gruen, 15221 laufend | - |
| Lehre: eigene Wachen-Pruefung haette die Stempel-Luecke nicht gefunden (Agent pruefte Stempel-Stelle statt nur Wache) | UNKLAR | Z14876 | dokumentiert als Lehre | - |

| Doku-Stale-Sweep Fehl-Commit (eigener git add -A ueberschrieb Agenten-Zwischenstand) | REGRESSION | Z14891-Z14909, Memory K8 | BEHOBEN (kein Schaden, Agent hatte selbst bemerkt+gemeldet) | - |
| Pipeline 15221 rot: "No space left on device" (Runner-Datentraeger voll) | REGRESSION | Z14924-Z14944 | BEHOBEN (eigener gitleaks-Klon-Muell 14GB identifiziert+geraeumt, von 50MB auf 8.2GB dann 12GB frei) | - |
| lint:static (cppcheck) gruen trotz vorheriger Sorge (M-3a-Bau) | AUFGABE | Z14928 | CI-BEWIESEN gruen | - |
| M-3a branch_misses real erheben (PMC-Ehrlichkeit) Bau | FEATURE | Z14915-Z14916, Commit aa06f900 | GEBAUT, committet, bewusst NICHT gepusht (Zwischenstand) | Bau-PMC-Ehrlichkeit |
| Doku-Stale-Sweep Abschluss (17 Dokumente, 175 stale Anker geheilt) | FEATURE | Z14963 teammate Doku-Stale-Sweep | GEBAUT (736 insertions/36 deletions, Bestandstext unangetastet) | Doku-Stale-Sweep |
| Fund 1: zwei Achsen-Nachschlagewerke ergeben zusammen nicht den Ist-Stand (ABI 4->5->6 vs Ist 8; 19->18->17 vs Ist 18; T17 persistence_target fehlt in beiden) | REGRESSION | Z14963 §3(1) | BEHOBEN (Stale-Block gesetzt) | 20260717/20260719-achsen-nachschlagewerk*.md |
| Fund 2: zwei Dokumente mit Korrekturen, die selbst in die Irre fuehren (16:271 "ABI-Major 4" Ist=8; 11_axes:347 fordert nie gesetzten Stale-Banner, falsche 19-Achsen-Zahl) | REGRESSION | Z14963 §3(2) | BEHOBEN (Stale-Block gesetzt) | 16_E1_E4_KONSOLIDIERUNG_DOSSIER.md, 11_axes_vs_strategies_disambiguation.md |
| Fund 3: Dossier 23 behauptet Systemachsen existierten "nirgends" — real drei hart gepinnt (target_isa, operating_system, external_utils) | REGRESSION | Z14963 §3(3) | BEHOBEN (Stale-Block gesetzt), Registry zitiert Dossier wörtlich als eigenen Reparatur-Auftrag obwohl abgearbeitet | 23_SYSTEMACHSEN_KONZEPT_WIEDERHERSTELLUNG_DOSSIER.md, axis_library_registry.hpp:121 |
| Selbstpruefung 13 uebernommene Zeilenangaben (Doku-Sweep) | REGRESSION | Z14963 §5 | 12/13 exakt, 1 Zeilendrift (4 Zeilen, build_all_axis_levels() :178 statt :182) BEHOBEN, 0 falsche Sachaussagen | registry_to_axis_levels.hpp:178 |
| 14_achsen_komposition_organ_metapher.md (158KB) traegt keinen Stale-Banner | AUFGABE | Z14963 §6 | OFFEN (groesster ungeprueter Posten), aber entlastet (ABI nur 1x wertfrei erwaehnt) | - |
| Dissens 11_konzept_achsen_extension_visitor_pattern.md:1906 (R9-Nachtrag "historisiert" oder aktiv kranke Stelle?) | REGRESSION | Z14963 §7, Z14973-Z14980 | BEHOBEN: Lead prueft selbst, bestaetigt Agent — 3 veraltete Werte (ABI-MAJOR==4 Ist=8, sizeof==1416, 19 statische Hauptachsen), Vermerk gesetzt | - |
| Doku-Sweep gelandet (super 123a1f97) | FEATURE | Z14993-Z14995 | GELANDET | - |
| Alles abbruchsicher sichern, letzten Workflow auslaufen lassen | OWNER-ENTSCHEID | Z14999 (User-Zitat) | GESETZT/AUSGEFUEHRT | - |
| Abschluss-Dokument 20260807-ABSCHLUSS-neun-straenge-und-die-offenen-Entscheide | FEATURE | Z15013-Z15022, Commit e4e9dcd3 | GEBAUT (Erst-Anker) | - |
| Task #39 VORLAGE FERTIG, wartet auf Owner, sechs Stempel-Entscheide (E-E dringendste) | AUFGABE | Z15032-Z15033 | OFFEN (Owner-Entscheid ausstehend) | Task #39 |
| Platz-Inventar 3 Maschinen (lokal=prod1 bestaetigt, nur 2 physische Maschinen) | AUFGABE | Z15036 teammate Platz-Inventar | ABGESCHLOSSEN (reine Erhebung, nichts geloescht) | Platz-Inventar |
| 26 Worktrees geprueft: 21 gemergt/remote-rueckholbar (38,47GB), 6 NICHT gemergt (~3,7GB, unwiederbringlich bei Loeschung) | UNKLAR | Z15036 | ERHOBEN, Empfehlung: 21 loeschbar, 6 NICHT anfassen | - |
| Build-Verzeichnisse ausserhalb Worktrees (~18,9GB reproduzierbar, zb-build-e24 verwaist ohne Quelle) | UNKLAR | Z15036 | ERHOBEN, Empfehlung Stufe 1 loeschbar | - |
| Nicht-Anfassen-Liste lokal (Messdaten, Backups, Doku, Credentials, .claude/.codex) | REFERENCE | Z15036 | Regel bestaetigt: additiv/nie loeschen | - |
| Owner-Freigabe-Grauzone (scrub-work 2,6G, comdare-web-work 1,7G, Transkripte-privat 81M, raceaudit/diag-scope4, git gc, aktives ce-build) | UNKLAR | Z15036 | OFFEN, Owner-Entscheid noetig | - |
| prod2 gesund (44% belegt, 135G frei) — NICHT Ursache der Platznot | REFERENCE | Z15036 | BESTAETIGT, ~100GB unter root-only-Pfaden nicht lesbar (vermutlich Talos-VM) | - |

| Pause beendet: max. Gruendlichkeit+Parallelitaet, Worktrees bleiben, golden-320-Messdaten veraltet und loeschbar (System wird neu gemessen), Hauptstrang parallel weiter | OWNER-ENTSCHEID | Z15057 (User-Zitat) | GESETZT | - |
| Vier Straenge neu gestartet: S2-Katalogwache, Restposten (fail-closed numa_node/page, tote COMDARE_VARIANT_GATE), P/E-Core-Messung entwerfen, M-3a-Bericht | AUFGABE | Z15065-Z15085 | GESTARTET | Bau-S2, Bau-Restposten, Bau-PE-Core, Bau-PMC-Ehrlichkeit |
| M-3a: keine sizeof-Wache auf PmcCounters (Feld additiv, kein Stempel-POD) | REGRESSION | Z15094 teammate Bau-PMC-Ehrlichkeit §1 | Praezisiert (Vermerk "byte-unberuehrt" war schon vor Agent ueberholt seit 06.08.) | i_measurement_source.hpp:9,131 |
| M-3a Bissprobe branch_misses NICHT-NULL (4202818 real, 50,1% Rate, gcc+clang) | FEATURE | Z15094 §2 | CI-BEWIESEN | - |
| M-3a Lastform-Fehlversuche (reines Pointer-Chasing=Rauschen 704 Misses; erster Zweig-Entwurf else nie genommen) | REGRESSION | Z15094 §2 | BEHOBEN (gewaehlte Last: xorshift64, 8.388.608 Zweige ~50/50) | - |
| Compiler-Barrier notwendig (ohne Barrier: 54 Misses statt 8.396.125, -O3 faltet zu cmov) | REGRESSION | Z15094 §2 | BEHOBEN (asm volatile Barrier gesetzt) | - |
| M-3a Gate-Biss-Beweis (Regression simuliert: Zaehler offen aber Wert nicht zugewiesen -> SMOKE_FAIL) | FEATURE | Z15094 §2 | CI-BEWIESEN (Gate beisst wirklich) | - |
| M-3a Bissprobe Ehrlichkeit n/a-statt-0 (echte AMD-Zen5-Fehloeffnung L3, branch_misses=443 echt vs l3=n/a) | FEATURE | Z15094 §3 | CI-BEWIESEN (W13/W14 Grenzfaelle belegt) | - |
| ctest 100%/418 gruen (M-3a gcc-release) | FEATURE | Z15094 §4 | CI-BEWIESEN | - |
| Unterwegs rote Laeufe NICHT eigener Code: 4 Roundtrip-Tests rot (Generator-Tools nicht am Default-Target); 3 Tests rot (io_uring/NUMA-Probe/Disk-Memento) unter Parallellast | REGRESSION | Z15094 §4 | BEHOBEN (Generator-Tools nachgebaut; Ursache Datentraeger 100% voll 2,3MB frei, nach Freiraeumen gruen) | - |
| Luecke 2 GEBAUT: measurement_from_workload_result kopiert nicht mehr blind (l2/l3/branch/coherence/energy je eigenes source_available) | FEATURE | Z15094 §5 | GEBAUT (Wache gegen Drift, aendert keinen Bestandswert) | measurement_snapshot.hpp |
| ComdareMeasurementSnapshotV1 POD-Erweiterung um Flag-Felder (feinkoernige Wahrheit) ZURUECKGEHALTEN | AUFGABE | Z15094 §5 | OFFEN (Owner-Entscheid noetig, CSV-Schema-Aenderung), entlastend: f15_compare an keinem CI-Job | - |
| PmcSystemAxis::do_collect stempelte mark_ok() auch bei 0-Wert auf AMD L3 | REGRESSION | Z15094 "ZWEI WEITERE FUNDORTE" | BEHOBEN (jetzt SourceUnavailable je Kategorie) | system_axis.hpp:413 |
| PmcSourceAdapter::read_delta stempelte valid grobkoernig statt je Kanal | REGRESSION | Z15094 "ZWEI WEITERE FUNDORTE" | BEHOBEN (jetzt je Kanal eigenes Flag) | i_measurement_source.hpp |
| Konsumenten-Suche branch_misses praezisiert (14 Treffer branch_misses/3 pmc_branch_misses, alle in Code/external gespiegeltem ce-Baum, kein super/Thesis-Konsument) | REGRESSION | Z15094 "DEINE FRAGE" | Klaerung (Lead-Zahl "0 Treffer" war unpraezise, Ergebnis inhaltlich gleich) | - |
| M-3a offene Punkte: Bau nach Merge nicht verifiziert (nicht Auftrag), cppcheck lokal nicht laufbar, l1/dtlb weiterhin kein Flag, Windows branch_misses nicht erhoben, m3v2_pmc_smoke branch nur 443 (kein Zaehlerqualitaets-Beleg) | AUFGABE | Z15094 "WAS ICH NICHT GESCHAFFT HABE" | TEILWEISE OFFEN (bewusst nicht erfunden) | - |
| Betriebsrisiko: Datentraeger 100% voll (50MB von 251G frei) vor mehrtaegiger Messung | REGRESSION | Z15094 "BETRIEBSRISIKO" | OFFEN (nur eigene Build-Verzeichnisse geraeumt, echter Blocker benannt) | - |
| Lead-Pruefung M-3a-Bericht: eigener grep traf Kommentar statt Code (Punkt 1), Agent hatte recht | REGRESSION | Z15096-Z15109 | BEHOBEN (Lead-Pruefung war zu naiv, korrigiert) | - |
| Bau nach Merge (Lead selbst): 4 rote Roundtrip-Tests, Generator-Tools nicht am Default-Target | REGRESSION | Z15121-Z15133 | BEHOBEN (comdare_axis_registry_gen u.a. explizit gebaut, bekannte Falle) | - |
| M-3a gelandet (ce development=6a8ab995), 419/419 gruen ueber gemergten Stand (Grammatik v2 + PMC-Ehrlichkeit) | FEATURE | Z15136-Z15154 | GELANDET, CI-BEWIESEN | Task #8 |
| ce Pipeline 15227 laeuft, 15224 (Branch-Lauf) gruen | AUFGABE | Z15162-Z15169 | CI-status: 15224 CI-BEWIESEN gruen | - |
| P1 P/E-Core Stufe 1 (Design pe-core-getrennte-messung.md) | FEATURE | Z15171 teammate Bau-PE-Core | GEBAUT (Entwurf), Bau bewusst angehalten vor Stufe 2 | wt-ce-pecore |
| prod1 ist NICHT hybrid (keine cpu_core/cpu_atom PMU-Domaenen) | REGRESSION/UNKLAR | Z15171 §1 | BESTAETIGT (deckt sich mit Ledger:4283) | - |
| prod1 ist kern-asymmetrisch (2 L3-Domaenen, 96MB vs 32MB, Faktor 3) | FEATURE | Z15171 §1 | ENTDECKT, Bissbeweis CI-BEWIESEN (Probe pinnt korrekt, behauptet nirgends P/E) | - |
| P/E-Ausprägung wartet auf prod2 (nicht erreichbar, Infra #207) | AUFGABE | Z15171 §1 | OFFEN (Gate-Grund im Ledger:340 gefuehrt) | - |
| Resolver fuer RT-Unter-Achsen numa_node/page/core_class fehlt komplett (OD-10-RT-K/OD-11-RT-K existieren nicht, probe_numa_cpu_pin_process_topology() null Rufer) | REGRESSION | Z15171 §2a | OFFEN-REGRESSION (Struktur-Entscheidung noetig, nicht Agenten-Entscheid) | hardware_probe_factory.hpp:481 |
| hybrid_core_aware NICHT gesetzt (keinen Leser, waere Schein-P/E/Feigenblatt) | OWNER-ENTSCHEID | Z15171 §2b | Empfehlung: NICHT setzen (Fehlerklasse "sieht aus als beruecksichtigt" vermeiden) | i_measurement_source.hpp:55 |
| LinuxPerfPmcSource bräuchte dynamische PMU-Typnummer (/sys/devices/cpu_core/type) fuer Hybrid, auf prod1 nicht verifizierbar | AUFGABE | Z15171 §2c | OFFEN ("ungetestet einbauen waere gruen und trotzdem falsch") | - |

| P/E-Core core_class Byte-Ereignis-Frage (RT-Welt vs CT-Welt Verwechslungsrisiko R-1) | REGRESSION | Z15171 §3 | NEIN kein Byte-Ereignis (dreifach belegt), Risiko dokumentiert mit static_assert-Gegenmassnahme im Entwurf | system_axis_registry.xml:10, system_cell_values.hpp:166-172 |
| Ω-1/Ω-2/Ω-3 P/E-Core Owner-Entscheide (Resolver-Zuschnitt, Ablage-Form CSV-Spalten, prod1-L3-Scharfschaltung) | OWNER-ENTSCHEID | Z15171 §4 | ALLE DREI OFFEN, Empfehlungen genannt | - |
| G-8 (echte PMU-Trennung) unerreichbar ohne prod2 | AUFGABE | Z15171 §5 | OFFEN (blockiert) | - |
| G-1 (Erkennung ehrlich) P/E-Core | FEATURE | Z15171 §5 | CI-BEWIESEN bestanden | - |
| A15-Kuerzel-Kollision real (Fahrplan-A15=Fehlerklassen-Framework #29 vs STAND-A15=§55-Gesamt-Reconcile) | REGRESSION | Z15239 teammate Kartierung-Phase34 | erkannt, getrennt behandelt | - |
| A4/12-Perm Golden-Profil (nur 4 Perms statt 12, D-2 Bau-Menge erneut owner-blockiert, 4 Kandidaten 131072/524288/1572864/2097152) | OWNER-ENTSCHEID | Z15239 | OFFEN ("Nachziehen ist ein ENTSCHEID, kein Bau"), 0 Testdateien O0+avx512 gefunden | all_axes_golden.profile.xml:189-198 |
| A9-xlsx-Writer S1 (Vendor libxlsxwriter+zlib) disjunkt baubar | FEATURE/AUFGABE | Z15239 | OFFEN, aber ungegatet (0 Codetreffer, S2/S3 an anderen Owner-Punkten/R-3) | ce docs/architecture/20260803-a9_xlsx_writer_f3_soll_design.md |
| A15/§55-Reconcile Triage 43 Positionen (3 belegte Baugebiete, 11 Owner-Fragen mit Duplikaten, 29 reine Ledger-Konsolidierung) | AUFGABE | Z15239 | TEILWEISE strukturiert, gross aber disjunkt zu Code | 20260807-AUDIT-ledger-vollstaendigkeit-43-positionen.json |
| A7/E-18 anhang:forward bereits vollstaendig code-seitig gebaut, nur Aktivierung (COMDARE_ANHANG_FORWARD inert-by-default) fehlt | FEATURE | Z15239 Posten #2 | GEBAUT, Aktivierung OWNER-ENTSCHEID OFFEN | super/.gitlab-ci.yml:1115 |
| A15 FK-3/FK-4 (Fehlerklassen AxisErrorTraits) fehlen, FK-5 bereits gelandet | AUFGABE | Z15239 Posten #9 | OFFEN gross, FK-5 GELANDET (f4ce89fe) | organ_axis_error_classes.hpp |
| A8-Schnitt Ebene(a) Wallclock (3 Ebenen CEB-Messung), Micro/PMC auf E1+E2 komplett ungebaut | AUFGABE | Z15239 Posten #10 | TEILWEISE (E1/E2 "gebaut mit Vorbehalt", E3 teilweise), Owner-Entscheid OF-A8-2 offen | abi_adapter.hpp:1781-2035 |
| A10 HW P4-P6 (CSV-Provenienz-Ruckschrieb, Passungs-Stempel, Roundtrip) — kein CSV/Result-Writer existiert | AUFGABE | Z15239 Posten #11 | OFFEN, STILL von T2 auf T4 heruntergestuft ohne expliziten Marker | - |
| E-19 Stufe 1 (Runner-Fleet-Matrix) | AUFGABE | Z15239 Posten #12 | ERLEDIGT (02.08. fertig), nichts zu bauen | - |
| §61-Dual-Weg: Bare-Metal-CMake-Kanal emittiert 0 PMC-Compile-Flag-Zeilen, nur CI-YAML tut das | REGRESSION | Z15239 Posten #8 | OFFEN-REGRESSION (strukturell asymmetrisch, nicht nur unbelegt) | 20260806-DOSSIER-regressionen-checkheft.md:1816 |
| A12 NAS-Creds Owner-Frage seit 06.08. unbeantwortet | OWNER-ENTSCHEID | Z15239 Posten #14 | OFFEN, Codepfad bereits DEPRECATED zugunsten HTTPS-PUT | LEDGER:5166 |
| Thesis C1-Rest/C2/D-07 + T5 Lizenz-Matrix (andere Tabelle als Task #42) | AUFGABE | Z15239 Posten #13 | TEILWEISE offen, T5 Lizenzfrage owner-gated | - |
| Scheinbar offen/erledigt-Diskrepanzen (A8 Teil(b) gemergt, A7/E-18 gebaut, A15 FK-5 nachgeholt, E-19 St.1 erledigt, A4 umgekehrt wieder Owner-Frage) | REGRESSION | Z15239 "SCHEINBAR OFFEN" | Klaerungen dokumentiert | - |
| zb-build-e24 verwaist bestaetigt (Quellverzeichnis existiert nicht) | REGRESSION | Z15241-Z15256 | BEHOBEN (3.3G geraeumt) | - |
| golden-320-Messdaten geloescht (Owner-GO, nicht getrackt, 2242 Dateien) | AUFGABE | Z15254-Z15256 | AUSGEFUEHRT (Owner-Entscheid Z15057) | - |
| Drei Bau-Straenge gestartet: A9-S1 xlsx-Vendor, A5-ETA-Kalibrierung | AUFGABE | Z15259-Z15263 | GESTARTET | Bau-A9-S1-Vendor, Bau-A5-ETA |
| Vor-Push-Wache Zwei-Punkt-statt-Drei-Punkt-Fehler (misst Rueckstand statt eigene Arbeit) | REGRESSION | Z15206 teammate Bau-Restposten, Z15209-Z15226 | BEHOBEN (Commit 962457b0, betrifft ALLE Parallel-Agenten des Tages) | scripts/vor_push_alle_wachen.sh:63 |
| Restposten 1 (fail-closed-Wache numa_node/page/core_class) — KEIN Bau, Praemisse widerlegt | REGRESSION | Z15206 | Absicht/kein Bau (Wertebereich waere erfunden, Resolver-Schritt zustaendig, 3 statt 2 Felder betroffen) | Bau-Restposten |
| Restposten 2 (COMDARE_VARIANT_GATE) — Variable NICHT tot, wirkt real (.variant-Sidecar) | REGRESSION | Z15206 | NICHT entfernt (waere Verhaltensaenderung), nur obsoleter Gate-Aspekt bestaetigt, [NACHGEFUEHRT]-Kommentar ergaenzt | build_orchestrator.hpp:330-337,440-446,702-703 |
| Restposten-Wachen-Fix gelandet (ce 5aad9c43, super cc761ed8) | REGRESSION | Z15275-Z15294 | BEHOBEN/GELANDET | - |
| Lead ASCII-Pruefung zu grob (ganze Dateien statt neue Zeilen gezaehlt) | REGRESSION | Z15285-Z15289 | BEHOBEN (0 Nicht-ASCII bei korrekt gemessenen neuen Zeilen) | - |
| S2 Katalog-Wache gebaut+verifiziert (ce 18e5798f, flag_grammar_catalog.hpp: 62 zugelassen, 14 abgelehnt) | FEATURE | Z15305 teammate Bau-S2-Katalogwache | GEBAUT (keine Attrappe) | wt-ce-s2, Branch bau/s2-katalog-wache |
| Katalog-Identitaet = Paar (token,eltern) noetig (vnni/ifma doppelt, 'f'=FPGA vs AVX512-Subset je nach Elternteil) | FEATURE | Z15305 §1 | GEBAUT (Design-Entscheidung erzwungen) | flag_grammar_catalog.hpp |
| Drei Wachen gegen die Katalog-Tabelle selbst (grammatisch erreichbar, Drift-Bruecke zu simd_feature_flag.hpp, Eindeutigkeit) | FEATURE | Z15305 §1 | GEBAUT | algo_semver.hpp |

| S2-Katalogwache 12 Bissproben gegen echten Header (alle brechen korrekt, static assertion failed) | FEATURE | Z15305 §4 | CI-BEWIESEN | - |
| Companion an Basis-Stelle bricht als ISA-Aussage (gfni hat kein separates avx512-Bit) | FEATURE | Z15305 §4 | GEBAUT/dokumentiert | - |
| S2-Wache berichtete falsch (Biss 13: Meldungstext "ohne CPU-Basis" obwohl Literal c trug) | REGRESSION | Z15305 §5a | BEHOBEN (acht Meldungen nennen jetzt beide Gruende) | - |
| Drei Meldungstexte vor dieser Scheibe bereits veraltet ("experimentelles e", "GENAU c bzw ce") | REGRESSION | Z15305 §5b | BEHOBEN (nachgezogen, Historie als Hinweis belassen) | system_axis_code_versions.hpp, measurement_tooling_registry.hpp, measurement_framework_registry.hpp |
| Drei Abweichungen von Owner-Vorgabe im S2-Katalog (aes/pclmulqdq als x128 statt Companion, xop/fma4 als Reserve statt regulaer, 3dnowprefetch als Skalar/eigene Setzung) | OWNER-ENTSCHEID | Z15305 §6 | Begruendet abgewichen, mit Beleg; xop-Basis bei Bedarf Owner-Entscheid | - |
| S2: vier Wachen bewusst nicht gebaut (Doppelungen c.c, nackte Breiten-Basis x512 ohne Sub-Liste, Abhaengigkeitsketten x512{vl} ohne f, Maschinen-Verfuegbarkeit) | AUFGABE | Z15305 §7 | OFFEN, im Header benannt | - |
| S2: sieben x256-Token mit leerer cpuinfo-Spalte nicht gegengeprueft; Recherche las Intel SDM/AMD APM nie direkt | UNKLAR | Z15305 §7 | Risiko dokumentiert, nicht zwingend falsch | - |
| S2-Katalogwache gelandet (ce 5788dc12), 104 static_asserts im Katalog | FEATURE | Z15329 | GELANDET, CI-BEWIESEN | - |
| Agenten-Methodenfehler: Basis-SHA aus Auftragstext uebernommen statt git merge-base berechnet (Ergebnis zufaellig richtig) | REGRESSION | Z15334 teammate, Z15336-Z15347 | erkannt+dokumentiert, Memory K9 "NIE eine Basis-SHA im Auftrag beziffern" angelegt | - |
| S2-Katalogwache final nachgemessen auf Merge 5788dc12, 419/419, Wache gruen (super c26f8a77) | FEATURE | Z15350 | GELANDET/CI-BEWIESEN final | - |
| A15/§55 Ledger-Konsolidierung Strang gestartet | AUFGABE | Z15355-Z15357 | GESTARTET | Bau-A15-Ledger |
| A9-S1 xlsx-Vendor gebaut (420/420, libxlsxwriter+zlib) | FEATURE | Z15373 teammate Bau-A9-S1-Vendor | GEBAUT, nicht gepusht/gemergt | wt-ce-xlsx, Branch bau/a9-s1-xlsx-vendor |
| BLOCKER: Diff-Hygiene-Wache (ci_diff_ascii_width_guard.sh) greift Vendor-Fremdcode (20 Treffer Cafe/russisch/>120 Spalten in xlsxwriter/zlib) | REGRESSION | Z15373 "EIN BLOCKER" | OFFEN (Lead-Entscheid noetig: is_scoped() prueft nur Dateiendung, nicht "selbst verfasst" wie vertraglich behauptet) | scripts/ci_diff_ascii_width_guard.sh:179-193 |
| A9-S1 Format-Haelfte geloest (.clang-format DisableFormat:true in Vendor-Verzeichnissen) | REGRESSION | Z15373 | BEHOBEN (52 geprueft, 0 abweichend, kein Vendor-Byte umformatiert) | - |
| A9-S1 Vendor-Pruning (libxlsxwriter 37MB->1,9MB/78 Dateien, zlib 4,3MB->1,2MB/31 Dateien) | FEATURE | Z15373 | GEBAUT (767KB Spiegel-Bundle) | COMDARE-VENDOR-PROVENANCE.md |
| A9-S1 Lizenzen live erhoben (libxlsxwriter v1.2.4 BSD-2-Clause, zlib v1.3.2 zlib-Lizenz, minizip/Openwall-MD5/emyg_dtoa/queue.h Sublizenzen) | FEATURE | Z15373 | GEBAUT/dokumentiert | - |

| A9-S1 Rauchtest (schreibt xlsx, liest per eigenem ZIP-Leser zurueck) | FEATURE | Z15373 "Rauchtest" | CI-BEWIESEN (3/3 gruen, Bissprobe verstellter Zellwert -> rot) | - |
| tmpfileplus.h (MPL-2.0) bleibt unbedingt inkludiert aber ungelinkt (Abweichung vom Design-Doc) | UNKLAR | Z15373 "Abweichung..." | GEKLAERT (nm: 0 Symbole im Archiv, kein MPL-Code gelinkt) | - |
| A9-S2 (Ownership) bereits erledigt: lager_pfad_grammatik.hpp existiert schon (L5-Entscheid: gehoert A1-Lager-Welle) | REGRESSION | Z15373 "Zwei Funde ausserhalb" #1 | Klaerung (Lead-Ausgangslage "0 Treffer" war falsch), Writer selbst existiert weiterhin nicht | - |
| liburing fehlt in beiden Lizenzdateien (NOTICE, LICENSE_AUDIT_EXT.md) seit 23.07. | REGRESSION | Z15373 "Zwei Funde ausserhalb" #2 | OFFEN (gehoert vermutlich zu Task #42) | - |
| Eigener Fehler A9-S1: mkdir-Kette im falschen Verzeichnis (b/ in fremdem Worktree wt-ce-rest angelegt) | REGRESSION | Z15373 "Eigener Fehler" | BEHOBEN (entfernt, fremdes build/ unberuehrt) | - |
| Diff-Hygiene-Wache Vendor-Blocker behoben (Marker-basierte Ausnahme, beidseitig gegengeprueft) | REGRESSION | Z15375-Z15414 | BEHOBEN (Commit ac29119f, eigener Code weiter gefangen, Vendor uebersprungen) | ci_diff_ascii_width_guard.sh |
| A9-S1 gelandet (ce development=351205f5), 420/420, Repo-Pack 34,6MiB | FEATURE | Z15424 | GELANDET, CI-BEWIESEN | - |
| A15/§55-Reconcile fertig: 43 Meldungen=36 unikate Posten (5 VOLLZOGEN, 5 SUPERSEDED, 7 DUPLIKAT, 5 OWNER-FRAGE, 19 OFFEN, 2 NICHT ENTSCHEIDBAR) | AUFGABE | Z15500 teammate Bau-A15-Reconcile | GEBAUT (Dispositions-Dokument), 26 Posten tragen noch Arbeit | 20260807-RECONCILE-43-positionen-disposition.md |
| Duplikat-Paare SIEBEN statt fuenf (Vortriage hatte 3 Paare uebersehen) | REGRESSION | Z15500 | BEHOBEN/korrigiert | - |
| Fuenf haerteste Umschlaege: #24 D-4 kCebFingerprint-Injektivitaet VOLLZOGEN, #37 T-9 VOLLZOGEN, #2 branch_misses VOLLZOGEN, #34 F-01 Talos VOLLZOGEN, #3 Anhaenge B/E Stubs widerlegt | REGRESSION | Z15500 | Alle als "bereits erledigt entgegen Audit-Status" korrigiert | - |
| Ledger irrt in beide Richtungen (GN-9 als offen gefuehrt obwohl superseded; xlsx-Writer Entlastung obwohl nicht existiert) | REGRESSION | Z15500 "DREI DINGE" | OFFEN-REGRESSION, dokumentiert | LEDGER:7885, LEDGER:7016 |
| Neun Kuerzel-Kollisionen tabelliert (A15, O-A, D-4, R-2, F3, E18-SNAP, P-1, T-n, B-1) | REFERENCE | Z15500 | dokumentiert, Fallen-Register um 7 Eintraege ergaenzt | - |
| A15/§55-Reconcile gelandet (super 16098601, ce 351205f5) | AUFGABE | Z15429-Z15445 | GELANDET | - |
| A5-ETA gebaut (eta_kalibrierung.hpp: Per-Binary-Timing, Mini-Batch, Fortschreibung, Re-Kalibrierung je Block, Kampagnen-Projektion) | FEATURE | Z15448 teammate Bau-A5-ETA | GEBAUT, 421/421 | wt-ce-eta, Branch bau/a5-eta-kalibrierung |
| Praezisierung: project_slice_eta_s/apply_calibration hat Aufrufer erst wenn Record 'done' (ETA nie mehr uebernehmbar) | REGRESSION | Z15448, Z15450-Z15466 | Klaerung (Lead-Formulierung "rechnet niemand" war ungenau, korrigiert) | builder_registration.hpp:282 |
| Befund 1 (hart): ETA-Fortschreibung im Slice BLOCKIERT vom eingefrorenen B2-Merge (jede zweite Fortschreibung verworfen trotz store()=true) | REGRESSION | Z15448 "DREI BEFUNDE" #1 | OFFEN-REGRESSION (Baupunkt 3 NICHT scharfgeschaltet, Test nagelt heutiges Verhalten fest, Owner-Entscheid noetig: Konflikt-Aufloesung aendern ODER monotones Ordnungsfeld) | - |
| Befund 2: Takeover-Uhr-Anker Nebenwirkung (Record wechselt von pro-forma 30min auf 1,5xETA) | UNKLAR | Z15448 "DREI BEFUNDE" #2 | dokumentiert als Verhaltensaenderung, nicht angefasst | builder_registration.hpp:279 |
| Befund 3: Kampagnen-Projektion hat NULL Produktions-Aufrufer (BatchReservierung traegt kein Perm-Feld) | REGRESSION | Z15448 "DREI BEFUNDE" #3 | OFFEN (Nachruesten waere syntax_version-Bump) | - |
| Falle: set_on_binary_done ueberschreibt statt zu akkumulieren (haette Push-Pump-Hook still abgeschaltet) | REGRESSION | Z15448 "ZWEI FALLEN" | BEHOBEN (add_on_binary_done ergaenzt, mit Test) | - |
| Falle: Testat-Zeile hiess "fenster=" statt "slice=" und brach test_tp1_planer_filter_iterator | REGRESSION | Z15448 "ZWEI FALLEN" | BEHOBEN | - |
| A5-ETA gelandet (ce development=73f9a56f), 422/422 — Liste baubarer nicht-gegateter Posten abgearbeitet | FEATURE | Z15460-Z15466 | GELANDET, CI-BEWIESEN | - |
| Alle Rueckfragen und Entscheidungen hier vorlegen (erneuter Auftrag) | OWNER-ENTSCHEID | Z15506 (User-Zitat) | GESETZT | - |
| E-E Overlay-Glied: GO mit Konkatenation fester statischer Ordnung (Mess-/System-/Organ-Achse), abweichend von Lead-Empfehlung (Hash je Datei) | OWNER-ENTSCHEID | Z15516 (User-Zitat) | GESETZT | - |
| Lizenz-Entscheid: restriktivste Lizenz mit Einblick+Compile+Linken erlaubt fuer CE/prt-art/Diplomarbeit-super, KEIN gewerblicher Verkauf, Dual-Lizenz fuer freie Forschung bei allen drei; thesis-Overleaf-Copyright bleibt bei Benjamin-Elias Probst | OWNER-ENTSCHEID | Z15516 (User-Zitat) | GESETZT | - |
| E-E Overlay-Glied Ordnung erkunden (Explore-EE-Ordnung) | AUFGABE | Z15526-Z15527 | GESTARTET | - |

| E-E Overlay-Glied Naht existiert schon (Position 7/9 Preimage), kommt heute leer (#define COMDARE_OVERLAY_SOURCE_HASH "") | FEATURE | Z15558 teammate Explore-EE-Ordnung §1 | GEBAUT (Naht fertig), fehlt nur Fueller (Codegen) | anatomy_fingerprint.hpp:108-128,407 |
| E-E drei Unterfragen: Sortier-Ordnung + Hash-vs-Konkatenation durch Owner beantwortet, Verzeichnis-Schnitt bleibt offen | OWNER-ENTSCHEID | Z15558 §2 | TEILWEISE beantwortet (2/3), Verzeichnis-Schnitt OFFEN | anatomy_fingerprint.hpp:120-123 |
| Kanonische Ordnung existiert bereits (Organ kCompositionAxisNames, System kSystemAxisOrder), Mess hat keine analoge (trivial, nur 1 Achse) | FEATURE | Z15558 §3 | GEBAUT/vorhanden | axis_path_serialization.hpp:31-34, system_axis_order.hpp:42-46 |
| Verzeichnis-Schnitt "das Overlay" NICHT im Bestand belegbar (0 Treffer fuer Verzeichnis "overlay") | UNKLAR | Z15558 §4 | OFFEN (Hypothese axis_XX_-Verzeichnisse als Kandidat, keine Owner-Definition) | - |
| Vier deklarierte Fingerprint-Anker (nicht drei): 3 Frozen-Vektoren + kCebFingerprint in test_d4_ceb_schluessel_wahl | REGRESSION | Z15558 §5 | erkannt/dokumentiert (muessen beim naechsten Preimage-Dreh zusammen bewegt werden) | - |
| StampGliedKategorie aus Plan existiert im Code NICHT (0 Treffer), Plan zaehlt 8 statt real 9 Kategorien | REGRESSION | Z15558 §5 | bestaetigt (bereits in Owner-Vorlage E-F vermerkt), waere 8!=9 nicht kompilierbar | - |
| E-E Verzeichnisstruktur (axis_XX_-Verzeichnisse) am Objekt bestaetigt | FEATURE | Z15562-Z15566 | BESTAETIGT | - |
| Lizenz-Optionen recherchieren | AUFGABE | Z15567-Z15568 | GESTARTET | Recherche-Lizenz |
| Task #39 Update: E-E FREIGEGEBEN (eine Frage offen: Verzeichnis-Schnitt) | AUFGABE | Z15589-Z15590 | TEILWEISE (E-E fast fertig) | Task #39 |
| Owner-Batch-Entscheide: E-A SHA512-Laenge (spaeter SHA256), E-F Gedaechtnisluecke->Explore (Planer traegt Versionsnummer als Stempel, geplant), E-C bestaetigt+std::variant strukturell verboten->Explore+Sidecar-Sinnhaftigkeit pruefen, E-B Gedaechtnisluecke stopfen ("Vorschlag ist irrsinnig", bereits ueber Lagerhaltung geplant, "Wir brechen golden-CRC!"), Overlay-Begriff Session-Historie->Explore | OWNER-ENTSCHEID | Z15595 (User-Zitat) | GESETZT, mehrere Sub-Auftraege an Explores | - |
| E-A Konflikt: SHA512=128 Hex-Zeichen vs kStemMax=120-Grenze (echter dokumentierter stiller built=0-Vorfall) | REGRESSION | Z15602-Z15604 | erkannt | - |
| Vier Explores gestartet: E-F Planer-Stempel, E-C Sidecars+variant-Verbot, E-B Lagerhaltung Symbol-Name, Overlay-Begriff Entstehung | AUFGABE | Z15607-Z15621 | GESTARTET | Explore-EF-Planer, Explore-EC, Explore-EB, Explore-Overlay-Historie |
| E-A: SHA256 statt SHA512 (Owner-Vereinfachung) | OWNER-ENTSCHEID | Z15628 (User-Zitat) | GESETZT | - |
| E-A entschieden: SHA-256=64 Hex-Zeichen, bereits im Baum vorhanden (ctsha.hpp) | AUFGABE | Z15635-Z15644 | ENTSCHIEDEN/GEKLAERT (kein neues Verfahren noetig) | libs/cache_engine/src/sha256/ctsha.hpp |
| FK-3 axis_error_traits.hpp (20 Achsen-Familien, AxisErrorTraits<Axis>) | FEATURE | Z15646 teammate Bau-FK34 | GEBAUT | wt-ce-fk, Commit fcdc77cb |
| Stille Variante ohne FK-3: Toolchain-Fehler und Compile-Fehler landeten unter gleichem Sammel-Etikett | REGRESSION | Z15646 | BEHOBEN durch FK-3 (4 Invarianten I1-I4) | - |
| FK-4 axis_error_traits_organ.hpp (18 Slots T0-T17, OrganSlot<N> als CT-Tag) | FEATURE | Z15646 | GEBAUT (Commit f2709599), 3 Invarianten O1-O3 | - |
| FK-3/FK-4 eigener Fehler (a): Separat-Header auf falscher Praemisse gebaut (grep traf nur Kommentare) | REGRESSION | Z15646 "ZWEI EIGENE FEHLER" | BEHOBEN (Header zurueckgebaut) | - |
| FK-3/FK-4 eigener Fehler (b): erste Bissprobe meldete faelschlich GRUEN (Patch-Suchtext veraltet nach clang-format) | REGRESSION | Z15646 "ZWEI EIGENE FEHLER" | BEHOBEN (Hermetik-Wache haertung ergaenzt) | - |
| FK-3/FK-4 acht Bissproben einzeln (I3,I4,Block D,Hermetik,O1,Anti-Parallelstruktur,Namens-Rueckbindung,Drift) | FEATURE | Z15646 | CI-BEWIESEN (alle korrekt gebrochen) | - |
| FK-3/FK-4 Voll-Bau 1913/1913, ctest Doppellauf 424/424 | FEATURE | Z15646 | CI-BEWIESEN | - |
| FK-3/FK-4 offene Punkte (Blatt->Familien-Aufloesung fehlt, Vollstaendigkeit der Saetze nicht compile-pruefbar, kOrganSlotCount Spiegel, cppcheck nicht gelaufen, nur GCC) | AUFGABE | Z15646 "WAS ICH NICHT GESCHAFFT" | TEILWEISE OFFEN | - |
| E-F Planer-Stempel: Section 43.b gefunden, Plan 20260806-PLAN-versionierungs-interface-stempel.md (4 Stufen planer/ceb/tier/hybrid), Widerspruch Abschnitt1 vs 5.2 im Plandokument selbst | REGRESSION/OWNER-ENTSCHEID | Z15864 teammate Explore-EF-Planer | WEITERHIN OFFEN trotz Owner-Aussage "das ist geplant" — explizite Bau-Sperre ("ohne Bestaetigung baue ich hier nichts"), Gedaechtnisluecke trifft vermutlich den Plan selbst | LEDGER:2450, 20260807-OWNER-VORLAGE-stopp-gates-E-A-bis-E-F.md:210-278 |

| FK-3/FK-4 Korrektur observer_snapshot/pmc haben KEIN Failed (geraten war falsch, am Code korrigiert) | REGRESSION | Z15649-Z15661 | BEHOBEN (Header traegt jetzt korrekte Saetze) | - |
| FK-3/FK-4 gelandet (ce f2709599), 424/424 | FEATURE | Z15661 | GELANDET final | - |
| std::variant-Verbot fuer statische Achsen verifiziert (68 Treffer/45 Dateien geprueft, 3 Klassen: Quarantaene test-only, ausserhalb Scope legitim, definierte Hybrid-Tier-Ausnahme noch nicht gebaut) | AUFGABE | Z15663 teammate Explore-EC-Sidecars Teil1 | BESTAETIGT eingehalten (0 echte Verstoesse ausserhalb 3 dokumentierter Faelle) | permutation_strategy_concept.hpp:11 |
| Sidecar-Verdikt: .fingerprint UNENTBEHRLICH (Lese-Zeitpunkt vor Bau), .version UNENTBEHRLICH (Transport-Vollstaendigkeits-Sentinel), .algos/.variant TECHNISCH ENTBEHRLICH aber teuer zu ersetzen (3 Tests betroffen) | OWNER-ENTSCHEID | Z15663 Teil2 | Klaerung praezise, Owner-Praemisse trifft fuer 3/4 technisch zu | build_orchestrator.hpp:241-256,344-400 |
| Explore-EC-Sidecars Befund gebucht (super 1be85a5e) | AUFGABE | Z15671-Z15674 | GEBUCHT | - |
| E-B Lagerhaltungs-Planung (Owner nannte sie "irrsinnig", forderte Symbol-Namen) NICHT gefunden — Belege bestaetigen stattdessen durchgaengig (ii) nur .rodata | REGRESSION | Z15676 teammate Explore-EB-Lager | Widerspruch zu Owner-Aussage ehrlich gemeldet (3 unabhaengige Konsolidierungspaesse bestaetigen (ii) unveraendert) | 20260801-DOSSIERS-oe-a-c-e-lager-stempel-bestandslog.md, LEDGER:3413 |
| Golden-CRC im Versionierungs-Plan rechnet mit TOTEM Anker (0xF1C1F26A1232073B statt aktuell 0x56F1B721C72DC10E seit 26.07./18.Achse) | REGRESSION | Z15676 §3b | OFFEN-REGRESSION (Dokudrift, 4 Treffer alt / 0 Treffer aktuell) | source_catalog.hpp:190 |
| Golden-CRC bereits einmal gebrochen (26.07., 18. Achse persistence_target, dokumentiertes Verfahren) | REFERENCE | Z15676 §3c | BEHOBEN historisch (gen_golden_fullpilot --crc64) | - |
| NAS/Netzwerkziel-Struktur finden (7,5TB-Rechnung durch NAS 8TB entschaerft, aber Direktive hat weitere Gruende) | AUFGABE | Z15706-Z15715 | GESTARTET (Klaerung: 7,5TB war Begruendung, nicht das Verbot selbst) | - |
| Overlay-Begriff entsteht 26.07.2026 13:01 UTC in Owner-Nachricht (Abnahme 3), von Anfang an unbestimmt, Verzeichnis-Schnitt NIE geschrieben | REGRESSION | Z15717 teammate Explore-Overlay-Herkunft | BESTAETIGT (belegt, nicht vermutet), Erst-Commit b2479c91 fuehrte es bereits als offene Frage | verlauf-queued-ergaenzung-06.txt:102 |
| Drei Fremd-Bedeutungen von "Overlay" im Korpus (Implicit Key Overlay, Diagramm-Overlay/KF-14, Include-Overlay Testtechnik) | UNKLAR | Z15717 §1 | GEKLAERT (keine ist die Fingerprint-Linie) | - |
| Overlay-Glied: ohne es sind reine Quellcode-Aenderungen NICHT im Fingerprint erkennbar (dll_is_current ueberspringt faelschlich) | REGRESSION | Z15717 §2 | OFFEN-REGRESSION, im Code selbst als "NOCH NICHT" dokumentiert | build_orchestrator.hpp:289-291 |
| Overlay urspruenglich Glied 5 von 5, heute 7 von 9 (Toolchain/bvset 10 Tage juenger) | UNKLAR | Z15717 §4 | Klaerung dokumentiert | anatomy_fingerprint.hpp:387,407 |

| Overlay-Herkunft Explore widerlegt Lead-Vorschlag fuer Verzeichnis-Schnitt (anatomy/ mit 54 Dateien fehlt komplett, 28 Verzeichnisse vs 18 Achsen, Toolchain-Glied ist Bau-Schalter nicht Quelltext-Hash) | REGRESSION | Z15717 "VERDIKT ZU DEINEM VORSCHLAG", Z15720-Z15723 | BEHOBEN (Lead-Vorschlag als falsch erkannt und zurueckgenommen, alternativer Vorschlag: 3 kanonische Achsen-Ordnungen + anatomy/) | libs/cache_engine/anatomy/ (54 Dateien) |
| NAS-Struktur gefunden: 2 Plaene (18.07., beide GATED auf User-GO), drei Storage-Ebenen A/B/C, 6 offene Entscheidungen blockieren Aktivierung | AUFGABE | Z15731 teammate Explore-NAS-Struktur | OFFEN (pending, 0 Code fuer Ebene B/C) | 20260718-storage-infra-verortung-VERORTUNGS-BRIEF.md |
| Widerspruch zwischen Lager-Baum-Dokumenten (Verortungs-Brief plant neue prod-longhorn-6TB-NFS, Dual-ccache-Doktrin sagt bestehende backup1-NAS) | REGRESSION | Z15731 §2 | OFFEN-REGRESSION, unaufgeloest (Gap G-E7) | - |
| E-E vollstaendig entschieden, Bau gestartet (Overlay-Glied scharfschalten) | FEATURE | Z15747-Z15752 | GESTARTET | Bau-Overlay-Scharfschalten, wt-ce-overlay |
| Freigegeben-Tabelle: E-A SHA-256/64Hex, E-C Sidecars mitziehen (kein Flotten-Neubau), E-D Ordnernamen auf Stempel mit Doppelspalte im Uebergang | OWNER-ENTSCHEID | Z15757 | ENTSCHIEDEN/baubar | - |
| Lizenz-Vorlage fertig: PolyForm Noncommercial 1.0.0 empfohlen (oeffentliche Schiene) + Einzelvertrag BEP Venture UG (kommerzielle Schiene) fuer alle drei Repos | FEATURE | Z15787 teammate Recherche-Lizenzen | GEBAUT (Vorlage, 371 Zeilen), 3 Owner-Entscheide offen (E1/E2/E3) | 20260807-VORLAGE-lizenzwahl-drei-repos.md |
| E2 wichtigster Fund: Thesis sagt GEDRUCKT super+PRT-ART stehen unter Apache-2.0, nur ce dual — widerspricht neuem Owner-Wunsch | REGRESSION | Z15787 "E2" | OFFEN-REGRESSION (Konflikt Ist vs. neuer Wunsch, Entscheid noetig: Thesis nachziehen oder nur ce restriktiv) | diplomarbeit.tex:219-244 |
| Vendorierter GPL-3/LGPL-Code (P04-CoCo-trie, P07-Wormhole, P29-RCU, A03-michael-lockfree) wird NICHT gebaut (4 CMake-Schalter alle OFF, nur Konvention nicht erzwungen) | REGRESSION | Z15787 "ZU DEINEN ZWEI RANDBEDINGUNGEN" | OFFEN (Empfehlung: CI-Gate das Schalter hart auf OFF nagelt, existiert noch nicht) | - |
| liburing einzige echte Lizenz-Luecke (0 Treffer in NOTICE/Audit) | REGRESSION | Z15787 "Zwei Korrekturen" | OFFEN (formal nachzutragen, MIT dual MIT/GPL) | - |
| Drei Allokator-Lizenz-Abweichungen schlimmer als gemeldet (A03 auch intern uneinheitlich: 4 Quellen, 3 verschiedene Aussagen) | REGRESSION | Z15787 "Die drei Allokator-Abweichungen" | OFFEN-REGRESSION, massgeblich ist Datei-Lizenzkopf (LGPL-2.1) | LICENSE_AUDIT_EXT.md:25, NOTICE:320,514 |
| "Architekt-Direktive II" widerspricht sich selbst zu GPL/LGPL-Umgang (docs/lizenzen widersprechen sich) | REGRESSION | Z15787 "Ein konzeptioneller Punkt" | dokumentiert, praktisch nicht gebraucht (Code nicht gebaut) | NOTICE:471-481 |
| docs/lizenzen/INDEX.md nennt weiterhin "Hauptlizenz Apache License 2.0", unmarkiert veraltet seit 02.08. | REGRESSION | Z15787 "Nebenbefund" | OFFEN-REGRESSION | docs/lizenzen/INDEX.md |
| Task #42 Update: Lizenz-Konflikt Thesis vs neuer Owner-Wunsch | AUFGABE | Z15808-Z15809 | OFFEN | Task #42 |
| Pipeline 15239 rot: lint:static/cppcheck stolpert ueber Hermetik-Wachen-#error (Bau selbst 424/424 gruen) | REGRESSION | Z15821-Z15847 | BEHOBEN (Suppression mit Begruendung gesetzt, projektuebliches Muster gefolgt) | test_a15_fk3_axis_error_traits |
| Kontextuebergabe 20260807-KONTEXTUEBERGABE-abend-zwoelf-landungen geschrieben | FEATURE | Z15854-Z15858 | GEBAUT | - |
| Drei neue Auftraege ohne Bau-Platz: MMX/3DNow Hardware-Recherche, Paper-Permutationen durchrechnen, Erst-Klammerung im Session-Log suchen | AUFGABE | Z15860-Z15872 | GESTARTET | Recherche-MMX, Analyse-Paper-Perm, Explore-Erstklammerung |
| Erst-Klammerung verbatim gefunden (Nacht 19.07->20.07, Owner-Architektur-Vorgabe: Mess-Achse->CEB-Typ->System-Achsen->Tier-Binary XOR Hybrid-Heuristik) | REFERENCE | Z15886 teammate Explore-Erstklammerung | GEFUNDEN/dokumentiert | verlauf-23.txt:100 |

| Tier-Build-Regression am 20.07. selbst korrigiert (faelschlich [a,b,c][d,e,f] statt [d,e,f][g,h,i] gebaut) | REGRESSION | Z15886 §2 | BEHOBEN historisch (ce c96a4da1/super 9eecdc6) | - |
| Lager-Baum-Grammatik (LB-0) vs Erst-Klammerung §43/§58 Verhaeltnis NICHT geprueft | UNKLAR | Z15886 §5 | OFFEN (eigener Explore empfohlen) | - |
| Datentraeger erneut 100% voll (50MB von 251GB) | REGRESSION | Z15918-Z15920 | erkannt (wiederkehrendes Muster, Messung vor Eingriff) | - |
| MMX/3DNow-Basis-Recherche: EIGENE BASIS bestaetigt (AMD APM Anhang D.1), Name "x64" fuehrt in die Irre — Vorschlag "m64" | FEATURE/OWNER-ENTSCHEID | Z15924 teammate Recherche-MMX-Basis | Empfehlung, Owner-Entscheid noch ausstehend | 20260807-RECHERCHE-mmx-3dnow-basis-oder-token.md |
| N-1: mmxext falsch dem 3dnowa-Makro zugeordnet im Katalog (gehoert zu SSE, nicht 3DNow) | REGRESSION | Z15924 "DREI NEBENBEFUNDE" | OFFEN-REGRESSION (Empfehlung gpp="" oder "-msse") | flag_grammar_catalog.hpp:266-270 |
| N-2: "auf keiner erreichbaren Maschine wahr" stimmt nicht fuer mmx/mmxext (beide live auf Testmaschine, mmx in x86-64-Grundlinie) | REGRESSION | Z15924 "DREI NEBENBEFUNDE" | OFFEN, Notations-Frage mit Basis-Entscheid gekoppelt | flag_grammar_catalog.hpp:262 |
| N-3: 3dnowprefetch als Skalar bestaetigt und haerter belegt (APM Vol.3, durch Long Mode impliziert) | REGRESSION | Z15924 "DREI NEBENBEFUNDE" | Bestaetigt, static_assert faellt von 6 auf 0 bei Vollzug | - |
| E-E Overlay-Glied scharfgeschaltet (711 Dateien, 3.343.603 Bytes: 640 organ/16 system/1 mess/54 anatomy) | FEATURE | Z15472 teammate Bau-EE-Overlay | GEBAUT | wt-ce-overlay, Commit c7158b2b |
| Korrektur: 16/18 Organ-Achsen haben unter topics/ nur Weiterleitungs-Huelle, echte Implementierung unter axes/ (Schnitt haette sonst fast alles verfehlt) | REGRESSION | Z15472 "DIE DATEIMENGE" | erkannt+korrekt beruecksichtigt | registry_to_axis_levels.hpp:51-81 |
| E-E Bissbeweise woertlich (H0-H6, Determinismus, bis zur realen Binary durchgemessen) | FEATURE | Z15472 "DIE BISSBEWEISE" | CI-BEWIESEN | - |
| E-E: sechs Anker statt vier (2 fand erst roter Lauf), test_lb1_knoten_heuristik_log umbenannt LEER->BELEGT statt geloescht | REGRESSION | Z15472 "DIE ANKER" | BEHOBEN (alle korrekt neu geankert) | - |
| Eigener Fehler: test_r3_mess_gates_spiegel zwischenzeitlich faelschlich als Parallel-Flake entlastet (grep-Muster falsch) | REGRESSION | Z15472 "DIE ANKER" #6 | BEHOBEN (war echter Befund, korrigiert) | - |
| E-E Verifikation: ctest 428/428 gruen (Basis-Diff 4 erklaert durch EXCLUDE_FROM_ALL Zweit-Configure) | FEATURE | Z15472 "VERIFIKATION" | CI-BEWIESEN | - |
| E-E offene Punkte: nur gcc-release, cppcheck nicht gefahren, axes/alloc/vendor_includes-Einordnung Auslegung, extension_hardware_system_axis.hpp (deprecated) bewusst im Schnitt behalten | UNKLAR | Z15472 "WAS ICH NICHT GESCHAFFT" | dokumentierte Auslegungen, ggf. Owner-Korrektur noetig | - |
| A9 Jitter-Review Kartierung fertig (6 Klassen L1-L6, kein Bau) | AUFGABE | Z15540 teammate A9-jitter-review | ABGESCHLOSSEN (Kartierung) | wt-ce-rest |
| Befund 1: virtueller Aufruf INNERHALB Timing-Fenster (Pfad B, tier_observe_trace_abi.hpp) — architektonisch erzwungen wegen .so-ABI-Grenze | REGRESSION | Z15540 "Befund 1" | dokumentiert, KEIN Ersatz moeglich ohne Architekturwechsel, Doku-Empfehlung offen | tier_observe_trace_abi.hpp:141-174,216-265 |
| Befund 2: std::function im Timing-Fenster (execute_engine_command.hpp), aber NICHT erreichbar aus produktiver Golden-Run-Pipeline (toter Pfad) | REGRESSION | Z15540 "Befund 2" | OFFEN (Empfehlung: als toten Pfad entfernen, letzter Rest der "Command-Inseln") | execute_engine_command.hpp:51,99-120 |

| A9 Jitter-Review Abschluss: Pfad A (axes/topics) sauber CT-dispatcht, viele "Termin 7"-Interfaces (subsystems c01-c12, platform, concepts, api) ohne jeden Konsumenten | REGRESSION | Z15540 §6-8 | Nullbefund fuer Jitter (unerreichbar), Aufraeum-Kandidat falls relevant | - |
| NAS F1 Cluster_NFS Export (backup1/PR4100) live verifiziert | REFERENCE | Z15631 teammate A8-nas-infra F1 | SICHER bestaetigt | showmount 10.0.20.241 |
| NAS F2 Filterpod measure-drop: GET technisch blockiert (403), Git-Manifest zeigt tote IP .101 statt live .241 seit 21.07. nie nachgezogen | REGRESSION | Z15631 F2 | OFFEN-REGRESSION (Rollback-Risiko bei Redeploy) | measure-drop-filterpod.yaml |
| "12 SNI-Regeln" veraltete Gesamtzahl (real 33 ACLs/34 Actions seit 14.07., weitere seither dazugekommen) | REGRESSION | Z15631 F2 | OFFEN-REGRESSION (Doku-Drift) | docs/FEHLER-LOESUNGEN-KB.md:380-386 |
| NAS F3 Schreib-only ist bewusste Owner-Entscheidung (User-Entscheid A 18.07., KEIN POSIX-Mount) | OWNER-ENTSCHEID | Z15631 F3 | BESTAETIGT (dreifach belegt) | - |
| NAS F4 Transport-Widerspruch am 18.07. aufgeloest (HTTPS-PUT gewaehlt), aber jetziger Owner-Wunsch (TB-Binaries+Messdaten lesbar) passt in KEINES der beiden bestehenden Modelle | OWNER-ENTSCHEID | Z15631 F4 | NEUER BEDARF, kein Bugfix — Klaerung noetig | artifact_cache.hpp |
| NAS F5 backup1(PR4100)/backup2(PR2100) physisch verschiedene Geraete; 16TB-Zahl NICHT belegt (real ~10,1TB: 3,6TB+6,5TB frei) | REGRESSION | Z15631 F5 | OFFEN-REGRESSION (Kapazitaets-Diskrepanz), Erreichbarkeit backup1.comdare.de live SICHER (HTTP/2 200) | 2026-08-06-K130-J-git-dr...BEFUND.md:293-296 |
| NAS F6 Vorschlag: eigener neuer SNI-Dienst (Kandidat 3) statt Direkt-IP-Mount (Kandidat 2, wiederholt bekannten Isolationsfehler) | OWNER-ENTSCHEID | Z15631 F6 | EMPFEHLUNG, Owner-Entscheid noetig | - |
| A4-Thesis: 2^17/18-Stolperstelle in Anhang E ADR-2 (DE+EN) — Pinning-Erklaerung fehlt, Beleg-Feld verweist nicht auf sec:mess-chain | REGRESSION | Z15702 teammate A4-thesis-nachzug P1 | OFFEN-REGRESSION, Vorschlagssatz DE+EN vorgelegt | anhang/de/E_architecture_decisions.tex:28-29 |
| 04_concept_architecture.tex (alte 19-Achsen-Zaehlung) bereits deprecatet markiert, nicht eingebunden | UNKLAR | Z15702 "Nebenfund" | KEIN Handlungsbedarf (schon sauber) | - |
| A4-Thesis Lizenz-Tabelle drei Abweichungen bestaetigt+detailliert (michael_lockfree BSD-3 falsch in kleiner Tabelle UND "MIT Re-Impl" falsch in Anhang D/PAPER_REFERENCES; tcmalloc/lrmalloc nur kleine Tabelle falsch) | REGRESSION | Z15702 P2 | OFFEN-REGRESSION, Vorschlag vorgelegt (copy-paste-Default "BSD-3" vermutet, 4/10 Zeilen betroffen) | kapitel/de/03_messsystem_prtart.tex:233-240 |
| Echter Bindungspfad zu vendoriertem LGPL-Code existiert (COMDARE_AXIS_06_USE_MICHAEL_LF, Default aus) — "MIT Re-Impl"-Anspruch fraglich | UNKLAR | Z15702 P2 "Wichtige Nuance" | OFFEN, Owner-Klaerung empfohlen | axis_06_allocator_flags.hpp.in:35 |
| A4-Thesis P3: Flag-Grammatik v2 VOLL STALE in Thesis (altes v-Praefix, 'e'=experimental statt efficiency-core) | REGRESSION | Z15789 P3.1 | OFFEN-REGRESSION | anhang/de/D_building_block_matrix.tex:1131-1136, kapitel/de/03_messsystem_prtart.tex:1153 |
| A4-Thesis P3: fingerprint_format Nullbefund (Thesis schweigt, kein Widerspruch) | UNKLAR | Z15789 P3.2 | Luecke, kein Fehler | - |
| A4-Thesis P3: golden-Katalog 2^17/320 bereits synchron | UNKLAR | Z15789 P3.3 | KEIN Handlungsbedarf | source_catalog.hpp:83 |

| A4-Thesis P3.4: branch_misses STALE an 3 Stellen (Thesis sagt weiterhin "nicht verdrahtet", Code M-3a VOLLZOGEN seit 6a8ab995 NACH Thesis-HEAD) | REGRESSION | Z3810 (A4-thesis-nachzug P3.4) | OFFEN-REGRESSION, IPC/CPI bleibt korrekt unverdrahtet (Korrektur muss branch_misses nur heraussloesen) | kapitel/de/05_evaluation.tex:95,194, 06_fazit.tex:162 |
| A4-Thesis P4: keine inhaltliche DE/EN-Divergenz gefunden (EN ueberall treue Uebersetzung, auch wo DE stale ist) | REFERENCE | Z3830 (A4-thesis-nachzug P4) | BESTAETIGT (positiv) | - |
| A9-Jitter-Review Nachverifikation gegen fea430d0: alle 8 zitierten Dateien byte-identisch, Befunde 1+2 unveraendert gueltig | FEATURE | Z3851 teammate A9-jitter-review (Nachverifikation) | CI-BEWIESEN bestaetigt | - |
| Zwei neue switch-Stellen (pruef_dock_version.hpp:75, flag_grammar_catalog.hpp:93) geprueft — harmlose constexpr Enum-Zuordnung, bewusst statt virtual gebaut | FEATURE | Z3851 | GEBAUT, kein Jitter-Risiko | - |
| perm_runner.hpp bleibt ungeprueft (Pro-Setting-Messung delegiert dorthin) | AUFGABE | Z3851 §4 | OFFEN | harness/perm_runner.hpp |
| KORREKTUR A4-Thesis P3.5: eigener Erstbefund war gegen zu alten Checkout gerechnet — FK-3/FK-4 sind tatsaechlich gelandet (axis_error_traits.hpp 20 Familien, axis_error_traits_organ.hpp 18 Slots, beide verifiziert) | REGRESSION | Z3878 teammate A4-thesis-nachzug (Neupruefung) | BEHOBEN (eigener Fehler korrigiert), Thesis dokumentiert das Bauteil an KEINER Stelle — Doku-Luecke, Owner-Entscheid ob fuer Abgabe noetig | axis_error_traits.hpp, axis_error_traits_organ.hpp:45 |

## Fortschritt
Gelesen: Zeilen 1-3911 von 3911 (VOLLSTAENDIG).
