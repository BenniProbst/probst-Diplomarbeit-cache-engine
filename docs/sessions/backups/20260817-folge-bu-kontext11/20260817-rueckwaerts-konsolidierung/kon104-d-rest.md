# RUECKWAERTS-KONSOLIDIERUNG: KON104 D-GRUPPE — D-1, D-3, D-6, D-7, D-10

**Cluster-Abgrenzung:** bearbeitet D-1/D-3/D-6/D-7/D-10 aus KON104-01/-02 (Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:117-150`). D-2/D-5/D-8/D-9 bewusst ausgelassen (laufen in F2/F3/F6/F5). Primärquellen: Ledger (30693 Z., neueste oben), `docs/sessions/20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md` (die "20er-Vorlage", auf die KON104 antwortet — enthält STAND/EMPFEHLUNG/WENN-OFFEN je Frage), `docs/sessions/backups/20260817-drift-konsolidierung-rohdaten/rest_karte_r{1,3,5}.md`, `docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md`, sowie Objekt-Gegenproben gegen ce `@04ac26fa` und thesis `@c169fd2` (beide READ-ONLY, development).

---

## D-1 — XML-Wache: volle Wohlgeformtheit als Ziel, deklarierte Grenze nur Übergang

**VORGESCHICHTE (mit Fundstellen):**
- **08.08.2026 nachts** (Ledger:18234-18248): XML-Wohlgeformtheits-Wache erstgebaut, ce `25fe4fbf` (160 XML/0 defekt, Köder 161. Datei rot mit Zeilennummer, ctest 429/429) + super `4a9d3d02` (66 XML/0). Das Script selbst (`Code/external/comdare-cache-engine/scripts/ci_xml_wellformed_guard.sh:4-15`, live gelesen) dokumentiert im Kopf: an diesem Tag waren fünf getrackte XML-Dateien — darunter `all_axes_golden.profile.xml` — wegen `--` in Kommentaren nicht wohlgeformt und wurden geheilt.
- **09.08.2026, 12:49** (KON3-03, Ledger:11495-11517, Herkunft AB, Transkript `5a19728e` L24190): Selbstmeldung des Bauenden: "grep-Zweig (nicht auslösbar ohne root) und Nenner-Mismatch-Zweig (nachweislich unbeobachtbar, Mutant überlebt)". Nachfrage 12:53 (L24236) "ist eine unbeobachtbare Zweighälfte überhaupt zulässig?" — **im Transkript nie beantwortet.**
- **11.08.2026 nachts** (KON9, Überschrift Ledger:9914; KON9-09 bei Ledger:10145-10164), Owner-Wort F2: *"Es braucht also je Achsen-Kategorie die von mir definiert freigegebene Syntax und Semantik, die jeweils nach den beschriebenen Regeln über c hinausgeht. Das ist Pflicht und Basis für die Abgabe."* — generelle Testbarkeitsdoktrin, **zu diesem Zeitpunkt nicht mit KON3-03 verknüpft.**
- **11.08.2026 nachts, später** (KON13, Überschrift Ledger:9185; KON13-03 bei Ledger:9255-9278): G-1/G-2-Grammatik-Trennung, Owner-Auftrag "G-2 ... die Semantik nachholen, in Reihenfolge der Achsen-Nummerierung" — wieder ohne Bezug zur Wache.
- Wellenplan-Posten **D-21** (`docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md:2428-2430`, Bündelung der beiden 11.08-Zitate, nachgetragen zum 08.08-Ur-Dokument): "Syntax UND Semantik je Achsen-Kategorie über c hinaus ... -> W4-Pflicht + nach F5" — ebenfalls ohne KON3-03-Bezug.
- **16.08.2026** (KON96-03(a), Ledger:702-706): Ledger-Gegenlese führt KON3-03 explizit als eine von genau drei verbleibenden echten Owner-Fragen, "seit Wochen unbeantwortet" — weiterhin isoliert von D-21/KON9-09.
- **17.08.2026**, Vorlage D-1 (`docs/sessions/20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md:183-200`): EMPFEHLUNG "deklarierte Grenze" (beide blinden Zweige bleiben, Ausgabe nennt geprüften/ungeprüften Anteil) — **ohne Bezug auf KON9-09/D-21/KON13-03 im STAND.**

**DELTA der heutigen Antwort** (Ledger:118-119, 127-130): Der Owner verknüpft selbst, was acht Tage lang getrennt blieb — er zitiert KON9-09 fast wörtlich ("Die gesamte Syntax und Semantik muss prüfbar sein") und erklärt damit KON3-03 zu einer *Instanz* der generellen D-21-Doktrin, nicht zu einem isolierten CI-Feinschliff. Zwei Präzisierungen gegenüber Vorgeschichte UND Lead-Empfehlung: (1) zeitlich — "deklarierte Grenze" wird ausdrücklich zum **Übergang**, nicht zum akzeptierten Dauerzustand (die Empfehlung ließ das offen); (2) sachlich — Zielgröße ist nicht "zwei bekannte Zweige reparieren", sondern die gesamte Syntax-UND-Semantik-Kette, was den heute noch offenen Task #17 (G-2-Semantik) mit einschließt.

**UEBERHOLT-Marker-Liste:**
1. Ledger:11507-11509 (KON3-03, unbeantworteter Nachprüf-Auftrag 09.08. 12:53) → Marker "BEANTWORTET 17.08. (KON104-01/-02): volle Wohlgeformtheit ist Ziel, deklarierte Grenze nur Übergang."
2. Ledger:704-706 (KON96-03(a), "seit Wochen unbeantwortet") → derselbe Marker; von den dort drei offenen Fragen sind mit KON104 jetzt zwei zu (D-1 hier, D-3 s.u.; die dritte, K4/Kurven-Stack = D-2, außerhalb dieses Clusters).
3. `docs/sessions/20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md:194-197` (D-1-EMPFEHLUNG "deklarierte Grenze") → Marker: durch Owner-Antwort nur als Übergang bestätigt, nicht als Endzustand.
4. **Objektbefund, unabhängig von der Owner-Antwort:** Ledger:631-635 ("OFFENE GOLDEN-NACHPOSTEN ... (a) all_axes_golden.profile.xml nicht wohlgeformt -- drei '--' beseitigen + Flag PROFILE_ALLOW_COMMENT_TEXT_DEFECT entfernen (r3 A12)") sowie die Quelle `docs/sessions/backups/20260817-drift-konsolidierung-rohdaten/rest_karte_r3.md:122` und Task #16 ("Rest: 3 golden-Nachposten ... all_axes-Wohlform") sind **STALE**. Live-Gegenprobe heute (ce HEAD `04ac26fa`): `xmllint --noout` meldet WELLFORMED, 0 eingebettete `--` außerhalb der Kommentargrenzen in `libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml`; `grep -rn PROFILE_ALLOW_COMMENT_TEXT_DEFECT` über den ganzen ce-Baum = 0 Treffer (Flag wurde nie gebaut, weil nie gebraucht); letzter Commit auf der Datei ist `4a26b6a3` (10.08., unrelated DURCHSTICH-Test). Das deckt sich mit dem Wache-Kommentar selbst, der die Heilung dieser Datei auf den 08.08. datiert. Vermutliche Ursache: Vendoring-Drift (dieselbe Fallenklasse, die der Ledger selbst bei :17437-17441 dokumentiert — der vendorierte ce-Stand in super kann Dutzende Commits hinter dem echten HEAD liegen).

**Fehlende Bau-Folgen:** KON104-02 bucht D-1 nur pauschal als "Bauposten im W2-Umfeld (XML-Wachen-Strecke)". Nicht erfasst: (a) die jetzt explizit erhöhte Bindung an Task #17 (G-2-Semantik, weiterhin PENDING) — "gesamte Syntax UND Semantik" verlangt beide Baustellen unter einem Ziel, sonst beansprucht D-1 fälschlich Vollständigkeit, sobald nur die Wache repariert ist; (b) der grep-Zweig (root-Pfad) braucht ein bislang nirgends skizziertes Testdesign (Root-Simulation ohne echten root), das die Owner-Antwort implizit mitfordert; (c) der unter Punkt 4 genannte Fehlbefund sollte, falls bestätigt, aus dem #15-Bruch-Bündel gestrichen bzw. auf "bereits erledigt" umgebucht werden, sonst wird Arbeitszeit auf einen nicht mehr existierenden Defekt verwendet.

---

## D-3 — Registration-Token instanzweit abschalten

**VORGESCHICHTE:**
- Ur-GO für **projektweise** Rotation, referenziert an Ledger-Anker "Z.35912" (Ledger:697-699, :8040-8046 unter "NACHTRAG 12.08.2026 — KON22", Zeile 8004): *"volles GO"* für Rotation der sieben CI/CD-Variablen **und** der 776 Runner-Registration-Token via `reset_registration_token` **je Projekt**. Anmerkung: der Anker "Z.35912" liegt außerhalb des heutigen 30693-Zeilen-Dokuments — stale Zeilenanker (dieselbe Klasse, die KON105-04 bereits für andere Anker als "V14: Anker über Abschnitt, nie Zeile" korrigiert).
- **13.08.2026** (KON58-04, Ledger:3875-3907, unter "NACHTRAG 13.08.2026 — KON58"): Befund 3 der MinIO-Scrub-Nachforschung — die Instanz akzeptiert Registration-Tokens weiterhin (`allow_runner_registration_token=true`); "776" ist **keine** Projekt-/Runner-ID, sondern die Zahl der gitleaks-Treffer (RuleID `gitlab-rrt`) im Backup-Suchlauf; "der Reset-Weg ist ein Owner-Entscheid (je Projekt zurücksetzen vs. instanzweit abschalten)" (Ledger:3906-3907). Präzisierung an anderer Ledger-Stelle (Ledger:23265-23271): die 776 Roh-Treffer = 1552 Klartext-Vorkommen (776×2 Ausgabezeilen je gitleaks-Fund), daraus **390 tatsächlich verschiedene** Tokens (Präfix `GR1348941`) — 776 ist also weder Projektzahl noch Token-Zahl, sondern reine Fundzahl.
- Wellenplan **D-19** (`docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md:2422-2423`): bündelt "Registration-Token-Reset = Owner-Entscheid" mit `COMDARE_NFS_DROP_TOKEN fehlt` und `CE_SUBMODULE_TOKEN fehlt` unter "Infra-Reste" — ohne A12/D-10 beim Namen zu nennen (siehe dort).
- **16.08.2026** (KON96-03(c), Ledger:711-712): dieselbe Frage als eine von drei verbleibenden echten Owner-Fragen geführt.
- **17.08.2026**, Vorlage D-3 (`...OWNER-VORLAGE...md:220-235`): stellt die Frage explizit als "MECHANIK-Frage" von der "TIMING-Frage" (=A-1, sofortige Rotation der geleakten Tokens) getrennt; EMPFEHLUNG "instanzweit abschalten".

**DELTA:** Die heutige Antwort ("Wie empfohlen") ist qualitativ radikaler als der eigene Alt-Stand des Owners: das frühere "volles GO" (Z.35912) trug **nur** projektweise Rotation; heute ersetzt der Owner das Mechanismus-Modell komplett (Registration-Tokens instanzweit AUS, Umstieg auf Runner-Authentication-Tokens) statt es nur zu wiederholen. Damit wird die alte A-1-Rotation zur **Übergangsmaßnahme vor** dem Mechanismuswechsel, nicht zu einer gleichrangigen Alternative — diese Rangfolge steht so weder in KON58-04 noch in der Vorlage explizit.

**UEBERHOLT-Marker-Liste:**
1. Ledger:711-712 (KON96-03(c)) → Marker "BEANTWORTET 17.08. (KON104, D-3): instanzweit abschalten."
2. Ledger:3906-3907 (KON58-04, Ursprung der offenen Frage) → derselbe Marker, am Ursprungsort.
3. Wellenplan D-19 (`...WELLENPLAN...md:2422-2423`) → Bullet "Registration-Token-Reset = Owner-Entscheid" braucht Verweis auf KON104; **Rest des Bullets (COMDARE_NFS_DROP_TOKEN/CE_SUBMODULE_TOKEN) bleibt unverändert offen** — nicht mitbeantwortet.
4. `docs/sessions/20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md:235` (D-3 "WENN OFFEN: A-1 rotiert dann je Projekt, der billigere, aber wiederholbare Weg") → Marker: A-1-Rotation bleibt zwar gültig (eigene Timing-Frage), aber nicht mehr als möglicher **Dauer**-Mechanismus zu lesen.

**Fehlende Bau-Folgen:** KON104-02 (Ledger:134-136) bucht nur "An Infra übergeben ... sinnvoll im selben Wartungsfenster wie die A-1-Rotation" — ohne (a) die Abhängigkeit zu Task #54s offenem Rest "Talos-CA-Trust = eigener Infra-Posten" und zum runner-mode-v3-Tooling (Task #60) zu nennen, die beide vom Registrierungsmechanismus berührt sein könnten; (b) die 776-vs-390-Präzisierung in die Infra-Meldung zu übernehmen, damit dort nicht die falsche Zahl als Nenner läuft; (c) COMDARE_NFS_DROP_TOKEN/CE_SUBMODULE_TOKEN (D-19, identisches Wartungsfenster, siehe D-10) explizit mit in denselben Fenster-Slot zu ziehen, statt sie separat treiben zu lassen.

---

## D-6 — p50/p95/p99-Altzahlen markieren, später neu erheben

**VORGESCHICHTE:**
- **09.04.2026, Termin 3** (Owner-Primärquelle, Ledger:17660-17665, nie widerrufen, 06.08. im KANON-Plan erneut katalogisiert): *"Perzentile werden nicht gemittelt. Je Lauf werden HDR-Histogramme persistiert; Auswertung erfolgt auf den separaten Rohläufen oder über korrekt zusammengeführte Histogramme."* — das ist der **älteste** Faden dieses Clusters, gut 19 Wochen vor heute.
- **09.08.2026** (D5-1-Landung, Ledger:17368-17442, ce `c98b4b95`): Perzentil-Kanon `ceil(q*n)-1` (Hyndman/Fan Typ 1) gebaut, `nearest_rank_p` ersatzlos gelöscht.
- **09.08.2026, derselbe Nachtrag**, K1 (Ledger:17647-17681): Befund "Thesis ist beim Median-Mechanismus intern zweistimmig — Hauptkapitel HDR (`aufgabenstellung/de.tex:130`, `05_evaluation.tex:129`), Anhang nearest-rank (`A_measurements.tex:46-49`, `bias_matrix_table.tex:2`)". Ist-Zustand: `latency_hdr_histogram.hpp` hat **null Produktionskonsumenten** (nur der eigene Unit-Test inkludiert es). Wellenplan-Konsequenz D5-5 wurde von "entscheiden" zu "HDR verdrahten + Je-Lauf-Persistenz + 0-ns-Zähler + Toleranz" verschärft.
- **09.08.2026, K3, derselbe Nachtrag** (Ledger:17683-17693) — die direkte Ur-Formulierung der D-6-Frage: *"D5-1 vermerkt 'alle vorher erhobenen p50/p95/p99 ungültig'. Im lebenden Thesis-Anhang stehen genau solche Zahlen ... unmarkiert als gültig ... Wie diese Kollision aufzulösen ist — markieren oder neu erheben —, ist nirgends festgelegt ... gehört auf die Liste bis zum 15.09."*
- `rest_karte_r1.md` Item 22 (Z.17126-17139, 09.08.): benachbarter, bislang unverbuchter Nebendefekt — `LATENCY_P95` ist deklariert, aber **nicht in der CSV exportiert**.
- **17.08.2026**, Vorlage D-6 (`...OWNER-VORLAGE...md:277-292`): EMPFEHLUNG "Markieren, nicht neu erheben ... Binnendifferenz HDR-vs-nearest-rank löse ich GETRENNT im Thesis-Sync auf; Definitionsfrage, keine Datenfrage."
- **17.08.2026** Owner (Ledger:120-121): "Wie empfohlen, wir müssen sie später neu erheben."

**Objekt-Gegenprobe heute** (thesis HEAD `c169fd2`): `anhang/de/A_measurements.tex:49` trägt weiterhin unverändert "ns/op, nearest-rank" — die Kollision besteht am Objekt unverändert fort, die Owner-Antwort ist also gegen den aktuellen Stand zutreffend formuliert.

**DELTA:** Der Owner bestätigt nur den ersten Teil der Empfehlung ("markieren"), fügt aber "wir müssen sie später neu erheben" als **eigenen, verpflichtenden** Halbsatz an — die Empfehlung hatte Neuerhebung nur als Begründung genutzt ("die Neuerhebung kommt mit der Kampagne ohnehin"), nicht als Auftrag formuliert. Der Owner macht daraus eine Pflicht. Das verknüpft D-6 sachlich mit D-7 (dieselbe Datei, dieselbe Kampagnen-Abhängigkeit) und mit dem noch offenen Wellenplan-Posten D5-5 (HDR-Verdrahtung), was weder Vorlage noch KON104-02 ausspricht: ohne HDR-Verdrahtung vor der Kampagne würde "neu erheben" nur alte nearest-rank-Zahlen durch neue nearest-rank-Zahlen ersetzen — die Binnendifferenz bliebe bestehen.

**UEBERHOLT-Marker-Liste:**
1. Ledger:17691 ("Wie diese Kollision aufzulösen ist ... ist nirgends festgelegt") → Marker "BEANTWORTET 17.08. (KON104, D-6): markieren jetzt, neu erheben mit der Kampagne (owner-verpflichtend)."
2. `anhang/de/A_measurements.tex:46-49` + `anhang/de/tabellen/bias_matrix_table.tex:2` (und EN-Pendants) selbst — tragen die vom Owner für ungültig erklärte Größe **weiterhin unmarkiert**; das ist der eigentliche Ausführungsrückstand, kein reiner Buchungsrückstand.
3. `rest_karte_r1.md` Item 22 (Z.17126-17139, p95-CSV-Export-Lücke) — nicht Teil der D-6-Antwort, braucht eigenen Marker/Posten, sonst fällt er zwischen die Buchungen.

**Fehlende Bau-Folgen:** KON104-02 (Ledger:141-142) bucht D-6 nur als "Thesis-Anhang-Posten". Fehlt: (a) die konkrete Markierungsarbeit an den genannten Dateien/Zeilen; (b) die Voraussetzung, dass Wellenplan-D5-5 (HDR-Verdrahtung, aktuell 0 Produktionskonsumenten) VOR der Kampagne steht, sonst ist "neu erheben" wirkungslos gegen die Binnendifferenz; (c) die p95-CSV-Export-Lücke als Voraussetzung jeder p95-Neuerhebung. Die von der Vorlage explizit ausgeklammerte "Binnendifferenz HDR-vs-nearest-rank" (→ "Thesis-Sync") hat aktuell keinen benannten Folgetermin außer dem allgemeinen Task #77 (Thesis-Audit-Einarbeitung, nach F2 Fr 21.08.) — dort nicht ausdrücklich referenziert.

---

## D-7 — Anhang A bei 16/44 (Weg 1) + Nacharbeit

**VORGESCHICHTE:**
- **07.08.2026 morgen-1** (Ledger:25727-25753, Punkt 4 bei :25745-25747) — die fast wortgleiche Ur-Formulierung: *"B-5a / O-4 Anhang-A-Reichweite: OFFEN. Anhang A deklariert je Sprache 44 Fragmente, davon 16 mit echten Messdaten belegt, 28 leer ... Lead-Empfehlung Weg 1 ... liegt vor, KEINE Owner-Freigabe; die 'NACH-Abgabe'-Prämisse ist durch die Termin-Korrektur auf 15.09.2026 widerlegt und laut Checkheft C-3 neu zu stellen."* — zehn Tage älter als die 17.08-Vorlage.
- Ursache der Terminkorrektur, noch eine Stufe älter: **06.08.2026 abend-1**, N-1 (Ledger:23302-23370), Owner-Zitat (Ledger:23344-23351): *"FRIST-KORREKTUR: Endtermin ist der 15.09.2026, mit wöchentlicher Lieferung jeden Freitag"* (`20260806-KONTEXTUEBERGABE-abend-praezise.md:67`, gleichlautend `ARBEITSWEISE-GESAMT-DOKTRIN.md:359`).
- Zwischenzeitliche Objektbewegung, NICHT statisch: 12.07. CI-Schleife mit initial 16 `\InputIfFileExists`-Blöcken (Ledger:19337, 19044); 14.07. ein 17. Block (observer_detail, Ledger:19013, 19877); später "GRAPH-UMBAU KOMPLETT" mit 23 neuen Abbildungen, Zähler wandert ausdrücklich "16 -> 29" (Ledger:25198).
- **08./11.08.2026** (KON6-07/6-08, Ledger:11076-11104, unter Überschrift Ledger:10854 "NACHTRAG 11.08.2026 — KON6", Fundtext datiert sich selbst auf 08.08.): Zähl-Diskrepanz "Wellenplan nennt 28, echter Klon zeigt 13" — "vor dem F5-Anhang-Gate zu klären".
- **Nummern-Kollision, präzise benannt:** KON104-02 selbst (Ledger:143-144) schreibt "Koppelt an KON58-13 (28-vs-13)" — das ist **falsch verankert**. Die formal überschriebene `### KON58-13` (Ledger:4231-4285, unter "NACHTRAG 13.08.2026 — KON58") behandelt den Stempel-Riegel/Overlay-Schnitt (158→718 Records) und hat mit Anhang A nichts zu tun. Der "28-vs-13"-Fund gehört zu KON6-07/6-08 (08./11.08.), nicht zu KON58-13 (13.08.). Beide tragen zufällig verwandte Nummern ("58"/"6-08" vs. "58-13"), sind aber inhaltlich fremd — exakt die von meiner Aufgabenstellung benannte Fallenklasse.
- Weitere Zwischenwerte für denselben Gegenstand, chronologisch: 31 (Ledger:25847, 07.08., andere Ausbaustufe) und DE=30/EN=30 (Ledger:27223, ~15./16.08.).
- **17.08.2026**, Vorlage D-7 (`...OWNER-VORLAGE...md:294-309`), reproduziert exakt 44/16/28, EMPFEHLUNG "Weg 1".
- **17.08.2026** Owner (Ledger:121-122): "Genau wie empfohlen, wir müssen hier nacharbeiten [Tippfehler im Original: 'muessenhier']."

**Objekt-Gegenprobe heute** (thesis HEAD `c169fd2`, `anhang/de/A_measurements.tex`): exakt 28 vollständige `\InputIfFileExists{...}` + 16 harte `\input{...tabellen...}` = 44 Fragmente gesamt; 0 der 28 Zieldateien liegen auf der Platte. **Anders als bei D-1 ist die 44/16/28-Zahl objektseitig aktuell und korrekt** — die früheren 13/28(Plan)/31/30-Werte waren Messungen zu früheren, kleineren Ausbaustufen desselben wachsenden Anhangs, kein echter Widerspruch.

**DELTA:** Wie bei D-6 fügt der Owner einen verpflichtenden Halbsatz an, den die Empfehlung nur als mögliche Konsequenz nannte: "Weg 1" (ursprünglich "bei 16/44 bleiben") wird durch "wir müssen hier nacharbeiten" zum **Übergangszustand statt Dauerzustand** — dieselbe Musterfigur wie bei D-1 ("nur als Übergang") und D-6 ("müssen neu erheben"). Diese Drei-fache Wiederholung derselben Owner-Figur (vorläufig akzeptieren, Nacharbeit ist Pflicht) über D-1/D-6/D-7 hinweg ist selbst ein Delta-Befund gegenüber der Ledger-Buchung, die die drei Antworten bisher nicht als zusammengehörige Familie führt.

**UEBERHOLT-Marker-Liste:**
1. Ledger:25747 ("Anhang-A-Reichweite: OFFEN ... KEINE Owner-Freigabe") → Marker "BEANTWORTET 17.08. (KON104, D-7): Weg 1 MIT Nacharbeitspflicht."
2. `...OWNER-VORLAGE...md:304-307` (D-7-EMPFEHLUNG) → Marker: Owner-Antwort geht über die Empfehlung hinaus (Nacharbeit jetzt Pflicht, nicht Kann-Option).
3. **Ledger:143-144 (KON104-02 selbst)** → Zitat-Korrektur nötig: "KON58-13 (28-vs-13)" → richtig wäre KON6-07/KON6-08 (Ledger:11076-11104).
4. Ledger:25847 ("31 gegatete") und Ledger:27223 ("DE=30, EN=30") → kein Fehlermarker nötig, aber "Stand-vom"-Vermerk, damit sie künftig nicht gegen die aktuelle 44/16/28-Zahl ausgespielt werden (dieselbe Fallenklasse wie der im Ledger selbst dokumentierte D5-3-Zeilendrift).

**Fehlende Bau-Folgen:** KON104-02 (Ledger:143-144) bucht D-7 nur als "Thesis-Anhang-Posten, gekoppelt an W3" — benennt weder die 28 Zieldateien/8 Zielabschnitte noch die Pflicht-Reihenfolge (Kampagne muss vor finaler PDF-Regenerierung laufen). Es fehlt ein sichtbarer Abgleich zwischen dem Kampagnenplan (S-19-Planungssimulation, Task #7) und der konkreten Liste der 28 Anhang-A-Fragmente. D-6 und D-7 teilen denselben physischen Träger (`A_measurements.tex`/`bias_matrix_table.tex`) und sollten als **ein** gemeinsamer Regenerierungs-Bauposten geführt werden (derselbe CI-Lauf measure→Anhang-Regen→persist, Ledger:19337), nicht als zwei getrennte Buchungen wie aktuell.

---

## D-10 — NAS-Creds A12/E-14 ausgebucht → COMDARE_NFS_DROP_TOKEN

**VORGESCHICHTE:**
- Ur-Quelle **02.08.2026**: `docs/sessions/20260802-KATALOG-offene-strecke-gesamtplan.md:28`, wörtlich (Ledger:23635-23637): *"A12 | NAS-Creds backup1/backup2 (E-14) | Zugangs-/Mount-Strecke für die Mess-CSV-Ablage -- trigger-nah, stand bis zur Inventur in KEINER Paketliste; neben A1/G-E7 einplanen | offen."*
- "nachmittag-11" (C/a-5, Datum in dieser Runde nicht separat verifiziert, vor 06.08.): A12 erstmals im Ledger, "im Register 0". **Fallenwarnung bestätigt:** 17 von 18 Roh-Treffern für "A12" sind Substring-Treffer im golden-CRC-Anker `0xF1C1F26A1232073B` — Namenskollision, wie in meiner Aufgabenstellung vorhergesagt.
- **06.08.2026** (Ledger:23836-23841, (a-5)): Codex-Gegenlauf — "KEIN echter Vor-Trigger-Anspruch ... vor der Abgabe klären, nicht vor dem Trigger."
- **13.08.2026** (KON58-04, Ledger:3901-3907): A12/E-14 taucht als Nebenbefund einer anderen Untersuchung (MinIO-Scrub) wieder auf — hier entsteht erstmals die Verbindung A12 ↔ `COMDARE_NFS_DROP_TOKEN` ("fehlt in 288, Ebene C bleibt inert"), die D-10s Empfehlung später trägt.
- Wellenplan **D-19** (`...WELLENPLAN...md:2422-2423`): bündelt COMDARE_NFS_DROP_TOKEN mit CE_SUBMODULE_TOKEN und dem D-3-Registrierungsthema, nennt A12 aber nicht beim Namen.
- **17.08.2026**, `rest_karte_r5.md:673-681` (A76, Quelle der Vorlage) sowie inhaltsgleich Ledger:28596-28599: *"das Skript ist deprecatet -- die METHODE (rohe UNC/SMB-Kopie), nicht das ZIEL. Spätere Dokumente referenzieren PR4100 weiterhin aktiv, über den CI-WRITE-Token-Weg."*
- **17.08.2026**, Vorlage D-10 (`...OWNER-VORLAGE...md:348-363`): EMPFEHLUNG "Als erledigt ausbuchen und in den COMDARE_NFS_DROP_TOKEN-Posten überführen -- derselbe Gegenstand unter anderem Namen." Ausdrücklich mit Rückfrage-Klausel: "Wenn du das anders siehst, sag es; dann bleibt A12 als eigener Release-Checklisten-Posten stehen."
- **17.08.2026** Owner (Ledger:123-124): "Ist erledigt, ausbuchen."

**DELTA:** Die Owner-Antwort ist **kürzer** als die Empfehlung und bestätigt wörtlich nur die Ausbuchung — er wiederholt die vorgeschlagene Überführung in den COMDARE_NFS_DROP_TOKEN-Posten **nicht** explizit. KON104-02 (Ledger:149-150, "Gegenstand lebt als COMDARE_NFS_DROP_TOKEN-Posten weiter") interpretiert das als volle Zustimmung — plausibel, aber nicht wörtlich gedeckt: die Vorlage sah für diesen Fall zwei explizite Antwortpfade vor ("überführen" oder "eigener Posten bleibt stehen"), keinen impliziten Default bei knappem Schweigen. Das ist der zentrale Delta-Befund dieses Punkts: die Buchung geht über das wörtliche Owner-Wort hinaus.

**UEBERHOLT-Marker-Liste:**
1. Ledger:23643-23645 ("OFFENE OWNER-FRAGE (unverändert): gilt A12 noch...") → Marker "BEANTWORTET 17.08. (KON104, D-10): erledigt, ausgebucht."
2. Ledger:23723 (Tabellenzeile N-10) → derselbe Marker an der tabellarischen Fundstelle.
3. Ledger:28598-28599 ("A12/E-14 ... ist heute noch offen") → derselbe Marker.
4. **Wichtig, Verwechslungsgefahr:** Wellenplan-D-19-Bullet "COMDARE_NFS_DROP_TOKEN fehlt" bleibt **unverändert gültig** — das ist NICHT Teil dessen, was D-10 als erledigt erklärt. Erledigt ist nur die alte Methode/Frage; das fehlende Token selbst ist am Objekt unverändert seit der letzten Messung (KON58-04, 13.08.) offen. KON104-02s Formulierung könnte fälschlich als "auch der Token-Status ist geklärt" gelesen werden — ist er nicht.

**Fehlende Bau-Folgen:** Kein eigener Bauposten für D-10 selbst korrekt (reine Ausbuchung). Aber: `COMDARE_NFS_DROP_TOKEN` taucht auf der aktuellen Task-Liste **nicht als eigener, nummerierter Posten** auf (nur als Nebenerwähnung in Task #48s Klammertext) — die Ausbuchung von A12 darf nicht dazu führen, dass der Nachfolgegegenstand mangels eigenem Posten aus dem Blick fällt (genau die von der eigenen Doktrin benannte Fehlerklasse: "ein Posten ohne Gegenstand bleibt bis zur Abgabe in der Liste" / "Lücke = Behebung ist immer Pflicht"). `CE_SUBMODULE_TOKEN` (identischer KON58-04-Befund-Kontext) teilt dasselbe Schicksal. Beide sollten explizit in dasselbe Wartungsfenster gezogen werden, das KON104-02 für D-3/A-1 bereits vorschlägt — dort aber nur für D-3 formuliert.

---

## GEPRUEFT

Alle fünf zugewiesenen Entscheide (D-1, D-3, D-6, D-7, D-10) wurden mit Fundstellen-genauer Vorgeschichte (Datei:Zeile bzw. KON-Anker), explizitem Delta-Befund, benannten Überholt-Markern und benannten fehlenden Bau-Folgen bearbeitet. Vorgeschichtstiefe variiert ehrlich nach Gegenstand: D-6 reicht bis 09.04.2026 (Termin 3, ~19 Wochen), D-1/D-7 bis 07.-09.08. (~1,5 Wochen mit klaren älteren Wurzeln in derselben Bauwoche), D-3/D-10 bis 02.08.2026 (~2 Wochen). Zwei Objekt-Gegenproben gegen den heutigen Live-Stand durchgeführt (ce `xmllint` gegen `all_axes_golden.profile.xml` bei D-1 — Befund: STAND stale; thesis `\InputIfFileExists`/`\input`-Zählung bei D-7 — Befund: STAND aktuell korrekt). Eine Nummern-Kollision präzise lokalisiert und korrigiert (D-7: "KON58-13" in KON104-02 zeigt auf den falschen Konsolidierungs-Eintrag, richtig ist KON6-07/KON6-08). Ein stale Zeilenanker benannt (D-3: "Z.35912" liegt außerhalb des heutigen 30693-Zeilen-Dokuments). D-2/D-5/D-8/D-9 nicht angerührt, wie angewiesen.