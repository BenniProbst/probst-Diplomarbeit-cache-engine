# LESER 12 von 12 -- Extraktion (Batch: Index i % 12 == 11 der gb_dateiliste.json)

Quelle: /home/comdare/.claude/jobs/5a19728e/tmp/regressions-gesamtbild/<name>

## Batch-Dateiliste (12 Dateien, Groesse in Bytes)
| Index | Datei | Bytes | Typ (result-Keys) |
|---|---|---|---|
| 11 | wpmdvux3p.json | 173086 | karten (Kartierung 7 Themen, Sonnet-5-Explore Stufe 1) |
| 23 | wz67qt3pc.json | 111533 | explore, dossier (Wallclock drittes Glied Mess-Achse) |
| 35 | wkg9iu9j5.json | 89758 | explore, zuordnung (EINE CEB, beide Messfuehler, E-/P-Core-Pinning) |
| 47 | wif8xpy56.json | 72080 | fund, soll, codexRev, synth (Kostenklammern) |
| 59 | w2l331gg7.json | 53731 | hw, ist, syn (Cache-Line-Groessen Deep Research) |
| 71 | w44o34i7j.json | 37979 | karte, bau, review (B14 GOLDEN-XML + Sync-Gate + KF-6 line_sizes) |
| 83 | woweldept.json | 32151 | bau, verdikte (numa_cpu_pin_process_probe Umbenennung) |
| 95 | wlrzgpeet.json | 24582 | a, b (P-PMC-1 Bau-Paket PMC-Messkette) |
| 107 | w4am8bfxd.json | 18421 | urteile, bergung, vor_landung, funde, offen (WF11-Neubau Strang C+A) |
| 119 | wx9unapoc.json | 13458 | bau, review (E18-SNAP Codex-Befunde heilen) |
| 131 | w4ffuvkx9.json | 9130 | kombibau, floor_commit, golden_endkontrolle, aufraeumen, landefaehig, offene_punkte (S-3-Auflagen) |
| 143 | w2tf1a30b.json | 5789 | Array len 4 (ungelesene Workflow-Ergebnisse einsammeln) |

Alle 12 Dateien haben die Huelle {summary, agentCount, logs, result, workflowProgress, totalTokens, totalToolCalls}; der Inhalt liegt in `.result`.

---

# DATEI 1: wpmdvux3p.json (173086 B) -- Kartierung 7 Themen (Sonnet-5-Explore Stufe 1, 07.08.), alle 7 Agenten state=done

Kontext: Stufe 1 der Explore-Doktrin, Referenzen (Datei:Zeile) fuer den Lead. ce-Stand zum Suchzeitpunkt: development@ba069e38, super@6d837e7d, thesis@eaf7fe87. Erhoben am 07.08. -- Zeilenanker koennen seither verschoben sein.

### [wpmdvux3p.json] 1
GEGENSTAND: Owner-Neufassung 07.08. 12:19 der Versions-Stempel-Grammatik ('e' hat hoechste Prioritaet und steht GANZ VORN, 'cpe' als String, Filterflags xNUMBER als x128*/x256*/x512** mit '*' als nachfolgende AVX-Register-Hardware-Flags) widerspricht der gebauten Grammatik.
ORT: ce libs/cache_engine/include/cache_engine/measurement/algo_semver.hpp:1-30,187-248,319-331 | Live-Transkript 5a19728e:13579 (Owner, typed, human)
SOLL/FIX: Quelle (Owner verbatim): "'e' hat die hoechste Prioritaet und steht ganz vorn ... Weitere Filterflags sind xNUMBER fuer AVX128,AVX512 oder AVX256 als x128* x256* x512** mit '*' als Hardware Flags speziell nachfolgend fuer die AVX verbauten Register (geplant bitte Explore) ... (Plan vorhanden, lies nach)". Gebaut ist exakt umgekehrt: version := 'v' UINT.UINT.UINT [HWFLAG['e']], HWFLAG genau EIN Zeichen aus {c,g,f,n}, ERST Hardware-Flag DANN optional 'e'.
STATUS LT. QUELLE: offen (Konflikt Owner-Aussage vs. Code+Thesis)
ABHAENGIGKEIT/FLAECHE: Thesis anhang D (Posten 7), 5 Registry-Wachen (Posten 8), Stempel-2-Bit-Kodierung (Posten 10), 138 Bestands-Literale (Posten 12)

### [wpmdvux3p.json] 2
GEGENSTAND: Literale Flag-Tokens 'x128'/'x256'/'x512' als Zeichen der Versions-Grammatik existieren nirgends im ce-Baum (0 Treffer / 3900 durchsuchte Dateien, Gegenprobe avx512/avx2 = hunderte Treffer).
ORT: ce-Baum gesamt | unbekannt (nicht gebaut)
SOLL/FIX: Neubau noetig, falls Owner-Grammatik umgesetzt wird; Owner sagt "geplant bitte Explore".
STATUS LT. QUELLE: offen (echter Nullbefund mit Gegenprobe)
ABHAENGIGKEIT/FLAECHE: Posten 1

### [wpmdvux3p.json] 3
GEGENSTAND: 'cpe' als geplantes/dokumentiertes Kuerzel VOR der Owner-Nachricht 07.08. 07:39:30Z: 0 Treffer in docs/ (7000+ Dateien), thesis/, backups-workflow; Owner behauptet aber "die Tags sind bereits geplant, alles Gedaechtnisluecken".
ORT: super docs/sessions/20260807-OWNER-VORLAGE-cpe-grammatik-und-profil-chart.md (184 Z.) | Transkript 5a19728e:10772, :11321
SOLL/FIX: OWNER-VORLAGE schlaegt drei Optionen fuer die Kollision mit dem experimental-'e' vor (Trennzeichen / Reihenfolge umdrehen / 'e' aufgeben); Owner-Antwort 12:19 = Reihenfolge 'e' zuerst.
STATUS LT. QUELLE: teilweise (Owner hat 12:19 geantwortet, Umsetzung fehlt)
ABHAENGIGKEIT/FLAECHE: Posten 1

### [wpmdvux3p.json] 4
GEGENSTAND: Eine GEBAUTE differenzierende Freigabe einzelner Hardware-FAMILIEN (CPU/GPU/FPGA/NPU) je System-Achse existiert nicht: g/f/n sind laut algo_semver.hpp:387 'reserviert, nicht produziert'; das analoge Freigabe-Muster existiert nur an der Nachbarachse TargetIsa (hardware_isa_system_axis.hpp:1-7, 'Binary-ISA subset Host-Capability').
ORT: ce algo_semver.hpp:387 | axis_variant_version_table.hpp:93-94 | hardware_meta_meta_axis.hpp:167 | hardware_isa_system_axis.hpp:1-7
SOLL/FIX: OWNER-VORLAGE cpe-grammatik: "die vom Owner beschriebene Freigabe-Kette fuer die Hardware-FAMILIE (nicht die Ziel-ISA) muss noch gebaut werden".
STATUS LT. QUELLE: offen (nicht gebaut)
ABHAENGIGKEIT/FLAECHE: Posten 1

### [wpmdvux3p.json] 5
GEGENSTAND: Der Code-Gegenpart zur Owner-Formulierung 'ohne Erweiterung oder stufenweise bis zur vollen Optimierungs-Stufe' existiert BEREITS, nur anders benannt: route_allows()/pruef_dock() in simd_build_gate.hpp mit kumulativer Stufung NoExtension<Avx2<Avx512; end-to-end getestet (test_c3b_kanal_merge_beleg.cpp:130-259, genus_buildvariant_avx2/avx512.cpp).
ORT: ce measurement/simd_build_gate.hpp:49-62,67-74,108-153
SOLL/FIX: Bestand nutzen statt Neubau (Bestands-Pflicht); keine Aenderung als solche gefordert.
STATUS LT. QUELLE: nur-hinweis (Bestand vorhanden)
ABHAENGIGKEIT/FLAECHE: Posten 1

### [wpmdvux3p.json] 6
GEGENSTAND: SimdFlagTier (simd_feature_flag.hpp) kennt {Avx256,Avx512,Companion,Scalar} -- KEINEN eigenen '128'-Tier und KEINE x128/x256/x512-Namensgebung; Referenzdoc Par.3 erklaert 'AVX128' als VEX.128-kodierte Form ohne eigenes CPUID-Flag (laeuft auf XMM-Registern).
ORT: ce measurement/simd_feature_flag.hpp:1-40 | super docs/architektur/20260719-simd-flag-signaturen-REFERENZ.md Par.3:87-104
SOLL/FIX: Bei Umsetzung der xNUMBER-Grammatik muss der 128er-Fall gesondert modelliert werden (kein CPUID-Flag vorhanden); Referenzdoc Par.6 nennt AVX10 mit Versions- statt Einzel-Flag-Modell als Zukunftshinweis.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 1, 2

### [wpmdvux3p.json] 7
GEGENSTAND: Thesis (Quellrang 1) traegt noch die ALTE Grammatik (drei Stellen: dreistellige Version + genau EIN Kleinbuchstaben-HWFLAG aus {c,g,f,n}, danach optional 'e') -- widerspricht wortwoertlich der 'e-zuerst'-Owner-Aussage.
ORT: thesis anhang/de/D_building_block_matrix.tex:1131-1138 + anhang/en/D_building_block_matrix.tex:1134-1135
SOLL/FIX: Thesis muss nachgezogen werden, sobald Grammatik entschieden/umgebaut ist.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 1 (Rangfolge OWNER > PLAN > THESIS)

### [wpmdvux3p.json] 8
GEGENSTAND: Fuenf Stellen, an denen die algo_semver-Grammatik per ce_owned_version_is_wellformed()/ce_owned_version_satisfies_cpu_enforce() scharfgeschaltet ist -- jede Grammatik-Aenderung ('e' zuerst, cpe, x128*) muss diese Wachen/Registries mitziehen.
ORT: ce system_axis_code_versions.hpp, measurement/measurement_tooling_registry.hpp, measurement/measurement_framework_registry.hpp, builder/experiment_tree/axis_variant_version_table.hpp, measurement/hardware_meta_meta_axis.hpp
SOLL/FIX: Bei Grammatik-Umbau alle 5 Stellen mitziehen (Merge-Flaeche).
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Posten 1; Merge-Flaeche zu jedem Stempel-Branch (ce bau/s7-algo-hardware-stempel!)

### [wpmdvux3p.json] 9
GEGENSTAND: Der Stempel-Tokenizer kodiert das Hardware-Flag als 2-Bit-Feld (Bits 1-2 von reserved:uint32_t, 00=c/01=g/10=f/11=n) im 48-Byte-Entry-POD; nur 6 von 32 Bit belegt, 26 Bit frei fuer breitere Kodierung ohne sizeof-Bruch.
ORT: ce abi/anatomy_stamp_entries.hpp:24-29,105-134,492 (aus Vorexplore uebernommen, nicht erneut gelesen)
SOLL/FIX: Erweiterung ohne sizeof-Bruch moeglich -- Design-Spielraum fuer cpe/xNUMBER.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Posten 1

### [wpmdvux3p.json] 10
GEGENSTAND: Bei einer Grammatik-Migration sind 138 Bestands-Literale betroffen (Nenner-Zaehlung des Vorexplores 20260807-EXPLORE-benchmark-zuordnung-und-flag-grammatik.json, Abschnitt flag-grammatik-cpe).
ORT: super docs/sessions/20260807-EXPLORE-benchmark-zuordnung-und-flag-grammatik.json:79-125
SOLL/FIX: Migrations-Aufwand einpreisen; Ein-Zeichen-Regel ist dreifach ratifiziert (POD-2-Bit-Kodierung, Negativ-Tests).
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Posten 1, 9

### [wpmdvux3p.json] 11
GEGENSTAND: prtart-Repo wurde in Karte 1 NICHT tief durchsucht (nur struktureller Blick, kein Volltext-Grep) -- Restzweifel am Nullbefund fuer AVX-Flag-Bezug dort.
ORT: /home/comdare/Projekte/Research/comdare-prt-art
SOLL/FIX: Quelle: "falls dort doch etwas liegt, ist es mit dieser Kartierung nicht ausgeschlossen".
STATUS LT. QUELLE: offen (Restzweifel, Stufe-1-Zeitbudget)
ABHAENGIGKEIT/FLAECHE: -

### [wpmdvux3p.json] 12
GEGENSTAND: Owner 12:19 korrigiert die Doku ausdruecklich von Blacklist auf Whitelist; die Blacklist-Sprache lebt aber an mind. 6 Stellen: Ledger SS59 (Owner-Verbatim 20.07. 'negatives Blacklisting' -- die Quelle der kritisierten Sprache!), experiment_schema.xsd:321-325 (+ :87-89, :612-615 'Abwesenheit=alles'), experiment_golden_kern.xml:132-134, 18_MESS_METHODIK...KONSOLIDIERT.md:156, Plan V3.2:706, PLAN-48:51+101 (Bauanweisung der XSD-Annotation).
ORT: super Code/test_data_xml/experiment_schema.xsd:321-325,87-89,612-615 | experiment_golden_kern.xml:132-134 | Ledger:3138-3143,:3200,:2969 | docs/architektur/18_MESS_METHODIK_ACHSEN_OPTIMIERUNG_KONSOLIDIERT.md:156
SOLL/FIX: Owner: XML-Semantik ist Whitelisting, kein Blacklisting; Doku/XSD-Kommentare umformulieren. Zusatzbefund: im Code wird bereits 'Whitelist' verwendet (xml_config_parser.hpp:343-350,424,455; merge_plan.hpp:41,47,91; validate_profile.hpp:578,581; sota_catalog.hpp:625-626), die 'Abwesenheit=volle Liste'-Semantik liegt darunter.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Owner-KERN SS59/U-2 (Ausschluss pruefen, dann mergen -- die Blacklist-Sprache STAMMT vom Owner 20.07.)

### [wpmdvux3p.json] 13
GEGENSTAND: libxlsxwriter ist NICHT vendored: ext/io/ enthaelt nur liburing/, git log fuer ext/io/libxlsxwriter = 0 Commits in gesamter Historie; a9-Design-Akte Abschnitt 3 legt Vendoring fest (BSD-2-Clause, Tag v1.2.4, Pfad ext/io/libxlsxwriter/ + ext/io/zlib/).
ORT: ce ext/io/ | ce docs/architecture/20260803-a9_xlsx_writer_f3_soll_design.md Abschnitt 3
SOLL/FIX: Vendoring gemaess a9-Akte nachholen (Teil des xlsx-Writer-F3-Baus).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: a9-Akte Abschnitt 10: sechs offene Entscheidungsvorlagen V-A9-1..6

### [wpmdvux3p.json] 14
GEGENSTAND: Owner verlangt zeitlich orientiertes Chart im xlsx-Profil; native Excel-Chart-Objekte kommen in a9-Akte und 1442 gepruefte Owner-Nachrichten NICHT vor (0 Treffer); OWNER-VORLAGE schlaegt drei Sheet-Form-Optionen vor: (a) ein Sheet je Mess-Layer mit Checkpoints als Zeilen [Empfehlung], (b) ein Sheet je Funktionsaufruf, (c) ein langes Zeitreihen-Sheet mit Layer als Spalte; plus offene Frage native Excel-Charts.
ORT: super docs/sessions/20260807-OWNER-VORLAGE-cpe-grammatik-und-profil-chart.md:92-125 | Transkript :11321, :13579
SOLL/FIX: Owner-Entscheid zur Sheet-Form + Chart-Frage einholen; Blattform lt. Thesis+a9 ist Zeile-pro-Messergebnis je Unter-Achsen-Permutation + Info-Sheet (KEIN Zeitreihen-Traeger).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 13; Thesis kapitel de/en 05_evaluation/06_fazit ratifizieren die a9-Blattform

### [wpmdvux3p.json] 15
GEGENSTAND: Schritte/Checkpoints INNERHALB einer Funktionsausfuehrung existieren nicht (0 Treffer bei 7 Namensmustern); vorhanden sind nur fill_checkpoints{10,100,1000} (Fuellstands-Stuetzpunkte ZWISCHEN Operationen, tier_observe_trace_abi.hpp:34,133,210,281-283) und die seg_ns-Segment-Lambda mit 4 Segmenten (abi_adapter.hpp:645-681,743-775); PLAN messkette O-4 'vierter Observer-Layer' mit drei Bau-Wegen A/B/C, Empfehlung Weg B.
ORT: ce builder/anatomy_commands/tier_observe_trace_abi.hpp | ce anatomy/abi_adapter.hpp:645-775 | super docs/plaene/20260806-PLAN-messkette-ceb-observabletier.md:~920-935
SOLL/FIX: Weg B des O-4-Plans (vierter Observer-Layer als Quelle des zeitlich geloggten Profils).
STATUS LT. QUELLE: offen (teilweise gebaut)
ABHAENGIGKEIT/FLAECHE: Posten 14

### [wpmdvux3p.json] 16
GEGENSTAND: Ein bereits eingefuehrtes active-Attribut (A9b) ist rein deklarativ und wird von NIEMANDEM ausgewertet.
ORT: ce xml_config_parser.hpp / profile_facade (A9b-Kontext, Karte 2 STUETZEND-Referenz)
SOLL/FIX: Auswertung anbinden oder Attribut als toten Bestand kennzeichnen (Quelle nennt keinen expliziten Fix).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 12 (Whitelist-Umbau)

### [wpmdvux3p.json] 17
GEGENSTAND: noise_distance_threshold (nearest_cluster(), Online-Zuordnung) hat KEINEN Default und in keinem der 4 Repos einen Zahlwert oder ein Kalibrier-Verfahren (eps-Wahl lt. BEFUND 'fragil'; Unit-Test nutzt illustrativen Wert 2.0).
ORT: ce libs/cache_engine/heuristik/workload_cluster_offline.hpp:450-480,:35-36 | super docs/audits/20260709-workload-cluster-research-BEFUND.md:118-144,239-244,289 | ce tests/unit/test_heuristik_workload_cluster.cpp:239-259
SOLL/FIX: Offener Owner-Entscheid (Welle D, G-4 im STAND-Dokument); Explore 07.08. formulierte vier praezisierte Rueckfragen N-1..N-4 (welche BEFUND-Mechanik 2.4/2 vs. 5.2 gilt, Bezugsraum normalisiert/roh, Kalibrier-Weg, Common-Denominator-Bedeutung).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Owner-Frage N-1..N-4; BEFUND 5.2: noise -> sicherer Default (Common-Denominator)

### [wpmdvux3p.json] 18
GEGENSTAND: Das modifizierte Online-DBSCAN (BEFUND 2.4/2: eps+minPts+fortlaufendes Re-Clustering) ist NICHT gebaut -- Datei-Kopf benennt die Luecke selbst als 'NICHT GEBAUT (zweiter Schnitt/Owner)'; nur die Nearest-Centroid-Variante aus 5.2 existiert.
ORT: ce heuristik/workload_cluster_offline.hpp:21-26
SOLL/FIX: Zweiter Schnitt / Owner-Entscheid; kein Bau vor Owner-Klaerung.
STATUS LT. QUELLE: offen (bewusst zurueckgestellt)
ABHAENGIGKEIT/FLAECHE: Posten 17

### [wpmdvux3p.json] 19
GEGENSTAND: Drift-Detektor-Schwelle (Default 5%, median-relative Spannweite ueber N=3, max_reruns=3) ist mechanisch fertig, aber die exakte Kalibrierung gegen reale PMC-Laeufe steht aus (#156-gegatet, mehrtaegiger Voll-Lauf).
ORT: ce builder/commands/drift_detector.hpp:1-24,42-74,93
SOLL/FIX: Kalibrierung nach #156 (286er-Experiment, nie pollen).
STATUS LT. QUELLE: teilweise (Mechanismus fertig, Kalibrierung offen)
ABHAENGIGKEIT/FLAECHE: #156 / Prod-CI-Mehrtages-Experiment

### [wpmdvux3p.json] 20
GEGENSTAND: Owner-Aussage Frage 8 (RunMethodology-Enum = parallele Zielkategorie, Reihenfolge bewusst NICHT Stufenordnung) ist NICHT im Ledger gebucht -- nur Live-Transkript:13579 + Workflow-JSON tragen sie; 'Zielkategorie'/'Zielverhalten' = 0 Treffer im gesamten Korpus, Plan fuehrt die Kategorie als 'Ablaufmethodik' (Sec.47).
ORT: super Ledger (8234 Z., kein Eintrag) | Transkript :13579 | run_methodology_registry.hpp:10-24 (Kommentar-Landung 491fff65 'docs(modi): O-A nachgezogen')
SOLL/FIX: Ledger-Buchung der Frage-8-Antwort nachholen; Code-Kommentar ist bereits nachgezogen (491fff65).
STATUS LT. QUELLE: teilweise (Code behoben@491fff65, Ledger-Buchung offen)
ABHAENGIGKEIT/FLAECHE: Ledger-Pflege (heute KON58)

### [wpmdvux3p.json] 21
GEGENSTAND: XSD RunMethodologyType-Kopfkommentar nennt nur {debug/measure/release} OHNE compare -- inkonsistent zu den 4 Registry-Werten (A-12: genau 4 Modi inkl. COMPARE, CUSTOM_COMPILE ist CLI-Feature, nie im Stempel).
ORT: super Code/test_data_xml/experiment_schema.xsd:289-300 (Element :101)
SOLL/FIX: XSD-Kommentar auf 4 Modi nachziehen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: A-12 (20260726-KONSOLIDIERUNG...ANKER.md:27,43)

### [wpmdvux3p.json] 22
GEGENSTAND: Stale TODO-Kommentar in measurement_axis_registry.xml:58-60 behauptet, die 3 Mess-Modi Debug/Mess/Release existierten nicht als Typen und wuerden nicht emittiert -- widerlegt durch run_methodology_registry.hpp (4 typisierte Werte).
ORT: ce include/cache_engine/measurement/measurement_axis_registry.xml:58-60
SOLL/FIX: Stale Kommentar korrigieren (4 Modi, typisiert).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 21

### [wpmdvux3p.json] 23
GEGENSTAND: Die DE-Thesis-Korrektur 'Modi sind typisiert, und es sind VIER' (Commit 47018e7b, 07.08. 09:33) fehlt in der EN-Fassung (anhang/en/D_building_block_matrix.tex: 0 Treffer 'Modi'/'Modus').
ORT: thesis anhang/en/D_building_block_matrix.tex | DE-Pendant :1269
SOLL/FIX: EN-Spiegel nachziehen (DE fuehrt).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Thesis-Doktrin DE fuehrt

### [wpmdvux3p.json] 24
GEGENSTAND: persistence_target (18. Kompositions-Achse seit STRUKT-R ORG-18) hat KEINE Zeile im axis_optimization_catalog (CatalogAxis T0..T18 ohne persistence_target; catalog_axis_from_name("persistence_target") liefert nullopt, per EXPECT_FALSE getestet); Owner-Frage-4-Antwort: 'minimale Groesse als default, minimale Latenz, minimale Zeit fuer Schreiben'.
ORT: ce heuristik/axis_optimization_catalog.hpp:1-56,66-256,337-426 | ce tests/unit/test_heuristik_spline_break_even.cpp:401-429 | STAND-Dokument G-2
SOLL/FIX: Bau-Skizze (NICHT gebaut) aus research[0].bau_skizze: (1) Katalog um CatalogAxis::PersistenceTarget=19 mit 3 Zielgroessen erweitern, (2) neues rein strukturelles XSD-Element <optimization_targets> nach measurement_tooling-Muster (Whitelisting, direction optional gegen Drift), (3) fehlende Bruecke CSV-Spalte->Katalog-Zielgroessen-Id bauen, bevor eine XML-Nennung Wirkung haette.
STATUS LT. QUELLE: offen (G-2 offiziell beim Owner offen)
ABHAENGIGKEIT/FLAECHE: static_asserts 17 MAX/28 MIN/45 Zielgroessen/15 Achsen-mit-MAX/3 Pareto muessen mitgezogen werden

### [wpmdvux3p.json] 25
GEGENSTAND: Es gibt KEINEN XML-Kanal fuer Optimierungs-Ziele/-Richtungen (0 Treffer objective|optimi|zielgroesse|direction|minimize|maximize in beiden XSDs) und KEIN einziges default="-Attribut im ganzen Schema -- Owner verlangt aber XML-manuell-setzbare Defaults, die sich durchziehen und fuer das 'Erstellungsziel' durchsetzen.
ORT: super Code/test_data_xml/experiment_schema.xsd (682 Z.) + messreihe_v32_schema.xsd (161 Z.)
SOLL/FIX: siehe Posten 24 Bau-Skizze (XSD-Element <optimization_targets>).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 24; einziger heutiger Kanal ist CLI --objectives am best_binary_selector (6 Metriken)

### [wpmdvux3p.json] 26
GEGENSTAND: metric_direction() im best_binary_selector liefert fuer ALLE sechs Selector-Metriken hart Minimize (inkl. Default-Fall) -- ohne Min/Max-Semantik je Achse laeuft der Kurvenvergleich fuer Max-Achsen systematisch falsch herum (Warnung T-9 der OWNER-VORLAGE).
ORT: ce builder/best_binary_selector/best_binary_selector.hpp:244-253 | OWNER-VORLAGE-alle-offenen-entscheide:168-170 (T-9)
SOLL/FIX: Min/Max-Semantik je Achse ('Deep Research frueh starten'); CSV->Katalog-Bruecke existiert nur als Zeilenkommentar :246-251, keine Datenstruktur.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 24, 25; G-3 (vier ungeklaerte Pareto-/XML-Bruecken-Entscheide: welche CSV-Spalten als MAX, CSV->Katalog-Id-Bruecke fehlt, Default-Zielgroessenmenge ist Agenten-Setzung, Mehrelement-Front-Versand)

### [wpmdvux3p.json] 27
GEGENSTAND: T-Nummern-Kollision nirgends entschieden: BEFUND T17=queuing_q1 vs. Thesis T17=persistence_target vs. Auftrag 'T19'; zusaetzlich existiert eine VIERTE, breitere Zaehlung 'axes26' (T00..T2x, 26-Slot-Matrix inkl. System-/Build-/Shape-Achsen) in registry_to_axis_levels.hpp:124-203.
ORT: ce builder/experiment_tree/registry_to_axis_levels.hpp:124-203 | research[0].offen
SOLL/FIX: Entscheid der kanonischen T-Nummerierung; auch: Zuordnung 'Owner-Frage 4 = persistence_target' ist ABGELEITET, nicht vom Owner benannt.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 24

### [wpmdvux3p.json] 28
GEGENSTAND: Aus research[0].offen (10 Eintraege): Pareto-Einstufung von persistence_target nicht entschieden; persistence_latency vs. writeback_time messtechnisch heute identisch (derselbe Seg-Timer); Messgroesse fuer persisted_footprint existiert im Code nicht (Default MemoryOnlyTarget: writes_back_to_disk()=constexpr false, persistence_writeback_scan=return 0).
ORT: super docs/sessions/20260807-EXPLORE-sechs-lose-flags-xlsx-noise-minmax-paper.json result.research[0].offen | ce axes/persistence_target/axis_persistence_target_memory_only.hpp:35,54-56
SOLL/FIX: Vor Katalog-Erweiterung messtechnische Trennung/Neubau der Messgroessen klaeren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 24

### [wpmdvux3p.json] 29
GEGENSTAND: Kein Repo-Dokument bildet Paper->Metrik direkt ab (Doc 32 = Paper->Lastprofil, Doc 17+18 = Paper->Code/Achse, 33 sota/*.profile.xml ohne Metrik-Feld); einzige Paper->Metrik-Tabelle ist das LOS-6-Dossier (aus Original-PDFs); dessen Luecken-Liste L-01..L-18: Cycles/Instructions/IPC/Branch-Miss/L2/STLB/Fill-Buffer/Baumhoehe/FPR/Thread-Skalierung/Kohaerenz/Bandbreite/Kompression/Energie fehlen heute in der Mess-Kette.
ORT: super docs/sessions/20260807-EXPLORE-sechs-lose-flags-xlsx-noise-minmax-paper.json result.research[1] (antwort 24911 Zeichen, 49 belege)
SOLL/FIX: L-01..L-18 als Metrik-Luecken-Katalog fuer die geplante XML-Whitelist; Owner: Paper-Metrik-Recherche ist Vorstufe der Min/Max-XML.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 12, 24, 25

### [wpmdvux3p.json] 30
GEGENSTAND: PMC-Ist-Stand: NUR DREI Counter werden real geoeffnet (cache_misses_l1, cache_misses_l3 'ehrlich LL', dtlb_misses) plus best-effort RAPL-Energie; cache_misses_l2 und coherence_invalidations werden NIE geoeffnet (kein portabler Counter); branch_misses wird von KEINER Quelle befuellt (offener Posten M-3a); cache_misses_l3 scheitert auf AMD Zen5 mit ENOENT.
ORT: ce builder/linux_perf_pmc_source.hpp (403 Z., :16,208-214,212,232,334) | include/cache_engine/measurement/pmc_source.hpp:29-31
SOLL/FIX: M-3a (branch_misses-Quelle) offen; L2/Coherence-Zaehler fehlen strukturell.
STATUS LT. QUELLE: offen (M-3a explizit als offener Posten markiert)
ABHAENGIGKEIT/FLAECHE: Posten 29; PMC = Meta-Meta-Achse, eigene Permutation AMD!=Intel (Owner 10.08.)

### [wpmdvux3p.json] 31
GEGENSTAND: ZWEI getrennte CSV-Serialisierer im selben Repo: 16+6-POD ComdareMeasurementSnapshotV1 (measurement_snapshot.hpp, 16- bzw. 25-Spalten-CSV) vs. das CI-verdrahtete grosse lazy_csv_header()-Schema (cache_engine_builder_iterator.hpp:469-581, .gitlab-ci.yml:392); dazu ein DRITTES Schema result_aggregator.hpp (+2 weitere Varianten in libs/execution_engine/{src,include}/). Namenskollision: die '16' Kategorien (measurement_category.hpp) sind NICHT dieselben 16 wie im 16+6-POD.
ORT: ce builder/measurement_snapshot.hpp:34-79,156-209 | builder/experiment_tree/cache_engine_builder_iterator.hpp:416-581 | builder/commands/result_aggregator.hpp:1-113
SOLL/FIX: Quelle markiert die Zweigleisigkeit als Befund (kein expliziter Fix genannt); bei jeder Spalten-Erweiterung beide/alle drei Schemata pruefen.
STATUS LT. QUELLE: nur-hinweis (Konflikt-Traechtigkeit)
ABHAENGIGKEIT/FLAECHE: CSV=Kind der xlsx; Posten 14

### [wpmdvux3p.json] 32
GEGENSTAND: total_cycles im 16+6-POD traegt trotz des Namens NANOSEKUNDEN (measurement_snapshot.hpp:42,115).
ORT: ce builder/measurement_snapshot.hpp:42,115
SOLL/FIX: Quelle dokumentiert nur; Namens-/Semantik-Klaerung naheliegend (nicht explizit gefordert).
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Posten 31

### [wpmdvux3p.json] 33
GEGENSTAND: Die Collector-Vereinigung (WallClockSystemAxis->LATENCY_MEAN+THROUGHPUT, ObserverSnapshotSystemAxis->CLU, PmcSystemAxis->7 PMC-Kategorien) bedient nur 10 von 16 Mess-Kategorien real (Thesis-Anhang-D-Hinweis).
ORT: thesis anhang/de/D_building_block_matrix.tex:1140-1199
SOLL/FIX: Luecke 6 von 16 Kategorien unbedient (deckt sich mit L-01..L-18 und M-3a).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 29, 30

### [wpmdvux3p.json] 34
GEGENSTAND: Zwei verschiedene paper_ref-Tokens fuer denselben Pruefling: ce thesis_profiles nutzen paper_ref="PRT", prtart_pruefling.profile.xml traegt paper_ref="PRTART".
ORT: prtart prt_art/algorithm_profiles/prtart_pruefling.profile.xml:5 | ce algorithm_profiles/thesis_profiles/*.profile.xml
SOLL/FIX: Token vereinheitlichen (Quelle: 'zwei verschiedene Tokens fuer denselben Pruefling').
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [wpmdvux3p.json] 35
GEGENSTAND: In ce axes/alloc/PAPER_REFERENCES.md fehlen laut explizitem Vermerk noch CrystallineAllocator(A17) und VampirNfpAllocator(A24) in der Tabelle.
ORT: ce libs/cache_engine/axes/alloc/PAPER_REFERENCES.md (61 Z., Tabelle Par.2)
SOLL/FIX: Tabelle vervollstaendigen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [wpmdvux3p.json] 36
GEGENSTAND: Sechs STOPP-Gate-Entscheide E-A..E-F des Versionierungs-Interface-Plans sind durch drei Konsolidierungen verloren gegangen (0 Treffer in beiden Owner-Vorlagen 07.08., Ledger, Gesamtdossier) und blockieren den Owner-KERN F7=Option b vollstaendig; E-A Hex-Laenge 16/24/32, E-B Name im Symbol i/ii/iii, E-C Sidecars auf POD a/b/c, E-D Ordner/CSV auf Stempel-Namen a/b/c, E-E Overlay-Glied scharfschalten a/b, E-F Planer-Stufe honest-empty vs eigenes Set a/b; Lead-Empfehlungen b/ii/b/a/b/a.
ORT: super docs/plaene/20260806-PLAN-versionierungs-interface-stempel.md:644-654 (Tabelle), :598-624 (DAG S6-S9), :700-704 (Gates) | Ledger:8132-8140 (BEFUND 2, d12fdc14) | STAND:76-80 (G-1)
SOLL/FIX: Gate-Text: der jeweilige OWNER-ENTSCHEID muss SCHRIFTLICH vorliegen und im Ledger verbucht sein, mit AUSGEWIESENER statt behaupteter Anker-/Sidecar-Bilanz, bevor gebaut wird. S6/S7=[BE] Byte-Ereignis, S8=[FP] Fingerprint-Ereignis. Eine ausformulierte Owner-Vorlage fuer E-A..E-F existiert noch NICHT.
STATUS LT. QUELLE: offen (G-1; blockiert F7=b)
ABHAENGIGKEIT/FLAECHE: Owner-Frage; Merge-Flaeche zu ce bau/s7-algo-hardware-stempel; 'Identitaets-Umbauten heute kostenlos, ab 26.08. teuer'

### [wpmdvux3p.json] 37
GEGENSTAND: Der Plan-Ist-Anker ist STALE: Preimage steht heute auf Format 4 mit 9 Gliedern (R-3 vom 07.08. haengte Mess-Gates-Glied an [8] an; neuer Frozen-Wert beginnt 5b18feac..., Alt-Wert 17148e5a... nur Historienkommentar), der Plan vom 06.08. fuehrt Format 3/8 Glieder (bzw. Kopf: ce 3bbcb8ed Format 2/6).
ORT: ce abi/anatomy_fingerprint.hpp:90,106,384-387,409-417 | ce tests/unit/test_m_w12_stamp_bausteine.cpp:672-691 | Plan :19-52
SOLL/FIX: Vor Umsetzung der Plan-Schritte S1-S9 den Ist-Anker neu erheben (Plan nicht blind bauen).
STATUS LT. QUELLE: offen (Plan-Anker veraltet)
ABHAENGIGKEIT/FLAECHE: Posten 36

### [wpmdvux3p.json] 38
GEGENSTAND: Die im Plan S1/S2 verlangten Header abi/version_stamp_interface.hpp + abi/version_stamp_name.hpp existieren nicht (0 Treffer im ce-Baum), das Symbol comdare_version_stamp (S3/S9) ebenfalls nicht -- nichts vom Plan wurde gebaut; 'DREI Konsolidierungen' (welche die Entscheide verloren) sind an keiner Stelle einzeln benannt.
ORT: ce abi/ (Nullbefund) | ce abi/anatomy_module_abi_v1_decl.hpp:89,119-137,234,241,278-286 (Ist: ABI-Major 8, 4 Pflicht-Symbole, kein version_stamp)
SOLL/FIX: Bau erst nach E-A..E-F-Entscheiden (STOPP-Gate); Identifikation der drei Konsolidierungen offen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 36, 37

### [wpmdvux3p.json] 39
GEGENSTAND: Sidecar-Suffixe leben an DREI Literal-Quellen: build_orchestrator.hpp:242-255 (.version/.algos/.variant), fingerprint_sidecar.hpp:49 (.fingerprint -- vom Plan NICHT als eigene Fundstelle genannt), artifact_cache.hpp:100-103 (kOptionalTierSidecars, bewusst entkoppelt).
ORT: ce builder/build_orchestrator/build_orchestrator.hpp:242,248,255 | builder/build_orchestrator/fingerprint_sidecar.hpp:49 | builder/artifact_transport/artifact_cache.hpp:100-103
SOLL/FIX: Bei E-C/E-D-Umsetzung ALLE drei Quellen mitziehen (Plan kennt nur zwei).
STATUS LT. QUELLE: nur-hinweis (Plan-Luecke)
ABHAENGIGKEIT/FLAECHE: Posten 36

### [wpmdvux3p.json] 40
GEGENSTAND: E-A..E-E-Namens-Kollision: am 06.07. wurden 'E-A..E-E' bereits fuer fuenf VOELLIG ANDERE Entscheidungs-Defaults vergeben (Ledger:1148: Reuse-Vendoring, CMD-1, RC-Rest #229, AP-10, perm_runner-Fix) -- ungefilterte E-A..E-F-Suche liefert ueberwiegend Falschtreffer.
ORT: super docs/audits/20260709-wf-todo-audit-e1-e4-SYNTHESE.md:107 | Ledger:1148
SOLL/FIX: Bei jeder E-*-Recherche den GEGENSTAND pruefen, nicht das Kuerzel (deckt sich mit OV-Nummern-Memory).
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Posten 36

### [wpmdvux3p.json] 41
GEGENSTAND: Methodischer Vorbehalt zum Owner-Extraktor: die vorgegebene Regel (type=user + promptSource typed/queued + origin.kind=human) findet in einem geprueften Fenster nur 12 von 20 tatsaechlichen Owner-Aeusserungen, weil mid-turn eingetippte Nachrichten teils als type=attachment/queued_command ankommen.
ORT: Live-Transkript 5a19728e:9470 (task-notification 'Explore: vergessene Arbeit 2 Kontexte')
SOLL/FIX: UNION-Regel verwenden (deckt sich mit Memory 'EXTRAKTOR: DREI PFADE').
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: alle Transkript-basierten Nachweise

### [wpmdvux3p.json] 42
GEGENSTAND: Kein pdftotext auf der Maschine installiert -- die 43 Original-Paper-PDFs (super Forschungsarbeiten/) sind nur ueber das LOS-6-Dossier ausgewertet, nicht maschinell reproduzierbar.
ORT: super Forschungsarbeiten/{traversal=17,prefetch=8,memory_layout=5,concurrency=3,allocator=1,general=1,hardware=1,'low priority'=7} (43 PDFs)
SOLL/FIX: Werkzeug-Luecke bei kuenftiger Paper-Metrik-Verifikation beachten.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Posten 29

---

# DATEI 2: wz67qt3pc.json (111533 B) -- Wallclock als drittes Glied / Mess-Achse dreiphasig (4 Explores + Fable-Dossier, Erhebung 06.08. spaet), alle 5 Agenten state=done

Dossier geschrieben nach: super docs/plaene/20260806-DOSSIER-messachse-wallclock-und-mess-kette.md
Erhebungs-Anker: ce development=2b5ecd29; ce-Submodul-Checkout im super-Baum=90bca126 auf b-m2-pmc-invariante (NICHT development, 2 vor/7 zurueck); super-Gitlink auf ce=b241a272 (=ce main); super HEAD=18a0bdf3. ACHTUNG: Stand 06.08. -- gegen heutige Landungen abzugleichen.

### [wz67qt3pc.json] 1
GEGENSTAND: M-1-Zuordnungs-REGRESSION im ungelandeten Paket b-m1-identitaetsnaht: die Zuordnung wallclock->nur-G1 (mess_achsen_naht.hpp:48-55,77-82) nimmt einer [wallclock]-Binary ALLE 18 Ebene-1-Achsen-Timer -- gemessen (Commit 8f70898a, H-B): [all] observable_axes=9, [wallclock] observable_axes=0 -- und widerspricht dem Owner-KERN direkt (Wallclock ist ORT auf drei Ebenen, kein Gate auf einer).
ORT: /home/comdare/wt-m1-naht (HEAD 4fdedbbf, 7 Commits ueber 2b5ecd29, 24 Dateien +3114/-149) | mess_achsen_naht.hpp:48-55,77-82
SOLL/FIX: Dossier-Verdikt verbatim: "Dringendster Posten vor der Messung ist die Entscheidung und Behebung der M-1-Zuordnungs-Regression VOR der Landung von b-m1-identitaetsnaht ... Das gehoert vor der Landung entschieden, nicht danach."
STATUS LT. QUELLE: offen (Paket ungelandet; Regression im Paket)
ABHAENGIGKEIT/FLAECHE: Owner-KERN 06.08. abends; Landung b-m1-identitaetsnaht; Tooling-Werte sind lt. Objekt eine INKLUSIONSKETTE (MEASUREMENT_ON subset CE_ENABLE_STATISTICS), keine Orte

### [wz67qt3pc.json] 2
GEGENSTAND: b-pmc-l3-honest ist NICHT committet: 0 Commits, nur uncommitteter WIP (5 Dateien, +136/-13; Pro-Zaehler-Verfuegbarkeits-Flags l2/l3/coherence/energy, CSV n/a statt erfundener 0, Ruecknahme der Falschaussage 'PmcCounters ERHEBT branch_misses real', Biss-Tests W7-W10); ohne Landung erfindet die Voll-Messung Nullen fuer l3/energy auf AMD (Zen5 ENOENT fuer PERF_TYPE_HW_CACHE/LL).
ORT: /home/comdare/wt-pmc-l3-honest (HEAD==development==2b5ecd29) | pmc_source.hpp:28-43 | cache_engine_builder_iterator.hpp (pmc_zelle-Lambda) | linux_perf_pmc_source.hpp:276-281
SOLL/FIX: Dossier: "unmittelbar dahinter b-pmc-l3-honest committen/landen". Ledger-Posten B-5 inhaltlich fertig, aber nicht committet, nicht getestet-belegt, nicht gelandet. AMD-ENOENT-Verifikation steht NUR als Behauptung im WIP-Kommentar, ohne Log-Beleg.
STATUS LT. QUELLE: offen (WIP uncommitted)
ABHAENGIGKEIT/FLAECHE: offen bleiben B-6 (RAW-Events je Mikroarchitektur) und M-3a (branch_misses real)

### [wz67qt3pc.json] 3
GEGENSTAND: T17-Nachweis: seg_persistence_target_ns = 0 in 16/16 CSV-Zeilen (stiller Messwert-Verlust, A8-Dossier-Befund B-6 'DEFEKT CONFIRMED': drei '< 17'-Kopierschleifen bei kV3AxisCount==18); Code-Fix teilweise da (abi_adapter.hpp:1102-1109 zieht Grenze aus kV3AxisCount), die CSV vom 26.07. stammt von davor -- Nachweis-Messung fehlt.
ORT: measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv | ce anatomy/abi_adapter.hpp:1102-1109
SOLL/FIX: T17-Nachweis seg_persistence_target_ns VOR der Voll-Messung fuehren (Dossier Punkt 3).
STATUS LT. QUELLE: teilweise (Code-Fix da, Beleg-Messung offen)
ABHAENGIGKEIT/FLAECHE: Voll-Messung; Posten 2 (gleiche CSV-Zeile betroffen)

### [wz67qt3pc.json] 4
GEGENSTAND: Ebene 1 misst heute NICHT die echten Achsenaufrufe: fill_segment_timing_v3 (LIVE via tier_observe) zeitet einen SYNTHETISCHEN NACHLAUF derselben Ops (Kommentar :1776-1780) und aggregiert je Achse ueber n_ops; die reale Gattungs-Funktion tier_lookup fuehrt 7 Achsen-/Organ-Aufrufe aus, GEMESSEN: 0 (Bereich abi_adapter.hpp:1128-1780 komplett clock-frei, Gegenprobe 83 chrono-Treffer in der Datei).
ORT: ce anatomy/abi_adapter.hpp:1253-1298 (tier_lookup), :1776-1780, :1781-2035
SOLL/FIX: Owner-Wortlaut verlangt 'fuer jeden Achsenaufruf IN der Tier-Binary' die ECHTEN Aufrufe; Umbau-Bedarf (E1-Umwidmung ist Owner-OK-pflichtig, OF-A8-2 -- der Owner-KERN koennte OF-A8-2 schliessen, ist aber Ableitung, nicht Beleg).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: OF-A8-2; A8-Dossier 20260803-a8_f2_benchmarking_schnitt_soll_design.md

### [wz67qt3pc.json] 5
GEGENSTAND: Ebene 2 laeuft im Host-Orchestrator statt 'AUF dem Pruefdock': run_workload_profile misst 6/6 Op-Arten je Aufruf, aber das Dock hat 0 Zeilen Zeitcode (17 Dateien/3161 Zeilen: 16x0, 2 Kommentar-Treffer); IPruefDock::measure() hat 0 Produktionsaufrufer (12 Treffer, ALLE tests/unit/); Produktionspfad umfaehrt das Dock via acquire_search_algorithm_drive (4 dynamic_cast) + run_conformance_gate.
ORT: ce builder/workload_driver/workload_orchestrator.hpp:65-164 | builder/pruef_dock/ | cache_engine_builder_iterator.hpp:2394-2395 | perm_runner.hpp:158
SOLL/FIX: Owner-KERN verlangt Messung AUF dem Pruefdock; die EINE Stelle, die alle drei Kriterien erfuellt (Wallclock je Funktionsaufruf + Verlaufs-Nullpunkt + Dock-Erreichbarkeit) ist drive_two_phase_tier_trace_abi + SearchAlgorithmDock::measure -- gebaut, getestet, im Produktionspfad NICHT angeschlossen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: 'PMC ins Pruefdock'-Owner-KERN wird an derselben Stelle konkret

### [wz67qt3pc.json] 6
GEGENSTAND: Ebene 3 (large scope) hat KEINEN aeusseren Clock: run_workload_profile/run_measurement_plan enthalten 12 clock::now(), alle 12 innerhalb einer Op; total_ns ist SUMME der Op-Zeiten (Zeit ZWISCHEN Funktionsaufrufen unsichtbar) und steht nicht einmal in der CSV des Serializers :233-261.
ORT: ce workload_orchestrator.hpp:45,85,182-197 | perm_runner.hpp:321-332
SOLL/FIX: Aeussere Verlaufs-Klammer bauen (Bautyp existiert: seg_run_total_ns als Vorbild); Lastprofil-Pfad hat die P-MD3-Versoehnung (seg_framework_ns/seg_run_total_ns) nie bekommen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 5 (Verlaufs-Treiber haengt am toten Dock-Pfad)

### [wz67qt3pc.json] 7
GEGENSTAND: 'Wallclock ist das dritte Glied' ist als Registry-Position WIDERLEGT (WallClock=Index 0, static_assert-verriegelt), als Mess-Zeile=Glied[3] des Fingerprint-Preimage/Stempels DREIFACH BELEGT (Preimage-Ordnung anatomy_fingerprint.hpp:428-431, ABI-POD append-only anatomy_module_abi_v1_decl.hpp:180-192, Stempel-Zeilen anatomy_version_stamp.hpp) -- KEINE Textstelle spricht die Gleichsetzung aus (Rekonstruktion).
ORT: ce measurement/measurement_tooling_registry.hpp:27-31,46-50,93 | abi/anatomy_fingerprint.hpp:428-431,:341 | abi/anatomy_version_stamp.hpp:53-216
SOLL/FIX: Empfehlung verbatim: "die Registry-Ordnung NICHT anfassen -- sie ist static_assert-verriegelt, und eine Umordnung wuerde jeden Stempel und jeden golden-Fingerprint brechen. Die 'Drittheit' gehoert an das GLIED, nicht an die Registry."
STATUS LT. QUELLE: nur-hinweis (Owner-Lesart U-1 offiziell unbelegt)
ABHAENGIGKEIT/FLAECHE: Owner-Entscheid U-1 (welche Lesart); U-2 ('DREIPHASIG' = Kette Planer/CEB/Tier, nicht die drei Ebenen -- zwei verschiedene Dreien in einem Satz, im Ledger explizit auseinanderhalten)

### [wz67qt3pc.json] 8
GEGENSTAND: D-1 gilt am 06.08. unveraendert: die Mess-Tooling-Achse hat 0 funktionale Konsumenten (MeasurementTooling:: = 3 Treffer, alle in der Registry-Tabelle selbst; Nenner 155 Treffer); perm_mess_defines() setzt HART 4 Literale ohne Tooling-Bezug; einziger funktionaler Effekt der Tooling-Wahl ist SCHEDULING (Lane-Wahl: macro->intel prod2, wallclock/micro/[all]->amd prod1, experiment_plan_director.hpp:600-602).
ORT: ce profile_facade/profile_run_facade.cpp:273-275 | experiment_plan_director.hpp:600-602,2020-2022
SOLL/FIX: Heilung liegt im ungelandeten b-m1-identitaetsnaht (live_mess_achsen_defines()), traegt aber die widerlegte G1/G3-Zuordnung (Posten 1); Fan-out/Call-Site-Verdrahtung gehoert lt. Planer-Selbstauskunft dem Schwester-Paket P-MESSTOOL.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 1; P-MESSTOOL

### [wz67qt3pc.json] 9
GEGENSTAND: Thesis-Selbstwiderspruch: 03_messsystem_prtart.tex:992 'das Mess-Tooling spannt die drei Granularitaeten des Benchmarkings auf' (Gleichsetzung A==B) widerspricht :1305-1312 und 04_implementierung.tex:496-502 ('Registry-Schnitt ist Implementierungs-Stand, nicht Soll ... die Registry zieht diesem Modell nach') -- die Textstelle, aus der die Verwechslung entstehen konnte.
ORT: thesis kapitel/de/03_messsystem_prtart.tex:992
SOLL/FIX: Quelle verbatim: "Eine Ein-Satz-Aenderung an 03:992 heilt es -- der Rest der Arbeit ist bereits konsistent."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: EN-Spiegel mitziehen (DE fuehrt)

### [wz67qt3pc.json] 10
GEGENSTAND: Soll-Matrix 3 Tooling x 3 Ebenen ist KEINE Vollmatrix: nur 6 von 9 Zellen besetzt; wallclock als einziges Instrument belegt alle drei Ebenen; micro(PMC) belegt genau EINE Zelle (Ebene-3-Klammer um die ganze Run-Phase, perm_runner.hpp:196/205,314/318); PMC je Achsen-Segment und je Gattungs-Op NICHT gebaut.
ORT: A8-Dossier :242-246 (Tooling-Neuzuordnung byte-stabil: 'WallClock = die 3 CEB-Ebenen, Macro = Gattungs-/Ende-zu-Ende, Micro = Achsen-Interface intern; ids/Stempel-Token BYTE-STABIL, nur Doku/Semantik zieht nach (deprecaten, nie loeschen)') | :130-133
SOLL/FIX: A8-3.5-Neuzuordnung umsetzen (byte-stabil); B-1 'Micro ohne Traeger' (Tooling-id micro hat keinen kompilierten Effekt, Registry-Doku definiert Micro als PMC -- F2-widrig).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: F2-Gesetz (Owner 01.08., THESIS-FAKTEN-KANON.md:391-394); Invariante 'Summe(E1-konstitutiv) <= E2 <= E3, jeder Rest EXPLIZIT benannt' (A8:225-226)

### [wz67qt3pc.json] 11
GEGENSTAND: Die drei Erhebungs-Ebenen existieren im Code als drei UNVERBUNDENE Strukturen ohne gemeinsames Ebenen-Vokabular (kein enum MeasurementLevel/BenchmarkGranularity; 0 Code-Treffer fuer 'Wallclock-Ebene'); A8-Befund B-7 'Ebenen unbenannt/unvollstaendig' unveraendert gueltig.
ORT: ce (kein Typ) | A8-Dossier :169-171
SOLL/FIX: Ebenen als benanntes Konzept schneiden/etikettieren (B-7); ob sie eigene Registry-Bausteine werden = Owner-Entscheid (B-7/B-8, Ledger:4632-4634 'nach Abgabe').
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Owner-Entscheid; CSV-Trennung Ebene/Wert = gleiche Klasse wie B-3 ('getrennte Ablage je PMU-Domaene, VOR der Messung, sonst Datenbruch') und gleiche Frist

### [wz67qt3pc.json] 12
GEGENSTAND: Korrektur K-1 am DIFF-Dokument 20260806-DIFF-thesis-soll-gegen-ledger-und-code.md:439-444,:566 ([Par.63-T-15]): 'seg_ns ungefuellt' ist am Objekt WIDERLEGT (16/16 Zeilen gefuellt, seg_coverage=0.999963); falscher Anker (Pfad A statt Pfad B); A_measurements.tex:148-149 falsch gelesen -- es fehlt der GENERATOR-Schritt (anhang/de/tabellen/seg_attribution.tex existiert nicht), nicht die Messwerte.
ORT: super docs/plaene/20260806-DIFF-thesis-soll-gegen-ledger-und-code.md:439-444,566 | thesis anhang/de/A_measurements.tex:148-149
SOLL/FIX: DIFF-Dokument korrigieren; seg_attribution-Generator-Schritt bauen; bestehen bleibt NUR der T17-Fall (Posten 3).
STATUS LT. QUELLE: teilweise (Falschaussage identifiziert, Korrektur-Buchung offen)
ABHAENGIGKEIT/FLAECHE: Posten 3

### [wz67qt3pc.json] 13
GEGENSTAND: Owner-KERN-Bilanz (12 KERNe, Stand 06.08.): #3 PMU-Domaenen-Trennung FEHLT (cpu_core_atom_perf_separation nie gesetzt, cpuid_platform_probe.hpp:38-39 'AP-13: bewusst ungesetzt', cpu_atom 0 Treffer, EXPECT_FALSE zementiert in test_cpuid_probe.cpp:62-63); #4 EINE-CEB-zwei-Messfuehler FEHLT (keine Core-Klassen-Unterachse, kein Doppelstart, 0 ScopedThreadPin in perm_runner); #6 Warntext 'warn: no pinned locality on hybrid architecture' NICHT GEFUNDEN (0 Treffer, Gegenprobe sehend); #7 Schwere-Leiter warn/error/fatal FEHLT als Typ (8 Enums in axis_error.hpp, keine Severity); #9 numa_cpu_pin_process_probe FEHLT (0 Treffer; 11 sub_axis-IDs, keine mit 'core'; Gegenprobe numa_page_probe=67 Treffer); #10 hybrid/ = 1 README 0 Code (9 geplante Dateien tabelliert, Bau lt. README in Auswertungsphase).
ORT: ce platform/i_platform_probe.hpp:20 | platform_probe/cpuid_platform_probe.hpp:38-39 | measurement/axis_error.hpp | measurement/system_axis_registry.xml | libs/cache_engine/hybrid/README.md
SOLL/FIX: je KERN Bau noetig; Stand 06.08. -- gegen spaetere Landungen (z.B. numa_cpu_pin_process_probe-Paket, woweldept) abgleichen.
STATUS LT. QUELLE: offen (je Zeile)
ABHAENGIGKEIT/FLAECHE: KON34 System B; woweldept (DATEI 7); Owner-Antworten 10.08. (PMC=Meta-Meta-Achse)

### [wz67qt3pc.json] 14
GEGENSTAND: KERN 8 'stiller Rueckfall verboten': NEUER Fall gefunden -- thread_pinning.hpp:61: 'if (::sched_setaffinity(0, sizeof(target), &target) != 0) return;' -- kein Log, kein Status, active() bleibt false, der Aufrufer misst ungepinnt weiter.
ORT: ce builder/measurement/thread_pinning.hpp:61
SOLL/FIX: fail-loud machen (Muster KERN 7); Heilungen andernorts liefen bereits (b-pmc-l3-honest, 22e17f57 errno, c1c76c87 Literal 64).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: KERN 6 (Warntext) am selben Ort

### [wz67qt3pc.json] 15
GEGENSTAND: Auswertungs-Kette (KERN 11/12) ist als Bibliothek VOLLSTAENDIG gebaut und operativ tot: measurement_curve_loader -> axis_spline -> break_even -> HybridBinarySelector gebaut+getestet; CLI best_binary_selector_main ruft AUSSCHLIESSLICH rank_binaries (0 Aufrufe find_break_evens/break_even_table/HybridBinarySelector); Rueckfuehrung Auswertung->Generierung als 'DEFERRED (#156)' deklariert (selection_filter_chain.hpp:118-121, Einhaengung reine Identitaet); heuristik/ hat 0 produktive Konsumenten; Funktions-Synthese existiert ZWEIFACH (axis_spline.hpp + curve_fit.hpp als deklarierter Spiegel).
ORT: ce heuristik/{measurement_curve_loader,axis_spline,break_even}.hpp | builder/best_binary_selector/best_binary_selector_main.cpp:100 | builder/experiment_tree/selection_filter_chain.hpp:118-121
SOLL/FIX: Verdrahtung best_binary_selector -> resolve_selection (#156); KERN-11-Dimension (b) 'Schnitte ueber Gattungs-/Genus-Funktionsinterfaces' hat KEINEN Code (break_even.hpp schneidet nur zwei Splines DERSELBEN Organ-Achse); Kreuz-Achsen-Aufbau fehlt.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: #156; Hybrid-Stufe (Posten 13 #10)

### [wz67qt3pc.json] 16
GEGENSTAND: Doku-Drift am ABI: anatomy_module_abi_v1_decl.hpp:38 sagt noch seg_ns[17] (:60/:85 nachgezogen auf [18]); static_assert-TEXTE measurable_workload.hpp:118,120 sagen '17-Segment-Latenz-POD' bei seg_ns[18] -- kosmetisch, aber irrefuehrend.
ORT: ce abi/anatomy_module_abi_v1_decl.hpp:38 | anatomy/measurable_workload.hpp:118,120
SOLL/FIX: Kommentar-/Text-Nachzug 17->18.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [wz67qt3pc.json] 17
GEGENSTAND: Fallen-Meldung fuers Register: die Termin-Dokumente kennen die Sache unter 'wall time'/'walltime_ns', NICHT unter 'Wallclock' (wallclock=2 Treffer, beide in zitierten Fremd-Papers) -- wer nach 'wallclock' sucht, meldet eine Null, die keine ist; ausserdem existiert die G1/G2/G3-Lesart in KEINEM persistierten Plandokument (nur Agenten-Lesart des Abends, 'was nur in einem Bericht steht, existiert fuer die Ausfuehrung nicht').
ORT: super docs/termine/ (309 Dateien; Termin-6-Scope-Freeze :55 'wall time' als Pflichtmetrik; Begriffsglossar_v4_FINAL.txt:418 walltime_ns)
SOLL/FIX: ins Fallen-Register aufnehmen; G1/G2/G3-Korrektur trotzdem verbuchen, weil sie in laufende Auftraege eingegangen ist.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Fallen-Register

### [wz67qt3pc.json] 18
GEGENSTAND: Gelandete Heilungen (zur Abgrenzung): 8894d983 M-2/P-PMC-1 (PMC-Pflicht-Invariante 'jede cmake-Zeile mit Mess-Treiber-Folgezeile traegt -DCOMDARE_ENABLE_PMC=ON', Single-Source ceb_pmc_compile_define(), Biss gefuehrt, 409/409 zweimal seriell); 22e17f57 (errno-Sichtbarkeit perf_event_open); 2b5ecd29 (m3v2_pmc_smoke echtes Fenster). OFFEN daraus: B4 (allow_failure) bewusst nicht enthalten = offener Owner-Entscheid O-PMC-1.
ORT: ce development (Commits 8894d983, 22e17f57, 2b5ecd29)
SOLL/FIX: O-PMC-1 beim Owner; Rest behoben.
STATUS LT. QUELLE: behoben@8894d983/22e17f57/2b5ecd29; O-PMC-1 offen
ABHAENGIGKEIT/FLAECHE: allow_failure VERBOTEN seit 06.07. (Zelle vs. Job) -- Konfliktpruefung noetig

### [wz67qt3pc.json] 19
GEGENSTAND: Commit-SHA-Behauptungen des b-m1-identitaetsnaht-Pakets (alle UNGELANDET, Stand 06.08.): b9fd81ff (M-1/D-1 mess_achsen_naht.hpp +562 Z., Wurzel: zwei ungeschuetzte mig_organ_.reset() in MEASUREMENT_ON-Bloecken uebersetzten nicht), 62a5b6f7 (M-1/D-4 kCebFingerprint rendert WAHL statt ANGEBOT; Injektivitaets-Verletzung 4 Uebersetzungen->EIN Schluessel 004251f4... geheilt; ODR-Falle via INTERFACE-Ziel + #error-Wache; KEIN CEB-seitiges Skip-Gate, begruendet fail-OPEN), 246b2793 (M-1/D-2 mess_konsistenz_gate.hpp +359 Z., erster produktiver Leser von measurement_line/measurement_entries, 6 fail-closed-Klassen; Nebenbefund: run_experiment_profile reichte GAR KEINEN Mess-Stempel durch), 8f70898a (H-A Stufen-Wache #else-Zweig; H-1 wallclock-Deklarationspflicht -- dll_is_current meldete 'current' ueber eine Mess-Code-Versionsgrenze; H-2 PMC-Ausstattungs-Invariante micro<->COMDARE_ENABLE_PMC fail-loud; H-B n/a statt 0 in 13 Observer-Zellen), c637f7aa (Merge development), 89bf2ee6/4fdedbbf (Format). ctest 418/418 lt. Commit (nicht selbst gefahren).
ORT: /home/comdare/wt-m1-naht | branch b-m1-identitaetsnaht
SOLL/FIX: Landen NACH Entscheidung der Regression (Posten 1); Auftragskopf-Zahlen '36 Dateien, +3671/-200' sind ueberholter Zwischenstand (real 24/+3114/-149); kein super-Gegenstueck existiert.
STATUS LT. QUELLE: offen (landereif nach Regressions-Entscheid)
ABHAENGIGKEIT/FLAECHE: Posten 1, 8

### [wz67qt3pc.json] 20
GEGENSTAND: Vierte verwechselbare Drei: die collector-Achse {WallClockSystemAxis, ObserverSnapshotSystemAxis, PmcSystemAxis} hat ebenfalls 0 produktive Konsumenten, und anatomy_version_stamp.hpp:164 setzt sie faelschlich/verkuerzend mit der Tooling-Wahl gleich ('Traegt GENAU die gewaehlte Mess-Tooling-HAUPT-Wahl ... (die collector-Achse...)').
ORT: ce measurement/system_axis.hpp:247/308/389 | measurement_axis_registry.xml:25-42 | abi/anatomy_version_stamp.hpp:164
SOLL/FIX: Die vier Dreien (Bau-Phasen, Tooling-Werte, Erhebungs-Ebenen, Collector-Bausteine) im Ledger explizit auseinanderhalten, sonst entsteht dieselbe Konfusion ein zweites Mal.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 7, 11

### [wz67qt3pc.json] 21
GEGENSTAND: Unbelegte Uebernahmen (von der Quelle NICHT nachgemessen): Voll-Bau ~34,4h Wanduhr auf 2 Lanes ([BERICHT]); '0 .fingerprint-Sidecars im super-Baum' + 'der stille Skip ist heute noch nicht scharf' (an b241a272 erhoben, nicht wiederholt); ctest 418/418 und 409/409 (aus Commit-Nachrichten).
ORT: docs/plaene/20260806-PLAN-messkette-ceb-observabletier.md:664 u.a.
SOLL/FIX: Bei Verwendung dieser Zahlen: erst nachmessen.
STATUS LT. QUELLE: nur-hinweis (Restzweifel)
ABHAENGIGKEIT/FLAECHE: -

---

# DATEI 3: wkg9iu9j5.json (89758 B) -- EINE CEB, beide Messfuehler, E-/P-Core-Pinning ueber NUMA-System-Achse (3 Explores + Zuordnung, Erhebung 06.08., ce=90bca126 auf b-m2-pmc-invariante), alle 4 Agenten state=done

Ergebnis-Plan geschrieben nach: super docs/plaene/20260806-PLAN-hybrid-pmc-numa-core-permutation.md (1025 Z., 10 Abschnitte).

### [wkg9iu9j5.json] 1
GEGENSTAND: Die Owner-Achse dockt an numa_node (sub_axis von target_isa, stage="runtime", binary_id="never") korrekt an; es fehlen GENAU ZWEI Dinge: eine Core-Unterachse (11 sub_axis-IDs in der Registry, keine mit 'core') und ein Erheber fuer Kern-Typen (NumaPageTopology traegt nur Node-IDs+Seitengroessen; CPUID-Leaf 0x1A ungelesen, 196 Z./0 Treffer/Gegenprobe cpuid( = 8).
ORT: ce measurement/system_axis_registry.xml:38,10 | measurement/numa_page_probe.hpp:181-184,192,197 | platform_probe/cpuid_probe.hpp
SOLL/FIX: Sechs Bausteine, ALLE Klasse CEB-ONLY (~77 s, 0 Tier-Binaries): (1) Kern-Topologie-Probe an der ISA-x-OS-Zelle, (2) Achsen-Typ + Registry-Zeile + XSD/Parser-Anschluss, (3) Aktuator-Kanal im Dyn-Loop, (4) Pin ueber fertigen ScopedThreadPin/CorePinPolicy, (5) Domaenen-faehige PMC-Quelle, (6) EINE neue CSV-Spalte ran_on_core_type. Fingerprint bleibt unberuehrt (alle 8 Preimage-Glieder belegt; static_assert-Sperre numa_node im Stempel system_cell_values.hpp:166-167,193-196). Kein Neubau.
STATUS LT. QUELLE: offen (entscheidungsreifer Plan)
ABHAENGIGKEIT/FLAECHE: Mess-Zeit prod2 verdoppelt sich (216->432 Settings je Binary; Weg (B) 3,0d->6,0d, ~4,0d bei Umverteilung 2/3 auf prod1)

### [wkg9iu9j5.json] 2
GEGENSTAND: O-E ('target_isa.numa_node/.page anschliessen oder declared-inert ausweisen') beantwortet sich durch den Owner-KERN selbst: ANSCHLIESSEN statt ausweisen -- das POD-Feld hat 2 Schreibstellen und 0 Leser; O-E war zudem 'in der falschen Fassung gestellt' (Namensfalle: alloc_hw.numa_node ist eine ANDERE, voll verdrahtete Organ-Achse, 152 vs. 23 Treffer; einziges <numa_node>-Profil-XML fb_numa_page_study.profile.xml:50-52 haengt an alloc_hw; 0 von 91 Profilen deklarieren <target_isa><numa_node>).
ORT: ce xml_config_parser.cpp:130,132 (+Header-Zusage :234-235) | 20260806-ANKNUEPFPUNKTE-vorarbeit-je-aufgabe.md:1155-1158,1271
SOLL/FIX: "Wer hier ungeprueft 'anschliesst', trifft die falsche Achse" -- vor Anschluss die Achsen-Identitaet pruefen; Luecke sitzt an EINER Naht: erhobene Werte-Menge -> Perm-Bildung (Folge-Paket OD-10-RT-K, deklarierte Paket-Grenze).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: OD-10-RT-K; Posten 1

### [wkg9iu9j5.json] 3
GEGENSTAND: Sieben Owner-Fragen F-1..F-7 des Plans, je mit Empfehlung: F-1 ob 'startet' Prozess (Planer-Perm) oder Durchlauf (CEB-DynamicDim) heisst -- die Tier-Binary wird heute per dlopen IN-PROCESS gefahren und NIE gestartet (0 fork/exec/posix_spawn in 2718 Z., Gegenprobe AnatomyModuleLoader::load=3) -> Empfehlung Naht B; F-2 (technisch kritischste) ob der Kernel die Hybrid-PMU beim Oeffnen festnagelt oder dem Thread folgt (perf_event_open(pid=0,cpu=-1)) -> als S-0 VOR JEDEM BAU MESSEN; F-3 Widerspruch Owner-KERN (NUMA-Achse) gegen Ledger:1577 (Hardware+Scheduling, 'neben NUMA') -> KERN gewinnt, Abweichung in der Arbeit benennen; F-4 prod1 einelementig oder V-Cache-CCD-Achse; F-5 Deep-Research-Umfang UNGEBUCHT (RAW-Event/Zen 3/Zen 4/Golden Cove/Gracemont je 0 Ledger-Treffer); F-6 Namens-Drift prod2_raptor_lake vs. kProd2AlderLakeCore (im Ledger 0-mal gebucht); F-7 Gate 'P/E-Core (HW+#215)' ist BEIDBEINIG GEFALLEN (HW seit 27.07.-prod2-Vollzug i9-12900K 8P+8E; #215 durch X-3) -- es verbleibt allein G-270a mit genau zwei verriegelten Assertions (test_cpuid_probe.cpp:63, test_platform_concepts.cpp:38).
ORT: Plan 20260806-PLAN-hybrid-pmc-numa-core-permutation.md | ce linux_perf_pmc_source.hpp:110 | Ledger:265,1312,1577
SOLL/FIX: Owner-Entscheide F-1..F-7 einholen; F-2 als Mess-Voraussetzung S-0.
STATUS LT. QUELLE: offen (Owner-Fragen)
ABHAENGIGKEIT/FLAECHE: G-270a (User-Sichtung verriegelter Tests); Owner-Antworten 10.08. (PMC=Meta-Meta-Achse, AMD!=Intel) sind NACH dieser Erhebung -- abzugleichen

### [wkg9iu9j5.json] 4
GEGENSTAND: Die CEB kann heute NICHT zwei PMC-Quellen halten: make_pmc_source() ist parameterlos (kein Kanal fuer PMU-Domaene/Kern-Typ); im Messmodus existiert genau EINE IPmcSource-Instanz fuer den ganzen Lauf; LinuxPerfPmcSource oeffnet die fds im KONSTRUKTOR (an den aufrufenden Thread gebunden -- also VOR jedem denkbaren Pin); PermResult/LazyMeasuredRow/CSV tragen je genau EIN PmcCounters ohne Domaenen-Diskriminator.
ORT: ce builder/pmc_source_factory.hpp:29-37 | linux_perf_pmc_source.hpp:208-223,110 | cache_engine_builder_iterator.hpp:2037-2039,2586-2587,365 | perm_runner.hpp:133,191,248
SOLL/FIX: (1) make_pmc_source() parametrisieren, (2) Ctx-Traeger mehrerer Quellen ODER Quelle je Permutations-Zweig neu, (3) fds NACH dem Pin oeffnen, (4) NICHT noetig bei Owner-Weg 'zwei Laeufe derselben Binary = zwei Zeilen' (billiger + doktrin-konform). Praezedenz der richtigen Reihenfolge: apps/f15_compare/main.cpp:225 (Pin) -> :335 (Quelle).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 1, 3(F-2)

### [wkg9iu9j5.json] 5
GEGENSTAND: RuntimeVariableLoop::set_field kennt nur fuenf POD-Felder und ignoriert unbekannte Variablennamen STILL -- ein Kern-Segment im Label wuerde heute nur BESCHRIFTET, nicht DURCHGESETZT (Praezedenz: hw_prefetcher steht seit jeher im Label, wird aber nie angewandt).
ORT: ce builder/experiment_tree/runtime_variable_loop.hpp:52-64
SOLL/FIX: Aktuator-Kanal neben dem POD-Kanal bauen (Plan-Baustein 3); der Aktuator selbst (ScopedThreadPin/CorePinPolicy thread_pinning.hpp:52-64,96-104) ist fertig und getestet, nur unangeschlossen (einziger produktiver Konsument apps/f15_compare/main.cpp:225; 0 Treffer in profile_facade/, 0 in CI).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 1; stiller Ignore = Muster 'verdeckte Wirkungslosigkeit'

### [wkg9iu9j5.json] 6
GEGENSTAND: Andockstellen fuer die dritte Perm-Ebene sind praezise benannt: A1 dritte Schleifenebene experiment_plan_director.hpp:2101-2102 (der EINE Perm-Walk), A2 Kardinalitaet :2089 (perm_count = opt*simd -> *core), A3 drittes PlanPerm-Glied :162-173 + plan_legend.hpp:103 system_perm (Legende [d,e,f] heisst bereits DREI Positionen, traegt nur zwei); die Ablage ist bereits perm-indiziert (:1471 measure_out .../perm+idx) -- getrennte PMC-Ablage faellt als Nebenwirkung ab; ein drittes Perm-Glied erzeugt am Emissions-Ort :1466-1471 automatisch den zweiten gepinnten Start derselben Binary.
ORT: ce profile_facade/planner/experiment_plan_director.hpp:2089,2099-2107,161-163,1430,1466-1471 | plan_legend.hpp:102-105
SOLL/FIX: dritte Schleifenebene + drittes PlanPerm-/Legenden-Glied; strukturell billigste Naht.
STATUS LT. QUELLE: offen (Bauvorschlag)
ABHAENGIGKEIT/FLAECHE: Posten 1, 3(F-1: alternativ DynamicDim-Naht B -- Empfehlung!)

### [wkg9iu9j5.json] 7
GEGENSTAND: Alternative Naht B (Empfehlung F-1): zusaetzliche DynamicDim (z.B. numa.core_type=p|e) im Dyn-Loop -- Loop dafuer gebaut (runtime_variable_loop.hpp:101-106, Binary wird NICHT neu geladen), Label wandert automatisch in setting_id (:2426) und CSV-Spalte 'setting' (:422) = getrennte Ablage ohne Schema-Bruch; RT-Sub-Achsen duerfen per compile-time-Wache ohnehin NICHT in den Stempel -> Fingerprint unberuehrt.
ORT: ce cache_engine_builder_iterator.hpp:2426,422 | runtime_variable_loop.hpp:4-9,91-96,101-106 | abi/system_cell_values.hpp:164-167,193-196
SOLL/FIX: DynamicDim-Weg; es fehlen hart: Aktuator-Kanal (Posten 5) + PMC-Oeffnungs-Reihenfolge (Posten 4).
STATUS LT. QUELLE: offen (Bauvorschlag, Empfehlung)
ABHAENGIGKEIT/FLAECHE: Posten 4, 5

### [wkg9iu9j5.json] 8
GEGENSTAND: Es gibt KEINE CSV-Spalte fuer Kern/Kern-Typ/NUMA-Node/CPU (lazy_csv_header 107 Z.: 0 einschlaegige Spalten; Gegenprobe platform :474); der Ledger-Zielname ran_on_core_type existiert NICHT im Code; P/E-Vokabular dreifach vorhanden und ueberall auf Null festgenagelt: HeteroCoreDispatch::None (einzige Auspraegung; scheduling_strategy.hpp ist DEPRECATED mit 0 Konsumenten), CoreClass 0 Impl, hybrid_core_aware genau 1 Treffer = Deklaration (nie gesetzt); scheduling hat KEINEN XSD-Kanal (grep -c scheduling experiment_schema.xsd = 0).
ORT: ce cache_engine_builder_iterator.hpp:421-528 | concepts/scheduling_strategy.hpp:39,2-10 | platform/core_layout.hpp:14-19,40-53 | measurement/i_measurement_source.hpp:55
SOLL/FIX: ran_on_core_type-Spalte (Plan-Baustein 6) + pe_policy (Dossier H-4: beide Spalten).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 1; Dossier 20260716-e17-e18-deep-research-DOSSIER.md (H-2..H-5)

### [wkg9iu9j5.json] 9
GEGENSTAND: Ledger-STALE-Block: alle 'P/E blockiert bis ~September'-Eintraege (Ledger :865-872, :2065, :2596, :2642, :2943, :2999 -- 14900KS-RMA) sind seit dem 27.07.-prod2-Vollzug (i9-12900K Alder Lake, online id17) WIDERLEGT; das #215-Bein (Annahme: Hybrid-Trennung kostet 320-DLL-Neubau) faellt durch den Owner-KERN 'kein Neubau' ersatzlos weg -- 'P/E-Core (HW+#215)' ist vollstaendig entgatet; Rest-Gate ausschliesslich G-270a (User-Sichtung von 2 EXPECT_FALSE-Assertions).
ORT: super Ledger:265(G7),:865-872,:1312(G-270a),:1137,:1423 | Cluster docs/sessions/2026-07-27-INFRA-AN-DIPLOM-o4a-prod2-cpu-VOLLZUG.md | I112_RUNNER_FLEET...:82
SOLL/FIX: Ledger-Staende bereinigen/supersedieren; G-270a-Sichtung beim Owner anstossen.
STATUS LT. QUELLE: teilweise (HW-Gate weg, G-270a offen)
ABHAENGIGKEIT/FLAECHE: Posten 3(F-7)

### [wkg9iu9j5.json] 10
GEGENSTAND: Namens-Drift ungebucht: Registry nennt die Intel-Maschine prod2_raptor_lake (cpu_fabrication="GenuineIntel/6/151/2"), die Identitaets-Konstante heisst kProd2AlderLakeCore ('Family 6/Model 151/Stepping 2 ist Alder Lake-S, i9-12900K') -- dieselbe CPU, zwei Namen, betrifft ausgerechnet die einzige Hybrid-Maschine der Flotte; kein Ledger-Eintrag (raptor_lake=0 Treffer im SSOT).
ORT: ce measurement/system_axis_registry.xml:23,26 | measurement/machine_identity.hpp:180-181,192-193,265-266
SOLL/FIX: Buchen und entscheiden (bewusstes Lane-Label oder Korrektur) -- UNGEBUCHTER Befund, kein bestaetigter Fehler.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 3(F-6)

### [wkg9iu9j5.json] 11
GEGENSTAND: PMC-Vendor-/uarch-Tabelle existiert NICHT: PERF_TYPE_RAW 0 Treffer in libs/ (Gegenprobe PERF_TYPE_=5); L2+coherence bewusst 0 ('kein RAW-Rateversuch'); der einzige Auftrag #187 'PMC-Auto-Adaption' ist auf Zen-5-RAW (EINE uarch) geschrieben; I-PMC-2 bleibt offen ('der Anhang kann selbst im besten Fall nur L1D+dTLB zeigen -- gehoert VOR Phase 6 entschieden, nicht nach der Messung entdeckt', Ledger:5298-5300); die Deep-Research-Pflicht 'alle AMD/Intel-Architekturen' ist im gesamten Korpus UNBELEGT -- 'zu erfassen, nicht nachzuschlagen'; beste technische Vorlage: 20260601-26-pmc-counter-beschaffungs-spec.md (Plattform-Annahmen tot/superseded, Substanz gueltig: RAW noetig fuer L2+Kohaerenz, attr.config[63:32] PMU-Type nirgends implementiert).
ORT: ce builder/linux_perf_pmc_source.hpp:200-218 | Ledger:2917,:5298-5300 | ce docs/sessions/20260601-26-pmc-counter-beschaffungs-spec.md:64,67,120,122
SOLL/FIX: I-PMC-2-Entscheid vor Phase 6; Deep-Research-Auftrag neu erfassen; attr.config[63:32] vor Bau am Objekt verifizieren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 3(F-2/F-5); P-PMC-1 (DATEI 8 wlrzgpeet)

### [wkg9iu9j5.json] 12
GEGENSTAND: Offene Struktur-Fragen H-1..H-3 der ceb-mechanik: (H2) die Zell-Ordner-Grammatik compose_system_zell_pfad koppelt jedes Pfad-Segment compile-time an ein Suffix-Segment (Bau-Identitaet) -- ein RT-Segment haette kein Gegenstueck, die Wache system_version_suffix.hpp:166-173 braeche (bewusste Sperre oder Aufgabe? unentschieden); (H3) ob cfg.measure_parallelism>1 und Pinning koexistieren duerfen (mehrere gepinnte Worker auf demselben Kern = Mess-Verfaelschung; im Repo steht dazu nichts).
ORT: ce builder/build_orchestrator/system_version_suffix.hpp:147-173 | cache_engine_builder_iterator.hpp:2594-2596
SOLL/FIX: vor Bau entscheiden.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 1, 6, 7

### [wkg9iu9j5.json] 13
GEGENSTAND: Superseded-/Stale-Kommentare im Code: target_isa_sub_axes.hpp:21-22 ('Laufzeit-Aufloesung nicht Teil dieses Fensters' -- durch OD-10-RT ueberholt, Kommentar steht noch); '6 System-Achsen' (Q2/Option C 17.07. + B3 20.07. dynamisches Erweiterungs-Array) ist HISTORISCH -- heute GENAU DREI Haupt-Achsen (system_axis_order.hpp:42-46 {target_isa, operating_system, external_utils}, static_assert gegen scheduling als Haupt-Achse); extension_hardware_system_axis.hpp DEPRECATED-Insel.
ORT: ce measurement/target_isa_sub_axes.hpp:21-22 | abi/system_axis_order.hpp:15-21,42-46,105-106 | extension_hardware_system_axis.hpp:4,14
SOLL/FIX: Stale Kommentar nachziehen; '6 Achsen'-Memory nicht mehr als Ist verwenden.
STATUS LT. QUELLE: teilweise (Code-Ordnung gilt, Kommentare stale)
ABHAENGIGKEIT/FLAECHE: Memory feedback_q2_option_c_erweiterungshardware_sechste_systemachse.md ist als Ist ueberholt

### [wkg9iu9j5.json] 14
GEGENSTAND: Erhebungs-Warnungen: (a) grep -v "/build" frisst /builder/ -- zwei Erst-Suchen des Agenten liefen falsch-negativ (sched_setaffinity=0), selbst korrigiert (deckt Fallen-Register); (b) der ce-Submodulpfad in /home/comdare/wt-super-landung/Code/external/comdare-cache-engine war zum Erhebungszeitpunkt LEER (0 Dateien); (c) SSOT-Ledger-Fassungen differierten (6735 vs. 6758 Zeilen, cmp VERSCHIEDEN) zwischen Repo-Klon und Worktree.
ORT: Erhebungsprotokoll wkg9iu9j5 explore[0]/explore[1]
SOLL/FIX: bei Nachpruefungen Filter '/build/' beidseitig; Ledger-Fassung eindeutig waehlen.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Fallen-Register; heutiger Zustand des ce-Klons im super-Baum ist anders (Auftrags-ORTE nennen ihn als existent)

### [wkg9iu9j5.json] 15
GEGENSTAND: Randnotiz roter Job: Test 304 m3v2_pmc_smoke misst ein leeres Fenster -- 'Der Test prueft nicht, was er zu pruefen vorgibt' (auf AMD durch Syscall-Rauschen >0, auf Intel exakt 0); slurm_launcher-taskset/numactl-Pfad ist DEPRECATED (KF-12) und emittiert nur Text -- KEIN gangbarer Weg fuer den Owner-KERN.
ORT: ce tests/unit/thesis_tiere/m3v2_pmc_smoke.cpp | builder/experiment_tree/slurm_launcher.hpp | tests/unit/test_kf12_kf13_slurm_prepare.cpp:52-53
SOLL/FIX: m3v2_pmc_smoke wurde lt. DATEI 2 (wz67qt3pc) durch 2b5ecd29 geheilt ('misst ein echtes Fenster') -- Abgleich: dieser Befund ist wahrscheinlich behoben@2b5ecd29.
STATUS LT. QUELLE: behoben@2b5ecd29 (lt. Querquelle) | slurm-Hinweis: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

---

# DATEI 4: wif8xpy56.json (72080 B) -- Kostenklammern-Anklage (fund/soll/codexRev/synth, Erhebung 06.08., ce=wt-b2-neuanker), alle 4 Agenten state=done

Anklage-Dokument geschrieben nach: super docs/sessions/20260806-ANKLAGE-kostenklammern-plan-diff.md. 9 Klammern am Objekt belegt + 10 weitere aus Codex (teils unverifiziert); 4 der 9 ZERSTOEREN geplante Arbeit.

### [wif8xpy56.json] 1
GEGENSTAND: K-01/K-02/K-04 (gemeinsame Wurzel COMDARE_BESTANDSLOG): das gesamte Bestandslog-Fingerprint-Gate ist in JEDEM real existierenden Aufruf tot -- der Provider lazy_fingerprint liefert nur bei getenv("COMDARE_BESTANDSLOG")=="true" eine Funktion; der Wert wird NIRGENDS gesetzt (nur 2 Unit-Tests; .gitlab-ci.yml komplett durchsucht: 0); damit expected_fp leer -> dll_is_current baut IMMER neu; .fingerprint-Sidecar wird in der Praxis NIE geschrieben; plan_bau_digest faellt immer auf kPlanOhneAnker zurueck. SOLL (F7 01.08., Owner): Fingerprint ist das EINZIGE, IMMER AKTIVE Gate, ersetzt den Dreifach-Vergleich, 'VERDRAENGT ... den G-C1-Vorschlag Fingerprint als VIERTES Gate, opt-in', 'KEINE Grandfathering-Logik'.
ORT: ce profile_facade/profile_run_entry.hpp:415-451,632,1004-1013 | builder/build_orchestrator.hpp:611-619,331 | builder/bestandslog/planer_driven_build.hpp:297-312 | cache_engine_builder_iterator.hpp:1167-1171
SOLL/FIX: Arbeitsliste i-5 (Owner-Entscheid F7 vs. Betriebsrealitaet: Env-Gate umkehren (Default AN) ODER im Trigger-Rezept verbindlich setzen PLUS harte Planer-Wache, die den Voll-Lauf ohne Provider abbricht statt stumm zu degradieren; M-L, 0,5-1 Tag) + i-6 (cfg.bestand_fingerprint_fn in bestandslog_active aufnehmen, fail-closed; S; MUSS mit i-5 in derselben Welle landen; Kollisionsgefahr mit T2-A/L1 in derselben Datei-Region).
STATUS LT. QUELLE: offen (Owner-Entscheid noetig)
ABHAENGIGKEIT/FLAECHE: blockiert F9/LB-0..LB-6, T2-A/A2-Eichungsstrang (nie produktiv scharf gewesen), Owner-A1-Zaehler-Resume, 2^17-Vollmatrix, Lager-Basis-Tests, P3-TRIGGER Task #4, Task #9; 'Erst nach i-1..i-4 -- ein scharfes Skip-Gate ohne PMC-Fix misst nur schneller falsch'

### [wif8xpy56.json] 2
GEGENSTAND: A-01/KK-1: Der vom Planer erzeugte Voll-Mess-Batch konfiguriert cmake an VIER Emissionsstellen OHNE -DCOMDARE_ENABLE_PMC=ON (Root-Default OFF -> NullPmcSource), obwohl der Owner das Flag am 16.07. als 'PFLICHT fuer Vollstaendigkeit aller perf-Messwerte' setzte; der 'harte PMC-Preflight' (m3v2_pmc_smoke) wertet mit pmc_seam_ok = delta.available || counters_all_zero genau den Ausfall, gegen den er gebaut wurde, als ERFOLG (SMOKE_OK bei komplett abgeschalteter Quelle); der Job traegt zusaetzlich allow_failure: true.
ORT: ce experiment_plan_director.hpp:1342 (+841/877/1194), :1362-1364, :1333 | CMakeLists.txt:67 | m3v2_pmc_smoke.cpp:71
SOLL/FIX: i-1: '-DCOMDARE_ENABLE_PMC=ON in die cmake-Emission aufnehmen, I-PMC-1 auf dem dynamischen Weg nachziehen. Biss: Director-Test prueft die emittierte YAML auf das Flag' (S, 1-2h; BLOCKIERT DEN MESSBEGINN; nach Landung super-Submodul-Bump noetig, sonst wirkungslos). i-2: Preflight-Verdikt am Preflight-Ort auf pmc_available=1 verengen; den 13.07.-Inversionsfix NICHT ruecknehmen, sondern zweiter Modus --require-available; 'Biss: Preflight muss ohne Flag rot werden' (S-M; ZWINGEND ZUSAMMEN mit i-1 -- i-1 allein liesse die Wache blind, i-2 allein blockierte den Lauf). i-3: allow_failure entfernen bzw. auf Zell-Ebene zurueckfuehren (CSV 'failed' bleibt, der JOB faellt; Par.66-N2) (S, <1h; vorher pruefen ob Landewarteschlangen-Politik daran haengt).
STATUS LT. QUELLE: offen (SOFORT-Klasse, vor jedem Messbeginn)
ABHAENGIGKEIT/FLAECHE: i-1+i-2+i-3 als EINE Welle; allow_failure-VERBOTEN-Doktrin

### [wif8xpy56.json] 3
GEGENSTAND: K-05/A-06: contract:axis-version-lock ist in ce .gitlab-ci.yml DOPPELT definiert -- die unbedingte harte Fassung (:339-354, Commit 76b6ef014 19.07. 15:42) wird per YAML-Letzter-Key-gewinnt von der INERT-Fassung (:497-517, Commit 7492b2eae 19.07. 12:51, rules-gated auf nie gesetztes COMDARE_AXIS_LOCK_CHECK) VOLLSTAENDIG verdrungen; der Heuristik-Header-Tripwire (axis_spline.hpp/break_even.hpp/measurement_curve_loader.hpp -- die Speisung des Break-Even-Routers HY-B2) lief seit 19.07. in KEINER Pipeline; Defekt besteht seit dem Entstehungstag.
ORT: ce .gitlab-ci.yml:339-354 vs. :497-517
SOLL/FIX: i-4: 'Doppel-Definition aufloesen (INERT-Variante samt rules-Zeile entfernen). Biss: Doppel-Key-Wache in den Abdeckungs-Invarianten-Job' (S, 1h; gehoert in die CI-Invariante dcb2f08f, steht als Task #6; 'nach dem Fix laeuft der Tripwire erstmals -- mit rotem Ergebnis rechnen'). Zusaetzlich: ungeschuetzte Drift in den 3 Headern seit 19.07. nicht auszuschliessen -- pruefen.
STATUS LT. QUELLE: offen (projektintern erkannt Task #6, unbehoben)
ABHAENGIGKEIT/FLAECHE: SOLL Par.32-F4 19.07. 'codegen-Minor = CI-Tripwire hart-rot'; Par.51-B7 Voraussetzung N=2^17; Hybrid-Kette

### [wif8xpy56.json] 4
GEGENSTAND: K-03: plan_resume_faecher entscheidet Resume rein ueber f.count (Fach-Granularitaet); das bereits ERHOBENE f.offen (Miss-Zahl je Fach) fliesst in KEINE Entscheidung (nur Dokument-Rendering :246 + Parse-Konsistenz :305). SOLL (Owner 23.07. verbatim): 'jedes fehlende Binary EINZELN erkannt, NICHT als Gesamt-Batch'; Dossier-Gaps G-A2/W-4. Codex praezisiert: detect_missing_in_window liefert konkrete Indizes und der Produktiv-Filterpfad baut nur zu_bauen -- die Ueberanklage 'ganze Bestandserkennung batch-granular' waere falsch; unerfuellt bleibt persistentes atomgenaues Resume/ETA.
ORT: ce builder/bestandslog/batch_planner.hpp:160-166,217-232,246,305
SOLL/FIX: ii-1: 'PlanFach::offen an eine Entscheidung anschliessen (ETA-Eingang, mindestens Widerspruchs-Wache)' (M, 3-4h; nach dem Messfenster vertretbar, wenn i-5 gelandet ist).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: F5/F6-ETA-Architektur; Posten 1

### [wif8xpy56.json] 5
GEGENSTAND: K-06: COMDARE_CE_ENABLE_OBSERVER_PUSH Default AUS, und selbst im Opt-in-Build wird 'ueber die extern-C-Modulgrenze NIE ein Subscriber gesetzt' -- die im Datei-Kopf verewigte User-Direktive ('Observer bereitstellen, um extern verschiedene Achsen auszuwerten') ist im Produktivsystem strukturell nicht einloesbar; offene Architekturfrage (wer setzt den Subscriber ueber die .so-Grenze) durch 'Default AUS' verdeckt.
ORT: ce src/measurement/measurable_concept.hpp:5-13,51-58,65-83
SOLL/FIX: Modul-Grenzen-Frage loesen oder ungebaut an Owner melden (Regel); Einstufung [VERZOEGERT].
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [wif8xpy56.json] 6
GEGENSTAND: K-07: 234-V-b (SHAPED-Emission, Multi-Node-Shape-B-Tree-Familien) ist FERTIG GESCHRIEBEN und nie an den produktiven Emissionspfad angeschlossen (emit_adhoc_modules_shaped/build_pilot_source_map_shaped: einzige Aufrufer sind 2 Test-TUs); node-shape-Varianten (Kt4/Kt16/Kt64, btree_order-Registry, Zuordnung fuer BST/Hash/SkipList/SwissTable+ART/HOT/START/Wormhole/SuRF) werden nie gebaut/gemessen.
ORT: ce builder/codegen/adhoc_emitter_shaped.hpp:1-11 | builder/experiment_tree/pilot_source_map_shaped.hpp:1-11 | organ_for_search_algo_shaped.hpp:17
SOLL/FIX: An den Experiment-Baum anschliessen -- 'keine offene Zukunftsarbeit mehr, sondern fertiggestellte, aber liegen gelassene Arbeit' [ZERSTOERT GEPLANTE ARBEIT].
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: geplante Messungen mit node-shape-Achsen-Auspraegungen

### [wif8xpy56.json] 7
GEGENSTAND: K-08: COMDARE_VARIANT_GATE nie aktiv -- das .variant-Sidecar wird bei jedem Bau GESCHRIEBEN (build_orchestrator.hpp:250-255, unbedingt), sein VERGLEICH (dll_is_current, Cross-Maschinen-Drift-Gate 8-Docker/prod1-prod2) findet nie statt; Codex entlastend: KEIN weiterer zerstoerter F7-Skip, weil BVSET unabhaengig davon im Fingerprint liegt.
ORT: ce profile_run_entry.hpp:453-470 | build_orchestrator.hpp:250-255
SOLL/FIX: Vergleich scharf schalten oder als ungebaut melden [VERZOEGERT].
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Dual-Weg-Doktrin Par.61; 8er-Docker-Matrix

### [wif8xpy56.json] 8
GEGENSTAND: K-09: target_isa-Unterachsen (numa_node/page) sind geparst, aber profile_to_tree.hpp (der EINZIGE Uebersetzer Profil->Permutationen) liest das Feld target_isa NICHT -- ein Profil mit <target_isa><option value=aarch64/> hat KEINERLEI Wirkung, keine Fehlermeldung: 'Eine Profil-XML mit dieser Achse taeuscht Wirkung vor, die nicht eintritt -- gefaehrlicher als noch-nicht-gebaut, weil es keine sichtbare Luecke hinterlaesst' [ZERSTOERT GEPLANTE ARBEIT].
ORT: ce xml_config_parser.hpp:234-243 | profile_to_tree.hpp (0 Treffer target_isa)
SOLL/FIX: Konsument in profile_to_tree bauen ODER lauten Fehler bei Deklaration ohne Wirkung (erst laute Compile-/Parse-Fehler, dann verschieben).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: riscv64/Cross-ISA-Auflage; deckt sich mit DATEI 3 Posten 2 (O-E)

### [wif8xpy56.json] 9
GEGENSTAND: K-10: COMDARE_LEGACY_MESSREIHEN ist ein PHANTOM-Gate -- als 'ohnehin gated' zitiert, existiert aber nirgends als #ifdef/getenv/CMake-Option (nur 2 Kommentarzeilen); die Rechtfertigung 'Slot bleibt leer, ist aber sicher' stuetzt sich auf einen nicht existenten Schutzmechanismus.
ORT: ce xml_config_parser.hpp:14 | xml_config_parser.cpp:147
SOLL/FIX: Kommentar korrigieren [KOSMETISCH mit Warncharakter].
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Doktrin 'Nie raten; Doku+Ist'

### [wif8xpy56.json] 10
GEGENSTAND: BINDENDE REGEL aus der Synthese (fuer jeden kuenftigen Bau-Auftrag): "KEINE KOSTENKLAMMERN: Eine geplante Faehigkeit wird IMMER vollstaendig verdrahtet und in der Produktionskette scharf geschaltet -- 'heute liest das niemand', 'kein Aufrufer', 'inert', 'opt-in', 'byte-/golden-neutral', 'spart Rechenzeit' sind KEINE Gruende, sondern Vollstaendigkeitsbehauptungen ueber ein System, das du nicht ueberblickst; wer eine Faehigkeit dennoch nicht scharf schalten kann, baut KEINE Bedingung ein, sondern meldet sie ungebaut an den Owner. Und: jede Wache muss den AUSFALL erkennen, gegen den sie gebaut wurde -- ein Verdikt, das den Ausfallzustand als Erfolg wertet, ist keine Wache, sondern ein Testat." Zusatz-Auflage Reviews: "Wer eine Env-Variable, ein rules:-Gate oder ein CMake-Flag als Aktivierungsbedingung einbaut, muss im selben Commit die Stelle nennen, die es in der Produktion setzt -- und diese Stelle im Baum belegen."
ORT: synth Abschnitt 3
SOLL/FIX: Regel in Bau-Auftraege kopieren; Muster-Ursachen: (1) Bau-Agent sieht Baum nicht Plan ('0 Konsumenten ist bei Pflicht-Features unverdrahtet/unfertig, nicht tot', Owner 13.07., Ledger:555), (2) byte-/golden-neutral als universeller Freibrief (dreistellige Vorkommen in libs/), (3) Wachen gegen den sichtbaren Fall statt gegen den Ausfall gebaut.
STATUS LT. QUELLE: nur-hinweis (Prozessregel)
ABHAENGIGKEIT/FLAECHE: alle Bau-Wellen

### [wif8xpy56.json] 11
GEGENSTAND: V-Posten (Ledger-Aussagen NICHT am Code bestaetigbar): V-01 'Default-Modus owner-gedeckt F7' traegt kein Owner-Zitat und WIDERSPRICHT dem eigenen F7-Kanon (opt-in = verworfener G-C1-Vorschlag); V-02 'P11 prueft das Env' beschreibt eine Absicht, keinen Code (B9 der VOR-TRIGGER-CHECKLISTE ist offenes TODO); V-03 Ergebnis der Verifikations-Welle wf_02b63805 NIRGENDS dokumentiert; V-04 Task#4-Haken 'BLOCKER GEHEILT (847c93c9)' irrefuehrend (nur synthetischer Provider, nie produktiv scharf); V-05 Ledger-Zeilennummern-Querverweise systematisch unzuverlaessig (W-8 Korn-Verweis-Drift; jede Zeilenangabe vor Verwendung per Volltextsuche neu verifizieren).
ORT: super Ledger (Nachtraege 05.08. nachmittag-2, 06.08. nachmittag-5; Task-Board #4/#6)
SOLL/FIX: Ledger-Korrektur-Buchungen; V-06 (Task #6 axis-version-lock) VOLLSTAENDIG bestaetigt.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 1, 3

### [wif8xpy56.json] 12
GEGENSTAND: Codex-only, NICHT selbst nachverifiziert (vor Uebernahme eigenstaendig verifizieren): A-02 (zweiter Profilpfad ExperimentRunArgs providerlos; SOTA-Fingerprint Existenz- statt Wertbeweis), A-03 (N8-Sidecar-Registrierung Testattrappe; continue bei kaputten Sidecars + nachfolgendes Loeschen = potenzieller Datenverlust sobald list angeschlossen), A-04 (F9-Lagerbaum/Knotenlog Testinseln, Store bleibt flach), A-05 (Messwert-Genus-Felder vom Host nirgends belegt), A-07 (Storage-/Reservierungs-Aktivierung fail-open bei Fehlkonfiguration), A-08 (Transportfehler wie 'Objekt fehlt' behandelt -> kann Bestandslog ueberschreiben; ii-3: fail-closed VOR dem ersten Push sobald i-5 den Lager-Weg oeffnet), A-10 (RAM/NUMA/Page-Probes test-only), A-12 (bestandslog_active prueft Funktionshuellen statt Schluesselwerte), A-13/ii-2 (artifact_cache.hpp:910,949,968 mc_size_verified best-effort true bei Fetch-/Parse-Fehler), A-14 (Messjob allow_failure -- deckt sich mit i-3), A-11/ii-4 (bytes_in_use_peak traegt END-Wert; f15_compare:364-376 pruefen ob als Peak ausgewertet; vor Thesis-Anhang-Bau).
ORT: Codex-Review (Provenienz: rescue/b2-neuanker-nb-77095354, NICHT nachpruefbar)
SOLL/FIX: iii-4: 'am Objekt nachlesen und einordnen'.
STATUS LT. QUELLE: offen (unverifiziert)
ABHAENGIGKEIT/FLAECHE: Codex-Sandbox-Ausfall (bwrap RTM_NEWADDR) -- deckt Memory CODEX-LENS; 4/4 harte Stichproben trafen (Plausibilitaets-Bonus, keine Verifikation)

### [wif8xpy56.json] 13
GEGENSTAND: A-09/iii-1: active_telemetry_is_silent() liefert literal false und ignoriert das geparste XML -- dokumentierter Kompromiss (H-10/A9.3, golden-Byte-Neutralitaet), kein stiller Fehler; Fix ist AUSDRUECKLICH GOLDEN-BRECHEND.
ORT: ce profile_run_facade.cpp:240-241
SOLL/FIX: iii-1: 'an das geparste Profil binden. Ausdruecklich golden-brechend, Owner-Absprache. GOLDEN-UPDATE-Fenster; nach Abgabe vertretbar' (M).
STATUS LT. QUELLE: offen (Owner-Absprache)
ABHAENGIGKEIT/FLAECHE: GOLDEN-UPDATE-Fenster

### [wif8xpy56.json] 14
GEGENSTAND: Aufraeum-/Folgeposten: iii-2 'byte-neutral/golden-neutral' quer durch libs/ in (a) Regressionsschranke=bleibt und (b) Nicht-Anschluss-Grund=Kandidatenliste trennen (L; Aufraeumpass Task #5, 9 Kandidaten); iii-3 nach i-5 pruefen, ob kPlanOhneAnker noch erreichbar ist -- 'wenn nicht, als Wache behalten, nicht loeschen' (S).
ORT: ce libs/ (cache_engine_builder_iterator.hpp 23x, profile_run_facade.cpp 21x, build_orchestrator.hpp 18x) | planer_driven_build.hpp:297-312
SOLL/FIX: wie genannt; empfohlene Reihenfolge der Synthese: i-1+i-2+i-3 als EINE Welle (halber Tag, blockiert Messbeginn) -> i-4 (parallel moeglich) -> Owner-Entscheid i-5 -> i-5+i-6 gemeinsam NACH der T2-A/L1-Landung -> Rest nach dem Messfenster.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: T2-A/L1-Landung; Messfenster

---

# DATEI 5: w2l331gg7.json (53731 B) -- Deep Research Cache-Line-Groessen (hw/ist/syn, Erhebung 06.08., ce development=3bbcb8ed + wt-b14-ce=16a173f2), alle 3 Agenten state=done

Ergebnis-Dokument: super docs/architektur/20260806-DEEP-RESEARCH-cacheline-hardware-vs-achse.md (580 Z., ASCII-only, kein Commit).

### [w2l331gg7.json] 1
GEGENSTAND: Owner-Frage (a) beantwortet: prod1 hat auf ALLEN Ebenen 64 Byte (selbst erhoben: getconf/sysfs/lscpu -C/CPUID, vier unabhaengige Wege); die Achse permutiert {32,64,128,256} -- nur 64 entspricht der Hardware, die anderen drei sind SOFTWARE-Alignment; praktisch entschaerft: die Achse dringt heute gar nicht bis zur Tier-Binary durch (NTTP nicht emittiert; catalog_codegen_tool/main.cpp:183-190 lehnt cacheline in permute_axes HART ab); (c) Line-Groesse ist FEST je Maschine (kein Schreibregister; dynamisch nur HW-Prefetcher-Zustand/SW-Hints/Padding), nicht universell 64 (32/64/128/256 real belegt: P-III/x86-heute/AppleM1+POWER/IBM-z).
ORT: ce axes/cacheline/cacheline_config.hpp:35-46 | cacheline_line_bytes.hpp:16-20,37-38,53-61 | apps/catalog_codegen_tool/main.cpp:172-194
SOLL/FIX: Antworten dokumentiert; siehe Posten 4 (Empfehlung).
STATUS LT. QUELLE: nur-hinweis (Befund)
ABHAENGIGKEIT/FLAECHE: KF-6/Posten 62 (NTTP-Emission)

### [w2l331gg7.json] 2
GEGENSTAND: (b) Hardware-Erhebung ist GEBAUT (cpuid_probe.hpp:174-189, sysfs_cache_probe.hpp:62-84, Ketten-Aufloesung cpuid_platform_probe.hpp:45-49 CPUID->SIMDDetector->sysfs), aber der Wert ist eine SACKGASSE: measured_metrics["cache_line_bytes"] hat ausserhalb von 2 Tests NULL Produktions-Konsumenten -- gemessener Ist-Wert und permutierter Achsen-Wert haben KEINERLEI Beruehrungspunkt im Code.
ORT: ce platform_probe/{cpuid_probe,sysfs_cache_probe,cpuid_platform_probe}.hpp
SOLL/FIX: Verwendung bauen, nicht Erhebung; Sonde gehoert unter hardware_probe_factory.hpp (dritte Erhebung an derselben ISA-x-OS-Zelle, neben RAM-Kette und numa/page).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 4

### [w2l331gg7.json] 3
GEGENSTAND: Freigabe-Kette: fuer cacheline existiert KEINE Zeile; host_supported kommt 3x vor und NIE in Code (nur XML cacheline_study:126 fuer isa, SCHEMA.md, Design-Notiz) -- KEINE .hpp/.cpp implementiert oder parst host_supported, fuer keine Achse; fuer ISA ist die uebertragbare Muster-Kette dagegen gebaut (system_axis_host_supports_simd profile_run_entry.hpp:245-267; ehrliches Ueberspringen experiment_run_entry.hpp:293-297; Planer annotiert statt filtert experiment_plan_director.hpp:2064). Heute nicht scharf; wird scharf in der Sekunde, in der KF-6 die NTTP-Emission nachruestet.
ORT: ce (host_supported Nullbefund) | cacheline_study.profile.xml:126 | thesis_profiles/SCHEMA.md:34
SOLL/FIX: 1:1-Uebertragung des ISA-Musters bei KF-6; Praedikat DREIWERTIG (Exakt/Modell/Unbekannt), NICHT bool -- Ueberspringen waere falsch (anders als SIMD laeuft die Binary und misst einen echten Padding-Effekt).
STATUS LT. QUELLE: offen (latent)
ABHAENGIGKEIT/FLAECHE: KF-6/Posten 62; Sperr-Kopplung Posten 4

### [w2l331gg7.json] 4
GEGENSTAND: EMPFEHLUNG Option 2 in ZWEI getrennten Landungen: (1) SOFORT (1-2h, golden-neutral, kein Schema-Ereignis): nur Wahrheits-Teil -- D_building_block_matrix.tex CacheLineSize-Zeile ('Runtime-Parameter' unter 'Dynamische Sub-Achsen' -> Uebersetzungs-Parameter) plus Abgrenzungssatz im Achsen-Header ('keine Zusage, die der Code nicht haelt'); (2) IM B14-FENSTER (3-5h): dreiteiliger CLU-Fix + Sonde + Praedikat IM SELBEN GATE: (i) Nenner aus derselben Quelle wie Zaehler via freiem Snapshot-Slot axis_stats[5][5] (observable_tier.hpp:80, Slots 5-7 frei -- ABER Namensvergabe = Schema-Ereignis, contract:axis-version-lock + Byte-Wache nachziehen), (ii) fail-closed statt Rueckfall auf 64, (iii) Stempel cacheline_assumed_bytes/cacheline_host_bytes; (3) NACH ABGABE Option 3 (volle Kette + KF-6) MIT Ledger-Sperrvermerk 'KF-6 darf nicht ohne B-1..B-3 landen'. Option 3 vor Abgabe ABGELEHNT: vier Gates gleichzeitig fuer eine Achse, die im golden-Korpus gar nicht vorkommt (all_axes_golden/experiment_golden/experiment_golden_kern: 0 Treffer cacheline -- selbst geprueft).
ORT: syn (Empfehlung) | thesis anhang/de/D_building_block_matrix.tex
SOLL/FIX: wie genannt, verbatim uebernommen.
STATUS LT. QUELLE: offen (Empfehlung, Teil 1 sofort faellig)
ABHAENGIGKEIT/FLAECHE: B14-Fenster (DATEI 6 w44o34i7j); contract:axis-version-lock (DATEI 4 Posten 3!)

### [w2l331gg7.json] 5
GEGENSTAND: Der CLU-Konsument system_axis.hpp:325-336 multipliziert cache_lines HART mit Literal 64 -- bei line=128 waere die CLU-Prozentzahl um Faktor 2 (bzw. 4/8) verzerrt ('8/16/33/66% statt ~16%', ce-Codex im Ledger); strukturell KANN er nicht line-genau rechnen: der ABI-POD ComdareTierObserverSnapshot transportiert keine line_bytes-Spalte; B14-NB3-CE-CODEX-Verdikt 'LANDET NICHT': der reine Literal-Fix heilt nur den Kopplungsfehler und ersetzt ihn durch einen unsichtbaren BEDEUTUNGSfehler.
ORT: ce include/cache_engine/measurement/system_axis.hpp:325-336 | anatomy/observable_tier.hpp (axis_stats[17][8])
SOLL/FIX: dreiteiliger Fix aus Posten 4(2); Erzeuger der cache_lines: axis_04_node_type_layout_aware_store.hpp:92,570-604 (bereits an line_bytes_of<L>() angebunden -- wird bei KF-6 automatisch line-genau, der Konsument nicht).
STATUS LT. QUELLE: offen (aktiver Landungsblocker fuer B14)
ABHAENGIGKEIT/FLAECHE: B14; Ledger 06.08. mittag-21

### [w2l331gg7.json] 6
GEGENSTAND: Der Scan-Puffer-OOB (Ledger Posten 62 'WARNUNG SCHARF: abi_adapter.hpp:454-464 kLbufBytes = kRecords*64 ... wird bei line_size>64 zum OOB') ist im WT b14-ce-anteil BEHOBEN (Commits 6a40071f, 0680eff1, 1fe3f6a9, 0ae12811, 16a173f2: kLineBytes/kMaxStride aus line_bytes_of<MemLayout>(), static_assert-Wachen, RAII-Puffer-Guard), aber NICHT in ce/development gelandet -- 'B14 LANDET NICHT', weil die Heilung den Konsumenten system_axis.hpp NICHT mitgezogen hat und dort neue falsche Werte erzeugen wuerde.
ORT: /home/comdare/wt-b14-ce (b14-ce-anteil, HEAD 16a173f2, 5 Commits vor development) | ce development abi_adapter.hpp:458-464,557-563,689-694 (noch hartkodiert)
SOLL/FIX: Landung NUR zusammen mit CLU-Fix (Posten 5) -- Landung harmonisiert Vertraege+Schnittstellen.
STATUS LT. QUELLE: teilweise (WT behoben, ungelandet, Blocker benannt)
ABHAENGIGKEIT/FLAECHE: B14-Fenster; Merge-Flaeche abi_adapter.hpp

### [w2l331gg7.json] 7
GEGENSTAND: Weitere hartkodierte 64er (Aufraeumpass-Kandidatenregister Ledger:4224): axis_05_memory_layout_observable.hpp:112 (kLineBytes=64u im generischen Raw-Buffer-Scan-Pfad), measure.hpp:38 (used_bytes/64, 'Beispiel-Spezialisierung'), node_width_config.hpp:54 (Default-Literal 64 in der EIGENEN Achse); axis_05_memory_layout_cache_line_aligned.hpp:28 (return 64) ist dagegen BEWUSST der intrinsische Design-Deskriptor -- dokumentierte 'Duplikat-Bug'-Falle, Verwechslungsgefahr real.
ORT: wie genannt
SOLL/FIX: im Aufraeumpass an line_bytes_of binden bzw. Falle dokumentiert lassen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 4(3)/KF-6

### [w2l331gg7.json] 8
GEGENSTAND: Mess-Ehrlichkeit (Kern): line=128 auf 64-B-Hardware ist KEINE Phantom-Achse fuer alignment/sw_hint (echter, literaturgestuetzter Padding-/False-Sharing-Effekt; Folly nutzt auf x86-64 bewusst 128 B wegen Adjacent-Line-Prefetcher), WOHL ABER fuer line_size als ZAEHL-Einheit der CLU (Modellwert, kein Messwert); Deep-Research schlaegt ehrliche Benennung vor (alignment_stride/padding_granularity/interference_size_hypothesis) mit Doku-Zeile 'simuliert das Verhalten, das eine Hardware mit dieser Line-Groesse haette'; empirisch am Objekt: False-Sharing-Grenze exakt bei 64 B, KEIN messbarer 128-B-Adjacent-Effekt auf Zen 5; MSR 0x1A4 NICHT verifizierbar (kein Root -- 'nicht verifiziert, nur dokumentiert').
ORT: hw-Bericht (Mikro-Benchmark /tmp/falseshare2.c auf prod1) | Thesis-Interpretations-Auflage
SOLL/FIX: Ergebnisinterpretation der cacheline-Achse in der Thesis entsprechend offenlegen (32/256 ohne Massenmarkt-Praezedenz).
STATUS LT. QUELLE: offen (Doku-/Thesis-Auflage)
ABHAENGIGKEIT/FLAECHE: Posten 4(1)

### [w2l331gg7.json] 9
GEGENSTAND: Nebenbefund am Objekt: prod1 (9950X3D) hat ASYMMETRISCHEN L3 -- CCD0 (Kerne 0-7,16-23) 96 MiB (32+64 V-Cache), CCD1 (Kerne 8-15,24-31) 32 MiB; live per CPUID gepinnt gemessen (taskset -c 0 vs. -c 24); Line-Groesse auf beiden CCDs identisch 64 B; getconf liefert je nach Scheduling-Platzierung verschiedene GROESSEN-Werte (32 vs. 96 MiB).
ORT: prod1 live-Erhebung (CPUID.8000001DH sub=3)
SOLL/FIX: relevant fuer F-4 (DATEI 3 Posten 3: prod1 einelementig oder V-Cache-CCD-Achse) -- Messplatzierung auf prod1 ist NICHT homogen.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: DATEI 3 F-4; Mess-Reproduzierbarkeit prod1

### [w2l331gg7.json] 10
GEGENSTAND: Klarstellung BootCacheDmi/F13: betrifft NICHT die Cache-Line-Groesse, sondern RAM-Frequenz/DIMM via DMI-Boot-Cache (ram_probe_chain.hpp:167-260); Verwechslungsgefahr im Owner-Stichwort war real, Trennung im Code sauber; cache_topology.hpp (ICacheLevel/ICacheTopology/ICacheResidency, 'Termin 7') sind reine Interfaces ohne Implementierung und Konsument.
ORT: ce measurement/ram_probe_chain.hpp:167-260 | platform/cache_topology.hpp:1-67
SOLL/FIX: keiner (Abgrenzung); cache_topology bleibt unimplementierter Bestand.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

---

# DATEI 6: w44o34i7j.json (37979 B) -- B14: GOLDEN-XML-Aktualitaet + Sync-Gate-Umhaengung + KF-6 line_sizes (karte/bau/review), alle 3 Agenten state=done

Bau: 2 Commits 71617a1b (Scheibe-6-Wache) + 6558c4ae (A7-Pflege + KF-6) in /home/comdare/wt-b14-golden, Branch b14-golden-kf6, UNPUSHED, ce unberuehrt (Gitlink 7969b399). Review-VERDIKT: NACHBESSERN (klein) -- Substanz tragfaehig, alle Gates eigenlaeufig reproduziert gruen (fixture_sync 4/4, da_unit 115/115, xmllint 4/4, Biss-Beweise RC=1/RC=1/RC=0, TABU 8/8 leer, ASCII 0).

### [w44o34i7j.json] 1
GEGENSTAND: F1 (NACHBESSERN, faktischer Fehler in COMMITTETER Datei): experiment_golden_kern.xml:131-135 behauptet, der golden-320-Katalog habe '17 Faktoren' und 'persistence_target kommt in jenem Katalog gar nicht vor' -- Ist: source_catalog.hpp:144 golden_320_catalog = 18 Faktoren INKLUSIVE persistence_target (K=1, 'Q-10b: GoldenK der neuen Achse = 1'), Registry traegt golden_wired="true"; der Satz uebernimmt den STALEN Kommentar aus tools/axis_registry_gen/main.cpp:45-49 und erzeugt genau die Verwechslung, die er verhindern soll.
ORT: super Code/test_data_xml/experiment_golden_kern.xml:131-135 (Commit 6558c4ae) | ce tools/axis_registry_gen/main.cpp:45-49 (zweite stale Quelle)
SOLL/FIX: 'Kommentarsatz korrigieren (18 Faktoren, persistence_target K=1 golden_wired-erfasst, Produkt unveraendert 320); optional main.cpp-Kommentar als zweite stale Quelle in die ce-Auflagen aufnehmen.' Kleiner Fixup-Commit im selben Worktree, Gates nachlaufen lassen, dann LANDEBEREIT.
STATUS LT. QUELLE: offen (blockiert Landung des B14-Pakets)
ABHAENGIGKEIT/FLAECHE: Landung super bau-Zweig b14-golden-kf6

### [w44o34i7j.json] 2
GEGENSTAND: F2 (NACHBESSERN): ce-Zwillings-Auflage (D) ist unvollstaendig -- abi_adapter.hpp:606 traegt ein DRITTES verstecktes 64-Literal (alloc.deallocate(lbuf, kLbufBytes, 64) im zweiten Pfad), die Auflage listet nur :528; 'Wer die Auflage abarbeitet, laesst 606 stehen.' F3 (Vermerk): Rechenfehler in Commit-Message/Bericht ((16384-1)*256+4 = 4194052, nicht 4194308; steht in KEINER committeten Datei) -- beim Fixup-Commit korrekte Zahl mitfuehren. F4 (Notiz): '12 Tests' real 15 TEST(-Faelle; Auflage-(B)-Formulierung leicht unpraezise (Thesis-Pfad validate_profile.hpp:196-208 kennt den Sonderzweig auch).
ORT: ce anatomy/abi_adapter.hpp:606 | Auflagen-Doku des B14-Pakets
SOLL/FIX: eine Zeile in der Auflagen-Doku (F2); Zahlen korrigieren (F3/F4).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 1; KF-6-Auflagenabarbeitung

### [w44o34i7j.json] 3
GEGENSTAND: Im Bau NEU GEFUNDEN (nicht in der Kartierung): F-3-Regression im Mess-Tooling der golden_kern -- 3 separate Ein-Tool-Combos = 3 CEB-Lanen statt Vollmenge in EINER CEB (Par.64/Owner 22.07.); korrigiert, Bau-Matrix-Faktor 3->1; ausserdem: falsche Herkunfts-Behauptung 'datasets 1:1 aus all_axes_golden' korrigiert (2 vs 3 Akten), english_words behalten; 17->18-Achsen-Nachzug in golden_kern selbst (Delta A: persistence_target fehlte seit 774a5d5f vom 26.07., zwei Beruehrungen ohne Nachzug).
ORT: super Code/test_data_xml/experiment_golden_kern.xml (6558ae4/6558c4ae)
SOLL/FIX: behoben im Paket.
STATUS LT. QUELLE: behoben@6558c4ae (ungelandet)
ABHAENGIGKEIT/FLAECHE: Posten 1

### [w44o34i7j.json] 4
GEGENSTAND: KF-6-Schema-Luecke geschlossen: das Golden-XML-Format (comdare_experiment-Dialekt) konnte line_sizes GRUNDSAETZLICH nicht ausdruecken (AxesDefaultLookupType nur Attribute; SystemAxesType ohne cacheline-Kanal; parse_experiment_profile ohne cacheline-Zweig) -- neu: Wurzel-Element <organ_subaxes> (XSD OrganSubAxesType) mit cacheline/node_width/alloc_hw, Vokabular zeichengleich zum thesis-Dialekt; Kardinalitaet: line_size-Faktor 4 x 2^17 = 524288 Tier-Binaries (Gegenrechnung 60er-Kreuz 60x131072=7864320 NICHT gewaehlt); System-Matrix 2x2x1=4; Aequivalenzklasse {32,64}->64 bei kRecordSize=48 als erwartete Nicht-Differenzierung vermerkt.
ORT: super Code/test_data_xml/experiment_schema.xsd + experiment_golden_kern.xml (6558c4ae)
SOLL/FIX: gebaut; ce-Zwillings-Auflagen (A)-(F) offen (Posten 5).
STATUS LT. QUELLE: behoben@6558c4ae (ungelandet); Auflagen offen
ABHAENGIGKEIT/FLAECHE: XSD-Erweiterung additiv bewiesen (Last-bearing gegen pre-B14-XSD)

### [w44o34i7j.json] 5
GEGENSTAND: ce-Zwillings-Auflagen (Ein-Schreiber-Regel, im B14-Paket NICHT vollzogen): (A) xml_config_parser.cpp: <organ_subaxes> in parse_experiment_profile lesen, deckungsgleich zum permute_axes-Sonderzweig (Z.289-294); (B) validate_profile.hpp: cacheline/node_width/alloc_hw im EXPERIMENT-Pfad als Sonderzweig -- FALLE: nur resolve_axis_refs_against_trio kennt ihn, Pruefung (5) nicht; (C) Codegen: CacheLineConfig als NTTP je Tier-Binary emittieren (Bruecke cacheline_line_bytes.hpp steht); (D) abi_adapter.hpp kLbufBytes=kRecords*64 an Z.462-463 UND Z.562 plus versteckte 64-Literale Z.464, 563, 528 UND 606 (F2!) -- mit KF-6 wird der OOB scharf (Faktor-4-Overrun bei line_size=256); (E) axis_05_memory_layout_cache_line_aligned.hpp:60 kCacheLine=64 -> line_bytes_of<Self>(); (F) ce tests/unit/thesis_tiere/experiment_golden_kern.xml umbenennen (Auflage C5) + COMDARE_EXPERIMENT_GOLDEN_KERN nachziehen, danach Wache auf echtes Byte-Gate hochziehen; (G, WICHTIG fuer Bau-Wirksamkeit): all_axes_golden.profile.xml (ce, thesis-Dialekt) definiert den realen 2^17-Bauraum -- 'Ohne eine parallele <axis ref="cacheline">-Deklaration dort bleibt die 524288-Zahl eine Deklaration, kein Bau. Owner-/Wellen-Entscheid noetig, da das die golden-N verschiebt.'
ORT: ce (6 Dateien wie genannt)
SOLL/FIX: verbatim wie oben.
STATUS LT. QUELLE: offen (Auflagenkatalog)
ABHAENGIGKEIT/FLAECHE: DATEI 5 Posten 4-7 (identische Flaeche!); Owner-Entscheid (G); wt-b14-ce-Zweig (DATEI 5 Posten 6) bearbeitet (D) bereits teilweise

### [w44o34i7j.json] 6
GEGENSTAND: Offene Punkte des Baus: (1) KEIN End-to-End-Antriebsbeweis fuer _kern -- 02_messung_driver/CMakeLists.txt:132 treibt COMDARE_V32_EXPERIMENT_GOLDEN_XML weiter auf die ALT-golden (experiment_golden.xml); Umhaengung des Treibers = eigener Posten (Planer-Zone, fuer B14 TABU); (2) all_axes_golden.profile.xml traegt stale Aussage 'compiler-FAMILIE + target_isa bleiben ZUKUNFT (B2, kein Parser-Kanal)' -- seit A4 (20.07.) liest parse_system_axes target_isa real (ce-Doku-Auflage); (3) <measurement_categories> bewusst nicht ergaenzt (Abwesenheit=alle 16, verhaltensgleich; kosmetisch); (4) op_types unveraendert 'OP-1 OP-3', Alt-golden fuehrt zusaetzlich OP-4 -- kein Ist-Beleg welcher Satz golden-Soll ist, NICHT geraten -> OWNER-FRAGE; (5) die neue Wache prueft NAMEN, nicht Werte/Kardinalitaeten/Reihenfolge (im Dateikopf als Nicht-Ziel benannt).
ORT: super Code/02_messung_driver/CMakeLists.txt:132 | ce all_axes_golden.profile.xml:211,224-225
SOLL/FIX: wie je Punkt; (4) an Owner.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Planer-Welle (Treiber-Umhaengung); A7-KERN 'staendig gepflegte Trigger-Input-Basis'

### [w44o34i7j.json] 7
GEGENSTAND: Scheibe-6-Struktur (Karte): das Sync-Gate test_fixture_sync_experiment_golden bewacht NUR das Alt-Paar; fuer das _kern-Paar existierte KEIN Sync-Gate; die ce-_kern-Datei ist eine EIGENSTAENDIGE, hart verdrahtete Parser-Seam-Fixture mit absichtlich abweichenden Werten (prod1-Struktur, pruefling="self", backend="minio") -- Byte-Umbiegen haette 12-15 Tests sofort rot geschossen; umgesetzt wurde der zweite offiziell zugelassene Weg (AUDIT-VERDIKT C5: ctest-Wache 'Fixture Teilmenge von Master-Schema', zwei FATAL-Beine, Kommentar-Strip, leeres Vokabular=FATAL); Owner-Entscheid zur endgueltigen Form bleibt: Option (A) neue dritte Datei als echter Byte-Spiegel (im erlaubten Rahmen) vs. (B) Umhaengung der Seam-Fixture (sprengt Ein-Schreiber-Klausel).
ORT: super Code/tests/fixture_schema_subset_check.cmake + CMakeLists.txt (71617a1b) | ce tests/unit/thesis_tiere/test_experiment_kern_seam.cpp:30 (#error-Pfad-Pin)
SOLL/FIX: Owner-Entscheid (A) vs. (B) einholen (analog F27); Alt-Gate bewusst in Kraft lassen (Abschalten = Wach-Verlust).
STATUS LT. QUELLE: teilweise (Wache gebaut, Owner-Entscheid offen)
ABHAENGIGKEIT/FLAECHE: Auflage (F) Posten 5

### [w44o34i7j.json] 8
GEGENSTAND: Traegerkreis-Widerspruch DREIER datierter Quellen fuer KF-6 (Vor-Entscheid noetig, bevor 'Vollausbau' definierbar): Code-NTTP verdrahtet {node_type, allocator, page_type, memory_layout, search_algo} aber NICHT cache_traversal; cacheline_study.profile.xml per_organ nennt {node_type, allocator, page_type, cache_traversal} ohne memory_layout/search_algo; Ledger:3939 (04.08.) nennt cache_traversal JA, memory_layout explizit 'NICHT'. Drei Kardinalitaets-Lesarten: (1) 60^4 bis 60^5 = praktisch unbaubar; (2) 4^4/4^5; (3) SOTA-BINDENDER Design-Input (synthese.md:17-34, 05.08.): EIN gemeinsamer CacheLineConfig-NTTP pro Tier-Binary = schlicht x4 -- die drei Quellen sind NICHT in Deckung gebracht.
ORT: ce axes (6 Basen) | cacheline_study.profile.xml:74 | Ledger:3939 | docs/sessions/backups/20260805-deep-research-a4-a5/synthese.md:17-34
SOLL/FIX: Traegerkreis-Reconciliation vor NTTP-Emission (Weitergabe an KF-6/Teil-2-Lane; Bau-Skizze liegt in synthese.md A4.4/A4.5).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 5(C); B14-Paket hat mit x4 die Lesart (3) gewaehlt

### [w44o34i7j.json] 9
GEGENSTAND: golden_wired-Verwechslungsfalle (Kontroll-Fund): golden_wired="true/false" in cache_engine_axis_registry.xml ist an den ALTEN golden-320-Katalog gekoppelt (Produkt 4*4*5*4=320), NICHT an experiment_golden_kern.xml -- 'Wer golden_wired als "ist im aktuellen Golden-XML" liest, irrt sich.'
ORT: ce cache_engine_axis_registry.xml (18x) | tools/axis_registry_gen/main.cpp:45-51
SOLL/FIX: klaerende Notiz (im B14-Paket bereits als 'Notiz gegen die golden_wired-Verwechslungsfalle' begonnen).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Posten 1 (F1 ist genau diese Falle, zugeschnappt)

---

# DATEI 7: woweldept.json (32151 B) -- Umbenennung numa_process_probe -> numa_cpu_pin_process_probe (bau + 2 Verdikte), alle Agenten done

Bau: Branch b-numa-cpu-pin-process-probe (aus b-numa-process-probe/b4cebdc4), Commit b1753926619d7bf734ba3b6b7ca2974ea95ea7d3, Worktree /home/comdare/wt-numa-cpu-pin, NICHT GEPUSHT, Arbeitsbaum sauber. 5 Dateien git mv, 37 Bezeichner, probe_id-Praefix, gtest-Suite, ctest-Label; ctest 18/18 + 24/24; Registry-Generator byte-identisch; TABU leer. Verdikt 1: HAELT (Umbenennung vollstaendig; echte Restvorkommen 0; 352 Alt-Token -> 4 Owner-Verbatim-Zitate). Verdikt 2: HAELT, wirkungsneutral (Rueck-Umbenennung 10/10 hash-gleich; Symboltabelle 1854 Symbole, 1 Mangling-Laengen-Artefakt; kein Nebenbei-Fix).

### [woweldept.json] 1
GEGENSTAND: OFFENER OWNER-ENTSCHEID: die Achsen-Id heisst weiterhin core_class (nicht numa_cpu_pin_process); der Ledger schreibt aber verbatim vor (Ledger:4507): 'Ableitungen: NumaCpuPinProcessSubAxis, Achsen-Id numa_cpu_pin_process' -- der Bau-Bericht hatte diese Auftrags-Punkte faelschlich zu 'Erfindungen' erklaert (Verdikt-LUECKE: geprueft wurde 'existiert der String heute im Code' statt 'vorgeschriebener Zielzustand'); die Ledger-Gegenprobe ist zudem stale (12 sub_axis-IDs statt 11, davon core_class enthaelt 'core').
ORT: ce system_axis_registry.xml:40 (<sub_axis id="core_class" .../>) | super Ledger:4507,4510 | Plan 20260806-PLAN-hybrid-architektur-pmc-achsen-zuordnung.md:382 (Quelle des Namens core_class)
SOLL/FIX: Verdikt verbatim: 'Der Owner-Entscheid ... ist damit NICHT offen zwischen zwei gleichrangigen Optionen, sondern eine Abweichung von einer schriftlichen Festlegung, die als solche vorgelegt werden muss.' Sachlich vertretbar (Geschwister-Muster numa_page_probe: Probe-Name != Achsen-Id ist etablierte Praxis); Umbenennung der Achse waere Folge-Paket mit Byte-Ereignis an system_axis_registry.xml + abi/system_cell_values.hpp (K-Wert-Verbotskatalog).
STATUS LT. QUELLE: offen (Owner-Vorlage noetig)
ABHAENGIGKEIT/FLAECHE: Rangfolge OWNER > PLAN; Byte-Ereignis-Flaeche Registry+Verbotskatalog

### [woweldept.json] 2
GEGENSTAND: Landereife-Einschraenkung: der Branch haengt 10 Commits hinter origin/development (2b5ecd29 vs. Spitze c4c04315, darunter bba4d90f/c4c04315), einer davon fasst tests/unit/CMakeLists.txt an (DIESELBE Datei); Trocken-Merge read-only: git merge-tree --write-tree origin/development HEAD -> MERGE_EXIT=0, Tree bb39b415, konfliktfrei.
ORT: /home/comdare/wt-numa-cpu-pin | b1753926
SOLL/FIX: "'Landereif' stimmt, aber nur nach vorherigem Merge von development." (Nie rebase, immer merge.)
STATUS LT. QUELLE: teilweise (landereif nach Merge)
ABHAENGIGKEIT/FLAECHE: Landereihenfolge ce-Zweige; parallel bauen, sequentiell landen

### [woweldept.json] 3
GEGENSTAND: probe_id-Ereignis dokumentiert und ENTLASTET: der probe_id aendert sich (numa_process_probe.{linux,macos,windows}@v1.0.0c -> numa_cpu_pin_process_probe....@v1.0.0c), die Verfahrens-Version nicht; origin/development traegt den alten Namen in 0 Dateien, 0 Daten-/Golden-Dateien tragen den alten probe_id -- keine Provenienz-Kette bricht.
ORT: ce algo_semver.hpp (h) 'probe_id-Ereignis'
SOLL/FIX: keiner (entlastet, nachgeprueft).
STATUS LT. QUELLE: behoben@b1753926 (im Paket)
ABHAENGIGKEIT/FLAECHE: -

### [woweldept.json] 4
GEGENSTAND: Kleinbefunde: (a) Bau-Baum-Defekt: inkrementeller Bau ohne cmake-Neulauf unmoeglich (ninja-Fehler CXXDependInfo.json 'missing and no known rule'; nach cmake . + Neubau gruen) -- das gruene Berichts-Ergebnis war echt, stand aber auf nicht-inkrementell baubarem Baum; (b) Berichts-Zahl '26 Namenslisten-Zeilen' real 25 (Running-main mitgezaehlt; Testfaelle=24); (c) erster Wachen-Lauf nach der Ersetzung war ROT (24 Zeilen >120 Spalten, Name 8 Zeichen laenger) -- behoben, Wache final GRUEN (2829 Zusatzzeilen, 0 Nicht-ASCII, 0 >120); (d) clang-format: Dateien schon im URSPRUNGS-Commit nicht clang-format-22-rein (numa_process_probe.hpp:345-348,:634), punktgenaue --lines-Behandlung statt Voll-Lauf; kein projekt-eigenes clang-format-Gate in dieser CI.
ORT: /home/comdare/wt-numa-cpu-pin/build/gcc-release | Bericht/Verdikt 2
SOLL/FIX: (a) als Bau-Infrastruktur-Hinweis; (d) Format-Reinheit der Alt-Dateien als Bestandsschuld.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

### [woweldept.json] 5
GEGENSTAND: Owner-Verbatim-Zitate-Doktrin angewendet: die naive Ersetzung hatte zwei Owner-VERBATIM-Zitate mit umgeschrieben; beide im Wortlaut wiederhergestellt ('Ein Zitat wird nicht nachtraeglich korrigiert'), daneben der Folge-KERN mit der Umbenennung gesetzt -- die 4 verbliebenen Alt-Treffer sind genau diese Zitate.
ORT: ce numa_cpu_pin_process_probe.hpp:6,12 | target_isa_sub_axes.hpp:12,15
SOLL/FIX: keiner (korrekt geloest); Muster fuer kuenftige Umbenennungen.
STATUS LT. QUELLE: behoben@b1753926
ABHAENGIGKEIT/FLAECHE: -

---

# DATEI 8: wlrzgpeet.json (24582 B) -- P-PMC-1: Bau-Paket PMC-Messkette entscheidungsreif (a=Verifikation, b=Bauplan), beide Agenten done

Plan geschrieben: super docs/plaene/20260806-PLAN-p-pmc-1-messkette.md (651 Z., NICHT committet; ASCII ausser Par. in zwei Ledger-Referenzen). Erhebungs-Anker ce=e7aa1244.

### [wlrzgpeet.json] 1
GEGENSTAND: Bau-Schritte B0-B6 (ausfuehrbare Reihenfolge, je mit Biss): B0 Kollisionslage pruefen -- experiment_plan_director.hpp ist bekannte Kollisionsflaeche (Ledger:4115: A2-Fix-Plan startet 'erst nach der w2-codex-fixes-Landung'); B1 -DCOMDARE_ENABLE_PMC=ON an ALLE VIER Emissionsstellen (:841,877,1194,1342; :1194+:1342 teilen Code/build via GIT_CLEAN_FLAGS -- einseitiges Flag laesst den anderen Job zurueckkonfigurieren; Begruendungstext woertlich aus super .gitlab-ci.yml:673-676); B2 Test der die INVARIANTE pinnt, nicht die Zahl vier ('zu jeder cmake-B-build-Zeile, deren Folgezeile --target comdare-messung-driver baut, gehoert das Flag' + EXPECT_GT(geprueft,0u) gegen leer-gruene Wache; zweimal: thesis+experiment; hartverdrahtete 4 wuerde exakt den Fehler wiederholen); B3 Wachen fail-closed via constexpr kPmcExpected in BEIDE Smokes (linux_perf_pmc_smoke SMOKE_FAIL statt Exit 0 bei kPmcExpected && !available; m3v2: available || (!kPmcExpected && counters_all_zero)) -- schliesst #37-Preflight UND pmc:amd/pmc:intel in einem Schritt, 13.07.-Inversionsfix bleibt; B4 allow_failure:true (:1333) entfernen (haengt an O-PMC-1); B5 Doku-Drift (a) linux_perf_pmc_smoke.cpp:4 vs. CMakeLists:3553, (b) CMakeLists.txt:67 nennt nur Windows gated aber Linux global, (c) linux_perf_pmc_source.hpp:5 widerspricht :194-195, (d) s. Posten 3; B6 branch_misses verdrahten (optional, PERF_COUNT_HW_BRANCH_MISSES, kein RAW). Wellen: W-1=B1+B2+B5(a-c), W-2=B3 (B3 VOR B1 waere falsch herum), W-3=B4 nach Entscheid, W-4=B6+B5(d), W-5=super-Submodul-Bump 'ohne den die ganze Landung wirkungslos ist'.
ORT: ce experiment_plan_director.hpp:841,877,1194,1333,1342,1362-1364 | tests m3v2_pmc_smoke.cpp:71 | linux_perf_pmc_smoke.cpp:58-63 | tests/unit/CMakeLists.txt:3553 | CMakeLists.txt:67-77
SOLL/FIX: wie B0-B6 verbatim.
STATUS LT. QUELLE: offen (entscheidungsreifes Bau-Paket, Sperrposten vor Phase 6)
ABHAENGIGKEIT/FLAECHE: Kollisionsflaeche director (B0); deckt DATEI 4 Posten 2 (i-1/i-2/i-3) mit praeziserer Schnittfuehrung

### [wlrzgpeet.json] 2
GEGENSTAND: Owner-Entscheide O-PMC-1..3: O-PMC-1 allow_failure am Mess-Batch -- gegen die Zeile: #278 ('0 allow_failure im GESAMTEN Matrix-System, einzige Ausnahme is_original:relock'), CI-Direktive 17.07., Par.66-N2 'BEIDE hart'; der Code-Kommentar beruft sich auf die Sichtbarkeits-Doktrin, die laut V6.4 eine ZELL-Doktrin ist, keine JOB-Doktrin; 20 allow_failure-Ledger-Treffer, KEINER autorisiert diese Zeile; Empfehlung Weg A entfernen. O-PMC-2 Haertegrad 'Quelle nicht gebaut = Fehler?': heute ist die gruene PMC-Ampel eine Aussage ueber den Compile, nicht ueber den Hardware-Zugriff (funktioniert nur, weil Infra guenstig konfiguriert: prod2 root-Executor perf_event_paranoid=1, prod1 Live-Beweis 25.06.); Empfehlung fail-closed; Preis: Trigger kann blockieren -> Vorab-Beweis beide Lanes (<3 min). O-PMC-3 Anhangs-Umfang: (a) 3 harte Spalten (L1D, LL/L3, dTLB) + 1 best-effort (Energie) von 7 PMC-Feldern; L2+coherence ausdruecklich honest-0 mit I-PMC-2/3-Verweis; (b) branch_misses JETZT verdrahten (Empfehlung) sonst B5(d) PFLICHT; (c) RAPL auf der AMD-Lane UNBELEGT -- vor dem Trigger cat-Einzeiler im pmc-Job, danach Spalte real ODER honest-0.
ORT: ce .gitlab-ci.yml:113-157 | experiment_plan_director.hpp:1333 | Ledger:666-692,1140,3499-3515,4347-4419
SOLL/FIX: wie genannt; Empfehlungen A/A/ja+jetzt.
STATUS LT. QUELLE: offen (Owner-Entscheide)
ABHAENGIGKEIT/FLAECHE: allow_failure-VERBOTEN-Doktrin; DATEI 2 Posten 18 (O-PMC-1 dort ebenfalls offen)

### [wlrzgpeet.json] 3
GEGENSTAND: NEUER BEFUND (weder Ledger noch ANKLAGE): pmc_branch_misses ist eine ZUSAGE OHNE DECKUNG -- 18 Treffer repo-weit, KEINE PMC-Quelle weist das Feld je zu; die einzigen Zuweisungen stehen in TESTS; die CSV-Spalte steht seit 04.08. im Header mit der Begruendung cache_engine_builder_iterator.hpp:499 verbatim 'PmcCounters ERHEBT branch_misses real' -- Praemisse am Objekt FALSCH, der absichernde Test setzt den Wert selbst ('Gleiche Familie wie KK-1, eine Ebene tiefer'); zudem: die Ledger-Formel 'nur L1D+dTLB' ist ZU PESSIMISTISCH (L3 mit Flag real als Last-Level; 'Last-Level = L3' fuer Client-CPUs korrekt, kein Etikettenschwindel) UND an dieser Stelle zu optimistisch.
ORT: ce cache_engine_builder_iterator.hpp:499 | test_a8s3_csv_klasse_c.cpp:6 | linux_perf_pmc_source.hpp:191-296
SOLL/FIX: B6 (verdrahten) ODER B5(d) Ruecknahme der Falschaussage VOR dem Anhang ('Zusage ueber Daten'). Hinweis: b-pmc-l3-honest-WIP (DATEI 2 Posten 2) enthaelt die Ruecknahme bereits -- Abgleich noetig.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Thesis-Anhang; DATEI 2 Posten 2 (identischer Gegenstand, dort als WIP-Ruecknahme)

### [wlrzgpeet.json] 4
GEGENSTAND: Nebenwirkungen GEMESSEN: das Flag geht in KEINEN Stempel ein (Co-Occurrence COMDARE_ENABLE_PMC x stamp|fingerprint|binary_id = 0); realer Fix-Preis = einmaliger ~77-s-Neubau des Host-Treibers pro Lane (12/13 Objekte wegen add_compile_definitions GLOBAL vor add_subdirectory dirty; die 131072-Matrix NICHT betroffen -- Tier-.so via eigenem g++-Aufruf, COMDARE_ENABLE_PMC in build_orchestrator.hpp 0-mal); Flag konsistent an BEIDEN Stellen -> Neubau genau einmal, Mess-Batch-Reconfigure No-Op; UNBELEGT-Abschnitt: Neubau-Zahlen aus Voranalyse nicht nachgefahren, ccache-Miss nicht gemessen, Runner-Rechtelage/RAPL aus Ledger 08.07./25.06., Stempel-Neutralitaet ueber Dateiliste (nicht jeden Emitter gelesen); Golden-Neutralitaet SELBST belegt (0 golden-Fixtures mit pmc_available).
ORT: ce CMakeLists.txt:77 | builder/build_orchestrator/build_orchestrator.hpp
SOLL/FIX: keiner (Kosten-/Risiko-Basis fuer die Landung).
STATUS LT. QUELLE: nur-hinweis (mit ausgewiesenen Restzweifeln)
ABHAENGIGKEIT/FLAECHE: Posten 1 (W-5 Submodul-Bump)

---

# DATEI 9: w4am8bfxd.json (18421 B) -- NEUBAU nach WF11-Agententod (529): Strang C F1-Durchstich + Strang A S-1 Basisklasse (urteile/bergung/vor_landung/funde/offen)

Urteile: C = LANDEFAEHIG_MIT_FIXES, A = LANDEFAEHIG.

### [w4am8bfxd.json] 1
GEGENSTAND: Strang C geborgen: ce-Branch bau/strang-c-f1-katalog-emitter, Tip 5f4024af6251aa8a51f79715e0e947db5102bc3f (1 Commit auf a99c4a18=origin/development, exakt 6 Dateien). BERGUNGS-FALLE BEHOBEN: Branch+Objekte lagen NUR im worktree-privaten Store .git/worktrees/wt-super-landung/modules/... (keine alternates, eigene 56M); 'git worktree remove/prune von wt-super-landung haette die Arbeit vernichtet'; geborgen per lokalem Fetch in den Hauptstore (.git/modules/Code/external/comdare-cache-engine, nachgemessen) + Thin-Bundle /home/comdare/.claude/jobs/5a19728e/tmp/strangc/belege/ce-strang-c-5f4024af.bundle (verify ok).
ORT: ce bau/strang-c-f1-katalog-emitter@5f4024af | Bundle-Pfad wie genannt
SOLL/FIX: worktree-unabhaengig landbar; Merge (nie rebase) nach development, danach Pipeline gruen verifizieren.
STATUS LT. QUELLE: teilweise (landereif, ce-Merge + super-Commit offen)
ABHAENGIGKEIT/FLAECHE: Posten 2 (super-Haelfte); WORKTREE-Lebenszyklus-Doktrin

### [w4am8bfxd.json] 2
GEGENSTAND: Strang C super-Haelfte NICHT committet -- Branch-Pflicht super unerfuellt und AN DEN LEAD DELEGIERT (Agent war worktree-isoliert, git ausserhalb hart geblockt, LITERAL: 'This agent is isolated in the worktree .../wf_d7ad183d-6b8-1 ... Refusing to run it'): Patch belege/super-strang-c.patch (3 Dateien: ci/mess_ausbeute_wache.sh, ci/tests/mess_ausbeute_bissprobe.sh, MANUAL_RUN.md; dry-run 3/3 sauber; Handoff-Dateien BYTE-IDENTISCH zu Bestand+Patch) + Commit-Text belege/strangc_commitmsg.txt.
ORT: /home/comdare/.claude/jobs/5a19728e/tmp/strangc/belege/ | Ziel: super-Branch bau/strang-c-f1-wachen
SOLL/FIX: vor_landung C verbatim: '1) super-Commit setzen ...; danach Bissprobe+--selbstbiss fahren (Soll 30/30 und 4/4 -- am Handoff reproduziert; Bestand blieb 28/28). 2) ce-Merge (nie rebase) ... 3) Golden NICHT regenerieren: 320er-Bestand byte-unberuehrt; Preimage-Wanderung der Basis-320-/Sweep-/per-K-Zellen ist GEWOLLT (KON47-01/Option a), KEIN fingerprint_format-Bump. 5) Worktree wf_d7ad183d-6b8-1 erst nach gruen+Merge loeschen. 6) Mess-CSV feldgenau lesen ($4/$5/$6), nicht ;n/a;n/a;n/a;-Zeilengrep (by-design-Endspalten).'
STATUS LT. QUELLE: offen (Lead-Aufgabe)
ABHAENGIGKEIT/FLAECHE: Landung super; F1-Durchstich (F1 = morgen!)

### [w4am8bfxd.json] 3
GEGENSTAND: Strang-C-Kleinfunde: (a) Warnungs-Meldung des Baus unpraezise -- Release-Baulog traegt 1 ECHTE gcc-Warnung -Wstringop-overflow (stl_algobase.h:426 via axis_03a_search_algo_interpolation.hpp:256, instanziert aus test_v41_topic_traversal.cpp:132) -- BESTANDS-Code, kein Strang-C-Regress, auf die GCC->clang-Warnungs-Aufraeumliste; (b) Kosmetik ':463 unveraendert' real :468; (c) A5-Grep ';n/a;n/a;n/a;'==0 am Objekt UNSCHARF (1 Treffer = by-design-n/a-ENDspalten 182-184 bzw. PMC-Spalten, NICHT die Messfelder); (d) Abweichungen vom Schnitt dokumentiert: Wache heisst (g) statt (f); Selbstbiss-Nenner 2->3 + Mutant M3 nachgezogen (sonst risse --selbstbiss .gitlab-ci.yml:609).
ORT: strangc-release-build.log:2286 | ce axes/lookup/axis_03a_search_algo_interpolation.hpp:256
SOLL/FIX: (a) Aufraeumliste; Rest dokumentiert.
STATUS LT. QUELLE: nur-hinweis / (a) offen
ABHAENGIGKEIT/FLAECHE: Warnungs-Review-Zweitpass GCC->clang

### [w4am8bfxd.json] 4
GEGENSTAND: Strang A landefaehig: ce-Branch bau/strang-a-s1-stempel-basis, Tip 868ed3a1451b6276eddbd57c0710479dcc38b56a (10 Commits auf a99c4a18, 13 Dateien +1322/-20, kein super-Commit noetig -- 0 super-Dateien im Diff). ACHTUNG Store-Lage: der Branch lebt im Store UNTER dem gitdir des super-Worktrees wt-super-landung -- 'dessen Loeschung wuerde den Branch mitreissen (ce-Worktree-Loeschung ist dagegen unkritisch)'. Verifikation umfassend selbst gemessen: is_empty/sizeof==1/!is_polymorphic (gcc15.3+clang22); K5-Koeder ROT 'eingefrorenen Praefix verlassen (Byte-Ereignis!)' + restore gruen; K7 ROT 'organ_zeile hier VERBOTEN (KON7-07)'; Vollbauten J-1..J-4: Release+Debug gcc LITERAL '100% tests passed, 0 tests failed out of 485'; Golden-SHAs identisch, 0 Sidecars.
ORT: ce bau/strang-a-s1-stempel-basis@868ed3a1 | Store .git/worktrees/wt-super-landung/modules/Code/external/comdare-cache-engine
SOLL/FIX: seriell landen (Lead); wt-super-landung NICHT entfernen, bevor der Branch gelandet oder in einen dauerhaften Store gehoben ist (KON49-Submodul-Branch-Regel); nach Landung+Push Pipeline per Monitor pruefen.
STATUS LT. QUELLE: teilweise (landereif, Landung offen)
ABHAENGIGKEIT/FLAECHE: KON49; Worktree-Loeschungs-Doktrin

### [w4am8bfxd.json] 5
GEGENSTAND: Strang-A-Funde + bewusste Nachzuege: FUND 1 Kommentar-Drift stempel_basis.hpp:50-52 ('die decl.hpp inkludiert DIESEN Header' -- seit ef0d13d6 falsch, Anbindung zog nach entries.hpp:97; 1-Wort-Fixup :51 'decl.hpp'->'entries.hpp' optional bei Landung); FUND 3 kein clang-Vollbau (Schnitt verlangte gcc Debug+Release = erfuellt; beruehrte TUs einzeln clang -Wall -Wextra sauber; Deckung via CI + Warnungs-Review-Zweitpass); Nachzuege ausserhalb der 12er-datei_menge (alle von Haus-Wachen erzwungen): (1) algo_semver.hpp Klasse (l) (P14-Taxonomie-Riegel), (2) POD-Anbindung in entries.hpp statt decl.hpp (decl = bewusst leichter Loader-Header), (3) test_check_size_cli_deckel braucht explizit gebautes Planer-Binary (rc=127 ohne; Vollbau-Luecken-Klasse J-1..J-4, kein Quelltext-Defekt); ERLAUBT-Zelle der Matrix heute unbelegt (KON8-07-Form, im Header dokumentiert).
ORT: ce ceb_version_stamp.hpp:650 | stempel_basis.hpp:50-52 | entries.hpp:97
SOLL/FIX: Fixup optional; Folgewelle (KEINE Landungs-Bedingungen): T-9 Codex-Gegenlese, CEB-System-Fuellwert (KON8-03), Planer-SHA, Tier-/Hybrid-Erbin (W-B/W-D), SotaStampLines (W-A).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Folgewellen W-A..W-D

---

# DATEI 10: wx9unapoc.json (13458 B) -- E18-SNAP: sechs Codex-Befunde geheilt + Fable-Re-Review (bau/review), beide done

Bau: EIN Commit 1ae02cdf (auf bda34e79) in /home/comdare/wt-b-e18snap, 5 Dateien +911/-107, KEIN Push, Arbeitsbaum sauber. Geheilt: HOCH-1 Beleg-Verlust bei Retry, HOCH-2 Sekunden-Kollision (mkdir-ohne-p-Lock + Remote-Wache), HOCH-3 divergente Doku nach non-FF-Push (Phase 2 hinter den Push, Re-Ernte), MITTEL-1 errexit-Luecke (|| return 1 je Schritt + Vollstaendigkeits-Wache), MITTEL-2 Pfad-Doppel-Literal (AF_SNAPSHOT_ROOT Single-Source), MITTEL-3 Rollback-Fremddatei-Loeschung (zustand|sicherung|pfad, Original-Wiederherstellung). Review-VERDIKT: LANDEBEREIT (alle Gates + Gegenproben selbst gefahren; Inertheit doppelt bewiesen; proben.sh 46 OK/0 FEHL zweimal).

### [wx9unapoc.json] 1
GEGENSTAND: Der .gitlab-ci.yml-Patch ist NICHT angewandt (LEAD-ONLY respektiert; Blob 3e0f7203 identisch in eb3d285a/bda34e79/HEAD): 'ohne den Patch entsteht der Beleg nur im CI-Workspace' -- die Anwendung von docs/sessions/backups/20260806-e18-snap/gitlab-ci-delta.patch (+91/-9, einziger geaenderter Job-Schluessel anhang:forward.script; rules/needs/variables byte-identisch; Inert-Gate COMDARE_ANHANG_FORWARD=="true" && branch==development, _bot_ -> never) ist Lead-Aufgabe.
ORT: /home/comdare/wt-b-e18snap/docs/sessions/backups/20260806-e18-snap/gitlab-ci-delta.patch | super .gitlab-ci.yml (LEAD-ONLY)
SOLL/FIX: Patch durch den Lead anwenden (git apply -p1 --check RC=0, --numstat 91 9).
STATUS LT. QUELLE: offen (Lead-Aufgabe nach Landung)
ABHAENGIGKEIT/FLAECHE: Landung des Commits 1ae02cdf; anhang:forward-Kanal

### [wx9unapoc.json] 2
GEGENSTAND: Bewusst offener Punkt 5 (in ANWENDUNG.md quittiert): Rot bei Nachholung = fail-loud RC=1, wenn der GELANDETE 289-HEAD nicht baut -- Nachholung erntet ohne 289-Commit, ohne Push; Modus/Herkunft stehen im QUELLSTAND (modus=/thesis_commit_aus_diesem_lauf=).
ORT: /home/comdare/wt-b-e18snap/ci/anhang_forward_core.sh | ANWENDUNG.md Punkt 5
SOLL/FIX: dokumentiert-bewusst; keine Aenderung gefordert.
STATUS LT. QUELLE: nur-hinweis (deklarierte Grenze)
ABHAENGIGKEIT/FLAECHE: -

### [wx9unapoc.json] 3
GEGENSTAND: Review-NIEDRIG-1: REST-RACE verengt, nicht null -- die REMOTE-Wache sieht nur GELANDETE Belege zum Fetch-Zeitpunkt; zwei gleichzeitig IN-FLIGHT-Laeufe derselben Sekunde auf verschiedenen Runnern koennen beide <TS> waehlen; der Verlierer endet im add/add-Konflikt des Writebacks -> RC=1 LAUT, HOCH-1-Nachholung stellt den Beleg selbstheilend wieder her -- kein stiller Fehler, kein Dauer-Verlust.
ORT: ci/anhang_forward_core.sh (Kollisions-Logik)
SOLL/FIX: Empfehlung: 'als offenen Punkt 7 in ANWENDUNG.md quittieren.'
STATUS LT. QUELLE: offen (Doku-Quittung ausstehend)
ABHAENGIGKEIT/FLAECHE: -

### [wx9unapoc.json] 4
GEGENSTAND: Review-NIEDRIG-2: Proben-Harnisch-Schwaeche -- ~14 von 46 Zusicherungen in fixture/proben.sh haben die Form 'grep -q ... && ok' OHNE '|| nok' (regrediert ein grep, faellt still eine OK-Zeile weg und die Suite bliebe gruen); die Soll-Zahl 46 wird im Script nicht asserted; heute alle 46 literal beobachtet (2 Laeufe). Betrifft nur Backup-Material, nicht das Auslieferungs-Produkt. Zusatz: shellcheck nicht installiert -> nicht geprueft (ehrlich deklariert, Bau+Review deckungsgleich).
ORT: /home/comdare/wt-b-e18snap/docs/sessions/backups/20260806-e18-snap/fixture/proben.sh
SOLL/FIX: 'kuenftig || nok bzw. OK-Zaehl-Assert ergaenzen.'
STATUS LT. QUELLE: offen (keine Nachbesserungs-Pflicht)
ABHAENGIGKEIT/FLAECHE: -

---

# DATEI 11: w4ffuvkx9.json (9130 B) -- S-3-Auflagen: KON55-Kombibau alle VIER Zellen + Inventory-Floor + Aufraeumen (kombibau/floor_commit/golden_endkontrolle/aufraeumen/landefaehig/offene_punkte)

landefaehig: JA. Branch bau/s3-ordnungsrelation in /home/comdare/wt-ce-mess-ordnung, genau 2 Commits: 4a89aed5 (Bau) + 965cd6da (Floor). Kombibau 4 Zellen SEQUENTIELL (gcc-15 Debug/Release, clang 22.1.8 Debug/Release) je ueber offiziellen GNU-Weg J-1..J-4; ctest -N je 487 (485 Bestand + test_s3_ordnung_relation + test_s3_ordnung_freigabe); Bilanz je Zelle LITERAL '100% tests passed, 0 tests failed out of 485' (-LE pmc); Namensmengen aller 4 Zellen BYTE-GLEICH; golden-Endkontrolle durchgaengig 0; Aufraeumen vollzogen (6 Bauverzeichnisse mit Belegpruefung geloescht, 38G frei), Worktree NICHT geloescht (Landung folgt A2.1a).

### [w4ffuvkx9.json] 1
GEGENSTAND: PROZESS-BEFUND (im Floor-Commit 965cd6da dokumentiert): FUENF Pakete seit der Sammellandung 6c010cdc registrierten zusammen 7 Tests OHNE den vom Datei-Kopf geforderten Sprossen-Nachzug im selben Zug (test_anker_marke_statt_ledgerzeile, test_d37b_modus_riegel, test_pa1_tote_ausnahme, test_vor_push_gate, test_vs_taxonomie_klassen_grep, test_bvset_teilmenge, test_s1_stempel_basis_vertrag) -- derselbe Versaeumnis-Typ wie ca6d8af1; Sprossen jetzt GEMESSEN nachgezogen: avx512f 479->488, avx2 475->484, basis 473->482 (Abstaende -4/-2 unveraendert; +9 je Sprosse = +2 S-3 ungegatet + 7 Nachzug; Namensdiffs per comm beidseitig exakt belegt).
ORT: ce scripts/ci_test_inventory_floor.txt (Commit 965cd6da) | Registrierungs-Diffs seit 6c010cdc
SOLL/FIX: 'fuer Landung/Owner als Wiederholungsmuster benennen (Kandidat: Wache/Hook, der Registrierungs-Diffs ohne Floor-Anfassung meldet).'
STATUS LT. QUELLE: teilweise (Floor nachgezogen; Prozess-Wache offen)
ABHAENGIGKEIT/FLAECHE: Owner-Vorlage; CI-Wachen-Design

### [w4ffuvkx9.json] 2
GEGENSTAND: Rest-Deckungs-Luecken der Abnahme: (a) pmc-Klasse NICHT GEFAHREN (linux_perf_pmc_smoke + m3v2_pmc_smoke; offizieller make-check-Weg schliesst -LE pmc aus, Klasse braucht COMDARE_PMC_LANES/Vendor-Lanes, eigener CI-Job) -- Deckung kommt mit der Pipeline nach der Landung; (b) scripts/ci_test_coverage_guard.sh selbst lief lokal NICHT (nur Mess-Rezept + Datei-Parser nachvollzogen) -- die neuen Sprossen 488/484/482 sieht die Wache ERSTMALS in der Pipeline ueber 965cd6da: nach der Landung Pipeline-gruen verifizieren (Push->gruen-Doktrin).
ORT: ce scripts/ci_test_coverage_guard.sh | CI-Jobs pmc:amd/pmc:intel
SOLL/FIX: nach Landung Pipeline verifizieren; erstes Guard-Feuer einplanen.
STATUS LT. QUELLE: offen (Pipeline-Nachweis ausstehend)
ABHAENGIGKEIT/FLAECHE: Landung bau/s3-ordnungsrelation

### [w4ffuvkx9.json] 3
GEGENSTAND: Warnungs-Bestand (kein S-3-Regress): GCC Release genau EINE Diagnose -Wstringop-overflow= (stl_algobase.h:426 via vector::erase, TU test_v41_topic_traversal.cpp) -- baseline-identisch AM OBJEKT belegt (Vor-S3-Baseline-Log vor Loeschung geprueft); clang je Zelle 3x -Wcharacter-conversion aus gtest-printers.h:524 (googletest selbst in _deps, Fremdcode) -- 'verschwindet ggf. mit einem googletest-Update'; NEUE FLAECHE (6 Dateien) 0 Warnungen in allen vier Zellen.
ORT: ce test_v41_topic_traversal.cpp-TU | _deps googletest
SOLL/FIX: -Wstringop-overflow auf GCC->clang-Aufraeumliste (deckt sich mit DATEI 9 Posten 3); googletest-Update-Kandidat.
STATUS LT. QUELLE: offen (Bestandsschuld, kein Blocker)
ABHAENGIGKEIT/FLAECHE: Warnungs-Review-Doktrin; DATEI 9 Posten 3 (identische Warnung)

### [w4ffuvkx9.json] 4
GEGENSTAND: Landung ausstehend: KEIN Push, KEIN Merge, KEIN Ledger-Edit erfolgt (auftragsgemaess); die Landung des Zweigs (2 Commits) folgt der Wellen-Form A2.1a; /home/comdare/wt-ce-golden-s14a (Fixup 3) zu keinem Zeitpunkt beruehrt.
ORT: ce bau/s3-ordnungsrelation (4a89aed5 + 965cd6da) in /home/comdare/wt-ce-mess-ordnung
SOLL/FIX: Landung per A2.1a-Welle; Bauten liefen via setsid -w mit rc-Marke auf jedem Exit-Pfad (V-8-Abdeckung).
STATUS LT. QUELLE: offen (landefaehig JA, Landung offen)
ABHAENGIGKEIT/FLAECHE: Landereihenfolge; Worktree-Lebenszyklus

---

# DATEI 12: w2tf1a30b.json (5789 B) -- Einsammeln ungelesener Workflow-Ergebnisse der letzten 4 Kontexte: TOTALAUSFALL

### [w2tf1a30b.json] 1
GEGENSTAND: Der gesamte Workflow ist GESCHEITERT: alle 4 Lese-Agenten (lesen:endberichte-diese-session, lesen:endberichte-voriger-kontext, lesen:journale-diese-session, lesen:journale-voriger-kontext) state=error mit logs verbatim "failed: You've hit your monthly spend limit"; alle 4 Ergebnisse = null; 707874 Tokens / 195 Tool-Calls verbraucht ohne jedes Ergebnis (je Agent ~465-474 s Laufzeit, Abbruch mitten in Bash-Aufrufen). Der Auftrag -- 'Ueber die letzten vier Kontexte liefen ~86 Workflows mit ~450 Agenten. Die ENDBERICHTE sind gesichert und committet unter /home/comdare/wt-super-landung/docs/sessions/backups/20260807-workflow-endberichte/voriger-kontext/ (14 Berichte + _IN...)' einsammeln -- wurde NIE erfuellt.
ORT: w2tf1a30b (Workflow-JSON) | /home/comdare/wt-super-landung/docs/sessions/backups/20260807-workflow-endberichte/
SOLL/FIX: Die LESE-SCHULD ueber die Endberichte+Journale der letzten 4 Kontexte (Stand 07.08.) ist weiterhin OFFEN, sofern kein spaeterer Workflow sie uebernommen hat -- der Designer muss pruefen, ob ein Nachfolger existiert (Memory: 'Sessions ab 08.08. LESEN'); andernfalls ist dies eine eigene Luecke im Gesamtbild (moegliche unbekannte Funde in ~86 Workflow-Endberichten).
STATUS LT. QUELLE: offen (Totalausfall, 0/4 Lose geliefert)
ABHAENGIGKEIT/FLAECHE: Vollstaendigkeit des Regressions-Gesamtbilds; Wiederanlauf-Doktrin

---

# BILANZ LESER 12

12/12 Batch-Dateien VOLLSTAENDIG gelesen (alle .result-Inhalte komplett, inkl. beider grosser Explore-Dossiers und aller Referenz-/Luecken-Listen der Kartierung). 134 Posten extrahiert.

Posten je Datei: wpmdvux3p=42, wz67qt3pc=21, wkg9iu9j5=15, wif8xpy56=14, w2l331gg7=10, w44o34i7j=9, woweldept=5, wlrzgpeet=4, w4am8bfxd=5, wx9unapoc=4, w4ffuvkx9=4, w2tf1a30b=1 (Summe 134).

Quer-Hinweise fuer den Designer (Dedup-Kandidaten): PMC-Flag/Preflight/allow_failure erscheint in DATEI 2, 3, 4 und 8 (Bauplan in 8 ist der praeziseste Stand); branch_misses-Falschzusage in DATEI 2 (WIP-Ruecknahme), 4 und 8; abi_adapter-64-Literale/CLU in DATEI 5 und 6 (B14: zwei Worktrees wt-b14-ce UND wt-b14-golden mit komplementaeren Haelften, Landung nur harmonisiert); numa/core_class in DATEI 3 und 7; contract:axis-version-lock-Doppeldefinition in DATEI 4 (Fix i-4) beruehrt DATEI 5 Posten 4 (Schema-Ereignis-Auflage). ACHTUNG Zeitstaende: DATEI 2-8 wurden am 06.-07.08. erhoben -- vor den Landungen bis KON58 (13.08.); jeder Posten ist vor Verbau gegen den heutigen Stand zu pruefen (einige sind nachweislich inzwischen behoben, z.B. m3v2_pmc_smoke via 2b5ecd29, numa_cpu_pin_process_probe via b1753926).

Selbstcheck: Alle 12 Dateien vollstaendig gelesen; jede Zahl mit Nenner, wo die Quelle einen trug; praezise Anweisungen verbatim uebernommen (einzige ASCII-Transliteration: Paragraphenzeichen der Quellen -> 'Par.', 12 Stellen); ASCII-only geprueft (grep -cP '[^\x00-\x7F]' = 0); keine Platzhalter-Abschnitte.

