# HY-A UEBERGABE-KONTEXT von hy-a-bau (17.08.2026 18:42, Teammate-Nachricht an Lead)

Quelle: Teammate-Session hy-a-bau, Uebergabe-Annahme nach Ein-Schreiber-Klaerung.
Worktree: ~/wt-ce-hy-a, Branch bau/hy-a-hybrid-struktur. HEAD zum Zeitpunkt der
Nachricht: a4366cb8 (der Workflow-Fix-Strang hatte bereits committet; vorher e3fc1390).

## WARNUNG (den Fix-Strang direkt betreffend)
Im Baum liegt NOCH EINE uncommittete Aenderung von hy-a-bau:
    M tests/unit/test_rcu_concurrency.cpp
Reine KOMMENTAR-Aenderung: praezisierte Terminierungs-Begruendung der Anlauf-Sperre
(Inhalt unter (3)). Uebernehmen oder verwerfen — verlustfrei wegwerfbar, Inhalt hier.

## (1) KOEDER-BEWEIS ERBRACHT (Protokoll: build-protokolle/20260817-FIXRUNDE2-koeder-nachbesserung.log)
    REFERENZ_RC=0 -> KOEDER_RC=1 -> NACH_RESTORE_RC=0
Assert-Text literal (Zeile 232): "zwischen erster und letzter Writer-Generation wurde
nicht ein einziges Mal gelesen ... der Test wuerde seinen Gegenstand (Churn WAEHREND
synchronize()) verfehlen, statt ihn zu pruefen". Der Schnappschuss-Waechter KANN fallen
— Tautologie nachweislich weg. Wichtig: rc=1 (Assert), NICHT 124.

## (2) ERSTER KOEDER WAR UNTAUGLICH — nicht wiederholen
kReaderEnde=0 lief in den ctest-Timeout (rc 124) statt in den Assert: kein Reader betritt
je den Schleifenrumpf, angelaufen bleibt 0, die ANLAUF-SPERRE wartet endlos. Tauglicher
Koeder: stop.store(true) DIREKT HINTER die Anlauf-Sperre — Reader sterben nach Anlauf und
vor der ersten Generation, Differenz bleibt null, Waechter schlaegt mit seinem Text an.

## (3) INHALT DER UNCOMMITTETEN KOMMENTAR-ZEILE
Die Terminierung der Anlauf-Sperre haengt seit dem Writer-Kopplungs-Umbau an ZWEI
Bedingungen, nicht mehr nur an stop: Threads sind erzeugt, stop ist false UND generation
steht auf 0 (unter kReaderEnde) — nur deshalb durchlaeuft jeder Reader mindestens einmal
den Rumpf und erhoeht angelaufen. Die alte Begruendung nannte nur stop (unvollstaendig).
Wer kReaderEnde veraendert, muss sicherstellen, dass es beim Start groesser 0 ist.

## (4) SERIEN-ZAHLEN DER ENDFASSUNG (Protokoll: build-protokolle/20260817-FIXRUNDE2-abnahme-endfassung.log)
20/20 ohne Last + 2 x 40 GLEICHZEITIG unter 32-Prozess-Last = 80/80 gruen; FIX-4-Test
gruen; lint_layer_includes rc=0. Bewusst 2x40 statt 2x25: die Vorfassung hatte 3/50 rot —
eine 25er-Serie haette das mit ~50 % Wahrscheinlichkeit verfehlt.

## (5) ZWEI DIMENSIONIERUNGS-FALLEN (je eine Fassung gekostet)
a) Feste Reader-Rundenzahl als "Notbremse" liegt in DERSELBEN Groessenordnung wie die
   Writer-Phase und wird zum RENNEN: mit 200000 spulten Reader in 3/50 Laeufen ihr Budget
   ab, BEVOR die erste Generation publiziert war (Waechter zu Recht rot, Code in Ordnung).
   Endfassung hat GAR KEINE Rundengrenze; Reader wird nur vom Writer beendet (kReaderEnde,
   dann stop). Haengender Writer faellt als ctest-Timeout auf.
b) EXPECT_LT auf "Notbremse hat nicht gegriffen" faerbte 46/50 rot — mass Interna statt
   Gegenstand. Entfernt.

## (6) LASTMARKEN-REZEPT (Lens-Fund 6)
Je Serienabschnitt: "LASTMARKE <phase> | $(date -Is) | $(uptime | sed 's/.*load average/load/')"
VOR der Serie, nach dem Anwerfen der Last und NACH der Serie. Last: 32 Hintergrund-
Schleifen ( while :; do :; done ) &, PIDs merken, am Ende kill. Zwei Serien parallel als
eigene Shell-Funktionen mit wait — gruene Haelfte genauso falsifizierbar wie die rote.

## (7) OFFEN / LANDUNGS-AUFLAGEN
- F-9 (Sichtbarkeits-Sentinel): begruendet vertagt auf HY-A2.
- TSan-Anspruch des Tests: in keiner Runde belegt.
- 498/499-Deckung des Endstands: Landungs-Auflage (Kombibau einmal live).
- FLOOR-LANDE-MESSUNG (Rezept): kalter build-covguard, CI-Form MIT
  -DCOMDARE_CE_PRUEFLINGE, J-1-Muster, drei Klassen erzwingen, cmake -U mit
  Wiederherstellungs-Beweis, LC_ALL=C comm beidseitig, Zaehlbasis "Total Tests: N" mit
  Listenlaengen-Gegenprobe, Schalter-Zustand literal aus dem CMakeCache ins Protokoll.
