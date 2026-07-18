# BAUPLAN-DOSSIER — Inkrementeller CEB/Tier-Binary-Cache (per-Organ-Achse Algorithmus-Versionierung)

> **Status:** VOR-Deep-Research (Workflow `wf_911c8162`, 5 Agenten, ~481k tokens), fertig 2026-07-18. **Voraussetzung
> für das neue golden N=2^17** (User: "zieh es durch, machbar"). Verdikt: KONFORM. GATED auf User-GO (7 offene
> Entscheidungen, davon 2 doktrin-/infra-relevant). ce = `Code/external/comdare-cache-engine`.

## 0. Auftrag (User-Direktive verbatim, 2026-07-18)
> „Strategie, wie CEB + Tier-Binaries gecached werden, und dass die CI erkennt, ob eine Organ-Achse sich bzgl. eines
> Achsen-Algorithmus geändert hat, sodass nur Binaries im Baum neu gebaut werden, die das bzgl. der Algorithmus-
> Versionierung betrifft. Jedes Binary trägt je Organ-Achse ein Listing: welcher Algorithmus + Algorithmus-Version.
> Alle Binaries mit geändertem einkompilierten Algorithmus werden neu gebaut, der Rest bleibt unverändert. Eine
> CEB-Änderung (betrifft ALLE) → vollständige Rekompilation. Damit grenzen wir die Last ein → feasible."

**Zweck:** golden N=2^17=131.072 Tier-Binaries; alle bei jeder Änderung neu = unmöglich (~409× golden-320). Selektives
Rebuild (nur geänderte Algorithmen) macht das große golden materialisier-/messbar. Sequentialität + Storage: siehe
`feedback_incremental_tier_binary_caching` (minio für Tier-Binaries, NFS-prod für Messergebnisse, Cache-Schreiben NIE
parallel zur Messung).

## 1. Manifest — per-Binary Algorithmus-Version-Listing
NEUES additives Sidecar **`perm.algos`** je Binary (neben `perm.dll` / `perm.dll.version`, build_orchestrator.hpp:271-280).
Grund für SEPARAT (nicht in `build_version` einfalten): Organ- vs System-Achsen NIE mischen
([[feedback_system_axes_measurement_own_abstract_root_blood]]). `perm.dll.version` bleibt byte-genau System-Provenienz
(ext/cxx/opt/target); `perm.algos` trägt die Organ-Provenienz. Format (key=value, Vorbild permutation_codegen_tool.cpp:600-608):
```
ceb=6.0
algo_sig=search_algo=bst@v1;cache_traversal=..@v1;...;queuing_q2=..@v1
search_algo=bst@v1
... (17 Zeilen, eine je Organ-Achse, Slot-Reihenfolge = kCompositionAxisNames)
cacheline_valueset=v2; node_width_valueset=v1; alloc_hw_valueset=v1  (Sub-Achsen-Werteset-Versionen)
```
Die 17 Zeilen = das geforderte je-Organ-Achse-Listing (name() + version()). `algo_sig` = deterministische Flach-Signatur,
gegen die der Rebuild-Selektor String-gleich vergleicht. Geschrieben von neuem `write_algos_sidecar()` bei r.status==0.

## 2. Change-Detection — explizites `version()` je Strategie-Klasse
EMPFEHLUNG: `static constexpr std::string_view algo_version = "v1";` neben name()/family_id/flag_suffix in JEDER
Variant-Klasse, **erzwungen via Achsen-Concept** (static_assert im CRTP-Ctor, axis_06_allocator_strategy_base.hpp:73-86)
— eine Variante ohne version() bricht die Kompilation. Compile-time, autor-gesetzt (Bump bei algorithmischer Änderung),
zero-cost, komponiert in algo_sig. Sub-Achsen-Werteset-Versionen (kCacheLineSubaxisVersion cacheline_config.hpp:135)
fließen mit ein (Werteset-Erweiterung ändert das Bit-Layout).
**Verworfen:** (i) Content-Hash der Quelle — über-invalidiert (Kommentar/Whitespace/Refactor bumpen den Hash → Rebuild
tausender Binaries). (ii) git-blob-Hash — nicht compile-time, koppelt Build an VCS-Zustand, bricht bei dirty tree.
**DISZIPLIN-GUARD:** vorhandene consteval-SHA-256 (ctsha.hpp) + apps/is_original_validator als CI-TRIPWIRE (nicht als
Bau-Invalidator): je Strategie-Header content-digest gegen eine eingecheckte Lock; CI ROT, wenn digest sich änderte,
version() aber NICHT gebumpt. Semantische Version treibt die Invalidierung, Hash erzwingt die Bump-Disziplin.

## 3. Rebuild-Selector — dll_is_current um algo_sig erweitern
`dll_is_current(output, build_version, algo_sig)` (build_orchestrator.hpp:172-180): skip GENAU DANN, wenn DLL existiert
UND `perm.dll.version==build_version` (System, unverändert) UND `perm.algos` algo_sig==erwartete algo_sig (Organ, neu).
Beide reine String-Gleichheit → additiv, risikoarm. Die erwartete algo_sig wird je Binary aus `BinarySpec.axes`
(experiment_tree.hpp:224-229/284) via injizierte **AlgoSigFn** (analog SourceGenFn build_orchestrator.hpp:190) aus einer
compile-time Versions-Tabelle gebaut. **Wirkung (das geforderte "nur betroffene"):** binary_id trägt nur name() (keine
Version) → binary_id byte-identisch; NUR Binaries, deren 17-Tupel die gebumpte Variante enthält, bekommen geänderte
algo_sig → genau die rebuilden, alle anderen skippen. Der Sidecar-Vergleich IST die Change-Detection (kein git-diff /
rules:changes, robust gegen rebase/dirty tree). Die lazy StaticBinaryView bleibt rein strukturell.

## 4. CEB-Full-Trigger — `ceb_contract_version`
Skalar `ceb_contract_version = COMDARE_ANATOMY_ABI_MAJOR(6) + codegen-Minor`, eingefaltet in `build_version`
(`+ceb=6.N` in system_axes_version_suffix() profile_run_facade.cpp:290-304) — Framework/System-Ebene, gehört legitim
in den System-Provenienz-String. Jeder Bump → jede perm.dll.version mismatcht → ALLE neu ("CEB-Änderung betrifft alle").
Bump-Auslöser: (a) ABI-Bruch (POD-Schema/vtable/Emitter-Aritäts-Änderung) → bumpt MAJOR automatisch. (b) universelle
Codegen-Änderungen (all_axes_umbrella/adhoc_emitter/Observer-Basis) → MINOR. Backstop: Loader host_compatible_with
lehnt Major-Mismatch-DLLs ab (decl:124-127) — `+ceb=` macht Bau-Skip + Lade-Akzeptanz konsistent.

## 5. CI-Integration
Grüne Pipeline baut NIE Tier-Binaries (CI-Grün=Messung AUS). Drei Bausteine: (1) billiger **VERSIONS-LOCK-GUARD-Job**
(kein Binary-Bau): content-Hash der Strategie-Header + CEB-universelles Set gegen die eingecheckte Lock (ctsha/
is_original_validator), rot iff Quelle geändert ohne Bump — Sekunden, stage `contract`/`lint`. (2) **Selektives Rebuild**
intrinsisch im Orchestrator (algo_sig + build_version), läuft in der SEPARATEN opt-in bare-metal Mess-Pipeline gegen ein
PERSISTENTES output_dir. (3) **Cache-Persistenz** via persistentes Volume auf dem bare-metal Mess-Host (NICHT GitLab-
Artefakte — Object-Storage-500); dort überleben perm.dll+perm.dll.version+perm.algos+result.csv.stamp die Läufe.
output_dir NIE löschen.

## 6. Genutzte vorhandene Infra (kein Neubau)
lazy StaticBinaryView (strukturell unverändert) · dll_is_current+Sidecar (additiv erweitert) · perm.dll.version
(unangetastet, best_binary_selector-Byte-Kopie bricht nicht) · Mess-Resume-vN-Prefix-Bump als Vorbild · consteval-SHA-256
+ is_original_validator als CI-Tripwire · ABI_MAJOR+Loader als "alles-neu"-Backstop · Legacy axes_versions.txt/
current_axes_signature als Format-Vorbild · Registry-mp_list/EnabledVendors baut die Versions-Tabelle · CRTP+Concept
erzwingt version() · SourceGenFn-Injektion als AlgoSigFn-Vorlage.

## 7. Konformitäts-Verdikt: KONFORM
compile-time-only (version() constexpr, mp_for_each-Tabelle) · keine Behelfswege (nur offizielle Pfade erweitert) ·
sauberster Weg (semantische Version + Content-Hash NUR als Disziplin-Guard; separates Sidecar hält Organ/System getrennt) ·
kein Python · Messung nie Nullen (Algo-Änderung bricht Resume-Stamp → ehrliche Neu-Messung) · CRTP+Concept · binary_id-
Doktrin (Version=Sidecar, NIE binary_id) · macht N=2^17 feasible. Bedingung: die 2 Doktrin-Berührungen (ceb= in
build_version; optionaler Registry-Spiegel) als open decisions, beide additiv+golden-neutral bis zum ersten Bump.

## 8. Offene Entscheidungen (dem User vorzulegen)
- **Manifest:** separates `perm.algos`-Sidecar (empfohlen) vs Einzel-Sidecar-Umbau.
- **`ceb=` in build_version** (empfohlen, framework-Ebene) — berührt die build_version-Doktrin → GO nötig.
- **Versions-Quelle:** constexpr-am-Klassen (empf.) NUR, ODER + Registry-XML-Spiegel?
- **codegen-Minor-Politik:** User bumpt manuell ODER CI-Tripwire erzwingt (rot bis gebumpt)? + exakter CEB-universeller Header-Set-Umfang.
- **CI-Guard:** hart-rot (Pipeline blockt) bestätigen; Lock-Datei-Ort.
- **Persistentes output_dir** (Volume prod1/prod2, Nie-Löschen) — INFRA-HANDOVER, bestätigen.
- **Mess-Resume:** Algo-Versions-Änderung erzwingt Neu-Messung der betroffenen Binaries (empf., ehrlich).

## 9. Risiken
- **ZENTRAL — geteilte Organ-Helfer:** ändert sich ein von MEHREREN Varianten genutzter Helfer ohne dass eine version()
  bumpt → betroffene Binaries FÄLSCHLICH geskippt (stale). Regel: geteilte Helfer gehören einer Achse (deren version()
  sie abdeckt) ODER sind CEB-universell (ceb-Bump); der CI-Tripwire muss sie dem richtigen Bucket zuordnen.
- Bump-Disziplin (Mensch vergisst) — gemildert durch CI-Tripwire (Scope muss exakt sein).
- algo_sig-Determinismus (Slot-Reihenfolge + Format plattform-stabil).
- Persistenz-Verlust (output_dir geleert → Voll-Rebuild) — persistentes Volume + Nie-Löschen dokumentieren.
- Sub-Achsen-Werteset muss in algo_sig (sonst reused Layout-geänderte Binary still).
- Zwei golden-Regime (320/2^17) koexistent — perm.algos nur für neu, alte Leser ignorieren additives Sidecar.
- ~alle Strategie-Klassen bekommen version() (großer mechanischer Diff) — Concept-Pflicht macht Vergessen zu Compile-Fehler.

## 10. Geordnete Code-Änderungen
1. Concept (axis_0X_*_concept.hpp / topics/axis_base.hpp) um Pflicht-`algo_version` (static_assert im CRTP-Ctor).
2. Alle Organ-Varianten (axes/**/axis_*_*.hpp) `static constexpr algo_version = "v1"` ergänzen.
3. anatomy_module_abi_v1_decl.hpp: `ceb_contract_version` = ABI_MAJOR(6)+codegen-Minor.
4. NEU axis_variant_version_table.hpp (compile-time {axis,variant→version} aus Registry-mp_list via mp_for_each).
5. axis_path_serialization.hpp (Zusatz): `compose_algo_signature(spec.axes, table)` → deterministische algo_sig.
6. build_orchestrator.hpp: AlgoSigFn injiziert; algo_sidecar_path()+write_algos_sidecar(); dll_is_current +algo_sig.
7. profile_run_facade.cpp: `+ceb=` in system_axes_version_suffix; AlgoSigFn injizieren.
8. cache_engine_builder_iterator.hpp: BuildOrchestrator +AlgoSigFn; resume-Stamp `|algos=<sig>` (resume-v6-Bump).
9. best_binary_selector.cpp: perm.algos mit-kopieren + `algos`-Feld ins manifest.
10. OPTIONAL: cache_engine_axis_registry.xml + validate_profile.hpp `algo_version`-Attribut (Katalog-Spiegel) + CI-Guard.
11. NEU tools/axis_version_lock/ + .gitlab-ci.yml Guard-Job + eingecheckte axis_version.lock (CI-Tripwire).
