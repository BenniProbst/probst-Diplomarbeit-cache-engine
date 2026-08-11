export const meta = {
  name: 'owner-antworten-nacht7c',
  description: 'Neun Straenge: drei Owner-Explore-Auftraege, drei Kontext-Bitten, drei neue Architektur-Aussagen am Objekt pruefen',
  phases: [
    { title: 'Explore' },
    { title: 'Gegenprobe' },
    { title: 'Synthese' },
  ],
}

const SUPER = '/home/comdare/wt-super-landung'
const CE    = '/home/comdare/wt-super-landung/Code/external/comdare-cache-engine'
const PROJ  = '/home/comdare/Projekte/docs'
const ROH   = '/home/comdare/.claude/projects/-home-comdare'

const GRUND = `
ARBEITSREGELN (bindend, aus der Owner-Doktrin):
- Suche nach dem GEGENSTAND, nicht nach dem Konsumenten. Ein Modul kann gebaut und
  ungerufen sein -- eine Konsumenten-Suche meldet dann faelschlich "fehlt".
- DREI FALSCH-NULL-KLASSEN, gegen die du absichern musst:
  (1) Encoding (Umlaute, ae/oe/ue-Umschriften, UTF-8 vs Latin-1)
  (2) Case (gross/klein)
  (3) ZEILENUMBRUCH bei ~95 Zeichen -- Begriffe werden in Dokumenten umbrochen!
      Suche deshalb NIE nur nach Mehrwortphrasen, sondern auch nach Einzelteilen.
- Der Schraegstrich-Falle vorbeugen: '-path "*/build*/*" -prune' frisst auch
  'libs/cache_engine/builder/'. Nutze exakte Pfadmuster.
- JEDER NICHTFUND braucht eine GEGENPROBE: suche ein Wort, das garantiert vorkommt,
  und zeige, dass dein Werkzeug es findet. Ohne Gegenprobe ist eine Null wertlos.
- Gib IMMER Datei:Zeile als Beleg an. Zahlen ohne Beleg sind unbrauchbar.
- Wenn du etwas NICHT findest, sage das klar -- rate NICHT.

ORTE:
  super (Diplomarbeit, Doku+CI):  ${SUPER}
  ce (der C++-Code):              ${CE}
  Projekte-Doktrin:               ${PROJ}
  Roh-Transkripte (20 JSONL):     ${ROH}/*.jsonl
  Ledger:  ${SUPER}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md  (21801 Zeilen,
           Nachtraege stehen OBEN, neueste zuerst: KON15, KON14, KON13, ...)
  Plaene:  ${SUPER}/docs/plaene/
  Sessions:${SUPER}/docs/sessions/
`

const SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['antwort', 'belege', 'sicherheit', 'gegenprobe'],
  properties: {
    antwort: { type: 'string', description: 'Die Antwort auf die gestellte Frage, praezise, mit Zahlen' },
    belege: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['ort', 'inhalt'],
        properties: {
          ort: { type: 'string', description: 'Datei:Zeile oder Dokument+Abschnitt' },
          inhalt: { type: 'string', description: 'Woertlich oder eng paraphrasiert, was dort steht' },
        },
      },
    },
    sicherheit: { type: 'string', enum: ['belegt', 'wahrscheinlich', 'nicht gefunden'] },
    gegenprobe: { type: 'string', description: 'Welches garantiert vorhandene Wort hast du gesucht, und mit welchem Ergebnis? Pflicht bei jedem Nichtfund.' },
    offen: { type: 'string', description: 'Was konntest du NICHT klaeren?' },
  },
}

const STRAENGE = [
  {
    key: 'A-flag-syntax',
    titel: 'Frage 1 -- die VOLLE Flag-Syntax, c = CPU',
    owner: `Owner 11.08.2026: "Doch die ist festgelegt und in der vollen Syntax steht c fuer CPU (etwa in cp oder ce). Bitte explore."`,
    auftrag: `Die Semantik der Achsen-Versionsflags galt mir als offen. Der Owner sagt: sie IST festgelegt.
Das Kuerzel 'c' in Flags wie '1.0.0.c' steht fuer CPU, und es gibt eine VOLLE Syntax mit
mehrstelligen Kuerzeln -- der Owner nennt beispielhaft 'cp' und 'ce'.

FINDE:
 1. Die vollstaendige Grammatik/Legende dieser Kuerzel. Wo ist sie definiert oder beschrieben?
 2. Was bedeuten 'cp' und 'ce'? (CPU + was? Der Owner nennt sie als Beispiele der VOLLEN Syntax)
 3. Welche weiteren Kuerzel gibt es -- gpu? fpga? npu? avx? Wie werden sie kombiniert?
 4. Ist die Grammatik ein-, zwei- oder mehrstellig? Gibt es Trennzeichen?
 5. Steht sie im Code (algo_semver.hpp), in einem Plan, in einem Roh-Transkript, in docs/termine?

WICHTIG: 'c', 'cp', 'ce' sind SEHR kurze Suchbegriffe -- eine naive Suche ertrinkt in Treffern.
Suche gezielt nach dem KONTEXT: Flag-Literale wie "1.0.0.c", "1.0.2.c", Legenden-Tabellen,
Aufzaehlungen von Hardware-Kuerzeln, Kommentare in algo_semver.hpp, Owner-Saetze in Transkripten
in denen 'cp' oder 'ce' zusammen mit CPU/Hardware/Grammatik/Syntax vorkommen.
Beachte: 'ce' ist auch die Abkuerzung fuer cache_engine -- unterscheide die Bedeutungen!`,
  },
  {
    key: 'B-flag-seiten',
    titel: 'Frage 2 -- freigebende Seite vs. compile-time-Seite',
    owner: `Owner 11.08.2026: "Das kommt darauf an, ob das Flag auf der freigebenden Seite oder der compile time Seite steht (explore). Im Falle der Freigabe impliziert es das Vorhandensein und im Falle der compile Seite Fordert das Flag das Vorhandensein von Hardware ein. Im Falle von DREIPHASIG fordert die Messachse der CEB ausserdem die Einhaltung des Vertrages mit den Messfuehlern der Tier-Binary bzw. Hybrid."`,
    auftrag: `Die Frage war: fordert ein Flag seine Voraussetzung, oder impliziert es sie? Der Owner
antwortet: BEIDES -- es haengt von der SEITE ab.

  FREIGEBENDE Seite   -> das Flag IMPLIZIERT das Vorhandensein
  COMPILE-TIME Seite  -> das Flag FORDERT das Vorhandensein von Hardware EIN
  DREIPHASIG zusaetzlich: die Mess-Achse der CEB fordert die Einhaltung des VERTRAGES
                          mit den MESSFUEHLERN der Tier-Binary bzw. des Hybrid

FINDE AM OBJEKT:
 1. Wo im Code steht die "freigebende Seite"? (Freigabe/Release/Approval/Gate -- welche
    Dateien, welche Funktionen, welche Achsen-Ebene?)
 2. Wo steht die "compile-time Seite"? (static_assert, constexpr, concept, requires --
    algo_semver.hpp hat 294 static_assert)
 3. Welche der ~123 Flag-Literale liegen auf welcher Seite? Gib die Aufteilung mit Zahlen.
 4. Gibt es heute schon eine Unterscheidung der beiden Seiten im Code, oder werden Flags
    an beiden Stellen gleich behandelt? (Das entscheidet, ob S-3 eine Wache oder ein
    Normalisierer wird.)
 5. MESSFUEHLER-VERTRAG: existiert er? Suche nach dem Vertrag zwischen der Mess-Achse der
    CEB und den Messfuehlern in Tier-Binary/Hybrid. Begriffe: Messfuehler, Fuehler, probe,
    sensor, measurement contract, Mess-Visitor, measure_visitor. Ist er compile-time
    durchgesetzt oder nur beschrieben?`,
  },
  {
    key: 'C-export-ziele',
    titel: 'Frage 8 -- was war als Export an die Ziele geplant',
    owner: `Owner 11.08.2026: "Die Gesamtkette war doch schon immer, dass wir eine XML konfigurieren und den Planer Starten, um das Experiment durchzufuehren und die Ergebnisse wie geplant (explore) an Ziele zu exportieren in Formaten wie latex und PDF, Messwerte als xlsx und wo weiter (explore). Angefordert heisst also: Wir starten super als Anwender der Cache engine ueber die XML und laufen die Gesamte Kette."`,
    auftrag: `Ich hatte gefragt, was ein Mess-Artefakt "individuell in der XML angefordert" macht, und eine
Positivliste vs. Klassenregel angeboten. Der Owner sagt: falsche Frage. "Angefordert" heisst
schlicht: super wird als ANWENDER der Cache-Engine ueber die XML gestartet und laeuft die
GESAMTE Kette.

FINDE, WAS "WIE GEPLANT" HEISST -- der Owner markiert es zweimal mit (explore):
 1. Welche AUSGABE-ZIELE waren geplant? Der Owner nennt: LaTeX, PDF, Messwerte als xlsx,
    "und so weiter". Was ist das "und so weiter"? (csv? json? HTML? Diagramme? svg/png?)
 2. Wo ist die Zuordnung Artefakt -> Ziel dokumentiert? (Plaene, Ledger, XSD, XML-Beispiele)
 3. Wie wird das heute in der XML konfiguriert? Gibt es Elemente fuer Ausgabeformate,
    Ausgabeziele, Export? Zeige das XSD-Fragment.
 4. Die Kette: XML -> Planer -> Experiment -> Export. Welche Stationen sind heute gebaut,
    welche fehlen? (Es gibt eine 8-Stationen-Kette im Ledger.)
 5. Wer schreibt heute nach Cluster_NFS/cache-engine-experiment, und was genau?`,
  },
  {
    key: 'D-traeger-typ-instanz',
    titel: 'Frage 6 Kontext -- je Traeger-TYP oder je INSTANZ',
    owner: `Owner 11.08.2026 auf meine Frage "je Traeger-Typ oder je Instanz?": "Ich brauche mehr Kontext."`,
    auftrag: `Der Owner braucht Kontext, um zu entscheiden. LIEFERE IHN -- beantworte die Frage NICHT selbst,
sondern stelle die Entscheidungsgrundlage zusammen.

ES GEHT UM: die Bau-Einheiten der Traeger-Kette. Es gibt VIER Traeger-TYPEN
(Planer, CEB, Tier-Binary, Hybrid). Die Frage war, ob jeder TYP eine Bau-Einheit bekommt
(4 Stueck) oder jede INSTANZ (also jede konkrete permutierte Binary).

SAMMLE:
 1. Wie viele INSTANZEN gibt es je Typ? Planer: vermutlich 1. CEB: 3!=6 (Permutationen)?
    Tier-Binary: wie viele? Hybrid: 4!=24 oder 48? Belege jede Zahl.
 2. Was ist die AKTUELLE Zahl im Bestand -- wie viele Binaries werden heute tatsaechlich
    gebaut? (Achtung: die Binary-Zahl kommt laut Owner NUR vom fertigen Planer.)
 3. Was kostet eine Bau-Einheit? (Bauzeit, Speicher -- ein ce-Bau = 6 G laut Ledger)
 4. Was waere der UNTERSCHIED in der Praxis: 4 Bau-Einheiten gegen N? Wo wuerde es
    wehtun (Runner-Kapazitaet: concurrent=4, zwei Hosts prod1/prod2)?
 5. Gibt es im Bestand oder in den Plaenen schon eine Aussage dazu? WICHTIG: eine
    kursierende Empfehlung "je Typ" stammt nachweislich von MIR (Assistant), nicht vom
    Owner -- pruefe, ob es eine echte Owner-Quelle gibt.`,
  },
  {
    key: 'E-eigene-beduerfnisse',
    titel: 'Frage 7 Kontext -- was heisst "eigene Beduerfnisse" je Traeger',
    owner: `Owner 11.08.2026 auf meine Frage nach "eigenen Beduerfnissen": "Ich brauche nochmal mehr Kontext."`,
    auftrag: `Der Owner braucht Kontext. LIEFERE IHN -- entscheide NICHT selbst.

ES GEHT UM: was jeder der vier Traeger (Planer, CEB, Tier-Binary, Hybrid) fuer sich
tatsaechlich BRAUCHT, wenn er seine eigene Bau-Strecke bekommt.

SAMMLE JE TRAEGER:
 1. Welche Schritte braucht er heute? (configure, build, test, lint, package, mess, release?)
 2. Welche Abhaengigkeiten hat er? (Werkzeuge, Codegen, Registries -- es gibt eine
    Pflicht-Reihenfolge J-1..J-4: Werkzeuge zuerst, dann RE-CONFIGURE, dann Vollbau)
 3. Was ist bei ihm ANDERS als bei den anderen drei? (z.B. der Hybrid kann nicht bauen,
    nur messen; die CEB baut Tier UND Hybrid; der Planer emittiert die naechste Stufe)
 4. Braucht er eigene MESS-Schritte? Eigene RELEASE-Schritte? Eigenen CACHE?
 5. Was sagen Ledger und Plaene heute schon dazu? Zitiere die Stellen.

Ziel: eine Tabelle "Traeger x Beduerfnis", aus der der Owner ablesen kann, welche Schritte
gemeinsam sind und welche wirklich traegerspezifisch.`,
  },
  {
    key: 'F-c4-wache',
    titel: 'Frage 12 Kontext -- C-4 Heuristik-Wache erweitern oder zweite bauen',
    owner: `Owner 11.08.2026 auf meine Frage "die Heuristik-Wache um axes/ erweitern oder eine zweite daneben?": "Ich brauche mehr Kontext." -- und frueher: "C-4 ist eine ueble Bilanz weil wir das trennen und verdrahten muessen."`,
    auftrag: `Der Owner braucht Kontext. LIEFERE IHN -- entscheide NICHT selbst.

ES GEHT UM: eine bestehende Wache (Test/Guard/CI-Pruefung), die heute Heuristik-Interfaces
prueft, und die Frage, ob sie um den axes/-Bereich ERWEITERT wird oder ob eine ZWEITE
Wache danebengestellt wird.

SAMMLE:
 1. WELCHE Wache ist das genau? Finde sie: Datei, Testname, was sie prueft, seit wann.
 2. Was ist ihr heutiger GEGENSTAND (welche Verzeichnisse/Dateien/Symbole)?
 3. Was ist der axes/-Bereich, um den es geht? Wie gross (Dateien, Header, Achsen)?
 4. Was hat der Explore als "C-4" gemessen? Finde die C-4-Bilanz im Ledger/in den
    Synthesen und gib sie mit Zahlen wieder.
 5. Was heisst "trennen UND verdrahten" konkret -- welche zwei Dinge sind heute vermengt?
 6. Was spricht praktisch fuer Erweiterung (eine Wache, ein Ort) und was fuer eine zweite
    (verschiedene Gegenstaende, verschiedene Fehlermeldungen)? Nenne die Konsequenzen,
    nicht deine Empfehlung.`,
  },
  {
    key: 'G-stufe-phase',
    titel: 'Frage 14 -- STUFE und PHASE sind Synonyme und muessen umbenannt werden',
    owner: `Owner 11.08.2026: "Ja genau ein Synonym, aber muss jetzt konsistent wegen Kollision umbeannt werden."`,
    auftrag: `Bestaetigt: "Stufe" (Vokabel vom 06.08.) und "phasig/Phase" (seit KON7) meinen DASSELBE.
Der Owner ordnet an: wegen der KOLLISION muss jetzt konsistent umbenannt werden.

FINDE DIE GRUNDLAGE FUER DIE UMBENENNUNG:
 1. WAS ist die Kollision? Es gibt ein Klaerungsdokument, das vor einer Kollision des
    Begriffs "Stufe" warnt -- finde es und gib die Kollision woertlich wieder.
    (Vermutung: "Stufe" kollidiert mit den CI-Stufen / GitLab stages / den Bau-Stufen.)
 2. Wie viele Stellen verwenden "Stufe"/"stufig"/"Stufen-" im Sinne von Phasigkeit?
    Zaehle getrennt: ce-Code, super-Doku, Ledger, Plaene, CI-YAML.
 3. Wie viele verwenden "Phase"/"phasig"? Gleiche Aufteilung.
 4. Wo kollidiert "Stufe" tatsaechlich mit einer ANDEREN Bedeutung? (CI-stage,
    Bau-Stufe, Versionierungs-Stufe, Traeger-Stufe -- welche Bedeutungen konkurrieren?)
 5. Welche Begriffe stehen als Ersatz zur Verfuegung und welcher ist am wenigsten belegt?
 6. WELCHE STELLEN SIND HART? (Symbolnamen im Code, XSD-Elemente, CI-Job-Namen,
    Fingerprint-Felder -- eine Umbenennung dort ist ABI-/Preimage-wirksam!)

Das ist ein Umbenennungs-VORBEREITUNGS-Auftrag: liefere die vollstaendige Trefferliste
nach Klassen sortiert, nicht die Umbenennung selbst.`,
  },
  {
    key: 'H-bau-modul',
    titel: 'Frage 3/5 -- KEINE YAML: der Planer emittiert direkt, zentrales Bau-Modul im Builder Pattern',
    owner: `Owner 11.08.2026: "Es gibt keine YAML sondern der Planer emittiert direkt eine pipe oder Prozess, der den build auf einer binary faehrt. Jede Traeger Stufe emittiert die naechste direkt und unter verwendung eines zentralen Bau-Modules, welches wiederverwendbar im Builder Pattern den naechsten Traeger aufbaut." Und: "Der Hybrid wird durch die CEB gebaut und das Budget wird nicht ausgeschoepft weil die Tiefe nur 3 ist und Hybrid und Tier sequentiell auf derselben Stufe gebaut werden, erst Tier und spaeter Hybrid durch die CEB."`,
    auftrag: `Das raeumt meine CI-Fragen weg: es gibt KEIN Kind-YAML. Der Planer emittiert direkt eine
Pipe/einen Prozess. Jede Traeger-Stufe emittiert die naechste ueber ein ZENTRALES,
WIEDERVERWENDBARES BAU-MODUL im Builder Pattern.

BESTANDS-PFLICHT (Arbeitsweise v3.3/A2.2 -- nach dem GEGENSTAND suchen, nicht nach dem
Konsumenten). Der Selbstkompilations-Entwurf existiert seit dem 19.07. in
${SUPER}/docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md und
${SUPER}/docs/plaene/20260719-FINALES-DESIGN-ABSTRACT-kette-baum-registries.md

FINDE AM OBJEKT:
 1. GIBT ES DAS ZENTRALE BAU-MODUL SCHON? Suche nach dem Gegenstand: Builder-Klassen, die
    einen Traeger/eine Binary aufbauen. Bekannt sind CMakeGraphBuilder und CiYamlBuilder
    aus dem Entwurf, und ein ExperimentPlanDirector (2352 Z., gebaut UND verdrahtet).
    Was existiert davon am Objekt? Gib je Fund: Datei, Zeilen, Aufrufer.
 2. Wer emittiert heute einen Prozess/eine Pipe? Suche nach Prozess-Start (fork/exec/
    popen/system/std::process/subprocess) im ce -- gibt es das ueberhaupt?
 3. Der Owner sagt "der Planer emittiert direkt eine pipe oder Prozess, der den build auf
    einer binary faehrt". Existiert dieser Emissions-Pfad? Wo endet er heute?
 4. TIEFE 3: Planer -> CEB -> {Tier, dann Hybrid}. Bestaetigt der Code diese Tiefe?
    Wo ist die Sequenz "erst Tier, spaeter Hybrid" abgebildet?
 5. CiYamlBuilder: der Owner sagt es gibt keine YAML. Was macht der CiYamlBuilder dann,
    und ist er ein Widerspruch zum Owner-Wort oder etwas anderes?
    (Neueres Owner-Wort schlaegt aeltere Aussage -- aber der Gegenstand muss benannt sein.)`,
  },
  {
    key: 'I-drei-flaechen',
    titel: 'Frage 9 -- DREI Flaechen: Genus, Stempel, measurement-Durchstich',
    owner: `Owner 11.08.2026: "Das ist Teil der Systemachse und geht nur als Stempel mit in Flaeche 2 des Genus Interfaces (was ja nach dem Compile durch die CEB mit dem compiler ein Tier-Binary oder Hybrid ergibt). Also der Genus Wert in der CEB hat einen compiler und nach dem compile hat das Genus interface NUR den measurement Durchstich. Das kompilieren und bauen macht ja nur die CEB. Das Genus ist also Flaeche 1 einer Tier-Binary und Flaeche 2 ist der Stempel. measurement Durchstich ist im prinzip gleichzusetzen mit Flaeche 3, damit wir die Gattung+Genus Funktionsinterfaces nicht aendern muessen."`,
    auftrag: `NEUE ARCHITEKTUR-AUSSAGE: es gibt DREI Flaechen, nicht zwei.

  Flaeche 1 = das GENUS-Interface einer Tier-Binary (abstract factory, Laufzeit)
  Flaeche 2 = der STEMPEL (compile time factory, ABI-stabil) -- hier haengt auch
              Tools/Compiler dran, als Teil der SYSTEMACHSE
  Flaeche 3 = der MEASUREMENT-DURCHSTICH -- eingefuehrt, DAMIT die Gattung+Genus-
              Funktionsinterfaces NICHT geaendert werden muessen

Und: der Genus-Wert IN DER CEB hat einen Compiler. NACH dem Compile hat das Genus-Interface
NUR noch den measurement-Durchstich. Kompilieren und Bauen macht NUR die CEB.

FINDE AM OBJEKT:
 1. Sind Flaeche 1 und Flaeche 2 im Code als solche benannt? Wo? (Bekannt: das Konzept
    steht im Ledger KON9; existiert es auch im Code?)
 2. GIBT ES FLAECHE 3 SCHON? Suche nach dem measurement-Durchstich: Durchstich,
    durchstich, measurement pass-through, Mess-Durchstich, MeasureVisitor am
    Genus-Interface. Ist er gebaut, oder nur beschrieben?
 3. Der Compiler als Teil der SYSTEMACHSE: steht der Compiler heute in einer System-Achse?
    Wie wird er heute im Fingerprint/Stempel erfasst? (Bekannt: CEB-System-Zeile ist LEER.)
 4. Wo genau sitzt heute die Grenze "vor dem Compile" / "nach dem Compile"? Welche
    Datenstruktur traegt den Compiler vor dem Compile, welche danach?
 5. WIDERSPRUCH PRUEFEN: bisher stand im Ledger "ZWEI Flaechen je Binary". Wo steht das,
    und ist die Drei-Flaechen-Aussage eine Erweiterung oder eine Korrektur? Zitiere beide.`,
  },
]

phase('Explore')

const ergebnisse = await pipeline(
  STRAENGE,
  // Stufe 1: vier Quellen-Schnitte je Strang, parallel
  (s) => parallel([
    () => agent(`${GRUND}

## STRANG ${s.key}: ${s.titel}
### Quellenschnitt 1 von 4: ROH-TRANSKRIPTE (Owner-Worte)

${s.owner}

${s.auftrag}

DEIN SCHNITT: die 20 Roh-Transkripte unter ${ROH}/*.jsonl.
Das sind JSONL-Session-Logs. Owner-Worte stehen in Zeilen mit "type":"user".
Nutze python3/jq zum Extrahieren, dann grep auf dem Klartext.
ACHTUNG: Live-Tokens koennen in Transkripten stehen -- gib NIEMALS Token-artige
Zeichenketten aus (glpat-, ghp_, Bearer, PRIVATE-TOKEN). Zitiere nur Fachinhalt.
Suche sehr gruendlich, mit allen drei Falsch-Null-Absicherungen.`,
      { label: `${s.key}:roh`, phase: 'Explore', model: 'sonnet', effort: 'max', schema: SCHEMA }),

    () => agent(`${GRUND}

## STRANG ${s.key}: ${s.titel}
### Quellenschnitt 2 von 4: LEDGER + PLAENE

${s.owner}

${s.auftrag}

DEIN SCHNITT: ${SUPER}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (21801 Zeilen!)
und ${SUPER}/docs/plaene/ (alle Dateien).
Der Ledger ist gross -- arbeite mit grep -n und lies gezielt um die Treffer herum.
Nachtraege stehen OBEN (neueste zuerst): KON15, KON14, KON13, KON12, KON11, KON10, KON9...
NEUERES SCHLAEGT AELTERES. Wenn du einen Widerspruch findest, nenne BEIDE Fassungen
mit ihrem Datum.
Vergiss die Konsolidierung nicht: docs/plaene/20260810-KONSOLIDIERUNG-* (3939 Z.,
106 Memories mit Herkunft, Widersprueche W-01..W-20).`,
      { label: `${s.key}:ledger`, phase: 'Explore', model: 'sonnet', effort: 'max', schema: SCHEMA }),

    () => agent(`${GRUND}

## STRANG ${s.key}: ${s.titel}
### Quellenschnitt 3 von 4: DER CODE (ce + super)

${s.owner}

${s.auftrag}

DEIN SCHNITT: der Code.
  ce:    ${CE}          (Stand 670483c0)
  super: ${SUPER}       (Doku-Repo, aber mit ci/ und Code/)
Suche nach dem GEGENSTAND, nicht nach dem Konsumenten.
Nutze rg mit Dateityp-Filtern. Lies die Fundstellen wirklich -- ein Treffer in einem
Kommentar ist etwas anderes als eine Implementierung.
Gib bei jedem Fund an: existiert das nur als Deklaration, als Implementierung, oder ist
es auch VERDRAHTET (wird es gerufen)? Ein gebautes, ungerufenes Modul ist ein wichtiger
Befund -- melde es als solches, nicht als "fehlt".`,
      { label: `${s.key}:code`, phase: 'Explore', model: 'sonnet', effort: 'max', schema: SCHEMA }),

    () => agent(`${GRUND}

## STRANG ${s.key}: ${s.titel}
### Quellenschnitt 4 von 4: SESSIONS + PROJEKTE-DOKTRIN + BACKUPS

${s.owner}

${s.auftrag}

DEIN SCHNITT:
  ${SUPER}/docs/sessions/           (Session-Dokumente, rueckwaerts lesen: neueste zuerst)
  ${SUPER}/docs/sessions/backups/   (gesicherte Workflow-Rohdaten und Synthesen!)
  ${SUPER}/docs/termine/            (Owner-Dokumente: .docx, .pptx -- ggf. entpacken)
  ${PROJ}/                          (ARBEITSWEISE-GESAMT-DOKTRIN.md u.a.)
Die Backups enthalten die Synthesen frueherer Explores im Volltext -- dort steht oft
schon eine Antwort, die nie in den Ledger kam.
.docx/.pptx sind ZIP-Dateien: entpacke sie und durchsuche word/document.xml bzw.
ppt/slides/*.xml. Der Text ist dort in XML-Tags zerlegt -- suche nach Wortteilen,
nicht nach ganzen Phrasen!`,
      { label: `${s.key}:sessions`, phase: 'Explore', model: 'sonnet', effort: 'max', schema: SCHEMA }),
  ]),

  // Stufe 2: Gegenprobe -- ein Skeptiker prueft die Befunde des Strangs am Objekt nach
  (funde, s) => {
    const gut = (funde || []).filter(Boolean)
    if (!gut.length) return { strang: s.key, titel: s.titel, funde: [], pruefung: null }
    return agent(`${GRUND}

## GEGENPROBE fuer STRANG ${s.key}: ${s.titel}

${s.owner}

Vier Agenten haben diesen Strang aus vier Quellen bearbeitet. Hier sind ihre Ergebnisse:

${JSON.stringify(gut, null, 1)}

DEIN AUFTRAG -- pruefe SKEPTISCH am Objekt nach:
 1. Stimmt jeder BELEG? Oeffne die genannten Dateien/Zeilen und pruefe, ob dort wirklich
    steht, was behauptet wird. Melde jede Abweichung.
 2. Widersprechen sich die vier Schnitte? Wo ja: welche Fassung ist NEUER, welche ist
    naeher am Objekt? Neueres schlaegt Aelteres, Owner-Wort schlaegt alles.
 3. Ist eine gemeldete NULL echt? Pruefe die Gegenproben. Wenn ein Agent "nicht gefunden"
    sagt ohne beissende Gegenprobe, wiederhole die Suche SELBST mit anderen Begriffen
    (Encoding-Varianten, Case, Wortteile wegen Zeilenumbruch bei ~95 Zeichen).
 4. Was ist die BESTE gemeinsame Antwort auf die Owner-Frage? Formuliere sie praezise.
 5. Was bleibt trotz vier Schnitten OFFEN? Sei hier ehrlich -- eine benannte Luecke ist
    wertvoller als eine geratene Antwort.

Wichtig: Praezisierung ist NICHT Widerlegung. Wenn ein Befund im Kern stimmt und nur
eine Zahl danebenliegt, sage das genau so.`,
      {
        label: `verify:${s.key}`, phase: 'Gegenprobe', model: 'sonnet', effort: 'max',
        schema: {
          type: 'object',
          additionalProperties: false,
          required: ['strang', 'antwort', 'sicherheit', 'belege', 'offen'],
          properties: {
            strang: { type: 'string' },
            antwort: { type: 'string', description: 'Die gepruefte Gesamtantwort auf die Owner-Frage dieses Strangs' },
            sicherheit: { type: 'string', enum: ['belegt', 'wahrscheinlich', 'nicht gefunden'] },
            belege: { type: 'array', items: { type: 'string', description: 'Datei:Zeile -- Inhalt' } },
            korrekturen: { type: 'array', items: { type: 'string', description: 'Was ein Schnitt falsch gemeldet hat, und was stattdessen gilt' } },
            widersprueche: { type: 'array', items: { type: 'string' } },
            offen: { type: 'string' },
            fuer_den_owner: { type: 'string', description: 'Falls dieser Strang eine Entscheidungsgrundlage liefern sollte: die Grundlage, kompakt und OHNE eigene Empfehlung' },
          },
        },
      }).then(v => ({ strang: s.key, titel: s.titel, owner: s.owner, funde: gut, pruefung: v }))
  },
)

phase('Synthese')

const synthese = await agent(`Du bist die SYNTHESE eines neun-straengigen Explores.

# ANLASS

Der Owner (TU-Dresden-Diplomarbeit "Cache-Engine-Experiment-System", Abgabe 15.09.2026,
naechste Lieferung Fr 14.08.) hat auf vierzehn offene Fragen geantwortet. Drei Antworten
waren Explore-Auftraege ("bitte explore"), drei waren Bitten um mehr Kontext, und drei
enthielten NEUE Architektur-Aussagen, die am Objekt geprueft werden mussten.

Dieser Lauf hat alle neun bearbeitet: je vier Quellenschnitte (Roh-Transkripte, Ledger+
Plaene, Code, Sessions+Backups) und eine skeptische Gegenprobe.

# DIE ERGEBNISSE

${JSON.stringify(ergebnisse.filter(Boolean), null, 1)}

# DEIN AUFTRAG

Schreibe die Auswertung als Markdown-Dokument. Es geht direkt an den Owner und wird
Grundlage fuer den naechsten Bau-Abschnitt. Struktur:

## 1. DIE DREI EXPLORE-AUFTRAEGE -- beantwortet oder nicht
Fuer A (Flag-Syntax, c=CPU), B (freigebende vs. compile-time-Seite), C (Export-Ziele):
die Antwort, mit Belegen. Wenn nicht gefunden: sage das klar und sage, was stattdessen
gefunden wurde und wo weiter zu suchen waere.

## 2. DIE DREI KONTEXT-BITTEN -- die Entscheidungsgrundlage
Fuer D (Typ vs. Instanz), E (eigene Beduerfnisse), F (C-4-Wache): stelle dem Owner die
Grundlage zusammen, aus der er entscheiden kann. TABELLEN, ZAHLEN, KONSEQUENZEN.
KEINE Empfehlung -- der Owner entscheidet. Wenn eine Zahl fehlt, sage welche.

## 3. DIE DREI NEUEN ARCHITEKTUR-AUSSAGEN -- was der Code dazu sagt
Fuer G (Stufe/Phase-Umbenennung), H (kein YAML, zentrales Bau-Modul, Tiefe 3),
I (drei Flaechen statt zwei): stimmt die Aussage mit dem Bestand ueberein? Was existiert
schon, was fehlt, was widerspricht? Bei Widerspruch: BEIDE Fassungen mit Datum, und die
Regel "Owner-Wort schlaegt alles, Neueres schlaegt Aelteres" anwenden.

## 4. WAS DARAUS ZU BAUEN IST
Eine geordnete Liste von Bau-Posten, die sich aus den Antworten ergeben. Je Posten:
Gegenstand, Ort (Repo+Pfad), Abhaengigkeit, und ob er heute schon teilweise existiert.

## 5. WAS DIESER LAUF NICHT KLAEREN KONNTE
Ehrlich und vollstaendig. Nenne je Punkt, WARUM nicht (nicht gefunden / widersprüchlich /
braucht Owner-Entscheidung) und was der naechste Schritt waere.

## 6. NEUE FRAGEN AN DEN OWNER
Nur was ein gefahrener Explore nicht aufloesen konnte. Formuliere jede Frage so, dass sie
mit einem Satz beantwortbar ist, und nenne dazu, was von der Antwort abhaengt.

REGELN:
- Jede Zahl mit Beleg. Zahlen ohne Beleg kennzeichnest du als unbelegt.
- Kein Erfolgs-Haken ohne woertliche Ausgabe.
- Wenn die Gegenprobe einen Schnitt korrigiert hat, steht die KORRIGIERTE Fassung im Text
  und die Korrektur in einer Fussnote -- nicht umgekehrt.
- Schreibe auf Deutsch, mit vollstaendigen Umlauten.
- ASCII-Sonderzeichen in Codebloecken, aber normale Umlaute im Fliesstext.`,
  { label: 'synthese', phase: 'Synthese', model: 'fable', effort: 'max' })

return { synthese, straenge: ergebnisse.filter(Boolean).length }
