# BEFUND — T19 `persistence_target`: Deep Research zur Achsen-Semantik (Auftrag D-8, 17.08.2026)

> **Zweck:** Owner-Auftrag D-8 (Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:26` woertlich: *"D-8: Bitte deep research dazu, wie die Achse aussehen muesste"*) — Skizze, wie eine Persistenz-Ziel-Achse fuer `persistence_target` **aussehen muesste**: Varianten-Enum + Zielgroessen mit Min/Max-Richtung, gegründet in (A) Objekt+Ledger-Ist-Stand und (B) peer-reviewed PMEM/NVM-Indexliteratur.
> **Format-Vorbild:** `docs/audits/20260709-axes-optimization-deep-research-BEFUND.md` (Kopf gelesen). **Abweichung offen ausgewiesen:** jenes Dokument definiert **keine** `[THESIS]/[LIT]/[EMPF]`-Klammermarken — es zitiert stattdessen durchgehend Datei:Zeile bzw. Web-Quelle inline und markiert Luecken als "OFFEN, NICHT ERFUNDEN". Ich uebernehme dessen Zitierdisziplin und definiere die vom Auftrag verlangten drei Marken selbst:
> - **[THESIS]** = am Objekt/Ledger dieses Repos verifiziert, Fundstelle Datei:Zeile
> - **[LIT]** = aus peer-reviewed (oder mind. begutachteter Venue-Preprint-)Literatur, mit URL
> - **[EMPF]** = meine eigene Synthese/Empfehlung — nicht woertlich belegt, sondern aus (A)+(B) abgeleitet
>
> **Ich habe NICHTS geaendert, committet oder geschrieben** — reine Recherche. Alle Aussagen unten tragen Fundstelle. Am Ende: GEPRUEFT/NICHT GEPRUEFT.

---

## TEIL A — OBJEKT + LEDGER

### A.0 Die Nummern-Verwirrung zuerst aufgeloest — sonst ist der Rest nicht lesbar

Der Auftrag nennt `persistence_target (T19)`, der Code nennt sie an anderer Stelle `T17`, ein drittes Fundstueck nennt sie `T26`. Alle drei sind **richtig — in drei verschiedenen Nummernkreisen**, die im Repo nirgends explizit gegenuebergestellt werden [EMPF, aus den drei folgenden Fakten selbst zusammengefuehrt]:

| Nummernkreis | Wert fuer `persistence_target` | Definiert in | Zaehlt |
|---|---|---|---|
| **Kompositions-Slot** (binary_id-Reihenfolge) | **T17** (0-indiziert, 18. von 18) | [THESIS] `Code/external/comdare-cache-engine/libs/cache_engine/builder/experiment_tree/axis_path_serialization.hpp:40-43` (`kCompositionAxisNames`, 18 Eintraege, `persistence_target` letztes Element) | die 18 **heute aktiven** Organ-Achsen der Permutation |
| **Katalog-Zeile** (Optimierungs-Richtung) | **T19** (naechster freier Wert, falls angehaengt) | [THESIS] `heuristik/axis_optimization_catalog.hpp:76-95` (`enum class CatalogAxis`, `SearchAlgo=0` .. `QueuingQ2=18`; `persistence_target` hat **keinen** Enum-Wert) | die 19 Zeilen des **historischen** 09.07.-Katalogs (T0..T18, inkl. der seither ausgezogenen `telemetry`/`isa`) |
| **Registry-Alias** (interne Reflection-ID) | **T26** (`R26_persistence_target`) | [THESIS] `builder/experiment_tree/axis_variant_version_table.hpp:143,235` (`axes26_registered::R26_persistence_target`) | eine **groessere historische Slot-Liste** mit Luecken bei T10, T12, T17-T19, T22-T25 (retirierte/nie belegte Registry-Slots) — mit der Kompositions- oder Katalog-Zaehlung NICHT verwandt |

**Was das fuer den Auftrag heisst:** Die "T19" aus D-8/G-2 ist **keine** eigene, im Code verankerte Nummer — sie ist die **logische naechste Zeile** des `axis_optimization_catalog.hpp` (T0..T18 belegt, T19 waere die naechste), UND per Zufall trifft sie exakt das freie `t_id`-Feld-Muster dieses Katalogs (`"T0".."T18"` als `std::string_view`, [THESIS] `axis_optimization_catalog.hpp:218`). Das ist also **kein Fehlgriff des Owners**, sondern die praeziseste verfuegbare Bezeichnung fuer *"die Zeile, die der Katalog als naechste bekaeme"*. Ab hier verwende ich **T19** ausschliesslich in diesem Sinn (Katalog-Erweiterung); fuer den Kompositions-Slot bleibe ich bei **T17**.

### A.1 T19-Pinnung am Objekt: was "auf 1 gepinnt" konkret bedeutet

`grep persistence_target` in `Code/external/comdare-cache-engine/libs/` und `tests/` liefert **~150 Fundstellen**; der Kern liegt in `libs/cache_engine/organ_axes/persistence_target/` (7 Header) + `topics/io/axis_persistence_target/` (1 Forwarding-Header) + `test_org18_persistence_target.cpp`. Die Achse traegt **zwei deklarierte Bausteine**, von denen **einer** aktiv ist:

- **`MemoryOnlyTarget`** [THESIS] `axis_persistence_target_memory_only.hpp:27-58`: `family_id=0`, `writes_back_to_disk()=false`, Mess-Op `persistence_writeback_scan()` gibt `return 0` (ehrliche Baseline, kein Pfad). `enabled` ist per `static_assert` **erzwungen an** (Z.39-41 der Registry: *"memory_only ist der golden_wired-Durchreich-Wert ... darf daher NIE per option() abgeschaltet werden"*) — dies ist der Wert, den **jede** bestehende Komposition traegt.
- **`DiskWritebackTarget`** [THESIS] `axis_persistence_target_disk_writeback.hpp:40-94`: `family_id=1`, `writes_back_to_disk()=true`, per Default **`enabled=false`** (aus einem CMake-generierten `flags`-Header). Die Mess-Op kopiert jeden Record in einen 64-Byte-Staging-Puffer + faltet eine Pruefsumme — **explizit keine echte Platten-I/O**. Eine eigene, maschinenlesbare Ehrlichkeitsmarke `has_device_writeback_path()` liefert **konstant `false`**, mit `static_assert`-Erinnerung (Z.102-104): *"Sobald ein echter Geraete-Schreibpfad existiert: ... static_assert hier entfernen"*.

**Die Pinnung selbst** [THESIS] `libs/cache_engine/profile_facade/source_catalog.hpp:136-138,170-172`:
```
// STRUKT-R ORG-18 / Owner-Entscheid Q-1 = FALL B: 17 Achsen je 2, persistence_target (K17) auf 1 GEPINNT.
// Damit bleibt der Raum 2^17 * 1 = 131072 (~224 GB / ~24 h Voll-Bau) statt 2^18 = 262144 (~448 GB / ~48 h)
```
`K17` ist der Kardinalitaets-Parameter des 18. (0-indiziert: 17.) Slots im `FullSourceCatalog<K0,...,K17>`-Template — er ist **mit voller Absicht** auf 1 geklemmt, weil `mp_take_c<L,2>` auf einer 1-elementigen Liste *ill-formed* ist (Bauplan-Falle, `axis_persistence_target_registry.hpp:9-12`, gegen die `source_catalog.hpp:114-121` explizit absichert). Der Test `test_org18_persistence_target.cpp:79-92` verifiziert das literal: `catalog_axis_product<FullSourceCatalog>() == 131072u` mit Kommentar *"17 Achsen je 2 x persistence_target je 1 = 131072 (NICHT 262144)"*. **Aufschaltung** (K17→2 + `COMDARE_AXIS_PERSISTENCE_ENABLE_DISK_WRITEBACK=ON`) ist **jederzeit ohne Codeänderung** moeglich — bewusst so gebaut, damit die Q-1-Auflage *"per XML deaktiviert und das muss unterstuetzt sein"* erfuellt bleibt.

Diese "T19"/K17-Pinnung ist **also selbst kein Defekt** — sie ist eine bewusste Kapazitaets-Entscheidung (Owner Q-1 Fall B), und der zweite Baustein ist bereits vollstaendig kompiliert vorhanden, nur inaktiv.

### A.2 Der eigentliche D-8-Gegenstand: die Katalog-Luecke

`persistence_target`/T17 ist die **einzige** der 18 heutigen Kompositions-Achsen ohne Zeile in `heuristik/axis_optimization_catalog.hpp`. Der Header sagt das selbst, sehr genau [THESIS] `axis_optimization_catalog.hpp:42-53`:
> *"Der Katalog ist der Stand 2026-07-09 und fuehrt 19 Zeilen T0..T18 inklusive telemetry (T10) und isa (T12). Beide haben die binary_id-permutierende Komposition seither VERLASSEN ... Umgekehrt traegt die Komposition seit STRUKT-R ORG-18 die 18. Achse 'persistence_target', fuer die es im Katalog KEINE Zeile gibt. Schnittmenge: 17 Namen. ... OFFEN, NICHT ERFUNDEN: fuer persistence_target existiert KEINE Katalog-Zeile und damit hier KEINE Richtung. `catalog_axis_from_name('persistence_target')` liefert honest-empty."*

Der Drift ist **compile-time verankert**, nicht nur dokumentiert — [THESIS] `tests/unit/test_heuristik_spline_break_even.cpp:72-90,402-428`:
```
static_assert(ex::kCompositionAxisNames.size() == 18u);
static_assert(composition_names_with_catalog_row() == 17u,
              "17 der 18 Kompositions-Achsen haben eine Katalog-Zeile.");
// [analog, Z.409]: "genau EINE Kompositions-Achse ohne Katalog-Zeile: persistence_target (Owner-Entscheid offen)."
EXPECT_FALSE(h::catalog_axis_from_name("persistence_target").has_value())
    << "persistence_target hat KEINE Katalog-Zeile -- honest-empty statt geratener Richtung";
```
Das ist **exakt** der "consteval-Anker", den die Owner-Vorlage vom 17.08. referenziert (siehe A.3). Jede kuenftige Verschiebung der 17↔18-Zahl bricht diesen Test **absichtlich**, statt still falsch zu werden.

Die Katalog-Zeilen selbst haben ein festes Schema — [THESIS] `axis_optimization_catalog.hpp:216-226,229-256`:
```cpp
struct AxisOptimizationInfo {
    CatalogAxis      axis;             // Enum-Wert == Index
    std::string_view t_id;             // "T0".."T18" -- die T-Nummer
    std::string_view name;             // Achsen-Token
    std::uint16_t    source_line;      // Zeile im BEFUND
    std::string_view mess_kategorien;  // z.B. "LAT, THR, dTLB, CM"
    std::string_view parameter_art;    // z.B. "CT", "RC-Phantom ...", "CT+asp"
    std::size_t      objective_begin;
    std::size_t      objective_count;
    bool             pareto;           // BEFUND :450-453
};
```
Zwei benachbarte, thematisch verwandte Zeilen als Stilvorbild [THESIS] `axis_optimization_catalog.hpp:250,255`:
```cpp
{CatalogAxis::IoDispatch, "T14", "io_dispatch", 97, "LAT, THR, dTLB, CM", "CT", 33, 2, false},
{CatalogAxis::QueuingQ2, "T18", "queuing_q2", 101, "THR, LAT, MEM, EN", "CT+asp (Threshold)", 42, 3, true},
```
mit Zielgroessen [THESIS] `:170-176,205-208`:
```cpp
{CatalogAxis::IoDispatch, "io_throughput", Maximize, "I/O-Durchsatz + Kontrolle (async/evict)"},
{CatalogAxis::IoDispatch, "page_fault_overhead", Minimize, "Page-Fault/TLB-Shootdown-Overhead (mmap-Antipattern)"},
...
{CatalogAxis::QueuingQ2, "write_amplification", Minimize, "Write-Amplification (lazy)"},
{CatalogAxis::QueuingQ2, "batching", Maximize, "Batching (lazy)"},
{CatalogAxis::QueuingQ2, "staleness_tail_latency", Minimize, "Staleness/Tail-Latenz (eager)"},
```
**Bemerkenswert fuer den Vorschlag unten:** `queuing_q2` (T18) traegt bereits `write_amplification` als MIN-Zielgroesse UND ist als **Pareto** markiert (batching MAX steht gegen staleness_tail_latency MIN — die klassische Eager-vs-Lazy-Flush-Spannung). Das ist thematisch die naechste Verwandte von `persistence_target`.

### A.3 ORG-19-Kopplung: der zweite, groessere Faden — NICHT Gegenstand dieser Recherche, aber zwingend mitzudenken

Parallel zur reinen Katalog-Luecke laeuft ein **architektonisch groesserer, eigenstaendiger** Strang, den der Auftrag als "ORG-19-Kopplung" bezeichnet und der mit T19/T17 kollidiert, ohne aufgeloest zu sein:

- **KON80-01, Owner verbatim 16.08.** [THESIS] `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:1248-1258`:
  > *"V10 = (b): NEUNZEHNTE ACHSE KOMMT — erste ORGAN-META-META-ACHSE (IO): extrahiert IO-Eigenschaften der Paper; bietet Algorithmen als optionale PERSISTIERUNG der anderen Tier-Binaries + Gesamt-Suchalgorithmen; NUR unter expliziter XML-Anfrage eingebaut ... braucht eigene Serialisierung; bietet Laden/Speichern von Genus-Interface-Algorithmen als Genus-metaprogrammierte Erweiterung; bei Verwendung erweitert sich das GENUS-INTERFACE um `store()` und `load()`. -> Design-Posten ORG-19/IO-Meta-Meta ... ORG-18-Kanon damit UEBERHOLT zu 'ORG-18 + 1 optionale Meta-Meta'."*
- Diese ORG-19-IO ist als **erste** Organ-Meta-Meta-Achse und **erste required-Deklaration** des ganzen Systems gefuehrt [THESIS] `docs/sessions/backups/20260817-drift-konsolidierung-rohdaten/rest_karte_r4.md:247`.
- **Der Widerspruch ist explizit offen registriert**, "W14": [THESIS] `docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md:2498-2499`: *"W14 T17 vs. ORG-19: Explore ob persistence_target daneben besteht; koppelt an K17-Pinning und die gedruckte 2^17"* — und "C-6": [THESIS] `rest_karte_r4.md:245-248`: *"→ Aufloesung: Explore am Objekt — wird ORG-19 scharf, entpinnt das K17? Dann aendert sich die gedruckte Zahl 2^17 ... Vor jeder Thesis-Zahlenaenderung klaeren."*
- Die aktuellste (heutige) Owner-Vorlage bestaetigt: der Lead empfahl *"Erst die gekoppelte Explore-Frage aufloesen, dann entscheiden ... Ich empfehle: heute keine Zeile, aber ein Marker am consteval-Anker, der auf ORG-19 zeigt"* — [THESIS] `docs/sessions/20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md:311-328`. **Der Owner hat diese konservative Empfehlung NICHT einfach uebernommen**, sondern stattdessen die vorliegende Deep-Research angeordnet [THESIS] Ledger `:26,44-50` (KON104-01/-02).

**Konsequenz fuer diesen Befund:** Ich loese W14/C-6 **nicht** auf (das ist explizit ein "Explore am Objekt", kein Literatur-Research, und ausserhalb meines Auftrags). Der Vorschlag in Teil C ist so konstruiert, dass er **robust gegen beide Ausgaenge** ist (siehe C.7).

### A.4 18/19-Achsen-Historie, chronologisch (Forensik am Ledger)

[THESIS] `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:25318-25327` (woertliche Forensik-Passage):

| Datum | Ereignis | Organ-Achsen-Zahl | Fundstelle |
|---|---|---|---|
| bis 17.07. | `telemetry`+`isa` sind Organ-Achsen | **19** | Ledger:25318 |
| 17.07. (INC-2c, ce `5fe811db`) | `telemetry` → System-Achse | 19→**18** | Ledger:25318 |
| INC-2d | `isa` → System-Achse | 18→**17** | Ledger:25318 (daher alle "17-Achsen"-Vermerke im Repo) |
| 26.07. (STRUKT-R, ce-Welle) | `persistence_target` NEU als 18. Organ-Achse | 17→**18** | Ledger:6263-6266, `docs/sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md:65-88` ("Session-Doc §5") |
| 09.07. (BEFUND, **vor** der 26.07.-Welle) | Katalog eingefroren bei **T0..T18 = 19 Zeilen** (mit telemetry/isa, ohne persistence_target) | — | `axis_optimization_catalog.hpp:43` |
| 16.08. (KON80-V10) | Owner benennt ORG-19-IO als potenzielle **19. Achse** (Meta-Meta, orthogonal zu obiger Zaehlung) | 18 **+ 1 optional** | Ledger:1248 |
| 17.08. (KON104, D-8) | Deep-Research-Auftrag fuer die T19-Katalogzeile | — | Ledger:21-49 |

**Memory-Abgleich:** Der Memory-Anker *"18 ORGAN-ACHSEN sind achtzehn nicht neunzehn"* ist mit diesem Stand **konsistent** — die Komposition hat heute 18, nicht 19, Organ-Hauptachsen; die "19" taucht ausschliesslich (a) im veralteten 09.07.-Katalog (mit anderer Besetzung) und (b) als *zukuenftige, optionale* ORG-19-Meta-Meta auf, nie als aktueller Kompositionsstand.

### A.5 Nebenfund: ein unbenutztes, aber genau passendes Interface liegt bereits im Objekt

`platform/storage.hpp` [THESIS] `Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/platform/storage.hpp:1-43` deklariert seit einer fruehen Planungswelle ("Termin 7 / REV 5 K07", Z.3) ein vollstaendiges, ABER **von keiner einzigen anderen Datei konsumiertes** Interface:
```cpp
enum class StorageMediumKind : std::uint8_t {
    Dram = 0, Hbm = 1, Nvram = 2 /* Optane-aehnlich */, Cxl = 3 /* CXL.mem */,
    SsdNvme = 4, HddSpinning = 5,
};
class IStorageMedium {
    virtual StorageMediumKind kind() const noexcept = 0;
    virtual double read_latency_ns() const noexcept = 0;
    virtual double write_latency_ns() const noexcept = 0;
    virtual double bandwidth_gbps() const noexcept = 0;
    virtual bool is_persistent() const noexcept = 0;
    virtual bool has_wearout() const noexcept = 0;
};
```
Gegenprobe (`grep -rl StorageMediumKind libs/ apps/ tools/`) liefert **ausschliesslich diese Datei + ihren eigenen Test** (`tests/unit/test_platform_concepts.cpp`) — **0 Konsumenten**. Das ist exakt die Klassifikation, die der D-8-Auftrag fuer eine Varianten-Enum sucht (Nvram/Cxl/SsdNvme sind bereits vorgedacht), aber sie ist **Hardware-Erkennung**, nicht **Algorithmus-Achse** — ein orthogonales, bisher unverbundenes Stueck Vorarbeit (siehe C.2).

### A.6 GEPRUEFT / NICHT GEPRUEFT — Teil A

**GEPRUEFT (am Objekt/Ledger verifiziert):** T17-Kompositionsposition · T19-Katalogluecke inkl. consteval-Anker · K17=1-Pinnung + Owner-Q-1-Fall-B-Begruendung · beide Bausteine (MemoryOnly/DiskWriteback) inkl. Ehrlichkeitsflag `has_device_writeback_path()` · `PersistenceTargetSnapshot`-Felder inkl. permanent-0 `device_flushes` · ORG-19-IO-Konzept (KON80-V10) + W14/C-6-Widerspruch als *offen* registriert · 18/19-Historie · `StorageMediumKind`-Fund + 0-Konsumenten-Gegenprobe · "ORG-19" als Ledger-Begriff (4 Treffer in KON104 selbst + zahlreiche Folge-Dokumente, **0 Treffer** als eigenstaendiger Code-Kommentar-Marker in `libs/`/`tests/` — dort steht durchgehend "ORG-18").
**NICHT GEPRUEFT (ausserhalb des Auftrags/Zeitbudgets):** ob prod1/prod2 echte PMEM/Optane/CXL-Hardware besitzen (keine Fundstelle dazu; fuer C.2 als offene Flanke ausgewiesen) · die exakte inhaltliche Aufloesung von W14/C-6 selbst (das ist ein separater "Explore am Objekt"-Auftrag, nicht Teil von D-8) · ob `flags`-Header (`axis_persistence_target_flags.hpp`) im aktuellen Build-Verzeichnis generiert vorliegt (Datei nicht direkt lesbar, da CMake-generiert — Existenz nur indirekt aus den zwei `option()`-Namen in den Kommentaren erschlossen).

---

## TEIL B — LITERATUR

### B.1 Peer-reviewed PMEM/NVM-Indexstrukturen

| Paper | Venue/Jahr | Kernidee | Berichtete Zielgroessen |
|---|---|---|---|
| **FPTree** — Oukid, Lasperas, Nica, Willhalm, Lehner | SIGMOD 2016 | Hybrid: innere Knoten in DRAM (rekonstruiert bei Recovery), Blaetter in SCM; *Fingerprinting* reduziert erwartete In-Leaf-Vergleiche auf ~1; HTM-basierte Nebenlaeufigkeit | bis zu **8,2x** schneller als SOTA bei variabler SCM-Latenz; Skalierung auf 88 logische Kerne [LIT] |
| **BzTree** — Arulraj, Levandoski, Minhas, Larson | PVLDB 11(5):553-565, 2018 | latch-freier Index via **PMwCAS** (persistent multi-word CAS); **derselbe Code** laeuft unveraendert auf volatilem RAM UND NVM | bis **2x** Durchsatz vs. Bw-Tree; **Recovery-Zeit im Mittel ~145 μs**, kein Sonder-Recovery-Code noetig [LIT] |
| **NV-Tree** — Yang, Wei, Chen, Wang et al. | USENIX FAST 2015 | Konsistenz **nur** fuer Blattknoten garantiert; innere Knoten aus Blaettern rekonstruiert; Log-strukturierte Blaetter vermeiden haeufige Synchronisation | bis **12x** schneller als konsistente SOTA-Baeume unter Schreib-Last [LIT] |
| **"Persistent B+-Trees in Non-Volatile Main Memory"** (= "LB+-Tree") — Chen, Jin | PVLDB 8(7):786-797, 2015 | zeigt, dass klassisches Undo-Redo-Logging + Shadowing auf NVM drastische Overheads erzeugt (exzessive NVM-Writes + CPU-Cache-Flushes); leitet daraus flusharme B+-Baum-Varianten her | Grundlagenarbeit fuer die gesamte Nachfolge-Linie (u.a. LB+-Trees als expliziter Nachfolgebegriff) [LIT] |
| **PACTree** — Kim, Ramanathan, Fu, Kashyap, Min | SOSP 2021 | **PAC-Guidelines** (Packed, Asynchronous Concurrency): gepackte Partial-Keys in inneren Knoten, asynchrones Nebenlaeufigkeits-Update; identifiziert Directory-Cache-Coherence als Ursache fuer NUMA-Bandbreiten-Einbrueche | **7x** Durchsatz, **20x** besseres p99.99-Tail gg. SOTA [LIT] |
| *(Bonus, aktuell)* **Bf-Tree** — Hao, Chandramouli | PVLDB 17(11):3442-3455, 2024 | ersetzt starre 4-KB-Seiten durch variable Mini-Seiten (64-4096 B), um Write-Amplification zu senken (Beispiel: 100-B-Update auf 4-KB-Seite = **40x** WA bei klassischen B-Baeumen) | 2,5x schneller als RocksDB (Scan), 6x schneller als B-Baum (Write), 2x (Point-Lookup) [LIT] |
| *(Bonus, Framework)* **RECIPE** — Lee, Kannan, Reddy, Kim, Min | SOSP 2019 | zeigt, dass Isolation konkurrenzfreier DRAM-Indexe mit **30-200 Zeilen Code** in Crash-Konsistenz fuer PM uebersetzbar ist (5 konvertierte Indextypen: B+-Baum, Trie, Radix, Hash) | bis **5,2x** schneller als handgeschriebene SOTA-PM-Indexe im Multithread-Fall [LIT] |

### B.2 Persistenz-Zielgroessen aus der Literatur (die fuenf im Auftrag genannten)

1. **Recovery-Zeit** — Standard-Metrik seit Chen/Jin 2015; BzTree berichtet konkret **~145 μs im Mittel**, explizit *"kein Sonder-Recovery-Code noetig"* — als Design-Ziel, nicht nur Messwert [LIT: BzTree, PVLDB 2018].
2. **Persist-Latenz je Op** — die zentrale Metrik der Lersch-et-al.-Survey *"Evaluating Persistent Memory Range Indexes"* (VLDB 13(4):574-587, 2020; erweiterte Fassung arXiv:2201.13047), die FPTree/BzTree/wBTree/NV-Tree/WORT auf **Latenz (μs, inkl. p99-Tail)** explizit gegenueberstellt [LIT, per WebFetch direkt aus der PDF extrahiert: die Survey fuehrt "Latency", "Tail Latency (p99/p95)", "Recovery Time", "PM Writes/Write Amplification", "Flush and Fence Counts per Operation" als eigene Metrik-Abschnitte 5.6/5.9/5.10].
3. **Write-Amplification auf NVM** — doppelt belegt: (a) hardwarenah — Optane uebersetzt kleine Schreibzugriffe intern in 256-Byte-Bloecke, was Write-Amplification erzwingt [LIT, aus Search-Synthese zu "Basic Performance Measurements of the Intel Optane DC PMM" (Izraelevitz et al., arXiv:1903.05714) — Abstract per WebFetch verifiziert: *"byte-granularity accesses with access times on the order of DRAM"*, konkrete ns/GB-s-Zahlen im Volltext **nicht extrahierbar** (PDF-Binaerstream), daher [NICHT GEPRUEFT fuer die exakten ns-Werte]]; (b) algorithmisch — Bf-Tree (2024) macht Write-Amplification zum expliziten Optimierungsziel, mit dem konkreten **40x**-Beispiel fuer starre 4-KB-Seiten [LIT, s.o.].
4. **Flush/Fence-Zahl je Op** — als eigene Metrik-Kategorie in der Lersch-Survey gefuehrt (s.o., Punkt 2); mechanistisch: `CLFLUSH`/`CLFLUSHOPT` evictieren die Cache-Line, `CLWB` nicht (schreibt zurueck ohne Evict), `SFENCE` erzwingt Ordering — alle drei Instruktionsklassen sind die direkten "Stellschrauben", die FPTree/NV-Tree/PACTree durch ihre jeweiligen Designs (Fingerprinting, Leaf-only-Konsistenz, Packed-Async) explizit **minimieren** [LIT, Search-Synthese aus mehreren Quellen inkl. der Lersch-Survey und "An Empirical Guide to the Behavior and Use of Scalable Persistent Memory" (arXiv:1908.03583)].
5. **Haltbarkeits-Garantie-Klassen** — grundgelegt in der **Persistence-Domain**-Taxonomie: **ADR** (Asynchronous DRAM Refresh) haelt nur die Memory-Controller-Write-Pending-Queues im Persistenz-Bereich, Software muss per `CLWB`/`CLFLUSH` explizit flushen; **eADR** (Enhanced ADR) erweitert den Persistenz-Bereich auf die **CPU-Caches selbst** — bei einem Stromausfall flusht eine NMI-Routine die Caches automatisch, Software braucht **keine** expliziten Flush-Aufrufe mehr [LIT, Intel-Doku + mehrere Paper, u.a. "Efficient Atomic Durability on eADR-Enabled Persistent Memory" (PACT 2022) und "From Ideal to Practice: Data Encryption in eADR-based Secure NVM Systems" (arXiv:2307.02050)]. Die klassische DB-Grundlagenarbeit fuer die generelle Storage/Recovery-Taxonomie ist **Arulraj/Pavlo/Dulloor, "Let's Talk About Storage & Recovery Methods for Non-Volatile Memory Database Systems"**, SIGMOD 2015 (S.707-722) [LIT].

### B.3 CXL-/DAX-/io_uring-Ziele

- **CXL**: seit Intels Optane-Ausstieg (siehe B.4) die Haupt-Nachfolgerichtung. *"CXL Memory as Persistent Memory for Disaggregated HPC: A Practical Approach"* (arXiv:2308.10714) untersucht CXL-Memory explizit als Persistenzschicht fuer disaggregierte HPC-Systeme [LIT]. Wichtige Praezisierung: der grosse Teil der aktuellen CXL-Literatur (z.B. *Pond*, ASPLOS 2023; *dLSM*, ICDE 2023) behandelt CXL als **volatile** Kapazitaets-Erweiterung/-Pooling, **nicht** als nichtfluechtiges Medium — "CXL" und "persistent" sind in der Literatur **zwei unabhaengige Achsen**, die nur in einer Teilmenge der Arbeiten zusammenfallen [EMPF, aus Gegenueberstellung mehrerer Quellen]. Konkrete Latenzzahlen fuer den CXL-Overhead (haeufig zitiert: **~70 ns Round-Trip** zusaetzlich zu direktem DRAM, Bandbreite je nach Controller-Generation 12-25 ns/Richtung) stammen aus **Industrie-/Analyse-Blogs, nicht aus einem peer-reviewed Paper direkt verifiziert** — [NICHT GEPRUEFT, nur als Groessenordnung zu lesen].
- **DAX** (Direct Access): der Mechanismus, ueber den FPTree/BzTree/NV-Tree/PACTree ihre PM-Zugriffe realisieren (`mmap()` + `MAP_SYNC` auf ein `/dev/pmemN`- bzw. DAX-gemountetes Dateisystem, typischerweise via PMDK/`libpmem`). Linux unterscheidet **fsdax** (DAX-Dateisystem, POSIX-Dateisemantik + Block-Allokation) von **devdax** (rohes Zeichen-Geraet, eine einzige statische Abbildung, keine Dateisemantik) — beide sind reale `ndctl`-Betriebsarten [LIT, Grundwissen aus der zitierten Literatur; keine einzelne Quelle noetig, ubiquitaer in FPTree/BzTree/RECIPE].
- **io_uring**: aktuelle Arbeit *"High-Performance DBMSs with io_uring: When and How to Use It"* (Jasny, El-Hindi, Ziegler, Leis, Binnig; arXiv:2512.04859, VLDB-Track, TU Darmstadt) [LIT, Autoren/Venue per WebFetch verifiziert; der konkrete Zahlenwert **"7-30 μs Strafe je Op"** fuer den `fsync`-Fallback-Worker-Pfad stammt aus der WebSearch-Zusammenfassung dieses Papers, der **Volltext selbst liess sich nicht dekomprimieren** — [NICHT GEPRUEFT im Wortlaut, aber plausibel und mit der bekannten io_uring-Architektur konsistent: `fsync` ist in io_uring blockierend und wird ueber Fallback-Kernel-Worker-Threads ausgefuehrt, da es nicht pollbar ist]]. Enterprise-SSDs mit Power-Loss-Protection (PLP) erreichen Mikrosekunden-Latenzen fuer echte Flushes, Consumer-SSDs bleiben im Millisekunden-Bereich dominiert [LIT, Search-Synthese].

### B.4 Ehrlicher Kontext: das Feld hat sich seit 2022 verschoben

Intel hat im **Juli 2022** das Ende aller Optane-Produkte (SSDs **und** Persistent-Memory-Module) angekuendigt; der offizielle Kunden-Abschiedsbrief datiert **Maerz 2023** [LIT: `pmem.io/announcements/2023/customer-letter-march-2023/`]. Das bedeutet konkret: **FPTree, BzTree, NV-Tree, LB+-Tree/"Persistent B+-Trees" und PACTree sind alle auf Hardware entstanden, die kommerziell nicht mehr verfuegbar ist.** Die Probleme, die diese Produktlinie loesen sollte (DRAM-Kapazitaets-Grenzen, langsame klassische Persistenz), sind laut Retrospektiven weiterhin ungeloest — die Forschungscommunity ist seither **explizit** in Richtung CXL abgewandert [LIT: mehrere Quellen inkl. SIGARCH-Blog "Persistent Memory – A New Hope"]. **Fuer diesen Auftrag heisst das:** eine ehrliche T19-Achse kann **keinen** Baustein bauen, der reales Optane/PMEM-Verhalten auf prod1/prod2 misst (sofern dort keine solche Hardware steckt, s. A.6 NICHT GEPRUEFT) — jeder `pmem_*`-Baustein muesste nach demselben, bereits im Objekt etablierten Muster **ehrlich als Staging/Emulation** deklariert werden, wie es `DiskWritebackTarget` fuer `disk_writeback` heute bereits tut (`has_device_writeback_path()==false`).

---

## TEIL C — VORSCHLAGS-SKIZZE: WIE DIE T19-ACHSE AUSSEHEN MUESSTE

### C.1 Design-Prinzip [EMPF]

Additiv, nicht ersetzend (Memory-Prinzip *"Hardware-Erweiterung ist additiv"* trifft hier sachlich zu, unabhaengig davon, dass es als Memory-Eintrag nicht bindend fuer mich ist): `memory_only` und `disk_writeback` bleiben unveraendert (byte-stabil, golden-neutral). Neue Varianten werden **angehaengt**, nicht umbenannt. Das bereits etablierte Ehrlichkeits-Flag-Muster (`has_device_writeback_path()`, Kommentar-Deklaration + `static_assert`-Erinnerung) wird auf jede neue Variante **fortgeschrieben** — das ist die staerkste, bereits im Code bewiesene Eigenschaft dieser Achse und sollte nicht durchbrochen werden.

### C.2 Varianten-Enum-Vorschlag

| Variante | Beschreibung | Durabilitaets-Klasse (B.2 Punkt 5) | `has_device_writeback_path()` | Hardware-Bedarf |
|---|---|---|---|---|
| `memory_only` *(bestehend)* | reines DRAM, kein Rueckschreibpfad | 0 — keine | n/a (kein Pfad zu melden) | keine |
| `disk_writeback` *(bestehend)* | Staging-Simulation, kein echtes Geraet | 1 — Staging-only | `false` (heute bereits so) | keine |
| `pmem_devdax` **[NEU]** | rohes DAX-Zeichengeraet, `mmap()`+`MAP_SYNC`, Baumdesign nach FPTree/BzTree/NV-Tree/PACTree (B.1) | 2 (ADR, Software-Flush) **oder** 3 (eADR, falls Plattform es traegt) | `true` **nur** auf realer PMEM-/eADR-Hardware, sonst ehrlich `false` | Optane-artiges NVDIMM ODER emuliert (s. B.4) — **[NICHT GEPRUEFT, ob prod1/prod2 sowas haben]** |
| `pmem_fsdax` **[NEU]** | DAX-Dateisystem (ext4-DAX/XFS-DAX), POSIX-Dateisemantik + Block-Allokations-Overhead on top von `pmem_devdax` | wie `pmem_devdax` | wie `pmem_devdax` | wie `pmem_devdax` |
| `nvme_io_uring` **[NEU]** | async Block-Device-Persistenz, `io_uring`-Ring + explizites `fsync`/NVMe-Flush-Completion (B.3) | 4 — Geraete-PLP-vermittelt | **realistisch `true` erreichbar**, da gewoehnliche NVMe-SSDs vorhanden sein duerften | gewoehnliche NVMe-SSD (wahrscheinlich vorhanden — **[NICHT GEPRUEFT]**) |
| `cxl_mem` **[Platzhalter, explizit als Zukunft markiert]** | CXL.mem-angebundener nichtfluechtiger Speicher (B.3) | je nach Geraet 2-4 | `false` bis reale Hardware existiert | CXL-3.0-faehiges nichtfluechtiges Geraet — heute [NICHT GEPRUEFT/hoechstwahrscheinlich nicht vorhanden] |

`pmem_devdax`/`pmem_fsdax` sind bewusst **zwei separate Varianten** statt einer mit Unter-Flag, weil sie in der Linux/`ndctl`-Realitaet echte, unterschiedliche Betriebsarten mit unterschiedlichem Overhead-Profil sind (B.3) — analog dazu, wie die Achse bereits heute zwei PT-Subaxis-Tags fuehrt (`residency_tag`/`writeback_tag`, [THESIS] `axis_persistence_target_subaxes_pt1_to_pt2.hpp:16-20`).

**Bezug zu A.5:** jede neue Variante sollte ihre Durabilitaets-Klasse **ueber** `platform::IStorageMedium::is_persistent()`/`kind()` erfragen koennen, statt eine zweite, parallele Hardware-Erkennung zu erfinden — das ist der naheliegende Ort, das bisher ungenutzte Interface **erstmals real anzuschliessen** [EMPF].

### C.3 Zielgroessen-Tabelle (Dokumentationsstil: Achse → Optimierungs-Eigenschaft → Mess-Kategorien → Parameter-Art → Last-Abhaengigkeit)

| Zielgroesse | Richtung | Mess-Kategorie (der 9 etablierten Kuerzel, B.2/§0.1-BEFUND) | Parameter-Art | Last-Abhaengigkeit |
|---|---|---|---|---|
| `persist_latency_per_op` | **MIN** | **LAT** (passt direkt — reine Wallclock-Latenz) | live messbar wie jede andere LAT-Zielgroesse | schlaegt **nur bei Schreiblast** durch (YCSB A/F); bei reinen Lesen (YCSB B/C) ist der Unterschied zwischen allen Varianten nahe Null — deckungsgleich mit dem Befund aller B.1-Paper |
| `write_amplification` | **MIN** | **passt auf KEINES der 9 Kuerzel sauber** — am naechsten "MEM" (Byte-Bewegung), aber MEM misst heute statischen Fussabdruck, nicht bewegte Bytes | **neue** Kategorie noetig, oder MEM-Definition erweitern | steigt mit Schreibgroesse UND mit Geraete-interner Blockgranularitaet (256 B bei Optane, s. B.2/B.4) — variantenspezifisch, nicht last-mustergetrieben |
| `recovery_time` | **MIN** | **LAT**, aber **Sonderform**: einmalig je Prozess-(Neu-)Start, NICHT je Operation | **keine** heutige Observer-/PMC-Kopplung deckt das — braucht einen Crash-and-Rebuild-Testharness, der heute nicht existiert | haengt von der **Datensatzgroesse** (Anzahl Records/Blaetter) ab, NICHT vom Lese/Schreib-Mix — andere Achse als die anderen vier |
| `flush_fence_count_per_op` | **MIN** | am naechsten den Observer-basierten (nicht PMC-basierten) Kategorien wie CLU — instrumentierbar als **Software-Zaehler**, nicht als perf-Counter | **natuerliche Erweiterung** eines bereits vorhandenen Feldes (s. C.6) | steigt streng mit Schreib-/Update-Anteil; bei `memory_only` konstant 0 |
| `durability_guarantee_level` | **MAX** | **keine der 9** — kein Laufzeit-Messwert, sondern eine **compile-time Ordinalklasse** (0-4, B.2 Punkt 5) | **neue Parameter-Art "CT-Flag"**, exaktes Vorbild `has_device_writeback_path()` | last-unabhaengig — reine Eigenschaft der Variante/Hardware-Kombination |

**Pareto-Empfehlung [EMPF], analog T18 `queuing_q2`:** `durability_guarantee_level` (MAX) steht in echtem Zielkonflikt zu `persist_latency_per_op` (MIN) — je staerker die Garantie (mehr/staerkere Flush-/Fence-Disziplin bzw. schwaechere Hardware-Unterstuetzung), desto hoeher die Latenz je Op. Das ist strukturell **dieselbe** Eager/Lazy-Spannung, die T18 bereits als Pareto (`batching` MAX vs. `staleness_tail_latency` MIN) fuehrt — nur eine Ebene tiefer (Software-Queue-Flush bei T18, Hardware-Persistenz-Flush bei T19). `persistence_target` sollte daher analog **`pareto=true`** tragen.

### C.4 Codeform des Vorschlags (reine Skizze — NICHTS hiervon wurde geschrieben/committet)

Ergaenzung des `CatalogAxis`-Enums (`axis_optimization_catalog.hpp:76-95`):
```cpp
enum class CatalogAxis : std::uint8_t {
    ... // T0..T18 unveraendert
    PersistenceTarget = 19, ///< T19 (Pareto — Durabilitaet vs. Persist-Latenz, analog T18)
};
inline constexpr std::size_t kCatalogAxisCount = 20;      // war 19
inline constexpr std::size_t kAxisObjectiveCount = 50;    // war 45, +5
```
Neue Zeile in `kAxisOptimizationCatalog` (Stil exakt nach `:250,255`):
```cpp
{CatalogAxis::PersistenceTarget, "T19", "persistence_target", /*source_line=*/0 /* KEIN BEFUND-Ursprung */,
 "LAT, MEM(*)", "CT (Binary-Wahl) + CT-Flag (Durabilitaetsklasse)", /*objective_begin=*/45, /*objective_count=*/5,
 /*pareto=*/true},
```
Fuenf neue Zeilen in `kAxisObjectives` (Stil exakt nach `:170-176,205-208`):
```cpp
// -- T19 persistence_target (NEU, kein BEFUND-Ursprung -- Deep-Research D-8, 2026-08-17) -------
{CatalogAxis::PersistenceTarget, "persist_latency_per_op", Minimize,
 "Persist-Latenz je Operation (Flush+Fence-Pfad bis zur Durabilitaets-Zusage)"},
{CatalogAxis::PersistenceTarget, "recovery_time", Minimize,
 "Wiederherstellungszeit nach Neustart (Funktion der Datensatzgroesse, NICHT der Op-Rate)"},
{CatalogAxis::PersistenceTarget, "write_amplification", Minimize,
 "Write-Amplification = physisch geschriebene / logisch geschriebene Bytes"},
{CatalogAxis::PersistenceTarget, "flush_fence_count_per_op", Minimize,
 "Zahl der CLWB/CLFLUSH(OPT)+SFENCE- bzw. fsync-aequivalenten Aufrufe je Operation"},
{CatalogAxis::PersistenceTarget, "durability_guarantee_level", Maximize,
 "Ordinalklasse 0(keine)..4(Geraete-PLP) -- compile-time Eigenschaft, kein Laufzeitmesswert"},
```
`source_line=0` ist bewusst **kein** BEFUND-Zeilenverweis (anders als alle 19 Bestandszeilen) — eine eigene Konvention waere noetig, z.B. Verweis auf **diesen** Deep-Research-Befund statt auf das 09.07.-Dokument [EMPF].

### C.5 Was am consteval-Anker konkret bricht, wenn das gebaut wird

`test_heuristik_spline_break_even.cpp:405-409` muesste **bewusst** umgeschrieben werden:
- `composition_names_with_catalog_row() == 17u` → **`== 18u`**
- die Zeile *"genau EINE Kompositions-Achse ohne Katalog-Zeile"* → **entfaellt** (Schnittmenge wird 18 von 18, keine Katalog-only-2/Komposition-only-1-Differenz mehr fuer diese Achse)

Das ist **beabsichtigt** — der Test ist als Drift-Waechter gebaut, nicht als Sperre; er bricht **laut**, sobald jemand die Zeile ergaenzt, und zwingt dazu, die Owner-Freigabe im selben Zug zu dokumentieren (genau die Funktion, die er laut Kopf-Kommentar hat).

### C.6 Instrumentierungs-Luecke ehrlich ausgewiesen [EMPF, wichtigster Einzelbefund von Teil C]

**Eine Katalogzeile allein macht diese Zielgroessen nicht real messbar.** Stand heute:
- `persist_latency_per_op` ist **sofort** live messbar — es ist eine gewoehnliche Wallclock-LAT-Messung, die Apparatur deckt LAT bereits vollstaendig ab (BEFUND §0.1).
- `flush_fence_count_per_op` hat einen **bereits vorbereiteten, aber toten** Anschlusspunkt: `PersistenceTargetSnapshot::device_flushes` [THESIS] `axis_persistence_target_observable.hpp:39`, Kommentar *"echte Geraete-Flushes; bleibt 0, solange kein Geraete-Pfad existiert"* — das Feld existiert exakt fuer diesen Zweck, zaehlt heute aber **niemals**. Eine reale `pmem_*`- oder `nvme_io_uring`-Variante muesste dieses Feld erstmals **tatsaechlich inkrementieren**.
- `write_amplification` und `recovery_time` haben **keinen** Anschlusspunkt im heutigen Observer-/Snapshot-Modell — sie brauchen neue Instrumentierung (ein Crash-and-Rebuild-Testharness fuer `recovery_time` existiert nirgends im durchsuchten Baum).
- `durability_guarantee_level` ist kein Messwert, sondern eine neue **statische** Kategorie (analog `has_device_writeback_path()`), braucht also gar keine Laufzeit-Instrumentierung, sondern nur eine neue `constexpr`-Methode je Baustein.

### C.7 Verhaeltnis zu ORG-19/W14/C-6 — Robustheit gegen beide Ausgaenge [EMPF]

Der Vorschlag oben ist absichtlich so geschnitten, dass er **unabhaengig** davon funktioniert, wie W14/C-6 entschieden wird:
- **Falls `persistence_target` (T17) neben ORG-19-IO bestehen bleibt** (die heutige Owner-Vorlage-Lesart, s. A.3): die T19-Katalogzeile beschreibt weiterhin exakt die bestehende Organ-Achse T17; K17 bleibt gepinnt, bis der Owner die Aufschaltung separat entscheidet.
- **Falls ORG-19-IO T17 ablöst/aufgehen laesst** (die KON80-V10-Lesart mit `store()`/`load()` auf Genus-Ebene): die fuenf Zielgroessen (Latenz, Recovery, WA, Flush-Count, Durabilitaetsklasse) bleiben **inhaltlich unveraendert relevant** — sie sind Eigenschaften *jeder* Persistenz-Loesung, unabhaengig davon, ob sie als Organ-Achse (`persistence_target`) oder als Genus-Meta-Meta (`store()`/`load()`) implementiert wird. Nur `t_id`/`CatalogAxis`-Zuordnung und die Kardinalitaets-Formel (2^17 vs. eine XML-opt-in-Meta-Meta-Multiplikation) muessten dann angepasst werden — das ist der Teil, den A.3 bewusst offenlaesst.

---

## QUELLEN (peer-reviewed bevorzugt)

1. Oukid, Lasperas, Nica, Willhalm, Lehner. **FPTree: A Hybrid SCM-DRAM Persistent and Concurrent B-Tree for Storage Class Memory.** SIGMOD 2016. https://dl.acm.org/doi/10.1145/2882903.2915251
2. Arulraj, Levandoski, Minhas, Larson. **BzTree: A High-Performance Latch-free Range Index for Non-Volatile Memory.** PVLDB 11(5):553-565, 2018. https://dl.acm.org/doi/10.1145/3164135.3164147
3. Yang, Wei, Chen, Wang et al. **NV-Tree: Reducing Consistency Cost for NVM-based Single Level Systems.** USENIX FAST 2015. https://www.usenix.org/conference/fast15/technical-sessions/presentation/yang
4. Chen, Jin. **Persistent B+-Trees in Non-Volatile Main Memory.** PVLDB 8(7):786-797, 2015. https://www.vldb.org/pvldb/vol8/p786-chen.pdf
5. Kim, Ramanathan, Fu, Kashyap, Min. **PACTree: A High Performance Persistent Range Index Using PAC Guidelines.** SOSP 2021. https://dl.acm.org/doi/10.1145/3477132.3483589 (Volltext: https://multics69.github.io/pages/pubs/pactree-kim-sosp21.pdf)
6. Lee, Kannan, Reddy, Kim, Min. **RECIPE: Converting Concurrent DRAM Indexes to Persistent-Memory Indexes.** SOSP 2019. https://dl.acm.org/doi/10.1145/3341301.3359635 (arXiv: https://arxiv.org/pdf/1909.13670)
7. Hao, Chandramouli. **Bf-Tree: A Modern Read-Write-Optimized Concurrent Larger-Than-Memory Range Index.** PVLDB 17(11):3442-3455, 2024. https://vldb.org/pvldb/vol17/p3442-hao.pdf
8. Arulraj, Pavlo, Dulloor. **Let's Talk About Storage & Recovery Methods for Non-Volatile Memory Database Systems.** SIGMOD 2015, S.707-722. https://dl.acm.org/doi/10.1145/2723372.2749441
9. Lersch, Hao, Oukid, Wang, Willhalm. **Evaluating Persistent Memory Range Indexes.** PVLDB 13(4):574-587, 2020. http://www.vldb.org/pvldb/vol13/p574-lersch.pdf (erweitert: https://arxiv.org/pdf/2201.13047)
10. Izraelevitz et al. **Basic Performance Measurements of the Intel Optane DC Persistent Memory Module.** arXiv:1903.05714, 2019. https://arxiv.org/pdf/1903.05714
11. Jasny, El-Hindi, Ziegler, Leis, Binnig. **High-Performance DBMSs with io_uring: When and How to Use It.** arXiv:2512.04859 (VLDB-Track). https://www.informatik.tu-darmstadt.de/media/systems/pdf_publications/iouring_vldb.pdf
12. **Optane Customer Letter, March 2023.** PMem.io. https://pmem.io/announcements/2023/customer-letter-march-2023/
13. **CXL Memory as Persistent Memory for Disaggregated HPC: A Practical Approach.** arXiv:2308.10714. https://arxiv.org/html/2308.10714
14. **Efficient Atomic Durability on eADR-Enabled Persistent Memory.** PACT 2022. https://dl.acm.org/doi/10.1145/3559009.3569676
15. Intel. **eADR: New Opportunities for Persistent Memory Applications.** https://software.intel.com/content/www/us/en/develop/articles/eadr-new-opportunities-for-persistent-memory-applications.html [Industrie-Dokumentation, nicht peer-reviewed — als Primaerquelle fuer die ADR/eADR-Terminologie zitiert, nicht fuer empirische Zahlen]

*(Nicht als belastbare Zahlenquelle verwendet, nur als Kontext-Groessenordnung markiert: CXL-Latenz-Blogs [eureka.patsnap.com, introl.com] — [NICHT GEPRUEFT, keine peer-reviewed Primaerquelle direkt verifiziert].)*

---

## GEPRUEFT / NICHT GEPRUEFT — GESAMT-AUSWEIS

**GEPRUEFT** (Fundstelle Datei:Zeile oder direkt per WebFetch/WebSearch mit Autor+Venue verifiziert):
- Gesamte T17/T19/T26-Nummernkreis-Aufloesung (A.0)
- K17=1-Pinnung, beide Bausteine, Ehrlichkeitsflags, `PersistenceTargetSnapshot` (A.1)
- Katalog-Luecke inkl. consteval-Anker-Mechanik, exaktes `AxisOptimizationInfo`-Schema (A.2)
- ORG-19-IO-Konzept (KON80-V10) + W14/C-6 als *registriert offen* (A.3) — die Existenz des Widerspruchs, nicht seine Aufloesung
- 18/19-Achsen-Historie (A.4)
- `platform/storage.hpp`/`StorageMediumKind` + 0-Konsumenten-Gegenprobe (A.5)
- Sechs der sieben Paper in B.1 mit Autoren/Venue/Kernzahlen (FPTree, BzTree, NV-Tree, Chen/Jin, PACTree, Bf-Tree, RECIPE)
- ADR/eADR-Persistenzdomaenen-Konzept (B.2 Punkt 5)
- Optane-Discontinuation-Datum + Kontext (B.4)
- Lersch-Survey-Metrikkatalog (per WebFetch direkt aus PDF, B.2 Punkte 2+4)

**NICHT GEPRUEFT** (explizit offen, nicht verschwiegen):
- Ob prod1/prod2 reale PMEM/Optane/CXL/eADR-Hardware besitzen — keine Fundstelle dazu erhoben; entscheidet, ob `pmem_*`/`cxl_mem` in C.2 je `has_device_writeback_path()==true` erreichen koennen oder dauerhaft Staging bleiben
- Exakte ns/GB-s-Zahlen fuer Optane-Latenz/Bandbreite (Volltext-PDF nicht dekomprimierbar; nur Abstract-Aussage "DRAM-Groessenordnung" bestaetigt)
- Exakter "7-30 μs"-Wortlaut des io_uring-Papers (nur ueber Search-Synthese, nicht per WebFetch-Volltext bestaetigt)
- CXL-Round-Trip-Latenzzahlen (70 ns / 150-300 ns) — nur aus Industrie-Blogs, keine peer-reviewed Primaerquelle direkt geprueft
- Inhaltliche Aufloesung von W14/C-6 selbst — ausserhalb des D-8-Auftrags, gehoert zu einem separaten "Explore am Objekt"
- Existenz/Inhalt des generierten `axis_persistence_target_flags.hpp` (CMake-generiert, im gelesenen Quellbaum nicht materialisiert)