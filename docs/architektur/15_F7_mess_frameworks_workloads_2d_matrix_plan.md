# 15 — F7: Mess-Frameworks × Workloads als feingliedrige 2D-Matrix-Module (Planung)

**Status:** PLANUNG (kein Code-Increment, keine Modul-Neuanlage). Grundlage für die #31-Folgearbeit.
**Bezug:** Ledger-F7 (`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:298` „die gesamte Matrix aller Mess-Frameworks × Workloads muss noch als Module mit feingliedriger Baseline-2D-Matrix-Struktur abstrahiert werden"), F14-Recherche (Task #30, ADDENDUM 2 Pkt 4), Diplomarbeit `thesis/…/kapitel/de/{03_messsystem_prtart,06_evaluation_methodology}.tex`.
**Invarianz:** rein additiv, golden/ABI-neutral, INV-1..4-treu. Dieses Dokument definiert die 2D-Achsen und legt den Struktur-Fork offen; es nimmt KEINE Realisierung vorweg. `comdare-measurement-all` (metrics/pmc/workloads), die laufende Mess-Pipeline 286 und der ce-Monolith bleiben unberührt, bis ein konkreter Realisierungs-Increment (eigene Kadenz, ggf. User-GO) folgt.

> ---
>
> ## ⚠️ STAND 2026-08-07: BELEGSTELLEN VERALTET
>
> **Der Plan (2D-Matrix-Zuschnitt, Struktur-Fork, Invarianz-Zusage) gilt weiter. Zwei Anker nicht.**
> Belege gegen ce `ba069e38` (identisch in `ab0b352e`).
>
> | Aussage im Dokument | Ist-Stand 07.08. | Beleg |
> |---|---|---|
> | `:70` „golden_fullpilot_320 / conformance-Oracle / **ABI-4** unberuehrt" | ABI-MAJOR ist **8** | ce `abi/anatomy_module_abi_v1_decl.hpp:89` |
> | `:16` „**Der committete** ce-`workload_matrix.hpp` … 36 Zellen compile-time" | **ENTFERNT.** Der G2-Revert ist vollzogen; `workload_matrix` hat im ce **null** Treffer (Datei und Inhalt). Die Praesens-Formulierung liest sich als Ist-Zustand und ist es nicht | Nullbefund nach Basisnamen-Suche ueber den ce-Baum |
> | `:4` Ledger-Anker „**`…LEDGER.md:298`**" | **Zeile falsch.** `:298` traegt heute „## §2 BLOCKER — MUSS ZUERST KLAEREN". Das zitierte F7-Diktum steht verbatim bei **`:724`** | super `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:724` |
> | `:13` Ledger-Anker „**`:371`**" | **Zeile falsch.** `:371` traegt „### §10.1 NOMENKLATUR-KONSOLIDIERUNG E0-E4"; das Zitat steht bei **`:797`** | ebd. `:797` |
> | `:49` „F6-Doktrin (**Ledger:298**)" | derselbe falsche Anker wie `:4` | ebd. `:724` |
>
> **Weiterhin korrekt (nicht anfassen):** `:29` „der gleichnamige ce-Ort
> `libs/cache_engine/builder/measurement_matrix/` ist ein **leeres Skelett**" -- trifft woertlich zu:
> das Verzeichnis enthaelt nur `.gitkeep` und eine `CMakeLists.txt` ohne Quellen.
> `:37`, `:55` der 6er-Datensatz-Kanon: die Loader sind gebaut
> (`libs/common/measurement/dataset_loader/`).
>
> **Ungeprueft:** die Ist-Tabelle `:20-27` zu `comdare-measurement-all` -- diese Zellen liegen in
> eigenen GitLab-Repos, in keinem der beiden Arbeitsbaeume.
>
> ---

## 0. E-EBENEN-KORREKTUR (Nachtrag 2026-07-09 — additiv, autoritativ)

> **Bezug:** `docs/architektur/16_E1_E4_KONSOLIDIERUNG_DOSSIER.md` (Teil B.5 + D), Ledger `§10.1` + `:371`. Dieser Nachtrag ordnet die zwei Achsen dieses Plans **ebenen-richtig** in die E0-E4-Experiment-Maschinerie ein — der ursprüngliche Plan (Abschnitte 1-6) liest „Workload als dynamische Achse" teils als compile-time und rahmt M×W ohne E-Bezug. Additiv, golden/ABI-neutral; die Abschnitte 1-6 bleiben als measurement-all-**Modul-Organisations**-Sicht (Option A) gültig, werden aber durch die folgende E-Zuordnung präzisiert.

**Kernsatz (ebenen-richtig):**
- **Achse M (Mess-Kategorien)** = **compile-time, E0/Tooling** (measurement-all-Modul-Interna). Option A (F6-Metaprogrammierung in den Zellen `metrics`/`pmc`/`workloads`) ist hier KORREKT und golden-orthogonal — es ist die *interne* Code-Organisation der Mess-Module, KEINE Binary-Identitäts-Achse.
- **Achse W (Workload × Dataset)** = **E4-XML-definiert + E1-Laufzeit** (Workload-Profil-Wahl je Messreihe, `DynamicVariableNode`) **+ E3-Permutation** (Dataset als CEB-„4. Dimension"). **NICHT** compile-time-statisch in der ce-Library. Beleg: Ledger `:371` („Mess-INPUT = DynamicVariableNode-Seite des experiment_tree, KEINE Binary-Identitäts-Achse; `permutation_axes.xml` bleibt TABU").
- **Dritte Dimension A/B/C × Micro/Makro/Gesamt** = **E4-Auswertung** (Spalten-Projektion im CSV/LaTeX), niemals `mp_product`-Lauffaktor.

**Abgrenzung zum #31-Fehlbau:** Der committete ce-`workload_matrix.hpp` (`mp_product<…, ycsb_profile_list, dataset_list>` = 36 Zellen compile-time in der Library, E2) verwechselt Achse W mit einer Binary-Achse — genau der von diesem Nachtrag ausgeschlossene Fall. Korrektur = **G2-Revert** + **E4-XML-Verortung** (Dossier 16 Teil D). Die measurement-all-Realisierung (Abschnitte 4-5, Option A) bleibt davon unberührt und **gated** hinter Migrationsplan-Schritt 13.

## 1. Ist-Struktur (verifiziert)

`comdare-measurement-all` ist heute eine **strikt 1D-Baseline-Schichtung** (Familie × Baseline-Stufe, je Stufe genau **eine** Zelle), INV-2-konform `n→n-1`:

| Baseline-Stufe | Zelle | Belang (F14-Mapping) |
|---|---|---|
| `baseline_0-core` | `comdare-metrics` | Signal-/Collection-Kern (`IMeasurementObserver`, Counter/Gauge/Histogram/Summary) + HDR (`LatencyHdrHistogram`, `latency_stats`) |
| `baseline_1-instrumentation` | `comdare-pmc` | Zähler-Quellen (`IPmcSource`, Linux-perf / Windows-PCM, compile-time Factory) |
| `baseline_2-workloads` | `comdare-workloads` | LoadGen + Dataset (YCSB-Kern, Driver, Dataset-Registry) — **gebündelt** |
| `baseline_3-analysis` | *(nur vorgesehen, leer = kein Ordner)* | Post-Processing/Statistik/Export (F14-Empfehlung) |

**Die „Achsen" dieser 1D-Schichtung sind Mess-BELANGE (Kern → Instrumentierung → Last), NICHT Framework × Workload.** Weder sind Workloads je Profil (YCSB-A/C/E, `tab:workload-routing`) noch Mess-Kategorien je Kategorie (die 16 ce-`MeasurementCategory`) in Module zerlegt — beides liegt gebündelt. Eine Framework×Workload-2D-Matrix existiert nicht (der gleichnamige ce-Ort `libs/cache_engine/builder/measurement_matrix/` ist ein leeres Skelett).

## 2. Die zwei Achsen (aus der Diplomarbeit, autoritativ)

**Achse M — Mess-Frameworks/-Kategorien** (`03_messsystem_prtart.tex:382`, `06_…:119`): kanonischer Kategoriensatz **Cache-Line-Auslastung, Cache-Misses (L1/L2/L3), dTLB-Misses, Speicher-Fußabdruck, Branch-Misses, IPC/CPI, Latenz, Durchsatz, Energie** — mit der tragenden Zweiteilung:
- **zeit-/observer-basiert** (Wall-Clock, HdrHistogramm, Per-Achsen-Observer) → unter beiden OS-Regimes; heute in `metrics(b0)`.
- **zählerbasiert (PMC)** (Cache/dTLB/Branch-Miss, IPC/CPI) → nur privilegiertes Regime; heute in `pmc(b1)`.

**Achse W — Workloads** (`03_…:248` `tab:wl-frameworks`, `06_…:68` `tab:workload-routing`, `:87` `tab:datasets`): die Benchmark-Frameworks (YCSB, SOSD, TPC-C/DS, SPEC CPU, CloudSuite, mimalloc-bench, …) werden per Thesis-Direktive **„zu einem gemeinsamen Satz von Lastprofilen abstrahiert"** — konkret die YCSB-Profile **A** (50/50 Zipf) / **C** (Read) / **E** (Range), gekreuzt mit dem **6er-Datensatz-Kanon** (url/dna/protein/xml/tpcds-id/trec-terms, #25). Thesis: „der Workload als dynamische Achse" (`03_…:365`).

**Orthogonale dritte Dimension (nicht 2D-relevant, nur Vollständigkeit):** die drei Messreihen A/B/C × drei Granularitäten Micro/Makro/Gesamt (`06_…:6`).

## 3. Struktur-Fork (echter Architektur-Entscheid, NICHT geraten)

Die Kernfrage: wie wird die **2D**-Matrix (M × W) mit dem strikt **1D**-linearen Baseline-Layering (`baseline_N`, `n→n-1`, INV-2) vereinbart? Drei Optionen:

- **Option A — 2. Dimension als compile-time-Parametrisierung IN den Zellen (F6-Metaprogrammierungs-Framework je Thema).** Die 1D-Baseline (metrics/pmc/workloads) bleibt; jede Zelle wird ein Kopf-Framework mit Metaprogrammierungs-Interface über ihre Achsen-Werte: `workloads` parametrisiert compile-time über `{YCSB-A,C,E} × {6 Datasets}`; `metrics`/`pmc` über den Kategoriensatz (zeit/observer vs. zähler). Die „Matrix" ist das Kreuzprodukt der compile-time-Parameter, kein Zell-Kreuzprodukt. **Golden/ABI-neutral, additiv, keine Zell-Explosion, INV-1..4 unberührt** (die Baseline-Kette bleibt `workloads→pmc→metrics`).
- **Option B — 2. Dimension als eigene Zellen (je Workload-Profil / je Kategorie ein Modul).** `comdare-workload-ycsb-a`, `-ycsb-c`, `-ycsb-e`, … + `comdare-metric-cachemiss`, `-branchmiss`, … → **Zell-Explosion** (M×W Zellen), jede mit eigenem Repo/CMake/CI. INV-2 erzwingt strenge n→n-1-Ketten je Profil-Zelle; hoher Wartungs-Overhead.
- **Option C — 2. Dimension als getrennte Familien-Achse** (`comdare-workloads-all` neben `comdare-metrics-all`). Bricht die etablierte eine `comdare-measurement-all`-Familie auf; widerspricht dem F14-Mapping (0-core/1-instrumentation/2-workloads als EINE Familie).

**Empfehlung: Option A.** Begründung: (i) F6-Doktrin (`feedback_achsen_thema_modul_framework_metaprogramming_interface`, Ledger:298) — „je Thema ein Modul-Framework mit Metaprogrammierungs-Interface, compile-time Auswahl"; (ii) Thesis-Wort „Workload als **dynamische Achse**" = Parametrisierung, nicht Modul-Explosion; (iii) golden/ABI-neutral + INV-treu (Baseline-Kette unverändert); (iv) deckt sich mit der bestehenden compile-time-Factory in `pmc` (`pmc_source_factory`) und dem ce-Vorbild (16-`MeasurementCategory`-Enum + `axis_observer_classification` klassifiziert alle 26 Achsen compile-time). Option B bleibt möglich, falls der User jedes Workload-Profil als eigenständig versioniertes/ge-CI-tes Modul erforschen will (dann eigener Struktur-GO + INV-2-Ketten-Design).

## 4. 2D-Matrix nach Option A (Ziel-Skizze, zu realisieren als Folge-Increment)

Kreuzprodukt als compile-time-Parameter, verankert je bestehender Zelle:

- **`workloads(b2)`** — Kopf-Interface `comdare::workloads::matrix` über `WorkloadProfile ∈ {YcsbA, YcsbC, YcsbE}` × `Dataset ∈ {url,dna,protein,xml,tpcds-id,trec-terms}`; `tab:workload-routing` = die Traversal-Tag→Profil-Bindung als `constexpr`-Map. Default = heutiger gebündelter Pfad (bit-identisch).
- **`metrics(b0)` + `pmc(b1)`** — Kategorie-Achse `MeasurementCategory` (zeit/observer-Teilmenge in metrics, zähler-Teilmenge in pmc) als compile-time-selektierbare Kollektor-Menge; deckt den Thesis-Kategoriensatz. Regime-Gate (privilegiert vs. immutable) als Achsen-Merkmal.
- **`baseline_3-analysis`** (F14) — als vorgesehene Stufe für Post-Processing (Median/Perzentile, Mann-Whitney-U/Holm, Cliff's δ) angelegt, sobald benötigt; Validation bleibt AUSSERHALB (F14).

Die „feingliedrige 2D-Matrix" ist damit das compile-time-Kreuzprodukt (Kategorie-Achse) × (Workload-Achse), instanziiert je Mess-Lauf — analog zur ce-Anatomie-Matrix (Permutation compile-time), nicht als Repo-Explosion.

## 5. Roadmap (je eigener Kadenz-Increment, nach User-Wahl A/B/C)

1. `workloads`-Kopf-Framework: `WorkloadProfile × Dataset` als compile-time-Parameter (Default = Ist, golden-neutral) + Trait-Test.
2. `metrics`/`pmc`-Kategorie-Achse: `MeasurementCategory`-selektierbare Kollektor-Menge + Regime-Gate.
3. `baseline_3-analysis` anlegen (F14), zunächst Interface-Skelett.
4. NACH Migrationsplan-Schritt 13 (GATED): Diplomarbeit konsumiert `measurement-all` statt ce-Kopie — dann läuft die 2D-Matrix produktiv gegen die Tier-Binaries.

## 6. Tabus / Invarianten (unverändert)

INV-1 (Baseline haargleich) · INV-2 (`n→n-1`, keine Aufwärtskanten — die Kette `workloads→pmc→metrics` bleibt) · INV-3 (Produkte→Produkt-Baselines) · INV-4 (Verstöße = Link-Blocker, nie Workaround). Keine Zell-Explosion ohne User-GO. `measurement-all`-Zellen + Pipeline 286 + ce-Monolith unberührt bis Realisierungs-Increment. Metaprogrammierung compile-time (Concepts/`if constexpr`/Factory), kein runtime-switch. golden_fullpilot_320 / conformance-Oracle / ABI-4 unberührt (Mess-Matrix ist orthogonal zur Anatomie-Permutation).

## Nachträge — E2E-Re-Audit 2026-07-15 (Ausrichtung an §0-GOAL-V5 / erweiterte A-H-Architektur)

> Additive Ausrichtungs-Vermerke; der Originaltext oben bleibt unverändert (Doku nie löschen).

- **[R7 · Anker docs/architektur/15_F7_mess_frameworks_workloads_2d_matrix_plan.md:20]** Keine Änderung nötig — das Baseline-Layering-Gebot (in Stein, `n→n-1`, nur niederwertigere Stufen referenzierbar) ist bereits gewahrt: Die 1D-Baseline-Schichtung (§1) ist INV-2-konform und die Kette `workloads→pmc→metrics` bleibt (§6). Vermerk rein bestätigend als Coverage-Nachweis (Beleg-Zeilen 20, 24–27, 45, 70); kein fälschlich gemeldeter Konflikt.  \n  *(Bezug: measurement-all ist strikt 1D-Baseline-Schichtung, INV-2-konform `n→n-1`, Kette `workloads→pmc→metrics` bleibt.)*
- **[R2 · Anker docs/architektur/15_F7_mess_frameworks_workloads_2d_matrix_plan.md:55]** Additiv einen Abschnitt ergänzen, der die runtime-getriebene W-Achse an die E4-Experiment-XML (`DynamicVariableNode`) bindet und offenlegt, WIE Workload/Dataset-Profile enumeriert werden. Option A (Workload × Dataset als compile-time-Parametrisierung der measurement-all-Zelle) bleibt per §0 als reine Modul-Interna golden-orthogonal korrekt; offen ist allein die Brücke zur Unified-Experiment-XML. Caveat (verify_note): Die etablierte SOTA-Antwort (Doc 17:49) verortet den Workload-Katalog als Laufzeit-Bibliothek in `measurement-all`/`comdare-workloads`, die die ce konsumiert — NICHT in den Anatomie-Registries (R1 = 90 Achsen-Bausteine). Der Katalog ist daher zu referenzieren, nicht als Baustein-Insel zu duplizieren; ob Workloads überhaupt „Bausteine je Achse" im Registry-Sinn sind, bleibt offen (Workload = Mess-INPUT/`DynamicVariableNode`, keine Binary-Identitäts-Achse, §0).  \n  *(Bezug: `workloads(b2)` — Kopf-Interface `comdare::workloads::matrix` über `WorkloadProfile ∈ {YcsbA,YcsbC,YcsbE}` × `Dataset ∈ {url,dna,protein,xml,tpcds-id,trec-terms}`.)*

---

### → §59 KERN-Mess-Schema (2026-07-20)

> Additiver Querverweis (kein Duplikat). Die hier geplante 2D-Mess-Matrix ordnet sich unter die KERN-Mess-Schema-Steuerung (Ledger §59): **Default = ALLES messen**, die XML wirkt als **negatives Blacklisting**. Das Mess-Tooling {Wallclock/Makro/Micro} ist eine **Unter-Achse, compile-time fix in CEB+Tier** (die W-Achse Workload/Dataset bleibt bewusst runtime, R6-konform). Drei Mess-Stufen: ① CE allein · ② je Prüfling `replace`/`merge` · ③ kombiniert `fulljoin`. Volle Fassung: **Ledger §59**.
