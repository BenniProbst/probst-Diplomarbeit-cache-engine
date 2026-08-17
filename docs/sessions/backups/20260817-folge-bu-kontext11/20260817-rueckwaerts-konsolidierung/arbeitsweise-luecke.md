# RUECKWAERTS-KONSOLIDIERUNGS-EXPLORE — CLUSTER "DER PROZESS-FEHLER SELBST"

## Vorbemerkung zur Quellenlage (Transparenz vor Inhalt)

Die woertliche Ruege-Zeile aus dem Auftrag ("Die Arbeitsweise war also wieder nicht strikt eingehalten und daher gab es mehr arbeit als noetig") ist **an keiner Stelle im super-Repo wortgleich auffindbar** (grep ueber Ledger + alle docs/ = 0 Treffer). Sie ist vermutlich eine live gegebene Owner-Aeusserung, die diesen Explore-Auftrag ausgeloest hat und noch nicht als KON-Zeile persistiert ist. Ich behandle sie als gegebenen Anlass, nicht als zu verifizierendes Zitat, und baue die Selbstmessung stattdessen aus dem, was IM Ledger und in den drei 17.08.-Vorlage-Dokumenten tatsaechlich steht.

Zusaetzlich zu den genannten Quellen habe ich `/home/comdare/Projekte/docs/ARBEITSWEISE-GESAMT-DOKTRIN.md` gelesen (die Live-Fassung des Umbrella-Dokuments, 1220 Z., Stand v4.3 + B.3-Nachtrag KON97 vom 16.08.) — das ist NICHT in der Quellenliste des Auftrags genannt, aber es ist das Dokument, dessen Teile B.3/A2.3 der Auftrag als Landeplatz fuer den Regel-Kandidaten nennt, und es liegt lokal auf derselben Maschine unter dem im super-Ledger selbst dokumentierten Pfad. Ohne diese Datei waere Punkt (d) nur eine Vermutung ueber A2.3 statt eine Anschluss-Formulierung an den tatsaechlichen Text gewesen.

---

## (a) Rekonstruktion: welche Owner-Fragen liefen OHNE dedizierten 12-Wochen-Explore

Der 17.08. zerfaellt in FUENF Owner-Antwort-Runden (KON101-105) plus einen Vorlauf-Vorfall, der die ganze Kette ausloeste. Rekonstruktion je Runde, mit Explore-Vorlauf-Pruefung:

| Runde | Vorlage-Dokument | Fragen | Explore-Vorlauf VOR dem Versand | Ergebnis der Nachpruefung |
|---|---|---|---|---|
| **0 (Ausloeser)** | `OWNER-VORAB-15.md` (KON99-03, wf_afe22f0b: 7 Flaechen-Explores g1-g7 + Fable-Synthese) | 13 (V-01..V-13) | **FALSCHE ART**: Flaechen-Explore fuer den Bau-Plan, kein Je-Frage-12-Wochen-Check | Owner-Ruege: *"Hast du alle Fragen vorher mit einem 10 Wochen explore geprueft?"* -> **NEIN**. Retro-Check (wf_e129dbb8, 1,13M Tok., 309 Tool-Calls): **8 von 13 (62%)** trugen bereits entschiedenen Inhalt (1 komplett [V-07], 7 Haelften [S2-S8], KON100-01) |
| **1** | `OWNER-VORAB-15-restfragen.md` (V-01R..V-13, KON101) | 12 | **JA** — dies ist die Korrektur-Runde selbst | Sauber bis auf **1/12 (8%)**: V-02R brauchte einen ZWEITEN Post-hoc-Explore (wf 969b3bba, 671k Tok.), weil der Erst-Explore die exakte, bereits dokumentierte Byte-Grammatik nicht gefunden hatte — Owner: *"Die exakte Byte Form ... wurde in den letzten 10 Wochen entschieden und ist dokumentiert ... Bitte explore"* |
| **2** | `20260817-DESIGN-s13-buendel-di25.md`, OV-S13-2..-6 (Strang **s13-design**, KON102) | 5 | **NEIN** — interner Lens-Zyklus (KON100-02) pruefte Design-Konsistenz, keinen Je-Frage-Historien-Check | **2 von 5 (40%)** vom Owner ZURUECKGEWIESEN statt entschieden — OV-S13-2b: *"das ist UMFASSEND ueber die letzten 10 Wochen definiert und MUSS nachgelesen werden"*; OV-S13-4: *"das ist schon definiert ueber die letzten 12 Wochen ... bitte Sonnet max explore"* (Folge: wf 875f28df, 910k Tok.) |
| **3** | `20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md` (Strang **owner-vorlagen**, KON103+KON104) | 20 (A-1,A-2,B-1,C-1..3,D-1..10,E-1..4) | **NEIN** — Quelle war ein allgemeiner Drift-Sweep (r1-r5/e1-e4), dieselbe Art Explore, die in Runde 0 bereits als unzureichend erkannt worden war | **Mind. 7/20 (35%) bestaetigt redundant/falsch-herum**, plus 2 weitere weiche Faelle -> **bis zu 9/20 (45%)** (Details unten) |
| **4** | KON105, "alle jetzt noch offenen Rueckfragen der letzten 2 Kontexte" (R4,P1-P5,E-2,D2a,D2c,E-4,E-1,E-3) | 12 | **JA** — zweite Korrektur-Runde desselben Tages (wf_a2e443f0, 2,6M Tok., 12 parallele Sonnet-max-Explorer) | **10 von 12 (83%)** bereits entschieden — nur E-1/E-3 blieben echte offene Fragen |

**Kernbefund von (a):** Die Explore-Zehn-Wochen-Pflicht wurde in EINER von drei bundle-produzierenden Runden befolgt (Runde 1, ausgeloest durch die Ruege), aber **nicht propagiert** auf die zwei GLEICHZEITIG in derselben Session laufenden Schwester-Straenge (Runde 2 = s13-design, Runde 3 = owner-vorlagen) — diese wiederholten denselben Fehler, den Runde 0 bereits begangen hatte, obwohl die Korrektur zu diesem Zeitpunkt bereits im Ledger stand (KON100, vor KON102/103).

### Detailbeleg je bestaetigtem Fall in Runde 3 (die 20er-Vorlage)

- **B-1** (C-3a-Tripwire ausloesen): **KON91-02** (vor KON103, selber Tag-Cluster) hat exakt dasselbe JA mit exakt derselben Begruendung bereits verbucht: *"C-3a ENTSCHIEDEN: JA ('genau so wie empfohlen') ... EIGENES PAKET IM EINEN W1-BUMP-BUENDEL"*. B-1 in der 20er-Vorlage fragt wortgleich dasselbe noch einmal.
- **C-3** (welche der 6 best_binary-Metriken MAX/MIN): Der **T-9-Katalog** (`heuristik/axis_optimization_catalog.hpp`, 436 Z., 45 Zielgroessen mit 17 MAX/28 MIN) existiert bereits seit **08.08.** (Ledger:26539-26559, Session `20260808-SESSION-zielgroessen-katalog-alle-19-achsen-erklaert.md`) — 9 Tage vor der Frage. Die Vorlage zitiert den Katalog korrekt im STAND-Absatz, schiebt die eigentliche Ableitungsarbeit (welche der sechs `best_binary_selector`-Metriken auf welche Katalog-Zielgroesse mappen) aber in eine SPAETERE Runde ("ich lege dir die sechs Metriken vor, sobald du 'ja' sagst") statt sie selbst zu leisten. Owner: *"Es gibt dazu immer noch einen deep research workflow, bitte selbst tief lesen."*
- **D-4** (ETA `last_update_utc`-Merge): **Wortgleich identisch mit OV-S13-2a** aus Runde 2, mit demselben Beleg-Anker (`r5 A48/A50`) in BEIDEN unabhaengig geschriebenen Vorlagen. KON103-04 quittiert es explizit: *"D-4 = OV-S13-2a erledigt"*. Zwei parallele Straenge (owner-vorlagen, s13-design) haben am selben Tag dieselbe Frage unabhaengig voneinander formuliert.
- **D-5** (Talos-Zwei-Regime-Aussage zuruecknehmen?): Dies ist der staerkste Einzelfund. Der Ledger enthaelt (:26702-26708) eine **bereits ausgefuehrte** Korrektur ("VERGESSENE ARBEIT V2 VOLLZOGEN: die Talos-Tempus-Korrektur, thesis eaf7fe8") mit dem woertlichen Vor-Verdikt: *"Loesung ist Tempus/Status praezisieren -- NICHT streichen, NICHT 'Rollentrennung'"*. Die 20er-Vorlage empfahl D-5 exakt das Gegenteil ("Zuruecknehmen"). Owner: *"UMKEHR der Vorlage-Empfehlung ... 'wie geplant AUFBAUEN, das muss noch'"*. Bemerkenswert: **der Ledger diagnostiziert an genau dieser Stelle bereits die Fehlerklasse selbst** — *"Das ist die Fehlerklasse: eine Umklassifizierung ERSETZT die verordnete Massnahme nicht"* — ein woertlicher Praezedenzfall fuer den hier gesuchten Muster-Namen, den die Vorlage 9 Tage spaeter erneut reproduzierte.
- **D-9** (ccache-Allowlist A11, Chronologie-Inversion): Der STAND-Absatz der Vorlage nennt selbst beide Daten — Plan-Posten **02.08.** vs. Code-Kommentar **27.07.** — die EMPFEHLUNG favorisiert dann die AELTERE Quelle (27.07.) gegen die JUENGERE (02.08.), invertiert also die eigene "neueste Aussage gewinnt"-Doktrin, obwohl beide Daten im selben Absatz stehen. Owner korrigierte mit exakt dieser Doktrin: *"die neueste Aussage gewinnt"*.
- **E-2** (`BAUSTEINE_BEWERTUNG.md`): War **gar keine Owner-Frage** — Habich-Termin-7-Auflage (H2, 08.05.) UND ein existierender Bauposten (R-26, Wellenplan 19.7) waren bereits vorhanden; die Vorlage fragte trotzdem ein Ja/Nein ab. KON105-02: *"KEINE Owner-Frage."*
- **E-4** (FF0/Multi-Plattform-Scope): Die Vorlage-EMPFEHLUNG rekonstruiert eine Scope-Split-Formulierung, die **wortgleich** bereits als Pilot-Entscheid am **07.08.** im Ledger steht (:25858-25861). KON105-02 woertlich: *"Die heutige E-4-Empfehlung war eine UNERKANNTE WIEDERHOLUNG der 10 Tage aelteren Ledger-Zeile."*

**Zwei explizit gepruefte GEGENBEISPIELE (nicht in dieselbe Klasse geraten):**
- **A-1** (Token-Rotation sofort vs. Wartungsfenster): grep ueber den vollen Ledger findet **keine** fruehere Formulierung von "5 Agenten parallel -> Infra orchestriert ein Wartungsfenster ueber den Owner". Das ist keine 12-Wochen-Historie, die ein Explore gehoben haette, sondern ein situatives Faktum des LAUFENDEN Tages (die Parallelitaet von main/gut-wie-wirst/hy-a-bau/k2-bau/owner-vorlagen/s13-design/triage31/vl12-bau/vl3-bau/wo-stehen-wir existiert erst JETZT). Die Vorlage-Empfehlung war taktisch unvollstaendig (empfahl session-seitige Rotation), aber das ist ein anderer Fehlertyp als "Historie nicht gefunden".
- **C-2** (I-PMC-2/3 bauen oder Zusage zuruecknehmen): Keine Vorgaenger-Formulierung von "volles Programm, nichts nach der Abgabe" fuer GENAU diesen Gegenstand gefunden — Owner hat hier erkennbar neu entschieden, nicht etwas Bekanntes wiederholt.

---

## (b) Ehrliche Bezifferung der Mehrarbeit

**Owner-Beruehrungen an einem einzigen Kalendertag (17.08.):** mindestens 6 — die Vorlauf-Ruege + KON101 + KON102 + KON103 + KON104 + KON105. Von diesen sechs waren mindestens DREI (die Ruege selbst, der OV-S13-2b/-4-Ruecksprung in KON102, der Dreifach-Auftrag in KON105) reine PROZESS-Korrekturen — der Owner musste seine Aufmerksamkeit auf "das ist falsch gemacht" statt auf Sachentscheidungen verwenden.

**Explore-Tokenverbrauch, der NACH statt VOR der Frage lief (alle am 17.08.):**

| Workflow | Anlass | Tokens |
|---|---|---|
| wf_e129dbb8 | Retro-Check der 13 V-Fragen NACH der Ruege | 1,13 Mio. |
| wf 969b3bba | V-02R-Byte-Grammatik NACH Owner-Antwort in KON101 | 671 k |
| wf 875f28df | OV-S13-2b/-4 NACH Owner-Ruecksprung in KON102 | 910 k |
| wf_a2e443f0 (KON105) | 12-Fragen-Sweep NACH KON101-104 | 2,6 Mio. |
| **Summe** | | **~5,31 Mio. Tokens** |

Das ist Explore-Arbeit, die inhaltlich groesstenteils WERTVOLL und noetig war (die Ergebnisse tragen jetzt Bauentscheidungen) — die Verschwendung liegt nicht im Inhalt, sondern in der REIHENFOLGE: dieselbe Rechercheleistung, VOR der jeweiligen Vorlage statt danach erbracht, haette dieselbe Erkenntnis ohne den dazwischenliegenden Owner-Ruecksprung geliefert.

**Quotenbild ueber alle vier bundle-produzierenden Runden hinweg** (Runden 0, 2, 3 = ohne Vorlauf-Explore; Runden 1, 4 = mit): von **38 in Runden ohne Vorlauf-Explore gestellten Fragen** (13+5+20) waren **~17-19 (ca. 45-50%)** bereits entschieden oder aus vorhandenem Material klar ableitbar — nahezu deckungsgleich mit der Quote der beiden korrekt vorexplorierten Runden im Rueckblick (Runde 1: 1/12 Nacharbeit, Runde 4: 10/12 Vorentscheidungen bestaetigt). Die Konstanz dieser Quote UEBER ALLE RUNDEN HINWEG (unabhaengig davon, ob vorexploriert wurde) ist selbst ein Befund: **das Verhaeltnis "bereits entschieden" bleibt gleich hoch — nur die Frage, WANN das auffiel (vor oder nach dem Owner-Kontakt), aendert sich.**

**Das eigentliche Risiko ist qualitativ, nicht nur quantitativ:** In mindestens zwei Faellen (D-9, V-02R) haette ein einfaches Owner-"ja wie empfohlen" eine SACHLICH FALSCHE Konstruktion in den Bau gegeben (verkehrte Chronologie-Aufloesung bzw. erfundene statt dokumentierte Byte-Grammatik). Diese wurden nur gefangen, weil der Owner aktiv nachfragte statt zu bestaetigen — es gibt keinen strukturellen Mechanismus, der das beim naechsten Mal wieder faengt.

---

## (c) Die Muster-Klasse, praezise benannt

Es ist **nicht** "Explore wurde vergessen" — in jeder der drei betroffenen Runden LIEF ein Explore (Flaechen-Explore in Runde 0, Design-Lens in Runde 2, Drift-Sweep in Runde 3). Das Muster ist praeziser:

1. **Destillierte Folgefragen wurden als "neu genug" behandelt.** D-4/OV-S13-2a ist der Reinfall: eine aus laufender Analyse destillierte Frage (ETA-Merge-Mechanik) wurde von zwei Straengen unabhaengig als je EIGENE, frische Frage formuliert, obwohl beide auf demselben Beleg-Anker (`r5 A48/A50`) sitzen — keiner der beiden Straenge fragte "laeuft diese Frage nicht gerade PARALLEL bei einem Geschwister-Strang?".

2. **Empfehlungs-Zeilen wurden gegen den eigenen STAND-Absatz nicht gegengelesen.** Der STAND-Text war in D-9, D-5, C-3 und E-4 jeweils KORREKT und vollstaendig recherchiert — das Beweismaterial fuer die richtige Antwort stand bereits im selben Absatz. Der Bruch passierte beim Schritt STAND -> EMPFEHLUNG: D-9 kehrte die eigene "neueste Aussage gewinnt"-Doktrin um, D-5 empfahl das woertliche Gegenteil eines bereits vollzogenen Vorgaenger-Verdikts, E-4 wiederholte unerkannt eine 10 Tage alte Ledger-Zeile, C-3 verschob die im STAND selbst benannte Ableitung in eine kuenftige Runde. Diese Fehlerklasse hat der Ledger selbst schon einmal treffend benannt (Ledger:26706, zum Talos-Fall): *"eine Umklassifizierung ERSETZT die verordnete Massnahme nicht"* — dieselbe Formel gilt fuer "eine Empfehlung ersetzt nicht die im eigenen STAND zitierte Vorentscheidung".

3. **Die Korrektur-Lehre aus einem Strang propagierte nicht zu parallelen Straengen derselben Session.** Runde 1 (V-Fragen) hatte die Lektion aus der Ruege bereits verarbeitet (Explore-vor-Frage), als Runde 2 (s13-design) und Runde 3 (owner-vorlagen) — GLEICHZEITIG in derselben Session laufend — denselben unkorrigierten Weg gingen. Das ist keine Wissenslücke im Sinn von "die Regel war unbekannt" (A2.3 existierte bereits seit v3.5, 12.08.), sondern eine **fehlende Durchsetzung ueber Strang-Grenzen**: A2.3 sagt "der Zehn-Wochen-Explore ist der Normalfall fuer JEDE Frage", aber es gibt keinen Mechanismus, der das bei der ZUSAMMENSTELLUNG eines Vorlage-Buendels erzwingt, und keinen, der zwei gleichzeitig laufende Vorlage-Straenge gegeneinander auf Ueberschneidung prueft.

**Kurzformel:** A2.3 regelt HEUTE nur die Suchtechnik innerhalb eines Explores (Encoding/Case/Zeilenumbruch/Kontext-Disziplin) — sie regelt NICHT, dass der Explore vor Vorlage-Versand PFLICHT-GATE ist, NICHT, dass STAND und EMPFEHLUNG gegeneinander verifiziert werden, und NICHT, dass parallele Vorlage-Straenge sich gegenseitig auf Dopplung pruefen. Genau diese drei Luecken sind es, die am 17.08. dreimal hintereinander in dieselbe Mehrarbeit liefen.

---

## (d) Regel-Kandidat fuer B.3/A2.3

**Befund zum Landeplatz:** B.3 traegt bereits einen exakt passenden, noch nicht in Kraft gesetzten Mechanismus — den Block **REGEL-KANDIDATEN v4.4** (`ARBEITSWEISE-GESAMT-DOKTRIN.md:979-995`, angelegt per B.3-NACHTRAG 16.08./KON97, "Owner-gated — VORSCHLAG, NICHT in Kraft", 8 Kandidaten). Der folgende Vorschlag reiht sich dort additiv als Kandidaten 9-11 ein (gleicher Stil: ein Satz, Begruendungsklausel, Herkunfts-Tag) statt einen neuen Mechanismus zu erfinden:

> **9. Vorlage-Sperre gegen Bereits-Entschiedenes:** Eine Frage geht erst an den Owner, wenn ihr eigener STAND-Absatz gegen eine explizite NEIN-Probe gehalten wurde — "gibt es zu genau diesem Gegenstand bereits ein KON-/Owner-Wort, einen bestehenden Bauposten, oder eine ZEITGLEICH laufende Vorlage eines anderen Strangs derselben Session?" Der Fund gehoert VOR die Formulierung der Empfehlung, nicht in eine spaetere Korrektur-Runde (Beleg: B-1/KON91-02, D-4/OV-S13-2a, E-2/E-4 — 17.08., KON103-105).
>
> **10. STAND-Empfehlung-Gegenlese:** Jede EMPFEHLUNG wird vor Versand gegen die im selben Absatz zitierten Daten/Anker gegengelesen — insbesondere auf Datums-Reihenfolge ("neueste Aussage gewinnt" gilt fuer die zitierten Quellen, nicht fuer die zuletzt gelesene) und auf bereits ausgefuehrte Vorgaenger-Massnahmen, die die Empfehlung stillschweigend rueckgaengig machen wuerde. Eine Empfehlung, die dem eigenen STAND widerspricht, ist ein Bau-Risiko, kein Formulierungsdetail (Beleg: D-9-Chronologie-Inversion, D-5-Talos-Ruecknahme gegen das bereits vollzogene "NICHT streichen"-Verdikt, Ledger:26706).
>
> **11. Strang-uebergreifende Dopplungs-Probe:** Eine Explore-Korrektur aus einem Strang gilt ab dem Moment fuer ALLE parallelen Straenge derselben Session, die selbst Owner-Fragen buendeln — nicht nur fuer den geruegten Strang. Vor Versand prueft jedes Vorlage-Dokument seinen Fragen-Katalog gegen die anderen zeitgleich laufenden Vorlage-Dokumente auf Gegenstands-Ueberschneidung (Beleg: OV-S13-2a/D-4-Dopplung zwischen den Straengen s13-design und owner-vorlagen, selber Tag, selber Beleg-Anker r5 A48/A50).

**Verhaeltnis zu A2.3 (Teil A, universell):** A2.3 selbst sollte nicht einfach erweitert werden, ohne den Owner-Gate zu respektieren, der fuer Teil A einen echten Versions-Bump verlangt (anders als B.3-Nachtraege). Ich schlage NICHT vor, A2.3 eigenmaechtig zu aendern. Sobald Kandidaten 9-11 vom Owner freigegeben werden, ist ihre naheliegende Zielform aber eine Ergaenzung von A2.3 um einen expliziten GATE-Satz nach dem Muster: *"Der Zehn-Wochen-Explore ist nicht nur Suchtechnik, sondern eine PFLICHT-STUFE vor jedem Vorlage-Versand — inklusive Gegenlese der eigenen Empfehlung gegen den eigenen Stand und gegen zeitgleiche Geschwister-Vorlagen."* Das waere dann der eigentliche v4.4-Bump (der Block traegt den Namen bereits, ist aber laut KON97-Nachtrag explizit "Kein Versions-Bump" bis zur Freigabe).

---

## GEPRUEFT

Alle vier Teilfragen (a)-(d) sind quellenbasiert beantwortet: (a) mit einer vollstaendigen Fuenf-Runden-Tabelle plus sieben einzeln belegten Faellen und zwei geprueften Gegenbeispielen; (b) mit Token- und Rundenzahlen direkt aus dem Ledger (KON100/101/102/104/105) statt Schaetzung; (c) mit einer Drei-Punkt-Musterklasse, die durch eine bereits im Ledger selbst vorhandene Parallel-Diagnose (Ledger:26706) gestuetzt wird; (d) mit einem Textvorschlag, der an den tatsaechlich existierenden, noch offenen Mechanismus (REGEL-KANDIDATEN v4.4, B.3) andockt statt einen neuen zu erfinden.

**Einschraenkung (ehrlich zu nennen):** Die woertliche Ausloeser-Ruege selbst konnte ich nicht im Repo verifizieren (vermutlich noch nicht persistiert); meine Bewertung der einzelnen 20er-Vorlage-Punkte als "explore-faengbar" vs. "genuin neu" ist an sieben Stellen durch KON103-105-Eigenbefunde direkt gedeckt, an zweien (D-9-Chronologie, D-5-Talos-Praezedenz) durch eigene Quervergleiche dieser Exploration neu erschlossen und noch nicht an anderer Stelle gegengelesen.

**Relevante Pfade:** `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (Zeilen 19-460 = KON101-105; 968 = KON91-02; 26539-26559 = T-9-Katalog; 26696-26710 = Talos-Tempus-Praezedenz) · `docs/sessions/20260817-OWNER-VORAB-15-restfragen.md` · `docs/sessions/20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md` · `docs/plaene/20260817-DESIGN-s13-buendel-di25.md` · `docs/sessions/backups/20260817-drift-konsolidierung-rohdaten/DOSSIER.md` (Zeilen 543-609) · `/home/comdare/Projekte/docs/ARBEITSWEISE-GESAMT-DOKTRIN.md` (Zeilen 437-454 = A2.3; 913-996 = B.3 + REGEL-KANDIDATEN v4.4; 1001-1220 = AENDERUNGSLOG).