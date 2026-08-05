# DEEP-RESEARCH-LENS A4: Cacheline-Stride — SOTA-Vergleich & Korpus-Abgleich

**Auftrag (Owner, abend-10 verbatim):** KF-6 ist das zu testende Kernfeature. Per Deep Research
ergruenden, wie andere Systeme variable Cacheline-/Stride-Groessen in Scan-/Latenz-Messpuffern
behandeln. Muster-Wahl liegt auf CEB-Laufzeit + Tier-Binary-CT; ALLE line_sizes (32/64/128/256)
muessen unterstuetzt sein, sofern HW-freigegeben.

**Scope-Hinweis:** Dies ist ein reiner Recherche-/Befund-Bericht. Es wurde KEIN Code veraendert.

---

## 1. Ist-Zustand am Objekt (Korpus-Fund, vor der Web-Recherche verifiziert)

### 1.1 Der konkrete OOB-Risikoort — `abi_adapter.hpp:454-468`

Woertliches Zitat (verifiziert per Read, Stand 2026-08-05):

```cpp
// Layout-Scan-Puffer (Segment 3): 16384 Datensaetze. LAYOUT-FIX (X-§4, 2026-06-04): kRecordSize=48
// (NICHT 64) — sonst fiele cache_line_aligned (aligned_stride=round_up(48,64)=64) mit aos_strict
// (Stride 48) zusammen und die Layout-Achse differenzierte nicht. [...] PFLICHT-OOB-SCHUTZ: der Puffer
// wird nach dem GRÖSSTMÖGLICHEN Stride (64) dimensioniert (kLbufBytes = kRecords*64 >= jeder Layout-Stride),
// sonst läse der CLA-Scan bei (kRecords-1)*64+4 über das Ende hinaus.
constexpr std::size_t kRecords    = 16384;
constexpr std::size_t kRecordSize = 48;
constexpr std::size_t kLbufBytes  = kRecords * 64; // OOB-Schutz: größtmöglicher Layout-Stride (64)
unsigned char* lbuf = static_cast<unsigned char*>(alloc.allocate(kLbufBytes, 64));
```

Der Kommentar benennt selbst korrekt das Prinzip "puffere fuer den groesstmoeglichen Stride" — aber
der Literal `64` ist **nicht** von der tatsaechlichen, an dieser Stelle massgeblichen Cacheline-Achse
abgeleitet, sondern von Hand eingetragen.

### 1.2 Der Verbraucher des Puffers — `axis_05_memory_layout_cache_line_aligned.hpp:58-69`

```cpp
[[nodiscard]] static std::uint64_t scan_field_sum(unsigned char const* buf, std::size_t n,
                                                  std::size_t record_size) noexcept {
    constexpr std::size_t kCacheLine     = 64;
    std::size_t const     aligned_stride = (record_size + kCacheLine - 1u) & ~(kCacheLine - 1u);
    std::uint64_t         s              = 0;
    for (std::size_t i = 0; i < n; ++i) {
        std::uint32_t v;
        std::memcpy(&v, buf + i * aligned_stride, sizeof(v)); // CLA: cache-line-gepaddeter Stride
        s += v;
    }
    return s;
}
```

`kCacheLine = 64` ist hier ein **zweites, unabhaengiges** Literal — nicht die permutierbare
Cacheline-Unterachse (`cacheline_config.hpp`), sondern der "intrinsische Design-Deskriptor" der
Layout-Strategie. Das ist **exakt die Falle**, die `cacheline_line_bytes.hpp` selbst dokumentiert
(Zeile 22-25, "bewusst dokumentiert ... 'Duplikat-Bug'"): `L::cache_line_size()` (bzw. hier der lokale
`kCacheLine`) darf nicht mit der permutierten Hardware-Line-Groesse verwechselt werden.

### 1.3 Die bereits gebaute Bruecke — `cacheline_line_bytes.hpp`

Diese Datei loest **bereits heute**, compile-time, dreistufig auf:

```cpp
template <typename T>
[[nodiscard]] constexpr std::size_t line_bytes_of() noexcept {
    if constexpr (CacheLineLineBytesAware<T>)      return T::cacheline_subaxis_line_bytes();
    else if constexpr (CacheLineConfigurable<T>)    return T::cacheline_config().line_size;
    else                                             return kDefaultLineBytes; // 64
}
static_assert(line_bytes_of<CacheLineAware<CacheLineConfig{CacheLineSize::B128}>>() == 128);
```

Der `static_assert` beweist: die Bruecke liefert schon jetzt **128 fuer eine B128-Config** — nur ist
noch **kein** Organ/Strategie im Repo mit einer Nicht-Default-`CacheLineConfig` verdrahtet (Kommentar
Zeile 16-20: "heute instanziieren alle Strategie-Basen die Default-CacheLineConfig{} (line_size = B64),
weil der Codegen die per-Organ-Config noch nicht als NTTP emittiert. Sobald KF-6 das tut, liefert
line_bytes_of<T>() OHNE weitere Aenderung den permutierten Wert").

**Konsequenz:** Der OOB liegt heute **schlafend**, nicht weil ein Guard ihn verhindert, sondern weil
zwei unabhaengige Stellen (`abi_adapter.hpp` UND `axis_05_...cache_line_aligned.hpp`) je einen
Hand-Literal `64` tragen, der noch nirgends durch `line_bytes_of<T>()` ersetzt wurde. Sobald KF-6
(a) den Codegen befaehigt, eine Nicht-Default-`CacheLineConfig` als NTTP zu emittieren, UND (b)
`cache_line_aligned::scan_field_sum` seinen lokalen `kCacheLine`-Literal durch `line_bytes_of<Self>()`
ersetzt, liest der Scan bei `line_size=256` und `kRecords=16384` bei Byte
`(16384-1)*256+4 = 4.194.308` — der Puffer ist aber nur `16384*64 = 1.048.576` Byte gross. Faktor 4
Overrun.

### 1.4 Das Profil erlaubt die Gefahrenzone bereits — `cacheline_study.profile.xml:74-87`

```xml
<axis ref="cacheline" per_organ="page_type node_type cache_traversal allocator">
  <line_size>64</line_size>
  <line_size>128</line_size>
  <line_size>256</line_size>
  <line_size>32</line_size>
  ...
</axis>
```

Die Werteliste `{64,128,256,32}` ist bereits Teil des aktiven Thesis-Profils (`cacheline_config.hpp`
Zeile 34, Wertraum `{B32,B64,B128,B256}`, 60 Konfigurationen, `all_configs()`). Das Owner-Ziel
"ALLE line_sizes muessen unterstuetzt sein" ist also **schon deklariert**, aber der Verbraucherpfad
(Abschnitt 1.1/1.2) haelt dem noch nicht stand.

### 1.5 Das Dispatch-Skelett — CEB/Tier-Binary via `PermDescriptor`

`ceb_generator.hpp` generiert je Permutation ein eigenstaendiges, dlopen-faehiges Modul
(`anatomy_module_loader.cpp`/`module_loader.cpp` laden per `dlopen`/`LoadLibrary`) mit einer festen
Export-Struktur:

```cpp
struct PermDescriptor {
    const char* id; const char* path; const char* axes;
    int (*run)(unsigned long, double*);
};
extern "C" COMDARE_PERM_EXPORT const PermDescriptor* comdare_perm_descriptor();
```

Das ist strukturell bereits das Ziel-Muster: **eine Binaerdatei pro NTTP-Permutation**, geladen
**einmal** durch den Orchestrator (CEB), danach ausschliesslich Funktionspointer-Aufruf — keine
Verzweigung im Hot Path. Siehe Abschnitt 4 fuer den Abgleich gegen SOTA-Analoga (glibc ifunc,
OpenBLAS `DYNAMIC_ARCH`).

---

## 2. SOTA-Web-Recherche — je System Befund + Quelle

### 2.1 lmbench / `lat_mem_rd` (Pointer-Chasing-Referenzbenchmark der Latenzmessung)

- Stride ist ein **Laufzeitparameter** (CLI: `lat_mem_rd len [stride...]`), Default `STRIDE = 512/sizeof(char*)`.
- Pointer-Chasing-Ring wird ueber `A[k] = (k+stride) % S` initialisiert, danach `p = *(char**)p` in
  entrollter Schleife durchlaufen.
- **Expliziter Bounds-Guard vor der Messschleife:** `if (range < stride) return;` — die Messung wird
  schlicht **nicht ausgefuehrt**, wenn der Adressraum kleiner als der gewaehlte Stride ist. Kein Retten
  durch groesseren Puffer, sondern ein hartes Preconditon-Gate.
- Fuer den "Thrash"/Page-Chase-Modus gibt es zusaetzlich eine explizite Validierung: die Chase-Page-Groesse
  muss `>= stride` sein, sonst Fehlermeldung `"Invalid chase page size %lu: must be >= stride"`.
- Quelle: [lmbench/src/lat_mem_rd.c (intel/lmbench, GitHub)](https://github.com/intel/lmbench/blob/master/src/lat_mem_rd.c); [lat_mem_rd(8) Manpage](https://lmbench.sourceforge.net/man/lat_mem_rd.8.html); [oscarlab/lmbench-2.5 doc](https://github.com/oscarlab/lmbench-2.5/blob/master/doc/lat_mem_rd.8)

**Bewertung fuer A4:** Das ist die praezise Antwort auf "wie vermeidet man OOB bei Stride-Parametrisierung":
ein **Precondition-Check unmittelbar vor der stride-abhaengigen Schleife**, nicht (nur) eine statisch
ueberdimensionierte Pufferannahme. Im CE-Code (Abschnitt 1.1) fehlt ein Analogon zu `if (range < stride)
return;` — es gibt nur den (aktuell zu klein bemessenen) statischen Puffer.

### 2.2 tinymembench (Negativ-Beleg: fehlender Guard als reales, verbreitetes Muster)

- `BLOCKSIZE`/Blockgroessen sind **compile-time Konstanten** je Testfunktion (z. B. `BLOCKSIZE = 2048`),
  die Puffer werden mit fixer `SIZE` (32 MB) bzw. `latbench_size = SIZE*2` alloziert.
- Innerste Schleife: `for (j = 0; j < size; j += blocksize)` — **setzt voraus**, dass `size` glatt durch
  `blocksize` teilbar ist; **kein** Modulo-/Restbehandlungscode.
- Fuer den Latenztest wird `testsize = 1 << nbits` verwendet, **ohne Validierung**, dass `testsize` die
  tatsaechliche Allokationsgroesse nicht ueberschreitet.
- Quelle: [tinymembench/main.c (ssvb/tinymembench, GitHub, per WebFetch verifiziert)](https://github.com/ssvb/tinymembench/blob/master/main.c); [Repo](https://github.com/ssvb/tinymembench); [Sysprogs-Fork](https://github.com/sysprog21/tinymembench)

**Bewertung fuer A4:** Wichtig als **Gegenbeleg**, nicht als Vorbild — tinymembench ist ein weit
verbreitetes, seit Jahren genutztes Benchmark-Tool, das **genau dieselbe Klasse Annahme** trifft wie der
CE-Code vor KF-6 (Puffer/Blockgroesse muessen "von Hand" zusammenpassen, kein Laufzeit-Guard). Das zeigt:
das CE-Risiko ist kein exotischer Fehler, sondern ein bekanntes, wiederkehrendes Muster in dieser
Werkzeugklasse — und damit ein Grund, es hier bewusst besser zu machen statt es zu kopieren.

### 2.3 Intel Memory Latency Checker (MLC)

- MLC ist Closed-Source (Intel-Binary); Interna sind nicht im Quelltext pruefbar (Transparenz-Einschraenkung,
  explizit vermerkt statt geraten).
- Dokumentiert/oeffentlich bekannt: Default-Line-Groesse 64 B, konfigurierbar; ab MLC v3.10 "full line
  access" als Default fuer alle Puffergroessen. Puffergroessen-Empfehlung der Nutzer-Community: Puffer
  muss kleiner als die zu testende Cache-Ebene und deutlich groesser als die naechstniedrigere Ebene sein
  (z. B. 19 KB fuer L1, 400 KB fuer L2, 8 MB fuer L3) — die Puffergroesse wird also **an der Ziel-Cache-Ebene
  ausgerichtet**, nicht an einem Stride-Literal.
- Quelle: [Measuring Cache Performance with Intel MLC (Medium, Z. Chen)](https://medium.com/@wrightchen/intel-memory-latency-checker-mlc-for-cache-testing-deep-dive-b8b2c30bacab); [Intel MLC v3.12 Download-Seite](https://www.intel.com/content/www/us/en/developer/articles/tool/intelr-memory-latency-checker.html)
- **Wichtige Korrektur/Praezisierung waehrend der Recherche:** Eine zunaechst gefundene CLI-Signatur
  (`-l/--line-size`, `-s/--stride`, Pointer-Chase-Formel `A[k]=(k+stride)%S`) stammt **nicht** von Intels
  echtem MLC, sondern von einem eigenstaendigen lmbench-Nachbau, der sich selbst explizit auf lmbench statt
  auf MLC bezieht: [FedeParola/memory-latency, README (per WebFetch verifiziert: "uses the same memory
  access pattern used by the memory latency test of lmbench")](https://github.com/FedeParola/memory-latency).
  Diese Fehlzuordnung wurde bewusst korrigiert, um keine falsche Quelle zu zitieren (Doktrin "nie raten").

**Bewertung fuer A4:** MLC selbst liefert (mangels Quelltext) keinen pruefbaren OOB-Beleg, aber die
Community-Praxis bestaetigt das gleiche Prinzip wie 2.1/2.7: **Puffergroesse wird aus einer echten,
gemessenen/deklarierten Obergrenze abgeleitet** (hier: Cache-Ebenen-Groesse), nicht aus einem kopierten
Literal.

### 2.4 pmbw (Parallel Memory Bandwidth Benchmark, T. Bingmann)

- Zugriffsgroessen sind **compile-time** an einzelne, spezialisierte C-Funktionen gebunden, per
  `REGISTER`-Makro mit Metadaten (Funktionsname, Zugriffsgroesse in Byte, Unroll-Faktor) —
  z. B. `REGISTER(cScanWrite64PtrSimpleLoop, 8, 8, 1)`, `REGISTER(cScanWrite32PtrSimpleLoop, 4, 4, 1)`,
  `REGISTER(cScanWrite128PtrSimpleLoop, 16, 16, 1)`.
- Jede Groesse hat ihre **eigene, per Typ-Cast (`uint32_t*`/`uint64_t*`) fest verdrahtete** Zugriffsfunktion;
  es gibt keinen dynamischen Stride-Parameter innerhalb einer Funktion.
- Quelle: [pmbw/funcs_c.h (bingmann/pmbw, GitHub, per WebFetch verifiziert)](https://github.com/bingmann/pmbw/blob/master/funcs_c.h); [Repo](https://github.com/bingmann/pmbw)

**Bewertung fuer A4:** Das ist strukturell **exakt das CEB/Tier-Binary-Muster** in Reinform, nur ohne
C++-Templates: **eine eigene, spezialisierte kompilierte Einheit pro Groesse**, statt ein universeller
Codepfad mit Laufzeit-Stride-Variable. pmbw waehlt die passende Funktion aus einer Registry aus — die
Auswahl passiert **ausserhalb** der heissen Schleife (Registrierung/Dispatch-Tabelle), genau wie CEB die
passende Tier-Binary auswaehlt/dlopen't statt innerhalb der Messung zu verzweigen.

### 2.5 likwid-bench

- Stride/Zugriffsmuster werden in `.ptt`-Benchmark-Definitionsdateien ueber `LOOP <n>` (Anzahl Updates je
  Iteration) und die Workgroup-Syntax `<affinity_domain>:<size>:<num_threads>:<chunk_size>:<stride>`
  spezifiziert (Laufzeit-CLI-Parameter, z. B. `likwid-bench -t stream_avx_fma -w S0:100MB:4:1:2`).
- Puffergroesse wird **aus der Workgroup-Spezifikation abgeleitet**: `Vektorlaenge = (Working-Set-Groesse in
  Byte) / (Datentypgroesse × Anzahl Streams)`; die Zugriffsschleife ist damit ueber
  `vector_length × type_size ≤ allocated_buffer_size` grundsaetzlich innerhalb der Allokation gehalten —
  die Grenze folgt rechnerisch der Spezifikation, ist kein separat mitgefuehrtes Literal.
- Quelle: [likwid-bench.md (RRZE-HPC/likwid, GitHub)](https://github.com/RRZE-HPC/likwid/blob/master/doc/applications/likwid-bench.md); [Likwid-Bench Wiki](https://github.com/RRZE-HPC/likwid/wiki/Likwid-Bench); [likwid-bench.c](https://github.com/RRZE-HPC/likwid/blob/master/bench/likwid-bench.c)

**Bewertung fuer A4:** Bestaetigt dasselbe Prinzip wie 2.3/2.8: **Puffergroesse als Funktion der aktiven
Konfiguration berechnen**, nicht als separates Literal pflegen. Genau das verletzt der CE-Code aktuell
(Abschnitt 1.1: `kLbufBytes = kRecords*64` ist ein gepflegtes Literal, keine Ableitung aus
`cacheline::all_configs()`/`line_bytes_of<T>()`).

### 2.6 Google Benchmark — `BENCHMARK_TEMPLATE` + `DoNotOptimize`

- `BENCHMARK_TEMPLATE`/`BENCHMARK(BM_Foo<T>)` registrieren **kompilierte Varianten pro Templat-Argument**;
  die Auswahl, welche Variante tatsaechlich **laeuft**, geschieht zur Laufzeit ueber
  `--benchmark_filter=<regex>` (z. B. `--benchmark_filter=BM_memcpy/32`).
- Fuer Groessen als Non-Type-Parameter musste die Bibliothek historisch einen Umweg nehmen: Groessen werden
  in `std::integral_constant<...>` verpackt, weil die Makros primaer Typ-Parameter sauber unterstuetzen
  (`BENCHMARK_TEMPLATE_INSTANTIATE_F(SizedFixture, Test, std::integral_constant<5>)`).
- `benchmark::DoNotOptimize(expr)` erzwingt, dass das Ergebnis eines Ausdrucks in Speicher/Register landet
  (Read/Write-Barriere fuer den Compiler) — verhindert Wegoptimieren des zu messenden Zugriffs, ist aber
  ein **Mess-Korrektheits-Mechanismus**, kein Stride-/OOB-Mechanismus.
- Quelle: [google/benchmark user_guide.md (per WebFetch verifiziert)](https://github.com/google/benchmark/blob/main/docs/user_guide.md); [google/benchmark GitHub](https://github.com/google/benchmark)

**Bewertung fuer A4:** Zwei getrennte Befunde. (a) Fuer die OOB-Frage liefert Google Benchmark **kein**
Muster (es ist kein Speicher-Stride-Werkzeug). (b) Fuer die Muster-Wahl-Frage (NTTP je Konfiguration +
Laufzeit-Auswahl) ist es eine **starke Bestaetigung des generellen Konzepts** "kompiliere alle Varianten,
waehle zur Laufzeit eine aus" — und zeigt zugleich, dass die **`CacheLineConfig`-als-strukturelles-NTTP**-Loesung
des CE-Codes (C++20 Klassentyp-NTTP mit defaultiertem `operator==`, `cacheline_config.hpp:45`) sauberer ist
als der `integral_constant`-Workaround, den Google Benchmark mangels C++20-NTTP-Unterstuetzung noch braucht.
Der `sink`-Akkumulator in `abi_adapter.hpp::run_workload` (Wert wird ueber alle vier Segmente akkumuliert und
zurueckgegeben) erfuellt bereits dieselbe Funktion wie `DoNotOptimize`/`ClobberMemory` — hier besteht **kein**
Aenderungsbedarf, nur eine Bestaetigung, dass dieser Teil bereits SOTA-konform ist.

### 2.7 Laufzeit-Cacheline-Erkennung (Systemebene, als Kontrastfolie zu CT)

Vollstaendiger, plattformuebergreifender Ueberblick (verifiziert per WebFetch):

| Plattform | Mechanismus | Konstante/API |
|---|---|---|
| Linux (POSIX) | `sysconf` | `_SC_LEVEL1_DCACHE_LINESIZE` |
| Linux (Fallback) | `/proc/cpuinfo` | `cache_alignment`, `clflush size` |
| x86 (roh) | CPUID Leaf 0x1 | EBX-Bits 15:8 × 8 |
| Windows | `GetLogicalProcessorInformationEx(RelationCache)` | `CACHE_DESCRIPTOR.LineSize` |
| macOS/BSD | `sysctlbyname` | `"hw.cachelinesize"` |
| ARM64 | Systemregister | `CTR_EL0`, Bits 19:16 → `2^(n+4)` |
| Portabel (HPC-Standard) | `hwloc`-Bibliothek | `hwloc_get_obj_by_type(...)->attr->cache.linesize`; auf Linux via `/sys/devices/system/.../cache/index*/line_size` |

Quelle: [Programmatically Get Cache Line Size Across All Platforms (w3tutorials.net, per WebFetch verifiziert)](https://www.w3tutorials.net/blog/programmatically-get-the-cache-line-size/); [hwloc topology-x86.c (open-mpi/hwloc, GitHub)](https://github.com/open-mpi/hwloc/blob/master/hwloc/topology-x86.c); [hwloc topology-linux.c](https://github.com/open-mpi/hwloc/blob/master/hwloc/topology-linux.c); [hwloc Doku](https://hwloc.readthedocs.io/en/stable/index.html)

**Bewertung fuer A4:** Dies ist die "andere Haelfte" der Design-Entscheidung, die der Owner bereits
getroffen hat (CT-Templates statt Runtime-Switch): all diese APIs liefern die **echte** Hardware-Zahl zur
Laufzeit, aber **keine** davon wird in einem Hot-Path-Branch verwendet — reale Systeme (hwloc-Konsumenten
wie MPI-Implementierungen, OpenMP-Runtimes) nutzen sie **einmalig bei Programm-/Prozessstart**, um danach
CT-artige, feste Entscheidungen zu treffen (Padding-Groessen, Thread-Placement). Das deckt sich mit dem
CEB-Modell: Laufzeit-Erkennung/-Entscheidung gehoert an die **Orchestrierungs-Grenze** (CEB waehlt/baut die
Tier-Binary), nicht in die gemessene innere Schleife.

### 2.8 `std::hardware_destructive_interference_size` — der Standard-Bibliotheks-Präzedenzfall

Dies ist der praeziseste Beleg fuer die Owner-Doktrin ("kein Runtime-Switch im Hot-Path"), direkt aus dem
C++-Committee-Prozess:

- **Design-Rationale (WG21 P0154R1):** Die Konstanten sind bewusst `constexpr`, weil sie mit `alignas()`
  genutzt werden sollen — und `alignas()` verlangt einen Compile-Time-Wert. Echte Laufzeit-Erkennung wurde
  im Papier diskutiert (Appendix), aber verworfen, weil sie "nicht portabel ueber Betriebssysteme/Architekturen"
  waere UND weil der Wert strukturelle Bedeutung hat (Objekt-Layout).
  Quelle: [P0154R1 (open-std.org, per WebFetch verifiziert)](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2016/p0154r1.html)
- **ABI-Zwang (GCC-Implementierungsdiskussion):** "program ABIs will depend on it" — sobald der Wert in
  Struct-Padding/Alignment einfliesst, bricht jede Aenderung Binaerkompatibilitaet mit zuvor kompiliertem
  Code. Der GCC-Patch macht den Wert daher **von `-mtune`/`-mcpu` beim Kompilieren abhaengig**, nicht von
  einer Laufzeitabfrage; fuer generische Ziel-CPUs mit heterogenen Line-Groessen empfiehlt der Patch
  explizit: *"the constructive size should probably be the minimum size, and the destructive size the
  maximum"* — also **dimensioniere den destruktiven (=OOB-relevanten) Wert nach dem groessten in Frage
  kommenden Fall**, nicht nach dem haeufigsten.
  Quelle: [gcc-patches Mailing-Liste, "c++: implement C++17 hardware interference size" (per WebFetch verifiziert)](https://www.mail-archive.com/gcc-patches@gcc.gnu.org/msg269055.html)
- **Reale Heterogenitaet als Kritikpunkt:** libstdc++/libc++ setzen beide pauschal `64`
  (`__GCC_DESTRUCTIVE_SIZE`); fuer generische ARM-Ziele empfiehlt Arm selbst
  `hardware_destructive_interference_size = 256` und `hardware_constructive_interference_size = 64` als
  konservative Bandbreite — waehrend einzelne reale Cores (z. B. Cortex-A9) nur 32 B Line-Groesse haben.
  Der Wert ist damit explizit ein **Kompromiss pro Compile-Target**, kein universeller Wahrheitswert.
  Quelle: [gcc-patches Re:-Thread (per WebSearch-Snippet, mail-archive.com)](https://www.mail-archive.com/gcc-patches@gcc.gnu.org/msg269338.html); [cppreference-Spiegel (docs.w3cub.com, per WebFetch verifiziert, da cppreference.com WebFetch mit 403 blockt)](https://docs.w3cub.com/cpp/thread/hardware_destructive_interference_size)

**Bewertung fuer A4:** Das ist der wichtigste Einzelbefund der Recherche. Der C++-Standard selbst loest das
"Line-Groesse variiert, darf aber nicht zur Laufzeit variieren"-Problem **genau so, wie die CE-Achse es tut**
— durch Festnageln als Compile-Time-Konstante pro Build/ABI-Einheit. Der einzige Unterschied: die
Standardbibliothek kann nur **einen einzigen globalen** Wert pro Prozess/ABI festlegen (daher der
unbefriedigende Kompromiss 64 bzw. 256), waehrend die CE-Architektur (NTTP je Organ, gebacken in eine
**eigene** Tier-Binary je Permutation) das **praeziser** kann: jede Tier-Binary ist ihre eigene, in sich
geschlossene ABI-Insel, sodass unterschiedliche Line-Groessen in unterschiedlichen Tier-Binaries koexistieren
koennen, ohne den globalen Kompromiss der Standardbibliothek einzugehen. Der GCC-Patch-Ratschlag
("destructive size = maximum of the range") ist zugleich die exakte Formel fuer den korrekten Fix von
Abschnitt 1.1: der Puffer muss nach dem **groessten aktuell freigegebenen** `line_size`-Wert dimensioniert
werden — nicht nach einem historischen `64`.

### 2.9 "NTTP-Familie + einmalige Laufzeit-Auswahl" als etabliertes Meta-Muster (drei unabhaengige Belege)

Drei technisch unabhaengige, weit verbreitete Systeme loesen "viele Hardware-Varianten, aber kein
Runtime-Branch im Hot Path" strukturell **identisch** zum CEB/Tier-Binary-Muster:

1. **glibc IFUNC / GCC Function Multi-Versioning:** Mehrere Implementierungen derselben Funktion werden
   kompiliert; ein **Resolver laeuft genau einmal**, beim Laden des Programms/der Bibliothek durch den
   Dynamic Loader, waehlt anhand CPUID die passende Variante, und **danach ist die Wahl fuer die Lebensdauer
   des Prozesses fixiert** — jeder weitere Aufruf geht direkt (kein Re-Check). Genau dieses Muster nutzt
   glibc produktiv fuer praktisch alle performance-kritischen Funktionen (`memcpy`, `strlen`, ...).
   Quelle: [Function multi-versioning in GCC 6 (LWN.net)](https://lwn.net/Articles/691932/); [GNU indirect function (MaskRay-Blog)](https://maskray.me/blog/2021-01-18-gnu-indirect-function); [The Linux Concept Journey — IFUNC (Medium, S. Boutnaru)](https://medium.com/@boutnaru/the-linux-concept-journey-ifunc-indirect-function-0c74a75b38a8)
2. **OpenBLAS `DYNAMIC_ARCH`:** Kompiliert vorab **einen Kernel-Satz pro Ziel-Mikroarchitektur**
   (SSE/AVX2/AVX512/...); zur Laufzeit erkennt eine CPUID-Routine die tatsaechliche CPU und setzt einen
   globalen Funktionszeiger-Tabellen-Zeiger (`gotoblas_t`) **einmal** — alle folgenden BLAS-Aufrufe gehen
   direkt ueber diese Tabelle.
   Quelle: [OpenMathLib/OpenBLAS Developer Manual](http://www.openmathlib.org/OpenBLAS/docs/developers/); [DeepWiki OpenBLAS Kernel Implementations](https://deepwiki.com/OpenMathLib/OpenBLAS/4-kernel-implementations)
3. **FFTW Codelets + Wisdom-Planner:** `genfft` generiert vorab viele kleine, groessenspezifische
   C-"Codelets" (analog: eine kompilierte Einheit je Konfiguration). Ein **Planner misst zur Laufzeit** (oder
   nutzt gespeicherte "Wisdom" aus einer frueheren Messung) und waehlt/komponiert daraus einen Ausfuehrungsplan
   — die eigentliche Transformationsschleife danach ruft nur noch die gewaehlten Codelets direkt auf, ohne
   weitere Messung/Verzweigung.
   Quelle: [The Design and Implementation of FFTW3 (Frigo/Johnson, fftw.org)](https://www.fftw.org/fftw-paper-ieee.pdf); [Words of Wisdom — Saving Plans (FFTW 3.3.10 Doku)](https://www.fftw.org/fftw3_doc/Words-of-Wisdom_002dSaving-Plans.html)

**Bewertung fuer A4:** Diese drei Systeme sind **die** einschlaegigen Praezedenzfaelle fuer exakt das
Owner-Zielmuster "CEB-Laufzeit + Tier-Binary-CT": kompiliere die Konfigurationsvielfalt vollstaendig vorab
(NTTP/Codelet/Kernel-Variante), triff die Auswahl **genau einmal ausserhalb** der gemessenen/heissen Schleife
(Resolver/Planner/CEB), und lass danach nur noch einen direkten, unverzweigten Aufruf zu. Der CEB/`PermDescriptor`/
`dlopen`-Mechanismus (Abschnitt 1.5) ist strukturell ein Analogon zum ifunc-Resolver bzw. zu OpenBLAS'
`gotoblas_t`-Tabelle — nur auf Prozess-/Modul-Ebene statt auf Symbol-Ebene.

### 2.10 Policy-based Design — die Namensgebung des bereits verwendeten Idioms

`cacheline_config.hpp`s `CacheLineAware<Cfg>` (CRTP-Mixin, `Cfg` als strukturelles NTTP) ist das klassische
C++-Idiom **Policy-based Design** (Alexandrescu): Verhalten wird als Compile-Time-Parameter injiziert,
wodurch der Compiler vollstaendig spezialisieren kann (keine virtuelle Dispatch-Kosten, keine
Laufzeit-Verzweigung). `node_width_config.hpp` bestaetigt das explizit als bewusst wiederverwendetes
Muster ("Muster = die bestehende cacheline-Unterachse ... exakt gespiegelt").

Quelle: [Policy-based design pattern (Medium, A. Kr)](https://medium.com/@abhishek.kr121/policy-based-design-pattern-ac902df38c20); [Traits and Policies in C++ (Software Patterns Lexicon)](https://softwarepatternslexicon.com/patterns-cpp/9/2/); [The problem with policy-based design (foonathan.net) — Grenzen/Kompositionskosten des Musters](https://www.foonathan.net/2017/02/policy-based-design-problem/)

**Bewertung fuer A4:** Reine Bestaetigung/Einordnung — kein neuer Handlungsbedarf. Nennenswert ist der
`foonathan.net`-Gegenpunkt: Policy-based Design mit **vielen unabhaengigen Achsen** (wie hier: line_size ×
alignment × sw_hint = 60, plus node_width, plus die uebrigen 17 Organ-Achsen) kann kombinatorisch explodieren
— exakt das Risiko, das die eigene Doku bereits als "bis 60^4 (beabsichtigt)" benennt
(`cacheline_study.profile.xml:67`). Das ist kein A4-spezifischer Befund, aber eine Bestaetigung, dass die
combinatorial-coverage-Frage (bereits als eigenes Thema im Korpus behandelt, `combinatorial_coverage.hpp`)
kein Nebenschauplatz ist.

---

## 3. Synthese — wie vermeiden SOTA-Systeme OOB bei Stride-Parametrisierung?

Drei komplementaere, in der Recherche wiederholt belegte Strategien (keine schliesst die anderen aus):

1. **Explizites Precondition-Gate unmittelbar vor der stride-abhaengigen Schleife** (lmbench,
   `if (range < stride) return;`, Abschnitt 2.1). Guenstig, lokal, aber nur so gut wie seine Platzierung —
   muss an JEDER Stelle stehen, die den Stride konsumiert.
2. **Puffergroesse als abgeleitete Funktion der aktiven Konfiguration bzw. ihrer deklarierten Obergrenze**,
   nicht als separat gepflegtes Literal (likwid-bench: `vector_length` aus Working-Set/Typgroesse berechnet,
   Abschnitt 2.5; GCC/ARM-`-mtune`-Empfehlung: destruktive Groesse = Maximum des unterstuetzten Bereichs,
   Abschnitt 2.8). Das ist die robustere, generalisierbare Strategie, weil sie **eine** Quelle der Wahrheit
   erzwingt statt an N Stellen synchron zu halten.
3. **Granularitaet als Compile-Time-Konstante pro Build-/ABI-Einheit fixieren**, statt sie ueberhaupt zur
   Laufzeit variieren zu lassen (`std::hardware_destructive_interference_size`, Abschnitt 2.8; pmbw:
   eine Funktion pro Groesse, Abschnitt 2.4). Das entspricht bereits der Owner-Doktrin und dem gewaehlten
   Muster (NTTP je Organ/Tier-Binary) — vermeidet die Gefahr an der Wurzel, weil "Stride variiert zur
   Laufzeit" in dieser Architektur gar nicht erst vorkommt (der Stride ist innerhalb einer Tier-Binary immer
   fix).
4. **Negativ-Beleg (Warnung, kein Muster zum Uebernehmen):** tinymembench zeigt, dass das Fehlen von (1)
   oder (2) ein reales, verbreitetes und seit Jahren toleriertes Risiko in genau dieser Werkzeugklasse ist
   (Abschnitt 2.2) — kein hypothetisches Problem.

---

## 4. Korpus-Abgleich — passt "NTTP je line_size + CEB-Laufzeit-Wahl der Instanz"?

**Ja, strukturell — mit einer offenen Konkret-Luecke an der zitierten Stelle.**

| Aspekt | SOTA-Beleg | Korpus-Ist |
|---|---|---|
| Grundmuster (viele CT-Varianten, 1x Auswahl ausserhalb Hot Path) | ifunc / OpenBLAS `DYNAMIC_ARCH` / FFTW-Codelets+Wisdom (2.9) | `CacheLineAware<Cfg>` NTTP-Mixin + CEB/`PermDescriptor`/`dlopen` (1.3, 1.5) — **strukturell deckungsgleich** |
| NTTP-Konfig als eigener Struct-Typ statt `integral_constant`-Workaround | Google Benchmark braucht `integral_constant`-Wrapping fuer Groessen (2.6) | `CacheLineConfig` ist bereits ein C++20-Klassentyp-NTTP mit defaultiertem `operator==` (`cacheline_config.hpp:45`) — **sauberer als das SOTA-Workaround** |
| Line-Groesse als fixe Compile-Time-Konstante statt Laufzeit-Variable | `hardware_destructive_interference_size` (2.8), pmbw (2.4) | genau das gewaehlte Muster — **deckungsgleich, sogar praeziser** (pro Tier-Binary statt pro Prozess) |
| Puffer folgt der wahren deklarierten Obergrenze, nicht einem Literal | likwid-bench (2.5), GCC/ARM "-mtune max" (2.8) | `kLbufBytes = kRecords*64` ist ein **gepflegtes Literal**, nicht aus `cacheline::all_configs()`/`line_bytes_of<T>()` abgeleitet — **verletzt das Prinzip** (Abschnitt 1.1) |
| Precondition-Gate vor stride-abhaengiger Schleife | lmbench `if (range < stride) return;` (2.1) | **kein Analogon vorhanden**; Schutz beruht ausschliesslich auf dem (aktuell zu kleinen) statischen Puffer |
| Mess-Korrektheit (Anti-DCE) | `DoNotOptimize`/`ClobberMemory` (2.6) | `sink`-Akkumulator-Kette in `run_workload` — **bereits SOTA-konform, kein Handlungsbedarf** |

**Kernaussage:** Die vom Owner gewaehlte Architektur (NTTP je Organ + CEB waehlt die passende Tier-Binary)
ist durch mindestens drei unabhaengige, produktiv genutzte SOTA-Systeme (glibc, OpenBLAS, FFTW) als
tragfaehiges Muster belegt und in einem Punkt (strukturelles NTTP statt `integral_constant`-Wrapper) sogar
moderner als das, was Google Benchmark aus C++03/11-Zeiten mitschleppt. Das konkrete Risiko liegt **nicht**
im gewaehlten Muster, sondern in einer **einzelnen, isolierten Verletzung** des Musters an der vom Owner
selbst benannten Stelle: `kLbufBytes` in `abi_adapter.hpp:462-463` ist (noch) ein von Hand kopierter Literal
`64` statt einer Ableitung aus derselben Achsen-Quelle, die `cacheline_line_bytes.hpp` bereits bereitstellt
— und genau diese Achsen-Bruecke ist die eigene, bereits dokumentierte Schnitt-Regel des Korpus ("ALLE
Achsen-Eigenschaften duerfen nur ueber die Achse abgebildet werden", `cacheline_line_bytes.hpp:12-14`),
die an dieser einen Stelle noch nicht angewendet wird. Zusaetzlich fehlt ein lmbench-analoges
Precondition-Gate als zweite, unabhaengige Verteidigungslinie.

Die zweite, davon getrennte Beobachtung (Abschnitt 1.2/1.3): `axis_05_memory_layout_cache_line_aligned.hpp`s
eigener `kCacheLine=64`-Literal ist heute **noch nicht** an die permutierte Cacheline-Achse angebunden
(die eigene Doku nennt das explizit "Duplikat-Bug"-Falle) — das bedeutet, der OOB ist aktuell **schlafend**
(die 60 Profil-Konfigurationen mit B128/B256 differenzieren an dieser Scan-Stelle noch nicht), wird aber mit
KF-6 (Codegen emittiert Nicht-Default-`CacheLineConfig` als NTTP) und einer parallelen Anbindung von
`cache_line_aligned::scan_field_sum` an `line_bytes_of<T>()` unmittelbar scharf.

---

## 5. Quellen (vollstaendig, mit Zugriffsart)

- lmbench `lat_mem_rd.c`: https://github.com/intel/lmbench/blob/master/src/lat_mem_rd.c (WebFetch)
- lat_mem_rd(8) Manpage: https://lmbench.sourceforge.net/man/lat_mem_rd.8.html (WebSearch)
- oscarlab/lmbench-2.5 Doku: https://github.com/oscarlab/lmbench-2.5/blob/master/doc/lat_mem_rd.8 (WebSearch)
- tinymembench `main.c`: https://github.com/ssvb/tinymembench/blob/master/main.c (WebFetch)
- tinymembench Repo: https://github.com/ssvb/tinymembench (WebSearch)
- Measuring Cache Performance with Intel MLC (Medium): https://medium.com/@wrightchen/intel-memory-latency-checker-mlc-for-cache-testing-deep-dive-b8b2c30bacab (WebFetch)
- Intel MLC v3.12: https://www.intel.com/content/www/us/en/developer/articles/tool/intelr-memory-latency-checker.html (WebSearch)
- FedeParola/memory-latency (lmbench-Nachbau, NICHT MLC — Fehlzuordnung korrigiert): https://github.com/FedeParola/memory-latency (WebFetch)
- pmbw `funcs_c.h`: https://github.com/bingmann/pmbw/blob/master/funcs_c.h (WebFetch)
- pmbw Repo: https://github.com/bingmann/pmbw (WebSearch)
- likwid-bench Doku: https://github.com/RRZE-HPC/likwid/blob/master/doc/applications/likwid-bench.md (WebFetch)
- Likwid-Bench Wiki: https://github.com/RRZE-HPC/likwid/wiki/Likwid-Bench (WebFetch)
- likwid-bench.c: https://github.com/RRZE-HPC/likwid/blob/master/bench/likwid-bench.c (WebSearch)
- Google Benchmark User Guide: https://github.com/google/benchmark/blob/main/docs/user_guide.md (WebFetch)
- Google Benchmark Repo/benchmark.h: https://github.com/google/benchmark/blob/main/include/benchmark/benchmark.h (WebSearch)
- Programmatically Get Cache Line Size Across All Platforms: https://www.w3tutorials.net/blog/programmatically-get-the-cache-line-size/ (WebFetch)
- hwloc `topology-x86.c`: https://github.com/open-mpi/hwloc/blob/master/hwloc/topology-x86.c (WebSearch)
- hwloc `topology-linux.c`: https://github.com/open-mpi/hwloc/blob/master/hwloc/topology-linux.c (WebSearch)
- hwloc Doku: https://hwloc.readthedocs.io/en/stable/index.html (WebSearch)
- P0154R1 (WG21, hardware interference size): https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2016/p0154r1.html (WebFetch)
- GCC-Patch-Diskussion "c++: implement C++17 hardware interference size": https://www.mail-archive.com/gcc-patches@gcc.gnu.org/msg269055.html (WebFetch)
- GCC-Patch Re:-Thread (ARM-Werte, ABI-Kompatibilitaet): https://www.mail-archive.com/gcc-patches@gcc.gnu.org/msg269338.html (WebSearch)
- cppreference-Spiegel (cppreference.com selbst blockte WebFetch mit HTTP 403): https://docs.w3cub.com/cpp/thread/hardware_destructive_interference_size (WebFetch)
- Function multi-versioning in GCC 6 (LWN.net): https://lwn.net/Articles/691932/ (WebSearch)
- GNU indirect function (MaskRay-Blog): https://maskray.me/blog/2021-01-18-gnu-indirect-function (WebSearch)
- The Linux Concept Journey — IFUNC (Medium): https://medium.com/@boutnaru/the-linux-concept-journey-ifunc-indirect-function-0c74a75b38a8 (WebSearch)
- OpenBLAS Developer Manual: http://www.openmathlib.org/OpenBLAS/docs/developers/ (WebSearch)
- DeepWiki OpenBLAS Kernel Implementations: https://deepwiki.com/OpenMathLib/OpenBLAS/4-kernel-implementations (WebSearch)
- The Design and Implementation of FFTW3 (Frigo/Johnson): https://www.fftw.org/fftw-paper-ieee.pdf (WebSearch)
- FFTW Words of Wisdom — Saving Plans: https://www.fftw.org/fftw3_doc/Words-of-Wisdom_002dSaving-Plans.html (WebSearch)
- Policy-based design pattern (Medium): https://medium.com/@abhishek.kr121/policy-based-design-pattern-ac902df38c20 (WebSearch)
- Traits and Policies in C++ (Software Patterns Lexicon): https://softwarepatternslexicon.com/patterns-cpp/9/2/ (WebSearch)
- The problem with policy-based design (foonathan.net): https://www.foonathan.net/2017/02/policy-based-design-problem/ (WebSearch)

### Korpus-Quellen (lokal, per Read verifiziert)

- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/anatomy/abi_adapter.hpp` (Zeilen 434-520, insb. 454-468)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/axes/cacheline/cacheline_config.hpp`
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/axes/cacheline/cacheline_line_bytes.hpp`
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/axes/cacheline/node_width_config.hpp`
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/axes/layout/axis_05_memory_layout_cache_line_aligned.hpp`
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/algorithm_profiles/thesis_profiles/cacheline_study.profile.xml`
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/builder/experiment_tree/ceb_generator.hpp` (PermDescriptor-Ausschnitt)
