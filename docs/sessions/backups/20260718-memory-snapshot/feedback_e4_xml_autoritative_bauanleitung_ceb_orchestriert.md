---
name: feedback_e4_xml_autoritative_bauanleitung_ceb_orchestriert
description: "E4-XML-Vollvision (User 09.07.): die XML ist AUTORITATIVE Bauanleitung des gesamten Versuchsaufbaus — CacheEngineBuilder liest sie zur Laufzeit + kompiliert/orchestriert daraus die Tier-Binaries; Framework×Workload = eigene cache-engine-Bibliothek-Kategorie (ersetzt YcsbWorkload A-F); paralleles Achsen-Messsystem mit eigenen Abstractions"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive 2026-07-09 (bindende E4-XML-Architektur; Antwort auf Phase-4-Fork R1/R2 + Freeze-GO):**

1. **Freeze-GO erteilt:** `main.cpp` (V31.F, `v32_orchestrator.hpp:7`) darf für die E4-XML-Verdrahtung **additiv** geändert werden.

2. **Workload ≠ YcsbWorkload A–F.** YCSB wird durch **dutzende Frameworks × Workloads** ersetzt (YCSB, SOSD, TPC-C/DS, SPEC CPU, CloudSuite, mimalloc-bench …), die eine **EIGENE Bibliothek-Kategorie IN der cache-engine** bilden müssen (nicht das simple Enum). = die volle Achse W. Verbindet #31/F7 (Mess-Frameworks × Workloads) + measurement-all/comdare-workloads. Die frühere „Option A" (messreihen.xml um 3 Felder) ist damit **überholt**.

3. **Die XML ist AUTORITATIV** und steuert den GESAMTEN erzeugten Versuchsaufbau (#229 XML-only, Vollform):
   - treibt die **Limits der statischen Hauptachsen** (19 compile-time-Achsen → welche Permutationen → welche Tier-Binaries; E3/E2)
   - **mitsamt ihrer dynamischen Unter-Achs-Konfigurationen** (RC-Laufzeit; E1)
   - **gegen das PARALLELE Achsen-Messsystem** = separate System-Achsen mit EIGENEN Abstractions (Mess-Kategorien M / Observer, orthogonal zu den Algorithmus-Achsen)
   - der **CacheEngineBuilder liest die XML zu SEINER Laufzeit** (als Bauanleitung) und **lässt die Tier-Binaries kompilieren bzw. orchestriert deren Aufbau** (E4→E3→E2).

**Why:** Herzstück der Diplomarbeit (#229) in Vollform — gigantisches System (>1e14 Binaries, dutzende Frameworks×Workloads, paralleles Mess-System). Ein kleiner Fix wird dem nicht gerecht.

**How to apply:** Phase 4/#31 ist die strategisch geplante E4-XML-Vollverdrahtung, kein 1-Datei-Fix. Roadmap strategisch planen (User-Auftrag 09.07.); Reihenfolge #221 (E1-RC-Setter) vor #188 (E2-Wurzel) vom User bestätigt. Siehe [[project_e1_e4_experiment_maschinerie_und_konsolidierung]] [[feedback_elaborate_dossier_fuer_komplexe_planung]] [[feedback_achsen_thema_modul_framework_metaprogramming_interface]] [[feedback_no_runtime_switch]] [[feedback_compile_time_only_no_runtime]].
