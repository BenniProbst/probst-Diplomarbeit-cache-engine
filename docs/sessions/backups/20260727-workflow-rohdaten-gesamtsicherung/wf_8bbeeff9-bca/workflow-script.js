export const meta = {
  name: 'wl31-impl-review',
  description: 'Adversariale Review des #31 E4-XML-Workload-Drive (messreihen_workload.hpp + main.cpp-Verdrahtung + Test) — Korrektheit, R2-Doppelquelle, TABU, Phantom',
  phases: [{ title: 'Review' }, { title: 'Verify' }],
}

const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const FIND = {
  type: 'object', additionalProperties: false, required: ['findings'],
  properties: { findings: { type: 'array', items: {
    type: 'object', additionalProperties: false, required: ['severity', 'file_line', 'summary', 'failure'],
    properties: {
      severity: { type: 'string', enum: ['critical', 'major', 'minor', 'nit'] },
      file_line: { type: 'string' }, summary: { type: 'string' }, failure: { type: 'string' },
    } } } },
}

const CTX =
  `Reviewe den #31 E4-XML-Workload-Drive (super-only, kein ce-Change). Nutze git -C ${SUP} show HEAD + lies die Dateien: ` +
  `${SUP}/Code/02_messung_driver/messreihen_workload.hpp (NEU: liest <workload> je <messreihe> ueber den ce-DOM-Reader ` +
  `comdare::common::xml aus xml_reader.hpp; ycsb_workload_from_string A-F + YCSB_A..F -> optional; workloads_from_root; parse_messreihe_workloads), ` +
  `${SUP}/Code/02_messung_driver/main.cpp (MessreihenSpec +optional<YcsbWorkload> workload; load_messreihen ergaenzt via ce-DOM-Map; ` +
  `Spec-Loop nutzt spec.workload.value_or(YcsbWorkload::C) statt Hartkode), ${SUP}/Code/02_messung_driver/tests/test_messreihen_workload.cpp, ` +
  `${SUP}/Code/02_messung_driver/CMakeLists.txt (Test-Target), ${SUP}/Code/experiment_config/messreihen.xml (optionales <workload> dokumentiert). ` +
  `DESIGN: R1 A-F thesis-kanonisch; R2 messreihe-<workload> autoritativ fuer WorkloadOptions, test_data_sets.xml = getrennter Pfad (KEINE neue Doppelquelle); ` +
  `R3 additiv ausserhalb V31.F. ZWINGEND submodul-CI-konform: KEIN ce-Change, KEIN Submodul-Bump, KEINE super-Regex (nutzt ce-DOM). ` +
  `golden/ABI-orthogonal (Workload = Mess-INPUT). Fehlendes <workload> -> Fallback C (Verhalten unveraendert).`

phase('Review')
const [correctness, integ] = await parallel([
  () => agent(CTX + ` LENS = KORREKTHEIT: Ist das A-F-Mapping korrekt + vollstaendig? Behandelt workloads_from_root id-lose/tag-lose <messreihe> richtig ` +
    `(kein falscher Eintrag)? Ist der value_or(C)-Fallback korrekt (fehlendes Tag == heutiges Verhalten)? Kompiliert main.cpp (Include-Pfad zu xml_reader.hpp ` +
    `via propagiertem experiment_driver-Target; <optional>/<iostream> vorhanden; wg::-Alias)? Kann parse_document auf realer messreihen.xml scheitern/UB? Nur ECHTE Defekte, zitiere datei:zeile.`,
    { label: 'lens:correctness', phase: 'Review', schema: FIND, agentType: 'feature-dev:code-reviewer' }),
  () => agent(CTX + ` LENS = R2-DOPPELQUELLE + TABU + PHANTOM: Fuehrt der zweite XML-Parse (ce-DOM neben dem typisierten load_messreihen) eine echte Doppelquelle ` +
    `ein (lesen sie DIESELBEN Felder inkonsistent?) oder nur disjunkte Tags? Ueberschreibt spec.workload test_data_sets.xml still + falsch (R2)? Verletzt irgendetwas ` +
    `golden/ABI/permutation_axes (Workload muss Mess-INPUT bleiben, KEINE Binary-Achse)? Braucht es doch einen ce-Change/Submodul-Bump (dann waere die ganze Praemisse falsch)? ` +
    `Ist der Workload-Drive ein Phantom (wirkt er real auf die Messung)? Nur ECHTE Defekte, zitiere datei:zeile.`,
    { label: 'lens:r2-tabu', phase: 'Review', schema: FIND, agentType: 'feature-dev:code-reviewer' }),
])

phase('Verify')
const all = [...(correctness?.findings || []), ...(integ?.findings || [])]
const verified = await parallel(all.map((f) => () =>
  agent(`Adversarial VERIFIZIERE gegen den echten Code in ${SUP}. Versuche zu WIDERLEGEN. Finding: ${f.severity} @ ${f.file_line}: ${f.summary} — ${f.failure}. ` +
    `Verdikt CONFIRMED (echter Defekt) oder REFUTED (Fehlannahme). Bei Unsicherheit REFUTED. Zitiere datei:zeile.`,
    { label: `verify:${f.file_line}`, phase: 'Verify',
      schema: { type: 'object', additionalProperties: false, required: ['verdict', 'reason'],
        properties: { verdict: { type: 'string', enum: ['CONFIRMED', 'REFUTED'] }, reason: { type: 'string' } } } })
    .then((v) => ({ ...f, ...v }))))

return { confirmed: verified.filter(Boolean).filter((f) => f.verdict === 'CONFIRMED'),
         refuted: verified.filter(Boolean).filter((f) => f.verdict === 'REFUTED').length }
