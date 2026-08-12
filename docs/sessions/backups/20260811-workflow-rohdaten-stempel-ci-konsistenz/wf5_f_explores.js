export const meta = {
  name: 'kon25-f-explores',
  description: 'Die Explore-Auftraege aus KON25: measure-drop-Entscheid (E-F5), Stufe/Phase-Trennung (E-F7), Multi-Runner-gegen-Lager (E-F9), 32-vs-6-Abgleich (E-F3b)',
  phases: [
    { title: 'Explore' },
    { title: 'Gegenprobe' },
    { title: 'Synthese' },
  ],
}

const SUPER = '/home/comdare/wt-super-landung'
const CE    = '/home/comdare/wt-super-landung/Code/external/comdare-cache-engine'
const ROH   = '/home/comdare/.claude/projects/-home-comdare'

const GRUND = `
ARBEITSREGELN (bindend):
- Nach dem GEGENSTAND suchen, nicht nach dem Konsumenten (v3.3/A2.2).
- Jede Aussage mit Beleg Datei:Zeile bzw. Transkript-Zeile. Nichtfund NUR mit beissender Gegenprobe.
- Falsch-Null-Klassen: Encoding (ae/oe/ue vs Umlaut) · Case · Zeilenumbruch ~95 Zeichen.
- '/build' frisst '/builder/'. /usr/bin/grep fuer exakte Zaehlungen.
- Roh-Transkripte (JSONL, bis 300 MB): NIE am Stueck -- jq -c / grep -n / sed -n.
  Owner-Pfade als UNION: type==user+promptSource/origin.kind UND attachment.queued_command
  UND queue-operation+enqueue. NIEMALS Token-artige Strings ausgeben.
- STRIKT READ-ONLY.

ORTE:
  ce:     ${CE}  · super: ${SUPER}
  Ledger: ${SUPER}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (23117 Z., KON25 oben)
  Plaene: ${SUPER}/docs/plaene/  · Sessions: ${SUPER}/docs/sessions/ (+backups/)
  Transkript AKTUELLE Session: ${ROH}/5a19728e-f6e1-4736-a246-e3fda9ac35a1.jsonl (224+ MB)
    Kontext-Grenzen (isCompactSummary-Zeilen): K-1 beginnt 41971, K-0 beginnt 43299.
    "Letzter Kontext" = Zeilen 41971-43298.
  Transkript ALT-Linie: ${ROH}/46375cdc-*.jsonl (314 MB, bis 06.08.)
`

const SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['antwort', 'belege', 'sicherheit', 'gegenprobe'],
  properties: {
    antwort: { type: 'string' },
    belege: { type: 'array', items: { type: 'object', additionalProperties: false, required: ['ort', 'inhalt'], properties: { ort: { type: 'string' }, inhalt: { type: 'string' } } } },
    sicherheit: { type: 'string', enum: ['belegt', 'wahrscheinlich', 'nicht gefunden'] },
    gegenprobe: { type: 'string' },
    offen: { type: 'string' },
  },
}

const STRAENGE = [
  {
    key: 'EF5-measuredrop',
    titel: 'E-F5: der measure-drop-Ziel-Entscheid im Session-Log des letzten Kontexts',
    auftrag: `OWNER 12.08. (KON25-05): "Das ist schon entschieden im session log des letzen Kontext - explore."

DIE FRAGE WAR (F5): bedient der measure-drop-HTTPS-PUT-Kanal (Ebene C, artifact_cache.hpp)
Ziel (2) Buildsystem-Cache (alle Messungen) oder Ziel (3) cache-engine-experiment (nur finale
Zusammenfassung+LaTeX+PDF+angeforderte Einzelnachweise)? Und darf er bis zum S-13-Bau weiter
jede per-Binary-CSV senden?

FINDE DEN ENTSCHEID:
 1. PRIMAER: das Roh-Transkript des LETZTEN Kontexts (Zeilen 41971-43298) -- alle drei
    Owner-Pfade. Suchbegriffe: measure-drop, measure_drop, Ebene C, artifact_cache,
    cache-engine-experiment, Cluster_NFS, HTTPS, PUT, drop, NFS-Route, Filterpod,
    Einzelnachweis, Zusammenfassung. Auch WORTTEILE (Umbruch!).
 2. SEKUNDAER: K-2/K-3 (Zeilen 38112-41970), falls der Entscheid frueher fiel und im
    letzten Kontext nur referenziert wurde.
 3. Dazu die Objektlage: der Verortungs-Brief vom 18.07. (docs/sessions/ oder plaene/)
    jailt die Ebene-C-NFS-Route auf 'cache-engine-experiment/'; artifact_cache.hpp und
    lager_ziel_strategie.hpp tragen die Code-Seite. KON13-04 traegt die Drei-Orte-Regel.
 4. LIEFERE: den Entscheid WOERTLICH mit Zeile, und ob er Ziel 2 oder Ziel 3 bedeutet --
    plus ob der ungefilterte per-Binary-CSV-Versand gedeckt oder verboten ist.`,
  },
  {
    key: 'EF7-stufe-phase',
    titel: 'E-F7: die GEPLANTE Trennung Stufe (Binary, physisch) vs. Phase (CacheEngine-Modi, Konzeption)',
    auftrag: `OWNER 12.08. (KON25-07): "die Traeger-Stufe ist die Binary und damit ein physisches
Objekt und die Phase ist ein ganz anderes Konzept der CacheEngine Modi, welche ueber diese
Traeger-Stufen ausgefuehrt werden - das ist schon geplant bitte explore. Du hast das nicht
sauber getrennt. Die Phase sind Konzeption, die Stufen Binaries physisch."

FINDE DEN PLAN DIESER TRENNUNG:
 1. Wo ist "Phase = CacheEngine-MODI" geplant/definiert? Suche: Phasen-Modi, CacheEngine-Modi,
    Modi, mode, RunMethodology, Mess-Modi, Phase+Modus, drive_phase, dispatch_phase,
    PhaseStrategyFor, MergeStrategy, ExperimentPhaseProjection, phases im XSD.
    Quellen: das 06.08.-Klaerungsdokument STUFE-vs-PHASE (docs/, finde es!), Ledger
    (KON-Eintraege + aeltere §), Plaene (19.07.-BAUPLAN, ABSTRACT D-Saetze), Code.
 2. Kartiere die HEUTIGEN Verwendungen von "Phase" im Code: welche meinen die MODI
    (Konzeption: Mess-Phasen, Merge-Phasen, drive_phase) und welche meinen faelschlich
    die BINARY/Traeger-Stufe? Je Klasse 3-5 Belegstellen, keine Vollzaehlung noetig --
    die Haerteklassen-Karte aus WF1-G existiert schon (XSD-Enum Stufe1..3 unter Element
    'phase' = die Kollision).
 3. Was sagt das 06.08.-Klaerungsdokument WOERTLICH? (Es unterschied STUFE = achsen-
    relative Gliederzahl vs. PHASE = Kettenposition -- wie verhaelt sich das zur heutigen
    Owner-Definition Stufe=Binary/Phase=Modi?)
 4. LIEFERE: den gefundenen Plan mit Belegen + die Umbenennungs-Landkarte (was wird zu
    "Phase", was zu "Traeger-Stufe", was ist schon richtig).`,
  },
  {
    key: 'EF9-multirunner',
    titel: 'E-F9: der Plan "multiple gleichgestellte CI-Runner + unterschiedliche Nodes gegen das Lager"',
    auftrag: `OWNER 12.08. (KON25-09): "Ja klar bleibt er [prod2], das ist auch geplant wie das
gegen das Lager gefahren wird mit multiplen gleichgestellten CI runnern und unterschiedlichen
nodes im System - explore."

FINDE DEN PLAN:
 1. Wie fahren MEHRERE gleichgestellte Runner GEGEN DAS LAGER? Suche: Runner, concurrent,
    prod1, prod2, node, Nodes, Lager+Runner, minio+Runner, Buildsystem-NAS, Lease, Lock,
    Batch-Reservierung, PromiseGuard, Takeover, Job-Pool, "O(Maschinen)".
    Quellen: Ledger (§62-B "Job-Anzahl O(Maschinen) nie O(Binaries)", OD-7, KON3-02),
    Plaene (TWO-CACHE-STORAGE-Bauplan 18.07., Verortungs-Brief), Sessions, Transkripte.
 2. Die KONKURRENZ-Mechanik: wie verhindern zwei Runner, dieselbe Binary/Messung doppelt
    zu bauen? (Stempel als Cache-Schluessel · Bestandslog · Skip-Marke · Batch-Reservierung
    "freigeben und neu greifen" · ETA+50% Takeover -- was davon ist GEPLANT, was GEBAUT?)
 3. Die Node-Dimension: "unterschiedliche nodes im System" -- Host-Klassen (avx512f/avx2/
    basis), PMC je Mikroarchitektur (AMD/Intel getrennt), prod1/prod2-Lanes. Wie ordnet
    der Plan Binaries/Messungen den Nodes zu?
 4. LIEFERE: den Plan mit Belegen + was fuer S-13/S-17 und die Kapazitaetsrechnung
    (zweilanig, 20,7h-Pfad) daraus folgt.`,
  },
  {
    key: 'EF3b-32-vs-6',
    titel: 'E-F3b: das Verhaeltnis der 32 Mess-System-Permutationen zu den "6 CEB-Builds (3!)"',
    auftrag: `OWNER-ENDFASSUNG 12.08. (KON25-03, nach Selbstkorrektur): 32 Mess-System-
Permutationen = Tier(Micro x Macro = 4) x Hybrid(Micro x Macro = 4) x CEB(Wall-Clock an/aus = 2).
AELTERE AUSSAGE (Z. 35912, K-5b): "Es gibt 6 builds an CEBs wegen der 3 fakultaet Mess-Layer
Regelung von Wallclock/Macro/Micro fuer checkpoint_measure."

KLAERE DAS VERHAELTNIS AM BESTAND:
 1. Was ist die 3!-Regelung KONKRET? Suche im Code: checkpoint_measure, Wallclock, wall_clock,
    Macro, Micro, Mess-Layer, measurement layer, MessEbene, E1-E4, steuer_dock
    (static_assert anzahl==6!), CebPermutationen. Ist die 6 eine ANORDNUNGS-Permutation
    (Reihenfolge der Layer) oder eine AUSWAHL?
 2. Die neue 32: An/Aus-BELEGUNGEN je Traeger. Vertragen sich beide (6 Anordnungen x
    Belegungen) oder ERSETZT die 32 die 6? Was sagt steuer_dock.hpp:234
    (ZuDocks<CebPermutationen>::anzahl == 6) heute konkret aus -- was permutiert dort?
 3. Suche die Owner-Historie: 3!-Aussagen (Z. 35912 + aeltere), die 12er-Korrektur
    (10.08. 07:27), die heutige 32 -- baue die Fassungskette mit Zeitstempeln.
 4. LIEFERE: die praeziseste widerspruchsfreie Lesart MIT Belegen -- oder den benannten
    Rest-Widerspruch als Owner-Frage. KEINE eigene Festlegung.`,
  },
]

phase('Explore')

const ergebnisse = await pipeline(
  STRAENGE,
  (s) => parallel([
    () => agent(`${GRUND}
## STRANG ${s.key}: ${s.titel}
### Schnitt 1 von 2: DOKU + TRANSKRIPTE
${s.auftrag}

DEIN SCHWERPUNKT: Ledger, Plaene, Sessions (+backups mit den frueheren Synthesen), und die
Roh-Transkripte (drei Owner-Pfade, UNION). Fuer E-F5 ist das Transkript PRIMAER.`,
      { label: `${s.key}:doku`, phase: 'Explore', model: 'sonnet', effort: 'max', schema: SCHEMA }),
    () => agent(`${GRUND}
## STRANG ${s.key}: ${s.titel}
### Schnitt 2 von 2: CODE (ce + super)
${s.auftrag}

DEIN SCHWERPUNKT: der Code. Je Fund den ZUSTAND (Deklaration/Implementierung/Kommentar/
verdrahtet). Tests und XSD mitlesen -- sie fixieren die gemeinte Semantik.`,
      { label: `${s.key}:code`, phase: 'Explore', model: 'sonnet', effort: 'max', schema: SCHEMA }),
  ]),
  (funde, s) => {
    const gut = (funde || []).filter(Boolean)
    if (!gut.length) return { strang: s.key, titel: s.titel, funde: [], pruefung: null }
    return agent(`${GRUND}
## GEGENPROBE fuer STRANG ${s.key}: ${s.titel}
${s.auftrag}

Zwei Agenten haben erhoben:
${JSON.stringify(gut, null, 1)}

PRUEFE SKEPTISCH AM OBJEKT: Belege nachlesen · Nullen nur mit beissender Gegenprobe (sonst
selbst nachsuchen) · Widersprueche mit Datum aufloesen (Owner-Wort schlaegt alles, Neueres
schlaegt Aelteres) · beste Gesamtantwort · Offenes ehrlich. Praezisierung != Widerlegung.`,
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

const synthese = await agent(`Du bist die SYNTHESE der vier KON25-Explores (E-F5 measure-drop-
Entscheid · E-F7 Stufe/Phase-Trennung · E-F9 Multi-Runner-gegen-Lager · E-F3b 32-vs-6).
TU-Dresden-Diplomarbeit Cache-Engine-Experiment-System, Abgabe 15.09.2026.

WICHTIG: Beginne dein Dokument mit der Titelzeile '# WF5-SYNTHESE' und schreibe KOMPAKT
(unter 20000 Zeichen) -- lieber vollstaendig kurz als abgeschnitten lang.

ERGEBNISSE (je Strang 2 Schnitte + Gegenprobe):
${JSON.stringify(ergebnisse.filter(Boolean), null, 1)}

STRUKTUR:
## 1. JE STRANG DIE ANTWORT (woertliche Belege, Fundort; bei E-F5 der Entscheid selbst)
## 2. WAS ZU BAUEN/ZU KORRIGIEREN IST (je Posten Ort + Abhaengigkeit)
## 3. WAS OFFEN BLEIBT (ehrlich; Owner-Fragen nur wenn Explore sie nicht aufloeste)
REGELN: Zitate woertlich mit [...] · jede Zahl mit Beleg · Deutsch mit korrekten Umlauten.`,
  { label: 'synthese', phase: 'Synthese', model: 'fable', effort: 'max' })

return { synthese, straenge: ergebnisse.filter(Boolean).length }
