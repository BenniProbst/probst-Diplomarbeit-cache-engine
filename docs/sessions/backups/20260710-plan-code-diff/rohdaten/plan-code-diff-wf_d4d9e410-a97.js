export const meta = {
  name: 'plan-code-diff',
  description: 'Diff aller Plandokumente + Thesis gegen den Code-Ist — verifizierte Nachimplementierungs-Liste',
  phases: [
    { title: 'Extract', detail: 'SOLL-Ansprüche aus Plan-Gruppen extrahieren' },
    { title: 'VerifyCode', detail: 'jeden Anspruch gegen den Code-Ist prüfen' },
    { title: 'Classify', detail: 'Dedup + Gate-Klassifikation' },
  ],
}
const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUP + '/Code/external/comdare-cache-engine'
const BASE = `Wurzeln: super=${SUP}, ce=${CE} (main 5d67eecd). Stand: Schicht-Sequenz E4-E1+M komplett (Ledger §12 Einträge 09./10.07., Z.406-424 lesen für den Ist-Kontext!). Read-only.`

const CLAIMS = { type: 'object', required: ['claims'], properties: { claims: { type: 'array', items: {
  type: 'object', required: ['id', 'quelle', 'anspruch', 'pruefhinweis'],
  properties: { id: { type: 'string' }, quelle: { type: 'string', description: 'datei:zeile des SOLL' },
    anspruch: { type: 'string', description: 'WAS der Plan verlangt, konkret/prüfbar' },
    pruefhinweis: { type: 'string', description: 'wo/wie im Code prüfen (grep/Datei)' } } } } } }
const VERDICT = { type: 'object', required: ['status', 'beleg'], properties: {
  status: { type: 'string', enum: ['implementiert', 'teilweise', 'fehlt'] },
  beleg: { type: 'string', description: 'datei:zeile-Beleg bzw. was genau fehlt' },
  gate: { type: 'string', description: 'falls bekannt: gated-auf (User/Cluster/#156/...) oder leer = non-gated' } } }

const GROUPS = [
  { key: 'dossier16-17', doc: `${SUP}/docs/architektur/16_E1_E4_KONSOLIDIERUNG_DOSSIER.md + 17_E4_XML_VOLLVISION_ROADMAP.md — extrahiere JEDEN noch offenen Bau-Anspruch (Roadmap-Phasen, C.1-C.3, D-Tabelle) der NICHT offensichtlich durch die Schicht-Sequenz erledigt ist` },
  { key: 'dossier18-19', doc: `${SUP}/docs/architektur/18_MESS_METHODIK_ACHSEN_OPTIMIERUNG_KONSOLIDIERT.md (Teil C/F) + 19_SCHICHTEN_FERTIGSTELLUNG_E4_E1_INTERFACE_VERTRAEGE.md (Teil B/C/G!) — bes. E4'-Heuristik, 4-Phasen-Auto-Doku, Arbeitsmodus/Hybrid-Modus-Bausteine, M2-Observer-Strategy-Vollausbau` },
  { key: 'befunde', doc: `${SUP}/docs/sessions/backups/20260709-axes-optimization-deep-research/BEFUND.md (F.3-F.6) + 20260709-pareto-objectives-t6-t18-t5/BEFUND.md (§4!) + 20260710-workload-cluster-research/BEFUND.md (§4/§5) + 20260710-schicht-e3-impl/LIMITS-ENTKOPPLUNG-ANALYSE.md — jede Umsetzungs-Empfehlung [EMPF] als Anspruch` },
  { key: 'f7-ledger', doc: `${SUP}/docs/architektur/15_F7_mess_frameworks_workloads_2d_matrix_plan.md (§4/§5-Roadmap) + Ledger docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md §13.10 W1-W5 (Z.540-560) + §5 Wellen-Reste — offene definierte Arbeiten` },
  { key: 'thesis', doc: `Thesis-Kernkapitel ${SUP}/thesis/diplomarbeit/kapitel/de/03_messsystem_prtart.tex (Mess-System-Abschnitt ab :389, LP-Katalog :270-310) + 06_evaluation_methodology.tex (:60-180) — extrahiere Design-Ansprüche ans SYSTEM (nicht an den Text), die der Code einlösen muss (z.B. LP01-14, IPlatformProbe, 3 Messreihen, Loader, Regime)` },
]

phase('Extract')
const results = await pipeline(
  GROUPS,
  g => agent(`${BASE}\n\nLies: ${g.doc}\n\nExtrahiere die konkreten, PRÜFBAREN Bau-Ansprüche (max 12 wichtigste; id-Präfix ${g.key}). KEINE erledigten Selbstverständlichkeiten — fokussiere, was plausibel NOCH FEHLT. Jeder Anspruch mit exakter Quelle (datei:zeile) + Prüfhinweis für den Code.`, { label: `extract:${g.key}`, phase: 'Extract', schema: CLAIMS, effort: 'high' }),
  (r, g) => parallel((r?.claims ?? []).slice(0, 12).map(c => () =>
    agent(`${BASE}\n\nSOLL-Anspruch [${c.id}] aus ${c.quelle}: ${c.anspruch}\nPrüfhinweis: ${c.pruefhinweis}\n\nPrüfe am ECHTEN Code (grep/lesen), ob das implementiert / teilweise / fehlend ist. Beachte den frischen Schicht-Sequenz-Stand (Ledger §12 Z.406-424; z.B. system_axis.hpp, profile_facade, E1-RC-Konsum EXISTIEREN jetzt). Bei 'fehlt/teilweise': exakt was fehlt + bekanntes Gate (Ledger-Bilanz Z.414/422-424: gated-Liste).`, { label: `verify:${c.id}`, phase: 'VerifyCode', schema: VERDICT, effort: 'high' })
      .then(v => ({ ...c, ...v }))
  ))
)

phase('Classify')
const all = results.filter(Boolean).flat().filter(Boolean)
const offen = all.filter(c => c.status !== 'implementiert')
const dedup = await agent(`${BASE}\n\nHier die verifizierten OFFENEN Plan-Ansprüche (JSON):\n${JSON.stringify(offen, null, 1).slice(0, 30000)}\n\nDedupliziere inhaltlich (gleiches Bau-Artefakt = ein Eintrag, Quellen mergen) und klassifiziere jeden in: NON_GATED (jetzt baubar; User hat 10.07. ALLE GO-Increments freigegeben — GO-Increments zählen als NON_GATED!), DATEN_GATED (#156/Cluster), EXTERN_GATED (Infra/User-Sichtung/6-vs-48/Q2). Sortiere NON_GATED nach Wert fürs Diplomarbeits-Ziel (Hybrid-Modus/Heuristik/Cache-Line-Awareness zuerst). Gib strukturiert zurück.`, { label: 'classify+dedup', phase: 'Classify', schema: { type: 'object', required: ['non_gated', 'daten_gated', 'extern_gated'], properties: { non_gated: { type: 'array', items: { type: 'object', required: ['titel', 'quellen', 'was_fehlt'], properties: { titel: { type: 'string' }, quellen: { type: 'string' }, was_fehlt: { type: 'string' } } } }, daten_gated: { type: 'array', items: { type: 'object', required: ['titel'], properties: { titel: { type: 'string' }, quellen: { type: 'string' }, was_fehlt: { type: 'string' } } } }, extern_gated: { type: 'array', items: { type: 'object', required: ['titel'], properties: { titel: { type: 'string' }, quellen: { type: 'string' }, was_fehlt: { type: 'string' } } } } } }, effort: 'high' })
log(`${all.length} Ansprüche geprüft, ${offen.length} offen`)
return { statistik: { geprueft: all.length, offen: offen.length, implementiert: all.length - offen.length }, ...dedup }