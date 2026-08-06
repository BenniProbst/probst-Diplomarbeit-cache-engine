# PAUSE (abbruchsicher) 05.08.2026 abends — Audit-/B-Strecken-Session

> **WIEDERAUFNAHME-AUFTRAG (Owner, verbatim-Kern): "Nach dem Auslaufen pausierst du abbruchsicher bis 23:40 Uhr berliner Zeit und nimmst die Arbeit dann autonom wieder auf."** — Wiederaufnahme **05.08.2026 23:40 Europe/Berlin (= 21:40 UTC)**, AUTONOM (Wecker-Task laeuft in der Session; bei Session-Verlust gilt dieses Doc als Auftrag). Erster Schritt bei Wiederaufnahme: Wiederanlauf-Doktrin (Ledger-Volltext + Objekt-Ist + Lebend-Check), PAT neu aus dem Vault extrahieren, dann Reststrecke Abschnitt 4.

> **ERST-ANKER BEI WIEDERAUFNAHME:** super `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`, Nachtraege **abend-1 bis abend-13** (rueckwaerts lesen). Danach dieses Doc, dann Arbeitsweise-Memory + `feedback_wiederanlauf_doktrin_nach_session_abriss`.

## 0. ZWEI-SESSIONS-LAGE (BINDEND)

Es arbeiten **zwei Claude-Sessions** am selben Projekt:

- **BAU-SESSION** (`b15ade0e`, die durchgehende Haupt-Session): besitzt `wt-e24` (W5/W3-Nachbesserung), `wt-super-w1`, die **Haupt-Baeume** und die **Landungs-Hoheit** der W5/W3-Strecke. Besitz-Register: Ledger abend-2 (Commit `09622a0c`).
- **DIESE SESSION** (Audit/B-Strecke, nach Systemabsturz gestartet): besitzt den **`wt-b*`-Namensraum** (Register-Erweiterung Ledger abend-5). Rollen-Anerkennung: Ledger abend-3.

**Regel:** Jeder Merge existiert GENAU EINMAL; Landungen nur nach **Lebend-Check** (Worktree-HEAD-Vergleich + Prozess-Check) + Ledger-Koordinationsvermerk.

## 1. LINIEN-IST BEI PAUSE

- **ce**: `dev == main == b4110cd0` (Gate 405) — A8-S5 komplett, ANKER GATE 5 vollzogen (Job-Sperre BEENDET), W1 Planer-Binary-Split + W2-Minimalhaerte + w2-codex-Fixes gelandet.
- **super**: `dev == 7d468505`, `main == 61548676` (CI-Wache + main-FF der letzten Doku-Commits bei Wiederaufnahme nachziehen!).
- Platte: ~56 GB frei (Bereinigung abend-9: 5 Alt-Builds + 9 bewiesene Worktrees; `all19_pilot.csv` gerettet nach `backups/20260805-worktree-abbau-messdaten-rettung/`).

## 2. WORKTREE-BESTAND

| Worktree | Branch | Stand | Besitzer |
|---|---|---|---|
| `wt-e24` | `w5-w3-kern` | W5/W3-Nachbesserung laufend | **BAU-SESSION — TABU** |
| `wt-super-w1` | `w1-planer-split-super` | gelandet | **BAU-SESSION — TABU** |
| `wt-b1-e18` | `b1-e18-vorwaerts-kanal` | 1 docs-Commit + Fix-Welle | diese Session |
| `wt-b13-eta` | `b13-eta-headless` | leer @b4110cd0, **gated** | diese Session |
| `wt-b2-neuanker` | `b2-neuanker-format3` | C-1 committed, C-2 in Arbeit | diese Session |

## 3. LAUFENDE WELLEN BEI PAUSE (Wiederaufnahme: NIE blind resumen — erst Ledger + Objekt-Ist + Lebend-Check)

1. **`wf_c95bf56b-4e4` — Neuanker Teil 1** (wt-b2-neuanker): C-1 (Sidecar-Haertung) committed `a16208ac`; C-2 (Format-3-Kern) war in Arbeit. Danach Dual-Review Fable+Codex. **STOP-GATE:** C-3-Dateien (`profile_run_entry.hpp`, `experiment_plan_director.hpp`, `cache_engine_builder_iterator.hpp`) NICHT anfassen — gehoeren der W5/W3-Welle.
2. **`wf_726f7f45-f7b` — E-18-Nachbesserung** (wt-b1-e18 + Patch-Scratch): behebt Codex-MAJOR (nicht ist-gedeckte Doku-Aussagen) + Fable-Befunde (ASCII-Auflage!, Zahlen, Deklarations-Grenzen), danach Zweit-Dual-Review.

Resume-Kommandos stehen in den jeweiligen Task-Notifications; Skripte unter `~/.claude/projects/-home-comdare/46375cdc-*/workflows/scripts/`.

## 4. RESTSTRECKE (Reihenfolge)

1. **Wellen-Ergebnisse verbuchen** (Backups + Ledger), dann **Landungen** je nach Lebend-Check:
   - E-18: ce-docs-Commit + **super-Patch** (`backups/20260805-b1-e18/super-anteil/`) in EIGENEM super-Worktree (nicht `wt-super-w1`).
   - Neuanker: **Teil 2** (C-3 F1/F4 inkl. **Owner-KERN Zaehler-Resume**: Batch-Plan persistent VOR dem Lauf, Resume = Zaehler je Phase; C-4-Rest) NACH der W5/W3-Landung; Merge-Reihenfolge: W5/W3 zuerst, dann Neuanker-Buendel KOMPLETT; danach **TP1-Wiederholung + 4+1-Beweise EINMAL** auf finalem Stand.
2. **B13-Bau** (Plan fertig: `backups/20260805-b13-eta-plan/plan.md`) — gated auf W5/W3-Landung, dann Branch NEU ab dev + Re-Anker-Pass.
3. **A1-Scheibe** (layout_aware-Wurf-Vertrag, Posten 74) · **B14** (GOLDEN-XML-Aktualitaet + Sync-Gate) · **KF-6-Fenster** mit dem SOTA-Design-Input (`backups/20260805-deep-research-a4-a5/`).
4. Restliche **B-Posten** B2/B3/B4/B8/B9/B11/B12 (Liste: Ledger abend-4 + `backups/20260805-liegengeblieben-sweep/synthese.md`).
5. **Phasen 3-5 -> Trigger** (Kollisionsregel Owner: **Substanz gewinnt, Trigger darf rutschen**) -> **Phase 6 Messung = USER-GO-STOPP**.

## 5. OFFENE OWNER-PUNKTE

- **E-18 Ziel-Branch-Entscheid**: Push-Ziel `development` vs. Overleaf-Sichtbarkeit ueber `main` (R2 des E-18-Plans).
- **E-18 Infra-Gate**: 289-Write-Token — **Owner-Hinweis: liegt im Cred-Vault unter „Cluster git"** (dort zuerst suchen; Handout im Backup nur als Fallback).
- Par.5-Fenster (CSV-Schema-Katalog P2-P8 + Peak-Quelle) — ehrlich offen ohne Empfehlung.
- Posten 92 (Registry-Kanon-Divergenz) — Einspruch moeglich, sonst Nach-Abgabe.
- A5-Folgeentscheid (Value-Filter-Achse: 4 Optionen unbewertet) — nach Abgabe.

## 6. FALLEN-KANON (neu aus dieser Session)

- **Wiederanlauf**: nie `resumeFromRunId` vor Ledger-Volltext + Objekt-Ist + **Lebend-Check auf Fremd-Session-Akteure**; Zustands-Aussagen ueber fremde Arbeitsstaende als **Momentaufnahme mit Zeitstempel** kennzeichnen.
- **Explore-Besetzung** (Owner-Dauer-Regel): Explore-/Recherche-Lenses = **Sonnet 5, effort max, very thorough**.
- **Backups**: Roh-JSON vor Commit **inhaltlich sichten** (Redaktionspass), Bau-Artefakte aussondern (nur Rohdaten/Plaene/Gate-Literale).
- **Doppellauf-Literale** gehoeren ins Wellen-Backup.
- **CI-Wachen**: zusaetzlich zum `status`-Feld die **Job-Liste** pruefen; bei Merge-Ketten Wache am Merge-VOLL-SHA oder Transitiv-Deckung explizit deklarieren.
- **Gate-Formeln praezise**: „genau EINE **Definitions-Naht**" statt „genau EINE Fundstelle" (Kommentar-Erwaehnungen zaehlen nicht).
- **Platte**: Alt-Build-Verzeichnisse und gelandete Worktrees sind die grossen Fresser — **vor jedem `rm` Mess-CSV-Check** (getrackte Duplikate vs. einzigartige untrackte Messdaten).
