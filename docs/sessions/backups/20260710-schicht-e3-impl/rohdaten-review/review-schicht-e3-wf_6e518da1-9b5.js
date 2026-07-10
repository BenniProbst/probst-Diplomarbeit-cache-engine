export const meta = {
  name: 'review-schicht-e3',
  description: 'Adversarialer Schicht-E3-Review (Gate-Beweis-Test + Bijektions-Contract + Limits-Analyse)',
  phases: [
    { title: 'Find', detail: '3 Dimensions-Finder über den uncommitted E3-Diff' },
    { title: 'Verify', detail: 'je Finding 2 adversariale Lenses' },
  ],
}

const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'

const CTX = `KONTEXT: Diplomarbeit cache-engine, Schicht-E3-Increment (UNCOMMITTED): ce NEU tests/unit/test_e3_contract_conformance_gate_wirksam.cpp (#223-Beweis: run_observable_perm gated nicht-konforme Tiere) + tests/unit/test_e3_contract_binary_id_bijektion.cpp (StaticBinaryView-Bijektion) + tests/unit/CMakeLists.txt (2 Target-Blöcke am Ende) + super NEU docs/sessions/backups/20260710-schicht-e3-impl/LIMITS-ENTKOPPLUNG-ANALYSE.md. Spec: ${SUPER}/docs/sessions/backups/20260710-schicht-e3-impl/CODEX-DOSSIER.md. Erhebe den Diff selbst (git -C ${CE} diff HEAD -- tests/unit/CMakeLists.txt + die neuen Dateien vollständig lesen). Referenz-Code: ce libs/cache_engine/builder/experiment_tree/perm_runner.hpp:130-164 (Gate), experiment_tree.hpp:235-324 (StaticBinaryView), pruef_dock/conformance_gate.hpp. Tabus: golden/permutation_axes/m3v2/ABI unberührt (git status prüfen!). Read-only.`

const FINDINGS = { type: 'object', required: ['findings'], properties: { findings: { type: 'array', items: {
  type: 'object', required: ['file', 'line', 'title', 'severity', 'scenario'],
  properties: { file: { type: 'string' }, line: { type: 'integer' }, title: { type: 'string' },
    severity: { type: 'string', enum: ['critical', 'major', 'minor'] }, scenario: { type: 'string' } } } } } }
const VERDICT = { type: 'object', required: ['real', 'reason'], properties: { real: { type: 'boolean' }, reason: { type: 'string' } } }

const DIMS = [
  { key: 'test-aussagekraft', prompt: 'Prüfe adversarial, ob die beiden Tests WIRKLICH beweisen, was sie behaupten: Deckt der Gate-Test den echten Voll-Lauf-Pfad (run_lazy_static_then_dynamic nutzt run_observable_perm UND run_workload_perm — deckt der Test beide? Ist der workload-Pfad ungetestet = Lücke?). Kann das WrongValue-Double das Gate zufällig BESTEHEN (RF-Fälle/Random-Ops deterministisch mit seed=42? lookup+1-Verfälschung sicher erkannt?)? Bijektions-Test: prüft er flat_index-Randfälle (letzter Index, size==1-Level, leere Levels)? Sind die Signatur-Fixpunkte view[0..11] gegen die ECHTE Odometer-Ordnung von StaticBinaryView verifiziert (least-significant = letztes Level?) — lies experiment_tree.hpp:256-288 und rechne nach.' },
  { key: 'ci-cmake', prompt: 'Prüfe die 2 neuen CMake-Blöcke: laufen die Tests wirklich in ce test:unit (Labels e3;gate / e3;tree — kein -LE-Ausschluss, kein nötiges -R)? Include-Dirs vollständig (perm_runner zieht welche transitiven Header — reicht libs/cache_engine + include + libs/common OHNE Link-Libraries? Der Gate-Test linkt NICHTS — header-only ok? conformance_gate/perm_runner header-only verifizieren). comdare_set_platform_defines vorhanden; COMDARE_TEST_TARGETS-Aggregat; Kollision der ctest-Nummern/Namen; baut comdare_tests das Target mit?' },
  { key: 'schicht-tabu', prompt: 'Prüfe Schicht-Disziplin + Tabus: berührt der Diff Produktiv-Code (perm_runner/conformance_gate/experiment_tree dürfen NICHT editiert sein — git diff)? golden_fullpilot_320/m3v2/permutation_axes byte-unberührt (git status)? Die LIMITS-ENTKOPPLUNG-ANALYSE.md: enthält sie NUR Analyse (keinen Code-Auftrag, der Tabus bricht)? Sind ihre Aussagen zu CatalogAxes-Konsumenten/golden-Kopplung korrekt (stichprobenartig gegen source_catalog.hpp:77-121 prüfen)? IObservableTier-Interface im Test vollständig/korrekt implementiert (alle pure virtuals, noexcept-Signaturen exakt wie anatomy/observable_tier.hpp)?' },
]

phase('Find')
const results = await pipeline(
  DIMS,
  d => agent(`${CTX}\n\nDEINE DIMENSION: ${d.prompt}\n\nNur echte Defekte mit konkretem Fehl-Szenario; keine Stil-Nörgelei.`, { label: `find:${d.key}`, phase: 'Find', schema: FINDINGS, effort: 'high' }),
  (review, d) => parallel((review?.findings ?? []).slice(0, 6).map(f => () =>
    parallel(['refute', 'reproduce'].map(lens => () =>
      agent(`${CTX}\n\nBehaupteter Defekt:\nDATEI: ${f.file}:${f.line}\nTITEL: ${f.title}\nSZENARIO: ${f.scenario}\n\nLinse: ${lens === 'refute' ? 'REFUTIERE aktiv am echten Code (Default bei Unsicherheit: real=false).' : 'REPRODUZIERE den Trace vollständig am echten Code; real=true NUR wenn er trägt.'}`, { label: `verify:${f.title.slice(0, 28)}`, phase: 'Verify', schema: VERDICT, effort: 'high' })
    )).then(vs => ({ ...f, dim: d.key, votes: vs.filter(Boolean).map(v => v.real), confirmed: vs.filter(Boolean).filter(v => v.real).length >= 2 }))
  ))
)

const all = results.filter(Boolean).flat().filter(Boolean)
const confirmed = all.filter(f => f.confirmed)
const plausible = all.filter(f => !f.confirmed && f.votes.some(v => v))
log(`${all.length} Kandidaten, ${confirmed.length} CONFIRMED, ${plausible.length} PLAUSIBLE`)
return { confirmed, plausible, total: all.length }