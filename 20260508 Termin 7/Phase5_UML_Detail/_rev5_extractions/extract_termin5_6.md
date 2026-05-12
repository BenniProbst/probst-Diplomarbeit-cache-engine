# Extraktion Termin 5 + Termin 6 — Cache-Engine Forschungslandkarte und Scope-Freeze

**Quellen (vollstaendig gelesen):**
- T5-AA: `20260412 Termin 5__20260412_Arbeitsaufstellung_PRT_ART_Termin5_final.docx.txt` (Arbeitsaufstellung)
- T5-FL: `20260412 Termin 5__20260412_PRT_ART_Forschungslandkarte_Cache_Engine_Termin5_final.docx.txt` (Forschungslandkarte mit Literaturmatrix)
- T5-NA: `20260412 Termin 5__20260416_PRT_ART_Ausarbeitung_Termin5_nachgezogen_final.docx.txt` (Nachgezogene Ausarbeitung)
- T6-AA: `20260416 Termin 6__20260416_Arbeitsaufstellung_PRT_ART_Termin6_final.docx.txt` (Arbeitsaufstellung Termin 6)
- T6-SF: `20260416 Termin 6__20260416_PRT_ART_Termin6_Scope_Freeze_final.docx.txt` (Scope-Freeze Termin 6)

**Hinweis:** Block AN/AO/AP und eine eigenstaendige "Telemetry-Strategie" sind in Termin 5/6 nicht woertlich genannt — Termin 6 nennt jedoch konkrete Telemetrie-/Mess-Pflichten (Abschnitt F). Kuehn (P28 DaMoN 2023) wird in Termin 5/6 ebenfalls nicht namentlich erwaehnt; Kuehn-Erkenntnisse stammen aus Tier-3-Lektuere (siehe Memory).

---

## A) Cache-Engine Forschungslandkarte — Bausteinfamilien, Permutations-Achsen, Heuristik-Familien

### A.1 Bausteinfamilien (5 Forschungscluster nach T5-FL §2 + T5-NA §3)

Die Forschungslandkarte ist EXPLIZIT in **fuenf Cluster** unterteilt, die zusammen die Cache-Engine-Bausteinfamilien aufspannen:

| Cluster | Bausteinfamilie | Repraesentative Arbeiten | Was die Engine daraus baut |
|---|---|---|---|
| **2.1 / 3.1** | Passive cache-aware Layoutforschung | CSS-tree, CSB+-tree, Graefe/Larson, Knotengroesse (Hankins/Patel), processor-conscious CSB+ (Samuel/Pedersen/Bonnet) | "Dense Pages, Seitengruppierung und pointerarme Adressierung" — statische Layout-Bausteine |
| **2.2 / 3.2** | Adaptive trieartige Suchstrukturen | ART, START, HOT, Masstree, B²-tree, CoCo-trie | "Seitentypfamilien, Redirects, lokale Suchtechniken und Praefixkollabierung" |
| **2.3 / 3.3** | Prefetching und Laufzeitanpassung | Fractal Prefetching B+-Trees, Dynamic Adaptation (Khan), Fetch Me If You Can (Mahling/Weisgut/Rabl), "Why Does Data Prefetching Not Work for Modern Workloads?" (Naderan-Tahan) | "Kalibrierungsphase und evidenzbasiertes, regel- oder kostenmodellbasiertes Prefetching" |
| **2.4 / 3.4** | Cache-oblivious Gegenentwurf | Cache-oblivious B-trees, cache-oblivious string B-trees (Bender et al.) | Bewusste Abgrenzung — Markiert "den philosophischen Kontrast: PRT-ART ist explizit cache-aware, nicht cache-oblivious" |
| **2.5 / 3.5** | Habich-/Dresden-Kontext | Ungethuem 2017 Hardware Optimizations, VAMPIR, "To stride or not to stride" | "Sprache, die PRT-ART braucht: hoher Durchsatz, niedrige Latenz, explizite Access-Pattern-Analyse, Scheduling und hardwarebewusste Entscheidungen" |

### A.2 Permutations-Achsen der Cache-Engine (aus T5-NA + T6-SF abgeleitet)

T5-NA §6 nennt die "Designhebel", T6-SF Abschnitt 4 die Verifikationsdimensionen. Zusammengenommen ergeben sich folgende Permutations-Achsen (alle als orthogonale Stellschrauben fuer Permutationen in F15):

1. **Seitentyp-Achse:** Dense Page | START-style multibyte | sparse HOT-page | redirect path (CoCo-trie collapsed) | lokale Suchraum-Seite (B²-tree)
2. **Value-Ablage-Achse:** Inline vs. Handle (T5-NA Regel R4 — "First-Class-Thema, weil Value-Ablage direkt auf Cache-Line-Nutzung und Pointer-Kette wirkt")
3. **Layout-Achse:** Knotengroesse, Pointerzahl, Kindanordnung, Suchschema auf der Seite (T5-FL §2.1)
4. **Prefetching-Achse:** Off | statisch | Warm-up-kalibrierte Prefetch-Distanz | online adaptiv (Khan-Stil)
5. **Plattform-Kalibrierungs-Achse:** Modus 1 statisch/passiv | Modus 2 Warm-up-kalibriert | Modus 3 online adaptiv (T6-SF §4)
6. **ISA-Pfad-Achse:** scalar | x86_avx2 | x86_avx512 | arm_neon | arm_sve2 (T6-AA §3 Pflicht-ISA-Pfade)
7. **Hardware-Plattform-Achse:** 9 Pflichtplattformen (T6-SF §1, siehe D)
8. **Core-Typ-Achse (bei Hybrid):** cpu_core vs. cpu_atom getrennt (T6-SF §3, T6-AA §3)

### A.3 Heuristik-Familien (Verifikationslogik T6-SF §4 + abgeleitete Heuristiken)

T6-SF §4 definiert drei **Heuristik-Modi** der Cache-Engine — das ist die zentrale Heuristik-Familie:

| Modus | Heuristik-Charakter | Quelle |
|---|---|---|
| **Modus 1: passiv/statisch** | "feste Seitentypen und feste Schwellen ohne Plattformkalibrierung" — Null-Heuristik / Default-Strategie | T6-SF §4 |
| **Modus 2: Warm-up-kalibriert** | "einmalige Mikrobenchmarks bei der ersten Instanz; daraus folgen feste Plattformregeln" — Kalibrierungs-Heuristik (CSB+ processor-conscious-Erbe) | T6-SF §4 |
| **Modus 3: online adaptiv** | "Warm-up plus laufende Rekalibrierung/Umschaltung bei veraenderten Zugriffsmustern" — Online-Adaption (Khan-Erbe + START-Optimizer-Erbe) | T6-SF §4 |

Zusaetzliche **Heuristik-Bausteine aus den Designregeln R1-R6** (T5-FL §6):
- R3-Heuristik: messgetriebene Seitentyp-Auswahl (Dense/Sparse/Redirect/lokale Suchraumseiten)
- R4-Heuristik: Inline-vs.-Handle-Umschaltentscheidung
- R5-Heuristik: "zuerst messen, dann aktivieren" — Prefetch-Aktivierungs-Heuristik
- R2-Heuristik: Plattformkalibrierung vor Produktivbetrieb

---

## B) Atomare Bausteine vs. Hybrid-Bausteine

Die Termin-5/6-Dokumente trennen NICHT explizit "atomar" vs. "hybrid" als Begriffe, aber die Klassifikation ergibt sich aus der Struktur der Forschungslandkarte (T5-FL §3) und der Pflicht-Benchmarkfamilien (T6-SF §2):

### B.1 Atomare Bausteine (in T6-SF §2 als einzelne Pflichttests verifizierbar)

**Seitentyp-Bausteine (Tabelle 2, Zeile "Seitentypen"):**
- Dense page (atomar)
- START-style multibyte page (atomar)
- Sparse HOT-page (atomar)
- Redirect path (atomar — CoCo-trie-Erbe)
- Inline value (atomar)
- Handle value (atomar)

**Kalibrierungs-Bausteine (Tabelle 2, Zeile "Kalibrierung"):**
- Working-set staircase (atomar)
- Stride sweep (atomar)
- Dependent pointer chase (atomar)
- Prefetch-distance sweep (atomar)
- TLB/page sweep (atomar)

**Mutations-Bausteine (Tabelle 2, Zeile "Mutation"):**
- Bulk build (atomar)
- Insert / update / delete (atomar)
- Rebuild / consolidation (atomar)

### B.2 Hybrid-Bausteine (zusammengesetzte / Mischlasten)

**Suchworkload-Hybride (Tabelle 2, Zeile "PRT-ART Suche"):**
- Exact hit/miss (zusammengesetzt aus Seitentyp + Suchpfad)
- Prefix hit/miss (Trie-Layer + Praefix-Kollabierung)
- Prefix enumeration (Iterator-Hybrid)
- Sequential lex-scan (Iterator + Layout-Hybrid)

**Mischlast-Hybride (Tabelle 2, Zeile "Mischlasten"):**
- YCSB-A/B/C/E/F-Profile ueber festen eigenen Harness — alle als Hybrid aus mehreren atomaren Operationen

**Architektur-Hybrid (T5-NA §1):**
- "PRT-ART selbst" wird als Hybrid-Konzept positioniert: "Bibliotheks- bzw. Control-Plane-Schicht, die Seitentypwahl, Layout, Inline-/Handle-Ablage, Prefetching und plattformspezifische Parameter aktiv steuert"

---

## C) Cache-Engine vs. Search-Engine — Permutations-Cross

Termin 5+6 grenzen Saeule A (ISearchEngine) und Saeule B (ICacheEngine) konzeptionell sauber ab, aber die explizite F15-Permutationsmatrix ist NICHT in Termin 5/6 ausformuliert. Die Permutationsbasis ergibt sich jedoch aus folgenden Stellen:

### C.1 Saeulen-Trennung (T5-NA §2 — geschaerfte Einordnung)

> "PRT-ART ist primaer eine aktive Cache-Engine bzw. Control Plane ueber trie-basierter Suche. Die Suchstruktur bleibt Mittel zum Zweck. Der wissenschaftliche Mehrwert liegt nicht in einem weiteren Trie als Selbstzweck, sondern in der messgetriebenen Orchestrierung von Seitentypwahl, Layout, Inline-vs.-Handle-Ablage, Prefetching und plattformabhaengigen Parametern."

T5-NA §2 nennt EXPLIZIT die Trennung:
- **Suchsemantik bleibt beim Algorithmus** (Saeule A)
- **Cache-Sicht bei der Engine** (Saeule B als wiederverwendbare Meta-Ebene)

### C.2 Permutations-Cross-Schema (aus den Quellen abgeleitet)

Aus T6-SF §2 (Benchmark-Familien) x T6-SF §1 (Pflichtplattformen) x T6-SF §4 (Modi) ergibt sich:

**Saeule A (Search-Engine) Bausteine:**
- ART-Algorithmus (P01)
- HOT (P02)
- Masstree (P03)
- CoCo-trie Praefixkollabierung (P04)
- START multibyte (P05)
- B²-tree page-lokale Decision/Span (P06)
- Wormhole (P07)

**Saeule B (Cache-Engine) Bausteine:**
- Seitentyp-Family (Dense/Sparse/Redirect/Lokal)
- Prefetching-Modus (off/static/warmup/online)
- Value-Policy (Inline/Handle)
- Layout-Parameter (Knotengr., Pointerzahl, Anordnung)

**Permutations-Cross (PRT-ART × Cache-Engine-Modus × Plattform × ISA):**
Ergibt Term-Anzahl: |Suchalgorithmen| × |Cache-Modus| × |Plattform| × |ISA| × |Workload-Profil|.
Bei naiver Vollstaendigkeit: 7 × 3 × 9 × 5 × 5 ~= **4725 Permutationen** — daher Pflicht zur Selektion via Pflichttests (T6-SF §2).

T6-AA "Pflichtfrage": *"Auf welchen Architektur-Extrema muss die Cache-Engine zeigen, dass sie ihre Seitentyp-, Layout- und Value-Ablage-Entscheidungen automatisch und plattformbewusst verbessern kann?"* — verankert die Permutation IMPLIZIT als Cache × Plattform × ISA, NICHT als Cache × Suchalgorithmus.

---

## D) Permutationsdimensionen total (alle Achsen aufgelistet)

Aus T6-AA + T6-SF konsolidierte Liste aller Permutationsdimensionen (in Reihenfolge der Pflicht):

| # | Dimension | Werte (aus T6-SF §1, §3) |
|---|---|---|
| **D1** | Hardware-Plattform | VisionFive 2 / RPi 5 / Mac mini M1 / ODROID-H4 Ultra / i7-1270P / i9-14900KS / Ryzen 9 9950X3D2 / Barnard (Sapphire Rapids) / Grace Hopper GH200 (+ optional Capella, + bedingt alter Intel-Mac-mini) |
| **D2** | ISA-Pfad | scalar / x86_avx2 / x86_avx512 / arm_neon / arm_sve2 |
| **D3** | Core-Typ (bei Hybrid) | cpu_core (P-Cores) / cpu_atom (E-Cores) — getrennt |
| **D4** | Cache-Engine-Modus | passiv-statisch / Warm-up-kalibriert / online-adaptiv |
| **D5** | Seitentyp | Dense / START-multibyte / sparse HOT / Redirect / lokale Suchraum-Seite |
| **D6** | Value-Ablage | Inline / Handle |
| **D7** | Prefetch-Strategie | off / static / Warm-up-distanz / online-adaptive Distanz |
| **D8** | Layout-Parameter | Knotengroesse, Pointerzahl, Kindanordnung, Suchschema |
| **D9** | Workload-Familie | Kalibrierung / Seitentyp-Mikro / PRT-ART Suche / Mutation / YCSB-Mischlasten |
| **D10** | Workload-Profil (innerhalb YCSB) | A read-mostly / B / C read-only / E scan-lastig / F read-modify-write |
| **D11** | Suchoperation | exact hit / exact miss / prefix hit / prefix miss / prefix enumeration / sequential lex-scan |
| **D12** | Mutationsoperation | bulk build / insert / update / delete / rebuild / consolidation |
| **D13** | Messstack | perf stat/record / PAPI / Intel Advisor MAP/CLU/Footprint / Instruments / Time Profiler / Intel MLC (optional) / PIKA (optional) |
| **D14** | Suchalgorithmus-Baseline (implizit, fuer Vergleichsmissionen) | ART / HOT / Masstree / B²-tree / CoCo-trie / START / Wormhole + PRT-ART |

T6-AA fixiert die **Pflicht-Auswertungs-Granularitaet:** "fuenf Rohlaeufe, keine Mittelung von Perzentilen, getrennte Ausweisung nach Plattform, Core-Typ, ISA und Cache-Engine-Modus" — d.h. mindestens D1 × D3 × D2 × D4 wird als Reporting-Dimension erzwungen.

---

## E) Scope-Freeze Termin 6 — Was IST im Scope, was IST RAUS

### E.1 Pflicht-IM-SCOPE (Termin 6 final)

**Plattformen-Pflicht (T6-AA §3 + T6-SF §1):**
- Lokal: VisionFive 2, Raspberry Pi 5, Mac mini M1, ODROID-H4 Ultra, i7-1270P, i9-14900KS, Ryzen 9 9950X3D2
- ZIH: Barnard (Sapphire Rapids), Grace Hopper GH200
- Optional: Capella (AMD EPYC 9334) als "interessanter AMD-Server-Zusatz"
- Bedingt: alter Intel-Mac-mini "nur nach exakter CPU-Erkennung"

**ISA-Pflicht:** scalar, x86_avx2, x86_avx512 (wo verfuegbar), arm_neon, arm_sve2

**Benchmark-Pflicht:** Working-set-, stride-, pointer-chase-, prefetch-, Seitentyp-Mikro + exact/prefix/build/update/delete + YCSB-Mischlasten

**Messstack-Pflicht:** perf stat/record auf Linux, PAPI auf ZIH, Intel Advisor MAP/CLU/Footprint auf Intel-x86, Instruments/Time Profiler auf macOS

**Cache-Engine-Modi:** Alle 3 Modi (passiv, Warm-up, online) MUESSEN verifiziert werden

### E.2 NICHT-IM-SCOPE / RAUS (T6-SF §5 — Termin-6-Nichtziele)

EXPLIZIT als Nichtziele markiert:
- **Keine GPU-Kerneloptimierung oder Nutzung;** auf Grace Hopper wird fuer Termin 6 NUR der CPU-/Speicherpfad verifiziert
- **Keine erzwungene Neuimplementierung fremder Algorithmen;** Baselines werden ueber Originalprojekte und Wrapper angebunden
- **Kein Multiwriter als Pflichtkern;** Schreibparallelitaet bleibt nachgelagert
- **Keine Volltheorie fuer den Instruction Cache als eigener Forschungspfad;** Schwerpunkt bleibt Datenpfad, Seitentypwahl, Prefetch und Layout

### E.3 Bedingt / nicht blockierend (T6-AA §4)

- Aelterer Intel-Mac-mini bleibt bedingt bis Modell-ID + CPU-Features + Messpfad geklaert
- Intel MLC nur als Hilfswerkzeug auf eigenen Intel-Maschinen, NICHT Primaerinstrument auf ZIH
- AMX auf Barnard "beobachtbar", aber NICHT als eigener Kernpfad fuer trie-basierte Suche eingefroren
- Grace Hopper: NUR CPU-/Speicherpfad, GPU-Kernelanalyse "not TODO"

### E.4 Cache-Engine Bausteine — was der Forschungslandkarte (T5) ueberlebt im Scope (T6)

Aus den 5 Clustern kommen IM SCOPE:
- Cluster 2.1 (Passive Layouts): Dense Page-Familie, pointerarme Adressierung, Knotengroesse-Sweeps — IM SCOPE
- Cluster 2.2 (Adaptive Tries): Seitentypfamilien (START/HOT/CoCo-trie/B²-tree-Ideen) — IM SCOPE
- Cluster 2.3 (Prefetching): Kalibrierungs-Sweeps + drei Modi — IM SCOPE
- Cluster 2.4 (Cache-oblivious): Nur als Kontrastbegriff — KEINE Implementation
- Cluster 2.5 (Habich/Dresden): Sprachebene + Messmethodik (perf, PAPI) — IM SCOPE

**RAUS aus Termin 5 -> Termin 6 (T5-NA §6 "Vorsichtig zu behandeln"):**
- "Direkte Verwaltung von Hardware-Caches" — als Behauptung RAUS
- "Explizite Programm-/Instruction-Cache-Steuerung" — RAUS (T6-SF §5 bestaetigt)
- "Universelle Prefetch-Regeln" — RAUS, ersetzt durch plattformabhaengige Kalibrierung

---

## F) Kuehn-Erkenntnisse / Block AN/AO/AP / Telemetrie-Strategie

### F.1 Kuehn (P28 DaMoN 2023) in Termin 5/6

**Befund:** Kuehn et al. wird in Termin 5/6 NICHT namentlich genannt. Suche in `_extracted_text` ergab keine Treffer fuer "Kuehn|Kühn|DaMoN|P28" in den Termin-5/6-Dateien. Die Kuehn-Erkenntnisse stammen aus der Tier-3-Lektuere (Task #56, P28 abgeschlossen) und wurden in Bausteine_Matrix + Domaenenmodell bereits eingearbeitet (Task #94 completed, Memory).

### F.2 Block AN/AO/AP

**Befund:** Diese Block-Bezeichnungen sind in Termin 5/6 NICHT vorhanden. Suche in `_extracted_text` ergab keine Treffer. Die Bloecke koennten aus internen Bausteine-Matrix-Dokumenten stammen (siehe `_temp/`-Sessions oder REV4-Skizze) — sind nicht Bestandteil von Termin 5/6.

### F.3 Telemetrie-Strategie (in Termin 5/6 NICHT als eigener Begriff, aber implizit)

T5/T6 nennen keine "Telemetrie-Strategie", sondern die folgende **Mess- und Verifikations-Strategie** (T6-AA §3 + T6-SF §3):

**Mess-Pflichtmetriken (T6-SF Tabelle 3):**
- Linux allgemein: cycles, instructions, branches, branch-misses, cache-misses, dTLB-misses, wall time
- Intel-Hybrid lokal: Miss-Verhalten getrennt nach P- und E-Cores; CLU und Footprint
- Intel-Server: LLC/Memory-Naehe, Server-AVX-512-Pfade, Vergleich zu lokaler Intel-Plattform
- AMD x86: LLC-Ausnutzung, 3D-V-Cache-Effekt, AVX-512-Pfad
- macOS / Apple Silicon: CPU-Zeit, Verteilung P/E, End-to-End-Latenz; KEINE AVX-Annahmen
- ZIH allgemein: Rohcounter je Job; exklusive Messjobs mit no_monitoring fuer eigene Counters

**Verifikations-Erfolgskriterium (T6-SF §4):**
> "Eine Plattform gilt als erfolgreich verifiziert, wenn die Cache-Engine auf derselben Hardware konsistent bessere Entscheidungen erzeugt als der statische Modus und die Verbesserungen gleichzeitig in End-to-End-Latenz sowie in Miss-/CLU-/Footprint-Metriken sichtbar werden."

**Auswertungsregeln (T6-AA §3 letzter Bullet):**
> "fuenf Rohlaeufe, keine Mittelung von Perzentilen, getrennte Ausweisung nach Plattform, Core-Typ, ISA und Cache-Engine-Modus."

Damit ist die Telemetrie-Strategie funktional festgelegt: **5 Rohlaeufe, Perzentile NICHT mitteln, Reporting-Dimensionen erzwungen (D1×D3×D2×D4)**.

---

## ANHANG: Designregeln R1-R6 (T5-FL §6) — Kanonische Cache-Engine-Direktiven

| Regel | Direktive |
|---|---|
| **R1** | "Die Cache-Engine sollte als Control Plane formuliert werden, nicht als vollwertiger 'Kernel' im hardwareseitigen Sinn." |
| **R2** | "Plattformkalibrierung vor dem produktiven Betrieb ist wissenschaftlich gut begruendbar; universelle Schwellwerte sind es nicht." |
| **R3** | "Dense-/Sparse-/Redirect-/lokale Suchraum-Seiten duerfen nicht als beliebige Sammlung erscheinen, sondern als messgetrieben ausgewaehlte Familie." |
| **R4** | "Inline vs. Handle ist ein First-Class-Thema, weil Value-Ablage direkt auf Cache-Line-Nutzung und Pointer-Kette wirkt." |
| **R5** | "Prefetching braucht Vorsicht: zuerst messen, dann aktivieren. 'Mehr Prefetch' ist kein Forschungsbeitrag." |
| **R6** | "Programmpfad- und Code-Page-Optimierung koennen als Zusatzhypothese erwaehnt werden, sollten aber nicht die Hauptbegruendung der Arbeit tragen." |

## ANHANG: Forschungsfrage-Formulierung (T5-NA §7)

> "Wie stark verbessern aktive, messgetriebene Cache-Entscheidungen — bezogen auf Seitentyp, Layout, Value-Ablage und Prefetching — die Leistung trie-basierter Suchstrukturen gegenueber passiven, statisch ausgelegten Varianten auf unterschiedlichen CPU-Plattformen?"

Damit ist die F15-Vergleichsmission als **PRT-ART (mit Cache-Engine in 3 Modi) vs. passive Baselines (statisch) ueber alle Plattformen** verankert.
