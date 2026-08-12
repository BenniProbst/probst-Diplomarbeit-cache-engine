export const meta = {
  name: 'zwei-welten-und-leere-klassen',
  description: 'Zwei Owner-Auftraege aus KON15: Glieder-Reihenfolge Lager vs. ausserhalb (blockiert S-6) + Register der leeren Klassen',
  phases: [
    { title: 'Explore' },
    { title: 'Gegenprobe' },
    { title: 'Synthese' },
  ],
}

const SUPER = '/home/comdare/wt-super-landung'
const CE    = '/home/comdare/wt-super-landung/Code/external/comdare-cache-engine'

const GRUND = `
ARBEITSREGELN (bindend):
- Nach dem GEGENSTAND suchen, nicht nach dem Konsumenten (Arbeitsweise v3.3/A2.2).
- Jede Zahl mit Beleg Datei:Zeile. Jeder Nichtfund mit beissender Gegenprobe.
- Falsch-Null-Klassen: Encoding (ae/oe/ue vs Umlaut) · Case · Zeilenumbruch bei ~95 Zeichen.
- Schraegstrich-Falle: '/build' frisst '/builder/' -- immer '/build/' mit beiden Schraegstrichen.
- grep ist in Agenten-Bash eine Funktion auf ugrep: fuer exakte Zaehlungen /usr/bin/grep absolut,
  und -P kann STUMM brechen -- Gegenprobe fahren.
- STRIKT READ-ONLY: du baust und aenderst NICHTS. Du erhebst.

ORTE:
  ce (C++-Code):   ${CE}     Stand 670483c0
  super (Doku):    ${SUPER}  Stand 2ae55a9c
  Ledger:          ${SUPER}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (21999 Zeilen, Nachtraege OBEN: KON16 zuerst)
  Wellenplan:      ${SUPER}/docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md (1921 Z., §13/§14 = Traeger-Baukette S-1..S-18)
`

const SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['antwort', 'belege', 'sicherheit', 'gegenprobe'],
  properties: {
    antwort: { type: 'string' },
    belege: { type: 'array', items: { type: 'object', additionalProperties: false, required: ['ort', 'inhalt'], properties: { ort: { type: 'string' }, inhalt: { type: 'string' } } } },
    sicherheit: { type: 'string', enum: ['belegt', 'wahrscheinlich', 'nicht gefunden'] },
    gegenprobe: { type: 'string' },
    offen: { type: 'string' },
  },
}

// GEDAECHTNIS-BEFUNDE des Leads (V2.1a: der Agent prueft sie am Objekt GEGEN, er ermittelt sie nicht neu):
const BEFUND_J = `
GEDAECHTNIS-BEFUND DES LEADS (am Objekt GEGENZUPRUEFEN, nicht neu zu ermitteln):
1. Owner-Wort 11.08. (Ledger KON15-02): "Das kommt immer noch darauf an, ob im Lager oder
   ausserhalb des Lagers verwendet, das sind zwei Welten fuer die Reihenfolge der Glieder (explore)."
2. D-12 (Ledger): das Lager traegt ZWEI Kaskaden -- Messdaten MESS->SYSTEM->ORGAN,
   Binaries SYSTEM->ORGAN->MESS. Beide halten System-vor-Organ.
3. KON7: "nur das Lager hat hier eine Ausnahme fuer die Uebermittlung von Funktionsvariablen."
4. Objekt-Fundstellen (Stand 670483c0, VERIFIZIEREN):
   - ${CE}/libs/cache_engine/include/cache_engine/abi/anatomy_fingerprint.hpp
     traegt anatomy_fingerprint_glieder(organ, system, measurement, ...) und die POD-Feldfolge
     organ_line -> system_line -> measurement_line
   - ${CE}/libs/cache_engine/builder/bestandslog/lager_baum_writer.hpp:50-53 woertlich:
     "BLATT-IDENTITAET = v6-FINGERPRINT (F7-Konvergenz): Skip-Marke, minio-Key,
     Bestandslog-key_sha512 und Baum-Blatt sind DASSELBE Preimage."
5. Die Stufen-Ordnung ausserhalb (KON13): MESS -> SYSTEM -> ORGAN (Mess-Kette),
   Stempel-Reihenfolge SOLL System vorn, Organ hinten (Freigabe vor Durchsetzung).
6. KON16-06 (Randkontext): drei Flaechen -- 1 Genus, 2 Stempel, 3 measurement-Durchstich.
🔴 An S-6 wird NICHTS gebaut, bis dieser Explore die Grenze benannt hat -- das Glied ist
preimage-wirksam, ein Bruch saehe aus wie ein Cache-Treffer (schneller UND falsch).`

const BEFUND_K = `
GEDAECHTNIS-BEFUND DES LEADS (am Objekt GEGENZUPRUEFEN):
1. Owner-Wort 11.08. (Ledger KON15-01): "Dann muessen wir noch leere Klassen notieren und
   spaeter implementieren, sofern sie in den Wellen noch bearbeitet werden sollten."
2. Die Inventur vom 11.08. hat AUFRUFER geprueft (Kategorie "0 Aufrufer ueberhaupt" = leer)
   -- sie hat NICHT geprueft, ob eine Klasse INHALTLICH leer ist. Eine Klasse kann Aufrufer
   haben und trotzdem ein Rumpf sein.
3. Bekannte Bestandslage (KON11/KON14): elf Positionen geprueft, neun gebaut-und-unverdrahtet;
   DREI CoR-Implementierungen (eine verdrahtet); ZWEI Command-Fassungen (i_command.hpp GEPARKT
   seit 06.07., AxisCommand concept in ${CE}/topics/axis_command_base.hpp:20).
4. Wellenplan §13/§14 (${SUPER}/docs/plaene/20260808-WELLENPLAN-*.md) traegt die Traeger-Baukette
   S-1..S-18 und die Wellen-Zuordnung -- das ist die Abgleichquelle fuer "fasst eine Welle sie an?".`

const STRAENGE = [
  {
    key: 'J-zwei-welten',
    titel: 'KON15-02 -- die ZWEI WELTEN der Glieder-Reihenfolge (blockiert S-6)',
    befund: BEFUND_J,
    auftrag: `KERNFRAGEN, alle drei zu beantworten:
 1. Welche Glieder-Reihenfolge gilt IM LAGER? (Preimage-Bildung, minio-Key, key_sha512,
    Baum-Blatt, Bestandslog, Kaskaden-Pfade)
 2. Welche gilt AUSSERHALB des Lagers? (Fingerprint-API, Stempel, CLI-Argumente,
    Funktions-Signaturen, PODs, XML/XSD)
 3. WO VERLAEUFT DIE GRENZE IM CODE? Welche Datei/Funktion konvertiert zwischen den Welten,
    oder gibt es gar keine Konversion (und damit einen verdeckten Bruch)?
DAZU: kartiere ALLE Fundstellen der Glieder-Reihenfolge (Signaturen, POD-Feldfolgen,
Aufruf-Argument-Folgen, Schluessel-Konkatenationen) und ordne JEDE einer Welt zu:
LAGER / AUSSERHALB / UNKLAR. Die UNKLAR-Liste ist genauso wichtig wie die zugeordneten.`,
  },
  {
    key: 'K-leere-klassen',
    titel: 'KON15-01 -- das Register der leeren Klassen',
    befund: BEFUND_K,
    auftrag: `FINDE die Klassen/Strukturen, die nur HUELLE sind. Huelle heisst:
 - leerer Rumpf ({} ohne Member/Methoden ausser Konstruktoren)
 - reine TODO-/Platzhalter-Koerper (TODO, FIXME, not implemented, stub, placeholder)
 - Methoden, die nur werfen/abbrechen/leer zurueckgeben, wo Logik angekuendigt ist
 - deklariert-aber-nie-definiert (Header ohne Implementierung, wo eine angekuendigt ist)
AUSNAHMEN (KEINE Huellen): Tag-Typen, Traits, Konzepte, CRTP-Basen, leere Interfaces mit
Absicht (z.B. Marker), generierter Code -- kennzeichne solche Faelle als "leer mit Absicht"
statt sie zu verschweigen.
JE FUND: Datei:Zeile, Symbolname, Huellen-Art, hat sie Aufrufer (ja/nein/nur Tests),
und -- gegen den Wellenplan §13/§14 gehalten -- fasst eine WELLE oder ein Bau-Teil S-1..S-18
sie noch an? (ja: welche/r -- nein: "benannte Grenze")`,
  },
]

phase('Explore')

const ergebnisse = await pipeline(
  STRAENGE,
  (s) => parallel([
    () => agent(`${GRUND}
## STRANG ${s.key}: ${s.titel}
### Schnitt 1 von 3: ce-CODE (Header + Implementierungen)
${s.befund}

${s.auftrag}

DEIN SCHNITT: ${CE} -- libs/, apps/, tools/, topics/, benchmarks/. Lies die Fundstellen
WIRKLICH (Deklaration vs. Implementierung vs. Kommentar vs. verdrahtet unterscheiden).`,
      { label: `${s.key}:ce`, phase: 'Explore', model: 'sonnet', effort: 'max', schema: SCHEMA }),

    () => agent(`${GRUND}
## STRANG ${s.key}: ${s.titel}
### Schnitt 2 von 3: TESTS + CI + XML/XSD + super-Seite
${s.befund}

${s.auftrag}

DEIN SCHNITT: Tests (${CE}/tests, ctest-Registrierungen), CI-Dateien beider Repos,
XML/XSD-Schemata, und die super-Seite (${SUPER}/ci, ${SUPER}/Code). Tests verraten oft die
GEMEINTE Ordnung (Erwartungswerte!), und die XSD traegt die Aussen-Sicht.`,
      { label: `${s.key}:tests`, phase: 'Explore', model: 'sonnet', effort: 'max', schema: SCHEMA }),

    () => agent(`${GRUND}
## STRANG ${s.key}: ${s.titel}
### Schnitt 3 von 3: LEDGER + PLAENE + SESSIONS
${s.befund}

${s.auftrag}

DEIN SCHNITT: der Ledger (21999 Z., grep -n + gezielt lesen; KON-Nachtraege OBEN, neueste
zuerst, NEUERES SCHLAEGT AELTERES), docs/plaene/ (besonders Wellenplan §13/§14 und die
KONSOLIDIERUNG 20260810-*), docs/sessions/ inkl. backups/ (dort liegen fruehere Synthesen im
Volltext). Suche, was zur Frage FESTGELEGT wurde -- und wo Festlegungen einander widersprechen
(beide Fassungen mit Datum nennen).`,
      { label: `${s.key}:doku`, phase: 'Explore', model: 'sonnet', effort: 'max', schema: SCHEMA }),
  ]),

  (funde, s) => {
    const gut = (funde || []).filter(Boolean)
    if (!gut.length) return { strang: s.key, titel: s.titel, funde: [], pruefung: null }
    return agent(`${GRUND}
## GEGENPROBE fuer STRANG ${s.key}: ${s.titel}
${s.befund}

Drei Agenten haben aus drei Quellen erhoben:
${JSON.stringify(gut, null, 1)}

PRUEFE SKEPTISCH AM OBJEKT:
 1. Jeden Beleg oeffnen und nachlesen -- Abweichungen melden.
 2. Nullen nur mit beissender Gegenprobe akzeptieren; sonst SELBST nachsuchen
    (Encoding-Varianten, Case, Wortteile).
 3. Widersprueche zwischen den Schnitten: welche Fassung ist naeher am Objekt / neuer?
 4. Die beste Gesamtantwort formulieren. Praezisierung ist KEINE Widerlegung.
 5. Was bleibt offen -- ehrlich.`,
      {
        label: `verify:${s.key}`, phase: 'Gegenprobe', model: 'sonnet', effort: 'max',
        schema: {
          type: 'object', additionalProperties: false,
          required: ['strang', 'antwort', 'sicherheit', 'belege', 'offen'],
          properties: {
            strang: { type: 'string' }, antwort: { type: 'string' },
            sicherheit: { type: 'string', enum: ['belegt', 'wahrscheinlich', 'nicht gefunden'] },
            belege: { type: 'array', items: { type: 'string' } },
            korrekturen: { type: 'array', items: { type: 'string' } },
            offen: { type: 'string' },
          },
        },
      }).then(v => ({ strang: s.key, titel: s.titel, funde: gut, pruefung: v }))
  },
)

phase('Synthese')

const synthese = await agent(`Du bist die SYNTHESE eines zwei-straengigen Explores
(TU-Dresden-Diplomarbeit Cache-Engine-Experiment-System, Abgabe 15.09.2026, F1 am Fr 14.08.).

Zwei Owner-Auftraege aus Ledger KON15:
  J (KON15-02): die ZWEI WELTEN der Glieder-Reihenfolge -- Lager vs. ausserhalb.
     Blockiert Bau-Teil S-6. Das Glied ist preimage-wirksam.
  K (KON15-01): das Register der leeren Klassen -- welche sind Huelle, und fasst eine
     Welle sie noch an?

ERGEBNISSE (je Strang drei Quellen-Schnitte + skeptische Gegenprobe):
${JSON.stringify(ergebnisse.filter(Boolean), null, 1)}

SCHREIBE die Auswertung als Markdown, direkt fuer den Owner und den Ledger:

## 1. DIE ZWEI WELTEN (J)
Die Antwort auf die drei Kernfragen (Reihenfolge im Lager / ausserhalb / Grenze im Code),
mit Belegen. Dann die VOLLSTAENDIGE Fundstellen-Karte als Tabelle: Ort | Reihenfolge | Welt
(LAGER/AUSSERHALB/UNKLAR). Dann: was folgt fuer S-6 -- ist die heutige POD-Folge in ihrer
Welt RICHTIG, und wo genau waere ein Eingriff noetig/verboten? KEINE Bau-Empfehlung ohne
Owner -- benenne, was entscheidbar ist und was nicht.

## 2. DAS REGISTER DER LEEREN KLASSEN (K)
Die Tabelle: Symbol | Ort | Huellen-Art | Aufrufer | Welle/S-Teil oder "benannte Grenze".
Getrennt davon die "leer mit Absicht"-Liste. Zahlen mit Nenner (N Klassen geprueft, davon...).

## 3. WAS OFFEN BLEIBT
Ehrlich, je Punkt: warum, und was der naechste Schritt waere.

REGELN: jede Zahl mit Beleg · Praezisierung ist keine Widerlegung · Deutsch mit korrekten
Umlauten im Fliesstext, ASCII in Codebloecken.`,
  { label: 'synthese', phase: 'Synthese', model: 'fable', effort: 'max' })

return { synthese, straenge: ergebnisse.filter(Boolean).length }
