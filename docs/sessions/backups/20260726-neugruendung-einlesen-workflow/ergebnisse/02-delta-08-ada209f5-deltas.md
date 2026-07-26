## Eintrag 1

**kategorie:** user_direktive

**was:** Stehende Stop-Hook-Direktive (User-konfiguriert): bei GO-pflichtig erscheinenden Architektur-Punkten NICHT auf User-Input blockieren, sondern - wenn eine Achsen-/Tier-Eigenschaft gefordert aber unbenannt ist - per Deep-Research im Thesis-Sinn auflösen und INNERHALB der gesetzten Grenzen fertigstellen; sichtbare TODO-Liste als Stack behandeln, gefundene Probleme sofort oben auflegen; zuerst konzeptionelle Grundlage sauber machen. Der Hook hat das Warten auf GO ausdrücklich als 'Halt auf Input, nicht Condition-Erfüllung' gerügt. Das Dossier kennt nur die Gegenrichtung ('Task-Zuweisung ist KEIN Start-Signal; Start-Gates respektieren') und nennt diese Autonomie-Klausel nicht.

**beleg:** verlauf-08.txt:351

## Eintrag 2

**kategorie:** fakt

**was:** Empirisch am golden-Katalog verifiziert: golden-320 trägt fuer ALLE 320 Binaries allocator=std_malloc (Allocator-Achse ist single-valued, wird gar nicht permutiert), isa fix, und search_algo ist nur {eytzinger, interpolation, k_ary, linear_scan} - also NULL Pool-Familien im Katalog. Die fehlende Allocator-Differenzierung ist eine KATALOG-Entscheidung, keine Wiring-Luecke; der Produktions-Flat-Store LayoutAwareChunkedStore fädelt Composition::allocator bereits (abi_adapter.hpp:2008-2009). Fehlt im Dossier, ist aber fuer den neuen golden (2^17) und die Achsen-Neuordnung tragend.

**beleg:** verlauf-08.txt:608

## Eintrag 3

**kategorie:** offener_faden

**was:** Hebel B / Phase 0.3: nur 3 von 10 Pool-Stores (BST/btree/surf = 'Group A') sind auf die echte axis_06-Strategie umgestellt. Group B (hash, swiss, skip_list, art, hot, wormhole, start) ist NICHT uniform konvertierbar (nested-Container-Skalierungsgrenze: SkipList-Node hält selbst std::vector, wormhole eine std::map, art 10 Vektoren - ein stateful StdAllocatorAdapter komponiert nicht mit default-konstruierten knoten-eigenen Containern); Eytzinger-Layout-Store und der deferred Masstree-Store haben ueberhaupt keinen Alloc-Param. Folge-Slice 0.3b (Tier-Level-Threading via organ_for_search_algo<S,Alloc>) wurde als INERT fuer den aktuellen Katalog + Hash/SkipList-Shape-Drop-Landmine bewertet und auf EXTERN_GATED (PRT_ART-/extension-Schicht, je-Repo-GO) gesetzt. Steht in keinem Dossier-Board-Punkt.

**beleg:** verlauf-08.txt:635

## Eintrag 4

**kategorie:** fakt

**was:** Zwei-Phasen-Mess-/COW-Protokoll (belegt, entscheidend fuer jede Store-Aenderung): T6 wird ABSOLUT/kumulativ gelesen (abi_adapter.hpp:1150 + 1160-1167, keine Delta-/Baseline-Bildung, tier_observe einmal am Phasenende); cow_capable_ (abi_adapter.hpp:2154-2157) verlangt restore_statistics + is_copy_constructible + is_copy_assignable, und cow_materialize_copy_ (:2176) ist NICHT if-constexpr-guarded -> der Store MUSS compile-time copy-konstruierbar sein (Copy/Move löschen = Bruch); restore_statistics (:1768) restauriert NUR den Observer-POD SearchAlgoStatistics, nie die AllocationStatistics. Loesung war Memento (GoF): Copy/Assign verwerfen die COW-Kopier-Pollution via allocator_.restore_statistics(src.statistics()) unter #ifdef COMDARE_CE_ENABLE_STATISTICS.

**beleg:** verlauf-08.txt:373

## Eintrag 5

**kategorie:** fakt

**was:** Mess-Semantik-Fallen, die im Dossier-Fallen-Katalog (a)-(f) fehlen: (1) cache_line_size() in den memory_layouts ist INTRINSISCHE Layout-Semantik (packed_bitmap=8, aos_strict=1, sonst 64), kein HW-Deskriptor - aus axis_12 gespeist wuerde die Bedeutung zerstoert; axis_12 fliesst bereits korrekt via build_variant_definition.hpp:66 in die Binary. (2) Die *_scan-Kerne sind bewusst STRIDED Mess-Kerne (aligned_stride = round_up(record_size,64)); ihr Cache-Line-Touch-Muster IST das Mess-Signal der Layout-Achse - SIMD-Vektorisierung wuerde es korrumpieren. (3) live_nodes ist eine Container-Eigenschaft, keine Allocator-Stat (war im alten Store-Snapshot fehlkonflatiert; jetzt aus occupied_count() bzw. pool_node_count() gespeist).

**beleg:** verlauf-08.txt:292

## Eintrag 6

**kategorie:** offener_faden

**was:** Nie beantwortete Owner-Fragen F-B/F-C aus der Phase-0.2-Strecke: (a) NUMA/Page->allocator-Neuverdrahtung (numa_capable -> NUMA-Policy, page_size/huge -> Huge-Page-Pools/dTLB) - thesis-motiviert, aber nicht mandatiert, GO-pflichtig geparkt; (b) Cacheline-Werteset-Widerspruch Code {B64,B128,B256} vs. Thesis KF-5 {32,64,128}, plus der Befund, dass Line-GROESSE und Knoten-BREITE-in-Lines (Literatur-Kontroverse FF2: 1 vs. 16 Cache-Lines) vermutlich ZWEI getrennte Unter-Achsen sind und der Sweep-Knopf ungeklaert ist - beruehrt golden-TABU. Beides fehlt im Dossier-Board und in der Achsen-Neuordnung R-A..R-F.

**beleg:** verlauf-08.txt:24
