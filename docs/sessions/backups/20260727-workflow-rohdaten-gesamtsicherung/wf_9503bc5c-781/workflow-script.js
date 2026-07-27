export const meta = {
  name: 'stempel-versionierung-plan-suche',
  description: 'Q-A-Owner-Order: das bereits geplante Stempel-/Versionierungs-Schema (je Achsen-Typ -> Haupt-Achse mit Algo+Version; Binary hat KEINE eigene CEB/Tier-Version, nur Planner; Komplex-Achse EIN gemeinsamer Stempel) in backups/sessions/Ledger wortgenau finden',
  phases: [
    { title: 'Suchen', detail: '3 parallele Sucher (Ledger §58/§43, Transkripte, Plan-Backups+Code-Ist)', model: 'opus' },
    { title: 'Befund', detail: 'konsolidiertes Stempel-Schema + Delta zum Ist-Code', model: 'opus' },
  ],
}
const S = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = S + '/Code/external/comdare-cache-engine'
const AUFTRAG = `GESUCHT (Owner 26.07., Q-A, KERN): Das BEREITS GEPLANTE Stempel-/Versionierungs-Schema. Owner-Worte: "Die Stempel sind je Achsen-Typ gegliedert und untergliedern sich jeweils in die Haupt-Achsen je Achsen-Typ mit einem gewaehlten Algorithmus je Haupt-Achse und dessen eindeutiger Versionsnummer. Eine Binary hat also keine eigene Versionsnummer fuer CEB und Tier-Binaries, nur fuer Planner, sondern identifiziert sich aus den gewaehlten Haupt-Achsen Rekombinationen und deren Algorithmus-Versionierung. Eine Komplex-Achse traegt als rekursive Klammerung die Haupt-Achsen die sie wrappt und hat nur eine indirekte Identitaet ueber die gewrappten echten Haupt-Achsen (command pattern). Sie formt einen gemeinsamen komplexen Stempel." Owner: "das ist schon genau geplant und vielleicht sogar in einem backup workflow zu finden oder den sessions." FINDE die Original-Planung wortgenau (Quelle+Zeile).`

phase('Suchen')
const [led, tk, plan] = await parallel([
  () => agent(
    `${AUFTRAG}\n\nQUELLE Ledger: ${S}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md — §58 (Stempel-Modell: Planer X.Y.Z, CEB-Array, Tier zwei Arrays + Merge-Stempel), §43/§43.b, §54-T3 (binary_id), §62-D/§62-N6 (SHA512-Lookup), §66. grep -n nach 'Stempel|Version|X.Y.Z|SHA512|Algorithmus.*version|algo_version|keine.*eigene.*Version|Rekombination' und Bloecke lesen. Wortgenaue Zitate: bestaetigt der Ledger, dass CEB/Tier KEINE eigene Version tragen (nur Planner)? Wo steht die je-Typ->je-Haupt-Achse-Gliederung?`,
    { label: 'ledger-stempel', phase: 'Suchen', model: 'opus', effort: 'high' }
  ),
  () => agent(
    `${AUFTRAG}\n\nQUELLE Transkripte: ${S}/docs/sessions/backups/20260726-kontext-neugruendung-workflow/ergebnisse/*transkript*.md + .../20260726-bestandslog-plan-nachlese-workflow/ergebnisse/03-user-worte-*.md + .../20260726-session-plaintext-verlauf/*.txt. grep -n -i 'stempel|version|algorithmus|rekombination|komplex|klammer|eigene version|planner' und USER-Zeilen-Umgebungen lesen. Wortgenaue Owner-Saetze zum Stempel-/Versionierungs-Schema, chronologisch.`,
    { label: 'transkript-stempel', phase: 'Suchen', model: 'opus', effort: 'high' }
  ),
  () => agent(
    `${AUFTRAG}\n\nQUELLE Plan-Backups + Code-Ist: alle ${S}/docs/sessions/backups/2026072*/ergebnisse/*.md (grep -l 'stempel|version|sha512') + ${S}/docs/architektur/ (Stempel-Dossiers). DAZU Code-Ist als Kontrast: ${CE}/libs/cache_engine/include/cache_engine/abi/anatomy_version_stamp.hpp, system_axis_code_versions.hpp, ceb_version_stamp.hpp, ${CE}/libs/cache_engine/builder/experiment_tree/axis_variant_version_table.hpp — wie versioniert der Ist-Code heute (per-Achse algo_version? eigene Binary-Version?)? Wortgenaue Doku-Zitate + Code-datei:zeile. Delta Plan vs Ist.`,
    { label: 'plan-code-stempel', phase: 'Suchen', model: 'opus', effort: 'high' }
  ),
])

phase('Befund')
const befund = await agent(
  `${AUFTRAG}\n\nSynthese aus den 3 Suchen (unten): (1) das KONSOLIDIERTE Stempel-/Versionierungs-Schema wortgenau belegt (je-Typ->Haupt-Achse->Algo+Version; keine eigene CEB/Tier-Version nur Planner; Komplex-Achse EIN Stempel, indirekte Identitaet); (2) ob es "schon genau geplant" IST (ja/nein, wo) oder nur teilweise; (3) DELTA zum Ist-Code (was erfuellt der Code heute, was fehlt) mit datei:zeile; (4) was das fuer STRUKT-R Lane A (Stempel A-II/A-III) konkret bedeutet; (5) wo die Quellen schweigen. ASCII (§ ok), keine Secrets.\n\n===== LEDGER =====\n${led || 'AUSGEFALLEN'}\n\n===== TRANSKRIPTE =====\n${tk || 'AUSGEFALLEN'}\n\n===== PLAN+CODE =====\n${plan || 'AUSGEFALLEN'}`,
  { label: 'stempel-befund', model: 'opus', effort: 'xhigh' }
)
return { befund }