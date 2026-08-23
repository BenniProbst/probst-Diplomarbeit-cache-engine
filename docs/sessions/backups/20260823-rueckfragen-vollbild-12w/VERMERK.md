# RUECKFRAGEN-VOLLBILD 12 WOCHEN — BEWEIS-SICHERUNG (So 23.08.2026)

Owner-Order 22.08. spaet: "Weiterhin hast du mir immer noch nicht alle noch offenen
Rueckfragen mit viel Kontext und den Erklaerungen der Zusammenhaenge geliefert und gegen
meine Antworten ueber die letzten 8 Kontexte verbucht. Die Fragen waren erneut
zusammenhangslos. Bitte starte einen Opus 5 max ultracode Leser, um die noch offenen Fragen
alle zu finden und deren Zusammenhaenge ueber die letzten 12 Wochen, je Kontext einzeln mit
Opus 5 max, tief zu lesen und mit Fable 5 max zum Schluss auszuwerten."

## 0. STAND

- Workflow `wf_bce0efd4-a0d`, TERMINAL 117/118 Agenten. **Alle 116 Kontext-Leser durch.**
- **NUR die Fable-5-max-Synthese fehlt** — sie starb am Fable-Kontingent ("You've reached your
  Fable 5 limit"). Das war vom Owner beim K30-Ende ausdruecklich vorhergesagt und akzeptiert.
- Verbrauch: 32,6 Mio. Subagent-Tokens, 3860 Werkzeugaufrufe, 3 h 11 min Laufzeit.
- Form: 10er-Batches parallel (Owner-Order 23.08. nachmittags), Modell Opus 5 max je Fenster.
- Alle 117 Returns wurden vom Lead VOLL gelesen (Dauerregel 22.08.).

## 1. WAS HIER LIEGT

`fenster/` — 139 Ergebnis-Dateien, 83.240 Zeilen: je Kontextfenster ein voller Bericht
(Zaehlwerk, Frage-Inventar, Owner-Antworten nach Quellen, Zuordnungs-Bilanz, Funde).
`KARTE.md` — die Fenster-Kartierung (116 Fenster ueber 5 Transkript-Dateien).

🔴 **NICHT hier (und NIE committen):** die `*-arbeit/`- und `*-roh/`-Verzeichnisse unter
`~/backups-workflow/20260823-rueckfragen-vollbild/` (490 MB). Sie tragen unredigierte
Transkript-Kopien mit **Live-Tokens** (ausdruecklich vermerkt im A39-Return). Nur die
Ergebnis-Markdowns sind gesichert. gitleaks: Koeder biss (leaks found: 1), Echt-Scan
6,34 MB "no leaks found".

## 2. KARTIERUNGS-BEFUND (korrigiert die Auftragsannahme)

116 Fenster statt der erwarteten ~31: **A=61** (5a19728e, 06.08.-23.08., LAUFEND) ·
**B=49** (46375cdc, 06.07.-16.08.) · **C=1** · **D=1** · **E=4 Splitter-Sessions**.

Drei Fallen, die der Kartierer belegt hat:
1. **A und B liefen PARALLEL, nicht nacheinander** (06.08.-16.08. gibt es Fenster in beiden).
   Eine Chronologie, die die Dateien aneinanderhaengt, ist falsch — nach Timestamp mischen.
2. Eine 1,1-MB-Datei hat nur 18 Zeilen, alle `file-history-snapshot`: Groesse taeuscht Inhalt vor.
3. Die vier Splitter-Sessions (15-18 Zeilen) fielen unter die Platzhalter-Regel, tragen aber je
   genau EINEN echten Owner-Prompt — Wegwerfen erzeugt falsches Owner-Schweigen.

🔴 **ECHTE LUECKE 31.05.-05.07.2026:** in keinem Projektordner existiert ein Transkript vor
dem 06.07. 09:31 UTC. B01 ist ein echter Sessionstart ohne Compact-Vorspann. Die ersten
5 der 12 angefragten Wochen sind **nicht abgedeckt** — kein Nullbefund, eine Luecke.

## 3. DER METHODEN-KERN: ES SIND NICHT VIER QUELLEN

Der bisher verwendete Vier-Quellen-Extraktor (`~/backups-workflow/20260822-anschluss-leser/
extraktor-vier-quellen.py`) hat **zwei gegenlaeufige Defekte**, beide vielfach unabhaengig belegt:

**(a) FALSCH-NULL — mindestens fuenf weitere Owner-Quellen fehlen ihm:**
| Klasse | Form | Belege |
|---|---|---|
| Q5a | `type=system` + `subtype=local_command` (`/btw`) | A05, A45, A60, B02 |
| Q5b | `promptSource=="suggestion_accepted"` (origin human) | A29 (L52119 "GO maximal parallel"), B01, B43 |
| Q5c | Slash-Argumente (`/goal`, `/compact`) ohne promptSource/origin | A02, A26, B09, B11, B12, B39, B43, B44 |
| Q5d | `AskUserQuestion` -> `toolUseResult.answers` | A18 (2 pfadwirksame, u.a. Scrub-Kanon) |
| Q5e | `ExitPlanMode`-Ablehnung im `toolUseResult` | B10 (schwerste Nachricht des Fensters) |
| Q5f | `last-prompt` (Fenster direkt nach Compact) | A58 |
| Q6 | alter Goal-Wortlaut in `stop_hook_summary -> hookInfos[].command` | B02 |
| Q7 | Owner-Frage nur im task-notification-Summary als Agentenname | A15 |
| — | Juli-Format traegt gar kein `promptSource` -> UNION=0 | B03 (angepasster Extraktor liegt) |

**(b) FALSCH-POSITIV — `<agent-message from="...">` wird NICHT gefiltert**, weil `ist_owner_text()`
nur auf "Another Claude session sent a message:" prueft. Ueberzaehlung: A16 80 % (6 von 9),
B41 60 von 93, B42 84 von 130, A02 26 %. Zwei Spiegelfaelle: A55 fand ein `queued_command`
mit `origin.kind=human`, dessen Inhalt die **Assistenten-Vorlage** ist (wer das als Owner-Wort
liest, bucht eigene Vorschlaege als Owner-Festlegungen); E03 fand eine **Phantom-Owner-Nachricht**,
die alle Merkmale erfuellt und reines Terminalrauschen ist.

**Fix-Rezept:** `NICHT_OWNER` um `<agent-message` / `<task-notification` erweitern (Praefix-Pruefung
am Textanfang) UND `promptSource in ("typed","suggestion_accepted")` UND Q5a-Q5f nachziehen.
Korrigierte Extraktoren liegen in `B03-arbeit/extraktor-b03.py`, `B37-arbeit/extraktor-b37.py`,
`B01-arbeit/ext5.py`.

**Wirkung der Falsch-Null (gemessen je Fenster):** eine reine `type=="user"`-Ernte sieht im
Median rund die Haelfte der Owner-Nachrichten. Spitzenwerte: **A37 100 % unsichtbar (5 von 5)**,
A59 90 %, B25 84 %, A47 83 %, B16 83 %, B15 77 %, B29 72 %, A11 60 %.
Was dabei verloren geht, ist nicht Beiwerk, sondern der Kern: GOAL-v8-Setzung (A11), der
HEURISTIK-ADAPTER-Architekturentwurf (A11), "Der Planer ist ZWINGEND eine eigene binary" (B48/C01),
die dreistufige Mess-/zweistufige System-Achsen-Setzung (B48), "NIE rebase, immer merge" (B19),
"Keine Behelfswege" (B18), die NIE-KUERZEN-Urzelle (D01/B49), die Notfall-Pause waehrend des
PAT-History-Rewrites (B34) und die Owner-Selbstkorrektur "alles mergen GLEICHZEITIG" (A60).

## 4. DIE ACHT VERFALLS-MECHANIKEN (jede am Objekt belegt)

1. **Frage lebt nur in der Task-Liste / in einer Datei, nie in einer Nachricht.**
   A04 misst die Trennschaerfe mit 100 %: 19 Fragen in einer Nachricht -> 0 verfallen;
   6 Fragen nur in der Taskliste -> 6 verfallen. A05 zeigt zwei Posten, die je **21x im
   Fenster** erscheinen — ausschliesslich als Task-Listen-Einspiegelung, 0x in einer Nachricht.
2. **Doppelfrage:** der Owner beantwortet die erste Haelfte, die Antwort loescht die ganze
   Frage (B17 systematisch; A19 NFS-Token neben MinIO; B25 zwei Fragen in einer Tabellenzelle).
3. **Sammel-Etikett frisst Einzelfragen:** "acht Formsachen" (A59), "die offenen
   G7-User-Punkte" (B34), "u.a." nach 4 von 13 genannten Punkten (A03).
4. **Nachsatz am Ende einer langen Nachricht:** B40 — alle drei Verfallenen des Fensters
   standen so, alle 31 nummerierten Block-Posten kamen vollstaendig zurueck.
5. **"Default laeuft" / NUR-KENNTNIS-Block:** B48 — alle 3 Verfallenen standen dort,
   36 von 36 nummerierten Fragen mit Empfehlung wurden beantwortet.
6. **Zeitliche Verdraengung:** A18 — drei Posten starben, weil die naechste Owner-Nachricht
   **35 Sekunden** spaeter zu einem anderen Thema kam (Kostenfolge belegt: PAT 54 wird 4 Tage
   spaeter zum OF-4-Kern).
7. **Nummern-Drift und Label-Kollision:** A06 (`O-C` traegt zwei unverbundene Sachfragen mit
   zwei verschiedenen Antworten), A17 (Owner-"Frage 6" trifft einen anderen Gegenstand —
   Doppelschaden: unbeantwortete Frage gilt als beantwortet UND ein fremder Entscheid wird
   unter falscher Nummer verbucht), A31 ("OF-1" bezeichnet im selben Fenster **vier**
   verschiedene Gegenstaende), B39 (Owner korrigiert selbst: "Also Frage 1 die vorher Frage 4 war").
8. **Compact frisst die Zuordnung:** A10 — die gesamte Acht-Fragen-Antwortrunde faellt 1 Sekunde
   nach der Compact-Grenze; im Fenster wird keine einzige Antwort quittiert.

## 5. DAS HEILREZEPT IST SIEBENFACH BELEGT — UND ES IST IMMER DASSELBE

| Fenster | Vorher | Nachher | Ergebnis |
|---|---|---|---|
| B15 (08.07.) | 5 abstrakte Enabler-Vorlagen | "bitte stelle die Fragen verbose" -> Klartext + (a)/(b) | 4 Owner-Nachrichten in 90 s, erste nach 32 s |
| B18 (12.07.) | 14 verstreute Einzelfragen | EINE konsolidierte Vorlage (GO 1-5 + Frage 6 + 7) | 0/14 -> 8/8 in einer Nachricht |
| B24 (17.07.) | Q2 zu duenn -> Owner vertagt | 5440-Zeichen-Neuvorlage A/B/C + Empfehlung + Ehrlichkeits-Absatz | "Option C, GO" + Plan-Erweiterung um eine 6. Achse |
| B42 (01.08.) | 2670 Zeichen, "Ich verstehe nur Bahnhof" | 7010 Zeichen mit Herleitung + Zahlen (4->524.288 vs. 12->1.572.864) | sofort vollstaendig beantwortet |
| A03 (06.08.) | verstreute Posten | F-14-Format: Frage/Empfehlung/Begruendung/Konsequenz beider Wege/Dringlichkeit | **9/9 = 100 %**, Reaktion 17 min |
| A32 (15.08.) | nackte Nummernliste, 8 Entscheide | 10.919 Zeichen, je Frage Zusammenhang/Was-getan/Warum-frage-ich/Empfehlung | 7 von 8 in 56 min |
| A31 (14.08.) | "B7: Zu wenig Kontext" (2x geruegt) | Lage-Absatz + Frage + Optionen + Empfehlung + jedes Flag an einem Beispiel-String | vollstaendige Antworten |

**B46 formuliert die Regel am schaerfsten:** der Owner antwortet zu **100 %**, wenn ein Punkt
mit Sachlage kommt (Latenz 3 bzw. 5 min) und zu **0 %** auf die Listen-Vorlage. Die Ursache
ist die fehlende Sachlage-Zeile je Frage, nicht Owner-Schweigen.
**A50 zieht die Konsequenz:** "Nicht die Fragen waren zusammenhangslos — der TRANSPORT war es.
Der Zusammenhang lag vollstaendig vor und wurde nicht mitgeschickt."

## 6. DIE RUEGE VOM 22.08. HAT SIEBEN VORLAEUFER

- **06.07.-08.07.** B15: "bitte stelle die Fragen verbose, ich verstehe dich nicht"
- **16.07.** B23: "Ich kann die Frage nicht beantworten, weil die Konstruktionslogik generell fehlt"
- **26.07.** B38: vier Ruegen derselben Klasse ("ich wiederhole mich ungern")
- **01.08.** B42 O-24: "Ich verstehe nur Bahnhof — bedenke das Projekt ist sehr gross"
- **06.08.** D01/A01 N-09: **"du schreibst zusammenhanglosen Mist"** (das Wort "erneut" in der
  23.08.-Ruege hat hier seinen Beleg; die damals wirksame Heilung steht ausformuliert da:
  erzaehlend statt Kuerzel, jeder Begriff aufs Owner-Ziel zurueckgefuehrt)
- **15./16.08.** A32/A33: "ich verstehe es nicht ohne den Zusammenhang" · "Bitte stelle mir all
  diese Rueckfragen nochmal im gesamten Zusammenhang mit Erklaerung des aktuellen Standes,
  ich kann so leider nichts entscheiden"
- **21.08.** A54: "Leider kann ich in dieser Knappheit nichts entscheiden und du scheinst auch
  noch keinen Ueberblick ueber den aktuellen Stand zu haben"

🔴 **A61 stellt fest: die Ruege selbst ist NICHT verbucht** — kein KON-Eintrag, kein
Arbeitsfehler-Memory ("zusammenhangslos" = 0 Treffer im Memory-Verzeichnis). Nur der
resultierende Auftrag ist verbucht.

## 7. NULL-FRAGEN-FENSTER: DIE STILLE IST MESSBAR

Mehrere Fenster produzieren Owner-Fragen und stellen keine einzige:
- **A37:** 33 fertige Owner-Fragen, **0 Fragezeichen** in 27 Textbloecken; 13 F2-kritische Fragen
  traegerlos (Board-Messung: 0 Treffer fuer 'VORAB'/'V-01'/'V-13' bei 58 'Owner'-Treffern).
- **A51:** 14 h 51 min, 0 Fragen, 19 heute faellige Posten verfallen im Fenster.
- **A50:** vollstaendiger 58er-Owner-Frage-Katalog trifft ein, wird nachweislich voll gelesen —
  **0 von 58 vorgelegt**; die einzige Beruehrung ist ein Halbsatz aus 16 nackten Kuerzeln.
- **A35:** 20 Owner-Entscheide als EIN Absatz mit Mittelpunkt-Trennern am Ende eines
  8.581-Zeichen-Berichts; Owner antwortet 33 s spaeter zu anderem Gegenstand — Trefferquote 0/20.
- **A41:** 6-Punkte-Absatz "OFFEN BEIM OWNER" um 20:56 — um 21:15 auf die Owner-Frage
  "Hast du derzeit noch offene Rueckfragen?" die Antwort **"Keine offenen Rueckfragen"** (19 min spaeter).
- **A52:** 35 Vorlage-Bloecke, nur 4 im Gespraech genannt, 31 nie ausgesprochen — und der gesamte
  Fragenbestand blieb **ungepusht** (0 `git push` im Fenster), also auch ueber die Remotes unsichtbar.
- **A26/A27/A28/A53/B35:** je 0 gestellte Fragen ueber 2-9 Stunden, mit dreifacher Gegenprobe belegt.

## 8. FRISTKRITISCH OFFEN (Stand 23.08., aus den juengsten Fenstern)

| Posten | Frist | Lage |
|---|---|---|
| 🔴 **R7 / D-09 RunMethodology-Enum-Ordnung** | **Mi 26.08. 06:00** | Stempel-/ABI-/CSV-Bytes; Aenderung danach entwertet ~41 h Flottenbau. In A56 gestellt, als R7/F-02 wiedervorgelegt, **5x nachgehalten**, nie beantwortet |
| 🔴 **D-08 A/B Emitter-Weiche** | Default A ab **Di 25 abends** | identitaetswirksam; Uhr laeuft, **ohne dass die Frage je beantwortet wurde** (A58/A61) |
| **F-09 S-19-Schema O2/O3** | war "vor dem s13schema-Merge" | der Merge fuhr am selben Abend trotzdem (A59) |
| **C-3a / #38a1** | Mi 19.08. — **VERSTRICHEN** | lief still in Fallregel 18.6(3); am Fristtag in 8 h kein einziges Mal erwaehnt (A45) |
| **V-14 root-Platte prod1** | vor Sa 22.08. — **UEBERFAELLIG** | Assistent misst die Platte 2x und fragt nie (A50/A53) |
| **F-13 Codex-Scope** | vor main-FF | einzige verbliebene main-FF-Restbedingung |
| **Infra-Slot / Rotation** | "vor Mi 26." | nur EINMAL genannt (A48), Termin-Datums-Widerspruch Do/Fr ungeklaert (A44/A45) |

## 9. LEDGER-LUECKE

🔴 **KON122 existiert nicht** (`grep -c KON122` = 0; Gegenprobe KON121 = 2). Der Ledger-Kopf ist
die NACHTRAG-Position e6c90277 vom 22.08. 14:09. **Alles, was der Owner danach sagte, ist
un-ledgered** — darunter drei neue Dauerregeln (Kipp-Ritual-Aenderung, O-6/O-8 "gleichzeitig",
O-9 "nie uninformiert"), die nur im Memory leben. A60 misst: 15 von 19 Owner-Antworten des
Fensters sind nicht im Ledger; A61 misst 0 von 8.

## 10. WAS JETZT NOCH FEHLT

Die **Fable-5-max-Synthese** (`RUECKFRAGEN-TAFEL-V3-REICH.md` + `VERBUCHUNGS-ABGLEICH-8K.md`).
Sobald Fable-Kontingent zurueck ist:
`Workflow({scriptPath: ".../rueckfragen-vollbild-12w-wf_bce0efd4-a0d.js", resumeFromRunId: "wf_bce0efd4-a0d"})`
— alle 116 Leser kommen aus dem Cache, nur die Synthese-Stufe laeuft.

Bis dahin ist dieses Verzeichnis die vollstaendige Beweislage; die Tafel ist daraus
zusammenzusetzen, nicht neu zu erheben.
