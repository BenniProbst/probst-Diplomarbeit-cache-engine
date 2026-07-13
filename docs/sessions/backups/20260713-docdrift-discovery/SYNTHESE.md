# Doku-Drift-Discovery (Goal-V4 #9 / Voll-Review Muster-E) — Synthese + Triage

**Auslöser:** G4-#9 „114 Doku-Drift" aus dem Voll-Zeilen-Review (`20260712-full-line-review`). Die Einzel-Findings
standen nicht im committeten Bericht → read-only Discovery-Workflow `wf_5b5add40-569` (3 Cluster parallel, Opus 4.8,
414k Token, 91 Tool-Calls). Rohdaten je Agent: `subagents/workflows/wf_5b5add40-569/journal.jsonl`.

**Doktrin:** streng additiv (DEPRECATED/SUPERSEDED-Vermerk bzw. Nachfolger-Verweis), **nie löschen**; Registry-`mp_list`
= TABU (nur lesen); Lizenzen NIE raten; Thesis-`.tex` = Overleaf-Remote-GO; „22-Achsen"-SOLL-Docs bewusst gepinnt.

## Autoritative Ist-Zahlen (Code-Anker, nur lesen)
| Konzept | Ist | Quelle |
|---|---|---|
| Such-Algos axis_03a | **22** | `axes/lookup/axis_03a_search_algo_registry.hpp:54-91` (AllStrategies) |
| Concurrency axis_08 | **9** | `axes/concurrency_axis/axis_08_concurrency_registry.hpp:23` |
| value_handle axis_14 | **5** | `axes/value_handle_axis/axis_14_value_handle_registry.hpp:19` |
| Allocator axis_06 | **26** total (25 enabled) | `axes/alloc/axis_06_allocator_registry.hpp:78-100` |
| node_type axis_04 | **4** | `axes/node/axis_04_node_type_registry.hpp:18` |
| Anatomie-Slots | **19** | `anatomy/composition_factory.hpp:89` `static_assert(sizeof...(Vs)==19)` (harter Anker existiert) |
| Achsen gesamt | **26** | `builder/experiment_tree/registry_to_axis_levels.hpp:46,79` |

**„17"-Disambiguierung:** 17 = alte Such-Algo-Zahl (jetzt 22) UND 17 = SearchAlgorithm-Kern-Slots T0..T16 (bewusste
Teilmenge der 19). Kern-Teilmengen-Nutzung (z. B. `axis_operability_classification.hpp:2`, README.md:95) = KORREKT.

## AUTONOM korrigiert (Increment-Staging)
- **Increment 1 (Zähl-Drift, objektiv):** `lookup/PAPER_REFERENCES.md:39` 17→22 · `concurrency_axis/PAPER_REFERENCES.md:22`
  8→9 · `value_handle_axis/PAPER_REFERENCES.md:7,18` 4→5 · `alloc/PAPER_REFERENCES.md:51` 25→26 · Kommentare `<17>`→`<19>`
  in `genus_binding_traits.hpp:5,14` · `set_composition.hpp:4,61` · `node_value_measurement.hpp:32` ·
  `build_variant_inspection.hpp:8`.
- **Increment 2 (gelöschte Behelfswege, ce-LIVE-Doku):** additive DEPRECATED/SUPERSEDED-Banner + Nachfolger-Verweis
  (`Code/02_messung_driver`/ctest-Targets/`Code/08_appendix_generator`) in `tests/unit/thesis_tiere/README.md`,
  `Code/MANUAL_RUN.md` (Weg A), `docs/anleitung_messwerte_erzeugen.md`, `docs/ERWEITERUNGS-LEITFADEN.md`, `SCHEMA.md`,
  README-Abschnitte + ~21 Test-`Build:`-Kommentare (scratch_compile_*.ps1 → ctest-Target-Vermerk).
- **Increment 3 (Attribution, BELEGT via in-repo PAPER_REFERENCES/family_name):** Wormhole ATC→**EuroSys 2019** ·
  START „Mertens ICDE 2024"→**Fent/Jungmair/Kipf/Neumann ICDEW 2020** · lrmalloc „Cohen/Petrank PPoPP"→**Leite/Rocha
  VECPAR 2018** · snmalloc „Liedtke…"→**Liétar et al.** · 9 Allocator-`vendor_includes/*.hpp:4` `@vendor`-Venues
  (michael PLDI 2004 · scalloc OOPSLA 2015 · numalloc ISMM 2023 · starmalloc OOPSLA 2024 · lrmalloc VECPAR 2018 ·
  cama ECRTS 2011 · hmalloc ICPADS 2019 · pim_malloc HPCA 2026 · exgen IEEE-CAL 2025 · hoard PPoPP→**ASPLOS-IX 2000**) ·
  Kuehn-LeafOnly-Fehlattribution (`axis_11_telemetry_leaf_only.hpp:29` — „Kuehn DaMoN"-Zuschreibung entfernen, Datei
  widerspricht sich selbst Z.16-17).

## DEFERRED an User (heikel/gated) — NICHT autonom
1. **LIZENZ-Labels (Compliance-sensibel):**
   - `algorithm_profiles/allocators/tcmalloc.profile.xml:8` + `README.md:22` + `adapters/A06-tcmalloc/README.md:3`:
     BSD-3 → **Apache-2.0** (belegt via `ext/allocator/A06-tcmalloc/LICENSE`).
   - `algorithm_profiles/allocators/lrmalloc.profile.xml:8` + `README.md:26` + `adapters/A11-lrmalloc/README.md:3`:
     BSD-3 → **MIT** (belegt via `ext/…/lrmalloc/LICENSE` „MIT, Ricardo Leite 2018").
   - `algorithm_profiles/allocators/michael_lockfree.profile.xml:8` + `ext/allocator/REPOS_OVERVIEW.md:13` +
     `allocators/README.md:19`: BSD-3/„MIT permissive" → **LGPL-2.1-or-later** (belegt via `michael.h:5`). **schweres
     Copyleft — Compliance-Nuance: Link-Status prüfen (Shim = DEFERRED/Custom, ggf. nicht gelinkt).**
   - scalloc (5 Doku-Stellen BSD-3, vendored LICENSE = 2-Klausel/BSD-2): **UNSICHER**, Upstream extern verifizieren.
   > **Frage an User:** die belegten (tcmalloc→Apache, lrmalloc→MIT) autonom korrigieren? michael (LGPL) + scalloc
   > erst nach externer Prüfung? Lizenzänderungen sind Compliance-relevant → GO erbeten.
2. **Thesis-`.tex` SUPERSEDED-Notizen (Overleaf-Remote, User-GO):** `anhang/{de,en}/A_measurements.tex:4` Kopf-Kommentar
   (Datei trägt ab Z.66/64 bereits korrekten Vermerk) + 4 `tabellen/*_diagram.tex:1` Auto-Header. → Teil von G8/#1.
3. **„22-Achsen"-SOLL-Dokumente:** `docs/architecture/28_vollstaendigkeits-kartographie.md` (durchgängig 22, explizit
   gepinnt), `26_…:84`, `22_f15…:30`. Bewusster Stand 2026-06-02; jetzt 26 nach 4 node-shape-Achsen. → nur mit
   Bestätigung, ob das SOLL-Dokument auf 26 nachgezogen werden soll oder als datierter Stand bleibt.
4. **Registry-`static_assert`-Anker (Muster-E-Empfehlung, aber TABU-nah):** die 5 axis-Registries pinnen ihre Gesamtzahl
   nur `>0`, kein `==N`. Ein `static_assert(mp_size<AllStrategies>::value==22)` würde künftige Drift beim Bauen fangen
   (Anatomie macht das bei 19 vorbildlich). Berührt aber die Registry-`mp_list`-TABU-Dateien → **User-GO für den
   durablen Anker**.
5. **UNSICHER-Attribution (nie raten):** crystalline (Shim „Solodkyy/Bunkov PLDI 2021" vs. Profil unknown — wirkt
   fabriziert, üblich Nikolaev/Ravindran; kein In-Repo-Beleg) · START-Profil-DOI (PVLDB vs. ICDEW) · q1 „Lopez-Pesch
   ICDE 2024" (paper_found=false, eher Fabrikations-Cluster).

## Historisch/ausgeschlossen (kein Drift)
Datierte `docs/sessions/**` + `backups/**` + Ledger-Einträge (beschreiben Vergangenheit korrekt); `_archiv_entwurf1`;
CMakeLists `:1625-1626` (dokumentiert die Löschung bereits = Korrektur-Muster); `USAGE.md build_thesis.*` (existiert).
