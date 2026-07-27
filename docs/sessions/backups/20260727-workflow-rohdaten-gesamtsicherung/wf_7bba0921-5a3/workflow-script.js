export const meta = {
  name: 'phase02-general-hardware-design',
  description: 'Deep-Research + adversariale Design-Auflösung: general_hardware(12) verdrahten ohne die cacheline-Mess-Achse (Thesis-Kern) zu beschädigen',
  phases: [{ title: 'Research' }, { title: 'Design' }, { title: 'Critique' }],
}

const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = `${SUP}/Code/external/comdare-cache-engine`

const IST = `IST-VERIFIKATION (belegt, Basis fuer alle Agenten — NICHT neu herleiten, nur nutzen/verifizieren):
PROVIDER axis_12 general_hardware (CRTP-Basis + 2x Concept-guarded, alles static constexpr) unter ${CE}/libs/cache_engine/topics/hardware/axis_12_general_hardware/:
 - Interface (concept GeneralHardwareStrategy, axis_12_general_hardware_concept.hpp:19-26): cache_line_size(), memory_page_size(), simd_width_bits(), numa_capable(), huge_page_capable().
 - 3 Profile: Generic(64/4096/0/false/false), X86_64(64/4096/256/true/true), Aarch64(64/4096/128/true/true). Registry AllPlatforms=mp_list<Generic,X86_64,Aarch64>.
 - Sub-Achsen HW1-HW4 (subaxes_hw1_to_hw4.hpp:26-41): Tag-Structs cpu_family_tag/simd_capability_tag/memory_topology_tag/page_topology_tag — aber alle 3 Profile setzen axis_tag=cpu_family_tag; die anderen 3 Tags nirgends materialisiert.
DOPPEL-WAHRHEIT (vier parallele "64", keine liest axis_12):
 (a) cacheline-Unterachse ${CE}/libs/cache_engine/axes/cacheline/cacheline_config.hpp: enum CacheLineSize{B64,B128,B256}(:30); struct CacheLineConfig{line_size=B64}(:35-41) als NTTP; template<CacheLineConfig Cfg> struct CacheLineAware (CRTP-Mixin, :84-89). = DIE PERMUTIERBARE MESS-ACHSE (Diplomarbeits-Kernthema).
 (b) memory_layout(05) axis_05_memory_layout_cache_line_aligned.hpp:28 cache_line_size()->64 + :54 hardcoded kCacheLine=64.
 (c) node axis_04_node_type_layout_aware_store.hpp:360 kChunkAlign=64.
KONSUMENTEN heute: node-Stores lesen L::cache_line_size() aus dem memory_layout-Param L (chunked_store.hpp:56, layout_aware_store.hpp:100) — NICHT axis_12. allocator liest cache_line/numa/page GAR NICHT.
ZIRKULARITAET: axis_12 inkludiert NICHTS aus memory_layout/allocator/node -> Kante Konsument->axis_12 = neue Abwaertskante, KEIN Zyklus.
VORBILD-MUSTER: defaulted NTTP + CRTP-Mixin (MemoryLayoutStrategyBase<Derived, CacheLineConfig Cfg={}> : CacheLineAware<Cfg>, axis_05_memory_layout_strategy_base.hpp:42-45; gleich in node/allocator/page_type/search_algo). Zweitmuster: build_variant_definition<PT,SE,HW>() reicht HW als Typ-Param durch und liest HW::cache_line_size()/HW::numa_capable() (build_variant_definition.hpp:60-72).
ABI/TABU: BuildVariantDefinitionV1 (build_variant_definition.hpp:17-34) = ABI-stabiler POD, traegt hw_cache_line/hw_numa_capable — UNVERAENDERT lassen. COMDARE_ANATOMY_ABI_MAJOR==4. GenusBindingTraits/golden_fullpilot_320_binary_ids.txt/permutation_axes.xml TABU. Additive golden/ABI-neutrale Verdrahtung nur, wenn Default den Wert 64 reproduziert (ODR-sicher, nicht-brechend) und kein neuer Achsen-Slot/POD-Feld noetig.`

const RESEARCH = [
  { key: 'thesis-design', prompt: `Du bist Design-Forscher. Quelle = Diplomarbeits-Design (Primärquelle) + Architektur-Doku. Lies:
- ${SUP}/thesis/diplomarbeit/diplomarbeit.tex (+ inkludierte Kapitel) — such nach: Cache-Line-Messung, Cache-Line-Größe/Alignment als Mess-/Permutations-Dimension, Hardware-Deskriptor/Plattform-Achse, general_hardware, das Verhältnis "was die HW WIRKLICH hat" vs. "was wir als Experiment-Knopf variieren".
- ${SUP}/docs/architektur/14_achsen_komposition_organ_metapher.md, 20_HEURISTIK_MESSKURVEN_TYPSYSTEM_UND_FILTERKETTE.md, 21_SESSION_PLAN_TYPSYSTEM_ACHSEN_ENTSCHEIDUNGEN.md (§F Phase 0.2 = "general_hardware verdrahten").
BEANTWORTE (mit Zitat datei:zeile / .tex-Abschnitt):
1. Ist die cacheline-Größe (B64/B128/B256) im Thesis-Design eine PERMUTIERBARE Mess-Achse (Experiment-Knopf), die erhalten bleiben MUSS? Belege.
2. Welche Rolle hat general_hardware(12) laut Design — reiner Hardware-WAHRHEITS-Deskriptor (was die Ziel-CPU real hat) ODER auch ein Permutations-Knopf? 
3. Sollen memory_layout/node/allocator ihre HARDWARE-Cacheline-Baseline (die heute hartkodierte 64) aus axis_12 beziehen, WÄHREND die cacheline-Permutations-Achse als separater Experiment-Knopf bestehen bleibt? Oder meint "verdrahten" etwas anderes?
4. Sollen numa_capable/memory_page_size/huge_page_capable laut Design in memory_layout/allocator/node einfließen — und wenn ja, wozu (welches Organ-Verhalten hängt davon ab)?
5. Gibt es im Design eine Aussage, die einen der beiden Mechanismen (defaulted NTTP-Param vs. HW-als-Typ-Param) präjudiziert?
Wenn das Design zu einem Punkt SCHWEIGT, sage das explizit (= echte Ambiguität für User-Eskalation). ${IST}` },
  { key: 'audit-constraint', prompt: `Du bist Constraint-Forscher. Verifiziere die golden/ABI/Zirkularitäts-Randbedingungen und die Muster-Wahl präzise am Code + konsolidiere den früheren Utilization-Audit.
Lies: ${SUP}/docs/sessions/backups/20260710-achsen-unterachsen-utilization/ACHSEN-UNTERACHSEN-UTILIZATION-BEFUND.md (Abschnitt zu general_hardware/#4). Verifiziere am Code ${CE}:
1. Reproduziert der Default eines defaulted-NTTP-Ansatzes garantiert 64 (golden/ABI-neutral)? Wo genau würde golden brechen, wenn nicht?
2. Bestätige zweifelsfrei, dass eine Kante memory_layout/node/allocator -> axis_12 zirkularitätsfrei ist (Include-Ketten beider Richtungen zeigen).
3. Welcher der beiden Vorbild-Mechanismen (defaulted NTTP CacheLineConfig-analog vs. HW-Typ-Param wie build_variant) ist der SAUBERERE für "HW-Baseline aus axis_12", ohne eine DRITTE parallele Wahrheit zu schaffen? Begründe an den bestehenden Strategy-Base-Signaturen.
4. Welche exakten Dateien/Zeilen müssten minimal geändert werden (Provider bleibt, nur Konsument liest)? Liste die konkrete Change-Surface.
5. Was ist NICHT anzufassen (BuildVariantDefinitionV1, GenusBindingTraits, golden, permutation_axes, ABI-Major) und warum bleibt es hier unberührt? ${IST}` },
]

const RESEARCH_SCHEMA = {
  type: 'object', additionalProperties: false, required: ['findings', 'ambiguities'],
  properties: {
    findings: { type: 'array', items: { type: 'object', additionalProperties: false, required: ['question', 'answer', 'evidence'],
      properties: { question: { type: 'string' }, answer: { type: 'string' }, evidence: { type: 'string', description: 'datei:zeile oder .tex-Abschnitt' } } } },
    ambiguities: { type: 'array', items: { type: 'string', description: 'Punkt, zu dem die Quelle schweigt -> evtl. User-Eskalation' } },
  },
}

phase('Research')
const research = await parallel(RESEARCH.map(r => () =>
  agent(r.prompt, { label: `research:${r.key}`, phase: 'Research', schema: RESEARCH_SCHEMA, effort: 'high' })
    .then(v => ({ key: r.key, ...v }))
))
const researchValid = research.filter(Boolean)

phase('Design')
const DESIGN_SCHEMA = {
  type: 'object', additionalProperties: false, required: ['recommendation', 'mechanism', 'properties_flow', 'change_surface', 'preserves_cacheline_axis', 'golden_abi_neutral', 'residual_forks'],
  properties: {
    recommendation: { type: 'string', description: 'Kern-Empfehlung in 3-5 Sätzen' },
    mechanism: { type: 'string', enum: ['defaulted-nttp', 'hw-type-param', 'hybrid', 'unclear-escalate'] },
    properties_flow: { type: 'string', description: 'Welche axis_12-Properties fließen zu welchem Konsumenten (cache_line_size/numa/page)' },
    change_surface: { type: 'array', items: { type: 'string', description: 'datei:zeile -> Änderung' } },
    preserves_cacheline_axis: { type: 'string', description: 'Wie bleibt die cacheline-Permutations-Achse unangetastet?' },
    golden_abi_neutral: { type: 'string', description: 'Warum golden/ABI-neutral (Default=64, kein POD/Slot-Change)' },
    residual_forks: { type: 'array', items: { type: 'string', description: 'offene Punkte, die nur der User entscheiden kann' } },
  },
}
const design = await agent(
  `Du bist der Design-Synthesizer. Aus den Research-Ergebnissen (unten) leite die KONKRETE, saubere Verdrahtung für Phase 0.2 ab (general_hardware(12) verdrahten). Zwingend: (a) die cacheline-Permutations-Mess-Achse (Thesis-Kern) bleibt UNANGETASTET; (b) zirkularitätsfrei; (c) golden/ABI-neutral (Default reproduziert 64, kein POD/Slot/GenusBindingTraits-Change); (d) keine DRITTE parallele Wahrheit — im Gegenteil, die hartkodierten 64 in memory_layout/node sollen die HW-Wahrheit aus axis_12 beziehen. Wenn die Research echte Thesis-Ambiguität zeigt, setze mechanism='unclear-escalate' und liste die Forks.
RESEARCH:
${JSON.stringify(researchValid, null, 1)}
${IST}`,
  { label: 'design:synth', phase: 'Design', schema: DESIGN_SCHEMA, effort: 'high' }
)

phase('Critique')
const CRIT_SCHEMA = {
  type: 'object', additionalProperties: false, required: ['verdict', 'issues'],
  properties: {
    verdict: { type: 'string', enum: ['SOUND', 'NEEDS-REVISION', 'ESCALATE'] },
    issues: { type: 'array', items: { type: 'object', additionalProperties: false, required: ['severity', 'issue'],
      properties: { severity: { type: 'string', enum: ['blocker', 'major', 'minor'] }, issue: { type: 'string' } } } },
  },
}
const CRITICS = [
  { key: 'thesis-core', lens: `Prüfe ADVERSARIAL, ob der Vorschlag die cacheline-MESS-Achse (Thesis-Kernbeitrag) beschädigt: Wird die Permutierbarkeit B64/B128/B256 als Experiment-Knopf irgendwo eingeschränkt, mit dem HW-Deskriptor konflatiert, oder die Mess-Semantik verändert? Wird HW-Wahrheit sauber von Permutations-Knopf getrennt gehalten? Wenn der Vorschlag den Thesis-Kern gefährdet: blocker.` },
  { key: 'abi-cycle', lens: `Prüfe ADVERSARIAL: Zyklus/Aufwärtskante? BuildVariantDefinitionV1/golden/GenusBindingTraits/permutation_axes/ABI-Major berührt? Reproduziert der Default garantiert 64 (nicht-brechend, ODR-sicher)? Compile-time-strikt (kein Runtime-Switch/vtable im Hot-Path)? Jede reale Verletzung: blocker.` },
]
const critiques = await parallel(CRITICS.map(c => () =>
  agent(`${c.lens}\n\nVORSCHLAG:\n${JSON.stringify(design, null, 1)}\n${IST}`,
    { label: `critique:${c.key}`, phase: 'Critique', schema: CRIT_SCHEMA, effort: 'high' })
    .then(v => ({ key: c.key, ...v }))
))

return { research: researchValid, design, critiques: critiques.filter(Boolean) }
