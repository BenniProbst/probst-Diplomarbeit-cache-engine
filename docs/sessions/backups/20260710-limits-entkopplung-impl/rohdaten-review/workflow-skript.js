export const meta = {
  name: 'review-limits-vorstufe',
  description: 'Adversarialer Review Limits-Entkopplung Vorstufe (Codegen-Tool + Golden-Gates)',
  phases: [{ title: 'Find' }, { title: 'Verify' }],
}
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'
const CTX = `KONTEXT: Limits-Entkopplung VORSTUFE (UNCOMMITTED, ce main 5d67eecd): NEU apps/catalog_codegen_tool/{main.cpp,CMakeLists.txt} (XML-Profil -> generierter Katalog-Header via mp_for_each-Registry + type_name.hpp) + tests/unit/test_limits_entkopplung_vorstufe.cpp (Golden-Gates 1-3) + CMake-Blöcke (add_custom_command -> CMAKE_BINARY_DIR/generated/generated_source_catalog.hpp). Spec: ${SUPER}/docs/plaene/20260710-limits-entkopplung-impl-CODEX-DOSSIER.md + ../20260710-schicht-e3-impl/LIMITS-ENTKOPPLUNG-ANALYSE.md (§3 Risiken!). Referenz: ce tests/unit/thesis_tiere/source_catalog.hpp:77-179 (UNVERÄNDERT zu bleiben), golden_fullpilot_320_binary_ids.txt (nur lesen). Diff selbst erheben. Read-only.`
const FINDINGS = { type: 'object', required: ['findings'], properties: { findings: { type: 'array', items: { type: 'object', required: ['file', 'line', 'title', 'severity', 'scenario'], properties: { file: { type: 'string' }, line: { type: 'integer' }, title: { type: 'string' }, severity: { type: 'string', enum: ['critical', 'major', 'minor'] }, scenario: { type: 'string' } } } } } }
const VERDICT = { type: 'object', required: ['real', 'reason'], properties: { real: { type: 'boolean' }, reason: { type: 'string' } } }
const DIMS = [
  { key: 'reihenfolge-golden', prompt: 'Prüfe die §3-Risiken adversarial: Reihenfolgedrift (respektiert das Tool EXAKT die Profil-Reihenfolge der values UND die kanonische 19-Slot-Reihenfolge — was passiert, wenn das Profil eine Achse in anderer Werte-Reihenfolge listet als die StaticAxisVariants-Liste? Golden verlangt die mp_take_c-Präfix-Ordnung — mappt das Tool Profil-Werte order-preserving aufs Profil ODER auf die Listen-Ordnung, und welche ist golden-korrekt? test_profile_roundtrip:94-145 als Wahrheit), Golden-Zirkularität (liest der Test wirklich die committete Datei?), gepinnte Slots = ERSTES Element (stimmt das gegen mp_take_c<...,1> für ALLE 15?).' },
  { key: 'typnamen-mapping', prompt: 'Prüfe das Namens→Typ-Mapping: type_name.hpp/strip_all_elaborated-Wiederverwendung korrekt (FQ-Namen kompilierbar im generierten Header? Namespace-Kontext des Headers vs. emittierte Namen)? W::name()-Kollisionen zwischen Slots (gleicher Name in 2 Listen)? Duplikat-Werte im Profil = harter Fehler? Cacheline-/Nicht-Slot-refs übersprungen wie build_axis_levels? Unbekannte Achse (ref weder Slot noch cacheline) — Fehler oder still?' },
  { key: 'scope-cmake', prompt: 'Prüfe Scope+Build: source_catalog.hpp/adhoc_emitter/golden/m3v2/profile_run_entry byte-unberührt (git status/diff)? Generierter Header NUR in CMAKE_BINARY_DIR (kein Source-Tree-Write, auch nicht vom Tool bei relativen Pfaden)? add_custom_command-Abhängigkeiten vollständig (Re-Generierung bei Profil-UND-Tool-Änderung)? Test-Target in test:unit CI-aktiv (Label e4;limits, kein contract)? Tool-CMake im apps-Baum konsistent (EXCLUDE_FROM_ALL? wird es im comdare_tests-Fluss gebaut)? Statistics-Define-Abhängigkeit des Tests?' },
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