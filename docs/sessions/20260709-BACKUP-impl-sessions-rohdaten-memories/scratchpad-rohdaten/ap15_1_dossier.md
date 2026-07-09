# DOSSIER AP-15-1 (#263) — conformance-Gate: 17-Dagger-Ops-Vollausbau via HOST-SEITIGE Synthese (ABI-frei, golden-neutral, kein DLL-Rebuild)

> **Für Codex** (workspace-write, gpt-5.5, xhigh). Repo = `--cd` (comdare-cache-engine, HEAD c9a7e44e). **NICHT committen, kein git, kein $null.**
> SCOPE: NUR `libs/cache_engine/builder/pruef_dock/conformance_gate.hpp` + Tests. NICHT: IDriveableTier/abi_adapter/POD/extern-C (ABI-4-Freeze!), modules/-Baum (veralteter Mirror, MAJOR 2 — ignorieren), get_allocator (15-2), CRTP-Mixin (15-3), perm_runner (user-dirty).

## 1. Auftrag
`run_conformance_gate` prüft heute nur 4 der 17 Dagger-Ops der Thesis-Pflicht-std::map-Schnittstelle (Anhang F tab:if-map). Baue das Gate so aus, dass ALLE 17 host-seitig gegen das Oracle geprüft werden — synthetisiert aus den 5 vorhandenen noexcept-ABI-Primitiven (tier_insert/lookup/erase/clear/size) + optional tier_scan. KEINE neue ABI-Op.

## 2. Kanonische 17-Dagger-Liste (aus Thesis verifiziert — EXAKT diese)
at · operator[] · begin/end (Paar) · empty · clear · insert · insert_or_assign · emplace · try_emplace · erase · find · count · contains · lower_bound · upper_bound · equal_range · key_comp. (`size` ist NICHT dagger; `get_allocator` separat in 15-2.)

## 3. Ist (Kartierung, verifiziert)
- Gate: `libs/cache_engine/builder/pruef_dock/conformance_gate.hpp` — `run_conformance_gate(IDriveableTier&, seed=42, n_random=2000)` (`:32`), Oracle `std::map<uint64,uint64>` (`:44`, TABU — bleibt), RF1-RF7 (`:49-:107`) + 2000 Zufalls-Ops `rng()%3` × Keys `rng()%256`.
- ABI-Primitive: `anatomy/idriveable_tier.hpp:28-46` — 5 Ops, alle noexcept, uint64. `IScannableTier` (geordneter Scan `tier_scan`) existiert als Sub-Interface — per `dynamic_cast` erreichbar (nur MESSUNG-AN-Builds vererben es).
- Tests: `tests/unit/test_conformance_gate.cpp` (plain main; MapTier + defekte Hüllen + KAry-Gate) + `tests/unit/test_v5_conformance_gate.cpp` (gtest). CI `contract:conformance` (`.gitlab-ci.yml:133`) treibt test_conformance_gate via ctest — greift automatisch.
- WICHTIG-SEMANTIK: prüfe ZUERST, welche Insert-Semantik `tier_insert` vertraglich hat (Gate-RF-Kommentare + ein Organ, z.B. composed_tree_search insert = Überschreiben ⇒ insert_or_assign-Semantik). Die Synthesen unten entsprechend GEGEN die korrekte std::map-Gegenoperation spiegeln — nichts umdeuten.

## 4. Soll — Synthese-Blöcke (additiv in run_conformance_gate; je Block eigener RF-Kommentar mit Dagger-Op-Namen)
**(A) Aus lookup/size (immer verfügbar):**
- `contains`/`count`: tier_lookup-bool ↔ oracle.contains/count (hit+miss-Fälle).
- `empty`: tier_size()==0 ↔ oracle.empty() — vor Befüllung, nach clear, nach letztem erase.
- `find`: bereits RF-gedeckt — um expliziten miss-nach-erase-Randfall ergänzen falls fehlt.
**(B) Bedingte Einfüge-Semantiken (synthetisiert als lookup→ggf. insert):**
- `emplace`/`try_emplace`: nur-falls-fehlt: `if(!tier_lookup) tier_insert` ↔ oracle.emplace/try_emplace — Fall „Key existiert, Wert bleibt ALT" ist der Kern-Randfall.
- `insert` (std::map-Semantik: überschreibt NICHT): gleiche Synthese, gegen oracle.insert gespiegelt.
- `insert_or_assign`: direkte tier_insert (falls Überschreib-Semantik bestätigt) ↔ oracle.insert_or_assign — Fall „Key existiert, Wert wird NEU".
- `operator[]`: lookup-oder-default-insert (`if(!lookup) insert(k,0)` dann lookup) ↔ `oracle[k]` (wertinitialisiert 0).
- `at`: hit → Werte-Gleichheit mit oracle.at; miss → Gate erwartet lookup==nullopt UND oracle.at wirft (try/catch im GATE — Host-Code, kein noexcept-Konflikt).
**(C) Ordnungs-Ops (NUR wenn `dynamic_cast<IScannableTier*>` gelingt — sonst SKIP mit ehrlicher Log-Zeile „ordnungs-Ops übersprungen (kein IScannableTier)"; Gate-Ergebnis bleibt dann auf A+B gestützt):**
- `begin/end`: voller tier_scan ↔ Oracle-Iteration — gleiche Länge, gleiche (key,value)-Folge in Schlüsselordnung.
- `lower_bound`/`upper_bound`/`equal_range`: host-seitig aus der gescannten geordneten Folge abgeleitet ↔ Oracle-Ergebnisse, für Probe-Keys: vorhandene, fehlende zwischen zwei vorhandenen, kleiner als min, größer als max.
**(D) `key_comp`:** deklarativer Check — Vertrag ist `std::less<uint64>`; belege via Ordnungs-Scan (C) bzw. bei fehlendem Scan als statische Notiz (static_assert im Gate-Header über Oracle-key_compare == std::less<uint64>).
**Key-Raum:** BESTEHENDE Verteilung (%256 + 7/999/42) BEIBEHALTEN — KEIN Widening (bricht u16-Monolith-Binaries, 4bb0:22-23). Zusätzlich neuer OPT-IN-Parameter `wide_keys=false`; nur wenn true, ein zusätzlicher Block mit Keys {0, 65536, 1<<32, UINT64_MAX} (für u64-Organe; Default-Aufrufer unverändert).
**Rückgabe/Report:** bestehende Ergebnis-Form beibehalten; je neuem Block eine Zähler-/Log-Zeile (z.B. „RF8 dagger-contains: OK"), damit CI-Trace literal belegt, welche der 17 geprüft wurden.

## 5. Tests
- `test_conformance_gate.cpp`: je Synthese-Klasse eine DEFEKTE Hülle, die NUR diese Klasse verletzt und vom Gate gefangen werden MUSS: (i) BrokenTryEmplace (überschreibt statt bewahrt), (ii) BrokenEmpty (size lügt bei 0), (iii) BrokenOrder (scan unsortiert — nur falls Scannable-Testhülle machbar; MapTier um IScannableTier erweitern falls vorhanden, sonst dokumentiert weglassen). MapTier-Referenz muss weiter PASS sein.
- gtest-Pendant `test_v5_conformance_gate.cpp` analog minimal erweitern.
- Alles clang-format-konform: `C:/temp/comdare/tools/clang-format-22.1.8.exe --dry-run -Werror <dateien>` = 0.

## 6. HARTE Auflagen
1. Oracle bleibt `std::map<uint64,uint64>`. 2. KEINE Änderung an IDriveableTier/IScannableTier/abi_adapter/POD (ABI-4). 3. Default-Verhalten bestehender Aufrufer identisch (Signatur nur um defaultete Parameter erweitern). 4. Kein Key-Raum-Widening im Default. 5. modules/ + apps/perm_runner NICHT anfassen. 6. Ehrliche Skips loggen statt fabrizieren.

## 7. Verifikation (PFLICHT, literal)
- Build+Run über offiziellen build/: `test_conformance_gate` + `test_v5_conformance_gate` + `test_188_4c0_known_compositions_conformance` (Bestands-Kompositionen bleiben grün!) → literal PASSED/OK-Zeilen inkl. der neuen RF-Dagger-Zeilen.
- `test_profile_roundtrip` → golden mismatch 0.
- clang-format = 0. `git status --short` = NUR conformance_gate.hpp + die 2 Test-Dateien (+ ggf. tests/unit/CMakeLists.txt falls nötig).

## 8. Ausgabe an Claude
(a) Diff-Übersicht; (b) literal alle Suiten + die neuen RF-Zeilen (welche der 17 geprüft, welche geskippt und warum); (c) tier_insert-Semantik-Befund (Beleg-Zeile); (d) Bestätigung TABUs; (e) bewusste Absenzen (15-2/15-3, wide_keys default-off).
