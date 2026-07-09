# Datiertes Voll-Backup der Impl-Agent-Sessions (erstellt 2026-07-09) — für account-fremde Weiterarbeit
Zweck: Eine andere Claude-Instanz (anderer Account, andere Maschine) übernimmt exakt am Goal V2 (siehe `docs/HANDOVER-BEP-ABTEILUNG-20260705.md` + Ledger §13). Dieses Backup ergänzt das Handover um ALLE Rohdaten und das VOLLSTÄNDIGE Assistenten-Memory. STRIKT ADDITIV — nie löschen.

## Inhalt
- **`scratchpad-rohdaten/`** (179 Dateien, secret-scrubbed): sämtliche Arbeits-Rohdaten der Sessions 02.–05.07. aus dem flüchtigen Session-Scratchpad — alle Codex-**Dossiers** (`*_dossier.md`: AP-1/9/10/11/13/15-1, s71, ap7b, 217_2a, 221, 224, …), alle **Codex-Transkripte** (`*_codex.out` — Voll-Logs der Implementierungs-Läufe), Kartierungs-Notizen, lint-Listen, Recherchen (206_pipeline_gates), Synthesen (synth1310 = Ledger §13.10-Quelle). Damit ist jede Kadenz-Entscheidung der Sessions nachvollziehbar.
- **`memory-vollexport/`** (324 Dateien inkl. `MEMORY.md`-Index): das KOMPLETTE persistente Assistenten-Memory (alle Projekte: Diplomarbeit, Cluster, comdare-db, buildsystem, Steuerrater, comdare-web; Tokens redacted). Der Diplomarbeits-Teilauszug (58) liegt bereits unter `docs/HANDOVER-ANHANG-MEMORIES-20260705/`; DIESER Export ist die Vollmenge zum Wiederaufbau des Memorys auf einer neuen Maschine (`~/.claude/projects/<projekt>/memory/`).
- Nicht enthalten (bewusst): Binärdateien (LLVM-Toolchain — Bezug s. Handover §1), Credential-Dateien, 2,5-GB-Build-/Klon-Reste des Scratchpads.

## Bereits versionierte Schwester-Backups (Kontext)
`docs/sessions/20260705-nacht-audit-ultracode-rohdaten/` (11-Agenten-Audit) · `docs/sessions/20260705-arch-verify-w1-w5-rohdaten/` (W1–W5 inkl. Workflow-Skript) · `docs/sessions/20260705-matrix-grundlagen-goalv2/` · Handover + Anhänge (TODO-Board 275 + Memories 58) unter `docs/`.
