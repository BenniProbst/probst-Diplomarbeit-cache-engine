export const meta = {
  name: 'ttl-eta-lock-definition-suche',
  description: 'Owner-Order: die bereits definierte TTL-/Lock-Zeit (in Verbindung mit ETA) in Session-Logs/Transkripten wortgenau wiederfinden — unpersistiert durch Kompaktierung verloren',
  phases: [
    { title: 'Suchen', detail: '3 parallele Sucher (Transkript-Extrakte, Session-Docs+Ledger, Plan-Backups)', model: 'opus' },
    { title: 'Befund', detail: 'wortgenaue Fundstellen + Verdikt', model: 'opus' },
  ],
}

const S = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const AUFTRAG = `GESUCHT (Owner 26.07., wortgenau erinnert): Eine BEREITS FRUEHER DEFINIERTE Lock-/TTL-Zeitangabe fuer das Bestandslog, die IN VERBINDUNG MIT "ETA" formuliert wurde. Owner-Beschreibung heute: "Bei der Berechnung der ETA fordert eine Maschine ein exklusives lock fuer die Berechnung von ETA an, bis diese feststeht, ansonsten ist der lock jeweils so kurz wie moeglich ueber den lese-, bewertungs- und Rueckschreibzyklus einer Bestand-haltungs-Aktion. Das TTL timeout war bereits definiert." Finde die urspruengliche Definition (Zahl + Wortlaut + Quelle). Kandidaten-Muster: TTL, timeout, Lock, Sperre, ETA, 30 min, pro-forma, Sekunden/Minuten-Angaben in Lock-Kontext. VORSICHT: die pro-forma-30-Minuten-RESERVIERUNG ist NICHT das Gesuchte (das ist die Reservierungs-, nicht die Lock-Dauer) — aber ihre Textumgebung koennte die Lock-TTL enthalten. Liefere WORTGENAUE Zitate mit Datei+Zeile, chronologisch, und markiere den besten Kandidaten.`

phase('Suchen')
const [tk, docs, plaene] = await parallel([
  () => agent(
    `${AUFTRAG}\n\nDURCHSUCHE die Transkript-Extrakte (redigierte User/Assistant-Konversation der letzten Kontexte): ${S}/docs/sessions/backups/20260726-kontext-neugruendung-workflow/ergebnisse/*transkript*.md (30 Dateien). Methode: grep -n -i nach 'ttl|timeout|lock|sperr' und nach 'eta' je Datei; dann die Treffer-Umgebungen (±30 Zeilen) LESEN, USER-Zeilen bevorzugt. Wortgenaue Zitate.`,
    { label: 'transkript-suche', phase: 'Suchen', model: 'opus', effort: 'high' }
  ),
  () => agent(
    `${AUFTRAG}\n\nDURCHSUCHE (1) ${S}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md komplett nach denselben Mustern (besonders §62-Umfeld N5-N15, aber auch ausserhalb), (2) ALLE ${S}/docs/sessions/2026072*.md, (3) ${S}/docs/sessions/backups/20260722* und 20260723* falls vorhanden (ls zuerst). Wortgenaue Zitate mit Zeile.`,
    { label: 'ledger-sessions-suche', phase: 'Suchen', model: 'opus', effort: 'high' }
  ),
  () => agent(
    `${AUFTRAG}\n\nDURCHSUCHE die Plan-Backups: ${S}/docs/sessions/backups/20260726-bestandslog-plan-nachlese-workflow/ergebnisse/*.md (besonders 01-ledger-62-verbatim und 03-user-worte — dort sind Ledger-Verbatim-Zitate und wortgenaue User-Saetze gesammelt) + ${S}/docs/sessions/backups/20260726-g4b-planung-workflow/ergebnisse/*.md. Zusaetzlich: git -C ${S} log --all --oneline -S 'ttl' -- docs/ (falls die Definition in einer geloeschten/umgeschriebenen Doku-Fassung lag). Wortgenaue Zitate.`,
    { label: 'plan-backup-suche', phase: 'Suchen', model: 'opus', effort: 'high' }
  ),
])

phase('Befund')
const befund = await agent(
  `${AUFTRAG}\n\nSynthetisiere aus den drei Such-Berichten (unten) den BEFUND: (a) die wahrscheinlichste Original-Definition (wortgenau, Quelle, Datum), (b) alle Kandidaten mit Bewertung, (c) falls NICHTS Eindeutiges gefunden: sage das EHRLICH ('nicht auffindbar — vermutlich im verlorenen unpersistierten Teil') und liste, was stattdessen belegt ist (z.B. LockRecord ttl_s=30 im Code, pro-forma 30 min, N7/N8-Saetze). NICHTS erfinden. ASCII (§ ok).\n\n===== TRANSKRIPTE =====\n${tk || 'AUSGEFALLEN'}\n\n===== LEDGER/SESSIONS =====\n${docs || 'AUSGEFALLEN'}\n\n===== PLAN-BACKUPS =====\n${plaene || 'AUSGEFALLEN'}`,
  { label: 'befund', phase: 'Befund', model: 'opus', effort: 'xhigh' }
)

return { befund }