I have the complete authoritative picture. Compiling the answer with exact citations.

---

**Pfad-Legende:** `ce` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine` · `super` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`

---

## 1. WO die Anforderung dokumentiert ist + exakter Wortlaut

Die autoritative Quelle ist das **V5-GRUNDMODELL (User-Direktive 2026-05-31)**, festgehalten in `ce/docs/architecture/messarchitektur_v5_drei_profile.md`. Es gibt **keinen** einzelnen Satz „Workloads=runtime, Achsen-Algorithmen=compile-time" wörtlich — die Anforderung ist als **Orthogonalität Build-Profil ⊥ Lastenprofil** formuliert, wobei Build-Profil = compile-time = Achsen-Kompositionen/Binaries und Lastenprofil = runtime = Workloads.

**`messarchitektur_v5_drei_profile.md:3-5` (User-Direktive wörtlich):**
> „DREI PROFILE streng getrennt: (1) BUILD-PROFIL statisch; (2) LASTENPROFIL host-seitig; (3) COMPILE-RELEASE-PROFIL (cmake, DEFAULT Messung eingebaut). Build-Profil ⊥ Lastenprofil = die zwei Haupt-Experiment-Achsen."

**`messarchitektur_v5_drei_profile.md:11-14` (die tragende Tabelle — Kernbeleg):**
> | 1 | **BUILD-PROFIL** | Compile-Time (configure) | WELCHE Lebewesen-Binaries (Kompositionen) + Permutations-Gesetzmäßigkeiten gebaut werden | configure-Zeit-Codegen … → je eine `.dll`/`.so` pro Komposition |
> | 2 | **LASTENPROFIL** | Runtime (host-seitig) | Testdaten-Range + Operationsabläufe (Op-Mix) + Umfang … | `WorkloadConfig` + `WorkloadGenerator` (xorshift64) + `MeasurementPlan`/`run_measurement_plan` |
> | 3 | **COMPILE-RELEASE-PROFIL** | Compile-Time (cmake-Option) | OB die DLL Messung … einkompiliert hat |

**`messarchitektur_v5_design.md:79`** (dieselbe Tabelle, W-Achse):
> | **(2) LASTENPROFIL** | … host-seitig generisch | YCSB A–F, record/operation_count, seed, OP-1..6, Pausen, Checkpoints | **Runtime host-seitig** `workload.hpp:34-40` … | Diplomarbeit/User (Achse 2) |

**Thesis (Aufgabenstellung, autoritativ)** — `super/thesis/diplomarbeit/kapitel/de/`:
- `03_messsystem_prtart.tex:364-365`: „Erst wenn *alle* Lastprofile gegen *alle* Lebewesen-Binaries laufen — **der Workload als dynamische Achse** (Kapitel~\ref{ch:eval}) —, lässt sich der 'Sieger nur im selbstgewählten Heimprofil' sichtbar machen".
- `03_messsystem_prtart.tex:80`: „T12 ISA (F) … **Ziel-ISA als Compile-Time-Achse**" (Gegenstück: Algorithmus-Achse = compile-time).
- `03_messsystem_prtart.tex:441`: Permutations-Binaries, „die **zur Laufzeit als ABI-stabile C++23-Module geladen** werden".

## 2. Wie W / D / M modelliert sein SOLLEN (compile-time vs. runtime) — und Doc 15 (F7)

**Achtung, zwei getrennte Architektur-Ebenen — hier liegt die einzige Nuance/Spannung:**

**(a) Experiment-/Ausführungsmodell (V5 + Thesis, operativ):**
- **W (Workload) = RUNTIME**, host-seitig (`drei_profile.md:13`, `design.md:79`). YCSB A–F, seed, n_ops via `WorkloadGenerator`/`run_measurement_plan`.
- **D (Dataset) = RUNTIME** (Teil des Lastenprofils „Testdaten-Range", `drei_profile.md:13`; `design.md:79`).
- **M (Mess-Kategorie) = COMPILE-TIME-Schalter** über das Compile-Release-Profil: `COMDARE_MEASUREMENT_MODE` bindet observer_all/memento_all ein/aus (`drei_profile.md:14`, `design.md:80,95`). Die Kategorien-Klassifikation selbst ist compile-time (`ce`-Vorbild: 16-`MeasurementCategory`-Enum).

**(b) Modul-Struktur der wiederverwendbaren Mess-Bibliothek — Doc 15 (F7), `super/docs/architektur/15_F7_mess_frameworks_workloads_2d_matrix_plan.md`:**

Doc 15 stellt den Struktur-Fork **wie 2D (M×W) in das strikt 1D-Baseline-Layering passt** und empfiehlt **Option A** (`15:34,38`):
> **Option A — 2. Dimension als compile-time-Parametrisierung IN den Zellen (F6-Metaprogrammierungs-Framework je Thema).** … `workloads` parametrisiert compile-time über `{YCSB-A,C,E} × {6 Datasets}`; `metrics`/`pmc` über den Kategoriensatz … Die „Matrix" ist das Kreuzprodukt der compile-time-Parameter, kein Zell-Kreuzprodukt. **Golden/ABI-neutral, additiv, keine Zell-Explosion, INV-1..4 unberührt.**
> **Empfehlung: Option A.** Begründung: (i) F6-Doktrin … „compile-time Auswahl"; (ii) Thesis-Wort „Workload als **dynamische Achse**" = **Parametrisierung, nicht Modul-Explosion**; …

- Option B = je Workload-Profil ein eigenes Modul (Zell-Explosion, `15:35`) — verworfen.
- Option C = eigene Familien-Achse `comdare-workloads-all` (`15:36`) — verworfen.

**Auflösung der Spannung:** Doc 15 „compile-time" meint das **F6-Metaprogrammierungs-Interface des Workload-MODULS** (welche Profil-/Dataset-Werte im Katalog verfügbar sind; `tab:workload-routing` als `constexpr`-Map, `15:44`) — **NICHT**, dass der Workload ein Faktor der Binary-/golden-320-Matrix wird. Explizit `15:48,59`:
> Die „feingliedrige 2D-Matrix" ist … das compile-time-Kreuzprodukt … **instanziiert je Mess-Lauf — analog zur ce-Anatomie-Matrix … nicht als Repo-Explosion.** … **Mess-Matrix ist orthogonal zur Anatomie-Permutation.**

Die tatsächliche Workload-Wahl/-Treibung gegen die geladene Binary bleibt runtime (Thesis-Pipeline `06_evaluation_methodology.tex:41-46`: Phase (3) **Compile** → (4) **Load** → (5) **Execute** = `run_workload`).

## 3. Compile-time (Achsen-Anatomie, golden 320) vs. Runtime

**COMPILE-TIME (erzeugt Binary-Identität / golden_fullpilot_320):**
- Die Achsen-**Permutation** (welche Achsen-Algorithmen ein Lebewesen komponieren) — `mp_product` **nur über die Kompositions-Achsen** (17/19). `ce/docs/architecture/27_experiment_baum_registry_bindung_4_bruecken.md:299`: „`composition_binary_count() = ∏ mp_size(Enabled_i)` … (constexpr, OHNE `mp_product`-Materialisierung)".
- `ce/docs/architecture/26_permutations_bplus_baum_und_inverse_signatur.md:158-161` (Kern-Definition):
  > „**Die Knotenart IST die compile-time/runtime-Unterscheidung** (kein separates Flag): `StaticAxisNode` = compile-time → lädt eine Binary; `DynamicVariableNode` = Laufzeit-FOR-SCHLEIFE auf der geladenen Binary … Compile-time-variierende Eigenschaften (auch cacheline-size/alignment …) sind daher **StaticAxisNodes** (sie erzeugen Binaries); nur echt laufzeit-einstellbare Größen (thread_count, hw_prefetcher) sind `DynamicVariableNodes`."
- Ebenfalls compile-time eingebacken: cacheline `line_size/alignment/sw_hint`, ISA (T12), `COMDARE_MEASUREMENT_MODE`. (`28:117`; Thesis `03:80`)

**RUNTIME (FOR-Schleife auf EINER geladenen Binary, keine Rekompilation):**
- Workload-Profil (YCSB), **Seed**, **n_ops/operation_count**, **records**, **Dataset**, **n_repeats**, thread_count, hw_prefetcher, Pausen — via `WorkloadGenerator` (xorshift64, bit-identisch je Seed) + `run_measurement_plan`. (`drei_profile.md:13,26-29,45`; `ce/docs/architecture/33_undolog_memento_und_mess_resume.md:109-110`)

## 4. Explizite Aussage: Workloads NICHT compile-time / kein mp_product-Faktor der Binary-Matrix

**Ja, mehrfach explizit:**

- **`ce/docs/architecture/messarchitektur_v5_design.md:100`** (schärfste Aussage):
  > „**Lastenprofil hat absichtlich KEINE neuen CMake-Flags** — es ist host-seitig zur Laufzeit (**Runtime-Matrix-Achse**)."

- **`ce/docs/architecture/28_vollstaendigkeits-kartographie.md:117`**:
  > „DYNAMISCHE Knoten = FOR-Schleife auf EINER geladenen Binary … **KEINE neue Binary**. … `binary_count` = Zahl distinkter Static-Pfade; **dyn. Kartesik wird NICHT aufgefächert** (`experiment_setting_count = binary_count × ∏ dyn`)."

- **`28:119` / `drei_profile.md:18,26`**: „Build ⊥ Lasten = kartesisches Kreuz (**1 Binary × N Lastprofile ohne Rekompilation**)."

- **`ce/docs/architecture/34_KONSOLIDIERTER_MASTER_IST_STAND.md:217`** (Mission-Verankerung, „golden 320"):
  > „Matrix **320 Lebewesen** × 18 dyn × **21 Lastprofile** … Lebewesen = Static-Pfad/binary_id, **Lastprofil = dynamische Achse 2 (DynamicVariableNode, FOR-Schleife auf geladener Binary)** | NICHT flach im Eval-Tool".

- **`super/docs/architektur/15_F7_…:59`**: „**Mess-Matrix ist orthogonal zur Anatomie-Permutation**"; `golden_fullpilot_320 … unberührt".

- **Ledger** (`super/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`, Eintrag 2026-07-07): „Tier-Binary-KONSTRUKTIONS-Achsen = 19 Kompositions-Achsen … **compile-time-Komposition je Permutation zur SHARED Tier-DLL** … System-Messachsen = ORTHOGONAL darübergelegt … **2 Experiment-Achsen Build-Profil × Lastenprofil**; `COMDARE_MEASUREMENT_MODE` = Compile-Schalter."

**Wichtige Präzisierung für den Aufrufer:** Das „kein mp_product-Faktor" gilt für die **golden-320-Anatomie-/Binary-Matrix** (nur Kompositions-Achsen). Doc 15 Option A macht den Workload-**Katalog** sehr wohl zu einem **compile-time-Parameter des Workload-MODULS** (F6-Metaprogrammierungs-Interface) — das ist eine separate, explizit als orthogonal deklarierte Struktur-Ebene und widerspricht der Runtime-Treibung nicht. Falls der Aufrufer eine Aussage sucht, die Workloads generell (auch modulintern) von jeder compile-time-Behandlung ausschließt: **die existiert nicht** — im Gegenteil empfiehlt Doc 15 (F7, neuestes Planungsdokument, 2026-07-08) für die Modul-Struktur compile-time-Parametrisierung. Runtime ist ausschließlich für das **Experiment-/Ausführungsmodell** (V5-Lastenprofil, Thesis-Phase Execute/`run_workload`) verbindlich.