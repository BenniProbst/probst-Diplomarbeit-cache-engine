# WORKFLOW-REGISTER: DIE LETZTEN 10 WORKFLOWS + DER FAKT DER ZUSAMMENSCHALTUNG (Owner-Order 02.09. ~08:00Z)

Owner-Wortlaut: "Wir haben mit diesen Fragen ein ernstes Problem, bitte liste die letzten 10 workflows auf und den
Fakt, dass wir den fold rest und das rueckfragen audit zusammenschalten mussten, um wirklich alle offenen
Rueckfragen zu erfassen"

Quellen (gemessen 02.09. 07:5xZ): Journal-Verzeichnisse ~/.claude/projects/-home-comdare/5a19728e-.../subagents/
workflows/wf_*/journal.jsonl (Verzeichnis-Anlagezeit = Start, Journal-mtime = letzte Aktivitaet, Zaehlung
"started/result/err"-Zeilen; err = Riss-Tote VOR einem Resume, keine lebenden Fehler) + Task-Outputs
/tmp/claude-1001/.../tasks/*.output (Feld "summary" = Zweck, "agentCount" = Agenten des Laufs).

================================================================================================
## 1. DIE LETZTEN 10 WORKFLOWS (neuester zuerst; Zeiten UTC)
================================================================================================
 1. wf_1a36d148-ffb  EXPLORE 10 KONTEXTE K072-K081 auf offene + gerissene Arbeit (Owner-Order 07:3xZ)
    Start 02.09. 07:35 | LAEUFT: 10/10 Sonnet-max-Scanner fertig, Fable-Reduce (Agent 11) aktiv, dann
    Refute + Fix | Journal 11 started / 10 result / 0 err | Board #174.
 2. wf_217f0221-b27  RASTER-NACHARBEIT 5 SCHRITTE (Nenner 277, F-038..F-040 + 36 Instanzen, V-110..V-148,
    A2.3a-Zulieferung, Verify) | 02.09. 07:07 - 07:49 TERMINAL | 5 Agenten (4 Schreiber + Verify), Verify
    URTEIL = TRAEGT | Journal 10/5/3 (3 = Riss-6-Tote) | Task wlvap6kg6, 2,12M Tokens | Board #170 completed.
 3. wf_1c5577e4-8e5  VOLLLESUNG r18-r30 MAP-REDUCE (Rueckkehrer des Rueckfragen-Audits/Merge-Workflows, die
    den Lead-Kontext sprengten; Owner-Order "ultracode mit map reduce") | Start 02.09. 07:03 | LAEUFT: 18/18
    Leser fertig, Reduce-Konsolidator (Agent 37) schreibt REDUCE-VOLLLESUNG-r18-r30-R1-R4-WACHE.md |
    Journal 37/18/15 (15 = Riss-6-Tote 07:09Z, Resume 07:12Z byte-unveraendert) | Board #171.
 4. wf_bfe3433a-5dd  RASTER W-2/V-109 (Owner-Fakten vs 37er-Tafel + vergessene Arbeit vs R1-Tafel ueber alle
    30 Kontext-Maps) | 02.09. 00:19 - 07:02 TERMINAL (1 Riss + Resume) | 7 Agenten | Ergebnis: Nenner 277
    statt 187, 28 U-01..U-28, 9 N-01..N-09, 11 H, 39 V-Fehlposten -> V-110..V-148 | Tasks wwgwh8hi7/wioiyb29h.
 5. wf_1fcc434d-23e  MERGE = 30-KONTEXTE-TRACE + NACHFOLD (das "Rueckfragen-Audit"; Owner 01.09. 18:21Z +
    18:3xZ) | Resume-Lauf 01.09. 19:46 - 02.09. 00:15 TERMINAL (Kette R0a->R6, 3 Resumes K27-sauber) |
    69 Agenten, 4,95M Tokens | Journal 82/70/3 | Ergebnis: Q1 Herkunft der Rueckfragen-Kette seit 20.08.,
    Q2 Rewrite-Verluste RV-1..RV-10, Q3 Nachfold (37 Owner-Fakten F-001..F-037 in die Kopie, 0 Kipps),
    R1-Tafel 109 vergessene Posten, O-1..O-29 + V-090(a)-(v) Owner-Entscheide, A2.3a-EINGANG (61 Fragen) |
    Task wiz02js0s | Board #168.
 6. wf_6a56ad4d-494  E-1 ABSCHLUSS (letzter Fund S-13 -> K17 r5 -> Re-Bewertung -> ce-Landung A2.1a
    53150058) | 01.09. 19:02 - 21:29 TERMINAL | 4 Agenten | Task wgy1kcv1s | Board #160.
 7. wf_d102ab04-ba6  E-1 BAU rules-skip-Fix (Mess-Batch smoke/full -> on_success, sonst never; F2-Wache;
    13 Fixes S-1..S-13, K17) | 01.09. 12:54 - 18:51 TERMINAL | 14 Agenten | Tasks wprc72fi7/bpzo3ufsn.
 8. wf_4fc4b8d9-01b  E-4 THESIS 289 Secret-Audit der Vor-Rewrite-Historie (blind gegen Vault) + Rewrite
    KAPPEN (cbefa617) | 01.09. 09:56 - 13:28 TERMINAL | 6 Agenten | Journal 7/6/1 | Task whuirq9pc |
    Board #161; Nebenfund 289-runners_token im Agent-Transkript -> #152.
 9. wf_38c58b96-0b7  E-1 CI-ZOMBIE-FIX Explore + Design (F1-F10) | 01.09. 09:53 - 12:42 TERMINAL |
    4 Agenten | Journal 5/4/1 | Task wcq7dug1c.
10. wf_50f25326-cd6  RUECKFRAGEN-TRACE 0109 (erster Anlauf des Rueckfragen-Audits) | 01.09. 08:47 |
    LEER: 4 started / 0 result, alle 4 Transkripte enden 08:47:29Z "[Request interrupted by user]";
    Gegenstand ging in wf_1fcc434d (Nr. 5) auf (KON137-05(d)).
Davor (fuer den Fakt in Abschn. 2 unverzichtbar):
11. wf_e1751971-949  VERIFY Stempel-2-Fix-Zug/super-Bump | 30.08. 20:47 - 01.09. 13:27 | 5 Ag. | #147.
12. wf_fe1cf67c-94e  FOLD (157 Rueckfragen-IDs -> WANDERT_NACH_A / BLEIBT_REST; Fold-R2 REST nach Riss 3,
    Reduce in Batch-Phasen, 16 Refuter/Fix in 4 Wellen) | 30.08. 09:32 - 01.09. 19:39 TERMINAL |
    108 Agenten im Resume-Lauf, Journal 120/109/7 | Ergebnis NEUER-LEDGER (18345 Z.): 97 WANDERT / 60 REST |
    Task wsf251spt | Board #159.
Zaehlwerk: 12 Workflows seit 30.08. 09:32; 5 davon mit Riss + Resume (Nr. 3, 4, 5, 12 mehrfach; Nr. 10 leer);
2 laufen (Nr. 1, 3); 1 leer (Nr. 10); 9 terminal.

================================================================================================
## 2. DER FAKT: FOLD-REST + RUECKFRAGEN-AUDIT MUSSTEN ZUSAMMENGESCHALTET WERDEN
================================================================================================
(1) Der FOLD (Nr. 12) allein lieferte 157 Rueckfragen-IDs mit Endstand 97 WANDERT_NACH_A / 60 BLEIBT_REST. Er
    faltete NUR die 12 Rueckfragen-Sektionen S01-S12 der Ledger-Synthese (Quelle: 20260824-rueckfragen-
    synthese2/NEUER-LEDGER-konsolidiert-owner-antworten.md). Was NICHT in diesen Sektionen stand, konnte der
    Fold nicht kennen: Owner-Worte in den Kontexten 20.08.-01.09., vergessene Session-Zusagen, Rewrite-
    Verluste der Ledger-Konsolidierung (RV-1..RV-10; T-3 = Kern-Rueckstand, T-9 verwaist).
(2) Das RUECKFRAGEN-AUDIT (Nr. 10 leer -> Nr. 5 MERGE) las die 30 Kontexte K052-K081 des Transkripts
    unabhaengig vom Fold und fand: 109 vergessene Posten (R1-Tafel, spaeter 148 nach V-109-Pass), 37 -> 40
    Owner-Fakten (R3), 29 Owner-Entscheide O-1..O-29 + 22 V-090-Punkte, 35 nie zugestellte F2-Fenster-Bloecke
    (V-115) + 3 NEUE Fragezeilen (V-02/V-10/V-11) -- alles Gegenstaende, die der Fold-REST NICHT enthielt.
(3) Umgekehrt enthielt das Audit NICHT die 60 Fold-REST-Fragen als Entscheidungs-Tafel; erst der NACHFOLD
    (Teil von Nr. 5) schrieb die Audit-Funde additiv in die Fold-KOPIE (18345 -> 20793 Z., Original md5
    unveraendert, 0 Status-Kipps der 157), und der A2.3a-EINGANG (189 Z.) vereinigte 60 REST + 1 E-4-Rest +
    O-1..O-29 + V-090 zu 61 + 29 + 22 Vorlage-Zeilen.
(4) Selbst diese Vereinigung war nicht vollzaehlig: die NACHFOLD-WACHE fand W-1..W-5, das RASTER (Nr. 4)
    hob den Owner-Fakten-Nenner von 187 auf 277 (26 -> 30 Maps), 28 UNGEDECKTE Owner-Worte, 9 Instanz-
    Luecken und 39 vergessene Posten (V-110..V-148); die NACHARBEIT (Nr. 2) spielte sie ein (Verify TRAEGT).
(5) FOLGE: Es gibt KEINE Einzelquelle, die alle offenen Rueckfragen traegt. Der geltende Vollbestand ist die
    UNION aus: Fold-Kopie (157 IDs, 97/60) + R1 V-001..V-148 + R3 F-001..F-040 + O-1..O-29 + V-090(a)-(v) +
    U-01..U-28 / N-01..N-09 + A2.3a-RASTER-ZULIEFERUNG (35 + 3) + OG-1..OG-58 (nur session-lokal!) -- mit SIEBEN
    verschiedenen Nummernkreisen, die sich ueberlappen (z.B. S06/B-21(ii) == O-13 == A-3; S08/B-10 == O-10
    == A-1; S04/B-04 == O-11 == A-2). Jede Vorlage muss diese Dopplungen VOR dem Versand auf EINE Zeile je
    Gegenstand falten (A2.3a-Workflow: Strang-Dopplungs-Probe + NEIN-Probe) -- sonst fragt sie doppelt oder
    laesst Gegenstaende aus, weil sie nur einen Nummernkreis abfragt.
(6) URSACHEN (aus Q1/Q2 des Audits): Rueckfragen-Kette seit Wurzel 20.08. ueber M1-M12 mit 6 Beweggruenden;
    Ledger-Rewrites verloren Posten (RV-1..RV-10); 6 Risse (Spend-/Session-Limit) zwischen 27.08. und 02.09.
    mit Resumes, bei denen Zwischenstaende nur im Journal-Cache lebten; Owner-Portionierung F-018 und
    Kontext-Kappen erzwangen Map-Reduce-Lesung statt Lead-Volllesung.
(7) KONSEQUENZ FUER DAS DICHTE LEDGER: KON137-09 traegt diesen Fakt; die Rueckfragen-Sektion des naechsten
    Ledgers muss den Vollbestand als EINE Tafel mit EINEM Nummernkreis (Gegenstand -> alle Alt-IDs als
    Aliasse) fuehren; die OG-Serie (session-lokal) ist dort zu materialisieren, sonst geht sie mit der
    Session verloren (S11/B-06 = genau diese Warnung).

Selbstcheck: ASCII; Zeilen <= 120; Zahlen aus Journalen/Task-Outputs/Lesequittung; keine Owner-Zitate erfunden.
