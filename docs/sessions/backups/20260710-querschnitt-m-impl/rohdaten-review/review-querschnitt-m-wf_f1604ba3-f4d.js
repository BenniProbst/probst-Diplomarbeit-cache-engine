export const meta = {
  name: 'review-querschnitt-m',
  description: 'Adversarialer Querschnitt-M-Review (SystemAxis-Wurzel + CMD-1-b)',
  phases: [{ title: 'Find' }, { title: 'Verify' }],
}
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'
const CTX = `KONTEXT: Diplomarbeit cache-engine, Querschnitt-M-Increment (UNCOMMITTED, ce main e0203341): NEU libs/cache_engine/include/cache_engine/measurement/system_axis.hpp (MeasurementRegime + regime_of ueber 16 Kategorien + CRTP-SystemAxis + Concept + 3 Strategies WallClock/ObserverSnapshot/Pmc; honest-0 inkl. IPC_CPI + Latenz-Perzentile invalidiert) + libs/cache_engine/topics/axis_command_base.hpp (CMD-1-b MeasurementVisitable eingeloest, requires an axis_accept_measurement) + tests/unit/test_m_contract_system_axis_wurzel.cpp + CMake-Endblock (Label m;blut). Diff/Dateien selbst erheben (git -C ${CE} status/diff + neue Dateien vollstaendig). Spec: ${SUPER}/docs/plaene/20260710-querschnitt-m-impl-CODEX-DOSSIER.md. Referenzen: observable_tier.hpp:66-101 (kV3AxisSchema), pmc_source.hpp:19-48, measurement_category.hpp:9-26, thesis 03_messsystem_prtart.tex:382-386 + 06_evaluation_methodology.tex:119-126, anatomy_execution_context.hpp:160-170 (realer axis_accept_measurement-Aufrufer). Read-only.`
const FINDINGS = { type: 'object', required: ['findings'], properties: { findings: { type: 'array', items: { type: 'object', required: ['file', 'line', 'title', 'severity', 'scenario'], properties: { file: { type: 'string' }, line: { type: 'integer' }, title: { type: 'string' }, severity: { type: 'string', enum: ['critical', 'major', 'minor'] }, scenario: { type: 'string' } } } } } }
const VERDICT = { type: 'object', required: ['real', 'reason'], properties: { real: { type: 'boolean' }, reason: { type: 'string' } } }
const DIMS = [
  { key: 'thesis-regime-wahrheit', prompt: 'Pruefe adversarial gegen die THESIS (Design-Quelle!): stimmt die regime_of-Zuordnung aller 16 Kategorien woertlich mit 03:382-386 + 06:119-126 ueberein (bes. ENERGY_J als PMC — traegt die Thesis das? MEMORY_FOOTPRINT als TimeObserver?)? Stimmen die 3 ObserverSnapshot-Slot-Indizes axis_stats[5][3]/[6][1]/[17][4] EXAKT gegen kV3AxisSchema (observable_tier.hpp:66-101 nachzaehlen!)? Ist CLU via memory_layout.cache_lines ein EHRLICHER Proxy fuer Cache-Line-Auslastung oder eine Fehl-Etikettierung? Ist die WallClock-Mittelwert-Semantik (nur LATENCY_MEAN valid, Perzentile invalid) korrekt umgesetzt?' },
  { key: 'zero-cost-concept', prompt: 'Pruefe Metaprogrammierungs-Striktheit: ist SystemAxis wirklich zero-cost (empty base, kein virtual, consteval regime_for_axis — kompiliert der throw-Pfad in consteval sauber bei Regime-Mischung als Fehler)? Ist das MeasurementVisitable-requires an axis_accept_measurement rueckwaertskompatibel mit ALLEN Bestandsaufrufern (anatomy_execution_context.hpp:160-170 + jeder weitere grep-Treffer — kann ein Bestands-Visitor jetzt hart failen, der vorher kompiliert haette)? Include-Pfad-Hygiene: system_axis.hpp mischt <cache_engine/...>-Include mit relativen ../../../-Includes — bricht das in irgendeinem Include-Kontext (Konsumenten ausserhalb libs/cache_engine/include)? CMake-Block korrekt (gtest? der Test nutzt gtest — linkt der Block GTest wie andere gtest-Tests)?' },
  { key: 'organ-system-trennung', prompt: 'Pruefe Schicht-Disziplin: vermischt der Diff Organ-Taxonomie (axis_observer_classification/ObserverAggregate) mit den System-Achsen? Beruehrt er ABI-PODs/perm_runner/golden/m3v2 (git status/diff)? Ist die Blut-Direktive dokumentiert (immer praesent, nicht Gattung)? test_cmd1_a bleibt semantisch identisch gruen?' },
]
phase('Find')
const results = await pipeline(
  DIMS,
  d => agent(`${CTX}\n\nDEINE DIMENSION: ${d.prompt}\n\nNur echte Defekte mit konkretem Fehl-Szenario.`, { label: `find:${d.key}`, phase: 'Find', schema: FINDINGS, effort: 'high' }),
  (review, d) => parallel((review?.findings ?? []).slice(0, 5).map(f => () =>
    parallel(['refute', 'reproduce'].map(lens => () =>
      agent(`${CTX}\n\nBehaupteter Defekt: ${f.file}:${f.line} — ${f.title}\nSZENARIO: ${f.scenario}\nLinse: ${lens === 'refute' ? 'REFUTIERE am echten Code (unsicher => real=false).' : 'REPRODUZIERE den Trace vollstaendig; real=true NUR wenn er traegt.'}`, { label: `verify:${f.title.slice(0, 26)}`, phase: 'Verify', schema: VERDICT, effort: 'high' })
    )).then(vs => ({ ...f, dim: d.key, votes: vs.filter(Boolean).map(v => v.real), confirmed: vs.filter(Boolean).filter(v => v.real).length >= 2 }))
  ))
)
const all = results.filter(Boolean).flat().filter(Boolean)
const confirmed = all.filter(f => f.confirmed)
log(`${all.length} Kandidaten, ${confirmed.length} CONFIRMED`)
return { confirmed, plausible: all.filter(f => !f.confirmed && f.votes.some(v => v)), total: all.length }