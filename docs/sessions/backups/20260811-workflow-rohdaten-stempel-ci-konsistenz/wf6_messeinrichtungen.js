export const meta = {
  name: 'r1-messeinrichtungen-je-traeger-stufe',
  description: 'KON30-01: die Messeinrichtungen je Traeger-Stufe kartieren -- wo gehoert was hin, was ist ein/aus schaltbar -- und daraus 32-vs-6 aufloesen',
  phases: [
    { title: 'Kartierung' },
    { title: 'Synthese' },
  ],
}

const SUPER = '/home/comdare/wt-super-landung'
const CE    = '/home/comdare/wt-super-landung/Code/external/comdare-cache-engine'

const GRUND = `
ARBEITSREGELN: Gegenstand-Suche (v3.3/A2.2) · jede Aussage mit Datei:Zeile · Nichtfund nur mit
beissender Gegenprobe · /usr/bin/grep fuer Zaehlungen · '/build' frisst '/builder/' · READ-ONLY.
ORTE: ce ${CE} · super ${SUPER} · Ledger ${SUPER}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md
(23718 Z., KON30 oben) · Plaene/Sessions unter ${SUPER}/docs/.

DER OWNER-AUFTRAG (KON30-01, verbatim): "bitte verstehe die Messeinrichtungen in jeder
Traeger-Stufe und dann wird es klar, wenn du verstehst wo was hingehoert und ein oder aus
geschalten werden kann bezueglich der Messachsen."

DER RAHMEN (owner-gesetzt):
  KON25-03: Tier = Micro+Macro (je an/aus) · Hybrid = eigene Micro+Macro (je an/aus) ·
            CEB = Wall-Clock (an/aus)  =>  32 Belegungen
  KON29-05: die 6 = ANORDNUNGS-Permutationen der drei Mess-Layer (Wallclock/Makro/Mikro)
            am Steuer-Dock (steuer_dock.hpp:229-241, static_assert anzahl==6)
  DOPPELBAU: measurement_tooling_registry (AUSWAHL-Semantik, 18 Dateien, dormant)
  KON30-02: der Pruefling erweitert NUR Organ-Achsen -- Mess-Einrichtungen sind davon getrennt
  KON29-01: --debug ist QUER zu allem (RunMethodology, eigene Unter-Achse)
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

phase('Kartierung')

const schnitte = await parallel([
  () => agent(`${GRUND}
## SCHNITT 1: DIE MESSEINRICHTUNGEN AM OBJEKT — was existiert, wo sitzt es, wie schaltet es

KARTIERE die drei Instrumenten-Familien und ihre Schalter:
 1. WALL-CLOCK / checkpoint_measure: wo implementiert, wer ruft es, an welcher Traeger-Stufe
    haengt es HEUTE (CEB? Iterator? Tier?), und wie wird es ein-/ausgeschaltet (XML, Define,
    RunMethodology, Flag)?
 2. MACRO-Benchmarking: dasselbe -- Fundort, Traeger-Zuordnung, Schalter. (Stichworte: Makro,
    macro, checkpoint, Messfuehler, measurement sensor, COMDARE_MEASUREMENT_ON)
 3. MICRO-Benchmarking: dasselbe. (micro, Mikro, PMC, pmu, perf)
 4. PMC als Meta-Meta-Mess-Achse (AMD/Intel getrennt): wo sitzt der Schalter, und ist PMC
    Teil von Micro oder eine eigene Einrichtung?
 5. Je Einrichtung: ist die AN/AUS-Schaltung heute XML-erreichbar, compile-time-Define,
    oder gar nicht gebaut?
LIEFERE die Tabelle: Einrichtung | Fundort | heutige Traeger-Zuordnung | Schalter | Zustand.`,
    { label: 'einrichtungen', phase: 'Kartierung', model: 'sonnet', effort: 'max', schema: SCHEMA }),

  () => agent(`${GRUND}
## SCHNITT 2: DIE SOLL-ZUORDNUNG AUS DEN PLAENEN + die Rolle der 6er-Ordnung

 1. Was sagen Plaene/Ledger/Sessions darueber, WELCHE Messeinrichtung zu WELCHER
    Traeger-Stufe GEHOERT (SOLL)? (KON25-03 ist der juengste Stand: Tier Micro+Macro,
    Hybrid Micro+Macro, CEB Wall-Clock. Aeltere Fassungen: "3 Mess-Ebenen -> 4",
    E-Ebenen E1-E4, checkpoint_measure-Regelung, GO-3 vierte Mess-Ebene.)
 2. Die 6er-ANORDNUNG (Reihenfolge Wallclock/Makro/Mikro): WOZU war die Reihenfolge da?
    (steuer_dock.hpp + konfiguration.hpp lesen: was bedeutet "Ordnung=Identitaet" dort,
    was steuert die Reihenfolge fachlich -- Mess-Reihenfolge im Durchlauf? Prioritaet?
    CEB-Varianten?) Und: haengt die 6 an der Annahme, dass ALLE DREI Instrumente an
    EINER Stelle (CEB) sitzen?
 3. Das AUSWAHL-Subsystem (measurement_tooling_registry, canonical_combo, XSD <combo>):
    welche Rolle hat ES gegenueber der Anordnung -- und deckt es die an/aus-Schaltung
    der 32 bereits ab?
 4. Wie passt --debug/RunMethodology als QUER-Flag dazu?
LIEFERE: die SOLL-Karte + die fachliche Bedeutung der Reihenfolge + ob die 6 ihre
Voraussetzung im 32er-Modell verliert.`,
    { label: 'soll-und-ordnung', phase: 'Kartierung', model: 'sonnet', effort: 'max', schema: SCHEMA }),
])

phase('Synthese')

const synthese = await agent(`Du bist die SYNTHESE der R-1-Kartierung (KON30-01). Beginne mit
'# R-1-KARTIERUNG' und bleibe UNTER 12000 Zeichen.

DER OWNER-AUFTRAG: "verstehe die Messeinrichtungen in jeder Traeger-Stufe ... wo was hingehoert
und ein oder aus geschalten werden kann bezueglich der Messachsen" -- dann loest sich 32-vs-6.

DIE ZWEI SCHNITTE:
${JSON.stringify(schnitte.filter(Boolean), null, 1)}

SCHREIBE:
## 1. DIE KARTE: Messeinrichtung x Traeger-Stufe x Schalter (IST und SOLL, Tabelle)
## 2. DIE AUFLOESUNG 32-vs-6: was die Reihenfolge fachlich war, ob ihre Voraussetzung im
   32er-Modell faellt, und welche Rolle dem Auswahl-Subsystem zukommt. Als HERLEITUNG aus
   der Karte -- der Owner sagte "dann wird es klar". Wenn es NICHT klar wird: sagen, was fehlt.
## 3. WAS ZU BAUEN IST (an/aus-Schalter je Stufe in XML/Planer-CLI; Verhaeltnis zu --debug)
REGELN: Zitate woertlich · jede Zahl mit Beleg · Deutsch mit Umlauten.`,
  { label: 'synthese', phase: 'Synthese', model: 'fable', effort: 'max' })

return { synthese }
