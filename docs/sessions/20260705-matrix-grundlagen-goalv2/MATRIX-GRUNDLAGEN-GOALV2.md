# MATRIX-GRUNDLAGEN-DOKUMENT (Goal V2) — Synthese aus L1–L4

> **Nachtrag 2026-07-09 (additiv, orthogonal):** Die kanonischen **Baseline-Schichten 0-6** dieser Matrix (Modul-/Layering-Struktur) sind **orthogonal** zu den **E0-E4-Experiment-Ebenen** (Experiment-Pipeline, `docs/architektur/16_E1_E4_KONSOLIDIERUNG_DOSSIER.md` + Ledger `§10.1`). „Baseline-Schicht N" (WO lebt Code) ≠ „E-Ebene N" (WELCHE Experiment-Stufe). Beide Begriffe nie vermischen.

## TEIL 1: KANONISCHE MATRIX-REGELN

**1.1 Baseline-Schichten** (normativ `baseline-system.md:105-113` [L2]; gleichlautend WEJ:270 [L1] — Semantik überall gleich, NAMEN variieren pro Zeile, nicht jede Zeile prägt alle Stufen aus):

| Schicht | Zweck | Gelebtes Beispiel comdare-db [L3 §1] |
|---|---|---|
| 0 foundation | Plattform-/Ressourcen-Fundament, keine Domänenlogik | memory, platform, simd, threading |
| 1 primitives | kleinste Wertbausteine | serialization, biginteger |
| 2 core | Domänen-Kern-Verträge | treecore, storage, indexmanager, fingerprints |
| 3 Blöcke/Strategien | zusammengesetzte Blöcke + Strategie-Plugins | deduplication + 12 dedup-strategies |
| 4 Kern/Integration | betriebsfähiges Kernsystem | dbcore, config-db, licensing |
| 5 Außen-APIs | Service-/Außen-Schnittstellen | filestorage-api, objectstorage-api |
| 6 user-interface | Endnutzer-Frontends | db-ui |

**1.2 Matrix-Prinzip:** Zeile = Umbrella/Produkt (15 Modules-Umbrellas + Produkt comdare-db = 16 Zeilen, 185 Zellen; K:20, R:14 [L1]) × Spalte = baseline_0..N; Zelle = header-only CMake-INTERFACE-Modul mit Pflicht-Alias `comdare::<x>`, Verträge unter `include/comdare/<ns>/` (WEJ:270 [L1]; `baseline-system.md:12-25` [L2]). Baseline-Ordner = reine Sortierordner ohne CMakeLists; Root-CMakeLists bindet strikt aufsteigend ein (WEJ:47 [L1]). Kategorien-Kodierung in buildsystem.xml: `source="layer1|layer2|modules|products"` (`baseline-system.md:222` [L3 §2]). ACHTUNG zwei orthogonale Baseline-Begriffe: Domänen-Baseline (WAS) vs. Build-Baseline cd-buildsystem Layer0-4 (WIE) — kein Vendoring in beide Richtungen (`steuerrater-buildsystem.md:104-141` [L2 §3]).

**1.3 Produkt-Referenz/Fassaden:** Resolver `comdare_add_module_or_db` löst **Products → Modules → produkt-intern** auf (CMakeLists.txt:117-137 wörtlich in [L3 §3]); Modules-Stand = „reine Erbmasse hinter einer Produkt-Fassade (`comdare-X` → `comdare-X-db`/`comdare-db-X`)" (`baseline-system.md:234`); Wrapper-Beispiel: comdare-db-biginteger delegiert INTERFACE auf comdare::biginteger (WEJ:266 [L1]). Gilt NUR für Produkte — Modules untereinander konsumieren direkt via `source="modules"`.

**1.4 Invarianten (wörtlich, `baseline-system.md:232-235` [L3 §4]):**
- INV-1: Baseline-System „wiederholt sich **haargleich** in allen Modules-Umbrellas und allen Produkten … Neue Umbrellas/Produkte MÜSSEN dieses Ordnungs-, Namens- und Zellenmuster übernehmen".
- INV-2: „Eine Baseline DARF ausschließlich Interfaces **niederwertigerer** Baselines referenzieren/linken. **Regelfall: exakt die nächst-kleinere Baseline (n → n−1), keine Sprünge.** Zell-interne Abhängigkeiten innerhalb derselben Baseline … sind horizontale Vertragsbindungen und zulässig, solange kein Zyklus und keine Aufwärtskante entsteht. Aufwärtskanten (n → n+k) sind IMMER Verstöße."
- INV-3: „Produkte referenzieren ausschließlich Baselines **in Produkten** — nie direkt generische Modules."
- INV-4: „Verstöße werden **beim Linken sofort sichtbar** — das ist gewollt. Verstöße sind **Blocker, nie Workaround**. … Leitsatz: **Modules = so generisch wie möglich, Produkte = so spezifisch wie nötig.**"
- Abnahme = 5-Punkte-Prüfung: Configure-Gate ohne Fallback-WARNING, Kanten-Audit via Regex `comdare-baseline_(\d+)-`, Graphviz-DAG, Produkt-Reinheit, Vollbuild (`baseline-system.md:247-251` [L3]).

**1.5 Konventionen:** Zelle = INTERFACE-Lib, cxx_std_23, Doppel-Adressierung Targetname `comdare-<modul>` + Alias `comdare::<modul>`, Target-Guard `if(TARGET …) return()`, install/export `NAMESPACE comdare::` (`baseline-system.md:80-95` [L3]). Repo-Layout je Zelle: CMakeLists, buildsystem.xml (`<repo>BenniProbst/<modul></repo><branch>development</branch>`), `include/comdare/<ns>/*.hpp`, `tests/test_*.cpp` (GTest 1.15.2, linkt NUR eigene Zelle), sessions/, LICENSE (`baseline-system.md:67-95,268-273` [L2 §4]). buildsystem.xml v3.4.15, Schema `https://bep-venture.de/schemas/buildsystem`, grep/awk-geparst (buildsystem.xml:9 [L3 §2]). Remotes: origin=GitHub `BenniProbst/<modul>` + gitlab=`gitlab.comdare.de/comdare/modules/comdare-<gruppe>/<modul>`, Branch `development` — verifiziert an foundation/config/treecore/storage/wrappers-all [L4 §2]; Untermodul = nested Standalone-Repo mit Doppel-Remote [L4 §2]. CI: dünne ~20-30-Zeilen-.gitlab-ci.yml per include aus `comdare/cluster/ci-templates` (Projekt 269), Stufen 1-7 Pflicht (lint:secrets=Gate … manifest), GitHub-Actions-Spiegel, Baseline N baut gegen Artefakte von N-1 (`ci-blueprint.md:44-90,210-228` [L2 §4.5]).

## TEIL 2: EINORDNUNG DER 6 CACHEENGINE-MODULE

**Gemeinsamer Ist-Stand** [L4 §3]: comdare-cacheengine-all ist als Umbrella gelistet (`baseline-system.md:40`), verletzt aber INV-1: KEINE baseline_N-Ordner, keine Root-CMakeLists/buildsystem.xml (`comdare-cacheengine-all.json:7,77-78` [L2]); die 6 = INTERFACE-Header-Spiegel V41.E4.1 (2026-06-01), 2-3 Commits, orphan, ohne Tests/CI/buildsystem.xml/configure/LICENSE/sessions, Branch **main**, include-Präfix kebab-case `include/comdare-<modul>/…` statt `include/comdare/<ns>/`; Header-Stände VERALTET ggü. Monolith (Drift ungemessen — offen). Baseline-Stufenzuordnung nirgends normiert („Umbrella-Rahmen per D-5 geplant", `FEATURES-MASTER-comdare-cacheengine-all.json:11`) → Stufen unten = **Empfehlung** (Ableitung aus 1.1-Semantik), keine Norm.

| Modul | Kategorie | Schicht (Empf.) | Ist (HEAD, [L4]) | Gehört hinein (Feature-Inventar [L2 §2]) |
|---|---|---|---|---|
| isa-dispatch | Modules-Zelle | **0-foundation** (analog foundation-b0 platform/simd) | f7541de, 18 hpp, axis_09_isa + simd_extension, ns comdare::cache_engine::simd, boost::mp11 | INK-5 Plattform-Auto-Discovery 28 Concepts (i_platform_probe, cache_topology, isa_features, RCU-Flavors; Z.295-308); Multi-OS-CMake platform_detection/compiler_flags/isa_features (Z.204-217) |
| measurement | Modules-Zelle | **1-primitives** (32B-Records = kleinste Wertbausteine) | fa27bf4, 16 hpp, measurement_snapshot/pmc_source/pruef_dock-Anteile, ns comdare::cache_engine::builder | INK-8 Buffer+ThreadArena+32B-Record+Measure<Cat,Detail> (Z.340-353); V8.5 ResultAggregator (Z.540-555); Mikrobenchmark+binary_blob_writer→CSV/JSON/tikz (Z.476-491); INK-4 TelemetryStrategy 6x (Z.280-293) |
| cache-engine-core | Modules-Zelle | **2-core** (Domänen-Kern-Verträge) | e452b79 (3. Commit), 21 hpp, abi/+anatomy/+builder/, Alias comdare::cache-engine-core existiert (CMakeLists.txt:9-10) | ICacheEngine C1-C12 ~264 Bausteine (Z.71-86); Visitor+State+Pipeline-Mediator (Z.138-154); PressureState (Z.123-136); INK-2/3/6 (Z.250-323); Allokator-Familie A01-A23+AA1-AA7 (Z.387-404) |
| search-engine | Modules-Zelle | **3-Blöcke/Strategien** (Achsen-Registries+Strategien) | b6caff5, 30 hpp (größtes), Achsen-Ordner mit axis_*_registry/strategy_base/concepts | 3-Ebenen IExecutingEngine/Säule A/B (Z.39-52); S1-S30 + 22 HybridCompositionCommands (Z.54-69); 6 Seitentypen D5 (Z.88-104); module_abi_v1+module_loader (Z.406-422); V8.8 algorithm_baustein (Z.592-607) |
| build-tools | Modules-Zelle | **4-Integration** (Orchestrator) | 4fc1df4, 8 hpp, einziges mit src/tools + cmake/ (6 .cmake), ns comdare::builder::codegen | CacheEngineBuilder (xml_config_parser/codegen/permutation_loop/experiment_runner; Z.441-457); V8.7 precompiled/hot-compile (Z.574-590); NO-PYTHON-Codegen (Z.372-385); IPermutationEngine (Z.156-171); V8.3 XML+XSD (Z.510-523); V8.6 Messreihen-Parser (Z.557-572) |
| test-system | Modules-Zelle | **4-Integration** (Alternative: eigene Test-Stufe analog external-all 0-testing — offen) | 7bb9e08, 18 Dateien, pruef_dock (conformance_gate/dock/registry/sequencer) | TestDataSetAccumulationEngine (aligned Loader, YCSB/RIPE/CommonCrawl; Z.459-474); GTest-Infra gtest_setup.cmake (`comdare-cacheengine-all.json:74`) |

## TEIL 3: PRAEZISIERTE #256-EXTRAKTIONS-REGELN

**Globale Auflagen (alle Ziele):** (1) **Kopie-Extraktion zuerst** — Monolith comdare-cache-engine bleibt Quelle und wird später Konsument; „cache-engine-Baum bleibt wegen der laufenden Mess-Pipeline 286 strikt unangetastet" (WEJ:17 [L1]); Pipeline 286 = mehrtägig, nicht stören (Memory). (2) ABI-Neutralität: ABI-Freeze MAJOR 4 (Memory) + module_abi_v1 (Z.406-422 [L2]) — Extraktion darf keine ABI-Bumps erzwingen; golden/Messdaten NIE löschen (Memory-Direktive). (3) INV-2 in der Zielstruktur: nur n→n-1-Kanten (isa-dispatch←nichts intern; measurement←isa-dispatch; core←measurement; search-engine←core; build-tools/test-system←search-engine bzw. tiefer). (4) Fehlende Zellen-Pflicht-Artefakte SCHAFFEN (buildsystem.xml, configure.*, LICENSE, tests/, sessions/, Branch development, ci-templates-Include) — Umbrella-Rahmen (baseline-Ordner + Root-Aggregator + Root-buildsystem.xml) existiert noch nicht (L2 §2, L4 §3). (5) Kein QUIET/Fallback-Dummy/Silent-Skip (INV-4-Maskierungs-Verbot, WEJ:13,258 [L1]).

**Namespace-Transformation (Empfehlung, da nicht normiert):** Ist = `comdare::cache_engine::*` (build-tools: `comdare::builder::*`) [L4 §3]; Matrix-Konvention = `comdare::<modul>` + `include/comdare/<ns>/` (`baseline-system.md:93` [L2/L3]). → Generische Ziel-Namespaces `comdare::measurement`, `comdare::isa` (o.ä.), `comdare::search_engine`, `comdare::cache_engine` (core), `comdare::build_tools`, `comdare::test_system`; CMake-Alias zwingend `comdare::<modulname>`. Übergangs-Alias `namespace cache_engine = comdare::…` im Monolith zulässig (Analogie: Produkt-Spezialisierung via db-Zweig `include/comdare/db/<domain>/` [L3 §1, L4 §2]) — finale ns-Namen = Userfrage (Teil 5).

**Abgrenzung Generisches → foundation/config (NICHT extrahieren, sondern #265/#266-Reuse):** aligned Allokatoren/Arenen → comdare-memory hat bereits AlignedAllocator/MemoryPool/ThreadLocalArena [L4 §2]; generische SIMD-/Plattform-Detektion → comdare-simd/comdare-platform (comdare::simd/platform, SIMDCapabilities/SIMDDetect [L4 §2]) — isa-dispatch behält nur die cache-engine-spezifische Achsen-Registry/Concepts; XML-Config-Parsing-Generik → comdare-config (comdare::config); Observer-Telemetrie-Generik → comdare-metrics (IMeasurementObserver/MeasurementSubject, thematisch nahe measurement [L4 Delta 3]) — Abgrenzung measurement↔metrics = Userfrage.

**Reihenfolge (Empfehlung, bottom-up = INV-2-konform):** 0. Umbrella-Rahmen (baseline-Ordner, Root-CMakeLists-Aggregator, Root-buildsystem.xml, D-5) → 1. isa-dispatch → 2. measurement → 3. cache-engine-core → 4. search-engine → 5. build-tools → 6. test-system; je Modul: Header-Kopie aktualisieren (Drift schließen), Zellen-Artefakte, Tests (nur eigene Zelle), CI-Include, dann erst Monolith-Umstellung auf Konsum (letzter Schritt, nach Pipeline-286-Abschluss).

## TEIL 4: REUSE-REGELN #265/#266

- **Keine Fassade:** Fassaden (`comdare-X-db`) sind der INV-3-Mechanismus für **Produkte** (`baseline-system.md:234`); cache-engine/cacheengine-all = Modules-Umbrella bzw. Research-Repo, kein Produkt → direkter Konsum `comdare::simd/platform/memory/config` zulässig; Vertrag = INTERFACE-Target + Alias + buildsystem.xml-dependency `source="modules"` (Muster: comdare-db bindet foundation-all-Zellen `baseline_0-foundation/{memory,platform,simd,threading}` + `baseline_1-core/{concurrency,config}` via MODULES_ROOT, CMakeLists.txt:197-202 [L3 §3]).
- **Vendoring-Doktrin** (Memory, geordnet): (1) vendor is_original+Compiler → (2) faithful Re-Impl → (3) self-contained. Für #265/#266: Stufe 1 = foundation-/config-Zellen als Quelle einbinden (nested-Repo-/Doppel-Remote-Muster ist etabliert [L4 §2]; Monolith hat bereits ext/-Vendor-Ordner [L2 §2]).
- **Bekannte Quell-Verstöße einpreisen:** simd→platform + threading→platform = intra-B0-„GRENZFALL" — **simd setzt platform voraus** (`comdare-foundation-all.json:87-100` [L2]) → platform immer mitvendorn; compression/crypto-hash im foundation-Root nicht verdrahtet (`:101-107`).
- **Gültiger Vertrag:** cxx_std_23, GTest 1.15.2 (Drift 1.14/1.16 nicht übernehmen, WEJ:43,137 [L1]), keine internen HTTP-FetchContent-Fallbacks (`baseline-system.md:299`), ENV `COMDARE_*`-Wurzeln aus `<exports>` (`baseline-system.md:219-224` [L2]).
- **config-Quelle:** foundation-all-b1 UND config-all-b1 führen comdare-config (PL:31 vs. PL:66 [L1]; `comdare-config-all.json:13` [L2]) — Owner OFFEN, vor #266 klären.

## TEIL 5: OFFENE KONVENTIONSFRAGEN (an User, mit Empfehlung)

1. **Baseline-Stufen der 6 Module** (nirgends normiert, D-5 offen): Empfehlung = Tabelle Teil 2 (0/1/2/3/4/4); Alternativ-Frage: test-system als eigene Stufe analog external-all `0-testing`?
2. **Kanonische config-Quelle #266** (foundation-all-b1 vs. config-all-b1): Empfehlung config-all (dediziertes Umbrella, ~3500 LOC, aus Products verschoben, Session 2602 [L2 §2]); foundation-all-Kopie dann als Duplikat abbauen — Entscheidung nötig.
3. **Namespace-Zielform:** `comdare::cache_engine::*` beibehalten (Monolith-kompatibel) vs. generisch `comdare::<modul>` (Matrix-konform, `baseline-system.md:93`)? Empfehlung: generisch + Übergangs-Alias; CMake-Alias `comdare::<modul>` in jedem Fall Pflicht.
4. **Include-Präfix + Target-Naming angleichen:** kebab-case `include/comdare-<modul>/` + `comdare_module_*`-Targets (Skelett-Stil) vs. Norm `include/comdare/<ns>/` + `comdare-<modul>` ([L2 §5], [L4 §3]) — Empfehlung: Norm, da INV-1 „haargleich".
5. **Branch-Umstellung** der 6 von `main` auf `development` (Matrix-Konvention verifiziert [L4 §2]) — Empfehlung: ja, bei Extraktion.
6. **Umbrella-Repo-Frage:** cacheengine-all-Ordner ist heute Teil des übergeordneten Projekte-Repos, kein eigenes Gruppen-Repo [L4 §3]; foundation-all hat eigenes Gruppen-Repo — eigenes `comdare-cacheengine-all`-Repo anlegen? Empfehlung: ja (INV-1 + Root-buildsystem.xml braucht Repo-Heimat).
7. **measurement ↔ comdare-metrics Abgrenzung** (Observer-Familie thematisch überlappend [L4 Delta 3]): Empfehlung: metrics = generische Observer-Verträge, measurement = cache-engine-Messdomäne (32B-Records/PMC); Bestätigung nötig.
8. Nachrichtlich (nicht blockierend): 16-vs-22-Umbrella-Zählung (WEJ:15 vs. K:20) und `audit:layering` fehlt im ci-blueprint (K:46) — betrifft #256 nur indirekt (CI-Job bei Neuanlage mit aufnehmen).

---
Quelle: ultracode wf_86d01d58-72b (5 Agenten, 491k Tokens) ueber _backup-discovery-rohdaten-20260702 (comdare-db) + gelebte Baseline + Modules-Ist. Rohdaten: wf_86d01d58-journal.jsonl (additiv, nie loeschen).
