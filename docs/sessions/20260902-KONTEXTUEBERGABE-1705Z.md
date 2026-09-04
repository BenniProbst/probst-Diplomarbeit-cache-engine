# KONTEXTUEBERGABE 02.09.2026 17:05Z -- Lead-Session 5a19728e (Fable 5 max)

Owner-Order 17:04Z (verbatim): "thesis license zug ist am spend limit gestorben und von a23a laeuft nur noch die
Haelfte, aber wir lassen die aktuelle Stufe durchlaufen und resumen erst, wenn die naechste Stufe dieser workflows
beginnt, um keine tokens durch Neustart zu verschwenden, lass diese Stufe noch auslaufen. Bitte schreibe eine reiche
und elaborate Kontextuebergabe, der Kontext endet jetzt"

Vorgaenger-Uebergabe: docs/sessions/20260902-KONTEXTUEBERGABE-0750Z.md (Commit 786437a5) -- gilt weiter, dieses
Dokument traegt NUR das Delta 07:50Z -> 17:08Z plus die neuen Regeln. Beide zusammen lesen.

Ritual fuer den Nachfolger (Memory feedback_nach_jedem_compact_...): ARBEITSWEISE-DICHT + Memories der letzten 3 Tage,
NICHT das /goal-Trio voll; Paragraph-Nachschlag erlaubt. Dann Abschnitt 3 (Workflows) und Abschnitt 6 (Reihenfolge).

## 0. Kurzbild in fuenf Zeilen

1. Drei Workflows: Explore-10K (A) laeuft in der Reduce-Stufe, A2.3a v3 (B) laeuft mit ~10 lebenden Map-Agenten,
   Thesis-LICENSE #179 (C) ist TERMINAL failed (eigene Doktrin-Wache, 1/2 Explore im Cache).
2. NEUE OWNER-REGEL 17:04Z: laufende Stufe AUSLAUFEN lassen; Resume ERST, wenn die naechste Stufe beginnen wuerde;
   dazu weiter die Regel 16:59Z: SEQUENTIELL (ein Workflow zur Zeit), GLEICHER UMFANG (nichts kuerzen).
3. Riss 9 (16:58Z, Fable-5-Kontingent, resets Sep 4 6pm UTC) = vierter Riss dieses Kontexts (6/7/8/9), 0 Datenverlust.
4. Repo-Staende unveraendert seit 0750Z (Abschnitt 1); super traegt 2 (jetzt 3) lokale, NICHT gepushte docs-Commits.
5. Offene Kette unveraendert: A2.3a-Chatfassung -> Owner-Antworten -> dichtes Ledger #176 -> #177/#178/#180/#181.

## 1. Repo-Staende (Nachmessung 17:08Z, keine Bewegung seit 0750Z)

| Repo      | dev == main | Remotes            | Bemerkung                                                             |
|-----------|-------------|--------------------|-----------------------------------------------------------------------|
| super 288 | 35ed801f    | origin+github      | lokal +786437a5 +56611a41 (+dieser) NICHT gepusht, porcelain 0 |
| ce 286    | 53150058    | origin+github      | E-1-Landung, CI 16305/16308 gruen                                     |
| prt-art   | b539d6ee    | origin+github      | unveraendert                                                          |
| thesis    | cbefa617    | origin+github      | GitHub PUBLIC seit 01.09. 13:30Z OHNE LICENSE -> #179                 |
| Umbrella  | 6ae5771     | origin             | unveraendert                                                          |
| Cluster   | 72c205c1    | origin             | unveraendert                                                          |

Platte: df / = 29G frei (17:08Z). Keine Worktrees angelegt in diesem Kontext (Worktree ~/wt-thesis-license fuer #179
wurde NICHT angelegt, der Bau kam nie dran).

## 2. Owner-Orders dieses Kontexts 07:47Z -> 17:04Z (verbatim, mit Vollzugsstand)

| Zeit   | Order (verbatim)                                                                          | Stand           |
|--------|-------------------------------------------------------------------------------------------|-----------------|
| 07:47Z | "Hast du jetzt das dichte Ledger unter meinen Rueckfragen schon erstellt? Bitte stelle mir | vollzogen      |
|        | alle offenen und nicht durch explore aufloesbaren Fragen hier. Es gibt ueber die letzten  | (Antwort NEIN,  |
|        | Kontexte einige gerissene Straenge. Bitte erstelle eine Kontextuebergabe, der Kontext     | Tafel im Chat,  |
|        | endet jetzt"                                                                              | Uebergabe 0750Z)|
| 07:52Z | "Bitte lies stets alle Workflow Rueckkehrer vollstaendig, wenn moeglich, pruefe ob das    | DAUERREGEL im   |
|        | Ergebnis nicht zu gross ist, sonst verbuche in haeppchen"                                 | Memory verankert|
| ~08:0xZ| "Wir haben mit diesen Fragen ein ernstes Problem, bitte liste die letzten 10 workflows    | vollzogen       |
|        | auf und den Fakt, dass wir den fold rest und das rueckfragen audit zusammenschalten       | (Register-Doku  |
|        | mussten, um wirklich alle offenen Rueckfragen zu erfassen"                             | 56611a41+KON137-09)|
| ~08:1xZ| "Ja, fahre den A2.3a-Workflow mit der Fold-Auflage, dann weiter wie gehabt"               | Workflow B v2   |
| ~08:3xZ| "Und du hast jetzt wirklich alle rueckfragen folds, alle rest folds und die gesamte       | NEIN -> 4 Lue-  |
|        | logische Kette unbeantworteter Fragen und der noch nicht gelesenen teile der workflow     | cken -> v3 mit  |
|        | Rueckkehrer in den a23a workflow gepackt?"                                                | Welle 2         |
| mehrf. | "Bitte halte kurz inne" / "Bitte weiter wie gehabt, ich wollte dich nicht unterbrechen,   | je vollzogen    |
|        | frische credits mussten her, bitte lese den letzten workflow Rueckkehrer wie gehabt       | (Riss-Rezepte   |
|        | weiter" / "Bitte heile und resume alle Agenten und workflows, dann weiter wie gehabt" /   | 7, 8, 9)        |
|        | "Bitte fahre fort wie gehabt, credits sind wieder frisch" (2x)                            |                 |
| 16:59Z | "aber sequentiell" + "gleicher Umfang"                                                    | Sequenz-Regel   |
| 17:04Z | siehe Kopf dieses Dokuments                                                               | DIESES Dokument |

Interpretation der 17:04Z-Order (Lead, fuer den Nachfolger bindend, bis der Owner anderes sagt):
- KEIN Resume, solange in einem der Workflows noch Agenten der laufenden Stufe leben.
- Der Trigger fuer das Resume ist der BEGINN der naechsten Stufe: sobald der lebende Workflow-Prozess die naechste
  Stufe anfassen wuerde (und dort an den toten Agenten scheitert bzw. sie fehlen), wird resumt -- nicht vorher.
- Praktisch: Stufe gilt als ausgelaufen, wenn (a) journal.jsonl 5 min ohne Wachstum, (b) keine agent-*.jsonl im
  Run-Ordner mit mtime < 5 min, (c) die Task-Notification (Task-ID unten) eingetroffen ist. Erst dann Abschnitt 3.4.

## 3. Die drei Workflows -- Endstand 17:08Z, Rezepte, Sperren

Run-Ordner (Journal = Wahrheit): ~/.claude/projects/-home-comdare/5a19728e-f6e1-4736-a246-e3fda9ac35a1/subagents/
workflows/<runId>/journal.jsonl. Task-Outputs (Abschlussmeldung, bisher 0 Byte): /tmp/claude-1001/-home-comdare/
5a19728e-f6e1-4736-a246-e3fda9ac35a1/tasks/<taskId>.output. Kein Task-Output = Prozess lebt oder starb ohne Meldung.

### 3.1 Workflow A -- Explore 10 Kontexte K072-K081 (Board #174), wf_1a36d148-ffb

- Script: ~/.claude/projects/-home-comdare-backups-workflow-20260902-explore-10-kontexte-kontexte/
  5a19728e-f6e1-4736-a246-e3fda9ac35a1/workflows/scripts/explore-10-kontexte-offen-gerissen-wf_1a36d148-ffb.js
- Beweisort: ~/backups-workflow/20260902-explore-10-kontexte/ (map/ = 10 Scans K072..K081 im Journal-Cache;
  reduce/ leer; Torsi der Riss-8/9-Reduce-Versuche in riss8-pre-resume-*/ bzw. riss9-pre-resume-1658z/ beiseite).
- Task des dritten Resumes: wg91yxfte (Start 17:00Z, SEQUENTIELL Nr. 1). Journal 17:00:22Z: started=16 result=10
  (10 Scans aus dem Cache), 3 Fehlerzeilen (Riss 8/9-Reste), Reduce-Agent LEBT (Transkript-mtime 17:04:55Z, um
  17:08Z noch 1 lebender Agent). Monitor bvek0x9ki laeuft (Basis err=3; letzte Zeile "EXPL-seq: started=16 result=10
  neue-err=0"); er meldet Terminal-Naehe bei >= 13 Results. Monitor NICHT stoppen, er ist die Lebendprobe.
- Stufenfolge im Script: 10 Sonnet-max-Scanner (X-14/Q1 per Design, Modell-Wache Erlaubnisliste!) -> Fable-Tieflese/
  Reduce (LAEUFT) -> Refute -> Fix. Der Reduce-Ruekkehrer ist der Zulieferer fuer A2.3a Welle 2 (map2:nachleser-
  explore-r18r30) -- deshalb Reihenfolge A vor B.
- NACHTRAG 17:12Z: Monitor bvek0x9ki meldet REDUCE-DATEI 22213 B (17:10:51) -> 32600 B (17:12:18): der lebende
  Reduce-Agent schreibt seine Tafel; danach geht der LEBENDE Prozess selbst in Refute -> Fix. Sterben dessen Agenten
  am Kontingent, ist genau DAS der Resume-Punkt fuer A (Owner-Regel 17:04Z), nicht frueher. Reduce-Datei liegt in
  ~/backups-workflow/20260902-explore-10-kontexte/reduce/ -- vor dem Resume voll lesen (Haeppchen), nie verschieben.
- Bekannter Folgefehler ohne Substanz: "TypeError reduce.datei null" nach Limit-Tod (kein null-Guard); Resume heilt.
  Script wegen K27 NICHT anfassen.

### 3.2 Workflow B -- A2.3a Owner-Vorlage mit Fold-Auflage v3 (Board #175), wf_f97550fa-4b8

- Script: ~/backups-workflow/20260902-a23a-vorlage/a23a-vorlage-map-fold-reduce-v3.js (498 Z., mtime 08:32Z; Welle 1
  byte-identisch zu v2 -> Cache-Praefix gilt, Beleg v2->v3 12/17 Cache; Welle 2 = 4 Leser map2:r1-v001-v148 /
  map2:board-owner-gated / map2:entwuerfe-dicht-widerspricht / map2:nachleser-explore-r18r30; dann FOLD (eine Zeile je
  Gegenstand, Alias-Spalte ueber die Nummernkreise, FOLD_SCHEMA) -> Reduce Versand + CHAT-FASSUNG + Schablone ->
  3 Lenses (Nicht-erneut-fragen / Vollzaehligkeit+Form / Dopplung+Alias) -> Fix + Re-Verify).
- Beweisort: ~/backups-workflow/20260902-a23a-vorlage/: map/ = 13 Dateien mit Journal-Result (fragen-batch-1/2/4/5/6/
  7/8/9/10, og-1-29, lead-bringschulden, explore-10k-und-rettungen, sperren-tafel [neu 17:05Z]) + fragen-batch-8.json +
  tmp-o/; riss7-pre-resume-0822z/ (6), riss8-pre-resume-0852z/ (fragen-batch-3, v-090-ergaenzungen), riss9-pre-resume-
  1658z/ (leer); fold/ reduce/ verify/ leer.
- Task des dritten Resumes: wjcyrqo87 (Start 16:55Z). Journal 17:05:28Z: 106 Zeilen = started=58, result=13,
  35 Fehlerzeilen (Riss-7/8/9-Tote, je erneut gestartet). Um 17:08Z leben 10 Agenten (Transkript-mtime < 3 min) =
  "laeuft nur noch die Haelfte" (Owner). Kein Task-Output, keine Notification -> Prozess lebt.
- Owner-Auflagen im Script (nicht kuerzen): Sperre 9 (Rohlisten-Ersatz verboten), Lens 3 Dopplung/Alias, Reduce-Kopf
  mit Nenner-Historie 45 -> 35 -> 60 -> 283 (RT-38), Versand-Sperren V-090(w)/V-115 (Raster-Zulieferung), Datum
  "20./21.08." + 3 NEU-Zeilen + 35er-Abschnitt aus #170 als Eingang.
- Nach Terminal: Rueckkehrer VOLL lesen (Haeppchen-Regel 07:52Z), dann CHAT-FASSUNG 1:1 posten (nur K3-Gegenstaende
  mit G-ID + Aliassen), Owner-Antworten verbuchen (Board #175 -> completed, Metadata), erst danach #176.

### 3.3 Workflow C -- Thesis-LICENSE #179, wf_d69f800c-888 (TERMINAL failed 17:1xZ)

- Script: ~/backups-workflow/20260902-thesis-license/thesis-license-zug-179.js (355 Z.; Explore(2) -> Design -> Bau
  im Worktree ~/wt-thesis-license Branch bau/thesis-license -> Verify 2 Lenses -> Fix -> Landung thesis dev/main dual +
  super Gitlink beide Zeiger atomar + REUSE-Nachzug + CI + main-FF + Nachmessung; REGELN: curlrc-Secret, TRAILER-FREI,
  E1-Wortlaut Apache-2.0 + Copyright Benjamin-Elias Probst, Fremdcode nie umlizenzieren).
- Task wdmw2n4yr: Notification "failed: Error: Explore unvollstaendig -- kein uninformierter Bau (Doktrin)" = MEINE
  Wache im Script (workflow.js:179), ausgeloest weil explore:A-inventar am Fable-5-Limit starb ("resets Sep 4, 6pm
  UTC"). agents_done 1 (explore:B -> explore/B-LANDE-REZEPT.md liegt, Journal result=1 = CACHE), agents_error 1.
- Resume-Rezept (SEQUENTIELL Nr. 3, erst nach A und B): Workflow({scriptPath: '<Script oben>', resumeFromRunId:
  'wf_d69f800c-888'}) byte-unveraendert; explore:B kommt aus dem Cache, explore:A laeuft neu, dann Design usw.
  Vorher: kein Worktree ~/wt-thesis-license vorhanden (pruefen: git -C ~/Projekte/.../thesis worktree list).
- Fach-Stand (aus 0750Z + Erhebung): E1 = Apache-2.0 MIT Copyright-Vermerk (WELLENPLAN-DICHT Z.2231, Memory
  owner_kerne Z.49); super REUSE.toml Z.192 traegt noch LicenseRef-Diplomarbeit-Copyright-Only (KON2-23, supersediert)
  -> Drehung im super-Nachzug; thesis .gitleaks.toml (V-081/V-082) + D6-Regeln; N-57 Lizenzabsatz DE/EN.

### 3.4 Resume-Rezept fuer den Nachfolger (gilt fuer A und B; C ist schon terminal)

1. Lebendprobe je Run: journal.jsonl-mtime, juengste agent-*.jsonl-mtime, Task-Output-Datei, pgrep auf alte
   Resume-Prozesse (NIE doppelt resumen, Memory reference_resume_zweiter_prozess_...).
2. Limit-Klasse aus dem Journal lesen: "session limit" = Uhrzeit-Reset (weiter nach Reset), "Fable 5 limit" =
   Datums-Reset (Sep 4 6pm UTC laut Riss 9; Sep 8 laut Riss 8) -> ohne frische Credits (Owner /login) NICHT resumen.
3. Pseudo-Result-Probe: Results mit Prosa statt Schema-Objekt greppen; Torsi (Dateien im Beweisort ohne Journal-Result)
   nach rissN-pre-resume-<stamp>/ beiseitelegen, nie loeschen.
4. Resume NUR byte-unveraendert (K27 Praefix-Cache); Schwanz-Erweiterung erlaubt, Prompt-Patch bricht alles danach.
5. SEQUENTIELL: A (Explore-10K) -> B (A2.3a v3) -> C (#179). Naechsten erst starten, wenn der vorige TERMINAL ist.
6. Modell-Wache mit Erlaubnisliste je Run ("<synthetic>" = Harness-Limit-Meldung, Sonnet-Scanner per Design).
7. Monitor: Basis-Zaehler + Dedup der Alarmzeile (sonst Alarm-Spam bei err > 0).

## 4. Riss-Register dieses Kontexts (Fortschreibung von 0750Z Abschnitt 4)

| Riss | Zeit (UTC)   | Klasse                | Wirkung                                    | Heilung                  |
|------|--------------|-----------------------|--------------------------------------------|--------------------------|
| 6    | 01.09. spaet | Session-Limit         | Volllesung r18-r30 unterbrochen            | Owner /login, weiter     |
| 7    | 08:16Z       | Session-Limit         | A2.3a v2 Map-Welle tot, Explore-10K tot    | Resumes wz229cmol/w0sysd.|
| 8    | 08:51Z       | Fable-5-Kont. (Sep 8) | A2.3a v3 + Explore-Reduce tot (08:33-42Z)  | Owner-Credits, Resumes   |
| 9    | 16:58Z       | Fable-5-Kont. (Sep 4) | 6 min nach 3 parallelen Resumes: #179 tot, | Owner: sequentiell, Stufe|
|      |              |                       | A2.3a halb tot, Explore-Reduce weiter      | auslaufen lassen (17:04Z)|

Datenverlust ueber alle vier Risse: 0 (Cache-Results bleiben im Journal, Torsi beiseite). Lehre RT-13 bestaetigt:
Zeit-Etiketten nur aus mtimes, nie geschaetzt (Riss-8-Korrektur ~08:5xZ -> 08:33-08:42Z).
Spend-Risiko: drei parallele Fable-max-Workflows verbrauchen ein frisches Kontingent in Minuten -> Sequenz-Regel.

## 5. Vollzuege dieses Kontexts (K081 -> K082), zusaetzlich zu 0750Z Abschnitt 5

1. Volllesung des r18-r30-Reduce-Rueckkehrers (1205 Z., md5 2c3c969d) in 5 Haeppchen, je sofort quittiert:
   ~/backups-workflow/20260901-volllesung-4-workflows/LESEQUITTUNG-VOLLLESUNG-4-WORKFLOWS-0109.md Abschn. 22-24.
   Ergebnis: 62 Rettungen RT-01..RT-62, 159 Owner-Worte ohne Ledger (9 NIRGENDS -> KON137-04 Verbatim-Pflicht),
   34 N-Posten, 20 P-Posten (8 ohne Traeger -> Board #176..#181).
2. Beweisort 20260901-30-kontexte-vergessene-arbeit: Lead-Nachfixe additiv mit .pre-leadfix-0209-Kopien:
   nachfold/NEUER-LEDGER-NACHFOLD-0109.md (20816 Z.; F-035-Marker RT-30, End-Newline RT-32, Instanzen 1c-2, Zeit-
   Korrektur), reduce/R1-VERGESSENE-ARBEIT-TAFEL.md (FIX-r3 RT-41..RT-52), reduce/R3-FOLD-ERWEITERUNG-OWNER-FAKTEN.md
   (F-001 +6 Instanzen, F-013, F-031, F-021 3 Instanzen, S11/A-10), EINGANG-KON136/GESAMTBILD/NACHFOLD-WACHE je +4 Z.
   V-S1-Quittung; volltexte/MD5SUMS 7/7.
3. Board: #170/#171 completed; NEU #175 A2.3a (in_progress), #176 docs-Zug KON136-04..08 + KON137-01..09, #177 Board-
   Hygiene V-072, #178 Memory-Zug V-091 (in_progress; Tranchen 4-7 vollzogen, Rest = Repo-Seite), #179 LICENSE
   (in_progress; Workflow terminal failed, Resume Nr. 3), #180 Traeger-Anlagen R4-1.8 + RN-83 + T-9, #181 CR-10 BU.
   Metadata-Nachtraege: #167 (l)-(z), #165 (A)(B)(C), #164 (h)-(j), #154, #152, #18, #135, #136(6), #128, #88,
   #57 T3, #142/#149 stale, #168 UEBERHOLT, #69 V-123, #174 Stand.
4. Register-Dokument docs/sessions/20260902-WORKFLOW-REGISTER-LETZTE-10-UND-ZUSAMMENSCHALTUNG-RUECKFRAGEN.md (Commit
   56611a41): 12 Workflows seit 30.08. + Fakt (1)-(7) der Zusammenschaltung Fold-REST/Rueckfragen-Audit.
5. KON137-Entwurf (~/backups-workflow/20260901-volllesung-4-workflows/KON137-ENTWURF-03-bis-08-volllesung.md):
   KON137-09 Zusammenschaltungs-Fakt; Riss 7/8/9 = (n)/(o)/(p) und Sequenz-/Auslauf-Regel = (q) als Nachtrag 1710Z.
6. Memory (11 Dateien + Index): Haeppchen-Regel, 7 Falsch-Null-Schreibvarianten (nohc/imt/abgeleichen/gemiensamt/
   testetm/gelese/Wiederworte), K28 (full-POST nie ohne Owner-T2-Sperrfenster + C-02 + E-2), Extraktor Punkt 7,
   Riss-Rezepte 7/8/9 + Modell-Wache + Spend-Risiko-Register + Sequenz-Regel, Zeichen-Cap-Falle (187 statt 277),
   DICHT-Nenner 719/536/2482/437, Wiederanlauf-Doktrin X-21/Wecker/Interrupt != Order/B.0, Abbruchkanon + L-05,
   K27-Belege v2->v3.
7. F2-Fenster-Dokument 20260821-F2-VORLAGEN-FENSTER-FINAL-konsolidiert.md: F3-17-Nachzug D-04 additiv (786437a5).

## 6. Naechste Schritte in Reihenfolge (Owner-Reihenfolge 01.09.: Fragen -> Antworten -> dichtes Ledger)

1. Stufen auslaufen lassen (A Reduce, B Map-Rest). Kriterium Abschnitt 2 (a)(b)(c). NICHTS killen (K20).
2. Resume A (wg91yxfte-Nachfolger) nur falls A nicht von selbst terminal wird; Rueckkehrer VOLL lesen (Groesse
   messen: < ~25k Tokens ein Read, sonst offset/limit-Haeppchen, jede Portion sofort in die Lesequittung); Explore-Tafel
   (offen + gerissen K072-K081) an Traeger verbuchen; Board #174 completed.
3. Resume B byte-unveraendert; Welle 2 + FOLD + Reduce + 3 Lenses + Fix; Rueckkehrer VOLL lesen; CHAT-FASSUNG 1:1
   posten; Owner-Antworten verbuchen (Board #175, Ledger-Entwurf KON137-10ff.).
4. Resume C (#179) byte-unveraendert; Landung thesis dev/main dual + super Gitlink beide Zeiger atomar; CI gruen;
   Nachmessung ls-remote 4/4; TRAILER-FREI.
5. docs-Zug #176: KON136-04..08 + KON137-01..09(+) + V-059-Buendel + die 3 lokalen super-Commits (786437a5, 56611a41,
   dieser) in EINEM Push-Fenster: Wachen 13/26, gitleaks Koeder rc=1 + Echt rc=0 (Bereich dev+main), R4/R6 0, Dual-
   Push, CI 288 SUCCESS 36/36 + Bruecken, main-FF, Nachmessung 4/4. Vorher Diff-Hygiene PUSH-lokal ueber den FF-Bereich.
6. Danach der Reihe nach: #177 Board-Hygiene V-072, #178 Rest (Repo-Seite ARBEITSWEISE-DICHT/RITUAL-KARTE), #180
   Traeger-Anlagen (Fenster W4 04.-11.09., vor T-3-Reset ~12.09.), #181 CR-10 W2-Vollaudit-BU, #165 SOLL-Inventar,
   #164, #163, #162 (Owner-Entscheid root-PAT id 62), #152 Rotation (ruhiges Fenster), #166 Turnus-Fix vor 01.10.
7. Trigger-Pfad (T-Entscheid #158): ##49 -> Funktionsnachweis -> W7/#88-Split; ##47-Re-Run-3 owner-gated (E-2/C-02,
   K28: nie full-POST ohne Owner-T2-Sperrfenster).

## 7. Owner-Fragen -- KEINE neue Rohliste (Sperre 9)

Die Kurztafel steht in 0750Z Abschnitt 7 (A-1..A-6, O-1..O-29, 55 B-Fragen) und im Register-Dokument. Die
vollzaehlige, gefaltete Fassung (G-nnn mit Alias-Spalte ueber die Nummernkreise S01..S12 / A-B 61 / V-001..V-148 /
F-001..F-040 / O-1..O-29 / V-090(a)-(v) / U-N / F2-Bloecke 35+3 / OG-1..58 / Explore-10K / r18-r30 / R1 / Board 63
offene Tasks / Entwuerfe / Nachleser-Delta) kommt AUS Workflow B. Der Nachfolger fragt den Owner NICHT vorab aus
Rohlisten (Owner 02.09.: "ernstes Problem" war genau die Unvollstaendigkeit) -- er postet die CHAT-FASSUNG des Workflows
1:1 und verbucht die Antworten. Einzige Ausnahme: Fragen, die der Owner selbst im Chat stellt.

Bereits BEANTWORTET in diesem Kontext (nicht erneut fragen): Sequenz-Regel (sequentiell, gleicher Umfang), Stufe-
auslaufen-Regel, Haeppchen-Regel, Register-Auftrag, Fold-Auflage JA, Kontextende-Order.

## 8. Sicherheitsregeln (verbatim fortgeltend, aus 0750Z Abschnitt 8, ergaenzt)

- ~/.claude/jobs/5a19728e/tmp/glhdr.curlrc = Secret: NIE ausgeben/kopieren, nur `curl --config`; stirbt mit dem Job,
  dann blind aus dem Vault neu (mapfile, rueckwaerts bis HTTP 200). API-Host immer aus `git remote -v` (E-5-Lehre:
  Agent riet gitlab.com -> 14x 401 an Cloudflare, Rotationsgrund root-PAT id 62 = #162).
- Keys/Token/PAT nie im Klartext (nur Laenge/Hash/Ort); Vault Cluster/keys NIE greppen; backup/-Branches nie pushen;
  Remote-Loeschungen/Cancels nur mit Owner-GO; GitHub-Purge-Scope NUR Commit 0891fcf43cbf + Blob 71670a3d.
- codex ac_-Code nie persistieren (L-13-Maskierung code=ac_REDACTED-L13, state=REDACTED-L13).
- Messdaten/Doku nie loeschen; Transkripte nie committen (wf_78955b71/agent-a11b87990b7092c3e.jsonl = prod2-Runner-
  Tokens 17+56; wf_4fc4b8d9 = 289-runners_token -> #152); `gitlab-runner list` NIE; config.toml nie ausgeben;
  Cluster _infra/ci-templates tabu.
- nie rebase, kein add -A, kein Force-Push ohne Owner-GO; Koeder-Literale in Commit-Texten maskieren (Koeder-Prosa-
  Allowlist frisst "Koeder"-Zeilen -> neutrale Form); K20 fremde/interaktive Sessions nie killen; Thesis-Commits
  TRAILER-FREI; lokale Thesis-ALT-Refs (main 95db7793, b-thesis-o4-nachzug, backup/pre-rescrub, w2-E02-Ledger, Tags,
  rescue/owner-laptop-merge-20260831 b591266, probe-*.git) NIE pushen.
- NEUER-LEDGER-Original nur lesen (Nachfold schreibt KOPIE); .riss*-Dateien und riss*-pre-resume-Ordner = Lead-only;
  Kontext-Extrakte vor Nutzung auf Token-Muster pruefen (glpat-/glrt-/ghp_/runners_token/code=ac_/state=).
- Workflow-Scripts der laufenden Runs NICHT editieren (K27) -- Aenderungen nur als neues Script mit Datei-Eingaengen.

## 9. Datei-Register (neu oder geaendert in diesem Kontext)

Repo super (lokal, ungepusht):
- docs/sessions/20260902-KONTEXTUEBERGABE-0750Z.md (786437a5) -- Basis-Uebergabe.
- docs/sessions/20260902-WORKFLOW-REGISTER-LETZTE-10-UND-ZUSAMMENSCHALTUNG-RUECKFRAGEN.md (56611a41).
- docs/sessions/20260821-F2-VORLAGEN-FENSTER-FINAL-konsolidiert.md (F3-17-Nachzug, 786437a5).
- docs/sessions/20260902-KONTEXTUEBERGABE-1705Z.md (dieses Dokument).

Beweisorte (~/backups-workflow/, additiv, nie raeumen):
- 20260902-a23a-vorlage/ (Scripts v2/v3, map/ 13 + json, riss7/8/9-pre-resume-*, fold/ reduce/ verify/ leer).
- 20260902-explore-10-kontexte/ (map/ 10 Scans, reduce/ leer, riss8/9-Torsi).
- 20260902-thesis-license/ (Script, explore/B-LANDE-REZEPT.md, uebrige Ordner leer, riss9-pre-resume-1658z/).
- 20260901-volllesung-4-workflows/ (LESEQUITTUNG Abschn. 22-24 + Schlussvermerk 1710Z, KON137-ENTWURF 03..09 + (n)-(q),
  maps-r18-r30/REDUCE-VOLLLESUNG-r18-r30-R1-R4-WACHE.md 1205 Z.).
- 20260901-30-kontexte-vergessene-arbeit/ (Nachfold-Kopie, R1/R3-Tafeln mit .pre-leadfix-0209, MD5SUMS 7/7).

Memory (~/.claude/projects/-home-comdare/memory/): project_kontextende_20260902_1705z_stufe_auslaufen_sequentiell_
resume.md (neu) + Index; Aenderungen aus Abschnitt 5 Punkt 6.

## 10. Lehren dieses Kontexts (fuer ARBEITSWEISE-DICHT-Nachzug #178, Kurzform)

- L-1 Drei parallele Fable-max-Resumes fressen ein frisches Kontingent in 6 Minuten -> nur EIN Workflow zur Zeit.
- L-2 Nach einem Riss die laufende Stufe auslaufen lassen; Resume erst bei Beginn der naechsten Stufe (Owner 17:04Z).
- L-3 Rueckkehrer immer voll lesen; zu gross -> Haeppchen mit Sofort-Verbuchung (Owner 07:52Z).
- L-4 Vollbestand offener Rueckfragen = nur die UNION mehrerer Nummernkreise; Rohlisten nie als Vorlage (Owner).
- L-5 Zeit-Etiketten nur aus mtimes; Kompakt-Eingaenge mit Zeichen-Cap sind Zaehlartefakte (187 statt 277).
- L-6 Doktrin-Wachen im Script (kein uninformierter Bau) wirken auch bei Limit-Toten: #179 brach kontrolliert ab.
- L-7 Limit-Klasse steht im Journal: Session-Limit (Uhrzeit) vs Fable-5-Kontingent (Datum) -> anderes Rezept.

Ende der Uebergabe 1705Z (geschrieben 17:08-17:1xZ). Selbstcheck: ASCII, <= 120 Spalten, keine Secrets, keine Koeder.

## 11. NACHTRAG 04.09. 18:1xZ -- Stufen ausgelaufen, Owner-Resume-Order

Alle drei Runs wurden 02.09. 17:08-17:18Z terminal (Fable-5-Kontingent, "resets Sep 8, 7pm (UTC)" fuer die zuletzt
gestarteten Agenten): A wf_1a36d148 FAILED (reduce:tafel tot; 10 Scans im Cache; Torso reduce/OFFENE-UND-GERISSENE-
ARBEIT-K072-K081.md 43606 B nach riss9-auslauf-pre-resume-0904-1815z/), B wf_f97550fa "completed" mit Null-Result
(14 Map-Results im Journal-Cache: fragen-batch-1/2/4/5/6/7/8/9/10, og-1-29, og-30-58, lead-bringschulden,
explore-10k-und-rettungen, sperren-tafel; tot: fragen-batch-3, o-1..o-29, v-090+raster, 4x map2, fold, reduce,
3 Lenses; Torso map/tmp-o/ beiseite), C wf_d69f800c FAILED (Doktrin-Wache; explore:B im Cache).
Owner 04.09. ~18:1xZ nach /login (verbatim): "Bitte resume ALLE Agenten und Workflows und fahre wie gehabt mit der
offenen Arbeit fort." + "Bitte untersuche mit ultracode die Aquivalente des Session Logs ueber die letzten 3 Kontexte
auf vergessene Arbeit." -> Vollzug sequentiell (Regel 16:59Z steht): A Resume -> Explore-3K (neuer Workflow, Owner-
Order) -> B Resume -> C Resume. Board #174/#175/#179 tragen den Stand.
