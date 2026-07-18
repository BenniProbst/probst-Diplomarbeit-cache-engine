# #274 Schritt 7 — Kartierung + Schnitt-Vorschlag comdare-workloads (2026-07-07, read-only erhoben)

**Zweck:** Vollständige Quell-Kartierung für die Zelle `comdare-workloads`
(`Modules/comdare-measurement-all/comdare-baseline_2-workloads/comdare-workloads`), erhoben aus der
Scratch-Kopie `Research/_ce-scratch-split-20260707` (fixiert `d6d0744a`), damit der Codex-Dossier-Schritt
ohne Neu-Kartierung starten kann. Plan-Zeile (Migrationsplan §1 measurement + Schritt 7):
„dataset_loader+workload_generator+workload_driver-Generika — heilt belegte Aufwärtskante dataset_loader→test_infra".

## 1. Die drei Quellorte (alle Pfade relativ zur Scratch-Kopie)

| Ort | Dateien (Zeilen) | Namespace | Kanten |
|---|---|---|---|
| A `libs/cache_engine/builder/workload_driver/` | workload_config.hpp (290) · workload_generator.hpp (106) + .cpp (191) · workload_profiles.hpp (37) — dazu NICHT-generisch: workload_orchestrator.hpp (263), load_profile_parser.hpp (135), load_profile_writer.hpp (303)+test | `comdare::cache_engine::builder::workload_driver` | config/generator/profiles: NUR untereinander + std (**ABI-frei** ✓). orchestrator: anatomy/* + tier_observe_trace_abi (**ce-Kern**). parser/writer: `serialization/xml_config_parser` (**XML-/config-Familie**) |
| B `libs/test_infra/workload_generator/` | include/comdare/workload_generator/workload_generator.hpp (89) + src/workload_generator.cpp (143) | `comdare::workload_generator` | EINZIGE ce-Kante = `#include <cache_engine/abi/module_abi_v1.hpp>` NUR für die eine Methode `to_abi_descriptor()` (hpp:76). Alle Typen (YcsbWorkload/KeyDistribution/OperationKind/WorkloadConfig/Operation) sind IM Header selbst definiert (Z. 22–61), ABI-frei |
| C `libs/common/measurement/dataset_loader/` | include/comdare/measurement/dataset_loader/{dataset_akte.hpp (81), dataset_loader.hpp (118)} + README | `comdare::measurement::dataset_loader` | nutzt `wg::{Operation, WorkloadGenerator, WorkloadConfig, YcsbWorkload}` aus B — das IST die zu heilende Aufwärtskante common→test_infra (dataset_loader.hpp:13/17 dokumentiert sie selbst) |

**Duplikat-Befund (Plan-Frage 5-Klasse):** A und B sind ZWEI parallele Generator-Welten mit
unterschiedlichen Typen-Modellen: A = WorkloadOpKind {Insert,Lookup,Erase,Clear,Scan,RMW} + WorkloadOp +
stateful Generator mit is_valid()-Validierung + YCSB-/Zipf-Literatur-Zitaten (Cooper 2010, Gray 1994);
B = OperationKind {Read,Update,Insert,Scan,RMW,Erase} + Operation + leichter Generator. KEINE gemeinsame
Definition — Konsolidierung wäre ein Design-Entscheid, NICHT Teil der faithful-Migration.

**Konsumenten von B im ce (bleiben unberührt):** experiment_driver.hpp, i_cache_engine_tools.hpp,
experiment_demo.hpp, test_ycsb_cli.cpp, test_workload_and_experiment.cpp, apps/cache_engine_builder/main.cpp.

## 2. Schnitt-VORSCHLAG (Empfehlung für das Dossier)

1. **Zelle nimmt faithful auf:**
   - aus A: `workload_config.hpp`, `workload_generator.hpp/.cpp`, `workload_profiles.hpp`
     → `include/comdare/workloads/driver/` bzw. src/, ns `comdare::workloads::driver` (Sub-Namespace erhält
     die Welten-Trennung ehrlich).
   - aus B: Generator-Kern OHNE `to_abi_descriptor()` und OHNE den ABI-Include
     → `include/comdare/workloads/`, ns `comdare::workloads` (die EINZIGE bewusste Auslassung, Klasse
     „Test 4 nicht migriert" wie Schritt 6; ce behält B unverändert — die ABI-Naht wandert erst mit
     Schritt 13 [Research-Instanziierungs-Zellen + Übergangs-Aliase A3]).
   - aus C: `dataset_akte.hpp` + `dataset_loader.hpp` → `include/comdare/workloads/dataset/`,
     ns `comdare::workloads::dataset`, wg-Alias auf `comdare::workloads` → **Aufwärtskante geheilt**
     (zellen-intern statt common→test_infra).
2. **Bleibt Research:** workload_orchestrator (anatomy/ABI), load_profile_parser/writer (XML-Kante →
   config-/serialization-Familie; Q2-config-Gate-Nähe), B-Original samt to_abi_descriptor.
3. **Welten-Konsolidierung A↔B:** NICHT in Schritt 7 — als eigener GEPARKT-Punkt mit Empfehlung
   (B-Kern als Zellen-API, A-driver als reichere Validierungs-Welt; Owner-Entscheid User).
4. **Zellen-Norm wie pmc/metrics:** INTERFACE `comdare::workloads` + STATIC für die 2 .cpp
   (ODER: .cpp-Inhalte sind klein — prüfen ob INTERFACE+Header-only-Port sauberer; NICHT umschreiben,
   nur Bau-Form entscheiden), lokaler gtest-Tarball, Zellen-CI (lint, COMDARE_LINT_PATHS=.),
   README Herkunft+SHA, .clang-format=ce, INV-2: workloads(b2)→pmc(b1)-Kante nur falls real gebraucht
   (aktuell: KEINE — Zelle startet kanten-frei).
5. **Tests:** aus Scratch prüfen: test_ycsb_cli/test_workload_and_experiment sind ce-verdrahtet — für die
   Zelle eigene faithful-Kern-Tests ableiten (Generator-Determinismus je seed, YCSB-Mix-Verhältnisse,
   dataset_loader-Registry-Fallback) — Zuschnitt im Dossier festlegen.
6. **Remote:** NEUES Projekt `comdare/modules/comdare-measurement/comdare-baseline_2-workloads/comdare-workloads`
   (Untergruppe existiert seit #34; Projekt-Anlage = Teil des User-GO für Schritt 7 wie bei pmc/320),
   main-default + development + protected(40/40).

## 3. Umbrella-Slot

`Modules/comdare-measurement-all/CMakeLists.txt` hat den EXISTS-Slot für workloads bereits (Z. ~22/25,
Schritt-0-Anlage) — nach Zellen-Anlage nur configure-rc=0 verifizieren (Muster Schritte 5/6).

## 4. Status

Schritt 6 (HDR in metrics + #42) ist implementiert/committet (metrics `7e027d1` + Format-Pass `a7c5093`,
ctest 280/280 literal); CI-Wellen 8880 (development) + 8881 (main) liefen beim Schreiben dieser Notiz.
Schritt 7 startet mit dieser Kartierung direkt beim Dossier (Kadenz-Schritt 3).
