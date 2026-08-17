# OWNER-VORLAGE 17.08.2026 -- FRAGENBUENDEL PARALLELSTART

**Datum:** 17.08.2026 (Mo) | **Zweck:** EIN Dokument fuer alle offenen ECHTEN Wahl-Entscheide, damit ein
kurzes Antwort-Fenster reicht | **Umfang:** 20 Fragen in 5 Gruppen nach Dringlichkeit.

**Wie das zu lesen ist.** Jede Frage steht in EINEM Satz, darunter STAND (was am Objekt belegt ist, mit
Datei/Zeile oder Karten-Anker), EMPFEHLUNG (mit Begruendung) und WENN OFFEN (was passiert, wenn keine
Antwort kommt). Wo eine Empfehlung steht, kannst du mit "ja" antworten -- dann faehrt sie so.

**Was hier NICHT drinsteht (Verweis).** Die Vorab-Entscheide des EINEN F2-Bump-Fensters (#15) -- Glied-FOLGE
und AxisKind-Ordnung, O-2 Preimage-Glieder A/B, G-5 RunMethodology-Enum,
AVX-512-in-golden samt der Provenienz-Haelfte no_extension-Cross-SKIP (r1 A-12a/b als Paar) -- liegen in
einem eigenen Dokument, `OWNER-VORAB-15.md`, das der parallel laufende Buendel-Explore liefert. Sie
gehoeren zusammen entschieden, weil sie EIN Byte-Ereignis teilen; sie hier zu zerreissen waere schaedlich.
*(NACHZUG 17.08., Buendel-Explore G7: die frueher hier mitgefuehrten VS-A..VS-F STOPP-Gates sind KEINE
offenen Entscheide mehr -- alle sechs sind seit 07.08. abend-23 owner-entschieden (E-A SHA-256/64 · E-B (i)
"Wir brechen golden-CRC!" · E-C mitziehen · E-D (a) · E-E/E-F gebaut); offen ist nur die AUSFUEHRUNG von
A/B/C/D, die als Bau-Posten im #15-Fenster faehrt. Der Wellenplan-Par.19.1-Zusatz "VS-A..VS-F offen" wird
im naechsten Plan-Zug entsprechend praezisiert.)*

**Wie aus 22 Kandidaten 20 Fragen wurden.** Deine Dauer-Direktive gilt: alles ist bereits entschieden, also
erst am Objekt belegen statt neu fragen. Zwei Kandidaten sind durch Objekt-Proben in dieser Runde
weggefallen (Abschnitt ZUR KENNTNIS) -- bei einem davon, der Lizenz-Tabelle, zeigte die Probe sogar, dass
die Karte die Richtung falsch herum hatte. Zwei Kandidaten habe ich zu einer Frage zusammengelegt (E-4),
weil sie zwei Haelften derselben Reichweiten-Frage sind. Und einen habe ich geteilt: der PMC-Block traegt
zwei verschiedene Entscheide (C-1 Mechanik, C-2 Textumfang), die man einzeln beantworten koennen muss.

**Quellen dieser Vorlage:** `docs/sessions/backups/20260817-drift-konsolidierung-rohdaten/` (Rest-Karten
r1-r5, Explore-Karten e1-e4, DOSSIER.md Par.19.6, LESE-SYNTHESE-kontext10.md) + Ledger-Kopf KON94-KON98.
Alle Karten-Anker unten loesen in diesem Ordner auf, nicht im tmp.

---

## GRUPPE A -- SOFORT / SICHERHEIT (2 Fragen)

### A-1 -- Token-Rotation 286/288/289: jetzt rotieren oder bei der A4-Pause?

**FRAGE:** Rotiere ich die Runner-Registration-Tokens der drei Projekte 286/288/289 sofort, oder bleibt es
bei deiner A4-Regel "Fortschritt geht vor, rotieren wenn fertig"?

**STAND:** Der Beleg ist neu und haerter als frueher gedacht. `outputs/bnpj776mm.output` enthielt 390
verschiedene Registration-Tokens im Klartext (Praefix `GR1348941`, 1552 Vorkommen), Herkunft
`projects_all.ndjson`/`group_projects.ndjson`, Feld `runners_token`, Commit `44820451` -- genau die Werte,
die der E23-Scrub vom 02.08. per filter-branch entfernt hat. Ein read-only Mengentest gegen die HEUTIGEN
Werte (ohne Klartext-Ausgabe) sagt literal fuer alle drei: "HEUTIGER TOKEN IST IN DER LECK-MENGE -> NICHT
ROTIERT" (r3 C11, `rest_karte_r3.md:440-460`). Der Scrub hat die SPUR beseitigt, nicht die WIRKUNG. Das
Original liegt in `~/backups-workflow/QUARANTAENE/` (0600), im Repo steht die `.REDACTED`-Fassung. Dein
"volles GO" fuer genau diese Rotation liegt bereits vor (Ledger Z.35912, `reset_registration_token` je
Projekt) -- vollzogen wurden davon nur die sieben CI/CD-Variablen, die Runner-Token nicht.

**EMPFEHLUNG:** Rotieren, und zwar jetzt -- aber als Ein-Punkt-Zug in einem eigenen seriellen Slot, nicht
parallel zu einem Workflow. Begruendung: A4 hat die Rotation aufgeschoben, als der Verdacht abstrakt war
("06.08.-Aera"); jetzt ist er ein Mengentest-Beleg. Wer einen dieser Token hat, kann einen Runner
registrieren, CI-Geheimnisse abgreifen und Code in die Bau-Kette bringen -- also genau in die Kette, die ab
26.08. die Messkampagne traegt. Der Zug selbst ist kurz (drei API-Calls plus Gegenprobe); die 387
Fremdprojekt-Token bleiben eine getrennte Frage und werden hier nicht angefasst.

**WENN OFFEN:** Ich lasse die Token stehen und trage sie als Vormerkung in die A4-Pausen-Liste ein. Die
Rotation wird dann teurer, weil sie nach dem 26.08. in eine laufende Kampagne faellt.

### A-2 -- `samba-comdare-socks-pw` in die Rotationsliste?

**FRAGE:** Nehme ich `samba-comdare-socks-pw` in die Rotationsliste auf, obwohl das Konto im Live-AD nicht
existiert?

**STAND:** Beim maskierten `sed`-Lauf geriet der Wert im Klartext ins Session-Transkript -- der Vault ist
eine Markdown-TABELLE, die Werte stehen in Spalten, und die positionsbasierte Regex griff 6 Zeichen statt
40 (r5 A74, `rest_karte_r5.md:659-666`). Entlastung, keine Entschuldigung: das Konto ist als
"2026-06-01 verifiziert" nicht existent in Live-AD. Der Ledger-Kopf fuehrt in der Rotationsliste heute nur
V8 (GitHub-PAT).

**EMPFEHLUNG:** Ja, aufnehmen -- als Vormerkung, nicht als Sofort-Aktion. Ein kompromittierter Wert bleibt
kompromittiert, auch wenn das Konto heute tot ist; ein spaeter wiederbelebtes Konto mit altem Passwort ist
genau der Fall, den eine Rotationsliste verhindern soll. Kosten: eine Zeile. Zusatzregel ist bereits
gezogen: ueber die LAENGE selektieren (`len:40`), nie ueber die Position.

**WENN OFFEN:** Der Wert steht in keiner Liste und faellt beim naechsten Rotationslauf durch.

---

## GRUPPE B -- FRIST MITTWOCH 19.08.2026 (1 Frage)

### B-1 -- #38a: darf die erste required-Deklaration den C-3a-Tripwire ausloesen?

**FRAGE:** Darf die Comp-Gate-Schicht (Festplatten-IO-Meta-Meta) den C-3a-Tripwire ausloesen und ihn durch
die echte per-Binary-Gate-Pruefung ersetzen, als eigenes Paket im EINEN W1-Bump-Buendel?

**STAND:** Die ausfuehrliche Vorlage liegt seit 13.08. mit Objekt-Belegen und deinem Wortlaut-Zitat des
Tripwires: `docs/plaene/20260813-OWNER-VORLAGE-c3a-comp-gate-paket-entscheid.md` (gelandet als `136a1798`).
Kern in einem Satz: `active_organ_required()` liefert heute hart `{}`, ein `static_assert` (ce
`libs/cache_engine/include/cache_engine/measurement/simd_build_gate.hpp:272-278`) macht die erste echte
required-Deklaration compile-hart ROT -- gewollt, bis dieser Entscheid vorliegt. Der Ersatz ist NICHT die
globale Vereinigung, sondern der im Tripwire selbst benannte Orchestrator-Weg
(`aggregate_required_for_axes`, per-Binary genau).

**EMPFEHLUNG:** JA -- ausloesen und ersetzen, gebuendelt mit Format 4->5, Layout 6->7 und den
Budget-Konstanten (#38d) als EIN Bruch (KON45-01/3 "ein Bruch statt zwei"). Vor F2/26.08. ist der Umbau
kostenlos, weil nie eine Flotte gebaut wurde; danach ist er ein Flotten-Preis.

**WENN OFFEN (das ist bereits geregelt, du musst nichts tun):** #38a2 faellt per Fallregel 18.6(3) ins
W2-Bump-Buendel, der FREEZE-CHECK Fr 21.08. bucht den deklarierten Fall. Der Tripwire bleibt stehen und
haelt jede required-Deklaration compile-hart auf; der Bump wandert hinter den Freeze, bleibt aber der EINE
gebuendelte Bruch.

---

## GRUPPE C -- VOR W3 / VOR DER MESSKAMPAGNE (3 Fragen)

### C-1 -- PMC: der Dreifach-Entscheid (Invariante, Wachen-Richtung, Buchbarkeit)

**FRAGE:** Drei Teilfragen in einem Block -- (a) wird `COMDARE_ENABLE_PMC` in der dynamischen Kette zur
INVARIANTE statt an Job-Namen zu haengen, (b) drehen wir die Wachen so, dass "PMC-Quelle nicht gebaut" ein
FEHLER ist und kein Skip, und (c) darf ein Messlauf OHNE PMC-Zaehler ueberhaupt als gueltig gebucht werden?

**STAND:** Vier Wachen existieren, keine beisst (r3 C1, `rest_karte_r3.md:303-333`): `CMakeLists.txt:67`
setzt `option(COMDARE_ENABLE_PMC ... OFF)` und gated damit AUCH den Linux-Pfad, obwohl die Option "Intel PCM
Windows cache-miss source" heisst -- ohne das Flag gibt es auf Linux gar keine PMC-Quelle;
`m3v2_pmc_smoke.cpp:71` laesst lauter Nullzaehler als bestanden durch; der eigens gebaute #37-Preflight
gibt bei `!delta.available` `SMOKE_SKIP` und `return 0` (`linux_perf_pmc_smoke.cpp:58-63`);
`experiment_plan_director.hpp` emittiert an vier Stellen `-DCOMDARE_V32_ENABLE=ON`, aber
`grep -c COMDARE_ENABLE_PMC` auf der Datei ist 0. Die Wurzel: die PMC-Pflicht war an ZWEI Job-Namen
geheftet (`measure:smoke`, `measure:golden-320`), beim Wechsel auf die dynamische Kette blieb sie dort
zurueck. Dein Wort vom 16.07. (F9) ist eindeutig: PMC "NICHT mehr gegated ... und MUSS als PFLICHT fuer die
Vollstaendigkeit aller perf-Messwerte mit in die Ergebnisse"; die haeufig zitierte Gegenstelle
("honest-0 bis #26") ist vier Tage aelter und traegt schon einen SUPERSEDED-Vermerk.

**EMPFEHLUNG (a)+(b): ja, beides.** Die Aufloesung von (c) ist nach W-r3-2 kein Sachwiderspruch, sondern
zwei nie zusammengefuehrte Ebenen: die BAU-Seite bleibt soft (die Binary entsteht auch ohne
Messeinrichtung, KON28-02), die ERGEBNIS-Seite wird hart (die Zeile traegt den Zaehler oder einen ehrlichen
Status-Token, nie eine stille 0). Damit waere (c) beantwortet mit: nein, ein Messlauf ohne PMC-Zaehler ist
nicht als vollstaendig buchbar, aber er ist als ausdruecklich gekennzeichneter Teil-Lauf buchbar. Bitte
bestaetige diese Lesart oder korrigiere sie -- sie ist die einzige, die beide deiner Saetze haelt.

**WENN OFFEN:** Die Voll-Matrix laeuft ohne Hardware-Zaehler durch und meldet gruen. Verschaerfend:
`pmc_cache_misses_l3` faellt auf AMD mit `errno=2` STILL auf 0, waehrend Intel 4M+ populiert (r3 C2,
`rest_karte_r3.md:334-345`). Startet der Voll-Lauf so, tragen alle AMD-Zeilen eine Null, die eine Messung
behauptet; repariert man es danach, tragen frueh und spaet erhobene Zeilen verschiedene Semantik unter
derselben Ueberschrift -- ein Datenbruch ohne Neubau, unsichtbar.

### C-2 -- PMC-Anhangsumfang: I-PMC-2/3 bauen oder die Kernmetrik-Zusage zuruecknehmen?

**FRAGE:** Bauen wir I-PMC-2/3 (L3-Mapping + branch_misses, L2 + coherence via Zen-5-RAW), oder nehmen wir
die Thesis-Zusage "Cache-Misses als Kernmetrik" auf L1D + dTLB zurueck?

**STAND:** Auch MIT Flag bleiben L3, L2, coherence und energy auf 0 -- "der Anhang kann selbst im besten
Fall nur L1D + dTLB zeigen" (W-r3-4, `rest_karte_r3.md:800-812`, Zitat Z23648-23651). Dagegen steht V-08:
"#152 Cache-Misses als Kernmetrik + I-PMC-2/3 -- sonst wird mit einer als Kernmetrik deklarierten Groesse
= 0 ausgewertet". Ein dritter Weg (still 0 messen) ist per Doktrin "stiller Rueckfall ist verboten"
ausgeschlossen.

**EMPFEHLUNG:** Zuruecknehmen, also die Kernmetrik-Zusage in der Thesis ehrlich auf L1D + dTLB
zuschneiden -- und I-PMC-2/3 als Nach-Abgabe-Posten fuehren. Begruendung: der Bau ist Zen-5-RAW-Arbeit mit
offenem Ausgang und liegt vor dem 26.08. auf dem kritischen Pfad; die Textkorrektur ist eine Stunde und
macht die Arbeit an dieser Stelle nachweisbar statt hoffnungsvoll. Wenn du den Bau willst, sag es -- dann
braucht er einen eigenen Slot vor W3, nicht daneben.

**WENN OFFEN:** Das gehoert "vor Phase 6 entschieden, nicht nach der Messung entdeckt" -- danach ist es
eine Aussage in der gedruckten Arbeit, die die eigenen Daten nicht tragen.

### C-3 -- Selektor: welche der sechs `best_binary`-Metriken sind MAX?

**FRAGE:** Welche der sechs Metriken des `best_binary_selector` sind MAXIMIEREN statt MINIMIEREN?

**STAND:** `best_binary_selector.hpp:236-254` traegt alle SECHS Metriken hart `Minimize` (r4 D-04/C-5,
`rest_karte_r4.md:126, 240-244`). Der T-9-Katalog (`heuristik/axis_optimization_catalog.hpp`, 436 Z.,
constexpr) fuehrt dagegen 45 Zielgroessen mit 17 MAX / 28 MIN, und der Kern dort ist: die Richtung haengt
an der ZIELGROESSE, nicht an der Achse (T3 will MAX Kompressionsrate UND MIN Baumhoehe). Zwischen beiden
liegt ein echtes Paritaets-Gate -- aber es haelt die Enum-Gleichheit, NICHT die Richtungs-Gleichheit.

**EMPFEHLUNG:** Ich lege dir die sechs Metriken einzeln mit meiner Richtungs-Vermutung vor, sobald du
"ja" sagst -- eine Liste mit sechs Zeilen zum Abhaken ist billiger als eine Frage im Abstrakten. Alternativ:
wenn alle sechs tatsaechlich MIN sind, genuegt ein "alle sechs bleiben MIN", dann setze ich einen
begruendeten Marker am Paritaets-Gate und die Sache ist erledigt.

**WENN OFFEN:** Die Auslieferungs-Auswahl rechnet fuer jede MAX-Groesse falsch herum -- also genau die
Klasse, an der T-8 schon einmal eine dominierte Binary ausgeliefert hat (r4 D-05, geheilt `21560a2e`).
Der Auslieferungspfad ist der teuerste Ort fuer stille Defekte.

---

## GRUPPE D -- KLEIN, EIN SATZ GENUEGT (10 Fragen)

### D-1 -- XML-Wache (KON3-03): ist eine unbeobachtbare Zweighaelfte zulaessig?

**FRAGE:** Sind die zwei nachweislich unbeobachtbaren Zweighaelften der XML-Wohlgeformtheits-Wache eine
zulaessige, deklarierte Grenze -- oder ein Bauauftrag?

**STAND:** Selbstmeldung des Bauenden 09.08. 12:49, woertlich: "XML-Wache: grep-Zweig (nicht ausloesbar
ohne root) und Nenner-Mismatch-Zweig (nachweislich unbeobachtbar, Mutant ueberlebt -- literal belegt)"
(Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:10938-10960`). Die Nachfrage wurde 12:53 gestellt
und im Transkript nie beantwortet. Eine Wache mit einer unbeobachtbaren Haelfte meldet Vollstaendigkeit
ueber einen Nenner, den sie nur halb kennt.

**EMPFEHLUNG:** Deklarierte Grenze -- also: die Wache behaelt beide Zweige, aber ihre Ausgabe nennt den
geprueften UND den ungeprueften Anteil ausdruecklich. Begruendung: der root-Zweig ist im CI-Kontext nicht
herstellbar; ihn zu erzwingen hiesse, die Wache um eines Zweigs willen umzubauen, der in Produktion nie
faehrt. Was NICHT bleiben darf, ist die stille Vollstaendigkeits-Meldung.

**WENN OFFEN:** Die Wache meldet weiter gruen ueber einen halben Nenner -- genau die Klasse, gegen die T-6
und K13 gebaut sind.

### D-2 -- Kurven-Stack: welcher der drei ist kanonisch (E-5)? Und K4 getrennt.

**FRAGE:** Zwei getrennte Fragen -- (a) welcher der drei Statistik-/Kurven-Stacks der Auswertung ist der
kanonische, und (b) bekommt das `mess/`-Subsystem eine eigene S-Position im Zielstruktur-Schnitt?

**STAND:** (a) `Ledger:16327`: "E-5 ist der teuerste, wenn er ausbleibt: welcher der drei Kurven-Stacks ist
kanonisch? Ohne Entscheid entscheidet der Aufraeumpass Par.75 implizit -- und dann ist die Wahl getroffen,
ohne dass jemand sie getroffen hat." (b) K4 (`Ledger:15076`-Umfeld) wurde nie gestellt: `mess/` traegt
heute keine S-Position, obwohl es ein eigenes Subsystem ist.

**EMPFEHLUNG:** Bitte beide GETRENNT beantworten, auch wenn sie im selben Absatz stehen -- (a) ist eine
Auswerte-Architektur-Frage mit Wirkung bis in die Diagramme, (b) ist eine Struktur-Frage mit Wirkung auf
den Monolith-Split. Zu (a) lege ich dir die drei Stacks nebeneinander vor, sobald du das Fenster oeffnest;
eine Empfehlung ohne diese Gegenueberstellung waere geraten.

**WENN OFFEN:** Der Aufraeumpass Par.75 waehlt implizit, und danach ist die Wahl nicht mehr sichtbar als
Wahl.

### D-3 -- Registration-Token-Reset (KON58-04): je Projekt oder instanzweit?

**FRAGE:** Setzen wir Registration-Tokens je Projekt zurueck, oder schalten wir sie instanzweit ab?

**STAND:** Die Instanz akzeptiert Registration-Tokens weiterhin
(`allow_runner_registration_token=true`); die "776" ist keine Projekt-ID, sondern die Zahl der
gitleaks-Treffer (RuleID `gitlab-rrt`) im Backup-Suchlauf (Ledger KON58-04, `:3345-3351`). Das ist die
MECHANIK-Frage; die TIMING-Frage steht oben als A-1.

**EMPFEHLUNG:** Instanzweit abschalten und auf Runner-Authentication-Tokens umstellen. Begruendung: das
Leck-Format `GR1348941` ist genau der Registration-Token-Typ; wer ihn abschaltet, macht die ganze
Fund-Klasse gegenstandslos statt sie zu rotieren. Die Flotte ist klein (die vier Windows-Runner plus
prod1/prod2), der Umstellungsaufwand also ueberschaubar -- aber es ist ein Infra-Eingriff mit
Runner-Ausfall-Risiko, deshalb frage ich.

**WENN OFFEN:** A-1 rotiert dann je Projekt (der billigere, aber wiederholbare Weg).

### D-4 -- ETA: `last_update_utc` mergen? Und ist ETA nur der Lease-Timer?

**FRAGE:** (a) Loese ich den stillen ETA-Merge-Verlust durch EIN neues Feld `last_update_utc` (Syntax-Bump)
oder durch eine geaenderte Konflikt-Aufloesung? Und (b) ist die ETA nur der Lease-Timer, oder auch ein
Dispositions-/Kapazitaetswert?

**STAND:** (a) Am Objekt gemessen: `merge_documents(remote{offen, eta=100}, lokal{offen, eta=250})` liefert
100 -- `pick_reservierung` (`bestandslog_lock.hpp:380-388`) laesst bei gleichem Rang die gefuellte `eta_s`
gewinnen, sonst stabil `a`. Jede zweite Fortschreibung derselben offenen Reservierung wird verworfen,
waehrend `store()` `true` meldet. Zusaetzlich misst der Takeover-Uhr-Anker an `reserviert_utc`, das sich
nicht bewegt (r5 A48, `rest_karte_r5.md:415-425`). Heute kein Live-Pfad -- der Zweig wird scharf, sobald
periodische Updates gebaut werden. (b) `eta_s` wird von genau zwei Stellen gelesen (Takeover-Praedikat +
`planner_status_reader.hpp:330`, der nur zaehlt); `avg_size_bytes` wird eingetragen, aber keine Stelle
rechnet daraus eine Platzvorhersage (r5 A50, `rest_karte_r5.md:439-445`).

**EMPFEHLUNG:** (a) Das eine Feld -- `last_update_utc`, ans ENDE der Feld-Folge wegen Byte-Stabilitaet.
"Ein Feld, zwei Defekte, ein Bump": es loest den Merge-Konflikt UND den Uhr-Anker, waehrend eine geaenderte
Konflikt-Aufloesung nur den ersten trifft und den zweiten stehen laesst. (b) Auch Dispositionswert --
dann wird `avg_size_bytes` der Eingang in die `df`-Wache, die Par.V7.4 fuer den Voll-Bau ohnehin fordert.
Ohne das bleibt ein eingetragener Wert ohne Verbraucher stehen.

**WENN OFFEN:** Der Merge-Verlust bleibt latent und wird still scharf, sobald die periodischen Updates
gebaut sind -- also mitten in der Kampagne, wo er am teuersten ist.

### D-5 -- F-01: die Talos-Aussage in der Abgabe zuruecknehmen?

**FRAGE:** Nehme ich die Aussage zurueck, dass jede Messung unter zwei Betriebssystem-Regimes (Talos und
root-Linux) laeuft?

**STAND:** Die Arbeit sagt woertlich "jede Messung unter zwei Betriebssystem-Regimes (Talos und
root-Linux)" (ADR-12, verstaerkt in ZWEI eingebundenen Kapiteln). Am Objekt: null Treffer im Code, die
OS-Achse kennt drei Auspraegungen OHNE Talos, alle 16 Messzeilen tragen `platform=linux-x86_64`, kein
Limitierungs-Punkt entlastet (r3 D1, `rest_karte_r3.md:466-478`).

**EMPFEHLUNG:** Zuruecknehmen -- unter einer Stunde Textarbeit gegen mehrere Tage Infra bei read-only
Cluster. Es ist eine Falschaussage in der Abgabe, kein Feature-Rueckstand; sie zu bauen waere der teuerste
Weg, sie loszuwerden.

**WENN OFFEN:** Die Arbeit geht mit einer nachweislich unwahren Aussage in zwei Kapiteln in die Abgabe.

### D-6 -- D5-1-Kollision im Anhang: markieren oder neu erheben?

**FRAGE:** Die alten p50/p95/p99-Zahlen im lebenden Thesis-Anhang -- markiere ich sie als ueberholt, oder
erhebe ich sie neu?

**STAND:** D5-1 vermerkt "alle vorher erhobenen p50/p95/p99 ungueltig"; im lebenden Anhang stehen genau
solche Zahlen unmarkiert als gueltig (`A_measurements.tex:46-49`, `tabellen/bias_matrix_table.tex:2`,
"ns/op, nearest-rank"). Wie die Kollision aufzuloesen ist, ist nirgends festgelegt. Dazu: die Thesis ist
beim Median-Mechanismus intern zweistimmig -- Hauptkapitel HDR, Anhang nearest-rank -- und keine Quelle im
Korpus loest die Binnendifferenz auf (r1 A-23, `rest_karte_r1.md:185-190`).

**EMPFEHLUNG:** Markieren, nicht neu erheben -- die Neuerhebung kommt mit der Kampagne ab 26.08. ohnehin,
und bis dahin ist eine markierte alte Zahl ehrlicher als eine fehlende. Die Binnendifferenz HDR vs.
nearest-rank loese ich getrennt im Thesis-Sync auf; sie ist eine Definitionsfrage, keine Datenfrage.

**WENN OFFEN:** Der Anhang traegt bis zur Abgabe Zahlen, die das eigene Protokoll fuer ungueltig erklaert.

### D-7 -- Anhang A: bei 16 von 44 bleiben (Weg 1)?

**FRAGE:** Bleibt Anhang A bei 16 belegten von 44 deklarierten Fragmenten plus einer Luecken-Zeile in
`le_limitierung.tex` (DE+EN) -- oder soll der Rest gefuellt werden?

**STAND:** Anhang A deklariert je Sprache 44 Fragmente, 16 mit echten Messdaten, 28 leer (per
`\InputIfFileExists` gegatet, im PDF unsichtbar). Die Lead-Empfehlung Weg 1 liegt vor, ohne Freigabe; die
frueher tragende "NACH-Abgabe"-Praemisse ist durch die Termin-Korrektur auf 15.09. widerlegt (r4 D-17,
`rest_karte_r4.md:172-174`).

**EMPFEHLUNG:** Weg 1 -- bei 16/44 bleiben und die Luecke ausdruecklich benennen. Begruendung: die 28
leeren Fragmente brauchen Messdaten, die erst die Kampagne liefert; eine ehrliche Luecken-Zeile ist ein
gueltiges Ergebnis, ein stilles Verschweigen nicht. Koppelt an KON58-13 (28-vs-13) und das
F5-Anhang-Gate -- beides zieht mit.

**WENN OFFEN:** Der Anhang deklariert 44 und liefert 16, ohne dass ein Leser das erfaehrt.

### D-8 -- T-9-Katalog: bekommt `persistence_target`/T19 eine Zeile?

**FRAGE:** Bekommt `persistence_target` (T19) eine Zielgroessen-Zeile mit Richtung im T-9-Katalog, oder ist
das Fehlen die richtige Aussage?

**STAND:** Der Katalog ist gebaut (`heuristik/axis_optimization_catalog.hpp`, 19 Achsen T0..T18, 45
Zielgroessen, jede mit BEFUND-Zeilennummer rueckverfolgbar; Pareto-Achsen T5/T6/T18 verweigern
compile-time die Einzel-Richtungs-Frage). `persistence_target`/T19 hat keine Katalog-Zeile,
`catalog_axis_from_name` ist dort honest-empty, und ein consteval-Anker (17 gemeinsam + 2 nur-Katalog + 1
nur-Komposition) bricht bei jeder kuenftigen Verschiebung (r4 D-03, `rest_karte_r4.md:123-125`).

**EMPFEHLUNG:** Erst die gekoppelte Explore-Frage aufloesen, dann entscheiden -- naemlich ob ORG-19-IO
scharf wird und damit K17 entpinnt (r4 C-6). Solange `persistence_target` auf 1 gepinnt ist, ist
"keine Zielgroesse" die ehrliche Aussage; wird ORG-19 scharf, braucht T19 eine Richtung UND die gedruckte
2^17 aendert sich. Ich empfehle: heute keine Zeile, aber ein Marker am consteval-Anker, der auf ORG-19
zeigt.

**WENN OFFEN:** Der consteval-Anker haelt, aber die Kopplung an W14/ORG-19 bleibt unverbucht.

### D-9 -- A11: die ccache-Allowlist zurueckziehen?

**FRAGE:** Ziehe ich den A11-Plan-Posten "ccache-Allowlist-Drop" zurueck, weil der Code-Kommentar die
Gegenbegruendung traegt?

**STAND:** Zwei normative Quellen widersprechen sich. Plan (02.08.): "A11 | Klein-Sammel |
ccache-Allowlist-Drop". Code (`.gitleaks.toml:24-28`, 27.07.): "MARATHON-SCAN-FALLE 27.07. ... Dieser
Eintrag MUSS hier stehen: der Job waehlt bei vorhandener Projekt-toml AUSSCHLIESSLICH diese
(`-c ./.gitleaks.toml`), die zentrale ci-templates-Basis greift dann NICHT." Die Marathon-Begruendung ist
am Objekt konkret: Job 335274, 24 min ohne Trace (r3 W-r3-3/D21, `rest_karte_r3.md:791-798, 707-712`).

**EMPFEHLUNG:** A11 zurueckziehen, den Code-Kommentar zur geltenden Wahrheit erklaeren -- und den
Rueckzug SICHTBAR machen (Marker am Plan-Posten). "Stillschweigendes Verschwinden waere die schlechteste
Variante."

**WENN OFFEN:** Ein Plan-Posten und ein Code-Kommentar behaupten dauerhaft Gegenteiliges; irgendwann zieht
jemand den Eintrag und die Marathon-Falle kehrt wieder.

### D-10 -- A12/E-14 NAS-Creds: gilt der Posten noch?

**FRAGE:** Gilt A12/E-14 (NAS-Creds backup1/backup2) noch, ist er erledigt, oder verworfen?

**STAND:** Die SACH-Haelfte ist am Objekt geklaert: deprecatet ist die METHODE (rohe UNC/SMB-Kopie,
`scripts/copy_results_to_nas.sh`), nicht das ZIEL -- spaetere Dokumente referenzieren PR4100 weiterhin
aktiv ueber den CI-WRITE-Token-Weg; Runner duerfen `Cluster_NFS` nie LESEN, nur ueber den Filterpod
schreiben; der Buildsystem-Export ist unberuehrt (r5 A76, `rest_karte_r5.md:673-681`). Offen bleibt nur der
STATUS des Posten selbst -- er ist ohne Erledigungsbeleg und kein Vor-Trigger-Blocker (r3 D21).

**EMPFEHLUNG:** Als erledigt ausbuchen und in den `COMDARE_NFS_DROP_TOKEN`-Posten (Ebene C, KON58-04)
ueberfuehren -- das ist derselbe Gegenstand unter anderem Namen. Wenn du das anders siehst, sag es; dann
bleibt A12 als eigener Release-Checklisten-Posten stehen.

**WENN OFFEN:** Ein Posten ohne Gegenstand bleibt bis zur Abgabe in der Liste und kostet bei jeder Triage
erneut Lesezeit.

---

## GRUPPE E -- STRATEGISCH / W4-VORLAUF (4 Fragen)

### E-1 -- UltiHash: gehoert das Produktions-Release-Konzept in die Arbeit?

**FRAGE:** Nehme ich das Konzept "beste Tier-Binary als ABI-stabiles Produktions-Release" (UltiHash-Rahmen,
ComdareDB) in das Thesis-Selbstverstaendnis und in das Deploy-Kapitel auf?

**STAND:** Dreifach aufgetaucht, dreifach nicht verfolgt (e4 FUND 1, `explore_karte_e4.md:21-56`).
Habich-Termin 7 (08.05., H5, `docs/termine/20260508 Termin 7/Habich_Feedback_2026_05_08.txt:180-202`):
"Nach Abschluss der Experimente liefert die CacheEngine fuer eine Plattform die beste
Suchalgorithmus-Rekombination unter Optimierung ... ueber std::map<>-aehnliches Interface in Produktion
verfuegbar ... Production-Modus (ComdareDB-Verwendung)". Du selbst am 25.06.
(`20260625-USER-ANTWORTEN-13-ENTSCHEIDUNGEN-...md:13-25,81`): "das Zurueckschreiben mindestens EINER
Tier-Binary ... um wiederum in einem anderen System als perfekte Plattform-Binary-Release zu arbeiten. Die
Cache-Engine ist konzeptionell von UltiHash abgeleitet ... Wir zeigen also hier das Konzept von UltiHash,
OHNE den Code darzulegen" (dort "Versprechen #172.1"). Gegenprobe: `ComdareDB` = 0 Treffer im ganzen
Live-Ledger (30076 Z.), `Plattform-Binary-Release` = 0, `172.1` = 0. Das Lager-/Storage-Thema (W9) deckt es
NICHT ab -- das behandelt die VERWAHRUNG von Messdaten und Binaries, nicht die FREIGABE der besten Binary
als eigenstaendiges Deploy-Artefakt.

**EMPFEHLUNG:** Ja, aufnehmen -- als Selbstverstaendnis-Baustein im Einleitungskapitel und als
Artefaktklasse im Deploy-Kapitel (neben Lager-Rueckschrieb und Thesis-PDF), aber OHNE ComdareDB-Code
darzulegen (deine eigene Auflage). Begruendung: es ist der Satz, der erklaert, wozu die ganze
Permutations-Maschinerie am Ende dient; ohne ihn liest sich die Arbeit als Messung um ihrer selbst willen.
Der Bau des Deploy-Pfads selbst gehoert nicht in diese Frage -- hier geht es um Text und Artefaktklasse.

**WENN OFFEN:** Der Zweck der Arbeit bleibt im Text unausgesprochen, obwohl er zweimal von dir und einmal
vom Betreuer benannt wurde.

### E-2 -- `BAUSTEINE_BEWERTUNG.md` + Habich-Sign-Off je SOTA-Quelle

**FRAGE:** Lege ich das von Habich verlangte Pflichtformat `BAUSTEINE_BEWERTUNG.md` je Bausteine-Quelle an
-- und holst du die Sign-Offs ein?

**STAND:** Habich-Termin 7 (08.05., H2,
`docs/termine/20260508 Termin 7/Habich_Feedback_2026_05_08.txt:60-101`) verlangt je zerlegtem
Algorithmus-Aspekt: QUELLE (Original-Datei + Zeilenbereich + Commit-Hash), ZIEL (Adapter-Header +
Funktion), BESCHREIBUNG (was aequivalent geaendert wurde, warum, mit welchen Auswirkungen auf die
Vergleichbarkeit) -- Pflichtformat `BAUSTEINE_BEWERTUNG.md`, inklusive Feld "Habich-Sign-Off: ausstehend |
erteilt am YYYY-MM-DD". Gegenprobe: `Bausteine_Bewertung`, `Sign-Off`, `Habich-Sign` = 0 Treffer im vollen
Live-Ledger und im Kompakt-Extrakt (e4 FUND 2, `explore_karte_e4.md:58-89`). Es werden mindestens 8
SOTA-Baselines aktiv weitergemessen, ohne dass je ein Formatnachweis entstanden ist.

**EMPFEHLUNG:** Ja -- ich lege das Format an und fuelle es aus dem vorhandenen Adapter-Bestand; das Feld
"Habich-Sign-Off" bleibt auf "ausstehend", bis du die Freigaben einholst. Das Sign-Off ist ausdruecklich
ein Betreuer-Feld und darf nicht autonom gesetzt werden. Begruendung: die wissenschaftliche
Vergleichbarkeits-Dokumentationspflicht ist in Kraft, seit wir Algorithmen zerschneiden; ohne sie steht
jede Baseline-Zahl auf einer undokumentierten Aequivalenz-Annahme.

**WENN OFFEN:** Die Arbeit misst gegen 8+ Baselines, ohne dass die Vergleichbarkeit der Adaptionen
irgendwo belegt ist -- ein Angriffspunkt genau in der Kernaussage.

### E-3 -- Paper-Kopplung / PV-4: Reichweite bestaetigen

**FRAGE:** Bestaetigst du die Reichweite der Paper-Kopplung (PV-4) vor W4 -- also: bauen wir sie in dieser
Arbeit, oder schraenken wir die Reichweite der Arbeit ausdruecklich ein?

**STAND:** Das ist die wissenschaftliche Kernfrage der Arbeit in einem Satz. Dein Wortlaut (zitiert in
`docs/plaene/20260808-WELLENPLAN-ANLAGE-luecken-defekte-einwaende.md`, Einwand E3, Z.477-482): "ueber die
Paper-XML definitionen ... in denen wir sequentiell JEDE Achse einzeln durch-permutieren, ob nicht die
Algorithmen der Anderen Paper in dieser Achse besser gewesen waeren" -- also nicht "welche Komposition ist
die beste", sondern "waere Paper X' Algorithmus fuer Achse A besser gewesen als der von Paper Y". Dein GO
liegt vor: "Ja unter sorgfaeltiger Design Planung bitte bauen, Ruecksprache mit mir im Detail."
Code-Gegenprobe 16.08.: `grep -rn "Paper-Kopplung\|PV-4\|paper_template"` ueber den ganzen ce-Baum = 0
Treffer. Der Plan schiebt das Thema als "Paper-Research-Vollausbau" nach W7 -- also hinter die Abgabe --
ohne Owner-Vorlage und ohne Risiko-Eintrag (e3 Fund 2, `explore_karte_e3.md:52-79`). Passend dazu: 33
SOTA-Profile liegen lueckenlos vor, aber 0 Experiment-XML; `profile_ref` wird geparst und nie
dereferenziert, 7 `base_tiers` erzeugen 0 Binaries (r5 A26).

**EMPFEHLUNG:** Die Ruecksprache jetzt fuehren, in einem eigenen Slot vor W4 -- ich lege dir dafuer den
Design-Schnitt vor (ein Experiment-XML je Paper, `profile_ref` dereferenzieren, Regel der abstrakt-leeren
Achse). Begruendung: dein GO existiert und hat nie eine Umsetzung gefunden; wenn die Arbeit ihr eigenes
Alleinstellungsmerkmal nicht traegt, muss die Einleitung das ausdruecklich sagen -- und das ist eine
Text-Entscheidung, die VOR der W4-Redaktion fallen muss, nicht danach.

**WENN OFFEN:** Die Arbeit behauptet in der Zielsetzung eine Frage, die sie nicht beantwortet, und niemand
hat das je als Risiko verbucht.

### E-4 -- Multi-Plattform: lebt FF0, und lebt die Cross-Plattform-Anforderung?

**FRAGE:** Zwei Haelften derselben Reichweiten-Frage -- (a) gilt FF0 (Multi-Plattform-Generalitaet: x86
AMD+Intel / ARM / RISC-V) als Forschungsfrage der Arbeit, und (b) lebt die Anforderung, Windows 11 /
Windows Server 2022 / 7 weitere Linux-Container / 2 macOS an die OS-Schnittstelle anzugliedern, oder ist
sie bewusst descoped?

**STAND (a):** Die Thesis stellt fuenf Fragen; FF0 ist als Abgabe-Blocker mit "OWNER FEHLT explizit"
gefuehrt und heute nur implizit ueber gated #163/#189 abgedeckt; der Ledger-Kopf fuehrt FF0-FF4 ueberhaupt
nicht (r1 A-45, `rest_karte_r1.md:346-350`). **STAND (b):** Dein Wort 21.07.: "Muss aber fuer Windows 11,
Windows Server, Linux ubuntu (und 7 weitere Linux OS typen), sowie mac OS x86+ARM1 passen"; 26.07. (RF-3):
"Jetzt bauen, per infrastruktur liegen schon Windows 11 und Windows Server 2022, sowie 7 weitere linux
docker container und 2 macOS bereit" (e2 Fund 2, `explore_karte_e2.md:101-113`). Die Infra-Haelfte ist
inzwischen am Objekt gemessen und teilweise geklaert: 21 Images sind entschieden (7 OS x 3 neueste
Versionen), macOS/RISC-V/Pi5 laufen NUR DEBUG, alle vier Windows-Runner sind online, node6 lebt, node5 ist
tot (r4 C-05/C-06 + Task #60). Was NICHT geklaert ist: ob die Mess-Matrix diese Plattformen tragen soll.

**EMPFEHLUNG:** Eine Zeile fuer beides: FF0 gilt als Forschungsfrage, aber mit ausdruecklich erklaerter
Reichweite -- x86 AMD+Intel voll gemessen (prod1/prod2), ARM/RISC-V/macOS als Debug-Lauffaehigkeits-Nachweis
ohne Messdaten. Begruendung: das entspricht dem, was die Infra heute wirklich hergibt (macOS/RISC-V/Pi5 nur
DEBUG ist bereits entschieden), und es macht aus einer stillschweigend verlorenen Anforderung eine
deklarierte Grenze. Wenn du mehr willst, ist das ein eigener Strang mit externen Gates (GH200-Miete,
ZIH-Antrag) und gehoert vor W4 terminiert.

**WENN OFFEN:** FF0 bleibt ein Abgabe-Blocker ohne Owner-Wort, und eine zweimal ausgesprochene
Plattform-Anforderung verschwindet lautlos aus der Arbeit -- gegen deine eigene "ALLES IST
GEPLANT"-Doktrin.

---

## ZUR KENNTNIS -- am Objekt aufgeloest, kein Entscheid noetig (Widerspruch genuegt)

Diese drei standen als Fragen auf der Liste. Die Objekt-Probe in dieser Runde hat sie aufgeloest; ich
melde sie, damit du widersprechen kannst, aber du musst nichts entscheiden.

**K-1 -- Break-Even: beide Teilfragen tragen bereits dein Wort.** Die Vereinheitlichung der zwei
divergierenden Implementierungen (`heuristik/break_even.hpp:68` monotone Hermite, geschuetzt, gegen
`builder/best_binary_selector/best_binary_selector.hpp:419` stueckweise linear, festes 256-Raster,
self-declared SKELETON) ist kein Entscheid, sondern dein Auftrag: "beide zusammenfuehren" (r5 A15). Und der
vermeintliche Hysterese-Widerspruch ist keiner: dein checkpoint_measure-Wort sagt "Keine Hysterese noetig,
sondern Bereichs-Erkennung", und A81 sagt dasselbe ("Stufe 1 mittelt, Stufe 2 sucht Bereiche; keine
Hysterese"). Das gegenteilige "Hysterese-Band als Pflicht-Eigenschaft" stammt aus einem eigenen
Plan-Dokument, nicht von dir (e3 Fund 1, `explore_karte_e3.md:28-50`). **Ich buche das als Bau-Auftrag:
zusammenfuehren, Bereichs-Erkennung, Skeleton-Vermerk streichen** -- und lege dir die Datenquellen-Luecke
(CSV ohne Checkpoint-Spalte, "Erst Checkpoints + Wallclock, dann B-Spline") getrennt vor, wenn sie ansteht.

**K-2 -- Lizenz-Tabelle: die Karte hatte die Richtung falsch herum.** Die Rest-Karte r4 D-01 (Stand 07.08.)
meldete drei Abweichungen Thesis gegen Akte. Objekt-Probe heute: **zwei davon existieren nicht mehr.**
`anhang/de/D_building_block_matrix.tex:320` und `:325` tragen fuer tcmalloc "Apache-2.0" und fuer lrmalloc
"MIT" -- identisch zur Akte (ce `NOTICE:374`, `:426`; `LICENSE_AUDIT_EXT.md:42`, `:46`); die EN-Fassung
ebenso. Die dritte existiert, aber umgekehrt: fuer A03 michael-lockfree sagt die **Thesis "LGPL Re-Impl"**
(`D_building_block_matrix.tex:317`, EN `:317` und `:1404`) -- und das ist **richtig**. Das Original traegt
es literal: `ext/allocator/A03-michael-lockfree/README` und `michael.h:1-17` sagen beide "Copyright (C)
2007 Scott Schneider, Christos Antonopoulos ... GNU Lesser General Public License ... version 2.1 or (at
your option) any later version". **Falsch sind unsere eigenen Dateien:** ce `NOTICE:336` behauptet "MIT
(per repository README)", ce `LICENSE_AUDIT_EXT.md:39` behauptet "KEINE LICENSE". Das ist keine
Geschmacksfrage, sondern eine falsche Lizenz-Zuschreibung an ein LGPL-Bauteil. **Ich korrigiere NOTICE und
LICENSE_AUDIT_EXT.md auf LGPL-2.1-or-later** (die gedruckte Tabelle bleibt unberuehrt, sie stimmt) und
haenge einen datierten Vermerk an. Deine Habich-Freigabe fuer LGPL ("WIRD VERWENDET OHNE SPERREN", r5 A68)
deckt die Verwendung; es geht rein um die richtige Angabe.

**K-3 -- liburing in den Lizenzdateien: ueberholt.** Die Karte r5 A75 meldete "steht in KEINER der beiden
Lizenzdateien" (Erhebung mit Anker `:27509-27510`). Am Objekt heute steht es in beiden:
`LICENSE_AUDIT_EXT.md:65` und `:130-132` (dual LGPL-2.1 / MIT, Comdare waehlt MIT) sowie `NOTICE:524-534`.
Der Audit-Kopf datiert den Nachzug selbst auf 2026-08-10 und nennt den Grund: liburing ist das einzige
`ext/`-Bauteil, das in eine ausgelieferte Binary gelinkt werden kann. **Kein offener Posten.**

---

## SELBSTCHECK

Dokument ist ASCII-only, keine Zeile ueber 120 Zeichen. 20 Fragen: Gruppe A 2, Gruppe B 1, Gruppe C 3,
Gruppe D 10, Gruppe E 4 (Gruppe C fuehrt den PMC-Block als zwei Fragen C-1/C-2 plus C-3 Selektor). Alle
Belege sind Datei:Zeile oder Karten-Anker in
`docs/sessions/backups/20260817-drift-konsolidierung-rohdaten/`. Objekt-Proben dieser Runde: A03/A06/A11
Lizenzangaben in Thesis DE+EN gegen ce NOTICE, ce LICENSE_AUDIT_EXT.md und das Original-README/-Header;
liburing gegen beide Lizenzdateien. Zwei Kandidaten wurden als objekt-entscheidbar ausgesondert (K-1, K-2
mit K-3), zwei zu einer Frage zusammengelegt (E-4). Die #15-Bump-Vorab-Entscheide stehen ausdruecklich
NICHT hier, sondern in `OWNER-VORAB-15.md`.
