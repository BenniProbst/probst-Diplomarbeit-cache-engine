export const meta = {
  name: 'kon19-fuenf-explores',
  description: 'Die fuenf Explore-Auftraege aus KON19: IO-Meta-Meta-Achse, Hybrid-Schichten/K2, dump-plan-Herkunft, Pruefdock-Retry, OD-7 16 Kerne',
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
- Jede Zahl/Aussage mit Beleg Datei:Zeile. Nichtfund NUR mit beissender Gegenprobe.
- Falsch-Null-Klassen: Encoding (ae/oe/ue vs Umlaut) · Case · Zeilenumbruch bei ~95 Zeichen
  (NIE nur nach Mehrwortphrasen suchen -- auch Einzelwoerter/Wortteile).
- '/build' frisst '/builder/' -- Pfadmuster mit beiden Schraegstrichen.
- grep ist ugrep-Funktion: exakte Zaehlungen mit /usr/bin/grep; -P kann stumm brechen.
- Roh-Transkripte (JSONL, bis 300 MB): NIE am Stueck lesen -- jq -c / grep -n / sed -n.
  Owner-Worte kommen ueber DREI Pfade: type==user+promptSource/origin.kind UND
  attachment.type==queued_command UND type==queue-operation+enqueue. UNION lesen!
  Transkripte koennen Live-Tokens tragen: NIEMALS Token-artige Strings ausgeben.
- STRIKT READ-ONLY.

ORTE:
  ce:        ${CE}   (670483c0)
  super:     ${SUPER}
  Ledger:    ${SUPER}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (22386 Z., KON19 oben)
  Plaene:    ${SUPER}/docs/plaene/   Sessions: ${SUPER}/docs/sessions/ (+backups/)
  Transkripte: ${ROH}/5a19728e-*.jsonl (224 MB, aktuelle Session)
               ${ROH}/46375cdc-*.jsonl (314 MB, aeltere Linie bis 06.08.)
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

const STRAENGE = [
  {
    key: 'EA-io-metameta',
    titel: 'E-A / O-4: Festplatten-IO als Organ-Meta-Meta-Achse + SIMD als System-Meta-Meta',
    auftrag: `OWNER 12.08. (KON19-01, verbatim): "O-4 ist nicht leer, SIMD ist auf der System-Achse
bereits eine valide Erweiterung (das IST die Meta-Meta-Achse) und auf Organ hatten wir doch
gesagt, dass das Festplatten IO eine solche Achse ist, weil das Genus SearchAlgorithm in der
Regel nur im RAM arbeitet, aber die IO Achse erweitern kann. Bitte explore dazu.
Organ-Meta-Meta-Achsen werden je Tier-Binary und damit je Gattung+Genus verknuepft."

FINDE:
 1. DIE FESTPLATTEN-IO-ENTSCHEIDUNG ("hatten wir doch gesagt"): wo wurde sie getroffen?
    Suche in Sessions, Ledger, Plaenen UND Roh-Transkripten (beide Dateien!) nach:
    Festplatten, IO-Achse, disk, io_axis, StorageIO, SSD, NVMe, "nur im RAM",
    SearchAlgorithm+IO, Erweiterung+IO. Datum + Wortlaut der Entscheidung liefern.
 2. SIMD ALS META-META am Objekt: wie ist SIMD heute an der System-Achse modelliert?
    (Header, Registry-Eintraege, Grammatik-Flags avx/sse -- ist die Struktur "valide
    Erweiterung" im Code ablesbar?)
 3. DIE VERKNUEPFUNG "je Tier-Binary = je Gattung+Genus": wo wuerde eine
    Organ-Meta-Meta-Achse heute andocken? (organ_meta_meta_axis.hpp existiert --
    Owner-E2-Zitat im Kopf. Was traegt sie heute, was fehlt fuer IO?)
 4. Gibt es im Bestand schon IO-bezogene Achsen/Strategien/Genus-Erweiterungen?`,
  },
  {
    key: 'EB-hybrid-schichten',
    titel: 'E-B / K2: ALLE Schichten und Eigenschaften des Hybrid aus dem Session-Log',
    auftrag: `OWNER 12.08. (KON19-02): "Bitte erklaere mir K2 (aber alle Schichten und
Eigenschaften von Hybrid sind im session log geplant - explore)".

K2 war die Frage: "Welcher LOADER-SCHICHT ist der Hybrid zugeordnet?" (aus den
Hybrid-Owner-Entscheiden 09.08.; K1 = Lager-Identitaet ist teilbeantwortet: regulaere
Gattung+Genus in den Wurzelebenen, L3-Manager-Verbot aufgehoben).

FOERDERE AUS DEM SESSION-LOG ALLES ZUM HYBRID:
 1. SCHICHTEN: Loader-Schichten des Lagers (L1/L2/L3?), wo der Hybrid einsortiert wurde,
    was "L3-Manager-Verbot aufgehoben" genau heisst. Suche: Loader, L1, L2, L3, Schicht,
    layer, dlopen, .so, Lager-Identitaet, K1, K2, K5, Hybrid+Schicht.
 2. EIGENSCHAFTEN: Transmitter/Multiplexer (KON19-02), transparent, steuerbar,
    Heuristik-Adapter-Gattung, Reroute-Genus, eigene Gattung, stempelfrei/Flaeche-2,
    Glied der MESS-Kette, kann nicht bauen. Sammle JEDE Owner-Aussage zum Hybrid
    mit Datum -- Ziel ist die VOLLSTAENDIGE Eigenschaftsliste.
 3. Quellen: docs/sessions/ (alle vom 08.-12.08.), Ledger (KON7..KON19, grep Hybrid),
    Plaene (BAUPLAN 19.07., Wellenplan §14), UND die beiden Roh-Transkripte.
 4. Am Ende: die K2-ANTWORT, falls sie im Log steht -- sonst die praeziseste
    Formulierung dessen, was K2 entscheiden muss, mit allen gefundenen Vorfestlegungen.`,
  },
  {
    key: 'EC-dumpplan',
    titel: 'E-C / O-13: Herkunft von --dump-plan / PlanTextBuilder',
    auftrag: `OWNER 12.08. (KON19-04): "Das sollte eine Director Methode sein, aber wir muessen
mit explore die Quelle bestimmen, weil ich diesen Begriff nicht gepraegt habe und auch die
Funktion nicht mehr kenne. Ich denke es ist ueberholt in der heutigen Konstellation und wird
nicht mehr benoetigt."

BESTIMME DIE QUELLE:
 1. Wo tauchen --dump-plan und PlanTextBuilder ZUERST auf? (Plaene: 20260719-planer-ceb-tier-
    topdown-BAUPLAN.md Fork B; Roh-Transkripte: wer schrieb den Begriff zuerst -- Owner-Zeile
    oder Assistant-Zeile? Die drei Owner-Pfade beachten!)
 2. Was sollte die Funktion TUN? (den Plan als Text ausgeben fuer den Contract-Test?)
 3. Existiert am Objekt schon etwas? (ce: dump-plan, dump_plan, PlanText, plan_text --
    Deklaration/Implementierung/Aufrufer?)
 4. URTEIL: ist die Funktion in der heutigen Konstellation (KON16-03: keine YAML, Planer
    emittiert Prozesse; KON19-03: eine rekursive Einstiegs-XML) noch noetig -- oder ersetzt
    der Contract-Test/die Planungs-Simulation sie? Argumente beider Seiten, KEINE Empfehlung.`,
  },
  {
    key: 'ED-pruefdock-retry',
    titel: 'E-D / T-15b: die Pruefdock-Retry-Stellen woertlich nachlesen',
    auftrag: `OWNER 12.08. (KON19-07): "Das galt doch fuer den gesamten Messdurchlauf der CEB
eines Tier-Binaries am Pruefdock bei failed Ausfuehrung. Die eigentliche success Messung wird
ja 3 Mal wiederholt wie geplant - der Mechanismus hier ist ein Robustheitskriterium. Bitte
lies das mit Explore nochmal genau nach."

MEINE FALSCHE ZUORDNUNG (zu korrigieren): die Owner-Zahl 5 wurde auf die max_reruns-Achse
(Drift-Instabilitaet der GRUPPE) gelegt -- richtig ist der Retry des GESAMTEN
CEB-Messdurchlaufs eines Tier-Binaries AM PRUEFDOCK bei failed.

LIES NACH:
 1. Die Originalstellen der "bis zu 5 Wiederholungen": GOAL-Dossier, Ledger (Z.~7681ff
    traegt die alte Analyse), Roh-Transkripte. WOERTLICH zitieren mit Fundort.
 2. Das PRUEFDOCK am Objekt: wo ist es gebaut? (Pruefdock, pruefdock, test dock, dock,
    Messdurchlauf, measurement run). Gibt es dort heute IRGENDEINEN failed-Retry?
 3. Die 3-fach-success-Wiederholung: wo ist sie verankert (reps=3, repetitions count=3,
    KF-10-Achse)? Bestaetige die Trennung der beiden Mechanismen am Objekt.
 4. WO die 5 heute (falsch) verdrahtet ist: die Stelle, an der der fruehere Agent die 5
    auf max_reruns legte -- Datei:Zeile, damit der Umzug ein praeziser Bauauftrag wird.
 5. Formuliere den KORRIGIERTEN Bau-Posten: Retry-Schleife um den Pruefdock-Durchlauf,
    Robustheitskriterium, bis zu 5, nur bei failed.`,
  },
  {
    key: 'EE-od7-kerne',
    titel: 'E-E / OD-7: die 16-Kerne-Entscheidung finden',
    auftrag: `OWNER 12.08. (KON19-09): "Das ist schon entschieden - explore. Aber es muessten
16 Kerne sein."

KONTEXT: OD-7 setzt irgendwo 24 Kerne; prod1 hat gemessen 16 Kerne/32 Threads
(Memory: reference_prod1_16_kerne_32_threads_die_24_war_falsch).

FINDE:
 1. WO steht OD-7 mit der 24? (Ledger, Plaene, Sessions -- OD-7, 24 Kerne, cores,
    Kapazitaet, Threads). Alle Fundstellen mit Zeile.
 2. DIE ENTSCHEIDUNG ("schon entschieden"): wo wurde 16 festgelegt? (Roh-Transkripte
    + Sessions; auch die Hardware-Messung zaehlt als Beleg, aber der Owner meint eine
    ENTSCHEIDUNG -- finde sie.)
 3. WAS haengt an der Zahl? (Kapazitaetsrechnungen, Batch-Planung, concurrent=4-Rechnungen,
    Mess-Deckel ETA <= 4,5 Maschinentage -- welche Rechnungen muessten mit 16 statt 24
    nachgezogen werden? Liste mit Fundstellen.)
 4. Formuliere den Korrektur-Posten: welche Stellen aendern, welche Rechnungen nachziehen.`,
  },
]

phase('Explore')

const ergebnisse = await pipeline(
  STRAENGE,
  (s) => parallel([
    () => agent(`${GRUND}
## STRANG ${s.key}: ${s.titel}
### Schnitt 1 von 3: DOKU (Ledger + Plaene + Sessions + Backups)
${s.auftrag}

DEIN SCHNITT: ${SUPER}/docs/ -- Ledger (22386 Z., grep -n + gezielt lesen, KON-Nachtraege
OBEN), plaene/, sessions/ inkl. backups/ (dort liegen fruehere Explore-Synthesen im Volltext).`,
      { label: `${s.key}:doku`, phase: 'Explore', model: 'sonnet', effort: 'max', schema: SCHEMA }),

    () => agent(`${GRUND}
## STRANG ${s.key}: ${s.titel}
### Schnitt 2 von 3: CODE (ce + super)
${s.auftrag}

DEIN SCHNITT: der Code. ${CE} (libs/, apps/, tools/, topics/, tests/) und ${SUPER}/ci,
${SUPER}/Code. Je Fund den ZUSTAND: Deklaration / Implementierung / Kommentar / verdrahtet.`,
      { label: `${s.key}:code`, phase: 'Explore', model: 'sonnet', effort: 'max', schema: SCHEMA }),

    () => agent(`${GRUND}
## STRANG ${s.key}: ${s.titel}
### Schnitt 3 von 3: ROH-TRANSKRIPTE (Owner-Worte)
${s.auftrag}

DEIN SCHNITT: die beiden grossen JSONL-Transkripte (${ROH}/5a19728e-*.jsonl aktuell,
${ROH}/46375cdc-*.jsonl aeltere Linie). ALLE DREI Owner-Pfade als UNION. Politisch wichtig:
Owner-Zeilen von Assistant-Zeilen UNTERSCHEIDEN (type-Feld pruefen) -- fuer Herkunftsfragen
("wer praegte den Begriff?") ist genau das die Antwort. NIEMALS Token-Strings ausgeben.`,
      { label: `${s.key}:roh`, phase: 'Explore', model: 'sonnet', effort: 'max', schema: SCHEMA }),
  ]),

  (funde, s) => {
    const gut = (funde || []).filter(Boolean)
    if (!gut.length) return { strang: s.key, titel: s.titel, funde: [], pruefung: null }
    return agent(`${GRUND}
## GEGENPROBE fuer STRANG ${s.key}: ${s.titel}
${s.auftrag}

Drei Agenten haben aus drei Quellen erhoben:
${JSON.stringify(gut, null, 1)}

PRUEFE SKEPTISCH AM OBJEKT: Belege oeffnen und nachlesen · Nullen nur mit beissender
Gegenprobe (sonst selbst nachsuchen, mit Encoding/Case/Wortteil-Varianten) · Widersprueche:
welche Fassung ist naeher am Objekt/neuer · beste Gesamtantwort · Offenes ehrlich.
Praezisierung ist KEINE Widerlegung.`,
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

const synthese = await agent(`Du bist die SYNTHESE der fuenf KON19-Explores
(TU-Dresden-Diplomarbeit Cache-Engine-Experiment-System, Abgabe 15.09.2026).

Der Owner hat am 12.08. acht Fragen beantwortet und dabei fuenf Explore-Auftraege erteilt:
E-A (Festplatten-IO als Organ-Meta-Meta-Achse + SIMD als System-Meta-Meta) ·
E-B (ALLE Hybrid-Schichten/Eigenschaften aus dem Session-Log -> K2 erklaeren) ·
E-C (Herkunft von --dump-plan, vermutlich ueberholt) ·
E-D (Pruefdock-Retry: die 5 woertlich nachlesen, Bau-Posten umziehen) ·
E-E (OD-7: die 16-Kerne-Entscheidung finden).

ERGEBNISSE (je Strang drei Quellen-Schnitte + skeptische Gegenprobe):
${JSON.stringify(ergebnisse.filter(Boolean), null, 1)}

SCHREIBE die Auswertung als Markdown fuer Owner und Ledger:
## 1. JE STRANG: DIE ANTWORT  (mit woertlichen Owner-Zitaten aus den Funden, Belegen, und
   dem, was am Objekt existiert vs. fehlt)
## 2. DIE K2-ERKLAERUNG  (aus E-B: was K2 entscheiden muss, welche Vorfestlegungen im Log
   stehen, und -- falls die Antwort dort steht -- die Antwort selbst)
## 3. KORRIGIERTE BAU-POSTEN  (aus E-D: der Pruefdock-Retry-Umzug praezise; aus E-C: das
   UEBERHOLT-Urteil mit Herkunftsbeleg; aus E-E: die OD-7-Korrekturliste)
## 4. WAS OFFEN BLEIBT  (ehrlich, je Punkt: warum + naechster Schritt)
REGELN: Zitate woertlich mit [...]-Kuerzungen · jede Zahl mit Beleg · Praezisierung ist
keine Widerlegung · Deutsch mit korrekten Umlauten.`,
  { label: 'synthese', phase: 'Synthese', model: 'fable', effort: 'max' })

return { synthese, straenge: ergebnisse.filter(Boolean).length }
