export const meta = {
  name: 'w0b-soll-ist-diff-bau-dualreview',
  description: 'Zehn Pakete: SOLL-Explore -> IST-Explore -> Diff-Design -> Bau -> Dual-Review (Codex + Fable 5 max)',
  phases: [
    { title: 'SOLL', detail: 'Sonnet 5 max: wie MUESSTE das Paket aussehen (Korpus 9 Wochen)' },
    { title: 'IST', detail: 'Sonnet 5 max: was ist am Objekt WIRKLICH gebaut' },
    { title: 'DIFF', detail: 'Fable 5 max: Delta SOLL gegen IST, Bauplan', model: 'fable' },
    { title: 'BAU', detail: 'Opus 5 max: bauen im zugewiesenen Worktree' },
    { title: 'REVIEW', detail: 'Codex + Fable 5 max, zwei unabhaengige Lenses' },
  ],
}

const DOK = `BINDENDE DOKUMENTE (lies, was dein Paket betrifft -- nicht alles):
  Arbeitsweise v3.1  /home/comdare/Projekte/docs/ARBEITSWEISE-GESAMT-DOKTRIN.md
  GOAL v8            /home/comdare/wt-super-landung/docs/plaene/20260808-GOAL-V8-DOSSIER-alle-wellen-am-stueck-bis-abgabe.md
  Wellenplan v2      /home/comdare/wt-super-landung/docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md
  Designplan TDD     /home/comdare/wt-super-landung/docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-wellen.md
  Ledger             /home/comdare/wt-super-landung/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md

VERIFIKATIONSVERTRAG (Wellenplan Abschnitt 6), gilt fuer JEDE Aussage die du machst:
  V-1 NENNER     jede Zahl mit Grundgesamtheit, IN DER AUSGABE. Nenner 0 = Abbruch, nie gruen.
  V-2 KOEDER     zufaellig erzeugt (/dev/urandom), Rot-Lauf VOR der Heilung, Gegenkoeder gruen.
  V-4 DIFFERENZ  zwei Zustaende, BEIDE Zahlen nennen -- auch die vorher.
  V-7 FREMDER NENNER  eine der zwei verglichenen Zahlen aus einer ANDEREN Quelle als dem Prueflig.
  V-8 GEGENSTAND STATT ANKUENDIGUNG  zu jeder Formel: "welcher Zustand laesst diese Ausgabe
      erscheinen, obwohl die Sache NICHT existiert?" Gibt es ihn, miss am OBJEKT.

WERKZEUG-FALLEN, jede hat schon zugeschlagen:
  * blankes grep ist ugrep -> -P bricht mit STILLER 0. Fuer exakte Zaehlung /usr/bin/grep absolut.
  * grep ohne -F auf Mustern mit $( -> stille 0. IMMER -F bei Literalen.
  * rc=$? nach einer Pipe misst das LETZTE Glied -> PIPESTATUS oder ohne Pipe messen.
  * grep -v '/build' frisst auch '/builder/' -> beide Schraegstriche.
  * git immer mit -C <pfad>, das cwd ist keine verlaessliche Aussage.
  * Jeder Nichtfund braucht eine GEGENPROBE (Muster das sicher trifft, mit Trefferzahl).
    Ohne sie ist ein Nichtfund von einem kaputten Kommando nicht zu unterscheiden.`

const PAKETE = [
  { id: 'P-STEMPEL', wt: '/home/comdare/wt-ce-checkpoint', repo: 'ce',
    titel: 'Stempel-Reihenfolge: Transpositions-Sperre statt Ebene 1 (Task #78)',
    dateien: 'ce/libs/cache_engine/include/cache_engine/**/anatomy_*',
    auftrag: `Der urspruengliche Auftrag "Ebene 1 (Makro-Argumente) auf system-vor-organ umbauen" ist
am 10.08. WIDERLEGT: (a) wirkungslos -- die Byte-Identitaet der Praeprozessor-Expansion wurde ZWEIMAL
unabhaengig reproduziert, die Makro-Argumentreihenfolge faellt in der Expansion weg; (b) mein Nenner
war falsch: 46 Vorkommen in 16 Dateien statt der behaupteten 3, darunter 4 Emitter und 3 Slot-Pins.
OFFENE OWNER-FRAGE, die Ebene 3 blockiert: wo steht MESS? {Format,measurement,system,organ} ODER
{Format,system,organ,measurement} -- beide erfuellen "system vorn, organ hinten". NICHT RATEN.
Empfehlung aus der Vorlage: die BESTANDSNEUTRALE TRANSPOSITIONS-SPERRE vorziehen -- eine Wache, die
die heutige Glied-Reihenfolge im Preimage FESTNAGELT, ohne einen einzigen Fingerprint zu brechen.
Sie ist unabhaengig von der MESS-Antwort baubar.`,
    verboten: 'Ebene 1, Ebene 2 (ABI/stamp_layout_version) und Ebene 3 (Preimage-Umordnung) NICHT bauen.' },

  { id: 'P-WARN', wt: '/home/comdare/wt-ce-warn-libs', repo: 'ce',
    titel: 'Warnstufe: S1 Null-Kosten-Ratsche (Tasks #44, #71)',
    dateien: 'ce/cmake/compiler_flags.cmake, ce/cmake/gtest_setup.cmake, ce/tests/unit/',
    auftrag: `"-Wall einfuehren" ist GEGENSTANDSLOS -- die Option steht in cmake/compiler_flags.cmake:22.
Globales -Werror in EINEM Schritt darf NICHT landen: 26 Warnungen in 12 heute schon gedeckten Zielen
wuerden sofort rot. Die alte Begruendung "590/590" ist eine Falsch-Null durch Unix Makefiles.
GEBAUT WIRD NUR S1: die NULL-KOSTEN-RATSCHE -- ausschliesslich Warn-Optionen, die HEUTE NULL Treffer
haben, werden zu -Werror=<option> hochgezogen. -Wcast-align ausdruecklich NICHT (sie hat Treffer).
Der Nenner je Option (Trefferzahl heute) MUSS in der Ausgabe stehen. Zusaetzlich #71: die eine
Release-exklusive -Wstringop-overflow -- Ort ist exakt bekannt, gehoert ins tests/unit-Paket.`,
    verboten: 'KEIN globales -Werror. Keine Option hochziehen, die heute Treffer hat.' },

  { id: 'P-CI-SUPER', wt: '/home/comdare/wt-super-warn', repo: 'super',
    titel: 'GUARD_BASIS_REF literal + Stage-Topologie (Tasks #48, #21)',
    dateien: 'super/.gitlab-ci.yml',
    auftrag: `(a) #48: COMDARE_GUARD_BASIS_REF steht als "origin/$CI_DEFAULT_BRANCH". Die Diff-Hygiene-Wache
misst damit in ce KUMULATIV gegen main und in super PUSH-LOKAL -- und das haelt nur durch eine
GitLab-UI-Einstellung (default_branch), nicht durch ein Werkzeug. Wer den Default-Branch umstellt,
schwaecht die Wache STILL: kein Commit, kein Diff, kein Signal. Auf einen LITERALEN Wert umbauen,
damit die Basis im versionierten Text steht.
ACHTUNG, vom Vor-Workflow gemessen: 4 von 4 heutigen Gates sind gegen den Rueckbau von Teil (c)
BLIND (rc=0). Wer nur umbaut, ohne diese Blindheit zu schliessen, landet ein ungedecktes Paket.
(b) #21: test:unit veroeffentlicht seit D1c seine Inventur als build/Testing/ctest_unit_inventar.txt
-- DER VERBRAUCHER FEHLT. test:coverage-guard liegt in Stage 'contract', test:unit in Stage 'test';
needs darf nicht vorwaerts zeigen (17 needs-Kanten, 0 vorwaerts). Das ist ein Stage-Topologie-Posten.`,
    verboten: 'Die Datei super/LICENSE nicht anfassen (fremdes Paket P-LIZENZ).' },

  { id: 'P-LIZENZ', wt: '/home/comdare/wt-super-d3naht', repo: 'super',
    titel: 'Lizenz: super-Haelfte (Task #66)',
    dateien: 'super/LICENSE, super/README*',
    auftrag: `Owner-Entscheid 10.08.: super = Apache 2.0 · ce + PRT-ART = Forschung frei / proprietaer
fuer Business UND Einzelnutzung · Diplomarbeit = nur Copyright Benjamin-Elias Probst.
Die ce-Haelfte ist gebaut (f6d13dfb). Offen: super, prt-art, overleaf.
EIGENTUM, nie vermengen: Thesis = Benjamin-Elias Probst PRIVAT (natuerliche Person).
CacheEngine/PRT-ART/super = BEP Venture UG, Marke Comdare. Die Abkuerzung "BEP" fuer die PERSON ist
VERBOTEN -- sie verschmilzt Person und Gesellschaft.
Der Vor-Workflow urteilte STIMMT_TEILWEISE und hat NICHTS gebaut; seine Nicht-Bau-Begruendung wurde
von der Verify-Lens am Objekt WIDERLEGT. Pruefe zuerst, ob die Begruendung traegt.`,
    verboten: 'super/.gitlab-ci.yml nicht anfassen (fremdes Paket P-CI-SUPER).' },

  { id: 'P-D37B', wt: '/home/comdare/wt-ce-fk', repo: 'ce',
    titel: 'D3-7b: der dritte Modus pruef_only fehlt (Task #79/P1)',
    dateien: 'ce/ci/lauf_marker.sh, ce/libs/cache_engine/**/profile_run_entry.hpp',
    auftrag: `D3-7 ist gelandet (028684ac): ci/lauf_marker.sh, ci/tests/lauf_marker_probe.sh,
ci/frische_wache.sh, verdrahtet in .gitlab-ci.yml:1665-1667 und :1840-1842. Der Modus kommt aus der
TREIBER-BILANZZEILE, nicht vom Aufrufer.
RESTPOSTEN D3-7b, dreiseitig: 'pruef_only' erscheint NICHT in der Bilanzzeile
(ce profile_run_entry.hpp:1268) -- also kann der Marker ihn nicht fuehren.
Die frueher gebaute Haelfte lag auf einem verlorenen Zweig (bcf6bc97, r7) und ist NICHT
wiederherstellbar. Das hier ist ein BAUAUFTRAG, kein Rettungsauftrag. Nicht nach der alten Fassung
suchen -- sie existiert nicht mehr.`,
    verboten: 'ce/cmake und ce/tests/unit/CMakeLists.txt nicht anfassen (fremde Pakete).' },

  { id: 'P-AGGREGAT', wt: '/home/comdare/wt-super-widefall', repo: 'super',
    titel: 'wide_aggregat: drei Kopien zu einer + ZWEI PARSES (Tasks #29, #30)',
    dateien: 'super/ci/wide_aggregat.sh',
    auftrag: `(a) #29: ci/wide_aggregat.sh traegt DREI Kopien derselben Logik. Eine daraus machen.
(b) #30: ZWEI PARSES, EINE ENTSCHEIDUNG -- profile_has_system_axes wird gegen die Walk-Bedingung
zweimal unabhaengig geparst; zwei Parses koennen auseinanderlaufen, die Entscheidung ist dann
undefiniert. EINEN Parse, EINE Entscheidung.
Bekannter Vorbefund (Posten M4): der Nenner-Riegel des WIDE-Aggregats ist ausdruecklich UNGEDECKT,
ein Mutant ueberlebt. Wenn du die drei Kopien vereinigst, ist das der Moment, den Riegel zu decken.`,
    verboten: 'super/.gitlab-ci.yml nicht anfassen.' },

  { id: 'P-WACHEN', wt: '/home/comdare/wt-super-blindwache', repo: 'super',
    titel: 'Blinde Wache + Mappen-Orakel am INHALT (Tasks #42, #53)',
    dateien: 'super/ci/ (ausser wide_aggregat.sh), super/tests/',
    auftrag: `(a) #42: die Wache NormalizedBarAggregatesRatiosNotRawMedians unterscheidet ihre ZWEI
Hypothesen nicht -- sie ist gegen beide gleich gruen. Eine Wache, die zwei Hypothesen nicht trennt,
prueft keine von beiden. Trennen, mit je einem Gegeneingang (T-4).
(b) #53: das Mappen-Orakel prueft den ZAEHLER, nicht den INHALT -- Koeder M3s ueberlebt. Am INHALT
pruefen, und den Koeder M3s als Rot-Lauf protokollieren (T-1: rot ZUERST).`,
    verboten: 'super/ci/wide_aggregat.sh nicht anfassen (fremdes Paket P-AGGREGAT).' },

  { id: 'P-GLIED', wt: '/home/comdare/wt-ce-messvisitor', repo: 'ce',
    titel: 'Additiv-Vertrag: GLIED [5] leer und GLIED [6] richtungsblind (Tasks #59, #61)',
    dateien: 'ce/libs/cache_engine/**/anatomy_fingerprint.hpp und die mess_gates-Glieder',
    auftrag: `Das 9-gliedrige Preimage lautet {Format, organ, system, measurement,
kSubAxisValuesetSegment, toolchain, bvset, overlay, mess_gates}, kAnatomyFingerprintGliedCount = 9.
(a) #61: GLIED [5] gate_contribution ist LEER -- die zweite Haelfte des Additiv-Vertrags (O-8) fehlt.
(b) #59: GLIED [6] ist RICHTUNGSBLIND -- der Additiv-Vertrag ist als GLEICHHEIT implementiert.
Additiv heisst: Zuwachs ist erlaubt, Rueckbau nicht. Eine Gleichheit faengt beide Richtungen
gleich -- und damit die falsche.
KEINE Umordnung der Glieder (das ist P-STEMPEL und gesperrt). Nur die INHALTE von [5] und [6].`,
    verboten: 'Die Glied-REIHENFOLGE nicht anfassen. kAnatomyFingerprintGliedCount nicht aendern.' },

  { id: 'P-ABSCHRIFT', wt: '/home/comdare/wt-ce-d4', repo: 'ce',
    titel: 'Abschrift-Divergenz der Hygiene-Wache ce gegen super (Task #77)',
    dateien: 'ce/scripts/ci_diff_ascii_width_guard.sh',
    auftrag: `HEUTE AM OBJEKT GEMESSEN (11.08., beim Landen): die beiden Fassungen derselben Wache
haben VERSCHIEDENE Optionsnamen. super kennt "--seit-basis", ce kennt "--bereich <basis> [<spitze>]".
Ein Aufruf mit der jeweils fremden Option bricht ab (ce meldete rc=129 "git diff selbst ist
fehlgeschlagen"). Immerhin FAIL-CLOSED -- keine stille Null. Aber: wer die super-Form abschreibt,
haelt die ce-Wache fuer kaputt, und umgekehrt.
Zeilenumfang: ce 779 Zeilen gegen super 558 (Stand 10.08.) -- die Fassungen sind auseinandergelaufen.
ABSCHRIFT SCHLAEGT LOESCHUNG: die Divergenz wird durch ANGLEICHEN geheilt, nicht durch Loeschen einer
Fassung. Beide Optionsnamen muessen danach in BEIDEN Repos funktionieren (Alias), sonst brechen
Altaufrufe. Die verlorene Vorarbeit (bcf6bc97) ist NICHT wiederherstellbar -- neu bauen.`,
    verboten: 'super nicht anfassen -- du baust NUR die ce-Haelfte. Die super-Haelfte ist ein Folgepaket.' },

  { id: 'P-D2FLOOR', wt: '/home/comdare/wt-ce-d2floor', repo: 'ce',
    titel: 'd2-floor: 3 Commits mit Merge-Konflikten -- obsolet oder zu retten? (Task #64)',
    dateien: 'ce/tests/unit/ (d2floor-Zweig)',
    auftrag: `Der Zweig w0a/d2-floor traegt 3 Commits und kollidiert beim Merge auf development an
DREI Stellen. Task #64 sagt: die fuenf d2floor-Tests sind auf development SCHON DA -- umbenannt und
STAERKER. AbgestuerztesCtest... heisst dort KaputteInventurIstWerkzeugFehler und prueft zusaetzlich
das Phantom-Gate.
DEINE ERSTE FRAGE IST DESHALB: ist dieser Zweig noch ein Bau-Paket oder ist er ERLEDIGT?
Ein NAMENS-Diff ist KEIN SACH-Diff. Vergleiche die AUSSAGE der Tests, nicht ihre Namen -- genau
dieser Fehler hat den Posten urspruenglich erzeugt.
Wenn erledigt: sage es, streiche den Posten, baue NICHTS. Ein Neubau erzeugte eine ZWEITE WAHRHEIT
neben etwas Fertigem und entwertete dessen gefahrene Koeder.
Wenn ein Rest bleibt: NUR den Rest bauen, konfliktfrei gegen origin/development.`,
    verboten: 'Nicht blind mergen. Erst die Sach-Frage beantworten.' },
]

const SOLL_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['paket', 'urteil', 'soll', 'quellen', 'offene_owner_frage'],
  properties: {
    paket: { type: 'string' },
    urteil: { type: 'string', enum: ['STIMMT', 'STIMMT_TEILWEISE', 'STIMMT_NICHT', 'SCHON_ERLEDIGT'] },
    soll: { type: 'string', description: 'Wie das Paket AUSSEHEN MUESSTE, aus dem Korpus belegt' },
    quellen: { type: 'array', items: { type: 'string' }, description: 'Datei:Zeile oder Dokument:Abschnitt je Aussage' },
    gegenprobe: { type: 'string', description: 'Bei jedem Nichtfund: Muster das sicher trifft, mit Trefferzahl' },
    offene_owner_frage: { type: 'string', description: 'Leer, wenn keine. Sonst: was der Owner entscheiden muss und warum es nicht ableitbar ist' },
  },
}

const IST_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['paket', 'ist', 'dateien', 'belege'],
  properties: {
    paket: { type: 'string' },
    ist: { type: 'string', description: 'Was am Objekt WIRKLICH gebaut ist' },
    dateien: { type: 'array', items: { type: 'string' } },
    belege: { type: 'array', items: { type: 'string' }, description: 'Kommando + woertliche Ausgabe, je Aussage' },
    nenner: { type: 'string', description: 'Grundgesamtheit jeder genannten Zahl' },
    schon_gebaut: { type: 'boolean', description: 'true, wenn das Paket am Objekt bereits erfuellt ist' },
  },
}

const DIFF_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['paket', 'delta', 'bauplan', 'darf_nicht_gebaut_werden', 'baubar'],
  properties: {
    paket: { type: 'string' },
    baubar: { type: 'boolean', description: 'false, wenn eine Owner-Frage oder ein fremdes Paket blockiert' },
    delta: { type: 'array', items: { type: 'string' }, description: 'Je Punkt: SOLL sagt X, IST ist Y' },
    bauplan: { type: 'string', description: 'Konkrete Schritte, Datei fuer Datei, mit Abnahme je Schritt' },
    koeder: { type: 'string', description: 'Der zufaellig zu erzeugende Koeder und was er rot machen MUSS' },
    darf_nicht_gebaut_werden: { type: 'array', items: { type: 'string' } },
  },
}

const BAU_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['paket', 'gebaut', 'zusammenfassung', 'offen'],
  properties: {
    paket: { type: 'string' },
    gebaut: { type: 'boolean' },
    commit: { type: 'string', description: 'SHA, leer wenn nichts gebaut' },
    zusammenfassung: { type: 'string' },
    dateien: { type: 'array', items: { type: 'string' } },
    koeder_rot_lauf: { type: 'string', description: 'Literale Ausgabe des Rot-Laufs VOR der Heilung' },
    gegenkoeder_gruen: { type: 'string', description: 'Literale Ausgabe des unmanipulierten Laufs' },
    nenner: { type: 'string' },
    offen: { type: 'array', items: { type: 'string' }, description: 'Ausdruecklich ungedeckt -- nie durch Weglassen' },
  },
}

const REVIEW_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['paket', 'lens', 'verdikt', 'blocker'],
  properties: {
    paket: { type: 'string' },
    lens: { type: 'string' },
    verdikt: { type: 'string', enum: ['LANDEFAEHIG', 'NACHBESSERN', 'DARF_NICHT_LANDEN'] },
    blocker: { type: 'array', items: { type: 'string' }, description: 'Je Blocker: Datei:Zeile + warum' },
    bestaetigt: { type: 'array', items: { type: 'string' } },
    eigene_messung: { type: 'string', description: 'Was DU selbst am Objekt gemessen hast, nicht uebernommen' },
  },
}

// ---------- BAU-SCHLANGE: genau EIN Bau zur Zeit ----------
// Owner-Anweisung 11.08.: "machen wir den Bau sequentiell und erst verify wie geplant wieder
// parallel". Anlass ist gemessen: zehn gleichzeitige Bauten haben die Platte auf 2,3 MB gefahren
// (ein ce-Bau belegt ueber 6 G), danach fielen sogar die PreToolUse-Hooks aus.
//
// WARUM EINE SCHLANGE UND KEIN UMBAU DER PIPELINE: die Stufen SOLL/IST/DIFF sollen weiter
// ueberlappen -- Paket B exploriert, waehrend A schon entworfen wird. Ein Umbau auf
// pipeline(3 Stufen) + Schleife wuerde die Reihenfolge der agent()-Aufrufe aendern und damit
// den Resume-Cache der 30 bereits fertigen Agenten entwerten. Die Schlange serialisiert
// AUSSCHLIESSLICH die Bau-Stufe und laesst die Prompts byte-gleich.
let bauSchlange = Promise.resolve()
function seriell(fn) {
  const lauf = bauSchlange.then(fn, fn)   // auch nach einem Fehlschlag des Vorgaengers weiterfahren
  bauSchlange = lauf.then(() => {}, () => {})  // die Kette darf nie an einem Fehler zerreissen
  return lauf
}

log(`Start: ${PAKETE.length} Pakete. Explore+Design parallel, BAU SEQUENTIELL (einer zur Zeit), Verify wieder parallel.`)

const ergebnis = await pipeline(
  PAKETE,

  // ---------- STUFE 1: SOLL (Sonnet 5, max effort -- Owner-Dauerregel fuer Explore) ----------
  (p) => agent(`STUFE 1 von 5 -- SOLL-EXPLORE. Paket ${p.id}: ${p.titel}

${DOK}

DEINE FRAGE, und NUR sie: WIE MUESSTE DIESES PAKET AUSSEHEN? Nicht "wie baue ich das".
Der Owner hat am 10.08. angeordnet: "Jede Verarbeitung braucht vorne einen Explore, ob ueberhaupt der
KERN ihrer Aufgabe stimmt, sonst muessen wir die DEFINITION der Aufgabe korrigieren."

DER AUFTRAG, WIE ER HEUTE LAUTET (er kann falsch sein -- das herauszufinden ist deine Arbeit):
${p.auftrag}

AUSDRUECKLICH VERBOTEN: ${p.verboten}

KORPUS -- neun Wochen zurueck, "very thorough":
  /home/comdare/wt-super-landung/docs/plaene/    /home/comdare/wt-super-landung/docs/sessions/
  /home/comdare/wt-super-landung/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md
  /home/comdare/.claude/projects/-home-comdare/memory/
  und die KONSOLIDIERUNG der 106 unverlinkten Memories:
  /home/comdare/wt-super-landung/docs/plaene/20260810-KONSOLIDIERUNG-*

DREI REGELN, ohne die diese Stufe nichts wert ist:
 1. Leitfrage ist "WAS WURDE DAZU FESTGELEGT?", nicht "wie baue ich das?".
 2. JEDER Nichtfund braucht eine GEGENPROBE -- ein Muster das sicher trifft, mit Trefferzahl.
 3. Findest du GAR NICHTS, ist die Festlegung NEU und wird als neu protokolliert.

Urteile mit einem von vier Werten: STIMMT / STIMMT_TEILWEISE / STIMMT_NICHT / SCHON_ERLEDIGT.
Findest du eine Frage, die NUR der Owner entscheiden kann: benenne sie und sage, warum sie nicht
ableitbar ist. RATE NIE.

LIES NUR. Aendere keine Datei.`,
    { label: `soll:${p.id}`, phase: 'SOLL', model: 'sonnet', effort: 'max', schema: SOLL_SCHEMA }),

  // ---------- STUFE 2: IST (Sonnet 5, max effort) ----------
  (soll, p) => agent(`STUFE 2 von 5 -- IST-EXPLORE. Paket ${p.id}: ${p.titel}

${DOK}

DEINE FRAGE: WAS IST AM OBJEKT WIRKLICH GEBAUT? Nicht was der Plan sagt -- was der Code TUT.

DAS SOLL, das Stufe 1 erhoben hat (Urteil: ${soll?.urteil ?? 'unbekannt'}):
${soll?.soll ?? '(Stufe 1 lieferte nichts -- erhebe das IST trotzdem)'}
Quellen von Stufe 1: ${JSON.stringify(soll?.quellen ?? [])}

MESS HIER: ${p.wt}  (Repo ${p.repo})
Betroffene Dateien laut Auftrag: ${p.dateien}

PRUEFE DIE QUELLEN VON STUFE 1 SELBST NACH -- Stufe 1 hat kartiert, du liest jede tragende Referenz
am Objekt gegen. Ein Bericht ist Beweismaterial, kein Beweis. Wo Stufe 1 eine Zeile nennt: oeffne sie.
Wo sie eine Zahl nennt: miss sie neu, mit deinem eigenen Kommando.

SAG AUSDRUECKLICH, wenn das Paket am Objekt BEREITS ERFUELLT ist (schon_gebaut=true). Sechs von
vierzehn Paketen waren das am 10.08. -- ein Neubau haette eine ZWEITE WAHRHEIT neben etwas Fertiges
gestellt und dessen gefahrene Koeder entwertet.

Jede Zahl mit Nenner. Jeder Nichtfund mit Gegenprobe. LIES NUR.`,
    { label: `ist:${p.id}`, phase: 'IST', model: 'sonnet', effort: 'max', schema: IST_SCHEMA })
    .then(ist => ({ soll, ist, p })),

  // ---------- STUFE 3: DIFF-DESIGN (Fable 5, max) ----------
  ({ soll, ist, p }) => agent(`STUFE 3 von 5 -- DIFF-DESIGN. Paket ${p.id}: ${p.titel}

${DOK}

Du bekommst zwei unabhaengige Erhebungen und baust daraus den BAUPLAN. Du baust NICHT selbst.

=== SOLL (Stufe 1, Urteil ${soll?.urteil ?? '?'}) ===
${soll?.soll ?? '(leer)'}
Offene Owner-Frage: ${soll?.offene_owner_frage || '(keine)'}

=== IST (Stufe 2, schon_gebaut=${ist?.schon_gebaut ?? '?'}) ===
${ist?.ist ?? '(leer)'}
Dateien: ${JSON.stringify(ist?.dateien ?? [])}
Belege: ${JSON.stringify(ist?.belege ?? [])}

DEINE ARBEIT:
 1. DELTA je Punkt: "SOLL sagt X, IST ist Y". Wo SOLL und IST sich DECKEN, sag es -- das ist ein
    Punkt, der NICHT gebaut wird.
 2. BAUPLAN: konkrete Schritte, Datei fuer Datei, mit der ABNAHME je Schritt.
 3. KOEDER (K13): was wird zufaellig erzeugt, und was MUSS dadurch rot werden? Beide Richtungen --
    der Gegenkoeder (unmanipuliert) muss gruen bleiben, sonst ist die Wache konstant rot.
 4. DARF NICHT GEBAUT WERDEN: alles, was der Auftrag verlangt, aber das IST widerlegt.
 5. BAUBAR: false, wenn eine Owner-Frage blockiert oder ein fremdes Paket die Datei haelt.

Sagt Stufe 2 schon_gebaut=true, ist baubar=false und der Bauplan lautet "streichen, nicht bauen" --
mit der Begruendung am Objekt.

VERBOTEN in diesem Paket: ${p.verboten}`,
    { label: `diff:${p.id}`, phase: 'DIFF', model: 'fable', effort: 'max', schema: DIFF_SCHEMA })
    .then(d => ({ soll, ist, diff: d, p })),

  // ---------- STUFE 4: BAU (Opus 5, max effort) ----------
  ({ soll, ist, diff, p }) => {
    if (!diff || diff.baubar === false) {
      log(`${p.id}: NICHT baubar -- ${diff?.darf_nicht_gebaut_werden?.[0] ?? 'Stufe 3 lieferte nichts'}`)
      return { paket: p.id, gebaut: false, commit: '',
        zusammenfassung: `NICHT GEBAUT. Grund: ${diff?.bauplan ?? 'Stufe 3 lieferte kein Ergebnis'}`,
        offen: diff?.darf_nicht_gebaut_werden ?? ['Stufe 3 ohne Ergebnis'], _diff: diff, _p: p }
    }
    log(`${p.id}: reiht sich in die Bau-Schlange ein (es baut immer nur EINER)`)
    return seriell(() => agent(`STUFE 4 von 5 -- BAU. Paket ${p.id}: ${p.titel}

${DOK}

DEIN WORKTREE: ${p.wt}   -- du bist dort der EINZIGE Schreiber.
Arbeite NUR dort. Fasse KEINEN anderen Worktree an. git IMMER mit -C ${p.wt}.

BAUPLAN aus Stufe 3:
${diff.bauplan}

DELTA, das du schliesst:
${(diff.delta ?? []).map((d, i) => `  ${i + 1}. ${d}`).join('\n')}

KOEDER, den du fahren MUSST:
${diff.koeder ?? '(Stufe 3 nannte keinen -- dann wuerfle selbst einen und benenne ihn)'}

DARF NICHT GEBAUT WERDEN:
${(diff.darf_nicht_gebaut_werden ?? []).map(d => `  - ${d}`).join('\n') || '  (nichts benannt)'}
VERBOTEN in diesem Paket: ${p.verboten}

DER TDD-VERTRAG, bindend:
  T-1 ROT ZUERST     Test am ersten Tag rot ODER Biss per protokollierter Wegwerf-Mutation.
                     Beides fehlt = kein Test. Ein Test, der am GESUNDEN Objekt nie gruen wird,
                     ist ebenso unzulaessig (Daueralarm).
  T-2 AUSSAGE        find(), Existenz, Exit 0, "wirft nicht" sind KEINE Zusicherungen.
  T-3 NENNER FREMD   Grundgesamtheit aus einer ANDEREN Quelle als dem Prueflig; ASSERT auf die
                     Zahl VOR der Schleife.
  T-4 GEGENEINGANG   zu jeder Zusicherung ein Eingang, bei dem sie NICHT gilt.
  T-6 SCHWESTER      jeder Fix sucht im selben Zug die Schwesterstelle (beide Writer, beide Genera).
  T-7 REGISTRIERUNG  ein Test existiert erst, wenn er in ctest -N erscheint.

BAU-REIHENFOLGE bei ce (J-1..J-4, sonst ist dein Gruen falsch):
  Werkzeuge ZUERST (adhoc_emitter_cli, anatomy_codegen_cli, alle *_registry_gen)
  -> RE-CONFIGURE -> Vollbau -> --target comdare_tests -> ctest.
  'cmake --build' allein reicht NIE.

PLATTEN-AUFLAGE -- am 11.08. hat sie einen ganzen Lauf gekostet, deshalb ist sie bindend:
  Zehn Pakete bauen gleichzeitig auf EINER Platte. Am 11.08. lief sie auf 2.3 MB voll; danach
  scheiterte JEDES Werkzeug, auch die PreToolUse-Hooks, und kein Agent konnte sich selbst mehr
  helfen -- nicht einmal aufraeumen, weil dafuer wieder ein Werkzeug noetig gewesen waere.
  (a) VOR jedem Vollbau: 'df -h /' ausfuehren. Unter 5G frei baust du NICHT, sondern meldest es
      als Blocker zurueck. Ein Bau, der mitten im Linken auf ENOSPC laeuft, hinterlaesst einen
      halben Baum und eine Fehlermeldung, die wie ein Code-Fehler aussieht.
  (b) NACH deinem Bau: dein eigenes Bauverzeichnis wieder entfernen, sobald ctest gelaufen ist.
      VORHER pruefen -- 'git -C <wt> ls-files <build>' UND find auf *.csv/*.xlsx, BEIDE muessen 0
      liefern. In ce-Bauverzeichnissen liegen versionierte Mess-CSV; Messdaten werden NIE geloescht.
  (c) Kein Hintergrund-Bau, den du nicht selbst wieder beenden kannst. Merke dir seine Shell-ID.
  (d) Baust du ueberhaupt nicht (reines Doku- oder Skript-Paket), sag es -- dann faellt (a) weg.

COMMITTE deine Arbeit im Worktree (NICHT pushen -- das Landen macht der Lead).
ASCII-Selbstcheck vor dem Commit: keine Umlaute, keine Em-Dashes, keine typografischen
Anfuehrungszeichen in Code/Skripten/CMake. Pruefe es literal, verlasse dich nicht darauf.

Keine Erfolgsmarke ohne literale Werkzeug-Ausgabe. Was du nicht gemessen hast, gehoert in 'offen'.`,
      { label: `bau:${p.id}`, phase: 'BAU', model: 'opus', effort: 'max', schema: BAU_SCHEMA }))
      .then(b => ({ ...b, _diff: diff, _p: p }))
  },

  // ---------- STUFE 5: DUAL-REVIEW (Codex + Fable 5 max) ----------
  (bau) => {
    const p = bau?._p
    if (!bau?.gebaut) {
      log(`${p?.id}: nichts gebaut -- kein Review noetig`)
      return { paket: p?.id, bau, reviews: [], uebersprungen: true }
    }
    const gemeinsam = `Paket ${p.id}: ${p.titel}
Worktree: ${p.wt}   Commit: ${bau.commit}

WAS GEBAUT WURDE:
${bau.zusammenfassung}
Dateien: ${JSON.stringify(bau.dateien ?? [])}
Koeder-Rot-Lauf: ${bau.koeder_rot_lauf ?? '(keiner protokolliert -- das ist selbst ein Blocker, T-1)'}
Gegenkoeder-Gruen: ${bau.gegenkoeder_gruen ?? '(keiner -- pruefe, ob die Wache konstant rot ist)'}
Nenner: ${bau.nenner ?? '(keiner genannt -- V-1-Verstoss)'}
Vom Bauenden selbst als offen benannt: ${JSON.stringify(bau.offen ?? [])}

${DOK}

DEIN AUFTRAG: dieses Paket ADVERSARISCH pruefen. Versuche zu WIDERLEGEN, dass es landefaehig ist.
Miss selbst am Objekt -- uebernimm KEINE Zahl aus dem Bericht oben ungeprueft.

Die fuenf Pruefungen, je Aussage des Bauenden:
 1. NENNER      -- ueber welcher Grundgesamtheit? Steht sie in der AUSGABE?
 2. GEGENSTAND  -- misst der Beleg DIE SACHE oder etwas Benachbartes, das billiger war?
 3. ZEITRICHTUNG-- lief die Messung VOR der Aussage?
 4. DECKUNG     -- was erzwingt das Halten: WERKZEUG, Disziplin oder Zufall? Nur die erste zaehlt.
 5. WIDERRUF    -- wenn er etwas korrigiert: ist die NEUE Aussage so hart geprueft wie die alte?

Verdikt: LANDEFAEHIG / NACHBESSERN / DARF_NICHT_LANDEN. Im Zweifel das strengere.`

    return parallel([
      // Lens 1: Codex (Regressions-Lens, GPT-5)
      () => agent(`DUAL-REVIEW, LENS 1 von 2 -- CODEX.

${gemeinsam}

FUEHRE DIESEN REVIEW UEBER DAS MCP-WERKZEUG "codex" AUS.
Lade es zuerst: ToolSearch mit "select:mcp__codex__codex".
Pflicht-Parameter beim Aufruf:
    approval-policy: never
    sandbox: danger-full-access     <-- WICHTIG: "workspace-write" ist auf prod1 DEFEKT
                                        (bwrap RTM_NEWADDR, gemessen 09.08.)
    cwd: ${p.wt}

CODEX-BETRIEBSREGELN, aus Schaden gelernt:
  * Codex NIEMALS selbst git ausfuehren lassen -- git diff/git log haengen bis in den Idle-Timeout.
    Liefere den DIFF-TEXT IM PROMPT mit (hole ihn selbst per git -C ${p.wt} diff).
  * Sein Output ist KARTIERUNG, nie Zitat -- jede tragende Referenz liest du selbst nach.
  * Haengt der Thread: FRISCHER Thread statt Diagnose am Prompt.
  * Keine Codex-Zeile und keine Codex-Zahl wandert ungeprueft in dein Verdikt.

Belegt schwach bei Codex und deshalb von dir gegenzupruefen: veralteter Stand, Zeilenanker auf
Nachbargegenstaende, Ganzheits-Behauptungen an Teilmengen gemessen, Koeder die nicht beissen.

Gib in 'eigene_messung' an, was DU selbst am Objekt gemessen hast -- nicht, was Codex sagte.`,
        { label: `review-codex:${p.id}`, phase: 'REVIEW', model: 'opus', effort: 'high', schema: REVIEW_SCHEMA }),

      // Lens 2: Fable 5 max (Meta-Stufe)
      () => agent(`DUAL-REVIEW, LENS 2 von 2 -- META-STUFE.

${gemeinsam}

Du bist die META-STUFE. Ihr Wert ist gemessen: einstufige Kritik verliert am Objekt EIN VIERTEL
ihrer Behauptungen (40 von 157) und uebersieht zusaetzlich MEHR ALS DIE HAELFTE ihres Fundvolumens
(62 Meta-Eigenfunde gegen 117). Deshalb bist du Pflicht, nicht Kuer.

DEIN BLICK IST EIN ANDERER als der der ersten Lens. Frage nicht "ist der Code richtig", sondern:

 * WAS FEHLT? Welche Schwesterstelle wurde nicht gesucht (T-6)? Welcher zweite Writer, welches
   zweite Genus, welches zweite Backend?
 * BEISST DER KOEDER WIRKLICH? Ein Koeder, der IMMER beisst, ist so wertlos wie einer, der NIE
   beisst. Sind BEIDE Richtungen gefahren?
 * IST DIE WACHE MIT SICH SELBST EINIG? Die teuerste belegte Klasse: eine Wache, die ihren Nenner
   aus der eigenen Inventur zieht, kann eine fehlende Registrierung grundsaetzlich nicht bemerken.
 * ZEMENTIERT EIN TEST EINEN DEFEKT? Dreimal an einem Tag war der TEST der Defekt. Ein Randfall-Test,
   der nur Absturzfreiheit prueft, unterschreibt stillschweigend die Semantik, die er vorfindet.
 * WAS ERZWINGT DAS HALTEN? Zufall, Disziplin und Maschine sehen im Rueckblick IDENTISCH GRUEN aus.
   Unterscheidbar nur an dieser Frage. "Wir achten darauf" gilt als NICHT ABGENOMMEN.

Und die Frage, die V-8 stellt, auf JEDE Formel des Pakets angewandt:
   "Was waere der Zustand, in dem diese Ausgabe erscheint und die Sache trotzdem nicht existiert?"

Gib in 'eigene_messung' an, was DU selbst am Objekt gemessen hast.`,
        { label: `review-meta:${p.id}`, phase: 'REVIEW', model: 'fable', effort: 'max', schema: REVIEW_SCHEMA }),
    ]).then(rs => ({ paket: p.id, bau, reviews: rs.filter(Boolean), uebersprungen: false }))
  },
)

// ---------- Bilanz ----------
const gueltig = ergebnis.filter(Boolean)
const gebaut = gueltig.filter(r => r.bau?.gebaut)
const landefaehig = gebaut.filter(r => r.reviews.length === 2 && r.reviews.every(v => v.verdikt === 'LANDEFAEHIG'))
const strittig = gebaut.filter(r => r.reviews.length === 2 && r.reviews.some(v => v.verdikt !== 'LANDEFAEHIG'))
const nicht_gebaut = gueltig.filter(r => !r.bau?.gebaut)

log(`BILANZ: ${gueltig.length} von ${PAKETE.length} Paketen durchgelaufen`)
log(`  landefaehig (BEIDE Lenses): ${landefaehig.length}`)
log(`  strittig (mindestens eine Lens dagegen): ${strittig.length}`)
log(`  nicht gebaut: ${nicht_gebaut.length}`)

return {
  nenner: { pakete: PAKETE.length, durchgelaufen: gueltig.length },
  landefaehig: landefaehig.map(r => ({ paket: r.paket, commit: r.bau.commit, wt: PAKETE.find(p => p.id === r.paket)?.wt })),
  strittig: strittig.map(r => ({
    paket: r.paket, commit: r.bau.commit,
    verdikte: r.reviews.map(v => `${v.lens}: ${v.verdikt}`),
    blocker: r.reviews.flatMap(v => v.blocker ?? []),
  })),
  nicht_gebaut: nicht_gebaut.map(r => ({ paket: r.paket, grund: r.bau?.zusammenfassung ?? r.uebersprungen })),
  alle_offenen_punkte: gebaut.flatMap(r => (r.bau.offen ?? []).map(o => `${r.paket}: ${o}`)),
}
