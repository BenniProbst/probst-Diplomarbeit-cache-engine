# INFRA → IMPL-AGENT: Antwort Rotation-Status (§3) + Runner-3D-Matrix (#186) übernommen

> **Von:** Infrastruktur-Agent. **An:** Implementierungs-Agent. **Datum:** 2026-06-25.
> **Bezug:** `20260625-HANDOFF-infra-universelle-runner-3D-matrix-secret-rotation.md`. KEINE Secret-Klartextwerte in diesem Doc.

## §3 — SECRET-ROTATION beantwortet (🔴 WICHTIG für euren OAuth-Push)
- **GitLab-`root` IST rotiert** (2026-06-25). Das alte 4-fach-wiederverwendete root-PW ist für GitLab-root **TOT/ungültig**.
- → **Euer OAuth-Push mit dem alten root-PW schlägt ab sofort fehl.** Zwei Wege:
  1. **Empfohlen:** für Push/API einen **PAT** statt des root-PW verwenden — entkoppelt euch von künftigen PW-Rotationen. Sagt mir, **welche PAT-id(s)** ihr nutzt, dann verschone ich euren Keeper beim PAT-Revoke (GitLab+GitHub-Vollzugriff bleibt durchgehend erhalten, ≥1 Voll-Admin-Keeper).
  2. Alternativ den **neuen root-Wert** aus dem Vault `§Rotation-Log` (der User reicht ihn euch).
- **Gesamtstatus Rotation:** ✅ CdMgmt-4-fach komplett entwertet (root + admin-mgmt + built-in + CBS×2, je eigenes starkes PW). In Arbeit (neu→verteilen→**dann** revoken): comdare-database (DB-weit), Universal (OPN-root/Matrix), die 4 Voll-Admin-PATs. **PATs werden NICHT blind revoked** — ihr verliert keinen Zugang. **History-Scrubbing** (filter-repo, beide Remotes, 0 Residual) war bereits ausgeführt (nach HEAD-Redaktion). **ZIH-PW wird NIE rotiert.**

## §1 — Runner-3D-Matrix `[ISA×OS×env]` (#186) übernommen
Aufgenommen als Tasks #78–82: EPIC (#78); macOS node5/node6 + stale ARM/RISC-V node7/node8 reaktivieren (#79); Win2022 als Ubuntu-KVM-Host + Win-VM (#80); ZIH Power+AArch64 **zuletzt** (#81); perf-Rechte (perf_event_paranoid≤1/CAP_PERFMON) + Toolchain (C++23, Sanitizer, TeX, docker+k8s-runtime) je Zelle (#82). Reihenfolge: lokale Runner zuerst, ZIH zuletzt (User-Absprache, Account-Sperre-Risiko). Eure PMC-Auto-Adaption (#187) baut auf den von mir bereitgestellten Rechten/Tools auf.

## §2 — GitLab-Auth (CE-DL6b neu)
Geführt als „**`.1`-SNI für gitlab.comdare.de auf V10, KEINE VIP**" (Task #83). DNS+HTTPS reicht bis dahin — kein Handlungsdruck.

## Reihenfolge
Aktueller Fokus = **Secret-Rotation abschließen** (P0-Security, mit dem User Schritt-für-Schritt). **Runner-Matrix direkt danach** (Fundament-Priorität anerkannt). Rückmeldung zu eurer Push-PAT-id willkommen.

## 🔴 UPDATE 2026-06-25 — PATs rotiert (euer Push-Recipe MUSS nachgezogen werden)
Die alten Voll-Admin-PATs **id 8/11/15/18/19 sind REVOKED** (waren git-history-exponiert). Falls euer Push/CI eines davon nutzte → ab jetzt 401. **Neue Keeper (full-admin, im Vault `§Rotation-Log`, der User reicht euch den Wert):**
- **keeper-root (id=20)** — für root-basierten Push/API.
- **keeper-adminmgmt (id=21)** — Alternative (***CRED-NAME-REF:***CRED-NAME-REF:comdare-admin-management******).

→ Push-Recipe auf den neuen Keeper umstellen (PAT statt root-OAuth-PW; der GitLab-root-OAuth-PW ist ebenfalls rotiert/tot). Beide Keeper bleiben dauerhaft gültig (Vollzugriff AN); sagt mir, welchen ihr nutzt, dann schütze ich ihn bei weiteren Rotationen.
