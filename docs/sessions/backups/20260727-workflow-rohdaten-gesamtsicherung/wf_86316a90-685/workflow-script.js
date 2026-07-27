export const meta = {
  name: 'plan-fehlerklassen',
  description: 'Ultracode-Planungssession Fehlerklassifizierungs-Framework (Task #29) — Design-Vorlage gegen Code + Ledger + Direktiven',
  phases: [
    { title: 'Map', detail: '3 Bereiche parallel: Ist-Fehlerbehandlung · etablierte Direktiven · Taxonomie+Pattern' },
    { title: 'Synth', detail: 'Design-Dossier + offene Entscheidungen synthetisieren' },
  ],
}

const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const LEDGER = `${SUP}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`

const CONTEXT = `
Task #29 (User-Pflicht-Direktive 2026-07-17): "Fehlerklassen und Behandlung sind für ALLE
Achsen → Unterachsen → Algorithmen Pflicht." Anlass: der SIMD/AVX512-Configure-Fehler
(comdare_add_simd_dispatch_test) muss als "Experiment-Planer Compiler-Compiler-Fehler" IM LOG
deklariert werden — NICHT als stiller CMake-Arity-Crash, der die Pipeline reisst. Das Fehlen
einer HW-Erweiterung (AVX512 auf prod2, GPU/FPGA) ist ein ERKENNBARER, klassifizierbarer Zustand.
Zwei etablierte Direktiven (BINDEND):
 (D1) HW-/Compile-Fehlen → Compiler-Compiler-Fehler-Klasse, im Log deklariert, Experiment MISST WEITER.
 (D2) Algo-Fehler → CSV-Zelle "failed" (NICHT null) + Log neben CSV, Harness misst weiter
      (Memory feedback_measurement_failure_visibility_csv_failed_not_null_plus_log).
Doktrin: compile-time-only im Hot-Path (CRTP+Concept, keine vtable, kein Runtime-Switch),
NUR benannte Lehrbuch-Patterns, ce=Framework/super=Definition, Messung NIE als Nullen.
Es ist eine DESIGN-VORLAGE (kein Bau ohne User-Freigabe).
`

const MAP_SCHEMA = {
  type: 'object',
  properties: {
    area: { type: 'string' },
    findings: { type: 'array', items: { type: 'object', properties: {
      point: { type: 'string' }, evidence: { type: 'string' } }, required: ['point','evidence'] } },
    gaps: { type: 'array', items: { type: 'string' } },
    recommendation: { type: 'string' },
  },
  required: ['area','findings','gaps','recommendation'],
}

const AREAS = [
  { key: 'ist_inventory', prompt: `Inventarisiere die IST-Fehlerbehandlung im ce-Repo (${CE}). Grep + lies representative Stellen für: (a) CMake-Configure-Fehler (FATAL_ERROR, message(SEND_ERROR), der comdare_add_simd_dispatch_test-Arity-Crash in tests/unit/CMakeLists.txt), (b) Subprozess-/Compile-Exit-Codes (build_orchestrator.hpp run_argv_redirected :386ff, Codes 125/127; make_gpp_compile_fn), (c) Laufzeit-cerr-Warnung+Fallback-Muster (profile_run_facade.cpp:116-130 perm_extension_hardware_cflags, :125 cerr, active_simd_policy), (d) die "failed"-Zelle im Mess-Harness (grep 'failed' in measurement/ + CSV-Schreibpfad). KERNFRAGE: welche Fehlerbehandlung existiert HEUTE schon (ad-hoc, verstreut) und wo sind die stillen Crashes/Nullen, die D1/D2 verletzen? Nenne datei:zeile.` },
  { key: 'direktiven_realisierung', prompt: `Kartiere WO die zwei bindenden Direktiven heute (teil-)realisiert sind und wo die Lücken klaffen. D1 (HW-/Compile-Fehlen → "Compiler-Compiler-Fehler" im Log, Experiment misst weiter): grep im ${CE} nach der SIMD-Kohärenz-Guard-Logik (GO-3 A1, cmake/isa_features.cmake), der Host-Descriptor/Gate-Achse (hardware_isa_system_axis), COMDARE_HOST_RUNS_*. D2 ("failed"-Zelle statt null + Log): grep measurement_snapshot / CSV-Writer / measured=0 vs failed. Lies im Ledger ${LEDGER} die Abschnitte zu Fehlerklassen (grep 'Fehlerklass','Compiler-Compiler','failed','AVX512'). KERNFRAGE: Ist D1 überhaupt als Klasse existent (Antwort laut Ledger: NEIN, der Layer fehlt) und wie muss der Experiment-Planer (Compiler-Compiler) HW-Fehlen erkennen+loggen statt abzubrechen? Nenne datei:zeile.` },
  { key: 'taxonomie_pattern', prompt: `Entwirf die TAXONOMIE + das benannte Pattern für das Framework. Die Pflicht ist "Fehlerklassen je Achse→Unterachse→Algorithmus". Lies die Achsen-Struktur (${CE}/libs/cache_engine/include/cache_engine/measurement/ceb_system_axis.hpp, compiler_system_axis.hpp, optimization_level_sub_axis.hpp, system_axis.hpp) für den CRTP+Concept-Stil, dem das Framework folgen MUSS. KERNFRAGE: (a) Welche Fehlerklassen-Taxonomie (z.B. HardwareFehlen / CompileKombinationsFehler / RuntimeAlgoFehler / Konfig-/XML-Parse-Fehler)? (b) Welche compile-time vs runtime Grenze (D1 ist Planer/Compile-Zeit = "Compiler-Compiler", D2 ist Runtime-Algo)? (c) Welches BENANNTE Lehrbuch-Pattern trägt die Klassifikation+Behandlung (z.B. compile-time Error-Category-Enum + Policy/Strategy für Behandlung; std::expected/Result-Typ; Chain-of-Responsibility für Fehler-Eskalation)? Bleibe compile-time-only im Hot-Path, keine vtable. Nenne konkrete Andockpunkte datei:zeile.` },
]

phase('Map')
const maps = (await parallel(AREAS.map(a => () =>
  agent(`${a.prompt}\n\nKONTEXT:\n${CONTEXT}`, { label: `map:${a.key}`, phase: 'Map', schema: { ...MAP_SCHEMA }, effort: 'high' })
    .then(r => r ? { ...r, area: r.area || a.key } : null)))).filter(Boolean)

phase('Synth')
const SYN_SCHEMA = {
  type: 'object',
  properties: {
    dossier_markdown: { type: 'string' },
    open_decisions_for_user: { type: 'array', items: { type: 'object', properties: {
      id: { type: 'string' }, question: { type: 'string' }, recommendation: { type: 'string' } },
      required: ['id','question','recommendation'] } },
    proposed_first_increment: { type: 'string' },
    scope_summary: { type: 'string' },
  },
  required: ['dossier_markdown','open_decisions_for_user','proposed_first_increment','scope_summary'],
}

const synInput = maps.map(m => `## ${m.area}\nfindings: ${JSON.stringify(m.findings)}\ngaps: ${JSON.stringify(m.gaps)}\nrec: ${m.recommendation}`).join('\n\n')

const synth = await agent(
  `Du bist der Architektur-Synthesizer für das Fehlerklassifizierungs-Framework (Task #29). Aus den 3 Kartierungen erzeuge ein Design-Dossier (Markdown): Zweck · IST-Lücken (datei:zeile) · SOLL-Taxonomie (Fehlerklassen je Achse→Unterachse→Algorithmus, D1 compile-time/Planer + D2 runtime/Harness) · benanntes Pattern (compile-time-only, CRTP+Concept-konform, keine vtable) · Andockpunkte · ein kleiner, isolierter ERSTER Increment-Vorschlag (was zuerst, golden-/messneutral, testbar) · Verifikation · TABU. REGELN: compile-time-only Hot-Path, nur benannte Lehrbuch-Patterns, Messung nie als Nullen (D1/D2). Sammle die genuin offenen Architektur-Entscheidungen (z.B. Taxonomie-Granularität, std::expected vs Error-Category-Enum, ob D1 als CMake-Layer ODER als C++-Planer-Layer realisiert wird) als open_decisions_for_user mit Empfehlung — löse Grundsatz-Weichen NICHT eigenmächtig. proposed_first_increment = der kleinste sinnvolle Startschritt zur User-Freigabe.\n\nKARTIERUNGEN:\n${synInput}\n\nKONTEXT:\n${CONTEXT}`,
  { label: 'synth:fehlerklassen-dossier', phase: 'Synth', schema: SYN_SCHEMA, effort: 'high' })

return { maps, synth }