# Konsolidierte Sammelstrecke 'trans-spaet' — Vollaudit

Konsolidierer: 'trans-spaet' des Vollaudits (Kontrollblock-Zweig, Session 5a19728e).
Quellen: `leser-transkript-13.md` .. `leser-transkript-23.md` (11 Dateien), gelesen VOLLSTAENDIG
(jede Zeile jeder Datei, ueber alle Truncation-Grenzen hinweg per offset/limit nachgeholt).
Jede Quelldatei deckt ein EXKLUSIVES, chronologisch AUFSTEIGENDES Zeitfenster des
Session-Korpus ab (Transkript 13 = fruehestes Fenster dieses Segments — KONTEXT-FENSTER 18,
10.08. vormittags —, Transkript 23 = spaetestes/letztes Fenster — KONTEXT-FENSTER 47-50,
20.08., endet mit dem Owner-Auftrag, der dieses Vollaudit selbst ausloest). Innerhalb jeder
Datei ist der Inhalt ebenfalls chronologisch aufsteigend (weiter unten = spaeter).

## Methodik der Deduplizierung

Programmatisch (nicht rein manuell) durchgefuehrt, um bei ~4700 Rohzeilen ueber 11 Dateien
belastbar und nachvollziehbar zu bleiben (Skript `dedup_transspaet.py` im selben Ordner):

1. **Rohextraktion**: alle Markdown-Tabellenzeilen aus den 11 Quelldateien geparst (Header-
   /Trenn-/Leerzeilen sowie narrative "Gelesen: Block N"-Zwischenueberschriften ausgeschlossen).
   Ausnahmefall: 9 von 4668 Rohzeilen enthielten in der Quelle selbst unescapte `|`-Zeichen
   in Fliesstext (Grammatik-Notation wie `c|g|f|n`, Shell-Pipes, sed-Ausdruecke) — dafuer
   wurde ein Recovery-Verfahren angewendet (Spalte 2 muss auf eine gueltige Klasse
   AUFGABE/REGRESSION/FEATURE/OWNER-ENTSCHEID/UNKLAR passen, sonst gelten die letzten vier
   Segmente als Klasse/Quelle/Status/Traeger und der Rest bleibt im KUERZEL-Freitext); alle
   4534 Ausgabezeilen wurden anschliessend strukturell verifiziert (exakt 6 Felder/Zeile).
2. **Exakte Duplikate**: normalisierter KUERZEL-Text (Kleinschreibung, Sonderzeichen entfernt)
   identisch ueber mehrere Quellen -> EINE Gruppe.
3. **Namens-Varianten / wiederkehrende Gegenstaende**: Wortueberlappung (Jaccard) auf
   inhaltstragenden Woertern DES KUERZEL-Felds, NUR ueber Dateigrenzen hinweg (gleiche Datei
   = bewusst getrennter Arbeitsschritt, nicht zusammengefuehrt), mit zwei Schwellen
   (min. 3 gemeinsame Woerter bei Jaccard>=0.6, oder min. 2 bei Jaccard>=0.75); zusaetzlich
   ein ID-verankerter Kanal fuer explizite Kennungen (Task #N, KONn, S-NNa, VL-N, T-Nb,
   Commit-SHA), der bei geteilter Kennung + gemeinsamen Inhaltswoertern etwas grosszuegiger
   greift (Jaccard>=0.25, min. 2 gemeinsame Woerter) — damit werden z. B. "Task #72
   queuing-Umzug" oder "KON119" ueber ihre gesamte Fortschritts-Historie hinweg auf EINE
   Zeile zusammengefuehrt.
4. **Sicherheitsventil gegen Fehlketten**: Union-Find-Gruppen sind auf max. 9 Mitglieder
   gedeckelt; ein erster ungedeckelter Lauf hatte via schwacher transitiver Verkettung eine
   243 KON-Ledger-Eintraege umfassende Fehl-Gruppe erzeugt (Stichprobe ergab: voellig
   verschiedene Gegenstaende, die nur einzelne generische Woerter teilten) — nach Einbau des
   Deckels und Verzicht auf die zu laxe Ein-Wort-ID-Regel wurde jede der 86 Mehrfach-Gruppen
   stichprobenartig gegengelesen (u. a. gezielt auf die Task-Nummern-Kollision gegen die im
   Korpus dokumentierte Task-Tracker-Reset-Stelle vom 10./11.08. geprueft — dort keine
   Fehlvermischung gefunden, da betroffene Nummern nur innerhalb derselben Epoche matchen).
5. **Status bei Konflikt**: die Zeile des Gegenstands zeigt den Status der JUENGSTEN Quelle
   (hoechste Transkript-Nr., bei gleicher Datei hoehere Zeilenposition). Weicht der Status
   einer AELTEREN Quelle im selben Gegenstand vom finalen Status ab, wird das NICHT still
   verworfen, sondern im Statusfeld als `⚠ STATUS-VERLAUF/vorher: <alter Status> (T<n>)`
   angehaengt — das deckt sowohl echte Konflikte als auch normale Fortschritts-Historie
   (OFFEN -> GEBAUT -> GELANDET -> CI-BEWIESEN) einheitlich sichtbar ab.
6. **Sortierung**: nach Erstauftreten (aelteste Quelle zuerst), um den narrativen Fluss der
   Session so weit moeglich zu erhalten, statt die 4534 Zeilen thematisch neu zu wuerfeln.
7. **Spalte 'Quellen'**: alle beitragenden Transkripte eines Gegenstands, z. B. `T18, T19, T21`
   (T = Transkript-Nummer 13-23). Die bestehende Spalte 'Quelle (Z-Anker/Abschnitt)' bleibt
   die Original-Quellenangabe der JUENGSTEN (repraesentativen) Zeile; wurde der Gegenstand
   in einer AELTEREN Datei zuerst erwaehnt, ist das zusaetzlich als
   `[orig. zuerst: T<n>]` vermerkt.

Was NICHT automatisch zusammengefuehrt wurde, bleibt als eigene Zeile stehen — das ist der
weit ueberwiegende Teil der Tabelle: die 11 Quelldateien sind ueberwiegend disjunkte
Zeitfenster desselben Arbeits-Marathons, entsprechend beschreibt die grosse Mehrheit der
Zeilen tatsaechlich unterschiedliche, nicht wiederkehrende Einzelfakten (Owner-Zitate,
CI-Laeufe, Commits, Einzelregressionen) und keine Duplikate.

## Konsolidierte Tabelle

