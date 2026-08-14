# LESER 4 von 12 -- Extraktion JSON-Batch (i % 12 == 3)

## Batch-Dateiliste (Index, Name, Bytes)
- 3 wfkyov860.json 315270
- 15 w9cqubpi0.json 139947
- 27 woyk1t3na.json 104904
- 39 wnfai1iau.json 84238
- 51 wdfgx3k8f.json 64633
- 63 w56km2g9g.json 45923
- 75 wgr8gvgza.json 34863
- 87 w41d6x1yq.json 29700
- 99 wn86mzt85.json 22292
- 111 wpzbpjmj1.json 16988
- 123 wr5l6ao2d.json 12482
- 135 w2w3z101l.json 8524
- 147 wvs8ulxqx.json 4828

Quelle je Datei: /home/comdare/.claude/jobs/5a19728e/tmp/regressions-gesamtbild/<name>

---

# DATEI 1: wfkyov860.json -- "11 Betreuer-Termine (309 Dateien) vollstaendig lesen + gegen Ist-Stand diffen"
Workflow: 3 Phasen (Lesen 6 Agenten, Diff 3 Agenten, Synthese 1 Agent). WICHTIG: Synthese-Agent
"synthese:termin-kanon" ist mit API-Error gestorben ("Server error mid-response") -- result.kanon = None.

### [wfkyov860.json] 1
GEGENSTAND: Der Termin-Kanon (Synthese ueber alle 11 Termine) wurde NIE erzeugt -- Synthese-Agent starb an API-Error, result.kanon=None.
ORT: Workflow wfkyov860, Agent synthese:termin-kanon, state=error
SOLL/FIX: Synthese/Kanon aus den 6 Lese- und 3 Diff-Berichten nachziehen (Berichte liegen vollstaendig vor).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: alle nachfolgenden Funde dieser Datei sind Roh-Berichte ohne Kanon-Dedup

### [wfkyov860.json] 2
GEGENSTAND: Datums-Widerspruch Termin 2: Ordner "20260330 Termin 2" + INDEX.md:15 sagen 2026-03-30, alle drei T2-Dateien tragen 20260405, docProps created 2026-04-05.
ORT: docs/termine/20260330 Termin 2/ + docs/termine/INDEX.md:15
SOLL/FIX: "Es gilt die Datei: Termin 2 wurde am 05.04.2026 erstellt, bis 09.04.2026 nachbearbeitet. Der Ordnername ist irrefuehrend."
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

### [wfkyov860.json] 3
GEGENSTAND: Invarianten I1-I6 aus T2 sind der maschinell pruefbare Abnahmevertrag; I5 verbietet feste universelle Schwellwerte -- jede hartkodierte Konstante in einer Umschaltregel ist Abweichung von T2.
ORT: 20260405_PRT_ART_Architekturentscheidungen_Termin2_final.docx [P0050-TAB]-[P0060-TAB]
SOLL/FIX: I2 ("genau ein ValueHandle") und I4 (Ordnungsrelation der rohen Byte-Keys) als Testfamilie ueber jede Seitentyp-Kombination fahren; I5-Verstoesse (hartkodierte Schwellwerte) auditieren.
STATUS LT. QUELLE: nur-hinweis (Pruefauftrag)
ABHAENGIGKEIT/FLAECHE: I6 spaeter durch REV6 5.23 praezisiert (Multi-Writer), T6-SF bleibt Betreuer-Fassung

### [wfkyov860.json] 4
GEGENSTAND: Cache-Engine hat abschliessend definierte Eingabe- (5) und Ausgabemenge (5) aus T2 -- als 10-Punkte-Checkliste gegen Ist-Stand zu halten.
ORT: Architekturentscheidungen T2 [P0034]/[P0035]
SOLL/FIX: Eingaben = lokale Dichte/Fanout, Praefixentropie, erwartete beruehrte Cache-Lines/Pages pro Lookup, Key-/Value-Groesse+Inline-Eignung, ISA-/HW-Profil; Ausgaben = Seitentyp, Alignment, lokale Ordnung, Inline-vs-Pointer-Value, Reorganisation von Node-Gruppen.
STATUS LT. QUELLE: nur-hinweis (Checkliste)
ABHAENGIGKEIT/FLAECHE: -

### [wfkyov860.json] 5
GEGENSTAND: Fairnessregel fuer seitenspezifische Inline-/Pointer-Values gegenueber Baselines wird in T1/T2 dreimal gestellt und nirgends beantwortet -- an T3 delegiert.
ORT: Arbeitsaufstellung T2 [P0089], Architekturentscheidungen [P0085], slide5:p022
SOLL/FIX: T3 [p069] liefert die Antwort: Common-Denominator-Modus vs. PRT-ART-Native-Modus strikt trennen.
STATUS LT. QUELLE: beantwortet in T3, aber im Ist nicht wirksam (siehe Funde 63, 84)
ABHAENGIGKEIT/FLAECHE: fairness_mode-Umsetzung

### [wfkyov860.json] 6
GEGENSTAND: 4-Ebenen-Pflichtmetrik-Matrix aus T1; Speicherbilanz-Ebene ("Bytes pro Key; Poolgroessen getrennt nach Suchseiten/Redirects/Values; Tombstones; Konsolidierungskosten") ist die am leichtesten vergessene.
ORT: Literatur_und_Arbeitsplanung T1 [P0119-TAB]-[P0131-TAB]
SOLL/FIX: Wer nur Latenz+perf-Counter misst, erfuellt 2 von 4 Ebenen. "Ohne saubere Speicherbilanz bleibt der Layout-Anspruch unglaubwuerdig."
STATUS LT. QUELLE: offen (Ist: teilweise, siehe Fund 60)
ABHAENGIGKEIT/FLAECHE: CSV-Schema

### [wfkyov860.json] 7
GEGENSTAND: Konfliktregel T1/T2: Es gilt T2 (Architektur-Freeze); T1 bleibt allein massgeblich fuer Forschungsfragen-Wortlaut, H1-H4, 4-Ebenen-Metrikmatrix, Datensatzliste, Leseliste L1-L16.
ORT: Arbeitsaufstellung T2 [P0005-TAB]
SOLL/FIX: verbatim uebernommen als Fassungsregel.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

### [wfkyov860.json] 8
GEGENSTAND: T3-Hybrid-Regel ist Messregel, kein Infrastrukturdetail: "P- und E-Cores werden nicht zusammenaggregiert. perf dokumentiert dafuer getrennte PMUs cpu_core und cpu_atom; gruppierte Events ueber beide PMUs werden vermieden."
ORT: T3 Benchmarkplan [p016] + Arbeitsaufstellung [p019] (eigener Kasten)
SOLL/FIX: Ein perf-Job, der ueber beide PMUs gruppiert, ist Verstoss gegen T3 (09.04.2026). Risiko [p077]: "strikte Trennung cpu_core/cpu_atom; JSON-Ausgabe aus perf".
STATUS LT. QUELLE: offen im Ist (siehe Funde 46, 68)
ABHAENGIGKEIT/FLAECHE: linux_perf_pmc_source.hpp, AP-13, G-270a

### [wfkyov860.json] 9
GEGENSTAND: T3 hat 8 Pflicht-Messachsen inkl. Core-Modus (Single P/Single E/All-P/All-E/Barnard homogeneous); Core-Modus fehlt in beiden Kurzformeln ([p012], slide4 par026) und wird deshalb systematisch uebersehen -- dokumentierter Verlustpfad.
ORT: T3 Benchmarkplan [p047]-[p054], massgeblich Tabelle [p053]
SOLL/FIX: "Die Tabelle [p053] ... ist die detailliertere und damit massgebliche Fassung."
STATUS LT. QUELLE: offen im Ist (siehe Fund 47)
ABHAENGIGKEIT/FLAECHE: XSD/Experiment-Schema (kein core_type/core_mode/pinning-Element)

### [wfkyov860.json] 10
GEGENSTAND: Die Zahl "97.200 Konfigurationen" in extract_termin3_4.md ist abgeleitete Rechnung eines spaeteren Agenten, KEIN T3-Zitat; eigene Nachrechnung des Lesers ergibt 81.000; Seitentyp-Achse ist in T3 nicht als Tabellenzeile ausgewiesen.
ORT: docs/termine/20260508 Termin 7/Phase5_UML_Detail/_rev5_extractions/extract_termin3_4.md (Abschnitt F.4)
SOLL/FIX: Zahl nicht als T3-Quelle zitieren.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

### [wfkyov860.json] 11
GEGENSTAND: Sekundaerquelle extract_termin3_4.md widerspricht Primaerquelle: behauptet, T4 ergaenze Core-Typ und Wiederholung als Achsen -- FALSCH, beide stehen seit T3 [p053]/[p054] als Pflicht.
ORT: extract_termin3_4.md vs. T3 Benchmarkplan [p053]/[p054]
SOLL/FIX: "Es gilt die T3-Fassung." Core-Modus-Achse ist seit 09.04.2026 Pflicht.
STATUS LT. QUELLE: nur-hinweis (Quellen-Korrektur)
ABHAENGIGKEIT/FLAECHE: -

### [wfkyov860.json] 12
GEGENSTAND: T3-Auswertungsregeln (3, nicht verhandelbar): Perzentile nie mitteln; 5 Laeufe nebeneinander berichten (Abweichungen sind Teil der Aussage); 64-Byte-Advisor-Modell ersetzt nicht Hardware-Discovery.
ORT: T3 Benchmarkplan [p065]-[p067]
SOLL/FIX: verbatim; [p067] ist primaerquellige Fassung der Doktrin "Hardware nie statisch" (seit 09.04.2026).
STATUS LT. QUELLE: Mechanik im Ist erfuellt, Zaehlwert abgewichen (Fund 50)
ABHAENGIGKEIT/FLAECHE: repetitions count

### [wfkyov860.json] 13
GEGENSTAND: T3-Fairness/Ehrlichkeitsregeln: N/A statt Emulation; Build-Transparenz "Compiler, Flags, ISA-Pfad, Allocator und Commit-Hash jeder Fremdbibliothek werden mitgeloggt"; 9-Feld-Datensatz-Akte; Roh-CSV/JSON je Lauf + HDR-Histogramme separat.
ORT: T3 Benchmarkplan [p069]-[p073], [p031], [p054]
SOLL/FIX: verbatim als Pflichten.
STATUS LT. QUELLE: teilweise im Ist (Funde 51, 60, 62)
ABHAENGIGKEIT/FLAECHE: CSV-Schema, Provenienz-Stempel

### [wfkyov860.json] 14
GEGENSTAND: Forschungsfrage hat drei Fassungen (T4-Arbeitsaufstellung "moderne CPU-Hardware"; T4-Scope-Freeze+Praesentation "Hybrid-CPUs und Sapphire-Rapids-Systemen"; T5 "unterschiedliche CPU-Plattformen", explizit sinngemaess).
ORT: T4 Scope_Freeze P9, T4 Arbeitsaufstellung P8, T5 Landkarte P111
SOLL/FIX: "Geltend: die Hybrid/Sapphire-Fassung" (Freeze-Dokument + Praesentation, spaetester mtime).
STATUS LT. QUELLE: nur-hinweis (Fassungsregel)
ABHAENGIGKEIT/FLAECHE: FF0-Formulierung der Thesis

### [wfkyov860.json] 15
GEGENSTAND: T4: P0 und P1 unantastbar; genau EINE optionale Komponente (multiples multithreaded Schreiben); Online-Umlagerung ist P2 und PFLICHT ("darf live Pages umbauen und verschieben ... nicht Optional, sondern Teil des Forschungsbeitrags").
ORT: T4 Arbeitsaufstellung doc:P57/P37/P58; Scope_Freeze doc:P71
SOLL/FIX: Spannung mit T5 slide6:P12 ("aggressive Online-Umlagerung sekundaer") aufgeloest: Online-Relocation bleibt Pflicht (P2), nur aggressive Varianten sekundaer.
STATUS LT. QUELLE: im Ist teilweise (adaptive/tier_based nicht in Messmenge, Fund 59)
ABHAENGIGKEIT/FLAECHE: migration_policy-Achse

### [wfkyov860.json] 16
GEGENSTAND: "drei Ordnungsmodi" ist P1-Pflicht (T4) und H2-Parameter, wird aber in T4/T5 nirgends benannt -- Definition muss aus T3 kommen (unsortiert, lokal geordnet, lexikographisch).
ORT: T4 Arbeitsaufstellung P25, slide3:P13, H2; T3 [p050]
SOLL/FIX: Ordnungsmodus-Achse definieren gemaess T3.
STATUS LT. QUELLE: offen (Ist: Achse existiert nicht, Funde 55, 78)
ABHAENGIGKEIT/FLAECHE: Achsen-Katalog (18 Achsen enthalten keine Ordnung)

### [wfkyov860.json] 17
GEGENSTAND: Dokumentierte Spannung T4/T5 zu Programm-/Instruction-Cache: Scope_Freeze P65 nennt Programmseiten als Engine-Aufgabe, T5 R6 mahnt "nicht die Hauptbegruendung tragen" -- T5 streicht die Aufgabe nicht.
ORT: T4 Scope_Freeze doc:P65 vs. T5 R6/slide1:P29
SOLL/FIX: vorsichtige Formulierung, Aufgabe bleibt.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Thesis-Sprachregelung

### [wfkyov860.json] 18
GEGENSTAND: T4-Messregeln: 5 Rohlaeufe ohne Mittelung, 6 Pflicht-Datensaetze (url, xml, dna, protein, trec-terms, tpcds-id), Policy-Ablation 5 Stufen (Cache-Engine Off / nur Page-Type-Selection / nur Prefetch / nur Relocation / Full Engine) fuer Kausalnachweis "active > passive".
ORT: T4 WP5 (Arbeitsaufstellung doc:P44), Landkarte doc:P227/P242
SOLL/FIX: Ohne Off-Stufe kein Kausalnachweis.
STATUS LT. QUELLE: offen im Ist (Funde 44, 61, 75)
ABHAENGIGKEIT/FLAECHE: CacheEngineMode als Mess-Dimension

### [wfkyov860.json] 19
GEGENSTAND: T5-Designregeln R1-R6, insb. R2 (universelle Schwellwerte nicht begruendbar), R5 ("zuerst messen, dann aktivieren. 'Mehr Prefetch' ist kein Forschungsbeitrag"), Kalibrierungsphase vor produktivem Lauf.
ORT: T5 Landkarte doc:P98-P109, Praesentation slide3:P28-P30
SOLL/FIX: verbatim.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

### [wfkyov860.json] 20
GEGENSTAND: T6-Auswertungsregel (geltende Fassung fuer Plattformen/ISA/Messstack): "fuenf Rohlaeufe, keine Mittelung von Perzentilen, getrennte Ausweisung nach Plattform, Core-Typ, ISA und Cache-Engine-Modus."
ORT: T6 Arbeitsaufstellung Z.16
SOLL/FIX: minimale Reporting-Dimension D1xD3xD2xD4.
STATUS LT. QUELLE: offen im Ist
ABHAENGIGKEIT/FLAECHE: CSV-Spalten cpu_class/Modus fehlen (Funde 54, 61)

### [wfkyov860.json] 21
GEGENSTAND: T6-Erfolgskriterium ist ein UND: besser als statischer Modus GLEICHZEITIG in End-to-End-Latenz UND in Miss-/CLU-/Footprint-Metriken; 3 Verifikationsmodi passiv/warm-up/online-adaptiv.
ORT: T6 Scope_Freeze Z.9-12
SOLL/FIX: verbatim.
STATUS LT. QUELLE: offen im Ist (Fund 44)
ABHAENGIGKEIT/FLAECHE: CLU/Footprint-Spalten, Modus-Achse

### [wfkyov860.json] 22
GEGENSTAND: T6-Nichtziele: keine GPU-Kernel, keine erzwungene Neuimplementierung fremder Algorithmen (Wrapper/Originalprojekte), kein Multiwriter als Pflichtkern, keine Instruction-Cache-Volltheorie; Intel MLC auf ZIH kein Primaerinstrument; AMX nicht eingefroren.
ORT: T6 Scope_Freeze Abschnitt 5, Z.15-18
SOLL/FIX: verbatim.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Spannung zu REV6 5.23 (Multi-Writer) -- Betreuer-Fassung ist abgabe-verbindlich

### [wfkyov860.json] 23
GEGENSTAND: Habich-Auflagen H1-H6 aus T7 (08.05.): H1 UML-Vollausarbeitung + ER-Modell ("das volle Programm"); H2 BAUSTEIN_BEWERTUNG.md mit Quelle-Commit-Hash + Habich-Sign-Off; H3 LaTeX-Toolchain mit dynamischer Diagramm-Compile (nur Appendix); H4 Repo-Separation; H5 CacheEngine als ABI-stabiler Production-Container + Verifikations-Suite ohne Mess-Aktivierung; H6 KEIN PYTHON (Talos OS).
ORT: docs/termine/20260508 Termin 7/Habich_Feedback_2026_05_08.txt Z.22-212
SOLL/FIX: verbatim als Betreuer-Auflagen; H6 revidiert F-EXTRA-5.
STATUS LT. QUELLE: teilweise (H2-Artefakt anders umgesetzt, Fund 85; H6-Verstoss codegen.py, Fund 27)
ABHAENGIGKEIT/FLAECHE: Habich-Sign-Off ausstehend

### [wfkyov860.json] 24
GEGENSTAND: OPEN-1..4 aus T7: OPEN-1 Compiler-Versionen autonom recherchieren; OPEN-2 Concept-Interfaces erst nach Kartografierung aller 33 Quellen; OPEN-3 KEINE Java-Runtime auf Production-Cluster; OPEN-4 zwei private GitHub-Repos SOFORT vor Cluster-Migration.
ORT: Habich_Feedback_2026_05_08.txt Z.352-409
SOLL/FIX: verbatim.
STATUS LT. QUELLE: offen lt. Quelle
ABHAENGIGKEIT/FLAECHE: OPEN-3 kollidiert mit YCSB-Java (F5: Original Java-YCSB einbinden) -- Provider-Tickets #109/#111 offen (Fund 33)

### [wfkyov860.json] 25
GEGENSTAND: F-EXTRA-8 ABI-Test + Habich-Log: Bit-Identitaet (diff der .o), funktionale Aequivalenz, strukturelle Pruefung; bei nicht-exakter Bit-Genauigkeit LOG fuer Prof. Habich (Baustein, Compiler-Version, Bit-Diff, Source-Identitaetsbeweis, Ursachen-Hypothese) -- "Habich entscheidet".
ORT: Architekturentscheidungen_F1_F15.txt Z.897-933; ER-Feld BuildArtefact.habich_log_path (07_er_model.md Z.185-186)
SOLL/FIX: verbatim; ER-Feld existiert bereits.
STATUS LT. QUELLE: offen (Prozess nie ausgefuehrt gemeldet)
ABHAENGIGKEIT/FLAECHE: Adapter-/ext-Aktivierung

### [wfkyov860.json] 26
GEGENSTAND: Kuehn-Erkenntnisse: naive Pro-Knoten-Histogramme UNBRAUCHBAR fuer parallele Workloads (Cacheline-Ping-Pong); Gegenmassnahmen LeafOnlyCounter/RetroactiveAggregation/Sampling; offene Punkte OPEN-K1 (wo wird Cache-Kohaerenz-Cost geschaetzt), OPEN-K2 (wann triggert RetroactiveAggregation-Barriere), OPEN-K3 (Heuristik fuer N-Anpassung, Kuehn konsultieren).
ORT: Kuehn_Erkenntnisse_Einarbeitung_2026_05_09.txt Z.24-303
SOLL/FIX: verbatim; P28 Kuehn-Code-Drop "ZUGESAGT (Code-Drop offen)" (08_cross_reference.md Z.74).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Achse 11 Telemetry, NotInTopLevels-Constraint

### [wfkyov860.json] 27
GEGENSTAND: tools/permutation_codegen/codegen.py (47 Zeilen Skelett) verletzt H6/F-EXTRA-5 (NO-PYTHON) frontal; wird bei jedem Build mit COMDARE_BUILD_PERMUTATIONS=ON aufgerufen.
ORT: extract_comdare_audit.md Z.257+297; Direktive: CMakeShBatCodegenDriver-Invariante "KEIN Python in der Toolchain"
SOLL/FIX: CMake + codegen.sh/codegen.bat, synchron (verify_sync vor jedem Build).
STATUS LT. QUELLE: offen (Stand Audit)
ABHAENGIGKEIT/FLAECHE: H6

### [wfkyov860.json] 28
GEGENSTAND: Comdare-Audit-Luecken (T7): datasets/ LEER (Task #81/#82 pending); hardware_isa/hybrid_core_pinning Skelett ohne Code; PlatformProbe dreifach dupliziert; vollstaendig fehlend: PressureState-State-Pattern, ICacheEngineVisitor REV-5.3-konform, 7 von 12 Sub-Engines (C02 Pinning, C04 Coherence, C05 Telemetry, C08 Encoding, C09 Heuristik, C10 Topologie, C12 Filter), kPipelineOrder, Hybrid-Command-Pattern K04, PLATFORM_REQUIREMENTS.md nicht im Comdare-Repo; Namespace-Konflikt prt_art::cache_engine vs comdare.
ORT: _rev6_extractions/extract_comdare_audit.md Z.226-614
SOLL/FIX: C02 Pinning: NEU subsystems/c02_pinning_engine/ (alternativ hardware_isa/hybrid_core_pinning/ umstellen).
STATUS LT. QUELLE: offen (Stand T7-Audit; Diff-Teil bestaetigt 12 Interfaces / 0 Implementierungen, Fund 57)
ABHAENGIGKEIT/FLAECHE: Sub-Engine-Architektur C01-C12

### [wfkyov860.json] 29
GEGENSTAND: Fuenf drawio-Tabs (18.-21.05., nur in phase5_uml_detail_REV7.drawio, KEIN .md-Pendant im T7-Ordner): N-Phase 11->14 Achsen (~120 Bausteine, 82-bit Permutations-ID statt 50); AA.2 CacheEngine = GLEICHWERTIGE ExecutionEngine neben PRT-ART; AA.3 Default-Achsen-Lookup = CEB-Auto-Permutation; O-Phase PRT-ART-Achsen-Audit 9/19 Sub-Achsen abgedeckt, 10 fehlen + "mind. 1 voellig neuartige Implementation in mind. 1 Achse"; R.12 Anti-Vermischung 4 Ebenen (F1-F29 und C1-C12 sind KEINE Algorithmus-Achsen).
ORT: docs/termine/20260508 Termin 7/Phase5_UML_Detail/phase5_uml_detail_REV7.drawio (54 Tabs); Verweise auf docs/bausteine/07_bausteine_matrix_N_erweitert.md u.a. ausserhalb des Termin-Ordners
SOLL/FIX: Beschluesse aendern Permutations-ID (50->82 bit) und CE-Rolle grundlegend; muessen beim Gap-Abgleich beruecksichtigt werden.
STATUS LT. QUELLE: nur-hinweis ("Zusatz-Befund, den heute vermutlich niemand kennt")
ABHAENGIGKEIT/FLAECHE: Flag-System-Baenke, ExecutionEngine-Rollenmodell

### [wfkyov860.json] 30
GEGENSTAND: Chronologie-/Fassungsregeln aus T6/T7-Lesebericht: T6 gilt fuer Plattformen/ISA/Benchmarks/Messstack; H6 schlaegt F-EXTRA-5 + v4 D-4; F12-K schlaegt F12; F10-K schlaegt F10 (Flag-System statt perm_id); Flag-System 10 Baenke (telemetry_bank) ueberholt 9-Bank-Fassung; K3.2 ersetzt plattformspezifische Probe-Klassen durch Auto-Discovery-Properties (RyzenX3DProbe -> has_asymmetric_l3, IntelHybridProbe -> has_hybrid_cores, X3DVCachePinningHeuristic -> LargestL3CcdPinningHeuristic, IntelHybridPCoreRoutingHeuristic -> HotPathOnHighIpcCoreHeuristic, neu measure_pinning_effects()); Glossar v7 > v6 > ... ; REV6 5.23 vs T6-SF Multiwriter: Betreuer-Fassung abgabe-verbindlich; Habich T7 entschieden: KEINE Reduktion der Messreihe B auf Teil-Auswahl ("die Messung muss immer so vollstaendig wie moeglich sein").
ORT: Teil D des T6/T7-Leseberichts; HABICH_TERMIN7_ZUSAMMENFASSUNG_2026_05_13.md Z.90
SOLL/FIX: verbatim als geltende Fassungen.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

### [wfkyov860.json] 31
GEGENSTAND: Risiko-Vorhersagen T7 mit Ist-Bezug: P25-Warnung "Auf i9-14900KS muessen kleine Knoten (<1 KiB) bevorzugt werden" (STRONG Prefetch + 8KB Nodes -> Slowdown 0.4-1x); AVX-512 auf i9-14900KS disabled (Hybrid-Constraint); macOS keine AVX-Annahmen; REV 7.5: 54 gemessene DLL-Module waren Mock-Stubs (op_count=0 erwartetes Mock-Verhalten, kein Messergebnis).
ORT: 13_saeule_b Z.536/543-544; 29_... (REV 7.5) Z.150-153
SOLL/FIX: Heuristik-Warnungen in Plattform-Heuristiken beruecksichtigen; Mock-Gruen nicht als Messergebnis werten.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

### [wfkyov860.json] 32
GEGENSTAND: Mess-Record-Layout 32 Byte mit cpu_class (0=core/1=atom), telemetry_strategy, sampling_n ist in T7 festgelegt (UML+ER+CSV-Schema); wer Messdaten ohne diese drei Felder schreibt, verletzt T6-Auswertungsregel, Achse 11 und ER-Modell aus H1.
ORT: 06_uml_persistence.md Z.52-63; 07_er_model.md Z.108-112, 258-260
SOLL/FIX: Felder fuellen; Struktur im Ist vorhanden (measurement_record.hpp, static_assert 32) aber OHNE Erzeuger.
STATUS LT. QUELLE: teilweise (Struktur ja, Erzeuger fehlt)
ABHAENGIGKEIT/FLAECHE: Fund 46 (Hybrid-PMU), CSV-Spalten

### [wfkyov860.json] 33
GEGENSTAND: T8 offene Tickets: #74 Email-Antworten P06/P28/P31/P32/P33; #77 Cluster-Migration Fortigate-31G+GitLab; #95 Kuehn-Code-Download P28; #109 Debian-Pod als YCSB-Provider (INFRA, offen); #111 Talos OS Java-Runtime-Provisioning (INFRA, offen); V21.2 HW-E2E-Messreihe; V21.5 Habich-Termin 8.
ORT: Arbeitsplan_Termin8.md:214-222
SOLL/FIX: YCSB-Provider ist seit T3 Datensatzplan-Grundlage; Provider bis heute INFRA-offen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: OPEN-3 (kein Java auf Production-Cluster)

### [wfkyov860.json] 34
GEGENSTAND: T8-Habich-Fragen NIE beantwortet: (a) libs/-Layout Option C+ ohne domain/-Ebene wurde OHNE Habich-Konsultation entschieden, "Habich sollte das absegnen"; (b) GPL-3-Adapter-Freigabe per User-Direktive "informationshalber"; (c) P27 hp_soft "Was fehlt aus Habich-Sicht fuer wissenschaftliche Akzeptanz?".
ORT: Arbeitsplan_Termin8.md:179-208
SOLL/FIX: Freigaben sind unbeantwortet, nicht abgelehnt -- als offene Owner-/Betreuer-Punkte fuehren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Lizenz-Flaeche (ARCHITEKT-DIREKTIVE II im NOTICE)

### [wfkyov860.json] 35
GEGENSTAND: Terminologie-Kollision "Tier": T8 nutzt "Tier-1" fuer Paper-Rang; heutiges Projekt nutzt "Tier" fuer Cache-Hierarchiestufe; T11-P4 (einzige direkte Habich-Auflage T10/T11): "Rang statt Tier" fuer Kapitel 1-3.
ORT: Arbeitsplan_Termin8 docx Abs.65 vs md:38; T11 tbl17.r6
SOLL/FIX: Manuskript Kap.1-3: Rang; Diff-Bericht ITEM[1] D4 und ITEM[2] #22 verifizieren: im Manuskript VOLLZOGEN (01_einleitung.tex:134 "Rang-1"), Code darf "Tier" behalten (Metapher Tier-Binary konform).
STATUS LT. QUELLE: behoben (Manuskript) / nur-hinweis (Code)
ABHAENGIGKEIT/FLAECHE: Achtung: Lesebericht T10/T11 nannte es "nie vollzogen" -- Diff-Berichte korrigieren das; Diff-Fassung gilt

### [wfkyov860.json] 36
GEGENSTAND: _archive_chatgpt/ in T8 traegt Etikett "war inhaltlich falsch", enthaelt aber die einzigen reproduzierten Zahlen des Termins (54 Permutationen enumerate-only; 109 generierte Dateien; Smoke rc=0/size=1/val=answer, vsize=2/at1=b) und den Befund "Compile-time ISA summary im Minimalbuild scalar-only ... muss fuer echte Messlaeufe geschaerft werden"; die dort formulierte 4-Stufen-Prioritaet wird von T9 offiziell beschlossen.
ORT: docs/termine/20260515 Termin 8/_archive_chatgpt/
SOLL/FIX: "Das Etikett ist irrefuehrend und sollte beim Gap-Abgleich nicht als Ausschlussgrund gelten."
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

### [wfkyov860.json] 37
GEGENSTAND: T8/T9-Widerspruch Include-Pfade: T8 meldet V30-Migration abgeschlossen ("9 hardcodierte Pfade aktualisiert"), T9 stellt fest, dass prt-art noch auf cache_engine/include statt libs/cache_engine/include zeigt -- T8-Vollzugsmeldung war unvollstaendig.
ORT: Arbeitsplan_Termin8.md:86 vs T9 Arbeitsergebnis Abs.49-52
SOLL/FIX: T9: "Vor weiteren Features sollte ein Integrationssprint Build-/Submodule-/Include-Pfade haerten."
STATUS LT. QUELLE: offen (Stand T9)
ABHAENGIGKEIT/FLAECHE: prt-art-Submodul

### [wfkyov860.json] 38
GEGENSTAND: T9-Achsen-Goldstandard: eine Achse verlangt 7 Pflichtbestandteile (Registry, StrategyBase, ConfigSet, Flags, Wrappers, Concept-Conformance, CMake-Integration), Referenz axis_06_allocator. Steht in keinem spaeteren Dokument vollstaendig.
ORT: T9 Arbeitsergebnis Abs.32
SOLL/FIX: jede Achsen-Abnahme gegen die 7 Punkte pruefen.
STATUS LT. QUELLE: offen im Ist (Diff C1: ConfigSet 0/28, Wrappers 0/28, axis-CMakeLists 0/28; selbst Referenzachse unvollstaendig -- Fund 76)
ABHAENGIGKEIT/FLAECHE: 28 Achsen-Verzeichnisse

### [wfkyov860.json] 39
GEGENSTAND: T9-Risikotabelle: Vendoring-Doktrin-Ursprung (FetchContent-Reproduzierbarkeitsrisiko -> "Lokale Vendor-/Third-Party-Caches oder dokumentierte Bootstrap-Schritte ergaenzen"); harte Reihenfolgeauflage "Goldstandard auf wenige Achsen anwenden, erste Messung vor Vollausbau erzwingen".
ORT: T9 Arbeitsergebnis Abs.67-84
SOLL/FIX: verbatim.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

### [wfkyov860.json] 40
GEGENSTAND: T9-Akzeptanzkriterium (haerteste Festlegung): "Ein Workload erzeugt ueber CEB ein PRT-ART-Ergebnisartefakt, das in CSV/LaTeX/TikZ/PDF landet." Reihenfolge fest: zuerst PRT-ART-E2E, dann SOTA-Wrapper. Drei Rede-Verbote (35.000+ nicht experimentreif; Original-Baselines nicht belastbar eingebunden; PRT-ART nicht fertig). Habich-Rueckfrage unbeantwortet: "Wie strikt soll der Nachweis 'Original-Implementierungen nur als Wrapper' bereits vor den ersten internen Messungen gefordert werden?"
ORT: T9 pptx Slide 7/8; Arbeitsaufstellung Abs.62-69
SOLL/FIX: verbatim.
STATUS LT. QUELLE: offen (kein PRT-ART-Artefakt existiert, Fund 66)
ABHAENGIGKEIT/FLAECHE: Messreihe A

### [wfkyov860.json] 41
GEGENSTAND: Geltende Architekturfassung ab T9 ist REV7.7, nicht REV7.6 (INDEX.md:130 nennt faelschlich 7.6; T8 kennt keine REV-Nummer).
ORT: T9 Arbeitsaufstellung Abs.18-19
SOLL/FIX: Referenzen auf REV7.6 korrigieren/relativieren.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: PROJECT_LAYER_MAPs

### [wfkyov860.json] 42
GEGENSTAND: Permutationszahl hat vier unvereinbare Werte (54 real enumeriert / 1800 deklariert / 35.000+ Modell / 5,5e9 Vollraum); T9-Regel: jede Zahlenangabe muss die Ebene mitnennen.
ORT: T8/T9 Querschnitt A
SOLL/FIX: Ebene (real enumeriert / deklariert / Modellraum / Vollraum) immer mitnennen.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Thesis-Zahlen; Ist-Zaehlstaende ebenfalls divergent (Fund 77)

### [wfkyov860.json] 43
GEGENSTAND: T10-Achsen-Delegations-Audit: 4 Fehlerklassen mit Reststatus -- Monolithische Suchorgane (erkannt+dokumentiert); getrennter Speicher im Adapter (teilweise); V1-POD ohne node-Felder (V2-POD OFFEN); NodeChunkedStore (Teilfix). Offene Restauflage: "Suchmetriken muessen ebenfalls aus demselben delegierenden Store kommen." T11 bestaetigt Rest als "Q2-Schritt-4 / Beschattung ... Apparate-Konfundierung bei node_type und memory_layout".
ORT: T10 Arbeitsergebnis [p23], [tbl24.r2-r5], slide7 p9; T11 [p21]
SOLL/FIX: gemeinsamer Store fuer Such- UND Speichermetriken; V2-POD mit node/layout/allocator-Feldern aktivieren.
STATUS LT. QUELLE: teilweise (NodeChunkedStore-Teilfix im Ist verifiziert und fortentwickelt zu _composed_store/_layout_aware_store, seg_coverage=0.999963 -- Diff E; Rest offen)
ABHAENGIGKEIT/FLAECHE: axis_03a-Suchorgane

### [wfkyov860.json] 44
GEGENSTAND: T11-Prioritaeten P0-P4 und Meilensteine M1-M5 (geltendes Arbeitspaket): P0 realer Messpfad einmal geschlossen (echte CSV/JSON/TikZ/PDF, nicht Demo/Smoke); P1/M2 PMC oder begruendetes Gate ("Die Forschungsfrage ist cache-zentriert; ohne Counter bleibt es indirekt"); P2 Kapitel 7 echte Ergebnisse; P3 Anhang B ohne TODO; P4 Rang statt Tier; M1-DoD dokumentierter Commit/Compiler/Seed; M5 DE fuehrt, EN abgeleitet.
ORT: T11 tbl17.r2-r6, tbl25.r2-r6
SOLL/FIX: verbatim; M2-Auswege: "Mindestens eine Metrikklasse L1/L2/LLC/dTLB oder ein klar dokumentiertes Gate" -- Schweigen ist keine Option.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: NullPmcSource-Gate; Funde 45, 62

### [wfkyov860.json] 45
GEGENSTAND: T11 benennt zwei Fehlerklassen namentlich, nur als Limitierung verbucht, nicht behoben: "uint16-Sekundaerorgan-Saettigung" und "intern verschlucktes OOM" (Git main @ a0d0a32). Ausserdem: untracked PDF "20260931_Diplomarbeit_...pdf" (nicht existierendes Datum 31. September) -- vor Abgabe klaeren.
ORT: T11 Arbeitsergebnis tbl4.r2-r6
SOLL/FIX: beide Fehlerklassen beheben oder als Gate dokumentieren; PDF-Artefakt klaeren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [wfkyov860.json] 46
GEGENSTAND: DIFF mess-und-plattform #6 (HOCH): Hybrid-Regel cpu_core/cpu_atom -- cpu_atom = 0 Treffer in 1265 libs-Dateien; i_platform_probe.hpp:20 cpu_core_atom_perf_separation=false; cpuid_platform_probe.hpp:38-39 "AP-13: Topologie/Pinning bleibt bewusst ungesetzt"; linux_perf_pmc_source.hpp oeffnet generische PERF_TYPE_HW_CACHE mit pid=0,cpu=-1 -- KEINE PMU-Wahl; Tests zementieren EXPECT_FALSE.
ORT: ce libs/cache_engine/builder/linux_perf_pmc_source.hpp; include/cache_engine/platform/i_platform_probe.hpp:16-21; platform_probe/cpuid_platform_probe.hpp:38-39; tests/unit/test_cpuid_probe.cpp:63; test_platform_concepts.cpp:38; Ledger G-270a "echt offenes User-Gate"
SOLL/FIX: PMU-Typ aus /sys/devices/cpu_core/type bzw. cpu_atom/type ermitteln, getrennt erheben und ausweisen; cpu_class-Erzeuger bauen.
STATUS LT. QUELLE: offen (FEHLT)
ABHAENGIGKEIT/FLAECHE: Funde 8, 32, 48, 68; G-270a User-Gate (verriegelte Plattform-Tests)

### [wfkyov860.json] 47
GEGENSTAND: DIFF #7 (HOCH): Core-Modus-Achse (Single P/Single E/All-P/All-E/Barnard) -- Pinning existiert nur ausserhalb des Mess-Treibers (thread_pinning.hpp mit ScopedThreadPin; Konsumenten nur apps/f15_compare --pin-core und Test); perm_runner.hpp 0 Treffer pin/affinity; CoreClass/ICoreLayout ohne Konsument; keine Core-Spalte in CSV.
ORT: ce libs/cache_engine/builder/measurement/thread_pinning.hpp; apps/f15_compare/main.cpp:225; platform/core_layout.hpp:14-37
SOLL/FIX: Pinning in den Mess-Treiber (perm_runner) heben; Core-Modus als Dimension ins Schema und die CSV.
STATUS LT. QUELLE: offen (FEHLT)
ABHAENGIGKEIT/FLAECHE: XSD kennt kein core_type/core_mode/pinning (Diff B1)

### [wfkyov860.json] 48
GEGENSTAND: DIFF #8+#9 (HOCH): Pflichtplattform ZIH Barnard/Slurm = 0 Treffer in beiden .gitlab-ci.yml; Messjob laeuft nur auf prod1 (AMD Zen5, nicht hybrid), tags [prod, baremetal, amd]; Hybrid-Messmaschine: i9-14900KS GESTORBEN (RMA, bis ~September blockiert), i7-1270P am 2026-06-15 von Messwerten ausgeschlossen; ABER prod2 ist heute i9-12900K Alder-Lake-S = Hybrid (8P+8E) mit gruenem pmc:intel-Beweis (Pipeline 12757) auf Runner-Tag [baremetal, intel] -- es fehlt nur ein Mess-Job, der ihn adressiert.
ORT: super .gitlab-ci.yml:718/:805; ce .gitlab-ci.yml:144; machine_identity.hpp:191; Ledger :871-877
SOLL/FIX: "eine zweite Lane auf [baremetal, intel] plus PMU-getrennte Counter-Oeffnung in linux_perf_pmc_source.hpp wuerde Position 6, 7 und 9 zugleich adressieren" (billigster Hebel im ganzen Diff).
STATUS LT. QUELLE: offen (FEHLT, mit ungenutzter Maschine)
ABHAENGIGKEIT/FLAECHE: Funde 46, 47; CI-Jobdefinitionen

### [wfkyov860.json] 49
GEGENSTAND: DIFF #1 (KRITISCH): Kein echter Messlauf -- einziger persistierter Lauf 20260726-164259-d03-strukt-r-erstbeleg (16 Datenzeilen, build_version=m3v2-smoke); Ledger: golden-320-Lauf #9916 nie persistiert, golden-320 KEIN legitimer Systembeweis; nur new-golden (N=131072 VOLL) beweist das System; Voll-Lauf #46 wird neu aufgesetzt.
ORT: measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv; Ledger :69
SOLL/FIX: T11 P0/M1: echter Plattformlauf mit CSV/JSON/TikZ/PDF.
STATUS LT. QUELLE: offen (FEHLT)
ABHAENGIGKEIT/FLAECHE: Voll-Lauf #46; Fund 65 (L1-Plausibilitaet VOR Voll-Lauf klaeren)

### [wfkyov860.json] 50
GEGENSTAND: DIFF #10 (HOCH): Wiederholungen -- Plan sagt 5 (T3/T4/T6 dreimal uebereinstimmend), Owner-Entscheid E3 vom 16.07. setzt 3 als Pflicht (Ledger :534), alle Thesis-Profile count="3" (Smoke count="1"), Ist-Beleg repetition ausschliesslich 0 = faktisch 1 Lauf.
ORT: algorithm_profiles/thesis_profiles/*.xml; Ledger :534
SOLL/FIX: Abweichung 5->3 ist bewusst+dokumentiert, MUSS aber im Methodikkapitel als Abweichung benannt werden; Ist-Beleg unterschreitet auch die 3.
STATUS LT. QUELLE: abgewichen + real unerfuellt
ABHAENGIGKEIT/FLAECHE: Owner-Entscheid E3 vs Plan-Primaerquelle

### [wfkyov860.json] 51
GEGENSTAND: DIFF #11 (HOCH): Reproduzierbarkeits-Stempel am Artefakt -- Mess-Ordner hat kein Sidecar/Manifest; CSV-Spalten seed/commit/compiler/isa/simd/opt_level = je 0; einzige Provenienz build_version=m3v2-smoke + platform; Stempel-Mechanik existiert code-seitig ungenutzt (toolchain_stamp_glied.hpp, ceb_version_stamp.hpp; Seed nur im Resume-Stamp).
ORT: measurement/...-erstbeleg/; include/cache_engine/abi/toolchain_stamp_glied.hpp; builder/ceb_version_stamp.hpp
SOLL/FIX: T11 M1-DoD Commit/Compiler/Seed in jedes Ergebnisartefakt.
STATUS LT. QUELLE: teilweise (Mechanik da, Artefakt traegt sie nicht)
ABHAENGIGKEIT/FLAECHE: CSV-Schema-Erweiterung

### [wfkyov860.json] 52
GEGENSTAND: DIFF #2 (KRITISCH): Pflicht-Datensaetze im Messpfad -- Akten liegen (5/6 mit echter Pruefsumme; xml-Akte honest-0/size_bytes 0), aber Messpfad konsumiert sie nicht; gemessene Schluessel sind rng() & 0xFF (8-Bit-Wertraum) in abi_adapter.hpp:636/649 und v2-Pfad :910/:924; Loader-MESS-Konsum ist "dokumentierter offener Folge-Schritt" (xml_config_parser.hpp:178-181, profile_runner.hpp:188-190); Golden fuehrt nur 2-3 Akten (url, sosd_books_200M bzw. +english_words).
ORT: libs/common/serialization/xml_config_parser/xml_config_parser.hpp:178-181; libs/cache_engine/anatomy/abi_adapter.hpp:636/649/910/924; all_axes_golden.profile.xml:120-123; Code/test_data_xml/experiment_golden_kern.xml
SOLL/FIX: load_or_generate_ycsb im Workload-Pfad an die Akten binden; die 3 fehlenden Pflichtdatensaetze ins Golden aufnehmen (Akten fertig, reine Deklaration).
STATUS LT. QUELLE: offen (FEHLT: Akten da, Konsum nicht)
ABHAENGIGKEIT/FLAECHE: H2/T4 datensatzabhaengige Aussagen unbelegbar; INC-G5 lauf-gated

### [wfkyov860.json] 53
GEGENSTAND: DIFF #3 (KRITISCH): CLU + Memory Footprint als Erfolgs-Metrik -- CSV-Header (173 Spalten) ohne CLU/Footprint/Advisor-Spalte; CLU nur als H1_clu_improvement-Feld ohne Produzent; MeasurementCategory::CLU deklariert, <measurement_categories> wird nur namensvalidiert, nie projiziert.
ORT: builder/commands/execution_result.hpp:34; result_aggregator.hpp:94; profile_facade/validate_profile.hpp:349-362
SOLL/FIX: CLU/Footprint-Spalten erzeugen; strukturelles CLU-Surrogat existiert (observable_tier.hpp:82 CLU=field_bytes/(cache_lines*line_bytes)) -- ableitbar, aber nicht ausgewiesen.
STATUS LT. QUELLE: offen (FEHLT)
ABHAENGIGKEIT/FLAECHE: T4-H1/T6-Erfolgs-UND

### [wfkyov860.json] 54
GEGENSTAND: DIFF #4 (KRITISCH): 3 Verifikationsmodi / 5 Ablationsstufen -- Enum CacheEngineMode {BASELINE_NO_ENGINE, HEURISTIC_STATIC, INFORMED_KALIBRIERT, AUTOMATIC_ADAPTIVE} vorhanden+getestet, aber KEINE Mess-Dimension: nicht in kCompositionAxisNames, keine CSV-Modus-Spalte, in 0 XML-Dateien, XSD kennt kein Modus-Element; ablation/engine_off = 0 Treffer.
ORT: include/cache_engine/concepts/cache_engine_mode.hpp:9-32; abi/processing_strategy.hpp:16 (Default HEURISTIC_STATIC)
SOLL/FIX: CacheEngineMode als Mess-Dimension mit BASELINE_NO_ENGINE verdrahten -- ohne Off-Stufe kein Kausalnachweis fuer FF0.
STATUS LT. QUELLE: teilweise (Typ ja, Messachse nein)
ABHAENGIGKEIT/FLAECHE: FF0/H1-Kausalnachweis

### [wfkyov860.json] 55
GEGENSTAND: DIFF #5+#12 (KRITISCH/HOCH): PMC-Luecken -- im einzigen Messbeleg pmc_cache_misses_l2=0 UND l3=0 in ALLEN 16 Zeilen, energy=0, trotz pmc_available=1 (L1+dTLB real); Header-Selbstaussage linux_perf_pmc_source.hpp:10-16: l2+coherence bleiben AUCH MIT Flag 0, "branch_misses wird von KEINER PMC-Quelle befuellt (offener Posten M-3a)"; cycles/instructions existieren nicht mal als Feld; IPC/BRANCH_MISS deklariert ohne Quelle/Spalte.
ORT: libs/cache_engine/builder/linux_perf_pmc_source.hpp:10-16/211-215; include/cache_engine/measurement/pmc_source.hpp:19-27
SOLL/FIX: LLC/L2/branch/cycles/instructions-Quellen nachziehen oder als Gate dokumentieren (T11 M2); L3=0 trotz geoeffnetem LL-Zaehler klaeren.
STATUS LT. QUELLE: teilweise (L1+dTLB echt; Rest honest-0/fehlt); M-3a offen
ABHAENGIGKEIT/FLAECHE: Fund 65 (Plausibilitaet), Fund 44 (M2)

### [wfkyov860.json] 56
GEGENSTAND: DIFF #13+#21 (HOCH/MITTEL): ISA-Pfade -- Toolchain kann avx512/sve2 (cmake/isa_features.cmake), aber golden-Matrix schliesst AVX-512 aus ("avx512 ist nicht universell und bleibt draussen") obwohl prod1 amd_zen5_avx512 registriert; ARM build:arm64-smoke allow_failure:true + rules-gated; axis_09_isa ist Architektur (amd64/aarch64/riscv/powerpc), nicht ISA-Pfad.
ORT: Code/test_data_xml/experiment_golden_kern.xml system_axes; cmake/isa_features.cmake:31-147; ce .gitlab-ci.yml:163-170
SOLL/FIX: AVX-512-Zweig (mind. auf prod1) in Mess-Deklaration aufnehmen oder Abweichung dokumentieren.
STATUS LT. QUELLE: abgewichen
ABHAENGIGKEIT/FLAECHE: FF4-Belegbarkeit

### [wfkyov860.json] 57
GEGENSTAND: DIFF ITEM[1] B4 (HOCH): 12 Sub-Engines C01-C12 = 12 Interfaces, 0 Implementierungen (alle I*Engine-Ableitungen = 0; c02 sogar ohne CMakeLists); Verhalten liegt teils unter anderem Namen in axes/* (prefetch/migration/allocator/telemetry/filter); OHNE Gegenstueck: C02 Pinning, C04 Coherence, C10 Topologie. ICpuCore/ICoreLayout/IPinningPolicy/ICoreToThreadMap 0 Implementierungen, Tests pruefen nur is_abstract_v.
ORT: libs/cache_engine/subsystems/c01..c12; platform/core_layout.hpp; tests/unit/test_platform_concepts.cpp:94-95
SOLL/FIX: C02/C04/C10 implementieren oder Architektur-Mapping dokumentieren.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Fund 28 (T7-Audit), K3.2 measure_pinning_effects

### [wfkyov860.json] 58
GEGENSTAND: DIFF ITEM[1] A3 / ITEM[2] #3 (KRITISCH): Prefix-Operationen existieren nirgends im Mess-/API-Pfad -- OperationKind {Read, Update, Insert, Scan, ReadModifyWrite, Erase} ohne Prefix; PrefixScan genau 1 unbenutzter Enum-Wert (request_context.hpp:12); OP-Kanon OP-1..OP-6 ohne Prefix/Exact-Miss; Golden nutzt nur OP-1+OP-3.
ORT: libs/test_infra/workload_generator/workload_generator.hpp:37-44; include/cache_engine/concepts/request_context.hpp:12; docs/datasets/OP_1_to_6_SPECIFICATIONS.md; experiment_golden_kern.xml:437
SOLL/FIX: Prefix-Lookup/-Enumeration in WorkloadGenerator + OperationKind + Mess-POD ergaenzen -- ohne sie beantwortet kein Lauf die woertliche FF3.
STATUS LT. QUELLE: offen (FEHLT)
ABHAENGIGKEIT/FLAECHE: T1-H3/FF3 Dominanzanspruch nicht messbar

### [wfkyov860.json] 59
GEGENSTAND: DIFF ITEM[1] A4 + C10 (KRITISCH/MITTEL): Alle SOTA-Adapter default OFF (COMDARE_HAVE_<X> OFF; Stub wirft) -- im Default-Build laeuft kein Original-Baseline-Code; Migration-Achse: adaptive/tier_based (eigentliches Online-Umlagern) nicht in Messmenge (nur none+hot_cold im Golden; stat_migration_policy_migrations=0 in 16/16).
ORT: adapters/P01..P30/CMakeLists.txt; ext/CMakeLists.txt:51-215; experiment_golden_kern.xml allowed_variants
SOLL/FIX: ext-Aktivierung pro Adapter (Original-Compiler-Setup) -- laut T8 explizit Cluster-Aufgabe; migration adaptive/tier_based in Messmenge.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: T4 P71 (Fund 15), F-EXTRA-8-Prozess (Fund 25)

### [wfkyov860.json] 60
GEGENSTAND: DIFF #14/#16/#20 (MITTEL): Perzentile/Speicherbilanz -- CSV je Op nur p50+p99, KEIN p95 (nur Trace-JSON-Nebenkanal), p999 opt-in inaktiv, kein throughput-Feld (nur ns_per_op); HDR-Wrapper vendored+getestet aber ohne Konsument; Speicherbilanz ohne bytes_per_key, ohne getrennte Poolgroessen, ohne Fragmentierung/Konsolidierungskosten.
ORT: CSV-Schema (173 Spalten); builder/anatomy_commands/tier_observe_trace_abi.hpp:308-314; libs/common/measurement/hdr_histogram_wrapper/
SOLL/FIX: p95-Spalte + HDR-Konsum + Bytes/Key-Normierung nachziehen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: T1 [P0122]/[P0125]

### [wfkyov860.json] 61
GEGENSTAND: DIFF #15 (MITTEL): Mess-Record/CSV ohne cpu_class/telemetry_strategy/sampling_n-Spalten (0 von 173); auch phase/engine fehlen (Owner-E1 forderte sie zusaetzlich, Ledger :534).
ORT: measurements.csv Header; 07_er_model.md CSV-Schema
SOLL/FIX: Spalten ergaenzen; Erzeuger fuer cpu_class ist Fund 46.
STATUS LT. QUELLE: offen (FEHLT)
ABHAENGIGKEIT/FLAECHE: Funde 32, 46

### [wfkyov860.json] 62
GEGENSTAND: DIFF #16-fairness (MITTEL): fairness_mode existiert (CSV Sp.172), Wert in 16/16 = "-"; nur Beispielprofil wdk_fairness_example nutzt es; produktive Profile (m3v2_sota_pilot, all_axes_golden, m3v2_study) tragen kein fairness=-Attribut; sota_catalog.hpp:453-457: "REINE Reihen-Metadaten ... Kompositions-Pinnung des common_denominator-Falls ist DATEN-gated (#156/#162-Fenster)".
ORT: profile_facade/profile_run_entry.hpp:567-621; thesis_profiles/wdk_fairness_example.profile.xml:77-78; sota_catalog.hpp:453-457
SOLL/FIX: fairness= in die produktiven Profile eintragen (Mechanik existiert; reine Deklaration).
STATUS LT. QUELLE: teilweise (Baustein erfuellt, Anwendung fehlt)
ABHAENGIGKEIT/FLAECHE: T3 [p069]; #156/#162-Fenster

### [wfkyov860.json] 63
GEGENSTAND: DIFF #17 mess-und-plattform (ERFUELLT, nicht doppelt bauen): EINE vereinte CEB ueber {wallclock, macro, micro} -- experiment_golden_kern.xml <measurement_tooling><combo tools="wallclock macro micro"/> mit Regressions-Vermerk (F-3-Regression), am 2026-08-06 nachgezogen. Ebenso ERFUELLT: Wiederholungs-Mechanik separat/nie aggregiert (repetition_plan.hpp), YCSB A-F vollstaendig, T2-Seitentypfamilie 5/6, ValueHandle inline/external/chain_ref, Flag-System 10 Baenke, 32-Byte-POD, Anatomy/ABI-Saeule, Welch-Test, LinuxPerfPmcSource real (T11-NullPmcSource-Aussage ueberholt), Datensatz-Akten 9 Pflichtfelder FNV-1a-64, NodeChunkedStore-Teilfix, MessreihenMode defined/full/full_sampled.
ORT: siehe Diff ITEM[0] #17/#18/#19 + ITEM[1] Abschnitt E
SOLL/FIX: als ERFUELLT registrieren, damit nichts doppelt gebaut wird.
STATUS LT. QUELLE: behoben/erfuellt
ABHAENGIGKEIT/FLAECHE: -

### [wfkyov860.json] 64
GEGENSTAND: DIFF ITEM[1] A1 / ITEM[2] #1 (KRITISCH): In KEINEM Messartefakt existiert eine PRT-ART- oder SOTA-Zeile -- alle 16 Datenzeilen sind CE-Achsen-Permutationen, pruefling_type="-" in 16/16; Kapitel-7-Ergebnisse leer ("Die Messdaten dieser Dimension stehen aus", 05_evaluation.tex:175/182-186); Anhangs-Tabellen mtime 06.07. (Juni-Smoke 43 Permutationen).
ORT: measurements.csv; thesis/diplomarbeit/kapitel/de/05_evaluation.tex:175-186
SOLL/FIX: Messreihe A (PRT-ART vs SOTA) real fahren; T9-Akzeptanzkriterium.
STATUS LT. QUELLE: offen (FEHLT)
ABHAENGIGKEIT/FLAECHE: Funde 40, 49

### [wfkyov860.json] 65
GEGENSTAND: DIFF ITEM[2] #9 (HOCH): Plausibilitaet der einzigen realen PMC-Daten ungeklaert -- Zeile 9: total_ns=46.015.934 bei pmc_cache_misses_l1=1.169.857.296 => >6 L1D-Misses pro Zyklus (physikalisch unmoeglich); Zeile 2 ~1,7/Zyklus; zugleich l3=0 in allen Zeilen trotz geoeffnetem LL-Zaehler.
ORT: measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv Zeile 2/9; linux_perf_pmc_source.hpp:213-214
SOLL/FIX: "die L1-Zaehler-Plausibilitaet klaeren, BEVOR ein mehrtaegiger Voll-Lauf 131.072 Permutationen mit demselben Zaehler schreibt."
STATUS LT. QUELLE: offen (Mess-Validitaet ungeklaert)
ABHAENGIGKEIT/FLAECHE: Voll-Lauf #46

### [wfkyov860.json] 66
GEGENSTAND: DIFF ITEM[2] #6 (ABGABE-KRITISCH): PRT-ART als Pruefling -- prt_art tier verweist auf ../sota/art.profile.xml; prt_art_reference.hpp = "identisch zu ArtComposition ABER mit REDIRECT-Organ in path_compression" => Pruefling und ART unterscheiden sich in genau 1 von 18 Achsen; realer PRT-ART-Code (redirect_node.hpp, bplus_node.hpp, pool_set.hpp, value_handle/*, multi_level_layout.hpp) wird von keiner ce-Datei inkludiert (einziger Include-Ort testweise aus); Map-Pfad weiter std::map; Codegen-Template quarantaeniert "ALT-PFAD -- NICHT Teil des Mess-Pfads".
ORT: ce compositions/prt_art_reference.hpp:5-11; profile_facade/sota_catalog.hpp:262-265; prt-art prt_art/include/prt_art/identity/prt_art_search_engine.hpp:383; prt_art/codegen/templates/prtart_body.hpp.template:14-18
SOLL/FIX: T10-Restauflage: Map-Pfad durch echte Trie-/Redirect-/Page-Struktur ersetzen; profile_ref wird geparst aber nirgends dereferenziert (irrefuehrende, wirkungslose Deklaration -- Diff D3).
STATUS LT. QUELLE: abgewichen / offen
ABHAENGIGKEIT/FLAECHE: FF3 misst nicht den entworfenen Pruefling

### [wfkyov860.json] 67
GEGENSTAND: DIFF ITEM[2] #5 (ABGABE-KRITISCH): page_type ist build-only System-Achse, binary_id-orthogonal -- permutiert NICHT (keine page_type-Spalte, kein seg_page_type_ns); Anhang-Limitierung 2: "Nur 4 Achsen variieren (search_algo, node_type, memory_layout, prefetch)".
ORT: builder/experiment_tree/registry_to_axis_levels.hpp:7/:144; TH anhang le_limitierung.tex
SOLL/FIX: "page_type von build-only in die permutierende Achsenmenge heben -- das allein entsperrt Thesis-H1 UND T4-H2 zur Haelfte."
STATUS LT. QUELLE: abgewichen
ABHAENGIGKEIT/FLAECHE: Thesis-H1, T4-H2

### [wfkyov860.json] 68
GEGENSTAND: DIFF ITEM[2] #2 (ABGABE-KRITISCH): FF0-Plattformterm Hybrid+Sapphire -- Messung nur auf einem AMD-Runner; kein cpu_class-Feld; hybrid_core_pinning/ = .gitkeep + "Skelett (Phase 4.B) -- keine Implementation"; Ledger :292: FF0 "OWNER FEHLT explizit".
ORT: super .gitlab-ci.yml:719/:806; ce libs/common/platform/hybrid_core_pinning/
SOLL/FIX: pmc:intel/prod2 fuer EINEN Lauf oeffnen + cpu_class in die CSV -- "der einzige Weg, den Plattform-Term der Forschungsfrage ueberhaupt zu beruehren".
STATUS LT. QUELLE: offen (FEHLT)
ABHAENGIGKEIT/FLAECHE: Funde 46-48

### [wfkyov860.json] 69
GEGENSTAND: DIFF ITEM[2] #8 (HOCH): Branch-Kosten als Beleggroesse (Expose P0016, FF3) -- keine Branch-Spalte, keine Quelle (M-3a); BRANCH_MISS im golden deklariert mit Vermerk "CSV-Record-Spalten separat (B17, Record-Erweiterung nachgelagert)".
ORT: linux_perf_pmc_source.hpp:16; golden-Profil
SOLL/FIX: B17-Record-Erweiterung + Quelle.
STATUS LT. QUELLE: offen (FEHLT); offene Posten M-3a + B17
ABHAENGIGKEIT/FLAECHE: FF3

### [wfkyov860.json] 70
GEGENSTAND: DIFF ITEM[2] #11 (HOCH): 8 Rang-1-SOTA -- sota_catalog.hpp:272 baut nur 6 (art/hot/wormhole/surf/masstree/start, "Wir nehmen die ersten 6 (CE-Reimpl)"); CoCo-Trie und B2-Baum fehlen als Lebewesen obwohl Profile existieren; Ledger DoD-4 (#162 >=8) damit nicht erfuellbar.
ORT: ce profile_facade/sota_catalog.hpp:266-272; sota/coco_trie.profile.xml, sota/b2tree.profile.xml
SOLL/FIX: CoCo-Trie + B2-Baum als Kompositionen nachziehen.
STATUS LT. QUELLE: teilweise (6/8)
ABHAENGIGKEIT/FLAECHE: Ledger DoD-4/#162; Thesis FF3-Nennung "acht Rang-1"

### [wfkyov860.json] 71
GEGENSTAND: DIFF ITEM[2] #12 (HOCH, bewusst abgewichen): Baselines nicht als Original-Wrapper gemessen, sondern CE-Reimpl-Rekompositionen; Thesis rahmt via FF1 um ("aus Originalcode bias-frei als Profil-Konfigurationen rekonstruierbar"); T9-Rueckfrage an Habich dazu unbeantwortet.
ORT: adapters/P01-ART/p01_art_adapter.hpp:7-9; sota_catalog.hpp:266; TH 01_einleitung.tex:98-101
SOLL/FIX: Abweichung ist dokumentiert; Habich-Klaerung offen.
STATUS LT. QUELLE: abgewichen (bewusst, dokumentiert)
ABHAENGIGKEIT/FLAECHE: T3 [p043], T6-SF Nichtziel, Fund 40

### [wfkyov860.json] 72
GEGENSTAND: DIFF ITEM[2] #14 (HOCH): H1/H2/H3-Auswertungsfelder ohne Erzeuger -- execution_result.hpp:34-36 deklariert H1_clu_improvement/H2_layout_score/H3_inline_external_ratio; einziger Setzer ist ein Unit-Test; h1_clu_validated() prueft dauerhaft gegen 0.0 und liefert false.
ORT: builder/commands/execution_result.hpp:34-36; compare_engine_command.hpp:51-56; result_aggregator.hpp:94-127; tests/test_commands.cpp:92
SOLL/FIX: Produzenten bauen.
STATUS LT. QUELLE: offen (FEHLT)
ABHAENGIGKEIT/FLAECHE: CompareEngineCommand-Vertrag

### [wfkyov860.json] 73
GEGENSTAND: DIFF ITEM[2] #13+#18 (HOCH/MITTEL): T4-H4 nicht entscheidbar (Affinity fehlt vollstaendig, Seitentyp fehlt als Achse, Prefetch pseudo -- Limitierung 9: "Key-Werte als Pseudo-Adressen ... kein echter Speicher-Prefetch", darf nicht als echter Prefetch verkauft werden = T11 [p20], unveraendert in axis_07_prefetch_path_oriented_impl.hpp:11-15); Inline-vs-Handle nur 1 globaler Achsenwert je Binary statt Parametrierung pro Seitentyp/Node-Familie (T4 doc:P60); Kostenmodell liegt im nicht-gemessenen Pruefling.
ORT: libs/cache_engine/axes/prefetch_axis/axis_07_prefetch_path_oriented_impl.hpp:11-15; PA prt_art/include/prt_art/value_handle/cost_model.hpp
SOLL/FIX: Vorbehalt muss in Kap.7 stehen bleiben; per-Seitentyp-Parametrierung offen.
STATUS LT. QUELLE: teilweise / offen
ABHAENGIGKEIT/FLAECHE: Funde 67, 47

### [wfkyov860.json] 74
GEGENSTAND: DIFF ITEM[2] #20 (MITTEL): Thesis-H2 Qualitaets-Audit -- Manuskript beschreibt 7 Bewertungs-Achsen Skala 1-5 in docs/quality_audit; implementiert ist EINE Zahl (gewichtete cppcheck-Befunddichte pro kLOC, sota_h2_scores.xml); docs/quality_audit existiert nicht; prt_art score="n/a"; CSV h2_code_quality_score="-" in 16/16.
ORT: ce algorithm_profiles/sota/sota_h2_scores.xml; TH 05_evaluation.tex:13-18
SOLL/FIX: Manuskript und Code angleichen (eine Seite muss sich bewegen).
STATUS LT. QUELLE: abgewichen
ABHAENGIGKEIT/FLAECHE: T7-H2 (BAUSTEIN_BEWERTUNG.md + Habich-Sign-Off) ebenfalls nicht in dieser Form umgesetzt

### [wfkyov860.json] 75
GEGENSTAND: DIFF ITEM[1] B7 (HOCH): Messreihe B ist im eigenen Kommentar als Duplikat von A_full deklariert ("Im aktuellen Skelett identisch zu A_full"); messreihen.xml (72 Z.) traegt keine einzige Achsen-/Datensatz-/ISA-/Wiederholungs-Dimension, nur <mode> und <profile>-Listen.
ORT: Code/experiment_config/messreihen.xml, <messreihe id="B_CacheEngine_Perms">
SOLL/FIX: Messreihe B als echte CE-Permutations-Reihe auspraegen (cache_engine_permutations.xml-Achsen einbeziehen).
STATUS LT. QUELLE: abgewichen
ABHAENGIGKEIT/FLAECHE: T10/T11 Pflichtmessreihen A/B/C

### [wfkyov860.json] 76
GEGENSTAND: DIFF ITEM[1] C1 (MITTEL): Achsen-Goldstandard-Erfuellung ueber 28 Achsen: Registry 28/28, StrategyBase 23/28 (fehlt axis_03a/03b/03m, axis_growth, axis_persistence_target, axis_q1), Concepts 26/28, ConfigSet 0/28, Flags 8/28, Wrappers 0/28, axis-lokale CMakeLists 0/28; selbst Referenzachse axis_06_allocator ohne ConfigSet/Flags/Wrapper.
ORT: libs/cache_engine/topics/ (28 axis_*-Verzeichnisse)
SOLL/FIX: Goldstandard-Bestandteile nachziehen oder Goldstandard-Definition revidieren.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Fund 38

### [wfkyov860.json] 77
GEGENSTAND: DIFF ITEM[1] C2 + ITEM[2] #23 (MITTEL/NIEDRIG): Achsen-Zaehlstaende unvereinbar -- Ist: topics/ = 17 Themen-Ordner/28 axis_*-Verz./424 hpp; golden permutiert 18; permutation_axes.xml deklariert 11; T9 sagte 22/324; T11 sagte 19+3; DE-Text "achtzehn" korrekt, EN-Kapitel noch "neunzehn" (stale, Dateikoepfe vermerken Divergenz selbst).
ORT: libs/cache_engine/topics/; algorithm_profiles/permutation_axes.xml; TH kapitel en 01_introduction.tex:111 u.a.
SOLL/FIX: jede Zahlenangabe in der Thesis braucht die Ebene dazu; EN aus DE synchronisieren (M5).
STATUS LT. QUELLE: abgewichen (EN stale)
ABHAENGIGKEIT/FLAECHE: M5

### [wfkyov860.json] 78
GEGENSTAND: DIFF ITEM[1] B3 / ITEM[2] #10 (HOCH): Ordnungsmodus existiert als Achse ueberhaupt nicht (OrderingMode/ordering_mode/LocallySorted/sort_policy/axis_ordering = 0; index_organization ist eine andere Frage) -- T1-H4 gar nicht, T4-H2 nicht pruefbar.
ORT: ce axis_path_serialization.hpp:39-42 (18 Achsen ohne Ordnung)
SOLL/FIX: Ordnungsmodus-Achse (unsortiert/lokal/lexikographisch) einfuehren oder Hypothesen-Scope in Thesis begruendet einschraenken.
STATUS LT. QUELLE: offen (FEHLT)
ABHAENGIGKEIT/FLAECHE: Funde 16, 82

### [wfkyov860.json] 79
GEGENSTAND: DIFF ITEM[1] C3 (MITTEL): Seitentyp 6: statt B2-Decision/Span-Seite existiert _bplus (Masstree-Familie); b2tree/decision_page/span_page = 0 in topics/.
ORT: topics/nodes/axis_01_page_type/
SOLL/FIX: Decision-/Span-Page (P2) nachziehen oder Abweichung dokumentieren.
STATUS LT. QUELLE: teilweise/umbenannt-anders
ABHAENGIGKEIT/FLAECHE: T4 Seitentabelle

### [wfkyov860.json] 80
GEGENSTAND: DIFF ITEM[1] C4+C5 (MITTEL): Advisor-Anbindung = leerer Ordner (advisor_wrapper/, perf_wrapper/, papi_wrapper/, platform_probe/, run_recorder/ je nur CMakeLists "Skelett Phase 4.B"); Diplomarbeit-Treiber-CSV-Pfad (binary_to_csv.cpp 16 Spalten) ohne Perzentile/repetition/dataset/isa/cpu_class, gespeist von measurement_writer.hpp:92-107 mit 12 von 13 Feldern honest-0.
ORT: libs/common/measurement/advisor_wrapper/; Code/03_binary_to_csv/binary_to_csv.cpp:56-58; Code/02_messung_driver/measurement_writer.hpp:92-107
SOLL/FIX: Entweder Advisor-Ersatz (strukturelles CLU) offiziell machen oder Wrapper fuellen; Treiber-Pfad-Schema angleichen.
STATUS LT. QUELLE: abgewichen/teilweise
ABHAENGIGKEIT/FLAECHE: Funde 53, 60

### [wfkyov860.json] 81
GEGENSTAND: DIFF ITEM[1] D1+D2 (NIEDRIG): libs/search_engine/ = 8 leere Skelett-Ordner (Inhalt lebt in cache_engine/topics|axes) -- Auditor zaehlt Luft; hardware_filter.hpp num_p_cores/num_e_cores deklariert, nie gesetzt/gelesen (tote Deklaration, Symptom von A2).
ORT: libs/search_engine/; Code/02_messung_driver/hardware_filter.hpp:40-41
SOLL/FIX: Skelette entfernen/fuellen bzw. Namensdrift dokumentieren.
STATUS LT. QUELLE: abgewichen/tote Deklaration
ABHAENGIGKEIT/FLAECHE: -

### [wfkyov860.json] 82
GEGENSTAND: DIFF ITEM[1] F (Ledger-Luecken): Ledger kennt die Hybrid-Regel nur als Hardware-Erkennung (#270a CPUID 0x1A, User-Sichtung), NICHT als Mess-/Auswertungsregel; im Ledger NICHT getrackt: Ordnungsmodi (0 Treffer), Common-Denominator (0), Policy-Ablation (0), Relocation (0), Prefix-Lookup (0), prt_art->art.profile.xml-Pointer (0). Nenner 6735 Zeilen, Positivkontrollen CLU=270, Adapter=141.
ORT: docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md
SOLL/FIX: diese Posten in den Ledger aufnehmen (Auswertungspflicht cpu_core/cpu_atom als eigener Punkt).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Ledger-Pflege

### [wfkyov860.json] 83
GEGENSTAND: docs/termine/INDEX.md endet bei Termin 8 (Stand 2026-05-15, 174 Z.) -- T9/T10/T11 fehlen; als "Pflicht-Pre-Read" deklarierter Wegweiser erzeugt mechanisch die geruegte Gedaechtnisluecke. Ausserdem INDEX-Zeile REV7.6 stale (REV7.7 gilt).
ORT: docs/termine/INDEX.md:14-21, 130, 141-149
SOLL/FIX: INDEX um T9-T11 ergaenzen, REV-Angabe korrigieren (im Lese-Workflow READ-ONLY nicht korrigiert).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [wfkyov860.json] 84
GEGENSTAND: DIFF ITEM[2] Widersprueche (3): (1) Ledger :68 "PMC honest-0 bis #26" UND Anhang-Limitierung 1 "NullPmcSource available=false" -- beide von der persistierten CSV widerlegt (pmc_available=1, L1+dTLB echt); Anhang 20 Tage stale. (2) Thesis 05_evaluation.tex:33-37 behauptet reale String-Datensaetze als Datengrundlage -- Code hat keinen Dataset-Konsument. (3) Ledger DoD-4 #162 >=8 SOTA vs Code baut 6.
ORT: Ledger :68/:36; TH 05_evaluation.tex:33-37; anhang le_limitierung.tex
SOLL/FIX: Ledger+Anhang+Thesis an Objektstand angleichen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Funde 52, 55, 70

### [wfkyov860.json] 85
GEGENSTAND: Hypothesen-Datengrundlage heute (Diff ITEM[2]): T4-H1 KEINE (Kontrast fehlt); T4-H2 KEINE (alle 4 Bedingungsvariablen fehlen/konstant -- am vollstaendigsten unbelegte Hypothese); Thesis-H1 KEINE; T1-H1 TEILWEISE (L1+dTLB, aber Plausibilitaet + Branch fehlt); T1-H3/FF3 KEINE fuer Prefix; T1-H4 KEINE; T4-H3 SCHWACH; T4-H4 KEINE; FF1 TRAGFAEHIG (einzige belegbare FF; 18 Achsen, golden N=2^17 mit CRC64-Anker); FF2 TEILWEISE; FF4 TEILWEISE.
ORT: Diff ITEM[2] Hypothesen-Tabelle
SOLL/FIX: kuerzester Weg zur Tragfaehigkeit: (a) page_type permutierend; (b) Prefix-Ops; (c) CacheEngineMode-Messdimension mit BASELINE_NO_ENGINE; (d) pmc:intel/prod2-Lauf + cpu_class-Spalte; (e) L1-Plausibilitaet VOR Voll-Lauf.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: buendelt Funde 52-58, 64-68

---

# DATEI 2: w9cqubpi0.json -- "20-seitiges Session-Dossier: alle Regressionen des 06.08. mit reichem Kontext, als abzuarbeitendes Checkheft"
Dossier-Datei lt. Quelle: docs/sessions/20260806-DOSSIER-regressionen-checkheft.md (1590 Z., NICHT committet zum Erhebungszeitpunkt).
Bilanz lt. Quelle: 25 Befunde (9 erledigt / 7 teilweise / 9 offen), 10 Regeln (7 im Werkzeug, 3 Disziplin), 8 Entlastungen, 2 UNBELEGT, 28 offene Handlungsposten (4 Sofort + 7 T1 + 5 T2 + 6 T3 + 6 T4).

### [w9cqubpi0.json] 1
GEGENSTAND: Owner-Klarstellung (bindend): Endtermin 15.09.2026, woechentliche Lieferung jeden Freitag; 08.08. war Zwischenziel. Alle Dringlichkeits-/"nach der Abgabe"-Urteile der Session sind zu relativieren; vertagt -> terminiert.
ORT: Dossier Kapitel I/II/III/IV/V.0 (mehrfach)
SOLL/FIX: "aus 'unrealistisch' wird 'nicht in dieser Woche'; aus 'nach der Abgabe' wird 'in einem der sechs verbleibenden Freitags-Pakete'."
STATUS LT. QUELLE: nur-hinweis (bindende Lage-Korrektur)
ABHAENGIGKEIT/FLAECHE: betrifft alle T3/T4-Einstufungen

### [w9cqubpi0.json] 2
GEGENSTAND: Regel 1 (Keine Null ohne Nenner): im ce geheilt via scripts/ci_diff_ascii_width_guard.sh; der super hat KEINE Kopie dieser Wache (find ausserhalb external/ = 0 Treffer); super-Pakete wurden mit Skript aus dem fremden Repo geprueft.
ORT: ce scripts/ci_diff_ascii_width_guard.sh; super (fehlend)
SOLL/FIX: Wache in den super spiegeln oder zentral ziehen.
STATUS LT. QUELLE: teilweise (ce geheilt, super offen)
ABHAENGIGKEIT/FLAECHE: Regel 7 (Gate-Umfang repo-spezifisch: ce 1733 vs super 59 Dateien, ~29:1)

### [w9cqubpi0.json] 3
GEGENSTAND: Regel 2 (Pruefbereich = merge-base): CI-Verdrahtung ist noch nicht merge-base-basiert -- ce .gitlab-ci.yml:259-268 waehlt CI_MERGE_REQUEST_DIFF_BASE_SHA, sonst CI_COMMIT_BEFORE_SHA, sonst HEAD~1; ein Push mehrerer Commits prueft nur den letzten Push.
ORT: ce .gitlab-ci.yml:259-268
SOLL/FIX: merge-base-basierte Bereichswahl in der CI.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: B14-Fall reproduziert (enger Bereich verbirgt 61% der Aenderung); b14-super-Zahlen 667/1385 UNBELEGT (Struktur 49% bestaetigt)

### [w9cqubpi0.json] 4
GEGENSTAND: Regel 3: Lager-Basis-Tests fehlen -- Owner verbatim: "Ich erwarte laut Plan eine dummy Strategie fuer den Tests des Lagers um aus simulierten Textdokumenten die Stempel auszulesen und jede Zeile verbatim auszuwerten und dasselbe mit compile Binary stubs fuer das Stempelsystem zu wiederholen ... Das sind die erwarteten Basis Tests fuer das Lagersystem."
ORT: Ledger :5048-5051; Plan docs/plaene/20260806-PLAN-lb6-stufe1-oeb-baumform.md
SOLL/FIX: Stufe 1 (Textdokument-Strategie, jede Zeile verbatim), Stufe 2 (compile Binary Stub mit Versionierungs-Interface).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: B-1/LB-6 (Fund 20)

### [w9cqubpi0.json] 5
GEGENSTAND: Regel 5 (aufgeklaert): Testzahl-Differenz 409->405 haengt am Bau-Zustand; 4 Tests haengen an mindestens 4 Configure-Bedingungen (test_v41_anatomy_adhoc_autobuilt_load, f15_compare_cli_smoke, test_v41_anatomy_r5i_configure_codegen, test_v41_anatomy_f15_measurement).
ORT: ce tests/unit/CMakeLists.txt:1544/:1565/:1082/:1188
SOLL/FIX: gesunkene Testzahl erst nach Mengendifferenz in beide Richtungen als Befund werten.
STATUS LT. QUELLE: behoben (aufgeklaert)
ABHAENGIGKEIT/FLAECHE: -

### [w9cqubpi0.json] 6
GEGENSTAND: Regel 6: kein Werkzeug erzwingt die Nennung der NICHT gelaufenen Gates (Anlass: Diff-Hygiene 3x gruen, lint:format fand trotzdem 94 Verstoesse in 13 Dateien [BERICHT]; super-Zwilling b35aea1b "lint:format war nie gegen die Landung gefahren").
ORT: strukturell (kein Ort)
SOLL/FIX: Werkzeug/Automatisierung fuer "Liste der nicht gelaufenen Gates" -- einer der 3 Kandidaten fuer Automatisierung (mit Regel 3 und 10).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: MEMORY-Regel "EIN GRUENES GATE deckt nur seinen Gegenstand"

### [w9cqubpi0.json] 7
GEGENSTAND: Regel 8 + IV-3: Submodul-Zeiger kann rueckwaerts zeigen ('M' heisst nicht neuer; Anlassfall 78 Commits Rueckstand); live steht +8e58f691 (vorwaerts, Distanz 4) unversioniert ohne Besitzer; Richtungs-Wache (pre-commit oder verify:submodules) fehlt.
ORT: super Code/external/20260931-overleaf-diplomarbeit; Ledger :4285-4302
SOLL/FIX: vor jedem Gitlink-Commit Richtung messen (git merge-base --is-ancestor <checkout> <zeiger>); Wache bauen, die Rueckwaerts-Bewegung abbricht.
STATUS LT. QUELLE: erledigt (Anlassfall) / offen (Wache + live stehender Zwilling)
ABHAENGIGKEIT/FLAECHE: IV-1 Doppel-Einbindung

### [w9cqubpi0.json] 8
GEGENSTAND: Regel 9 + IV-4: rescue-Ref ist keine Landung -- Gate 8 geheilt (8970465d auf main+development des Thesis-Repos); weitere rescue-Refs liegen auf den Remotes (rescue/b14-nb3-super-1ba29b63, rescue/e18snap-nb-1ae02cdf, rescue/b-honest-empty-final, 20+ im ce); Routine fehlt.
ORT: refs/remotes/origin/rescue/*
SOLL/FIX: Routine, die je Ref merge-base --is-ancestor gegen development und main faehrt und nicht-erreichbare auflistet.
STATUS LT. QUELLE: erledigt (Anlassfall) / offen (Routine, T3)
ABHAENGIGKEIT/FLAECHE: -

### [w9cqubpi0.json] 9
GEGENSTAND: IV-4-Neufall: Branch b-thesis-ehrlichkeit-anhang HEAD 8e58f691 ("die vier Gruppen-Ersatztexte benennen jetzt, WAS fehlt (DE+EN)", 4 Commits ueber 8970465d) existiert NUR als lokaler Branch -- auf keinem Remote.
ORT: Thesis-Arbeitsbaum Code/external/20260931-overleaf-diplomarbeit, refs/heads/b-thesis-ehrlichkeit-anhang
SOLL/FIX: auf beide Remotes pushen (Sicherung), in development landen, super-Gitlink BEIDER Zeiger nachziehen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: C-1 (die Ersatztexte gehoeren zu den 17 stummen Anhang-Eintraegen)

### [w9cqubpi0.json] 10
GEGENSTAND: Regel 10 / IV-6 / B-1-Buchfuehrung: LB-Paketschnitt LB-0..LB-6 (Owner 01.08., LB-6 Vor-Trigger-Rang) stand nur in Session-Dokumenten; 14-Tage-Register hat weiterhin 0 Treffer fuer LB-[0-9] und OE-B; Ursache: Quellenklasse docs/sessions/* fehlt in der Register-Methodik. Entwarnung: Kopf-Bausteine gebaut (lager_pfad_grammatik LB-0, knoten_heuristik_log LB-1, lager_baum_writer LB-2/3); Beweise nur bis LB-1 (test_lb0 33 TESTs, test_lb1 23; kein test_lb2/test_lb3).
ORT: ce libs/cache_engine/builder/bestandslog/; tests/unit/CMakeLists.txt:4995/:5008 (Session nannte :4970 -- Zeilendrift, N-2)
SOLL/FIX: LB-0..LB-6 in Ledger UND Register eintragen; Quellenklassen jeder Konsolidierung auflisten; LB-6 Stufe 1 bauen (klein, golden-neutral).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Regel 3/Fund 4

### [w9cqubpi0.json] 11
GEGENSTAND: N-1: ci_diff_ascii_width_guard.sh bindet das Repo an seinen eigenen Ort (dirname $0/..), nicht ans cwd -- aus wt-b14-ce aufgerufen mass sie den fremden Hauptklon (12578 statt 1450 Zeilen, GRUEN ueber fremden Baum).
ORT: ce scripts/ci_diff_ascii_width_guard.sh:141-142
SOLL/FIX: fuer Worktrees: git diff ... | sh .../guard.sh --stdin (korrekte Nutzung); Bezugsrahmen-Zeile lesen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Worktree-Betrieb

### [w9cqubpi0.json] 12
GEGENSTAND: N-2: Zeilendrift in Ledger-Belegen (LB-Registrierung :4970 -> tatsaechlich :4995/:5008, an einem Tag weiter nach :5003) -- Belege brauchen neben der Zeile einen Suchbegriff.
ORT: Ledger-Belege allgemein
SOLL/FIX: Beleg-Konvention: Zeile + Suchbegriff + Zaehlmethode.
STATUS LT. QUELLE: offen (Prozess-Posten)
ABHAENGIGKEIT/FLAECHE: -

### [w9cqubpi0.json] 13
GEGENSTAND: N-3/N-4: lokaler ce-main veraltet (2b0a9bd8 vs origin/main 47c4ef1d, 54 Commits); lokale ctest-Zaehlung 331 vs Pipeline 411 (teilkonfigurierter Baum) -- Landungs-/Remote-Fragen nur gegen origin/* bzw. per ls-remote beantworten.
ORT: ce Hauptklon
SOLL/FIX: Bezugszweig vor der Frage aktualisieren; lokale Zaehlungen sind keine Pipeline-Aussagen.
STATUS LT. QUELLE: offen (Prozess-Posten)
ABHAENGIGKEIT/FLAECHE: -

### [w9cqubpi0.json] 14
GEGENSTAND: SW-1 (ERLEDIGT): contract:axis-version-lock war 18 Kalendertage (19.07.-06.08.) durch YAML-Doppelschluessel faktisch AUS; zwei Semantik-Drifts am measurement_curve_loader.hpp ohne AXIS_ALGO_VERSION-Bump kamen durch; geheilt 597ecffe (Zusammenfuehrung auf strengere Wirkung) + 557d8023 (AXIS_ALGO_VERSION: 2 + Lock-Regen); ci_yaml_key_guard.sh als erster Schritt in test:coverage-guard.
ORT: ce .gitlab-ci.yml:447/:241; libs/cache_engine/heuristik/measurement_curve_loader.hpp:2
SOLL/FIX: erledigt; Klassen-Merkmal: Aktivierung an ungesetzter Variable + stummer Schluesselraum.
STATUS LT. QUELLE: behoben@597ecffe+557d8023
ABHAENGIGKEIT/FLAECHE: -

### [w9cqubpi0.json] 15
GEGENSTAND: SW-2 (ERLEDIGT an der Wurzel): 9 Tests in keinem CI-Job (zweiter Durchgang -- am 13.07. waren es schon 21, M-CE-25); geheilt dcb2f08f: contract-Ausschluss faellt, 14 Job-Auswahlen aus EINER Datei, test:coverage-guard inventarisiert live (ctest -N), kein rules-Gate, kein allow_failure. Zahlen-Praezisierung: Ground Truth 406 (2-Pass-Configure), nicht 404.
ORT: ce .gitlab-ci.yml:575-582/:230; scripts/ci_test_coverage_manifest.sh:127-129
SOLL/FIX: erledigt; Lehre: manueller Fix haelt nicht, Invariante statt Job-Namen.
STATUS LT. QUELLE: behoben@dcb2f08f
ABHAENGIGKEIT/FLAECHE: D-3 (super-Spiegelung offen, Fund 27)

### [w9cqubpi0.json] 16
GEGENSTAND: SW-3 / A-1/A-3 (OFFEN, hoechste Position, T1): PMC-Preflight -- vier Wachen, keine beisst: (1) COMDARE_ENABLE_PMC fehlt an allen 4 Emissionsstellen des Plan-Directors (0 Treffer in 2092 Z.; Option OFF, Beschreibung irrefuehrend "Windows", gated aber auch Linux); (2) pmc_seam_ok = available || counters_all_zero wertet lauter Nullen als bestanden; (3) allow_failure: true am Mess-Batch (:1333); (4) Preflight wertet SMOKE_SKIP (Quelle nicht gebaut) als Exit 0. Konsequenz: 131.072er-Matrix laeuft ohne Hardware-Zaehler und meldet gruen.
ORT: ce libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:841/:877/:1194/:1342/:1333/:1361-1364; tests/unit/thesis_tiere/m3v2_pmc_smoke.cpp:71; linux_perf_pmc_smoke.cpp:58-62; CMakeLists.txt:67/:69-77
SOLL/FIX: Owner-KERN 06.08. verbatim: "PMC MUSS eingebaut und gemessen werden und zwar in die CEB fuer deren Pruefdock ... NIE abkuerzen, immer mit deep research fixen." -- also NICHT Flag-Zeile, sondern Mess-Achse gibt frei, CEB kompiliert nach Planer-Freigabe ein, Pruefdock testiert. Zusaetzlich: (a) Flag an 4 Emissionsstellen; (b) allow_failure entfernen/begruenden; (c) Preflight auf "Quelle gebaut UND liefert Werte" umstellen (SMOKE_SKIP im Mess-Kontext = rot; Inversionsfix 13.07. NICHT zuruecknehmen -- zweiter Modus); (d) Option-Beschreibung korrigieren. A-1 und A-3 ZUSAMMEN landen.
STATUS LT. QUELLE: offen (T1, blockiert Messbeginn)
ABHAENGIGKEIT/FLAECHE: A-4 Fortpflanzung; Owner-Direktive 16.07. "MUSS als PFLICHT fuer die Vollstaendigkeit aller perf-Messwerte mit in die Ergebnisse"

### [w9cqubpi0.json] 17
GEGENSTAND: A-2 (T2): L2/L3/Kohaerenz/Energie nachruesten -- nur L1D+dTLB liefern real (I-PMC-2/3 Zen-5-RAW-Events); Owner-KERN verbatim: "gehoert in die Messachse und wird durch die CEB einkompiliert nach Planer Freigabe ... direkt nachruesten nach Plan. PFLICHT und KERN der ANLAGE." -- fruehere Zurueckhaltungs-Empfehlung ausdruecklich verworfen.
ORT: Mess-Achse -> CEB
SOLL/FIX: verbatim wie oben; haengt an A-1.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: A-1; C-4 (Thesis-Praezisierung)

### [w9cqubpi0.json] 18
GEGENSTAND: A-4 (T1): Fortpflanzungs-Regel -- heute geht COMDARE_ENABLE_PMC in keinen Stempel/binary_id/Fingerprint ein (Co-Occurrence 0); sobald PMC ueber die Mess-Achse kommt (A-1), wird es Teil der Bau-Identitaet: Mess-Achsen-Aenderung erzwingt CEB-Neubau UND alle Binaries neu.
ORT: Planer
SOLL/FIX: Fortpflanzungs-Regel im Planer explizit machen BEVOR A-1 landet, sonst misst man mit halb erneuerten Binaries.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: A-1

### [w9cqubpi0.json] 19
GEGENSTAND: A-5 (T2): ObservableTier-Vertrag -- #if COMDARE_MEASUREMENT_ON (abi_adapter.hpp:393-397, via CMake-Option :135/:141) entscheidet, ob der ABI-Adapter IObservableTier/IMeasurableWorkload/-V2/-V3 erbt: "Was gemessen werden kann, entscheidet heute eine CMake-Option, nicht die Mess-Achse." Owner: Vertrag ist KERN-Achse des Planers, wird NICHT gestrichen -- zu korrigieren ist die Orchestrierung.
ORT: ce libs/cache_engine/anatomy/abi_adapter.hpp:393-397; CMakeLists.txt:135/:141; Landeplatz libs/cache_engine/builder/pruef_dock/mess_interface_testate.hpp
SOLL/FIX: Deep Research Pfad Mess-Achse -> Planer-Freigabe -> CEB-Einkompilierung -> Pruefdock-Testat.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: gleiche Wurzel wie A-1, eine Ebene tiefer; F-6 Observer-Push

### [w9cqubpi0.json] 20
GEGENSTAND: A-6 (T2): experiment_golden_kern.xml:246 <run_options cap="131072" build_version="golden_kern"/> -- EIN Element traegt Mess-Obergrenze und Bau-Identitaet; Mess-Aenderung kann Bau-Identitaet mitverschieben.
ORT: super Code/test_data_xml/experiment_golden_kern.xml:246
SOLL/FIX: Bau-Block und Mess-Block als getrennte XSD-Vokabeln, additiv (wie G5: run_options/organ_subaxes je minOccurs="0"). Owner: "sonst regression".
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: XSD/Golden

### [w9cqubpi0.json] 21
GEGENSTAND: SW-5 / F-8: active_telemetry_is_silent() liefert literal false (Konstante, kein Profil-Wiring); 11 Thesis-Profile deklarieren <telemetry mode="on" silent="true"/> -- XML sagt silent, gemessen wird Active; Wiring ist bewusst golden-brechend vertagt, aber nirgends als Mess-Posten gefuehrt.
ORT: ce libs/cache_engine/profile_facade/profile_run_facade.cpp:240-241 (einziger Aufrufer :505)
SOLL/FIX: entweder Wiring bauen (bewusster golden-Bruch, Owner-Entscheid, GOLDEN-UPDATE-Fenster) ODER laute Wache XML-vs-Ist beim Profil-Laden; bis dahin Klarstellung im Ergebnis-Teil.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: golden-Byte-Identitaet

### [w9cqubpi0.json] 22
GEGENSTAND: SW-6 / F-7: COMDARE_LEGACY_MESSREIHEN -- ce-Kommentare falsch ("existiert nirgends (0x)"): das Gate existiert im super (Code/02_messung_driver/main.cpp:701/:718/:986/:1370-1372) und gated den V37.C/V38.C-Legacy-Pfad; ce xml_config_parser.cpp:149 liest test_data_sets.xml UNBEDINGT (Datei existiert, 3 Datensaetze) obwohl Kommentar das Gegenteil behauptet.
ORT: ce libs/common/serialization/xml_config_parser/*; super Code/02_messung_driver/main.cpp
SOLL/FIX: ce-Kommentare korrigieren ("Gate liegt im super und deckt DIESEN Aufruf nicht"); Owner-Stufe: gaten oder ehrlich ungegatet-deprecated ausweisen; Entfernen erst mit Aufraeumpass nach belegter E4-XML-Subsumtion. Kein heutiger Messwert haengt daran.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Aufraeumpass F-3

### [w9cqubpi0.json] 23
GEGENSTAND: III-Kapitel ERLEDIGT-Posten (nicht doppelt bauen): III.1 CLU-Konsument Literal-64-Nenner geheilt@c1c76c87 (Einheit reist in axis_stats[5][5]; Lehre: Achsen-Regel endet an der Modul-ABI); III.2 XXE geheilt@cb4b15e9 (--noent ueberall weg, DOCTYPE komplett FATAL, parser-basiert); III.3 foreach(RANGE 1 0) geheilt@cb4b15e9 (if(_n_modes GREATER 0)); III.4 ohne-anker-Kollisions-Eimer geheilt@71b5586a (PlanAnkerBefund + fp_is_hex_128 in der Digest-Schleife); III.5 drain()-Barrieren-Kurzschluss geheilt@71b5586a (cv-wait statt closed_-Abkuerzung); III.7 Fassaden-Test nachgefuehrt (setenv COMDARE_BESTANDSLOG literal im Test).
ORT: siehe je Posten; alle als Ancestor von ce 47c4ef1d / super 72eab9ae verifiziert
SOLL/FIX: als gelandet registrieren. Ledger-Stand "UNGELANDET" fuer 2c631551, 9934a7e5, 0bda94aa, c1cdc0da, 9c858a73, 4b38d072 ist UEBERHOLT -- alle sechs sind Ancestor ihres HEAD.
STATUS LT. QUELLE: behoben (gelandet)
ABHAENGIGKEIT/FLAECHE: Ledger-Korrektur noetig

### [w9cqubpi0.json] 24
GEGENSTAND: III.4-R1 (OFFEN): Formwache ist plan-global inert -- ein Atom ohne pruefbare Identitaet legt die ganze Plan-Ablage still; richtig waere, das Atom aus dem Plan zu nehmen statt den Plan zu verwerfen.
ORT: ce cache_engine_builder_iterator.hpp:1246-1283
SOLL/FIX: Verfeinerung einplanbar ab Liefer-Freitag 14.08.; fail-closed plan-global ist die richtige ERSTE Form.
STATUS LT. QUELLE: offen (niedrige Prioritaet)
ABHAENGIGKEIT/FLAECHE: III.4

### [w9cqubpi0.json] 25
GEGENSTAND: III.6 / F-4 (OFFEN): PlanFach::offen wird erhoben, persistiert und fuer die einzige Entscheidung verworfen -- plan_resume_faecher liest nur f.count; gemessen: ein vollstaendig gedecktes Fach mit frisch als abwesend gemeldeten Binaries wird uebersprungen. Naive offen>0-Abschneidung verboten (braeche 2 Zusagen bei ungebundener PresenceFn) -- sauber ist ein present_-Gate.
ORT: ce libs/cache_engine/builder/bestandslog/batch_planner.hpp:159-165/:217-233/:246
SOLL/FIX: present_-Gate bauen, zusammen mit Host-Belegung der Plan-Ablage; offener Owner-Entscheid (Autoritaets-Frage): "der Plan-Zaehler ist eine HISTORISCHE Aussage, der Praesenz-Scan eine GEGENWAERTIGE -- wo beide vorliegen, muss die gegenwaertige gewinnen." Einplanbar ab 14.08. Abgrenzung: ersetzt die Formwache III.4 NICHT.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Owner-Entscheid; III.4

### [w9cqubpi0.json] 26
GEGENSTAND: III.7-R1 (OFFEN): Mechanik der Plan-Ablage (Plan + Zaehler + Praefix-Resume) ist im Fassaden-Pfad NICHT belegt, nur auf Iterator-Ebene -- der produktive Weg zeigt die Mechanik nirgends.
ORT: ce tests/unit/test_t2a_f4_facade_plan_durchreichung.cpp (Test-Kopf); test_tp1_planer_filter_iterator (11a)-(11c2),(11l-b)/(11l-f)
SOLL/FIX: Fassaden-Profil mit materialisierbarer Binary (alle 17 Kompositions-Achsen in der Enabled-Tabelle), dann Zusage (3) wieder als Wirkung fahren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [w9cqubpi0.json] 27
GEGENSTAND: IV-1/D-1 + IV-2/D-2: Thesis doppelt eingebunden (.gitmodules zwei Eintraege, selbe URL; CI baut nur thesis/diplomarbeit) -- Divergenz geheilt@72eab9ae, aber am selben Abend wieder aufgelaufen; Trigger-Bridges branch:main fest verdrahtet (super .gitlab-ci.yml:255/:273/:291) waehrend auf development gelandet wird; super origin/main lag 9-10 Commits zurueck (baute Gate-8-lose Thesis).
ORT: super/.gitmodules:11-18; super/.gitlab-ci.yml:255/:273/:291/:548/:560
SOLL/FIX: (1) SOFORT super main per FF nachziehen (S-3: auf 46824fba); (2) Owner-Entscheid: zweite Einbindung entfernen ODER Gitlink-Gleichheits-Wache rot; (3) Bridges auf development/$CI_COMMIT_REF_NAME (Weg a, T1) oder Gitlink-SHA-Forwarding (Weg b, T4); (4) main-FF-Pflicht gilt fuer BEIDE Repos.
STATUS LT. QUELLE: teilweise/offen
ABHAENGIGKEIT/FLAECHE: Abgabe-PDF (23 Abbildungen Anhang A); Autoritaets-Linie main

### [w9cqubpi0.json] 28
GEGENSTAND: IV-5/S-4: untracked Plandokumente im super-Baum -- zunaechst 2 Dateien/1313 Zeilen, bei Abfassung 3 Dateien/2042 Zeilen (729+599+714: u.a. 20260806-PLAN-kostenklammer-restposten.md, 20260806-PLAN-thesis-posten-und-testoffensive.md) + Code/measure_out_d03/ -- git clean -fdx vernichtet sie rueckstandsfrei; zwei davon werden im Dossier als Beleg zitiert.
ORT: super git status --porcelain (?? docs/plaene/...)
SOLL/FIX: sofort versionieren; Dauer-Regel: keine Planarbeit ohne Commit im selben Arbeitsschritt (an Backup-SOFORT-Doktrin haengen).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [w9cqubpi0.json] 29
GEGENSTAND: IV-7 / Z-7-Rest: fehlende Build-Graph-Kante -- test_experiment_plan_director inkludiert den generierten Katalog-Header ohne Kante auf comdare_limits_generated_source_catalog (4 andere Konsumenten setzen sie korrekt); kalt 3/3 Fehlschlaege, warm 20/20 gruen [BERICHT]; ein Ein-Zeilen-Fix wurde 4 Tage als mehrstufiges Ritual (J-3) dokumentiert.
ORT: ce tests/unit/CMakeLists.txt:3438-3461; cmake/catalog_codegen.cmake:48-60
SOLL/FIX: eine Zeile comdare_attach_generated_catalog(test_experiment_plan_director) nach :3461; danach Gegenprobe fuer ALLE Konsumenten generierter Header (auch Achsen-Codegen-Header); J-3 aus der Doku streichen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: J-1..J-4-Vollbau-Doktrin (MEMORY)

### [w9cqubpi0.json] 30
GEGENSTAND: IV-8 / C-1: Anhang A -- \InputIfFileExists-Eintraege ohne Zieldatei; Kapitel-IV-Zaehlung 28 Eintraege/0 Dateien/17 stumm ({}{}), 11 mit Ersatztext; Checklisten-Livezaehlung spaeter: 29/17 stumm/12 Ersatztext/0 Ziele; je Sprache identisch. Umgekehrte Falle: axis_inventory.tex wird erzeugt (appendix_generator.cpp:423) aber 0-mal referenziert.
ORT: thesis/diplomarbeit/anhang/de/A_measurements.tex (+en)
SOLL/FIX: (a) stumme Eintraege auf benennenden Ersatztext heben (Commit 8e58f691 tut das fuer 4 Gruppen -- landen, Fund 9); (b) Zaehl-Gate im thesis:pdf-Job (Eintraege vs existierende Ziele, Schwellwert); (c) Owner-Entscheid Anhang-A-Reichweite vor erstem Voll-Messlauf (C-3: M-8/M-9/M-15).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Freitags-Lieferung; C-3 Owner-Entscheid

### [w9cqubpi0.json] 31
GEGENSTAND: C-2: 7 unmarkierte Alt-Kapitel -- kapitel/de/ hat 14 .tex, diplomarbeit.tex bindet 6 ein; von 8 nicht eingebundenen traegt nur 06_evaluation_methodology.tex einen Vermerk; die 7 anderen sprechen von "neunzehn" Achsen (eingebundenes 04_implementierung.tex sagt 7x korrekt "achtzehn").
ORT: thesis kapitel/de/*; diplomarbeit.tex:280-285
SOLL/FIX: Kopfvermerk je Datei (T3).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [w9cqubpi0.json] 32
GEGENSTAND: C-4: Praezisionsluecke 05_evaluation.tex:84-92 -- Text suggeriert, das privilegierte Regime mache alle zaehlerbasierten Kategorien zugaenglich, ohne zu differenzieren dass nur L1D+dTLB real liefern. Entlastet: 06_fazit.tex:157-162 und le_limitierung.tex korrekt gehedgt; Node-Shape-Varianten 0 Treffer.
ORT: thesis kapitel/de/05_evaluation.tex:84-92
SOLL/FIX: Limitierung praezisieren statt Anhang kuerzen (~30 min DE+EN), vor der ersten Zaehler-Tabelle (T2).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: A-2

### [w9cqubpi0.json] 33
GEGENSTAND: D-3: super ohne Abdeckungs-Invariante -- kein scripts/ci_test_coverage_* im super; heute Luecke 0 (144/144 mit da_unit), aber im ce ist die Luecke zweimal nachgewachsen; nichts haelt die super-Null von selbst.
ORT: super scripts/ (fehlt); ce ci_test_coverage_manifest.sh/guard.sh
SOLL/FIX: Manifest+Wache spiegeln; entscheidender Unterschied: ce-/prt-art-Submodul-Tests aus dem Nenner nehmen (sonst 313 falsch-ungedeckte).
STATUS LT. QUELLE: offen (T3)
ABHAENGIGKEIT/FLAECHE: SW-2-Klasse

### [w9cqubpi0.json] 34
GEGENSTAND: E-1: refs/backup/pre-secret-scrub-20260802 mit 776 realen runners_token-Werten (GR1348941...) liegt live auf gitlab origin (group_projects.ndjson 386 + projects_all.ndjson 390); Scrub-Verify lief nur gegen den Zweig, nicht alle Refs.
ORT: super refs/backup/pre-secret-scrub-20260802 (enthaelt 44820451); docs/sessions/backups/20260802-e23-suchlauf-belege/e23/
SOLL/FIX: Owner-Entscheid (bindend): stehen lassen; nach Abgabe rechtebeschraenktes Bundle, dann Remote-Ref loeschen (Remote-Loeschung braucht ausdrueckliches GO). Unabhaengig: Runner-Registration-Token rotieren (T3) -- entwertet die Werte.
STATUS LT. QUELLE: offen (Owner-Entscheid liegt vor)
ABHAENGIGKEIT/FLAECHE: Loeschung=GO-Regel

### [w9cqubpi0.json] 35
GEGENSTAND: F-1: F3/Weg a (Fixture-Rename) hat GO (Ledger :5220 "F3: Bitte sauber die fixture nachziehen"), ist nicht vollzogen; bindende Auflage: fixture_schema_subset_check.cmake:98-101 deutet fehlenden FIXTURE-Pfad als "Nachbar-Checkout fehlt" und meldet still SKIPPED (SCHEMA/MASTER dagegen FATAL) -- nach dem Rename waere die einzige Wache des Neu-Paares lautlos abgeschaltet.
ORT: super Code/tests/fixture_schema_subset_check.cmake:98-101; ce tests/unit/thesis_tiere/experiment_golden_kern.xml
SOLL/FIX: Gegenmassnahme (Verzeichnis existiert, Datei fehlt => FATAL) MUSS im selben Commit wie der Rename kommen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: F3-Fixture-Flaeche

### [w9cqubpi0.json] 36
GEGENSTAND: B-2/B-3: B10-Pruefdurchlauf (Anker auf Fingerprint-Mismatch; Auflage: COMDARE_VARIANT_GATE=true NICHT einschalten -- waere Regression, kein Test); Beweis 1 (lueckenlose Batch-Wiederaufnahme, 2 Layer, versions-scharfer per-Binary-Nachbau -- NICHT als Ersatz-Minimalkriterium) und Beweis 4 (Bestandslog-E2E gegen echtes minio + Takeover -- infra-gebunden, Impl-Strang hat nur Lesezugriff).
ORT: ce build_variant_sidecar.hpp; super docs/sessions/20260801-KONSOLIDIERT-...:76/:89; FAHRPLAN:194
SOLL/FIX: verbatim; B-2/Beweis 1 = T1, Beweis 4 = T2 (Infra-Termin noetig).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Infra/minio

### [w9cqubpi0.json] 37
GEGENSTAND: F-9 (T2, unverbuchter Nachtrag): bestandslog_active prueft fetch/store/bestand_key_of/bestand_doc_key, NICHT bestand_fingerprint_fn -- muss fail-closed nachgezogen werden, in derselben Welle wie die Provider-Scharfschaltung.
ORT: ce cache_engine_builder_iterator.hpp:1658-1660
SOLL/FIX: fail-closed ergaenzen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: III.4/Bestandslog-Welle

### [w9cqubpi0.json] 38
GEGENSTAND: Entlastungen + UNBELEGT-Posten (nicht wieder aufmachen bzw. erst rekonstruieren): COMDARE_BESTANDSLOG reist ueber emittierten Weg (Regel 4); kaputte grep-Kette traf 0 CI-Jobs; Shaped-Emission default-OFF ist spezifiziert (G-234V-b); target_isa-Unterachsen haben Konsumenten; COMDARE_VARIANT_GATE obsolet (nicht vor Aufraeumpass entfernen); lint:static-Treffer isolierter cppcheck-False-Positive; i-4 "ce-CI-Doppeldefinition :343/:502" am Objekt NICHT reproduzierbar (UNBELEGT); D-4/U-2 Include-Root/INTERFACE-Ziel-Forderung ohne Fundstelle (UNBELEGT, an Quelle Vierfach-Review rekonstruieren); U-1 b14-super 667/1385 UNBELEGT; Thesis-GitHub-Sicherung auf Stand.
ORT: siehe je Posten
SOLL/FIX: als Entlastung/UNBELEGT registrieren, Dedup fuer Designer.
STATUS LT. QUELLE: entlastet / unbelegt
ABHAENGIGKEIT/FLAECHE: -

### [w9cqubpi0.json] 39
GEGENSTAND: Sofort-Posten der Checkliste (live gemessen bei Abfassung, SHAs neuer als Kapitel-Staende): S-1 super-Gitlink auf ce f57801d3 committen (vorwaerts, Distanz 2); S-2 ce main per FF auf f57801d3 (stand 47c4ef1d, 2 zurueck); S-3 super main per FF auf 46824fba (stand 5534c23c, 10 zurueck; Gitlinks dort: thesis 29a1700d = VOR Gate 8, ce e7aa1244); S-4 drei untracked Plandokumente versionieren (2042 Zeilen).
ORT: super/ce Haupt-Repos
SOLL/FIX: verbatim; Reihenfolge wie gelistet.
STATUS LT. QUELLE: offen (Stand 06.08. abends; vor Verwendung neu erheben)
ABHAENGIGKEIT/FLAECHE: Diff-Hygiene-Wache misst push-lokal (MEMORY)


# DATEI 3: woyk1t3na.json -- "Messkurven-Synthese + Bestimmung der besten Binaries als Voraussetzung der Hybrid-Binary -- detailliert geplant, nach der Abgabe faellig"
Plan-Datei lt. Quelle: docs/plaene/20260806-PLAN-messkurven-synthese-und-hybrid-binary.md

### [woyk1t3na.json] 1
GEGENSTAND: Owner-Definition der 4-Phasen-Kette (verbatim, Ledger:4176, 05.08.): Voll-Lauf -> Messwerte ausgewertet -> zu Messkurven synthetisiert -> Kurven je Eingangslast verglichen -> beste Binary -> Release-Rekompilation ohne Mess-Einrichtungen + Wallclock-Nachmessung -> multiple beste Binaries ueber multiple Lasten -> Erkennungsheuristik der Last -> Hybrid-Tier-Binary zur aktiven Runtime-Auswahl.
ORT: docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:4176; F8 Ledger:2296/:2301
SOLL/FIX: Kette als Sollbild; Auswertung ist KONSTRUKTOR der Hybrid-Binary (Bestueckungsliste (a), Router-Schwellen (b), XML-Freischaltung (c)).
STATUS LT. QUELLE: nur-hinweis (Soll-Definition)
ABHAENGIGKEIT/FLAECHE: Hybrid-Stufe HY-B1a..HY-B4, Auswertungsphase nach Voll-Bau-4 + E-24

### [woyk1t3na.json] 2
GEGENSTAND: ZENTRALER BRUCH S-1 (HOCH): Die Kette ist an ihrer wichtigsten Naht durchtrennt -- best_binary_selector konsumiert die Synthese NICHT (grep axis_spline|heuristik/ in beiden Selektor-Dateien = 0), rankt Roh-Mediane direkt aus der CSV; hybrid_router.hpp existiert nicht; ZWEI unvereinbare Definitionen von "beste Binary" koexistieren (IST: Median-der-Zell-Mediane, 1 globaler Sieger je Metrik, Bediener waehlt --metric; SOLL/F8: f(x)-Splines, Heuristik waehlt, 1 Sieger JE Eingangslast, multiple) -- nirgends als Fork verbucht. Dritte Definition (C): Pareto-Front (User-Entscheid-Fork H-6, Entscheid in Doc 21 NICHT am Objekt geprueft = UNBELEGT).
ORT: ce libs/cache_engine/builder/best_binary_selector/; heuristik/{axis_spline,break_even,measurement_curve_loader}.hpp; Atlas 05b:784
SOLL/FIX: Bruecke [2]->[3] bauen (Auswertungs-Orchestrator "Kurven-Vergleich JE EINGANGSLAST" als EIN benannter Codepfad); Fork "beste Binary"-Definition dem Owner stellen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: HY-B2; 75er-Schutzliste

### [woyk1t3na.json] 3
GEGENSTAND: S-2 (HOCH): DREI parallele Implementierungen derselben Rueckwaerts-Wahl-Mathematik, alle 0 Produktions-Konsumenten (1802 Zeilen): (1) heuristik/ (Fritsch-Carlson, 75-geschuetzt, HY-B2-Speisung); (2) builder/curve_fit + decision_lambda_trees (natuerlicher kubischer Spline + eigene Fritsch-Carlson-Kopie, CMake-angebunden); (3) best_binary_selector Haelfte B (std-only PiecewiseCurve). Plan zeigt auf Stack 1, gebauter Entscheidungsbaum sitzt auf Stack 2, Stack 3 ist dritte Spiegelung. Im 75er-Aufraeumpass sind 1 geschuetzt und 2/3 ungeschuetzt -- der Pass wuerde die Entscheidung IMPLIZIT faellen.
ORT: ce libs/cache_engine/heuristik/; builder/curve_fit/curve_fit.hpp:278/:387; builder/decision_lambda_trees/decision_lambda_trees.hpp:10-11
SOLL/FIX: expliziter Owner-Entscheid VOR dem 75er-Pass, welcher Stack kanonisch ist.
STATUS LT. QUELLE: offen (nirgends registriert)
ABHAENGIGKEIT/FLAECHE: 75-Schutzliste (Ledger:3602: heuristik/-Header duerfen weder entfernt noch umbenannt werden)

### [woyk1t3na.json] 4
GEGENSTAND: S-3 (HOCH): LAST-ERKENNUNGSHEURISTIK 0 in Code, 0 im HY-D2-Design-Doc, 0 im TODO-Register -- Bindeglied zwischen "multiple beste Binaries" und Hybrid-Binary; echte Planungsluecke (nicht nur ungelesen); schmalste Stelle der Owner-benannten Funktionalitaets-Voraussetzung.
ORT: Atlas 05b:786 (UNGEDECKT 4); Deckung nur Dossier-19 Punkt 4 + Owner-R5 verbatim
SOLL/FIX: Verfahren + Deep Research + Paket + Registrierung -- alles fehlt.
STATUS LT. QUELLE: offen (ungedeckt)
ABHAENGIGKEIT/FLAECHE: Hybrid-Router

### [woyk1t3na.json] 5
GEGENSTAND: S-4 (MITTEL): Phantom-Blocker K-5 -- Ledger:2726/:3027 fuehren "best_binary_selector ABI-Spiegel stale kAbiMajor=5 vs Host 6, OFFEN, hoch"; der Code steht real auf kAbiMajor=8/.A8. mit Paritaets-static_assert in zwei Tests; der DIFF-Doc 20260806 (Par.63-T-23) hat daraus faelschlich einen Vor-Abgabe-Thesis-Blocker gemacht ("Par.50-K-5 vor Abgabe schliessen") -- GEGENSTANDSLOS, streichen; nur Ledger-Vermerk nachziehen. ABER Rest-Facette (B-2 unten): eine STALE GEBAUTE Selektor-Binary schrieb im Live-Test abi_major=5 statt 8 ins Manifest -- static_assert schuetzt nur den Uebersetzungs-, nicht den Ausfuehrungszeitpunkt.
ORT: Ledger:2726/:3027; docs/plaene/20260806-DIFF-thesis-soll-gegen-ledger-und-code.md:499-505; best_binary_selector.hpp:45-59
SOLL/FIX: Ledger-Posten korrigieren; TODO Par.63-T-23 streichen; ABI-Provenienz zur Laufzeit aus der DLL messen statt aus Tool-Konstanten spiegeln.
STATUS LT. QUELLE: teilweise (Blocker gegenstandslos, Laufzeit-Facette offen)
ABHAENGIGKEIT/FLAECHE: K-5-Fehlerklasse

### [woyk1t3na.json] 6
GEGENSTAND: S-5 / B-2-Kurvenloader (MITTEL): Stiller Gruppen-Kollaps im measurement_curve_loader -- fehlt eine Gruppen-Spalte im CSV-Header (z.B. workload), faellt ihre Dimension still auf "-": alle Lasten verschmelzen zu EINER Gruppe; genau "je Eingangslast" ist die Owner-Definition von Phase 2b; x/y sind honest-empty-geschuetzt, die Gruppendimensionen nicht.
ORT: ce libs/cache_engine/heuristik/measurement_curve_loader.hpp:50-51
SOLL/FIX: "Gruppendimensions-Kollaps zaehlen und diagnostizieren (analog skipped_rows), nicht nur kommentieren."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Phase 2b

### [woyk1t3na.json] 7
GEGENSTAND: S-6 / REV-DATA-12 (MITTEL): Median-Divergenz -- Selektor nutzt lower_median (untere Mitte), csv_to_latex.cpp:48-54 und diagram_generator.cpp:414-420 die nearest-rank-OBERE Mitte; bei geradem n kann die Thesis-Tabellen-Zahl vom Sieger-Bestimmungs-Median abweichen; im Code als offen annotiert; NICHT im Ledger, NICHT im Register.
ORT: ce best_binary_selector.cpp:182-184; Disposition docs/audits/20260716-wp5-rev-mining-DISPOSITION.md:53
SOLL/FIX: Median-Definition vereinheitlichen oder Abweichung registrieren+dokumentieren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Thesis-Zahlen

### [woyk1t3na.json] 8
GEGENSTAND: S-7 / B-1-Selektor (schwer): Fehlende Quell-Provenienz wird still zu leerem Sidecar und als Erfolg gemeldet -- fehlt perm.dll.version in der Quelle, entsteht leeres .version + dll_build_version= (leer) im Manifest, build() meldet Erfolg; Artefakt mit/ohne Provenienz am Rueckgabewert ununterscheidbar.
ORT: ce best_binary_selector.cpp:326-339
SOLL/FIX: fehlende Quelle mindestens diagnostizieren (Owner-KERN "stiller Rueckfall verboten"); vor dem Vortrag korrigieren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [woyk1t3na.json] 9
GEGENSTAND: S-8 + S-9 (gering): --top mit Muell faellt via catch(...){} still auf Default 5 (best_binary_selector_main.cpp:53-56, formgleich zum verbotenen Muster); CLI-Frontend best_binary_selector_main.cpp (148 Z.) wird in KEINER CI-Uebersetzungseinheit uebersetzt (grep best_binary ueber 1996 CI-Zeilen = 0; kein Job baut all) -- Compile-Bruch faellt erst beim manuellen Vollbau auf. Zusaetzlich B-4: dokumentierter tiere-Anker build/thesis_tiere/tiere existiert nicht (real <out>/e4_xml/dll/<stem>/perm.dll, 328 Treffer).
ORT: ce best_binary_selector_main.cpp:53-56/:23; .hpp:219
SOLL/FIX: stoi-Fehler diagnostizieren; CLI in CI-Bau aufnehmen; Doku-Anker korrigieren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [woyk1t3na.json] 10
GEGENSTAND: TiereDllRepository::resolve_dir (binary_id->DLL-Aufloesung, orch_make_stem-Spiegel der byte-gleich zum BuildOrchestrator bleiben muss) hat KEINEN Test (429 tests-cpp, 0 Treffer; Gegenprobe ShippedArtifactBuilder=1) -- ein Drift im Orchestrator-Stem bricht stumm.
ORT: ce best_binary_selector.hpp:61-64; tests/
SOLL/FIX: Test fuer resolve_dir ergaenzen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: BuildOrchestrator-Stem

### [woyk1t3na.json] 11
GEGENSTAND: best_binary_selector ist gebaute Faehigkeit OHNE Produktions-Aufrufer -- Feedback-Kante Auswertung->Generierung im Code dreifach als "noch nicht verdrahtet / DEFERRED (#156) / reine Identitaet" markiert (selection_filter_chain.hpp:2-5/:110-113/:122-125: ResumeFilter-Reject strukturell UNERREICHBAR solange keine MeasurementRow-Rueckfuehrung).
ORT: ce libs/cache_engine/builder/experiment_tree/selection_filter_chain.hpp
SOLL/FIX: Verdrahtung best_binary_selector -> resolve_selection nachziehen (DEFERRED #156); Kostenklammer-Form, nicht bezahlte Vollstaendigkeit.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: #156-Fenster; Widerspruch zweier Bestandsaussagen zu selection_filter_chain (Atlas: IST-Anker vs plaene/20260720: Dead-Code) UNGEKLAERT

### [woyk1t3na.json] 12
GEGENSTAND: Thesis-Zusage best_binary_selector (01_einleitung.tex:227-233 + 03:1401 + 06:195, EN-Paritaet) HAELT in enger Fassung; einziger angreifbarer Punkt: Wort "Binary-Versand" (real: fs::copy_file+rename nach --out, kein MinIO-/Lager-/Ebene-B-Kanal -- Nullen mit Nenner belegt). Zwei Owner-Wege: WEG A bauen (Versandkanal an ShippedArtifactBuilder via artifact_cache_transport-Naht; riskant, CI-ungedeckte Datei) vs WEG B praezisieren (6 Textzeilen DE+EN: "Binary-Versand" -> "Artefakt-Auslieferung als eigenstaendige, provenienz-etikettierte Binary"); Einordnung des Berichts: Weg B risikoaermer, Weg A gehoert in HY-B4.
ORT: thesis kapitel/{de,en}/01_einleitung.tex:231-232, 03_messsystem_prtart.tex:1402, 06_fazit.tex:196
SOLL/FIX: Owner-Wahl A/B; unabhaengig davon Par.63-T-23 streichen.
STATUS LT. QUELLE: offen (Owner-Entscheid)
ABHAENGIGKEIT/FLAECHE: Abgabe-Flaeche

### [woyk1t3na.json] 13
GEGENSTAND: Hybrid-Binary-Definition (Owner-E1 02.08. verbatim): eigene Stufe HINTER der CEB, mehrere ABI-stabile Pruef-Docks, Factory-Pattern als Proxy, std::variant als Ausnahme in wahlweise statischem oder Runtime-Array; in plain Tier-Binaries bleibt variant VERBOTEN; Vererbungs-Gesetz (Ledger:4082/:4090/:4091): MESS- und SYSTEM-Achse dehnbar stufig durch Hybrid (CT-Weitergabe), ORGAN beruehrt Hybrid NICHT (factory-facade-Adapter); Stempel: Hybrid traegt Mess+System-Zeilen, KEINE Organ-Permutations-Identitaet.
ORT: docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md:7; Ledger:96/:4082/:4090-4092; memory feedback_hybrid_tier_stufe_hinter_ceb_variant_ausnahme.md
SOLL/FIX: verbatim als bindende Definition; E-11-Regelkonflikt AUFGELOEST (zwei Geltungsbereiche).
STATUS LT. QUELLE: nur-hinweis (bindend)
ABHAENGIGKEIT/FLAECHE: S7/S9-variant-Grenze

### [woyk1t3na.json] 14
GEGENSTAND: IST hybrid/: genau 1 Datei README.md ("RESERVIERTER STUB ... KEIN CODE ... ANFASSEN ERST in der Auswertungsphase (HY-B1..HY-B4), nach Voll-Bau-4 und nach E-24"); build-neutral verifiziert; korrekt by design -- kein Befund.
ORT: ce libs/cache_engine/hybrid/README.md
SOLL/FIX: 5 bindende Design-Auflagen VOR dem Bau offen: K1 Lager-Identitaet der Hybrid-.so (keine Organ-binary_id -> kein Slot im Binaries-Realm; (a) eigener Schluessel vs (b) keine Einlagerung) / K2 Schichten-Zuordnung Loader-Drive (Hybrid-.so muesste Builder-Code linken, kollidiert mit pruef_dock.hpp:10-14) / K5 Snapshot-Aggregation ((a) Summe vs (b) Passthrough -- "Bis zum Entscheid gilt keine Variante als implizit gesetzt") / Q10.3 Stempel-Kennzeichen / Q10.4 Verdraengungs-Heuristik-Shortlist. Plus Posten 90: GoF-Einordnung + CT-Weitergabe beider Achsen-Arten noch nicht im Design-Doc (Doc vom 02.08., Praezisierungen vom 05.08.).
STATUS LT. QUELLE: offen (Design-Auflagen), Bau terminlich korrekt vertagt
ABHAENGIGKEIT/FLAECHE: Auswertungsphase; K6 "F8-Minimal-DoD zuerst"

### [woyk1t3na.json] 15
GEGENSTAND: Thesis fuehrt per K4 SUPERSEDETES Framing: 03_messsystem_prtart.tex:1455-1456 "Heuristik-Optimierung selbst eine System-Achse" -- dagegen Ledger:97 + Design-Doc K4 (Owner-GO Q6 02.08.): "die Hybrid-Natur ist eine STUFE, keine Systemachse"; sekundaer :1459 "statisch zugewiesene" Tiers vs Owner-E1 dynamisches Dock-Array.
ORT: thesis kapitel/de/03_messsystem_prtart.tex:1455-1459
SOLL/FIX: Thesis-Text auf K4-Stand bringen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: V-15 (Register:443: Doku-Widerspruch soll_design.md:286-288 "[[System],[Organ]]" gegen organ-freien Stempel-Kanon)

### [woyk1t3na.json] 16
GEGENSTAND: Register-Sichtbarkeits-Analyse: Von 4 Kettengliedern hat NUR [4] Hybrid eine Registerzeile (V-09); UNSICHTBAR (Register-Treffer 0): Messkurven-Synthese als Posten, Auswertungs-Orchestrator, Doppelquellen-Aufloesung (S-2), Last-Erkennungsheuristik, Release-Rekompilation+Wallclock-Nachmess-LAUF, Multi-Last-Sieger, best_binary_selector-Verdrahtung/#156, REV-DATA-12, S-5/S-7/S-8/S-9. Empfohlener Nachtrag als EINE Register-Zeilen-Familie V-09a AUSWERTUNGS-STRECKE mit 8 Punkten (verbatim im Bericht).
ORT: docs/sessions/20260806-REGISTER-todo-konsolidierung-14-tage.md (474 Z.)
SOLL/FIX: 8 Register-Zeilen nachtragen (V-09a (1)-(8)), 1 streichen (Par.63-T-23/K-5).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Register/Ledger-Pflege

### [woyk1t3na.json] 17
GEGENSTAND: Nullbefunde mit Nenner: Messkurven-Synthese hat KEINEN Betreuer-Beleg (309 Termin-Dateien, 38 Office-Archive entpackt, 0 Treffer -- Owner-/Projekt-intern); Begriff existiert nicht in Thesis (dort "Messkurven-Typsystem") und nicht im ce-Code (Mathematik ohne Namen und ohne Orchestrator); Hybrid-Tier-Binary kommt in Betreuer-Terminen NICHT vor (0 von 309; 109 "hybrid"-Treffer sind andere Bedeutungen); Homonym-Falle: 2 Plaene vom 06.08. behandeln Intel-Hybrid-CPU (P/E+PMC) -- wer "hybrid" greppt, landet zu ~96% dort (12 von 107 plaene-Dateien meinen Hybrid-Tier).
ORT: docs/termine; docs/plaene
SOLL/FIX: bei Suchen Hybrid-CPU vs Hybrid-Tier trennen.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

### [woyk1t3na.json] 18
GEGENSTAND: UNBELEGT-Posten dieses Berichts: (1) "7 Par.H-Forks alle entschieden" (Doc 21 nicht gelesen -- offen ob Einzelsieger oder Pareto-Front); (2) "19 Min/Max-Semantiken je Achse" -- keine Datei gefunden, die je Achse die Optimierungsgroesse festschreibt (Doktrin fordert sie; IST-Selektor kennt nur kleiner=besser); (3) selection_filter_chain-Widerspruch (IST-Anker vs Dead-Code).
ORT: docs/architektur/20_...md:92/:119/:144; 21_SESSION_PLAN_TYPSYSTEM_ACHSEN_ENTSCHEIDUNGEN.md (ungelesen)
SOLL/FIX: an der Quelle rekonstruieren, bevor gebaut wird.
STATUS LT. QUELLE: unbelegt/offen
ABHAENGIGKEIT/FLAECHE: Pareto-Fork H-6

### [woyk1t3na.json] 19
GEGENSTAND: Versions-Lock-Vorgeschichte der Synthese-Eingabe: Verwerf-Token-Liste des Kurven-Loaders 2x semantisch erweitert (150b0ede 26.07. "gesperrt"; 0fdeccff 02.08. "nicht_gebaut") ohne Versions-Bump, weil contract:axis-version-lock seit 19.07. faktisch abgeschaltet war; am 06.08. auf v2 nachgezogen -- betrifft, welche CSV-Zeilen zu Kurvenpunkten werden.
ORT: ce measurement_curve_loader.hpp:3-10
SOLL/FIX: erledigt (v2); als Kontext fuer Kurven-Reproduzierbarkeit registrieren.
STATUS LT. QUELLE: behoben
ABHAENGIGKEIT/FLAECHE: SW-1 (Datei 2, Fund 14)


# DATEI 4: wnfai1iau.json -- "Alle offenen TODOs 23.07.-06.08. einsammeln (4 Quellen-Lenses), adversarial gegen Owner-Direktiven pruefen, konsolidiertes Register"
Enthaelt: konsolidiertes Klassen-Register P0-P4/VOR-ABGABE/OWNER-FENSTER/PHASE-6/NACH-ABGABE (Stand 06.08.), adversariale Befunde B-1..B-17 mit Korrekturen, Widersprueche 1-10, Owner-Direktiven-Massstab D-1..D-95 (verbatim mit Ledger-Zeilen).

### [wnfai1iau.json] 1
GEGENSTAND: P0-Posten (offen): Neuanker-Teil-2/T2-Welle (wf_996f7155, b2-neuanker-format3, CX-B1..B3 + NB-2-Auflagen 1xKRITISCH+5xMITTEL+1xGERING; Skip-Gate-Kollision Glied[5], Realversions-FAIL-OPEN, Preimage-Hex, string_view-Dangling); L1 Buendel-Landung (hebt TABU auf 3 C-3-Dateien auf); TP1+4+1 (Neun-Gates-Inventur + V7.4-4+1-Beweise + G6 J-0..J-5 EINMALIGER Re-Lauf nach L1, Scope-ERGAENZUNG per B-8: + E2E-.rsp-Beweis, Defines literal im realen Tier-Bau, loest flottenweite Neubau-Welle aus); Stempel-/RF-Rest-Verifikation (RF-1/2/6/7/8, G2/#36-Rest, C-3a/C-3b Par.69.9/70.9 -- OFFEN-UNGEPRUEFT, Absorption in Neuanker-Kette unbewiesen, ultracode-Gegenpruefung bei L1; + O-2-SCHLIESSUNGS-Vermerk: O-2 Preimage C1+C6 = Option A, in Format-3-Gliedern [5]/[6] aufgegangen, Ratifikation im L1-Lande-Text).
ORT: Ledger 4239/4287/4265/4297/4384/4217; Fahrplan 20260806-FAHRPLAN-parallel-sequenz-optimiert.md Z.8-12
SOLL/FIX: wie je Zeile; Reihenfolge P0 bindend (D-91: nichts faellt weg, nur Verschiebung).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: L1-Landung; Format-3-Stempel

### [wnfai1iau.json] 2
GEGENSTAND: P1-Posten (offen): Posten 92 (validate-2er vs plan-3er Abgleich/Heilung, "vor Abgabe" Pflicht, Slot nach TP1+4+1 vor B13; Owner E-5: "Noch vor Abgabe bitte"); B13 L18-ETA/headless-CLI (KORREKTUR B-6: wt-b13-eta EXISTIERT NICHT MEHR -- Bau mit NEUEM Branch ab dev, Pflicht-Schritt 1 = Re-Anker-Pass aller W5-Zeilen-Anker; Gate W5/W3 7969b399 erfuellt); B14 GOLDEN-XML + Sync-Gate-Umhaengung (KORREKTUR B-5: wt-b14-golden EXISTIERT live, Widerspruch gestrichen; NEUE KOPPLUNGS-AUFLAGE: line_sizes>64 nur ins golden-XML wenn KF-6-Bau-Teil vor Trigger landet -- OOB-Warnung 62c kLbufBytes abi_adapter:454-464 -- sonst zurueckstellen + Regression/TODO-Vermerk); KF-6 Cacheline-NTTP-Vollausbau Bau-Teil (alle 4 line_sizes {32,64,128,256} HW-gated; Entscheide 74/77/78 nur ENTSCHIEDEN, Bau offen; 77/78-Doku-/Wachen-Auflagen als eigene P2-Zeile).
ORT: Ledger 4366/3939/4211; struktur-audit :327-328
SOLL/FIX: wie je Zeile (verbatim Korrekturen aus B-5/B-6/B-11).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Trigger-Input-Basis golden-XML

### [wnfai1iau.json] 3
GEGENSTAND: P2-Posten (VOR Messbeginn, offen): P2-P8-WIDE-Mess-Schema (Katalog-Quelle in A8-S3-Backups lokalisieren + Schema-Delta beziffern, dann ce-Bau); A1-Scheibe Wurf-Vertrag (Posten 71 PmrResourceAdapter-nullptr, 72 Ueberlauf-Wache n*sizeof, 73 cacheline-Default-Literal, 74 OOM-Roh-Route layout_aware append_slot); Lager-Kaskaden + xlsx-GERUEST (B12; xlsx=DEFAULT, Strategy CSV XOR xlsx -- D-80; Fuellung -> P4); B5 Mess-Schnitt-Fenster (T6-Einsammel-Naht + Posten-68 Option B; Namenskollision B5 != B-5-Lebend-Check); #46b-Restumfang (G3-Rest: XML-Bestandslog-Persistenz, avg_size-Log, Gleichverteilung/Takeover -- Restumfang unbeziffert, bei P2-Start abgrenzen); NEU per B-15: G-E3-Host-Binder (mess_bestand_*-Verdrahtung Iterator->Messwert-Lager, 3 cfg-Felder 0 Konsumenten -- deklarierte Luecke L3790); NEU per B-11: Posten-77/78-Auflagen (kReal16-Doku+Pin-Wache; XorFilter-FN-Einschraenkungs-Doku inkl. Thesis/Messbild PFLICHT).
ORT: Ledger 3936-3946/4222/3434/3790; Fahrplan Z.12-14
SOLL/FIX: wie je Zeile.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Leitplanke 4 (Messwert-Lager vor Messbeginn)

### [wnfai1iau.json] 4
GEGENSTAND: P3-Posten (Trigger/Voll-Bau, offen): Trigger + Voll-Bau-4 (#215) MIT bindender Trigger-Checkliste (per B-9): 7-Auflagen-Satz LEDGER:98 woertlich + gruene Emission ALLER W-Wellen + J-Hygiene L2 + D-10-Eichung L11 + aktiver Bestandslog-Provider + P11-Env-Check; Phase 6 = USER-GO-STOPP (O-1 Mess-GO); Lager-Gate G1 (#27 B/C/D + amd24, OFFEN-UNGEPRUEFT, #27-Nummernraum mehrfach belegt); Ebene-B-Push-Aktivierung (G4/P-A #34/#33 -- MinIO-Push in emittierten Batch-Jobs INERT, Aktivierung vor/mit Voll-Bau); Lager-Gate G5 GESTRICHEN (per B-3: SUPERSEDED durch Owner-A8 + Additiv-Doktrin; Nachfolger OWNER-FENSTER O-3 Loesch-GO); Forecast-Platzpflege + df-Wache (Ist-Update per B-12: prod1 60G frei/75%, prod2 141G, Spiegel-Annahme widerlegt; offen: Infra-Lane builds_dir/cache_dir-Umzug + Cleaner + FF_USE_LEGACY_S3_CACHE_ADAPTER=false-Test, Handouts 5d3842e/7e2091f; df-Wache beider Maschinen WAEHREND Voll-Bau); OD-7 Runner-Zahlen WIDERSPRUCH (einzige bekannte aktive Abweichung von einer Owner-Direktive: normal blieb 3/2 statt 2/2, heavy prod1 16 Kerne statt 24 Worker -- vor Voll-Bau klaeren); E8 PMC-Beleg-Form (OFFEN-UNGEPRUEFT, Methodik-Bestaetigung im Landungstext nicht auffindbar); B9 P11-Pre-Flight UMKLASSIERT aus P4 nach P3 (per B-2: P11 traegt Ebene-B-Enumerations-Nachholung + Env-Check DES Voll-Bau-4 -- nach Trigger sinnentleert).
ORT: Ledger Par.65/Par.66 L3440-3531; Par.69.6 L3570; L4171-4185; Fahrplan Z.9/15/19
SOLL/FIX: wie je Zeile.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Trigger-Ziel; OD-7 = Owner-Direktiven-Abweichung

### [wnfai1iau.json] 5
GEGENSTAND: P4-Posten (nach Trigger, offen): honest-empty (KORREKTUR B-7: NICHT landebereit -- Codex kippte auf NACHBESSERN: [HOCH] echte-0-Klassifikation + [MITTEL] 3D-Phantom-Vertex; NB-Welle honest-empty-nb; Landung nur nach beidseitigem Dual-Verdikt); NEU: 1xN-/Nx1-Matrix-Fatal im diagram_generator (bricht bei nur 1 Algo ODER 1 Workload fatal -- Bestandsfehler); B-5-Lebend-Check (E-2b Voll-Korpus, blockiert auf honest-empty); E-18-Aktivierung (Gate-KORREKTUR B-1: R2 ist ENTSCHIEDEN = development, E-1 frueh-6 L4328 -- Rest-Gate NUR B-5-Lebend-Check + Opt-in-Var COMDARE_ANHANG_FORWARD); E18-SNAP (datierter Snapshot-Ordner measurement/thesis_compiles/JJJJMMTT-HHMMSS/, Vorzieher per Owner-Max-Parallelitaets-GO, kein P0-P4-Bruch); Graph-Umbau 2D/3D; B12-Fuellung; B2 E-04-Vollausbau (KORREKTUR B-4: Widerspruch gestrichen -- 92ad8357/63406ce3 zur Falte 037300a6 vereinigt L3656; Umfang inkl. Mess-Phase-Marker-v2); B3 OS-U4/A14-Rest + Z-04-Tests (OS-U3 0 produktive Konsumenten); B4 A4-12-Perm-Paket + FS1-Testschuld (iterator:1812; Terminrisiko "spaetestens vor Messung" vs P4); B8 nur noch Zitat-Drift-/Referenz-Heilung (J-Hygiene+D-10 -> P3); B11 Posten 19 stale build/ (VORSICHT: build/ enthaelt getrackte Mess-CSV).
ORT: Ledger 4318/4320/4306/4219-4222; Tab. B; Fahrplan Z.13/16
SOLL/FIX: wie je Zeile.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: E-18-Kanal; honest-empty-NB

### [wnfai1iau.json] 6
GEGENSTAND: VOR-ABGABE-Posten: R-G/OD-2/OD-1-Refactoring-Buendel -- SPLIT per B-14: R-G = ERLEDIGT-BELEGT (L22-STRUKT-R-Quittung L3789 kSystemAxisOrder==DREI + compile-harte Abgangs-Wache load_framework; A13-M2 [5] L3649); Rest OD-2-Wrapper-Vollform + OD-1-telemetry-Dual-Zeile = OFFEN-UNGEPRUEFT, reiner ultracode-PRUEFPASS bei L1 (kein Bau-Buendel vor Abgabe).
ORT: Ledger Par.69.1-69.3 L3560-3564; L3789/L3649
SOLL/FIX: Pruefpass bei L1.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: L1-Fenster

### [wnfai1iau.json] 7
GEGENSTAND: OWNER-FENSTER: R2 E-18-Zielbranch ENTSCHIEDEN (development) -- aus dem Fenster streichen; NEU O-3 Loesch-GO (lokal->0-Rueckbau/Pruning + Alt-Bestands-Loeschungen NUR mit explizitem Owner-GO; Nachfolger von G5); O-1 Mess-GO (= Phase-6-USER-GO-STOPP, deklaratorisch); Map-Gattungs-Kern-Reichweite OFFEN (zaehlen SA-Zusatz-Subinterfaces zum Map-Gattungs-Kern? deklariert in idriveable_tier.hpp:31-34, keine Owner-Antwort gefunden).
ORT: Ledger 4318/4328/4394; gattungs-diskrepanz :369-373
SOLL/FIX: wie je Zeile.
STATUS LT. QUELLE: offen (Owner-Fenster)
ABHAENGIGKEIT/FLAECHE: -

### [wnfai1iau.json] 8
GEGENSTAND: PHASE-6-Posten: E7 Multi-Thread-Messflaeche (T8/q1) -- Multi-Thread vs 1-Thread-Kanon ist Phase-6-Doktrin-Frage; Default 1-Thread bleibt bis dahin.
ORT: achsen-katalog :829-830; Ledger 3833
SOLL/FIX: in Phase 6 entscheiden.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [wnfai1iau.json] 9
GEGENSTAND: NACH-ABGABE-Posten (Register + B-10-Pflichtzeilen): SF-1 anatomy->builder-Aufwaertskante (container_framework.hpp:37, einziger echter Schnitt-Fehler, Owner-terminiert); SHORTCUT-R1 T6-Peak-Quelle (Peak n/a statt Zeitreihe, bewusst, als Regression+TODO); E4+E14 Registry-Erweiterungen (T17-Min/Max-Semantik; Filter-"ohne"-Luecken T14/T16/C-A -- golden-320-Bruch, eigenes golden-Neuanker-Fenster); E10 Container-Varianten (bestaetigt nach Abgabe, entschaerft: GoldenRatio/FixedChunk/Exact existieren); Writer-Backend io_uring/IoRing (geparkt, Einordnung Phase-4 vs Nach-Abgabe uneindeutig); Tools-Lagerhaltung #32; K5 Template-Parametrisierung; A8-S6 17 stale-Kommentar-Stellen; Aufraeumpass-Posten 33-53 (SetDock-Doppelschicht; Nummerierungs-Drift; SA-Dock ohne dock_version(); 29 K1-Prosa-Stellen; kAdapterCompositionSlotCount 13 vs live 11; 4 perm_*-Module ABSICHTLICH defekt -- NICHT reparieren; abi->builder-Altkante V32-Insel; topics->anatomy Ziel-Ort; organ_location.hpp 79 Aufwaerts-Konsumenten; builder/-Duenn-Verzeichnisse + thread_pinning-Einordnung; axes/ vs topics/ Doppel-Wurzel EIGENES FENSTER; Terminologie-Sweep 176+18; stale-Zahlen-Kommentare; G8-Par.1.2-Dateitabelle nicht nachgezogen; SA-Matrix-Asymmetrie; e24-Label-Nachzug 18/37; 3 Testnamen ohne test_-Praefix; Posten 50 trunkiert nicht rekonstruierbar; ce docs/INDEXe fortschreiben; dt. Einzeldatei; Kompositions-Platzierungs-Asymmetrie); Par.75-Startliste a-f; Pflicht-Kette R3-Rest -> #35-.so-Schnitt -> #54-Endform-XML (Option b) -> W3-Vollausbau (Pruefstand-Deep-Research-Tests F5) -> W2-Codegen-Zielform + W-11 Cache-Key-Einfaltung -> K1-K4-XML-Rueckfragen (gebuendelt VERBOSE); Planer-Takt-Vollausbau R6; Key-/Value-Filter-Achsen A5 (MAP grundsaetzlich Key- UND Value-Filter-Achse; Posten-60-Umzug; T13-vs-T16 Owner-Architekturentscheid; 4 Value-Optionen unbewertet); Overlay-Fenster (3 Owner-Festlegungen + Glied-[7]-Scharfschaltung); f2/f3-Remote-GOs; Posten 90 (Hybrid-Doc GoF+CT-Weitergabe); Posten 91 (Hinweis-Regeln); Vortrag D-15; Par.75-Abschluss-Aufraeumpass als EIN Paket (ultracode VOR+NACH, inkl. Waisen-TU-7, ASCII-Sweep GA-08, V36.B-TEIL-V-Retire, Par.75-NICHT-KANDIDATEN-Freihaltung HY-D2); thesis_profiles-Ort (Kenntnis); axes-interner Rekursions-Sweep (optional).
ORT: Register-Tabellen; g8_negativliste :239-244; struktur-audit :133-188/321-340; Ledger 3601/3804/3833/3848/4309
SOLL/FIX: wie je Zeile; KEIN Posten wird gestrichen (D-91).
STATUS LT. QUELLE: offen (by design nach Abgabe)
ABHAENGIGKEIT/FLAECHE: 75er-Fenster; golden-Neuanker-Fenster

### [wnfai1iau.json] 10
GEGENSTAND: ERLEDIGT-Belegregister (nicht doppelt bauen): RAM-Sammelpuffer-Kern (B6-SpoolWriter+W11-Async-Push-Pump); VERLUSTNAHT measure_out (03.08. geschlossen, experiment_plan_director.hpp:1015-1020/1379-1386); PMC-Preflight #37 (gebaut :1269-1280); A3 kSystemAxisOrder=3; OD-10 NUMA/page-Umbau (17 Testfaelle, Gate 331->332); Posten 64 StdAllocatorAdapter (Gate 388->389, ce fb623528); B7 V4-Owner-Vorlage (A1-A9 beantwortet); B1 E-18-Kanal BAU (ce 253bcd86 + super anhang:forward 8131a9a2); B6-Entscheid-Teil (74/77/78 Variante a); super main-FF-Stand (da269bdc); FK-8-Etiketten; Graph-Sweep ausserhalb Anatomy; E1-E4-Dossier-Strang (6/8 erledigt/superseded, #215=Voll-Bau-4); G3-Kern.
ORT: Register ERLEDIGT-Tabelle
SOLL/FIX: als erledigt registrieren.
STATUS LT. QUELLE: behoben
ABHAENGIGKEIT/FLAECHE: -

### [wnfai1iau.json] 11
GEGENSTAND: Explizite Quellen-Widersprueche (10): (1) OD-7 Runner-Zahlen (einzige aktive Owner-Direktiven-Abweichung); (2) B9-Platzierung (geloest: P3); (3) B4-Termin "spaetestens vor Messung" vs P4-Band; (4) B2/E-04 (geloest: Falte 037300a6); (5) B12/xlsx Split Geruest(P2)/Fuellung(P4); (6) B14-Welle (geloest: wt-b14-golden existiert); (7) E8 ohne Methodik-Bestaetigung; (8) Writer-Backend-Einordnung uneindeutig; (9) Namenskollisionen (B5 != B-5; R2 != R2 Driver-Split; Aufraeumpass-Posten 36/37 != #36 Stempel / #37 PMC-Preflight; #27 mehrfach); (10) RF-/G2-/C-3a-Absorption unbewiesen.
ORT: Register-Abschnitt WIDERSPRUECHE
SOLL/FIX: je aufgeloest wie B-Befunde bzw. offen klaeren (1,3,7,8,10).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -

### [wnfai1iau.json] 12
GEGENSTAND: Erfassungsluecken der Eingaben: Ledger ohne Nachtrag-Header 28.-31.07. und ohne 01.08.-Block (Fensterluecke); Register-Eingabe trunkiert (Gruppe 2 endet mitten in E10; Gruppe 3 super-Kandidatenliste fehlt vollstaendig; Tabelle B endet mitten in B14) -- Restposten koennen unerfasst sein; NACH-ABGABE-Pflichtzeilen gegen trunkierten Teil gegenzeichnen.
ORT: Register-Schlussteil; Vollstaendigkeits-Vermerk
SOLL/FIX: bei Verwendung neu erheben; 2 Zeilen verlangen Pruefung IM L1-Fenster (Stempel-/RF-Rest inkl. O-2-Ratifikation; OD-2/OD-1-Pruefpass).
STATUS LT. QUELLE: offen (Vorbehalt)
ABHAENGIGKEIT/FLAECHE: -

### [wnfai1iau.json] 13
GEGENSTAND: Owner-Direktiven-Massstab D-1..D-95 (23.07.-06.08., verbatim mit Ledger-Zeilen) -- als Pruefmassstab vollstaendig in dieser Quelle; Kern-Highlights: D-7/Par.66 Lagerhaltung+Stempel = Gate fuer Voll-Bau; D-9/D-10 PMC-Pflicht je deklarierter Lane; D-11 Mapping-Reinheit (variant: CEB geduldet, Tier verboten, Hybrid Ausnahme); D-15 Test-Skip-Gesetz; D-21 OD-7 Runner-Zahlen (heavy prod1=24 Worker); D-24 Par.70 RF-1..RF-8 (KERN=Gesetz); D-27 Par.73 Ein-Hauptkanal + g++ 15.3 Minimum UND Standard (KEIN g++-16-Pin; vgl. D-89 "wir arbeiten mit gcc 15.3, neueste ueberhaupt existierende = gcc 16"); D-28 Pipelines hart gruen, interruptible abgelehnt; D-29 persistence_target = 18. Organ-Haupt-Achse; D-33 F5 golden SOFORT brechen; D-36 Par.75-Aufraeumpass; D-39..41 HW-Erkennung Factory zur Laufzeit, zweigeteilte MESS-Achse; D-46 Stempel: Meta-Meta ans Realm-Ende, merge-Zeile darf NICHT existieren, e-Suffix; D-48 Versions-Flag-Grammatik dreistellig+HW-Flag; D-57 generalisierte Schnitt-Regel (ALLE Achseneigenschaften NUR ueber Achsen, Ausnahme Genus-Erst-Instanziierung); D-72 R4-Dauer-Regel (saubersten Weg IMMER als Nach-Abgabe-TODO) + R6 Planer taktet selbst; D-73/D-74 Stufen-Symmetrie (Mess DREISTUFIG, System ZWEISTUFIG, Organ ZWEISTUFIG; Hybride erben alles); D-78 DUAL-REVIEW-PFLICHT Codex+Fable; D-79 Atlas IMMER gegenpruefen; D-80 xlsx XOR csv Strategy; D-83 Explore = Sonnet 5 max very thorough (Anm.: temporaer durch MEMORY-Regel "ueberall nur Fable 5 max" ueberschrieben); D-91 P0-P4 BINDEND + Vollstaendigkeits-Auflage; D-93 E-1..E-5 (E18-SNAP; 2D/3D-Graphen statt Heatmap; 9pm-Schwelle; xlsx zuerst + Shortcuts als offene Regression notieren; Posten 92 vor Abgabe) + Gesamt-GO bis zur Messung (Messung = USER-GO-STOPP).
ORT: wnfai1iau KEY direktiven (D-1..D-95 mit Ledger-Zeilenankern L3420-4414)
SOLL/FIX: als Pruefmassstab fuer jedes Design verwenden; bei Bedarf verbatim in der Quelle nachschlagen.
STATUS LT. QUELLE: nur-hinweis (Massstab)
ABHAENGIGKEIT/FLAECHE: alle Designs


# DATEI 5: wdfgx3k8f.json -- "A2.5-Luecken-Paket: Triage W0a/W0b-Posten + golden-Artefakt + Wachen-Haertung + allow_failure-Triage + Sicherungs-Paket (Bau+Verify+Fix im selben Lauf)"

### [wdfgx3k8f.json] 1
GEGENSTAND: Triage-Urteile SCHON_ERLEDIGT (nicht doppelt bauen): W0a/D1e f15-CLI Baukante+Wrapper (gelandet 84672350; Rest: 1-Zeilen-Verifikation Inventur-Zeile im naechsten gruenen test:unit-Log); W0a/D1f 5-STATUS_OUT/3-Zustaende (ERROR eliminiert; Zaehl-Drift 5-vs-6 aufgeklaert: 6 Vorkommen/5 Bloecke); W0a/D1c Abdeckungs-Wache dritte Achse fremde Quelle (CI-bewiesen Pipeline 15751; Floor 13.08. neu 489/485/483 am Stand b91b22fc); W0a/D2-G2 (eigener contract-Job test:coverage-guard; optional: x4-TIMEOUT als Job-timeout 84m); W0a/##07 f15-Risse (deckungsgleich mit D1e erfuellt); W0b/D3-8 Frische-Wache (gelandet 028684ac, CI 15764 Job 376333 SUCCESS; Scharf-Schaltung mit ergebnis:holen = W2-Posten); W0b/##20-B-Restbau (gelandet 88464ac7 + 38b6bdbd; pathspec-from-file entfallen, git>=2.25 nicht noetig); W0b/##08-Rest GEGENSTANDSLOS (lazy_csv_header genau 1 Definition/19 Nutzer; "lazy Header-Emission" ist ausdrueckliches BAU-VERBOT).
ORT: je Posten (ce tests/unit/CMakeLists.txt, scripts/ci_test_coverage_guard.sh, ci/frische_wache.sh, ci/anhang_forward_core.sh, schema_freeze.hpp)
SOLL/FIX: Restlisten-Pflege: ##08-Rest und ##20-B-Restbau streichen mit Belegen; Wellenplan-Fussnoten nachtragen.
STATUS LT. QUELLE: behoben/gegenstandslos
ABHAENGIGKEIT/FLAECHE: F1-KERN-Fall: Restlisten fuehrten Erledigtes als offen (Plan-Artefakt)

### [wdfgx3k8f.json] 2
GEGENSTAND: W0a/##06-CI-Haelfte TEILS_OFFEN: kein Job faehrt die VOLLE Bedingungs-Tabellen-Formel (nur test:abnahme06-zusicherung mit --nur-zusicherung); Voraussetzung seit D1c geliefert (ce test:unit publiziert Inventur-Artefakt).
ORT: super .gitlab-ci.yml:1132-1144; scripts/ci_abnahme06_bedingungs_tabelle.sh (Kopf :91-104)
SOLL/FIX: verbatim: "super .gitlab-ci.yml: Job test:abnahme06-voll neben :1132 anlegen; Schritt 1: Inventur beziehen -- entweder per cross-project-Artefakt (curl mit CI_JOB_TOKEN auf das letzte gruene ce-test:unit-Artefakt build/Testing/ctest_unit_inventar.txt, ref development) oder als needs auf einen super-Job, der den vendorierten Baum konfiguriert und 'ctest -N' nach datei schreibt; Schritt 2: Selbsttest, dann Skript mit --ctest-liste; Abnahme: die 6 Formel-Zahlen (bedingte_registrierungen=18/bedingungs_klassen=14/erfuellt/allowlist_mit_begruendung/ohne_allowlist_eintrag=0/allowlist_zusicherung_verletzt=0) MIT Host-Kennung literal im Job-Log; kein allow_failure."
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: ce-Inventur-Artefakt

### [wdfgx3k8f.json] 3
GEGENSTAND: W0a/D2-G6 TEILS_OFFEN: 3 Registry-Roundtrip-Gates haengen an Datei-Existenz (CMakeLists :5611/:5641/:5656 "AND EXISTS"), Kommentar :5631-5636 verkauft stille Abschaltung als Merkmal, kein comdare_registrierung_vermerken an den Bloecken (indirekt gefangen durch Floor + D1c-Achse).
ORT: ce tests/unit/CMakeLists.txt:5611-5656
SOLL/FIX: (a) an allen 3 Gates else-Zweig mit comdare_registrierung_vermerken STATUS UEBERSPRUNGEN + GRUND; Kommentar "bewaffnet sich automatisch" durch Pflicht-Erwartung ersetzen. (b) Standard-Bissprobe: system_axis_registry.xml per git stash entfernen, configure, Guard MUSS rot mit Namen und "Inventur N, Untergrenze M, Differenz -k", stash pop, Gegenprobe gruen; Protokoll ins Paket (Koeder beidseitig, K13).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -

### [wdfgx3k8f.json] 4
GEGENSTAND: W0b/D3-4+D3-5 TEILS_OFFEN: allow_failure-Emission entfernt (+Objekt-Test), Testat-XOR gebaut, Byte-Determinismus-Tests da, Inhalts-Gate super-seitig KOMPLETT inkl. n/a-Zaehler (a1ee9780, CI 15764) -- der KON58-11(c)-Bauposten n/a-Zaehler ist am Objekt SCHON ERLEDIGT, nur der Ledger fuehrt ihn als offen (F1-KERN-Fall). OFFEN am emittierten Grandchild-Batch: (i) KEIN Inhalts-Gate je Batch in der emittierten YAML; (ii) Batch-Bilanz A+B==C nirgends.
ORT: ce experiment_plan_director.hpp:1546-1549/:1679-1697/:1720; super ci/mess_ausbeute_wache.sh:258-347
SOLL/FIX: verbatim: "Im Director (Mess-Batch-Emission vor 'exit $FAIL' :1720): Zaehler emittieren -- A=$((A+1)) im else-Zweig (MESS-TESTAT), B=$((B+1)) im FEHLER-Zweig, C als Literal aus perms.size(); danach 'echo \"[BATCH-BILANZ] gemessen=$A fehler=$B zellen=C\"; [ $((A+B)) -eq C ] || exit 1'. Inhalts-Gate je Batch: awk-Inline-Gate emittieren (echte Datenzeilen ueber measure_out/<slug> >= 1, n/a zaehlt NICHT -- awk-Muster byte-gleich zu ci/mess_ausbeute_wache.sh:262; super-Wache im ce-Grandchild-Klon nicht verfuegbar). Byte-fixierte Unit-Test-Literale im SELBEN Commit; T-1 rot zuerst (Mutant: FEHLER-Zelle erzeugen, Bilanz muss reissen)."
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: KON44-01 via KON47-01/a geloest (Strang C 5f4024af im ce-HEAD); Ledger-Korrektur n/a-Zaehler

### [wdfgx3k8f.json] 5
GEGENSTAND: W0b/##23-R1 TEILS_OFFEN: xlsx-blind heute 3 von 11 Profilen (27%), nicht mehr 8 von 9 -- base_pilot, m3v2_smoke, wdk_fairness_example ohne xlsx-Element; alte Zaehlung ueberholt (Gitlink-Hub drehte Stand).
ORT: ce libs/cache_engine/algorithm_profiles/thesis_profiles/*.profile.xml (Stand 5f3f26a5)
SOLL/FIX: in den 3 Profilen Block aus m3v2_study.profile.xml:181-183 additiv uebernehmen (<method value="xlsx"/> + Kommentar); Abnahme: alle 11 Profile grep -c xlsx >= 1 (Nenner 11). ADDITIV halten -- S-13 (#18, W2 Di 25.08.) schneidet Export-Element neu und darf ersetzen, nicht umgekehrt. Landung im naechsten ce-Slot NACH der laufenden Wellen-Landung (ce Lande-gesperrt).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: S-13/#18; ce-Schreibsperre

### [wdfgx3k8f.json] 6
GEGENSTAND: W0b/##26 TEILS_OFFEN: measure-Gate-Formel N>=1 UND M==N UND Z>=1 -- N>=1 hart, Z>=1 hart (modus=voll), ABER M==N nur WARNUNG (:355-358 "Der Lauf gilt als gelungen") -- widerspricht korrigierter v2-Formel (:27) und v1-Koeder (:593).
ORT: super ci/mess_ausbeute_wache.sh:239/:334-358
SOLL/FIX: verbatim: "Nach der Luecken-Dauerregel den harten Zweig bauen: nach :355 'if [ \"$N_LEER\" -gt 0 ] && [ \"$MODUS\" = voll ]; then echo FEHLER ... exit 1; fi' (Warnung bleibt fuer provision_only/pruef_only); Bissproben-Fall ergaenzen: 2 CSVs, eine auf Kopfzeile reduziert => rot mit 'M von N', Gegenprobe gruen. Falls die weiche Form fachlich gewollt bleibt, stattdessen die ##26-Formel im Wellenplan v2 per datiertem Nachtrag ans Objekt angleichen und das Owner-Zitat als Begruendung setzen -- NICHT beides stehen lassen."
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Wellenplan-v2-Formel

### [wdfgx3k8f.json] 7
GEGENSTAND: W0b/##27-##31 GANZ_OFFEN: ##31 Wachen-Register NICHT gebaut (0 Treffer in beiden CIs; wachen_paritaet.sh ist NICHT das Register); ##27-##30 haben KEINE auffindbare Einzeldefinition (nur Nachlauf-Sammelzeilen) -- Nummern derzeit ohne Gegenstand; per v2:1742 bewusst hinter S-2 geschoben.
ORT: Wellenplan v2:686/688/1357/1742
SOLL/FIX: Im Slot hinter S-2, nicht vor F1: (1) ##31 nach v2-Formel bauen -- Grundmenge je Lauf frisch zaehlen (alle ausfuehrbaren .sh unter ci/+scripts/ beider Repos: heute super 17+14+11, ce ~25; plus verdiktdruckende CI-Jobs plus ctest-Eintraege mit PASS_REGULAR_EXPRESSION), Abgleich beidseitig rot, je Wache ein GEFAHRENER Koeder, Rueckfallstufe manuell versioniertes Register. (2) Fuer ##27-##30 ZUERST Definitions-Explore in GOAL-v8-Rohquellen/Einwandslisten; ohne Gegenstand je Nummer als GEGENSTANDSLOS ausbuchen mit 0-Treffer-Beleg.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: S-2-Slot

### [wdfgx3k8f.json] 8
GEGENSTAND: W0b/#21-Pruefposten E-1..E-4-Vollzug GANZ_OFFEN: NIE GEFAHREN (V-8 Ledger :4123-4124 "Vollzug UNBELEGT"; kein KON zwischen KON24 und KON58 bucht Pruefung); Gegenstaende E-1 = still gekuerztes Owner-Zitat KON11-03 (Weg C FunctionInterfaceReroute), E-2=K1, E-3=K2, E-4=K5 (Ledger :13180-13182); moeglicherweise durch KON41/KON42/KON45 teilueberholt. Dringlichkeit NEU erhoeht: KON58-04 Befund 3 (backup-ref auf beiden origins verschwunden, ungebucht) verlangt A-1-Vorlagetext JETZT; #21 gate-t die #10-Ref-Haelfte.
ORT: Ledger :4123-4124/:13180-13182; Roh ~Z.35872 (A-1-Vorlagetext)
SOLL/FIX: Pruef-Explore (READ-ONLY, Fable 5 max): je E-Entscheid Rohtranskript-Zitat ziehen, am Objekt pruefen ob vollzogen oder ueberholt; A-1-Vorlagetext woertlich in die KON58-04-Owner-Vorlage uebernehmen; Ergebnis via scripts/ledger_nachtrag.sh verbuchen; #10-Ref-Haelfte entsperren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: KON58-04 Owner-Vorlage; #10

### [wdfgx3k8f.json] 9
GEGENSTAND: #81 Owner-Auftrag Wiederhol-Verify ueber W0b-Bauposten GANZ_OFFEN: 0 Treffer "#81" im Ledger (26997 Z.); Owner woertlich 20260811-KONTEXTUEBERGABE:67-75 "der verify ... muss wiederholt werden, sobald w0b fertig zurueckkommt" inkl. Pflicht "er muss die Pipeline messen"; WF1-BERGUNG-verify-ABCD ist ein ANDERER Verify; Teil-Beweise ersetzen den Wiederhol-Verify nicht (erster Durchgang kannte P-GLIED und Folge-Commits nicht).
ORT: docs/sessions/20260811-KONTEXTUEBERGABE-der-tag-an-dem-die-riegel-zurueckschlugen.md:67-75
SOLL/FIX: Verify-Workflow nach A1/v3.6 (Anm.: temporaere MEMORY-Regel = ueberall Fable 5 max): Gegenstaende = W0b-Endstaende (mess_ausbeute/frische/lauf_marker/persist_sammler/anhang_forward + emittierte Director-YAML) am Stand super HEAD + ce 5f3f26a5, MIT Pipeline-Messung (15764-Trace je Wache, Job-IDs zitieren); Ergebnis mit #81-Referenz via ledger_nachtrag.sh verbuchen. Startbar sofort; ce nur lesen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Wellen-Landung

### [wdfgx3k8f.json] 10
GEGENSTAND: Zaehlwerk 137-vs-123 Flag-Literale AUFGEKLAERT (Scope-Differenz, kein Drift): 123 = same-line im Organ-Scope (97x 1.0.0.c + 24x 1.0.2.c + 2x 1.0.1.c; 122 Dateien + 1 Doppel-Literal k_ary); 137 = alle ce-eigenen Literale (123 Organ + 7 System + 6 Mess + 1 Planer, Ledger :6862-6863) => Differenz 14 = 7+6+1; "Differenz 14 unaufgeklaert"-Vermerke (:5272,:5395,:5470) sind zu schliessen; HEUTE reproduziert 137 nicht mehr (same-line ausserhalb axes/topics = 0; telemetry inzwischen CEB-System-Achse KON58-13).
ORT: Ledger :5272/:5395/:5470/:6862-6863; ce libs/cache_engine/axes+topics
SOLL/FIX: Ledger-Vermerke schliessen; Kommandos verbatim in der Quelle.
STATUS LT. QUELLE: behoben (aufgeklaert; Ledger-Nachtrag offen)
ABHAENGIGKEIT/FLAECHE: -

### [wdfgx3k8f.json] 11
GEGENSTAND: Zaehlwerk #67 "142 Include-Kanten / 29 Wanderungen": Kanten-Definition fuer 142 EXISTIERT NICHT (0 Belegstellen; Owner :4528 "Bitte explore und schaerfen, behalten"); 29 reproduzierbar unter sauberer Definition (Familien-Header basename version|stamp|semver|fingerprint, 24 Dateien; eingehende Include-Zeilen = 29; repo-weit 39); 142 reproduziert KEIN heutiger Schnitt (ausgehende Kanten 175; Wanderungskosten-Summe :8722 = 60).
ORT: Ledger :4528/:4630/:5789/:8722
SOLL/FIX: fuer S-6d/#67 die 29er-Definition als Kanten-Definition in den Wellenplan uebernehmen (Kommando ausgeschrieben in Quelle), 142 als historisch ohne Definition markieren.
STATUS LT. QUELLE: offen (Doku-Nachzug)
ABHAENGIGKEIT/FLAECHE: S-6d

### [wdfgx3k8f.json] 12
GEGENSTAND: Zaehlwerk KON11-01-Elferliste am Stand ce 5f3f26a5: 4 Zeilen WIDERLEGT (1 ExperimentPlanDirector hat 16 Konsumenten + CI-terminal 15764; 3 axis_version_lock v3 718 Records deckt 712/712; 7 IResourceControllableTier 5+ Nutzer; 11 Hybrid 955 Zeilen MIT Stempel-Bezug, KON45-01 traegt), 1 teilwiderlegt (2 LagerBaumWriter: Test ja, aber weiterhin 0 Produktions-Aufrufer), 5 STIMMEN NOCH: (4) run_selection_filter_chain 0 Produktions-Konsumenten; (5) ram_probe_chain unveraendert; (6) AxisCommand nur familienintern; (8) i_command.hpp GEPARKT als V32-AUSNAHME (#267); (9) v32_messreihe_antrieb existiert. admit_organ als unverdrahtet ebenfalls widerlegt (5 Dateien).
ORT: ce (je genannt); Ledger :5385
SOLL/FIX: Elferlisten-Reste (2,4,6) als echte offene Verdrahtungs-Posten fuehren; widerlegte Zeilen im Ledger korrigieren.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: KON11-01

### [wdfgx3k8f.json] 13
GEGENSTAND: A/E-Mengen-Erhebung fuer Lande-Slots: STRANG A (S-6a) Kern = 3 abi-Header (anatomy_module_abi_v1, _decl, anatomy_fingerprint) + 4 Zwillinge + 5 Stamp-Nachbarn; Wirkmenge 41 Dateien; STRANG E (B2/B3/B5-Gates) 12 Dateien; SCHNITTMENGE NICHT leer: 3 harte Include-Kanten (mess_konsistenz_gate.hpp, lazy_adhoc_source_gen.hpp, ceb_version_stamp.hpp) + Glied-[3]-Inhaltskopplung (mess_achsen_naht.hpp) + 1 gemeinsamer Test (test_r3_mess_gates_spiegel).
ORT: ce libs/cache_engine/include/cache_engine/abi/; builder/pruef_dock/; profile_facade/
SOLL/FIX: FOLGE fuer B5-Lande-Slot (vor Mo 17.08. fixieren): B5 darf NICHT parallel zum S-6a-Fenster fahren; B5 seriell HINTER S-5 -> S-6a in dasselbe W1-Fenster (ein Schreiber je Datei); B2/B3-Hybrid-Gate-Anteile parallelisierbar (4 hybrid-Gates disjunkt); einzige geteilte B2/B3-Datei mit S-6a-Naehe = mess_achsen_naht.hpp -- dort denselben Seriell-Slot.
STATUS LT. QUELLE: nur-hinweis (Slot-Planung)
ABHAENGIGKEIT/FLAECHE: W1-Fenster, Ein-Schreiber-Regel

### [wdfgx3k8f.json] 14
GEGENSTAND: Bau-Stufe-1-Commits (super, LOKAL, nicht gepusht): 367d732c GOLDEN-VERSION-Registry (docs/golden/GOLDEN-VERSION.md, G-2026-07-26, 4 Fixtures je 320 ids mit sha256, NE-13 BLOCKIEREND BEHOBEN); e8126eb1 KON59 Ledger-Korrektur admit_organ_on_machine ("vorhanden, aber inert" statt "kein Produktionspfad"; build_orchestrator.hpp:761 produktiv seit 19.07., inert weil required leer); 6316c2d2 BU-SOFORT 7 von 8 Task-Outputs; 8f4b4f1a Blind-Smoke + Loeschregel-Wache (minio_blind_smoke.sh + worktree_remove_safe.sh); e3e75350 KON59-Marker-Nachzug 13 Stellen; 3ce69ed2 Designplan Par.11 (T-11a Warmup-PAAR, T-11b Kombibau-2x2, T-11c Mutations-Protokoll; Summen 117/386h nicht angefasst); 2142439 ARBEITSWEISE v4.1 gitleaks-Koeder-Regel (committet UND gepusht).
ORT: /home/comdare/wt-super-landung (development, lokal voraus); /home/comdare/Projekte (Umbrella)
SOLL/FIX: Lead pusht gesammelt; Pipeline-Gruen des Umbrella offen (Fund 20).
STATUS LT. QUELLE: behoben (lokal), Push/Pipeline offen
ABHAENGIGKEIT/FLAECHE: Diff-Hygiene push-lokal

### [wdfgx3k8f.json] 15
GEGENSTAND: Bau-Stufe-2-Commits (super, LOKAL): 76a345e3 anker_wache + tests_registrierung_wache Stufen-Form (WIP-Uebernahme geprueft); 5d67207b 8. Backup-Output (Secret-Scan nachgeholt: grep-Treffer war Prosa-Falsch-Positiv "glpat-Regel-Klassen-Lehre", gitleaks 0 findings); eacd3182 minio_blind_smoke pipefail-Mindesthaertung + host_klassen_bericht Stufen-Form; 58b5aff4 + 1e31cd4b vor_push_alle_wachen.sh INVENTAR-MODUS (M=26; 13 gefahren, 13 je Zeile begruendet ausgeschlossen; beide Richtungen ROT; fehlendes Werkzeug ROT; T-1 Koeder rc=1/Gegenprobe rc=0); 83e06159 NE-20 ergebnis:holen deklarierte Ausnahme + KETTEN-RISS-Fix (OK-Zeilen measure:smoke/golden-320 an realen Anhang-Lauf gebunden via ANHANG_GRUND-Sammler; latenter pipefail-Jobtod geheilt).
ORT: super ci/ + scripts/ + .gitlab-ci.yml
SOLL/FIX: als gebaut registrieren; NE-19a-Nenner: 38 sh, 3 mit pipefail, 34 dash (pipefail dort nicht verfuegbar -- Stufen-Form die passende Haertung).
STATUS LT. QUELLE: behoben (lokal)
ABHAENGIGKEIT/FLAECHE: -

### [wdfgx3k8f.json] 16
GEGENSTAND: VERTAGTE ce-Posten (ce schreibgesperrt wegen Wellen-Landung 5f3f26a5): (a) NE-19a-Kampagne ce-Wachen (Lens-B-Fund 34 von 36 ohne pipefail; Shebang-Klassifikation zuerst; super-Fassungen 76a345e3/eacd3182 als Vorlage); (b) vor_push_alle_wachen.sh im ce auf INVENTAR-Modus heben (58b5aff4 Vorlage); (c) NE-20-Triage ce arm64-smoke (:257) + is_original:relock (:898 -> :919 am 5f3f26a5): je Stelle pruefen ob Infra-Grund traegt; wenn ja DEKLARIERTE-AUSNAHME-Kommentar in 83e06159-Form, wenn nein allow_failure entfernen; (d) NE-16 (T-6-Wachen-Inventar kennt S-14a-Job nicht) + NE-10 (S-3/S-7 je Seite mit 2 Zahlen belegen; bvset_ist_teilmenge 2 Produktions-Treffer).
ORT: ce scripts/ + .gitlab-ci.yml
SOLL/FIX: nach Ende der Schreibsperre; Anker-Drift dokumentiert (relock :898->:919, super ergebnis:holen :2751->:2809).
STATUS LT. QUELLE: offen (vertagt)
ABHAENGIGKEIT/FLAECHE: ce-Schreibsperre; KON59-02-Triage Stufe 2

### [wdfgx3k8f.json] 17
GEGENSTAND: Offene Punkte des Laufs: (1) ci/tests/-Probes (14 dash-Dateien) Urteils-Pipe-Einzelhaertung = EIGENES Paket (~360 KB Skripttext), ausgewiesen nicht mitbehauptet; (2) ci_xml_wellformed_guard.sh Zaehl-Pipes mit || true bei Probes-Kampagne mitnehmen; (3) KONKURRIERENDER super-SCHREIBER beobachtet (Wellen-Landung committete 6c4cc130+01e091f6 waehrend des Laufs -- disjunkt, kein Schaden, gemeldet); (4) Lauf-Logs unter /tmp fluechtig (vpw_final.log u.a. -- bei Bedarf sichern); (5) Anomalie minio_blind_smoke_v2.sh 261-Byte-Fragment ENTLASTET (Duplikat-Stub, bleibt nur im Sicherungs-Branch).
ORT: siehe je Punkt
SOLL/FIX: wie je Punkt.
STATUS LT. QUELLE: offen/nur-hinweis
ABHAENGIGKEIT/FLAECHE: Ein-Schreiber-Regel

### [wdfgx3k8f.json] 18
GEGENSTAND: Verify-Urteil TRAEGT_MIT_FIXES; Funde: (1) b2-Quittung fuer 5 von 6 Stufe-2-Commits nie uebermittelt (Objekte unabhaengig entlastet; Text-Gegenlese an naechsten Verify); (2) NE-11b "bash+sh -n ok" ueberbreit (sh -n rc=2 auf minio_blind_smoke.sh Array-Syntax; BEHOBEN f3017a77 Syntax-Gate dokumentiert); (3) Kommentar "/usr/bin/grep ist hier ugrep" in 2 Wachen faktisch falsch (BEHOBEN e96b67e8: GNU grep 3.11; ugrep ist die interaktive FUNKTION); (4) NE-26-Zitat-Zeile unpraezise (ENTLASTET); (5) NE-27 1 von 28 +Zeilen Non-ASCII = ererbter U+00B7-Trenner (ENTLASTET, Format-konsistent); (6) KON59-02-Zeilenanker gedriftet (VERTAGT an NE-20-Triage Stufe 2 mit gemessenen neuen Ankern); (7) NE-27 PIPELINE-GRUEN offen (kein glab/API-Zugang; Umbrella b7ffecb v4.2; Push->gruen-Doktrin unerfuellt -- VERTAGT an wer Zugang hat).
ORT: Fix-Commits e96b67e8 + f3017a77 (super, lokal)
SOLL/FIX: offene Reste wie je Fund; volle b2-Quittungsliste an naechsten Verify uebergeben.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Push->gruen-Doktrin


# DATEI 6: w56km2g9g.json -- "WF2-SYNTHESE KON15-02 Glieder-Reihenfolge Lager vs. ausserhalb (blockiert S-6) + KON15-01 Register der leeren Klassen"
Stand: 12.08., ce 670483c0, super Snapshot 2ae55a9c / HEAD 012f61c0. 2 Straenge.

### [w56km2g9g.json] 1
GEGENSTAND: Zwei-Welten-Befund (J) beantwortet: IM LAGER zwei Realm-Kaskaden CT-erzwungen und Owner-bestaetigt (Messdaten MESS->SYSTEM->ORGAN(5 Gruppen); Binaries SYSTEM->ORGAN->MESS tiefst, D-12); AUSSERHALB durchgaengig ORGAN->SYSTEM->MEASUREMENT an 11 Belegstellen (9-Glieder-Preimage kAnatomyFingerprintGliedCount=9: Format/Organ/System/Mess-Tooling/Werteset/Toolchain/Bvset/Overlay/MessGates); SOLL lt. Owner 11.08. (KON6-02 Punkt 4): MESS,SYSTEM,ORGAN nach Stufigkeit, "nur das Lager hat hier eine Ausnahme"; IST != SOLL fuer Aussen-Welt, Feldfolge "gewachsen, nicht entworfen" (KON7-09); Aussen-IST ist die EINZIGE Ordnung im Haus, die "System vor Organ" nicht haelt. Grenze je Ebene: Hash/Schluessel EINE Welt (Writer rechnet nichts nach, BinaryKeyPolicy wirft bei !=9); Unterachsen gemeinsame gewachte Quellen (kSystemAxisOrder; organ_gruppen_ebenen einzige Konversion, CT-bewiesen 18=18); Kategorien-Ebene KEINE gemeinsame Quelle, KEINE Wache -- der vom Owner befuerchtete verdeckte Bruch sitzt genau dort.
ORT: ce abi/anatomy_fingerprint.hpp:591-596/:607-608/:733-738; abi/anatomy_module_abi_v1_decl.hpp:200-243; abi/anatomy_module_abi_v1.hpp:162/:213; builder/bestandslog/lager_baum_writer.hpp (Kaskaden :693-758, Gruppen :391-403); vollstaendige Fundstellen-Karte in der Quelle
SOLL/FIX: S-6 bleibt GESPERRT bis Owner-Entscheid; Explore-Auflage aus KON15-02 mit diesem Dokument erfuellt. Eingriffsorte falls SOLL bestaetigt: (1) Makro-Argumentfolge (golden-Bruch), (2) POD-Feldfolge (ABI-Bruch, nur mit Layout-Bump), (3) Preimage-Glied-Folge samt Zwillingen/Testliteralen (invalidiert alle Fingerprints; preimage-wirksam VOR F2-Freeze faellig). Lager-Schluessel wandert automatisch mit -- dort NICHTS aendern. Eingriff VERBOTEN: Lager-Kaskaden + kOrganGruppen*, Unterachsen-Quellen, Hash-Mechanik, Messwert-2-Tupel.
STATUS LT. QUELLE: offen (Owner-Vorlage)
ABHAENGIGKEIT/FLAECHE: S-6-Sperre; F2-Freeze; MEMORY-Regel GLIEDER-REIHENFOLGE

### [w56km2g9g.json] 2
GEGENSTAND: Fuenf Owner-Fragen zu S-6 (nicht entscheidbar ohne Owner): (1) gilt SOLL M,S,O fuer alle drei Aussen-Ebenen; meint #87 die Funktions-/Makro-Argumentfolge, #78 die Zeilen-/POD-Folge (Wellenplan mehrdeutig)? (2) welcher Realm gibt die Preimage-Ordnung vor (derselbe Fingerprint ist Binary-Identitaet S,O,M UND Messdaten-Skip-Marke M,S,O -- in keinem Dokument beantwortet)? (3) Kategorien-Ordnungs-Wache als neuer Posten zu S-6 (Vorbild organ_gruppen_decken_die_komposition)? (4) Transpositions-Sperre fuer die 3 rohen string_view-Glieder (Ledger-gedeckt KON7-10 P4) -- mit S-6 oder vorgezogen? (5) Posten #67 (142 Include-Kanten, unbelegt lt. KON13-08) -- streichen, entkoppeln oder belegen?
ORT: Quelle Abschnitt 1 "Nicht entscheidbar ohne Owner"
SOLL/FIX: Synthese mit Fundstellen-Karte dem Owner vorlegen.
STATUS LT. QUELLE: offen (Owner-Fenster)
ABHAENGIGKEIT/FLAECHE: S-6; #67 (vgl. Datei 5 Fund 11: 29er-Definition)

### [w56km2g9g.json] 3
GEGENSTAND: Nebenbefunde J: 7-vs-9-Glieder kein Widerspruch (9 gesamt, 7 traeger-relevant; 4 typ-gepinnt, die vorderen 3 organ/system/measurement rohe typgleiche string_view -- Vertauschung kompiliert unbemerkt; CEB-Pfad uebergibt organ+system leer); Zitat-Anker-Korrektur: "nur das Lager..."-Satz ist KON6-02 Punkt 4, NICHT KON7 (Ledger+Memory zitieren falsch); Namenskollisionen: zweiter "S-6" (gcc|clang Dossier-23) im Ledger L10486/L11786, zweites "D-12", drei S-/W-Zaehlungen -- vor jeder Posten-Referenz Gegenstand pruefen, nie die Nummer; Wellenplan-S-6-Zeile (:1577) uebernimmt den Lager-Vorbehalt aus KON6-02(4) NICHT (belegte Plan-Text-Luecke); KON14-02-Messung war korrekt (beide Stellen Aussen-Stellen).
ORT: Ledger/Wellenplan (je genannt)
SOLL/FIX: Ledger-/Memory-Anker korrigieren; Wellenplan-S-6-Zeile um Lager-Vorbehalt ergaenzen.
STATUS LT. QUELLE: offen (Doku-Nachzug)
ABHAENGIGKEIT/FLAECHE: OV-Nummern-Regel (MEMORY)

### [w56km2g9g.json] 4
GEGENSTAND: Register der leeren Klassen (K, Erstbefuellung): KEINE einzige unbenannte Huelle (jede deklariert als DEFERRED/SKELETT/Stub/deprecated/bewusst ungesetzt); Luecken liegen in Wellen-Zuordnung und Eigentuemerschaft. Echte Huellen: ISearchEngineProvider + ICacheEngineCoreProvider (DEFERRED-#274/Fork-4, keine S-Position); V32Orchestrator submit_to_builder + execute_messreihe (bewusste Stubs, Klasse deprecated); 3 Test-Verzeichnis-Skelette (integration/generic_module_tests/module_specific_tests -- Phase-4.B-Marker 06.07., EIGENTUEMER FEHLT); CI-Job ergebnis:holen (Skelett, terminiert: scharf mit D3-8 in W2; Spannung zu KON16-03/KON18 "keine YAML" offen = K6); XSD-Attribut active Teile 3+4 (Teil-Huelle, XSD-Kommentar veraltet, KEIN Posten); best_binary BreakEvenPoint-SKELETON (terminiert S-15=HY-B, echte Kurven HY-C); decision_lambda_trees (HY-C-Substrat); hybrid_router.hpp EXISTIERT NICHT (HY-C, nur geplant); P/E-Core-Cluster (ICpuCore/ICoreLayout/CoreClass, has_hybrid_cores, CPUID 0x1A nirgends gelesen, 2x EXPECT_FALSE) -- KEIN Posten in S-1..S-18/O/HY = ECHTE ZUORDNUNGS-LUECKE, Par.16.3-E17 "deep research Pflicht" nicht eingeloest; CodegenEngine KEINE Klassen-Huelle (nur prtart-Stub-Pfad quarantaenisiert, "NICHT erweitern").
ORT: je Zeile (ce api/i_cache_engine.hpp:92-99; super v32_orchestrator.hpp:96-108; super .gitlab-ci.yml:2736-2769; ce platform/core_layout.hpp u.a.)
SOLL/FIX: Register als gepflegtes Repo-Dokument anlegen (KON15-01 "anlegen"; Ablageort+Pflegeregel vom Owner bestaetigen lassen, Doku-Policy).
STATUS LT. QUELLE: offen (K1: Register-Dokument existiert nicht)
ABHAENGIGKEIT/FLAECHE: K2 P/E-Cluster = Owner-Entscheid eigener Posten oder Nach-F2

### [w56km2g9g.json] 5
GEGENSTAND: Abgrenzungen (damit Register nicht falsch waechst): KON11-Elf -- KEINE strukturell hohl; v32_messreihe_antrieb wird von main.cpp:669 REAL gerufen => KON12-01-Angabe "kein Produktionspfad" ist zu aktualisieren; resolve_selection/run_selection_filter_chain real mit 4 Produktionsaufrufern, stets leerer Kette (per #156 Identitaet, Owner-bestaetigt KON16-07 "Ja wir nutzen es jetzt aktiv, genau das ist der Plan"; Welle S-8/W1); mess/-Subsystem substanziell, nur Ziel-Verdrahtung offen (S-Zuordnung ungeklaert = K4); MeasurementVisitable seit 10.07. aktiviert; Praezisierung "drei CoR-Implementierungen": zwei gebaut (resolve_selection, ram_probe_chain produktiv), eine nur geplant (hybrid_router); Testkommentar test_v32_orchestrator:16-19 ("echte Konsumenten") haelt Gegenprobe nicht stand (alle 5 Fundstellen Kommentar-Erwaehnungen).
ORT: je genannt
SOLL/FIX: Ledger-Korrekturen (KON12-01); Rest wie Register.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: S-8/W1; #156

### [w56km2g9g.json] 6
GEGENSTAND: Offene Rest-Posten J2-J5 + K7-K8: J2 Kategorien-Ebene ungesichert (kein static_assert spiegelt Kaskaden gegen Aussen-Ordnung -- neuer Posten, Owner-GO); J3 anatomy_version_stamp.hpp:149-169 18er-Literalliste nur ueber Anzahl verankert, nicht Element fuer Element (Wachen-Kandidat); J4 Kommentar-Drift bestandslog_factory.hpp:11-12 + veralteter XSD-Kommentar zu active (Doku-Korrektur, deprecaten nie loeschen); J5 Restmengen ungelesen (~40 XML-Instanzen, cache_engine_builder_iterator.hpp 3257 Z. nur Grep, XSD ab Z.426 strukturell); K7 nicht erschoepfend geprueft (~1175 kleine Structs, 132 Testdateien, 6847-Z.-CMakeLists, 14 ci/tests-Skripte, Kandidatenliste-75 Posten 42); K8 Aggregatzahlen-Buchhaltung (164-117-34=13 nicht aufgeschluesselt; beim Landen Zaehlung reproduzierbar ablegen).
ORT: je genannt
SOLL/FIX: wie je Posten; nichts davon blockiert S-6-Vorlage.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -


# DATEI 7: wgr8gvgza.json -- "Thesis-Posten (O-4 Anhang-A-Reichweite, Kapitel-Stand) + unausgewertete Codex-Testoffensive" (Stand 06.08.)
Plan-Datei lt. Quelle: docs/plaene/20260806-PLAN-thesis-posten-und-testoffensive.md (714 Z., nicht committet).

### [wgr8gvgza.json] 1
GEGENSTAND: O-4 Anhang-A-Reichweite: Owner-Entscheid weiterhin OFFEN ("Anhang A DE+EN haengt daran, falls er in die Abgabe soll, rutscht V-04 hoch = OWNER-ENTSCHEID", Ledger:5028/5149); Ist: 44 Fragmente je Sprache = 16 echt (aus 43er-Smoke) + 28 fehlend (23 Gate-8-Graph + 5 alte #24), alle via InputIfFileExists gegated; ENTSCHEIDUNGSREIFE Vorlage: Weg 1 (Kosten null, V-04 nach Abgabe) MIT AUFLAGE 16. Zeile in le_limitierung.tex DE+EN ("16-von-44 im Dokument benennen statt nur im Ledger") vs Weg 2 (44/44, Ein-Versuch-Kette ueber O-A/O-E/Voll-Lauf, blockiert durch R-T1); Weg 2b (Teilfuellung) verworfen. Empfehlung: Weg 1 mit Auflage.
ORT: Ledger:4921/:5028/:5042/:5149; FAHRPLAN-hauptstrang-landung.md:512; Thesis @8970465d anhang/{de,en}/A_measurements.tex
SOLL/FIX: Owner-Vorlage wie oben; Namenskollision: zwei ANDERE "O-4" existieren (ce .gitlab-ci.yml:426, Ledger:3576).
STATUS LT. QUELLE: offen (Owner)
ABHAENGIGKEIT/FLAECHE: V-04 (M-8/M-9/M-15); O-A; O-E

### [wgr8gvgza.json] 2
GEGENSTAND: R-T1 [SCHWER]: Drei Quellen, drei Bau-Mengen -- Text 05_evaluation.tex:94-101 = 524288; XML experiment_golden_kern.xml:285 = 2097152; FAHRPLAN = 131072 (Faktor 16 Spanne, keine gemessen). Am Objekt: <run_options cap="131072"/> (XML:246) ist DEKORATIV -- parse_experiment_profile enthaelt 0 Treffer auf run_options/cap (nur parse_thesis_profile liest es); XML-Kommentar :157-158 verweist auf falschen Dialekt; COMDARE_E4_CAP nirgends gesetzt und cappt ohnehin SOTA-Paesse. Entwarnung: real gepinnt via super .gitlab-ci.yml:79 COMDARE_GN_TOTAL=131072 (Code-Default ohne sie = 16!); ABER Fenster gilt JE System-Perm (director :989-990 verbatim) -- Fahrplan-Rechnung mindestens um System-Perm-Faktor zu klein; ob line_size zusaetzlich multipliziert, aus keiner Quelle entscheidbar.
ORT: TH kapitel/de/05_evaluation.tex:94-101; super Code/test_data_xml/experiment_golden_kern.xml:246/:285; ce xml_config_parser.cpp:266-580; super .gitlab-ci.yml:79/:1213/:1236; experiment_plan_director.hpp:989-990
SOLL/FIX: T-0 [NEU, hoechste Prioritaet, 2-3h] Bau-Mengen-Invariante: (a) Planer trocken emittieren und Binaries ZAEHLEN statt addieren; (b) <run_options cap="7"/> in comdare_experiment-XML muss WIRKEN oder laut abgelehnt werden (heute still geschluckt). Loest R-T1, liefert Kalibrier-Stichprobe, ist fehlende Eingabe fuer O-A. Reihenfolge: T-0(a) -> O-A -> O-4.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: O-A; Machbarkeitsrechnung Voll-Lauf; Kalibrier-Stichprobe steht in keiner Liste als Posten

### [wgr8gvgza.json] 3
GEGENSTAND: R-T2 [MITTEL-SCHWER]: 05_evaluation.tex:86-91 nennt Branch-Misses und IPC/CPI als durch root-Regime "ueberhaupt erst zugaenglich" -- linux_perf_pmc_source oeffnet dafuer keinen Counter (branch_misses ohne Zuweisung; PAPI-Zweig befuellt nur L1/L3/dTLB). ZUGLEICH Korrektur an Ledger:4403-4406 ("nur L1D + dTLB"): WIDERLEGT -- cache_misses_l3 wird aus PERF_COUNT_HW_CACHE_LL befuellt (:204-205/:262-266), Energie best-effort aus RAPL (:152-167/:279-293); strukturell 0 bleiben L2, coherence, branch (DREI, nicht vier). O-A wird derzeit auf der falschen Zahl vorbereitet (Ledger:4540). KONFLIKT-HINWEIS des Lesers 4: Datei 1 (Diff 26.07.-Beleg) meldet pmc_cache_misses_l3=0 in allen 16 CSV-Zeilen trotz pmc_available=1 -- Code-Faehigkeit (LL-Counter geoeffnet) vs. beobachteter CSV-Wert divergieren; Plausibilitaet klaeren (Datei 1 Fund 65).
ORT: TH 05_evaluation.tex:86-91; ce linux_perf_pmc_source.hpp:152-293; Ledger:4403-4406/:4540
SOLL/FIX: R-T2-Textfix (<3h) + Ledger-Korrektur; R-T3 [MITTEL]: Spalte heisst l3, Counter misst last level ("ehrlich LL", :192) -- 05_evaluation.tex:179 listet L1/L2/L3 ohne Vorbehalt; Fix eine Zeile, zusammenlegbar mit O-4-Auflage.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: O-A-Vorlage; Datei-1-Fund 55/65

### [wgr8gvgza.json] 4
GEGENSTAND: R-T4 [MITTEL]: PMC-Wache beantwortet andere Frage -- COMDARE_ENABLE_PMC 0x im Director; SMOKE_SKIP/Exit 0 bei fehlendem Zugriff; PRAEZISIERUNG gegen bisherige Buchung: ab :66 hat der Test durchaus Biss ("available==1 -> mindestens ein echter Counter MUSS befuellt sein") -- Defekt trifft nur den Fall "Quelle gar nicht gebaut". T-3 PMC-Flag-Vertrag GEGATET auf O-A (sonst rotes Gate in Pipeline die gruen werden soll).
ORT: ce linux_perf_pmc_smoke.cpp:58-66; experiment_plan_director.hpp
SOLL/FIX: T-3 nach O-A; mit O-A-Vorlage die R-T2-Korrektur mitgeben.
STATUS LT. QUELLE: offen (gated)
ABHAENGIGKEIT/FLAECHE: O-A; Datei 2 Fund 16 (SW-3)

### [wgr8gvgza.json] 5
GEGENSTAND: Testplan Vor-Trigger: T-1 [hoch, 1-2h] XXE-Bissbeweis -- Sperre gebaut+verdrahtet (xml_canonical_utils.cmake:135, Aufrufe :394/:473, parser-basiert :121-124), aber 0 XML mit <!DOCTYPE im ganzen Baum: FATAL-Kante wird nie genommen (Wache sagt es bei :130 selbst); T-2 [hoch, 1-3h] Axis-Lock-Mutationsprobe -- 0 Testdateien mit axis.?version.?lock|AXIS_ALGO_VERSION: ein Byte in Heuristik-Header ohne Bump muss rot melden (sonst gruener Job von inertem ununterscheidbar). Danach: T-4 Fingerprint-Kreuzprobe; T-5 bestandslog_active (gated O-C); T-6 LB-2/LB-3 mit benanntem RANGKONFLIKT (Ledger:4473-4478 stuft LB-6 Stufe 1 als Vor-Trigger-PFLICHT, Beweise nur bis LB-1); T-7ff ABI-Baseline/XLSX-Roundtrip/Property-Fuzz/Stempelgrammatik.
ORT: super Code/tests/xml_canonical_utils.cmake; ce tests/
SOLL/FIX: verbatim; bereits erledigt (keine Arbeit): Duplicate-Key-Wache, CTest-Routing-Wache (407/407 -> 411/411 Pipeline 15043), ASCII-/Breiten-Wache (Bissbeweis-Datei real).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: naechster Voll-Lauf

### [wgr8gvgza.json] 6
GEGENSTAND: Tautologie-Streichkandidaten (selbst gelesen, bestaetigt): test_config_durability.cpp:105-122 (SUCCEED() auf nullopt ODER Node -- beweist nur kein Absturz); test_r2_suffix_wachen.cpp:77-78 (Funktion gegen sich selbst). Weitere Codex-Kandidaten (test_g2_variant_sidecar:275-280, test_f3_lager_key_provider_iterator:208-305, test_e24_c10_g6_identitaets_bilanz:171-191, test_clu_per_layout:108-110, test_phase6_vorbau:41-52) stammen aus Codex-Lektuere unter Sandbox-Netz-Einschraenkung (bwrap-Fehler), als ungegengelesen markiert -- vor Umsetzung gegen Ist-Stand nachlesen.
ORT: ce/super tests (je genannt)
SOLL/FIX: streichen bzw. schaerfen; ungegengelesene Kandidaten erst verifizieren.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Codex-Lens-Doktrin (klein schneiden, MEMORY)

### [wgr8gvgza.json] 7
GEGENSTAND: R-T5/R-T6 + Entlastungen: R-T5 19 "neunzehn"-Treffer alle in NICHT eingebundenen Vorfassungen (aktive Kapitel sauber; Parallel-Linie baute bessere Loesung: 16 Dateien +74 Zeilen 0 Loeschungen additive Kopf-Kommentare -- Verschiebe-Empfehlung ZURUECKGEZOGEN); R-T6 axis_inventory.tex geschrieben, nirgends eingebunden; KEIN Risiko: 06_fazit gehedgt, Anhaenge B/E KEINE Stubs mehr (Blocker-Vermerk Ledger:267 + V-02 ueberholt), Node-Shape 0 Treffer, .blg-Gate gruen; O-A ist der schwerste offene Punkt (nicht ein fehlender Test): PMC fixen+neu messen vs Grenze benennen -- vor Phase 6.
ORT: TH kapitel/anhang beide Sprachen; Ledger Abschnitt H
SOLL/FIX: R-T6: einbinden oder abschalten; O-A dem Owner vorlegen.
STATUS LT. QUELLE: offen/entlastet
ABHAENGIGKEIT/FLAECHE: O-A; Kritischer Pfad zum Trigger (L0/R4/T2-A/B14-ce/A1/B14-super/Submodul-Bump + hart gruener Voll-Lauf -- alle aendern Binary-Identitaet)


# DATEI 8: w41d6x1yq.json -- "Doku-Korrektur-Workflow: Anker-Fehler (:1333->:1373 ueber viele Dokumente), Widersprueche D-1..D-9, verlorene Konsolidierungen -- jeder Wert am HEAD (ce 54106bc9) neu gemessen + adversarische Verify-Phase"
Hinweis: mehrere Reports in der Quelle selbst mitten im Satz abgeschnitten (F-9, G4-Dateiliste, Verify-Restpunkt 3) -- Restinhalt dieser Teile unbekannt.

### [w41d6x1yq.json] 1
GEGENSTAND: Anker-Korrektur-Kampagne :1333->:1373 (allow_failure im experiment_plan_director; Drift +40 uniform; Kommentar :1372, rules: :1368): 30 echte Anker in 10 von 10 Dateien korrigiert (Liste verbatim in Quelle: PLAN-p-pmc-1-messkette, PLAN-messkette-ceb-observabletier, PLAN-owner-antworten-vertiefung, PLAN-testoffensive, PLAN-kostenklammer-restposten, PLAN-wellenplan-vollbild, ANKLAGE-kostenklammern, KONTEXTUEBERGABE-abend, ANKNUEPFPUNKTE, DOSSIER-checkheft); 2 Stellen bewusst als Alt-Wert belassen (Drift-Records DOSSIER:405/:1734).
ORT: super docs/plaene + docs/sessions (10 Dateien)
SOLL/FIX: erledigt; nicht mandatierte Nachbar-Anker derselben Zeilen (:1362/:1367/:1240-1252/:952-955, :1300, :1336-1364) NICHT nachgemessen -- auf Alt-Stand, mit Hinweis versehen.
STATUS LT. QUELLE: behoben (Arbeitskopie)
ABHAENGIGKEIT/FLAECHE: N-2-Regel (Belege brauchen Suchbegriff)

### [w41d6x1yq.json] 2
GEGENSTAND: ZWEI ECHTE REST-FEHLER nach der Kampagne (adversarisch gefunden): (a) LEDGER:5328 schreibt experiment_plan_director.hpp:1332-1333 als IST-Zustand ("CODE-STAND: unveraendert") -- real 1372/1373, STALE nicht gefixt; (b) DOSSIER-regressionen-checkheft.md:1302 "der Kommentar darueber (:1332)" als aktuelle Tatsache -- real @1372; dieselbe Datei traegt auf Z.405/543 bereits :1373 -- interner Widerspruch.
ORT: super docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:5328; docs/sessions/20260806-DOSSIER-regressionen-checkheft.md:1302
SOLL/FIX: beide Stellen auf 1372/1373 ziehen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [w41d6x1yq.json] 3
GEGENSTAND: GESAMTDOSSIER-Korrekturen (alle am ce 54106bc9 neu gemessen): F-3 allow_failure @1373 (1 Treffer); F-4 Messfenster [0:COMDARE_GN_TOTAL) real emittiert :1410-1413 (nicht :1367-1369); F-1 seg_ns = 308 ueber libs+apps+tools+tests+adapters+modules (nicht 326; libs allein 117; ganzer Baum 424/65 Dateien) -- falsches "beide Zahlen sind richtig"-Acquittal entfernt; F-5 include/cache_engine/-Segment in 3 Pfaden restauriert; F-6 vier PMC-Flags pmc_source.hpp:37-43 (nicht :36-42); F-7 swisstable in libs = 11 Dateien (nicht 5); F-8 ASCII-Marker 101 von 265 (nicht 104; Umlaut-Varianten 108); F-9 im Quell-Report abgeschnitten.
ORT: super docs/sessions/20260806-GESAMTDOSSIER-session-architektur-und-befunde.md
SOLL/FIX: erledigt in Arbeitskopie.
STATUS LT. QUELLE: behoben (unkommittiert)
ABHAENGIGKEIT/FLAECHE: -

### [w41d6x1yq.json] 4
GEGENSTAND: Verify-Nebenbefund F-02 (GESAMTDOSSIER Z.2382) NICHT belegbar: Behauptung "flat_hash_map repoweit zehnmal ... 3 Thesis-Spiegel/1 googletest/6 tcmalloc" -- real @54106bc9: 82 Zeilen in 21 Dateien AUSNAHMSLOS unter ext/allocator/A06-tcmalloc; keine .tex, kein googletest. (Z.2378 "libs apps tools tests -> 0" dagegen korrekt.)
ORT: GESAMTDOSSIER Z.2382
SOLL/FIX: Stelle korrigieren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: MEMORY-Regel flat_hash_map (Gattung-Map, nicht Container)

### [w41d6x1yq.json] 5
GEGENSTAND: Ledger-Nachtrag "morgen-1" (07.08., Z.7250-7286, append-only) verbucht: R-3 OFFEN bestaetigt (COMDARE_MEASUREMENT_ON/mess_tooling/measurement_tooling in anatomy_fingerprint.hpp + toolchain_stamp_glied.hpp = 0 Treffer => Mess-Tooling NICHT im Preimage; Zusatzbefund: measurement_tooling steht in anatomy_version_stamp.hpp in der lesbaren STEMPEL-Zeile -- im Stempel, aber nicht im Preimage; "Fix kostenlos solange 0 .fingerprint-Sidecars" verifiziert); SW-5/E-14 OFFEN verbucht (active_telemetry_is_silent(){return false;} :241, Aufrufer :533; 12 Profile silent="true"; golden-beruehrend). Verify: Nachtrag vollstaendig; Off-by-one: "8 Treffer" real 7; "mindestens 10" real exakt 12.
ORT: Ledger Z.7250-7286; ce profile_run_facade.cpp:241-242/:533; abi/anatomy_version_stamp.hpp
SOLL/FIX: R-3 (Mess-Tooling ins Preimage) + SW-5 als Mess-Sperrposten fuehren; Off-by-one-Zahlen korrigieren.
STATUS LT. QUELLE: offen (beide Sperrposten)
ABHAENGIGKEIT/FLAECHE: Preimage/Format; golden-Byte-Identitaet; Datei 2 Fund 21

### [w41d6x1yq.json] 6
GEGENSTAND: UEBERBLICK-Korrekturen: (1) generated/-Zensus a007bfb20 war VOLLSTAENDIG, nicht abgebrochen (Endverdikt: 146 Wurzel-Vorkommen "${PROJECT_BINARY_DIR}/generated"; 220 Ziele geprueft -- 141 noetig / 79 Ballast; MCE24-Kanal 52 Ziele / 26 noetig) -- 5 Stellen korrigiert inkl. I-5 auf ABGESCHLOSSEN; (2) E2/E3/E9 nicht mehr Blocker (E3 durch Owner-E-4, E2 durch E-4-SHORTCUT-R1 gedeckt; NUR E9 frag-milli-Stille-0 offen-klein, wird mit P6 geheilt; Ledger:7016); (3) H-3 erledigt (LB-0..6 im Ledger verbucht: reconcile-Bilanz 11/6, Voll-Datei-Zaehlung 66/13).
ORT: super docs/sessions/20260806-UEBERBLICK-workflow-ergebnisse.md (Z.78/117/188/334/369/683)
SOLL/FIX: erledigt in Arbeitskopie; Verify: E2/E3/E9-Korrektur sitzt auf Z.369 (Auftrags-Anker 327 falsch).
STATUS LT. QUELLE: behoben (unkommittiert)
ABHAENGIGKEIT/FLAECHE: generated/-Ballast (79 Ziele) als spaeterer Aufraeum-Posten

### [w41d6x1yq.json] 7
GEGENSTAND: D-2-Korrektur (WICHTIG, korrigiert Datei-7-R-T1-Teilaussage): <run_options cap="131072"/> ist NICHT pauschal dekorativ -- cap WIRD im comdare_thesis_profile-Zweig geparst UND angewandt (xml_config_parser.cpp:426 tp.run_options.cap; Fluss profile_runner.hpp:148 -> profile_effective_cap :163 -> profile_run_entry.hpp:388 = min(cap, basis_count); SCHEMA.md:41 dokumentiert); nur der comdare_experiment-Zweig liest run_options gar nicht (0 Treffer ab :448). Ob 131072 real verkleinert, haengt an ungemessener basis_count. B-4: Bericht fuehrt VIER Bau-Mengen-Kandidaten (131072/524288/1572864/2097152), Basis 131072 via compile-guard source_catalog.hpp + CI COMDARE_GN_TOTAL gegengeprueft.
ORT: ce xml_config_parser.cpp:424-432/:448; profile_runner.hpp:148-163; profile_run_entry.hpp:388
SOLL/FIX: beide Fassungen dokumentiert; T-0-Mengen-Invariante (Datei 7 Fund 2) bleibt noetig (Experiment-Zweig schluckt cap weiterhin still).
STATUS LT. QUELLE: teilweise (korrigiert; Experiment-Zweig-Luecke offen)
ABHAENGIGKEIT/FLAECHE: R-T1/T-0; O-A

### [w41d6x1yq.json] 8
GEGENSTAND: D-3-Korrektur: "Sechs Planungs-Rueckfragen unbeantwortet" -> vier dokumentiert (F1 ROH:7716/7761; F3 Break-Even pro Ebene PLAN-BREAK:334-339; F5 CT-CoR PLAN-KURVEN:250-252; F6 mehrere Optima ROH:7601/7603); wirklich offen nur F4 (Phrase "Orchestration ueber das Lager" = 0 Treffer) plus je ein Restentscheid bei F2 (wandert vs. testiert) und F5 (CT-Einbau vs. RT-Tausch).
ORT: super docs (Handover/Bilanz-Dateien); Explore-Bericht acd614d772b8ecb00.md Z.112-119
SOLL/FIX: F4 + F2-Rest + F5-Rest als offene Owner-/Design-Fragen fuehren.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Messkurven/Hybrid-Kette (Datei 3)

### [w41d6x1yq.json] 9
GEGENSTAND: Weitere Abweichungen/Unvollstaendigkeiten: vierter Berichts-Hash a2ac148a6dcedebb9.md existiert NICHT im Backup-Ordner (inhaltsgleiche Fassung a2a9678e69e6ed72c.md konsolidiert); Selbst-Audit im Nachtrag: 6/20 Anker-Fehler -> Gesamt-Dossier O-3 wktkhd1cj; KERN 1 + KERN 12 abgeschnitten, zwei fehlende Owner-Nachrichten -- Erfassung NICHT VOLLSTAENDIG; alle Korrekturen (H-3, E2/E3/E9, GESAMTDOSSIER, Anker) UNCOMMITTED (M im Working-Tree, "Der Lead committet zentral") -- solange nicht committet/gepusht ist die Heilung nur lokal; Verify-Punkt 3 im Quell-Report abgeschnitten.
ORT: super Working-Tree development; docs/sessions/backups/20260807-workflow-endberichte/
SOLL/FIX: Lead-Commit der Korrekturen; fehlende Owner-Nachrichten (KERN 1/12) nachziehen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -


# DATEI 9: wn86mzt85.json -- "A1.1-Review: Opus-5-Lead-Fehler dieser Session adversarisch bewertet (Fable 5 max prueft am Objekt)" (13.08.)

### [wn86mzt85.json] 1
GEGENSTAND: Fehlerkatalog F1-F14 bewertet -- GEHEILT: F1 blinder Monitor (toter Token; Heilung verifiziert: /home/comdare/keys/gitlab-pat-r20260813, 0600, HTTP 200; Pipelines 15779/15781 success); F2 R4-Verstoss (ueberlappende Pipelines, beide success, docs-only); F3 K11 zweimal (Wiederholungsfall, nur Selbstbericht); F4 PZW-Handzaehlung (Wache griff, Commit 26099198 traegt 40/21/2); F5 Werkzeug-Null perm_runner.hpp (liegt in harness/, nicht profile_facade/; KON58-11 verbucht); F6 Binnenaufteilung 13+16 real 12+18 (KON58-01 korrigiert); F7 Ledger-Nachtrag 5h ungelandet (a7128965 = 594 Z. KON58; Lehre KON58-12 "Nachtrag an die LANDUNG binden"); F8 Verify-Teile nicht gelesen (Owner-gefangen; nachverbucht in 874920a9); F10 A1.1-Beinahe-Verstoss (abgefangen); F11 21 Task-Subjects (21/21 gedeckt, 5 kuratiert); F12 #37 completed; F14 Vault-Regex ohne Punkte (Memory nicht konsultiert; Token liefert 200).
ORT: je Fund; Commits 26099198, a7128965, 874920a9
SOLL/FIX: als geheilt registrieren; F2-Rest: praeventive Vor-Push-Pruefung existiert weiterhin nicht.
STATUS LT. QUELLE: behoben (bis auf genannte Reste)
ABHAENGIGKEIT/FLAECHE: -

### [wn86mzt85.json] 2
GEGENSTAND: F9 OFFEN (einziger offener Katalogpunkt): Zehn-Wochen-Explore vor Fixup 2/3 uebersprungen -- benannt, NIE geheilt, NIE autorisiert; Verbuchung als "deklarierte Abweichung" NICHT zulaessig (Owner-Dauerregel 13.08.: Luecke=Behebung IMMER Pflicht; A2.3-Ausnahme koennte nur der Owner gewaehren).
ORT: Fixup 2/3 (Bump-Wache/golden-Riegel/Overlay-Schnitt)
SOLL/FIX: verbatim Restarbeit-Posten: "nachgezogener Zehn-Wochen-Explore ueber den Gegenstand von Fixup 2/3 (Owner-Rohtranskripte, Bestand nach A2.2 'nach dem Gegenstand suchen', Falsch-Null-Regeln Encoding/Case/95-Zeichen-Umbruch); Divergenz => Pflichtfix in derselben Session, Ergebnis als Ledger-Nachtrag" -- P1, VOR weiterem Bau auf dem Riegel, insbesondere vor #16 golden/Homes am WE. Milderung: Fixup 3 hart verifiziert (Dreifach-Messung, Mutationsproben A/B, KON58-13) -- deckt BAU-Qualitaet, nicht die EXPLORE-Frage.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: #16 golden/Homes

### [wn86mzt85.json] 3
GEGENSTAND: F13 TEILGEHEILT: #10 Lead-seitig fertig (Blind-Smoke ROT mit beissendem Koeder rc=1 => Null echt, KON58-04; Owner-Vorlage 20260813-OWNER-VORLAGE-minio-keys-und-backup-ref.md, a82078cb; "sofort vollziehbar" des Wellen-Designs war am Objekt FALSCH -- Vault traegt nur Entwertetes, Keys neu erzeugen = Infra/Owner-gated); #31 (13 ce-Branches, "Triage sofort") WEITER UNBEGONNEN und blockiert #19 main-FF -- der offene Kern.
ORT: docs/plaene/20260813-OWNER-VORLAGE-minio-keys-und-backup-ref.md
SOLL/FIX: #31 Branch-Triage: 13 ce-Branches + Worktrees + Rueckwaerts-Gitlink inventarisieren, in P-Lande-Ordnung klassifizieren (landen oder begruendet ausbuchen); LESEND sofort, SCHREIBEND erst nach ce-Landung wgrkst273; vor Worktree-Loeschungen alle Submodul-Branches pruefen; Remote-Loeschung nur mit Owner-GO.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: #19 main-FF; wgrkst273

### [wn86mzt85.json] 4
GEGENSTAND: Neue Funde N1-N8: N1 Pipeline-15780-Raetsel GELOEST (eigener Bridge-Trigger aus 15779, success -- Task-#19-Notiz korrigieren; FF-Blocker nur noch #31); N2 WORKFLOW-ROHDATEN-BACKUP 12./13.08. FEHLT (Doktrin-Verstoss; Rohdaten nur im fluechtigen Job-tmp: disjunktheits-plan.json 88KB, task-updates.json, updates-anwenden.tsv, wellenplan-18.md, ledger-nachtrag-kon58.md 35KB, verify/, p2.patch 101KB; beim Nachholen 233-Regel-Redaktionspass PFLICHT, Transkript-Extrakte 5a_all.ndjson 108MB + Token-Artefakte NIE committen); N3 MEMORY-INDEX STALE (Z.6+21 sagen KON36/ddfb68ac, real KON58 @ a7128965 -- 22 Konsolidierungen zurueck; KON58-11 Befund 1 fordert ARBEITSWEISE-Pfad-Praezisierung: super docs/ = Zeiger 53 Z., geltende Fassung 988 Z. im Umbrella) [Anm. Leser 4: heutiger MEMORY-Kopf nennt bereits KON58 -- bei Verwendung neu pruefen]; N4 F8-Binnenzahl am Objekt nicht deckbar (real 1 behoben + 2 entlastet, Katalog sagt 2+1 -- F6-Klasse in der Selbstpruefung); N5 Katalog teilweise ueberholt in gute Richtung; DREI unpushte Commits (689b5379, 136a1798, a82078cb), nicht zwei; N6 Termin-Widerspruch "S-7 = P2 morgen Sa 15.08." (morgen ist Fr 14.08. = F1-Frist; KON58-05: S-3=Fr/S-7=Sa, S-3 bereits Do gebaut -- S-7-Vorzug vor WE-Taktung fixieren); N7 Token-Artefakte im Job-tmp (.pat 0600, pat.sh, pat-blind.sh, token_289_rotation.py, var_289_token_fix.py -- beim N2-Backup ausschliessen, Raeumung empfohlen); N8 Idle-bg-Session e1-e4-ebenen-konsolidierung 5 Tage idle (Shells-Regel pruefen).
ORT: je Fund; /home/comdare/.claude/jobs/5a19728e/tmp/
SOLL/FIX: wie je Fund.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Backup-Doktrin; MEMORY-Pflege; S-7-Taktung

### [wn86mzt85.json] 5
GEGENSTAND: Restarbeit-Liste (10 Posten mit Prio/Wer): (1) P1 Sammel-Push development (689b5379+136a1798+a82078cb) NACH Landung wgrkst273; R4-konform EINE Pipeline; Monitor MIT PAT bewaffnen inkl. Bewaffnungs-Lebendprobe (einmal HTTP 200 beweisen bevor Stille als "laeuft" gilt); Push-danach-gruen; danach GitHub-Zweitremote; (2) P1 Owner vorlegen: MinIO-Keys-Vorlage + C-3a Comp-Gate-Paket-Entscheid (20260813-OWNER-VORLAGE-c3a-comp-gate-paket-entscheid.md, Frist Mi 19.08.) + A1.1-Bericht mit F8-Korrektur; (3) P1 F9-Explore (Fund 2); (4) P1 #31-Triage (Fund 3); (5) P2 Workflow-Rohdaten-Backup additiv (N2); (6) P1 S-7-Termin fixieren + P2 takten (eiserne Regel beider Tage: nichts unter axes/, topics/, heuristik/ anfassen; danach WE-Reserve S-2/Grammatik + #16 Homes; #16 rueckt frei sobald wgrkst273 P11/#33 gelandet + B2 (#24) steht); (7) P2 Task-Hygiene (#19-Notiz korrigieren); (8) P2 MEMORY.md pflegen; (9) P3 Monitor-Doktrin haerten (Lebendprobe-Pflicht + Vor-Push-Pruefung "laeuft schon eine Pipeline auf dem Ref?" als R4-Riegel); (10) P3 Idle-bg-Session pruefen.
ORT: Restarbeit-Sektion verbatim
SOLL/FIX: wie gelistet.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: wgrkst273-Landung; F1-Frist Fr 14.08.


# DATEI 10: wpzbpjmj1.json -- "B14-Abschluss: ce-kLbufBytes-Teil committen + Gates + Codex-Lens ueber super- und ce-Teil"

### [wpzbpjmj1.json] 1
GEGENSTAND: B14-Welle Teil 1 committet (KEIN Push): ce b14-ce-anteil @ 6a40071f (Vor-Stand c837d830; erste SHA bfd5c119 nach Ehrlichkeits-Amend verworfen); Patch-Identitaet gegen gesicherten WIP-Patch belegt (md5 identisch); Gates gruen: make all 0 error, ctest 2x 408/408, golden 5/5, TABU 0, Nicht-ASCII 0.
ORT: /home/comdare/wt-b14-ce @ 6a40071f; Gate-Spiegel docs/sessions/backups/20260806-b14-nb2/gates/
SOLL/FIX: Landung/Push steht aus.
STATUS LT. QUELLE: behoben@6a40071f (unge-pusht)
ABHAENGIGKEIT/FLAECHE: B14-Welle Teil 2 (Format-3-Linie; Frozen-Vektor 17148e5a existiert auf diesem Branch NICHT -- hiesiger Vektor 0fe275bd...)

### [wpzbpjmj1.json] 2
GEGENSTAND: LEHRE falsches Gruen (praezisiert bekannte Falle): 2-Pass-Configure KALT ergab 404 statt 408 Tests -- 2-Pass-Pflicht heisst configure -> BAU -> configure; ein zweites Configure VOR dem Bau reicht nicht. Nach 3. Configure: 408.
ORT: Gate-Spiegel DOPPELLAUF-LITERALE-B14-NB2.txt
SOLL/FIX: J-1..J-4-Doktrin entsprechend praezisieren.
STATUS LT. QUELLE: nur-hinweis (Lehre)
ABHAENGIGKEIT/FLAECHE: Vollbau-Luecken-Doktrin (MEMORY)

### [wpzbpjmj1.json] 3
GEGENSTAND: Bump-Entscheidung KEIN algo_version-Bump -- bewiesen (Beweis-TU RC=0: alle 5 Layout-Strategien gehuellt+nackt line_bytes_of==64, stride(48)==64, 16384*stride==1048576 == Alt-Werte; Gegenprobe B256 schlaegt durch). Grund: alle 5 Strategien erben Default-NTTP B64; Codegen emittiert die NTTP noch nicht (0 Treffer CacheLineConfig in generated/); golden-XML deklariert kein line_size.
ORT: ce libs/cache_engine/axes/layout/; b14-neutralitaets-beweis.cpp
SOLL/FIX: dokumentiert; KF-6-NTTP-Emission ist der spaetere scharfe Schalter.
STATUS LT. QUELLE: behoben (Beweis)
ABHAENGIGKEIT/FLAECHE: KF-6

### [wpzbpjmj1.json] 4
GEGENSTAND: OFFEN B14-NB3 (wichtigster Befund): CacheLineAlignedMemoryLayout::scan_field_sum (axis_05_memory_layout_cache_line_aligned.hpp:60) traegt weiterhin kCacheLine=64 hart und fragt die Achse nicht. Folgen: (1) Patch-Kommentar UEBERZEICHNET (kein OOB bei NTTP-Belegung, sondern 4x ueberdimensionierter Puffer -- Korrektur in Commit-Message aufgenommen, Kommentar-Block in NB3 nachziehen); (2) Scan-Seite ist die messwirksame Haelfte -- ohne sie differenzieren KF-6-line_size-Permutationen den CLA-Scan nicht (Mess-Validitaets-Loch, kein Absturz); (3) Zusatzfrage: bei line=32 bliebe Stride 64, Alloc-Alignment saenke 64->32 -- bewusste Entscheidung noetig, keine Nebenwirkung.
ORT: ce libs/cache_engine/axes/layout/axis_05_memory_layout_cache_line_aligned.hpp:60
SOLL/FIX: NB3: Scan-Seite an die Achse binden + Kommentar korrigieren + line=32-Alignment-Entscheid.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: KF-6-Messvaliditaet

### [wpzbpjmj1.json] 5
GEGENSTAND: Codex-Lens-Befunde (a) CMake-Wachen umgehbar (Verdikt DIFF-SUPER: BLOCKER): HOCH fixture_schema_subset_check.cmake:78/:102 + golden_n_consistency_check.cmake:54/:76 CDATA-/Kommentar-Stripper ohne XML-Lexikalzustand; HOCH :123/:152 bzw. :96/:147/:182 Entities nicht expandiert; HOCH :211/:218 ASCII-Grenze uebersieht Nicht-ASCII-Namen; HOCH :264/:275 Truncation-Riegel prueft nur textuellen Wurzelabschluss; MITTEL :237 XSD-Extraktion nur xs:-Praefix+Doppel-Quotes; MITTEL :221 xmlns/xsi-Filter zu grob; HOCH golden_n:112/:125/:159 Regex ueber Rohdokument (PI/DTD-Text als echte Achse lesbar); HOCH golden_n:150/:195/:219 doppelte Achsen nicht zurueckgewiesen; MITTEL doppelte Werte nur sortiert; MITTEL cap-Regex akzeptiert xcap= falsch; MITTEL unmaskierte Semikolons als CMake-Listentrenner; MITTEL Drift beider Traeger auf nicht-registrierte Namen passiert; MITTEL CI-Trigger-Wirkung bei reinen ce-Aenderungen unklar (Skip bei fehlendem ce-Checkout); NIEDRIG XSD unsignedInt vs Parser-int (>INT_MAX).
ORT: super Code/tests/fixture_schema_subset_check.cmake + golden_n_consistency_check.cmake; experiment_schema.xsd; experiment_golden_kern.xml:245/:284
SOLL/FIX: Wachen-Haertung je Fund; cap="max_binaries"-Doku vs Wache zaehlt nur Organraum 131072 (Faktor 4x4 zur Gesamtmatrix 2097152 ignoriert).
STATUS LT. QUELLE: offen (BLOCKER-Vorschlag super-Diff)
ABHAENGIGKEIT/FLAECHE: B14-super-Landung; R-T1-Komplex (Dateien 7/8)

### [wpzbpjmj1.json] 6
GEGENSTAND: Codex-Lens-Befunde (c)+(d) ce (Verdikt DIFF-CE: NACHBESSERN): HOCH Kette experiment_schema.xsd:53 + abi_adapter.hpp:510 -- solange parse_experiment_profile organ_subaxes nicht in die Profilbaum-/NTTP-Komposition ueberfuehrt, erreichen die XML-Werte 32/64/128/256 MemLayout gar nicht (= Kerninhalt "Haelfte 2"); MITTEL abi_adapter:513/:620/:758 static_asserts selbstreferenziell (nutzen denselben ggf. falsch auf 64 gefallenen kMaxStride); MITTEL axis_05_memory_layout_observable.hpp:66 bedingtes Forwarding heilt nur diese eine Huelle -- jeder weitere Wrapper ohne Member faellt lautlos auf 64 zurueck, kein Test ueber alle finalen MemLayout-Instanziierungen; MITTEL kein Compile-/Laufzeittest fuer 32/128/256 ueber alle drei Pfade; MITTEL abi_adapter:517/:578 catch(...){return 0;} ohne RAII-Cleanup des Layout-Puffers (Leak, mit 4x Puffern gewichtiger); NIEDRIG Ueberlauf-Pruefung fehlt (aktuell unkritisch); NIEDRIG veralteter Kommentar test_phase_b_effective_search_algo_contrast.cpp:259. Codex-Fazit "Haelfte 2": (i) Einlesen/statisches Auspraegen der vier organ_subaxes-Line-Werte, (ii) Audit aller Wrapper, (iii) End-to-End-Instanziierungstests aller drei Pfade.
ORT: ce abi_adapter.hpp; axis_05_memory_layout_observable.hpp:66
SOLL/FIX: verbatim Codex-Fazit als NB-Paket.
STATUS LT. QUELLE: offen (NACHBESSERN)
ABHAENGIGKEIT/FLAECHE: KF-6 "Haelfte 2"; Codex-Sandbox-Hinweis: bwrap-Fehler, Diffs inline eingebettet (Lens-Doktrin)


# DATEI 11: wr5l6ao2d.json -- "A1-Codex-Befunde heilen: algo_version-Bump Allokator-Varianten, PMR-Zero-Size, Concept-Regress; Fable-Re-Review"

### [wr5l6ao2d.json] 1
GEGENSTAND: Alle 3 Codex-Befunde geheilt in EINEM Fixup-Commit 62d8c715 auf b-a1-wurf-vertrag (Vorfahr 0b5ed557; 31 Dateien +367/-45; 2 unpushed Commits, kein Push): [HOCH] algo_version-PATCH-Bump aller 26 Achse-6-Strategien v1.0.0c -> v1.0.1c (CRTP-Wurzel-Aenderung erbt in alle; jede Permutation fuehrt genau einen Allokator-Slot => Fingerprint jeder Permutation bewegt sich; Begruendung einmal in axis_06_allocator_strategy_base.hpp "A1-VERSIONS-BUMP"); [MITTEL-1] PMR-Zero-Size do_allocate: if (p == nullptr) throw std::bad_alloc{} ohne bytes!=0-Vorbehalt ([mem.res.public]); Std-Adapter + allocate_or_throw behalten Zero-Size-Ausnahme; Test-Orakel korrigiert ("liefert NIE nullptr", Zeiger ODER Wurf); [MITTEL-2] neues Sub-Concept ThrowTranslatingStrategy (siebtes Sub-Concept, bewusst NICHT in AllocatorStrategy gezogen; Gegenprobe-Typ OhneWurfUebersetzung beweist "echt staerker").
ORT: /home/comdare/wt-b-a1 libs/cache_engine/axes/alloc/ (+concepts/), axes/node/, tests/unit/
SOLL/FIX: Landung/Push ausstehend; Frozen-Beweis erbracht (3 Fixtures ohne Allokator-Slot, Hex 0fe275bd... unbewegt, gleiche Zeilennummern); Gates: 2x 409/409, TABU 0, Nicht-ASCII 0, clang-format-22.1.8 sauber.
STATUS LT. QUELLE: behoben@62d8c715 (ungepusht); Re-Review-VERDIKT: LANDEBEREIT
ABHAENGIGKEIT/FLAECHE: A1-Scheibe (Datei 4 Fund 3: Posten 71-74)

### [wr5l6ao2d.json] 2
GEGENSTAND: Re-Review-Befund W-1 (Bericht-Wording, kein Code-Mangel): Bau-Bericht begruendet Cache-Sichtbarkeit ueber algo_sig -- das ist der Vor-A2-Mechanismus; seit 05.08. entscheidet .algos ueber keinen Skip mehr, dll_is_current vergleicht NUR den .fingerprint (build_orchestrator.hpp:293). Bump trotzdem voll cachewirksam (Organ-Zeile speist sich aus derselben Versions-Tabelle; literaler Beleg ORGAN_LINE=allocator=std_malloc@1.0.1c).
ORT: ce build_orchestrator.hpp:293; reflect_versions/compose_organ_stamp_line
SOLL/FIX: fuer kuenftige Berichte: Wirkflaeche = kOrganAxisVersionLine im Fingerprint-Preimage nennen.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

# DATEI 12: w2w3z101l.json -- "DE/EN-Konsistenzpruefung: wo weicht die englische Fassung von der fuehrenden deutschen ab?"
Bilanz: 4 Abweichungen gesamt -- 2 NUR_STIL/NIEDRIG, 2 EN_WIDERSPRICHT/HOCH.

### [w2w3z101l.json] 1
GEGENSTAND: [HOCH] EN widerspricht DE UND sich selbst: anhang/en/D_building_block_matrix.tex:588 nennt die Migrations-Strategie-Achse "T15" (DE + eigene EN-Section-Ueberschrift Z.584 + vorangehender Satz Z.586 sagen T13).
ORT: anhang/en/D_building_block_matrix.tex:588 (DE :588)
SOLL/FIX: verbatim Vorschlag: "The Migration Strategy axis (T13, \texttt{axis\_\allowbreak{}migration}) encapsulates decision logic for data placement across multi-tier storage hierarchies (RAM/\allowbreak{}SSD/\allowbreak{}HDD, Hot/\allowbreak{}Cold tiers)."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: M5 (DE fuehrt, EN abgeleitet)

### [w2w3z101l.json] 2
GEGENSTAND: [HOCH] EN widerspricht DE UND sich selbst: anhang/en/D_building_block_matrix.tex:642 nennt die Filter-Achse "T16" (DE + EN-Section-Ueberschrift Z.638 + Satz Z.640 sagen T14).
ORT: anhang/en/D_building_block_matrix.tex:642 (DE :642)
SOLL/FIX: verbatim Vorschlag: "The Filter Axis T14 provides selectable probabilistic and deterministic membership-query filters for point and range queries."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: M5

### [w2w3z101l.json] 3
GEGENSTAND: [NIEDRIG, NUR_STIL] (a) kapitel/en/03_messsystem_prtart.tex:731 laesst den Einordnungs-Begriff weg (DE :739 "Genus SearchAlgorithm"; EN-Parallelstellen nutzen "tier subclass") -- Vorschlag: "carries as its sole subclass (tier subclass \texttt{SearchAlgorithm}) the full eighteen-axis \enquote{mammal}"; (b) EN :796 "eleven-axis" vs Vorschlag "11-axis" (DE :805 "11-Achsen").
ORT: kapitel/en/03_messsystem_prtart.tex:731/:796
SOLL/FIX: wie Vorschlaege.
STATUS LT. QUELLE: offen (niedrig)
ABHAENGIGKEIT/FLAECHE: M5

# DATEI 13: wvs8ulxqx.json -- "Codex-Zweitlens fuer E18-SNAP (bda34e79, wt-b-e18snap)"

### [wvs8ulxqx.json] 1
GEGENSTAND: Codex-Zweitlens E18-SNAP: Shell-Injection/Quoting OHNE BEFUND; 5 neue + 1 vorbestehender Befund: [HOCH] Snapshot haengt am Anhang-Byte-Delta -- unveraenderter Kanal-Lauf endet vor PDF-Gate+Snapshot (entgegen "je Kanal-Lauf"); stirbt der Job nach 289-Push aber vor 288-Push, sieht ein Retry keinen Delta und erzeugt keinen Snapshot (SNAP_PENDING=0), Gitlink landet trotzdem, Commit-Meldung behauptet faelschlich "+ Compile-Schnappschuss" -- Snapshot dauerhaft verloren (anhang_forward_core.sh:291/:531, gitlab-ci-delta.patch:52); [HOCH] Kollisionssuffix beruecksichtigt nur lokalen veralteten Checkout -- zwei parallele Laeufe derselben Sekunde waehlen denselben Pfad (checkout -B-Kollision bzw. Add/Add-Konflikt; [ -e ]+mkdir -p nicht exklusiv) (:409, patch:65); [HOCH] PDF + thesis_commit_sha vor dem 289-Push fixiert -- nach Non-FF kann Retry Merge-Commit M pushen, Gitlink zeigt auf M, Snapshot/PDF dokumentieren Vor-Merge-Commit C (verlinkter Baum weder gegatet noch snapshotiert) (:515/:531); [MITTEL] Funktionen unter if ! func -- errexit greift nicht; Log-cp + QUELLSTAND.txt ungeprueft; Patch staged ganzen Baum statt 3 Pflichtdateien (halber/doppelter Snapshot gruen committbar) (:397/:436/:515, patch:76); [MITTEL] AF_SNAPSHOT_ROOT konfigurierbar, Writeback staged nur measurement/thesis_compiles -- Override-Snapshot wird verworfen (:147, patch:52); [MITTEL vorbestehend] Rollback kann fremde unversionierte Datei gleichen Namens loeschen (COPIED_LIST merkt Vorexistenz nicht) (:270/:476); measurement/ selbst von neuen Loeschpfaden nicht betroffen.
ORT: super ci/anhang_forward_core.sh + gitlab-ci-delta.patch (wt-b-e18snap @ bda34e79)
SOLL/FIX: je Befund haerten bevor E18-SNAP landet/scharf geht.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: E18-SNAP-Landung; E-18-Kanal; ##20-B-Flaeche (Datei 5)

---
SELBSTCHECK: 13 von 13 Batch-Dateien vollstaendig gelesen (Rohdumps unter leser04_rohdump/); Eintraege je Datei: 85+39+19+13+18+6+7+9+5+6+2+3+1 = 213; ASCII-only geprueft; jede Zahl mit Nenner wo verfuegbar; Statusangaben sind QUELLEN-Stand (nicht neu am Objekt erhoben).
