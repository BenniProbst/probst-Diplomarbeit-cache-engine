export const meta = {
  name: 'design-planung-konformitaets-fixes',
  description: 'Je Aufgabe (INC-1/F-SIMD/Namensfalle/INC-2d/INC-0/INC-29) ein konkreter ultracode-Bauplan + koordinierte Bau-Reihenfolge',
  phases: [
    { title: 'Plan', detail: 'je Aufgabe: Code kartieren + konkreter Bauplan (6 parallel)' },
    { title: 'Synth', detail: 'koordinierte Bau-Reihenfolge (gekoppelte Achsen-Library-Tasks)' },
  ],
}

const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUP + '/Code/external/comdare-cache-engine'
const NACHSCHLAG = SUP + '/docs/sessions/backups/20260717-achsen-nachschlagewerk/ACHSEN-NACHSCHLAGEWERK.md'
const SWEEP = SUP + '/docs/sessions/backups/20260718-konformitaets-sweep-3-tage/SWEEP-SYNTHESE.md'

const PRINZIP = `
FREIGABE-PRINZIP (User-Ruling 2026-07-18, verbindlich für ALLE Tasks):
- System-Achsen = "Freigabe der Existenz zu testender Hardware-Eigenschaften" (extension_hardware/simd gibt AVX frei;
  compiler gibt opt_level/-march/-mcx16 frei; hardware_isa gibt Ziel-ISA frei inkl. Cross-Compile x86→ARM64).
- Organ-Achsen = "Durchsetzung verfügbarer Hardware NACH der Freigabe" (Organ-Nutzung ≤ System-Freigabe).
- KEINE opt/OptO-Haupt-Achse — opt_level ist NUR Unter-Achse unter compiler; Optionen heißen OptO*Option.
- Alle malloc = Allokator-ORGAN-Achse (nicht System); Compile-Flags = Compiler-System-Achse. Klar trennen.
- Gemeinsames Dach topics::Axis über Mess+System+Organ; Organ-Achsen definieren parallel die Gattungen.
STRIKTHEIT: compile-time-only (CRTP+Concept, keine vtable), nur benannte Lehrbuch-Patterns, ce=Framework/super=Def,
binary_id-Neutralität (system_config nie in kCompositionAxisNames außer bewusst im GO-Fenster), golden messdaten-erhaltend.
Autoritative Achsen-Tabelle: ${NACHSCHLAG}. Sweep-Befunde: ${SWEEP}. JEDER Bauplan MUSS architekturkonform sein, nicht nur grün.
`

const TASKS = [
  { key: 'INC-1 Dach + Gattungen + Freigabe-Prinzip',
    ruling: `Organ-Familie unter das gemeinsame Dach topics::Axis hängen (AxisBase→OrganAxis<Derived>:topics::Axis, axis_kind()==organ, ODER Zwischenlösung StrategyBase : AxisBase, topics::Axis<Derived>). PARALLEL: die Organ-Achsen definieren die GATTUNGEN (welche Gattung=SearchAlgorithm/Set/Sequence/Adapter/View welche Organ-Achsen verwendet+braucht) — an GenusBindingTraits/AnatomyGenus andocken. Freigabe-Prinzip als Vertrag verankern.`,
    ist: `${CE}/libs/cache_engine/topics/axis.hpp + topics/axis_base.hpp (AxisBase:52) + die ~22 StrategyBase (grep 'public ::comdare::cache_engine::topics::AxisBase' in libs/cache_engine, z.B. axis_q2_queuing_strategy_base.hpp / axis_01_page_type_strategy_base.hpp) + GenusBindingTraits (grep GenusBindingTraits/AnatomyGenus) + system_axis.hpp/ceb_system_axis.hpp (die 2 bestehenden Dach-Kinder)` },
  { key: 'F-SIMD symmetrisch (SimdSubAxis)',
    ruling: `STRIKT nach DESIGN-§5-Empfehlung SYMMETRISCH: neue SimdSubAxis:CebSystemAxis (do_axis_label=="simd", parent_axis_label=="extension_hardware") analog OptimizationLevelSubAxis; Generic/Avx2/Avx512 → Optionen OptNoExtOption/OptAvx2Option/OptAvx512Option. XSD/golden/Parser/opt-g auf <extension_hardware><simd><option value>.`,
    ist: `${CE}/libs/cache_engine/include/cache_engine/measurement/extension_hardware_system_axis.hpp + optimization_level_sub_axis.hpp (als Template-Vorbild) + ${SUP}/Code/test_data_xml/experiment_schema.xsd (extension_hardware-Block) + ${CE}/libs/common/serialization/xml_config_parser/xml_config_parser.{hpp,cpp} (ExtensionHardwareAxisSel) + experiment_run_entry.hpp (march_of, Perm-Loop) + tests/unit/test_striktheit_axis_dach_guard.cpp` },
  { key: 'Namensfalle OptO*SubAxis→OptO*Option',
    ruling: `Die 5 Optionen OptO0..OfastSubAxis → OptO0..OfastOption. OptimizationLevelSubAxis bleibt DIE Unter-Achse. Optionen tragen nicht mehr "SubAxis".`,
    ist: `${CE}/libs/cache_engine/include/cache_engine/measurement/optimization_level_sub_axis.hpp:76-137 + alias DefaultOptLevelSubAxis:127 + experiment_run_entry.hpp:105-115 (experiment_opt_flag_of) + profile_run_facade.cpp (perm_opt_level_cflags) + tests/unit/test_striktheit_axis_dach_guard.cpp (Block J) + grep OptO alle Refs` },
  { key: 'INC-2d isa herauslösen → hardware_isa-System-Achse',
    ruling: `isa aus kCompositionAxisNames raus (18→17 Komposition-Achsen), an hardware_isa_system_axis anbinden (eigene System-Achse, cross-compile-fähig x86→ARM64). golden-Fixture regeneriert messdaten-erhaltend (binary_id verliert isa=-Segment; count bleibt 320, da isa ×1-gepinnt); POD/ABI-Diff + golden-Regen-Checkpoint.`,
    ist: `${CE}/libs/cache_engine/builder/experiment_tree/axis_path_serialization.hpp (kCompositionAxisNames, isa-Slot) + libs/cache_engine/include/cache_engine/measurement/hardware_isa_system_axis.hpp + libs/cache_engine/profile_facade/source_catalog.hpp (CatalogAxes/FullSourceCatalog, isa-Pinning) + tools/gen_golden_fullpilot + tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt + test_profile_roundtrip/limits-Tests (Count-Gates)` },
  { key: 'INC-0 malloc→Organ / Flags→Compiler-System trennen',
    ruling: `Alle malloc (mimalloc/jemalloc/snmalloc/std_malloc) = Allokator-ORGAN-Achse (Bibliotheks-Linking Organ-getrieben), NICHT System. Compile-Flags (-mcx16, SNMALLOC_*, opt, -march, -fno-gnu-unique) = Compiler-System-Achse. Klar trennen. Behebt Sweep-INC-0-Scope-Grenze (COMDARE_FACADE_PERM_EXTRA_CFLAGS/-mcx16 in perm_mess_defines aktiv injiziert, im Plan als out-of-scope markiert).`,
    ist: `${CE}/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp (make_gpp_compile_fn link_libs+opt_flag) + profile_run_facade.cpp:79-104/:156 (perm_link_libs/baked_perm_extra_cflags/perm_mess_defines) + libs/cache_engine/profile_facade/CMakeLists.txt:143-176 (COMDARE_FACADE_PERM_LINK_LIBS/EXTRA_CFLAGS) + die Allokator-Organ-Achse (grep axis_06_allocator / allocator strategy) + compiler_system_axis.hpp` },
  { key: 'INC-29 InfraError + isa_features FATAL→WARNING + SampleStatus + Patterns',
    ruling: `(1) Infra-Codes 125/127/-2 NICHT als D1-Klasse — separater InfraError (build_orchestrator.hpp:107 Carrier heben). (2) isa_features.cmake FATAL_ERROR (7 Stellen) → message(WARNING [Compiler-Compiler-Fehler:…]) + Perm überspringen. (3) SystemAxisSample um SampleStatus (N/A vs Failed splitten, invalidate→mark_not_applicable/mark_failed), op_lat volle SampleStatus. (4) 2 fehlende benannte Patterns: Policy-Based-Design (Handling-Policy-Structs) + Chain-of-Responsibility (error_domain()-Trait).`,
    ist: `${CE}/libs/cache_engine/include/cache_engine/measurement/axis_error.hpp + build_orchestrator.hpp (BuildResult.outcome=std::expected, provision_core-Exit-Mapping) + builder/experiment_tree/cache_engine_builder_iterator.hpp (D1-Log, op_lat :351-362) + builder/experiment_tree/perm_runner.hpp (D2 catch) + ${CE}/cmake/isa_features.cmake (FATAL_ERROR-Stellen) + measurement/system_axis.hpp (SystemAxisSample/invalidate)` },
]

phase('Plan')
const PLAN = { type: 'object', properties: {
  task: { type: 'string' },
  dateien: { type: 'array', items: { type: 'string' }, description: 'zu ändernde Dateien mit Stichwort' },
  bau_sequenz: { type: 'array', items: { type: 'string' }, description: 'geordnete Bau-Schritte' },
  patterns: { type: 'array', items: { type: 'string' }, description: 'benannte Lehrbuch-Patterns' },
  abi_golden_impact: { type: 'string' },
  verifikation: { type: 'string' },
  offene_fragen: { type: 'array', items: { type: 'string' } } },
  required: ['task','dateien','bau_sequenz','patterns','abi_golden_impact','verifikation','offene_fragen'] }

const plans = (await parallel(TASKS.map(t => () =>
  agent(`ultracode-DESIGN-PLANUNG für die Aufgabe "${t.key}". RULING (verbindlich, GO erteilt): ${t.ruling}
Kartiere den IST-Code: ${t.ist}. Erzeuge einen KONKRETEN, architekturkonformen Bauplan: dateien (datei:zeile + was),
bau_sequenz (geordnet, kleinstschrittig), patterns (benannte Lehrbuch-Patterns, compile-time CRTP+Concept, keine vtable),
abi_golden_impact (golden==320? ABI-Bump? messdaten-erhaltend?), verifikation (ctest/roundtrip/cf22/super-Sub-Build),
offene_fragen (nur ECHT ungeklärt). KEINE Umsetzung — nur der Plan. Berücksichtige die anderen 5 Tasks (Kopplung
Achsen-Library) für konsistente Struktur.\n\n${PRINZIP}\n\nALLE 6 TASKS (Kontext): ${TASKS.map(x => x.key).join(' · ')}`,
    { label: `plan:${t.key.slice(0,20)}`, phase: 'Plan', schema: { ...PLAN }, effort: 'high' })
    .then(r => r ? { ...r, task: r.task || t.key } : null)))).filter(Boolean)

phase('Synth')
const SYN = { type: 'object', properties: {
  bau_reihenfolge: { type: 'array', items: { type: 'object', properties: {
    schritt: { type: 'string' }, task: { type: 'string' }, begruendung: { type: 'string' }, go_status: { type: 'string' } },
    required: ['schritt','task','begruendung','go_status'] } },
  kopplungen: { type: 'array', items: { type: 'string' } },
  gesamt_offene_fragen: { type: 'array', items: { type: 'string' } },
  abi_golden_gesamtplan: { type: 'string' } },
  required: ['bau_reihenfolge','kopplungen','gesamt_offene_fragen','abi_golden_gesamtplan'] }
const synth = await agent(
  `Synthetisiere die KOORDINIERTE Bau-Reihenfolge über alle 6 Design-Pläne. Die Achsen-Library-Tasks (INC-1 Dach,
F-SIMD, Namensfalle, INC-2d) sind GEKOPPELT (gleiche Dateien) — ordne sie so, dass jeder Schritt architekturkonform
+ golden/ABI-kohärent ist (z.B. INC-1 Dach als Fundament zuerst; golden-Regen-Schritte gebündelt). INC-0 + INC-29
sind unabhängiger. Nenne bau_reihenfolge (schritt/task/begruendung/go_status), kopplungen, gesamt_offene_fragen,
abi_golden_gesamtplan (welche Schritte golden regenerieren, wie messdaten-erhaltend).\n\n${plans.map(p => `## ${p.task}\ndateien: ${JSON.stringify(p.dateien)}\nsequenz: ${JSON.stringify(p.bau_sequenz)}\nabi/golden: ${p.abi_golden_impact}\noffen: ${JSON.stringify(p.offene_fragen)}`).join('\n\n')}\n\n${PRINZIP}`,
  { label: 'synth:reihenfolge', phase: 'Synth', schema: SYN, effort: 'high' })
return { plans, synth }