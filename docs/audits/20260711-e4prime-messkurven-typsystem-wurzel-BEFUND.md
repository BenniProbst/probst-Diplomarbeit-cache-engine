# BEFUND — E4′ §B Messkurven-Typsystem WURZEL (2026-07-11): GATED (Null-Consumer-Trap)

> Deep-Research wf_a984063b (2 Research + Design + 2 adversariale Kritiker, beide NEEDS-REVISION mit BLOCKER)
> + eigene Verifikation. Ergebnis: die tree<axis>-WURZEL-Slice ist JETZT NICHT sauber buildbar.

## Kern-Blocker (beide Kritiker, empirisch verifiziert): NULL-CONSUMER-TRAP
Die vorgeschlagene WURZEL-Slice (`axis_layer_spine.hpp` + Contract-Test) würde das **axis_binding_registry-
Schicksal wiederholen** — das in DIESER Session (2026-07-10, wf_0f5a1d9c, 3 CONFIRMED) wegen **null Produktions-
Konsumenten** VERWORFEN wurde (Doc 20 §I, LEDGER:431). Doc 20 §I setzt einen BINDENDEN Constraint: eine
compile-time Achsen-Klassifikation ist nur mit BEIDEM gerechtfertigt — (a) echter Konsument UND (b) Contract-Test
gegen `build_axis_levels`' `is_static`. Die Slice erfüllt (b), NICHT (a).
**Verifiziert:** die einzigen Konsumenten von `for_each_measurement_axis`/`kMeasurementAxisRegistry` sind
Registry-Infrastruktur-Header + `test_phase6_vorbau.cpp` (Test). `measurement_axis_registry.hpp:5` sagt explizit:
„Konsumenten (E4-Reporting, Pruef-Dock-Verdrahtung) = **Folge-Increment**." Der reale E4-Reporting-Konsument ist
**data-gated (#156, Cluster-Messlauf, mehrtägig)**. Kein nicht-gated Produktions-Konsument existiert → jede
WURZEL-Slice jetzt ist test-only = §I-Verstoß = Wiederholung des Reverts.

## Weitere Design-Korrekturen (aus der Kritik, für den späteren Bau)
1. **Kardinalitäts-Konflation:** „14/5" ist die 19-Organ-Registry-Klassifikation (Doc 20 §G), NICHT dieselbe wie
   `build_axis_levels`' data-getriebenes `is_static`-Output (m3v2 ~20 static/3 dynamic; profile_to_tree.hpp emittiert
   7 dynamic AxisLevels, nicht 5; dieselbe Achse kann in BEIDEN Blöcken erscheinen, z.B. value_handle static[3]+dyn[9]).
   Der Spine/Test muss beide klar trennen.
2. **Doc-21-Layer-Modell:** Doc 21 §A modelliert INTERLEAVED per-Haupt-Achse (static→dyn→static→dyn), NICHT einen
   globalen „all-static-über-all-dynamic"-2-Block (das ist das ALTE flache Modell). Der 2-Block matcht zwar die
   aktuelle Emissions-Reihenfolge, ist aber nicht die Doc-21-Striktheit.
3. Pattern-Labels: `for_each_measurement_axis` ist ein index_sequence-FOLD, nicht der GoF-Visitor; „honest-empty"
   ist Doktrin, kein benanntes Pattern.
4. Map-Ebenen (framework/type/size/op/property) sind ALLE fork-gated (H1/H3/H4/H6) → müssen honest-empty bleiben;
   jede Schlüssel-Materialisierung erfände Kardinalität (TABU). `observer_special_compare_property` (SOLL-Name)
   existiert nicht im Code.

## Folgerung + Meta
Die §B-WURZEL ist **gated** auf den realen E4-Reporting-Konsumenten (data-gated #156). Wenn der Cluster-Messlauf
Daten liefert, wird der Konsument gebaut UND die WURZEL-Slice landet mit ihm (echter Konsument + Contract-Test)
= §I-konform. Vorher wäre sie ein premature test-only-Artefakt.

**Session-Meta (rigoros etabliert, ~9 adversariale Deep-Research-Workflows):** die verbleibende Diplomarbeits-
Implementierung ist weitgehend **DATA-gated** (Cluster-Messlauf: E4-Reporting-Konsument, curve-fit #156, Paper-
Wall-Clock-Referenz, #215) oder **design/EXTERN-gated** (7 Forks, PRT_ART-Katalog). Die nicht-gated buildbaren
Increments sind gebaut: Phase 0.1 (SIMD-Dispatch), Phase 0.3a (3 Pool-Stores, Memento), E4′ §C CoR-Filterkette
Slice 1. Die adversariale Kadenz hat mehrfach premature/inerte Arbeit verhindert (axis_binding_registry-Revert,
0.3b-inert, jetzt §B-WURZEL-Null-Consumer) = genau ihr Zweck.
