I have the complete evidence chain. All findings below are read-only; no files were created or modified.

Path shorthands (absolute): **super** = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine` · **ce** = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine` · **LEDGER** = `super/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`.

---

## Anker — der ursprüngliche E1–E4-Plan (28.06., autoritativ)

- **ce** `docs/sessions/20260628-KONTEXT-DOSSIER-...-A2welle.md:32-33` (Ebenen-Def), `:364` (§12 B+-Baum/2 Knotenarten), `:381` (§13 4 Ebenen), `:397+` (§14 Audit E4→E1)
- **super** `docs/sessions/20260628-SESSION-ENDE-9-TOPDOWN-AUDIT-E4-E1-...:28-40` (§3 A/C/D), `:42-53` (§4 Audit), `:445-465` (§15 Ebenen-Einteilung), `:517+` (§17 #188-Plan)

Modell (oben→unten): **E4** XML-Def + Auswertung (Superprojekt) → **E3** Permutations-B+-Baum *pro Gattung* (`GenusBindingTraits<G>`) → **E2** Tier-Binaries (`StaticAxisNode`, compile-time) → **E1** RC-Laufzeit (`DynamicVariableNode`). **E0** = Querschnitt (Infra/CI, nicht Pipeline). Fix-Reihenfolge E4→E3→E2→E1→E0; alle ~47 TODOs waren `[E1]`–`[E4]/[E0]`-getaggt.

**Bruch belegt:** Von den 30+ Sessions 02.–09.07. nutzt **keine** das E-Experiment-Modell inhaltlich (Grep: 0 echte Treffer; die wenigen `E2/E4`-Token sind Zufalls-Matches). Der 03.07. neu erstellte Ledger (`LEDGER:145` „2026-07-03: Ledger erstellt") ist E-frei; `SYNTHESE-13.10.md:24` sagt sogar wörtlich *„Ein wörtlicher Begriff '4 Schichten der Diplomarbeit' existiert nirgends"* — die W-Auditoren kannten das E-Modell nicht.

---

## 1. Widerspruchs-Liste (Doc ab 02.07. → Widerspruch, datei:zeile)

| Doc | datei:zeile | Widerspruch zum E1–E4-Plan |
|---|---|---|
| **MASTER-EXECUTION-PLAN 03.07.** | `super/docs/sessions/20260703-MASTER-EXECUTION-PLAN-goal-gesamtumfang.md:9-27` (Spur S), `:29-50` (Spur P) | Ersetzt das E-Ebenen-Scheduling durch **Spur S (S1–S9 God-Header/ABI-Kette)** + **Spur P (AP-Wellen)**. E1–E4 kommen nicht vor; nur `S4=#221` trägt E1-Rest-Inhalt („RC→DynamicVariableNode"), umbenannt zu „S4". Genesis der E-Verdrängung. |
| **Ledger §10** | `LEDGER:132-134` | Degradiert „E0-E4" zu **„Architektur-Audit-Dimension (NICHT Termin)"** — verliert die Experiment-Pipeline-Semantik (XML→B+→Binary→RC). Das ist die §10-„E-Degradierung". |
| **Ledger §13.4-V2 / §13.12-V3** | `LEDGER:407-413` (Katalog-Tags), `:423` (V2), `:538` (V3) | Führt **„E-A..E-E" als Entscheidungs-Defaults** ein → „E-"-Namespace doppelt belegt (Kollision, s. Q2). |
| **SYNTHESE-13.10 W5** | `super/docs/sessions/20260705-arch-verify-w1-w5-rohdaten/SYNTHESE-13.10.md:22-24` | Rekonstruiert ein konkurrierendes **„4 Schichten = Schichten-Modell M / S1–S4"** aus `10_schichten_modell_M.md`, statt E1–E4 zu verwenden. |
| **SYNTHESE-13.10 W1** | `.../SYNTHESE-13.10.md:6-8` | Beschreibt `StaticAxisNode`/`DynamicVariableNode`/B+-Baum (= E2/E1/E3) unter Label **„W1"** mit Doc-26-Bezug — nicht als E-Ebenen. |
| **Ledger §13.10-W5 (AP-10/#269)** | `LEDGER:510` | Verankert Datensätze über **„Schicht 1..4"** (Schicht-1=XML-Akte, Schicht-2=CEB-Permutation, Schicht-3=Loader, Schicht-4=Prüfling misst) = S1–S4-Nummerierung, invers zu E4→E1. |
| **15_F7 (08.07.)** | `super/docs/architektur/15_F7_mess_frameworks_workloads_2d_matrix_plan.md:20-48` | Neues **M×W-2D-Matrix + A/B/C×Micro/Makro/Gesamt**-Modell auf `measurement-all`-Baselines (`baseline_0-core/1-instrumentation/2-workloads`); kein E1–E4-Bezug; Option A legt Workload **compile-time** (E2) statt E4/E1 (s. Q4). |
| **Ledger §12 08.07. (#31-Hybrid)** | `LEDGER:371` | Bestätigt: Workload = **„DynamicVariableNode-Seite des experiment_tree"** (E1-Laufzeit, Mess-INPUT), orthogonal zu golden_320 — **widerspricht F7-Option-A (compile-time)**; zudem **3 konkurrierende Workload-Enums** entdeckt (`WorkloadProfile` vs. `WorkloadKind` vs. `profile_by_name`). |
| **STANDARDPROZESS + MATRIX-GRUNDLAGEN** | `super/docs/STANDARDPROZESS-RESEARCH-ZU-PRODUCT.md:6-9`; `super/docs/sessions/20260705-matrix-grundlagen-goalv2/MATRIX-GRUNDLAGEN-GOALV2.md:5-16` | 3D-Matrix **Familien × Baseline-Stufen (0-6) × Module** — orthogonales Ebenen-Vokabular, nirgends auf E1–E4 abgebildet. (Kein direkter Widerspruch, aber unversöhnt.) |
| **20260709 WORKFLOW-4layer** | `super/docs/sessions/20260709-WORKFLOW-4layer-experiment-tree-DOSSIER.md:1` | Erneute **„4-Layer-Architektur (Experiment-Baum)"** für #31/#29 — Stub („kein synth"), nicht an E1–E4 gekoppelt → droht dritte 4-Ebenen-Herleitung. |

Nachrichtlich (Quelle des S1–S4-Vokabulars, NICHT post-02.07.-Drift, bereits Banner-superseded): `super/docs/architektur/10_schichten_modell_M.md:26,62-110` und `super/docs/uml_planning/Y3_...:186` / `Z3_...:1` (Stand 05.31, „Subsystem 1 Outer-Loop laut M-Modell").

---

## 2. Namenskollision — E1–E4 vs. E-A..E-E vs. S1–S4

**Drei „E/S"-Achsen konkurrieren:**

1. **E1–E4** (28.06.) = Experiment-Maschinerie. Code-verankert (`experiment_tree.hpp` StaticAxisNode/DynamicVariableNode, `GenusBindingTraits`, XML). Älteste + tragendste Bedeutung.
2. **E-A..E-E** (05.07. §13.4-V2 `LEDGER:423`, zementiert 06.07. §13.12-V3 `LEDGER:538`) = Goal-Entscheidungs-Defaults (E-A Reuse-Vendoring · E-B CMD-1-neutral · E-C RC-Rest · E-D Datensätze · E-E perm_runner). Das „E" steht hier **für nichts** — reiner Aufzähl-Buchstabe. Kollidiert im „E-"-Namespace mit E1–E4.
3. **S1–S4** = „Schichten-Modell M / 4-Subsystem-Modell" (`10_schichten_modell_M.md:62-110`): **S1** messung_driver/Auswertung · **S2** CacheEngineBuilder · **S3** CacheEngine · **S4** Prüfling PRT-ART. Vom W5-Audit als „die 4 Schichten" wiederbelebt (`SYNTHESE-13.10.md:22-24`, `LEDGER:510`).

**Exakte Kollisionsstelle S↔E** — dieselbe Pipeline, **invers nummeriert** + andere Schnittkanten:

| E (oben→unten, 28.06.) | S (unten→oben, Modell M) | Diskrepanz |
|---|---|---|
| E4 XML-Def **+ Auswertung** | S1 messung_driver/**Auswertung** | Auswertung beidseitig, aber E=„4"/S=„1"; E4 enthält zusätzlich den XML-**Eingang** |
| E3 B+-Baum/Gattung (Permutation) | S2 CacheEngineBuilder (enumeriert Permutationen) | deckungsgleich, Nummer invers |
| E2 Tier-Binaries (StaticAxisNode) | S3 CacheEngine (Werkzeug-Bibliothek) | E2 = die gebaute DLL; S3 = die Library — andere Schnittkante |
| E1 RC-Laufzeit (DynamicVariableNode) | S4 Prüfling (PRT-ART) | E1 = Laufzeit-Mechanismus; S4 = das Messobjekt — andere Schnittkante |

Zusätzlich: `LEDGER:84,92,93` und `super/docs/sessions/20260703-MASTER-EXECUTION-PLAN-...:14-27` belegen ein **viertes** „S": Spur-S = God-Header-Kette S1–S9 (ABI) — ebenfalls „S1..".

**Auflösungs-Vorschlag (additiv, welche Seite umbenennen):**
- **E1–E4 BEHALTEN** als kanonisch (älteste, code-verankerte Experiment-Pipeline). `LEDGER:132-134` §10 additiv **rehabilitieren**: E4=XML-Def+Auswertung … E1=RC-Laufzeit ausschreiben, „nur Audit-Dimension" streichen.
- **E-A..E-E umbenennen** (die semantisch schwächste Seite, „E" bedeutungslos) → z.B. **„DD-A..DD-E" (Decision-Defaults)** oder „GV-A..GV-E (Goal-V-Defaults)". Additiv an `LEDGER:407-413,423,538` (Original-Wortlaut stehen lassen, Rename-Vermerk davor). Beseitigt die „E-"-Doppelbelegung sofort.
- **S1–S4 NICHT umbenennen** (eigenständiges Subsystem-Ownership-Modell, historisch legitim), aber **einmalig explizit gegen E1–E4 kreuz-mappen** (Tabelle oben) an einer Stelle — Vorschlag: additiver Block in `10_schichten_modell_M.md` + Korrektur-Fußnote an `SYNTHESE-13.10.md:22-24` / `LEDGER:510`. Klarstellen: E-Sicht = Experiment-Pipeline (top-down 4→1), S-Sicht = Subsystem-Zerlegung (bottom-up 1→4); „Spur-S (S1–S9)" ist ein dritter, ABI-Kettenscope — im Ledger-Glossar disambiguieren.

---

## 3. Nachzieh-Liste (neuere Docs → an E1–E4 angleichen; additiv, nie löschen)

| Doc / Stelle | Nachzuziehen (additiv) |
|---|---|
| `LEDGER:132-134` (§10) | E0-E4 als **Experiment-Maschinerie ausschreiben** (E4 XML+Auswertung / E3 B+-Baum/Gattung / E2 Tier-Binaries / E1 RC / E0 Querschnitt); „nur Architektur-Audit-Dimension" als verengte Lesart markieren; Verweis auf ce-Dossier §12-15 + SESSION-ENDE-9. |
| `LEDGER:407-413,423,538` (§13.4/§13.12 Defaults) | Entscheidungs-Defaults von **„E-A..E-E" → „DD-A..DD-E"** umbenennen (Rename-Vermerk, Original bleibt); Kollisions-Hinweis auf E1–E4. |
| `SYNTHESE-13.10.md:22-24` (W5) + `LEDGER:510` | Korrektur-Marker: „4 Schichten" **= E1–E4-Experiment-Pipeline** (nicht neu erfunden); Schicht-1..4 ↔ E4/E3/E2/E1 explizit; S1–S4-Nummerierungs-Inversion notieren. |
| `SYNTHESE-13.10.md:6-8` (W1) | Annotation: das dort beschriebene StaticAxisNode/DynamicVariableNode/B+-Baum-Konstrukt **IST E2/E1/E3**; Bezug auf ce-Dossier §12/§13 ergänzen. |
| `super/docs/architektur/15_F7_...md` (ganz) | E-Rahmen ergänzen: M-Achse = E0/Tooling-Modul-Concern (compile-time OK); **W-Achse (Workload/Dataset) = E4-XML-definiert + E1-Laufzeit gespeist, NICHT E2-compile-time**; A/B/C×Micro/Makro als E4-Auswertungs-Dimension einordnen (s. Q4). |
| `super/docs/sessions/20260703-MASTER-EXECUTION-PLAN-...md:14-27` | Querverweis: „S4/#221" = E1-Rest; „Spur-S (S1–S9)" ≠ Schichten-Modell-M-S1–S4 (Glossar-Disambiguierung). |
| `super/docs/sessions/20260709-WORKFLOW-4layer-...DOSSIER.md` | Vor Weiterverarbeitung für #31/#29 an E1–E4 andocken (Stub explizit als „= Experiment-Maschinerie E4→E1" rahmen), sonst dritte 4-Layer-Parallelherleitung. |
| `STANDARDPROZESS-...md:6-9` + `MATRIX-GRUNDLAGEN-GOALV2.md:5-16` | Klarstellen: die 3D-Matrix (Familien×Baseline×Module) ist die **E0/Product-Struktur-Achse**, orthogonal zur E1–E4-Experiment-Achse — beide Achsen einmal gegeneinander abgrenzen. |
| `LEDGER:371` (#31-Revert) | Als **verbindlichen Ebenen-Beleg** hochziehen: Workload = DynamicVariableNode (E1) / golden_320-orthogonal → in F7-Korrektur zitieren. |
| `10_schichten_modell_M.md` | E↔S-Kreuz-Map-Block (Q2-Tabelle) additiv; als Ursprung des S1–S4-Vokabulars kennzeichnen. |

---

## 4. F7-Doc-15 — wie es den #31-Ebenen-Fehler propagiert, und Neufassung

**Wo (datei:zeile):** `super/docs/architektur/15_F7_...md:3` deklariert sich „Grundlage für die #31-Folgearbeit"; `:4` ankert an `LEDGER:298` (F7). §1 `:9-18` (measurement-all 1D-Baselines), §2 `:20-28` (Achse M × Achse W + „orthogonale 3. Dim A/B/C×Micro/Makro/Gesamt"), §3 `:30-38` (Struktur-Fork, **Option A** = 2. Dimension als **compile-time-Parametrisierung IN den Zellen**), §4 `:44-48`, §6 `:59`.

**Der Fehler (dreifach):**
1. **Workload/Dataset auf compile-time (E2) verortet.** `:34` „workloads parametrisiert compile-time über {YCSB-A,C,E} × {6 Datasets}", `:48` „analog zur ce-Anatomie-Matrix (Permutation compile-time)". Im E-Modell ist der Workload aber die **E1-Laufzeit-Dimension** (DynamicVariableNode, „for-Schleife auf EINER geladenen Binary") bzw. **E4-XML-definiert** — nicht E2-statisch. Der Ledger widerlegt F7 selbst: `LEDGER:371` „Workload = DynamicVariableNode-Seite des experiment_tree … orthogonal zu golden_320/permutation_axes"; Datensätze sind laut W5 die „**4. CEB-Permutations-Dimension**" auf Builder-/Baum-Ebene (E3), `LEDGER:510` / `SYNTHESE-13.10.md:34`.
2. **Fehl-Lesart der Thesis-Formel.** `:26` + `:38` nutzen „Workload als **dynamische Achse**" als Begründung für *compile-time*-Parametrisierung — „dynamisch" heißt im E-Modell aber gerade **E1-Laufzeit** (DynamicVariableNode), also das Gegenteil von compile-time.
3. **Drittes Ebenen-Vokabular statt Versöhnung.** F7 rahmt alles in die `measurement-all`-Baselines (`baseline_0-core/1-instrumentation/2-workloads`, `:9-18`) + M/W/A-B-C — und mappt **nie** auf E4→E1. Es multipliziert die Ebenen-Sprachen (Baseline-Stufen + M/W + A/B/C), statt sie an E1–E4 zu binden = Propagierung des E-Modell-Verlusts.

**Neu fassen (additiv, ohne golden/ABI-Berührung):**
- **Achse M (Mess-Kategorien)** bleibt Option-A-tauglich, aber korrekt als **E0/Tooling-Concern** deklarieren: die *interne* Code-Organisation des `measurement-all`-Moduls (F6-compile-time-Metaprogrammierung) — das ist zulässig und golden-orthogonal.
- **Achse W (Workload × Dataset)** aus der compile-time-Zelle herausnehmen und explizit verorten: **E4** (die XML-Experiment-Definition wählt Profil×Dataset je Messreihe) → gespeist an **E1** (DynamicVariableNode-Laufzeit); die Dataset-Permutation sitzt auf **E3** (CEB-„4. Permutations-Dimension", `test_data_sets.xml`). Damit entfällt jede Binary-/Zell-Explosion (deckt sich mit F7 `:59` „orthogonal zur Anatomie-Permutation", macht die Aussage aber E-konsistent).
- **A/B/C × Micro/Makro/Gesamt** als **E4-Auswertungs-Dimension** kennzeichnen (die m3v2-/Messreihen-Ebene), nicht als 3. Matrix-Achse der Modul-Struktur.
- **Kopfzeile** von 15_F7 um einen E-Anker ergänzen (Verweis auf ce-Dossier §12-15 + SESSION-ENDE-9), damit „#31-Folgearbeit" nicht erneut die Ebenen verwechselt; `LEDGER:371` als bindenden Beleg zitieren.

**Kernsatz für die Neufassung:** *M = compile-time (E0-Modul-Interna, Option A OK); W/Datasets = E4-XML-definiert + E1-Laufzeit/E3-Permutation (NICHT compile-time-statisch); A/B/C = E4-Auswertung.*

---

Hinweis zur Arbeitsweise: Dies war eine reine Lese-/Kartierungs-Aufgabe; ich habe nichts geschrieben oder verändert. Der obige Bericht ist die Antwort selbst (keine Report-Datei angelegt).