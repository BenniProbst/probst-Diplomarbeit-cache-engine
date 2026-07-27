export const meta = {
  name: 'memory-footprint-peak-semantics',
  description: 'Deep-Research: COW-korrekte MEMORY_FOOTPRINT/bytes_in_use_peak-Semantik (Thesis-Ziel) + exakter sauberer Implementierungspunkt + adversariale Ehrlichkeit/TABU-Pruefung — H-2 fertigstellen',
  phases: [{ title: 'Research' }, { title: 'Design' }, { title: 'Refute' }],
}
const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const THESIS = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/thesis/diplomarbeit'
const COMMON = `KONTEXT: SystemAxis MEMORY_FOOTPRINT (Kat 5, TimeObserver) ist honest-0 (system_axis.hpp:264-269): "Thesis-Kanon verlangt bytes_in_use_peak (05_evaluation.tex:94-95); T6-Schema traegt nur Momentanwert bytes_in_use — als Footprint verzerrte er CoW-lastige Layouts (Peak >> Endstand). Bis eine peak-Spalte (golden-neutraler END-Append) existiert: invalid." Der Fill (abi_adapter.hpp:1164-1184) liest container_algorithm_.store_allocator_statistics() {total_bytes_allocated, total_bytes_in_use, allocation_count, deallocation_count, failure_count} nach axis_stats[6][0..5]; Slots [6][6]/[6][7] sind reserviert (nullptr im Schema, wie T2's [2][6]). TABU: golden_fullpilot_320, POD sizeof==1416 (axis_stats[19][8] fix → reservierter Slot = neutral), ABI-4. Direktive: Min/Max je Achse ERFORSCHEN nie ERFINDEN; Anti-Phantom (falscher Wert schlimmer als honest-0); nur benannte Patterns; compile-time-only Hot-Path.`

phase('Research')
const DIM = [
  {
    key: 'thesis-semantik',
    prompt: `${COMMON}\n\nAufgabe: was SOLL MEMORY_FOOTPRINT/bytes_in_use_peak laut Diplomarbeit-Ziel GENAU messen? Lies ${THESIS}/kapitel (05_evaluation / 07_results_evaluation, bes. :94-95 zu bytes_in_use_peak/Speicher-Footprint) + Design-Space-Kanon. Frage: Peak WOVON — die live-Bytes der Datenstruktur (Store), oder der Allokator-Arena-High-Water-Mark, oder RSS? Ueber welchen Zeitraum (ganze Messreihe / je Op / je Fuellstand)? Warum ist der Endstand (Momentanwert) fuer COW-lastige/vector-growth-Layouts irrefuehrend (Peak>>Endstand)? Nenne die thesis-kanonische Definition mit datei:zeile. KEINE Erfindung.`,
  },
  {
    key: 'store-stats-ist',
    prompt: `${COMMON}\n\nAufgabe: IST-Zustand der Store-Statistik im Code ${CE}. Finde die Methode store_allocator_statistics() (grep) + die zurueckgegebene Statistik-Struct: welche Felder, WO wird total_bytes_in_use getrackt (auf welchem alloc/grow/dealloc-Pfad), und trackt der Store schon irgendwo ein Maximum/high-water? Bes. der ComposedStore<N,L,A>/NodeChunkedStore-Vector-Growth-Pfad (abi_adapter.hpp:64). Ist ein Peak = max(peak, total_bytes_in_use) auf jedem Wachstums-/Alloc-Ereignis ein SAUBERER, minimaler, COW-korrekter Zusatz (EINE Stelle), oder verstreut ueber viele Allokatoren/Pfade? Belege datei:zeile. Ist die Statistik compile-time/Observer-Pattern-konform?`,
  },
  {
    key: 'system-axis-read',
    prompt: `${COMMON}\n\nAufgabe: der Lese-Pfad. Lies ${CE}/libs/cache_engine/include/cache_engine/measurement/system_axis.hpp (bes. MEMORY_FOOTPRINT-Zweig 264-270 + ein funktionierendes Muster wie CLU 254-266 das axis_stats[T][f] liest+validiert). Wie genau wuerde der MEMORY_FOOTPRINT-Zweig aussehen, wenn axis_stats[6][6] den Peak traegt (statt honest-0)? Muss der Slot != 0 UND > bytes_in_use[6][1] sein fuer valid? Zusaetzlich: welche Tests (test_*system_axis* / measurement) asserten den honest-0-Status von MEMORY_FOOTPRINT und muessen mitgezogen werden? grep. Belege datei:zeile.`,
  },
]
const research = await parallel(DIM.map(d => () => agent(d.prompt, { label: `res:${d.key}`, phase: 'Research' })))
const researchText = DIM.map((d, i) => `### ${d.key}\n${research[i] || '(kein Ergebnis)'}`).join('\n\n')

phase('Design')
const DESIGN_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['peak_semantic', 'is_cleanly_buildable', 'edits', 'tests_to_update', 'tabu_neutral_argument', 'honest_0_fallback'],
  properties: {
    peak_semantic: { type: 'string', description: 'Die thesis-kanonische COW-korrekte Peak-Definition (was genau, worueber)' },
    is_cleanly_buildable: { type: 'boolean', description: 'true = EIN sauberer minimaler COW-korrekter Tracking-Punkt + reservierter Slot; false = verstreut/ambig/riskant' },
    edits: { type: 'array', description: 'Exakte Edits (Store-Peak-Tracking + store_allocator_statistics-Feld + abi_adapter r[6] + observable_tier Schema[6][6]-Name + system_axis MEMORY_FOOTPRINT-Zweig)', items: { type: 'object', additionalProperties: false, required: ['file', 'anchor', 'change', 'code'], properties: { file: { type: 'string' }, anchor: { type: 'string' }, change: { type: 'string', enum: ['insert', 'replace'] }, code: { type: 'string' } } } },
    tests_to_update: { type: 'string', description: 'Welche Tests den honest-0-MEMORY_FOOTPRINT-Status asserten (datei:zeile) + wie anzupassen' },
    tabu_neutral_argument: { type: 'string', description: 'Warum golden-320/POD-1416/ABI-4 unberuehrt (reservierter Slot, kein neuer Achsenwert)' },
    honest_0_fallback: { type: 'string', description: 'Falls is_cleanly_buildable=false: warum honest-0 der korrekte Ist-Zustand bleibt (ehrliches Negativ-Ergebnis)' },
  },
}
const design = await agent(
  `${COMMON}\n\nSynthetisiere das EXAKTE, saubere H-2-Design (MEMORY_FOOTPRINT-Peak) aus der Research. WICHTIG: nur wenn ein EINZIGER, minimaler, COW-korrekter Tracking-Punkt existiert + der reservierte Slot [6][6] genutzt wird + die Semantik thesis-kanonisch ist → is_cleanly_buildable=true mit exakten Edits. Wenn die Peak-Semantik ambig ist ODER das Tracking ueber viele Allokatoren/Pfade verstreut/riskant waere ODER ein falscher Peak drohte → is_cleanly_buildable=false + honest_0_fallback begruenden (Anti-Phantom: dann ist honest-0 KORREKT und wir bauen NICHT). Kein Erzwingen.\n\nRESEARCH:\n${researchText}`,
  { label: 'design', phase: 'Design', schema: DESIGN_SCHEMA },
)

phase('Refute')
const REFUTE_SCHEMA = { type: 'object', additionalProperties: false, required: ['refuted', 'issue'], properties: { refuted: { type: 'boolean' }, issue: { type: 'string' } } }
const lenses = [
  'Semantik-Ehrlichkeit: ist der vorgeschlagene Peak thesis-kanonisch + COW-korrekt, oder ein Phantom/irrefuehrender Wert (schlimmer als honest-0)? Trackt er das RICHTIGE (live-Store-Bytes vs. Arena)?',
  'TABU/golden: bricht IRGENDEIN Edit golden-320 / POD sizeof==1416 / ABI-4 / einen Achsenwert? Ist [6][6] wirklich reserviert+frei? Recompiliert nur additiv?',
  'Sauberkeit/Risiko: ist das Peak-Tracking EIN minimaler COW-korrekter Punkt (nicht ueber viele Allokatoren verstreut)? Bricht es COW-Semantik (z.B. shared pages doppelt gezaehlt)? Sind alle honest-0-Tests korrekt mitgezogen?',
]
const dStr = JSON.stringify(design, null, 1)
const verds = await parallel(lenses.map((lens, i) => () => agent(`Adversariale Pruefung des H-2-MEMORY_FOOTPRINT-Peak-Designs, LINSE: "${lens}". Default refuted=true bei Semantik-Zweifel (Anti-Phantom). Lies ${CE} bei Bedarf.\n\nDESIGN:\n${dStr}`, { label: `refute:${i}`, phase: 'Refute', schema: REFUTE_SCHEMA })))

return { design, research: researchText, refutations: verds.filter(Boolean), survives: verds.filter(Boolean).every(v => !v.refuted), buildable: design && design.is_cleanly_buildable && verds.filter(Boolean).every(v => !v.refuted) }
