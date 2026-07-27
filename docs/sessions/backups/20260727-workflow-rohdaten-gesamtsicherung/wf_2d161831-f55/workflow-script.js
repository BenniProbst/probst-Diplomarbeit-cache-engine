export const meta = {
  name: 'anforderungs-ueberblick',
  description: 'Ultracode-Ueberblick: Ledger + letzte 6 Workflow-Backups + Top-5-Dokumente -> Anforderungs-/Erfuellungs-Matrix fuer die naechsten Wellen',
  phases: [{ title: 'Lesen', detail: '3 parallele Opus-Reader' }],
}
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const COMMON = `Du bist Rechercheur der Diplomarbeit-Doku. Wurzel: ${SUPER}. Antworte NUR mit StructuredOutput, Belege als datei(:zeile) bzw. ordner. Lies gezielt (Grep/Read mit offset), grosse Dateien abschnittsweise.`

const REQ_SCHEMA = {
  type: 'object', required: ['anforderungen', 'offene_faeden'],
  properties: {
    anforderungen: { type: 'array', items: { type: 'object', required: ['id', 'kern', 'stand', 'beleg'], properties: { id: { type: 'string' }, kern: { type: 'string' }, stand: { type: 'string', description: 'ERFUELLT | TEIL | OFFEN | GEPARKT + 1-Satz-Begruendung' }, beleg: { type: 'string' } } } },
    offene_faeden: { type: 'array', items: { type: 'string' } },
  },
}

phase('Lesen')
const [ledger, backups, docs] = await parallel([
  () => agent(`${COMMON}
AUFGABE Ledger-Anforderungs-Extrakt: Lies im Ledger ${SUPER}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md die Abschnitte §25 bis §40.b (Grep '## §' fuer die Anker; das ist der hintere Teil der Datei) UND den vorderen Ziel-/GOAL-Teil (Kopf bis ca. Zeile 120, §0-GOAL + Abgabekriterien). Extrahiere JEDE dort kodierte Anforderung/Direktive als eigenen Eintrag (id=§-Nummer+Kurzname). Bewerte je den Erfuellungs-Stand GEGEN die dokumentierten Wellen-Lieferungen: Kreuzreferenz ${SUPER}/docs/sessions/2026-07-19-SESSION-UEBERGABE-wellen1-4-pool-maschinerie-komplett.md (Wellen 1-4) + ${SUPER}/docs/plaene/20260719-welle5-dock-protokoll-BAUPLAN.md (W5) + Roadmap-KONSOLIDIERUNG am Ende von ${SUPER}/docs/plaene/20260719-gesamt-roadmap-ledger-diff-ROADMAP.md. Heutige zusaetzliche Lieferungen (noch nicht ueberall dokumentiert): W5-A/B/C/C+ integriert (ce d7d35c36: Dock-Payload+R5-XML, ProgressDelta-Rueck-Kanal, CMakeGraphBuilder-No-Op, --dump-plan, GN-Zellen-Filter, ceb-measurement-exclusive, contract:axis-version-lock, Basic-Auth-Fix), Kalibrierung 11453 = 24/24 gruen (Pilot), Runner-Tags gesetzt, mc auf prod2. In offene_faeden: alles was KEINER Welle zugeordnet ist.`, { label: 'ledger:§25-§40', phase: 'Lesen', schema: REQ_SCHEMA, model: 'opus', effort: 'high' }),
  () => agent(`${COMMON}
AUFGABE Workflow-Backup-Extrakt: Unter ${SUPER}/docs/sessions/backups/ liegen Workflow-Backup-Ordner. Nimm die 6 NEUESTEN (nach ls -t: 20260718-konformitaets-audit-9dim, 20260718-storage-infra-verortung, 20260717-ci-hermetik-boost, 20260717-achsen-nachschlagewerk, 20260717-inc2c-konformitaet-audit, 20260717-voll-konsolidierung). Lies je Ordner die Synthese-/Ergebnis-Datei(en) (meist SYNTHESE*.md oder gleichnamig; bei mehreren Dateien die Haupt-Synthese). Extrahiere je Workflow: (a) Kern-Ergebnisse (max 5 Saetze als 'kern'), (b) als eigene anforderungen-Eintraege alle dort festgehaltenen NOCH-OFFENEN Auftraege/Empfehlungen/Befunde mit Handlungsbedarf (stand=OFFEN wenn nicht erkennbar erledigt; id=<ordner>/<kurzname>). In offene_faeden: Querbezuege, die mehrere Workflows gemeinsam offen lassen.`, { label: 'backups:6-workflows', phase: 'Lesen', schema: REQ_SCHEMA, model: 'opus', effort: 'high' }),
  () => agent(`${COMMON}
AUFGABE Top-5-Dokumente-Extrakt: Lies diese 5 Dokumente VOLL (abschnittsweise): (1) ${SUPER}/docs/plaene/20260719-gesamt-roadmap-ledger-diff-ROADMAP.md (2) ${SUPER}/docs/plaene/20260719-welle5-dock-protokoll-BAUPLAN.md (3) ${SUPER}/docs/sessions/2026-07-19-SESSION-UEBERGABE-wellen1-4-pool-maschinerie-komplett.md (4) ${SUPER}/docs/plaene/20260719-FINALES-DESIGN-ABSTRACT-kette-baum-registries.md (5) ${SUPER}/docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md. Extrahiere als anforderungen-Eintraege: alle dort geplanten Increments/Deliverables mit Stand (id=doc-kuerzel/name; ERFUELLT nur bei explizitem Beleg). Fokus auf: Planer-I-Increments (I1-I5), Fork-Entscheide (A/C/E offen?), Registry-Stufen, Hybrid-Pflicht, Mess-Kette, D1-D18/A1-A11-Abstract-Punkte mit Impl-Bedarf. In offene_faeden: Widersprueche zwischen den 5 Dokumenten oder zu §40 (dynamische Planer-CI, Flag-Signaturen, Bare-Metal).`, { label: 'docs:top5', phase: 'Lesen', schema: REQ_SCHEMA, model: 'opus', effort: 'high' }),
])
return { ledger, backups, docs }