---
name: feedback_selbst_implementieren_ab_20260710_codex_abgeloest
description: User-Direktive 10.07.2026 — ab sofort implementiert Claude selbst; Codex-Erstimplementierung abgelöst; bei Major-Verstößen sofort selbst nachimplementieren
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**Direktive (User, 10.07.2026, mid-turn):** „Bitte implementiere ab sofort selbst" + „bei major Verstößen bitte selbst nachimplementierst … direkt wenn es dir auffällt".

**Why:** Der Codex-MCP-Lauf zur Limits-Umschaltung hing 1800s ohne Antwort (idle-timeout, abgebrochen); zuvor schon bwrap-Defekt auf prod1 und ein Scope-Überschreitungs-Vorfall. Die Token-Ersparnis der Codex-Erstimplementierung trägt nicht mehr gegen die Ausfälle.

**How to apply:** (1) Erstimplementierung macht Claude ab sofort SELBST — ersetzt die Codex-first-Kadenz aus [[feedback_codex_implements_from_dossier_claude_corrects]] (dort Codex-first als historisch markieren). Elaborierte Dossiers bleiben Pflicht (Konzept vor Bau), ebenso der adversariale Review-Workflow je Increment. (2) Bei MAJOR-Verstößen (Review-CONFIRMED-major, Scope-Verletzungen, Architektur-Brüche) nicht delegieren, sondern SOFORT beim Auffallen selbst nachimplementieren. (3) Nach abgebrochenen/hängenden Fremd-Läufen (Codex, danger-full-access) IMMER git status prüfen und Hinterlassenschaften sichten, bevor selbst weitergebaut wird.
