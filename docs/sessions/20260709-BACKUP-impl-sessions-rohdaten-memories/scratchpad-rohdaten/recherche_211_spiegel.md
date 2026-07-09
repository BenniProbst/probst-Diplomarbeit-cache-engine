# RECHERCHE-AUFTRAG (READ-ONLY, KEINE EDITS): #211 — container_-Spiegel: SortedBinary-O(n)-Pflege je Mess-Op raus

Repo: comdare-cache-engine, HEAD `a1f6024`. Zusätzlich Doku-Repo-Wurzel (super): `C:\Users\benja\OneDrive\Desktop\Diplomarbeit - Datenbanken` (dort docs/sessions/ — read-only mitlesen erlaubt). Alle Aussagen MIT file:line. KEINE Code-Änderungen.

## Kontext (fix)
Task #211 = AUDIT-A2 K5c / P4 / M8: „container_ → LinearScan/Append (O(n)-flatten+rebuild je Mess-Op raus)".
Bekannte Wurzel-Formulierung: `abi_adapter.hpp:1630` — „SortedBinary insert_slot_at/erase_slot_at = flatten+rebuild;
trifft über container_ JEDE Komposition". Seit #188-4b/4a gilt: organ-backed Familien (9 Pools + Eytzinger) haben
container_ = natives Organ (authoritativ, KEIN Spiegel mehr); store-traversierbare Such-Methoden
(LinearScan/Interpolation/k-ary/per-K) haben container_ = authoritativ mit IHREM Traversal. Der SortedBinary-
SPIEGEL existiert nur noch für: (a) markerlose Flach-Gruppe (Array256/VectorU8U8/VectorU16U16/Array65535) und
(b) die 11 Reference-Compositions (u64-Hülle als search_algo → beide Traits void → flat + Doppelbuchung).
abi_adapter-Weichen: container_traversal_t :1929-1932 (StoreTraversable ? traversal_for : SortedBinaryTraversal),
flat_container_t :1934-1938, Doppelbuchungs-else-Zweige tier_insert :755-760 / tier_erase :888-894.
GOD-HEADER-REGEL: max EIN offener Increment am abi_adapter — #211 IST dieses Increment (4a ist gelandet).

## Fragen
1. ORIGINAL-BEFUNDE: Lokalisiere und ZITIERE wörtlich die Audit-Befunde K5c, P4 und M8 (Audit-Workflows
   wf_a013b73f + wf_86936298, Auswertungs-/Synthese-Dokumente in docs/sessions/ um 2026-06-14..16, auch
   „Fix-Wellen"-Dokument zu Task #142; ggf. AUDIT-A2-Listen). Was genau fordern sie (Mechanik + Begründung)?
2. IST-KOSTEN-KARTE: Wo GENAU zahlt die Spiegel-Pflege heute im MESS-FENSTER? Je Stelle file:line + Kostenklasse:
   tier_insert/tier_erase-Doppelbuchung (SortedBinary insert_slot_at/erase_slot_at = vector-memmove O(n)),
   tier_clear, CoW-Materialisierung, sonstige. Welche Kompositionen zahlen (exakte Menge; sind die 320
   golden-Tiere betroffen? Die 4 First-Algos sind k_ary/interpolation/eytzinger/linear_scan — k_ary/interpolation/
   linear_scan = StoreTraversable-authoritativ OHNE search_organ_-Doppelbuchung? eytzinger seit 4a organ-backed?
   → zahlt in den 320 ÜBERHAUPT noch jemand die Spiegel-Doppelbuchung? Oder nur Reference-Compositions/
   Docks/Gattungs-Läufe außerhalb der 320?).
3. KONSUMENTEN-MATRIX des Spiegels (für die betroffene Menge): WER liest container_ bei nicht-authoritativen
   Kompositionen? Je Konsument file:line + benötigte EIGENSCHAFT (Sortierung? Duplikatfreiheit? Wert-Aktualität?):
   (a) Storage-Achsen-Observer (organ_observe_* über LayoutAwareChunkedStore), (b) tier_scan (scan_range via
   container_traversal_t), (c) prefetch-descent (descent_slot_for_ = lower_bound-Position!), (d) Key-Ernte
   fill_segment_timing_v3, (e) Memento/CoW (save/rollback), (f) T6-allocator-stats, (g) weitere.
4. ZIEL-OPTIONEN präzise durchdenken (Empfehlung mit Begründung, Option b des Users hier NICHT relevant):
   (A) SortedBinaryTraversal-Fallback in container_traversal_t → LinearScanTraversal (unsortierter Store,
   insert=Duplikat-Scan+Update oder Append, scan_into=O(n)+partial_sort korrekt-geordnet);
   (B) neues minimales Append-/Mirror-Traversal (insert=append ohne Duplikat-Scan? → bricht Wert-Aktualität
   bei Updates — prüfen ob Konsumenten das brauchen);
   (C) etwas anderes, das die Befunde nahelegen. WICHTIG: prefetch-descent nutzt lower_bound auf dem Store —
   bei unsortiertem Spiegel wird descent_slot semantisch anders (welche Stelle, wie schlimm?); tier_scan-Kosten
   wandern von O(log n + len) zu O(n) je Scan-Op (Apparat-Kosten im Scan-Timing? tier_scan wird als seg/Timing
   gemessen? file:line). Und: ändert ein unsortierter Spiegel MESSWERTE der authoritativen search_organ_-Pfade
   (nein? Doppelbuchungs-Insert-Timing ändert sich → tier_insert-Timing der betroffenen Kompositionen!).
5. WECHSELWIRKUNGEN: #226-Appendix-Zeile (super dc6b34a — welche Formulierung? müsste nach #211 angepasst
   werden), #214-GoF-Scan (erledigt — Konsistenz), #216 (seg_ns n>1 + stat-Reset — berührt?), CoW #133
   (cow_materialize_copy_ kopiert container_ — Kostenprofil ändert sich?), 11 Reference-Compositions
   (Konformitäts-/Äquivalenz-Tests die auf SORTIERTEM Spiegel bestehen?), Golden-320-Werte.
6. TEST-/CI-ANKER: bestehende Tests, die den Spiegel-Pfad abdecken (test_conformance_gate? tier150?
   Äquivalenz-Tests?); wo müsste ein #211-Beweis-Test ansetzen (Timing-frei: Semantik-Konformität +
   ggf. Op-Zähler-Beweis, dass der Spiegel keine O(n)-memmove-Pflege mehr macht)?

## Output
Strukturierter Bericht entlang 1-6, jede Aussage mit file:line; Empfehlung als klarer Vorschlag;
am Ende „OFFENE FRAGEN/UNSICHERHEITEN". Auf Deutsch.
