# BAUPLAN Bau-INC-2 — DER EINE koordinierte 4→5-ABI-Bump am Experiment-Planer-Dock

> **STATUS: ERSTELLT ZUR FREIGABE.** Kein Bau-Start ohne explizites User-GO für Bau-INC-2. **Zusätzliches Freigabe-Gate: W3-Fork (Golden-Materialisierungs-Struktur, §7 + eigene Vorlage unten) — User-Ruling erbeten VOR INC-2-Baustart.**
> Erstellt 2026-07-17. Basis: 3 Erfassungs-Reports (Report 1 Bündel-Design / Report 2 Ist-Kartierung / Report 3 W3-Fork), Ledger §0-GOAL-V6 + §18.2.4 + §19.C/D/E-4 + §20, `F12III-DESIGN-VORLAGE.md` (PRIMÄR), `20260716-e18-ebene1-und-h1-hardware-design/DOSSIER.md`. Alle Zeilenbelege stichprobenartig eigenhändig gegen den CE-Baum verifiziert (grep 2026-07-17).
>
> Pfade: **CE** = `Code/external/comdare-cache-engine`; **SUPER** = Repo-Wurzel; **LEDGER** = `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`. Alle CE-Belege relativ zu `CE/libs/cache_engine/` (Ausnahmen ausgeschrieben).
> **Vorgänger:** `20260717-inc1-bauplan/BAUPLAN-INC1-CEB-SYSTEMACHSEN-SCHICHTUNG.md` (+ ADDENDUM, jetzt gefaltet um Q2-C-Ruling + 6. Achse). INC-2 setzt die INC-1-Schichtung (6 CEB-System-Achsen ⊃ 19 Organ-Achsen, ABI-4-neutral) voraus.

---

## (0) KOPF — Zweck, Scope, TABU-GO-Fenster, Freigabe-Status

### Zweck
Bau-INC-2 ist **DER EINE koordinierte 4→5-ABI-Major-Bump** am Experiment-Planer-Dock (LEDGER:87; §18.2.4; §19.E-4). Vier–fünf Struktur-Verschiebungen brechen ALLE **dieselbe** ABI-Grenze (Modul-Symbole + POD-Layouts + Gattungs-Diskriminator + binary_id-Konvention). Einzeln vollzogen hieße das, die TABU-Grenze **viermal** zu berühren und Golden **viermal** neu zu materialisieren. Darum werden sie in **EINEM koordinierten Bruch** vollzogen (F12III §1): Magic `.A4.`→`.A5.`, `COMDARE_ANATOMY_ABI_MAJOR 4→5`, Loader verwirft alle ABI-4-DLLs.

Der Bump bündelt (F12III §3; §18.2.4; §19.E-4):
- **F12(iii)** — Telemetrie aus der binary_id-Komposition herauslösen (Organ-Slot T10 → CEB-System-Achse/H-10-Sidecar) = POD/`kV3AxisSchema`/`sizeof`-Bruch.
- **F1b** — Set-Ebene-1-Promotion (`AnatomyGattung` 3→4: `Set` als eigene Gattung, nicht mehr Genus unter Container).
- **F2** — native Set-ABI (gattungs-eigenes `ISetTier` + `SetObserverSnapshotV2` + `SetDock`).
- **#37/Q2** — Scheduling als compile-time-CEB-System-Achse als **EINZIGER** Träger; verwaiste Runtime-vtable final deprecaten (nicht löschen).
- **Q4** — Prüf-Dock als EINZIGER Träger (Iterator-Bypass vereinheitlichen).
- **Q5/H-7 + 5. Achse (Compiler) + 6. Achse (Erweiterungshardware/SIMD)** — die aus INC-1 nur als **Sidecar-Text** getragene `-march`/Compiler/SIMD-Provenienz wird zur **autoritativen ABI-5-Metadaten-Version** (AVX10-Feld an `BuildVariantDefinitionV1` + per-Binary-Schema-Version) hochgezogen. Siehe §2d (Erweiterungshardware/Compiler-Naht).
- **Golden ZERLEGT + UMGEBAUT — messdaten-erhaltend** (alt `…_abi4` additiv einfrieren; `serialize_composition_path`/`kCompositionAxisNames` ERWEITERN statt ersetzen; je Gattung neu materialisieren; Gate umhängen). **Struktur-Fork W3 → §7 + Vorlage unten.**

### Scope-Grenze (der EINE Major-Bump — TABU-GO-Fenster)
- **DAS GO-BEDINGTE ÄNDERUNGS-FENSTER wird HIER — und NUR hier — geöffnet** (LEDGER:96, V6.5). ABI-MAJOR==4 war hart-TABU **bis** Bau-INC-2 (INC-0 + INC-1 ABI-4-kompatibel, KEIN Bump). Bau-INC-2 ist der EINE reservierte Major-Bump. Erlaubt in diesem Fenster (und NUR hier): POD-1416-Layout-Bruch (`ComdareTierObserverSnapshot`), `kV3AxisSchema`-Umbau, `GenusBindingTraits`-Erweiterung (Set als Ebene-1), `serialize_composition_path`/`kCompositionAxisNames`-Bruch, golden-Umbau messdaten-erhaltend.
- **Messdaten IMMER additiv, NIE löschen — bedingungslos** (LEDGER:96; Memory `feedback_messdaten_nie_loeschen_abi_darf_brechen`, `feedback_raw_data_backups_additive_never_delete`). Alt-Golden + alt-CSV/PDF werden als `…_abi4`-Historie eingefroren, nicht ersetzt.
- **Weiterhin hart-TABU (auch in INC-2):** `permutation_axes.xml` (Legacy-11-Katalog, read-only, E12); Registry-`mp_list` (EnabledVendors) nur additiv/Default-OFF. Doku/Dossiers/Architektur-Doks nie löschen (nur deprecaten).
- **NUR EIN Bump:** kein zweiter Major-Bump in Folge-Increments. Set-Achsen F3 (ordering/multiplicity), Sequence/Graph-Dock (V42) = ABI-5-**additiv** nach INC-2 (INC-4), nicht INC-2-Scope.
- **Setzt INC-1 voraus:** die 6 CEB-System-Achsen (Scheduling/Hardware-ISA/Telemetrie/Last/Compiler/Erweiterungshardware) sind bereits als Schicht ÜBER den Organen verankert (ABI-4). INC-2 hebt nur die 4 **ABI-brechenden** Anteile über die 4→5-Grenze.

### Entscheidungs- vs. Verifikations-Gate
- **Entscheidungs-Gate ENTLASTET** durch VOLLES GO (§19.A, §20.E): der koordinierte 4→5-Umbau ist sachlich freigegeben (Q1–Q5-Mapping BESTÄTIGT; F1b-GO GEWÄHRT §16.3-E18; F12iii-Vorlage; DLL-Load-B done). Es ist NICHTS mehr zu erfragen — außer den zwei formal offenen Punkten (§7).
- **VERIFIKATIONS-Checkpoint bleibt PFLICHT (§0-GOAL-V6.7; §19.E-4; §20.E):** „Trotz VOLLEM GO je Increment den **konkreten golden-Regenerierungs- + POD/ABI-Diff** als Verifikations-Checkpoint zeigen." Das ist die zentrale INC-2-Kadenz-Verschärfung ggü. INC-0/INC-1.

### User-Freigabe-Status
**ERSTELLT ZUR FREIGABE.** Zwei Freigabe-Stufen: (1) die explizite **Bau-Freigabe** für Bau-INC-2 (überschreibt die Anhalte-Direktive für diese Phase, §20.B) steht aus; (2) das **W3-Ruling** (Golden-Materialisierungs-Struktur, §7) ist ein **eigenes Freigabe-Gate**, das VOR dem INC-2-Baustart zu beantworten ist (analog wie Q2 für INC-1 ein Gate war).

---

## (1) IST-KARTIERUNG (datei:zeile, aus Report 2, stichprobenverifiziert 2026-07-17)

Die Loci, die beim 4→5 **die ABI-Grenze kreuzen** (= das TABU-Fenster berühren):

### 1.1 ABI-Major + Modul-Symbol-Grenze
- `include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp:43` `#define COMDARE_ANATOMY_ABI_MAJOR 4` · `:47` `#define COMDARE_ANATOMY_ABI_MAGIC 0x434F4D444141342EULL` (= `.A4.`) · `:120` `kHostAnatomyAbiVersion{MAJOR, MINOR}`.
- Loader-Gate `host_compatible_with` (Major identisch, Minor≤) — `anatomy_module_abi_v1_decl.hpp:106`; `anatomy_module_loader.cpp:114-152` (4 Pflicht-Symbole, Magic-Match). ⇒ **Andockpunkt Bump:** genau `:43/:47` flippen; Loader verwirft dann alle ABI-4-DLLs sauber.

### 1.2 Ergebnis-POD-Grenze (F12iii bricht sie)
- `anatomy/observable_tier.hpp:47` `kV3AxisCount = 19` · `:66` `kV3AxisSchema[kV3AxisCount]` (19×8 Spalten-Vertrag) · `:128` Kommentar `sizeof==1416 nach P-MD3` · `:131` `std::uint64_t axis_stats[kV3AxisCount][kV3FieldCount]`. `static_assert`s standard_layout/trivially_copyable (INC-1-Bauplan §5-T2, verifiziert).
- Telemetrie heute **doppelt vergeben** (F12III §2): Organ-Slot **T10** (`anatomy/composition_factory.hpp:35/62` `using telemetry = T10`), `kCompositionAxisNames[10]` (`builder/experiment_tree/axis_path_serialization.hpp:30`), **permutiert binary_id**. ⇒ **Andockpunkt:** T10 raus aus `kCompositionAxisNames` → `kV3AxisCount 19→18`(SA-Anatomie) → neues `kV3AxisSchema` → neuer `sizeof` = **POD-Layout-Bruch = ABI-Major-Bruch**.

### 1.3 Gattungs-Diskriminator-Grenze (F1b bricht sie)
- `anatomy/anatomy_base.hpp:40-43` `enum class AnatomyGattung : uint8_t { SearchAlgorithm=0, Container=1, Graph=2 }` — heute **3** (Set fehlt). `gattung_of(Set)→Container` (Doc `:42` „Tier-Unterklassen: Set/Sequence/Adapter/View"). ⇒ **Andockpunkt:** `Set=3` **additiv anhängen** (kein Reshuffle, e18-DOSSIER F1b); `gattung_of()` faltet Set nicht mehr; `container_framework` `type_count 4→3`, `static_assert`s + `test_29_container_framework.cpp` erzwingen `Set∉Container` (= die „unverhandelbare Durchsetzung").

### 1.4 Antriebs-Grenze (F2 erweitert sie)
- Set-ABI existiert bereits als Ebene-2-Genus: `anatomy/set_tier.hpp`, `anatomy/set_anatomy.hpp`, `anatomy/set_abi_adapter.hpp`, `include/cache_engine/abi/set_module_abi_v1.hpp` (`ISetTier`/`SetObserverSnapshotV1`, `GenusBindingTraits<Set>` slot_count=15, e18-DOSSIER). ⇒ **Andockpunkt:** `SetObserverSnapshotV2` = V1 + hinten angehängte Set-Felder (`extract/merge/union/intersect/difference`, P-MD3-Append-Muster `observable_tier.hpp:142`); `SetDock` in `PruefDockRegistry` (heute nur `SearchAlgorithmDock`; „Set/Sequence/Adapter/View kommen mit V42", `anatomy/pruef_dock_registry.hpp`, F12III §6).

### 1.5 Scheduling (#37) — verwaiste Runtime-vtable (bereits DEPRECATED)
- `include/cache_engine/concepts/scheduling_strategy.hpp` `ISchedulingStrategy` = REINE VTABLE, **0 Konsumenten**, DEPRECATED-Banner seit F6 (ce `95f76805`, §20.A; INC-1-Bauplan §1.2). ⇒ **Andockpunkt:** die compile-time-CEB-Scheduling-System-Achse aus **INC-1c** wird beim 4→5 zum EINZIGEN Träger; die vtable bleibt deprecated (never-delete). Stellt `no_runtime_switch` wieder her.

### 1.6 Prüf-Dock-Bypass (Q4 vereinheitlicht ihn)
- Lazy-Iterator umgeht `IPruefDock` und castet direkt (`builder/cache_engine_builder_iterator.hpp:~750-756`, F12III §7 / §18.2.2 — 2026-07-17 belegt). Prüf-Dock ist **KEINE** ABI-Grenze (`anatomy/pruef_dock.hpp:10-14`, Builder-Binary) → frei umbaubar. ⇒ **Andockpunkt:** `IPruefDock`-Vertrag scharf stellen; Iterator-Bypass auf den Dock vereinheitlichen.

### 1.7 Metadaten-Grenze (Q5/H-7 + Compiler + Erweiterungshardware bricht sie)
- `anatomy/build_variant_definition.hpp:17` `struct BuildVariantDefinitionV1` (nur uint64 → ABI-fest; `:24` `simd_avx512`, `:26` `hw_cache_line`; `:67-68` `detect_avx512<SE>()`/`cache_line_size`). `.version`-Sidecar + `write_provenance_manifest` sind heute **global**, nicht per-Binary (INC-1 §2d; ADDENDUM §2.1 `provenance_manifest.hpp:79-83`). ⇒ **Andockpunkt:** **AVX10-Versionsfeld** an `BuildVariantDefinitionV1` anhängen (POD-Erweiterung = ABI-4-Bruch → INC-2) + per-Binary-Schema-Version, die `-march` + `compiler_id/version` + SIMD-Erweiterungshardware-Ausprägung **autoritativ** trägt.

### 1.8 Golden + Experiment-Planer-Dock-Naht
- `profile_facade/source_catalog.hpp:80/112/113` `FullSourceCatalog = CatalogAxes<4,4,5,4>` = **320** (L00 search_algo·L04 node_type·L05 memory_layout·L07 prefetch variiert; 15 Slots `mp_take_c<…,1>` gepinnt). Fixture `tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt` (320 IDs, eingefroren; jeder Pfad fix `isa=isa_amd64`, `telemetry=telemetry_leaf_only_counter`). Gate `test_profile_roundtrip.cpp`. Generator `gen_golden_fullpilot` (in `test_profile_roundtrip.cpp` referenziert, F12III §5).
- Experiment-Planer-Dock **im Code NOCH NICHT benannt** (grep `Planer/planner/AnatomyMajor` in `libs/` leer, §18.1.1/§19.D). Reale Naht = `profile_facade/experiment_run_entry.hpp:95` `run_experiment_profile` → `run_lazy_static_then_dynamic` (`experiment_run_entry.hpp:225-251`; HIER wird golden zerlegt). ⇒ **Andockpunkt Bump:** der Anatomy-Major reitet an dieser Naht.

---

## (2) DESIGN des Bündels (aus Report 1)

### (2a) Warum EIN Bruch, nicht vier (F12III §1)
Die vier ABI-brechenden Anteile (F12iii-POD, F1b-Gattung, F2-Antrieb, Metadaten-Version) berühren dieselbe Modul-ABI-Grenze und würden einzeln Golden je viermal neu materialisieren. Doktrin `feedback_e_schichten_separat_fertigstellen_top_down` verlangt „je Schicht 1 Review/Backup" — **der ABI-Major-Bruch IST EINE Schicht** → gemeinsam am Experiment-Planer-Dock. #37 und Q4 sind ABI-neutral bzw. golden-neutral, reiten aber im selben Fenster mit (kein separater Bruch nötig).

### (2b) Die ABI-Grenz-Landkarte beim 4→5 (F12III §4)
Prinzip: Prüf-Dock ist **KEINE** ABI-Grenze; die Grenze ist stets **gattungs-eigenes Antriebs-Sub-Interface (vtable-stabil) + flacher POD (memcpy)**. Frei umbaubar (nicht Grenze): `IPruefDock`, `AnatomyPermutationDriver`, `BuildOrchestrator`, `registry_to_axis_levels`, gesamte CRTP+Concept-Kompositionslogik.

| Grenze | Verschiebung beim 4→5 | Datei |
|---|---|---|
| Modul-Symbol | Magic `.A4.`→`.A5.`, Major 4→5 | `anatomy_module_abi_v1_decl.hpp:43/47` |
| Ergebnis-POD | neues Snapshot-Layout (T10 raus; Set-Achsen-Satz) | `observable_tier.hpp:47/66/128/131` |
| Antriebs-Grenze | `ISetTier` als neues gattungs-eigenes Sub-Interface (F2) | `set_module_abi_v1.hpp`, `set_tier.hpp` |
| Gattungs-Diskriminator | `Set=3` in `AnatomyGattung` (F1b) | `anatomy_base.hpp:40-43` |
| Metadaten-Grenze | Telemetrie-/Scheduling-/ISA-/`-march`-/Compiler-Belegung → per-Binary-Sidecar (H-10) + AVX10-Feld | `build_variant_definition.hpp:22-24` |

### (2c) Golden zerlegt + umgebaut — messdaten-erhaltend (F12III §5)
Drei orthogonale Verschiebungen brechen golden: (1) System-Achsen-Schicht (`isa`/`telemetry` verlassen den binary_id-Pfad → jeder der 320 Pfade verliert ≥2 Segmente); (2) Gattung-Ebene-1-Promotion (`kCompositionAxisNames` hart auf 19; promotetes Set/Sequence braucht eigene Namen-Liste + Gattung-Diskriminator → golden zerfällt per-Gattung); (3) Major 4→5 (Magic/Versionsfeld). Regenerierungs-Plan (Messdaten nie löschen):
1. **Einfrieren-additiv:** `golden_fullpilot_320_binary_ids.txt` + zugehörige Mess-CSV/PDF bleiben als `…_abi4`-Historie **unangetastet** (Regressions-Referenz).
2. **Konventions-Erweiterung statt Ersatz:** `serialize_composition_path`/`kCompositionAxisNames` erweitern um (i) Herausnahme der System-Segmente, (ii) optionales Gattung-Segment, (iii) das default-OFF `with_shape_segment` (`axis_path_serialization.hpp:87-94`) — unveränderte Pfade byte-identisch wo möglich.
3. **Neu-Materialisierung EINMALIG** via `gen_golden_fullpilot` unter der neuen Achsen-Struktur → neue eingefrorene Fixtures je Gattung (`golden_abi5_map_/_set_/_sequence_`), committet.
4. **Gate umhängen:** roundtrip-Test gegen die neuen Golden; alte als historische Referenz behalten. — **Ob 3+4 ein eigenes Bau-INC-3 sind oder in INC-2 gefaltet werden = W3-Fork (§7).**

### (2d) Erweiterungshardware/Compiler-Naht — die Metadaten-Version trägt `-march` + Compiler-Provenienz

Dies ist der INC-2-Anteil der neuen 5. (Compiler) und 6. (Erweiterungshardware/SIMD) System-Achsen (Q2-C-Ruling, LEDGER:1916; ADDENDUM §5-Fold). **Rollen-Trennung (Option C):**
- **Wert = System-Achse:** die **Erweiterungshardware-System-Achse (SIMD, später GPU)** ist die `-march`-Flag-QUELLE; die CEB permutiert `simd_extension` **zu ihrer eigenen Laufzeit selbst** durch (Rahmen vom Planer via Experiment-Dock) und baut je Ausprägung Tier-Binaries compile-time. Die **Compiler-System-Achse (gcc|clang)** liefert den Treiber+Dialekt.
- **Ort = `CompileFn`-Naht:** `-march`/`-mavx…` + `cxx`-Treiber werden an `make_gpp_compile_fn` (`build_orchestrator.hpp:466/476`) angewandt — dem Engine-agnostischen Parametrisierungs-Ort. (INC-1d/1h haben diesen Ort bereits erschlossen; das `-fno-gnu-unique`-Compiler-Gate `:479` ist in INC-1h gebaut.)
- **Provenienz = H-10-Metadaten — der INC-2-Sprung:** in INC-1 wird die `-march`/Compiler/SIMD-Belegung nur als **Sidecar-TEXT** neben der `.so` geführt (ABI-4-neutral, `build_version` `:62`). In INC-2 wird sie zur **autoritativen ABI-5-Metadaten-Version**: **AVX10-Versionsfeld** an `BuildVariantDefinitionV1` (`build_variant_definition.hpp:22-24`, POD-Erweiterung = ABI-4-Bruch → gehört zwingend hierher) + per-Binary-Schema-Version, die `-march` + `compiler_id`/`compiler_version` + SIMD-Erweiterungshardware-Ausprägung trägt. Der Kohärenz-Guard `declared_extension_matches_build<SE>()` (e18-DOSSIER) wird auf das neue Feld erweitert.
- **binary_id UNBERÜHRT:** weder Compiler noch Erweiterungshardware noch `-march` werden je Segment in `kCompositionAxisNames`/`serialize_composition_path` — die Unterscheidbarkeit lebt aus der H-10-Provenienz, **NICHT** aus der binary_id (e18-⟂ gewahrt; der „bis-5-%"-Compiler/SIMD-Vergleich lebt von der Sidecar-/Metadaten-Versionierung).

⇒ Die INC-2-Metadaten-Version ist der **einzige** Ort, an dem die 5. + 6. Achse den 4→5-Bruch mitnehmen; ihre Achsen-Rahmen selbst sind bereits in INC-1 (1d-präzisiert / 1h) ABI-4-neutral gebaut.

### (2e) Kopf-Frameworks je Ebene-1-Gattung (F12III §6)
Beim 4→5 wird `Set` zur vollen Ebene-1-Gattung (map=SearchAlgorithm-Hülle fertig; Set=4→5-Ziel; Sequence/Container/Graph angelegt-ungebunden → INC-4/V42). **View = read-only aus sequential container** bleibt non-owning Genus **unter** Container (kein eigenes Ebene-1, `genus_binding_traits.hpp:135-152`). Gemeinsame Wurzel = `topics::AxisBase` + `AnatomyConcept` (`anatomy_base.hpp:120-127`); je Gattung eigener Achsen-Satz + gattungs-eigenes Antriebs-Sub-Interface; kein vtable im Hot-Path (vtable nur 1× kalt an der Modul-ABI-Grenze via `dynamic_cast`).

---

## (3) MINI-INCREMENT-SCHNITT + Abhängigkeits-Reihenfolge

**Prinzip:** ABI-4-neutrale Vorbereitung zuerst (2a), dann der Major-Flip (2b), dann die einzelnen Struktur-Brüche je auf ABI-5 (2c–2g), je mit dem **konkreten golden-Regenerierungs- + POD/ABI-Diff-Checkpoint** (§0-GOAL-V6.7 Pflicht). Golden-Roundtrip==320 wird ab 2b durch **golden-Neubau messdaten-erhaltend** ersetzt. Die **autoritative** Neu-Materialisierung + Gate-Umhängung (2h) ist **W3-gated** (§7): eigenes Bau-INC-3 (Option A) oder in 2c–2g gefaltet (Option B).

| Inc | Abhängt von | Inhalt (Änderungsskizze) | golden/POD/ABI-Diff-Checkpoint (Pflicht §0-GOAL-V6.7) |
|---|---|---|---|
| **INC-2a** — Planer-Dock benennen + Prüf-Dock scharf (Q4) | INC-1 komplett | Experiment-Planer-Dock an der Naht `experiment_run_entry.hpp:95/225-251` benennen+einziehen; `IPruefDock`-Vertrag scharf; Iterator-Bypass (`cache_engine_builder_iterator.hpp:~750-756`) auf den Dock vereinheitlichen. **ABI-4-NEUTRAL** (nicht Grenze). | golden==320 **byte-identisch** (noch ABI-4); POD/ABI unverändert; ctest grün. |
| **INC-2b** — Major-Flip + Loader-Gate (öffnet das TABU-Fenster) | 2a | `COMDARE_ANATOMY_ABI_MAJOR 4→5`, Magic `.A4.`→`.A5.` (`anatomy_module_abi_v1_decl.hpp:43/47`); Loader `host_compatible_with` verwirft ABI-4-DLLs. **Ab hier: golden-Neubau statt Roundtrip==320.** | Alt-golden `…_abi4` **additiv eingefroren** (Beleg: Datei unverändert + committet); POD/ABI-Diff = Magic/Major-Flip; Loader lehnt ABI-4 literal ab. |
| **INC-2c** — F12iii Telemetrie raus | 2b + INC-1e | T10 raus aus `kCompositionAxisNames` (`axis_path_serialization.hpp:30`) → `kV3AxisCount`/`kV3AxisSchema`/`sizeof` (`observable_tier.hpp:47/66/128/131`); Telemetrie-Wahl → H-10-Sidecar. | **POD/ABI-Diff: `sizeof`-Δ + `kV3AxisSchema`-Δ konkret zeigen**; golden ohne telemetry-Segment neu materialisiert; grep telemetry in neuem golden == 0. |
| **INC-2d** — F1b Set Ebene-1 | 2b | `AnatomyGattung` `Set=3` additiv (`anatomy_base.hpp:40-43`); `gattung_of()`; `container_framework` `type_count 4→3` + `static_assert`s + `test_29_container_framework.cpp` (Compile-Gate `Set∉Container`). | POD/ABI-Diff = Gattung-Enum + `gattung_of`; golden zerfällt **per-Gattung** neu materialisiert; Set-Pfade tragen Gattung-Diskriminator. |
| **INC-2e** — F2 native Set-ABI | 2d + 2a | `SetObserverSnapshotV2` (V1+append, P-MD3-Muster `observable_tier.hpp:142`); `ISetTier`-Antrieb; `SetDock` in `PruefDockRegistry`. | POD/ABI-Diff = `ISetTier`-vtable + Set-POD-V2-`sizeof`; `golden_abi5_set_` materialisiert; SetDock geladen. |
| **INC-2f** — #37 Scheduling CT einziger Träger | 2b + INC-1c | INC-1c-Scheduling-System-Achse = EINZIGER Träger; `ISchedulingStrategy`-vtable final deprecated (nie gelöscht). | golden **neutral** (Scheduling = System-Achse, nicht binary_id); grep: keine vtable im Hot-Path (`!is_polymorphic`-Guard hält). |
| **INC-2g** — Q5/H-7 + Compiler + Erweiterungshardware Metadaten-Version | 2b + INC-1d/1g/1h | AVX10-Feld an `BuildVariantDefinitionV1` (`build_variant_definition.hpp:22-24`) + per-Binary-Schema-Version trägt `-march`+`compiler_id/_version`+SIMD-Ausprägung (§2d); `declared_extension_matches_build<SE>()`-Guard erweitern. | POD/ABI-Diff = AVX10-Feld + Schema-Version-Δ; golden **neutral** (Provenienz NEBEN binary_id; grep march/compiler in golden == 0). |
| **INC-2h** — Golden autoritativ neu materialisieren + Gate umhängen — **W3-GATED (§7)** | 2c–2g | `gen_golden_fullpilot` einmalig je Gattung (`golden_abi5_map_/_set_/_sequence_`), committen; roundtrip-Gate umhängen; alt = historische Referenz. **Option A = eigenes Bau-INC-3; Option B = in 2c–2g gefaltet.** | Gate gegen neue golden grün; alt-`…_abi4` unangetastet vorhanden (never-delete literal belegt). |

**Konsolidierungs-Checkpoint** nach INC-2h: voller super-Sub-Build (`build-i2`) + golden-Neubau messdaten-erhaltend verifiziert (neue Gattungs-Fixtures grün, alt `…_abi4` eingefroren) + Loader verwirft ABI-4 + POD/ABI-Diff-Register vollständig + cf22==0 + Mojibake==0 + beide Remotes ref-gleich.

---

## (4) VERIFIKATIONS-PLAN (je Mini-Increment; INC-2-Verschärfung)

Pro Mini-Increment, in dieser Reihenfolge (Memory `reference_cache_engine_standalone_build_pipeline`, `feedback_ci_infra_blocked_proceed_local_double_verify_mode_a`; aktuell **lokal-first**, CI-Nachzug gesammelt nach Abschluss — §20.B):
1. **ctest** grün (ce-standalone `build-conf`, offizieller CMake/ctest-Weg — kein Behelf).
2. **golden-Verifikation:** bis 2a = Roundtrip==320 byte-identisch; **ab 2b = golden-Neubau messdaten-erhaltend** — der konkrete **golden-Regenerierungs-Diff** (welche Segmente/Pfade sich ändern) + der **POD/ABI-Diff** (`sizeof`, `kV3AxisSchema`, Enum, Magic/Major, AVX10-Feld) werden **literal gezeigt** (§0-GOAL-V6.7; §19.E-4). Mess-Fehler als CSV-„failed" + Log, nie Nullen (Memory `feedback_measurement_failure_visibility_...`).
3. **Alt-Messdaten-Beleg:** `…_abi4`-Fixtures + CSV/PDF nach jedem Increment als **unangetastet vorhanden** bestätigen (never-delete, bedingungslos).
4. **cf22 == 0** (clang-format 22.1.8; `~/tools/cf22/usr/bin`).
5. **Mojibake == 0** (`grep -R "Ã\|â€"` == 0).
6. **super-Sub-Build PFLICHT** (`build-i2`, ~15 vendored Links; deckt Config-Gaps auf, die `build-conf` verbirgt — §20.D-B2/B4; nicht nur ce-standalone).
7. **beide Remotes ref-gleich** (origin=gitlab.comdare.local / github; batch) — **erst nach explizitem User-Bau-GO und granular**; keine Commits/Pushes in der Planungsphase.

Loader-Gate nach 2b zusätzlich literal: eine ABI-4-DLL wird sauber verworfen (`host_compatible_with`==false), eine ABI-5-DLL geladen.

---

## (5) RISIKEN + ROLLBACK

**GO-bedingtes Änderungs-Fenster (bewusst offen in INC-2, sonst hart-TABU):** ABI-MAJOR 4→5, POD-1416, `kV3AxisSchema`, `GenusBindingTraits`-Erweiterung, `serialize_composition_path`/`kCompositionAxisNames`-Bruch, golden-Umbau. **Weiterhin hart-TABU:** `permutation_axes.xml`, Registry-`mp_list` (additiv/Default-OFF), Doku/Messdaten löschen.

| Risiko | Auslöser (datei:zeile) | Mitigation | Rollback |
|---|---|---|---|
| **R1 Messdaten-Verlust** (unwiederbringlich) | golden/CSV/PDF überschreiben statt additiv einfrieren | ALT `…_abi4`-Fixtures + Mess-CSV/PDF **kopieren-vor-Umbau**, nach jedem Increment als vorhanden belegen (V6.7-Checkpoint Pkt.3); ERWEITERN statt ersetzen (`with_shape_segment`-Muster) | Backup wiederherstellen; Working-Tree verwerfen |
| **R2 Doppel-Bruch / zweiter Major-Bump** | Set-F3/Sequence/Graph in INC-2 ziehen statt ABI-5-additiv nach INC-2 | Scope hart auf die 4 ABI-brechenden Anteile; F3/V42 = INC-4-additiv (kein Major) | Working-Tree verwerfen; Anteil nach INC-4 schieben |
| **R3 golden-Regenerierung inkonsistent** (Pfade/Segmente falsch) | `serialize_composition_path`/`kCompositionAxisNames`-Umbau (`axis_path_serialization.hpp:30/48`) | je Increment golden-Regenerierungs-Diff literal zeigen (V6.7); `gen_golden_fullpilot` einmalig, deterministisch; roundtrip gegen neue Fixtures | alt-Gate + alt-golden reaktivieren (eingefroren vorhanden) |
| **R4 stale ABI-4-DLL geladen** (falsches Skip) | Loader/`build_version` (`build_orchestrator.hpp:62`, `dll_is_current` `:282`) erkennt Major-Wechsel nicht | 2b: Loader verwirft ABI-4 via Magic/Major; `build_version` um ABI-5-Signatur + Metadaten-Version erweitern; Skip/Resume literal geprüft | `.version`-Sidecar löschen + Rebuild |
| **R5 POD-Layout-`static_assert`-Bruch unbemerkt** | `observable_tier.hpp` standard_layout/trivially_copyable + `sizeof` nach T10-Entfall | die bestehenden `static_assert`s brechen den Build zwingend; neuen `sizeof` explizit im Checkpoint fixieren | Working-Tree verwerfen |
| **R6 `-march`/Compiler leckt in binary_id** (golden-Bruch statt Provenienz) | Versuchung, Erweiterungshardware/Compiler als binary_id-Segment (§2d) | Metadaten-Version NEBEN binary_id (H-10-Feld); grep march/compiler in neuem golden == 0 nach 2g | AVX10-Feld/Schema-Version zurücknehmen, in Sidecar-Text belassen |
| **R7 Set∉Container-Durchsetzung bricht Fremdcode** | `container_framework` `type_count 4→3`, `static_assert`s | Compile-Gate ist gewollt (e18 „unverhandelbar"); Fremd-Nutzer additiv umstellen, `test_29_container_framework.cpp` als Beleg | Working-Tree verwerfen |

Rollback-Prinzip: keine Commits vor Grün; alt-`…_abi4` **immer** vorhanden (Wiederherstellungs-Anker). Der Major-Flip (2b) ist der Punkt ohne Roundtrip-320-Rückweg — davor byte-identisch, danach golden-Neubau.

---

## (6) NAHT ZU INC-3/INC-4 (was INC-2 BEWUSST offen lässt)

- **Bau-INC-3** — Golden-Neu-Materialisierung (falls W3-Option A, §7): alt additiv einfrieren + je Gattung neu materialisieren + Gate umhängen (F12III §7; LEDGER:88).
- **Bau-INC-4** — restliche Gattungs-Frameworks: Sequence-/Container-/Graph-Dock + Antriebs-ABI (V42-Fahrplan); Set-F3 (ordering/multiplicity als Set-Achsen, end-append, Default=Ist) — **ABI-5-additiv, KEIN weiterer Major-Bump**.
- **Folgearbeiten (nach INC-2/3/4):** F5-Planer-Codegen (Interpreter+EIN-Director+ZWEI-Builder → CI/cmake synchron, PF1–4); Serialisierung Q1–Q4; „failed"-Zelle; Debug/Mess-Schalter; echter Mess-Lauf #215/#156; G5/#274 (Projektende); S-7 (offen).

---

## (7) OFFENE FRAGEN AN DEN USER

**Doktrin-Check:** der koordinierte 4→5-Umbau ist durch VOLLES GO sachlich entschieden (§19.A/§20.E); Q1–Q5 BESTÄTIGT; Q2 = Option C + 6. Achse ENTSCHIEDEN (LEDGER:1916); F1b-GO GEWÄHRT. Es bleibt **eine** echt offene Struktur-Frage + zwei Bestätigungen:

- **W3 — Golden-Materialisierungs-Struktur — FREIGABE-GATE (VOR INC-2-Baustart):** eigenes Bau-INC-3 (Option A) vs. in den 4→5 gefaltet (Option B). LEDGER:87 markiert dies verbatim als „STRUKTUR-OFFEN … VOR INC-2-Planung klären". **→ eigene Vorlage unten (wird 1:1 vorgelegt).** Empfehlung: **Option A** (eigenes INC-3), Begründung dort.
- **Q-Bestätigung a (nicht blockierend):** Reihenfolge des Major-Flips — 2b **früh** (dieser Plan: Flip zuerst, dann Struktur je auf ABI-5) vs. Flip **zuletzt** (Struktur unter ABI-4-„Schatten" vorbereiten, dann atomar flippen). Konservativer Default: **früh** (klarer Schnitt, jeder Folge-Increment self-contained golden-neu). 1-Zeilen-Ruling genügt.
- **Q-Bestätigung b (nicht blockierend):** AVX10-Feld-Form (§2d) — einzelnes `avx10_version`-uint64 an `BuildVariantDefinitionV1` (SOTA-Richtung H-10) vs. Bündel `{march_id, compiler_id, ext_hw_id}`. Konservativer Default: **AVX10-Versionsfeld + per-Binary-Schema-Version** (F12III/e18-H-10). Bestätigung erwünscht.

---

## W3-FORK-VORLAGE (User-Ruling erbeten)

> Dies wird dem User 1:1 vorgelegt. Es ist die EINE echt offene Struktur-Frage vor dem INC-2-Baustart (LEDGER:87 verbatim: golden-Neu-Materialisierung „als eigenes Bau-INC-3 vs. in 4→5 gefaltet — VOR INC-2-Planung klären").

**Kontext.** Beim koordinierten 4→5-Bump zerfällt das heutige `golden_fullpilot_320` (320 binary_ids, eingefroren): die System-Achsen (`isa`/`telemetry`) verlassen den binary_id-Pfad, Set wird zur Ebene-1-Gattung mit eigenem Diskriminator, der Major wird zu 5. Die alten Fixtures + Messdaten werden bedingungslos als `…_abi4` additiv eingefroren (nie gelöscht). Offen ist nur die **Struktur**, wann/wo die **neuen** Fixtures (`golden_abi5_map_/_set_/_sequence_`) autoritativ materialisiert und das Roundtrip-Gate umgehängt wird. §0-GOAL-V6.7 verlangt in beiden Optionen unverändert je Mini-Increment den konkreten golden-Regenerierungs- + POD/ABI-Diff als Verifikations-Checkpoint.

**Option A — Golden-Neu-Materialisierung als eigenes Bau-INC-3 (nach dem ABI-Bruch).**
INC-2 bleibt der reine koordinierte ABI-/Struktur-Bruch (2a–2g). Die per-Increment-golden-Diffs in INC-2 sind **provisorisch/verifikatorisch** (zeigen den Bruch, satisfizieren V6.7 als Verifikation). Die **autoritative** einmalige Materialisierung je Gattung + Gate-Umhängung passiert gebündelt in einem eigenen nachgelagerten **Bau-INC-3** (= das Modell in F12III-DESIGN-VORLAGE §7 + LEDGER:88).
- *Implikationen:* golden-Regeneration ist eine eigene, für sich testbare Schicht (Doktrin „je Schicht 1 Review/Backup"); INC-2 ist entkoppelt vom Fixture-Churn; ein klarer Konsolidierungs-Schnitt. Nachteil: zwischen INC-2h und INC-3 existiert ein Zustand, in dem die committeten Fixtures noch die alten `…_abi4` sind (das Gate läuft in dieser Phase gegen die eingefrorene alt-Referenz bzw. provisorische Fixtures) — der „scharfe" ABI-5-Roundtrip wird erst in INC-3 autoritativ.

**Option B — Golden-Neu-Materialisierung in den 4→5 gefaltet (in INC-2).**
Jedes betroffene Mini-Increment (2c–2g) materialisiert **sofort** seine ABI-5-Fixture-Scheibe autoritativ, committet sie und hängt das Gate inkrementell um (= die wörtliche Lesart von §0-GOAL-V6.7 „golden-Roundtrip==320 wird durch golden-Neubau messdaten-erhaltend ersetzt").
- *Implikationen:* kein Zwischenzustand, in dem golden nicht zur ABI passt; jeder Increment ist self-contained grün mit autoritativem golden. Nachteil: der ABI-Bruch und der Fixture-Churn sind verwoben — mehr bewegliche Teile je Increment, schwerere Rückführung eines einzelnen Struktur-Schritts, weil sein committetes golden schon Folge-Increments trägt; kollidiert mit „je Schicht 1 Review/Backup" (golden-Regeneration ist dann keine eigene Schicht mehr).

**Empfehlung: Option A (eigenes Bau-INC-3).** Sie ist die einzige, die zugleich (i) F12III-DESIGN-VORLAGE §7 + LEDGER:88 („Bau-INC-3 golden additiv einfrieren + je Gattung neu materialisieren") **wörtlich** trifft, (ii) die Doktrin „je Schicht 1 Review/Backup" (`feedback_e_schichten_separat_fertigstellen_top_down`) einhält — golden-Regeneration IST eine eigene Schicht —, und (iii) den ABI-/Struktur-Bruch von der Fixture-Materialisierung entkoppelt, was Rückführung und Review vereinfacht. Der §0-GOAL-V6.7-Checkpoint bleibt in INC-2 als **verifikatorische** Regeneration je Increment erfüllt; die **autoritative** Materialisierung + Gate-Umhängung bündelt INC-3. Option B ist die schnellere, aber weniger saubere Faltung (verwoben, kollidiert mit der Schicht-Doktrin, schwerere Rückführung) — nach `feedback_infra_cleanest_not_easiest` („sauberste, nie einfachste Strategie") daher nachrangig. **1-Zeilen-Ruling genügt (A oder B).**
