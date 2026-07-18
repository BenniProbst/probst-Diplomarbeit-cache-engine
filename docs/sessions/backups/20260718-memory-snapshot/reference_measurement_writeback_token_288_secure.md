---
name: reference_measurement_writeback_token_288_secure
description: "Sicherheits-maximale Push-Credential-Lösung für den #22-persist:measurements-Auto-Push nach development: projekt-lokaler Project Access Token (super 288, write_repository-only, Developer, 90-Tage-expires), getrennt vom Admin-PAT, admin-PAT-unabhängig rotierbar. development ist jetzt PROTECTED. INERT bis COMDARE_PERSIST_MEASUREMENTS=true"
metadata:
  type: reference
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**Angelegt 2026-07-11 (User-Direktive „separater projekt-spezifischer Token, minimal nur für Messwert-Push,
Admin-PAT unabhängig rotierbar, Sicherheit maximieren"; Deep-Research wf_f68bec15).** NIE einen Token-WERT
committen/ausgeben ([[reference_session_transkripte_enthalten_live_tokens_nie_committen]]).

**Lösung (GitLab 18.9.0 CE/Free, super=Projekt-ID 288):**
- **Project Access Token id=54, Name `writeback-measurements`**, Scope **write_repository-ONLY** (kein api/registry
  → bei Leak nur git-push auf 288, keine Eskalation), Rolle **Developer (30)**, **expires_at 2026-10-09** (90 Tage).
  NICHT der Admin/Master-PAT, NICHT ein Deploy-Token (die können physisch keinen Code pushen — GitLab #23067).
- **Bot-User `project_288_bot_c319e399ff7cdd9c31bb0317b5c99509`** — enthält `_bot_` → die persist-Job-Loop-Schutz-
  rule (`GITLAB_USER_LOGIN =~ /_bot_/ -> never`) greift korrekt.
- **CI-Vars (super 288):** `COMDARE_WRITEBACK_TOKEN` = masked+hidden+protected; `COMDARE_WRITEBACK_USER` =
  protected (Bot-Username). Beide `protected` → nur auf **development-Pipelines** exponiert, nie Feature-Branch.
- **`development` ist jetzt PROTECTED** (push/merge=Developer+, allow_force_push=false) — aktiviert die
  protected-Var-Boundary + Force-Push-Schutz. KEIN Regressions-Risiko: beide super-Member sind Owner (bypassen
  protected-push); kein CI-Job pusht via CI_JOB_TOKEN nach development. Der persist-Job pusht mit dem Bot-PAT
  (Developer) → darf auf protected development pushen.

**Status: SCHARF, per-Pipeline-Aktivierung (2026-07-11, NAS-Vorbehalt aufgelöst „Ja das backup genügt. GO").**
`COMDARE_PERSIST_MEASUREMENTS` wird NICHT als global-always-on Projekt-Var gesetzt (das erzeugte je dev-Pipeline
einen `measurement/<ts>/`-Commit = Rauschen, da der Timestamp-Ordner immer neu ist) — stattdessen wird die Var NUR
beim Mess-Trigger zusammen mit `COMDARE_RUN_MEASURE=true` als Pipeline-Variable übergeben. So läuft persist NUR auf
echten Mess-Läufen (`measure:golden-320`), der Normal-Gesamtlauf (Messung AUS) bleibt commit-frei. Der Token bleibt
protected → nur auf protected-development-Pipelines exponiert; Feature-Branch-persist scheitert mangels Token ohne
Push (Boundary hält). **Trigger-Rezept:** POST `/projects/288/pipeline` ref=development +
`variables:[{COMDARE_RUN_MEASURE,true},{COMDARE_PERSIST_MEASUREMENTS,true}]` →
[[project_mess_ergebnis_rueckschreibung_pipeline_persistiert]].

**Rotation (admin-PAT-unabhängig):** `POST /api/v4/projects/288/access_tokens/54/rotate` (Alt-Token sofort
inaktiv, neues expires in einem Schritt) — dann `COMDARE_WRITEBACK_TOKEN` neu setzen. Revoke: `DELETE
/projects/288/access_tokens/54`. Un-protect development: `DELETE /projects/288/protected_branches/development`.

**Rest-Risiko (CE-Free-inhärent, ehrlich):** wer nach development pushen darf (auf Free NICHT bot-exklusiv
beschränkbar — bot-exklusive Push-Allowlist + Push-Rules-Pfad-Allowlist sind Premium) könnte den protected Token
theoretisch via CI-Job exfiltrieren (Masking ist KEINE Boundary). Begrenzt durch write_repository-only + 90-Tage-
Rotation + winziger Member-Pool (nur Owner) + job-seitige Pfad-Begrenzung (`git add -- measurement/`). Maximal ohne
Premium/pre-receive-Gitaly-Hook. Backup des Deep-Research:
`docs/sessions/backups/` (wf_f68bec15).
