# SESSION-PAUSE 18.08.2026 (Credits) — WIEDERANLAUF-REZEPT + AUDIT-VOLLSTAENDIGKEITS-AUFTRAG

> Owner-Order (18.08., verbatim): "Bitte lege eine abbruchsichere Pause ein, die Fable credits
> sind gleich leer. Lass den workflow auslaufen, nimm bis zum auffrischen der credits keine neue
> Arbeit auf. Kann es sein, dass das audit jetzt kuerzer ist als vorher - ich wuerde ein
> vollstaendiges Audit bevorzugen."

## 1. ANTWORT AUF DIE AUDIT-FRAGE: JA, ES WAR VERKUERZT — WIEDERANLAUF FAEHRT VOLL

Das laufende Audit (wf_794b904b) ist gegenueber dem Anspruch "vollstaendig" DOPPELT verkuerzt:
1. SPEND-LIMIT-AUSFALL STILL: 4 von 8 Ledger-Segmenten (seg2/3/4/8 = Ledger-Zeilen ~4001-16100
   + ~28001-32200) starben im Erstlauf am Limit. Der Resume laesst sie neu laufen — aber der
   Null-sicher-Fix (noetig gegen den Synthese-Crash) FILTERT einen erneut sterbenden Agenten
   jetzt STILL heraus. Ein Audit-Ergebnis ohne Segment-Vollzaehligkeits-Pruefung kann fehlende
   Segmente nicht melden.
2. SAMPLING IM DESIGN: die Ist-Verifikation deckelte auf 14 Pruefpakete (slice(0,14)) — bei
   grosser Zusagen-Menge wird NICHT jede Zusage verifiziert.

WIEDERANLAUF-AUFTRAG (bindend): Audit NEU aufsetzen als VOLL-AUDIT —
- alle 8 Ledger-Segmente + 3 Session-Gruppen mit VOLLZAEHLIGKEITS-GATE (fehlt ein Segment-
  Ergebnis => Audit-Ausgabe ROT "SEGMENT N FEHLT", nie stille Reduktion);
- Ist-Verifikation OHNE slice-Deckel: ALLE HOCH- und MITTEL-Zusagen pruefen (Pakete dynamisch:
  ceil(n/12) Pakete);
- Kontext-Audit-Lenses (doktrin-treue, beweis-vollstaendigkeit, owner-wort-treue) unveraendert;
- Synthese erst, wenn Vollzaehligkeit belegt.
Das gefixte Script liegt unter (Session-Verzeichnis) workflows/scripts/
owner-audit-ledger-ist-soll-wf_794b904b-d1c.js — als BASIS verwenden, Deckel entfernen,
Vollzaehligkeits-Gates einbauen. Cache-Resume NUR fuer die Soll-Karten-Phase nutzen
(resumeFromRunId wf_794b904b-d1c), Verifikation+Synthese IMMER frisch.

## 2. STAND BEI PAUSE (alles committet/gepusht ausser dem benannten Worktree)

GELANDET+CI-GRUEN (dual-remote): ce development = 20c111c4 (CI 15979) · super development =
0671a24c (CI 15980/15982/15983) · KON113-KON118 im Ledger · Wellenplan P.20.1-20.10 · #92=S-22 ·
E-6-Phantom-Nenner-Verdikt · Tasks #20/#70/#80/#81/#92 nachgebucht.

UNGELANDET, VOLLSTAENDIG COMMITTET: ce-Worktree /home/comdare/wt-ce-bump15, Branch
bau/bump15-preimage-bruch, Tip 67dafa46 (25 Commits auf 20c111c4; letzte zwei = Hygiene-Fixes
des Leads). Inhalt = das komplette #15-Bump-Buendel: Layout 6->7, Format 4->5, GliedCount 9->10,
Budget 8192, S-6a-Ordnung, HY-A2-Proxy+2 .so+F8-Test, HY-A3-Gate 5->6, work_mode-Umbau (P1),
Gate-Grammatik 7->9 (P2), anatomy_name_hex+POD 152/Codegen 8.2 (P4+P3), Compose-Bausteine (P5),
K13-Koeder alle gebissen (P6), 7 stale-Heilungen (P9), Verbund-Rename V-11R komplett (Q1,
TABU-CRC 0x56F1B721C72DC10E UNBEWEGT [MATCH]), 6-Symbol-ABI+Riegel (Q2/R2), Warnungs-Null
110->0 (R0), clang-Rot geheilt via ENABLE_EXPORTS (R1, -fassume-unique-vtables-Verdikt).
ABNAHME-STAND: gcc-release 503/503 + Wache GUARD_EXIT=0 + Floor 503/499/497 + clang-release
502/502 (vor R2) + gcc-debug 499/499 + kumulative Hygiene-Wache GRUEN (195 Commits) + gitleaks
Koeder biss/Echt clean. OFFENE RESTE (benannt): clang-debug-Zelle PIE/HDR-Link-Rot
(vorbestehend/neu-sichtbar) · Lock-Regen = Lande-Schritt (4 Traeger "(- -> -)") · clang-Zelle
nach R2 nicht wiederholt · E-B/A-11-Stempel-Pflicht = golden-gebundener Folgezug · lokale
clang-format-22-Alignment-Anomalie (122 vs 120, Datei-Standard manuell normiert; CI-lint:format
entscheidet).

SUPER-HAELFTE VORBEREITET (uncommitted im super? NEIN — als Patch gesichert):
~/.claude/jobs/5a19728e/tmp/super_xsd_golden_verbund.patch (113 Z.): XSD-Dreier-Enum
Verbund1/2/3 + Prosa :39/:333-335 + experiment_golden_kern.xml/experiment_golden.xml
Verbund-Namen. Wird beim super-Lande-Zug ATOMAR mit dem Gitlink eingespielt (Subset-Wache
koppelt Fixture+XSD).

REVIEW-MATERIAL (untracked, absichtlich): /home/comdare/wt-ce-bump15/.review-tmp/ (4 Lens-
Prompts + 2 Diffs) — vor der Landung loeschen. Diffs auch unter ~/.claude/jobs/5a19728e/tmp/
(l1a/l1b/l1c/l2a/lens2b*.diff).

## 3. LAUFENDE PROZESSE (auslaufen lassen, NICHT stoppen)

- Audit-Workflow wf_794b904b (Task w4nd6h751): laeuft aus; Ergebnis-Fragmente im journal.jsonl.
  Stirbt er am Limit: Journal = Wahrheit; Wiederanlauf nach Abschnitt 1.
- Codex Lens A (Task kc7vkh7l2) + Lens D (k0p6iutfc): kosten KEINE Fable-Credits; Ergebnisse
  kommen als Task-Notification. bwrap-Erkenntnis: workspace-write liest NUR unterhalb cwd —
  Material muss IM Worktree liegen (.review-tmp/); Pfade ausserhalb (~/.claude/...) scheitern.
  Lens B/C (Prompts fertig in .review-tmp/) NACH Wiederanlauf starten.
- CI: keine offenen Pipelines; letzte Staende alle SUCCESS (ce 15979, super 15983).

## 4. WIEDERANLAUF-REIHENFOLGE (nach Credit-Auffrischung)

1. Diese Datei lesen + Task #15-Metadata ("pause_20260818").
2. Codex-Ergebnisse A/D ernten (Notifications/Threads); Lens B/C starten (Workspace-Pfade!).
3. VOLL-AUDIT nach Abschnitt 1 fahren (Vollzaehligkeits-Gates, kein slice-Deckel).
4. Befund-Synthese Workflow+4 Lenses -> A2.5-FIX-Stufe (Fable max) fuer ALLE Funde.
5. LANDUNG: (a) offene Bruch-Reste (clang-Wiederholung nach R2, ggf. clang-debug-PIE-Posten
   benennen), (b) .review-tmp loeschen, (c) ce-Merge --no-ff mit voller Gate-Kette + Wellen-
   Ende-Gates (Lock-Regen am ENDSTAND + kumulative Hygiene), (d) EIN Push, EINE CI,
   (e) super-Zug ATOMAR (XSD-Patch + golden + Gitlink + PZW neu messen + KON119 mit
   Namensnennung bump15-a/b/c/d), (f) F2-Vorlagen an Owner (AxisKind-Drehung, E-6-Satz,
   KON60-04, C-3a-Frist Mi 19.08.).

Sicherheitsauflagen unveraendert (Vault nie greppen, Transkripte nie committen, nie rebase,
Koeder glpat-+20 mit Laengen-Assert, AskUserQuestion nie, CI nie canceln, Messdaten nie
loeschen, Doku nur deprecaten).
