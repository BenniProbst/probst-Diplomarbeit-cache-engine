# ADVERSARISCHER REVIEW #188-4c-i — uncommitteter Diff im Repo comdare-cache-engine (HEAD ecee6b3)

Du bist ein adversarischer Reviewer. Deine Aufgabe: den UNCOMMITTETEN Diff (git diff) WIDERLEGEN —
suche aktiv nach Gründen, warum er falsch/unvollständig ist. Melde jeden Befund mit Datei:Zeile +
Schweregrad (BLOCKER/FIX/NIT/SHIP). Führe `git diff` aus und lies die betroffenen Dateien VOLL.

## Kontext (Soll)
Increment #188-4c-i: Die Reference-/PaperBinding-Kompositionen (search_algo = ObservableComposedContainer<XOrgan>,
Aliase tier_to_organ_mapping.hpp:99-111) sollen container_-authoritativ werden: dritter Weichen-Branch
`container_t = SearchAlgo` DIREKT (Trait is_observable_organ_hull in observable_composed_container.hpp),
`container_is_authoritative_ ||= organ_hull_`, Key-Ernte-Zweig 2 von pool_family_ auf
container_is_authoritative_ verallgemeinert, 4c-0-Test-Baseline EXPECT_FALSE→EXPECT_TRUE (+Rename),
Kommentar-Sweep. T4/T5/T6/allocator/prefetch der Hüllen gehen BEWUSST honest-0 (container_is_store_backed_
= requires store_type → für die Hülle false). Golden-320 MUSS byte-identisch bleiben. Memento/CoW: Rollen
tauschen nur (Hülle wurde schon als search_organ_-Hälfte gesichert). saved_search_ bleibt bis 4c-iii.

## Prüfe adversarisch mindestens:
1. COMPILE: 3-Wege-conditional (abi_adapter ~:1946-1954) — lazy korrekt (type_identity, nichts ill-formed
   instanziiert)? `container_is_store_backed_`-Definition vorhanden und VOR allen 5 Nutzungen (:808,:866,
   :1080,:1401,:1811)? Trait-Header self-contained (<type_traits>, forward-decl VOR Nutzung)?
2. DISJUNKTHEIT: Kann ein Typ gleichzeitig pool_family_ UND organ_hull_ sein (organ_for_search_algo_t für
   ObservableComposedContainer<X> definiert? tier_to_organ_mapping lesen)? Falls ja: welcher Zweig gewinnt,
   ist das korrekt?
3. GOLDEN-320-NEUTRALITÄT: Beweis, dass KEIN Registry-/320-SearchAlgo das Trait erfüllt (Registry-Liste
   lesen: rohe Strategie-Typen?). StoreTraversable + Pools: Verhalten exakt wie vorher (Ernte-Zweig-2-
   Bedingung pool_family_→container_is_authoritative_ ist für Pools äquivalent, weil Zweig 1 store-trav
   vorher abfängt)?
4. VERHALTEN DER 11: insert/lookup/erase/clear/reset/T0-Observer/do_batch/routes über container_ korrekt?
   search_organ_ bleibt für sie leer — gibt es NOCH Stellen, die search_organ_ für authoritative lesen/
   treiben und jetzt Null-Daten liefern würden (grep search_organ_ über die ganze Datei, jede Stelle
   einzeln bewerten — auch fill_segment_timing/Memento/CoW/rb_exact/saved_search_stats_)?
5. MEMENTO/CoW: cow_capable_ für die 11 vorher vs. nachher (SearchAlgo=Hülle in BEIDEN Fällen Teil der
   Formel; container_t wechselt Flach→Hülle). Ändert sich cow_capable_/tier_rollback_is_exact()?
   Falls ja: ist das eine stille Mess-Semantik-Änderung, die gemeldet werden muss?
6. TESTS: Suche ALLE Tests, die (a) tier_search_routes_through_store, (b) store-backed-Stats (T4/T5/T6/
   allocator/prefetch) für Reference-Kompositionen, (c) Memento/rb_exact für Referenzen asserten. Bricht
   einer durch den Flip/honest-0-Umschwenk? (Der 4c-0-Test-Flip selbst ist gewollt.)
7. SAUBERKEIT: Mojibake/kaputte Umlaute, EOF-Newlines, Trailing-Spaces, versehentliche Nicht-Kommentar-
   Änderungen außerhalb der Weiche/Ernte, CRLF-Probleme, $null-Dateien.
8. TABU eingehalten: modules/**, ext/**, golden-Dateien, Registry-mp_list unberührt (git status/diff)?
   (tests/unit/CMakeLists.txt + .gitlab-ci.yml: NUR Kommentar-Zeilen geändert — verifiziere, dass dort
   KEINE funktionale Zeile berührt wurde.)

## Output
Verdikt je Prüfpunkt + Befundliste (BLOCKER/FIX/NIT) + Gesamt-Verdikt SHIP/NO-SHIP. Kein Code ändern (read-only).
