# HAUPTSTRANG A2.3a -- REGISTER DER WOCHE 27.08.-04.09., OWNER-AUFTRAEGE, ZIEL-SYNTHESE, NAS-SICHERUNG

Lead-Session 5a19728e (Fable 5 max), 04.09.2026 ~20:4xZ. Owner-Order ~20:3xZ (verbatim): "Bitte suche ueber die letzte
Woche nach nicht abgeschlossenen Agenten und Workflows, da waren noch mehr und finde zurueck zum Hauptstrang, indem
du dich wieder auf die Vorbereitung der Rueckkehr von a23a konzentrierst, indem du die vorangegangenen Schritte und
offenen Auftraege untersuchst, die ich dir dazu gab, sie sind noch aktuell. Was ist in deinen eigenen Worten ueber
die letzten 15 Kontexte das gesetzte Ziel und Aufgaben, warum haben wir uns 2 Wochen lang mit speziellen Workflows
gequaelt. Bitte speichere diese workflows als Backup mit Rohdaten in den dafuer vorgesehenen Sicherungsordner auf
dem NAS" + "Bitte weiter, ich wollte nicht unterbrechen".
Rahmen: Owner ~20:0xZ "maximal 2 Agenten gleichzeitig" -> alles hier ist Lead-Arbeit ohne neue Agenten; der laufende
A2.3a-v4-Lauf (wf_a7fff12a) haelt die beiden Slots. Zeiten UTC aus mtimes/Journalen, nie geschaetzt.

## 1. INVENTAR: ALLE WORKFLOWS 27.08.-04.09. (Journal = Wahrheit)

Quelle: ~/.claude/projects/-home-comdare/5a19728e-.../subagents/workflows/wf_*/journal.jsonl (28 Runs), Script-Namen
aus workflows/scripts/ ALLER Projekt-Verzeichnisse (Runs wurden aus wechselnden cwd gestartet), Task-Outputs unter
/tmp/claude-1001/.../tasks/. s/r/f = started/result/failed-Zeilen; o = Agenten OHNE Ausgang (Riss, Stop, Kill).

| Run         | letzte Akt.  | Script / Gegenstand                  | s/r/f/o      | Stand 04.09.                   |
|-------------|--------------|--------------------------------------|--------------|--------------------------------|
| wf_78955b71 | 27.08. 12:06 | d1-va-prod2-nas-2608 (D1 prod2)      | 3/1/1/1      | terminal, #151 completed       |
| wf_607d23d9 | 27.08. 12:08 | lead-vollzug-kon-prtartff-2608       | 5/2/2/1      | terminal, #107 completed       |
| wf_363cae62 | 27.08. 18:01 | d1-prod1-gnout-2708                  | 1/1/0/0      | terminal, #151 completed       |
| wf_2fa9c753 | 27.08. 18:05 | thesis-sync-2708                     | 2/1/0/1      | terminal, #156 completed       |
| wf_9def1e89 | 27.08. 18:17 | thesis-kommentar-nachtrag-2708       | 1/1/0/0      | terminal, Ledger KON133-14     |
| wf_e4c580a2 | 27.08. 18:18 | dichte-fassungen (#146)              | 27/13/6/8    | terminal, #146 completed       |
| wf_8cf07321 | 28.08. 18:51 | stempel-teil2-bau-2608               | 7/2/4/1      | ABGELOEST -> #147 (01.09.)     |
| wf_bc166beb | 28.08. 19:18 | e10-38a2-86-designplan-und-bauzug    | 27/13/2/12   | ABGELOEST -> #133 (30.08.)     |
| wf_027ac946 | 29.08. 02:16 | lande-reif-2708                      | 17/8/7/2     | ABGELOEST -> #153 komplett     |
| wf_d27fc8f0 | 29.08. 12:31 | lande-rest-mainff-47                 | 8/3/4/1      | ABGELOEST -> #153 komplett     |
| wf_c37fb077 | 29.08. 17:36 | rueckfragen-synthese-2stufig         | 228/88/95/45 | ABGELOEST (Owner 'pausiere')   |
| wf_401a0ff3 | 30.08. 10:02 | verify+fix ##47-kalibrier (2L/2F)    | 5/4/1/0      | terminal, #153 Pruefung        |
| wf_bf22ab45 | 30.08. 20:40 | e10-folgephasen (review/landung)     | 8/5/3/0      | ABGELOEST -> Lead #147         |
| wf_50f25326 | 01.09. 08:47 | rueckfragen-trace-0109               | 4/0/0/4      | LEER -> in wf_1fcc434d         |
| wf_38c58b96 | 01.09. 12:42 | e1-ci-zombie-fix-explore-design      | 5/4/1/0      | terminal, #160                 |
| wf_e1751971 | 01.09. 13:27 | verify stempel-2 + super-bump        | 7/5/1/1      | terminal, #147                 |
| wf_4fc4b8d9 | 01.09. 13:28 | e4-thesis-secret-audit-rewrite       | 7/6/1/0      | terminal, #161                 |
| wf_d102ab04 | 01.09. 18:51 | e1-bau rules-skip-fix S-1..S-13      | 14/14/0/0    | terminal, #160                 |
| wf_fe1cf67c | 01.09. 19:39 | fold 157 IDs -> 97 W / 60 R          | 120/109/7/4  | terminal, #159                 |
| wf_6a56ad4d | 01.09. 21:29 | e1-abschluss + ce-Landung 53150058   | 4/4/0/0      | terminal, #160                 |
| wf_1fcc434d | 02.09. 00:15 | 30-kontexte-trace + nachfold         | 82/70/3/9    | terminal, #168                 |
| wf_bfe3433a | 02.09. 07:02 | raster-w2-v109                       | 14/7/7/0     | terminal, #170                 |
| wf_217f0221 | 02.09. 07:48 | raster-nacharbeit-5-schritte         | 10/5/3/2     | terminal TRAEGT, #170          |
| wf_1c5577e4 | 02.09. 08:12 | volllesung-r18-r30-map-reduce        | 37/19/15/3   | terminal, #171                 |
| wf_d69f800c | 02.09. 17:08 | thesis-license-zug-179 (C)           | 2/1/1/0      | OFFEN -> Resume, Platz 2       |
| wf_1a36d148 | 04.09. 19:31 | explore-10-kontexte (A)              | 20/13/4/3    | terminal, gelesen, #174        |
| wf_f97550fa | 04.09. 19:42 | a23a-vorlage v2/v3 (B)               | 79/20/51/8   | ABGELOEST -> v4 (Datei-Eing.)  |
| wf_a7fff12a | 04.09. lebt  | a23a-owner-vorlage-v4-max2           | 2/1/0/-      | LAEUFT (2 Agenten, 20:1xZ)     |
| (kein Run)  | 04.09. 18:23 | explore-3-kontexte #182 (Script)     | 0            | OFFEN -> Umbau, Platz 3        |

Zu wf_c37fb077 (die groesste Zahl "ohne Ausgang", 45): Owner-Wort "pausiere die rueckfragen synthese" (L89812);
die 88 Results (Reduce r18-r30 u.a.) sprengten den Lead-Kontext und wurden am 02.09. per Map-Reduce (wf_1c5577e4,
19 Leser) VOLL gelesen und quittiert (#171, Lesequittung Abschn. 22-24); der FOLD (wf_fe1cf67c) uebernahm den
Gegenstand. Nichts davon ist ungelesen.
Zu wf_bc166beb / wf_027ac946 / wf_d27fc8f0 / wf_8cf07321 / wf_bf22ab45 (Bau-/Lande-Zuege 28.-30.08.): die Riss-Toten
wurden je durch Folge-Runs oder die Lead-Kette zu Ende gefuehrt; Endstaende sind CI-bewiesen (#133 5e03c2cc, #147
dd0f56d3/8b9ca7c9, #153 bd55942a + main-FFs). Zu wf_53d967b8 (26.08., X2-Explore 5/2/0/3): beide Deliverables
liegen (20260825-x2-csv-factory/BEFUND-X2-FINAL.md 327 Z.), Deckung KON133-19 + Board #18 "X2-Design-Eingang B0-B10
GEDECKT". Zu wf_8c890d9a (26.08., Lead-super-Nachlauf 11/4/0/7): 4 Results (KON129, ASCII-Commit 54b25e2f,
Wiederanlauf, ##47 am roten Gate CE_SUBMODULE_TOKEN gestoppt = BL-1 -> #150 geheilt). Aeltere Torsi (23.-26.08.)
waren Gegenstand von #134 (gerissene Straenge, Heilungs-Workflow, completed) und #141 (Volllesung nachgeholt).

Agent-Tool-Subagenten (nicht Workflow) seit 27.08.: 2 -- a6ff2997 (01.09. 14:30, Explore Sonnet "Quellen der
#157-Doku-Posten kartieren", 176 Z., regulaer beendet) und a7cc7fde (01.09. 19:47, Fork "Board-Traeger 30-Kontexte-
Run" -> #168 angelegt). Beide abgeschlossen. Hintergrund-Tasks (Monitore/Bash) sind keine Agenten.

BILANZ: 28 Runs; 2 OFFEN (#179 Resume wf_d69f800c; #182 nie gestartet), 1 LAUFEND (v4), 25 terminal oder durch
spaetere Runs/Lead-Kette abgeloest und verbucht. Kein Rueckkehrer ist ungelesen. Die Owner-Vermutung "da waren
noch mehr" trifft fuer die abgeloesten Bau-/Lande-Zuege 28.-30.08. zu (5 Runs mit 21 Riss-Toten), aber deren
Gegenstaende sind gelandet; offen im Sinne von "noch zu tun" sind nur #179 und #182.

## 2. HAUPTSTRANG: DIE OWNER-AUFTRAEGE ZU A2.3a (chronologisch, Vollzugsstand 04.09.)

A2.3a = "Owner-Vorlage mit Fold-Auflage": EIN Versand-Dokument, in dem jeder offene Gegenstand GENAU EINMAL steht
(Alias-Spalte ueber alle Nummernkreise), dreiwertig klassifiziert (K1 bereits beantwortet / K2 explore-aufgeloest /
K3 echter Owner-Entscheid), mit Sachlage je Frage, so dass der Owner in EINER Nachricht antworten kann.

| Datum/Zeit   | Owner-Auftrag (verbatim-nah, Anker)                                                | Stand           |
|--------------|-----------------------------------------------------------------------------------|-----------------|
| 21.08. 17:06 | "Leider kann ich in dieser Knappheit nichts entscheiden" (NL S11/A-14 Z.887)      | Form V-090(u)   |
| 22.08. 13-17 | Lead-Zusagen L83933/L84993/L85093 EIN-NACHRICHT-Minimalantwort (S12/B-18)         | Deklaration v4  |
| 23.08. 08:36 | "Die Fragen waren erneut zusammenhangslos. Bitte starte einen Opus 5 max          | O-7 -> Trace/   |
|              | ultracode Leser" (NL S12/A-25 Z.921)                                              | Nachfold #168   |
| 25.08. L90418| "Bitte stelle mir alle offenen Entscheidungen und Rueckfragen direkt hier [...]   | A-Tafel 26.08.  |
|              | mit erklaerung und vollem Kontext"; Owner-Kerne A1-A6/B1-B10, B8 "Fehlendes mit   | + #144          |
|              | Fable 5 max nachliefern", 12W/15W-Explores statt Rueckfragen                      |                 |
| 26.08. 13:00 | META-REGEL Block F "es war alles schon beantwortet"; Tafel-Antworten; ~19:0xZ     | verbucht #144;  |
|              | RF-1..RF-9 + "Bitte lies alle Rueckkehrer stets vollstaendig oder hole das nach"  | Regel X-19      |
| 27.08. 18:5x | F1-F5 "Volles go fuer alle Punkte, wie empfohlen" + F4-Revision + "OS-2-Gate      | KON133-20;      |
|              | musst du mir erklaeren" (L95671)                                                  | erklaert L95780 |
| 28.08.       | T-Entscheid "Ich bleibe bei letzterem"; "wir lassen nie etwas fallen, NIE"        | #158, Doktrin   |
| 01.09. ~15:2x| "Alle Soll Fehler sind IMMER auch PFLICHT zu beheben" (L102011)                   | Regel SOLL=MUSS |
| 01.09. 18:2x | Rueckfragen-Audit ueber 30 Kontexte "ultracode mit map reduce"; Reihenfolge       | #168/#170/#171  |
|              | "Fragen -> Antworten -> dichtes Ledger" (#176)                                    |                 |
| 02.09. 07:47 | "Hast du jetzt das dichte Ledger [...]? Bitte stelle mir alle offenen und nicht   | Antwort NEIN,   |
|              | durch explore aufloesbaren Fragen hier"                                           | Rohliste 07:54  |
| 02.09. 07:52 | "Bitte lies stets alle Workflow Rueckkehrer vollstaendig [...] sonst verbuche in  | Haeppchen-Regel |
|              | haeppchen"                                                                        |                 |
| 02.09. 07:55 | "Wir haben mit diesen Fragen ein ernstes Problem, bitte liste die letzten 10      | Register        |
|              | workflows auf und den Fakt, dass wir den fold rest und das rueckfragen audit      | 56611a41 +      |
|              | zusammenschalten mussten, um wirklich alle offenen Rueckfragen zu erfassen"       | KON137-09       |
| 02.09. 08:00 | "Ja, fahre den A2.3a-Workflow mit der Fold-Auflage, dann weiter wie gehabt"       | v2 -> v3 -> v4  |
| 02.09. 08:07 | "Und du hast jetzt wirklich alle rueckfragen folds, alle rest folds und die       | Welle 2 (4      |
|              | gesamte logische Kette unbeantworteter Fragen [...] in den a23a workflow gepackt?"| Leser) in v3/v4 |
| 02.09. 16:59 | "aber sequentiell" + "gleicher Umfang"                                            | Sequenz-Regel   |
| 02.09. 17:04 | Stufe auslaufen lassen, reiche Uebergabe (1705Z)                                  | vollzogen       |
| 04.09. 18:13 | "resume ALLE Agenten und Workflows" + "untersuche mit ultracode [...] letzten 3   | #182 Script,    |
|              | Kontexte auf vergessene Arbeit"                                                   | nie gestartet   |
| 04.09. 18:29 | Neustart-Order (Satz + Kill nach Workflow-Ende)                                   | vollzogen       |
| 04.09. ~19:3x| "Workflow und Agenten Rueckkehrer IMMER vollstaendig liest und verbuchst"         | Memory 4. Setz. |
| 04.09. 19:43 | "Bitte stoppe alle workflows und untersuche die vorhandenen Ergebnisse"           | Abschn. 27-30   |
| 04.09. ~19:45| "maximal 2 Fable Agenen insgesamt" (K29); ~20:0xZ "maximal 2 Agenten gleichzeitig"| Regel + v4      |

Vorangegangene Schritte (die Kette, die A2.3a speist): FOLD 157 IDs (30.08.-01.09., #159) -> 30-Kontexte-TRACE +
NACHFOLD (01./02.09., #168: 37 Owner-Fakten, R1-Tafel 109 vergessene Posten, O-1..O-29, V-090, EINGANG 61 Fragen) ->
RASTER W-2/V-109 + NACHARBEIT (02.09., #170: Nenner 277, V-110..V-148, Raster-Zulieferung 35 F2-Bloecke) ->
VOLLLESUNG r18-r30 (02.09., #171: 62 Rettungen, 159 Owner-Worte ohne Ledger) -> EXPLORE-10K (02.-04.09., #174:
G-01..G-16 A2.3a-Eingaenge) -> A2.3a v3 (16 Map-Dateien) -> v4 (laeuft). Offene Auftraege AN DER VORLAGE (alle noch
aktuell, Sperren-Tafel S-1..S-9): S-2 V-090 (a)-(w) einarbeiten (v4 MapRest fertig 20:27Z, 69.5 kB); S-5 OG 58/58
(liegt); S-6 S12/B-18-Deklaration im Kopf UND in der Chat-Fassung; S-8 RT-35/RT-38/RT-61/RT-62(e)(g)/RT-44/RT-56 als
Posten; S-9 Versand-Tafel ERSETZT die Rohliste 07:54Z (0 Owner-Antworten darauf); dazu Lens-Auflagen (nicht erneut
fragen; Vollzaehligkeit je Nummernkreis; Dopplung/Alias), Buendel-Auflagen (S01/B-14+S06/B-21(ii); E-13+R4; FK-7+
Fuenftes-Token; S06/B-25+#152; Rechts-Trio), Form V-090(u)/(v), Nenner-Historie 45 -> 35 -> 60 -> 283 im Kopf.
Nach Terminal: Rueckkehrer VOLL lesen (Haeppchen), CHAT-FASSUNG 1:1 posten, Owner-Antworten verbuchen, dann #176.

## 3. DAS GESETZTE ZIEL UND DIE AUFGABEN -- IN EIGENEN WORTEN (letzte 15 Kontexte, K069-K084, 24.08.-04.09.)

Das Ziel ist unveraendert seit GOAL v8: bis zur Abgabe am 15.09. eine Cache-Engine, deren gesamte Mess- und Bau-
Kette aus EINER Einstiegs-XML entsteht -- Planer -> Tier-Binaries (524288 im Voll-Bau-4, 224 GB Lager) -> Messung
auf den beiden Hosts -> xlsx/csv -> LaTeX-Anhang -> PDF der Diplomarbeit -- reproduzierbar, fail-loud, mit Stempel-
Identitaet je Binary und mit den fuenf Pruefungen des TDD-Vertrags als Abnahme. Der kritische Pfad ist seit dem
T-Entscheid vom 28.08. festgelegt: Trigger ##49 (Voll-Bau-4) -> Funktionsnachweis (Bau + Kampagne) -> Monolith-Split
W7 -> restliche Wellen; nichts wird gestrichen, nichts nach der Abgabe verschoben.

Die Aufgabe der letzten 15 Kontexte war NICHT, neue Features zu bauen, sondern die Voraussetzung dafuer wieder
herzustellen, dass gebaut werden DARF: Der Owner hat am 25./26.08. verlangt, dass jede offene Entscheidung mit vollem
Kontext vorliegt und dass nichts gefragt wird, was er schon beantwortet hat -- und am 01.09. die Reihenfolge gesetzt:
erst die vollstaendige Fragen-Vorlage, dann seine Antworten, dann das dichte Ledger, dann weiter auf dem Trigger-Pfad.
Parallel dazu wurden die harten Blocker gelandet (E-10 Stempel/Identitaet, E-1 CI-Zombie-Fix, E-4 Thesis-Rewrite nach
Secret-Leak, Stempel Teil 2, Push-Fenster), damit der Trigger technisch startbereit ist (##47-Kalibrierlauf gruen auf
amd, intel wartet auf E-2/C-02).

## 4. WARUM ZWEI WOCHEN "SPEZIELLE WORKFLOWS"

1. Der Bestand offener Owner-Fragen lag NICHT an einer Stelle. Er war ueber sieben Nummernkreise verstreut (Ledger-
   Sektionen S01-S12, R1 V-001..V-148, F-001..F-040, O-1..O-29, V-090(a)-(v), OG-1..OG-58, F2-Fenster-Bloecke),
   entstanden in 30 Kontexten seit dem 20.08.; Ledger-Rewrites hatten Posten verloren (RV-1..RV-10), und Zusagen aus
   dem Chat (Minimalantwort, D-10-Antwort, V-111) waren nie geliefert. Das war der Befund vom 23.08. ("zusammenhangs-
   los") und vom 02.09. ("ernstes Problem").
2. Die Owner-Doktrin verlangt Vollstaendigkeit statt Auswahl: nie kuerzen, jede Rueckkehrer-Datei voll lesen, jede
   Frage per 12-Wochen-Explore gegen "schon beantwortet" absichern, SOLL = PFLICHT. Diese Pruefung ueber ein Korpus
   von ~107.000 Transkript-Zeilen + 35.000 Ledger-Zeilen + 181 Board-Tasks passt in keinen einzelnen Kontext; sie geht
   nur als Map-Reduce mit vielen Lesern und adversarischen Lenses -- daher Fold, Trace, Nachfold, Raster, Volllesung,
   Explore-10K, A2.3a.
3. Die Qual kam aus dem Betrieb, nicht aus dem Plan: zwoelf Risse (Session-Limit, Fable-5-Kontingent, Owner-Interrupt)
   toeteten parallele Agenten mitten in der Arbeit; jeder Riss hinterliess Torsi und Pseudo-Results, die vor einem
   Resume geerntet werden mussten; der Praefix-Cache (K27) erzwang byte-gleiche Resumes; drei parallele Fable-max-
   Workflows frassen ein frisches Kontingent in Minuten. Das kostete Kontexte fuer Wiederanlauf-Rezepte, Riss-
   Register, Uebergaben und Re-Lesungen statt fuer Substanz.
4. Die Lehre steht seit heute als Regel: maximal 2 Agenten gleichzeitig, ein Workflow zur Zeit, fertige Ergebnisse
   als Datei-Eingang (nie neu erzeugen), inkrementelles Schreiben, Transkript-Ernte vor jedem Resume. Der v4-Lauf ist
   der erste, der so gebaut ist.

## 5. RUECKKEHR-PLAN (Reihenfolge, ein Workflow zur Zeit)

1. v4 terminal -> Rueckkehrer VOLL lesen (Fold-Tafel, Versand, Chat, Schablone, 3 Lenses, Fix) -> Chat-Fassung 1:1
   posten -> Owner antwortet in EINER Nachricht -> Antworten verbuchen (Board #175, KON137-10ff.).
2. #179 Thesis-LICENSE: Resume wf_d69f800c byte-unveraendert (Explorer A nachholen, Design, Bau, 2 Lenses, Landung
   thesis dev/main + super-Gitlink; Fan-out nie > 2); vorher S01-Vorflug neu messen; die 6 ungepushten super-docs-
   Commits gehen im selben Push-Fenster raus.
3. #182 Explore-3K: Script auf 2er-Paare umbauen, dann starten; Delta in die Vorlage nachtragen (Fix-Stufe).
4. #176 docs-Zug (dichtes Ledger KON136-04..08 + KON137) NACH den Owner-Antworten; danach #177/#178/#180/#181, dann
   Trigger-Pfad (##47-Re-Run-3 owner-gated E-2/C-02, K28; ##49).

## 6. NAS-SICHERUNG (Owner-Order 04.09.)

Designierter Ordner: /mnt/backup2-nfs/sessions-rohdaten/ (10.0.20.242 PR2100; Praezedenz k145-wf_434ae6ec-a0c vom
12.08. = Agent-Transkripte eines Runs). Neu: sessions-rohdaten/k084-woche-20260827-20260904/ mit runs/<wf_id>-<script>/
(journal.jsonl + agent-*.jsonl + meta), scripts/, task-outputs/, subagenten-lead/, beweisorte/ (~/backups-workflow
27.08.-04.09. inkl. Torsi). rsync -a --ignore-existing (additiv, nichts ueberschrieben/geloescht), chmod go-rwx.
Rohdaten enthalten bekannte Token-Fundstellen (wf_78955b71 Runner-Tokens prod2 17+56; wf_4fc4b8d9 289-runners_token)
-> Vermerk unten, Rotation = #152; das Haupt-Session-Transkript ist NICHT enthalten (nicht beauftragt, OAuth-Codes).
Nenner + Secret-Scan-Ergebnis: siehe NACHTRAG am Dateiende (nach Abschluss des Hintergrundlaufs).

Selbstcheck: ASCII, <= 120 Spalten, Zahlen aus Journalen/Scripts/Task-Outputs, keine Secrets, keine Koeder.

## 7. NACHTRAG NAS-SICHERUNG (04.09. 20:33-20:58Z, Lead)

Erster Pass 20:33-20:41Z (rsync -a --ignore-existing; NFS verweigert chgrp = rc 23 nur Attribut, Daten vollstaendig):
runs/ 28 Ordner 1520/1520 Dateien, task-outputs/ 927, subagenten-lead/ 4, scripts/ 11, beweisorte/ 4488/4488;
gesamt 6956 Dateien, 786 MB. Nachpass (-rlt, ohne owner/group, additiv) + Vollkopie aller wf_*-Runs nach
runs-nachpass/ laeuft beim Schreiben noch; Zaehler im INDEX.md auf dem NAS. INDEX.md + REGISTER.md (Kopie dieses
Dokuments) liegen im Ordner, chmod go-rwx.
SECRET-SCAN (7 Muster, nur Klassen/Zaehler): 55 Treffer-Dateien -> P7 runners_token 286/287/288 in 6 API-Dumps der
Beweisorte (27.08. lande-reif ce-push r4-projekt-*.json; 01.09. e1-ci-zombie-fix design-fix/api-project-*.json + lenses/
proben-r3/fable-r3-proj-288.json) = ECHT -> REDIGIERT (Wert -> REDACTED-sha256[:8]) lokal UND NAS, chmod 600, Vermerk
REDAKTION-0409.md je Beweisort; P1 glpat: COMDARE_THESIS_WRITEBACK_TOKEN (PAT id=98, 53 Zeichen, in CI masked+protected,
aber im Variablen-Dump im Klartext) in 2 Lens-Dumps seit 01.09. mit Rechten 664 = ECHT -> REDIGIERT lokal UND NAS; 2
Transkript-Treffer = Koeder-Kontext; P2 glrt prod2 Runner 17+56 in 1 Transkript = ECHT (bekannt, #152) -> NAS-Kopie
redigiert, lokales Transkript unveraendert; P6 codex-OAuth-Codes in 25 NAS-Transkripten L-13-maskiert (lokale
Transkripte unveraendert); P4 AKIA 13 Dateien / 2 distinkte Werte ohne EXAMPLE-Form = gitleaks-Koeder-Klasse (nicht am
Objekt verifiziert); P5 1 Textnennung 'BEGIN PRIVATE KEY' ohne END-Block = kein Schluessel. Gegenprobe nach Redaktion:
P7 0, P1-vars 0, P2 0, P6-unmaskiert 0. NEUE ROTATIONS-POSTEN an #152: PAT id=98 (Wert lag 3 Tage mit 664 auf prod1) +
runners_token 286/288 (zusaetzlich zu 287/289). Haupt-Session-Transkript ist NICHT auf dem NAS (nicht beauftragt).
