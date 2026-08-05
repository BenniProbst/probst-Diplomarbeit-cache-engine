# LENS befunde — Voll-Detail der 4 Mess-Vorfeld-Entscheide (Posten 74 / 77 / 78 / KF-6)

Erhoben 05.08.2026, read-only am Objekt `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine` (im Folgenden `ce/`) und an Ledger + docs/sessions (im Folgenden `super/`). Alle Zeilennummern am heutigen Ist-Stand selbst nachgelesen, nichts aus Berichten uebernommen ohne Gegenlesen am Code.

---

## BEFUND 1 — POSTEN 74: OOM-Roh-Route im LayoutAwareChunkedStore (Wurf-Vertrag fehlt am Strategie-Roh-Pfad)

### Sachlage (technisch, am Objekt)
Der LayoutAwareChunkedStore (node_type-Achse, axis_04) bezieht seit dem 02a-HERZ-Schnitt BEIDE Speicher-Ebenen aus dem Kompositions-Allokator `A`. Dabei existieren zwei ungleich behandelte OOM-Pfade:

1. **Record-Bytes (ROH-Pfad, UNGESCHUETZT):** `ce/libs/cache_engine/axes/node/axis_04_node_type_layout_aware_store.hpp`
   - `:269` `c.data = static_cast<unsigned char*>(alloc_.allocate(c.capacity, kChunkAlign));` — Rueckgabe UNGEPRUEFT
   - `:270` `std::memset(c.data, 0, c.capacity);` — bei Strategie-OOM (nullptr) ist das der UB-Pfad (memset auf nullptr)
   - Der Doku-Block `:257-264` deklariert den Zustand selbst ehrlich: "die Strategie meldet OOM per nullptr, den der Store hier UNGEPRUEFT weiterreicht (memset auf nullptr = der vorbestehende UB-Pfad dieser Zeile)".
   - Gleiches Muster in `copy_from_` `:631` (`alloc_.allocate` ungeprueft) + `:632` (`std::memcpy(c.data, oc.data, ...)`).
2. **Chunk-INDEX (GEHAERTET, Posten-64-Klasse):** Das Index-Wachstum laeuft ueber den `StdAllocatorAdapter`, und dort uebersetzt Posten 64 den Strategie-nullptr an EINER Stelle in `std::bad_alloc`: `ce/libs/cache_engine/axes/alloc/axis_06_allocator_strategy_base.hpp:222-224` (`if (p == nullptr && n != 0) throw std::bad_alloc{};` — der C++23-[allocator.requirements]-Wurf-Vertrag; failure_count wird VOR dem Wurf gezaehlt, `:205`).

**Kopier-Ctor-Leck-Nuance (Review B5):** Der Copy-Ctor `:215-217` (`LayoutAwareChunkedStore(LayoutAwareChunkedStore const& o) : chunks_(...) { copy_from_(o); }`) ruft `copy_from_` `:626-640`. Wirft dort `chunks_.push_back(c)` (`:634`) ueber den geharteten Adapter `std::bad_alloc` MITTEN in der Schleife, laeuft der Destruktor des halbkonstruierten Objekts NICHT — die bereits ueber `alloc_.allocate` gezogenen Chunk-Datenbloecke (inkl. des aktuellen, noch nicht gepushten `c.data`) lecken. Zusaetzlich gilt im Zuweisungs-Pfad `:219-232` dieselbe Nuance nach `alloc_ = A{}` (`:229`).

Die Roh-Route ist also NICHT die vom StdAllocatorAdapter geschlossene UB-Flaeche: Posten 64 hat den Adapter-Weg geschlossen (Ledger abend-12, Gate 388->389), die direkte `alloc_.allocate`-Nutzung in `append_slot`/`copy_from_` blieb bewusst offen und deklariert ("gehoert dem alloc-/A15-Strang", `:260-261`).

### Entstehung
- **Erst-Fundstelle:** `super/docs/sessions/backups/20260804-s5-02a-welle/ergebnis-roh.json:43` (Report, "VORBESTEHENDER UB-PFAD ... append_slot memsetzt den Rueckgabewert von alloc_.allocate UNGEPRUEFT") und `:58` (Review-Befund B5, Kopier-Ctor-Leck-Nuance).
- **Ledger:** `super/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:3946` (NACHTRAG 04.08. abend-13, Par.75-Kandidat (74): "gleiche Entscheid-Klasse wie (64), VOR Messbeginn").
- **Referenz-Klasse Posten 64:** Ledger:3936 (abend-12, HAERTUNG GELANDET: "StdAllocatorAdapter uebersetzt Strategie-nullptr in std::bad_alloc (UB-Pfad geschlossen fuer ALLE Form-B-Organe + 4 Pool-Stores + composed_store ...)").

### Konsequenz fuers MESSBILD
- Betroffene Zellen: **node_type=layout_aware x allocator=beliebig**, verschaerft bei budget-/OOM-faehigen Strategien (der Treiber-Kommentar `ce/libs/cache_engine/anatomy/abi_adapter.hpp:465-467` benennt selbst: "Alloc-Achsen (z.B. numalloc) liefern bei OOM nullptr OHNE throw"; der Store fuehrt zudem `runtime_pool_budget_rejections_` `:654` — Pool-Budget-Ablehnungen sind ein realer Laufzeit-Fall). Quer dazu alle memory_layout-Repraesentationen (der Store ist der Traeger der 5 Layout-Reps).
- Wirkung: Ein OOM waehrend eines Messlaufs erzeugte statt einer sauberen `failed`-CSV-Zeile (Mess-Kanon: Fehler->CSV 'failed', nicht null) einen **SIGSEGV/UB im Messprozess** — im schlimmsten Fall reisst EINE Zelle den ganzen Mess-Job (und damit die Nachbar-Zellen desselben Laufs) mit. Verfaelschung zweiter Ordnung: die Leck-Nuance verfaelscht bei ueberlebtem bad_alloc die Allocator-Statistik-Spalten (alloc_cnt/dealloc-Asymmetrie ohne echtes Leck im Messgegenstand).
- Am golden-Ist (N=2^17, Budgets weit oberhalb) wird der Pfad nicht getroffen — das Risiko ist ausschliesslich die Mess-Matrix mit knappen Budget-/NUMA-Zellen.

### Optionen
- **(A) Wurf-Vertrag nachziehen (Posten-64-Klasse):** In `append_slot` und `copy_from_` nullptr pruefen -> `throw std::bad_alloc{}` (Fehlerklasse FK-5-Boden der Allokator-Achse, wie am Adapter), in `copy_from_` zusaetzlich exception-sicher bereits gezogene Chunks freigeben (try/catch mit `free_chunks_()`-Rueckbau oder Guard). Lokal, klein, golden-neutral (Pfad feuert am Ist nie), Negativ-TU nach test_h64-Vorbild moeglich.
- **(B) Deklarieren statt heilen:** Befund als bekannte Grenze in die Mess-Dossier-Notizen; Mess-XML so schneiden, dass budget-knappe allocator-Zellen nicht mit layout_aware kombiniert werden. Kein Code-Risiko vor dem Anker, aber eine stille Vertrags-Luecke im Messfenster und ein Kanon-Konflikt (Fehler muessen als 'failed' sichtbar werden koennen).
- **(C) Nichts tun:** verletzt die eigene Deklaration ("VOR Messbeginn") und den Fehlerklassen-Pflicht-Kanon.

### Empfehlung
**Option A vor Messbeginn** — exakt die Entscheid-Klasse von Posten 64, mit derselben, bereits gelandeten Begruendungs- und Test-Schablone (test_h64/GEGENPROBE-BISS). Aufwand ist eine kleine Scheibe (2 Funktionen, 1 Negativ-TU); sie schliesst den letzten bekannten UB-OOM-Pfad des Mess-Traegers. Falls das Vor-Anker-Kalenderfenster es nicht traegt: Option B mit expliziter Budget-Headroom-Deklaration im Mess-Dossier, und Posten bleibt offen markiert.

---

## BEFUND 2 — POSTEN 77: kReal16-Suffix kollabiert auf kurzen Keys auf kNone-Verhalten (SuRF, papertreu — Mess-Interpretations-Frage)

### Sachlage (technisch: WELCHE Konfiguration kollabiert WIE)
Betroffen ist das composable SuRF-Organ mit Real-Suffix-Tuning: `ComposedSurfLoudsFilter<SurfSuffixType::kReal, 0, 16>` ("S2R16"; Typaliase z.B. `ce/tests/unit/test_s5_02b_filter_perf_sanity.cpp:342`, `ce/tests/unit/test_v41_axis_filter_surf_louds_organ.cpp:26`).

Mechanik am Objekt `ce/libs/cache_engine/axes/filter_axis/composable/surf_suffix_bits.hpp`:
- `:93-94` `construct_real`: `if (level > 8U || (8U - level) * 8U < RealLen) return 0;` — reicht der Key unterhalb des Trie-Leaf-Levels nicht mehr fuer RealLen Bits, wird als Suffix **0** gespeichert.
- `:174-176` `check_equality` (kReal): `if (stored == 0) return true;` — Suffix 0 heisst "keine Suffix-Info", der Check ist IMMER wahr.

Kollaps-Bedingung: **RealLen > (8 - leaf_level) * 8**. Key-Satz A des 02b-Kontrasts (dichte Integer < 100000, big-endian in 8 Bytes -> Leaf-Level 7, Rest 8 Bit) ergibt literal:
- S2R4 (RealLen=4): 8 >= 4 -> diskriminiert teilweise, pos=4820
- S2R8 (RealLen=8): 8 >= 8 -> voll wirksam, pos=800 (= S1)
- S2R16 (RealLen=16): 8 < 16 -> ALLE Suffixe 0 -> **pos=24164, point_fnv=18b06d3f1727b31d IDENTISCH zu S2None (kNone)**, obwohl bits 11272->24072 und bpk 14.09->30.09 steigen.
- FP-Monotonie auf Satz A GEBROCHEN (R8 besser als R16); auf Satz B (flache Blatt-Keys) haelt sie: 172285 > 20266 > 669 > 2.
- Der Bestandstest `SurfLoudsFilter.FalsePositiveMonotoneTunable` (`ce/tests/unit/test_v41_axis_filter_surf_louds_organ.cpp:75-105`) prueft NUR `build_shallow_keys` (`:36`) und faengt den Fall darum nicht.

**Faithful-Einordnung (verifiziert):** Das ist KEIN Adaptions-Bug, sondern exakt die Original-SuRF-Semantik. Vendored Original `ce/ext/traversal/P10-SuRF/SuRF/include/suffix.hpp`:
- `constructRealSuffix` `:43-46`: `if (key.length() < level || ((key.length() - level) * 8) < len) return 0;`
- `checkEquality` `:216-219`: `// if no suffix info for the stored key` -> `if (stored_suffix == 0) return true;`
Der 02b-Papertreue-Beleg (Membership ALT==NEU BIT-IDENTISCH ueber 272.961 Antworten) pinnt zusaetzlich: kein 02b-Regress, in ALT und NEU zeichengleich. `ext/` ist unberuehrt.

### Entstehung
- **Erst-Fundstelle:** `super/docs/sessions/backups/20260805-s5-02b-welle/ergebnis-roh.json:75` (Report-offene_punkte, "BEFUND (neu, aus meinem Kontrast-Lauf, VORBESTEHEND...") + `:87` (Review, unabhaengig bestaetigt, bit-identisch alt==neu).
- **Ledger:** `super/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:3959` (NACHTRAG 05.08. nacht-1, S5-02b GELANDET: "(77) kReal16-Suffix kollabiert auf kurzen Keys auf kNone-Verhalten ... Mess-Interpretations-Frage").

### Konsequenz fuers MESSBILD
- Betroffene Zellen: filter-Studien ueber die **composable SuRF-Organe** mit Real-Suffix-Tuning (S2/kReal16, generell kReal mit RealLen > Rest-Bits der Key-Verteilung). WICHTIG zur Einordnung: die composable Organe liegen NICHT im T14-Mess-Pfad der Kompositions-filter-Achse (deklariert in `ce/tests/unit/test_s5_02b_filter_perf_sanity.cpp:34-38`); betroffen sind die SuRF-Tuning-Kurven (FP-Rate vs. bits_per_key), nicht die T14-Spalten.
- Wirkung: Auf kurzen/dichten Integer-Keys zahlt die kReal16-Zelle **16 Bit je Key ohne jede FP-Reduktion** — die FP-vs-bpk-Kurve wird nicht-monoton (R8 dominiert R16). Wer die Kurve ohne Key-Verteilungs-Kontext liest, haelt das fuer einen Messfehler oder einen Bug; tatsaechlich ist es eine ECHTE, papertreue Eigenschaft von SuRF-Real-Suffixen auf dieser Key-Verteilung (und damit thesis-tauglicher Befund, kein Artefakt).
- Verfaelschungs-Risiko nur bei Heuristik-Ableitung: eine automatische Min/Max-Heuristik ueber die Kurve wuerde kReal16 als strikt dominiert verwerfen — korrekt fuer Satz-A-Verteilungen, falsch verallgemeinert fuer lange Keys.

### Optionen
- **(A) Behalten + Interpretations-Regel festschreiben (papertreu):** Code unangetastet; im Mess-Dossier/Thesis-Text die Kollaps-Bedingung (RealLen vs. Rest-Bits) als Lese-Regel der Kurven dokumentieren; Key-Saetze der Mess-XML bewusst waehlen (kurze UND lange Keys als getrennte Zellen).
- **(B) Test-Haertung zusaetzlich:** FalsePositiveMonotoneTunable um einen Deep-Key-Satz erweitern, der den Kollaps als GEPINNTES Verhalten dokumentiert (nach dem Muster der 02b-Xor-Wache: faellt, wenn sich die Semantik aendert).
- **(C) Semantik aendern (z.B. Rest-Bits speichern):** verletzt die Papertreue-Doktrin, risse den 02b-Bit-Identitaets-Beleg und die Membership-Wachen — ausgeschlossen vor Abgabe.

### Empfehlung
**Option A, ergaenzt um B als billige Wache.** Kein Code-Eingriff am Filter (faithful-Doktrin; das Original verhaelt sich identisch). Der Entscheid "VOR Messbeginn" ist hier ein reiner INTERPRETATIONS-Entscheid: Kollaps-Bedingung als Fussnote an die betroffenen Kurven, Key-Satz-Wahl in der Mess-XML explizit machen. Das ist in Minuten leistbar und kalender-ehrlich.

---

## BEFUND 3 — POSTEN 78: XorFilter meldet 30/256 gespeicherte Keys als nicht enthalten (ECHTE false negatives — Befund liegt in der ADAPTION, nicht im vendored Original)

### Sachlage (technisch)
Objekt: `ce/libs/cache_engine/axes/filter_axis/axis_filter_xor.hpp` (Kompositions-filter-Achse, Registry-Strategie, family_id 4).
- `:65-68` `insert_key`: loest NUR den dritten Slot — `table_[h2_(key)] = fp ^ table_[h0_(key)] ^ table_[h1_(key)]`. Es gibt KEIN Peeling: kollidieren zwei Keys auf demselben h2-Slot (4096 Slots je Drittel, `:48`), ueberschreibt der spaetere Key den geloesten Slot des frueheren — dessen Xor-Invariante bricht -> echter false negative bei `probe_key` (`:71-74`).
- Der Header deklariert das SELBST als bewusste Vereinfachung: `:43-46` "LEICHTGEWICHTIGE XOR-Konstruktion OHNE das vollstaendige Peeling/3-Hypergraph-Matching des Original-Xor-Filters — ehrlich deklariert: bei h2-Kollisionen ueberschreibt ein spaeterer Key den geloesten Slot eines frueheren (mogliche FN; bewusste Apparat-Vereinfachung. Der rigorose Membership-Beleg laeuft ueber Bloom/Cuckoo)".
- Messwert am Ist: T14-Zustands-Scan (256 gespeicherte Keys, Treiber `ce/libs/cache_engine/anatomy/abi_adapter.hpp:1475-1479` store_observe_filter): **pos=226, neg=30** — 30 echte FN, ~11.7% der gespeicherten Keys.
- Die 02b-Wache pinnt BEIDE Seiten: `ce/tests/unit/test_s5_02b_filter_perf_sanity.cpp:273-275` (neg==0 fuer RangeSurf/Bloom/Cuckoo = no-FN-Zusage der Achse) und `:276-279` ("BEFUND GEPINNT ... XorFilter meldet false negatives -- faellt diese Zeile, ist der Befund geheilt und der Kommentar oben nachzuziehen", `xorf.axis_stats[kAxisFilter][2] > 0`).

**Faithful-Frage BEANTWORTET (verifiziert am ext/-Baum):** Unter `ce/ext/` existiert KEIN vendored fastfilter_cpp/Xor-Original (Suche ueber ext/: nur xoroshiro.h [snmalloc-Test] und boost-mpl-bitxor-Praeprozessor-Dateien — nichts Filter-bezogenes). `axis_filter_xor.hpp` ist eine CE-NATIVE, paper-referenzierte Reimplementierung (Kopf `:2-11`: Graf/Lemire 2020, DOI 10.1145/3376122, Verweis auf fastfilter_cpp als Quelle — aber nicht vendored). **Der FN-Befund ist also ein bewusst deklarierter Abstrich der ADAPTION; die faithful-Doktrin (ext/ unantastbar) ist nicht beruehrt.** Der Original-Algorithmus (offline ueber den VOLLSTAENDIGEN Key-Satz gepeelt) ist per Konstruktion FN-frei — ein inkrementelles insert_key KANN die Xor-Invariante prinzipiell nicht erhalten (so auch der Wachen-Kommentar `:266-272`).

### Entstehung
- **Erst-Fundstelle:** `super/docs/sessions/backups/20260805-s5-02b-welle/ergebnis-roh.json:76` (Report-offene_punkte) + `:88` (Review, im eigenen Lauf gesehen; "Gehoert vor Messbeginn entschieden (offline gepeelter Xor vs. inkrementelles insert_key)").
- **Ledger:** `super/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:3959` (nacht-1: "(78) XorFilter 30/256 FALSE NEGATIVES (echte FN einer Membership-Struktur! axis_filter_xor nicht im Diff; Wache faellt bei Heilung)").
- Historischer Kontext der Vereinfachung: Header `:40` datiert die reale Fingerprint-Tabelle auf P5 (#124, 2026-06-04, User §4.3).

### Konsequenz fuers MESSBILD
- Betroffene Zellen: **filter=xor auf der Kompositions-filter-Achse (T14)** — im Gegensatz zu Posten 77 liegt das DIREKT im Mess-Pfad (T14-Spalten probe/pos/neg/hash_probes/checksum).
- Wirkung: (a) Die pos/neg-Spalten der xor-Zelle beantworten einen ANDEREN Vertrag als Bloom/Cuckoo/RangeSurf — der Filter-Vertrag der Achse (FP erlaubt, FN verboten) ist verletzt; jede aus pos/neg abgeleitete Groesse (Hit-Rate, Effektivitaet) ist fuer xor nicht vertrags-vergleichbar. (b) Wuerde je ein Workload den Filter STEUERND nutzen (Store-Zugriff bei negativ ueberspringen), lieferte die xor-Zelle inhaltlich falsche Ergebnisse (verpasste Treffer). (c) Die ZEIT-/Multiplizitaets-Messung (3 Slot-Reads branch-frei, probe_multiplicity=3, `:77-78`) bleibt dagegen papertreu und vergleichbar — der Probe-Pfad ist strukturgetreu Graf+Lemire §3.
- Nicht-Entscheid = stille Verfaelschung: die xor-Zeile stuende gleichberechtigt neben den FN-freien Filtern in derselben CSV.

### Optionen
- **(A) Heilen — Offline-Peeling nachruesten:** Build-Op ist deklariert "Setup, NICHT gemessen" (`:64`), d.h. eine echte Peeling-Konstruktion (Keys sammeln, am Ende peelen) waere MESS-NEUTRAL fuer den Probe-Pfad und stellte den Membership-Vertrag her. Kosten: neuer Build-Zustand (Key-Puffer = Heap im bisher heap-freien Organ -> beruehrt die 02b-Schlussbilanz "Kompositions-filter-Achse heap-frei" und die T6-Doppelzaehlungs-Regel), Wache `:276-279` MUSS gedreht werden (sie ist genau dafuer gebaut), Kommentar-Nachzug, neue TU. Keine golden-Beruehrung (filter liegt nicht in den golden-320-IDs), aber eine echte Bau-Scheibe in der knappsten Kalenderphase.
- **(B) Behalten + deklarieren (der Header-Weg):** xor bleibt die leichtgewichtige Apparat-Strategie; im Mess-Dossier/Thesis wird die xor-Zelle als "Probe-Kosten-Messpunkt, KEIN Membership-Beleg" markiert (der Header sagt das bereits: rigoroser Membership-Beleg via Bloom/Cuckoo); FN-Quote (hier 30/256 auf dem 256er-Scan) als bekannte Eigenschaft an die Zelle. pos/neg der xor-Zelle aus vertrags-vergleichenden Auswertungen ausschliessen.
- **(C) xor-Zellen aus der Mess-Matrix nehmen:** verliert den 4. Familien-Kontrastpunkt (Multiplizitaet 3 zwischen Cuckoo 2 und Bloom 4) ohne Not.

### Empfehlung
**Option B fuer die Abgabe-Strecke** (kalender-ehrlich; die Vereinfachung ist seit 04.06. dokumentiert, die Wache pinnt sie sichtbar, der gemessene Probe-Pfad ist papertreu) — mit VERBINDLICHER Dossier-/Thesis-Notiz an der xor-Zelle und Ausschluss der xor-pos/neg aus Vertrags-Vergleichen. **Option A als Nach-Abgabe-Posten registrieren** (die Wache ist explizit als Heilungs-Detektor gebaut). Option A vorziehen NUR, falls der Owner den Membership-Vertrag aller vier Filter fuer die Messung als KERN einstuft.

---

## BEFUND 4 — KF-6: kLbufBytes = kRecords*64 wird bei line_size > 64 zum OOB (G8-Flaeche, MUSS im KF-6-Fenster mitbewegt werden)

### Sachlage (technisch)
Objekt: `ce/libs/cache_engine/anatomy/abi_adapter.hpp:454-464` (Mess-Treiber, Layout-Scan-Puffer Segment 3; Spiegel-Stellen laut Kartierung `:560`, `:691`):
- `:460-463` `kRecords=16384`, `kRecordSize=48`, `kLbufBytes = kRecords * 64; // OOB-Schutz: groesstmoeglicher Layout-Stride (64), nicht kRecordSize`
- `:464` `lbuf = alloc.allocate(kLbufBytes, 64)`; der Kommentar `:457-459` begruendet die 64 als "GROESSTMOEGLICHEN Stride": cache_line_aligned rechnet `aligned_stride = round_up(48, line)`; bei line=64 ist das 64, der Scan liest bis `(kRecords-1)*64+4` — die Rechnung stimmt NUR solange line_size <= 64.

Heute ist das korrekt, weil die Cache-Line-Groesse noch NTTP-fixiert ist (ausnahmslos `CacheLineConfig{}`, Default 64 — genau die "EINE Bewegungs-Stelle" der KF-6-Praezisierung). Das KF-6-Fenster (Posten 62: cacheline-NTTP-Codegen-Verdrahtung) macht line_size permutierbar, und die Studien-XML fuehrt bereits groessere Werte: `ce/libs/cache_engine/algorithm_profiles/thesis_profiles/cacheline_study.profile.xml:74-78` — `line_size 64 / 128 / 256 / 32` (per_organ="page_type node_type cache_traversal allocator"). Bei line_size=128/256 wird `round_up(48,line)` = 128/256 > 64 -> der CLA-Scan laese bis `(kRecords-1)*256+4` = weit hinter das Puffer-Ende -> **OOB-Read im Mess-Treiber**. Die Kartierung stuft die Datei als G8-gesperrt ein (Owner-Fenster, nicht im Bau zu heilen).

Zur Praezision der Befund-Klasse: Die Kartierung fuehrt die Stelle als "legitim-framework" mit ausgewiesenem Grenzfall — die Konstante DUPLIZIERT Achsen-Wissen (max Layout-Stride) im Treiber, statt es aus der Layout-/cacheline-Achse abzufragen. Das kollidiert mit der GENERALISIERTEN SCHNITT-REGEL (04.08., abend-6/abend-8: ALLE Achsen-Eigenschaften NUR ueber die Achsen) und mit dem P-CACHELINE-Muster (`line_bytes_of<T>`-Konsum-Bruecke `axes/cacheline/cacheline_line_bytes.hpp`, Ledger:3937).

### Entstehung
- **Erst-Fundstelle:** `super/docs/sessions/backups/20260804-schnitt-regel-kartierung/ergebnis-roh.json:500-506` (Kartierung, Fundstelle abi_adapter.hpp:454-464 inkl. Grenzfall-Begruendung; KF-6-Posten-Anschluss `:732`).
- **Scharf-Stellung:** `super/docs/sessions/backups/20260804-p-cacheline/ergebnis-roh.json:47` ("KF-6-WARNUNG aus der Kartierung, weiter offen und jetzt scharf: ... Bei line_size > 64 ist das ein OOB. Die Datei ist G8-gesperrt ... MUSS zwingend mit KF-6 zusammen bewegt werden.").
- **Ledger:** `super/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:3939` (NACHTRAG 04.08. abend-12, KF-6-PRAEZISIERUNG Punkt (c): "WARNUNG SCHARF: abi_adapter.hpp:454-464 kLbufBytes = kRecords*64 ... wird bei line_size>64 zum OOB — G8-Flaeche, MUSS im KF-6-Fenster mitbewegt werden, NIE vergessen").

### Konsequenz fuers MESSBILD
- Betroffene Zellen: die GESAMTE cacheline-Studie oberhalb 64 — **line_size in {128, 256} x memory_layout=cache_line_aligned** (und jede weitere Layout-Rep, deren Stride mit line_size skaliert) ueber alle per_organ-Traeger der Studie (page_type/node_type/cache_traversal/allocator). Am Ist (line 64 fixiert) ist NICHTS betroffen; die Warnung gilt exklusiv dem KF-6-Fenster.
- Wirkung: OOB-Reads im Segment-3-Scan liefern je nach Speicherlage **stumm falsche Werte** (Scan-Summen/Checksums aus fremdem Speicher — die Layout-Zeitmessung misst dann teilweise fremde Seiten/TLB-Verhalten) oder SIGSEGV. Das ist die gefaehrlichste Verfaelschungs-Klasse: kein Absturz-Zwang, kein 'failed', sondern plausibel aussehende, systematisch verfaelschte Kurven genau in der Studien-Dimension, die die Studie messen will.
- Zusatz-Falle: Die Spiegel-Stellen (`:560`, `:691` laut Kartierung) muessen im selben Zug bewegt werden, sonst heilt nur eine von drei Scan-Flaechen.

### Optionen
- **(A) Achsen-Ableitung (schnitt-regel-konform):** `kLbufBytes = kRecords * max_layout_stride`, wobei max_layout_stride zur Compile-Zeit aus der Layout-/cacheline-Achse kommt (z.B. `round_up(kRecordSize, line_bytes_of<MemLayout>)` bzw. Max ueber die Layout-Registry) — exakt das P-CACHELINE-Konsum-Brueckenmuster; die Kommentar-Begruendung bleibt wahr, weil sie dann PARAMETRISCH ist.
- **(B) Konservative Ober-Kappe:** kLbufBytes = kRecords * 256 (Max der Studien-XML). Simpel, aber dupliziert erneut Fremd-Wissen (jetzt XML-Wissen) im Treiber und bricht bei der naechsten XML-Erweiterung stumm — dieselbe Falle eine Stufe hoeher.
- **(C) line_size auf <=64 kappen:** verstuemmelt die Studie (KF-5 thesis-treu verlangt {32,64,128}; die XML fuehrt bewusst 128/256) — keine echte Option.

### Empfehlung
**Option A, fest an das KF-6-Fenster gebunden** (nicht frueher: G8-Sperre/Owner-Fenster; nicht spaeter: sonst misst die erste cacheline-Studie OOB). Konkret als Pflicht-Item in die KF-6-Scheiben-Checkliste: (1) NTTP-Belegung beweglich machen, (2) kLbufBytes + Spiegel `:560`/`:691` parametrisch ziehen, (3) eine BISS-Wache (static_assert kLbufBytes >= kRecords * max_stride) die den Vergessens-Fall compile-hart macht. Bis dahin ist der Punkt fuer das aktuelle Messfenster (line 64 fix) unschaedlich — der Entscheid ist eine TERMINIERUNGS-Zusage, kein Sofort-Bau.

---

## Querschnitt: Reihung fuer den Owner-Entscheid (Empfehlungs-Synthese)

| Posten | Klasse | Vor Messbeginn noetig? | Empfehlung | Aufwand |
|---|---|---|---|---|
| 74 OOM-Roh-Route | UB-Pfad im Mess-Traeger | JA (Ledger-Deklaration) | Wurf-Vertrag nachziehen (Posten-64-Klasse) | klein (2 Funktionen + TU) |
| 77 kReal16-Kollaps | papertreue Semantik | Nur Interpretation | Behalten; Lese-Regel + Key-Satz-Wahl dokumentieren; optionale Pin-Wache | minimal (Doku) |
| 78 XorFilter FN | deklarierter Adaptions-Abstrich | JA (Vertrags-Vergleichbarkeit) | Behalten + Zelle als Nicht-Membership-Beleg markieren; Heilung (Peeling) = Nach-Abgabe-Posten | minimal jetzt / mittel spaeter |
| KF-6 kLbufBytes | latenter OOB (erst mit KF-6) | NEIN (am Ist unschaedlich), aber Fenster-Bindung | Pflicht-Item der KF-6-Scheibe: parametrisch + BISS-Wache | klein, aber G8/Owner-Fenster |

Gemeinsamer Nenner: 77 und 78 sind EHRLICH GEPINNTE Eigenschaften (Wachen fallen bei Heilung — Vorsicht Zementierungs-Falle in beide Richtungen); 74 ist der einzige echte Vor-Mess-BAU-Kandidat; KF-6 ist eine Terminierungs-Zusage ans Owner-Fenster.
