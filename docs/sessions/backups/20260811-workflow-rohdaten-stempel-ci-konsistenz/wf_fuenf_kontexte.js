export const meta = {
  name: 'fuenf-kontexte-einlesen',
  description: 'Owner-Auftrag KON17-04: die letzten 5 Kontexte einlesen -- Owner-Schaerfungen extrahieren, gegen den Ledger halten, Unverbuchtes finden',
  phases: [
    { title: 'Lesen' },
    { title: 'Abgleich' },
    { title: 'Synthese' },
  ],
}

const TMP = '/home/comdare/.claude/jobs/5a19728e/tmp'
const SUPER = '/home/comdare/wt-super-landung'
const ROH = '/home/comdare/.claude/projects/-home-comdare/5a19728e-f6e1-4736-a246-e3fda9ac35a1.jsonl'

// Kontext -5 ist gross (131 KB) -> zwei Leser; die anderen je einer.
const SCHEIBEN = [
  { key: 'K-5a', datei: `${TMP}/owner-kontext-5.md`, teil: 'ERSTE Haelfte (bis zur Mitte der Datei)', zeilen: '34441-36298' },
  { key: 'K-5b', datei: `${TMP}/owner-kontext-5.md`, teil: 'ZWEITE Haelfte (ab der Mitte der Datei)', zeilen: '34441-36298' },
  { key: 'K-4', datei: `${TMP}/owner-kontext-4.md`, teil: 'VOLLSTAENDIG', zeilen: '36299-38111' },
  { key: 'K-3', datei: `${TMP}/owner-kontext-3.md`, teil: 'VOLLSTAENDIG', zeilen: '38112-40464' },
  { key: 'K-2', datei: `${TMP}/owner-kontext-2.md`, teil: 'VOLLSTAENDIG', zeilen: '40465-41970' },
  { key: 'K-1', datei: `${TMP}/owner-kontext-1.md`, teil: 'VOLLSTAENDIG', zeilen: '41971-43298' },
  { key: 'K-0', datei: `${TMP}/owner-kontext-0.md`, teil: 'VOLLSTAENDIG (aktueller Kontext)', zeilen: '43299-43776' },
]

const LESE_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['schaerfungen', 'zusagen', 'entscheide', 'fragen_des_owners'],
  properties: {
    schaerfungen: {
      type: 'array',
      description: 'Owner-Schaerfungen: Architektur-Festlegungen, Korrekturen, Doktrin-Saetze',
      items: {
        type: 'object', additionalProperties: false,
        required: ['zitat', 'gegenstand', 'zeile'],
        properties: {
          zitat: { type: 'string', description: 'WOERTLICH, Kuerzungen mit [...]' },
          gegenstand: { type: 'string', description: 'Worauf bezieht sich die Schaerfung (1 Satz)' },
          zeile: { type: 'string', description: 'Transkript-Zeilennummer aus dem ### KONTEXT-Header' },
          klasse: { type: 'string', description: 'ARCHITEKTUR | PRIORITAET | ARBEITSWEISE | KORREKTUR | RUEGE' },
        },
      },
    },
    zusagen: { type: 'array', items: { type: 'string' }, description: 'Was der ASSISTENT dem Owner zugesagt hat (aus den Owner-Antworten rekonstruierbar: "volles GO zu X" impliziert eine Zusage X)' },
    entscheide: { type: 'array', items: { type: 'string' }, description: 'Owner-Entscheide (GO/NO-GO/Auswahl) mit Gegenstand' },
    fragen_des_owners: { type: 'array', items: { type: 'string' }, description: 'Fragen, die der OWNER gestellt hat (nicht ich)' },
    auffaellig: { type: 'string', description: 'Was sonst auffiel: Wiederholungen, Unmut, offene Enden' },
  },
}

phase('Lesen')

const lesungen = await parallel(SCHEIBEN.map(s => () => agent(`
Du liest OWNER-NACHRICHTEN aus einer Claude-Code-Session (TU-Dresden-Diplomarbeit
"Cache-Engine-Experiment-System", Abgabe 15.09.2026). Der Owner hat angeordnet, die letzten
5 Kontexte einzulesen: "meine Owner Nachrichten waren hier Reich an Schaerfung fuer diese Session."

DEINE SCHEIBE: ${s.key} -- lies ${s.datei}, davon ${s.teil}.
(Die Datei enthaelt NUR Owner-Nachrichten, verbatim und Token-redigiert, mit Transkript-
Zeilennummern. Der zugehoerige Assistant-Kontext liegt im Roh-Transkript ${ROH},
Zeilenbereich ${s.zeilen} -- dort NUR bei Bedarf gezielt nachlesen: die Datei ist 224 MB,
IMMER mit sed -n 'X,Yp' oder grep -n arbeiten, NIE am Stueck. Roh-Transkripte koennen
Live-Tokens enthalten: NIEMALS Token-artige Strings ausgeben.)

EXTRAHIERE VOLLSTAENDIG -- Vollstaendigkeit schlaegt Kompaktheit:
1. JEDE Schaerfung (Architektur-Festlegung, Prioritaets-Setzung, Korrektur meiner Aussagen,
   Doktrin-Satz, Ruege) -- WOERTLICH zitiert, Kuerzungen mit [...].
2. JEDEN Entscheid (GO, NO-GO, Auswahl, "letztes Wort").
3. Owner-FRAGEN an mich.
4. Zusagen, die der Owner offenbar von mir erhalten hat.
Ein Satz wie "Bitte merke dir X" oder "in Zukunft immer Y" ist IMMER eine Schaerfung.
Kurznachrichten ("Dann weiter", "volles GO") sind Entscheide -- ordne sie dem Gegenstand zu,
soweit aus der Reihenfolge erkennbar; sonst als "GO ohne erkennbaren Gegenstand (Zeile N)".`,
  { label: `lese:${s.key}`, phase: 'Lesen', model: 'sonnet', effort: 'max', schema: LESE_SCHEMA })))

phase('Abgleich')

const abgleich = await agent(`
Du haeltst extrahierte Owner-Schaerfungen aus 5+1 Kontexten GEGEN DEN LEDGER, um Unverbuchtes
zu finden.

DIE EXTRAKTE:
${JSON.stringify(lesungen.filter(Boolean), null, 1)}

DER LEDGER: ${SUPER}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (22176 Zeilen,
Nachtraege OBEN, neueste zuerst: KON18, KON17, KON16, KON15, KON14, KON13, ... KON7).
Die KON-Nachtraege der letzten Nacht decken die juengsten Kontexte weitgehend -- die AELTEREN
Kontexte (-5, -4) sind die wahrscheinlichste Quelle fuer UNVERBUCHTES.

PRUEFE je Schaerfung/Entscheid: steht sie im Ledger (KON-Nummer/Zeile), in einem Plan
(${SUPER}/docs/plaene/) oder NIRGENDS? Arbeite mit grep -n auf Schluesselwoertern des Zitats
(auch Wortteile -- Zeilenumbruch bei ~95 Zeichen!). Ein Nichtfund braucht 2-3 Suchvarianten.

LIEFERE:
- verbucht: [{zitat_kurz, wo}]
- UNVERBUCHT: [{zitat, gegenstand, zeile, warum_wichtig}]  <- das ist die Ernte
- widerspruch: [{zitat, ledger_stelle, differenz}] -- wo der Ledger etwas ANDERES sagt als der Owner`,
  {
    label: 'abgleich', phase: 'Abgleich', model: 'sonnet', effort: 'max',
    schema: {
      type: 'object', additionalProperties: false,
      required: ['verbucht', 'unverbucht', 'widerspruch'],
      properties: {
        verbucht: { type: 'array', items: { type: 'object', additionalProperties: false, required: ['zitat_kurz', 'wo'], properties: { zitat_kurz: { type: 'string' }, wo: { type: 'string' } } } },
        unverbucht: { type: 'array', items: { type: 'object', additionalProperties: false, required: ['zitat', 'gegenstand', 'warum_wichtig'], properties: { zitat: { type: 'string' }, gegenstand: { type: 'string' }, zeile: { type: 'string' }, warum_wichtig: { type: 'string' } } } },
        widerspruch: { type: 'array', items: { type: 'object', additionalProperties: false, required: ['zitat', 'ledger_stelle', 'differenz'], properties: { zitat: { type: 'string' }, ledger_stelle: { type: 'string' }, differenz: { type: 'string' } } } },
      },
    },
  })

phase('Synthese')

const synthese = await agent(`Du bist die SYNTHESE des 5-Kontexte-Einlese-Auftrags
(Owner, KON17-04: "Bitte explore ueber die letzten 5 Kontexte, um dich einzulesen, meine Owner
Nachrichten waren hier Reich an Schaerfung fuer diese Session").

DIE LESUNGEN (7 Leser ueber 6 Kontexte):
${JSON.stringify(lesungen.filter(Boolean), null, 1)}

DER LEDGER-ABGLEICH:
${JSON.stringify(abgleich, null, 1)}

SCHREIBE das Einlese-Dossier als Markdown -- es wird die Grundlage fuer die XML->PDF-Ketten-Planung:

## 1. DIE SCHAERFUNGEN, GEORDNET
Nach Klasse (ARCHITEKTUR / PRIORITAET / ARBEITSWEISE / KORREKTUR / RUEGE), je Eintrag das
woertliche Zitat + Gegenstand + Kontext-Nr. Chronologie innerhalb der Klassen beibehalten.
VOLLSTAENDIG -- das Dossier ersetzt das Nachlesen.

## 2. DAS UNVERBUCHTE  🔴
Was in keiner KON-Nummer und keinem Plan steht -- je Eintrag: Zitat, warum es wichtig ist,
wohin es gehoert (Ledger-Nachtrag / Wellenplan / Memory).

## 3. WIDERSPRUECHE
Wo der Ledger anderes traegt als das Owner-Wort (Owner-Wort schlaegt alles, Neueres schlaegt
Aelteres -- benenne, was zu korrigieren ist).

## 4. DIE ROTEN FAEDEN FUER DIE XML->PDF-KETTE
Welche Owner-Saetze aus den 5 Kontexten beschreiben die Kette XML -> Planer -> ... -> PDF,
ihre Abzweigungen, ihre Prioritaets-Struktur? Konsolidiere sie zu einem Bild -- NUR aus
Owner-Worten, jede Ergaenzung von dir als solche markiert.

## 5. WAS DIE LESER NICHT KLAEREN KONNTEN
Ehrlich: GOs ohne erkennbaren Gegenstand, abgerissene Faeden, Stellen wo das Roh-Transkript
noetig waere.

REGELN: Zitate woertlich, Kuerzungen mit [...] · jede Zuordnung mit Kontext-Nr. ·
Deutsch mit korrekten Umlauten.`,
  { label: 'synthese', phase: 'Synthese', model: 'fable', effort: 'max' })

return { synthese, leser: lesungen.filter(Boolean).length, unverbucht: (abgleich?.unverbucht || []).length }
