---
name: feedback_ceb_config_cmake_interface_static_registry_paths_prt_module
description: "CEB-Konfig — Experiment-XML+Achsen-Registries per CMake-Interface als statische Pfade; PRT-ART=CE-Modul, additiv per Phase full-join-kompiliert"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

Der Anwender (Diplomarbeit) verwendet die CacheEngine als Framework, um per XML-Experiment-Konfiguration zu bauen. Die Pfade werden per **CMake-Interface als statische (dokumentierte) Pfade** übergeben — NICHT per env, NICHT per Co-Location neben der XML (User 2026-07-16, Antwort auf den I2-registry_dir-Fork; dokumentiert Dossier 17 R1/R2 + [[feedback_unified_experiment_xml_plus_system_registry_xml]]).

- **Je CacheEngineBuilder EINE Achsen-Registry-XML** am dokumentierten statischen Pfad; **je CacheEngine UND je PRT-ART eine** (= 2-Registry-Kanon; Registries sind die ALLEINIGE, statische Baustein-Ablage je Achse). Ist-Pattern schon da: `COMDARE_CE_AXIS_REGISTRY`/`COMDARE_PRT_AXIS_REGISTRY` + `COMDARE_V32_EXPERIMENT_GOLDEN_XML` als compile-defs (`ce tests/unit/CMakeLists.txt:2568-2570`, `super Code/02_messung_driver/CMakeLists.txt:117`). Kanonische Orte: ce `libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml`, prt-art `prt_art/algorithm_profiles/prt_art_axis_registry.xml` (verschiedene Verzeichnisse → per-Engine-Auflösung, kein gemeinsames registry_dir/<filename>).
- **Die Experiment-XML-Pfad** kommt per CMake-Interface an die cache-engine (Default gebacken + argv/env-Override, Muster `COMDARE_THESIS_PROFILE`/`COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE`); die übrigen Bauteile konfigurieren sich dann nach statischen Pfaden.
- **PRT-ART = ein MODUL der CacheEngine.** Verlangt der Anwender es per XML, wird es per Metaprogrammierung (XML-Definition der Experiment-Planungs-Anwendung) bei der Folge-Konfiguration **full join additiv an die ce-Achsen kompiliert, je nach Phase** (compile-time, Familie-C via PrueflingSlot; nie HART verdrahtet, nie Surrogat).

**Build-Mechanik (User-Präzisierung 2026-07-16):** Das ce-Framework kompiliert eine **versteckte root-Minimal-Binary = der Experiment-Planer** — gebaut aus einer **CMake-Konfiguration des Anwenders (Diplomarbeit)** aus den ce-Bibliotheken, in den Diplomarbeit-Code. Dadurch bekommt die Diplomarbeit ein **XML-ABHÄNGIGES Build**; die **CacheEngineBuilder + deren Tier-Binaries landen untergeordnet als tiefe Build-Struktur** der Diplomarbeit. Die Pfade sind IMMER klar, weil ce + PRT-ART je als **external Modul** an festen relativen Orten liegen (der Planer übergibt die Pfade). **Die XML nennt explizit NUR EINEN Pfad: den Ziel-Ordner, wo die Ergebnisse der Anfrage gespeichert werden** — alle übrigen Pfade (Registries, Module) sind build-strukturell statisch. Die Ergebnisse werden zuerst statisch im BUILD-Pfad generiert und nach der Messung in den XML-Ziel-Ordner **kopiert/kompiliert** (verbindet sich mit dem Mess-Rückschrieb `measurement/<ts>/`, [[project_mess_ergebnis_rueckschreibung_pipeline_persistiert]]). Der Experiment-Planer = die 3. Framework-Anwendung ([[reference_meta_driven_concept_hardening_pattern]]; §15.10-Konzeptstand).

**Why:** legt fest, wie der CEB seine Konfiguration bekommt (Registry-Auflösung + XML-Pfad + Planer-Binary-Build) — bestimmt die BRÜCKE-Increments I2 (per-Engine statische Registry-Pfade), I3/I4 (prt-art-Modul additiv per Phase; die Planer-Binary + Ergebnis-Rückschrieb) und den Standalone-Bau (28.07.-Deadline).

**How to apply:** I2-Fassade löst je Engine die Registry aus ihrem statischen CMake-Pfad auf (map engine→statischer Pfad, NICHT ein gemeinsames registry_dir/<filename>, NICHT env, NICHT Co-Location). Experiment-XML-Pfad per CMake-Default + argv/env-Override. Siehe [[feedback_vor_aufgaben_erst_projektstruktur_analyse]] (bestehenden offiziellen Pfad nutzen).
