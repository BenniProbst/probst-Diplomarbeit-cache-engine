# QUELLEN-REPORT: 3 Architektur-Dateien (vollstaendig gelesen)

Gelesene Dateien (absolute Pfade, Zeilenumfang):
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/architektur/14_achsen_komposition_organ_metapher.md` (3484 Zeilen, 19 Teile, §1-§54 + Nachtraege)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/architektur/15_F7_mess_frameworks_workloads_2d_matrix_plan.md` (84 Zeilen)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/architektur/00_INDEX.md` (70 Zeilen)

Selbstcheck: ASCII-only ausser dem zulaessigen Paragraphen-Zeichen; keine Secret-Werte zitiert.

---

## (a1) 14_achsen_komposition_organ_metapher.md - dichte Zusammenfassung

Charakter: Quell-Dokument der Organ-/Lebewesen-Metapher, chronologisch additiv gewachsen (2026-05-26 bis 2026-05-27 nacht), spaeter mit Korrektur-Bannern (2026-06-03) und E2E-Re-Audit-Nachtraegen (2026-07-15) sowie §59-Querverweis (2026-07-20) ueberlagert. Originaltext wird nie ueberschrieben, nur annotiert (`[[never-delete-documentation]]`, 14:360, :642, :988, :3468).

### Kopf-Banner = hoechste Lese-Autoritaet (14:14-54)
- **3-Ebenen-Modell (Doc 30 §8.0) hat bei jedem Widerspruch Vorrang** (14:51).
- **GATTUNG = EIN Interface fuer die Aussenwelt = ein Pruef-Dock**: `SearchAlgorithm` / `Container` / `Graph` (14:23-27).
- **TIER-/LEBEWESEN-UNTERKLASSE = liegt unter dem Gattungs-Interface, traegt den FESTEN Achsen-Satz** (14:29-37). Alle Stellen im Body, die "Gattung"/`AnatomyGenus` fuer die Ebene mit festem Achsen-Satz benutzen (5 Klassen SearchAlgorithm/Set/Sequence/Adapter/View, "Gattung A-F" in §26), meinen in Wahrheit Unterklassen.
- **KEINE Achse ist optional** (14:40-45): jedes Lebewesen-Binary treibt die Interfaces ALLER Achsen uniform; "weglassen" existiert nicht, stattdessen konkreter **Durchreich-Algorithmus** (NoBuffer/NoFlush/NonePrefetch/NoMigration/None).
- **queuing q1/q2 sind Pflicht-ACHSEN der SearchAlgorithm-Unterklasse** (kein Interface, keine Gattung); Code-Ziel AdHocComposition **17 -> 19** (14:47-49).
- Verbatim-User-Direktiven (§1, §10, §16, §25, §33, §41, §43, §53) bleiben woertlich, werden nur annotiert (14:52-54).

### Teil 1 (§1-§9) - Kern-Prinzip
- Verbatim-Direktive Organ-Metapher (14:58-69): jeder Suchalgorithmus hat dieselben Organe in unterschiedlicher Auspraegung; Permutation = genetisches Experiment (Organe tauschen).
- **Achse = Organ, nicht Lebewesen** (14:221-228). Anti-Pattern: monolithische Algorithmus-Wrapper in `axis_03a_search_algo` (14:137-151).
- **Bindender Aequivalenz-Vertrag §3.3** (14:196-207): fuer jede Composition C muss eine Permutation P existieren mit `Permutate(P) == Compile(C)` (bit-identisch oder verhaltensaequivalent). Jeder Original-Algorithmus MUSS als Reference-Composition genau 1 Punkt der Matrix sein (§4.4, 14:245-254).
- **Habich-Compliance pro Organ, nicht pro Composition** (14:209-216): Original-Code/Original-Compiler-Bindung liegt auf Achsen-Ebene (Paper-Mixin, SHA256).
- Pflicht-Gates vor jeder neuen Achse: Organ-vs-Lebewesen-Frage (§4.1), **Universalitaets-Check min. 3 bekannte Algorithmen** (§4.2, 14:230-237), **Rekombinations-Test + Cross-Constraints** (§4.3, 14:239-243).
- 3-Stufen-Modell (§5, 14:257-268): Stufe 1 `comdare_perms_ce`, Stufe 2 `comdare_perms_<pruefling>`, Stufe 3 `comdare_perms_full_join`.
- Master-Statement (14:338-350): Achse=Organ, Algorithmus=Permutations-Konfiguration, Bottom-Up-Pflicht.

### Teil 2 (§10-§15) - Anatomie als Forschungsziel
- Forschungsfrage formal (14:459-465): existiert EINE zentrale Anatomie-Implementation, die per Template-Parameter alle bekannten Algorithmen reproduziert und neuen Permutationsraum erschliesst.
- 3-Schichten (14:388-412): Achsen/Sub-Achsen (15 Topics) -> Composition-Templates -> `SearchAlgorithmAnatomy<Composition>`.
- Anatomie-Tabelle 6 Algorithmen x 17 Organe (14:484-504); Beobachtungen 14:506-510 (SuRF ist selbst Filter, Wormhole einziges HashLookup, viele Organe invariant).
- Permutationsraum-Schaetzung 576 minimal -> 10^4..10^5 bei Vollausbau (14:513-514).
- **R3.2 AUDIT-KORREKTUR: PROMOTION statt Deprecation** (14:528-567) - `OriginalXxx`-Wrapper sind legitime Achsen-Werte S04-S08, **KEINE Loeschung** (14:567). 5 PaperBinding-Compositions unterscheiden sich von den Re-Impl-Compositions ausschliesslich in `search_algo` (Beweis-Test, 14:561-563).
- R4: `AdHocComposition<T0..T16>` mit fixierter Topic-Slot-Convention T0..T16 (14:573-579) - diese Slot-Reihenfolge ist Vertrag.

### Teil 3 (§16-§24) - Verantwortlichkeits-Trennung (KERN-Vertrag)
- Verbatim-Direktive (14:649-666): PermutationEngine erzeugt Anatomien, gesteuert durch CEB-Konfiguration; Anatomie wird als registrierter Binary gespeichert und ABI-stabil durchgemessen; **alles was nicht Teil der Anatomie ist (ausser Statistik-Observern der Achsen) gehoert in die CacheEngineBuilder**; PermutationEngine muss per Metaprogrammierung fuer die 3 kompositionalen Joins erweiterbar sein.
- §17.1 PermutationEngine (14:674-687): compile-time Cartesian via `mp_product`; **KEIN Runtime-Switch, alles statisch determiniert** (14:681). Nicht zustaendig: Container-Ops, Mess-Logik, Binary-Loading.
- §17.2 Anatomie = **nur** 17 Achsen-Member + 17 Statistik-Observer + **ABI-stabiler ObserverAggregate-POD** + Composition-Inspection (14:688-700). Explizit VERBOTEN in der Anatomie: `insert/lookup/erase/clear`, interner `std::map`, Workload-Driver (14:701-717, Wiederholung §24 14:971-977).
- §17.3 CEB: Konfiguration, Binary-Bau, ABI-Loader, Command-Pattern-Workload, Mess-Aggregation (Welch-t-Test), 3-Stufen-Auswahl (14:740-773). **CMake-Treiber `cmake -B build/perm_<hash>` pro Permutation (14:744) ist per Nachtrag R4 abgeloest, s. unten.**
- §18 Die 3 Joins (14:777-846): Stufe 1 = nur CE-Defaults; **Stufe 2 = Pruefling ERSETZT komplett je Achse, Compile-Time-Fallback auf CE-Default wenn kein Pruefling-Namespace** (`[[pruefling-replace-not-extend]]`, 14:798-826); Stufe 3 = `mp_unique<mp_append<...>>` Union-non-redundant (14:828-846).
- §19 Pruefling-Namespace-Slot-Pattern: leerer Default-Slot `PrueflingVariants = mp_list<>` + `has_pruefling=false`, Pruefling ueberschreibt (14:850-885).
- §20 ObserverAggregate: POD/standard-layout/trivially_copyable, 17 named Snapshots (14:889-922). **Pflicht-Concept `ObservableAxis`** (`snapshot_t` + `statistics()`, 14:924-931); Achsen ohne Statistik liefern `EmptySnapshot{}` POD (14:933-934).

### Teil 4 (§25-§32) - Gattungen / Genus-Constraint
- §26 std-Container-Familien A-F recherchiert (14:1018-1087) mit Pflicht-APIs je Familie.
- §27 AnatomyBase two-phase: `AnatomyConcept` (compile-time) + `IAnatomyBase` (virtual, ABI) - **beide gleichzeitig verpflichtend** (14:1107-1150); `AnatomyGenus`-Enum mit 5 Werten (14:1131-1137).
- §28 Achsen-Verteilung je Unterklasse inkl. neuer Achsen `axis_inner/axis_growth/axis_extent/axis_layout/axis_accessor` (14:1180-1205); Banner-Schaerfung: "-" heisst Durchreich-Algorithmus, nicht fehlende Achse (14:1166-1178).
- §29 **Eine PermutationEngine pro Gattung, per Vererbung spezialisiert** (14:1223-1271), CEB waehlt die Gattung (14:1273-1289).
- §32 **HARTE INVARIANTE: nur gleiche Gattung/Unterklasse darf gekreuzt werden** (Verbatim 14:1348-1353). Begruendung: disjunkte Achsen-Sets -> `mp_product` typinkompatibel (14:1368-1370). **Pflicht: jeder Pruefling-Slot deklariert seine Gattung; PermutationEngine prueft per `static_assert` zur Compile-Zeit** (14:1372-1394). Cross-Genus-Vergleich ist **nur Mess-Ebene im CEB, nie Permutation** (14:1403-1408). Build-System: `-DCOMDARE_GENUS=mammal` erzeugt nur passende Compositions; Cross-Genus-Builds werden per `static_assert` blockiert (14:1424-1428).
- prt-art ist Mammal/SearchAlgorithm-kompatibel (14:1397-1401).

### Teil 5 (§33-§40) - ExecutionEngine als Wurzel
- Verbatim (14:1455-1466): **ExecutionEngine steht UEBER AnatomyBase**; Viren (Graphen-Algorithmen etc.) sind messbar ohne Topics/Achsen; das allgemeine Mess-Interface liegt auf der ExecutionEngine.
- Taxonomie (14:1482-1498), `ExecutionEngineKind {Anatomy, Virus, Hybrid}` (14:1523-1527), `IAnatomyBase : IExecutionEngine` mit `engine_kind()` als `final` (14:1557-1574), `IVirusExecutionEngine` parallel, **ohne Achsen/Composition** (14:1577-1593).
- Migration: alte `i_executing_engine.hpp` im prt_art_legacy bleibt unangetastet, `bind_cache_engine` faellt weg (14:1662-1673).
- **Pre-Read-Pflicht: Doku 10 §0-§4 ist Wurzel-Modell, in jeder Architektur-Iteration zu referenzieren** (14:1681-1682).

### Teil 6-8 (§41-§43) - Namens- und Lifecycle-Vertrag
- **`[[technical-identifiers-over-metaphor]]`** (14:1734-1744, :1839-1848): Code-Identifier NUR technisch; Metaphern erlaubt in Kommentaren und .md. Grep-Audit-Pflicht vor Commit (14:1847).
- **Gegenlaeufige Praezisierung (14:2073-2084)**: Metaphern bleiben waehrend der Entwicklung erhalten; vollstaendiger Umbenennungs-Cleanup erst am Ende aller Implementierungsaufgaben (Task #704 / V41.Z.1).
- `SearchAlgorithmAbiAdapter` mit `static_assert` auf Genus (14:1766-1795).
- **Pflicht-Lifecycle-Sequenz fuer jeden Mess-Pass**: `warm_up() -> run() -> reset() -> shutdown()` (14:2051-2063); Lifecycle liegt ausschliesslich im Virtual-Interface, das Concept prueft nur statische Members (14:2065-2071).

### Teil 9-17 (§44-§52) - ABI + Codegen-Pipeline (durchgaengig geliefert + getestet)
- **ABI v1 = genau 4 extern "C" Symbole** je .so/.dll: `comdare_anatomy_abi_version`, `_abi_magic`, `comdare_create_anatomy`, `comdare_destroy_anatomy` (14:2111-2118). Bewusst KEIN 9-Funktionszeiger-POD (`module_abi_v1.hpp` REV7.6 gilt als Pre-Anatomy-Altstand, 14:2103-2109).
- Compat-Regel: Major identisch, Modul-Minor <= Host-Minor (14:2151-2166).
- 3 ABI-Build-Modi STATIC/SHARED-Author/SHARED-Consumer mit PUBLIC/PRIVATE-Define-Semantik (14:2222-2231).
- **Kritische Cleanup-Reihenfolge im Loader**: erst `comdare_destroy_anatomy`, dann `dlclose/FreeLibrary` (Heap-Mismatch-Vermeidung, 14:2315-2318). 7 Validierungsschritte mit errno-Style-Status, Magic vor Version (14:2320-2339).
- Drift-Eliminierung in 3 Stufen: R5.G Traits `HasCompositionLocation` + Macro (14:2674-2686), R5.H `make_desc<C>()` (14:2818-2838), R5.J `KnownReferenceCompositions` als `mp_list` + `mp_for_each` (14:3088-3097, :3109-3125). Neue Composition = 4 Edits, alle im `compositions/`-Modul (14:3162-3172, :3189-3193).
- R5.I 2-Pass-Build (Bootstrap-Problem Tool-Target, 14:2905-2925), STATUS_OUT FOUND/SKIPPED/ERROR, Idempotenz (14:2946-2954).
- Test-Zaehlung kumulativ dokumentiert: 24 -> 92 -> 107 -> 117 -> 122 -> 133 -> 140 -> 154 -> 187 -> 191 -> 197 -> 218 gruen (14:565, :1820, :1978, :2175, :2259, :2385, :2510, :2625, :2778, :3026, :3185, :3317).

### Teil 18 (§53) - WorkloadDriver
- Verbatim (14:3216-3222): Workload-Eigenschaften werden **separat vor dem Experiment ueber alle Permutations-Binaries konfiguriert und exakt in Reihenfolge und Umfang fuer jede Binary wiederholt**.
- `WorkloadConfig` (seed/num_ops/key range/4 Prozentsaetze) + deterministischer xorshift64-Generator; **Reproduzierbarkeit ist Pflicht-Garantie** (14:3267-3275); PRNG-Begruendung Tabelle (14:3277-3290).
- 4 Profile: insert_heavy 80/20, lookup_heavy 5/95, mixed_a 50/50, mixed_b 5/95 (14:3292-3300).
- Verortung: WorkloadDriver gehoert zur CEB-Schicht, NICHT zur AnatomyBase (14:3320-3328).

### Teil 19 (§54) - Audit-Zwischenstand (wichtigster Ist-Befund)
- Verbatim (14:3355-3361): Achsen sind grossteils Stubs, zuerst nachholen; danach Struktur-Aufraeumen + prt-art-Einbindung.
- **Ist-Stand: 15 Topics x 20 Achsen x 99 Wrapper-Dateien; 0 Achsen voll ausgebaut, 20 PARTIAL** (Skelette ohne Algorithmus-Bodies), Compositions valid aber dahinter Marker-Klassen (14:3363-3369).
- Vollausbau-Sprintplan 5 Phasen ~150-180 SP (14:3371-3379).
- prt-art: alles vorhanden ausser Achsen-Slot-Deklarationen (PrueflingSlot, PrtArtComposition, HasCompositionLocation) (14:3399-3406); 5-Phasen-Plan ~20h (14:3408-3416).
- **Pflicht-Reihenfolge: ZUERST Topics-Stub-Vollausbau, DANN prt-art-Einbindung** (14:3418-3420); Priorisierungstabelle R7.1..R7.5 -> R8 -> R5.C.2 -> R6.B/C -> F15 (14:3422-3434).
- CMake-Robustness: `comdare_clean_stale_fetchcontent_subbuild()` gegen Repo-Umzuege (14:3436-3456).

### Nachtraege 2026-07-15 (additiv, korrigierend; 14:3466-3477)
- **R4 (:3470)**: `cmake -B build/perm_<hash>` je Permutation ist **abgeloest**. Kanonisch: **CEB orchestriert den Tier-Binary-Build zur CEB-Laufzeit C++-seitig, nicht via CMake-per-Permutation, kein Python.** Betrifft auch die spaeteren CMake-Snippets §48.5/§51.5. Alt-Text bleibt.
- **R3 (:3472)**: Konfigurationsquelle des CEB = **eine Experiment-XML (3 Phasen) + 2 Registry-XMLs (ce + prt-art)**; XML-Parser als ce-Modul `libs/common/serialization/xml_config_parser`, v32 `PhaseStrategyBase<Derived>` CRTP+Concept; compile-time `TopicConfigSets` sind nur das Uebersetzungs-Ziel.
- **R9 (:3474)**: `organ_count()` ist **kanonisch 19, nicht 17** (Bezug `axis_stats[19][8]`, golden-320); §17.2, §20, §27.2 fuehren noch 17 und erhalten nur eine additive Notiz.
- **R6 (:3476)**: Hot-Path compile-time-only (CRTP+Concepts), W/D (Workload/Dataset) bewusst runtime; die vtable in §27.1 ist Cold-Start-ABI-Grenze, kein Hot-Path - **kein Widerspruch**.
- §59-Querverweis (:3481-3483): Anatomie ist Stempel-Vorlage des KERN-Mess-Schemas; je Pruefling-Merge eigener id-Satz; **dritter Tier-Binary-Stempel = die Merge-Kombination**; `pruefling_merge.hpp` `MergeAxis` wird von EINEM hart-codierten Pruefling auf beliebige generalisiert (Umverdrahtung, kein Neubau).

### Offene Punkte in Datei 14
- Alle 20 Achsen PARTIAL (14:3363) - der gesamte Rest baut darauf auf.
- R5.C.2 Pruefling-Slots fuer prt-art fehlen; R5.C.3 Cross-Constraints fuer queuing (Q-EPOCH+F-EAGER etc.) offen (14:3384-3385).
- R6.B/R6.C (ABI-Container-Ops, MeasurementResult, Welch-t-Test, CSV-Report) offen (14:3330-3343).
- 17->19 Achsen-Umstellung im Code/Body offen (14:3474).
- Metapher-Cleanup V41.Z.1 / Task #704 offen (14:2073-2084).
- `docs/bausteine/` Neuerstellung mit Organ-Taxonomie offen (14:3396-3397).
- Doku 11 §11.7.E-Q (13 weitere Topics), Doku 13 Teil E, Doku 10 §0.4 offen (14:3387-3394).

---

## (a2) 15_F7_mess_frameworks_workloads_2d_matrix_plan.md - dichte Zusammenfassung

Charakter: **reines Planungsdokument**, ausdruecklich kein Code-Increment, keine Modul-Neuanlage (15:3). Grundlage der #31-Folgearbeit.

### Bindende Rahmen-Invarianz (15:5)
"rein additiv, golden/ABI-neutral, INV-1..4-treu" - definiert die 2D-Achsen und **legt den Struktur-Fork offen, nimmt KEINE Realisierung vorweg**. `comdare-measurement-all` (metrics/pmc/workloads), Pipeline 286 und der ce-Monolith bleiben unberuehrt bis zu einem konkreten Realisierungs-Increment (eigene Kadenz, ggf. User-GO).

### §0 E-Ebenen-Korrektur (2026-07-09, additiv, AUTORITATIV; 15:7-16)
Der wichtigste Abschnitt der Datei - er ordnet die zwei Achsen ebenen-richtig ein:
- **Achse M (Mess-Kategorien) = compile-time, E0/Tooling** = measurement-all-Modul-Interna. Option A ist hier korrekt und golden-orthogonal, **keine Binary-Identitaets-Achse** (15:12).
- **Achse W (Workload x Dataset) = E4-XML-definiert + E1-Laufzeit (`DynamicVariableNode`) + E3-Permutation (Dataset als CEB-"4. Dimension")**. Ausdruecklich **NICHT compile-time-statisch in der ce-Library**. Beleg Ledger `:371`: Mess-INPUT ist DynamicVariableNode-Seite des experiment_tree, **`permutation_axes.xml` bleibt TABU** (15:13).
- **Dritte Dimension A/B/C x Micro/Makro/Gesamt = E4-Auswertung** (Spalten-Projektion in CSV/LaTeX), **niemals `mp_product`-Lauffaktor** (15:14).
- **Benannter Fehlbau #31** (15:16): der committete ce-`workload_matrix.hpp` mit `mp_product<..., ycsb_profile_list, dataset_list>` = 36 compile-time-Zellen in der Library (E2) verwechselt W mit einer Binary-Achse. Korrektur = **G2-Revert + E4-XML-Verortung** (Dossier 16 Teil D). Die measurement-all-Realisierung bleibt **gated hinter Migrationsplan-Schritt 13**.

### §1 Ist-Struktur (verifiziert; 15:18-29)
`comdare-measurement-all` ist heute **strikt 1D-Baseline-Schichtung**, je Stufe genau eine Zelle, INV-2-konform `n->n-1`:
- `baseline_0-core` = `comdare-metrics` (IMeasurementObserver, Counter/Gauge/Histogram/Summary, HDR/latency_stats)
- `baseline_1-instrumentation` = `comdare-pmc` (IPmcSource, Linux-perf / Windows-PCM, compile-time Factory)
- `baseline_2-workloads` = `comdare-workloads` (YCSB-Kern, Driver, Dataset-Registry - gebuendelt)
- `baseline_3-analysis` = nur vorgesehen, leer/kein Ordner
Befund (15:29): die Achsen dieser Schichtung sind Mess-BELANGE, nicht Framework x Workload; eine 2D-Matrix existiert nicht, der ce-Ort `libs/cache_engine/builder/measurement_matrix/` ist ein **leeres Skelett**.

### §2 Die zwei Achsen, autoritativ aus der Thesis (15:31-39)
- **M**: Cache-Line-Auslastung, Cache-Misses L1/L2/L3, dTLB-Misses, Speicher-Fussabdruck, Branch-Misses, IPC/CPI, Latenz, Durchsatz, Energie; Zweiteilung zeit-/observer-basiert (beide OS-Regimes, `metrics` b0) vs. **zaehlerbasiert PMC (nur privilegiertes Regime, `pmc` b1)** (15:33-35).
- **W**: Benchmark-Frameworks werden per Thesis-Direktive **zu einem gemeinsamen Satz von Lastprofilen abstrahiert**: YCSB **A/C/E** gekreuzt mit dem **6er-Datensatz-Kanon** url/dna/protein/xml/tpcds-id/trec-terms (#25); Thesis-Wort "der Workload als dynamische Achse" (15:37).
- Dritte Dimension nur der Vollstaendigkeit halber (15:39).

### §3 Struktur-Fork (offener Architektur-Entscheid; 15:41-49)
- Option A: 2. Dimension als compile-time-Parametrisierung IN den Zellen (F6-Kopf-Framework je Thema); golden/ABI-neutral, keine Zell-Explosion, Baseline-Kette `workloads->pmc->metrics` unveraendert (15:45).
- Option B: je Workload-Profil / je Kategorie ein eigenes Modul -> Zell-Explosion M x W, hoher Overhead (15:46).
- Option C: getrennte Familien-Achse -> bricht die eine measurement-all-Familie, widerspricht F14-Mapping (15:47).
- **Empfehlung Option A** mit 4 Begruendungen (F6-Doktrin, Thesis-Wortlaut "dynamische Achse", golden/INV-Treue, Praezedenz `pmc_source_factory` + ce-16-`MeasurementCategory`) (15:49). Option B nur mit eigenem Struktur-GO + INV-2-Ketten-Design.

### §4/§5 Ziel-Skizze und Roadmap (15:51-66)
- `workloads(b2)`: Kopf-Interface `comdare::workloads::matrix` ueber Profile x Dataset; `tab:workload-routing` als `constexpr`-Map; **Default = heutiger Pfad, bit-identisch** (15:55).
- `metrics(b0)`/`pmc(b1)`: `MeasurementCategory` als compile-time-selektierbare Kollektor-Menge, **Regime-Gate (privilegiert vs. immutable) als Achsen-Merkmal** (15:56).
- `baseline_3-analysis`: erst bei Bedarf; **Validation bleibt AUSSERHALB** (15:57).
- Roadmap 4 Schritte; Schritt 4 **GATED hinter Migrationsplan-Schritt 13**: Diplomarbeit konsumiert `measurement-all` statt ce-Kopie (15:66).

### §6 Tabus / Invarianten (15:68-70)
INV-1 Baseline haargleich; INV-2 `n->n-1`, keine Aufwaertskanten; INV-3 Produkte->Produkt-Baselines; **INV-4 Verstoesse = Link-Blocker, nie Workaround**. Keine Zell-Explosion ohne User-GO. measurement-all-Zellen + Pipeline 286 + ce-Monolith unberuehrt. **Metaprogrammierung compile-time (Concepts/`if constexpr`/Factory), kein runtime-switch.** `golden_fullpilot_320` / conformance-Oracle / ABI-4 unberuehrt (Mess-Matrix ist orthogonal zur Anatomie-Permutation).

### Nachtraege 2026-07-15 (15:72-77)
- **R7 (:76)**: rein bestaetigend, kein Konflikt - Baseline-Layering gewahrt (Beleg-Zeilen 20, 24-27, 45, 70).
- **R2 (:77)**: **offener Punkt** - additiver Abschnitt noetig, der die runtime-getriebene W-Achse an die E4-Experiment-XML (`DynamicVariableNode`) bindet und offenlegt, WIE Profile enumeriert werden. Caveat: SOTA-Antwort (Doc 17:49) verortet den Workload-Katalog als **Laufzeit-Bibliothek in measurement-all/comdare-workloads, die die ce konsumiert - NICHT in den Anatomie-Registries (R1 = 90 Achsen-Bausteine)**; Katalog referenzieren, nicht duplizieren; ob Workloads ueberhaupt "Bausteine je Achse" sind, **bleibt offen**.

### §59-Querverweis (15:81-83)
KERN-Mess-Schema: **Default = ALLES messen, die XML wirkt als negatives Blacklisting**. Mess-Tooling {Wallclock/Makro/Micro} = **Unter-Achse, compile-time fix in CEB+Tier**; die W-Achse bleibt bewusst runtime (R6-konform). Drei Mess-Stufen: (1) CE allein, (2) je Pruefling `replace`/`merge`, (3) kombiniert `fulljoin`. Volle Fassung im Ledger §59.

### Offene Punkte in Datei 15
- Struktur-Fork A/B/C ist formal **noch nicht entschieden** (nur Empfehlung A, 15:49; §5 sagt "nach User-Wahl A/B/C", 15:61).
- Bruecke W-Achse <-> Unified-Experiment-XML fehlt (R2, 15:77).
- Status von Workloads als Registry-Bausteine offen (15:77).
- `baseline_3-analysis` existiert nicht (15:27, :57).
- G2-Revert des #31-Fehlbaus als Aufgabe benannt, nicht als erledigt (15:16).

---

## (a3) 00_INDEX.md - dichte Zusammenfassung

- **SUPERSEDED-Banner 2026-05-31 (00_INDEX:3)**: "Ueberholter Planungs-/Architektur-Stand (axis-zentrische Restruktur F.2, Plugin-Pruefling-Modell, DLL-F15-Pipeline, sezierte Organe). IST-treue Single-Source-of-Truth: `comdare-cache-engine/docs/ledger-sections/architektur-ziele-offene-punkte-ledger.md` + `.../20260531-e2e-abnahme-audit-und-entscheidungen.md`. **Niemals loeschen - nur Banner.**"
- Stand 2026-05-15, Phase K-C des Masterplans (00_INDEX:5-7).
- Inhaltsverzeichnis listet **nur `01_`..`09_`** (00_INDEX:13-25): REV-Historie, Master REV7.7, Konzepte Saeule A/B, UML, ER, Cross-Reference, drawio, Taxonomien. Total 9 Doks aus 24 Quell-Doks (~9.674 Zeilen).
- **Memory-Direktive (00_INDEX:29-33)**: Original-Quellen unter `../termine/20260508 Termin 7/Phase5_UML_Detail/` bleiben VOLLSTAENDIG erhalten (Doks 00-30); konsolidierte Doks referenzieren nur Pfad+Zeile, kopieren keine Voll-Inhalte.
- REV-Historie REV3..REV7.7 (00_INDEX:37-57); relevant: **REV7 = Custom Allokation (21 Allokator-Paper) + ABI-stabiles C++23-Modul-Interface** (:48); REV7.6 Doc 30 = Drei-Repo-Layer, Diplomarbeit Code/ als Anwender-Schicht (:54) - das ist genau das in Datei 14 als Vorrang gesetzte Doc 30.
- Querverweise (00_INDEX:61-69): Masterplan, Glossar K-D, Bausteine (85 Bausteine + 25 ADRs) K-E, Forschungslandkarte K-F, Termine-Konsolidiert K-G, drawio REV6 (REV7 in Phase K-H), Thesis-Kapitel `../../thesis/chapters/03_architektur.tex` + `04_implementation.tex`.

Offene Punkte: Index ist **stale** - keine Eintraege fuer die Dateien 10..19 (u.a. 14 und 15); drawio REV7 nicht erstellt; Forschungslandkarte "in Arbeit"; Termine-Konsolidiert "geplant".

---

## (b) Querschnitt: HARTE Direktiven und Verbote

Kompositions-/Achsen-Modell
1. Achse = Organ, niemals ein ganzer Algorithmus; ganze Algorithmen nur als Reference-Composition (14:221-228, :245-254, :338-350).
2. Neue Achse nur nach Universalitaets-Check in mind. 3 bekannten Algorithmen (14:230-237).
3. Aequivalenz-Pflicht: zu jeder Reference-Composition muss genau eine Permutation existieren (14:196-207).
4. **Keine Achse ist optional** - fehlende Funktion = konkreter Durchreich-Algorithmus, nie Weglassen (14:40-45, :1166-1178, :1335-1346).
5. Gattung = Interface/Pruef-Dock (Search/Container/Graph); fester Achsen-Satz sitzt auf der Lebewesen-Unterklasse; bei Widerspruch gilt das 3-Ebenen-Modell Doc 30 §8.0 (14:14-54, :51).
6. **Cross-Genus-Merge verboten** - nur gleiche Unterklasse kreuzbar; Pruefling-Slot muss Genus deklarieren; Verstoss = `static_assert`-Blocker; Cross-Genus nur als Mess-Vergleich im CEB (14:1348-1428).
7. AdHocComposition-Slot-Reihenfolge T0..T16 ist Vertrag (14:573-579); kanonische Achsen-Zahl ist 19, nicht 17 (14:47-49, :3474).

Verantwortlichkeits-Trennung
8. Anatomie enthaelt NUR Achsen + Observer + ObserverAggregate + Composition-Inspection. `insert/lookup/erase/clear`, interne Container, Workload-Driver sind in der Anatomie VERBOTEN (14:701-717, :971-977, :3320-3328).
9. PermutationEngine ist nur Anatomie-Generator; Mess-Logik, Binary-Loading, Commands gehoeren in den CEB (14:674-687).
10. Eine PermutationEngine pro Gattung/Unterklasse, per Vererbung spezialisiert (14:1223-1271, :1410-1422).
11. ExecutionEngine ist die Wurzel ueber AnatomyBase; das allgemeine Mess-Interface liegt dort; Viren erben direkt, ohne Achsen (14:1455-1466, :1557-1593, :1700-1706).

Compile-Time / Runtime
12. **Kein Runtime-Switch im Hot-Path; alles statisch determiniert** (14:681, 15:70, 14:3476).
13. Metaprogrammierung compile-time: Concepts / `if constexpr` / Factory (15:70).
14. Ausnahmen von 12/13 sind exakt zwei und explizit gewollt: die vtable-Cold-Start-ABI-Grenze (14:3476) und die W-Achse Workload/Dataset (15:13, :83).
15. Kein Python in der Buildchain; **CEB orchestriert den Tier-Binary-Build zur CEB-Laufzeit C++-seitig, NICHT CMake-per-Permutation** (14:3470).

ABI / Loader
16. ABI = genau 4 extern "C" Symbole; Compat = Major identisch + Modul-Minor <= Host-Minor (14:2111-2118, :2151-2166).
17. Loader-Reihenfolge zwingend: destroy vor dlclose/FreeLibrary; Magic-Check vor Version-Check (14:2315-2339).
18. ObserverAggregate muss POD/standard-layout/trivially_copyable sein; jede Achse erfuellt `ObservableAxis` oder liefert `EmptySnapshot{}` (14:889-934).
19. Pflicht-Lifecycle je Mess-Pass: `warm_up -> run -> reset -> shutdown` (14:2051-2063).

Mess-System / E-Ebenen
20. **Workload/Dataset ist KEINE Binary-Identitaets-Achse; `permutation_axes.xml` ist TABU; W gehoert nach E4-XML/E1-Laufzeit** (15:13).
21. A/B/C x Micro/Makro/Gesamt ist E4-Auswertung, **niemals `mp_product`-Lauffaktor** (15:14).
22. INV-1..4 unverletzlich; INV-4: Verstoss = Link-Blocker, nie Workaround (15:68-70).
23. Keine Zell-Explosion ohne User-GO; measurement-all + Pipeline 286 + ce-Monolith bleiben unberuehrt bis Realisierungs-Increment (15:5, :70).
24. `golden_fullpilot_320` / conformance-Oracle / ABI-4 unberuehrt; Default-Pfad bit-identisch (15:55, :70).
25. Konsum von measurement-all statt ce-Kopie ist GATED hinter Migrationsplan-Schritt 13 (15:66).
26. Mess-Default = ALLES messen; XML wirkt als negatives Blacklisting; Mess-Tooling compile-time fix in CEB+Tier (15:83).
27. CEB-Konfigurationsquelle = eine Experiment-XML (3 Phasen) + 2 Registry-XMLs; `TopicConfigSets` sind nur Uebersetzungsziel des XML-Parsers (14:3472).

Prozess / Doku / Naming
28. **Doku nie loeschen, nur Banner/annotieren**; Verbatim-User-Direktiven bleiben woertlich (14:52-54, :360, :642, :3468; 00_INDEX:3, :29-33).
29. `OriginalXxx`-Wrapper duerfen NICHT geloescht werden - legitime Achsen-Werte (14:567).
30. Code-Identifier technisch, Metaphern nur in Kommentaren/.md; Grep-Audit vor Commit - vollstaendiger Cleanup aber erst V41.Z.1 / Task #704 (14:1734-1848, :2073-2084).
31. Pflicht-Reihenfolge: zuerst Achsen-Stub-Vollausbau, dann prt-art-Einbindung (14:3418-3420).
32. Pre-Read-Pflicht Doku 10 §0-§4 als Wurzel-Modell in jeder Architektur-Iteration (14:1681-1682).
33. Pruefling-Merge Stufe 2 = ERSETZT-mit-Fallback (nicht extend); Stufe 3 = Union mit `mp_unique` (14:798-846).
34. Reproduzierbarkeit: identische Workload-Sequenz in Reihenfolge und Umfang je Permutations-Binary (14:3216-3222, :3267-3275).
35. Fuer die Dateien 00-09 gilt: IST-treue SSoT ist der Ledger, nicht diese Doku (00_INDEX:3).

---

## (c) Widersprueche

### C1 - Achsen-Zahl 17 vs 19 (innerhalb 14, unaufgeloest im Body)
Body durchgaengig 17 (`organ_count(){return 17;}` 14:732, ObserverAggregate 14:897-905, Tabelle §27.2 14:1156, AdHocComposition T0..T16 14:573). Kopf-Banner (14:47-49) und Nachtrag R9 (14:3474) setzen **kanonisch 19** (inkl. queuing q1/q2, Bezug `axis_stats[19][8]`). Nachtrag sagt ausdruecklich, die Original-Signaturen werden nicht ueberschrieben -> der Konflikt ist bewusst offen und trifft jeden Code, der `organ_count()` oder die Snapshot-Arity nutzt. **Autoritativ: 19.**

### C2 - Binary-Bau: CMake-per-Permutation vs CEB-Laufzeit-Orchestrierung (innerhalb 14)
§17.3 (14:744), §21 (14:938-946), §45 (14:2193-2220), §47 (14:2423-2461), §48.5 (14:2591-2613), §51 (14:2903-2998) beschreiben eine vollstaendig gelieferte, getestete CMake-/configure_file-/execute_process-Pipeline mit einem .so/.dll je Composition. Nachtrag R4 (14:3470) erklaert genau diese Strategie fuer **abgeloest**. Die Alt-Pipeline ist aber real gebaut und mit 191+ Tests gruen dokumentiert -> Konflikt zwischen dokumentiertem Ist-Code und kanonischer Soll-Direktive. **Autoritativ: R4/CEB-Laufzeit.**

### C3 - Anatomie ohne Container-Ops vs ABI/R6.B mit Container-Ops (innerhalb 14)
§17.2/§24 verbieten `insert/lookup/erase/clear` und einen internen `std::map` in der Anatomie ausdruecklich als "FALSCH" (14:701-717, :971-975). §17.3 (14:756-772) und R6.B (14:3332-3337) fuehren genau `comdare_insert/lookup/erase/clear` als extern "C" ABI-Symbole ein und geben dem `SearchAlgorithmAbiAdapter` einen internen `std::map` als Pilot. Formal aufloesbar (Adapter/Builder-Schicht statt Anatomie-Klasse), aber der Adapter ist Teil des Anatomie-Moduls - **Grenze ist nicht sauber gezogen und muss explizit entschieden werden.**

### C4 - Workload-Konfiguration: C++-Struct vs E4-XML (14 gegen 15)
14 §53 definiert `WorkloadConfig` als C++-Struct mit 4 hart kodierten Prozent-Profilen (insert_heavy/lookup_heavy/mixed_a/mixed_b, 14:3252-3300). 15 §0 (:13) und §2 (:37) legen fest: W = **E4-XML-definiert + E1-Laufzeit**, kanonisch **YCSB A/C/E x 6er-Dataset-Kanon**, Enumeration ueber `DynamicVariableNode`. 14s Profile sind weder der YCSB-A/C/E-Kanon noch XML-gesteuert, und der Dataset-Faktor fehlt ganz. **Autoritativ: 15 §0 + Experiment-XML.**

### C5 - Genus-/Modus-Wahl per CLI-Flag und CMake-Define vs "nur ein XML-Programm"
14 §29.3 (`argv[1]` genus, 14:1275-1286), §32.7 (`cmake -DCOMDARE_GENUS=mammal`, 14:1424-1428), §48.3 CLI-Flags (14:2554-2563) und §5/§17.3 "3-Stufen-Auswahl als CLI-Flag" (14:753) etablieren Steuerung ueber CLI/CMake-Defines. Nachtrag R3 (14:3472) und 15 §0/§59 (15:13, :83) etablieren die Experiment-XML + 2 Registry-XMLs als alleinige Konfigurationsquelle. **Autoritativ: XML.**

### C6 - "kein runtime-switch" (15:70) vs "W-Achse bewusst runtime" (15:13, :83) - innerhalb 15
§6 formuliert das Verbot pauschal fuer die Mess-Matrix; §0 und der §59-Nachtrag verlangen die W-Achse ausdruecklich runtime. Aufloesung ergibt sich aus 14:3476 (Hot-Path compile-time, W/D runtime), ist aber in 15 §6 nicht nachgezogen -> **Formulierungs-Widerspruch, inhaltlich per R6 geklaert.**

### C7 - Mess-/Telemetrie-Ort: ce-Anatomie vs measurement-all
14 verankert Telemetrie/Observer als Organ-Achse in der ce-Anatomie (axis_11, ObserverAggregate, 14:889-934) und baut Welch-t-Test/Reporting im CEB (14:752, :3339-3343). 15 verortet den Mess-Kern in `comdare-measurement-all` (metrics/pmc/workloads) und sagt, die Diplomarbeit soll measurement-all **statt der ce-Kopie** konsumieren - **gated hinter Migrationsplan-Schritt 13** (15:20-27, :66, :77). Solange das Gate zu ist, existieren zwei Mess-Stacks parallel; die Zuordnung Achsen-Observer (ce) vs Kategorien-Kollektoren (measurement-all) ist nicht abschliessend geschnitten.

### C8 - Analyse/Statistik-Verfahren: Welch-t-Test vs Mann-Whitney-U/Holm/Cliff's delta
14 nennt durchgaengig Welch-t-Test als Auswertungsverfahren (14:474, :752, :3202, :3341). 15:57 nennt fuer `baseline_3-analysis` Median/Perzentile, **Mann-Whitney-U/Holm, Cliff's delta**. Unterschiedliche statistische Doktrin, nirgends abgeglichen.

### C9 - Permutations-Skalierung vs Dataset-Dimension
14:513-514 rechnet den Permutationsraum ausschliesslich ueber Achsen (576 -> 10^4..10^5). 15:13 fuehrt Dataset als **E3-Permutation / CEB-"4. Dimension"** ein. Ob Dataset die Binary-Zahl multipliziert (E3) oder nur Laufzeit-Input ist (E1), ist zwischen den Dateien nicht konsistent gefasst - 15 sagt gleichzeitig "keine Binary-Identitaets-Achse" (15:13) und "E3-Permutation" (15:13). **Innerhalb einer Zeile spannungsgeladen, klaerungsbeduerftig.**

### C10 - 00_INDEX ist stale und sein Geltungsbereich unklar
Der SUPERSEDED-Banner (00_INDEX:3) steht als Kopf des Verzeichnis-Index und nennt u.a. "DLL-F15-Pipeline" und "sezierte Organe" als ueberholt - beides ist exakt das Thema von Datei 14. Datei 14 (2026-05-26/27 + Nachtraege bis 2026-07-20) und Datei 15 (2026-07-09 ff.) sind aber **juenger** als der Banner (2026-05-31) und im Index gar nicht gelistet (00_INDEX:13-25 fuehrt nur 01..09). Es ist damit formal unentscheidbar, ob der Banner fuer 14/15 gilt. Praktische Lesart: der Banner betrifft nur 01..09; 14/15 tragen eigene, juengere Autoritaets-Marker. **Der Index muss um 10..19 ergaenzt und der Banner-Scope explizit auf 01..09 eingegrenzt werden.**

### C11 - Thesis-Pfadschema divergiert
00_INDEX:69 verweist auf `../../thesis/chapters/03_architektur.tex` + `04_implementation.tex`; 15:4 verweist auf `thesis/.../kapitel/de/{03_messsystem_prtart,06_evaluation_methodology}.tex` (bilinguale Struktur). Alte vs neue Thesis-Topologie - der Index-Verweis ist tot bzw. veraltet.

### C12 - "stabile Achsen" vs "0 Achsen vollausgebaut" (innerhalb 14)
§7 (14:309-318) markiert axis_06_allocator, axis_q1/q2_queuing, axis_03b, axis_03m als stabil/kein Refactoring noetig. §54.2 (14:3363-3369) stellt fest: **0 Achsen voll ausgebaut, 20 PARTIAL, Algorithmus-Bodies fehlen, Compositions referenzieren Marker-Klassen.** Die spaetere Audit-Aussage entwertet die fruehe Stabilitaets-Tabelle. **Autoritativ: §54.2.**

### C13 - Naming-Doktrin: sofort technisch vs Metaphern behalten (innerhalb 14)
§41.2/§41.8 (14:1734-1744, :1839-1848) machen technische Code-Identifier zur Pflicht mit Grep-Audit vor jedem Commit. §43.6 (14:2073-2084) haelt Metaphern-Identifier bis V41.Z.1 ausdruecklich aufrecht. Ergebnis: `AnatomyGenus`, `Frankenstein*`, `*Mammal*`-Test-Namen bleiben legal, obwohl die Regel dagegen spricht. **Aufgeloest durch Fristsetzung, aber die Grep-Audit-Pflicht ist faktisch ausgesetzt.**