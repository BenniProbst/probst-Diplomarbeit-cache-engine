# P32 — To Stride or Not to Stride (Schmidt/Habich et al. 2025)

**Voller Titel:** To stride or not to stride the memory access?
**Autoren:** Lennart Schmidt (TUD), Roland Kuehn, Matti Krause, Jens Teubner (TU Dortmund), Wolfgang Lehner (TUD/AAU Aalborg), **Dirk Habich** (TUD)
**Venue:** DIMES 2025, Seoul (3rd Workshop on Disruptive Memory Systems)
**DOI:** 10.1145/3764862.3768174
**Volltext:** `_text/P32-ToStride2025.txt` (8 Seiten, 45 KB)

## 1. Konzeptionelle Identitaet

**Empirische Studie**: Stride-Access kann Sequential-Access bei modernen Disruptive Memory Systems (Sapphire Rapids + HBM) **schlagen** — sogar SIMD-Sequential!

> "The strided access pattern with a well-chosen stride size clearly outperforms the sequential access pattern. Even a SIMD-accelerated sequential access is considerably slower than the best-performing scalar strided access." (P32:S.1/45-49)

**Klasse:** Memory-Access-Pattern-Studie auf moderner Hardware
**Hauptbefund:** Klassische Annahme "Sequential ist optimal" ist NICHT mehr korrekt!

## 2. Hauptkonzepte

### 2.1 Strided Access Pattern
```c
for (size_t i = 0; i < s; i++) {        // s = stride size
    for (size_t j = 0; j < total/s; j++) {
        sum += data[i + j * s];          // access every s-th element
    }
}
```
- `s` Passes ueber das Array
- Jeder Pass: jedes s-te Element

### 2.2 Vier Varianten (P32:S.2)
1. **sequential** — klassisch
2. **simd-sequential** — AVX-512 sequenziell
3. **strided** — mit stride size s
4. **strided-unrolled** — strided + Loop-Unrolling

### 2.3 Plattformen (P32:Tab.1)
| Generation | Name | Besonderheit |
|---|---|---|
| 2nd Xeon Scalable | Cascade Lake (Gold 6240R) | DDR4 + 64 entries DTLB |
| 4th Xeon Scalable | Sapphire Rapids (Gold 9468) | DDR5 + HBM + 96 entries DTLB + 2× L2/L3 |

### 2.4 Empirische Erkenntnis
- Sapphire Rapids (4th Gen): groesserer Cache + groesserer TLB + HBM
- Strided Access kann **bessere Memory-Bandbreite** ausnutzen
- TLB-Misses werden trotz Stride-Access seltener (groesserer DTLB/STLB)

## 3. PRT-ART-Bezug (Habich-Forschungsprogramm!)

| Schmidt-2025-Konzept | PRT-ART-Bezug |
|---|---|
| **Stride-Access > Sequential auf moderner Hardware** | **DIREKTE Stuetze fuer PRT-ART Cache-Engine Plattform-Kalibrierung** |
| **Plattform-spezifische Access-Pattern-Wahl** | PRT-ART Cache-Engine MUSS verschiedene Access Patterns evaluieren |
| **HBM + DDR5 als neue Memory-Typen** | PRT-ART Termin 6 Plattformmatrix beruecksichtigt HBM (Grace Hopper) |
| **2 MiB Hugepages reduzieren TLB-Druck** | PRT-ART Cache-Engine kann Hugepages-Wahl beruecksichtigen |
| **Klassische Annahmen sind ueberholt** | **Klassisches Argument** fuer adaptive Plattform-Kalibrierung |

## 4. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **Schmidt Stride-Access ↔ Hankins/Patel "Knoten > Cache-Line ist besser" (P13)**: beide widerlegen klassische Annahmen
- **Schmidt HBM-Memory ↔ Mahling Hochlatenz-Memory (P25)**: beide untersuchen disruptive Memory
- **Schmidt Habich/Lehner ↔ VAMPIR Berthold/Lehner/Habich (P33) ↔ Ungethuem 2017 (P31)**: TUD/Habich-Forschungsprogramm

## 5. Kernanschluss fuer PRT-ART (TUD-Linie)

Schmidt 2025 ist die **direkte Stuetze** fuer PRT-ART Cache-Engine Plattform-Kalibrierung:

1. **Memory-Access-Pattern-Wahl ist plattformabhaengig** — PRT-ART Cache-Engine waehlt Strided vs Sequential
2. **Klassische Annahmen werden widerlegt** — PRT-ART darf NICHT auf "Sequential ist optimal" bauen
3. **HBM + neue Memory-Typen** — PRT-ART Cache-Engine muss diese unterstuetzen
4. **TUD/Habich-Linie** — PRT-ART steht in dieser Forschungstradition

→ Termin 1+5 referenzieren das Paper als L14 / A3.3: "TUD Access-Pattern-Quelle". Schmidt 2025 ist die direkte Quelle.

PRT-ART Cache-Engine kann **konkret lernen**:
- Mikrobenchmark "Sequential vs Strided" beim Warm-up
- Pro Plattform optimaler Stride
- Pro Memory-Typ unterschiedliche Wahl
