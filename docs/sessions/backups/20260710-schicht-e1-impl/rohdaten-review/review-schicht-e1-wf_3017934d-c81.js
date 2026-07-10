export const meta = {
  name: 'review-schicht-e1',
  description: 'Adversarialer Schicht-E1-Review (RC-Konsum T6/T8/T1/T11 + A-Fixes)',
  phases: [{ title: 'Find' }, { title: 'Verify' }],
}
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'
const CTX = `KONTEXT: Diplomarbeit cache-engine, Schicht-E1-Increment (UNCOMMITTED, ce main 2a231cf5) = Neuauflage des revertierten #221 (Anti-Vorbild git show 1f9c2eef; Fix-Spec ${SUPER}/docs/sessions/backups/20260709-code-review-phase2-221/SYNTHESE.md A1-A9; Bau-Spec ${SUPER}/docs/sessions/backups/20260710-schicht-e1-impl/CODEX-DOSSIER.md). Diff selbst erheben: git -C ${CE} diff + status (abi_adapter.hpp RC-Block+T1-Timing+T6-Mapping+tier_insert-Gate; observable_tier.hpp Schema-Slots T1[6/7]+T6[5]; axis_08 Blocking/OLC/ReaderWriter/Observable [thread_local->static, try_acquire, contention]; observable_composed_search.hpp Budget-Gate; axis_04-Store; axis_14-VH; NEU tests/unit/test_e1_contract_rc_konsum.cpp + CMake). Honest-0-Doktrin; golden=binary_ids (RC ist dynamisch, darf binary_id nie beruehren). Read-only.`
const FINDINGS = { type: 'object', required: ['findings'], properties: { findings: { type: 'array', items: { type: 'object', required: ['file', 'line', 'title', 'severity', 'scenario'], properties: { file: { type: 'string' }, line: { type: 'integer' }, title: { type: 'string' }, severity: { type: 'string', enum: ['critical', 'major', 'minor'] }, scenario: { type: 'string' } } } } } }
const VERDICT = { type: 'object', required: ['real', 'reason'], properties: { real: { type: 'boolean' }, reason: { type: 'string' } } }
const DIMS = [
  { key: 'mess-semantik-t8-t1', prompt: 'Pruefe adversarial die MESS-SEMANTIK-Aenderungen: (a) T8: Blocking/OLC/ReaderWriter wurden von thread_local-static auf GETEILTE static-Primitive umgestellt, OLC von Read-Validate auf Schreibbit-CAS+yield-Spin, ReaderWriter von lock_shared auf EXKLUSIV — veraendert das die Single-Thread-Pfad-A-Laufzeitcharakteristik so, dass alte/neue Messreihen inkommensurabel werden (W3-Verbot!) oder Strategie-Differenzierung verloren geht (RW==Blocking?)? Ist der static-Mutex ueber MEHRERE Tier-Instanzen im selben Prozess geteilt (Cross-Tier-Contention = Mess-Kontamination zwischen parallel geladenen DLLs/Instanzen?)? Ist OLC-release ohne vorheriges try_acquire (unpaired release) korrekt? (b) T1: t1_segment_shape_ — ist RC=0 wirklich byte-verhaltensgleich zum alten n_ops=max(nk,256)/kBatches=8 (nachrechnen!); visited_keys=n_ops*batch_count korrekt als \"batch_visited\"-Semantik; segment_key_count_for_timing_ Zweige sinnvoll?' },
  { key: 'a-fixes-vollstaendig', prompt: 'Pruefe JEDEN A-Fix (SYNTHESE A1-A9) am Diff: A1 Budget-Gate wirklich NUR im New-Key-insert (erase/migrate/rebuild_/lookup ungegatet — trace!); A2 tier_insert-Return-Gate: liegen VOR dem insert (:828) noch Organ-Treiber (T8 acquire? telemetry?), die bei Reject schon gelaufen sind = Uebergezaehlt?; A4 restore_statistics erhaelt budget_reject?; A5 CSV: werden die neuen Spalten stat_cache_traversal_batch_size/batch_visited/stat_allocator_budget_reject im Header UND in format_csv_row wirklich emittiert (nullptr-Drop-Logik prueft Schema — jetzt benannt, also emittiert; aber: brechen ALTE CSV-Konsumenten/csv_to_latex an den 3 NEUEN Spalten [W3/Spalten-Anzahl-Annahmen]?); A6 reused-Tier: apply{0} nach apply{X} ⇒ Organe erhalten 0 und interpretieren als Default (T7 set_runtime_distance(0) — bedeutet 0 dort wirklich kein Override? axis_07:117-123 pruefen!); A7 Rejection-Zaehler separat + clear()-Reset; A9 Div-by-0-Guards in t1_segment_shape_.' },
  { key: 'test-tabu-golden', prompt: 'Pruefe test_e1_contract_rc_konsum.cpp vollstaendig (Aussagekraft: deckt er die 7 Dossier-§5-Faelle? jthread-Contention-Test deterministisch genug [kein Flake: Sleep/Yield-Robustheit]? CSV-Header-Test prueft echten lazy_csv_header-String?) + CMake-Block (per-Target-Defines, Label e1;rc ohne contract) + Tabus: POD/caps unveraendert (over-caps-apply==5 bleibt? applied-Zaehlung mit neuem apply1), golden_fullpilot/permutation_axes/m3v2 byte-unberuehrt, binary_id-Pfade unberuehrt, 14 honest-0-Achsen + T7 unberuehrt (git diff zeigt KEINE weiteren Achsen-Dateien).' },
]
phase('Find')
const results = await pipeline(
  DIMS,
  d => agent(`${CTX}\n\nDEINE DIMENSION: ${d.prompt}\n\nNur echte Defekte mit konkretem Fehl-Szenario.`, { label: `find:${d.key}`, phase: 'Find', schema: FINDINGS, effort: 'high' }),
  (review, d) => parallel((review?.findings ?? []).slice(0, 6).map(f => () =>
    parallel(['refute', 'reproduce'].map(lens => () =>
      agent(`${CTX}\n\nBehaupteter Defekt: ${f.file}:${f.line} — ${f.title}\nSZENARIO: ${f.scenario}\nLinse: ${lens === 'refute' ? 'REFUTIERE am echten Code (unsicher => real=false).' : 'REPRODUZIERE den Trace vollstaendig; real=true NUR wenn er traegt.'}`, { label: `verify:${f.title.slice(0, 26)}`, phase: 'Verify', schema: VERDICT, effort: 'high' })
    )).then(vs => ({ ...f, dim: d.key, votes: vs.filter(Boolean).map(v => v.real), confirmed: vs.filter(Boolean).filter(v => v.real).length >= 2 }))
  ))
)
const all = results.filter(Boolean).flat().filter(Boolean)
const confirmed = all.filter(f => f.confirmed)
log(`${all.length} Kandidaten, ${confirmed.length} CONFIRMED`)
return { confirmed, plausible: all.filter(f => !f.confirmed && f.votes.some(v => v)), total: all.length }