# LENS objekt-ist — Fingerprint-IST-Kartierung (READ-ONLY)

Stand: ce `b4110cd0` (verifiziert via `git rev-parse HEAD` = b4110cd021dc1838dde2571d8fe786751f3f626f),
Wurzel = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine`.
Alle Pfade unten relativ zu dieser Wurzel. Kontext: OWNER-KERN abend-5 (Ledger F1 verbatim) + O-2 = Option A
(Achsen-Vollstaendigkeits-Neuanker, gebuendelt mit F1/F3/F4/F5, danach TP1-Wiederholung + 4+1/B10 EINMAL).

---

## (1) anatomy_fingerprint.hpp KOMPLETT — die Preimage-Wahrheit heute

Datei: `libs/cache_engine/include/cache_engine/abi/anatomy_fingerprint.hpp`

- **Puffer-Budget**: `kAnatomyFingerprintPreimageMax = 4096` (Z.41; Budget-Beleg Z.31-40: laengste Organ-Zeile ~762, Summe <~1400).
- **Separator**: `kAnatomyFingerprintSeparator = '\n'` (Z.55) — OF-M3-1 Option A, beweisbar kollisionsfrei, da '\n' ausserhalb des Stempel-Zeichenvorrats alnum+"=@;.+_[]" liegt (Z.51-54). Injektivitaet haengt an FESTER Glied-Anzahl (Z.103).
- **Format-Erstglied**: `kAnatomyFingerprintFormat = "fingerprint_format=2"` (Z.64; Format 1 = separatorlose concat bis A13-M2, Z.62-63).
- **Glied-Anzahl**: `kAnatomyFingerprintGliedCount = 6` (Z.104); System-Position benannt `kAnatomyFingerprintSystemGlied = 2` (Z.113), bewiesen per static_assert (Z.136-138).
- **DIE EINE QUELLE der Ordnung**: `anatomy_fingerprint_glieder(organ, system, measurement, OverlayHash)` (Z.128-132):
  - `[0]` Format-Kennung (`fingerprint_format=2`)
  - `[1]` Organ-Zeile (18 Haupt-Achsen `achse=algo@X.Y.Z`)
  - `[2]` System-Zeile (3 Haupt-Achsen + Meta-Meta-Klammer-Anhang; seit W10-C4 mit Zellwerten `code.<token>`)
  - `[3]` Mess-Tooling-Zeile (Haupt-Wahl + `[load_framework=...]`-Anhang)
  - `[4]` Sub-Achsen-Werteset-Segment `kSubAxisValuesetSegment` (aus `subaxis_valueset_segment.hpp`, Include Z.14)
  - `[5]` Overlay-Source-Hash — **HEUTE LEER** (L14)
- **Overlay-Glied leer/L14**: `COMDARE_OVERLAY_SOURCE_HASH` defaultet auf `""` (Z.83-86); OF-M3-2 = Fallback B, Owner-Festlegungen zur Dateimenge liegen NICHT vor (Z.78-82); Codegen existiert nicht (Z.74-77). L14 als deklarierte Luecke der Eichung: `libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp` Z.262-267 („SHA512 deckt reine Quell-Code-Aenderungen NOCH NICHT; Heilung Phase 6").
- **OverlayHash-Typ (K-1)**: benannter Typ statt 4. string_view (Z.97-101); Sperr-Ueberladung gegen den alten merge-Slot (Z.190-199).
- **Laufzeit-Zwilling des Preimage**: `anatomy_fingerprint_preimage(span)` (Z.145-152) — dieselbe Ordnung/derselbe Separator wie der consteval-Weg `anatomy_fingerprint_hex` (Z.158-174).

**IST-Aussage**: Das Preimage traegt heute AUSSCHLIESSLICH: Format-Version, die drei Realm-Stempel-Zeilen (mit deren Achsen-VERSIONEN), die drei globalen Sub-Achsen-VERSIONEN, ein leeres Overlay-Glied. KEIN cxx/opt/build_type, KEINE Enabled-Mengen (bvset), KEIN planner/ceb-contract-Glied.

---

## (2) system_cell_values.hpp — welche System-Achsen-WERTE existieren

Datei: `libs/cache_engine/include/cache_engine/abi/system_cell_values.hpp`

- **Abschliessende Zellwert-Schluessel** (`kSystemCellValueKeyCount = 3`, Z.116): `kSystemCellValueKeys = {"target_isa", "operating_system", "simd"}` (Z.118-122). `external_utils` bewusst wertfrei (Hub, E-2-Default (a), Z.124-126). Drift-Wache gegen `kSystemAxisOrder` (Z.140-146, asserts Z.184-196).
- **Verbots-Katalog A-15** (RT-Unter-Achsen NIE im Stempel): `os_version/kernel/build/os_family/numa_node/page/scheduling` (Z.166-167).
- **na-Sentinel** `kSystemCellValueNa = "na"` (Z.90) + fail-closed-Zusage Lager-Rueckschrieb (Z.87-89, Praedikat Z.295-305).
- **Define-Naht**: `COMDARE_SYSTEM_CELL_VALUES` default `""` = Identitaet (Z.210-213); Traeger-Typ `SystemCellValues` (K-1-Muster, Z.223-228); Wachen-Batterie ueber dem Define (Z.322-347).
- **Der EINE Renderer**: `detail::render_system_cell_values` (Z.384-410) haengt Token hinter den Algorithmus-Namen vor das '@' (`code` → `code.<token>`); consteval-Form `complete_system_stamp_line_array` (Z.483-500), Laufzeit-Zwilling `complete_system_stamp_line` (Z.506-513).
- **WAS FEHLT (C1-Kern)**: `cxx`? NEIN. `opt`? NEIN. `build_type`? NEIN. Die Schluessel-Liste ist ABSCHLIESSEND 3-elementig; die einzige Zell-Diskriminierung im Preimage-Glied [2] ist isa/os/simd. Genau das deckt der Ledger-Verdikt C1 (nachmittag-9, LEDGER:4129: „W10-Zellwerte sind abschliessend isa/os/simd, system_cell_values.hpp:112-122").

---

## (3) build_variant_sidecar / build_type_stamp / .version-Stempel-Kette — wo cxx/opt/build_type HEUTE leben

**Quelle der Werte (Env/Config, NIE Preimage):**
- `libs/cache_engine/profile_facade/build_type_stamp.hpp`: `build_type_version_suffix()` → `"+bt=Debug"` NUR bei `COMDARE_BUILD_TYPE=Debug` (Z.22-26); Roh-Wert `build_type_version_value()` (Z.32-36). **ACHTUNG Kopf-Kommentar Z.8-10 behauptet: „die build_version steht in dessen [.fingerprint] Preimage" — FALSCH am Objekt** (kein Preimage-Glied traegt die build_version; Ledger C1: „build_type_stamp.hpp:8-10 behauptet faelschlich Preimage-Deckung").
- `libs/cache_engine/profile_facade/system_version_suffix.hpp`: DIE eine Suffix-Ordnung `kSuffixSegmentOrder = {"+cxx=", "+opt=", "+ext=", "+ceb=", "+target=", "+tel=", "+bt=", "+gate="}` (Z.56-57); `SystemVersionSuffixParts` (Z.61-70); `compose_system_version_suffix` (Z.73-89); `ceb_contract_version_text()` = `COMDARE_ANATOMY_ABI_MAJOR . kCebContractCodegenMinor` (Z.49-52); Ordnungs-Anker static_asserts (Z.94-99).
- **Perm-Schleife fuellt die Glieder**: `libs/cache_engine/profile_facade/profile_run_entry.hpp` — `perm_parts.cxx = a.compiler_tag` (Z.906), `.opt = opt_id` (Z.907), `.simd` (Z.908), `.ceb = ceb_contract_version_text()` (Z.922-923), `.build_type = build_type_version_value()` (Z.924), `.gate_contribution` (Z.926-929); `perm_suffix` → `perm_build_version = a.build_version + perm_suffix` (Z.931) und CSV-Tag (Z.932). `compiler_tag`-Feld deklariert Z.99 („+cxx=-Provenienz im per-Perm-build_version, NIE binary_id").

**Fluss in `.version`, NICHT in `.fingerprint`:**
- `cfg.build_version = perm_build_version` (`profile_run_entry.hpp:544`) → Orchestrator schreibt `write_version_sidecar(job.output, cfg_.build_version)` (`libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp:596`, Writer Z.307-323, fail-loud TP1FK1-B2).
- `.fingerprint` dagegen: `expected_fp = fingerprint_(spec.binary_id)` (`build_orchestrator.hpp:524`) — der FingerprintFn rechnet NUR ueber die 6 Glieder (s. (6)); cxx/opt/bt kommen dort nirgends vor.
- Seit A2-Eichung entscheidet NUR `.fingerprint` den Skip (`dll_is_current`, `build_orchestrator.hpp:293-299`; F7-Doku Z.244-289): `.version/.algos/.variant` sind reine Provenienz-/Transport-Marken (Z.270-273). **=> C1: zwei Baue derselben Permutation mit anderem opt/bt haben IDENTISCHEN Fingerprint; teilt sich der Pfad (lokaler opt×simd-Loop, EIN `output_dir` `profile_run_entry.hpp:556` `cfg.output_dir = a.dll_dir`; CI: `dll_dir = .../gn_out/<slug>/<host>/perm<idx>` OHNE Zelle/bt, `libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:1236`), skippt O3 auf die O2-DLL bzw. Debug auf Release.**
- `--version`-Ausgabe-Zwilling (kein Bau-Input): `libs/cache_engine/profile_facade/g1_binary_version_stamp.hpp` Z.44-56 (`build-type=`, `build-version=<suffix>`-Zeilen).
- `.variant`-Sidecar: `libs/cache_engine/builder/build_variant_sidecar.hpp` — Einzel-POD-Signatur `compose_variant_signature` (Z.44-64: `bv=..;page_kind=..;simd_width_bits=..;simd_avx512=..;simd_avx10_version=..;hw_cache_line=..;hw_numa_capable=..;present_mask=..`), Parser Z.69-106. **Kopf-Kommentar Z.10-13 (NACHGEFUEHRT 2026-08-05) behauptet: „seine Wirkung ... laeuft ueber das bvset-Glied IM Fingerprint-Preimage" — DIESES GLIED EXISTIERT NICHT** (s. (5); F5-/C6-Ziel).
- **Stale-Kommentar-Kandidat Nr. 3 (im Ledger nicht gelistet, hier markiert per Atlas-Regel):** `profile_run_entry.hpp:917-921` behauptet „das +ceb-Glied wirkt jetzt ueber das PREIMAGE (es steht in der System-Zeile = Glied [2])" — am Objekt UNGEDECKT: die System-Zeile (`system_stamp_line` + Zellwert-Vervollstaendiger) enthaelt kein `+ceb`-Byte; die Contract-Version lebt nur im build_version-Suffix (`system_version_suffix.hpp:49-52`). Gehoert in die F5-Kommentar-Drehung mit aufgenommen.

---

## (4) Achsen-VERSIONIERUNGS-Traeger — was ist im Preimage, was nicht

| Traeger | Datei:Zeile | Inhalt | Im Preimage? |
|---|---|---|---|
| Organ-Zeile (18 Achsen) | `libs/cache_engine/include/cache_engine/abi/anatomy_version_stamp.hpp:82-116` (`organ_stamp_line<Comp>`, 18 `AxisVersionEntry` Z.85-105 inkl. `persistence_target` Z.104; `kOrganAxisCount = 18` Z.39; static_assert Z.106-109) | je Achse `name()` + `algo_version` X.Y.Z | **JA, Glied [1]** |
| System-Code-Versionen | `libs/cache_engine/include/cache_engine/abi/system_axis_code_versions.hpp:55-59` (`kSystemAxisCodeVersions`: target_isa/operating_system/external_utils je `"v1.0.0c"`; `kSystemAxisCodeCount = 3` Z.38; Bump-Wachen Z.81-96; compiler/scheduling/load_framework = UMZUEGE, Z.33-37) → gerendert in `system_stamp_line` (`anatomy_version_stamp.hpp:144-161`) + Meta-Meta-Anhang `[simd=code@1.0.0c]` aus `ExternalUtilsHub::meta_metas` (Z.157-159) | Code-Identitaet + seit W10-C4 Zellwert-Namens-Anteil | **JA, Glied [2]** |
| Mess-Tooling-Versionen | `anatomy_version_stamp.hpp:216-231` (Einzel-Form, `tooling_version_for_id`), Z.239-258 (Mengen-Form), Z.264-270 (Vollmenge aus `kMeasurementToolingRegistry`), Z.277-296 (Combo-Legende); load_framework-Klammer-Anhang Z.200-214 | `measurement_tooling=<t>@X.Y.Zc;[load_framework=ycsb@X.Y.Zc]` | **JA, Glied [3]** |
| Sub-Achsen-Werteset | `libs/cache_engine/include/cache_engine/abi/subaxis_valueset_segment.hpp:44-71` (`sub=cacheline@vN,node_width@vN,alloc_hw@vN` aus `kCacheLineSubaxisVersion`/`kNodeWidthSubaxisVersion`/`kAllocHwSubaxisVersion`, Includes Z.25-27) | NUR die 3 globalen Sub-Achsen-VERSIONEN | **JA, Glied [4]** |
| Mess-Array Sec-58-V (POD-Array-Form) | `libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp:150-167` (`AnatomyStampEntryV1`), Z.219-226 (`organ_entries`/`system_entries`/`measurement_entries` + counts im `AnatomyVersionLines`-POD), Layout 6 Z.243, sizeof-Pin 120 Z.251 | ARRAY-Sicht DERSELBEN Zeilen-Literale (consteval geparst, keine zweite Wahrheit) | indirekt (gleiche Literale wie Glieder [1]-[3]); `sha512_line` Z.207-209 traegt den fertigen Fingerprint |
| CEB-Selbst-Stempel | `libs/cache_engine/builder/ceb_version_stamp.hpp:159-161` (`kCebMeasurementStamp`), Z.187-189 (`kCebFingerprint` = `anatomy_fingerprint_hex("","",mess)`), Z.166-178 (bewusst ZELLWERTFREI) | CEB-Provenienz (Log-Kopf/--version) | **NEIN** (kein Tier-Preimage) |
| planner_version | `libs/cache_engine/profile_facade/planner/planner_version.hpp:37` (`kPlannerVersion = "v1.0.0c"`), Stamp-Zeile Z.58ff | `planner@1.0.0c isa=.. os=..` im --dump-plan-Header | **NEIN** |
| ceb-contract (+ceb=) | `system_version_suffix.hpp:49-52`; decl-Quellen `COMDARE_ANATOMY_ABI_MAJOR`/`kCebContractCodegenMinor` (anatomy_module_abi_v1_decl.hpp) | build_version-Suffix-Glied | **NEIN** (nur `.version`/CSV/Cache-Key) |
| Build-Varianten-Versionen | `libs/cache_engine/anatomy/build_variant_definition.hpp` (`kBuildVariantDefinitionVersion`), gestempelt als `bv=` in `.variant` (`build_variant_sidecar.hpp:47-48`) bzw. `bvset=1;bv=..` (`build_variant_set_signature.hpp:47,156-159`) | POD-/Format-Version der Varianten-Signatur | **NEIN** |
| cxx/opt/build_type/gate/tel/target | s. (3) | build_version-Suffix-Glieder | **NEIN** |

Formatter beider Stempel-Welten: `libs/cache_engine/include/cache_engine/measurement/axis_version_stamp.hpp:29-49` (`AxisVersionEntry` + `build_axis_version_stamp_line`, X.Y.Z-Voll-Form; SEPARATE Welt zur `.algos`-Sig).

**Owner-KERN-Abgleich (abend-5/F1)**: Die geforderte Compiler-HAUPT-Achse (inkl. Flags als Teil der Haupt-Achsen-DEFINITION) existiert heute NICHT als versionierte Achse im Preimage: `compiler` ist per A3/O-8 aus der System-Tabelle entfernt und als „Unter-Achsen-GRUPPE der AEUSSEREN System-Komplex-Achse" deklariert (`system_axis_code_versions.hpp:33-37`); seine Laufzeit-Spuren sind `+cxx=`/`+opt=`/`+bt=`/`+gate=` im build_version-Suffix. Der Neuanker muss genau diese Glieder in versionierte (Haupt-)Achsen-Stempel-Form heben.

---

## (5) bvset/Enabled-Mengen (C6) — VARIANT_GATE-Kette und das Werteset-Glied

- **Enabled-Mengen leben je Achse als CT-Typliste**: `EnabledStrategies = mp_filter<is_enabled, AllStrategies>` — z.B. `libs/cache_engine/axes/lookup/axis_03a_search_algo_registry.hpp:95-97`, `axes/cache_traversal/axis_03b_cache_traversal_registry.hpp:29-31`, `axes/concurrency_axis/axis_08_concurrency_registry.hpp:30-32`, `topics/queuing/axis_q1_queuing/axis_q1_queuing_registry.hpp:55-57`; verdrahtet in die Topic-Config-Sets (`topics/traversal/topic_traversal_config_set.hpp:23-29` u.a.).
- **XML-enabled-Flags als Quelle**: `libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml` (z.B. Z.10-13 `enabled="true"`), via Registry-Generator → CMake-Flags `COMDARE_AXIS_*_ENABLE_*` (Konsum-Beispiel `profile_facade/source_catalog.hpp:588-593`).
- **Mengen-Signatur (bvset)**: `libs/cache_engine/builder/build_variant_set_signature.hpp` — Kopf `bvset=<format>;bv=<pod-version>` (Z.156-159), je Achse separat geklammert `page_type[..];simd_extension[..];general_hardware[..]` (Z.127-149), `variant_set_signature<PageList,SimdList,HwList>()` (Z.194-198). Treiber-Konstante ueber die REALEN Enabled-Listen: `libs/cache_engine/builder/driver_build_variant_signature.hpp:19,40` (`kDriverBuildVariantSignature.starts_with("bvset=")`).
- **VARIANT_GATE-Kette**: Director forwarded `COMDARE_VARIANT_GATE` (`experiment_plan_director.hpp:950-956`) → Treiber liest es EINMAL: `variant_gate_sig` (`profile_run_entry.hpp:395-400`, opt-in `=true`) → `cfg.build_variant_sig = variant_gate_sig` (Z.559) → Orchestrator schreibt `.variant` (`build_orchestrator.hpp:598-600`, Writer Z.332-337).
- **NICHT-Einfluss aufs Preimage**: Glied [4] rendert AUSSCHLIESSLICH die drei Sub-Achsen-VERSIONEN (`subaxis_valueset_segment.hpp:59-64`) — KEINE Enabled-Mengen, KEIN bvset. Kein anderes Glied traegt sie. Seit A2 vergleicht `dll_is_current` `.variant` nicht mehr (`build_orchestrator.hpp:270-273`) ⇒ **COMDARE_VARIANT_GATE ist faktisch write-only** (Ledger C6 REAL-NEU, LEDGER:4129: „bei voll-enableter Flotte inert"). Der `build_variant_sidecar.hpp:10-13`-Kommentar behauptet das nicht existierende bvset-Glied (F5-Ziel).

---

## (6) Konsumenten-Kette des Fingerprints — die EINE-Schluessel-Welt-Naht

**Berechnung (Provider):**
- Laufzeit-Zwilling: `lazy_adhoc_fingerprint_for` (`libs/cache_engine/profile_facade/lazy_adhoc_source_gen.hpp:347-365`) — organ via `compose_organ_stamp_line`, system via `complete_system_stamp_line(system_stamp_line(), cell_values)`, Glieder aus `abi::anatomy_fingerprint_glieder`, Preimage aus `abi::anatomy_fingerprint_preimage` (Z.356-364).
- Provider-Naht: `make_lazy_adhoc_fingerprint_fn_from_env` (Z.380-394; Zellwerte per WERT gefangen); gated auf `COMDARE_BESTANDSLOG=true` (`profile_run_entry.hpp:381-386`), per-Perm mit Zellwerten (Z.895-900), injiziert als `cfg.bestand_fingerprint_fn` (Z.558).

**Skip + Schreiben (Orchestrator):** `libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp`
- `expected_fp` EINMAL je Job (Z.518-524), Skip `dll_is_current(job.output, expected_fp)` (Z.529; Funktion Z.293-299; fail-closed-Katalog Z.249-255; EINE-Schluessel-Welt-Deklaration Z.257-260: „Skip-Gate == .fingerprint-Inhalt == minio-Objekt-Key == Bestandslog key_sha512 == Baum-Blatt-Identitaet"; L14 Z.262-267).
- Nach Bau-Erfolg: `write_version_sidecar` (Z.596) / `write_algos_sidecar` (Z.597) / `write_variant_sidecar` (Z.598-600) / `write_fingerprint_sidecar(job.output, expected_fp)` (Z.603; Writer Z.349-353, **leer = no-op ⇒ C5-Stale-Anker-Luecke, kein fail-loud** — Kontrast: `.version`-Writer ist seit TP1FK1-B2 fail-loud Z.307-323).

**Lesen (EINE Lese-Wahrheit):** `libs/cache_engine/builder/build_orchestrator/fingerprint_sidecar.hpp`
- `fingerprint_sidecar_path` (Z.48-50), `read_fingerprint_sidecar` (Z.101-114; Trim + 128-hex-Formwache; beide Leser deklariert Z.82-88: dll_is_current + Lager-Binder).
- Lager-Binder: `libs/cache_engine/builder/bestandslog/fingerprint_key_source.hpp:77` (`make_fingerprint_key_fn`, Delegation an read_fingerprint_sidecar Z.72-76) → `LazyRunConfig::bestand_key_of` (`libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:220`, Mess-Seite `mess_bestand_key_of` Z.244).

**LagerKey / Bestandslog / minio:**
- `libs/cache_engine/builder/bestandslog/bestandslog_index.hpp`: `derive_key_from_lines` = sha512 ueber `anatomy_fingerprint_preimage` (Z.60-67), `to_hex`/`key_from_hex` (Z.70-100), `LagerKey{sha, zelle}` (Z.104-111; Zelle NIE im Digest, Z.15-19).
- `libs/cache_engine/builder/bestandslog/bestandslog_factory.hpp`: `BinaryKeyPolicy::derive_key` vervollstaendigt GENAU Glied [2] um die Zellwerte (Z.62-70, `kAnatomyFingerprintSystemGlied`) und rechnet ueber `derive_key_from_lines`; `derive_lager_key` klammert die Zelle DANEBEN (Z.71-75).
- Bestandslog-Dokument: `libs/cache_engine/builder/bestandslog/bestandslog_document.hpp` — Eintrags-Identitaet = TUPEL (`key_sha512`, zelle) (Z.197-231, Feld Z.200; Serialisierung Z.343-345; Parse Z.433); CEB-Referenz `ceb_key_sha512` (Z.255, Z.400-402, Parse Z.470).
- Baum/minio: `lager_pfad_grammatik.hpp:15` („Baum-Pfad == minio-Objekt-Praefix == Verortung des key_sha512-Blatts"), `lager_ziel_strategie.hpp:118` (`objekt_key(objekt_key(minio_praefix, baum_pfad), blatt)`), `lager_baum_writer.hpp:31-32` (Blatt-Identitaet = v6-Fingerprint, F7-Konvergenz).
- Transport (Ebene B): `libs/cache_engine/builder/artifact_transport/artifact_cache.hpp` — `perm.dll.fingerprint` in `kOptionalTierSidecars` (Z.102, Doku Z.92); Push-Ordnung `.version` ZULETZT mit throw (Z.415-424); Pull raeumt lokale Marken/Sidecars ZUERST (Z.427-440; Objekt-Key-Schema `cache_key_prefix(build_version)/<stem>/...` Z.6 — der Transport-PFAD traegt build_version, die IDENTITAET das .fingerprint).

**Resume-Naht (C4-Flaeche):** `libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp`
- Mess-Resume-Stamp `resume-v5|build=<build_version>|...` (Z.890-897) — traegt die build_version (inkl. +cxx/+opt/+bt), aber **KEIN `fpr=`-Feld**; `lazy_try_resume_binary` (Z.935-977) prueft Stamp-Prefix+Header+Zeilenzahl; Aufruf Z.1815-1822 im b.ok()-Zweig (gebaut ODER uebersprungen — prueft NICHT, ob die DLL soeben identitaets-geaendert NEU gebaut wurde ⇒ „NEUE DLL, ALTE MESSWERTE", Ledger C4).

---

## A2-Fix-Plaene F1/F3/F4/F5 (Ledger nachmittag-9, LEDGER:4130) als Datei-Landkarte

| Fix | Inhalt (Ledger) | Dateien (IST-verortet) |
|---|---|---|
| **F1** (C1-Interim) | per-Perm-Unterordner cxx-opt-bt im lokalen Loop; bt-Pfad-Suffix in der Director-Emission | `profile_run_entry.hpp` (Perm-Schleife Z.899-940; `cfg.output_dir = a.dll_dir` Z.556) · `planner/experiment_plan_director.hpp` (dll_dir `.../perm<idx>` Z.1236; Env-Emission COMDARE_GN_OPT/SIMD/BUILD_TYPE Z.1164-1168, 1246, 1269, 1405-1423, 1691-1766) |
| **F3** (C5) | provision_core raeumt stale Sidecars beim Neubau (mind. `.fingerprint` bei leerem expected; konsequent .algos/.variant/.version) + write-fail-loud im TP1FK1-B2-Muster | `build_orchestrator.hpp` (provision_core-Erfolgszweig Z.595-604; Writer Z.325-353; Muster Z.300-323) |
| **F4** (C4) | Resume an `b.skipped` koppeln + `\|fpr=<expected>` additiv im Stamp (resume-v6) | `cache_engine_builder_iterator.hpp` (Stamp Z.890-897; `lazy_try_resume_binary` Z.935; Aufrufstelle Z.1815-1822) |
| **F5** (C6) | Kommentare drehen (datiert, Doku-Doktrin) | `build_variant_sidecar.hpp:10-13` · `build_type_stamp.hpp:8-11` · **zusaetzlicher Kandidat (dieser Lens): `profile_run_entry.hpp:917-921` (+ceb-im-Preimage-Behauptung)** |

**Buendel-Zwang (Dateien, die Neuanker UND Fixe beruehren):**
1. `profile_run_entry.hpp` — F1 (Pfad-Disziplin) UND Neuanker (Suffix-Glieder cxx/opt/bt werden Preimage-Traeger; Provider-/Zellwert-Naht Z.895-931).
2. `experiment_plan_director.hpp` — F1 (Pfad/bt-Emission) UND Neuanker (Define-/Env-Emission je Zelle muss die neuen Achsen-Werte tragen).
3. `build_orchestrator.hpp` — F3 (Sidecar-Raeumung/fail-loud) UND Neuanker (expected_fp-Naht Z.518-529 + Doku-Bloecke Z.244-289 muessen den neuen Glied-Satz deklarieren).
4. `cache_engine_builder_iterator.hpp` — F4 (`|fpr=` im Stamp) haengt DIREKT am Preimage: jeder Neuanker aendert `<expected>` — F4 vor dem Neuanker hiesse zwei Stamp-Invalidierungswellen.
5. `build_type_stamp.hpp` / `build_variant_sidecar.hpp` — F5-Kommentare werden vom Neuanker inhaltlich WAHR gedreht (bt bzw. bvset kommen ins Preimage); getrennt gefahren wuerden dieselben Saetze zweimal umgeschrieben.
6. Preimage-Kern selbst (nur Neuanker, aber Fix-Testflaechen beruehrend): `anatomy_fingerprint.hpp` (Glied-Liste + `fingerprint_format`-Bump 2→3), `system_cell_values.hpp` (Schluessel-Erweiterung oder eigenes Glied), `subaxis_valueset_segment.hpp`/neues bvset-Glied (`build_variant_set_signature.hpp`, `driver_build_variant_signature.hpp`), Zwillinge `lazy_adhoc_source_gen.hpp` + `bestandslog_factory.hpp`/`bestandslog_index.hpp`, Frozen-Vektor `tests/unit/test_g3_sha512_index.cpp:45` (`kFrozenFingerprintV1`, identisch in `test_w10_system_cell_values.cpp` + `test_m_w12_stamp_bausteine.cpp`; Pin-Kommentar `test_a2_sha512_skip_gate.cpp:24`).

**Konsequenz (deckt O-2 Option A):** EIN Fenster mit EINEM Format-Bump (Glied-Nachtrag + `fingerprint_format=3`), F1/F3/F4/F5 im selben Zug, danach TP1-Wiederholung + 4+1-Beweise (B10 — Variant-Gate-E2E ist seit A2 ohnehin inert und wird erst durch das bvset-Glied wieder beweisfaehig) EINMAL auf finalem Stand.
