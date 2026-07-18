# SYNTHESE — Adversarialer Review „Limits-Entkopplung Vorstufe" (wf_fce92d2c-302)

> GO-Increment 1 (User-Freigabe 10.07., BACKLOG NON_GATED-1). Reviewgegenstand: Codex-Erstimplementierung
> `apps/catalog_codegen_tool/{main.cpp,CMakeLists.txt}` + `tests/unit/test_limits_entkopplung_vorstufe.cpp`
> + CMake-Codegen-Block (uncommitted auf ce main 5d67eecd). Dossier: `CODEX-DOSSIER.md` (dieser Ordner),
> Spezifikation: `../20260710-schicht-e3-impl/LIMITS-ENTKOPPLUNG-ANALYSE.md`.
> Rohdaten: `rohdaten-review/` (journal.jsonl, workflow-skript.js, ergebnis-erstlauf.json, ergebnis-resume-nach-fixes.json).

## Aufbau

EIN großer adversarialer Workflow (Kadenz-Pflicht je Increment): 3 Finder-Dimensionen
(reihenfolge-golden / typnamen-mapping / scope-cmake) → je Kandidat 2 unabhängige Verifier
(2-Lens, empirische Reproduktion gefordert). Erstlauf: 9 Agenten, 587k Tokens, 233 Tool-Calls.
Resume-Lauf (nach Fixes, User-Auftrag „resume die fehlenden workflows"): 9 Agenten (3 Finder cached),
203k Tokens.

## Erstlauf-Verdikt: 3 Kandidaten, 2 CONFIRMED (beide empirisch reproduziert)

1. **CONFIRMED major — main.cpp:188 (Reihenfolge-Normalisierung statt Validierung).**
   `select_slots` sammelte Profil-Achsen in einer `std::map` und iterierte die kanonische
   19er-Slot-Tabelle → die Profil-DOKUMENTordnung wurde stumm vernichtet. Empirisch: m3v2-Kopie
   mit vertauschten Achsen ⇒ Tool exit 0 + BYTE-IDENTISCHER Header. Der autoritative Runtime-Pfad
   `build_axis_levels` (profile_to_tree.hpp:51-66) baut den Baum aber in Dokumentordnung, während
   Source-Map-Keys immer kanonisch serialisiert werden (kCompositionAxisNames) → jedes künftige
   nicht-kanonische Profil (der Existenzzweck der Entkopplung!) hätte NUR leere binary_id-Lookups
   geliefert, bei durchgehend grünem Tool/Build/Gates.
2. **CONFIRMED minor — main.cpp:179 (cacheline stumm verworfen).** `<axis ref="cacheline">` erzeugt
   in build_axis_levels STATISCHE binary-id-relevante Ebenen (20+-Segment-IDs), das Tool ignorierte
   die Achse per `continue` und bescheinigte einen inkonsistenten Katalog mit exit 0.
3. **UNVERIFIED (Erstlauf) — unbekannter Achsen-ref still übersprungen.** Beide Verifier des
   Erstlaufs schlugen mit transienten API-Safeguards-Fehlern fehl (req_011CctJUfwh3…, req_011CctJV1k…,
   „This sometimes happens with safe, normal conversations" — false-positive, 0 Tool-Calls).
   Konservativ mitgefixt (deckungsgleicher Fix wie Fund 2).

## Fixes (manuell, Claude — Kadenz „kleinere Verstöße → Abschnitts-Korrektur")

In `select_slots` (main.cpp): (a) unbekannter ref = harter Fehler `unknown axis ref in profile` (exit 3);
(b) `cacheline` = eigener sprechender Ablehnungs-Fehler (Vorstufe unterstützt keine
cacheline-Subachsen-Segmente); (c) Ordnungs-Validierung: Slot-Index-Folge der Profil-Achsen muss
streng aufsteigend in kanonischer Slot-Ordnung sein, sonst harter Fehler (exit 3). Werte-Reihenfolge
bleibt korrekt profil-order-preserving (deckungsgleich build_axis_levels; Drift fangen Golden-Gates 1/2).

## Beweise nach Fix (literal)

- swapped-Profil: `catalog-codegen: profile axis order deviates from canonical slot order at 'search_algo' …` → **exit=3**
- cacheline-Profil: `catalog-codegen: axis 'cacheline' ist in der Limits-Entkopplungs-Vorstufe nicht unterstuetzt …` → **exit=3**
- m3v2 normal: `wrote … (static permutations=320)` → **exit=0** (Regression intakt)
- ctest offizieller build/ (g++-16): `100% tests passed, 0 tests failed out of 9`
  (inkl. test_limits_entkopplung_vorstufe, test_e4/e3/e2/m_contract, 3× striktheit)
- clang-format-22 dry-run ==0; Mojibake-grep ==0.

## Resume-Verdikt (unabhängige Bestätigung der Fixes): 3 Kandidaten, 0 CONFIRMED

Alle 6 Verifier des Resume-Laufs (auch die 2 nachgeholten für Kandidat 3) refutierten die Kandidaten
am gefixten Stand mit eigener empirischer Reproduktion (swapped ⇒ exit 3, cacheline ⇒ exit 3,
unknown ref ⇒ exit 3): „Der behauptete Defekt existiert im aktuellen Stand nicht mehr."
scope-cmake-Finder: 0 Findings (Byte-Unberührtheit von source_catalog/adhoc_emitter/golden/m3v2,
Header nur in CMAKE_BINARY_DIR/generated, Test CI-aktiv mit Label e4;limits — alles bestätigt).

## Einordnung

Der major-Fund traf exakt das §3-Risiko „Reihenfolgedrift" der Analyse und wäre erst beim ersten
nicht-kanonischen Profil (= Produktivzweck) explodiert — stiller Totalausfall bei grünen Gates.
Der Review-Workflow hat damit seinen Zweck (plausible-aber-falsche Grün-Bescheinigungen töten)
erneut erfüllt. Produktivumschaltung (Gate-Stufen 4-6) bleibt Folge-Increment.
