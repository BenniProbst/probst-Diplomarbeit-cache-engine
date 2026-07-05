---
name: reference_gitlab_pat_format_dots_regex
description: "GitLab-PATs (routable-token-Format) enthalten PUNKTE (glpat-<x>.NN.<y>); Extraktions-Regex MUSS '.' einschließen, sonst Truncation → falsche 401"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 885d4915-6f41-4b18-9770-e729576e9fee
---

GitLab Personal Access Tokens im neueren „routable token"-Format haben die Struktur `glpat-<base62>.<2-stellige-version>.<base62>` — also **mit Punkten**. Gültige Tokens sind ~51 Zeichen lang.

Beim Extrahieren aus Dateien/Vault MUSS die Regex den Punkt enthalten: `glpat-[A-Za-z0-9_.\-]{20,}` (danach ggf. trailing `.` trimmen). Die naive Regex `glpat-[A-Za-z0-9_-]+` schneidet am ersten Punkt ab (→ len≈38) → abgeschnittenes, ungültiges Token → `/api/v4/user` = **401**.

**Lektion (K81-74, 2026-06-27):** Dieser Bug verursachte einen kompletten Fehlalarm „alle 9–13 Vault-PATs sind 401 / GitLab-API tokenlos" (Task #114), obwohl tatsächlich ≥2 PATs gültig waren. Erst punkt-bewusst getestet kam `/user=200` (len≈51). Es wurde dadurch fast unnötig ein neuer Keeper gemintet.

**How to apply:** Bei JEDER GitLab-PAT-Extraktion/Validierung dot-aware extrahieren + per `https://gitlab.comdare.de/api/v4/user` (HTTP-Code, NIE den Wert echoen) testen. Vault = `keys/CREDENTIALS-VAULT.md` (gitignored). Verwandt: [[reference_gitlab_admin_access_keeper_pat_and_transfer_block]] · [[feedback_token_pat_rotation_new_first_keep_gitlab_github_full_access]].
