export const meta = {
  name: 'plan-optg-a2neben',
  description: 'Koordinierte Planung: opt-g (Planer-opt_level-Permutation, CI/cmake-Codegen) + A2-Neben (builder<->measurement-Zyklus brechen, ABI-sicher)',
  phases: [
    { title: 'Scout', detail: '3 parallele Kartierungen: Planer-Dock · Zyklus-Ist · Includer-Fanout' },
    { title: 'Plan', detail: 'koordinierter, dependency-geordneter, ABI-sicherer Bau-Plan' },
  ],
}

const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'

const CTX = `
KONTEXT (Stand 2026-07-18, User "Volles GO fuer alle Punkte"):
- opt-c/d + d1 gebaut: CEB-Default O3 beweglich (DefaultOptLevelSubAxis=OptO3SubAxis), perm_opt_level_cflags()
  liest active_opt_level() (env COMDARE_PILOT_OPT_LEVEL, EINEN Wert), reicht opt_flag runter; +opt=<level> immer
  in system_axes_version_suffix(). D1: BuildResult.outcome=std::expected<void,CompilerCompilerErrorClass>.
- opt-f (parallel gebaut): opt_level als XML-Liste/Range (A3) im Experiment-XML + ce-Parser + validate_profile.
- opt-g SOLL: der Experiment-PLANER permutiert opt_level (und simd_extension) aus dem XML-Rahmen SELBST, erzeugt
  je Permutation eine eigene CompileFn(opt_flag) + eigenes +opt=-build_version-Sidecar, generiert CI/cmake daraus;
  Flags an CompileFn, Provenienz in Sidecar, NIE in binary_id (Q2 Option C). Eindimensional top-down (Blut/Dock).
- A2-Neben SOLL: den Verzeichnis-ZYKLUS builder<->measurement brechen. Ist: measurement/system_axis.hpp:10 +
  measurement/i_measurement_source.hpp:13 inkludieren builder/pmc_source.hpp (measurement->builder, aufwaerts);
  builder/experiment_tree/perm_runner.hpp + measurement/curve_fit.hpp inkludieren measurement (abwaerts). Aufloesung:
  pmc_source.hpp unter measurement/ oder neutralen Basis-Layer verschieben; perm_runner (Mess-Executor, fehlplatziert
  im builder-Layer) in eigenen Mess-/Harness-Layer herausloesen. ABI-nah (PmcCounters/IPmcSource), #156-WIDE-Mess-Naht,
  viele Includer. MUSS additiv/byte-identisch, ABI-neutral, golden==320 unberuehrt.
`

const MAP = {
  type: 'object',
  properties: {
    area: { type: 'string' },
    findings: { type: 'array', items: { type: 'object', properties: {
      point: { type: 'string' }, evidence: { type: 'string' } }, required: ['point','evidence'] } },
    recommendation: { type: 'string' },
    risks: { type: 'array', items: { type: 'string' } },
  },
  required: ['area','findings','recommendation','risks'],
}

const AREAS = [
  { key: 'optg_planer_dock', prompt: `opt-g: Finde den Experiment-PLANER-Dock im ce-Repo (${CE}). Grep nach run_experiment_profile / experiment_run_entry.hpp / dem Ort, an dem HEUTE EINE feste CompileFn erzeugt + an provision_all/BuildOrchestrator uebergeben wird (grep 'make_gpp_compile_fn' ausserhalb profile_run_facade; 'run_experiment_profile'; 'BuildOrchestrator'; 'CompileFn'; 'provision_all'). KERNFRAGE: Wo permutiert der Planer HEUTE (opt_level ist noch EIN Wert)? Wo muesste die opt_level-Liste (aus opt-f-XML) in eine SCHLEIFE ueber Permutationen einhaengen, die je opt-Wert eine eigene CompileFn(opt_flag) + eigenes +opt=-build_version erzeugt? Wie wird HEUTE CI/cmake aus dem XML generiert (grep catalog_codegen / permutation_codegen / generierte .cmake)? Nenne datei:zeile + den konkreten Andockpunkt fuer die Permutations-Schleife.` },
  { key: 'a2_cycle_break', prompt: `A2-Neben: Kartiere den builder<->measurement-ZYKLUS praezise. Lies ${CE}/libs/cache_engine/include/cache_engine/measurement/system_axis.hpp (um :10) + i_measurement_source.hpp (um :13) + finde builder/pmc_source.hpp (${CE}/libs/cache_engine/builder/pmc_source.hpp). KERNFRAGE: (a) WAS genau ziehen die measurement-Header aus pmc_source.hpp (PmcCounters? IPmcSource? make_pmc_source?)? (b) Ist pmc_source.hpp ein reiner POD/Interface-Header (dann leicht nach measurement/ oder einen neutralen base-Layer verschiebbar) oder zieht es selbst builder-Abhaengigkeiten? (c) Gehoert PmcCounters/IPmcSource konzeptionell zu measurement (Mess-Quelle) -> Verschiebung nach measurement/ bricht den Zyklus am saubersten? (d) ABI-Risiko: ist PmcCounters ein wire/POD-Typ (#156-Mess-Naht)? Nenne datei:zeile + die sauberste, byte-identische Verschiebungs-Strategie.` },
  { key: 'includer_fanout', prompt: `A2-Neben Includer-Fanout: Finde ALLE Dateien, die pmc_source.hpp UND perm_runner.hpp inkludieren (grep -rl 'pmc_source.hpp' + 'perm_runner.hpp' in ${CE}/libs ${CE}/tests ${CE}/apps). KERNFRAGE: Wenn pmc_source.hpp nach measurement/ verschoben wird, welche Include-Pfade muessen mitgezogen werden (relative vs <cache_engine/...>)? Und wenn perm_runner in einen eigenen Mess-Layer (z.B. measurement/harness/ oder ein neuer libs/cache_engine/harness/) verschoben wird — wie viele Includer sind betroffen + welche ABI-/Mess-Naht (#156, result_ingest, e2e_pipeline, slurm_launcher)? Bewerte, ob eine MINIMALE Aufloesung (nur pmc_source verschieben, perm_runner vorerst lassen) den Zyklus schon bricht (der Zyklus ist measurement->pmc_source[builder]; wenn pmc_source nach measurement wandert, ist der measurement->builder-Pfeil weg -> Zyklus gebrochen, OHNE perm_runner anzufassen). Nenne datei:zeile + eine gestufte Strategie (Minimal-Bruch zuerst).` },
]

phase('Scout')
const maps = (await parallel(AREAS.map(a => () =>
  agent(`${a.prompt}\n\n${CTX}`, { label: `scout:${a.key}`, phase: 'Scout', schema: { ...MAP }, effort: 'high' })
    .then(r => r ? { ...r, area: r.area || a.key } : null)))).filter(Boolean)

phase('Plan')
const SYN = {
  type: 'object',
  properties: {
    optg_plan: { type: 'string' },
    a2_neben_plan: { type: 'string' },
    build_order: { type: 'array', items: { type: 'object', properties: {
      id: { type: 'string' }, what: { type: 'string' }, files: { type: 'string' }, golden_neutral: { type: 'boolean' }, abi_risk: { type: 'string' } },
      required: ['id','what','files','golden_neutral','abi_risk'] } },
    open_questions: { type: 'array', items: { type: 'string' } },
  },
  required: ['optg_plan','a2_neben_plan','build_order','open_questions'],
}
const synInput = maps.map(m => `## ${m.area}\nfindings: ${JSON.stringify(m.findings)}\nrec: ${m.recommendation}\nrisks: ${JSON.stringify(m.risks)}`).join('\n\n')
const synth = await agent(
  `Synthetisiere den koordinierten Bau-Plan fuer opt-g + A2-Neben. (a) optg_plan = die konkrete Permutations-Schleife am Planer-Dock (opt_level-Liste aus XML -> je Wert CompileFn(opt_flag)+ +opt=-build_version; CI/cmake-Codegen; NIE binary_id). (b) a2_neben_plan = die GESTUFTE, byte-identische Zyklus-Aufloesung (Minimal-Bruch zuerst: pmc_source nach measurement/ verschieben -> measurement->builder-Pfeil weg -> Zyklus gebrochen OHNE perm_runner; dann optional perm_runner-Herausloesung als Stufe 2). ABI-neutral, #156-Mess-Naht nicht brechen, golden==320. (c) build_order = geordnete Increments mit golden_neutral + abi_risk je Schritt. compile-time-only, benannte Patterns, Messdaten nie loeschen, golden-Regenerierung messdaten-erhaltend nur wo noetig. Sammle echte offene Fragen (open_questions), loese Grundsatz-Weichen nicht eigenmaechtig.\n\nSCOUTS:\n${synInput}\n\n${CTX}`,
  { label: 'synth:plan', phase: 'Plan', schema: SYN, effort: 'high' })
return { maps, synth }