---
name: feedback_all_projects_dual_remote_github_gitlab
description: "User-Regel 08.07. — ALLE Projekte sollen github UND gitlab als Remote haben; wenn beim Arbeiten auffällt dass einer fehlt, nachziehen (remote add, wenn Ziel-Repo existiert). Repo-ANLAGE bleibt je-Repo-GO."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive (2026-07-08):** „Alle Projekte müssen github und gitlab haben, wenn es dir auffällt, zieh es nach." Steht neben (und präzisiert) [[feedback_github_flache_out_of_house_sicherung_fokus_gitlab]]: github bleibt die flache Out-of-House-Sicherung, gitlab die Struktur-Autorität — aber BEIDE sollen als Remote vorhanden sein.

**Konvention (Fleet-verifiziert 08.07.):** `origin = gitlab` (`https://gitlab.comdare.de/comdare/...`), zweiter Remote `github = https://github.com/BenniProbst/<repo>.git`. Alle konformen Modules-Klone + der Diplomarbeit-ce/-super folgen dem. gitlab-Fetch braucht die ROOTCA (`git config http.https://gitlab.comdare.de/.sslCAInfo ~/Projekte/Cluster/keys/gitlab-ca-ROOTCA-...crt`, nie -k).

**„wenn es dir auffällt, zieh es nach" = opportunistisch + sicher:**
- Fehlt ein Remote UND das Ziel-Repo EXISTIERT bereits → `git remote add` (+ ff-fetch, Tracking setzen). SICHER, sofort machen. Beispiel 08.07.: `Modules/comdare-cacheengine-all/comdare-cache-engine` hatte NUR github → gitlab-Repo 286 (`comdare/research/comdare-cache-engine`) existierte → `remote rename origin github` + `remote add origin <gitlab>` + fetch + set-upstream. Konform.
- Fehlt ein Remote UND das Ziel-Repo existiert NICHT → das wäre Remote-Repo-ANLAGE → bleibt TABU ohne expliziten je-Repo-User-GO ([[feedback_remote_deletion_requires_explicit_user_authorization]]). NICHT im Massen-Sweep anlegen; dem User vorlegen.

**Zusatz-Fakten (08.07., aus dem MEMORY-Index hierher konsolidiert):** (a) Das external-Modul-**Original** (`Modules/comdare-cacheengine-all/comdare-cache-engine` = 2. Klon von gitlab-286) bei Änderungen am Diplomarbeit-ce per **ff-sync** nachziehen ([[feedback_diplomarbeit_4_projects_local_clones_keep_in_sync]]). (b) Der ce-Namespace `comdare/research/`-286 ist **Doku-konform** — KEINE Migration; der Research↔All-Split bleibt deferred (#12, [[project_cache_engine_research_vs_cacheengine_all_split_todo]]). (c) Die 6 `modules/comdare-cacheengine/`-Zellen auf gitlab = **Archiv-Tombstone** (leer/historisch), nicht reaktivieren.

**Audit-Befund 08.07. (offener Sweep, NICHT blind fixen):** ~50 Repos unter `Modules/`+`Products/`+`Research/` haben NUR gitlab, KEIN github (die Firmen-Modul-Struktur lebt auf gitlab; github-Sicherung fehlt flächig). github-Repos existieren dort meist NICHT → Massen-Ergänzung = Massen-Repo-Anlage → als eigenes Arbeitspaket mit User-GO klären, nicht opportunistisch. `Research/MergeHash` = umgekehrt (nur github). Verwandt: #32 Struktur-Regression ([[project_struktur_regression_geteilte_klone_statt_instanz_repos]]), [[feedback_diplomarbeit_4_projects_local_clones_keep_in_sync]].
