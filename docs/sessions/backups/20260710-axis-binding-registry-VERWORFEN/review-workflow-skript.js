export const meta = {
  name: 'review-axis-binding-registry',
  description: 'Adversarialer Review Achsen-Binding-Registry (compile/dynamic-Wurzel Doc-20)',
  phases: [
    { title: 'Find', detail: '3 Dimensionen: grounding-treue, metaprog-striktheit, layering-scope' },
    { title: 'Verify', detail: '2-Lens-Verify je Kandidat, empirische Reproduktion' },
  ],
}
const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const CTX = `KONTEXT: NEU (UNCOMMITTED, ce main 7b3f43e-Bereich) axis_binding-Registry. ce=${CE}. Dateien: (1) libs/cache_engine/builder/axis_binding/axis_binding_registry.hpp — consteval-"Blut"-Registry der 19 Composition-Achsen mit AxisBinding{Compile,Dynamic} (tree<axis compile/dynamic>-Wurzel des Doc-20-Typsystems, docs/architektur/20_...md §B/§G), RcField-Enum, kAxisBindingRegistry[19] (5 Dynamic: cache_traversal/allocator/prefetch/concurrency/value_handle + Caps 4096/1GiB/64/64/256; 14 Compile), consteval-Guards (Namen==kCompositionAxisNames, Dynamic<=>RcField+Cap, RC-Bijektion, count 5/14, sizeof(RC-POD)/8-1==count_dynamic), for_each_axis_binding/axis_binding-Lookup. (2) tests/unit/test_axis_binding_registry.cpp (Label axes;binding) + CMake-Block. GROUNDING-QUELLEN (verifizieren!): kCompositionAxisNames in libs/cache_engine/builder/experiment_tree/axis_path_serialization.hpp:30-34; RC-POD ComdareResourceControlV1 in libs/cache_engine/anatomy/resource_controllable_tier.hpp:34-40; Caps in libs/cache_engine/anatomy/abi_adapter.hpp:226-231. Bereits bewiesen: test ALLE OK, voller ctest 200/200, clang-format 0, Mojibake 0.`
phase('Find')
const DIMS = [
  { key: 'grounding-treue', prompt: `${CTX}\n\nAUFTRAG (Finder, adversarial): Pruefe die GROUNDING-TREUE gegen die drei Quellen (lies sie!). (a) Sind die 5 als Dynamic markierten Achsen (cache_traversal, allocator, prefetch, concurrency, value_handle) WIRKLICH die RC-POD-steuerbaren — Feld↔Achse-Zuordnung + Caps exakt gegen abi_adapter.hpp:226-231 UND resource_controllable_tier.hpp:35-40 (batch_size↔cache_traversal? die abi_adapter-Kommentare sagen 'traversal (axis_03a)' und 'value_handle (axis_14)' — sind das dieselben Achsen wie cache_traversal/value_handle im kCompositionAxisNames-Slot, oder eine axis_NN-vs-Slot-Verwechslung? tier_apply_resource_control-Konsum pruefen: WELCHE Achse wird real gesetzt)? (b) Cap-Werte 4096/1GiB/64/64/256 stimmen sie mit den abi_adapter-Literalen? (c) Ist die Behauptung '14 compile / 5 dynamic' konsistent mit dem Bestand (profile_to_tree.hpp DynamicVariableNode; welche Achsen erzeugen dynamische vs. statische Baum-Ebenen)? (d) sizeof(ComdareResourceControlV1)/8-1==5 — stimmt die POD-Struktur (6 uint64-Felder) und ist der Drift-Guard korrekt? Melde NUR belegbare Grounding-Fehler (datei:zeile + korrekter Wert).` },
  { key: 'metaprog-striktheit', prompt: `${CTX}\n\nAUFTRAG (Finder, adversarial): Pruefe METAPROGRAMMIERUNG + Korrektheit. (a) Sind alle Guards WIRKLICH consteval/compile-time (registry_is_consistent, count_dynamic, sizeof-Assert) — oder gibt es einen still-durchrutschenden Fall (z.B. zwei Achsen mit gleichem RcField wuerde die Bijektions-Schleife fangen — verifiziere durch ein Shim-Experiment: manipuliere eine Zeile und pruefe ob der static_assert ZWINGEND bricht)? (b) ODR/inline-constexpr-Risiken bei Mehrfach-TU-Include? (c) index_sequence-Lambda in for_each — C++23-Portabilitaet (g++-16 ok, aber MSVC/clang der 8er-Matrix)? (d) Ist der system_axis.hpp-Include (Kommentar 'nur fuer Layer-Naht/Doku') tatsaechlich UNBENUTZT → toter Include, der observable_tier+pmc_source unnoetig in jeden Konsumenten zieht (wie im Phase-6-Review gefunden)? Melde NUR belegbare Defekte.` },
  { key: 'layering-scope', prompt: `${CTX}\n\nAUFTRAG (Finder, adversarial): Pruefe LAYERING + SCOPE + Doc-20-Treue. (a) Include-Layering: builder/axis_binding inkludiert builder/experiment_tree + anatomy + include/measurement — ist die Richtung konsistent mit der Baseline-Layering-Doktrin (nur niederwertigere referenzieren)? Zirkel? (b) Ist die Registry wirklich FORK-UNABHAENGIG (Doc 20 §H) — enthaelt sie versteckt eine der 7 offenen User-Entscheidungen (z.B. praejudiziert sie das Sonderstatus-Trio T2/T1/T10, indem T1 cache_traversal als Dynamic klassifiziert wird, obwohl §H Punkt 7 T1-Attribution offen laesst)? (c) CMake: Label axes;binding nicht in -LE contract|pmc (CI-aktiv)? Test korrekt in COMDARE_TEST_TARGETS? (d) Doppelt-Wahrheit: existiert die 14/5-Klassifikation schon woanders im Code (z.B. profile_to_tree is_static-Logik) — waere die Registry dann eine zweite, drift-gefaehrdete Quelle statt Single-Source? Melde NUR belegbare Defekte (datei:zeile).` },
]
const FINDINGS_SCHEMA = { type: 'object', required: ['findings'], properties: { findings: { type: 'array', items: { type: 'object', required: ['file', 'line', 'title', 'severity', 'scenario'], properties: { file: { type: 'string' }, line: { type: 'number' }, title: { type: 'string' }, severity: { type: 'string', enum: ['critical', 'major', 'minor'] }, scenario: { type: 'string' } } } } } }
const VERDICT_SCHEMA = { type: 'object', required: ['real', 'reason'], properties: { real: { type: 'boolean' }, reason: { type: 'string' } } }
const results = await pipeline(
  DIMS,
  d => agent(d.prompt, { label: `find:${d.key}`, phase: 'Find', schema: FINDINGS_SCHEMA }),
  (review, d) => parallel((review?.findings ?? []).map(f => () =>
    agent(`${CTX}\n\nAUFTRAG (Verifier, adversarial — versuche zu WIDERLEGEN, empirische Reproduktion am echten Code PFLICHT, bei Unsicherheit real=false): Kandidat aus Dimension ${d.key}: ${f.file}:${f.line} [${f.severity}] ${f.title} — Szenario: ${f.scenario}\n\nPruefe am echten Repo-Stand (lesend; Compile-Proben in eigenem Scratch, NIE offizielle build/ zerstoeren, kein git-write). real=true NUR wenn das Fehl-Szenario konkret reproduzierbar/zwingend ist.`, { label: `verify:${f.title.slice(0, 26)}`, phase: 'Verify', schema: VERDICT_SCHEMA })
      .then(v => ({ ...f, dim: d.key, verdict: v }))
  ))
)
const flat = results.filter(Boolean).flat().filter(Boolean)
const byKey = new Map()
for (const f of flat) {
  const k = `${f.file}:${f.line}:${f.title}`
  if (!byKey.has(k)) byKey.set(k, { ...f, votes: [] })
  byKey.get(k).votes.push(f.verdict?.real === true)
}
const uniq = [...byKey.values()].map(f => ({ ...f, confirmed: f.verdict?.real === true }))
const confirmed = uniq.filter(f => f.confirmed)
log(`${uniq.length} Kandidaten, ${confirmed.length} CONFIRMED`)
return { confirmed, plausible: uniq.filter(f => !f.confirmed), total: uniq.length }