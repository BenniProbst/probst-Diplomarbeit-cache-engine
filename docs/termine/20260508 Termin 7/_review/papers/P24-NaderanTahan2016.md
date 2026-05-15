# P24 — Naderan-Tahan/Sarbazi-Azad 2016 (Why Doesnt Prefetching Work)

**Voller Titel:** Why Does Data Prefetching Not Work for Modern Workloads?
**Autoren:** Mahmood Naderan-Tahan, Hamid Sarbazi-Azad (Sharif Univ. of Technology + IPM Tehran)
**Venue:** Computer Journal Oxford 59(2) 2016 (Online Dez 2015)
**DOI:** 10.1093/comjnl/bxv112
**Volltext:** `_text/P24-NaderanTahan2016.txt` (16 Seiten, 67 KB)

## 1. Konzeptionelle Identitaet

**Empirische Studie**: Existierende state-of-the-art Prefetching-Methoden funktionieren NICHT bei modernen Cloud-Workloads (Cloudsuite, scale-out).

> "Existing history-based prefetchers that were originally proposed for desktop and server workloads are quite inefficient in reducing cache misses. The main problem is high overprediction rates" (P24:S.2/103-107)

**Klasse:** Workload-Charakterisierungs-Studie + Prefetcher-Evaluation
**Schluessel-Befund:** Modern Workloads = **niedrige temporal locality + irregulaere miss patterns**

## 2. 7 Schluessel-Erkenntnisse (P24:S.2/102-148)

1. **High overprediction rates** — Prefetched Bloecke werden vor Zugriff evicted
2. **Modern Workloads = poor temporal locality** + wenige Wiederholungen
3. **Strong spatial locality** in scale-out workloads (mehr als andere)
4. **No regularity for cache misses** in grossen Memory-Regionen
5. **Few opportunities** zur Eliminierung von temporal repetitive misses (Misses sind non-repetitive)
6. **Delta correlation prefetchers** scheitern bei scale-out (random hit/miss)
7. **NICHT energy-effizient** — mehr Memory-Requests fuer wenig Performance

## 3. Workload-Klassifikation (P24:Tab.2/S.3)

| Workload-Typ | Beispiele | Miss Ratio |
|---|---|---|
| **Cloudsuite scale-out** | Data Serving (Cassandra), Map-Reduce, Web frontend, SAT solver, Web search, Media streaming | 2.5-6.4% |
| **Cache-friendly traditional** | Vips, milc | 0.15-0.5% |
| **Cache-unfriendly traditional** | lbm, Libquantum, Soplex, hmmer | 2.5-22% |
| **Server** | Oracle OLTP | 6.4% |

## 4. PRT-ART-Bezug (KRITISCHE WARNUNG)

| Naderan-Tahan-Erkenntnis | PRT-ART-Bezug |
|---|---|
| **Prefetching hilft NICHT bei modernen workloads** | **PRT-ART Cache-Engine MUSS messen, ob Prefetch hilft** — kein Default-AN! |
| **Hohe Overprediction-Rate = Cache Pollution** | PRT-ART Cache-Engine misst CLU + Cache-Pollution |
| **Workload-Charakteristik bestimmt Prefetch-Erfolg** | PRT-ART Cache-Engine muss Workload-Charakteristik erkennen |
| **Energy efficiency** | wichtig fuer Embedded-Plattformen (Pi 5, ODROID, VisionFive 2 in Termin 6) |

## 5. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **Naderan-Tahan "Prefetching scheitert" ↔ Mahling Fetch Me If You Can (P25)**: zwei Studien zur Prefetch-Limitierung (mit gleicher Botschaft, andere Plattform)
- **Naderan-Tahan vs Chen 2001 (P21) Prefetching B+-Trees**: Gegensatz — Chen 2001 zeigt grossen Speedup bei B+-Tree (regulaer), Naderan-Tahan zeigt: bei modernen workloads (irregular) scheitert es
- **Naderan-Tahan Workload-Charakterisierung ↔ TPC-C realistische Last (P19 Saikkonen 2016)**: beide zeigen die Wichtigkeit echter Workloads

## 6. Kernanschluss fuer PRT-ART

Naderan-Tahan ist die **kritische Vorsicht-Quelle**: PRT-ART Cache-Engine darf NICHT annehmen, dass Prefetching immer hilft.

PRT-ART **Modus 2 (Warm-up Calibration)** muss explizit messen:
- Hilft Prefetching auf der konkreten Plattform?
- Hilft Prefetching fuer den konkreten Workload?
- Wenn nein: **Prefetch-Policy = OFF**

→ Termin 5 nachgezogen Resolution: "Prefetching gehoert in die Cache-Engine, aber nur als gemessene, platform-aware Entscheidung." Naderan-Tahan ist die theoretische Stuetze fuer dieses Termin-5-Statement.
