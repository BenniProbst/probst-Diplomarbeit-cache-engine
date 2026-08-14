# LESER 1 -- Extraktion (Batch i%12==0 der GROESSEN-sortierten gb_dateiliste.json, 152 Eintraege gesamt, 13 Dateien in diesem Batch)

Batch-Dateiliste (Name, Bytes):
- wtk6lmhln.json (745196 B)
- w3azi1rhl.json (171980 B)
- w2mylldp8.json (109928 B)
- w9ezc7zw6.json (88223 B)
- wp8u862m5.json (70219 B)
- ww7eb5key.json (52286 B)
- wq3sh10mx.json (36688 B)
- wvi23h1ux.json (31898 B)
- wf8v44w0f.json (23812 B)
- w72yytmwm.json (18305 B)
- wjrbqudaw.json (13246 B)
- wzktivkld.json (9099 B)
- wn2wugqyj.json (5383 B)

KORREKTUR (2. Durchgang): Die urspruengliche Kopfzeile nannte faelschlich w2z8rp4xk.json als
letzten Batch-Eintrag. Verifiziert am Objekt (gb_dateiliste.json, 152 Eintraege, 0-basiert):
Index 144 = wn2wugqyj.json (5383 B); w2z8rp4xk.json ist Index 142 (6113 B, Batch i%12==10,
Leser 11). Extrahiert wird hier wn2wugqyj.json.

Quelle aller Pfade: /home/comdare/.claude/jobs/5a19728e/tmp/regressions-gesamtbild/<name>

## QUELLE wtk6lmhln.json -- 'Ist done wirklich erledigt?' Vollstaendigkeitspruefung 11.-13.08. (11 Agenten, 4 Erhebungen + 4 Verifikationen + 2 Codex-Lenses + Synthese). 538 Erledigt-Behauptungen geprueft: 311 voll / 190 teilweise / 19 hart gefallen / 18 gegenstandslos (Nenner 538). Stand-Anker der Quelle: super development f8cff2c8, Gitlink ce 7d65eb6c, ce-Arbeitskopie f23c18e2, Ledger-Kopf KON57.

### [wtk6lmhln.json] 001
GEGENSTAND: ERHEBUNG[0]-Luecke: TaskList/TaskGet-Werkzeuge waren diesem Subagenten NICHT exponiert (ToolSearch findet nur TaskStop)
ORT: 5a19728e
SOLL/FIX: TaskList/TaskGet-Werkzeuge waren diesem Subagenten NICHT exponiert (ToolSearch findet nur TaskStop). Ich habe ersatzweise den On-Disk-Store /home/comdare/.claude/tasks/session-5a19728e/*.json gelesen. RISIKO: falls die laufende Session Tasks im Speicher haelt, die noch nicht auf Platte sind, fehlen sie hier. Gegenindiz: die neuesten mtimes sind 13.08. 07:41/07:45, also unmittelbar vor meinem Start (07:47) -- der Store wirkt aktuell. Sollte die naechste Stufe TaskList haben: 36 Eintraege gegenzaehlen.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 002
GEGENSTAND: ERHEBUNG[0]-Luecke: Die Erledigt-Behauptungen des LEDGERS selbst (334 '## NACHTRAG'-Bloecke, KON1..KON57) sind NICHT erhoben -- die Quelle war laut Auftrag die Task-Liste
ORT: unbekannt
SOLL/FIX: Die Erledigt-Behauptungen des LEDGERS selbst (334 '## NACHTRAG'-Bloecke, KON1..KON57) sind NICHT erhoben -- die Quelle war laut Auftrag die Task-Liste. Der Ledger enthaelt mit Sicherheit weitere Erledigt-Aussagen (insbesondere zu Posten, die nie einen Task hatten).
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 003
GEGENSTAND: ERHEBUNG[0]-Luecke: Die Erledigt-Behauptungen in docs/plaene/ (21 Dokumente, u.a
ORT: unbekannt
SOLL/FIX: Die Erledigt-Behauptungen in docs/plaene/ (21 Dokumente, u.a. WELLENKONSOLIDIERUNG 12.08., GOAL-V8-DOSSIER, WELLENPLAN-v2, DESIGNPLAN-tdd) und docs/sessions/ (WF1-WF6-Synthesen, Kontextuebergaben, GESAMTURTEIL) sind NICHT erhoben.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 004
GEGENSTAND: ERHEBUNG[0]-Luecke: Die Erledigt-Behauptungen aus dem Roh-Transkript / den Owner-Texten (jobs/tmp/*_owner*.jsonl) sind NICHT erhoben.
ORT: unbekannt
SOLL/FIX: Die Erledigt-Behauptungen aus dem Roh-Transkript / den Owner-Texten (jobs/tmp/*_owner*.jsonl) sind NICHT erhoben.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 005
GEGENSTAND: ERHEBUNG[0]-Luecke: Die 164 uebrigen Session-Task-Verzeichnisse unter /home/comdare/.claude/tasks/ sind NICHT gelesen -- frueherer Session-Kram kann Erledigt-Meldungen tragen, die in diese Session hineinwirken (z.B
ORT: unbekannt
SOLL/FIX: Die 164 uebrigen Session-Task-Verzeichnisse unter /home/comdare/.claude/tasks/ sind NICHT gelesen -- frueherer Session-Kram kann Erledigt-Meldungen tragen, die in diese Session hineinwirken (z.B. das mehrfach referenzierte '#84' und '#88', die in dieser 36er-Liste GAR NICHT vorkommen: #84 in T-14e, #88 in Task 21/28/29).
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 006
GEGENSTAND: ERHEBUNG[0]-Luecke: Die Nummerierung ist inkonsistent: die Tasks referenzieren '##25', '#67', '#84', '#88' -- diese Nummern existieren in der aktuellen 36er-Liste NICHT
ORT: unbekannt
SOLL/FIX: Die Nummerierung ist inkonsistent: die Tasks referenzieren '##25', '#67', '#84', '#88' -- diese Nummern existieren in der aktuellen 36er-Liste NICHT. Woher sie stammen (aeltere Liste? Ledger-Posten? Bauliste?) habe ich nicht ermittelt.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 007
GEGENSTAND: ERHEBUNG[0]-Luecke: KEINE VERIFIKATION durchgefuehrt (auftragsgemaess Erhebung): kein git log/show auf die genannten SHAs, kein Pipeline-Abruf, kein ctest, kein grep gegen den ce-Code
ORT: unbekannt
SOLL/FIX: KEINE VERIFIKATION durchgefuehrt (auftragsgemaess Erhebung): kein git log/show auf die genannten SHAs, kein Pipeline-Abruf, kein ctest, kein grep gegen den ce-Code. Ich habe ausschliesslich die EXISTENZ der referenzierten Beleg-PFADE geprueft, damit die Pruefformen ausfuehrbar sind.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 008
GEGENSTAND: ERHEBUNG[0]-Luecke: Ich habe /home/comdare/wt-ce-golden-s14a NICHT betreten und keine git-Metadaten daraus gelesen (Bau-Agent aktiv)
ORT: bau/golden-s14a-riegel
SOLL/FIX: Ich habe /home/comdare/wt-ce-golden-s14a NICHT betreten und keine git-Metadaten daraus gelesen (Bau-Agent aktiv). Alle Pruefformen zum Branch bau/golden-s14a-riegel sind deshalb ueber 'git show <branch>:<pfad>' aus dem ce-Store formuliert, nicht ueber das Worktree.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 009
GEGENSTAND: ERHEBUNG[0]-Luecke: Ich habe den INHALT der Beleg-Dateien (fable-lens-3achsen.json 32 KB, review-opus-fable-s14a.json 76 KB, codex-funde-s14a-verifiziert.md, wf11-design-2/3.json, pzw-fussnote, minio_blind_smoke.sh) NICH
ORT: fable-lens-3achsen.json | review-opus-fable-s14a.json | codex-funde-s14a-verifiziert.md
SOLL/FIX: Ich habe den INHALT der Beleg-Dateien (fable-lens-3achsen.json 32 KB, review-opus-fable-s14a.json 76 KB, codex-funde-s14a-verifiziert.md, wf11-design-2/3.json, pzw-fussnote, minio_blind_smoke.sh) NICHT gelesen -- nur ihre Existenz und Groesse. Die dort enthaltenen Einzelbefunde sind weitere Behauptungen und in T-35a/T-36a/T-30d als Pruefpunkt markiert.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 010
GEGENSTAND: ERHEBUNG[0]-Luecke: Der activeForm-Text der Tasks ist erhoben, aber nicht separat ausgewertet; blocks/blockedBy-Kanten sind nur bei Task 19/31 vorhanden und uebernommen.
ORT: unbekannt
SOLL/FIX: Der activeForm-Text der Tasks ist erhoben, aber nicht separat ausgewertet; blocks/blockedBy-Kanten sind nur bei Task 19/31 vorhanden und uebernommen.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 011
GEGENSTAND: ERHEBUNG[0]-Luecke: Nicht erhoben: ob 'completed' zum Zeitpunkt des Abhakens gerechtfertigt war ODER durch spaetere Ereignisse ueberholt wurde
ORT: unbekannt
SOLL/FIX: Nicht erhoben: ob 'completed' zum Zeitpunkt des Abhakens gerechtfertigt war ODER durch spaetere Ereignisse ueberholt wurde. Zwei Faelle sind auffaellig und als Behauptung aufgenommen (T-22b: Task 22 sagt 'laeuft', Task 34 sagt 'gelandet'; T-16a/T-33b vs. T-36b: 158 vs. 152/387), es koennen weitere existieren.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 012
GEGENSTAND: ERHEBUNG[1]-Luecke: KON58 EXISTIERT IM LEDGER NICHT
ORT: unbekannt
SOLL/FIX: KON58 EXISTIERT IM LEDGER NICHT. Der Auftrag nannte 'KON6 bis KON58'; der Ledger-Kopf beginnt bei KON57 (Zeile 19), Datei-mtime 12.08. 21:02. Hoechste vergebene Nummer = KON57. (KON35 wurde ausdruecklich nie vergeben -- der Konsolidierungs-Entwurf trug die 35 im Arbeitstitel und landete als 'LEDGER-KONSOLIDIERUNG IV' ohne Nummer.)
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 013
GEGENSTAND: ERHEBUNG[1]-Luecke: POST-KON57-VOLLZUG STEHT NICHT IM LEDGER, ist also nicht erhoben, obwohl er Erledigt-Behauptungen traegt: super f8cff2c8 'Uebergabe nacht-9 final -- Fixup GELANDET (ce 7d65eb6c + Gitlink 09937abe), CI
ORT: f8cff2c8 | 7d65eb6c | 09937abe
SOLL/FIX: POST-KON57-VOLLZUG STEHT NICHT IM LEDGER, ist also nicht erhoben, obwohl er Erledigt-Behauptungen traegt: super f8cff2c8 'Uebergabe nacht-9 final -- Fixup GELANDET (ce 7d65eb6c + Gitlink 09937abe), CI-Beweis laeuft' und super 09937abe 'chore(gitlink): ce 671d7f6a -> 7d65eb6c (Zweitlens-Haertung KON57) + Designplan-Paragraph-9.5-Fussnote sechster Zug'; ce-seitig 7d65eb6c (merge s1-haertung, 12.08.), 58579575 + f23c18e2 (13.08., Q6-Dock-32-Nachzug an 4 Stellen). Damit ist die in KON57-05 als OFFEN dokumentierte Landesequenz offenbar vollzogen -- der Beleg liegt nur in Commit-Messages und in docs/sessions/20260812-KONTEXTUEBERGABE-nacht-9-*.md, nicht im Ledger.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 014
GEGENSTAND: ERHEBUNG[1]-Luecke: DER 13.08.-BEFUND SELBST (die frisch gebaute Wache meldete 'GRUEN -- 158 Dateien', bewachte aber 152 von 387 Achsen-Headern; Grundgesamtheit war ein SUBSTRING- statt Datei-Filter) ist im Ledger nirgen
ORT: unbekannt
SOLL/FIX: DER 13.08.-BEFUND SELBST (die frisch gebaute Wache meldete 'GRUEN -- 158 Dateien', bewachte aber 152 von 387 Achsen-Headern; Grundgesamtheit war ein SUBSTRING- statt Datei-Filter) ist im Ledger nirgends verbucht. Er beruehrt direkt Z-35, Z-40, Z-42 und Z-56 -- deren Nenner (6/130/152/371) sind alle mit derselben Klasse gemessen worden.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 015
GEGENSTAND: ERHEBUNG[1]-Luecke: DIE DREI ANDEREN LEDGER wurden nicht gelesen, obwohl die AUDIT-KLAUSEL im Ledger-Kopf sie fuer Vollstaendigkeits-Audits vorschreibt: ce Code/external/comdare-cache-engine/docs/ledger-sections/*.md (dr
ORT: goal-v6-luecken-ledger.md
SOLL/FIX: DIE DREI ANDEREN LEDGER wurden nicht gelesen, obwohl die AUDIT-KLAUSEL im Ledger-Kopf sie fuer Vollstaendigkeits-Audits vorschreibt: ce Code/external/comdare-cache-engine/docs/ledger-sections/*.md (drei Dateien, u.a. goal-v6-luecken-ledger.md mit SUPERSEDED-Banner), prt-art und thesis; das Cluster-Ledger ist der 5. Pfad (Infra-Hoheit). Auftrag beschraenkte auf den super-Ledger-Kopf.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 016
GEGENSTAND: ERHEBUNG[1]-Luecke: DIE SESSION-DOKUMENTE wurden nicht durchgekaemmt, nur soweit der Ledger sie zitiert: 20260812-GESAMTURTEIL-*, WF1-BERGUNG, WF1/WF2/WF3/WF4/WF5/WF6-SYNTHESEN, ZWISCHENSTAND, KONTEXTUEBERGABE nacht-7/7b
ORT: 20260812 | 20260811
SOLL/FIX: DIE SESSION-DOKUMENTE wurden nicht durchgekaemmt, nur soweit der Ledger sie zitiert: 20260812-GESAMTURTEIL-*, WF1-BERGUNG, WF1/WF2/WF3/WF4/WF5/WF6-SYNTHESEN, ZWISCHENSTAND, KONTEXTUEBERGABE nacht-7/7b/7c/8/9, 20260811-NACHGEHOLTER-DUALREVIEW, 20260811-PLANABGRENZUNG-UND-CODEX-VOLLREVIEW. Sie enthalten die Volltexte, aus denen die Ledger-Kurzfassungen destilliert sind -- dort stehen weitere Erledigt-Behauptungen.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 017
GEGENSTAND: ERHEBUNG[1]-Luecke: DIE PLAN-DOKUMENTE wurden nicht gelesen: docs/plaene/20260812-WELLENKONSOLIDIERUNG-und-strategische-reihenfolge.md (Teil A einbaufertige Fassung, Teil B die Strecke, Teil A.4 die 15 v3.5-Kandidaten), 
ORT: docs/plaene/20260812-WELLENKONSOLIDIERUNG-und-strategische-reihenfolge.md | 20260812
SOLL/FIX: DIE PLAN-DOKUMENTE wurden nicht gelesen: docs/plaene/20260812-WELLENKONSOLIDIERUNG-und-strategische-reihenfolge.md (Teil A einbaufertige Fassung, Teil B die Strecke, Teil A.4 die 15 v3.5-Kandidaten), Wellenplan v2 Paragraph 16/Paragraph 17, GOAL-v8-Dossier, DESIGNPLAN-tdd Paragraph 9.5/Paragraph 10. Mehrere erhobene Behauptungen (W-04, W-06, Z-15, Z-16, D-04) sind nur dort pruefbar.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 018
GEGENSTAND: ERHEBUNG[1]-Luecke: AUS DER LEDGER-KONSOLIDIERUNG IV (Zeilen 1796-2462, Kapitel A-M) wurden nur die tragenden ERGAENZT-Fakten erhoben (Z-56..Z-62)
ORT: unbekannt
SOLL/FIX: AUS DER LEDGER-KONSOLIDIERUNG IV (Zeilen 1796-2462, Kapitel A-M) wurden nur die tragenden ERGAENZT-Fakten erhoben (Z-56..Z-62). Die Kapitel B/C/D/E/G/I/K enthalten weitere Dutzende Bestands-Aussagen der Form 'ist gebaut / existiert / ist verdrahtet' (u.a. Flag-Grammatik v2 gebaut, SIMD-Meta-Meta gebaut, C-4-Wache CI-verdrahtet, PlanTextBuilder produktionskritisch, 3 Vertrags-Gatter produktiv verdrahtet, Composite-Zulassungsmatrix dreiwertig) -- sie sind Erledigt-Behauptungen im weiteren Sinn und nicht einzeln aufgenommen.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 019
GEGENSTAND: ERHEBUNG[1]-Luecke: KON5 UND AELTER (10.08
ORT: unbekannt
SOLL/FIX: KON5 UND AELTER (10.08. und davor) wurden nicht erhoben -- ausserhalb des 11.-13.08.-Fensters. KON5-01 ('der leere Mess-Stempel ist SOLLVERHALTEN') wird aber in KON44-01 und KON47-01 als geltend fortgeschrieben und dort PRAEZISIERT; wer KON44/KON47 prueft, braucht KON5-01 im Original.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 020
GEGENSTAND: ERHEBUNG[1]-Luecke: DIE MEMORY-DATEIEN wurden nicht gegen den Ledger gehalten
ORT: unbekannt
SOLL/FIX: DIE MEMORY-DATEIEN wurden nicht gegen den Ledger gehalten. Mehrere erhobene Punkte behaupten Memory-Vollzug (D-02, D-05, D-06, Z-39, Z-45, P-12) -- die Memories selbst sind ungelesen geblieben.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 021
GEGENSTAND: ERHEBUNG[1]-Luecke: KEIN EINZIGER PUNKT WURDE GEPRUEFT
ORT: unbekannt
SOLL/FIX: KEIN EINZIGER PUNKT WURDE GEPRUEFT. Rollenauftrag war ERHEBUNG; es wurden keine Pipelines abgefragt, keine Code-Zeilen aufgeschlagen, keine Zaehlungen nachgefahren. Die Spalte 'pruefbar_wie' ist ein Vorschlag, kein Ergebnis -- und sie ist selbst eine Behauptung darueber, was den Gegenstand trifft.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 022
GEGENSTAND: ERHEBUNG[1]-Luecke: NICHT GEPRUEFT, OB DIE ZITATE IM LEDGER DEN OWNER-ROHTRANSKRIPTEN ENTSPRECHEN
ORT: unbekannt
SOLL/FIX: NICHT GEPRUEFT, OB DIE ZITATE IM LEDGER DEN OWNER-ROHTRANSKRIPTEN ENTSPRECHEN. KON14-03 belegt vier unmarkierte Eingriffe in EINEM Owner-Zitat (KON9-11), darunter ein gekapptes Ende vor einem Blocker-Folgesatz; KON11-03 einen weiteren Fall. Jedes der rund 40 woertlichen Owner-Zitate im erhobenen Bereich traegt dieses Risiko.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 023
GEGENSTAND: ERHEBUNG[1]-Luecke: KEINE ZUORDNUNG COMMIT->KON-NACHTRAG erhoben
ORT: unbekannt
SOLL/FIX: KEINE ZUORDNUNG COMMIT->KON-NACHTRAG erhoben. L-20 behauptet 'alle 17 KON-Nachtraege dieser zwei Tage sind pipeline-gruen' auf Basis von drei Pipelines -- die Abbildung, welcher Commit welchen Nachtrag traegt, wurde nicht gebaut.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 024
GEGENSTAND: ERHEBUNG[2]-Luecke: GOAL-v8-Dossier im Volltext: nur der Kopf-Nachtrag (Teil A.1 im Wellenkonsolidierungs-Dokument) und die Existenz der Einpflege wurden gelesen
ORT: unbekannt
SOLL/FIX: GOAL-v8-Dossier im Volltext: nur der Kopf-Nachtrag (Teil A.1 im Wellenkonsolidierungs-Dokument) und die Existenz der Einpflege wurden gelesen. Die Zusicherungen in GOAL VI.1-VI.5, VIII (TDD-Vertrag) und IX (D2/D5) selbst sind NICHT erhoben -- sie stehen nur in der Spiegelung durch Teil A.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 025
GEGENSTAND: ERHEBUNG[2]-Luecke: docs/ARBEITSWEISE-GESAMT-DOKTRIN.md (viertes Haupt-Referenzdokument nach KON19-00): nicht geoeffnet
ORT: docs/ARBEITSWEISE-GESAMT-DOKTRIN.md
SOLL/FIX: docs/ARBEITSWEISE-GESAMT-DOKTRIN.md (viertes Haupt-Referenzdokument nach KON19-00): nicht geoeffnet. Der Versionsstand (v3.4 oder v3.5) und die Einarbeitung der 15 A.4-Kandidaten sind offen (REF-11 nennt die Pruefform).
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 026
GEGENSTAND: ERHEBUNG[2]-Luecke: Ledger-Nachtraege KON39 bis KON57 (alle 12.08., alle NACH der Landung der Wellenkonsolidierung als KON39): nur die 30 Ueberschriften per grep gesichtet, kein Block gelesen
ORT: unbekannt
SOLL/FIX: Ledger-Nachtraege KON39 bis KON57 (alle 12.08., alle NACH der Landung der Wellenkonsolidierung als KON39): nur die 30 Ueberschriften per grep gesichtet, kein Block gelesen. Deren Erledigt-Behauptungen sind ein eigener Erhebungs-Gegenstand -- besonders KON40 (17-vs-18 geklaert), KON41/KON42 (OF-2), KON44 (Durchstich faehrt heute nicht), KON45 (Festplatten-IO, Hybrid-Stempel), KON46 (Landungen durch, 289-Token rotiert), KON47 (F1-Weg, Bau beginnt), KON48 (v3.5-GO), KON56 (F1-Landung), KON57 (Zweitlens-Haertung).
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 027
GEGENSTAND: ERHEBUNG[2]-Luecke: Ledger-Konsolidierung IV (Kapitel A-M mit ERGAENZT-Bloecken) und KON24-KON38: als Fakten-Quelle von allen drei Dokumenten in Anspruch genommen, aber nicht geoeffnet.
ORT: unbekannt
SOLL/FIX: Ledger-Konsolidierung IV (Kapitel A-M mit ERGAENZT-Bloecken) und KON24-KON38: als Fakten-Quelle von allen drei Dokumenten in Anspruch genommen, aber nicht geoeffnet.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 028
GEGENSTAND: ERHEBUNG[2]-Luecke: Sessions vom 12./13.08.: 20260812-KONTEXTUEBERGABE-nacht-9-die-f1-landung-und-die-kanal-doktrin.md, 20260812-ZWISCHENSTAND-strecke-beginnt-durchstich-laeuft.md, 20260812-GESAMTURTEIL-manuelle-synthese
ORT: 20260812-KONTEXTUEBERGABE-nacht-9-die-f1-landung-und-die-kanal-doktrin.md | 20260812-ZWISCHENSTAND-strecke-beginnt-durchstich-laeuft.md | 20260812-GESAMTURTEIL-manuelle-synthese-aller-workflows-nacht-7c.md | 20260812
SOLL/FIX: Sessions vom 12./13.08.: 20260812-KONTEXTUEBERGABE-nacht-9-die-f1-landung-und-die-kanal-doktrin.md, 20260812-ZWISCHENSTAND-strecke-beginnt-durchstich-laeuft.md, 20260812-GESAMTURTEIL-manuelle-synthese-aller-workflows-nacht-7c.md (Quelle der V-1/V-2-Befunde) -- nicht gelesen.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 029
GEGENSTAND: ERHEBUNG[2]-Luecke: Wellenplan v2 par.0 bis par.12: die Defekte D1-D5, die ##-Postenliste, par.5 kritischer Pfad, par.8 'was beim Owner liegt', par.12.3 die sieben Testklassen und par.12.5 der Kapazitaetskonflikt (99 h Band A, 62 h Band B
ORT: unbekannt
SOLL/FIX: Wellenplan v2 par.0 bis par.12: die Defekte D1-D5, die ##-Postenliste, par.5 kritischer Pfad, par.8 'was beim Owner liegt', par.12.3 die sieben Testklassen und par.12.5 der Kapazitaetskonflikt (99 h Band A, 62 h Band B) -- auftragsgemaess ausserhalb par.13-par.17, aber mehrfach von par.13-par.17 in Anspruch genommen.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 030
GEGENSTAND: ERHEBUNG[2]-Luecke: DESIGNPLAN par.0 bis par.8: die Zahlen par.0 (157/117/40), die sieben Testklassen par.2, der TDD-Vertrag T-1..T-9 par.3, die Testarbeit je Welle par.4 und par.8 ('~118 h', Bedingung (2)) -- ausserhalb par.9/par.10, aber von par.10
ORT: unbekannt
SOLL/FIX: DESIGNPLAN par.0 bis par.8: die Zahlen par.0 (157/117/40), die sieben Testklassen par.2, der TDD-Vertrag T-1..T-9 par.3, die Testarbeit je Welle par.4 und par.8 ('~118 h', Bedingung (2)) -- ausserhalb par.9/par.10, aber von par.10 D-2/D-4/D-5 in Anspruch genommen.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 031
GEGENSTAND: ERHEBUNG[2]-Luecke: Die Tasks-Liste (user-sichtbares TODO) -- Gegenstand aller ##- und #-Nummern in allen drei Dokumenten
ORT: unbekannt
SOLL/FIX: Die Tasks-Liste (user-sichtbares TODO) -- Gegenstand aller ##- und #-Nummern in allen drei Dokumenten. Ohne sie sind die Nummern-Behauptungen (91/56/35, #7/#10/#11/#13/#14-#22, #78/#80/#82/#83/#84/#86/#87/#88/#90/#91) nicht aufloesbar.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 032
GEGENSTAND: ERHEBUNG[2]-Luecke: Alle CI-Zustaende: keine Pipeline gepollt, keine Job-Nummer verifiziert (15428/369258, 15463/369917, 15615/373214, 15706/374843, 15764)
ORT: unbekannt
SOLL/FIX: Alle CI-Zustaende: keine Pipeline gepollt, keine Job-Nummer verifiziert (15428/369258, 15463/369917, 15615/373214, 15706/374843, 15764). Hausregel: der Agent wartet nie auf CI.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 033
GEGENSTAND: ERHEBUNG[2]-Luecke: /home/comdare/wt-ce-golden-s14a -- auftragsgemaess nicht angefasst (dort arbeitet ein Bau-Agent)
ORT: unbekannt
SOLL/FIX: /home/comdare/wt-ce-golden-s14a -- auftragsgemaess nicht angefasst (dort arbeitet ein Bau-Agent). Der dortige Stand von S-14a/golden ist damit unbekannt, obwohl Teil B Posten 10 und 11 heute darauf zielen.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 034
GEGENSTAND: ERHEBUNG[2]-Luecke: Kein Bau, kein ctest, kein Configure gefahren -- alle Zahlen, die einen gebauten Baum brauchen (429/431/456/460, 4x485/485, ctest -N), sind ausschliesslich als Pruefform notiert.
ORT: unbekannt
SOLL/FIX: Kein Bau, kein ctest, kein Configure gefahren -- alle Zahlen, die einen gebauten Baum brauchen (429/431/456/460, 4x485/485, ctest -N), sind ausschliesslich als Pruefform notiert.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 035
GEGENSTAND: ERHEBUNG[2]-Luecke: Teil B Posten 16-46 mit ZUKUNFTS-Datum wurden nicht als Terminposten erhoben (nicht faellig); nur die in ihnen eingebetteten Zustands-Zusicherungen sind aufgenommen (STR-13 bis STR-21).
ORT: unbekannt
SOLL/FIX: Teil B Posten 16-46 mit ZUKUNFTS-Datum wurden nicht als Terminposten erhoben (nicht faellig); nur die in ihnen eingebetteten Zustands-Zusicherungen sind aufgenommen (STR-13 bis STR-21).
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 036
GEGENSTAND: ERHEBUNG[2]-Luecke: Die uebrigen 129 Dateien in docs/plaene/ -- insbesondere die Bauplaene INC0/INC1/INC2, das GESAMTBILD 08.08
ORT: unbekannt
SOLL/FIX: Die uebrigen 129 Dateien in docs/plaene/ -- insbesondere die Bauplaene INC0/INC1/INC2, das GESAMTBILD 08.08. und die WELLENPLAN-ANLAGE (Luecken/Defekte/Einwaende) -- nicht gesichtet.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 037
GEGENSTAND: ERHEBUNG[3]-Luecke: Die Rohtranskripte/Owner-Nachrichten der drei Tage: /home/comdare/ernte-20260812-nacht7c/session-log-*.jsonl (217 M) und workflows/ (797 M), /home/comdare/ernte-20260811-nacht7/, sowie docs/sessions/b
ORT: 20260812 | 20260811
SOLL/FIX: Die Rohtranskripte/Owner-Nachrichten der drei Tage: /home/comdare/ernte-20260812-nacht7c/session-log-*.jsonl (217 M) und workflows/ (797 M), /home/comdare/ernte-20260811-nacht7/, sowie docs/sessions/backups/*/owner-extrakte/ -- dort stehen weitere Zusagen und Owner-Worte, die in den Session-Dokumenten nur zusammengefasst sind. Die Doktrin (ZEHN-WOCHEN-EXPLORE, 'Rohtranskripte zuerst') verlangt sie; ich habe ausschliesslich die aufbereiteten Dokumente gelesen.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 038
GEGENSTAND: ERHEBUNG[3]-Luecke: Die sechs Workflow-Synthesen vom 12.08
ORT: 20260812
SOLL/FIX: Die sechs Workflow-Synthesen vom 12.08. im Volltext (20260812-WF1-SYNTHESE + WF1-BERGUNG-verify-ABCD * WF2 * WF3 * WF4 * WF5 * WF6, zusammen ~215 KB). Ich habe sie nur ueber das GESAMTURTEIL und die KON-Nachtraege referenziert. Jede dieser Dateien enthaelt eigene Erledigt-/Verify-Urteile je Agent (WF1 allein: 45/46 Agenten), die hier NICHT einzeln erhoben sind.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 039
GEGENSTAND: ERHEBUNG[3]-Luecke: 20260811-NACHGEHOLTER-DUALREVIEW-ergebnis.md (29 KB) -- nur die Kopfzeile gelesen
ORT: 20260811-NACHGEHOLTER-DUALREVIEW-ergebnis.md | 20260811
SOLL/FIX: 20260811-NACHGEHOLTER-DUALREVIEW-ergebnis.md (29 KB) -- nur die Kopfzeile gelesen. Enthaelt die Landeurteile je Paket, also eine dichte Menge von 'landefaehig/nicht landefaehig'-Behauptungen.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 040
GEGENSTAND: ERHEBUNG[3]-Luecke: 20260811-PLANABGRENZUNG-UND-CODEX-VOLLREVIEW.md Abschnitte 1-3 (Stichproben, die zehn P-Pakete je einzeln, 'was beide Stufen uebersahen') -- ich habe nur par.4 (F1-Luecke) und par.5 (Ungedeckt) gelesen
ORT: 20260811-PLANABGRENZUNG-UND-CODEX-VOLLREVIEW.md | 20260811
SOLL/FIX: 20260811-PLANABGRENZUNG-UND-CODEX-VOLLREVIEW.md Abschnitte 1-3 (Stichproben, die zehn P-Pakete je einzeln, 'was beide Stufen uebersahen') -- ich habe nur par.4 (F1-Luecke) und par.5 (Ungedeckt) gelesen. Dort stehen ~50 weitere Einzelbefunde mit Objekt-Angabe.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 041
GEGENSTAND: ERHEBUNG[3]-Luecke: Die Ledger-Nachtraege KON36 bis KON55 im Volltext (Z
ORT: unbekannt
SOLL/FIX: Die Ledger-Nachtraege KON36 bis KON55 im Volltext (Z. 201-1684) sowie KON1-KON35 -- ich habe nur KON49, KON56, KON57 gelesen und KON58 im Entwurf. Insbesondere KON44 (n/a-Falle), KON45 (Hybrid-Stempel/E-WARMUP), KON46 (Landungen/289/zwei korrigierte Eigenbefunde) und KON47 (Warmup-Paar testpflichtig) tragen eigene Vollzugs-Behauptungen.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 042
GEGENSTAND: ERHEBUNG[3]-Luecke: LEDGER-KONSOLIDIERUNG IV (Kapitel A-M mit ERGAENZT-Bloecken, ~780 Zeilen) -- die Pflicht-Kipp-Liste nennt sie ausdruecklich als Teil des geltenden Standes.
ORT: unbekannt
SOLL/FIX: LEDGER-KONSOLIDIERUNG IV (Kapitel A-M mit ERGAENZT-Bloecken, ~780 Zeilen) -- die Pflicht-Kipp-Liste nennt sie ausdruecklich als Teil des geltenden Standes.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 043
GEGENSTAND: ERHEBUNG[3]-Luecke: Die vier /goal-Referenzen im Volltext: GOAL-v8-Dossier (~686 Z.), WELLENPLAN-ENDFASSUNG-v2 (~2055 Z., par.1-par.17), DESIGNPLAN-tdd (~395 Z., par.9/par.9.5/par.10), ARBEITSWEISE-GESAMT-DOKTRIN.md (v3.5, ~831 Z.)
ORT: ARBEITSWEISE-GESAMT-DOKTRIN.md
SOLL/FIX: Die vier /goal-Referenzen im Volltext: GOAL-v8-Dossier (~686 Z.), WELLENPLAN-ENDFASSUNG-v2 (~2055 Z., par.1-par.17), DESIGNPLAN-tdd (~395 Z., par.9/par.9.5/par.10), ARBEITSWEISE-GESAMT-DOKTRIN.md (v3.5, ~831 Z.). Ich habe nur TEIL B/C/D der WELLENKONSOLIDIERUNG gelesen. Die F1-Definition selbst (GOAL :494, VII.3 :523-529) habe ich NICHT gelesen -- sie ist der Massstab fuer L57-01/GU-02.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 044
GEGENSTAND: ERHEBUNG[3]-Luecke: Die drei anderen Ledger der AUDIT-KLAUSEL: ce Code/external/comdare-cache-engine/docs/ledger-sections/*.md, prt-art, thesis
ORT: unbekannt
SOLL/FIX: Die drei anderen Ledger der AUDIT-KLAUSEL: ce Code/external/comdare-cache-engine/docs/ledger-sections/*.md, prt-art, thesis. Vollstaendigkeits-Audits laufen laut Ledger-Kopf ueber ALLE VIER.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 045
GEGENSTAND: ERHEBUNG[3]-Luecke: Die TaskList (user-sichtbares TODO) -- in dieser Rolle kein Zugriff
ORT: unbekannt
SOLL/FIX: Die TaskList (user-sichtbares TODO) -- in dieser Rolle kein Zugriff. Alle Task-Status-Behauptungen (#4 #7 #10 #11 #14 #16 #21 #22 #28 #30 #31 #32 #33 #80 #81 #84 #88) sind daher unerhoben und muessen von der Pruefstufe dort gegengelesen werden.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 046
GEGENSTAND: ERHEBUNG[3]-Luecke: Das Cluster-Repo (OD-7-Handout 20260813-*, Commit 1d7b5d0) und das Umbrella-Repo /home/comdare/Projekte (ARBEITSWEISE v3.5, Commit 6ac0ac9) -- beide nicht geoeffnet.
ORT: 20260813
SOLL/FIX: Das Cluster-Repo (OD-7-Handout 20260813-*, Commit 1d7b5d0) und das Umbrella-Repo /home/comdare/Projekte (ARBEITSWEISE v3.5, Commit 6ac0ac9) -- beide nicht geoeffnet.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 047
GEGENSTAND: ERHEBUNG[3]-Luecke: Der laufende Bau im Worktree /home/comdare/wt-ce-golden-s14a (@8257e517, bau/golden-s14a-riegel): auftragsgemaess NICHT angefasst
ORT: codex-funde-s14a-verifiziert.md | bau/golden-s14a-riegel | 8257e517
SOLL/FIX: Der laufende Bau im Worktree /home/comdare/wt-ce-golden-s14a (@8257e517, bau/golden-s14a-riegel): auftragsgemaess NICHT angefasst. Alle S-14a-Behauptungen sind daher nur aus KON58-Entwurf und codex-funde-s14a-verifiziert.md erhoben, nicht am Bau-Objekt.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 048
GEGENSTAND: ERHEBUNG[3]-Luecke: Die journal.jsonl-Dateien der Workflows (Doktrin: 'das Journal ist die Wahrheit, nicht der Task-Output')
ORT: journal.json
SOLL/FIX: Die journal.jsonl-Dateien der Workflows (Doktrin: 'das Journal ist die Wahrheit, nicht der Task-Output'). Alle Agenten-Zaehlungen (8/8, 10/10, 9/12, 0/4, 45/46, 235 Journale) stehen hier ungeprueft als Berichtszahlen.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 049
GEGENSTAND: ERHEBUNG[3]-Luecke: Die 20260810-* Session-Dokumente (AUSLAUF, CE-STEMPEL-WARNSTUFE, W0B-RESTPOSTEN, KONTEXTUEBERGABEN nacht-3 bis nacht-6)
ORT: 20260810
SOLL/FIX: Die 20260810-* Session-Dokumente (AUSLAUF, CE-STEMPEL-WARNSTUFE, W0B-RESTPOSTEN, KONTEXTUEBERGABEN nacht-3 bis nacht-6). Sie liegen ausserhalb des 11.-13.-Fensters, ihre mtime ist nur durch einen Checkout auf den 11.08. gesetzt -- sie enthalten aber die Vorgeschichte fast aller hier erhobenen Zusagen.
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 050
GEGENSTAND: ERHEBUNG[3]-Luecke: Die konkreten Zahlenwerte selbst: ich habe KEINE der erhobenen Zahlen nachgemessen (kein grep -c am Code, kein ctest, kein Pipeline-Abruf, kein gitleaks)
ORT: unbekannt
SOLL/FIX: Die konkreten Zahlenwerte selbst: ich habe KEINE der erhobenen Zahlen nachgemessen (kein grep -c am Code, kein ctest, kein Pipeline-Abruf, kein gitleaks). Erhoben sind ausschliesslich der Behauptungs-Wortlaut, sein Gegenstand und die Pruefform. Die einzigen von mir am Objekt abgelesenen Werte sind die Stand-Anker im Feld 'quelle' (HEADs, Gitlink, Worktree-Liste, Ledger-Zeilenzahl).
STATUS LT. QUELLE: offen (deklarierte Erhebungs-Luecke der Quelle)
ABHAENGIGKEIT/FLAECHE: Deckungsgrenze der 538er-Pruefung

### [wtk6lmhln.json] 051
GEGENSTAND: T-04b [TEILWEISE] Explore wq3sh10mx vollstaendig geborgen, owner-gedeckt (KON16-02/KON26-01/KON57-05)
ORT: timeline.json | 4.json
SOLL/FIX: Das Explore-Ergebnis wq3sh10mx ist als Artefakt nirgends auffindbar -- die 'Vollstaendigkeit' der Bergung ist nur die Behauptung des Tasks; KON57-05-Deckung der S-3/S-7-Strecke nicht im Wortlaut verifiziert.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): KON-Marker existieren: KON57-05 @:103 'WAS NACH DIESEM NACHTRAG OFFEN IST (Landesequenz dokumentiert)'; KON16/KON26 vorhanden. ABER: grep -r wq3sh10mx ueber jobs/, timeline.jsonl, tmp = 0 Treffer (einzige Fundstelle: der Task-Text 4.json selbst).

### [wtk6lmhln.json] 052
GEGENSTAND: T-08d [TEILWEISE] E-C: dump-plan-Herkunft produktionskritisch; Owner hat Begriff nicht gepraegt
ORT: profile_run_facade.hpp:259-275 | planner_version.hpp:9 | 46375cdc/5a19728e_owner_raw.json | 46375cdc
SOLL/FIX: Roh-Kanal traegt 38 'dump-plan'-Treffer (46375cdc/5a19728e_owner_raw.jsonl) in Lead-Berichtsstil -- Autorschaft nicht sauber getrennt; der Nichtfund ist nur fuer die kuratierten Texte belegt.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): --dump-plan + PlanTextBuilder existieren produktiv (profile_run_facade.hpp:259-275; planner_version.hpp:9 '--dump-plan-Header planner@1.0...') -- einziger Kanal der Plan-Zahl. Owner-Korpus: 0 Treffer in den 180 kuratierten Owner-Texten.

### [wtk6lmhln.json] 053
GEGENSTAND: T-10b [TEILWEISE] Vault-Blind-Smoke gefahren (mc-Mechanik validiert, Koeder biss rc=1)
ORT: minio_blind_smoke.sh
SOLL/FIX: Kein persistiertes Lauf-Log gefunden (kein 'Kandidaten: access='-Output in tmp) -- rc-Werte des behaupteten Laufs nicht belegbar.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): minio_blind_smoke.sh existiert und ist doktrin-konform (mapfile, Werte nie argv/stdout, K13-Koeder ZUERST mit Abbruch 'KOEDER BISS NICHT - Smoke wertlos'); Einordnung korrekt: Erreichbarkeit!=Key-Gueltigkeit.

### [wtk6lmhln.json] 054
GEGENSTAND: T-10c [TEILWEISE] Vault-Zeilen sind Prosa, mehrere entwertet (Z470, Z620/621)
ORT: unbekannt
SOLL/FIX: Z621 traegt selbst keinen Marker -- moeglicherweise vom Z620-Marker als Block mitgedeckt; nicht am Objekt entschieden.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Blind-mapfile-Pruefung (ohne Inhaltsausgabe): Z470 MARKER_GEFUNDEN, Z620 MARKER_GEFUNDEN, Z621 ohne Entwertet-Marker (10 Wortvarianten geprueft).

### [wtk6lmhln.json] 055
GEGENSTAND: T-10d [TEILWEISE] refs/backup/pre-secret-scrub-20260802 von super UND ce origin verschwunden, kein Bundle
ORT: unbekannt
SOLL/FIX: 'kein Bundle gefunden' ist unpraezise: PRE-SCRUB-Bundles vom 25./26.07. EXISTIEREN (~/prescrub-bundles-2026-07-25/ + ~/scrub-backups/, inkl. ce+super+SHA256SUMS) -- nur keines vom 02.08. Das Delta bleibt ungebucht (Ledger-Kopf = 12.08.); Owner-Frage steht aus.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): git ls-remote 'refs/backup/*' 'refs/heads/backup/*' auf ALLEN VIER Seiten (super/ce x origin/github): kein pre-secret-scrub-Ref (super-origin traegt nur backup/gitlab-artifact-development-2026-07-25). Kein 0802-Bundle gefunden.

### [wtk6lmhln.json] 056
GEGENSTAND: T-10f [TEILWEISE] 776 = gitleaks-Trefferzahl; Instanz akzeptiert Registration-Tokens
ORT: unbekannt
SOLL/FIX: Herkunft der 776 nicht rekonstruiert -- kein Report/Config-Beleg auffindbar; nach der Koeder-Lehre (T-34f) ist die Zahl ohne Biss-Beleg schwach.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): GET /application/settings: allow_runner_registration_token = True (bestaetigt).

### [wtk6lmhln.json] 057
GEGENSTAND: T-14a [TEILWEISE] ce-Pipeline GRUEN (15751 SUCCESS @ a99c4a18)
ORT: a99c4a18
SOLL/FIX: Die Pipeline enthaelt is_original:relock (manual, allow_failure=True) -- Dauer-Manual-Job in JEDER ce-Pipeline; nach MEMORY-Doktrin ('allow_failure VERBOTEN') mindestens benennungspflichtig.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): JOBLISTE 15751: 23 Jobs success @sha a99c4a18, Gesamtstatus success.

### [wtk6lmhln.json] 058
GEGENSTAND: T-14d [NICHT_ERLEDIGT] 0 allow_failure/when:never, Gegenprobe biss
ORT: .gitlab-ci.yml
SOLL/FIX: Die Null gilt nicht fuer die heutigen Dateien; der damalige Zaehl-Nenner (welche Datei-/Job-Menge) ist unbenannt. Nachzupruefen, ob die 3 Ausnahmen doktrin-konform deklariert werden sollen (manual-Opt-ins) oder fallen muessen.
STATUS LT. QUELLE: offen (Behauptung faellt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Heute am Objekt: ce .gitlab-ci.yml traegt 2x 'allow_failure: true' (:257 build:arm64-smoke, :898 is_original:relock manual); super 1x (:2751 ergebnis:holen, when:manual opt-in). grep -cE '^\s*allow_failure' super=1, ce=2.

### [wtk6lmhln.json] 059
GEGENSTAND: T-14f [TEILWEISE] D-Worktree nach neuer Loeschregel (KON49-02) entfernt
ORT: bau/strang-d-f1-f2-wachen
SOLL/FIX: Ein Nachweis, dass die damalige Loeschung BEIDE ce-Stores prueft, existiert nicht -- heutige Gegenpruefung (beide Stores enumeriert) findet nichts Verlorenes.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Worktree wf_d826aca8 existiert nicht mehr (git worktree list); Branch bau/strang-d-f1-f2-wachen existiert in Store 1 und ist GELANDET (merge-base ancestor origin/development); KON49-02 @:585 dokumentiert Regel + Vorfall.

### [wtk6lmhln.json] 060
GEGENSTAND: T-14g [TEILWEISE] drei #84-Testdateien neu erheben
ORT: unbekannt
SOLL/FIX: Ein expliziter Neuerhebungs-Beleg fuer 'drei Testdateien' existiert nirgends; welche drei Dateien gemeint waren, ist nicht rekonstruierbar -- mit dem Task-Abschluss verloren.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): #84 geheilt (KON57-02 F12) und Pipelines 15770/15774 gruen.

### [wtk6lmhln.json] 061
GEGENSTAND: T-16a [TEILWEISE] Teil 1 gebaut+verifiziert (TRAEGT): golden-Baseline 158, a8465ef3
ORT: a8465ef3 | 8cc564d5
SOLL/FIX: Der Verify-TRAEGT war teilmengen-wahr; Heilung liegt inzwischen im Branch (Fixup 3 8cc564d5: Overlay-Grundgesamtheit 718 Records) -- Landung auf development steht aus.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): a8465ef3 existiert ('golden(axis-lock): Baseline auf 158 Traeger'); Lock v2 nachgezaehlt: 6 heuristik + 152 organ = 158 Records. ABER Grundgesamtheit neu erhoben: 387 hpp in axes+topics/queuing, nur 152 mit Substring -- 'TRAEGT' pruefte den Nenner nicht (V0-Klasse, wie Task 36 fand).

### [wtk6lmhln.json] 062
GEGENSTAND: T-16c [TEILWEISE] Digest-Kontinuitaet 158/158 identisch
ORT: unbekannt
SOLL/FIX: Beweist nichts ueber die 235 nie gelockten Dateien (Erhebungs-Einwand trifft); Fixup 3 ersetzt durch 718-Record-Lock mit Deckungszeile 'deckt 712 von 712'.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Als Teilmengen-Aussage konsistent (Lock v2 6+152).

### [wtk6lmhln.json] 063
GEGENSTAND: T-16f [TEILWEISE] MESS hat keine Achsen-Header, nur Versions-Infra
ORT: algo_semver.hpp | axis_version_stamp.hpp | ceb_system_axis.hpp
SOLL/FIX: Gegenprobe beisst: dasselbe Verzeichnis traegt Achsen-Header (ceb_system_axis.hpp, compiler_system_axis.hpp, hardware_isa_system_axis.hpp, load_framework_measurement_axis.hpp u.a.) -- per Fixup-3-Overlay als Kategorie system (16 Dateien) klassifiziert, mess-Kategorie selbst = 1 Datei. Die Aussage gilt nur fuer die Overlay-Kategorie, nicht fuers Verzeichnis.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): algo_semver.hpp + axis_version_stamp.hpp existieren unter include/cache_engine/measurement/.

### [wtk6lmhln.json] 064
GEGENSTAND: T-21d [TEILWEISE] Ledger-Selbstwiderspruch :9468/:8941 (Anker gedriftet)
ORT: unbekannt
SOLL/FIX: Das Widerspruchs-SYMBOL des Tasks ist aus dem Task-Text nicht rekonstruierbar -- welcher Widerspruch exakt gemeint war, bleibt offen (per Symbol nachtragen).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Drift am Objekt bestaetigt: :8941='#### KON-20 -- BEI CI-STAUS...', :9468='#### KON-62 -- ROHTRANSKRIPTE...' (anderes als gemeint). Der OD-7/32T-24K-Selbstwiderspruch ist als Seiten-A/B/C-Block @:8574ff dokumentiert und via KON25-03/KON28 aufgeloest.

### [wtk6lmhln.json] 065
GEGENSTAND: T-22a [TEILWEISE] OD-7-Umsetzung vollstaendig spezifiziert (KON28+29); Explore wo0oghvqu vollstaendig
ORT: timeline.json
SOLL/FIX: Explore wo0oghvqu nur als Journal-Eintrag 'Reading wo0oghvqu' (timeline.jsonl 13.08. 05:19) belegt; Ergebnis-Artefakt nicht in tmp abgelegt.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): KON28-01 @:2961ff: Owner-verbatim '16 heruntergestuft, es gab Probleme ... Kette bis release mit dem --debug Flag'; ENTSCHEID 24->16 + KOMPENSATION --debug bis 15.09.; KON29 traegt die Debug-Betriebsdoktrin -- Spezifikation steht.

### [wtk6lmhln.json] 066
GEGENSTAND: T-22b [GEGENSTANDSLOS] Q6-Kommentar-Nachzug LAEUFT (Branch bau/q6-dock32-nachzug)
ORT: 58579575 | f23c18e2
SOLL/FIX: -
STATUS LT. QUELLE: nur-hinweis (gegenstandslos/ueberholt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Zeitlich ueberholt: Task-22-Text (05:41) beschreibt den Stand VOR der Landung; am Objekt: 58579575 (05:40) als no-ff-Merge f23c18e2 (06:24) auf development, beide Remotes = f23c18e2. Task 34 hat recht; Task-22-Text wurde nicht fortgeschrieben.

### [wtk6lmhln.json] 067
GEGENSTAND: T-22d [TEILWEISE] Infra-Handout geschrieben (untracked, commit+push beim #22-Landen)
ORT: runner-mode.sh:43
SOLL/FIX: Zustellung + Commit + Umsetzung (HEAVY_J=16) stehen aus; #22 ist in_progress -- vor F1 zu landen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Datei existiert (3550 B, 13.08. 06:11); git status: '??' = weiterhin untracked (nicht committet, nicht gepusht, nicht zugestellt); Gegenstand live: Cluster runner-mode.sh:43 'prod1) ... HEAVY_J=24' -- die 24->16-Umsetzung ist noch nirgends vollzogen.

### [wtk6lmhln.json] 068
GEGENSTAND: T-23b [GEGENSTANDSLOS] Ergebnis als KON31 vorgelegt
ORT: unbekannt
SOLL/FIX: -
STATUS LT. QUELLE: nur-hinweis (gegenstandslos/ueberholt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Nummern-Kollision aufgeloest: KON31 @:2672 = 'R-2 TECHNISCH PRAEZISIERT' (anderer Gegenstand); das WF6-Ergebnis traegt KON34. Die Task-Description war eine Prognose vor der Landung; Subject (KON34) stimmt. Ledger-Doktrin 'Gegenstand vor Nummer' (KON39-Vermerk) deckt den Fall.

### [wtk6lmhln.json] 069
GEGENSTAND: T-26c [TEILWEISE] Owner-Fragen auf OF-1...OF-4 reduziert
ORT: unbekannt
SOLL/FIX: Die Task-Formulierung suggeriert eine abschliessende Vier-Liste; am Objekt kam OF-5 hinzu (Task-22-'OF-5-Lesart' bestaetigt) -- bei Wiederverwendung der Zahl die Zeitmarke mitfuehren.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): KON39 :1448 'Offen nach diesem Nachtrag: OF-1...OF-4' -- zum Zeitpunkt wahr. Danach: KON40-03 schuf OF-5 (F-D-Spannung), KON41 beantwortete OF-5/1/2/3, OF-4 -> Bestands-Explore.

### [wtk6lmhln.json] 070
GEGENSTAND: T-28b [TEILWEISE] dockt an S-16 an (Shell->GTest, 13 Dateien/7.967 Z.)
ORT: unbekannt
SOLL/FIX: Die S-16-Menge '13 Dateien/7.967 Z.' ist nirgends als Liste materialisiert -- Nenner unbelegt; der Posten TEST-KONSOLIDIERUNG (KON37-08, Wellenkonsolidierung :253) braucht die konkrete Datei-Liste.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Unter tests/ 0 .sh-Dateien; Repo gesamt 145 .sh (scripts/ci_*-Wachen etc.).

### [wtk6lmhln.json] 071
GEGENSTAND: T-30c [TEILWEISE] ce-CI 15759 SUCCESS (beide Compiler)
ORT: unbekannt
SOLL/FIX: Erstlauf pmc:intel (376175) FAILED (allow_failure=False) und wurde retried (376192 success) -- 'SUCCESS' gilt erst nach Retry; ausserdem Dauer-Manual-Job is_original:relock (allow_failure=True) in der Pipeline.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Jobliste 15759: Gesamtstatus success; build:clang vorhanden (gcc = Basis der uebrigen Jobs).

### [wtk6lmhln.json] 072
GEGENSTAND: T-30e [NICHT_ERLEDIGT] WARTE-Liste W-A...W-D bleibt ausdruecklich liegen
ORT: unbekannt
SOLL/FIX: Die 12.08.-Warte-Liste W-A...W-D existiert NUR im abgeschlossenen Task-Text -- in kein Plandokument/Ledger uebertragen; Nachtrag noetig, sonst verloren.
STATUS LT. QUELLE: offen (Behauptung faellt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): grep W-A|W-B|W-C|W-D: 0 Treffer in der Wellenkonsolidierung; Ledger-Treffer nur Alt-Objekte vom 05.08. (Neuanker/B13 -- andere W-Buchstaben).

### [wtk6lmhln.json] 073
GEGENSTAND: T-31a [TEILWEISE] vollstaendige Branch-Erhebung in beiden ce-Stores
ORT: bau/s3-ordnungsrelation
SOLL/FIX: Gegenprobe fand weitere bare Verify-Klone (~/di-freshverify/*.git, ~/di-verify/*.pre.git) -- read-only-Artefakte, aber die Allaussage 'nur zwei Stores' ist unscharf.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Beide Arbeits-Stores enumeriert: Store 1 (.git/worktrees/.../modules/...) 18 Branches, Store 2 (.git/modules/...) 148 -- je +1 seit Erhebung (neuer Branch bau/s3-ordnungsrelation 13.08.).

### [wtk6lmhln.json] 074
GEGENSTAND: T-31e [GEGENSTANDSLOS] vier Workflow-Worktrees checken ungelandete Branches aus (mod=0)
ORT: unbekannt
SOLL/FIX: -
STATUS LT. QUELLE: nur-hinweis (gegenstandslos/ueberholt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Die vier Worktrees existieren nicht mehr (git worktree list: nur Submodul + wt-ce-golden-s14a + wt-ce-mess-ordnung) -- von der T-31f-Aufraeumung erfasst; ihre Branches existieren in Store 2 und sind OFFEN wie gelistet (w0a/d2-floor, worktree-wf_e22d25ef-71c-7). 'mod=0' nicht mehr pruefbar.

### [wtk6lmhln.json] 075
GEGENSTAND: T-32e [TEILWEISE] Dual-Review zu, T-1 4/4, Kombibau 4x485/485
ORT: 6f537245 | 58579575
SOLL/FIX: Kombibau 4x485 nicht unabhaengig neu erhoben (kein Vollbau in dieser Pruefung); CI-Nenner weichen ab (482@15751, 483@15770, 479@15774 -- bedingte Registrierung).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Dual-Review: KON57-03 (LENS 2 Codex TRAEGT_MIT_FIXES, 3 HINWEISE -> 6f537245) -- geschlossen; T-1-Protokoll existiert (KON57-03). Lokal-485 plausibilisiert: Commit 58579575 zitiert '100% tests passed ... out of 485'.

### [wtk6lmhln.json] 076
GEGENSTAND: T-32f [TEILWEISE] Worktree fixup-s1-haertung nach Loeschregel entfernt
ORT: bau/s1-codex-haertung | 7d65eb6c
SOLL/FIX: Der Branch bau/s1-codex-haertung existiert in KEINEM Store mehr (geloescht statt ueberlebend) -- inhaltlich gedeckt durch den Merge, aber die 'Branches ueberleben'-Regel wurde hier nicht gelebt; Alt-Nachweis der Beide-Stores-Pruefung fehlt.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Worktree weg; Inhalt gelandet: Merge 7d65eb6c auf development (Ancestor-Check bestanden).

### [wtk6lmhln.json] 077
GEGENSTAND: T-32g [TEILWEISE] Abnahme: Wegwerf-Mutations-Rot je Fix (11x)
ORT: unbekannt
SOLL/FIX: Kein 11-facher Einzelnachweis im Ledger-Block; weitere Koeder stecken vermutlich in den Fix-Commit-Messages -- als Sammelbeleg, nicht als 11 dokumentierte Einzel-Rot-Laeufe.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): KON57-03 T-1-MUTATIONS-PROTOKOLL dokumentiert 4 benannte Mutationen (M-F1 3x static_assert-Rot, M-F2b inkl. protokollierter Wiederholung nach Falsch-Biss, M-F3, M-H10).

### [wtk6lmhln.json] 078
GEGENSTAND: T-33b [TEILWEISE] Riegel v2 modular, 158 Traeger statt 6
ORT: f2f9fc05
SOLL/FIX: Grundgesamtheit war 387 (Substring-Filter :431/:435 im Fixup-2-Stand) -- von mir unabhaengig bestaetigt; im Fixup 3 'ERSATZLOS GEFALLEN' (Overlay-Schnitt 718 Records) -- Landung ausstehend.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Modular [OK] (HeuristikDetail/OrganDetail, f2f9fc05); 158 = wahre Substring-Menge (152+6, nachgezaehlt).

### [wtk6lmhln.json] 079
GEGENSTAND: T-33c [TEILWEISE] Koeder A-E + Rot-zuerst D + v1-Abweisung + T-i-2
ORT: unbekannt
SOLL/FIX: Geschlossen erst durch Fixup 2 G7 (Koeder L: heuristik-ROT beidseitig erstmals gefahren) -- im Branch, ungelandet.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Koeder-Kette existierte; bestaetigter Mangel (2 Lenses unabhaengig, E3+K4): Heuristik-Kategorie hatte KEINEN Rot-Koeder (A waehlt organ, B-G synthetischer organ-Traeger).

### [wtk6lmhln.json] 080
GEGENSTAND: T-33d [TEILWEISE] Golden-Kontinuitaet 158/158 unabhaengig nachgerechnet
ORT: unbekannt
SOLL/FIX: Wie T-16c: Aussage nur ueber die discovered-Teilmenge; die 235 nie gelockten Dateien deckt sie nicht.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Teilmengen-Kontinuitaet plausibel (Lock v2 6+152)

### [wtk6lmhln.json] 081
GEGENSTAND: T-33e [TEILWEISE] ctest -N 485->486; Kombibau 4x486 lokal
ORT: test_s14_axis_version_lock_tripwire.cpp | Test-.cpp | 58579575
SOLL/FIX: 486 nicht neu erhoben (kein Vollbau); die Kette 482->485->486 vermengt CI- und Lokal-Nenner -- der Nenner ist bedingt registrierend (coverage-guard weist '5 von 5 Bloecke gelaufen' aus), je Sprung fehlt die Benennung des hinzugekommenen Tests.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Neu erhoben (CI): test:unit 482 (15751) / 483 (15770) / 479 (15774), je '100% passed'; lokal 485 belegt via 58579575-Zitat; +1 Testdatei im Branch nachgewiesen (test_s14_axis_version_lock_tripwire.cpp; Test-.cpp im Baum 498->499).

### [wtk6lmhln.json] 082
GEGENSTAND: T-33f [TEILWEISE] Pflicht-Fixup 3cba6ade+8257e517, +214/-13, Koeder F/G
ORT: unbekannt
SOLL/FIX: Zahlendifferenz 215/14 vs. 214/13 unaufgeklaert (vermutlich Zaehlform); korrekt bleibt: fail-closed loest NICHT die Substring-Luecke -- die fiel erst mit Fixup 3.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Beide Commits existieren mit den beschriebenen Inhalten (fail-closed Discovery, strenger Lock-Parser); Summe neu gerechnet: (+89/-10) + (+126/-4) = +215/-14 -- nicht +214/-13 (Delta 1/1).

### [wtk6lmhln.json] 083
GEGENSTAND: T-34g [TEILWEISE] echter Scan: Push-Inhalt, 2 Commits/198 Diff-Zeilen
ORT: 7d65eb6c | f23c18e2
SOLL/FIX: '198 Diff-Zeilen' mit keiner Standard-Messform reproduzierbar (shortstat 30+/1-=31; unified diff 71; log -p 126; show 101) -- Zahl unbelegt; der Scan mit --pipe --config -m wurde nicht wiederholt.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): 2 Commits [OK] (rev-list --count 7d65eb6c..f23c18e2 = 2).

### [wtk6lmhln.json] 084
GEGENSTAND: T-34h [TEILWEISE] Lehre gehoert in Arbeitsweise/Fallen-Register
ORT: unbekannt
SOLL/FIX: Projekt-Doku-Nachzug offen: Lehre weder in ARBEITSWEISE v3.9 noch als Ledger-NACHTRAG (Kopf = 12.08.) -- Nachimplementierung.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): MEMORY gepflegt (13.08.); ARBEITSWEISE ist heute v3.9 (13.08.) und traegt gitleaks-Regeln (-m, repo-eigene toml), aber NICHT die neue Regel-Klassen-Lehre (kein glpat-Koeder-Passus; grep glpat = 0).

### [wtk6lmhln.json] 085
GEGENSTAND: T-36c [TEILWEISE] K1 gefahren: 3 Dateien geaendert -> GRUEN '158 Dateien'
ORT: unbekannt
SOLL/FIX: Live-Reproduktion des Alt-Zustands nicht wiederholt (Objekt im Branch inzwischen Fixup 3; Alt-Lauf nur via altem Commit im tmp moeglich -- verzichtet, da Kernzahlen unabhaengig bestaetigt).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Der Wortlaut 'GRUEN bestand konsistent -- 158 Dateien' ist im Fixup-3-Commit als rot-zuerst-Beleg zitiert; Zahlen-Differenz aufgeklaert: 158 = 152 organ + 6 heuristik (Werkzeug-Output zaehlt beide Kategorien).

### [wtk6lmhln.json] 086
GEGENSTAND: T-36h [TEILWEISE] Entlastungen (Bijektion, fail-closed, strenger Parser, Drift-Zellen rot)
ORT: 3cba6ade | 8257e517
SOLL/FIX: Erst Fixup 3 D4 liefert den echten Deckungs-Beleg ('deckt 712 von 712' in der GRUEN-Zeile) -- die urspruengliche Entlastung war teilmengen-wahr.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Entlastungs-Nenner offengelegt: die 'Bijektion Baum<->Register' lief ueber die discovered-Menge (152/158) -- bzgl. der 235 trivial; die uebrigen Entlastungen (fail-closed, Parser G1-G4) decken sich mit 3cba6ade/8257e517.

### [wtk6lmhln.json] 087
GEGENSTAND: Q-03 [TEILWEISE] drei ctest-Nenner (482/485/486) in drei Meldungen
ORT: Test-.cpp | a99c4a18 | 7d65eb6c | f23c18e2
SOLL/FIX: Die Task-Kette vermengt CI- und Lokal-Nenner ohne Kennzeichnung; der 479er-Abfall bei doku-only-Merge (Lane-bedingt) zeigt, dass die Zahl ohne Umgebungsangabe nicht vergleichbar ist -- Meldungen sollten den Nenner-Kontext (lokal/CI, Lane) mitfuehren.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Neu erhoben: CI test:unit = 482 (15751@a99c4a18), 483 (15770@7d65eb6c), 479 (15774@f23c18e2) -- je '100% passed'; lokal = 485 (Zitat in 58579575), 486 (Branch, +1 Testdatei belegt via 498->499 Test-.cpp). Der Nenner ist bedingt registrierend (Umgebung/Lane); der coverage-guard weist die Bedingtheit aus ('bedingte Registrierungs-Bloecke: 5 von 5 gelaufen, kein stiller Schwund'); leere Testverzeichnisse tragen 0 bei.

### [wtk6lmhln.json] 088
GEGENSTAND: V[0]-nicht_pruefbar[0]: Kombibau-Zahlen 4x485/485 (T-32e) und 4x486/486 (T-33e) lokal: nicht neu erhoben -- ein Vollbau ausserhalb des tmp-Verzeichnisses war untersagt und im Zeitrahmen nicht leistbar; CI-
ORT: unbekannt
SOLL/FIX: Kombibau-Zahlen 4x485/485 (T-32e) und 4x486/486 (T-33e) lokal: nicht neu erhoben -- ein Vollbau ausserhalb des tmp-Verzeichnisses war untersagt und im Zeitrahmen nicht leistbar; CI-Traces liefern abweichende, umgebungsbedingte Nenner (482/483/479).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 089
GEGENSTAND: V[0]-nicht_pruefbar[1]: Live-Reproduktion der Alt-Werkzeug-Defekte K1/K2/K4 (T-36c/d/f) am Vor-Fixup-Stand: verzichtet, weil der Branch waehrend der Pruefung auf Fixup 3 (8cc564d5) vorgerueckt ist; gestue
ORT: 8cc564d5
SOLL/FIX: Live-Reproduktion der Alt-Werkzeug-Defekte K1/K2/K4 (T-36c/d/f) am Vor-Fixup-Stand: verzichtet, weil der Branch waehrend der Pruefung auf Fixup 3 (8cc564d5) vorgerueckt ist; gestuetzt auf unabhaengige Zahlen-Reproduktion + rot-zuerst-Protokolle in den Commits.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 090
GEGENSTAND: V[0]-nicht_pruefbar[2]: Historischer Nachweis, dass die Worktree-Loeschungen vom 12./13.08
ORT: unbekannt
SOLL/FIX: Historischer Nachweis, dass die Worktree-Loeschungen vom 12./13.08. (T-14f, T-32f) zum Loeschzeitpunkt BEIDE ce-Stores prueften -- nur die heutige Non-Loss-Gegenprobe war moeglich.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 091
GEGENSTAND: V[0]-nicht_pruefbar[3]: Das Widerspruchs-Symbol hinter T-21d (Ledger :9468/:8941): aus dem Task-Text nicht rekonstruierbar; die Anker tragen heute andere Inhalte.
ORT: unbekannt
SOLL/FIX: Das Widerspruchs-Symbol hinter T-21d (Ledger :9468/:8941): aus dem Task-Text nicht rekonstruierbar; die Anker tragen heute andere Inhalte.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 092
GEGENSTAND: V[0]-nicht_pruefbar[4]: Herkunft der Zahl 776 (T-10f): kein gitleaks-Report/Config-Beleg auffindbar.
ORT: unbekannt
SOLL/FIX: Herkunft der Zahl 776 (T-10f): kein gitleaks-Report/Config-Beleg auffindbar.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 093
GEGENSTAND: V[0]-nicht_pruefbar[5]: Die '198 Diff-Zeilen' (T-34g): mit keiner Standard-Messform reproduzierbar (31 changed / 71 unified / 126 log-p / 101 show).
ORT: unbekannt
SOLL/FIX: Die '198 Diff-Zeilen' (T-34g): mit keiner Standard-Messform reproduzierbar (31 changed / 71 unified / 126 log-p / 101 show).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 094
GEGENSTAND: V[0]-nicht_pruefbar[6]: Explore-Artefakt wq3sh10mx (T-04b): nirgends auf Platte auffindbar (einzige Fundstelle: der Task-Text selbst); wo0oghvqu nur als Journal-Lesevorgang belegt.
ORT: unbekannt
SOLL/FIX: Explore-Artefakt wq3sh10mx (T-04b): nirgends auf Platte auffindbar (einzige Fundstelle: der Task-Text selbst); wo0oghvqu nur als Journal-Lesevorgang belegt.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 095
GEGENSTAND: V[0]-nicht_pruefbar[7]: mod=0-Zustand der vier geloeschten Workflow-Worktrees (T-31e): Objekte existieren nicht mehr.
ORT: unbekannt
SOLL/FIX: mod=0-Zustand der vier geloeschten Workflow-Worktrees (T-31e): Objekte existieren nicht mehr.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 096
GEGENSTAND: V[0]-nicht_pruefbar[8]: Autorschafts-Trennung der 38 'dump-plan'-Treffer im Owner-Rohkanal (T-08d): Lead-zitierte vs
ORT: unbekannt
SOLL/FIX: Autorschafts-Trennung der 38 'dump-plan'-Treffer im Owner-Rohkanal (T-08d): Lead-zitierte vs. Owner-eigene Zeilen nicht sauber trennbar ohne Tiefenanalyse der jsonl-Provenienz.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 097
GEGENSTAND: V[0]-nicht_pruefbar[9]: Die Task-Liste selbst wurde (wie in der Erhebung) aus dem On-Disk-Store gelesen; TaskList/TaskGet waren nicht exponiert -- im Speicher gehaltene, ungeschriebene Tasks waeren unsicht
ORT: unbekannt
SOLL/FIX: Die Task-Liste selbst wurde (wie in der Erhebung) aus dem On-Disk-Store gelesen; TaskList/TaskGet waren nicht exponiert -- im Speicher gehaltene, ungeschriebene Tasks waeren unsichtbar (Gegenindiz: mtimes bis 07:45 unmittelbar vor Start).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 098
GEGENSTAND: V[0]-nicht_pruefbar[10]: WICHTIGER LAUFZEIT-HINWEIS: der Bau-Agent hat WAEHREND dieser Verifikation Fixup 3 (8cc564d5) auf bau/golden-s14a-riegel committet -- Urteile zu T-16/T-33/T-35/T-36 nennen deshalb j
ORT: bau/golden-s14a-riegel | 8cc564d5
SOLL/FIX: WICHTIGER LAUFZEIT-HINWEIS: der Bau-Agent hat WAEHREND dieser Verifikation Fixup 3 (8cc564d5) auf bau/golden-s14a-riegel committet -- Urteile zu T-16/T-33/T-35/T-36 nennen deshalb je den Stand vor UND nach diesem Commit; der Branch ist weiterhin UNGELANDET (nicht auf origin/development).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 099
GEGENSTAND: V[0]-nicht_pruefbar[11]: NACHIMPLEMENTIERUNGS-KANDIDATEN aus dieser Pruefung (Kurzliste): (1) T-14d allow_failure-Bestand klaeren/deklarieren (ce 2x, super 1x); (2) T-22d Cluster-Handout committen+zustelle
ORT: runner-mode.sh
SOLL/FIX: NACHIMPLEMENTIERUNGS-KANDIDATEN aus dieser Pruefung (Kurzliste): (1) T-14d allow_failure-Bestand klaeren/deklarieren (ce 2x, super 1x); (2) T-22d Cluster-Handout committen+zustellen UND runner-mode.sh prod1 HEAVY_J 24->16 umsetzen; (3) T-30e W-A...W-D aus dem Task in Ledger/Plan retten; (4) T-34h glpat-Regel-Klassen-Lehre in ARBEITSWEISE+Ledger nachtragen; (5) T-10d Backup-Ref-Delta als Ledger-NACHTRAG buchen + Owner-Frage stellen; (6) S-14a-Branch landen (Fixup 1-3), danach Gitlink-Bump 7. Zug (T-34i) mit vorbereiteter PZW-Fussnote; (7) T-28b S-16-Datei-Liste (die '13') materialisieren.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 100
GEGENSTAND: B-01 [TEILWEISE] Lens 1: 5 ERNST am Objekt bestaetigt
ORT: f837420b | 84e6099a
SOLL/FIX: Der Lens-1-BERICHT selbst wurde nicht aufgeschlagen; ob '5/5 bestaetigt' eigene Messung oder Berichtsuebernahme war, bleibt unbelegt (V1).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Die Fix-Commits existieren mit passendem Inhalt: git show --stat f837420b (stempel_basis+2 Tests), 84e6099a (6+ Dateien inkl. 4 Anker-Traeger). Objekt traegt die Fixes (F1-Trait-Split-Datei, 13er-Pin, Anker :109/:114).

### [wtk6lmhln.json] 101
GEGENSTAND: B-03 [TEILWEISE] F1 Trait-Split stempel_baustein_trait.hpp + AbiPod beim POD-Eigentuemer, beidseitiger Mini-TU-Beweis
ORT: libs/cache_engine/include/cache_engine/abi/stempel_baustein_trait.hpp | decl.hpp:252
SOLL/FIX: Der beidseitige Mini-TU-Beweis (HEAD rc=0 / Altstand 3 static_asserts reissen) wurde nicht nachgefahren -- kein Bau im Verify-Rahmen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Datei existiert: libs/cache_engine/include/cache_engine/abi/stempel_baustein_trait.hpp; Kopf dokumentiert die Include-Order-Falle ('specialization after instantiation') und die Auslagerung; AbiPod-Spezialisierungen bei decl.hpp:252/:255.

### [wtk6lmhln.json] 102
GEGENSTAND: B-08 [TEILWEISE] Lande-Vollbau-Skript faehrt ab sofort BEIDE Compiler je Konfiguration
ORT: jobs/5a19728e/tmp/landung-kombibau.sh | 5a19728e
SOLL/FIX: Das Skript liegt NUR im fluechtigen Job-tmp (kein Treffer in super/ce scripts|ci) -- 'Regel ins Werkzeug' ist nicht repo-versioniert; beim Aufraeumen des Job-Ordners stirbt sie.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): jobs/5a19728e/tmp/landung-kombibau.sh Z.9-13: for CCPAAR in "gcc:g++" "clang:clang++" ... for CFG in Debug Release -- 2x2 im Skript; 4 fixup-Logs beweisen den 2x2-Lauf.

### [wtk6lmhln.json] 103
GEGENSTAND: W-01 [TEILWEISE] Lens 2 TRAEGT_MIT_FIXES, 3 Hinweise, alle in 6f537245
ORT: 6f537245
SOLL/FIX: Lens-2-Bericht nicht gelesen; H-A (Fixed-Extent-Spans) und H-B (3 stale Orts-Kommentare) nicht einzeln der Diff-Zeile zugeordnet.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): git show --stat 6f537245: 4 Dateien (decl 15, anatomy_stamp_entries 4, stempel_basis 22, koeder-Test 14) -- passt zu H-A/H-B/H-C-Klassen; H-C (13-Namen-Pin) am Objekt verifiziert.

### [wtk6lmhln.json] 104
GEGENSTAND: L-09 [TEILWEISE] Lokal J-1..J-4 ctest Debug+Release 485/485 (GCC), clang via CI deklariert
ORT: 671d7f6a
SOLL/FIX: J-1..J-4-Werkzeug-Vorstufe (Emitter/Registry-Gen -> RE-CONFIGURE) in den Logs nicht nachgewiesen; Zuordnung der Logs zu exakt 671d7f6a nur ueber Zeit/Name.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): landung-kombibau-debug/release-ctest.log (12.08. 18:37/18:41) je '100% tests passed ... out of 485'; conf1-Log: 'The CXX compiler identification is GNU 15.3.0'.

### [wtk6lmhln.json] 105
GEGENSTAND: L-16 [TEILWEISE] a99c4a18 gelandet; 0 allow_failure/when:never; gitleaks 6 Commits/2865 Zeilen koeder-gedeckt
ORT: a99c4a18
SOLL/FIX: 2865 nicht reproduziert (Merge-Diff: 1284 unified-Zeilen, 864+/205-=1069 Aenderungszeilen -- Zaehlweise der 2865 unbekannt); gitleaks-Log ('commits scanned', Koeder-Regelherkunft) nicht aufgeschlagen -- nach 13.08.-Memory beisst nur ein Koeder AUS EINER CONFIG-REGEL (glpat-+20).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): git diff a99c4a18^1..a99c4a18 | grep -c 'allow_failure|when: never' = 0; das gewollte '+when: always' vorhanden; Bereich = 5 Commits + Merge = 6.

### [wtk6lmhln.json] 106
GEGENSTAND: P-03 [TEILWEISE] 13 ungelandete ce-Branches, darunter 3 vom 10.08. je 1 Commit
ORT: bau/p2-warnstufe-aufteilen/p6-lizenz-umsetzung/p3-ci-clang-pflicht
SOLL/FIX: Zahl heute 20 statt 13 (neue Straenge seit 12.08.); die drei ce-Seiten sind WEITER ungelandet -- offener Posten.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Geteilter Store (Projekte/Research/.../.git/modules/.../comdare-cache-engine): branch --no-merged development = 20 (heute); die drei existieren: bau/p2-warnstufe-aufteilen/p6-lizenz-umsetzung/p3-ci-clang-pflicht mit je 'log development..<b> | wc -l' = 1.

### [wtk6lmhln.json] 107
GEGENSTAND: P-04 [TEILWEISE] Platte 2,9G->24G frei; 4 Bauverzeichnisse nach Belegpruefung entfernt
ORT: unbekannt
SOLL/FIX: Ob die Belegpruefung (git ls-files=0 UND csv/xlsx=0) VOR der Loeschung protokolliert wurde, ist nicht verifizierbar (Verzeichnisse weg; Protokoll nicht gesucht/gefunden).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): df -h /: 29G frei (88% belegt) -- konsistent mit 24G-Meldung.

### [wtk6lmhln.json] 108
GEGENSTAND: P-06 [TEILWEISE] Loeschregel: vor worktree remove log --all je Submodul gegen Remote
ORT: unbekannt
SOLL/FIX: KEIN erzwingendes Skript gefunden (grep in scripts/ci ohne Treffer fuer eine solche Wache) -- Disziplin-Regel, kein Werkzeug (KON9-11-Klasse: gilt als nicht abgenommen).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Memory-Eintrag existiert (Index: feedback_worktree_loeschung_erst_alle_submodul_branches_pruefen).

### [wtk6lmhln.json] 109
GEGENSTAND: D-02 [TEILWEISE] ARBEITSWEISE v3.5 eingearbeitet (Umbrella 6ac0ac9) + Vault-Handout (Cluster 1d7b5d0)
ORT: unbekannt
SOLL/FIX: Cluster-Commit 1d7b5d0 (Vault-Handout) nicht geprueft (Cluster-Repo nicht geoeffnet); die 15 Absaetze nicht einzeln gezaehlt (nur 8 explizite '(v3.5'-Marker -- Rest anders markiert).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Datei 67034 B, mtime 13.08. 07:44; Kopfzeile: 'v3.5 (v3.4 + fuenfzehn Regeln aus den Lehren 10.-12.08.)'; KON38 als A1-MATRIX-ZEILE :61 ('STEMPEL-THEMA -- ALLE Phasen ... Fable 5, max effort'); git show 6ac0ac9: 'docs(arbeitsweise): v3.5 -- fuenfzehn Regeln... (Owner-GO 12.08.)', 108+/3-. Datei inzwischen v3.9.

### [wtk6lmhln.json] 110
GEGENSTAND: Z-01 [TEILWEISE] Planer-Binary existiert (CMakeLists:13); apps = 10 Binaries
ORT: main.cpp | experiment_plan_director.hpp | 671d7f6a
SOLL/FIX: apps-Nenner: grep add_executable apps/*/CMakeLists.txt = 9 (je 1) -- auch am 671d7f6a-Stand 9 Verzeichnisse. Die '10' ist am Objekt nicht reproduzierbar.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): apps/experiment_planner/CMakeLists.txt Z.13: add_executable(comdare_experiment_planner main.cpp); libs/.../planner/ traegt 10 Header inkl. experiment_plan_director.hpp.

### [wtk6lmhln.json] 111
GEGENSTAND: P-08 [TEILWEISE] Fehl-Variablen (len=7) erkannt und geloescht (HTTP 204) vor Konsum
ORT: unbekannt
SOLL/FIX: Die HTTP-204-Loeschungen selbst (Werkzeug-Log) nicht nachgewiesen; Zustand ist konsistent mit der Erzaehlung, beweist die Reihenfolge nicht.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Heutige 289-Variablenliste zeigt nur 3 saubere Keys (TEXLIVE + die 2 Writeback) -- keine Rueckstaende der Fehlsetzung.

### [wtk6lmhln.json] 112
GEGENSTAND: W-03 [TEILWEISE] #27 Explore fertig, Vorlagen gebuendelt, Rohdaten im Backup
ORT: unbekannt
SOLL/FIX: Die drei Ein-Satz-Vorlagen nicht wortwoertlich im Plan-/Vorlage-Dokument aufgesucht.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Task #27 'completed -- E-WARMUP GELANDET (KON45, WF10 geheilt)'; WF10-Archiv (drei Explores) im Backup nachgewiesen.

### [wtk6lmhln.json] 113
GEGENSTAND: Z-06 [NICHT_ERLEDIGT] admit_organ_on_machine NUR aus Tests gerufen -- KEIN Produktionspfad
ORT: build_orchestrator.hpp:761 | 6d65b0e6
SOLL/FIX: Die Kernaussage war schon am 12.08. falsch (Aufrufer existierte seit 19.07.; inert nur weil required-Mengen leer). Ledger-Korrektur noetig: 'Produktionspfad vorhanden, aber inert' statt 'kein Produktionspfad'. Die A2.2-Falle (Konsument statt Gegenstand) in der Original-Messung.
STATUS LT. QUELLE: offen (Behauptung faellt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): grep -rn admit_organ_on_machine libs/apps: build_orchestrator.hpp:761 'if (auto const gate_err = ...admit_organ_on_machine(' -- PRODUKTIONS-Aufruf; git log -S: seit 6d65b0e6 (19.07., 'provision_core-Zulassungs-Naht ... 3 Inertness-Beweise').

### [wtk6lmhln.json] 114
GEGENSTAND: Z-14 [TEILWEISE] Nebenbefund: Tier-Treiber g++-16/16.0.1 gegen CEB gcc 15.3.0, 'unschaedlich'
ORT: unbekannt
SOLL/FIX: Je-Ziel-Verdrahtung (CMake-Cache) nicht gemessen; 'unschaedlich' bleibt Bewertung -- KON55 (Compiler wird System-Achse) hat als Konsequenz die 2x2-Pflicht gebracht.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): g++ --version = 15.3.0; g++-16 --version = 16.0.1 (beide lokal vorhanden).

### [wtk6lmhln.json] 115
GEGENSTAND: F-02 [TEILWEISE] System B = 17 Dateien (6 mess/ + 3 measure_storage/ + 8 Referenzierer)
ORT: unbekannt
SOLL/FIX: measure_storage heute 5 statt 3 -- der 17er-Nenner driftet; OF-1 (17 vs 18) verlangt ohnehin Neuzaehlung am Objekt (Plan-Tabelle: 'Zaehlung liegt bei, Mi 19.08.'). Die 8 Referenzierer nicht einzeln reproduziert.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): ls mess/*.hpp = 6 (exakt); ls builder/measure_storage/*.hpp = 5 (heute).

### [wtk6lmhln.json] 116
GEGENSTAND: F-04 [TEILWEISE] Widerlegt: KON28-03-Beobachtung, KON34-03-Klammer, OF-2 Teil C (Marker gesetzt)
ORT: unbekannt
SOLL/FIX: Die Ledger-ALTSTELLEN selbst tragen keinen Rueckverweis: KON28-03 (:3040ff 'Beobachtung ... klaert E-F3b (laeuft)') und die KON34-Klammer (:72 im KON34-Block) stehen unmarkiert -- Doku-Deprecation unvollstaendig.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Plan-Dokument Teil C Z.243: '~~KON34-06(a)...~~ KORRIGIERT 12.08. (KON41-03, Owner: VOELLIG FALSCH) ... OF-2-neu' -- durchgestrichen+Marker [OK]; KON41-Index (:1857) fuehrt die Widerlegung.

### [wtk6lmhln.json] 117
GEGENSTAND: D-05 [TEILWEISE] Task-Stand #9/#26/#25 erledigt, #11 in_progress, neu #27/#28; MEMORY auf KON36+
ORT: 5a19728e
SOLL/FIX: MEMORY-Kopf ist gegen KON57 stale (V-11-Klasse, wie von der Erhebung vermutet) -- Fortschreibung offen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Task-Store session-5a19728e: #9 completed, #26 completed, #25 completed, #11 completed (inzwischen), #27 completed, #28 pending; MEMORY-Index traegt 'Ledger-Kopf = KON36' + Stempel-Fable-max-Zeile.

### [wtk6lmhln.json] 118
GEGENSTAND: D-06 [TEILWEISE] KON38-Memory angelegt, Index-Zeile, kuenftige Workflow-Skripte fable/max je agent()
ORT: unbekannt
SOLL/FIX: Der Werkzeug-Teil ungeprueft: agent()-Aufrufe der WF11/WF12-Skripte nicht auf model:'fable',effort:'max' inspiziert -- hier trennt sich Doktrin von Werkzeug.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Memory-Datei existiert (2465 B, 12.08. 11:12); MEMORY-Index-Zeile vorhanden ('STEMPEL-STRECKE = FABLE 5 MAX...').

### [wtk6lmhln.json] 119
GEGENSTAND: F-07 [TEILWEISE] T-15b P.13/14 geschlossen; #13 baut mit Klammer Build UND Messung je 5
ORT: unbekannt
SOLL/FIX: Der sichtbare #13-Text traegt nur die MESS-Klammer; die Build-Klammer-Haelfte dort nicht nachgewiesen (evtl. im abgeschnittenen Rest).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Wellenplan par.17.1-Tabelle: 'T-15b-Details P.13/14: je 5 fuer Build UND Messung; 3 Erfolgs-Werte einzeln (KF-10) | KON37-06'; Task #13 pending, Text: 'Retry-Klammer um measure_one_binary ... bis zu 5 Versuche'.

### [wtk6lmhln.json] 120
GEGENSTAND: F-09 [TEILWEISE] KON37-09: F-A..F-H alle geschlossen
ORT: unbekannt
SOLL/FIX: F-D hielt nicht: KON40-Titel ':1303 ... F-D TRAEGT EINE SPANNUNG' -- aus 'geschlossen' wurde eine neue offene Frage (OF-5-Klasse); Rohtranskript-Zitatabgleich (Kuerzungen) nicht durchgefuehrt.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): par.17.1: 'Die WF7-Fragen F-A...F-H sind per KON37 alle acht beantwortet' + ZU-Tabelle mit 7 Zeilen-Belegen.

### [wtk6lmhln.json] 121
GEGENSTAND: W-11 [TEILWEISE] 56 Fakten als ERGAeNZT-Bloecke je Kapitel, Bestand unangetastet
ORT: unbekannt
SOLL/FIX: Grobe Bullet-Zaehlung liefert ~52-58 je nach Zerlegung (Inline-Fakten, Unterpunkte) -- die exakte 56 nicht reproduziert; 'bestehender Text unangetastet' nicht git-gedifft.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): 11 'ERGAeNZT 12.08. (KON36/WF7)'-Bloecke im Ledger (Zeilen 1917,1987,2085,2174,2222,2248,2278,2309,2341,2380,2443) = 11 Kapitel wie behauptet (B..M).

### [wtk6lmhln.json] 122
GEGENSTAND: Z-19 [TEILWEISE] <combo> in 7 Profilen geparst; Director konsumiert measurement_tooling NICHT ([all]=>1 Voll-Konfig)
ORT: experiment_plan_director.hpp:2097-2101
SOLL/FIX: Der Nicht-Konsum-Teil ist am heutigen Objekt ueberholt (Luecke wurde gebaut); Ledger-Fortschreibung noetig, sonst plant jemand einen bereits gebauten Posten.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): combo-XMLs heute: 8 (ce) + f1_durchstich (super); experiment_plan_director.hpp:2097-2101/:2146 heute: 'Fan-out-Verdrahtung ist aktiv -- measurement_combos_of(cats, tp.measurement_tooling) faechert je...' -- der Director KONSUMIERT measurement_tooling inzwischen.

### [wtk6lmhln.json] 123
GEGENSTAND: Z-22 [TEILWEISE] E-F9: Gen-2 scharf; window_belongs_to NICHT verdrahtet; Messung nicht zweilanig (resource_group, prod1-Pin)
ORT: batch_planner.hpp | .gitlab-ci.yml:1813
SOLL/FIX: 23 Gen-2-Header nicht gezaehlt; Takeover-Sweep-Produktivitaet nicht geprueft. Beide Kern-Luecken sind heute UNVERAENDERT offen (Bau-Posten).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): window_belongs_to: einziger Fundort batch_planner.hpp (Definition) -- 0 Aufrufer, unverdrahtet BESTAETIGT; super .gitlab-ci.yml:1813 'resource_group: "ceb-measurement-exclusive" # cluster-weit genau EINE messende CEB' -- nicht zweilanig BESTAETIGT.

### [wtk6lmhln.json] 124
GEGENSTAND: Z-27 [TEILWEISE] SIMD-Meta-Meta gebaut (17 static_asserts); axis_kind()==system_config; Hub NULL Konsumenten
ORT: external_utils_family_axis.hpp | system_cell_values.hpp | anatomy_version_stamp.hpp
SOLL/FIX: 'NULL Konsumenten' ueberholt: ExternalUtilsHub wird heute von 3 abi-Headern gefuehrt (system_cell_values.hpp, anatomy_version_stamp.hpp, meta_meta_stamp_suffix.hpp); static_assert-Zahl 23 statt 17; die drei -mavx-Stellen nicht aufgeschlagen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): external_utils_family_axis.hpp: SimdExternalUtilsFamily erbt SystemMetaMetaAxis; grep -c static_assert = 23 (heute); :119 'static_assert(SimdExternalUtilsFamily::axis_kind() == topics::AxisKind::system_config)' -- system_config BESTAETIGT (sogar gepinnt).

### [wtk6lmhln.json] 125
GEGENSTAND: W-17 [TEILWEISE] KON24-03: Wellenplan par.16 auf KON16-23 gezogen, S-19/S-20/S-21 neu; Gesamturteil; MEMORY-Kopf
ORT: unbekannt
SOLL/FIX: Owner-Vorlage-UEBERHOLT-Kopf und Gesamturteil-Datei nicht einzeln aufgeschlagen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Wellenplan :1967-1969: Tabellenzeilen S-19 (PLANUNGS-SIMULATION), S-20 (SYNC-KANAL CEB<->Hybrid), S-21 (Kategorien-Ordnungs-Wache) + :1939 'FORTSCHREIBUNG 12.08. abends: par.16 gilt bis KON23 -- Vorrang par.17'; MEMORY-Kopf gezogen (heute KON36+).

### [wtk6lmhln.json] 126
GEGENSTAND: F-14 [TEILWEISE] S-6 vollstaendig entsperrt, Bauauftrag geschnitten (S-6a..d + Verbotszonen)
ORT: stempel_basis.hpp
SOLL/FIX: Der GELTENDE Stand re-sperrt den BAU: stempel_basis.hpp-Kopf 'S-1 schreibt KEINE Zeilen-/Glied-REIHENFOLGE fest (S-6-Sperre: ... Explore offen)' + Memory 'GLIEDER-REIHENFOLGE: ZWEI WELTEN -- bis dahin wird an S-6 NICHTS gebaut'. 'Vollstaendig entsperrt' gilt heute nur fuer die ENTSCHEIDUNGs-Sperre, nicht als Bau-Freigabe.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Wellenplan :1958: 'ENTSPERRT und geschnitten (KON20/KON21-03): S-6a ... S-6b ... S-6c ... S-6d ... Verbotszonen: Lager-Kaskaden, Unterachsen-Quellen, Hash-Mechanik'.

### [wtk6lmhln.json] 127
GEGENSTAND: Z-39 [TEILWEISE] Vier->ZWEI-von-fuenf-Korrektur in drei Dokumenten inkl. MEMORY
ORT: memory/reference_stempel_traegt_fuenf_rollen...md:25-27
SOLL/FIX: Nur 1 der 3 Dokumente geprueft; die zwei anderen Traeger der falschen Vier nicht aufgesucht.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): memory/reference_stempel_traegt_fuenf_rollen...md:25-27: 'KORREKTUR 11.08. SPAET -- ZWEI VON FUENF SIND DURCHGESETZT, NICHT VIER ... Am Objekt sind es ZWEI von fuenf'.

### [wtk6lmhln.json] 128
GEGENSTAND: Z-40 [TEILWEISE] KON13-07-Bestaetigungen: hybrid/ 4 Header 943 Z.; algo_semver 1535 Z.; 371 axes; LagerBaumWriter 0 Prod
ORT: algo_semver.hpp | 58579575 | 99de5b30
SOLL/FIX: axes-Nenner ungeklaert: meine Zaehlung (find libs -path '*axes/*' -name '*.hpp') = 345, Ledger sagt 371, der 13.08.-Wachenbefund 387 -- DREI Zahlen, drei Scopes; der richtige Gegenstand ist unbestimmt und muss mit ausgeschriebenem Kommando festgelegt werden. LagerBaumWriter-Aufrufer nicht neu gezaehlt.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): hybrid/: 4 Header, 955 Zeilen (=943+12, Q6-Nachzug 58579575 vom 13.08. -- erklaerbarer Drift); algo_semver.hpp 1546 (=1535+11 via 99de5b30 -- erklaerbar).

### [wtk6lmhln.json] 129
GEGENSTAND: Z-42 [NICHT_ERLEDIGT] S-14: 7 von 130 (371 Header, Marker 7, lock 9, Differenz unaufgeklaert)
ORT: unbekannt
SOLL/FIX: Die 7/371/9 sind am Objekt nicht reproduzierbar; die spaetere KON14-01-Korrektur ('6 gegen 6, kein Rest') passt exakt zum heutigen Objekt (6 Marker-Dateien = 6 Lock-Eintraege, beide heuristik/). Ledger-Stand KON12-02 ist ueberholt und sollte deprecatet werden.
STATUS LT. QUELLE: offen (Behauptung faellt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Nachgefahren: axes-Header mit algo_version = 130 (exakt); ABER Marker: grep AXIS_ALGO/ALGO_VERSION trifft heute 0 axes-Dateien (nur 6 heuristik/-Dateien); lock = 6 DATEI-Eintraege (die '9' war wc -l INKLUSIVE 3 Kommentar-+1 Leerzeile -- Zaehlfehler); axes gesamt mit meinem Kommando 345, nicht 371.

### [wtk6lmhln.json] 130
GEGENSTAND: Z-44 [TEILWEISE] Inventur des Unverdrahteten: elf Positionen, neun gebaut+unverdrahtet
ORT: unbekannt
SOLL/FIX: '9 von 11' ist nachweislich zu hoch; vollstaendige Neuzaehlung der elf Zeilen steht aus -- Nachimplementierung: Inventur-Liste am Objekt neu erheben, bevor jemand daraus Bau-Posten schneidet.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Mindestens DREI der elf sind heute (bzw. schon damals) verdrahtet: ExperimentPlanDirector (facade:1034, Z-41), measurement_tooling-Fanout aktiv (director:2097-2101, Z-19), admit_organ_on_machine produktiv (orchestrator:761 seit 19.07., Z-06).

### [wtk6lmhln.json] 131
GEGENSTAND: Z-45 [NICHT_ERLEDIGT] KON11-04: die widerspruechliche 153 zurueckziehen und neu erheben
ORT: memory/reference_versionierung_soll_je_stufe...md:85
SOLL/FIX: Rueckzug/Neuerhebung mit ausgeschriebener Zaehlweise ist NICHT vollzogen -- Memory-Datei korrigieren (Vorkommen vs. Literal-Zeilen trennen).
STATUS LT. QUELLE: offen (Behauptung faellt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): memory/reference_versionierung_soll_je_stufe...md:85 traegt UNVERAENDERT '153 static constexpr algo_version in'. Eigene Neuerhebung: grep -r 'static constexpr' libs --include='*.hpp' | grep -c algo_version = 153 (Vorkommen), Literal-Split: 99x "1.0.0.c" + 2x "1.0.1.c" + 24x "1.0.2.c" = 125 -- die Aufschluesselung deckt die Summe weiter nicht (28 Zeilen ohne die drei Literale; Datei sagt zudem 96 statt 99).

### [wtk6lmhln.json] 132
GEGENSTAND: Z-48 [NICHT_ERLEDIGT] KON9-11: 'vier der fuenf Rollen durchgesetzt' (Beleg lager_baum_writer:50-53)
ORT: unbekannt
SOLL/FIX: Die Vier-Behauptung war falsch (Klasse 'Kommentar als Beweis'); gilt nur noch als dokumentierte Fehlmessung.
STATUS LT. QUELLE: offen (Behauptung faellt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Der Beleg ist ein KOMMENTAR (:50-53 Preimage-Konvergenz-Text), kein Riegel; die Zahl ist durch KON13-06/C-3 und das korrigierte Memory ('ZWEI VON FUENF SIND DURCHGESETZT') widerlegt.

### [wtk6lmhln.json] 133
GEGENSTAND: L-20 [TEILWEISE] 15730/15731/15732 success -- alle 17 KON-Nachtraege pipeline-gruen
ORT: eb274f1b | de4ddf6d | 0d6bd74b
SOLL/FIX: Nur Gesamtstatus je Pipeline erhoben (Joblisten nicht gezogen); die Abbildung Commit->17 Nachtraege existiert weiterhin nicht -- '3 gruene SHAs decken 17 Nachtraege' bleibt unbewiesen (der von der Erhebung benannte Stellvertreter).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): API: 15730 success @eb274f1b, 15731 success @de4ddf6d, 15732 success @0d6bd74b.

### [wtk6lmhln.json] 134
GEGENSTAND: P-11 [TEILWEISE] KON22-01: 7 Variablen rotiert (#70); 776 Runner-Token/MinIO/test:secrets UNGEPRUEFT
ORT: unbekannt
SOLL/FIX: Task #70 in aelterer Session (nicht lesbar); Rotations-ZEITPUNKT nicht belegbar; die drei als UNGEPRUEFT deklarierten Posten sind weiterhin ungeprueft -- die ehrliche Grenze besteht fort und darf nicht als 'erledigt' weitergegeben werden.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): 288-Variablenliste zeigt die Writeback-/MinIO-Variablen existent (Keys+Attribute); secrets-Jobs tags:[baremetal] beidseitig.

### [wtk6lmhln.json] 135
GEGENSTAND: Z-50 [TEILWEISE] KON6-03-IST-Luecken (Planer-SHA leer, CEB-System leer, Genus handgeschrieben, keine Basis) -- nach S-1 geheilt?
ORT: planner_version.hpp:74 | ceb_version_stamp.hpp:623 | planner_version.hpp:80-83 | cba285b4
SOLL/FIX: NACHIMPLEMENTIERUNGS-KERN: (1) Planer-fingerprint_sha() weiterhin LEER -- jetzt laut (planner_version.hpp:80-83 kFingerprintShaBewusstLeer=true), Fuellung offen; (2) CEB-system_zeile() weiterhin LEER -- laut (ceb_version_stamp.hpp:630-632), Fuellung offen; (3) Genus-Versionen weiterhin 5 Hand-Literale ('1.0.0.c' x5, pruef_dock_version.hpp:60-66); (4) NUR 2 von 4 Traegern erben (TierStempel/HybridStempel existieren nicht -- grep StempelTraeger::Tier|Hybrid ausserhalb Basis/Trait = 0); Matrix definiert 4 Traeger. 'Eine gemeinsame Basisklasse fuer ALLE FUENF' gibt es nicht -- per dokumentierter Design-Entscheidung Trait statt Basis.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): S-1 EXISTIERT: CRTP-Basis StempelBasis + deferred-consteval StempelVertrag; Erbinnen: PlanerStempel (planner_version.hpp:74, Vertrag :94) und CebStempel (ceb_version_stamp.hpp:623, :650); die fuenf KON6-03-Strukturen haengen per ist_stempel_baustein-Trait (10 Spezialisierungen) an -- bewusst OHNE Basisklasse (Trait-Kopf: 'eine leere Basis fraesse den ERSTEN positionellen Initialisierer'); Genus-Literale als VersionsLiteral-Bausteine angebunden (cba285b4, Nenner 5).

### [wtk6lmhln.json] 136
GEGENSTAND: Z-51 [TEILWEISE] #85 entlastet (15675 builds gruen); #80 aufgeklaert (374052 exit status 4, 4 ISA + 1 Pruefling)
ORT: unbekannt
SOLL/FIX: Die exakte 4+1-Zerlegung (4 ISA-gegatete namentlich) nicht aus dem Trace isoliert.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): 15675: 24 Jobs, 1 rot = test:coverage-guard, build:clang+test:unit in den 22 success; Trace 374052 (4805 Z.): 'exit status 4' literal + Pruefling-Fixture-Befund literal ('COMDARE_PRT_ART_DIR ist LEER ... Der Planer sieht die Pruefling-Achsen nicht').

### [wtk6lmhln.json] 137
GEGENSTAND: Z-53 [TEILWEISE] 19 jsonl/503MB ab 06.08.; docs 19 Unterordner; Journale ab 10.07.
ORT: unbekannt
SOLL/FIX: 503MB/aeltestes Datum nicht neu bestimmt; Journal-Startdatum nicht geprueft. Die Deckungsgrenze (Transkripte erst ab 06.08.) bleibt fuer jede 10-Wochen-Aussage bindend.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): ls -d docs/*/ | wc -l = 19 (exakt); jsonl heute 26 (gewachsen, 13.08. laeuft).

### [wtk6lmhln.json] 138
GEGENSTAND: L-22 [TEILWEISE] 4 Landungen 11.08.: 15674 33/33 * 15675 23/24 * Zwischenstandsdoku * 75505b9d 'Pipeline offen'
ORT: 75505b9d
SOLL/FIX: DIE VIERTE LANDUNG WURDE NIE GRUEN: einzige Pipeline auf 75505b9d = 15678 status=failed (eigene 33 Jobs alle success, aber Bridge trigger:cache-engine -> Kind-Pipeline 15679 failed = der bekannte coverage-guard-Rot). Die 'offen'-Deklaration endete ROT und wurde im Ledger nie geschlossen; Deckung kam erst von Folge-Commits (15730-15764 success). Ledger-Nachtrag noetig.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): API 15674 (super): 33 Jobs, success=33 (exakt); 15675 (ce): 24 Jobs, failed=1 test:coverage-guard, success=22+1 manual (exakt wie deklariert).

### [wtk6lmhln.json] 139
GEGENSTAND: Z-56 [TEILWEISE] S-14: 7 von 130 markiert; Wache CI-verdrahtet (:768-786); lock 9 Eintraege
ORT: unbekannt
SOLL/FIX: Marker-Zaehlung falsch: HEUTE 0 axes-Header mit dem Wachen-Marker (Marker nur in 6 heuristik/-Dateien); lock = 6 Datei-Eintraege (9 = wc -l inkl. Kommentare/Leerzeile). Der AUSROLL-Auftrag auf die 130 axes-Traeger ist unveraendert offen -- mit korrigiertem Nenner 0/130 statt 7/130.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Job 'contract:axis-version-lock' existiert im ce-CI (:762ff, 'HARTES Gate', 2-Pass Anti-Phantom); 130 algo_version-Traeger exakt bestaetigt.

### [wtk6lmhln.json] 140
GEGENSTAND: Z-58 [TEILWEISE] 8 von 9 thesis_profiles xlsx-blind (Altstand, neu auszuzaehlen)
ORT: unbekannt
SOLL/FIX: 3 Profile bleiben xlsx-blind; welche 3, ist aus der Trefferliste ableitbar (11 minus die 8 genannten) -- Rest-Posten fuer Kampagnen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Neuzaehlung (beauftragt und hiermit geliefert): ce thesis_profiles = 11 XML, davon 8 MIT xlsx (grep -l xlsx), 3 ohne -- der Blocker ist weitgehend geheilt (Invertierung des Altstands).

### [wtk6lmhln.json] 141
GEGENSTAND: Z-59 [TEILWEISE] coverage-guard-Rot ist stempelfrei (ISA/Host); Fix-Reihenfolge F1 vor F2 bindend
ORT: 3353171e | c6a3e991 | a99c4a18
SOLL/FIX: 'stempelfrei' nicht wortwoertlich am roten Alt-Trace isoliert (Pruefling/ISA-Kontext im 374052-Trace stuetzt es).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Strang-D-Serie hielt die Reihenfolge: 3353171e 'F1a/F1b/F1c dritte Achse klassenbewusst' VOR c6a3e991 'when:always am Job + F1-Leitungen (P3a/P6/P7)'; Task #14 completed ('ce-Pipeline GRUEN 15751 ... coverage-guard'); 15751 success @a99c4a18 per API.

### [wtk6lmhln.json] 142
GEGENSTAND: Z-60 [TEILWEISE] Zwei divergente Hygiene-Wachen (ce 779 / super 558), super ohne --bereich, --stdin ohne Abbruch
ORT: scripts/ci_diff_ascii_width_guard.sh
SOLL/FIX: Ledger-Zahlen (779/558) und die Kritik 'super ohne --bereich' sind ueberholt -- super traegt --bereich inzwischen; die strukturelle ZWEIHEIT (zwei Implementierungen, gemeinsame Klasse) besteht fort und bleibt Konsolidierungs-Posten vor dem main-FF.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Beide Fassungen existieren weiter: super scripts/ci_diff_ascii_width_guard.sh = 662 Z., ce = 936 Z.; Flag-Sets heute: super --bereich/--bestand/--seit-basis/--stdin (Z.222-236), ce --bereich/--seit-basis/--bestand/--stdin.

### [wtk6lmhln.json] 143
GEGENSTAND: Z-62 [TEILWEISE] Neue Offen-Punkte: Wallclock-SOLL-Konflikt + E-Label-Doppelbedeutung -> Owner-Fragen
ORT: unbekannt
SOLL/FIX: MEMORY-Index fuehrt beide noch als 'NEU offen -> Owner-Fragen' (stale, V-11-Klasse) -- Memory nachziehen; ob der KON37-01-Merge den F2-Gesetz-WORTLAUT deckt oder ueberstimmt, wurde nicht am Dossier geprueft.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Beide wurden am 12.08. BEANTWORTET: Ledger :1525 'Wallclock-SOLL-Konflikt (KON36-01) ist damit aufgeloest: Merge, kein Widerruf' (KON37-01) + par.17.1 'E-Label-Doppeldeutung: Umbenennung genehmigt ... (KON37-05)'.

### [wtk6lmhln.json] 144
GEGENSTAND: W-22 [TEILWEISE] KON7: Stempel-Architektur Satz fuer Satz vom Owner abgenommen
ORT: unbekannt
SOLL/FIX: Der eigentliche Pruefauftrag -- jede KON7-Aussage gegen das Rohtranskript 11.08. spaetabends, Sammel- vs. Einzel-Zustimmung -- wurde nicht durchgefuehrt (Transkript-Arbeit ausserhalb des Zeitbudgets; KON14-03-Zitatrisiko unbeurteilt).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): KON7 existiert im Ledger (Nachtrags-Liste); die S-1-Umsetzung referenziert KON7-04/-07/-08 konsistent im Code (Matrix-Asserts zitieren die Owner-Saetze).

### [wtk6lmhln.json] 145
GEGENSTAND: Z-13 [TEILWEISE] WF9 Verbots-Checks alle gruen (Preimage leer, Golden/TABU, Ledger, kein Push, Gitlink, Messdaten)
ORT: a1ee9780 | e22f1300
SOLL/FIX: Die sechs Zonen wurden nicht einzeln gegen den WF9-Diff geprueft; eine Preimage-/Golden-/TABU-DATEILISTE als Nenner wurde nicht gefunden -- ohne benannten Nenner ist 'alle gruen' nicht nachvollziehbar (V0-Klasse).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Indirekt: der WF9-Ertrag ist konfliktfrei gelandet (a1ee9780/e22f1300, Gitlink in e22f1300 nachweislich unveraendert, CI gruen).

### [wtk6lmhln.json] 146
GEGENSTAND: L-15 [TEILWEISE] HONEST-EMPTY der Ratio-Heatmap = designte 1x1-Semantik, kein Befund
ORT: unbekannt
SOLL/FIX: Die Code-Stelle, die 1x1 als honest-empty DOKUMENTIERT (Soll-Semantik vs. Nachhinein-Auslegung), wurde nicht aufgesucht.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): 15764-Trace zeigt sota_rows=0/sota_series=0 als deklarierten Profilzustand (f1_durchstich ohne SOTA-Serie).

### [wtk6lmhln.json] 147
GEGENSTAND: V[1]-nicht_pruefbar[0]: B-07 (T-1-Mutationsprotokoll): Die vier Wegwerf-Mutationen erfordern Compile-Laeufe gegen den heutigen Baum; im Verify-Rahmen wurde nicht gebaut
ORT: 6f537245
SOLL/FIX: B-07 (T-1-Mutationsprotokoll): Die vier Wegwerf-Mutationen erfordern Compile-Laeufe gegen den heutigen Baum; im Verify-Rahmen wurde nicht gebaut. Die genannten Assert-Zeilen (:150/:175/:188/:246/:507) sind zudem seit 6f537245 gedriftet -- Nachfahren nur sinnvoll mit Symbol-Ankern im tmp-Klon.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 148
GEGENSTAND: V[1]-nicht_pruefbar[1]: L-08 (cf22-Format kompilat-neutral je Datei): Der g++ -fpreprocessed-Hash-Vergleich HEAD==Arbeitskopie wurde nicht nachgefahren (Bau-/Toolchain-Lauf; cf22-Pfad /home/comdare/tools/
ORT: vor_push_alle_wachen.sh:137
SOLL/FIX: L-08 (cf22-Format kompilat-neutral je Datei): Der g++ -fpreprocessed-Hash-Vergleich HEAD==Arbeitskopie wurde nicht nachgefahren (Bau-/Toolchain-Lauf; cf22-Pfad /home/comdare/tools/cf22 existiert laut vor_push_alle_wachen.sh:137). Nenner-Frage (alle 10 oder Stichprobe) bleibt offen.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 149
GEGENSTAND: V[1]-nicht_pruefbar[2]: P-02 (Bergungs-Bilanz fsck, 'KEIN dangling von heute'): fsck ueber drei Objektspeicher heute neu zu fahren aendert die zeitrelative Aussage ('von heute' = 12.08.) und ist auf dem 2
ORT: unbekannt
SOLL/FIX: P-02 (Bergungs-Bilanz fsck, 'KEIN dangling von heute'): fsck ueber drei Objektspeicher heute neu zu fahren aendert die zeitrelative Aussage ('von heute' = 12.08.) und ist auf dem 210G-Store lastintensiv; nicht gefahren. Der Befund ist als Momentaufnahme des 12.08. formuliert und nur aus damaligen Logs pruefbar, die nicht aufgesucht wurden.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 150
GEGENSTAND: V[1]-nicht_pruefbar[3]: P-05 (Branch-Pflicht in Workflow-Skripten nach KON49): Die WF12-Skripte (wf_cd576b6e) wurden nicht geoeffnet; ob die Branch-Pflicht im WERKZEUG oder nur im Ledger steht, ist offen
ORT: bau/s1-codex-haertung
SOLL/FIX: P-05 (Branch-Pflicht in Workflow-Skripten nach KON49): Die WF12-Skripte (wf_cd576b6e) wurden nicht geoeffnet; ob die Branch-Pflicht im WERKZEUG oder nur im Ledger steht, ist offen. Hinweis: die Strang-Commits tragen benannte Branches (bau/s1-codex-haertung) -- Indiz, kein Skript-Beweis.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 151
GEGENSTAND: V[1]-nicht_pruefbar[4]: F-03 (17 vs 18 Referenzierer measurement_tooling_registry): Beide Zaehlungen waeren nur mit dem IDENTISCHEN Original-Kommando beweiskraeftig; das Kommando ist im Ledger nicht ausge
ORT: unbekannt
SOLL/FIX: F-03 (17 vs 18 Referenzierer measurement_tooling_registry): Beide Zaehlungen waeren nur mit dem IDENTISCHEN Original-Kommando beweiskraeftig; das Kommando ist im Ledger nicht ausgeschrieben -- Reproduktion waere eine dritte Zaehlweise. Nicht durchgefuehrt; kollidiert zusaetzlich mit Z-24 (18 vs 3).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 152
GEGENSTAND: V[1]-nicht_pruefbar[5]: D-04 (21 A.5-Marker: 8 GOAL, 7 Wellenplan, 6 Designplan; Diff genau 1 Minus-Zeile): Nicht vollstaendig gezaehlt; im Wellenplan wurden 5 'MARKER 12.08
ORT: unbekannt
SOLL/FIX: D-04 (21 A.5-Marker: 8 GOAL, 7 Wellenplan, 6 Designplan; Diff genau 1 Minus-Zeile): Nicht vollstaendig gezaehlt; im Wellenplan wurden 5 'MARKER 12.08. (KON39)'-Treffer gesehen (Stichprobe positiv), GOAL/Designplan nicht gezaehlt, der Marker-Commit nicht gedifft.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 153
GEGENSTAND: V[1]-nicht_pruefbar[6]: W-05 (KON37-09-Abgleich 'Ledger Z.19-250 am Objekt'): Der Anker ist ein Zeilenanker auf die lebende Datei (heute anderes Z.19-250); der Abgleich-VORGANG hinterlaesst kein pruefbare
ORT: unbekannt
SOLL/FIX: W-05 (KON37-09-Abgleich 'Ledger Z.19-250 am Objekt'): Der Anker ist ein Zeilenanker auf die lebende Datei (heute anderes Z.19-250); der Abgleich-VORGANG hinterlaesst kein pruefbares Artefakt, das gefunden wurde.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 154
GEGENSTAND: V[1]-nicht_pruefbar[7]: W-06 (22 Review-Fixes eingearbeitet): Die zwei Review-Berichte liegen in den WF8-Rohdaten (lauf-wf_4ec570cc-...tar.gz, vorhanden); die Fix-fuer-Fix-Einarbeitungspruefung im 36.750-
ORT: unbekannt
SOLL/FIX: W-06 (22 Review-Fixes eingearbeitet): Die zwei Review-Berichte liegen in den WF8-Rohdaten (lauf-wf_4ec570cc-...tar.gz, vorhanden); die Fix-fuer-Fix-Einarbeitungspruefung im 36.750-Byte-Plan-Dokument wurde aus Zeitgruenden nicht durchgefuehrt.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 155
GEGENSTAND: V[1]-nicht_pruefbar[8]: W-07 (6 Ledger-Zeilenanker der Lead-Stichprobe): Die sechs KON-Stellen sind ueber Kennung auffindbar, aber der WORTLAUT-Vergleich gegen die damals zitierten Fassungen wurde nicht d
ORT: unbekannt
SOLL/FIX: W-07 (6 Ledger-Zeilenanker der Lead-Stichprobe): Die sechs KON-Stellen sind ueber Kennung auffindbar, aber der WORTLAUT-Vergleich gegen die damals zitierten Fassungen wurde nicht durchgefuehrt; die Anker selbst sind um tausende Zeilen gedriftet (die Erhebung benennt das Problem korrekt).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 156
GEGENSTAND: V[1]-nicht_pruefbar[9]: W-08 (WF7-Schnitt 2, sechs Plan-Quellen literal): Nicht aufgeschlagen; haengt an W-10-Zitatanker-Korrekturen, die ebenfalls ungeprueft blieben.
ORT: unbekannt
SOLL/FIX: W-08 (WF7-Schnitt 2, sechs Plan-Quellen literal): Nicht aufgeschlagen; haengt an W-10-Zitatanker-Korrekturen, die ebenfalls ungeprueft blieben.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 157
GEGENSTAND: V[1]-nicht_pruefbar[10]: W-09 (KON34-01 steuer_dock.hpp/konfiguration.hpp komplett gelesen): Beide Dateien nicht vollgelesen; die A/B-Split-0-Produktionsaufrufer-Aussage ist ueber Z-17 (Include- und Aufruf
ORT: steuer_dock.hpp/konfiguration.hpp
SOLL/FIX: W-09 (KON34-01 steuer_dock.hpp/konfiguration.hpp komplett gelesen): Beide Dateien nicht vollgelesen; die A/B-Split-0-Produktionsaufrufer-Aussage ist ueber Z-17 (Include- und Aufrufer-Nullen mit Gegenprobe) indirekt gestuetzt, der Volltext-Anspruch ('komplett gelesen, keine Plan-Quelle widerspricht') nicht verifiziert.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 158
GEGENSTAND: V[1]-nicht_pruefbar[11]: W-10 (zwei korrigierte Zitatanker im messachse-DOSSIER :44-50/:93-99 + KON25-03 ersetzt 12-These): DOSSIER nicht aufgeschlagen; KON25-03 existiert im Ledger (KON25-Nachtrag :3297ff
ORT: unbekannt
SOLL/FIX: W-10 (zwei korrigierte Zitatanker im messachse-DOSSIER :44-50/:93-99 + KON25-03 ersetzt 12-These): DOSSIER nicht aufgeschlagen; KON25-03 existiert im Ledger (KON25-Nachtrag :3297ff gesehen), die Ersetzungs-Aussage nicht am Wortlaut geprueft.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 159
GEGENSTAND: V[1]-nicht_pruefbar[12]: W-12 ('genau EINE Fehldarstellung' in Konsolidierung IV): Der KORRIGIERT-Vermerk in Kapitel B wurde nicht aufgesucht; ob ALLE fuenf Berichte gegengehalten wurden (der eigentliche N
ORT: unbekannt
SOLL/FIX: W-12 ('genau EINE Fehldarstellung' in Konsolidierung IV): Der KORRIGIERT-Vermerk in Kapitel B wurde nicht aufgesucht; ob ALLE fuenf Berichte gegengehalten wurden (der eigentliche Nenner von 'genau eine'), ist prinzipiell nur aus den WF7-Rohdaten rekonstruierbar.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 160
GEGENSTAND: V[1]-nicht_pruefbar[13]: W-13 (drei verworfene Berichts-Behauptungen): Die Gegenbelege (KON21-03, KON27-04, KON22-01/5) wurden nicht einzeln aufgeschlagen
ORT: unbekannt
SOLL/FIX: W-13 (drei verworfene Berichts-Behauptungen): Die Gegenbelege (KON21-03, KON27-04, KON22-01/5) wurden nicht einzeln aufgeschlagen. Hinweis: S-6-Entsperrung (KON21-03) ist per F-14 geprueft -- die Verwerfung 'S-6 bleibt gesperrt' war berechtigt, wird aber durch die spaetere Explore-Sperre (Memory ZWEI WELTEN) praktisch relativiert.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 161
GEGENSTAND: V[1]-nicht_pruefbar[14]: W-14 (KON30-01 Verstaendnis-Auftrag erfuellt, WF6-Synthese): Synthese-Datei nicht gelesen; deklarierte Deckungsgrenze (Schnitt 2 fehlte der Synthese) macht eine Zeile-fuer-Zeile-Co
ORT: unbekannt
SOLL/FIX: W-14 (KON30-01 Verstaendnis-Auftrag erfuellt, WF6-Synthese): Synthese-Datei nicht gelesen; deklarierte Deckungsgrenze (Schnitt 2 fehlte der Synthese) macht eine Zeile-fuer-Zeile-Codepruefung noetig, die nicht stattfand.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 162
GEGENSTAND: V[1]-nicht_pruefbar[15]: W-15/Z-20/Z-21/Z-23/Z-24/Z-25 (WF5-Explores E-F5/E-F7/E-F9-Randteile/E-F3b): Code- und Transkript-Gegenproben nicht durchgefuehrt (E-F9-Kernluecken sind unter Z-22 geprueft)
ORT: unbekannt
SOLL/FIX: W-15/Z-20/Z-21/Z-23/Z-24/Z-25 (WF5-Explores E-F5/E-F7/E-F9-Randteile/E-F3b): Code- und Transkript-Gegenproben nicht durchgefuehrt (E-F9-Kernluecken sind unter Z-22 geprueft). Z-24 kollidiert mit F-03 (18 vs 17) -- beide Zaehlungen brauchen EIN ausgeschriebenes Kommando.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 163
GEGENSTAND: V[1]-nicht_pruefbar[16]: W-16 (WF4 19/21, Journal): Journal nicht geoeffnet; welche Aussagen allein an den zwei toten Schnitten haengen, nicht bestimmt.
ORT: unbekannt
SOLL/FIX: W-16 (WF4 19/21, Journal): Journal nicht geoeffnet; welche Aussagen allein an den zwei toten Schnitten haengen, nicht bestimmt.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 164
GEGENSTAND: V[1]-nicht_pruefbar[17]: W-18 (WF1 45/46): Journal/Synthese nicht geoeffnet.
ORT: unbekannt
SOLL/FIX: W-18 (WF1 45/46): Journal/Synthese nicht geoeffnet.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 165
GEGENSTAND: V[1]-nicht_pruefbar[18]: W-19 (KON22: 7 Leser, 180 distinkte Owner-Texte, 23/10/1): Transkript-Korpusarbeit ausserhalb des Budgets; die Drei-Pfade-UNION-Doktrin ist bekannt, ihre Anwendung nicht verifizier
ORT: unbekannt
SOLL/FIX: W-19 (KON22: 7 Leser, 180 distinkte Owner-Texte, 23/10/1): Transkript-Korpusarbeit ausserhalb des Budgets; die Drei-Pfade-UNION-Doktrin ist bekannt, ihre Anwendung nicht verifiziert.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 166
GEGENSTAND: V[1]-nicht_pruefbar[19]: W-20 (KON20: 9 Agenten, jede Kernaussage gegengeprueft): Synthese nicht gelesen; die drei Ordnungen nicht am Code nachgezaehlt.
ORT: unbekannt
SOLL/FIX: W-20 (KON20: 9 Agenten, jede Kernaussage gegengeprueft): Synthese nicht gelesen; die drei Ordnungen nicht am Code nachgezaehlt.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 167
GEGENSTAND: V[1]-nicht_pruefbar[20]: Z-07 (organ_stamp_line<Comp> ohne Comp :196; active_organ_required global/leer :263; Tripwire :272-278): anatomy_version_stamp.hpp/simd_build_gate.hpp an diesen Ankern nicht aufges
ORT: anatomy_version_stamp.hpp/simd_build_gate.hpp
SOLL/FIX: Z-07 (organ_stamp_line<Comp> ohne Comp :196; active_organ_required global/leer :263; Tripwire :272-278): anatomy_version_stamp.hpp/simd_build_gate.hpp an diesen Ankern nicht aufgeschlagen (Zeit); benachbarte Befunde (Z-32 :88-Assert) bestaetigt.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 168
GEGENSTAND: V[1]-nicht_pruefbar[21]: Z-08 (EnabledTargets 1-elementig, has_device_writeback_path unbedingt false): Dateien nicht aufgeschlagen.
ORT: unbekannt
SOLL/FIX: Z-08 (EnabledTargets 1-elementig, has_device_writeback_path unbedingt false): Dateien nicht aufgeschlagen.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 169
GEGENSTAND: V[1]-nicht_pruefbar[22]: Z-09 ('erste Iteration verwerfen' existiert nicht, 0 Treffer + Koeder): Transkript-Suche mit Koeder-Anker nicht wiederholt; Korpusgrenze (ab 06.07./06.08.) bleibt als deklarierte L
ORT: unbekannt
SOLL/FIX: Z-09 ('erste Iteration verwerfen' existiert nicht, 0 Treffer + Koeder): Transkript-Suche mit Koeder-Anker nicht wiederholt; Korpusgrenze (ab 06.07./06.08.) bleibt als deklarierte Luecke bestehen.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 170
GEGENSTAND: V[1]-nicht_pruefbar[23]: Z-16 (W7-Bilanz 23 Posten = 9+14): Die Bilanz-Stelle wurde im Wellenplan nicht gefunden (grep nach '23 Posten|9 Behaelter|14 Zaehler' traf nur W1); vermutlich steht sie im WELLENKO
ORT: unbekannt
SOLL/FIX: Z-16 (W7-Bilanz 23 Posten = 9+14): Die Bilanz-Stelle wurde im Wellenplan nicht gefunden (grep nach '23 Posten|9 Behaelter|14 Zaehler' traf nur W1); vermutlich steht sie im WELLENKONSOLIDIERUNGs-Teil B -- nicht weiter gesucht. Task #28 (herausgezogene Test-Verzeichnisse) existiert pending -- Teilindiz positiv.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 171
GEGENSTAND: V[1]-nicht_pruefbar[24]: Z-18 (IST-Karte: 30 Gates, 18 Segment-Timer, MICRO-Makro ohne Leser, PMC iterator:2574, naht:159-160): Die Nachzaehlungen mit ausgeschriebenem Kommando wurden nicht durchgefuehrt (
ORT: abi_adapter.hpp
SOLL/FIX: Z-18 (IST-Karte: 30 Gates, 18 Segment-Timer, MICRO-Makro ohne Leser, PMC iterator:2574, naht:159-160): Die Nachzaehlungen mit ausgeschriebenem Kommando wurden nicht durchgefuehrt (abi_adapter.hpp ist 2000+ Zeilen; Budget).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 172
GEGENSTAND: V[1]-nicht_pruefbar[25]: Z-26 (Korrekturliste HEAVY_J 24->16 etc.): runner-mode.sh:43 und die Ledger-Zitatstellen nicht aufgesucht -- ob die Korrektur VOLLZOGEN oder nur Posten ist, offen
ORT: runner-mode.sh:43 | runner-mode.sh
SOLL/FIX: Z-26 (Korrekturliste HEAVY_J 24->16 etc.): runner-mode.sh:43 und die Ledger-Zitatstellen nicht aufgesucht -- ob die Korrektur VOLLZOGEN oder nur Posten ist, offen. Einziger Code-Anteil (runner-mode.sh) waere ein 1-Zeilen-Check: nachholen.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 173
GEGENSTAND: V[1]-nicht_pruefbar[26]: Z-28 (353 Fundstellen-Klassifikation, c9240477): Klassifikator-Nachlauf mit Gegenprobe nicht durchgefuehrt; git show c9240477 nicht gemacht.
ORT: c9240477
SOLL/FIX: Z-28 (353 Fundstellen-Klassifikation, c9240477): Klassifikator-Nachlauf mit Gegenprobe nicht durchgefuehrt; git show c9240477 nicht gemacht.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 174
GEGENSTAND: V[1]-nicht_pruefbar[27]: Z-29 (4cd1ab91 beide Lesarten dokumentiert + 8-Punkte-Ripple): Commit nicht geshowt; checkpoint_speicher.hpp:119-123 nicht gelesen.
ORT: checkpoint_speicher.hpp:119-123 | 4cd1ab91
SOLL/FIX: Z-29 (4cd1ab91 beide Lesarten dokumentiert + 8-Punkte-Ripple): Commit nicht geshowt; checkpoint_speicher.hpp:119-123 nicht gelesen.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 175
GEGENSTAND: V[1]-nicht_pruefbar[28]: Z-30 (OD-7-Timeline, vier Owner-Stellen human-klassifiziert): Transkriptarbeit nicht durchgefuehrt; Korpusgrenze macht 'vollstaendig' prinzipiell relativ (nur Journale vor 06.08.).
ORT: unbekannt
SOLL/FIX: Z-30 (OD-7-Timeline, vier Owner-Stellen human-klassifiziert): Transkriptarbeit nicht durchgefuehrt; Korpusgrenze macht 'vollstaendig' prinzipiell relativ (nur Journale vor 06.08.).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 176
GEGENSTAND: V[1]-nicht_pruefbar[29]: Z-36 (H: 9 Builder + BuildOrchestrator; IExperimentDock 0 Treffer): Zaehlungen nicht durchgefuehrt (waere je ein grep -- im Schlussbudget nicht mehr gefahren).
ORT: unbekannt
SOLL/FIX: Z-36 (H: 9 Builder + BuildOrchestrator; IExperimentDock 0 Treffer): Zaehlungen nicht durchgefuehrt (waere je ein grep -- im Schlussbudget nicht mehr gefahren).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 177
GEGENSTAND: V[1]-nicht_pruefbar[30]: Z-37 (KON20-04: 1351 gescannt, 164 leere Ruempfe...): Scan nicht wiederholt; heutiger Datei-Nenner (find libs+apps hpp/cpp) = 1330 -- Scope-Differenz zur 1351 unbestimmt; die deklar
ORT: unbekannt
SOLL/FIX: Z-37 (KON20-04: 1351 gescannt, 164 leere Ruempfe...): Scan nicht wiederholt; heutiger Datei-Nenner (find libs+apps hpp/cpp) = 1330 -- Scope-Differenz zur 1351 unbestimmt; die deklarierte Teilpruefung (~1175 nur teilgeprueft) bleibt die offene Flanke.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 178
GEGENSTAND: V[1]-nicht_pruefbar[31]: Z-43 (LagerBaumWriter-Referenz = 1, BuildOrchestrator = 11): Die beiden grep-Zaehlungen wurden nicht reproduziert; Vorsicht KON14-01 (Factory-Aufrufer make_binaries_baum_writer zae
ORT: unbekannt
SOLL/FIX: Z-43 (LagerBaumWriter-Referenz = 1, BuildOrchestrator = 11): Die beiden grep-Zaehlungen wurden nicht reproduziert; Vorsicht KON14-01 (Factory-Aufrufer make_binaries_baum_writer zaehlen zum Gegenstand).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 179
GEGENSTAND: V[1]-nicht_pruefbar[32]: Z-52 (13 Shell-Proben/7967 Z
ORT: unbekannt
SOLL/FIX: Z-52 (13 Shell-Proben/7967 Z. vs 517 gtests; KON14-04 korrigiert auf 14/8528): Heutige Zaehlung nicht durchgefuehrt; super ci/tests hat inzwischen deutlich mehr Dateien (Listing zeigte 14+ Proben) -- Trend bestaetigt sich anekdotisch, Zahlen nicht erhoben.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 180
GEGENSTAND: V[1]-nicht_pruefbar[33]: Z-54 (18.900 laute / 64 stille Brueche: 35 GLOB + 29 Anker): Die Abhaengigkeitstabelle wurde nicht nachgezaehlt; als F2-Risikoposten weiter offen.
ORT: unbekannt
SOLL/FIX: Z-54 (18.900 laute / 64 stille Brueche: 35 GLOB + 29 Anker): Die Abhaengigkeitstabelle wurde nicht nachgezaehlt; als F2-Risikoposten weiter offen.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 181
GEGENSTAND: V[1]-nicht_pruefbar[34]: Z-55 (Thesis zweimal Submodul, beide leer; InputIfFileExists 13 vs 28): .gitmodules und die Zaehlung nicht geprueft.
ORT: unbekannt
SOLL/FIX: Z-55 (Thesis zweimal Submodul, beide leer; InputIfFileExists 13 vs 28): .gitmodules und die Zaehlung nicht geprueft.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 182
GEGENSTAND: V[1]-nicht_pruefbar[35]: Z-57 (S-17: 0 Produktionsaufrufer; O-9-Voraussetzung): Aufrufer-Zaehlung nach dem Gegenstand (inkl
ORT: unbekannt
SOLL/FIX: Z-57 (S-17: 0 Produktionsaufrufer; O-9-Voraussetzung): Aufrufer-Zaehlung nach dem Gegenstand (inkl. Factories) nicht neu gefahren; O-9-Existenz (NAS/MinIO-Wurzel) nicht geprueft.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 183
GEGENSTAND: V[1]-nicht_pruefbar[36]: F-06 (KON34-06(b) geschlossen; B4-Zielrolle): Ledger-/Wellenplan-Stellen nicht aufgeschlagen (nur par.17.1-Zeile 'KON34-06(b): Reihenfolge zaehlt DOCH -- als statische Anordnungs-Freig
ORT: unbekannt
SOLL/FIX: F-06 (KON34-06(b) geschlossen; B4-Zielrolle): Ledger-/Wellenplan-Stellen nicht aufgeschlagen (nur par.17.1-Zeile 'KON34-06(b): Reihenfolge zaehlt DOCH -- als statische Anordnungs-Freigabe' gesehen -- Teilindiz fuer die Schliessung, nicht fuer die B4-Praezisierung).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 184
GEGENSTAND: V[1]-nicht_pruefbar[37]: F-10 (F11-Streichung an sechs Stellen + Gegenprobe siebte Stelle): Die sechs UEBERHOLT-Marker nicht einzeln aufgesucht; der repo-weite Gegen-grep nach der Formulierung nicht gefahr
ORT: unbekannt
SOLL/FIX: F-10 (F11-Streichung an sechs Stellen + Gegenprobe siebte Stelle): Die sechs UEBERHOLT-Marker nicht einzeln aufgesucht; der repo-weite Gegen-grep nach der Formulierung nicht gefahren.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 185
GEGENSTAND: V[1]-nicht_pruefbar[38]: F-12 (KON26-06: fuenf Posten erledigt): Nicht einzeln geprueft; Achtung Stellvertreter -- 'T-15b-Bauplan' ist ein PLAN (Task #13 steht heute pending/BAUBEREIT, also Bau NICHT erledi
ORT: unbekannt
SOLL/FIX: F-12 (KON26-06: fuenf Posten erledigt): Nicht einzeln geprueft; Achtung Stellvertreter -- 'T-15b-Bauplan' ist ein PLAN (Task #13 steht heute pending/BAUBEREIT, also Bau NICHT erledigt -- soweit aus dem Task-Store ableitbar).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 186
GEGENSTAND: V[1]-nicht_pruefbar[39]: P-12 (gitleaks-Koeder ueber WF2-Rohdaten): Nicht wiederholt
ORT: unbekannt
SOLL/FIX: P-12 (gitleaks-Koeder ueber WF2-Rohdaten): Nicht wiederholt. WICHTIG: das 13.08.-Memory widerlegt die dort verankerte Laengen-Regel bereits (aws_secret+20 biss NICHT; nur config-Regel-Koeder wie glpat-+20 beissen) -- der Fallen-Register-Eintrag aus KON20-05 ist damit selbst korrekturbeduerftig.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 187
GEGENSTAND: V[1]-nicht_pruefbar[40]: L-24 (Hygiene ueber kumulativen main-FF-Bereich, 77 Commits/10.046 Z.): Der main-FF (#19) ist bis heute nicht vollzogen (kein Anlass-Bereich definiert); ein heutiger Lauf misst ein
ORT: unbekannt
SOLL/FIX: L-24 (Hygiene ueber kumulativen main-FF-Bereich, 77 Commits/10.046 Z.): Der main-FF (#19) ist bis heute nicht vollzogen (kein Anlass-Bereich definiert); ein heutiger Lauf misst einen anderen, groesseren Bereich und widerlegt/bestaetigt die damalige Zahl nicht. Vor dem tatsaechlichen FF ist der Lauf PFLICHT (Memory: push-lokal vs kumulativ, 18.577-Beispiel).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 188
GEGENSTAND: V[1]-nicht_pruefbar[41]: KON58/POST-KON57 (aus 'nicht_erhoben' der Quelle, hier verifiziert soweit moeglich): KON57 ist der hoechste Nachtrag (Ledger :19); die dort als OFFEN dokumentierte Landesequenz ist
ORT: 7d65eb6c | 09937abe | f23c18e2
SOLL/FIX: KON58/POST-KON57 (aus 'nicht_erhoben' der Quelle, hier verifiziert soweit moeglich): KON57 ist der hoechste Nachtrag (Ledger :19); die dort als OFFEN dokumentierte Landesequenz ist am Objekt VOLLZOGEN UND GRUEN: ce 15770 success @7d65eb6c, super 15771 success @09937abe, ce 15774 success @f23c18e2, super 15773 success @f8cff2c8 (alle per API). Dieser Vollzug steht weiterhin NICHT im Ledger -- Nachtrags-Posten.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 189
GEGENSTAND: V[1]-nicht_pruefbar[42]: QUERSCHNITT-BEFUND zur Nachimplementierungs-Liste (Zusammenfassung der harten Funde): (1) Z-45 Memory-153 unkorrigiert; (2) Z-42/Z-56 falsche Marker-/Lock-Nenner im Ledger (real 0/
ORT: unbekannt
SOLL/FIX: QUERSCHNITT-BEFUND zur Nachimplementierungs-Liste (Zusammenfassung der harten Funde): (1) Z-45 Memory-153 unkorrigiert; (2) Z-42/Z-56 falsche Marker-/Lock-Nenner im Ledger (real 0/130 Marker, 6 Lock-Eintraege) bei weiter offenem S-14-Ausrollen; (3) Z-06 'kein Produktionspfad' im Ledger falsch (orchestrator:761 seit 19.07.); (4) L-22/15678: vierte 11.08.-Landung endete ROT, nie im Ledger geschlossen; (5) B-08 2x2-Lande-Skript lebt nur im fluechtigen Job-tmp; (6) W-02/D-07-Backups liegen untracked NUR im Landungs-Worktree -- Loeschregel P-06 existiert nur als Memory, nicht als Werkzeug; (7) Z-50: Planer-SHA und CEB-System-Zeile weiterhin leer (laut deklariert), Tier-/Hybrid-Stempel-Erbinnen fehlen (2/4); (8) MEMORY-Kopf stale (KON36 vs KON57) inkl. zweier als offen gefuehrter, laengst beantworteter Owner-Fragen (Z-62); (9) P-03: drei 10.08.-ce-Branches (p2/p3/p6) weiterhin ungelandet im geteilten Store.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 190
GEGENSTAND: REF-15 [TEILWEISE] Dokument gegen KON37/KON38 abgeglichen, Ledger Z.19-250 gegengelesen, alle 22 Review-Fixes eingearbeitet
ORT: unbekannt
SOLL/FIX: Die 22 Fixes existieren nirgends als Liste (0 Treffer in docs/); der Z.19-250-Abgleich ist nur historisch, am heutigen Objekt nicht nachvollziehbar. Nachimplementierung: Fix-Liste aus Workflow-Backup referenzieren.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Dokument referenziert KON37/38 durchgehend (Teil B Legende, par.17.1-ZU-Tabelle mit allen 8 F-A..F-H). grep '^## NACHTRAG' Ledger: Z.19=KON57, Z.116=KON56, Z.201=KON55 -- der Bereich Z.19-250 ist heute anderer Text als am 12.08.

### [wtk6lmhln.json] 191
GEGENSTAND: REF-16 [TEILWEISE] LEDGER-KONSOLIDIERUNG IV Kapitel A-M inkl. ERGAENZT-Bloecke existiert
ORT: unbekannt
SOLL/FIX: Kapitel A (Index) und L (Methodik) tragen KEINEN ERGAENZT-Block -- 11 von 13; ob der 56-Fakten-Anspruch (KON36) A/L einschloss, ist unbelegt.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): grep -n 'LEDGER-KONSOLIDIERUNG IV' -> Z.1796; Kapitel A(1814) bis M(2424) = 13 Kapitel; grep 'ERGAeNZT' im Bereich = 11 Bloecke (B,C,D,E,F,G,H,I,J,K,M)

### [wtk6lmhln.json] 192
GEGENSTAND: STR-04 [TEILWEISE] #14 ce gruenen: #83 lint:format zuerst, dann #84, dann #80 coverage-guard
ORT: .gitlab-ci.yml | 7d65eb6c | 671d7f6a
SOLL/FIX: #80 coverage-guard: kein einzelner Fix-Beleg im Ledger (15759 SUCCESS impliziert gruen -- Job hat kein allow_failure -- aber der ISA/Host-Fix ist nirgends dokumentiert); fuer den HEUTIGEN Gitlink 7d65eb6c existiert kein Pipeline-Terminal-Beleg (KON57-05 fuehrt Landesequenz+Monitor als offen).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): git show 7d65eb6c:.gitlab-ci.yml: lint:format Z.90 existiert; KON57-02: '#84-VORBESTAND ERKLAERT UND GEHEILT' (F12, clang/Debug-Padding); KON56: 'CI ce Pipeline 15759 SUCCESS (beide Compiler; einziger Rot war pmc:intel, transient, Retry gruen)' @671d7f6a

### [wtk6lmhln.json] 193
GEGENSTAND: STR-05 [TEILWEISE] #9 Referenz-Konsolidierung gelandet inkl. Teil-A-Einpflege in GOAL/Wellenplan/Designplan
ORT: unbekannt
SOLL/FIX: A.5-Stellen OHNE Marker am Objekt: Wellenplan-DOKUMENTKOPF (head -12: keine FORTSCHREIBUNG), par.8/OV-2-Zeile (Z.977 unmarkiert), par.2-D4+par.7-T-15-Fussnoten (Z.607-621/941: keine), par.16.1/O-5 (Z.1950 unmarkiert), Designplan par.2/K7 ohne [D-5->par.10]; par.17.1-F5/F7-Praezisierung nur als Quellklammer (s. REF-13).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): grep -c 'REFERENZ-STAND 12.08.2026' GOAL = 1; Wellenplan par.17 ab Z.1996; Designplan par.10 ab Z.402; Marker-Zaehlung: GOAL 8 + Wellenplan 6+FORTSCHREIBUNG(1939) + Designplan 5+STAND-HINWEIS(Z.2) = 21 = KON40-04-Zaehlung

### [wtk6lmhln.json] 194
GEGENSTAND: STR-06 [NICHT_ERLEDIGT] #10 MinIO-Keys + 776-Runner-Token-Rotation + test:secrets aus prod2 (heute faellig)
ORT: super/.gitlab-ci.yml | 7d65eb6c
SOLL/FIX: Alle drei Teile ohne Vollzugs-Beleg. Klaerung: 776 = ANZAHL Runner-Registration-Token (KON2-02), 289 = Projekt-ID des rotierten Thesis-Tokens (KON46-03) -- zwei Gegenstaende, kein Widerspruch. test:secrets existiert in keinem der beiden Repos -- Umsetzungsort (CI-Template-Repo?) zu bestimmen.
STATUS LT. QUELLE: offen (Behauptung faellt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): KON22-01/(5): MinIO-Neueinsetzen 'UNGEPRUEFT'; /(6): 'die 776 Runner-Token sind UNGEPRUEFT'; /(7): test:secrets-Herausnahme 'ungeprueft ob umgesetzt'; KON57-05 Punkt 4 fuehrt '#10 MinIO' als offene Reststrecke (letzter Ledger-Stand); grep 'test:secrets' super/.gitlab-ci.yml + ce@7d65eb6c = 0 Job-Treffer (nur lint:secrets Z.289 super)

### [wtk6lmhln.json] 195
GEGENSTAND: STR-07 [GEGENSTANDSLOS] #11 Durchstich-Bau ganztaegig am 13.08.
ORT: 5f4024af
SOLL/FIX: -
STATUS LT. QUELLE: nur-hinweis (gegenstandslos/ueberholt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Der Durchstich ist seit 12.08. abends fertig: KON56-01 Strang C 5f4024af (Katalog-Emitter, P9: measured=1, ns_per_op=644.020) + KON57-01 'DER ##25-BEWEIS IST KOMPLETT TERMINAL' (15764, 35/35, Job 376333). KON44 ('faehrt heute nicht') war 12.08. mittags, aufgeloest durch KON47-01 (Option a). git -C ce log --since=2026-08-13: nur s14/q6-Commits -- kein Durchstich-Bau noetig

### [wtk6lmhln.json] 196
GEGENSTAND: STR-08 [TEILWEISE] (a) #83 gelandet, dann S-1 landen; (b) S-3/S-7 gebaut+inert, nur aktivieren
ORT: bvset_teilmenge.hpp | test_bvset_teilmenge.cpp | build_orchestrator.hpp | 7d65eb6c | 868ed3a1
SOLL/FIX: 'inert' ist teilwiderlegt: git grep 'bvset_ist_teilmenge' 7d65eb6c -> build_orchestrator.hpp traegt 2 Produktions-Treffer (nicht 0 Aufrufer). Die Voraussetzungs-Wache (S-3-Aktivierungsgegenstand) wurde nicht einzeln vermessen -- beide Zahlen (existiert/inert) sind je Seite getrennt nachzuerheben.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): (a) lint:format in ce@7d65eb6c Z.90 + KON56 'Format-Serie (cf22-Vollformat 10 Dateien)'; S-1 gelandet (KON56 Strang A 868ed3a1, Merge 99de5b30). (b) bvset_teilmenge.hpp 187 Z. + test_bvset_teilmenge.cpp am Gitlink

### [wtk6lmhln.json] 197
GEGENSTAND: STR-09 [TEILWEISE] #22-Paket: runner-mode.sh:43 HEAVY_J 24->16 + Q6-MaxN 8->32 (heute faellig)
ORT: libs/cache_engine/hybrid/heuristik_adapter_synthese_matrix.hpp | /home/comdare/Projekte/Cluster/scripts/runner-mode.sh | runner-mode.sh:43 | 7d65eb6c | f23c18e2
SOLL/FIX: Der Kernposten HEAVY_J 24->16 ist NICHT vollzogen (prod1 traegt 24; prod2 $(nproc)); par.69.6-Vermerk und N-3/N-4-Rechnung mit 16 Workern ohne Fundstelle. Nachimplementierung: runner-mode.sh:43 aendern + Vermerk.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Q6: git show 7d65eb6c:libs/cache_engine/hybrid/heuristik_adapter_synthese_matrix.hpp Z.83: 'inline constexpr std::size_t kHybridNodeObergrenzeDefault = 32;' + heutige ce-Commits f23c18e2/58579575 'Dock-32-Entscheid an 4 Stellen nachgetragen'. HEAVY_J: sed -n '43p' /home/comdare/Projekte/Cluster/scripts/runner-mode.sh: 'prod1) ... HEAVY_J=24'

### [wtk6lmhln.json] 198
GEGENSTAND: STR-10 [NICHT_ERLEDIGT] golden Version festschreiben (heute faellig, Voraussetzung #16)
ORT: bau/golden-s14a-riegel | a8465ef3
SOLL/FIX: Kein golden-Datenversions-Artefakt in super development. Arbeit laeuft im gesperrten Worktree wt-ce-golden-s14a (Branch bau/golden-s14a-riegel) -- Landung + Versionsartefakt stehen aus.
STATUS LT. QUELLE: offen (Behauptung faellt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): grep -rn 'GOLDEN_VERSION|golden_version' super/ci super/scripts super/Code/experiment_config = 0; KON57-05 Punkt 4 fuehrt 'golden festschreiben (#16-Voraussetzung)' als offen; heutiger Branch-Commit a8465ef3 'golden(axis-lock): Baseline auf 158 Traeger' ist die LOCK-Baseline (S-14a), NICHT die golden-Datenbasis-Version -- Stellvertreter-Gefahr genau wie in der Pruefform benannt

### [wtk6lmhln.json] 199
GEGENSTAND: STR-11 [TEILWEISE] S-14a Bump-Wache Teil 1, heute 6/136 gedeckt
ORT: tools/axis_version_lock/axis_version.lock | bau/golden-s14a-riegel | 7d65eb6c | b12afd32
SOLL/FIX: Der Nenner 136 ist mit keiner benannten Zaehlweise reproduzierbar -- konkurrierend: 130 (par.15.9) / 136 / >=152 (Posten 41) / 345/371 (eigene Zaehlung) / 387 (13.08.-Befund) / 158 (heutige Branch-Baseline). Exakt die Grundgesamtheits-Klasse des Tagesbefunds. Teil 1 laeuft HEUTE auf bau/golden-s14a-riegel (b12afd32: 'sieben Fund-Gruppen am Riegel geschlossen') -- nicht gelandet. Nachimplementierung: 'bump-pflichtig' schriftlich definieren, dann Nenner festschreiben.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): git show 7d65eb6c:tools/axis_version_lock/axis_version.lock = 9 Zeilen, davon 6 Datenzeilen -- alle 6 unter libs/cache_engine/heuristik/, 0 unter axes/ (Zaehler 6 bestaetigt). Nenner: grep -c '/axes/.*hpp$' auf ls-tree = 345 (bzw. 371 mit 'axes' irgendwo)

### [wtk6lmhln.json] 200
GEGENSTAND: STR-12 [TEILWEISE] Vier F1-Lieferungen morgen: Durchstich landet * ce-Pipeline gruen * #21 E-1..E-4 * S-3 aktivieren
ORT: 671d7f6a | 7d65eb6c
SOLL/FIX: ce-Pipeline fuer den HEUTIGEN Gitlink 7d65eb6c ohne Terminal-Beleg; #21 Pruefposten E-1..E-4 + A-1-Vorlagetext: kein Artefakt gefunden (docs/ 13.08. leer); S-3-Aktivierung: fuer Fr geplant (KON57-05), 0 Aktivierungs-Commits.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Durchstich: CI-bewiesen (KON57-01: 15764 TERMINAL SUCCESS 35/35, measure:smoke 376333, 'MESS-AUSBEUTE-WACHE OK (1 echte, 0 n/a)'). ce: 15759 SUCCESS @671d7f6a (KON56)

### [wtk6lmhln.json] 201
GEGENSTAND: STR-16 [TEILWEISE] Tier-Pflicht-Wurf in abi_adapter.hpp:476-491 (faellt per KON37-01)
ORT: libs/cache_engine/anatomy/abi_adapter.hpp | mess_achsen_naht.hpp:304 | mess_achsen_naht.hpp | 7d65eb6c | 671d7f6a
SOLL/FIX: Der KON37-01-/Plan-Anker zeigt auf die falsche Datei -- der Pflicht-Wurf liegt in mess_achsen_naht.hpp, nicht abi_adapter.hpp:476-491. B3-Doppeltermin bestaetigt (Teil B Posten 24: Mo 17.-Mi 19. Bau; Posten 34: 'B3 landet' Do 20./Fr 21. -- lesbar als Bau->Landung, unausgewiesen). Anker vor B3-Bau korrigieren.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): git show 7d65eb6c:libs/cache_engine/anatomy/abi_adapter.hpp | grep -n 'throw' = 1 Treffer, nur Kommentar Z.646; Z.470-495 traegt Runtime-Setter (identisch am 671d7f6a). Der reale Wurf: mess_achsen_naht.hpp:304 'throw std::runtime_error("fehlerklasse=konfiguration_widerspruch: COMDARE_MEASUREMENT_COMBO fehlt/leer...")' + Kommentar :280 'DIE HEILUNG IST EIN WURF'

### [wtk6lmhln.json] 202
GEGENSTAND: STR-18 [TEILWEISE] Diff-Hygiene-Wache 779/558 Z. angleichen * Mutant bvset_ist_teilmenge * 6/>=152
ORT: scripts/ci_diff_ascii_width_guard.sh | build_orchestrator.hpp | 7d65eb6c
SOLL/FIX: Beide Fassungszahlen (779/558) sind am Objekt nicht mehr vorhanden (heute 662/936) -- Divergenz besteht weiter, Angleich-Posten #19 offen (W2, planmaessig); Mutationslauf-Beleg fuer #82 nicht erhoben; '6/>=152' teilt den strittigen S-14-Nenner (s. STR-11).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Wache = scripts/ci_diff_ascii_width_guard.sh: wc -l super-Arbeitskopie = 662; git show 7d65eb6c:scripts/ci_diff_ascii_width_guard.sh | wc -l = 936. bvset_ist_teilmenge existiert (4 Trefferdateien inkl. build_orchestrator.hpp)

### [wtk6lmhln.json] 203
GEGENSTAND: STR-19 [TEILWEISE] T-15b 8-Punkte-Ripple checkpoint_speicher.hpp:119-123 * measure-drop heilen (vor Kampagne)
ORT: checkpoint_speicher.hpp | 7d65eb6c
SOLL/FIX: measure-drop-Heilung offen (Posten 42, Frist vor Kampagne -- nicht ueberfaellig); die Unbedingtheit des CSV-Versands wurde nicht am Kontrollfluss gezeigt (Sendepfad nicht lokalisiert).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): git show 7d65eb6c:...checkpoint_speicher.hpp Z.115-127: Formel-Doku 'reps * (max_reruns + 1) ... Vorgabewerten 3 und 5 ... bis zu 18 Durchlaeufe' -- Ripple-Anker trifft. KON32-01 im Ledger als 'bleibt falsch' gefuehrt

### [wtk6lmhln.json] 204
GEGENSTAND: STR-20 [TEILWEISE] thesis_profiles 8/9 xlsx-blind * window_belongs_to unverdrahtet * AnatomyModuleLoader Sync-Kandidat
ORT: .profile.xml | batch_planner.hpp:78 | 7d65eb6c
SOLL/FIX: Nenner 9 nicht reproduzierbar (11 vendorierte am Gitlink) -- vor Kampagnen-Planung neu zaehlen + je Profil xlsx-Pfad pruefen; 'window_belongs_to unverdrahtet' gilt hoechstens fuer den uebergeordneten Produktionspfad (interner Aufrufer existiert).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): ls-tree 7d65eb6c thesis_profiles/: 11 *.profile.xml (all_axes_golden, base_pilot, cacheline_study, fb_numa_page, ff2_node_width, m3_golden_coverage, m3_smoke_coverage, m3v2_smoke, m3v2_sota_pilot, m3v2_study, wdk_fairness) + super f1_durchstich = 12. window_belongs_to: definiert batch_planner.hpp:78, gerufen :478 + 6 Testzeilen. AnatomyModuleLoader: breite Konsumenten, 0 unter libs/cache_engine/hybrid/

### [wtk6lmhln.json] 205
GEGENSTAND: STR-21 [NICHT_ERLEDIGT] Trigger-Kriterium Mi 26.08.: #7-Zahlen + S-13/S-17 + B1/B2/B4/B5 + S-14-Vollausrollung (+#68)
ORT: director.hpp:489
SOLL/FIX: Frist 26.08. nicht ueberschritten -- aber JEDE Teilbedingung braucht noch ihren Nachweis-Gegenstand; '#68 oder dokumentierter Verzicht' hat kein Dokument mit Datum.
STATUS LT. QUELLE: offen (Behauptung faellt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Ist-Stand heute je Teil: #7/S-19 = nur Zaehl-Keim PlanSizeBuilder (director.hpp:489); S-13 = COMDARE_STORAGE_CACHE-Mechanik vorhanden, nicht scharf; S-17 = LagerBaumWriter 0 Aufrufer; B1-B5 = par.17.3-Posten ungebaut (Wurf steht, Gates ungetrennt); S-14-Vollausrollung = in Arbeit auf Branch; #68 = kein Beginn, kein datierter Verzicht -> 0/8

### [wtk6lmhln.json] 206
GEGENSTAND: STR-23 [TEILWEISE] Fuenf engste Glieder (Stand 12.08. abends) als offene Posten
ORT: decl.hpp
SOLL/FIX: Glied (2) ist GEFALLEN: OF-1 per KON40-02+KON41-02 ('Ja korrekt.') geklaert, OF-2-neu per KON42 beantwortet ('Offene Owner-Fragen: NULL') -- beide datieren nach der Plan-Landung; die Engstellen-Liste ist an dieser Stelle ueberholt und traegt keinen Marker.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): (1) Layout-Bump: decl.hpp-Verbot steht (Z.287/306) -- offen [OK]; (3) S-13/S-17: offen [OK] (0 Aufrufer LagerBaumWriter); (4) Explore 21b: kein 13.08.-Artefakt -- Glied besteht [OK]; (5) XML->PDF+Lager-Skip: offen [OK]

### [wtk6lmhln.json] 207
GEGENSTAND: STR-24 [NICHT_ERLEDIGT] Datei-Mengen-Explore A<->E vor Mo 17.08. (Schnittmenge als Dateiliste)
ORT: 20260812 | 20260813
SOLL/FIX: Frist (vor Mo 17.) laeuft noch, aber das Artefakt existiert nicht; ohne die Schnittmengen-Liste bleibt die B5-Lande-Slot-Entscheidung ungedeckt. Nachimplementierung: Explore fahren, ZWEI Dateimengen + Schnittmenge persistieren.
STATUS LT. QUELLE: offen (Behauptung faellt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): ls -t docs/sessions/ | head: neueste Datei = 20260812-*; ls docs/{sessions,plaene} | grep 20260813 = 0 Treffer -- kein Explore-Artefakt, keine Dateimengen, keine Schnittmengen-Liste

### [wtk6lmhln.json] 208
GEGENSTAND: REF-01 [TEILWEISE] hybrid/ traegt 4 Header/943 Z. + 1802 Z. Vorarbeit, 0 Produktions-Konsumenten
ORT: 7d65eb6c
SOLL/FIX: Die '1802 Z. Vorarbeit' tragen keinen Ort -- ohne Ortsangabe nicht zaehlbar (Ledger:10813-Anker gedriftet; ueber KON9-02 zu schneiden).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): git show 7d65eb6c:libs/cache_engine/hybrid/heuristik_adapter_{gate,klassifikation,strategy,synthese_matrix}.hpp | wc -l = 189/256/246/252, Summe 943 [OK]; kein Konsument der hybrid-Header ausserhalb hybrid/ gesichtet

### [wtk6lmhln.json] 209
GEGENSTAND: REF-02 [TEILWEISE] HeuristikAdapter=3 (4. Gattung) + FunctionInterfaceReroute=5 (Genus sechswertig) + genus() liefert NIE den Reroute-Wert
ORT: anatomy_base.hpp | 7d65eb6c
SOLL/FIX: Die Pass-through-Aussage ist am Objekt nur Kommentar-Doktrin ('ER IST BEWUSST NICHT DIE ANTWORT VON genus()') -- ein Hybrid-genus()-Rueckgabepfad existiert noch nicht (0 Hybrid-Binaries); Verhaltens-Beweis steht bis HY-A aus.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): git show 7d65eb6c:...anatomy_base.hpp: 'HeuristikAdapter = 3' (Gattung vierwertig: Map/Container/Graph/HeuristikAdapter), 'FunctionInterfaceReroute = 5' (Genus sechswertig), gattung_of 7 Treffer in anatomy_base -- Anker :53-92/:131-169 treffen

### [wtk6lmhln.json] 210
GEGENSTAND: REF-04 [TEILWEISE] ce hat GENAU EINEN roten Job = test:coverage-guard (F1/F2 = Guard-Schritte)
ORT: 7d65eb6c | 671d7f6a
SOLL/FIX: Ueberholt durch KON56: Pipeline 15759 SUCCESS @671d7f6a (einziger Rot pmc:intel transient) -- coverage-guard war dort gruen, ohne dokumentierten Fix-Eintrag; when:always (Guard-F2-Schritt) im Job nicht gefunden; heutiger Gitlink ohne Pipeline-Beleg.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Fuer 12.08. per Jobliste belegt: Ledger Z.2618 '24 Jobs, GENAU 1 rot: test:coverage-guard (stage contract, allow_failure=false)'; Job-Definition@7d65eb6c: 'kein rules-Gate und kein allow_failure' [OK]; KON46-02 erwartete ROT

### [wtk6lmhln.json] 211
GEGENSTAND: REF-05 [TEILWEISE] IX D5: 3/5 erledigt (2 kanonisch + D5-1 via ce c98b4b95), offen D5-2+D5-4
ORT: c98b4b95
SOLL/FIX: Die fuenf D5-Teilposten sind im Dokument nicht aufgezaehlt (nur Wellenplan Z.695 nennt 'D5-3 -> D5-2, D5-4, D5-5') -- '3/5' bleibt ohne vollstaendige Postenliste unverifizierbar.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): git show --stat c98b4b95: 'D5-1: Perzentil-KANON -- alle vorher erhobenen p50/p95/p99 ungueltig' (09.08., tier_observe_trace_abi u.a.) -- D5-1 belegt

### [wtk6lmhln.json] 212
GEGENSTAND: REF-06 [TEILWEISE] Anker gewandert; super allein 38/41, Datei 2768 Z.
ORT: super/.gitlab-ci.yml
SOLL/FIX: '38/41' und '45' stehen als zwei unbenannte Zaehlweisen fuer DIESELBE Datei nebeneinander -- keine ist am Objekt als die gemeinte bestimmbar; Zaehlweise (Definitionen vs. .hidden vs. extends) festschreiben.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): wc -l super/.gitlab-ci.yml = 2768 [OK]; Top-Level-Key-Zaehlung = 50 inkl. ~5 Struktur-Keys ~ 45 Jobs (deckt par.14.7 '45')

### [wtk6lmhln.json] 213
GEGENSTAND: REF-07 [TEILWEISE] Stempel: 5 Rollen, durchgesetzt 2
ORT: decl.hpp
SOLL/FIX: Die 5-Rollen-Liste selbst existiert nur ledger-/memory-seitig; je Rolle fehlt die dokumentierte Zuordnung Rolle->durchsetzender Pfad (beide Mengen ausweisen).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Zwei brechende Pfade am Objekt gefunden: (1) CT-Fingerprint-/Layout-Wachen (decl.hpp static_asserts -- Uebersetzungsbruch) (2) axis_version_lock-CI-Job (ce yml :763-799, --check gegen Lock, exit!=0). NICHT durchgesetzt: Lager-Schluessel (LagerBaumWriter 1 Datei/0 externe kaskade-Aufrufe), Einsortier-/Skip-Pfad (Kaskade ohne Anschluss) -- konsistent mit 'durchgesetzt 2'

### [wtk6lmhln.json] 214
GEGENSTAND: REF-10 [TEILWEISE] Acht gegengeprueft-gueltige Aussagen inkl. TDD 117/386 h/157-117-40-62 und allow_failure-Verbot
ORT: 7d65eb6c
SOLL/FIX: allow_failure existiert real in ce@7d65eb6c (:257, :898 advisory-Jobs) -- das 'Verbot auf JOB-Ebene' gilt am Objekt nicht ausnahmslos und die Pauschal-Zeile weist die Ausnahmen nicht aus; 'gegengeprueft' bleibt ohne Pruefprotokoll eine Zusicherung.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Nachgerechnet: 53+59+5=117 [OK], 206+166,5+13=385,5 [OK] (386=Rundung, offengelegt nur in Designplan par.9.6); Fristen konsistent (F1 14.08. Fr, F2 21.08., Trigger 26.08., Abgabe 15.09.)

### [wtk6lmhln.json] 215
GEGENSTAND: REF-12 [TEILWEISE] A.5: ca. 20 einzeilige Marker an die Stellen selbst
ORT: unbekannt
SOLL/FIX: A.5 nennt mehr Gegenstaende als Marken gesetzt: ohne Marker sind Wellenplan-Dokumentkopf, par.8/OV-2 (Z.977), par.2-D4/par.7/par.12-T-15-Fussnoten, par.16.1/O-5 (Z.1950), Designplan par.2/K7 [D-5]; Marker 981 deckt OV-10+OV-13 gemeinsam. Fehlende Marker nachsetzen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Objekt-Zaehlung: grep -c 'MARKER 12.08.2026': GOAL 8, Wellenplan 6, Designplan 5 (=19) + FORTSCHREIBUNG (W:1939) + STAND-HINWEIS (P:2) = 21 Marken = KON40-04 ('alle 21 A.5-Marker bestaetigt')

### [wtk6lmhln.json] 216
GEGENSTAND: REF-13 [NICHT_ERLEDIGT] Wellenplan par.17.1-Quellenzeile 'F5,F7 (KON25)' traegt die Praezisierung (EXPLORE, geschlossen via WF4/WF5 + KON32-01)
ORT: unbekannt
SOLL/FIX: Der geforderte Praezisierungs-Wortlaut ('KON25-11 fuehrte E-F5/E-F7 als EXPLORE; geschlossen via WF4/WF5 + measure-drop KON32-01') steht NICHT im gelandeten par.17.1 -- die A.5-Zeile 161 wurde nicht an die Stelle uebertragen.
STATUS LT. QUELLE: offen (Behauptung faellt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): sed -n '2000,2004p' Wellenplan: par.17.1 sagt 'F1-F11 zu (KON25-11 * KON25 * KON27-01/-02 * KON28-03+KON30-04...)' -- nur Quellklammer

### [wtk6lmhln.json] 217
GEGENSTAND: REF-14 [TEILWEISE] Designplan: Z.2-Stand-Hinweis + [D-n -> par.10]-Marker an par.4/Regel3, par.2/K7, par.8, par.9.3, par.9.5
ORT: unbekannt
SOLL/FIX: [D-5 -> par.10] an par.2/K7 FEHLT (kein Marker in Z.33-59) -- die xlsx-Nenner-Drift ist an der Stelle selbst unmarkiert.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Z.2 traegt '[STAND-HINWEIS 12.08.: ... betroffene Stellen tragen [D-n -> par.10]-Marker.]' [OK]; Marker am Objekt: Z.86 [D-1] (par.4) [OK], Z.118 [D-4] + Z.124 [D-2] (par.8) [OK], Z.183 [D-3] (par.9.3) [OK], Z.391 [D-3] (par.9.5) [OK]

### [wtk6lmhln.json] 218
GEGENSTAND: OF-01 [GEGENSTANDSLOS] OF-1 (17 oder 18 Dateien) offen, Frist Mi 19.08.
ORT: unbekannt
SOLL/FIX: Teil-C-Zeile traegt (anders als OF-2) keinen Nachtrags-Marker -- Leser sieht eine beantwortete Frage als offen.
STATUS LT. QUELLE: nur-hinweis (gegenstandslos/ueberholt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): KON40-02: 'OF-1 AM OBJEKT GEKLAERT: 17 CODE-DATEIEN + 1 README = 18' (Liste je Datei); KON41-02: Owner 'Ja korrekt.' -> 'KON34-06(d) ist GESCHLOSSEN' -- beide 12.08., nach der Plan-Landung (KON39). Objekt-Stichprobe mess/=6 identisch

### [wtk6lmhln.json] 219
GEGENSTAND: OF-02 [GEGENSTANDSLOS] OF-2-neu offen, Frist Fr 21.08.
ORT: unbekannt
SOLL/FIX: -
STATUS LT. QUELLE: nur-hinweis (gegenstandslos/ueberholt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): KON41-03 (Owner: 'VOELLIG FALSCH', Entwirrung dreier Groessen; 'die OF-2-Formulierung in Teil C ... Marker gesetzt' -- am Objekt vorhanden: durchgestrichener Alt-Text + KORRIGIERT-Block in Teil C) + KON42-01(3): 'OF-2-NEU VOLLSTAENDIG BESTAETIGT (sonst exakt alles)' + KON42-02: 'Offene Owner-Fragen: NULL'

### [wtk6lmhln.json] 220
GEGENSTAND: OF-03 [GEGENSTANDSLOS] OF-3 (Hybrid-.so-Lager-Identitaet) offen, Frist Fr 21.08.
ORT: unbekannt
SOLL/FIX: -
STATUS LT. QUELLE: nur-hinweis (gegenstandslos/ueberholt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): KON41-04: 'DER HYBRID-STEMPEL -- ERBT TIER, PLUS DIE KOMPOSIT-MAP-ZEILE' (vorletzte Zeile = CT-Map, letzte = SHA, wirkt compile-time); KON45-01: Pruefung 'TRAEGT -- mit Budget-Bruch' (Preimage-Puffer 4096 zu klein, Map-VALUE = Tier-SHA); KON47-02: SHA in CT-Map + RT-Init-Cache bestaetigt

### [wtk6lmhln.json] 221
GEGENSTAND: OF-04 [GEGENSTANDSLOS] OF-4 (Festplatten-IO neuer Typ?) offen, Frist F3
ORT: unbekannt
SOLL/FIX: -
STATUS LT. QUELLE: nur-hinweis (gegenstandslos/ueberholt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): KON41-05: OF-4 als Bestands-Explore statt Owner-Frage; KON45-02: 'ADDITIVER TYP JA -- die COMP-GATE-SCHICHT FEHLT IN ALLEN DREI REALMS' (simd_organ_requirement:31-50 keine Achse; admit_organ_on_machine nur aus Tests); KON47-03: Owner 'ja, voll bauen wenn an der Reihe' -- Frage beantwortet, Bau terminiert

### [wtk6lmhln.json] 222
GEGENSTAND: W7-01 [TEILWEISE] TEST-KONSOLIDIERUNG: drei Skelett-Verzeichnisse, Eigentuemer setzen, aktiver Posten
ORT: 7d65eb6c
SOLL/FIX: Ein namentlicher Eigentuemer ist nirgends dokumentiert (Tasks-Liste aus dieser Session nicht einsehbar; par.17.1-OFFEN fuehrt 'Eigentuemer setzen' weiter als offen).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): ls-tree@7d65eb6c: tests/integration (2 Dateien), tests/generic_module_tests (2), tests/module_specific_tests (2) -- Skelette existieren; KON40-04: 'neu #28 TEST-KONSOLIDIERUNG' als Task angelegt

### [wtk6lmhln.json] 223
GEGENSTAND: WP-01 [TEILWEISE] W-1 abgeschlossen / W0a laeuft (Stand 11.08. nachts)
ORT: ca901c50 | 1f88cfec | 41b20a16
SOLL/FIX: Abschluss-Beleg je Welle EINZELN: der W0a-Rest (D1e/D1f/D1c/D2-G2/##06/##07) taucht in KEINER Erledigt-Liste auf -- W0a hat keinen vollstaendigen Abschluss-Beleg (s. WP-03).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): W-1: super ca901c50 (08.08. 'W-1 gelandet') + ce 1f88cfec [OK]; W0a: 41b20a16 (10.08., D1g) + KON40-01-Gelandet-Liste (D3-1-Kern+D3-2, D3-7, D3-3, ##23, D3-6, ##08, D2-G1)

### [wtk6lmhln.json] 224
GEGENSTAND: WP-02 [TEILWEISE] Erledigt gestrichen: D2 * D2-G1 * D2-G3 * D2-G4 * D2-G5 * D5-1 * D1g (super 41b20a16); D2-G6 nicht erhoben
ORT: 41b20a16 | c98b4b95
SOLL/FIX: D2-G3/G4/G5 ohne Einzelbeleg am Objekt (nur Sammelbehauptung); D2-G6-Status ist auch bis heute NICHT erhoben (kein Treffer in KON39-57) -- per Owner-Dauerregel 13.08. eine Luecke mit Behebungspflicht, kein Vermerk.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): 41b20a16 existiert (Merge w0a/d1g-super-configure, 10.08.) [OK]; D2-G1 + D5-1 in KON40-01/c98b4b95 belegt [OK]

### [wtk6lmhln.json] 225
GEGENSTAND: WP-03 [NICHT_ERLEDIGT] W0a-Rest: D1e * D1f * D1c * D2-G2 * ##06-CI-Haelfte * ##07 (Frist 12.08. mittags)
ORT: unbekannt
SOLL/FIX: Sechs Posten mit VERGANGENER Frist ohne Slot in der aktuellen Strecke -- verschollene Posten. Nachimplementierung: je Posten Gegenstand aufloesen, erledigen oder terminieren.
STATUS LT. QUELLE: offen (Behauptung faellt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Kein Erledigt-Beleg in KON40-KON57; Wellenplan-Fahrplan Z.875 fuehrt D1e/D1f/D1c/D2-G2 UNdurchgestrichen (waehrend D1b/##08/D3-7/D3-3/##20/D3-6/##23 durchgestrichen sind); Teil B enthaelt keinen der sechs Posten

### [wtk6lmhln.json] 226
GEGENSTAND: WP-04 [TEILWEISE] W0b-Rest: 10 Posten bis F1 (D3-1-Marker * D3-4+D3-5 * D3-8 * ##08-Rest * ##20-B * ##21 object_stat * ##23-R1 * ##26 * ##25 * ##27-##31)
ORT: ci/object_stat_wache.sh | object_stat_abnahme.sh
SOLL/FIX: OHNE Beleg: D3-4+D3-5 ('Bau fehlt' -- unveraendert undurchgestrichen), D3-8, ##08-Rest, ##20-B-Restbau, ##23-R1, ##28-##31 -- Frist ist morgen; von zehn Posten sind fuenf belegt erledigt/gebaut, fuenf offen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): ERLEDIGT am Objekt: ##25 (KON57-01) * ##26 (KON40-04 [DONE]) * ##27/E-WARMUP (KON45-03 'Explore FERTIG') * D3-1-Marker-Haelfte GEBAUT (mess_ausbeute_wache-Allowlist 'voll|provision_only|pruef_only|prune_only|auto' + frische_wache modus=voll-Logik + Aufrufe '1 auto' yml:1954/2134 = D3-7/D3-7b gelandet) * ##21-object_stat-Artefakte existieren (super ci/object_stat_wache.sh + object_stat_abnahme.sh + ce artifact_cache)

### [wtk6lmhln.json] 227
GEGENSTAND: WP-06 [TEILWEISE] #21=##25-Durchstich, GOAL :494 ('F1 nur halb ohne Besitzer')
ORT: unbekannt
SOLL/FIX: GOAL-Anker :494 zeigt auf den falschen Abschnitt -- bei Zitat neu suchen (Hausregel V14).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): sed -n '488,500p' GOAL: an :494 steht heute VI.5-Messung (T-15-Marker) -- der Anker ist durch den Kopf-Nachtrag verschoben; die Sache (Durchstich = F1-Lieferung, Besitzerpflicht) steht in par.17.6 + Teil B Posten 1; Nummernkollision #21/#11 im Text selbst ausgewiesen ('Gegenstand zaehlt, nie die Nummer')

### [wtk6lmhln.json] 228
GEGENSTAND: WP-07 [TEILWEISE] #90 Bump-Pflicht-Wache Teil 1: 'der Riegel' vorgezogen
ORT: tools/axis_version_lock/axis_version_lock.cpp | axis_version.lock | bau/golden-s14a-riegel | 7d65eb6c | b12afd32
SOLL/FIX: Deckung Teil 1 = nur 6 Dateien; Vollausrollung laeuft HEUTE auf bau/golden-s14a-riegel (b12afd32 'sieben Fund-Gruppen', 8257e517 Lock-Parser streng, 3cba6ade fail-closed Discovery) -- ungelandet; Namens-Vierfalt #90/S-14a/S-14/Vollausrollung unaufgeloest im Bestand.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Der Riegel existiert und haengt an der CI: tools/axis_version_lock/axis_version_lock.cpp + axis_version.lock (6 Eintraege) + ce-CI-Job @7d65eb6c :763-799 (baut comdare_axis_version_lock, faehrt --check gegen das Lock)

### [wtk6lmhln.json] 229
GEGENSTAND: WP-08 [TEILWEISE] #83 lint:format ohne lokale Deckung; dreimal in Folge Format-Nachzug
ORT: 7d65eb6c
SOLL/FIX: Die Zahl 'dreimal in Folge' wurde nicht per git log verifiziert (nicht erhoben); ob cf22 als PFLICHT-Hook verdrahtet ist (nicht nur als Werkzeug), nicht geprueft.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): lint:format existiert: super yml :328, ce@7d65eb6c :90; KON56 belegt lokales Format-Verfahren ('cf22-Vollformat 10 Dateien' + Kompilat-Neutralitaets-Beweis je Datei) -- lokale Deckung existiert inzwischen als Werkzeug

### [wtk6lmhln.json] 230
GEGENSTAND: WP-09 [TEILWEISE] #80 coverage-guard deterministisch rot
ORT: 7d65eb6c
SOLL/FIX: Ueberholt durch 15759 SUCCESS (KON56) ohne dokumentierten Fix; heutiger Gitlink ohne Beleg -- der Posten braucht eine Neuerhebung am 7d65eb6c-Lauf.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Deckungsgleich REF-04: fuer 12.08. per Jobliste belegt (Ledger:2618), Job ohne allow_failure [OK]

### [wtk6lmhln.json] 231
GEGENSTAND: WP-10 [TEILWEISE] #67: vier Familien, 142 Include-Kanten, 29 Include-Wanderungen
ORT: unbekannt
SOLL/FIX: Vor S-6d (#67-Schaerfung): Zaehlweise schriftlich festlegen, dann 142/29 neu erheben.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Keine Zaehlweise im Bestand benannt (Kante = Zeile? Paar? transitiv?) -- am Objekt ohne Definition nicht reproduzierbar; genau die 'kein-nenner'-Klasse aus Designplan par.2, im Plan der sie definiert

### [wtk6lmhln.json] 232
GEGENSTAND: WP-12 [TEILWEISE] 5 von 7 Paketen der fuenf F1-Kern-Explores schon erledigt; 3 von 4 Selbstkompilations-Bausteinen gebaut
ORT: profile_run_facade.cpp | 7d65eb6c
SOLL/FIX: Fussnote F1-KERN nicht aufgeschlagen -- der Nenner-Bruch (fuenf Explores -> sieben Pakete) bleibt unverifiziert; die Vierer-Bausteinliste ist nirgends am Objekt namentlich fixiert.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Bausteine am Objekt: ExperimentPlanDirector produktiv (profile_run_facade.cpp@7d65eb6c) + PlanSizeBuilder (:480-489) existieren; Memory bestaetigt 'es fehlt Steuerung -> Compile' als vierten

### [wtk6lmhln.json] 233
GEGENSTAND: WP-13 [TEILWEISE] Zweite run_experiment_profile in super (v32_messreihe_antrieb.hpp:214, 'der OFFIZIELLE Einstieg')
ORT: v32_messreihe_antrieb.hpp:228
SOLL/FIX: Anker :214 gedriftet (:226-228); der Titel 'der OFFIZIELLE Einstieg' gehoert execute_messreihe (:268), nicht run_experiment_profile -- Zitat-Zuordnung im Plan ungenau.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): grep -rn 'run_experiment_profile' super/Code/02_messung_driver/: Definition v32_messreihe_antrieb.hpp:228 ('der reine Antrieb (INC-G)') -- die zweite Enumerations-Engine EXISTIERT

### [wtk6lmhln.json] 234
GEGENSTAND: WP-14 [TEILWEISE] Owner-Reihenfolge: 1. Stempel planen LAEUFT * 2. Pipeline debuggen NAECHSTES * 3. Konsolidierung #88
ORT: unbekannt
SOLL/FIX: #88 GESAMT bleibt aktiv (KON37-07 bindet die Klon-Ordnung an #88) -- nur dessen Teil P.3 ist erledigt; die Reihenfolge wurde faktisch parallel (Strang D) statt seriell gefahren -- kein Schaden belegt, aber der Plan-Wortlaut ('NAECHSTES') deckt den Ablauf nicht.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Schritt 1: KON9/KON10 im Ledger gelandet [OK]; Schritt 3: nur P.3 erledigt (#9 [DONE] KON40-04 = DIESES Dokument); ce-gruen (KON56) kam NACH der Konsolidierungs-Landung (KON39)

### [wtk6lmhln.json] 235
GEGENSTAND: WP-15 [TEILWEISE] 3 von 4 Bausteinen existieren; Planer-Kopf = groesstes Loch (PL-1); Wellenplan kennt die Strecke nicht
ORT: unbekannt
SOLL/FIX: par.14.7-Zeile unmarkiert ueberholt (kein Marker dort); die Bausteinliste nirgends fixiert (wie WP-12).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Director am Gitlink produktiv (4 Konsumenten-Dateien); die DREI Zustandsaussagen im selben Dokument bestaetigt: par.14.7 'unangeschlossen' / par.15.5 'im Produktionspfad benutzt' / par.13.5(c) 'Strecke ohne Wellen-Platz' -- am Objekt gilt par.15.5

### [wtk6lmhln.json] 236
GEGENSTAND: WP-16 [GEGENSTANDSLOS] Variante-A-Lage: 'Was davon im Fenster gebaut wird: NICHTS -- W2 baut mit dem HEUTIGEN Bauweg'
ORT: unbekannt
SOLL/FIX: Die Stelle par.13.5(c) (Z.1456-1480) traegt KEINEN Marker (Marker-Liste: 955/981/1599/1923/1985/1992) -- spaeterer Leser liest die ueberholte Lage als aktuell. Marker nachsetzen.
STATUS LT. QUELLE: nur-hinweis (gegenstandslos/ueberholt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): par.14-Kopf (Z.1522-1530, Owner verbatim 'volles Risiko ... Richtung Variante B ... direkt ins Zielbild'): Varianten (A)/(A+)/(C) gestrichen -- die zitierte Lage-Aussage ist abgeloest

### [wtk6lmhln.json] 237
GEGENSTAND: WP-17 [TEILWEISE] Der heutige Bauweg funktioniert: 128 x 19,4 min ~ 41,4 h, 'gemessen'
ORT: unbekannt
SOLL/FIX: 'Gemessen' ist nur fuer die 19,4 min je Bau haltbar; der Faktor 128 ist unbelegt (S-19 soll ihn liefern) -- das Produkt ist gerechnet, nicht gemessen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Rechnung [OK] (41,39 h); par.16.3 nennt dieselbe Zahl 'als Rechenluecke benannt' -- zwei Bewertungen im selben Dokument bestaetigt

### [wtk6lmhln.json] 238
GEGENSTAND: WP-20 [TEILWEISE] Stempel-Designplan ST-00..ST-14 existiert nicht mehr: 0 Treffer ueber 180 Workflow-Outputs und docs/
ORT: unbekannt
SOLL/FIX: '0 Treffer ueber docs/' ist am heutigen Objekt falsch -- die Paketnamen-Erwaehnungen existieren (konsistent mit 'Erhalten sind Paketnamen', aber der Nichtfund-Wortlaut deckt sie nicht); die Nicht-Existenz des PLAN-DOKUMENTS selbst bleibt plausibel (kein eigenstaendiges Stempel-Designplan-Dokument in plaene/).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): grep -rlE 'ST-0[0-9]|ST-1[0-4]' super/docs/ = 5 Trefferdateien (Ledger, Wellenplan, 2 Sessions 11.08., Backup-MANIFEST); Kontrollkoeder ('S-14' in plaene/) biss mit 4 Dateien

### [wtk6lmhln.json] 239
GEGENSTAND: WP-21 [TEILWEISE] 91 Posten * 56 erledigt * 35 offen (6P+4M+5W+6+14)
ORT: unbekannt
SOLL/FIX: Die reale Tasks-Liste (user-sichtbares TODO) ist aus dieser Session nicht einsehbar -- 91/56 nicht verifizierbar; jeder der 56 'erledigt' braeuchte seinen Objektbeleg (Summe belegt keine Summanden).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Rechnung 6+4+5+6+14 = 35 [OK]

### [wtk6lmhln.json] 240
GEGENSTAND: WP-22 [GEGENSTANDSLOS] Scope-Entscheid (A)/(B)/(C) zur Selbstkompilation an F1 vorzulegen (offen)
ORT: unbekannt
SOLL/FIX: par.13.6-Zeile (Z.1514 'Scope-Entscheid, an F1 vorzulegen: 1') traegt keinen Marker -- erledigte Owner-Vorlage steht als offener F1-Posten im Plan.
STATUS LT. QUELLE: nur-hinweis (gegenstandslos/ueberholt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): par.14-Kopf (Z.1522-1530): Owner hat entschieden -- Variante B, (A)/(A+)/(C) gestrichen; Teil-B-Legende: 'par.13.4c (Variante B, Wellenplan:1521-1530)' als gefallenes Gate

### [wtk6lmhln.json] 241
GEGENSTAND: WP-23 [GEGENSTANDSLOS] S-1: heute fuenf lose Stempel-Strukturen, vier Namensschemata
ORT: stempel_basis.hpp
SOLL/FIX: par.14.2-S-1-Zeile unmarkiert; eine Neu-Zaehlung der Reststrukturen (sind alle fuenf angebunden?) wurde nicht einzeln erhoben -- als Abnahme-Posten der S-1-Strecke fuehren.
STATUS LT. QUELLE: nur-hinweis (gegenstandslos/ueberholt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): S-1 ist gelandet: stempel_basis.hpp + 9 produktive Trait-Anbindungen am Gitlink (KON56: '10 Trait-Anbindungen, Pins byte-unberuehrt') -- der 'fuenf lose'-Zustand beschreibt den Vor-S-1-Stand

### [wtk6lmhln.json] 242
GEGENSTAND: WP-25 [TEILWEISE] S-16: ci/tests/*.sh heute 14 Dateien / 8.528 Z., wachsend (Repo ungenannt)
ORT: 7d65eb6c
SOLL/FIX: Die Repo-Angabe fehlt weiterhin in Wellenplan UND Designplan D-3 (gleiche Zahl, gleiche Luecke); Zeilenzahl gedriftet 8.528->8.599 ('wachsend' bestaetigt); '0 retired' nicht gegengeprueft.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): super: ls ci/tests/*.sh = 14 Dateien, wc -l = 8.599 total; ce@7d65eb6c: 0 ci/tests-Dateien -- das Repo ist super (am Objekt bestimmt)

### [wtk6lmhln.json] 243
GEGENSTAND: WP-26 [TEILWEISE] O-3-Frage im Code (algo_semver:1527-1528) unbeantwortet; O-4: Organ-Meta-Meta-Liste leer
ORT: 7d65eb6c
SOLL/FIX: par.14.2-O-3/O-4-Zeilen unmarkiert ueberholt (O-3 per KON16-02 beantwortet: Freigabe impliziert, Compile fordert); die Organ-Liste selbst wurde nicht neu gezaehlt.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): algo_semver@7d65eb6c :1529-1535: '(m8) WAS DIESE WACHE AUSDRUECKLICH NICHT PRUEFT ... ist eine Sach-Frage, die keine der Quellen beantwortet' -- Frage-Stelle existiert (leicht gedriftet); O-4-Zustandskette am Ledger aufgeloest: par.16.1 'NICHT leer (Festplatten-IO = Organ-Meta-Meta)' + KON45-02 (Typ noetig, admit_organ_on_machine nur aus Tests = kein Produktionspfad) + KON47-03 (voll bauen)

### [wtk6lmhln.json] 244
GEGENSTAND: WP-28 [TEILWEISE] par.14.3 Regel 2 (P-0) und Regel 3 (Preimage-Menge) -- Marker-Lage
ORT: unbekannt
SOLL/FIX: Regel 3 bleibt unmarkiert falsch (par.15.4 korrigiert auf +S-3, die Stelle selbst zeigt es nicht) -- exakt wie in der Erhebung vermutet. Marker nachsetzen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Marker Z.1599 deckt Regel 2 ('Regel 2 (P-0) gilt in der par.15.5-Fassung: begleitend, nicht blockierend') [OK]; Regel 3 am Objekt: 'S-1, S-2, S-5, S-6, S-7' -- S-3 fehlt weiterhin, kein Marker

### [wtk6lmhln.json] 245
GEGENSTAND: WP-29 [TEILWEISE] Kipp-Punkte K-1 (Do 14.08., O-1+O-2) / K-2 (S-1..S-7 gruen) / K-3 (##47)
ORT: unbekannt
SOLL/FIX: K-1 ist als Kipp-Punkt ohne lebende Bedingung -- Stelle braucht Marker + Neufassung (z.B. an S-2-Start koppeln).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): K-1 am Objekt (Z.1694): Bedingung 'O-1 und O-2 sind entschieden' -- O-2 entfallen (par.15.1), O-1 beantwortet (par.16.1 'Grammatik EXISTIERT') -> Bedingung gegenstandslos; Datum 'Do 14.08.' unkorrigiert, kein Marker (par.15.7 korrigiert nur per Verweis); K-2: S-1 gelandet [OK], S-2..S-7 offen (Frist 21.08. laeuft); K-3: ##47 = Kalibrierlauf GN_TOTAL=64 (Z.702) identifiziert

### [wtk6lmhln.json] 246
GEGENSTAND: WP-31 [GEGENSTANDSLOS] ExperimentPlanDirector existiert, unangeschlossen im Submodul
ORT: profile_run_facade.cpp | apps/experiment_planner/main.cpp | 7d65eb6c
SOLL/FIX: par.14.7-Zeile steht unmarkiert neben der Korrektur (A.5 forderte dort keinen Marker -- die Leser-Falle bleibt).
STATUS LT. QUELLE: nur-hinweis (gegenstandslos/ueberholt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): git grep 'ExperimentPlanDirector' 7d65eb6c -- libs apps: profile_run_facade.cpp + .hpp + apps/experiment_planner/main.cpp konsumieren ihn -- 'unangeschlossen' ist am heutigen Gitlink widerlegt; par.15.5 traegt die Korrektur

### [wtk6lmhln.json] 247
GEGENSTAND: WP-32 [TEILWEISE] S-14-Wache existiert: 6/136 gedeckt, 0 unter axes/, verdrahtet ce yml :768-786
ORT: tools/axis_version_lock/axis_version.lock | 7d65eb6c
SOLL/FIX: Nenner 136 unreproduzierbar (eigene Zaehlung: 345 Header unter /axes/, 371 mit 'axes'; weitere kursierende 130/152/387/158) -- 'bump-pflichtig' hat keine schriftliche Definition; exakt die Grundgesamtheits-Klasse des 13.08.-Befunds.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Lock@7d65eb6c: 6 Datenzeilen, alle libs/cache_engine/heuristik/, 0 axes/ [OK]; CI-Verdrahtung: Job-Block um :763-799 (baut Tool, './build-axislock/...comdare_axis_version_lock --check tools/axis_version_lock/axis_version.lock') -- Anker minimal gedriftet, Sache [OK]

### [wtk6lmhln.json] 248
GEGENSTAND: WP-33 [TEILWEISE] B-2: GitLab-Nesting-Budget ausgeschoepft (super yml :2686-2688), keine 4. Ebene fuer Hybrid
ORT: unbekannt
SOLL/FIX: Ob B-2 nach KON16-03 ('keine YAML') + par.16.1-S-12-Neufassung (Bau-Modul emittiert BESCHREIBUNG, Prozesse im BuildOrchestrator) gegenstandslos ist, bleibt unmarkiert offen -- vor S-12-Bau entscheiden.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): sed -n '2680,2695p': Kommentar bei ~2686-2689 traegt 'parent->child->grandchild = GitLab-Nesting-Tiefe 2' -- Anker trifft; die Hybrid-Folge ist im Text als 'Ableitung des Explores, kein Quellensatz' gekennzeichnet

### [wtk6lmhln.json] 249
GEGENSTAND: WP-34 [TEILWEISE] B-4: comdare-buildsystem 0 Treffer in ce/libs+apps; Env-Variablen nie angelegt; Ledger-Widerspruch :18698
ORT: artifact_cache.hpp | REPOS_OVERVIEW.md | 7d65eb6c
SOLL/FIX: 'Env-Variablen nie angelegt' unpruefbar ohne die Namensliste aus dem TWO-CACHE-STORAGE-Bauplan (18.07., nicht gelesen); Ledger-Anker :18698 gedriftet (Datei 26.395 Z.) -- ueber Datum/KON neu schneiden; ob O-9-Antwort (par.15.8) B-4 schliesst, ist unmarkiert.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): git grep 'comdare-buildsystem' 7d65eb6c -- libs apps = 0 Dateien; Gegenprobe 'buildsystem' beisst (artifact_cache.hpp + REPOS_OVERVIEW.md) -- Nullbefund mit beissender Gegenprobe bestaetigt

### [wtk6lmhln.json] 250
GEGENSTAND: WP-36 [TEILWEISE] Nichtfund der frueheren Owner-Aussage zur Mini-Pipeline-Pflicht (Gegenprobe ueber 19 .jsonl)
ORT: unbekannt
SOLL/FIX: Das Gegenprobe-PROTOKOLL (welcher Koeder biss, mit welcher Regel) ist nicht dokumentiert; die 19 .jsonl sind gegen die heutige Transkriptmenge nicht abgeglichen; Extraktor-UNION-Regel (promptSource+queued_command+queue-operation) nicht nachweisbar angewendet.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): par.14.7 dokumentiert Nichtfund + Gegenprobe-Behauptung und zieht die korrekte Konsequenz ('der Satz vom 11.08. ist die massgebliche und einzige Quelle')

### [wtk6lmhln.json] 251
GEGENSTAND: WP-37 [TEILWEISE] CI-Zahlen: super 2768/45/11/1 * ce 1056/25/6/2 * keine Traeger-Stufen * 4 trigger * Hybrid 0/0
ORT: 7d65eb6c
SOLL/FIX: ce-Zeilenzahl gedriftet: heute 1094 statt 1056 (Datei gewachsen seit 11.08.) -- bei Zitat neu zaehlen; Job-Zaehlweise bleibt unbenannt (vgl. REF-06 '38/41').
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Neu erhoben: super 2768 Z. [OK], stages = 11 [OK] (Liste Z.25-38), Top-Level-Keys 50 (~45 Jobs nach Abzug ~5 Struktur-Keys) [OK], echte trigger: = 4 (Z.1257/1275/1293/2720) [OK], ceb/tier/hybrid/release = 0 [OK], hybrid case-insensitive super 0 / ce 0 [OK]; ce@7d65eb6c: 30 Keys (~25 Jobs) [OK]

### [wtk6lmhln.json] 252
GEGENSTAND: WP-38 [TEILWEISE] Sieben Owner-Zusagen S1..S7, 0 von 4 Traegern erfuellt = Umfang S-12
ORT: unbekannt
SOLL/FIX: Die sieben Zusagen sind NIRGENDS einzeln aufgelistet -- der Zaehler-Gegenstand fehlt; vor S-12-Bau die S1..S7 aus dem 11.08.-Transkript extrahieren und fixieren.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Die 0/4-Traegerseite ist objektiv bestaetigt (keine Traeger-Jobs/-Stufen/-Trigger, s. STR-17/WP-37); par.14.7 selbst: 'Der Satz vom 11.08. ist die massgebliche und einzige Quelle fuer S1...S7'

### [wtk6lmhln.json] 253
GEGENSTAND: WP-39 [NICHT_ERLEDIGT] O-2 ENTFAELLT -- an sechs benannten Stellen zu streichen
ORT: unbekannt
SOLL/FIX: par.15.1 dokumentiert nur den AUFTRAG ('Betroffene Stellen, an denen O-2 zu streichen ist') -- der Vollzug an den Stellen selbst fehlt vollstaendig. Nachimplementierung: sechs Marker setzen.
STATUS LT. QUELLE: offen (Behauptung faellt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Alle sechs Stellen am Objekt UNVERAENDERT ohne Streich-/Markervermerk: par.14.2-Blocker-Zeile (O-2 blockiert S-2), Graph-Kante O-2->S-2 (Pfeilkette), Regel 1 ('ohne O-1 und O-2'), par.14.4-W0b-Zeile ('O-1...O-5'), WE-Zeile ('setzt O-1/O-2 voraus'), K-1 (Z.1694)

### [wtk6lmhln.json] 254
GEGENSTAND: WP-44 [TEILWEISE] 'Do 14.08.' -> Fr korrigiert; alle 30+ Datum-Paare nachgerechnet
ORT: unbekannt
SOLL/FIX: Die Korrektur lebt nur als par.15.7-Verweis; die Zusicherung 'alle 30+ Paare nachgerechnet' wurde nicht selbst nachvollzogen (nicht erhoben).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): par.15.7 existiert und benennt die Korrektur; 14.08.2026 = Freitag [OK] (heute Do 13.08.); AM OBJEKT stehen beide Stellen weiter unkorrigiert: par.14.4 'Frist Do 14.08.' + par.14.5 K-1 'Do 14.08.' -- ohne Marker an den Stellen

### [wtk6lmhln.json] 255
GEGENSTAND: WP-45 [TEILWEISE] Drei Cache-Ziele, je zwei Backends, alle per XML separat konfigurierbar
ORT: Code/test_data_xml/experiment_schema.xsd | messreihe_v32_schema.xsd | 7d65eb6c
SOLL/FIX: Drei GETRENNTE XML-Konfigurationspunkte existieren noch nicht (S-13 ist W2-Posten '#18/S-13 Export+Filter+COMDARE_STORAGE_CACHE') -- die Behauptung ist SOLL-Festlegung, kein Ist; das Memory-'XSD-Enum traegt die Semantik bereits' war fuer den ce-Baum nicht verifizierbar.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): par.15.8-Festlegung steht (O-9 beantwortet, KON13-04/KON15-05); am Objekt existiert die Traeger-Mechanik teilweise: COMDARE_STORAGE_CACHE-Aktivierung im Director (:882-1127, emit_storage_activation); XSDs nur super-seitig (Code/test_data_xml/experiment_schema.xsd + messreihe_v32_schema.xsd), ce@7d65eb6c: 0 XSD

### [wtk6lmhln.json] 256
GEGENSTAND: WP-46 [TEILWEISE] '7 von 130' keine Deckungsquote: 6 Traeger unter heuristik/, 130 axes/-Header, Schnittmenge 0
ORT: csv_cell_reader.hpp | 7d65eb6c
SOLL/FIX: 'saemtlich unter heuristik/' ist ueberholt (7. Traeger ausserhalb); der Nenner 130 ist auf 345/371 gewandert -- Kernaussage (keine Deckungsquote) haelt, beide Zahlen sind zu aktualisieren; die S-18-Definitionsluecke ('bump-pflichtig') besteht fort.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): git grep -l 'AXIS_ALGO_VERSION' 7d65eb6c -- libs = 7 Dateien: 6 unter heuristik/ + csv_cell_reader.hpp (include/cache_engine/measurement/) -- Schnittmenge mit axes/ weiterhin 0 [OK]; axes-Header heute: 345 (/axes/-Pfad, .hpp)

### [wtk6lmhln.json] 257
GEGENSTAND: WP-47 [TEILWEISE] 14 von 17 Bau-Teilen nie gegen den Code gemessen; kein Aufwand fuer S-1..S-18
ORT: unbekannt
SOLL/FIX: Die '14 von 17 (nur P-0, S-14, S-17)' ist inzwischen ueberholt: seit 11.08. sind mindestens S-1 (gebaut+gemessen KON56/57), S-3-Vorbild, Hybrid-Stempel (KON45-01) und Festplatten-IO (KON45-02) am Objekt vermessen -- Zaehler veraltet; 'Termine unveraendert' bleibt weiter ohne Aufwands-Beleg.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Aufwands-Luecke bestaetigt: Designplan D-4 ('S-6, S-13, S-14, S-17...S-21 fehlen im 117er-Katalog') + Summen-Regel; keine Aufwandszahlen je S-Posten in Wellenplan/Designplan gefunden; Sessions 13.08. leer

### [wtk6lmhln.json] 258
GEGENSTAND: WP-49 [TEILWEISE] O-3 beantwortet je Seite; beide Seiten gebaut und heute leer/inert => S-3/S-7 = Aktivierungs-Auftraege
ORT: bvset_teilmenge.hpp | build_orchestrator.hpp
SOLL/FIX: Die Konjunktion 'gebaut+inert' ist nicht doppelt belegt: bvset_ist_teilmenge hat 1 Produktions-Konsumenten (build_orchestrator.hpp, 2 Treffer) -- die Freigabe-/Compile-SEITEN sind nicht einzeln mit je zwei Messungen (existiert + 0 Eintraege/Aufrufer) ausgewiesen. Vor der S-3-Aktivierung (morgen) beide Seiten benennen und je zwei Zahlen erheben.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Existenz: bvset_teilmenge.hpp (187 Z.) + Andockstelle + Tests [OK]

### [wtk6lmhln.json] 259
GEGENSTAND: WP-50 [TEILWEISE] S-6 entsperrt: drei Aussen-Ebenen (Makro/POD/Preimage), Layout-Bump-Konflikt, drei Verbotszonen
ORT: decl.hpp
SOLL/FIX: Die drei Aussen-Ebenen-Orte (Makro-Definition/POD-Struktur/Preimage-Erzeugung) und die drei Verbotszonen wurden nicht einzeln lokalisiert (nicht erhoben) -- vor dem S-6-Fenster (Mo 17.) als Explore-Pflicht fuehren.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Layout-Verbot am Objekt [OK] (decl.hpp ==6 + Probe-7u-Assert); kein S-6-Bau am Objekt gesichtet -- konsistent mit Memory-Sperre ('an S-6 wird NICHTS gebaut bis Explore')

### [wtk6lmhln.json] 260
GEGENSTAND: WP-53 [GEGENSTANDSLOS] ##25 ohne Besitzer + ce-Pipeline rot (Stand 12.08. mittags) vor jeder ce-Landung
ORT: 671d7f6a | 7d65eb6c
SOLL/FIX: Fuer den HEUTIGEN Gitlink 7d65eb6c existiert kein Pipeline-Terminal-Beleg im Ledger (KON57-05 fuehrt den Monitor als offenen Schritt) -- gruen fuer 671d7f6a ist ein anderer Gegenstand; Neuerhebung faellig.
STATUS LT. QUELLE: nur-hinweis (gegenstandslos/ueberholt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Beide Zustaende am Objekt ueberholt: Besitzer per WF9 (KON40-01), Landung+CI-Beweis (KON56-01/KON57-01: 15764, 35/35, Job 376333); ce 15759 SUCCESS @671d7f6a (KON56)

### [wtk6lmhln.json] 261
GEGENSTAND: WP-54 [TEILWEISE] S-14/S-18 Build-Blocker per 'WF3 Z. 34976'
ORT: unbekannt
SOLL/FIX: Ein TECHNISCHER Bruch ohne S-14/S-18 existiert heute nicht (Wache deckt nur 6 Dateien) -- der Blocker ist Owner-Gate, nicht Compile-Gate; bei Zitat den Anker als Transkript-Zeile fuehren.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Der Anker ist eine TRANSKRIPT-Zeile (KON22-Muster '(Z. 35912)'), keine Ledger-Zeile (Ledger nur 26.395 Z.); die Sache existiert im Ledger: KON22-03 Vollbau-Gate 'Wir bauen, wenn Lagerhaltung fertig und Stempel fertig und ALGORITHMEN VERSIONIERT und Messung einbaubar' (Z. 35912) -- daraus folgt der Blocker-Charakter

### [wtk6lmhln.json] 262
GEGENSTAND: WP-56 [TEILWEISE] par.17.1-OFFEN-Liste (12.08. abends): R-2 * R-3 * OF-1 * OF-2 * OF-3 * OF-4 * A-1 * E-WARMUP * TEST-KONSOLIDIERUNG * T-3-Ripple
ORT: unbekannt
SOLL/FIX: Die OFFEN-Tabelle traegt keine Nachtrags-Marker (anders als Teil-C-OF-2); weiter offen sind: R-2-Vorschlag (S-6-Fenster), A-1-Vorlagetext, TEST-KONSOLIDIERUNG-Eigentuemer, T-3-Ripple-Posten -- Klasse 'Bericht statt Objekt' fuer die 5 ueberholten Zeilen bestaetigt.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Am Landetag ueberholt: OF-1 (KON40-02 + KON41-02 'Ja korrekt.'), OF-2 (KON41-03/KON42 'Offene Owner-Fragen: NULL'), OF-3 (KON41-04/45-01/47-02), OF-4 (KON45-02/47-03), E-WARMUP (KON45-03 'Explore FERTIG' + KON47-04 Paar-Regel) -- 5 von 10 Zeilen waren binnen Stunden beantwortet

### [wtk6lmhln.json] 263
GEGENSTAND: WP-58 [TEILWEISE] System A #ifdef via mess_achsen_naht * System B 17 Dateien * B3 vor F2 (Owner-Datum), B1/B2/B4/B5 Ableitung
ORT: abi_adapter.hpp | mess_achsen_naht.hpp | 7d65eb6c
SOLL/FIX: B3 traegt in Teil B ZWEI Termine (Posten 24: Mo 17.-Mi 19. / Posten 34: 'B3 landet' Do 20./Fr 21.) -- lesbar als Bau->Landung, aber nirgends ausgewiesen; vor W1 klaeren, welcher der Owner-Termin ist.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): abi_adapter.hpp@7d65eb6c: 7 #ifdef [OK]; mess_achsen_naht.hpp existiert (profile_facade/, traegt den Pflicht-Wurf :304) [OK]; 17-Liste per KON40-02 + Objekt-Stichprobe mess/=6 exakt [OK]

### [wtk6lmhln.json] 264
GEGENSTAND: WP-59 [NICHT_ERLEDIGT] Fussnote an par.2-D4-Zeile und par.7 (T-15b-Praezisierung)
ORT: unbekannt
SOLL/FIX: Der par.17.4-/A.5-Auftrag ('par.2-D4-Zeile und par.7 bleiben stehen, Fussnote dort') ist an keiner der Stellen vollzogen. Nachimplementierung: T-15b-Fussnoten setzen.
STATUS LT. QUELLE: offen (Behauptung faellt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): sed par.2-D4 (Z.607-621): keine Fussnote, kein Marker; par.7-T-15/D4-Zeile (Z.941): kein Marker (der par.7-Marker Z.955 betrifft die checkpoint_measure-Zeile); par.12er-T-15-Stelle (Z.837) ebenfalls ohne

### [wtk6lmhln.json] 265
GEGENSTAND: WP-60 [TEILWEISE] Kapazitaet prod1 20,7 h / prod2 34,4 h; Luecken window_belongs_to + Messung nicht zweilanig
ORT: runner-mode.sh:43
SOLL/FIX: Kapazitaetszahlen auf strittigem Kernwert nicht belastbar, solange HEAVY_J-Posten (STR-09) offen; window_belongs_to hat einen internen Aufrufer + Tests -- 'unverdrahtet' nur fuer den Pfad darueber haltbar (praezisieren).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Zahlen nur ledger-seitig (KON29-04), Herkunfts-Lauf unbenannt; Kernzahl-Konflikt am Objekt REAL: runner-mode.sh:43 prod1 HEAVY_J=24 vs. OD-7-Deckel 16 (KON28-01) vs. Memory 'prod1 = 16 Kerne/32 Threads' -- unaufgeloest

### [wtk6lmhln.json] 266
GEGENSTAND: WP-62 [TEILWEISE] Marker an par.7, par.8/OV-2, par.8/OV-10, par.8/OV-13, par.16.1/O-5
ORT: unbekannt
SOLL/FIX: NICHT gesetzt: par.8/OV-2-Zeile (Z.977 'Bleibt es bei spezifiziert, nicht gebaut (W7)? ja' -- unmarkiert, obwohl per KON34/par.17.3 ueberholt) und par.16.1/O-5 (Z.1950 -- Zeitbezug-Korrektur nur in par.17.5, nicht an der Stelle). Zwei Marker nachsetzen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Gesetzt: par.7 (Z.955, checkpoint-Zeile UEBERHOLT->B4) [OK]; par.8 OV-10+OV-13 gemeinsam (Z.981, PRAEZISIERT/KORRIGIERT) [OK]

### [wtk6lmhln.json] 267
GEGENSTAND: DP-03 [TEILWEISE] 29/17 ist die MT-L3-tragende Zahl (zwei Werkzeuge, beide 29/17)
ORT: 25fe4fbf
SOLL/FIX: par.9.1 traegt keinen Stale-Hinweis an der 29/17-Stelle -- welcher Satz gilt, sagt nur der PZW-Block; Leser von par.9.1 allein liest veraltete Zahlen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): 29/17 galt am Baum 25fe4fbf; am heutigen Gitlink liefert dieselbe Zaehlweise 40/21 (Wache-Lauf: 'Plan sagt 40, Objekt liefert 40 ... 21') -- par.9.5/PZW nachgezogen, par.9.1 selbst unveraendert

### [wtk6lmhln.json] 268
GEGENSTAND: DP-04 [TEILWEISE] LITERAL-Zaehler = 1 (test_lazy_resume_binary.cpp:238, Resume-Koeder); 0 von 29 Orakel
ORT: unbekannt
SOLL/FIX: Die ZWEITE Literal-Stelle ist nicht namentlich bestimmt worden (welcher Traeger, Orakel oder Koeder?) und MT-L3 ist nicht gelandet -- die Prognose ('steigt, sobald MT-L3 einfriert') bleibt unbestaetigt. Zweiten Traeger per git grep benennen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Heute: SCHEMA-LITERAL = 2 (Wache-Lauf, Plan=Objekt=2) -- par.9.5 hat nachgezogen

### [wtk6lmhln.json] 269
GEGENSTAND: DP-07 [TEILWEISE] SOLL-Scanner-Blindheit fuer mehrzeiliges add_test( -- behoben (277->280)?
ORT: 1f88cfec | 7d65eb6c
SOLL/FIX: Der Live-Koeder (mehrzeilige add_test-Registrierung im Wegwerf-Verzeichnis -> erscheint sie im SOLL?) wurde nicht gefahren -- die Behebung ist dokumentiert, nicht am Biss bewiesen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Fix-Commit 1f88cfec existiert; Wache@7d65eb6c dokumentiert Erfassung von add_test(NAME...)/gtest_discover_tests/comdare_add_test inkl. Variablen-Formen in foreach (:79-83) und Hausfunktions-Rumpf (:125-128)

### [wtk6lmhln.json] 270
GEGENSTAND: DP-09 [GEGENSTANDSLOS] D3-1-Marker-Haelfte OFFEN: modus=voll/provision_only 0-mal, haengt an D3-7, Stationen uebergeben '1'
ORT: mess_ausbeute_wache.sh | frische_wache.sh
SOLL/FIX: Der Wellenplan fuehrt den Posten weiter als W0b-Rest (unmarkiert) -- Erledigt-Nachtrag setzen.
STATUS LT. QUELLE: nur-hinweis (gegenstandslos/ueberholt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Die Nullbefunde sind am heutigen Objekt widerlegt: mess_ausbeute_wache.sh-Allowlist 'voll | provision_only | pruef_only | prune_only | auto' (D3-7b-Kommentar), frische_wache.sh mit modus=voll-Logik (:79-82, :227, :257), yml:639 'aus ihm zieht ... ihren Modus'; Stationen rufen 'measure_out_smoke 1 auto' (:1954) / 'measure_out 1 auto' (:2134) -- D3-7-Lauf-Marker ist gelandet, die Marker-Haelfte gebaut

### [wtk6lmhln.json] 271
GEGENSTAND: DP-12 [TEILWEISE] 5 echte Vorkommen in der Bissprobe; /usr/bin/grep = GNU grep 3.11 liefert die richtige Zahl
ORT: ci/tests/mess_ausbeute_bissprobe.sh
SOLL/FIX: Die Zahl ist 6 statt 5 (Datei gewachsen) -- bei Zitat neu erheben; die Z.44-Gegenzuschreibung in der Datei nicht gelesen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): /usr/bin/grep -cF 'test -n "$(find' ci/tests/mess_ausbeute_bissprobe.sh = 6 (heute); GNU-Zuschreibung in der PZW-Wache kodifiziert ('gemessen wird ausdruecklich mit /usr/bin/grep, GNU grep 3.11') und von mir benutzt

### [wtk6lmhln.json] 272
GEGENSTAND: DP-15 [TEILWEISE] Merge 7d65eb6c: 13 Dateien / +344 / ?116; Kombibau 4x485/485
ORT: 7d65eb6c | 84e6099a | 6f537245
SOLL/FIX: Der 4x485/485-Kombibau gilt fuer 84e6099a (KON57-03); der finale Anlauf ueber 6f537245 'LAEUFT bei Abfassung' -- ein dokumentierter Abschluss-Beleg fuer den GELANDETEN Merge-Stand fehlt im Ledger (letzter Nachtrag); bleibt Agentenbericht bis zur Reproduktion (Bau im read-only-Auftrag nicht zulaessig).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): git show --stat 7d65eb6c | tail: '13 files changed, 344 insertions(+), 116 deletions(-)' -- EXAKT [OK]

### [wtk6lmhln.json] 273
GEGENSTAND: DP-17 [TEILWEISE] test_s1_stempel_basis_vertrag.cpp existiert; prueft er den VERTRAG?
ORT: unbekannt
SOLL/FIX: Der Testinhalt wurde nicht selbst gelesen -- die Vertrags-Eigenschaft stuetzt sich auf das Ledger-Mutationsprotokoll, nicht auf eigene Lektuere.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Datei am Gitlink [OK] (im Haertungs-Merge +66 Z.); Vertrags-Indizien stark: KON56 '28er-Matrix dreiwertig, StempelVertrag deferred-consteval', KON57-03 Mutations-Protokoll (M-F1 3x static assertion failed, M-F2b Hex-Probe beisst, M-F3 :246 reisst, M-H10 :507 reisst -- je ROT gesehen + Gegenprobe)

### [wtk6lmhln.json] 274
GEGENSTAND: DP-18 [TEILWEISE] Vier Wachen-Ausloesungen (15428/369258 * 15463/369917 * 15615/373214 * 15706/374843)
ORT: unbekannt
SOLL/FIX: Die vier historischen Pipeline-/Job-Nummern haben 0 Treffer in Ledger UND docs/sessions -- einzige Quelle ist der Designplan selbst; als CI-Zustaende nicht pollbar (Hausregel). Fundstellen ausserhalb des behauptenden Dokuments fehlen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Mechanismus-Biss selbst bewiesen: Plan-Kopie im tmp, Anker 40->41 verfaelscht -> rc=1, woertlich 'ROT SCHEMA-STELLEN: Plan sagt 41, Objekt liefert 40 ... FEHLER: 1 von 5' (fuenfter Biss); SHA-Gate-Wortlaut im Code (Z.172: 'der Plan nennt einen ANDEREN ce-Zustand als super HEAD fuehrt') [OK]; KON56 bestaetigt den fuenften Zug + 'PZW-Wache lokal 5 von 5'

### [wtk6lmhln.json] 275
GEGENSTAND: DP-21 [TEILWEISE] Innere Konsistenz: 53+59+5=117, 206+166,5+13=385,5, Klassenlisten 29/25/23/16/10/9/3+2=117
ORT: unbekannt
SOLL/FIX: Die sieben par.2-Klassenlisten wurden nicht neu am Dokument durchgezaehlt (nur par.9.6s eigene Zaehlung uebernommen); '117/386 h' in par.10/Teil A rundet 385,5 ohne Offenlegung -- die vierte Zahl wandert bereits (Teil A C: '386').
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Alle drei Rechnungen nachgerechnet: 117 [OK], 385,5 [OK], 115+2=117 [OK]

### [wtk6lmhln.json] 276
GEGENSTAND: DP-22 [TEILWEISE] 157/117/40 aus par.0 nicht nachgezaehlt (Meta-Stufen-Aussage)
ORT: unbekannt
SOLL/FIX: Per Owner-Dauerregel 13.08. ist die Luecke ein AUFTRAG: Herkunft und Zaehlweise der 157/117/40 sind weiterhin unbestimmt, kein Behebungs-Task auffindbar -- vor Weiterzitieren (der Auftragstext dieses Reviews zitiert sie bereits) bestimmen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): par.9.6 deklariert die Luecke woertlich [OK] -- die Deklaration ist korrekt

### [wtk6lmhln.json] 277
GEGENSTAND: DP-23 [TEILWEISE] D-1: Hybrid-Bilanz (dreifache Fundstelle); der HY-Vertrag PINNT kGenusCount
ORT: klassifikation.hpp | genus_build_admission.hpp:171
SOLL/FIX: Das Symbol kGenusCount existiert NICHT im Baum (git grep = 0) -- die Pin-SACHE ja, der benannte Bezeichner nein; bei Zitat das reale Symbol nennen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Bilanz selbst nachgemessen (943 Z. exakt, Genus sechswertig) -- dreifach abgeschrieben, EINE Messung: bestaetigt; CT-Pins existieren: klassifikation.hpp static_asserts :146/:151/:177-178 (gattungs_liste_ist_vollstaendig / genus_liste_ist_vollstaendig / alle_benannt) + genus_build_admission.hpp:171 'kGenusBuildSlotCounts.size() == 5'

### [wtk6lmhln.json] 278
GEGENSTAND: DP-24 [TEILWEISE] D-2: #87/#78/#86/KON9-05/HY-A fallen NIE; Band B/W1 gestrichen; par.8-Bedingung (2) entschieden
ORT: unbekannt
SOLL/FIX: Designplan-par.8-Bedingung (2) im Wortlaut nicht gelesen (ausserhalb Erhebungs-Scope) -- ob das Genannte sie wirklich entscheidet, unverifiziert; der heutige Bau-Stand je [P]-Posten (#87/#78/#86/HY-A) nicht einzeln erhoben (W1-Posten, kuenftig).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): D-2-Marker an par.8 gesetzt (Z.124) [OK]; Band-B-Streichung dreifach konsistent (Z.1239/1394/1660 + D-2)

### [wtk6lmhln.json] 279
GEGENSTAND: DP-25 [TEILWEISE] D-3: 14 Dateien/8.528 Z., 0 retired; Anker par.9.5 (Z.338)
ORT: plan_zahlen_probe.sh
SOLL/FIX: Repo-Angabe fehlt weiter in beiden Plaenen; '0 retired' ohne Gegenpruefung (kein GTest-Abloese-Beleg gesucht); Z.338-Anker im gelandeten D-3-Text bereits stale.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): super ci/tests: 14 Dateien [OK] / 8.599 Z. heute; ce@Gitlink: 0 ci/tests -> Repo=super am Objekt bestimmt; Anker-Drift bestaetigt: plan_zahlen_probe.sh steht heute Designplan Z.389, nicht Z.338 -- Drift im SELBEN Dokument

### [wtk6lmhln.json] 280
GEGENSTAND: DP-26 [TEILWEISE] D-4: S-6, S-13, S-14, S-17..S-21 fehlen im 117er-Katalog (gezaehlte Warteliste)
ORT: unbekannt
SOLL/FIX: Die geforderte Gegenprobe (grep mit alternativen Schreibweisen S6/S 6/S-06 ueber par.2/par.4) wurde nicht gefahren -- der Nichtfund im Katalog stuetzt sich auf die D-4-Eigenaussage.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): D-4 als Marker an par.4-Warteliste (Z.118) gesetzt [OK]; par.10-D-4-Text zaehlt die neun Posten; Aufwands-Katalog traegt keine S-Posten (Summen-Regel haelt)

### [wtk6lmhln.json] 281
GEGENSTAND: DP-27 [TEILWEISE] D-5: 8 von 9 thesis_profiles xlsx-blind (Kampagnen-Blocker)
ORT: .profile.xml | 7d65eb6c
SOLL/FIX: Nenner-Drift 9->11(12); je-Profil-xlsx-Pfad-Pruefung nicht gefahren; der Blocker-Charakter (xlsx = DIE Ausgabe) bleibt -- vor W3: Profile neu zaehlen + je Profil xlsx-Writer-Anschluss messen; [D-5]-Marker an par.2/K7 fehlt zudem (s. REF-14).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Nenner am Objekt: ls-tree@7d65eb6c thesis_profiles/ = 11 *.profile.xml + super f1_durchstich = 12 -- die 9 ist heute nicht reproduzierbar (Profile seit KON36-Zaehlung dazugekommen)

### [wtk6lmhln.json] 282
GEGENSTAND: DP-28 [TEILWEISE] D-6: CI faehrt PMC ohne Vendor (WARNING); MT-L11 misst nur Injektion
ORT: unbekannt
SOLL/FIX: MT-L11-Inhalt nicht gelesen (Injektion vs. Vertragsfolge unverifiziert); der fehlende CEB->Tier-CT-Vertragsposten besteht fort (kein Task gesichtet); P-/E-Core-Trennung in CI nicht geprueft.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Vendor-genaue PMC-Jobs existieren inzwischen: KON56 nennt 'pmc:intel' als eigenstaendigen ce-CI-Job (transienter prod2-perf-Rot, Retry gruen) -- die 'ohne Vendor'-Lage von KON34-02 ist mindestens teilueberholt

### [wtk6lmhln.json] 283
GEGENSTAND: DP-30 [TEILWEISE] par.10 = genau sechs Differenzen D-1..D-6 gegen KON15-KON38
ORT: unbekannt
SOLL/FIX: Mindestens zwei TESTRELEVANTE Neuerungen nach KON38 sind im Designplan nicht erfasst: KON47-04 (Warmup-PAAR-Regel 'MUSS GETESTET SEIN' -- Test-Posten Paar-Zaehlung 2x3, --debug-Zweig, Verwerf-Beweis) und KON55 (clang+gcc Basis-Pflicht, 2x2-Matrix); dazu KON57-Mutations-Protokollklasse. Nachimplementierung: par.11-Nachtrag KON39-KON57 nach par.9-Muster.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): par.10 endet planmaessig bei KON38 (Statuszeile [OK]); der Ledger steht bei KON57

### [wtk6lmhln.json] 284
GEGENSTAND: V[2]-nicht_pruefbar[0]: Die Tasks-Liste (user-sichtbares TODO): aus dieser Session nicht einsehbar -- betrifft WP-21 (91/56/35-Bilanz), W7-01/STR-01-Eigentuemer-Namen und alle #-Nummern-Aufloesungen; nur L
ORT: unbekannt
SOLL/FIX: Die Tasks-Liste (user-sichtbares TODO): aus dieser Session nicht einsehbar -- betrifft WP-21 (91/56/35-Bilanz), W7-01/STR-01-Eigentuemer-Namen und alle #-Nummern-Aufloesungen; nur Ledger-Task-Vermerke (KON40-04, KON57-01) standen zur Verfuegung.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 285
GEGENSTAND: V[2]-nicht_pruefbar[1]: CI-Zustaende: keine Pipeline gepollt (Hausregel; Pipelines nie canceln) -- der ce-Pipeline-Zustand fuer den HEUTIGEN Gitlink 7d65eb6c ist im Ledger nicht terminal belegt (KON57-05 f
ORT: 7d65eb6c
SOLL/FIX: CI-Zustaende: keine Pipeline gepollt (Hausregel; Pipelines nie canceln) -- der ce-Pipeline-Zustand fuer den HEUTIGEN Gitlink 7d65eb6c ist im Ledger nicht terminal belegt (KON57-05 fuehrt den Monitor als offenen Schritt); die historischen Job-Nummern 15428/369258, 15463/369917, 15615/373214, 15706/374843 haben 0 Treffer in Ledger und docs/sessions -- einzige Quelle ist der Designplan selbst (DP-18).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 286
GEGENSTAND: V[2]-nicht_pruefbar[2]: REF-15s '22 eingearbeitete Review-Fixes': existieren nirgends als Liste in docs/ -- laegen nur im Workflow-Backup (nicht durchsucht).
ORT: unbekannt
SOLL/FIX: REF-15s '22 eingearbeitete Review-Fixes': existieren nirgends als Liste in docs/ -- laegen nur im Workflow-Backup (nicht durchsucht).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 287
GEGENSTAND: V[2]-nicht_pruefbar[3]: REF-01s '1802 Z
ORT: unbekannt
SOLL/FIX: REF-01s '1802 Z. Vorarbeit': ohne Ortsangabe nicht zaehlbar (Ledger-Anker :10813 gedriftet; KON9-02-Block nicht bis zur Ortsangabe verfolgt).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 288
GEGENSTAND: V[2]-nicht_pruefbar[4]: WP-38s sieben Owner-Zusagen S1..S7: laut Wellenplan par.14.7 existiert nur der Owner-Satz vom 11.08
ORT: unbekannt
SOLL/FIX: WP-38s sieben Owner-Zusagen S1..S7: laut Wellenplan par.14.7 existiert nur der Owner-Satz vom 11.08. als Quelle -- Roh-Transkript nicht geoeffnet.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 289
GEGENSTAND: V[2]-nicht_pruefbar[5]: Alle Zahlen, die einen gebauten Baum brauchen (4x485/485-Kombibau ueber 6f537245, ctest-Zustaende 429/431/456/460, Debug/Release-Matrix): kein Bau, kein Configure, kein ctest gefah
ORT: 6f537245
SOLL/FIX: Alle Zahlen, die einen gebauten Baum brauchen (4x485/485-Kombibau ueber 6f537245, ctest-Zustaende 429/431/456/460, Debug/Release-Matrix): kein Bau, kein Configure, kein ctest gefahren (read-only-Auftrag).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 290
GEGENSTAND: V[2]-nicht_pruefbar[6]: /home/comdare/wt-ce-golden-s14a: auftragsgemaess nicht betreten -- der dortige S-14a-/golden-Tagesstand nur von aussen ueber Branch-Log bau/golden-s14a-riegel erhoben (b12afd32 u.a.
ORT: bau/golden-s14a-riegel | b12afd32
SOLL/FIX: /home/comdare/wt-ce-golden-s14a: auftragsgemaess nicht betreten -- der dortige S-14a-/golden-Tagesstand nur von aussen ueber Branch-Log bau/golden-s14a-riegel erhoben (b12afd32 u.a.).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 291
GEGENSTAND: V[2]-nicht_pruefbar[7]: WP-34s Env-Variablen-Liste: der TWO-CACHE-STORAGE-Bauplan (18.07.) wurde nicht gelesen -- 'nie angelegt' bleibt ohne Namensliste unpruefbar.
ORT: unbekannt
SOLL/FIX: WP-34s Env-Variablen-Liste: der TWO-CACHE-STORAGE-Bauplan (18.07.) wurde nicht gelesen -- 'nie angelegt' bleibt ohne Namensliste unpruefbar.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 292
GEGENSTAND: V[2]-nicht_pruefbar[8]: DP-24s Designplan-par.8-Bedingung (2): Wortlaut nicht gelesen (ausserhalb des par.9/par.10-Scopes der Erhebung; Zeitbudget).
ORT: unbekannt
SOLL/FIX: DP-24s Designplan-par.8-Bedingung (2): Wortlaut nicht gelesen (ausserhalb des par.9/par.10-Scopes der Erhebung; Zeitbudget).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 293
GEGENSTAND: V[2]-nicht_pruefbar[9]: DP-12s Z.44-Werkzeug-Zuschreibung in der Bissprobe selbst: nicht gelesen (nur die PZW-Wachen-Zuschreibung GNU grep 3.11 verifiziert und benutzt).
ORT: unbekannt
SOLL/FIX: DP-12s Z.44-Werkzeug-Zuschreibung in der Bissprobe selbst: nicht gelesen (nur die PZW-Wachen-Zuschreibung GNU grep 3.11 verifiziert und benutzt).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 294
GEGENSTAND: N9-06 [ERLEDIGT] T-1-Mutations-Protokoll 4/4 + Kombibau 4x485/485
ORT: test_s1_stempel_basis_vertrag.cpp:150 | 84e6099a | 6f537245
SOLL/FIX: -
STATUS LT. QUELLE: behoben lt. Quelle, mit Restzweifel
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Vier Mutations-Logs 12.08. 20:37-20:38 (mut-f2/f2b/f3/h10.log) mit Fehlern an EXAKT test_s1_stempel_basis_vertrag.cpp:150/:175/:246/:507; vier fixup-kombibau-*-ctest.log (20:53-21:03) je '100% tests passed, 0 tests failed out of 485' (gcc/clang x debug/release). Einschraenkung: nur EIN Log-Satz -- die Zuordnung 84e6099a vs. 6f537245 ist nicht mehr trennbar (Logs ueberschrieben), Endstand CI-gedeckt (15770 success)

### [wtk6lmhln.json] 295
GEGENSTAND: N9-11 [TEILWEISE] fixup-s1-haertung nach KON49-02-Loeschregel entfernt (Tips einzeln gegen Remote geprueft)
ORT: bau/s1-codex-haertung | 84e6099a | 6f537245 | 7d65eb6c
SOLL/FIX: Ein PROTOKOLL der zugesagten Einzelpruefung 'jeder Branch-Tip gegen den echten Remote im HAUPT-Klon' existiert nirgends auffindbar -- die Regel wurde eingehalten im Ergebnis (nichts verloren), ihre Durchfuehrung ist unbelegt
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): git worktree list: Worktree weg; Branch bau/s1-codex-haertung existiert in keinem Store mehr, Inhalt nachweislich gelandet (84e6099a/6f537245 ancestor von development via 7d65eb6c)

### [wtk6lmhln.json] 296
GEGENSTAND: N9-12 [TEILWEISE] wf_d7ad183d-6b8-1/-2 nur nach neuer Loeschregel entfernen
ORT: unbekannt
SOLL/FIX: Wie N9-11: Ref-Pruefprotokoll fehlt; die Sicherung ist am Objekt belegt, die zugesagte Prozedur nicht
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Worktrees weg; ihre Branch-Tips sind als Refs worktree-wf_d7ad183d-6b8-1/-2 (12.08.) im wt-super-Store konserviert und branch --no-merged zeigt sie NICHT => beide Tips sind in development enthalten (gelandet)

### [wtk6lmhln.json] 297
GEGENSTAND: N9-13 [TEILWEISE] Strecke: golden festschreiben * S-14a * #10 MinIO * #22-Rest (3 Ledger-Marker, N-3, Handout, Q6) * Steuerkanal-Memory
ORT: bau/golden-s14a-riegel | a8465ef3 | f23c18e2
SOLL/FIX: Die drei #22-Ledger-Marker FEHLEN am Objekt (sed an :16968/:17202/:8048: keine datierten Marker -- KON58-Futur, ungelandet); OD-7-Handout ist im Cluster-Repo UNTRACKED (git status '??'), nicht committet/gepusht
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): golden-Baseline a8465ef3 + S-14a-Riegel GEBAUT (Branch bau/golden-s14a-riegel, 7 Commits, UNGELANDET); Q6 GELANDET (f23c18e2, Pipeline 15774 success); Steuerkanal-Memory traegt UEBERHOLT-Stand 12.08. [OK]; MinIO: 4 Ebene-B-Variablen existieren (API-Liste), Smoke aus

### [wtk6lmhln.json] 298
GEGENSTAND: N8-02 [TEILWEISE] P1-P7-Vollstaendigkeitspruefung: elf Zaehlungen
ORT: .gitlab-ci.yml
SOLL/FIX: Die Grundgesamtheit je Zaehlung war nicht dokumentiert; 6 von 11 Zahlen treffen heute KEINE plausible Datei-Menge (Drift durch Folge-Commits vs. Fehlzaehlung nicht unterscheidbar) -- exakt die Nenner-Klasse der Pruefnorm
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Neu erhoben ueber die 4 Strang-D-Dateien: st_fall=12 [OK], when:always=2 [OK], [HISTORIE]=2 [OK], coverage-guard=8 in .gitlab-ci.yml [OK]; ABER COMDARE_LINT_PATHS=8 (behauptet 7), --nur=format=11 (12), 22.1.8=4 (3), FREMD_SOLL_DELTA=15 (6), ctest_unit_host_probe=5 (4), FREMD_HOST_PROBE=20 (7)

### [wtk6lmhln.json] 299
GEGENSTAND: N8-03 [TEILWEISE] Diff a99c4a18: 0 allow_failure/when:never, 1 gewolltes when:always
ORT: ce/.gitlab-ci.yml | 9bb664d6 | a99c4a18
SOLL/FIX: Diff-Aussage wahr, Funktions-Aussage nicht: der Baum traegt weiterhin 2 dokumentierte allow_failure-Jobs gegen die Memory-Doktrin 'allow_failure VERBOTEN' -- Diff statt Funktion ist die benannte Stellvertreter-Klasse
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): git diff 9bb664d6..a99c4a18 | grep -c 'allow_failure|when: never' = 0 [OK]; ABER Gesamtbaum heute: 2 AKTIVE allow_failure:true in ce/.gitlab-ci.yml (Z.257 build:arm64-smoke, Z.898 is_original:relock when:manual) + super Z.2751 (ergebnis:holen, manual)

### [wtk6lmhln.json] 300
GEGENSTAND: N8-05 [TEILWEISE] Pipeline 15751 gruen => #14 schliessen, wf_d826aca8-6ce-8 entfernen
ORT: a99c4a18
SOLL/FIX: Loesch-Protokoll fehlt (wie N9-11/12); Task #14 nicht pruefbar
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): API: P15751 @a99c4a18 status=success (23 success + 1 manual); Worktree wf_d826aca8* existiert nicht mehr, kein Branch-Rest in den Stores

### [wtk6lmhln.json] 301
GEGENSTAND: N8-07 [TEILWEISE] Ledger 24.378->25.848 * 14 Nachtraege KON36-KON49 * 56 ERGAENZT-Fakten
ORT: 6f03349a
SOLL/FIX: 25852!=25848; die 56 Einzel-Fakten sind nicht nachgezaehlt (15 ERGAENZT-Bloecke, Fakten je Block unbenannt -- Nenner offen)
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): git show 6f03349a:LEDGER | wc -l = 25852 (behauptet 25848, Delta 4); KON36..KON49 = 14 neue Nachtraege [OK]; grep -c 'ERGAeNZT' = 15 Bloecke

### [wtk6lmhln.json] 302
GEGENSTAND: N8-10 [TEILWEISE] Bergungs-Bilanz: fsck 3 Stores, kein dangling von heute (12.08.)
ORT: cf4308b6 | bd449d1c | 67e02ca0
SOLL/FIX: Zwei danglings tragen 12.08.-Datum -- nach/um die Messung entstanden; kein Verlust nachweisbar (Inhalte gelandet/WIP), aber die Zahl '2 danglings, keiner von heute' gilt am heutigen Objekt nicht mehr; ce-Stores nicht neu gefsckt (Budget)
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): git fsck super HEUTE: 3 danglings -- cf4308b6 (11.08.) + bd449d1c (12.08. 12:21, MANUAL_RUN par.8b, Inhalt gelandet) + 67e02ca0 (12.08. 19:23 WIP-Stash)

### [wtk6lmhln.json] 303
GEGENSTAND: N8-11 [TEILWEISE] Loeschregel KON49-02 als Memory angelegt und seit 12.08. angewandt
ORT: feedback_worktree_loeschung_erst_alle_submodul_branches_pruefen.md | MEMORY.md
SOLL/FIX: Fuer KEINE der seither entfernten Worktrees (fixup-s1-haertung, wf_d7ad183d-*, wf_d826aca8-*) existiert ein Ref-Pruefprotokoll -- Ergebnis jeweils sauber (Tips gelandet/konserviert), Durchsetzung der Prozedur unbelegt
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Memory-Datei feedback_worktree_loeschung_erst_alle_submodul_branches_pruefen.md existiert (12.08. 17:14), im MEMORY.md-Index verlinkt ([ROT])

### [wtk6lmhln.json] 304
GEGENSTAND: N8-13 [TEILWEISE] Monats-Spend-Limit erreicht, WF12 0/4, C/A vom Lead direkt
ORT: b12afd32
SOLL/FIX: Keine Verbuchung 'Limit angehoben/Monat neu' im Ledger; die Wiederfreigabe ist am Objekt sichtbar, aber unerklaert verbucht
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Ledger dokumentiert Limit-Abrisse als reale Klasse (Z.17850 02.08., Z.21020-21027 06.08. 'You've hit your monthly spend limit'); heute laufen nachweislich wieder Bau-Agenten (S-3-Build-Prozesse in wt-ce-mess-ordnung, s14a-Fixup b12afd32 07:52)

### [wtk6lmhln.json] 305
GEGENSTAND: ZW-01 [TEILWEISE] GOAL-Kopf-Nachtrag+8 Marker * Wellenplan par.17+7 * Designplan par.10+6 * ARBEITSWEISE unangetastet
ORT: unbekannt
SOLL/FIX: Wellenplan hat 6 statt 7: der von Teil A.5 geforderte Kopf-FORTSCHREIBUNGS-Marker fehlt im Wellenplan-Kopf (Stand-Zeile weiter '08.08.2026 abends')
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): GOAL: REFERENZ-STAND-Kopf Z.13 [OK] + grep -c 'MARKER 12.08...' = 8 [OK]; Wellenplan: par.17 Z.1996 [OK], Marker = 6; Designplan: par.10 Z.402 [OK], 5 Marker-Bloecke + Kopf-STAND-HINWEIS 12.08. = 6 [OK]; ARBEITSWEISE war 12.08. v3.5 (inzwischen v3.9)

### [wtk6lmhln.json] 306
GEGENSTAND: ZW-02 [TEILWEISE] WF7 8/8 * WF8 10/10 (22 Fixes) * 21/21 Marker * 0 Agenten-Tode
ORT: journal.json
SOLL/FIX: WF7 (8/8), Marker-Agent (21/21) und die 22 Fixes nicht einzeln am Journal erhoben (nur WF8 stichprobenhaft verifiziert)
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): WF8-Archiv entpackt: journal.jsonl traegt 10 result-Zeilen / 10 Agenten [OK] (das Journal ist die Wahrheit)

### [wtk6lmhln.json] 307
GEGENSTAND: ZW-03 [GEGENSTANDSLOS] Task-Zustaende #9/#26/#11/#27/#28
ORT: unbekannt
SOLL/FIX: -
STATUS LT. QUELLE: nur-hinweis (gegenstandslos/ueberholt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): In dieser Rolle existiert kein TaskList-Zugriff -- als eigener Eintrag unter nicht_pruefbar gefuehrt

### [wtk6lmhln.json] 308
GEGENSTAND: GU-01 [TEILWEISE] Acht Eigenzusagen OK, darunter Register-Erstbefuellung und gedeckte gitleaks-Nullen
ORT: 20260812-WF2-SYNTHESE-...-register-leerer-klassen.md | 65ef6cfb | 20260812
SOLL/FIX: 'Register-Erstbefuellung' existiert NUR als Synthese-Bericht (20260812-WF2-SYNTHESE-...-register-leerer-klassen.md), nicht als pflegbares Register-Artefakt -- Bericht statt Gegenstand (Stellvertreter-Klasse)
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Nullen: MANIFEST durchgehend glpat-+20 mit 'leaks found: 1' [OK]; KON15-23 gelandet [OK] (65ef6cfb KON21 etc.); S-6-Fragen beantwortet [OK] (KON21 'S-6 ENTSPERRT')

### [wtk6lmhln.json] 309
GEGENSTAND: GU-02 [TEILWEISE] V-1: ##25 ohne Besitzer -- dringendster Posten; ist F1 damit erfuellt?
ORT: unbekannt
SOLL/FIX: F1 ist zweigliedrig (GOAL :517 'Nenner-Ehrlichkeit + DURCHSTICH'); VII.3 :548ff verlangt den frischen Messwert 'als Tabellenzeile im Thesis-Submodul ... bis PDF' -- dieser End-Beleg existiert nirgends; PLANABGRENZUNG woertlich: 'der Freitag braucht eine Tabellenzeile im Thesis-PDF, und dafuer arbeitet weiterhin niemand'
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): ##25 inzwischen gebaut+CI-bewiesen (KON56/57, P15764 35/35) -- der 11.08.-Missstand ist behoben

### [wtk6lmhln.json] 310
GEGENSTAND: GU-04 [NICHT_ERLEDIGT] V-7: A-1-Vorlagetext vor Backup-Ref-Aktion nachlesen; gestufte Fassung gilt
ORT: 20260802
SOLL/FIX: Die gestufte Fassung wurde faktisch verletzt: refs/backup/pre-secret-scrub-20260802 ist ohne Bundle und ohne verbuchtes GO von beiden origins verschwunden; A-1-Nachlesen nirgends verbucht; die Owner-Vorlage existiert nur im UNGELANDETEN KON58-Entwurf -- muss in die naechste Owner-Vorlage
STATUS LT. QUELLE: offen (Behauptung faellt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): git ls-remote origin 'refs/backup/*' in super UND ce: LEER (rc=0, Gegenprobe development=1 Tip); kein 20260802-Bundle (nur prescrub-2026-07-25-Bundles); Ledger Z.21449: O-5 verlangte 'stehen lassen -> Bundle -> DANN loeschen'; kein Loeschungs-GO im Ledger

### [wtk6lmhln.json] 311
GEGENSTAND: GU-05 [TEILWEISE] V-8: E-1..E-4 Status je Punkt ungeprueft; Fr 14.08. komplett abschliessbar
ORT: unbekannt
SOLL/FIX: Kein E-1..E-4-Abschluss verbucht (Frist erst morgen 14.08.); Task #21 nicht pruefbar; die alten Zeilenanker :9468/:8941 sind gedriftet -- Anker-Doktrin (Symbol statt Zeile) weiterhin verletzt
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): E-Posten als Strecke verbucht (Ledger Z.3521); OV-4 als W2-Posten angelegt (KON41); Selbstwiderspruch: Z.11015 traegt die Durchstreichungs-Korrektur ('~~und die Paper-Kopplung~~')

### [wtk6lmhln.json] 312
GEGENSTAND: GU-06 [TEILWEISE] V-11: MEMORY-Kopf stale -- auf KON23 korrigiert
ORT: MEMORY.md
SOLL/FIX: Die damalige Korrektur fand statt, die KLASSE ist nicht geschlossen: der Kopf hinkt heute wieder um 21 KON-Stufen (KON36 vs KON57)
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): head MEMORY.md heute: 'lebender Stand: Ledger KON36 + Konsolidierung IV' -- Ledger-Kopf ist KON57

### [wtk6lmhln.json] 313
GEGENSTAND: GU-09 [TEILWEISE] F11-UEBERHOLT-Marker an allen Fundstellen der gestrichenen Invariante
ORT: 20260810
SOLL/FIX: 20260810-HAUPTSTRANG-ergebnis (Z.64/Z.173-176) und WF6-SYNTHESE Z.32 nennen die Invariante OHNE Marker; Wellenplan Z.1989 nur ueber Kontext (Z.2002) gedeckt -- 'Doku deprecaten' ist an 3 Fundstellen nicht vollzogen
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Gesamturteil Z.77+Z.132+Z.147 tragen datierte '[UeBERHOLT 12.08., KON30-04...]'-Marker [OK]; Ledger Z.1847/2788 fuehren die geltende Fassung (nur CEBs) [OK]

### [wtk6lmhln.json] 314
GEGENSTAND: N7c-02 [TEILWEISE] 235 Journale * 797M Voll-Ernte * 217M Session-Log in ernte-20260812-nacht7c
ORT: 20260812
SOLL/FIX: 233 statt 235 Journal-Eintraege im Archiv (Delta 2 unerklaert -- moeglicherweise die 2 redigierten separat gezaehlt); kon-quellen heute 51 (Verzeichnis seit 12.08. weiter befuellt, 21er-Stand nicht mehr isolierbar)
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): du: session-log 217M [OK], workflows 802M (~797M [OK]); tar -tzf alle-journale-20260812.tar.gz | grep -c journal = 233

### [wtk6lmhln.json] 315
GEGENSTAND: N7c-05 [TEILWEISE] Kuerzungs-Regel: jede Owner-Zitat-Kuerzung traegt [...]
ORT: unbekannt
SOLL/FIX: Ob die 7 Zitate ungekuerzt sind (kein Marker noetig) oder die Regel nicht angewandt wurde, ist ohne Abgleich gegen die Owner-Extrakte nicht entscheidbar -- Anwendungs-Nachweis fehlt
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): KON50-57-Bereich (Z.19-600): 7 verbatim-Bloecke, 0 '[...]'-Marker

### [wtk6lmhln.json] 316
GEGENSTAND: N7c-06 [NICHT_ERLEDIGT] Platzhalter-Gate in kuenftige Workflows eingebaut
ORT: workflow-script.js
SOLL/FIX: Ein Platzhalter-Gate ist in keinem auffindbaren Skript nachweisbar; die Zusage ist unbelegt -- Skripte der heutigen Laeufe (S-3/s14a) nicht zugreifbar
STATUS LT. QUELLE: offen (Behauptung faellt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Keine Workflow-Skripte ab 12.08. auffindbar (backups tragen nur workflow-script.js vom 26.07.-02.08.; kein wf12*.js); grep-Prueffeld existiert nicht

### [wtk6lmhln.json] 317
GEGENSTAND: N7b-01 [TEILWEISE] Vier Zahlen nachziehen: 295->294 * 137->123 * 124->130 * 13/7967->14/8528
ORT: unbekannt
SOLL/FIX: Z.5737/5741 fuehren weiterhin '295 static_assert' ohne Korrektur-Marker daneben; der 137->123-Nachzug ist an keiner Fundstelle als Marker belegt (Flag-Zaehlung 137 vs 123 bleibt unaufgeklaert im Ledger)
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Z.4672 '13/7967 -> 14/8528 ci/tests/*.sh, 0 von 14 retired' [OK] + Z.4795 Tabelle [OK]; 130 als Substring-Menge etabliert (KON12-02, heute selbst gemessen 130) [OK]

### [wtk6lmhln.json] 318
GEGENSTAND: N7b-02 [TEILWEISE] G-1-Grammatik -- Owner-angeforderte Bringschuld
ORT: unbekannt
SOLL/FIX: Ein eigenes G-1-Entwurfsdokument existiert nicht (kein Datei-Fund); die Bringschuld wurde per v2-Deckung umdefiniert und im Ledger verbucht, der Rest-Posten (Pruefsyntax) ist offen
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Ledger Z.3516 'G-1 hat sich gewandelt: die Grammatik EXISTIERT (v2)' + Z.2072 'die v2 deckt sie; Rest = DREIPHASIG-Pruefsyntax des Homes'

### [wtk6lmhln.json] 319
GEGENSTAND: N7b-04 [TEILWEISE] Register der leeren Klassen angelegt (KON15-01)
ORT: 20260812-WF2-SYNTHESE-...-register-leerer-klassen.md | 20260812
SOLL/FIX: Das Register existiert als Bericht, nicht als pflegbares Register-Artefakt -- Stellvertreter-Klasse (Bericht statt Gegenstand); niemand kann es fortschreiben, ohne eine Synthese zu editieren
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): find docs -iname '*register*': einziger Neueintrag ist 20260812-WF2-SYNTHESE-...-register-leerer-klassen.md -- ein Sessions-Bericht

### [wtk6lmhln.json] 320
GEGENSTAND: N7-01 [TEILWEISE] Restlandung 4/4; R1-E18SNAP neu geschnitten statt gelandet
ORT: unbekannt
SOLL/FIX: Der 'neue Schnitt' existiert nicht als Bau -- R1 ist faktisch ein offener P4-Posten (Verdikt + Einplanung, kein Commit); '4 von 4' gilt nur, wenn man den Entscheid als Erledigung zaehlt
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Ledger Z.6814 'R1-E18SNAP wird NEU GESCHNITTEN, nicht gelandet wie vorgelegt -- Wirksamkeit null' + Z.6286 Tabelle 'R1 | -- | E18SNAP, neu geschnitten'; Z.20863: E18-SNAP 'NICHT LANDEN, aber KEINE Welle jetzt -- P4-Fenster'

### [wtk6lmhln.json] 321
GEGENSTAND: N7-05 [TEILWEISE] 28 InputIfFileExists (Wellenplan ##58) vs. gemessen 13 im echten Klon
ORT: 20260931
SOLL/FIX: Wellenplan Z.714 fuehrt weiterhin '28 \InputIfFileExists-Ziele' OHNE Korrektur-Marker -- die Messung ist nie in den Plan uebertragen worden
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Echter Klon Projekte/Research/20260931-overleaf-diplomarbeit: grep -c ueber *.tex = 12 (Session mass 13 -- Groessenordnung bestaetigt, +/-1 Drift); Submodul-Checkout in wt-super-landung ist LEER (0 .tex)

### [wtk6lmhln.json] 322
GEGENSTAND: N7-06 [TEILWEISE] 137 ce-eigene Flag-Literale (123 Organ + 7 System + 6 Mess + 1 Planer)
ORT: unbekannt
SOLL/FIX: Ohne dokumentierte Zaehlweise nicht reproduzierbar -- Nenner-Mangel; Aufklaerung 137-vs-123 steht aus
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Die Kategorien-Zaehlweise ist nirgends als Kommando dokumentiert; die Differenz 137 vs. 123 (N7b-01) ist im Ledger als UNGEPRUEFT gefuehrt und bis heute nicht aufgeklaert (kein Marker, keine Neuzaehlung verbucht)

### [wtk6lmhln.json] 323
GEGENSTAND: N7-07 [NICHT_ERLEDIGT] #81: Verify ueber W0b-Bauposten wiederholen (Owner-Auftrag)
ORT: unbekannt
SOLL/FIX: Der wiederholte W0b-Verify ist nirgends als gefahren verbucht -- offener Owner-Auftrag; Task-Status nicht einsehbar
STATUS LT. QUELLE: offen (Behauptung faellt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): grep '#81' im Ledger-Kopf KON36-KON57: kein Vollzugs-Eintrag; kein verbuchter Wiederhol-Verify mit Pipeline-Messung auffindbar

### [wtk6lmhln.json] 324
GEGENSTAND: N7-08 [TEILWEISE] main-FF vorbereitet: kumulativ 92 Commits / 15.114 Zeilen / 0 Verstoesse (11.08.)
ORT: unbekannt
SOLL/FIX: Vor dem FF muss die Hygiene-Wache ueber die heutigen 160/56 Commits neu laufen; die 11.08.-Zahl ist als Beleg verbraucht
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Heute rev-list origin/main..origin/development: super=160 (ce=56) -- die 92er-Messung deckt den heutigen FF-Bereich nicht mehr

### [wtk6lmhln.json] 325
GEGENSTAND: P7-03 [TEILWEISE] Acht Credential-Muster je 0 Treffer, Gegenprobe 'Stempel' 117
ORT: unbekannt
SOLL/FIX: Je Muster ein praeparierter Koeder (KON58-02-Klasse) wurde nie gefahren; fuer glpat- ist der Biss anderweitig belegt (MANIFEST 'leaks found: 1'), fuer die uebrigen 7 Muster fehlt der Koeder-Beweis
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Die Struktur-Kritik der Erhebung trifft: die 'Stempel'-Gegenprobe beweist nur, dass grep lief -- nicht, dass die acht Muster beissen wuerden

### [wtk6lmhln.json] 326
GEGENSTAND: P7c-02 [GEGENSTANDSLOS] Nichts laeuft mehr (Prozess-Nullbefund 11.08.)
ORT: unbekannt
SOLL/FIX: -
STATUS LT. QUELLE: nur-hinweis (gegenstandslos/ueberholt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Vergangener Momentzustand ohne protokolliertes Kommando -- am heutigen Objekt nicht mehr pruefbar (heute laufen absichtlich Bau-Prozesse); die Methodenluecke (kein benanntes Muster, keine Gegenprobe) bleibt als Lehre korrekt

### [wtk6lmhln.json] 327
GEGENSTAND: RG-03 [NICHT_ERLEDIGT] Lande-Stufe gehoert IN den Workflow (landet den Zweig)
ORT: workflow-script.js
SOLL/FIX: Die Lehre ist nirgends als Workflow-Stufe implementiert nachweisbar -- sie lebt nur als Text; bei den heutigen Laeufen (S-3/s14a) erneut Handlandung zu erwarten
STATUS LT. QUELLE: offen (Behauptung faellt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Kein Workflow-Skript ab 12.08. auffindbar (backups: nur workflow-script.js 26.07.-02.08., kein wf12*.js); die realen Landungen (C/A, s1-haertung, Q6) fuhr der Lead von Hand (nacht-9 par.3 dokumentiert Handlandungen)

### [wtk6lmhln.json] 328
GEGENSTAND: RG-04 [TEILWEISE] T-6-Wachen-Inventar deckt jede neue Wache; drei neue seit dem Fang
ORT: test_t6_wachen_inventar.cpp | f23c18e2 | b12afd32
SOLL/FIX: test_t6_wachen_inventar.cpp kennt weder an f23c18e2 noch an b12afd32 den S-14a-Riegel (grep 'axis_version|s14' = 0) -- obwohl der s14a-Kombibau 486/486 gruen lief, d.h. das Inventar bemaengelt den neuen CI-Job nicht (Nenner des Inventars unbestimmt); vor der s14a-Landung zu klaeren
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Ausbeute-/Durchstich-Wache sind als eigene super-CI-Jobs registriert und liefen success in 15764 (test:mess-ausbeute-bissprobe, test:durchstich-bissprobe) [OK]

### [wtk6lmhln.json] 329
GEGENSTAND: PA-01 [TEILWEISE] Zwoelf F1-Posten (11.08.), nur Posten 1 in den Sessions als erledigt belegt
ORT: .gitlab-ci.yml:2751 | a881d468 | 97b58e91
SOLL/FIX: (8) ergebnis:holen traegt WEITER allow_failure:true (super .gitlab-ci.yml:2751, manual-Job); Posten 3/5/6/7/9/10/11 (D3-4/D3-5, ##26-Formel, ##23-R1-Neuzaehlung, ##21 object_stat, ##20-B, W0a-Rest, W0b-15-Posten) sind weder in KON56-58 noch am Objekt als erledigt belegt -- echte Nachimplementierungs-Kandidaten vor F1
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Am Objekt: (1) ##25 CI-bewiesen [OK]; (2) P-D37B gelandet [OK] (a881d468 in dev); (4) #80 geheilt [OK] (guard neu + 4x success); (12) P-LIZENZ 97b58e91 'fix(lizenz): vier Zusicherungen erzwungen' gelandet [OK]

### [wtk6lmhln.json] 330
GEGENSTAND: PA-02 [TEILWEISE] #80 + 8 P-CI-Wachen-Defekte einplanen (sonst W0b-Nachlauf auf blinder Wache)
ORT: a99c4a18
SOLL/FIX: Die ACHT Einzeldefekte aus PLANABGRENZUNG (docs/sessions/, nicht plaene) sind nicht einzeln gegen den a99c4a18-Diff abgehakt -- Sammelheilung plausibel, Einzelnachweis fehlt
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): #80 aufgeloest (Strang D, Guard-Neubau 552 Z., 4 Pipelines success); die Wache diskriminiert jetzt (st_fall=12 Selbsttest-Faelle, SOLL_DELTA-Mechanik)

### [wtk6lmhln.json] 331
GEGENSTAND: L57-01 [TEILWEISE] ##25 VOLL CI-bewiesen => F1-Lieferung erbracht
ORT: unbekannt
SOLL/FIX: Es existiert KEIN Beleg, dass der frische 376333-Messwert die Kette bis zur PDF-Tabellenzeile durchlaufen hat (nur dass alle Kettenjobs in derselben Pipeline gruen sind); Glied 1 (Nenner-Ehrlichkeit/W0a) ist nirgends als abgenommen verbucht -- die Gleichsetzung '##25 bewiesen = F1 erbracht' traegt nicht
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): ##25-CI-Beweis haelt (35/35, Trace-Zeilen [OK]); GOAL :517: F1 = 'Nenner-Ehrlichkeit + DURCHSTICH' (zweigliedrig); VII.3 :548ff: der frische Messwert muss 'als Tabellenzeile im Thesis-Submodul' liegen (CSV->persist->xlsx->anhang:forward->PDF). 15764 enthaelt thesis:pdf/anhang-forward/analyse:thesis-data alle success

### [wtk6lmhln.json] 332
GEGENSTAND: L57-05 [TEILWEISE] Lens 2 ueber 671d7f6a..84e6099a: TRAEGT_MIT_FIXES, 0 ERNST
ORT: 6f537245 | b12afd32
SOLL/FIX: Die Deckungs-Implikation ist begrenzt: der 13.08.-Zweitpass ueber die Nachbar-Werkzeugklasse (S-14a-Riegel) fand 7 Fund-Gruppen (b12afd32) -- ein 'TRAEGT' eines Lens deckt nur seinen Diff-Ausschnitt (EIN GRUENES GATE deckt nur seinen Gegenstand)
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Bereichsangabe korrekt -- 6f537245 entstand erst als Antwort auf die 3 Hinweise (ausserhalb des gepruefen Bereichs, logisch zwingend)

### [wtk6lmhln.json] 333
GEGENSTAND: L56-05 [TEILWEISE] cf22-Vollformat 10 Dateien, kompilat-neutral bewiesen (-fpreprocessed-Hash)
ORT: 2907df3b
SOLL/FIX: Der -fpreprocessed-Hash nicht stichprobenweise reproduziert; Anmerkung der Erhebung bleibt: die Suppression aendert Werkzeug-, nicht Kompilat-Verhalten -- 'kompilat-neutral' ist der engere, korrekt benannte Gegenstand
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Commit 2907df3b 'cf22-Vollformat der 10 beruehrten Dateien + cppcheck-2.21-FP-Suppression' existiert; danach 485/485 + CI success

### [wtk6lmhln.json] 334
GEGENSTAND: L58-02 [TEILWEISE] Grundgesamtheit 158 dreifach gemessen (6+130+22); 122 echt + 30 Forwarder
ORT: b12afd32
SOLL/FIX: Die axes/queuing-Discovery ist ein SUBSTRING-Filter (152 von 387 hpp -- exakt die 152/387-Relation des heutigen Wachen-Funds); Gegenprobe HEUTE: 0 Traeger ausserhalb (6 Alternativ-Schreibweisen je 0 Treffer), aber ein kuenftiger Traeger ohne den Substring bliebe unsichtbar -- strukturell offen, heute nicht verletzt; 35 nicht-hpp-Dateien unter axes deckt erst der b12afd32-Fixup (G5)
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Zaehlung selbst reproduziert: 6+130+22 = 158 [OK] (grep -rl 'algo_version' axes=130, queuing=22, heuristik-hpp=6); Lock traegt 158 Records (316 Nicht-Kommentar-Zeilen / 2)

### [wtk6lmhln.json] 335
GEGENSTAND: L58-03 [TEILWEISE] Mutationsbeweis T-i-2 erbracht: Aenderung an einem axes-Header wird gefangen
ORT: 8424a331 | b12afd32
SOLL/FIX: Der Beweis ist ein Einzelfall-Beweis: eine Mutation an einem Header AUSSERHALB der 152er-Substring-Menge wurde nie gesetzt (waere nach Discovery-Semantik auch kein Traeger -- die Mengen-Deckung haengt an der Substring-Definition, siehe L58-02); Riegel nicht selbst gebaut/gefahren in dieser Pruefung
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Tripwire-Test rot-zuerst existiert (8424a331 'Koeder D belegt die v1-Luecke'); b12afd32/G7 schliesst weitere Testluecken (heuristik-ROT beidseitig, Lock-Byteidentitaet)

### [wtk6lmhln.json] 336
GEGENSTAND: L58-04 [TEILWEISE] ctest -N 485->486; Kombibau VOLLSTAENDIG lokal 4x486/486; 'dem CI bleibt nichts nachzudecken'
ORT: unbekannt
SOLL/FIX: NUR EINE von vier Zellen ist am Objekt belegt (gcc-deb, 13.08. 07:55 -- NACH dem KON58-Entwurf 06:47 geschrieben); Logs fuer gcc-release/clang-debug/clang-release existieren nirgends (weder /tmp noch Job-tmps). 'Dem CI bleibt nichts nachzudecken' ist zusaetzlich falsch: der CI faehrt Jobklassen, die lokal nicht existieren (pmc, measure, lint, coverage-guard) -- ein gruenes Gate deckt nur seinen Gegenstand
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): 486 registriert [OK] (/tmp/s14_kombi_gcc-deb.log: '100% tests passed, 0 tests failed out of 486' + 'KOMBI gcc-deb DURCH: rc=0'); PZW-Nenner am Zweig 499 Test-cpp [OK]

### [wtk6lmhln.json] 337
GEGENSTAND: L58-07 [TEILWEISE] Q6-Nachzug 58579575: 4 Doku-Stellen, Hash identisch, Koeder beidseitig
ORT: 58579575 | bd874f3f
SOLL/FIX: Der -fpreprocessed-Hash (bd874f3f...) und der static_assert(nodes==8)-Koeder sind Berichtswerte -- nicht reproduziert (CI 15774 deckt das Kompilat indirekt)
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): git show 58579575 --stat: 3 Dateien / 4 Stellen (soll_design +9 = 2 Stellen, README +8, Matrix-Kopf +14) [OK] konsistent mit der Behauptung

### [wtk6lmhln.json] 338
GEGENSTAND: L58-09 [TEILWEISE] Infra-Handout im Cluster-Repo; Beleg aus runner-matrix-DONE.md:50 zitiert
ORT: Cluster/docs/sessions/20260813-HANDOUT-od7-heavy-worker-24-auf-16.md | runner-matrix-DONE.md | 20260813
SOLL/FIX: git status: '?? docs/sessions/20260813-HANDOUT-...' -- UNTRACKED, weder committet noch gepusht; Infra kann den Handout nicht sehen. Nachimplementierung: committen+pushen (GitLab-only)
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Datei existiert: Cluster/docs/sessions/20260813-HANDOUT-od7-heavy-worker-24-auf-16.md mit korrektem Gegenstand (':43 HEAVY_J=24 -> 16, nur die prod1-Zeile'); der zitierte Beleg existiert (runner-matrix-DONE.md Z.48-52: SIGHUP-only, Deploy /usr/local/sbin auf beiden Hosts) [OK]

### [wtk6lmhln.json] 339
GEGENSTAND: L58-10 [NICHT_ERLEDIGT] Die zwei Alt-Zitate (Z.17446/17511) + par.69.6 (Z.17745) bekommen datierte Marker
ORT: unbekannt
SOLL/FIX: Die Futur-Zusage aus dem ungelandeten KON58-Entwurf ist nicht vollzogen: kein datierter Marker an den Alt-Stellen (nur die NEUEN Ledger-Zeilen 2990/3270-3282 beschreiben die Korrektur); KON58 selbst ist nicht im Ledger (Kopf = KON57)
STATUS LT. QUELLE: offen (Behauptung faellt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): sed an den Stellen HEUTE: Z.17511 'prod1 = 32 Threads / 24 Kerne; prod2 = 24 Threads / 16 Kerne' OHNE Marker daneben; par.69.6 (Z.17745) 'OD-7 NEUE RUNNER-ZAHLEN' OHNE UEBERHOLT-Vermerk

### [wtk6lmhln.json] 340
GEGENSTAND: L58-11 [TEILWEISE] N-3/N-4 neu gerechnet: prod1@16W ~22,8h (Faktor 1,1008 uebertragen) vs prod2@24W 34,4h gemessen
ORT: unbekannt
SOLL/FIX: Der Faktor 1,1008 wurde nicht gegen die @24W/@32W-Traces nachgerechnet (Traces in dieser Session nicht lokalisierbar); die Rechnung ist Entwurfs-Stand, KON58 ungelandet; ~45,5h (nacht-9) vs ~45,6h (KON58) bleibt als Rundungs-Differenz unerklaert
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Der Entwurf deklariert die ANNAHME selbst ('es existiert KEIN amd-16W-Lauf in den Traces') und setzt die Pflicht-Nachkalibrierung -- methodisch ehrlich

### [wtk6lmhln.json] 341
GEGENSTAND: SB-01 [TEILWEISE] Sechs Tagesposten 13.08. (#10 MinIO+776+test:secrets * #11 * #83/S-1 * #22-Paket * golden * S-14a)
ORT: f23c18e2 | 868ed3a1 | 671d7f6a
SOLL/FIX: golden/S-14a UNGELANDET (Bau-Agent arbeitet); #10-Smoke aus; '776-Token-Rotation' NICHT erfolgt (776 war Fehldeutung -- gitleaks-Trefferzahl); 'test:secrets aus prod2' in keinem Beleg erwaehnt/erledigt; #22-Ledger-Marker fehlen (L58-10); OD-7-Handout untracked
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Q6 gelandet [OK] (f23c18e2); S-1 gelandet [OK] (868ed3a1 via 671d7f6a); golden+S-14a GEBAUT (7 Commits, ungelandet); #10 erhoben (4 Vars existieren)

### [wtk6lmhln.json] 342
GEGENSTAND: SB-02 [GEGENSTANDSLOS] S-14a heute 6/136 gedeckt (dritter Nenner neben 158/152/387)
ORT: unbekannt
SOLL/FIX: -
STATUS LT. QUELLE: nur-hinweis (gegenstandslos/ueberholt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Alle vier Zahlen auf ihre Grundgesamtheit zurueckgefuehrt: 136 = Explore-Fehlzahl, von KON12-02 schon am 11./12.08. korrigiert ('7 VON 130, NICHT 6 VON 136') -- die Strecke schrieb die veraltete Zahl ab; 130/152 = Substring-Mengen (axes bzw. axes+queuing), 158 = 152+6 heuristik = Lock-Records (heute selbst gemessen), 387 = 345+42 alle hpp; 'gedeckt' heute: 158 Records am ungelandeten Zweig

### [wtk6lmhln.json] 343
GEGENSTAND: SB-03 [TEILWEISE] Fr 14.08.: #11 landet * #14 (#80/#84) fertig * #21 E-1..E-4 komplett * #4 S-3 aktivieren
ORT: bau/s3-ordnungsrelation | 671d7f6a
SOLL/FIX: #21 (E-1..E-4 + A-1-Vorlagetext) offen -- und der A-1-Teil ist durch den Backup-Ref-Verlust (GU-04/L58-13) inzwischen eine Owner-Frage, kein Abarbeitungs-Posten mehr; Fristen erst morgen -- keine Verletzung, aber #21 ist der Wackelkandidat
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Vorfristig: #11/##25 GELANDET (12.08., 671d7f6a) [OK]; #80/#84 faktisch gruen (4 Pipelines success, 3 #84-Tests Passed) [OK]; S-3 IM BAU (Worktree wt-ce-mess-ordnung, bau/s3-ordnungsrelation, Build-Prozesse live; S-1-Voraussetzung gelandet)

### [wtk6lmhln.json] 344
GEGENSTAND: SB-04 [GEGENSTANDSLOS] Nur noch VIER Owner-Fragen (OF-1..OF-4) mit Fristen
ORT: unbekannt
SOLL/FIX: -
STATUS LT. QUELLE: nur-hinweis (gegenstandslos/ueberholt)
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Von der Realitaet ueberholt: alle vier sind beantwortet -- OF-1 KON40-02 (am Objekt: 17+1=18) + KON41-02 ('Ja korrekt.'); OF-2 KON41-03 ('VOELLIG FALSCH', Neu-Frage) -> OF-2-neu KON42 beantwortet; OF-3 KON41-04; OF-4 KON45-02 als Bestands-Explore gefahren. Die 'NULL offen'-Aussage der nacht-9 (N9-14) ist die aktuellere Wahrheit

### [wtk6lmhln.json] 345
GEGENSTAND: SB-06 [TEILWEISE] TEST-KONSOLIDIERUNG als aktiver Posten (#28), kein W7-Behaelter mehr
ORT: unbekannt
SOLL/FIX: Eigentuemer NICHT gesetzt (Z.1449 fuehrt 'TEST-KONSOLIDIERUNG-Eigentuemer' in der Offen-Liste); seit 12.08. kein Fortschritt in KON56/57 verbucht -- umetikettiert ja, bearbeitet nein
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -
BELEG (verbatim): Ledger Z.1386 '#28 TEST-KONSOLIDIERUNG' angelegt + Z.1441 'per KON37-08 HERAUSGEZOGEN -> aktiver Posten (dockt an S-16/#88)'

### [wtk6lmhln.json] 346
GEGENSTAND: V[3]-nicht_pruefbar[0]: Alle Task-Status-Behauptungen (#4 #7 #10 #11 #14 #16 #21 #22 #28 #30 #31 #32 #33 #80 #81 #84 #88, ZW-03): in dieser Rolle existiert kein TaskList-Zugriff -- die Pipeline-/Objekt-Tei
ORT: unbekannt
SOLL/FIX: Alle Task-Status-Behauptungen (#4 #7 #10 #11 #14 #16 #21 #22 #28 #30 #31 #32 #33 #80 #81 #84 #88, ZW-03): in dieser Rolle existiert kein TaskList-Zugriff -- die Pipeline-/Objekt-Teile der betroffenen IDs (N9-04, N9-10, N8-05, GU-03, L58-12, N7-07, P7-05, ZW-03) sind geprueft, die completed/in_progress-Flags muss die Pruefstufe mit TaskList-Zugriff gegenlesen.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 347
GEGENSTAND: V[3]-nicht_pruefbar[1]: N9-06/L58-04-Restluecke: die Kombibau-Zellen gcc-release/clang-debug/clang-release am s14a-Stand (486er) -- Logs existieren nirgends (nur gcc-deb in /tmp); der Bau-Agent arbeitet no
ORT: b12afd32
SOLL/FIX: N9-06/L58-04-Restluecke: die Kombibau-Zellen gcc-release/clang-debug/clang-release am s14a-Stand (486er) -- Logs existieren nirgends (nur gcc-deb in /tmp); der Bau-Agent arbeitet noch (b12afd32 07:52, Prozesse live). Nachpruefung erst nach dessen Abschluss sinnvoll -- im READ-ONLY-Auftrag kein eigener Vier-Zellen-Bau gefahren (Platte 25G frei, paralleler S-3-Bau laeuft).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 348
GEGENSTAND: V[3]-nicht_pruefbar[2]: L58-11: der Skalierungsfaktor 1,1008 gegen die @24W/@32W-CI-Traces -- die Trace-Quellen sind in dieser Session nicht lokalisierbar (CI-Job-Artefakte); die Zahl bleibt Entwurfs-Rechn
ORT: unbekannt
SOLL/FIX: L58-11: der Skalierungsfaktor 1,1008 gegen die @24W/@32W-CI-Traces -- die Trace-Quellen sind in dieser Session nicht lokalisierbar (CI-Job-Artefakte); die Zahl bleibt Entwurfs-Rechnung mit selbst-deklarierter Annahme.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 349
GEGENSTAND: V[3]-nicht_pruefbar[3]: N7c-05 abschliessend: ob die 7 verbatim-Bloecke in KON50-57 UNGEKUERZT sind (dann waere 0 Marker korrekt), verlangt Wort-fuer-Wort-Abgleich gegen die Owner-Extrakte in docs/session
ORT: unbekannt
SOLL/FIX: N7c-05 abschliessend: ob die 7 verbatim-Bloecke in KON50-57 UNGEKUERZT sind (dann waere 0 Marker korrekt), verlangt Wort-fuer-Wort-Abgleich gegen die Owner-Extrakte in docs/sessions/backups/*/owner-extrakte/ bzw. die 217M-Rohtranskripte -- nicht im Budget dieser Verifikation.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 350
GEGENSTAND: V[3]-nicht_pruefbar[4]: P7c-02: der Prozess-Nullbefund vom 11.08
ORT: unbekannt
SOLL/FIX: P7c-02: der Prozess-Nullbefund vom 11.08. ist ein vergangener Momentzustand ohne protokolliertes Kommando -- prinzipiell nicht mehr am Objekt pruefbar (als GEGENSTANDSLOS eingestuft).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 351
GEGENSTAND: V[3]-nicht_pruefbar[5]: ce-Store-fsck (N8-10 Teil b/c): fsck lief nur ueber super; die zwei ce-Objektspeicher (Hauptklon-Store mit 148 Branches, geteilter modules-Store) wurden aus Zeitgruenden nicht neu 
ORT: unbekannt
SOLL/FIX: ce-Store-fsck (N8-10 Teil b/c): fsck lief nur ueber super; die zwei ce-Objektspeicher (Hauptklon-Store mit 148 Branches, geteilter modules-Store) wurden aus Zeitgruenden nicht neu gefsckt -- der Loesch-Vorfall-Klasse wegen empfohlen, das beim naechsten ruhigen Fenster nachzuholen.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 352
GEGENSTAND: V[3]-nicht_pruefbar[6]: Die zwei Codex-Funde-Detailzeilen B (:569 Sentinel im Drift-Zweig) einzeln am Altstand: nur A und C wurden als Stichprobe selbst gelesen; B/D/E/F sind ueber die G1-G7-Fixgruppen de
ORT: b12afd32 | 8257e517
SOLL/FIX: Die zwei Codex-Funde-Detailzeilen B (:569 Sentinel im Drift-Zweig) einzeln am Altstand: nur A und C wurden als Stichprobe selbst gelesen; B/D/E/F sind ueber die G1-G7-Fixgruppen des b12afd32 plausibel gedeckt, aber nicht einzeln am 8257e517-Stand nachgelesen.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 353
GEGENSTAND: V[3]-nicht_pruefbar[7]: PA-01 Posten 3/5/6/7/9/10/11 im Detail (D3-4/D3-5-Bau, ##26-Formel, ##23-R1-xlsx-Neuzaehlung am heutigen Gitlink, ##21 object_stat zweite Haelfte, ##20-B-Restbau, W0a-Rest, W0b-Ban
ORT: unbekannt
SOLL/FIX: PA-01 Posten 3/5/6/7/9/10/11 im Detail (D3-4/D3-5-Bau, ##26-Formel, ##23-R1-xlsx-Neuzaehlung am heutigen Gitlink, ##21 object_stat zweite Haelfte, ##20-B-Restbau, W0a-Rest, W0b-Band-A-15-Posten): je eigener Explore noetig -- hier nur als 'kein Erledigt-Beleg gefunden' markiert, nicht positiv widerlegt.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 354
GEGENSTAND: V[3]-nicht_pruefbar[8]: PA-02: die acht P-CI-Einzeldefekte aus PLANABGRENZUNG par.2.3 (docs/sessions/) wurden nicht einzeln gegen den a99c4a18-Diff gehalten (Datei 29KB, par.2.3-Extraktion stand nicht im Budget
ORT: a99c4a18
SOLL/FIX: PA-02: die acht P-CI-Einzeldefekte aus PLANABGRENZUNG par.2.3 (docs/sessions/) wurden nicht einzeln gegen den a99c4a18-Diff gehalten (Datei 29KB, par.2.3-Extraktion stand nicht im Budget; Sammelheilung durch Guard-Neubau + 4x gruener CI-Job belegt).
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 355
GEGENSTAND: V[3]-nicht_pruefbar[9]: WF7 8/8, Marker-Agent 21/21 und die 22 WF8-Fixes einzeln (ZW-02-Rest): nur das WF8-Journal (10/10) wurde als Stichprobe entpackt und gezaehlt.
ORT: unbekannt
SOLL/FIX: WF7 8/8, Marker-Agent 21/21 und die 22 WF8-Fixes einzeln (ZW-02-Rest): nur das WF8-Journal (10/10) wurde als Stichprobe entpackt und gezaehlt.
STATUS LT. QUELLE: offen (nicht pruefbar in der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 356
GEGENSTAND: CODEX-Lens 1, Befund 1: F1/KETTENRISS 'messen->auswerten' [SELBST VERIFIZIERT]
ORT: super/.gitlab-ci.yml
SOLL/FIX: F1/KETTENRISS 'messen->auswerten' [SELBST VERIFIZIERT]: ergebnis:holen (super/.gitlab-ci.yml, Job ab Z.2732) ist ein selbsterklaertes SKELETT -- der scharfe Sammel-Aufruf (mkdir/find/cp der measure_out-CSVs + Uebergabe an persist:measurements) ist AUSKOMMENTIERT; der Job echot den Fluss und zaehlt hoechstens Dateien. Faellender Eingang: ein fertiger dynamischer Messlauf (planer:delegate->ceb->tier->measure) -- seine Zell-CSVs werden von diesem Job nie eingesammelt, der Job endet trotzdem gruen.
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Verarbeitungskette XML->Planer->CEB->Tier->messen->auswerten->release+Hybrid->LaTeX/PDF, geprueft per Codex-Zweit-Lens (gpt, reasoning high, 1 Lauf) ueber 8 am Objekt er

### [wtk6lmhln.json] 357
GEGENSTAND: CODEX-Lens 1, Befund 2: F1/KETTENRISS 'auswerten->release' [SELBST VERIFIZIERT]
ORT: super/.gitlab-ci.yml
SOLL/FIX: F1/KETTENRISS 'auswerten->release' [SELBST VERIFIZIERT]: es existiert KEIN release-Job (grep 'release' in super/.gitlab-ci.yml trifft nur CMAKE_BUILD_TYPE). tools/best_binary_selector (CMakeLists-Kopf: '#172 Versprechen (1): automatische Auswahl + Versand der besten Binary') ist gebaut + unit-getestet (tests/unit/CMakeLists.txt:4591ff, nur parse+rank), hat aber KEINEN Aufrufer in super-CI, ce-CI oder Skripten. Gebaut-ohne-Rufer; 'Versand' existiert nirgends.
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Verarbeitungskette XML->Planer->CEB->Tier->messen->auswerten->release+Hybrid->LaTeX/PDF, geprueft per Codex-Zweit-Lens (gpt, reasoning high, 1 Lauf) ueber 8 am Objekt er

### [wtk6lmhln.json] 358
GEGENSTAND: CODEX-Lens 1, Befund 3: F1/KETTENRISS 'release->Hybrid-Bau' [SELBST VERIFIZIERT]
ORT: hybrid_gate.hpp:89
SOLL/FIX: F1/KETTENRISS 'release->Hybrid-Bau' [SELBST VERIFIZIERT]: die Hybrid-Stufe hat keinen Bau-Pfad. libs/cache_engine/hybrid/ (4 Header, ~955 Z.) wird ausserhalb des Verzeichnisses NUR von tests/unit/test_hy_a1_*.cpp referenziert; hybrid_gate.hpp:89 sagt selbst 'Heute traegt sie nur Identitaet ... (Struktur, nicht Implementierung)' und verweist auf das ungebaute Folgepaket HY-A2. super-CI: 0 Treffer 'hybrid'. Keine App, kein Tool, kein Job erzeugt eine Hybrid-Binary -- deckt sich mit Memory 'Selbstkompilation: es fehlt Steuerung->Compile'.
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Verarbeitungskette XML->Planer->CEB->Tier->messen->auswerten->release+Hybrid->LaTeX/PDF, geprueft per Codex-Zweit-Lens (gpt, reasoning high, 1 Lauf) ueber 8 am Objekt er

### [wtk6lmhln.json] 359
GEGENSTAND: CODEX-Lens 1, Befund 4: F1/KETTENRISS 'Tier-Bau->Cluster-Messung' [SELBST VERIFIZIERT]
ORT: apps/perm_runner/main.cpp | .gitlab-ci.yml:1421-1423
SOLL/FIX: F1/KETTENRISS 'Tier-Bau->Cluster-Messung' [SELBST VERIFIZIERT]: apps/perm_runner/main.cpp (der Tier-Mess-Runner je DLL) wird nur von Unit-Tests gerufen; der Kopfkommentar verschiebt die echte Cluster-Submission auf 'GATE-MAXIMAL' und es gibt keine sbatch/apptainer-Datei im Repo, die ihn faehrt. Der CI-Job visibility:tier-binaries beweist derweil nur PLAN-TEXT: er akzeptiert dokumentiert binary_id=- (Thesis-Profile, .gitlab-ci.yml:1421-1423) und meldet dann 'visibility:tier-binaries OK (Bau-Sichtbarkeit ... surfaced)' -- wahr fuer seinen Gegenstand (dump-Zeilen), beantwortet aber nicht, ob je eine Tier-Binary gebaut wurde.
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Verarbeitungskette XML->Planer->CEB->Tier->messen->auswerten->release+Hybrid->LaTeX/PDF, geprueft per Codex-Zweit-Lens (gpt, reasoning high, 1 Lauf) ueber 8 am Objekt er

### [wtk6lmhln.json] 360
GEGENSTAND: CODEX-Lens 1, Befund 5: F2/KOMMENTAR-VS-CODE (a) [SELBST VERIFIZIERT]
ORT: .gitlab-ci.yml:2198
SOLL/FIX: F2/KOMMENTAR-VS-CODE (a) [SELBST VERIFIZIERT]: measure:golden-320 druckt UNBEDINGT '=== measure:golden-320 OK (... CSVs + regenerierter Anhang unter measure_out/) ===' (.gitlab-ci.yml:2198), obwohl drei Zweige davor den Anhang legal ausfallen lassen: appendix-Build mit '|| echo ...uebersprungen' (Z.2166), Generator-Lauf mit '|| echo honest-empty' (Z.2189), Daten-leer-Skip (Z.2195). Faellender Zustand: appendix_generator_cli-Build schlaegt fehl -> die OK-Zeile behauptet trotzdem einen regenerierten Anhang. Exakt die gesuchte Klasse (Erledigt-Meldung wahr nur fuer den eigenen Gegenstand).
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Verarbeitungskette XML->Planer->CEB->Tier->messen->auswerten->release+Hybrid->LaTeX/PDF, geprueft per Codex-Zweit-Lens (gpt, reasoning high, 1 Lauf) ueber 8 am Objekt er

### [wtk6lmhln.json] 361
GEGENSTAND: CODEX-Lens 1, Befund 6: F2/KOMMENTAR-VS-CODE (b) [SELBST VERIFIZIERT]
ORT: apps/cache_engine_builder/main.cpp | test_data_sets.xml
SOLL/FIX: F2/KOMMENTAR-VS-CODE (b) [SELBST VERIFIZIERT]: apps/cache_engine_builder/main.cpp verlangt in Usage und Kopf '4 XML configs' inkl. test_data_sets.xml und erklaert DIESELBE Datei im selben Kommentar fuer nirgends existent (Z.21-24: 'die Datei existiert nirgends') -- der dokumentierte Eingangs-Zustand ist unerfuellbar. Zudem deklariert sich die CEB-App selbst als 'cache-engine-Demo-Driver' mit fest verdrahtetem Demo-Workload (1000 Keys/500 Ops, Z.177-181); der produktive CEB ist der 1570-Zeilen-Treiber Code/02_messung_driver.
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Verarbeitungskette XML->Planer->CEB->Tier->messen->auswerten->release+Hybrid->LaTeX/PDF, geprueft per Codex-Zweit-Lens (gpt, reasoning high, 1 Lauf) ueber 8 am Objekt er

### [wtk6lmhln.json] 362
GEGENSTAND: CODEX-Lens 1, Befund 7: F2/KOMMENTAR-VS-CODE (c) [CODEX, Kern selbst nachgeprueft]
ORT: hybrid_gate.hpp:32-35
SOLL/FIX: F2/KOMMENTAR-VS-CODE (c) [CODEX, Kern selbst nachgeprueft]: hybrid_gate.hpp:32-35 behauptet, die S3-Schranke ('alle Ziele EINES Gehaeuses teilen dieselbe Gattung ... wird ueber dieselbe Ableitung erzwungen') sei erzwungen -- der Code kennt aber nur das Einzel-Paar HybridZielPaar<Ga,G> bzw. HybridZielBindung (Z.80-96); ein Gehaeuse-Typ, an dem eine MEHR-Ziel-Konsistenz haengen koennte, existiert nicht (HY-A2 offen). S3 ist heute Behauptung ohne Verwendungsstelle.
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Verarbeitungskette XML->Planer->CEB->Tier->messen->auswerten->release+Hybrid->LaTeX/PDF, geprueft per Codex-Zweit-Lens (gpt, reasoning high, 1 Lauf) ueber 8 am Objekt er

### [wtk6lmhln.json] 363
GEGENSTAND: CODEX-Lens 1, Befund 8: F2/KETTEN-ENDE PDF [SELBST VERIFIZIERT, mit Einordnung]
ORT: unbekannt
SOLL/FIX: F2/KETTEN-ENDE PDF [SELBST VERIFIZIERT, mit Einordnung]: der Anspruch endet bei 'Messwerte als LaTeX/PDF', die super-CI endet bei .tex -- Artefakte sind ausschliesslich measure_out*/appendix/**/*.tex (Z.2020, 2210); anhang:forward schiebt die Tabellen ins Thesis-Submodul. Innerhalb der geprueften Kette gibt es kein PDF-Ziel aus Messwerten; ob das Thesis-Repo den PDF-Schluss traegt, war nicht Gegenstand dieser Vorlage und bleibt offen.
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Verarbeitungskette XML->Planer->CEB->Tier->messen->auswerten->release+Hybrid->LaTeX/PDF, geprueft per Codex-Zweit-Lens (gpt, reasoning high, 1 Lauf) ueber 8 am Objekt er

### [wtk6lmhln.json] 364
GEGENSTAND: CODEX-Lens 1, Befund 9: F3/DUeNNSTER BEWEIS -- Rangfolge (Codex, von mir geteilt)
ORT: .gitlab-ci.yml:2604-2729
SOLL/FIX: F3/DUeNNSTER BEWEIS -- Rangfolge (Codex, von mir geteilt): 1. HYBRID (duennste Stufe: nur Concepts/static_asserts + 2 Unit-Tests, ausdruecklich keine Implementierung, kein Binary-/CI-Pfad) * 2. TIER (perm_runner hat echte Lade-/Mess-Logik, ist aber produktiv ungerufen; CI sieht nur Plan-Text statt gebauter Binaries -- die measure:smoke/golden-Pfade messen ueber den Treiber, nicht ueber perm_runner) * 3. CEB (Treiber wird in CI gebaut und im Durchstich real gefahren [measure:smoke Job 376333 measured=1], aber die ce-App ist Demo, und die emittierten Grandchild-Jobs sind der eigentliche, seltener bewiesene Vollzug) * 4. PLANER (staerkster Beweis: eigenes Target gebaut, plan ci real gegen das golden-Profil gefahren, rc hart geprueft, Child-Pipeline via Artefakt + strategy:depend getriggert; .gitlab-ci.yml:2604-2729).
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Verarbeitungskette XML->Planer->CEB->Tier->messen->auswerten->release+Hybrid->LaTeX/PDF, geprueft per Codex-Zweit-Lens (gpt, reasoning high, 1 Lauf) ueber 8 am Objekt er

### [wtk6lmhln.json] 365
GEGENSTAND: CODEX-Lens 1, Befund 10: METHODEN-VORBEHALT
ORT: unbekannt
SOLL/FIX: METHODEN-VORBEHALT: Codex sah einen kuratierten ~50-KB-Ausschnitt (8 Dateien) plus mein grep-Inventar -- Negativ-Aussagen der Klasse 'kein Aufrufer' stammen aus meinen eigenen Greps ueber beide Repos (ohne build-Verzeichnisse) und sind Falsch-Null-anfaellig, wenn Aufrufer unter anderem Namen (z.B. Target- statt Binary-Name) existieren; die Positiv-Funde (Skelett, OK-Zeile, unerfuellbare Usage, Identitaet-statt-Implementierung) sind dagegen woertlich am Objekt belegt.
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Verarbeitungskette XML->Planer->CEB->Tier->messen->auswerten->release+Hybrid->LaTeX/PDF, geprueft per Codex-Zweit-Lens (gpt, reasoning high, 1 Lauf) ueber 8 am Objekt er

### [wtk6lmhln.json] 366
GEGENSTAND: CODEX-Lens 2, Befund 1: F1/GRUEN-OHNE-LAUF (verifiziert)
ORT: ce/scripts/vor_push_alle_wachen.sh
SOLL/FIX: F1/GRUEN-OHNE-LAUF (verifiziert): ce/scripts/vor_push_alle_wachen.sh Z.367-383 -- fehlt cppcheck (COMDARE_CITOOLS_DIR leer, /home/comdare/tools/cppcheck-2.21.0 nicht da, kein cppcheck im PATH), wird 'NICHT GEFAHREN' gedruckt und CPPCHECK_GEFAHREN=0 gesetzt, aber ROT bleibt 0 -> Gesamtausgang GRUEN mit uebersprungener Wache 3 von 3. Eingang: Werkzeug nicht installiert.
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Wachen/Gates beider Repos (super/ci/*.sh, super/scripts/ci_*.sh, ce/scripts/ci_*+lint_*+vor_push_alle_wachen.sh) auf die Klasse "gruen ohne Gegenstand" -- Codex-

### [wtk6lmhln.json] 367
GEGENSTAND: CODEX-Lens 2, Befund 2: F1/LISTE-UNVOLLSTAENDIG (verifiziert)
ORT: ce/scripts/vor_push_alle_wachen.sh
SOLL/FIX: F1/LISTE-UNVOLLSTAENDIG (verifiziert): ce/scripts/vor_push_alle_wachen.sh faehrt hartkodiert genau DREI Wachen (clang-format, ci_diff_ascii_width_guard, cppcheck) und inventarisiert scripts/ci_*.sh nicht -- ~13 weitere Wachen (achsen_roundtrip, stage_topologie, test_bauweg, test_coverage, test_registrierungs, test_sichtbarkeit, xml_wellformed, yaml_key, hy_label, lint_layer, lint_flags, ...) laufen ueber dieses Gate NIE, waehrend der Dateiname 'alle_wachen' verspricht. Die GRUEN-Meldung (Z.478-480) grenzt zwar ehrlich ein ('KEINE Aussage ueber die ungeprueften Gates'), ein Leser des Exit-Codes sieht das nicht. Eingang: jede neue oder nicht gelistete Wache.
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Wachen/Gates beider Repos (super/ci/*.sh, super/scripts/ci_*.sh, ce/scripts/ci_*+lint_*+vor_push_alle_wachen.sh) auf die Klasse "gruen ohne Gegenstand" -- Codex-

### [wtk6lmhln.json] 368
GEGENSTAND: CODEX-Lens 2, Befund 3: F1/NENNER-UEBERZAEHLT (verifiziert, exakt die Klasse der 158/387-Wache von heute)
ORT: ce/scripts/ci_xml_wellformed_guard.sh | super/scripts/ci_xml_wellformed_guard.sh
SOLL/FIX: F1/NENNER-UEBERZAEHLT (verifiziert, exakt die Klasse der 158/387-Wache von heute): ce/scripts/ci_xml_wellformed_guard.sh Z.~118-121 vs. Schlusszeile -- der Nenner ANZ stammt aus 'git ls-files *.xml', die Schleife ueberspringt aber mit '[ -f "$DATEI" ] || continue' jede getrackte, im Arbeitsbaum fehlende Datei OHNE Gegenbuchung -> 'OK ($ANZ XML-Dateien geprueft)' zaehlt Dateien als geprueft, die nie an xmllint gingen. Eingang: getrackte, nicht wohlgeformte XML, die lokal fehlt (z.B. sparse checkout) -> GRUEN. Gleicher Befund gilt fuer super/scripts/ci_xml_wellformed_guard.sh (Schwesterkopie). Positiv: leerer Nenner und Zeilenende-Dateinamen sind dort sauber abgefangen (Exit 2).
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Wachen/Gates beider Repos (super/ci/*.sh, super/scripts/ci_*.sh, ce/scripts/ci_*+lint_*+vor_push_alle_wachen.sh) auf die Klasse "gruen ohne Gegenstand" -- Codex-

### [wtk6lmhln.json] 369
GEGENSTAND: CODEX-Lens 2, Befund 4: F1/PARTIELLE-GRUNDMENGE (verifiziert)
ORT: super/ci/frische_wache.sh
SOLL/FIX: F1/PARTIELLE-GRUNDMENGE (verifiziert): super/ci/frische_wache.sh Z.156 -- find "$WURZEL" ... > "$TMP" 2>/dev/null || true: scheitert find nach Teilausgabe (nicht lesbarer Teilbaum), wird die PARTIELLE CSV-Menge zur Grundgesamtheit und der Fehler verworfen -> GRUEN ueber einer unvollstaendigen Menge. (Die LEERE Menge selbst ist abgefangen: N_DIESER=0 -> Exit 1.)
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Wachen/Gates beider Repos (super/ci/*.sh, super/scripts/ci_*.sh, ce/scripts/ci_*+lint_*+vor_push_alle_wachen.sh) auf die Klasse "gruen ohne Gegenstand" -- Codex-

### [wtk6lmhln.json] 370
GEGENSTAND: CODEX-Lens 2, Befund 5: F1/PIPE-RC + WORTZERLEGUNG (verifiziert)
ORT: ce/scripts/lint_layer_includes.sh
SOLL/FIX: F1/PIPE-RC + WORTZERLEGUNG (verifiziert): ce/scripts/lint_layer_includes.sh Z.42+56-57 -- DATEIEN=$(find|sort) misst ohne pipefail nur sort; 'for f in $DATEIEN' zerlegt Dateinamen an Leerzeichen und '|| true' maskiert die folgenden grep-Lesefehler -> ein Header mit Leerzeichen im Namen wird im Nenner GEZAEHLT, aber nie geprueft. (Codex' Zusatzbehauptung 'leerer Scope wird gruen' ist am Objekt FALSCH: Z.49-53 bricht bei 0 Headern mit Exit 2 ab.)
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Wachen/Gates beider Repos (super/ci/*.sh, super/scripts/ci_*.sh, ce/scripts/ci_*+lint_*+vor_push_alle_wachen.sh) auf die Klasse "gruen ohne Gegenstand" -- Codex-

### [wtk6lmhln.json] 371
GEGENSTAND: CODEX-Lens 2, Befund 6: F1/PIPE-RC (verifiziert)
ORT: ce/scripts/ci_yaml_key_guard.sh | ce/scripts/ci_achsen_roundtrip_wache.sh
SOLL/FIX: F1/PIPE-RC (verifiziert): ce/scripts/ci_yaml_key_guard.sh Z.146 -- _ce_dupes=$(printf|cut|sort|uniq -d) ohne pipefail: faellt cut oder sort aus, endet uniq erfolgreich mit leerer Eingabe -> _ce_dupes leer -> GRUEN trotz real doppelter Top-Level-Schluessel. Analog ce/scripts/ci_achsen_roundtrip_wache.sh Z.141-142: FEHLT/ZUVIEL aus comm mit '|| true' -- faellt comm aus, entfaellt der Soll/Ist-Mengenvergleich still.
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Wachen/Gates beider Repos (super/ci/*.sh, super/scripts/ci_*.sh, ce/scripts/ci_*+lint_*+vor_push_alle_wachen.sh) auf die Klasse "gruen ohne Gegenstand" -- Codex-

### [wtk6lmhln.json] 372
GEGENSTAND: CODEX-Lens 2, Befund 7: F1/SYSTEMISCH (eigenes Screening 13.08., alle 36 Nicht-Selbsttest-Wachen)
ORT: ci_diff_ascii_width_guard.sh | super/ci/thesis_gitlink_parity.sh
SOLL/FIX: F1/SYSTEMISCH (eigenes Screening 13.08., alle 36 Nicht-Selbsttest-Wachen): ausser den beiden ci_diff_ascii_width_guard.sh setzt KEINE Wache 'set -o pipefail' -- jede cmd|filter-Kette misst den Filter statt des Befehls. Betroffen u.a. super/ci/thesis_gitlink_parity.sh Z.115-125, dessen Kopfkommentar sogar explizit behauptet 'set -e greift' -- in der Pipe git|awk traegt der rc nur awk; git-Teilausfall nach Teilausgabe ist unsichtbar. (Leere Gitlink-Werte fallen dort immerhin fail-closed, Z.132-146.)
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Wachen/Gates beider Repos (super/ci/*.sh, super/scripts/ci_*.sh, ce/scripts/ci_*+lint_*+vor_push_alle_wachen.sh) auf die Klasse "gruen ohne Gegenstand" -- Codex-

### [wtk6lmhln.json] 373
GEGENSTAND: CODEX-Lens 2, Befund 8: F2/KEIN-NENNER (verifiziert)
ORT: ce/scripts/ci_yaml_key_guard.sh | super/ci/thesis_gitlink_parity.sh | ce/scripts/vor_push_alle_wachen.sh
SOLL/FIX: F2/KEIN-NENNER (verifiziert): ce/scripts/ci_yaml_key_guard.sh Z.188 GRUEN-Zeile 'SCHLUESSEL-WACHE: GRUEN -- jeder Top-Level-Schluessel genau einmal definiert.' traegt kein N-von-M (die Zahlen stehen nur weiter oben im Log, nicht im Urteil). super/ci/thesis_gitlink_parity.sh Z.161 'Thesis-Gitlink-Paritaet OK ...' ohne Nenner (Gegenstand ist fix 2 Zeiger -- formaler Befund). ce/scripts/vor_push_alle_wachen.sh nennt Datei-Nenner, aber kein 'N von M WACHEN gefahren' als Zahl. Positiv-Gegenprobe: anker_wache, frische_wache, xml_wellformed, lint_layer_includes, achsen_roundtrip drucken alle einen expliziten Nenner ('nie eine nackte Null').
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Wachen/Gates beider Repos (super/ci/*.sh, super/scripts/ci_*.sh, ce/scripts/ci_*+lint_*+vor_push_alle_wachen.sh) auf die Klasse "gruen ohne Gegenstand" -- Codex-

### [wtk6lmhln.json] 374
GEGENSTAND: CODEX-Lens 2, Befund 9: F3/ANWESENHEIT-STATT-BEDINGUNG (verifiziert)
ORT: super/ci/anker_wache.sh
SOLL/FIX: F3/ANWESENHEIT-STATT-BEDINGUNG (verifiziert): super/ci/anker_wache.sh Z.112 -- sed -n "${soll}p" | grep -qF "$sym": SUBSTRING-Treffer genuegt; traegt die Soll-Zeile das Symbol als Teil eines laengeren Bezeichners oder in einem Kommentar, ist der Anker GRUEN, obwohl dort nicht der behauptete Gegenstand steht. Dazu Z.73-75: die Anker-Extraktion haengt an '|| true' und awk 'NF>=4' wirft malformed ANKER-SYMBOL-Zeilen STILL aus der Grundmenge -- ein kaputter Anker verschwindet aus dem Nenner statt rot zu werden.
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Wachen/Gates beider Repos (super/ci/*.sh, super/scripts/ci_*.sh, ce/scripts/ci_*+lint_*+vor_push_alle_wachen.sh) auf die Klasse "gruen ohne Gegenstand" -- Codex-

### [wtk6lmhln.json] 375
GEGENSTAND: CODEX-Lens 2, Befund 10: F3/REGISTRIERUNG-STATT-WIRKUNG (verifiziert)
ORT: ce/scripts/ci_achsen_roundtrip_wache.sh | ce/scripts/vor_push_alle_wachen.sh
SOLL/FIX: F3/REGISTRIERUNG-STATT-WIRKUNG (verifiziert): ce/scripts/ci_achsen_roundtrip_wache.sh Z.117 -- ctest -N listet nur REGISTRIERTE Testnamen; die Wache ist GRUEN, wenn die 3 Roundtrip-Gates registriert sind, egal ob sie je laufen oder was sie tun (ein /bin/true-Dummy gleichen Namens waere GRUEN). Gleiches Muster im Meta-Gate: ce/scripts/vor_push_alle_wachen.sh Z.327-332 prueft Unterwachen-EXISTENZ + Exit 0, liest aber deren Nenner nicht -- eine Unterwache, die '0 geprueft' meldet und mit rc=0 endet, ginge als GRUEN durch.
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Wachen/Gates beider Repos (super/ci/*.sh, super/scripts/ci_*.sh, ce/scripts/ci_*+lint_*+vor_push_alle_wachen.sh) auf die Klasse "gruen ohne Gegenstand" -- Codex-

### [wtk6lmhln.json] 376
GEGENSTAND: CODEX-Lens 2, Befund 11: F3/MUSTER-ZU-ENG (verifiziert)
ORT: ce/scripts/lint_layer_includes.sh
SOLL/FIX: F3/MUSTER-ZU-ENG (verifiziert): ce/scripts/lint_layer_includes.sh Z.57 -- Muster '#include.*builder/' verfehlt das gueltige Praeprozessor-Include '# include "...builder/..."' (Leerraum zwischen # und include ist erlaubt) -> die verbotene Schichtkante anatomy->builder existiert und die Wache bleibt GRUEN. Analog ci_yaml_key_guard: Rohtext-Vergleich der Schluessel behandelt job: und "job": als verschieden -- dasselbe YAML-Duplikat bleibt GRUEN.
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Wachen/Gates beider Repos (super/ci/*.sh, super/scripts/ci_*.sh, ce/scripts/ci_*+lint_*+vor_push_alle_wachen.sh) auf die Klasse "gruen ohne Gegenstand" -- Codex-

### [wtk6lmhln.json] 377
GEGENSTAND: CODEX-Lens 2, Befund 12: META/KRITIK-FEHLERQUOTE
ORT: f8cff2c8 | f23c18e2
SOLL/FIX: META/KRITIK-FEHLERQUOTE: von Codex' Einzelbefunden fielen 2 am Objekt (lint_layer_includes 'leerer Scope gruen' -- abgefangen mit Exit 2; thesis_gitlink_parity 'beide git-Fehler -> GRUEN' -- leere Werte fallen fail-closed, nur die enge Pipe-rc-Form traegt). Alle oben als 'verifiziert' markierten Befunde habe ich selbst an den Quelldateien nachgelesen; die Zeilennummern der kopierten Dateien entsprechen dem Stand development@f8cff2c8/f23c18e2.
STATUS LT. QUELLE: offen (Codex-Befund, tragende Kerne vom Lead am Objekt nachgemessen)
ABHAENGIGKEIT/FLAECHE: Lens-Gegenstand: Wachen/Gates beider Repos (super/ci/*.sh, super/scripts/ci_*.sh, ce/scripts/ci_*+lint_*+vor_push_alle_wachen.sh) auf die Klasse "gruen ohne Gegenstand" -- Codex-

### [wtk6lmhln.json] 378
GEGENSTAND: SYNTHESE-BILANZ (verbatim)
ORT: unbekannt
SOLL/FIX: GESAMT: 538 Erledigt-Behauptungen (11.-13.08.) in 4 Verifikationslaeufen am Objekt geprueft -- 311 halten voll (58%), 190 nur teilweise (35%), 19 fallen hart (3,5%), 18 gegenstandslos/ueberholt (3,3%). JE QUELLE: V1 Task-Store (T-01..T-36, Q-01..Q-07): 169 geprueft -- 133 halten / 31 teilweise / 2 fallen / 3 gegenstandslos. V2 Nacht-/Sessions-Behauptungen (L/B/W/P/D/Z/F): 106 geprueft -- 60 / 42 / 4 / 0. V3 Referenz-Dokumente Wellenplan+Designplan+GOAL+Strecke (REF/STR/OF/W7/WP/DP): 139 geprueft -- 45 / 75 / 8 / 11 -- die drift-anfaelligste Quelle: nur 32% halten voll. V4 nacht-8/9 + KON56-58 + S-14a/Q6 (N9/N8/GU/N7*/P7*/RG/PA/L5x/CX/PZW/SB): 124 geprueft -- 73 / 42 / 5 / 4. LENS A (Kette, Codex 1 Lauf ueber 8 Dateien): 9 tragende Befunde -- 4 Kettenrisse + 3 Kommentar-vs-Code + PDF-Ende + Rangfolge, alle Kerne vom Lead am Objekt nachgemessen, 0 Ausfall. LENS B (36 Wachen, Codex 3 kleine Laeufe): 13 Einzelbefunde, 11 am Objekt bestaetigt, 2 fielen an der Kritik selbst (15% Kritik-Fehlerquote -- konsistent zur 13/40-Hausquote); dazu 1 systemischer Eigenfund (34 von 36 Wachen ohne pipefail). NICHT PRUEFBAR blieb ausdruecklich: alle Task-completed-Flags (kein TaskList in den Verify-Rollen), lokale Kombibau-Wiederholungen und Mutations-Laeufe (read-only-Auftrag, Bau-Agent aktiv in wt-ce-golden-s14a), Transkript-Wortlaut-Abgleiche (KON7/KON22-Zitate, Kuerzungs-Regel), die Explore-Artefakte wq3sh10mx/wo0oghvqu (nirgends auf Platte), 4 historische PZW-Pipeline-Nummern (einzige Quelle: der Designplan selbst), '198 Diff-Zeilen' und '1802 Z. Vorarbeit' (keine Messform/kein Ort), ce-Store-fsck, mod=0 geloeschter Worktrees. LAUFZEIT-VORBEHALT: der Bau-Agent committete WAEHREND der Pruefung Fixup 3 (8cc564d5) -- S-14a-Urteile nennen Stand vor UND nach.
STATUS LT. QUELLE: nur-hinweis (Bilanz)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 379
GEGENSTAND: SYNTHESE NE-01 [L57-01/GU-02] [BLOCKER, Frist F1 morgen]: ##25 CI-bewiesen (15764, 35/35, measured=1) = F1-Lieferung erbracht
ORT: unbekannt
SOLL/FIX: F1 ist zweigliedrig (GOAL :517): (1) kein Beleg, dass der frische 376333-Messwert die Kette bis zur Tabellenzeile im Thesis-PDF durchlief (nur: alle Kettenjobs derselben Pipeline gruen); (2) Glied Nenner-Ehrlichkeit/W0a nirgends als abgenommen verbucht
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=BLOCKER, Frist=F1 morgen

### [wtk6lmhln.json] 380
GEGENSTAND: SYNTHESE NE-02 [WP-03] [ERNST, Frist F1 morgen]: W0a-Rest (D1e, D1f, D1c, D2-G2, ##06-CI-Haelfte, ##07) laeuft mit Frist 12.08.
ORT: unbekannt
SOLL/FIX: Frist VERGANGEN, kein Erledigt-Beleg in KON40-57, kein Slot in Teil B -- sechs verschollene Posten; D2-G6-Status zusaetzlich nie erhoben
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=F1 morgen

### [wtk6lmhln.json] 381
GEGENSTAND: SYNTHESE NE-03 [WP-04/PA-01] [ERNST, Frist F1 morgen]: W0b-Rest: 10 Posten bis F1
ORT: unbekannt
SOLL/FIX: 5 von 10 ohne Beleg: D3-4+D3-5 (Bau fehlt), D3-8, ##08-Rest, ##20-B-Restbau, ##23-R1, ##28-##31; von den 12 PA-Posten sind 3/5/6/7/9/10/11 unbelegt
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=F1 morgen

### [wtk6lmhln.json] 382
GEGENSTAND: SYNTHESE NE-04 [STR-06/GU-03/SB-01] [ERNST, Frist F1 morgen]: #10 MinIO-Keys + 776-Rotation + test:secrets aus prod2 (13.08. faellig)
ORT: unbekannt
SOLL/FIX: Werte-Smoke nie gefahren (nur Existenz der 4 Variablen per API); test:secrets existiert in KEINEM Repo (Zielort unbestimmt); '776-Rotation' war Fehldeutung (776 = gitleaks-Trefferzahl, KON2-02: Anzahl Registration-Tokens)
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=F1 morgen

### [wtk6lmhln.json] 383
GEGENSTAND: SYNTHESE NE-05 [T-22d/STR-09/L58-09/L58-10] [ERNST, Frist F1 morgen]: OD-7-Umsetzung 24->16 spezifiziert, Handout geschrieben
ORT: runner-mode.sh:43
SOLL/FIX: Handout UNTRACKED im Cluster-Repo (nie committet/gepusht/zugestellt); runner-mode.sh:43 prod1 traegt weiter HEAVY_J=24; die 3 datierten Ledger-Marker (:17446/:17511/par.69.6) fehlen
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=F1 morgen

### [wtk6lmhln.json] 384
GEGENSTAND: SYNTHESE NE-06 [STR-12/SB-03] [ERNST, Frist F1 morgen]: #21 Pruefposten E-1..E-4 + A-1-Vorlagetext bis Fr komplett
ORT: unbekannt
SOLL/FIX: Kein Artefakt (docs 13.08. leer); der A-1-Teil ist durch den Backup-Ref-Verlust zur Owner-Frage geworden, nicht mehr abarbeitbar
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=F1 morgen

### [wtk6lmhln.json] 385
GEGENSTAND: SYNTHESE NE-07 [N7-07] [ERNST, Frist F1 morgen]: #81: Verify ueber die W0b-Bauposten wiederholen (Owner-Auftrag)
ORT: unbekannt
SOLL/FIX: Nirgends als gefahren verbucht -- kein Wiederhol-Verify mit Pipeline-Messung auffindbar
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=F1 morgen

### [wtk6lmhln.json] 386
GEGENSTAND: SYNTHESE NE-08 [KON58/L58-10] [ERNST, Frist F1 morgen]: KON57-Landesequenz dokumentiert, KON58 verfasst
ORT: unbekannt
SOLL/FIX: Ledger-Kopf = KON57: der VOLLZUG der Landesequenz (15770/15771/15773/15774 alle success, per API belegt) und der komplette KON58-Entwurf (Backup-Ref-Frage, 776-Aufklaerung, Marker-Zusagen) stehen nicht im Ledger
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=F1 morgen

### [wtk6lmhln.json] 387
GEGENSTAND: SYNTHESE NE-09 [GU-06/Z-62/WP-55] [ERNST, Frist F1 morgen]: MEMORY gepflegt (Kopf auf lebenden Stand)
ORT: unbekannt
SOLL/FIX: Kopf = KON36, Ledger = KON57 (21 Stufen Rueckstand); Wallclock-SOLL + E-Label als 'NEU offen -> Owner-Fragen' gefuehrt, obwohl seit KON37 beantwortet -- jeder Agent startet mit falschem Fragenstand
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=F1 morgen

### [wtk6lmhln.json] 388
GEGENSTAND: SYNTHESE NE-10 [WP-49/STR-08] [ERNST, Frist F1 morgen]: S-3/S-7: beide Seiten gebaut UND inert -- morgen nur aktivieren
ORT: unbekannt
SOLL/FIX: Konjunktion nicht je Seite mit 2 Zahlen belegt; bvset_ist_teilmenge hat 2 PRODUKTIONS-Treffer im build_orchestrator -- 'inert' teilwiderlegt; vor der Aktivierung beide Seiten benennen und je (existiert + Nenner) messen
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=F1 morgen

### [wtk6lmhln.json] 389
GEGENSTAND: SYNTHESE NE-11 [W-02/B-08/P-06] [ERNST, Frist F1 morgen]: Rohdaten gesichert, Lande-Skript etabliert, Loeschregel gilt
ORT: landung-kombibau.sh
SOLL/FIX: WF-Rohdaten-Backups liegen untracked NUR im Landungs-Worktree (ein worktree remove fraesse sie); landung-kombibau.sh (2x2-Pflicht) lebt nur im fluechtigen Job-tmp; P-06-Loeschregel existiert nur als Memory, nicht als Werkzeug -- fuer keine Loeschung existiert ein Ref-Pruefprotokoll
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=F1 morgen

### [wtk6lmhln.json] 390
GEGENSTAND: SYNTHESE NE-12 [T-16a/T-33b/CX-03/L58-01] [BLOCKER, Frist F2 21.08.]: S-14a Teil 1 gebaut+verifiziert (TRAEGT), Fixups komplett
ORT: bau/golden-s14a-riegel
SOLL/FIX: Der Verify-TRAEGT war teilmengen-wahr (152 von 387 Headern bewacht); die Heilung (Overlay-Grundgesamtheit 718, Fixup 1-3) liegt UNGELANDET auf bau/golden-s14a-riegel -- preimage-wirksam (Fingerprint-Glied [7] hasht ueber die Lock-Menge): Landung + CI-Beweis muessen VOR den Freeze
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=BLOCKER, Frist=F2 21.08.

### [wtk6lmhln.json] 391
GEGENSTAND: SYNTHESE NE-13 [STR-10] [BLOCKER, Frist F2 21.08.]: golden Version festschreiben (13.08. faellig, #16-Voraussetzung)
ORT: a8465ef3
SOLL/FIX: Kein golden-Datenversions-Artefakt in super development; die Lock-Baseline a8465ef3 ist der STELLVERTRETER (Achsen-Lock), nicht die golden-Datenbasis-Version
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=BLOCKER, Frist=F2 21.08.

### [wtk6lmhln.json] 392
GEGENSTAND: SYNTHESE NE-14 [N9-16/PZW-01/T-34i] [ERNST, Frist F2 21.08.]: Gitlink-Zuege vollstaendig, Fussnote vorbereitet
ORT: pzw-fussnote-siebter-zug.md | 7d65eb6c | f23c18e2
SOLL/FIX: 7. Zug nicht vollzogen: super fuehrt Gitlink 7d65eb6c, ce development = f23c18e2; pzw-fussnote-siebter-zug.md liegt nur im tmp
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=F2 21.08.

### [wtk6lmhln.json] 393
GEGENSTAND: SYNTHESE NE-15 [L58-04/T-32e/T-33e] [ERNST, Frist F2 21.08.]: Kombibau vollstaendig lokal 4x486/486, 'dem CI bleibt nichts nachzudecken'
ORT: unbekannt
SOLL/FIX: Nur 1 von 4 Zellen belegt (gcc-deb-Log); gcc-release/clang-debug/clang-release-Logs existieren nirgends -- KON55-2x2-Pflicht vor der S-14a-Landung unerfuellt; der CI-Zusatz ist zudem falsch (CI faehrt Jobklassen, die lokal nicht existieren)
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=F2 21.08.

### [wtk6lmhln.json] 394
GEGENSTAND: SYNTHESE NE-16 [RG-04] [ERNST, Frist F2 21.08.]: T-6-Wachen-Inventar deckt jede neue Wache
ORT: test_t6_wachen_inventar.cpp
SOLL/FIX: test_t6_wachen_inventar.cpp kennt den S-14a-CI-Job nicht (Kombibau blieb trotzdem gruen) -- Inventar-Nenner unbestimmt; vor der Landung klaeren, sonst ist die naechste Wache wieder unbewacht
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=F2 21.08.

### [wtk6lmhln.json] 395
GEGENSTAND: SYNTHESE NE-17 [GU-04/L58-13/T-10d/Q-04] [ERNST, Frist F2 21.08.]: A-1/Backup-Refs nach gestufter Fassung behandelt
ORT: 20260802
SOLL/FIX: refs/backup/pre-secret-scrub-20260802 ist von BEIDEN origins ohne Bundle und ohne verbuchtes GO verschwunden (O-5 verlangte: stehen lassen -> Bundle -> DANN loeschen); die Owner-Frage existiert nur im ungelandeten KON58-Entwurf -- als Ledger-NACHTRAG buchen + naechste Owner-Vorlage
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=F2 21.08.

### [wtk6lmhln.json] 396
GEGENSTAND: SYNTHESE NE-18 [Z-06] [ERNST, Frist F2 21.08.]: admit_organ_on_machine NUR aus Tests gerufen -- KEIN Produktionspfad (KON45-02-Grundlage)
ORT: build_orchestrator.hpp:761
SOLL/FIX: Falschbuchung: build_orchestrator.hpp:761 ruft produktiv seit 19.07.; inert nur, weil required-Mengen leer. Ledger-Korrektur 'vorhanden, aber inert' -- die OF-4-Antwort (Comp-Gate-Schicht) stuetzte sich auf die falsche Messung (A2.2-Falle: Konsument statt Gegenstand)
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=F2 21.08.

### [wtk6lmhln.json] 397
GEGENSTAND: SYNTHESE NE-19 [Lens B F1-F3] [ERNST, Frist F2 21.08.]: Wachen-/Gate-Landschaft bewacht die Strecke
ORT: unbekannt
SOLL/FIX: Klasse 'gruen ohne Gegenstand' systemisch: 34/36 Wachen ohne pipefail; vor_push_alle_wachen GRUEN bei fehlendem cppcheck UND faehrt nur 3 von ~16 Wachen (kein Inventar); xml_wellformed zaehlt uebersprungene Dateien als geprueft (Schwesterkopie beidseitig); anker_wache: Substring-Treffer genuegt + malformed Anker fallen STILL aus dem Nenner; achsen_roundtrip prueft Registrierung statt Wirkung; lint_layer verfehlt '#  include'; frische_wache akzeptiert partielle find-Menge
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=F2 21.08.

### [wtk6lmhln.json] 398
GEGENSTAND: SYNTHESE NE-20 [T-14d/N8-03/REF-10] [ERNST, Frist F2 21.08.]: 0 allow_failure/when:never, Gegenprobe biss
ORT: unbekannt
SOLL/FIX: Diff-wahr, Baum-falsch: 3 aktive allow_failure:true (ce :257 arm64-smoke, :898 relock-manual, super :2751 ergebnis:holen) gegen die Doktrin 'allow_failure VERBOTEN', nirgends als Ausnahme deklariert -- deklarieren oder entfernen
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=F2 21.08.

### [wtk6lmhln.json] 399
GEGENSTAND: SYNTHESE NE-21 [DP-30] [ERNST, Frist F2 21.08.]: Designplan-Drift-Nachtrag par.10 vollstaendig (bis KON38)
ORT: unbekannt
SOLL/FIX: Testrelevante Neuerungen KON39-57 fehlen: Warmup-PAAR-Pflichttests (KON47-04: Paar-Zaehlung 2x3, --debug-Zweig, Verwerf-Beweis), clang+gcc-2x2-Matrix (KON55), Mutations-Protokollklasse (KON57) -- der TDD-Vertrag kennt sie nicht
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=F2 21.08.

### [wtk6lmhln.json] 400
GEGENSTAND: SYNTHESE NE-22 [STR-24] [ERNST, Frist F2 21.08.]: Datei-Mengen-Explore A<->E vor Mo 17.08. (Schnittmenge als Dateiliste)
ORT: unbekannt
SOLL/FIX: Kein Explore-Artefakt, keine zwei Dateimengen, keine Schnittmengen-Liste -- B5-Lande-Slot-Entscheidung ungedeckt
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=F2 21.08.

### [wtk6lmhln.json] 401
GEGENSTAND: SYNTHESE NE-23 [T-30e] [ERNST, Frist F2 21.08.]: WARTE-Liste W-A..W-D bleibt ausdruecklich liegen
ORT: unbekannt
SOLL/FIX: Die Liste existiert NUR im abgeschlossenen Task-Text -- in kein Plandokument/Ledger uebertragen; ohne Nachtrag verloren
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=F2 21.08.

### [wtk6lmhln.json] 402
GEGENSTAND: SYNTHESE NE-24 [Z-42/Z-56/SB-02/WP-46] [HINWEIS, Frist F2 21.08.]: S-14-Stand '7 von 130 markiert, lock 9' bzw. '6/136 gedeckt'
ORT: unbekannt
SOLL/FIX: Am Objekt: 0 axes-Marker (nur 6 heuristik + 1 measurement), Lock = 6 Datei-Eintraege (9 = wc -l inkl. Kommentare), 136/371 sind Fehl-/Drift-Nenner (real 345/387 je Zaehlweise); KON12-02 deprecaten, 'bump-pflichtig' schriftlich definieren
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=HINWEIS, Frist=F2 21.08.

### [wtk6lmhln.json] 403
GEGENSTAND: SYNTHESE NE-25 [Z-45/Z-48/P7-01] [HINWEIS, Frist F2 21.08.]: Memory-Zahlen korrigiert (153 zurueckgezogen; Rollen-Zaehlung 'zwei von fuenf')
ORT: unbekannt
SOLL/FIX: 153er-Eintrag steht unveraendert (Vorkommen vs. Literal-Zeilen unaufgeschluesselt: 125 von 153 gedeckt); Rollen-Zaehlung inzwischen in die ANDERE Richtung ueberholt (derive_key_from_lines hat Produktionsaufrufer) -- neu erheben, weder 4 noch 2 stimmt
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=HINWEIS, Frist=F2 21.08.

### [wtk6lmhln.json] 404
GEGENSTAND: SYNTHESE NE-26 [WP-39/WP-59/REF-13/REF-12/REF-14/GU-09/WP-44/ZW-01/WP-56/F-04] [HINWEIS, Frist F2 21.08.]: Marker/Streichungen an ueberholten Stellen gesetzt (A.5 u.a.)
ORT: unbekannt
SOLL/FIX: ~20 Stellen ohne Vollzug: 6x O-2-ENTFAELLT, T-15b-Fussnoten par.2-D4/par.7, par.17.1-F5/F7-Wortlaut, [D-5] an par.2/K7, 3x F11-Invariante, 2x 'Do 14.08.', Wellenplan-Kopf-FORTSCHREIBUNG, par.17.1-OFFEN-Tabelle (5 ueberholte Zeilen), K-1 ohne lebende Bedingung, par.13.5c/par.13.6/par.14.2/par.14.7 unmarkiert, KON28-03/KON34-Altstellen ohne Rueckverweis, '28 InputIfFileExists' (gemessen 12)
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=HINWEIS, Frist=F2 21.08.

### [wtk6lmhln.json] 405
GEGENSTAND: SYNTHESE NE-27 [T-34h] [HINWEIS, Frist F2 21.08.]: gitleaks-Regel-Klassen-Lehre in Arbeitsweise/Fallen-Register
ORT: unbekannt
SOLL/FIX: Memory+Fallen-Register haben sie, ARBEITSWEISE v3.9 traegt keinen glpat-Passus (grep=0) und ein Ledger-NACHTRAG fehlt
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=HINWEIS, Frist=F2 21.08.

### [wtk6lmhln.json] 406
GEGENSTAND: SYNTHESE NE-28 [L-22] [HINWEIS, Frist F2 21.08.]: 4 Landungen 11.08., vierte 'Pipeline offen'
ORT: 75505b9d
SOLL/FIX: Die vierte (75505b9d, Pipeline 15678) endete ROT (Kind-Pipeline coverage-guard) und wurde im Ledger nie geschlossen; Deckung kam erst von Folge-Commits -- Nachtrag setzen
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=HINWEIS, Frist=F2 21.08.

### [wtk6lmhln.json] 407
GEGENSTAND: SYNTHESE NE-29 [N7-06/WP-10/Z-44/Z-19] [HINWEIS, Frist F2 21.08.]: Zaehlwerke belastbar (137 Flags; #67 142/29; 'neun von elf unverdrahtet')
ORT: unbekannt
SOLL/FIX: 137-vs-123 unaufgeklaert, keine dokumentierte Zaehlweise; #67-Kanten ohne Definition; Unverdrahtet-Inventur nachweislich zu hoch (mind. 3 der 11 verdrahtet: Director, Fanout, admit_organ) -- vor Bau-Posten-Schnitt neu erheben; measurement_tooling-Fanout im Ledger fortschreiben (sonst plant jemand Gebautes)
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=HINWEIS, Frist=F2 21.08.

### [wtk6lmhln.json] 408
GEGENSTAND: SYNTHESE NE-30 [LensA-F1a/PA-01(8)] [ERNST, Frist Bau-Trigger 26.08.]: Kette messen->auswerten steht
ORT: unbekannt
SOLL/FIX: ergebnis:holen ist selbsterklaertes SKELETT (Sammel-cp auskommentiert) + allow_failure:true -- Zell-CSVs dynamischer Vollmesslaeufe wuerden nie eingesammelt, Job endet gruen
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=Bau-Trigger 26.08.

### [wtk6lmhln.json] 409
GEGENSTAND: SYNTHESE NE-31 [LensA-F1b] [ERNST, Frist Bau-Trigger 26.08.]: Kette auswerten->release steht
ORT: unbekannt
SOLL/FIX: KEIN release-Job in super-CI; best_binary_selector (Versprechen #172: Auswahl+Versand) gebaut+unit-getestet, aber 0 Aufrufer in CI/Skripten; 'Versand' existiert nirgends
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=Bau-Trigger 26.08.

### [wtk6lmhln.json] 410
GEGENSTAND: SYNTHESE NE-32 [LensA-F1d] [ERNST, Frist Bau-Trigger 26.08.]: Tier-Bau->Cluster-Messung nachgewiesen
ORT: unbekannt
SOLL/FIX: perm_runner produktiv ungerufen (nur Unit-Tests; Cluster-Submission auf GATE-MAXIMAL verschoben, keine sbatch/apptainer-Datei); visibility:tier-binaries akzeptiert binary_id='-' und meldet OK -- beweist Plan-TEXT, nie eine gebaute Tier-Binary (V0-Klasse)
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=Bau-Trigger 26.08.

### [wtk6lmhln.json] 411
GEGENSTAND: SYNTHESE NE-33 [LensA-F2a] [ERNST, Frist Bau-Trigger 26.08.]: measure:golden-320 meldet 'OK (CSVs + regenerierter Anhang)'
ORT: unbekannt
SOLL/FIX: Die OK-Zeile ist UNBEDINGT (yml :2198), obwohl drei Zweige davor den Anhang legal ausfallen lassen ('|| echo' :2166/:2189/:2195) -- exakt die gesuchte Erledigt-Meldungs-Klasse; OK-Zeile bedingen
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=Bau-Trigger 26.08.

### [wtk6lmhln.json] 412
GEGENSTAND: SYNTHESE NE-34 [STR-21] [ERNST, Frist Bau-Trigger 26.08.]: Trigger-Kriterium Mi 26.08. definiert (8 Teile)
ORT: unbekannt
SOLL/FIX: 0 von 8 Teilbedingungen hat einen Nachweis-Gegenstand mit Messkommando; '#68 oder dokumentierter Verzicht' hat kein datiertes Dokument -- Frist laeuft, aber ohne Nachweisliste ist der Trigger nicht pruefbar
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=Bau-Trigger 26.08.

### [wtk6lmhln.json] 413
GEGENSTAND: SYNTHESE NE-35 [WP-38/LensA-F2b/F2c] [HINWEIS, Frist Bau-Trigger 26.08.]: S-12-Grundlagen + CEB/Hybrid-Selbstauskuenfte tragen
ORT: test_data_sets.xml | hybrid_gate.hpp:32-35
SOLL/FIX: Die sieben Owner-Zusagen S1..S7 sind nirgends einzeln fixiert (nur der 11.08.-Satz); cache_engine_builder verlangt per Usage die nirgends existente test_data_sets.xml und ist Demo-Driver; hybrid_gate.hpp:32-35 behauptet erzwungene S3-Schranke ohne Gehaeuse-Typ (HY-A2 offen)
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=HINWEIS, Frist=Bau-Trigger 26.08.

### [wtk6lmhln.json] 414
GEGENSTAND: SYNTHESE NE-36 [RG-03/N7c-06] [ERNST, Frist danach]: Lande-Stufe in den Workflow eingebaut; Platzhalter-Gate in kuenftigen Workflows
ORT: unbekannt
SOLL/FIX: In keinem auffindbaren Workflow-Skript nachweisbar (kein wf12*.js; Landungen laufen von Hand) -- beide Lehren leben nur als Text
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=ERNST, Frist=danach

### [wtk6lmhln.json] 415
GEGENSTAND: SYNTHESE NE-37 [T-28b/WP-25/N7b-04] [HINWEIS, Frist danach]: S-16-Menge benannt; Register leerer Klassen angelegt
ORT: unbekannt
SOLL/FIX: Die '13 Dateien/7.967 Z.' nie als Liste materialisiert und Repo-Angabe fehlt in beiden Plaenen (real: super ci/tests, 14 Dateien/8.599 Z.); das Register existiert nur als Sessions-Bericht, nicht als pflegbares Artefakt
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=HINWEIS, Frist=danach

### [wtk6lmhln.json] 416
GEGENSTAND: SYNTHESE NE-38 [P-03/N8-12/T-21b] [HINWEIS, Frist danach]: Klon-Ordnung = Zielzustand (W-6 geschlossen)
ORT: unbekannt
SOLL/FIX: Der ENTSCHEID ist zu, das Ist nicht: 3 ce-Branches vom 10.08. (p2/p3/p6) weiter ungelandet, Haupt-Klon-ce steht auf b-m2-pmc-invariante -- #88-Konsolidierung (Owner: beim Aufraeumen, nicht vor F1/F2)
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Schwere=HINWEIS, Frist=danach

### [wtk6lmhln.json] 417
GEGENSTAND: NACHIMPLEMENTIERUNG: F1-Endbeleg PDF-Tabellenzeile [mittel]
ORT: MANUAL_RUN.md
SOLL/FIX: Im 15764-Artefaktbestand nachweisen, dass der 376333-Messwert via anhang:forward als Tabellenzeile im Thesis-Submodul/PDF gelandet ist (Thesis-Commit + .tex-Zeile aufsuchen); fehlt sie: anhang:forward fuer f1_durchstich nachfahren; Befund als Abnahmeblock in super MANUAL_RUN.md par.8b + Ledger-NACHTRAG; W0a-Nenner-Ehrlichkeit als abgenommen verbuchen
STATUS LT. QUELLE: offen (Nachimplementierungs-Auftrag)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 418
GEGENSTAND: NACHIMPLEMENTIERUNG: KON58-Ledger-Landung [mittel]
ORT: scripts/ledger_nachtrag.sh
SOLL/FIX: Via super scripts/ledger_nachtrag.sh EINEN Nachtrag landen: KON58-Entwurf (Backup-Ref-Owner-Frage, 776-Aufklaerung), Landesequenz-Vollzug 15770/15771/15773/15774, Z-06-Korrektur ('Produktionspfad vorhanden, aber inert'), Z-19-Fanout-Fortschreibung, Z-42/56-Nenner-Korrektur (0/130, Lock=6), L-22-15678-Schliessung, OD-7-Marker an :17446/:17511/par.69.6, glpat-Lehre
STATUS LT. QUELLE: offen (Nachimplementierungs-Auftrag)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 419
GEGENSTAND: NACHIMPLEMENTIERUNG: MEMORY-Nachzug [klein]
ORT: MEMORY.md
SOLL/FIX: MEMORY.md-Kopf auf KON57/58 ziehen; 'NEU offen: Wallclock + E-Label'-Zeile streichen (KON37 beantwortete beide); reference_versionierung-153 korrigieren (Vorkommen 153 vs. Literal-Zeilen getrennt ausweisen); Stempel-Rollen-Zaehlung neu erheben (derive_key_from_lines-Produktionsaufrufer zaehlen) und Datei aktualisieren
STATUS LT. QUELLE: offen (Nachimplementierungs-Auftrag)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 420
GEGENSTAND: NACHIMPLEMENTIERUNG: OD-7-Vollzug im Cluster-Repo [klein]
ORT: scripts/runner-mode.sh:43 | runner-matrix-DONE.md:48-52 | 20260813
SOLL/FIX: /home/comdare/Projekte/Cluster: Handout 20260813-HANDOUT-od7-*.md committen + pushen (GitLab-only); scripts/runner-mode.sh:43 prod1 HEAVY_J 24->16 aendern; SIGHUP-Redeploy gemaess runner-matrix-DONE.md:48-52 dokumentieren; par.69.6-Vermerk
STATUS LT. QUELLE: offen (Nachimplementierungs-Auftrag)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 421
GEGENSTAND: NACHIMPLEMENTIERUNG: W0a/W0b-Rest-Triage + #81 [gross]
ORT: unbekannt
SOLL/FIX: Fuer D1e/D1f/D1c/D2-G2/##06/##07/D2-G6 + D3-4/D3-5/D3-8/##08-Rest/##20-B/##23-R1/##28-##31 je Objektstand per Explore erheben, erledigen oder mit Termin in WELLENKONSOLIDIERUNG Teil B eintragen; danach den #81-Wiederhol-Verify ueber die W0b-Bauposten fahren und im Ledger verbuchen
STATUS LT. QUELLE: offen (Nachimplementierungs-Auftrag)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 422
GEGENSTAND: NACHIMPLEMENTIERUNG: #10-Abnahme MinIO + test:secrets [mittel]
ORT: minio_blind_smoke.sh
SOLL/FIX: minio_blind_smoke.sh im ruhigen Fenster fahren (K13-Koeder ZUERST, Werte nie ausgeben), rc-Protokoll persistieren; test:secrets-Zielort bestimmen (in super/ce nicht vorhanden -> privates CI-Template-Repo) und prod2-Herausnahme dort umsetzen oder mit Beleg als gegenstandslos buchen
STATUS LT. QUELLE: offen (Nachimplementierungs-Auftrag)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 423
GEGENSTAND: NACHIMPLEMENTIERUNG: S-3-Aktivierung mit Beide-Seiten-Nenner [klein]
ORT: bau/s3-ordnungsrelation
SOLL/FIX: Auf bau/s3-ordnungsrelation vor dem Aktivierungs-Commit je Seite messen und in den Commit-Body schreiben: Freigabe-Seite (set_active_machine_declaration-Aufrufer, required-Eintraege =0) und Compile-Seite (ce_owned_version_is_wellformed, bvset_ist_teilmenge-Konsumenten inkl. der 2 build_orchestrator-Treffer)
STATUS LT. QUELLE: offen (Nachimplementierungs-Auftrag)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 424
GEGENSTAND: NACHIMPLEMENTIERUNG: Sicherungs-Paket Worktree/Backups [mittel]
ORT: landung-kombibau.sh | scripts/worktree_remove_safe.sh
SOLL/FIX: Untracked Backup-Bestand in wt-super-landung/docs/sessions/backups/ committen (BU-SOFORT); landung-kombibau.sh aus Job-tmp nach super/scripts/ versionieren; P-06-Loeschregel als Skript scripts/worktree_remove_safe.sh (je Submodul-Store alle Branch-Tips gegen Remote pruefen, Protokoll-Pflicht, Abbruch bei Ungelandetem)
STATUS LT. QUELLE: offen (Nachimplementierungs-Auftrag)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 425
GEGENSTAND: NACHIMPLEMENTIERUNG: S-14a-Landepaket + 7. Gitlink-Zug [mittel]
ORT: tmp/pzw-fussnote-siebter-zug.md | bau/golden-s14a-riegel | f23c18e2
SOLL/FIX: Nach Abschluss des Bau-Agenten: Kombibau-Restzellen gcc-release/clang-debug/clang-release am 486er-Stand fahren + Logs persistieren; test_t6_wachen_inventar um contract:axis-version-lock ergaenzen (Inventar-Nenner definieren); Yml-Diff-Review + CI-Monitor bis terminal; bau/golden-s14a-riegel landen; danach super-Gitlink auf f23c18e2+ bumpen mit vorbereiteter PZW-Fussnote (tmp/pzw-fussnote-siebter-zug.md) im SELBEN Commit
STATUS LT. QUELLE: offen (Nachimplementierungs-Auftrag)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 426
GEGENSTAND: NACHIMPLEMENTIERUNG: golden-Versionsartefakt [klein]
ORT: unbekannt
SOLL/FIX: GOLDEN_VERSION als Datenbasis-Versions-Anker in super anlegen (nicht die Lock-Baseline), von der golden-320-Strecke konsumiert; als #16-Voraussetzung im Ledger buchen
STATUS LT. QUELLE: offen (Nachimplementierungs-Auftrag)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 427
GEGENSTAND: NACHIMPLEMENTIERUNG: Wachen-Haertungspaket (Lens B) [gross]
ORT: vor_push_alle_wachen.sh
SOLL/FIX: Je Fix Rot-zuerst-Koeder: set -o pipefail in die 34 Wachen ohne; vor_push_alle_wachen.sh auf Inventar-Modus (scripts/ci_*.sh enumerieren) + fehlendes Werkzeug = ROT; ci_xml_wellformed_guard (beide Repos): uebersprungene getrackte Dateien = ROT statt mitgezaehlt; anker_wache: Exakt-Match statt Substring + malformed ANKER-Zeile = ROT statt stillem Auswurf; achsen_roundtrip: Wirkungs-Probe statt ctest -N; lint_layer_includes: '#\s*include'-Muster + IFS-feste Schleife; yaml_key/thesis_gitlink_parity: Nenner in die Urteilszeile
STATUS LT. QUELLE: offen (Nachimplementierungs-Auftrag)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 428
GEGENSTAND: NACHIMPLEMENTIERUNG: allow_failure-Triage + ergebnis:holen [mittel]
ORT: .gitlab-ci.yml:257
SOLL/FIX: Die 3 Stellen (ce .gitlab-ci.yml:257 arm64-smoke, :898 is_original:relock, super :2751 ergebnis:holen) im Ledger als deklarierte manual-Opt-in-Ausnahmen buchen ODER entfernen; ergebnis:holen: auskommentierten Sammelblock scharf schalten, Nenner-Ausgabe ('N CSVs aus M Verzeichnissen'), allow_failure weg -- Sammelpfad-Bau vor der ersten Kampagne
STATUS LT. QUELLE: offen (Nachimplementierungs-Auftrag)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 429
GEGENSTAND: NACHIMPLEMENTIERUNG: Marker-Nachzug Referenz-Dokumente [mittel]
ORT: unbekannt
SOLL/FIX: Die ~20 Stellen aus NE-26 mechanisch abarbeiten: je Stelle datierter Einzeiler mit KON-Quelle (6x O-2, T-15b-Fussnoten, par.17.1-Wortlaut, [D-5] par.2/K7, 3x F11, 2x Do-14.08., Wellenplan-Kopf, OFFEN-Tabelle, K-1-Neufassung, par.13.5c/par.13.6/par.14.2/par.14.7, KON28-03/KON34-Altstellen, 28->12 InputIfFileExists)
STATUS LT. QUELLE: offen (Nachimplementierungs-Auftrag)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 430
GEGENSTAND: NACHIMPLEMENTIERUNG: Designplan par.11 KON39-57 [mittel]
ORT: unbekannt
SOLL/FIX: Nach par.9/par.10-Muster nachtragen: Warmup-PAAR-Pflichttests (Paar-Zaehlung 2x3, --debug-Zweig, Verwerf-Beweis, KON47-04), clang+gcc-2x2-Matrix als Pruefnorm (KON55), Mutations-Protokoll als Abnahmeklasse (KON57), W-A..W-D-Warteliste aus Task 30 retten
STATUS LT. QUELLE: offen (Nachimplementierungs-Auftrag)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 431
GEGENSTAND: NACHIMPLEMENTIERUNG: Explore A<->E-Dateimengen [mittel]
ORT: unbekannt
SOLL/FIX: Beide Dateimengen (Strang A / Strang E) erheben und mit Schnittmenge als Liste in docs/sessions/ persistieren (vor Mo 17.08.); B5-Lande-Slot-Entscheidung daran festmachen
STATUS LT. QUELLE: offen (Nachimplementierungs-Auftrag)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 432
GEGENSTAND: NACHIMPLEMENTIERUNG: ARBEITSWEISE v3.10 glpat-Passus [klein]
ORT: /home/comdare/Projekte/docs/ARBEITSWEISE-GESAMT-DOKTRIN.md
SOLL/FIX: /home/comdare/Projekte/docs/ARBEITSWEISE-GESAMT-DOKTRIN.md: Regel 'gitleaks-Koeder MUSS aus einer Regel der wirksamen Config stammen (glpat-+20); Biss-Beleg VOR jeder Null; Laenge allein entscheidet nicht' + Verweis Fallen-Register
STATUS LT. QUELLE: offen (Nachimplementierungs-Auftrag)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 433
GEGENSTAND: NACHIMPLEMENTIERUNG: Zaehlwerk-Klaerungen mit Kommando [mittel]
ORT: unbekannt
SOLL/FIX: Je mit ausgeschriebenem Kommando festschreiben und im Ledger/Plan nachtragen: 137-vs-123 Flag-Literale; #67 142 Kanten/29 Wanderungen (Kanten-Definition); Unverdrahtet-Elferliste neu (mind. Director/Fanout/admit_organ raus); S-16-Liste (Repo=super, 14 Dateien namentlich); S1..S7 aus dem 11.08.-Transkript extrahieren; 'bump-pflichtig' definieren
STATUS LT. QUELLE: offen (Nachimplementierungs-Auftrag)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 434
GEGENSTAND: NACHIMPLEMENTIERUNG: Bau-Trigger-Nachweisliste [klein]
ORT: unbekannt
SOLL/FIX: In WELLENKONSOLIDIERUNG Teil B je der 8 Trigger-Teilbedingungen (#7-Zahlen/S-19, S-13, S-17, B1/B2/B4/B5, S-14-Vollausrollung, #68) Nachweis-Gegenstand + Messkommando eintragen; #68-Verzichtsdokument-Vorlage mit Datumsfeld anlegen
STATUS LT. QUELLE: offen (Nachimplementierungs-Auftrag)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 435
GEGENSTAND: NACHIMPLEMENTIERUNG: Ketten-Riss-Posten buchen + OK-Zeile fixen [mittel]
ORT: test_data_sets.xml
SOLL/FIX: Sofort: measure:golden-320-OK-Zeile bedingen (OK nur wenn Anhang real regeneriert, sonst eigene SKIP-Zeile mit Grund). Buchen als Teil-B-Bauposten mit W-Fenster: release-Job + best_binary_selector-Anschluss; perm_runner-Cluster-Pfad; visibility:tier-binaries um Echtbau-Klasse ergaenzen (binary_id!='-'-Zaehler); cache_engine_builder-Usage bereinigen (test_data_sets.xml)
STATUS LT. QUELLE: offen (Nachimplementierungs-Auftrag)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 436
GEGENSTAND: NACHIMPLEMENTIERUNG: Register leerer Klassen als Artefakt [klein]
ORT: docs/plaene/REGISTER-leere-klassen.md
SOLL/FIX: Aus der WF2-SYNTHESE das Register in ein eigenes pflegbares Dokument docs/plaene/REGISTER-leere-klassen.md herausloesen (Eintraege + Abgrenzungsliste + Pflege-Regel), Synthese verweist nur noch
STATUS LT. QUELLE: offen (Nachimplementierungs-Auftrag)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 437
GEGENSTAND: METHODIK-BEFUND 1: HAEUFIGSTE KLASSE -- TEILMENGEN-GRUEN (Nenner ohne Grundgesamtheit, ~40% der Faelle)
ORT: unbekannt
SOLL/FIX: HAEUFIGSTE KLASSE -- TEILMENGEN-GRUEN (Nenner ohne Grundgesamtheit, ~40% der Faelle): die Meldung ist wahr fuer ihre eigene Teilmenge und beantwortet die eigentliche Frage nicht. Belege: S-14a-'TRAEGT' ueber 152 von 387 Headern; '0 allow_failure' im DIFF bei 3 im BAUM; vor_push_alle_wachen faehrt 3 von ~16 Wachen und meldet gruen; xml_wellformed zaehlt uebersprungene Dateien als geprueft; 'Kombibau vollstaendig' mit 1 von 4 belegten Zellen; ce-gruen fuer 671d7f6a als Beleg fuer den Nachfolger gelesen; ctest-Nenner 482/483/479/485/486 ohne Umgebungsangabe vermengt. GEGENMITTEL: jede GRUEN-/Erledigt-Zeile traegt 'deckt X von Y' mit ausgeschriebenem Y-Kommando.
STATUS LT. QUELLE: nur-hinweis (Methodik-Lehre fuer das Design)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 438
GEGENSTAND: METHODIK-BEFUND 2: ZWEITHAEUFIGSTE -- DEKLARATION STATT VOLLZUG AM ZIELORT (~25%)
ORT: unbekannt
SOLL/FIX: ZWEITHAEUFIGSTE -- DEKLARATION STATT VOLLZUG AM ZIELORT (~25%): der Nachtrag beschreibt die Erledigung, der Zielort traegt sie nicht. O-2-Streichung als Auftrag dokumentiert, alle 6 Stellen unveraendert; Datums-/Marker-Korrekturen nur als par.15.7-Verweis; OD-7-Handout geschrieben aber untracked; Lande-Skript nur im fluechtigen Job-tmp; KON58 als Entwurf statt Ledger; 'Register erstbefuellt' = Sessions-Bericht statt Artefakt. REGEL: erledigt heisst am Zielort committet/markiert/zugestellt -- ein Beschluss ueber die Aenderung ist nicht die Aenderung.
STATUS LT. QUELLE: nur-hinweis (Methodik-Lehre fuer das Design)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 439
GEGENSTAND: METHODIK-BEFUND 3: ZEITSCHEIBEN-WAHRHEIT OHNE FORTSCHREIBUNG (~15%, dominiert die Plan-Dokumente
ORT: unbekannt
SOLL/FIX: ZEITSCHEIBEN-WAHRHEIT OHNE FORTSCHREIBUNG (~15%, dominiert die Plan-Dokumente: V3 nur 32% voll haltend): zum Meldezeitpunkt wahr, von der Bewegung ueberholt, ohne Marker -- OF-1..4 'offen' nach Beantwortung; '13 Branches' (heute 20); 'NULL offene Fragen' vor der naechsten; MEMORY-Kopf 21 KON-Stufen zurueck; Task-Texte nach Landung nicht fortgeschrieben. REGEL: jede Zustandszahl braucht Commit-/Zeitanker, und ueberholte Stellen brauchen den Marker AN DER STELLE, nicht nur im Nachtrag.
STATUS LT. QUELLE: nur-hinweis (Methodik-Lehre fuer das Design)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 440
GEGENSTAND: METHODIK-BEFUND 4: GEFAEHRLICHSTE (weil mehrere Pruefstufen sie passieren liess) -- STELLVERTRETER-MESSUNG
ORT: unbekannt
SOLL/FIX: GEFAEHRLICHSTE (weil mehrere Pruefstufen sie passieren liess) -- STELLVERTRETER-MESSUNG: Registrierung statt Wirkung (ctest -N; visibility:tier-binaries akzeptiert binary_id='-' und meldet OK -- beweist Plan-Text, nie eine gebaute Binary); Kommentar als Beweis ('vier von fuenf Rollen' aus Kommentarzeilen; hybrid_gate behauptet erzwungene S3-Schranke ohne Verwendungsstelle); unbedingte OK-Zeile hinter legalen Ausfall-Zweigen (measure:golden-320); Konsument-statt-Gegenstand-Suche ('kein Produktionspfad' bei existierendem orchestrator:761); Lock-Baseline als 'golden festgeschrieben'. Die 158/387-Wache vom Vormittag war KEIN Einzelfall, sondern der sichtbarste Vertreter dieser Klasse.
STATUS LT. QUELLE: nur-hinweis (Methodik-Lehre fuer das Design)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 441
GEGENSTAND: METHODIK-BEFUND 5: PROZEDUR-ZUSAGE OHNE PROTOKOLL-ARTEFAKT (~10%)
ORT: unbekannt
SOLL/FIX: PROZEDUR-ZUSAGE OHNE PROTOKOLL-ARTEFAKT (~10%): Ergebnis stimmt, Durchfuehrung unbelegbar -- Loeschregel-Anwendung ohne Ref-Protokoll (4 Faelle, Ergebnis jeweils sauber); Explore-Artefakte wq3sh10mx/wo0oghvqu nirgends auf Platte; '198 Diff-Zeilen' und '2865 Zeilen' mit keiner Messform reproduzierbar; 'alle 30 Datumspaare nachgerechnet'. REGEL: das Protokoll (Kommando+Nenner+rc, persistiert ausserhalb tmp) ist Teil der Erledigung.
STATUS LT. QUELLE: nur-hinweis (Methodik-Lehre fuer das Design)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 442
GEGENSTAND: METHODIK-BEFUND 6: WERKZEUG-GRUEN OHNE BEISSENDEN KOEDER
ORT: unbekannt
SOLL/FIX: WERKZEUG-GRUEN OHNE BEISSENDEN KOEDER: 34 von 36 Wachen ohne pipefail messen den Filter statt des Befehls; Koeder falscher Klasse (AWS biss nie -- nur Config-Regel-Koeder glpat-+20 beisst); Kategorien ohne je eigenen Rot-Pfad (Heuristik 3 Wochen still); Meta-Gate prueft Existenz+rc der Unterwachen, liest deren Nenner nicht. REGEL: je Wache UND je Kategorie ein gesehener Rot-Lauf vor der ersten akzeptierten Null.
STATUS LT. QUELLE: nur-hinweis (Methodik-Lehre fuer das Design)
ABHAENGIGKEIT/FLAECHE: -

### [wtk6lmhln.json] 443
GEGENSTAND: METHODIK-BEFUND 7: POSITIV-BEFUND als Kalibrierung
ORT: unbekannt
SOLL/FIX: POSITIV-BEFUND als Kalibrierung: die harten Objekt-Tatsachen (Commits, Merges, Remote-Koepfe, Pipeline-Terminalzustaende, CT-Asserts, Zeilenzahlen) hielten fast durchgehend -- 311 von 538 voll, nur 19 harte Faelle. Gefallen wird fast nie am 'ob es geschah', sondern am 'ob es die Frage beantwortet' (V0) und am Nenner. Konsequenz fuer die naechsten drei Tage: Erledigt-Meldungen zu LANDUNGEN duerfen kurz geprueft werden, Erledigt-Meldungen zu WACHEN, NENNERN und 'an der Stelle korrigiert' brauchen die Objekt-Probe.
STATUS LT. QUELLE: nur-hinweis (Methodik-Lehre fuer das Design)
ABHAENGIGKEIT/FLAECHE: -


## QUELLE w3azi1rhl.json -- Regressions-Konsolidierung 06.08. (Dossier-Nachtrag). ACHTUNG ZEITSTAND: Messstaende der Quelle sind 06.08. ~22-23 Uhr (super origin/development cc431b01, ce 2b5ecd29, ce main b241a272 = damaliger super-Gitlink). ERGEBNIS EINGEARBEITET: docs/sessions/20260806-DOSSIER-regressionen-checkheft.md 1590->2486 Z. (+896, append-only), 31 neue Befunde N-A..N-AE, 11 Statuskorrekturen K-1..K-11, 15 nicht belegbare Posten, 10 neue Regeln R-11..R-20. Roh-Sammlungen (4 Straenge: transkript 24 Funde, journale 206 result-Ereignisse/79 Journale, git-und-ledger 14 Funde, indirekte Regressionen) unten verbatim segmentiert.

### [w3azi1rhl.json] 001
GEGENSTAND: Messstaende der Pruefung 06.08. (live ls-remote/rev-parse) inkl. main-Rueckstaende (super main 10 zurueck, ce main 8 zurueck, super-Gitlink = ce main)
ORT: cc431b01 | 38381ac8 | 2a6f35d8
SOLL/FIX: # VERIFIKATIONS-RUeCKGABE -- drei Listen

**Messstaende dieser Pruefung (live, `ls-remote`/`rev-parse`, nicht aus `refs/remotes/*`):**

| Gegenstand | Ist |
|---|---|
| super `origin/development` | `cc431b01` (22:46:47) -- **neuer als jeder Sammler-Stand (`38381ac8`)** |
| super `origin/main` | `2a6f35d8` (**10 zurueck**) |
| ce `origin/development` | `2b5ecd29` (22:16:59) |
| ce `origin/main` | `b241a272` (**8 zurueck**) |
| super-Gitlink ce auf `development` **und** `main` | `b241a272` = ce **main** |
| thesis `origin/development` == `origin/main` | `19e15920`; beide super-Zeiger in Paritaet |
| Dossier | `e110cf6d`, 20:36:26, **genau 1 Commit, seither unveraendert** |

Messmethode durchgaengig `/usr/bin/grep` (GNU 3.11) absolut; Zahlen mit Zaehlmethode; Wachen selbst gefahren.

---

# LISTE 1 -- BESTAeTIGT

## 0. Statuskorrekturen am Dossier selbst (schwerste Klasse des Nachtrags)
STATUS LT. QUELLE: nur-hinweis (Zeitanker der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [w3azi1rhl.json] 002
GEGENSTAND: K-1: K-1 * C-2 "7 sind unmarkiert" ist FALSCH -- es sind 0, und schon am Messstand des Dossiers
ORT: diplomarbeit.tex:280-285 | diplomarbeit.tex | 8e58f691 | bdd1e16
SOLL/FIX: **K-1 * C-2 "7 sind unmarkiert" ist FALSCH -- es sind 0, und schon am Messstand des Dossiers**
Selbst gemessen gegen `8e58f691` (den das Dossier in 0.3 als seinen eigenen Stand nennt) *und* gegen `origin/development`: `kapitel/de/` = 14 `.tex`, 6 eingebunden (`diplomarbeit.tex:280-285`), **8 nicht eingebunden -- alle 8 tragen Zeile 1 `% NICHT eingebunden (Stand ...): diese Datei ist in diplomarbeit.tex nicht referenziert.`** Heilung: thesis `bdd1e16`, **19:34:39** -- 62 Minuten vor Abfassung. Status `[x]`. Klasse: N-3/R-9 auf das Heft selbst.
STATUS LT. QUELLE: Statuskorrektur am Dossier (Befund des Dossiers falsch/ueberholt) -- eingearbeitet
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 003
GEGENSTAND: K-2: K-2 * Z-8 Nebenbefund "`axis_inventory.tex` ... 0-mal referenziert" ist FALSCH
ORT: axis_inventory.tex | anhang/de/D_building_block_matrix.tex:1442 | anhang/de/tabellen/axis_inventory.tex | 8e58f691 | df54a2c
SOLL/FIX: **K-2 * Z-8 Nebenbefund "`axis_inventory.tex` ... 0-mal referenziert" ist FALSCH**
`git grep axis_inventory 8e58f691` -> **2 Treffer**: `anhang/de/D_building_block_matrix.tex:1442` und `anhang/en/...:1442`, je `\InputIfFileExists{anhang/de/tabellen/axis_inventory.tex}{}{% ...}`. Eingebunden durch `df54a2c`, **19:34:39**, Vorfahr von `8e58f691` (geprueft). Handlungspunkt **C-1(c) ist erledigt**.
STATUS LT. QUELLE: Statuskorrektur am Dossier (Befund des Dossiers falsch/ueberholt) -- eingearbeitet
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 004
GEGENSTAND: K-3: K-3 * Die Anhang-A-Zahlen des Dossiers sind um eins zu hoch -- und die "Korrektur gegen die Session" kehrt eine richtige Zahl in eine falsche
ORT: anhang/de/A_measurements.tex:71 | 8970465d | 8e58f691 | 19e15920
SOLL/FIX: **K-3 * Die Anhang-A-Zahlen des Dossiers sind um eins zu hoch -- und die "Korrektur gegen die Session" kehrt eine richtige Zahl in eine falsche**
Eigene Messung, drei Revisionen, Zaehlmethode genannt:

| Revision | `-c 'InputIfFileExists'` | `-c '^\InputIfFileExists'` | stumm `}{}{}`  | Ersatztext `}{}{%` |
|---|---:|---:|---:|---:|
| `8970465d` | 29 | **28** | 17 | **11** |
| `8e58f691` | 29 | **28** | 17 | **11** |
| `19e15920` | 30 | **28** | **0** | **28** |

DE und EN identisch. Die 29./30. Fundstelle ist eine **Kommentarzeile** (`anhang/de/A_measurements.tex:71`) -- dieselbe, die Z-8 zwei Absaetze weiter zitiert. Das Dossier schreibt "29 / 17 / 12" und "`8e58f691` hat einen Eintrag mit Ersatztext hinzugefuegt": **an dieser Zaehlung hat `8e58f691` nichts geaendert**; die Session-Zahlen 28/17/11 waren an *beiden* Staenden richtig. **C-1(a) ist heute erledigt** (`19e15920`, 0 stumme in DE **und** EN). Klasse: **N-2, angewandt auf das Dossier** -- es formuliert die Regel und verletzt sie in derselben Tabelle.
STATUS LT. QUELLE: Statuskorrektur am Dossier (Befund des Dossiers falsch/ueberholt) -- eingearbeitet
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 005
GEGENSTAND: K-4: K-4 * C-4 war 57 Minuten vor Abfassung geheilt -- und die Heilung ist inzwischen selbst falsch
ORT: kapitel/de/05_evaluation.tex | a6c7598 | 8e58f691
SOLL/FIX: **K-4 * C-4 war 57 Minuten vor Abfassung geheilt -- und die Heilung ist inzwischen selbst falsch**
`a6c7598`, **19:39:55**, Vorfahr von `8e58f691`. Der neue Text (`kapitel/de/05_evaluation.tex`, selbst gelesen) differenziert ausdruecklich: *"Die Mess-Kette oeffnet ueber `perf\_event\_open` genau drei generische Zaehler --- L1D-Misses, Last-Level-Misses und dTLB-Misses ... Die zugehoerigen Spalten tragen deshalb keine \emph{gemessene} Null."* Der Dossier-Vorwurf "ohne zu differenzieren / suggeriert Vollstaendigkeit" traegt nicht mehr.
**Aber:** der neue Satz ist praeziser als die Wirklichkeit -- s. **N-C**. Neue Fehlerklasse: *eine Heilung, die zur Regression wurde, weil der geheilte Text praeziser wurde als die Messung.*
STATUS LT. QUELLE: Statuskorrektur am Dossier (Befund des Dossiers falsch/ueberholt) -- eingearbeitet
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 006
GEGENSTAND: K-5: K-5 * R-1/R-7/D-3 "der super hat kein `scripts/`-Verzeichnis" ist ueberholt
ORT: scripts/ci_diff_ascii_width_guard.sh | ci/thesis_gitlink_parity.sh | ci/anhang_forward_core.sh | 7780c6af
SOLL/FIX: **K-5 * R-1/R-7/D-3 "der super hat kein `scripts/`-Verzeichnis" ist ueberholt**
`git ls-tree origin/development scripts/ ci/` -> `scripts/ci_diff_ascii_width_guard.sh`, `ci/thesis_gitlink_parity.sh`, `ci/anhang_forward_core.sh`. Commit `7780c6af`, **21:11:32**. Job `lint:diff-hygiene` bei `:254`. **T3-Posten teilschliessen** -- mit den offenen Luecken aus **N-I/N-J**.
STATUS LT. QUELLE: Statuskorrektur am Dossier (Befund des Dossiers falsch/ueberholt) -- eingearbeitet
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 007
GEGENSTAND: K-6: K-6 * Z-1/D-1 und Owner-Posten 12+13 sind geheilt -- Biss selbst nachgewiesen
ORT: ci/thesis_gitlink_parity.sh | 3ccbc501 | 20260931
SOLL/FIX: **K-6 * Z-1/D-1 und Owner-Posten 12+13 sind geheilt -- Biss selbst nachgewiesen**
`3ccbc501` (21:41:31). Am Objekt: `anhang:forward` bumpt `THESIS_GITLINKS="thesis/diplomarbeit Code/external/20260931-overleaf-diplomarbeit"` (`:1170`), Fruehausstieg prueft **beide**, Nachbedingung `ci/thesis_gitlink_parity.sh --quelle index --erwartet "$NEW_THESIS_SHA"`; `verify:submodules` ruft `--quelle head` fail-closed (`test -x ... || exit 1`). **Selbst gefahren:**
```
sh ci/thesis_gitlink_parity.sh --quelle head                 -> RC=0
sh ci/thesis_gitlink_parity.sh --quelle head --erwartet 000... -> RC=1
```
Eine der wenigen Wachen des Tages, deren Biss **bewiesen** ist. Owner-Posten 12 ist am Objekt bestaetigt (die Alt-Wache `:370` prueft `git submodule status --recursive | grep -E '^[-+U]'` = Worktree gegen Gitlink; der Kommentar `:377-379` sagt es selbst) und **durch dieselbe Landung geheilt**.
STATUS LT. QUELLE: Statuskorrektur am Dossier (Befund des Dossiers falsch/ueberholt) -- eingearbeitet
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 008
GEGENSTAND: K-7: K-7 * S-4/Z-5: vierte Rueckkehr, andere Dateien, 4170 statt 2042 Zeilen
ORT: 20260806-ANWEISUNG-pmc-intel-perf-rechte.md | -KLAERUNG-zweiphasig-dreiphasig-drei-typen.md | -PLAN-hybrid-architektur-pmc-achsen-zuordnung.md | 20260806
SOLL/FIX: **K-7 * S-4/Z-5: vierte Rueckkehr, andere Dateien, 4170 statt 2042 Zeilen**
Die drei vom Dossier genannten Plandokumente sind **gelandet** (geprueft). Im Hauptklon stehen jetzt **5 neue unversionierte Plandokumente**: `20260806-ANWEISUNG-pmc-intel-perf-rechte.md` 622 * `...-KLAERUNG-zweiphasig-dreiphasig-drei-typen.md` 632 * `...-PLAN-hybrid-architektur-pmc-achsen-zuordnung.md` 1043 * `...-PLAN-hybrid-pmc-numa-core-permutation.md` 1025 * `...-PLAN-warnungen-und-ausgabe-bei-messfehlern.md` 848 = **4170 Zeilen**, auf **keinem** Ref (`git cat-file -e origin/development:<pfad>` -> FEHLT fuer alle fuenf). Dazu `Code/measure_out_d03/`: **66 Dateien, 3,7 MB**, darunter `e4_xml/measurements.csv` (17 Zeilen) und **8 `perm.dll.rsp`**; `git check-ignore` -> **kein Treffer**. Ein `git clean -fdx` vernichtet damit **Rohmessdaten unter der Nie-loeschen-Doktrin**, nicht nur Planung.
STATUS LT. QUELLE: Statuskorrektur am Dossier (Befund des Dossiers falsch/ueberholt) -- eingearbeitet
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 009
GEGENSTAND: K-8: K-8 * Zeilendrift, heute erneut vierfach (N-2 live)
ORT: super/.gitlab-ci.yml:255 | m3v2_pmc_smoke.cpp:71 | experiment_plan_director.hpp:1333
SOLL/FIX: **K-8 * Zeilendrift, heute erneut vierfach (N-2 live)**

| Dossier | heute | Delta |
|---|---|---|
| `super/.gitlab-ci.yml:255/:273/:291` (drei `branch: main`) | **:310/:328/:346** | 55 |
| `thesis:pdf` `:548` | **:612** | 64 |
| `verify:submodules` `:309` | **:353** | 44 |
| `m3v2_pmc_smoke.cpp:71` (`pmc_seam_ok`) | **:117** | 46 |
| `experiment_plan_director.hpp:1333` (`allow_failure`) | **:1373** | 40 |
STATUS LT. QUELLE: Statuskorrektur am Dossier (Befund des Dossiers falsch/ueberholt) -- eingearbeitet
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 010
GEGENSTAND: K-9: K-9 * S-2/S-3 sind zum dritten Mal am selben Tag eingetreten, mit schwererer Fracht
ORT: 8894d983 | b708c572 | 77ed15fa
SOLL/FIX: **K-9 * S-2/S-3 sind zum dritten Mal am selben Tag eingetreten, mit schwererer Fracht**
ce `main` 8 zurueck, super `main` 10 zurueck. Auf `main` liegen **nicht**: die PMC-Invariante `8894d983`, die Codegen-Struktur-Haertung `b708c572`, E14 `77ed15fa`, der Fensterfix `2b5ecd29`, die super-ASCII-Wache `7780c6af`, die Paritaetswache `3ccbc501`. Die drei Bridges stehen unveraendert auf `branch: main`.
STATUS LT. QUELLE: Statuskorrektur am Dossier (Befund des Dossiers falsch/ueberholt) -- eingearbeitet
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 011
GEGENSTAND: K-10: K-10 * N-3 heute -- schlimmer als im Dossier
ORT: b-ci-rueckschrieb-beide-zeiger | b-m2-pmc-invariante | 9d0f1bad
SOLL/FIX: **K-10 * N-3 heute -- schlimmer als im Dossier**
`super` lokaler `main` = `9d0f1bad`, **406 Commits** hinter `origin/main`. ce lokaler `main` ist heute synchron. Beide Hauptklone stehen auf Arbeitszweigen (`b-ci-rueckschrieb-beide-zeiger` / `b-m2-pmc-invariante`) -- die **Vorbedingung von Owner-Posten 16 ist live in beiden Repos**.
STATUS LT. QUELLE: Statuskorrektur am Dossier (Befund des Dossiers falsch/ueberholt) -- eingearbeitet
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 012
GEGENSTAND: K-11: K-11 * Owner-Posten 11 ist auf `development` geheilt -- und auf dem gebauten Stand NICHT
ORT: m3v2_pmc_smoke.cpp | 2b5ecd29 | b241a272
SOLL/FIX: **K-11 * Owner-Posten 11 ist auf `development` geheilt -- und auf dem gebauten Stand NICHT**
`m3v2_pmc_smoke.cpp` auf `origin/development` (`2b5ecd29`): `:62 pmc->begin();` ... `:69 ...end();` mit echtem Messfenster dazwischen, Kopf `:15` benennt die Korrektur. Auf `origin/main` (`b241a272`, = der Gitlink des super): `:31/:32` unmittelbar hintereinander, Kopf `:12` sagt woertlich *"begin()->[leerer Batch]->end()"*. **Der Defekt stand wochenlang woertlich im eigenen Kopfkommentar** und ist im integrierten System weiterhin aktiv.

---

## 1. Neue Befunde -- am Objekt belegt, im Dossier nicht gefuehrt
STATUS LT. QUELLE: Statuskorrektur am Dossier (Befund des Dossiers falsch/ueberholt) -- eingearbeitet
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 013
GEGENSTAND: N-A: N-A `[ ] OFFEN` T1 -- Die Schluessel-Wache wohnt in genau dem Job, den sie bewacht (schwerster Neubefund)
ORT: ce/.gitlab-ci.yml | ci_yaml_key_guard.sh | ci_diff_ascii_width_guard.sh
SOLL/FIX: **N-A `[ ] OFFEN` T1 -- Die Schluessel-Wache wohnt in genau dem Job, den sie bewacht (schwerster Neubefund)**
`ce/.gitlab-ci.yml` auf `origin/development`: `ci_yaml_key_guard.sh` hat **genau eine** Aufrufstelle (`:243`), `ci_diff_ascii_width_guard.sh` **genau eine** (`:268`) -- beide im `script:` von `test:coverage-guard`. Ein zweites `test:coverage-guard:`-Mapping am Dateiende loescht kommentarlos **alle drei Wachen auf einmal** (YAML: letzte Definition gewinnt) -- exakt der Angriff, gegen den die Schluessel-Wache gebaut ist. Der Job-Kommentar `:224` verspricht das Gegenteil: *"Er kann nicht selbst durchs Raster fallen: seine Eingabe ist die Gesamtmenge, er hat kein rules-Gate und kein allow_failure."* Die Zusage gilt fuer **Tests**, nicht fuer den **Job**. -> **R-13**.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 014
GEGENSTAND: N-B: N-B `[~]` statt `[x]` -- `contract:axis-version-lock` ist gruen per Konstruktion; SW-1 ist zu stark verbucht
ORT: tools/axis_version_lock/axis_version.lock | 557d8023
SOLL/FIX: **N-B `[~]` statt `[x]` -- `contract:axis-version-lock` ist gruen per Konstruktion; SW-1 ist zu stark verbucht**
`git grep -rniE "axis.?version.?lock|AXIS_ALGO_VERSION"` ueber `tests/` = **0** (Nenner: 460 verfolgte Dateien im Testbaum). Der heilende Commit `557d8023` hat `AXIS_ALGO_VERSION: 2` gesetzt **und die Lock-Datei im selben Zug neu erzeugt** -- selbst nachgerechnet, alle drei `sha256sum` stimmen heute zeichengleich mit `tools/axis_version_lock/axis_version.lock`. Die Wache hatte **nie die Gelegenheit zu beissen**. Genau die vom Owner gesuchte Klasse. -> **R-13, zweiter Vertreter.**
STATUS LT. QUELLE: behoben lt. Quelle (Statuskorrektur/geheilt)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 015
GEGENSTAND: N-C: N-C `[ ] OFFEN` T1 -- Der Abgabetext behauptet drei geoeffnete Zaehler; die Quelle deckt das nicht
ORT: linux_perf_pmc_source.hpp | 19e15920
SOLL/FIX: **N-C `[ ] OFFEN` T1 -- Der Abgabetext behauptet drei geoeffnete Zaehler; die Quelle deckt das nicht**
`linux_perf_pmc_source.hpp` auf `origin/development`, selbst gelesen: `:224-227` oeffnet `c_ll_` (`PERF_TYPE_HW_CACHE`, LL/READ/MISS); `:234 ready_ = l1d_ok_ || ll_ok_ || dtlb_ok_;`; `:263 measurement::PmcCounters c;` (POD-Default, alle 0); `:286-290` schreibt `c.cache_misses_l3` **nur bei `ll_ok_`**. Scheitert `ll_ok_`, bleibt die Spalte **0, waehrend `pmc_available` 1 meldet** -- und keine Wache faengt das (s. N-F). Der Thesis-Satz "genau drei generische Zaehler" (DE+EN, `19e15920`) ist damit lane-abhaengig. **Hoechste Dringlichkeit: C-4 wie im Dossier formuliert auszufuehren wuerde eine falsche Hardware-Aussage in die Abgabe schreiben.**
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 016
GEGENSTAND: N-D: N-D `[ ] OFFEN` T2 -- `branch_misses`: drei Kommentare am selben HEAD, zwei behaupten das Gegenteil des dritten
ORT: linux_perf_pmc_source.hpp:16 | cache_engine_builder_iterator.hpp:499 | measurement_snapshot.hpp:145
SOLL/FIX: **N-D `[ ] OFFEN` T2 -- `branch_misses`: drei Kommentare am selben HEAD, zwei behaupten das Gegenteil des dritten**
Auf `origin/development`:
- `linux_perf_pmc_source.hpp:16` -- *"branch_misses wird von **KEINER** PMC-Quelle befuellt (offener Posten M-3a). Diese honest-0-Spalten sind im Anhang als solche zu fuehren, **nicht als gemessen**."*
- `cache_engine_builder_iterator.hpp:499` -- *"PmcCounters **ERHEBT** branch_misses **real**"*, und `:504` emittiert die CSV-Spalte `;pmc_branch_misses`.
- `:774` -- *"real erhoben (PmcCounters), bisher nur nicht emittiert"*, `:777` schreibt sie.

Gegenprobe: `git grep -n branch_misses -- libs apps` = **14 Treffer**, davon **genau eine Zuweisung** (`measurement_snapshot.hpp:145`, Kopie aus `PmcCounters`). Keine PMC-Quelle schreibt das Feld je. Eine als "real erhoben" begruendete CSV-Spalte ist strukturell immer 0. Kapitel IV, in **derselben Codebasis**.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 017
GEGENSTAND: N-E: N-E `[ ] OFFEN` T1 -- Das committete Erstbeleg-CSV: `pmc_available=1` neben VIER Null-Spalten
ORT: super/measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv | 20260726
SOLL/FIX: **N-E `[ ] OFFEN` T1 -- Das committete Erstbeleg-CSV: `pmc_available=1` neben VIER Null-Spalten**
`super/measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv`, selbst ausgelesen (Separator `;`), **16 Datenzeilen**:

| Spalte | Wert ueber alle 16 Zeilen |
|---|---|
| `pmc_available` | **1** |
| `pmc_cache_misses_l1`, `pmc_dtlb_misses` | reale, verschiedene Werte |
| `pmc_cache_misses_l2`, `pmc_cache_misses_l3`, `pmc_coherence_invalidations`, `pmc_energy_micro_joules` | **0** |

Owner-Posten 14 haelt und ist **schwerer als notiert**: es sind **vier** Spalten, nicht eine, und die Zeile behauptet aktiv Verfuegbarkeit. Das ist die Datei, die der Anhang auswerten wuerde.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 018
GEGENSTAND: N-F: N-F `[ ] OFFEN` T1 -- `pmc_seam_ok` bleibt bei `available=1` blind
ORT: unbekannt
SOLL/FIX: **N-F `[ ] OFFEN` T1 -- `pmc_seam_ok` bleibt bei `available=1` blind**
Heute (`:117`): `bool const pmc_seam_ok = delta.available || (!kPmcExpected && counters_all_zero);`. M-2/B3 hat die **zweite** Haelfte fail-closed gedreht; die **erste** steht unveraendert. Bei `available=1` ist die Naht OK, gleichgueltig wie viele Spalten strukturell 0 sind (N-C, N-D, N-E). Kapitel III, Merkmal 4: die Heilung schloss die eine Haelfte und liess die produktiv relevante offen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 019
GEGENSTAND: N-G: N-G `[ ] OFFEN` T1 -- Der Bare-Metal-Kanal (par.61 Dual-Weg) traegt die PMC-Pflicht nicht
ORT: experiment_plan_director.hpp
SOLL/FIX: **N-G `[ ] OFFEN` T1 -- Der Bare-Metal-Kanal (par.61 Dual-Weg) traegt die PMC-Pflicht nicht**
`experiment_plan_director.hpp` auf `origin/development`: **6** `IPlanBuilder`-Klassen (`:305 :396 :439 :778 :1041 :1593`). Alle **4** `cmake -B build`-Emissionen (`:874 :912 :1233 :1386`) tragen `+ ceb_pmc_compile_define()` und liegen in `CiYamlBuilder`/`TierCiYamlBuilder`. `CMakeGraphBuilder` (`:439`) und `TierCmakeGraphBuilder` (`:1593`) emittieren **0** solche Zeilen; der Treiber kommt ueber `COMDARE_PLAN_DRIVER` (*"Default: PATH-Suche"*, `:459`/`:1617`) von aussen und wird **ohne Flag stumm akzeptiert**. Die Pflicht haengt jetzt an zwei **YAML-Emittern** statt an einer Invariante -- dieselbe Wurzel wie SW-2/A-1, eine Generation spaeter.
**Zugleich Korrektur zu SW-3/A-1:** `COMDARE_ENABLE_PMC` kommt in dieser Datei heute **5-mal** vor (auf `origin/development`) -- und **0-mal** auf `origin/main`, also auf dem Stand, den der super-Gitlink baut.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 020
GEGENSTAND: N-H: N-H `[ ] OFFEN` T1 -- `allow_failure` ist eine Regression gegen einen erreichten Zustand und eine Owner-Direktive
ORT: .gitlab-ci.yml:169 | experiment_plan_director.hpp:1373 | b5e64a51
SOLL/FIX: **N-H `[ ] OFFEN` T1 -- `allow_failure` ist eine Regression gegen einen erreichten Zustand und eine Owner-Direktive**
Ledger `:692` verbatim: *"damit **0 allow_failure im GESAMTEN Matrix-System** (einzige Ausnahme by design: ce `is_original:relock`, manual Utility)"*. Ledger `:2040` (Owner 17.07.): *"JEDER Job ... kein roter Job, **kein allow_failure-Freibrief**"*.
Heute gemessen: ce `.gitlab-ci.yml:169` (`build:arm64-smoke`) * ce `:521` (`is_original:relock`) * super `:1344` (`ergebnis:holen` -- der Job, der die Mess-CSVs einsammelt) = **drei eingecheckte**, plus **einer emittiert** (`experiment_plan_director.hpp:1373`). Der emittierte wurde in `b5e64a51`, **19.07.2026 21:33** eingefuehrt -- **zwei Tage nach** der Verschaerfung. Die Vollstaendigkeitsaussage von 06.07. traegt nicht mehr.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 021
GEGENSTAND: N-I: N-I `[ ] OFFEN` T1 -- Die gespiegelte Wache existiert in zwei Strengen; die schwaechere bewacht das groessere Repo
ORT: ci_test_coverage_manifest.sh | ci_test_coverage_guard.sh | copy_results_to_nas.sh
SOLL/FIX: **N-I `[ ] OFFEN` T1 -- Die gespiegelte Wache existiert in zwei Strengen; die schwaechere bewacht das groessere Repo**
`is_scoped()` super `:375`: `... || ext == ".inl" || ext == ".cmake" || ext == ".sh") return 1` -- ce `:191`: `... || ext == ".inl" || ext == ".cmake") return 1`. **`.sh` fehlt im ce.** Der super-Kopf sagt es selbst (`:62-64`): *"Die ce-Vorlage kennt .sh NICHT."* Die Verbesserung liegt **nur in der Kopie**.
**Wirkung selbst gemessen** ueber die 7 verfolgten `ce/scripts/*.sh` (1142 Zeilen, Methode: `awk length($0)>120` bzw. `LC_ALL=C grep -c '[^ -~\t]'`): **18 Zeilen ueber 120 Byte** (Spitze `ci_test_coverage_manifest.sh` mit 6, `ci_test_coverage_guard.sh` mit 6) und **21 Nicht-ASCII-Zeilen** (`copy_results_to_nas.sh` 10, `lint_flags_includes.sh` 10, `comdare_storage_activation.sh` 1) -- drei dieser Skripte sind **am 06.08. gebaut** worden und keine Wache hat sie je gesehen. Zweite Divergenz: der super hat `--seit-basis` (bestimmt den Bereich per `merge-base` selbst), der ce nicht -- und **genau die vom super als falsch begruendete Form** ist im ce in CI verdrahtet (`:268`, `"${_ce_base}..HEAD"`). -> **R-16**.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 022
GEGENSTAND: N-J: N-J `[ ] OFFEN` T3 -- `--bestand` kann in diesem Repo nicht durchlaufen; seine nie erzeugte Ausgabe traegt eine Politik-Entscheidung
ORT: scripts/ci_diff_ascii_width_guard.sh | super/.gitlab-ci.yml:248-249 | 20260931
SOLL/FIX: **N-J `[ ] OFFEN` T3 -- `--bestand` kann in diesem Repo nicht durchlaufen; seine nie erzeugte Ausgabe traegt eine Politik-Entscheidung**
**Selbst gefahren, ohne Pipe:**
```
$ sh scripts/ci_diff_ascii_width_guard.sh --bestand ; echo EXIT=$?
FATAL: Datei nicht lesbar: .../Code/external/20260931-overleaf-diplomarbeit
DIFF-HYGIENE-WACHE: ABBRUCH -- awk-Verarbeitung fehlgeschlagen (rc=2)
EXIT=2
```
Ursache: `git ls-files` liefert die vier **Submodul-Gitlinks** als Dateien; awk kann ein Verzeichnis nicht per `getline` oeffnen. Der `NENNER`-Block wird nie erreicht. Bis zum Abbruch bereits gemeldet: **814 NICHT-ASCII + 156 >120-SPALTEN** in 979 Ausgabezeilen. Die publizierte Zahl **845 / 174 / 18714** steht in `super/.gitlab-ci.yml:248-249` als Begruendung dafuer, den Alt-Bestand **bewusst nicht zu gaten** -- sie ist mit diesem Modus **nicht reproduzierbar**.
**Gegenprobe, damit der Befund nicht ueberzieht:** `--seit-basis` liefert `EXIT=0`, mit Nenner und korrekt benannten uebersprungenen Gitlinks. Nur der Bestands-Modus ist unbrauchbar -- und **kein Job ruft ihn**. Positiv: die Wache scheitert **laut**; niemand hat den Ausgang gelesen, bevor die Zahl in zwei Dokumente ging.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 023
GEGENSTAND: N-K: N-K `[ ] OFFEN` SOFORT -- Acht ce-Landungen stehen in keinem Gitlink; und die in Z-3 vorgeschlagene Wache wuerde es durchwinken
ORT: b-m2-pmc-invariante | b241a272 | 6ddd7fd4 | b708c572
SOLL/FIX: **N-K `[ ] OFFEN` SOFORT -- Acht ce-Landungen stehen in keinem Gitlink; und die in Z-3 vorgeschlagene Wache wuerde es durchwinken**
Live: super-Gitlink ce auf `origin/development` **und** `origin/main` = `b241a272` = ce **main**. Die acht ungespiegelten ce-Commits sind namentlich `6ddd7fd4`/`b708c572` (Codegen-Struktur-Haertung = die Klassenheilung zu Z-7), `ed67661c`/`77ed15fa` (E14), `8894d983` (**PMC-Pflicht als Invariante** = A-1/SW-3), `fb9aefdc`, `22e17f57` (errno-Diagnose), `2b5ecd29` (Fensterfix). Auf dem gebauten Stand ist `COMDARE_ENABLE_PMC` im Planer **0-mal** vorhanden (gemessen).
**Und der Heilungsvorschlag ist falsch, bevor er gebaut ist.** Z-3 `:998` verlangt einen Hook, der *"die Richtung misst"*. Gemessen im Hauptklon: Gitlink committet `b241a272`, Checkout `90bca126` (Zweig `b-m2-pmc-invariante`), `merge-base --is-ancestor b241a272 90bca126` = **wahr** -> die vorgeschlagene Wache waere **GRUeN**; `--is-ancestor 90bca126 origin/development` = **falsch**, `git ls-remote origin | grep -c 90bca126` = **0**. Richtung ist keine Aussage ueber Erreichbarkeit. -> **R-12.**
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 024
GEGENSTAND: N-L: N-L `[ ] OFFEN` T3 -- Die Ablage verschluckt ihren eigenen Beleg: 78 Gate-Logs in keinem git-Objekt
ORT: super/.gitignore:49 | ce/.gitignore:73
SOLL/FIX: **N-L `[ ] OFFEN` T3 -- Die Ablage verschluckt ihren eigenen Beleg: 78 Gate-Logs in keinem git-Objekt**
`super/.gitignore:49` = `*.log`, `ce/.gitignore:73` = `*.log`. Unter `docs/sessions/backups/`: **155** `.log`-Dateien im Arbeitsbaum, **77** davon auf `origin/development` verfolgt, die restlichen **78** von `git check-ignore --stdin` als **78/78 ignoriert** bestaetigt -- sie liegen in **keinem** git-Objekt. `git add <ignorierte Datei>` schweigt; der Commit ist gruen, der Beleg fehlt. Beruehrt die Owner-Doktrin *Messdaten nie loeschen / Backups additiv*. -> **R-17**.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 025
GEGENSTAND: N-M: N-M `[x] GEHEILT, Klasse offen` -- Eine Migration erbt die Fehlerklasse, die sie beseitigt
ORT: 2c631551
SOLL/FIX: **N-M `[x] GEHEILT, Klasse offen` -- Eine Migration erbt die Fehlerklasse, die sie beseitigt**
super `2c631551` (15:58:04, Vorfahr von `origin/development` -- geprueft), Commit-Nachricht verbatim:
> "die sechs URSPRUENGLICHEN Codex-Befunde gelten als strukturell geheilt -- der Wegfall des Selbstbau-Parsers hat sie erledigt. **Die Befunde hier sind LUECKEN DER MIGRATION SELBST. Das ist Fehlerklasse 1 der Pruefliste: der geheilte Defekt steckt eine Ebene weiter.**"

Elf benannte Pfade mit Biss, u. a. B11 (die Flag-Verriegelung pruefte nie, **ob** der rohe Fehler der Doppelbindestrich ist -> heute `if(NOT _err MATCHES "Double hyphen within comment")`), B3 (bei RC 0 wurde stderr ignoriert -- `--nonet` meldet den blockierten Entity-Load nur dort), B1 (der eine verbliebene zustandslose Ausnahme-Lexer). -> **R-14**.
STATUS LT. QUELLE: behoben lt. Quelle (Statuskorrektur/geheilt)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 026
GEGENSTAND: N-N: N-N `[ ] OFFEN` T1 -- Fingerprint-Injektivitaet ist eine KLASSE, nicht ein Einzelfall; das Heft fuehrt einen von fuenf
ORT: abi_adapter.hpp | anatomy_fingerprint.hpp:427-441 | profile_run_facade.cpp:274 | 71b5586a | dbdd2f9b
SOLL/FIX: **N-N `[ ] OFFEN` T1 -- Fingerprint-Injektivitaet ist eine KLASSE, nicht ein Einzelfall; das Heft fuehrt einen von fuenf**
Fuenf Vertreter desselben Satzes an einem Tag: (1) Kollisions-Eimer `ohne-anker` (`71b5586a`, **im Heft als H-4**); (2) Preimage-Glied [5] nicht per-Perm (`dbdd2f9b`, *"O2/O3 derselben Zelle identischer Fingerprint = falscher Skip"*); (3) Tier-Realversion geerbt statt erhoben (`bbd72c2a`, *"g++-16 16.1->16.3 = identischer Stempel"*); (4) `kCebFingerprint` (**bestritten**, s. Liste 3); (5) **`COMDARE_MEASUREMENT_ON`**.
Fall (5) selbst belegt: `abi_adapter.hpp` traegt **30** `COMDARE_MEASUREMENT_ON`-Zeilen und entscheidet damit den geerbten Interface-Satz (`:393`, Dossier A-5); `anatomy_fingerprint.hpp:427-441` listet **8** Glieder, **keines** davon ist die Mess-Schaltung; `git grep -c COMDARE_MEASUREMENT_ON` ueber den gesamten `include/cache_engine/abi/`-Baum = **0**. Heute knallt es nicht, weil `profile_run_facade.cpp:274` das Makro **hart und unbedingt** setzt -- bis jemand die funktional-only-Binary baut. -> **R-15.**
*Abgrenzung:* Dossier A-4 behandelt `COMDARE_ENABLE_PMC`. Dies ist ein **anderes** Makro und ein anderer Befund.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 027
GEGENSTAND: N-O: N-O `[x] GEHEILT` -- "Der EINE literale Pin": eine Anzahl-Zusage, die zweimal widerlegt und zweimal stehen gelassen wurde
ORT: 4b38d072
SOLL/FIX: **N-O `[x] GEHEILT` -- "Der EINE literale Pin": eine Anzahl-Zusage, die zweimal widerlegt und zweimal stehen gelassen wurde**
ce `4b38d072` (15:47:56), verbatim: *"er sprach von 'dem EINEN literalen Pin', E-24 C8 fand einen ZWEITEN ... **liess den Wortlaut aber stehen. Beim naechsten Bump waren es dann VIER.**"* Und: *"GEFUNDEN HAT SIE NICHT DIESER KOPF, SONDERN DER ctest-DOPPELLAUF."* Der Header fuehrt seither die **vollstaendige Fundstellen-Liste** statt einer Anzahl. -> **R-19, schaerft R-3.**
STATUS LT. QUELLE: behoben lt. Quelle (Statuskorrektur/geheilt)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 028
GEGENSTAND: N-P: N-P `[ ] OFFEN` T2 -- Der teure Pass ist der erste, und genau sein Plan wird ueberschrieben
ORT: profile_runner.hpp:283-291 | profile_run_entry.hpp
SOLL/FIX: **N-P `[ ] OFFEN` T2 -- Der teure Pass ist der erste, und genau sein Plan wird ueberschrieben**
Am Objekt (`origin/development`): `profile_runner.hpp:283-291` -- `passes.emplace_back(); // "" = Basis-Pass (immer zuerst)`, dann je `<axis_sweep>` einer. Selbst gezaehlt mit `/usr/bin/grep -c '<axis_sweep '` (mit Leerzeichen -- ohne zaehlt der Container `<axis_sweeps>` mit): `all_axes_golden` **17** -> 18 Paesse, `m3_golden_coverage` **17** -> 18, `m3_smoke_coverage` **17** -> 18, `m3v2_study`/`m3v2_sota_pilot` **8** -> 9, `m3v2_smoke` **2** -> 3. Das Chunk-Fenster gilt **nur** fuer den Basis-Pass (`profile_run_entry.hpp`: `if (a.golden_range_count > 0 && pass_axis.empty())`); alle Paesse fahren mit demselben `cfg.batch_plan_datei` (`:658`). Der teure Basis-Pass schreibt den Plan, die 17 Folgepaesse ueberschreiben dieselbe Datei. Verwandt mit H-6, eine Stufe hoeher: nicht ein Feld, sondern die **ganze Resume-Ebene** wird vom eigenen Ablauf entwertet.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 029
GEGENSTAND: N-Q: N-Q `[ ] OFFEN` T4 -- Eine Achse, die deklariert permutiert und im gebauten Objekt konstant ist
ORT: cacheline_line_bytes.hpp:16-19 | apps/catalog_codegen_tool/main.cpp:183-190
SOLL/FIX: **N-Q `[ ] OFFEN` T4 -- Eine Achse, die deklariert permutiert und im gebauten Objekt konstant ist**
`cacheline_line_bytes.hpp:16-19` sagt es selbst: *"heute instanziieren alle Strategie-Basen die Default-CacheLineConfig{} (line_size = B64), weil der Codegen die per-Organ-Config noch nicht als NTTP emittiert."* Und `apps/catalog_codegen_tool/main.cpp:183-190` **weist `cacheline` hart zurueck**: *"ist in der Limits-Entkopplungs-Vorstufe nicht unterstuetzt ... Profil ablehnen."* Das Dossier hedgt in H-1 korrekt mit *"bei aktivierter KF-6-NTTP-Belegung"*, fuehrt aber nicht, dass die Freigabe-Kette **gar nicht existiert**.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 030
GEGENSTAND: N-R: N-R `[ ] OFFEN` T3 -- Die repo-lokalen Ledger sind ein Register, das niemand fuehrt (R-10 eine Ebene hoeher)
ORT: 253bcd86 | 626b9db
SOLL/FIX: **N-R `[ ] OFFEN` T3 -- Die repo-lokalen Ledger sind ein Register, das niemand fuehrt (R-10 eine Ebene hoeher)**
Selbst gezaehlt gegen `origin/development`: ce **79 Commits am 06.08., davon 0** auf `docs/ledger-sections/`; letzter Eintrag `253bcd86` vom **05.08. 19:45**. thesis **6 Commits, 0**; letzter Eintrag `626b9db` vom **03.08.** prt-art **0 Commits** seit 03.08.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 031
GEGENSTAND: N-S: N-S `[ ] OFFEN` T4 (F-3) -- Die A-8-Entlastung steht auf einer Gegenprobe, die Tests ausschliesst; dort liegt die einzige lebende Fundstelle
ORT: measure.hpp:36-38 | tests/unit/test_measurement_buffer.cpp:124
SOLL/FIX: **N-S `[ ] OFFEN` T4 (F-3) -- Die A-8-Entlastung steht auf einer Gegenprobe, die Tests ausschliesst; dort liegt die einzige lebende Fundstelle**
`measure.hpp:36-38` auf `origin/development`:
```cpp
    static constexpr void at_node_visit(std::uint64_t used_bytes, Context& ctx) noexcept {
        // CLU = effektiv genutzte Bytes pro Cache-Line (64 B)
        ctx.cache_lines_used += used_bytes / 64;
```
Einzige Aufrufer im ganzen Repo (selbst gezaehlt): `tests/unit/test_measurement_buffer.cpp:124` und `:132`. Und `:132-133` pinnt die falsche Einheit als gruene Zusage: `M::at_node_visit(128, ctx); EXPECT_EQ(ctx.cache_lines_used, 2u);`. Die Ledger-Gegenprobe lautete *"repoweite Suche ... **ausserhalb Tests**/ext/build ergab KEINE weitere lebende Fundstelle"* -- der Ausschluss enthielt den Fund. **R-3 + H-7** an einem Objekt. Muss zusammen mit dem Test geheilt werden, sonst faellt der Test.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 032
GEGENSTAND: N-T: N-T `[ ] OFFEN` T3 -- Ein Kommentar, der seine Messung mitliefert, altert schneller als die Messung
ORT: super/.gitmodules | .gitlab-ci.yml | 123b2f32 | 20260931
SOLL/FIX: **N-T `[ ] OFFEN` T3 -- Ein Kommentar, der seine Messung mitliefert, altert schneller als die Messung**
`super/.gitmodules` (Kommentarblock aus `123b2f32`, 21:09:41), verbatim: *"Als PFAD kommt sie in .gitlab-ci.yml **NULL Mal** vor (gemessen: `grep -n "Code/external/20260931" .gitlab-ci.yml -> exit 1`)"* und *"Der Rueckschrieb-Job `anhang:forward` bumpt **NUR** `thesis/diplomarbeit` ... `verify:submodules` prueft nur den lebenden Pfad."*
**Mit exakt diesem Muster nachgemessen:** `/usr/bin/grep -c "Code/external/20260931" .gitlab-ci.yml` = **3** (`:102`, `:377`, `:1170`), davon `:1170` funktional: `THESIS_GITLINKS="thesis/diplomarbeit Code/external/20260931-overleaf-diplomarbeit"`. Ursache: `3ccbc501`, **32 Minuten spaeter**. Die Heilung ist gelandet, die Wunde-Beschreibung nicht nachgezogen. Verschaerfung zu N-2: hier altert nicht die Zeilenangabe, sondern die **Aussage samt Befehl** -- und der Befehl beweist heute das Gegenteil.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 033
GEGENSTAND: N-U: N-U `[ ] OFFEN` -- Owner-Posten 8 stimmt, die Zahl darin nicht, und der Posten ist schwerer
ORT: libs/cache_engine/include/cache_engine/measurement/axis_error.hpp | topics/organ_axis_error_classes.hpp | builder/pruef_dock/dock_error_classification.hpp
SOLL/FIX: **N-U `[ ] OFFEN` -- Owner-Posten 8 stimmt, die Zahl darin nicht, und der Posten ist schwerer**
`libs/cache_engine/include/cache_engine/measurement/axis_error.hpp` auf `origin/development`: **655 Zeilen** [OK], aber `/usr/bin/grep -c '^enum class'` = **8** (nicht 4): `CompilerCompilerErrorClass:39`, `SampleStatus:77`, `AdmissionStatus:98`, `BuildCellStatus:119`, `InfraErrorClass:195`, `HardwareProbeErrorClass:227`, `DockErrorClass:270`, `ErrorDomain:338`; **121** `static_assert`. Dazu `topics/organ_axis_error_classes.hpp`, `builder/pruef_dock/dock_error_classification.hpp` und `tests/unit/test_axis_error_taxonomy.cpp`. Die "neu erarbeitete" Zustands-Leiter dupliziert eine **doppelt so reiche** Taxonomie.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 034
GEGENSTAND: N-V: N-V `[ ] OFFEN` T3 -- Zwei Zehner-Listen von Fehlerklassen vom selben Tag, ohne Querverweis
ORT: memory/feedback_behauptungen_verifizieren_layer_vertraege_halten.md
SOLL/FIX: **N-V `[ ] OFFEN` T3 -- Zwei Zehner-Listen von Fehlerklassen vom selben Tag, ohne Querverweis**
`memory/feedback_behauptungen_verifizieren_layer_vertraege_halten.md` (30 Zeilen, modified **06.08. 11:19**) traegt zehn **andere** Klassen als R-1..R-10, u. a. *"Wachen pruefen EXISTENZ statt WERTE"*, *".tmp/Ablage-Pfad ohne Prozess-Kennung"*, *"Wert zweimal gelesen statt einmal gebunden"*, *"Regex statt echtem Parser -- und die Loesung oeffnet ggf. eine NEUE Klasse"*. Das Dossier nennt die Datei **einmal** (`:608`) und importiert **keine** der zehn: `/usr/bin/grep -c` im Dossier fuer `\.tmp` = 0, `tautolog` = 0, `Regex statt` = 0, `zweimal gelesen` = 0. **Kapitel IV, angewandt auf das Heft selbst** -- sonst existieren zwei Kanons.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 035
GEGENSTAND: N-W: N-W `[ ] OFFEN` -- Eine Korrektur ohne Gegenstandsangabe hebt einen richtigen Befund auf
ORT: memory/feedback_eigene_arbeitsfehler_lead_berichte_nie_uebernehmen.md:44
SOLL/FIX: **N-W `[ ] OFFEN` -- Eine Korrektur ohne Gegenstandsangabe hebt einen richtigen Befund auf**
`memory/feedback_eigene_arbeitsfehler_lead_berichte_nie_uebernehmen.md:44`, verbatim: *"**"Der Submodul-Zeiger wird stillschweigend zurueckgedreht"** -- falsch herum: ein Commit **ohne** Pathspec haette ihn **RICHTIG** gesetzt."* Der Satz nennt das Submodul nicht. Er gilt fuer den ce-Gitlink; fuer den Thesis-Gitlink gilt weiterhin Z-3 (dort haette ein Commit ohne Pathspec um 78 Commits **zurueck**gedreht). Zeile `:35` derselben Datei belegt den anderen Fall. Wer `:44` allein liest, haelt R-8/Z-3 fuer widerlegt. **Handlung: Satz um den Submodul-Namen ergaenzen.**
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 036
GEGENSTAND: N-X: N-X `[ ] OFFEN` T3 -- Der rueckwirkende Pruefauftrag wurde formuliert, ausdruecklich vertagt und nie zugeschnitten
ORT: memory/reference_ugrep_ascii_gate_stille_null.md
SOLL/FIX: **N-X `[ ] OFFEN` T3 -- Der rueckwirkende Pruefauftrag wurde formuliert, ausdruecklich vertagt und nie zugeschnitten**
`memory/reference_ugrep_ascii_gate_stille_null.md`, verbatim: *"**Unbelegt (nicht falsch) ist damit jede Zusage, die (a) auf der mehrstufigen Diff-Pipe MIT `+++`-Filterstufe beruht UND (b) weder die unescaped Form noch eine Gegenprobe zeigt.** ... Welche historische Meldung welche Form nutzte, steht nur in den Transkripten, nicht in der Doku -- eine echte Reichweitenerhebung waere eine eigene, grosse Aufgabe."* Im Dossier existiert **kein entsprechender Posten**. Gehoert als benannter Posten mit Umfangsentscheid gefuehrt, nicht als Fussnote.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 037
GEGENSTAND: N-Y: N-Y `[ ] OFFEN` -- Der Weg "Regel dokumentieren" ist hier nachweislich schon beschritten worden und hat nicht getragen
ORT: memory/feedback_ascii_only_comments_and_selfcheck_line.md:37
SOLL/FIX: **N-Y `[ ] OFFEN` -- Der Weg "Regel dokumentieren" ist hier nachweislich schon beschritten worden und hat nicht getragen**
`memory/feedback_ascii_only_comments_and_selfcheck_line.md:37` enthaelt die **korrekte, unescapte** Form `... | grep -v '^+++' | ...` -- sichtbar daneben, waehrend Agenten die kaputte escaped Form aus Gewohnheit tippten. Zweiter Gegenbeweis gegen den Dokumentations-Weg (der erste ist SW-2, 13.07.). Verschaerfung zu SW-2: *eine Regel, die nur dokumentiert ist, wird von der Gewohnheit ueberstimmt, auch wenn die Doku sichtbar danebensteht.*
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 038
GEGENSTAND: N-Z: N-Z `[~] TEILWEISE` T2 -- Eine Diagnose-Ausgabe, die Ursachen NENNT, die sie nie gemessen hat
ORT: m3v2_pmc_smoke.cpp:124-125 | linux_perf_pmc_source.hpp:116-121 | 22e17f57
SOLL/FIX: **N-Z `[~] TEILWEISE` T2 -- Eine Diagnose-Ausgabe, die Ursachen NENNT, die sie nie gemessen hat**
`m3v2_pmc_smoke.cpp:124-125`: *"[PMC-FEHLER] COMDARE_ENABLE_PMC ist einkompiliert, die Quelle meldet aber available=0. **Ursache pruefen: perf_event_paranoid, CAP_PERFMON/Executor-Rechte, Container ohne perf.**"* -- eine hartkodierte Vermutungsliste. Sie hat drei Fehldiagnosen und eine beinahe ausgefuehrte Cluster-Rechte-Aenderung erzeugt. **Teilweise geheilt:** `22e17f57` hat die echte Messung nachgereicht -- `linux_perf_pmc_source.hpp:116-121` sichert `errno` sofort und druckt `[PMC-DIAG] perf_event_open fehlgeschlagen: event=%s type=%u config=%llu errno=%d (%s)`. Die Vermutungsliste im Test steht unveraendert. -> **R-11.**
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 039
GEGENSTAND: N-AA: N-AA `[ ] OFFEN` -- R-6 bekommt seinen Nenner: zehn Format-/Breiten-Nachzuege an einem Tag
ORT: fb9aefdc | b20eeabc | 98952e02
SOLL/FIX: **N-AA `[ ] OFFEN` -- R-6 bekommt seinen Nenner: zehn Format-/Breiten-Nachzuege an einem Tag**
Eigene Zaehlung (alle Refs, seit 06.08. 00:00, Commit-Titel auf `format|width|breiten|>120|spalten`, ohne Merges und ohne die Werkzeug-Commits): ce **7** (`fb9aefdc`, `b20eeabc`, `98952e02`, `b6d87c08`, `cc20b63d`, `034e0068`, `2a58e2ed`), super **3** (`b35aea1b`, `6124c6f7`, `50dc231b`) = **10**. Der aussagekraeftigste fehlt im Heft: ce `b20eeabc` (19:01) -- *"cf22: clang-format-Nachzug -- **Vorwellen-Luecke** aus der A1-NB2-Serie (nie mit dem exakten Job-Scope geprueft)"*: die Welle war bereits als landebereit gemeldet, das Gate lief erst bei der Landung im echten Job-Scope. **R-2 plus R-6 an einem Objekt.** Disziplin traegt hier messbar nicht.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 040
GEGENSTAND: N-AB: N-AB `[ ] OFFEN` T3 -- Der lokale `ci-templates`-Checkout beantwortet Fragen ueber einen fremden autoritativen Stand
ORT: /home/comdare/Projekte/Cluster/_infra/ci-templates/base-pipeline.yml
SOLL/FIX: **N-AB `[ ] OFFEN` T3 -- Der lokale `ci-templates`-Checkout beantwortet Fragen ueber einen fremden autoritativen Stand**
`/home/comdare/Projekte/Cluster/_infra/ci-templates/base-pipeline.yml`: **846 Zeilen**, mtime **11. Juli 10:35**. Wer `include:`-Verhalten aus diesem Checkout beantwortet, misst am falschen Gegenstand -- dieselbe Klasse wie N-3/N-4, auf einem Pfad, den das Dossier nicht kennt. *(Die Behauptung "authoritativ 1142 Zeilen" ist nicht nachgefahren -- s. Liste 3.)*
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 041
GEGENSTAND: N-AC: N-AC `[ ] OFFEN` T3 -- Eine abgelaufene Sperre wirkt weiter, weil das Zitat ihre Verfallsbedingung abschneidet
ORT: super/docs/architektur/22_CI_INTERAKTIVE_DIPLOMARBEIT_ANHANG_AUTOMATION.md:97
SOLL/FIX: **N-AC `[ ] OFFEN` T3 -- Eine abgelaufene Sperre wirkt weiter, weil das Zitat ihre Verfallsbedingung abschneidet**
`super/docs/architektur/22_CI_INTERAKTIVE_DIPLOMARBEIT_ANHANG_AUTOMATION.md:97`, am Objekt: `| -- | pmc_cache_misses-Darstellungen | -- | **NICHT bauen** (honest-empty bis #26) |`. Die Bedingung *"bis #26"* steht dort. Ein Explore hat sie ohne diesen Zusatz zitiert und als geltende Regel gefuehrt. Klasse: *eine Entlastung auf ungepruefter Praemisse* -- hier durch ein abgeschnittenes Zitat. Umkehrung von SW-2. *(Ob #26 vollzogen ist, s. Liste 3.)*
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 042
GEGENSTAND: N-AD: N-AD `[ ] OFFEN` SOFORT -- Die Vorbedingung des Zwei-Schreiber-Fehlers steht live in beiden Repos
ORT: b-ci-rueckschrieb-beide-zeiger | b-m2-pmc-invariante
SOLL/FIX: **N-AD `[ ] OFFEN` SOFORT -- Die Vorbedingung des Zwei-Schreiber-Fehlers steht live in beiden Repos**
super-Hauptklon auf `b-ci-rueckschrieb-beide-zeiger`, ce-Hauptklon auf `b-m2-pmc-invariante`; super lokaler `main` **406 Commits** zurueck (K-10). Genau die Lage, in der zweimal in den Arbeitsbranch einer laufenden Welle committet wurde. Die aus dem Transkript gezogene Konsequenz -- *"Landungen laufen ab jetzt ueber eigene Worktrees"* -- ist unterwegs (`wt-landung`/`wt-super-landung` existieren), aber **nichts erzwingt einen Lebend-Check vor Bereinigungs-/Reset-Auftraegen**.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 043
GEGENSTAND: N-AE: N-AE `[ ] OFFEN` -- Owner-Posten 4: der Mechanismus ist am Objekt bestaetigt
ORT: anatomy_fingerprint.hpp:429 | anatomy_fingerprint.hpp:428-429 | ceb_version_stamp.hpp:200 | 3ccbc501 | 20260802
SOLL/FIX: **N-AE `[ ] OFFEN` -- Owner-Posten 4: der Mechanismus ist am Objekt bestaetigt**
Die Verdikt-Zeile beider Wachen lautet literal `DIFF-HYGIENE-WACHE: ROT.` (super `:556`, ce `:346`) bzw. `... GRUEN.` (super `:553`, ce `:343`). Ein grep-Filter auf `DIFF-HYGIENE:` trifft **keine** davon. Der Selbstcheck der Selbstcheck-Ausgabe hat dieselbe Gestalt wie der urspruengliche Fehler.

---

# LISTE 2 -- SCHON IM DOSSIER (nur ergaenzen, nicht neu fuehren)

| Sammler-Posten | Dossier-Stelle | Behandlung |
|---|---|---|
| Owner-1/2/3 (stille Nullen: gitleaks ce/thesis, Token-Praefix) | **R-1**, Klassenmerkmal | Instanzen ergaenzen, keine neue Regel |
| Owner-5 (Landestatus gegen veralteten lokalen `main`) | **N-3** | mit K-10 fortschreiben (super lokal 406 zurueck) |
| Owner-6 / T-17 (M-1-Format-Bump 3->4 gegen ueberholten Stand) | **R-5**-verwandt; Glied [3] steht in `anatomy_fingerprint.hpp:429`, 8 Glieder gesamt (`:441`) | als Auftrags-Praemissen-Fehler ergaenzen; s. auch Liste 3 |
| Owner-12 / 13 (Submodul-Wache, `anhang:forward`) | **Z-1/D-1/Z-3** | auf `[x]` mit `3ccbc501` (K-6) |
| Owner-14 (`cache_misses_l3_ll` = 0 in der CSV) | **A-2/C-4** `[BERICHT]` | durch **N-C/N-E** ersetzen: Umfang und Begruendung sind widerlegt |
| Owner-16/17 (Arbeitsbranch, Kette T-1) | **S-2/S-3/Z-2** | mit K-9/K-10/N-AD fortschreiben |
| I-6 (Z-7 Restposten (a), Gegenprobe aller Konsumenten) | **Z-7** | Restposten (a) schliessbar; **Restposten "Liste statt Invariante"** bleibt: der Katalog-Codegen haengt an handgeschriebenen `attach`-Aufrufen, der Paper-Codegen an einer Invariante (`ce/CMakeLists.txt`, `GLOBAL PROPERTY COMDARE_TEST_TARGETS`) |
| T-11 (Rotations-Test: Null ohne Nenner, selbst korrigiert) | **R-1** | als **positives Muster** ergaenzen -- der einzige Fall des Tages, in dem die Regel von selbst griff |
| T-12 (`GIT_SUBMODULE_STRATEGY: none` => Wache faende ihr eigenes Skript nicht) | **R-1/R-7**, offene Handlung | ist die **Antwort** auf die dort offene Frage "spiegeln oder zentral ziehen": gespiegelt, mit Begruendung |
| B-13 (jeder neue ce-Test verschiebt den Nenner) | **SW-2**, Betriebs-Auflage | als Auflage ergaenzen; Zahl nicht nachgemessen |
| E-j (`anhang:forward` beide Zeiger) | **Z-1** | erledigt, s. K-6 |
| E-k (SW-3 Wachen 2/4) | **SW-3/A-3** | Wache 4 geheilt (`kPmcExpected`), Wache 2 **halb** -- s. **N-F** |

---

# LISTE 3 -- NICHT BELEGBAR (mit Grund; gehoert NICHT ins Checkheft, sondern in die `[?]`-Rubrik)

1. **T-9 "Glied [3] deklariert eine Ausstattung, die der Bau ignoriert -- die Deklaration ist eine Luege".** Am Objekt widerlegt in der Begruendung: Glied [3] ist die **Mess-Tooling-Zeile** (`anatomy_fingerprint.hpp:428-429`: *"Haupt-Wahl + load_framework-Anhang ... NICHT der CEB-Schluessel, Paragraf 62-D trennt beide"*), also die Tooling-**Wahl**. `perm_mess_defines()` setzt `COMDARE_MEASUREMENT_ON=1` -- eine **andere** Groesse. Nichts am Objekt zeigt, dass der Bau die Tooling-Wahl ignoriert. Die tragende Substanz steht in **N-N**; T-9 als eigener Posten faellt weg.

2. **T-10 `kCebFingerprint` = par.58-Verstoss.** Am Objekt bestaetigt ist nur die Form (`ceb_version_stamp.hpp:200`: `anatomy_fingerprint_hex("", "", kCebMeasurementStamp)`). Der Code traegt eine **ausdrueckliche, dokumentierte Gegenbegruendung** (`:188-197`): *"die CEB ist KEIN Tier-Binary ... ihre Identitaet ist ihre CODE-Identitaet (das Mess-ANGEBOT) ... OE-C: CEB und Planer je EIGENES Stempelsystem"*, plus par.62-D im Preimage-Kopf. **Kein Befund, sondern ein Owner-Entscheid** -- er kollidiert mit dem Owner-KERN *"Mess-Achse => CEB+Binaries neu"*. Der par.58-Vorwurf wurde weitergegeben, ohne par.62-D zu lesen: genau die gesuchte Form *"Anklage auf ungepruefter Praemisse"*.

3. **Owner-Posten 15 (390 Runner-Token nicht rotiert).** Nicht nachgefahren: verlangt Vault-PAT und Leseoperationen auf drei Cluster-Projekten, faellt unter die read-only-Auflage. Zusaetzlich ungeklaerte Zahlen-Kollision: Dossier E-1 nennt **776** in `refs/backup/pre-secret-scrub-20260802`, der Abend-Fund **390** in der Workflow-Sicherung -- zwei Mengen, nie gegeneinander gestellt. Als `[?] UNBELEGT` fuehren, nicht als Befund.

4. **Owner-Posten 4, Pipeline 15110 und `fb9aefdc` als Heilung.** Kein CI-Zugang. Der **Mechanismus** ist bestaetigt (N-AE), die Pipeline-ID und der Kausalzusammenhang nicht.

5. **Owner-Posten 7 ("zwei der vier A-8-Fundstellen falsch zugeordnet").** Die Zuordnung der vier Fundstellen habe ich nicht einzeln nachgefahren. Was ich belegt habe: die A-8-Entlastung hat eine **zu kleine Gegenprobe** (N-S).

6. **B-3 "`PERF_COUNT_HW_CACHE_LL` liefert auf Zen 5 `errno=2`".** Kein prod1-Zugang. Bestaetigt ist die **strukturelle** Haelfte: bei `ll_ok_==false` bleibt `cache_misses_l3` 0, waehrend `pmc_available` 1 meldet (N-C). Die vendor-spezifische ENOENT-Aussage bleibt `[BERICHT]`.

7. **Herkunft der Zahl 845 / 174 / 18714.** Belegt ist, dass `--bestand` sie heute nicht liefern **kann** (zweimal FATAL, EXIT=2) und dass bis zum Abbruch 814/156 gemeldet wurden. Aus welchem Lauf die publizierte Zahl stammt, ist **nicht entschieden**. Befund lautet "nicht reproduzierbar", **nicht** "falsch".

8. **B-9 (super-Wache: untracked-Blindstelle, 897 Fremdcode-Dateien im Scope).** Die Scope-Divergenz `.sh` habe ich am Objekt belegt (N-I); den Untracked-Lauf und die 897 habe ich **nicht** reproduziert (verlangt Schreiben im Arbeitsbaum). Als `[?]` mit dem Reproduktionsrezept fuehren.

9. **B-13 Nenner 407 / B-2-Rezept.** Nicht gemessen (verlangt ein Configure des ce-Testbaums, in einer read-only-Runde nicht vertretbar).

10. **"MEINE 16 Arbeitsfehler".** Selbst gezaehlt (`/usr/bin/grep -c '^- \*\*'`): **15** Bullets; der Titel sagt 16. **Die Zahl 16 traegt keine Zaehlmethode.** N-2, in der Doktrin-Datei selbst -- als Buchhaltungs-Korrektur, nicht als Befund.

11. **N-AC Teilaussage "#26 ist am 12.07. vollzogen".** Im Ledger nicht sauber auffindbar (`:68` fuehrt PMC-Spalten weiterhin als *"honest-0 bis #26"*). Der Befund ist auf den belegbaren Teil verengt: das Zitat schneidet die Verfallsbedingung weg.

12. **N-AB Teilaussage "authoritativ 1142 Zeilen".** Kein Cluster-Zugang. Belegt ist nur der lokale Stand (846 Zeilen, 11.07.).

13. **G-9 (Entlastung eines KRITISCH-Befunds auf einem Code-Kommentar).** Ledger-belegt, von mir **nicht** am Objekt nachgefahren. Die daraus abgeleitete Regel (**R-20**) schlage ich trotzdem vor, weil ihr Anlassfall im Ledger verbatim steht.

14. **Die sechs Ein-Schreiber-Verletzungen (T-14/T-15/G-11) als Einzelfaelle.** Transkript-/Ledger-Belege, nicht objektpruefbar. Am Objekt belegt ist nur die **Vorbedingung** (N-AD). Ein eigenes Kapitel "Zwei Schreiber auf einem Gegenstand" ist gerechtfertigt, seine Faelle muessen aber als `[Ledger/Transkript]` markiert werden.

15. **Ob eine der heute gebauten Wachen je in einer echten Pipeline lief.** Kein CI-Zugang. Bewiesen ist die **Bissfaehigkeit lokal** (K-6, N-J) und die Verdrahtung durch Lesung. Die Restgrenze aus SW-4 (*"der erste echte Lauf ist der Beweis dieser einen Stelle"*) bleibt fuer `lint:diff-hygiene` und die ce-Verdrahtung **unbewiesen**.

---

# NEUE REGELN -- Vorschlag, in der Sprache des Hefts
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 044
GEGENSTAND: R-11: R-11 -- Keine Ursache ohne Messung.
ORT: 22e17f57
SOLL/FIX: **R-11 -- Keine Ursache ohne Messung.**
Eine Fehler- oder Diagnoseausgabe darf keine Ursache **nennen**, die sie nicht **gemessen** hat.
*Anlassfall:* `[PMC-FEHLER] ... Ursache pruefen: perf_event_paranoid, CAP_PERFMON, Container ohne perf` -- drei Fehldiagnosen, ein beinahe ausgefuehrter Cluster-Eingriff, waehrend `errno` an der Quelle verworfen wurde (heute nachgereicht: `22e17f57`).
*Erkennungsmerkmal:* eine Fehlermeldung, die eine **Liste moeglicher** Ursachen druckt. Spiegel von R-1: dort fehlt der Nenner einer Null, hier die Messung einer Behauptung.
STATUS LT. QUELLE: nur-hinweis (Regel-Vorschlag, ins Dossier uebernommen)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 045
GEGENSTAND: R-12: R-12 -- Richtung ist nicht Erreichbarkeit.
ORT: 90bca126 | b241a272
SOLL/FIX: **R-12 -- Richtung ist nicht Erreichbarkeit.**
Bei jedem Gitlink gilt `git merge-base --is-ancestor <zeiger> origin/<zielzweig>`, **nicht** `--is-ancestor <alt> <neu>`. "Vorwaerts" ist keine Aussage ueber den Zweig.
*Anlassfall:* der Checkout `90bca126` liegt vorwaerts vom committeten `b241a272` und ist auf **keinem** Remote-Ref.
*Wirkung:* **korrigiert den in Z-3 vorgeschlagenen `pre-commit`-Hook, bevor er gebaut wird.** R-8 + R-9 zusammengezogen.
STATUS LT. QUELLE: nur-hinweis (Regel-Vorschlag, ins Dossier uebernommen)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 046
GEGENSTAND: R-13: R-13 -- Eine Wache darf nicht im Gegenstand ihrer eigenen Fehlerklasse wohnen -- und ihr Sollwert nicht aus demselben Commit stammen wie ihr Istwert.
ORT: unbekannt
SOLL/FIX: **R-13 -- Eine Wache darf nicht im Gegenstand ihrer eigenen Fehlerklasse wohnen -- und ihr Sollwert nicht aus demselben Commit stammen wie ihr Istwert.**
*Prueffrage bei jeder neuen Wache:* **Kann der Mechanismus, gegen den sie gebaut ist, sie selbst treffen? Und hatte sie je die Gelegenheit zu beissen?**
*Anlassfaelle:* N-A (Schluessel-Wache als erster Schritt eines Jobs, den YAML stumm verschlucken kann) und N-B (Lock-Datei im selben Commit erzeugt wie der Sollwert -- gruen per Konstruktion, 0 Tests bei 460 Testbaum-Dateien).
STATUS LT. QUELLE: nur-hinweis (Regel-Vorschlag, ins Dossier uebernommen)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 047
GEGENSTAND: R-14: R-14 -- Eine Migration erbt die Fehlerklasse, die sie beseitigt.
ORT: 2c631551
SOLL/FIX: **R-14 -- Eine Migration erbt die Fehlerklasse, die sie beseitigt.**
Wer einen Selbstbau-Parser durch ein Werkzeug ersetzt, muss **jede Aufrufstelle des Werkzeugs einzeln** gegen dieselbe Klasse bissen -- sonst wandert die stille Null vom Parser in den Aufruf.
*Anlassfall:* `2c631551`, elf Migrations-eigene False-Green-Pfade nach sechs als "strukturell geheilt" verbuchten Befunden.
*Erkennungsmerkmal:* jede Ersetzung eines Eigenbaus durch ein Standardwerkzeug. R-6 trifft die Wirkung, nicht die Ursache.
STATUS LT. QUELLE: nur-hinweis (Regel-Vorschlag, ins Dossier uebernommen)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 048
GEGENSTAND: R-15: R-15 -- Ein Identitaets-Stempel ist nur so gut wie die Menge der Eingaenge, die ihn veraendern.
ORT: abi_adapter.hpp
SOLL/FIX: **R-15 -- Ein Identitaets-Stempel ist nur so gut wie die Menge der Eingaenge, die ihn veraendern.**
Jede Groesse, die die Binary veraendert und **nicht ins Preimage reist**, ist ein programmierter Falsch-Skip: `dll_is_current` ist genau ein Vergleich.
*Anlassfall:* `COMDARE_MEASUREMENT_ON` -- 30 ABI-wirksame Stellen im `abi_adapter.hpp`, **0** im gesamten `abi/`-Preimage-Baum. Fuenf Vertreter derselben Klasse an einem Tag; das Heft fuehrt einen davon (H-4).
*Prueffrage:* **Welche Groessen veraendern die Binary? Welche davon stehen im Preimage? Die Differenz ist die Liste der stillen Falsch-Skips.**
STATUS LT. QUELLE: nur-hinweis (Regel-Vorschlag, ins Dossier uebernommen)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 049
GEGENSTAND: R-16: R-16 -- Eine gespiegelte Wache ist eine zweite Quelle.
ORT: ci_diff_ascii_width_guard.sh
SOLL/FIX: **R-16 -- Eine gespiegelte Wache ist eine zweite Quelle.**
Ab dem Tag der Spiegelung ist *"die Wache sagt gruen"* keine Aussage mehr, solange nicht gesagt ist, **WELCHE**.
*Anlassfall:* ce- und super-Fassung von `ci_diff_ascii_width_guard.sh` -- `.sh` im Scope der einen, nicht der anderen; `--seit-basis` nur in der Kopie, waehrend das schwaechere Original das groessere Repo bewacht.
*Erkennungsmerkmal:* zwei Dateien gleichen Namens in zwei Repos, gepflegt wird eine. Kreuzung aus R-7 und Kapitel IV.
STATUS LT. QUELLE: nur-hinweis (Regel-Vorschlag, ins Dossier uebernommen)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 050
GEGENSTAND: R-17: R-17 -- Die Ablage darf ihren eigenen Beleg nicht verschlucken.
ORT: unbekannt
SOLL/FIX: **R-17 -- Die Ablage darf ihren eigenen Beleg nicht verschlucken.**
Ein Beweisstueck, dessen Dateiendung auf ein Ignoriermuster passt, verschwindet **lautlos**: `git add` schweigt, der Commit ist gruen, der Beleg fehlt.
*Anlassfall:* `*.log` in beiden `.gitignore` -- 78 von 155 Gate-Logs unter `docs/sessions/backups/` liegen in keinem git-Objekt.
*Heilung:* nicht `git add -f` (der Name loest die Falle weiter aus), sondern eine Endung ausserhalb jedes Ignoriermusters.
STATUS LT. QUELLE: nur-hinweis (Regel-Vorschlag, ins Dossier uebernommen)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 051
GEGENSTAND: R-18: R-18 -- Jeder Befund traegt den Zeitstempel seiner Messung und den Zweigkopf, gegen den gemessen wurde.
ORT: 38381ac8
SOLL/FIX: **R-18 -- Jeder Befund traegt den Zeitstempel seiner Messung und den Zweigkopf, gegen den gemessen wurde.**
Sonst ist er ein Beleg mit Verfallsdatum, und das Heft wird zur vierten Quelle fuer dieselbe Wahrheit.
*Anlassfaelle:* K-1 bis K-4 -- das Dossier fuehrt vier Befunde, die **vor seiner Abfassung** geheilt waren, zwei davon 62 bzw. 57 Minuten vorher. Verschaerfung, die ueber N-2 hinausgeht: **N-T** -- ein Kommentar, der seinen eigenen Messbefehl mitliefert, altert schneller als die Messung, und der Befehl beweist heute das Gegenteil.
*(Der Ledger fuehrt dies bereits als REGEL-ZEILE 17, `38381ac8`. Das Heft sollte sie **uebernehmen**, nicht neu erfinden.)*
STATUS LT. QUELLE: nur-hinweis (Regel-Vorschlag, ins Dossier uebernommen)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 052
GEGENSTAND: R-19: R-19 -- Eine Zusage ueber eine ANZAHL ist eine Vollstaendigkeitsaussage. Ersetze sie durch die Liste.
ORT: unbekannt
SOLL/FIX: **R-19 -- Eine Zusage ueber eine ANZAHL ist eine Vollstaendigkeitsaussage. Ersetze sie durch die Liste.**
Eine Liste altert **sichtbar**, eine Zahl nicht.
*Anlassfall:* "der EINE literale Pin" -- zweimal widerlegt, zweimal stehen gelassen, beim naechsten Bump waren es vier. Gefunden hat es kein Kommentar, sondern der ctest-Doppellauf.
*Schaerft R-3.*
STATUS LT. QUELLE: nur-hinweis (Regel-Vorschlag, ins Dossier uebernommen)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 053
GEGENSTAND: R-20: R-20 -- Ein Code-Kommentar ist Beleg fuer den Code, nie fuer die Absicht.
ORT: unbekannt
SOLL/FIX: **R-20 -- Ein Code-Kommentar ist Beleg fuer den Code, nie fuer die Absicht.**
Eine Entlastung, die eine Doktrin aus einem Kommentar zieht, hat die Doktrin nicht geprueft, sondern zitiert.
*Anlassfall (Ledger mittag-15, verbatim):* *"ich habe eine Doktrin-Aussage aus einem Kommentar uebernommen, statt Ledger/Session-Log zu pruefen ... Der Kommentar ... ist Kandidat fuer eine Wahrheits-Korrektur, nicht Beleg."*
*Erkennungsmerkmal:* jede Entkraeftung eines Befunds, deren einziger Beleg im gewachten Code selbst steht. Kapitel IV trifft es nur halb -- hier gewinnt die **schwaechere** Quelle.

---

## Vorschlag zur Einordnung (Struktur des Nachtrags)

- **Kapitel 0 -- Statuskorrektur:** K-1 bis K-11. Elf Positionen, alle nach 20:36 bewegt oder als falsch erwiesen. Das ist der ehrlichste und wichtigste Teil.
- **Kapitel VII -- "Was nie geoeffnet wurde":** N-V, N-X, N-AB, N-R und die drei nie geoeffneten Primaerquellen (`docs/termine/`, Thesis als Spezifikation, die gesicherten Wellen-Berichte). Verallgemeinert R-10 von *"eine Quellenklasse fehlte in der Aufzaehlung"* zu **"die Primaerquelle stand nie in der Aufzaehlung"**.
- **Kapitel VIII -- "Zwei Schreiber auf einem Gegenstand":** N-AD plus die Ledger-/Transkript-Faelle, ausdruecklich als `[Ledger]` markiert. Die einzige Klasse des Tages, die **nicht** "Messung beantwortet falsche Frage" ist, sondern *"zwei Wahrheiten ueber denselben Gegenstand, gleichzeitig geschrieben"*.
- **Kapitel IX -- "Wenn das Heft selbst altert":** K-1..K-4, K-8, N-T, N-W. Traegt **R-18**.
- **In den Sofort-Block:** N-K (Gitlink 8 Landungen zurueck, PMC-Invariante auf dem gebauten Stand abwesend), K-7 (4170 Zeilen + Rohmessdaten unversioniert), K-9/K-10.
- **Nach T1 vorgezogen:** N-A, N-B, N-C, N-E, N-F, N-G, N-H, N-I -- sie betreffen alle die Messkette vor dem ersten 4096er-Batch.

**Keine Datei geschrieben.** Diese Rueckgabe ist Pruefergebnis, nicht Einarbeitung.
STATUS LT. QUELLE: nur-hinweis (Regel-Vorschlag, ins Dossier uebernommen)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier-Nachtrag (+896 Z.)

### [w3azi1rhl.json] 054
GEGENSTAND: LISTE-3 (nicht belegbar): T-9 "Glied [3] deklariert eine Ausstattung, die der Bau ignoriert -- die Deklaration ist eine Luege". Am Objekt widerlegt in der Begruendung: Glied [3] ist die
ORT: anatomy_fingerprint.hpp:428-429
SOLL/FIX: **T-9 "Glied [3] deklariert eine Ausstattung, die der Bau ignoriert -- die Deklaration ist eine Luege".** Am Objekt widerlegt in der Begruendung: Glied [3] ist die **Mess-Tooling-Zeile** (`anatomy_fingerprint.hpp:428-429`: *"Haupt-Wahl + load_framework-Anhang ... NICHT der CEB-Schluessel, Paragraf 62-D trennt beide"*), also die Tooling-**Wahl**. `perm_mess_defines()` setzt `COMDARE_MEASUREMENT_ON=1` -- eine **andere** Groesse. Nichts am Objekt zeigt, dass der Bau die Tooling-Wahl ignoriert. Die tragende Substanz steht in **N-N**; T-9 als eigener Posten faellt weg.
STATUS LT. QUELLE: offen (nicht belegbar, [?]-Rubrik)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier VII.3

### [w3azi1rhl.json] 055
GEGENSTAND: LISTE-3 (nicht belegbar): T-10 `kCebFingerprint` = par.58-Verstoss. Am Objekt bestaetigt ist nur die Form (`ceb_version_stamp.hpp:200`: `anatomy_fingerprint_hex("", "", kCebMeasurementSta
ORT: ceb_version_stamp.hpp:200
SOLL/FIX: **T-10 `kCebFingerprint` = par.58-Verstoss.** Am Objekt bestaetigt ist nur die Form (`ceb_version_stamp.hpp:200`: `anatomy_fingerprint_hex("", "", kCebMeasurementStamp)`). Der Code traegt eine **ausdrueckliche, dokumentierte Gegenbegruendung** (`:188-197`): *"die CEB ist KEIN Tier-Binary ... ihre Identitaet ist ihre CODE-Identitaet (das Mess-ANGEBOT) ... OE-C: CEB und Planer je EIGENES Stempelsystem"*, plus par.62-D im Preimage-Kopf. **Kein Befund, sondern ein Owner-Entscheid** -- er kollidiert mit dem Owner-KERN *"Mess-Achse => CEB+Binaries neu"*. Der par.58-Vorwurf wurde weitergegeben, ohne par.62-D zu lesen: genau die gesuchte Form *"Anklage auf ungepruefter Praemisse"*.
STATUS LT. QUELLE: offen (nicht belegbar, [?]-Rubrik)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier VII.3

### [w3azi1rhl.json] 056
GEGENSTAND: LISTE-3 (nicht belegbar): Owner-Posten 15 (390 Runner-Token nicht rotiert). Nicht nachgefahren: verlangt Vault-PAT und Leseoperationen auf drei Cluster-Projekten, faellt unter die rea
ORT: 20260802
SOLL/FIX: **Owner-Posten 15 (390 Runner-Token nicht rotiert).** Nicht nachgefahren: verlangt Vault-PAT und Leseoperationen auf drei Cluster-Projekten, faellt unter die read-only-Auflage. Zusaetzlich ungeklaerte Zahlen-Kollision: Dossier E-1 nennt **776** in `refs/backup/pre-secret-scrub-20260802`, der Abend-Fund **390** in der Workflow-Sicherung -- zwei Mengen, nie gegeneinander gestellt. Als `[?] UNBELEGT` fuehren, nicht als Befund.
STATUS LT. QUELLE: offen (nicht belegbar, [?]-Rubrik)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier VII.3

### [w3azi1rhl.json] 057
GEGENSTAND: LISTE-3 (nicht belegbar): Owner-Posten 4, Pipeline 15110 und `fb9aefdc` als Heilung. Kein CI-Zugang. Der Mechanismus ist bestaetigt (N-AE), die Pipeline-ID und der Kausalzusammenh
ORT: fb9aefdc
SOLL/FIX: **Owner-Posten 4, Pipeline 15110 und `fb9aefdc` als Heilung.** Kein CI-Zugang. Der **Mechanismus** ist bestaetigt (N-AE), die Pipeline-ID und der Kausalzusammenhang nicht.
STATUS LT. QUELLE: offen (nicht belegbar, [?]-Rubrik)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier VII.3

### [w3azi1rhl.json] 058
GEGENSTAND: LISTE-3 (nicht belegbar): Owner-Posten 7 ("zwei der vier A-8-Fundstellen falsch zugeordnet"). Die Zuordnung der vier Fundstellen habe ich nicht einzeln nachgefahren. Was ich belegt h
ORT: unbekannt
SOLL/FIX: **Owner-Posten 7 ("zwei der vier A-8-Fundstellen falsch zugeordnet").** Die Zuordnung der vier Fundstellen habe ich nicht einzeln nachgefahren. Was ich belegt habe: die A-8-Entlastung hat eine **zu kleine Gegenprobe** (N-S).
STATUS LT. QUELLE: offen (nicht belegbar, [?]-Rubrik)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier VII.3

### [w3azi1rhl.json] 059
GEGENSTAND: LISTE-3 (nicht belegbar): B-3 "`PERF_COUNT_HW_CACHE_LL` liefert auf Zen 5 `errno=2`". Kein prod1-Zugang. Bestaetigt ist die strukturelle Haelfte: bei `ll_ok_==false` bleibt `cache_
ORT: unbekannt
SOLL/FIX: **B-3 "`PERF_COUNT_HW_CACHE_LL` liefert auf Zen 5 `errno=2`".** Kein prod1-Zugang. Bestaetigt ist die **strukturelle** Haelfte: bei `ll_ok_==false` bleibt `cache_misses_l3` 0, waehrend `pmc_available` 1 meldet (N-C). Die vendor-spezifische ENOENT-Aussage bleibt `[BERICHT]`.
STATUS LT. QUELLE: offen (nicht belegbar, [?]-Rubrik)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier VII.3

### [w3azi1rhl.json] 060
GEGENSTAND: LISTE-3 (nicht belegbar): Herkunft der Zahl 845 / 174 / 18714. Belegt ist, dass `--bestand` sie heute nicht liefern kann (zweimal FATAL, EXIT=2) und dass bis zum Abbruch 814/156 
ORT: unbekannt
SOLL/FIX: **Herkunft der Zahl 845 / 174 / 18714.** Belegt ist, dass `--bestand` sie heute nicht liefern **kann** (zweimal FATAL, EXIT=2) und dass bis zum Abbruch 814/156 gemeldet wurden. Aus welchem Lauf die publizierte Zahl stammt, ist **nicht entschieden**. Befund lautet "nicht reproduzierbar", **nicht** "falsch".
STATUS LT. QUELLE: offen (nicht belegbar, [?]-Rubrik)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier VII.3

### [w3azi1rhl.json] 061
GEGENSTAND: LISTE-3 (nicht belegbar): B-9 (super-Wache: untracked-Blindstelle, 897 Fremdcode-Dateien im Scope). Die Scope-Divergenz `.sh` habe ich am Objekt belegt (N-I); den Untracked-Lauf und 
ORT: unbekannt
SOLL/FIX: **B-9 (super-Wache: untracked-Blindstelle, 897 Fremdcode-Dateien im Scope).** Die Scope-Divergenz `.sh` habe ich am Objekt belegt (N-I); den Untracked-Lauf und die 897 habe ich **nicht** reproduziert (verlangt Schreiben im Arbeitsbaum). Als `[?]` mit dem Reproduktionsrezept fuehren.
STATUS LT. QUELLE: offen (nicht belegbar, [?]-Rubrik)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier VII.3

### [w3azi1rhl.json] 062
GEGENSTAND: LISTE-3 (nicht belegbar): B-13 Nenner 407 / B-2-Rezept. Nicht gemessen (verlangt ein Configure des ce-Testbaums, in einer read-only-Runde nicht vertretbar).
ORT: unbekannt
SOLL/FIX: **B-13 Nenner 407 / B-2-Rezept.** Nicht gemessen (verlangt ein Configure des ce-Testbaums, in einer read-only-Runde nicht vertretbar).
STATUS LT. QUELLE: offen (nicht belegbar, [?]-Rubrik)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier VII.3

### [w3azi1rhl.json] 063
GEGENSTAND: LISTE-3 (nicht belegbar): "MEINE 16 Arbeitsfehler". Selbst gezaehlt (`/usr/bin/grep -c '^- \*\*'`): 15 Bullets; der Titel sagt 16. Die Zahl 16 traegt keine Zaehlmethode. N-2, in
ORT: unbekannt
SOLL/FIX: **"MEINE 16 Arbeitsfehler".** Selbst gezaehlt (`/usr/bin/grep -c '^- \*\*'`): **15** Bullets; der Titel sagt 16. **Die Zahl 16 traegt keine Zaehlmethode.** N-2, in der Doktrin-Datei selbst -- als Buchhaltungs-Korrektur, nicht als Befund.
STATUS LT. QUELLE: offen (nicht belegbar, [?]-Rubrik)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier VII.3

### [w3azi1rhl.json] 064
GEGENSTAND: LISTE-3 (nicht belegbar): N-AC Teilaussage "#26 ist am 12.07. vollzogen". Im Ledger nicht sauber auffindbar (`:68` fuehrt PMC-Spalten weiterhin als *"honest-0 bis #26"*). Der Befund i
ORT: unbekannt
SOLL/FIX: **N-AC Teilaussage "#26 ist am 12.07. vollzogen".** Im Ledger nicht sauber auffindbar (`:68` fuehrt PMC-Spalten weiterhin als *"honest-0 bis #26"*). Der Befund ist auf den belegbaren Teil verengt: das Zitat schneidet die Verfallsbedingung weg.
STATUS LT. QUELLE: offen (nicht belegbar, [?]-Rubrik)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier VII.3

### [w3azi1rhl.json] 065
GEGENSTAND: LISTE-3 (nicht belegbar): N-AB Teilaussage "authoritativ 1142 Zeilen". Kein Cluster-Zugang. Belegt ist nur der lokale Stand (846 Zeilen, 11.07.).
ORT: unbekannt
SOLL/FIX: **N-AB Teilaussage "authoritativ 1142 Zeilen".** Kein Cluster-Zugang. Belegt ist nur der lokale Stand (846 Zeilen, 11.07.).
STATUS LT. QUELLE: offen (nicht belegbar, [?]-Rubrik)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier VII.3

### [w3azi1rhl.json] 066
GEGENSTAND: LISTE-3 (nicht belegbar): G-9 (Entlastung eines KRITISCH-Befunds auf einem Code-Kommentar). Ledger-belegt, von mir nicht am Objekt nachgefahren. Die daraus abgeleitete Regel (R
ORT: unbekannt
SOLL/FIX: **G-9 (Entlastung eines KRITISCH-Befunds auf einem Code-Kommentar).** Ledger-belegt, von mir **nicht** am Objekt nachgefahren. Die daraus abgeleitete Regel (**R-20**) schlage ich trotzdem vor, weil ihr Anlassfall im Ledger verbatim steht.
STATUS LT. QUELLE: offen (nicht belegbar, [?]-Rubrik)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier VII.3

### [w3azi1rhl.json] 067
GEGENSTAND: LISTE-3 (nicht belegbar): Die sechs Ein-Schreiber-Verletzungen (T-14/T-15/G-11) als Einzelfaelle. Transkript-/Ledger-Belege, nicht objektpruefbar. Am Objekt belegt ist nur die Vorbed
ORT: unbekannt
SOLL/FIX: **Die sechs Ein-Schreiber-Verletzungen (T-14/T-15/G-11) als Einzelfaelle.** Transkript-/Ledger-Belege, nicht objektpruefbar. Am Objekt belegt ist nur die **Vorbedingung** (N-AD). Ein eigenes Kapitel "Zwei Schreiber auf einem Gegenstand" ist gerechtfertigt, seine Faelle muessen aber als `[Ledger/Transkript]` markiert werden.
STATUS LT. QUELLE: offen (nicht belegbar, [?]-Rubrik)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier VII.3

### [w3azi1rhl.json] 068
GEGENSTAND: LISTE-3 (nicht belegbar): Ob eine der heute gebauten Wachen je in einer echten Pipeline lief. Kein CI-Zugang. Bewiesen ist die Bissfaehigkeit lokal (K-6, N-J) und die Verdrahtung 
ORT: unbekannt
SOLL/FIX: **Ob eine der heute gebauten Wachen je in einer echten Pipeline lief.** Kein CI-Zugang. Bewiesen ist die **Bissfaehigkeit lokal** (K-6, N-J) und die Verdrahtung durch Lesung. Die Restgrenze aus SW-4 (*"der erste echte Lauf ist der Beweis dieser einen Stelle"*) bleibt fuer `lint:diff-hygiene` und die ce-Verdrahtung **unbewiesen**.

---
STATUS LT. QUELLE: offen (nicht belegbar, [?]-Rubrik)
ABHAENGIGKEIT/FLAECHE: eingearbeitet in Dossier VII.3

### [w3azi1rhl.json] 069
GEGENSTAND: LISTE-2 (schon im Dossier, ergaenzen): Owner-1/2/3 (stille Nullen: gitleaks ce/thesis, Token-Praefix)
ORT: Dossier-Stelle: R-1, Klassenmerkmal
SOLL/FIX: Instanzen ergaenzen, keine neue Regel
STATUS LT. QUELLE: teilweise (im Dossier gefuehrt, Ergaenzung noetig)
ABHAENGIGKEIT/FLAECHE: Dossier-Eintrag R-1, Klassenmerkmal

### [w3azi1rhl.json] 070
GEGENSTAND: LISTE-2 (schon im Dossier, ergaenzen): Owner-5 (Landestatus gegen veralteten lokalen `main`)
ORT: Dossier-Stelle: N-3
SOLL/FIX: mit K-10 fortschreiben (super lokal 406 zurueck)
STATUS LT. QUELLE: teilweise (im Dossier gefuehrt, Ergaenzung noetig)
ABHAENGIGKEIT/FLAECHE: Dossier-Eintrag N-3

### [w3azi1rhl.json] 071
GEGENSTAND: LISTE-2 (schon im Dossier, ergaenzen): Owner-6 / T-17 (M-1-Format-Bump 3->4 gegen ueberholten Stand)
ORT: Dossier-Stelle: R-5-verwandt; Glied [3] steht in `anatomy_fingerprint.hpp:429`, 8 Glieder gesamt (`:441`)
SOLL/FIX: als Auftrags-Praemissen-Fehler ergaenzen; s. auch Liste 3
STATUS LT. QUELLE: teilweise (im Dossier gefuehrt, Ergaenzung noetig)
ABHAENGIGKEIT/FLAECHE: Dossier-Eintrag R-5-verwandt; Glied [3] steht in `anatomy_fingerprint.hpp:429`, 8 Glieder gesamt (`:441`)

### [w3azi1rhl.json] 072
GEGENSTAND: LISTE-2 (schon im Dossier, ergaenzen): Owner-12 / 13 (Submodul-Wache, `anhang:forward`)
ORT: Dossier-Stelle: Z-1/D-1/Z-3
SOLL/FIX: auf `[x]` mit `3ccbc501` (K-6)
STATUS LT. QUELLE: teilweise (im Dossier gefuehrt, Ergaenzung noetig)
ABHAENGIGKEIT/FLAECHE: Dossier-Eintrag Z-1/D-1/Z-3

### [w3azi1rhl.json] 073
GEGENSTAND: LISTE-2 (schon im Dossier, ergaenzen): Owner-14 (`cache_misses_l3_ll` = 0 in der CSV)
ORT: Dossier-Stelle: A-2/C-4 `[BERICHT]`
SOLL/FIX: durch **N-C/N-E** ersetzen: Umfang und Begruendung sind widerlegt
STATUS LT. QUELLE: teilweise (im Dossier gefuehrt, Ergaenzung noetig)
ABHAENGIGKEIT/FLAECHE: Dossier-Eintrag A-2/C-4 `[BERICHT]`

### [w3azi1rhl.json] 074
GEGENSTAND: LISTE-2 (schon im Dossier, ergaenzen): Owner-16/17 (Arbeitsbranch, Kette T-1)
ORT: Dossier-Stelle: S-2/S-3/Z-2
SOLL/FIX: mit K-9/K-10/N-AD fortschreiben
STATUS LT. QUELLE: teilweise (im Dossier gefuehrt, Ergaenzung noetig)
ABHAENGIGKEIT/FLAECHE: Dossier-Eintrag S-2/S-3/Z-2

### [w3azi1rhl.json] 075
GEGENSTAND: LISTE-2 (schon im Dossier, ergaenzen): I-6 (Z-7 Restposten (a), Gegenprobe aller Konsumenten)
ORT: Dossier-Stelle: Z-7
SOLL/FIX: Restposten (a) schliessbar; **Restposten "Liste statt Invariante"** bleibt: der Katalog-Codegen haengt an handgeschriebenen `attach`-Aufrufen, der Paper-Codegen an einer Invariante (`ce/CMakeLists.txt`, `GLOBAL PROPERTY COMDARE_TEST_TARGETS`)
STATUS LT. QUELLE: teilweise (im Dossier gefuehrt, Ergaenzung noetig)
ABHAENGIGKEIT/FLAECHE: Dossier-Eintrag Z-7

### [w3azi1rhl.json] 076
GEGENSTAND: LISTE-2 (schon im Dossier, ergaenzen): T-11 (Rotations-Test: Null ohne Nenner, selbst korrigiert)
ORT: Dossier-Stelle: R-1
SOLL/FIX: als **positives Muster** ergaenzen -- der einzige Fall des Tages, in dem die Regel von selbst griff
STATUS LT. QUELLE: teilweise (im Dossier gefuehrt, Ergaenzung noetig)
ABHAENGIGKEIT/FLAECHE: Dossier-Eintrag R-1

### [w3azi1rhl.json] 077
GEGENSTAND: LISTE-2 (schon im Dossier, ergaenzen): T-12 (`GIT_SUBMODULE_STRATEGY: none` => Wache faende ihr eigenes Skript nicht)
ORT: Dossier-Stelle: R-1/R-7, offene Handlung
SOLL/FIX: ist die **Antwort** auf die dort offene Frage "spiegeln oder zentral ziehen": gespiegelt, mit Begruendung
STATUS LT. QUELLE: teilweise (im Dossier gefuehrt, Ergaenzung noetig)
ABHAENGIGKEIT/FLAECHE: Dossier-Eintrag R-1/R-7, offene Handlung

### [w3azi1rhl.json] 078
GEGENSTAND: LISTE-2 (schon im Dossier, ergaenzen): B-13 (jeder neue ce-Test verschiebt den Nenner)
ORT: Dossier-Stelle: SW-2, Betriebs-Auflage
SOLL/FIX: als Auflage ergaenzen; Zahl nicht nachgemessen
STATUS LT. QUELLE: teilweise (im Dossier gefuehrt, Ergaenzung noetig)
ABHAENGIGKEIT/FLAECHE: Dossier-Eintrag SW-2, Betriebs-Auflage

### [w3azi1rhl.json] 079
GEGENSTAND: LISTE-2 (schon im Dossier, ergaenzen): E-j (`anhang:forward` beide Zeiger)
ORT: Dossier-Stelle: Z-1
SOLL/FIX: erledigt, s. K-6
STATUS LT. QUELLE: teilweise (im Dossier gefuehrt, Ergaenzung noetig)
ABHAENGIGKEIT/FLAECHE: Dossier-Eintrag Z-1

### [w3azi1rhl.json] 080
GEGENSTAND: LISTE-2 (schon im Dossier, ergaenzen): E-k (SW-3 Wachen 2/4)
ORT: Dossier-Stelle: SW-3/A-3
SOLL/FIX: Wache 4 geheilt (`kPmcExpected`), Wache 2 **halb** -- s. **N-F**
STATUS LT. QUELLE: teilweise (im Dossier gefuehrt, Ergaenzung noetig)
ABHAENGIGKEIT/FLAECHE: Dossier-Eintrag SW-3/A-3

### [w3azi1rhl.json] 081
GEGENSTAND: Struktur-Vorschlag des Nachtrags (Kapitel 0/VII/VIII/IX, Sofort-Block: N-K, K-7, K-9/K-10; T1 vorgezogen: N-A,N-B,N-C,N-E,N-F,N-G,N-H,N-I -- alle Messkette vor erstem 4096er-Batch)
ORT: unbekannt
SOLL/FIX: ## Vorschlag zur Einordnung (Struktur des Nachtrags)

- **Kapitel 0 -- Statuskorrektur:** K-1 bis K-11. Elf Positionen, alle nach 20:36 bewegt oder als falsch erwiesen. Das ist der ehrlichste und wichtigste Teil.
- **Kapitel VII -- "Was nie geoeffnet wurde":** N-V, N-X, N-AB, N-R und die drei nie geoeffneten Primaerquellen (`docs/termine/`, Thesis als Spezifikation, die gesicherten Wellen-Berichte). Verallgemeinert R-10 von *"eine Quellenklasse fehlte in der Aufzaehlung"* zu **"die Primaerquelle stand nie in der Aufzaehlung"**.
- **Kapitel VIII -- "Zwei Schreiber auf einem Gegenstand":** N-AD plus die Ledger-/Transkript-Faelle, ausdruecklich als `[Ledger]` markiert. Die einzige Klasse des Tages, die **nicht** "Messung beantwortet falsche Frage" ist, sondern *"zwei Wahrheiten ueber denselben Gegenstand, gleichzeitig geschrieben"*.
- **Kapitel IX -- "Wenn das Heft selbst altert":** K-1..K-4, K-8, N-T, N-W. Traegt **R-18**.
- **In den Sofort-Block:** N-K (Gitlink 8 Landungen zurueck, PMC-Invariante auf dem gebauten Stand abwesend), K-7 (4170 Zeilen + Rohmessdaten unversioniert), K-9/K-10.
- **Nach T1 vorgezogen:** N-A, N-B, N-C, N-E, N-F, N-G, N-H, N-I -- sie betreffen alle die Messkette vor dem ersten 4096er-Batch.

**Keine Datei geschrieben.** Diese Rueckgabe ist Pruefergebnis, nicht Einarbeitung.
STATUS LT. QUELLE: nur-hinweis (Einordnung)
ABHAENGIGKEIT/FLAECHE: -

### [w3azi1rhl.json] 082
GEGENSTAND: EINGEARBEITET-Quittung: Dossier-Nachtrag komplett (+896 Z. append-only); eigene Zahlen-Abweichungen: 5708 statt 4170 unversionierte Zeilen (7 Dokumente), 25 von 66 Messdateien per .gitignore:39 (*.csv) verschluckt; neue Fehler-Gestalten (Heft ohne Zeitstempel = stille Wache; tautologische Messung 557d8023; zwei Schreiber)
ORT: /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260806-DOSSIER-regressionen-checkheft.md | 20260806 | 557d8023
SOLL/FIX: **Pfad:** `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260806-DOSSIER-regressionen-checkheft.md`

**Zeilenzahl:** vorher **1590** -> nachher **2486** (+896). `git diff --numstat` gegen `origin/development`: **896 Zusatzzeilen, 0 geloeschte** -- strikt append-only, von git selbst bestaetigt. Keine andere Datei geaendert (die drei weiteren ` M`-Eintraege im Klon bestanden vor Arbeitsbeginn).

**Neue Befunde: 31** (N-A..N-AE, je mit Ort/Beleg/Klassenmerkmal/naechster Handlung), dazu **11 Statuskorrekturen am Heft selbst** (K-1..K-11), **15 nicht belegbare Posten** (VII.3) und **21 Nachtrags-Zeilen** unter bestehenden Eintraegen. Kapitel VII, weil VI bereits vergeben war.

Vier Posten der Startliste tragen **nicht** und stehen in VII.3 statt im Checkheft -- u. a. "Glied [3] ist eine Luege" (am Objekt widerlegt: Glied [3] ist die Mess-Tooling-Wahl, Paragraf 62-D trennt sie ausdruecklich vom CEB-Schluessel) und der `kCebFingerprint`-Paragraf-58-Vorwurf (dokumentierter Owner-Entscheid, nicht Befund). Drei eigene Zahlen weichen von der Startliste ab und stehen mit meiner Messung drin: **5708** statt 4170 unversionierte Zeilen (7 Dokumente, nicht 5) und **25 von 66** Messdateien per `.gitignore:39` (`*.csv`) verschluckt -- nicht nur die 78 Gate-Logs.

**Neue Regeln:**
- **R-11** Keine Ursache ohne Messung (Fehlerausgabe darf keine Ursache *nennen*, die sie nicht *gemessen* hat)
- **R-12** Richtung ist nicht Erreichbarkeit (`--is-ancestor <zeiger> origin/<zielzweig>`, nicht `<alt> <neu>`)
- **R-13** Eine Wache darf nicht im Gegenstand ihrer eigenen Fehlerklasse wohnen -- und ihr Sollwert nicht aus demselben Commit stammen wie ihr Istwert
- **R-14** Eine Migration erbt die Fehlerklasse, die sie beseitigt
- **R-15** Ein Identitaets-Stempel ist nur so gut wie die Menge der Eingaenge, die ihn veraendern
- **R-16** Eine gespiegelte Wache ist eine zweite Quelle
- **R-17** Die Ablage darf ihren eigenen Beleg nicht verschlucken
- **R-18** Jeder Befund traegt Zeitstempel und Zweigkopf (uebernommen aus Ledger-REGEL-ZEILE 17, nicht neu erfunden)
- **R-19** Eine Zusage ueber eine ANZAHL ist eine Vollstaendigkeitsaussage -- ersetze sie durch die Liste
- **R-20** Ein Code-Kommentar ist Beleg fuer den Code, nie fuer die Absicht

**Neue Fehler-Gestalt** (VII.5 fuehrt drei, die die These nicht abdeckt; die tragende in einem Satz):

> Eine Messung kann korrekt sein und die *richtige* Frage beantworten -- und trotzdem falsch sein, weil ihr Gegenstand sich zwischen Messung und Aussage bewegt hat; vier Befunde dieses Hefts waren bei seiner Abfassung bereits geheilt, zwei davon 62 und 57 Minuten vorher, weshalb ein Checkheft ohne Zeitstempel selbst eine stille Wache ist.

Die beiden anderen: **(1)** die Messung hat nie stattgefunden und ihr Ausbleiben ist von einem Bestehen ununterscheidbar -- Sonderform *tautologische Messung*, Soll und Ist aus demselben Commit (`557d8023`, Lock-Datei; 0 Treffer in `tests/` bei Nenner 460); **(2)** zwei Schreiber auf einem Gegenstand -- keine Messung, sondern zwei gleichzeitig geschriebene Wahrheiten, Schaden beim Schreiben statt beim Lesen.
STATUS LT. QUELLE: behoben lt. Quelle (Einarbeitung vollzogen); zugrundeliegende Defekte je Einzelstatus oben
ABHAENGIGKEIT/FLAECHE: -

### [w3azi1rhl.json] 083
GEGENSTAND: ROH-SAMMLER[0] Kopf/Erhebungsbasis
ORT: docs/sessions/20260806-DOSSIER-...md | e110cf6d | 20260806
SOLL/FIX: ## SAMMEL-ERGEBNIS `transkript` -- 24 Funde

Transkript flach extrahiert (`jq` -> `/tmp/tr_raw.txt`, 3787 Eintraege aus 7373 JSONL-Zeilen), 89 Owner-Prompts isoliert (`promptSource in {typed,queued}` + `origin.kind=="human"`). Jeder Posten unten ist **am Objekt nachgemessen**, nicht aus dem Transkript uebernommen. Alle Zaehlungen mit `/usr/bin/grep`.

**Zeitliche Grundlage, die alles ordnet:** Das Dossier wurde **20:36:26 UTC** committet (`e110cf6d`) und **seither nie geaendert** (`git log -- docs/sessions/20260806-DOSSIER-...md` -> genau 1 Commit). Der Owner-Auftrag kam **22:32:00**. Dazwischen liegen **fast zwei Stunden**, in denen sechs Dossier-Posten geheilt und zehn neue Regressionen entstanden sind.

---

# A. DAS DOSSIER SELBST TRAeGT DREI VERALTETE BEFUNDE

Das ist die schwerste Klasse des Nachtrags: das Dokument, dessen par.0.1 sagt *"Jeder Befund unten wurde am Objekt nachgeprueft"*, fuehrt drei Posten als `[ ] OFFEN`, die **vor oder kurz nach seiner Abfassung geheilt waren**.
STATUS LT. QUELLE: nur-hinweis (Erhebungsbasis des Sammlers)
ABHAENGIGKEIT/FLAECHE: -

### [w3azi1rhl.json] 084
GEGENSTAND: ROH: T-1 * C-2 war 13 Minuten VOR dem Auftrag geheilt -- der Befund ist falsch
ORT: diplomarbeit.tex | diplomarbeit.tex:280-285 | bdd1e16
SOLL/FIX: ### T-1 * C-2 war 13 Minuten VOR dem Auftrag geheilt -- der Befund ist falsch
- **Dossier:** `:1332-1342` -- *"8 nicht eingebundene Alt-Kapitel, 7 davon unmarkiert"*, `:1334` *"(heute nachgezaehlt) ... 7 sind unmarkiert"*.
- **Am Objekt gemessen (jetzt):** alle **8** nicht eingebundenen `kapitel/de/*.tex` tragen in Zeile 1 den Vermerk `% NICHT eingebunden (Stand 06.08.2026): diese Datei ist in diplomarbeit.tex nicht referenziert.` -- Gegenprobe ueber die 6 eingebundenen aus `diplomarbeit.tex:280-285`.
- **Heilender Commit:** thesis `bdd1e16` *"docs(kapitel): die sieben unmarkierten Alt-Kapitel als NICHT eingebunden kennzeichnen (DE+EN)"*, **19:34:39 UTC** -- der Owner-Auftrag fuer das Dossier kam 19:47:58.
- **Transkript-Beleg, dass es bekannt war** (19:51:24 / 19:52:08): *"**Meine Pruefung war falsch** -- die gelisteten Dateien sind die **aktiven** Kapitel"* / *"Alle acht Alt-Kapitel sind markiert -- der Agent hat den Punkt bereits erledigt."*
- **Status:** `[x]` geheilt; **Dossier-Eintrag zu streichen/umzuschreiben.**
- **Fehlerklasse:** R-9/N-3 auf sich selbst angewandt -- das Heft misst gegen einen Stand, der schon weiter war. **Verschaerfend:** das Wissen lag im selben Kontext vor, in dem das Heft geschrieben wurde.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 085
GEGENSTAND: ROH: T-2 * C-4 war 8 Minuten VOR dem Auftrag geheilt
ORT: 05_evaluation.tex:84-92 | kapitel/de/05_evaluation.tex:91-98 | 19e1592
SOLL/FIX: ### T-2 * C-4 war 8 Minuten VOR dem Auftrag geheilt
- **Dossier:** `:1350-1362` -- *"Praezisionsluecke zu den Zaehlern"*, Ort `05_evaluation.tex:84-92`, Handlung *"Limitierung praezisieren statt Anhang kuerzen (~30 min DE+EN). T2"*.
- **Am Objekt (jetzt), `kapitel/de/05_evaluation.tex:91-98`:** *"Davon zu trennen ist, welche Zaehler dieser Zugang in der vorliegenden Fassung tatsaechlich fuellt: Die Mess-Kette oeffnet ueber `perf_event_open` genau drei generische Zaehler -- L1D-Misses, Last-Level-Misses und dTLB-Misses. ... Die zugehoerigen Spalten tragen deshalb keine *gemessene* Null: Sie sind als *nicht implementiert* zu lesen."* Der vom Dossier zitierte Text existiert in dieser Form nicht mehr.
- **Heilender Commit:** `19e1592^^` *"docs(kapitel 5): das privilegierte Regime praezisieren -- Zugang und tatsaechlich gefuellte Zaehler trennen (DE+EN)"*, **19:39:55 UTC**.
- **Status:** `[x]` geheilt -- **aber siehe T-3**, die Heilung ist inzwischen wieder falsch.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 086
GEGENSTAND: ROH: T-3 * Die Heilung von C-4 wurde 2,5 Stunden spaeter widerlegt und steht unkorrigiert in der Abgabe
ORT: libs/cache_engine/builder/linux_perf_pmc_source.hpp:223-227
SOLL/FIX: ### T-3 * Die Heilung von C-4 wurde 2,5 Stunden spaeter widerlegt und steht unkorrigiert in der Abgabe
- **Der neue Text behauptet drei geoeffnete Zaehler.** Um **22:05** wurde am Objekt bewiesen: auf der **Produktions-AMD-Maschine** existiert der dritte nicht.
- **Transkript, verbatim (22:05:08 / 22:06:24):** *"`event=cache_misses_l3_ll type=3 config=65538 errno=2 (No such file or directory)` ... L2/L3 sind auf prod1 nicht ?null', sie **existieren in dieser Kodierung nicht**."*
- **Am Objekt bestaetigt** (`ce origin/development`):
  - `libs/cache_engine/builder/linux_perf_pmc_source.hpp:223-227` -- `ll_ok_ = c_ll_.open(PERF_TYPE_HW_CACHE, ..., "cache_misses_l3_ll");`
  - `:262` -- `measurement::PmcCounters c;` (POD-Default, **alle 0**); bei `ll_ok_==false` bleibt `c.cache_misses_l3 = 0`.
  - `:230` -- `ready_ = l1d_ok_ || ll_ok_ || dtlb_ok_;` und `any` -> **`pmc_available` wird 1**, obwohl der L3-Zaehler nie geoeffnet wurde.
- **Status:** `[ ] OFFEN`, **T1** -- der Satz "genau drei generische Zaehler" steht DE+EN in der Abgabe und ist fuer prod1 unwahr.
- **Fehlerklasse:** NEU -- *"eine Heilung, die zur Regression wurde, weil der geheilte Text praeziser wurde als die Wirklichkeit"*. Praezision ohne Nachmessung ist gefaehrlicher als Vagheit.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 087
GEGENSTAND: ROH: T-4 * C-1 (17 stumme Anhang-Eintraege) ist geheilt -- und die Zahl 29 stimmt nicht
ORT: anhang/de/A_measurements.tex | 19e1592
SOLL/FIX: ### T-4 * C-1 (17 stumme Anhang-Eintraege) ist geheilt -- und die Zahl 29 stimmt nicht
- **Dossier `:1326-1330`:** *"29 Anhang-Eintraege ohne Datei, 17 davon voellig stumm ... Live gemessen: DE 29 / 17 stumm"*.
- **Am Objekt (jetzt):** `/usr/bin/grep -c '}{}{}' anhang/de/A_measurements.tex` = **0**, EN = **0**. Historie: `19e1592^` = 29 Eintraege / 17 stumm, `19e1592` (**21:08:08**) = **0** stumm.
- **Zahlen-Praezisierung:** `InputIfFileExists` heute **30**, bei `19e1592^` **29**. Der heilende Commit-Titel sagt "**28** Abbildungs-Eintraege". **Drei Zahlen (28/29/30) fuer denselben Gegenstand** -- keine traegt ihre Zaehlmethode. Exakt N-2.
- **Status:** `[x]` geheilt, **Zahl im Heft zu korrigieren** mit Zaehlmethode.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 088
GEGENSTAND: ROH: T-5 * R-1 / R-7 "der super hat keine Kopie der Wache" ist erledigt
ORT: scripts/ci_diff_ascii_width_guard.sh | 7780c6af
SOLL/FIX: ### T-5 * R-1 / R-7 "der super hat keine Kopie der Wache" ist erledigt
- **Dossier `:199` / `:314`:** *"`find` ueber den super ... liefert **0** Treffer (heute nachgemessen; der super hat ueberhaupt kein `scripts/`-Verzeichnis) ... **T3**"*.
- **Am Objekt:** `git -C super ls-files scripts/` = **1 Datei**: `scripts/ci_diff_ascii_width_guard.sh`. Commit `7780c6af` *"feat(ci): super-eigene ASCII-/Breiten-Wache + Einhaengung als lint:diff-hygiene"*, **21:11:32 UTC**.
- **Bonus-Beleg aus derselben Welle (Transkript 21:23:03):** `super/Code/tests/CMakeLists.txt:202` verwies woertlich auf `(scripts/ci_diff_ascii_width_guard.sh)` -- **auf einen Pfad, den es im super nie gab.** Am Objekt bestaetigt: die Zeile steht dort, und `scripts/` entstand erst um 21:11.
- **Status:** `[x]` -- **T3-Posten schliessen.**

---

# B. INDIREKTE REGRESSION: EINE HEILUNG, DIE IHRE EIGENE DOKUMENTATION 22 MINUTEN SPAeTER FALSCH MACHTE
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 089
GEGENSTAND: ROH: T-6 * Der `.gitmodules`-Kommentar behauptet eine Messung, die reproduzierbar 3 statt 0 liefert
ORT: super/.gitmodules | .gitlab-ci.yml | 123b2f32 | 20260931
SOLL/FIX: ### T-6 * Der `.gitmodules`-Kommentar behauptet eine Messung, die reproduzierbar 3 statt 0 liefert
- **Ort:** `super/.gitmodules`, Kommentarblock aus `123b2f32` (**21:09:41 UTC**), verbatim:
  > *"DIE TOTE EINBINDUNG ist `Code/external/20260931-overleaf-diplomarbeit`. Als PFAD kommt sie in .gitlab-ci.yml **NULL Mal** vor (gemessen: `grep -n "Code/external/20260931" .gitlab-ci.yml -> exit 1`)."*
  > *"Der Rueckschrieb-Job `anhang:forward` bumpt **NUR** `thesis/diplomarbeit` (:1111). ... `verify:submodules` (:309) prueft nur den lebenden Pfad."*
- **Nachgemessen mit exakt dem angegebenen Muster:** `/usr/bin/grep -c "Code/external/20260931" .gitlab-ci.yml` = **3** (Zeilen `102`, `377`, `1170`). Zeile 1170 lautet: `THESIS_GITLINKS="thesis/diplomarbeit Code/external/20260931-overleaf-diplomarbeit"`.
- **Ursache:** `18a0bdf3` *"ci(thesis): Rueckschrieb bumpt BEIDE Thesis-Gitlinks + Paritaets-Wache in verify:submodules"*, **21:32:12 UTC** -- **22 Minuten nach** dem Kommentar. Die Heilung ist gelandet, die Wunde-Beschreibung nicht nachgezogen.
- **Folge fuer die Owner-Liste:** Posten **13** (`anhang:forward` bumpt nur einen Zeiger, selbstverriegelnde Divergenz) ist **GEHEILT** -- er darf nicht als offen ins Heft.
- **Fehlerklasse:** NEU -- *"ein Kommentar, der eine Messung mitliefert, altert schneller als die Messung"*. Verschaerfung zu N-2: hier altert nicht die Zeilenangabe, sondern die **Aussage samt Befehl**, und der Befehl beweist heute das Gegenteil.

---

# C. DER LIVE-BEFUND, DER DIE VORGESCHLAGENE HEILUNG VON R-8 AUSHEBELT
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 090
GEGENSTAND: ROH: T-7 * Der super-Gitlink zeigt "vorwaerts" auf einen Commit, den kein Remote-Zweig kennt
ORT: b-m2-pmc-invariante | 18a0bdf3 | b241a272 | 90bca126
SOLL/FIX: ### T-7 * Der super-Gitlink zeigt "vorwaerts" auf einen Commit, den kein Remote-Zweig kennt
- **Live gemessen, jetzt:**
  ```
  super HEAD           18a0bdf3   (Arbeitsbaum:  M Code/external/comdare-cache-engine)
  Gitlink committet    b241a272
  Gitlink Arbeitsbaum  90bca126
  merge-base --is-ancestor b241a272 90bca126        -> JA  (vorwaerts)
  merge-base --is-ancestor 90bca126 origin/development -> NEIN
  git branch -a --contains 90bca126                 -> nur  b-m2-pmc-invariante
  ce origin/development                              = 2b5ecd29
  ```
- **Warum das der Punkt ist:** Das Dossier setzt in **Z-3 `:998`** als Heilung an: *"Ein `pre-commit`-Hook ..., der fuer jeden veraenderten Gitlink **die Richtung misst** und bei Rueckwaerts-Bewegung abbricht, ist der billigste Dauer-Schutz."* Dieser Hook wuerde hier **durchwinken** -- die Richtung ist vorwaerts. Er wuerde den super auf einen Commit festnageln, der auf **keinem Remote-Zweig** liegt und auf einem Arbeitszweig einer laufenden Welle sitzt.
- **Richtige Frage:** nicht *"vorwaerts?"*, sondern *"von `origin/<zielzweig>` aus erreichbar?"* -- also **R-9 auf den Gitlink angewandt**.
- **Status:** `[ ] OFFEN`, **T1** (vor der naechsten super-Landung). **Der Heilungsvorschlag in Z-3 ist zu korrigieren, nicht nur umzusetzen.**
- **Fehlerklasse:** R-8 **+** R-9 zusammen -- und ein Musterfall fuer "die Heilung trifft neben die Wunde", diesmal in einem noch **ungebauten** Heilmittel.

---

# D. DER FINGERPRINT DECKT NICHT, WAS DIE ABI AeNDERT (schwerster Sach-Neubefund)
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 091
GEGENSTAND: ROH: T-8 * `COMDARE_MEASUREMENT_ON` ist ABI-wirksam und steht in keinem Preimage-Glied -> stiller Falsch-Skip
ORT: libs/cache_engine/anatomy/abi_adapter.hpp | include/cache_engine/abi/anatomy_fingerprint.hpp:427-437 | toolchain_stamp_naht.hpp
SOLL/FIX: ### T-8 * `COMDARE_MEASUREMENT_ON` ist ABI-wirksam und steht in keinem Preimage-Glied -> stiller Falsch-Skip
- **Transkript (21:27:52 / 21:32:56):** *"`MEASUREMENT_ON` ist ABI-wirksam ohne im Preimage zu stehen, was einen **stillen Falsch-Skip** erzeugt"* / *"eine Release-Nachmessung erzeugt eine **andere** Binary mit **identischem** Fingerprint."*
- **Am Objekt vollstaendig belegt (`ce origin/development`):**
  - **ABI-Wirkung:** `libs/cache_engine/anatomy/abi_adapter.hpp` -- `#if COMDARE_MEASUREMENT_ON` an **20 Stellen** (`:393 :589 :1148 :1165 :1258 :1307 :1322 :1331 :1369 :2098 :2350 :2577` u. a.); `:9-10` erzwingt sogar `#error "COMDARE_EXPERIMENT_MODE_ON erfordert COMDARE_MEASUREMENT_ON"`. Der geerbte Interface-Satz des Adapters unterscheidet sich.
  - **Preimage:** `include/cache_engine/abi/anatomy_fingerprint.hpp:427-437` listet die 8 Glieder; `:463-471` baut sie. `/usr/bin/grep -n "MEASUREMENT_ON"` ueber `abi/`, `toolchain_stamp_naht.hpp`, `driver_build_variant_signature.hpp` -> **0 Treffer**.
  - **bvset-Glied [6]** (`driver_build_variant_signature.hpp:33-36`) deckt genau drei Achsen: `page_type`, `simd_extension`, `general_hardware` -- **nicht** die Mess-Schaltung.
- **Warum es heute noch nicht knallt:** `profile_run_facade.cpp:273-275` setzt `-DCOMDARE_MEASUREMENT_ON=1` **hart und unbedingt** in `perm_mess_defines()`. Im CEB-Pfad gibt es also keine Divergenz -- bis jemand die im `README.md:129-131` beschriebene funktional-only-Binary baut.
- **Status:** `[ ] OFFEN`, **T1** -- vor jedem Lager-getragenen Skip-Betrieb.
- **Fehlerklasse:** R-4-verwandt (*Abwesenheit im gesuchten Ort beweist nichts*) plus SW-3 (*die Wache stellt eine andere Frage*): das Preimage deklariert die Mess-**Ausstattung**, nicht die Mess-**Schaltung**.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 092
GEGENSTAND: ROH: T-9 * Glied [3] deklariert eine Ausstattung, die der Bau ignoriert -- die Deklaration ist eine Luege
ORT: anatomy_fingerprint.hpp:428-431 | profile_run_facade.cpp:274
SOLL/FIX: ### T-9 * Glied [3] deklariert eine Ausstattung, die der Bau ignoriert -- die Deklaration ist eine Luege
- **Transkript (21:07:13), verbatim:** *"`perm_mess_defines()` setzt hart `-DCOMDARE_MEASUREMENT_ON=1`, unabhaengig von jeder Tooling-Wahl. Glied [3] **deklariert** eine Mess-Ausstattung, die der Bau ignoriert. **Die Deklaration ist eine Luege** -- nicht ein fehlendes Feld."*
- **Am Objekt:** `anatomy_fingerprint.hpp:428-431` -- `[3] Mess-Tooling-Zeile (Haupt-Wahl + load_framework-Anhang; die CT-Mess-AUSSTATTUNG dieser Tier-Binary)`, gegen `profile_run_facade.cpp:274` (Literal `-DCOMDARE_MEASUREMENT_ON=1`).
- **Fehlerklasse:** **identisch zu SW-5** (`active_telemetry_is_silent()` liefert literal `false`, waehrend 11 Profile `silent="true"` deklarieren). Zwei Vertreter derselben Klasse an zwei Orten -- das macht sie zur **Klasse**, nicht zum Einzelfall: *eine Deklaration in Konfiguration/Preimage, deren Wirkung im Code hart gegenteilig verdrahtet ist.*
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 093
GEGENSTAND: ROH: T-10 * `kCebFingerprint` rendert das Angebot statt der Wahl -- BESTRITTEN, Owner-Entscheid noetig
ORT: builder/ceb_version_stamp.hpp:199-201 | anatomy_fingerprint.hpp:428-429
SOLL/FIX: ### T-10 * `kCebFingerprint` rendert das Angebot statt der Wahl -- **BESTRITTEN, Owner-Entscheid noetig**
- **Transkript-Behauptung (21:07:13):** *"`kCebFingerprint` ist `consteval` ohne jede Abhaengigkeit von der einkompilierten Combo: zwei CEBs mit `[wallclock]` und `[macro]` tragen denselben Schluessel. Das ist ein direkter par.58-Verstoss."*
- **Am Objekt bestaetigt** (`builder/ceb_version_stamp.hpp:199-201`): `kCebFingerprintArray = anatomy_fingerprint_hex("", "", kCebMeasurementStamp)` -- Organ- und System-Glied leer, nur das Mess-**Angebot**.
- **ABER der Code traegt eine ausdrueckliche Gegenbegruendung** (`:188-194`): *"die CEB ist KEIN Tier-Binary ... ihre Identitaet ist ihre CODE-Identitaet (das Mess-ANGEBOT), nicht die Toolchain eines einzelnen Bauauftrags"*, und `anatomy_fingerprint.hpp:428-429` sagt fuer Glied [3] woertlich *"NICHT der CEB-Schluessel, **Paragraf 62-D trennt beide**"*.
- **Status:** `[?]` **Behauptung und Code widersprechen sich dokumentiert.** Nicht als Befund buchen, sondern als **Owner-Entscheid** -- er kollidiert direkt mit dem Owner-KERN *"Mess-Achse => CEB+Binaries neu"*.
- **Warum das hier steht:** Genau die vom Auftrag gesuchte Sorte -- *eine Entlastung/Anklage auf ungepruefter Praemisse*. Der par.58-Vorwurf wurde im Transkript weitergegeben, ohne par.62-D zu lesen.

---

# E. DIE STILLE NULL WAR VIERMAL DA, NICHT DREIMAL -- UND DIE VIERTE HAT EINE ANDERE GESTALT

Die Owner-Liste nennt drei (ce-Submodul, thesis-Submodul, gitleaks-Vorpruefung). Das Transkript belegt **zwei weitere**:
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 094
GEGENSTAND: ROH: T-11 * Der Rotations-Test lieferte eine Null, weil das Verfahren nichts finden konnte
ORT: unbekannt
SOLL/FIX: ### T-11 * Der Rotations-Test lieferte eine Null, weil das Verfahren nichts finden **konnte**
- **Transkript 20:47:20 / 20:47:37, verbatim:** *"**Null ohne Nenner** -- mein Muster hat nichts gefunden, also pruefe ich erst, ob es ueberhaupt finden *kann*."* -> *"**Meine Null war ein Verfahrensfehler:** gitleaks schneidet den Kontext so eng, dass **kein `id`-Feld** im Fragment steht -- die Datei kann die Zuordnung Token->Projekt gar nicht liefern."*
- **Konsequenz:** erst nach der Gegenprobe kam der eigentliche Befund (20:48:07): *"**Akuter Befund: die Token sind nicht rotiert.**"* Haette die erste Null gegolten, waere der Sicherheitsbefund als "nichts gefunden" durchgegangen.
- **Fehlerklasse:** **R-1 in Reinform**, aber der einzige Fall des Tages, in dem die Regel **von selbst gegriffen** hat, bevor jemand fragte. Gehoert als **positives Muster** ins Heft.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 095
GEGENSTAND: ROH: T-12 * Eine Wache, die von einem leeren Submodul-Verzeichnis startet, findet ihr eigenes Skript nicht
ORT: unbekannt
SOLL/FIX: ### T-12 * Eine Wache, die von einem leeren Submodul-Verzeichnis startet, findet ihr eigenes Skript nicht
- **Transkript 21:23:03:** *"Alle super-Lint-Jobs setzen `GIT_SUBMODULE_STRATEGY: none` -- das ce ist dort ein **LEERES Verzeichnis**. Eine Wache, die von dort startet, faende ihr eigenes Skript nicht, und ein nicht gefundenes Skript wird zum uebersprungenen Schritt: **exakt die stille Null, gegen die sie gebaut ist**."*
- **Das ist die Begruendung, warum gespiegelt statt zentralisiert wurde** -- und damit die **Antwort auf die offene Handlung in R-1/R-7**, die das Dossier als noch zu klaerend fuehrt.
- **Fehlerklasse:** SW-4-Familie, aber neuer Mechanismus: nicht eine kaputte Pipe-Stufe, sondern ein **nicht existierendes Werkzeug**, das als "Schritt uebersprungen" durchgeht.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 096
GEGENSTAND: ROH: T-13 * `*.log` in beiden `.gitignore` schluckte Gate-Beweise stumm -- dreimal an einem Tag
ORT: super/.gitignore:49 | ce/.gitignore:73 | 20260806
SOLL/FIX: ### T-13 * `*.log` in beiden `.gitignore` schluckte Gate-Beweise stumm -- **dreimal an einem Tag**
- **Transkript (Kompaktierungs-Bilanz, Punkt 10):** *"**`.gitignore *.log` schluckt Gate-Logs stumm (3x heute)** -> force-add"*.
- **Am Objekt:** `super/.gitignore:49` = `*.log`, `ce/.gitignore:73` = `*.log`. Die geretteten Beweise liegen als `.txt` (`docs/sessions/backups/20260806-b14-nb3/gates/nb3-biss-beweise.txt` u. a., **255 verfolgte Dateien** unter `docs/sessions/backups/`).
- **Fehlerklasse:** NEU -- *"das Beweisstueck verschwindet an der Dateiendung"*. `git add <ignorierte Datei>` schweigt; der Commit ist gruen, der Beleg fehlt. Trifft **jede** Wache, deren Ausgabe als Beweis committet werden soll.

---

# F. ZWEI SCHREIBER AUF EINEM GEGENSTAND -- SECHS FAeLLE, EIN BEINAHE-VERLUST

Die Owner-Liste nennt zwei (Posten 16). Es sind mindestens sechs, und einer war ein **Beinahe-Totalverlust fertiger Arbeit**.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 097
GEGENSTAND: ROH: T-14 * Der Bereinigungs-Auftrag, der zwei fertige Commits geloescht haette
ORT: 2c631551 | 9934a7e5 | 1ba29b63
SOLL/FIX: ### T-14 * Der Bereinigungs-Auftrag, der zwei fertige Commits geloescht haette
- **Transkript 16:00:19** -- Agent-Auftrag gestartet: *"LEAD-AUFTRAG: einen durch einen **unautorisierten Fremd-Schreiber** verunreinigten Worktree in einen definierten Zustand zurueckfuehren"* (Ziel `/home/comdare/wt-b14-golden`, Schritt 4 = Ruecksetzen).
- **16:01:08 -- STOPP**, verbatim: *"Die Lage hat sich waehrend Deines Auftrags gedreht, und **meine Auftragsbeschreibung war falsch**. ... Es war die **WIP einer parallel laufenden, autorisierten B14-NB4-Welle** ... Der Worktree traegt zwei fertige Commits (`2c631551` B1-B11, `9934a7e5` Gate-Spiegel). **Ein Zuruecksetzen auf `1ba29b63` wuerde fertige, mit Bissen belegte Arbeit vernichten.** Dasselbe gilt fuer die `nb4-*.txt`-Gate-Logs: das sind die Beweis-Logs dieser Welle, nicht Muell."*
- **Eigene Einordnung 16:01:48:** *"**Mein Fehler war derselbe wie heute schon zweimal: einen Bericht als Ist-Stand genommen, statt ihn gegen die laufenden Straenge zu pruefen.** Vor Bereinigungs-Auftraegen gehoert ein Lebend-Check."*
- **Zusatzbefund im selben Auftragstext:** der Beweis-Diff lag unter `/home/comdare/.claude/jobs/5a19728e/tmp/codex_unauthorized_edits.diff` -- im Auftrag selbst als *"dieser Ort ist **FLUECHTIG** (Job-Temp)"* markiert. Dieselbe Fluechtigkeits-Klasse, die um 20:50 die 25 MB Workflow-Rohdaten fast gekostet haette (Owner: *"Temp-Verzeichnis nach `/home/comdare/backups-workflow/...`. Von dort verschwinden sie nicht mehr."*).
- **Status:** `[x]` abgefangen, **Klasse `[ ] OFFEN`** -- es gibt keinen erzwungenen Lebend-Check vor Bereinigungs-/Reset-Auftraegen.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 098
GEGENSTAND: ROH: T-15 * Die vollstaendige Liste der Ein-Schreiber-Verletzungen des Tages
ORT: b-a1 | b-m2-pmc-invariante | 0b5ed557
SOLL/FIX: ### T-15 * Die vollstaendige Liste der Ein-Schreiber-Verletzungen des Tages
| # | Zeit | Fall | Beleg |
|---|---|---|---|
| 1 | ~11:5x | Zwei-Schreiber-Kollision im Graph-Worktree | *"**SendMessage an laufenden Workflow-Agenten erzeugt ZWEITE Instanz** -> Workflow gestoppt"* (Kompaktierung, Punkt 2) -- **Harness-Falle, keine Nachlaessigkeit** |
| 2 | ~09:2x | `wt-b-a1` doppelt belegt | *"STOPP-MELDUNG A1-NB ... wird **PARALLEL von einem zweiten Schreiber** bearbeitet -- dieselbe Aufgabe, dieselben Dateien. Bei meinem Start war der Tree LITERAL sauber (`git status --porcelain` leer, HEAD `0b5ed557`)"* |
| 3 | 16:00 | `wt-b14-golden` -- s. T-14 | Beinahe-Verlust |
| 4 | ~mittags | `.tmp`-Ablagepfad ohne Prozess-Kennung | *"E18-SNAP vormittags, Batch-Planer mittags -- **45 Fehlschlaege bei 8 Schreibern**"* |
| 5 | 21:25:03 | In den Branch der laufenden PMC-Welle gemergt | *"**Fehler -- und ein gefaehrlicher.** Der ce-Hauptklon steht auf `b-m2-pmc-invariante`, wo die PMC-Welle **gerade mit ungespeicherten Aenderungen arbeitet**."* |
| 6 | 21:28:40 | Zweiter Fehlgriff derselben Art | *"Der Commit landete auf dem Branch der laufenden CI-Welle."* |

- **Bindende Konsequenz aus dem Transkript (21:32:56):** *"Kein Verlust, aber die Konsequenz ist bindend: **Landungen laufen ab jetzt ueber eigene Worktrees**."*
- **Fehlerklasse:** NEU -- verdient ein eigenes Kapitel. Sie ist **nicht** "Messung beantwortet falsche Frage", sondern *"zwei Wahrheiten ueber denselben Gegenstand, gleichzeitig geschrieben"* -- die Schreib-Variante von Kapitel IV.

---

# G. NICHT GELESENE GRUNDLAGEN -- DIE TEUERSTE KLASSE, UND SIE HAT SECHS VERTRETER
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 099
GEGENSTAND: ROH: T-16 * Sechs Wellen liefen, bevor die gesicherte Vorarbeit gelesen war
ORT: unbekannt
SOLL/FIX: ### T-16 * Sechs Wellen liefen, bevor die gesicherte Vorarbeit gelesen war
- **Owner-Frage 21:05:18:** *"Hattest du gruendlich alle workflow Ergebnisse aus dem letzten Kontext im Backup gelesen und Anknuepfungspunkte zu den aktuellen Aufgaben daraus verglichen?"*
- **Antwort 21:05:43, verbatim:** *"**Nein.** Das muss ich klar sagen: Ich habe die Backups gesichert, auf Geheimnisse geprueft und eingelagert -- **gelesen habe ich sie nicht**. ... Das ist **derselbe Fehler wie heute schon zweimal: gehandelt, bevor die Grundlage gelesen war**."*
- **Ausmass, gemessen 21:06:07:** *"**83 Backup-Berichte beruehren M-1-Themen, 41 PMC, 72 den ObservableTier-Vertrag.** Das ist substanzielle Vorarbeit, die ich **vor** dem Start der Wellen haette abgleichen muessen."*
- **Sofortige Folge:** die **erste Stichprobe** kippte einen laufenden Bau-Auftrag (-> T-17).
- **Regel-Zeile 16, im Transkript 21:32:56 formuliert:** *"**Gesicherte Vorarbeit, die niemand liest, ist verlorene Vorarbeit.** Sechs Wellen liefen, bevor die frueheren Ergebnisse abgeglichen waren. Der Abgleich gehoert **vor** die Welle."*
- **Status:** `[ ] OFFEN` als Prozedur -- nichts erzwingt den Abgleich.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 100
GEGENSTAND: ROH: T-17 * Der M-1-Bauauftrag (Owner-Posten 6) -- am Objekt bestaetigt
ORT: anatomy_fingerprint.hpp:429
SOLL/FIX: ### T-17 * Der M-1-Bauauftrag (Owner-Posten 6) -- am Objekt bestaetigt
- **Am Objekt:** `anatomy_fingerprint.hpp:429` -- `[3] Mess-Tooling-Zeile`, `:441` -- `kAnatomyFingerprintGliedCount = 8`. Das Feld, fuer das ein Format-Bump 3->4 beauftragt war, **steht als Glied [3] von 8 im Preimage**. Welle gestoppt (21:07:25).
- **Fehlerklasse:** R-5-verwandt, aber schaerfer: *"der Auftrag trug die ungepruefte Praemisse, nicht der Bau"* -- Klasse 5 der Selbstkritik (`feedback_eigene_arbeitsfehler_...`).
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 101
GEGENSTAND: ROH: T-18 * Drei Primaerquellen, die diese Session nie geoeffnet wurden
ORT: axis_error.hpp
SOLL/FIX: ### T-18 * Drei Primaerquellen, die diese Session nie geoeffnet wurden
| Quelle | Umfang (transkript-belegt) | Zitat |
|---|---|---|
| `docs/termine/` | **11 Termine, 309 Dateien, 27 docx** | 22:22:54: *"Ich habe **geraten**, wo ein Plan liegt. `docs/termine/` sind **Betreuer-Dokumente -- die Primaerquelle** -- und ich habe sie **diese ganze Session nicht gelesen**."* |
| Thesis als Spezifikation | 80 `.tex` | 22:27:44: *"Nein -- und das ist **derselbe Fehler nochmal**. Ich habe die Thesis diese Session nur als **Bau-Artefakt** behandelt ..., nie als **Anforderungsquelle** gelesen. **Dabei steht es in meinem eigenen Memory: LaTeX ist die Quelle der Implementierung.**"* |
| `axis_error.hpp` | s. T-19 | 22:30:32: *"Du hattest recht -- **zum dritten Mal an einem Abend**. Es ist geplant, und es ist **sogar schon gebaut**."* |
- **Owner-Diagnose 22:22:43, verbatim:** *"Ich sag es dir ja: **Gedaechtnisluecken, es ist alles geplant** und du musst bitte mit explore lesen"*.
- **Fehlerklasse:** NEU und die teuerste: *"die Suchmenge schliesst die Primaerquelle aus"* -- Verallgemeinerung von R-10 (dort: `docs/sessions/*` in keiner Quellenliste; hier: `docs/termine/` und die Thesis).
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 102
GEGENSTAND: ROH: T-19 * Owner-Posten 8 stimmt, die Zahl darin nicht
ORT: axis_error.hpp | topics/organ_axis_error_classes.hpp | tests/unit/test_axis_error_taxonomy.cpp
SOLL/FIX: ### T-19 * Owner-Posten 8 stimmt, die Zahl darin nicht
- **Behauptung:** *"`axis_error.hpp` (655 Zeilen, **vier** disjunkte Enums, static_asserts) existiert seit Wochen."*
- **Am Objekt gemessen** (`ce origin/development`): Datei = **655 Zeilen** [OK]. `/usr/bin/grep -c "^enum class"` = **8**, nicht 4: `CompilerCompilerErrorClass:39`, `SampleStatus:77`, `AdmissionStatus:98`, `BuildCellStatus:119`, `InfraErrorClass:195`, `HardwareProbeErrorClass:227`, `DockErrorClass:270`, `ErrorDomain:338`. Dazu `topics/organ_axis_error_classes.hpp` und `tests/unit/test_axis_error_taxonomy.cpp`.
- **Konsequenz:** Der Posten ist **schwerer**, nicht leichter -- die "neu erarbeitete" Zustands-Leiter dupliziert eine doppelt so reiche Taxonomie. **Zahl im Heft mit Zaehlmethode nachtragen.**

---

# H. DER RUeCKWIRKENDE PRUeFAUFTRAG, DER FORMULIERT UND NIE ZUGESCHNITTEN WURDE
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 103
GEGENSTAND: ROH: T-20 * Alle historischen "ASCII: 0"-Zusagen bleiben unbelegt -- der Umfang wurde ausdruecklich vertagt
ORT: memory/reference_ugrep_ascii_gate_stille_null.md:24
SOLL/FIX: ### T-20 * Alle historischen "ASCII: 0"-Zusagen bleiben unbelegt -- der Umfang wurde ausdruecklich vertagt
- **Auftrag erteilt 16:08:06** (`SendMessage` an `codex-t2a-final`, summary *"ugrep-Falle rueckwirkend ueber alle Gate-Zusagen pruefen"*), Lead-Erwartung: *"Das Ergebnis wird eine **Liste von Gate-Zusagen** sein, die *unbelegt* sind statt falsch."*
- **Ergebnis der Bestandsaufnahme, verbatim:** *"**RUECKWIRKENDE REICHWEITE -- ehrlich begrenzt:** Eine vollstaendige Pruefung jeder historischen ?ASCII: 0'-Zusage ist mit vertretbarem Aufwand nicht moeglich ... Wenn eine echte Reichweitenerhebung ueber Transkripte gewuenscht ist, ist das **eine eigene, deutlich groessere Aufgabe (Umfang vorher klaeren)** -- ich wuerde das NICHT ungefragt anfangen."*
- **Am Objekt bestaetigt:** `memory/reference_ugrep_ascii_gate_stille_null.md:24` traegt genau diesen Satz. **Im Dossier existiert kein entsprechender Posten** (`/usr/bin/grep -c "rueckwirkend" DOSSIER` = 0).
- **Status:** `[ ] OFFEN`, **T3** -- als benannter Posten mit Umfangsentscheid, nicht als Fussnote.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 104
GEGENSTAND: ROH: T-21 * Die dokumentierte Prozedur war die ganze Zeit korrekt -- kaputt war die Gewohnheit
ORT: memory/feedback_ascii_only_comments_and_selfcheck_line.md:37
SOLL/FIX: ### T-21 * Die dokumentierte Prozedur war die ganze Zeit korrekt -- kaputt war die Gewohnheit
- **Am Objekt:** `memory/feedback_ascii_only_comments_and_selfcheck_line.md:37` enthaelt die **korrekte, unescapte** Form: `git diff -U0 -- "$f" | grep '^+' | grep -v '^+++' | grep -P '[^\x00-\x7F]' | grep -v 'par.'`.
- **Bestandsaufnahme, verbatim:** *"dieselbe Merkfeld-Datei dokumentiert **BEREITS die korrigierte, unescaped Form** (`^+++`) als ?Stand nach Nachtrag 26.07.' -- die kaputte escaped Form `\+\+\+` ... taucht in **KEINER** durchsuchbaren Markdown-Session-Doku beider Repos woertlich auf."*
- **Warum das ein eigener Befund ist:** SW-4 heilt die Klasse per Werkzeug -- richtig. Aber der Weg *"Regel dokumentieren"* war hier **nachweislich schon beschritten und hat nicht getragen**: Agenten tippten die kaputte Form aus Gewohnheit, waehrend die Doku daneben die richtige zeigte. **Das ist der zweite Gegenbeweis gegen den Dokumentations-Weg** (der erste ist SW-2, 13.07.).
- **Fehlerklasse:** Verschaerfung zu SW-2 -- *"eine Regel, die nur dokumentiert ist, wird von der Gewohnheit ueberstimmt, auch wenn die Doku sichtbar danebensteht."*
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 105
GEGENSTAND: ROH: T-22 * Eine Zwischen-Falschmeldung wanderte in eine Memory-Datei, bevor sie widerlegt wurde
ORT: reference_ugrep_ascii_gate_stille_null.md
SOLL/FIX: ### T-22 * Eine Zwischen-Falschmeldung wanderte in eine Memory-Datei, bevor sie widerlegt wurde
- **Kette, alle vier Stufen im Transkript:**
  1. Meldung: *"`/usr/bin/grep` ist auf dieser Maschine ugrep"* -> in `reference_ugrep_ascii_gate_stille_null.md` geschrieben (Entry 2263).
  2. Zweiter Agent misst das Gegenteil, Widerspruch offen (2283).
  3. Selbstkorrektur (2284), verbatim: *"Ich habe gemeldet ?/usr/bin/grep ist ugrep'. **Das war falsch.** ... `type grep` -> Shell-Funktion (ugrep 7.5.0, -G); `/usr/bin/grep` -> GNU grep 3.11."*
  4. Aufloesung: die Funktion stammt aus `~/.claude/shell-snapshots/snapshot-bash-*.sh` und **propagiert nicht** in `.sh`-Skripte, `bash -c` oder GitLab-Runner.
- **Status:** `[x]` geheilt, Memory heute korrekt.
- **Fehlerklasse:** NEU und wichtig fuer das Heft: *"eine Behauptung wurde persistiert, bevor die Gegenprobe lief -- die Doktrin-Datei trug den Fehler weiter als jeder Bericht."* Persistenz ist ein **Verstaerker**, nicht nur ein Speicher.

---

# I. ZWEI QUELLEN FUeR DIESELBE WAHRHEIT -- IM EIGENEN DOKUMENTENBESTAND
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 106
GEGENSTAND: ROH: T-23 * Zwei Zehner-Listen von Fehlerklassen vom selben Tag, ohne Querverweis
ORT: memory/feedback_behauptungen_verifizieren_layer_vertraege_halten.md
SOLL/FIX: ### T-23 * Zwei Zehner-Listen von Fehlerklassen vom selben Tag, ohne Querverweis
- **Liste A:** Dossier `R-1` ... `R-10` (`:185-361`).
- **Liste B:** `memory/feedback_behauptungen_verifizieren_layer_vertraege_halten.md`, 30 Zeilen, geschrieben **14:45:48** -- zehn **andere** Klassen:
  > 1. Hartes Literal statt Achse (Kette bis zum letzten Verbraucher pruefen) * 2. Stiller Fallback, gegen den man selbst argumentiert * 3. **Wachen pruefen EXISTENZ statt WERTE** (tautologische `static_assert`s; *"ein Wrapper, der 32 meldet waehrend die Strategie 256 scannt, besteht den Audit"*) * 4. Gruene Tests zementieren die falsche Ordnung -- **auch in umgekehrter Richtung** * 5. `.tmp`-Ablagepfad ohne Prozess-Kennung * 6. Wert zweimal gelesen statt einmal gebunden * 7. **Regex statt echtem Parser** (*"und die Loesung oeffnet ggf. eine NEUE Klasse: `xmllint --nonet` blockt Netz, NICHT das lokale Dateisystem"*) * 8. Zaehler/Bilanz behauptet mehr als gedeckt * 9. Zusage im Kommentar, die der Code nicht haelt * 10. Bestandsfehler unter gruener CI
- **Am Objekt:** Das Dossier nennt die Datei **einmal** (`:608`) und importiert **keine** ihrer zehn Klassen. `/usr/bin/grep -c` im Dossier: `.tmp` = 0, `tautolog` = 0, `Regex statt` = 0, `Wrapper-Audit` = 0, `zweimal gelesen` = 0.
- **Status:** `[ ] OFFEN` -- **die zehn Klassen sind in das Heft zu ueberfuehren oder das Heft muss auf sie verweisen.** Sonst existieren zwei Kanons.
- **Fehlerklasse:** **Kapitel IV, angewandt auf das Heft selbst.** Zusaetzlich R-10: eine Konsolidierung, die eine Quellenklasse (`memory/`) nicht nennt.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 107
GEGENSTAND: ROH: T-24 * Die Selbstkritik-Datei ist mehrdeutig gegen Z-3 und kann den Befund aufheben
ORT: memory/feedback_eigene_arbeitsfehler_lead_berichte_nie_uebernehmen.md | docs/sessions/20260806-ANKNUEPFPUNKTE-vorarbeit-je-aufgabe.md | ce/libs/cache_engine/anatomy/abi_adapter.hpp | 7969b399 | e7aa1244
SOLL/FIX: ### T-24 * Die Selbstkritik-Datei ist mehrdeutig gegen Z-3 und kann den Befund aufheben
- **Ort:** `memory/feedback_eigene_arbeitsfehler_lead_berichte_nie_uebernehmen.md`, Klasse 4, verbatim: *"**?Der Submodul-Zeiger wird stillschweigend zurueckgedreht'** -- falsch herum: ein Commit **ohne** Pathspec haette ihn **RICHTIG** gesetzt."*
- **Das gilt fuer den ce-Gitlink** (Transkript 16:45/16:46: *"`7969b399` -> `e7aa1244`"*), **nicht** fuer den Thesis-Gitlink. Fuer den gilt weiterhin Z-3 (`:986-990`), Transkript-Beleg (Entry 2603): *"ohne Pathspec im super wuerde das Thesis-Repo also nicht ?nachziehen', sondern **um 78 Commits zurueckdrehen** ... Meine Commits waren alle mit Pathspec, deshalb ist bisher nichts passiert."*
- **Problem:** Der Satz nennt das Submodul nicht. Wer ihn allein liest, haelt R-8/Z-3 fuer widerlegt.
- **Status:** `[ ] OFFEN` -- **Satz um den Submodul-Namen ergaenzen.**
- **Fehlerklasse:** NEU -- *"eine Korrektur ohne Gegenstandsangabe hebt einen richtigen Befund auf."* Genau die Kehrseite von R-7 (*eine Zahl wandert ueber eine Repo-Grenze*), hier: **eine Aussage wandert ueber eine Submodul-Grenze.**

---

# J. WEITERE BELEGTE FUNDE, KNAPP

- **`lint:format` hat gemessene blinde Flecken** (Transkript 21:23:03, am Objekt bestaetigt): `ce/.clang-format:33` und `super/.clang-format:33` setzen beide `ReflowComments: false` -> *"140 Spalten rein ASCII in einer Kommentarzeile -> **Exit 0**"*; *"String-Literal mit echten Umlauten -> Exit 0"*; Dateiscope nur C/C++, **nicht** `.cmake`/`CMakeLists.txt`/`.sh`. Gemeldeter Bestand: *"15 ASCII-Zeilen ueber 120 Byte, die `lint:format` heute scannt und durchlaesst"*. -> **Praezisiert R-6:** die beiden Gates sind nicht nur verschiedene Gegenstaende, das Format-Gate ist an dieser Stelle **konstruktiv blind**.
- **Alt-Bestand ungegatet, bewusst** (21:24:01): *"Der Alt-Bestand im super traegt **845 Nicht-ASCII- und 174 Breiten-Zeilen aus 18714 Codezeilen**. Bewusst nicht gegatet -- eine Bestands-Wache waere **am Tag ihrer Einfuehrung rot geboren**."* Offener Aufraeum-Posten, in keiner Liste.
- **S-4 ist zurueck und 2,7-fach gewachsen:** Dossier `:40` nennt "**2042** Zeilen" unversioniert. Jetzt gemessen: **7 untracked Eintraege, davon 6 `.md` mit zusammen 5520 Zeilen** (`docs/plaene/20260806-{ANWEISUNG-pmc-intel-perf-rechte, KLAERUNG-zweiphasig-dreiphasig, PLAN-hybrid-architektur-pmc-achsen-zuordnung, PLAN-hybrid-pmc-numa-core-permutation, PLAN-warnungen-und-ausgabe-bei-messfehlern}.md`, `docs/sessions/20260806-ANKNUEPFPUNKTE-vorarbeit-je-aufgabe.md`) plus `Code/measure_out_d03/`. **Vierte Rueckkehr derselben Klasse an einem Tag.**
- **Der leere Mess-Fenster-Test war in seinem eigenen Kopfkommentar deklariert.** `ce 2b5ecd29` entfernt die Zeile: *"befuellt row.pmc EXAKT ueber die EINE PMC-Quelle (**begin()->[leerer Batch]->end()**)"*. Der Defekt stand wochenlang **woertlich in der Datei** und wurde von niemandem gelesen. **`pmc:intel` ist seit 22:20 GRUeN** (Pipeline 15114 auf `22e17f57`, dann Fensterfix) -- Owner-Posten 11 ist also **`[x]` geheilt**, nicht offen.
- **Die perf-Rechte-Empfehlung war falsch und haette den Owner in eine Cluster-Aenderung geschickt.** 21:43:37 empfahl ich *"(a) intel-Lane die perf-Rechte geben"*, der Owner gab 21:45:51 GO (*"Ein skip ist keine Loesung. Wir machen das richtig"*). 21:4x: *"`perf_event_paranoid = 1` auf **beiden** Maschinen, identisch ... **Haetten wir die perf-Rechte vergeben, haette sich nichts geaendert -- meine Empfehlung von vorhin war falsch.**"* -> **Drei Thesen, zwei widerlegt** (meine, die des Teammates); die dritte (Test misst nichts) belegt mit 13 Traces, 7/7 vs. 6/6.
- **Die CEB-Lesart wurde an einem Abend dreimal korrigiert** (22:02:57 *"meine Aussage ?eine CEB je PMU-Domaenen-Satz' war falsch"*; 22:18:20 *"das ist die **dritte Korrektur meiner Lesart** heute Abend an derselben Stelle. Ich hatte gesagt: ?das Pinning *ist* die Laufzeit-Freigabe in der CEB.' **Falsch.** Die Freigabe sitzt im **Planer**."*). **Klassenmerkmal:** dreimal dieselbe Stelle, jedes Mal durch den Owner korrigiert, nie durch eigene Messung.
- **Namenskollision macht `grep`-Buchfuehrung wertlos** (20:23:03): *"ihre Kennung hat im Ledger zwar Treffer, aber ausnahmslos fuer eine **andere Bedeutung** -- eine Namenskollision, die das Suchen wertlos macht."* -> **NEUE Regel-Kandidatin:** *ein Treffer ist erst ein Beleg, wenn der Suchbegriff eindeutig ist; die Suchmenge ist nicht die Bedeutungsmenge.*
- **Die Fenster-Zusage der 14-Tage-Konsolidierung ist widerlegt** (18:5x): die LB-Kette liegt mit **01.08. innerhalb** des Fensters (23.07.-06.08.), das zusagte, *"alles Aktive"* zu tragen -- `LB-[0-9]` im Ledger **0**, im Register **0**. -> **Verschaerft R-10:** nicht nur eine Quellenklasse fehlte, die **Vollstaendigkeitszusage selbst** ist fuer diese Kette falsch.
- **Der 125.000-Zeichen-Bericht wurde nur am Anfang gelesen** (19:19:14): *"**Der Disjunktheits-Beweis** war 125.000 Zeichen lang und ich hatte nur den Anfang gesehen. Sein Kernsatz **korrigiert meine Annahme** ueber Parallelitaet."* -> gehoert zur Klasse T-16.
- **Ein Fehlalarm ueber Berichtsketten** (13:59:59): *"Der von dir entkraeftete Codex-Befund war also in der Sache **korrekt**, nur die Einordnung als ?fail-closed by design' war falsch"* -- eine **Entlastung**, die selbst falsch war. Genau die vom Auftrag gesuchte Form.
- **Zwei Ausnahme-Sicherheits-Lecks, eines bewusst offen, im Dossier nicht gefuehrt** (`/usr/bin/grep -c "Churn" DOSSIER` = **0**). Am Objekt, `ce/libs/cache_engine/anatomy/abi_adapter.hpp`: *"Die kChurn=2048 Bloecke des Segment-2-Churn (`blocks`) **lecken weiterhin** ... max. 2048 * 256 B = 512 KiB je Fehlschlag. ... **FRUEHERE BEGRUENDUNG, HIERMIT ZURUECKGENOMMEN:** ?liegt im gemessenen T6-Fenster, also nicht ohne Mess-Eingriff heilbar'. ... **STATUS: BEWUSST ZURUECKGESTELLT ..., NICHT ?nicht machbar'.**"*

---

# K. WAS ICH **NICHT** BELEGEN KONNTE -- ausdruecklich

1. **Owner-Posten 15 ("die 390 Runner-Token sind NICHT rotiert")** -- der Mengentest ist read-only im Transkript belegt (20:48:07, 21:00:52), ich habe ihn **nicht nachgefahren**: er verlangt einen Vault-PAT und Leseoperationen auf drei Cluster-Projekten. Steht als `[BERICHT]`, nicht als eigene Messung. Zahlen-Kollision zusaetzlich ungeklaert: Dossier E-1 nennt **776** Token in `refs/backup/pre-secret-scrub-20260802`, der Abend-Fund **390** in der Workflow-Sicherung -- **zwei Mengen, nie gegeneinander gestellt**.
2. **Owner-Posten 12 ("Submodul-Wache prueft Worktree gegen Gitlink ... am Objekt nachgewiesen")** -- im Transkript belegt (21:37: *"Die alte `git submodule status --recursive`-Wache meldet GRUeN bei Nenner 2 ... Meine Annahme ?die Wache faengt es, nur zu spaet' war falsch"*). Ich konnte es **nicht am Objekt reproduzieren**, weil `18a0bdf3` (21:32) `verify:submodules` bereits um eine Paritaets-Wache ergaenzt hat -- der Vorzustand ist nur noch ueber `git show 18a0bdf3^` zugaenglich, was ich im Umfang dieses Auftrags nicht gefahren habe. Als `[?]` fuehren oder gegen `18a0bdf3^` nachfahren.
3. **Owner-Posten 4 (der weggefilterte `DIFF-HYGIENE-WACHE:`-Verdikt, Pipeline 15110)** -- Selbstmeldung woertlich belegt (21:43:37), Heilung `fb9aefdc` genannt. Ich habe **weder die Pipeline-ID 15110 noch `fb9aefdc`** verifiziert (keine API-Abfrage im Umfang dieses Auftrags).
4. **Die "16 Arbeitsfehler"** -- die Memory-Datei nennt 16 im Titel; ich zaehle in ihr **15 einzeln aufgefuehrte Faelle** ueber 5 Klassen (4+3+3+4+3, minus eine Doppelnennung je nach Zaehlweise), die Kompaktierungs-Bilanz listet **12**. **Die Zahl 16 traegt keine Zaehlmethode.** N-2, in der Doktrin-Datei selbst.
5. **"Zwei der vier A-8-Fundstellen waren falsch zugeordnet" (Owner-Posten 7)** -- Widerlegung im Transkript belegt (21:37:39: *"BEIDE Befunde widerlegt -- bereits heute geheilt, nichts gebaut"*; 21:3x: *"`system_axis.hpp:347` zieht `line_bytes` aus `axis_stats[5][5]`, fail-closed bei 0. **Exakt der Weg, den ich als ?zu bauen' beschrieben hatte.** Selbst nachgemessen"*). Die **Zuordnung der vier Fundstellen** habe ich nicht einzeln nachgefahren.

---

# L. EMPFOHLENE STRUKTUR DES NACHTRAGS

Der Nachtrag braucht **drei neue Kapitel** und **eine Statuskorrektur**:

- **Statuskorrektur zuerst** (Kapitel 0 des Nachtrags): C-1 `[x]`, C-2 `[x]` (Befund war falsch), C-4 `[x]`+neue Regression T-3, R-1/R-7-Handlung `[x]`, Owner-Posten 11 `[x]`, Owner-Posten 13 `[x]`. **Sechs Posten**, alle nach 20:36 bewegt. Dazu S-4 mit neuer Zahl (2042 -> 5520).
- **Kapitel VII -- "Zwei Schreiber auf einem Gegenstand"** (T-14, T-15): sechs Faelle, ein Beinahe-Verlust, eine Harness-Falle. Die einzige Klasse des Tages, die **nicht** "Messung beantwortet falsche Frage" ist.
- **Kapitel VIII -- "Was nie geoeffnet wurde"** (T-16, T-18, T-20, T-23): `docs/termine/` (309 Dateien), die Thesis als Spezifikation, 83+41+72 Backup-Berichte, der vertagte Rueckwirk-Auftrag, die zweite Zehner-Liste. Verallgemeinert R-10 von "eine Quellenklasse fehlte in der Aufzaehlung" zu **"die Primaerquelle stand nie in der Aufzaehlung"**.
- **Kapitel IX -- "Wenn das Heft selbst altert"** (T-1..T-6, T-24): das Dossier traegt drei tote Befunde, eine `.gitmodules`-Messung reproduziert 3 statt 0, eine Korrektur ohne Gegenstandsangabe hebt Z-3 auf. **Regel-Kandidatin R-11:** *jeder Befund traegt den Zeitstempel seiner Messung und den Zweig-Kopf, gegen den gemessen wurde -- sonst ist er ein Beleg mit Verfallsdatum, und das Heft wird zur vierten Quelle fuer dieselbe Wahrheit.*
- **Regel-Kandidatin R-12** (aus T-7): *Richtung ist nicht Erreichbarkeit. Bei jedem Gitlink gilt `merge-base --is-ancestor <zeiger> origin/<zielzweig>`, nicht `--is-ancestor <alt> <neu>`.* -- Sie **korrigiert den in Z-3 vorgeschlagenen Hook, bevor er gebaut wird.**
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 108
GEGENSTAND: ROH-SAMMLER[1] Kopf/Erhebungsbasis
ORT: /journal.json | b-ci-rueckschrieb-beide-zeiger | b-m2-pmc-invariante | 5a19728e | e3fda9ac35a1
SOLL/FIX: ## SAMMEL-AUFTRAG `journale-und-berichte` -- Rueckgabe

**Erhebungsbasis.** 206 `result`-Ereignisse aus 79 Journalen unter `/home/comdare/.claude/projects/-home-comdare/5a19728e-f6e1-4736-a246-e3fda9ac35a1/subagents/workflows/*/journal.jsonl`, vollstaendig extrahiert und durchsucht. **Jeder Posten unten ist danach am Objekt nachgeprueft** -- der Journalbericht ist nur der Zeiger, der Beleg steht in Code/Git.

**Live-Staende bei dieser Pruefung** (alle per `ls-remote` bzw. `rev-parse`, nicht aus `refs/remotes/*`):

| Gegenstand | Ist |
|---|---|
| super lokaler HEAD | `18a0bdf3` auf Branch **`b-ci-rueckschrieb-beide-zeiger`** -- **auf keinem Remote-Ref** (`ls-remote \| grep -c 18a0bdf3` = 0) |
| super `origin/development` / `origin/main` | `38381ac8` / `2a6f35d8` (**9 zurueck**) |
| ce-Submodul-Checkout | `90bca126` auf Branch **`b-m2-pmc-invariante`** -- **auf keinem Remote-Ref** |
| ce `origin/development` / `origin/main` | `2b5ecd29` / `b241a272` (**8 zurueck**) |
| super Gitlink ce, committet | `b241a272`; Checkout `+90bca126`, Distanz 3, Richtung vorwaerts |

---

# A. Wo ein Agent die AUFTRAGSPRAeMISSE zurueckgewiesen hat
STATUS LT. QUELLE: nur-hinweis (Erhebungsbasis des Sammlers)
ABHAENGIGKEIT/FLAECHE: -

### [w3azi1rhl.json] 109
GEGENSTAND: ROH: A-1 `pmc:intel` -- drei Agenten unabhaengig: "Die Praemisse des Auftrags ist widerlegt." GEHEILT im Erkennen, OFFEN in der Ursache
ORT: m3v2_pmc_smoke.cpp:92-95 | linux_perf_pmc_source.hpp:111-114 | 6701028 | 4048837 | 3314004
SOLL/FIX: ### A-1 `pmc:intel` -- drei Agenten unabhaengig: "Die Praemisse des Auftrags ist widerlegt." **GEHEILT im Erkennen, OFFEN in der Ursache**

`wf_49b32e04-eb8` (4 Ergebnisse). Ueberschriften woertlich: *"KERNBEFUND, DER DEN AUFTRAG UMSTOSST"* * *"## BEFUND: Die Praemisse des Auftrags ist widerlegt. Die intel-Lane HAT PMC-Zugriff."* * *"# BEFUND: `pmc:intel` -- die Praemisse traegt nicht"*.

Beleg aus dem **selben roten Job** (365257, prod2), 0,47 s nach dem Fehlschlag:
```
329: delta.available       = 1
329: delta.cache_misses_l1 = 6701028
329: delta.cache_misses_l3 = 4048837
329: delta.dtlb_misses     = 3314004
329: SMOKE_OK
```
`perf_event_paranoid` = **1 auf beiden Hosts**, shell-Executor, kein Container, Job-Definitionen unterscheiden sich **nur** in `tags:`.

**Der eigentliche Fund ist nicht der Zugriff, sondern die Fehlermeldung.** `m3v2_pmc_smoke.cpp:92-95` (am Objekt, HEAD `90bca126`) druckt bei Fehlschlag:
> `[PMC-FEHLER] COMDARE_ENABLE_PMC ist einkompiliert, die Quelle meldet aber available=0. Ursache pruefen: perf_event_paranoid, CAP_PERFMON/Executor-Rechte, Container ohne perf.`

Agent woertlich: *"die zitierte Ursachenliste ist eine **hartkodierte Vermutung im Testcode**, keine Messung."* Und `linux_perf_pmc_source.hpp:111-114` verwirft `errno` ersatzlos:
```cpp
long const r = perf_event_open(&attr, 0, -1, -1, 0);
if (r < 0) { fd_ = -1; return false; }
```
**Fehlerklasse:** neu. *Eine Diagnose-Ausgabe, die Ursachen NENNT, die sie nie gemessen hat.* Sie hat drei Fehldiagnosen und einen beinahe ausgefuehrten Cluster-Rechte-Eingriff erzeugt. Das ist R-1 ("keine Null ohne Nenner") in der Ausgabe-Richtung: **keine Ursache ohne Messung**. Gehoert als **R-11** ins Dossier.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 110
GEGENSTAND: ROH: A-2 M-1: "Format-Bump 3->4 nicht noetig" steht gegen drei fruehere Berichte -- aber aus dem GEGENTEILIGEN Grund
ORT: unbekannt
SOLL/FIX: ### A-2 M-1: "Format-Bump 3->4 nicht noetig" steht gegen drei fruehere Berichte -- aber aus dem GEGENTEILIGEN Grund
`wf_22b0822f-81d__006`, WIDERSPRUCH 1 woertlich:
> "Die Aussage ?Format-Bump 3->4 voraussichtlich NICHT noetig' steht gegen drei fruehere Berichte, die genau diesen Bump als den Kern-Bau empfehlen -- und zwar **nicht, weil Glied [3] fehlt, sondern weil Glied [3] NICHT AUSREICHT**."
WIDERSPRUCH 3 ebenda: *"Der ?Glied [3] von 8'-Stand gilt nur auf dem T2-A-Stand, nicht auf jedem ce-Stand des Tages."*
**Das korrigiert Posten 6 der Lead-Liste.** Die Welle wurde richtig gestoppt, aber die Begruendung ("Feld steht laengst im Preimage") traegt nur auf einem Stand und beantwortet die Frage nicht, die die drei Vorberichte gestellt hatten. **OFFEN.** Fehlerklasse: R-2 (Bezugs-Stand), angewandt auf einen Bauauftrag.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 111
GEGENSTAND: ROH: A-3 "nur L1D + dTLB" -- zugleich zu pessimistisch UND zu optimistisch
ORT: unbekannt
SOLL/FIX: ### A-3 "nur L1D + dTLB" -- zugleich zu pessimistisch UND zu optimistisch
`wf_22b0822f-81d__001`, WIDERSPRUCH 5. Zwei Berichte derselben Session widersprechen sich direkt; das Dossier hat **den falschen** uebernommen. Siehe **B-3**.

---

# B. Befunde, die im Dossier FEHLEN (am Objekt belegt)
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 112
GEGENSTAND: ROH: B-1 Die Schluessel-Wache liegt in genau dem Job, den sie bewachen soll `[ ] OFFEN` -- schwerster Neubefund
ORT: ce/.gitlab-ci.yml:243 | ci_yaml_key_guard.sh | ci_diff_ascii_width_guard.sh | ae3ba30475a1c7561
SOLL/FIX: ### B-1 Die Schluessel-Wache liegt in genau dem Job, den sie bewachen soll `[ ] OFFEN` -- **schwerster Neubefund**

`ce/.gitlab-ci.yml:243` ist die **einzige** Aufrufstelle von `ci_yaml_key_guard.sh`; `:268` die **einzige** von `ci_diff_ascii_width_guard.sh`. Beide stehen im Skript-Block von `test:coverage-guard`.

Die Wache existiert, weil `contract:axis-version-lock` doppelt vergeben war und YAML kommentarlos die letzte Definition gewinnen liess (SW-1). **Genau dieser Angriff funktioniert gegen ihren eigenen Traeger:** ein zweites `test:coverage-guard:`-Mapping am Dateiende -- ohne den Schluessel-Wachen-Schritt -- loescht alle drei Wachen auf einmal, stumm. Der Job-Kommentar `:223-224` verspricht das Gegenteil:
> "Er kann nicht selbst durchs Raster fallen: seine Eingabe ist die Gesamtmenge, er hat kein rules-Gate und kein allow_failure."

Die Zusage gilt fuer **Tests**, nicht fuer den **Job**. Der Erbauer selbst sagt es (`wf_728af669-2f7 * ae3ba30475a1c7561`, zitiert in `wf_22b0822f-81d__010`, Vorbedingung 6):
> "Wer den Job `test:coverage-guard` loescht oder ihm `allow_failure`/`rules` verpasst, wird von nichts im Repo bemerkt."

**Fehlerklasse:** Kapitel III, Merkmal 4 in Reinform -- die Heilung prueft, ob ein Schluessel doppelt ist, nicht, ob sie selbst noch existiert. **Neue Regel-Kandidatin: eine Wache, deren einziger Aufrufer der Gegenstand ihrer eigenen Fehlerklasse ist.**
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 113
GEGENSTAND: ROH: B-2 `contract:axis-version-lock`: geheilt, aber nie bewiesen, dass sie beissen kann `[ ] OFFEN`
ORT: tools/axis_version_lock/axis_version.lock | measurement_curve_loader.hpp | 557d8023 | a043de49a80bc4fe9
SOLL/FIX: ### B-2 `contract:axis-version-lock`: geheilt, aber **nie bewiesen, dass sie beissen kann** `[ ] OFFEN`

Das Dossier fuehrt SW-1 als `[x] ERLEDIGT`. Am Objekt:
- `/usr/bin/grep -rniE "axis.?version.?lock|AXIS_ALGO_VERSION" ce/tests/` -> **0** (Nenner: gesamter Testbaum).
- Der heilende Commit `557d8023` hat im selben Zug `AXIS_ALGO_VERSION: 2` gesetzt **und die Lock-Datei neu erzeugt**. `sha256sum` der drei Header stimmt heute zeichengleich mit `tools/axis_version_lock/axis_version.lock`. Die Wache ist **gruen per Konstruktion**.

`wf_24104303-f97 * a043de49a80bc4fe9` woertlich:
> "Die Duplikat-Heilung macht den Job aktiv, beweist aber nicht, dass er beisst. [...] **Ohne diesen Test ist ein gruener Job von einem inerten Job weiterhin ununterscheidbar -- exakt der Ursprungsschaden**, der drei Wochen lang zwei reale Semantikdrifts durchliess."

**Fehlerklasse:** exakt die vom Owner gesuchte -- *eine Wache, die seit ihrer Einfuehrung nie ausgeloest hat, und niemand hat geprueft, ob sie ausloesen KANN.* Der Status `[x]` im Dossier ist zu stark; korrekt ist `[~]`. Rezept liegt fertig vor (ein Byte in `measurement_curve_loader.hpp` ohne Bump => Lock muss rot).
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 114
GEGENSTAND: ROH: B-3 `cache_misses_l3` ist vendor-asymmetrisch -- die B5/M-2-Korrektur ist auf der Haupt-Mess-Lane wieder falsch `[ ] OFFEN`
ORT: ce/libs/cache_engine/builder/linux_perf_pmc_source.hpp:9-17
SOLL/FIX: ### B-3 `cache_misses_l3` ist **vendor-asymmetrisch** -- die B5/M-2-Korrektur ist auf der Haupt-Mess-Lane wieder falsch `[ ] OFFEN`

Der Kopf von `ce/libs/cache_engine/builder/linux_perf_pmc_source.hpp:9-17` ist selbst eine **Selbstkorrektur vom 06.08.**, woertlich:
> "der Kopf sagte frueher ?+6 HW-Counter (... best-effort L2/coherence, RAPL-energy)'. Das war die aeltere, zu optimistische Fassung und **widersprach dem eigenen Code weiter unten**. TATSAECHLICH GEOEFFNET werden DREI generische Counter -- cache_misses_l1 ..., **cache_misses_l3 (LAST-LEVEL/READ/MISS, ehrlich LL)** und dtlb_misses ... cache_misses_l2 und coherence_invalidations bleiben AUCH MIT dem Flag 0"

**Die korrigierte Fassung ist auf prod1 falsch.** `wf_49b32e04-eb8__004` (eigene C-Sonde, auf prod1 gefahren): `PERF_COUNT_HW_CACHE_LL` laesst sich auf Zen 5 **gar nicht oeffnen** -- `errno=2 (No such file or directory)`. `wf_7daeeecc-a83__003` hat es per strace-Zeile: `perf_event_open(...PERF_COUNT_HW_CACHE_LL...) = -1 ENOENT`. `wf_7daeeecc-a83__006` aus echten Job-Traces: `cache_misses_l3 = 0` in **5 von 5** AMD-Laeufen, **3,2-4,1 Mio in 4 von 4** Intel-Laeufen.

Der Pruefer benennt es selbst als Folgeschaden der Heilung:
> "**Folgeschaden in der Doku, die B5 gerade erst ?korrigiert' hat:** ... Auf der AMD-Lane ist `cache_misses_l3` eine **dritte** honest-0-Spalte. Die B5-Korrektur ist damit auf der Haupt-Mess-Lane selbst wieder falsch -- und im Anhang stuende L3 als gemessen." (`wf_7daeeecc-a83__003`)

**Das trifft das Dossier direkt.** A-2 und C-4 tragen `[BERICHT]`: *"Nur L1D und dTLB liefern real; L2/L3/Kohaerenz/Energie bleiben wegen I-PMC-2/3 (Zen-5-RAW-Events) auf 0."* Beides ist widerlegt:
- **Umfang:** L3 liefert auf Intel real. Die Aussage ist lane-abhaengig, nicht absolut.
- **Begruendung:** L3 wird ueber den **generischen** `PERF_TYPE_HW_CACHE`-Pfad geoeffnet (`:201`, `:213`), nicht ueber RAW-Events. Die Ursache ist ENOENT auf Zen 5, nicht "Zen-5-RAW-Events".
- **Energie:** die Ursache ist DAC, nicht PMU -- `/sys/class/powercap/intel-rapl:0/energy_uj` ist `0400 root:root`, *"`CAP_PERFMON` hilft dort nicht"* (`wf_49b32e04-eb8__004`, eigene Messung).

**Fehlerklasse:** *Eine Zahl, die aus einem Bericht in ein Dokument wanderte, ohne je nachgemessen zu werden* -- und C-4 verlangt, sie in die **Thesis-Limitierung zu schreiben**. Wuerde C-4 wie formuliert ausgefuehrt, entstuende eine falsche Hardware-Aussage in der Abgabe. **Hoechste Dringlichkeit unter allen Befunden dieses Nachtrags.**
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 115
GEGENSTAND: ROH: B-4 `branch_misses`: drei Kommentare am selben HEAD, zwei behaupten das Gegenteil des dritten `[ ] OFFEN`
ORT: libs/cache_engine/builder/linux_perf_pmc_source.hpp:16 | libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:499 | pmc_source.hpp | 90bca126 | a89e6be5a24b83d4d
SOLL/FIX: ### B-4 `branch_misses`: drei Kommentare am selben HEAD, zwei behaupten das Gegenteil des dritten `[ ] OFFEN`

Am Objekt, HEAD `90bca126`:
- `libs/cache_engine/builder/linux_perf_pmc_source.hpp:16` -- *"branch_misses wird von **KEINER** PMC-Quelle befuellt (offener Posten M-3a). Diese honest-0-Spalten sind im Anhang als solche zu fuehren, **nicht als gemessen**."*
- `libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:499` -- *"(C1) pmc_branch_misses ...: **PmcCounters ERHEBT branch_misses real** (pmc_source.hpp)"*
- ebenda `:774` -- *"(C1) pmc_branch_misses: **real erhoben (PmcCounters)**, bisher nur nicht emittiert."*

Die CSV-Spalte steht seit 04.08. im Header, begruendet mit `:499`. Gegenprobe: `/usr/bin/grep -rn "branch_misses" libs apps` = **14 Treffer**, davon **genau eine Zuweisung** (`measurement_snapshot.hpp:145`, Kopie aus `PmcCounters`) -- keine PMC-Quelle schreibt das Feld je. `wf_d5d5761c-1aa * a89e6be5a24b83d4d` woertlich: *"**Praemisse am Objekt falsch; der absichernde Test setzt den Wert selbst.**"*

**Fehlerklasse:** Kapitel IV, "zwei Quellen fuer dieselbe Wahrheit" -- hier in **derselben Codebasis, am selben Tag**. Die Heilung hat einen Kommentar ehrlich gemacht und zwei stehengelassen.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 116
GEGENSTAND: ROH: B-5 Das committete Erstbeleg-CSV traegt `pmc_available=1` neben drei Null-Spalten `[ ] OFFEN`
ORT: super/measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv | 20260726 | 057ee3e5
SOLL/FIX: ### B-5 Das committete Erstbeleg-CSV traegt `pmc_available=1` neben drei Null-Spalten `[ ] OFFEN`

`super/measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv` (Commit `057ee3e5`, *"D-03 Erstbeleg ... 16 echte Mess-Zeilen"*), selbst ausgelesen, Separator `;`, alle **16** Datenzeilen:

| Spalte | Wert |
|---|---|
| `pmc_available` | **1** (16x) |
| `pmc_cache_misses_l1` / `pmc_dtlb_misses` | reale, verschiedene Werte |
| `pmc_cache_misses_l2` / `pmc_cache_misses_l3` / `pmc_energy_micro_joules` | **0** (16x) |

Das ist die Datei, die der Anhang auswerten wuerde. `pmc_available=1` neben drei Nullen liest sich als **gemessene Null**; drei davon sind ENOENT/DAC. Der Lead-Posten 14 stimmt und ist **staerker als notiert**: es sind drei Spalten, nicht eine, und die Zeile behauptet aktiv Verfuegbarkeit.

Zusatz aus `wf_05819268-e3f__005`: dieses CSV ist laut Commit `057ee3e5` **handgefahren** -- *"kein Beleg fuer die Kette"*.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 117
GEGENSTAND: ROH: B-6 `pmc_seam_ok` bleibt bei `available=1` blind -- und das Messfenster ist immer noch leer `[ ] OFFEN`
ORT: m3v2_pmc_smoke.cpp:71 | ab077c917752b767e
SOLL/FIX: ### B-6 `pmc_seam_ok` bleibt bei `available=1` blind -- und das Messfenster ist immer noch leer `[ ] OFFEN`

Das Dossier zitiert SW-3/Wache-2 als `m3v2_pmc_smoke.cpp:71`, `pmc_seam_ok = delta.available || counters_all_zero`. **Heute steht dort `:87`:**
```cpp
bool const pmc_seam_ok = delta.available || (!kPmcExpected && counters_all_zero);
```
M-2/B3 hat die **zweite** Haelfte fail-closed gedreht. **Die erste Haelfte steht unveraendert** -- bei `available=1` ist die Naht OK, gleichgueltig wie viele Spalten strukturell 0 sind. `wf_216c6dbe-b55 * ab077c917752b767e` woertlich:
> "**L3 ist geoeffnet, deklariert ?ehrlich LL' -- und ist in allen 16 realen Zeilen 0**, waehrend L1 und dTLB reale Werte liefern. Keine Wache faengt das: `pmc_seam_ok = available || all_zero` ist bei `available=1` **erfuellt**, egal wie viele Spalten strukturell 0 sind."

**Und das Fenster ist nach wie vor leer** (`:40-41`, am Objekt):
```cpp
pmc->begin();
PmcCounters const delta = pmc->end();
```
Der Kommentar `:11` sagt es selbst: *"begin()->[leerer Batch]->end()"*. Lead-Posten 11 ist bestaetigt und **offen**. Das Dossier erwaehnt das leere Fenster an **keiner Stelle** (`grep` ueber die 1590 Zeilen: 0 Treffer auf `leere.*Fenster|zwischen begin|nichts zwischen`).

**Fehlerklasse:** Kapitel III, Merkmal 4 -- die Heilung hat die eine Haelfte der Disjunktion geschlossen und die produktiv relevante offen gelassen.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 118
GEGENSTAND: ROH: B-7 Der Bare-Metal-Kanal (par.61 Dual-Weg) traegt die PMC-Pflicht ueberhaupt nicht `[ ] OFFEN`
ORT: experiment_plan_director.hpp
SOLL/FIX: ### B-7 Der Bare-Metal-Kanal (par.61 Dual-Weg) traegt die PMC-Pflicht **ueberhaupt nicht** `[ ] OFFEN`

`wf_7daeeecc-a83__005`, Verdikt woertlich: *"die Emissionsmenge ist fuer den CI-Kanal vollstaendig (6/6 am Objekt bestaetigt), aber der **Bare-Metal-Kanal (par.61 Dual-Weg) ist ueberhaupt nicht abgedeckt**."*

Am Objekt bestaetigt: `experiment_plan_director.hpp` traegt **6** `IPlanBuilder`-Klassen (`:305 :396 :439 :778 :1041 :1593`). Alle **4** geflaggten `cmake -B build`-Emissionen (`:874 :912 :1233 :1386`, je `+ ceb_pmc_compile_define()`) liegen in `CiYamlBuilder`/`TierCiYamlBuilder`. `CMakeGraphBuilder` (`:439`) und `TierCmakeGraphBuilder` (`:1593`) emittieren **0** `cmake -B build`-Zeilen; der Treiber wird ueber `COMDARE_PLAN_DRIVER` von aussen hereingereicht (*"Default: PATH-Suche"*). Ein ohne Flag gebauter Treiber wird dort **stumm** akzeptiert.

**Fehlerklasse:** *Eine Heilung, die den Anlassfall behebt, aber die Fehlerklasse offen laesst* -- die Pflicht haengt jetzt an den zwei **YAML-Emittern** statt an einer Invariante. Dieselbe Wurzel wie SW-2/A-1, eine Generation spaeter.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 119
GEGENSTAND: ROH: B-8 `allow_failure` am Mess-Batch ist eine Regression gegen einen erreichten Zustand und eine Owner-Direktive `[ ] OFFEN`
ORT: experiment_plan_director.hpp | .gitlab-ci.yml:169 | .gitlab-ci.yml:1344 | b5e64a51
SOLL/FIX: ### B-8 `allow_failure` am Mess-Batch ist eine **Regression gegen einen erreichten Zustand und eine Owner-Direktive** `[ ] OFFEN`

Das Dossier fuehrt A-3 als offenen Befund. `wf_d023e824-238__002` liefert die fehlende Einordnung, am Objekt nachgeprueft:
- **Ledger:692** (06.07.): *"damit **0 allow_failure im GESAMTEN Matrix-System** (einzige Ausnahme by design: ce `is_original:relock`, manual Utility)"*
- **Ledger:2040** (17.07., Owner): *"die gesamte pipeline IMMER hart gruen sein muss -- JEDER Job ... kein roter Job, **kein allow_failure-Freibrief**"*
- **Ledger:686** (06.07.): *"Pipeline-?success' mit allow_failure **LUeGT**"*
- `git log -S'allow_failure: true' -- experiment_plan_director.hpp` -> eingefuehrt in **`b5e64a51`, 19.07.2026** -- **zwei Tage nach der Verschaerfung.**

Zusaetzlich haelt die Vollstaendigkeitsaussage "0 allow_failure, eine Ausnahme" heute nicht mehr: ce `.gitlab-ci.yml:169` (`build:arm64-smoke`) und `:521` (`is_original:relock`) -- **zwei**; super `.gitlab-ci.yml:1344` (`ergebnis:holen`, der Job, der die Mess-CSVs einsammelt) -- **drei**.

**Fehlerklasse:** SW-2-Rueckfall ("ein manueller Fix haelt hier nachweislich nicht"), plus R-3 (Vollstaendigkeitsaussage mit zu kleinem Suchraum).
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 120
GEGENSTAND: ROH: B-9 Die super-ASCII-Wache ist gelandet -- mit zwei vor der Landung gemeldeten, ungeheilten Luecken `[ ] OFFEN`
ORT: super/scripts/ci_diff_ascii_width_guard.sh | Code/tests/unit/probe_alpha.cpp | scripts/ci_diff_ascii_width_guard.sh | 7780c6af
SOLL/FIX: ### B-9 Die super-ASCII-Wache ist **gelandet -- mit zwei vor der Landung gemeldeten, ungeheilten Luecken** `[ ] OFFEN`

Das Dossier sagt an drei Stellen (R-1, R-7, D-3): *"der super hat keine Kopie dieser Wache"*. **Ueberholt:** `7780c6af` ("feat(ci): super-eigene ASCII-/Breiten-Wache + Einhaengung als lint:diff-hygiene") ist Vorfahr von `origin/development`; `super/scripts/ci_diff_ascii_width_guard.sh` existiert, Job `lint:diff-hygiene` bei `:254`.

`wf_499d83cf-183__002` hat sie adversarial geprueft -- 6/6 Auftragspunkte halten -- und **drei unbeauftragte Befunde** gemeldet. Zwei davon sind am Objekt heute noch da:

**Luecke A -- der Arbeitsbaum-Modus liefert die nackte gruene Null, die der Kopf ausschliesst.** Verbatim aus dem Bericht:
```
$ git status --short  ->  ?? Code/tests/unit/probe_alpha.cpp   (Umlaut + 133-Byte-Zeile)
$ sh scripts/ci_diff_ascii_width_guard.sh
  0 Zeilen in super-eigenem Code geprueft, davon 0 Nicht-ASCII ...
  DIFF-HYGIENE-WACHE: GRUEN.       EXIT=0
```
Ursache: `:253` faehrt `git diff -U0 HEAD`, das Untracked nie zeigt. Gegenprobe im Skript: `grep -n "others\|exclude-standard\|untracked"` -> **0 Treffer**. Der Bericht: *"genau der Lauf, den ein Agent vor der Paketmeldung macht, und genau der Fall (brandneue Datei), in dem ein Paket typischerweise steht."*

**Luecke B -- 897 Fremdcode-Dateien im Scope, Nenner nennt sie "super-eigenen Code".** `is_scoped()` (`:363-377`) ist eine reine Endungs-Pruefung, **ohne jede Pfad-Ausnahme**. Selbst nachgezaehlt: `git ls-files | grep -E '\.(cpp|hpp|...)$' | grep -cE '^(Code/external/|Forschungsarbeiten/)'` = **897**. `:538` druckt trotzdem *"... Zeilen in super-eigenem Code geprueft"*. Der naechste faithful-Vendor-Import faehrt `lint:diff-hygiene` (kein `allow_failure`) rot -- gegen Code, den die Vendoring-Doktrin unveraendert lassen will. Entlastung heute nur durch `GIT_SUBMODULE_STRATEGY: none`, also *"Zufall der Job-Konfiguration, nicht Absicht der Scope-Funktion."*

**Fehlerklasse:** die Wache aus R-1 reproduziert im Handbetrieb **genau die Klasse, gegen die sie gebaut wurde** -- und der Befund lag vor der Landung vor. **Zusatz-Klasse: ein Review-Befund, der gemeldet wurde und trotzdem mitgelandet ist.** (`git log -- scripts/ci_diff_ascii_width_guard.sh` = genau ein Commit, kein Nachbesserungs-Commit.)
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 121
GEGENSTAND: ROH: B-10 Die R-8-Richtungswache deckt den heute live stehenden Fall nicht `[ ] OFFEN`
ORT: b-m2-pmc-invariante | b-ci-rueckschrieb-beide-zeiger | b241a272 | 90bca126
SOLL/FIX: ### B-10 Die R-8-Richtungswache deckt den **heute live stehenden** Fall nicht `[ ] OFFEN`

Das Dossier schlaegt in R-8/Z-3 einen `pre-commit`-Hook vor, der *"fuer jeden veraenderten Gitlink die Richtung misst und bei Rueckwaerts-Bewegung abbricht."* Am Objekt, jetzt:

```
committeter Gitlink : b241a272   (== ce origin/main)
Checkout            : 90bca126   auf Branch b-m2-pmc-invariante
merge-base --is-ancestor b241a272 90bca126  ->  wahr   => R-8-Wache: GRUEN
merge-base --is-ancestor 90bca126 2b5ecd29  ->  falsch => nicht auf origin/development
git ls-remote origin | grep -c 90bca126     ->  0      => auf KEINEM Remote-Ref
```

**"Vorwaerts" ist keine Aussage ueber den ZWEIG.** Die vorgeschlagene Wache winkt einen Gitlink auf einen Commit durch, der nirgends erreichbar ist -- das ist R-9 (rescue-Ref ist keine Landung), und die R-8-Wache kann es per Konstruktion nicht sehen. Beide Hauptklone stehen gerade so: super auf `b-ci-rueckschrieb-beide-zeiger` (`18a0bdf3`, ebenfalls auf keinem Remote), das ce-Submodul auf `b-m2-pmc-invariante`. **Das ist die Vorbedingung von Lead-Posten 16, live in beiden Repos gleichzeitig.**

**Naechste Handlung:** die Wache muss `merge-base --is-ancestor <zeiger> origin/development` pruefen, nicht `<alt> <neu>`.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 122
GEGENSTAND: ROH: B-11 Z-5/S-4 hat sich seit dem Dossier um 170 % verschlechtert -- und enthaelt echte Messdaten `[ ] OFFEN`
ORT: measurements.csv | result.csv
SOLL/FIX: ### B-11 Z-5/S-4 hat sich seit dem Dossier **um 170 % verschlechtert** -- und enthaelt echte Messdaten `[ ] OFFEN`

Live gemessen (`git status --porcelain`, super):

| | Dossier (Abfassung) | jetzt |
|---|---:|---:|
| untracked Dokumente | 3 | **6** |
| Zeilen | 2042 | **5520** |

Dazu `?? Code/measure_out_d03/` -- das Dossier fuehrt es als Fussnote ohne Zahl. Selbst gemessen: **66 Dateien, 3,7 MB**, vom 26.07.2026, darunter `measurements.csv` (16 Zeilen), je Permutation `result.csv`, `result.csv.stamp`, `perm.cpp`, `perm.dll`, **8 `perm.dll.rsp`**. `git check-ignore` -> **kein Treffer**. `wf_216c6dbe-b55__002`, 3.2:
> "Memory-Doktrin `feedback_messdaten_nie_loeschen_abi_darf_brechen` + `feedback_raw_data_backups_additive_never_delete` greifen direkt. Zusaetzlich: die `.rsp`-Dateien sind genau das Artefakt, das die REGISTER-P0-Ergaenzung als Pflichtteil von TP1+4+1 verlangt (?E2E-.rsp-Beweis (Defines literal im realen Tier-Bau)', REGISTER:294)."

**Fehlerklasse:** Z-5 -- aber die Kosten sind hoeher als dort veranschlagt. Ein `git clean -fdx` vernichtet nicht nur Planungsarbeit, sondern **Rohmessdaten unter einer Nie-loeschen-Doktrin und den geforderten Pflichtbeleg**.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 123
GEGENSTAND: ROH: B-12 Eine Regel, die nach ihrem eigenen Wortlaut abgelaufen ist, wird als geltend zitiert `[ ] OFFEN`
ORT: super/docs/architektur/22_CI_INTERAKTIVE_DIPLOMARBEIT_ANHANG_AUTOMATION.md:97
SOLL/FIX: ### B-12 Eine Regel, die nach ihrem eigenen Wortlaut abgelaufen ist, wird als geltend zitiert `[ ] OFFEN`

`super/docs/architektur/22_CI_INTERAKTIVE_DIPLOMARBEIT_ANHANG_AUTOMATION.md:97` (am Objekt):
> `| -- | pmc_cache_misses-Darstellungen | -- | **NICHT bauen** (honest-empty bis #26) |`

`wf_d023e824-238__002`, A4: ein Explore hat die Zeile ohne **"bis #26"** zitiert und als geltende Regel gefuehrt; **#26 ist am 12.07. vollzogen** (Ledger:570). **Fehlerklasse:** *Eine Entlastung, die auf einer ungeprueften Praemisse steht* -- hier durch ein abgeschnittenes Zitat, das die Verfallsbedingung wegschneidet. Verwandt mit SW-2 ("Zusicherung im Kommentar verfaellt lautlos"), aber die Umkehrung: **eine abgelaufene Sperre wirkt weiter.**
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 124
GEGENSTAND: ROH: B-13 Jeder neue ce-Test verschiebt den Nenner der Abdeckungswache `[ ] OFFEN`
ORT: a2c3691b77804d30a
SOLL/FIX: ### B-13 Jeder neue ce-Test verschiebt den Nenner der Abdeckungswache `[ ] OFFEN`
`wf_216c6dbe-b55 * a2c3691b77804d30a`: *"`test:coverage-guard` -> jeder neue ce-Test verschiebt den Nenner (heute 407) ... **Zwei gleichzeitige Registrierungen machen ein Rot unzurechenbar.**"* Betriebs-Auflage: Pakete, die Tests registrieren, duerfen nicht parallel laufen. Steht im Dossier nirgends.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 125
GEGENSTAND: ROH: B-14 Der lokale `ci-templates`-Checkout ist veraltet -- N-4 auf die CI-Templates `[ ] OFFEN`
ORT: /home/comdare/Projekte/Cluster/_infra/ci-templates/base-pipeline.yml | experiment_plan_director.hpp | m3v2_pmc_smoke.cpp:71 | 2b5ecd29 | b241a272
SOLL/FIX: ### B-14 Der lokale `ci-templates`-Checkout ist veraltet -- N-4 auf die CI-Templates `[ ] OFFEN`
`wf_49b32e04-eb8__001`: *"**Warnung: der lokale read-only-Checkout `/home/comdare/Projekte/Cluster/_infra/ci-templates/base-pipeline.yml` ist VERALTET** -- 846 Zeilen lokal vs. 1142 Zeilen authoritativ."* Selbst nachgezaehlt: **846**. Wer `include:`-Verhalten aus dem lokalen Checkout beantwortet, misst am falschen Gegenstand -- dieselbe Klasse wie N-3/N-4, aber auf einem Pfad, den das Dossier nicht kennt.

---

# C. Dossier-Eintraege, die durch die Journale/das Objekt ueberholt oder zu korrigieren sind

| Dossier | Ist heute | Beleg |
|---|---|---|
| SW-3/A-1: *"`COMDARE_ENABLE_PMC` kommt in `experiment_plan_director.hpp` 0-mal vor"* | **5-mal** auf `origin/development` (`2b5ecd29`) * **0-mal** auf `origin/main` (`b241a272`) | `git show <ref>:... \| grep -c` |
| SW-3/Wache-2: `m3v2_pmc_smoke.cpp:71` | steht bei **`:87`**, Formel geaendert (s. B-6) | am Objekt |
| SW-1 `[x] ERLEDIGT` | korrekt waere `[~]` -- Biss unbewiesen (B-2) | 0 Tests |
| R-1/R-7/D-3: *"super hat keine Kopie der Wache"* | **ueberholt**, `7780c6af` gelandet -- mit 2 offenen Luecken (B-9) | `git ls-files` |
| Z-1/D-1 *"keine Wache prueft zwei Gitlinks gegeneinander"* | **geheilt**: `18a0bdf3` + `ci/thesis_gitlink_parity.sh`, verdrahtet in `verify:submodules` (`.gitlab-ci.yml:382-383`); beide Zeiger auf `main` und `development` in Paritaet | am Objekt |
| Lead-Posten 12/13 | ebenda geheilt; der Commit benennt es selbst: *"Der Rueckschrieb-Job anhang:forward bumpte nur den ersten Zeiger ... die CI **ERZEUGT** die Divergenz bei jedem Rueckschrieb selbst"* | `git show 18a0bdf3` |
| S-2/S-3 "ce main 2 zurueck / super main 10 zurueck" | **ce main 8 zurueck * super main 9 zurueck** -- die Klasse ist gewachsen, nicht geschlossen; die PMC-Heilung ist auf `main` **nicht** vorhanden, und die drei Bridges triggern fest `branch: main` | `ls-remote` + `rev-list --count` |
| A-2/C-4 `[BERICHT]` "nur L1D+dTLB ... Zen-5-RAW-Events" | **in Umfang und Begruendung widerlegt** (B-3) | strace/Sonde/CI-Traces |
| SW-3 `[BERICHT]` "ohne Flag SMOKE_SKIP ..., mit Flag `cache_misses_l1=4191307`" | war **selbst gemessen**, nicht Bericht (`wf_05819268-e3f__005`: *"eigene Nachmessung auf der Maschine"*) | Journal |

---

# D. Was ich NICHT belegen konnte

1. **Lead-Posten 15 ("die 390 Runner-Token sind NICHT rotiert, Mengentest gegen 286/288/289").** In **keinem** der 206 Berichte steht eine Rotations-Verifikation. `wf_22b0822f-81d__010` sagt es explizit: *"In den 121 Berichten steht **keine** Messung, kein API-Abruf, kein Vergleich alter gegen aktueller Token-Werte. Wer ?nicht rotiert' behaupten will, hat aus diesem Bestand nur den Umkehrschluss ?es ist nicht belegt, dass rotiert wurde'. Das ist nicht dasselbe."* Ferner ist **390 die falsche Bezugsgroesse**: selbst nachgezaehlt in `docs/sessions/backups/20260802-e23-suchlauf-belege/e23/` -- `group_projects.ndjson` **386**, `projects_all.ndjson` **390**, zusammen **776** `runners_token`-Vorkommen. "390" ist die Zahl **einer** Datei (und zugleich der E-23-Projekt-Anker). Im Arbeitsbaum stehen **0** literale `GR1348941...`-Werte (Scrub wirksam); die Werte liegen ausschliesslich auf `refs/backup/pre-secret-scrub-20260802` = `5ba3d03f`, **heute live per `ls-remote` bestaetigt**. -> Der Posten gehoert als **`[?] UNBELEGT`** ins Heft, nicht als Befund.
2. **`MANUAL_RUN.md` traegt das Flag an 0 von 7 cmake-Zeilen** (`wf_05819268-e3f__005`). Am Objekt: `Code/MANUAL_RUN.md` enthaelt `COMDARE_ENABLE_PMC` **3-mal**. Die Aussage traegt heute nicht; nicht uebernehmen.
3. **Ursache von `t_running == 0` auf prod2.** Der Agent sagt es selbst: *"Die zwei moeglichen `ok=false`-Zweige ... sind aus dem Trace nicht unterscheidbar. **Ich rate nicht.**"* Bleibt offen.
4. **Lead-Posten 7 (A-7/A-8 als Bau-Paket vergeben, obwohl erledigt).** Ich habe in den Journalen keinen Bericht gefunden, der das benennt; die Commits `c1c76c87`/`0b5ed557` existieren, aber die Fehl-Vergabe selbst steht in keinem `result`-Ereignis. Nicht aus dieser Quelle belegbar.
5. **Lead-Posten 8 ("Zustands-Leiter neu erarbeitet, `axis_error.hpp` existiert seit Wochen").** In den Journalen nicht auffindbar; am Objekt habe ich es nicht gegengeprueft (ausserhalb meines Sammel-Auftrags).

---

# E. Vorschlag fuer zwei neue Regeln
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 126
GEGENSTAND: ROH: R-11 -- Keine Ursache ohne Messung. Eine Fehler-/Diagnoseausgabe darf keine Ursache nennen, die sie nicht gemessen hat. Anlassfall A-1: `[PMC-FEHLER] ... Ursache
ORT: linux_perf_pmc_source.hpp:112
SOLL/FIX: **R-11 -- Keine Ursache ohne Messung.** Eine Fehler-/Diagnoseausgabe darf keine Ursache **nennen**, die sie nicht **gemessen** hat. Anlassfall A-1: `[PMC-FEHLER] ... Ursache pruefen: perf_event_paranoid, CAP_PERFMON, Container ohne perf` -- drei Fehldiagnosen, ein beinahe ausgefuehrter Cluster-Eingriff, waehrend `errno` an der Quelle (`linux_perf_pmc_source.hpp:112`) ersatzlos verworfen wird. Spiegel von R-1: *dort* fehlte der Nenner einer Null, *hier* fehlt die Messung einer Behauptung.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 127
GEGENSTAND: ROH: R-12 -- Eine Wache darf nicht im Gegenstand ihrer eigenen Fehlerklasse wohnen. Anlassfall B-1: die Schluessel-Wache gegen "YAML verschluckt einen Job stumm" ist der ers
ORT: unbekannt
SOLL/FIX: **R-12 -- Eine Wache darf nicht im Gegenstand ihrer eigenen Fehlerklasse wohnen.** Anlassfall B-1: die Schluessel-Wache gegen "YAML verschluckt einen Job stumm" ist der erste Schritt **eines Jobs**, den YAML stumm verschlucken kann. Prueffrage bei jeder neuen Wache: *Kann der Mechanismus, gegen den sie gebaut ist, sie selbst treffen?* Zweiter Vertreter: B-2 -- eine Wache, deren Sollwert im selben Commit mit dem Istwert erzeugt wurde, ist gruen per Konstruktion und hat nie die Gelegenheit gehabt zu beissen.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 128
GEGENSTAND: ROH-SAMMLER[2] Kopf/Erhebungsbasis
ORT: unbekannt
SOLL/FIX: ## SAMMEL-ERGEBNIS `git-und-ledger` -- 14 Funde, alle am Objekt geprueft

Messmethode durchgaengig `/usr/bin/grep` (absolut), Ancestry mit `git merge-base --is-ancestor`, Remote-Fragen mit `ls-remote`/`ls-tree`. Repos: super `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`, ce `.../Code/external/comdare-cache-engine`, thesis `.../thesis/diplomarbeit`.

---
STATUS LT. QUELLE: nur-hinweis (Erhebungsbasis des Sammlers)
ABHAENGIGKEIT/FLAECHE: -

### [w3azi1rhl.json] 129
GEGENSTAND: ROH: A. ZWEI HARTE FEHLER IM DOSSIER SELBST (beide gegen den Stand, den das Dossier als seinen eigenen Messstand nennt)
ORT: 8e58f691
SOLL/FIX: ### A. ZWEI HARTE FEHLER **IM DOSSIER SELBST** (beide gegen den Stand, den das Dossier als seinen eigenen Messstand nennt)

Das Dossier gibt in 0.3 als Thesis-Submodul-Stand `8e58f691` an. Gegen genau diesen Stand gemessen:
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 130
GEGENSTAND: ROH: G-1 -- Z-8 Nebenbefund `axis_inventory.tex` "0-mal referenziert" ist FALSCH.
ORT: axis_inventory.tex | super/Code/08_appendix_generator/appendix_generator.cpp:423 | 8e58f69 | df54a2c
SOLL/FIX: **G-1 -- Z-8 Nebenbefund `axis_inventory.tex` "0-mal referenziert" ist FALSCH.**
- **Ort:** Dossier `:1155`: *"`axis_inventory.tex` wird erzeugt (`super/Code/08_appendix_generator/appendix_generator.cpp:423`), ist aber im gesamten Thesis-Baum **0-mal** referenziert."*
- **Gegenbeleg (`git grep` gegen den Baum `8e58f69` selbst):** 2 Treffer -- `anhang/de/D_building_block_matrix.tex:1442` und `anhang/en/...:1442`, je `\InputIfFileExists{anhang/de/tabellen/axis_inventory.tex}{}{% \emph{(Das Achsen-Inventar erscheint nach dem naechsten Lauf des Anhang-Generators.)}}`. Eingebunden durch thesis `df54a2c` (19:34, *"feat(anhang D): das generierte Achsen-Inventar einbinden (DE+EN)"*), **Vorfahr von `8e58f69`** (geprueft).
- **Folge:** Handlungspunkt C-1(c) *"`axis_inventory` einbinden oder abschalten"* war beim Schreiben bereits erledigt.
- **Fehlerklasse:** **REGEL-ZEILE 17** (Befund traegt Erhebungsdatum), Ledger `38381ac8` -- hier auf das Checkheft selbst angewandt. Keine neue Regel noetig.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 131
GEGENSTAND: ROH: G-2 -- C-2 "7 sind unmarkiert" ist FALSCH; es sind 0.
ORT: 06_evaluation_methodology.tex | kapitel/de/05_evaluation.tex | 8e58f69 | bdd1e16
SOLL/FIX: **G-2 -- C-2 "7 sind unmarkiert" ist FALSCH; es sind 0.**
- **Ort:** Dossier `:1334`: *"8 sind nicht eingebunden; von diesen traegt genau eine (`06_evaluation_methodology.tex`) einen Vermerk -- **7 sind unmarkiert**."*
- **Gegenbeleg (je Datei aufgeschlagen, Baum `8e58f69`):** `kapitel/de/` = 14 `.tex`, 6 eingebunden, **8 nicht eingebunden -- und alle 8 tragen den Vermerk** (`01_introduction`, `02_fundamentals`, `03_state_of_the_art`, `04_concept_architecture`, `05_implementation`, `06_evaluation_methodology`, `07_results_evaluation`, `08_conclusion`). Geheilt durch thesis `bdd1e16` (19:34, *"docs(kapitel): die sieben unmarkierten Alt-Kapitel als NICHT eingebunden kennzeichnen (DE+EN)"*), **Vorfahr von `8e58f69`**.
- **Fehlerklasse:** wie G-1.

**Gleiche Klasse, dritter Fall (schwaecher, deshalb nur als Hinweis):** C-4 (`:1350`) verlangt *"Limitierung praezisieren"*; thesis `a6c7598` (19:39, ebenfalls Vorfahr von `8e58f69`) hat genau das getan -- `kapitel/de/05_evaluation.tex` traegt seither den Absatz *"Davon zu trennen ist, welche Zaehler dieser Zugang in der vorliegenden Fassung tatsaechlich fuellt: ... Branch-Misses, IPC/CPI und die Energie-Aufnahme sind nicht verdrahtet. Die zugehoerigen Spalten tragen deshalb keine gemessene Null."* Der zitierte Satz steht noch, aber der Vorwurf *"ohne zu differenzieren"* traegt nicht mehr. **Rest-Substanz bleibt:** der Text nennt **drei** geoeffnete Zaehler (L1D, Last-Level, dTLB), waehrend `cache_misses_l3_ll` auf AMD `errno=2` liefert (Owner-Posten 14) -- das ist der Teil von C-4, der offen bleibt.

---
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 132
GEGENSTAND: ROH: B. DIE STAERKSTE INDIREKTE REGRESSION DES TAGES: eine Migration, die 11 neue False-Green-Pfade einbaute
ORT: unbekannt
SOLL/FIX: ### B. DIE STAERKSTE INDIREKTE REGRESSION DES TAGES: eine Migration, die 11 neue False-Green-Pfade einbaute
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 133
GEGENSTAND: ROH: G-3 -- Die xmllint-Migration hat ihre eigene Fehlerklasse eine Ebene weiter reproduziert.
ORT: 2c631551 | 1ba29b63
SOLL/FIX: **G-3 -- Die xmllint-Migration hat ihre eigene Fehlerklasse eine Ebene weiter reproduziert.**
- **Ort/SHA:** super `2c631551` (15:58), *"fix(wachen): die SECHS FALSE-GREEN-PFADE der xmllint-Migration selbst geschlossen (B14-NB4, B1-B11)"*. Vorlaeufer: `1ba29b63` (13:00, Migration), Ledger nachmittag-2 (`:5979`). Vorfahr von `origin/development` (geprueft).
- **Beleg, verbatim aus der Commit-Nachricht:**
  > "EINORDNUNG (der Grund, warum es diese Welle gibt): die sechs URSPRUENGLICHEN Codex-Befunde gelten als strukturell geheilt -- der Wegfall des Selbstbau-Parsers hat sie erledigt. **Die Befunde hier sind LUECKEN DER MIGRATION SELBST. Das ist Fehlerklasse 1 der Pruefliste: der geheilte Defekt steckt eine Ebene weiter.**"
- **Elf benannte Pfade, jeder mit Biss.** Auswahl mit Objekt-Gegenprobe:
  - **B11:** die Flag-Verriegelung prueefte nur "roh scheitert" + "kommentarfrei laeuft", nie **ob** der rohe Fehler der Doppelbindestrich ist. Heute am Objekt: `Code/tests/xml_canonical_utils.cmake:419-420` -- `if(NOT _err MATCHES "Double hyphen within comment")`.
  - **B7 (vom Autor selbst als "der ehrlichste" bezeichnet):** die Wache prueefte "Produkt == beide caps", **behauptete** aber fest *"golden N = 2^17"*. Heute: `-DEXPECTED_N=131072` in `Code/tests/CMakeLists.txt:221`, und `golden_n_consistency_check.cmake:482` faellt FATAL, wenn das Argument fehlt.
  - **B4:** `SKIP_REGULAR_EXPRESSION "FIXTURE-SYNC-SKIP"` war unverankert und galt fuer alle fuenf Tests -- *"jeder FATAL, dessen Text die Zeichenfolge mitfuehrt, waere SKIP statt FAIL gewesen, und die Wachen echoen Dateiinhalte in ihre FATAL-Meldungen"*. Heute im Kommentar `Code/tests/CMakeLists.txt:224` dokumentiert.
  - **B8:** Nachbar-Skip lief **vor** der Werkzeug-Pruefung -- *"PATH ohne xmllint + fehlende Submoduldatei -- ALT RC=0 SKIP trotz 'xmllint ist PFLICHT, sein Fehlen ist FATAL'"*.
- **Status:** geheilt und gelandet.
- **Fehlerklasse:** passt zu **keiner** der zehn Regeln sauber. R-6 ("ein gruenes Gate deckt nur seinen eigenen Gegenstand") trifft die Wirkung, nicht die Ursache. **Vorschlag neue Regel: "Eine Migration erbt die Fehlerklasse, die sie beseitigt."** Wer einen Selbstbau-Parser durch ein Werkzeug ersetzt, muss jede Aufrufstelle des Werkzeugs einzeln gegen dieselbe Klasse bissen -- sonst wandert die stille Null vom Parser in den Aufruf.

---
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 134
GEGENSTAND: ROH: C. EINE FEHLERKLASSE, DIE HEUTE FUENFMAL AUFTRAT UND IM DOSSIER KEINE REGEL HAT
ORT: unbekannt
SOLL/FIX: ### C. EINE FEHLERKLASSE, DIE HEUTE **FUENFMAL** AUFTRAT UND IM DOSSIER KEINE REGEL HAT
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 135
GEGENSTAND: ROH: G-4 -- Fingerprint-Injektivitaet: zwei verschieden gebaute Binaries, ein Stempel, stiller Falsch-Skip.
ORT: ce/libs/cache_engine/builder/ceb_version_stamp.hpp:3-4 | ce/libs/cache_engine/profile_facade/profile_run_facade.cpp:274 | 71b5586a | dbdd2f9b | bbd72c2a
SOLL/FIX: **G-4 -- Fingerprint-Injektivitaet: zwei verschieden gebaute Binaries, ein Stempel, stiller Falsch-Skip.**

| # | Fall | Ort / SHA | Belegzitat | Status |
|---|---|---|---|---|
| 1 | Kollisions-Eimer `ohne-anker` | ce `71b5586a` | Dossier H-4 | geheilt, **im Dossier** |
| 2 | Preimage-Glied [5] nicht per-Perm | ce `dbdd2f9b` (09:09) | *"Live-Glied[5] nur cxx/ceb/bt -> **O2/O3 derselben Zelle identischer Fingerprint = falscher Skip**"* | geheilt, **fehlt** |
| 3 | Tier-Realversion geerbt statt erhoben | ce `bbd72c2a` (09:17) | *"g++-16-Binary 16.1->16.3 = identischer Stempel = falscher Skip"* ... *"zwei Baue mit g++-16 = 16.0.1 und g++-16 = 16.3.0 trugen weiter DASSELBE Glied"* | geheilt, **fehlt** |
| 4 | `kCebFingerprint` rendert das ANGEBOT statt der WAHL | Ledger abend-3 par.C, D-4 (`:4238`) | *"Zwei CEBs mit `[wallclock]` und `[macro]` tragen **denselben** `ceb_key_sha512` -- Injektivitaets-Verletzung, bricht Owner-KERN F6 auf CEB-Ebene"* | **OFFEN**, **fehlt** |
| 5 | `COMDARE_MEASUREMENT_ON` ist ABI-wirksam, steht nicht im Preimage | Ledger abend-3 par.C (`:4241`) | *"Eine Release-Nachmessung erzeugt also eine **andere Binary mit identischem Fingerprint**; `dll_is_current` ist genau ein Vergleich -> **stiller Falsch-Skip**."* | **OFFEN**, **fehlt** |

- **Objekt-Gegenprobe zu #4:** `ce/libs/cache_engine/builder/ceb_version_stamp.hpp:3-4` sagt es selbst: *"Ihre Provenienz ist ihr Mess-ANGEBOT: das Mess-Array [...] je Tooling aus `kMeasurementToolingRegistry`"* -- das Angebot, nicht die Wahl.
- **Objekt-Gegenprobe zu #5:** `ce/libs/cache_engine/profile_facade/profile_run_facade.cpp:274` setzt `-DCOMDARE_MEASUREMENT_ON=1` **hart** in `perm_mess_defines()`.
- **Heilung liegt vor, ist aber NICHT gelandet:** ce `b9fd81ff` / `62a5b6f7` / `246b2793` (M-1 d-1/d-2/d-4, 21:40-22:27) sind **kein** Vorfahr von `ce origin/development` (geprueft).
- **Fehlerklasse:** braucht eine **eigene Regel**. Vorschlag: **"Ein Identitaets-Stempel ist nur so gut wie die Menge der Eingaenge, die ihn veraendern. Jede Groesse, die die Binary veraendert und nicht ins Preimage reist, ist ein programmierter Falsch-Skip."** Alle fuenf Faelle sind derselbe Satz; das Dossier fuehrt nur einen davon.

---
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 136
GEGENSTAND: ROH: D. EINE NEU EINGEFUEHRTE WACHE, DIE IHREN EIGENEN BESTANDS-MODUS NICHT AUSFUEHREN KANN -- und deren Zahlen in zwei Dokumenten stehen
ORT: unbekannt
SOLL/FIX: ### D. EINE NEU EINGEFUEHRTE WACHE, DIE IHREN EIGENEN BESTANDS-MODUS NICHT AUSFUEHREN KANN -- und deren Zahlen in zwei Dokumenten stehen
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 137
GEGENSTAND: ROH: G-5 -- `super/scripts/ci_diff_ascii_width_guard.sh --bestand` bricht immer ab; die publizierten Zahlen 845/174/18714 sind nicht reproduzierbar.
ORT: super/scripts/ci_diff_ascii_width_guard.sh | scripts/ci_diff_ascii_width_guard.sh | ce/scripts/ci_diff_ascii_width_guard.sh:61 | 7780c6af | 20260931
SOLL/FIX: **G-5 -- `super/scripts/ci_diff_ascii_width_guard.sh --bestand` bricht immer ab; die publizierten Zahlen 845/174/18714 sind nicht reproduzierbar.**
- **Ort:** super `7780c6af` (21:11), Ledger abend-3 par.F (`:4258`).
- **Publizierte Zahl (Commit-Nachricht, verbatim):** *"`--bestand` meldet heute **845 Nicht-ASCII- und 174 Breiten-Zeilen aus 18714**, eine Bestands-Wache waere am Tag ihrer Einfuehrung rot geboren."* Ledger `:4258` traegt dieselbe Zahl.
- **Selbst gemessen, zweimal (ohne Pathspec und mit `Code`):**
  ```
  $ sh scripts/ci_diff_ascii_width_guard.sh --bestand   -> RC=2
  FATAL: Datei nicht lesbar: .../Code/external/20260931-overleaf-diplomarbeit
  DIFF-HYGIENE-WACHE: ABBRUCH -- awk-Verarbeitung fehlgeschlagen (rc=2)
  ```
- **Ursache, strukturell am Skript nachgelesen** (`:335` und `:409-425`): der Modus fuellt die Dateiliste mit `git ls-files` -- das liefert die **drei Gitlink-Eintraege** mit -- und der awk-Block oeffnet jeden Pfad per `getline`; ein Verzeichnis liefert `rc<0` -> `FATAL; exit`. Der Abbruch kann mit keiner Pfadangabe umgangen werden, die `Code/` enthaelt.
- **Wieviel der Lauf ueberhaupt sah:** Abbruch bei `git ls-files`-Eintrag **134 von 4759** (2,8 %); bis dahin bereits **814 NICHT-ASCII** und **156 >120-SPALTEN** gemeldet. Die publizierten 845/174 liegen unmittelbar darueber -- die Zahl beschreibt also **nicht** den Gesamtbestand, sondern hoechstens einen abgebrochenen Anfang.
- **Der Diff-Modus ist in Ordnung** (Gegenprobe, damit der Befund nicht ueberzieht): `--seit-basis` liefert RC=0, mit Nenner (*"703 Zeilen in super-eigenem Code geprueft, davon 0 Nicht-ASCII"*) und nennt die Gitlinks korrekt als uebersprungen. Nur der Bestands-Modus ist unbrauchbar.
- **Verschaerfung:** der **ce** hat den Modus gar nicht -- `ce/scripts/ci_diff_ascii_width_guard.sh:61` sagt selbst *"Sie prueft nur den DIFF-BEREICH, nicht den Gesamtbestand"*. In **keinem** der beiden Repos ist der Alt-Bestand heute messbar.
- **Status:** OFFEN (neu).
- **Fehlerklasse:** **R-1 in Reinform, gegen die Wache selbst gerichtet** -- plus die vom Owner ausdruecklich gesuchte Klasse *"eine Zahl, die aus einem Bericht in ein Dokument wanderte, ohne je nachgemessen zu werden"*.
- **Positiv zu vermerken:** die Wache scheitert **laut** (FATAL + rc=2), nicht still. Das ist der Konstruktions-Grundsatz aus R-1 korrekt angewandt -- nur hat niemand den Ausgang gelesen, bevor die Zahl in zwei Dokumente ging.

---
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 138
GEGENSTAND: ROH: E. WACHEN, DIE AUSLOESEN KOENNEN -- nachgewiesen, nicht angenommen
ORT: unbekannt
SOLL/FIX: ### E. WACHEN, DIE AUSLOESEN KOENNEN -- nachgewiesen, nicht angenommen
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 139
GEGENSTAND: ROH: G-6 -- Die neue Thesis-Gitlink-Paritaets-Wache faellt nachweislich rot (Biss-Probe selbst gefahren).
ORT: ci/thesis_gitlink_parity.sh | 3ccbc501 | 18a0bdf3 | 19e159203ac8
SOLL/FIX: **G-6 -- Die neue Thesis-Gitlink-Paritaets-Wache faellt nachweislich rot (Biss-Probe selbst gefahren).**
- **Ort/SHA:** super `3ccbc501` / `18a0bdf3` (21:32), `ci/thesis_gitlink_parity.sh`. Heilt Owner-Posten 12/13.
- **Selbst gefahren:**
  ```
  $ sh ci/thesis_gitlink_parity.sh                       -> RC=0
    Thesis-Gitlink-Paritaet OK (Quelle 'head'): beide Zeiger auf 19e159203ac8...
  $ sh ci/thesis_gitlink_parity.sh --erwartet 000...0    -> RC=1
    FEHLER (Thesis-Doppelbindung): ... erwartet war aber 000...0
  ```
- **Zusatzbeleg aus der Commit-Nachricht, den die Owner-Liste nicht nennt:** die zweite Einbindung kommt in `.gitlab-ci.yml` **null Mal** vor (*"grep -c 'Code/external/20260931' .gitlab-ci.yml -> 0"*), und die eingebundene `ci-templates/base-pipeline.yml` ebenfalls null Mal und hat selbst kein `include:` -- *"die Kette ist damit vollstaendig abgesucht"*. Die **tote zweite Einbindung bleibt bewusst stehen**: *"Ihr Entfernen waere die sauberste Loesung, ist aber eine Loeschung und braucht Owner-GO."* -> offener Owner-Posten.
- **EIGENE MESSFALLE, offen ausgewiesen:** mein erster Biss-Lauf meldete `RC=0` fuer den Fehlerfall -- weil ich `$?` **hinter einer Pipe nach `tail`** gelesen habe. Die Messung war korrekt und beantwortete die Frage *"was liefert `tail`?"*. Dieselbe Gestalt wie die These des Dossiers; die korrigierte Messung ohne Pipe liefert RC=1.

---
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 140
GEGENSTAND: ROH: F. DEFEKTE AUS COMMIT-NACHRICHTEN, DIE IM DOSSIER FEHLEN
ORT: unbekannt
SOLL/FIX: ### F. DEFEKTE AUS COMMIT-NACHRICHTEN, DIE IM DOSSIER FEHLEN
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 141
GEGENSTAND: ROH: G-7 -- "Der EINE literale Pin": eine Vollstaendigkeits-Zusage im Kopf-Kommentar, die zweimal widerlegt und zweimal stehen gelassen wurde.
ORT: libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp | 4b38d072
SOLL/FIX: **G-7 -- "Der EINE literale Pin": eine Vollstaendigkeits-Zusage im Kopf-Kommentar, die zweimal widerlegt und zweimal stehen gelassen wurde.**
- **Ort/SHA:** ce `4b38d072` (15:47), `libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp`.
- **Beleg (Commit, verbatim):** *"er sprach von 'dem EINEN literalen Pin', E-24 C8 fand einen ZWEITEN (`test_w10_c4_zellwert_naht`) und stellte ihn um, **liess den Wortlaut aber stehen. Beim naechsten Bump waren es dann VIER.**"*
- **Objekt heute (`:448`):** *"zweimal von 'dem EINEN literalen Pin'; beide Male war das falsch."* Der Header fuehrt seither die **vollstaendige Fundstellen-Liste** statt einer Anzahl-Behauptung.
- **Wer es fand:** *"GEFUNDEN HAT SIE NICHT DIESER KOPF, SONDERN DER ctest-DOPPELLAUF."* -- es gab **keine** Wache fuer diese Klasse; nur der Bump 8.0->8.1 machte sie sichtbar.
- **Status:** geheilt.
- **Fehlerklasse:** **R-3** (Vollstaendigkeitsaussage), aber mit neuem Traeger: nicht ein `grep`, sondern ein **Kommentar**. Dossier-Vorschlag: R-3 um den Satz erweitern *"Eine Zusage ueber eine Anzahl ist eine Vollstaendigkeitsaussage. Ersetze sie durch die Liste -- eine Liste altert sichtbar, eine Zahl nicht."*
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 142
GEGENSTAND: ROH: G-8 -- Der Batch-Plan wird von 18 Selektions-Paessen ueberschrieben; die F4-Ebene ist im Trigger-Lauf wirkungslos.
ORT: profile_runner.hpp:283-291 | profile_run_entry.hpp:761 | 67a8aa87 | 6dc01930
SOLL/FIX: **G-8 -- Der Batch-Plan wird von 18 Selektions-Paessen ueberschrieben; die F4-Ebene ist im Trigger-Lauf wirkungslos.**
- **Ort/SHA:** super `67a8aa87` (16:36) und `6dc01930` (16:31, Titel: *"die F4-Ebene ist gebaut, gruen und im Trigger-Lauf wirkungslos"*).
- **Beleg (Commit, verbatim):** *"VERSCHAERFENDER FUND, nicht im Auftrag: **DER TEURE PASS IST DER ERSTE, und genau sein Plan wird ueberschrieben.** Das Chunk-Fenster gilt NUR fuer den Basis-Pass ... Im Chunk-Bau schreibt also Pass 1 den Plan ueber das 2^17-Fenster, und die 17 folgenden Sweep-Paesse ueberschreiben dieselbe Datei. Beim Folgelauf findet der Basis-Pass seinen Plan garantiert nicht mehr."*
- **Am Objekt nachgezaehlt (ce `origin/development`):** `profile_sweep_passes` (`profile_runner.hpp:283-291`) = Basis-Pass **immer zuerst** (`passes.emplace_back(); // "" = Basis-Pass (immer zuerst)`), dann je `<axis_sweep>` ein Pass. `<axis_sweep ` je Profil: `all_axes_golden` **17**, `m3_golden_coverage` **17**, `m3v2_study` **8**, `m3v2_smoke` **2** -> **18/18/9/3 Paesse**. Chunk-Fenster-Bedingung heute `profile_run_entry.hpp:761` (Commit nannte `:762` -- Zeilendrift, N-2).
- **Eigene Korrektur, offen ausgewiesen:** mein erster Zaehlversuch mit `grep -o "<axis_sweep"` lieferte **18** statt 17, weil der Container `<axis_sweeps>` mitzaehlt. Mit `"<axis_sweep "` sind es 17 -- die Commit-Zahl haelt. *Eine Zahl ohne genannte Zaehlmethode ist nicht nachpruefbar* (N-2), hier an mir selbst.
- **Status:** OFFEN (Bau-Posten).
- **Fehlerklasse:** *"eine Ebene, die gebaut, gruen und wirkungslos ist"* -- verwandt mit H-6 (`PlanFach::offen`: erhoben, persistiert, verworfen), aber eine Stufe hoeher: hier wird nicht ein Feld, sondern die **ganze Resume-Ebene** vom eigenen Ablauf entwertet.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 143
GEGENSTAND: ROH: G-9 -- Der Lead hat einen KRITISCH-Befund auf einem CODE-KOMMENTAR entlastet; der Owner hat ihn zurueckgeholt.
ORT: 73ce9c8e
SOLL/FIX: **G-9 -- Der Lead hat einen KRITISCH-Befund auf einem CODE-KOMMENTAR entlastet; der Owner hat ihn zurueckgeholt.**
- **Ort:** Ledger mittag-15 (`:6080`), super `73ce9c8e`.
- **Beleg (Ledger, verbatim):** *"In mittag-13 Abschnitt C hatte ich Codex' KRITISCH-Befund ('der produktive Resume-Pfad liest den persistierten Plan gar nicht -- nur `write_batch_plan`, nie `read_batch_plan`') als 'fail-closed by design' ENTKRAEFTET und bin dabei dem Vorbehalt des Vehikel-Agenten gefolgt, der sich auf einen CODE-KOMMENTAR stuetzte. ... **ich habe eine Doktrin-Aussage aus einem Kommentar uebernommen, statt Ledger/Session-Log zu pruefen.**"* Und weiter: *"Der Kommentar im Code, der 'kein Resume-Anspruch fuer den Folgelauf' als beabsichtigt darstellt, steht damit im WIDERSPRUCH zur Planung -- **er ist Kandidat fuer eine Wahrheits-Korrektur, nicht Beleg.**"*
- **Status:** Befund reaktiviert; die Kommentar-Korrektur ist **offen**.
- **Fehlerklasse:** genau die vom Owner gesuchte *"Entlastung, die auf einer ungeprueften Praemisse steht"*. **Neue Regel-Kandidat:** *"Ein Code-Kommentar ist Beleg fuer den Code, nie fuer die Absicht. Eine Entlastung, die eine Doktrin aus einem Kommentar zieht, hat die Doktrin nicht geprueft, sondern zitiert."* -- das Dossier hat dafuer nichts; Z-Kapitel (zwei Quellen) trifft es nur halb, weil hier die **schwaechere** Quelle gewonnen hat.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 144
GEGENSTAND: ROH: G-10 -- Die Cacheline-Achse permutiert {32,64,128,256}, ohne dass eine Freigabe-Kette existiert -- und sie erreicht die Tier-Binary heute nicht.
ORT: ce/libs/cache_engine/axes/cacheline/cacheline_line_bytes.hpp:16-19 | ce/apps/catalog_codegen_tool/main.cpp:183-190 | 1b2f15bb
SOLL/FIX: **G-10 -- Die Cacheline-Achse permutiert {32,64,128,256}, ohne dass eine Freigabe-Kette existiert -- und sie erreicht die Tier-Binary heute nicht.**
- **Ort:** Ledger nachmittag-3 (`:5972-5976`), super `1b2f15bb`.
- **Beleg (Ledger, verbatim):** *"die Achse dringt HEUTE gar nicht bis zur Tier-Binary durch"* und *"**die Pruefung 'gibt die System-Achse frei, was die Hardware kann?' existiert fuer cacheline NICHT EINE ZEILE**"*.
- **Am Objekt bestaetigt:** `ce/libs/cache_engine/axes/cacheline/cacheline_line_bytes.hpp:16-19` sagt es selbst -- *"heute instanziieren alle Strategie-Basen die Default-CacheLineConfig{} (line_size = B64), weil der Codegen die per-Organ-Config noch nicht als NTTP emittiert"*; und `ce/apps/catalog_codegen_tool/main.cpp:183-190` **weist `cacheline` hart zurueck** (*"ist in der Limits-Entkopplungs-Vorstufe nicht unterstuetzt ... -- Profil ablehnen"*).
- **Status:** OFFEN (Bau-Auftrag im Deep-Research-Doc Abschnitt 3.3).
- **Fehlerklasse:** neu -- *"eine Achse, die deklariert permutiert und im gebauten Objekt konstant ist"*. Das Dossier beruehrt es nur indirekt in H-1 (dort korrekt gehedgt mit *"bei aktivierter KF-6-NTTP-Belegung"*), fuehrt aber nicht den Befund, dass die Freigabe-Kette **gar nicht existiert**.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 145
GEGENSTAND: ROH: G-11 -- Die Klasse "zwei Schreiber auf einem Objekt" trat heute DREIMAL auf.
ORT: b-m2-pmc-invariante | b-ci-rueckschrieb-beide-zeiger
SOLL/FIX: **G-11 -- Die Klasse "zwei Schreiber auf einem Objekt" trat heute DREIMAL auf.**
| # | Fall | Beleg |
|---|---|---|
| 1 | A1-NB Zwei-Schreiber-Alarm | Ledger `:6392` -- *"Bauagent FROR (Zwei-Schreiber) ... der Worktree BEWEGT sich noch (verwaister Schreiber, 2 aktive Prozesse, Diff-Hash aendert sich)"*; aufgeloest in vormittag-26 (`:6400`) |
| 2 | Graph-Welle: SendMessage-Resume erzeugt zweite Instanz | Ledger `:6279-6281` -- *"meine SendMessage-Nachreichung des Plan-Pfads RESUMTE den Agenten als ZWEITE, vom Workflow unabhaengige Instanz -- die Workflow-Instanz lief parallel weiter. Beide schrieben in dieselben Dateien"* |
| 3 | Lead committet zweimal in den Arbeitsbranch einer laufenden Welle | Ledger abend-3 par.D (`:4245`) -- *"weil der Hauptklon nicht mehr auf `development` stand (ce auf `b-m2-pmc-invariante`, super auf `b-ci-rueckschrieb-beide-zeiger`)"* |
- **Strukturelle Antwort erst im dritten Fall:** *"Konsequenz, ab sofort bindend: **Landungen laufen ueber eigene Worktrees** (`wt-landung`, `wt-super-landung`)"* -- beide existieren (geprueft).
- **Fehlerklasse:** neu, prozessual. Die Owner-Liste fuehrt nur Fall 3.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 146
GEGENSTAND: ROH: G-12 -- Die `.gitignore`-Falle: Gate-Belege werden stumm verschluckt -- heute vier Commits, und 78 Dateien sind es aktuell noch.
ORT: f7d96905 | afab6fbb | 9c858a73
SOLL/FIX: **G-12 -- Die `.gitignore`-Falle: Gate-Belege werden stumm verschluckt -- heute vier Commits, und **78 Dateien sind es aktuell noch**.**
- **Ort:** super `.gitignore:49` = `*.log` (Zeile aufgeschlagen).
- **Vier Anlassfaelle heute:** `f7d96905` (*"schluckte **21 der 26** t2a-Dateien stumm"*), `afab6fbb` (*"**15** haette stumm geschluckt"* von 19), `9c858a73` (*"**12 von 18** waeren stumm verschluckt worden"*), `0bda94aa` (*"Fuer die NB-Welle 511671c9..6c300e68 und fuer NB2 lag KEIN einziges Log im Spiegel"*).
- **Live nachgemessen, mit Nenner und Gegenprobe:** `docs/sessions/backups/` enthaelt **155** `.log`-Dateien; `git ls-files` kennt davon **77**; die restlichen **78** liefert `git check-ignore --stdin` als **78/78 ignoriert** -- sie liegen in **keinem** git-Objekt, nur in diesem Arbeitsbaum. Aeltester betroffener Ordner: `20260805-anker-a2-eich-welle/`.
- **Status:** OFFEN. Die beste Heilung des Tages (`9c858a73`) benennt selbst, warum `git add -f` nicht reicht: *"`git add -f` haette den Namen bestehen lassen, der die Falle ausloest -- tracked ist zwar gegen .gitignore immun, aber der Name passt weiter auf jedes `*.log`-Aufraeummuster; die Falle waere zugedeckt, nicht beseitigt."*
- **Fehlerklasse:** neu -- *"die Ablage verschluckt ihren eigenen Beleg"*. Beruehrt die Owner-Doktrin *Messdaten nie loeschen / Backups additiv*: die Zahlen der Wellen sind belegt, aber die Belege sind nicht versioniert.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 147
GEGENSTAND: ROH: G-13 -- Der Format-Gate-Nachzug ist heute zwoelfmal committet worden; das Dossier fuehrt zwei davon.
ORT: 2a58e2ed | 034e0068 | cc20b63d
SOLL/FIX: **G-13 -- Der Format-Gate-Nachzug ist heute **zwoelfmal** committet worden; das Dossier fuehrt zwei davon.**
- **Nachgezaehlt (beide Repos, alle Refs, seit 06.08. 00:00):** ce **7** (`2a58e2ed`, `034e0068`, `cc20b63d`, `b6d87c08`, `98952e02`, `b20eeabc`, `fb9aefdc`), super **5** (`50dc231b`, `6124c6f7`, `b35aea1b`, plus die beiden Landemerges mit Breiten-Fix). Dossier R-6 nennt `98952e02` und `b35aea1b`.
- **Der aussagekraeftigste fehlt: ce `b20eeabc`** (19:01) -- *"cf22: clang-format-Nachzug -- **Vorwellen-Luecke** aus der A1-NB2-Serie (nie mit dem exakten Job-Scope geprueft)"*. Beleg im Commit: *"Beim Ausfuehren der Landungs-Gates ... kamen drei Dateien der URSPRUENGLICHEN A1-NB2-Serie (`0b5ed557..fdfa68ee`) rot zurueck -- Stellen, die von den Bump-/Pin-/Kommentar-Commits dieser Landung NICHT beruehrt wurden"*; sieben Stellen, *"KEIN Byte Inhalt bewegt"*.
- **Warum das mehr ist als R-6:** hier war die Welle bereits als **landebereit gemeldet**, das Gate wurde erst bei der Landung im echten Job-Scope gefahren. Das ist R-2 (Pruefbereich) **plus** R-6 (nicht gelaufenes Gate) an einem Objekt.
- **Fehlerklasse:** R-6, mit Nenner. Vorschlag fuers Dossier: R-6 die Zahl **12/1 Tag** als Klassen-Signal geben -- Disziplin traegt hier messbar nicht.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 148
GEGENSTAND: ROH: G-14 -- Die repo-lokalen Ledger sind eine Quellenklasse, die niemand fuehrt -- und der Ledger sagt es selbst.
ORT: architektur-ziele-offene-punkte-ledger.md | 253bcd86 | 626b9db
SOLL/FIX: **G-14 -- Die repo-lokalen Ledger sind eine Quellenklasse, die niemand fuehrt -- und der Ledger sagt es selbst.**
- **Beleg (Ledger abend-1, Schluss-Absatz `:4762-4764`, verbatim):** *"**WAS DIESER NACHTRAG NICHT LEISTET:** er wertet dieselben Quellenklassen aus wie nachmittag-11 und ist damit derselben M2-Anfaelligkeit ausgesetzt -- `docs/audits/`, die drei repo-lokalen Ledger (ce/prt-art/thesis) und das Cluster-Ledger waren erneut **nicht** im Scope."*
- **Live nachgemessen:** ce hat **79** Commits auf `origin/development` am 06.08.; davon beruehren **0** `docs/ledger-sections/` -- letzter Eintrag im ce-eigenen `architektur-ziele-offene-punkte-ledger.md` (275 Z.) ist `253bcd86` vom **05.08. 19:34**. thesis: **6** Commits am 06.08., **0** auf `docs/ledger-sections/`, letzter Eintrag `626b9db` vom **03.08.** prt-art: **0** Commits seit 03.08.
- **Status:** OFFEN.
- **Fehlerklasse:** **R-10** (Session-Doc ist Beleg, kein Register) -- hier eine Ebene hoeher: ein **Register**, das kein Register mehr ist, weil niemand es fuehrt. Verstaerkt R-10 statt eine neue Regel zu brauchen.

---
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 149
GEGENSTAND: ROH: G. ZWEI LAGE-BEFUNDE, DIE DAS DOSSIER ALS "SOFORT" FUEHRT UND DIE INZWISCHEN WIEDER EINGETRETEN SIND
ORT: unbekannt
SOLL/FIX: ### G. ZWEI LAGE-BEFUNDE, DIE DAS DOSSIER ALS "SOFORT" FUEHRT UND DIE INZWISCHEN **WIEDER** EINGETRETEN SIND
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 150
GEGENSTAND: ROH: G-15 -- S-2/S-3/Z-2: nach dem vollzogenen Kettenschluss T-1 (Ledger abend-2 par.A, 20:59) haengen beide `main` binnen zwei Stunden erneut zurueck.
ORT: .gitlab-ci.yml | b241a272 | 2b5ecd29 | 8894d983
SOLL/FIX: **G-15 -- S-2/S-3/Z-2: nach dem vollzogenen Kettenschluss T-1 (Ledger abend-2 par.A, 20:59) haengen beide `main` binnen zwei Stunden erneut zurueck.**
- **Live gemessen (`git rev-list --count origin/main..origin/development`):**
  - ce: `origin/main` = `b241a272`, `origin/development` = `2b5ecd29` -> **8 Commits zurueck** (darunter die PMC-Invariante `8894d983`, E14 `77ed15fa`, die Codegen-Struktur-Haertung `b708c572`, der m3v2-Fensterfix `2b5ecd29`).
  - super: `origin/main` = `2a6f35d8`, `origin/development` = `38381ac8` -> **9 Commits zurueck** (darunter die neue super-ASCII-Wache `7780c6af` und die Thesis-Paritaets-Wache `3ccbc501`).
- **Wirkung unveraendert belegt:** die drei Trigger stehen weiterhin auf `branch: main` -- heute in `.gitlab-ci.yml` auf **`:310`, `:328`, `:346`** (das Dossier nennt `:255/:273/:291` -- **55 Zeilen Drift binnen Stunden**, N-2 in Aktion). Ein super-`main`-Lauf triggert also gerade eine ce-Kette **ohne** die PMC-Invariante und ohne die Codegen-Haertung.
- **Fehlerklasse:** Z-2 bestaetigt sich als **Zeitbombe mit Zufallszuendung**: die Heilung ist zum dritten Mal am selben Tag ein Nachzug geblieben. Die Dossier-Naechste-Handlung (2) -- `branch: $CI_COMMIT_REF_NAME` -- ruecht damit von T4 nach vorn.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 151
GEGENSTAND: ROH: G-16 -- S-1 ist in schaerferer Form zurueck: der super-Arbeitsbaum-Gitlink zeigt auf einen ce-Commit, der auf keinem Integrationszweig liegt.
ORT: b-m2-pmc-invariante | 90bca126 | b241a272
SOLL/FIX: **G-16 -- S-1 ist in **schaerferer** Form zurueck: der super-Arbeitsbaum-Gitlink zeigt auf einen ce-Commit, der auf **keinem** Integrationszweig liegt.**
- **Gemessen:** `git submodule status` -> `+90bca126... Code/external/comdare-cache-engine`; `git ls-tree origin/development` -> `b241a272`. **`git merge-base --is-ancestor 90bca126 origin/development` = NEIN** -- `90bca126` ist der Kopf des Bau-Zweigs `b-m2-pmc-invariante`; derselbe Inhalt landete unter einem **anderen** Merge-SHA (`b708c572`).
- **Unterschied zum Dossier-S-1:** dort zeigte der Zeiger *"vorwaerts, 2 Commits"* auf einen gelandeten Stand. Jetzt zeigt er auf einen Seitenast. Ein Commit dieses Zeigers wuerde einen Gitlink versionieren, den `origin/development` nicht kennt.
- **Fehlerklasse:** **R-8** -- `+` heisst weder "neuer" noch "erreichbar".

---
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 152
GEGENSTAND: ROH: H. WAS ICH NICHT BELEGEN KONNTE (ausdruecklich benannt)
ORT: result.csv | libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp | 2b5ecd29 | 22e17f57 | 81651f6e
SOLL/FIX: ### H. WAS ICH **NICHT** BELEGEN KONNTE (ausdruecklich benannt)

1. **Herkunft der Zahl "845 / 174 / 18714" (G-5).** Ich kann zeigen, dass der dokumentierte Aufruf abbricht und dass 96 % des Bestands nie gelesen wurden. Ich kann **nicht** rekonstruieren, aus welchem Lauf die Zahl stammt. Als `[?] UNBELEGT` zu fuehren, nicht als Falschaussage.
2. **F8 / Cross-Run-Halbzustand** (Ledger mittag-17, `:6062`: *"Neubau mit GLEICHEM Fingerprint (weil DLL/Sidecar fehlte) invalidiert `result.csv.stamp` NICHT (`build_orchestrator:676-690`)"*). Die Datei ist heute `libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp`, der zitierte Bereich ist verschoben; ich habe die Stamp-Invalidierungs-Logik **nicht** in der noetigen Tiefe nachgelesen. Der Posten ist im Ledger als **offene Owner-Frage** gebucht und fehlt im Dossier -- den Sachverhalt selbst habe ich nicht verifiziert.
3. **Die PMC-Posten (Owner-Liste 11 und 14).** Ich habe nur die Ancestry belegt: `2b5ecd29` (m3v2-Fensterfix) und `22e17f57` (errno-Diagnose) sind Vorfahren von `ce origin/development`, `81651f6e` ist es nicht (Zwilling auf dem Bau-Zweig). Die Messaussagen selbst (leeres Fenster, `errno=2`, Intel-Stillschaltung) habe ich **nicht** nachgemessen -- anderer Sammel-Auftrag.
4. **Die Buchfuehrungs-Zahlen aus nachmittag-11 / mittag-19** (18 wirklich verloren / 15 nur anders benannt; 20 Positionen der Vor-Zeit-Bruecke) habe ich nicht nachgezaehlt. Der Ledger weist selbst aus, dass sie veralten (REGEL-ZEILE 14).
5. **Owner-Posten 15 (Runner-Token nicht rotiert)** ist im Ledger abend-2 par.D vollstaendig belegt (Mengentest, drei Projekte). Ich habe ihn **nicht** nachgefahren -- das waere ein Cluster-Zugriff und faellt unter die read-only-Auflage.

---
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 153
GEGENSTAND: ROH: I. ZUSAMMENFASSUNG FUER DIE EINARBEITUNG
ORT: unbekannt
SOLL/FIX: ### I. ZUSAMMENFASSUNG FUER DIE EINARBEITUNG

- **Zwei Korrekturen am Dossier selbst** (G-1 Z-8-Nebenbefund, G-2 C-2) -- beide gegen den vom Dossier genannten Messstand belegt.
- **Vier neue Regel-Kandidaten**, die keine der zehn Regeln abdeckt:
  1. *"Eine Migration erbt die Fehlerklasse, die sie beseitigt."* (G-3)
  2. *"Ein Identitaets-Stempel ist nur so gut wie die Menge der Eingaenge, die ihn veraendern."* (G-4, fuenf Faelle an einem Tag)
  3. *"Ein Code-Kommentar ist Beleg fuer den Code, nie fuer die Absicht."* (G-9)
  4. *"Die Ablage darf ihren eigenen Beleg nicht verschlucken."* (G-12, 78 Dateien live)
- **Drei Regeln bekommen ihren Nenner:** R-6 -> 12 Format-Nachzuege an einem Tag (G-13) * R-8 -> Gitlink auf Seitenast (G-16) * R-10 -> repo-lokale Ledger 0/79 Commits (G-14).
- **Zwei "Sofort"-Posten sind wieder eingetreten** (G-15, G-16) und gehoeren mit Datum und neuem Zahlenstand in den Sofort-Block, nicht als Wiederholung, sondern als **Rueckfall-Beleg**: die Heilung war beide Male ein Nachzug.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 154
GEGENSTAND: ROH-SAMMLER[3] Kopf/Erhebungsbasis
ORT: 38381ac8 | 2a6f35d8 | 2b5ecd29
SOLL/FIX: ## SAMMEL-AUFTRAG "indirekte Regressionen" -- Ergebnis

Alles unten ist **selbst am Objekt gemessen** (GNU grep 3.11 absolut, Wachen live ausgefuehrt, git ohne lokale Ref-Kopien). Staende der Messung: super `origin/development` = `38381ac8`, `origin/main` = `2a6f35d8`; ce `origin/development` = `2b5ecd29`, `origin/main` = `b241a272`; thesis `19e15920`.

---
STATUS LT. QUELLE: nur-hinweis (Erhebungsbasis des Sammlers)
ABHAENGIGKEIT/FLAECHE: -

### [w3azi1rhl.json] 155
GEGENSTAND: ROH: I-1 `[ ] OFFEN` -- Die Diff-Hygiene-Wache existiert zweimal in ZWEI VERSCHIEDENEN STRENGEN; die schwaechere Fassung ist die einzige, die in CI haengt
ORT: scripts/ci_diff_ascii_width_guard.sh:189-191 | scripts/ci_diff_ascii_width_guard.sh:373-375 | scripts/foo.sh | 7780c6af | 8894d983
SOLL/FIX: ### I-1 `[ ] OFFEN` -- Die Diff-Hygiene-Wache existiert zweimal in ZWEI VERSCHIEDENEN STRENGEN; die schwaechere Fassung ist die einzige, die in CI haengt

**Was.** R-1 wurde geheilt, indem die Prozedur durch ein Werkzeug ersetzt wurde. Am Abend wurde das Werkzeug in den super **gespiegelt** (`7780c6af`) -- und die Kopie ist an zwei Stellen **strenger** als das Original, ohne dass das Original nachgezogen wurde.

**Ort.** ce `scripts/ci_diff_ascii_width_guard.sh:189-191` gegen super `scripts/ci_diff_ascii_width_guard.sh:373-375` (`is_scoped`).

**Beleg -- Live-Reproduktion, identische Eingabe, zwei Verdikte** (praeparierter Diff auf `scripts/foo.sh` mit einer Umlaut-Zeile und einer 140-Byte-Zeile):

```
CE-WACHE   : "0 Zusatzzeilen ... geprueft"  -> DIFF-HYGIENE-WACHE: GRUEN.  EXIT=0
SUPER-WACHE: NICHT-ASCII scripts/foo.sh:1 / >120-SPALTEN scripts/foo.sh:2 (140 Byte)
             -> DIFF-HYGIENE-WACHE: ROT.   EXIT=1
```

Die ce-Fassung kennt `.sh` **nicht**; die super-Fassung hat es ergaenzt und sagt das in ihrem eigenen Kopf woertlich (`:62-64`): *"Die ce-Vorlage kennt .sh NICHT. Im super sind Shell-Skripte selbst verfasster Code ... und gehoeren in den Scope; sie sind hier ergaenzt."*

**Die Wirkung ist nicht theoretisch, sondern gemessen.** In `ce/scripts/` liegen heute vier Shell-Wachen, drei davon **am 06.08. gebaut** -- und sie tragen **13 Zeilen ueber 120 Byte**, die keine Wache je gesehen hat:

| Datei:Zeile | Byte |
|---|---:|
| `ci_test_coverage_manifest.sh:83` | **356** |
| `ci_test_coverage_manifest.sh:98` | 284 |
| `ci_test_coverage_manifest.sh:48` | 238 |
| `ci_test_coverage_guard.sh:87` | 158 |
| `ci_test_coverage_guard.sh:67` | 148 |
| `ci_test_coverage_manifest.sh:73` | 144 |
| `ci_yaml_key_guard.sh:140` | 130 |
| + 6 weitere (`guard.sh:66,139,152,154`, `manifest.sh:88,170`) | 123-137 |

Dazu **21 Nicht-ASCII-Zeilen** in den aelteren ce-Skripten (`copy_results_to_nas.sh` 10, `lint_flags_includes.sh` 10, `comdare_storage_activation.sh` 1). Die Wache selbst (348 Zeilen) haelt ihre Invariante -- von Hand, nicht durch Pruefung.

**Zweite Divergenz, dieselbe Richtung.** Die super-Fassung hat `--seit-basis` (bestimmt den Bereich per `merge-base` selbst und **lehnt einen blanken SHA aktiv ab, Exit 2**). Die ce-Fassung hat diesen Modus **nicht** und nimmt einen rohen Bereich widerspruchslos an -- am Objekt gefahren:

```
$ sh scripts/ci_diff_ascii_width_guard.sh "8894d983..2b5ecd29"
MODUS: git diff selbst ausgefuehrt (Repo: .../comdare-cache-engine)
ARGUMENTE: git diff -U0 --no-color --no-ext-diff 8894d983..2b5ecd29
```

Und genau **in dieser Form** ist sie in CI verdrahtet (`ce/.gitlab-ci.yml`, `test:coverage-guard`): `_ce_base="${CI_MERGE_REQUEST_DIFF_BASE_SHA:-}"`, sonst `CI_COMMIT_BEFORE_SHA`, sonst `HEAD~1`, dann `sh scripts/ci_diff_ascii_width_guard.sh "${_ce_base}..HEAD"`. Die super-Wache begruendet in ihrem Kopf (`:117-121`), warum genau das falsch ist: *"Ein uebergebener Zwischen-SHA ... schneidet den Bereich zu eng. In dieser Session hat genau das 61 Prozent einer Aenderung verborgen."*

**Status:** offen, beide Teile.
**Fehlerklasse:** **neue Regel noetig.** Sie ist die Kreuzung von **R-7** (Gate-Umfang ist repo-spezifisch) und **Z-1** (zwei Quellen, gepflegt wird eine): *"Eine gespiegelte Wache ist eine zweite Quelle. Ab dem Tag der Spiegelung ist 'die Wache sagt gruen' keine Aussage mehr, solange nicht gesagt ist, WELCHE."* Verschaerfend: die Spiegelung hat die Verbesserungen **nur in die Kopie** gelegt -- das schwaechere Original bewacht das groessere Repo.

---
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 156
GEGENSTAND: ROH: I-2 `[ ] OFFEN` -- Der `--bestand`-Modus der super-Wache kann in diesem Repo NICHT durchlaufen; seine nie erzeugte Ausgabe steht als Begruendung im CI-File
ORT: .gitlab-ci.yml | scripts/ci_diff_ascii_width_guard.sh | 20260931
SOLL/FIX: ### I-2 `[ ] OFFEN` -- Der `--bestand`-Modus der super-Wache kann in diesem Repo NICHT durchlaufen; seine nie erzeugte Ausgabe steht als Begruendung im CI-File

**Was.** Eine Zahl ist aus einer Messung, die es so nicht gegeben haben kann, in die `.gitlab-ci.yml` gewandert -- und traegt dort eine **Politik-Entscheidung** (der Alt-Bestand wird bewusst nicht gegatet).

**Ort.** super `.gitlab-ci.yml`, Kommentarblock zu `lint:diff-hygiene`, Abschnitt "WARUM KEIN allow_failure", woertlich:

> "Der Bereich ist in der Praxis klein ..., der Alt-Bestand wird bewusst NICHT geprueft: `--bestand` meldet heute 845 Nicht-ASCII- und 174 Breiten-Zeilen aus 18714: eine Bestands-Wache waere am Tag ihrer Einfuehrung rot geboren."

**Beleg (selbst gefahren, zweimal FATAL):**

```
$ sh scripts/ci_diff_ascii_width_guard.sh --bestand ; echo EXIT=$?
FATAL: Datei nicht lesbar: .../Code/external/20260931-overleaf-diplomarbeit
DIFF-HYGIENE-WACHE: ABBRUCH -- awk-Verarbeitung fehlgeschlagen (rc=2)
EXIT=2
```

Ursache 1: `git ls-files` listet die **vier Submodul-Gitlinks** als Dateien (`Code/external/20260931-overleaf-diplomarbeit`, `Code/external/comdare-cache-engine`, `Code/external/comdare-prt-art`, `thesis/diplomarbeit`); awk kann sie nicht oeffnen. Der `NENNER`-Block wird nie erreicht.

Mit Ausschluss-Pathspecs faellt sie an der naechsten Stelle:

```
$ sh scripts/ci_diff_ascii_width_guard.sh --bestand ':!Code/external' ':!docs' ':!thesis' ':!Forschungsarbeiten'
FATAL: Datei nicht lesbar: .../"E-Mail K\303\274hn \342\200\223 benjamin-elias.probst@...pdf"
EXIT=2
```

Ursache 2: `git ls-files` **quotet** Pfade mit Nicht-ASCII-Namen C-artig; awk oeffnet den Namen samt Anfuehrungszeichen und Oktal-Escapes.

**Und die Zahl selbst.** `--bestand` hat **keinen** Pfad-Ausschluss im Code -- der Ausschluss steht nur im Kommentar (`:60-61`: *"git ls-files ohne Code/external, Forschungsarbeiten, docs, thesis, Code/build*"*). Meine Nachrechnung:

| Bezugsmenge | Zeilen im Scope | Nicht-ASCII | >120 |
|---|---:|---:|---:|
| **so wie `--bestand` sie bildet** (alle `ls-files`) | 240975 | 1154 | 3446 |
| **die im Kommentar deklarierte enge Menge** | 21066 | 943 | 191 |
| **die zitierte Zahl** | 18714 | 845 | 174 |

**Status:** offen. Der **Befund haelt** (eine Bestands-Wache waere rot geboren), die **Zahl ist nicht reproduzierbar** und die **Betriebsart, der sie zugeschrieben wird, laeuft nicht**.
**Fehlerklasse:** **R-1** in ihrer bittersten Form -- eine Zahl **mit** Nenner, die trotzdem nicht traegt, weil der Nenner aus einer anderen Messung stammt als der Zaehler. Plus **neue Teilregel:** *"Ein Modus, den kein Job aufruft, ist ungetestet -- auch wenn er im selben Skript steht wie ein bewiesener."* Kein Job ruft `--bestand`; CI faehrt ausschliesslich `--seit-basis`.

---
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 157
GEGENSTAND: ROH: I-3 `[ ] OFFEN` -- Acht ce-Landungen des Abends stehen in KEINEM Gitlink; super und `main` bauen `b241a272`
ORT: generated_source_catalog.hpp | super/.gitlab-ci.yml:255 | b241a272 | 2b5ecd29
SOLL/FIX: ### I-3 `[ ] OFFEN` -- Acht ce-Landungen des Abends stehen in KEINEM Gitlink; super und `main` bauen `b241a272`

**Was.** Die Abend-Heilungen sind auf der ce-Linie gelandet und im integrierten System **unsichtbar**. Vierte Wiederkehr von Z-2/S-1..S-3 an einem Tag -- diesmal verschluckt sie genau die Arbeit des Abends.

**Beleg (live gemessen, `ls-tree` gegen `ls-remote`, keine lokalen Ref-Kopien):**

```
ce  origin/development                       2b5ecd29
ce  origin/main                              b241a272     (8 zurueck)
super origin/development  : Gitlink ce       b241a272     (8 zurueck)
super origin/main         : Gitlink ce       b241a272
super origin/main         : thesis/diplom.   8e58f691     (VOR Anhang-A-Ehrlichkeit 19e1592)
super origin/main                            2a6f35d8     (9 hinter development)
```

Die acht ungespiegelten ce-Commits:

| SHA | Inhalt |
|---|---|
| `6ddd7fd4` / `b708c572` | Struktur-Haertung: `generated_source_catalog.hpp` in eigenes `generated/limits` -- die **Klassen**-Heilung zu Z-7 |
| `8894d983` | **M-2/P-PMC-1: PMC-Pflicht als INVARIANTE** in die dynamische Messkette (= A-1/SW-3) |
| `2b5ecd29` | m3v2_pmc_smoke misst ein echtes Fenster statt eines leeren |
| `ed67661c`/`77ed15fa`, `fb9aefdc`, `22e17f57` | E14 NoneFilter, Breiten-Fix, errno-Diagnose |

Die drei Bridges stehen unveraendert auf `branch: main` (`super/.gitlab-ci.yml:255, :273, :291`). Ein Lauf auf der Autoritaets-Linie triggert ce also auf `b241a272` -- **vor** allen Abend-Heilungen.

**Der indirekte Teil.** Ledger-Nachtrag `abend-3`, Tabelle "WAS GELANDET IST", fuehrt `b708c572` und `77ed15fa` als gelandet. Das ist fuer die ce-Linie wahr und fuer das gebaute System falsch: der letzte Gitlink-Bump (`863efddc`, 20:42) ging auf `b241a272` und liegt **zeitlich vor** den vier ce-Landungen ab 21:2x. Eine "GELANDET"-Zeile, die den Zeiger nicht mitmisst, ist eine Aussage ueber ein Repo, nicht ueber die Lieferung.

**Status:** offen (S-1/S-2/S-3 in neuer Auspraegung).
**Fehlerklasse:** **Z-2** (Deckung an einem Zweignamen statt am eingebundenen SHA) + **R-9** in der Gitlink-Variante. **Neue Teilregel:** *"'Gelandet' ist eine Aussage ueber genau eine Linie. Fuer ein Submodul-System lautet die Frage: steht es im Zeiger, den der Bau liest?"*

---
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 158
GEGENSTAND: ROH: I-4 `[x] Sache geheilt / `[ ]` Zahl zu korrigieren` -- Die Anhang-A-Zahlen des Dossiers (Z-8/C-1) sind um eins zu hoch, und die "Korrektur gegen die Session" kehrt ei
ORT: anhang/de/A_measurements.tex:71 | 8970465d | 8e58f691 | 19e15920
SOLL/FIX: ### I-4 `[x] Sache geheilt / `[ ]` Zahl zu korrigieren` -- Die Anhang-A-Zahlen des Dossiers (Z-8/C-1) sind um eins zu hoch, und die "Korrektur gegen die Session" kehrt eine richtige Zahl in eine falsche

**Was.** Das Dossier zaehlt eine **Kommentarzeile** als Eintrag -- und zwar genau die Zeile, die es zwei Absaetze weiter als Datei-Kopf-Begruendung **zitiert**.

**Beleg (drei Revisionen, Zaehlmethode genannt):**

| Revision | `grep -c "InputIfFileExists"` | echte Eintraege (`^\InputIfFileExists`) | stumm (`}{}$`) | mit Ersatztext (`}{%$`) |
|---|---:|---:|---:|---:|
| `8970465d` | 29 | **28** | 17 | **11** |
| `8e58f691` | 29 | **28** | 17 | **11** |
| `19e15920` | 30 | **28** | **0** | **28** |

Die 29. bzw. 30. Fundstelle sind Kommentarzeilen, u. a. `anhang/de/A_measurements.tex:71`: `%  \InputIfFileExists: kompiliert auch VOR dem ersten Messlauf sauber.` -- dieselbe Zeile, die das Dossier in Z-8 als *"kompiliert auch VOR dem ersten Messlauf sauber"* zitiert.

Das Dossier schreibt: *"Korrektur gegen die Session: dort standen 28 / 17 / 11 -- gemessen am aelteren Stand `8970465d`"* und *"Der Commit `8e58f691` ... hat einen Eintrag mit Ersatztext hinzugefuegt"*. Beides traegt nicht: **28/17/11 war an BEIDEN Staenden richtig**; `8e58f691` hat an dieser Zaehlung nichts geaendert. Die "Korrektur" hat eine richtige Zahl durch eine falsche ersetzt.

**Sachstand heute:** C-1(a) ist **erledigt** -- `19e15920` (*"docs(anhang A): jeder der 28 Abbildungs-Eintraege traegt jetzt seinen EIGENEN Ersatztext (DE+EN)"*), 0 stumme Eintraege in DE **und** EN. Offen bleiben C-1(b) (Zaehl-Gate) und C-1(c) (`axis_inventory`). `0 Zieldateien existent` gilt weiterhin an allen drei Staenden.

**Fehlerklasse:** **N-2** -- angewandt auf das Dossier selbst: *"eine Zahl ohne genannte Zaehlmethode ist nicht nachpruefbar"*. Das Dossier formuliert die Regel und verletzt sie in derselben Tabelle.

---
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 159
GEGENSTAND: ROH: I-5 `[ ] OFFEN` -- Die Entlastung von A-8 steht auf einer Gegenprobe, die Tests ausschliesst; genau dort liegt die einzige lebende Fundstelle, festgenagelt von einem
ORT: ce/libs/cache_engine/include/cache_engine/measurement/measure.hpp:37-38 | tests/unit/test_measurement_buffer.cpp:131 | system_axis.hpp | 74c1e780 | 38381ac8
SOLL/FIX: ### I-5 `[ ] OFFEN` -- Die Entlastung von A-8 steht auf einer Gegenprobe, die Tests ausschliesst; genau dort liegt die einzige lebende Fundstelle, festgenagelt von einem gruenen Test

**Was.** Die A-8-Entkraeftung (`74c1e780`/`38381ac8`) ist in vier von vier Punkten sachlich richtig -- ich habe alle vier nachgemessen. Ihre **Gegenprobe** hat aber eine zu kleine Suchmenge, und das aendert die Bewertung des einen offenen Punktes.

**Beleg -- die Gegenprobe, verbatim aus dem Ledger-Nachtrag:**

> "**GEGENPROBE (der Teil, der die Entlastung erst belastbar macht):** repoweite Suche nach `* 64`/`/ 64` im Cacheline-/CLU-Kontext **ausserhalb Tests**/ext/build ergab KEINE weitere lebende, noch falsche Fundstelle."

**Was in der ausgeschlossenen Menge liegt.** `ce/libs/cache_engine/include/cache_engine/measurement/measure.hpp:37-38`:

```cpp
        // CLU = effektiv genutzte Bytes pro Cache-Line (64 B)
        ctx.cache_lines_used += used_bytes / 64;
```

Einziger Aufrufer im ganzen Repo (selbst nachgezaehlt): `tests/unit/test_measurement_buffer.cpp:131`. Und dieser Test **pinnt die falsche Einheit als Zusage**:

```cpp
    using M = cem::Measure<cem::MeasurementCategory::CLU, cem::AlgoDetail::ART_NODE256>;
    M::at_node_visit(128, ctx);
    EXPECT_EQ(ctx.cache_lines_used, 2u);      // 128/64 == 2
```

Die Einstufung "toter Beispielcode, kein produktiver Aufrufer" ist fuer die **Messstrecke** korrekt und entlastet sie. Fuer den **Bestand** entlastet sie nicht: ein gruener Test zementiert 64 als Linien-Groesse, waehrend die Unterachse 32/64/128/256 fuehrt. Wer die Stelle spaeter richtigstellt, faellt zuerst ueber diesen Test -- und die naheliegende Reaktion ist, den Test "wieder gruen zu machen".

**Bestaetigte Nachmessung der uebrigen drei A-8-Stellen** (damit sie niemand erneut jagt): `system_axis.hpp` geheilt durch `c1c76c87` (15:31 UTC), Nenner `line_bytes = snapshot->axis_stats[5][5]`, fail-closed bei `cache_lines==0 || line_bytes==0`; `node_width_config.hpp` geheilt durch `0b5ed557` (09:08 UTC); `axis_05_memory_layout_cache_line_aligned.hpp` geheilt durch `0680eff1` (13:26 UTC) -- der Code sagt an `:88` selbst: *"hier stand `constexpr std::size_t kCacheLine = 64;`"*. Alle drei **vor** der Verdichtung (21:24).

**Status:** offen (Aufraeumpass **F-3**), sachlich klein, methodisch relevant.
**Fehlerklasse:** **R-3** (Vollstaendigkeitsaussage ueber eine zu kleine Menge -- hier: der Ausschluss `ausserhalb Tests` enthielt den Fund) **+ H-7** (gruener Test pinnt den Defekt statt der Zusage).

---
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 160
GEGENSTAND: ROH: I-6 `[x] Gegenprobe DURCHGEFUEHRT` -- Z-7 Restposten (a): es gibt KEINE zweite fehlende Codegen-Kante; die Klassenheilung liegt aber in keinem Gitlink
ORT: generated_source_catalog.hpp | profile_run_entry.hpp:29 | tests/unit/test_lazy_adhoc_source_gen.cpp:18 | 14eed391 | 678a4487
SOLL/FIX: ### I-6 `[x] Gegenprobe DURCHGEFUEHRT` -- Z-7 Restposten (a): es gibt KEINE zweite fehlende Codegen-Kante; die Klassenheilung liegt aber in keinem Gitlink

**Was.** Das Dossier laesst Z-7 mit dem Restposten *"die Gegenprobe fuer **alle** Konsumenten von `generated_source_catalog.hpp` ... steht aus"* offen. Ich habe sie gefahren.

**Beleg (auf `ce origin/development`).** Direkte Includer: `profile_run_entry.hpp:29`, `tests/unit/test_lazy_adhoc_source_gen.cpp:18`, `tests/unit/test_limits_entkopplung_vorstufe.cpp:4` (dazu ein Kommentar-Treffer in `source_catalog.hpp:132`). Transitiv ueber `profile_run_entry.hpp`: `experiment_plan_director.hpp`, `experiment_run_entry.hpp`, `profile_run_facade.cpp`, `tests/unit/test_t2a_f4_facade_plan_durchreichung.cpp`; ueber `experiment_plan_director.hpp`: `tests/unit/thesis_tiere/test_experiment_plan_director.cpp`. Dem stehen gegenueber: `tests/unit/CMakeLists.txt:3041, 3468, 4443, 4471, 4498` (fuenf `comdare_attach_generated_catalog`) plus die DEFER-Kante der Bibliothek `libs/cache_engine/profile_facade/CMakeLists.txt:120`. **Schnittmenge vollstaendig -- keine zweite fehlende Kante.** Restposten (a) kann mit dieser Messung geschlossen werden.

**Der indirekte Rest, der bleibt.** Fuer die **Paper-Codegen**-Familie hat das Haus laengst eine **Invariante** statt einer Liste (`ce/CMakeLists.txt:1595-1602`, verbatim: *"Hermetik: JEDES Test-Target bekommt die Codegen-Kante -- eliminiert die 14eed391-Fehlerklasse fuer den Sammel-Bau vollstaendig"* -- ueber `GLOBAL PROPERTY COMDARE_TEST_TARGETS`). Der Katalog-Codegen haengt weiterhin an **fuenf handgeschriebenen** `attach`-Aufrufen. `678a4487` hat einen sechsten hinzugefuegt -- also die Listenform verlaengert, nicht abgeloest. Erst `6ddd7fd4` macht das Vergessen deterministisch (eigenes `generated/limits`, `#include` schlaegt fehl statt zu racen) -- und **dieser Commit liegt in keinem Gitlink** (s. I-3).

**Fehlerklasse:** **SW-2** ("Liste statt Invariante") -- am selben Tag im selben Repo einmal geloest und einmal nicht.

---
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 161
GEGENSTAND: ROH: Entlastungen -- am Objekt geprueft, damit sie nicht ein zweites Mal gejagt werden
ORT: super/.gitlab-ci.yml:98-107 | ci/thesis_gitlink_parity.sh | m3v2_pmc_smoke.cpp:117 | 20260931 | b241a272
SOLL/FIX: ### Entlastungen -- am Objekt geprueft, damit sie nicht ein zweites Mal gejagt werden

| # | Verdacht | Befund am Objekt |
|---|---|---|
| E-i | Die neue Thesis-Paritaets-Wache koennte in einer docs-only-Welle ausfallen -- also genau bei einem reinen Gitlink-Bump | **Nein.** `.code-rules` (`super/.gitlab-ci.yml:98-107`) fuehrt `Code/external/*`, `thesis/diplomarbeit`, `.gitmodules` explizit; der Kommentar `:101-104` benennt den Fall. Kein Loch. |
| E-j | `anhang:forward` bumpt weiterhin nur einen Zeiger (Owner-Posten 13) | **Geheilt.** `:1170` `THESIS_GITLINKS="thesis/diplomarbeit Code/external/20260931-overleaf-diplomarbeit"`, Fruehausstieg `:1181` prueft **beide**, Nachbedingung `:1194` `ci/thesis_gitlink_parity.sh --quelle index --erwartet "$NEW_THESIS_SHA"`. Die Wache ist fail-closed (fehlender Pfad = Exit 1, kein `\|\| true`). |
| E-k | SW-3 Wache 2 und Wache 4 beissen weiterhin nicht | **Geheilt auf `origin/development`.** Beide Smokes tragen `kPmcExpected`: `m3v2_pmc_smoke.cpp:117` `pmc_seam_ok = delta.available \|\| (!kPmcExpected && counters_all_zero)`; `linux_perf_pmc_smoke.cpp:98-105` liefert bei `kPmcExpected && !available` **SMOKE_FAIL / return 1**. Der 13.07.-Inversionsfix ist unangetastet -- genau die in A-3 verlangte Form. |
| E-l | Die `137 von 139`-Zahl aus `abend-3` ist ein Bericht | **Reproduziert.** merge-base `b241a272`, `git diff -U0 ... \| Wache --stdin` -> *"137 Zusatzzeilen ... geprueft, davon 0 Nicht-ASCII, davon 0 ueber 120 Spalten. 139 ... insgesamt; 2 davon ausserhalb des Scopes"*, uebersprungen: `axis_filter_flags.hpp.in`. |
| E-m | Die `16/16`-Entlastung zu Anhang A ist ein Bericht | **Reproduziert.** 16 harte `\input` in `anhang/de/A_measurements.tex`, **0 fehlend**. |
| E-n | Heutige ce-Landungen koennten Nicht-ASCII eingeschleppt haben | **Nein.** `b241a272..origin/development`, alle Zusatzzeilen: **0** Nicht-ASCII. Das Nicht-ASCII in den beiden PMC-Smokes ist Alt-Bestand, kein Wachen-Versagen. |
| E-o | Der super koennte dieselbe YAML-Doppelschluessel-Klasse tragen wie der ce (SW-1) | **Heute nicht realisiert**: ce-Schluessel-Wache gegen `super/.gitlab-ci.yml` gefahren -> *"Top-Level-Schluessel-Zeilen: 34, davon verschiedene Namen: 34 -> kein doppelter Schluessel"*, EXIT=0. **Aber: kein super-Job ruft die Wache.** Die Klasse ist im super unbewacht -- Folgeposten zu D-3. |

---
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 162
GEGENSTAND: ROH: Nebenbefund zu I-1, gemessen und einreihbar
ORT: unbekannt
SOLL/FIX: ### Nebenbefund zu I-1, gemessen und einreihbar

Die uebersprungene Datei aus E-l zeigt eine **zweite Scope-Luecke derselben Art**: `*.hpp.in`-Templates sind selbst verfasster C++-Code, dessen Zeilen woertlich in kompilierte Header wandern -- und sie sind in **beiden** Wachen ausserhalb des Scopes. Gemessen ueber die 29 verfolgten `.in`-Templates des ce (ohne `ext/`): **723 Zeilen, davon 37 Nicht-ASCII, 0 ueber 120**. Gehoert in denselben Handlungsposten wie `.sh`.

---
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 163
GEGENSTAND: ROH: Was ich NICHT belegen konnte -- ausdruecklich
ORT: 18a0bdf3 | 3ccbc501
SOLL/FIX: ### Was ich NICHT belegen konnte -- ausdruecklich

1. **Ob eine der heute gebauten Wachen je in einer echten Pipeline gelaufen ist.** Von hier aus gibt es keinen CI-Zugang. Ich kann nur die **Biss-Faehigkeit lokal** beweisen (I-1, I-2) und die Verdrahtung lesen. Die ehrliche Restgrenze aus SW-4 (*"der erste echte Lauf ist der Beweis dieser einen Stelle"*) bleibt fuer die ce-Verdrahtung und fuer `lint:diff-hygiene` im super **unbewiesen**.
2. **Die Herkunft der Zahl `845 / 174 / 18714`.** Ich habe belegt, dass `--bestand` sie heute nicht liefern **kann** (zweimal FATAL) und dass meine Nachrechnung ueber die deklarierte enge Menge `943 / 191 / 21066` ergibt. Ob die Differenz aus einem frueheren Dateibestand, einer Handmessung oder einer anderen Ausschlussliste stammt, ist **nicht entschieden**. Der Befund lautet "nicht reproduzierbar", **nicht** "falsch".
3. **Ob `18a0bdf3` (die zweite Fassung des Paritaets-Pakets) untergehen kann.** `3ccbc501` ist Vorfahr von `origin/development`, `18a0bdf3` **nicht** -- die beiden Commits tragen dieselbe Botschaft. Ich konnte nicht klaeren, ob `18a0bdf3` und `74c1e780` nur lokale Cherry-Pick-Zwillinge sind oder Arbeit tragen, die auf `origin` fehlt. **Vor dem naechsten Aufraeumen zu pruefen** (`git range-diff 3ccbc501...18a0bdf3`).
4. **Die Entlastung E-f (super-Abdeckung `Luecke 0`, 144 Tests)** habe ich **nicht** nachgemessen -- sie braucht ein Configure des super-Testbaums, das in einer read-only-Runde nicht vertretbar ist. Sie bleibt `[BERICHT]`.

---
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)

### [w3azi1rhl.json] 164
GEGENSTAND: ROH: Vorschlag zur Einordnung im Checkheft
ORT: measure.hpp:38 | test_measurement_buffer.cpp:131 | 19e15920
SOLL/FIX: ### Vorschlag zur Einordnung im Checkheft

- **I-1** und das `.in`-Nebenstueck: neuer Eintrag in **Kapitel IV** (zwei Quellen), Handlung als Erweiterung von **D-3** (`.sh` + `.hpp.in` in den ce-Scope; `--seit-basis` in die ce-Fassung backporten; die CI-Zeile in `test:coverage-guard` von `${_ce_base}..HEAD` auf `--seit-basis` umstellen) -- **T1**, weil es die R-2-Heilung erst wirksam macht.
- **I-2**: neuer Eintrag in **Kapitel II** (stille Wachen), Handlung: `--bestand` Gitlink- und Quoting-fest machen (`git ls-files -z` + `160000`-Filter), Zahl im CI-Kommentar durch eine reproduzierbare ersetzen oder streichen -- **T3**.
- **I-3**: Fortschreibung von **S-1/S-2/S-3** mit dem heutigen Stand; die Rangfolge aus Z-2 gilt unveraendert -- **sofort**.
- **I-4**: Zahlenkorrektur in **Z-8/C-1**, C-1(a) auf `[x]` mit `19e15920` -- Buchhaltung.
- **I-5**: Erweiterung von **F-3** um `measure.hpp:38` **samt** `test_measurement_buffer.cpp:131` (beide zusammen, sonst faellt der Test) -- **T4**.
- **I-6**: **Z-7 Restposten (a) auf `[x]`** mit der obigen Messung; Restposten (b) (obsolete J-3-Pflicht-Reihenfolge in mindestens vier Dokumenten) bleibt offen; neuer Praeventions-Posten "Katalog-Codegen an dieselbe Registry-Invariante haengen wie den Paper-Codegen" -- **T3**.
STATUS LT. QUELLE: offen (Roh-Fund, Verifikations-Status s. K-/N-/Listen-Eintraege oben)
ABHAENGIGKEIT/FLAECHE: vom Verifikations-Schritt konsolidiert (Dedup dort)


## QUELLE w2mylldp8.json -- WELLENPLAN-ENDFASSUNG-v2-Erzeugung (08.08.). result: 19/19 Schaerfungs-Auftraege, 212 Posten geschaerft, Summe 850 h, 167 Querbefunde, 3 Wellendesign-Entwuerfe (kritische Pfade 36/41/43 Posten). Das 'dokument' IST der als docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md gelandete Plan (Stand VOR par.13-par.17-Nachtraegen). Extraktion: alle Defekt-Posten D1-D5, v1-Formel-Korrekturen, Was-faellt, Owner-Fragen OV, Risiken R-1..R-9, Annahmen, Kurzfassung; Struktur-Paragraphen als Bloecke.

### [w2mylldp8.json] 001
GEGENSTAND: Workflow-Bilanz: 5 Defekte + 103 Luecken + 39 Regressionen + 20 Einwaende als Eingang; 212 geschaerfte Posten / 850 h aus 19/19 Auftraegen; 3 unabhaengige Wellendesigns (Fable 5 max)
ORT: unbekannt
SOLL/FIX: Fable 5 xhigh ueber alle Punkte ab den Regressionen: 5 Defekte, 103 Luecken, 39 Regressionen, 20 Einwaende.
19 Schaerfungs-Auftraege (5 Defekte + 6 Luecken-Gruppen + 4 Regressions-Gruppen + 4 Linsen).
defekt-4: 7 geschaerfte Posten
defekt-5: 8 geschaerfte Posten
regressionen-4: 10 geschaerfte Posten
einwand-vollstaendigkeit: 8 geschaerfte Posten
defekt-1: 8 geschaerfte Posten
defekt-2: 7 geschaerfte Posten
defekt-3: 8 geschaerfte Posten
regressionen-1: 10 geschaerfte Posten
regressionen-3: 14 geschaerfte Posten
regressionen-2: 10 geschaerfte Posten
luecken-1: 18 geschaerfte Posten
luecken-4: 17 geschaerfte Posten
luecken-2: 17 geschaerfte Posten
luecken-3: 17 geschaerfte Posten
luecken-6: 17 geschaerfte Posten
einwand-abhaengigkeiten: 5 geschaerfte Posten
luecken-5: 17 geschaerfte Posten
einwand-frist: 8 geschaerfte Posten
einwand-verifikation: 6 geschaerfte Posten
GESCHAERFT: 212 Posten aus 19/19 Auftraegen, Summe 850 h.
167 Querbefunde.
Drei unabhaengige Wellendesigns aus verschiedenen Blickwinkeln, Fable 5 max.
3/3 Entwuerfe. Kritische Pfade: 36, 41, 43 Posten.
STATUS LT. QUELLE: nur-hinweis (Workflow-Quittung)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 002
GEGENSTAND: Plan-v2 par.0: Was diese Fassung aendert (D-Familien nach vorn, 35 Posten; 4 v1-Abnahmeformeln korrigiert; HYBRID zurueck ins Fenster HY-A/B/C; DURCHSTICH als F1-Lieferung; EIN-BLECH-REGEL + ABGABEFAEHIGKEITS-MINIMUM)
ORT: ./configure.sh | experiment_plan_director.hpp:1394 | hybrid/README.md
SOLL/FIX: ## 0. WAS DIESE FASSUNG GEGENUeBER DER VORLAGE AeNDERT

**(1) Die Defekte ruecken von hinten nach vorn.** Die Vorlage fuehrte die Regressionen als Abschnitt 6 mit ~8 gebuchten Wachen-Defekten. Diese Fassung fuehrt **35 Posten in fuenf Familien** als Abschnitt 2, weil sie zwischen uns und jeder belastbaren Messung stehen. Neu hinzugekommen (in v1 unverbucht):

| neu | Kern | warum es die Vorlage verschiebt |
|---|---|---|
| **D1a** | `./configure.sh && make` baut **0 von 53** Permutations-DLLs (ninja-Ziele 6329->6749 erst nach 2. Configure) | der gemeldete Test-Zaehl-Defekt ist ein **Produkt**-Defekt: `make install` liefert die Kern-Artefaktklasse nicht |
| **D1b/D1c** | CI `test:unit` faehrt **429 von 431**; die Abdeckungs-Wache blieb **GRUeN gegen den korrekten 431-Baum** (`guard431.log`, gefahren) | die Vorlagen-Heilung ##06 (STATUS_OUT zaehlen) heilt das nachweislich **nicht** -- die Wache prueft Selektor-, nie Registrierungs-Abdeckung |
| **D2-G1** | **27 gtest-Faelle in JEDEM Baum unsichtbar** seit 79 Tagen (`enable_testing()` bei `CMakeLists.txt:717` NACH `add_subdirectory(libs/cache_engine)` `:674`) -- darunter die **Welch-Wachen** der Signifikanz-Aussage | faellt durch jede geplante Heilung hindurch: kein STATUS_OUT-Block existiert dafuer |
| **D3-4/D3-5** | der **lebende** CEB-emittierte Mess-Weg hat **kein Ausgabe-Gate** und traegt `allow_failure: true` (`experiment_plan_director.hpp:1394`, 1 von 1 in der Datei); `[MESS-TESTAT]` wird **unbedingt** gedruckt, auch nach `[FEHLER-TESTAT]` | `allow_failure` kam in v1 + allen drei JSON-Bestaenden **0-mal** vor -- groesster unverbuchter Einzelbefund; v1 haertete nur den deprecateden statischen Weg |
| **D3-7/D3-8** | drei Treiber-Modi liefern planmaessig exit 0 ohne Messwert und hinterlassen **dieselbe Kopfzeilen-CSV** wie ein kaputter Lauf; `GIT_CLEAN_FLAGS -e Code/measure_out` laesst Altbestand ueber Pipeline-Grenzen leben | ohne Lauf-Marker und Frische-Kennung ist jedes Inhalts-Gate zu scharf **oder** zu stumpf |
| **D4a-D4f** | Welch (`se<=0` -> `valid=true, p=1.0`), MWU (`valid` **vor** dem Guard), Bonferroni (ungetestete Hypothesen im Nenner, `win_rate` verduennt), `success = !empty`, f15 ohne Tote-Proben-Guard, Break-Even "nicht bestimmbar" == "keiner" (byte-gleich leerer Vektor) | die **Headline-Zahl der Arbeit** kann heute durch nie gemessene Zellen kippen, ohne dass es der Zahl anzusehen ist |
| **D5-2-D5-5** | **fuenf** Median-Implementierungen, **drei** Antworten auf {10,20,30,40} (20/25/30); Sieger-Kuerung und LaTeX-Tabelle rechnen verschieden; `delete_p99_ns` existiert **0-mal**; HDR = sechstes Verfahren, unverdrahtet, verschluckt 0-ns-Proben | v1 fuehrte den Median als Nebensatz und REV-DATA-12 als "zwei geloeschte Werkzeuge" -- **beide leben in super**, letzter Commit 6d837e7d gestern (D5-3) |

**(2) Korrekturen an der Vorlage selbst** (v1 haette, woertlich gebaut, viermal die eigene Fehlerklasse erzeugt):

- **##26-Formel** "N == M" ist bei N==0 **gruen mit Nenner 0** -- korrigiert auf `N >= 1 UND M == N UND datenzeilen_gesamt >= 1` (V-1-Verstoss in der eigenen Abnahmezeile, v1:593 gegen v1:555).
- **##06-Formel** "fuer jeden der 5 STATUS_OUT ein FOUND" waere ein **Dauer-Rot**: 2 der 5 Bloecke liegen hinter `if(COMDARE_PRUEFLING_INCLUDE_DIRS)` und werden in jedem CI-Baum **nicht erreicht** (weder FOUND noch SKIPPED). Korrigiert auf Bedingungs-Tabelle: erfuellt ODER Allowlist mit Begruendung (D2-G4); zudem sind es **15 bedingte Registrierungen in 8 Klassen**, nicht 5 -- STATUS_OUT deckt 20 %.
- **##36-Koeder** kann den Zielfall nicht sehen: eine Null-Fenster-Zelle liefert im ungeheillten Gate `reruns=0` -- exakt die Zahl, die laut Koeder "nicht verdrahtet" bedeutet. Korrigiert auf **zwei degenerierte Zellarten** (Null-Fenster -> "unbestimmbar", echte Streuung -> Reruns), beide Zahlen getrennt.
- **##04/##05** waren Abnahmezeilen **ohne Bau-Paket** -- die Vorlage verifizierte den `make check`-Defekt und heilte ihn nirgends. **V-6 gilt jetzt beidseitig** (Paket ohne Abnahmezeile UND Abnahmezeile ohne Paket = nicht abgenommen); D1/D1a schliessen die Luecke.
- **##57**-Koeder ("Datensatz mit nur einer Binary") beisst aus dem falschen Grund und waere auch nach einer Heilung gruen -- der Rueckgabetyp kann "nicht bestimmbar" von "bestimmt: keiner" heute gar nicht unterscheiden (D4f); Abnahme auf den Statusraum umgestellt.
- **Einwand-36-Erklaerung** ("610 Tests = Folge von EXCLUDE_FROM_ALL") wird **nicht festgeschrieben**: super `Code/CMakeLists.txt:278 enable_testing()` steht ebenfalls NACH den `add_subdirectory`-Aufrufen (:211/:243) -- dieselbe D2-G1-Konstellation; welche Ursache traegt, entscheidet die Messung in D1g, nicht der Plan.

**(3) HYBRID kehrt ins Fenster zurueck.** v1 fuehrte Hybrid-Bau als Streichkaskade Position 2 / W7. Der Owner-KERN 08.08. ("Volles GO. Alles Pflicht.", Gattung `HEURISTIK-ADAPTER`, Genus `Function-Interface-Reroute`, 4. Mess-Ebene DAZWISCHEN) verbietet das. Der Widerspruch wird **zerlegt statt glattgerechnet**, entlang des aelteren, als bindend markierten Owner-E1-Designs (`hybrid/README.md`: "kein eigener ABI-Schritt", "Erster Meilenstein = F8-Minimal-DoD, genau 1 Standard-Dock", Router = Break-Even-Router, der Messkurven **konsumiert**): **HY-A** (Struktur+Dock+Achse+Parser) in die Freeze-Woche, **HY-B** (Overhead-Messung mit Stub-Heuristik, eigene kleine Teilmatrix) in die Mess-Welle, **HY-C** (Router aus echten Kurven) in die Auswertung. **Preis, offen ausgewiesen:** der W2-S-E-Restbau (##40: T-06...T-14, W-03, W-08, A14, A10) faellt nach W7 (Abschnitt 7).

**(4) Reihenfolge-Umkehrungen:** W0a waechst von 0,5 auf **2,5 Tage** (13 statt 2 Pakete -- V-6 erzwingt den ehrlichen Nenner); **D5-1** (Perzentil-Kanon) rueckt aus W1 in die W0a-Lokalspur vor, weil er als einziger Posten den Messtermin bewegt; **D2-G4 vor D2** (Textkorrektur vor Wachen-Bau, sonst entsteht ein Dauer-Rot); **D1e vor D1b** (sonst macht die Heilung `test:unit` rot -- `ninja -t query comdare_tests`: 424 Test-Inputs, `comdare_f15_compare_cli` fehlt); **D3-7 vor allen D3-Gates** (Modus-Marker zuerst). Neu: der **DURCHSTICH** -- F1 (14.08.) liefert nicht mehr "Anschluss an beiden Enden", sondern **einen echten, frisch gemessenen Mini-Messwert als Tabellenzeile im Thesis-Submodul**, durch die komplette Kette CSV -> persist -> xlsx -> `anhang:forward` -> PDF.

**(5) Messfenster:** Zielbild **Sa 29.08. 06:00 - Do 03.09.** (5,75 Maschinentage, ETA-Deckel 4,5 Tage + 30 h Marge), Rueckschrieb Fr 04.09. = F4; GO-Vorabzusage beim Owner (OV-15). Rueckfall Mo 31.08. kostet 1:1 Fenster.

**(6) Zwei neue Betriebsregeln:** die **EIN-BLECH-REGEL** (prod1 ist Runner id=16 UND Arbeitsmaschine: maximal EIN Paket mit Pipeline-gruen-Abnahme zur Zeit, der zweite Slot nur fuer rein lokale Abnahmen; waehrend Bau und Kampagne exakt 1) und das **ABGABEFAeHIGKEITS-MINIMUM** (ab F1 existiert zu jedem Zeitpunkt eine ehrliche kleine Abgabe; jeder Freitag steht allein, auch wenn danach alles abbricht).

**Wellen-Nummern gegenueber v1 verschoben:**

| v1 | v2 | Inhalt v2 |
|---|---|---|
| W-1 | **W-1** | unveraendert Landung + jetzt Bauweg-Heilung (D1/D1a/D1d) |
| W0a (0,5 T) | **W0a** (2,5 T) | Waage: D1/D2-Familien + D5-1-Lokalspur |
| W1 (10.-14.08.) | **W0b** (12.-14.08., F1) | Naehte + Durchstich (D3-Familie + Transport ##20-##25) |
| W2 (17.-21.08.) | **W1** (17.-21.08., F2 = Freeze) | Statistik-Glied (D4), Menge, par.59-SCHEMA, HY-A, Entwicklung der Bump-Pakete |
| W3 (24.-28.08.) | **W2** (24.-28.08., F3) | EIN Bump-Buendel (Mo) -> Anker/Kalibrierung (Di) -> Bau (Mi-Do) -> GO-Vorlage (Fr) |
| W4 | **W3-MESS** (Sa 29.08.-Fr 04.09., F4) | + HY-B |
| W5 | **W4-AUSWERTUNG** (07.-11.09., F5) | + HY-C |
| W6 | **W5-SICHERUNG** (12.-15.09.) | unveraendert |

Die Paketnummern ##01-##62 der v1 bleiben gueltig und werden weiterverwendet; D-Posten und HY-Posten kommen als eigene IDs dazu.

---


STATUS LT. QUELLE: nur-hinweis (Plan-Text, gelandet)
ABHAENGIGKEIT/FLAECHE: Owner-KERN 08.08. 'Volles GO. Alles Pflicht.'

### [w2mylldp8.json] 003
GEGENSTAND: v1-Abnahmeformel-Korrektur: ##26-Formel
ORT: unbekannt
SOLL/FIX: **##26-Formel** "N == M" ist bei N==0 **gruen mit Nenner 0** -- korrigiert auf `N >= 1 UND M == N UND datenzeilen_gesamt >= 1` (V-1-Verstoss in der eigenen Abnahmezeile, v1:593 gegen v1:555).
STATUS LT. QUELLE: behoben im Plan v2 (Formel korrigiert)
ABHAENGIGKEIT/FLAECHE: Verifikationsvertrag; Dauer-Rot/Dauer-Gruen-Gefahr

### [w2mylldp8.json] 004
GEGENSTAND: v1-Abnahmeformel-Korrektur: ##06-Formel
ORT: unbekannt
SOLL/FIX: **##06-Formel** "fuer jeden der 5 STATUS_OUT ein FOUND" waere ein **Dauer-Rot**: 2 der 5 Bloecke liegen hinter `if(COMDARE_PRUEFLING_INCLUDE_DIRS)` und werden in jedem CI-Baum **nicht erreicht** (weder FOUND noch SKIPPED). Korrigiert auf Bedingungs-Tabelle: erfuellt ODER Allowlist mit Begruendung (D2-G4); zudem sind es **15 bedingte Registrierungen in 8 Klassen**, nicht 5 -- STATUS_OUT deckt 20 %.
STATUS LT. QUELLE: behoben im Plan v2 (Formel korrigiert)
ABHAENGIGKEIT/FLAECHE: Verifikationsvertrag; Dauer-Rot/Dauer-Gruen-Gefahr

### [w2mylldp8.json] 005
GEGENSTAND: v1-Abnahmeformel-Korrektur: ##36-Koeder
ORT: unbekannt
SOLL/FIX: **##36-Koeder** kann den Zielfall nicht sehen: eine Null-Fenster-Zelle liefert im ungeheillten Gate `reruns=0` -- exakt die Zahl, die laut Koeder "nicht verdrahtet" bedeutet. Korrigiert auf **zwei degenerierte Zellarten** (Null-Fenster -> "unbestimmbar", echte Streuung -> Reruns), beide Zahlen getrennt.
STATUS LT. QUELLE: behoben im Plan v2 (Formel korrigiert)
ABHAENGIGKEIT/FLAECHE: Verifikationsvertrag; Dauer-Rot/Dauer-Gruen-Gefahr

### [w2mylldp8.json] 006
GEGENSTAND: v1-Abnahmeformel-Korrektur: ##04/##05
ORT: unbekannt
SOLL/FIX: **##04/##05** waren Abnahmezeilen **ohne Bau-Paket** -- die Vorlage verifizierte den `make check`-Defekt und heilte ihn nirgends. **V-6 gilt jetzt beidseitig** (Paket ohne Abnahmezeile UND Abnahmezeile ohne Paket = nicht abgenommen); D1/D1a schliessen die Luecke.
STATUS LT. QUELLE: behoben im Plan v2 (Formel korrigiert)
ABHAENGIGKEIT/FLAECHE: Verifikationsvertrag; Dauer-Rot/Dauer-Gruen-Gefahr

### [w2mylldp8.json] 007
GEGENSTAND: v1-Abnahmeformel-Korrektur: ##57
ORT: unbekannt
SOLL/FIX: **##57**-Koeder ("Datensatz mit nur einer Binary") beisst aus dem falschen Grund und waere auch nach einer Heilung gruen -- der Rueckgabetyp kann "nicht bestimmbar" von "bestimmt: keiner" heute gar nicht unterscheiden (D4f); Abnahme auf den Statusraum umgestellt.
STATUS LT. QUELLE: behoben im Plan v2 (Formel korrigiert)
ABHAENGIGKEIT/FLAECHE: Verifikationsvertrag; Dauer-Rot/Dauer-Gruen-Gefahr

### [w2mylldp8.json] 008
GEGENSTAND: v1-Abnahmeformel-Korrektur: Einwand-36-Erklaerung
ORT: unbekannt
SOLL/FIX: **Einwand-36-Erklaerung** ("610 Tests = Folge von EXCLUDE_FROM_ALL") wird **nicht festgeschrieben**: super `Code/CMakeLists.txt:278 enable_testing()` steht ebenfalls NACH den `add_subdirectory`-Aufrufen (:211/:243) -- dieselbe D2-G1-Konstellation; welche Ursache traegt, entscheidet die Messung in D1g, nicht der Plan.
STATUS LT. QUELLE: behoben im Plan v2 (Formel korrigiert)
ABHAENGIGKEIT/FLAECHE: Verifikationsvertrag; Dauer-Rot/Dauer-Gruen-Gefahr

### [w2mylldp8.json] 009
GEGENSTAND: Defekt-Familie D1 -- Der Bauweg luegt ueber seinen eigenen Umfang (8 Posten, 19,5 h)
ORT: unbekannt
SOLL/FIX: ### D1 -- Der Bauweg luegt ueber seinen eigenen Umfang (8 Posten, 19,5 h)

`make check` faehrt 427 statt 431 (fehlendes Reconfigure; **zwei** Gate-Familien: `comdare_run_anatomy_codegen_tool` 4x UND die eigenstaendige 2-Pass-Maschine `comdare_run_adhoc_emitter`). Der Fix ist eine Makefile-Zeile -- teuer sind die Geschwister.
STATUS LT. QUELLE: offen (Plan-Stand 08.08.; Vollzug je Posten spaeter, s. wtk6lmhln/WP-Eintraege)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 010
GEGENSTAND: D1: Reconfigure in `check`; Zahlen 427/429/431 gemessen, beide Gate-Familien benannt
ORT: unbekannt
SOLL/FIX: Kern: Reconfigure in `check`; Zahlen 427/429/431 gemessen, beide Gate-Familien benannt | Aufwand: 3 h | Ziel-Welle: W-1 | Reihenfolge-Zwang: mit D1a in EINEM Commit
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W-1; Zwang: mit D1a in EINEM Commit

### [w2mylldp8.json] 011
GEGENSTAND: D1a: `make` (all) baut **0/53** Permutations-DLLs -- Produkt-Problem, `make install` unvollstaendig; 2-Pass-Bau ist hausuebliche Praxis (`base-pipel
ORT: base-pipeline.yml:470-477
SOLL/FIX: Kern: `make` (all) baut **0/53** Permutations-DLLs -- Produkt-Problem, `make install` unvollstaendig; 2-Pass-Bau ist hausuebliche Praxis (`base-pipeline.yml:470-477`) | Aufwand: 2,5 h | Ziel-Welle: W-1 | Reihenfolge-Zwang: nach D1, gleiche Datei
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W-1; Zwang: nach D1, gleiche Datei

### [w2mylldp8.json] 012
GEGENSTAND: D1b: CI-Prebuild kennt `comdare_adhoc_emitter_cli` nicht -> 2 von 431 Tests laufen in **keinem** Job (`.gitlab-ci.yml:637`)
ORT: .gitlab-ci.yml:637
SOLL/FIX: Kern: CI-Prebuild kennt `comdare_adhoc_emitter_cli` nicht -> 2 von 431 Tests laufen in **keinem** Job (`.gitlab-ci.yml:637`) | Aufwand: 1,5 h | Ziel-Welle: W0a | Reihenfolge-Zwang: **D1e ZWINGEND vorher**
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W0a; Zwang: **D1e ZWINGEND vorher**

### [w2mylldp8.json] 013
GEGENSTAND: D1c: Abdeckungs-Wache bleibt gruen gegen die korrekte Inventur (`guard431.log`) -> zweite Achse: Job-Baum-Inventur aus **fremdem** Artefakt, N!=M = 
ORT: unbekannt
SOLL/FIX: Kern: Abdeckungs-Wache bleibt gruen gegen die korrekte Inventur (`guard431.log`) -> zweite Achse: Job-Baum-Inventur aus **fremdem** Artefakt, N!=M = rot; fail-closed | Aufwand: 5 h | Ziel-Welle: W0a | Reihenfolge-Zwang: nach D1b, D1f
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W0a; Zwang: nach D1b, D1f

### [w2mylldp8.json] 014
GEGENSTAND: D1d: Doku-Widerspruch "404 statt 406" (Guard-Kopf) vs. "427 gegen 431" (super-Makefile) -- der falsche Kommentar hat den unvollstaendigen CI-Job **
ORT: unbekannt
SOLL/FIX: Kern: Doku-Widerspruch "404 statt 406" (Guard-Kopf) vs. "427 gegen 431" (super-Makefile) -- der falsche Kommentar hat den unvollstaendigen CI-Job **erzeugt**; Zahlen kuenftig mit Datum+Kommando | Aufwand: 0,5 h | Ziel-Welle: W-1 | Reihenfolge-Zwang: nach D1-Messung (K13)
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W-1; Zwang: nach D1-Messung (K13)

### [w2mylldp8.json] 015
GEGENSTAND: D1e: `f15_compare_cli_smoke`: Binary nicht in der `comdare_tests`-Baukante (424 Inputs), `PASS_REGULAR_EXPRESSION` haengt den Exit-Code ab (11 Feh
ORT: unbekannt
SOLL/FIX: Kern: `f15_compare_cli_smoke`: Binary nicht in der `comdare_tests`-Baukante (424 Inputs), `PASS_REGULAR_EXPRESSION` haengt den Exit-Code ab (11 Fehlerausgaenge unsichtbar), Kommentar beschreibt einen anderen Test, kein TIMEOUT | Aufwand: 2 h | Ziel-Welle: W0a | Reihenfolge-Zwang: vor D1b
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W0a; Zwang: vor D1b

### [w2mylldp8.json] 016
GEGENSTAND: D1f: 5 STATUS_OUT-Bloecke, **drei** Zustaende (nicht-erreicht/SKIPPED/ERROR/FOUND); `message(WARNING)` bei rc!=0 = stiller ERROR-Pfad -> FATAL, aber 
ORT: unbekannt
SOLL/FIX: Kern: 5 STATUS_OUT-Bloecke, **drei** Zustaende (nicht-erreicht/SKIPPED/ERROR/FOUND); `message(WARNING)` bei rc!=0 = stiller ERROR-Pfad -> FATAL, aber "nicht gebaut" im super-Sub-Build tolerierbar | Aufwand: 3 h | Ziel-Welle: W0a | Reihenfolge-Zwang: nach D1
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W0a; Zwang: nach D1

### [w2mylldp8.json] 017
GEGENSTAND: D1g: super: Reconfigure vorhanden, aber strukturell wirkungslos (`EXCLUDE_FROM_ALL`, `Code/CMakeLists.txt:213`); 610/186 = ungemessene Agent-Beha
ORT: unbekannt
SOLL/FIX: Kern: super: Reconfigure vorhanden, aber strukturell wirkungslos (`EXCLUDE_FROM_ALL`, `Code/CMakeLists.txt:213`); 610/186 = ungemessene Agent-Behauptung -> EIN Configure-Paar entscheidet; Nenner 186/610 in die Lauf-Ausgabe | Aufwand: 1,5 h | Ziel-Welle: W0a | Reihenfolge-Zwang: nach D1
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W0a; Zwang: nach D1

### [w2mylldp8.json] 018
GEGENSTAND: Tragende Abnahme der Familie D1
ORT: ./configure.sh
SOLL/FIX: **Tragende Abnahme:** frischer Baum, baremetal: `./configure.sh && make && make check` druckt literal `... out of 431`; **vorher 427 protokolliert** (V-4); nach `make` allein: `find generated -name 'comdare_anatomy_perm_*.so' | wc -l` == 53 (heute 0, beide Zahlen). Koeder (gewuerfelt): `add_test`-Koeder `qzoelw42uqoszpy` NUR im R5.G-Zweig + `g4nhmvh652vfr4a` im R5.I-Zweig -- vor der Heilung unsichtbar-gruen, danach rot mit Namen; beide Rot-Laeufe ins Paket.
STATUS LT. QUELLE: offen (Abnahme-SOLL mit Koedern)
ABHAENGIGKEIT/FLAECHE: Koeder-Pflicht K13, Rot-zuerst

### [w2mylldp8.json] 019
GEGENSTAND: Defekt-Familie D2 -- Die Wachen zaehlen sich selbst (7 Posten, 11 h)
ORT: cmake/gtest_setup.cmake:56-82
SOLL/FIX: ### D2 -- Die Wachen zaehlen sich selbst (7 Posten, 11 h)

Nenner der Abdeckungs-Wache = eigene Inventur; keine Untergrenze (`:87` prueft nur `> 0`); der Partitions-Beleg druckt `==` statt zu vergleichen; `declared:VAR` fail-open; und eine ganze Testklasse (gtest via `gtest_discover_tests`, einzige Stelle im Repo, von `cmake/gtest_setup.cmake:56-82` selbst als unbrauchbar verworfen) liegt **ausserhalb** des `ctest -N`-Wahrheitsbegriffs.
STATUS LT. QUELLE: offen (Plan-Stand 08.08.; Vollzug je Posten spaeter, s. wtk6lmhln/WP-Eintraege)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 020
GEGENSTAND: D2-G4: **Textkorrektur der Abnahme ##06 VOR dem Bau**: 15 bedingte Registrierungen in 8 Klassen, davon 2 unerreichbar in jeder CI; Formel "erfuellt 
ORT: unbekannt
SOLL/FIX: Kern: **Textkorrektur der Abnahme ##06 VOR dem Bau**: 15 bedingte Registrierungen in 8 Klassen, davon 2 unerreichbar in jeder CI; Formel "erfuellt ODER Allowlist mit Begruendung"; Zaehl-Skript als unabhaengige Quelle | Aufwand: 1 h | Ziel-Welle: W0a | Reihenfolge-Zwang: zuerst
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W0a; Zwang: zuerst

### [w2mylldp8.json] 021
GEGENSTAND: D2: Nenner-Untergrenze (`ci_test_inventory_floor.txt`, eigener Commit), Emitter in die covguard-Prebuild-Zeile, Skip-Allowlist, Configure-Log al
ORT: unbekannt
SOLL/FIX: Kern: Nenner-Untergrenze (`ci_test_inventory_floor.txt`, eigener Commit), Emitter in die covguard-Prebuild-Zeile, Skip-Allowlist, Configure-Log als Artefakt (heute `paths: []`) | Aufwand: 3,5 h | Ziel-Welle: W0a | Reihenfolge-Zwang: nach D2-G4
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W0a; Zwang: nach D2-G4

### [w2mylldp8.json] 022
GEGENSTAND: D2-G1: 27 unsichtbare gtest-Faelle -> zwei `add_test` nach dem dokumentierten Muster, in `COMDARE_TEST_TARGETS`; Erstlauf ehrlich buchen (`AllFourtee
ORT: unbekannt
SOLL/FIX: Kern: 27 unsichtbare gtest-Faelle -> zwei `add_test` nach dem dokumentierten Muster, in `COMDARE_TEST_TARGETS`; Erstlauf ehrlich buchen (`AllFourteenAxesPopulated` bei heute 22/18 Achsen = erwarteter Fund, kein `allow_failure`) | Aufwand: 2 h | Ziel-Welle: W0a | Reihenfolge-Zwang: parallel moeglich
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W0a; Zwang: parallel moeglich

### [w2mylldp8.json] 023
GEGENSTAND: D2-G2: ohne dieses Paket macht D2 die Hauptpipeline rot (Registrierung ohne Bau); TIMEOUT nach gemessener Zeit x4; Exit-Code via `cmake -P`-Wrapper
ORT: registry_roundtrip.cmake
SOLL/FIX: Kern: ohne dieses Paket macht D2 die Hauptpipeline rot (Registrierung ohne Bau); TIMEOUT nach gemessener Zeit x4; Exit-Code via `cmake -P`-Wrapper (Vorbild `registry_roundtrip.cmake`) | Aufwand: 1,5 h | Ziel-Welle: W0a | Reihenfolge-Zwang: im D2-Bogen
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W0a; Zwang: im D2-Bogen

### [w2mylldp8.json] 024
GEGENSTAND: D2-G3: drei Gruen-ohne-Vergleich-Wege: Untergrenze, `==`-Druck -> echter Vergleich mit Exit, `2>/dev/null` faellt (K11: ctest-Ausgabe in Datei, dann r
ORT: unbekannt
SOLL/FIX: Kern: drei Gruen-ohne-Vergleich-Wege: Untergrenze, `==`-Druck -> echter Vergleich mit Exit, `2>/dev/null` faellt (K11: ctest-Ausgabe in Datei, dann rc), `declared:VAR` -> gezaehlte "ungepruefte Gates" | Aufwand: 1,5 h | Ziel-Welle: W0a | Reihenfolge-Zwang: mit D2
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W0a; Zwang: mit D2

### [w2mylldp8.json] 025
GEGENSTAND: D2-G5: 6 von 428 Tests registrieren sich nur auf AVX-512-Hosts -> Host-Klassen-Bericht (3 Zahlen, Host-Kennung), zweistufige Untergrenze
ORT: unbekannt
SOLL/FIX: Kern: 6 von 428 Tests registrieren sich nur auf AVX-512-Hosts -> Host-Klassen-Bericht (3 Zahlen, Host-Kennung), zweistufige Untergrenze | Aufwand: 1 h | Ziel-Welle: W0b | Reihenfolge-Zwang: nach D2/D2-G4
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W0b; Zwang: nach D2/D2-G4

### [w2mylldp8.json] 026
GEGENSTAND: D2-G6: Registry-Roundtrip-Gates haengen an Datei-Existenz, Kommentar verspricht die stille Abschaltung als Merkmal -> Pflicht-Erwartung + Kommentar k
ORT: unbekannt
SOLL/FIX: Kern: Registry-Roundtrip-Gates haengen an Datei-Existenz, Kommentar verspricht die stille Abschaltung als Merkmal -> Pflicht-Erwartung + Kommentar korrigieren; **Standard-Bissprobe** der Wache (stash-Koeder, billig, rueckstellbar) | Aufwand: 0,5 h | Ziel-Welle: W0a | Reihenfolge-Zwang: Anhang zu D2
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W0a; Zwang: Anhang zu D2

### [w2mylldp8.json] 027
GEGENSTAND: Tragende Abnahme der Familie D2
ORT: unbekannt
SOLL/FIX: **Tragende Abnahme:** die Wache druckt DREI unabhaengige Zahlen (eigene Inventur N / Job-Baum-Inventur M aus dem Artefakt eines **anderen** Jobs / Gates FOUND G von G_deklariert), N!=M => Exit!=0; Zahl-Koeder "345" im gefaelschten Artefakt -> rot; Schrumpf-Koeder (N per `shuf` gewaehlte Tests in `if(FALSE)`) -> rot mit Zahl; **unmanipulierter Lauf bleibt gruen** (Gegenkoeder gegen Dauer-Rot). `ctest -N` zaehlt nach D2-G1 **+2** (heute 0 Treffer fuer `test_commands|test_engine_adapters`).
STATUS LT. QUELLE: offen (Abnahme-SOLL mit Koedern)
ABHAENGIGKEIT/FLAECHE: Koeder-Pflicht K13, Rot-zuerst

### [w2mylldp8.json] 028
GEGENSTAND: Defekt-Familie D3 -- Ein leeres Messfenster ist heute gruen (8 Posten, 20 h)
ORT: unbekannt
SOLL/FIX: ### D3 -- Ein leeres Messfenster ist heute gruen (8 Posten, 20 h)

Reproduziert: Kopfzeilen-CSV und 0-Byte-CSV bestehen das golden-320-Gate (rc=0). Die Kopfzeile ist Bauart (`trunc` + unbedingter Header vor dem ersten Pass). Der Autor kannte die richtige Form -- einen Tag spaeter, am Wegwerf-Objekt (WIDE-Aggregat), im selben Commit wie der Datei-Zaehler des Rueckschriebs.
STATUS LT. QUELLE: offen (Plan-Stand 08.08.; Vollzug je Posten spaeter, s. wtk6lmhln/WP-Eintraege)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 029
GEGENSTAND: D3-7: **Wurzel zuerst:** Lauf-Marker neben jeder CSV (`modus/measured/resumed/provisioned/csv_ok`, aus denselben Feldern wie der stdout-Bericht); 
ORT: unbekannt
SOLL/FIX: Kern: **Wurzel zuerst:** Lauf-Marker neben jeder CSV (`modus/measured/resumed/provisioned/csv_ok`, aus denselben Feldern wie der stdout-Bericht); fehlender Marker = rot; auch `prune_only` schreibt einen | Aufwand: 3 h | Ziel-Welle: W0b | Reihenfolge-Zwang: vor allen D3-Gates
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W0b; Zwang: vor allen D3-Gates

### [w2mylldp8.json] 030
GEGENSTAND: D3-1: `ci/measure_csv_gate.sh`: drei Zahlen (`csv_gesamt/csv_mit_datenzeile/datenzeilen_gesamt`), `awk` statt `wc -l`, N==0 = rot; rot NUR bei `mo
ORT: ci/measure_csv_gate.sh
SOLL/FIX: Kern: `ci/measure_csv_gate.sh`: drei Zahlen (`csv_gesamt/csv_mit_datenzeile/datenzeilen_gesamt`), `awk` statt `wc -l`, N==0 = rot; rot NUR bei `modus=voll` und Z==0 | Aufwand: 3,5 h | Ziel-Welle: W0b | Reihenfolge-Zwang: nach D3-7
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W0b; Zwang: nach D3-7

### [w2mylldp8.json] 031
GEGENSTAND: D3-2: derselbe Helfer an der deprecateden smoke-Stelle (3 Zeilen); danach `grep -c 'test -n "$(find'` == 0 (heute 2)
ORT: unbekannt
SOLL/FIX: Kern: derselbe Helfer an der deprecateden smoke-Stelle (3 Zeilen); danach `grep -c 'test -n "$(find'` == 0 (heute 2) | Aufwand: 0,5 h | Ziel-Welle: W0b | Reihenfolge-Zwang: nach D3-1
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W0b; Zwang: nach D3-1

### [w2mylldp8.json] 032
GEGENSTAND: D3-3: persist zaehlt **Zeilen** statt Dateien; leeres Fenster = **KEIN Commit** (Beweis am Git-Zustand, nicht am Log); `datenzeilen_gesamt` in PROV
ORT: unbekannt
SOLL/FIX: Kern: persist zaehlt **Zeilen** statt Dateien; leeres Fenster = **KEIN Commit** (Beweis am Git-Zustand, nicht am Log); `datenzeilen_gesamt` in PROVENANCE; :1038-Warnung wird echter Abbruch | Aufwand: 2 h | Ziel-Welle: W0b | Reihenfolge-Zwang: nach D3-1
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W0b; Zwang: nach D3-1

### [w2mylldp8.json] 033
GEGENSTAND: D3-4: der **lebende** Mess-Job bekommt das Inhalts-Gate je Batch; `allow_failure` = Owner-Entscheid (OV-16), bis dahin maschinell findbare Klammer
ORT: unbekannt
SOLL/FIX: Kern: der **lebende** Mess-Job bekommt das Inhalts-Gate je Batch; `allow_failure` = Owner-Entscheid (OV-16), bis dahin maschinell findbare Klammer-Zeile; Emissionsblock ist byte-fixiert (Unit-Test-Literale) -> Handarbeit | Aufwand: 5 h | Ziel-Welle: W0b | Reihenfolge-Zwang: nach D3-1/D3-7; Owner bis Mi 12.08.
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W0b; Zwang: nach D3-1/D3-7; Owner bis Mi 12.08.

### [w2mylldp8.json] 034
GEGENSTAND: D3-5: `[MESS-TESTAT]` in den else-Zweig (heute C+1 Testate bei C Zellen); Batch-Bilanz `A+B==C`; set-e-Sicherheit erhalten
ORT: unbekannt
SOLL/FIX: Kern: `[MESS-TESTAT]` in den else-Zweig (heute C+1 Testate bei C Zellen); Batch-Bilanz `A+B==C`; set-e-Sicherheit erhalten | Aufwand: 1,5 h | Ziel-Welle: W0b | Reihenfolge-Zwang: im D3-4-Bogen
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W0b; Zwang: im D3-4-Bogen

### [w2mylldp8.json] 035
GEGENSTAND: D3-6: `anhang:forward`-Selektor findet **beide** Ablageformen (Produktions-`result.csv` + Archiv-`*.result.csv`, EIN Muster als Variable an 3 Stel
ORT: result.csv | .result.csv
SOLL/FIX: Kern: `anhang:forward`-Selektor findet **beide** Ablageformen (Produktions-`result.csv` + Archiv-`*.result.csv`, EIN Muster als Variable an 3 Stellen); NO-OP nur noch mit Nenner (`laufordner_geprueft/mit_material`) | Aufwand: 2,5 h | Ziel-Welle: W0b | Reihenfolge-Zwang: Owner-Klaerung Konvention (OV-17)
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W0b; Zwang: Owner-Klaerung Konvention (OV-17)

### [w2mylldp8.json] 036
GEGENSTAND: D3-8: Frische-Wache gegen die `GIT_CLEAN_FLAGS`-Ausnahme: Lauf-Kennung = `CI_PIPELINE_ID` (+JOB_ID als Zusatz, Retry-fest); `csv_dieser_lauf` getr
ORT: unbekannt
SOLL/FIX: Kern: Frische-Wache gegen die `GIT_CLEAN_FLAGS`-Ausnahme: Lauf-Kennung = `CI_PIPELINE_ID` (+JOB_ID als Zusatz, Retry-fest); `csv_dieser_lauf` getrennt von `csv_gesamt`; Altbestand **gemeldet, nie geloescht** | Aufwand: 2 h | Ziel-Welle: W0b | Reihenfolge-Zwang: zuletzt; scharf mit `ergebnis:holen` (W2)
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W0b; Zwang: zuletzt; scharf mit `ergebnis:holen` (W2)

### [w2mylldp8.json] 037
GEGENSTAND: Tragende Abnahme der Familie D3
ORT: unbekannt
SOLL/FIX: **Tragende Abnahme:** Fake-Treiber-Doppel am emittierten Job-Rumpf (nur Kopfzeile vs. eine Datenzeile mit gewuerfeltem `$K`): heute BEIDE `FAIL=0` -- nach Heilung 1 rot / 1 gruen, beide Ausgaben literal; persist-Beweis P1/P2 am Git-Zustand (`git status --porcelain measurement/` leer vs. genau eine Datei mit `$K`); Zwei-Lauf-Koeder im selben Verzeichnis (Altzelle `$K1` mit Datenzeile, Neuzelle `$K2` leer) -> rot mit `csv_dieser_lauf=0` und namentlicher Altbestandsliste -- heute meldet das Existenz-Gate hier gruen.
STATUS LT. QUELLE: offen (Abnahme-SOLL mit Koedern)
ABHAENGIGKEIT/FLAECHE: Koeder-Pflicht K13, Rot-zuerst

### [w2mylldp8.json] 038
GEGENSTAND: Defekt-Familie D4 -- Tote Messreihen gelten als gueltig und nicht-signifikant (7 Posten, 12,5 h)
ORT: drift_detector.hpp:69 | welch_t_test.hpp:130 | mann_whitney_u_test.hpp:92 | multi_compare.hpp:75 | f15_compare/main.cpp:486
SOLL/FIX: ### D4 -- Tote Messreihen gelten als gueltig und nicht-signifikant (7 Posten, 12,5 h)

Die Klasse in einem Satz, fuenffach belegt: die Null wird ueberall als **Divisions**-Gefahr gerettet und nirgends als **Daten**-Aussage behandelt (`drift_detector.hpp:69`, `welch_t_test.hpp:130`, `mann_whitney_u_test.hpp:92`, `multi_compare.hpp:75`, `f15_compare/main.cpp:486`); daneben steht jeweils ein ehrlich gebauter Rand-Guard (fehlende Daten ehrlich, tote Daten gutartig -- das Suchmuster fuer weitere Geschwister). Die Heilungsform liegt im Repo: `mess_konsistenz_gate.hpp` (fail-closed per Default-Wert, benannte Fehlerklassen) -- Uebertragung, nicht Entwurf.
STATUS LT. QUELLE: offen (Plan-Stand 08.08.; Vollzug je Posten spaeter, s. wtk6lmhln/WP-Eintraege)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 039
GEGENSTAND: D4: Drift-Gate: `median<=0 && n>=2` -> `unstable=true` + `bestimmbar=false` (bool, kein Enum -- Leser `:128` existiert); Rerun-Loop endet nicht me
ORT: unbekannt
SOLL/FIX: Kern: Drift-Gate: `median<=0 && n>=2` -> `unstable=true` + `bestimmbar=false` (bool, kein Enum -- Leser `:128` existiert); Rerun-Loop endet nicht mehr auf der kaputten Gruppe als "stabil"; Test `ZeroMedianGuard` wird im SELBEN Commit umgedreht | Aufwand: 2 h | Ziel-Welle: W2 | Reihenfolge-Zwang: **nur zusammen mit T-15 (##36)** -- allein = Scheinvollzug, T-15 allein = Blindheit einbauen
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W2; Zwang: **nur zusammen mit T-15 (##36)** -- allein = Scheinvollzug, T-15 allein = Blindheit einbauen

### [w2mylldp8.json] 040
GEGENSTAND: D4a: Welch: `degeneriert`-Flag bei se<=0 und bei nicht-finitem p; `valid` bleibt "gerechnet"; Export-Spalte
ORT: unbekannt
SOLL/FIX: Kern: Welch: `degeneriert`-Flag bei se<=0 und bei nicht-finitem p; `valid` bleibt "gerechnet"; Export-Spalte | Aufwand: 1,5 h | Ziel-Welle: W1 | Reihenfolge-Zwang: vor D4c
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W1; Zwang: vor D4c

### [w2mylldp8.json] 041
GEGENSTAND: D4b: MWU: `valid=true` HINTER den Guard; cliff_delta nicht "negligible" ueber Nichts; Diskrepanz-Warnung nur bei beidseitig nicht-degeneriert
ORT: unbekannt
SOLL/FIX: Kern: MWU: `valid=true` HINTER den Guard; cliff_delta nicht "negligible" ueber Nichts; Diskrepanz-Warnung nur bei beidseitig nicht-degeneriert | Aufwand: 1 h | Ziel-Welle: W1 | Reihenfolge-Zwang: mit D4a
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W1; Zwang: mit D4a

### [w2mylldp8.json] 042
GEGENSTAND: D4c: Bonferroni-Familie: m = **getestete** Hypothesen; `win_rate = X (Y von Z getestet, D degeneriert)`; Export erweitert
ORT: unbekannt
SOLL/FIX: Kern: Bonferroni-Familie: m = **getestete** Hypothesen; `win_rate = X (Y von Z getestet, D degeneriert)`; Export erweitert | Aufwand: 3 h | Ziel-Welle: W1 | Reihenfolge-Zwang: nach D4a/D4b
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W1; Zwang: nach D4a/D4b

### [w2mylldp8.json] 043
GEGENSTAND: D4d: `success` = mindestens eine Probe > 0; `degeneriert` als **eigenes** Feld; **die eine CSV-Spaltenaenderung der Woche**, danach Header-Freeze 
ORT: unbekannt
SOLL/FIX: Kern: `success` = mindestens eine Probe > 0; `degeneriert` als **eigenes** Feld; **die eine CSV-Spaltenaenderung der Woche**, danach Header-Freeze Stufe 2 | Aufwand: 1 h | Ziel-Welle: W1 | Reihenfolge-Zwang: mit ##08-Freeze-Logik
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W1; Zwang: mit ##08-Freeze-Logik

### [w2mylldp8.json] 044
GEGENSTAND: D4e: f15: Tote-Proben-Guard + Summenzeile `A+B+C+D+gemessen==geladen`; Exit-Code fuer degeneriert; Muster auf die Zahlen-Zeile
ORT: unbekannt
SOLL/FIX: Kern: f15: Tote-Proben-Guard + Summenzeile `A+B+C+D+gemessen==geladen`; Exit-Code fuer degeneriert; Muster auf die Zahlen-Zeile | Aufwand: 1,5 h | Ziel-Welle: W1 | Reihenfolge-Zwang: nach ##07 (W0a)
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W1; Zwang: nach ##07 (W0a)

### [w2mylldp8.json] 045
GEGENSTAND: D4f: Break-Even-Rueckgabetyp mit Statusraum (`bestimmt/kein_schnittpunkt/kurve_ungueltig/kein_ueberlapp/zu_wenig_stuetzstellen`), fail-closed Defa
ORT: unbekannt
SOLL/FIX: Kern: Break-Even-Rueckgabetyp mit Statusraum (`bestimmt/kein_schnittpunkt/kurve_ungueltig/kein_ueberlapp/zu_wenig_stuetzstellen`), fail-closed Default -- **jetzt, solange 0 Konsumenten** | Aufwand: 2,5 h | Ziel-Welle: W1 | Reihenfolge-Zwang: nach Break-Even-Definitionslage (OV-6)
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W1; Zwang: nach Break-Even-Definitionslage (OV-6)

### [w2mylldp8.json] 046
GEGENSTAND: Tragende Abnahme der Familie D4
ORT: unbekannt
SOLL/FIX: **Tragende Abnahme:** Invarianz-Beweis -- derselbe Datensatz mit und ohne degenerierte Kandidaten liefert **identische** `adjusted_p` fuer die echten (heute Faktor 9/7 daneben; ein gewuerfelter Kandidat mit p_roh zwischen 0,05/9 und 0,05/7 kippt heute die Signifikanz); Welch-Koeder {634x4} vs. {634x6} und der schaerfere {746x4} vs. {634x6} (beide konstant, 15 % verschieden, heute "kein Unterschied"); f15-Koeder: praeparierte Null-DLL **gewinnt heute das Ranking mit p50=0** -- nach Heilung ausgewiesen und Exit!=0.
STATUS LT. QUELLE: offen (Abnahme-SOLL mit Koedern)
ABHAENGIGKEIT/FLAECHE: Koeder-Pflicht K13, Rot-zuerst

### [w2mylldp8.json] 047
GEGENSTAND: Defekt-Familie D5 -- Sechs Perzentil-Verfahren, fuenf Mediane, ein fehlendes Feld (5 Posten, 13 h)
ORT: unbekannt
SOLL/FIX: ### D5 -- Sechs Perzentil-Verfahren, fuenf Mediane, ein fehlendes Feld (5 Posten, 13 h)
STATUS LT. QUELLE: offen (Plan-Stand 08.08.; Vollzug je Posten spaeter, s. wtk6lmhln/WP-Eintraege)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 048
GEGENSTAND: D5-1: **Perzentil-KANON**: beide Formeln tragen den Namen "Nearest-Rank" zu Unrecht; Lehrbuch-Formel `ceil(q*n)-1`; `nearest_rank_p` (34 unbewacht
ORT: unbekannt
SOLL/FIX: Kern: **Perzentil-KANON**: beide Formeln tragen den Namen "Nearest-Rank" zu Unrecht; Lehrbuch-Formel `ceil(q*n)-1`; `nearest_rank_p` (34 unbewachte Stellen) wird **ersatzlos geloescht** -> jede uebersehene Stelle bricht compile-time laut; Pin 51->50 mit Klartext-Commit "alle vorher erhobenen p50/p95/p99 ungueltig". **Einziger Posten, der den Messtermin bewegt** | Aufwand: 6 h | Ziel-Welle: **W0a (Lokalspur)** | Reihenfolge-Zwang: vor jedem ernsten Messwert
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle **W0a (Lokalspur)**; Zwang: vor jedem ernsten Messwert

### [w2mylldp8.json] 049
GEGENSTAND: D5-2: Median-Kanon = q=0.5-Fall; Sieger-Kuerung, `csv_to_latex`, `diagram_generator` auf EINE Definition; `:1783/:1784` (Mediane UeBER Konfiguration
ORT: unbekannt
SOLL/FIX: Kern: Median-Kanon = q=0.5-Fall; Sieger-Kuerung, `csv_to_latex`, `diagram_generator` auf EINE Definition; `:1783/:1784` (Mediane UeBER Konfigurationen) NICHT faelschlich umbauen; `eta_kalibrierung` begruendet entscheiden | Aufwand: 3 h | Ziel-Welle: W1 | Reihenfolge-Zwang: nach D5-1, nach D5-3
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W1; Zwang: nach D5-1, nach D5-3

### [w2mylldp8.json] 050
GEGENSTAND: D5-3: **Vorlage-Korrektur:** REV-DATA-12 zeigt auf **lebende** super-Werkzeuge (`Code/04_csv_to_latex/`, `Code/05_diagram_generator/`, letzter Com
ORT: unbekannt
SOLL/FIX: Kern: **Vorlage-Korrektur:** REV-DATA-12 zeigt auf **lebende** super-Werkzeuge (`Code/04_csv_to_latex/`, `Code/05_diagram_generator/`, letzter Commit 6d837e7d, 07.08.); Disposition-Anker um 239 Zeilen gedriftet -> korrigieren | Aufwand: 0,5 h | Ziel-Welle: W1 | Reihenfolge-Zwang: vor D5-2
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W1; Zwang: vor D5-2

### [w2mylldp8.json] 051
GEGENSTAND: D5-4: `delete_p99_ns` existiert 0-mal -> 9er-Feldliste als EINE Konstante, 5 Serialisierer auf den geteilten Helfer, Schema-Test in beide Richtunge
ORT: unbekannt
SOLL/FIX: Kern: `delete_p99_ns` existiert 0-mal -> 9er-Feldliste als EINE Konstante, 5 Serialisierer auf den geteilten Helfer, Schema-Test in beide Richtungen (fehlend UND unerwartet) | Aufwand: 1,5 h | Ziel-Welle: W1 | Reihenfolge-Zwang: mit D5-1-Flaechen
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W1; Zwang: mit D5-1-Flaechen

### [w2mylldp8.json] 052
GEGENSTAND: D5-5: HDR-Histogramm = sechstes Verfahren, unverdrahtet, gegen die falsche Referenz (1 %-Toleranz), verschluckt 0-ns-Proben still -> entscheiden (e
ORT: unbekannt
SOLL/FIX: Kern: HDR-Histogramm = sechstes Verfahren, unverdrahtet, gegen die falsche Referenz (1 %-Toleranz), verschluckt 0-ns-Proben still -> entscheiden (entfernen ODER begruendet fuehren), Toleranz aus `significant_figures=3` hergeleitet | Aufwand: 2 h | Ziel-Welle: W1 (rutschfaehig W2) | Reihenfolge-Zwang: nach D5-1
STATUS LT. QUELLE: offen (Plan-Posten 08.08.)
ABHAENGIGKEIT/FLAECHE: Welle W1 (rutschfaehig W2); Zwang: nach D5-1

### [w2mylldp8.json] 053
GEGENSTAND: Tragende Abnahme der Familie D5
ORT: unbekannt
SOLL/FIX: **Tragende Abnahme:** Wache druckt `Definitionen: 1` (heute 2); Zufalls-Seed-Test gegen zweitimplementierte Lehrbuch-Referenz (Seed gedruckt); Mutations-Koeder (delta +/-1 auf gewuerfeltem Summanden, nur Testziel neu gebaut) -> rc!=0, **vor der Heilung einmal rot gefahren**; Kreuz-Test gerader Laenge ueber Selector/`csv_to_latex`/`diagram_generator` mit Bit-Gleichheit (Achtung: vendorierter ce-Stand in super zeigt auf alten Commit -- der Kreuz-Test muss gegen den geheilten Stand pruefen, sonst gruen und blind).

---
STATUS LT. QUELLE: offen (Abnahme-SOLL mit Koedern)
ABHAENGIGKEIT/FLAECHE: Koeder-Pflicht K13, Rot-zuerst

### [w2mylldp8.json] 054
GEGENSTAND: WAS FAELLT: ##40 W2-S-E-Restbau (T-06 KF-6/60, T-07 RAM-Spool, T-08 Dual-ccache, T-09, T-10, T-12 Cross-Genus, T-13/T-14 FK-Walk, W-03, W-08, 
ORT: unbekannt
SOLL/FIX: Entscheid: -> W7. **Das ist der Preis des Owner-KERN Hybrid**: Bausteine ohne Konsument tragen keine Messung, ein fehlendes Kettenglied macht sie wertlos | Kosten (ehrlich): ~10 gebaute Bausteine bleiben eine Abgabe-Periode laenger ohne Konsument; Cacheline-/Spool-Achsen fehlen in der Messmatrix = kleinerer belegter Design-Raum; in der Thesis nur als "gebaute Infrastruktur mit deklarierter Grenze" zitierbar
STATUS LT. QUELLE: offen (Streich-/Verschiebe-Entscheid, Kosten ausgewiesen)
ABHAENGIGKEIT/FLAECHE: Streichkaskade par.7

### [w2mylldp8.json] 055
GEGENSTAND: WAS FAELLT: HY-Vollausbau
ORT: unbekannt
SOLL/FIX: Entscheid: nur F8-Minimalschnitt im Fenster (1 Standard-Dock, Stub-Heuristik, Router aus Kurven); Heuristik-Familie, Mehrfach-Aufbau, scharfe Eviction, Paper-gekoppelte Wahl -> W7 | Kosten (ehrlich): das Hybrid-Kapitel belegt Reroute-Overhead + EINEN Routing-Fall, nicht die Familie -- aber ehrlich, statt das Pflicht-Glied ganz zu verschieben
STATUS LT. QUELLE: offen (Streich-/Verschiebe-Entscheid, Kosten ausgewiesen)
ABHAENGIGKEIT/FLAECHE: Streichkaskade par.7

### [w2mylldp8.json] 056
GEGENSTAND: WAS FAELLT: prod2/Intel-Lane (S-05, U-06 pmc:intel, U-07, B-3-Spalte `cpu_core/cpu_atom`, D2-G5-Vollausbau)
ORT: unbekannt
SOLL/FIX: Entscheid: Empfehlung OV-5(b): Textkorrektur; nur der 3-Zeilen-Host-Bericht (D2-G5) wird gebaut | Kosten (ehrlich): drei Praesens-Zusagen der Evaluation werden zurueckgenommen statt erfuellt (sichtbarer Schnitt mit Methodikgrenze); Vendor-Vergleich faellt ersatzlos; die Alternative (still mit einer Lane messen, Text behalten) waere eine Falschaussage
STATUS LT. QUELLE: offen (Streich-/Verschiebe-Entscheid, Kosten ausgewiesen)
ABHAENGIGKEIT/FLAECHE: Streichkaskade par.7

### [w2mylldp8.json] 057
GEGENSTAND: WAS FAELLT: Voll-Messung (524.288 Binaries, >=143 Tage einthreadig Untergrenze)
ORT: unbekannt
SOLL/FIX: Entscheid: faellt IMMER; genau EINE gedeckelte Kampagne (`<measure_selection>`, ETA <= 4,5 Maschinentage, Prioritaet = die in Kap. 5 zitierten Tabellen) | Kosten (ehrlich): die Design-Raum-Aussage gilt fuer die begruendete Teilmenge; Deckel + Auswahlregel versioniert und in der Methodik ausgewiesen -- ehrlicher als eine still abgebrochene Vollmessung
STATUS LT. QUELLE: offen (Streich-/Verschiebe-Entscheid, Kosten ausgewiesen)
ABHAENGIGKEIT/FLAECHE: Streichkaskade par.7

### [w2mylldp8.json] 058
GEGENSTAND: WAS FAELLT: T-15/D4-Streichung (Frist-Entwurf)
ORT: unbekannt
SOLL/FIX: Entscheid: **abgelehnt** -- Widerspruch entschieden: D4 ist ein Defekt (Owner-KERN "DEFEKT = IMMER BEHEBEN"), T-15 ohne D4 baut Blindheit ein, D4 ohne T-15 ist Scheinvollzug (Einwand 25); das Frist-Gift-Argument (Reruns unplanbar) wird durch Rerun-Deckel + im Kalibrierlauf erhobene Rerun-Rate entschaerft | Kosten (ehrlich): 0,5-1 AT mehr in W2; falls die Kalibrier-Rerun-Rate explodiert, wird die Drift-Schwelle VOR dem GO neu vorgelegt statt still gefahren
STATUS LT. QUELLE: offen (Streich-/Verschiebe-Entscheid, Kosten ausgewiesen)
ABHAENGIGKEIT/FLAECHE: Streichkaskade par.7

### [w2mylldp8.json] 059
GEGENSTAND: WAS FAELLT: NULL-Bump (Frist-Entwurf)
ORT: unbekannt
SOLL/FIX: Entscheid: **abgelehnt als Total-Streichung, uebernommen als Wache**: EIN Buendel Mo 24.08., danach NULL-Wache | Kosten (ehrlich): par.59-Kette wird ganz statt halb (MERGE-STEMPEL ist im Ledger "OFFEN, kritisch"); Restrisiko: das Buendel selbst muss an einem Tag landen
STATUS LT. QUELLE: offen (Streich-/Verschiebe-Entscheid, Kosten ausgewiesen)
ABHAENGIGKEIT/FLAECHE: Streichkaskade par.7

### [w2mylldp8.json] 060
GEGENSTAND: WAS FAELLT: F-07b Diagramm-Emitter
ORT: unbekannt
SOLL/FIX: Entscheid: -> W7 (Streichkaskade bestaetigt) | Kosten (ehrlich): Anhang traegt Tabellen, keine 2D/3D-Diagramme -- Tabellen tragen die Aussage
STATUS LT. QUELLE: offen (Streich-/Verschiebe-Entscheid, Kosten ausgewiesen)
ABHAENGIGKEIT/FLAECHE: Streichkaskade par.7

### [w2mylldp8.json] 061
GEGENSTAND: WAS FAELLT: `checkpoint_measure` (OV-2b bestaetigt)
ORT: unbekannt
SOLL/FIX: Entscheid: -> W7 | Kosten (ehrlich): fuenfte Mess-Ebene bleibt spezifiziert; Text MUSS "vier gemessen (inkl. Hybrid-Ebene), fuenfte spezifiziert" sagen (P-1-Klasse)
STATUS LT. QUELLE: offen (Streich-/Verschiebe-Entscheid, Kosten ausgewiesen)
ABHAENGIGKEIT/FLAECHE: Streichkaskade par.7

### [w2mylldp8.json] 062
GEGENSTAND: WAS FAELLT: Paper-Kopplung (OV-14)
ORT: unbekannt
SOLL/FIX: Entscheid: -> W7 mit Klartext-Satz in Kap. 5 | Kosten (ehrlich): die wissenschaftliche Frage "waeren fremde Paper-Algorithmen je Achse besser" wird im Fenster nicht gemessen; der Owner-Auftrag ("bauen, Ruecksprache im Detail") wird als offener Posten mit Konsequenz uebergeben, nicht still entsorgt
STATUS LT. QUELLE: offen (Streich-/Verschiebe-Entscheid, Kosten ausgewiesen)
ABHAENGIGKEIT/FLAECHE: Streichkaskade par.7

### [w2mylldp8.json] 063
GEGENSTAND: WAS FAELLT: par.75-Aufraeumpass (104), Record-and-Replay, PV-1
ORT: unbekannt
SOLL/FIX: Entscheid: -> W7; ab W0b nur Zuwachs-Stopp | Kosten (ehrlich): Zaehler bleiben hoch und sichtbar (ASCII 1160, Prosa 54, `organ_location` 97)
STATUS LT. QUELLE: offen (Streich-/Verschiebe-Entscheid, Kosten ausgewiesen)
ABHAENGIGKEIT/FLAECHE: Streichkaskade par.7

### [w2mylldp8.json] 064
GEGENSTAND: WAS FAELLT: Break-Even-Neubau B=3
ORT: unbekannt
SOLL/FIX: Entscheid: gemaess OV-1; faellt die Definitions-Konsolidierung nicht bis F2, faellt Break-Even **ganz** aus den Ergebnissen | Kosten (ehrlich): fehlende Leistung, keine Falschaussage (`kapitel/` = 0 Treffer "Break-Even"); D4f-Typ wird trotzdem gebaut
STATUS LT. QUELLE: offen (Streich-/Verschiebe-Entscheid, Kosten ausgewiesen)
ABHAENGIGKEIT/FLAECHE: Streichkaskade par.7

### [w2mylldp8.json] 065
GEGENSTAND: WAS FAELLT: D4a-Vorzeichenfrage (p=1.0 vs. 0.0 bei se=0, mean_a!=mean_b)
ORT: unbekannt
SOLL/FIX: Entscheid: NICHT im Code entschieden; nur `degeneriert=true` + Ausschluss aus der Familie | Kosten (ehrlich): eine ehrlich benannte Methodik-Fussnote statt einer still geaenderten Zahl
STATUS LT. QUELLE: offen (Streich-/Verschiebe-Entscheid, Kosten ausgewiesen)
ABHAENGIGKEIT/FLAECHE: Streichkaskade par.7

### [w2mylldp8.json] 066
GEGENSTAND: WAS FAELLT: ##24 A9-S5a (Archiv-xlsx), ##15-EMITTER/TEMPLATE, D5-5
ORT: unbekannt
SOLL/FIX: Entscheid: nachrangig / rutschfaehig -- fallen zuerst bei lokalem Riss | Kosten (ehrlich): kein Rueckbeleg ueber den Alt-Korpus (der Fassung-3-Beweis haengt am frischen ##25 -- der ohnehin allein etwas ueber die September-Kette aussagt)
STATUS LT. QUELLE: offen (Streich-/Verschiebe-Entscheid, Kosten ausgewiesen)
ABHAENGIGKEIT/FLAECHE: Streichkaskade par.7

### [w2mylldp8.json] 067
GEGENSTAND: WAS FAELLT: ##31-Vollautomation, D1c-Vollausbau
ORT: unbekannt
SOLL/FIX: Entscheid: gebaut; benannte **Rueckfallstufen** (manuelles Register / Floor-Variante) nur bei Zeitriss, Entnahme wird gebucht | Kosten (ehrlich): deklarierte Grenzen im Register, W7-Nacharbeit
STATUS LT. QUELLE: offen (Streich-/Verschiebe-Entscheid, Kosten ausgewiesen)
ABHAENGIGKEIT/FLAECHE: Streichkaskade par.7

### [w2mylldp8.json] 068
GEGENSTAND: WAS FAELLT: EN-Nachzug
ORT: unbekannt
SOLL/FIX: Entscheid: nur beruehrte Kapitel (Doktrin: DE fuehrt) | Kosten (ehrlich): EN zur Abgabe nicht vollsynchron; Bestand war es vorher auch nicht, es waechst nur nicht
STATUS LT. QUELLE: offen (Streich-/Verschiebe-Entscheid, Kosten ausgewiesen)
ABHAENGIGKEIT/FLAECHE: Streichkaskade par.7

### [w2mylldp8.json] 069
GEGENSTAND: WAS FAELLT: measure:smoke-Wiederbelebung
ORT: unbekannt
SOLL/FIX: Entscheid: faellt (bleibt deprecated; nur der 3-Zeilen-Helfer-Umbau D3-2) | Kosten (ehrlich): keine -- der lebende Weg ist der CEB-emittierte, und genau der wird gehaertet
STATUS LT. QUELLE: offen (Streich-/Verschiebe-Entscheid, Kosten ausgewiesen)
ABHAENGIGKEIT/FLAECHE: Streichkaskade par.7

### [w2mylldp8.json] 070
GEGENSTAND: OWNER-FRAGE OV-13 HYBRID: Bestaetigst du die Ketten-Zerlegung HY-A (Struktur/Dock/Achse/Parser, W1) / HY-B (Overhead-Messung mit Stub-Heuristik, W3-MESS) / HY-C (Break-Even-Rout
ORT: unbekannt
SOLL/FIX: Frage: Bestaetigst du die Ketten-Zerlegung HY-A (Struktur/Dock/Achse/Parser, W1) / HY-B (Overhead-Messung mit Stub-Heuristik, W3-MESS) / HY-C (Break-Even-Router, W4) mit F8-Minimal-DoD als Pflichtkern und Vollausbau nach W7 -- ja/nein? | Empfehlung: **ja** -- haelt deinen KERN ("Alles Pflicht") UND dein E1-Design ("Router in der Auswertungsphase", "kein eigener ABI-Schritt") gleichzeitig; bei "nein, v1 gilt" entspannt sich W1 um ~4 Tage und ##40 kehrt zurueck | Frist: **Mo 10.08.**
STATUS LT. QUELLE: offen (Owner-Frage, Stand 08.08.; etliche seither beantwortet -- Abgleich noetig)
ABHAENGIGKEIT/FLAECHE: Owner-Entscheid

### [w2mylldp8.json] 071
GEGENSTAND: OWNER-FRAGE OV-3 4. MESS-EBENE: Wird die Hybrid-Macro-Schicht hybrid-LOKAL gebaut (nur in `hybrid_tier_module` einkompiliert, plain-Tier-Fingerprint unberuehrt, KEIN Bump) oder als ne
ORT: unbekannt
SOLL/FIX: Frage: Wird die Hybrid-Macro-Schicht hybrid-LOKAL gebaut (nur in `hybrid_tier_module` einkompiliert, plain-Tier-Fingerprint unberuehrt, KEIN Bump) oder als neues Glied im globalen `mess_gates_glied` (7. Bump-Anspruchsteller, ALLE Binaries neu)? | Empfehlung: **hybrid-lokal** -- dein "dazwischengequetscht" lebt in der Ebenen-Nummerierung des Mess-BERICHTS, nicht im Stempel der plain Tiers | Frist: Mi 19.08., VOR ##34
STATUS LT. QUELLE: offen (Owner-Frage, Stand 08.08.; etliche seither beantwortet -- Abgleich noetig)
ABHAENGIGKEIT/FLAECHE: Owner-Entscheid

### [w2mylldp8.json] 072
GEGENSTAND: OWNER-FRAGE OV-12 HYSTERESE: Ist das Flattern des Schalters das SIGNAL fuer den Umschaltbereich (Bereichs-Erkennung) oder eine zu unterdrueckende Stoerung (Hysterese-Band)?
ORT: unbekannt
SOLL/FIX: Frage: Ist das Flattern des Schalters das SIGNAL fuer den Umschaltbereich (Bereichs-Erkennung) oder eine zu unterdrueckende Stoerung (Hysterese-Band)? | Empfehlung: **Bereichs-Erkennung** -- ein Hysterese-Band unterdrueckt exakt das Messobjekt der 4. Ebene; bis zum Entscheid wird keine Variante verdrahtet | Frist: Mo 17.08. abends
STATUS LT. QUELLE: offen (Owner-Frage, Stand 08.08.; etliche seither beantwortet -- Abgleich noetig)
ABHAENGIGKEIT/FLAECHE: Owner-Entscheid

### [w2mylldp8.json] 073
GEGENSTAND: OWNER-FRAGE OV-16 allow_failure: Darf ich `allow_failure: true` vom CEB-emittierten Mess-Job entfernen, sodass ein Mess-Fehler die Pipeline rot faerbt?
ORT: unbekannt
SOLL/FIX: Frage: Darf ich `allow_failure: true` vom CEB-emittierten Mess-Job entfernen, sodass ein Mess-Fehler die Pipeline rot faerbt? | Empfehlung: **ja** -- die "Sichtbarkeits-Doktrin" im Code (`experiment_plan_director.hpp:1393`) ist Agent-Behauptung ohne auffindbares Owner-Wort und beruft sich auf eine CSV, die dort niemand liest | Frist: Mi 12.08.
STATUS LT. QUELLE: offen (Owner-Frage, Stand 08.08.; etliche seither beantwortet -- Abgleich noetig)
ABHAENGIGKEIT/FLAECHE: Owner-Entscheid

### [w2mylldp8.json] 074
GEGENSTAND: OWNER-FRAGE OV-17 result.csv: Ist die Flach-Ablage `<stem>.result.csv` ein GEPLANTER Umbenenn-Schritt (dann bauen wir ihn) oder ein Archiv-Artefakt des handgefahrenen D-03-Erstbele
ORT: unbekannt
SOLL/FIX: Frage: Ist die Flach-Ablage `<stem>.result.csv` ein GEPLANTER Umbenenn-Schritt (dann bauen wir ihn) oder ein Archiv-Artefakt des handgefahrenen D-03-Erstbelegs (dann erweitere ich das Suchmuster auf beide Formen)? | Empfehlung: **Archiv-Artefakt, Muster erweitern** -- in ce und super existiert kein Flach-Schritt; ohne dein Wort ist die Heilungsrichtung geraten | Frist: Mi 12.08.
STATUS LT. QUELLE: offen (Owner-Frage, Stand 08.08.; etliche seither beantwortet -- Abgleich noetig)
ABHAENGIGKEIT/FLAECHE: Owner-Entscheid

### [w2mylldp8.json] 075
GEGENSTAND: OWNER-FRAGE OV-5 prod2: Korrigieren wir `05_evaluation.tex:70-82` auf Ein-Maschinen-Betrieb (prod1/Zen 5) mit ausgewiesener Methodikgrenze -- ja/nein?
ORT: unbekannt
SOLL/FIX: Frage: Korrigieren wir `05_evaluation.tex:70-82` auf Ein-Maschinen-Betrieb (prod1/Zen 5) mit ausgewiesener Methodikgrenze -- ja/nein? | Empfehlung: **ja** -- `getent hosts prod2` -> rc 2, keine Beschaffung dokumentiert, der Cluster ist fuer mich read-only; eine mitten im Fenster erscheinende Maschine waere selbst ein Messrisiko (keine Kalibrierhistorie, AVX-512-Nennerdifferenz D2-G5); der Entscheid JETZT spart pmc:intel/B-3/S-05/U-06/U-07 aus den Wochen 1-2 | Frist: jetzt, spaetestens Fr 21.08.
STATUS LT. QUELLE: offen (Owner-Frage, Stand 08.08.; etliche seither beantwortet -- Abgleich noetig)
ABHAENGIGKEIT/FLAECHE: Owner-Entscheid

### [w2mylldp8.json] 076
GEGENSTAND: OWNER-FRAGE OV-4 MESS-DECKEL: Gilt "Messmenge = groesste Teilmenge mit ETA <= 4,5 Maschinentagen, Prioritaet = die in Kap. 5 zitierten Tabellen zuerst, versioniert als `<measure_select
ORT: unbekannt
SOLL/FIX: Frage: Gilt "Messmenge = groesste Teilmenge mit ETA <= 4,5 Maschinentagen, Prioritaet = die in Kap. 5 zitierten Tabellen zuerst, versioniert als `<measure_selection>`, plus HY-B als eigene kleine Teilmatrix daneben" -- ja/nein? | Empfehlung: **ja** -- die einzige Rechnung (>=143 Tage einthreadig, doppelt als Untergrenze markiert) schliesst den Vollraum aus; die Deckel-Achse waehlst du an der ##51-Vorlage | Frist: an F2 (21.08.), MIT beiden Zahlenreihen
STATUS LT. QUELLE: offen (Owner-Frage, Stand 08.08.; etliche seither beantwortet -- Abgleich noetig)
ABHAENGIGKEIT/FLAECHE: Owner-Entscheid

### [w2mylldp8.json] 077
GEGENSTAND: OWNER-FRAGE OV-1 BREAK-EVEN: B=3-B-Spline im Fenster neu bauen (dein KERN-Wortlaut) ODER die gebaute monotone Hermite ratifizieren und die Methodenwahl in der Thesis begruenden, B-
ORT: unbekannt
SOLL/FIX: Frage: B=3-B-Spline im Fenster neu bauen (dein KERN-Wortlaut) ODER die gebaute monotone Hermite ratifizieren und die Methodenwahl in der Thesis begruenden, B-Spline nach der Abgabe? | Empfehlung: **Widerspruch der drei Entwuerfe, offen vorgelegt:** Risikosicht sagt Hermite (neuer Numerik-Code, der erst in W4 an echten Daten geprueft wuerde = spaete Fehlerklasse), dein KERN sagt B=3 -- **dein Satz entscheidet, nicht meine Autonomie**; Zusatzregel in jedem Fall: steht die Definitions-Konsolidierung (drei Modelle) nicht bis F2, faellt Break-Even ganz aus den Ergebnissen (OV-6) | Frist: Mo 17.08.
STATUS LT. QUELLE: offen (Owner-Frage, Stand 08.08.; etliche seither beantwortet -- Abgleich noetig)
ABHAENGIGKEIT/FLAECHE: Owner-Entscheid

### [w2mylldp8.json] 078
GEGENSTAND: OWNER-FRAGE OV-6 BE-DEFINITION: Faellt Break-Even ganz aus den Ergebnissen, falls die Definitions-Konsolidierung nicht bis 21.08. steht -- ja?
ORT: unbekannt
SOLL/FIX: Frage: Faellt Break-Even ganz aus den Ergebnissen, falls die Definitions-Konsolidierung nicht bis 21.08. steht -- ja? | Empfehlung: **ja** -- `kapitel/` hat 0 Treffer "Break-Even": fehlende Leistung, keine Falschaussage; D4f wird als Typ trotzdem gebaut | Frist: an F2
STATUS LT. QUELLE: offen (Owner-Frage, Stand 08.08.; etliche seither beantwortet -- Abgleich noetig)
ABHAENGIGKEIT/FLAECHE: Owner-Entscheid

### [w2mylldp8.json] 079
GEGENSTAND: OWNER-FRAGE OV-10 CEB-VARIANTEN: Teilmengen-Lesart (max. 4 erreichbar, Abnahme "4 + belegte Begruendung warum nicht 6") -- ja?
ORT: unbekannt
SOLL/FIX: Frage: Teilmengen-Lesart (max. 4 erreichbar, Abnahme "4 + belegte Begruendung warum nicht 6") -- ja? | Empfehlung: **ja** -- echte 3!-Permutation waere ein Gate-Modell-Umbau im Identitaetsfenster mit Bump-Folge | Frist: vor ##32
STATUS LT. QUELLE: offen (Owner-Frage, Stand 08.08.; etliche seither beantwortet -- Abgleich noetig)
ABHAENGIGKEIT/FLAECHE: Owner-Entscheid

### [w2mylldp8.json] 080
GEGENSTAND: OWNER-FRAGE OV-8 TREIBER: Faehrt ce `perm_runner` (Konformitaets-Gate scharf, `:196/:289`) den Voll-Lauf -- ja?
ORT: unbekannt
SOLL/FIX: Frage: Faehrt ce `perm_runner` (Konformitaets-Gate scharf, `:196/:289`) den Voll-Lauf -- ja? | Empfehlung: **ja** -- nur so bleibt `05_evaluation.tex:138` ohne Textaenderung wahr; der super-Katalog-Treiber erst nach ##39 | Frist: vor W2
STATUS LT. QUELLE: offen (Owner-Frage, Stand 08.08.; etliche seither beantwortet -- Abgleich noetig)
ABHAENGIGKEIT/FLAECHE: Owner-Entscheid

### [w2mylldp8.json] 081
GEGENSTAND: OWNER-FRAGE OV-14 PAPER-KOPPLUNG: Bau nach der Abgabe, und der Satz "die Arbeit vergleicht Kompositionen, nicht Paper-Algorithmen je Achse" geht als Methodikgrenze in Kap. 5 -- ja?
ORT: unbekannt
SOLL/FIX: Frage: Bau nach der Abgabe, und der Satz "die Arbeit vergleicht Kompositionen, nicht Paper-Algorithmen je Achse" geht als Methodikgrenze in Kap. 5 -- ja? | Empfehlung: **ja** -- dies IST die von dir geforderte Ruecksprache im Detail (LEDGER:11128); stilles Einsortieren waere der Fehler | Frist: Mo 17.08., sonst automatisch W7
STATUS LT. QUELLE: offen (Owner-Frage, Stand 08.08.; etliche seither beantwortet -- Abgleich noetig)
ABHAENGIGKEIT/FLAECHE: Owner-Entscheid

### [w2mylldp8.json] 082
GEGENSTAND: OWNER-FRAGE OV-2 checkpoint_measure: Bleibt es bei "spezifiziert, nicht gebaut" (W7)?
ORT: unbekannt
SOLL/FIX: Frage: Bleibt es bei "spezifiziert, nicht gebaut" (W7)? | Empfehlung: **ja** -- ein Fingerprint-Bump ohne Konsument waere die Klasse "gebaut, kein Konsument" im Identitaetsfenster | Frist: vor Mo 24.08.
STATUS LT. QUELLE: offen (Owner-Frage, Stand 08.08.; etliche seither beantwortet -- Abgleich noetig)
ABHAENGIGKEIT/FLAECHE: Owner-Entscheid

### [w2mylldp8.json] 083
GEGENSTAND: OWNER-FRAGE OV-15 GO-TERMIN: Koennen beide Mess-GOs (320er + gedeckelte Teilmatrix) bis **Sa 29.08. 06:00** fallen, wenn die GO-VORLAGE Fr 28.08. mit Deckel-Zahl vorliegt -- ja?
ORT: unbekannt
SOLL/FIX: Frage: Koennen beide Mess-GOs (320er + gedeckelte Teilmatrix) bis **Sa 29.08. 06:00** fallen, wenn die GO-VORLAGE Fr 28.08. mit Deckel-Zahl vorliegt -- ja? | Empfehlung: **ja erbeten** -- jeder Verzugstag frisst 1:1 Messfenster; ab Ende-W2-Verzug kippt die Rueckwaertsrechnung und W4 entfaellt als Auswertungsfenster | Frist: Vorab-Zusage an F3
STATUS LT. QUELLE: offen (Owner-Frage, Stand 08.08.; etliche seither beantwortet -- Abgleich noetig)
ABHAENGIGKEIT/FLAECHE: Owner-Entscheid

### [w2mylldp8.json] 084
GEGENSTAND: OWNER-FRAGE OV-18 STREICHKASKADE: Bestaetigst du die neue Streich-Reihenfolge (Abschnitt 7, letzter Block) mit einem Satz?
ORT: unbekannt
SOLL/FIX: Frage: Bestaetigst du die neue Streich-Reihenfolge (Abschnitt 7, letzter Block) mit einem Satz? | Empfehlung: ja erbeten -- sie weicht von v1 ab, weil deren Position 2 (Hybrid) durch deinen KERN gefallen ist | Frist: Mo 17.08.
STATUS LT. QUELLE: offen (Owner-Frage, Stand 08.08.; etliche seither beantwortet -- Abgleich noetig)
ABHAENGIGKEIT/FLAECHE: Owner-Entscheid

### [w2mylldp8.json] 085
GEGENSTAND: RISIKO R-1 -- Der lebende Messweg war bis heute unbeobachtbar (hoechstes Risiko, jetzt adressiert). `allow_failure: true` + kein Ausgabe-Gate + Kopfzeilen-CSV 
ORT: unbekannt
SOLL/FIX: **R-1 -- Der lebende Messweg war bis heute unbeobachtbar (hoechstes Risiko, jetzt adressiert).** `allow_failure: true` + kein Ausgabe-Gate + Kopfzeilen-CSV als Bauart + persistierte Phantome + blinder anhang-Selektor: der vollstaendige Phantom-Pfad war offen. Gegenmassnahme: die D3-Kette (W0b) + der Durchstich (F1) beweisen die Kette am kleinen Objekt, BEVOR das grosse durch sie muss. **Restrisiko:** die ersten echten Rot-Laeufe nach der Haertung sind Funde, keine Rueckschlaege -- sie brauchen Budget (Batch-Abend-Doktrin + Resume + 30 h Marge), und `ergebnis:holen` wird erst mit stehender Frische-Wache scharf.
STATUS LT. QUELLE: offen (Risiko mit Gegenmassnahme)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 086
GEGENSTAND: RISIKO R-2 -- Menge/Anker (unveraendert aus v1, verschaerft). Ohne ##10/##10b/##11 ist die Kampagne geraten; eine Mess-Achsen-Aenderung nach Mi 26.08. 06:00 vern
ORT: unbekannt
SOLL/FIX: **R-2 -- Menge/Anker (unveraendert aus v1, verschaerft).** Ohne ##10/##10b/##11 ist die Kampagne geraten; eine Mess-Achsen-Aenderung nach Mi 26.08. 06:00 vernichtet 41 h Bau + Fenster. Gegenmassnahme: Sperrlisten-Wache = Freeze-Gate (##14), EIN Bump-Buendel + NULL-Wache (##34), Kalibrierlauf gegen unabhaengige Auszaehlung (##47). **Kipp-Punkt-Regel:** Bau-Start nach Fr 28.08. 06:00 = W4-Fangnetz faellt, als Zahl protokolliert.
STATUS LT. QUELLE: offen (Risiko mit Gegenmassnahme)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 087
GEGENSTAND: RISIKO R-3 -- Die drei Praesens-Zusagen (unveraendert). Zwei-Maschinen (`:78-79`), 4096er-Resume (`:139-140`), Konformitaet (`:138`). Gegenmassnahme P-1 (Nenner 3
ORT: unbekannt
SOLL/FIX: **R-3 -- Die drei Praesens-Zusagen (unveraendert).** Zwei-Maschinen (`:78-79`), 4096er-Resume (`:139-140`), Konformitaet (`:138`). Gegenmassnahme P-1 (Nenner 3): erfuellt bis F4 ODER korrigiert bis F5; ##35 erfuellt die zweite, OV-8 die dritte, OV-5 korrigiert die erste. Still fallenlassen macht die Abgabe unwahr -- ein anderer Fehler als fehlende Leistung.
STATUS LT. QUELLE: offen (Risiko mit Gegenmassnahme)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 088
GEGENSTAND: RISIKO R-4 -- Statistik-Erstlaeufe koennen rot sein. 27 Faelle liefen 79 Tage nicht (`AllFourteenAxesPopulated` bei heute 22/18 Achsen ist der offensichtliche Ka
ORT: unbekannt
SOLL/FIX: **R-4 -- Statistik-Erstlaeufe koennen rot sein.** 27 Faelle liefen 79 Tage nicht (`AllFourteenAxesPopulated` bei heute 22/18 Achsen ist der offensichtliche Kandidat); die zwei nie gefahrenen R5.G-Tests koennen beim ersten echten Lauf rot sein; D5-1 dreht einen gruenen Pin (51->50) bewusst um. Alles Funde, kein Grund zur Ruecknahme -- aber Zeit, die im W0a/W0b-Budget steht; mehr als zwei rote Faelle je Flaeche = eigener Posten, nie `allow_failure`.
STATUS LT. QUELLE: offen (Risiko mit Gegenmassnahme)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 089
GEGENSTAND: RISIKO R-5 -- HY-Ueberlauf. HY-A ist eine Planungsschaetzung ohne Objekt-Basis (An-10); jeder Ueberlauftag frisst 1:1 die WE-Option 22./23.08. und danach W2-Fr-P
ORT: unbekannt
SOLL/FIX: **R-5 -- HY-Ueberlauf.** HY-A ist eine Planungsschaetzung ohne Objekt-Basis (An-10); jeder Ueberlauftag frisst 1:1 die WE-Option 22./23.08. und danach W2-Fr-Puffer. Gegenmassnahme: F8-Minimalschnitt ist bindend; HY-C ist Streichkaskade Rang 3 (auf EINEN belegten Fall reduzierbar); der 4.-Ebenen-Entscheid (OV-3) haelt HY aus dem Bump heraus.
STATUS LT. QUELLE: offen (Risiko mit Gegenmassnahme)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 090
GEGENSTAND: RISIKO R-6 -- prod1-Platte/RAM. `/` zu 83 % voll, 43 G frei, Runner auf derselben Platte, earlyoom; 53 Permutations-TUs ? 523 MB MaxRSS (bei `-j6` ~3 GB, `-j1
ORT: unbekannt
SOLL/FIX: **R-6 -- prod1-Platte/RAM.** `/` zu 83 % voll, 43 G frei, Runner auf derselben Platte, earlyoom; 53 Permutations-TUs ? 523 MB MaxRSS (bei `-j6` ~3 GB, `-j16` ~8 GB Spitze). Gegenmassnahme: BUILD_JOBS-Deckel dokumentiert (D1a), ##48 druckt `benoetigt_GB/frei_GB` VOR dem Trigger, Probe-Baeume nach Gegenlesen loeschen, Lastfreiheit im Bau-/Messfenster angeordnet (An-7).
STATUS LT. QUELLE: offen (Risiko mit Gegenmassnahme)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 091
GEGENSTAND: RISIKO R-7 -- GO-Verzug. Ohne beide GOs bis Sa 29.08. 06:00 schrumpft das Fenster 1:1; nach An-3 kippt ab Ende-W2-Verzug die gesamte Rueckwaertsrechnung. Gegenm
ORT: unbekannt
SOLL/FIX: **R-7 -- GO-Verzug.** Ohne beide GOs bis Sa 29.08. 06:00 schrumpft das Fenster 1:1; nach An-3 kippt ab Ende-W2-Verzug die gesamte Rueckwaertsrechnung. Gegenmassnahme: OV-15-Vorabzusage, EINE Vorlage (##51) mit allen Entscheiden.
STATUS LT. QUELLE: offen (Risiko mit Gegenmassnahme)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 092
GEGENSTAND: RISIKO R-8 -- Drift-Gate-Rerun-Rate unbekannt. T-15+D4 verdrahtet erstmals Reruns in den Messweg. Gegenmassnahme: Rerun-Deckel im Code, Rate im Kalibrierlauf (
ORT: unbekannt
SOLL/FIX: **R-8 -- Drift-Gate-Rerun-Rate unbekannt.** T-15+D4 verdrahtet erstmals Reruns in den Messweg. Gegenmassnahme: Rerun-Deckel im Code, Rate im Kalibrierlauf (##47) erhoben; explodiert sie, wird die Schwelle VOR dem GO neu vorgelegt -- nicht still gefahren, nicht still abgeschaltet.
STATUS LT. QUELLE: offen (Risiko mit Gegenmassnahme)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 093
GEGENSTAND: RISIKO R-9 -- Die Korrektur-Fassungen selbst. Diese Fassung korrigiert vier v1-Abnahmeformeln; falsch korrigiert waere die naechste Dauer-Rot- oder Dauer-Gruen-W
ORT: unbekannt
SOLL/FIX: **R-9 -- Die Korrektur-Fassungen selbst.** Diese Fassung korrigiert vier v1-Abnahmeformeln; falsch korrigiert waere die naechste Dauer-Rot- oder Dauer-Gruen-Wache. Gegenmassnahme: jede korrigierte Formel traegt einen Gegenkoeder (unmanipulierter Lauf gruen) UND einen Biss-Beweis (V-2 beidseitig), beide gefahren vor Verlass.

---
STATUS LT. QUELLE: offen (Risiko mit Gegenmassnahme)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 094
GEGENSTAND: ANNAHME An-2: Mess-Dauer je Binary in der Groessenordnung des Kalibrierlaufs
ORT: unbekannt
SOLL/FIX: Annahme: Mess-Dauer je Binary in der Groessenordnung des Kalibrierlaufs | Status: ungeprueft bis ##10b/##47; 0,1094 s ist doppelt als Untergrenze markiert, Bezugsgroesse 16 Zeilen, Spanne Faktor 69
STATUS LT. QUELLE: offen (benannte Annahme)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 095
GEGENSTAND: ANNAHME An-3: Beide GOs bis Sa 29.08. 06:00 (Rueckfall Fr 28.08. als letzte Grenze der Rueckwaertsrechnung)
ORT: unbekannt
SOLL/FIX: Annahme: Beide GOs bis Sa 29.08. 06:00 (Rueckfall Fr 28.08. als letzte Grenze der Rueckwaertsrechnung) | Status: Owner-abhaengig (OV-15)
STATUS LT. QUELLE: offen (benannte Annahme)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 096
GEGENSTAND: ANNAHME An-4: `bau/a9-s4-mess-report` ist baubar
ORT: unbekannt
SOLL/FIX: Annahme: `bau/a9-s4-mess-report` ist baubar | Status: Zahl verifiziert (6/17/1940+), Bau nicht -- deshalb ##02 mit eigener Abnahme
STATUS LT. QUELLE: offen (benannte Annahme)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 097
GEGENSTAND: ANNAHME An-6: Doku-Drift nicht abgabekritisch ausser A9-Design Abschnitt 1 und der D5-3-Disposition
ORT: unbekannt
SOLL/FIX: Annahme: Doku-Drift nicht abgabekritisch ausser A9-Design Abschnitt 1 und der D5-3-Disposition | Status: beide in W0b/W1 adressiert
STATUS LT. QUELLE: offen (benannte Annahme)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 098
GEGENSTAND: ANNAHME An-7: prod1 traegt waehrend Bau- und Messfenster keine fremde Last
ORT: unbekannt
SOLL/FIX: Annahme: prod1 traegt waehrend Bau- und Messfenster keine fremde Last | Status: **angeordnet, nicht garantiert** -- Runner auf derselben Platte
STATUS LT. QUELLE: offen (benannte Annahme)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 099
GEGENSTAND: ANNAHME An-8: Alder-Lake-Consumer-Silizium hat AVX-512 abgeschaltet (D2-G5-Folge: 424 statt 428 Tests auf prod2)
ORT: unbekannt
SOLL/FIX: Annahme: Alder-Lake-Consumer-Silizium hat AVX-512 abgeschaltet (D2-G5-Folge: 424 statt 428 Tests auf prod2) | Status: ungemessen, weil prod2 nicht existiert; wird bei Existenz mit EINEM Kommando erhoben
STATUS LT. QUELLE: offen (benannte Annahme)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 100
GEGENSTAND: ANNAHME An-9: super-Zahlen 610/186
ORT: unbekannt
SOLL/FIX: Annahme: super-Zahlen 610/186 | Status: Agent-Behauptung aus dem super-Commit, **nicht nachgemessen** -- D1g misst sie; die Erklaerung (EXCLUDE_FROM_ALL vs. enable_testing-Reihenfolge) bleibt bis dahin offen
STATUS LT. QUELLE: offen (benannte Annahme)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 101
GEGENSTAND: ANNAHME An-10: HY-A-Aufwand ~3-4 AT im F8-Minimalschnitt
ORT: unbekannt
SOLL/FIX: Annahme: HY-A-Aufwand ~3-4 AT im F8-Minimalschnitt | Status: Planungsschaetzung ohne Objekt-Basis (Bestand = 1 README); WE-Option 22./23.08. ist die Deckung
STATUS LT. QUELLE: offen (benannte Annahme)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 102
GEGENSTAND: ANNAHME An-11: `.test`-Template-Befunde gelten fuer den Live-Stand
ORT: unbekannt
SOLL/FIX: Annahme: `.test`-Template-Befunde gelten fuer den Live-Stand | Status: erhoben am lokalen Klon `Cluster-ci-templates` (HEAD 5f9e04be, 27.07.), **nicht** am ref=development-Live-Stand
STATUS LT. QUELLE: offen (benannte Annahme)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 103
GEGENSTAND: ANNAHME An-12: Die defekt-1/2-CI-Aussagen (429 etc.) halten im echten Job
ORT: unbekannt
SOLL/FIX: Annahme: Die defekt-1/2-CI-Aussagen (429 etc.) halten im echten Job | Status: aus YAML + lokalem Nachbau der Job-Schritte, ohne Job-ID -- nach V-3 erst mit den W0a-Laeufen vollzogen
STATUS LT. QUELLE: offen (benannte Annahme)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 104
GEGENSTAND: ANNAHME An-13: Der Durchstich-Mini-Messwert ist mit D5-1-Kanon erhoben
ORT: unbekannt
SOLL/FIX: Annahme: Der Durchstich-Mini-Messwert ist mit D5-1-Kanon erhoben | Status: gesichert durch die Reihenfolge W0a-Lokalspur vor ##25; ohne diese Reihenfolge waere die erste Thesis-Zahl Ausschuss
STATUS LT. QUELLE: offen (benannte Annahme)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 105
GEGENSTAND: KURZFASSUNG IN ZEHN ZEILEN (Pfad fuellt 26 von 27 Werktagen; passt NUR mit Streichungen + 4 Bedingungen; sonst 5-6 Werktage hinter der Frist)
ORT: unbekannt
SOLL/FIX: ## KURZFASSUNG IN ZEHN ZEILEN

1. **W-1 (WE):** landen, neu erheben, und den Bauweg heilen -- `make check` 427->431, `make` 0->53 DLLs; v1 hatte dafuer Abnahmezeilen ohne Bau-Paket.
2. **W0a (2,5 T):** die Waage -- CI 429->431, die literal blinde Abdeckungs-Wache bekommt fremde Nenner (V-7), 27 unsichtbare gtest-Faelle (inkl. Welch) werden sichtbar, und der Perzentil-Kanon faellt VOR jeder Zahl.
3. **W0b (F1 14.08.):** kein Glied kann mehr still leer sein (Marker -> Inhalts-Gate -> persist -> Frische), der lebende Mess-Job kann rot werden -- und der **DURCHSTICH** legt einen echten Mini-Messwert bis in den Thesis-Anhang.
4. **W1 (F2 21.08. = FREEZE):** tote Reihen heissen nie wieder "gueltig, nicht signifikant"; Menge wird rechenbar UND deckelbar; par.59-SCHEMA; **HY-A** (Owner-KERN: Pflicht) im F8-Minimalschnitt; OV-4-Vorlage mit Zahlen.
5. **W2 (F3 28.08.):** EIN Bump-Buendel am Montag, danach NULL; Anker -> Kalibrierlauf durch die neuen Gates -> Bau 41,4 h ab Mi 06:00 (Kipp-Punkt) -> Zweitlauf -> USER-GO-VORLAGE.
6. **W3-MESS (F4 04.09.):** GO-Stopp; 320er -> gedeckelte Teilmatrix + **HY-B**; jeder Batch wird am Abend seines Tages entschieden -- heilbar via Resume statt unheilbar am 07.09.
7. **W4 (F5 11.09.):** Auswertung mit Nennern, **HY-C**-Router aus echten Kurven, Anhang gegen 28 Soll-Ziele, P-1 3/3. Do/Fr Fangnetz.
8. **W5:** PDF, Spiegel, Abgabe Di 15.09. Keine Bau-Eingriffe.
9. **Der Pfad fuellt 26 von 27 Werktagen und passt NUR mit den Streichungen (##40->W7, prod2->Text, Vollmessung->Deckel) und den vier Bedingungen: Deckel an F2, ein Bump, Batch-Abend-Ehrlichkeit, GOs bis Sa 29.08. 06:00.** Ohne die Schnitte endet er 5-6 Werktage hinter der Frist -- das ist die wichtigste Zahl dieses Dokuments.
10. **Ueber allem:** jede Wache mit fremdem Nenner und gefahrenem Koeder (rot UND gruen); jeder Freitag eine fuer sich stehende, ehrliche Lieferung; die drei Praesens-Zusagen erfuellt oder korrigiert -- still fallenlassen macht die Abgabe unwahr.
STATUS LT. QUELLE: nur-hinweis (Plan-Kern)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 106
GEGENSTAND: PLAN-BLOCK par.1 WO WIR STEHEN (verbatim, gelandeter Plan-Text)
ORT: docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md
SOLL/FIX: ## 1. WO WIR STEHEN

Alle Zahlen heute (08.08.) erhoben, Messaufbau: ce-Worktree `/home/comdare/wt-ce-fk` auf `b2daf9a6`, `git status --porcelain` vor UND nach allen Messungen leer; Probe-Baeume ausserhalb des Repos (`~/.claude/jobs/5a19728e/tmp/pass1-probe`, `pass1-only`; Logs `guard431.log` u. a.).

**Drei Nenner fuer dieselbe Behauptung "kein Test fehlgeschlagen":** Anwenderweg `make check` = **427**, CI `test:unit` = **429**, wahr = **431** (gemessen: 1 Configure -> 427; + `comdare_anatomy_codegen_cli`/`comdare_profile_run_facade` + Reconfigure -> 429; + `comdare_adhoc_emitter_cli` + Reconfigure -> 431; die vier Namen per `comm -13`: `f15_compare_cli_smoke`, `test_v41_anatomy_adhoc_autobuilt_load`, `test_v41_anatomy_f15_measurement`, `test_v41_anatomy_r5i_configure_codegen`). Auf `origin/development` ist `check: inventar` bereits gelandet (v1-E-1) -- aber `make` allein baut auch dort **0 von 53** Permutations-DLLs (kein zweites Configure in `all`), und die zwei `.gitlab-ci.yml`-Prebuild-Listen kennen den Emitter **0-mal** (`grep -c adhoc_emitter` = 0, Arbeitsbaum UND `origin/development`).

**Die Wache ueber den Zahlen ist literal blind:** `sh scripts/ci_test_coverage_guard.sh` gegen den **korrekten 431-Baum** gefahren -> Exit 0, "BILANZ: 431 von 431 ... GRUeN" (`guard431.log`). Sie prueft Selektor-Abdeckung (`-LE pmc`, Negativ-Selektor), nie Registrierungs-Abdeckung. Zusaetzlich: **27 gtest-Faelle** (`test_commands` 20 + `test_engine_adapters` 7) sind seit dem 21.05. in **jedem** Baum unsichtbar -- Binaries gebaut, Discovery gelaufen, keine `CTestTestfile.cmake` unterhalb `libs/` (12 von 1.226 Verzeichnissen tragen eine, keine unter `libs/`); darunter `WelchTTest.*` -- das Verfahren, das "signifikant schneller" entscheidet. Ehrlicher Gesamtnenner heute: **428 ctest-Eintraege lokal + 27 nie enumerierte Faelle = 455**.

**Der lebende Mess-Weg kann nicht rot werden:** der CEB-emittierte STUFE-3-Mess-Job liest `measure_out` an keiner Zeile zwischen `FAIL=0` (:1447) und `exit $FAIL` (:1528) und traegt das **einzige** `allow_failure: true` der Datei (:1394, Begruendung ist Agent-Behauptung ohne Owner-Wort). Das statische Existenz-Gate akzeptiert reproduzierte Kopfzeilen- und 0-Byte-CSVs (rc=0, heute gefahren); `persist:measurements` zaehlt Dateien statt Zeilen und macht das Phantom unter "Messdaten nie loeschen" **permanent**; der `anhang:forward`-Selektor (`*.result.csv`) trifft die Produktions-Ablage (`result.csv`) **nie** -- die Muster sind disjunkt, nachgemessen.

**Die Statistik erklaert tote Reihen fuer gueltig:** `welch_t_test.hpp:130-136` (se<=0 -> t=0, p=1.0, `valid=true`), `mann_whitney_u_test.hpp:90/:92` (`valid=true` VOR dem Guard), `multi_compare.hpp:75/:83` (p=1.0 in die Bonferroni-Familie; `win_rate`-Nenner enthaelt Ungetestetes), `result_aggregator.hpp:86` (`success = !empty` -- 32 Nullen = success), `drift_detector.hpp:69-72/:122/:128` (median<=0 -> drift=0.0 = Minimum -> der Rerun-Loop endet **bevorzugt auf der kaputten Gruppe** mit `stable=true`). Perzentile: **2** Definitionen, beide faelschlich "Nearest-Rank" benannt, in 4700/9998 Probefaellen verschieden; A's p99 == max fuer n<=100 trifft 2 von 3 write-Checkpoints der Default-Konfiguration. Median: **5** Implementierungen, **3** Antworten (20/25/30 auf {10,20,30,40}); die Zahl der Sieger-Kuerung ist bei geradem n eine andere als die in der LaTeX-Tabelle (`best_binary_selector.cpp:183-188` sagt es selbst: "REV-DATA-12 (offen)").

**Menge und Maschine:** `--check-size` und `<measure_selection>` = 0 Treffer (beide Repos); die einzige Rechnung fuer die Voll-Matrix: **~143 Tage einthreadig als Untergrenze** (0,1094 s ist doppelt als Untergrenze markiert, Spanne Faktor 69). Bau des Bestands: **128 x 19,4 min ~ 41,4 h** auf prod1 allein. `getent hosts prod2` -> rc 2, waehrend `05_evaluation.tex:78-79` den Zwei-Maschinen-Betrieb im Praesens zusagt. prod1: `/` zu 83 % voll, 43 G frei, Runner id=16 auf derselben Platte, concurrent=2; jede Permutations-TU 523 MB MaxRSS.

**HYBRID:** Owner-KERN 08.08. "ALLES PFLICHT" -- Bestand: `git ls-tree origin/development libs/cache_engine/hybrid/` = **genau `README.md`**.

**Fenster:** 27 Werktage + 11 Wochenendtage, **5 Freitage** (14.08. * 21.08. * 28.08. * 04.09. * 11.09.), Abgabe **Di 15.09.** Arbeitsbaum 29 Commits hinter `origin/development` -> W-1 landet und erhebt neu.

**In einem Satz:** von der Kette **[PLANER] -> [CEB] -> [HYBRID] -> [TIER]** traegt heute genau ein Glied (der TIER laeuft); die Beweis-Maschinerie darueber luegt mit drei verschiedenen Nennern, das Statistik-Glied adelt tote Messreihen, das dritte Glied existiert als README -- und die Abgabe verspricht im Praesens drei Dinge, die der Code nicht haelt.

---


STATUS LT. QUELLE: nur-hinweis (Plan-Struktur, im Repo gelandet)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 107
GEGENSTAND: PLAN-BLOCK par.3 WELLENSYSTEM (W-1..W7, F1-F5-Definitionen) (verbatim, gelandeter Plan-Text)
ORT: docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md
SOLL/FIX: ## 3. DAS WELLENSYSTEM

**Betriebsregeln ueber allen Wellen:** EIN-BLECH-REGEL (max. ein Pipeline-Abnahme-Paket zur Zeit; zweiter Slot nur lokal; Bau und Kampagne exklusiv). Jede Wellen-Abnahme traegt Nenner, Rot- UND Gruen-Lauf mit frisch gewuerfeltem Koeder (K13); eine Welle ohne beissende Wache gilt als nicht abgenommen (V-6, jetzt beidseitig). Abgabefaehigkeits-Minimum: jeder Freitag steht allein.

```
15.09. Di   ABGABE
11.09. Fr   F5  PDF final, Anhang gegen Nenner, P-1 3/3          <- LETZTE LIEFERUNG
04.09. Fr   F4  Kampagne gemessen + Rueckschrieb mit Substanz
28.08. Fr   F3  Bestand gebaut + USER-GO-VORLAGE                  <- danach NULL-Bump
21.08. Fr   F2  Statistik-Kanon + Menge rechenbar + HY-A          <- IDENTITAETS-FREEZE
14.08. Fr   F1  Nenner-Ehrlichkeit + DURCHSTICH (Messwert im Thesis-Submodul)
```

### W-1 -- LANDUNG + BAUWEG-WAHRHEIT * Sa 08.08.-So 09.08. (Reserve-Entnahme 2 WE-Tage)

Posten: ##01 (Merge `origin/development`, nie rebase; 29->0, beide Zahlen), ##02 (A9-S4 landen: 6 Commits, 17 Dateien), ##03 (Diff-Neuerhebung, Erhebungs-SHA je Zeile), **D1+D1a+D1d in EINEM Commit-Bogen** (auf dem Landestand neu erhoben: `check: inventar` ist dort vermutlich Verifikation, `make`-allein = 0/53 DLLs bleibt Bau), ##04 (baremetal literal), ##05 (ctest -N vor/nach Reconfigure -- jetzt MIT Bau-Paket).
**Parallelitaet 1** (jede Landung aendert die naechste Erhebung; Gruen-Pruefung belegt den einzigen Runner). **Blockiert durch:** nichts.

### W0a -- DIE WAAGE * Mo 10.08.-Mi 12.08. mittags (2,5 AT; v1 sagte 0,5 -- real 14 Pakete)

Blech-Strang (seriell): **D2-G4 zuerst** (Text), **D1e -> D1b** (Reihenfolge zwingend), D1f, D1c (Vollausbau; Floor-Variante nur als benannte Rueckfallstufe), D1g (Configure-Paar entscheidet die super-Frage), D2, D2-G2 (im D2-Bogen), D2-G3, D2-G6, ##06 (korrigierte Formel), ##07. Lokalspur: **D2-G1** (27 Faelle sichtbar + Erstlauf), **D5-1** (Perzentil-Kanon -- vorgezogen, damit ab Mi 12.08. jede Zahl kanonisch ist).
**Parallelitaet 2**, festgemacht an: CI-Verdikt-Pakete teilen den EINEN Runner-Strang seriell; gtest-Sichtbarmachung, Textkorrekturen und D5-1 sind rein lokal (Header + 34 Aufrufer + ctest lokal).
**Blockiert durch:** W-1 (alle Zeilennummern gegen Landestand, K10).

### W0b -- DIE NAeHTE + DURCHSTICH * Mi 12.08. mittags-Fr 14.08. = **F1**; Nachlauf ##27-##31 bis Di 18.08.

Kern-Kette: **##08 zuerst** (`lazy_csv_header` EINMAL -- Spaltenvertrag, Header = Resume-Schluessel; Schema-Freeze Stufe 1), **D3-7 -> D3-1 -> D3-2 -> D3-3 -> D3-4+D3-5 -> D3-8**, D2-G5, ##26 (korrigierte Formel). Transport: **##20+D3-6 als EIN Paket** (AF_GENERATOR belegen UND Selektor trifft beide Layouts -- einzeln geheilt bleibt der einzige Transport zu), ##21, ##22, ##23 (NAHT, eigener Besitzer), **##25 DURCHSTICH** (frischer Mini-Lauf, 1 Binary, 1 Perm, Minuten). Nachrangig: ##24 (A9-S5a -- faellt zuerst bei Riss), F-13. Nachlauf bis Di 18.08.: ##27-##30, ##31 (Wachen-Register: Grundmenge = alle `.sh` beider Repos + verdiktdruckende Jobs **+ ctest-Tests mit `PASS_REGULAR_EXPRESSION`** -- neue Klasse aus dem D4-Querbefund; Koeder GEFAHREN; Rueckfallstufe bei Riss: manuell versioniert + die je D-Posten gefahrenen Koeder-Protokolle).
**F1-Lieferung:** kein Glied kann mehr still leer sein, UND ein am Mittwoch frisch gemessener Mini-Messwert liegt am Freitag als Tabellenzeile im Thesis-Submodul (Kette: Lauf-Marker -> Inhalts-Gate -> persist-Commit -> xlsx im Realm-Baum -> `anhang:forward` -> PDF baut; jede Stufe druckt ihren Nenner).
**Parallelitaet 2:** Helfer/Unit-Koeder lokal; nur die CI-Beweislaeufe seriell.
**Blockiert durch:** W0a; Owner-Entscheide OV-16 (allow_failure) und OV-17 (result.csv-Konvention) bis Mi 12.08.

### W1 -- STATISTIK-GLIED + MENGE + HY-A * Mo 17.08.-Fr 21.08. = **F2 = IDENTITAeTS-FREEZE**

Statistik: **D4a -> D4b -> D4c** (Reihenfolge zwingend, D4c ist vorher blind), **D4d** (die EINE Spaltenaenderung der Woche, danach Header-Freeze Stufe 2), D4e (nach ##07), D4f (nach OV-6-Lage), D5-3 -> D5-2, D5-4, D5-5. Menge: ##10+##10b (`--check-size`, zwei Zahlenreihen + EIN gemessener Punkt bei working_set 8.388.608), ##11 (`<measure_selection>`), ##12, ##13 (G3-Split), ##14 (**Sperrlisten-Wache = Freeze-Gate**, maschinell aus `kAnatomyFingerprintGliedCount = 9`), ##15 (par.59-SCHEMA als hartes W3-MESS-Vor-Gate; EMITTER/TEMPLATE bei Slack), ##16+##17 (nach OV-1), ##19, ##09 (nachrangig). **HY-A1-A3** (nach OV-13-Bestaetigung + OV-12 + 4.-Ebenen-Entscheid Mi 19.08.): Gattung `HEURISTIK-ADAPTER`/Genus `Function-Interface-Reroute` -- `hybrid_dock_contract` + `hybrid_pruef_dock` + factory/array (CT-Interface-Vererbung, `variant` NUR im DockSlot), `hybrid_binary_proxy` + `hybrid_tier_module.cpp` (4 ABI-Pflicht-Symbole) = **F8-Minimal-DoD** (genau 1 Standard-Dock, ctest-bewiesen, Reroute auf 2 plain-Tier-Ziele), `<hybrid_tier>`-Parser + Heuristik-Hybrid-Achse in die Registry (22->23, beide Zahlen) + Fehlerklassen. Abgabe-Vorlauf: ##42, ##43, ##44, ##45. **Entwicklung** (nicht Landung) der W2-Landepakete: ##32, ##33, ##35, ##36 (T-15+D4), ##37, ##38, ##39. **An F2:** OV-4-Deckel-Vorlage MIT beiden `--check-size`-Zahlenreihen beim Owner.
**Sa 22./So 23.08. = benannte Entnahme-Option NUR fuer HY-A-Fertigstellung.**
**Parallelitaet 2:** Statistik-Header + HY-A sind rein lokal (CT); Mengen-/CI-Pakete buendeln ihre Beweislaeufe seriell.
**Blockiert durch:** W0b (F1); OV-13/OV-12 (Owner); OV-1/OV-6 fuer ##16/##17/D4f.

### W2 -- EIN BUMP, ANKER, BAU * Mo 24.08.-Fr 28.08. = **F3**

**Mo:** das EINE Lande-Ereignis -- Bump-Buendel ##32+##33+**##34** (genau EIN Magic-Wechsel 4->5 im Gesamtfenster, **HY-Ebenen-Entscheid eingerechnet** -- bei "hybrid-lokal" bleibt HY ausserhalb des Stempels; nach dem Buendel-Tag gilt **NULL-Bump-Wache** bis zur Abgabe), ##35 (Resume-Beweis: Abbruch nach 2 Batches, Neustart ueberspringt), **##36 = T-15 verdrahten MIT D4 als Schritt 1** (nie eines ohne das andere; Rerun-Deckel gesetzt, Rerun-Rate wird im Kalibrierlauf erhoben), ##37, ##38 (klein), ##39, ##41. **Di:** ##46 (Anker + TP1-FINAL, drei Spiegel), ##47 (Kalibrierlauf `GN_TOTAL=64` -- **faehrt durch alle W0b-Gates**, erster Ernstfall der Messweg-Ehrlichkeit; Menge unabhaengig per Teilbaum-Auszaehlung, Einwand 29), ##48 (par.66 G1-G5 + **Platten-Budget: benoetigt_GB und frei_GB BEIDE gedruckt VOR dem Trigger** -- 43 G frei bei 83 %), ##41b (gefahrene Kaskade Parent/Child/Grandchild mit Job-IDs -- und dank D3-4 kann der Grandchild jetzt **rot** werden, sonst ist die Kaskade kein Beleg). **Mi 26.08. 06:00:** ##49 Bau-Trigger (~41,4 h = 128 x 19,4 min; **KIPP-PUNKT**: spaetester tolerierbarer Start Fr 28.08. 06:00, danach faellt das W4-Fangnetz -- steht dann als Zahl im Protokoll). **Do abends:** Bau fertig, ##50 Zweitlauf (`built_new==0`, `lager_skip==N`, `skip_ohne_testlog==0`). **Fr:** ##51 USER-GO-VORLAGE (EINE Datei: 320er + gedeckelte Teilmatrix via `<measure_selection>` MIT Zahlen, HY-B-Teilmatrix daneben, prod2-Entscheid eingearbeitet) = **F3**. `ergebnis:holen` wird scharf (D3-8 steht seit W0b).
**Parallelitaet 1** (strikte Kette; waehrend des Bau-Fensters 0 CI-/Agenten-Last auf prod1, Thesis-Text nur via Overleaf-Remote).
**Blockiert durch:** W1 vollstaendig (Freeze steht, Sperrlisten-Wache gruen); OV-2/OV-3 (Null-Bump-Umfang/4. Ebene); W0b-Nachlauf abgenommen (sonst kalibriert ##47 ueber ungehaerteten Gates).

### W3-MESS -- DIE KAMPAGNE * Sa 29.08. 06:00-Do 03.09.; Rueckschrieb Fr 04.09. = **F4** * USER-GO-STOPP davor

##52 (Vor-Gate par.59-SCHEMA + **zwei getrennte GOs**), ##53 (320er zuerst, dann gedeckelte Teilmatrix; **je Batch am Abend entschieden**: Bilanz `A+B==C`, Inhalts-Gate mit Marker, Frische `csv_dieser_lauf>=1` -- ein Fehllauf wird am Abend seines Tages sichtbar und via Resume geheilt, nicht am 07.09. entdeckt), **HY-B** (Hybrid-Overhead-Kampagne: Stub-Heuristik am Hybrid-Pruefdock, Reroute-Overhead zu multiplen Tier-Zielen, eigene kleine Teilmatrix -- die 4. Mess-Ebene liefert ihre Pflicht-Zahlen), ##54 (Auswertung NUR in Batch-Pausen, par.61), ##55 (L3-Asymmetrie prod1-eigen: 2x128 MiB CCD, braucht kein prod2), ##56 (Rueckschrieb WRITE-Token/NAS/minio inkl. xlsx; Commit nur bei `datenzeilen_gesamt>=1`, Zahl in PROVENANCE). ETA-Deckel 4,5 Maschinentage + 30 h Marge; **Sa 05./So 06.09. = benannter Resume-Puffer** (Entnahme wird gebucht).
**Parallelitaet 1** (Messung haelt das Blech exklusiv -- fremde Last kontaminiert Latenzen, und kontaminierte Daten sind die unheilbare Klasse; menschliche Textspur via Overleaf).
**Blockiert durch:** W2 (F3); **beide GOs bis Sa 29.08. 06:00** (OV-15; jeder Verzugstag frisst 1:1 Fenster).

### W4-AUSWERTUNG -- ZAHLEN + TEXT + HY-C * Mo 07.09.-Mi 09.09. Kern; Do 10./Fr 11.09. Fangnetz; Fr 11.09. = **F5**

##57 (Break-Even auf dem D4f-Typ: "kein Break-Even bestimmbar" != "bestimmt: keiner", zwei verschiedene Ausgaben -- heute byte-gleich; Umfang gemaess OV-1/OV-6), **HY-C** (`hybrid_router` als Break-Even-CoR aus den HY-B/W3-Kurven + `hybrid_eviction`-Minimalstrategie + EIN belegter Routing-Fall im Text; Koeder: nirgends kreuzende Kurven -> `kein_schnittpunkt` + Rueckfall auf direkten Tier-Aufbau, ungueltige Kurve -> `kurve_ungueltig`), ##58+##58b (Anhang-Wache: 28 `\InputIfFileExists`-Ziele gegen wirklich gefundene Dateien, beide Zahlen; `\thesisfinal` macht Ersatztext zum LaTeX-Fehler; `|| echo honest-empty` faellt ersatzlos), ##59 (FF0-FF4, Nenner 5, leere Frage = rot), ##60 (Ergebniskapitel C5: Zahlen ins ##44-Geruest, jede Tabelle mit Lauf-Provenance; DE fuehrt, EN zieht fuer beruehrte Kapitel nach), ##61 (Backups sofort), **P-1** (Praesens-Zusagen-Wache: `geprueft 3 / erfuellt-oder-korrigiert 3` -- Zwei-Maschinen KORRIGIERT per OV-5, Resume ERFUeLLT per ##35, Konformitaet ERFUeLLT per perm_runner/OV-8).
**Parallelitaet 2** (Auswertung und Text dateidisjunkt; keine Bau-Abnahmen mehr auf dem Blech). Fangnetz Do/Fr: Auswertungs-Verzug ODER Teil-Nachmessung via Resume (max. 2 Tage + WE 12./13. als letzte Entnahme).
**Blockiert durch:** W3-MESS (mindestens die 320er-Abgabemessung; HY-C konsumiert die HY-B-Kurven -- deshalb stand der Router nie in W1).

### W5-SICHERUNG * Sa 12.09.-Di 15.09. (Abgabe Di)

##62: PDF aus sauberem Checkout (`-halt-on-error`, Warnings <= 1, `.blg` alphadin), Anhang **gegen Nenner** belegt, DE/EN der beruehrten Teile konsistent, Spiegel GitHub/GitLab synchron, Overleaf-Identitaet, Desktop-Backup, Abgabe-Logistik Di VOR Dienstschluss. **Keine Bau-Eingriffe.**

### W7 -- NACH DER ABGABE (Behaelter)

par.75-Aufraeumpass (104 offen) * ##40-Restbau (T-06...T-14, W-03, W-08, A14, A10) * HY-Vollausbau (Heuristik-Familie, Mehrfach-Aufbau, scharfe Eviction, Paper-gekoppelte Heuristikwahl) * `checkpoint_measure` (OV-2b bestaetigt) * Record-and-Replay * Paper-Kopplung (OV-14) * prod2-Lane/pmc:intel/P-E-Trennung * D1c-Ausbau falls Floor-Rueckfall gezogen wurde * B-Spline (je nach OV-1) * Voll-Messung als Kampagnen-Programm * PV-1 * Doku-Anker-Sanierung.

---


STATUS LT. QUELLE: nur-hinweis (Plan-Struktur, im Repo gelandet)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 108
GEGENSTAND: PLAN-BLOCK par.4 SEQUENTIELLE AUFGABENKETTE (verbatim, gelandeter Plan-Text)
ORT: docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md
SOLL/FIX: ## 4. DIE SEQUENTIELLE AUFGABENKETTE

Fuer EINE Instanz, ohne Ruecksprung lesbar. `[R]` = Reserve-Entnahme. `[lok]` = rein lokale Abnahme (zweiter Slot erlaubt), `[CI]` = Pipeline-Abnahme (Ein-Blech-Regel: seriell).

```
=== W-1  Sa 08.08. - So 09.08.  [R: 2 WE-Tage] ==================================
 01  [CI]  Merge origin/development (29 -> 0, beide Zahlen). Landestand-SHA.
 02  [CI]  A9-S4 landen (6 Commits, 17 Dateien; Pipeline gruen).
 03  [lok] Diff A.1-A.5 NEU erheben, Erhebungs-SHA je Zeile.
 D1+D1a+D1d [CI, EIN Commit]  Reconfigure in check UND all; 427->431; 0->53 DLLs;
     Guard-Kopf '404 statt 406' korrigiert; Koeder-Rotlaeufe protokolliert.
 04  [lok] baremetal './configure.sh && make && make check' literal: 'out of 431'.
 05  [lok] ctest -N vor/nach Reconfigure: 427/431 + Differenz + 4 Namen.

=== W0a  Mo 10.08. - Mi 12.08. mittags ==========================================
 D2-G4 [lok] Abnahmetext ##06 korrigieren (erfuellt ODER Allowlist) VOR jedem Bau.
 D1e  [CI]  f15-CLI: Baukante + cmake-P-Wrapper (Exit zaehlt) + TIMEOUT gemessen.
 D1b  [CI]  Prebuild-Liste + Emitter: test:unit 429 -> 431, Job-ID + Gate-Zeile.
 D1f  [lok] 5 STATUS_OUT / 3 Zustaende; ERROR-Pfad FATAL (super-Kontext SKIPPED ok).
 D2   [CI]  Untergrenze (floor.txt) + covguard-Prebuild + Allowlist + Log-Artefakt.
 D2-G2[CI]  im D2-Bogen (sonst faellt test:unit rot).
 D2-G3[lok] '==' wird Vergleich; 2>/dev/null faellt (K11: Datei statt Pipe);
            declared:VAR zaehlt ungeprueft.
 D2-G6[lok] Registry-Gates Pflicht-Erwartung; Stash-Koeder = Standard-Bissprobe.
 D1c  [CI]  Wache Vollausbau: 3 Zahlen (eigen/Job-Artefakt/Gates), N!=M rot,
            fail-closed; Zahl-Koeder 345 rot. [Rueckfall bei Riss: Floor-Variante]
 D1g  [lok] super-Configure-Paar: 610er-Frage MESSEN (EXCLUDE_FROM_ALL vs.
            enable_testing-Reihenfolge), Ergebnis in den Makefile-Kommentar.
 D2-G1[lok] 27 gtest-Faelle sichtbar (2 add_test statt discover); Erstlauf ehrlich
            gebucht; rote Faelle = Befund, KEIN allow_failure.
 D5-1 [lok] PERZENTIL-KANON: Lehrbuch-Formel; nearest_rank_p GELOESCHT (34 Stellen
            brechen laut); Pin 51->50; Seed-Test + Mutations-Koeder rot gefahren.
 06/07[CI]  Vorlagen-Pakete in korrigierter Form.

=== W0b  Mi 12.08. mittags - Fr 14.08. (F1); Nachlauf bis Di 18.08. =============
 08   [lok] lazy_csv_header EINMAL (B-3). SCHEMA-FREEZE STUFE 1.
 D3-7 [lok] Lauf-Marker neben jeder CSV; fehlt = rot; prune_only schreibt einen.
 D3-1 [lok] ci/measure_csv_gate.sh: 3 Zahlen, awk, N==0 rot, Marker-Auswertung.
 D3-2 [lok] smoke-Stelle auf denselben Helfer (danach grep 'test -n "$(find' == 0).
 D3-3 [CI]  persist: Zeilen statt Dateien; leer = KEIN Commit (Git-Zustand-Beweis).
 D3-4+D3-5 [lok+1 CI-Beleg] lebender Mess-Job: Inhalts-Gate je Batch; Testat-XOR;
            Bilanz A+B==C; allow_failure gemaess OV-16; Byte-Determinismus-Tests
            im selben Commit.
 D3-8 [lok] Frische-Kennung (PIPELINE_ID); Altbestand gemeldet, nie geloescht.
 D2-G5[lok] Host-Klassen-Bericht (6 AVX-Registrierungen, 3 Zahlen immer gedruckt).
 20+D3-6 [CI, EIN Paket] anhang:forward: AF_GENERATOR belegt UND Selektor findet
            BEIDE Layouts; NO-OP nur mit Nenner. P1/P2/P3 gefahren.
 21   [CI]  Realm-Wurzeln /mnt + G-E3 + COMDARE_BESTANDSLOG in beiden CI.
 22   [CI]  persist um *.xlsx; F-15 Schwere-Stufe.
 23   [lok] NAHT: echte Mess-CSV -> xlsx im Realm-Baum; Zeilenzahl je Blatt gegen
            Eingangs-CSV; SKIP-Zweitlauf geschrieben==0/uebersprungen==N.
 25   [CI]  DURCHSTICH: Mini-Lauf (1 Binary, 1 Perm) -> Marker -> Gate -> persist
            -> xlsx -> anhang:forward-Commit im Thesis-Submodul -> PDF baut.  = F1
 24   [lok, nachrangig] A9-S5a gegen 06.06.-Archiv.       F-13 [CI] super-Wache.
 27-31[CI, Nachlauf bis Di 18.08.] Diff-Wache/Allowlist/lint/parity/REGISTER
            (Grundmenge inkl. PASS_REGULAR_EXPRESSION-Tests; Koeder GEFAHREN).

=== W1  Mo 17.08. - Fr 21.08. (F2 = FREEZE) =====================================
 D4a->D4b->D4c [lok] Degenerations-Kette; Invarianz-Beweis 7-vs-9.
 D4d  [lok] success-Schaerfung = EINZIGE Spaltenaenderung der Woche. FREEZE ST. 2.
 D4e  [lok] f15-Summenzeile + Exit; Muster auf Zahlen-Zeile.
 D5-3 [lok] Vorlage-/Dispositions-Korrektur (lebende Werkzeuge, Anker 653-659).
 D5-2 [lok] Median-Kanon ueber ce+super (Kreuz-Test gerade Laenge, Seed gedruckt).
 D5-4 [lok] delete_p99_ns + EIN geteilter Helfer + Schema-Test beidseitig.
 D5-5 [lok] HDR entscheiden (0-ns-Zaehler, Toleranz hergeleitet). [rutschfaehig]
 10+10b [lok+1 Lauf] --check-size: 2 Zahlenreihen + Messpunkt working_set 8388608.
 11   [lok] <measure_selection>: Schema+XSD+Validator+Teilmengen-Garantie.
 12   [lok] configure --enable-X=no; 5 XMLs wohlgeformt (2 generiert).
 13   [CI]  G3 aus dem STATISTICS-Gate (7. Feld mess_gates_glied).
 14   [CI]  Sperrlisten-Wache maschinell (9 Glieder; 10. Glied -> rot). FREEZE-GATE.
 15   [lok] par.59-SCHEMA golden-neutral (EMITTER/TEMPLATE nur bei Slack).
 16+17[lok] Break-Even-Kanon + Serialisierung gemaess OV-1.
 D4f  [lok] Break-Even-Statustyp (falls OV-6 Definition steht; sonst Typ-Vorbereitung).
 19   [lok] LaTeX-Auswertungs-Emitter.       09 [lok, nachrangig] amd_l3-Teil.
 HY-A1[lok] Dock-Contract/Pruefdock/Factory/Array (CT, variant nur im DockSlot).
 HY-A2[lok] F8-MINIMAL-DoD: 1 Standard-Dock + Proxy + tier_module, ctest-bewiesen.
 HY-A3[lok] <hybrid_tier>-Parser + Achse in Registry (22->23) + Fehlerklassen.
 32/33/35/36/37/38/39 [lok] ENTWICKLUNG der W2-Landepakete (Landung erst Mo 24.).
 42/43/44/45 [lok] FF-Matrix anlegen, .ps1/.py-Abloesung, C5-Geruest, Thesis-Spur.
 Fr 21.08.: OV-4-VORLAGE mit beiden Zahlenreihen an den Owner. FREEZE.
 [R-Option: Sa 22./So 23. NUR HY-A]

=== W2  Mo 24.08. - Fr 28.08. (F3) -- strikt seriell =============================
 Mo:  32+33+34 [CI] BUMP-BUENDEL: genau EIN Magic-Wechsel (HY-Ebene eingerechnet);
      danach NULL-BUMP-WACHE. 35 [CI] Resume-Beweis (Abbruch nach 2 Batches).
      36 [CI] T-15 verdrahtet MIT D4 (2 degenerierte Zellarten, getrennt gezaehlt;
      Rerun-Deckel). 37/38/39/41 [lok/CI klein].
 Di:  46 [lok] Anker 3 Spiegel. 47 [CI] Kalibrierlauf GN_TOTAL=64 DURCH die
      W0b-Gates; Menge unabhaengig ausgezaehlt; Rerun-Rate erhoben.
      48 [lok] par.66 G1-G5 5/5 + Platten-Budget (benoetigt/frei BEIDE gedruckt).
      41b [CI] Kaskade Parent/Child/Grandchild, Job-IDs; Grandchild kann ROT.
 Mi 06:00: 49 BAU-TRIGGER (~41,4 h). 0 CI-/Agenten-Last. KIPP-PUNKT-Regel aktiv.
 Do abends: Bau fertig. 50 Zweitlauf (3 Zahlen, skip_ohne_testlog==0).
 Fr:  51 USER-GO-VORLAGE (EINE Datei, Deckel-Zahl, HY-B-Teilmatrix). = F3.
      ergebnis:holen scharf (Frische-Wache steht).

=== W3-MESS  Sa 29.08. 06:00 - Do 03.09.; Fr 04.09. Rueckschrieb (F4) ===========
 52  Vor-Gate par.59-SCHEMA + zwei GOs (Datum im Protokoll).
 53  320er -> gedeckelte Teilmatrix. JE BATCH am Abend: A+B==C, Inhalts-Gate mit
     Marker (provision-only bleibt gruen), Frische csv_dieser_lauf>=1.
 HY-B Overhead-Teilmatrix (Stub-Heuristik, Reroute zu multiplen Zielen, n je Zelle,
     degeneriert-Zaehler im Report).
 54  Auswertung NUR in Batch-Pausen.   55  L3-Asymmetrie (prod1-CCDs).
 56  Rueckschrieb Fr 04.09.: WRITE-Token, NAS+minio, xlsx; Commit nur bei
     datenzeilen_gesamt>=1; PROVENANCE traegt die Zahl. = F4.
 [R-Option: Sa 05./So 06.09. Resume-Puffer]

=== W4-AUSWERTUNG  Mo 07.09. - Fr 11.09. (F5) ===================================
 57  Break-Even auf D4f-Statusraum (zwei verschiedene Antworten gedruckt).
 HY-C Router aus HY-B-Kurven + Eviction-Minimal + EIN belegter Routing-Fall.
 58+58b Anhang-Wache 28 Ziele beidseitig; thesisfinal; honest-empty faellt.
 59  FF0-FF4 (5/5, leere Frage rot).   60  C5-Zahlen ins Geruest, Provenance.
 61  Backups sofort.   P-1  Praesens-Wache 3/3. Do/Fr = Fangnetz. Fr = F5.

=== W5  Sa 12.09. - Di 15.09. ===================================================
 62  PDF sauberer Checkout; Anhang gegen Nenner; Spiegel; KEINE Bau-Eingriffe.
     ABGABE Di 15.09.
```

---


STATUS LT. QUELLE: nur-hinweis (Plan-Struktur, im Repo gelandet)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 109
GEGENSTAND: PLAN-BLOCK par.5 KRITISCHER PFAD (verbatim, gelandeter Plan-Text)
ORT: docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md
SOLL/FIX: ## 5. DER KRITISCHE PFAD

`##01 -> ##02 -> D1+D1a (W-1) -> D2-G4 -> D1e -> D1b -> D1f -> D1c -> D2+D2-G2 -> D2-G1 -> D5-1 (W0a) -> ##08 -> D3-7 -> D3-1 -> D3-3 -> D3-4+D3-5 -> ##20+D3-6 -> ##23 -> ##25 DURCHSTICH (F1) -> D4a->D4b->D4c -> D4d -> ##10+##10b -> ##11 -> ##13 -> ##14 -> ##15 -> HY-A1->A2->A3 (F2/FREEZE) -> ##32/##33/##34 Bump-Buendel -> ##35 -> ##36 (T-15+D4) -> ##46 -> ##47 -> ##48 -> ##49 Bau 41,4 h -> ##50 -> ##51 (F3) -> GOx2 -> ##53+HY-B -> ##56 (F4) -> ##57/HY-C -> ##58/##58b -> ##59 -> ##60+P-1 (F5) -> ##62.`

**Die Rechnung.** Verfuegbar: 27 Werktage + 11 WE-Tage. Der Pfad belegt: 2 WE-Tage (W-1) + 2,5 AT (W0a) + 2,5 AT (W0b) + 5 AT (W1) + 5 AT (W2, davon ~1,7 AT reine Bau-Wartezeit, in der nur Text/lokale Pakete laufen) + 5,75 Maschinentage Kampagne (davon 4 im WE/regulaeren Lauf ohne Personal-Bindung, Batch-Abnahmen abends) + 1 AT Rueckschrieb + 3 AT Auswertung + 2 Fangnetz-Tage + 2 AT Sicherung ~ **26 von 27 Werktagen**. Rest-Reserve: **1 Werktag + ~7 WE-Tage** (2 entnommen W-1, 2 Option HY-A, 2 Option Resume-Puffer).

**Die Defizit-Arithmetik (Planungsschaetzung, als solche gekennzeichnet):** v1 verplante 26/27 WT ohne die Defekt-Familien. Die ~76 h Defekt-Pflicht (~ 9,5 WT) plus HY-A/B/C im F8-Minimalschnitt (~3-4 AT, **Schaetzung ohne Objekt-Basis**, An-10) werden gedeckt durch ~10-11 WT gestrichenes v1-Bauprogramm (##40-Restbau, prod2-Posten, F-07b, ggf. Break-Even-Neubau, ##15-EMITTER/TEMPLATE, Register-Vollautomation als Rueckfallstufe). **Saldo ~ 0 bis ?1 WT.**

**Passt er?** **Nur unter vier Bedingungen**, und das ist die wichtigste Aussage dieses Dokuments: (1) der OV-4-Deckel faellt an F2 mit den ##10-Zahlen; (2) es gibt genau EINEN ABI-Bump (Mo 24.08.), danach null; (3) Messfehler werden je Batch am selben Abend sichtbar (W0b-Gates), sodass das Fangnetz einen TEIL-Nachlauf via Resume tragen kann; (4) beide GOs fallen bis Sa 29.08. 06:00. **Faellt eine der vier, reisst der Pfad.** Mit dem vollen v1-Programm PLUS Defekt-Pflicht PLUS HY laege das Ende rechnerisch **5-6 Werktage hinter dem 15.09.** -- deshalb sind die Streichungen in Abschnitt 7 keine Kuer, sondern die Rechnung. Der Bau-Start Mi 26.08. 06:00 ist der Kipp-Punkt: spaetester tolerierbarer Start Fr 28.08. 06:00, dann faellt das W4-Fangnetz ersatzlos und wird als Zahl protokolliert, nicht als Hoffnung.

---


STATUS LT. QUELLE: nur-hinweis (Plan-Struktur, im Repo gelandet)
ABHAENGIGKEIT/FLAECHE: -

### [w2mylldp8.json] 110
GEGENSTAND: PLAN-BLOCK par.6 VERIFIKATIONSVERTRAG (verbatim, gelandeter Plan-Text)
ORT: docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md
SOLL/FIX: ## 6. DER VERIFIKATIONSVERTRAG

Vier Formen von Schein-Gruen sind belegt (uebersprungener Job, Nenner 0, Koeder der nie anschlug, Gate das nie aufging) -- plus die in dieser Runde gemessene fuenfte: **die Wache, die mit sich selbst einig ist** (`guard431.log`: "431 von 431 GRUeN" ueber dem eigenen Baum, blind fuer den Job-Baum). Der Vertrag schliesst die Klasse aus.

**Vertragszeilen (V-1 bis V-5 unveraendert aus v1; V-6 verschaerft; V-7 neu):**

| # | Regel |
|---|---|
| V-1 NENNER | Jede Wache druckt ihre Grundmenge und prueft sie. Nenner 0 = Exit != 0, nie GRUeN. |
| V-2 KOeDER BEIDSEITIG | Zufaellig erzeugt (K13), Rot-Lauf VOR der Heilung protokolliert; Gegenkoeder: unmanipulierter Lauf bleibt gruen (eine Wache, die immer rot ist, ist keine Wache). |
| V-3 GATE-VOLLZUG | Job-ID + Log-Zeile eines gefahrenen Laufs. YAML-Absicht zaehlt nicht. |
| V-4 DIFFERENZ-BELEG | Zwei Zustaende, beide Zahlen ausgegeben -- auch die vorher. |
| V-5 DUAL-WEG (par.61) | CI und baremetal, beide literal. |
| **V-6 PLAN-NENNER, beidseitig** | Abnahme-Nenner = Paketzahl; Paket ohne Abnahmezeile **UND Abnahmezeile ohne Bau-Paket** = Welle nicht abgenommen (v1 verletzte die zweite Richtung bei ##04/##05). |
| **V-7 FREMDER NENNER** *(neu, aus D1c/D2)* | Eine Wache, die zwei Zahlen vergleicht, bezieht mindestens eine aus einer **anderen** Quelle als sich selbst (Job-Artefakt, committete Untergrenze, maschinelle Quell-Auszaehlung). Selbst-Inventur gegen Selbst-Selektor ist kein Vergleich. |

**Wachen-Register (##31):** Grundmenge = alle ausfuehrbaren Dateien unter `ci/`+`scripts/` beider Repos + alle verdiktdruckenden CI-Jobs **+ alle ctest-Eintraege mit `PASS_REGULAR_EXPRESSION`** (Wachen, deren Verdikt ein Textmuster ist -- dort ist der Nenner am leichtesten zu faelschen; D4-Querbefund). Nenner nach D3-1: super `scripts/`+`ci/` = **6** `.sh`. Abgleich beidseitig rot; Koeder werden vom Job GEFAHREN. Rueckfallstufe bei Zeitriss: manuell versioniertes Register + die je D-Posten ohnehin gefahrenen Koeder-Protokolle (deklarierte Grenze: neu entstehende Wachen machen dann nichts rot -- W7-Posten).

**Je Welle (Nenner + tragende Zeilen; die vollstaendigen Abnahme-/Koeder-Definitionen der D-Posten aus Abschnitt 2 sind Vertragsbestandteil):**

**W-1** (Nenner 6): ##01 `rev-list --count` 29->0, beide Zahlen * ##02 `diff --stat` 17->0 * D1/D1a: `make check` 427->431 literal, `make` allein 0->53 `.so` (6329->6749 ninja-Ziele), Doppel-Koeder beider Gate-Familien vorher unsichtbar-gruen/nachher rot * D1d: `grep -rn '404 statt 406'` = 0; jede verbleibende Kommentar-Zahl mit Datum+Kommando * ##04/##05 wie v1, jetzt erfuellbar.

**W0a** (Nenner 14): test:unit-Job druckt Job-ID + `out of 431` + `R5.G ... ACTIVE (48 auto-gebaute DLLs)` (heute 429, beide Zahlen) * Wache druckt DREI Zahlen aus DREI Quellen (V-7), Zahl-Koeder 345 -> rot, Schrumpf-Koeder N per `shuf` -> rot mit N, Gegenkoeder gruen * Bedingungs-Tabelle: `bedingte Registrierungen: 15 / ohne Allowlist-Eintrag: 0` (16. Koeder-Bedingung hebt den Zaehler maschinell) * D2-G1: `ctest -N` +2, Erstlauf-Ergebnis mit bestanden/gesamt gebucht * D2-G6-Stash-Koeder: XML weg -> rot mit Namen und `Inventur 426, Untergrenze 428, Differenz -2` * D5-1: `Definitionen: 1`, Pin 51->50, Mutations-Koeder rc!=0 mit Seed * D1g: zwei `ctest -N`-Zahlen aus einem gefahrenen super-Configure-Paar, Ursache im Kommentar benannt.

**W0b** (Nenner 17 + 5 Nachlauf): D3-1-Proben P1 (Kopfzeile, `$K` im Pfad der Fehlerzeile) rot / P2 (eine Datenzeile `koeder_$K`) gruen mit `datenzeilen_gesamt=1` / P3 (leer) rot mit `csv_gesamt=0` -- heute P1/P3 gruen, Vorher-Laeufe protokolliert * ##26 in korrigierter Formel `N>=1 UND M==N UND Z>=1` * Marker: fehlend = rot, `provision_only` nicht faelschlich rot, gefaelschter `modus=voll measured=0` rot * persist-Beweis am Git-Zustand * Testat-XOR: gewuerfelte Fehl-Zelle -> genau 1 `[FEHLER-TESTAT]`, C?1 `[MESS-TESTAT]`, Bilanz stimmt (heute C+1 Testate) * Frische-Zwei-Lauf-Koeder * D3-6: P1 Produktions-Layout heute unsichtbar -> danach im WIDE-Aggregat, P3 NO-OP mit `laufordner_geprueft=1 / mit_material=0` * ##23/##23b wie v1 (Zeilenzahl je Blatt gegen Eingangs-CSV; SKIP-Zweitlauf zwei Zahlen) * **##25 DURCHSTICH:** Submodul-Diff zeigt die Tabellenzeile mit dem gewuerfelten Mini-Lauf-Token; PDF baut; jede Stufe hat ihren Nenner gedruckt.

**W1** (Nenner 26): D4-Invarianz (identische `adjusted_p` 7-vs-9; benannter Kipp-Kandidat) * `win_rate` nur noch mit Nenner-Klammer * f15-Summenzeile nachgerechnet, Exit!=0 bei degeneriert (rc direkt hinter dem Aufruf, K11) * D4d: Spaltenzahl vorher/nachher, Null-Vektor != success, Gegenprobe (31 Nullen + 1 echter Wert) * ##10 zwei Zahlenreihen + ##10b ein gemessener Punkt bei 8.388.608 * ##11 Deckelung liefert kleinere Zahl; nicht deklarierte Perm = Fehlerklasse * ##13 `nm` auf benannte micro-Symbole, Stempel-Region ausgenommen (v1-##13 bleibt) * ##14 Preimage-Wache: 10. Glied -> rot * HY-A: F8-DoD gruen in ctest (Zahl vorher/nachher), Reroute-Roundtrip-Koeder (gewuerfeltes Token durch das Dock zu 2 plain-Zielen und zurueck), nicht deklariertes Ziel bricht compile-time laut, Registry 22->23 * Kreuz-Test Median (Bit-Gleichheit, gerade Laenge) * Fr 21.08.: OV-4-Vorlage liegt MIT Zahlen beim Owner.

**W2** (Nenner 12): ##34 `git log -p`-Filter aufs ABI-Magic = **genau EIN** Wechsel im Gesamtfenster, **NULL nach Mo 24.08.** (Commit-Zahl als Nenner gedruckt) * ##35 zwei Zahlen (Abbruch nach 2 Batches, Neustart ueberspringt; heute Start bei 0 = rot) * ##36 **zwei degenerierte Zellarten getrennt**: Null-Fenster -> `MESSUNG DEGENERIERT ... unbestimmbar` (kein Rerun), echte Streuung -> `reruns: n`; `ZeroMedianGuard` im selben Commit umgedreht; Zensus-Zaehler Produktion >= 1 mit Dateiname * ##47 ETA gegen unabhaengige Teilbaum-Auszaehlung, Abweichung > 50 % = Abbruch; Kalibrierlauf passiert alle W0b-Gates (das IST der U-02-Vollzug) + erhobene Rerun-Rate * ##48 5/5 mit Nenner + `benoetigt_GB`/`frei_GB` beide gedruckt * ##50 drei Zahlen * ##41b drei Job-IDs + ein absichtlicher Zell-Fehlschlag faerbt den Grandchild rot * ##51 EINE Datei.

**W3-MESS** (Nenner 7): ##53 `zellen_mit_echtem_messwert/zellen_gesamt` + Haeufigkeit JEDES Ersatz-Tokens (Single-Source `measurement_curve_loader.hpp:72`), alle Zahlen im Log UND im Exit-Code; `nicht_gebaut > 0` = Abbruch vor der Auswertung ("Zeilenzahl > 0" ist wertlos -- der Bau-Fehler-Zweig schreibt formal vollstaendige CSVs); "echt" = D4d-Definition * Batch-Abende: Bilanz, Gate, Frische -- je Batch protokolliert * HY-B: Overhead-Kurve je Zielanzahl mit n je Zelle; eine tote Reihe kann nicht mehr gewinnen (D4e-Nachweis) * ##56 Commit nur bei Substanz, PROVENANCE traegt die Zahl.

**W4/W5** (Nenner 8 + 1): ##57 zwei Laeufe, zwei verschiedene Antworten (Status benannt -- heute byte-gleich; der v1-Koeder "eine Binary" ist als unzureichend vermerkt) * ##58 28 Soll gegen X gefunden, beide Zahlen * ##58b `\thesisfinal` macht Ersatztext zum Fehler, `|| echo honest-empty` gefallen * ##59 5/5 * P-1 `geprueft 3 / erfuellt-oder-korrigiert 3` * HY-C Koeder beidseitig (kein Schnittpunkt vs. ungueltige Kurve) * ##62 wie v1.

---


STATUS LT. QUELLE: nur-hinweis (Plan-Struktur, im Repo gelandet)
ABHAENGIGKEIT/FLAECHE: -


## QUELLE w9ezc7zw6.json -- Datei-Mengen-Erhebung aller offenen Posten der aktuellen Welle (P1-P11) + Parallel-Bau-Plan (Deckel 3 gleichzeitige Vollbauten, Ein-Blech-Regel). P1=S-3 (F1 Fr 14.08.), P2=S-7, P3=S-5 Stempel-Factory, P4=S-18 Kategorie-Homes+queuing-Umzug, P5=Layout-7-Vorstufe, P6=B2 Gate-Trennung G2/G3, P7=S-4 Filter-Concepts, P8=#21 E-1..E-4+A-1, P9=#22-Rest Ledger+Cluster-Handout, P10=#10 MinIO, P11=S-14a-Riegel. Nenner: 15 Hotspots, 9 Erhebungs-Luecken, 7 Bau-Gruppen, 12 Konflikte, 11 Risiken, 11 Erhebungs-Kritiken.

### [w9ezc7zw6.json] 001
GEGENSTAND: HOTSPOT (gemeinsame Flaeche) fuer Posten P1+P2+P3+P4+P6+P7+P11: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/tests/unit/CMakeLists.txt
ORT: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/tests/unit/CMakeLists.txt
SOLL/FIX: gemeinsame Datei -- HOTSPOT ERSTEN RANGES. 7 von 11 Posten registrieren dort. 6876 Zeilen. P11 haengt seinen Block an :1916 (mitten in der Datei), der zuletzt gelandete S-1-Block steht am DATEIENDE (:6840-6876) -- neue Bloecke landen also im selben Tail-Bereich. Bei paralleler Landung ist der Textkonflikt garantiert; die Serialisierung gehoert an die Lande-Stufe, nicht an den Bau. Zusatz: die Datei enthaelt 97 Vorkommen von COMDARE_CE_ENABLE_STATISTICS (P6-Flaeche) und zwei GLOBs (:11 topics/*/axis_*, :24 axes/*), die P4 mitbewegt.
STATUS LT. QUELLE: offen (Konflikt-/Kopplungs-Hinweis fuer Parallel-Bau)
ABHAENGIGKEIT/FLAECHE: Posten P1+P2+P3+P4+P6+P7+P11

### [w9ezc7zw6.json] 002
GEGENSTAND: HOTSPOT (gemeinsame Flaeche) fuer Posten P1+P2+P4+P7: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/measurement/ (Verzeichnis, 70 Header)
ORT: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/measurement/ (Verzeichnis, 70 Header)
SOLL/FIX: gemeinsames Verzeichnis. P1 legt flag_menge_ordnung.hpp an, P2 die Bruecke neben simd_organ_requirement.hpp, P7 evtl. die Filter-Concepts, und P4 stellt genau dieses Verzeichnis als MESS-/SYSTEM-Home zur Disposition. HEUTE sind 17 seiner Dateien ueber 9 Datei-Praefixe im Overlay-Schnitt (overlay_source_set.hpp:176-196, Form::datei_praefix) -- neue Dateien mit anderem Namen fallen automatisch HERAUS. Legt P4 ein echtes Home mit Form::verzeichnis an, kippt diese Logik: dann liegt JEDE Datei des Homes im Fingerprint, und P1/P2/P7 werden nachtraeglich golden-brechend. Diese Weiche ist der wichtigste offene Punkt der Erhebung.
STATUS LT. QUELLE: offen (Konflikt-/Kopplungs-Hinweis fuer Parallel-Bau)
ABHAENGIGKEIT/FLAECHE: Posten P1+P2+P4+P7

### [w9ezc7zw6.json] 003
GEGENSTAND: HOTSPOT (gemeinsame Flaeche) fuer Posten P4+P6: Overlay-Schnitt / kOverlaySourceHash -> binary_id -> golden (Kette: libs/cache_engine/builder/overlay_source_set.hpp -> tools/overlay_source_hash_gen/main.cpp -> cmake/overlay_source_hash.cmake:37-45,
ORT: Overlay-Schnitt / kOverlaySourceHash -> binary_id -> golden (Kette: libs/cache_engine/builder/overlay_source_set.hpp -> tools/overlay_source_hash_gen/main.cpp -> cmake/overlay_source_hash.cmake:37-45,137-148 -> generated/cache_engine/abi/overlay_sour
SOLL/FIX: gemeinsame ABI-/Identitaets-Flaeche. Die BEIDEN golden-brechenden Posten der Welle. P4 bewegt Schnitt-Pfade UND aendert overlay_source_set.hpp selbst; P6 aendert libs/cache_engine/anatomy/abi_adapter.hpp, und anatomy/ steht als Kategorie tier_substanz mit Form::verzeichnis REKURSIV im Schnitt (overlay_source_set.hpp:190-196). Beide erzwingen einen bewussten golden-Regen. Zusatzkopplung: comdare_overlay_source_hash ist ein ALL-Target, das per add_dependencies an JEDEM bauenden Ziel haengt -- der Hash-Wechsel ist damit kein lokales Ereignis, sondern ein Vollbau.
STATUS LT. QUELLE: offen (Konflikt-/Kopplungs-Hinweis fuer Parallel-Bau)
ABHAENGIGKEIT/FLAECHE: Posten P4+P6

### [w9ezc7zw6.json] 004
GEGENSTAND: HOTSPOT (gemeinsame Flaeche) fuer Posten P4+P6+P11: S-14a-Lock-Domaene: libs/cache_engine/axes/ + libs/cache_engine/topics/queuing/ + libs/cache_engine/heuristik/ (158 per SHA-256 gelockte Dateien, tools/axis_version_lock/axis_version.lock)
ORT: S-14a-Lock-Domaene: libs/cache_engine/axes/ + libs/cache_engine/topics/queuing/ + libs/cache_engine/heuristik/ (158 per SHA-256 gelockte Dateien, tools/axis_version_lock/axis_version.lock)
SOLL/FIX: gemeinsame ABI-/Identitaets-Flaeche, HEUTE NEU ENTSTANDEN. P11 besitzt sie. P4 BEWEGT 22 der 158 (alle topics/queuing) -- und das Werkzeug erklaert die Kopplung selbst: axis_version_lock.cpp:19-22 'Wer die Homes anlegt, ergaenzt die Detail-Klasse UND haengt sie in write_lock()/check_lock() ein'; OrganDetail::discover:194 ist auf beide Home-Pfade hartkodiert mit fail-closed Exit 2, und test_s14_axis_version_lock_tripwire.cpp:193-194 kopiert exakt diese drei Baeume, ebenfalls hartkodiert, mit 'return 2' bei fehlendem Baum plus den Ankern heuristik==6 / organ>=120. P6 ist die STILLE Gefahr: 39 Dateien unter axes/ und 13 unter topics/queuing tragen COMDARE_CE_ENABLE_STATISTICS -- greift die Gate-Trennung dort hinein, ist es sofort Bump-Zwang oder Lock-Regen. P1/P2 sind per eiserner Regel (keine Datei unter axes/, topics/, heuristik/) ausgenommen -- diese Regel deckt sich EXAKT mit der Lock-Domaene.
STATUS LT. QUELLE: offen (Konflikt-/Kopplungs-Hinweis fuer Parallel-Bau)
ABHAENGIGKEIT/FLAECHE: Posten P4+P6+P11

### [w9ezc7zw6.json] 005
GEGENSTAND: HOTSPOT (gemeinsame Flaeche) fuer Posten P3+P5: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp
ORT: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp
SOLL/FIX: gemeinsame Datei + gemeinsame ABI-Flaeche. P5 muss die Layout-Wache (:283 '== 6', :309-311 die Layout-7-Negativprobe, :274-277 sizeof==120) oeffnen. P3 muss laut stempel_basis.hpp:31-35 genau dort die Baustein-Trait-Anbindung fuehren und dabei die Pins :191-193/:254/:261-264 'byte-unberuehrt' lassen. Groesster Rueck-Include-Kegel der Erhebung: 186 Dateien / 142 TUs / 133 Test-TUs. Zwei Posten in derselben Datei, beide mit Vollbau -- diese zwei duerfen nicht gleichzeitig offen sein.
STATUS LT. QUELLE: offen (Konflikt-/Kopplungs-Hinweis fuer Parallel-Bau)
ABHAENGIGKEIT/FLAECHE: Posten P3+P5

### [w9ezc7zw6.json] 006
GEGENSTAND: HOTSPOT (gemeinsame Flaeche) fuer Posten P1+P3+P5: abi/-Stempelflaeche: stempel_basis.hpp * stempel_baustein_trait.hpp * anatomy_stamp_entries.hpp * anatomy_version_stamp.hpp * anatomy_module_abi_v1.hpp * toolchain_stamp_glied.hpp * system_axis_code_v
ORT: abi/-Stempelflaeche: stempel_basis.hpp * stempel_baustein_trait.hpp * anatomy_stamp_entries.hpp * anatomy_version_stamp.hpp * anatomy_module_abi_v1.hpp * toolchain_stamp_glied.hpp * system_axis_code_versions.hpp * meta_meta_stamp_suffix.hpp * builder
SOLL/FIX: gemeinsame ABI-Flaeche. P3 baut darauf, P5 bricht ihren POD, und P1 ist ueber die static_assert-Traeger von ce_owned_version_is_wellformed indirekt drin (stempel_basis.hpp:166, toolchain_stamp_glied.hpp:234-236, system_axis_code_versions.hpp:105, planner_version.hpp:121, pruef_dock_version.hpp:123-139, ceb_version_stamp.hpp) -- eine schaerfere Wache kann diese Bestands-Zusicherungen ROT machen, ohne dass P1 eine dieser Dateien anfasst.
STATUS LT. QUELLE: offen (Konflikt-/Kopplungs-Hinweis fuer Parallel-Bau)
ABHAENGIGKEIT/FLAECHE: Posten P1+P3+P5

### [w9ezc7zw6.json] 007
GEGENSTAND: HOTSPOT (gemeinsame Flaeche) fuer Posten P1+P2: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/measurement/simd_build_gate.hpp
ORT: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/measurement/simd_build_gate.hpp
SOLL/FIX: gemeinsame Datei. P1 braucht set_active_machine_declaration (:234) fuer die Fassaden-Naht; P2 braucht admit_organ_on_machine + active_machine_signature (die der Orchestrator-Gate-Block :759-771 ruft) und :260-277 kommentiert den P2-Weg ausdruecklich. Kegel 66/56/54.
STATUS LT. QUELLE: offen (Konflikt-/Kopplungs-Hinweis fuer Parallel-Bau)
ABHAENGIGKEIT/FLAECHE: Posten P1+P2

### [w9ezc7zw6.json] 008
GEGENSTAND: HOTSPOT (gemeinsame Flaeche) fuer Posten P1+P2: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp (semantisch, ohne gemeinsame Zeile)
ORT: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp (semantisch, ohne gemeinsame Zeile)
SOLL/FIX: VERDECKTE KOPPLUNG OHNE GEMEINSAME DATEI. P2 baut den Gate-Block :759-771 aus. P1 belegt zum ersten Mal active_machine_signature() -- und genau die liest der Gate-Block :761. Heute ist die Signatur LEER (0 Produktions-Aufrufer, profile_run_entry.hpp:315), das Gate deshalb trivial-durchlaessig. P1 macht es scharf, ohne P2s Datei anzufassen. Wer die beiden als disjunkt bewertet, weil die Dateimengen sich nicht schneiden, bewertet falsch.
STATUS LT. QUELLE: offen (Konflikt-/Kopplungs-Hinweis fuer Parallel-Bau)
ABHAENGIGKEIT/FLAECHE: Posten P1+P2

### [w9ezc7zw6.json] 009
GEGENSTAND: HOTSPOT (gemeinsame Flaeche) fuer Posten P1+P2+P3+P7: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/measurement/algo_semver.hpp + flag_grammar_catalog.hpp
ORT: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/measurement/algo_semver.hpp + flag_grammar_catalog.hpp
SOLL/FIX: gemeinsame Datei bzw. Registrierung. P1 schreibt (Wache + Traversal), P7 haengt sich wahrscheinlich ein (S-4 braucht S-3), P2 und P3 sind ueber die 16 static_assert-Traeger passiv gebunden. Groesster gemeinsamer Kegel: 197-198 Dateien / 126 TUs / 118 Test-TUs. Zusatz-Falle: tests/unit/test_vs_taxonomie_klassen_grep.cpp greppt den Wachen-NAMEN im Quelltext (:90) und bekommt den Pfad per COMDARE_TAX_QUELLE-Define -- eine Umbenennung bricht ihn, ohne dass der Compiler etwas sagt.
STATUS LT. QUELLE: offen (Konflikt-/Kopplungs-Hinweis fuer Parallel-Bau)
ABHAENGIGKEIT/FLAECHE: Posten P1+P2+P3+P7

### [w9ezc7zw6.json] 010
GEGENSTAND: HOTSPOT (gemeinsame Flaeche) fuer Posten P4: Die 6 CMake-GLOB-Stellen ueber axes/* bzw. topics/*/axis_* (alle unter /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/): tests/unit/CMakeLists.txt:11,24 * libs/cache_engine/profile_
ORT: Die 6 CMake-GLOB-Stellen ueber axes/* bzw. topics/*/axis_* (alle unter /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/): tests/unit/CMakeLists.txt:11,24 * libs/cache_engine/profile_facade/CMakeLists.txt:4,11 * apps/catalog_codegen_
SOLL/FIX: gemeinsame CMake-Registrierung -- nur P4, aber sie erklaert, warum P4 ein RE-CONFIGURE erzwingt und nicht bloss einen Neubau. Jede der 6 Stellen leitet aus dem Verzeichnisbestand Include-Pfade generated/axes/<name> bzw. generated/topics/<rel> ab. Ein Home-Umbau aendert alle sechs Ergebnisse gleichzeitig; ein blosses 'cmake --build' liefe auf einem veralteten Pfadsatz und meldete falsches Gruen (bekannte Klasse J-1..J-4).
STATUS LT. QUELLE: offen (Konflikt-/Kopplungs-Hinweis fuer Parallel-Bau)
ABHAENGIGKEIT/FLAECHE: Posten P4

### [w9ezc7zw6.json] 011
GEGENSTAND: HOTSPOT (gemeinsame Flaeche) fuer Posten P1+P2+P3+P4+P6+P7+P11: Test-Wachen-Register (alle unter /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/scripts/): ci_test_inventory_floor.txt * ci_test_coverage_manifest.sh * ci_test_registrierungs_allowl
ORT: Test-Wachen-Register (alle unter /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/scripts/): ci_test_inventory_floor.txt * ci_test_coverage_manifest.sh * ci_test_registrierungs_allowlist.txt * ci_test_bauweg_allowlist.txt * ci_test_s
SOLL/FIX: gemeinsame Registrierung. Jeder neue Test beruehrt diesen Satz: der coverage-guard verlangt, dass jeder registrierte ctest von mindestens einem WIRKLICH fahrenden CI-Job getroffen wird (sonst ROT); die bauweg-Wache verlangt die Zeile set_property(GLOBAL APPEND PROPERTY COMDARE_TEST_TARGETS <ziel>); der inventory_floor (avx512f 479 / avx2 475 / basis 473) ist bei wachsender Testzahl von Hand in einem EIGENEN Commit nachzuziehen. Sieben Posten, ein Registersatz.
STATUS LT. QUELLE: offen (Konflikt-/Kopplungs-Hinweis fuer Parallel-Bau)
ABHAENGIGKEIT/FLAECHE: Posten P1+P2+P3+P4+P6+P7+P11

### [w9ezc7zw6.json] 012
GEGENSTAND: HOTSPOT (gemeinsame Flaeche) fuer Posten P10+P11: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/.gitlab-ci.yml und /home/comdare/wt-super-landung/.gitlab-ci.yml
ORT: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/.gitlab-ci.yml und /home/comdare/wt-super-landung/.gitlab-ci.yml
SOLL/FIX: Lead-only. P11 aendert den ce-Job contract:axis-version-lock (:788-812), P10 arbeitet am super-Job measure:smoke (:1810) und am Storage-#51-Block (:1620-1690). Zwei verschiedene Dateien, aber beide LEAD-ONLY und beide brauchen ein Pipeline-Blech -- die EIN-BLECH-REGEL macht sie zueinander seriell, obwohl ihre Dateimengen disjunkt sind.
STATUS LT. QUELLE: offen (Konflikt-/Kopplungs-Hinweis fuer Parallel-Bau)
ABHAENGIGKEIT/FLAECHE: Posten P10+P11

### [w9ezc7zw6.json] 013
GEGENSTAND: HOTSPOT (gemeinsame Flaeche) fuer Posten P8+P9: /home/comdare/wt-super-landung/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md
ORT: /home/comdare/wt-super-landung/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md
SOLL/FIX: Lead-only, gemeinsame Datei. 3,17 MB. Beide Posten schreiben hinein (P8 den E-1..E-4-Vollzug, P9 die 2 Zitat-Korrekturen + Paragraph-69.6-Vermerk + N-3-Rechnung). Seriell -- git commit nimmt die ganze Staging-Area.
STATUS LT. QUELLE: offen (Konflikt-/Kopplungs-Hinweis fuer Parallel-Bau)
ABHAENGIGKEIT/FLAECHE: Posten P8+P9

### [w9ezc7zw6.json] 014
GEGENSTAND: HOTSPOT (gemeinsame Flaeche) fuer Posten P2+P3: NAMENSRAUM tests/unit/test_s5_*.cpp und tests/unit/test_s7_*.cpp
ORT: NAMENSRAUM tests/unit/test_s5_*.cpp und tests/unit/test_s7_*.cpp
SOLL/FIX: gemeinsame Registrierung / Namenskollision. Es gibt bereits 20 Bestandstests test_s5_01a..test_s5_05q_* (Allokator-/Perf-Konformitaet, Registrierung ab tests/unit/CMakeLists.txt:2179) und 10 test_s7_1..test_s7_10_*_pool_allocator_deg.cpp (ab :2660) -- beide mit voellig anderem Gegenstand als die S-5-Stempel-Factory und der S-7-Achsen-Stempel. Neue Dateien nach demselben Schema sind fuer jeden Leser und fuer jeden ctest -R-Selektor nicht mehr unterscheidbar. Betrifft auch den coverage-guard, der Job-Selektoren gegen die Live-Inventur prueft.
STATUS LT. QUELLE: offen (Konflikt-/Kopplungs-Hinweis fuer Parallel-Bau)
ABHAENGIGKEIT/FLAECHE: Posten P2+P3

### [w9ezc7zw6.json] 015
GEGENSTAND: HOTSPOT (gemeinsame Flaeche) fuer Posten P1+P2: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/profile_facade/profile_run_entry.hpp
ORT: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/profile_facade/profile_run_entry.hpp
SOLL/FIX: gemeinsame Datei plus offene Alt-Baustelle. P1 setzt dort den einen Aufruf (:300-320). P2 zieht sie indirekt (sie inkludiert build_orchestrator.hpp und axis_variant_version_table.hpp). Zusaetzlich: der STEHENGEBLIEBENE Worktree /home/comdare/wt-ce-messvisitor (Branch w0b/durchstich-kette, 31240ac5) traegt gegen development 188 Diff-Zeilen auf genau diese Datei -- der Branch ist veraltet (er wuerde u.a. test_s1_stempel_basis_vertrag.cpp mit 510 Zeilen loeschen). Wer ihn spaeter merged statt neu aufsetzt, holt sich P1 zurueck.
STATUS LT. QUELLE: offen (Konflikt-/Kopplungs-Hinweis fuer Parallel-Bau)
ABHAENGIGKEIT/FLAECHE: Posten P1+P2

### [w9ezc7zw6.json] 016
GEGENSTAND: ERHEBUNGS-LUECKE[0]: DIE NAMEN DER NEUEN ARTEFAKTE
ORT: unbekannt
SOLL/FIX: DIE NAMEN DER NEUEN ARTEFAKTE. Nur measurement/flag_menge_ordnung.hpp (P1) ist im Lage-Text benannt. Offen bleiben: die S-5-Factory-/Composite-Header (P3), die S-4-Concept-Header und ihr Verzeichnis measurement/ vs. builder/experiment_tree/ (P7), die drei S-18-Waechter (P4), der Ort der S-7-Bruecke algo_declared_flags_for_axes -- eigener Header oder Anbau an simd_organ_requirement.hpp (P2) -- und saemtliche neuen Test-Dateinamen.
STATUS LT. QUELLE: offen (deklarierte Luecke der Erhebung)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 017
GEGENSTAND: ERHEBUNGS-LUECKE[1]: DER ZUSCHNITT VON P4, und das ist die folgenreichste Luecke
ORT: unbekannt
SOLL/FIX: DER ZUSCHNITT VON P4, und das ist die folgenreichste Luecke. Erstens: '22 Traeger' vs. die 46 Dateien, die tatsaechlich unter libs/cache_engine/topics/queuing/ liegen -- ob nur die gelockten 22 umziehen oder der ganze Baum (concepts/, Registries, Subaxes, *_flags.hpp.in, config_set), ist nicht entschieden. Zweitens: ob das ORGAN-Ziel 'axes/queuing/' heisst. Drittens und wichtigstens: ob die SYSTEM-/MESS-Homes durch VERSCHIEBEN der 17 heute per Praefix erfassten Dateien aus include/cache_engine/measurement/ entstehen oder als zusaetzliches Verzeichnis daneben. Von dieser einen Entscheidung haengt ab, ob P1/P2/P7 fingerprint-neutral bleiben oder nachtraeglich golden-brechend werden.
STATUS LT. QUELLE: offen (deklarierte Luecke der Erhebung)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 018
GEGENSTAND: ERHEBUNGS-LUECKE[2]: DER ARBEITSSTAND IN /home/comdare/wt-ce-golden-s14a
ORT: unbekannt
SOLL/FIX: DER ARBEITSSTAND IN /home/comdare/wt-ce-golden-s14a. READ-ONLY-Auflage eingehalten: gemessen ist ausschliesslich der Branch-Stand bau/golden-s14a-riegel @8257e517 aus dem Object-Store (git diff --stat, git show <branch>:<pfad>). Das laufende Fixup ueber 22 Lens-Funde kann die P11-Dateimenge noch erweitern -- insbesondere tests/unit/CMakeLists.txt und tools/axis_version_lock/axis_version.lock.
STATUS LT. QUELLE: offen (deklarierte Luecke der Erhebung)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 019
GEGENSTAND: ERHEBUNGS-LUECKE[3]: ES WURDE NICHTS GEBAUT
ORT: unbekannt
SOLL/FIX: ES WURDE NICHTS GEBAUT. Im gelandeten Stand existiert kein build*-Verzeichnis. Alle Kegel-Zahlen (Dateien/TUs/Test-TUs) stammen aus einer statischen transitiven Rueck-Include-Huelle ueber Basename-Aufloesung (Skript /tmp/rdep.py), NICHT aus 'ninja -t deps'. Sie sind eine UNTERE SCHRANKE: Umbrella-Header, generierte Header (generated/axes/*, generated/topics/*) und per -I aufgeloeste Mehrdeutigkeiten sind darin nicht erfasst. Ebenso wenig geprueft: ob ein Posten tatsaechlich uebersetzt.
STATUS LT. QUELLE: offen (deklarierte Luecke der Erhebung)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 020
GEGENSTAND: ERHEBUNGS-LUECKE[4]: generated/cache_engine/abi/overlay_source_set_manifest
ORT: unbekannt
SOLL/FIX: generated/cache_engine/abi/overlay_source_set_manifest.txt -- die Datei, die die exakt gehashte Dateimenge des Overlay-Glieds [7] auflistet, entsteht erst beim Bau. Die Schnitt-Zugehoerigkeit wurde deshalb aus overlay_source_set.hpp:129-198 plus der Praefix-Logik in tools/overlay_source_hash_gen/main.cpp:98-113 (rfind(praefix,0)==0) REKONSTRUIERT, nicht gemessen.
STATUS LT. QUELLE: offen (deklarierte Luecke der Erhebung)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 021
GEGENSTAND: ERHEBUNGS-LUECKE[5]: DIE LEDGER-ZEILEN von P8 und P9
ORT: unbekannt
SOLL/FIX: DIE LEDGER-ZEILEN von P8 und P9. Der Ledger ist 3,17 MB; welche zwei Zitate zu korrigieren sind, wo der Paragraph-69.6-Vermerk hingehoert und was die N-3-Rechnung im Einzelnen ist, wurde nicht aufgeschlagen. Ebenso wenig, welches Dokument unter /home/comdare/Projekte/Cluster/docs/sessions/ das gemeinte 'bereits geschriebene Infra-Handout' ist.
STATUS LT. QUELLE: offen (deklarierte Luecke der Erhebung)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 022
GEGENSTAND: ERHEBUNGS-LUECKE[6]: P10: ob die MinIO-Keys von Projekt 288 tatsaechlich fehlen
ORT: unbekannt
SOLL/FIX: P10: ob die MinIO-Keys von Projekt 288 tatsaechlich fehlen. CI-Variablen und Vault wurden bewusst NICHT angefasst (Memory-Regel: Vault-Dateien nie greppen). Erhoben ist nur, WO der Posten wohnt (super-.gitlab-ci.yml, nicht ce).
STATUS LT. QUELLE: offen (deklarierte Luecke der Erhebung)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 023
GEGENSTAND: ERHEBUNGS-LUECKE[7]: DIE ZWEITE HAELFTE DER SCHWESTERSTELLEN-REGEL (T-6)
ORT: unbekannt
SOLL/FIX: DIE ZWEITE HAELFTE DER SCHWESTERSTELLEN-REGEL (T-6). Geprueft ist 'beide Writer / beide Genera' nicht systematisch, sondern nur dort, wo die Anker es nahelegten. Konkret nicht durchgezaehlt: ob die S-5-Composites fuer Sequence/Set/View/Adapter-Genus je eine eigene Stelle brauchen (abi/ traegt fuenf *_module_abi_v1.hpp-Varianten) und ob die P6-Gate-Trennung an beiden Observable-Familien (anatomy/*_observable.hpp und axes/*/*_observable.hpp) haengt.
STATUS LT. QUELLE: offen (deklarierte Luecke der Erhebung)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 024
GEGENSTAND: ERHEBUNGS-LUECKE[8]: OB DIE WACHE ci_test_inventory_floor
ORT: unbekannt
SOLL/FIX: OB DIE WACHE ci_test_inventory_floor.txt bei WACHSENDER Testzahl rot wird oder nur meldet. Der Dateikopf sagt 'sagt die Wache das ausdruecklich an und die Zahlen gehoeren dann von Hand nachgezogen'; der Exit-Code-Zweig in scripts/ci_test_coverage_guard.sh wurde nicht bis zum Ende gelesen. Fuer die Planung heisst das: als Beruehrung ANNEHMEN, nicht als gesichert rot.
STATUS LT. QUELLE: offen (deklarierte Luecke der Erhebung)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 025
GEGENSTAND: POSTEN P1 -- Dateimenge SICHER
ORT: s. Text
SOLL/FIX: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/measurement/flag_menge_ordnung.hpp (NEU -- existiert nachweislich nicht: find ueber den Baum liefert 0 Treffer) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/measurement/algo_semver.hpp (:905 for_each_flag_node, :1003 ce_owned_version_is_wellformed -- der Konjunktions-Term; 1530 Z.) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/measurement/flag_grammar_catalog.hpp (FlagCatalogEntry; Ketten-Tabelle als DATEN) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/measurement/machine_simd_signature.hpp (Geschlossenheits-Wache) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/profile_facade/profile_run_entry.hpp (:300-320 -- system_axis_host_supports_simd; der Kommentar :315 sagt literal 'weil die CEB set_active_machine_declaration noch nicht ruft (0 Produktions-Aufrufer)') ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/tests/unit/test_s3_*.cpp (NEU) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/tests/unit/CMakeLists.txt (Registrierung; 6876 Z.)
STATUS LT. QUELLE: offen (Bau-Posten der Welle)
ABHAENGIGKEIT/FLAECHE: P1

### [w9ezc7zw6.json] 026
GEGENSTAND: POSTEN P1 -- Dateimenge WAHRSCHEINLICH + Kopplungen
ORT: s. Text
SOLL/FIX: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/measurement/simd_build_gate.hpp -- HIER lebt set_active_machine_declaration (:234) und reset_active_machine_declaration_for_test (:250); NICHT in profile_facade. Der eine Aufruf zieht diesen Header in die Naht. ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/profile_facade/profile_run_facade.cpp -- vom Lage-Text als Alternativort der Naht genannt ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/tests/unit/test_c3a_gate_scharfschaltung.cpp + test_o4_machine_identity.cpp -- die EINZIGEN heutigen Aufrufer von set_active_machine_declaration; der Zustand ist prozess-global, ein Produktions-Aufruf aendert ihre Vor-/Nachbedingung ; 16 Bestands-Traeger mit static_assert/if auf ce_owned_version_is_wellformed -- ein schaerferer Konjunktions-Term kann sie ROT machen: profile_facade/planner/planner_version.hpp:121 * builder/pruef_dock/pruef_dock_version.hpp:123,127,131,135,139 * builder/experiment_tree/axis_variant_version_table.hpp:93 * include/cache_engine/abi/system_axis_code_versions.hpp:105 * abi/toolchain_stamp_glied.hpp:234-236 * abi/stempel_basis.hpp:166 * measurement/measurement_framework_registry.hpp:54 * measurement/measurement_tooling_registry.hpp:60 * measurement/pmc_vendor_registry.hpp:70 * measurement/operating_system_probe.hpp:280 * measurement/numa_page_probe.hpp:438 * measurement/numa_cpu_pin_process_probe.hpp:630 * measurement/hardware_meta_meta_axis.hpp:146 ; Bestandstests, die die Wache direkt fahren: tests/unit/test_planner_version_flag_grammatik.cpp * test_m_w12_stamp_bausteine.cpp * test_reflect_versions_all_registered.cpp * test_e24_c4_dock_version_negativ.cpp * test_a1_algo_version_pin_alloc_axis.cpp * test_od10_numa_page_probe.cpp * test_od11_numa_cpu_pin_process_probe.cpp * test_os_u3_probe.cpp ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/tests/unit/test_vs_taxonomie_klassen_grep.cpp -- SONDERFALL: greppt den WACHEN-NAMEN im Quelltext (:90 kWacheWohlgeformt = "ce_owned_version_is_wellformed") und bekommt algo_semver.hpp per COMDARE_TAX_QUELLE als Define; eine Umbenennung/Verschiebung bricht ihn still ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/scripts/ci_test_inventory_floor.txt -- die drei Sprossen (avx512f 479 / avx2 475 / basis 473) sind bei wachsender Testzahl von Hand nachzuziehen (Kopf der Datei: 'als eigener Commit')
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P1

### [w9ezc7zw6.json] 027
GEGENSTAND: POSTEN P1 -- Baubedarf + Begruendung
ORT: s. Text
SOLL/FIX: BAUBEDARF: VOLLBAU. Gemessener Rueck-Include-Kegel (statisch, /tmp/rdep.py): algo_semver.hpp = 197 Dateien / 126 TUs / 118 Test-TUs; flag_grammar_catalog.hpp = 198/126/118; machine_simd_signature.hpp = 95/66/63. Das ist praktisch die ganze Test-Suite. ABER: FINGERPRINT-NEUTRAL -- weder algo_semver.hpp noch ein 'flag_menge_ordnung.hpp' trifft einen Eintrag von kOverlaySourceSet (die measurement-Eintraege sind Form::datei_praefix mit genau 9 Praefixen, overlay_source_set.hpp:176-196; Treffer sind exakt 17 Dateien, keine davon betroffen). Also kein golden-Regen. Vollbau nach J-1..J-4 (Werkzeuge zuerst, RE-CONFIGURE, --target comdare_tests, ctest). || BEGRUENDUNG: Anker aus dem Lage-Text am Objekt verifiziert: grep -rn for_each_flag_node -> algo_semver.hpp:905; ce_owned_version_is_wellformed -> :1003 + 16 Bestands-Traeger; FlagCatalogEntry -> nur algo_semver.hpp + flag_grammar_catalog.hpp + test_m_w12. KORREKTUR am Lage-Text: set_active_machine_declaration liegt NICHT in profile_facade, sondern in measurement/simd_build_gate.hpp:234; profile_run_entry.hpp:315 traegt nur den Kommentar ueber die fehlende Belegung. Kegel-Zahlen aus transitiver Rueck-Include-Huelle.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P1

### [w9ezc7zw6.json] 028
GEGENSTAND: POSTEN P2 -- Dateimenge SICHER
ORT: s. Text
SOLL/FIX: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/builder/experiment_tree/axis_variant_version_table.hpp (LESEND -- Vollbestands-Beweis; :81-93 traegt bereits die Wache) ; Neue Bruecke algo_declared_flags_for_axes -- existiert nachweislich NICHT (grep ueber den ganzen Baum: 0 Treffer). Nachbarschaft belegt: measurement/simd_organ_requirement.hpp:70 aggregate_required_for_axes ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp (:759-771 -- der Gate-Block mit aggregate_required_for_axes + admit_organ_on_machine + active_machine_signature, verifiziert) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/tests/unit/test_s7_*.cpp (NEU; synthetische Probe-Klassen IM TEST) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/tests/unit/CMakeLists.txt
STATUS LT. QUELLE: offen (Bau-Posten der Welle)
ABHAENGIGKEIT/FLAECHE: P2

### [w9ezc7zw6.json] 029
GEGENSTAND: POSTEN P2 -- Dateimenge WAHRSCHEINLICH + Kopplungen
ORT: s. Text
SOLL/FIX: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/measurement/simd_organ_requirement.hpp -- entweder Ort der neuen Bruecke oder ihr direkter Nachbar ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/measurement/simd_build_gate.hpp -- :260-277 kommentiert genau diesen Weg ('der genaue Weg liegt allein im Orchestrator'); liefert admit_organ_on_machine + active_machine_signature ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/measurement/axis_version_stamp.hpp (Achsen-Stempel-Seite) ; NAMENSKOLLISION: tests/unit/test_s7_1_bst_pool_allocator_deg.cpp .. test_s7_10_swiss_pool_allocator_deg.cpp existieren BEREITS (anderer Gegenstand: Pool-Allokator-Degradation), Registrierung ab tests/unit/CMakeLists.txt:2660 ; Bestandstests von aggregate_required_for_axes/simd_build_gate: tests/unit/test_m_simd_feature_flag_catalog.cpp:163 * test_c3a_gate_scharfschaltung.cpp * test_c3b_kanal_merge_beleg.cpp * test_meta_meta_halbordnung.cpp * test_o4_machine_identity.cpp ; Orchestrator-Bestandstests (11 Test-TUs inkludieren build_orchestrator.hpp): test_kf16_build_orchestrator.cpp * test_kf16b_build_resilience.cpp * test_a2_sha512_skip_gate.cpp * test_d1_d2_selection.cpp * test_g2_variant_sidecar.cpp * test_w6_parallel_provision.cpp * test_s2_pull_tier_binary.cpp * test_r3_mess_gate_fingerprint_biss.cpp * kf16_e2e_real_build.cpp * r3_mess_gate_stamp_module.cpp * test_c3b_kanal_merge_beleg.cpp ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/scripts/ci_test_inventory_floor.txt
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P2

### [w9ezc7zw6.json] 030
GEGENSTAND: POSTEN P2 -- Baubedarf + Begruendung
ORT: s. Text
SOLL/FIX: BAUBEDARF: VOLLBAU, mittlerer Kegel. simd_organ_requirement.hpp = 67 Dateien / 56 TUs / 54 Test-TUs; simd_build_gate.hpp = 66/56/54; build_orchestrator.hpp = 59/51/49; axis_variant_version_table.hpp = 31/23/21. Vereinigung grob 70-80 TUs. ctest allein reicht NICHT: der Gate-Block aendert Laufzeitverhalten des Orchestrators (r.status=-4-Zweig), das muss --target comdare_tests + ctest fahren. FINGERPRINT-NEUTRAL (keine der Dateien liegt im Overlay-Schnitt). || BEGRUENDUNG: grep algo_declared_flags_for_axes ueber den ganzen Baum = 0 Treffer (Neubau bestaetigt). aggregate_required_for_axes: 6 Fundstellen, Definition simd_organ_requirement.hpp:70, EINZIGER Produktions-Konsument build_orchestrator.hpp:759. Kegel per Rueck-Include-Huelle. Bestehende test_s7_*-Dateien per ls belegt.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P2

### [w9ezc7zw6.json] 031
GEGENSTAND: POSTEN P3 -- Dateimenge SICHER
ORT: s. Text
SOLL/FIX: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/abi/stempel_basis.hpp (604 Z.; S-1-Vertrag, StempelTraeger-Enum :76, dreiwertige Matrix :79ff) ; Neue Factory-/Composite-Header in libs/cache_engine/include/cache_engine/abi/ (Name offen) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/abi/anatomy_version_stamp.hpp (399 Z.) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/tests/unit/CMakeLists.txt
STATUS LT. QUELLE: offen (Bau-Posten der Welle)
ABHAENGIGKEIT/FLAECHE: P3

### [w9ezc7zw6.json] 032
GEGENSTAND: POSTEN P3 -- Dateimenge WAHRSCHEINLICH + Kopplungen
ORT: s. Text
SOLL/FIX: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/abi/anatomy_stamp_entries.hpp (755 Z.) -- DER EINE Zeilen-Scanner, den stempel_basis.hpp:58 nur vorwaertsdeklariert; jede Composite-Pruefung laeuft darueber ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/abi/stempel_baustein_trait.hpp (56 Z.) -- ist_stempel_baustein<T> mit Rollen-Tag, die Baustein-Ebene der Factory ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp -- KONFLIKT MIT P5: stempel_basis.hpp:31-35 erklaert ausdruecklich, dass die Trait-Anbindung dort lebt und die Pins :191-193/:254/:261-264 'byte-unberuehrt' bleiben muessen ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1.hpp:187 (COMDARE_ANATOMY_VERSION_STAMP-Materialisierung) ; DIE VIER TRAEGER-ERBINNEN: profile_facade/planner/planner_version.hpp:94 (PlanerStempel) * builder/ceb_version_stamp.hpp:650 (CebStempel) * Tier + Hybrid existieren HEUTE NUR als Probe-Structs im Test test_s1_stempel_basis_vertrag.cpp:175/:188 -- ein Composite 'je Traeger' muss die beiden fehlenden erst schaffen ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/abi/toolchain_stamp_glied.hpp (Feld-Ordnungs-Wache :300-311) * abi/system_cell_values.hpp * abi/meta_meta_stamp_suffix.hpp * abi/system_axis_code_versions.hpp * profile_facade/toolchain_stamp_naht.hpp * builder/pruef_dock/pruef_dock_version.hpp ; Bestandstests der Stempelflaeche: tests/unit/test_s1_stempel_basis_vertrag.cpp * test_m_w12_stamp_bausteine.cpp * test_w10_system_cell_values.cpp ; NAMENSKOLLISION: 20 Bestandstests heissen bereits test_s5_01a..test_s5_05q_* (Allokator-Konformitaet, ganz anderer Gegenstand), Registrierung ab tests/unit/CMakeLists.txt:2179
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P3

### [w9ezc7zw6.json] 033
GEGENSTAND: POSTEN P3 -- Baubedarf + Begruendung
ORT: s. Text
SOLL/FIX: BAUBEDARF: VOLLBAU. stempel_basis.hpp = 131 Dateien / 99 TUs / 92 Test-TUs; anatomy_version_stamp.hpp = 42/33/31. Wenn anatomy_module_abi_v1_decl.hpp mit angefasst wird (wahrscheinlich, s. Trait-Anbindung): 186/142/133 -- der GROESSTE Einzelkegel der ganzen Erhebung. Der S-1-Testblock verlangt ausserdem das Ziel comdare_measurement_combo_ct (tests/unit/CMakeLists.txt Ende), also kein reiner Test-Teilbau. FINGERPRINT-NEUTRAL: abi/ liegt NICHT im Overlay-Schnitt. || BEGRUENDUNG: grep StempelVertrag< liefert genau 2 Produktions-Erbinnen (planner_version.hpp:94, ceb_version_stamp.hpp:650) und 2 Test-Proben -- der 'Composite je Traeger' hat also fuer Tier/Hybrid heute keinen Traeger. grep ist_stempel_baustein liefert 9 Dateien = die Baustein-Flaeche. Kegel per Rueck-Include-Huelle.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P3

### [w9ezc7zw6.json] 034
GEGENSTAND: POSTEN P4 -- Dateimenge SICHER
ORT: s. Text
SOLL/FIX: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/builder/overlay_source_set.hpp (369 Z.) -- DIE EINE Quelle der Home-Definitionen. :129-163 ORGAN als Form::verzeichnis, :165-196 SYSTEM+MESS als Form::datei_praefix ueber include/cache_engine/measurement. GENAU DAS ist 'SYSTEM- und MESS-Home FEHLEN'. :160-161 schreiben queuing auf topics/queuing fest. ; 46 Dateien unter /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/topics/queuing/ -- davon 22 im S-14a-Lock (16x axis_q1_queuing/*, 6x axis_q2_queuing/*), 24 weitere (concepts/, *_registry.hpp, *_subaxes_*.hpp, *_flags.hpp.in, *_axis_storage.hpp, topic_queuing_config_set.hpp, 2x PAPER_REFERENCES.md) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/CMakeLists.txt (:1055-1076 configure_file q1/q2 flags; :1619-1640 _aq1_legacy_root/_aq1_gen_root) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml (:102-123 -- 22 header="topics/queuing/..."-Attribute) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/tests/unit/CMakeLists.txt (:11 GLOB topics/*/axis_*, :24 GLOB axes/* -- beide Ergebnisse aendern sich; plus Waechter-Registrierung) ; 3 neue Waechter (je Home einer, Orte offen)
STATUS LT. QUELLE: offen (Bau-Posten der Welle)
ABHAENGIGKEIT/FLAECHE: P4

### [w9ezc7zw6.json] 035
GEGENSTAND: POSTEN P4 -- Dateimenge WAHRSCHEINLICH + Kopplungen
ORT: s. Text
SOLL/FIX: DIE 6 GLOB-STELLEN ueber axes/* bzw. topics/*/axis_*: tests/unit/CMakeLists.txt:11,24 * libs/cache_engine/profile_facade/CMakeLists.txt:4,11 * apps/catalog_codegen_tool/CMakeLists.txt:18 * tools/gen_golden_fullpilot/CMakeLists.txt:18 * tools/axis_registry_gen/CMakeLists.txt:19 * cmake/axis_hierarchy_summary.cmake:24 -- jede erzeugt Include-Pfade generated/axes/<name> bzw. generated/topics/<rel> ; 36 externe Quelldateien mit topics/queuing-Includes (60 gesamt, 24 davon liegen selbst im Verzeichnis): 11x libs/cache_engine/compositions/*_reference.hpp * builder/codegen/all_axes_umbrella.hpp * builder/experiment_tree/registry_to_axis_levels.hpp * profile_facade/source_catalog.hpp * topics/io/topic_io_config_set.hpp * topics/io/axis_persistence_target/axis_persistence_target_registry.hpp * apps/catalog_codegen_tool/main.cpp * 17 tests/unit/*.cpp ; P11-KOPPLUNG, im Werkzeug SELBST deklariert: tools/axis_version_lock/axis_version_lock.cpp:19-22 'SYSTEM- und MESS-Detail-Klassen werden BEWUSST NICHT angelegt -- ihre Homes existieren im Baum noch nicht (#16 Umgliederung kommt erst; queuing ist hier im HEUTIGEN Pfad festgeschrieben). Wer die Homes anlegt, ergaenzt die Detail-Klasse UND haengt sie in write_lock()/check_lock() ein.' OrganDetail::discover (:194) ist auf {libs/cache_engine/axes, libs/cache_engine/topics/queuing} HARTKODIERT, fail-closed Exit 2 wenn ein Home fehlt. ; tests/unit/test_s14_axis_version_lock_tripwire.cpp (:193-194) kopiert exakt diese drei Baeume, hartkodiert, mit 'return 2' wenn einer fehlt; Anker :216-220 h_disc==6 und o_disc>=120 ; tools/axis_version_lock/axis_version.lock -- Lock-Regen-Commit (--write) fuer die 22 bewegten Traeger zwingend ; tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt (+_abi4/_abi5/_abi6) -- Overlay-Hash aendert sich, damit die binary_id ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/.gitlab-ci.yml (Job contract:axis-version-lock, :788-812) -- LEAD-ONLY
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P4

### [w9ezc7zw6.json] 036
GEGENSTAND: POSTEN P4 -- Baubedarf + Begruendung
ORT: s. Text
SOLL/FIX: BAUBEDARF: VOLLBAU MIT ERZWUNGENEM RE-CONFIGURE. overlay_source_set.hpp selbst zieht nur 1 TU (den Codegen tools/overlay_source_hash_gen) -- die Wirkung laeuft NICHT ueber Includes, sondern ueber cmake/overlay_source_hash.cmake:37-45 (ALL-Target comdare_overlay_source_hash) und :137-148 (add_dependencies an JEDES bauende Ziel des Projekts). Der neu berechnete Hash landet in generated/cache_engine/abi/overlay_source_hash_generated.hpp -> abi/anatomy_fingerprint.hpp:30/:157 kOverlaySourceHash -> anatomy_fingerprint_hex -> binary_id. Ein Verzeichnis-Umzug aendert zusaetzlich 6 CMake-GLOBs => CMake MUSS neu konfigurieren, sonst falsches Gruen. Teuerster Posten der Welle. || BEGRUENDUNG: overlay_source_set.hpp:100-106 und :165-196 gelesen (Form::datei_praefix vs. verzeichnis). Die 46 Dateien per find gezaehlt, die 22 Lock-Traeger per Auszaehlung aus axis_version.lock (git show bau/golden-s14a-riegel:...; 158 Records, davon 16+6 unter topics/queuing). Die 6 GLOBs per grep -rn 'GLOB' ueber CMakeLists/*.cmake. Die XML-Bindung per grep 'topics/queuing' ueber *.xml. Die P11-Kopplung ist im Werkzeug-Kopf literal deklariert.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P4

### [w9ezc7zw6.json] 037
GEGENSTAND: POSTEN P5 -- Dateimenge SICHER
ORT: s. Text
SOLL/FIX: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp -- :274-277 static_assert(sizeof(AnatomyVersionLines)==120), :283 stamp_pod_has_entries mit '== 6', :304-311 die DREI CT-Proben, darunter :309-311 literal '!stamp_pod_has_entries(stamp_pod_layout_probe(7u))' mit dem Text 'ein kuenftiges Layout 7 ist ebenfalls unbekannt -- Gleichheit, nicht Ordnung'
STATUS LT. QUELLE: offen (Bau-Posten der Welle)
ABHAENGIGKEIT/FLAECHE: P5

### [w9ezc7zw6.json] 038
GEGENSTAND: POSTEN P5 -- Dateimenge WAHRSCHEINLICH + Kopplungen
ORT: s. Text
SOLL/FIX: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1.hpp:187 -- die Makro-Materialisierung von kAnatomyVersionLinesLayout ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/builder/pruef_dock/mess_konsistenz_gate.hpp -- :56/:113 Fehlerklasse stempel_layout_fremd, :142 ist_stamp_layout, :240-241 der Aufruf, :346 die Wache ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/builder/anatomy_module_loader/anatomy_module_loader.hpp:142 ; Sechs Bestandstests pinnen die 6 HART: tests/unit/test_v41_anatomy_module_abi.cpp:126 (static_assert ==6) * test_m_w12_stamp_bausteine.cpp:681,703-705 * test_w10_system_cell_values.cpp:330-332 * test_d2_mess_konsistenz_gate.cpp:149,170,226,237,274 * test_r3_mess_gate_fingerprint_biss.cpp:94,131-134 * test_e24_c10_g6_identitaets_bilanz.cpp:241 ; Moeglicherweise NEU: tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids_abi7.txt -- test_e24_c10_g6_identitaets_bilanz.cpp:241 nennt ausdruecklich, warum es sie HEUTE nicht gibt ('anders als bei den Majors 4/5/6, die jeweils an einer BEWEGTEN binary_id hingen') ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/abi/anatomy_stamp_entries.hpp (POD-Umordnung verschiebt Offsets)
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P5

### [w9ezc7zw6.json] 039
GEGENSTAND: POSTEN P5 -- Baubedarf + Begruendung
ORT: s. Text
SOLL/FIX: BAUBEDARF: VOLLBAU, groesster Kegel der Erhebung. anatomy_module_abi_v1_decl.hpp = 186 Dateien / 142 TUs / 133 Test-TUs. Die Datei ist bewusst 'leicht' gehalten (Loader-Seite), genau deshalb zieht sie fast alles. Debug UND Release noetig (die sizeof-Wache ist plattform-/ABI-abhaengig). FINGERPRINT-relevant nur ueber die ABI-Generation (abi4/5/6-Historie), NICHT ueber Glied [7] (abi/ liegt nicht im Overlay-Schnitt). || BEGRUENDUNG: Der Konflikt ist am Objekt belegt: :309-311 verbietet Layout 7 durch eine explizite CT-NEGATIV-Probe, und die Gleichheits-Wache (== 6 statt >= 5) ist mit A13-M3/K-4 begruendet. grep kAnatomyVersionLinesLayout|stamp_layout_version|stamp_pod_has_entries liefert genau die 3 Produktions- und 6 Test-Fundorte. Kegel per Rueck-Include-Huelle.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P5

### [w9ezc7zw6.json] 040
GEGENSTAND: POSTEN P6 -- Dateimenge SICHER
ORT: s. Text
SOLL/FIX: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/anatomy/abi_adapter.hpp (2735 Z., 10 Vorkommen COMDARE_CE_ENABLE_STATISTICS; :1432 in fill_observer_v3, :1799 in fill_segment_timing_v3 -- die vom Lage-Text genannten :1432/:1796 stimmen auf +-3 Z.) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/profile_facade/mess_achsen_naht.hpp (11 Vorkommen; :497 ist die EINE Emissionsstelle 'd.emplace_back("-DCOMDARE_CE_ENABLE_STATISTICS=1")', :271-273 die env-Mengen [all]/[macro], :64 die Bestandszaehlung '39 Vorkommen') ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/CMakeLists.txt (:187-198 MEASUREMENT_MODE-Zwang, :210-214 option + add_compile_definitions, :225 Observer-Push-Kopplung) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/tests/unit/CMakeLists.txt (97 Vorkommen -- der groesste Einzelbestand der Datei)
STATUS LT. QUELLE: offen (Bau-Posten der Welle)
ABHAENGIGKEIT/FLAECHE: P6

### [w9ezc7zw6.json] 041
GEGENSTAND: POSTEN P6 -- Dateimenge WAHRSCHEINLICH + Kopplungen
ORT: s. Text
SOLL/FIX: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/abi/mess_gates_glied.hpp -- :121-137 baut das mg=-Preimage-Glied aus TOOLING_WALLCLOCK/MACRO/MICRO, :290-296 + :341-353 die Wachen. Ein NEUES Micro-Gate braucht dort ein Glied, sonst unterscheidet der Fingerprint G2/G3 nicht. ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/src/measurement/measurable_concept.hpp (:33/:94/:123/:138 -- der Concept-Umschalter, die eigentliche G2/G3-Semantik) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/profile_facade/CMakeLists.txt:134 * profile_run_facade.cpp:283 * builder/anatomy_commands/anatomy_execution_context.hpp * builder/anatomy_commands/tier_observe_trace.hpp * builder/experiment_tree/cache_engine_builder_iterator.hpp * anatomy/observer_aggregate.hpp * anatomy/view_policies_observable.hpp (11) * anatomy/inner_container_observable.hpp (11) * anatomy/growth_policy_observable.hpp ; Tests: tests/unit/test_r3_mess_gates_spiegel.cpp:156 * test_m1_mess_achsen_wirkung.cpp (11) * test_a8s4_release_pfad_neutralitaet.cpp (7) * r3_mess_gate_stamp_module.cpp:31-32 * test_a1_wurf_vertrag_allokator_store.cpp (14) * test_v41_pruef_dock_search_algorithm.cpp * test_m1hb_observer_zellen_ehrlich.cpp ; RISIKO-FLAECHE (nicht beauftragt, aber im Weg): 39 Dateien unter axes/ + 13 unter topics/queuing tragen COMDARE_CE_ENABLE_STATISTICS -- alle 52 liegen in der S-14a-Lock-Domaene. Die eiserne axes/topics/heuristik-Regel gilt fuer P6 laut Lage-Text NICHT ausdruecklich.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P6

### [w9ezc7zw6.json] 042
GEGENSTAND: POSTEN P6 -- Baubedarf + Begruendung
ORT: s. Text
SOLL/FIX: BAUBEDARF: VOLLBAU. abi_adapter.hpp = 93 Dateien / 83 TUs / 81 Test-TUs; mess_gates_glied.hpp = 111/89/85; mess_achsen_naht.hpp nur 15/11/10, aber die CMake-option greift GLOBAL (add_compile_definitions in der Wurzel-CMakeLists) => jede TU. ZUSAETZLICH FINGERPRINT-WIRKSAM: libs/cache_engine/anatomy/ ist als Kategorie tier_substanz im Overlay-Schnitt (overlay_source_set.hpp:196, Form::verzeichnis, REKURSIV). Jede Byte-Aenderung an abi_adapter.hpp aendert kOverlaySourceHash -> binary_id -> golden_fullpilot_320_binary_ids.txt. P6 ist damit neben P4 der ZWEITE golden-brechende Posten. || BEGRUENDUNG: Vorkommen je Datei ausgezaehlt (grep -c ueber alle 190 Treffer-Dateien). Die Emissionsstelle :497 und die Leser-Seite mess_gates_glied.hpp:127/:133 direkt gelesen. Die Schnitt-Zugehoerigkeit von anatomy/ per overlay_source_set.hpp:190-196 belegt, die Hash-Kette per cmake/overlay_source_hash.cmake:27-45 und anatomy_fingerprint.hpp:22-30/:157.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P6

### [w9ezc7zw6.json] 043
GEGENSTAND: POSTEN P7 -- Dateimenge SICHER
ORT: s. Text
SOLL/FIX: Neue Concept-Header (Ort offen, Name offen) -- entweder libs/cache_engine/include/cache_engine/measurement/ (Bauform-Vorbild ram_probe_chain.hpp) oder libs/cache_engine/builder/experiment_tree/ (das zweite CoR-Vorbild) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/tests/unit/test_s4_*.cpp (NEU) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/tests/unit/CMakeLists.txt
STATUS LT. QUELLE: offen (Bau-Posten der Welle)
ABHAENGIGKEIT/FLAECHE: P7

### [w9ezc7zw6.json] 044
GEGENSTAND: POSTEN P7 -- Dateimenge WAHRSCHEINLICH + Kopplungen
ORT: s. Text
SOLL/FIX: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/measurement/ram_probe_chain.hpp -- Vorbild, LESEND (Kegel nur 5/4/4, winzig) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/builder/experiment_tree/selection_filter_chain.hpp -- das zweite CoR-Vorbild, das ram_probe_chain.hpp:18 selbst als Referenz nennt ('Vorbild ist selection_filter_chain.hpp') ; HARTE VORAUSSETZUNG: das P1-Ergebnis measurement/flag_menge_ordnung.hpp (S-4 'braucht S-3'). Damit ist P7 zeitlich hinter P1 gebunden, nicht nur logisch. ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/measurement/algo_semver.hpp + flag_grammar_catalog.hpp -- falls die Concepts ueber die Flag-Mengen quantifizieren (Concept B 'Mess, zweischneidig' spricht dafuer) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/tools/mess_report/dynamic_axis_filter.hpp -- dritter Nutzer desselben FilterHandler-Musters (:11 nennt selection_filter_chain.hpp::FilterHandler) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/scripts/ci_test_inventory_floor.txt
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P7

### [w9ezc7zw6.json] 045
GEGENSTAND: POSTEN P7 -- Baubedarf + Begruendung
ORT: s. Text
SOLL/FIX: BAUBEDARF: TEILBAU + ctest -- SOLANGE die neuen Header nur von den neuen Tests inkludiert werden (die beiden Vorbild-Header haben winzige Kegel: ram_probe_chain 5/4/4, selection_filter_chain nur ueber profile_facade). SOBALD die Concepts in algo_semver.hpp oder flag_grammar_catalog.hpp eingehaengt werden, kippt es auf VOLLBAU mit demselben 197/126/118-Kegel wie P1. Diese Weiche ist heute nicht entschieden -- der Baubedarf haengt an einer Design-Entscheidung, die noch aussteht. || BEGRUENDUNG: Es gibt HEUTE keine 'Filter-Concepts A/B' (grep Filter-Concept|FilterConcept|filter_concept trifft nur die Filter-ACHSE Bloom/Cuckoo/XOR unter axes/filter_axis -- anderer Gegenstand). Das Bauform-Vorbild ist am Objekt bestaetigt: ram_probe_chain.hpp:16-24 beschreibt die CoR-ohne-vtable-Form und verweist selbst auf selection_filter_chain.hpp. Kegel beider Vorbilder per Rueck-Include-Huelle.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P7

### [w9ezc7zw6.json] 046
GEGENSTAND: POSTEN P8 -- Dateimenge SICHER
ORT: s. Text
SOLL/FIX: /home/comdare/wt-super-landung/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (3,17 MB) -- LEAD-ONLY-Hotspot ; Rohtranskript ~Z. 35872 ('Alle offenen Punkte, nach Dringlichkeit') -- der A-1-Vorlagetext liegt NUR dort, nicht in den Auszuegen
STATUS LT. QUELLE: offen (Bau-Posten der Welle)
ABHAENGIGKEIT/FLAECHE: P8

### [w9ezc7zw6.json] 047
GEGENSTAND: POSTEN P8 -- Dateimenge WAHRSCHEINLICH + Kopplungen
ORT: s. Text
SOLL/FIX: /home/comdare/wt-super-landung/docs/sessions/20260812-GESAMTURTEIL-manuelle-synthese-aller-workflows-nacht-7c.md:130 (Zeile V-7: 'A-1-Vorlagetext vor jeder Backup-Ref-Loeschung nachlesen (Roh ~Z. 35872)') ; /home/comdare/wt-super-landung/docs/sessions/20260812-WF3-SYNTHESE-fuenf-kontexte-einlesen.md:145 + :208 (der Konflikt Owner-GO vs. Ledger O-5) ; /home/comdare/wt-super-landung/docs/plaene/20260812-WELLENKONSOLIDIERUNG-und-strategische-reihenfolge.md:73, :188, :263 ; /home/comdare/wt-super-landung/docs/sessions/20260812-KONTEXTUEBERGABE-nacht-7c-die-nacht-in-der-die-fragen-ausgingen.md:166, :255
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P8

### [w9ezc7zw6.json] 048
GEGENSTAND: POSTEN P8 -- Baubedarf + Begruendung
ORT: s. Text
SOLL/FIX: BAUBEDARF: KEIN BAU. Reine Doku-/Betriebsarbeit, belegt keinen der drei Vollbau-Slots und kein Blech. Einziger Engpass: der Ledger ist LEAD-ONLY, also seriell gegen P9. || BEGRUENDUNG: grep 'A-1-Vorlagetext' ueber /home/comdare/wt-super-landung/docs/ liefert 7 Fundstellen, alle in Ledger-/Session-/Plan-Dokumenten, keine einzige in Code. Im ce-Repo: 0 Treffer. Bestaetigt 'vermutlich DOKU/Betrieb, kein Code'.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P8

### [w9ezc7zw6.json] 049
GEGENSTAND: POSTEN P9 -- Dateimenge SICHER
ORT: s. Text
SOLL/FIX: /home/comdare/wt-super-landung/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md -- LEAD-ONLY-Hotspot (2 Zitat-Korrekturen + Paragraph-69.6-Vermerk + N-3-Rechnung) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine: KEINE Datei (verifiziert -- kein ce-Code)
STATUS LT. QUELLE: offen (Bau-Posten der Welle)
ABHAENGIGKEIT/FLAECHE: P9

### [w9ezc7zw6.json] 050
GEGENSTAND: POSTEN P9 -- Dateimenge WAHRSCHEINLICH + Kopplungen
ORT: s. Text
SOLL/FIX: /home/comdare/wt-super-landung/Projekte-Cluster: das Infra-Handout liegt unter /home/comdare/Projekte/Cluster/docs/sessions/ -- die neuesten Handouts dort sind 20260813-HANDOUT-od7-heavy-worker-24-auf-16.md und 2026-08-10-K144-HANDOUT-INFRA-AN-IMPL-korrektur-san-plus-prod-harbor-geheilt.md; welches Dokument genau gemeint ist, ist nicht erhoben ; /home/comdare/wt-super-landung/docs/handouts/ (heute nur 20260808-HANDOUT-INFRA-vault-wert-rotation.md)
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P9

### [w9ezc7zw6.json] 051
GEGENSTAND: POSTEN P9 -- Baubedarf + Begruendung
ORT: s. Text
SOLL/FIX: BAUBEDARF: KEIN BAU. Belegt keinen Vollbau-Slot und kein Blech. Seriell gegen P8 ueber den Ledger (EIN SCHREIBER je Worktree gilt auch dort: git commit nimmt die GANZE Staging-Area). || BEGRUENDUNG: Ledger-Ort per ls belegt (3165145 Bytes, 12.08. 21:02). Cluster-Repo als eigenes Repo unter /home/comdare/Projekte/Cluster identifiziert, Handout-Verzeichnis docs/sessions/ per find. Kein ce-Bezug: grep der Posten-Stichworte im ce-Baum leer.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P9

### [w9ezc7zw6.json] 052
GEGENSTAND: POSTEN P10 -- Dateimenge SICHER
ORT: s. Text
SOLL/FIX: /home/comdare/wt-super-landung/.gitlab-ci.yml -- LEAD-ONLY-Hotspot. :1620-1690 der Storage-#51-OPT-IN-Block (:1633 'if [ "${COMDARE_STORAGE_CACHE:-}" = "true" ]', :1635 COMDARE_MINIO_ENDPOINT/MC_HOST_-Alias, :1679 der INERT-Zweig), :1770-1790 der Bestandslog-Zweig, :1810 der Job measure:smoke ; KEINE ce-Datei: COMDARE_STORAGE_CACHE und measure:smoke kommen im ce-.gitlab-ci.yml NICHT vor (grep = 0 Treffer ueber alle 1094 Zeilen). Der Posten lebt vollstaendig im super-Repo.
STATUS LT. QUELLE: offen (Bau-Posten der Welle)
ABHAENGIGKEIT/FLAECHE: P10

### [w9ezc7zw6.json] 053
GEGENSTAND: POSTEN P10 -- Dateimenge WAHRSCHEINLICH + Kopplungen
ORT: s. Text
SOLL/FIX: /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/scripts/comdare_storage_activation.sh (ce-seitiges Aktivierungs-Skript, nur wenn der Kontrakt nachgezogen wird) ; /home/comdare/wt-super-landung/ci/comdare_bestandslog_activation.sh ; CI-Variablen/Keys von Projekt 288 -- Ort nicht erhoben (Memory-Regel: Vault nie greppen)
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P10

### [w9ezc7zw6.json] 054
GEGENSTAND: POSTEN P10 -- Baubedarf + Begruendung
ORT: s. Text
SOLL/FIX: BAUBEDARF: KEIN lokaler Bau -- aber EIN PIPELINE-SLOT. Das ist der harte Punkt: die EIN-BLECH-REGEL erlaubt hoechstens ein Pipeline-Abnahme-Paket zur Zeit, und P10 belegt es fuer die Dauer eines measure:smoke-Laufs. P10 konkurriert damit NICHT um den 3er-Vollbau-Deckel, wohl aber mit P11 (dessen Landung eine ce-Pipeline braucht) und mit jeder anderen Landung um das Blech. || BEGRUENDUNG: grep 'measure:smoke|COMDARE_STORAGE_CACHE|minio' im ce-.gitlab-ci.yml: 0 Treffer. Dieselbe Suche im super-.gitlab-ci.yml: 20+ Treffer, Job measure:smoke bei :1810, Storage-Block ab :1620. Damit ist der Posten eindeutig super-lokal und LEAD-ONLY.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P10

### [w9ezc7zw6.json] 055
GEGENSTAND: POSTEN P11 -- Dateimenge SICHER
ORT: s. Text
SOLL/FIX: Aus dem Branch-Diff development..bau/golden-s14a-riegel (git diff --stat, ohne den Worktree anzufassen) -- 9 Dateien, +1369/-180: ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/tools/axis_version_lock/axis_version_lock.cpp (+681/-...) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/tools/axis_version_lock/axis_version.lock (+338; 329 Z., 158 Zweizeilen-Records) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/tools/axis_version_lock/CMakeLists.txt (+6/-?) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/tests/unit/test_s14_axis_version_lock_tripwire.cpp (+442, NEU) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/tests/unit/CMakeLists.txt (+34 an :1916 -- MITTEN in der Datei, nicht am Ende) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/.gitlab-ci.yml (:785-812; die hartkodierte 6-Pfad-Liste faellt weg) -- LEAD-ONLY ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/hybrid/heuristik_adapter_synthese_matrix.hpp (-14/+, Kommentar) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/hybrid/README.md (-8) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/docs/architektur/20260802-hybrid_tier_stufe_soll_design.md (-9)
STATUS LT. QUELLE: offen (Bau-Posten der Welle)
ABHAENGIGKEIT/FLAECHE: P11

### [w9ezc7zw6.json] 056
GEGENSTAND: POSTEN P11 -- Dateimenge WAHRSCHEINLICH + Kopplungen
ORT: s. Text
SOLL/FIX: Das laufende Fixup ueber 22 Lens-Funde kann die Menge noch erweitern -- gemessen ist nur der Branch-Stand 8257e517, NICHT der Arbeitsstand des Bau-Agenten im Worktree (READ-ONLY-Auflage eingehalten) ; ENTWARNUNG: heuristik_adapter_synthese_matrix.hpp liegt unter libs/cache_engine/hybrid/, NICHT unter libs/cache_engine/heuristik/ -- sie ist also NICHT im eigenen Lock (die 6 heuristik-Traeger sind axis_optimization_catalog.hpp, axis_spline.hpp, break_even.hpp, measurement_curve_loader.hpp, workload_cluster_offline.hpp, workload_feature_vector.hpp) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/scripts/ci_test_inventory_floor.txt (ein Test mehr) ; /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/scripts/ci_test_coverage_manifest.sh -- der neue Test muss von mindestens einem CI-Job-Selektor getroffen werden, sonst wird test:coverage-guard ROT
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P11

### [w9ezc7zw6.json] 057
GEGENSTAND: POSTEN P11 -- Baubedarf + Begruendung
ORT: s. Text
SOLL/FIX: BAUBEDARF: NUR ctest-TEILBAU. Das Werkzeug-Target comdare_axis_version_lock ist EXCLUDE_FROM_ALL; der CI-Job konfiguriert mit 'cmake -B build-axislock -G Ninja' OHNE -DCOMDARE_BUILD_TESTS=ON und baut nur dieses eine Target. Der ctest haengt per add_dependencies + COMDARE_TEST_TARGETS am comdare_tests-Sammelbau (2-Pass-Muster), TIMEOUT 180s fuer Baumkopie ~4 MB + ~14 Tool-Laeufe mit SHA-256 ueber ~430 Dateien. Belegt aber DAS BLECH bei der Landung (ce-Pipeline). || BEGRUENDUNG: Vollstaendig aus dem Object-Store gelesen (git diff --stat + git show <branch>:<pfad>), ohne den Worktree wt-ce-golden-s14a zu beruehren. Der Lock wurde ausgezaehlt: 158 Records, Verteilung 27 axes/alloc, 19 axes/lookup, 22 topics/queuing, 11 axes/concurrency_axis, 6 heuristik, Rest ueber 13 weitere axes-Verzeichnisse. Der CMake-Block und der CI-Diff sind literal gelesen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P11

### [w9ezc7zw6.json] 058
GEGENSTAND: BAU-GRUPPE G-A mess-ordnung (P1 -> P2, seriell im selben Worktree) (Posten: P1 (S-3, Fr 14.08. F1), P2 (S-7, Sa 15.08.))
ORT: NEU /home/comdare/wt-ce-mess-ordnung; Branch 1: bau/s3-ordnungsrelation (P1); nach P1-Landung im SELBEN Verzeichnis Branch 2 vom frischen development: bau/s7-achsen-algo-stempel (P2). Ein Schreiber, ein Build-Verzeichnis.
SOLL/FIX: BEGRUENDUNG: Gemeinsame Flaeche, nicht Thema: (a) measurement/simd_build_gate.hpp ist gemeinsame Datei -- P1 zieht set_active_machine_declaration (:234) in die Fassaden-Naht, P2 konsumiert admit_organ_on_machine + active_machine_signature; (b) profile_facade/profile_run_entry.hpp ist gemeinsame Datei (P1 setzt den einen Aufruf :300-320, P2 zieht sie transitiv); (c) die VERDECKTE Kopplung ohne gemeinsame Zeile: P1 belegt erstmals active_machine_signature() und macht damit genau den Orchestrator-Gate-Block (build_orchestrator.hpp:759-771) scharf, den P2 ausbaut -- P2s Tests muessen gegen den Zustand NACH P1 stimmen; (d) beide teilen den measurement-Include-Kegel (197/126/118 vs. ~70-80 TUs) -- ein wiederverwendetes inkrementelles Bauverzeichnis spart Platte (nur 36G frei!). Seriell P1->P2 deckt sich mit den Terminen Fr->Sa. AUFLAGE fuer P2 (am Objekt neu belegt, simd_build_gate.hpp:272-278): der C-3a-Tripwire erzwingt organ_required_union_size()==0 -- die Probe-Klassen MUESSEN im Test bleiben, eine Produktions-required-Deklaration braucht einen eigenen Owner-Paket-Entscheid. Beide Posten halten die eiserne Regel (nichts unter axes/, topics/, heuristik/) und sind damit ausserhalb der S-14a-Lock-Domaene und fingerprint-neutral (kein 9er-Praefix-Treffer in overlay_source_set.hpp:177-194). || WORKTREE: NEU /home/comdare/wt-ce-mess-ordnung; Branch 1: bau/s3-ordnungsrelation (P1); nach P1-Landung im SELBEN Verzeichnis Branch 2 vom frischen development: bau/s7-achsen-algo-stempel (P2). Ein Schreiber, ein Build-Verzeichnis.
STATUS LT. QUELLE: offen (Bau-Plan-Festlegung)
ABHAENGIGKEIT/FLAECHE: P1 (S-3, Fr 14.08. F1), P2 (S-7, Sa 15.08.)

### [w9ezc7zw6.json] 059
GEGENSTAND: BAU-GRUPPE G-B abi-stempel (P3 -> P5, seriell im selben Worktree) (Posten: P3 (S-5 Stempel-Factory, Sa/So), P5 (Layout-7-Vorstufe, Landung Mo vor dem S-6-Fenster))
ORT: NEU /home/comdare/wt-ce-abi-stempel; Branch 1: bau/s5-stempel-factory (P3); nach P3-Landung im selben Verzeichnis Branch 2: bau/abi-layout7-vorstufe (P5).
SOLL/FIX: BEGRUENDUNG: Gemeinsame DATEI anatomy_module_abi_v1_decl.hpp: P5 muss die Gleichheits-Wache (==6, :287) und die CT-Negativ-Probe Layout 7 (:306-307) oeffnen; P3 fuehrt laut dem am Objekt gelesenen S-1-Nachtrag (:309-316) die Baustein-Trait-Anbindung GENAU DORT und muss die Pins byte-unberuehrt lassen -- P3 fasst die Datei also mit hoher Sicherheit an, nicht nur 'wahrscheinlich'. Dieselbe Datei traegt den GROESSTEN Kegel der Erhebung (186/142/133): zwei getrennte Worktrees hiessen zwei getrennte 186er-Vollbauten auf einer 86%-vollen Platte. Dazu gemeinsame abi/-Stempelflaeche (stempel_basis.hpp, anatomy_stamp_entries.hpp, anatomy_version_stamp.hpp, stempel_baustein_trait.hpp). Reihenfolge P3 zuerst: P3s Abhaengigkeit (S-1 gelandet, S-3 landet Fr) ist Sa erfuellt und P3 baut auf dem BESTEHENDEN Layout-6-Vertrag; P5s Frist (vor S-6a-Baubeginn Mo) liegt spaeter und seine Aenderung invalidiert die 142 TUs ohnehin erneut -- inkrementell im selben Verzeichnis. Getrennt LANDEN (zwei Pakete): getrennte Gegenstaende, getrennte Abnahmen (P5 zieht 6 Bestandstests nach, die die 6 hart pinnen). || WORKTREE: NEU /home/comdare/wt-ce-abi-stempel; Branch 1: bau/s5-stempel-factory (P3); nach P3-Landung im selben Verzeichnis Branch 2: bau/abi-layout7-vorstufe (P5).
STATUS LT. QUELLE: offen (Bau-Plan-Festlegung)
ABHAENGIGKEIT/FLAECHE: P3 (S-5 Stempel-Factory, Sa/So), P5 (Layout-7-Vorstufe, Landung Mo vor dem S-6-Fenster)

### [w9ezc7zw6.json] 060
GEGENSTAND: BAU-GRUPPE G-C gate-trennung (P6 allein) (Posten: P6 (B2 Gate-Trennung G2/G3, Sa/So))
ORT: NEU /home/comdare/wt-ce-gate-g2g3; Branch: bau/b2-gate-trennung-g2g3. golden-Regen 1 als Commit IM Paket, unmittelbar vor Push auf gemergtem development-Stand gefahren.
SOLL/FIX: BEGRUENDUNG: Eigener Strang, weil P6 der eine von zwei GOLDEN-BRECHENDEN Posten ist (anatomy/ = tier_substanz, Form::verzeichnis REKURSIV im Overlay-Schnitt, overlay_source_set.hpp:196ff): jede Byte-Aenderung an abi_adapter.hpp aendert kOverlaySourceHash -> binary_id -> golden_fullpilot_320_binary_ids.txt(+abi4/5/6). Diese Identitaets-Flaeche teilt er NUR mit P4 -- und mit dem darf er deshalb gerade NICHT parallel offen sein (beide regenerieren dieselben vier golden-Dateien vollstaendig; nicht mergebar). Seine Code-Flaeche (anatomy/abi_adapter.hpp, mess_achsen_naht.hpp:497, src/measurement/measurable_concept.hpp, abi/mess_gates_glied.hpp fuer das neue mg=-Glied, Wurzel-CMakeLists :187-225) ist zu allen anderen Straengen datei-disjunkt bis auf die Register. HARTE AUFLAGE: die 52 Statistik-Traeger unter axes/ + topics/queuing (S-14a-Lock-Domaene) NICHT anfassen -- nur Leser-/Emissions-/anatomy-Seite; da P6 nach P11 landet, schluege der Riegel sonst fail-closed an (gewollt). Das neue Micro-Gate braucht sein mess_gates_glied, sonst unterscheidet der Fingerprint G2/G3 nicht -- das ist Teil des Pakets, kein Nachtrag. || WORKTREE: NEU /home/comdare/wt-ce-gate-g2g3; Branch: bau/b2-gate-trennung-g2g3. golden-Regen 1 als Commit IM Paket, unmittelbar vor Push auf gemergtem development-Stand gefahren.
STATUS LT. QUELLE: offen (Bau-Plan-Festlegung)
ABHAENGIGKEIT/FLAECHE: P6 (B2 Gate-Trennung G2/G3, Sa/So)

### [w9ezc7zw6.json] 061
GEGENSTAND: BAU-GRUPPE G-D homes (P4 allein, startet erst nach P11- UND P6-Landung) (Posten: P4 (S-18 Kategorie-Homes + queuing-Umzug + Waechter, Landung Di/Mi -- [P] vor F2))
ORT: NEU /home/comdare/wt-ce-homes-s18; Branch: bau/s18-kategorie-homes. Bis zum Baustart (Mo) laeuft P4 als Explore/Design ohne Slot (Zuschnitt-Vorlage an Owner/Lead bis So).
SOLL/FIX: BEGRUENDUNG: Eigener Strang, weil P4 die Identitaets-Zentrale selbst anfasst: overlay_source_set.hpp (nur P4 darf diese Datei schreiben), 6 CMake-GLOB-Stellen, Registry-XML, 46 queuing-Dateien, davon 22 im S-14a-Lock. Die Kopplung an P11 ist im Riegel-Werkzeug LITERAL deklariert (am Objekt bestaetigt, axis_version_lock.cpp v2-Kopf: 'SYSTEM- und MESS-Detail-Klassen werden BEWUSST NICHT angelegt -- ihre Homes existieren noch nicht... Wer die Homes anlegt, ergaenzt die Detail-Klasse UND haengt sie in write_lock()/check_lock() ein', plus 'golden VOR Umgliederung'; OrganDetail::discover hartkodiert auf {axes, topics/queuing}, fail-closed Exit 2). P4 traegt daher in EINEM Paket: Homes + Umzug + Tool-Detail-Klassen SYSTEM/MESS + Lock-Regen (--write) + golden-Regen 2 + RE-CONFIGURE-Vollbau + Nachzug von test_s14-Tripwire-Ankern (h_disc==6/o_disc>=120) + CI-Job-Anteil als Lead-Commit. VOR Baubeginn muss der Zuschnitt-Entscheid fallen (22 vs. 46 Dateien; Praefix- vs. Verzeichnis-Form der neuen Homes) -- davon haengt ab, ob P1/P2/P7-Dateien nachtraeglich in den Fingerprint ruecken; deshalb landen P1/P2/P7 VOR P4. || WORKTREE: NEU /home/comdare/wt-ce-homes-s18; Branch: bau/s18-kategorie-homes. Bis zum Baustart (Mo) laeuft P4 als Explore/Design ohne Slot (Zuschnitt-Vorlage an Owner/Lead bis So).
STATUS LT. QUELLE: offen (Bau-Plan-Festlegung)
ABHAENGIGKEIT/FLAECHE: P4 (S-18 Kategorie-Homes + queuing-Umzug + Waechter, Landung Di/Mi -- [P] vor F2)

### [w9ezc7zw6.json] 062
GEGENSTAND: BAU-GRUPPE G-E filter-concepts (P7 mit Design-Auflage) (Posten: P7 (S-4 Filter-Concepts A+B; Start nach P1-Landung, Landung vor P4))
ORT: NEU /home/comdare/wt-ce-s4-concepts; Branch: bau/s4-filter-concepts. (Alternativzweig bei Einhaenge-Entscheid: in wt-ce-mess-ordnung als bau/s4-filter-concepts nach P2.)
SOLL/FIX: BEGRUENDUNG: Eigener kleiner Strang NUR unter der Auflage, die die offene Design-Weiche zur Paket-Grenze macht: in DIESEM Paket ausschliesslich neue Header (measurement/, Vorbild ram_probe_chain.hpp/selection_filter_chain.hpp) + neue Tests; KEIN Anfassen von algo_semver.hpp/flag_grammar_catalog.hpp (P1s Schreibflaeche). Dann ist P7 datei-disjunkt zu allem (Register ausgenommen), braucht nur TEILBAU + ctest und zaehlt NICHT gegen den 3er-Deckel. Die harte S-3-Abhaengigkeit bindet den Start hinter die P1-Landung (P7 INKLUDIERT das gelandete flag_menge_ordnung.hpp -- lesen ist kein Schreib-Konflikt). Faellt die Weiche stattdessen auf 'in algo_semver einhaengen', wandert P7 als dritter Posten in Strang G-A HINTER P2 (gleiche Schreibflaeche, gleicher Schreiber) und wird Vollbau -- dann Landung Mo/Di, immer noch vor P4. || WORKTREE: NEU /home/comdare/wt-ce-s4-concepts; Branch: bau/s4-filter-concepts. (Alternativzweig bei Einhaenge-Entscheid: in wt-ce-mess-ordnung als bau/s4-filter-concepts nach P2.)
STATUS LT. QUELLE: offen (Bau-Plan-Festlegung)
ABHAENGIGKEIT/FLAECHE: P7 (S-4 Filter-Concepts A+B; Start nach P1-Landung, Landung vor P4)

### [w9ezc7zw6.json] 063
GEGENSTAND: BAU-GRUPPE G-F lead-betrieb (P8 -> P9 -> P10, kein Bau, kein Slot) (Posten: P8 (#21 E-1..E-4-Vollzug + A-1-Vorlagetext), P9 (#22-Rest Ledger-Nachtrag + Cluster-Handout), P10 (#10 MinIO CI-Smoke, super-Repo))
ORT: KEIN neuer Worktree: /home/comdare/wt-super-landung (bestehender Lead-Worktree, der Lead ist dort der eine Schreiber); P9-Handout-Anteil im Cluster-Klon.
SOLL/FIX: BEGRUENDUNG: Gemeinsame Flaeche Ledger (P8+P9 schreiben in dieselbe 3,17-MB-Datei, LEAD-ONLY, git commit nimmt die ganze Staging-Area -> strikt seriell, getrennte Commits) und Lead-only-CI (P10 lebt komplett im super-.gitlab-ci.yml, ce-seitig 0 Treffer). Keiner belegt einen Vollbau-Slot; P10 belegt aber das BLECH (Ein-Blech-Regel) und wird darum in der Lande-Ordnung als eigenes Fenster gefuehrt. P9s Cluster-Handout liegt im getrennten Repo /home/comdare/Projekte/Cluster (kein Konflikt); WELCHES Dokument gemeint ist, ist vor Vollzug zu klaeren (Erhebungsluecke). Diese Posten fuellen die Wartezeiten des Leads zwischen den Landungen (Fr abend P8, Sa P9, So frueh P10). || WORKTREE: KEIN neuer Worktree: /home/comdare/wt-super-landung (bestehender Lead-Worktree, der Lead ist dort der eine Schreiber); P9-Handout-Anteil im Cluster-Klon.
STATUS LT. QUELLE: offen (Bau-Plan-Festlegung)
ABHAENGIGKEIT/FLAECHE: P8 (#21 E-1..E-4-Vollzug + A-1-Vorlagetext), P9 (#22-Rest Ledger-Nachtrag + Cluster-Handout), P10 (#10 MinIO CI-Smoke, super-Repo)

### [w9ezc7zw6.json] 064
GEGENSTAND: BAU-GRUPPE G-G s14a-riegel (P11, Bestand) (Posten: P11 (S-14a-Riegel: Fixup ueber 22 Lens-Funde abschliessen, dann landen))
ORT: BESTAND /home/comdare/wt-ce-golden-s14a; Branch bau/golden-s14a-riegel (unveraendert).
SOLL/FIX: BEGRUENDUNG: Bleibt wo er ist: der Fixup-Agent in wt-ce-golden-s14a ist der eine Schreiber dieses Strangs (READ-ONLY fuer alle anderen). Kein neuer Vollbau -- inkrementeller Teilbau im vorhandenen build-s14-redfirst; er zaehlt nur dann voruebergehend als Slot, wenn das Fixup einen comdare_tests-Suite-Rebuild erzwingt. Sein CI-Anteil (.gitlab-ci.yml :785-812) ist Lead-Commit. Er ist die QUERKOPPLUNG der Welle: nach seiner Landung erzwingt jede Aenderung an einem der 158 gelockten Traeger Bump oder bewussten Lock-Regen -- darum landet er frueh (direkt nach P1) und VOR P6/P4. Vor P11-Push zusaetzlich pruefen: ci_test_coverage_manifest-Treffer des neuen Tests und inventory_floor-Nachzug als eigener Commit. || WORKTREE: BESTAND /home/comdare/wt-ce-golden-s14a; Branch bau/golden-s14a-riegel (unveraendert).
STATUS LT. QUELLE: offen (Bau-Plan-Festlegung)
ABHAENGIGKEIT/FLAECHE: P11 (S-14a-Riegel: Fixup ueber 22 Lens-Funde abschliessen, dann landen)

### [w9ezc7zw6.json] 065
GEGENSTAND: KONFLIKT: tests/unit/CMakeLists.txt (6876 Z.) + Test-Wachen-Register (scripts/ci_test_inventory_floor.txt, ci_test_coverage_manifest.sh, drei Allowlists)
ORT: tests/unit/CMakeLists.txt (6876 Z.) + Test-Wachen-Register (scripts/ci_test_inventory_floor.txt, ci_test_coverage_manifest.sh, drei Allowlists)
SOLL/FIX: AUFLOESUNG: PARALLEL BAUEN, SERIELL LANDEN (Memory-Doktrin; die Erhebung sagt es selbst): die Registrierungen sind additiv und block-lokal. Regeln: (a) jeder Strang haengt seinen Block ans DATEIENDE mit Strang-Marker-Kommentar (P11s Block bei :1916 kollidiert damit textlich nicht); (b) wer landet, merged zuerst development und loest den Tail-Append-Konflikt mechanisch auf; (c) die Floor-Sprossen (avx512f/avx2/basis) sind ABSOLUTE Zahlen -- nach jedem Landungs-Merge die Inventur LIVE neu laufen lassen und die Zahl aus dem Lauf uebernehmen, NIE addieren; Nachzug als EIGENER Commit (Dateikopf-Regel). Am Objekt geklaert: der Floor ist eine UNTERGRENZE (Exit 4 nur bei Unterschreitung) -- Wachstum macht nicht rot, Nachziehen bleibt Pflicht-Hygiene; (d) coverage-guard: jeder neue Test muss von einem WIRKLICH fahrenden CI-Job-Selektor getroffen werden -- gilt fuer ALLE sieben Posten, nicht nur P11.
STATUS LT. QUELLE: offen (Konflikt mit verbindlicher Aufloesung)
ABHAENGIGKEIT/FLAECHE: betroffen: P1, P2, P3, P4, P6, P7, P11

### [w9ezc7zw6.json] 066
GEGENSTAND: KONFLIKT: golden-Identitaets-Kette: overlay_source_set.hpp -> kOverlaySourceHash -> binary_id -> golden_fullpilot_320_binary_ids.txt(+abi4/5/6) -- die vier golden-Dateien werden VOLLSTAENDIG regeneriert, nicht additiv geaendert
ORT: golden-Identitaets-Kette: overlay_source_set.hpp -> kOverlaySourceHash -> binary_id -> golden_fullpilot_320_binary_ids.txt(+abi4/5/6) -- die vier golden-Dateien werden VOLLSTAENDIG regeneriert, nicht additiv geaendert
SOLL/FIX: AUFLOESUNG: STRIKT SERIELL P6 -> P4; die beiden duerfen nicht gleichzeitig offen sein (zwei parallele Voll-Regenerationen derselben Dateien sind nicht mergebar; der Zweite muesste ohnehin komplett neu regenerieren). Jeder Regen ist paket-atomar und laeuft unmittelbar vor dem Push auf dem gemergten development-Stand. Die fingerprint-neutralen Posten (P1/P2/P3/P7, nach Objektbefund auch P5: abi_v1_decl.hpp:272-273 'KLEINES ABI-Gate, KEIN binary_id-/CRC-Bruch') duerfen dazwischen landen, ohne einen Regen zu invalidieren. comdare_overlay_source_hash ist ALL-Target an jedem Ziel: P4 zusaetzlich mit erzwungenem RE-CONFIGURE (6 GLOB-Stellen!), sonst falsches Gruen (Klasse J-1..J-4).
STATUS LT. QUELLE: offen (Konflikt mit verbindlicher Aufloesung)
ABHAENGIGKEIT/FLAECHE: betroffen: P6, P4, (P5 nur im Rueckfall)

### [w9ezc7zw6.json] 067
GEGENSTAND: KONFLIKT: abi/anatomy_module_abi_v1_decl.hpp (groesster Kegel 186/142/133; Layout-Wache ==6 :287, CT-Negativ-Probe Layout 7 :306-307, S-1-Trait-Anbindung :309-316, Pins byte-unberuehrt)
ORT: abi/anatomy_module_abi_v1_decl.hpp (groesster Kegel 186/142/133; Layout-Wache ==6 :287, CT-Negativ-Probe Layout 7 :306-307, S-1-Trait-Anbindung :309-316, Pins byte-unberuehrt)
SOLL/FIX: AUFLOESUNG: EIN Strang G-B, ein Schreiber, seriell P3 -> P5 im selben Worktree; niemals gleichzeitig offen. P3 baut auf Layout-6-Bestand, P5 oeffnet danach die Wachen-Mechanik und zieht die 6 Bestandstests nach, die die 6 hart pinnen (test_v41, test_m_w12, test_w10, test_d2, test_r3, test_e24_c10).
STATUS LT. QUELLE: offen (Konflikt mit verbindlicher Aufloesung)
ABHAENGIGKEIT/FLAECHE: betroffen: P3, P5

### [w9ezc7zw6.json] 068
GEGENSTAND: KONFLIKT: measurement/simd_build_gate.hpp + profile_facade/profile_run_entry.hpp + VERDECKTE Kopplung: P1s Erstbelegung von active_machine_signature() macht den Orchestrator-Gate-Block (build_orchestrator.hpp:759-771) scharf, den 
ORT: measurement/simd_build_gate.hpp + profile_facade/profile_run_entry.hpp + VERDECKTE Kopplung: P1s Erstbelegung von active_machine_signature() macht den Orchestrator-Gate-Block (build_orchestrator.hpp:759-771) scharf, den P2 ausbaut -- Kopplung ohne ge
SOLL/FIX: AUFLOESUNG: EIN Strang G-A, seriell P1 -> P2; P2 setzt erst auf dem GELANDETEN P1 auf (neuer Branch vom frischen development). Zusatz-Auflagen aus dem Objektbefund: (a) P2s Probe-Klassen bleiben IM TEST -- der C-3a-Tripwire (simd_build_gate.hpp:272-278) macht jede Produktions-required-Deklaration compile-hart rot und verlangt dafuer einen eigenen Owner-Paket-Entscheid; (b) P1 passt die Vor-/Nachbedingungen der zwei heutigen Test-Aufrufer (test_c3a, test_o4; prozess-globaler Latch + reset_for_test) im selben Paket an; (c) die ODR-Frage Naht im Header (profile_run_entry.hpp) vs. TU (profile_run_facade.cpp) ist im P1-Design VOR dem Commit zu entscheiden.
STATUS LT. QUELLE: offen (Konflikt mit verbindlicher Aufloesung)
ABHAENGIGKEIT/FLAECHE: betroffen: P1, P2

### [w9ezc7zw6.json] 069
GEGENSTAND: KONFLIKT: measurement/algo_semver.hpp + flag_grammar_catalog.hpp: P1 schreibt (Wache :1003 + Traversal :905 + Ketten-Tabelle), 16 Bestands-Traeger fuehren static_asserts auf ce_owned_version_is_wellformed, 8 Bestandstests fahren d
ORT: measurement/algo_semver.hpp + flag_grammar_catalog.hpp: P1 schreibt (Wache :1003 + Traversal :905 + Ketten-Tabelle), 16 Bestands-Traeger fuehren static_asserts auf ce_owned_version_is_wellformed, 8 Bestandstests fahren die Wache direkt, test_vs_taxon
SOLL/FIX: AUFLOESUNG: P1 landet ZUERST (Fr, F1). Ein schaerferer Konjunktions-Term kann die 16 Traeger rot machen, ohne dass P1 sie anfasst -- ihre Gruen-Pruefung ist Teil des P1-Verifikationsumfangs und wird VOR der Landung geschlossen (Owner-Dauerregel 13.08.: kein 'Randfall'). KEINE Umbenennung/Verschiebung der Wache (der Taxonomie-Grep-Test braeche still). P7 fasst die beiden Dateien in seinem Paket NICHT an (Design-Auflage G-E); die Einhaengung ist ein eigener spaeterer Posten in G-A.
STATUS LT. QUELLE: offen (Konflikt mit verbindlicher Aufloesung)
ABHAENGIGKEIT/FLAECHE: betroffen: P1 (Schreiber), P2/P3 (passiv ueber static_asserts), P7 (Einhaenge-Versuchung)

### [w9ezc7zw6.json] 070
GEGENSTAND: KONFLIKT: S-14a-Lock-Domaene (158 SHA-256-gelockte Dateien unter axes/ + topics/queuing/ + heuristik/) und das Riegel-Werkzeug selbst
ORT: S-14a-Lock-Domaene (158 SHA-256-gelockte Dateien unter axes/ + topics/queuing/ + heuristik/) und das Riegel-Werkzeug selbst
SOLL/FIX: AUFLOESUNG: P11 landet VOR P4 -- zwingend, nicht nur ordentlich: das Tool deklariert die Kopplung literal ('golden VOR Umgliederung'; discover fail-closed Exit 2 auf {axes, topics/queuing}); eine P4-zuerst-Ordnung machte P11 rot. P4 traegt Tool-Detail-Klassen SYSTEM/MESS + write_lock/check_lock-Einhaengung + Lock-Regen-Commit fuer die 22 bewegten Traeger + Tripwire-Anker-Nachzug im SELBEN Paket. P6 bekommt die harte Auflage, die Domaene nicht anzufassen; da P6 nach P11 landet, faellt ein Verstoss fail-closed auf -- dann STOP und expliziter Lead-Entscheid Bump vs. Lock-Regen, nicht im P6-Paket verstecken. P1/P2 sind per eiserner Regel deckungsgleich ausgenommen; P3/P5/P7 beruehren die Domaene nicht.
STATUS LT. QUELLE: offen (Konflikt mit verbindlicher Aufloesung)
ABHAENGIGKEIT/FLAECHE: betroffen: P11 (Besitzer), P4 (bewegt 22 gelockte Traeger + muss das Tool erweitern), P6 (stille Gefahr: 52 Statistik-Traeger in der Domaene)

### [w9ezc7zw6.json] 071
GEGENSTAND: KONFLIKT: Wurzel-CMakeLists.txt (P4: :1055-1076 configure_file q1/q2 + :1619-1640 Legacy-Roots; P6: :187-225 MEASUREMENT_MODE/option/add_compile_definitions)
ORT: Wurzel-CMakeLists.txt (P4: :1055-1076 configure_file q1/q2 + :1619-1640 Legacy-Roots; P6: :187-225 MEASUREMENT_MODE/option/add_compile_definitions)
SOLL/FIX: AUFLOESUNG: Durch die golden-Serialitaet (P6 -> P4) ohnehin nie gleichzeitig offen; disjunkte Regionen, der Landungs-Merge ist trivial. Kein weiterer Eingriff noetig -- nur nicht vergessen, dass P4 auch hier RE-CONFIGURE ausloest.
STATUS LT. QUELLE: offen (Konflikt mit verbindlicher Aufloesung)
ABHAENGIGKEIT/FLAECHE: betroffen: P4, P6

### [w9ezc7zw6.json] 072
GEGENSTAND: KONFLIKT: .gitlab-ci.yml beider Repos (LEAD-ONLY) + EIN-BLECH-REGEL (hoechstens ein Pipeline-Abnahme-Paket zur Zeit) + R4 (seriell je Ref)
ORT: .gitlab-ci.yml beider Repos (LEAD-ONLY) + EIN-BLECH-REGEL (hoechstens ein Pipeline-Abnahme-Paket zur Zeit) + R4 (seriell je Ref)
SOLL/FIX: AUFLOESUNG: Alle CI-Aenderungen als Lead-Commits im jeweiligen Paket (die Bau-Agenten liefern den Diff-Vorschlag, der Lead committet). Das Blech wird streng nach der Lande-Ordnung vergeben; P10 belegt es als eigenes Fenster (So frueh) und laeuft NIE waehrend einer ce-Abnahme. Zusatz-Vorsicht: LOKAL=prod1 -- wenn die Abnahme-Pipeline auf prod1-Runnern baut, zaehlt sie faktisch gegen Platte/RAM der Maschine: waehrend einer laufenden Abnahme-Pipeline hoechstens ZWEI lokale Vollbauten.
STATUS LT. QUELLE: offen (Konflikt mit verbindlicher Aufloesung)
ABHAENGIGKEIT/FLAECHE: betroffen: P11 (ce contract:axis-version-lock :785-812), P4 (ce, falls Job-Anpassung an neue Homes), P10 (super measure:smoke :1810 + Storage-Block :1620-1690)

### [w9ezc7zw6.json] 073
GEGENSTAND: KONFLIKT: docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (3,17 MB, LEAD-ONLY)
ORT: docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (3,17 MB, LEAD-ONLY)
SOLL/FIX: AUFLOESUNG: Seriell beim Lead im bestehenden wt-super-landung (ein Schreiber; git commit nimmt die ganze Staging-Area): Fr abend P8, danach P9 als getrennter Commit. Kein Bau, kein Blech.
STATUS LT. QUELLE: offen (Konflikt mit verbindlicher Aufloesung)
ABHAENGIGKEIT/FLAECHE: betroffen: P8, P9

### [w9ezc7zw6.json] 074
GEGENSTAND: KONFLIKT: Namensraeume tests/unit/test_s5_* und test_s7_* (28 Bestandsdateien mit ANDEREM Gegenstand: Allokator-Konformitaet bzw. Pool-Allokator-Degradation)
ORT: Namensraeume tests/unit/test_s5_* und test_s7_* (28 Bestandsdateien mit ANDEREM Gegenstand: Allokator-Konformitaet bzw. Pool-Allokator-Degradation)
SOLL/FIX: AUFLOESUNG: Neue Tests bekommen sprechende, kollisionsfreie Namen: test_s7_achsen_stempel_* (P2), test_s5_stempel_factory_* / test_s5_composite_* (P3); analog test_s3_ordnung_* (P1), test_s4_filter_concept_* (P7), test_s18_home_waechter_* (P4). Vor der Landung je Paket pruefen, dass die neuen Namen von einem realen CI-Job-Selektor gefahren werden und keinen bestehenden ctest -R-Selektor der Altbestaende kapern (coverage-guard).
STATUS LT. QUELLE: offen (Konflikt mit verbindlicher Aufloesung)
ABHAENGIGKEIT/FLAECHE: betroffen: P2, P3

### [w9ezc7zw6.json] 075
GEGENSTAND: KONFLIKT: include/cache_engine/measurement/ als kuenftiges MESS-/SYSTEM-Home: P1/P2/P7 legen dort neue Dateien an, P4 disponiert das Verzeichnis um; heute erfassen 9 datei_praefix-Eintraege genau 17 Dateien -- neue Dateien mit and
ORT: include/cache_engine/measurement/ als kuenftiges MESS-/SYSTEM-Home: P1/P2/P7 legen dort neue Dateien an, P4 disponiert das Verzeichnis um; heute erfassen 9 datei_praefix-Eintraege genau 17 Dateien -- neue Dateien mit anderem Namen fallen automatisch 
SOLL/FIX: AUFLOESUNG: P1/P2/P7 landen VOR P4 (sie bleiben bei ihrer Landung fingerprint-neutral; P4s spaeterer Regen erfasst den Endstand ohnehin). NUR P4 schreibt overlay_source_set.hpp. Der P4-Zuschnitt-Entscheid (Verschieben der 17 Praefix-Dateien vs. neues Verzeichnis; Praefix- vs. Verzeichnis-Form) faellt VOR P4-Baubeginn als Owner-/Lead-Entscheid und benennt AUSDRUECKLICH, ob die neuen Dateien (flag_menge_ordnung.hpp, S-7-Bruecke, S-4-Concepts) in den Fingerprint aufgenommen werden -- sonst stille Preimage-Ausweitung oder stille Luecke.
STATUS LT. QUELLE: offen (Konflikt mit verbindlicher Aufloesung)
ABHAENGIGKEIT/FLAECHE: betroffen: P1, P2, P7, P4

### [w9ezc7zw6.json] 076
GEGENSTAND: KONFLIKT: Branch w0b/durchstich-kette (188 Diff-Zeilen auf profile_run_entry.hpp, wuerde test_s1_stempel_basis_vertrag.cpp mit 510 Z. loeschen); der zugehoerige Worktree wt-ce-messvisitor existiert NICHT mehr, nur der Branch lebt
ORT: Branch w0b/durchstich-kette (188 Diff-Zeilen auf profile_run_entry.hpp, wuerde test_s1_stempel_basis_vertrag.cpp mit 510 Z. loeschen); der zugehoerige Worktree wt-ce-messvisitor existiert NICHT mehr, nur der Branch lebt
SOLL/FIX: AUFLOESUNG: Branch dokumentiert stilllegen (Vermerk im Paket-/Sessions-Doc, nicht loeschen ohne Owner-GO): er ist gegen development veraltet und kollidiert frontal mit P1s Naht-Datei und dem S-1-Bestand. Wird der Mess-Visitor-Durchstich wieder gebraucht, wird er NEU auf dem Stand nach P1/P2 aufgesetzt, nie gemergt.
STATUS LT. QUELLE: offen (Konflikt mit verbindlicher Aufloesung)
ABHAENGIGKEIT/FLAECHE: betroffen: P1, P3 (test_s1 ist Vertrags-Grundlage)

### [w9ezc7zw6.json] 077
GEGENSTAND: BAU-ORDNUNG (Slots, Platten-Hygiene ZUERST: 86% voll/36G frei; KON55-Kombibau nur fuer Lande-Abnahme; Slot-Plan Do-Mi)
ORT: unbekannt
SOLL/FIX: VORAB (Do abend, ohne Slot): Platten-Hygiene ZUERST -- df zeigt 86% voll, nur 36G frei; das ist fuer 3 parallele Vollbauten + prod1-CI-Runner knapp. Alte super-Worktrees (wt-super-d3naht, wt-super-strangc, wt-super-warn, wt-uebergabe-0608) nach KON49-Prozedur pruefen (ALLE Submodul-Branches, nie nur super-HEAD) und nur Freigegebenes raeumen; Vorsicht: ce-build-Verzeichnisse koennen getrackte Mess-CSV tragen, nie blind rm. wt-ce-q6 ist in git worktree list bereits NICHT mehr vorhanden (Erhebungskorrektur). df-Check vor JEDEM Bau-Start (volle Platte legt auch die Hooks lahm).

SLOT-REGELN: Der Deckel zaehlt LAUFENDE Vollbauten, nicht offene Straenge. Ein KON55-Kombibau (gcc+clang x Debug+Release, 4 Zellen NACHEINANDER) = 1 Slot, dauert aber lange -- Kombibau nur fuer die Lande-Abnahme, Zwischenstaende mit einer Zelle (gcc Debug). Teilbauten (P7, P11-ctest) zaehlen nicht. Konservativ-Regel wegen LOKAL=prod1: waehrend eine Abnahme-Pipeline auf prod1-Runnern baut, lokal hoechstens ZWEI Vollbauten.

DIE DREI ERSTEN (Do abend/Fr): Slot 1 = G-A/P1 (Vollbau nach J-1..J-4: Werkzeuge, RE-CONFIGURE, --target comdare_tests, ctest; Fr die KON55-Abnahme -- F1 haengt daran, P1 hat Vorfahrt vor allem). Slot 2 = G-G/P11-Fixup (inkrementell in build-s14-redfirst; zaehlt nur als Slot, solange der comdare_tests-Rebuild laeuft -- sonst frei). Slot 3 = G-C/P6 (Baubeginn Fr nachmittag; golden-Regen erst am Ende auf Merge-Stand).

NACHRUECKER: Sa frueh rueckt G-B/P3 in den frei gewordenen P11-Slot (P11 landet Fr abend/Sa frueh). Sa uebernimmt G-A denselben Slot-1 mit P2 (neuer Branch, inkrementelles Bauverzeichnis). G-E/P7 startet Sa nach P1-Landung als TEILBAU ohne Slot (Design-Auflage: nicht einhaengen). So: P6-Abnahme + Landung, P3-Abnahme + Landung; Slot 1 wird frei (Reserve fuer Rot-Reparaturen). Mo: Slot 2 (G-B) faehrt P5 (186er-Kegel, Debug UND Release -- die sizeof-Wache ist ABI-abhaengig), Landung Mo; Slot 1 = G-D/P4-Baubeginn (RE-CONFIGURE-Vollbau; Voraussetzungen: P11 + P6 gelandet, Zuschnitt-Entscheid liegt vor); Slot 3 bleibt ab Mo fuer das S-6a-Fenster reserviert (fremdes Paket; dessen Memory-Explore-Pflicht muss am WE ohne Slot erfuellt werden -- faellt S-6 aus, erbt P4 den Slot als Beschleunigung). Di: P4-Abnahme (Vollbau + golden-Regen 2 + Lock-Regen), Landung Di abend/Mi.

WARTEND IN EXPLORE/DESIGN (kein Slot): P4-Zuschnitt (Owner-Vorlage bis So: 22-vs-46, Praefix-vs-Verzeichnis, Aufnahme der neuen measurement-Dateien in den Schnitt); P7-Einhaenge-Weiche (dokumentieren, NICHT in diesem Paket bauen); S-6-Explore (fremd). OHNE BAU parallel jederzeit: P8 (Fr abend), P9 (Sa), P10 (So frueh, nur Blech). Mi/Do = Puffer vor F2 -- gefuellt wird er mit Rot-Reparaturen, nie mit vorgezogenen Neu-Straengen.
STATUS LT. QUELLE: offen (verbindliche Bau-Ordnung)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 078
GEGENSTAND: LANDE-ORDNUNG seriell 1.P1(Fr F1) 2.P11 3.P2(Sa) 4.P10(So frueh) 5.P6(So) 6.P3 7.P5(Mo) 8.P7 9.P4(Di/Mi); P8/P9 blechfrei parallel; alle [P]-Posten mit >=2 Tagen Luft vor F2
ORT: unbekannt
SOLL/FIX: Seriell (R4 je Ref + Ein-Blech), in dieser Reihenfolge:
1. P1 (Fr 14.08.) -- F1-Frist ist die haerteste der Welle; Basis fuer P2 (Gate-Scharfschaltung), P3 (braucht S-3) und P7; fingerprint-neutral, beruehrt keine Lock-Datei -- zum Riegel ordnungsfrei, die Frist entscheidet.
2. P11 (Fr abend/Sa frueh, sobald das Fixup verifiziert ist) -- der Riegel kommt so frueh wie moeglich, damit die Lock-Disziplin steht, BEVOR die golden-brechenden Posten landen (jeder versehentliche Griff in die Domaene faellt ab dann fail-closed auf); einzige harte Vorbedingung fuer P4 ('golden VOR Umgliederung'). Er darf P1 nicht blockieren: zieht das Fixup sich, ruecken P2/P6 vor und P11 landet im naechsten freien Fenster -- hart noetig ist nur P11 VOR P4 und praktisch VOR P6.
3. P2 (Sa) -- S-7-Termin; setzt auf gelandetem P1 auf; macht den Orchestrator-Gate-Block konsumierend, bevor P4 die measurement-Flaeche disponiert.
4. P10 (So frueh, Blech-Fenster) -- super-Pipeline, beruehrt keine ce-Ref; flexibel in JEDES freie Blech-Fenster verschiebbar, nur nie waehrend einer ce-Abnahme.
5. P6 (So) -- golden-Regen 1; muss vor P4 (golden-Serialitaet) und soll nach P11 (Riegel-Schutz gegen die 52-Traeger-Gefahr); [P] vor F2 damit frueh gesichert.
6. P3 (So abend/Mo frueh) -- Stempel-Factory auf Layout-6-Stand; strang-intern zwingend vor P5 (gleiche Datei, gleicher Schreiber).
7. P5 (Mo) -- VOR dem S-6a-Baubeginn (der die Layout-7-Oeffnung braucht); nach Objektbefund golden-neutral (abi_v1_decl.hpp:272-273: kein binary_id-Bruch), im Rueckfall traegt es einen eigenen Regen und die Position zwischen P6 und P4 haelt trotzdem.
8. P7 (Mo abend/Di frueh) -- nach P1 (S-3-Bedarf), vor P4: der measurement-Bestand muss vollstaendig sein, bevor P4 das Home zuschneidet; sachlich duerfte P7 auch frueher (ab So), das Blech gibt es erst hier her.
9. P4 (Di abend, spaetestens Mi) -- bewusst LETZTER Preimage-Posten: nach P11 (Tool-Erweiterung + Lock-Regen), nach P6 (zweiter golden-Regen), nach P1/P2/P7 (Home-Bestand komplett); RE-CONFIGURE-Nachweis, golden-Regen 2 und Lock-Regen-Commit im Paket; danach bleiben Mi/Do als F2-Puffer.
P8/P9 laufen blechfrei parallel (untereinander seriell ueber den Ledger: P8 vor P9, Fr/Sa). Damit landen ALLE [P]-Posten (P1, P2, P6, P4 -- plus P3/P5/P7 als Zulieferer) mit mindestens zwei Tagen Luft vor F2 (Fr 21.08.).
STATUS LT. QUELLE: offen (verbindliche Lande-Ordnung)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 079
GEGENSTAND: PLAN-RISIKO[0]: P11-Fixup (22 Lens-Funde) zieht sich
ORT: unbekannt
SOLL/FIX: P11-Fixup (22 Lens-Funde) zieht sich: P4 darf den Riegel NIE ueberholen (fail-closed Exit 2 des Tools, golden-Baseline 'VOR Umgliederung') -- P4-Start rutscht dann. Gegenmassnahme: P4-Design/Zuschnitt-Vorlage laeuft parallel ohne Slot; Puffer reicht bis Mi/Do; ausserdem P11 aus dem kritischen Pfad von P2/P6 nehmen (Lande-Ordnung erlaubt Vorruecken).
STATUS LT. QUELLE: offen (Risiko mit Gegenmassnahme)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 080
GEGENSTAND: PLAN-RISIKO[1]: P1 macht die 16 static_assert-Bestandstraeger oder die 8 Bestandstests rot (schaerferer Konjunktions-Term) und gefaehrdet F1 MORGEN. Gegenmassnahme
ORT: unbekannt
SOLL/FIX: P1 macht die 16 static_assert-Bestandstraeger oder die 8 Bestandstests rot (schaerferer Konjunktions-Term) und gefaehrdet F1 MORGEN. Gegenmassnahme: Traeger-Liste VOR dem Term-Commit einzeln durchpruefen; Fallback zweistufig (Term zunaechst fuer neue Belegungen scharf, Bestands-Haertung als Folge-Commit im SELBEN Paket -- Owner-Dauerregel: Funde vor der Landung schliessen); alle anderen Slots pausieren notfalls, bis P1 gelandet ist.
STATUS LT. QUELLE: offen (Risiko mit Gegenmassnahme)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 081
GEGENSTAND: PLAN-RISIKO[2]: PLATTE
ORT: unbekannt
SOLL/FIX: PLATTE: 86% voll, 36G frei -- drei Bauverzeichnisse plus prod1-CI-Runner-Bauten koennen das sprengen; volle Platte legt auch Bash/Read/Hooks lahm (Selbsthilfe faellt aus). Gegenmassnahme: Hygiene vor Start, df-Check vor jedem Bau, Bauverzeichnis-Wiederverwendung in G-A/G-B, build-s14-redfirst nach P11-Landung raeumen (Vorsicht getrackte CSV), Notausstieg rm -rf ~/.cache/uv/builds-v0 kennen.
STATUS LT. QUELLE: offen (Risiko mit Gegenmassnahme)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 082
GEGENSTAND: PLAN-RISIKO[3]: Abnahme-Pipelines bauen auf prod1-Runnern (LOKAL=prod1)
ORT: unbekannt
SOLL/FIX: Abnahme-Pipelines bauen auf prod1-Runnern (LOKAL=prod1): der 3er-Deckel ist real ein Maschinen-Budget -- wer 3 lokale Bauten UND eine Lande-Pipeline faehrt, faehrt effektiv 4+. Gegenmassnahme: waehrend jeder Abnahme hoechstens 2 lokale Vollbauten; Pipelines streng sequentiell (OOM-Regel).
STATUS LT. QUELLE: offen (Risiko mit Gegenmassnahme)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 083
GEGENSTAND: PLAN-RISIKO[4]: P6 greift doch in die 52 Statistik-Traeger unter axes/+topics/queuing
ORT: unbekannt
SOLL/FIX: P6 greift doch in die 52 Statistik-Traeger unter axes/+topics/queuing: nach P11-Landung schlaegt der Riegel an -- dann STOP und expliziter Lead-Entscheid (Bump vs. Lock-Regen) statt stillem Fix im Paket; schlimmstenfalls verliert P6 einen Tag. Die Auflage (nur Leser-/anatomy-/Emissions-Seite) steht darum im Auftragstext des Strangs.
STATUS LT. QUELLE: offen (Risiko mit Gegenmassnahme)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 084
GEGENSTAND: PLAN-RISIKO[5]: Der P4-Zuschnitt-Entscheid faellt spaet oder falsch
ORT: unbekannt
SOLL/FIX: Der P4-Zuschnitt-Entscheid faellt spaet oder falsch: entstehen die Homes als Form::verzeichnis ueber dem heutigen measurement/, ruecken P1/P2/P7-Dateien nachtraeglich in den Fingerprint -- P4s Regen deckt das technisch, aber die Preimage-MENGE ist eine Identitaets-Entscheidung des Owners; ohne Entscheid bis So kippt der Mo-Baustart. Eskalation: Owner-Frage mit beiden Varianten und Preimage-Folgen bis Sa abend vorlegen.
STATUS LT. QUELLE: offen (Risiko mit Gegenmassnahme)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 085
GEGENSTAND: PLAN-RISIKO[6]: Merge-Ueberraschung an den Registern
ORT: unbekannt
SOLL/FIX: Merge-Ueberraschung an den Registern: die Floor-Sprossen sind Absolutzahlen und die CMakeLists-Tail-Bloecke kollidieren bei jeder zweiten Landung -- wer nach dem Merge nicht LIVE neu zaehlt (Inventur fahren, nicht addieren), landet falsches Gruen. In jede Lande-Checkliste aufgenommen.
STATUS LT. QUELLE: offen (Risiko mit Gegenmassnahme)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 086
GEGENSTAND: PLAN-RISIKO[7]: Blech-Stau
ORT: unbekannt
SOLL/FIX: Blech-Stau: 9 ce-Landungen + P10 in ~5 Tagen bei striktem R4; EINE rote Abnahme staut die ganze Kette. Gegenmassnahme: nur fertig verifizierte Pakete aufs Blech (kein Debug auf dem Blech), Landungen nachts takten, P10 als Lueckenfueller flexibel halten; Reserve-Slot (ab So) repariert Rot sofort lokal.
STATUS LT. QUELLE: offen (Risiko mit Gegenmassnahme)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 087
GEGENSTAND: PLAN-RISIKO[8]: P5-Rueckfall
ORT: unbekannt
SOLL/FIX: P5-Rueckfall: erweist sich die Layout-7-Oeffnung wider den Objektbefund doch als golden-wirksam (etwa weil S-6a-Vorgriffe die binary_id bewegen), braucht P5 einen eigenen Regen -- die Lande-Position (zwischen P6 und P4) haelt das aus, aber der Mo wird eng; dann P5-Landung vor Di frueh ziehen und S-6a-Start verschieben.
STATUS LT. QUELLE: offen (Risiko mit Gegenmassnahme)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 088
GEGENSTAND: PLAN-RISIKO[9]: S-6-Fenster (Mo-Mi) konkurriert um Slots und Blech, und seine Memory-Explore-Pflicht ('an S-6 wird NICHTS gebaut, bis der Glieder-Reihenfolge-Explore 
ORT: unbekannt
SOLL/FIX: S-6-Fenster (Mo-Mi) konkurriert um Slots und Blech, und seine Memory-Explore-Pflicht ('an S-6 wird NICHTS gebaut, bis der Glieder-Reihenfolge-Explore steht') ist noch offen -- faellt der Explore nicht bis So, verschiebt sich das Fenster; der Plan haelt Slot 3 ab Mo frei, erbt ihn aber fuer P4, statt ihn verfallen zu lassen.
STATUS LT. QUELLE: offen (Risiko mit Gegenmassnahme)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 089
GEGENSTAND: PLAN-RISIKO[10]: Der Branch w0b/durchstich-kette wird versehentlich wiederbelebt/gemergt
ORT: unbekannt
SOLL/FIX: Der Branch w0b/durchstich-kette wird versehentlich wiederbelebt/gemergt: er loescht test_s1 (510 Z., S-1-Vertragsgrundlage von P3) und ueberschreibt P1s Naht-Datei mit 188 veralteten Diff-Zeilen. Stilllegungs-Vermerk gehoert in die Fr-Session-Doku, bevor die Welle Fahrt aufnimmt.
STATUS LT. QUELLE: offen (Risiko mit Gegenmassnahme)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 090
GEGENSTAND: ERHEBUNGS-KRITIK[0]: WORKTREE-BESTAND FALSCH
ORT: unbekannt
SOLL/FIX: WORKTREE-BESTAND FALSCH: Die Erhebung fuehrt /home/comdare/wt-ce-messvisitor als 'STEHENGEBLIEBENEN Worktree' -- das Verzeichnis existiert nicht, und git worktree list im ce kennt nur das super-Submodul und wt-ce-golden-s14a; auch das in der Lage genannte wt-ce-q6 ist dort nicht (mehr) registriert. Real lebt nur der BRANCH w0b/durchstich-kette. Die Konsequenz (stilllegen, nie mergen) bleibt, aber der erhobene Bestand stimmte nicht.
STATUS LT. QUELLE: offen (Korrektur an der eigenen Erhebung -- fuer Folge-Nutzer bindend)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 091
GEGENSTAND: ERHEBUNGS-KRITIK[1]: FINGERPRINT-NEUTRALITAET NUR FUER GLIED [7] GEPRUEFT
ORT: unbekannt
SOLL/FIX: FINGERPRINT-NEUTRALITAET NUR FUER GLIED [7] GEPRUEFT: 'FINGERPRINT-NEUTRAL' wird bei P1/P2/P3 allein aus dem Overlay-Schnitt abgeleitet. Andere Preimage-Glieder (toolchain_stamp_glied, mess_gates_glied, ABI-Generation, Systemachsen-Grammatik -- P1s Geschlossenheits-Wache liegt an machine_simd_signature!) sind ungeprueft. Je Paket gehoert ein Preimage-/binary_id-Differenzbeweis (Probe vorher/nachher) in die Lande-Checkliste, nicht nur die Glied-[7]-Betrachtung.
STATUS LT. QUELLE: offen (Korrektur an der eigenen Erhebung -- fuer Folge-Nutzer bindend)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 092
GEGENSTAND: ERHEBUNGS-KRITIK[2]: P5/GOLDEN-FRAGE OFFEN GELASSEN, OBWOHL DIE ANTWORT IM OBJEKT STEHT
ORT: unbekannt
SOLL/FIX: P5/GOLDEN-FRAGE OFFEN GELASSEN, OBWOHL DIE ANTWORT IM OBJEKT STEHT: abi_v1_decl.hpp:269-273 sagt woertlich 'KLEINES ABI-Gate, KEIN binary_id-/CRC-Bruch (binary_id bleibt Organ-only)' -- zusammen mit test_e24_c10:241-242 (abi7-golden fehlt, weil 4/5/6 an BEWEGTER binary_id hingen) ist P5 voraussichtlich golden-neutral. Die Erhebung haette diese Zeilen zitieren muessen statt 'moeglicherweise NEU abi7.txt' zu raten -- davon haengt die golden-Serialisierung ab.
STATUS LT. QUELLE: offen (Korrektur an der eigenen Erhebung -- fuer Folge-Nutzer bindend)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 093
GEGENSTAND: ERHEBUNGS-KRITIK[3]: C-3A-TRIPWIRE ALS P2-AUFLAGE FEHLT
ORT: unbekannt
SOLL/FIX: C-3A-TRIPWIRE ALS P2-AUFLAGE FEHLT: simd_build_gate.hpp:272-278 macht organ_required_union_size()==0 compile-hart und verlangt VOR der ersten Produktions-required-Deklaration einen eigenen Owner-Paket-Entscheid. Fuer P2 ist das eine harte Design-Leitplanke (Proben NUR im Test) -- die Erhebung listet die Datei, aber nicht diese Regel.
STATUS LT. QUELLE: offen (Korrektur an der eigenen Erhebung -- fuer Folge-Nutzer bindend)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 094
GEGENSTAND: ERHEBUNGS-KRITIK[4]: INVENTORY-FLOOR-SEMANTIK WAR AM OBJEKT KLAERBAR
ORT: unbekannt
SOLL/FIX: INVENTORY-FLOOR-SEMANTIK WAR AM OBJEKT KLAERBAR: Der Dateikopf sagt UNTERGRENZE, coverage_guard meldet NENNER-BEFUND Exit 4 bei UNTERSCHREITUNG -- Testwachstum macht die Wache nicht rot. Die Erhebung liess das als 'nicht gelesen' stehen und erzeugte damit ein Schein-Risiko; uebrig bleibt die Nachzieh-Pflicht als eigener Commit.
STATUS LT. QUELLE: offen (Korrektur an der eigenen Erhebung -- fuer Folge-Nutzer bindend)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 095
GEGENSTAND: ERHEBUNGS-KRITIK[5]: P3-ABI-BERUEHRUNG ZU WEICH
ORT: unbekannt
SOLL/FIX: P3-ABI-BERUEHRUNG ZU WEICH: Der S-1-Nachtrag in abi_v1_decl.hpp:309-316 (Trait-Anbindung lebt DORT, Zweitpass-Fix 12.08.) macht das Anfassen der Datei durch P3 praktisch sicher, nicht 'wahrscheinlich' -- damit ist der 186er-Kegel fuer P3 der Regelfall und der Ein-Strang-Zwang P3/P5 haerter, als die Erhebung ihn gewichtet.
STATUS LT. QUELLE: offen (Korrektur an der eigenen Erhebung -- fuer Folge-Nutzer bindend)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 096
GEGENSTAND: ERHEBUNGS-KRITIK[6]: PLATTEN-LAGE FEHLT KOMPLETT
ORT: unbekannt
SOLL/FIX: PLATTEN-LAGE FEHLT KOMPLETT: Der 3er-Deckel ist ausdruecklich plattenmotiviert, aber die Erhebung misst nirgends den Bestand (aktuell 86% voll, 36G frei) und schlaegt keine Hygiene vor Baubeginn vor. Ebenso unbeziffert: dass Abnahme-Pipelines auf prod1-Runnern dasselbe Maschinen-Budget verbrauchen (LOKAL=prod1) -- Blech und Bau-Deckel sind keine getrennten Budgets.
STATUS LT. QUELLE: offen (Korrektur an der eigenen Erhebung -- fuer Folge-Nutzer bindend)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 097
GEGENSTAND: ERHEBUNGS-KRITIK[7]: KEINE ZEITMASSE
ORT: unbekannt
SOLL/FIX: KEINE ZEITMASSE: Alle Kegel sind statische Basename-Huellen (selbst deklarierte UNTERE Schranke), es gibt keine einzige gemessene Baudauer. Die Tagesplanung (KON55-Kombibau 'lange') beruht damit auf Annahmen; der Plan kompensiert mit Reserve-Slot und F2-Puffer, aber die Erhebung haette mindestens eine Referenz-Baudauer (letzter CI-Vollbau 15774) liefern koennen.
STATUS LT. QUELLE: offen (Korrektur an der eigenen Erhebung -- fuer Folge-Nutzer bindend)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 098
GEGENSTAND: ERHEBUNGS-KRITIK[8]: P4-ALLOWLISTEN UNGEPRUEFT
ORT: unbekannt
SOLL/FIX: P4-ALLOWLISTEN UNGEPRUEFT: Ob ci_test_registrierungs/bauweg/sichtbarkeit-Allowlists pfadgenaue topics/queuing-Eintraege tragen, die der Umzug bricht, wurde nicht erhoben -- vor P4-Baubeginn pruefen, sonst wird eine der drei Wachen der erste rote Job des Pakets.
STATUS LT. QUELLE: offen (Korrektur an der eigenen Erhebung -- fuer Folge-Nutzer bindend)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 099
GEGENSTAND: ERHEBUNGS-KRITIK[9]: P8/P9-GEGENSTAENDE UNBESTIMMT
ORT: unbekannt
SOLL/FIX: P8/P9-GEGENSTAENDE UNBESTIMMT: Welche zwei Ledger-Zitate, wo der 69.6-Vermerk hingehoert, was die N-3-Rechnung ist, WELCHES Cluster-Handout gemeint ist -- alles offen; und der A-1-Vorlagetext haengt an einer Roh-Zeilennummer (~35872), die die bekannte 95-Zeichen-Umbruch-Falle bruechig macht (nach INHALT suchen, nicht nach Zeile). Fuer Lead-only-Posten ohne Bau ist das tragbar, aber es macht P8/P9 nicht delegierbar.
STATUS LT. QUELLE: offen (Korrektur an der eigenen Erhebung -- fuer Folge-Nutzer bindend)
ABHAENGIGKEIT/FLAECHE: -

### [w9ezc7zw6.json] 100
GEGENSTAND: ERHEBUNGS-KRITIK[10]: ERHEBUNG STARK, WO SIE KORRIGIERT
ORT: unbekannt
SOLL/FIX: ERHEBUNG STARK, WO SIE KORRIGIERT: Die Richtigstellung des Lage-Textes (set_active_machine_declaration liegt in simd_build_gate.hpp:234, nicht in profile_facade) ist am Objekt bestaetigt und planungsrelevant (P1-Naht zieht den Header; ODR-Frage Header vs. TU bleibt aber unentschieden und gehoert ins P1-Design vor dem ersten Commit).
STATUS LT. QUELLE: offen (Korrektur an der eigenen Erhebung -- fuer Folge-Nutzer bindend)
ABHAENGIGKEIT/FLAECHE: -


## QUELLE wp8u862m5.json -- Entwurf XML-getriebene LaTeX-Kapitel-Generierung (08.08.): 3 Entwuerfe (minimal / ct-rein=ANLAGE-XML / thesis-erst=ANLAGE-DEKLARAT), adversarische Bewertung ALLE 0/3 Stimmen; Synthese-VORLAGE empfiehlt ANLAGE-XML. 68 Kern-/Andockstellen, 47 Hindernisse kartiert. WICHTIG: Workflow-interner Lieferausfall dokumentiert (Entwurf 3 nie angekommen, ct-rein abgeschnitten, minimal-Urteil bricht ab) -- Synthese hat deshalb jede tragende Behauptung selbst am Objekt nachgeprueft.

### [wp8u862m5.json] 001
GEGENSTAND: Lieferausfall im Entwurfs-Workflow: Entwurf 3 nie angekommen; ct-rein mitten im CI-Abschnitt abgeschnitten; adversarisches Urteil nur fuer minimal (0/3) und bricht ab; Bewertungs-Ausgang alle Entwuerfe 0/3 Stimmen
ORT: unbekannt
SOLL/FIX: Synthese kompensierte durch eigene Objektpruefung; Restunsicherheit deklariert: 'Es kann im dritten Entwurf ein Argument geben, das meine Empfehlung kippt.'
STATUS LT. QUELLE: nur-hinweis (Workflow-Qualitaets-Vorbehalt)
ABHAENGIGKEIT/FLAECHE: -

### [wp8u862m5.json] 002
GEGENSTAND: Planungs-Bestand: Auftrag 08.08. = vierte Formulierung; Owner-Zitate Juli ('CI-interaktive Diplomarbeit', 'Haupt-Ziel des Gesamt-Systems'), Ledger-Gesetz F1/par.16.1-C2/E-18; GEBAUT: E-18-Vorwaertskanal INERT (Token/Var-Scharfschaltung + R2 Ziel-Branch offen), M08 appendix_generator, Weg A 30 Eintraege
ORT: docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:533/:1509/:3554 | ci/anhang_forward_core.sh
SOLL/FIX: ## 1. WAS BEREITS GEPLANT WAR

Der Auftrag vom 08.08. ist **keine neue Idee**. Er ist die vierte Formulierung derselben Sache, und die dritte davon ist bereits als Ledger-Gesetz gebucht. Die Suche hat gefunden:

### 1.1 Der Owner hat es zweimal selbst formuliert (Juli)

> "Ich moechte die dort vorbereiteten Anhaenge-Kapitel automatisiert mithilfe der Interpretation und latex-code-Encodierung direkt mit den aktuellen Messwerten updaten und Messwert-Tabellen und Diagramme erstellen [...] **Damit erzeugt ueber die gesamte Kette eine Einstellung der xml eine Diplomarbeit Evaluation mithilfe dynamisch ausgewerteter Messwerte, Tabellen und Diagramme. Damit haben wir eine CI-interaktive Diplomarbeit.**"
> -- Owner, ca. 11.-12.07.2026, Transkript-Chunk 10/38, gesichert in `docs/sessions/backups/20260802-kontext-neugruendung-abend-workflows/ergebnisse/13-798ff6f6.md:19`
> *(Datum unsicher: der Chunk-Kopf traegt keine Datumszeile; verortet ueber die #22-Scharfschaltung im selben Chunk.)*

> "**Das Generieren der Latex anhaenge in der Diplomarbeit code ist Haupt-Ziel des Gesamt-Systems** und kombiniert das automatische erstellen der Ergebnisse in die Diplomarbeit PDF mit Auswertungsautomatisierung aus der xml-Kette bis zu den fertigen Ergebnissen (voll-Matrix mit Tabellen, Formeln und Diagrammen der echten Messwerte)."
> -- Owner, ca. 13.-14.07.2026, `ergebnisse/17-9b750d94.md:16`

### 1.2 Es ist als Ledger-Gesetz gebucht (16.07.)

> **F1 JA+ERWEITERUNG:** ZIEL: "dass der Anwender (die Diplomarbeit) selbst in der XML waehlen kann, **wie jedes Experiment ausgewertet und veroeffentlicht wird** und wo und wie die Ergebnisse gespeichert werden" -- **die Cache Engine stellt als Framework eine BIBLIOTHEK bereit, welche per XML-Config die 'Programmierung' von Experimenten UND deren Auswertung erlaubt.**
> -- `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:533`, 16.07.2026

> **par.16.1-C2** -- "**Die XML nennt explizit NUR EINEN Pfad: den Ziel-Ordner**, wo die Ergebnisse der Anfrage gespeichert werden" -- Ergebnisse erst im BUILD-Pfad, dann build->ziel kopiert/kompiliert. *Code-Anker derselben Sektion: "build->ziel-Copy **fehlt heute**".*
> -- `LEDGER.md:1509`, 16.07.2026

> **E-18** = LaTeX-Anhang-VORWAERTS-Kanal je CI (**= HAUPT-ZIEL des Gesamt-Systems**).
> -- `LEDGER.md:3554`, 26.07.2026, par.68c

### 1.3 Was bereits GEBAUT ist

- **E-18-Vorwaertskanal** (`ci/anhang_forward_core.sh` + Job `anhang:forward`) -- gelandet 06.08., aber **INERT**: "Pipeline 14756 angelegt, Job-Liste OHNE anhang:forward [...] Job bleibt INERT bis Token/Var-Scharfschaltung. Owner-offen bleibt: **Ziel-Branch development vs. main/Overleaf (R2)**." (`LEDGER.md:7116 ff.`, 06.08.)
- **M08 `appendix_generator`** schreibt heute je Sprache alle Darstellungsformen (Heatmap, 3D, Ratio, Normbar, Sweep, Forest, Pareto, ECDF, Range, Segment-Attribution, Observer-Detail, Achsen-Inventar, Bias, Exchange, Limitierung) -- honest-empty-fest.
- **Anhang-Verdrahtung Weg A** (`\InputIfFileExists` mit eigenem Ersatztext) -- in `anhang/de/A_measurements.tex` **30 Eintraege**, verifiziert.

### 1.4 Was der Auftrag vom 08.08. NEU hinzufuegt

Drei Dinge, die in **keiner** Quelle vorher stehen (Nullbefund, Muster unten):

1. **Auswahl und Reihenfolge aus der XML.** Bisher galt das Gegenteil: F10 (16.07., `LEDGER:533`) sagt woertlich "aus einem **FEST VERDRAHTETEN** Output des Messsystems".
2. **Aufmachung aus der XML** (welche Darstellungsform fuer welchen Messwert).
3. **Schaltende Textbausteine im Hauptteil** ("in der Auswertung und Evaluation").

**Nullbefund-Muster** (alle in `docs/`, `--include=*.md`, `/usr/bin/grep`):
`<darstellung|<figures|<report|<auswertung|<sections|<chapters|<tables>` -> 0 * `Reihenfolge.{0,40}(Darstellung|Tabelle|Abbildung)` -> 0 einschlaegige * `XML.{0,60}(Darstellung|Abbildung|Tabelle)en?` -> 0 * `adaptive (Prosa|Text)|Ergebnis-Makro|Wert-Makro|schaltet.{0,30}Text` -> 0 * `newcommand` ueber den ganzen Thesis-Baum (`*.tex`,`*.sty`) -> **kein einziges Ergebnis-Makro**.
**Gegenproben, die trafen:** `<writeback_methods` -> 3 Treffer * `latex_path` -> 8 im ce-Code + 2 im Katalog * `Prosa` im Ledger -> 12 (Engine liest Nicht-ASCII korrekt).

### 1.5 Der Betreuer hat 2026-05-08 etwas AEHNLICHES, aber nicht dasselbe verlangt

> "VORDEFINIERTE TEXTBAUSTEINE -- Im LaTeX-Sourcecode der Diplomarbeit (**NUR im Appendix-Bereich**) eingebettete Bausteine, die zur Compile-Zeit Werte aus Binary-Dumps einsetzen. Beispiel: `\PRTARTPlot{dataset=YCSB-A, isa=AVX-512, metric=p99-latency, baseline=ART_Node256, compare=PRTART_DenseByte}`"
> -- Habich-Feedback H3, `docs/termine/20260508 Termin 7/Habich_Feedback_2026_05_08.txt:106-117`

**Das steht in echter Spannung zum Auftrag vom 08.08.** (Betreuer: nur Appendix; Owner: auch Auswertung/Evaluation) und zur Umsetzungsart (Betreuer: LaTeX liest zur Compile-Zeit Binary-Dumps; hier: der Generator rechnet vorher, LaTeX setzt nur ein). -> **Entscheid O-4** in Abschnitt 7.

---


STATUS LT. QUELLE: nur-hinweis (Bestands-Erhebung mit Nullbefund-Mustern + Gegenproben)
ABHAENGIGKEIT/FLAECHE: E-18 INERT; R2 offen

### [wp8u862m5.json] 003
GEGENSTAND: KONFLIKT Betreuer vs. Owner (H3): Habich 08.05. 'Textbausteine NUR im Appendix-Bereich' vs. Owner-Auftrag 08.08. 'auch in Auswertung und Evaluation'; Umsetzungsart divergiert (Compile-Zeit-Dump vs. Vorab-Rechnung)
ORT: docs/termine/20260508 Termin 7/Habich_Feedback_2026_05_08.txt:106-117
SOLL/FIX: Entscheid O-4 noetig; S11 bis dahin blockiert; Empfehlung: ja, aber Betreuer vorher informieren
STATUS LT. QUELLE: offen (echter Konflikt, Owner-/Betreuer-Entscheid)
ABHAENGIGKEIT/FLAECHE: O-4/O-5

### [wp8u862m5.json] 004
GEGENSTAND: minimal-Blocker 1: CI wuerde falsche XML-Familie durchreichen -- .gitlab-ci.yml:723 setzt COMDARE_THESIS_PROFILE auf m3_smoke (Wurzel comdare_thesis_profile), xml_config_parser.cpp:454 verlangt comdare_experiment => Nullbefund, Anlage bliebe leer
ORT: .gitlab-ci.yml:723 | xml_config_parser.cpp:454
SOLL/FIX: Am Objekt selbst verifiziert (Synthese); Heilung im ANLAGE-XML-Entwurf konstruktiv (eigener Namensraum generated/, S14-S16)
STATUS LT. QUELLE: offen (Bestands-Defekt, bis Entwurfs-Umsetzung)
ABHAENGIGKEIT/FLAECHE: ANLAGE-XML S14/S15/S16

### [wp8u862m5.json] 005
GEGENSTAND: minimal-Blocker 2: measure:golden-320 braeche ab -- COMDARE_THESIS_PROFILE existiert NUR in measure:smoke; unter set -euo pipefail unbound variable = exit 1 nach bis zu 10 Tagen Messlauf
ORT: .gitlab-ci.yml:723
SOLL/FIX: Am Objekt selbst verifiziert (Synthese); Heilung im ANLAGE-XML-Entwurf konstruktiv (eigener Namensraum generated/, S14-S16)
STATUS LT. QUELLE: offen (Bestands-Defekt, bis Entwurfs-Umsetzung)
ABHAENGIGKEIT/FLAECHE: ANLAGE-XML S14/S15/S16

### [wp8u862m5.json] 006
GEGENSTAND: minimal-Blocker 3: Kapitel-Anlage wuerde kopiert aber nie committet -- anhang_forward_core.sh:235 stagt nur anhang/$lang/tabellen; Datei daneben => changed=0 => 'IDEMPOTENT: 0 Aenderungen' => RC 0 (stiller Ausfall)
ORT: ci/anhang_forward_core.sh:235/:220
SOLL/FIX: Am Objekt selbst verifiziert (Synthese); Heilung im ANLAGE-XML-Entwurf konstruktiv (eigener Namensraum generated/, S14-S16)
STATUS LT. QUELLE: offen (Bestands-Defekt, bis Entwurfs-Umsetzung)
ABHAENGIGKEIT/FLAECHE: ANLAGE-XML S14/S15/S16

### [wp8u862m5.json] 007
GEGENSTAND: minimal-Blocker 4/5: 'Filter' erzeugt stille Staleness -- A_measurements.tex bindet 17 Fragmente mit blankem \input; Kanal loescht nie; PDF zeigt Juni-Zahlen ohne Warnung
ORT: anhang/de/A_measurements.tex
SOLL/FIX: Am Objekt selbst verifiziert (Synthese); Heilung im ANLAGE-XML-Entwurf konstruktiv (eigener Namensraum generated/, S14-S16)
STATUS LT. QUELLE: offen (Bestands-Defekt, bis Entwurfs-Umsetzung)
ABHAENGIGKEIT/FLAECHE: ANLAGE-XML S14/S15/S16

### [wp8u862m5.json] 008
GEGENSTAND: minimal-Blocker 6: neue Exit-Codes werden verschluckt -- .gitlab-ci.yml:775/:867 enden auf '|| echo honest-empty ... kein Fehler'; jeder neue Code ununterscheidbar
ORT: .gitlab-ci.yml:775 :867
SOLL/FIX: Am Objekt selbst verifiziert (Synthese); Heilung im ANLAGE-XML-Entwurf konstruktiv (eigener Namensraum generated/, S14-S16)
STATUS LT. QUELLE: offen (Bestands-Defekt, bis Entwurfs-Umsetzung)
ABHAENGIGKEIT/FLAECHE: ANLAGE-XML S14/S15/S16

### [wp8u862m5.json] 009
GEGENSTAND: Zusatzbefund: kapitel/en/07_results_evaluation.tex existiert, ist aber NICHT eingebunden (diplomarbeit.tex:280-285 bindet 01..06); englische Evaluation ist kapitel/en/05_evaluation.tex
ORT: kapitel/en/07_results_evaluation.tex | diplomarbeit.tex:280-285
SOLL/FIX: Am Objekt selbst verifiziert (Synthese); Heilung im ANLAGE-XML-Entwurf konstruktiv (eigener Namensraum generated/, S14-S16)
STATUS LT. QUELLE: offen (Bestands-Defekt, bis Entwurfs-Umsetzung)
ABHAENGIGKEIT/FLAECHE: ANLAGE-XML S14/S15/S16

### [wp8u862m5.json] 010
GEGENSTAND: EMPFOHLENER ENTWURF ANLAGE-XML: <report> im comdare_thesis_profile-Kanal -> Modul Code/10_report_composer -> Namensraum anhang/<lang>/generated/ -> manifest-getriebene CI-Kopie ueber E-18; Herkunfts-Tabelle je Idee + 3 Setzungen (Traeger thesis_profile; report steuert Komposition nicht Erzeugung; Prosa lebt in Thesis)
ORT: Code/10_report_composer (NEU) | report_manifest.txt (NEU)
SOLL/FIX: ## 2. DER EMPFOHLENE ENTWURF

### 2.1 Das Urteil

**`minimal` faellt durch -- nicht wegen seiner Ideen, sondern weil seine Kernbehauptung falsch ist.** Er verspricht Minimal-Invasivitaet durch Wiederverwendung von M08 und E-18. Ich habe die fuenf schwersten Einwaende selbst nachgeprueft; **alle fuenf bestaetigen sich am Objekt**:

| Befund | Beleg (selbst geprueft) |
|---|---|
| Die CI wuerde die **falsche XML-Familie** durchreichen | `.gitlab-ci.yml:723` setzt `COMDARE_THESIS_PROFILE` auf `m3_smoke_coverage.profile.xml`; deren Wurzel ist `<comdare_thesis_profile>` (Zeile 43). `xml_config_parser.cpp:454`: `if (!root \|\| root->tag != "comdare_experiment") return std::nullopt;` -> **Nullbefund, die Anlage bliebe leer** |
| `measure:golden-320` **bricht ab** | `COMDARE_THESIS_PROFILE` existiert NUR in `measure:smoke` (`:723`); der golden-Job hat es nicht. Unter `set -euo pipefail` = unbound variable = exit 1 nach bis zu 10 Tagen Messlauf |
| Die Kapitel-Anlage wird **kopiert, aber nie committet** | `ci/anhang_forward_core.sh:235` stagt ausschliesslich `anhang/$lang/tabellen`; `:220` schreibt auch nur diesen Pfad in `$COPIED_LIST`. Eine Datei daneben => `changed=0` => "IDEMPOTENT: 0 Aenderungen" => RC 0. **Stiller Ausfall von Auftragsteil (c)** |
| "Filter" erzeugt **stille Staleness** | `anhang/de/A_measurements.tex` bindet **17 Fragmente mit blankem `\input`** ein (Z. 18,19,33,34,53,61-66,260-263,290). `git ls-files anhang/de/tabellen/` = **18 getrackte Dateien**. Der Kanal loescht nie. Nicht-Schreiben => alte committete Datei bleibt und wird weiter eingebunden => **PDF zeigt Juni-Zahlen ohne Warnung** |
| Die neuen Exit-Codes werden **verschluckt** | `.gitlab-ci.yml:775` und `:867` enden je auf `\|\| echo "appendix-generator: honest-empty/Teil-Output (n/a-Spalten) -- kein Fehler"`. Jeder neue Code ist von honest-empty ununterscheidbar |

Dazu bestaetige ich einen sechsten: `kapitel/en/07_results_evaluation.tex` **existiert, ist aber nicht eingebunden** -- `diplomarbeit.tex:280-285` bindet `kapitel/\thesislang/01_einleitung ... 06_fazit` ein. Die englische Evaluation ist `kapitel/en/05_evaluation.tex`.

**`ct-rein` gewinnt** -- und zwar aus einem Grund, der in keinem der Urteile steht: **es schreibt seine eigenen Fragmente in einen eigenen Namensraum, statt die von M08 zu filtern.** Damit sind Blocker 4 (Exchange-Tabellen-Granularitaet: `write_exchange_longtables()` bekommt ein Verzeichnis und benennt selbst) und Blocker 5 (Filter = Staleness) **konstruktiv aufgeloest**, nicht nur repariert. Das ist der Unterschied zwischen "Regie ueber fremde Maschinerie" und "eigene Maschinerie".

### 2.2 Der empfohlene Entwurf: **ANLAGE-XML**

`<report>`-Abschnitt im **`comdare_thesis_profile`**-Kanal -> eigenes Modul `Code/10_report_composer` -> eigener Namensraum `anhang/<lang>/generated/` -> **manifest-getriebene** CI-Kopie ueber den bestehenden E-18-Kanal.

**Was von wem stammt:**

| Idee | Herkunft |
|---|---|
| Eigenes Modul `Code/10_report_composer` statt M08-Regie | **ct-rein** |
| constexpr-Registries (Form/Reducer/Praedikat/Sprache) + statischer Dispatch via `index_sequence`-Fold + `consteval`-Vollstaendigkeitswache | **ct-rein** (Muster aus `writeback_method_registry.hpp`) |
| `report_manifest.txt` mit sha256 je erzeugtem Pfad | **ct-rein** |
| `--check-lang-parity` als HARTER CI-Job (EN fehlt = rot) | **ct-rein** |
| `\csname erg@...\endcsname`-Namensraum statt Einzel-`\newcommand` -- nie undefiniert, keine geplatzte PDF | **minimal** |
| `\Erg{}` / `\ErgWenn{}{}{}` als Praeambel-Trio, **Prosa bleibt in der Thesis, nur die Bedingung kommt aus der Messung** | **minimal** |
| `<latex_appendix target_dir>` als der eine XML-Zielordner (par.16.1-C2) | **minimal** |
| Deprecate-Schritt fuer die E-18-Negativzusage | **minimal** (S15) |
| **`<report>` haengt an `comdare_thesis_profile`, nicht an `comdare_experiment`** | **neu (meine Gegenpruefung)** -- beide Kanaele teilen sich laut `xml_config_parser.cpp:95-96` bereits eine gemeinsame Parse-Funktion; hier wird derselbe Weg gegangen |
| **Das Manifest ist gleichzeitig Staging-Liste, Byte-Delta-Umfang und Rollback-Liste** -- eine Liste, drei Verwendungen | **neu** -- heilt Blocker 3 an der Wurzel statt per Sonder-ENV |
| **Kein Filtern der M08-Fragmente.** M08 schreibt weiter alle Fragmente unveraendert; `<report>` komponiert nur das Kapitel | **neu** -- heilt Blocker 5 vollstaendig und macht die Byte-Identitaets-Zusage trivial wahr |
| **Kein `file_pattern` und keine Prosa in ce** -- die Registry kennt nur abstrakte Formen; Dateinamen gehoeren super, Prosa gehoert der Thesis | **neu** -- Antwort auf den Layering-/Eigentums-Einwand D2 |

### 2.3 Die drei Setzungen, die ich selbst treffe

Ableitbar, deshalb kein Owner-Entscheid -- aber ausdruecklich benannt:

**SETZUNG 1 -- Traeger ist `comdare_thesis_profile`.** Die `comdare_experiment`-Familie ist im Messbetrieb nicht angeschlossen (`Code/test_data_xml/experiment_golden.xml` haengt als Compile-Define an einem Test). Die Anlage muss an dem Profil haengen, das die Messung wirklich fuehrt.

**SETZUNG 2 -- `<report>` steuert die Komposition, nicht die Erzeugung.** M08 schreibt weiterhin jedes Fragment. Der Composer erzeugt zusaetzlich seine eigenen Bloecke unter `generated/`. Nichts wird jemals "weggelassen" -- damit kann keine alte Datei still ueberleben.

**SETZUNG 3 -- Prosa lebt in der Thesis, Bedingungen in der Messung.** `<switch>` traegt nur ein Praedikat, nie deutschen oder englischen Satz. Bild-/Tabellenunterschriften duerfen aus der XML kommen (sie kommen heute aus C++-String-Literalen in super -- die XML ist kein *neuer* unlinted Ort, sondern ein besser sichtbarer), aber Fliesstext nie.

---


STATUS LT. QUELLE: offen (Design-Empfehlung, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: O-1..O-6

### [wp8u862m5.json] 011
GEGENSTAND: XML-Abschnitt <report> im Wortlaut (chapter/block/values/switches; fehlt der Block => byte-identisch zu heute; argmin/ratio_vs_reference GESPERRT bis COMPARE-Stufe D2/#46)
ORT: thesis_profiles/m3_golden_coverage.profile.xml (Ziel)
SOLL/FIX: ## 3. DER XML-ABSCHNITT IM WORTLAUT

Einzufuegen in ein Thesis-Profil, z. B. `libs/cache_engine/algorithm_profiles/thesis_profiles/m3_golden_coverage.profile.xml`, als Geschwister von `<permute_axes>` / `<run_options>`. **Fehlt der Block, ist das Verhalten byte-identisch zu heute.**

```xml
<comdare_thesis_profile id="m3_golden_coverage" schema_version="1">

  ...  <!-- base_tiers, permute_axes, sweep_axes, writeback_methods, run_options: unveraendert -->

  <!-- =====================================================================
       (a) ZIELORDNER + Sprachen.  dir ist der EINE Pfad im Sinn von 16.1-C2:
       geschrieben wird erst in den BUILD-Pfad, danach dorthin kopiert.
       ${date} loest sich wie in <output> auf.
       ACHTUNG Hausfalle: KEIN doppelter Bindestrich in XML-Kommentaren.
       ===================================================================== -->
  <report dir="_runs/${date}/diplomarbeit_golden/anlage">

    <!-- role="lead" GENAU EINMAL. Fehlt eine follow-Sprache irgendwo,
         bricht der CI-Job report:lang-parity HART ab (Code 15). -->
    <languages>
      <lang code="de" role="lead"/>
      <lang code="en" role="follow"/>
    </languages>

    <!-- =================================================================
         (b) DIE ANFORDERUNG.  Dokument-Reihenfolge IST Ausgabe-Reihenfolge;
         order= ist nur die explizite, stabile Zweitangabe fuer Diffs.
         file= ist ein NAME, kein Pfad:  [A-Za-z0-9_]{1,48}
         ================================================================= -->
    <chapter id="anlage_G" file="G_generierte_ergebnisse" order="10">
      <title lang="de">Erzeugte Ergebnisse der Messkette</title>
      <title lang="en">Generated Results of the Measurement Chain</title>

      <!-- form= MUSS eine id aus kReportFormRegistry sein.
           Unbekanntes Token = HARTER Abbruch mit Auflistung der gueltigen. -->
      <block id="tab_top5_lookup" form="table_longtable" order="10">
        <select metric="op_lookup_p50_ns"/>
        <group_by>search_algo workload</group_by>
        <filter axis="node_type" value="dense_byte"/>
        <sort key="median" dir="asc"/>
        <limit n="5"/>
        <caption lang="de">Die fuenf schnellsten Suchverfahren je Lastprofil</caption>
        <caption lang="en">The five fastest search algorithms per workload</caption>
        <label>tab:gen:top5-lookup</label>
      </block>

      <block id="fig_flaeche_lookup" form="heatmap2d" order="20">
        <select metric="op_lookup_p50_ns"/>
        <axes x="workload" y="search_algo"/>
        <caption lang="de">Latenz-Flaeche Lookup ueber Lastprofil und Suchverfahren</caption>
        <caption lang="en">Lookup latency surface over workload and search algorithm</caption>
        <label>fig:gen:flaeche-lookup</label>
      </block>

      <block id="fig_pareto" form="pareto" order="30">
        <select metric="op_lookup_p50_ns" second_metric="op_lookup_p99_ns"/>
        <caption lang="de">Pareto-Streuung p50 gegen p99 je Konfiguration</caption>
        <caption lang="en">Pareto scatter p50 versus p99 per configuration</caption>
        <label>fig:gen:pareto</label>
      </block>
    </chapter>

    <!-- =================================================================
         (d1) VARIABLEN.  Je <value> genau EIN LaTeX-Makro, aus DERSELBEN
         einmal geparsten WIDE-Matrix.  reducer= aus kReportReducerRegistry.
         ================================================================= -->
    <values>
      <value key="besteLatenzNs"  reducer="min"    metric="ns_per_op"
             format="fixed2" unit="ns"/>
      <value key="refLatenzNs"    reducer="median" metric="ns_per_op"
             filter_axis="search_algo" filter_value="linear_scan"
             format="fixed2" unit="ns"/>
      <value key="permAnzahl"     reducer="count"  metric="ns_per_op"
             format="int"/>

      <!-- GESPERRT bis die COMPARE-Stufe D2 gebaut ist (Task #46).
           argmin und ratio_vs_reference sind AUSWERTUNGS-Semantik und
           duerfen nicht zweimal definiert werden.
      <value key="besterAllokator" reducer="argmin" metric="ns_per_op"
             group_by="memory_layout" format="ident"/>
      <value key="faktorGegenRef"  reducer="ratio_vs_reference" metric="ns_per_op"
             reference_axis="search_algo" reference_value="linear_scan"
             format="fixed2"/>
      -->
    </values>

    <!-- =================================================================
         (d2) SCHALTER.  NUR das Praedikat.  Die Prosa steht in der Thesis,
         auf Deutsch und auf Englisch, dort wo alle andere Prosa steht.
         @key verweist auf ein zuvor deklariertes <value>; nackte Zahl =
         Literal.  Vorwaertsreferenz = harter Fehler.
         ================================================================= -->
    <switches>
      <switch key="refUnterboten" predicate="lt" lhs="@besteLatenzNs"
              rhs="@refLatenzNs" tolerance="0.02"/>
      <switch key="korpusVoll"    predicate="ge" lhs="@permAnzahl" rhs="320"/>
    </switches>

  </report>

</comdare_thesis_profile>
```

**Erzeugtes Layout** unter `<dir>`:

```
<lang>/generated/G_generierte_ergebnisse.tex   <- die Kapitel-Huelle, \input in order-Folge
<lang>/generated/blocks/<block_id>.tex         <- je ein Block-Fragment
<lang>/generated/ergebnis_variablen.tex        <- die Wert-Makros
<lang>/generated/ergebnis_schalter.tex         <- die Flags
report_manifest.txt                            <- eine Zeile je relativem Pfad + sha256
```

Der Namensraum `generated/` ist **getrennt von `tabellen/`**, wo M08 unveraendert weiterschreibt. Keine Datei kollidiert, kein Fragment wird ersetzt.

---


STATUS LT. QUELLE: offen (Entwurfs-Wortlaut)
ABHAENGIGKEIT/FLAECHE: #46/COMPARE-D2-Sperre

### [wp8u862m5.json] 012
GEGENSTAND: Variablen-/Textbaustein-Mechanik: \csname erg@...-Namensraum, \Erg{}/\ErgWenn{}{}{} DREIWERTIG ([?] bei Datenmangel statt Behauptung), \InputIfFileExists; DE fuehrt, EN-Werte lokalisiert (12,43 vs 12.43); Unsicherheit: gemeinsamer Zahlenformat-Helfer 04_csv_to_latex/05_diagram_generator ungeprueft
ORT: diplomarbeit.tex (Praeambel) | kapitel/de/05_evaluation.tex
SOLL/FIX: ## 4. DIE VARIABLEN- UND TEXTBAUSTEIN-MECHANIK

### Das Problem

Ein `\newcommand{\besteLatenzNs}` waere vor dem ersten Messlauf undefiniert und wuerde die PDF reissen. Heute gibt es im gesamten Thesis-Baum **kein einziges Ergebnis-Makro** (Nullbefund verifiziert, Abschnitt 1.4).

### Der Generator schreibt (DE)

`anhang/de/generated/ergebnis_variablen.tex`:

```latex
% GENERIERT -- nicht von Hand aendern.
% Quelle: <report><values> aus m3_golden_coverage.profile.xml, Lauf 20260808-0412
% Definierte Namen: besteLatenzNs refLatenzNs permAnzahl
\expandafter\gdef\csname erg@besteLatenzNs\endcsname{12,43}
\expandafter\gdef\csname erg@refLatenzNs\endcsname{18,07}
\expandafter\gdef\csname erg@permAnzahl\endcsname{320}
```

`anhang/de/generated/ergebnis_schalter.tex`:

```latex
\expandafter\gdef\csname erg@flag@refUnterboten\endcsname{1}
\expandafter\gdef\csname erg@flag@korpusVoll\endcsname{1}
```

Die EN-Fassung ist **inhaltlich** verschieden, nicht kosmetisch: `{12.43}` statt `{12,43}`. Der Composer benutzt dafuer denselben Lokalisierungs-Helfer wie `04_csv_to_latex` / `05_diagram_generator`.
*Unsicher: ich habe nicht geprueft, ob dort ein gemeinsamer Helfer existiert. Existiert er nicht, ist das der erste Befund des Bau-Pakets -- der Helfer wird gezogen, nicht neu erfunden, sonst brechen Zahlenformate zwischen Fliesstext und Tabelle im selben Dokument auseinander.*

### Die Thesis bekommt EINMALIG (Praeambel `diplomarbeit.tex`, hinter `\input{config/language.tex}`)

```latex
\providecommand{\ergUnbekannt}{\textbf{[?]}}
% Wert: nie undefiniert -- ein nicht generierter Name faellt sichtbar auf.
\newcommand{\Erg}[1]{\ifcsname erg@#1\endcsname\csname erg@#1\endcsname\else\ergUnbekannt\fi}
% Schalter: DREI Zweige.  Ohne Messung wird KEINE Behauptung gedruckt.
\newcommand{\ErgWenn}[3]{%
  \ifcsname erg@flag@#1\endcsname
    \ifnum\csname erg@flag@#1\endcsname=1\relax #2\else #3\fi
  \else \ergUnbekannt\fi}
\InputIfFileExists{anhang/\thesislang/generated/ergebnis_variablen.tex}{}{}
\InputIfFileExists{anhang/\thesislang/generated/ergebnis_schalter.tex}{}{}
```

**Der dritte Zweig ist der wichtige Teil.** Ein zweiwertiges `\ErgWenn` haette bei fehlendem Flag den Else-Zweig gedruckt -- also eine **inhaltliche Behauptung aus Datenmangel**. Das ist wissenschaftlich schlechter als eine rote PDF. Mit dem dritten Zweig steht dort `[?]`, sichtbar, unuebersehbar, und der Lint aus S12 findet es.

### Im Fliesstext -- DE fuehrt

`kapitel/de/05_evaluation.tex`:

```latex
Die schnellste gemessene Konfiguration erreicht \Erg{besteLatenzNs}\,ns/op;
die Referenz \texttt{linear\_scan} liegt bei \Erg{refLatenzNs}\,ns/op ueber
\Erg{permAnzahl} Permutationen.
\ErgWenn{refUnterboten}
  {Die Referenz wird damit unterboten; der Vorteil geht auf die Achsen-Wahl zurueck.}
  {Die Referenz wird nicht unterboten; der erwartete Vorteil der Achsen-Wahl bleibt aus.}
```

### Englisch zieht nach

`kapitel/en/05_evaluation.tex` -- **nicht** `07_results_evaluation.tex`; die Datei existiert, ist aber laut `diplomarbeit.tex:280-285` nicht eingebunden (Alt-Struktur, un-included):

```latex
The fastest measured configuration reaches \Erg{besteLatenzNs}\,ns/op;
the \texttt{linear\_scan} reference sits at \Erg{refLatenzNs}\,ns/op across
\Erg{permAnzahl} permutations.
\ErgWenn{refUnterboten}
  {The reference is thereby beaten; the advantage stems from the axis selection.}
  {The reference is not beaten; the expected advantage of the axis selection does not materialise.}
```

Die Makronamen sind sprachneutral, die Werte sprachabhaengig, die Prosa sprachspezifisch und von Hand geschrieben. `\thesislang` waehlt zur Compile-Zeit die richtige Variablen-Datei (`diplomarbeit.tex:18`, `:290-295` -- verifiziert).

---


STATUS LT. QUELLE: offen (Entwurf)
ABHAENGIGKEIT/FLAECHE: -

### [wp8u862m5.json] 013
GEGENSTAND: BAU-SCHRITT S1: `report_form_registry.hpp`, `report_reducer_registry.hpp`, `report_predicate_registry.hpp`, `report_language_registry.hpp` in ce unter `libs/cache_engine/include/cache_engine/repor
ORT: unbekannt
SOLL/FIX: Schritt: `report_form_registry.hpp`, `report_reducer_registry.hpp`, `report_predicate_registry.hpp`, `report_language_registry.hpp` in ce unter `libs/cache_engine/include/cache_engine/report/`. **Ohne `file_pattern`-Spalte, ohne Prosa.** Muster: `writeback_method_registry.hpp` (Groessen-Anker, Index-Identitaet, Namen-Anker, `for_each_*`-Fold) || Abnahme (literale Ausgabe): Eine absichtlich hinzugefuegte Enum-Auspraegung ohne Registry-Eintrag bricht den Bau; die `static_assert`-Meldung wird literal gezeigt
STATUS LT. QUELLE: offen (Bau-Schritt, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: S11 setzt O-4 voraus; S1-S9+S17 owner-unabhaengig

### [wp8u862m5.json] 014
GEGENSTAND: BAU-SCHRITT S2: `report_form_impl.hpp`: `template <ReportForm F> struct ReportFormImpl` **primaer undefiniert**, CRTP-Basis, Concept `ReportFormLike`, `visit_report_form()` als `index_sequence`-Fo
ORT: unbekannt
SOLL/FIX: Schritt: `report_form_impl.hpp`: `template <ReportForm F> struct ReportFormImpl` **primaer undefiniert**, CRTP-Basis, Concept `ReportFormLike`, `visit_report_form()` als `index_sequence`-Fold, `consteval all_report_forms_implemented()` || Abnahme (literale Ausgabe): Eine auskommentierte `ReportFormImpl`-Spezialisierung erzeugt einen Compile-Fehler, nicht eine Laufzeit-Luecke. Meldung literal
STATUS LT. QUELLE: offen (Bau-Schritt, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: S11 setzt O-4 voraus; S1-S9+S17 owner-unabhaengig

### [wp8u862m5.json] 015
GEGENSTAND: BAU-SCHRITT S3: XSD: `ReportType` + `report` `minOccurs="0"` im **`comdare_thesis_profile`**-Typ von `Code/test_data_xml/experiment_schema.xsd`. **Vorher pruefen**, ob `Code/tests/fixture_schema_s
ORT: unbekannt
SOLL/FIX: Schritt: XSD: `ReportType` + `report` `minOccurs="0"` im **`comdare_thesis_profile`**-Typ von `Code/test_data_xml/experiment_schema.xsd`. **Vorher pruefen**, ob `Code/tests/fixture_schema_subset_check.cmake`, `xml_canonical_utils.cmake`, `golden_n_consistency_check.cmake` die Ergaenzung neutral vertragen || Abnahme (literale Ausgabe): Die drei `.cmake`-Pruefungen laufen vor und nach der Ergaenzung mit identischem Ergebnis; beide Ausgaben nebeneinander
STATUS LT. QUELLE: offen (Bau-Schritt, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: S11 setzt O-4 voraus; S1-S9+S17 owner-unabhaengig

### [wp8u862m5.json] 016
GEGENSTAND: BAU-SCHRITT S4: `xml_config_parser.{hpp,cpp}`: `struct ThesisReport` + `parse_thesis_profile`-Block, roh, **keine Token-Pruefung** (Baseline-Layering; Muster `measurement_categories`, `:406-408`)
ORT: unbekannt
SOLL/FIX: Schritt: `xml_config_parser.{hpp,cpp}`: `struct ThesisReport` + `parse_thesis_profile`-Block, roh, **keine Token-Pruefung** (Baseline-Layering; Muster `measurement_categories`, `:406-408`) || Abnahme (literale Ausgabe): Round-Trip-Test: Profil ohne `<report>` parst byte-identisch zu vorher; Profil mit `<report>` liefert die Rohstrings
STATUS LT. QUELLE: offen (Bau-Schritt, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: S11 setzt O-4 voraus; S1-S9+S17 owner-unabhaengig

### [wp8u862m5.json] 017
GEGENSTAND: BAU-SCHRITT S5: `validate_profile` (cache_engine-Schicht) prueft `form`/`reducer`/`predicate`/`lang` gegen die Registries, Eindeutigkeit von `block id` **und** `label` ueber das ganze Profil, `rol
ORT: unbekannt
SOLL/FIX: Schritt: `validate_profile` (cache_engine-Schicht) prueft `form`/`reducer`/`predicate`/`lang` gegen die Registries, Eindeutigkeit von `block id` **und** `label` ueber das ganze Profil, `role="lead"` genau einmal, `@key`-Rueckwaertsreferenz, Namens-Regexe || Abnahme (literale Ausgabe): Sechs Bissproben, je ein absichtlicher Fehler, je die literale Fehlermeldung mit Auflistung der gueltigen Tokens
STATUS LT. QUELLE: offen (Bau-Schritt, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: S11 setzt O-4 voraus; S1-S9+S17 owner-unabhaengig

### [wp8u862m5.json] 018
GEGENSTAND: BAU-SCHRITT S6: Neues Modul `Code/10_report_composer/` (hpp/cpp/main_cli/CMakeLists/tests), `add_subdirectory` in `Code/CMakeLists.txt`. Linkt `comdare::csv_to_latex`, `comdare::diagram_generator`
ORT: unbekannt
SOLL/FIX: Schritt: Neues Modul `Code/10_report_composer/` (hpp/cpp/main_cli/CMakeLists/tests), `add_subdirectory` in `Code/CMakeLists.txt`. Linkt `comdare::csv_to_latex`, `comdare::diagram_generator`, `comdare::cache_engine_headers` || Abnahme (literale Ausgabe): `cmake --build --target report_composer_cli` gruen; `report-composer --help` gibt die Usage aus
STATUS LT. QUELLE: offen (Bau-Schritt, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: S11 setzt O-4 voraus; S1-S9+S17 owner-unabhaengig

### [wp8u862m5.json] 019
GEGENSTAND: BAU-SCHRITT S7: `compose_report()`: WIDE-Matrix **einmal** parsen, je Sprache Bloecke + Kapitel-Huelle + Variablen + Schalter schreiben, `report_manifest.txt` mit sha256 je Pfad
ORT: unbekannt
SOLL/FIX: Schritt: `compose_report()`: WIDE-Matrix **einmal** parsen, je Sprache Bloecke + Kapitel-Huelle + Variablen + Schalter schreiben, `report_manifest.txt` mit sha256 je Pfad || Abnahme (literale Ausgabe): Fixture-Lauf: `wc -l report_manifest.txt` und `sha256sum -c` gegen die erzeugten Dateien, beide literal
STATUS LT. QUELLE: offen (Bau-Schritt, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: S11 setzt O-4 voraus; S1-S9+S17 owner-unabhaengig

### [wp8u862m5.json] 020
GEGENSTAND: BAU-SCHRITT S8: Fehlerklassen und getrennte Exit-Codes: `12` honest-empty, `13` unbekannte Form, `14` unbekannter Reducer, `15` Sprach-Luecke, `16` angeforderte Spalte fehlt im Korpus, `17` `@key`
ORT: unbekannt
SOLL/FIX: Schritt: Fehlerklassen und getrennte Exit-Codes: `12` honest-empty, `13` unbekannte Form, `14` unbekannter Reducer, `15` Sprach-Luecke, `16` angeforderte Spalte fehlt im Korpus, `17` `@key` ohne `<value>`, `18` id-/label-Kollision. **Jede Klasse zusaetzlich als `WARNUNG fehlerklasse=<name>` ins Log** (Hausmuster: `apps/experiment_planner/main.cpp:95`) || Abnahme (literale Ausgabe): Sieben Bissproben, je der literale Exit-Code plus die `fehlerklasse=`-Zeile
STATUS LT. QUELLE: offen (Bau-Schritt, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: S11 setzt O-4 voraus; S1-S9+S17 owner-unabhaengig

### [wp8u862m5.json] 021
GEGENSTAND: BAU-SCHRITT S9: `--check-lang-parity` als reine Pruefung ohne Schreiben
ORT: unbekannt
SOLL/FIX: Schritt: `--check-lang-parity` als reine Pruefung ohne Schreiben || Abnahme (literale Ausgabe): Profil mit fehlendem `<caption lang="en">` liefert Exit 15 und nennt Block-id und Sprache
STATUS LT. QUELLE: offen (Bau-Schritt, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: S11 setzt O-4 voraus; S1-S9+S17 owner-unabhaengig

### [wp8u862m5.json] 022
GEGENSTAND: BAU-SCHRITT S10: Thesis-Verdrahtung **DE zuerst**: Praeambel-Trio in `diplomarbeit.tex`, dann `\InputIfFileExists{anhang/\thesislang/generated/G_generierte_ergebnisse}` am Ende von `anhang/de/A_mea
ORT: unbekannt
SOLL/FIX: Schritt: Thesis-Verdrahtung **DE zuerst**: Praeambel-Trio in `diplomarbeit.tex`, dann `\InputIfFileExists{anhang/\thesislang/generated/G_generierte_ergebnisse}` am Ende von `anhang/de/A_measurements.tex`; danach `anhang/en/A_measurements.tex` nachziehen || Abnahme (literale Ausgabe): `latexmk` baut DE und EN ohne die generierten Dateien fehlerfrei; Seitenzahl vor/nach identisch
STATUS LT. QUELLE: offen (Bau-Schritt, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: S11 setzt O-4 voraus; S1-S9+S17 owner-unabhaengig

### [wp8u862m5.json] 023
GEGENSTAND: BAU-SCHRITT S11: Erste echte Nutzung: drei `\Erg{}` und ein `\ErgWenn{}` in `kapitel/de/05_evaluation.tex`, danach `kapitel/en/05_evaluation.tex`
ORT: unbekannt
SOLL/FIX: Schritt: Erste echte Nutzung: drei `\Erg{}` und ein `\ErgWenn{}` in `kapitel/de/05_evaluation.tex`, danach `kapitel/en/05_evaluation.tex` || Abnahme (literale Ausgabe): PDF gebaut **ohne** Variablen-Datei zeigt an allen vier Stellen `[?]`; **mit** Variablen-Datei zeigt sie die Werte. Beide PDFs, beide Stellen, im Log
STATUS LT. QUELLE: offen (Bau-Schritt, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: S11 setzt O-4 voraus; S1-S9+S17 owner-unabhaengig

### [wp8u862m5.json] 024
GEGENSTAND: BAU-SCHRITT S12: Namens-Lint (`/usr/bin/grep`, kein neues Werkzeug): jeder im Fliesstext benutzte `\Erg{name}` / `\ErgWenn{name}` muss in der Kommentarzeile "Definierte Namen:" des Manifests vorkom
ORT: unbekannt
SOLL/FIX: Schritt: Namens-Lint (`/usr/bin/grep`, kein neues Werkzeug): jeder im Fliesstext benutzte `\Erg{name}` / `\ErgWenn{name}` muss in der Kommentarzeile "Definierte Namen:" des Manifests vorkommen || Abnahme (literale Ausgabe): Ein absichtlicher Tippfehler laesst den Lint rot werden, mit Nennung des Namens und der Fundstelle
STATUS LT. QUELLE: offen (Bau-Schritt, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: S11 setzt O-4 voraus; S1-S9+S17 owner-unabhaengig

### [wp8u862m5.json] 025
GEGENSTAND: BAU-SCHRITT S13: chktex-Entscheidung fuer generierte Dateien umsetzen: der Composer schreibt `% chktex-file 1 % chktex-file 8` in Kopf jeder erzeugten `.tex`
ORT: unbekannt
SOLL/FIX: Schritt: chktex-Entscheidung fuer generierte Dateien umsetzen: der Composer schreibt `% chktex-file 1 % chktex-file 8` in Kopf jeder erzeugten `.tex` || Abnahme (literale Ausgabe): Der Lint laeuft ueber `anhang/*/generated/` ohne Befund; die Kopfzeile im literalen Auszug
STATUS LT. QUELLE: offen (Bau-Schritt, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: S11 setzt O-4 voraus; S1-S9+S17 owner-unabhaengig

### [wp8u862m5.json] 026
GEGENSTAND: BAU-SCHRITT S14: `ci/anhang_forward_core.sh` **manifest-getrieben** umbauen: Kopie, `$COPIED_LIST`, `git add` und der Byte-Delta-Umfang lesen alle aus `report_manifest.txt` statt aus dem hartkodier
ORT: unbekannt
SOLL/FIX: Schritt: `ci/anhang_forward_core.sh` **manifest-getrieben** umbauen: Kopie, `$COPIED_LIST`, `git add` und der Byte-Delta-Umfang lesen alle aus `report_manifest.txt` statt aus dem hartkodierten `anhang/$lang/tabellen`. Ziel-Wache: nur Pfade unter `^anhang/(de\|en)/(tabellen\|generated)/` werden akzeptiert, alles andere exit 1. Namens-Wache, "nie loeschen", Idempotenz, PDF-Gate, Rollback: unveraendert || Abnahme (literale Ausgabe): Dry-Run zeigt eine gestagte Datei unter `generated/`; ein Manifest-Eintrag mit `../` bricht mit exit 1 und literaler Meldung
STATUS LT. QUELLE: offen (Bau-Schritt, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: S11 setzt O-4 voraus; S1-S9+S17 owner-unabhaengig

### [wp8u862m5.json] 027
GEGENSTAND: BAU-SCHRITT S15: `.gitlab-ci.yml`: neue Stage `report` mit `report:compose`, `report:lang-parity`, `report:pdf-gate`. `COMDARE_THESIS_PROFILE` **auch** im `measure:golden-320`-`variables:`-Block se
ORT: unbekannt
SOLL/FIX: Schritt: `.gitlab-ci.yml`: neue Stage `report` mit `report:compose`, `report:lang-parity`, `report:pdf-gate`. `COMDARE_THESIS_PROFILE` **auch** im `measure:golden-320`-`variables:`-Block setzen (auf das golden-Profil) und alle Nutzungen als `${COMDARE_THESIS_PROFILE:-}` schreiben || Abnahme (literale Ausgabe): `measure:golden-320` laeuft mit `set -euo pipefail` durch; der Job-Log zeigt den aufgeloesten Profilpfad literal
STATUS LT. QUELLE: offen (Bau-Schritt, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: S11 setzt O-4 voraus; S1-S9+S17 owner-unabhaengig

### [wp8u862m5.json] 028
GEGENSTAND: BAU-SCHRITT S16: Die drei `\|\| echo "... kein Fehler"`-Stellen (`.gitlab-ci.yml:765,775,857,867`) durch `rc=$?; case` ersetzen: nur `0` und `12` sind gruen, alles andere bricht ab
ORT: unbekannt
SOLL/FIX: Schritt: Die drei `\|\| echo "... kein Fehler"`-Stellen (`.gitlab-ci.yml:765,775,857,867`) durch `rc=$?; case` ersetzen: nur `0` und `12` sind gruen, alles andere bricht ab || Abnahme (literale Ausgabe): Ein injizierter Exit 13 macht den Job rot; ein injizierter Exit 12 laesst ihn gruen. Beide Logs
STATUS LT. QUELLE: offen (Bau-Schritt, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: S11 setzt O-4 voraus; S1-S9+S17 owner-unabhaengig

### [wp8u862m5.json] 029
GEGENSTAND: BAU-SCHRITT S17: Golden-Neutralitaets-Beweis: `declared_count` und golden-CRC vor und nach dem Paket
ORT: unbekannt
SOLL/FIX: Schritt: Golden-Neutralitaets-Beweis: `declared_count` und golden-CRC vor und nach dem Paket || Abnahme (literale Ausgabe): Beide Zahlen literal nebeneinander, identisch. `<report>` ist `binary_id`-neutral -- **das ist eine Behauptung, bis sie hier steht**
STATUS LT. QUELLE: offen (Bau-Schritt, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: S11 setzt O-4 voraus; S1-S9+S17 owner-unabhaengig

### [wp8u862m5.json] 030
GEGENSTAND: BAU-SCHRITT S18: Plan-Doku nachziehen: die E-18-Negativzusage "0 Dateien ausserhalb `anhang/<lang>/tabellen/*.tex`" (`docs/sessions/20260805-PLAN-b1-e18-vorwaerts-kanal.md`) **deprecaten, nicht loe
ORT: unbekannt
SOLL/FIX: Schritt: Plan-Doku nachziehen: die E-18-Negativzusage "0 Dateien ausserhalb `anhang/<lang>/tabellen/*.tex`" (`docs/sessions/20260805-PLAN-b1-e18-vorwaerts-kanal.md`) **deprecaten, nicht loeschen**; Ledger-Eintrag zu F10 als abgeloest markieren || Abnahme (literale Ausgabe): Beide Dokumente zeigen den Deprecate-Vermerk mit Datum und Ersatz-Verweis
STATUS LT. QUELLE: offen (Bau-Schritt, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: S11 setzt O-4 voraus; S1-S9+S17 owner-unabhaengig

### [wp8u862m5.json] 031
GEGENSTAND: BESTANDS-BRUCH: measure:golden-320
ORT: unbekannt
SOLL/FIX: Wie es bricht: Bekommt `COMDARE_THESIS_PROFILE` in seinen `variables:`-Block (hat es heute nicht -- verifiziert, `.gitlab-ci.yml:723` gilt nur fuer smoke) || Wie es sich meldet: Ohne diesen Schritt bricht der Job nach bis zu 10 Tagen Messlauf mit "unbound variable" ab. **Deshalb steht er in S15 und nicht spaeter**
STATUS LT. QUELLE: offen (deklarierter Bruch mit Meldeweg)
ABHAENGIGKEIT/FLAECHE: -

### [wp8u862m5.json] 032
GEGENSTAND: BESTANDS-BRUCH: anhang/<lang>/A_measurements.tex
ORT: unbekannt
SOLL/FIX: Wie es bricht: Bekommt eine `\InputIfFileExists`-Zeile am Ende. Der handgeschriebene Teil bleibt vollstaendig || Wie es sich meldet: Keine Verdopplung, weil M10 einen eigenen Namensraum hat und M08 unveraendert weiterschreibt. **Das Ausduennen des handgeschriebenen Teils ist ein eigenes Migrations-Paket**, kein Teil dieses
STATUS LT. QUELLE: offen (deklarierter Bruch mit Meldeweg)
ABHAENGIGKEIT/FLAECHE: -

### [wp8u862m5.json] 033
GEGENSTAND: BESTANDS-BRUCH: Golden-Katalog / binary_id
ORT: unbekannt
SOLL/FIX: Wie es bricht: Ich **behaupte**, `<report>` ist neutral || Wie es sich meldet: S17 ist genau deshalb ein eigener Schritt mit literalem Vorher/Nachher. Bis der Beleg da ist, gilt es als unbelegt
STATUS LT. QUELLE: offen (deklarierter Bruch mit Meldeweg)
ABHAENGIGKEIT/FLAECHE: -

### [wp8u862m5.json] 034
GEGENSTAND: RESTLICHE UNSICHERHEITEN (ungeschminkt): dritter Entwurf nie gesehen; Zahlenformat-Helfer ungeprueft; XSD-Scharf-Validierung ungeklaert; CDATA-Faehigkeit xml_reader.hpp unverifiziert
ORT: unbekannt
SOLL/FIX: ### Restliche Unsicherheiten, ungeschminkt

- Ich habe den dritten Entwurf nie gesehen und das `ct-rein`-Urteil nie erhalten. Es kann darin ein Argument geben, das meine Empfehlung kippt.
- Ob `04_csv_to_latex` / `05_diagram_generator` einen gemeinsamen Zahlenformat-Helfer haben, weiss ich nicht. Falls nein, ist das der erste Befund von S7.
- Wo die XSD ueberhaupt **scharf** validiert wird, konnte ich nicht klaeren -- ich habe die drei `.cmake`-Konsumenten nur als Treffer gesehen, nicht gelesen. S3 prueft das, bevor gebaut wird.
- Ob `xml_reader.hpp` CDATA kennt, habe ich nicht verifiziert. Fuer Unterschriften mit `&` oder `<` ist das relevant.
STATUS LT. QUELLE: offen (deklarierte Luecken)
ABHAENGIGKEIT/FLAECHE: -


## QUELLE ww7eb5key.json -- Kostenklammer-Restposten + Codex-Testoffensive + CI-Pipeline-Bestandsaufnahme + Fahrplan (06.08.). ZEITSTAND 06.08.: viele Posten inzwischen bewegt (z.B. axis-lock-Doppeldefinition auf development geheilt, main-FF-Frage). Nenner: 14 Kostenklammer-Posten (11 BESTAETIGT, 2 K-01-abhaengig, 1 UNGEPRUEFT), 6 V-Posten, Codex-Befunde A+B selbst verifiziert, Blocker B1-B6, Fahrplan Schritte 0-5, 3 Owner-Entscheide (O-G/O-H/O-A).

### [ww7eb5key.json] 001
GEGENSTAND: Quellenlage-Befund: zwei unabhaengige Fund-Listen (fund K-01..K-10 vs. Anklageschrift KK-1..KK-9) ueberlappen nur in 3 Punkten; 6 K-Posten (K-04,K-06..K-10) fehlten in der Anklageschrift komplett; KK-1 (PMC, schwerster Posten) nur in der Anklageschrift
ORT: docs/sessions/20260806-ANKLAGE-kostenklammern-plan-diff.md
SOLL/FIX: Beide Listen zusammengefuehrt, jeder Posten am aktuellen Stand neu geprueft; KEIN Posten entlastet
STATUS LT. QUELLE: nur-hinweis (Methodik-Befund: Listen-Divergenz)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 002
GEGENSTAND: Posten 1: PMC-Flag fehlt im einzigen realen Voll-Mess-Pfad -- 131.072-Zellen-Matrix misst ohne Cache-Zaehler; alle 4 cmake-Emissionszeilen ohne COMDARE_ENABLE_PMC; measure:smoke DEPRECATED-Fallback; 131k-Pfad laeuft ueber flaglosen Emittenten
ORT: experiment_plan_director.hpp:841,877,1194,1342 | m3v2_pmc_smoke.cpp:71 | CMakeLists.txt:67
SOLL/FIX: Am Objekt verifiziert (Stichprobe 06.08.); Behebung nicht in dieser Quelle vollzogen
STATUS LT. QUELLE: offen (BESTAETIGT am HEAD b6d87c08, 06.08.)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 003
GEGENSTAND: Posten 2: allow_failure:true auf demselben Voll-Mess-Batch -- Batch ohne PMC-Werte kann zusaetzlich scheitern ohne Pipeline-Rot
ORT: experiment_plan_director.hpp:1333
SOLL/FIX: Am Objekt verifiziert (Stichprobe 06.08.); Behebung nicht in dieser Quelle vollzogen
STATUS LT. QUELLE: offen (BESTAETIGT)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 004
GEGENSTAND: Posten 3: contract:axis-version-lock doppelt definiert -- Heuristik-Tripwire seit Wochen aus, REAL Drift durchgelassen (2 unbemerkte Semantik-Aenderungen am Kurven-Lader seit 19.07., Bisektion dokumentiert); Fix existiert fertig aber UNGELANDET (597ecffe+557d8023 auf b-r4-ci-abdeckung)
ORT: .gitlab-ci.yml:343 vs :502 | docs/sessions/20260806-FAHRPLAN-hauptstrang-landung.md:95-113
SOLL/FIX: Am Objekt verifiziert (Stichprobe 06.08.); Behebung nicht in dieser Quelle vollzogen
STATUS LT. QUELLE: teilweise (Fix gebaut, ungelandet; laut pipeline-Teil: auf development geheilt, auf main weiter aktiv)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 005
GEGENSTAND: Posten 4: 234-V-b Shaped-Emission fertig gebaut, nie an Produktivpfad angeschlossen (nur 2 Tests referenzieren) -- Liegenlassen fertiger Arbeit
ORT: adhoc_emitter_shaped.hpp | pilot_source_map_shaped.hpp
SOLL/FIX: Am Objekt verifiziert (Stichprobe 06.08.); Behebung nicht in dieser Quelle vollzogen
STATUS LT. QUELLE: offen (BESTAETIGT)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 006
GEGENSTAND: Posten 5: target_isa-Unterachsen numa_node/page geparst aber KOMPLETT ohne Konsumenten (nur Schreib-Stellen des Parsers; Profil-XML mit dieser Achse taeuscht Wirkung vor)
ORT: xml_config_parser.cpp:130,132
SOLL/FIX: Am Objekt verifiziert (Stichprobe 06.08.); Behebung nicht in dieser Quelle vollzogen
STATUS LT. QUELLE: offen (BESTAETIGT, staerker als behauptet)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 007
GEGENSTAND: Posten 6: doppeltes Fingerprint-Leeren (na-Zellwert + T2-C-Sonde, COMDARE_BESTANDSLOG-Gate)
ORT: profile_run_entry.hpp:1012 | :434-451
SOLL/FIX: Am Objekt verifiziert (Stichprobe 06.08.); Behebung nicht in dieser Quelle vollzogen
STATUS LT. QUELLE: teilweise (Mechanismus bestaetigt; Wirkung K-01-abhaengig -- K-01 spaeter im plan-Teil WIDERLEGT)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 008
GEGENSTAND: Posten 7 (=KK-8): kPlanOhneAnker als Dauerzustand statt Ausnahme
ORT: planer_driven_build.hpp:297,301
SOLL/FIX: Am Objekt verifiziert (Stichprobe 06.08.); Behebung nicht in dieser Quelle vollzogen
STATUS LT. QUELLE: teilweise (Code bestaetigt, Wirkung K-01-abhaengig)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 009
GEGENSTAND: Posten 8 (=KK-4): bestandslog_active prueft Funktions-Existenz statt Fingerprint-Identitaet -- wird aktiv falsch sobald K-01 geoeffnet
ORT: cache_engine_builder_iterator.hpp:1658-1660 | :1194/:1219
SOLL/FIX: Am Objekt verifiziert (Stichprobe 06.08.); Behebung nicht in dieser Quelle vollzogen
STATUS LT. QUELLE: offen (BESTAETIGT)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 010
GEGENSTAND: Posten 9: COMDARE_VARIANT_GATE -- Cross-Maschinen-.variant-Drift-Vergleich nie aktiv (in keiner .gitlab-ci.yml gesetzt); gefaehrlich beim Multi-Maschinen-Betrieb
ORT: profile_run_entry.hpp:453,461 | build_orchestrator.hpp:250-255
SOLL/FIX: Am Objekt verifiziert (Stichprobe 06.08.); Behebung nicht in dieser Quelle vollzogen
STATUS LT. QUELLE: offen (BESTAETIGT)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 011
GEGENSTAND: Posten 10 (=K-03/KK-6): PlanFach::offen erhoben aber von plan_resume_faecher nie gelesen -- wird falsch sobald Mini-Batch-ETA auf Atom-Granularitaet aufsetzt
ORT: batch_planner.hpp:163/:246/:305
SOLL/FIX: Am Objekt verifiziert (Stichprobe 06.08.); Behebung nicht in dieser Quelle vollzogen
STATUS LT. QUELLE: offen (BESTAETIGT)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 012
GEGENSTAND: Posten 11 (=KK-7): active_telemetry_is_silent() liefert literal false, ignoriert geparstes Profil (im Code als golden-brechender aufgeschobener Schritt benannt)
ORT: profile_run_facade.cpp:240-241
SOLL/FIX: Am Objekt verifiziert (Stichprobe 06.08.); Behebung nicht in dieser Quelle vollzogen
STATUS LT. QUELLE: offen (BESTAETIGT, Kategorie Sauberkeit)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 013
GEGENSTAND: Posten 12: COMDARE_CE_ENABLE_OBSERVER_PUSH -- Observer ueber .so-Grenze architektonisch nie erreichbar; woertlich zitierte User-Anforderung strukturell uneinloesbar
ORT: measurable_concept.hpp:5-13,53,55
SOLL/FIX: Am Objekt verifiziert (Stichprobe 06.08.); Behebung nicht in dieser Quelle vollzogen
STATUS LT. QUELLE: offen (BESTAETIGT)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 014
GEGENSTAND: Posten 13: COMDARE_LEGACY_MESSREIHEN als 'Gate' zitiert, existiert im Code nicht (3 Kommentar-/Doku-Treffer, kein ifdef/getenv/Option) -- Rechtfertigung beruft sich auf nicht existierenden Schutzmechanismus
ORT: xml_config_parser.hpp:14 | .cpp:147 | test_data_sets.xml:5
SOLL/FIX: Am Objekt verifiziert (Stichprobe 06.08.); Behebung nicht in dieser Quelle vollzogen
STATUS LT. QUELLE: offen (BESTAETIGT)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 015
GEGENSTAND: Posten 14 (KK-9): bytes_in_use_peak traegt END-Wert statt Peak (selbstdokumentiert); konkrete Fehlkonsum-Stelle f15_compare nicht bestaetigt
ORT: measurement_snapshot.hpp:124 | apps/f15_compare/main.cpp:364-376
SOLL/FIX: Am Objekt verifiziert (Stichprobe 06.08.); Behebung nicht in dieser Quelle vollzogen
STATUS LT. QUELLE: teilweise (Zuweisung bestaetigt, Konsum UNGEPRUEFT)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 016
GEGENSTAND: V-A: Ledger-Haken I-PMC-1 'erledigt' wortlaut-korrekt (Flag in measure:smoke+golden-320), aber Wirkung beim Umbau auf dynamische Kette VERLOREN (Emittent flaglos)
ORT: LEDGER:532/:1417 | super .gitlab-ci.yml:677/:768
SOLL/FIX: -
STATUS LT. QUELLE: offen (BESTAETIGT -- Haken wahr, Wirkung weg)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 017
GEGENSTAND: V-C: par.66-N2 'BEIDE hart' vs. Mess-Batch mit allow_failure:true -- Gegenbeweis am Batch bestaetigt; ce-pmc-Zeilen nicht selbst gelesen
ORT: experiment_plan_director.hpp:1333
SOLL/FIX: -
STATUS LT. QUELLE: teilweise (ce-Teil UNGEPRUEFT)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 018
GEGENSTAND: V-D: 'contract:axis-version-lock als HARTES CI-Gate' laeuft in keiner Pipeline -- Ledger-Eigenrecherche deckt sich mit Code-Befund
ORT: LEDGER:2724/:2874/:4589
SOLL/FIX: -
STATUS LT. QUELLE: offen (BESTAETIGT)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 019
GEGENSTAND: V-B: 'Default-Modus-Konsequenz owner-gedeckt (F7)' -- Dossier nicht gelesen
ORT: profile_run_entry.hpp:423
SOLL/FIX: -
STATUS LT. QUELLE: offen (UNGEPRUEFT)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 020
GEGENSTAND: V-E: honest-100%-Doktrin vs. NullPmcSource -- folgt aus Posten 1 + Ledger Z.555 'kein Weg-Nullen = honest-0-Aufgeben'
ORT: LEDGER:555
SOLL/FIX: -
STATUS LT. QUELLE: offen (BESTAETIGT als Konsequenz)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 021
GEGENSTAND: V-F: 'bestandslog_active als Lager-Gate' = Posten 8
ORT: cache_engine_builder_iterator.hpp:1658-1660
SOLL/FIX: -
STATUS LT. QUELLE: offen (BESTAETIGT)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 022
GEGENSTAND: CODEX-TESTOFFENSIVE Befund A (selbst verifiziert): doppelter CI-Job-Schluessel contract:axis-version-lock (:343 vs :502, letzte Definition gewinnt, COMDARE_AXIS_LOCK_CHECK nirgends gesetzt) -- Header-Digest-Gate laeuft in KEINEM regulaeren Lauf
ORT: ce .gitlab-ci.yml:343/:502
SOLL/FIX: Duplicate-Key-Wache bauen (Top-5 Nr.1, ~1-2h)
STATUS LT. QUELLE: offen (Stand 06.08.; laut plan-Teil auf development geheilt)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 023
GEGENSTAND: CODEX-TESTOFFENSIVE Befund B (selbst verifiziert): 17 CTest-Targets mit Label contract gebaut aber NIE ausgefuehrt (test:unit filtert -LE contract|pmc; kein -R-Regex nennt sie; alle 13 ctest-Aufrufe explizite Allowlists) -- Fehlerklasse '9 Tests liefen in KEINEM Job', n=17
ORT: tests/unit/CMakeLists.txt x .gitlab-ci.yml
SOLL/FIX: CTest-Routing-Deckungswache (Top-5 Nr.2, ~2-4h); alle 17 Waisen in eine aktive Lane; Namensliste: test_e1_contract_rc_konsum, test_e2_contract_abi_vertrag, test_e3_contract_binary_id_bijektion, test_e3_contract_conformance_gate_wirksam, test_e4_contract_xml_to_axislevels, test_experiment_dock_payload, test_experiment_kern_seam, test_experiment_plan_director, test_experiment_projection, test_gn_cell_filter, test_m_contract_system_axis_wurzel, test_merge_plan_directive, test_org18_persistence_target, test_phase6_vorbau, test_phase_b_effective_search_algo_contrast, test_progress_delta, test_striktheit_scan_kernel_purity
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 024
GEGENSTAND: CODEX Q1/Q2/Q3/Q4/Q5 + Runde 2 (verbatim uebernommen): 18 Testvorschlaege; tautologische Bestandstests mit Datei:Zeile; ungepruefte Invarianten (Planer->CEB->Tier-Wertkette, echte ABI-Stabilitaet, 18-Achsen-Manifest, Lager-Crash-Atomizitaet, XLSX-Roundtrip); Priorisierung; 3 Bestandstests die echte Regression NICHT fangen (test_e2_contract_abi_vertrag, test_gn_cell_filter, test_g2_variant_sidecar:246-270)
ORT: tests/unit/*
SOLL/FIX: ### Codex-Runde 1 -- die 5 Owner-Fragen (roh, hier verdichtet; volle Antwort im Thread `019fd818-57dc-7ab2-b70f-6bfb91c31b5b`)

**Q1 Fehlende Tests (18 konkrete Vorschlaege, je mit Beweis/Ort/Biss)** -- u.a.: Duplicate-Key-Wache; CTest-Routing-Deckungswache (Analogon zu dcb2f08f, diesmal auf Ist-Menge statt YAML-Text); Axis-Lock-Mutationsmatrix (v1->Drift->rot->v2-Bump->gruen->Drift->rot); Fingerprint-Form-Kreuzprobe Schreib-/Lesepfad; F3-Test von "Schreiber erzeugt 127/129 Byte" auf "Schreiber ist fail-closed" drehen; `SpoolFlushWaitsForInflightBatch` + `SpoolFlushReportsBackendFailure` (deterministisches Latch-Backend statt racy Portable-Backend); `CacheLineAxisReachesFinalCluConsumer` (B32/B64/B128/B256-Matrix gegen feste Erwartungstabelle, nicht gegen denselben Nenner wie der Code); XXE-Doppelprobe (echter Angriff MIT externer DTD-Datei UND harmlose-DOCTYPE-Gegenprobe -- Codex weist selbst darauf hin, dass nur einer der beiden Faelle zu schwach waere); `CMakeZeroCountCreatesZeroProductionEntries` (N=0/1/3 gegen die echte geheilte RANGE-Stelle); `PlanerCebTierValueIdentity`; `LiveBuildContextIsBoundExactlyOnce` (Provider mit A dann B, Aufrufzahl exakt 1 erwartet); `SuffixRejectsStructuralCharacters`; `RealRegistryManifestIsExact`; `CountersMatchWitnessSets`; `GeneratedDocumentsAreParsedByTheirRealParser`.

**Q2 Tautologische/falsch-ordnungs-pinnende Bestandstests (mit Datei:Zeile):** `test_r2_suffix_wachen.cpp:77-78` (verifiziert); `test_config_durability.cpp:105-122` (akzeptiert `XmlNode` ODER `nullopt`, endet in `SUCCEED()` -- beweist nur "kein Crash"); `test_g2_variant_sidecar.cpp:275-280` (Materialisierer gegen eigene Konstante); `test_f3_lager_key_provider_iterator.cpp:208-305` (zementiert laut Codex explizit den alten "Schreiber erzeugt 127/129 Byte, erst Leser klassifiziert"-Zustand -- bei Fail-closed-Schreib-Vertrag waere das die Zementierung des geheilten Defekts); `test_e24_c10_g6_identitaets_bilanz.cpp:171-191` (prueft laut Codex weiterhin den Vor-CEB-Injektions-Zustand); `test_clu_per_layout.cpp:108-110` (Testorakel traegt denselben Nenner `64` wie der zu pruefende Code); `test_phase6_vorbau.cpp:41-52,117-136` (Separator-Mismatch in der CSV-Quote-Probe: Fixture nutzt Komma, Code trennt per Semikolon); `test_experiment_plan_director.cpp` mehrfach (fehlendes Registry-Trio wird als `resolved=0, ok=1` akzeptiert -- gruener Null-Arbeits-Fallback); `test_progress_delta.cpp:95-102` (Minimalitaets-Check nur als Bereichsgrenze, nicht als exakte Hamming-Differenz); `test_striktheit_scan_kernel_purity.cpp` (raeumt laut Codex im eigenen Dateikopf ein, nur Interfaceform zu pruefen, nicht den Funktionskoerper).

**Q3 Ungepruefte Invarianten:** Planer->CEB->Tier-`.so` als durchgaengige Wertkette (nur Teilstuecke belegt); echte ABI-Stabilitaet alt-vs-neu (heute nur Same-Build-Selbstkonsistenz); vollstaendige Stempelgrammatik/Injektivitaet; exaktes 18-Achsen-Manifest (Name+Reihenfolge+Eindeutigkeit, nicht nur Anzahl); Lager-Crash-Atomizitaet an jeder Schreibgrenze; 1,57-Mio-Kardinalitaet/Batch-Lueckenfreiheit; echter XLSX-Roundtrip (heute laut Codex kein einziger gefunden); erzeugtes CI-YAML/CMake als ausfuehrbarer statt nur textueller Vertrag.

**Q4 CI vs. lokal:** die 9 (lokal ggf. 17) toten `contract`-Tests; Axis-Lock effektiv inert; kein gemeinsames CMake/CTest-Preset zwischen lokalem Lauf und den handgepflegten `-R`-Listen in `.gitlab-ci.yml` (Drift-Risiko).

**Q5 Priorisierung (VOR erstem Vollgruen, hart):** Duplicate-Key-Wache zuerst (sonst kann jedes weitere Gate per zweitem Schluessel abgeschaltet werden) -> ein einziger aktiver `axis-version-lock` -> CTest-Routing-Wache mit Waisen-Fixture -> alle 17 Waisen in eine aktive Lane -> Fingerprint-Formmatrix -> XXE-Doppelprobe -> Spool-Barrier deterministisch -> CLU-Matrix -> RANGE-N=0-Fixture -> ein repraesentativer Planer->CEB->Tier-Identitaetstest. DANACH erst: volle ABI-Baseline (libabigail), Property-/Fuzz-Tests, Lager-Crashmatrix, echter XLSX-Roundtrip, volle 1,57-Mio-Abdeckungsinvariante.

### Codex-Runde 2 -- Verdichtung unter Zeitdruck (Fr 08.08.)

**A) Top 5, je wenige Stunden, ohne neues Framework/XLSX-Lib/libabigail, priorisiert:**
1. Duplicate-Key-Wache (~1-2h) -- deckt den heute aktiven Gate-Ausfall.
2. CTest-Routing-Wache (~2-4h) -- deckt die 17 Waisen.
3. Axis-Lock-Mutationstest (~1-3h).
4. Fingerprint-Kreuzprobe Schreib/Lese (~2-4h, bestehende Harnesses wiederverwendbar).
5. XXE-Negativtest im bestehenden `test_config_durability.cpp` (~1-2h).

**B) 3 Bestandstests, bei denen Codex sich am sichersten ist, dass ein echter Regressions-Fall NICHT gefangen wuerde -- mit konkretem Rueckfall:**
- `test_e2_contract_abi_vertrag.cpp`: zwei ABI-Felder vertauschen + Major nicht bumpen + beide Seiten gemeinsam neu bauen -> bleibt gruen (Same-Build-Selbstkonsistenz statt ABI-Stabilitaet).
- `test_gn_cell_filter.cpp`: Filter in der zweiten produktiven Walk-Call-Site nicht mehr durchreichen bzw. durch `{}` ersetzen -> `gn_walk_cells` selbst bleibt korrekt, Test bleibt gruen, Produktion baut/misst ungefiltert.
- `test_g2_variant_sidecar.cpp:246-270`: einen `page_type`-Eintrag weglassen und dafuer einen `simd_extension`-Eintrag duplizieren -> Gesamtklammerzahl `{` bleibt gleich, Test bleibt gruen, Signatur ist trotzdem falsch.

**C) Codex' Selbstkritik (unaufgefordert, wichtig):** Der spekulativste eigene Vorschlag ist `PlanerCebTierValueIdentity` -- Codex konnte `test_t2a_f4_facade_plan_durchreichung.cpp` und den aktuellen letzten CEB-Verbraucher auf `b6d87c08` nicht lesen (Sandbox-Netzwerkfehler) und hat aus Architekturmuster geschlossen, dass die Kette fehlt. **Meine eigene Nachpruefung dieser Datei bestaetigt: sie deckt die Plan-Ablage-Durchreichung, nicht die Achsenwert-Kette -- Codex' Luecken-Vermutung bleibt damit plausibel, aber war zum Zeitpunkt der Aussage unbelegt, und Codex hat das selbst offen benannt statt es zu verschweigen.**

### Meine Einordnung (was ich fuer real/handlungsreif halte)

**Hart belegt, real, sofort umsetzbar** -- Befund A (doppelter CI-Schluessel) und Befund B (17 tote contract-Tests) sind von mir selbst am Objekt bestaetigt, nicht nur von Codex behauptet. Die Top-5-Liste aus Runde 2 baut direkt darauf auf und ist plausibel im vom Owner verlangten Zeitfenster umsetzbar. Diese fuenf wuerde ich dem Owner ungeprueft-aber-mit-hoher-Zuversicht vorschlagen.

**Plausibel, aber nur von Codex behauptet, nicht von mir Zeile fuer Zeile gegengelesen** -- die uebrigen Q2-Befunde (`test_config_durability.cpp`, `test_f3_lager_key_provider_iterator.cpp`, `test_e24_c10_g6_identitaets_bilanz.cpp`, `test_clu_per_layout.cpp`, `test_phase6_vorbau.cpp`, `test_experiment_plan_director.cpp`, `test_progress_delta.cpp`, `test_striktheit_scan_kernel_purity.cpp`) -- diese sind aus Codex' eigener Lektuere und daher, wie Codex selbst gesagt hat, ggf. gegen einen leicht anderen Stand als `b6d87c08` gelesen. Vor Umsetzung: kurz gegen den aktuellen Worktree-Stand nachlesen, bevor daraus ein Test-Patch wird.

**Nicht ausreichend geprueft fuer harte Prioritaet vor Freitag** -- Q3-Punkte 3.6/3.7 (1,57-Mio-Kardinalitaet, echter XLSX-Roundtrip), 3.2 (volle ABI-Baseline via libabigail) -- Codex selbst stuft diese als "danach" ein; deckt sich mit meiner Einschaetzung angesichts der Frist.
STATUS LT. QUELLE: offen (Testluecken-Katalog 06.08.; Umsetzungsstand unbekannt)
ABHAENGIGKEIT/FLAECHE: Codex-Sandbox-Limitation bwrap deklariert; Q2-Reste nicht zeilengenau gegengelesen

### [ww7eb5key.json] 025
GEGENSTAND: PIPELINE-Befund 0 (06.08.): super trigger:cache-engine triggert ce auf BRANCH MAIN -- main 48 Commits hinter development; gruener Lauf = Haken ohne Pruefbereich; test:coverage-guard existiert nicht auf main; Abdeckung dort unbewacht
ORT: super .gitlab-ci.yml:253/:255/:273/:291
SOLL/FIX: ce FF development->main (Fahrplan Schritt 2) -- 'aendert mehr an der Aussagekraft als jeder neue Test'
STATUS LT. QUELLE: offen (Stand 06.08.; spaeterer Vollzug andernorts zu pruefen)
ABHAENGIGKEIT/FLAECHE: O-G

### [ww7eb5key.json] 026
GEGENSTAND: PIPELINE-Bestandsaufnahme: Job-Inventar beider Repos; Abdeckungswache live 409/409 auf development; Blocker B1-B6 (B2: xmllint auf baremetal-Runnern UNVERIFIZIERT -- Code sagt selbst 'NICHT belegt, sondern eine Annahme', 5 da_unit-Tests fallen zur Testlaufzeit; B3 pmc-Lanes; B6 Kind-Pipeline auf 48-Commits-altem Snapshot); lint:format faktisch HART trotz advisory-Kommentar (Divergenz Kommentar/Definition)
ORT: Code/tests/xml_canonical_utils.cmake:38-41 | base-pipeline.yml:104-115
SOLL/FIX: # CI-Pipeline-Bestandsaufnahme (READ-ONLY), Stand 2026-08-06 ~18:xx

## 0. WICHTIGSTER BEFUND ZUERST: welcher Stand laeuft ueberhaupt?

`super/.gitlab-ci.yml:253` (`trigger:cache-engine`) triggert `comdare/research/comdare-cache-engine` auf Branch **`main`**, nicht `development`. Geprueft (`git -C wt-b-r4-ci fetch origin main`):

- `origin/main` = `c837d830` (Merge b-doku-77-78, 11:33 Uhr)
- `origin/development` = `b5e0e4e7` (17:25 Uhr)
- **`git log --oneline origin/main..origin/development | wc -l` = 48** -- main liegt 48 Commits hinter development.

D.h. der heutige gesamte Nachmittags-Zug (p92 3bbcb8ed, T2-A 86be2420, B14-ce f577f886, R4-CI-Invariante b5e0e4e7) ist auf dem Branch, den die super-Pipeline tatsaechlich faehrt, **nicht vorhanden**. Jede Aussage unten ist deshalb fuer zwei verschiedene Pruefbereiche gemacht: **main** (was heute real liefe) und **development** (der lokal am weitesten integrierte Stand).

## 1. Job-Inventar

**super/.gitlab-ci.yml** (1278 Zeilen, Stufen: lint -> orchestrate -> submodules -> analyse -> test -> integration -> planer -> manifest -> thesis-pdf -> measure -> persist):

| Job | Stage | Gate | Bemerkung |
|---|---|---|---|
| lint:secrets | lint | HART (`rules: on_success`) | einziger Pflicht-Job jeder Welle |
| lint:format | lint | HART (kein allow_failure gesetzt!) | siehe par.4b |
| lint:static | lint | HART (kein allow_failure gesetzt!) | cppcheck, hermetisch gebaut |
| runner:sweep-zombies | lint | -- | Wartung |
| toolchain:probe | analyse | via .code-rules | |
| build:clang | analyse | rules-gated `COMDARE_CLANG_MATRIX==1` | opt-in |
| test:unit | test | HART, `needs:[verify:submodules]` | ctest `-L da_unit`, Ziel `comdare_da_unit_tests` |
| trigger:cache-engine / prt-art / thesis | orchestrate | `strategy: depend` (echtes Gate) | rules: nur bei Pfad-Changes bzw. web/api/pipeline/trigger/MR |
| verify:submodules | submodules | HART | git-Gitlink-Determinismus |
| analyse:thesis-data, visibility:tier-binaries | analyse | | |
| integration:smoke | integration | | |
| manifest:provenance, prebackup:measurements | manifest | | |
| thesis:pdf | thesis-pdf | | |
| measure:smoke, measure:golden-320 | measure | **rules: opt-in `COMDARE_RUN_MEASURE`** | inert-by-default |
| persist:measurements, anhang:forward | persist | opt-in | |
| planer:delegate*, ergebnis:holen | planer | `ergebnis:holen` = `when: manual` | |

**cache-engine/.gitlab-ci.yml** -- Zustand haengt vom geprueften Branch ab:

*Auf `origin/main` (c837d830, real getriggert)* -- 519 Zeilen, Stufen lint->build->sanitize->contract->test->chaos, **29 effektive Top-Level-Keys von 30 Zeilen** (Duplikat, s. par.4c). Jobs: lint:{secrets,format,static}, build:clang (opt-in), pmc:amd/intel (rules `COMDARE_PMC_LANES`), build:arm64-smoke (opt-in, allow_failure), sanitize:asan-ubsan (HART), contract (+durability/conformance/pool_flip/harness/profile_coverage/experiment_driver/node_shape, alle HART, `needs:[lint:secrets]`), contract:axis-version-lock (**doppelt, s.u.**), is_original:relock (`when: manual`, allow_failure), chaos:drift (HART), test:unit (HART), sanitize:tsan (HART).

*Auf `origin/development` (b5e0e4e7)* -- 635 Zeilen, **30/30 saubere Keys**, zusaetzlich `test:coverage-guard` (Stage contract, HART, `needs:[lint:secrets]`) -- das neue Gate ueber die Gates.

## 2. Test-Abdeckung -- mit Nenner, live gemessen (kein CMakeLists-Raten)

Ich habe **die existierende Invariante (dcb2f08f, `scripts/ci_test_coverage_guard.sh`) real ausgefuehrt**, nicht neu erfunden -- in einem frischen `git worktree` auf `origin/development` (b5e0e4e7), exakt nach Job-Rezept (2-Pass-Configure + Codegen-Tool):

```
LIVE-INVENTUR (ctest -N): 409 registrierte Tests
...
BILANZ: 409 von 409 registrierten Tests werden von einem fahrenden Job ausgefuehrt.
PARTITIONS-BELEG: ohne Label 'pmc' (test:unit): 407 + mit Label 'pmc': 2 = 409 == Inventur 409
ABDECKUNGS-WACHE: GRUEN -- kein Test ohne fahrenden Job.
```

**Nenner: 409/409 (100%) auf `development`.** Das ist ein Anstieg gegenueber dem Befund vom Vormittag (406, dann 404/406 mit 2-Pass) -- heute sind durch T2-A/B14 weitere Tests dazugekommen, alle sind erfasst.

**Wichtig:** Dieser Job (`test:coverage-guard`) existiert **nicht** auf `main` -- auf dem Branch, den die super-Pipeline real triggert, ist die Abdeckung nach wie vor unbewacht (Stand vom letzten Live-Lauf des R4-Befunds: 9 von 406 Tests liefen in keinem Job).

## 3. Was blockiert einen gruenen Voll-Lauf HEUTE -- getrennt Infra/Code

| # | Blocker | Infra/Code | Beleg |
|---|---|---|---|
| B1 | `main` (der real getriggerte Branch) traegt die R4-CI-Fixes nicht -> doppelter YAML-Key aktiv, Abdeckungswache fehlt | **Code** (Landung fehlt) | git-Diff main vs. development, s. par.0/par.4c |
| B2 | `xmllint` auf den baremetal-Runnern **unverifiziert** -- 5 super-ctest-Tests (Label `da_unit`, laufen also in `test:unit`) rufen `find_program(xmllint)` + `FATAL_ERROR` bei Fehlen | **Infra** (offene Pruefpflicht) | Datei-eigener Kommentar `Code/tests/xml_canonical_utils.cmake:38-41`: *"xmllint ist bis heute in KEINEM CI-Job dieses Repos aufgerufen worden ... Praesenz auf den baremetal-Runnern ist damit NICHT belegt, sondern eine Annahme"*. Auf diesem Desktop ist `/usr/bin/xmllint` vorhanden (libxml2-utils 2.9.14) -- das sagt nichts ueber prod1/prod2. |
| B3 | pmc:amd / pmc:intel brauchen `perf_event_open`-faehige bare-metal-Runner beider Vendor-Lanes | **Infra** (Runner-Verfuegbarkeit) | `.pmc`-Template, `tags:[baremetal,amd]`/`[baremetal,intel]`, `COMDARE_PMC_LANES` |
| B4 | build:arm64-smoke braucht node7-rpi5-arm64-Runner | **Infra** | rules `COMDARE_ISA_MATRIX`, allow_failure=true, opt-in -- heute defaultmaessig gar nicht instanziiert, also kein Blocker im Normalbetrieb |
| B5 | measure/persist-Stufen (mehrtaegiger golden-320-Lauf) | **Infra + Zeit**, aber bewusst opt-in | `COMDARE_RUN_MEASURE` -- nicht Teil des "Voll-Lauf" im Normalfall |
| B6 | trigger:cache-engine/prt-art/thesis: `strategy: depend` -- super wird nur rot, wenn Kind-Pipeline rot wird, aber die Kind-Pipeline laeuft auf einem 48 Commits alten Snapshot | **Code** (Landung nachziehen) | s. par.0 |

Kein Blocker verweist auf fehlende MinIO/Vault/Registry-Objekte in den YAML-Dateien selbst -- der Cache-Layer (ccache via MinIO-Runner-Cache) ist konfiguriert, aber ob er live erreichbar ist, kann ich von hier nicht pruefen (kein Cluster-Zugriff, Doktrin: read-only).

## 4. Bekannte Baustellen gegengeprueft

**(a) xmllint** -- s. B2 oben. Nicht installiert-behauptet, sondern **explizit als ungeklaerte Annahme im Code dokumentiert**. Es ruft ein Job es auf: ja, indirekt ueber `test:unit` (super), sobald die 5 `da_unit`-gelabelten Fixture-Wachen laufen (`test_fixture_sync_experiment_golden`, `test_fixture_sync_prt_registry`, `test_fixture_schema_experiment_golden_kern`, `test_fixture_schema_experiment_golden`, `test_golden_n_consistency`, `Code/tests/CMakeLists.txt:234-238`).

**(b) lint:format** -- laeuft gegen das **projekteigene, vendorte `.clang-format`** (Repo-Root, nicht "extern Cluster"), mit hermetisch heruntergeladenem clang-format 22.1.8 (`base-pipeline.yml:104-115`, SHA256-gepinnt). Ist es ein hartes Gate? **Ja** -- weder das Template noch die konsumierenden Jobs (`lint:format:` in cache-engine UND super) setzen `allow_failure`, obwohl der Kopf-Kommentar des Templates als *Beispiel* `allow_failure: true # advisory bis #179` zeigt. Default in GitLab ist `allow_failure: false`. Also: **hart**, trotz der "advisory"-Doku-Absicht im Template-Kommentar -- das ist selbst eine kleine Divergenz zwischen Kommentar-Absicht und tatsaechlicher Job-Definition.

**(c) test:coverage-guard / Breiten-Ascii-Wache -- die wichtigste Einzelfrage:**
Ich habe die Diff-Hygiene-Wache (`scripts/ci_diff_ascii_width_guard.sh`) real gegen den heute gelandeten Bestand laufen lassen -- Bereich `7969b399..origin/development` (vor der heutigen Landewelle bis jetzt, 8855 gepruefte Zusatzzeilen in selbst verfasstem Code):

```
VERSTOESSE (falls vorhanden): (keine)
NENNER: 8855 Zusatzzeilen geprueft, davon 0 Nicht-ASCII, davon 0 ueber 120 Spalten.
DIFF-HYGIENE-WACHE: GRUEN.
```

**Antwort: NEIN, sie wuerde nicht rot laufen.** Der gelandete Bestand ist sauber. Zusaetzlich habe ich die Schluessel-Wache (Vorstufe desselben Jobs) real gegen beide Branch-Staende geprueft: auf `development` **GRUeN** (30/30 eindeutige Keys), auf `main` **ROT** -- dort besteht der 2026-07-13/06-08 dokumentierte Duplikat-Key `contract:axis-version-lock` (Zeile 343 verworfen, Zeile 502 gewinnt, INERT-gegatet) noch echt, woertlich bestaetigt:
```
DOPPELT: 'contract:axis-version-lock'
  main:343  <- VERWORFEN (steht da, wirkt aber nicht)
  main:502  <- GEWINNT (diese Fassung laeuft)
SCHLUESSEL-WACHE: ROT.
```
D.h. der Fund aus Task #6 ("Tripwire de facto AUS") ist **bereits auf development behoben**, aber **auf main, dem real getriggerten Branch, weiterhin aktiv** -- bis zur Landung auf main bleibt das ein reales Sicherheitsloch der Pipeline.

## 5. Laufzeit

Ich kann hierzu **keine belastbare Zahl liefern** -- die einzigen lokal vorhandenen Trace-Dateien stammen vom 06./09.07. (vor der heutigen Testzahl-Verdopplung, veraltet) und Pipeline-APIs sind laut Doktrin nicht per Live-Abfrage nutzbar von hier. Was sich aus den Job-Definitionen ablesen laesst: `.pmc`-Timeout ist 15 min (fail-fast-Deckel, kein Normwert), die meisten contract-Jobs sind Einzel-Target-Builds (schnell), `test:unit` baut die volle Suite (`comdare_tests`, 409 Targets) und ist damit vermutlich der teuerste Einzeljob -- das ist aber eine Vermutung aus der Zielmenge, kein Messwert, und ich benenne sie ausdruecklich als solche.

## Gepruefte Objekte (Nachweis Pruefbereich)

- `/home/comdare/wt-b2-neuanker/.gitlab-ci.yml` (519 Zeilen, Branch b2-neuanker-format3, **veraltet -- 24 Commits hinter development**, siehe unten)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/.gitlab-ci.yml` (1278 Zeilen, Branch development)
- `/home/comdare/Projekte/Cluster-ci-templates/base-pipeline.yml` (968+ Zeilen, HEAD 5f9e04b)
- cache-engine `origin/main` (c837d830) und `origin/development` (b5e0e4e7) via `git show`/frischer `git worktree` unter `/tmp/ce-covguard-check` (entfernt nach Gebrauch)
- `Code/tests/{CMakeLists.txt,xml_canonical_utils.cmake,golden_n_consistency_check.cmake,fixture_schema_subset_check.cmake}`
- Commit-Bereich Diff-Hygiene-Nachrechnung: `7969b399..origin/development` (Merge-Basis vor der heutigen Landewelle bis HEAD)
- Keine Pipeline ausgeloest, kein Push, kein Merge -- alle Pruefungen liefen lokal (git show/worktree, cmake/ninja/ctest, vorhandene Shell-Wachen).
STATUS LT. QUELLE: offen (Bestandsaufnahme 06.08.)
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 027
GEGENSTAND: PLAN-Korrekturen an den Eingangsberichten: K-01 WIDERLEGT (COMDARE_BESTANDSLOG wird durchgereicht, experiment_plan_director.hpp:952-955 + Ledger:4286ff); Codex-Prioritaeten 1,2,4 BEREITS GEBAUT ('sie zu planen waere Beschaeftigung gewesen'); Berichte massen ueberholten Stand
ORT: experiment_plan_director.hpp:952-955
SOLL/FIX: Jeden Posten an der echten Landelinie neu pruefen bevor Bau
STATUS LT. QUELLE: behoben lt. Quelle (K-01-These widerlegt); Lehre: Stand-Anker pruefen
ABHAENGIGKEIT/FLAECHE: -

### [ww7eb5key.json] 028
GEGENSTAND: PLAN Testoffensive (untracked 06.08.): T-i-3 Abdeckungswache an Landelinie nachmessen (erster Posten); T-i-1 Bissbeweis XXE-/Entity-Sperre (gelandet OHNE Test, 0 Treffer DOCTYPE|ENTITY in tests/); T-i-2 Mutationsprobe axis-version-lock (gruener Job von inertem ununterscheidbar -- Urschaden 3 Wochen aus, 2 reale Drifts); Fahrplan Schritte 0-5 (0: 13 dreckige Submodul-Dateien aufloesen; 2: ce FF; 3: Gitlink-Bump; 4: erster echter Lauf auf development; 5: super FF nach Gruen); Owner-Entscheide O-G (FF-Freigabe), O-H (13 Dateien), O-A (PMC fixen+neu messen vs. ohne Zaehler messen+Grenze benennen)
ORT: docs/plaene/20260806-PLAN-testoffensive-und-gruene-pipeline.md (war untracked!)
SOLL/FIX: `.md` is explicitly out of the width guard's scope ("ABSICHTLICH ausgenommen"), so the wide table rows are compliant. ASCII: 0 violations of 472 lines. Nothing committed -- super HEAD still `b35aea1b`, the plan is untracked.

**PFAD:** `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/plaene/20260806-PLAN-testoffensive-und-gruene-pipeline.md`

**VORWEG -- die Eingangsberichte waren ueberholt.** Sie messen ce `b6d87c08` (Seitenzweig) / super `7a26b754`. Ist-Stand: super `b35aea1b`, ce/development `b5e0e4e7`; das L1-Buendel ist gelandet. Ich habe jeden Posten an der echten Landelinie neu geprueft. Drei Korrekturen, die den Auftrag verschieben: **K-01 ist widerlegt** (Ledger 4286 ff.; `experiment_plan_director.hpp:952-955` reicht `COMDARE_BESTANDSLOG` in das erzeugte YAML durch), und **Codex-Prioritaeten 1, 2 und 4 sind bereits gebaut** -- sie zu planen waere Beschaeftigung gewesen.

---

## PUNKT 1 -- Wuerde die Pipeline gruen?

**Die Frage ist heute falsch gestellt, und das ist der wichtigste Befund.** Der dominierende Blocker ist nicht Roetung, sondern dass die Pipeline die fragliche Arbeit **gar nicht anfasst**: `super/.gitlab-ci.yml:242-255` triggert ce fest auf `branch: main` (Z. 255/273/291). ce/main = `c837d830`, **48 Commits hinter** development. Ein gruener Lauf von heute frueh war ein gruener Lauf ueber Code, den niemand mehr faehrt -- ein Haken ohne Pruefbereich.

Belegt mit zwei Exitcodes, selbst ausgefuehrt: `ci_yaml_key_guard.sh` gegen ce/main-YAML = **EXIT 1** (`contract:axis-version-lock` doppelt, Z. 343 verworfen / Z. 502 gewinnt), gegen ce/development-YAML = **EXIT 0**. Der Heuristik-Tripwire ist auf development geheilt und auf dem getriggerten Branch weiter tot.

Was rot wuerde, getrennt:
- **Code:** nichts bekannt Rotes -- aber auch **nichts Gemessenes**. Kein Voll-Lauf ueber `b5e0e4e7`.
- **Nenner-Ehrlichkeit:** Ich habe die Abdeckungs-Wache real laufen lassen: `BILANZ: 406 von 406 ... EXIT=0`, Partition 404+2. **Aber der Bau-Baum gehoert zu Quellstand `3133f226`, nicht zur Landelinie.** Die 406 gilt fuer `3133f226`; die aus den Berichten zitierte 409 habe ich nicht nachgemessen und uebernehme sie nicht.
- **Infra (der einzige harte Posten):** `xmllint` auf den Runnern unbelegt -- der Code sagt das selbst verbatim ("ist damit NICHT belegt, sondern eine Annahme"). Praezisiert und dadurch entschaerft: die 5 Tests laufen per `add_test(COMMAND ${CMAKE_COMMAND} -P ...)` im Skript-Modus, der `FATAL_ERROR` faellt zur **Testlaufzeit** -- 5 Tests rot, **kein** Bauabbruch.
- **Prozess:** die super-Submodul-Arbeitskopie ist **dreckig (13 Dateien, +98/-92)**. Aus diesem Zustand darf kein Bump entstehen.
- Kein Blocker: arm64-smoke und measure/persist sind opt-in; pmc braucht Lanes, die im Normallauf nicht instanziiert werden.

---

## PUNKT 2(i) -- Tests, die VOR dem ersten Voll-Lauf existieren muessen

Kriterium streng angelegt: ohne diesen Test beweist ein gruener Lauf nichts. **Nur drei Posten erfuellen es.**

**T-i-3 -- Abdeckungs-Wache an der Landelinie nachmessen** (kein neuer Test, eine fehlende Messung). Beweist den Nenner. Solange 406/406 zu `3133f226` gehoert, ist die Abdeckung fuer `b5e0e4e7` unbelegt und alle T2-A-/B14-Tests koennten ungedeckt sein. ~30-60 min, kein Schreibvorgang. **Erster Posten des ganzen Plans.**

**T-i-1 -- Bissbeweis fuer die XXE-/Entity-Sperre.** Der schwerste Einzelbefund: die B14-NB5-Sperre ist **gelandet, ohne dass ein Test sie festhaelt**. Mit Nenner: `DOCTYPE|ENTITY|xxe|XXE` ueber `tests/` auf ce/development = **0 Dateien**; im super **kein** `add_test` dafuer und **keine** `bissbeweis`-Datei. Ein gruener Lauf ist heute mit und ohne wirksame Sperre identisch gruen. Doppelprobe (Angriff mit externer Entity ROT, harmlose Datei ohne DOCTYPE GRUEN), ~1-2 h; faltet Codex' `test_config_durability.cpp:105-122`-Posten mit ein.

**T-i-2 -- Mutationsprobe fuer `contract:axis-version-lock`.** Die Doppel-Definition ist geheilt, aber dass die ueberlebende Definition **beisst**, ist ungeprueft -- und ein gruener Job ist bis dahin von einem inerten nicht zu unterscheiden. Genau diese Ununterscheidbarkeit war der Urschaden (drei Wochen aus, zwei reale Drifts durchgelassen). ~1-3 h.

---

## PUNKT 4 -- Fahrplan zum gruenen Lauf

**Schritt 0:** Die 13 dreckigen Submodul-Dateien aufloesen (landen oder auf `rescue/` parken). Kein Fortschritt davor.
**Schritt 1:** T-i-3 -- Nenner holen.
**Schritt 2:** ce FF `development` -> `main` (48/0, sauber). **Dieser Schritt allein aendert mehr an der Aussagekraft der Pipeline als jeder neue Test.**
**Schritt 3:** super Submodul-Bump `7969b399` -> neuer ce/main-Kopf, als eigener Commit; der `changes:`-Block feuert den Trigger selbst.
**Schritt 4:** Erster echter Lauf, bewusst auf super/`development`, damit Rot `main` nicht verschmutzt. Job-Reihenfolge: `lint:secrets` -> **ce `test:coverage-guard`** (enthaelt die Schluessel-Wache, kein Voll-Bau noetig -- wertvollster erster Job) -> `verify:submodules` -> ce `contract:*` -> ce `test:unit` -> super `test:unit` (hier faellt `xmllint`, falls) -> Sanitizer -> `thesis:pdf`.
**Schritt 5:** super FF -> `main`, erst nach Gruen.

**Realistisch bis Do 07.08.:** Schritte 0-4 (Landung ist Mechanik, kein Bau), T-i-3, T-i-1, T-i-2, sowie T-ii-1 sofern O-A frueh entschieden ist.
**Wahrscheinlich, nicht sicher:** Fingerprint-Kreuzprobe; voll gruener Lauf beider Repos inkl. Sanitizer (`sanitize:tsan` ist die lange Stange, ein Cold-Cache-ICE kostet einen Umlauf).
**NICHT realistisch, klar gesagt:** Neuvalidierung von Messergebnissen nach einem PMC-Fix (das Flag ist eine Zeile, die 131.072-Zellen-Matrix ist ein mehrtaegiger Lauf -- also faellt die Entscheidung ueber die Messung **mit** O-A, nicht danach); `xmllint` selbst installieren (Cluster read-only); alles aus (iii).

**Falls die Zeit knapper wird:** Schritte 0-4 schlagen jeden neuen Test. Ein gruener Lauf ueber den **richtigen** Code ohne die drei neuen Wachen ist mehr wert als drei neue Wachen ueber Code, den der Trigger nicht anfasst.

**Zwei Entscheide blockieren heute Abend alles:** O-G (FF `development` -> `main` in beiden Repos freigegeben?) und O-H (die 13 dreckigen Dateien: landen oder parken?). Schwerster inhaltlicher Entscheid ist O-A: PMC-Flag fixen und neu messen, oder ohne Zaehler messen und die Grenze in der Arbeit benennen -- an `experiment_plan_director.hpp` (0 Treffer `COMDARE_ENABLE_PMC`, Emission Z. 841/877/1194/1342, `allow_failure: true` Z. 1333) haengt, ob die Voll-Matrix Cache-Zaehler misst oder Nullen.
STATUS LT. QUELLE: offen (Stand 06.08.; Plan-Datei war UNTRACKED -- Verlust-Risiko)
ABHAENGIGKEIT/FLAECHE: O-A/O-G/O-H


## QUELLE wq3sh10mx.json -- EXPLORE Task #4: S-3 (Fr 14.08.) + S-7 (Sa 15.08.) AKTIVIEREN (super f8cff2c8 / ce 7d65eb6c). QUERVERWEIS: wtk6lmhln T-04b/nicht_pruefbar[6] meldete dieses Explore-Artefakt als 'nirgends auf Platte auffindbar' -- ES LIEGT HIER (regressions-gesamtbild/wq3sh10mx.json); der T-04b-Restzweifel ist damit materiell aufloesbar. Nenner: 17 Festlegungen, 13 Objekt-Befunde, 7 offene Punkte/Abgrenzungen, 13 Gegenproben, Bau-Anweisung Tag1+Tag2.

### [wq3sh10mx.json] 001
GEGENSTAND: QUERVERWEIS-AUFLOESUNG: Explore-Artefakt wq3sh10mx existiert (diese Datei) -- der wtk6lmhln-Befund 'einzige Fundstelle: der Task-Text selbst' ist durch die Bereitstellung im regressions-gesamtbild-Batch ueberholt; Persistenz ausserhalb Job-tmp weiterhin pruefen
ORT: regressions-gesamtbild/wq3sh10mx.json
SOLL/FIX: Designer: T-04b-Zweifel gegen diesen Inhalt schliessen; Artefakt dauerhaft ablegen (BU-SOFORT)
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: wtk6lmhln T-04b

### [wq3sh10mx.json] 002
GEGENSTAND: FESTLEGUNG[0] (OWNER-WORT): "Das kommt darauf an, ob das Flag auf der freigebenden Seite oder der compile time Seite steht. Im Falle der Freigabe impliziert es das Vorhandensein und im Falle der compile Seite
ORT: Roh-Transkript 5a19728e-f6e1-4736-a246-e3fda9ac35a1.jsonl (8 Treffer, wortgleich) = Ledger KON16-02 (:4442)
SOLL/FIX: "Das kommt darauf an, ob das Flag auf der freigebenden Seite oder der compile time Seite steht. Im Falle der Freigabe impliziert es das Vorhandensein und im Falle der compile Seite Fordert das Flag das Vorhandensein von Hardware ein. Im Falle von DREIPHASIG fordert die Messachse der CEB ausserdem die Einhaltung des Vertrages mit den Messfuehlern." -- Ledger-Zitat 1:1 treu.
STATUS LT. QUELLE: nur-hinweis (Festlegung/Owner-Wort bzw. verifizierte Behauptung)
ABHAENGIGKEIT/FLAECHE: OWNER-WORT

### [wq3sh10mx.json] 003
GEGENSTAND: FESTLEGUNG[1] (OWNER-WORT): Die Ordnung gilt (x512{f.vl} SUBSET x512{f.vl.bw}); ihr Gegenstand ist der GESAMTE Hardware-Satz, den ein Rechner fahren kann; Organ-Achse KANN nutzen, MUSS nicht alles; Folge: jed
ORT: Ledger KON9-05 (:5734)
SOLL/FIX: Die Ordnung gilt (x512{f.vl} SUBSET x512{f.vl.bw}); ihr Gegenstand ist der GESAMTE Hardware-Satz, den ein Rechner fahren kann; Organ-Achse KANN nutzen, MUSS nicht alles; Folge: jeder Achsen-Algorithmus traegt einen Hardware-Spezifikations-Stempel X.Y.Z in VOLLER System-Achsen-Syntax UND Semantik. Das ist der S-7-Bauauftrag; die Semantik (Ordnung) fehlt heute -- 0 Treffer teilmenge/dominiert.
STATUS LT. QUELLE: nur-hinweis (Festlegung/Owner-Wort bzw. verifizierte Behauptung)
ABHAENGIGKEIT/FLAECHE: OWNER-WORT

### [wq3sh10mx.json] 004
GEGENSTAND: FESTLEGUNG[2] (OWNER-WORT): Zweistufige Versionierung: Varianten unterscheiden sich => Achsen-INTERFACE-Versionen; deren Algorithmen => ALGORITHMUS-Versionen. Reihenfolge: ZUERST golden, dann Homes. S-7 aktiv
ORT: Ledger KON27-01 (:3049)
SOLL/FIX: Zweistufige Versionierung: Varianten unterscheiden sich => Achsen-INTERFACE-Versionen; deren Algorithmen => ALGORITHMUS-Versionen. Reihenfolge: ZUERST golden, dann Homes. S-7 aktiviert NUR die Algorithmus-Ebene (algo_version-Literale); die Interface-Ebene ist S-18 nach golden -- interface_version hat heute 0 Code-Treffer.
STATUS LT. QUELLE: nur-hinweis (Festlegung/Owner-Wort bzw. verifizierte Behauptung)
ABHAENGIGKEIT/FLAECHE: OWNER-WORT

### [wq3sh10mx.json] 005
GEGENSTAND: FESTLEGUNG[3] (OWNER-WORT): Owner 12.08. abends: "weiter mit dem hauptstrang und konsolidiertem Wellenplan" -- und die dokumentierte Landesequenz endet mit "S-3-Aktivierung (Fr) -- Strecke unveraendert". Die Fr
ORT: Ledger KON57 + KON57-05 (:19-115)
SOLL/FIX: Owner 12.08. abends: "weiter mit dem hauptstrang und konsolidiertem Wellenplan" -- und die dokumentierte Landesequenz endet mit "S-3-Aktivierung (Fr) -- Strecke unveraendert". Die Fr/Sa-Strecke ist damit owner-gedeckt; kein weiterer Entscheid noetig.
STATUS LT. QUELLE: nur-hinweis (Festlegung/Owner-Wort bzw. verifizierte Behauptung)
ABHAENGIGKEIT/FLAECHE: OWNER-WORT

### [wq3sh10mx.json] 006
GEGENSTAND: FESTLEGUNG[4] (OWNER-WORT): clang UND gcc ueberall Basis-Pflicht (CI und lokal), weil der Compiler eine System-Achse belegen wird; Kombibau-Matrix gcc+clang x Debug+Release je J-1..J-4 + ctest ist das gefahre
ORT: Ledger KON55-01 (:214) + KON57-03
SOLL/FIX: clang UND gcc ueberall Basis-Pflicht (CI und lokal), weil der Compiler eine System-Achse belegen wird; Kombibau-Matrix gcc+clang x Debug+Release je J-1..J-4 + ctest ist das gefahrene Protokoll (KON57-03: 4x 485/485).
STATUS LT. QUELLE: nur-hinweis (Festlegung/Owner-Wort bzw. verifizierte Behauptung)
ABHAENGIGKEIT/FLAECHE: OWNER-WORT

### [wq3sh10mx.json] 007
GEGENSTAND: FESTLEGUNG[5] (AGENT-BEHAUPTUNG): Beide Seiten gebaut und inert/leer: Zielbild set_active_machine_declaration/active_machine_signature simd_build_gate.hpp:234-247/:324-329 mit 0 Produktions-Aufrufern (bestaetigt: n
ORT: Ledger KON23-02 (:3591) -- am Objekt Punkt fuer Punkt NACHGEPRUEFT
SOLL/FIX: Beide Seiten gebaut und inert/leer: Zielbild set_active_machine_declaration/active_machine_signature simd_build_gate.hpp:234-247/:324-329 mit 0 Produktions-Aufrufern (bestaetigt: nur tests/unit/test_c3a_gate_scharfschaltung.cpp + test_o4_machine_identity.cpp); Fallback system_axis_host_supports_simd per __builtin_cpu_supports (profile_run_entry.hpp:319-342); 9 Organ-Klassen required AUSNAHMSLOS LEER, static_assert :88; 23er-Katalog static_assert :155. S-3/S-7 sind Aktivierungs-, keine Neubau-Auftraege.
STATUS LT. QUELLE: nur-hinweis (Festlegung/Owner-Wort bzw. verifizierte Behauptung)
ABHAENGIGKEIT/FLAECHE: AGENT-BEHAUPTUNG

### [wq3sh10mx.json] 008
GEGENSTAND: FESTLEGUNG[6] (AGENT-BEHAUPTUNG): S-3 = Ordnungs-Relation ueber Flag-Mengen (SUBSET) als constexpr + Voraussetzungs-Wache, Vorbild bvset_teilmenge.hpp; transitiv preimage-wirksam (S-5 haengt an S-3), Regel 3: S-1,S
ORT: Wellenplan par.14.2/par.15.4 (20260808-WELLENPLAN-ENDFASSUNG-v2:1578,1869) + par.16 (20260812-WELLENKONSOLIDIERUNG:180-233)
SOLL/FIX: S-3 = Ordnungs-Relation ueber Flag-Mengen (SUBSET) als constexpr + Voraussetzungs-Wache, Vorbild bvset_teilmenge.hpp; transitiv preimage-wirksam (S-5 haengt an S-3), Regel 3: S-1,S-2,S-3,S-5,S-6,S-7 vor F2. par.16 Posten 15/16: erst S-3 (braucht S-1, GELANDET in ce 7d65eb6c), dann S-7; kritischer Pfad S-1 -> #4 Fr-Sa -> S-5.
STATUS LT. QUELLE: nur-hinweis (Festlegung/Owner-Wort bzw. verifizierte Behauptung)
ABHAENGIGKEIT/FLAECHE: AGENT-BEHAUPTUNG

### [wq3sh10mx.json] 009
GEGENSTAND: FESTLEGUNG[7] (AGENT-BEHAUPTUNG): KORREKTUR: "Versionszeile" hat 0 Ledger-Treffer -- Lead-Paraphrase. KON9-05 verlangt, dass jeder Algorithmus den Stempel UNTERSTUETZT (Syntax+Semantik), nicht dass am Aktivierungs-T
ORT: Lead-Memo Task #4 ("jeder Algorithmus bekommt eine neue Versionszeile")
SOLL/FIX: KORREKTUR: "Versionszeile" hat 0 Ledger-Treffer -- Lead-Paraphrase. KON9-05 verlangt, dass jeder Algorithmus den Stempel UNTERSTUETZT (Syntax+Semantik), nicht dass am Aktivierungs-Tag Literale gebumpt werden. Alle 123 Literale bleiben unveraendert (97x 1.0.0.c, 24x 1.0.2.c, 2x 1.0.1.c); ein Flag-Zuwachs je Algorithmus ist ein SPAETERES Ereignis, wenn ein Algo real SIMD deklariert.
STATUS LT. QUELLE: nur-hinweis (Festlegung/Owner-Wort bzw. verifizierte Behauptung)
ABHAENGIGKEIT/FLAECHE: AGENT-BEHAUPTUNG

### [wq3sh10mx.json] 010
GEGENSTAND: FESTLEGUNG[8] (OBJEKT-BEFUND): Die "Andockstelle seit 07.08. bei :73" IST algo_semver.hpp:73 -- dort steht woertlich "Der Grep-Anker der Naht bleibt S2-KATALOG-ANDOCKSTELLE" (Sektion :814-951 mit for_each_flag_no
ORT: algo_semver.hpp:73 + OWNER-VORLAGE 11.08. (:105) + Wellenplan S-3-Zeile
SOLL/FIX: Die "Andockstelle seit 07.08. bei :73" IST algo_semver.hpp:73 -- dort steht woertlich "Der Grep-Anker der Naht bleibt S2-KATALOG-ANDOCKSTELLE" (Sektion :814-951 mit for_each_flag_node als Traversal-Primitive). simd_organ_requirement.hpp:73 ((void)value;) ist ein Zufalls-:73, nicht die dokumentierte Stelle.
STATUS LT. QUELLE: nur-hinweis (Festlegung/Owner-Wort bzw. verifizierte Behauptung)
ABHAENGIGKEIT/FLAECHE: OBJEKT-BEFUND

### [wq3sh10mx.json] 011
GEGENSTAND: FESTLEGUNG[9] (OBJEKT-BEFUND): Die O-3-Frage steht heute bei :1538-1539 (Wellenplan nannte :1527-1528 -- Datei gewachsen): "fordert das Flag die Voraussetzung, oder impliziert es sie?" mit den Ketten aes->vaes, p
ORT: algo_semver.hpp:1529-1544 (m8)
SOLL/FIX: Die O-3-Frage steht heute bei :1538-1539 (Wellenplan nannte :1527-1528 -- Datei gewachsen): "fordert das Flag die Voraussetzung, oder impliziert es sie?" mit den Ketten aes->vaes, pclmulqdq->vpclmulqdq, avx512f->alles. Genau EINE Assert-Stelle dokumentiert das Nicht-Pruefen (:1544 x512{vl} ohne f geht durch) -- die T-1-Saat.
STATUS LT. QUELLE: nur-hinweis (Festlegung/Owner-Wort bzw. verifizierte Behauptung)
ABHAENGIGKEIT/FLAECHE: OBJEKT-BEFUND

### [wq3sh10mx.json] 012
GEGENSTAND: FESTLEGUNG[10] (OBJEKT-BEFUND): Die SUBSET-Mechanik existiert NUR ueber bvset-Signatur-STRINGS (3 Achsen-Sektionen, byte-genau je Element, AUSDRUECKLICH ASYMMETRISCH, fail-closed, Kopf-Byte-Gleichheit als Vorbedi
ORT: bvset_teilmenge.hpp (187 Z., builder/)
SOLL/FIX: Die SUBSET-Mechanik existiert NUR ueber bvset-Signatur-STRINGS (3 Achsen-Sektionen, byte-genau je Element, AUSDRUECKLICH ASYMMETRISCH, fail-closed, Kopf-Byte-Gleichheit als Vorbedingung) -- KEINE Ordnung ueber Grammatik-Flag-Mengen (AlgoSemVer/FlagList). Sie ist VORBILD (Asymmetrie-/fail-closed-Doktrin :146-165), nicht Bestand fuer S-3.
STATUS LT. QUELLE: nur-hinweis (Festlegung/Owner-Wort bzw. verifizierte Behauptung)
ABHAENGIGKEIT/FLAECHE: OBJEKT-BEFUND

### [wq3sh10mx.json] 013
GEGENSTAND: FESTLEGUNG[11] (OBJEKT-BEFUND): Scheinwiderspruch aufgeloest: der ORCHESTRATOR-Weg (per-Binary, build_orchestrator/build_orchestrator.hpp:759-771 -- KON23-02 nannte :458-459, Datei umgezogen/gewachsen) ist fertig 
ORT: simd_organ_requirement.hpp:5-8 GEGEN simd_build_gate.hpp:272-278 (C-3a-TRIPWIRE)
SOLL/FIX: Scheinwiderspruch aufgeloest: der ORCHESTRATOR-Weg (per-Binary, build_orchestrator/build_orchestrator.hpp:759-771 -- KON23-02 nannte :458-459, Datei umgezogen/gewachsen) ist fertig verdrahtet (aggregate_required_for_axes -> admit_organ_on_machine -> D1 + weiter); der GLOBALE Fassaden-Hook active_organ_required() ist eine UNION und per Tripwire compile-hart gesperrt: die erste echte required-Deklaration braucht einen eigenen Owner-Paket-Entscheid. #4 fuellt KEINE required-Mengen -- der Konflikt wird nicht beruehrt.
STATUS LT. QUELLE: nur-hinweis (Festlegung/Owner-Wort bzw. verifizierte Behauptung)
ABHAENGIGKEIT/FLAECHE: OBJEKT-BEFUND

### [wq3sh10mx.json] 014
GEGENSTAND: FESTLEGUNG[12] (OBJEKT-BEFUND): Die komplette Freigabe-Kette existiert: <machines><machine cpu_fabrication ram_pair hostname_hint> wird geparst (ep.machines) und validiert (Kern-Schluessel Pflicht); kDeclaredMach
ORT: xml_config_parser.hpp:380-403/.cpp:576 + validate_profile.hpp:1150-1159 + machine_identity.hpp:210-299 + experiment_golden_kern.xml:26-29
SOLL/FIX: Die komplette Freigabe-Kette existiert: <machines><machine cpu_fabrication ram_pair hostname_hint> wird geparst (ep.machines) und validiert (Kern-Schluessel Pflicht); kDeclaredMachines (prod1 amd_zen5_avx512 / prod2 intel_avx2, je mit CT-Signatur + Kern-Kennung fuer Drift-Gegenprobe); live_hostname() als NUR-Lookup-Schluessel; golden-XML deklariert beide Maschinen. ES FEHLT GENAU EIN AUFRUF: niemand konsumiert ep.machines in Richtung set_active_machine_declaration (profile_run_entry.hpp:314-318 benennt es selbst: "heute der Normalfall, weil die CEB ... noch nicht ruft"). Sobald belegt, gewinnt die Deklaration, der Host-CPUID-Fallback verschwindet von selbst (:330-334).
STATUS LT. QUELLE: nur-hinweis (Festlegung/Owner-Wort bzw. verifizierte Behauptung)
ABHAENGIGKEIT/FLAECHE: OBJEKT-BEFUND

### [wq3sh10mx.json] 015
GEGENSTAND: FESTLEGUNG[13] (OBJEKT-BEFUND): Die deklarierten Signaturen sind VORAUSSETZUNGS-VOLLSTAENDIG (prod1 traegt avx512f UND alle 13 Subsets explizit; static_assert-Batterie :111-128) -- die KON16-02-Implikation der Fre
ORT: machine_simd_signature.hpp:75-128
SOLL/FIX: Die deklarierten Signaturen sind VORAUSSETZUNGS-VOLLSTAENDIG (prod1 traegt avx512f UND alle 13 Subsets explizit; static_assert-Batterie :111-128) -- die KON16-02-Implikation der Freigabe-Seite ist bei Aktivierung byte-neutral und wird als Geschlossenheits-WACHE festgeschrieben, nicht als stille Expansion (ein still ergaenztes Flag waere eine Identitaet, die niemand geschrieben hat -- bvset-Doktrin).
STATUS LT. QUELLE: nur-hinweis (Festlegung/Owner-Wort bzw. verifizierte Behauptung)
ABHAENGIGKEIT/FLAECHE: OBJEKT-BEFUND

### [wq3sh10mx.json] 016
GEGENSTAND: FESTLEGUNG[14] (OBJEKT-BEFUND): O-4 ("gegen welche Menge laeuft die Teilmengen-Pruefung -- ohne sie ist S-3 nicht schneidbar") ist durch das NEUERE KON26-01 beantwortet: SIMD ist DIE System-Meta-Meta (gebaut), PMC
ORT: Ledger KON18-02 (:4267) GEGEN Konsolidierung IV (:2057) / KON26-01
SOLL/FIX: O-4 ("gegen welche Menge laeuft die Teilmengen-Pruefung -- ohne sie ist S-3 nicht schneidbar") ist durch das NEUERE KON26-01 beantwortet: SIMD ist DIE System-Meta-Meta (gebaut), PMC die Mess-Meta-Meta, die IO-Substanz zwei regulaere Organ-Hauptachsen. Die Pruefmenge ist die SIMD-Signatur der deklarierten Maschine. S-3 ist schneidbar. (OWNER-VORLAGE-Empfehlung "FORDERN, nicht implizieren" ist durch das neuere KON16-02 ueberholt: beides, je Seite.)
STATUS LT. QUELLE: nur-hinweis (Festlegung/Owner-Wort bzw. verifizierte Behauptung)
ABHAENGIGKEIT/FLAECHE: OBJEKT-BEFUND

### [wq3sh10mx.json] 017
GEGENSTAND: FESTLEGUNG[15] (OBJEKT-BEFUND): PREIMAGE-URTEIL: Overlay-Glied [7] hasht QUELLTEXT der Organ-Verzeichnisse (axes/, topics/...) + praefixierte measurement-Dateien (target_isa*, operating_system*, external_utils*, 
ORT: overlay_source_set.hpp:127-200 (52 Eintraege: 36 organ / 10 system / 3 mess / 3 tier_substanz)
SOLL/FIX: PREIMAGE-URTEIL: Overlay-Glied [7] hasht QUELLTEXT der Organ-Verzeichnisse (axes/, topics/...) + praefixierte measurement-Dateien (target_isa*, operating_system*, external_utils*, compiler_*, simd_sub_axis*, optimization_level_sub_axis*, measurement_tooling*, scheduling_system_axis*, extension_hardware*) + anatomy/. algo_semver.hpp, flag_grammar_catalog.hpp, simd_build_gate.hpp, simd_organ_requirement.hpp, simd_feature_flag.hpp, machine_identity.hpp, machine_simd_signature.hpp und profile_facade/ sind NICHT im Satz. Folge: die GESAMTE #4-Aktivierung ist SHA-/fingerprint-neutral, SOLANGE keine axes/-, topics/- oder heuristik/-Datei beruehrt wird (heuristik zusaetzlich unter C-4-SHA-256-Lock). Golden 131072/320 unberuehrt (Signatur -> CompileFn/H-10-Sidecar, NIE binary_id; simd_build_gate.hpp:22-23).
STATUS LT. QUELLE: nur-hinweis (Festlegung/Owner-Wort bzw. verifizierte Behauptung)
ABHAENGIGKEIT/FLAECHE: OBJEKT-BEFUND

### [wq3sh10mx.json] 018
GEGENSTAND: FESTLEGUNG[16] (OBJEKT-BEFUND): Die Voraussetzungs-KETTEN existieren NUR als Prosa in der 6-Lens-Recherche (vaes-Eintrag: "Setzt aes voraus, das im Ist-Katalog FEHLT -- die Voraussetzungskette aes->vaes ist damit 
ORT: SIMD-KATALOG-vollstaendig-32-und-64-bit-6-lenses.json (docs/sessions/backups/20260807-explores-und-simd-katalog/)
SOLL/FIX: Die Voraussetzungs-KETTEN existieren NUR als Prosa in der 6-Lens-Recherche (vaes-Eintrag: "Setzt aes voraus, das im Ist-Katalog FEHLT -- die Voraussetzungskette aes->vaes ist damit heute nicht abbildbar") und in Katalog-/algo_semver-Kommentaren (flag_grammar_catalog.hpp:244 alle x512 auf avx512f gegated; :86-92 MMX/3DNow AUSDRUECKLICH OHNE formale CPUID-Abhaengigkeit). Nirgends als DATEN. Die Ketten-Tabelle ist der eine echte Neubau-Baustein von S-3 -- Quelle ist die Recherche, nie geraten. Live-Gegenprobe prod1 (= lokale Maschine): /proc/cpuinfo traegt aes UND pclmulqdq -- der 23er-Signatur-Katalog fuehrt beide NICHT (nur kVaes/kVpclmulqdq).
STATUS LT. QUELLE: nur-hinweis (Festlegung/Owner-Wort bzw. verifizierte Behauptung)
ABHAENGIGKEIT/FLAECHE: OBJEKT-BEFUND

### [wq3sh10mx.json] 019
GEGENSTAND: OBJEKT-IST[0]: simd_build_gate.hpp (427 Z.) -- Zielbild-Seite
ORT: simd_build_gate.hpp (427 Z.) -- Zielbild-Seite
SOLL/FIX: BEFUND: pruef_dock :108-153 (Ungeprueft->{NotApplicable|Freigegeben|Abgelehnt}, leeres required => inert); admit_organ_on_machine :159-165; Einmal-Belegung set_active_machine_declaration :234-247 (Latch, abweichender Zweit-Aufruf ABGELEHNT), reset NUR fuer Tests :250-256; Hook 1 active_organ_required :263 = {} mit C-3a-TRIPWIRE :272-278 (Owner-Paket-Entscheid vor erster required-Deklaration); Hook 3 active_machine_signature :324-329 (nur bei Verdict Match, sonst LEER); NOT-AUS COMDARE_SIMD_GATE_ARMED :200-203; par.70.9-Identitaets-Beitrag gate_contribution :385-408 (leer = wahre Aussage, dreifach eingehaengt seit dbdd2f9b8) || KOMMANDO: sed -n '187,278p;319,345p' /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/measurement/simd_build_gate.hpp
STATUS LT. QUELLE: nur-hinweis (IST-Kartierung am Objekt)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 020
GEGENSTAND: OBJEKT-IST[1]: simd_build_gate.hpp -- Fallback-Seite (heute aktiv)
ORT: simd_build_gate.hpp -- Fallback-Seite (heute aktiv)
SOLL/FIX: BEFUND: system_axis_host_supports_simd lebt in profile_facade/profile_run_entry.hpp:319-342: fragt ZUERST active_machine_signature() (deklarierte KLASSE, C-3c), faellt NUR ohne Belegung auf __builtin_cpu_supports zurueck (:335-340). Kommentar :314-318 benennt den fehlenden CEB-Aufruf woertlich. Konsument: experiment_plan_director.hpp:2339 als PlanPerm-ANNOTATION (kein Filter) || KOMMANDO: sed -n '300,342p' /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/profile_facade/profile_run_entry.hpp
STATUS LT. QUELLE: nur-hinweis (IST-Kartierung am Objekt)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 021
GEGENSTAND: OBJEKT-IST[2]: simd_organ_requirement.hpp (93 Z.) -- Compile-Time-Seite
ORT: simd_organ_requirement.hpp (93 Z.) -- Compile-Time-Seite
SOLL/FIX: BEFUND: 9 Organ-Klassen (filter, search_algo, memory_layout, mapping, index_organization, value_handle, cache_traversal, scoring, prefetch) ALLE kRequiredNone (:40-50); static_assert(!any_organ_declares_required()) :88; aggregate_required_for_axes :69-85 (per-Binary-Vereinigung, heute stets leer); Kopftext :5-8: erste echte Deklaration aktiviert die Kopplung "OHNE weiteren Umbau" -- gilt fuer den ORCHESTRATOR-Weg, nicht den Fassaden-UNION-Hook (Tripwire) || KOMMANDO: cat /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/measurement/simd_organ_requirement.hpp
STATUS LT. QUELLE: nur-hinweis (IST-Kartierung am Objekt)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 022
GEGENSTAND: OBJEKT-IST[3]: Orchestrator-Gate-Block (per-Binary, FERTIG verdrahtet)
ORT: Orchestrator-Gate-Block (per-Binary, FERTIG verdrahtet)
SOLL/FIX: BEFUND: builder/build_orchestrator/build_orchestrator.hpp:759-771: aggregate_required_for_axes(spec.axes) -> wenn nicht leer: admit_organ_on_machine(gate_req, active_machine_signature()) -> bei Verletzung status=-4, D1 HardwareErweiterungFehlt, Log + weiter (kein Abbruch). KON23-02s ":458-459" ist Zeilen-Drift nach Umzug in den Unterordner || KOMMANDO: sed -n '753,772p' /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp
STATUS LT. QUELLE: nur-hinweis (IST-Kartierung am Objekt)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 023
GEGENSTAND: OBJEKT-IST[4]: bvset_teilmenge.hpp (187 Z.) -- das S-3-Vorbild
ORT: bvset_teilmenge.hpp (187 Z.) -- das S-3-Vorbild
SOLL/FIX: BEFUND: SUBSET nur ueber bvset-Signatur-Strings (bvset=<v>;bv=<v>;page_type[..]simd_extension[..]general_hardware[..]): Parser fail-closed (:115-144, kein Rest-Byte), bvset_ist_teilmenge :165-185 (Kopf byte-gleich als Vorbedingung, je Element byte-genau, AUSDRUECKLICH NICHT SYMMETRISCH). KEINE Funktion nimmt AlgoSemVer/FlagList -- die Grammatik-Mengen-Ordnung existiert nicht (deckt KON9-05-Nullbefund) || KOMMANDO: sed -n '146,185p' /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/builder/bvset_teilmenge.hpp
STATUS LT. QUELLE: nur-hinweis (IST-Kartierung am Objekt)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 024
GEGENSTAND: OBJEKT-IST[5]: algo_semver.hpp (1547 Z.) -- Grammatik v2 + Andockstelle + Wachen-Zielform
ORT: algo_semver.hpp (1547 Z.) -- Grammatik v2 + Andockstelle + Wachen-Zielform
SOLL/FIX: BEFUND: S2-KATALOG-ANDOCKSTELLE :73 (Anker) / Sektion :814-951; for_each_flag_node :904-911 (Token+Tiefe+ELTERN je Knoten -- die vorgeschriebene Traversal-Form fuer jede kuenftige Flag-Auswertung); flag_catalog_is_satisfied :934-941; ce_owned_version_is_wellformed :1003-1008 = DIE Zielform-Einhaengestelle (genutzt von Organ-Registry + allen Nicht-Organ-Registries, 12 Quellen-Klassen (a)-(l), P14-Riegel test_vs_taxonomie_klassen_grep, 139 Vorkommen); (m8) :1529-1544: Abhaengigkeiten AUSDRUECKLICH NICHT geprueft -- mit Ketten-Nennung und der O-3-Frage :1538-1539 || KOMMANDO: sed -n '814,951p;1003,1016p;1529,1544p' /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/measurement/algo_semver.hpp
STATUS LT. QUELLE: nur-hinweis (IST-Kartierung am Objekt)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 025
GEGENSTAND: OBJEKT-IST[6]: flag_grammar_catalog.hpp (755 Z.) -- 62+14, OHNE Ketten-Daten
ORT: flag_grammar_catalog.hpp (755 Z.) -- 62+14, OHNE Ketten-Daten
SOLL/FIX: BEFUND: FlagCatalogEntry :163-172 traegt token+cpuinfo+gpp+kind+eltern(+eltern_alternativ, entscheid_offen=0) -- KEIN Voraussetzungs-Feld; kFlagGrammarCatalog :176 (62), kFlagGrammarReserve :373 (14); flag_token_is_admitted_under :437; Token->cpuinfo-Bruecke fuer die Zulassung EXISTIERT als Tabellenfelder (Drei-Namensraeume-Doktrin). MMX-Negativbeleg :86-92: keine formale CPUID-Abhaengigkeit -- Kette dort NICHT erfinden || KOMMANDO: sed -n '163,200p' /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/measurement/flag_grammar_catalog.hpp
STATUS LT. QUELLE: nur-hinweis (IST-Kartierung am Objekt)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 026
GEGENSTAND: OBJEKT-IST[7]: algo_version-Literal-Bestand (S-7-Gegenstand)
ORT: algo_version-Literal-Bestand (S-7-Gegenstand)
SOLL/FIX: BEFUND: 124 Grep-Zeilen = 123 echte Literale (97x "1.0.0.c", 24x "1.0.2.c", 2x "1.0.1.c") + 1 Kommentar-Treffer (axes/alloc/axis_06_allocator_strategy_base.hpp:115, Mock-Beschreibung "1.0.0") -- deckt die Ledger-Zaehlung 123. ALLE nackt-c => jede neue Semantik-Wache ist auf dem Bestand vakuum-wahr. AXIS_ALGO_VERSION-Marker: NUR heuristik/ (6 Dateien, C-4-Lock), KEIN axes/-Vorkommen -- anderes Werkzeug (S-14), nicht S-7 || KOMMANDO: /usr/bin/grep -rhoE 'algo_version *= *"[^"]*"' --include='*.hpp' /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs | sort | uniq -c
STATUS LT. QUELLE: nur-hinweis (IST-Kartierung am Objekt)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 027
GEGENSTAND: OBJEKT-IST[8]: S-1-Fundament (GELANDET, ce 7d65eb6c)
ORT: S-1-Fundament (GELANDET, ce 7d65eb6c)
SOLL/FIX: BEFUND: abi/stempel_basis.hpp: CRTP-StempelVertrag, 7 Interfaces x 4 Traeger = 28 Zellen DREIWERTIG (:18-22, :129; ERLAUBT heute unbelegt :79), version_xyz NUR Planer, Basis LEER (KON7-08), deferred-consteval; zieht algo_semver.hpp fuer ce_owned_version_is_wellformed => die S-3-Wache erreicht den StempelVertrag OHNE neue Aufruf-Stelle. abi/stempel_baustein_trait.hpp: P1.4-Trait (Anbindung ohne Basisklassen-Einbau, Pins byte-unberuehrt) || KOMMANDO: sed -n '1,60p' /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/abi/stempel_basis.hpp
STATUS LT. QUELLE: nur-hinweis (IST-Kartierung am Objekt)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 028
GEGENSTAND: OBJEKT-IST[9]: Freigabe-Kette XML -> Deklaration (alles gebaut ausser EINEM Aufruf)
ORT: Freigabe-Kette XML -> Deklaration (alles gebaut ausser EINEM Aufruf)
SOLL/FIX: BEFUND: xml_config_parser.hpp:399-403 ExperimentMachine{id,cpu_fabrication,ram_pair,hostname_hint,ram_frequency_mhz}, .cpp:576 push_back; ExperimentProfile.machines :473; validate_profile.hpp:1150-1159 (Kern-Schluessel Pflicht, leer = keine Menge = heutiges Verhalten); machine_identity.hpp: kDeclaredMachines :265-269 (2 Zeilen, Tupel WOERTLICH aus golden-XML), resolve_machine_by_properties :274-279 (kein Treffer -> nullptr, KEIN Ersatz), live_hostname :291 (leer => "keine Maschine gewaehlt"), identify_machine + Drift-Gegenprobe gegen live_core_cpu_id; golden-XML tests/unit/thesis_tiere/experiment_golden_kern.xml:26-29 traegt prod1+prod2 || KOMMANDO: /usr/bin/grep -rn 'set_active_machine_declaration' --include='*.hpp' --include='*.cpp' /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/apps
STATUS LT. QUELLE: nur-hinweis (IST-Kartierung am Objekt)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 029
GEGENSTAND: OBJEKT-IST[10]: Byte-Neutralitaets-Beweis-Bestand (T-6-Schwester-Vorlage)
ORT: Byte-Neutralitaets-Beweis-Bestand (T-6-Schwester-Vorlage)
SOLL/FIX: BEFUND: tests/unit/test_c3a_gate_scharfschaltung.cpp: rsp_zeilen-Spiegel der Fassaden-Naht (:24-36), 3 Routen (kRouten), Kill-Switch-Beweis (ohne Belegung inert), Einmal-Belegungs-Semantik (Gesetzt/BereitsGesetztIdentisch/AbgelehntAbweichend :137-144); test_o4_machine_identity.cpp; test_m_simd_feature_flag_catalog.cpp (aggregate leer); test_s1_stempel_basis_vertrag.cpp. 25 Testdateien tragen "1.0.0.c"-Erwartungen (bleiben gruen, solange kein Literal bewegt wird) || KOMMANDO: sed -n '1,160p' /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/tests/unit/test_c3a_gate_scharfschaltung.cpp
STATUS LT. QUELLE: nur-hinweis (IST-Kartierung am Objekt)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 030
GEGENSTAND: OBJEKT-IST[11]: Preimage-/Golden-Pruefung
ORT: Preimage-/Golden-Pruefung
SOLL/FIX: BEFUND: Overlay-Glied [7] (builder/overlay_source_set.hpp, 52 Eintraege) hasht Organ-Quelltext + praefixierte System/Mess-Dateien -- KEINE der #4-Baustellen-Dateien im Satz; gate-Beitrag bleibt leer (organ_required leer, Tripwire steht); binary_id NIE (Registry never); golden==131072/320 neutral (simd_build_gate.hpp:22-23, machine_simd_signature.hpp:9). Gepinnte 128-Hex-Fingerprint-Literale in tests/libs: 0 (Positivkontrolle des Musters bestanden). EINZIGE In-Tree-Erwartung, die die neue Wache beruehrt: algo_semver.hpp:1542-1544 (m8-Dokumentations-Asserts -- bleiben wahr fuer flag_catalog_is_satisfied, bekommen die neue Negativ-Zeile fuer is_wellformed daneben) || KOMMANDO: /usr/bin/grep -o 'Kategorie::[a-z_]*' /home/comdare/wt-super-landung/Code/external/comdare-cache-engine/libs/cache_engine/builder/overlay_source_set.hpp | sort | uniq -c
STATUS LT. QUELLE: nur-hinweis (IST-Kartierung am Objekt)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 031
GEGENSTAND: OBJEKT-IST[12]: Ketten-Datenquelle (der eine Neubau-Baustein)
ORT: Ketten-Datenquelle (der eine Neubau-Baustein)
SOLL/FIX: BEFUND: 6-Lens-Recherche-JSON (108 Token) mit Ketten in bemerkung-Prosa: aes->vaes ("heute nicht abbildbar" auf Signatur-Seite, weil aes im 23er fehlt), pclmulqdq->vpclmulqdq, avx512f->alle x512-Subsets; MMX-Familie ausdruecklich OHNE CPUID-Kette. prod1-Live-Beleg: /proc/cpuinfo traegt aes UND pclmulqdq (additiver 23er-Zuwachs waere ehrlich belegbar, ist aber NICHT Pflicht fuer #4 -- Grammatik-seitige Kette genuegt, Signatur-Grenze wird dokumentiert) || KOMMANDO: jq -r '.. | objects | select(.token? == "vaes")' /home/comdare/wt-super-landung/docs/sessions/backups/20260807-explores-und-simd-katalog/SIMD-KATALOG-vollstaendig-32-und-64-bit-6-lenses.json
STATUS LT. QUELLE: nur-hinweis (IST-Kartierung am Objekt)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 032
GEGENSTAND: OFFENER PUNKT[0]: KEIN Owner-Entscheid fuer #4 noetig -- Erwartung des Leads bestaetigt: O-3 beantwortet (KON16-02, roh verifiziert), O-4 beantwortet (KON26-01: SIMD = System-Meta
ORT: unbekannt
SOLL/FIX: KEIN Owner-Entscheid fuer #4 noetig -- Erwartung des Leads bestaetigt: O-3 beantwortet (KON16-02, roh verifiziert), O-4 beantwortet (KON26-01: SIMD = System-Meta-Meta => Pruefmenge = SIMD-Signatur der deklarierten Maschine), Strecke owner-gedeckt (KON57 verbatim + KON57-05 "S-3-Aktivierung (Fr) -- Strecke unveraendert").
STATUS LT. QUELLE: nur-hinweis (Abgrenzung/Antwort)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 033
GEGENSTAND: OFFENER PUNKT[1]: ABGRENZUNG (kein #4-Gegenstand, kuenftiger Owner-Paket-Entscheid dokumentiert im Code): die ERSTE echte required-Deklaration eines Organs -- der C-3a-TRIPWIRE (s
ORT: unbekannt
SOLL/FIX: ABGRENZUNG (kein #4-Gegenstand, kuenftiger Owner-Paket-Entscheid dokumentiert im Code): die ERSTE echte required-Deklaration eines Organs -- der C-3a-TRIPWIRE (simd_build_gate.hpp:272-278) verlangt dafuer den eigenen Entscheid zum Fassaden-UNION-Kanal; der per-Binary-Orchesterweg ist bereit. #4 laesst alle 9 required-Mengen leer.
STATUS LT. QUELLE: nur-hinweis (Abgrenzung/Antwort)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 034
GEGENSTAND: OFFENER PUNKT[2]: ABGRENZUNG: "1.0.0.c" vs "1.0.0.c{p}" bleiben ZWEI Werte (Gleichsetzung waere ein Byte-Ereignis und ausdruecklich Owner-Entscheid-Klasse, algo_semver.hpp:61-63)
ORT: unbekannt
SOLL/FIX: ABGRENZUNG: "1.0.0.c" vs "1.0.0.c{p}" bleiben ZWEI Werte (Gleichsetzung waere ein Byte-Ereignis und ausdruecklich Owner-Entscheid-Klasse, algo_semver.hpp:61-63) -- die Ordnungs-Relation behandelt sie als verschiedene Mengen; im S-3-Header dokumentieren, nicht entscheiden.
STATUS LT. QUELLE: nur-hinweis (Abgrenzung/Antwort)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 035
GEGENSTAND: OFFENER PUNKT[3]: ABGRENZUNG: Messfuehler-Vertrag (dritter KON16-02-Gegenstand, dreiphasig) = Posten 8 der Bauliste (Naht am SearchAlgorithm-Dock, genau 1 Biss-Test) -- nicht #4.
ORT: unbekannt
SOLL/FIX: ABGRENZUNG: Messfuehler-Vertrag (dritter KON16-02-Gegenstand, dreiphasig) = Posten 8 der Bauliste (Naht am SearchAlgorithm-Dock, genau 1 Biss-Test) -- nicht #4.
STATUS LT. QUELLE: nur-hinweis (Abgrenzung/Antwort)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 036
GEGENSTAND: OFFENER PUNKT[4]: ABGRENZUNG: Interface-Versions-Ebene der zweistufigen Versionierung (KON27-01) = S-18/Homes NACH golden (interface_version heute 0 Treffer); S-7 aktiviert nur d
ORT: unbekannt
SOLL/FIX: ABGRENZUNG: Interface-Versions-Ebene der zweistufigen Versionierung (KON27-01) = S-18/Homes NACH golden (interface_version heute 0 Treffer); S-7 aktiviert nur die Algorithmus-Ebene.
STATUS LT. QUELLE: nur-hinweis (Abgrenzung/Antwort)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 037
GEGENSTAND: OFFENER PUNKT[5]: BAU-WEICHE (Bauer entscheidet am Objekt, ohne Owner): 23er-Signatur-Katalog additiv um kAes/kPclmulqdq erweitern (live auf prod1 belegt: /proc/cpuinfo traegt be
ORT: unbekannt
SOLL/FIX: BAU-WEICHE (Bauer entscheidet am Objekt, ohne Owner): 23er-Signatur-Katalog additiv um kAes/kPclmulqdq erweitern (live auf prod1 belegt: /proc/cpuinfo traegt beide) ODER die Signatur-Geschlossenheits-Wache mit benannter Werkzeug-Grenze (Ketten nur soweit der Signatur-Katalog die Voraussetzung fuehrt). Empfehlung: Grenze benennen an Tag 1, Zuwachs nur wenn ein Test ihn wirklich braucht -- jeder Zuwachs zieht die :155-size- und Signatur-Asserts im selben Commit nach.
STATUS LT. QUELLE: offen (Bau-Weiche, Bauer entscheidet am Objekt)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 038
GEGENSTAND: OFFENER PUNKT[6]: VORGEFUNDENE Doku-Drifts (beim Bau im Kommentar nachziehen, kein eigener Auftrag): KON23-02/C-3a nennt build_orchestrator.hpp:458-459 (heute builder/build_orche
ORT: unbekannt
SOLL/FIX: VORGEFUNDENE Doku-Drifts (beim Bau im Kommentar nachziehen, kein eigener Auftrag): KON23-02/C-3a nennt build_orchestrator.hpp:458-459 (heute builder/build_orchestrator/build_orchestrator.hpp:759-771); Wellenplan-O-3 nennt algo_semver.hpp:1527-1528 (heute :1538-1539); OWNER-VORLAGE-O-3-Empfehlung "FORDERN, nicht implizieren" ist durch KON16-02 (beides, je Seite) ueberholt.
STATUS LT. QUELLE: offen (Doku-Drift, beim Bau nachziehen)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 039
GEGENSTAND: GEGENPROBE[0]: Arbeitsbaum: super f8cff2c8 + ce-Gitlink 7d65eb6c == Arbeitskopie (git submodule status, Praefix-Leerzeichen = sauber) -- NUR dort gemessen.
ORT: unbekannt
SOLL/FIX: Arbeitsbaum: super f8cff2c8 + ce-Gitlink 7d65eb6c == Arbeitskopie (git submodule status, Praefix-Leerzeichen = sauber) -- NUR dort gemessen.
STATUS LT. QUELLE: nur-hinweis (Gegenprobe der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 040
GEGENSTAND: GEGENPROBE[1]: KON16-02-Rohwort: /usr/bin/grep -c 'impliziert es das Vorhandensein' => 8 Treffer in 5a19728e-*.jsonl, 0 in 46375cdc-*.jsonl; extrahierter Volltext wo
ORT: unbekannt
SOLL/FIX: KON16-02-Rohwort: /usr/bin/grep -c 'impliziert es das Vorhandensein' => 8 Treffer in 5a19728e-*.jsonl, 0 in 46375cdc-*.jsonl; extrahierter Volltext wortgleich zum Ledger-Zitat (Zitattreue bestanden).
STATUS LT. QUELLE: nur-hinweis (Gegenprobe der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 041
GEGENSTAND: GEGENPROBE[2]: 'Versionszeile' im Ledger: 0 Treffer (grep -n) => Lead-Formulierung ist Paraphrase, KON9-05-Wortlaut ist 'unterstuetzen muessen' -- S-7 ohne Literal-Bu
ORT: unbekannt
SOLL/FIX: 'Versionszeile' im Ledger: 0 Treffer (grep -n) => Lead-Formulierung ist Paraphrase, KON9-05-Wortlaut ist 'unterstuetzen muessen' -- S-7 ohne Literal-Bumps geplant.
STATUS LT. QUELLE: nur-hinweis (Gegenprobe der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 042
GEGENSTAND: GEGENPROBE[3]: algo_version-Literale: 124 Grep-Zeilen, davon 1 Kommentar (axis_06_allocator_strategy_base.hpp:115) => 123 echte (97/24/2) -- deckt Ledger-Zaehlung exa
ORT: unbekannt
SOLL/FIX: algo_version-Literale: 124 Grep-Zeilen, davon 1 Kommentar (axis_06_allocator_strategy_base.hpp:115) => 123 echte (97/24/2) -- deckt Ledger-Zaehlung exakt; das scheinbar flaglose '1.0.0' war der Kommentar-Treffer (Falsch-Positiv des Musters, aufgeklaert).
STATUS LT. QUELLE: nur-hinweis (Gegenprobe der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 043
GEGENSTAND: GEGENPROBE[4]: set_active_machine_declaration: 0 Produktions-Aufrufer -- Grep ueber libs/apps/tests/tools liefert NUR tests (test_c3a, test_o4) + 2 Kommentare (profil
ORT: unbekannt
SOLL/FIX: set_active_machine_declaration: 0 Produktions-Aufrufer -- Grep ueber libs/apps/tests/tools liefert NUR tests (test_c3a, test_o4) + 2 Kommentare (profile_run_entry.hpp:315, hardware_probe_factory.hpp:498) -- deckt KON23-02(a).
STATUS LT. QUELLE: nur-hinweis (Gegenprobe der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 044
GEGENSTAND: GEGENPROBE[5]: Gepinnte 128-Hex-Fingerprints in tests+libs: 0 Treffer -- Muster-POSITIVKONTROLLE bestanden (synthetischer 128er-String => 1 Treffer); der erste Kontro
ORT: unbekannt
SOLL/FIX: Gepinnte 128-Hex-Fingerprints in tests+libs: 0 Treffer -- Muster-POSITIVKONTROLLE bestanden (synthetischer 128er-String => 1 Treffer); der erste Kontrollversuch mit handgetipptem String schlug fehl und wurde mit generiertem String wiederholt (protokolliert).
STATUS LT. QUELLE: nur-hinweis (Gegenprobe der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 045
GEGENSTAND: GEGENPROBE[6]: x512{vl}-ohne-f-Akzeptanz: genau 1 Assert (algo_semver.hpp:1544) + Prosa :1536-1539 -- vollstaendige T-1-Saat-Liste, keine weitere Testdatei pinnt die 
ORT: unbekannt
SOLL/FIX: x512{vl}-ohne-f-Akzeptanz: genau 1 Assert (algo_semver.hpp:1544) + Prosa :1536-1539 -- vollstaendige T-1-Saat-Liste, keine weitere Testdatei pinnt die Nicht-Pruefung.
STATUS LT. QUELLE: nur-hinweis (Gegenprobe der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 046
GEGENSTAND: GEGENPROBE[7]: Andockstellen-Doppel ':73' aufgeloest: algo_semver.hpp:73 traegt den Anker-Text 'S2-KATALOG-ANDOCKSTELLE' und die OWNER-VORLAGE :105 nennt die Datei e
ORT: unbekannt
SOLL/FIX: Andockstellen-Doppel ':73' aufgeloest: algo_semver.hpp:73 traegt den Anker-Text 'S2-KATALOG-ANDOCKSTELLE' und die OWNER-VORLAGE :105 nennt die Datei explizit; simd_organ_requirement.hpp:73 ist '(void)value;' (Zufalls-Zeilennummer).
STATUS LT. QUELLE: nur-hinweis (Gegenprobe der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 047
GEGENSTAND: GEGENPROBE[8]: Overlay-Satz vollstaendig gelistet: 52 Eintraege (36/10/3/3); Praefix-Block :177-195 woertlich gelesen -- keine der #4-Dateien faellt unter einen Praef
ORT: unbekannt
SOLL/FIX: Overlay-Satz vollstaendig gelistet: 52 Eintraege (36/10/3/3); Praefix-Block :177-195 woertlich gelesen -- keine der #4-Dateien faellt unter einen Praefix (simd_sub_axis deckt NUR simd_sub_axis*, nicht simd_build_gate/simd_feature_flag/simd_organ_*).
STATUS LT. QUELLE: nur-hinweis (Gegenprobe der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 048
GEGENSTAND: GEGENPROBE[9]: GESAMTURTEIL nacht-7c: 170 Zeilen, 0x 'S-3' (grep -c) -- die Strecke lebt in par.16 der Wellenkonsolidierung (Posten 8/15/16 + kritischer Pfad), dort mit 
ORT: unbekannt
SOLL/FIX: GESAMTURTEIL nacht-7c: 170 Zeilen, 0x 'S-3' (grep -c) -- die Strecke lebt in par.16 der Wellenkonsolidierung (Posten 8/15/16 + kritischer Pfad), dort mit Zeilennummern belegt.
STATUS LT. QUELLE: nur-hinweis (Gegenprobe der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 049
GEGENSTAND: GEGENPROBE[10]: DESIGN-Doc flag-grammatik-v2: 0 Treffer gegated/Voraussetzung/impliz => Ketten-Quelle ist die 6-Lens-JSON (vaes-Eintrag mit 'Setzt aes voraus' woertli
ORT: unbekannt
SOLL/FIX: DESIGN-Doc flag-grammatik-v2: 0 Treffer gegated/Voraussetzung/impliz => Ketten-Quelle ist die 6-Lens-JSON (vaes-Eintrag mit 'Setzt aes voraus' woertlich extrahiert) + Katalog-Prosa -- die Ketten existieren nirgends als Daten (Neubau-Baustein bestaetigt).
STATUS LT. QUELLE: nur-hinweis (Gegenprobe der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 050
GEGENSTAND: GEGENPROBE[11]: prod1-Live-Probe (lokale Maschine IST prod1): /proc/cpuinfo traegt ' aes ' und ' pclmulqdq ' (grep -m1 -o) -- Grundlage der Bau-Weiche zum 23er-Katalog
ORT: unbekannt
SOLL/FIX: prod1-Live-Probe (lokale Maschine IST prod1): /proc/cpuinfo traegt ' aes ' und ' pclmulqdq ' (grep -m1 -o) -- Grundlage der Bau-Weiche zum 23er-Katalog; 23er fuehrt heute nur kVaes/kVpclmulqdq (grep auf simd_feature_flag.hpp).
STATUS LT. QUELLE: nur-hinweis (Gegenprobe der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 051
GEGENSTAND: GEGENPROBE[12]: Werkzeug-Disziplin: alle Zaehlungen mit /usr/bin/grep (ugrep-Falle umgangen); Transkript-Zugriff erst grep -c je Datei, dann gezielte jq-/grep-o-Extra
ORT: unbekannt
SOLL/FIX: Werkzeug-Disziplin: alle Zaehlungen mit /usr/bin/grep (ugrep-Falle umgangen); Transkript-Zugriff erst grep -c je Datei, dann gezielte jq-/grep-o-Extraktion (keine ungebremsten Reads; 246/299-MB-Dateien nur per Muster angefasst).
STATUS LT. QUELLE: nur-hinweis (Gegenprobe der Quelle)
ABHAENGIGKEIT/FLAECHE: -

### [wq3sh10mx.json] 052
GEGENSTAND: BAU-ANWEISUNG KOPF + TAG 1 (Fr 14.08., S-3): Ordnungs-Relation flag_menge_ordnung.hpp + Voraussetzungs-Wache (Ketten als DATEN aus 6-Lens-JSON) + Freigabe-Belegung (DER EINE AUFRUF in der Fassaden-Naht); EISERNE REGEL: KEINE Datei unter axes/, topics/, heuristik/ anfassen (Overlay-Glied [7]); T-1 ROT zuerst, K13-Koeder, Verify KON55-Kombibau
ORT: measurement/flag_menge_ordnung.hpp (NEU) | algo_semver.hpp:1003-1008 | profile_run_facade.cpp/profile_run_entry.hpp
SOLL/FIX: GELTUNG: KON38 -- jede Phase {model:'fable', effort:'max'}. Arbeitsort: ce-Worktree unter /home/comdare/wt-super-landung (EIN Schreiber je Worktree). EISERNE REGEL BEIDER TAGE: KEINE Datei unter axes/, topics/ oder heuristik/ anfassen (Overlay-Glied [7] hasht deren QUELLTEXT -- jeder Touch, auch Kommentar, verschiebt Fingerprints; heuristik zusaetzlich C-4-Lock). Alle Arbeit liegt in include/cache_engine/measurement/ (nicht im Overlay-Satz), profile_facade/ und tests/ => SHA-/golden-neutral by construction.

== TAG 1 (Fr 14.08.) -- S-3: Ordnungs-Relation + Voraussetzungs-Wache + Freigabe-Belegung ==
S-3a ORDNUNGS-RELATION (constexpr SUBSET ueber Flag-MENGEN der v2-Grammatik):
 (1) T-1 ROT: neue TU tests/unit/test_s3_flag_ordnung.cpp mit CT-Erwartungen: teilmenge(parse(\"1.0.0.c.x512{f.vl}\"), parse(\"1.0.0.c.x512{f.vl.bw}\"))==true; Umkehr==false (Asymmetrie IST der Zweck); (token,eltern)-genau: vnni@x256 niemals Teilmenge via vnni@x512; Sentinel/unparsbar => false (fail-closed); X.Y.Z-Tripel ist NICHT Teil der Mengen-Rechnung (Ordnung ueber die MENGE, das Tripel gehoert der zweistufigen Versionierung). Bau bricht = ROT gesehen, protokollieren.
 (2) Neuer Header measurement/flag_menge_ordnung.hpp (Nachbarschaft flag_grammar_catalog.hpp, nur stdlib+Katalog, reines constexpr): flag_menge_ist_teilmenge(AlgoSemVer,AlgoSemVer) ueber for_each_flag_node (algo_semver.hpp:904 -- die EINE Traversal-Primitive, kein zweiter Parser), Element=(token,eltern)-Paar; Doktrin-Vorlage bvset_teilmenge.hpp:146-165 (asymmetrisch, fail-closed, byte-genau je Element). Dazu die Signatur-Bruecke flag_menge_in_signatur(AlgoSemVer, span<SimdFeatureFlag const>) ueber die Token->cpuinfo-TABELLENFELDER von kFlagGrammarCatalog (NIE String-Heuristik -- Drei-Namensraeume, algo_semver.hpp:833-853); Token ohne cpuinfo-Feld (c,p,e,Basen) sind zulassungs-neutral.
 (3) K13-KOEDER: Mutation Teilmenge->Gleichheit => Erweiterungs-Fall-Test MUSS reissen; Mutation Eltern-ignorieren => vnni-Doppelgaenger-Test MUSS reissen. Je ROT gesehen + Gegenprobe gruen (KON57-03-Protokollform; Koeder-LAENGE/Grund pruefen -- K13: der Koeder muss aus dem RICHTIGEN Grund beissen).
S-3b VORAUSSETZUNGS-WACHE (Compile-Seite FORDERT, KON16-02):
 (4) T-1 ROT: Erwartungen in dieselbe TU: voraussetzungen_erfuellt(parse(\"1.0.0.c.x512{f.vl}\"))==true; \"...x512{vl}\" ohne f ==false; \"...vaes\" ohne x128{aes}==false; \"...vpclmulqdq\" ohne x128{pclmulqdq}==false; m64-Familie OHNE Ketten-Pflicht (Recherche: keine formale CPUID-Abhaengigkeit -- NICHT raten); nacktes \"1.0.0.c\" true (vakuum).
 (5) Ketten als DATEN: additives Feld voraussetzung (string_view, \"\"=keine) in FlagCatalogEntry ODER eigene kFlagVoraussetzungen-Tabelle daneben -- Quelle AUSSCHLIESSLICH die 6-Lens-JSON (docs/sessions/backups/20260807-explores-und-simd-katalog/) + Katalog-Prosa (:244 x512-Subsets->f); JEDE Kette mit Beleg-Zitat im Kommentar, Nichtbestand (m64) ausdruecklich benannt.
 (6) Praedikat voraussetzungen_erfuellt(AlgoSemVer): je Knoten mit Kette MUSS das Voraussetzungs-Token in der Menge stehen -- FORDERN, KEIN Auffuellen (Auffuellen waere ein Byte-/Identitaets-Ereignis: algo_semver.hpp:52-63, parse->render-Treue).
 (7) ZIELFORM-EINHAENGUNG (KON11-01): neuer Konjunktions-Term in ce_owned_version_is_wellformed (algo_semver.hpp:1003-1008), UNGATED mit der Katalog-Begruendung (:992-996: Existenz-Aussage, keine Politik). Damit hoeren alle 12 B12-Quellen-Klassen (a)-(l), alle Registries UND der S-1-StempelVertrag die Wache mit NULL neuen Aufruf-Stellen. Nenner-Beweis: P14-Riegel-Vorkommenszahl (139) vorher/nachher messen und deklarieren.
 (8) (m8)-Block :1529-1544 NACHFUEHREN: Prosa ergaenzen (Abhaengigkeiten seit S-3 GEPRUEFT -- durch is_wellformed, nicht durch flag_catalog_is_satisfied), neue CT-Zeile static_assert(!ce_owned_version_is_wellformed(\"1.0.0.c.x512{vl}\")) daneben; die bestehenden :1542-1544 bleiben wahr (Katalog prueft weiter nur Vokabular). Bestands-Gruen-Beweis: alle 123 Literale nackt-c => vakuum-wahr; die 25 \"1.0.0.c\"-Testdateien bleiben gruen.
S-3c FREIGEBENDE SEITE SCHARF (IMPLIZIERT + Einmal-Belegung):
 (9) T-1 ROT: tests/unit/test_s3_freigabe_belegung.cpp: nach Fassaden-Start mit golden-XML auf prod1: active_machine_verdict()==Match, active_machine_signature() nicht leer, rsp-Zeilen BYTE-GLEICH zu vorher (C-3a-Spiegel -- byte-neutral scharf); Hostname ohne <machine>-Treffer: alles bleibt leer/inert (fail-closed). ROT, weil der Konsum fehlt.
 (10) DER EINE AUFRUF: in der Fassaden-Eintrittsnaht (profile_run_facade.cpp/profile_run_entry.hpp -- NACH Parse+validate, VOR der Perm-Schleife): live_hostname() gegen ep.machines.hostname_hint (NUR Lookup-Schluessel, machine_identity.hpp:285-286); Treffer => Ergebnis von set_active_machine_declaration(mc.cpu_fabrication, mc.ram_pair) BEHANDELN ([[nodiscard]]: Gesetzt/BereitsGesetztIdentisch ok; AbgelehntAbweichend => klassifizierter Fehler-Log, kein Abbruch); kein Treffer/keine Menge => NICHTS belegen (natuerlicher Kill-Switch, simd_build_gate.hpp:209). KEIN zweiter Kanal, KEINE Heuristik, KEIN CMake-Schalter.
 (11) IMPLIKATION ALS WACHE: neue CT-Wache signatur_ist_voraussetzungs_geschlossen ueber die Ketten-Tabelle je MachineSimdSignature + je kDeclaredMachines-Zeile -- heute gruen (prod1 traegt f+Subsets explizit), kuenftig laut bei unvollstaendiger Neu-Deklaration. GRENZE DOKUMENTIEREN: Ketten, deren Voraussetzungs-Flag der 23er-Signatur-Katalog nicht fuehrt (aes, pclmulqdq), prueft die Wache nicht -- benannte Werkzeug-Grenze; der additive 23er-Zuwachs (kAes/kPclmulqdq, live auf prod1 belegt) ist ERLAUBT aber nicht Pflicht; wer ihn zieht, zieht die Schwester-Asserts (:155 size==23, Signatur-Batterien) im SELBEN Commit nach.
 (12) T-6 SCHWESTERSTELLEN: Tests iterieren ALLE 9 Organ-Klassen (kSimdOrganRequirement-Tabelle, nicht 1 Beispiel), BEIDE Dialekte (Gpp/Clang), alle 3 Routen (kRouten-Muster), beide Maschinen-Klassen + odroid (nicht deklariert => nullptr => ehrlich leer).
 (13) VERIFY: Kombibau KON55 (gcc+clang x Debug+Release, je J-1..J-4: Werkzeuge -> RE-CONFIGURE -> Vollbau -> --target comdare_tests -> ctest); Warnungs-Review zweimal (GCC, dann clang); Diff-Hygiene push-lokal ueber den Bereich; BU sofort; literale Ausgaben ins Protokoll (kein Erfolgs-Haken ohne Literal).


STATUS LT. QUELLE: offen (ausfuehrbare Bau-Anweisung -- praezise Anweisung VERBATIM uebernommen)
ABHAENGIGKEIT/FLAECHE: S-1 gelandet vorausgesetzt; F1-Frist

### [wq3sh10mx.json] 053
GEGENSTAND: BAU-ANWEISUNG TAG 2 (Sa 15.08., S-7): Achsen-Algo-Hardware-Stempel X.Y.Z aktiv -- Vollbestands-Beweis ueber Registry-TYPLISTEN (Nenner GEMESSEN >=123, nie gepinnt), Zulassungs-Bruecke algo_declared_flags_for_axes an per-Binary-Naht (build_orchestrator.hpp:759-771), VERBOTEN: globaler Fassaden-Hook + zweite Gate-Mechanik; K13-Koeder beidseitig; Abgrenzungen im Commit-Text; Landung sequentiell
ORT: measurement/ (neue Freifunktion) | build_orchestrator.hpp:759-771 | tests/unit/test_s7_algo_hardware_stempel.cpp (NEU)
SOLL/FIX: == TAG 2 (Sa 15.08.) -- S-7: Achsen-Algo-Hardware-Stempel X.Y.Z AKTIV ==
 (1) T-1 ROT: tests/unit/test_s7_algo_hardware_stempel.cpp: (a) VOLLBESTANDS-Beweis: JEDE Variante der Registry-TYPLISTEN (Erhebung ueber die Typlisten, nicht Datei-Grep -- Bestands-Pflicht-Regel \"nach dem Gegenstand suchen\") erfuellt die VOLLE Kette: ce_owned_version_is_wellformed(W::algo_version) UND voraussetzungen_erfuellt UND (gated) cpu_enforce; Zaehl-Nenner wird GEMESSEN und geloggt (>=123), NICHT als Konstante gepinnt. (b) SEMANTIK-Beweis an SYNTHETISCHEN Probe-Klassen IM TEST (kein axes/-Touch!): Probe-Algo deklariert \"1.0.0.c.x512{f}\" => flag_menge_in_signatur gegen prod2-Signatur (kein avx512f) == false, gegen prod1 == true; MIN SUBSET implementiert SUBSET freigegeben (KON8-12) als CT-Kette an den Proben. ROT vor der Bruecken-Einhaengung.
 (2) ZULASSUNGS-BRUECKE an der BESTEHENDEN per-Binary-Naht: Freifunktion algo_declared_flags_for_axes(axes, versions_lookup) in measurement/ (Nachbarschaft aggregate_required_for_axes): parst je (achse,wert) das Varianten-Literal, uebersetzt Grammatik-Token -> SimdFeatureFlag ueber die Katalog-TABELLE, dedupliziert. Konsum im Orchestrator-Gate-Block (build_orchestrator.hpp:759-771) als ZWEITE Menge durch DIESELBE admit_organ_on_machine-Mechanik -- Menge heute LEER (alle Literale nackt-c) => byte-/golden-neutral, Wirkung bewiesen ueber die synthetische Probe. VERBOTEN: der globale Fassaden-Hook (C-3a-Tripwire-Klasse -- UNION waere je-Binary falsch); VERBOTEN: eine zweite Gate-Mechanik.
 (3) K13-KOEDER BEIDSEITIG: (fordernd) Mutation \"Voraussetzungs-Term aus is_wellformed entfernen\" => Registry-/StempelVertrag-Batterie und test_s7 muessen reissen; (freigebend/zulassend) Mutation \"Bruecke liefert immer leer\" => prod2-Ablehnungs-Probe muss reissen. Je ROT + Gegenprobe gruen, protokolliert.
 (4) T-6: beide Seiten x alle 9 Organ-Klassen x 3 Routen x 2 Dialekte x 2 Maschinen-Klassen; die C-3a-rsp-Byte-Gleichheit MUSS nach beiden Tagen weiter gruen sein (der Beweis, dass AKTIV != Byte-Ereignis).
 (5) ABGRENZUNGEN IM COMMIT-TEXT DEKLARIEREN: keine required-Mengen befuellt (Tripwire steht, Owner-Paket-Entscheid bleibt kuenftig); keine Literal-Bumps (kommen je Algorithmus, wenn er real Flags deklariert -- dann .algos-Sidecar+Stempel-Byte-Ereignis, heute kostenlos: nie eine Flotte gebaut); S-14-Bump-Wache eigener Posten; Interface-Versions-Ebene = S-18 nach golden; Messfuehler-Vertrag (dreiphasig) = Posten 8.
 (6) VERIFY wie Tag 1 (KON55-Matrix, zweifacher Warnungs-Review, ctest Debug+Release) + LANDUNG: parallel gebaut, SEQUENTIELL gelandet (Lande-Stufe landet den Zweig; merge, nie rebase; Diff-Hygiene; gitleaks mit --config + frischem Koeder; Push BEIDE Remotes; ce-Pipeline per Monitor, NIE im Agenten warten); super-Gitlink-Bump als eigener Zug; Worktree erst nach gruen+merge+Submodul-Branch-Pruefung loeschen. Danach steht S-5 (braucht S-1+S-3) frei.
STATUS LT. QUELLE: offen (ausfuehrbare Bau-Anweisung)
ABHAENGIGKEIT/FLAECHE: nach Tag 1; landereifer Branch ce bau/s7-algo-hardware-stempel = mutmasslicher Vollzug -- am Objekt verifizieren

## QUELLE wvi23h1ux.json -- Zwei P1-Read-only-Posten (13.08., frisch): F9-Heilung (nachgezogener Zehn-Wochen-Explore ueber Fixup 2/3 des Achsen-Versions-Riegels) + #31-Triage (13 ce-Branches in P-Lande-Ordnung klassifiziert: 1x LANDEN, 8x AUSBUCHEN, 4x UEBERHOLT_DURCH_NEUBAU). 2 Agenten, F9-Quittung BEFUNDLOS_ABWEICHUNG_GESCHLOSSEN (divergenzen leer).

### [wvi23h1ux.json] 001
GEGENSTAND: F9-Nachexplore-Quittung: die Fixups 2/3 des Achsen-Versions-Riegels sind owner-gedeckt, KONSOLIDIERT statt daneben gebaut (KON11-01 eingehalten); divergenzen-Liste LEER
ORT: ce tools/axis_version_lock/ | Baseline-Anker a8465ef3 (Eltern-Commit 7d65eb6c)
SOLL/FIX: kein Fix -- Quittung "BEFUNDLOS_ABWEICHUNG_GESCHLOSSEN"; A2.2-Befund: vor dem Riegel existierte je Klasse genau EIN Artefakt, Fixups haben es fortgeschrieben (Lock v1 -> v2 (bb5d3f3c, Zweizeilen) -> v3 (8cc564d5, Dreizeilen-Record mit Pfad-Split dirname/basename))
STATUS LT. QUELLE: behoben (Fixup-Strecke geschlossen; v1/v2 werden bei --check laut abgewiesen = Dauer-Koeder S)
ABHAENGIGKEIT/FLAECHE: Landung P11 (bau/golden-s14a-riegel via merge b91b22fc in development)

### [wvi23h1ux.json] 002
GEGENSTAND: Owner-Wort KON27-01 (12.08. 07:56 typed, 5a19728e) VERBATIM: "Das Grundproblem der Deckung ist immer noch das Aufraeumproblem, weil eigentlich jede Achsen-Kategorie ihr eigenes home braucht, fuer das unter der Stempel-Mechanik genau ein Waechter greift. Daher gilt nach Untergliederung 130 und 152 je nach Achsen-Kategorie, was nach DREIPHASIG und ZWEIPHASIG Syntax ueberprueft werden muss. Die Organ-Achsen sind derzeit axes und es braucht noch die Kategorien fuer Mess/System. [...] Wir beginnen aber zuerst mit einer gueltigen golden Version. Ansonsten brauchen wir das fuer Mess/System/Organ gleichermassen gegliedert."
ORT: Ledger KON27-01 | Rohtranskript 5a19728e 12.08. 07:56
SOLL/FIX: Owner fixiert KEINE der Zahlen 130/152, sondern die Reihenfolge golden-ZUERST, Home-Gliederung DANACH; die Zahlen werden laut Ledger-Verbuchung NACH dem Aufraeumen geschnitten; je Achsen-Kategorie eigenes Home + genau EIN Waechter
STATUS LT. QUELLE: offen (Task #16: Homes MESS/SYSTEM + S-18-Waechter, explizit NACH P11; Leerstelle im Tool-Kopf benannt, kein stiller Default -- Ledger KON58-01)
ABHAENGIGKEIT/FLAECHE: #16/#17 (G-2-Semantik DREIPHASIG/ZWEIPHASIG je Home-Waechter); golden Version zuerst

### [wvi23h1ux.json] 003
GEGENSTAND: Owner-Wort KON17-03 (12.08. 06:19 typed) VERBATIM: "Frage 12: Wache Modular erweitern und in Detail-Klassen splitten." -- EINE bestehende Wache erweitern, KEIN zweites Werkzeug
ORT: Ledger KON17-03
SOLL/FIX: Erweiterung der bestehenden Wache in Detail-Klassen; verbietet Zweitwerkzeug-Bau
STATUS LT. QUELLE: nur-hinweis (Deckungs-Anker fuer kuenftige Wachen-Arbeiten)
ABHAENGIGKEIT/FLAECHE: alle kuenftigen Wachen-Erweiterungen (#16/#17, S-18)

### [wvi23h1ux.json] 004
GEGENSTAND: Owner-Versionierungs-SOLL (10.08. 11:16 typed) VERBATIM: "Jeder Achsen-Algorithmus hat eine Versionierung, was sich in der Tier-Binary spaeter wiederspiegelt. Die CEB haben nur Mess-Achsen und System-Achsen Versionierungen. Jedes Genus hat fuer sein Interface eine Versionierung fuer das was es Leistet und das setzt sich als compile time Versionierungsstempel aus allen Mess/System/Organ-Achsen zusammen. [...] Der Planer [...] hat laut Plan eine simple X.Y.Z Versionierung und einen Fingerprint SHA wie alle Planer/CEB/Tier-Binary/Hybrid-Tier-Binary."
ORT: Rohtranskript 5a19728e 10.08. 11:16
SOLL/FIX: Versionierungs-SOLL je Stufe (Anker fuer S-7/Stempel-Strecke)
STATUS LT. QUELLE: nur-hinweis (Owner-Orientierung, deckt S-7-Bau)
ABHAENGIGKEIT/FLAECHE: S-7 (bau/s7-algo-hardware-stempel), Stempel-Strecke

### [wvi23h1ux.json] 005
GEGENSTAND: Wurzel der Bump-Wache: Owner 18.07. 19:17 queued (46375cdc) VERBATIM: "dass die CI erkennt, ob eine Organ-Achse sich bezueglich eines Achsen-Algorithmus geaendert hat, sodass nur Binaries im Baum neu gebaut werden, die das bezueglich er Algorithmus Versionierung betrifft. [...] es werden alle Binaries gebaut, wo wir einen einkompilierten Algorithmus geaendert haben, der Rest bleibt unveraendert."
ORT: Rohtranskript 46375cdc 18.07. 19:17
SOLL/FIX: Cache-Oekonomie, deren Ehrlichkeit der Riegel bewacht; v1-Werkzeug entstand einen Tag spaeter (7492b2ea, 19.07.)
STATUS LT. QUELLE: nur-hinweis (historischer Deckungs-Anker)
ABHAENGIGKEIT/FLAECHE: S-14a-Riegel / Bump-Wache (S-14-Bump-Wache eigener Posten lt. wq3sh10mx)

### [wvi23h1ux.json] 006
GEGENSTAND: Binary-Stempel-Arrays (NICHT Registerform): Owner 19.07. 19:23 + 20.07. 13:12 -- string_view-Stempel IN der Binary, 2 separate Zeilen (System-Achsen / Organ-Achsen); Planer eigener X.Y.Z-Stempel; CEB je einkompilierter Mess-Achse eigene Array-Versionierung; KEINE Gesamt-Versionierung fuer CEB oder Tier-Binary
ORT: Rohtranskripte 46375cdc 19.07. 19:23 / 20.07. 13:12
SOLL/FIX: Abgrenzung: beide Owner-Worte betreffen die IN-Binary-Stempel, NICHT die Register-DATEI; die Registerform (Zeilen je Record, Pfad-Split, 120-Grenze) hat KEIN Owner-Wort (Nichtfund mit Gegenprobe, siehe 011)
STATUS LT. QUELLE: nur-hinweis (Abgrenzungs-Anker)
ABHAENGIGKEIT/FLAECHE: Stempel-Strecke (S-1/S-5/S-7); axis_version.lock v3-Form ist agentische Wahl, owner-neutral

### [wvi23h1ux.json] 007
GEGENSTAND: Golden-Bruch freigegeben: Owner 18.07. 10:03 "Wir loeschen die golden und die Messwerte und beginnen von vorn mit einer neuen golden Version. Bruch Freigabe." + 20.07. 08:53 "B1: new golden ist die neue Pflicht." + 07.08. 17:34 "Wir brechen golden-CRC!"
ORT: Rohtranskripte 46375cdc + 5a19728e
SOLL/FIX: golden-Neuaufbau ist Pflicht und freigegeben; Overlay-Entstehung per Explore + Tiefensuche im gefundenen Dokument (Owner 07.08.)
STATUS LT. QUELLE: nur-hinweis (Freigabe-Anker, Achse 3)
ABHAENGIGKEIT/FLAECHE: golden-Regen der Welle (P6-Statistik-Gate), GOLDEN-VERSION.md trennt seit 13.08. ACHSEN-LOCK-Anker a8465ef3 von golden-DATENBASIS G-2026-07-26

### [wvi23h1ux.json] 008
GEGENSTAND: Stempel+Fingerprint: Owner 06.08. 13:39 "Wir hatten einen komplexen Stempel mit allen Achsen-Kategorien festgelegt mit jeweils versionierten Achsen-Algorithmen und zum Schluss ein SHA Hash als fingerprint." -- Fixup 3 richtet die Wachen-Grundgesamtheit exakt an der Menge aus, die dieser Fingerprint sieht (kOverlaySourceSet, Overlay-Glied [7])
ORT: builder/overlay_source_set.hpp (seit 07.08., c7158b2b)
SOLL/FIX: EIN Schnitt (kOverlaySourceSet + Endungs-Listen aus genau diesem Header), keine Zweitliste
STATUS LT. QUELLE: behoben@Fixup3 (Riegel liest den Fingerprint-Schnitt)
ABHAENGIGKEIT/FLAECHE: Overlay-Glied [7]; jede kuenftige Erweiterung der Quellmenge muss durch DIESEN Header

### [wvi23h1ux.json] 009
GEGENSTAND: Interface- vs. Algo-Version TRENNEN: Owner 10.08. 10:53 "weil die Achsen und deren Interfaces eine eigene Kategorie sind, gehoeren ihnen separate zusaetzliche geplante Stempel je Achse und Algorithmus (explore), bitte das trennen und unterscheiden."
ORT: Ledger / Stempel-Strecke
SOLL/FIX: der Riegel bewacht die ALGORITHMUS-Haelfte (algo_version-Literale + Digests); die Interface-Haelfte liegt in der Stempel-Strecke (S-1 gebaut, G-2/#17 folgt); nichts vermengen
STATUS LT. QUELLE: teilweise (Algo-Haelfte bewacht; Interface-Haelfte = S-18 nach golden bzw. G-2/#17)
ABHAENGIGKEIT/FLAECHE: S-18, #17, Stempel-Strecke

### [wvi23h1ux.json] 010
GEGENSTAND: Dauerregel-Anker: Owner 13.08. 09:06 queued + 09:42 typed: "Bitte erinnere dich auch daran, dass alle in workflows gefundenen Luecken Pflicht fixes sind." / "Alle Luecken sind wie immer Pflicht" -- Grundlage der fail-closed-Entscheide der Fixups (Traeger-Austritt ROT, Aufwertung Exit 3, Bump-Zweig Exit 3)
ORT: Rohtranskript 5a19728e 13.08.
SOLL/FIX: Luecke = Pflichtfix im SELBEN Zug (deckt sich mit Memory-Dauerregel)
STATUS LT. QUELLE: nur-hinweis (Regel-Anker; die drei fail-closed-Entscheide sind gebaut)
ABHAENGIGKEIT/FLAECHE: gesamter Komplex-Fix-Workflow

### [wvi23h1ux.json] 011
GEGENSTAND: NICHTFUND (mit dreifacher Gegenprobe): KEIN Owner-Wort zur Register-DATEIFORM (Zeilen je Record, Pfad-Split, 120-Grenze) in 1.917 puren Owner-Aeusserungen (1.193 von 4.904 extrahierten in 46375cdc [107.425 Roh-Zeilen] + 724 von 2.158 in 5a19728e [51.507 Roh-Zeilen]; Extraktion = UNION der drei Pfade promptSource-typed/queued_command/queue-operation-enqueue)
ORT: Rohtranskript-Korpora 46375cdc + 5a19728e
SOLL/FIX: Gegenprobe dreifach: (a) registerform|lock-form|lockformat|dreizeilen|zweizeilen|spalten = 3 Treffer, alle andere Objekte; (b) lock mit Wortgrenze = 4 Treffer, 3 Lager-Bestandslog/ETA-Locks, 1 Fehltreffer; (c) \b120\b = 2 Treffer (CI-Terminal-Escapes). Falsch-Null-Klassen gedeckt: Case, Encoding (ae- UND Umlaut-Schreibweise, 'Trager'), Umbruch (joined-vs-raw, 15 Terme x 2 Korpora = 0 Differenzen)
STATUS LT. QUELLE: behoben (Nichtfund sauber belegt; Lock-v3-Form damit als agentisch-owner-neutrale Wahl bestaetigt)
ABHAENGIGKEIT/FLAECHE: -

### [wvi23h1ux.json] 012
GEGENSTAND: NICHTFUND (mit Gegenprobe): KEIN Owner-Wort zu Traeger-Austritts- oder digest-only-Verhalten (austritt 0/1.193 + 0/724; digest 0+0, die 2 Rohtreffer waren Task-Notifications; alle 25 Traeger-Treffer in 5a bezeichnen Traeger-STUFEN Planer/CEB/Tier/Hybrid -- Homonym am Text belegt)
ORT: Rohtranskript-Korpora
SOLL/FIX: kein Owner-Wort verlangt stilles Verschwinden; die gebaute ROT/Exit-3-Semantik folgt der Dauerregel und dem V-1-Verbot stillen Gruens
STATUS LT. QUELLE: behoben (fail-closed-Entscheid gedeckt)
ABHAENGIGKEIT/FLAECHE: -

### [wvi23h1ux.json] 013
GEGENSTAND: Gegenprobe Restkorpora: die 7 uebrigen JSONL in /home/comdare/.claude/projects/-home-comdare/ (b15ade0e 20 typed, 4cf35b04 16 typed, 5 Kleinst-Dateien je 0-1 typed) enthalten 0 Treffer auf axis_version|Grundgesamtheit|golden Version|Detail-Klassen|Overlay-Schnitt
ORT: /home/comdare/.claude/projects/-home-comdare/
SOLL/FIX: nichts Achsen-Relevantes ausserhalb der zwei grossen Korpora
STATUS LT. QUELLE: behoben (Deckungs-Beleg)
ABHAENGIGKEIT/FLAECHE: -

### [wvi23h1ux.json] 014
GEGENSTAND: Lock-v3-Bestand am Objekt: 2.181 Zeilen, laengste Zeile 92 von erlaubten 120, 718 Records = 712 Overlay-Quellen (organ 640, system 16, mess 1, tier_substanz 55) + 6 heuristik
ORT: ce tools/axis_version_lock/axis_version.lock (v3 @ 8cc564d5)
SOLL/FIX: kein Fix; Zahlenstand als Referenz (deckt sich mit Ledger KON58 "Riegel 718 Records"); 120-Spalten-Grenze ist Bestand (scripts/ci_diff_ascii_width_guard.sh:9, ColumnLimit aus .clang-format) -- v3 DIENT dieser Wache
STATUS LT. QUELLE: behoben (Ist-Stand-Messung)
ABHAENGIGKEIT/FLAECHE: Diff-ASCII-Width-Wache

### [wvi23h1ux.json] 015
GEGENSTAND: Historie der Deckungs-Wache: das v1-Werkzeug axis_version_lock.cpp war DREI WOCHEN TOT durch YAML-Doppel-Key (ce/.gitlab-ci.yml Kommentar Z. 370ff. und 776ff., Zusammenfuehrung 06.08.; 557d8023 belegt die durchgelassene Drift); wurde IN SITU zum Riegel v2/v3 erweitert (Ledger KON12-02 woertlich "reiner Ausroll-Auftrag, kein Neubau" -- eingehalten); BESTANDS-Parser algo_semver.hpp wiederverwendet (kein zweiter Version-Parser, Ledger KON58-01); CI-Job contract:axis-version-lock bleibt EIN unbedingtes Dauergate; Fixup 2 ergaenzte --write + git diff --exit-code als Tiefenstaffelung
ORT: ce tools/axis_version_lock/axis_version_lock.cpp | ce/.gitlab-ci.yml
SOLL/FIX: kein neuer Fix; KON12-02/KON14-05 am Objekt bestaetigt
STATUS LT. QUELLE: behoben
ABHAENGIGKEIT/FLAECHE: -

### [wvi23h1ux.json] 016
GEGENSTAND: 26 Alt-Home-*.hpp AUSSERHALB des Overlay-Schnitts, benannt und gemessen: telemetry 10, simd/isa 10, cacheline 3, axis_centric_namespaces 1, queuing-Huelle 2; 0 gelockt, 0 mit algo_version
ORT: ce libs (ausserhalb kOverlaySourceSet)
SOLL/FIX: Quelle nennt keine Behebung -- Menge ist deklariert; Zuordnung zur kuenftigen Home-Gliederung (#16) offen
STATUS LT. QUELLE: nur-hinweis (gemessene Restmenge)
ABHAENGIGKEIT/FLAECHE: #16 Home-Gliederung; S-18-Kategorie-Homes

### [wvi23h1ux.json] 017
GEGENSTAND: Kern-Defekt-Heilung: vor Fixup 3 waren 152 von 387 Home-hpp bewacht = 60 Prozent unbewacht bei GRUEN; Fixup 3 waehlte den Fingerprint-Schnitt (die Menge, die Overlay-Glied [7] tatsaechlich hasht) -- die WF7-Skizze "Autodiscovery ueber Registry-Typlisten" war Agenten-Vorzeichnung OHNE Owner-Mechanik-Wort; eine Typlisten-Menge waere ENGER als die Quellmenge des Fingerprints gewesen
ORT: ce builder/overlay_source_set.hpp + tools/axis_version_lock/
SOLL/FIX: Fingerprint-Schnitt als Grundgesamtheit (gebaut)
STATUS LT. QUELLE: behoben@Fixup3
ABHAENGIGKEIT/FLAECHE: KONFLIKT-HINWEIS: wq3sh10mx-Bau-Anweisung S-7 verlangt Vollbestands-Beweis ueber Registry-TYPLISTEN (>=123) -- zwei verschiedene Grundgesamtheiten (Typlisten fuer S-7-Stempel vs. Fingerprint-Schnitt fuer Riegel); Designer muss trennen, nicht vermengen

### [wvi23h1ux.json] 018
GEGENSTAND: Abgegrenzte Owner-Forderungen mit eigenem, vom Owner selbst NACH der golden Version sequenziertem Traeger (kein Gegenstand der Fixups): (a) je Achsen-Kategorie eigenes Home + genau ein Waechter -> Task #16 (explizit NACH P11); (b) DREIPHASIG/ZWEIPHASIG-Syntaxpruefung je Home-Waechter -> #16/#17 G-2-Semantik; (c) separate Achsen-INTERFACE-Versionen -> Stempel-Strecke
ORT: Task #16, #17, Stempel-Strecke
SOLL/FIX: Sequenz einhalten: golden zuerst, dann Homes/Waechter/Interface-Versionen
STATUS LT. QUELLE: offen (drei benannte Folgeposten)
ABHAENGIGKEIT/FLAECHE: golden-Regen; P-Lande-Ordnung

### [wvi23h1ux.json] 019
GEGENSTAND: T31-Triage b-m2-pmc-invariante: AUSBUCHEN -- Tip 90bca126 (06.08.), 1/1 Nicht-Merge-Commits patch-aequivalent in development (git cherry '-'); Beleg 8894d983 (06.08. 21:36, titel-identische Nachlandung); spaeterer PMC-Neubau I-PMC-2 f4dcc234 baut auf gelandetem Stand auf
ORT: ce Branch b-m2-pmc-invariante @ 90bca126
SOLL/FIX: AUSBUCHEN; Betriebsfolge: Store-2-Hauptauscheck nach der Ausbuchung von diesem Branch auf development umsetzen (Submodul clean, kein Verlust)
STATUS LT. QUELLE: offen (Urteil gefaellt, Verbuchung + Umsetzung ausstehend)
ABHAENGIGKEIT/FLAECHE: Store-2-Hygiene; #31-Vollzug

### [wvi23h1ux.json] 020
GEGENSTAND: T31-Triage b-m3v2-pmc-window: AUSBUCHEN -- Tip 81651f6e, 1/1 patch-aequivalent; Beleg 2b5ecd29 (06.08. 22:16, titel-identisch), seriell nachgelandet 6 Minuten nach dem Branch-Commit
ORT: ce Branch b-m3v2-pmc-window @ 81651f6e
SOLL/FIX: AUSBUCHEN
STATUS LT. QUELLE: offen (Urteil gefaellt, Verbuchung ausstehend)
ABHAENGIGKEIT/FLAECHE: #31-Vollzug

### [wvi23h1ux.json] 021
GEGENSTAND: T31-Triage b-pmc-errno-diag: AUSBUCHEN -- Tip 3f0d989d, 1/1 patch-aequivalent; Beleg 22e17f57 (06.08. 22:05, titel-identisch); 22e17f57 ist zugleich merge-base von b-m3v2-pmc-window -- serielle Nachlande-Kette der drei PMC-Branches geschlossen belegt
ORT: ce Branch b-pmc-errno-diag @ 3f0d989d
SOLL/FIX: AUSBUCHEN
STATUS LT. QUELLE: offen (Urteil gefaellt, Verbuchung ausstehend)
ABHAENGIGKEIT/FLAECHE: #31-Vollzug

### [wvi23h1ux.json] 022
GEGENSTAND: T31-Triage bau/p2-warnstufe-aufteilen: UEBERHOLT_DURCH_NEUBAU -- Tip 237d0952 (10.08.), 32 Dateien +564/-7; Lens 2 (10.08.) mass 'NICHT LANDEN (3 Blocker)', u.a. Wache rot auf owner-offiziellem configure.sh/make-check-Bauweg; Warn-Gegenstand neu aufgesetzt: warn(S1) 'Null-Kosten-Ratsche' b2d713d4 aendert DIESELBE Datei cmake/compiler_flags.cmake (:52-55), via merge(sammellandung) 51e1ee45 am 11.08. gelandet; COMDARE_set_default_warnings auf development weiterhin EINE Funktion (Z. 6-60)
ORT: ce Branch bau/p2-warnstufe-aufteilen @ 237d0952 | Worktree wf_5834b706-7b5-15 (porcelain 0)
SOLL/FIX: NICHT landen; SUBSTANZ-VERWERTUNG: die Hausnorm-Substanz (libs 15/15, apps 9/9, tools 15/15 + Abdeckungstest test_warnnorm_abdeckung.cpp, existiert auf development NICHT -- cat-file-Gegenprobe FEHLT) gehoert als Input in die P-WARN-Folgestufen, NEU abgeleitet vom frischen Stand
STATUS LT. QUELLE: offen (Substanz-Uebertrag als Folgeposten)
ABHAENGIGKEIT/FLAECHE: P-WARN-Folgestufen; cmake/compiler_flags.cmake-Hotspot

### [wvi23h1ux.json] 023
GEGENSTAND: T31-Triage bau/p3-ci-clang-pflicht: UEBERHOLT_DURCH_NEUBAU -- Tip 708cf156 (10.08.), 3 Dateien +1062/-5; Kern (build:clang unskippbar) dreifach ueberholt: (1) dev-.gitlab-ci.yml traegt seit 08.08. Block 'UNBEDINGT GESCHALTET' (Z. 139-147); (2) KON55 (12.08.): clang UND gcc ueberall Basis-Pflicht, landung-kombibau.sh 2x2; (3) juengere CI-Haertungen f528a4c7 (11.08.) + c6a3e991 (12.08., when:always am Guard-Job); 10.08.-Lens: 'nicht landen (2 ueberlebende Mutanten)' + Befund Invarianten-Wache sieht nur eigene YAML, nicht geerbte Vorlage im anderen Repo
ORT: ce Branch bau/p3-ci-clang-pflicht @ 708cf156 | Worktree wf_5834b706-7b5-16 (porcelain 0)
SOLL/FIX: NICHT landen; SUBSTANZ-VERWERTUNG: test_ci_invarianten.cpp (+933, auf dev nicht vorhanden) waere ein NEUER Posten im W2/S-12-CI-Geruest (#3) auf frischem Stand
STATUS LT. QUELLE: offen (Substanz-Uebertrag als Folgeposten #3)
ABHAENGIGKEIT/FLAECHE: W2/S-12-CI-Geruest; KON55-Kombibau

### [wvi23h1ux.json] 024
GEGENSTAND: T31-Triage bau/p6-lizenz-umsetzung: LANDEN -- einziger der 13 mit unueberholtem, owner-gedecktem Inhalt; Tip f6d13dfb (10.08.), 44 Dateien +1389/-91 (LICENSE +337 Comdare Research License 1.0, Change Date 2031-08-10; NOTICE; README; lizenz_audit.hpp +385 NEU; test_lizenz_konsistenz.cpp +500 NEU; ~30 SPDX-Header Apache-2.0 -> LicenseRef-Comdare-Research-1.0); implementiert exakt Owner-Entscheid C-2 vom 10.08. ('cache engine nach 5 Jahren frei verfuegbar ab heute'); development traegt noch 02.08.-Dual-Text OHNE Change-Date (6b8eee0f) und Apache-2.0-Header; 0 Treffer 'Research-1.0' im dev-Baum (Positiv-Koeder beisst am Branch LICENSE:1, Null echt)
ORT: ce Branch bau/p6-lizenz-umsetzung @ f6d13dfb | Worktree wf_5834b706-7b5-19 (porcelain 0)
SOLL/FIX: Lande-Auflagen VERBATIM: (1) Merge auf den frischen development-Stand (3 Tage Drift: S-1-Landung, KON57-Fixes, Q6, S-3, S-14a) mit mechanischer Tail-Append-Aufloesung am Register-Hotspot tests/unit/CMakeLists.txt; (2) KON55-Kombibau 2x2 (gcc+clang x Debug+Release) -- die neue Lizenz-Wache muss auf BEIDEN Compilern gruen sein; (3) Floor-Sprossen LIVE neu zaehlen (drei Absolutzahlen je Host-Klasse, NIE addieren; Nachzug als eigener Commit) + coverage-manifest-Treffer der 2 neuen Tests pruefen; (4) LICENSE-Text gegen Ledger:4152 gegenlesen (Change-Date 2031-08-10, Research-and-Teaching bleibt)
STATUS LT. QUELLE: offen (landereif mit 4 Auflagen; Slot: naechstes freies Blech-Fenster NACH P2/S-7-Landung, in jedem Fall VOR dem main-FF #19)
ABHAENGIGKEIT/FLAECHE: fingerprint-/lock-/golden-neutral (0/44 Dateien in Overlay-Schnitt oder Lock-Domaene); einzige Ueberschneidung tests/unit/CMakeLists.txt-Tail; DECKT den im Auftrags-Rahmen genannten landereifen Branch

### [wvi23h1ux.json] 025
GEGENSTAND: T31-Triage w0a/d2-floor: UEBERHOLT_DURCH_NEUBAU -- Tip 7f3901fb (09.08. 23:41); D2-Posten auf development in derselben Nacht PARALLEL neu gebaut und weiterentwickelt: 3e6fa9d5 (23:31) + 12bdd9ee (23:36) liegen 5-10 Min VOR dem Branch-Tip; danach 83a6d443 + d1eb4dc7 (10.08., Untergrenze JE HOST-KLASSE + Umgebungs-Leck 15515), 965cd6da (13.08., S-3-Sprossen 488/484/482), 5f3f26a5 (13.08., Landungs-Sprossen 489/485/483); cherry zeigt 3/3 '+' nur weil PATCHES abweichen, GEGENSTAND vollstaendig gedeckt
ORT: ce Branch w0a/d2-floor @ 7f3901fb
SOLL/FIX: NICHT landen; Restluecke laeuft als NEUER Posten #39 Floor-Nachzug-Wache
STATUS LT. QUELLE: offen (Posten #39)
ABHAENGIGKEIT/FLAECHE: D2-G5-Sprossen-Strecke; Floor-Sprossen-Zahlen 489/485/483 (13.08.)

### [wvi23h1ux.json] 026
GEGENSTAND: T31-Triage w2-A13-M1b: AUSBUCHEN -- 6/6 Commits patch-aequivalent; Beleg 95fc814c (02.08. 16:25, 'feat(A13-M1b)!: OWNER-Q3-FLAG-GRAMMATIK'); auf dev folgt Review-Fixup 7603453b (merge-base der w2c-Branches) -- Landung doppelt belegt
ORT: ce Branch w2-A13-M1b @ e35e0f36
SOLL/FIX: AUSBUCHEN
STATUS LT. QUELLE: offen (Verbuchung ausstehend)
ABHAENGIGKEIT/FLAECHE: #31-Vollzug

### [wvi23h1ux.json] 027
GEGENSTAND: T31-Triage w2-FK-1: AUSBUCHEN -- 6/6 patch-aequivalent; Belege 8893fdc7 ('BuildCellStatus drittes Zell-Vokabular, Owner-Q4 Volles-GO 02.08.'), 0fdeccff, 1231bc06; test_fk1_nicht_gebaut_marker.cpp auf dev von B13-Haertung (205a4bcd) weiterbearbeitet -- dev-Stand juenger als Branch
ORT: ce Branch w2-FK-1 @ 6019585c
SOLL/FIX: AUSBUCHEN
STATUS LT. QUELLE: offen (Verbuchung ausstehend)
ABHAENGIGKEIT/FLAECHE: #31-Vollzug

### [wvi23h1ux.json] 028
GEGENSTAND: T31-Triage w2-FK-2 (nur Store 2, lokal): AUSBUCHEN -- 4/4 patch-aequivalent; Belege b4aa7b10, 3501063a, 788a0c64, 13bc9f3d (alle 02.08., titel-identisch)
ORT: ce Branch w2-FK-2 @ a21575c5 (nur lokal Store 2)
SOLL/FIX: AUSBUCHEN
STATUS LT. QUELLE: offen (Verbuchung ausstehend)
ABHAENGIGKEIT/FLAECHE: #31-Vollzug

### [wvi23h1ux.json] 029
GEGENSTAND: T31-Triage w2c-TP1FK1-Fixes (nur Store 2): AUSBUCHEN -- 5/5 patch-aequivalent; Belege 1a1fc224 (B10), c7a6ec20 (B2), 86f97cd5 (B3), a3db9ddb (B5), f3475418 (B1/B4), alle 02.08. 18:27
ORT: ce Branch w2c-TP1FK1-Fixes @ c4d5b354 (nur lokal Store 2)
SOLL/FIX: AUSBUCHEN
STATUS LT. QUELLE: offen (Verbuchung ausstehend)
ABHAENGIGKEIT/FLAECHE: #31-Vollzug

### [wvi23h1ux.json] 030
GEGENSTAND: T31-Triage w2c-wachen-fixes (nur Store 2): AUSBUCHEN -- 5/5 patch-aequivalent; Belege ffdd37df (B6 static_assert je Eintrag), 1017d209 (B7 FINAL-DREI), 85ee0805 (B11 take_uint), c7f3e005 (B12 Registry-Politik), 205a4bcd (B13 Reader-Negativtest); Triage-Hypothese 'durch KON57 ueberholt' stellt sich NICHT -- Fixes seit 02.08. drin, KON57-Haertung baute auf ihnen auf
ORT: ce Branch w2c-wachen-fixes @ 43d98d5b (nur lokal Store 2)
SOLL/FIX: AUSBUCHEN
STATUS LT. QUELLE: offen (Verbuchung ausstehend)
ABHAENGIGKEIT/FLAECHE: #31-Vollzug

### [wvi23h1ux.json] 031
GEGENSTAND: T31-Triage worktree-wf_e22d25ef-71c-7: UEBERHOLT_DURCH_NEUBAU -- byte-identischer Zwilling von w0a/d2-floor (gleicher Tip 7f3901fb); kein eigener Commit-Inhalt; ABER: zugehoeriger Worktree traegt 17 untracked Eintraege
ORT: ce Branch worktree-wf_e22d25ef-71c-7 @ 7f3901fb | Worktree wf_e22d25ef-71c-7
SOLL/FIX: vor Freigabe des Worktrees die 17 untracked Dateien sichten (KON49-02: erst landen, dann loeschen)
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: siehe 034 (untracked-Sichtung)

### [wvi23h1ux.json] 032
GEGENSTAND: Zusatzbestand STORE 1 (Modulstore wt-super-landung-ce): Haupt-Auscheck development @ 5f3f26a5 (13.08. 09:45) mit laufender P1+P11-Landung -- 13/13 Commits UNPUSHED ueber origin/development f23c18e2 (fetch 09:26); Bau-Worktrees wt-ce-golden-s14a @ 8cc564d5 [bau/golden-s14a-riegel] und wt-ce-mess-ordnung @ 965cd6da [bau/s3-ordnungsrelation] (beide via merge(p11) b91b22fc bzw. merge(p1) 4c37116a in development enthalten); Stash 0; Sweep aller 14 uebrigen lokalen Branches: 0/14 mit Commits ueber development (auch w0b/durchstich-kette graph-enthalten -- Stilllegungs-Vermerk 'nie wiederbeleben' gilt fort); alle 8 weiteren origin-Branches ausserhalb der 13: je 0 Commits ueber development
ORT: .git/worktrees/wt-super-landung/modules/.../comdare-cache-engine
SOLL/FIX: ce-development-Push steht aus (13 Commits lokal voraus)
STATUS LT. QUELLE: offen (Push/Landung der Welle)
ABHAENGIGKEIT/FLAECHE: Push-Pflicht beide Remotes; Pipeline-gruen-Wache

### [wvi23h1ux.json] 033
GEGENSTAND: Zusatzbestand STORE 2 (Haupt-Super-Auscheck): ce-Submodul-Auscheck steht auf b-m2-pmc-invariante @ 90bca126 (06.08., UEBERHOLTER Stand) -- nach Verbuchung der Ausbuchung auf development umsetzen (porcelain 0, kein Verlust); Nebenbefund: lokaler bau/b5-pmc-status-token zeigt '28 ahead' gegen SEIN eigenes Remote-Gegenstueck, aber 0 Nicht-Merge-Commits ueber origin/development (cherry leer) -- nichts Ungelandetes
ORT: .git/modules/.../comdare-cache-engine (Haupt-Super-Auscheck)
SOLL/FIX: Hauptauscheck auf development umsetzen (nach Ausbuchungs-Verbuchung)
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: 019 (b-m2-Ausbuchung)

### [wvi23h1ux.json] 034
GEGENSTAND: Worktree wf_e22d25ef-71c-7 traegt 17/17 porcelain-Zeilen untracked ('??'): 16 Helfer-Skripte vom 10.08. 14:36-14:53 (abschluss/aufsetzen/ci_lauf/commit/g/hygiene/messen/nachbarn/owner_zitate/planwache/planwache2/rest20/stand/summe/transkripte/zitate2 .sh) + bau/ (284K CI-Reste); owner_zitate/transkripte = Beweisapparat-Kandidaten; gingen bei worktree remove VERLOREN
ORT: <Store2>/.claude/worktrees/wf_e22d25ef-71c-7
SOLL/FIX: vor Freigabe sichten/sichern (KON49-02)
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Worktree-Lebenszyklus-Regel; Beweisapparat

### [wvi23h1ux.json] 035
GEGENSTAND: WT-SUPER-D3NAHT Rueckwaerts-Gitlink: super-Branch bau/mutations-sicheres-testen @ e6d90232 (11.08., gelandet, 0 ueber origin); porcelain exakt 1 Zeile ' M Code/external/comdare-cache-engine' = Gitlink: HEAD verbucht e114cabd (10.08.), Arbeitsbaum steht detached auf 1880f296 (09.08., VORFAHR von e114cabd, ebenfalls enthalten) -- Dirty-Zustand zeigt RUECKWAERTS; overleaf-/thesis-Submodule NICHT initialisiert (leer, nichts zu verlieren)
ORT: Worktree wt-super-d3naht
SOLL/FIX: bei Loeschung geht NICHTS verloren; einzige Gefahr ist das COMMITTEN des Gitlinks (wuerde Submodul-Stand von e114cabd auf 1880f296 zurueckdrehen) -- NIE adoptieren; Worktree nach KON49-Prozedur freigebbar
STATUS LT. QUELLE: offen (Freigabe ausstehend)
ABHAENGIGKEIT/FLAECHE: Gitlink-Hygiene

### [wvi23h1ux.json] 036
GEGENSTAND: Lande-Empfehlung gesamt: NUR bau/p6-lizenz-umsetzung landet (Slot nach P2/S-7-Landung Sa abend/So frueh, Rueckfall-Slot nach P4 Mi, in jedem Fall VOR main-FF #19); 8x AUSBUCHEN (Branches bleiben unangetastet in den Stores, nur als bewusst-nicht-gelandet fuehren), 4x UEBERHOLT; Hygiene NACH Verbuchung (KON49-02-Reihenfolge): Store-2-Hauptauscheck umsetzen; wf-Worktrees -15/-16 sofort freigebbar, -19 erst NACH p6-Landung (traegt den Lande-Branch), wf_e22d25ef erst nach Sichtung der 17 untracked; wt-super-d3naht freigebbar; damit #31 vollstaendig und #19 (main-FF beider Repos) ENTBLOCKT
ORT: P-Lande-Ordnung (Schnitt-Doku 20260813, Z. 450-460)
SOLL/FIX: Reihenfolge und Slots wie oben verbatim
STATUS LT. QUELLE: offen (Vollzugs-Plan)
ABHAENGIGKEIT/FLAECHE: #19 main-FF; Wellen-Kette P2/S-7 -> P10 -> P6-Statistik-Gate -> P3 -> P5 -> P7 -> P4

## QUELLE wf8v44w0f.json -- Format-3-Neuanker TEIL 2 (ZEITSTAND 06.08.!): Bau-Agent STOPP vor Schritt 0 (HEAD-Abweichung benigne + Fremd-Session im Worktree), Fable-Review NACHBESSERN (alle Literal-Behauptungen reproduziert), Codex-Lens 8 Funde (1 BLOCKER, 1 KRITISCH, 4 HOCH, 2 MITTEL). ACHTUNG: alle Posten sind gegen den HEUTIGEN Stand (13.08.) abzugleichen -- vieles kann seither behoben/ueberholt sein; Worktree /home/comdare/wt-b2-neuanker, Branch b2-neuanker-format3.

### [wf8v44w0f.json] 001
GEGENSTAND: B1 HEAD-Abweichung: HEAD war b1d33cbe statt geforderter aa46c524 -- benigne, denn b1d33cbe IST der Schritt-0-Merge (Eltern aa46c524 + 7969b399); Schritt 0 inkl. semantischer Konfliktaufloesung bereits ausgefuehrt
ORT: /home/comdare/wt-b2-neuanker @ b1d33cbe
SOLL/FIX: Neuauftrag mit HEAD == b1d33cbe statt aa46c524
STATUS LT. QUELLE: offen (Auftrag ging von ueberholtem Ist aus)
ABHAENGIGKEIT/FLAECHE: Zeitstand 06.08. -- heutigen Verbleib des Branches/Worktrees pruefen

### [wf8v44w0f.json] 002
GEGENSTAND: B2 DOPPELBELEGUNG: eine fremde, lebende Session (PID 546552, claude --resume seit 07:36, mit codex mcp-server) arbeitete im selben Worktree an denselben Paketen; 3 uncommittete T2-D-Dateien (toolchain_stamp_glied.hpp, anatomy_fingerprint.hpp, toolchain_stamp_naht.hpp; +197/-20), Mtimes 51 s bis 3 min vor Agent-Start
ORT: /home/comdare/wt-b2-neuanker (uncommitted)
SOLL/FIX: VERBATIM: "Doppelbelegung des Worktrees ist auszuschliessen, bevor irgendein Agent weiterbaut."; Owner-/Orchestrator-Entscheid: PID-546552-Session ODER neu beauftragter Agent -- nie beide; bei Uebernahme explizite Freigabe, die 3 uncommitteten T2-D-Dateien als Vorarbeit zu uebernehmen und fertigzustellen (nicht neu zu schreiben)
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: alle T2-Pakete; Zeitstand 06.08.

### [wf8v44w0f.json] 003
GEGENSTAND: T2-A OFFEN: C-3: F1 Zell-Pfad + F4 resume-v6 mit Zaehler-Resume -- existiert nicht (grep resume-v6|resume_v6 ueber libs/apps/tests: 0 Treffer); Ist-Code steht auf resume-v5
ORT: ce builder/experiment_tree/cache_engine_builder_iterator.hpp:904 (resume-v5)
SOLL/FIX: T2-A bauen; Gegen-Probe (kuenstlicher Abbruch+Resume) erst danach moeglich
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: Zaehler-Resume-KERN; Zeitstand pruefen

### [wf8v44w0f.json] 004
GEGENSTAND: T2-B OFFEN (NB-2-KRITISCH): per-Perm-Felder aus der optxsimd-Schleife (O2/O3) -- kein Code, nur 2 Kommentar-Treffer in den uncommitteten T2-D-Dateien; kein Fingerprint-Vergleich moeglich
ORT: ce profile_facade (fehlend)
SOLL/FIX: T2-B bauen; O2-vs-O3-Fingerprint-Differenz literal beweisen
STATUS LT. QUELLE: offen (Stand 06.08., KRITISCH markiert)
ABHAENGIGKEIT/FLAECHE: haengt mit Codex-KRITISCH-Fund 014 zusammen (Skip-Key nicht injektiv)

### [wf8v44w0f.json] 005
GEGENSTAND: T2-C OFFEN: CEB-RT-Realversions-Erhebung (g++ 15.3 / g++-16 zur LAUFZEIT) fehlt; vorhandene CT-Stufe ist fail-closed (profile_run_facade.cpp:331-336: bei fehlender Deckung traegt Toolchain-Glied [5] NUR den Dialekt, keine Realversion)
ORT: ce profile_facade/profile_run_facade.cpp:331-336 | toolchain_stamp_naht.hpp:117
SOLL/FIX: RT-Erhebung bauen; konsistent mit NB2-Gate-Doc (nb2-live-und-frozen-sonde.txt: Deckung=NEIN, Glied [5] = tc=1;cxx=gcc:g++-16@1.0.0c;ceb=8.0)
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: Codex-HOCH-Fund 015 (Reuse fail-open)

### [wf8v44w0f.json] 006
GEGENSTAND: T2-D TEILWEISE: 3 uncommittete Fremd-Dateien decken 3 von 4 Punkten (rsp-Zeichenvorrat kToolchainGliedTransportZeichen + toolchain_wert_ist_rsp_transportfaehig; dangling-Traeger via geloeschtem RVALUE-Konstruktor + Voll-Formatwache in anatomy_fingerprint_glieder(); Feld-Ordnungs-static_assert fuer ToolchainStampParts); REST FEHLT: Diagnose-Text profile_run_facade.cpp:334 + bvset-PAARWEISE-CT-Eindeutigkeit
ORT: ce abi/toolchain_stamp_glied.hpp, abi/anatomy_fingerprint.hpp, profile_facade/toolchain_stamp_naht.hpp (uncommitted 06.08.)
SOLL/FIX: T2-D fertigstellen (facade:334-Text, bvset-Paarweise-CT, string_view-Umweg-Loch) und ERSTMALS gaten
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: 010 (Ist-Baum ungedeckt), 012 (Lebensdauer-Loch)

### [wf8v44w0f.json] 007
GEGENSTAND: T2-E OFFEN: tc=1-Kollisions-Verifikation
ORT: unbekannt (ce toolchain-Stempel-Strecke)
SOLL/FIX: T2-E bauen
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: -

### [wf8v44w0f.json] 008
GEGENSTAND: T2-F OFFEN: C-4-Rest
ORT: unbekannt (Neuanker-Soll-Spez C-4)
SOLL/FIX: T2-F bauen
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: -

### [wf8v44w0f.json] 009
GEGENSTAND: Gate-Backup-Spiegel LEER: docs/sessions/backups/20260806-neuanker-teil2/gates/ angelegt 08:03:23 aber leer -- die sechs Merge-Logs aus /tmp/.../scratchpad/neuanker/gates4/ gehoeren dorthin gespiegelt (Doktrin Workflow-Backup SOFORT); von beiden Reviews als Verstoss bestaetigt
ORT: super docs/sessions/backups/20260806-neuanker-teil2/gates/
SOLL/FIX: gates4-Logs (6 Logs, 08:03-08:09) in den Backup-Spiegel spiegeln
STATUS LT. QUELLE: offen (Stand 06.08.; /tmp-Quelle womoeglich inzwischen WEG -- Verlustrisiko pruefen)
ABHAENGIGKEIT/FLAECHE: BU-additiv-Regel

### [wf8v44w0f.json] 010
GEGENSTAND: Review-Neubefund (wichtigster): die 3 uncommitteten T2-D-Dateien wurden 08:12:31-08:14:54 geschrieben -- NACH dem letzten Gate-Lauf (ctest2 endete 08:09:57); der Working Tree ist von KEINEM Gate gedeckt; die Voll-Wache in anatomy_fingerprint_glieder() ist verhaltensaendernd und ungebaut; die 408er-Basis attestiert exakt HEAD b1d33cbe, NICHT den Ist-Baum
ORT: /home/comdare/wt-b2-neuanker (Ist-Baum 06.08.)
SOLL/FIX: Ist-Baum erstmals gaten (nach Uebernahme-Entscheid)
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: 002, 006

### [wf8v44w0f.json] 011
GEGENSTAND: Fable-Review-Verdikt NACHBESSERN mit Prioritaetenliste VERBATIM: 1. Worktree-Doppelbelegung aufloesen (Owner-/Orchestrator-Entscheid); 2. Neuauftrag mit HEAD == b1d33cbe + explizite Uebernahme-Freigabe der drei uncommitteten T2-D-Dateien; T2-D fertigstellen und erstmals gaten; 3. T2-A (Zaehler-Resume), T2-B (per-Perm O2/O3 -- KRITISCH), T2-C (RT-Realversion), T2-E, T2-F bauen; Gegen-Proben erst dann moeglich; 4. gates4-Logs in den leeren Backup-Spiegel spiegeln
ORT: Workflow wf8v44w0f, Review-Phase
SOLL/FIX: siehe Prioritaetenliste; Bau-Bericht selbst verifiziert korrekt, keine Falschaussage, STOPP war richtig
STATUS LT. QUELLE: offen (kein Teil-2-Paket gelandet, Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: gesamter Neuanker-Teil-2-Komplex

### [wf8v44w0f.json] 012
GEGENSTAND: Rest-Loch Lebensdauer: der Umweg Glied{std::string_view{temporary}} kompiliert weiterhin -- die Loeschung des Rvalue-Konstruktors schliesst nur den direkten Pfad; die Gebrauchs-Wache prueft Format, nicht Lebensdauer
ORT: ce abi/anatomy_fingerprint.hpp (uncommitted T2-D-Diff, OverlayHash/ToolchainGlied/BvsetGlied)
SOLL/FIX: fuer die Fertigstellung von T2-D vermerken (Review-Auflage)
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: 006

### [wf8v44w0f.json] 013
GEGENSTAND: Codex BLOCKER: der angekuendigte Teil 2 fehlt im Reviewbereich -- aa46c524..HEAD enthaelt nur den Merge b1d33cbe; Ist-Code weiter auf resume-v5 (cache_engine_builder_iterator.hpp:904); Batch-Plaene existieren nur fluechtig (builder/bestandslog/planer_driven_build.hpp:136); persistenter Batch-Plan und Phasenzaehler nicht vorhanden
ORT: ce builder/experiment_tree/cache_engine_builder_iterator.hpp:904 | builder/bestandslog/planer_driven_build.hpp:136
SOLL/FIX: Teil 2 bauen (persistenter Batch-Plan + Phasenzaehler)
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: T2-A

### [wf8v44w0f.json] 014
GEGENSTAND: Codex KRITISCH: Skip-Key NICHT INJEKTIV -- toolchain_stamp_naht.hpp:21 laesst opt/ext/gate aus dem Live-Glied weg, Komposition belegt kein atomic128 (:148); Zell-Injektion enthaelt nur target_isa/operating_system/simd (abi/system_cell_values.hpp:116); im Perm-Loop aendern sich Compile-Flags und build_version, Fingerprint wird aber nur aus Zellwerten neu erzeugt (profile_run_entry.hpp:874); Skip vergleicht ausschliesslich den Fingerprint (build_orchestrator/build_orchestrator.hpp:304) => O2/O3 derselben target/OS/SIMD-Zelle koennen KOLLIDIEREN
ORT: ce profile_facade/toolchain_stamp_naht.hpp:21,:148 | abi/system_cell_values.hpp:116 | profile_facade/profile_run_entry.hpp:874 | builder/build_orchestrator/build_orchestrator.hpp:304
SOLL/FIX: Skip-Key injektiv machen (per-Perm-Felder = T2-B)
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: T2-B (004); Mess-Echtheit des Skip-Gates

### [wf8v44w0f.json] 015
GEGENSTAND: Codex HOCH: keine CEB-RT-Realversions-Sonde; Reuse bleibt FAIL-OPEN -- bei fehlender Deckung bleibt realver leer, der Fingerprint jedoch gueltig und skipfaehig (toolchain_stamp_naht.hpp:159); zwei reale Compiler-Versionen hinter demselben Tag erhalten denselben Key; fail-closed ist nur die Versionsbehauptung, nicht der Skip
ORT: ce profile_facade/toolchain_stamp_naht.hpp:117,:159
SOLL/FIX: RT-Erhebung (T2-C) + Skip bei fehlender Deckung fail-closed
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: T2-C (005)

### [wf8v44w0f.json] 016
GEGENSTAND: Codex HOCH: normaler Mess-Resume NICHT ABBRUCHSICHER -- der Pfad trunciert zuerst result.csv (cache_engine_builder_iterator.hpp:1935), der alte Stamp wird erst anschliessend ersetzt/entfernt; Abbruch bzw. ungueltige Zwei-Phasen-Messung bei gleicher Konfiguration und Zeilenzahl kann vom Alt-Stamp zertifiziert werden; der Build-Fehler-Pfad macht es korrekt ('Stamp zuerst weg', :1719)
ORT: ce builder/experiment_tree/cache_engine_builder_iterator.hpp:1935 (defekt) vs :1719 (korrekt)
SOLL/FIX: Reihenfolge drehen: Stamp zuerst entfernen, dann truncaten (Muster :1719)
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: Messdaten-Echtheit

### [wf8v44w0f.json] 017
GEGENSTAND: Codex HOCH: W5 filtert das FALSCHE Fensterkoordinatensystem -- planner_status_reader.hpp:322 vergleicht COMDARE_GOLDEN_N_RANGE mit PlanPerm::index; die Range bezeichnet jedoch StaticBinaryView-Indizes INNERHALB jeder optxsimd-Perm (profile_run_entry.hpp:162); PlanPerm::index zaehlt den optxsimd-Walk (experiment_plan_director.hpp:2053); bei 4096:4096 werden typischerweise alle realen Zellen zu Fremdfenstern; die W5-Tests ZEMENTIEREN das falsche Modell (test_w5_status_reader.cpp:651)
ORT: ce profile_facade/planner/planner_status_reader.hpp:322 | profile_run_entry.hpp:162 | planner/experiment_plan_director.hpp:2053 | tests/unit/test_w5_status_reader.cpp:651
SOLL/FIX: Koordinatensystem korrigieren UND die zementierenden Tests mitkorrigieren
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: W5-Status-Strecke

### [wf8v44w0f.json] 018
GEGENSTAND: Codex HOCH: altes 'done' kann als Fertigsignal des AKTUELLEN Fensters erscheinen -- der additive Cursor speichert keinen Fensterstart/-umfang (progress_cursor_reader.hpp:60); der Renderer ordnet den letzten persistenten done-Stand dem aktuell angefragten Fenster zu (planner_status_reader.hpp:478)
ORT: ce profile_facade/planner/progress_cursor_reader.hpp:60 | planner_status_reader.hpp:478
SOLL/FIX: Fensterstart/-umfang im Cursor persistieren oder Zuordnung verweigern
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: W5-Status-Strecke

### [wf8v44w0f.json] 019
GEGENSTAND: Codex MITTEL: Resume-Stamp-Grammatik DRIFTET -- Live-Resume akzeptiert via std::stoull auch '|rows=3junk' (cache_engine_builder_iterator.hpp:952); W5 fordert vollstaendigen from_chars-Verbrauch (planner_status_reader.hpp:140); Status und Lauf urteilen unterschiedlich
ORT: ce builder/experiment_tree/cache_engine_builder_iterator.hpp:952 | planner_status_reader.hpp:140
SOLL/FIX: EINE Grammatik (from_chars-Vollverbrauch) fuer beide Leser
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: Vertrags-Harmonisierung an der Landung (Landungs-Regel v4.2/A2.1b)

### [wf8v44w0f.json] 020
GEGENSTAND: Codex MITTEL: verwaister Sidecar wird als GEBAUT gezaehlt -- W5 prueft nur den formal gueltigen .fingerprint-Sidecar (planner_status_reader.hpp:219); das echte Skip-Gate fordert zusaetzlich die Binary (build_orchestrator.hpp:304)
ORT: ce profile_facade/planner/planner_status_reader.hpp:219 | builder/build_orchestrator/build_orchestrator.hpp:304
SOLL/FIX: W5 muss dieselbe Doppelbedingung pruefen wie das Skip-Gate
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: 019 (gleiche Harmonisierungs-Flaeche)

### [wf8v44w0f.json] 021
GEGENSTAND: Merge-Aufloesung Schritt 0 OHNE BEFUND (beide Reviews): einzige beidseitig beruehrte Datei profile_run_facade.cpp, Hunks disjunkt; W5-Wahrheit uebernommen ('|rows=' -> kLazyResumeRowsKey, cache_engine_builder_iterator.hpp:876, kein viertes nacktes Literal); Gate-Doppellauf 408/408 Passed (62.59 s / 62.45 s), make1/make2 je 0 error-Zeilen; Frozen-Digest 17148e5a an allen 3 Soll-Fundstellen unbewegt; Rettungs-Branch rescue/b2-nb2-aa46c524 auf origin UND github
ORT: /home/comdare/wt-b2-neuanker @ b1d33cbe
SOLL/FIX: kein Fix (Entlastungs-Quittung)
STATUS LT. QUELLE: behoben@b1d33cbe (nur der Merge; Teil-2-Pakete davon unberuehrt offen)
ABHAENGIGKEIT/FLAECHE: -

## QUELLE w72yytmwm.json -- LB-6 Stufe 1 (ZEITSTAND 06.08., ce HEAD damals e7aa1244): OE-B-Dummy-Lager auf Baum-Form + Zeilen-Ruecklesung, Vor-Trigger-Pflicht. Codex-Analyse + Opus-Bauplan (docs/plaene/20260806-PLAN-lb6-stufe1-oeb-baumform.md, 521 Z., damals uncommitted). Kernbefund: der Ruecklese-Biss fehlt in beiden Lager-TUs; Beweis 1 + Beweis 4 bleiben unbelegt (B10).

### [w72yytmwm.json] 001
GEGENSTAND: LB-6-Delta: KEIN Test vereint 'echtes Dateisystem' + 'Stempel-Zeilen zurueckgelesen und einzeln ausgewertet' -- test_g1_binary_version_stamp.cpp hat den Zeilen-Anker (split_lines :28-40, vier Zeilen einzeln :84-104) aber in-process (0 Treffer fstream/filesystem); test_lb0:542 schreibt real, liest NIE zurueck (nur fs::exists); test_lb1:522 schreibt real, liest nur den Knoten-Log strukturiert zurueck, nicht den Stempel-Text zeilenweise
ORT: ce tests/unit/test_g1_binary_version_stamp.cpp | test_lb0_lager_pfad_grammatik.cpp:542 | test_lb1_knoten_heuristik_log.cpp:522
SOLL/FIX: neue Assertion-Ebene: std::ifstream oeffnen, Inhalt lesen, mit split_lines zerlegen, JEDE Zeile einzeln pruefen -- auf den bereits real geschriebenen Stempel-Dateien; kein neues Schreib-Fixture, kein neuer Header noetig, NUR der Ruecklese-Biss fehlt in beiden TUs
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: OE-B-Owner-Verschaerfung; heutigen Stand pruefen

### [w72yytmwm.json] 002
GEGENSTAND: D4 PFLICHT: mehrzeiliger Stempel-Fixture -- der heutige Fixture-String '[vereint,O2,avx2][a,b,c]+bt=Release' ist EINZEILIG; ohne mehrzeiligen Stempel (wie g1_binary_version_block()) ist 'jede Zeile verbatim' eine LEERE Aussage und die Owner-Forderung nicht erfuellt
ORT: ce tests/unit/test_lb0/test_lb1 (Fixture-String)
SOLL/FIX: Stempel auf Vier-Zeilen-Block heben; Erwartung gegen Erwartungs-ARRAY pruefen (nie gegen die geschriebene Variable); plus Negativ-Probe
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: 001

### [w72yytmwm.json] 003
GEGENSTAND: NEUBEFUND (blockiert Konkurrenz-Stufe): beide Fixtures (TempLager test_lb0:118-137, TempKnoten test_lb1:106-124) bilden ihre Wurzel als FESTEN Namen direkt unter temp_directory_path() und rufen im Konstruktor fs::remove_all(basis); die geheilte Klasse existiert bereits: tests/unit/comdare_test_tmp.hpp (#278/#24 + Haertung Posten 69) mit user_tmp_dir(); 39 TUs benutzen sie, 12 NICHT -- test_lb0/test_lb1 gehoeren zu den 12; ein echter Nebenlaeufigkeits-Test wuerde sonst die Kollision zweier ctest-Laeufe messen statt der Spin-Lock-Semantik
ORT: ce tests/unit/test_lb0_lager_pfad_grammatik.cpp:118-137 | test_lb1_knoten_heuristik_log.cpp:106-124 | comdare_test_tmp.hpp
SOLL/FIX: B-4: Wurzel auf user_tmp_dir() umstellen (15 min)
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: 006 (Nebenlaeufigkeits-Test); evtl. weitere der 12 TUs ohne comdare_test_tmp.hpp

### [w72yytmwm.json] 004
GEGENSTAND: Konkurrenz-Test deckt nur einen TEIL: TruncateZustandsmaschine (:420) + Crash-Marke (:448) laufen auf FakeAblage (In-Memory, :51), nicht auf make_filesystem_ablage(); der 'zweite Schreiber' ist ein verschachtelter SEQUENZIELLER zweiter Aufruf von mit_knoten_lock -- kein std::thread (0 Treffer in der TU); Zustandslogik bewiesen, Konkurrenz auf ECHTEM Dateisystem nicht
ORT: ce tests/unit/test_lb1_knoten_heuristik_log.cpp:420,:448,:51
SOLL/FIX: B-6 (optional/deklarierbar): echte 2-Thread-Konkurrenz mit make_filesystem_ablage() + TempKnoten + std::thread, Flake-Auflage: 'genau einer gewinnt', nie 'A gewinnt', kein sleep
STATUS LT. QUELLE: offen (Stand 06.08.; B-6 einziger Kandidat fuer deklarierte Verschiebung)
ABHAENGIGKEIT/FLAECHE: 003 (erst Temp-Wurzel-Fix)

### [w72yytmwm.json] 005
GEGENSTAND: Bau-Schritte VERBATIM (Plan): B-1 geteilter split_lines-Helfer tests/unit/stempel_zeilen.hpp (wortgleich aus test_g1:28-40, dort Kopie loeschen -- Muster comdare_test_tmp.hpp); B-2 test_lb0:542 Ablage als benannte Variable statt zweimal Temporary, Stempel auf Vier-Zeilen-Block, ablage.datei_lesen(b.blatt_pfad) -> split_lines -> Zeile-fuer-Zeile-EXPECT_EQ gegen Erwartungs-Array, plus Negativ-Probe und Test-Log-Zeile; B-3 dasselbe auf perm.dll in test_lb1:522, NACH Truncate+Inventur (belegt die Nachbarschafts-Invariante, die der Testname heute nur behauptet); B-4 Wurzel auf user_tmp_dir(); B-5 Doppellauf -LE pmc (erwartet 0 failed out of 405), ctest -N-Namens-Diff, cf22 ueber ganze Dateien (Lehre Ledger :4335-4345), ASCII-Selbstcheck, Ledger-Nachtrag; B-6 optional echte 2-Thread-Konkurrenz
ORT: ce tests/unit/ (B-1..B-6)
SOLL/FIX: siehe verbatim; Aufwand Stufe 1 ~110-140 Test-Zeilen, 0 Produktivzeilen, ~2,0-2,5 h; B-6 +1,5-2,0 h mit Rest-Flake-Risiko
STATUS LT. QUELLE: offen (Bauplan, Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: 001-004

### [w72yytmwm.json] 006
GEGENSTAND: BEWEIS 1 UNBELEGT: lueckenlose BATCH-Wiederaufnahme-Konstruktion (2 Layer, versions-scharfer per-Binary-Nachbau), PFLICHT laut OE-A (01.08.), KEIN Minimal-Ersatz; Ersatz-Gate-Rezept (K1, 01.08. Addendum): Doppellauf-Idempotenz (DIFF-RC=0), rm .version-Kontrolltest (genau eine Binary neu), literales built_new=0 an der Wurzel; B10 der VOR-TRIGGER-CHECKLISTE fuehrt ihn unveraendert offen ('V7.4-4+1-Beweise + G6(J-0..J-5) auf GEEICHTEM Stand NEU erbringen; Variant-Gate-E2E seit A2 inert'); test_a2_sha512_skip_gate.cpp deckt Fingerprint-Skip unit-seitig, ist NICHT der geforderte Driver-E2E-Doppellauf
ORT: Ledger VOR-TRIGGER-CHECKLISTE B10 | Quellen 20260801-FAHRPLAN:192-201, 20260801-KONSOLIDIERT:76,89-90
SOLL/FIX: Beweis 1 als Driver-E2E-Paket konstruieren (kein Stundenposten) ODER deklarierte Herabstufung im Ledger UND in der VOR-TRIGGER-CHECKLISTE
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: Vor-Trigger fuer Voll-Bau-4/Messfenster

### [w72yytmwm.json] 007
GEGENSTAND: BEWEIS 4 UNBELEGT: Bestandslog-E2E gegen ECHTES minio + Takeover-Zweig (K2/K5: 'Beweis 4 offen'); strukturell ausserhalb der Agenten-Reichweite (Cluster-read-only-Doktrin, echtes minio = Infra); Beweis 2 dagegen belegt (test_g3_prune.cpp: prune_verdict-Matrix, PruneNeverTouchesMeasureData; akzeptiert per K2 als Fake-mc-Weg)
ORT: Infra/minio (ausserhalb Repo)
SOLL/FIX: Beweis 4 in Infra-Lane erbringen ODER deklarierte Herabstufung
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: #10 MinIO (P10); Infra-Fenster

### [w72yytmwm.json] 008
GEGENSTAND: CI-Einhaengung: KEINE eigene CI-Aenderung noetig -- beide TUs label-los, laufen im Job test:unit (Schnitt -LE pmc); Nenner praezisiert: 407 Tests registriert, 2 mit LABEL pmc, 405 im Schnitt; AUFLAGE VERBATIM: 'keinem beruehrten Test ein Label geben' -- das war die R4-Wurzel (alte Job-Auswahl -LE contract|pmc schloss 9 registrierte Tests still aus; Wurzel-Fix baaaea62+dcb2f08f gelandet)
ORT: ce scripts/ci_test_coverage_manifest.sh:127-129 | build/land/tests/unit/CTestTestfile.cmake:794,796
SOLL/FIX: Label-Verbot bei der LB-6-Erweiterung einhalten
STATUS LT. QUELLE: nur-hinweis (Auflage fuer den Bau)
ABHAENGIGKEIT/FLAECHE: R4-Fallenklasse

### [w72yytmwm.json] 009
GEGENSTAND: Korrekturen des Plan-Agenten an der Codex-Analyse: (a) Codex zitierte B10 als 'Ledger :5696, juengster Eintrag' -- FALSCH HERUM: der Ledger haengt Nachtraege OBEN an, :5775 ist die B-Checkliste vom 05.08., juengster Eintrag stand bei :4199; inhaltlich bleibt B10 offen, die RANG-Aussage nicht; (b) Zeilennummern korrigiert (TempLager :118-137, TempKnoten :106-124, temp_directory_path :109); (c) eigener Lauf literal '100% tests passed, 0 tests failed out of 3'
ORT: Ledger (Richtungs-Konvention: Nachtraege OBEN)
SOLL/FIX: Lese-Konvention beachten (Falle fuer jeden Ledger-Leser)
STATUS LT. QUELLE: behoben (im Plan korrigiert)
ABHAENGIGKEIT/FLAECHE: Fallen-Register-Kandidat

### [w72yytmwm.json] 010
GEGENSTAND: TERMIN-URTEIL VERBATIM: 'Stufe 1 passt vor Do 07.08. -- LB-6 als Ganzes passt NICHT.'; kleinster Umfang, der die Zusage einloest: B-1+B-2+B-3 (MIT mehrzeiligem Fixture) + B-5 + EINE DEKLARIERTE HERABSTUFUNG von Beweis 1, Beweis 4 und der echten Nebenlaeufigkeit im Ledger UND in der VOR-TRIGGER-CHECKLISTE; 'Ohne den dritten Punkt wird Stufe 1 fertig beim naechsten Lesen zu LB-6 fertig -- dieselbe Verlustklasse, die den Paketschnitt ueberhaupt erst verschwinden liess.'
ORT: Ledger + VOR-TRIGGER-CHECKLISTE
SOLL/FIX: Herabstufung EXPLIZIT verbuchen, nie implizit
STATUS LT. QUELLE: offen (Stand 06.08.; ob Stufe 1/Herabstufung inzwischen vollzogen: gegen heutigen Ledger pruefen)
ABHAENGIGKEIT/FLAECHE: Verlustklasse 'still verschwundene Paketschnitte'

### [w72yytmwm.json] 011
GEGENSTAND: Plan-Datei-Verbleib: docs/plaene/20260806-PLAN-lb6-stufe1-oeb-baumform.md (521 Zeilen, 0 Nicht-ASCII) lag am 06.08. NUR als '??' im Arbeitsbaum -- NICHT committet
ORT: super docs/plaene/20260806-PLAN-lb6-stufe1-oeb-baumform.md
SOLL/FIX: Verbleib pruefen (committet? verloren?)
STATUS LT. QUELLE: offen (Commit stand aus)
ABHAENGIGKEIT/FLAECHE: Doku-nie-loeschen-Regel

### [w72yytmwm.json] 012
GEGENSTAND: Stufe 2 nur als Folgeposten: Vorlage tests/unit/genus_buildvariant_avx2.cpp (30 Zeilen, echt kompilierte SHARED-Lib ohne Anatomie-Rumpf, CMakeLists.txt:3583/:3599, nennt sich selbst 'dieser Stub'); haengt am Versionierungs-Interface (F7 Option b); NACH der Abgabe, ohne Terminzusage
ORT: ce tests/unit/genus_buildvariant_avx2.cpp | CMakeLists.txt:3583,:3599
SOLL/FIX: als Folgeposten fuehren
STATUS LT. QUELLE: offen (nach Abgabe)
ABHAENGIGKEIT/FLAECHE: F7 Option b / Versionierungs-Interface

### [w72yytmwm.json] 013
GEGENSTAND: Golden-/TABU-Neutralitaet der LB-6-Aenderungen belegt: beide TUs schreiben ausschliesslich unter temp_directory_path() (grep-verifiziert je 1 Fundstelle); alle 6 minio|golden|nas-Treffer sind Kommentare bzw. Test-Vokabel 'GOLDEN-STRING'; kein Produktivheader, keine golden-XML/CSV, kein binary_id/Fingerprint-Preimage, kein Netz
ORT: ce tests/unit/test_lb0 + test_lb1
SOLL/FIX: kein Fix (Neutralitaets-Beleg)
STATUS LT. QUELLE: behoben (Beleg erbracht)
ABHAENGIGKEIT/FLAECHE: -

## QUELLE wjrbqudaw.json -- A2.5-Fix des Design-Duos (13.08., FRISCH): TRAEGT_MIT_FIXES-Korrekturen beider Gegenleser in die zwei Design-Dokumente eingearbeitet (design_zielstruktur.md 30.225 Z. + design_g1.md 38.862 Z., beide unter JOB_DIR /home/comdare/.claude/jobs/5a19728e/tmp/, KEIN Repo). 12x EINGEARBEITET/ENTLASTET-Quittungen + 5 Restfragen. Diese Dokumente liegen im SELBEN tmp wie diese Extraktion.

### [wjrbqudaw.json] 001
GEGENSTAND: #29 F1 (HART) eingearbeitet: K3 unterzaehlt -- Querschnitt->CEB = 6 Kanten (nicht 3), Summe 61 (nicht 58); Summenzeile neu '59 Lib-Kanten (49+1+3+6) + 2 App-Kanten = 61' + Zaehlentscheid zu bewusst NICHT gezaehlten 5 ->builder-Kanten der drei Bau-Modul-Werkzeug-Apps; Objekt-Beleg: abi/cache_engine_execution_engine_adapter.hpp:14-16 zieht relativ ../../../builder/commands/{execute_engine_command,execution_result,workload}.hpp
ORT: design_zielstruktur.md par.3a/par.3c | ce abi/cache_engine_execution_engine_adapter.hpp:14-16
SOLL/FIX: K3-Aufloesung: beide Koepfe entkoppeln
STATUS LT. QUELLE: behoben (im Design-Dokument; Bau steht aus)
ABHAENGIGKEIT/FLAECHE: #29 Zielstruktur-Umbau (spaeterer Komplex-Fix)

### [wjrbqudaw.json] 002
GEGENSTAND: #29 F2 (HART) eingearbeitet: Matrix-Zeile tier korrigiert (->Querschnitt 1 via perm_runner.hpp:30, ->Fach 4 via perm_runner.hpp:26-29 -> anatomy, statt 0/0); neuer Punkt: harness/ ist NICHT fach-frei, stufen-neutral erlaubt, wandert beim Tier-Umzug mit
ORT: design_zielstruktur.md par.3a/par.3b | ce harness/perm_runner.hpp:26-30
SOLL/FIX: siehe Beleg
STATUS LT. QUELLE: behoben (im Design-Dokument)
ABHAENGIGKEIT/FLAECHE: #29

### [wjrbqudaw.json] 003
GEGENSTAND: #29 F3 (HART) eingearbeitet: Querschnitt->Fach = 20 (anatomy 13, topics 4, axes 3), nicht 0 -- der Querschnitt LEHNT am Fach; Quell-Verteilung abi 11/measurement 4/Rest 5; anatomy_module_abi_v1_decl.hpp:17-20 am Objekt bestaetigt; Folgerung: transitive anatomy-Mitnahme + #88-Entscheid 'Vertraege heben oder Kante deklarieren'
ORT: design_zielstruktur.md par.3a/par.3b(5)/par.1 | ce anatomy_module_abi_v1_decl.hpp:17-20
SOLL/FIX: #88-Entscheid noetig: Vertraege heben ODER Kante deklarieren
STATUS LT. QUELLE: behoben (Dokument); der #88-Entscheid selbst offen
ABHAENGIGKEIT/FLAECHE: #88

### [wjrbqudaw.json] 004
GEGENSTAND: #29 F4 (MITTEL) eingearbeitet: Ein-Zaehlweise deklariert (echte #include-Direktiven am Zeilenanfang, direkt+relativ, ohne Kommentare): ceb->Fach 147 (anatomy 85 = 74 direkt + 11 relativ, topics 48, axes 12, compositions 1, src 1) statt 134; ceb->Querschnitt 50 (49+1 relativ commands/auto_permutator.hpp:10); planer->Querschnitt 56, planer->Fach 25; fruehere Werte 58/51/4 als Kommentar-behaftet ausgewiesen; Folge-Angleichungen par.1 (74->85) und R8 (134->147)
ORT: design_zielstruktur.md par.3/par.3a | ce commands/auto_permutator.hpp:10
SOLL/FIX: siehe Beleg
STATUS LT. QUELLE: behoben (Dokument)
ABHAENGIGKEIT/FLAECHE: #67-Neuerhebung als unabhaengige Drittzaehlung (S-6d)

### [wjrbqudaw.json] 005
GEGENSTAND: #29 F5 (HART) eingearbeitet: par.4.2 'nur neue Dateien' war UNBAUBAR -- es gibt KEIN libs/CMakeLists.txt, libs/* haengt direkt an der Repo-Wurzel (Z. 736-753); neu: '1 Commit: NEUE Dateien libs/traeger/** PLUS GENAU EINE Anschluss-Zeile add_subdirectory(libs/traeger) in der bestehenden Repo-Wurzel-CMakeLists.txt' + Ein-Schreiber-Pruefauflage + Timing-Voraussetzung: ce-Schreibsperre der laufenden Wellen-Landung (KON59-02) aufgehoben, dann WE-15./16.-Fenster
ORT: design_zielstruktur.md par.4.2 | ce CMakeLists.txt (Wurzel, Z. 736-753)
SOLL/FIX: Skeleton-Commit erst nach KON59-02-Aufhebung, im WE-Fenster, mit Ein-Schreiber-Check
STATUS LT. QUELLE: behoben (Dokument); Skeleton-Commit offen
ABHAENGIGKEIT/FLAECHE: KON59-02-Schreibsperre; Ein-Schreiber-je-Worktree-Regel

### [wjrbqudaw.json] 006
GEGENSTAND: #29 F6 (MITTEL) eingearbeitet: Bruecken-Whitelist deckte nur 41 der 49 K1-Kanten (A2.2-Kollision); neu: Whitelist = K1-VOLLMENGE (experiment_tree 26, bestandslog 8, build_orchestrator/orch_make_stem 6, codegen/adhoc_emitter+type_name 2, driver_build_variant_signature 2, je 1 workload_driver, measure_storage/checkpoint_speicher, lager_ablage, ceb_version_stamp, artifact_transport); Bruecke ausserhalb der Liste erlaubt bei Besitzkarten-Nachtrag im selben Commit ('lauter Zugang statt Verbot', S-8s 2-Pass/lazy_adhoc_source_gen.hpp benannt)
ORT: design_zielstruktur.md par.4.3/par.2a
SOLL/FIX: siehe Beleg
STATUS LT. QUELLE: behoben (Dokument)
ABHAENGIGKEIT/FLAECHE: #29-Bau

### [wjrbqudaw.json] 007
GEGENSTAND: #29 F7 (KLEIN) eingearbeitet: Praezision+Anker -- (a) KON10-02 (Owner 11.08., D17 fuenf CI-Stufen, CiYamlBuilder->Child-Pipeline) als Primaeranker fuer S-12, KON25-08/-04 als Stuetzen; (b) K1-Zitatort experiment_dock_payload.hpp:24; (c) par.2-Nenner '18 Unterverzeichnisse, davon 16 mit C++-Bestand'; (d) par.2a builder '35 Unterverzeichnisse: 22 C++-tragende + 13 leere Skelette -> #88-Triage'; (e) R5 um dritte Include-Wurzel libs/cache_engine/src ergaenzt (<measurement/...> 77x von axes, <concepts>-Std-Header-Kollision, 'traeger/ erbt KEINE Alt-Wurzel'); (f) planer->src 2 als eigene Mini-Familie
ORT: design_zielstruktur.md par.1/par.2/par.2a/par.3c
SOLL/FIX: siehe Beleg; 13 leere Builder-Skelette -> #88-Triage
STATUS LT. QUELLE: behoben (Dokument); #88-Triage offen
ABHAENGIGKEIT/FLAECHE: #88; <concepts>-Kollisionsrisiko bei Include-Wurzeln

### [wjrbqudaw.json] 008
GEGENSTAND: G-1 HAUPTFUND/FIX 1 (tragend) eingearbeitet: die [...]-Kuerzung im par.0-Zitat verdeckte KON37-01 Satz 1 ('CEB gibt wallclock build auf der naechsten Traeger-Stufe frei', Ledger :2148) -- Slot-Projektion war w-blind (Alias-Klasse); B3-Konsequenz-Zitat :2171-2172 ('Die Tier-Gates bleiben -- gebaut werden sie nur noch, wenn die erzeugende CEB Wallclock traegt'); M-8 neu: CEB-Voll-Stempel + Gleichheit fest, Kind-Stempel-FORM ausdruecklich owner-offen; w-Blindheit als Alias-Klasse gegen KON34-05 :3229 und B11 algo_semver.hpp:533-537; NEUER Owner-Entscheid F-G1-11 mit drei Optionen (i) voller Ausdruck / (ii) Kontext-Mitfuehrung / (iii) w als CEB-Selbst-Instrument mit auszuweisendem B3-Widerspruch, OHNE stillen Default
ORT: design_g1.md par.0/M-8/B-1..B-3 | Ledger :2148,:2171-2172,:3229 | ce measurement/algo_semver.hpp:533-537
SOLL/FIX: F-G1-11 dem Owner vorlegen (drei Optionen, kein Default)
STATUS LT. QUELLE: behoben (Dokument); F-G1-11 OFFEN als Owner-Entscheid
ABHAENGIGKEIT/FLAECHE: F-G1-4/F-G1-10-Antworten + Stufe-D-Pin-Form haengen an F-G1-11

### [wjrbqudaw.json] 009
GEGENSTAND: G-1 AMBIGUITAET (b)/FIX 2 eingearbeitet: EBNF vs. Stufe C -- Hardware-Flags zwischen c[cpu_sub] und m; Entscheid: EBNF GILT, Produktion ist ABSCHLIESSEND ('zwischen c[cpu_sub] und m steht NICHTS; Hardware-Katalog fuer den c-Teil meint AUSSCHLIESSLICH c/p/e'); B-5 um Spiegel-Negativ-Probe '1.0.0.c.x512{f}.m{...} ROT AUCH AUF DER MESS-ZEILE' ergaenzt
ORT: design_g1.md par.3.1/Stufe C/B-5
SOLL/FIX: siehe Beleg
STATUS LT. QUELLE: behoben (Dokument)
ABHAENGIGKEIT/FLAECHE: G-1-Grammatik-Bau

### [wjrbqudaw.json] 010
GEGENSTAND: G-1 AMBIGUITAET (a)/FIX 3 eingearbeitet: Nicht-Injektivitaet der Projektion (m{t{ma.mi}} ist Voll-Ausdruck UND Projektion) -- in M-8 ausgeschrieben ('Rolle (Kopf vs. Kind) und Herkunft liegen am TRAEGER, nicht im Wert; Anordnung und Fremd-Slots gehen restlos verloren'); F-G1-10 um Kind-Anordnungs-Frage erweitert ('KON37-03: Zeiger/Zustaende JE STUFE, haengt an der F-G1-11-Entscheidung')
ORT: design_g1.md M-8/F-G1-10
SOLL/FIX: an F-G1-11 angeschlossen
STATUS LT. QUELLE: behoben (Dokument); Owner-Frage offen
ABHAENGIGKEIT/FLAECHE: F-G1-11

### [wjrbqudaw.json] 011
GEGENSTAND: G-1 AMBIGUITAET (c)/FIX 4 eingearbeitet: c{p.p}/c{e.e} war ableitbar und von keiner Wache verboten; NEUE Regel M-11 'CPU_SUB OHNE DUPLIKATE' (durchgesetzt in mess_version_is_wellformed(), mess-zeilen-lokal; auf System-/Organ-Zeilen ausgewiesenes G-2-Erbe -> #17); B-5-Beispiel '1.0.0.c{p.p}.m{b{w}} ROT (M-11)'; Belege: flag_catalog_is_satisfied algo_semver.hpp:934-941 (nur Zulassung je Knoten) und :1571 ('andere Fehlerklasse, NICHT gebaut')
ORT: design_g1.md par.3.2 (M-1..M-11) | ce measurement/algo_semver.hpp:934-941,:1571
SOLL/FIX: M-11 im G-1-Bau umsetzen; System-/Organ-Seite als G-2-Erbe nach #17
STATUS LT. QUELLE: behoben (Dokument); Bau offen
ABHAENGIGKEIT/FLAECHE: #17 (G-2)

### [wjrbqudaw.json] 012
GEGENSTAND: G-1 KLEINFUNDE/FIX 5 (a-d) eingearbeitet: (a) Geisterverweis par.6.2 -> 'par.6, Stufen B/C'; (b) Knotenzahl: m-Baum maximal 1+3+9=13, VOLLE Mess-Zeilen-Version mit c{p.e} bis 16 Knoten (13 + c/p/e), 16 << 96; (c) konkrete Wachen-Umstellung dreifach benannt: measurement_tooling_registry.hpp:58-62 ruft ce_owned_version_is_wellformed -- tooling_versionen_wohlgeformt + Schwester-Wachen wechseln; (d) NEUER Owner-Entscheid F-G1-12 (Tooling-<id> bei Mehr-Stufen-Belegung; anatomy_version_stamp.hpp:256-259 'GENAU die gewaehlte'); Stufe D um F-G1-11-Vorbehalt am Gleichheits-Pin ergaenzt
ORT: design_g1.md par.3.3/Stufe C/Stufe D/Stufe F | ce measurement_tooling_registry.hpp:58-62 | anatomy_version_stamp.hpp:256-259
SOLL/FIX: F-G1-12 dem Owner vorlegen
STATUS LT. QUELLE: behoben (Dokument); F-G1-12 OFFEN als Owner-Entscheid
ABHAENGIGKEIT/FLAECHE: F-G1-11/F-G1-12-Vorlage

### [wjrbqudaw.json] 013
GEGENSTAND: Bestaetigungs-Funde beider Reviews ENTLASTET (zielstruktur 'GEGENPROBEN GRUEN'; g1 VERIFIZIERT/NACHGERECHNET: alle Fundstellen, 0/8-Kollisionserhebung, 5 Beispiele, M-1-These, Owner-Zitate) -- kein Dokument-Eingriff noetig; als Verdikt-Kontext in neuen Abschnitten par.7 (zielstruktur) bzw. par.10 (g1); Auftrags-Pflicht 'REVIEW-EINARBEITUNG (A2.5, 13.08.2026)' in beiden Dokumenten erfuellt; Zaehlweisen bei allen ersetzten Zahlen mitgefuehrt (61 = 59 Lib (49+1+3+6) + 2 App; 147 = 85+48+12+1+1 mit 85 = 74+11; 20 = 13+4+3; 16 Knoten = 13 + c/p/e; 10 Naht-Familien)
ORT: design_zielstruktur.md par.7 | design_g1.md par.10
SOLL/FIX: kein Fix
STATUS LT. QUELLE: behoben
ABHAENGIGKEIT/FLAECHE: -

### [wjrbqudaw.json] 014
GEGENSTAND: RESTFRAGE 1: F-G1-11 (Kind-Stempel-Form/w-Sichtbarkeit, drei Optionen ohne Default) und F-G1-12 (Tooling-<id> bei Mehr-Stufen-Belegung) sind NEUE Owner-Entscheide; F-G1-4/F-G1-10-Antworten und die Stufe-D-Pin-Form haengen an F-G1-11
ORT: design_g1.md (Owner-Entscheid-Liste)
SOLL/FIX: in die Owner-Sammelvorlage aufnehmen
STATUS LT. QUELLE: offen (Owner-Frage)
ABHAENGIGKEIT/FLAECHE: Owner-Vorlage Sammelrunde Welle 2 (20260813-OWNER-VORLAGE)

### [wjrbqudaw.json] 015
GEGENSTAND: RESTFRAGE 2: feingranulare Matrix-Zellwerte NICHT selbst nachgemessen (topics/axes-Aufteilungen 15/4/48/12, die 11-relativ-Liste anatomy, Querschnitt->Fach-Quellverteilung abi 11/measurement 4/Rest 5) -- dem Gegenleser-Review entnommen (Methode an 7 Stichproben bestaetigt); die ohnehin beauftragte #67-Neuerhebung (S-6d) liefert die unabhaengige Drittzaehlung
ORT: design_zielstruktur.md par.3a
SOLL/FIX: #67-Neuerhebung als Drittzaehlung fahren
STATUS LT. QUELLE: offen (Restzweifel deklariert)
ABHAENGIGKEIT/FLAECHE: #67 (S-6d)

### [wjrbqudaw.json] 016
GEGENSTAND: RESTFRAGE 3: PUBLIKATION STEHT AUS -- beide Design-Dokumente liegen unpubliziert unter /home/comdare/.claude/jobs/5a19728e/tmp/ (design_zielstruktur.md 30.225 Z., design_g1.md 38.862 Z.); Zielpfade docs/plaene/20260813-DESIGN-* erst nach Owner-GO bzw. nach Aufhebung der ce-/super-Schreibsperre der laufenden Wellen-Landung (KON59-02)
ORT: /home/comdare/.claude/jobs/5a19728e/tmp/design_zielstruktur.md + design_g1.md
SOLL/FIX: nach Owner-GO/KON59-02-Aufhebung nach docs/plaene/20260813-DESIGN-* committen
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: KON59-02; Owner-GO

### [wjrbqudaw.json] 017
GEGENSTAND: RESTFRAGE 4: der Ein-Schreiber-Check an der Repo-Wurzel-CMakeLists.txt gegen die parallel laufenden WE-Straenge (Auflage in par.4.2) ist ZUM SKELETON-COMMIT-ZEITPUNKT durchzufuehren, nicht vorher pruefbar
ORT: ce CMakeLists.txt (Wurzel)
SOLL/FIX: Check in den Skeleton-Commit-Ablauf einbauen
STATUS LT. QUELLE: offen (zeitgebunden)
ABHAENGIGKEIT/FLAECHE: 005 (F5); Ein-Schreiber-Regel

### [wjrbqudaw.json] 018
GEGENSTAND: RESTFRAGE 5: Zielstruktur par.6.4 (Strenge der Stufen-Kante) nennt weiterhin 'heute 0 solcher Kanten gemessen' fuer transitives Durchgreifen Stufe 4->2 (hybrid->ceb bleibt 0) -- vom Review nicht beanstandet, von der Neumessung nicht beruehrt
ORT: design_zielstruktur.md par.6.4
SOLL/FIX: bei der #67-Neuerhebung mitpruefen
STATUS LT. QUELLE: offen (Pruefauftrag an #67)
ABHAENGIGKEIT/FLAECHE: #67

## QUELLE wzktivkld.json -- V-01/A15-Konsolidierung (ZEITSTAND 06.08.): 20 vergessene Positionen ins heutige System konsolidiert (neueste Aussagen gewinnen). Bilanz: 10 UEBERNOMMEN / 4 SUPERSEDED / 5 BEREITS ERLEDIGT / 1 OWNER-ENTSCHEID (Nenner 20). Beide Ziel-Dateien ADDITIV ergaenzt, KEIN Commit (Commit war Lead-Folgeposten).

### [wzktivkld.json] 001
GEGENSTAND: V-01/A15 vollzogen: Register (20260806-REGISTER-todo-konsolidierung-14-tage.md, Abschnitt 'NACHTRAG V-01/A15' ab Z.396, +79 Z.) und Delta-Doc (20260806-DELTA-abc-straenge-vs-neue-wellen.md, Abschnitt '6. KONSOLIDIERUNGS-VOLLZUG' ab Z.219, +80 Z.) additiv ergaenzt; KEIN Commit erfolgt
ORT: super docs/sessions/20260806-REGISTER-todo-konsolidierung-14-tage.md:396 | 20260806-DELTA-abc-straenge-vs-neue-wellen.md:219
SOLL/FIX: Zeile #1 VERBATIM: 'Lead committet beide Docs + Ledger-Zeile A15 VOLLZOGEN 10/4/5/1'
STATUS LT. QUELLE: teilweise (Dateien geschrieben, Commit offen -- heutigen Commit-Stand pruefen)
ABHAENGIGKEIT/FLAECHE: Lead-only-Ledger-Regel

### [wzktivkld.json] 002
GEGENSTAND: V-02-Rest: Zeile 'Mess-Manifest/Provenance' in die P3-Trigger-Checkliste, mit E8 zusammenfuehren: Voll-Bau-4 nur mit aktivem Provenienz-Log + geklaerter PMC-Beleg-Form; FF0 NICHT nachbauen (superseded durch Kap.-6-Habich-Fassung + P3/Phase 6)
ORT: Register :313 + :56
SOLL/FIX: siehe verbatim; Owner nur bei Herabstufung
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: P3-Trigger-Checkliste; E8

### [wzktivkld.json] 003
GEGENSTAND: V-03: KEIN Abgabe-Blocker (Korrektur des eigenen Delta-Berichts) -- alle 7 zitierten 19-Achsen-Stellen liegen in UN-INCLUDED Alt-Kapiteln; alle Vorkommen in kompilierten Dateien sind ausdruecklich historisch markiert, DE+EN paritaetisch (Belegtabelle mit 14 Datei:Zeile-Eintraegen in der Quelle); Kanon literal: 'Galerie der achtzehn Organ-Achsen (T0--T17)' (de/04_implementierung.tex:173)
ORT: thesis kapitel/de+en (diplomarbeit.tex:278-285: 8->6 Kapitel-Skelett, alte 01_..08_-Dateien un-included, Stufe-3-Umzug)
SOLL/FIX: Zeile #3: KEINE Aenderung im Thesis-Repo jetzt; Deprecation-Kopf fuer die 8 un-included Alt-Kapitel je Sprache + Stufe-3-Umzugs-Auflage (bei jedem Abschnitts-Umzug 19 -> 18/T0-T17 mitziehen) als NACH-ABGABE-Zeile
STATUS LT. QUELLE: offen (NACH-ABGABE-Posten; kein Abgabe-Risiko)
ABHAENGIGKEIT/FLAECHE: Thesis Stufe-3-Umzug

### [wzktivkld.json] 004
GEGENSTAND: V-05-Rest: vor erster Messauswertung Katalog-Pfad auf >=8 Rang-1-SOTA-Lebewesen zaehlen (sota_catalog), Ergebnis literal ins Ledger; bei <8: ausdrueckliche Herabstufung (Shortcut=Regression+TODO); V-05-Kern (Stub-Quarantaene) war seit 07.07. vollzogen und per ce-Test bewiesen -- kein Mess-Echtheits-Risiko
ORT: ce libs/cache_engine/profile_facade/ (sota_catalog)
SOLL/FIX: Lead zaehlt, OWNER entscheidet Herabstufung
STATUS LT. QUELLE: offen (vor erster Messauswertung)
ABHAENGIGKEIT/FLAECHE: Messfenster-Vorlauf

### [wzktivkld.json] 005
GEGENSTAND: V-06-Rest: P3-Checkliste 'ETA-Erst-Batch-Abnahme' -- nach dem ERSTEN Mini-Batch t/TU + avg_size gegen freien Plattenplatz BEIDER Maschinen rechnen, BEVOR die Matrix weiterlaeuft; kein separater 1-Zellen-Vorlauf; (V-06-Kern GN-9 superseded durch ETA/avg_size-Bestandslog + Forecast/df-Wache)
ORT: Register :313 | ce builder/bestandslog/eta_estimator.hpp
SOLL/FIX: siehe verbatim; Owner bei Abbruch
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: P3-Trigger; Platte-voll-Falle (df -h-Doktrin)

### [wzktivkld.json] 006
GEGENSTAND: V-08-Rest: nach dem Messlauf Anhang-A-Limitierung-1 DE+EN nachziehen; L2 bleibt ehrlich 0 (kein RAW-Rateversuch) und ist so zu formulieren; (V-08-Kern korrigiert: PMC misst NICHT gegen 0 -- L1/L3/branch_misses real erhoben und emittiert)
ORT: thesis anhang/{de,en}/A_measurements.tex:11/:10
SOLL/FIX: siehe verbatim; Lead nach Messdaten
STATUS LT. QUELLE: offen (nach Messlauf)
ABHAENGIGKEIT/FLAECHE: Messfenster

### [wzktivkld.json] 007
GEGENSTAND: V-11 #327 PAT (SECURITY): nicht mehr 'sofort' -- Owner hat Rotation auf NACH dem Messfenster terminiert (LEDGER:3727, Handout liegt); OWNER-FENSTER-Zeile mit Termin + Rotationsschritte im Handout (Vault-Kandidaten RUECKWAERTS gegen /api/v4/user bis HTTP 200; Position rotiert, nie hartcodieren); Ausfuehrung Infra-Lane, Cluster read-only
ORT: Register OWNER-FENSTER | Infra-Handout | LEDGER:3727
SOLL/FIX: Owner gibt Rotations-Fenster frei; dann Infra-Lane-Ausfuehrung
STATUS LT. QUELLE: offen (Owner-Fenster; SECURITY)
ABHAENGIGKEIT/FLAECHE: Messfenster-Ende; Vault-nie-greppen-Regel

### [wzktivkld.json] 008
GEGENSTAND: V-04 -> NEUER Owner-Entscheid O-4 'Anhang-A-Reichweite' (einzige der 20 Positionen, die als Owner-Entscheid klassifiziert wurde)
ORT: Register OWNER-FENSTER-Zeile O-4
SOLL/FIX: Owner entscheidet Anhang-A-Reichweite
STATUS LT. QUELLE: offen (Owner-Frage)
ABHAENGIGKEIT/FLAECHE: Thesis Anhang A

### [wzktivkld.json] 009
GEGENSTAND: Pos. 5 (V-13 rescue-Ref) ENTFAELLT: refs/rescue/e24-c3-wip-pause = 0bac9fbe83e5c5ae2cabd970cea0b6dd8c0dffe5 auf BEIDEN Remotes verifiziert; Namespace ausserhalb refs/heads/* -- Branch-Abbau kann ihn nicht treffen
ORT: refs/rescue/e24-c3-wip-pause (origin + github)
SOLL/FIX: kein Fix
STATUS LT. QUELLE: behoben (verifiziert)
ABHAENGIGKEIT/FLAECHE: Branch-Abbau/#31

### [wzktivkld.json] 010
GEGENSTAND: Superseded-Zuordnungen (4): V-02 FF0 -> Kap. 6 Habich-Fassung + P3/Phase 6; V-06 GN-9 -> ETA/avg_size-Bestandslog + Forecast/df-Wache; V-11 SOFORT -> Owner-Termin 'nach Messfenster'; V-18-Teil A20 -> Dual-Review-Regelbetrieb
ORT: Register NACHTRAG V-01/A15
SOLL/FIX: Nachfolger gelten; Vorgaenger NICHT nachbauen
STATUS LT. QUELLE: behoben (Zuordnung verbucht)
ABHAENGIGKEIT/FLAECHE: -

### [wzktivkld.json] 011
GEGENSTAND: Erledigt-Belege (5): V-01 (dieser Vollzug selbst), V-03 (siehe 003), V-05-Kern (Quarantaene seit 07.07.), V-08-Kern (PMC real), V-13 (siehe 009); uebernommen (10): V-07, V-09, V-10, V-12, V-14, V-15, V-16, V-17, V-19, V-20 (+ Reste aus V-02/V-03/V-05/V-06/V-08/V-18)
ORT: Register NACHTRAG V-01/A15
SOLL/FIX: die 10 uebernommenen Positionen leben im Register weiter -- Inhalte der V-07..V-20-Einzelposten sind in DIESER Quelle nicht ausgefaltet (nur die Nummern); bei Bedarf Register lesen
STATUS LT. QUELLE: teilweise (Erfassungs-Grenze dieser Quelle: Einzelinhalte der 10 nicht enthalten)
ABHAENGIGKEIT/FLAECHE: Register 20260806 als Traeger-Dokument

### [wzktivkld.json] 012
GEGENSTAND: Nebenbefund: Anhaenge B/E sind KEINE 4-Zeilen-Stubs mehr -- anhang/de/B_code_structure.tex 257 Z., E_architecture_decisions.tex 151 Z., EN 256/153 Z., alle sechs Anhaenge included (diplomarbeit.tex:290-295); Anhaenge-Realm-Welle gelandet auf 29a1700 (LEDGER:3748)
ORT: thesis anhang/ | diplomarbeit.tex:290-295
SOLL/FIX: kein Fix (in V-02 verbucht)
STATUS LT. QUELLE: behoben@29a1700
ABHAENGIGKEIT/FLAECHE: -

## QUELLE wn2wugqyj.json -- TOTALAUSFALL (12.08.): NEUBAU nach WF11-Agententod (529): Strang C F1-Durchstich + Strang A S-1 Basisklasse aus den geborgenen Schnitten (Fable 5 max, Branch-Pflicht, worktree-isoliert). ALLE 4 Agenten (bauC:f1-durchstich, bauA:s1-basis, verA, verC) starben am monthly spend limit; Ergebnis-Struktur LEER.

### [wn2wugqyj.json] 001
GEGENSTAND: Workflow-Totalausfall: Bau- und Verify-Agenten fuer Strang C (F1-Durchstich) und Strang A (S-1 Basisklasse) alle 4 mit Fehler 'You've hit your monthly spend limit' gestorben; Log literal 'Bau: C=TOT A=TOT'; result-Felder urteile/bergung/vor_landung/funde/offen ALLE leer ({})
ORT: Workflow wn2wugqyj (12.08.; development war damals a99c4a18, WF11-Strang-D-Wachen frisch gelandet)
SOLL/FIX: Gegenstand blieb in DIESEM Workflow ungebaut: F1-Durchstich (Strang C) + S-1 Basisklasse (Strang A) aus den geborgenen WF11-Schnitten; VERIFIKATIONS-AUFTRAG an den Designer: pruefen, ob ein SPAETERER Workflow beides neu gebaut hat (Indizien: Memory 'S-1 gebaut' in der Stempel-Strecke; landereifer super-Branch bau/f1-1x1-honest-empty) UND ob die 'geborgenen Schnitte' aus dem WF11-Agententod (529) dabei vollstaendig verwertet oder verloren sind
STATUS LT. QUELLE: offen (Ausfall ohne jede Quittung)
ABHAENGIGKEIT/FLAECHE: F1-Frist 14.08.; S-1/Stempel-Strecke; WF11-Bergungs-Bestand

### [wn2wugqyj.json] 002
GEGENSTAND: Ausfall-Klasse als Betriebs-Befund: leere Ergebnisstruktur = Platzhalter-Lieferung im Sinne der Ausfall-Definition; der Workflow hinterliess KEINE Bergungs-Notiz, keine Urteils-Zeile, keine vor_landung-Auflagen -- bei der Gesamtbild-Auswertung darf wn2wugqyj NICHT als Beleg fuer irgendeinen Vollzug zitiert werden
ORT: Workflow wn2wugqyj result
SOLL/FIX: Quelle nur als Ausfall-Dokumentation verwenden; Spend-Limit-Ausfallklasse (analog Codex-Lens-Doppelausfall 13.08.) im Betriebs-Risiko fuehren
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Workflow-Betrieb; stumme-Workflow-Tode-Regel (journal.jsonl)

---
SELBSTCHECK: 13/13 Batch-Dateien (i%12==0 der 152er-Liste, 0-basiert Index 0..144) vollstaendig
gelesen und extrahiert; 13 QUELLE-Abschnitte; 1034 Posten gesamt (wtk6lmhln 443, w3azi1rhl 164,
w2mylldp8 110, w9ezc7zw6 100, wp8u862m5 34, ww7eb5key 28, wq3sh10mx 53, wvi23h1ux 36,
wf8v44w0f 21, w72yytmwm 13, wjrbqudaw 18, wzktivkld 12, wn2wugqyj 2); Kopfzeilen-Korrektur
w2z8rp4xk->wn2wugqyj verbucht; ASCII-Pruefung: 0 Nicht-ASCII-Zeilen (LC_ALL=C grep -cP,
/usr/bin/grep absolut); keine rc-Pruefung nach Pipes (K11 beachtet).

