# ERINNERUNG -- Verworfene/geparkte Konzepte fuer spaetere Wiederverwendung (Stand 2026-07-20)

> Gesammelt per Workflow. WIEDERVERWENDUNGS-PRUEFUNG erfolgt SEPARAT NACH dem Gesamtplan, gemeinsam mit dem User per Rueckfragen -- nur einbauen, was §54/§55 nicht widerspricht. Nichts hier ist geloescht; alles bleibt als Referenz.

## Gruppe A -- Auswertungsstufen (Break-Even / Heuristik / Mess-Auswertung) -- HOHE Wiederverwendbarkeit
(je Konzept: Kurzname | wo | warum verworfen | Kern noch valide? | Wiederverwendung | Auswertungsstufe)

**A1 — DLL-Load Option A (-rdynamic / Host-Export des Allokators)** · *Mess-Auswertung*
wo: §0-GOAL-V6, §12 2026-07-17++, §18.4-INC-0 (L1). warum verworfen: Arena-Kontamination N−1→N; bricht Allokator-als-Algorithmus-Achse, RAII-Destroy-Vertrag, self-contained-ABI und H-10; Option B (DLL self-linkt Allokator, RTLD_LOCAL) gewann.
Kern valide? ja (Negativbeleg). Wiederverwendung: Fairness-/Isolations-Argument der Allokator-Achsen-Messung; Warnung vor Cross-Arena-Verfälschung.

**A2 — workload_matrix.hpp (compile-time WorkloadKind-Matrix, mp_product 36 Zellen)** · *Mess-Auswertung*
wo: §12 2026-07-09 G2-Revert, 2026-07-16-Nacht, Voll-Audit F03 (L1). warum verworfen: tote CT-Insel / E2-Fehlbau; Achse W (Workload) gehört als Mess-INPUT nach E4-XML/E1, nicht als Binary-Achse; WorkloadKind→OP-1..6 waren Phantom-Etiketten.
Kern valide? teilweise — Einordnung „Workload=Mess-Input“ deckt §55 exakt (Workloads=Mess-UNTER-Achse des Planers). Wiederverwendung: mp_product-Enumeration/Permutation der Workload-Unter-Achsen im Planer (als Spalten, nicht Binary-Segment).

**A3 — V32-Orchestrator / execute_messreihe / config_a/b/c (Schema-Familie C)** · *Mess-Auswertung*
wo: §15.10-E10 (→§30 SUPERSEDED-Reaktivierung), §29 v32_messreihe_antrieb.hpp:259, v32_orchestrator.hpp:92 (L1/L2/P). warum verworfen: erst als toter Stub/„Irrweg“ zum Rückbau markiert; config_a/b/c=0 C++-Reader, Orchestrator=return-0-Stub. Dann SUPERSEDIERT (19.07.→§30): NICHT rückbauen — v32-Strang (PhaseStrategyFor + execute_messreihe) wird als offizielles Planer-Skelett reaktiviert.
Kern valide? ja — voll implementiert (parse→validate→run→CSV/TikZ), nur nicht angebunden. Wiederverwendung: Planer-Phase-0 (Input umstellen statt Neubau, spart größten Bau-Block); Welch-t-Test-Vergleich SdT-vs-Prüfling (EE-A/EE-B); erweiterte op_type-Semantik OP-1..6 als Mess-Unter-Achse; XSD als Struktur-Vorlage. Rest-Warnungen: F02 (`<mode>` nie konsumiert), F08 (kein MEASUREMENT_ON-Preset).

**A4 — WP-1 Parallel-Mess-Engine (Fork-A-Patch, 507 Zeilen, gestoppt)** · *Mess-Auswertung*
wo: §15.9-Backups 20260716-wp1-parallel-engine-gestoppt-fork-a; fork-a-bruecken-dossier (L1/P/B). warum verworfen: User-STOPP 16.07. („zweite sinnlose parallele Engine“); Patch NIE appliziert, Code deprecatet-inert; verletzt Ein-Weg-Doktrin (Parallelstrecke statt offizieller E4/CEB-Pfad).
Kern valide? teilweise — nur als Konzept-Transfer (nie Datei-Reaktivierung). Wiederverwendung: Debug-Parallel-Mess-Modus (so viele Messungen parallel wie Threads; Mess-Modus bleibt 1-Thread); fail-loud-Fehlerklassen F02/F11/F12 (XML autoritativ, Overrides explizit+geloggt, unbekannte Token Exit 7/8); ehrlicher Dispatch F03 (CSV-Etikett==getriebene Op); injektives key_for(index,seed) als Single-Source Prefill+Mess; CSV→Welch-Konsument.

**A5 — Legacy-Mikrobench V37.C/V38.C + P6-Legacy-Vergleichspfad** · *Break-Even / Mess-Auswertung*
wo: §12 2026-07-13 Two-Day-Sweep B2 + Gate-3-Ablehnungen (L1). warum verworfen: P6-Voll-Entfernung bewusst NICHT durchgeführt (golden-320-Subsumtion unbestätigt → würde Vergleichsfähigkeit zerstören); nur Gating des ungegateten parallelen Mess-Pfads, keine Entfernung (data-gated).
Kern valide? ja — die alt-vs-neu-Referenzmessfähigkeit ist genau, was Break-Even braucht. Wiederverwendung: Alt-Referenzkurve gegen new-golden; Vergleichsbasis nicht vorschnell tilgen.

**A6 — golden==320 (CatalogAxes<4,4,5,4>) als TABU-Referenz** · *Mess-Auswertung*
wo: gesamt-roadmap-ROADMAP §208/212/213; alle Superseded-Blöcke (P). warum verworfen: SUPERSEDED durch new-golden N=2^17=131072 all-axes; 320er harte Neutralitäts-Schranke überholt (alt-golden darf brechen).
Kern valide? teilweise — 320 bleibt als Alias/Snapshot (golden_320_catalog _abi4/_abi5 additiv) und Zwischen-Messung; binary_id-Reinheit trägt unverändert. Wiederverwendung: 320er-Roundtrip als Doppel-Anker neben kNewGolden131072Crc64; 2^17 = einer der 4 Sweep-Stützpunkte {2^14,2^17,2^20,2^23} für Heuristik-Messkurven.

**A7 — Reihe C = 2 Auswertungs-Views (kein 4. MergeStrategy-Enum)** · *Mess-Auswertung / Break-Even*
wo: gesamtkonzept-experiment-DOSSIER:18-23; pruefling_merge.hpp:130-134 (=3) (P). warum verworfen: KEINE 4. Stufe/4. Enum; Reihe C kanonisch = zwei Auswertungs-VIEWS auf denselben serialisierten Baum.
Kern valide? teilweise — View1 (SdT-vs-Prüfling je Stufe, Compiler/ISA/OS NUR Gruppierungs-Schlüssel) + View2 (build-über-Build-Regression, Welch/Holm f15_compare) valide; ABER: Hybrid-Binary ist heute das 4. Ketten-Glied (ABGABE-PFLICHT) — „keine 4. Stufe“ ist dadurch nuanciert. Wiederverwendung: Mess-Auswertungs-Views; binary_id-Reinheit (Tags/Compiler/ISA/OS nie in Identität, nur Ordner/Sidecar/Spalten).

**A8 — Chain-of-Responsibility Selektions-Filterkette (selection_filter_chain / resolve_selection / DOC20-C)** · *Heuristik / Break-Even*
wo: §50, selection_filter_chain.hpp:87, Doc20, experiment-planer-codegen K5 (L2/P). warum verworfen: CoR-Andockpunkt = Dead-Code (0 Prod-Treffer, nur test_d15); nie verkettet gebaut, obwohl Bausteine (best_binary_selector=Strategy+Builder) da.
Kern valide? teilweise — resolve_selection ist Keimzelle der Planer-Resolver-Stufe (löst Registry-ANGEBOT gegen Anwender-XML auf → gebaut/verworfen). Wiederverwendung: run_selection_filter_chain in run_lazy_static_then_dynamic real verdrahten; Break-Even-/Heuristik-getriebene Selektion, welche (Hybrid-)Tier-Binaries gebaut werden (benanntes Pattern, architektur/20).

**A9 — F-SPREAD / Max-Kontrast-Paar-Selektion (INC-G7 / S23 BAND-C)** · *Heuristik*
wo: §29-Entwurf, §52-B12, §41/§32-F2 (L2/P). warum verworfen: HAUPT-Lauf = first-2 (mp_take_c<Enabled,2>), da CRC64-Fixture darauf landete; Max-Kontrast als optionaler, GO-pflichtiger Fork geparkt (für 24./28.07. nicht relevant).
Kern valide? ja — N=2^17 unverändert, nur WELCHE 2 Werte je Achse; Max-Kontrast liefert maximale Wirkungs-Spannweite als beste Heuristik-Stützstellen. Wiederverwendung: N-Voll-Messung ab 01.08. (offener User-Entscheid first-2 vs Max-Kontrast); Katalog-Index-Selektion generalisieren + Fixtures regenerieren.

**A10 — Break-Even-Option 2 (ganze Tier-Binaries hot ans Dock laden)** · *Break-Even*
wo: §32-F8 Punkt 2, §49 (L2). warum verworfen: §49 gab Option 1 (variant in dieselbe Hybrid-Tier-Binary) + Option 3 (Dock-Array + Verdrängung) frei; Option 2 bleibt nur „als Zwischenform implizit“, nicht eigenständig ausgebaut.
Kern valide? teilweise — als Zwischenform zwischen Option 1 und 3 gültig. Wiederverwendung: reaktivierbar, falls Option 1/3 bei komplexen Multi-Break-Even-Übergängen nicht ausreichen.

**A11 — Break-Even-Option 1: std::variant UNBEGRENZT (de-scopt auf limitiert)** · *Break-Even (Hybrid)*
wo: §49, §32-F8-3, SESSION-PLAN-V3:129 (P/B). warum verworfen: variant NICHT für Haupt-Observer-Kommunikation (bleibt statisch IObservableTier/Prüf-Dock); nur LIMITIERT für abweichende Unter-Prüf-Dock-Typen via Abstract-Factory; Grund: kein variant-Bloat auf statischen/Organ-Achsen.
Kern valide? teilweise — der eng-begrenzte Kern ist AKTUELLER Stand (§55). Wiederverwendung: Design-Leitplanke Hybrid-Binary (4. Ketten-Glied): variant/Factory GENAU hier und nur hier; Dock-Array multipler Tier-Binaries + Verdrängungs-Strategie (Speicher-Heuristiken).

**A12 — MeasurementVisitable-Concept (CMD-1-b, auskommentiert-geparkter Block)** · *Mess-Auswertung*
wo: §12 2026-07-06 (609/613), Querschnitt-M CMD-1-b, DOSSIER-267 (ce 2a231cf5) (L1/P). warum verworfen: zunächst GEPARKT (ungenutzt+untestet, Visitor-/Observer-Umbau aktiv); später eingelöst als constrained axis_accept_measurement OHNE AxisCommand-Konjunkt (Konjunkt hätte observe_all gebrochen).
Kern valide? ja (eingelöst). Wiederverwendung: compile-time Mess-Visitor-Slot über die Achsen (Basis wallclock/macro/micro als Mess-Haupt-Achse); Concept-Form v.template visit_observable<>(); Observable* müssen Concept-Member forwarden; if constexpr(ObservableAxis)-gated.

**A13 — S-7 Locking/Concurrency-Achse (Deep-Research + Enumerator-Vokabular + ILockingMode)** · *Mess-Auswertung*
wo: §14/§15, §16 S-7-PLAN, §18.3; s7-locking-observer-research (2-code-ist.md:250-258); prt_art_82_locking_default.hpp (L1/P/B). warum verworfen: Deep-Research-Läufe scheiterten an Modell-Safety-Block; Deprecation-Banner nach 27 min revertiert (Konzept in Schwebe); Registry-Enumeratoren {Optimistic,Pessimistic,LockFree,WaitFree} = Phantom (nur Upgradeable=2 real). User: Research separat mit Opus nach Planungs-Abschluss.
Kern valide? ja — S-7-Pflicht unverändert (Achse in Suchalgorithmen- UND Container-Gattung echt verwenden; alle Gattungen Observer echt ermitteln). Wiederverwendung: Locking/Concurrency-Achse; Break-Even zwischen Concurrency-Strategien; Observer-Echtheits-Audit ALLER Gattungen; Upgradeable=2 (shared→exclusive) als Semantik-Quelle für CRTP-Organ UpgradeableConcurrency; ILockingMode nur deprecaten (nicht rm).

**A14 — Die 7 User-Fork-Entscheidungen (Doc 20 §H) / map<>-Ebenen-Kardinalitäten** · *Mess-Auswertung*
wo: SESSION-UEBERGABE-typsystem-forks-phase6 §4; kardinalitaeten-deep-research-BEFUND (B). warum verworfen: GEPARKT/fork-blockiert — nicht entschieden (nur Empfehlungen, AskUserQuestion tabu → Klartext).
Kern valide? ja — definieren exakt die Kardinalitäten der heutigen Mess-UNTER-Achsen (workload-framework/type/size/operation_type). Empfehlungen (14 Kanon-LP, YCSB als Teilmenge, 13-Framework-Registry, kV3AxisCount=19-ABI) tragfähig. Wiederverwendung: direkte Vorlage für Planer-Definition der Mess-Unter-Achsen; Fork 6 (objective_tag+Pareto-Front) speist Hybrid-Tier-Break-Even-Bildung.

**A15 — SIMD/ISA-Dispatch in Such-/Scan-Kerne (SwissTable-group-match + Option 0 ISA-Routing)** · *Mess-Auswertung*
wo: §12 2026-07-08 (7b-3), go3-hebel-a-dossier:276/279 (L1/P). warum verworfen: Option A (7b-3 als Composition-Slot) golden/ABI-TABU (19-Achsen-Tupel + golden_320 berührt); Option 0 (volles ISA-Routing aller *_scan-Kerne) für GO 3 zu breit. Empfohlen: group_match_mask als static-Methode der ISA-Strategie über bestehenden C::isa-Slot (ABI-neutral).
Kern valide? ja — 16-Byte-Gruppe=128 bit=1 SSE2-Op bleibt valide; passt zum Meta-Meta/Hardware-Haupt-Achsen-Modell (Command-Freigabe). Wiederverwendung: SIMD-Effekt-Messung (simd_iterations/scalar_fallback via organ_observe_isa; Hebel A der Utilization-Lücken K8); volles ISA-Routing nur als separater GO-pflichtiger Umbau mit uint64-Invarianz-Beweisen.

**A16 — P/E-Core Hetero-Dispatch (#270a/G-270a) + Mess-Thread-Pinning** · *Mess-Auswertung*
wo: §12 2026-07-05 AP-13/#247, §16.3-E17, e17-e18-DOSSIER:13 (L1/P). warum verworfen: HeteroCoreDispatch (CPUID 0x1A / GetLogicalProcessorInformationEx) aufgeschoben (ändert verriegelte Plattform-Tests); perm_runner-Pinning live verworfen (Pinning nur in f15); H-2 aktives Pinning geparkt (erst beobachtend ran_on_core_type, Policy=Unpinned). Später §16.3-E17: P/E-Core = separate System-Achse, aber dynamische Unter-Achse unter Hardware (H-1, Doppel-Modellierung mit Scheduling vermeiden).
Kern valide? ja — passt exakt (Haupt=Hardware CT, dynamische Unter-Achsen runtime; prod2-Intel-Baremetal verfügbar). Wiederverwendung: Hetero-Core-Dispatch als dynamische Hardware-Unter-Achse (P- vs. E-Core-Effekt); CorePinPolicy/NoPinPolicy für reproduzierbare single-thread-Messung; aktives Pinning als Folge-Increment.

**A17 — NUMA / page_type / Cacheline Cache-Awareness-Unter-Achsen (B8/B10/F-A/F-B/F-C)** · *Mess-Auswertung / Heuristik*
wo: §51-B8/B10 (→§52 aufgelöst), go4-f-abc-dossier:19/44/187, Doc21 §F.1 (L2/P). warum verworfen: NUMA/Locking NICHT als 7. compile-statische Haupt-Achse (auf modernen Systemen dynamisch) → System-UNTER-Achse unter ISA, an Tier-Binary als Runtime-Variable delegiert; page_type WEDER Unter- noch neue Haupt-Achse (Allokations-Zeit-Eigenschaft; Ist-Code bereits zweigeteilt RAUM=System/DURCHSETZUNG=Organ); F-A/F-B allocator-Verdrahtung + F-C Cacheline-Split design-gated GEPARKT (bis Messkampagne die Allocator-Achse permutiert).
Kern valide? ja/teilweise — F-A/F-B = einzige laut Re-Diagnose legitime noch fehlende axis_12-Organ-Konsumption (numa/page in Pool-Organe, CT-gated); cache-awareness-Pflicht (page_type↔dTLB-Reach/FF3) bestätigt; Line-Größe (Mess) vs Knoten-Breite (Organ, FF2 1–16) = zwei getrennte Unter-Achsen. Wiederverwendung: NUMA-Runtime-Unter-Achse + Allocator-/NUMA-Organ-Verdrahtung für Mess-Kontrast + Heuristik-Kurven; bestehende page_type-Zweiteilung anerkennen+benennen; MAP_HUGETLB GO-pflichtig; Werteset-Abgleich Thesis {32,64,128} vs Code {B64,B128,B256} offen.

**A18 — 48er-Dataset-Katalog (Datasets_Spezifikation.txt / Termin-7-48er-Liste)** · *Mess-Auswertung*
wo: §16-F11, §13.6-Defaults E-D (L1). warum verworfen: 48er VERWORFEN, Thesis-Set (6+2 = tab:datasets) kanonisch; alter Termin-7-Verweis gestrichen.
Kern valide? teilweise — 6+2 kanonisch für golden; 48er-Liste als Reserve-/Erweiterungs-Katalog denkbar. Wiederverwendung: erweiterte Workload-Datensätze über den golden-Kanon hinaus (optionale Mess-Konstellationen).

**A19 — opt_level-Sidecar-Permutationen (-O2/-O3/Ofast); -O2 als stehender Default** · *Mess-Auswertung*
wo: inc2c-OPT-KORRIGIERT:50 (OF-2-Verdikt wf_31c280b8), A1-Ruling (P). warum verworfen: CEB-Default DEPRECATED von -O2 auf Ofast (DefaultOptLevelSubAxis=OptOfastSubAxis, static_assert); -O2 nur transitionaler Signatur-Fallback von make_gpp_compile_fn.
Kern valide? teilweise — persistierte -O2-Reihen bleiben additiv als +opt-Sidecar-Permutation (Messdaten nie löschen), nur nicht mehr Default; Ofast getrennt (nicht-deterministisch). Wiederverwendung: opt_level-System-Unterachse als Mess-Dimension; -O2/-O3/Ofast als Sidecar-Permutationen für Optimierungsstufen-Auswertung.

**A20 — Mess-Achsen-Haupt/Unter-Auflösung (superseded Lesarten §31-A3 + §32-F7)** · *Mess-Auswertung*
wo: §31-A3, §32-F7, §47, §54-T2, §55:2749/2881 (L2). warum verworfen: §31-A3 („measurement_categories = passive CSV-Spalten“) und §32-F7 („Debug/Messen/Release = Mess-HAUPT-Achse“) korrigiert: Mess-HAUPT-Achse ist das TOOLING (Wallclock/Makro/Micro-Observer); die 16 measurement_categories + Rückschrieb-Methoden = delegierte Mess-Tooling-UNTER-Achsen (Planer-gesteuert); Modus (Debug/Messen/Release) = Ablaufmethodik-UNTER-Achse (an CEB delegiert).
Kern valide? teilweise — „binary_id-neutral / keine Auffächerungs-Haupt-Achse“ + Tooling-Effekt (selektiv einkompiliertes Messsystem) bleiben; nur Haupt/Unter-Zuordnung gedreht. Wiederverwendung: measurement_combos_of über Tooling {Wallclock/Makro/Micro} auffächern (N CEB-Strecken); measurement_categories/Rückschrieb als Unter-Achsen verdrahten; CSV-Manifestation bleibt.

**A21 — SOTA/Paper real messen statt spiegeln (Mirror/#211 verworfen)** · *Break-Even*
wo: SESSION-ENDE-15 §56, SESSION-ENDE-20 §1 P3; #211-DOSSIER; store_traversable_search_algo.hpp:16-22 (B/P). warum verworfen: #211 Linear-Mirror-Traversal-Optimierung = BUG (hätte den Spiegel zementiert); SOTA-/Paper-Bäume würden nie real gemessen, golden-320 spiegelt nicht mehr; ersetzt durch #188-4c ELIMINIERUNG (search_organ-Vollentfall). Reine Anti-Lehre: keine Optimierung eines zu eliminierenden Konstrukts.
Kern valide? ja (als Anforderung) — Paper-/SOTA-Algorithmen MÜSSEN real gemessen werden (D-Schritt-4: untergebene Heuristik-Tiere ohne Observer, Wall-Clock gegen alle Permutationen UND Paper-Algorithmen; Paper-Vergleich geht vor). Wiederverwendung: Begründung/Anforderung realer Paper-Vergleich in der Break-Even/Hybrid-Auswertung; Warnung, SOTA nie als Spiegel zu führen.

**A22 — ZeroingStrategy-deallocate-Vertrag-Fix (bewusst nicht aufgenommen)** · *Mess-Auswertung (Warnung)*
wo: §12 2026-07-13 Gate-3-Ablehnungen (wf_1009d16f), #16 (L1). warum verworfen: Fix bewusst NICHT aufgenommen — würde Heap-Crossover reintroducieren.
Kern valide? ja (Negativbeleg). Wiederverwendung: Warnung bei Allokator-Achsen-Semantik (kein Heap-Crossover in Zeroing); relevant bei Interpretation der Allokator-Messung.

## Gruppe B -- Architektur/Achsen-Konzepte (teilweise valide)

**B1 — Re-Root (Anatomie-Wurzel / Mess-Visitor / Runtime-Hierarchie, CMD-1)** · *Sonstiges (Architektur/ABI)*
wo: §3-S5/§13.3/§13.7, §55:2801 (#251/#267), DOSSIER-267:4 (L1/L2/P). warum verworfen: VERWORFEN zugunsten ABI-NEUTRALEM compile-time-Mess-Visitor (Magic .A4./golden-neutral, kein Bump); Mess-Trennung entsteht auf CT-Achsen-Ebene statt durch Herausschneiden aus IExecutionEngine (:108-118 unverändert).
Kern valide? teilweise — neutraler Visitor gewann und ist gebaut; ABER §55 erlaubt jetzt explizit 4→5-ABI-Bump (Hybrid, new-golden, ABI darf brechen) → Re-Root nicht mehr per se tabu. Wiederverwendung: Vorlage für die invasive Variante, falls im koordinierten 4→5-Umbau echte Anatomie-Wurzel-Umhängung (OrganAxis) gebraucht wird; Referenz für ABI-neutrale Visitor-Erweiterung.

**B2 — axis_binding_registry (consteval CT-Binding-Registry, 14/5-Klassifikation)** · *Heuristik/Mess-Auswertung + Sonstiges (Registry)*
wo: §12 2026-07-10, Backup 20260710-axis-binding-registry-VERWORFEN, Doc 20 §I; profile_to_tree.hpp:68-87 (L1/P/B). warum verworfen: GEBAUT→10-Agenten-Review→VERWORFEN, nie committet (3 CONFIRMED: toter cross-layer-Include builder→measurement, Cap-Werte ohne CT-Kopplung/stiller Drift, DOPPELTE WAHRHEIT zur autoritativen is_static-14/5 in profile_to_tree). Selbst revertiert VOR Commit (ce zurück auf 199 ctest).
Kern valide? ja (per Refutation) — validierter Kern KK-1 (Wurzel-Verzweigung Haupt-Achse=CT-statisch vs Unter=laufzeit-steuerbar) ist fork-unabhängige Design-Konstante, direkter Vorfahr §27/§28; RC-POD-5-Feld-Bijektion (cache_traversal→batch_size etc.) als Blaupause „dynamisch im Ziel-Binary“; HAUS-PATTERN Enum+consteval-Array+static_assert-Drift-Guard. Wiederverwendung: Design der dynamischen Mess-/Heuristik-Unter-Achsen im Ziel-Binary (RC-POD-Bindung); in-Binary-constexpr-Gegenstück zu den §28-XML-Registries. NIE erneut als zweite Wahrheitsquelle — nur mit echtem Konsumenten + Producer-Konsistenz-Contract (Anti-Doppelquelle-Abnahmekriterium).

**B3 — Runtime-vtable-System-Achsen (Scheduling/NUMA/Locking/Hardware) + AxisLibraryRegistry-Header (DEPRECATED)** · *Sonstiges (System-Achse/Registry)*
wo: §18-Delta, §12 INC-1c, §26, KAPSELN K10 §280-304, axis_library_registry.hpp:340-380 (L1/P). warum verworfen: DEPRECATED/verwaist/nirgends konsumiert; verletzt no_runtime_switch/compile_time_only; AxisLibraryRegistry von Anfang an nicht gegen die Header geschrieben (Phantom-Enum NumaAffinity, LockingMode-Namen 4/4 falsch, Achsen-ID-Kollision); 4 vtable-Header mit 0 Include-Konsumenten (Widerspruch CRTP-Doktrin). Ersetzt durch compile-time-CRTP-SchedulingSystemAxis (#37).
Kern valide? teilweise — „Scheduling/NUMA/Locking = System-Achse“ valide (CRTP neu gebaut); Wert-Fundus der Namen brauchbar. Wiederverwendung: §28-System-Achsen-Registry (größter Neubau), aber compile-validiert/aus Code abgeleitet, NIE handgepflegte String-Tabellen; Negativbeleg gegen vtable im Hot-Path.

**B4 — Alte SIMD-System-Achsen-Klasse / SimdSubAxis (verwaist, DEPRECATED) + extension_hardware-Migration (opt-j/opt-k)** · *Sonstiges (System/Compiler-Achse)*
wo: §26-F-SIMD, §48:2443, §51-B4 (Fork A), §12 INC-1d, inc2c-OPT-KORRIGIERT:40/41/45 (L1/L2/P). warum verworfen: einzige do_axis_label()=='extension_hardware'-Klasse DEPRECATED; SimdSubAxis.parent zeigt auf verwaisten Knoten; Fork A: ISA-System-Achse neu bauen (Freigabe-Haupt-Achse), alte Version ausbauen (Q3-Pflicht-Schluss); opt-j (HW-Erweiterung-XML) geparkt bis OF-1 (blockiert durch SIMD-Deep-Research S-7); opt-k (MSVC-Symmetrie) POSIX-first zurückgestellt.
Kern valide? teilweise — INC-1d baute aktive 6. Achse ExtensionHardwareSystemAxis (Q2-C: no_extension/avx2/avx512, Flags je Compiler); Prinzip „SIMD als Freigabe-Achse“ lebt im Meta-Meta-Manager weiter. Wiederverwendung: aktiver System-Achsen-Knoten (Meta-Meta per Command von Hardware-Haupt-Achse); Migration env-pilotiert (COMDARE_PILOT_SIMD_POLICY) → XML/Planer-Permutation der march/SIMD-Unterachse; SIMD→GPU-Erweiterung.

**B5 — System-Achsen-XML-Schema-Praezedenz (messreihe_v32 hardware_strategy/scheduling_strategy/compiler_strategy)** · *Sonstiges (System-Achsen-Registry)*
wo: xml-featurespace-KATALOG:174 (A.10 Legacy/Superseded) (P). warum verworfen: SUPERSEDED (Legacy-Fixture behalten); einziger je gebauter Scheduling-/HW-XML-Kanal ohne Nachfolger; von compiler_strategy überlebte nur opt_level.
Kern valide? ja (nur als Schema-Präzedenz, NICHT wiederbeleben) — XML-Struktur-Vorlage für die noch komplett fehlenden System-Achsen-Registries (Scheduling/Hardware/Compiler-Unterachsen family/lto/pgo/target_arch). Wiederverwendung: Aufbau §28-System-Achsen-Registry (Compiler-Achse mit dynamischen XML-Unterachsen); Blaupause Scheduling/HW-Unterachsen.

**B6 — permutation_axes.xml Legacy-Wertedomänen (isa-Domäne + Allocator-16-Familienraum)** · *Sonstiges / Mess-Auswertung (Wertfundus)*
wo: xml-featurespace-KATALOG:171-177 + B10:197 (P). warum verworfen: SUPERSEDED (COMDARE_LEGACY_MESSREIHEN-gated); ids disjunkt zur Registry; Allocator-16-Familienraum existiert NUR im Legacy-XML (offizielle Organ-Achse allocator = 3 Bausteine); isa-Domäne bereits zu target_isa-System-Achse migriert.
Kern valide? teilweise — 16er-Allocator-Wertefundus = offener Entscheid (Enabled*-Nachzug per Vendoring-Doktrin ODER dokumentiert entfallen). Wiederverwendung: potentieller Enabled*-Ausbau der Allocator-Organ-Achse für breiteren Mess-Kontrast; historische Wertedomänen-Referenz.

**B7 — Command-Pattern-Inseln (IStrategyCommand / ICommand / anatomy_*_command, vestigial)** · *Sonstiges (Command-Pattern)*
wo: MASTERPLAN-188-4c:42/51/76/87, DOSSIER-267 I1-I4 (P). warum verworfen: vestigiale Inseln mit 0 Produktions-Konsumenten (V32-Pfad default OFF), je nur 1 Test; durch CMD-1-Basis-Interface subsumiert (Entfernung nur falls wirklich 0 Konsumenten, sonst GEPARKT-Notiz).
Kern valide? teilweise — Command-Pattern-Prinzip lebt in AxisCommand weiter; konkrete Insel-Klassen tot. Wiederverwendung: Command-Pattern für Achsen (Meta-Meta-Achsen per Command-Pattern von Hardware-Haupt-Achse freigegeben); Statistik-/tier_observe_trace-Header unangetastet.

**B8 — #29 Container/Set-Restrukturierung (Set/Sequence als Typen vs Genus; Set als Ebene-2-Genus)** · *Sonstiges (Gattung/Container)*
wo: §12 2026-07-08, §16.3-E18, e17-e18-DOSSIER:19, Doc 37 §5 (L1/P). warum verworfen: GEPARKT (Terminologie-/Struktur-Klärung nötig); Code modelliert Set als Ebene-2-Genus UNTER Container, User-Doktrin map/Sequence/Set=getrennte Gattungen kollidiert mit eingefrorenem 3-Gattung-Modell (ABI/golden-berührend); SetAnatomy=dünne K=V-Projektion, native Set-Semantiken fehlen.
Kern valide? teilweise — §54/§16.3-E18: Ebene-1 = 4 Gattungen inkl. Set-Promotion (F1b GEWÄHRT, MAJOR); Gattung=Tier-Binary-Interface. Wiederverwendung: Container-Gattung Set (Interface-Familie) bei User-GO; Vokabular-Brücke Gattung(Interface) vs. Genus(Ebene-2).

**B9 — 234-V Shaped-Emission / B+-Baum Shape-Materialisierung (Option A per-Source vs. B CMake-Rebuild) + binary_id-Shape-Segment** · *Sonstiges (Tier-Build-Array)*
wo: §12 2026-07-06/2026-07-10 E2, §13.10-234V, adhoc_emitter (L1/L2). warum verworfen: GEPARKT als echter Architektur-Fork (Eskalationsregel); Kette Baum→DLL reißt (adhoc_emitter webt nur 19 Slot-Typen; organ_for einarmig; T22-T25/page_type/simd weben nichts in perm-Source). SHAPED-Adapter-Seite existiert, Emitter-Verdrahtung geparkt; User-GO liegt, Bau als eigener Increment geparkt.
Kern valide? teilweise — Shaped-Pool-Varianten (btree_order etc.) bleiben valides Materialisierungs-Konzept; golden-320 default-OFF-geschützt. Wiederverwendung: Tier-Binary-Varianten-Materialisierung; binary_id-Shape-Segment für Baum-Zerlegung; potenziell für Hybrid-Binary-Rekombination (variantenreiche Pool-Familien).

**B10 — Planer↔CEB: „Kein Rückkanal“ revidiert + ExperimentSubtreePayload (Struktur+Test-only)** · *Sonstiges (Planer↔CEB)*
wo: §38-REVISION, §52-B14, §55:2781 (L2). warum verworfen: „EINDIMENSIONAL/kein Rückkanal“ überholt — Planer erhält sparsen Fortschritts-/Cursor-Rück-Kanal (Delta-only, KEIN Mess-Daten-Rückfluss) für Sequenzierung (§38.b Mess-Exklusivität); ExperimentSubtreePayload = POD+R5-Serialisierung+Byte-Roundtrip erfüllt, aber NICHT im Kettenlauf genutzt (Director emittiert Achsen-Ranges über SEPARATEN Pfad :485).
Kern valide? teilweise — asymmetrische Nutzlast (hinab serialisierte Teilbaum-Ranges) bleibt; nur „kein Rückkanal“ revidiert. Wiederverwendung: Payload real emit/parse verdrahten statt separaten Range-Emit-Pfad (sonst deprecaten); Rück-Kanal = Voraussetzung für Ein-CEB-Sequenzierung im Mess-Vollzug.

**B11 — System-/Mess-Achsen-Algorithmus-Join (deprioritisiert)** · *Sonstiges*
wo: §30 (Join-Modi-Scope), §55:2798 (L2). warum verworfen: Organ-Join JETZT gebaut (3 Stufen); Algorithmus-Join für System-/Mess-Achsen nach hinten geschoben (nach Ergebnisse/Abgabe), als getracktes späteres Increment (nicht still fallen gelassen).
Kern valide? ja — konzeptionell identisch zum Organ-Join, nur zeitlich deprioritisiert. Wiederverwendung: nach Abgabe System-/Mess-Achsen-Join analog zu den 3 Organ-MergeStrategy-Stufen ausbauen.

**B12 — Option A: Byte-Arena / search_algo flachpressen** · *Sonstiges*
wo: SESSION-ENDE-15 §3/§56 (B). warum verworfen: endgültig VERWORFEN — search_algo ist NIE flach (Dimension inhärent hierarchisch, Knoten-Graph); „flach“ war Fehlframing; plain std::vector verstößt gegen Thesis-Kern (Kontrolle über cache-aware alignment).
Kern valide? teilweise — flache Repräsentation nur für Array/flache Container native Anatomie (Array=flach, Tree/Trie/Hash=hierarchisch); als Universalform verworfen. Wiederverwendung: flacher Store = native Anatomie der Array-Gattung/-Achse innerhalb des SearchAlgorithm-Achsen-Satzes.

**B13 — Option B: ObservableComposedContainer + honest-0-Storage-Achsen (de-scopt)** · *Sonstiges*
wo: SESSION-ENDE-15 §56 (B). warum verworfen: als Zwischenschritt de-scopt (search_organ_ raus via ObservableComposedContainer, Storage-Achsen noch Spiegel/honest-0); ZIEL = native <N,L,A>-Pool-Container via Container-Achse.
Kern valide? teilweise — ObservableComposedContainer als Observable-Wrapper-Fassade bleibt gültig (Observable* forwarden Concept-Member); honest-0/Spiegel-Storage überholt (native Pool-Container). Wiederverwendung: Wrapper-Fassaden-Muster in der Organ-Achsen-Komposition; honest-0-Platzhalter als Fallback bis native Stores gebaut.

**B14 — Geplanter 4→5-ABI-Bump für ContainerObserver (§3-S6/#252-CMD-2, #268-Sidecar)** · *Sonstiges (ABI)*
wo: §55:2801, #268 (L2). warum verworfen: ContainerObserver als E2-Sidecar via #268: RESERVE-REICHT (0 POD-Spalten nötig) → KEIN 4→5-Bump; geplanter Bump vermieden.
Kern valide? teilweise — Sidecar-Lösung valide; Bump-Plan obsolet. Wiederverwendung: Muster additive Sidecar-Lösung ohne ABI-Bump (Messdaten-erhaltend); Referenz bei künftigen Observer-Erweiterungen.

## Gruppe C -- Infra/Bau/Storage (Behelfswege, Alt-Versionen)

**C1 — W11 async-Push (pauschal) → getrennt** · *Mess-Auswertung / Storage*
wo: §52, §53 W11-Trennung, §55:2881 (L2). warum verworfen: pauschale „W11 verworfen“-Notiz ersetzt durch verbindliche Trennung: async NUR für Erstellung/Upload der Binary-Artefakte auf minio.comdare.de (FREIGEGEBEN+PFLICHT, Bau-Durchsatz); git-Push UND Mess-Rückschrieb-Sink bleiben SYNCHRON (Storage-Naht-Doktrin, I/O-Contention=Messfehler).
Kern valide? teilweise — async-Binary-Upload-Kern lebt weiter (S14); async-git-Push/Sink bewusst verworfen (Mess-Korrektheit). Wiederverwendung: Storage-Strang S14 async Binary-Upload aktiv; verworfene async-Sink-Idee als dokumentierte Nicht-Option (warum synchron zwingend).

**C2 — Statische 24-Zellen-CI-Matrix / COMDARE_STATIC_MATRIX_FALLBACK (DEPRECATED)** · *Sonstiges (Infra/Bau)*
wo: §40.b (W4-Pilot), §45 (GATE-SWAP), §46 (L2). warum verworfen: handgeschriebene opt×simd-Matrix war „erfolgreicher Pilot“, abgelöst durch dynamische CE-gesteuerte 3-stufige Legenden-Kette (planer:delegate); läuft nur noch mit COMDARE_STATIC_MATRIX_FALLBACK=true, DEPRECATED (nie löschen).
Kern valide? teilweise — als Pilot-Beleg der Routing/Locking/Dedup-Maschinerie valide; als Ziel-Steuerung überholt (Steuerung im Planer/CEB). Wiederverwendung: Fallback-Bau-Pfad + Referenz für Zellen-Routing/resource_group-Locking-Mechanik; Rückfall falls dynamische Kette bricht.

**C3 — POSIX-Copy / NAS-SMB-Behelfsweg (copy_results_to_nas.sh, POSIX-NFS-Mount, Ebene C)** · *Sonstiges (Mess-Infrastruktur)*
wo: §44.7, Verortungs-Brief F2-3, gesamt-roadmap ST-6:96 + D-Liste:229, storage-two-cache-BAUPLAN (L2/P). warum verworfen: unmarkierter Behelfsweg neben dem EINEN measure-drop-Pfad; POSIX-copy SUPERSEDED durch User-Entscheid A (18.07.): measure-drop HTTPS-PUT mit Basic-Auth (401-Fix 95a6556d/0-Fix), KEIN POSIX/SMB-Mount. DEPRECATED-Marker + Verweis (nicht löschen).
Kern valide? nein (als Transport-Weg) — measure-drop HTTPS-PUT kanonisch. Wiederverwendung: nur deprecatete Historie; Mess-Ergebnis-Rückschrieb läuft über measure-drop-Pipeline (Token id=54, INERT, [skip ci]).

**C4 — Storage-Routing Ebene B/C (prod-MinIO V91 + #72-Kopplung)** · *Sonstiges (Storage)*
wo: §24.F-Routing, §31-A4, KORRIGIERT §51-B5/B6, §55:2881 (L2). warum verworfen: §51-B5/B6 korrigiert auf Verortungs-Brief: Ebene B = dev-V90, Ebene C = prod-NFS-V91 reaktiviert; #72-Kopplung gestrichen; measure-drop-Rückschrieb-Naht als offene Storage-Zeile.
Kern valide? teilweise — Ebenen-Konzept bleibt, nur V90/V91-Zuordnung + #72-Kopplung revidiert. Wiederverwendung: Storage-Aktivierung ab 01.08. mit korrigiertem Routing dev-V90 / prod-NFS-V91.

**C5 — Modul-Migration Schritt-13 (Mechanismus supersediert)** · *Sonstiges (Bau/Modul)*
wo: §52-B15 (Auflage b), LED:1209 BLOCKER, §55:2907 (L2). warum verworfen: Schritt-13 im MECHANISMUS supersediert — die Diplomarbeit konsumiert Module über eigene Research-Matrix-Instanziierungs-Zellen (§9), nicht über den alten Migrationsweg; additiver Doku-Nachzug/Neuschnitt vor G8/G9.
Kern valide? teilweise — Migrations-Ziel (funktionale Kategorien) bleibt, Konsum-Mechanismus ersetzt. Wiederverwendung: measurement-all-Modul-Migration (Projektende, geparkt) via Research-Matrix-Instanziierungs-Zellen.

## Gruppe D -- Vermutlich obsolet (widerspricht aktuellem Stand -- nur zur Vollstaendigkeit, niedrige Prioritaet)

**D1 — std::variant-Baustein-Insel-Triade (algorithm_baustein / baustein_variants / resolve_baustein)** · *Sonstiges / Heuristik(Hybrid)*
wo: §25/§22/§23.D, §12 #52-variant-Bloat, §55:2787, test_abi_interface.cpp (L1/L2). warum verworfen: selbstreferenzielle test-only-Insel (nur test_abi_interface.cpp konsumiert, nicht im Live-Codegen); durch Achsen-Wahl (Enabled*-Generator, statischer Dispatch) ersetzt; §23-Quarantäne + HotPathIsVariantFree-Guard gesetzt; widerspricht §23-variant-Verbot für statische Achsen.
Kern valide? nein (als Insel) — DEPRECATED-Markierung + test_abi_interface.cpp auf Achsen-Wahl umstellen (TEIL, niedrig) noch offen. Wiederverwendung: abschreckendes Anti-Muster für die Umstellung variant-Dispatch→statische Achsen-Wahl; das Pattern selbst lebt NUR noch als A11 (limitierter variant für Hybrid-Unter-Prüf-Docks via Abstract-Factory), NIE Live-Hot-Path.

**D2 — W10-B alte Lesart (Mess-Achsen-Zuordnung)** · *Mess-Auswertung*
wo: §52-B12 („NICHT übernommen“), 20260720-mess-achsen-§47-fundstellen-W10B-REFERENZ (L2). warum verworfen: explizit „NICHT übernommen“ — widerspricht §47 (schnitt measurement_categories/Modi anders).
Kern valide? nein — widerspricht §47/§54-T2-Auflösung. Wiederverwendung: nur historische Fundstellen-Referenz für die additive §47-Doku-Korrektur widersprechender Docs (Doc 23/Doc 16).

**D3 — Alte Mess-Achsen-Zuordnung in Doc 23 / Doc 16 („16 Kategorien=Hauptachsen“, „Mess hat KEINE Unter-Achsen“)** · *Mess-Auswertung*
wo: §47-DOKU-NACHZUG, §48:2480 (L2). warum verworfen: trägt die alte Zuordnung, die §47/§54-T2 widerspricht (Mess-Tooling=Haupt; measurement_categories/Ablaufmethodik/Workloads/Rückschrieb=Unter; 16-Kat=CSV-Spalten-Manifestation).
Kern valide? nein — durch §47/§54-T2 additiv korrigiert (Doku nur deprecaten, nicht löschen). Wiederverwendung: additive §47-Doku-Korrektur; historische Referenz für die Mess-Achsen-Terminologie-Evolution.

**D4 — „Gattungs-Achsen“ / „B+-Baum pro Gattung“ (Fehlbenennung)** · *Sonstiges (Terminologie)*
wo: §15.10-D, §30 (E3), KORRIGIERT §54-T1/T4, §55:2746/2747 (L2). warum verworfen: §54-T1: „Gattung“ = NUR Tier-Binary-Interface, NIE eine Achse; es gibt KEINE Achsen-Gattungen, sondern Achsen-TYPEN (Organ/System/Mess); T4: Permutations-Baum je ACHSEN-TYP, nicht „pro Gattung“.
Kern valide? nein (als Terminologie) — die Sache (Baum je Achsen-Typ, Gattung=Interface) bleibt. Wiederverwendung: durchgängige Terminologie-Korrektur in Thesis-Text + Doku (Achsen-TYP für Achsen, Gattung für Tier-Interface).

**D5 — Bauplan Phase 2 „CEB bestückt mit System+Mess-Achsen“ / Mess-Permutation in der CEB** · *Sonstiges*
wo: §30 (Punkt 5 revidiert), Bauplan-Korrektur (L2). warum verworfen: ÜBERHOLT — Mess-Achsen gehören zum PLANER, nicht zur CEB; Mess-Permutation wandert von CEB in Planer → Stufen-Zuordnung Planer=Mess / CEB=System / Tier=Organ; Planer→CEB-Nutzlast = Messsystem-Wahl (CEB messsystem-HART kompiliert).
Kern valide? nein — alte CEB=System+Mess-Zuordnung ersetzt. Wiederverwendung: Referenz für die Stufen-Zuordnung; Dock-Mirror-Struktur strukturell wiederverwendbar, Nutzlast neu (Messsystem-Wahl).

**D6 — test_data_sets.xml Doppelquelle (DEPRECATED)** · *Sonstiges*
wo: §15.4-Dataset-Doppelquelle, §48/§55:2879 (L2). warum verworfen: konkurriert mit der kanonischen Dataset-Quelle; als Doppelquelle zu deprecaten + Single-Source-Konsolidierung.
Kern valide? nein (als Doppelquelle) — Inhalt in Single-Source überführen. Wiederverwendung: Datensatz-Akten-Konsolidierung, Inhalte in die kanonische tab:datasets-Quelle mergen.

## Offene Rueckfragen fuer die spaetere gemeinsame Durchsicht
(Liste der Punkte, bei denen der User entscheiden muss, ob/wie wiedereingebaut wird -- jeweils erst gegen §54/§55 pruefen)

1. **N-Voll-Messung ab 01.08. (A9):** first-2 (mp_take_c) beibehalten ODER Max-Kontrast-Paare (F-SPREAD/INC-G7)? Katalog-Index-Selektion generalisieren + Fixtures regenerieren. Prio niedrig, post-Abgabe.
2. **Break-Even Option 2 (A10):** Zwischenform (Tier-Binaries hot ans Dock) reaktivieren, falls Option 1 (variant) / Option 3 (Dock-Array+Verdrängung) bei Multi-Break-Even-Übergängen nicht ausreichen?
3. **axis_binding_registry (B2):** mit echtem Konsumenten (Kurven-Fit/Filterkette) + Producer-Konsistenz-Contract wiederbeleben, ODER profile_to_tree bleibt alleinige Single-Source? (golden-sensitiver Increment; Anti-Doppelquelle-Kriterium verpflichtend.)
4. **234-V Shaped-Emission (B9):** Option A (per-Source-Emission + binary_id-Shape-Segment) als eigener Increment bauen? User-GO liegt, Bau geparkt; relevant für Hybrid-Rekombination.
5. **#29 Set als eigene Gattung (B8):** GO-pflichtiger MAJOR-Ausbau (ABI/golden-berührend, native Set-Semantiken) — wann/ob? (F1b bereits gewährt.)
6. **ExperimentSubtreePayload (B10):** real im Kettenlauf verdrahten (emit/parse statt separatem Range-Pfad) ODER als Dead-Code deprecaten?
7. **S-7 Locking/Concurrency (A13):** Deep-Research separat mit Opus nach Planungs-Abschluss; UpgradeableConcurrency als CRTP-Organ bauen; Observer-Echtheits-Audit ALLER Gattungen terminieren.
8. **NUMA + page_type + Cacheline (A17):** NUMA als System-Unter-Achse unter ISA bestätigen (S11 ultracode-Verifikation); F-A/F-B Allocator-/NUMA-Organ-Verdrahtung freigeben (Wiedervorlage sobald Messkampagne die Allocator-Achse permutiert); MAP_HUGETLB-Aktivierung GO-pflichtig; Werteset-Divergenz Thesis {32,64,128} vs Code {B64,B128,B256} auflösen.
9. **Allocator-16-Familienraum (B6):** Enabled*-Nachzug per Vendoring-Doktrin für breiteren Mess-Kontrast ODER dokumentiert entfallen?
10. **Volles ISA-Routing aller *_scan-Kerne (A15, Option 0):** separater GO-pflichtiger Umbau mit uint64-Invarianz-Beweisen für echte funktionale Achsen-Kante (Hebel A)?
11. **P/E-Core aktives Pinning (A16, H-2):** von beobachtender Phase (ran_on_core_type/Unpinned) auf aktives Pinning als Folge-Increment umstellen?
12. **variant-Baustein-Insel + test_abi_interface.cpp (D1):** DEPRECATED-Markierung + Umstellung auf Achsen-Wahl jetzt (klein, niedrig) oder gesammelt später?
13. **48er-Dataset-Katalog (A18):** als optionalen Erweiterungs-Katalog über den golden-Kanon (6+2) hinaus reaktivieren?
14. **opt_level-Sidecar (A19):** -O2/-O3/Ofast als getrennte Sidecar-Permutationen der Optimierungsstufen-Auswertung führen (Ofast bleibt Default, -O2-Altreihen additiv erhalten)?
