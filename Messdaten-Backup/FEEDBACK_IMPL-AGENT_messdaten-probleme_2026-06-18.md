# FEEDBACK → Implementierungsagent: Messdaten-Probleme

**Von:** Text-/Auswertungs-Agent · **Datum:** 2026-06-18 · **Status:** offen (Code-/Mess-seitig)
**Bezug:** Messlauf `tier150_measurements_INDEX320_cowfix-v1_2026-06-18.csv` (163 MB, `;`-getrennt,
154 Spalten, **120.960 valide Zeilen**). Auswertung: `AUSWERTUNG_2026-06-18_INDEX320_cowfix-v1.md`;
reproduzierbar mit `analyze_ff.py` (Python 3.13 + pandas, ohne scipy).

> Ziel dieses Dokuments: alle **noch existierenden** Probleme der Messdaten so beschreiben, dass der
> nächste Lauf die Forschungsfragen FF0–FF4 (cache-line-aware Hauptthema) **belastbar** beantworten kann.

---

## 0. Versuchsaufbau dieses Laufs (Ist)
- **320 Binaries** = vollfaktoriell `memory_layout(5) × node_type(4) × prefetch(4) × search_algo(4)`.
- **Fixiert (nicht variiert):** `isa=amd64`, `cache_traversal=linear_fanout`, `allocator=std_malloc`,
  `mapping=direct_placement`, `path_compression=none`, `concurrency=none`, `value_handle=inline`,
  `serialization=raw_binary`, `telemetry=leaf_only`, `index_organization=heap`, `io_dispatch=in_memory`,
  `migration=none`, `filter=bloom`, `queuing_q1/q2=no_buffer/eager`.
- **21 Workloads × 3 Wiederholungen**; Laufzeit-Sub-Achsen: `thread_count` 3 Werte, `prefetch_distance` 2 Werte.
- Messmodell: **Wall-Clock + Per-Achsen-Observer** (`ns_per_op`, `op_*_p50/p99`, `seg_<achse>_ns`,
  `stat_<achse>_*`). **Keine** Hardware-/PMC-Zähler.

---

## 1. Problem-Register (priorisiert)

| ID | Schwere | Problem | betroffene FF |
|----|---------|---------|---------------|
| **P-MD1** | **Blocker** | CLU-Instrumentierung defekt (zentrale Cache-Line-Metrik unbrauchbar) | FF3, FF0, FF2 |
| **P-MD2** | Hoch | System-Artefakte im Tail (Mehr-Millisekunden-Ausreißer) | alle (Latenz) |
| **P-MD3** | Hoch | `seg_*_ns` misst Observer-Overhead, nicht Organ-Algorithmuszeit | FF2, FF3 |
| **P-MD4** | Hoch | PMC/Hardware-Zähler fehlen vollständig | FF3 (Mikroarch.) |
| **P-MD5** | Hoch | Dimensions-Abdeckung zu eng (ISA/SIMD, Allokator, Plattform fix) | FF0, FF1 |
| **P-MD6** | Hoch | Kein PRT-ART und keine SOTA-Lebewesen im Lauf | FF3 |
| **P-MD7** | Mittel–Hoch | Arbeitssatz in-cache (~46 KB) → Layout/Prefetch ohne Hebel | FF0 |
| **P-MD8** | Mittel | `two_phase_valid` fängt Tail-Artefakte nicht ab | FF2 |
| **P-MD9** | Mittel | Mess-Umgebung nicht quiesziert (OneDrive/OS-Scheduling) | FF2 |

---

## 2. Detailbefunde, Ursache-Hypothese, geforderte Korrektur, Abnahme

### P-MD1 — CLU-Instrumentierung defekt **(Blocker)**
**Evidenz:** `stat_memory_layout_field_bytes` ist über **alle 5 Layouts identisch = 46.509** und
`stat_memory_layout_records` ebenfalls = 11.627; nur `stat_memory_layout_cache_lines` variiert als
**feste Records-Vielfache**: cache\_line\_aligned/soa/aosoa = 1×, packed\_bitmap = 2×, **aos\_strict = 16×**.
Daraus CLU = `field_bytes/(cache_lines·64)` = **0,39 %–6,25 %**.
**Warum falsch:** (a) 16 Cache-Lines pro (key,value)-Record ist physikalisch unmöglich. (b) `field_bytes`
≈ 4 B/Record, obwohl ein Record (u64-Key + u64-Value) ≥ 16 B belegt → **Unterzählung**. (c) `field_bytes`
ändert sich NICHT mit dem Layout → die Instrumentierung bildet das Layout gar nicht ab; `cache_lines` ist
ein fixes Modell-Vielfaches, **keine Messung**. CLU 0,4–6 % ist unrealistisch (real i. d. R. > 30–90 %).
**Geforderte Korrektur:** CLU aus dem **tatsächlichen Speicher-Image** je Layout bestimmen:
`field_bytes` = real belegte Nutzbytes (Key+Value+Metadaten, layout-abhängig), `cache_lines` = real
berührte/geladene 64-B-Lines bei den Operationen (oder aus dem konkreten Knoten-/Layout-Footprint
abgeleitet). CLU MUSS zwischen den Layouts differenzieren.
**Abnahme:** CLU plausibel (> 20 %), layout-abhängig unterschiedlich; `analyze_ff.py` meldet `clu_usable=True`.

### P-MD2 — System-Artefakte im Tail **(Hoch)**
**Evidenz:** Median 15.761 ns/op vs. Mittel 51.743; **Max 8.608.293 ns/op (~560× Median)**; 9,13 %
der Zeilen > 10× Median, **gleichverteilt über alle 3 Wiederholungen** (3.700/3.651/3.696) → kein
Warmup-Leck, sondern überwiegend echte Schwer-Workload-Kosten **plus** vereinzelte Extrem-Artefakte.
**Ursache-Hypothese:** OS-Scheduling-Preemption, Page-Faults, **OneDrive-Sync auf der Messmaschine**,
Thermik/Turbo-Schwankung — die Mehr-Millisekunden-Einzelwerte sind nicht algorithmisch.
**Geforderte Korrektur:** Messung auf der **quieszierten Experiment-OS (AP-M1)** mit CPU-Pinning,
deaktiviertem OneDrive/Hintergrunddiensten, fixiertem Takt; Ausgabe von Perzentilen + **winsorisierten**
Kennzahlen; ggf. Auto-Verwerfen system-gestörter Einzelläufe.
**Abnahme:** Max/Median-Verhältnis je (binary,workload) < ~20×; Mittel ≈ Median-nah nach Trim.

### P-MD3 — `seg_*_ns` nicht attributiv **(Hoch)**
**Evidenz:** Die Summe aller `seg_*_ns` deckt nur **~33,6 % der Wall-Clock** (`total_ns`) ab. Mediananteile:
**mapping 15,9 % + cache\_traversal 15,7 %** dominieren — ausgerechnet die in diesem Lauf **fixierten**
Organe; die cache-line-*entscheidenden* Organe sind winzig: memory\_layout **0,1 %**, search\_algo **0,2 %**,
node\_type **0,8 %**.
**Ursache-Hypothese:** Der Per-Achsen-Timer misst vor allem **Observer-/Instrumentierungs-Overhead**
(mapping/cache\_traversal-Observer), nicht die algorithmische Organ-Zeit; ~66 % der Zeit liegen außerhalb
der Segmente.
**Geforderte Korrektur:** Per-Achsen-Segment-Timing so überarbeiten, dass es **algorithmische** Organ-Zeit
attribuiert (Observer-Overhead separat ausweisen); `sum(seg_*_ns)` muss sich mit `total_ns` versöhnen
lassen (Coverage nahe 100 % oder explizit dokumentierter Rest).
**Abnahme:** Coverage > 90 %; die latenz-dominanten Organe (search\_algo/node\_type) tragen plausible Anteile.

### P-MD4 — PMC/Hardware-Zähler fehlen **(Hoch, FF3-Kern)**
**Evidenz:** Keine Spalten für L1/L2/L3-Misses, dTLB-Misses, Branch-Misses, IPC/CPI.
**Warum kritisch:** Genau diese Mikroarchitektur-Kennzahlen verlangt **FF3** (höhere Cache-Line-Auslastung,
weniger LLC-/dTLB-Misses, geringere Branch-Kosten). Ohne sie ist der eigentliche Cache-Line-Mechanismus
nicht beobachtbar — nur Latenz als Proxy.
**Geforderte Korrektur:** PMC via `perf`/PAPI integrieren (root-Linux-Experiment-OS, AP-M1) — die im
Thesis-Stand „vorgesehenen, noch ausstehenden" PMC-Kategorien aktivieren.
**Abnahme:** Pro Zeile L1/L2/L3-, dTLB-, Branch-Miss-Zähler + IPC/CPI; plausibel je Layout/Knoten.

### P-MD5 — Dimensions-Abdeckung zu eng **(Hoch, FF0/FF1)**
**Evidenz:** Nur 4 Achsen variiert; **ISA/SIMD, Allokator, Traversierung, Mapping u. a. fix**; nur eine
Plattform (amd64).
**Folge:** FF0 („unterschiedliche CPU-Plattformen, Hybrid/Sapphire Rapids") und FF1-Teilfrage
(`node_type × SIMD × path_compression`-Kopplung) sind **nicht testbar**.
**Geforderte Korrektur:** Build-Achse **SIMD** (SSE2/AVX2/AVX-512/…) variieren, Allokator-Korpus einbeziehen,
auf **≥ 2 Plattformen** messen (Hybrid-CPU + Sapphire Rapids).
**Abnahme:** ISA/SIMD + Allokator als variierte Achsen; ≥ 2 Plattform-Profile im Datensatz.

### P-MD6 — Kein PRT-ART / keine SOTA-Lebewesen **(Hoch, FF3)**
**Evidenz:** Variiert werden Such-**Methoden** (k\_ary/eytzinger/interpolation/linear\_scan), **nicht** die
SOTA-Entwürfe (ART/HOT/Masstree/…) oder PRT-ART. `binary_id` enthält kein `prt_art`.
**Folge:** **FF3 (Prüfling-Vergleich PRT-ART vs. 8 Rang-1-SOTA) ist gar nicht adressiert.**
**Geforderte Korrektur:** Die 30 SOTA-Profile + PRT-ART als Binaries aufnehmen und unter den drei
Pflicht-Messreihen A (Prüfling vs. SOTA), B (Entwurfs-Variation), C (Merge/Regression) messen.
**Abnahme:** PRT-ART + ≥ 8 Rang-1-SOTA im Datensatz, Messreihen-Tag A/B/C vorhanden.

### P-MD7 — Arbeitssatz in-cache **(Mittel–Hoch)**
**Evidenz:** ~11.627 Records, ~46 KB field\_bytes, 10.000 Ops → passt in L1/L2. memory\_layout kontrolliert
nur **1,5 %** Spanne (alle Cliff's δ negligible), prefetch ein Patt → Layout/Prefetch haben **keinen Hebel**,
weil nichts aus dem Cache fällt.
**Geforderte Korrektur:** **Cache-sprengende** Arbeitssätze (Millionen Records, deutlich > LLC), damit der
cache-line-aware Effekt überhaupt entstehen kann.
**Abnahme:** Datensatz-Größen-Sweep inkl. Working-Set > LLC; Layout/Prefetch zeigen messbaren Effekt
(Cliff's δ ≥ small) bei großen Sets.

### P-MD8 — Validitätsflag fängt Artefakte nicht **(Mittel)**
**Evidenz:** `two_phase_valid==1` für **100 %** der Zeilen — auch für die 8,6-ms-Ausreißer.
**Geforderte Korrektur:** zusätzliches **Per-Zeilen-Qualitätsflag** (z. B. „system-gestört", wenn
`ns_per_op` > k× Median seiner (binary,workload)-Gruppe), damit die Auswertung Artefakte hart filtern kann.
**Abnahme:** Quality-Flag-Spalte vorhanden; Artefakt-Zeilen markiert.

### P-MD9 — Mess-Umgebung nicht quiesziert **(Mittel)**
**Evidenz:** Lauf liegt im OneDrive-Pfad; Tail-Profil deutet auf Hintergrund-I/O + Scheduling.
**Geforderte Korrektur:** Messung außerhalb synchronisierter Ordner, dedizierte Kerne (isolcpus/pinning),
Governor=performance, Hyperthreading/Turbo dokumentiert/fixiert (Experiment-OS, AP-M1).
**Abnahme:** dokumentierte, reproduzierbare Mess-Umgebung; Tail deutlich reduziert.

---

## 3. Spezifikation des nächsten „sauberen" Laufs (Soll, kurz)
1. **CLU + seg-Timer fixen** (P-MD1, P-MD3) — sonst bleiben die Kernmetriken wertlos.
2. **PMC aktivieren** (P-MD4) auf root-Experiment-OS, **quiesziert** (P-MD2, P-MD9).
3. **Achsen erweitern:** SIMD/ISA + Allokator variieren; **≥ 2 Plattformen** (P-MD5).
4. **PRT-ART + SOTA-Profile** + Messreihen A/B/C aufnehmen (P-MD6).
5. **Working-Set-Sweep** bis > LLC (P-MD7).
6. **Qualitäts-Flag** + Perzentile/winsorisierte Ausgabe (P-MD8).
7. Auswertung weiterhin mit Median + **Statistik-Triade (MWU + Holm + Cliff's δ)**; Mittelwerte nicht berichten.

## 4. Reproduktion / Tooling (für den Impl-Agenten)
- `Messdaten-Backup/analyze_ff.py [csv]` → Konsolen-Report + `ff_summary.json` + `tikz_data.csv`
  (marginal + kontrolliert + Triade + Segment-Attribution + CLU-Diagnose + FF-Schlüsse).
- `Messdaten-Backup/AUSWERTUNG_2026-06-18_INDEX320_cowfix-v1.md` (Volltext-Auswertung).
- Querverweise: Doc 35 (function-handle-hops), Doc 14 (Achsen-Goldstandard), Doc 18 (Paper-Code-Map),
  AP-M1 (Experiment-OS), Dataset-Loader-Slot (`libs/common/measurement/dataset_loader/`).

## 5. Methodische Lektion (für die Berichterstattung)
Bei n im Tausenderbereich wird fast jeder Unterschied „signifikant" (p<0,05); erst **Cliff's δ** trennt
*relevant* von *irrelevant*. Beispiel aus diesem Lauf: node16 vs node4 p\_holm=2,8e-7, aber δ=−0,13
(**negligible**); memory\_layout-Paare teils signifikant, alle δ negligible. → Immer δ + Median mitberichten.
