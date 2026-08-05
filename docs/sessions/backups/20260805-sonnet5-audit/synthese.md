# SYNTHESE Sonnet-5-Audit (Fable, adversarial)

Datum: 2026-08-05, abend. Grundlage: transkript.md (Transkript-Lens, Fenster L105382-105520,
16:01:10Z-16:09:33Z) + objekt.md (Objekt-Verifikations-Lens, read-only am Repo/API/Session-Store).
Massstab: Arbeitsweise v2.1 + Session-Vereinbarungen (Ledger-Punkte 1-9 laut Auftrag).

---

## GESAMT-VERDIKT

Sonnet hat die Not-Uebernahme unter Kreditsperre (~8,5 Minuten, kein eigener Bau, keine eigene
Landung) ueberwiegend gruendlich nach Arbeitsweise gefuehrt: Ist-Erhebung git-belegt statt geraten,
ANKER-GENAU-EINMAL per S0-Waechter respektiert, der einzige Commit der Phase (super docs 01b6f48c)
in voller Landungs-Kadenz (Secrets-grep, gitleaks podman, CI-Wache am VOLL-SHA, gepinnter main-FF),
Owner-Gate O-2 sauber markiert und vorgelegt, Task-Board ehrlich neu aufgesetzt, Doku additiv,
Dual-Review-Pflicht unverwaessert fortgeschrieben — und die Objekt-Lens hat KEINE einzige
Sonnet-Behauptung widerlegt (alle 8 Prueffelder bestanden). Nicht gut war die Wiederanlauf-Logik:
alle drei Wellen wurden per resumeFromRunId BLIND neu gestartet, bevor Ledger oder Objekt-Ist
geprueft war — bei unvollstaendigem Cache haette das Opus-Bau-Agenten in den eingefrorenen,
ungelandeten wt-e24-Fremdstand gesetzt und die ANKER-GENAU-EINMAL-Disziplin gefaehrdet (glimpflich
nur dank Cache). Zweitens uebersah der Reconcile, dass die Luecken-Session noch lebende Akteure
hatte: wt-w2fix erhielt nach Sonnets Momentaufnahme einen dritten Commit, die persistierte Meldung
"2 saubere Commits" wurde ohne Vorbehalt zur Wahrheit erklaert. Dazu zwei geringe Literalitaets-/
Sorgfaltsluecken (Erfolgsformel vor Beleg; Roh-Backup ohne Redaktionspass). Netto: disziplinierte,
schadensfreie Phase mit zwei mittleren Prozess-Befunden in der Wiederanlauf-Doktrin — kein Befund
am Repo-Stand selbst.

Zum nachmittag-6-Selbstbefund (Codex-Review-Versaeumnis, bereits eingestanden): Die Korrektur war
soweit pruefbar VOLLSTAENDIG — Codex-Nachbewertung A2 verbucht (backups/20260805-a2-codex-bewertung,
Commit 8baa7082), Dual-Review-Regel im Reconcile zementiert, die zwei ungereviewten Wellen
(w2-codex-fixes, w5-w3-kern) korrekt als "gebaut, NICHT gelandet" gefuehrt. Kein Doppel-Anrechnen;
der verbleibende Rest ist regulaere laufende Kadenz.

---

## BEFUNDE FINAL (dedupliziert; je: Schweregrad + Objekt-Folge)

1. **MITTEL — Blind-Resume vor Ist-Check** (Transkript-Befund 1). Alle drei Wellen inkl.
   anker-a2-eich-welle per resumeFromRunId gestartet (L105383-105392, 16:01:11-13), erster
   Ist-Check erst L105415. Verstoss gegen "Immer Ledger zuerst" + ANKER-Vorsicht (Massstab 8).
   Objekt-Folge: KEINE — alle agent()-Calls waren gecacht (Completions 1-2 s), kein Agent lief
   real an. Reiner Prozess-Befund mit realem Gefaehrdungspotenzial (Working-Tree-Freeze wt-e24,
   GENAU-EINMAL).

2. **MITTEL — Lebender Fremd-Akteur im Reconcile uebersehen** (Transkript-Befund 2). "Vollstaendige
   Wahrheit erhoben" (L105471) ohne Lebend-Check der Luecken-Session da4c8f70 (kein ps/pgrep, keine
   Fremd-Task-Enumeration). Belegte Folge: wt-w2fix 16:04:59 = 2 Commits (0a2047cd), 16:53 =
   3 Commits (e3fc1b98) — ein Akteur der Vorsession schrieb weiter. Objekt-Folge: kein falscher
   Repo-Stand (der 3. Commit ist legitime Weiterarbeit der Vorsession), aber die persistierte
   Owner-/Ledger-Aussage "Fix bereits gebaut (2 saubere Commits)" ist eine unmarkierte, inzwischen
   veraltete Momentaufnahme — Ledger-Praezisierung noetig.

3. **GERING — Erfolgsformel vor dem Beleg** (Transkript-Befund 3). "0 neue Tool-Calls" (L105402/
   105414) war Inferenz ohne zitierte Ausgabe; Atlas-/Konsolidierungs-Outputs nie direkt gelesen.
   Objekt-Folge: KEINE — Aussagen trafen objektiv zu (spaeterer git-log-Beweis). "Kein Erfolg ohne
   woertliche Ausgabe" im Aussage-Moment nur teilerfuellt.

4. **GERING — Roh-Backup ohne Redaktionspass committet** (Transkript-Befund 4). ergebnis-roh.json
   (42 KB, w5-w3-kern) nach Secrets-grep (literal 0) + gitleaks (no leaks) mitverbucht, aber ohne
   deklarierte inhaltliche Sichtung (Massstab 7 "redigiert"). Objekt-Folge: keine bekannten
   Secrets/Token im Commit (doppelt geprueft); der Editorial-Pass fehlt als Schritt.

5. **GERING — Gate-Formel unpraezise** (Objekt B-2). "COMDARE_OVERLAY_SOURCE_HASH genau EINE
   Fundstelle" stimmt nur funktional (1 Definitions-Naht anatomy_fingerprint.hpp:83-86); literaler
   grep an 18fbb950 = 9 Zeilen in 7 Dateien (8 Kommentare). Objekt-Folge: KEINE — Zustand korrekt,
   Formel kuenftig als "genau EINE Definitions-Naht" fuehren.

6. **GERING — Literalitaets-Luecke Gate-Zahlen** (Objekt B-3, klassenbedingt). Die Doppellaeufe
   2x404/2x405 seriell am Commit-Objekt sind NUR commit-/ledger-attestiert; kein CI-Artefakt
   traegt 404/405 (CI faehrt Kanon-Teilmenge 357/362, Messung AUS). Objekt-Folge: KEINE —
   Gegenwarts-Reproduktion 405 via ctest -N in beiden Build-Dirs gelungen; Wachstum 403->404->405
   exakt die 2 neuen TUs. Restrisiko gering; Literal-Persistenz kuenftig ins Wellen-Backup.

7. **KLEIN — super-Merge 409757b0 ohne eigene Pipeline am Merge-SHA** (Objekt B-4). CI-Wache lief
   am Folge-Head 8baa7082 (14698/14699 success, enthaelt 409757b0) — im Ledger deklariert.
   Objekt-Folge: KEINE — transitiv gedeckt; strenge Lesart "Wache am Merge-VOLL-SHA" nur
   transitiv erfuellt.

8. **HINWEIS (Audit-Input, NICHT Sonnet)** (Objekt B-1). Das roh/-Fenster der Transkript-Lens
   enthaelt die 4 Owner-Bloecke nur als Ledger-Read-Echo — Verbatim-Pruefung allein darauf waere
   zirkulaer. Hier ausgeglichen: Direktpruefung am Session-Store b15ade0e, alle 4 Bloecke EXAKT
   (inkl. 2x queued attachment.prompt — E-21-Falle erfuellt).

**Objekt-Bilanz: NICHTS am Repo-Stand ist falsch.** Rescue-Refs beide Remotes, tree-identische
--no-ff-Merges, CI success an beiden ce-VOLL-SHAs (14659/14674; ROT 14673 ehrlich deklariert),
TABU-/Fingerprint-Diffs 0, Frozen-Vektor in genau 3 TUs, golden-CRC-Traeger unveraendert,
3-Marker-grep 0, Gitlinks korrekt, alle 4 Owner-Bloecke verbatim, Backups je Welle vorhanden,
Atlas REV4/5-Merkmale real. Alle Befunde sind Prozess-Befunde.

---

## KURS-KORREKTUREN (jetzt anwendbar, ohne die laufende Dual-Review-Kadenz zu stoeren)

1. **Wiederanlauf-Doktrin persistieren** (Ledger-Nachtrag + Memory): Nach Session-Abriss NIE
   resumeFromRunId/Wellen-Neustart vor (a) Ledger-Volltext, (b) Objekt-Ist (Remotes, Worktree-HEADs,
   porcelain), (c) Lebend-Check auf Fremd-Session-Akteure (pgrep auf laufende Agenten/Workflows,
   Task-/Workflow-Enumeration, Worktree-HEAD-Vergleich vorher/nachher). Deckt Befunde 1+2 an der
   Wurzel.

2. **Ledger-Praezisierung nachmittag-10** (additiv): wt-w2fix-Angabe "2 saubere Commits
   (db9cc553+0a2047cd)" als Momentaufnahme 16:05 kennzeichnen und Ist nachtragen (3. Commit
   e3fc1b98 durch Vorsession) — damit der anstehende W2-Dual-Review (Codex+Fable) den VOLLEN
   Commit-Satz abdeckt und nicht gegen die veraltete 2er-Angabe testiert.

3. **Gate-Formel schaerfen**: In kuenftigen Gate-/Ledger-Texten "genau EINE Definitions-Naht
   (anatomy_fingerprint.hpp #ifndef/#define)" statt "genau EINE Fundstelle" (Objekt B-2).

4. **Doppellauf-Literal-Persistenz**: Ab sofort die woertlichen ctest-Doppellauf-Ausgaben (2x
   seriell, frisches Configure) in das Wellen-Backup (ergebnis-roh) aufnehmen, damit Gate-Zahlen
   objektbeweisbar werden; fuer 404/405 den heutigen Reproduktionsbeleg (ctest -N = 405 in beiden
   wt-w2fix-Build-Dirs) als Ledger-Notiz vermerken (Objekt B-3).

5. **Redaktionspass nachziehen + Kadenz-Pflichtschritt**: Inhaltliche Sichtung von
   backups/20260805-w5-w3-kern/ergebnis-roh.json mit deklariertem Vermerk (Secrets bereits doppelt
   negativ); "Redaktionspass ueber Roh-JSON" als expliziten Schritt in die Backup-Kadenz aufnehmen
   (Massstab 7).

6. **Punktuelle Nachverifikation Eich-BEFUND-2** (read-only, stoert nichts): Im Store der
   Luecken-Session da4c8f70 belegen, dass das gitleaks-Testat VOR Landung 18fbb950 real lief
   (Eich-Review verlangte es vom Lead); falls kein Beleg auffindbar, gitleaks ueber die Range
   24e07219..18fbb950 jetzt nachfahren und Ergebnis im Ledger verbuchen.

7. **CI-Wachen-Haertung** (naechste Wache, kein Eingriff in laufende): Zusaetzlich zum ersten
   status-Feld die Job-Liste der Pipeline pruefen (alle Jobs success ausser deklarierte
   manual-Jobs); bei super-Merges Wache am Merge-VOLL-SHA fahren oder Transitiv-Deckung ueber den
   Folge-Head EXPLIZIT deklarieren (Objekt B-4, Transkript nicht-pruefbar-Punkt 4).

---

## OWNER-RELEVANT

1. **Kein Schaden am Repo-Stand.** Die Objekt-Lens hat alle Landungen des Nachmittags (ce
   18fbb950 Gate 404, 3bf03b01, Hotfix 60c7c56a Gate 405; super-Kette bis 8baa7082 + 01b6f48c)
   in allen 8 Prueffeldern bestanden; keine Sonnet-Behauptung widerlegt.

2. **O-2 bleibt Ihre Entscheidung** — von Sonnet korrekt als Owner-Gate mit beiden Optionen und
   Kostenfolge vorgelegt, nichts still entschieden.

3. **wt-w2fix traegt inzwischen 3 Commits, nicht 2** (Vorsession schrieb nach Sonnets Meldung
   weiter, e3fc1b98). Der W2-Dual-Review vor Landung deckt alle 3 ab; die Ledger-Angabe wird
   additiv praezisiert.

4. **Sonnet-Not-Phase war diszipliniert** (kein Bau, kein Gate-Sprung, Voll-Kadenz am einzigen
   Commit); zwei mittlere Prozess-Befunde in der Wiederanlauf-Logik (Blind-Resume vor Ist-Check;
   Lebend-Check der Vorsession fehlte) — ohne eingetretenen Schaden, Doktrin wird nachgeschaerft.

5. **nachmittag-6-Korrektur vollstaendig** soweit pruefbar: Codex-Nachbewertung A2 verbucht,
   Dual-Review-Regel zementiert, ungereviewte Wellen korrekt als nicht-gelandet gefuehrt.

6. **Gate-Zahlen 404/405 sind lokal-attestiert** (CI faehrt kanon-gemaess nur die Teilmenge
   357/362, Messung AUS); heute unabhaengig reproduziert (405). Kuenftig werden die
   Doppellauf-Literalausgaben im Wellen-Backup persistiert.
