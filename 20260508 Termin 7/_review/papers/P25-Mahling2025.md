# P25 — Mahling/Weisgut/Rabl (Fetch Me If You Can — Prefetch Reliability)

**Voller Titel:** Fetch Me If You Can: Evaluating CPU Cache Prefetching and Its Reliability on High Latency Memory
**Autoren:** Fabian Mahling, Marcel Weisgut, Tilmann Rabl (Hasso Plattner Institute, U. Potsdam)
**Venue:** DaMoN 2025, Berlin
**DOI:** 10.1145/3736227.3736231
**Volltext:** `_text/P25-Mahling2025.txt` (9 Seiten, 54 KB)

## 1. Konzeptionelle Identitaet

Empirische Studie zu **Software-Prefetching auf High-Latency Memory** (NUMA, CXL, NVLink, HBM). Identifiziert **Prefetching Reliability** als kritischen Hardware-Faktor.

> "We show that prefetching can increase performance by up to 2.6× and 2.8× for B+-Tree and binary search workloads. We find that CPU **fill buffers**, which track L1 cache misses, and a workload's memory intensity dictate how much access latency can be hidden." (P25:S.1/30-37)

**Klasse:** Hardware-empirische Prefetching-Studie auf 7 verschiedenen CPUs
**Hauptbeitrag:** Konzept **Weak vs Strong Prefetching Reliability** als Plattform-Charakteristik

## 2. Schluesselkonzepte

### 2.1 Fill Buffer (FB)

> "The FB is located between the L1 and L2 caches. For every main memory, L2, and L3 request, the CPU allocates an FB slot to track the request. **Prefetch requests are either dropped if the FB is full or the CPU stalls until a slot is available**." (P25:S.2/138-143)

CPU-Hersteller-Bezeichnungen:
- Intel: **Line Fill Buffer (LFB)**
- AMD: **Miss Address Buffer (MAB)**
- Fujitsu: **Move In Buffer (MIB)**

### 2.2 Weak vs Strong Prefetching Reliability (HAUPTBEITRAG)

| Reliability | Verhalten bei FB voll |
|---|---|
| **Weak** (z.B. AMD EPYC) | Prefetch-Requests werden **dropped** |
| **Strong** (z.B. Intel Xeon) | CPU **stalled** bis FB-Slot frei |

**Wichtig:** "When prefetching 8 KiB B+-Tree nodes, weak reliability achieves a speedup of 2× while strong reliability degrades performance with a slowdown of 2.5× for lookup workloads." (P25:S.1/42-46)

### 2.3 Prefetch Locality Hints (Plattform-spezifisch!)

| Hint | Intel | AMD | ARM |
|---|---|---|---|
| T0 | L1 | T0 (oder PREFETCH 3DNow!) | KEEP_L1 |
| T1 | L2 | wie T0 | KEEP_L2 |
| T2 | L3 (gleich wie T1!) | wie T0 | KEEP_L3 |
| NTA | non-temporal | (egal) | STREAM_L1/L2/L3 |

> "Intel treats T1 and T2 the same on their Xeon Scalable family. AMD claims to either map T1 and T2 to T0 or to map all prefetches to a single PREFETCH instruction." (P25:S.2/192-194)

→ **Plattform-spezifisches Verhalten** — `__builtin_prefetch` ist ein **Hint, kein Befehl!**

## 3. PRT-ART-Bezug (HOECHST RELEVANT fuer Cache-Engine!)

| Mahling-Konzept | PRT-ART-Bezug |
|---|---|
| **Fill Buffer als limitierender Faktor** | **PRT-ART Cache-Engine MUSS Fill-Buffer-Auslastung beruecksichtigen** |
| **Weak vs Strong Reliability** | **PRT-ART Cache-Engine Modus 2 (Warm-up) muss Reliability messen!** |
| **CPU-spezifische Prefetch-Implementierung** | DIREKT: PRT-ART Cache-Engine Plattform-Profil enthaelt Prefetch-Charakteristik |
| **Hints werden nicht garantiert ausgefuehrt** | wichtige Erkenntnis: PRT-ART darf nicht annehmen, dass Prefetch immer wirkt |
| **Coroutine-based prefetching erwaehnt** | OPTIONAL Future Work fuer PRT-ART |

## 4. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **Mahling Fill Buffer ↔ Chen 2001 Memory-Level-Parallelism (P21)**: gleiche Hardware-Mechanik (24 Jahre)
- **Mahling Weak/Strong Reliability ↔ Khan Cost-Benefit-Adaption (P23)**: beide adressieren "Prefetch hilft nicht immer"
- **Mahling Plattform-spezifisch ↔ Samuel Configuration Experiment (P14)**: beide brauchen pro Plattform Mikrobenchmarks
- **Mahling skeptisches "Prefetch hilft nicht immer" ↔ Naderan-Tahan (P24)**: zwei Studien mit gleicher Botschaft

## 5. Kernanschluss fuer PRT-ART

Mahling 2025 ist **HOECHST WICHTIG** fuer die PRT-ART Cache-Engine:

1. **Fill-Buffer-Auslastung** als Schwellenwert fuer Prefetch-Aktivierung
2. **Weak vs Strong Reliability** als Plattform-Charakteristik in der Cache-Engine-Profil-Tabelle
3. **CPU-spezifische Prefetch-Locality-Hints** (T0/T1/T2/NTA) muessen je Plattform validiert werden
4. **Mikrobenchmarks** fuer Prefetch-Charakterisierung gehoeren in PRT-ART Modus 2 Warm-up Calibration

→ Termin 5 nachgezogen: "Prefetch-Erfolg haengt von Fill Buffers, Workload-Intensitaet und CPU-Verhalten ab" — Mahling ist die direkte Quelle fuer dieses Statement.

**Zentral:** Die `PRT-ART Cache-Engine Plattform-Profil-Tabelle` muss enthalten:
- Prefetching Reliability (weak/strong)
- Anzahl FB-Slots (z.B. Intel 10 LFBs)
- T1=T2-Aliasing (Intel-spezifisch)
- AMD T1/T2→T0-Mapping (AMD-spezifisch)
