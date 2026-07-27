export const meta = {
  name: 'nach-pruefung-inc29-namensfalle',
  description: 'NACH-Prüfung (VOR+NACH-Direktive): adversariale Konformitäts-Verifikation INC-29 + Namensfalle gegen Plan + Sweep-Befunde',
  phases: [{ title: 'Prüfen', detail: 'je Increment adversarial' }, { title: 'Verdikt', detail: 'kombiniert' }],
}
const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const SCH = { type: 'object', properties: {
  increment: { type: 'string' }, verdikt: { type: 'string', enum: ['KONFORM','ABWEICHUNG'] },
  befunde: { type: 'array', items: { type: 'object', properties: {
    problem: { type: 'string' }, beleg: { type: 'string' }, fix: { type: 'string' }, schwere: { type: 'string' } },
    required: ['problem','beleg','fix','schwere'] } }, zusammenfassung: { type: 'string' } },
  required: ['increment','verdikt','befunde','zusammenfassung'] }

phase('Prüfen')
const [inc29, namensfalle] = await parallel([
  () => agent(`NACH-Prüfung INC-29 (committet ce 5e47f009). ADVERSARIAL: hat es die 2 KRITISCH-Sweep-Befunde WIRKLICH behoben,
ohne Regression? Lies ${CE}/libs/cache_engine/include/cache_engine/measurement/axis_error.hpp (InfraErrorClass/ErrorDomain/
BuildError/error_domain/Policies) + ${CE}/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp (outcome-Typ +
Exit-Mapping ~:325-338) + ${CE}/libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp (D1-Log ~:749-758)
+ ${CE}/cmake/isa_features.cmake (alle FATAL_ERROR weg?). PRÜFE: (1) werden Infra-Codes (125/127/<0) NIE mehr als D1
(ToolchainFehlt/CompileKombination) verbucht? (2) ALLE 7 isa_features-FATAL_ERROR → WARNING+Skip (grep FATAL_ERROR muss 0 sein)?
(3) golden-/ABI-neutral (kein kCompositionAxisNames-/POD-Touch)? (4) compile-time-only, keine vtable, benannte Patterns korrekt?
(5) wird SampleStatus-Split ehrlich als OFFEN (INC-29.3) geführt, nicht falsch als fertig? Finde JEDE Restlücke.`,
    { label: 'nach:INC-29', phase: 'Prüfen', schema: { ...SCH }, effort: 'high' }),
  () => agent(`NACH-Prüfung Namensfalle (committet ce 538b0758). ADVERSARIAL: ist der Rename OptO*SubAxis→OptO*Option VOLLSTÄNDIG
+ semantisch unschädlich? grep im ce-Repo (${CE}, inkl. tools/apps, NICHT nur die 4 bekannten Dateien) nach Rest-'OptO[0-9a-z]*SubAxis'
und 'DefaultOptLevelSubAxis' (muss 0 sein). PRÜFE: (1) blieb die EINE Unter-Achse OptimizationLevelSubAxis + ihr Concept UNBENANNT?
(2) sind die serialisierten opt_level_id-Strings ('O0'..'Ofast') + gcc/clang/msvc-Flags UNVERÄNDERT (→ golden==320 byte-identisch)?
(3) irgendein Consumer/generierter Code/Katalog, der die alten Namen erwartet? (4) ist DefaultOptLevelOption korrekt der Alias auf
OptO3Option (O3-Default-Ruling)? Finde jede übersehene Referenz oder semantische Drift.`,
    { label: 'nach:Namensfalle', phase: 'Prüfen', schema: { ...SCH }, effort: 'high' }),
])

phase('Verdikt')
const V = { type: 'object', properties: {
  gesamt: { type: 'string', enum: ['BEIDE KONFORM','NACHBESSERN'] },
  offene_fixes: { type: 'array', items: { type: 'string' } }, freigabe_naechster_schritt: { type: 'boolean' } },
  required: ['gesamt','offene_fixes','freigabe_naechster_schritt'] }
const verdikt = await agent(
  `Kombiniertes NACH-Verdikt über INC-29 + Namensfalle. Beide KONFORM → freigabe_naechster_schritt=true (weiter zu INC-1a).
Sonst offene_fixes listen (kritisch zuerst).\n\nINC-29: ${JSON.stringify(inc29)}\n\nNAMENSFALLE: ${JSON.stringify(namensfalle)}`,
  { label: 'verdikt', phase: 'Verdikt', schema: V, effort: 'medium' })
return { inc29, namensfalle, verdikt }