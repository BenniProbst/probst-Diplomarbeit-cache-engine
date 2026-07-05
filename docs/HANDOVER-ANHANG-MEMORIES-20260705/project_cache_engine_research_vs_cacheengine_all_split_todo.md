---
name: project_cache_engine_research_vs_cacheengine_all_split_todo
description: "comdare-cache-engine = Diplomarbeits-Forschungsrepo (GitHub BenniProbst/comdare-cache-engine = GitLab comdare/research/comdare-cache-engine, CI-Projekt 286); Modules/comdare-cacheengine-all bettet DASSELBE Remote ein + 6 Skelett-Zellen, wird von der Thesis NICHT verwendet; TODO GANZ SPÄTER: Forschung von offizieller Bibliothek nach Baseline-Methodik trennen"
metadata: 
  node_type: memory
  type: project
  originSessionId: c6f15797-7fa1-4e66-874f-55631afe1d28
---

**Sachverhalt (User-Klärung 2026-07-03):** Die Diplomarbeit (Desktop, thesis-Repo) behandelt die comdare-cache-engine als Forschungsprojekt und nutzt exakt das Remote `github.com/BenniProbst/comdare-cache-engine` (GitLab-Spiegel `comdare/research/comdare-cache-engine`, CI-Projekt 286). `Modules/comdare-cacheengine-all` bettet dasselbe Remote als Unterordner ein und enthält zusätzlich 6 Skelett-Zellen (build-tools, cache-engine-core, isa-dispatch, measurement, search-engine, test-system) — es ist das VORBEREITETE künftige Firmeninventar-Zuhause der Domäne, wird aber vom Forschungsprojekt (bewusst) NICHT verwendet. Einziges Umbrella ohne Baseline-System (Ist-Dossier-Befund); D-5 hat die Baseline-Zuordnung der Skelette fixiert (Rahmen jetzt, Befüllung später).

**Reihenfolge:** (1) Thesis testet die Cache-Engine als Forschungsprojekt und schließt das Studium ab. (2) Ein früherer Bauversuch mit einem älteren Claude-Modell scheiterte. (3) **TODO GANZ SPÄTER (User 2026-07-03, als Task eingetragen): Forschungsprojekt und offizielle Bibliothek nach Baseline-Methodik wieder trennen** — offizielle Anteile in die cacheengine-all-Zellen, Forschungs-Repo bleibt eigenständig.

**How to apply:** Bis zur Trennung gilt strikt: cache-engine-Repo UNANGETASTET (Thesis-Track + laufende Mess-Pipeline 286, [[feedback_prod_ci_measurement_multiday_experiment]]); comdare-db-Wellen bauen nur die Skelett-Rahmen (D-5). Siehe [[feedback_baseline_system_in_stein_gemeisselt_layering]].
