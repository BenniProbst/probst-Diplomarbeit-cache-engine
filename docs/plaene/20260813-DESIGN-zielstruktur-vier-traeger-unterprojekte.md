# DESIGN #29 — ZIELSTRUKTUR-SCHNITT: DIE VIER TRÄGER-UNTERPROJEKTE (13.08.2026)

> **Auftrag:** Task **#29** der Task-Zuordnung 13.08. (Wellenplan §18.4): *„Zielstruktur-SCHNITT der vier Traeger-Unterprojekte VOR dem S-8-Bau (WE-Design-Posten); voller Monolith-Split -> W7/#88 (‚beim Aufraeumen')"* — Anker **KON43-01/2+02**, Abstimmung **S-6d/#67** (Include-Kanten).
> **Owner verbatim 12.08.2026 (KON43):** *„Ich lege weiterhin hiermit fest, dass wir **erst den Planer aufbauen, dann die CEB, dann die Tier-Binaries und dann Hybrid. In der Reihenfolge und nicht anders.** Im Projekt der cache engine brauchen wir also **4 unter-Projekte die in Träger-stufenform aufeinander aufbauen**. Wir **splitten den aktuellen Monolithen falls noch nicht erfolgt in übersichtliche Ordnerstrukturen beim Aufräumen**."*
> **Scope-Grenze:** Dieses Dokument ist NUR der Schnitt-Plan (das Zielbild, das S-8/S-9/S-12 brauchen). Der **volle Monolith-Split ist W7/#88** und wird hier nicht vollzogen (KON43-02: *„nicht vor F1/F2 erzwungen"*).
> **Quellen-Stand:** Ledger-Kopf **KON59** (13.08.) · ce-Baum **@ 5f3f26a5** (nur lesend vermessen) · Wellenplan §18 (13.08.) · Strecke 20260812-WELLENKONSOLIDIERUNG Teil B. Jede Zahl unten am Objekt gemessen, Nenner steht dabei; Nichtfunde mit Gegenprobe.
> **Namens-Stand (Owner B3, 13.08.):** Entscheid englisch -- alle Traeger-Zielnamen dieses Dokuments fuehren `planner` (nicht `planer`); die Kollision mit dem Bestand profile_facade/planner ist damit aufgeloest (ein Name, eine Schreibweise). Umgestellt bei der Welle-2-Landung.

⚠️ **Nummern-Warnung (V12):** Im Wellenplan existieren ZWEI „#29": der **W7-Zähl-Posten** „wide_aggregat-Dedup" (§13.3, Wellenplan Z. 1452/1756) und DIESER **§18.4-Posten** „Zielstruktur-Schnitt" (Z. 2152). In jeder Task-Liste den GEGENSTAND mitführen, nie die Nummer allein.

---

## 1. ZIELBILD — zwei orthogonale Ordnungen, eine Struktur

KON43-01(3) dockt den Split ans Home-Prinzip (KON27-01) an: **Achsen-Homes ordnen die KATEGORIEN, die Unter-Projekte ordnen die TRÄGER — zwei orthogonale Ordnungen derselben Ziel-Struktur.** Daraus folgt die wichtigste Design-Aussage dieses Schnitts:

**Die vier Unter-Projekte sind KEINE Vier-Teilung des ganzen Baums.** Sie sind die vier träger-eigenen Zonen; daneben stehen zwei stufen-NEUTRALE Zonen, die jede Stufe konsumieren darf:

```
STUFENFORM (Traeger-Ordnung, KON43-01/1+2)                 STUFEN-NEUTRAL (beide Ordnungen bedienend)
                                                           
  traeger/planner   Stufe 1  (NUR der Planer wird           QUERSCHNITT  include/cache_engine/
     ^                        direkt kompiliert, KON17-01)               (ABI/Stempel S-1..S-7, Mess-
     |  N+1 haengt NUR an N,                                             Registries, Concepts, Platform)
     |  nie umgekehrt                                       FACH/KATEGORIEN  axes/ (=ORGAN-Home) ·
  traeger/ceb       Stufe 2                                              topics/ · anatomy/ (Flaeche-1-
     ^                                                                   Vertraege) · src/ · compositions/
  traeger/tier      Stufe 3  (Emission: .so-Module,                      · subsystems/ ... — MESS/SYSTEM-
     ^                        ABI-stabil RUECKWAERTS in                  Homes legt S-18/#16 an (KON27-01)
     |                        die CEB gesteckt, KON25-08)
  traeger/hybrid    Stufe 4
```

* **Stufen-Regel** (KON43-01/2): die Projektstruktur bildet die Kette ab — Stufe N+1 hängt nur von Stufe N ab, nie umgekehrt. Die Regel bindet die **vier Träger-Projekte untereinander**; Querschnitt und Fach sind stufen-neutral (die Stempel-Strecke „widerspricht der Reihenfolge nicht, sie bedient sie", KON43-01/1).
* **Auflösung des scheinbaren Widerspruchs „CEB hängt an Tier":** die heute massiven Kanten builder→anatomy/topics/axes (85+48+12, §3a) sind **CEB→FACH**, nicht CEB→TIER — denn das TIER-Unterprojekt besitzt nur **Emission + Modul-Skelett + Harness**, nicht die Fach-Substanz, die in die Tier-Binaries hineinkompiliert wird. Die Rakete (KON25-08) steckt Tier-Module zur LAUFZEIT ABI-stabil in die CEB; die ABI-Deklaration (`include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp`) liegt im Querschnitt, zieht ihrerseits aber die Fläche-1-Verträge aus anatomy/ (§3b.5) — es braucht keine Compile-Kante CEB→TIER.
* **Emission bleibt Doktrin:** keine YAML in der Kette; jede Stufe emittiert die nächste über das EINE zentrale Bau-Modul = **Planer-Bibliothek in C++23** (KON16-03/KON18-01) ⇒ das Bau-Modul gehört ins **Planer-Unterprojekt**, die höheren Stufen linken es (stufenkonform: N+1→N). CiYamlBuilder bleibt für den LOKALEN Build (KON25-04).
* **S-12-Anschluss:** vier Mini-Pipelines je Träger (**KON10-02**: Owner 11.08., eigene Mini-Pipeline je Träger-Stufe, D17 fünf CI-Stufen, CiYamlBuilder→Child-Pipeline; KON25-08 stützt die Emissionsliste = volle Pipeline, KON25-04 den CiYamlBuilder lokal; IST 12.08.: **0 von 4 Trägern** mit eigenem Bau-/Test-Job, super 45 Jobs · ce 25 · „hybrid" 0 Treffer — KON23-05/E). Der Schnitt liefert je Träger **ein Projekt-Home + einen stabilen Target-Namen** als Aufhänger; die Jobs selbst baut S-12.

### Vorschlag Wurzel und Namen (Abstimmung S-6d/#67, siehe §6)

```
libs/traeger/                 # NEU — die vier Unter-Projekte; Monolith libs/cache_engine bleibt daneben bis #88
  planner/  CMakeLists.txt    # Ziel: comdare_planner       — Stufe 1
  ceb/      CMakeLists.txt    # Ziel: comdare_ceb           — Stufe 2, linkt NUR comdare_planner (+Q/Fach)
  tier/     CMakeLists.txt    # Ziel: comdare_tier_emission — Stufe 3, linkt NUR comdare_ceb (+Q/Fach)
  hybrid/   CMakeLists.txt    # Ziel: comdare_hybrid        — Stufe 4, linkt NUR comdare_tier_emission (+Q)
```

End-Zustand nach #88: `libs/cache_engine/` reduziert sich auf **Querschnitt + Fach-Homes**, alle Träger-Substanz lebt unter `libs/traeger/*`. Neue Projekte bekommen eine EIGENE Include-Wurzel (`<traeger/planner/...>`), die PUBLIC-Wurzel des Monolithen (`profile_facade/CMakeLists.txt:89` setzt `${PROJECT_SOURCE_DIR}/libs/cache_engine`) wird NICHT erweitert.
**Nicht verwechseln:** `modules/` (6 „funktionale Säulen", V41.E4-Altskelett, nur README) ist eine ANDERE, abgelöste Ordnung — bei #88 deprecaten (nie löschen, Doku-Policy), damit niemand die Träger-Projekte dort hineinbaut.

---

## 2. IST-AUFMASS DES MONOLITHEN — Verzeichnis→Ziel-Zuordnung (Besitzkarte)

Monolith `libs/cache_engine/` @ 5f3f26a5: **1.292 C++-Dateien (hpp+cpp) / 157.192 Zeilen** (Nenner: `find`-Zählung; der Monolith hat **18 Unterverzeichnisse, davon 16 mit C++-Bestand** — algorithm_profiles und concurrency_manager ohne, §2d; keine .h/.cc/.ipp vorhanden). Vollständige Zerlegung — die drei Zonen summieren exakt auf den Gesamtbestand (219+209+864 D. = 1.292 · 58.633+31.168+67.391 Z. = 157.192):

### 2a. Träger-eigene Substanz → die vier Unter-Projekte (219 D. / 58.633 Z. = 37 %)

| Verzeichnis | Dateien | Zeilen | Ziel-Träger | Beleg/Bemerkung |
|---|---|---|---|---|
| `profile_facade/` (Wurzel 22 D.) | 32 | 15.437 | **PLANER** (1) | KON47-01: „die Planer-Substanz (Director, plan_legend, planner_*-Familie) lebt als profile_facade/planner/ im Monolithen" |
| — davon `profile_facade/planner/` | 10 | 4.721 | **PLANER** (1) | experiment_plan_director, plan_legend, planner_version … |
| `builder/` (35 Unterverzeichnisse: 22 C++-tragende 156 D./35.376 Z. + 13 leere Skelette → #88-Triage; dazu 13 Wurzel-D./3.152 Z.) | 169 | 38.528 | **CEB** (2) | build_orchestrator, pruef_dock, experiment_driver …; Brücken-Naht-Familien s. §4.3 |
| `mess/` | 6 | 1.140 | **TIER** (3) | genus_kaskade, steuer_dock, mess_naht = Tier-Laufzeit-Messkaskade (Fläche 3); Naht-TYPEN → Querschnitt, s. K2 |
| `harness/` | 2 | 612 | **TIER** (3) | drift_gated_cell, perm_runner = Mess-Harness des Tier-Laufs |
| `hybrid/` | 4 | 955 | **HYBRID** (4) | heuristik_adapter_* (Heuristik-Adapter-Gattung, Reroute-Genus); 0 Produktions-Konsumenten, nur 3 Unit-Tests → frei formbar |
| `heuristik/` | 6 | 1.961 | **HYBRID** (4), Vorschlag | break_even, axis_spline, workload_cluster; nur 4 Test-Konsumenten; Planer-Mitnutzung (Break-Even-Bereichskarte KON7-05) offen, s. §6 |

### 2b. Querschnitt — stufen-neutral, Identität (209 D. / 31.168 Z.)

| Verzeichnis | Dateien | Zeilen | Inhalt |
|---|---|---|---|
| `include/cache_engine/` | 209 | 31.168 | abi 29/6.898 (stempel_basis, anatomy_module_abi_v1_decl — die S-1..S-7-Strecke) · measurement 70/17.046 (Registries, algo_semver, simd_build_gate) · concepts 52/2.403 · allocators 32/2.799 · platform 13/623 · platform_probe 3/358 · api 4/480 · fingerprint 2/181 · hbm 1/193 · indexes 2/168 · Wurzel 1 |

### 2c. Fach/Kategorien — stufen-neutral, Home-Prinzip KON27-01 (864 D. / 67.391 Z.)

| Verzeichnis | Dateien | Zeilen | Rolle |
|---|---|---|---|
| `axes/` | 345 | 42.108 | **ORGAN-Home** (existiert; MESS/SYSTEM-Homes legt S-18/#16 in W1 an) |
| `topics/` | 425 | 10.737 | Kategorien-Konfigmengen (topic_*_config_set) |
| `anatomy/` | 55 | 11.008 | **Fläche-1-Verträge** (Gattung/Genus-Interfaces: *_tier, *_anatomy, adapter, observable — Interface-Hierarchie, KEINE Achsen) |
| `src/` | 9 | 1.380 | CT-SHA, Permutations-Engine, Concepts |
| `compositions/` | 14 | 1.290 | Referenz-Kompositionen (ART/HOT/SuRF …) |
| `subsystems/` | 12 | 376 | 12 i_*-Engine-Interfaces |
| `execution_engine/` + `virus/` + `reclamation/` | 4 | 492 | Klein-Fach |

### 2d. Außerhalb des C++-Aufmaßes (Zuordnung bei #88)

* `algorithm_profiles/`: **95 Dateien = 91 XML + 4 MD** → Planer-EINGABEDATEN (Daten-Home des Planer-Projekts).
* `concurrency_manager/`: 0 C++ (nur .gitkeep/CMakeLists, wird aber in `libs/cache_engine/CMakeLists.txt:6` ge-add_subdirectory-t) → Fach-Skelett, #88-Triage.
* `apps/`: **9 Binaries** (je 1 `add_executable` in 9 CMakeLists; Gegenprobe `apps/CMakeLists.txt` selbst: 0). ⚠️ Abweichung deklariert: KON47-01 nennt „10 Binaries" — an 5f3f26a5 nicht reproduziert (9/9 gemessen). Zuordnung: experiment_planner→PLANER · cache_engine_builder→CEB · perm_runner→TIER-Harness · adhoc_emitter/anatomy_codegen_tool/catalog_codegen_tool→Bau-Modul-Werkzeuge (Planer-Bibliothek) · f15_compare/h2_score_akte_tool/is_original_validator→Werkzeuge. `tools/`: **13 weitere add_executable**. Beide Listen sind Behelfs-Bestand gegen das Vier-Binary-Typen-Ziel (Planer→CEB→Tier→Hybrid) — **Absorption ist W7/#88**, nicht dieser Schnitt.
* `tests/`: unit **500 .cpp**; `integration/`, `generic_module_tests/`, `module_specific_tests/` sind Skelette (nur CMakeLists) → Ziel-Testmodule je Träger liefert **#28 TEST-KONSOLIDIERUNG** (KON37-08), abgestimmt auf DIESE Struktur.
* `libs/`-Geschwister (kein Teil des Monolith-Schnitts): common 17 D./3.973 Z. (Mess-Wrapper=Querschnitt-Infra) · execution_engine 3/260 · test_infra 11/957 · search_engine 0 C++ (Skelett) → #88-Triage.

---

## 3. INCLUDE-KANTEN-LAGE an den künftigen Grenzen (am Objekt gemessen)

Messmethode: `grep -r '#include' je Quell-Zone`, klassifiziert nach Ziel-Zone; Gegenproben: Richtungs-grep der Gegenrichtung und Suche nach relativen `"../"`-Includes. **Zählweise (A2.5 geschärft): nur echte `#include`-Direktiven (Zeilenanfang), direkte UND relative Pfade aufgelöst; Kommentar-Erwähnungen von Include-Pfaden zählen nicht** — die früheren Werte 58 (planner→Querschnitt), 51 (ceb→Querschnitt) und 4 (planner→compositions) enthielten solche, und relative Kanten in `include/` fehlten (→builder 3 der jetzt 6, →Fach alle 20, §3a/§3c). Aus den Fach-Zonen aufwärts bleiben es 0 Treffer.

### 3a. Kanten-Matrix (Produktions-Code libs/cache_engine, ohne Tests)

Eine Zählweise für alle Zellen (A2.5-Neumessung): **echte `#include`-Direktiven (Zeilenanfang), direkte UND relative Pfade aufgelöst; Kommentar-Erwähnungen zählen nicht.**

| von \ nach | planner (profile_facade) | ceb (builder) | tier (mess+harness) | hybrid (+heuristik) | Querschnitt (include/) | Fach (axes/topics/anatomy/…) |
|---|---|---|---|---|---|---|
| **planner** | 11 intern | **49** ⛔ | **1** ⛔ (→harness) | 0 | 56 ✓ | 25 ✓ (topics 15 · axes 4 · compositions 3 · anatomy 1 · src 2) |
| **ceb** | **0** ✓ (Gegenprobe leer) | 20 intern | **3** ⛔ (mess 1 + harness 2) | 0 | 50 ✓ (49 direkt + 1 relativ: commands/auto_permutator.hpp:10) | **147** ✓ (anatomy 85 = 74 direkt + 11 relativ · topics 48 · axes 12 · compositions 1 · src 1) |
| **tier** | 0 | 10 ✓ (mess→builder 2 + harness→builder 8; Stufe 3→2 erlaubt) | 7 intern | 0 | 1 ✓ (perm_runner.hpp:30) | 4 ✓ (perm_runner.hpp:26-29 → anatomy) |
| **hybrid** | 0 | 0 ✓ | 0 | 0 | 1 ✓ (heuristik) | 4 ✓ (hybrid→anatomy) |
| **Querschnitt** | 0 | **6** ⛔ (api/i_cache_engine_tools.hpp:23-25 + abi/cache_engine_execution_engine_adapter.hpp:14-16) | 0 | 0 | — | 20 (anatomy 13 · topics 4 · axes 3) |
| **Fach** (alle 9 Verz.) | 0 ✓ | 0 ✓ | 0 ✓ | 0 ✓ | ✓ | — |

✓ = stufenkonform oder stufen-neutral · ⛔ = verbotene Richtung im Zielbild.
**Summe verbotene Richtung: 59 Lib-Kanten (49+1+3+6) + 2 App-Kanten (apps/experiment_planner→builder) = 61 Kanten** — gegen 1.292 Dateien eine kleine, präzise benennbare Menge. Zählentscheid deklariert: die →builder-Kanten der drei Bau-Modul-Werkzeug-Apps (adhoc_emitter 2, catalog_codegen_tool 2, anatomy_codegen_tool 1) sind hier bewusst NICHT gezählt (Behelfs-CLIs, Absorption W7/#88).

### 3b. Wo es SAUBER schneidet (die guten Nachrichten, je mit Gegenprobe)

1. **builder→profile_facade = 0** — die künftige Pflicht-Kante CEB→PLANER ist heute unbelegt: dort ist nichts RÜCKzubauen, nur AUFzubauen.
2. **Fach→Träger = 0** aus allen neun Fach-Verzeichnissen (axes, topics, anatomy, src, compositions, subsystems, execution_engine, virus, reclamation; je Verzeichnis einzeln gemessen, zusätzlich Gegenprobe über relative Includes) — die Kategorien-Homes sind bereits träger-rein.
3. **hybrid/ und heuristik/ sind Inseln:** hybrid nur 4 Kanten →anatomy (Fach), heuristik 1 →Querschnitt; Konsumenten ausschließlich Tests (hybrid: 3, heuristik: 4 Unit-Tests). Das Stufe-4-Projekt ist frei formbar (HY-A baut auf grüner Wiese).
4. **Die Tier-Emissions-Wurzel ist EIN Header:** das emittierte Tier-Modul inkludiert genau EINE Zeile — `<builder/codegen/all_axes_umbrella.hpp>` (`builder/codegen/adhoc_emitter.hpp:92`); der Umbrella hat 53 Z. mit 26 Includes (20 topics + 4 axes + 1 anatomy + 1 cache_engine) und ist reine Fach-Aggregation. Tier-Module werden als SHARED gebaut (`cmake/adhoc_emitter.cmake:155`). ⇒ Der Umzug der Emissions-Wurzel ins Tier-Projekt ist bei #88 eine Ein-Punkt-Operation.
5. **Querschnitt fast rein Richtung Träger:** 6 Kanten aus 2 Dateien (K3 unten), sonst 0 in alle Träger-Zonen. Richtung FACH ist der Querschnitt dagegen NICHT rein — **20 Kanten** (Quell-Verteilung: abi/ 11 · measurement/ 4 · Rest 5; Ziele: anatomy 13 · topics 4 · axes 3, alle relativ): die ABI-Deklarationen (inkl. `anatomy_module_abi_v1_decl.hpp:17-20`) ziehen die Fläche-1-Verträge aus anatomy/. Für das §1-Argument bleibt die Folgerung (keine Compile-Kante CEB→TIER nötig) bestehen, aber der Querschnitt lehnt am Fach — wer Querschnitt konsumiert, bekommt anatomy transitiv mit; bei #88 entscheiden: Verträge in den Querschnitt heben oder die Kante Querschnitt→Fach deklarieren.
6. **harness/ ist NICHT fach-frei** (Matrix-Korrektur A2.5): `perm_runner.hpp` zieht 4× anatomy (Fach, :26-29) + 1× cache_engine/measurement (Querschnitt, :30) — stufen-neutral erlaubt, wandert beim Tier-Umzug einfach mit.

### 3c. Wo es NICHT sauber schneidet — die vier benannten Schmutz-Kanten-Familien

* **K1 — RICHTUNGS-INVERSION PLANER→CEB (49+2 Kanten, die Hauptlast):** profile_facade inkludiert builder — Schwerpunkt `experiment_tree` **26**, `bestandslog` **8**, `build_orchestrator` **6**, codegen 2, driver_build_variant_signature 2, je 1 workload_driver/measure_storage/lager_ablage/ceb_version_stamp/artifact_transport (Summe 49); dichteste Dateien: profile_run_facade.cpp (8), profile_run_entry.hpp (7), lazy_adhoc_source_gen.hpp (6), planner/experiment_plan_director.hpp (5). Der Code deklariert die heutige Schichtung sogar wörtlich: *„TEIL2 lebt in der BUILDER-Schicht (Layering: planner -> builder)"* (`profile_facade/planner/experiment_dock_payload.hpp:24`). Das Zielbild verlangt die GEGENRICHTUNG. **Auflösung (#88):** die plan-seitigen Single-Source-Header aus experiment_tree (axis_path_serialization/kCompositionAxisNames, progress_delta, slice_marker) und die Bau-Modul-Anteile wandern in Planer-Projekt bzw. Querschnitt; die Builder-/Iterator-Seite bleibt CEB. **Bis dahin (S-8-Regel):** §4-Brückenmarker. — Daneben, NICHT Teil der 49 (Fach-Richtung, stufen-neutral): planner→src **2** (`<sha512/ctsha512.hpp>`, `<permutations/permutation_engine.hpp>` via src-Include-Wurzel) als eigene Mini-Familie, damit die Besitzkarte `src/` nicht übersieht.
* **K2 — ZYKLUS builder↔mess (3 Kanten, measure_storage-Naht):** `builder/measure_storage/checkpoint_measure.hpp:48 → mess/konfiguration.hpp` UND `mess/konfiguration.hpp:58 → builder/measure_storage/mess_arena.hpp` + `mess/mess_naht.hpp:40 → builder/measure_storage/checkpoint_measure.hpp`. Egal wie mess/ zugeordnet wird, EINE Hälfte ist verboten. **Auflösung:** die geteilten Typen (MessEbene, MessCheckpointZeile, Arena-Formel-PODs) in den Querschnitt `include/cache_engine/measurement/` heben — Zeitfenster: mit #18/S-13 (die dort ohnehin an measure_storage bauen) oder spätestens #88.
* **K3 — QUERSCHNITT→CEB (6 Kanten, 2 Dateien):** `include/cache_engine/api/i_cache_engine_tools.hpp:23-25` zieht `builder/commands/welch_t_test.hpp`, `mann_whitney_u_test.hpp`, `builder/codegen/adhoc_emitter.hpp`; UND `include/cache_engine/abi/cache_engine_execution_engine_adapter.hpp:14-16` zieht relativ `../../../builder/commands/{execute_engine_command,execution_result,workload}.hpp` — ein ABI-Header der Stempel-Zone (S-1..S-7) zieht Builder-Kommando-Interna. Kein Kopf des Querschnitts darf im Zielbild Träger-Inneres kennen. **Auflösung (#88):** beide Köpfe entkoppeln (Interface im Querschnitt, Implementierung im CEB-Projekt).
* **K4 — PLANER→TIER (1 Kante):** `profile_facade/profile_run_facade.cpp` → harness/. Stufe 1→3 rückwärts. **Auflösung:** mit K1 (die Fassade delegiert künftig über die CEB-Stufe bzw. der Lauf-Einstieg wandert). — Die Gegenstücke `builder/experiment_tree/cache_engine_builder_iterator.hpp → harness/` (2 Kanten, in K-Summe „ceb→tier 3" enthalten) lösen sich mit derselben Zuordnungsentscheidung; harness→builder (8) und mess→builder (2) sind als Stufe-3→2-Kanten bereits stufenkonform.

**Übergabe an S-6d/#67:** #67s Alt-Zahlen („4 Familien, 142 Include-Kanten / 29 Wanderungen") haben im Ledger **0 Belegstellen** und sind per Owner-Wort *„Bitte explore und schärfen, behalten"* neu zu erheben — die Matrix in §3a und die K-Familien in §3c sind die frische, objektgemessene Basis dafür. Namensrelevant für #67: die Kollision **`planner` (EN, Bestand: profile_facade/planner) vs `planer` (DE, Zielname)** ist ENTSCHIEDEN (Owner B3, 13.08.: englisch) -- der Zielname ist `planner`, deckungsgleich mit dem Bestand; dieses Dokument fuehrt durchgaengig `planner`.

---

## 4. WAS VOR S-8 GESCHIEHT (der #29-Schnitt) — und was NICHT

**Zeit-Lesart, deklariert:** §18.4 führt #29 im WE-22./23.-Block, der Posten-Text und KON43-02 sagen aber **„VOR dem S-8-Bau"**, und die Strecke (P.31) startet S-8 bereits **Mo 17.–Mi 19.08.** Der GEGENSTAND bindet (V12): Design = DIESES Dokument (13.08.), der Skeleton-Commit landet im **WE-15./16.-Fenster vor dem ersten S-8-Commit**. Er ist klein; einzige Bestands-Berührung ist EINE Anschluss-Zeile in der Repo-Wurzel-CMakeLists.txt (§4.2) — der Ein-Schreiber-Konflikt dort ist vor dem Commit gegen die parallel laufenden WE-Stränge zu prüfen.

**VOR S-8 (Umfang des Schnitts — bewusst minimal):**

1. **Dieses Zielbild + Besitzkarte** (§1–§3) als Plan-Dokument landen — der eigentliche (W)-Posten.
2. **Skeleton-Commit** (1 Commit: NEUE Dateien `libs/traeger/**` PLUS GENAU EINE Anschluss-Zeile `add_subdirectory(libs/traeger)` in der bestehenden **Repo-Wurzel-CMakeLists.txt** — es gibt KEIN `libs/CMakeLists.txt`, `libs/*` hängt direkt an der Wurzel, Z. 737–753): `libs/traeger/{planner,ceb,tier,hybrid}/CMakeLists.txt` + je ein README mit Zeiger auf die Besitzkarte; `add_subdirectory`-Kette in Stufenreihenfolge; je Projekt ein (zunächst leeres INTERFACE-)Ziel mit stabilem Namen; `target_link_libraries` bildet die Stufenkette N+1→N ab. Damit steht der Stufen-Vertrag **compile-time**, bevor Substanz einzieht („erst laute Compile-Fehler, dann verschieben"). tier/ und hybrid/ bleiben reine Skelette — kein Ketten-Bau an einer höheren Stufe, bevor die niedrigere steht (KON43-01/1). Die eine Bestands-Zeile ist die einzige Schreiber-Berührung — vor dem Commit den Ein-Schreiber-Konflikt an der Wurzel-CMakeLists.txt gegen die parallel laufenden WE-Stränge prüfen. **Timing-Voraussetzung:** die ce-Schreibsperre der laufenden Wellen-Landung (KON59-02) ist aufgehoben; der Skeleton landet danach im WE-15./16.-Fenster.
3. **Brücken-Regel für S-8/S-9 (Zielform-Pflicht KON43-02 konkretisiert):** Neubauten entstehen unter `traeger/planner/` (S-8: IPlanBuilder/CMakeGraphBuilder/CiYamlBuilder/2-Pass) bzw. `traeger/ceb/` (S-9). Erlaubte Includes ohne Auflage: Querschnitt + Fach + eigene Stufe + Stufe N−1. Wo S-8 Bestand aus builder/ WIEDERVERWENDEN muss (Bestands-Pflicht A2.2 — keine Neuimplementierung!), ist die Kante erlaubt und trägt einen greppbaren ASCII-Marker `// TRAEGER-BRUECKE(#88): <Zielort>`. Brückenfähig MIT Marker ist die am Objekt gemessene **K1-Vollmenge der Naht-Familien** (experiment_tree 26 · bestandslog 8 · build_orchestrator/orch_make_stem 6 · codegen/adhoc_emitter+type_name 2 · driver_build_variant_signature 2 · je 1 workload_driver, measure_storage/checkpoint_speicher, lager_ablage, ceb_version_stamp, artifact_transport); eine Brücke AUSSERHALB dieser Liste ist erlaubt, wenn sie im selben Commit in die Besitzkarte (§3c) nachgetragen wird — lauter Zugang statt Verbot, sonst kollidierte die Regel mit der Bestands-Pflicht A2.2 (S-8s 2-Pass braucht absehbar den codegen-Emitter-Bestand, heute von `lazy_adhoc_source_gen.hpp` gezogen). Jede Brücke ist damit ein gezählter #88-Wanderposten statt stiller Neuverschmutzung.
4. **Grenz-Wache als Google-Test** (kein Shell, KON6-05; Bau-Muster existiert: test_vs_taxonomie_klassen_grep): prüft (a) keine Include-Kante Stufe N→N+1 innerhalb `libs/traeger/`, (b) jede traeger→builder-Kante trägt den Brücken-Marker. Sie zieht **MIT dem ersten S-8-Commit** ein (gleiches Paket) — und dabei gilt NE-16 (KON59-02): neuer ctest/CI-Job zuerst in den Wachen-Inventar-Nenner, sonst entsteht wieder eine unbewachte Wache.
5. **Neutralitäts-Beleg:** der Schnitt ist preimage-/golden-neutral (KON43-02 „kein Preimage-Bezug") — nur neue Dateien, kein Eintrag von kOverlaySourceSet berührt, kein Versions-Bump, kein Neubau der 158/718-Riegel-Menge.

**NICHT vor S-8 (alles W7/#88 — „beim Aufräumen", konsolidieren→archivieren→in der Zielform aktivieren, KON11-01):**

* KEIN Datei-Umzug des Bestands (weder profile_facade→planner noch builder→ceb etc.), keine Include-Rewrites im 1.292-Dateien-Monolithen, keine CMake-Umverdrahtung bestehender Ziele.
* KEINE Auflösung von K1–K4 (nur Deklaration + Marker); keine Absorption der 9 apps-/13 tools-Behelfs-CLIs in die vier Binary-Typen.
* KEINE Test-Umzüge (#28 macht in W2 nur Eigentümer+Inventur; Verteilung als Dauerposten mit S-16 bis W4).
* KEINE CI-Job-Änderungen (die vier Mini-Pipelines baut S-12 in W2 auf die hier geschaffenen Target-Anker).
* KEINE modules/-Bereinigung, keine algorithm_profiles-Wanderung, keine libs-Geschwister-Triage.

**#29-Rest → W7 (gezählt, §18.5):** der volle Monolith-Split ist dort als „#29-Rest voller Monolith-Split (#88-Familie)" bereits verbucht.

---

## 5. RISIKEN (benannt, mit Gegenmittel)

* **R1 — K1 wächst während S-8:** jede neue planner→builder-Kante ohne Marker vergrößert die Inversion unsichtbar. Gegenmittel: Brücken-Regel + Grenz-Wache (§4.3/4.4) im SELBEN Paket wie der erste S-8-Commit.
* **R2 — K2-Knoten wächst in W2:** #13 (T-15b, checkpoint_speicher-Ripple :119-123) und #18/S-13 (measurement_sink) bauen genau an der measure_storage-Naht. Gegenmittel: beide Tasks erhalten den K2-Befund als Auflage („Typ-Hebung mitdenken, Knoten nicht verdicken").
* **R3 — Nummern-Doppelbelegung #29** (wide_aggregat-Dedup vs Zielstruktur): in jeder Liste Gegenstand mitführen (V12).
* **R4 — Namens-Drift bricht S-12:** die Mini-Pipeline-Jobs hängen an Target-Namen; wenn S-6d/#67 später Namen dreht, nur über ALIAS-Ziele drehen, nie die Erst-Namen brechen.
* **R5 — Include-Wurzel-Kollision:** `<cache_engine/...>` ist doppelt lesbar (include/cache_engine vs libs/cache_engine-Wurzel); die DRITTE Include-Wurzel `libs/cache_engine/src` macht `<measurement/...>`, `<concepts/...>`, `<permutations/...>`, `<sha512/...>` zusätzlich doppelt lesbar gegen `include/cache_engine/*` bzw. den C++-Standard-Header `<concepts>` (src/measurement/measurable_concept.hpp wird von axes 77× als `<measurement/...>` gezogen); die `planner`(EN)/`planer`(DE)-Verwechslung ist per Owner-B3 (13.08., durchgaengig `planner`) aufgeloest. Gegenmittel: neue traeger/-Projekte erben KEINE der Alt-Wurzeln (NUR die eigene `<traeger/...>`-Wurzel); Namensentscheid B3 gefallen (§6.1).
* **R6 — WE-Kapazität:** WE 15./16. ist bereits P-belegt (S-7, S-5, #16, 21b …). Gegenmittel: der Skeleton ist bewusst ≤1 kleiner Slot; das Design liegt mit diesem Dokument vor.
* **R7 — Verwechslung mit modules/-Altskelett** (6 Säulen): README-Hinweis im Skeleton + Deprecation bei #88.
* **R8 — „ceb hängt an tier"-Fehllesart:** ohne die Fach/Träger-Trennung aus §1 wirken die 147 builder→Fach-Kanten wie ein Stufenbruch und verleiten zu unnötigem Umbau. Die Besitzkarte ist die Referenz.

---

## 6. OFFENE OWNER-PUNKTE (Default-Vorschlag steht, Bau läuft; Owner kann drehen)

1. **Wurzel + Namen:** `libs/traeger/{planner,ceb,tier,hybrid}` mit Zielen `comdare_planner/_ceb/_tier_emission/_hybrid` — finale Familien-Namen mit S-6d/#67 (dessen Zahlen unbelegt sind und neu erhoben werden); Entscheid `planner`(EN-Bestand) vs `planer`(DE-Ziel): GEFALLEN per Owner-B3 (13.08., englisch) -- Zielname `planner`, Kollision mit profile_facade/planner damit geloest.
2. **heuristik/-Zuordnung:** Default HYBRID (Stufe 4); Planer-Mitnutzung der Break-Even-Bereichskarte (KON7-05) spätestens bei HY-A bestätigen oder Heuristik-Anteil in den Querschnitt heben.
3. **mess/-Schnitt:** Default Kaskade→TIER, geteilte Naht-Typen→Querschnitt (löst K2); Zeitpunkt der Typ-Hebung: mit #18/S-13 oder erst #88.
4. **Strenge der Stufen-Kante:** Default adjazent-only (N+1 linkt NUR N); ob transitives Durchgreifen (z. B. Stufe 4→2) je erlaubt wird, entscheidet der erste Bedarfsfall LAUT (heute 0 solcher Kanten gemessen).
5. **experiment_tree-Besitz (die 26-Kanten-Frage):** Default: plan-seitige Single-Source-Header → Planer/Querschnitt bei #88, Builder-Iterator-Seite bleibt CEB.
6. **Lager-Substanz (bestandslog/lager_ablage):** Querschnitt-Kandidat (Stempel-Rolle 3 Lager-Schlüssel; „Emission endet im Lager", KON17-02) vs CEB-Eigentum — bei S-17 (Lager-Baum-Writer) festzurren.
7. **Timing-Lesart deklariert:** Skeleton im WE 15./16. VOR dem ersten S-8-Commit (Strecke P.31: Mo 17.) statt der §18.4-Blockzeile WE 22./23. — Widerspruch der Zeilen, Inhalts-Regel „VOR S-8" bindet.

---

*Erhebungs-Nachweis: alle Kanten-/Datei-/Zeilen-Zahlen am 13.08.2026 am ce-Baum 5f3f26a5 gemessen (grep/find, read-only); Ledger-Anker KON43-01/-02, KON47-01, KON18-01, KON17-01/-02, KON10-02, KON25-04/-08, KON27-01, KON23-05/E, KON59-02/NE-16; Wellenplan §18.4 Z. 2152; Strecke Teil B P.31/38. Abweichungen von früheren Angaben (apps 9 statt „10"; #67-Zahlen unbelegt) sind im Text deklariert, nicht geglättet; die Kanten-Matrix wurde per A2.5-Gegenlese neu gemessen (Zählweise §3a: echte Direktiven, direkt+relativ, ohne Kommentar-Treffer).*

---

## 7. REVIEW-EINARBEITUNG (A2.5, 13.08.2026)

**Gegenleser-Verdikt: TRAEGT_MIT_FIXES** (Design-Duo-Review 13.08., Objekt-Gegenlese an ce @ 5f3f26a5 + Ledger). Die Kernaussagen halten am Objekt (Aufmaß 1.292 D./157.192 Z. exakt inkl. aller §2-Unterzahlen; K1=49 mit Familien- und Datei-Dichte; ceb→planner 0; Fach→Träger 0; hybrid/heuristik-Inseln; Umbrella-Ein-Punkt-Emission; alle KON-Anker und Wellenplan-Zeilen verifiziert; #67-„142/29" mit 0 Belegstellen bestätigt). Eingearbeitete Fixes:

* **F1/K3 (HART):** Querschnitt→CEB sind **6** Kanten aus 2 Dateien, nicht 3 — zusätzlich `abi/cache_engine_execution_engine_adapter.hpp:14-16` (relativ →builder/commands). Summe verbotene Richtung **59 Lib- + 2 App-Kanten = 61** (§3a, §3c-K3).
* **F2 (HART):** Matrix-Zeile tier korrigiert — tier→Fach **4** + tier→Querschnitt **1** (`perm_runner.hpp:26-30`), stufen-neutral erlaubt (§3a, §3b.6).
* **F3 (HART):** Querschnitt→Fach = **20** ausgewiesen (anatomy 13 · topics 4 · axes 3; Schwerpunkt abi/) — der Querschnitt lehnt am Fach, Folgerung für §1 bleibt (§3a, §3b.5).
* **F4 (MITTEL):** CEB→Fach **147** (anatomy 85 = 74 direkt + 11 relativ · topics 48 · axes 12 · compositions 1 · src 1); planner→Querschnitt **56**, ceb→Querschnitt **50**, planner→compositions **3** — Kommentar-Treffer entfernt, Zählweise in §3/§3a deklariert.
* **F5 (HART):** §4.2 „nur neue Dateien" war unbaubar — es gibt kein libs/CMakeLists.txt; GENAU EINE Anschluss-Zeile in der Wurzel-CMakeLists.txt (Z. 737–753) als deklarierte Schreiber-Berührung + KON59-02-Timing-Voraussetzung (§4-Intro, §4.2).
* **F6 (MITTEL):** Brücken-Whitelist von 4 auf die K1-Vollmenge (10 Naht-Familien, 49 Kanten gedeckt) erweitert; Brücken außerhalb der Liste per Besitzkarten-Nachtrag im selben Commit erlaubt — A2.2-Kollision behoben (§4.3).
* **F7 (KLEIN):** KON10-02 als Mini-Pipeline-Primäranker (§1); K1-Zitatort `experiment_dock_payload.hpp:24` (§3c); Nenner 18/16 Unterverzeichnisse (§2); builder 35 Unterverzeichnisse = 22 C++-tragende + 13 leere Skelette (§2a); R5 um die dritte Include-Wurzel `src` ergänzt (§5); planner→src-Mini-Familie benannt (§3c); Zählentscheid zu den 5 →builder-Kanten der drei Bau-Modul-Werkzeug-Apps deklariert (§3a).