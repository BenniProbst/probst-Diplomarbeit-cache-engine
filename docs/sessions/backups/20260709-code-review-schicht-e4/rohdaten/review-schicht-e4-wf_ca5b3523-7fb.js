export const meta = {
  name: 'review-schicht-e4',
  description: 'Adversarialer max-Effort-Review des Schicht-E4-Diffs (profile_facade + RC-XML-Eingang + Contract-Test + super-Dock)',
  phases: [
    { title: 'Find', detail: '5 Dimensions-Finder über den uncommitted Diff' },
    { title: 'Verify', detail: 'je Finding 2 adversariale Lenses' },
  ],
}

const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'

const CTX = `KONTEXT: Diplomarbeit cache-engine. Der UNCOMMITTED Diff in zwei Repos ist der Review-Gegenstand (Schicht E4, Increment 1'/#230 + B4-1):
- ce = ${CE} (git diff HEAD + neue Dateien: libs/cache_engine/profile_facade/{profile_run_facade.hpp,profile_run_facade.cpp,CMakeLists.txt}, tests/unit/test_e4_contract_xml_to_axislevels.cpp, tests/unit/fixtures/e4_contract_profile.xml; geändert: libs/cache_engine/CMakeLists.txt, builder/build_orchestrator/build_orchestrator.hpp [make_gpp_compile_fn + posix_spawnp], builder/experiment_tree/profile_to_tree.hpp [4 neue dyn. AxisLevel], libs/common/serialization/xml_config_parser/xml_config_parser.{hpp,cpp} [4 neue ThesisProfile-Felder], algorithm_profiles/thesis_profiles/SCHEMA.md, tests/unit/CMakeLists.txt [neues contract-Test-Target])
- super = ${SUPER} (git diff: Code/02_messung_driver/main.cpp [opt-in E4-Dock-Block, env-Parsing, try/catch], Code/02_messung_driver/CMakeLists.txt [Fassaden-Link + Default-Profil-Define]).
Erhebe den Diff SELBST via git -C <repo> diff HEAD -- <pfade> und lies die neuen Dateien vollständig. Historischer Hintergrund (Fix-Specs, die der Diff erfüllen MUSS): ${SUPER}/docs/sessions/backups/20260709-code-review-phase1-230/SYNTHESE.md (A1,B1-B5,C1-C3,D1-D3,E1-E3) + ${SUPER}/docs/sessions/backups/20260709-schicht-e4-impl/CODEX-DOSSIER.md (§0 Tabus!). TABU-Verletzungen (permutation_axes.xml, golden_fullpilot_320, ABI-Header/POD, GenusBindingTraits, m3v2_study.profile.xml byte-gleich, Organ-/abi_adapter-Code) wären Findings höchster Schwere. Schicht-Disziplin: Der Diff darf KEINEN RC-Konsum in Organen bauen (das ist Schicht E1).`

const FINDINGS = {
  type: 'object', required: ['findings'],
  properties: { findings: { type: 'array', items: {
    type: 'object', required: ['file', 'line', 'title', 'severity', 'scenario'],
    properties: {
      file: { type: 'string' }, line: { type: 'integer' }, title: { type: 'string' },
      severity: { type: 'string', enum: ['critical', 'major', 'minor'] },
      scenario: { type: 'string', description: 'Konkrete Inputs/Zustand -> falsches Verhalten' },
    } } } },
}
const VERDICT = {
  type: 'object', required: ['real', 'reason'],
  properties: { real: { type: 'boolean' }, reason: { type: 'string' } },
}

const DIMS = [
  { key: 'cmake-build', prompt: 'Prüfe ALLE CMake-Änderungen adversarial: cmake_language(DEFER)-Semantik (feuert es im super-Sub-Build, wo ce via add_subdirectory eingebettet ist? PROJECT_SOURCE_DIR-Bindung korrekt?), Generator-Expression COMDARE_FACADE_PERM_INCLUDES (REMOVE_DUPLICATES/JOIN über TARGET_PROPERTY-Listen — leere Einträge, Semikolon-Escaping, Anführungszeichen im Define), EXCLUDE_FROM_ALL-Folgen, die E3-Härtung (target_include_directories auf fremde Targets — Reihenfolge/Timing, PUBLIC vs INTERFACE), tests/unit-Target (Fixture-Pfad zur Laufzeit, Label-Muster), super-CMakeLists (if(TARGET ...)-Timing relativ zu add_subdirectory-Reihenfolge, COMDARE_CACHE_ENGINE_DIR-Define-Quoting mit Pfad-Sonderzeichen).' },
  { key: 'dock-integrity', prompt: 'Prüfe den super-main.cpp-E4-Dock adversarial gegen die 15 Phase-1-Findings (SYNTHESE.md lesen!): sind B1-B5/C1-C3 WIRKLICH geheilt (nicht nur scheinbar)? Neue Fehlerquellen: e4_overall_rc-Propagation (Spec-Mode vs Fallback — kann ein E4-Fehler einen grünen klassischen Lauf rot machen oder umgekehrt verschluckt werden?), parse_size_env_strict-throw-Pfad (welche env-Kombis brechen den Block VOR dem klassischen Pfad? try/catch-Abdeckung), platform_tag-Fallback-Ehrlichkeit, Default-Thesis-Profil-Pfad (existiert er zur Laufzeit auf CI/anderen Maschinen? COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE zeigt in den Source-Tree), Verhalten wenn COMDARE_RUN_E4_XML!=1 aber andere E4-envs gesetzt.' },
  { key: 'spawn-compile', prompt: 'Prüfe make_gpp_compile_fn + detail::run_argv_redirected + decode_process_status adversarial: rsp-Datei-Quoting (Pfade mit Leerzeichen/Quotes in -I"..."/-o — wie parst gcc @file wirklich?), posix_spawnp-Fehlerpfade (log-open-Fehler, ENOENT-Compiler), EINTR-Loop, fd-Leaks, environ-Deklaration im Header (ODR/Mehrfach-Include), Windows-Fallback shell_safe_token (blockiert er legitime Pfade? cmd-Quoting), Log-Append vs Trunc-Mischung, Wiederverwendung durch bestehende make_system_compile_fn-Konsumenten (Regression?). Und die Fassade profile_run_facade.cpp: split_on-Verhalten, COMDARE_PILOT_INCLUDES-Präzedenz (D2), cxx_compiler-Default g++-16 auf Systemen ohne g++-16.' },
  { key: 'parser-contract', prompt: 'Prüfe Parser+Baum+Test adversarial: text_tokens-Verhalten bei Whitespace/Leerzeichen-only-Elementen (<batch_size> </batch_size> -> leerer Vektor oder [""]?), Reihenfolge-Stabilität der neuen AxisLevels (hängt der Contract-Test an einer Reihenfolge, die anderswo dokumentiert/garantiert ist?), Doppel-Deklaration (prefetch-Achse trägt jetzt 2 dynamische Ebenen hw_prefetcher UND prefetch_distance mit gleicher block_id prefetch — verkraftet ExperimentTree/RuntimeVariableLoop/CSV-Pfad zwei dyn. Ebenen derselben Achse?), golden-Neutralität (binary_id wirklich unberührt? static_filter), Negativ-Fixture-Robustheit (temp_directory_path-Kollisionen, fehlende Cleanup bei Assert-Exit), Verlustfreiheit uint64-Strings (parse_u64 bei nicht-numerisch -> 0 silently).' },
  { key: 'schicht-disziplin', prompt: 'Prüfe Schicht-Disziplin + Tabus + Doku-Konsistenz: berührt der Diff IRGENDWO Organ-Code/abi_adapter/ABI-Header/PODs/GenusBindingTraits/permutation_axes/golden-Dateien (grep im Diff)? Ist m3v2_study.profile.xml byte-gleich (git diff)? SCHEMA.md-Doku vs. tatsächliches Parser-Verhalten konsistent (uint64-Behauptung vs String-Durchreichung)? Namespace-Konventionen (builder::profile_facade vs bestehende), deutsche Kommentare/ue-ae-oe-Stil, Include-Konventionen (profile_run_entry.hpp-Naht: bricht der PRIVATE tests/unit/thesis_tiere-Include-Pfad irgendein anderes Target oder Installations-/Export-Szenario?), EXCLUDE_FROM_ALL vs COMDARE_PAPER_CODEGEN_CONSUMER_TARGETS-Property (Codegen-Ordering).' },
]

phase('Find')
const results = await pipeline(
  DIMS,
  d => agent(`${CTX}\n\nDEINE DIMENSION: ${d.prompt}\n\nArbeite read-only (kein Edit/Write in den Repos). Liefere NUR echte Defekte mit konkretem Fehl-Szenario (Inputs/Zustand -> falsches Verhalten), keine Stil-Nörgelei. Wenn du einen Verdacht nicht am Code belegen kannst, lass ihn weg.`, { label: `find:${d.key}`, phase: 'Find', schema: FINDINGS, effort: 'high' }),
  (review, d) => parallel((review?.findings ?? []).slice(0, 8).map(f => () =>
    parallel(['refute', 'reproduce'].map(lens => () =>
      agent(`${CTX}\n\nEin Finder behauptet folgenden Defekt im Diff:\nDATEI: ${f.file}:${f.line}\nTITEL: ${f.title}\nSZENARIO: ${f.scenario}\n\nDeine Linse: ${lens === 'refute' ? 'REFUTIERE aktiv — lies den echten Code und beweise, dass das Szenario NICHT eintreten kann (Default bei Unsicherheit: real=false).' : 'REPRODUZIERE gedanklich präzise am echten Code — trace das Szenario Schritt für Schritt; real=true NUR wenn der Trace vollständig trägt.'}\nArbeite read-only.`, { label: `verify:${f.title.slice(0, 30)}`, phase: 'Verify', schema: VERDICT, effort: 'high' })
    )).then(vs => ({ ...f, dim: d.key, votes: vs.filter(Boolean), confirmed: vs.filter(Boolean).filter(v => v.real).length >= 2 }))
  ))
)

const all = results.filter(Boolean).flat().filter(Boolean)
const confirmed = all.filter(f => f.confirmed)
const plausible = all.filter(f => !f.confirmed && f.votes.some(v => v.real))
log(`${all.length} Kandidaten, ${confirmed.length} CONFIRMED, ${plausible.length} PLAUSIBLE`)
return { confirmed, plausible, refuted: all.length - confirmed.length - plausible.length }