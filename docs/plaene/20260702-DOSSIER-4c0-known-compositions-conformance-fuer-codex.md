# DOSSIER #188-4c-0 — Known-Compositions-Conformance-Gate (Sicherheitsnetz VOR dem Spiegel-Abbau)

**Für: codex exec (workspace-write) im Repo `comdare-cache-engine` (HEAD `a1f6024`).**
**Increment-Ziel (TEST-ONLY, KEIN Produktions-Code-Umbau):** Ein neuer Test treibt ALLE Reference-/
PaperBinding-Compositions aus `compositions/known_compositions_list.hpp` durch den `SearchAlgorithmAbiAdapter`
gegen das std::map-Orakel — als Baseline VOR #188-4c (Spiegel-Eliminierung). Der Test bleibt über den
4c-Umbau UNVERÄNDERT bestehen und beweist danach Verhaltens-Äquivalenz.

## 0. BINDENDE VORGABEN + TABUS
1. **NUR neue Test-Datei** `tests/unit/test_188_4c0_known_compositions_conformance.cpp`. KEINE Änderung an
   `abi_adapter.hpp`, Achsen, Registry, Compositions, Concepts. KEINE CMake-/CI-Edits (**Integrator macht
   CMake/CI — bewusste Arbeitsteilung, im Review NICHT als fehlend melden**).
2. TABU: `modules/**`, `ext/**`, golden-Dateien, Registry-mp_list. Kein git. Keine Editor-Temp-Dateien
   (`*~NNNNN`, `$null`).
3. Muster/Stil: `test_188_4bbV_pool_adapter_flip_compile.cpp` (Adapter je Familie instanziieren + treiben;
   standalone-tauglicher Aufbau) + `test_conformance_gate.cpp` (Gate-Konsum). Benannte Konstanten statt
   Literale; deutsche Kommentare im Nachbar-Stil; Increment-Tag `#188-4c-0 (2026-07-02)`.

## 1. FUNDAMENT (verifiziert, HEAD a1f6024)
- Die Kompositions-Liste: `compositions/known_compositions_list.hpp:91-106` (mp_for_each-Traversal :97-105) —
  enthält die Reference-/PaperBinding-Compositions (z.B. ArtReference mit `search_algo = ObservableArtTrieOrgan`,
  `compositions/art_reference.hpp:65`; hot/wormhole/surf/start/masstree + PaperBinding-Varianten). Diese
  Gruppe ist heute `container_is_authoritative_ == false` (search_organ_ + Spiegel) — GENAU die 4c-Zahler.
- Das Gate: `builder/pruef_dock/conformance_gate.hpp:32-115` (`run_conformance_gate`, std::map-Orakel,
  RF-Regeln + deterministische Op-Sequenz; `ConformanceResult` :22-27). Konsum-Vorlage:
  `tests/unit/test_conformance_gate.cpp`.
- Adapter-Instanziierung je Komposition: Muster `test_188_4bbV_pool_adapter_flip_compile.cpp` —
  `SearchAlgorithmAbiAdapter<SearchAlgorithmAnatomy<Composition>>`, treiben über die ABI-Verben
  (tier_insert/tier_lookup/tier_erase/tier_size/tier_clear) bzw. direkt via `run_conformance_gate`, je
  nachdem was das Gate konsumiert (IDriveableTier-Fassade — am Bestand ablesen, nicht raten).

## 2. DER TEST (GTest)
- **T1 (Kern): Conformance über ALLE Known Compositions.** Über `known_compositions_list` (mp_for_each) je
  Komposition: Adapter instanziieren → `run_conformance_gate` → `EXPECT_TRUE(result.passed)` mit
  Kompositions-Namen in der Fehlermeldung (`Composition::name` aus dem IsComposition-Vertrag). Zähle die
  durchlaufenen Kompositionen mit und `EXPECT_EQ` gegen eine benannte Konstante `kKnownCompositionCount`,
  die aus der Liste selbst abgeleitet wird (mp_size — NICHT hart 11 raten; die Liste ist die Wahrheit).
- **T2: Größen-/Clear-Rundlauf je Komposition** (falls nicht schon vom Gate abgedeckt): N=64 Inserts →
  tier_size==64 → tier_clear → tier_size==0 → erneut 8 Inserts korrekt (Wiederverwendbarkeit nach clear).
- **T3 (Baseline-Anker für 4c): Diagnostik-Snapshot.** Je Komposition `tier_search_routes_through_store()`
  dokumentierend erfassen (heute false für diese Gruppe) — als EXPECT mit Kommentar „flippt mit 4c-i auf
  true; dieser EXPECT wird DANN im 4c-i-Increment bewusst angepasst (einzige erlaubte Test-Änderung)".
- **T4 (compile-time):** static_asserts — jede Known Composition erfüllt `IsComposition`; die Liste ist
  nicht leer.
- Unter `COMDARE_MEASUREMENT_ON`-Gating arbeiten wie die Vorlagen (der Adapter vererbt IObservableTier nur
  bei AN — Testaufbau exakt wie test_188_4bbV, das kompiliert bereits in der contract-Stage auf Linux-g++).

## 3. VERIFIKATION + BERICHT
- MSVC-Syntax-Check (`cl /Zs`) wie üblich, falls verfügbar; sonst berichten.
- Abschlussbericht: (a) Datei + Testliste; (b) WELCHE Kompositionen die Liste real enthält (Namen, Anzahl);
  (c) wie das Gate konsumiert wurde (welche Fassade); (d) Abweichungen mit Begründung; (e) offene Risiken.
