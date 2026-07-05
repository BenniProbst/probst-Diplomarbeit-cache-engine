---
name: feedback_remote_deletion_requires_explicit_user_authorization
description: Remote-Repos/Branches NIE löschen ohne expliziten User-Auftrag JE Repo; vor Lösch-Aktionen Matrix-System auf Klone/Submodul-URLs prüfen (Vorfall 2026-07-04)
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 78cf67f8-571e-4fcd-a907-1556dbc5be72
---

**Vorfall 2026-07-04/05:** Bei der cache-engine-Modul-Konsolidierung (User-Entscheid A = „6 Pseudo-Spiegel sauber löschen") wurden zusätzlich die 6 **GitHub-Remotes** (`gh repo delete`) gelöscht. Das vorherige ultracode-Lösch-Audit (wf_9f28bd31, „0 externe Refs in Projekte\") suchte nur **Code-Referenzen** und übersah die eigenständigen **Klone im Baseline-Matrix-System** `Projekte\Modules\comdare-cacheengine-all\` (origin→GitHub) → orphaned. Behebung: User-Web-Restore (github.com/settings/deleted_repositories, 90-Tage-Fenster, stellt volle Historie wieder her) + GitLab-Pendants neu (comdare/modules/comdare-cacheengine, ID 344) + Matrix-Klone ff auf Vollstand (Ledger §13.5).

**Why:** „Nicht mehr referenziert" aus Code-Sicht ≠ „nirgends verwendet" — das Matrix-/Baseline-System referenziert Module als eigenständige Klone/Submodul-URLs, nicht als Includes. Remote-Löschung ist (nach 90 Tagen) irreversibel und zerstört Verlinkungen außerhalb des auditierten Repos.

**How to apply:** (1) Remote-Repos/-Branches NIE löschen/anlegen ohne **expliziten User-Auftrag je Repo** (Sammel-Freigaben wie „sauber löschen" decken NUR die lokal benannten Artefakte, nicht Remotes). (2) Vor JEDER Lösch-Aktion: `Projekte\Modules\**` + `Projekte\Products\**` auf Klone (`**/.git/config` remote-URLs) und `.gitmodules`-Einträge greppen — nicht nur Code-Refs. (3) Gelöschte GitHub-Repos: zuerst Web-Restore prüfen (Settings→Deleted repositories) statt Neu-Anlage. Verankert als hartes TABU in GOAL-TEXT V2 (Ledger §13.4). [[project_diplomarbeit_modules_mirrors_deleted_reuse_comdare_modules]] · [[feedback_baseline_system_in_stein_gemeisselt_layering]]
