export const meta = {
  name: 'review-schicht-e2',
  description: 'Adversarialer Schicht-E2-Review (Kommentar-Wahrheit + ABI-Contract-Test)',
  phases: [{ title: 'Find' }, { title: 'Verify' }],
}
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'
const CTX = `KONTEXT: Diplomarbeit cache-engine, Schicht-E2-Increment (UNCOMMITTED, ce main 08322478): (a) Paket A = reine KOMMENTAR-Korrekturen in 11 Dateien (stale search_organ_-Behauptungen -> vollzogener #188-4c-Zustand; git -C ${CE} diff -- libs/ tests/unit/test_188* tests/unit/test_m8* tests/unit/test_pathb* selbst erheben); (b) Paket B = NEU tests/unit/test_e2_contract_abi_vertrag.cpp + CMake-Endblock (Label e2;abi, nutzt bestehendes Wormhole-DLL-Target). Spec: ${SUPER}/docs/plaene/20260710-schicht-e2-impl-CODEX-DOSSIER.md. Referenz: abi_adapter.hpp:212-237 (caps/apply), anatomy_module_loader.hpp, Doc 30:307-329 (honest-0). Read-only.`
const FINDINGS = { type: 'object', required: ['findings'], properties: { findings: { type: 'array', items: { type: 'object', required: ['file', 'line', 'title', 'severity', 'scenario'], properties: { file: { type: 'string' }, line: { type: 'integer' }, title: { type: 'string' }, severity: { type: 'string', enum: ['critical', 'major', 'minor'] }, scenario: { type: 'string' } } } } } }
const VERDICT = { type: 'object', required: ['real', 'reason'], properties: { real: { type: 'boolean' }, reason: { type: 'string' } } }
const DIMS = [
  { key: 'kommentar-wahrheit', prompt: 'Prüfe JEDE geänderte Kommentar-Zeile (git diff) adversarial auf FACHLICHE Wahrheit gegen den echten Code: behauptet ein neuer Kommentar etwas, das der Code NICHT hergibt (z. B. container_algorithm_ als Träger — existiert das Member wirklich und trägt es für ALLE Familien? rollbackable_tier-Memento-Aussagen vs. reale Deckung)? Ist irgendwo doch eine CODE-Zeile geändert (nicht nur Kommentar)? Sind Umlaute/Stil konsistent (ue/ae/oe)?' },
  { key: 'contract-test', prompt: 'Prüfe test_e2_contract_abi_vertrag.cpp + CMake-Block adversarial: apply-Status==5-Annahme korrekt (abi_adapter apply1-Zählung — was zählt als applied bei over-caps-Klammerung? nullptr==0?)? static_cast<IDriveableTier*> aus IObservableTier legitim (Vererbung observable_tier.hpp:170)? DLL-Pfad-Define/add_dependencies korrekt verdrahtet (Target-Name, $<TARGET_FILE>)? Läuft der Test wirklich in test:unit (Label e2;abi, kein -LE-Ausschluss; wird die Wormhole-DLL im comdare_tests-Aggregat mitgebaut)? Tabus: golden/m3v2/permutation_axes/PODs unberührt (git status)?' },
]
phase('Find')
const results = await pipeline(
  DIMS,
  d => agent(`${CTX}\n\nDEINE DIMENSION: ${d.prompt}\n\nNur echte Defekte mit konkretem Fehl-Szenario.`, { label: `find:${d.key}`, phase: 'Find', schema: FINDINGS, effort: 'high' }),
  (review, d) => parallel((review?.findings ?? []).slice(0, 5).map(f => () =>
    parallel(['refute', 'reproduce'].map(lens => () =>
      agent(`${CTX}\n\nBehaupteter Defekt: ${f.file}:${f.line} — ${f.title}\nSZENARIO: ${f.scenario}\nLinse: ${lens === 'refute' ? 'REFUTIERE am echten Code (unsicher => real=false).' : 'REPRODUZIERE den Trace vollständig; real=true NUR wenn er trägt.'}`, { label: `verify:${f.title.slice(0, 26)}`, phase: 'Verify', schema: VERDICT, effort: 'high' })
    )).then(vs => ({ ...f, dim: d.key, votes: vs.filter(Boolean).map(v => v.real), confirmed: vs.filter(Boolean).filter(v => v.real).length >= 2 }))
  ))
)
const all = results.filter(Boolean).flat().filter(Boolean)
const confirmed = all.filter(f => f.confirmed)
log(`${all.length} Kandidaten, ${confirmed.length} CONFIRMED`)
return { confirmed, plausible: all.filter(f => !f.confirmed && f.votes.some(v => v)), total: all.length }