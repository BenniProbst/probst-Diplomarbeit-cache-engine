# CHEF-SYNTHESE — Zwei User-Entscheidungen (E11: Phasen-Struktur/Schema-Evolution, E13: "#37-3-Achsen")

Alle Pfade relativ zu `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine` (= super); ce = `super/Code/external/comdare-cache-engine`; Thesis = `super/thesis/diplomarbeit`.

---

## TEIL E11 — DIE ECHTE PHASEN-STRUKTUR

### E11.1 Vollständige Phasen-/Modi-Taxonomie (Thesis + Architektur-Doku)

Die User-Feststellung "das Experiment hat MEHR ALS 3 Phasen" ist quellengedeckt. Es existieren **sieben getrennte Haupt-Vokabulare** (plus Neben-Vokabulare); "genau 3 Phasen" steht an KEINER Stelle der Thesis — es ist ausschließlich eine XSD-Setzung der 3-Stufen-Prüf-Dimension.

| # | Vokabular | Inhalt | Typ | Primärquellen |
|---|---|---|---|---|
| 1 | **Sieben-Phasen-Mess-Pipeline** (+2 opt-in) | (1) Enumerate, (2) Codegen, (3) Compile, (4) Load, (5) Execute, (6) Measure, (7) Persist; opt-in: Hot-Compile fehlender Module, ABI-Vertrags-Funktionstest | sequenziell, je Lauf | Thesis `kapitel/de/04_implementierung.tex:108-114`: "Über diese Bausteine läuft die \emph{Sieben-Phasen-Mess-Pipeline} … des \texttt{ExperimentDriver} je Reihe"; gleichlautend `06_evaluation_methodology.tex:41-48`, `04_concept_architecture.tex:123-124` |
| 2 | **Folge-Phase Heuristik-Extraktion** (Ausblick, selbst 3-schrittig) | nach Persist: Feature-Extraktion → ML-Klassifikator → empfohlene Komposition; Ergebnis = XML-Lastprofil, rückgespeist in `<expected_workload>` ("measure → profile → config → filter"-Kreislauf) | sequenziell, nach #1 | Thesis `03_messsystem_prtart.tex:569-582`, `06_evaluation_methodology.tex:154-172`, `06_fazit.tex:95-103`, `aufgabenstellung/de.tex:89-96` (Teilaufgabe 7) |
| 3 | **3-Stufen-Prüfung + build-übergreifende 4. Zeile** | Stufe 1 CE-only / Stufe 2 Prüfling-Replace / Stufe 3 Full-Join; Tabelle `tab:stage-series` hat VIER Zeilen ("build-übergreifend & alt gegen neu derselben Konfiguration & C") | orthogonal (Kompositions-Raum) | Thesis `03_messsystem_prtart.tex:437-440, 465-470, 474-484`; ce `docs/architecture/24_…:590-594`; super `docs/architektur/14_…:257-263, 784-828`; Enum in `pruefling_merge.hpp` |
| 4 | **3 Pflicht-Messreihen A/B/C** (mit Sub-Modi A_defined/A_full) | A: PRT-ART vs. SOTA; B: systematische Achsen-Variation; C: Merge/Regression build-übergreifend | orthogonal | Thesis `03:492-497`, `aufgabenstellung/de.tex:75-77`; WICHTIG `03:465-470`: Stufen ↔ Reihen NICHT 1:1 |
| 5 | **3 Granularitäten** | Micro / Makro (std::map-Ops) / Gesamt (YCSB) | orthogonal | Thesis `03:497-500`, `aufgabenstellung/de.tex:78-84` |
| 6 | **MessreihenMode / Lauf-Skalen** | `Defined` / `Full` / `Full-Sampled`; Prozessdirektive Smoke-vor-Voll | Umfangs-Auswahl je Lauf | Thesis `03:507-510`, `06_eval:146`; Ledger:96 (§0-GOAL-V5.5 "Smoke-first"); XML `metadata/mode` `experiment_golden.xml:27` |
| 7 | **3 Mess-Modi M1/M2/M3** | M1 Lebewesen-Wall-Clock, M2 Per-Achsen-Observer (`observe_all()`, 2 Trigger-Modi per-Op/Checkpoint), M3 Achsen-Vergleich vs. std::map | orthogonal (Mess-Dimension) | ce `docs/architecture/24_…:34, 75-82, 477-484`; super `docs/architektur/18_…:149` (R10); Ledger:1245 (§15.7) |
| 8 | **4 CEB-Betriebsmodi — vom User selbst "Phasen" genannt** | Messmodus → Auswertungsmodus → Arbeitsmodus (Hot-Tier-Switching) → Hybrid-Modus (Ziel; enthält ERNEUTE Messung) | sequenziell (Lebenszyklus) | super `docs/architektur/19_…:62-73` (bindend): "**Alle 4 Phasen der cache-engine (Mess- → Auswertungs- → Arbeits- → Hybrid-Modus) müssen erzeugt und in E4 … AUTOMATISCH dokumentiert werden**"; Memory `feedback_ceb_drei_modi_arbeitsmodus_hot_tier_switching.md` |
| 9 | **3 XML-Experiment-Phasen** (`<phases>`) | phase1_prt_art / phase2_cache_engine / phase3_kombiniert, je an merge-Stufe gebunden | = Dimension #3 in XML-Form | Ledger:1176 (§15.1); `Code/test_data_xml/experiment_golden.xml:47-52` |
| 10 | **5 Treiber-Ausführungsphasen (Code-Ist)** | `phase1_enumerate` … `phase5_run_workload` (+`phase3_hot_compile_missing`, `phase4b_functional_tests`) | sequenziell, CEB-intern | ce `libs/cache_engine/builder/experiment_driver/experiment_driver.cpp:93,142,266,339,357,302,386` |
| 11 | **Auswertungs-Werkzeugkette Stufen 01–09** | sample → messung_driver → binary→csv → csv→latex → diagram → latex→pdf (+07 tier_binary_report, 08 appendix, 09 tex_formatter) | sequenziell, nachgelagert | Thesis `04_implementierung.tex:114-118` (6 Stufen); ce `docs/architecture/34_…:79-80`; super `docs/architektur/22_…:168` |

**Neben-Vokabulare (nicht verwechseln, gehören NICHT in die `<phases>`):**
- **Zwei-Phasen-Operationsschleife** (Warmup verworfen → Messung; `two_phase_valid`): Thesis `02_suchbaeume_grundlagen.tex:585-586`, `anhang/de/A_measurements.tex:47`; ce doc 34:104 (PFLICHT-Mechanik `tier_save_all → op → rollback → op`).
- **Makro-Phasen Pfad B**: BUILD → MEASURE out-of-process (empfohlener Weg), Thesis `03:427-431`, `04_impl:155-158`.
- **Betriebs-Modi der Binary**: Produktiv- vs. Experiment-Modus (`COMDARE_MEASUREMENT_ON`, `06_fazit.tex:30-33`), Debug-/Mess-/Release-Variante (`aufgabenstellung/de.tex:128-129`), Common-Denominator vs. PRT-ART-Native (`05_evaluation.tex:76-78`).
- **Umgebungs-Dimensionen**: 2 OS-Regimes (Talos vs. root-Linux, `05_evaluation.tex:67-71`), N Wiederholungsläufe mit HDR-Perzentilen (`05:82-83`), Sequenz Single-Thread → lesend-parallel (`aufgabenstellung/de.tex:110-111`), Workload-Routing/Datensätze (`05:30-59`).
- **Begriffskollisionen**: "N-Phasen-Erweiterung" (`04_impl:103`) = Entwicklungs-Iterationen der Achsen-Matrix (11→19 Achsen), KEINE Experiment-Phasen; SOTA-Cluster A–F = Korpus-Gliederung; Dossier-17-"Phasen 1-8" = historische Roadmap; E4→E1 = Fertigstellungs-Reihenfolge der Ebenen.

**Benannte Lücken (nicht geraten):**
- **L1**: Thesis nennt 7 Pipeline-Phasen, der Code hat nur 5 benannte `phaseN_`-Funktionen (Measure/Persist ohne eigene Funktion; Thesis `06_fazit.tex:32-33` verortet den ResultAggregator in "Phasen 5–7"). Ein autoritatives 7↔5-Mapping existiert in keiner der drei Quellen.
- **L2**: Die Dossier-19-Begriffe "Messmodus/Auswertungsmodus/Arbeitsmodus" kommen in der Thesis WÖRTLICH NICHT vor (grep leer); Thesis-Entsprechung ist Produktiv-/Experiment-Modus + Defined/Full/Full-Sampled. Ob die Thesis die 4 Betriebsmodi künftig explizit benennen soll, ist unentschieden.
- **L3**: Doku-Defekt — super `docs/architektur/16_…:264` mappt Stufe↔Phase naiv 1:1; die golden-XML permutiert aber (`:49` phase2_cache_engine=Stufe1, `:50` phase1_prt_art=Stufe2). Korrekturbedarf im Dossier 16.
- **L4**: "Phase" ist mindestens 5-fach überladen (XML-Prüf-Phase, CEB-Betriebs-"Phase", Treiber-phase1-5, Roadmap-Phase, Zwei-Phasen-Op-Schleife) — eine Disambiguierungs-Tabelle nach Muster Ledger §10.1(2) (:266-273) fehlt.

### E11.2 Verhältnis der Dimensionen (Nesting-Modell)

```
CEB-Betriebsmodus (Mess → Auswertung → Arbeit → Hybrid)          [sequenziell, Dossier 19:62-73]
 └─ Experiment-Lauf (Smoke | Voll; Defined/Full/Full-Sampled)     [Lauf-Skala, Ledger:96]
     └─ Prüf-Phasen der XML (merge = Stufe 1/2/3)                 [Kompositions-Raum]
         └─ Treiberphasen 1–5 / 7-Phasen-Pipeline je Binary-Menge [sequenziell je Lauf]
             └─ Zwei-Phasen-Op-Schleife je Operation              [Mess-Gültigkeit]
 nachgelagert: Auswertungs-Stufen 01–09 → Thesis-PDF (honest-empty)
 ORTHOGONAL in jeder Prüf-Phase: 3 Mess-Modi M1–M3 × Reihen A/B/C × 3 Granularitäten
   × Workloads × Datasets × op_types × 2 OS-Regimes × N Wiederholungen
```

Kernaussagen: Die **3 Mess-Modi sind KEINE Phasen** (sie laufen IN jeder Prüf-Phase; jede XML-`<phase>` trägt nur merge+engine, Mess-Settings gelten quer — `experiment_golden.xml:11,47-52`; Memory `feedback_unified_experiment_xml…`). Die **4 CEB-Betriebsmodi sind eine EIGENE, zu den merge-Phasen orthogonale Lebenszyklus-Dimension** — sie als weitere `<phase merge=…>`-Einträge zu modellieren, würde Prüf- und Lebenszyklus-Dimension vermischen (Verbot analog Organ-vs-System-Achsen, doc 18 / Memory `feedback_system_axes_measurement_own_abstract_root_blood`). **R-C(i)** (`experiment_golden.xml:18-19`, Stufe1+Stufe3 build-übergreifend) ist semantisch bereits eine 4. Prüf-Kombination — heute nur Kommentar, keine `<phase>`.

### E11.3 Konkreter Schema-/Validator-Vorschlag (additive Evolution, Golden bleibt gültig)

**IST-Kern (Quelle 3):** Das Einzige, das "genau 3 Phasen" erzwingt, ist die **inerte XSD** (`Code/test_data_xml/experiment_schema.xsd:84`, kein xmllint/CI-Konsument) plus Golden-Pins der Tests (`test_experiment_parser.cpp:99` ASSERT `phases.size()==3`). Code-seitig gilt bereits N>=1: Parser loopt phases 0..N (`xml_config_parser.cpp:391-401`) und ignoriert unbekannte Elemente; Validator prüft nur `phases >= 1` (`validate_profile.hpp:457-460`). Hart sind dagegen "GENAU 2 engines" (`validate_profile.hpp:450-454`) und "1 Experiment pro XML" (Root-Tag-Check `xml_config_parser.cpp:374`).

**(a) N Phasen — Empfehlung: sofort umsetzen, trivial additiv.**
XSD Z.84: `minOccurs="3" maxOccurs="3"` → `minOccurs="1" maxOccurs="unbounded"` (+ Doku-Kommentar Z.81). **Null Code-Änderung** (Parser/Validator/Antrieb N-fähig; `run_experiment_profile` loopt `for (auto const& phase : profile.phases)`), Golden und beide Test-Suiten unberührt. Wiederholte merge-Werte über N Phasen sind unproblematisch (dispatch = Enum-Switch). Abzugrenzen: ein **4. merge-Wert** (build-übergreifend, R-C(i)) wäre NICHT trivial — Enum in `pruefling_merge.hpp` + XSD + `PhaseStrategyFor`-Spezialisierung (`experiment_phase_strategy.hpp:147-169`) müssten nachziehen; das ist eine separate Design-Entscheidung, hier nur geflaggt.

**(b) Experiment-SERIE in EINER XML (E9) — zwei Varianten:**

**Variante 1 — Envelope-Root `<comdare_experiment_series>`** (zweites globales Element derselben XSD; Kinder = `<comdare_experiment>` 1..unbounded, eigenes series-id/version). Parser additiv: `parse_experiment_series(path) -> vector<ExperimentProfile>` (Körper von `parse_experiment_profile` in Node-Helper refaktoriert; bei Root==`comdare_experiment` liefert die Serien-API {1 Element} als Upgrade-Pfad). Validator: Schleife über `validate_experiment_profile` + Serien-Check (eindeutige ids).
- Pro: strikt additiv (Golden + Tests byte-identisch; `parse_experiment_profile` verhaltensgleich); keine neue Vererbungs-Semantik; jedes Experiment self-contained = exakt die heute geprüfte Einheit; Validator 1:1 wiederverwendbar; XSD sauber (geteilter ExperimentType).
- Contra: neue Parse-API für Serien-Konsumenten; Redundanz (engines/datasets/lebewesen je Sub-Experiment wiederholt — verbos, aber explizit).

**Variante 2 — optionales `<experiments>`-Kind im bestehenden Root**, Einträge tragen nur Deltas (eigene phases, optionale Overrides); Root-Ebene = geteilte Defaults; Expander materialisiert je Sub-Experiment ein volles Profil und validiert es mit dem bestehenden Validator.
- Pro: eine Datei-Identität; DRY (Registry-Referenz-Philosophie); Golden sofort unberührt; Alt-Konsumenten sehen das Root-Experiment weiter.
- Contra: Vererbungs-/Override-Semantik muss spezifiziert UND validiert werden (was ist überschreibbar? Root-`<phases>` = Default oder Experiment 0?) = eigene Fehlerklasse; XSD tiefer/teilredundant; Expander-Schritt vor der Prüfung.

**Empfehlung: Variante 1 + (a) kombiniert.** Sauberste UND risikoärmste Lösung (Memory `feedback_infra_cleanest_not_easiest` deckt sich hier ausnahmsweise mit dem geringsten Risiko): kein neues Semantik-Konzept, Wiederverwendung der geprüften Einheit, strikt additiv. Variante 2 lohnt nur bei nachgewiesenem Bedarf an geteilten Deklarationen über viele Serien-Experimente.

**Mitzuschließende IST-Lücken (in beiden Varianten):** (i) `phase.engine/engines` gegen die deklarierten engine-ids validieren (heute freier String, vom Antrieb ignoriert — `PhaseCompositions<S>` hart verdrahtet); (ii) `metadata.mode` gegen das Enum prüfen (heute stiller Defined-Fallback, `v32_messreihe_antrieb.hpp:82-86`); (iii) Doku-Defekt L3 (doc 16:264) korrigieren; (iv) Disambiguierungs-Tabelle "Phase" (L4) anlegen. Hinweis: `v32_messreihe_antrieb.hpp` ist seit Fork A (16.07.) DEPRECATED-BY-DESIGN — Schema-Arbeiten docken an Parser/Validator/Strategy an (INC-A..E bleiben gültig), nicht am Parallel-Antrieb.

**NICHT in die `<phases>` aufnehmen:** Mess-Modi M1–M3 (Mess-Settings), Treiberphasen 1–5 (CEB-Maschinerie), Auswertungs-Stufen 01–09 (output-Kette), Zwei-Phasen-Op-Schleife (Mess-Gültigkeit), Smoke/Voll (über `metadata/mode` abgedeckt).

**Separat vorzulegende Folge-Entscheidungen (geflaggt, NICHT Teil dieser Minimal-Evolution):** (F1) 4. merge-Wert für build-übergreifend/R-C(i) als echte `<phase>`? (F2) Lebenszyklus-Dimension (4 CEB-Betriebsmodi) als eigenes orthogonales XML-Element — doku-gedeckt durch Dossier 19:73 ("Alle 4 Phasen … in E4 AUTOMATISCH dokumentiert", E4-XML = autoritative Bauanleitung), architektur-konform via demselben Strategy-Mechanismus (doc 16:266), aber #156-DATA-gated (Arbeits-/Hybrid-Increments nach E4′).

### E11 — ENTSCHEIDUNGSVORLAGE (User wählt)

- **E11-A (Kardinalität):** `<phases>` auf 1..unbounded öffnen? [Empfehlung: JA — null Code-Änderung, Golden bleibt gültig]
- **E11-B (Serie, E9):** Variante 1 (Envelope-Root, self-contained) ODER Variante 2 (nested Deltas mit Vererbung)? [Empfehlung: Variante 1]
- **E11-C (optional, separat):** F1 (4. merge-Wert) und F2 (Lebenszyklus-Element) jetzt mitentscheiden oder vertagen?

---

## TEIL E13 — "#37-3-ACHSEN": ENTSCHEIDUNGSVORLAGE

### Was der Ledger-Eintrag bezeichnete (Hypothesen nach Evidenz)

**Hypothese 1 (~95%, direkt belegt): "#37-3-Achsen" = die 3 NICHT-Scheduling-Achsen von Task #37 — hardware_strategy (Achse 12), locking_mode (Achse 8.2), numa_affinity (Achse 6.3) — deren vtable-Header Duplikate der bereits live existierenden CRTP-Substanz sind; offene Aktion = honest-Deprecation + Provenienz-Strings umbiegen, erst nach User-Vorlage.**

Wörtliche Fundstellen (Transkript `/home/comdare/.claude/projects/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489.jsonl`):
- **:38678** (Soll-Recherche-Tabelle): "| **#37** | 3 der 4 Achsen (hardware/locking/numa) | Substanz **existiert LIVE** als CRTP+Concept, echt gemessen über T19/T08/T06. Die vtable-Header sind **Duplikate**. | Duplikat-Header deprecaten + Provenienz-Strings umbiegen |" und "Die 'konsolidieren/deprecaten'-Punkte (#35/#37-3Achsen/#38) lege ich dir **erst vor** (da genau dort mein Fehler lag), bevor ich markiere."
- **:39164** (Status): "**Mark-ones** … #37-3-Achsen (vtable-Duplikate → live-CRTP-Nachfolger) … — honest-Markierungen, ich lege sie dir kurz vor".
- **:38727** (Task-#37-Update nach Fork-Entscheid, a/b-Split): "(a) hardware/locking/numa = Substanz LIVE als CRTP (T19/T08/T06), vtable-Header = Duplikate → deprecaten + Provenienz umbiegen (dem User vorlegen bevor markiert). (b) SCHEDULING (Fork #37-S) = OPTION A + B, Priorität A…"
- **:38574-38575**: ursprüngliche Task-#37-Anlage ("KERNFEATURE — 4 Achsen hardware/scheduling/locking/numa: vtable→CRTP-Umbau + verdrahten", 2026-07-13T14:33); **:38316**: grep-Verifikation 0 #include-Konsumenten der vtable-Header.

Konkrete offene Aktion: (1) die 3 Header `ce/libs/cache_engine/include/cache_engine/concepts/{hardware_strategy,locking_mode,numa_affinity}.hpp` (V32.EE.5; IHardwareStrategy/ILockingMode/INumaAffinity, 0 Konsumenten) honest deprecaten; (2) Provenienz-Strings in `ce/libs/cache_engine/builder/commands/axis_library_registry.hpp:122-243` auf die Live-CRTP-Nachfolger umbiegen (z. B. `topics/hardware/axis_12_general_hardware`); heute zeigen sie noch auf die toten Header (code-verifiziert, z. B. "12.1 Scalar → …/hardware_strategy.hpp::SimdFamily::Scalar").

**Hypothese 2 (~4%): "3-Achsen" = drei NEU zu bauende CRTP-Achsen.** Dagegen spricht die Soll-Recherche direkt (:38678): Substanz existiert bereits live als CRTP+Concept, gemessen über T19/T08/T06; Aktion explizit nur "deprecaten + Provenienz umbiegen". Der Neubau-Teil wurde exklusiv auf scheduling verengt (#37-A; `topics/scheduling/axis_13` existiert weiterhin NICHT — #37-A unimplementiert, separates Label "#37-A-Scheduling (großes Design)").

**Hypothese 3 (<1%): Bezug auf Anhang-D-Katalog oder drei andere Achsen.** Der Anhang-D-"Build-SC"-Katalog gehört laut :38727 ausschließlich zu Teil (b) #37-A-Scheduling; die Dreiergruppe hardware/locking/numa ist in allen vier Transkript-Belegen identisch benannt.

### Kritischer Vorbehalt (Grund für "User vorlegen")

Der erste Deprecation-Versuch (ce-Commit `414ed8c2`, Banner auf 5 Header inkl. dieser 3 + scheduling) wurde per `804aa3c2` REVERTIERT — User-Korrektur: "fehlerhaft umgesetzte Pflicht-Features ≠ tot". Aktuell tragen die 3 Header KEINE Banner (grep DEPRECATED = 0). **Lücke (nicht geraten):** Ob sich die Revert-Korrektur nur auf scheduling bezog oder auf alle Header, ist aus den vorliegenden Belegen nicht eindeutig — genau deshalb steht "(User vorlegen)" im Ledger.

### E13 — OPTIONEN (User wählt)

- **Option 1 (deckungsgleich mit Hypothese 1, Evidenzlage stark):** Die 3 vtable-Header als Duplikate honest deprecaten (Banner, keine Löschung — Memory `feedback_never_delete_documentation` analog) UND Provenienz-Strings in `axis_library_registry.hpp:122-243` auf die Live-CRTP-Nachfolger umbiegen.
- **Option 2 (konservativ):** Nur Provenienz-Strings umbiegen (Registry zeigt auf Live-Substanz); Header vorerst unmarkiert lassen, Deprecation vertagen.
- **Option 3 (nur falls der Revert 804aa3c2 auch diese 3 meinte):** Header als fehlerhaft umgesetzte Pflicht-Features einstufen → Reparatur/Verdrahtung statt Deprecation. Evidenz dagegen: Substanz existiert bereits live als CRTP (T19/T08/T06), vtable-Variante hat 0 Konsumenten — Reparatur würde eine Parallelstruktur zur Live-Substanz erzeugen (Verstoß gegen Memory `feedback_vor_aufgaben_erst_projektstruktur_analyse`).

Referenzen: Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:388`; ce-Commits `414ed8c2` (Banner) / `804aa3c2` (Revert); Header-Köpfe "Achse 12/13/8.2/6.3" in `ce/libs/cache_engine/include/cache_engine/concepts/`.