export const meta = {
  name: 'diplomarbeit-letzte-15-sessions',
  description: 'Die letzten 15 Session-Dokumente der Diplomarbeit vollständig einlesen und synthetisieren',
  phases: [
    { title: 'Einlesen', detail: '5 parallele Leser über je 3-4 Session-Docs' },
    { title: 'Synthese', detail: 'Matrix-relevante Direktiven + offene Fäden konsolidieren' },
  ],
}

const S = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions'
const D = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs'

const READER_SCHEMA = {
  type: 'object',
  properties: {
    kernpunkte: { type: 'array', items: { type: 'string' }, description: 'Wichtigste Erkenntnisse/Entscheidungen je Dokument (mit Datei-Kurzname als Präfix)' },
    offene_faeden: { type: 'array', items: { type: 'string' }, description: 'Noch offene Punkte/TODOs/Gates aus diesen Dokumenten (mit Nummern)' },
    matrix_modul_relevanz: { type: 'array', items: { type: 'string' }, description: 'ALLES was Matrix-Struktur, Modul-Extraktion (#256/#274), Baseline-System, comdare-Module, Wiederverwendung betrifft' },
    fallstricke: { type: 'array', items: { type: 'string' }, description: 'Dokumentierte Fallstricke/Lektionen, die künftige Arbeit betreffen' },
  },
  required: ['kernpunkte', 'offene_faeden', 'matrix_modul_relevanz', 'fallstricke'],
}

phase('Einlesen')
const batches = [
  { label: 'sessions-18-20', files: [
    `${S}/20260702-SESSION-ENDE-18-fable5-manager-modus-deg1-w0-w1-done-234K-inflight.md`,
    `${S}/20260702-SESSION-ENDE-19-w2-fanout-f1-f4-done-node-shape-real-4a-option-b-entschieden.md`,
    `${S}/20260702-SESSION-ENDE-20-4a-done-211-verworfen-4c-strecke-cmd-direktiven-4c0b-pipeline-pending.md`,
  ]},
  { label: 'sessions-21-22b', files: [
    `${S}/20260703-SESSION-ENDE-21-188-4c-KOMPLETT-spiegel-eliminiert-containeralgorithm.md`,
    `${S}/20260703-SESSION-ENDE-21b-ADDENDUM-lint-pflicht-strecke-diagnose-und-fahrplan.md`,
    `${S}/20260703-SESSION-ENDE-22-lint-pflicht-komplett-goal-parallelstrategie-4-kartierungen.md`,
    `${S}/20260703-SESSION-ENDE-22b-ADDENDUM-GO-erhalten-worktree-lektion-216h2-neu.md`,
  ]},
  { label: 'sessions-23-fullcopy-plan', files: [
    `${S}/20260703-SESSION-ENDE-23-ledger-erstellt-ultracode-validiert-193B-umgesetzt.md`,
    `${S}/20260703-SESSION-FULL-COPY-lint-pflicht-runner-goal-parallelstrategie.md`,
    `${S}/20260703-MASTER-EXECUTION-PLAN-goal-gesamtumfang.md`,
  ]},
  { label: 'sessions-24-26-infra', files: [
    `${S}/20260704-SESSION-ENDE-24-goal-ledger-6-increments-217-2a-AP7a-AP3.md`,
    `${S}/20260704-SESSION-ENDE-25-goal-AP5-AP4-DONE-AP6-scoped-codex-envfix.md`,
    `${S}/20260704-SESSION-ENDE-26-goal-AP5-AP4-DONE-AP6-revised-pipeline-first.md`,
    `${S}/20260704-HANDOVER-INFRA-gitlab-connectivity-pipeline-green-blocker.md`,
  ]},
  { label: 'sessions-0705', files: [
    `${S}/20260705-268-CMD2-RESERVE-PRUEFUNG-BERICHT.md`,
    `${S}/20260705-HANDOVER-INFRA-PAKET-HO-1-12.md`,
    `${S}/20260705-SESSION-BEP-ABT-1-SETUP-PLUGINS-MEMORIES-UMGEBUNG-vor-reboot.md`,
    `${S}/20260705-SESSION-HANDOVER-goalv2-audit-restore-ci-s7-ap7b.md`,
    `${D}/HANDOVER-ANHANG-TODO-BOARD-20260705.md`,
  ]},
]

const results = await parallel(batches.map(b => () =>
  agent(`Lies diese Diplomarbeit-Session-Dokumente VOLLSTÄNDIG (jede Datei komplett, keine Auszüge):
${b.files.map((f, i) => `${i + 1}. ${f}`).join('\n')}

Kontext: Wir rekonstruieren den vollen Arbeitskontext der letzten 15 Sessions. Besonders wichtig ist ALLES zu: comdare Matrix-Struktur / Baseline-System (baseline_0..N, INV-1..4), Modul-Extraktion (#256, #274, #265, #266), bestehende comdare-*-all-Module und deren Wiederverwendung, Product/Research-Verlinkung, Namespace-/Include-Konventionen. Antworte auf Deutsch, präzise, mit Task-/Commit-Nummern.`, { label: b.label, phase: 'Einlesen', schema: READER_SCHEMA })
))

phase('Synthese')
const clean = results.filter(Boolean)
const synth = await agent(`Du bekommst strukturierte Zusammenfassungen der letzten 15 Diplomarbeit-Sessions (5 Leser). Konsolidiere sie zu EINEM Lagebild auf Deutsch:

${JSON.stringify(clean, null, 2)}

Liefere:
1. Chronologischer roter Faden (was geschah 02.07.–05.07., in 10-15 Sätzen)
2. ALLE Matrix-/Modul-/Baseline-relevanten Direktiven und Entscheidungen konsolidiert (dedupliziert, mit Quellen-Session)
3. Die 10 wichtigsten noch offenen Fäden (mit Nummern, priorisiert nach Goal-V2-Reihenfolge)
4. Die 10 wichtigsten Fallstricke für die weitere Arbeit`, {
    label: 'synthese', phase: 'Synthese', schema: {
      type: 'object',
      properties: {
        roter_faden: { type: 'string' },
        matrix_direktiven: { type: 'array', items: { type: 'string' } },
        offene_faeden_top10: { type: 'array', items: { type: 'string' } },
        fallstricke_top10: { type: 'array', items: { type: 'string' } },
      },
      required: ['roter_faden', 'matrix_direktiven', 'offene_faeden_top10', 'fallstricke_top10'],
    },
  })

return { synth, leser: clean }