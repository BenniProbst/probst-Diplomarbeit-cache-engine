# LENS f5-pruefstand-tests — Einlese-Bericht (05.08.2026)

Auftrag: FRAGE 5 / PRUEFSTAND-DOKTRIN. Owner heute (mittag-1): "Absolut NEIN" zum std::map-Oracle allein.
Korpus: SSOT-Ledger, Bauplan 20260719, Kette-Audit 05.08. (backups/20260805-planer-ceb-kette-audit/), V5-Architektur-Docs, Session-Docs, 982er-Anker, Chunk-Delta, Memories. Alle Zitate mit datei:zeile.

Abkuerzung: LEDGER = docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md; ce = Code/external/comdare-cache-engine.

---

## 0. Die Owner-Antwort F5 (05.08., VERBATIM — der Massstab dieser Lens)

LEDGER:4031 (Owner-Nachricht verbatim, Vollpersistenz-Regel E-21):
> "Frage 5: Absolut NEIN. ALLE Interfaces einer Tier-Binary (welche ja die Interfaces ihrer MAP-Huelle traegt (bitte Gattung/Genus/Terminologie der Anatomie Schichtung nachschlagen) testen die realen Implementierungen der gewaehlten metaprogrammierten Tier-Binary-SearchAlgorithmBase und deren Implementierungen, die ihrerseits dort Achseninterfaces verwenden, wo sie nur koennen. ALLE Achsen-Algorithmen UND Tier-Binary Interfaces muessen umfassend mit deep research tests nach dem compile belegt werden."

Konsolidierte Konsequenz LEDGER:4032: "**F5 = PRUEFSTAND-DOKTRIN (Owner-KERN):** std::map-Oracle ist NICHT genug; ALLE Interfaces einer Tier-Binary (= die Interfaces ihrer MAP-GATTUNGS-Huelle, Anatomie-Schichtung Gattung->Genus) testen die REALEN Implementierungen der metaprogrammierten Tier-Binary-SearchAlgorithmBase; ALLE Achsen-Algorithmen UND Tier-Binary-Interfaces umfassend mit DEEP-RESEARCH-TESTS NACH dem Compile belegen."

Die Rueckfrage, die das beantwortet, war Synthese-Frage 5 des Kette-Audits (backups/20260805-planer-ceb-kette-audit/synthese.md:117): "Gilt das std::map-Oracle-Konformitaets-Gate als Erfuellung von 'GOOGLE-TESTS als PRUEFSTAND' (§62-B), oder ist ein GTest-Harness am Pruef-Dock nachzuziehen?" -> Antwort: Absolut NEIN (Oracle allein genuegt nicht); die Doktrin ist umfassender als die Werkzeug-Frage.

---

## 1. SOLL im Plan-Korpus — chronologisch (spaeter schlaegt frueher; hier KEINE Supersession gegenlaeufig, die Linie ist konsistent aufsteigend)

### 1.1 V5-Architektur (2026-05-31, User-Direktive — die Ur-Quelle des Konformitaets-Gates UND der Interface-Vollabdeckung)

- ce docs/architecture/messarchitektur_v5_design.md:211-223 (§6 "Konformitaets-Gate gegen std::map je Gattung"): "Jede Lebewesen-Binary **bei Verwendung zuerst** durch dieselben std::map-Huellen-Tests (alle Randfaelle valide, egal wie die Huelle gebaut ist). Experiment misst nur Performance, aber jede Binary muss nach ihrer Gattung Testdaten konform speichern+wiedergeben. … **Reihenfolge bindend: import → GATE → (nur bei pass) messen.**"
- ce docs/architecture/messarchitektur_v5_entscheidungen.md:78-92 (§8, User 2026-05-31 — INTERFACE-VOLLABDECKUNG ist ALT-Gesetz, nicht neu): "Die Antriebs-Schnittstelle einer Lebewesen-Binary (`IDriveableTier` fuer die SearchAlgorithm-Gattung) muss **die VOLLSTAENDIGE Schnittstelle des repraesentativen Standard-Containers** anbieten — weil das Lebewesen **genau das IST** (eine `std::map`-Huelle). … Die aktuell vorhandenen **5 Ops** … sind **korrekt + super als Mock/Startpunkt**, muessen aber **zukuenftig erweitert** werden, bis die Huelle der **Vollstaendigkeit eines echten `std::map`** nahekommt: `operator[]`, `at`, `find`, `count`, `contains`, `begin/end`/Iteratoren, `lower_bound/upper_bound/equal_range`, `emplace/insert(hint)`, `erase(range/iterator)`, `empty`, `size`, `clear`, `swap`, `merge`, …" — plus Verallgemeinerung je Gattung (Set↔std::set, Sequence↔std::vector, Adapter↔Container-Adapter, View↔std::span).

### 1.2 AP-15/#263 (05.-06.07. — 17-Dagger-Interface-Vollabdeckung am Gate, Oracle TABU)

- LEDGER:1250: "conformance-Gate von 4 auf ALLE 17 Thesis-Dagger-Ops (Anhang F tab:if-map, selbst verifiziert): RF1-RF14 host-seitige Synthese aus den 5 noexcept-Primitiven gegen das unveraenderte std::map-Oracle; Ordnungs-Ops via IScannableTier-Cast mit ehrlichen Skips".
- LEDGER:626: "get_allocator = NON-DAGGER … → NICHT ins Oracle; additives dynamic_cast-Sub-Interface = major-neutral (Praezedenzen IScannable/IMigratable/IRC)".
- LEDGER:628: CRTP `DriveableMapContract<Derived>` in pruef_dock; "conformance_gate-Refactor **verhaltensidentisch bewiesen** (alle 6 Broken-Huellen fangen weiter, RF1-RF14 unveraendert, Oracle unangetastet)"; offen blieb "Set/Sequence-Dagger-Gatter als Folge-TODO" (inzwischen durch E-24 C4 Genus-Orakel materiell eingeloest, s. §3.2).
- TABU-Rahmen LEDGER:1265: "conformance-Oracle (std::map<uint64,uint64>) unantastbar — Erweiterungen nur [additiv]". Das Oracle bleibt also BESTAND; die F5-Doktrin fordert MEHR DANEBEN, nicht dessen Ersatz.

### 1.3 §62-B (21.07., User — GTEST-PRUEFSTAND + Mess-Tauglichkeits-Gate + Tooling-Konsistenz; das ist der "GOOGLE-TESTS"-Wortlaut)

LEDGER:3315 (PRAEZISIERUNG BATCH-MECHANIK, User 21.07.): "die Tier-Binaries werden per RUNTIME-BATCH auf der CEB gebaut und dann **direkt am PRUEFDOCK ueber den Aufruf von GOOGLE-TESTS als PRUEFSTAND auf alle Funktionen getestet** (Interface-Korrektheit), BEVOR gemessen wird — **erst Build+Pruef-Batch, nach Durchlauf erst die Messung**. KOMPILATIONS-STATUS-KOPPLUNG: welche Pruef-Tools in die CEB EINKOMPILIERT sind (Mess-Tooling-Achse), bestimmt, was auch das Tier-Binary beinhalten MUSS (Tooling-Konsistenz CEB<->Tier). … **der Planer wird aufgerufen, die CEB per XML-ANWEISUNG zu INSTRUMENTIEREN**, um mit ihr Batches von Tier-Binaries zu bauen und **auf Mess-Tauglichkeit zu pruefen**. (= Kern-Baustein der emit-VERTRAGS-KETTE aus dem §63-Nachtrag; … Umsetzung = Paket #54.)"

- LEDGER:3316 (Emissions-Gesetz): "je Maschine EIN Build+Pruef-Batch-Job (die CEB iteriert intern alle zugeteilten Perms x Chunks, **GTest-Pruefstand je Tier**, Log dokumentiert je Schritt die [d,e,f][g,h,i]-Kombi) + EIN Mess-Batch-Job je Maschine".
- LEDGER:3325: "die Reservierungen decken compile+pruef der CEB [= Tier-Batch + GTest-Pruefstand, s. Batch-Mechanik oben] UND den Compile der CEB durch den Planer ab — als STRATEGY PATTERN fuer das Caching."
- §63-GO-Stempel LEDGER:3375 (User 21.07.): "Korrekt, alle Punkte bis hierhin freigegeben. Volles autonomes GO — auch nachts." — deckt explizit "§62-B-Batch-Mechanik/#54 (CEB-interner Pruefstand-Batch + Planer-Instrumentierung)".
- Audit-SOLL-Kanon (backups/20260805-planer-ceb-kette-audit/soll.md:74, Posten 5.4, Prioritaet **[JETZT]**): "GTest-PRUEFSTAND am Pruefdock VOR der Messung … Tooling-Konsistenz: einkompilierte Pruef-Tools der CEB bestimmen die Pflicht-Ausstattung des Tier-Binaries (CEB↔Tier)."

### 1.4 §64 (22.07. — gemischte Pruef-Dock-Abnahme = das Mess-Tauglichkeits-Gate konkret)

- LEDGER:3381 (GESETZ): "STEHT DAZU NICHTS IN DER XML: alle 3 Verfahren in der CEB GEMEINSAM abgebildet per METAPROGRAMMIERUNG, und das **PRUEF-DOCK nimmt alle 3 Features vom Tier-Binary GEMISCHT ab**."
- LEDGER:3397-3399 (§64-SCHICHTEN-ZUORDNUNG, User "jetzt richtig"): "**Wallclock** wird auf der **CEB-SEITE** gebaut/erhoben … **Makro- und Micro-Benchmarking** muss durch **CEB UND TIER-BINARY einkompiliert ueber das PRUEFDOCK** unterstuetzt werden (beidseitig: die CEB traegt die Pruef-Tools, das Tier-Binary die Observer)."
- LEDGER:3400 (AUSRICHTUNGS-MECHANIK): "die Kette Planer-Mess-Achse -> CEB-Mess-Ausrichtung -> Tier-Observer-Einkompilierung ist EIN durchgereichter statischer Draht (§24-Ketten-Statik); die **gemischte Pruef-Dock-Abnahme nimmt dann wallclock (CEB-Schicht) + macro/micro (Tier-Observer-Schicht) in einem Rutsch ab**."

### 1.5 §68b + §62-B-NACHTRAG (26.07./22.07. — Test-Skip-Gesetz, Pruef-only als eigene Reihenfolge-Stufe)

- LEDGER:3548 (§68b, Owner zweifach bestaetigt): "Der **Voll-Build testet IMMER hart die GANZE Pipeline** — AUSGENOMMEN sind nur **gruen-getestet inventarisierte Binaries/Messungen** (Lager-Skip nur bei gruenem Test-Log am Binary). Der **Pruef-Dock-Test laeuft VOR jeder Messung**; das **Test-Log neben der Binary = Lagerhaltung**."
- LEDGER:3411 (Reihenfolge-Gesetz): "S1 (Log-Testate) -> S2 (Smoke-Umfang) -> **S3 (Pruef-only-Eintritt)** -> S4 (Batch-Emission …) — ERST DANN der 2^17-Voll-Bau".
- Konsolidierung docs/sessions/20260801-KONSOLIDIERT-gesamtarchitektur-lager-batch-eta-sha512.md:33: "Pruefstand: Build+Pruef-Batch VOR Messung; GTest-Pruefstand am Pruefdock je Tier; Tooling-Konsistenz CEB<->Tier; … Test-Skip-Gesetz §68b (26.07.): Lager-Skip NUR fuer gruen-getestet inventarisierte Binaries (Test-Log neben der Binary = Lagerhaltung); sonst testet der Voll-Build IMMER hart."

### 1.6 "deep research tests" — Begriffs-Vorlaeufer im Korpus

Der Terminus "deep research tests" als POST-COMPILE-Testklasse ist am 05.08. NEU gepraegt (LEDGER:4031). Sein Fundament ist aber Alt-Doktrin:
- LEDGER:241 (Goal-Kanon): "unbenannte Eigenschaft → deep research; falscher Wert schlimmer als honest-0" — Eigenschaften werden ERFORSCHT, nie erfunden ([[feedback_axes_optimization_semantics_deep_research_observer_strategy]]).
- Praezedenzen erforschter Test-Semantik: M0-Deep-Research (LEDGER:808, 5 RC-Achsen + 14 honest-0), #24-P4-Semantik-Deep-Research VOR Testbau (LEDGER:855: "Σ(19 Organ-seg + seg_framework_ns) = seg_run_total_ns EXAKT" als erforschte, dann getestete Invariante), #30-Deep-Research gegen Design-Docs (LEDGER:561).
- S-7 (LEDGER:530): "Pflicht mit deep research und ultracode … Alle Gattungen sollen ihre wichtigen Observer-Messwerte echt ermitteln." (Observer-ECHTHEIT als Forschungs-+Testauftrag; S-7 GEPARKT fuer Opus-Session.)
=> Lesart der F5-Doktrin im Korpus-Kontext: je Achsen-Algorithmus/Interface werden die zu testenden EIGENSCHAFTEN per Deep-Research aus Papern/Design-Docs erhoben (nie geraten, F6 "NIE RATEN") und dann als Post-Compile-Tests am realen Tier-Binary belegt.

---

## 2. Anatomie-Schichtungs-Terminologie AM OBJEKT (ce libs/cache_engine/anatomy/anatomy_base.hpp)

- 3-Ebenen-Modell (anatomy_base.hpp:31-45): "Ebene 1 AnatomyGattung = Aussen-Interface/Pruef-Dock: **Map | Container | Graph** (NUR 3); Ebene 2 AnatomyGenus = TIER-UNTERKLASSE …; Ebene 3 Achsen = Organe". "SEARCHALGORITHM IST DAS GENUS, NICHT DIE GATTUNG — die Ebene-1-Kategorie heisst MAP (Owner-KERN NACHTRAG 4, LEDGER:3836)" (:36-37). Map-Gattung hat GENAU EIN Genus (SearchAlgorithm, std::map-artig, 18 Organ-Haupt-Achsen == abi::kOrganAxisCount) (:38-40).
- Vererbungs-Satz (anatomy_base.hpp:91-92, Owner verbatim zitiert): "**'Das Genus erbt von der gemeinsamen Gattung'** — der Gattungs-Kern ist die mathematische Schnittmenge der Genus-Interfaces, das Genus erweitert sie."
- Enum (:49-58): Map=0 (Genus SearchAlgorithm), Container=1 (Genera Set/Sequence/Adapter/View), Graph=2 (Stub, Q5 nach Abgabe). `gattung_of()` (:125-134) = constexpr Genus->Gattung; `module_gattung()` (:233) host-seitig aus `genus()` — bewusst KEIN gattung()-vtable-Member (C7-6, :143-155).
- Wurzel-Interface `IAnatomyBase : IExecutionEngine` (:196-230): composition_name()/paper_id()/genus()/organ_count().

### 2.1 Die MAP-Huellen-Interfaces der Tier-Binary — KONKRET (ce libs/cache_engine/anatomy/abi_adapter.hpp:229-247)

`SearchAlgorithmAbiAdapter<A>` (DIE Tier-Binary-Huelle um die metaprogrammierte SearchAlgorithm-Anatomie) erbt:
- IMMER: **IAnatomyBase** (+IExecutionEngine-Wurzel), **IResourceControllableTier** (:232 "KF-4/L-MEAS: IMMER (auch Messung-aus)"), **IAllocatorProxyTier** (:233 "AP15-2: IMMER, non-dagger get_allocator-Proxy").
- MESSUNG-AN (COMDARE_MEASUREMENT_ON, :237-244): **IObservableTier** (: IDriveableTier — observable_tier.hpp:185; tier_observe auf POD `ComdareTierObserverSnapshot`, tier_reset_statistics), **IMeasurableWorkload** (V1 run_workload), **IMeasurableWorkloadV2** (run_workload_segmented, 4 Achsen), **IMeasurableWorkloadV3** (run_workload_segmented_v2, ALLE 17 Achsen) (measurable_workload.hpp:22/68/127), **IRollbackableTier** (rollbackable_tier.hpp:39, memento_all V5-I6), **IMigratableTier** (observable_tier.hpp:216, tier_migrate_step), **IScannableTier** (scannable_tier.hpp:35, Range-Scan/Ordnungs-Ops).
- MESSUNG-AUS (:246): NUR **IDriveableTier** (idriveable_tier.hpp:41) — "funktionaler Antrieb … Release-/funktional-only-DLL OHNE jeden Mess-Overhead" (:236).
- Gattungs-ANTRIEBS-Interface am Dock: `IDriveableTier` als funktionaler Gattungs-Antrieb ("IMMER vorhanden, auch in Release-/funktional-only-DLLs", conformance_gate.hpp:7) + dock-vertragliches Antriebs-Buendel `SearchAlgorithmDrive{obs,ctrl,rbk,scn}` via `acquire_search_algorithm_drive` (search_algorithm_dock.hpp:63-86; obs=Pflicht, ctrl/rbk/scn optional).
- Container-Gattungs-Pendants (fuer die Genus-Docks): ISetTier/ISetTierV2/ISetAlgebraTier, ISequenceTier/V2, IAdapterTier/V2, IViewTier/V2 (set_tier.hpp:41 usw.).
- ABI-Grenzen-Doktrin dazu LEDGER:1749/:1809: "Die ABI-Grenze ist **NICHT** `IPruefDock` … sondern das **gattungs-eigene Antriebs-Sub-Interface + POD-Snapshot**."

---

## 3. IST — was existiert schon (Kette-Audit 05.08. + gezielte Datei-Belege; NICHT neu erhoben)

### 3.1 Pruefstand am Dock (real, aber std::map-Oracle statt GTest)

- ist-ceb.md:208-225 (backups/20260805-planer-ceb-kette-audit/): "Pruefstand REAL, aber NICHT GTest. … Reihenfolge bindend VOR der Messung: conformance_gate.hpp:1-9 … Oracle = std::map<uint64,uint64> (:12-32), Quoten-Ergebnis ConformanceResult (:35-40); dock_status_conformance_failed (pruef_dock.hpp:41-42). … **Luecke vs SOLL: kein GTest im Pruefstand — grep gtest in pruef_dock/: 0 Treffer. GTest existiert im Repo nur in der tests/-Suite.**"
- measure()-VERTRAG ce builder/pruef_dock/pruef_dock.hpp:74-79: "Jede measure()-Implementierung MUSS das Modul VOR der Messung gegen die std::map-Huellen-Konformitaet pruefen (run_conformance_gate, Reihenfolge import → GATE → messen) … Gleiches gilt fuer JEDEN produktiven Mess-Eintrittspunkt ausserhalb der Docks." — §75-NICHT-KANDIDAT (LEDGER:3598): `IPruefDock::measure` samt Konformitaets-Gate-Klausel ist aufraeum-TABU (Hybrid-Stufe haengt daran).
- Standalone-Pruef-Modus: pruef_only.hpp:28-40 `run_so_conformance_gate` (Load → Drive → Gate, kein Bau/keine Messung) = `COMDARE_PRUEF_ONLY=true` im Batch-Job, `[PRUEF-TESTAT]` (ist-ceb.md:221-223; Marker-Familie v2 mit [PRUEF-BILANZ], LEDGER:3652; Diagnostik-Regel "pruef_only MUSS gebaut_neu=0 zeigen", LEDGER:3656).
- Sequencer: pruef_dock_sequencer.hpp `measure_genus_sequential` (gattungs-sequentiell, D2-Fehlerklassen daneben); Registry: pruef_dock_registry.hpp (Abstract-Factory select_for/dock_for_genus); Fehlerklassen: dock_error_classification.hpp + Tests test_e24_c5_fk7_dock_fehlerklassen.cpp (Fehlerklassen-Pflicht-Doktrin [[feedback_fehlerklassen_pflicht_alle_achsen_unterachsen_algorithmen]]).
- Synthese-Verdikt (synthese.md:61/79 + LEDGER:4025 R-G5a): "**Kein GTest im Pruefstand** — … Funktion voll gedeckt (Konformitaet ueber alle Randfaelle, bindende Reihenfolge), Werkzeug weicht ab, KEINE Deferred-Markierung → formale Regression".

### 3.2 Conformance-Oracles je Gattung (E-24 C4 — die Genus-Erweiterung EXISTIERT)

ce builder/pruef_dock/genus_conformance_gate.hpp:1-40: die vier Container-Gattungs-Orakel des V5-Gates — "Set -> std::set<uint64>; Sequence -> std::deque<uint64>; Adapter -> std::queue (FIFO) + std::stack (LIFO) **PLUS std::priority_queue** (am Ist erzwungen: HeapInner ist echter MAX-HEAP …); View -> std::span<uint64 const>"; "AUFLAGE 7 … der conformance-BESTAND wird nur ERWEITERT, nie geaendert. conformance_gate.hpp ist byte-unberuehrt". Docks je Genus existieren: set_dock/sequence_dock/adapter_dock/view_dock (+search_algorithm_dock).

### 3.3 Bestehende Test-Belege (GTest — aber in tests/, nicht am Dock)

- Dock-/Gate-Tests (Bauplan 20260719:145 nennt sie den "**Fuss-Beweis**"): test_conformance_gate.cpp ("alle 6 Broken-Huellen fangen, RF1-RF14", LEDGER:628), test_v5_conformance_gate.cpp, test_e3_contract_conformance_gate_wirksam.cpp (Gate im E3-Lauf wirksam; perm_runner.hpp:130-148 "import→GATE→(nur bei pass) messen" geheilt, LEDGER:812), test_v41_pruef_dock_search_algorithm.cpp, test_genus_docks.cpp, test_v41_anatomy_module_loader.cpp; E-24-Serie test_e24_c4_genus_conformance_gates/_genus_pruef_docks/_c4_dock_version_negativ/_c5_fk7_dock_fehlerklassen/_c10_genus_dll_roundtrip; CI-Job contract:conformance (LEDGER:313 u.a.).
- **Familien-Gates (S5)**: tests/unit/s5_family_alloc_conformance.hpp + test_s5_01a_pool_stores/01b_composable/01c_fassaden/01d_traversal/02a_layout/02b_filter/03_placement/04_execution/05q_queuing_alloc_conformance.cpp — die Allokator-Achsen-Familien-Konformitaet der REALEN Implementierungen (S5-Wellen, Familie 05 4/4 gelandet, MEMORY Lage-Anker 05.08.). Das ist der naechste existierende Verwandte der F5-Doktrin: Achsen-Familien x reale Impl x Conformance.
- Achsen-Tests je Organ-Achse: test_v41_axis_01..14_*-Serie + topics (test_v41_topic_allocator_axis_06/queuing/traversal) — testen die realen metaprogrammierten Achsen-Implementierungen, aber COMPILE-ZEIT-instanziiert in der Test-Suite, NICHT post-compile an der gebauten Tier-.so.
- Interface-Einzeltests: test_216h2 (tier_reset_statistics daten-erhaltend, LEDGER:313), test_v41_tier_observe_trace, test_v41_anatomy_observer, test_v41_anatomy_f15_measurement, test_ap15_3_driveable_map_contract.

### 3.4 Was das heutige Gate INHALTLICH abdeckt (und was nicht)

Abgedeckt am geladenen Binary (post-compile): IDriveableTier-Funktionalitaet (RF1-RF14 = 17 Dagger-Ops synthetisiert aus 5 noexcept-Primitiven) gegen std::map-Oracle; Ordnungs-Ops via IScannableTier-Cast (ehrliche Skips); AllocatorProxy als REPORT-Probe ausserhalb der RF-Kette (conformance_gate.hpp:42-60); Genus-Orakel fuer Set/Sequence/Adapter/View; Fehlerklassen + Versions-/ABI-Gate des Loaders.
NICHT als eigenes Post-Compile-Testat am Dock belegt: IObservableTier-Semantik (tier_observe-Plausibilitaet/Reset), IMeasurableWorkload V1-V3 (Segment-Summen-Invarianten — die erforschte Invariante Σseg==seg_run_total existiert nur als Suite-Test, LEDGER:855), IRollbackableTier (memento/rollback-Roundtrip), IMigratableTier (tier_moves real), IResourceControllableTier (RC-Felder wirken) — diese Interfaces werden im MESS-Pfad BENUTZT, aber nicht am Pruefstand PER INTERFACE GETESTET. Genau diese Luecke adressiert F5.

---

## 4. DELTA zur F5-Doktrin — was zur Doktrin FEHLT (Bauwelle W2 "Pruefstand-Ausbau")

1. **Werkzeug**: GTest am Pruef-Dock (§62-B verbatim "GOOGLE-TESTS"; grep gtest in pruef_dock/ = 0). R-G5a unmarkierte Werkzeug-Abweichung (LEDGER:4025). Owner-Antwort macht die WERKZEUG-Frage nachrangig gegenueber dem UMFANG — aber der §62-B-Wortlaut ist nirgends supersediert.
2. **Interface-Vollabdeckung am Dock**: je ein Post-Compile-Testat fuer JEDES getragene Interface (Liste §2.1) gegen die reale metaprogrammierte SearchAlgorithmBase-Kette — heute nur IDriveableTier(+Scannable-Ordnung, AllocatorProxy-Report).
3. **Achsen-Algorithmen post-compile**: die test_v41_axis_*-Substanz existiert nur suite-seitig; ein per-Binary-Beleg "ALLE Achsen-Algorithmen … nach dem compile" fehlt (Anker: S5-Familien-Gates als Muster; "Achsen-Interfaces wo immer moeglich" = GENERALISIERTE SCHNITT-REGEL 04.08.: ALLE Achsen-Eigenschaften NUR ueber die Achsen).
4. **Deep-Research-Test-Katalog**: pro Achsen-Algorithmus/Interface die zu belegenden Eigenschaften per Deep-Research erheben (F6: NIE RATEN; Doktrin LEDGER:241) — existiert nirgends als Katalog.
5. **Drive-Voll-API (V5-§8)**: ABI-Antrieb weiterhin 5 Primitive; die volle std::map-Huelle (Iteratoren/bounds/merge…) als Drive-Erweiterung ist deklariertes Zukunfts-SOLL (conformance_gate.hpp:10-11 "V5-I-Drive-Vollausbau").
6. **Gemischte Mess-Tauglichkeits-Abnahme** (§64: wallclock+macro/micro "in einem Rutsch" am Dock) — im IST-Audit nicht als gebaut belegt; koppelt an Tooling-Konsistenz CEB<->Tier (statischer Draht LEDGER:3400).
7. **#54-Form**: Pruefstand-Batch-Instrumentierung laeuft per Env/Job-Text statt XML-ANWEISUNG (R-G5b, LEDGER:4025) — separater W3-Posten, aber derselbe §62-B-Absatz.

Nicht-Befunde (ehrlich): Der 982er-Wahrheits-Anker enthaelt KEINE Pruefstand-/GTest-/Oracle-Frage (grep pruefstand|gtest|google = 0 Treffer; einzig nr-Eintrag zu Hybrid-"Unter-Pruef-Docks per Abstract-Factory", :58). Chunk-Delta D-01..D-17 enthaelt nichts Pruefstand-Spezifisches (D-02 PMC-Gate = Maschinen-Messfaehigkeit, nicht Dock-Pruefstand).
