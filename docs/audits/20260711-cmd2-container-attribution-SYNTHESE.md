# CMD-2 / #252 — ContainerObserver E2-Sidecar (host-seitige Container-in-SA-Attribution)

> 2026-07-11. ce `0b790034` (beide Remotes, development+main). Das **letzte Spur-S-Architektur-Item**,
> ABI-neutral gebaut. Deep-Research `wf_d054f1d0` (thesis+code+adversarial) + Impl-Review `wf_be0f3111`
> (2-Lens, 0 Findings). Workflow-Rohdaten: `subagents/workflows/wf_d054f1d0-e34/` + `wf_be0f3111-e10/`.

## Auslöser — Gating-Fehlklassifikation korrigiert (wie #221)
Ledger §3-S6:85 führte CMD-2 als „EINZIGER Bump-Kandidat 4→5, Bump NUR mit User-GO" = user-gated. Das ist
**STALE**: #268-Reserve-Prüfung (Ledger :204, 05.07.) hatte längst VERDIKT **RESERVE-REICHT** ergeben —
CMD-2 im beschlossenen Scope (E2-Sidecar Variante a, User „✅ ENTSCHIEDEN" 02.07.) braucht **0 neue POD-Spalten**,
der 4→5-Bump wird **nicht konsumiert**. → CMD-2 ist **ABI-neutral + non-user-gated**. Zeile 204 markierte S6:85
selbst als nachzuziehen. (Der Goal-Hook hat diese Fehlklassifikation zurecht angemahnt — zweiter Fall nach #221.)

## Thesis-geerdete Semantik (Deep-Research wf_d054f1d0, primärcode-verifiziert)
- **Attribution = „messbar zurechenbar"** (Trennbarkeits-Problem, 07_results_evaluation.tex:44,50): je Achse der
  isolierte Gewichtungsbeitrag, statt im Gesamtdurchsatz vermengt.
- **Store = thesis-kanonisch GENAU T4+T5+T6** (LayoutAwareChunkedStore = Knotentyp+Layout+Allokator,
  02_suchbaeume_grundlagen.tex:374-380); „die Suche T0 läuft über ihn". Die Masterplan-„+T11/T13"-Formel ist
  **Ledger-Erweiterung, NICHT Thesis** (T13 eigene Index-Achse, T11 eigenes Value-Handle).
- **c1/c2/c3 sind KEINE Thesis-Begriffe** (nur Ledger/#268-Bericht). Thesis liefert das PRINZIP (Per-Achsen-Gewicht),
  nicht die drei Etiketten.
- „ContainerObserver real" löst das Doc-24-§5.2-Problem (container_ vom observe_all entkoppelt) — heute per #188-4c
  geheilt (axis_stats[0] aus container_algorithm_.statistics()). Rest = host-seitige Attributions-Etikettierung.

## VERDIKT (geteilt — ehrlich, wie der §B-WURZEL-Null-Consumer-Fall)
- **MECHANIK (Host-Sidecar, reads-only axis_stats, additive CSV-Endspalte, 0 neue POD-Spalten): JA — jetzt buildbar
  + unit-testbar ohne #156.**
- **c1 store_ops = axis_stats[0][0]+[0][3]+[0][4] = lookup+insert+erase: JA.** Doppelzähl-frei (lookup==hit+miss →
  hit/miss ausgeschlossen; peak=Gauge ausgeschlossen; die drei Op-Familien disjunkt, axis_03a_*:95-99).
- **c3 = LABEL** der bereits transportierten Store-Achsen-Spalten (kStoreAxes=T4/T5/T6), **KEINE Skalar-Summe** —
  die mischte Prüfsummen ([4][3]/[5][4]/[13][4]) + Bytes ([6][0..1]) + 4×-dieselbe-container_algorithm_-Traversierung
  (T4.find/T5.scan/T11.access/T13.scan) = **Phantom**.
- **c2 + c3-Skalar: NICHT gebaut = bewusstes Phantom-Nein.** Jede Einzel-Snapshot-Lesart ist dimensionslos-inkohärent
  (c3/c1: Füllstand-Scan / kumulativer Op-Count) oder trivial 1.0. Der echte thesis-„Gewichtungsbeitrag" ist die
  **Sensitivitätsanalyse Reihe B = Cross-Permutation** (06_evaluation_methodology:17-19), NICHT ein Sidecar-Snapshot.
  **User-Gate 11.07. freigegeben — aber eine freigegebene Gate macht ein Phantom nicht real (Anti-Phantom-Doktrin).**

## Geliefert (ce 0b790034)
- NEU `libs/cache_engine/builder/experiment_tree/container_attribution.hpp` (host-only, header-only): `ContainerAttribution{store_ops}` +
  `container_attribution(snapshot)` + static_assert-Index-Freeze auf kV3AxisSchema[0].names[0/3/4] + `kStoreAxes`-Label.
- EDIT `cache_engine_builder_iterator.hpp`: Include + `lazy_csv_header` (+`;container_store_ops`) + `format_csv_row`
  (additive Endspalte, `unified_real`==false→„n/a", Header↔Row identische Reihenfolge).
- NEU `tests/unit/test_cmd2_container_attribution.cpp` (Label goal_v6;phase_d): 5 Fälle inkl. Doppelzähl-Sentinel.
- EDIT `tests/unit/CMakeLists.txt` (COMDARE_GOALV6_LIGHT_DTESTS).

## Verifikation (literal)
Standalone-Smoke g++-16 8/8 OK · offizieller build/ (g++-16) **ctest 204/204 pass** (test_cmd2 1/1) · clang-format-22==0 ·
Mojibake==0 · adversariale 2-Lens-Review (wf_be0f3111, feature-dev:code-reviewer) **0 Findings** · **0 TABU-Dateien
berührt** (git: nur die 4 Increment-Dateien; sizeof==1416/ABI-4/permutation_axes/golden/GenusBindingTraits/ContainerObserver-Count=0
unangetastet) · host-only → DLLs unverändert (ABI-neutral).

## Offen (an den User, ehrlich statt Phantom)
Ein c2/c3-**Skalar** braucht entweder einen modalitäts-gleichen Semantik-Entscheid ODER — thesis-treuer — die
Reihe-B-Cross-Permutations-Maschinerie (perm_runner über permutierte Kompositionen). Kein Snapshot-Sidecar.
