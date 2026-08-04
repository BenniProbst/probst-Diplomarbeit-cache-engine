# DOSSIER 04.08.2026 -- Achsen-Qualitaets-Parameter-Katalog (C6-Vorstufe, read-only Research-Synthese)

STATUS: SYNTHESE aus R1 (SA-Wire-Ist), R2 (SA-Parameter-Vollmenge + Min/Max-Doktrin), R3 (Container-
Gattungs-Seite), R4 (Thesis-/Literatur-Versprechen). Workflow wf_c78d741d-Umfeld; KEINE Code-Aenderung,
KEIN Commit, KEIN Build. NACHBESSERUNG 04.08. (Review-Runde 2): Befunde B1-B10 eingearbeitet, alle
Neu-Anker am Ist 44bcda99 verifiziert.

REVIEW-VERMERK (Runde 2, je Befund quittiert):
- B1 [BLOCKIEREND, CONFIRMED] Owner-KERN NACHTRAG 3 war unverarbeitet -> ERLEDIGT: neuer Abschnitt 1N
  (Mess-Objekt-Klarstellung; Spalte (i) 'ohne'-Auspraegung vorhanden/fehlend je Thema, strikt getrennt
  von leer/CarriedAxis; Spalte (ii) konzeptionelle Einsatzorte + Research-/Paper-Verwendung je Baustein);
  Rekursions-Invariante als C6-Randbedingung = neuer Punkt 2.11; Folge-Entscheide E13/E14.
- B2 [CONFIRMED] Katalog-Zeile "Substitution/Messbaum" existierte nur fuer T0/T1 -> ERLEDIGT: Zeile
  JE Thema nachgezogen (T2-T17 mit grep-Substitutions-Indikator je Themen-Ordner, erhoben 04.08.;
  Container-/Gattungs-Seite 1N.3 mit realem std::allocator-Substitutions-Befund); Feinaufloesung
  je Variante bleibt P10 (in Abschnitt 0 jetzt ehrlich so deklariert).
- B3 [CONFIRMED] T4-Slot-Arithmetik der SA-Verdikt-Stuetze war falsch (>=7 FB-Kandidaten auf 4 freie
  Slots) -> ERLEDIGT: BINDENDE SLOT-VERGABE je Thema in Abschnitt 3 (wire vs. AlgoDetail-Kanal vs.
  Host); T4: Typ-Verteilung BINDEND ueber AlgoDetail-Kanal statt Wire; T0: avg_density-milli explizit
  NACHRANGIG (T2-Praezedenz); Verdikt JA bleibt, jetzt arithmetisch gedeckt; P5 nachgezogen.
- B4 [CONFIRMED] T6-Vollstaendigkeit -> ERLEDIGT: Multicore-Skalierung in der Min/Max-Zeile + Mess-
  Modus-Vermerk (T8-Form); neue Zeilen Allokations-Lokalitaet (BEFUND:206) und NUMA-/Hugepage-
  Lokalitaet (numalloc-Variante + OD-10-RT-Probe verbunden).
- B5 [PLAUSIBLE] T7-Timeliness fehlte -> ERLEDIGT: eigene Zeile (late/early-Prefetch-Quote, FT);
  Accuracy/Coverage/Timeliness-Triade jetzt 3/3 benannt.
- B6 [PLAUSIBLE] T14-Insert-/Pflege-Seite fehlte -> ERLEDIGT: add_count + displacement_ops
  (Cuckoo-Eviction real: axis_filter_cuckoo.hpp:68/:84-88/:175) + bindende 3/3-Slot-Vergabe.
- B7 [CONFIRMED] bytes_in_use_peak-Fehl-Etikettierung (measurement_snapshot.hpp:106-107 speist
  Momentanwert axis_stats[6][1]) -> ERLEDIGT: in T6-Zeile geflaggt + P6/Klasse C als
  Fehl-Etikettierungs-Heilung aufgenommen.
- B8 [CONFIRMED] pmc_branch_misses geschrieben-aber-stumm -> ERLEDIGT: Klasse C erweitert + neuer
  Arbeitspunkt P11 (layout-neutrale WIDE-Spalte); Abschnitt-5-Zeile verweist auf den Heil-Schritt.
- B9 [3 Luecken] -> ERLEDIGT: (i) ExtentStatistics-Felder BENANNT (2.2); (ii) E1 explizit VOR C6
  gebunden (AllocationStatistics-doubles fahren IN der C6-Wire-Form, permutation_concept.hpp:61-62);
  (iii) per-Slot-Timing im Gattungs-Wire als expliziter Entscheid E13 + Punkt 2.12 (Einfrieren-ohne
  = deklarierte Entscheidung, keine Stille).
- B10 [klein] observable_tier.hpp:76 traegt selbst stale "aktuell 1272, INC-2d" (Ist 1344/Version 8)
  -> in Nachzug-Liste 2.7 aufgenommen.
- POSITIV-BEFUNDE (a)-(e) zur Kenntnis; (e) WT-Drift: Ist am 04.08. NACHGEPRUEFT -- C3-C5 ist
  GELANDET (CE dev == WT == 44bcda99), 2.10 und Pfad-Kuerzel entsprechend aktualisiert.

## 0. Auftrag, Doktrin-Anker, Legende

- OWNER-KERN 04.08. verbatim (LEDGER:3811): Qualitaets-Parameter, die "eine positive Performance fuer
  die Aufgabe einer Achse ueber ALLE ueber das Achsen Thema verfuegbaren Parameter, erkennen lassen".
  Auslegung LEDGER:3812: (1) 9-SA-Slot-Nachruestung bestaetigt (A8-S3), (2) Deep Research je Achsen-
  THEMA VOR Snapshot-Formgebung, (3) Ergebnis MUSS VOR C6 vorliegen (C6 friert XxxObserverAggregate<N>
  ein); SA-Seite: pruefen ob 8 axis_stats-Felder je Thema reichen -- Wire-Erweiterung waere V3-Schema-/
  Major-gekoppelt und gehoert ins OFFENE E-24-Fenster, KEINE stille Scope-Erweiterung.
- OWNER-KERN 04.08. NACHTRAG 2 (LEDGER:3813, Substitutions-Prinzip/Programm-Messbaeume): Erfolg einer
  Achse = ihr GLOBALER Effekt ueber ALLE Verwendungsstellen; Substitutions-Vollstaendigkeit ist selbst
  Pruefkriterium; Programm-Messbaeume = Messung entlang rekursiver Achse-unter-Achse-Aufrufpfade
  (Ist-Anker seg_ns je Slot). Dieser Massstab ist als Katalog-Zeile "Substitution/Messbaum" JE Thema
  angelegt (T0-T17 unter Abschnitt 1; Container-/Gattungs-Seite unter 1N.3); die Zeile traegt je Thema
  den seg_ns-Messbaum-Anker + einen grep-Substitutions-INDIKATOR (Dateien des Themen-Ordners mit
  std-Container-/malloc-Treffern, erhoben 04.08. am Stand 44bcda99; inkl. Kommentar-/Concept-
  False-Positives) -- die FEINAUFLOESUNG je Fundstelle bleibt der P10-Sweep (Abschnitt 4).
- OWNER-KERN 04.08. NACHTRAG 3 (LEDGER, "Kleine Korrektur ... Sonst passt es jetzt"; vier
  Praezisierungen): (a) MESS-OBJEKT = der eingestellte ALGORITHMUS, die Achse ist der Mess-KANAL
  (Qualitaet(Algorithmus | Achse, Situation) = Blatt-Einheit der Programm-Messbaeume); (b) die
  Auspraegung "OHNE Optimierung" ist ein VALIDER, MESSBARER Algorithmus jeder Achse, die sie erlaubt
  (Baseline der Vergleichs-Kurven) -- STRIKT ZU TRENNEN von "leer/getragen" (CarriedAxis); (c)
  Forschungs-Frage je Baustein: konzeptionelle EINSATZORTE + wie er im RESEARCH/Paper eingesetzt
  wurde; Container = eigene Gattung fuer die Komplett-Zerlegung, Adapter = ObservableOrgan-Huellen
  (C1/C3); (d) REKURSIONS-INVARIANTE: metaprogrammatisch rekursiv erlaubt, zur Laufzeit imperativ/
  stack-sicher. Verarbeitung: (a)+(b)+(c) -> Abschnitt 1N; (d) -> C6-Randbedingung 2.11.
- Doktrin-Anker: Min/Max -> Heuristik-Messkurven + Observer-Strategie (LEDGER:431 "Min/Max erforschen
  nie erfinden"; LEDGER:808 Dossier 18; LEDGER:2259 Heuristik-Hybrid; architektur/18:9 + /20:17-39;
  Memory feedback_axes_optimization_semantics_deep_research_observer_strategy +
  feedback_heuristik_messkurven_typsystem_chain_of_responsibility). Mess-Fehler-Doktrin "failed statt
  0/null" (axis_error.hpp:12/:121; Memory feedback_measurement_failure_visibility...). A-15: RT-Unter-
  Achsen/Observer-Werte NIE im Stempel, Zuordnung ueber Spalten/Dateinamen (LEDGER:3611-3612).
- C6-Freeze-Gegenstand: E-24-Bauplan 20260803-DOSSIER-e24-fenster-bauplan.md:246-250 (C6 = Wire-/Sub-
  Interface-Ereignis, XxxObserverAggregate<N> per-Achse statt flacher Hand-PODs; Wire-PODs append-only
  bzw. V2 NUR HIER); Genus-Slot-Listen 1.1-1.4 (Set 13 :78-80, Sequence 9 :95-96, Adapter 11 :105-107,
  View 5 :123-124; Pins genus_binding_traits.hpp:93/:95 + container_framework.hpp:94).
- PFAD-KUERZEL: CE = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/
  comdare-cache-engine/libs/cache_engine. STAND-UPDATE 04.08. (Runde 2, git-log-verifiziert): C3-C5
  ist GELANDET -- CE dev == WT (/home/comdare/wt-e24) == Merge 44bcda99 "E-24 a-Teil KOMPLETT".
  Wire-/Schema-Anker (observable_tier.hpp, measurement_snapshot.hpp, pmc_source.hpp) am gelandeten
  Stand REVERIFIZIERT (T4-Zeile :79, T2-Kommentar :76, doubles-Weglass :66-68); die C3-ANATOMIE-Zeilen
  aus Runde 1 stammen vom Zwischenstand 0c56b69b und sind gedriftet (Detail 2.10).
  TH = .../thesis/diplomarbeit. S = .../probst-diplomarbeit-cache-engine.
- LEGENDE Ist-Stand: IST = heute messbar (datei:zeile) | ABL = host-ableitbar aus Bestandsfeldern
  (kein Wire-Slot noetig) | FB = fehlend-billig (Zaehler/Slot-Benennung/Host-Auswertung) |
  FT = fehlend-teuer (PMC-Attribution, Instrumentierung, fehlendes Substrat, Treiber-Ausbau).
- WIRE-BESTAND SA: ComdareTierObserverSnapshot = axis_stats[18][8] + seg_ns[18] + Meta, sizeof==1344
  zementiert (CE/anatomy/observable_tier.hpp:50/:53/:69-105/:133-146/:160-162, Version 8 :166-167).
  Schema-Namen = CSV-Spalten stat_<achse>_<feld>; names[f]==nullptr => KEINE Spalte
  (CE/builder/experiment_tree/cache_engine_builder_iterator.hpp:402-412/:627); Nicht-Mess-DLL =
  literal 'n/a', nie 0 (:630-632). Schreiber fill_observer_v3 CE/anatomy/abi_adapter.hpp:1137-1448.

---

## 1. Katalog je Achsen-Thema (18 SA + 5 Container-Achsen-Themen + 4 Gattungs-Ebenen)

### T0 search_algo (Slots frei: 2/8)
Aufgabe: Such-Paradigma / Schluessel finden. Min/Max: MIN Lookup-Latenz (Baumhoehe x Cache-Lines/Knoten
+ Vergleiche), MIN Branch-Miss, MAX Durchsatz (BEFUND-09.07.:83/:107-115).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| lookup/hit/miss/insert/erase/peak_occupancy | IST axis_stats[0][0..5] (observable_tier.hpp:70; Quelle abi_adapter.hpp:1150-1161) | Kern der Achse; Kategorien LAT/THR/CM/BM/IPC |
| seg_ns[0] Achsen-Latenz | IST (observable_tier.hpp:134; Pfad-B acc abi_adapter.hpp:671-848) | Messbaum-Knoten (Owner NACHTRAG 2) |
| Hit-Quote hit/(hit+miss) | ABL | Heuristik-Kurven-Eingang |
| per-Op-Latenz p50/p99 je Op-Typ | IST-Vektoren workload_orchestrator.hpp:42-55; CSV-Emission FB (heute nur merged-p50 + THR, measurement_snapshot.hpp:83-92) | Trade-off-Dreieck p50/p99 (03_messsystem:1046-1074) |
| Schluessel-VERGLEICHE je Lookup | FB: Organ-Zaehler, freier Slot [0][6] | Latenz-Formel-Glied "Vergleiche" |
| Descent-TIEFE avg/max (besuchte Knoten) | FB: Zaehler, freier Slot [0][7] | Latenz-Formel-Glied "Baumhoehe" |
| avg_density_at_lookup | FB: double-Drop (axis_03a...concept.hpp:52; Wire laesst doubles weg observable_tier.hpp:66-68); milli-Encoding moeglich -- BINDEND NACHRANGIG hinter Vergleiche+Tiefe (kein freier Slot mehr; T2-Praezedenz "2. Kandidat nachrangig"; spaeter gewollt => Klasse B/Major) | Dichte-Kontext der Hit-Rate |
| Branch-Miss/IPC/CM je Lookup | FT: PMC nur per-Lauf (pmc_source.hpp:19-27), keine Achsen-Attribution; A/B-Permutations-Differenz | BEFUND:83; vierte Komponente ausstehend (03_messsystem:1050-1053) |
| Occupancy-KURVE ueber Fuellstand | FT: Lauf-Ende-POD, keine Zeitreihe (Mechanismus existiert observable_tier.hpp:176-180) | Min/Max->Kurven-Doktrin |
| Statik-Kontext supports_simd/supports_range_scan/is_dense/has_cache_line_alignment/max_fanout | IST CT-Properties (axis_03a:64-73) -- Kurven-Kontext, A-15-neutral | Idreos-Design-Space-Dimensionen |

Substitution/Messbaum: SA ruft Container-Organe (Owner-Beispiel LEDGER:3813); Vergleichs-/Tiefen-Zaehler
machen den rekursiven Pfad SA->node/layout zaehlbar. Slot-Bedarf NEU: genau 2 -> passt in 2 freie Slots
(avg_density-milli BINDEND nachrangig, s.o.). Substitutions-Indikator: 16/21 lookup-Header mit
std-Container-/malloc-Treffern (grep 04.08.) -- hoechster Wert aller Themen; die Algorithmus-Blaetter
selbst sind Substitutions-Kandidaten erster Ordnung (exakt das Owner-Beispiel); Feinaufloesung P10.

### T1 cache_traversal (Slots frei: 0/8 -- VOLL)
Aufgabe: Knoten aufloesen/verfolgen, Cache-Sicht getrennt vom Algorithmus. Min/Max: MIN Cache-Misses/
Memory-Transfers je Traversal, MAX CLU (BEFUND:84/:126-141 inkl. Attributions-Warnung T1/T5/T7).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| resolve/resolve_hit/resolve_miss/register/unregister/peak_tracked/batch_size/batch_visited | IST [1][0..7] VOLL (observable_tier.hpp:71-73; abi_adapter.hpp:1163-1178) | Kern; Kategorien CM/CLU/dTLB/LAT |
| Resolve-Hit-Quote | ABL | Kurven-Eingang |
| avg_collision_chain_length | FB nur host-seitig (double-Drop, axis_03b:27-28); Wire-Slot existiert NICHT | Hash-Ketten-Guete |
| reale Cache-Lines/Transfers je Traversal (CLU/CM/dTLB) | FT: PMC-Attribution; heute nur Permutations-A/B | DIE Kern-Groesse der Achse (BEFUND:126-141) |
| batch_size-WIRKUNGS-Kurve | FT: RC-Setter = #221-Phantom (BEFUND:30-46) | Heuristik-Kurve ueber RC-Knopf |

Substitution/Messbaum: seg_ns[1] IST. Jeder NEUE Wire-Zaehler = Schema-/Major-Ereignis (Deckel); am Ist
NICHT noetig -- die Luecken sind PMC-/Instrumentierungs-Klasse, keine Wire-Zaehler.
Substitutions-Indikator: 3/6 cache_traversal-Header mit std-Treffern (grep 04.08.); Feinaufloesung P10.

### T2 mapping (Slots frei: 1/8)
Aufgabe: logisch->physisch-Adressaufloesung. Min/Max: MIN Indirektions-Cache-Misses je resolve
(Hash-Redirect O(logN)->O(1); BEFUND:85/:143-157).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| register/resolve/resolve_hit/resolve_miss/reverse_lookup/peak_mapped/indirect_steps | IST [2][0..6] (observable_tier.hpp:74-76; abi_adapter.hpp:1180-1193) | indirect_steps = dokumentiertes T2-Mess-Objective (axis_03m:24-25) |
| peak_indirection_depth | FB: Zaehler in freien Slot [2][7]; layout-neutral nach T2-slot[6]-Praezedenz (observable_tier.hpp:76 "layout-neutral benannt; sizeof-neutral") | trennt DirectPlacement (konstant 1) von PoolRelative-Ketten |
| Indirektions-Tiefe avg = indirect_steps/resolve; Reverse-Lookup-Anteil | ABL | Kurven-Eingang |
| getrennte reverse-Lookup-Latenz | FT: seg-Timer misst Achse gesamt | -- |
| CM je resolve | FT: PMC | BEFUND:85 |
| Rehash-/Reorder-Zaehler (Permuter) | FB: Zaehler-Kandidat, wuerde 2. neuen Slot brauchen -> nachrangig | Masstree-Bindung tab:axes-overview T2 |

Stale-Detail: axis_03m:25-Kommentar "NICHT Teil des eingefrorenen 1272-POD" ist UEBERHOLT -- Feld IST
benannt (observable_tier.hpp:75-76) und wird geschrieben (abi_adapter.hpp:1189). Kommentar-Nachzug.
Substitution/Messbaum: seg_ns[2] IST (observable_tier.hpp:134); Substitutions-Indikator 2/5
mapping-Header mit std-Treffern (grep 04.08.); Feinaufloesung P10.

### T3 path_compression (Slots frei: 3/8)
Aufgabe: Single-Child-Ketten kollabieren / Pfad-Information verdichten. Min/Max: MAX Kompressionsrate
UND MIN Baumhoehe -> MIN MEM+CM; verteilungs-getrieben (Praefix-Sharing; BEFUND:86/:159-169).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| compress_calls/prefix_len_total/bytes_saved_total/cuts_performed/last_checksum | IST [3][0..4] (observable_tier.hpp:77-78; abi_adapter.hpp:1319-1330) | Kern |
| Kompressionsrate bytes_saved/prefix_len; Schnitt-Effizienz bytes_saved/cuts; Cut-Quote | ABL (Verhaeltnis = double -> Auswertungs-Seite, nicht Wire) | MAX-Rate-Semantik |
| Basis-Bytes (Raten-Nenner) | FB: Zaehler, freier Slot | echte Rate braucht Nenner |
| Hoehen-REDUKTION (mit/ohne Kompression) | FB: Zaehler, freier Slot | MIN-Baumhoehe-Ast |
| realer MEM-Fussabdruck-Anteil | FT: Struktur-Introspektion/RSS-Zuordnung | MIN MEM |
| Decode-Kosten getrennt vom Encode | FT | -- |

Substitution/Messbaum: seg_ns[3] IST (observable_tier.hpp:134); Substitutions-Indikator 1/8
path_compression-Header mit std-Treffern (grep 04.08.); Feinaufloesung P10.

### T4 node_type (Slots frei: 4/8 -- AERMSTES Thema)
Aufgabe: adaptive Knotenklasse/Knoten-Format. Min/Max: MIN Knoten-Speicher-Verschnitt (ART ~52 B/Key)
UND MAX Fanout/CLU (BEFUND:87/:171-183). Direkter H1-Anker (Page-Type-Kosten je Workload,
05_evaluation.tex:10-12).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| find_count/keys_stored/queries_run/last_checksum | IST [4][0..3] (observable_tier.hpp:79; abi_adapter.hpp:1195-1207) | Kern (schmal) |
| Belegungsgrad keys_stored/Kapazitaet (capacity_utilization) | FB WIRE (BINDEND): NUR 1 neuer Zaehler capacity_slots_total -> Slot [4][4] (keys_stored existiert als [4][1]; Belegungsgrad = ABL-Quotient) | DIE Format-Qualitaetsgroesse; avg_occupancy-double-Ersatz |
| KNOTENTYP-VERTEILUNG (#Node4/16/48/256) | FB, BINDEND NICHT-WIRE: 4 Zaehler passen NICHT in die freien Slots -> Erhebung ueber den EXISTIERENDEN AlgoDetail-Attributions-Kanal ART_NODE4..CSS_NODE (measurement_category.hpp:35-50, measurement_record.hpp:11-21) | Kern-Groesse adaptiver Knoten; H1 |
| Bytes je Key (Verschnitt) | ABL aus AlgoDetail-Typ-Verteilung x sizeof (Host-Seite) | ~52 B/Key-Vergleich |
| Knotenklassen-WECHSEL (grow/shrink) | FB WIRE (BINDEND): 1 Summen-Zaehler node_class_transitions -> Slot [4][5]; Richtungs-Split grow vs. shrink ueber AlgoDetail | Adaptions-Dynamik |
| Fanout-Auslastung avg | ABL aus keys_stored/capacity_slots_total | MAX Fanout |
| CLU je Knotenzugriff real | FT: PMC | BEFUND:87 |

BINDENDE SLOT-VERGABE T4 (loest die 7-Kandidaten-auf-4-Slots-Ueberbuchung auf): Wire NUR
[4][4]=capacity_slots_total + [4][5]=node_class_transitions (2 von 4 freien Slots, [4][6]/[4][7]
Reserve); Typ-Verteilung + Richtungs-Split BINDEND ueber den AlgoDetail-Kanal (kein Wire-Slot);
Verschnitt/Belegungsgrad/Fanout = Host-ABL.
Substitution/Messbaum: seg_ns[4] IST (observable_tier.hpp:134); Substitutions-Indikator 3/12
node-Header mit std-Treffern (grep 04.08.); Feinaufloesung P10.

### T5 memory_layout (Slots frei: 3/8 -- KEIN Handlungsdruck)
Aufgabe: Cache-Line-Ausnutzung des Layouts. Min/Max: MAX CLU / MIN CM je Knotenzugriff; LOUDS MIN MEM
(BEFUND:88/:185-200).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| scan_count/records_scanned/field_bytes_read/cache_lines_touched/last_checksum | IST [5][0..4] (observable_tier.hpp:80; abi_adapter.hpp:1209-1222; P-MD1-REAL layout-abhaengig axis_05...observable.hpp:32-34) | Kern |
| CLU-Proxy = field_bytes/(cache_lines*64) | ABL -- wird bereits host-seitig gerechnet (system_axis.hpp:326-337) | DIE Achsen-Kennzahl; Collector-Zuordnung CLU->Observer (Anhang D:1182-1196) |
| Bytes je Record; records_per_line | ABL | -- |
| Alignment-Verletzungs-/Cache-Line-Split-Zaehler | FB: Zaehler, freier Slot (optional) | R4-Kandidat |
| reale HW-CLU/CM/dTLB | FT: PMC | vierte Komponente |
| Layout-MEM-Fussabdruck | FB statisch | LOUDS-MIN-MEM |

Substitution/Messbaum: seg_ns[5] IST (observable_tier.hpp:134); Substitutions-Indikator 0/9
layout-Header mit std-Treffern (grep 04.08., sauber); Feinaufloesung P10.

### T6 allocator (Slots frei: 2/8 -- Vollmenge 9 > 8, Aufloesung s.u.)
Aufgabe: Speicher bereitstellen. Min/Max: MAX Alloc-Durchsatz/MULTICORE-SKALIERUNG UND MIN
Fragmentierung/Peak-RSS UND MIN Alloc-Tail-Latenz (BEFUND:89/:202-217, dort woertlich "MAX
Alloc-Durchsatz/Multicore-Skalierung" :203; 26 Vendor). Mess-MODUS-Vermerk (T8-Form): der
Skalierungs-Teil ist im 1-Thread-Mess-Kanon NICHT erhebbar -- Modus-Zuordnung deklarieren (E7).
Eval verspricht Fragmentierung + bytes_in_use_peak als Spalten (05_evaluation:178-182).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| bytes_alloc/bytes_in_use/alloc_cnt/dealloc_cnt/fail/budget_reject | IST [6][0..5] (observable_tier.hpp:81-82; abi_adapter.hpp:1224-1252) | Kern; Fail-/Reject-Semantik vorhanden |
| bytes_in_use_peak | FB -- im Code als fehlende Quelle DEKLARIERT: MEMORY_FOOTPRINT=SourceUnavailable weil Thesis-Kanon peak verlangt (system_axis.hpp:339-346, Fix-Pfad dort benannt: "golden-neutraler END-Append" der Host-Spalte). ZUSATZ-BEFUND FEHL-ETIKETTIERUNG (B7): das Host-POD-Feld wird HEUTE aus axis_stats[6][1]==bytes_in_use (MOMENTANWERT, Schema observable_tier.hpp:81-82) befuellt, unter dem Etikett "ECHT aus Observer" (measurement_snapshot.hpp:106-107) -- die Snapshot-CSV-Spalte bytes_in_use_peak traegt damit einen NICHT-Peak, exakt die Verzerrung vor der system_axis.hpp:339-346 selbst warnt; Heilung in P6/E2 | 05_evaluation:180; MEMORY_FOOTPRINT-Kategorie |
| external/internal_fragmentation | FB: double-Drop (axis_06:60-61); STILLE-0-Klasse: Host-Spalten frag_milli deklariert+serialisiert, aber NIE befuellt (measurement_snapshot.hpp:56-57/:160-161/:188-189) -- Spannung zur failed-statt-0-Doktrin; milli-Encoding in freie Slots [6][6]/[6][7] | MIN Fragmentierung |
| REUSE-Quote dealloc/alloc; in_use/allocated | ABL | -- |
| Alloc-LATENZ p50/p99 je malloc | FT: per-Call-Timing | MIN Tail-Latenz |
| pool_budget_bytes-Wirkungs-Kurve | FT: RC-Phantom #221 | Heuristik-Kurve |
| Peak-RSS Prozess-Ebene | FB host-seitig (/proc/self/status), heute nicht erhoben | MIN Peak-RSS |
| Reklamations-Zaehler (Epoch/RCU/HP-Retire) | FB: Zaehler-Kandidat (Sub-Achse AA-Reklamation) -- konkurriert um Slots, nachrangig | tab:axes-overview T6 |
| Allokations-LOKALITAET (CM/CLU der Alloc-Pfade) | FT: PMC-Attribution bzw. Permutations-A/B; BEFUND:206 fuehrt "CM/CLU sekundaer (Allokations-Lokalitaet)" explizit als messbar | Lokalitaets-Flanke der Achse |
| NUMA-/Hugepage-LOKALITAET der Allokationen | Substrat IST DOPPELT vorhanden, Verbindung FEHLT: Varianten-Pool traegt NUMAllocAllocator mit Node-Pin-Option (axis_06_allocator_numalloc.hpp:9-24, CRTP-Body + gate_alloc_hw_for), und die OD-10-RT-Probe erhebt NUMA-/Hugepage-Laufzeit-Ist prozessfrei (include/cache_engine/measurement/numa_page_probe.hpp; hardware_probe_factory.hpp:81 numa_node_root/hugepage_root; LEDGER NACHTRAG 03.08. spaetnachts). FB: per-Lauf-Umgebungs-Spalten aus der Probe (Host-Seite) + A/B numalloc vs. std_malloc; FT: per-Allokations-Node-Attribution | etablierter Allokator-Qualitaets-Parameter; Multi-Socket-Effekt HW-gated (~Sep, numalloc:23) |
| MULTICORE-SKALIERUNG alloc-ops/s ueber Threads | FT: Modus-gebunden (Mess-Kanon 1-Thread, E7); BEFUND:203 nennt sie im MAX-Ziel | Skalierungs-Flanke |
| Statik-Kontext ProgressGuarantee-Stufe | IST CT (axis_06:77-82) | Design-Space-Dimension |

DECKEL-AUFLOESUNG: 2 freie Slots + 3 on-wire-Kandidaten (peak, ext_frag, int_frag). Geht peak den im
Code benannten Host-END-Append-Weg, passen die 2 frag-milli exakt in [6][6]/[6][7] -> KEIN Major.
Slot-Vergabe = Entscheid (Abschnitt 6). Die B4-Ergaenzungen aendern den Deckel NICHT: Lokalitaet/
NUMA/Skalierung sind FT- bzw. Host-/Proben-Klasse, keine Wire-Zaehler.
Substitution/Messbaum: seg_ns[6] IST (observable_tier.hpp:134); Substitutions-Indikator 1/30
alloc-Header mit std-Treffern (grep 04.08.) -- die Vendor-Blaetter sind weitgehend sauber;
Feinaufloesung P10. KEHRSEITE (Owner-Beispiel): die KONSUM-Seite der Substitution liegt bei den
Containern/Algorithmen, die den Achsen-Allokator nutzen sollen -- realer Befund dazu unter 1N.3.

### T7 prefetch (Slots frei: 0/8 geschrieben -- davon 3 UNBENANNT = Schema-Loch)
Aufgabe: Latenz verstecken. Min/Max: MIN effektive Memory-Latenz (Miss-Verdeckung), MAX MLP/IPC;
Kosten Cache-Verschmutzung/Bandbreite (BEFUND:90/:219-233).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| trigger/suggestions/hot_path_hints/max_queue_depth/addrs_enqueued | IST [7][0..4] (observable_tier.hpp:83-85) | Kern |
| real_prefetches_issued/last_prefetch_distance/last_real_address | IST IM POD, CSV-UNSICHTBAR: fill_observer_v3 schreibt r[5..7] (abi_adapter.hpp:1267-1269, K9-REAL-Telemetrie seit #221-Schliessung LEDGER:591), Schema-names[5..7]==nullptr (observable_tier.hpp:83-85) -> Writer ueberspringt (iterator:627). FB: 3 Slot-BENENNUNGEN, layout-neutral (Praezedenz T2-slot[6]) | Messwert-Sichtbarkeits-Doktrin beruehrt: Wert faellt stumm aus der Auswertung |
| DISTANZ-Wirkungs-Kurve | IST: prefetch_distance = der EINZIGE real verdrahtete RC-Knopf (LEDGER:591 literal default=4/rc=2->2/rc=9->9); RC-Sweep auf derselben Binary | Heuristik-Kurven-Doktrin, einziger echter RC-Sweep |
| HIT-DELTA (CM mit/ohne Prefetch) | FB als Permutations-A/B gegen None-Baseline; FT als direkte HW-Zaehlung | Nutzen-Beleg |
| FEHL-PREFETCH-/useful-Quote (prefetched-but-never-accessed) | FT: Adress-Nutzungs-Tracking bzw. PMC-Korrelation | einziger direkter Nutzen-Beweis der Achse |
| BANDBREITEN-Kosten | FB als issues*64B-Naeherung (ABL nach Benennung); FT echte Bus-/EN-Messung | Kosten-Seite |
| Cache-VERSCHMUTZUNG (Evictions) | FT | Kosten-Seite |
| TIMELINESS (late/early-Prefetch-Quote) | FT: braucht per-Prefetch Ausgabe-/Nutzungs-Zeitkorrelation (Adress-Zeitstempel-Tracking) bzw. HW-Zaehler fuer late prefetches; die Distanz-Wirkungs-Kurve (oben) misst nur das AGGREGAT der Distanz-Wahl, nicht die Puenktlichkeit des einzelnen Prefetch | dritte Groesse der etablierten Prefetch-Guete-Triade Accuracy/Coverage/TIMELINESS -- mit useful-Quote (Accuracy) + Hit-Delta (Coverage) jetzt 3/3 benannt |

Nach der 3er-Benennung 8/8 voll; jede weitere Wire-Groesse = Major.
Substitution/Messbaum: seg_ns[7] IST (observable_tier.hpp:134); Substitutions-Indikator 2/11
prefetch_axis-Header mit std-Treffern (grep 04.08.); Feinaufloesung P10.

### T8 concurrency (Slots frei: 3/8 -- Modus-gebunden)
Aufgabe: paralleler Zugriff. Min/Max: MAX Multicore-Durchsatz/Skalierung UND MIN Contention/
Kohaerenz-Traffic (BEFUND:91/:235-248).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| acquire/release/contention/validation_fail/pattern_id | IST [8][0..4] (observable_tier.hpp:86-87; axis_08...observable.hpp:37-45); contention/validation_fail im 1-Thread-Mess-Kanon EHRLICH 0 (deklariert :41-42) | Kern; ehrliche 0 dokumentieren (CSV-Legende) |
| Paarungs-Invariante acquire==release; RETRY-Quote | ABL | Pruefgroesse |
| OLC-Retry-Zaehler / CAS-Fehlschlaege / Wartezyklen | FB: Zaehler in freie Slots -- aber erst im Parallel-Modus informativ | validation_fail deckt Fails, nicht Retries |
| SKALIERUNGS-Kurve ops/s ueber thread_count | FT: thread_count #221-Phantom + paralleler Mess-Treiber; kollidiert mit Mess-Kanon Debug=par/Mess=1-Thread | BEFUND:91 |
| FAIRNESS/Tail unter Contention | FT | -- |
| Kohaerenz-Invalidierungen | FT Attribution; per-Lauf-Spalte pmc_coherence_invalidations EXISTIERT (pmc_source.hpp:25; iterator:433) | vierte Komponente |

Verdikt: KEIN neues Wire-Feld jetzt; Mess-MODUS-Zuordnung im Bericht/CSV-Legende deklarieren.
Substitution/Messbaum: seg_ns[8] IST (observable_tier.hpp:134); Substitutions-Indikator 0/13
concurrency_axis-Header mit std-Treffern (grep 04.08., sauber); Feinaufloesung P10.

### T9 serialization (Slots frei: 4/8)
Aufgabe: Externalisierungs-Kosten. Min/Max: MAX Kompressionsrate / MIN serialisierte Groesse vs. MIN
Encode/Decode-Latenz (BEFUND:92/:250-259).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| serialize_count/records_serialized/bytes_serialized/last_checksum | IST [9][0..3] (observable_tier.hpp:88; abi_adapter.hpp:1281-1294) | Kern |
| Bytes je Record | ABL | -- |
| Encode-Latenz | IST seg_ns[9] | Messbaum |
| Raw-Bytes-Basis (Kompressionsraten-Nenner) | FB: Zaehler, freier Slot | MAX Rate braucht Nenner |
| deserialize-/Roundtrip-Zaehler + DECODE-Latenz getrennt | FT: Decode-Pfad wird im Scan heute nicht getrieben | MIN Decode-Latenz |

Substitution/Messbaum: seg_ns[9] IST (observable_tier.hpp:134); Substitutions-Indikator 1/9
serialization_axis-Header mit std-Treffern (grep 04.08.); Feinaufloesung P10.

### T10 value_handle (Slots frei: 4/8 -- H3-PFLICHT-Luecke)
Aufgabe: Wert-Zugriffs-Indirektion (Inline vs. External). Min/Max: MIN Wert-Indirektion vs. MAX
Knoten-Dichte/CLU; Optimum = Schwelle auf Wertgroesse (BEFUND:94/:277-290; Thesis-H3
05_evaluation:19-21).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| total_access_count/indirect_deref_count/version_tag_strips/peak_chain_depth | IST [10][0..3] (observable_tier.hpp:89-90; abi_adapter.hpp:1300-1313) | Kern |
| Indirektions-Quote indirect_deref/access | ABL | Kurven-Eingang |
| per-Varianten-Zaehler inline_hits/external_refs/chain_refs | FB: 3 Zaehler in 3 freie Slots -- OHNE sie ist H3 aus stat_* NICHT pruefbar | H3-PFLICHT (Verteilung x Page-Dichte) |
| avg_chain_depth (Summen-Zaehler, nicht nur Peak) | FB: 4. freier Slot | Tiefe vollstaendig |
| Wertgroessen-Verteilung des Workloads | FT: Workload-Dimension fehlt (Treiber faehrt uint64) | Schwellen-Kurve |
| inline_threshold_bytes-Wirkungs-Kurve | FT: RC-Phantom #221 | Heuristik-Kurve |
| CLU-Wirkung der Knotendichte | FB als Proxy ueber T5-Felder; FT real | H3-Flanke |

Substitution/Messbaum: seg_ns[10] IST (observable_tier.hpp:134); Substitutions-Indikator 1/10
value_handle_axis-Header mit std-Treffern (grep 04.08.); Feinaufloesung P10.

### T11 index_organization (Slots frei: 3/8)
Aufgabe: Zugriffsweg-Organisation. Min/Max: Scan MAX Storage-Order-Lokalitaet (clustered/IOT) vs.
Point+Sekundaer MIN Redundanz (BEFUND:96/:307-320). Cross-Genus: kommt im E-24-Fenster als Sub-Organ
von Set (E24-Bauplan:91).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| scan_count/records_scanned/predicate_evals/indirect_lookups/last_checksum | IST [11][0..4] (observable_tier.hpp:91-92; abi_adapter.hpp:1336-1348); honest-100%-Zaehlung real ausgefuehrter Ops (#24 Option A, axis_01...observable.hpp:20-27/:66-70) -- Ehrlichkeits-PRAEZEDENZ fuer alle neuen PODs | Kern, dokumentiert vollstaendig |
| Predicate-Kosten je Record; Hops je Lookup; records_per_scan | ABL | -- |
| bytes_/cache_lines_touched je Scan (CLU-Proxy der Storage-Order) | FB: Zaehler, freier Slot | der eigentliche MAX-Parameter (heute nur via Wall-Clock indirekt) |
| scan_early_exit_count | FB: Zaehler; erst mit praedikat-tragendem Treiber belastbar | clustered/IOT vs. Heap-Vollscan |
| Sekundaerindex-PFLEGEKOSTEN im Insert-Pfad | FB: Zaehler, freier Slot; Treiber faehrt Insert-Pflege heute NICHT (nur Scan-Pfad beobachtet) | MIN-Redundanz-Ast |
| MEM-Redundanz (Index-Duplikat-Bytes) | FB statisch | MIN Redundanz |
| Scan-Lokalitaet real (seq vs. random) | FT: PMC/Adress-Trace | BEFUND:96 |
| CT-Identitaet IO1 storage_order/IO2 index_count/IO3 data_embedding + is_clustered/... | IST (subaxes_io1_to_io3.hpp:9-16; :73-75) | Kurven-Kontext |

Substitution/Messbaum: seg_ns[11] IST (observable_tier.hpp:134); Substitutions-Indikator 0/8
index_organization-Header mit std-Treffern (grep 04.08., sauber); Feinaufloesung P10.

### T12 io_dispatch (Slots frei: 3/8 -- In-Memory-Simulation, ehrlich gedeckelt)
Aufgabe: IO-Buendelung. Min/Max: MAX IO-Durchsatz+Kontrolle UND MIN Page-Fault/TLB-Shootdown
(mmap-Antithese; BEFUND:97/:322-333). Am Ist deklarierte IN-MEMORY-Dispatch-SIMULATION
(abi_adapter.hpp:1350-1355).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| dispatch_rounds/bytes_dispatched/alignment_adjusts/total_dispatch_count/last_checksum | IST [12][0..4] (observable_tier.hpp:93-94) | Kern |
| Dispatch-Durchsatz bytes/seg_ns[12]; Alignment-Quote; Batch-Groesse bytes/rounds | ABL | -- |
| Page-Faults/TLB-Shootdowns | FT: braucht echten IO-Pfad + PMC; fuer In-Memory-Tier ehrlich N/A (fuellstand-gated) | mmap-Antithese |
| echte Device-Latenz/async-Tiefe; sync/async-Anteile | FT: IO-Pfad existiert nicht | -- |

CSV-Legende-Pflicht: "In-Memory-Simulation" deklarieren, sonst liest der Auswerter ehrliche Werte falsch.
Substitution/Messbaum: seg_ns[12] IST (observable_tier.hpp:134); Substitutions-Indikator 0/8
io_dispatch-Header mit std-Treffern (grep 04.08., sauber); Feinaufloesung P10.

### T13 migration_policy (Slots frei: 3/8 -- Substrat-gebunden)
Aufgabe: Tier-Umschichtung. Min/Max: MIN tier-gewichtete Zugriffslatenz = MIN Cold-Tier-Zugriffe je
Budget; adaptiv MIN Eviction-Regret; Nutzen skaliert mit Skew (BEFUND:98/:335-350).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| total_decisions/migrations_triggered/hot_votes/cold_votes/tier_moves | IST [13][0..4] (observable_tier.hpp:95-96); tier_moves HONEST 0 im decide-only-Scan (abi_adapter.hpp:1362-1367); realer Move-Pfad existiert: IMigratableTier::tier_migrate_step (observable_tier.hpp:204-222) | Kern; ehrliche 0 deklarieren |
| Vote-Verhaeltnis; decision_flip_rate (hot->cold-Wechsel) | ABL | Adaptions-Dynamik |
| HOT-SET-Treffer-Quote / Cold-Hit-Zaehler (Zugriffe kalte Ebene) | FB: Zaehler, freie Slots -- die eigentliche Regret-Groesse | MIN Cold-Zugriffe |
| Rueckmigrationen (Thrashing-Indikator) | FB: Zaehler | Regret-Flanke |
| Migrations-Overhead ns je Move | FB: tier_migrate_step + Timing kombinierbar | Kosten-Seite |
| Hit-Rate-Gewinn vs. None-Baseline | FB als Permutations-A/B | Regret-Proxy |
| echte tier-gewichtete Latenz; move_latency/moved_bytes | FT: braucht 2. Tier mit realer Latenz-Differenz (Hybrid-Tier = Stufe HINTER CEB, Owner-KERN 02.08.) | Voll-Semantik erst mit Substrat |
| Skew-Sensitivitaet (Zipf-Sweep) | FB ueber Workload-Profile (Doc 32 LP-Katalog) | Last-Abhaengigkeit |

Substitution/Messbaum: seg_ns[13] IST (observable_tier.hpp:134); Substitutions-Indikator 0/8
migration_policy-Header mit std-Treffern (grep 04.08., sauber); Feinaufloesung P10.

### T14 filter (Slots frei: 3/8)
Aufgabe: Negativ-Abweis. Min/Max: MIN False-Positive-Rate je Bit (MIN bits/Key bei Ziel-FPR) UND MIN
Probe-Zugriffe; Nutzen skaliert mit Negativ-Anteil (BEFUND:99/:352-365; neg%-Sweep LP06 = Pflicht-
Lastrahmen, Doc 32:17).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| probe_count/queries_positive/queries_negative/hash_probes_total/last_checksum | IST [14][0..4] (observable_tier.hpp:97; abi_adapter.hpp:1374-1385) | Kern |
| Probe-Multiplizitaet hash_probes/probe | ABL | -- |
| REALE FPR (Positiv-Antworten gegen Ground-Truth) | FB: der Scan KENNT die echten Keys -- known_absent-Abgleich-Zaehler in freien Slot; heute fehlt der Wahrheits-Abgleich | OHNE ihn keine FPR -- pos/neg liefern nur Verteilung, nicht Fehlerrate |
| bits/Key | FB statisch (Filtergroesse/Key-Zahl) | MIN bits/Key |
| downstream-CM-Ersparnis | FB als A/B gegen filterlose Permutation; FT direkt (zur filterlosen Baseline als Achsen-Variante s. 1N/E14) | Nutzen-Beleg |
| INSERT-/PFLEGE-Seite: add_count | FB: Zaehler, freier Slot -- heute misst der Katalog NUR die Probe-Seite; ohne add_count keine Pflege-Kosten-Quote | Insert-Kosten-Ast; BEFUND:99-Abhaengigkeit "Static<->Delete" |
| Cuckoo-DISPLACEMENT-Ops | FB: Zaehler, substrat-spezifisch (honest-0 fuer Bloom/Xor/SuRF); Substrat real: CuckooFilter::insert_key mit Eviction-Kette (axis_filter_cuckoo.hpp:68, Verdraengungs-Carry :84-88, eviction_slot_ :175) | Verdraengungs-Dynamik = DIE Cuckoo-Pflege-Kenngroesse |

BINDENDE SLOT-VERGABE T14 (3 freie Slots, 3 Kandidaten -- passt exakt): [14][5]=known_absent_fp
(Ground-Truth-FPR, P4), [14][6]=add_count, [14][7]=displacement_ops (honest-0 ausser Cuckoo);
bits/Key bleibt statisch/Host, downstream-Ersparnis bleibt A/B -- keine weiteren Wire-Kandidaten.
Substitution/Messbaum: seg_ns[14] IST (observable_tier.hpp:134); Substitutions-Indikator 0/8
filter_axis-Header mit std-Treffern (grep 04.08., sauber); Feinaufloesung P10.

### T15 queuing_q1 buffer_strategy (Slots frei: 3/8)
Aufgabe: Puffer-Betrieb (Write-Buffer). Min/Max: MAX Durchsatz/Batching UND MIN Puffer-MEM +
Drain-Latenz; concurrent MAX Producer/Consumer-Parallelitaet (BEFUND:100 alt-T17 /:367-381).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| put/get/overflow/underflow/peak_size | IST [15][0..4] (observable_tier.hpp:98; abi_adapter.hpp:1388-1397) | Kern; Grenzlagen gedeckt |
| Overflow-/Underflow-Quote | ABL | -- |
| avg_occupancy | FB: double-Drop (q1-concepts:53-60); uint64-Ersatz occupancy-Summe + Sample-Zaehler ODER milli-Encoding, freie Slots | Betriebs-Guete |
| Batching-Effizienz (Ops je Drain-Runde) | FB: Zaehler | MAX Batching |
| Drain-Latenz | FT: eigenes Timing des Drain-Pfads | MIN Drain |
| Kapazitaets-Wirkungs-Kurve | IST via CT-Permutations-Aspekt iterable_aspect 8..65536 (12_queuing...:83); RC-Knopf fehlt (FT) | Heuristik-Kurve CT-seitig erhebbar |
| Producer/Consumer-Parallelitaet | FT: Multi-Thread-Treiber (Mess-Kanon) | concurrent-Ast |

Substitution/Messbaum: seg_ns[15] IST (observable_tier.hpp:134); Substitutions-Indikator 12/18
axis_q1_queuing-Header mit std-Treffern (grep 04.08.) -- zweithoechster Wert, Puffer-Substrate
tragen std-Container; Feinaufloesung P10.

### T16 queuing_q2 flush_policy (Slots frei: 3/8)
Aufgabe: Flush-Politik. Min/Max: Pareto MIN Write-Amplification/MAX Batching (lazy) XOR MIN Staleness/
Tail-Latenz (eager) (BEFUND:101 alt-T18 /:383-401).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| decisions/full_flush/partial_flush/no_flush/flush_complete | IST [16][0..4] (observable_tier.hpp:99-100; abi_adapter.hpp:1399-1408) | Kern |
| Flush-Quote (full+partial)/decisions | ABL | -- |
| avg_fill_at_flush | FB: double-Drop (q2-concepts:25-32) -- DIE Kenngroesse der Policy-Guete (Eager~0, Watermark~Schwelle, Lazy~voll); milli-Encoding, freier Slot | Pareto-Lage direkt ablesbar |
| WRITE-AMPLIFICATION (geflushte Bytes / logische Bytes) | FB: 2 Byte-Zaehler in freie Slots | MIN Write-Amp-Traeger |
| STALENESS (Alter aeltester ungeflushter Eintrag) | FT: Zeitstempel-Tracking je Eintrag | eager-Ast |
| Threshold-/Window-Wirkungs-Kurve | IST via CT-Aspekte threshold_pct 50..95 / window_ms (12_queuing...:146/:153); RC fehlt | Heuristik-Kurve CT-seitig |
| Statik-Kontext is_time_based/is_threshold_based/is_event_driven/is_adaptive | IST Concept-Kommentar (q2:37-41) | Design-Space |

Substitution/Messbaum: seg_ns[16] IST (observable_tier.hpp:134); Substitutions-Indikator 0/8
axis_q2_queuing-Header mit std-Treffern (grep 04.08., sauber); Feinaufloesung P10.

### T17 persistence_target (Slots frei: 3/8 -- honest-0-Klasse, Semantik Owner-ratifizierbar)
Aufgabe: Rueckschreiben; achsen-eigenes Praedikat writes_back_to_disk() (concepts/
axis_persistence_target_concept.hpp:5-7); misst am Ist die Rueckschreib-VORBEREITUNG (Staging), NIE
Platte (Ehrlichkeits-Deklaration axis_persistence_target_disk_writeback.hpp:10-19). Min/Max-Semantik =
RESEARCH-ERGAENZUNG (kein BEFUND-09.07.-Anker, Achse juenger als ORG-18): MIN Rueckschreib-Overhead
bei gegebener Persistenz-Pflicht UND MAX Staging-Batching; Trade-off Staging-MEM vs. Flush-Frequenz.

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| writeback_rounds/bytes_staged/records_staged/device_flushes/last_checksum | IST [17][0..4] (observable_tier.hpp:101-104; abi_adapter.hpp:1410-1425); bytes_staged=0 fuer MemoryOnly, device_flushes IMMER 0 solange has_device_writeback_path()==false -- ehrlich deklariert. A8-S1-Fix gelandet (seg_persistence_target_ns traegt Werte ab de7688b9, LEDGER:3806) | Thesis pinnt Katalog auf In-Memory (03_messsystem:313-316); honest-0-konform bleiben |
| Staging-Durchsatz bytes_staged/seg_ns[17]; Bytes je Record | ABL | -- |
| Staging-Puffer-PEAK | FB: Zaehler, freier Slot | Staging-MEM-Ast |
| echte Device-Flush-Latenz/fsync; Platten-Write-Amp | FT DOPPELT: Geraete-Pfad existiert nicht + DiskWriteback verdoppelt Voll-Bau-Raum 2^17->2^18 (disk_writeback.hpp:20-23) | erst mit Geraete-Pfad |

Substitution/Messbaum: seg_ns[17] IST seit A8-S1 (de7688b9, LEDGER:3806); Substitutions-Indikator 0/6
persistence_target-Header mit std-Treffern (grep 04.08., sauber); Feinaufloesung P10.

---

### C-A growth_policy (Sequence-Achse; Slot in SequenceObserverAggregate<9>)
Aufgabe: Wachstums-Politik. Min/Max: MIN amortisierte Kopierkosten UND MIN Ueberallokation UND MIN
Realloc-Pausen (3-Ziel-Trade-off, Dossier-18:124 "nicht naiv 1 Min/Max je Achse").

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| statistics()/snapshot_t der Achse | FEHLT KOMPLETT: DoublingGrowth traegt nur next_capacity/growth_factor (sequence_composition.hpp:24-30, identisch WT) -> C3-Slot = EmptyAxisSnapshot (observer_aggregate.hpp:27-33/:46-63) | R4-L6: kein Metrik-Anker in Thesis/BEFUND -- exakt die Owner-benannte stille Luecke |
| growth_events | IST nur im flachen Gattungs-POD (sequence_tier.hpp:19; in-process sequence_anatomy.hpp:19-27) | einziger schon vorhandener Gattungs-KPI |
| GrowthStatistics-POD (FB, 7 Felder): growth_events, elements_copied, bytes_copied, requested_total, granted_total, final_capacity, peak_slack | FB: Observable-Huelle nach ObservableIndexOrg-Muster (axis_01...observable.hpp:60-134, ENABLE_STATISTICS-gegated, honest-100%) | Amortisation sichtbar (Exact-Policy zeigt O(n^2) literal); Ueberallokations-Faktor vs. deklariertem growth_factor |
| max_single_growth_ns (Realloc-Spike) | FT: Treiber-Timing | Tail-Latenz-Ast |
| CT-Identitaet growth_factor() | IST (sequence_composition.hpp:16-21); Theorie ~1.5/Golden-Ratio vs. 2.0 | std::vector-Vergleichshuelle 03_messsystem:916-919 |
| Varianten-Raum | NUR 1 Policy (DoublingGrowth); GoldenRatio/FixedChunk/Exact = deklarierter Vollausbau (sequence_composition.hpp:8-9), KEIN Fenster im E-24-Bauplan | Kurven brauchen >=2 Varianten |

### C-B extent_policy (View-Achse; Slot in ViewObserverAggregate<5>)
Aufgabe: Ausdehnungs-Vertrag (statisch => Bounds-Check-Elision moeglich).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| statistics()/snapshot_t | FEHLT: DynamicExtent ohne statistics() (view_composition.hpp:34-43) -> EmptyAxisSnapshot | R4-L6 |
| oob-Quote read_oob/read; bind_count/Re-Binding-Rate; bound_size | IST im Gattungs-POD (view_tier.hpp:12-21) -- ABL fuer die Achse | Ehrlichkeits-Beleg des Extent-Vertrags |
| ExtentStatistics-POD (FB, max. 3 Felder) | FB: Huelle | -- |
| Bounds-Check-Elisions-Beweis | FT/relational: CT-/Codegen-Paarvergleich statisch vs. dynamisch -- kein Zaehler | der eigentliche Performance-Beweis |
| CT-Identitaet is_static()/static_extent() | IST (view_composition.hpp:18-22) | Design-Space |

### C-C layout_policy (View-Achse)
Aufgabe: Index->Offset-Uebersetzung mit maximaler Lokalitaet.

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| statistics()/snapshot_t | FEHLT: LayoutRight ohne statistics() (view_composition.hpp:34-43) -> EmptyAxisSnapshot | R4-L6 |
| LayoutStatistics-POD (FB): index_translations, non_contiguous_steps (aus real gelieferten Offsets gezaehlt, #24-Option-A-Praezedenz, NIE aus Layout-Typ synthetisiert), max_offset_jump (dTLB-/CLU-Proxy) | FB: Huelle + 3 Zaehler | Lokalitaets-Verlust zaehlbar |
| Uebersetzungs-Wall-Clock-Anteil | FT: Referenz-Differenzmessung (View-Loop vs. Identitaets-Layout-Loop) | -- |
| Varianten-Raum | nur LayoutRight; layout_left/stride = Vollausbau (view_composition.hpp:8-9) | Kurven brauchen >=2 |

### C-D accessor_policy (View-Achse)
Aufgabe: Element-Zugriff ohne Aufschlag (aligned/unaligned/konvertierend).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| statistics()/snapshot_t | FEHLT: DefaultAccessor ohne statistics() -> EmptyAxisSnapshot | R4-L6 |
| AccessorStatistics-POD (FB): access_count, unaligned_accesses (nur wenn real geprueft, sonst ehrlich Empty), conversion_ops | FB: Huelle | honest-0-konform |
| KERN-Parameter Overhead-Ratio t_view_read/t_raw_read | FT: Rohspeicher-Zwilling (nackter Pointer-Loop) existiert NICHT; Ziel-Kurve konstant ~1.0 | relational, kein Zaehler; std::span-Orakel (E24:127-129) |

### C-E inner_container (Adapter-Achse; Slot in AdapterObserverAggregate<11>)
Aufgabe: Enden-Ops in disziplin-gerechter Kostenklasse (FIFO/LIFO O(1), PRIORITY O(log n)).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| statistics()/snapshot_t | FEHLT: DequeInner/VectorInner/HeapInner ohne statistics() (adapter_anatomy.hpp:38-97 mainline; WT :52/:69/:90) -> EmptyAxisSnapshot | R4-L6 |
| push/pop/front_reads/back_reads/current_occupancy/peak_occupancy | IST nur im flachen Gattungs-POD (adapter_anatomy.hpp:103-111) -- gehoeren als InnerContainerStatistics AN DIE ACHSE | Disziplin-Mix front:back = FIFO/LIFO-Nutzungs-Beweis (ABL) |
| underflow_count (pop auf leer) | FB: heute UNBEOBACHTET (adapter_anatomy.hpp:186-204) obwohl hauseigenes q1-Schema underflow fuehrt | Ehrlichkeits-Schliessung |
| elements_shifted (VectorInner pop_front = erase(begin) = O(n), adapter_anatomy.hpp:63) | FB: Zaehler -- verdeckte O(n^2)-Drain-Klasse wird zaehlbar | Kostenklassen-Beleg |
| sift_ops (HeapInner push_/pop_heap, :80-91) | FB: Zaehler -- O(log n)-Beleg der PRIORITY-Disziplin | Kostenklassen-Beleg |
| block_events (DequeInner Chunk-Churn) | FB: Zaehler | Kostenklassen-Beleg |
| Feldbedarf | 6 Bestand + underflow + Union-Slot(shifted|sift|block; disjunkt je Substrat) = 8 -- passt; alternativ breiterer Gattungs-POD (Entscheid) | einziger 8er-Grenzfall der Container-Seite |
| CT-Identitaet Substrat-Name/Compare-Typ | IST (:41/:58/:79) | Design-Space |

### G-1 Gattungs-Ebene SET
Beleg der Aufgabe: Lookup-/Insert-/Erase-Kurven ueber Fuellstand, relativ zur std::set-Referenz
(Orakel-Entscheid E24:89-90; V5-Vertrag import -> GATE -> messen, pruef_dock.hpp:74-79).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| insert(nur Neue)/contains/hit/miss/erase(nur Erfolge)/current_size/peak_size + observable_axis_count/organ_count | IST V1-Wire-POD (set_tier.hpp:17-27); in-process set_anatomy.hpp:22-30 | Referenz-Doktrin: identische Op-Folge gegen std::set-Zwilling |
| insert_attempt_count + erase_attempt_count | FB: Ehrlichkeits-Schliessung -- Duplikat-/Erase-Miss-Quote heute strukturell unbestimmbar (set_anatomy.hpp:49-76) | ohne sie keine Quoten |
| hit_ratio; clear_count | ABL / FB klein | Kurven-Segmentierung |
| per-Op-Latenz p50/p99 je Fuellstands-Fenster | FT: Dock-Treiber faehrt fixe 0..n-Sequenzen OHNE Zeitnahme/Fuellstands-Parameter (WT set_dock.hpp:66-77, CSV nur Zaehler :80-88); SA-Praezedenz latency_samples_ns/Welch (LEDGER:544) + seg_ns Pfad B fehlen container-seitig | KURVEN-Doktrin: Zaehler-PODs ersetzen keine Kurven |
| C3-Aggregat SetAxisObservation 13 Slots | IST WT (set_anatomy.hpp:59-99, observe_axes :236-283 aus 13 REALEN Organ-Membern :287-300) -- in-process, KEIN Wire-POD, Promotion=C6 | C6-Freeze-Objekt |

### G-2 Gattungs-Ebene SEQUENCE
Beleg: Append-/Random-Access-Kosten + Realloc-Zahl; Orakel std::deque (E24:99-100, "kein
Realloc-Artefakt"); zusaetzlich std::vector-Referenzzwilling trennt Block- vs. Flach-Layout.

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| push/at/at_oob/current_size/peak_size/growth_events + Meta | IST V1-POD (sequence_tier.hpp:12-22) | growth_events = einziger schon vollstaendiger Gattungs-KPI |
| Append-Kurve ueber n (amortisiert + Spikes an growth_events); at(i)-Kurve ueber Fuellstand | FT: Treiber-Ausbau mit Zeitnahme | Kurven-Doktrin |
| capacity/slack-Spiegel | FB aus GrowthStatistics (C-A) | -- |
| C3-Aggregat SequenceAxisObservation 9 Slots | IST WT (sequence_anatomy.hpp:46-76) | C6-Freeze-Objekt |

### G-3 Gattungs-Ebene ADAPTER
Beleg: Enden-Ops-Kosten je Substrat; DREI Orakel std::queue/std::stack/std::priority_queue (C4-Ist
WT genus_conformance_gate.hpp:12-19; Disziplin-Probe put(10,30,20): Heap front=30, Deque/Vector
front=10 :21-33 -- belegte Bauplan-Abweichung vom 2-Orakel-Entscheid E24:115-118).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| push/pop/front_reads/back_reads/current/peak + organ_count | IST V1-POD (adapter_tier.hpp:26-45) -- EINZIGER POD OHNE observable_axis_count (:35) | Symmetrie-Nachzug C6 |
| underflow_count (Wire-Spiegel) | FB (s. C-E) | -- |
| Enden-Ops-Kurven je Substrat (push/pop_front/pop_back ueber Fuellstand) | FT: Treiber-Ausbau; trennt Deque O(1) / Vector O(n) / Heap O(log n) | Kurven-Doktrin, je gegen disziplin-passendes Orakel |
| C3-Aggregat AdapterAxisObservation 11 Slots; total_slots aus LIVE slot_count==11, NICHT frozen kAdapterCompositionSlotCount==13 | IST WT (adapter_anatomy.hpp:173-207; :166/:205-207); Aufraeumpass-Kandidat (32) bestaetigt (mainline :152) | C6-Freeze-Objekt |
| LIFO-Permutation in der Registry | FEHLT (2 Substrate FIFO, 1 PRIORITY, genus_conformance_gate.hpp:34-37); std::stack-Orakel steht bereit | LIFO-Kurven nur ueber Test-Huelle belegbar |

### G-4 Gattungs-Ebene VIEW
Beleg: Zugriffs-Overhead vs. Rohspeicher; non-owning-Invariante (KEINE insert/erase/alloc-Parameter --
view_tier.hpp:31-33 API-Asymmetrie gewollt, keine Phantom-Felder).

| Qualitaets-Parameter | Ist-Stand | Thesis-Versprechen (R4) |
|---|---|---|
| read_count/read_oob_count/bound_size/bind_count + Meta | IST V1-POD (view_tier.hpp:12-25) | Kern |
| Overhead-Ratio-Kurve gegen Rohspeicher-Baseline | FT: Paarmessung existiert NICHT (kein nackter Puffer-Loop im Treiber) | zentraler View-KPI, heute nicht erhebbar |
| sequentiell vs. gestreut (trennt Layout- von Accessor-Anteil) | FT: Treiber | -- |
| C3-Aggregat ViewAxisObservation 5 Slots | IST WT (view_anatomy.hpp:43-64) | C6-Freeze-Objekt |

### Nicht-Container-Formen (Vollstaendigkeit)
- SYSTEM-Organe (nicht mehr im SA-POD, INC-2c/2d): TelemetrySnapshot (axis_11...observable.hpp:28-34),
  IsaStatistics (axis_09_isa_observable.hpp:41-48) -- System-Sphaere, binary-id-neutral ("Blut",
  03_messsystem:973-986); Observer-Overhead-Quantifizierung haengt am ungebauten 3-Varianten-
  Mechanismus (R4-L12).
- VirusMeasurementSnapshotV1 (execution_engine/virus_execution_engine.hpp:19-27) -- 5. Form, kein
  Achsen-Thema.
- cacheline-Unterachse (axes/cacheline/cacheline_config.hpp:1-20): KEIN eigener Observer; einzige
  RT-Dimension = HW-Prefetcher-MSR-Zustand (Launcher); A-15-Einordnung neuer Observer-Parameter offen.

---

## 1N. NACHTRAG-3-SPALTEN (Owner-KERN 04.08. NACHTRAG 3; Befund B1)

### 1N.1 Mess-Objekt + strikte Trennung 'ohne' vs. leer
MESS-OBJEKT ist der eingestellte ALGORITHMUS, die Achse der Mess-KANAL: Qualitaet(Algorithmus |
Achse, Situation) = Blatt-Einheit der Programm-Messbaeume. Die Auspraegung "OHNE Optimierung"
(NonePrefetch & Co.) ist eine AKTIVE Variante MIT Mess-Identitaet: eigene Permutations-Zelle/
binary_id, Zaehler laufen, strukturelle Nullen sind EHRLICHE Nullen (CSV-Legende) -- sie ist die
BASELINE der Vergleichs-Kurven je Achse. STRIKT DAVON GETRENNT: "leer/getragen" = CarriedAxis
(cross_genus_organ.hpp:55, `struct CarriedAxis {};`) bzw. EmptyAxisSnapshot
(observer_aggregate.hpp:27-33) = Identitaet OHNE Antrieb, KEIN Algorithmus, KEINE Mess-Identitaet.
Ein C6-Freeze darf die beiden Klassen nie vermengen: 'ohne' liefert Werte, 'leer' liefert keine.

### 1N.2 Katalog-Spalten je Thema: 'ohne'-Auspraegung | Einsatzorte | Research-Verwendung

| Thema | 'ohne'-Auspraegung (Ist am Objekt) | konzeptionelle Einsatzorte | Research-/Paper-Verwendung |
|---|---|---|---|
| T0 search_algo | NICHT SINNVOLL (Suche = Pflicht-Aufgabe); Baseline-Rolle = LinearScanSearchAlgo (axis_03a_search_algo_linear_scan.hpp:41) | SA-Wurzel; ruft T1-T14 + Container-Organe (Rekursions-Topologie 2.11) | BEFUND:107-115; original_art/hot/start/surf-Blaetter = Paper-Faithful-Stufe |
| T1 cache_traversal | FEHLT als Blatt; naechste Naeherung = linear_fanout (Basis-Traversal) -> E14 | unter T0 je Knoten-Aufloesung | BEFUND:126-141 |
| T2 mapping | VORHANDEN semantisch: DirectPlacement = ohne Indirektion, konstant 1 (axis_03m_mapping_direct_placement.hpp:37) | logisch->physisch unter T0/T1; Pool-Seite unter T6 | BEFUND:143-157; Masstree-Bindung tab:axes-overview T2 |
| T3 path_compression | VORHANDEN literal: PathCompressionNone (axis_02_path_compression_none.hpp:16) | Pfad-Verdichtung in Baum-Varianten unter T0 | BEFUND:159-169 |
| T4 node_type | NICHT SINNVOLL (Knoten-Format = Pflicht); Baseline = SlotStore/Node4-Familie (axes/node/) | Knoten-Substrat unter T0; Cross-Genus: Sequence-Organ im SA-node_type-Slot belegt (C1-Durchreichungs-Beweis, LEDGER NACHTRAG 04.08.) | BEFUND:171-183; ART ~52 B/Key; H1 (05_evaluation:10-12) |
| T5 memory_layout | NICHT SINNVOLL (Layout = Pflicht); Baseline = AosStrict (naiv, axis_05_memory_layout_aos_strict.hpp) | Feld-Anordnung unter T4/T11 | BEFUND:185-200; LOUDS/SuRF (BEFUND:200) |
| T6 allocator | VORHANDEN semantisch: StdMalloc = System-Default ohne Pool-Optimierung (axis_06_allocator_std_malloc.hpp:51) | GLOBALER Substitutions-Hub: alle Container/Algorithmen sollen ueber ihn allozieren (Owner-Beispiel; Ist-Luecke 1N.3) | BEFUND:202-217; 26 Vendor-Familien je Paper-Anker |
| T7 prefetch | VORHANDEN literal: NonePrefetch (axis_07_prefetch_none.hpp:20) -- das Owner-Beispiel aus NACHTRAG 3 selbst | Latenz-Verdeckung unter T1/T5 | BEFUND:219-233 |
| T8 concurrency | VORHANDEN literal: NoneConcurrency (axis_08_concurrency_none.hpp:17) | Zugriffs-Schutz um T0-Ops | BEFUND:235-248; OLC-Papiere |
| T9 serialization | VORHANDEN semantisch: RawBinarySerialization = ohne Kompression (axis_10_serialization_raw_binary.hpp:18) | Externalisierung unter T17/T12 | BEFUND:250-259 |
| T10 value_handle | VORHANDEN semantisch: InlineValueHandle = ohne Indirektion (axis_14_value_handle_inline.hpp:21) | Wert-Zugriff unter T0/T4 | BEFUND:277-290; H3 (05_evaluation:19-21) |
| T11 index_organization | VORHANDEN semantisch: HeapIndexOrganization = Heap-Vollscan ohne Index-Organisation (axis_01_index_organization_heap.hpp:20) | Zugriffsweg ueber T0; E-24: Sub-Organ von Set (E24-Bauplan:91) | BEFUND:307-320; clustered/IOT-Literatur |
| T12 io_dispatch | VORHANDEN literal: InMemoryOnly (axis_io_in_memory_only.hpp:20) | IO-Buendelung unter T17 | BEFUND:322-333; mmap-Antithese |
| T13 migration_policy | VORHANDEN literal: NoMigration (axis_migration_none.hpp:19) | Tier-Umschichtung ueber T6/T17 | BEFUND:335-350 |
| T14 filter | FEHLT literal UND semantisch: AllFilters = mp_list<Bloom, Cuckoo, RangeSurf, Xor> OHNE None-Blatt (axis_filter_registry.hpp:18) -- einzige Achse, deren Nutzen-Beleg (A/B gegen filterlos) heute keine baubare Achsen-Variante hat -> E14 | Negativ-Abweis vor T0-Lookups | BEFUND:352-365; Range-Filter-Substrat real (axis_filter_range_surf.hpp) |
| T15 queuing_q1 | VORHANDEN literal: NoBuffer (axis_q1_queuing_no_buffer.hpp:28) | Write-Pufferung vor T0-Insert | BEFUND:367-381 |
| T16 queuing_q2 | FEHLT literal; Lazy = Naeherung, aber eine Politik (kein 'ohne') -> E14 | Flush-Steuerung ueber T15 | BEFUND:383-401; LSM-Literatur (adaptive_lsm) |
| T17 persistence_target | VORHANDEN semantisch: MemoryOnlyTarget = ohne Rueckschreiben (axis_persistence_target_memory_only.hpp:27) | Rueckschreib-Senke unter T16/T12 | Research-Ergaenzung (E4; kein BEFUND-Anker) |
| C-A growth_policy | 'ohne Ueberallokation' = Exact -- deklariert, UNGEBAUT (sequence_composition.hpp:8-9) -> E10/E14 | Sequence-Gattung; Kapazitaets-Politik | R4-L6 (kein Thesis-Anker); std::vector-Vergleich 03_messsystem:916-919 |
| C-B extent_policy | VORHANDEN CT-seitig: static extent = ohne dynamische Grenze (is_static/static_extent, view_composition.hpp:18-22) | View-Gattung; Bounds-Vertrag | R4-L6; std::span-Orakel (E24:127-129) |
| C-C layout_policy | NICHT SINNVOLL (Uebersetzung = Pflicht); Baseline = LayoutRight (Identitaets-Layout) | View-Gattung; Index->Offset | R4-L6; mdspan-Literatur |
| C-D accessor_policy | VORHANDEN semantisch: DefaultAccessor = ohne Aufschlag (Ziel-Ratio ~1.0) | View-Gattung; Element-Zugriff | R4-L6 |
| C-E inner_container | NICHT SINNVOLL (Substrat = Pflicht); Disziplin-Baseline je Orakel | Adapter-Gattung; Enden-Ops | R4-L6; STL-Adapter-Referenzen |
| G-1..G-4 Gattungs-Ebenen | keine 'ohne'-Frage (Interface-Ebene, kein Algorithmus); Abgrenzung: CarriedAxis = getragen, NICHT 'ohne' (1N.1) | Container-Gattung = Baustein der Komplett-Zerlegung: verwendet IN SearchAlgorithm UND bedient sich selbst aus dem Achsen-Pool; Adapter am Ist = ObservableOrgan-Huellen/Sub-Organ-Bauformen (C1/C3) | Orakel-Doktrin std::set/deque/queue/stack/priority_queue (E24:89-118) |

BEFUND der Spalte (i): 8 Themen literal 'ohne' (T3/T7/T8/T12/T13/T15 + semantisch praezise T6/T17),
6 weitere semantisch vorhanden (T2/T9/T10/T11/C-B/C-D), 5 nicht sinnvoll (T0/T4/T5/C-C/C-E),
LUECKEN: T1, T14 (einzige harte -- Nutzen-Beleg der Achse haengt daran), T16, C-A (ungebaut) -> E14.

### 1N.3 Container-Gattungs-Substitutions-Befund (Owner-Beispiel NACHTRAG 2, real am Objekt)
Die Gattungs-Substrate speichern HEUTE ueber std-Container mit DEFAULT-std::allocator, NICHT ueber
die T6-Achse: sequence_anatomy.hpp:207 (`std::vector<element_type> data_`), adapter_anatomy.hpp:64/
:81/:108 (std::deque/std::vector-Substrate; Zeilen am gelandeten Stand 44bcda99). Das Allokator-ORGAN
existiert je Gattung als BEOBACHTENDES Organ (set_anatomy.hpp:189-190 allocator_organ()), aber die
Element-Speicherung laeuft daran vorbei -- exakt die Owner-benannte Substitutions-Luecke ("multiple
container, die den globalen Achsen-Allokator verwenden sollten"). KEIN C6-Blocker (Wire-Form ist
davon unabhaengig), aber die GROESSTE bekannte Substitutions-Luecke des Katalogs; Heilung = eigenes
Fenster nach C6, Vollerhebung inkl. Set-Substrat = P10.
Substitution/Messbaum Container-Seite: Gattungs-Timing fehlt im Wire (E13); Messbaum-Anker der
Gattungen entsteht erst mit dem seg_ns-Analogon bzw. dem Dock-Treiber-Ausbau (2.9).

---

## 2. C6-IMPLIKATIONEN -- was die XxxObserverAggregate<N>-Wire-Formen tragen MUESSEN

Damit C6 nichts Armes einfriert (Owner-Terminierung LEDGER:3812 Punkt 3), sind VOR bzw. IN C6 bindend:

1. OBSERVABLE-HUELLEN + Statistics-PODs fuer die 5 gattungs-eigenen Achsen-Themen growth_policy,
   extent_policy, layout_policy, accessor_policy, inner_container -- heute EmptyAxisSnapshot
   (observer_aggregate.hpp:27-33/:46-63). Muster: ObservableIndexOrg (axis_01...observable.hpp:60-134;
   COMDARE_CE_ENABLE_STATISTICS-gegated, OFF = 0 Footprint, honest-100%-Zaehler #24 Option A).
   Ein Freeze mit leeren Slots waere die woertliche "stille Qualitaets-Luecke".
2. MINDEST-FELDSAETZE der neuen PODs: GrowthStatistics {growth_events, elements_copied, bytes_copied,
   requested_total, granted_total, final_capacity, peak_slack} (7) | InnerContainerStatistics
   {push, pop, front_reads, back_reads, current_occupancy, peak_occupancy, underflow_count,
   substrat_union(elements_shifted|sift_ops|block_events)} (8; Union-Slot disjunkt je Substrat) |
   LayoutStatistics {index_translations, non_contiguous_steps, max_offset_jump} | ExtentStatistics
   {bounds_checks_performed, oob_rejects, rebind_count} (3, BENANNT -- ein Freeze braucht Namen;
   honest-0 bei static extent: bounds_checks_performed==0 IST der on-wire-Elisions-Beweis, Ergaenzung
   zum relationalen Codegen-Vergleich C-B) | AccessorStatistics {access_count, unaligned_accesses,
   conversion_ops} -- alle honest-0-faehig.
3. VOLLE statistics()-Form je Slot transportieren INKLUSIVE double-Ersatz (milli-/promille-uint64) --
   sonst wiederholt der Gattungs-Wire den SA-double-Drop (observable_tier.hpp:66-68) bei
   avg_density/avg_collision_chain/fragmentation/avg_occupancy/avg_fill_at_flush. KONSEQUENZ (B9-ii):
   die Skalierungs-Konvention E1 ist damit C6-BLOCKIEREND -- SetObserverAggregate<13> transportiert
   u.a. AllocationStatistics mit 2 double-Feldern external/internal_fragmentation
   (axis_06_allocator_cache_engine_permutation_concept.hpp:61-62); der double-Ersatz muss IN der
   C6-Wire-Form stehen, also MUSS E1 VOR C6 gebunden sein (nicht erst vor Klasse-A2-Benennungen).
4. SET-EHRLICHKEITS-SCHLIESSUNG: insert_attempt_count + erase_attempt_count in Anatomie und Wire-Form
   (set_anatomy.hpp:49-76) -- Duplikat-/Erase-Miss-Quote sonst dauerhaft unbestimmbar eingefroren.
5. ADAPTER-SYMMETRIE: observable_axis_count in die Adapter-Wire-Form (einziger V1-POD ohne,
   adapter_tier.hpp:35) + underflow_count.
6. total_slots/Groessen aus LIVE Composition::slot_count ableiten (WT-Praezedenz adapter_anatomy.hpp:
   205-207), NICht aus frozen Konstanten (kAdapterCompositionSlotCount==13 vs. live 11 = Kandidat (32)).
7. KOMMENTAR-NACHZUG im C6-Commit: stale organ_count-Kommentare 15/11/7/13 vs. live 13/9/5/11 in allen
   4 V1-PODs (set_tier.hpp:25-26, sequence_tier.hpp:20, view_tier.hpp:18, adapter_tier.hpp:35) +
   observer_aggregate.hpp:2 "17-Achsen" + axis_03m:25 1272-POD-Satz + observable_tier.hpp:76 (B10:
   der als Praezedenz zitierte T2-slot[6]-Kommentar traegt SELBST das stale "aktuell 1272, INC-2d";
   Ist: sizeof==1344, Version 8, observable_tier.hpp:160-162/:166-167 -- am 04.08. reverifiziert).
8. FEHLER-SICHTBARKEIT: alle neuen Felder unter der G3-Regel (klassifizierte Fehlerklasse im Log UND
   'failed'-Zelle, nie 0/null -- e24_container_gattungs_abi_dossier.md:285; axis_error.hpp:12/:121);
   ehrliche strukturelle Nullen (device_flushes, tier_moves, contention) in der CSV-Legende deklarieren.
9. KURVEN-VORBEHALT (kein C6-Blocker, aber deklarieren): Zaehler-PODs ersetzen die geforderten
   Gattungs-KPI-KURVEN nicht -- Dock-Treiber-Ausbau (Fuellstands-Sweep + per-Op-Latenz nach
   SA-Praezedenz latency_samples_ns/Welch, seg-Timing) ist eigenes Nach-C6-Fenster; View braucht
   zusaetzlich die Rohspeicher-Zwillingsmessung.
10. C3-ZEILEN-DRIFT (Ist-Update 04.08., Runde 2): C3-C5 ist inzwischen GELANDET -- CE dev == WT ==
    Merge 44bcda99. Die im Dossier zitierten C3-Anatomie-Zeilen stammen vom Zwischenstand 0c56b69b
    und SIND gedriftet (Stichprobe: SetStatistics-Zaehler jetzt set_anatomy.hpp:39-45 statt der
    zitierten in-process-:22-30; allocator_organ() :189-190). VOR C6-Formgebung ALLE C3-Anker gegen
    44bcda99 (bzw. den dann aktuellen dev-Stand) nachziehen. Die Wire-/Schema-Anker
    (observable_tier.hpp, abi_adapter.hpp, measurement_snapshot.hpp) sind am gelandeten Stand
    stichproben-reverifiziert und UNVERAENDERT.
11. REKURSIONS-INVARIANTE (Owner-KERN NACHTRAG 3 (d), BINDEND fuer C6/A8-S3/Cross-Genus):
    Achsen-Verschachtelung ist METAPROGRAMMATISCH rekursiv erlaubt (Typ-Graph, compile-time
    aufgeloest -- Typ-Zyklen brechen compile-hart), zur LAUFZEIT imperativ/stack-sicher: KEINE
    unbeschraenkte Call-Rekursion ueber Achsen-Grenzen, Schleifen statt Rekursion. Erlaubte
    Aufruf-Topologie: SA -> Achsen (direkt) -> Achsen -> Container-GATTUNG -> deren Achsen.
    C6-RANDBEDINGUNG: die XxxObserverAggregate<N>-Formen und ihre observe_axes-Einsammlung muessen
    dieser Topologie folgen (flache, imperative Slot-Einsammlung je Ebene -- kein rekursiver
    Laufzeit-Abstieg durch geschachtelte Aggregate); die C3-observe_axes-Form (flaches Aggregat aus
    realen Organ-Membern) erfuellt das am Ist und ist als Muster festzuschreiben.
12. GATTUNGS-TIMING-ENTSCHEID VOR dem Freeze treffen (E13): die 2.1-2.6-Formen tragen KEIN
    per-Slot-Timing (seg_ns-Analogon) -- Einfrieren OHNE Timing ist zulaessig, aber NUR als
    DEKLARIERTE Entscheidung (E13), nicht als Stille; Nachruesten waere ein Wire-/Major-Ereignis.

## 3. SA-WIRE-BEFUND -- reichen die 8 axis_stats-Felder je Thema?

VERDIKT: JA -- die 8 Bestand-Felder REICHEN je Thema; aus dem Research folgt KEINE V3-Schema-/
Major-Wire-Erweiterung (kV3FieldCount bleibt 8, kV3AxisCount bleibt 18, sizeof bleibt 1344).

Begruendung (Slot-Zaehlung je Thema, R2-Befund 9): frei sind T0:2, T2:1, T3:3, T4:4, T5:3, T6:2, T8:3,
T9:4, T10:4, T11:3, T12:3, T13:3, T14:3, T15:3, T16:3, T17:3; T1 = 8/8 voll, T7 = 8/8 geschrieben.
KORREKTUR (B3): der Runde-1-Satz "die fehlend-billigen Zaehler passen in die freien Slots" stimmte
NICHT pauschal -- T4 hatte >=7 FB-Wire-Kandidaten auf 4 freie Slots, T0 einen 3. Kandidaten auf 2.
Das Verdikt traegt erst MIT der folgenden BINDENDEN SLOT-VERGABE (Auswahl wire vs. AlgoDetail-Kanal
vs. Host je Thema); QUOTEN/RATIOS sind host-ableitbar und brauchen keinen Slot; die verbleibenden
Luecken bei T1/T7 (reale CLU/CM, Fehl-Prefetch-Quote) sind PMC-/Instrumentierungs-Klasse, keine
Wire-Zaehler.

BINDENDE SLOT-VERGABE (je Thema; erschoepfend fuer alle Themen mit FB-Wire-Kandidaten):
- T0 (2 frei): [0][6]=Vergleiche, [0][7]=Tiefe -- VOLL; avg_density-milli BINDEND NACHRANGIG (kein
  Slot; spaeter = Klasse B).
- T2 (1 frei): [2][7]=peak_indirection_depth; Rehash-/Reorder-Zaehler bleibt NACHRANGIG (Bestand).
- T3 (3 frei): [3][5]=Basis-Bytes-Nenner, [3][6]=Hoehen-Reduktion; [3][7] Reserve.
- T4 (4 frei): [4][4]=capacity_slots_total, [4][5]=node_class_transitions; [4][6]/[4][7] Reserve;
  Typ-Verteilung + grow/shrink-Split BINDEND ueber AlgoDetail-Kanal (NICHT Wire); Verschnitt/
  Belegungsgrad/Fanout = Host-ABL.
- T5 (3 frei): optionaler Alignment-/Split-Zaehler [5][5]; Rest Reserve.
- T6 (2 frei): [6][6]/[6][7]=frag-milli; bytes_in_use_peak = Host-END-Append (E2); Lokalitaet/NUMA/
  Skalierung = FT/Host-Proben-Klasse (B4), KEIN Slot.
- T8 (3 frei): Retry-/CAS-/Warte-Zaehler NUR bei Mess-Kanon-Oeffnung (E7); bis dahin Reserve.
- T9 (4 frei): [9][4]=Raw-Bytes-Nenner; Rest Reserve.
- T10 (4 frei): [10][4..6]=inline_hits/external_refs/chain_refs, [10][7]=chain_depth-Summe -- VOLL.
- T11 (3 frei): [11][5]=bytes/cache_lines-Proxy, [11][6]=early_exit, [11][7]=Pflege-Zaehler -- VOLL.
- T13 (3 frei): [13][5]=Cold-Hit, [13][6]=Rueckmigrationen, [13][7]=Move-Overhead-ns -- VOLL.
- T14 (3 frei): [14][5]=known_absent_fp, [14][6]=add_count, [14][7]=displacement_ops -- VOLL (B6).
- T15 (3 frei): [15][5]=occupancy-Summe, [15][6]=Sample-Zaehler, [15][7]=Batching -- VOLL.
- T16 (3 frei): [16][5]=avg_fill-milli, [16][6]/[16][7]=Write-Amp-Byte-Paar -- VOLL.
- T17 (3 frei): [17][5]=Staging-Puffer-Peak; Rest Reserve.
Slot-Indizes = VORSCHLAG in Schreib-Reihenfolge-Konvention (observable_tier.hpp:97-104 Muster);
endgueltige Benennung = Klasse A2 im Entscheid-Fenster E3.

EREIGNIS-KLASSEN (nichts davon still):
- KLASSE A, layout-neutral, aber CSV-SCHEMA-EREIGNIS (neue Spalten; deklarierter Mini-Schritt im
  A8-S3- oder E-24-Fenster, Fenster-Zuordnung = Entscheid): (A1) T7-Drift-Heilung -- 3 Schema-Namen
  fuer die GESCHRIEBENEN Felder real_prefetches_issued/last_prefetch_distance/last_real_address
  (observable_tier.hpp:83-85 names[5..7]=nullptr vs. abi_adapter.hpp:1267-1269). (A2) Slot-Benennungen
  + Schreiber fuer neue Zaehler in freie Slots GEMAESS BINDENDER SLOT-VERGABE oben (T0 Vergleiche+
  Tiefe, T2 peak_indirection_depth, T4 capacity_slots_total+node_class_transitions [Typ-Verteilung =
  AlgoDetail-Kanal, KEIN Wire-/Schema-Ereignis], T6 frag-milli, T10 H3-Varianten-Zaehler, T11
  CLU-Proxy/early_exit/Pflege, T14 Ground-Truth-FPR+add_count+displacement_ops, T15/T16 milli+
  Write-Amp, T17 Staging-Peak). Praezedenz layout-neutraler Nachbenennung: T2-slot[6]
  (observable_tier.hpp:76; Kommentar dort selbst stale, Nachzug 2.7).
- KLASSE B, V3-Schema-/ABI-MAJOR-GEKOPPELT (NUR per Entscheid im OFFENEN E-24-Fenster, LEDGER:3812
  Punkt 3 -- am Ist NICHT noetig): jede kV3FieldCount>8-Verbreiterung; jeder NEUE Zaehler auf T1
  (8/8 voll) oder T7 (nach Benennung voll); T6-Vollmenge on-wire (9 Felder) FALLS der
  Host-END-Append-Weg fuer bytes_in_use_peak verworfen wird.
- KLASSE C, reine HOST-/CSV-Seite (kein Wire-Ereignis, aber deklarierbares Spalten-Ereignis):
  bytes_in_use_peak END-Append (system_axis.hpp:339-346) INKLUSIVE Fehl-Etikettierungs-Heilung (B7:
  die bestehende Snapshot-Spalte bytes_in_use_peak wird aus axis_stats[6][1]==bytes_in_use befuellt,
  measurement_snapshot.hpp:106-107 -- Momentanwert unter Peak-Etikett, bis zur Heilung in der
  CSV-Legende deklarieren), Tail-Perzentile p99/p999 je Op-Typ aus IST-Vektoren
  (workload_orchestrator.hpp:42-55), frag_milli-Stille-0-Heilung ODER ehrliche
  Nicht-erhoben-Markierung, pmc_branch_misses-Spalte (B8: PmcCounters erhebt branch_misses,
  pmc_source.hpp:24, der WIDE-7er-pmc-Block emittiert es NICHT, iterator:433-434; Thesis verspricht
  die Schema-Erweiterung woertlich, 05_evaluation:181-182 -- Heil-Schritt P11), CSV-Legenden-Semantik
  (T12 Simulation, T13 decide-only, T17 Staging, T8 single-thread-0, T6 Skalierungs-Modus).

## 4. A8-S3-ARBEITSLISTE (SA-Member-Nachruestung + Einsammlungs-Erweiterung, priorisiert)

Basis: SearchAlgorithmAnatomy haelt am Ist NUR 9 reale Achsen-Member (search_algorithm_anatomy.hpp:
202-221); die 9 uebrigen Slots werden nur ueber abi_adapter-Organ-Member getrieben (pc_/pf_/cc_/vh_/
idx_/io_/mig_/flt_organ_ + store_allocator-Route) -- deckt exakt LEDGER:3812 Punkt 1.

1. P1 STRUKTUR: 9 SA-Organ-Member nachruesten (path_compression, allocator, prefetch, concurrency,
   value_handle, index_organization, io_dispatch, migration_policy, filter) + fill_observer_v3 auf
   Anatomie-Quellen umziehen; Ein-Schreiber-Regel abi_adapter.hpp (nach C3-C5, LEDGER:3806).
2. P2 SICHTBARKEIT: T7-Schema-Benennung (3 Namen; Klasse A1) -- billigster Qualitaetsgewinn, heilt
   real geschriebene, stumme Messwerte.
3. P3 HYPOTHESEN-PFLICHT: T10 inline_hits/external_refs/chain_refs (+avg_chain_depth-Summe) -- ohne
   sie ist Thesis-H3 nicht aus stat_* pruefbar (05_evaluation:19-21).
4. P4 FPR: T14 known_absent-/Ground-Truth-Abgleich-Zaehler -- ohne ihn keine False-Positive-RATE.
5. P5 H1/FORMAT: T4 gemaess BINDENDER Vergabe (Abschnitt 3): Wire NUR capacity_slots_total +
   node_class_transitions; Knotenklassen-VERTEILUNG + grow/shrink-Split ueber den AlgoDetail-Kanal
   andocken (kein Wire-Slot); Verschnitt/Belegungsgrad/Fanout host-seitig rechnen.
6. P6 MEM-EHRLICHKEIT: T6 frag-milli in [6][6]/[6][7] + bytes_in_use_peak Host-END-Append + frag_milli-
   Stille-0-Heilung (Entscheid E2 vorab) + FEHL-ETIKETTIERUNGS-HEILUNG der bestehenden Snapshot-Spalte
   bytes_in_use_peak (B7, measurement_snapshot.hpp:106-107: Momentanwert axis_stats[6][1] unter
   Peak-Etikett "ECHT aus Observer" -- Spalte auf echte Peak-Quelle umziehen ODER ehrlich umbenennen).
7. P7 LATENZ-FORMEL: T0 Vergleichs- + Tiefen-Zaehler ([0][6]/[0][7]).
8. P8 RESTLICHE SLOT-KANDIDATEN: T2 peak_indirection_depth; T15 occupancy-Ersatz + Batching; T16
   avg_fill-milli + Write-Amp-Byte-Paar; T13 Cold-Hit/Rueckmigration; T11 CLU-Proxy/early_exit/
   Pflege-Zaehler; T3 Nenner/Hoehen-Reduktion; T9 Raw-Bytes-Nenner; T17 Staging-Peak.
9. P9 KOMMENTAR-/LEGENDEN-NACHZUG: axis_03m:25; CSV-Legenden-Deklarationen (Klasse C); Mess-Modus-
   Zuordnung T8.
10. P10 SUBSTITUTIONS-LUECKEN-SWEEP (Owner NACHTRAG 2, LEDGER:3813): je Achse FUNDSTELLEN-GENAU
    erheben, wo Achsen-/Algorithmus-Code noch Standard-Funktionen statt der aequivalenten Achsen-
    Definition nutzt. Der GROB-Indikator je Thema ist seit Runde 2 IM Katalog (Zeile "Substitution/
    Messbaum" je Thema, Abschnitt 1; Spitzenwerte lookup 16/21, q1 12/18; Container-Befund
    std::allocator 1N.3) -- P10 liefert die Feinaufloesung je Fundstelle + Heilungs-Plan.
    (A8-S5-Naehe: 70 von 340 axes-.hpp mit std-Container-/OS-Call-Treffern, E24-Bauplan:73.)
11. P11 PMC-SICHTBARKEIT (B8, "geschrieben-aber-stumm"-Klasse wie P2): pmc_branch_misses als
    WIDE-Spalte nachziehen -- PmcCounters erhebt branch_misses real (pmc_source.hpp:24), der
    7er-pmc-Block emittiert es nicht (iterator:433-434), die Thesis verspricht die Erweiterung
    (05_evaluation:181-182); header-getrieben additiv = layout-neutral, billigster Heil-Schritt.

Sperr-Hinweis: A8-S3 serialisiert HINTER dem E-24-Fenster (beide fassen abi_adapter.hpp an,
Ein-Schreiber-Regel, LEDGER-Nachtrag 3.3); Sub-Interface-/POD-Bedarf aus S3 NUR vor/im Fenster --
entsteht er spaeter: STOPP + Manager (K-b).

## 5. Phase-6-Auswertungs-Anschluss (Kurven/Kategorien)

- KATEGORIEN-DECKUNG 16er-Registry (measurement_category.hpp:10-32; Collector-Zuordnung 10/16,
  Anhang D:1182-1196): LATENCY_MEAN/THROUGHPUT <- ns_per_op/op_*_n IST; P50/P99 <- op_*-Spalten IST;
  P95/P999 OHNE Spalte; CLU <- Observer IST (stat_* + Host-Ableitung); MEMORY_FOOTPRINT haengt an T6-
  peak (P6); BRANCH_MISS/IPC_CPI OHNE pmc_-Spalte (7er-Block iterator:433-434 = l1/l2/l3/dtlb/
  coherence/energy/available; 05_evaluation:181-182 deklariert Schema-Erweiterung; fuer BRANCH_MISS
  ist der Quell-Zaehler REAL vorhanden, pmc_source.hpp:24 -- Heil-Schritt = P11/Klasse C);
  FILL_BUFFER_OCCUPANCY ohne Spalte und Collector -- Kandidat = T15-occupancy-Ersatz (P8).
- REGISTRY->BESTANDS-SPALTEN-MAPPING ist explizit OFFENE E4'-Folge-Stufe (curve_fit.hpp:1-12); dieser
  Katalog liefert die Prueftabelle je Kategorie.
- KURVEN: Typsystem tree/map nur Keim (architektur/20:59-69; curve_fit + heuristik/-CSV-Leser); je
  Achse liegen Min/Max-Groesse + Kategorien + Last-Abhaengigkeit vor (BEFUND:81-101; T17-Ergaenzung
  hier, Abschnitt 1); RC-Wirkungs-Kurven real NUR prefetch_distance, die 4 Phantome (batch_size/
  pool_budget/thread_count/inline_threshold) nur als CT-Permutations-Sweeps; CT-Aspekt-Sweeps fuer
  q1-Kapazitaet/q2-Schwellen existieren (12_queuing...:83/:146/:153).
- ZEITREIHEN-LUECKE: Fuellstands-/Occupancy-KURVEN brauchen periodische tier_observe-Zuege mit
  Wall-Clock-Stempel (Mechanismus observable_tier.hpp:176-180 vorhanden, Mess-Pfad faehrt ihn nicht);
  Aufwand mittel, KEIN Wire-Ereignis.
- TAIL-PERZENTILE: p99/p999 je Op-Typ aus IST-Vektoren emittierbar (reine Host-Auswertung; Spalten-
  Ereignis deklarieren) -- Kern-Groesse fuer T6-Alloc-Tail und T16-eager/lazy-Pareto.
- XLSX-STRECKE: Writer konsumiert AUSSCHLIESSLICH das lazy_csv_header-WIDE-Schema (A9-Dossier:220-223)
  -- alle hier vorgeschlagenen Spalten fliessen ohne Writer-Aenderung ein; failed/gesperrt/nicht_gebaut
  woertlich (:224-227); Heuristik bleibt CSV-Leser (:266-267).
- PMC-METHODIK: keine per-Achsen-Attribution (nur per-Lauf + Permutations-A/B); ob A/B als Beleg-Form
  je Achsen-Thema ausreicht = Mess-Methodik-Festlegung (Dossier-18-Anschluss), keine stille Umsetzung.
- PROGRAMM-MESSBAEUME (Owner NACHTRAG 2): Ist-Anker = seg_ns[18] je Slot + Knoten-Projektion; die
  rekursive Achse-unter-Achse-Attribution (z.B. SA->allocator je Algorithmus-Pfad) ist ueber seg_ns
  nur EBENEN-flach -- pfad-aufgeloeste Baeume waeren Instrumentierungs-Klasse (FT), als Zielbild der
  Heuristik-Entscheidungen fuehren.

## 6. OFFENE ENTSCHEIDE (nur echtes NICHT-GEFUNDEN / nirgends festgelegt)

- E1 SKALIERUNGS-KONVENTION double->uint64 (ppm vs. promille vs. milli) fuer avg_*-/frag-Felder:
  NIRGENDS festgelegt; einzige Praezedenz ist der Name frag_milli (measurement_snapshot.hpp:56-57).
  TERMINIERUNG VERSCHAERFT (B9-ii): Festlegung MUSS VOR C6 stehen, nicht erst vor Klasse-A2 --
  der double-Ersatz faehrt IN der C6-Wire-Form selbst (2.3: AllocationStatistics-doubles im
  Set-Aggregat, axis_06_allocator_cache_engine_permutation_concept.hpp:61-62); C6 ohne E1 wuerde
  entweder doubles einfrieren (SA-Drop-Wiederholung) oder eine unbenannte Konvention zementieren.
- E2 T6-SLOT-VERGABE: bytes_in_use_peak on-wire vs. Host-END-Append (Code benennt END-Append,
  system_axis.hpp:339-346) x 2 frag-milli-Slots; on-wire-Vollmenge waere Klasse B (Major).
- E3 FENSTER-ZUORDNUNG der CSV-Schema-Ereignisse (T7-Benennung A1, Klasse-A2-Benennungen, Tail-
  Perzentil- und peak-Spalten): A8-S3 vs. E-24-b -- Manager/Owner; nie still.
- E4 T17-MIN/MAX-SEMANTIK (MIN Rueckschreib-Overhead / MAX Staging-Batching) ist Research-Ergaenzung
  ohne BEFUND-/Owner-Anker -- beim naechsten Owner-Kontakt ratifizieren.
- E5 C6-GATE-FORM: Observable-Huellen + PODs fuer die 5 Container-Achsen VOR C6 bauen (EMPFEHLUNG)
  vs. deklarierte Empty-Slots mit dokumentiertem Nachruest-Fenster -- Owner-Terminierung "Research
  VOR C6" spricht fuer Variante 1; Aufwand liegt im C6-Budget (~4 h) NICHT drin.
- E6 inner_container-FORM: Union-Slot (8 Felder) vs. breiterer Gattungs-POD -- betrifft NUR die
  Container-Wire-Form, keine SA-18x8-Kopplung.
- E7 MULTI-THREAD-MESSFLAECHE (T8, q1-lock-free): Oeffnung des Mess-Kanons Debug=par/Mess=1-Thread
  fuer Concurrency-Qualitaet vor Abgabe -- Owner-/Methodik-Entscheid.
- E8 PMC-BELEG-FORM: Permutations-A/B als ausreichender Beleg je Achsen-Thema (statt per-Achsen-
  PMC-Segmentierung um seg_ns-Fenster) -- Mess-Methodik-Festlegung.
- E9 frag_milli-STILLE-0: befuellen (via E2) oder Spalten ehrlich als nicht-erhoben markieren --
  failed-statt-0-Doktrin verlangt eine der beiden Formen.
- E10 VOLLAUSBAU-FENSTER der Container-Varianten-Raeume (GoldenRatio/FixedChunk/Exact; layout_left/
  stride; aligned_accessor; LIFO-Registry-Permutation): deklariert in den Kompositions-Headern,
  KEIN Slot im E-24-Bauplan -- ohne >=2 Varianten je Thema keine Heuristik-Kurve dieser Themen.
- E11 cacheline-Unterachse: A-15-Einordnung etwaiger neuer Observer-Parameter (RT-Unter-Achse ohne
  Observer) offen.
- E12 STATIK-PROPERTIES-KARTE: concepts/-Pflicht-Properties nur fuer T0/T1/T2/T6/Q1/Q2 literal
  erhoben; die uebrigen 12 Themen unkartiert (Rest-Research, kein Bau-Blocker).
- E13 GATTUNGS-WIRE-TIMING (B9-iii): per-Slot-Timing (seg_ns-Analogon je Genus-Slot) in die
  XxxObserverAggregate<N>-Formen aufnehmen JA/NEIN -- der Messbaum-Anker ist seg_ns je Slot
  (Owner NACHTRAG 2, LEDGER:3813), die 2.1-2.6-Formen tragen KEIN Timing; spaeteres Nachruesten
  waere ein Wire-/Major-Ereignis der Gattungs-PODs. EINFRIEREN-OHNE ist zulaessig, aber NUR als
  hier deklarierte Entscheidung (2.12) -- Owner/Manager VOR C6.
- E14 'OHNE'-AUSPRAEGUNGS-LUECKEN (NACHTRAG 3 (b), Befund 1N.2): T14 filter hat KEIN None-Blatt
  (AllFilters axis_filter_registry.hpp:18) -- der Nutzen-Beleg der Achse (A/B gegen filterlos)
  braucht ein NoFilter-Blatt (Registry-/golden-Ereignis, deklariert) ODER eine CT-Weglass-
  Komposition; T1 (kein 'ohne'-Traversal-Blatt), T16 (kein 'ohne'-Politik-Blatt) analog leichter;
  C-A Exact ist deklariert-ungebaut (E10-Naehe). Fenster-Zuordnung = Owner/Manager; nie still.

ENDE DES DOSSIERS. Ergebnis = DATEN; keine Code-Aenderung aus dieser Session.
NACHBESSERUNGS-VERMERK Runde 2 (04.08.): B1-B10 eingearbeitet (Quittung im Kopf); neue Ist-Anker am
gelandeten Stand 44bcda99 verifiziert; grep-Substitutions-Indikatoren 04.08. erhoben (read-only).
