# Backup: Kontext-Neugruendungs-Workflow (ultracode, Opus xhigh) — 26.07.2026

> STRUKTUR-SNAPSHOT eines LAUFENDEN Workflows (Stand ~06:34 UTC, 28 von ~38 Agenten fertig,
> Synthese ausstehend). User-Auftrag: nach Workflow-Ende wird dieses Backup FINAL durch
> UEBERSCHREIBEN aktualisiert (frische Neu-Extraktion aller Ergebnisse + Synthese-Dossier).

## Zweck

Wiederverwendbarer Neugruendungs-Workflow nach Kontext-Kompaktierung der Manager-Session:
Voll-Einlesung (1) der GESAMTEN Architektur-Doku (docs/architektur, 33 Dateien, 4 balancierte
Gruppen), (2) der 5 neuesten Session-Docs beider Repos, (3) der Plaene (Ledger, Masterplan,
Index, TODO-Board, aktive Plan-Datei), (4) der NACHRICHTEN des letzten Kontexts (aus dem
Session-Transkript extrahiert: nur User/Assistant-Text, tool-Dumps entfernt, Token-Muster
redigiert, in ~300-KB-Chunks) — alles parallel mit Opus/xhigh-Lesern, dann EIN Synthese-
Lage-Dossier fuer den Architekten.

## Orte

- Run-ID: wf_4d63cdab-1d4 (Session 46375cdc, 26.07.2026)
- Wiederverwendung: Workflow({scriptPath: "<dieser Ordner>/workflow-script.js"}) — Pfade zu
  Transkript/Scratchpad im Skript-Kopf je Session anpassen.
- Fluechtige Originale (session-gebunden, NICHT committet): Transcript-Dir
  ~/.claude/projects/<projekt>/<session>/subagents/workflows/<runId>/ (journal.jsonl +
  agent-*.jsonl) sowie workflows/scripts/<name>-<runId>.js.

## Inhalt

- workflow-script.js — das vollstaendige Workflow-Skript (der wiederverwendbare Teil).
- journal-snapshot-laufend.jsonl — Journal-Snapshot (started/result je agent()-Call).
- ergebnisse/NN-<label>-<agentid>.md — die Agent-RETURNS (Rohdaten der Ergebnisse),
  Label aus den Agent-Prompts rekonstruiert (arch-gruppe-1..4, sessions-letzte-5,
  plaene-ledger, transkript-01..NN, inventar/extraktion).

## Redaktions-Doktrin (PFLICHT vor jedem Commit von Workflow-Rohdaten)

Alle Dateien liefen durch den kuratierten Redaktions-Pass (233-Regel-Liste des Giga-Scrubs,
blind angewendet + Token-Muster glpat/github_pat/ghp) mit regel-bewusstem 0-Treffer-Verify
(Ersatztexte maskiert, da einzelne Regeln pat-in-rep-Form haben). 4 Redaktionen waren noetig
(transkript-11 + journal) — der Pass ist also KEIN Ritual. WICHTIG fuers Final-Update:
IMMER frisch aus dem Journal neu extrahieren und den Pass EINMAL anwenden — nie den Pass
ueber bereits redigierte Dateien wiederholen (pat-in-rep-Regeln wuerden aufblaehen).
Die vollen agent-*.jsonl-Transkripte werden NIE committet (Transkript-Doktrin).
