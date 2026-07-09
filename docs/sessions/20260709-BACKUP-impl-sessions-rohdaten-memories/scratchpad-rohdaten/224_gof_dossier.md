# DOSSIER #224 — AUDIT-A4 K10 GoF-Etiketten-Hygiene: RESIDUAL-Annotations-Pass (KOMMENTAR-ONLY, ABI-4, golden-neutral)

> **Für Codex** (`--sandbox workspace-write`, gpt-5.5, xhigh). EIN Agent, KEINE Sub-Agenten. Repo-Wurzel = `--cd` (comdare-cache-engine).
> **NICHT committen, KEINE git-Operationen.** Basis = fresh-context-Kartierung (Explore ac7ddfde), alle Zeilen belegt.
> **HARTE REGEL: KOMMENTAR-ONLY.** KEINE Identifier-Renames, KEINE Code-Zeilen-Änderung, KEIN Verhaltens-/ABI-/golden-Change.
> Jede Änderung ist eine Kommentar-Zeile (`//`) — der Diff darf NUR Kommentarzeilen berühren.

## 0. Kontext (warum klein)
K10 (GoF-Etiketten) wurde in #158 (8 PMAJOR) + G5-Welle (2026-06-20) großteils terminalisiert; 7/8 PMAJOR tragen bereits ehrliche
Annotationen. #224 = der RESIDUAL: **1 substanzieller Fall (Adapter) + kosmetische Kommentar-Spuren**. Direktive
(`docs/architecture/34_KONSOLIDIERTER_MASTER_IST_STAND.md:181-182`): „Name/Pattern nur tragen, wenn die kanonische Semantik erfüllt
ist … sonst ehrlich umbenennen (grep-Beweis)" — hier via **ehrlicher Kommentar-Annotation** (Rename TABU, s. §5), was die Direktive
(„kanonisch ODER ehrlich") erfüllt.

## 1. R1 — Adapter (der einzige substanzielle Fall): `abi_adapter.hpp`
**Stelle:** `libs/cache_engine/anatomy/abi_adapter.hpp`, Klassen-Doku bei `:109-114` (Deklaration `SearchAlgorithmAbiAdapter`).
**Ist:** trägt „generischer Runtime-ABI-Adapter"; hält **kein** `A anatomy_{}`-Adaptee-Member (Organe = eigene Member
`container_algorithm_` `:1885` etc.); die GoF-Adaptee-Frage ist bisher NICHT ehrlich adressiert (einziges der 8 PMAJOR ohne Annotation).
**Fix (NEUE Kommentarzeilen direkt über/bei `:109-114`, KEIN Rename):** ehrliche GoF-Klarstellung, sinngemäß EXAKT:
```
// GoF-Ehrlichkeit (K10/#224): "ABI-Adapter" = Adaption der Composition-Anatomie (A::composition_t-Organtypen) an die
// extern-C-IAnatomyBase-vtable — KEIN klassischer GoF-Object-Adapter. Die Organe werden INTERN konstruiert (eigene
// Member container_algorithm_/telemetry_organ_/...), es gibt KEINEN injizierten Adaptee-Instanz-Member (anders als
// SetAbiAdapter mit `A anatomy_{}`, das an eine Adaptee-Instanz delegiert). "Adapter" ist hier als vtable-/ABI-Adapter
// ehrlich, nicht als Adaptee-delegierender Object-Adapter. Die volle Delegations-Vereinheitlichung (echte
// Adaptee-Delegation) ist bewusst an Befund-2/#188 gekoppelt.
```
Wortlaut anpassbar, aber die 3 Fakten MÜSSEN stehen: (a) adaptiert Composition→vtable, (b) kein Adaptee-Instanz-Member (Organe intern),
(c) volle Vereinheitlichung = #188-gekoppelt. KEINE erfundenen Fakten.

## 2. R2 — Observer-/Template-Header-Spuren: `measurable_concept.hpp`
**Stelle:** `libs/cache_engine/src/measurement/measurable_concept.hpp:2` (Header „Observer-Pattern") + `:36` („Template Pattern").
Direkt darunter (`:40-50`) ist bereits ehrlich korrigiert — nur die zwei Alt-Label-Zeilen qualifizieren:
- `:2` → ergänze/ändere den Kommentar zu: „Mess-Concept — Single-Slot-Notify-Hook (KEIN GoF-Observer-one-to-many; s. Klassen-Doku :40)".
- `:36` → „Template-parametrisiertes Klassen-Template (KEIN GoF-Template-Method-Pattern)".
Nur die Kommentar-Texte; keine `concept`/Typ-Zeile anfassen.

## 3. R3 — „Transparenter Decorator" (systematisch, ~13 Observable-Hüllen)
**grep** im Repo nach exakt `Transparenter Decorator` (Startpunkt `axis_07_prefetch_observable.hpp:97`; Schwestern u.a.
`axis_08_concurrency_observable.hpp`, `axis_11_telemetry_observable.hpp`, weitere `*_observable.hpp`).
**Fix je Treffer (Kommentar-Ersatz):** „Transparenter Decorator" → „statische Forwarding-/Instrumentierungs-Hülle (KEIN GoF-Decorator:
hält keine Komponenten-Instanz, kein Voll-Interface)". Nur die Kommentarzeile, systematisch über ALLE Treffer.

## 4. R4 — kosmetisch (Interpreter + B+-Baum-Satelliten), Kommentar-only
- `builder/experiment_tree/perm_runner.hpp:25` (+ `:199-200`) „Interpreter" → „Op-Skript-Runner (generischer CS-Interpreter über
  den flachen Op-Vektor — KEIN GoF-Interpreter mit Grammatik/AST)".
- B+-Baum-Satelliten-Kommentare (`builder/experiment_tree/ceb_generator.hpp:2,72`, `workload_driver/load_profile_parser.hpp:8`,
  `workload_driver/workload_profiles.hpp:5,10,20`, `experiment_tree/profile_to_tree.hpp:2`, `cache_engine_builder_iterator.hpp:3`):
  je einmal „(Permutations-/Präfixbaum, kein textbook-B+-Baum — s. experiment_tree.hpp:2-10)" ergänzen, wo noch nicht vorhanden.
  Den `[[project_workload_achse2_dynamic_bplus]]`-Doku-Anker in `workload_profiles.hpp:10` NICHT verändern (reiner Memory-Link).
- **RuntimeMeasureVisitor:** NAME NICHT ändern (Datei-lokal, Doku bereits ehrlich); optional 1 Kommentarzeile am Klassennamen
  `runtime_measure_visitor.hpp:29`: „(kein GoF-Visitor — kein accept/visit-Double-Dispatch; host-seitige Mess-Schleife)".

## 5. HARTE Auflagen / TABU (Verstoß = Abbruch)
1. **KOMMENTAR-ONLY:** Jede geänderte Zeile ist ein `//`-Kommentar. KEINE Code-/Signatur-/Typ-Zeile. Der `git diff` darf NUR
   Kommentarzeilen zeigen.
2. **KEINE Identifier-Renames — TABU:** `SearchAlgorithmAbiAdapter` (extern-C-Factory-Body `abi_adapter.hpp:132-136` + generierte
   perm.cpp); die Container-Gattung-Unterklasse „Adapter" (`abi_adapter.hpp:1881` „historische #224-Falle" — speist
   axis_path_serialization/binary_id); `kCompositionAxisNames`, `permutation_axes(.xml)`, `binary_id`-tragende Strings (32 Dateien,
   golden/ingest). NICHTS davon umbenennen.
3. **ABI-4 / golden-neutral:** `COMDARE_ANATOMY_ABI_MAJOR` unberührt; kein POD/vtable/extern-C; keine golden-/permutation_axes-Datei.
   (Kommentar-only garantiert das ohnehin — trotzdem verifizieren.)
4. **KEINE Fabrikation:** nur ehrliche, am Code belegbare Aussagen. Wo ein Etikett teilweise verteidigbar ist (ABI-Adapter), das
   ehrlich so sagen — nicht überkorrigieren.
5. Kein `git`.

## 6. Verifikation (PFLICHT — Codex, literal)
- `git diff --no-color` je berührte Datei — bestätige: NUR Kommentarzeilen (`//` / Block-Kommentar) geändert, KEINE Code-Zeile.
- `grep -rn "Transparenter Decorator"` = 0 verbleibende Treffer (alle R3 ersetzt).
- Bestätige: kein Identifier umbenannt (grep `SearchAlgorithmAbiAdapter` Count unverändert; kein `kCompositionAxisNames`/
  `permutation_axes`/`binary_id`-Diff). `COMDARE_ANATOMY_ABI_MAJOR` unverändert (4).
- Optional-Smoke (Kommentar-only bricht nichts): ein berührter Header (`measurable_concept.hpp`) muss weiter syntaktisch valide sein.

## 7. Ausgabe an Claude
(a) `git status --short` (nur die #224-Dateien); (b) je Datei kurz die Kommentar-Diffs; (c) Bestätigung: KOMMENTAR-ONLY, kein
Rename, ABI-4, golden-neutral, `Transparenter Decorator`-grep=0; (d) Liste der R3-Hüllen-Dateien; (e) ehrliche Notiz falls eine
Stelle bereits annotiert war (dann übersprungen).
