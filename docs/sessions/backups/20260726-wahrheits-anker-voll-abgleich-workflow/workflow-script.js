export const meta = {
  name: 'wahrheits-anker-voll-abgleich',
  description: 'ultracode: alle 982 getippten Owner-Nachrichten gegen den persistierten Stand klassifizieren, Deltas wortgenau bergen',
  phases: [
    { title: 'Abgleich', detail: '16 Opus-Leser, je 62 Nachrichten gegen Dossier+Memories+Session-Docs' },
    { title: 'Synthese', detail: 'Dedup, Prioritaet, finale Wahrheits-Anker-Delta-Liste' },
  ],
}
const S = '/tmp/claude-1001/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489/scratchpad/qcmd'
const ROOT = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const REFS =
  'REFERENZ-ANKER (den persistierten Stand VOLLSTAENDIG lesen, BEVOR du klassifizierst):\n' +
  '1. ' + ROOT + '/docs/sessions/20260726-DOSSIER-session-gesamtstand-kompaktierungs-anker.md (349 Z., autoritativ)\n' +
  '2. /home/comdare/.claude/projects/-home-comdare/memory/MEMORY.md (Index; bei Bedarf einzelne verlinkte Memory-Dateien nachschlagen, insbesondere project_20260726_chunk_delta_verlorene_owner_antworten.md, project_achsen_neuordnung_bindende_sortierung_regressionen.md, project_bestandslog_abnahmen_baum_heuristik_stempel.md, project_lager_baeume_xlsx_doktrin.md)\n' +
  '3. ' + ROOT + '/docs/sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md\n' +
  '4. ' + ROOT + '/docs/sessions/20260726-SESSION-layer-modell-antworten-QA-QF-stempel-doktrin.md\n' +
  '5. ' + ROOT + '/docs/sessions/20260726-SESSION-HANDOVER-6-lagerwelle-komplett-abnahmen-struktr.md\n'

const SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['batch', 'eintraege'],
  properties: {
    batch: { type: 'string' },
    eintraege: {
      type: 'array',
      items: {
        type: 'object', additionalProperties: false,
        required: ['nr', 'klasse', 'kurz'],
        properties: {
          nr: { type: 'integer' },
          jsonl_zeile: { type: 'integer' },
          klasse: { enum: ['verankert', 'delta', 'obsolet', 'operativ', 'duplikat'] },
          kurz: { type: 'string' },
          anker: { type: 'string' },
          delta_text: { type: 'string' },
          konsequenz: { type: 'string' },
        },
      },
    },
  },
}

const mk = (b) =>
  'Du bist ein Wahrheits-Anker-Pruefer einer Diplomarbeits-Manager-Session. Der Owner hat ueber viele Kontexte ~982 Nachrichten getippt; durch API-Stoerungen ist unklar, ob ALLE im persistierten Planungs-Stand angekommen sind. Deine Batch-Datei: ' + S + '/batch-' + b + '.txt (Format: "=== NR n | jsonl:z | timestamp ===" + Owner-Klartext).\n\n' +
  REFS + '\n' +
  'AUFGABE: Klassifiziere JEDE Nachricht deines Batches (keine auslassen):\n' +
  '- "verankert": Substanz ist im Referenz-Stand abgedeckt -> anker = wo (Datei/Abschnitt/Memory-Name).\n' +
  '- "delta": planungs- oder architektur-relevante Substanz, die im Referenz-Stand FEHLT oder ihm WIDERSPRICHT -> delta_text = der tragende Owner-Wortlaut (transliteriert ASCII, gekuerzt auf den Kern), konsequenz = was dadurch ungeplant/falsch ist.\n' +
  '- "obsolet": war mal relevant, ist durch SPAETERE Owner-Aussagen oder erledigte Arbeit ueberholt (anker = was es ueberholt).\n' +
  '- "operativ": reine Prozess-/Steuer-Nachricht ohne persistenz-wuerdige Substanz (bitte weiter, commit das, ok, Slash-Commands, Unterbrechungs-Hinweise).\n' +
  '- "duplikat": identischer Text wie eine FRUEHERE Nachricht im selben Batch (nur dann).\n' +
  'MASSSTAB: Der Owner sagt, aufgrund der Systemkomplexitaet sind ALLE Antworten relevant - im Zweifel "delta" statt "verankert". Aber ein Delta braucht SUBSTANZ (eine Regel, ein Entscheid, ein Fakt, eine Praezisierung), nicht nur andere Worte. kurz = 3-10 Worte Inhalt. ASCII-only.'

phase('Abgleich')
const batches = []
for (let i = 1; i <= 16; i++) batches.push(String(i).padStart(2, '0'))
const results = await parallel(batches.map(b => () =>
  agent(mk(b), { label: 'batch-' + b, phase: 'Abgleich', schema: SCHEMA, model: 'opus', effort: 'high' })
))
const ok = results.filter(Boolean)
const all = ok.flatMap(r => r.eintraege.map(e => ({ ...e, batch: r.batch })))
const deltas = all.filter(e => e.klasse === 'delta')
const stats = {}
for (const e of all) stats[e.klasse] = (stats[e.klasse] || 0) + 1
log('Abgleich: ' + all.length + '/982 klassifiziert (' + ok.length + '/16 Batches), Klassen: ' + JSON.stringify(stats) + ', Deltas: ' + deltas.length)

phase('Synthese')
const synth = await agent(
  'Du bist die Synthese eines Wahrheits-Anker-Voll-Abgleichs (982 getippte Owner-Nachrichten gegen den persistierten Stand). Lies zuerst das Dossier ' + ROOT + '/docs/sessions/20260726-DOSSIER-session-gesamtstand-kompaktierungs-anker.md vollstaendig und das Memory /home/comdare/.claude/projects/-home-comdare/memory/project_20260726_chunk_delta_verlorene_owner_antworten.md (die 17 schon eingeplanten Deltas D-01..D-17).\n\n' +
  'Hier ALLE Delta-Funde der 16 Batch-Pruefer (JSON):\n' + JSON.stringify(deltas).slice(0, 90000) + '\n\n' +
  'Statistik aller Klassen: ' + JSON.stringify(stats) + '\n\n' +
  'AUFGABE: (1) Dedupliziere (gleiche Substanz aus mehreren Batches = ein Punkt; gegen D-01..D-17 abgleichen - schon Eingeplantes NICHT erneut listen, nur referenzieren). (2) Pruefe jedes verbleibende Delta kritisch: ist es wirklich unverankert oder hat der Batch-Pruefer den Anker nur nicht gefunden? Bei Unsicherheit als PLAUSIBEL markieren statt streichen. (3) LIEFERE einen ASCII-Report: (a) Vollstaendigkeits-Bilanz (N verankert / N delta / N obsolet / N operativ / N duplikat), (b) die FINALE Delta-Liste als E-01..E-NN, je: Owner-Wortlaut-Kern, Konsequenz, Prioritaet (VOR-TRIGGER / VOR-01.08. / BAND-C / KLAERUNG), (c) Widersprueche zwischen Owner-Aussagen verschiedener Kontexte (falls die Batch-Pruefer welche fanden), (d) 1-Absatz-Antwort auf die Owner-Frage "habe ich jetzt alle 982 wieder?". Max 150 Zeilen.',
  { label: 'synthese', phase: 'Synthese', model: 'opus', effort: 'xhigh' }
)
return { stats, deltaCount: deltas.length, deltas, synthese: synth }