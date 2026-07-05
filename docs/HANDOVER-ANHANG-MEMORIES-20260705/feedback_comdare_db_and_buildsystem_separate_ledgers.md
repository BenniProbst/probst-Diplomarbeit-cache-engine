---
name: feedback_comdare_db_and_buildsystem_separate_ledgers
description: "comdare-db und comdare-buildsystem sind ZWEI VÖLLIG GETRENNTE Systeme mit GETRENNTEN Ledgern. comdare-db-Arbeit/Designs/Analysen/M2/ctest gehören in comdare-db (eigenes Repo, sessions/ + eigenes Ledger); Buildsystem-TODOs gehören in cd-buildsystem-core/docs/BUILDSYSTEM-LEDGER.md. Einträge NIE vermischen. comdare-db nutzt das Buildsystem nur zum Bauen."
metadata:
  node_type: memory
  type: feedback
  originSessionId: c6f15797-7fa1-4e66-874f-55631afe1d28
---

**Direktive (User 2026-07-04):** comdare-db und buildsystem-core haben **getrennte Ledger** und müssen **strikt getrennt** dokumentiert werden — sie sind zwei völlig getrennte Systeme, comdare-db *nutzt* das Buildsystem nur zum Bauen.

**Warum:** Beide Ledger sind extrem wertvoll (Millionen Tokens Analyse-Arbeit). Vermischung entwertet sie + verwirrt die Single-Source-Wahrheit je System.

**How to apply:**
- **comdare-db** = eigenes git-Repo (`Products/comdare-db`, GitHub `BenniProbst/comdare-db` + GitLab `comdare/products/comdare-db`). comdare-db-Sessions → `comdare-db/sessions/` (Konvention `YYYYMMDD-HH-MM-NNNNNN-*.md`). comdare-db-Ledger + Designs/Analysen/M2/ctest/Build-Fixes/Feature-Stubs → **im comdare-db-Repo**.
- **comdare-buildsystem** = `cd-buildsystem-construct/Layer1-Foundation/cd-buildsystem-core/docs/BUILDSYSTEM-LEDGER.md` (Master-Ledger, T-01..T-61) — **nur Buildsystem-TODOs**. Buildsystem-Sessions → `cd-buildsystem-core/docs/sessions/`.
- Beim Fortschreiben IMMER prüfen: gehört der Eintrag zum DB-System oder zum Buildsystem? Nie eine comdare-db-M2/ctest/Design-Notiz ins Buildsystem-Ledger schreiben (und umgekehrt). Bei Bau-Integration, die beide berührt (z.B. rc→cd in comdare-db-`configure.sh`): der Buildsystem-Aspekt ins Buildsystem-Ledger, der DB-Code-Aspekt ins DB-Ledger.
- Trennen ohne zu beschädigen: additiv umziehen (an Zielort schreiben, dann am Quellort entfernen), Inhalt wörtlich erhalten. Verwandt: [[feedback_text_agent_sessions_belong_in_thesis_not_impl_repo]].
