---
name: feedback_github_flache_out_of_house_sicherung_fokus_gitlab
description: "User 07.07. — GitHub ist NUR flache Out-of-House-Sicherung (Backup-Spiegel), strukturell so belassen (keine Praefix-Renames, keine Org-Aufteilung, keine Struktur-Abbildung); Struktur-Autoritaet = GitLab-Gruppen + lokale Ordner-Matrix; Fokus aller Struktur-Arbeit auf GitLab"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

User-Entscheidung (2026-07-07, nach Klaerung dass GitHub keine verschachtelten Namespaces kennt): **GitHub = flache Out-of-House-Sicherung, mehr nicht.** GitHub strukturell so lassen wie es ist (unsortiert/flach); **wir verbleiben beim Fokus auf GitLab.**

**Why:** GitHub kann die 3D-Matrix-Gruppenstruktur (Familien/Umbrella -> Baseline-Stufen -> Module) nicht abbilden (nur eine Ebene Owner/Repo). Naeherungen (Praefix-Renames, eine Org je Familie, Topics) sind Kompromisse mit Umbau-Aufwand ohne echten Struktur-Gewinn — vom User verworfen. GitHub erfuellt seine Rolle als georedundantes Backup (out of house) bereits.

**How to apply:**
- KEINE GitHub-Renames/Org-Transfers/Struktur-Experimente vorschlagen oder durchfuehren; GitHub-Repos bleiben flach unter BenniProbst/.
- Struktur-Arbeit (Gruppen-Nachzug B6, Spiegel-Konventionen, Familien-Anlagen) ausschliesslich auf GitLab ([[feedback_gitflow_branch_doktrin_main_authoritaet_development_voraus]], [[feedback_standardprozess_research_zu_product_matrix_3d]]).
- Dual-Remote-Repos: Pushes weiterhin zu BEIDEN Remotes (Paritaet halten, [[reference_thesis_git_topology_remotes_overleaf]]) — GitHub-Seite dabei nur als Inhalts-Backup verstehen, nie als Struktur-Traeger.
