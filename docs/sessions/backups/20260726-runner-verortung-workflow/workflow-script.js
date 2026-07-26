export const meta = {
  name: 'runner-verortung-infra',
  description: 'Verortungs-Workflow vor Runner-Umbau: Cluster-Runner/CI-Sessions + SSH-Zugangsweg + concurrency-Doktrin',
  phases: [
    { title: 'Verortung', detail: '3 Opus-Leser: Runner-Doku, Zugangsweg, Mess-Doktrin' },
    { title: 'Brief', detail: 'Verortungs-Brief mit exakten Schritten' },
  ],
}
const CL = '/home/comdare/Projekte/Cluster'
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'

const SEC = 'SECURITY (hart): Du darfst ' + CL + '/keys/ NIEMALS lesen oder oeffnen. Secret-WERTE (Passwoerter, Tokens, PATs, PSKs) NIEMALS in deinen Report schreiben, auch nicht maskiert oder in Fragmenten. Verweise nur auf Fundstellen (datei:zeile) und Verfahren. ASCII-only Report.\n'

const p1 = SEC +
  'AUFGABE: Verortung GitLab-Runner-Infrastruktur prod1/prod2 fuer eine anstehende concurrency-Umstellung.\n' +
  'Lies in ' + CL + '/docs/ alles Runner-/CI-bezogene: CICD-DEPLOYMENT-PLAN.md, 08_BUILD_NODES_SETUP.txt, 12_RUNBOOK_PRO_MACHINE.txt (prod1/prod2-Sektionen), FEHLER-LOESUNGEN-KB.md (Runner-Eintraege), sessions/ (grep nach runner|concurrency|concurrent, die neuesten zuerst, insbesondere 2026-07-2*).\n' +
  'LIEFERE: (a) Wo liegt die Runner-config je Maschine (config.toml-Pfad, User, wie viele Runner registriert, tags, limit/concurrent-Ist laut Doku), (b) dokumentierte Prozeduren zum Aendern (reload-Verhalten, Vorsichtsregeln), (c) WARUM concurrency=1 gesetzt wurde (Mess-Schutz-Historie, wer/wann), (d) alle dokumentierten Fallen (Zombie-Driver, Cancel-trap, P11-Exklusivitaet, OOM bei Parallel-Bau W-44, RAM-Grenzen), max 80 Zeilen.'

const p2 = SEC +
  'AUFGABE: Den dokumentierten SSH-/Admin-Zugangsweg zu prod1 (10.0.10.211, = lokale Maschine) und prod2 (10.0.10.212) ermitteln - NUR das VERFAHREN, nie Werte.\n' +
  'Lies in ' + CL + '/docs/: 12_RUNBOOK_PRO_MACHINE.txt, 08_BUILD_NODES_SETUP.txt, VPN-ZUGRIFF.md, sessions/ (grep admin-management + ssh + prod1|prod2|211|212, neueste zuerst; auch die K105-Realm-Trennungs-Doku und agent-memories-infra/).\n' +
  'KONTEXT: Ein Login-Versuch admin-management@localhost mit dem Vault-Eintrag "***CRED-NAME-REF:comdare-admin-management*** PROD-comdare.de-AD (K105-INC 2026-07-15)" wurde abgelehnt (Permission denied). Die Offset-Tabelle kennt zusaetzlich einen dev-Realm-Eintrag (comdare.local, Rotation 2026-07-13) und einen "#113-Nachtrag = prod2-ssh" am Vault-Ende.\n' +
  'LIEFERE: (a) An welchem Identity-Backend haengen prod1/prod2-SSH-Logins laut Doku (lokaler User? SSSD/AD? welcher Realm?), (b) welcher Vault-EINTRAG (nur Fundstellen-Beschreibung/Label, NIE der Wert) ist laut Doku der fuer admin-management-SSH auf prod1/prod2 aktive, (c) gibt es Lockout-Politiken (AD account lockout) und wie viele Fehlversuche sind riskant, (d) alternative dokumentierte Wege (lokale Konsole, sudo-Regeln fuer andere User, gitlab-runner-User), max 60 Zeilen.'

const p3 = SEC +
  'AUFGABE: Die Diplomarbeit-seitige Mess-/CI-Doktrin zur Runner-Parallelitaet zusammentragen, damit eine concurrency-Umstellung (prod1: 3, prod2: 2, Jobs max 12 Threads im Normal-Modus; bei Voll-Bau/Messung concurrency 1 + physische Kerne) doktrin-konform entworfen werden kann.\n' +
  'Lies in ' + SUPER + '/docs/: DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (grep nach 38.b|62-B|62-C|61|Exklusivitaet|concurrency|seriell, mit Kontext-Zeilen), sessions/ (grep concurrency|runner, neueste 5 Treffer-Dateien).\n' +
  'LIEFERE: (a) alle bindenden Doktrin-Saetze zu Parallelitaet/Exklusivitaet (Mess-Exklusivitaet pro Maschine, Bau parallel, Batch O(Maschinen), Debug parallel/Messung 1-Thread) mit Fundstelle, (b) welche CI-Jobs Thread-Zahlen woher beziehen (nproc? Variablen? K-Budgets amd=24/intel=16?), (c) Risiken der Umstellung gegen die Doktrin + wie der Zwei-Modus-Entwurf sie respektiert, max 80 Zeilen.'

phase('Verortung')
const r = await parallel([
  () => agent(p1, { label: 'runner-doku', phase: 'Verortung', model: 'opus', effort: 'high' }),
  () => agent(p2, { label: 'zugangsweg', phase: 'Verortung', model: 'opus', effort: 'high' }),
  () => agent(p3, { label: 'mess-doktrin', phase: 'Verortung', model: 'opus', effort: 'high' }),
])
const [doku, zugang, doktrin] = [r[0] || 'FEHLT', r[1] || 'FEHLT', r[2] || 'FEHLT']

phase('Brief')
const brief = await agent(
  SEC + 'Du bist der Synthese-Schritt eines Infra-Verortungs-Workflows. Drei Erhebungen:\n\n=== RUNNER-DOKU ===\n' + String(doku).slice(0, 15000) +
  '\n\n=== ZUGANGSWEG ===\n' + String(zugang).slice(0, 10000) +
  '\n\n=== MESS-DOKTRIN ===\n' + String(doktrin).slice(0, 15000) +
  '\n\nAUFTRAG DES OWNERS: prod1 concurrent=3, prod2 concurrent=2, Jobs max 12 Threads im Normal-Modus; bei Voll-Bau oder Messung: concurrent=1 + physische Kerne als Parallelitaets-Grenze. Zweck: schnelleres Testen im Normalbetrieb.\n' +
  'LIEFERE einen VERORTUNGS-BRIEF (max 80 Zeilen): (1) Ist-Stand, (2) exakte geordnete Umsetzungs-Schritte (welche Datei, welche Werte, wie Modus-Umschaltung sauber als sh-Skript ohne Python, wo das Skript liegt/committet wird), (3) Constraints/Fallen die einzuhalten sind, (4) offene Punkte die der Manager klaeren muss (z.B. Zugangsweg falls ungeklaert), (5) Verifikations-Schritte mit literalen Kommandos.',
  { label: 'verortungs-brief', phase: 'Brief', model: 'opus', effort: 'xhigh' }
)
return { doku, zugang, doktrin, brief }