export const meta = {
  name: 'architektur-4schichten-workloads-runtime',
  description: 'Tiefes Architektur-Verstaendnis der Diplomarbeit cache-engine: B+-Experiment-Baum, 4 Schichten (Workflow-Backup), XML-Anforderungen, compile-time/runtime-Split (Achsen-Algorithmen=compile-time, Workloads=runtime); kritische Bewertung des #31-Baus',
  phases: [
    { title: 'Kartieren', detail: '7 parallele Leser: B+-Baum, 4 Schichten, XML, Doku/Anforderung, Workload-Ist, Kategorie/Mess-Achse, 6-Wochen-Historie' },
    { title: 'Synthese', detail: 'Architektur-Gesamtbild + kritische Bewertung des #31-compile-time-Ansatzes gegen workloads=runtime' },
  ],
}

const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'

const READERS = [
  {
    label: 'bplus-experiment-baum',
    prompt: `Du bist ein READ-ONLY-Architektur-Kartierer der Diplomarbeit cache-engine. ce-Basis: ${CE}. Fuehre KEINE mutierenden Befehle aus.

AUFGABE: Kartiere die Mechanik des B+-/Permutations-Experiment-Baums und den compile-time/runtime-Split.

Lies (mit Grep/Read, datei:zeile belegen): libs/cache_engine/builder/experiment_tree/experiment_tree.hpp, cache_engine_builder_iterator.hpp; suche+lies profile_to_tree.hpp, runtime_variable_loop.hpp; tests/unit/thesis_tiere/profile_run_entry.hpp, profile_runner.hpp, source_catalog.hpp.

Beantworte praezise:
1. Wie unterscheidet der Baum COMPILE-TIME-Achsen (StaticAxisNode: contributes_to_signature, is_runtime_loop=false, → binary_id, je Kombination eine eigene Tier-Binary/DLL) von RUNTIME-Achsen (DynamicVariableNode: virtuelle for-Schleife ueber EINER geladenen Binary, KEINE neue Binary)? Wo ist der Schalter (AxisLevel.is_static)?
2. Wie wird ein Lauf real gefahren (run_lazy_static_then_dynamic o.ae.)? static_filter/dynamic_filter, binary_id-Serialisierung, RuntimeVariableLoop.
3. WO GENAU sind WORKLOADS angesiedelt — static oder dynamic? Wie/wo wird die Workload-Achse injiziert (z.B. profile_run_entry.hpp: AxisLevel{"workload", ..., is_static=false})? Welche Achsen sind heute dynamic (concurrency, prefetch.hw_prefetcher, repetition, workload)?
4. Wo sind die ACHSEN-ALGORITHMEN (search_algo, node_type, memory_layout, prefetch-Strategie = die golden 320) — static/compile-time?

Gib eine praezise Mechanik-Karte mit datei:zeile-Belegen. Kern-Frage: bestaetigt der Code, dass Achsen-Algorithmen compile-time (eigene Binaries) und Workloads runtime (for-Schleife) sind?`,
  },
  {
    label: '4-schichten-dossier-backup',
    prompt: `Du bist ein READ-ONLY-Kartierer. Lies das gesicherte 4-Layer-Workflow-Dossier VOLLSTAENDIG: ${SUP}/docs/sessions/backups/20260709-wf-4layer-experiment-tree/workflow-result-full.json (nutze auch journal.jsonl + agent-*.jsonl im selben Ordner). Fuehre keine mutierenden Befehle aus.

AUFGABE: Extrahiere die 4 SCHICHTEN der Diplomarbeit-Architektur (in der JSON meist result.maps[0..3]) und die Synthese (result.synth).

Beantworte:
1. Was ist jede der 4 Schichten (Layer 1-4) — Name, Zweck, die konkreten Typen/Dateien je Schicht?
2. Wie realisieren die 4 Schichten zusammen die "Einstellbarkeit des Experiment-Baumes in der CacheEngineBuilder"?
3. Wie ist der compile-time/runtime-Split ueber die 4 Schichten verteilt — welche Schicht ist compile-time (Achsen-Algorithmen, Binary-Identitaet), welche runtime (Workloads, Mess-Variation)?
4. Welche Rolle spielt die BuildSelection / der Emitter / die Binary-Generierung?

Gib die 4 Schichten praezise wieder mit den Original-Zitaten aus der JSON (Typen, Dateien, datei:zeile wo vorhanden).`,
  },
  {
    label: 'xml-anforderungen',
    prompt: `Du bist ein READ-ONLY-Kartierer der cache-engine. ce-Basis: ${CE}. Keine mutierenden Befehle.

AUFGABE: Kartiere die XML-Landschaft und ihre Rolle im compile-time/runtime-Split.

Suche+lies (Grep/Glob/Read): alle *.xml unter ${CE} (v.a. permutation_axes.xml, load_profile-/workload-/lastprofil-XMLs, topic_config_sets-/config-XMLs, thesis-profile-XMLs) und ihre Parser (xml_config_parser, load_profile_parser, xml_reader). Belege datei:zeile.

Beantworte:
1. Welche XML definiert WAS? Insbesondere: definiert eine XML die WORKLOADS/Lastprofile (runtime), und definiert eine andere (permutation_axes.xml) die ACHSEN-PERMUTATION (compile-time, die golden-Binaries)?
2. Wie werden die XML-Werte in den Experiment-Baum eingespeist — als static axis (compile-time → binary_id) oder dynamic axis (runtime for-Schleife)? Wie laeuft discover_load_profiles / parse_load_profile?
3. Ist die Workload-Konfiguration (Op-Mix, Seed, Ops, Dataset) XML-getrieben und zur RUNTIME geladen?
4. Welche Anforderung an die XML-Struktur ergibt sich fuer ein "Framework von Workloads als runtime"?

Gib die XML-Landschaft mit Pfaden + Rolle + Parse-Pfad + compile-time/runtime-Zuordnung je XML.`,
  },
  {
    label: 'architektur-doku-kernanforderung',
    prompt: `Du bist ein READ-ONLY-Kartierer. Basen: ce=${CE}, super=${SUP}. Keine mutierenden Befehle.

AUFGABE: Finde die AUTORITATIVE Architektur-Anforderung fuer den compile-time/runtime-Split, speziell die Direktive "komplettes Framework von WORKLOADS als RUNTIME und ACHSEN-ALGORITHMEN als COMPILE-TIME".

Lies (Grep/Read, datei:zeile): ce docs/architecture/ + super docs/architektur/ — v.a. Doc 14 (achsen_komposition_organ_metapher), Doc 15 (F7 mess_frameworks_workloads_2d_matrix_plan), Doc 24, 27, 30, 37, messarchitektur_v5_design.md. Suche gezielt nach "runtime", "compile-time", "dynamische Achse", "Lastprofil", "Workload als", "Binary-Identitaet". Wenn Thesis-Kapitel auffindbar (thesis/.../kapitel/de/03_messsystem*, 06_evaluation*), lies die relevanten Stellen.

Beantworte:
1. Wo genau ist die Anforderung "Workloads=runtime, Achsen-Algorithmen=compile-time" dokumentiert, und was heisst sie exakt (Wortlaut zitieren)?
2. Wie SOLL die Workload-Achse (W), die Dataset-Achse (D) und die Mess-Kategorie-Achse (M) architektonisch modelliert sein — compile-time oder runtime? Was sagt Doc 15 (F7) dazu (Option A/B/C)?
3. Was ist compile-time (die Achsen-Anatomie/Permutation, golden 320) vs. runtime (Workload/Seed/Ops/Dataset/Repeats)?
4. Gibt es eine explizite Aussage, dass Workloads NICHT compile-time (kein mp_product-Faktor der Binary-Matrix) sein duerfen?

Gib die autoritativen Stellen woertlich mit datei:zeile.`,
  },
  {
    label: 'workload-subsystem-ist',
    prompt: `Du bist ein READ-ONLY-Kartierer der cache-engine. ce-Basis: ${CE}. Keine mutierenden Befehle.

AUFGABE: Kartiere den IST-Zustand des Workload-Subsystems und die Rolle der compile-time-workload_matrix.hpp.

Lies (datei:zeile): libs/cache_engine/builder/workload_driver/* (workload_matrix.hpp, workload_config.hpp, workload_profiles.hpp, workload_orchestrator.hpp, workload_generator.*), builder/commands/workload.hpp. Suche, WER workload_matrix.hpp inkludiert/konsumiert (Grep ueber das ganze Repo).

Beantworte:
1. Wie sind Workloads HEUTE modelliert: runtime (WorkloadConfig/profile_by_name/WorkloadGenerator, seed/ops) vs. compile-time (workload_matrix.hpp mp_list/mp_product)?
2. Was ist die Rolle von workload_matrix.hpp (compile-time Matrix ycsb_profile_list/matrix_cells)? IST SIE IN DEN PRODUKTIVEN MESS-PFAD VERDRAHTET, oder eine parallele/toteliegende Struktur, deren einziger Consumer ein Unit-Test (test_31) ist? Belege via Grep, wer sie inkludiert.
3. Wie laeuft der PRODUKTIVE Mess-Pfad — ueber String-AxisLevel-Injektion (discover_load_profiles, is_static=false) statt der compile-time-Matrix?
4. Waere ein compile-time mp_product(workload_profile_list, dataset_list) architektonisch konsistent mit "Workloads=runtime", oder ein Widerspruch?

Gib den Ist-Zustand mit datei:zeile + der Consumer-Liste von workload_matrix.hpp.`,
  },
  {
    label: 'mess-kategorie-achse-ist',
    prompt: `Du bist ein READ-ONLY-Kartierer der cache-engine. ce-Basis: ${CE}. Keine mutierenden Befehle.

AUFGABE: Kartiere das Mess-/Kategorie-Subsystem (Achse M) und wie Metriken erfasst werden.

Lies (datei:zeile): libs/cache_engine/include/cache_engine/measurement/measurement_category.hpp; libs/cache_engine/builder/measurement_snapshot.hpp (ComdareMeasurementSnapshotV1, pmc_available); suche pmc_source.hpp / IPmcSource / pmc_source_factory, IMeasurementObserver, axis_observer_classification / measure.hpp. Suche, ob es schon eine compile-time-Klassifikation der 16 MeasurementCategory (observer vs counter/pmc) gibt.

Beantworte:
1. Wie werden Mess-Kategorien heute erfasst — entstehen ALLE Spalten eines Laufs gleichzeitig in EINEM Snapshot-POD, oder je Kategorie ein eigener Lauf?
2. Gibt es bereits eine Zweiteilung observer(zeit)/counter(pmc) — z.B. via pmc_available oder eine Factory? datei:zeile.
3. Ist die Mess-Kategorie-Achse (M) eine Lauf-multiplizierende Achse (mp_product-Faktor) oder eine Spalten-Projektion ueber den Snapshot (multipliziert KEINE Laeufe)?
4. Wie SOLLTE eine compile-time-Kategorie-Achse M korrekt aussehen (Liste+Regime-Klassifikator vs. mp_product)?

Gib den Ist-Zustand mit datei:zeile.`,
  },
  {
    label: '6-wochen-planungshistorie',
    prompt: `Du bist ein READ-ONLY-Kartierer. super-Basis: ${SUP}. Keine mutierenden Befehle.

AUFGABE: Rekonstruiere die Planungs-Historie der letzten ~6 Wochen fuer das "Framework von Workloads (runtime) + Achsen-Algorithmen (compile-time)" und #31 (F7).

Lies (datei:zeile): docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (v.a. alle F7/#31-, #29-, Workload-Achse-, experiment_tree-, Hybrid-Eintraege); docs/sessions/*.md chronologisch (Titel + relevante Stellen); docs/architektur/15; ce docs/architecture/37.

Beantworte:
1. Wie hat sich die Anforderung an den compile-time/runtime-Split ueber die 6 Wochen entwickelt? Was wurde konkret als "Workloads=runtime, Achsen=compile-time" festgelegt (Zitate)?
2. Was wurde fuer #31 (F7 2D-Matrix Workloads × Kategorien/Datasets) beschlossen — insbesondere der "Hybrid aus compile-time + runtime"-Beschluss (User)? Was genau soll compile-time, was runtime sein?
3. Gab es frueher einen verworfenen rein-compile-time-Ansatz (z.B. revertierter WorkloadProfile-Enum)? Warum verworfen?
4. Welche offenen Punkte/Gates bestehen fuer #31 und den Workload-Achsen-Split?

Gib die Anforderungs-Evolution chronologisch mit Beleg-Zeilen.`,
  },
]

phase('Kartieren')
const maps = await parallel(READERS.map((r) => () => agent(r.prompt, { label: r.label, phase: 'Kartieren' })))

phase('Synthese')
const joined = maps
  .map((m, i) => (m ? `\n\n===== KARTIERUNG: ${READERS[i].label} =====\n${m}` : `\n\n===== KARTIERUNG: ${READERS[i].label} — FEHLGESCHLAGEN =====`))
  .join('')

const synthPrompt = `Du bist der Chef-Architekt der Diplomarbeit cache-engine. Dir liegen 7 READ-ONLY-Kartierungen der Architektur vor (B+-Experiment-Baum, 4 Schichten aus dem Workflow-Backup, XML-Anforderungen, Architektur-Doku/Kern-Anforderung, Workload-Subsystem-Ist, Mess-/Kategorie-Achse-Ist, 6-Wochen-Planungshistorie). Synthetisiere das VOLLSTAENDIGE Architektur-Bild, mit striktem Fokus auf die Kern-Anforderung: "komplettes Framework von WORKLOADS als RUNTIME und ACHSEN-ALGORITHMEN als COMPILE-TIME".

Beantworte praezise und mit datei:zeile-Belegen aus den Kartierungen:

1. VIER SCHICHTEN: Was sind die 4 Schichten der Architektur und wie realisieren sie den compile-time/runtime-Split? Welche Schicht ist compile-time (Achsen-Algorithmen → eigene Tier-Binary/DLL, binary_id, golden 320), welche runtime (Workloads → for-Schleife ueber einer Binary, keine neue Binary)?

2. B+-EXPERIMENT-BAUM: Wie fahrt der Baum static (compile-time) vs dynamic (runtime)? Wo sitzen Workloads (dynamic/runtime), wo die Achsen-Algorithmen (static/compile-time)? Wie steckt die CacheEngineBuilder-"Einstellbarkeit" darin?

3. WORKLOADS = RUNTIME: Was heisst "Framework von Workloads als runtime" konkret architektonisch? Rolle der XML/discover_load_profiles/WorkloadConfig/profile_by_name. Duerfen Workloads ein compile-time mp_product-Faktor der Binary-Matrix sein — ja/nein, mit Begruendung aus der Anforderung?

4. ACHSE W/D/M — KORREKTE MODELLIERUNG: Wie sollen Workload-Achse (W), Dataset-Achse (D) und Mess-Kategorie-Achse (M) architektonisch KORREKT modelliert sein (compile-time vs runtime), gemaess Anforderung + Doc 15 (F7)?

5. KRITISCHE BEWERTUNG DES #31-BAUS (WICHTIGSTE FRAGE): Ein Impl-Agent hat gerade #31-Schritt-2 gebaut (lokal ctest-gruen, aber NICHT committet):
   (a) workload.hpp: enum WorkloadKind um InsertHeavy=6, LookupHeavy=7 ergaenzt.
   (b) workload_matrix.hpp: neue COMPILE-TIME-Liste workload_profile_list = mp_push_back(ycsb_profile_list, IH, LH) = 8, und matrix_cells = mp_product(mp_list, workload_profile_list, dataset_list) = 8 Workloads x 6 Datasets = 48 COMPILE-TIME-Zellen.
   (c) measurement_category_axis.hpp (neu): COMPILE-TIME measurement_category_list (16 MeasurementCategory) + constexpr category_regime (Observer/Counter/Derived) + category_needs_pmc.
   Damit sind W, D und M als COMPILE-TIME mp11-Strukturen modelliert.
   FRAGE: Ist dieser compile-time-Ansatz fuer die WORKLOADS (W) und DATASETS (D) architektonisch KORREKT gegenueber "Workloads=runtime"? Oder ist die compile-time-workload_matrix ein WIDERSPRUCH zur Anforderung, und W (und ggf. D) muessten runtime (dynamische AxisLevel, XML/discover_load_profiles) modelliert werden? Ist die Kategorie-Achse M (Spalten-Projektion, kein Lauf-Multiplikator) korrekt als compile-time-Liste? WO GENAU liegt das Missverstaendnis des Impl-Agenten, und was waere die architektonisch KORREKTE Umsetzung von #31 (konkrete Datei-/Typ-Empfehlungen)?

6. KORREKTUR-EMPFEHLUNG: Falls der #31-Bau (teilweise) falsch ist — was ist der konkrete, architektonisch korrekte Bau-Plan fuer #31 (welche Teile behalten, welche verwerfen/anders)? Falls korrekt — begruende warum die compile-time-Katalog-Definition mit dem runtime-Fahren vereinbar ist (Hybrid).

Sei schonungslos praezise. Die Kartierungen:${joined}`

const synth = await agent(synthPrompt, { label: 'synthese-architektur-bewertung', phase: 'Synthese' })

return { synthese: synth, kartierungen: maps }
