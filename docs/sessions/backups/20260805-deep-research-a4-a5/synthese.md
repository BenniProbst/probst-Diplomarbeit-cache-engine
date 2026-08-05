# SYNTHESE Deep-Research A4 + A5 (Fable, 2026-08-05)

**Quellen dieser Synthese:** `a4-stride.md` (Cacheline-Stride, KF-6) + `a5-filter.md` (Key-/Value-Filter,
Filter-Familie). Beide Lens-Reports wurden vollstaendig gelesen; diese Synthese fuegt nichts Unbelegtes hinzu.
Alle Quellen-URLs/DOIs stehen in den Lens-Reports (A4 §5, A5 §6) und werden hier nicht dupliziert.

**Charakter:** (A4) ist Design-Input fuer das KF-6-Fenster (VOR Abgabe relevant, da KF-6 das zu testende
Kernfeature ist). (A5) ist ein ENTWURF fuer den Owner-Design-Entscheid NACH Abgabe — ausdruecklich KEINE
Festlegung. Kein Code wurde veraendert.

---

## TEIL A4 — Design-Input fuers KF-6-Fenster (Cacheline-Stride)

### A4.1 Empfohlenes Muster (durch SOTA gedeckt, durch Korpus vorbereitet)

**CT-NTTP-Instanz je line_size ueber die Achsen-Bruecke + einmalige CEB-Laufzeit-Wahl der Tier-Binary.**

1. **Eine Tier-Binary pro `CacheLineConfig`-NTTP** (line_size in {32,64,128,256}); innerhalb einer
   Tier-Binary ist der Stride IMMER fix — "Stride variiert zur Laufzeit" kommt in der Architektur gar
   nicht erst vor. Der bestehende Mechanismus (`ceb_generator.hpp`/`PermDescriptor`/`dlopen`) ist bereits
   das Ziel-Skelett; KF-6 muss "nur" den Codegen befaehigen, Nicht-Default-`CacheLineConfig` als NTTP zu
   emittieren.
2. **Die Achsen-Bruecke ist fertig:** `cacheline_line_bytes.hpp::line_bytes_of<T>()` loest dreistufig auf
   und liefert per `static_assert` beweisbar 128 fuer eine B128-Config. Sie muss nur noch VERBRAUCHT werden
   (heute instanziieren alle Strategie-Basen die Default-Config B64).
3. **CEB an der Orchestrierungs-Grenze** waehlt die passende Tier-Binary genau EINMAL (dlopen +
   Funktionspointer), danach kein Branch im Hot Path.
4. **HW-Freigabe-Kopplung:** Die Laufzeit-Erkennung der echten Line-Groesse (sysconf
   `_SC_LEVEL1_DCACHE_LINESIZE`, CPUID Leaf 1 EBX[15:8]*8, macOS `hw.cachelinesize`, ARM64 `CTR_EL0`,
   portabel hwloc) gehoert AUSSCHLIESSLICH an die CEB-/Planungs-Grenze: gebaut werden CT-seitig ALLE vier
   line_sizes; welche davon auf einer konkreten Maschine als "HW-freigegeben" gemessen werden, entscheidet
   die Orchestrierung einmalig anhand der erkannten Hardware. Das deckt sich mit dem Owner-KERN
   "HW-Werte nie statisch: Laufzeit-Factory ISA x OS" — Erkennung zur Laufzeit, Konsum als CT-Konstante.

### A4.2 SOTA-Belege fuer das Muster

| Beleg | Aussage |
|---|---|
| glibc IFUNC / GCC FMV | Resolver laeuft EINMAL beim Laden, Wahl danach fixiert; produktiv fuer memcpy/strlen |
| OpenBLAS DYNAMIC_ARCH | Kernel-Satz je Mikroarchitektur vorkompiliert; `gotoblas_t`-Tabelle einmal gesetzt |
| FFTW Codelets + Wisdom | Vorkompilierte groessenspezifische Einheiten; Planner waehlt einmalig/gecacht |
| pmbw | Eine eigene kompilierte Funktion pro Zugriffsgroesse, Registry-Auswahl ausserhalb der Schleife |
| std::hardware_destructive_interference_size (P0154R1) | Line-Groesse als CT-Konstante pro Build/ABI-Einheit, weil alignas()/Layout Laufzeitwerte nicht zulassen; CE (NTTP je Tier-Binary = eigene ABI-Insel) loest das PRAEZISER als der eine globale libstdc++-Wert 64 |
| Google Benchmark BENCHMARK_TEMPLATE + --benchmark_filter | "Alle Varianten kompilieren, Laufzeit-Filter waehlt" bestaetigt; CE-`CacheLineConfig` als strukturelles C++20-NTTP ist sauberer als deren `integral_constant`-Workaround |

### A4.3 Abgrenzung zu verworfenen Mustern

- **Runtime-Switch/std::variant im Hot Path:** von KEINEM der recherchierten SOTA-Systeme praktiziert;
  widerspricht zudem der Owner-Doktrin (kein Runtime-Switch, kein std::variant fuer statische Achsen;
  variant-Ausnahme gilt nur Hybrid-Tier HINTER der CEB). P0154R1 verwirft Laufzeit-Erkennung explizit
  (Appendix: nicht portabel, Wert hat strukturelle/ABI-Bedeutung).
- **Von Hand gepflegte Literale** (tinymembench als Negativ-Beleg: kein Bounds-Guard zwischen Blockgroesse
  und Puffer; verbreitetes, seit Jahren toleriertes Risiko dieser Werkzeugklasse) — bekanntes Muster, das
  hier bewusst NICHT kopiert wird.
- **`integral_constant`-Wrapping** (Google-Benchmark-Altlast mangels C++20-NTTP) — Korpus ist bereits
  weiter, kein Rueckschritt.
- **Ein globaler Kompromisswert pro Prozess** (libstdc++ 64 / ARM-Empfehlung 256) — die Tier-Binary-
  Architektur macht den Kompromiss unnoetig, jede Permutation traegt ihren exakten Wert.

### A4.4 Konkrete Bau-Skizze: kLbufBytes-Parametrisierung in `abi_adapter.hpp`

**Ist-Verletzung (Korpus-Befund):** `abi_adapter.hpp:462-463` traegt `kLbufBytes = kRecords*64` als
Hand-Literal; `axis_05_memory_layout_cache_line_aligned.hpp:60` traegt einen ZWEITEN unabhaengigen
`kCacheLine=64` (die selbstdokumentierte "Duplikat-Bug"-Falle). Beides verletzt die eigene Schnitt-Regel
("ALLE Achsen-Eigenschaften nur ueber die Achse"). Der OOB schlaeft nur, weil BEIDE Literale noch nicht an
die permutierte Achse angebunden sind; mit KF-6 wird er scharf: bei line_size=256 laese der Scan bis Byte
(16384-1)*256+4 = 4.194.308 in einem 1.048.576-Byte-Puffer (Faktor 4 Overrun).

**Fix in drei Schichten (Strategien 1-3 aus A4-Report §3, komplementaer):**

1. **Eine Quelle der Wahrheit (Hauptfix):** `kLbufBytes` wird ABGELEITET, nicht gepflegt.
   - Variante (a) — per-Tier exakt (bevorzugt, sobald der Adapter die Organ-Config als NTTP kennt):
     `constexpr std::size_t kLineBytes = line_bytes_of<Self>();`
     `constexpr std::size_t kMaxStride = round_up(kRecordSize, kLineBytes);`
     `constexpr std::size_t kLbufBytes = kRecords * kMaxStride;`
     Auch das Alignment-Argument von `alloc.allocate(kLbufBytes, 64)` wird auf `kLineBytes` umgestellt
     (zweites verstecktes 64-Literal an derselben Stelle).
   - Variante (b) — Profil-Maximum (Fallback, falls der Puffer konfigurationsuebergreifend geteilt bleiben
     muss): `kLbufBytes = kRecords * max_line_bytes(cacheline::all_configs())` — exakt die
     GCC/ARM-mtune-Formel "destructive size = Maximum des unterstuetzten Bereichs" (heute: 256).
   - In BEIDEN Varianten verschwindet der Literal 64 vollstaendig aus abi_adapter; SOTA-Vorbild
     likwid-bench (Puffer = Funktion der Workgroup-Spezifikation, kein separates Literal).
2. **Anbindung des Verbrauchers:** `cache_line_aligned::scan_field_sum` ersetzt seinen lokalen
   `kCacheLine=64` durch `line_bytes_of<Self>()` (bzw. bekommt den Wert als Template-/NTTP-Parameter
   durchgereicht) — erst DANN differenziert die Cacheline-Achse an dieser Scan-Stelle ueberhaupt messbar.
3. **Zweite Verteidigungslinie (lmbench-Gate):** Precondition-Pruefung unmittelbar vor der
   stride-abhaengigen Schleife, Vorbild `if (range < stride) return;` aus `lat_mem_rd.c`:
   - CT wo moeglich: `static_assert(kLbufBytes >= (kRecords - 1) * kMaxStride + sizeof(std::uint32_t));`
   - RT wo der Stride erst am Aufrufort feststeht: Gate am Segment-3-Einstieg; bei Verletzung Messung
     NICHT ausfuehren, sondern gemaess Mess-Kanon als 'failed' in die CSV schreiben (niemals still
     weiterlaufen, niemals null).

### A4.5 Test-Strategie (alle 4 line_sizes, OOB-Biss)

1. **Instanziierungs-Matrix:** je line_size in {32,64,128,256} eine Tier-Binary bauen;
   `static_assert(line_bytes_of<...>() == N)` je Instanz (Bruecke liefert den permutierten Wert).
2. **Puffer-Beweis CT:** static_assert der Gate-Ungleichung (A4.4/3) in jeder Instanz — bei B256 beweist
   das kLbufBytes >= 16384*256 = 4 MiB.
3. **OOB-Biss-Test (Negativ-Test / Drift-Wache):** ein Kompilier-Test, der die ALTE Formel
   (`kRecords*64`) gegen die B256-Instanz haelt und via static_assert beweist, dass das Gate sie ablehnt —
   damit ist der Biss des Gates selbst getestet, nicht nur der Gutfall (Doktrin: gruene Tests duerfen die
   alte Ordnung nicht zementieren).
4. **Sanitizer-Beleg RT:** ASan/UBSan-Lauf der B256- und B128-Permutation ueber Segment 3 (Debug-Modus,
   parallel erlaubt) — literaler Ausgaben-Nachweis, kein Haekchen ohne Output.
5. **Mess-Semantik-Erwartung dokumentieren:** bei kRecordSize=48 gilt round_up(48,32)=64 — B32 und B64
   fallen an DIESER Scan-Stelle auf denselben aligned_stride 64 (Aequivalenzklasse {32,64}->64, 128->128,
   256->256). Das ist KEIN Fehler, muss aber als erwartete Nicht-Differenzierung im Test/der Auswertung
   vermerkt sein, sonst wird es spaeter als Regression fehlgedeutet. Die Layout-Achsen-Differenzierung
   (aos_strict Stride 48 vs. CLA >= 64) bleibt in allen vier Faellen erhalten (X-§4-Invariante).
6. **HW-Freigabe-Pfad:** ein Orchestrierungs-Test, der die CEB-seitige Laufzeit-Erkennung stubbed (z.B.
   erkannte Line 64) und prueft, dass nur HW-freigegebene Permutationen zur Messung eingeplant werden —
   Bau ALLER vier bleibt davon unberuehrt.
7. **Golden-Disziplin:** Aenderungen golden-neutral einplanen (CI-Gesamtlauf = Messung AUS); der volle
   golden-Lauf nach Anbindung ist der Fehler-Finder der Produktionsschiene.

---

## TEIL A5 — Design-Input Filter-Familien-Erweiterung (ENTWURF fuer Owner-Entscheid NACH Abgabe)

**Status-Klammer:** Alles in Teil A5 ist Entwurfs-Input, KEINE Festlegung. Der Entscheid liegt beim Owner
nach Abgabe (Frist Fr 08.08.). Kein Handlungsbedarf vor Abgabe.

### A5.0 Verbindliche Korrektur zuerst

Die Filter-Achse ist **T16**, nicht T14 (T14 = I/O-Dispatch: Buffered/mmap/Direct-IO). Verifiziert gegen
`tab:axes-overview` (04_concept_architecture.tex Z.104) und `axis_filter_registry.hpp` (AllFilters =
Bloom/Cuckoo/RangeSurf/Xor, wortgleich zur T16-Zeile). Exakt die Verwechslungsfalle aus
`reference_thesis_axis_t_ids_vs_dir_numbers.md`. Jedes Folge-Design-Dokument MUSS mit T16 fuehren.

### A5.1 Key-Filter-Systematik (Ist + dokumentierte Luecke, kein Neubau verlangt)

1. **Membership (AMQ):** Bloom (1970) / Cuckoo (CoNEXT'14) / Xor (JEA'20) im Code; dokumentierte
   Erweiterungs-Kandidaten ohne Auftrag: Ribbon (2021), Binary Fuse (JEA'22), Learned/Sandwiched Bloom
   (SIGMOD'18/NeurIPS'18).
2. **Range:** T16 traegt genau EINEN von mindestens acht recherchierten SOTA-Vertretern (SuRF, SIGMOD'18).
   Nicht vertreten: Rosetta (2020), SNARF (2022), Grafite (2024), Memento (2025, erstes dynamisches,
   in WiredTiger integriert), Oasis/Oasis+ (2024), GRF (2024, global ueber den ganzen LSM-Baum),
   Aleph (2024), Zeno (2025). Einstiegspunkt fuer eine spaetere Erweiterungsentscheidung: Tutorial
   "Beyond Bloom" (SIGMOD/PODS 2024 Companion, Autoren = Dayan/Zhang-Linie).
3. **Gemeinsames Interface existiert schon:** `FilterStrategy`-Concept mit `supports_range_query()`-Flag
   vereinigt Membership+Range bereits unter einem Dach — direktes Vorbild fuer ein analoges
   `ValueFilterStrategy`-Concept.

### A5.2 Sortierung unter Key-Filter — Einordnung von Posten 60

1. **Literaturbefund:** Sortierte Strukturen (Zonemaps/Min-Max, SMA seit Moerkotte VLDB'98, Fence
   Pointers, LSM Sorted Runs) werden funktional identisch zu Filtern als Pruning/Data-Skipping
   beschrieben ("Zone Maps help determine where to NOT look for data"). Monkey (SIGMOD'17) fuehrt Bloom-
   Filter und Fence Pointers als zwei komplementaere, technisch getrennte Pruning-Mechanismen im SELBEN
   System — der Praezedenzfall fuer die Owner-These.
2. **Posten 60 `SortedArrayKeySet`** liefert ZWEI Vorfilter-Ebenen: die Binaersuche (O(log n),
   Basis-Zugriff) und — heute ungenutzt — ein implizites O(1)-Min/Max-Zonemap-Fenster aus den zwei
   Endwerten, ohne Zusatzspeicher.
3. **Design-Vorschlag (Entwurf):** Sortierung NICHT als neue eigene Filter-Instanz fuehren, sondern als
   Attribut/Nebenprodukt sortierter Organe: ein optionales `MinMaxHint`-artiges Interface, das sortierte
   Organe zusaetzlich zu ihrer T13-Rolle erfuellen koennen, sodass die Filter-Achse eine "kostenlose"
   Min/Max-Instanz einsammeln kann, ohne ein Bloom/SuRF-artiges Objekt zu allozieren (Fence-Pointer-
   Praezedenz).
4. **Offenes Spannungsfeld (bewusst unaufgeloest):** T13 (Storage-Order) vs. T16 (Filter) sind kanonisch
   getrennt; der Owner-Kern postuliert funktionale Zusammengehoerigkeit. BEIDE Lesarten sind
   literaturkonform (Monkey haelt die Trennung, nutzt beide komplementaer). Aufloesung =
   Architekturentscheidung des Owners, nicht dieser Recherche.

### A5.3 Value-Filter-Achse — vier Optionen mit Paper-Belegen (unbewertet)

Die neue Achsen-Frage lautet praezise: "muss dieser Value ueberhaupt gelesen/dekodiert werden, gegeben ein
Praedikat?" — orthogonal zu T11 (Value-Handle: WO/WIE liegt der Wert) und T13 (Key-Storage-Order). Keine
Namenskonflikte: Repo-Grep auf value_filter/ValueFilter ist leer.

| Option | Kern | Staerkster Beleg | Offene Kernfrage |
|---|---|---|---|
| A — neue Hauptachse T19 (SearchAlgorithm-Anatomie) | eigenes ValueFilterStrategy-Concept + eigene Wrapper-Familie | Idreos Data Calculator / Periodic Table: "Filter" ist EINE von fuenf generischen, seitenUNabhaengigen Primitiv-Klassen | gehoert die Achse zur SearchAlgorithm-Anatomie, obwohl die Frage erst bei Map (K!=V) scharf wird? |
| B — Sub-Familie in T16 | T16 bekommt Key- und Value-Sub-Rolle | NEXT/Perseid: ein System, zwei Filterpfade — aber dort NICHT als eine Achse gefuehrt (eher Gegenbeleg) | verletzt das dokumentierte "orthogonales Organ"-Prinzip von T16 |
| C — Achsen-Slot der kuenftigen Map-Gattung | parallel zu T16, aber im Map-Genus (analog Set: eigene ISetTier-ABI, eigener Achsen-Satz) | Set-Genus-Praezedenz (per User-GO promoted); Cross-Genus-Komposition existiert als Muster | Key-Filter (T16) und Value-Filter laegen in zwei Anatomien — wie referenziert ein Map-Organ beide? |
| D — Dual-Filter-Organ | EIN Organ traegt K-Filter- + V-Filter-Instanz als geschlossene Einheit | Curator (PACMMOD'26) + Window-Filter-ANN: K-Struktur und V-Praedikat als getrennte, koordinierte Komponenten in einem Objekt | Kopplungsgrad muss mitentschieden werden: Pre-/Post-/In-Filtering (vor/nach/waehrend Key-Zugriff) |

**Wrapper-Kandidaten-Familie fuer die Value-Seite** (unabhaengig von der Options-Wahl, spiegelt die
Reifungs-Linie der Key-Seite):
- statisch: Zonemap/SMA auf Werten (Moerkotte VLDB'98; Ziauddin PVLDB'17; Netezza/Snowflake-Praxis)
- repraesentationsbasiert: Column Sketches (SIGMOD'18), BitWeaving (SIGMOD'13), Column Imprints
  (SIGMOD'13), Data Blocks/Positional-SMA (SIGMOD'16)
- adaptiv/gelernt: Predicate Caching (SIGMOD'24), Database Cracking (PVLDB'12)
- Grenzfall gesondert benennen: Bloom-Join/Predicate Transfer (CIDR'24/PACMMOD'25) — Filter AUS Values
  der einen Seite GEGEN Keys der anderen; weder reiner K- noch reiner V-Filter.

### A5.4 Registry-/Gattungs-Konsequenzen (Map traegt beide)

1. **Map-Gattung (K!=V) ist der Traeger beider Filterrollen:** Key-Filter-Pfad (T16-Erbe) + Value-Filter-
   Pfad. Direkteste Systempraezedenz: NEXT (PACMMOD'25) / Perseid (ACM ToS'24) — EIN LSM-KV-Store mit
   Primaerschluessel-Filter UND Sekundaerattribut/Value-Filter, dort als getrennte Subsysteme ohne
   vereinheitlichtes Achsen-Vokabular. Genau diese Vereinheitlichung waere der Beitrag der neuen Achse.
2. **Registry-Bild (Entwurf):** analog `axis_filter_registry.hpp` eine `axis_value_filter_registry`
   (Options A/C/D) bzw. Sub-Registry (Option B); Registry bleibt ANGEBOT, Aufloesung ueber den Planer
   (Registry-Doktrin). Fehlerklassen-Pflicht gilt fuer die neue (Unter-)Achse wie fuer jede andere.
3. **Set bleibt unberuehrt:** fuer K=V (Set) ist Value-Filter gegenstandslos (Value == Key); die Frage
   wird erst mit der Map-Gattung scharf, die laut Sequence-Plan noch nicht als Genus verankert ist.
4. **Doku-Ehrlichkeit (Pflicht-Einordnung):** Die Zwei-Achsen-Benennung "Key-Filter + Value-Filter fuer
   EINE Map-Struktur" ist nach expliziter Negativ-Feststellung KEIN woertliches Literatur-Zitat, sondern
   eine literaturgestuetzte SYNTHESE des Projekts (gestuetzt durch Idreos-Primitiv, NEXT/Perseid,
   Curator-Taxonomie). In Thesis/Doku entsprechend als Architekturentscheidung mit Literaturstuetze
   fuehren, nicht als uebernommene Nomenklatur. Offene Nachrecherche: Periodic-Table-Volltext (in der
   Session nur snippet-verifiziert, 403).

---

## Querbezug A4/A5 (eine Beobachtung)

Beide Lenses treffen dieselbe Meta-Regel aus zwei Richtungen: A4 zeigt eine EINZELVERLETZUNG der
Schnitt-Regel "alle Achsen-Eigenschaften nur ueber die Achse" (Hand-Literal 64 statt Achsen-Bruecke); A5
zeigt die ERWEITERUNGS-Seite derselben Regel (eine neue Eigenschaftsklasse — Value-Praedikat-Pruning —
verlangt eine eigene Achsen-Heimat statt Anbau an T11/T13/T16 ohne Entscheid). In beiden Faellen ist die
Achse die einzige Quelle der Wahrheit; A4 ist dafuer der Sofort-Fall (KF-6), A5 der Nach-Abgabe-Fall.
