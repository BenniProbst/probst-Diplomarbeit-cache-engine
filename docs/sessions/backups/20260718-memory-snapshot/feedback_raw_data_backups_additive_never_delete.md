---
name: feedback_raw_data_backups_additive_never_delete
description: "Beim Sichern von Analyse-/Rohdaten-Backups STRIKT ADDITIV arbeiten — niemals rm oder Überschreiben bestehender extrahierter Dateien, auch nicht zum Umbenennen/Aufräumen. Lieber zusätzliche Lesehilfe (INDEX/MAPPING) daneben legen. User stoppte 2026-07-04 einen `rm -f $BK/*.md`-vor-Re-Extract."
metadata:
  node_type: memory
  type: feedback
  originSessionId: c6f15797-7fa1-4e66-874f-55631afe1d28
---

**Feedback (User 2026-07-04):** „Bitte sichere die Rohdaten beider Workflows als backup **ohne etwas zu löschen**." Der User brach einen Bash-Befehl ab, der `rm -f "$BK"/*.md` ausführen wollte (um die bereits extrahierten agentId-benannten Rohdaten-Dateien durch besser benannte zu ERSETZEN).

**Regel:** Rohdaten-/Analyse-Backups (Workflow-Journal-Extrakte, Discovery-Rohdaten, Session-Dumps) sind **append-only**:
- **NIE** `rm`/`mv`/Überschreiben bestehender Backup-Dateien — auch nicht für „schöneres" Naming oder Aufräumen.
- Verbesserungen (lesbare Namen, Kategorisierung) als **zusätzliche** Datei DANEBEN (z.B. `AGENTID-MAPPING.md`, `INDEX.md`), die auf die unveränderten Rohdateien verweist.
- Extrahieren aus `journal.jsonl` (Feld `result` je `type:"result"`-Zeile; agentId statt label) → je Ergebnis EINE neue Datei; vorhandene nie antasten.

**Why:** Analyse-Rohdaten sind teuer erkauft (hier 2×~1,95 M Tokens); ein versehentliches `rm` vernichtet nicht-reproduzierbare Zwischenergebnisse. Deckt sich mit [[feedback_messdaten_nie_loeschen_abi_darf_brechen]], [[feedback_never_delete_documentation]], [[feedback_protect_customer_data]]. Muster-Vorbild: comdare-db `_backup-discovery-rohdaten-20260702/`.
