# x86-SIMD-Befehlssatz-Flags — Referenz fuer die Maschinen-Signatur und Organ-Sinnhaftigkeit (§40.a)

> Quellen-belegtes Referenzdokument (Web-Recherche via Opus-Agent, 2026-07-19, User-Auftrag §40.a).
> **LIVE-VERIFIZIERT auf prod1 (Zen 5, 19.07.):** die in Abschnitt 4 vorhergesagte Signatur stimmt zu 100% mit
> `/proc/cpuinfo` ueberein — alle 13 avx512-Flags inkl. `avx512_vp2intersect`, exakte Unterstrich-Schreibweisen
> (avx512vbmi OHNE / avx512_vbmi2 MIT), KEIN `avx512_fp16`; Begleiter `avx avx2 fma f16c avx_vnni gfni vaes
> vpclmulqdq bmi1 bmi2 abm movbe pni popcnt sse4a` komplett. Konsumenten: System-Registry (Maschinen-Signatur),
> Organ-Registry (isa-required/optional je Algorithmus-Variante), Planer-Resolver (§40.a-Schnitt), CompileFn-Flag-Bundles.

## 0. KRITISCH: Namens-Inkonsistenz der cpuinfo-Flags (Unterstrich-Falle)

Die Linux-`cpuinfo`-Namen sind **nicht** einheitlich gebildet. Historisch aeltere Subsets tragen **keinen** Unterstrich nach `avx512`, die spaeter hinzugefuegten **einen**. Das ist kein Tippfehler, sondern der reale Kernel-String. Wer die Signatur per String-Vergleich parst, muss das exakt so uebernehmen:

| Ohne Unterstrich (aeltere Subsets) | Mit Unterstrich (neuere Subsets) |
|---|---|
| `avx512f` `avx512cd` `avx512vl` `avx512dq` `avx512bw` `avx512ifma` `avx512vbmi` `avx512er` `avx512pf` | `avx512_vbmi2` `avx512_vnni` `avx512_bitalg` `avx512_vpopcntdq` `avx512_vp2intersect` `avx512_bf16` `avx512_fp16` `avx512_4vnniw` `avx512_4fmaps` |

Merkregel: `vbmi` ohne, `vbmi2` mit Unterstrich. Der Kernel leitet den `cpuinfo`-String aus dem Kommentar hinter `#define X86_FEATURE_*` ab; wenn dort ein `"..."`-String steht, ist genau das der angezeigte Name.

---

## 1. AVX-512-Flag-Familie (512-bit, EVEX-kodiert) — vollstaendig

CPUID-Notation: `(Leaf, Subleaf):Register[Bit]`. AVX-512-Basis liegt in `(7,0)`; die AVX10/Neuzugaenge teils in `(7,1)`.

| Subset | Offizieller Name | CPUID-Bit | cpuinfo | GCC/Clang-Flag | Kann |
|---|---|---|---|---|---|
| **F** | AVX-512 Foundation | `(7,0):EBX[16]` | `avx512f` | `-mavx512f` | EVEX-Basis: 512-bit ZMM0–31, 8 Maskenregister k0–k7, Embedded-Broadcast, 32-bit/64-bit-Float+Int auf 512 bit |
| **CD** | Conflict Detection | `(7,0):EBX[28]` | `avx512cd` | `-mavx512cd` | `VPCONFLICT`/`VPLZCNTD` — erkennt Duplikate in Index-Vektoren, macht Loops mit Konflikten vektorisierbar |
| **ER** | Exponential & Reciprocal | `(7,0):EBX[27]` | `avx512er` | `-mavx512er` | Nur Xeon Phi (KNL/KNM). exp2, rcp28, rsqrt28. In GCC 14+ entfernt |
| **PF** | Prefetch | `(7,0):EBX[26]` | `avx512pf` | `-mavx512pf` | Nur Xeon Phi. Gather/Scatter-Prefetch. In GCC 14+ entfernt |
| **VL** | Vector Length Extensions | `(7,0):EBX[31]` | `avx512vl` | `-mavx512vl` | Alle EVEX-Ops auch auf XMM(128)/YMM(256) mit Maskierung — auf Zen ohne Frequenz-Malus |
| **DQ** | Doubleword & Quadword | `(7,0):EBX[17]` | `avx512dq` | `-mavx512dq` | 32-/64-bit-Integer-Ops, Masken-nach-Vektor-Konvertierung, `VPMULLQ` |
| **BW** | Byte & Word | `(7,0):EBX[30]` | `avx512bw` | `-mavx512bw` | 8-/16-bit-Integer, 64-bit-breite Maskenregister, `VPCMP*B/W` |
| **IFMA** | Integer Fused Multiply-Add | `(7,0):EBX[21]` | `avx512ifma` | `-mavx512ifma` | `VPMADD52LUQ/HUQ` — 52-bit-Integer-FMA (Big-Integer/Krypto) |
| **VBMI** | Vector Bit Manipulation Instr. | `(7,0):ECX[1]` | `avx512vbmi` | `-mavx512vbmi` | `VPERMB` (Byte-Permutation ueber ganzes Register), `VPMULTISHIFTQB` |
| **VBMI2** | Vector Bit Manipulation Instr. 2 | `(7,0):ECX[6]` | `avx512_vbmi2` | `-mavx512vbmi2` | `VPCOMPRESS`/`VPEXPAND` byte/word, Funnel-Shift `VPSHLD/VPSHRD` |
| **VNNI** | Vector Neural Network Instr. | `(7,0):ECX[11]` | `avx512_vnni` | `-mavx512vnni` | `VPDPBUSD`/`VPDPWSSD` — int8/int16 Dot-Product-mit-Akkumulation in einem Befehl |
| **BITALG** | Bit Algorithms | `(7,0):ECX[12]` | `avx512_bitalg` | `-mavx512bitalg` | `VPOPCNTB/W` (Popcount pro Byte/Word), `VPSHUFBITQMB` |
| **VPOPCNTDQ** | Vector Population Count D/Q | `(7,0):ECX[14]` | `avx512_vpopcntdq` | `-mavx512vpopcntdq` | `VPOPCNTD/Q` — Popcount pro 32/64-bit-Lane |
| **VP2INTERSECT** | Vector Pair Intersection | `(7,0):EDX[8]` | `avx512_vp2intersect` | `-mavx512vp2intersect` | `VP2INTERSECTD/Q` — paarweiser Schnitt zweier Vektoren → **Maskenpaar** |
| **BF16** | BFloat16 | `(7,1):EAX[5]` | `avx512_bf16` | `-mavx512bf16` | bfloat16 Dot-Product + Konvertierung (KI-Beschleunigung) |
| **FP16** | Half-Precision FP | `(7,0):EDX[23]` | `avx512_fp16` | `-mavx512fp16` | Volle IEEE-binary16-Arithmetik (nicht nur Konvertierung) |
| **4VNNIW** | (Xeon-Phi) VNNI Word var. prec. | `(7,0):EDX[2]` | `avx512_4vnniw` | `-mavx5124vnniw` | Nur Knights Mill. 4-fach-iteriertes VNNI-Word. GCC 14+ entfernt |
| **4FMAPS** | (Xeon-Phi) FMA Packed Single | `(7,0):EDX[3]` | `avx512_4fmaps` | `-mavx5124fmaps` | Nur Knights Mill. 4-fach-iteriertes Single-FMA. GCC 14+ entfernt |

### EVEX/VEX-Begleiter (nicht streng AVX-512, aber mit ZMM nutzbar)
Diese drei haben je eine **VEX-Form** (128/256 bit) **und** eine **EVEX-Form** (512 bit, wenn zusammen mit AVX-512F/VL/BW vorhanden). Deshalb tauchen sie auch auf reinen AVX2-CPUs auf:

| Subset | Offizieller Name | CPUID-Bit | cpuinfo | GCC/Clang-Flag | Kann |
|---|---|---|---|---|---|
| **GFNI** | Galois Field New Instructions | `(7,0):ECX[8]` | `gfni` | `-mgfni` | Affine Transformationen ueber GF(2^8), `GF2P8AFFINEQB` — Bit-Matrix-Multiply, Krypto, Bit-Permutation |
| **VAES** | Vector AES | `(7,0):ECX[9]` | `vaes` | `-mvaes` | AES-Runden auf 256/512-bit-Vektoren (mehrere Bloecke parallel) |
| **VPCLMULQDQ** | Vector Carry-less Multiply | `(7,0):ECX[10]` | `vpclmulqdq` | `-mvpclmulqdq` | Carry-less-Multiply auf 256/512 bit — GHASH, CRC, Reed-Solomon, Hashing |

---

## 2. AVX / AVX2-Familie (256-bit, VEX-kodiert)

Diese Ebene ist auf allen modernen x86 quasi **universell** (Intel seit Haswell 2013, AMD seit Zen 1 2017). Grund: Sie ist Bestandteil der x86-64-v3-Baseline und wurde nie fused-off; ein Ziel-Binary fuer den ganzen Cluster kann AVX2+FMA+F16C voraussetzen.

| Subset | Offizieller Name | CPUID-Bit | cpuinfo | GCC/Clang-Flag | Kann |
|---|---|---|---|---|---|
| **AVX** | Advanced Vector Extensions | `(1):ECX[28]` | `avx` | `-mavx` | 256-bit-YMM Float, VEX-Kodierung (3-Operand, non-destructive) |
| **AVX2** | Advanced Vector Extensions 2 | `(7,0):EBX[5]` | `avx2` | `-mavx2` | 256-bit-Integer, `VPGATHER*` (Gather), variable Per-Lane-Shifts |
| **FMA (FMA3)** | Fused Multiply-Add | `(1):ECX[12]` | `fma` | `-mfma` | 3-Operand-`a*b+c` in einem Befehl, eine Rundung |
| **F16C** | 16-bit-Float-Konvertierung | `(1):ECX[29]` | `f16c` | `-mf16c` | half<->single-Konvertierung (`VCVTPH2PS`/`VCVTPS2PH`) |

### Skalare Begleiter (praktisch immer mit dabei)
| Subset | CPUID-Bit | cpuinfo | GCC-Flag | Kann |
|---|---|---|---|---|
| **BMI1** | `(7,0):EBX[3]` | `bmi1` | `-mbmi` | `ANDN`, `BEXTR`, `BLSI/BLSR`, `TZCNT` |
| **BMI2** | `(7,0):EBX[8]` | `bmi2` | `-mbmi2` | `PDEP`/`PEXT` (Bit-Scatter/Gather), `BZHI`, `MULX`, `SHLX/SHRX` |
| **MOVBE** | `(1):ECX[22]` | `movbe` | `-mmovbe` | Byte-Swap beim Laden/Speichern (Big-Endian-I/O) |
| **POPCNT** | `(1):ECX[23]` | `popcnt` | `-mpopcnt` | Skalarer Population-Count |
| **LZCNT/ABM** | `(0x80000001):ECX[5]` | `abm` | `-mlzcnt` / `-mabm` | Leading-Zero-Count. **Achtung:** Linux zeigt dies als `abm`, nicht `lzcnt` |

### 256-bit-VEX-Neuzugaenge (Alder Lake / Zen 4 aufwaerts — wichtig fuer AVX-512-lose CPUs)
| Subset | CPUID-Bit | cpuinfo | GCC-Flag | Kann |
|---|---|---|---|---|
| **AVX-VNNI** | `(7,1):EAX[4]` | `avx_vnni` | `-mavxvnni` | VNNI-Dot-Product int8/int16 auf **256-bit VEX** — verfuegbar auf CPUs OHNE AVX-512 (z.B. Raptor Lake, Gracemont) |
| **AVX-IFMA** | `(7,1):EAX[23]` | `avx_ifma` *(auf Ziel verifizieren)* | `-mavxifma` | 52-bit-Integer-FMA auf 256-bit VEX |
| **AVX-VNNI-INT8** | `(7,1):EDX[4]` | `avx_vnni_int8` *(auf Ziel verifizieren)* | `-mavxvnniint8` | int8-VNNI-Variante auf VEX |

---

## 3. 128-bit-Historie (SSE-Linie + der Begriff „AVX128")

Die 128-bit-SIMD-Geschichte, chronologisch. MMX (1996) war das erste x86-SIMD ueberhaupt, arbeitete aber noch auf 64-bit-MM-Registern (aliased auf die x87-FPU). SSE fuehrte 1999 die eigenstaendigen 128-bit-XMM-Register ein.

| Subset | Jahr/Herkunft | CPUID-Bit | cpuinfo | GCC-Flag | Kann |
|---|---|---|---|---|---|
| **MMX** | 1996, Pentium MMX | `(1):EDX[23]` | `mmx` | `-mmmx` | 64-bit gepackte Integer (MM0–7, auf x87 aliased) |
| **SSE** | 1999, Pentium III | `(1):EDX[25]` | `sse` | `-msse` | Erste echten 128-bit-XMM, Single-Precision-Float |
| **SSE2** | 2001, Pentium 4 | `(1):EDX[26]` | `sse2` | `-msse2` | Double-Precision + 128-bit-Integer (macht MMX obsolet) |
| **SSE3 (PNI)** | 2004, Prescott | `(1):ECX[0]` | `pni` | `-msse3` | Horizontale Ops, `LDDQU`. **cpuinfo heisst `pni`** (Prescott New Instructions), nicht `sse3` |
| **SSSE3** | 2006, Core | `(1):ECX[9]` | `ssse3` | `-mssse3` | `PSHUFB` (Byte-Shuffle), `PMADDUBSW` |
| **SSE4.1** | 2007, Penryn | `(1):ECX[19]` | `sse4_1` | `-msse4.1` | `PBLEND*`, `PMOVSX/ZX`, `PMULLD`, `DPPS` |
| **SSE4.2** | 2008, Nehalem | `(1):ECX[20]` | `sse4_2` | `-msse4.2` | String-Vergleich `PCMPESTRI`, `CRC32` |
| **SSE4a** | AMD, 2007 (K10) | `(0x80000001):ECX[6]` | `sse4a` | `-msse4a` | `EXTRQ`/`INSERTQ` — **nur AMD** |

**Zum Begriff „AVX128":** Es gibt keine eigene CPUID-Flag namens AVX128. Gemeint sind die **VEX.128-kodierten Formen** aller AVX-Befehle: Jeder AVX-Befehl existiert in einer 128-bit-Variante, die auf XMM-Registern arbeitet, aber mit dem sauberen 3-Operand-VEX-Encoding (non-destructive, kein SSE/AVX-Transition-Penalty). Sie werden vom `avx`-Flag mitgeschaltet — man braucht nichts Zusaetzliches. Die vom User genannte historische Einordnung ist korrekt: SSE (bzw. streng genommen MMX) war das „erste SIMD", und die 128-bit-Ebene lebt heute in zwei Kodierungen weiter — legacy-SSE (destruktiv) und VEX.128 („AVX128", sauber). Unter EVEX kommt mit AVX-512VL noch eine dritte 128-bit-Kodierung mit Maskierung hinzu.

---

## 4. Support-Matrix der konkreten Cluster-CPUs

| | **prod1 — AMD Ryzen 9 9950X3D (Zen 5)** | **prod2 — Intel i9-14900KS (Raptor Lake)** | **Odroid-H4-Klasse (Alder Lake-N, Gracemont)** |
|---|---|---|---|
| AVX-512 | **VOLL, nativer 512-bit-Datenpfad** | **fused-off (0)** | **nicht vorhanden** |
| 512-bit-Ausfuehrung | Ja — Zen 5 hat erstmals native 512-bit-Datenpfade (kein Double-Pumping wie Zen 4) | — | — |
| AVX2/FMA/F16C | Ja | Ja | Ja (Gracemont hat FMA3) |
| AVX-VNNI (VEX) | Ja | **Ja** (256-bit-Ersatz fuer AVX-512-VNNI) | **Ja** |
| GFNI/VAES/VPCLMULQDQ | Ja (VEX+EVEX) | Ja (nur VEX-Form) | Ja (nur VEX-Form) |
| Frequenz-Malus | **Nein** — Zen 4/5 takten unter AVX-512 nicht signifikant herunter (kein Skylake-X-Lizenz-Malus) | n/a | n/a |

**Erwartete `/proc/cpuinfo`-Signaturen (AVX-relevanter Ausschnitt):**

- **prod1 (Zen 5):** `avx avx2 fma f16c bmi1 bmi2 movbe popcnt abm aes pclmulqdq sha_ni gfni vaes vpclmulqdq avx_vnni` + AVX-512: `avx512f avx512dq avx512ifma avx512cd avx512bw avx512vl avx512vbmi avx512_vbmi2 avx512_vnni avx512_bitalg avx512_vpopcntdq avx512_bf16 avx512_vp2intersect`. Kein `avx512_fp16`, kein `avx512er/pf/4vnniw/4fmaps` (Xeon-Phi-Only). VP2INTERSECT ist der Zen-5-Neuzugang gegenueber Zen 4.
- **prod2 (Raptor Lake):** `avx avx2 fma f16c bmi1 bmi2 movbe popcnt abm aes pclmulqdq sha_ni gfni vaes vpclmulqdq avx_vnni`. **Keinerlei `avx512*`.** VNNI nur als 256-bit `avx_vnni`.
- **Odroid-H4 (Gracemont):** wie Raptor Lake ohne AVX-512, ebenfalls `avx avx2 fma f16c avx_vnni gfni vaes vpclmulqdq bmi1 bmi2`. **Keine `avx512*`.**

Konsequenz fuer die Baseline: Der **einzige AVX-512-Traeger im Cluster ist prod1**. Ein Organ, das AVX-512 verlangt, laeuft nur dort; prod2/Odroid brauchen einen 256-bit-VEX-Rueckfallpfad (AVX2 + `avx_vnni` fuer int8-Faelle).

---

## 5. Sinnhaftigkeits-Matrix: Flag-Klassen ↔ Organ-Achsen-Klassen

Fuer eine B+-Baum-Suchmaschine. Konfidenz: **[solide]** = klarer, direkter Befehls-Match; **[spekulativ]** = plausibel, aber nutzen-abhaengig / nicht durch die Datenstruktur zwingend nahegelegt.

| Organ-Achsen-Klasse | Plausibel nutzbare Flag-Klassen | Begruendung (1 Satz) | Konfidenz |
|---|---|---|---|
| **filter** (Bloom/Bitmap) | `avx512_vpopcntdq`, `avx512_bitalg`, `gfni` | Popcount pro Lane/Byte ist die Kern-Operation von Bloom-Filtern; GFNI berechnet Bit-Matrix-Hashes fuer die Filter-Bits. | [solide] |
| **search_algo** (Key-Vergleich im Node) | `avx512bw`, `avx512dq`, `avx512f`, `avx512vl` | Parallele `VPCMP`-Vergleiche der Keys gegen einen Suchschluessel liefern direkt eine Maske → Trefferindex; VL erlaubt 128/256-bit unter Maskierung fuer kleine Nodes. | [solide] |
| **node_type** (SIMD-scan-Node) | `avx512bw`/`avx512dq` + `avx512_vbmi2` | Vergleich erzeugt Maske, `VPCOMPRESS` packt die Treffer ohne Branch. | [solide] |
| **memory_layout** (SoA/AoS, De-Interleave) | `avx512vbmi` (`VPERMB`), `avx512_vbmi2`, `avx512bw` | Byte-Permutation und Compress/Expand re-arrangieren Feld-Layouts in Registern. | [solide] |
| **mapping** (Hash/Adress-Abbildung) | `gfni`, `vpclmulqdq`, `avx512cd` | GFNI-Affine und CLMUL sind billige, gut streuende Hash-Primitive; `VPCONFLICT` (CD) erkennt Kollisionen parallel. | [solide] |
| **index_organization** (Radix/Trie, Rank/Select) | `bmi2` (`PEXT`/`PDEP`), `avx512vbmi`, `avx512_vpopcntdq` | Radix-Ziffern-Extraktion via PEXT; Popcount liefert Rank/Select fuer succinct-Indizes. | [solide] |
| **cache_traversal** (Pointer-Chasing) | `avx2`-Gather / `avx512f`-`VPGATHER`, `avx512cd` | Gather sammelt mehrere Kind-Pointer in einem Befehl — aber Pointer-Jagd ist latenz-, nicht durchsatzgebunden, der Gewinn ist daher begrenzt. | [spekulativ] |
| **value_handle** (Offset-Decode, Kompression) | `avx512_vbmi2` (Compress/Expand), `vpclmulqdq` | Varint/Bit-Packing-Decode via Expand; CLMUL fuer Value-Pruefsummen. | [spekulativ] |
| **prefetch** (Organ-Achse) | (kein SIMD-Flag) — `avx512pf` nur Xeon-Phi | Software-Prefetch (`PREFETCHT0` etc.) ist **nicht** SIMD-Flag-gated; die Prefetch-Achse ist weitgehend orthogonal zu SIMD-Flags. `avx512pf` existiert, ist aber auf dem Cluster nicht verfuegbar. | [nicht anwendbar] |
| **(Scoring/Ranking, falls vorhanden)** | `avx512_vnni` / `avx_vnni`, `avx512_bf16`, `avx512_fp16` | int8/bf16-Dot-Product fuer gelerntes Ranking — nur sinnvoll, wenn das Organ ueberhaupt ML-Scoring betreibt; fuer einen klassischen B+-Baum kuenstlich. | [spekulativ] |

**Querschnitt VL:** `avx512vl` ist fuer fast alle obigen Achsen der Enabler, um AVX-512-Semantik (Maskierung, 32 Register) auch bei kleinen 128/256-bit-Nodes zu nutzen — auf Zen ohne den frueher gefuerchteten Frequenz-Malus, dieser Mythos gilt fuer Zen 4/5 nicht mehr.

---

## 6. Empfehlung: Deklarations-Format (XML-Registry, R5-`<values>`-Stil)

Zwei getrennte Belange: (a) die **Maschinen-Signatur** (was die Hardware kann — 1:1 aus `/proc/cpuinfo`) und (b) die **Organ-Anforderung** (was ein Achsen-Algorithmus braucht: `required` + `optional`). Der Planer/Resolver schneidet beide gegeneinander.

**(a) Maschinen-Signatur** — reine Ist-Aufnahme, ein `<flag>` pro cpuinfo-String (exakte Schreibweise):
```xml
<machine id="prod1" arch="znver5" source="/proc/cpuinfo">
  <isa-signature>
    <flag>avx</flag> <flag>avx2</flag> <flag>fma</flag> <flag>f16c</flag>
    <flag>avx512f</flag> <flag>avx512vl</flag> <flag>avx512bw</flag>
    <flag>avx512dq</flag> <flag>avx512cd</flag> <flag>avx512vbmi</flag>
    <flag>avx512_vbmi2</flag> <flag>avx512_vnni</flag>
    <flag>avx512_vpopcntdq</flag> <flag>avx512_bitalg</flag>
    <flag>avx512_bf16</flag> <flag>avx512_vp2intersect</flag>
    <flag>gfni</flag> <flag>vaes</flag> <flag>vpclmulqdq</flag>
  </isa-signature>
</machine>
```

**(b) Organ-Anforderung** — im ANGEBOT-`<values>`-Stil, ein `<value>` je Algorithmus-Variante einer Achse; jede Variante deklariert `required`/`optional` plus das passende Compiler-Flag-Bundle:
```xml
<axis class="filter">
  <values>
    <value id="simd_bloom_avx512" default="false">
      <isa required="all">
        <flag cpuinfo="avx512f"           gcc="-mavx512f"/>
        <flag cpuinfo="avx512_vpopcntdq"  gcc="-mavx512vpopcntdq"/>
      </isa>
      <isa optional="true">
        <flag cpuinfo="avx512_bitalg"     gcc="-mavx512bitalg"/>
      </isa>
    </value>
    <value id="simd_bloom_avx2" default="true">
      <isa required="all">
        <flag cpuinfo="avx2"     gcc="-mavx2"/>
        <flag cpuinfo="popcnt"   gcc="-mpopcnt"/>
      </isa>
    </value>
    <value id="scalar_bloom" default="false"/>  <!-- Rueckfall ohne SIMD -->
  </values>
</axis>
```

Regeln fuer den Resolver:
- **`required="all"`** = harte Vorbedingung; ist auch nur ein Flag nicht in der Maschinen-Signatur, faellt die Variante fuer diese Maschine weg (auf prod2/Odroid also die `avx512`-Variante → Fallback `simd_bloom_avx2`).
- **`optional`** = wenn vorhanden, schaltet das Codegen einen schnelleren Pfad frei, ist aber nicht Bau-verhindernd.
- Jedes `<flag>` traegt **beide** Namen: `cpuinfo` (Matching gegen die Signatur) und `gcc` (was der Planer in das CMake/CI-Compile-Bundle schreibt).
- Detektion beruht auf `/proc/cpuinfo` bzw. `lscpu`: Der Kernel setzt ein AVX-512-Flag nur, wenn auch die OS-XSAVE-Freischaltung (XCR0-Opmask/ZMM-Bits) aktiv ist — das cpuinfo-Flag ist also bereits „OS-enabled", eine separate XCR0-Pruefung ist nicht noetig.

**Zukunftshinweis:** Intel konsolidiert die zerfledderte Flag-Landschaft in **AVX10** (`-mavx10.1`/`-mavx10.2`, cpuinfo perspektivisch `avx10`), mit einem Versions- statt Einzel-Flag-Modell und garantiertem 256-bit-Baseline unabhaengig von der Vektor-Laenge. Fuer eine langlebige Registry lohnt es, das `<flag>`-Modell so zu halten, dass eine spaetere `<isa-level name="avx10.1"/>`-Notation additiv danebengestellt werden kann.

---

## 7. Quellen

- Linux-Kernel `cpufeatures.h` (autoritativ fuer cpuinfo-Strings): https://raw.githubusercontent.com/torvalds/linux/master/arch/x86/include/asm/cpufeatures.h
- Linux-Kernel x86 Feature-Flags-Doku: https://www.kernel.org/doc/html/latest/arch/x86/cpuinfo.html
- Wikipedia CPUID (Leaf-7/Leaf-1-Bit-Tabellen): https://en.wikipedia.org/wiki/CPUID
- Wikipedia AVX-512 (Subset-Liste, Microarchitektur-Ersteinfuehrung): https://en.wikipedia.org/wiki/AVX-512
- Wikipedia Advanced Vector Extensions (AVX/AVX2/AVX128-VEX): https://en.wikipedia.org/wiki/Advanced_Vector_Extensions
- GCC x86-Options (Compiler-Flags): https://gcc.gnu.org/onlinedocs/gcc/x86-Options.html
- WikiChip AVX-512: https://en.wikichip.org/wiki/x86/avx-512
- Zen-5-AVX-512-Teardown (nativer 512-bit-Datenpfad, VP2INTERSECT): https://www.numberworld.org/blogs/2024_8_7_zen5_avx512_teardown/
- Chips and Cheese, Zen-5-AVX-512-Frequenzverhalten (kein Frequenz-Malus): https://chipsandcheese.com/p/zen-5s-avx-512-frequency-behavior
- Phoronix, Zen-4-AVX-512 (realer cpuinfo-Flag-Satz): https://www.phoronix.com/review/amd-zen4-avx512
- Intel 13th/14th-Gen Datasheet, AVX2-VNNI auf Raptor Lake: https://edc.intel.com/content/www/us/en/design/products/platforms/details/raptor-lake-s/13th-generation-core-processors-datasheet-volume-1-of-2/007/intel-avx2-vector-neural-network-instructions-avx2-vnni/
- Tom's Hardware, Gracemont ISA (AVX/AVX2/AVX-VNNI, kein AVX-512): https://www.tomshardware.com/news/intels-upcoming-gracemont-microarchitecture-to-support-avx-avx2-and-avx-vnni

---

**Verifikations-Vermerke:** Alle cpuinfo-Schreibweisen doppelt bestaetigt (Kernel-Header + realer Zen-4-Dump). CPUID-Bits aus der Wikipedia-CPUID-Tabelle; `VBMI2 = (7,0):ECX[6]` explizit gegengeprueft. Als „auf Ziel verifizieren" markiert: cpuinfo-Strings `avx_ifma` und `avx_vnni_int8` (im geholten Kernel-Auszug ohne eindeutigen String-Kommentar — auf der konkreten Kernel-Version am Ziel per `lscpu`/`grep` bestaetigen). Nicht als AVX-512-Kern, sondern als VEX/EVEX-Begleiter eingeordnet: GFNI/VAES/VPCLMULQDQ.

