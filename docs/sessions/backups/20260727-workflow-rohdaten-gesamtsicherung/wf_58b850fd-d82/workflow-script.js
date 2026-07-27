export const meta = {
  name: 'goal-v6-neuplanung',
  description: 'Goal /goal neu planen: §0-GOAL-V6 autorieren + regulaer ins Ledger konsolidieren + kompakter Meta-Hook-Text fuer den User-Paste',
  phases: [
    { title: 'Erfassung', detail: '4 parallele Straenge: §0-V5-Analyse, Neuester-Stand-Extrakt, Direktiven-Inventar, Audit-/Backup-Index' },
    { title: 'Synthese', detail: 'V6-Text autorieren + regulaer ins Ledger einpflegen + Meta-Hook-Text' },
  ],
}

const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const LEDGER = SUPER + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'
const BACKUPS = SUPER + '/docs/sessions/backups'
const MEMDIR = '/home/comdare/.claude/projects/-home-comdare/memory'

const COMMON = 'GEMEINSAME DIREKTIVEN (strikt): (1) Belege als datei:zeile. (2) NIEMALS Tokens/Secrets in Reports (glpat/oauth2/eyJ -> [MASKIERT]). (3) KEINE git-Commits/Pushes. (4) Rueckgabe = roher Daten-Report, kein Menschentext. (5) Token-effizient: grep vor Read, Read mit offset/limit. LEDGER=' + LEDGER + ' (nach dem letzten Nachzieh ~1889 Zeilen; §0 ab Z.15 [Titel "## §0 GOAL / MISSION (autoritativ — Referenz fuer /goal)"], §0-GOAL-V5 ab Z.75 [AKTIV seit 2026-07-15], §0-GOAL-V4 ab Z.122 [SUPERSEDED]; §16 ab ~Z.1340, §17 ~1520, §18 ~1550, §19 ~1797, §20 ~1853 [NEUESTER EINSTIEG]).\n\nKONTEXT-FAKTEN (autoritativ):\n' + args.facts + '\n\n'

phase('Erfassung')

const [v5analyse, standExtrakt, direktiven, auditIndex] = await parallel([
  () => agent(COMMON +
    'AUFGABE 1 — §0-VOLL-ANALYSE. Lies LEDGER Z.15 bis zum Beginn von §1 (finde das Ende per grep nach der naechsten "## §"-Ueberschrift nach Z.122; lies ALLES dazwischen: Mission/FF0-FF4/DoD-Block Z.15-74, den kompletten V5-Text Z.75-121, den V4-Kopf + die V4-Stufen G1-G8 Z.122ff). Liefere: (a) Die EXAKTE Struktur von V5 (alle Stufen/Abschnitte mit Titeln + Kernaussagen, woertlich wo kompakt). (b) Was in V5 ist NICHT mehr aktuell (pruefe jeden Satz gegen die KONTEXT-FAKTEN: VOLLES GO, INC-Roadmap, TABU-Aenderung ABI-4/golden, neue Prozess-Direktiven, erledigte Stufen)? Je: V5-Zitat + warum stale + was V6 stattdessen sagen muss. (c) Was in V5 (und im Mission/FF/DoD-Vorspann Z.15-74) bleibt UNVERAENDERT gueltig? (d) Wie ist die Versions-Konvention in §0 (V5 loest V4 ab, V4 additiv erhalten, Titelzeilen-Format, wo wird die neue Version eingefuegt)? (e) Welche G-Stufen-Nummern von V5 mappen auf welche INC-Increments (fuer die Kontinuitaet der Nummerierung in V6)?',
    { label: 'erfassung:v5-analyse', phase: 'Erfassung', model: 'opus' }),

  () => agent(COMMON +
    'AUFGABE 2 — NEUESTER-STAND-EXTRAKT FUER V6. Lies: LEDGER §20 (ab ~Z.1853 bis Dateiende) KOMPLETT, §19 (Z.1797-1852) KOMPLETT, §18.5 (grep "### 18.5" und lies bis §19), sowie ' + BACKUPS + '/20260717-inc0-bauplan/BAUPLAN-INC0-DLL-LOAD-B.md (Kopf + Schrittfolge + Verifikations-Plan + Planungs-Index INC-1/INC-2, ~334 Z. — lies komplett). Liefere die V6-BAUSTEINE: (a) Das Arbeitsprogramm-SOLL: INC-0 (DLL-Load B, deadline-kritisch, Bau-Freigabe-Gate!) -> INC-1 (CEB-System-Achsen-Schichtung) -> INC-2 (der EINE koordinierte 4->5-Bump) -> danach Planer-Codegen/Serialisierung/F12iii + die gated Reststrecke (Messlauf #215/#156, G5/#274 ans Ende, S-7, G8-Abgabe-Blocker Anhaenge B/E). (b) Die Freigabe-/Prozess-Mechanik: explizites User-Release-Gate je Bau-Phase; ultracode-Planungssession je Aufgabe ueber Ledger+ALLE Plandocs; Lesereihenfolge §20->§19->§18->§17->§16. (c) TABU-Anpassungen: was bleibt hart TABU (POD-1416? kV3AxisSchema? golden_fullpilot_320? permutation_axes.xml? GenusBindingTraits?) vs. was ist jetzt GO-bedingt aenderbar (ABI-4 nur bis INC-2; golden-Umbau messdaten-erhaltend in INC-2; POD/Schema-Bruch im koordinierten Bump) — praezise mit Beleg (§19.F, §18.2.4, §20.E). (d) Verifikations-Kadenz-SOLL inkl. der 20.D-Nebenbefunde (super-Sub-Build PFLICHT bei INC-0). (e) Deadline-Anker 28.07. (CI UND standalone messfaehig).',
    { label: 'erfassung:stand-extrakt', phase: 'Erfassung', model: 'opus' }),

  () => agent(COMMON +
    'AUFGABE 3 — DIREKTIVEN-VOLL-INVENTAR. Lies ' + MEMDIR + '/MEMORY.md KOMPLETT (Index aller Memories) und die Titelzeilen+description der 8 NEUESTEN Direktiven-Memories (16./17.07.: feedback_recursive_dock_*, feedback_jede_aufgabe_ultracode_*, feedback_ledger_regulaer_updaten_*, feedback_open_decision_*, project_diplomarbeit_stand_20260717_*, feedback_serialization_*, feedback_measurement_modes_*, feedback_measurement_failure_*: je die Datei kurz lesen). Zusaetzlich LEDGER §16.4 (grep "16.4" und den Direktiven-Block lesen). Liefere: (a) Die kanonische Striktheits-Direktiven-Liste, die ein Goal-Text nennen MUSS (Metaprogrammierung compile-time-only/CRTP+Concepts/benannte Patterns; WAS/WIE ce=Framework super=Definition; sauberster-nie-einfachster-Weg; keine Behelfswege; Doku nie loeschen [PRAEZISIERT: Ledger darf regulaer geupdated werden, neuere Fakten schlagen aeltere — Dossiers/Doku weiterhin nie loeschen]; Messdaten nie loeschen; Remote nur je-Repo-GO; NIE rebase immer merge; kein Python in Buildchain; NIE AskUserQuestion; nie-Erfolg-ohne-woertliche-Ausgabe; vor-Aufgaben-Projektstruktur-Analyse; offene-Entscheidung->erst-Ledger-lesen). (b) Die NEUEN Prozess-Direktiven 07-17 exakt formuliert. (c) Welche Direktiven-Formulierungen des ALTEN Hook-Textes (in KONTEXT-FAKTEN verbatim) veraltet/zu ersetzen sind — Zeile fuer Zeile durchgehen.',
    { label: 'erfassung:direktiven', phase: 'Erfassung', model: 'opus' }),

  () => agent(COMMON +
    'AUFGABE 4 — AUDIT-/BACKUP-INDEX FUER DIE PFLICHTLEKTUERE-REFERENZEN. ls -1 ' + BACKUPS + '/ | sort. Der alte Hook verweist auf 20260712-full-line-review + 20260712-forgotten-todo-sweep als Pflichtlektuere. Liefere: (a) die 12 NEUESTEN Dossier-Verzeichnisse (2026-07-14 und juenger) mit je 1 Satz Inhalt+Rolle (Kopf der Haupt-Datei je Verzeichnis kurz anlesen), (b) eine EMPFOHLENE Pflichtlektuere-Kaskade fuer V6 nach Aufgaben-Typ: vor JEDER Aufgabe (Ledger §20->§19->...), vor INC-0 (Bauplan+DLL-Diagnose), vor INC-1/INC-2 (Konstruktionslogik+F12III-Vorlage+e18/e17-Dossiers+experiment-planer-codegen), Audits allgemein (20260712-Reviews bleiben als Basis-Audits gueltig? pruefe ob deren Befunde abgearbeitet/ueberholt sind — konservativ: als historische Basis nennen, neueste Audits als primaer).',
    { label: 'erfassung:audit-index', phase: 'Erfassung', model: 'opus' }),
])

const okN = [v5analyse, standExtrakt, direktiven, auditIndex].filter(Boolean).length
log('Erfassung fertig: ' + okN + '/4 Straenge')

phase('Synthese')

const synth = await agent(COMMON +
  'AUFGABE S — §0-GOAL-V6 AUTORIEREN + REGULAER INS LEDGER EINPFLEGEN + META-HOOK-TEXT LIEFERN. NEUE LEDGER-DOKTRIN GILT (User 2026-07-17): das Ledger darf REGULAER geupdated werden (in-place), neuere Fakten schlagen aeltere; Historie via git. Du bekommst 4 Erfassungs-Reports (unten).\n\n' +
  'SCHRITT 1 — V6-TEXT AUTORIEREN (der Kern der Aufgabe, hoechste Sorgfalt): Struktur nach V5-Muster (Report 1d/1a), Titelzeile: "### §0-GOAL-V6 (2026-07-17, KONSOLIDIERT + AKTIV — loest V5 ab; V5/V4 als Historie erhalten. Basis: VOLLES GO 2026-07-17 + §18-§20 + Baupläne, ultracode wf_d5ba4b2b + diese Planungssession)". Inhalt: (i) Mission/FF0-FF4/DoD referenzieren (unveraendert dort wo Report 1c das bestaetigt — NICHT duplizieren, auf den Vorspann verweisen). (ii) ARBEITSPROGRAMM als geordneter Stack auf Ist-Stand (Report 2a): fortlaufende Stufen-Nummerierung waehlen, die die V5-Stufen ehrlich fortschreibt (Report 1e) — erledigte V5-Stufen als DONE markieren, dann INC-0 -> INC-1 -> INC-2 -> Folgearbeiten -> gated Reststrecke -> Abgabe-Blocker. Je Stufe: Ziel, Pflichtlektuere (Report 4b), Verifikations-Gate. (iii) PROZESS-REGELN (Report 3b): ultracode-Planungssession je Aufgabe ueber Ledger+ALLE Plandocs; explizites User-Release-Gate je BAU-Phase (Anhalte-Direktive gilt bis zur expliziten Freigabe je Phase); Lesereihenfolge §20->§19->...; Orientierung an den letzten Audits/Backup-Workflows via ultracode bei jeder groesseren Aufgabe; Ledger-Update-Doktrin regulaer. (iv) STRIKTHEITS-DIREKTIVEN (Report 3a, kompakt, vollstaendig). (v) TABU-BLOCK PRAEZISIERT (Report 2c): hart-TABU unveraendert vs. GO-bedingte Aenderungs-Fenster (ABI-4 bis INC-2; golden-Umbau messdaten-erhaltend NUR im koordinierten INC-2-Bump; Messdaten IMMER additiv). (vi) Deadline-Anker 28.07. (vii) Verifikations-Kadenz je Increment inkl. super-Sub-Build-Pflicht (Report 2d).\n\n' +
  'SCHRITT 2 — REGULAER EINPFLEGEN: (a) V6-Block VOR dem V5-Block einfuegen (neue Version zuerst, ab Z.75-Bereich). (b) V5-Titelzeile IN-PLACE aendern: "AKTIV" -> "SUPERSEDED durch §0-GOAL-V6 (2026-07-17), als Historie erhalten" (Text von V5 stehen lassen). (c) Im §0-Kopf (Z.15-Bereich): falls dort eine "aktive Version"-Referenz steht, auf V6 updaten. (d) Den obersten §12-Eintrag um einen Satz ergaenzen (regulaer, in-place am Ende des Eintrags): "+ §0-GOAL-V6 konsolidiert (loest V5 ab)". KEINE anderen Stellen anfassen.\n\n' +
  'SCHRITT 3 — SELBST-CHECKS (Ausgaben woertlich in den Report): grep -c "§0-GOAL-V6" LEDGER (>=1); grep -n "SUPERSEDED durch §0-GOAL-V6" (==1 Zeile, die V5-Titelzeile); git -C ' + SUPER + ' diff --numstat (nur LEDGER; Insertions plausibel, Deletions NUR die regulaer ersetzten Zeilen [V5-Titel, §0-Kopf-Referenz, §12-Satz]); Mojibake-Check auf den added lines == 0; wc -l vorher/nachher.\n\n' +
  'SCHRITT 4 — META-HOOK-TEXT (Deliverable an den User, im Report zurueckgeben, NICHT in eine Datei): kompakter /goal-Paste-Text (~12-18 Zeilen Prosa, DEUTSCH, im Stil des alten Hook-Textes in den KONTEXT-FAKTEN), der (1) auf §0-GOAL-V6 im Ledger als autoritative Referenz zeigt, (2) das Stack-Prinzip + die aktuellen Stufen nennt, (3) die Striktheits-Kurzliste enthaelt, (4) die NEUEN Prozess-Regeln einbaut (ultracode-Planungssession je Aufgabe; explizite Bau-Freigabe je Phase; Lesereihenfolge §20->; letzte Audits/Backup-Workflows als Orientierung; Ledger regulaer updaten, neuere Fakten schlagen aeltere), (5) die literale Verifikations-Kadenz + das praezisierte TABU nennt.\n\n' +
  'RUECKGABE: (i) Edit-Liste (LEDGER:zeile + 1 Satz), (ii) Selbst-Check-Ausgaben woertlich, (iii) der komplette META-HOOK-TEXT, (iv) 5-Satz-Zusammenfassung der wichtigsten V5->V6-Aenderungen.\n\n' +
  '=== REPORT 1 (V5-Analyse) ===\n' + (v5analyse || '(ausgefallen — lies §0 selbst komplett)') +
  '\n\n=== REPORT 2 (Stand-Extrakt) ===\n' + (standExtrakt || '(ausgefallen — lies §19/§20 + Bauplan selbst)') +
  '\n\n=== REPORT 3 (Direktiven) ===\n' + (direktiven || '(ausgefallen — lies MEMORY.md selbst)') +
  '\n\n=== REPORT 4 (Audit-Index) ===\n' + (auditIndex || '(ausgefallen — ls backups selbst)'),
  { label: 'synthese:goal-v6', phase: 'Synthese', model: 'opus' })

return { erfassung_ok: okN, synthese: synth || 'AUSGEFALLEN' }