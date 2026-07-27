export const meta = {
  name: 'opt-arch-clarify',
  description: 'A1/A2-Architektur-Klärung: O3-Default nichts-gepinnt + Fehler-Exception + builder/measurement-Hybrid-Layering',
  phases: [
    { title: 'Understand', detail: '3 parallele Kartierungen: A1-Plan-Neulesung · A2-Architektur-Ist · A2-Hybrid-Entwurf' },
    { title: 'Synthesize', detail: 'konsolidiertes Design-Ruling + konkrete Bau-Schritte' },
  ],
}

const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const LEDGER = `${SUP}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`
const FACADE = `${CE}/libs/cache_engine/profile_facade/profile_run_facade.cpp`
const ORCH = `${CE}/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp`
const RUNNER = `${CE}/libs/cache_engine/builder/experiment_tree/perm_runner.hpp`
const AXERR = `${CE}/libs/cache_engine/include/cache_engine/measurement/axis_error.hpp`

const RULINGS = `
USER-RULINGS (verbindlich, 2026-07-18):
- A1: CEB-Default = -O3 (NICHT -O2, NICHT Ofast; O3 ist IEEE-754-deterministisch, Ofast nicht). ABER: der Ledger
  verbietet GLOBALES FESTSETZEN — "alle Teile sind beweglich". Mein bisheriger O2-Signatur-Default war ein
  falscher globaler Pin. Korrekt: O3 ist nur der bewegliche Default-Startwert; XML/Planer/env bewegen JEDES Teil.
  Tier-Binary-Builds DUERFEN fehlschlagen -> von CEB GELOGT + per EXCEPTION gefangen (D1/D2-Fehlerklassen,
  Harness misst weiter). Ziel = Option B (golden-Reihe deterministisch, Ofast/andere additiv).
- A2: Der Builder fuehrt eigentlich die Messung durch (perm_runner in builder/experiment_tree) und greift dabei
  "nach unten" (measurement/). Das riecht nach Layering-Verstoss. Die Aufloesung soll ein HYBRID aus
  (1) build_orchestrator-greift-hoch-nach-CompilerSystemAxis und (2) Facade-reicht-runter-als-Parameter sein.
- A3: opt_level als XML-LISTE/Range je Experiment, per spezifischer Tier-Binary oder als gegeneinander antretende
  Optimierungs-Ranges.
`

const MAP_SCHEMA = {
  type: 'object',
  properties: {
    area: { type: 'string' },
    findings: { type: 'array', items: { type: 'object', properties: {
      point: { type: 'string' }, evidence: { type: 'string' } }, required: ['point','evidence'] } },
    recommendation: { type: 'string' },
    risks: { type: 'array', items: { type: 'string' } },
  },
  required: ['area','findings','recommendation','risks'],
}

const AREAS = [
  { key: 'a1_plan_reread', prompt: `A1: Lies den Ledger ${LEDGER} zu "nichts gepinnt / alle Teile beweglich / globales Festsetzen verboten" (grep 'gepinnt','beweglich','global','pinned','JEDES TEIL','OF-2') UND meinen opt-c-Code in ${FACADE} (active_opt_level():168ff, perm_opt_level_cflags(), system_axes_version_suffix()). KERNFRAGE: (a) Ist mein Facade-Default "O2" ein verbotener GLOBALER PIN? (b) Wie sieht der KORREKTE Ansatz aus: Default-Startwert O3 (IEEE-deterministisch), aber KEIN harter Pin — alles XML/Planer/env-beweglich? Wo genau kommt der O3-Default her (DefaultOptLevelSubAxis ist heute Ofast — muss ein NEUES OptO3-Default-Alias her, oder liest active_opt_level() O3 als Startwert, XML-ueberschreibbar)? (c) Wie werden Tier-Binary-BUILD-Fehlschlaege (z.B. eine Achsen-Kombo, die der Compiler ablehnt) von CEB GELOGT + per Exception gefangen (D1 CompilerCompilerErrorClass aus ${AXERR}; Harness misst weiter statt Absturz)? Nenne datei:zeile + einen konkreten Umsetzungs-Spec.` },
  { key: 'a2_architecture_ist', prompt: `A2: Beschreibe die AKTUELLE Architektur der Bau-/Mess-/Achsen-Schichten. Kartiere die Include-/Abhaengigkeits-Richtung zwischen: (i) builder/ (build_orchestrator ${ORCH} = baut DLLs; experiment_tree/perm_runner ${RUNNER} = MISST je Binary), (ii) measurement/ (CompilerSystemAxis/OptimizationLevelSubAxis/axis_error = die System-Achsen + Fehlerklassen), (iii) profile_facade/ (die Umbrella-Fassade). Grep welche Richtung Includes laufen (builder->measurement? facade->beide? measurement->builder?). KERNFRAGE (User-Verdacht): "der Builder fuehrt eigentlich die Messung durch und greift dabei nach unten" — ist das ein Layering-Verstoss? Wer ist WIRKLICH oben/unten? Ist perm_runner (Messung) im builder-Layer eine Fehlplatzierung? Nenne datei:zeile + eine ehrliche Ist-Beschreibung (fuer den User).` },
  { key: 'a2_hybrid_design', prompt: `A2-Hybrid: Entwirf die Aufloesung als HYBRID aus (1) build_orchestrator-greift-hoch-nach-measurement und (2) Facade-reicht-runter-als-Parameter. KONTEXT: opt-b/opt-c haben Muster (2) etabliert (Facade rechnet Flags, uebergibt sie als Param an make_gpp_compile_fn). opt-d/D1-Carrier braeuchten Muster (1) (build_orchestrator liest CompilerSystemAxis::supports_fno_gnu_unique / klassifiziert Compile-Fehler als CompilerCompilerErrorClass). KERNFRAGE: Welche Wissens-Teile gehoeren SAUBER nach unten-gereicht (Facade->Builder als Param: opt_flag, link_libs, fno-gnu-unique-bool) und welche darf der Builder LEGITIM hoch-fragen (die Leaf-Enum axis_error.hpp fuer die Fehler-KLASSIFIKATION der eigenen Compile-/Mess-Fehler)? Ist die Trennung "Builder darf measurement-LEAF-Enums (axis_error) inkludieren, aber NICHT das Achsen-FRAMEWORK (CebSystemAxis/CRTP) — das reicht die Facade als Param runter" ein sauberer Hybrid? Bewerte gegen Baseline-Layering-in-Stein + sauberster-Weg. Nenne datei:zeile + die konkrete Regel.` },
]

phase('Understand')
const maps = (await parallel(AREAS.map(a => () =>
  agent(`${a.prompt}\n\n${RULINGS}`, { label: `map:${a.key}`, phase: 'Understand', schema: { ...MAP_SCHEMA }, effort: 'high' })
    .then(r => r ? { ...r, area: r.area || a.key } : null)))).filter(Boolean)

phase('Synthesize')
const SYN_SCHEMA = {
  type: 'object',
  properties: {
    architecture_description: { type: 'string' },
    a1_ruling: { type: 'string' },
    a2_hybrid_ruling: { type: 'string' },
    build_steps: { type: 'array', items: { type: 'object', properties: {
      id: { type: 'string' }, what: { type: 'string' }, files: { type: 'string' }, golden_neutral: { type: 'boolean' } },
      required: ['id','what','files','golden_neutral'] } },
    open_risks: { type: 'array', items: { type: 'string' } },
  },
  required: ['architecture_description','a1_ruling','a2_hybrid_ruling','build_steps','open_risks'],
}

const synInput = maps.map(m => `## ${m.area}\nfindings: ${JSON.stringify(m.findings)}\nrec: ${m.recommendation}\nrisks: ${JSON.stringify(m.risks)}`).join('\n\n')

const synth = await agent(
  `Du bist der Architektur-Synthesizer. Aus den 3 Kartierungen konsolidiere: (a) architecture_description = eine KLARE, ehrliche Beschreibung der Ist-Architektur (Bau/Mess/Achsen-Schichten + Include-Richtung) FUER DEN USER; (b) a1_ruling = der korrekte opt_level-Ansatz (O3-Default beweglich, NICHTS global gepinnt, XML/Planer/env bewegt alles, Tier-Binary-Fehler -> D1-klassifiziert geloggt + Exception-gefangen, Harness misst weiter); (c) a2_hybrid_ruling = die saubere Hybrid-Regel (was Facade-runter-reicht vs. was Builder-legitim-hoch-fragt, Leaf-Enum vs Achsen-Framework); (d) build_steps = die konkrete, geordnete Bau-Liste unter dem User-Vollen-GO (opt-c-Default-Korrektur O2->O3-beweglich, opt-d+D1-Carrier per Hybrid, opt-f XML-Liste/Range, opt-g Planer-Permutation, Tier-Binary-Fehler-Exception-Handling), je golden_neutral-Flag. compile-time-only Hot-Path, benannte Patterns, Messdaten nie loeschen, golden-Regenerierung messdaten-erhaltend nur wo noetig.\n\nKARTIERUNGEN:\n${synInput}\n\n${RULINGS}`,
  { label: 'synth:ruling', phase: 'Synthesize', schema: SYN_SCHEMA, effort: 'high' })

return { maps, synth }