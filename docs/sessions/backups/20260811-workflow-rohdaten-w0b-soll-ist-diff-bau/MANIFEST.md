# WORKFLOW-ROHDATEN — Sicherung 11.08.2026

**Anlass:** Owner-Auftrag *„Bitte backup aller Rohdaten des Workflows so weit in einem backup
Ordner unter den sessions."* Danach wurde der Bau von parallel auf **sequentiell** umgestellt.

Rohdaten-Sicherungen sind **additiv und werden nie geloescht**. Dies ist eine Sicherung, keine
Auswertung — die Auswertung steht in den `*-workflow-ergebnis.md` daneben.

---

## WAS HIER LIEGT

| Datei | Inhalt | roh | gepackt |
|---|---|---|---|
| `lauf-wf_4579d7c4-37a.tar.gz` | **der laufende Workflow** (10 Pakete, SOLL/IST/DIFF/BAU/REVIEW) — Journal + 90 Agenten-Transkripte | 15 M | 6,1 M |
| `lauf-wf_80fa369e-9f9.tar.gz` | W0b-Restposten (r2, p4, GUARD_BASIS_REF, Lizenz, tote Anker) | 4,5 M | 1,3 M |
| `lauf-wf_200fefb7-5f7.tar.gz` | ce-Stempel + Warnstufe | 1,5 M | 460 K |
| `alle-journale.tar.gz` | **alle 211 `journal.jsonl`** dieser Session — die in Task #65 als „nie geerntete Quelle" benannte Menge | 21,4 M | 8,1 M |
| `w0b-soll-ist-diff-bau-dualreview-*.js` | das Workflow-Skript selbst, Fassung mit Platten-Auflage | — | 22 K |

**Auspacken:** `tar -xzf lauf-<run>.tar.gz` — legt ein Verzeichnis `wf_<id>/` an mit
`journal.jsonl` (eine Zeile je Agenten-Ereignis, `type: started|result`) und je Agent ein
`agent-<id>.jsonl` (vollstaendiges Transkript) plus `.meta.json`.

**Das `journal.jsonl` ist die Wahrheit**, nicht die Ergebnisdatei: ein Workflow kann stumm
sterben, und dann ist die fehlende Datei das einzige Signal.

---

## SICHERHEIT — und warum die erste Null nicht galt

Alle drei Laeufe sind vor dem Packen mit `gitleaks --no-git` gegen die repo-eigene
`.gitleaks.toml` geprueft: **`no leaks found`**, dreimal.

**Diese Null war zuerst unbelegt.** Die Gegenprobe (K13) hat es gezeigt:

    Koeder 1  glpat- + 19 Zeichen   ->  no leaks found     <- FALSCH-NULL, mein Koeder war defekt
    Koeder 2  glpat- + 20 Zeichen   ->  leaks found: 1     <- der Scanner greift
    dieselbe Datei als .txt          ->  leaks found: 1     <- die Endung .jsonl ist NICHT der Grund

Der erste Koeder hatte **ein Zeichen zu wenig** und lag damit unter der Formregel der
GitLab-PAT-Detektion. Haette ich ihn fuer gueltig genommen, waere „no leaks found" ueber
90 Agenten-Transkripte eine Aussage ohne Gegenstand gewesen — genau die Klasse, gegen die
K13 gebaut ist: *ein Koeder, der nicht beisst, beweist nichts.*

Erst mit dem formkorrekten Koeder ist die Null belastbar. **Wer diese Sicherung erneuert,
faehrt die Gegenprobe mit** — ein Scan ohne beissenden Koeder ist kein Scan.

---

## WAS HIER NICHT LIEGT (ausdrueckliche Grenze)

* **Session-Transkripte** (`~/.claude/projects/.../<session>.jsonl`). Sie enthalten Live-Token
  und werden **nie** committet. Die Agenten-Transkripte hier sind etwas anderes: sie entstehen
  im Subagenten-Kontext und sind gescannt.
* **Bau-Artefakte** der Pakete. Die liegen in den Worktrees und sind fluechtig.
* Die Journale **anderer Sessions** — dies ist die Menge dieser einen Session (211 Laeufe).

---

## DER STAND, DEN DIESE ROHDATEN FESTHALTEN

Der Lauf `wf_4579d7c4-37a` wurde **zweimal gestoppt**:

1. **07:32** — die Platte lief auf 2,3 MB voll. Zehn Pakete bauten gleichzeitig; ein ce-Bau
   belegt ueber 6 G. Damit fielen auch die PreToolUse-Hooks aus (`uv` braucht ein
   Build-Verzeichnis), und **kein Agent konnte sich mehr selbst helfen**.
   Journal-Stand: **35 gestartet, 30 abgeschlossen**.
2. **kurz darauf, geplant** — Umstellung des Bauens von parallel auf **sequentiell** auf
   Owner-Anweisung. Explore und Design bleiben parallel, Verify wird wieder parallel.

Die 30 abgeschlossenen Agenten liefern beim Resume aus dem Cache; ihre Arbeit ist in diesen
Rohdaten enthalten und geht nicht verloren.
