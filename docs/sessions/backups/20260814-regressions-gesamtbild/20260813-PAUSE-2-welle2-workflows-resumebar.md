# PAUSE 2, 13.08.2026 — WELLE 2 UNTERBROCHEN, ALLE WORKFLOWS RESUMEBAR

> Owner-Order: abbruchsichere Pause, alle Workflows pausiert. Drei liefen, per TaskStop sauber
> gestoppt, WIP committet. NICHTS ist gepusht seit a103e518 (super) / b7ffecb->6d7fc83 (Umbrella).

## 1. DIE DREI GESTOPPTEN WORKFLOWS — RESUME (Scripts unter
## /home/comdare/.claude/projects/-home-comdare-wt-super-landung/.../workflows/scripts/ bzw. -Projekte-)

    S-7      Workflow({scriptPath: ".../s7-achsen-algo-hardware-stempel-wf_81efb13f-45b.js",
             resumeFromRunId: "wf_81efb13f-45b"})
             WIP: wt-ce-mess-ordnung, Branch bau/s7-algo-hardware-stempel @ ec3c71fa (Agent
             committete selbst, Baum sauber). VOR Resume: Bau-Prompt um Hinweis ergaenzen,
             bestehenden Branch/Commits zu uebernehmen statt neu anzulegen.
    WACHEN   Workflow({scriptPath: ".../wachen-paket-floor-nachzug-und-inventar-wf_b6b05f65-923.js",
             resumeFromRunId: "wf_b6b05f65-923"})
             WIP: wt-ce-wachen, Branch bau/wachen-floor-inventar @ c0ff9986 (WIP-Commit
             UNGEPRUEFT ueber 0fbcb049). Gleiche Prompt-Ergaenzung.
    F1-LENS  Workflow({scriptPath: "(-Projekte-).../f1-paket-dual-lens-wf_61f2b36f-712.js",
             resumeFromRunId: "wf_61f2b36f-712"})
             wt-f1-1x1 sauber @ c134b70a — Lenses replaien ggf. aus Cache; journal.jsonl
             wf_61f2b36f-712 VOR Resume lesen (welche Lenses fertig waren).

## 2. STAND (alles lokal, NICHTS ungesichert)

    super development @ a103e518 == origin; 8 lokale Commits DAVOR bereits da? NEIN:
      8 lokale Commits a103e518..f3017a77 (Luecken-Stufe 2 + Fixes) LOKAL — Sammel-Push
      kommt mit der Drei-Stufen-Landung. Branches: bau/e21-vollzug-a1 (3 Commits),
      bau/texlive-gate-haertung (4), wip/luecken-stufe2-pause-1308 (Sicherung).
    ce  development @ 5f3f26a5 == origin (CI 15785 success, Gitlink f6829547 gelandet).
      Branches: bau/f1-1x1-honest-empty @ c134b70a (F1-Fix, Dual-Lens teils offen),
      bau/s7-algo-hardware-stempel @ ec3c71fa, bau/wachen-floor-inventar @ c0ff9986,
      bau/p6-lizenz-umsetzung @ f6d13dfb (Triage-LANDEN-Fall).
    Umbrella @ 6d7fc83 (v4.3) gepusht; CI dort strukturell rot (macos/win, seit 06.03.).

## 3. NACH DER PAUSE — REIHENFOLGE (Owner-Order vom 13.08. bindend)

    1. Drei Workflows resumen (S. 1), Ergebnisse VOLLSTAENDIG lesen (alle Verify/Fix-Felder).
    2. Findings in die Sammelliste nachtragen:
       $CLAUDE_JOB_DIR/tmp/welle2_findings_sammelliste.md (43 Punkte, waechst).
    3. REGRESSIONS-GESAMTBILD liegt bereit: $CLAUDE_JOB_DIR/tmp/regressions-gesamtbild/
       (152 Workflow-Outputs beider Kontexte + Dumps + Designs + 00-INDEX.md).
    4. OWNER-VORLAGE stellen: ALLE offenen Rueckfragen/Entscheidungen gebuendelt (C-3a
       Mi 19.08. · MinIO-Keys · A-3-Token · E-4c Test-Skip · E-2-Kenntnisnahme ·
       F-G1-11/-12 + F-G1-Fragen · Umbrella-CI · ##26-Formel + Neuzugaenge der Resumes).
    5. NACH Owner-Antworten: DREI-STUFEN-LANDUNG (v4.3/A2.1b): serielle Merges mit
       Harmonisierung -> KOMPLEX-FIX (ein Fable-5-max-WF; Auftrag = Sammelliste +
       Gesamtbild; Merge-Regressionen + ALLE Findings in EINEM Paket) -> EIN Push, EINE CI.
    6. Danach F1-Echtlauf (bash-Rezept!) + 288-Gitlink beide Thesis-Zeiger + E-18-SNAP.

## 4. AUFLAGEN unveraendert: Fable 5 max bis Widerruf · Luecken immer Pflicht · A2.5 +
## Komplex-Fix · Vault blind · nie rebase · kein add -A · Pipelines nie canceln ·
## gitleaks glpat-+20 aus wirksamer Config · Drei-Bauten-Deckel · ein Schreiber je Worktree.
