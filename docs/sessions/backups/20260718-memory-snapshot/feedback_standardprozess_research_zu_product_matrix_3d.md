---
name: feedback_standardprozess_research_zu_product_matrix_3d
description: "User 07.07. — Matrix ist 3D (Familien × Baseline-Stufen × MODULE); Module = source-only Template-Code; jedes Product/Research baut EIGENE Instanziierungs-Matrix (Binary-Interfaces); Standardprozess Research→Product dokumentiert; ce=Framework-Modul, Diplomarbeit=dessen Product, prt-art=Modul, Overleaf=Product ohne Baselines"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

User-Klarstellung + Auftrag (2026-07-07): **In Stein gemeißelt ist die Matrix als DREI Dimensionen: Familien × Baseline-Stufen × Module** (Module = die Zellen-Repos IN einer Stufe). **Generische Module sind metaprogrammierungs-offen und NUR Source-Code**; **jedes Product/Research, das Module nutzt, organisiert eine EIGENE Matrix (Familien × Stufen × Module)** aus separaten Repos, die die Template-Module **als echte Interface-Binaries instanziieren**. Research = Products mit gelockerten Eigenschaften. Taxonomie-Anker: **comdare-cache-engine = Framework-Modul, Diplomarbeit = dessen Product/Außeninterface; prt-art = Modul; Overleaf/Thesis = Product OHNE Baseline-Struktur** (kein Programmiersprachen-Projekt).

Der **Standardprozess Research→Product** ist als Dokument gespeichert: `Research/probst-diplomarbeit-cache-engine/docs/STANDARDPROZESS-RESEARCH-ZU-PRODUCT.md` (9 Schritte: Kartierung → Reuse → additive Erweiterung → minimale Neuanlagen → Framework-Modul-Schnitt in Baseline-Struktur → Product-Instanziierungs-Matrix → GitLab-Gruppen exakt nach Ordnerstruktur [vorher Diff, origin-URLs=Ist] → CI+CMake parallel bis Buildsystem fertig → Beweis-Disziplin).

**Why:** Bindende Organisations-Doktrin für ALLE künftigen Research→Product-Umwandlungen; das Wort „Migration" meint FUNKTIONS-Zerteilung des Monolithen in diese Struktur, NIE Umbau der bestehenden Matrix.

**How to apply:** Bei jeder Migrations-/Strukturarbeit zuerst das Standardprozess-Doc + [[feedback_baseline_system_in_stein_gemeisselt_layering]] + [[feedback_achsen_thema_modul_framework_metaprogramming_interface]] laden; GitLab-Struktur nur nach bestätigter Spiegel-Konvention nachziehen (Ordnerstruktur autoritativ); eingebettete Submodule/Vendor-Klone sind von der Spiegel-Regel ausgenommen.
