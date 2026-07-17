# ADDENDUM zum INC-1-Bauplan — Q1 (Achsen-Dach), Q2 (H-7 `-march`-Vorlage), Q3 (Compiler = 5. System-Achse)

**Datum:** 2026-07-17 · **Bezug:** `BAUPLAN-INC1-CEB-SYSTEMACHSEN-SCHICHTUNG.md` (dieses Verzeichnis) · **Quellen:** Reports A (Q1-Dach), B (Q2-Ist-Fakten), C (Q3-Verzahnung), D (HW-Dossiers-Deep-Read).
**Status:** Q1 ENTSCHIEDEN, Q3 ENTSCHIEDEN (beides Bauplan-Anpassung), **Q2 OFFEN — Freigabe-Gate** (die Vorlage in §3 ist das Kern-Deliverable, wird dem User 1:1 vorgelegt).

> **Q-Nummern-Warnung (Report D, Widerspruch #2 — Doku-Falle):** Die INC-1-Ruling-Nummerierung (LEDGER:1916) Q1/Q2/Q3 bezeichnet **andere** Fragen als §18.3.5 (dort Q1=4 Gattungen … Q5=H-7-`-march`). In diesem Addendum gilt durchgängig die **INC-1-Ruling-Nummerierung**: **Q1** = gemeinsames Achsen-Dach (ENTSCHIEDEN), **Q2** = H-7-`-march`-Aufhängung (OFFEN), **Q3** = Compiler als volle 5. System-Achse (ENTSCHIEDEN). Die §18.3.5-„Q5" ist dieselbe Sachfrage wie hier „Q2".

> **Beleg-Ehrlichkeit (Report C §0):** Das Prompt-Feld `KONTEXT (autoritativ, User 2026-07-17)` kam als `undefined` an. Die im Auftrag zitierte Präzisierung „**VOLLE 5. System-Achse … Vergleich bis 5 %**" ist **nicht verbatim** aus LEDGER/BACKUPS belegbar (grep nach `5 ?%`/`Performance.*unterschied` = 0 Treffer). Sie wird hier als **Parent-Direktive** geführt und mit den nächstliegenden verbatim-Aussagen (LEDGER:429 S-5/S-6, LEDGER:430 F3i „NEUE SYSTEMACHSE") gestützt; wo „5 %"/„volle 5." steht, ist es die vom Orchestrator gesetzte Richtung, nicht ein belegtes User-Zitat.

---

## (1) Q1-AUFLÖSUNG — das gemeinsame Achsen-Dach + `CebSystemAxis<Derived>` als Geschwister-Wurzel

### 1.1 Die belegte Planung (verbatim, Report A)

**Q1-Direktive (User, 2026-07-17)** — `LEDGER:1916`:
> „**(Q1 ENTSCHIEDEN)** `CebSystemAxis<Derived>` = abgeleitetes Konzept der allgemein geplanten **`Axis<Derived>`-Konzepte**; neue **Geschwister-Wurzel unter einem GEMEINSAMEN DACH** (Dach-Planung aus früheren Sessions per ultracode belegen; fehlt das Dach im Ist = Lücke aus nicht-korrekt-umgesetztem Plan → in INC-1 nachziehen)."

**Befund der Planungs-Archäologie (Report A, KERN-VERDIKT):** Ein **literales, code-fähiges `Axis<Derived>`-Dach über BEIDEN Achsen-Familien (Organ + System)** ist in **keiner** früheren Session belegt (`grep -rhoE '[^a-zA-Z]Axis<Derived>'` über alle Backups = **0 Treffer**; jedes Vorkommen ist `SystemAxis<Derived>`/`CebSystemAxis<Derived>`). Belegt sind drei **getrennte** Dinge:
- **Ein gemeinsames PATTERN** (nicht ein gemeinsamer Typ): CRTP + Concept-Guard für **alle** Achsen — `feedback_crtp_concept_guard_mix_pattern.md`; die belegte generische Form ist **`…StrategyBase<Derived> : public topics::AxisBase`** (`topics/axis_base.hpp:52`), die aber **nur Organ-Achsen** verwurzelt (`backups/20260713-achsen-gattungen-metaprog/wf-RESULT-raw.json` §1.1).
- **Ein Organ-Familien-Dach** `topics::AxisBase` (Organ, plain struct, KEIN Template).
- **Eine bewusst getrennte System-Wurzel** `SystemAxis<Derived>` — Blut-Direktive `LEDGER:94`/`:146` (verbatim): „System-Achsen=„Blut" (**eigene abstrakte Wurzel, Organ vs System NIE mischen**)."

**Name aus der Planung:** Die Planung liefert **keinen literalen Dach-Namen**. Den Namen setzt der **User selbst in Q1**: **`Axis<Derived>`** (Concept: `AxisConcept`). Übernommen wird dieser Wortlaut; der belegte Organ-Roof-Name `AxisBase` wird zur Organ-**Sub**-Wurzel.

### 1.2 Lücken-Befund — welche Wurzeln heute dachlos sind (IST, Report A §2)

Heute existieren **genau ZWEI unabhängige Achsen-Wurzeln — ohne gemeinsamen Elter** (die Aufgaben-Prämisse „3 Wurzeln" trifft nicht zu — `IsaStrategyBase`/`ConcurrencyStrategyBase` sind **keine** eigenständigen Wurzeln, sie erben bereits `: public topics::AxisBase`):

| # | Wurzel (heute dachlos) | datei:zeile | Form |
|---|---|---|---|
| 1 | `topics::AxisBase` + `AxisBaseConcept` | `topics/axis_base.hpp:52` / `:91` | **plain struct** (kein Template!); 22 `…StrategyBase` erben `: public topics::AxisBase` |
| 2 | `measurement::SystemAxis<Derived>` + `SystemAxisConcept` | `measurement/system_axis.hpp:148` / `:183` | **CRTP-Template**, empty base |
| (3) | `CebSystemAxis<Derived>` (INC-1a, NEU) | `measurement/ceb_system_axis.hpp` (geplant) | CRTP-Template, empty base — **existiert im IST nicht** (`grep -rln CebSystemAxis libs/` = NONE) |

**Verifizierte Entkopplung:** `system_axis.hpp` inkludiert `topics/axis_base.hpp` **nicht** → zwei disjunkte Hierarchien. Der INC-1-Bauplan plant `CebSystemAxis` heute als **komplett eigenständige dritte Geschwister-Wurzel „own root per layer"** (BAUPLAN §7-Q1, Zeile 77/212) — **ebenfalls ohne Dach**. **Alle drei sind also heute dachlos.**

**Präzise Lücke (Report A §3):** Die Lücke ist **nicht** „ein Plan, der falsch umgesetzt wurde" — die Trennung war **absichtlich** (Blut-Direktive, mehrfach). Das „gemeinsame Dach" ist eine **neue Vereinigungsabsicht** (Q1). Sie ist mit der Blut-Direktive **nur dann vereinbar, wenn das Dach semantik-frei bleibt** (reiner Marker/Identität) und alle Familien-Semantik in den Unter-Wurzeln bleibt.

### 1.3 Design — semantik-freies Marker-Dach + Familien-Sub-Wurzeln (Report A §4)

```
Axis<Derived>                       // NEU (Dach): empty base, KEINE do_categories/get_compiler;
  │  concept AxisConcept =          //      nur Identität + axis_kind()-Diskriminator
  │    derived_from<D,Axis<D>> && is_empty_v && !is_polymorphic_v
  │    && requires { {D::axis_kind()} -> convertible_to<AxisKind>; }
  ├── OrganAxis<Derived>   : Axis<Derived>   // = heutiges topics::AxisBase (cross-props wandern mit)
  │       └── …StrategyBase<Derived> : OrganAxis<Derived>   // die 22 Organ-Basen umhängen
  ├── SystemAxis<Derived>  : Axis<Derived>   // Mess-„Blut" (do_categories/do_collect bleiben HIER)
  └── CebSystemAxis<Derived> : Axis<Derived> // INC-1-Geschwister (Konfig; do_axis_label bleibt HIER)
```

**Benanntes Muster (verteidigungsfähig, `feedback_lehrbuch_design_patterns_only_zero_cost_metaprog`):** „**Layer Supertype** (Fowler, PoEAA) als **Marker-Concept + CRTP-Tag**, kombiniert mit **Separation of Hierarchies**" (Letzteres zitiert der Bauplan bereits, Zeile 96). Zero-cost bleibt über denselben Concept-Guard (`is_empty_v && !is_polymorphic_v`), jetzt auf `Axis<Derived>` gehoben. **Blut-Direktive gewahrt**, weil das Dach NULL Familien-Semantik trägt.

**Einziger Namens-Freiheitsgrad (1-Zeilen-Bestätigung, optional):** Soll das Dach `Axis<Derived>` (Q1-Wortlaut) heißen und `topics::AxisBase` zu `OrganAxis<Derived>` umgewidmet werden? Die Planung gibt keinen literalen Dach-Namen vor — Q1 setzt ihn.

### 1.4 ANPASSUNG von INC-1a — Dach zuerst, bestehende Wurzeln AUSSCHNEIDEN

Q1 gibt das **Ausschneiden** frei (`LEDGER:1916`: „Ausschneiden der Achsen … freigegeben") — INC-1a ist damit **nicht mehr rein-additiv**. **Pflicht-Gates je Mini-Increment bleiben:** golden==320 **und** ABI-4 (kein Major-Bump). Ausschneide-Scope in zwei Risiko-Stufen:

**Stufe 1 — niedriges Risiko (INC-1a, sofort):** neues Dach-Header `libs/cache_engine/topics/axis.hpp` (`Axis<Derived>` + `AxisConcept`, empty base). `SystemAxis<Derived>` (`system_axis.hpp:148`) und `CebSystemAxis<Derived>` (INC-1a-neu) bekommen die Basis-Zeile `: Axis<Derived>`; ihre Concepts refinen `AxisConcept`. **Kein Organ-Code berührt**, keine Serialisierung berührt → golden==320 byte-identisch, ABI-4 unberührt.

**Stufe 2 — ABI/golden-sensibel → EXPLIZIT markiert:** die Umwidmung `topics::AxisBase` → `OrganAxis<Derived>` und das Umhängen der **22** `…StrategyBase` von `: public topics::AxisBase` auf `: public OrganAxis<Derived>`. Das ist die höchst-berührende Änderung (aus plain-struct wird CRTP-Sub-Wurzel; cross-props `get_compiler()`/`is_original_module()` wandern mit).
- **Golden-Erwartung:** neutral, weil binary_id über `serialize_composition_path(P::variants)` gegen `kCompositionAxisNames` läuft (`axis_path_serialization.hpp:30/48`) — die **Klassen-Hierarchie** speist die binary_id **nicht**. Empty-Base-Optimierung hält `is_empty_v`.
- **ABI-Erwartung:** neutral für die Wire-PODs (`BuildVariantDefinitionV1` ist ein separater flacher POD, **nicht** von `AxisBase` abgeleitet).
- **GATE-REGEL (Task):** Falls die Stufe-2-Umwidmung golden==320 **nicht byte-identisch** hält **oder** ABI-4 berührt → **NICHT in INC-1a erzwingen, sondern nach INC-2 schieben** (dort mit dem 4→5-Bump). Minimal-invasive Zwischenlösung dokumentiert (Report A §4): `AxisBase` bleibt Mixin, `…StrategyBase` erben **zusätzlich** `Axis<Derived>` — trägt das Dach, ohne die 22 Basen umzuwidmen; die saubere Umwidmung folgt dann in INC-2.

---

## (2) Q3-EINARBEITUNG — Compiler = VOLLE 5. System-Achse (neues INC-1h)

**Entscheid (Parent-Direktive 2026-07-17; verbatim-Stütze siehe Beleg-Warnung oben):** Der Compiler wird von „**4+1-Begleiter**" (bisheriger Bauplan-Default §7-Q3) zur **vollwertigen 5. System-Achse** hochgestuft. Der Planer baut **CEB und Tier-Binaries mit BEIDEN** Compilern (`gcc|clang` im ersten Ausbau) und **vergleicht** (Parent: „bis 5 % Performance-Unterschied"). Nächstliegende verbatim-Belege: `LEDGER:430` F3i (User): „**sowohl den CacheEngineBuilder als auch JEDE einzelne Tier-Binary-Permutation entweder mit gcc oder mit clang** … (eigene Achse zur compile time bei runtime der CacheEngineBuilder und **NEUE SYSTEMACHSE**)"; `LEDGER:429` S-5: der Planer baut „**VERSCHIEDENE CacheEngineBuilder auf, die ihrerseits ihre Tier-Binaries bauen**"; S-6: „strikt gcc|clang im ersten Ausbau" + erweiterbar als „**runtime-dynamische UNTER-ACHSE** (Verfügbarkeits-Erkennung zur Laufzeit)".

Diese Hochstufung **löst das offene Bauplan-Q3 auf** (4+1 → vollwertige 5.), ändert am Ordner-/Sidecar-**Mechanismus** nichts, nur den **Rang** (eigene `CompilerSystemAxis`-Wurzel statt Begleit-Label), und reitet bruchfrei auf demselben CompileFn-Andockpunkt.

### 2.1 Ist-Andockpunkte (Report C §1) — der Compiler ist HEUTE bereits injizierbar
- **Compiler-Wahl:** `profile_run_facade.cpp:129-132` `cxx_compiler()` (env `COMDARE_CXX`, Default `"g++-16"`) — einziger dynamischer Umschaltpunkt.
- **Injektion:** `profile_run_facade.cpp:184` **und** `:360` backen den Compiler-String als 3. Arg in `make_gpp_compile_fn`.
- **Fabrik:** `build_orchestrator.hpp:466-492` `make_gpp_compile_fn(..., std::string cxx = "g++-16", ...)` → `posix_spawnp({cxx,"@rsp"})`. **g++↔clang-Swap ist heute schon trivial über den `cxx`-String.**
- **HÄRTESTER Blocker (Q3-eigen, Q2-unabhängig):** `build_orchestrator.hpp:479` bäckt **HART** `-fno-gnu-unique` — **clang kennt das Flag nicht → `error: unknown argument`**; jeder clang-Bau bricht sofort. **MUSS compiler-bedingt gegated werden.** Präzedenz existiert nur im CMake-Weg (`permutation_codegen_tool.cpp:481` `$<CXX_COMPILER_ID:…>`), **nicht** im Subprozess-Weg → Compiler-Dialekt-Selektor in `make_gpp_compile_fn` neu einziehen.
- **H-10-Heimat existiert:** `provenance_manifest.hpp:79-83` schreibt bereits `compiler_id`/`compiler_version` — aber **global**, nicht per-Binary (Delta: per-Binary + in `build_version` `:62` kodieren, sonst falsches DLL-Skip via `dll_is_current` `:170/:282`, wenn nur der Compiler wechselt).
- **Serialisierung** (`feedback_serialization_flat_systemaxis_folders…`): Compiler = **eigener flacher Ordner-Level** in der Reihenfolge **Host→OS→Compiler→ISA**, **nie** Segment in `kCompositionAxisNames`/`serialize_composition_path`.

### 2.2 Neues Mini-Increment **INC-1h — Compiler-System-Achse**
Spaltet den „Compiler +1", der bisher auf INC-1d mitritt, in ein **eigenes** Increment ab:
1. **CRTP-Achse** `template<class D> struct CompilerSystemAxis : CebSystemAxis<D>` (`static_assert(CebSystemAxisConcept<D>)`, Muster `IsaStrategyBase`); Ausprägungen `gcc|clang` als static-constexpr; runtime-dynamische Verfügbarkeits-Unter-Achse (S-6) speist sich aus `.toolchain-probe` (#273-T1, LEDGER:1152).
2. **`cxx_compiler()`-Anbindung:** die Achsen-Belegung treibt den `cxx`-String an `make_gpp_compile_fn` (statt nur env `COMDARE_CXX`).
3. **Compiler-Dialekt-Gate:** `-fno-gnu-unique` (`:479`) compiler-bedingt entfernen/ersetzen; ThinLTO-Randdivergenz (`-flto=thin` nur clang) demselben Gate unterwerfen.
4. **Serialisierungs-Ordner:** Compiler-Level zwischen OS und ISA (flach), golden-neutral.
5. **H-10-Sidecar-Feld:** `compiler_id`/`compiler_version` per-Binary neben der `.so` + in `build_version` kodieren. **KEIN POD-Feld-Anhang** (das wäre ABI-4-Bruch = INC-2).
6. **golden-Neutralität belegen:** `grep -c` Compiler-Token in `golden_fullpilot_320_binary_ids.txt` == 0 nach INC-1h.

### 2.3 Verzahnung Planer (PF2-Matrix) + INC-2-Naht
- **PF2 (Report C §3):** je `(Host, OS, Compiler)`-Ordner **ein CEB**, der darunter alle 09b×Organ-Permutationen baut — deckt S-5 („VERSCHIEDENE CacheEngineBuilder") exakt; der Compiler multipliziert **sauber am System-Level**, orthogonal zur Organ-Permutation.
- **INC-2-Naht:** der „5 %"-Vergleich koppelt an die **neue Metadaten-Version** (dieselbe wie H-7/Q5, LEDGER:1783/1785) — die **Version-Bump-Semantik** ist INC-2; INC-1h liefert nur den **Rahmen** (Achse + Ordner + Sidecar-Text). Die 4+1→5-Hochstufung ändert nur den Rang, nicht die INC-1/INC-2-Grenze.

---

## (3) DIE Q2-VORLAGE — H-7-`-march`-Aufhängung (wird dem User 1:1 vorgelegt) ⟵ KERN-DELIVERABLE

### (a) Kontext

Die **Build-Achse `09b` (`simd_extension`)** ist eine reine Bau-Zeit-Konstante: ein flacher, ABI-stabiler POD (`build_variant_definition.hpp:2-9,22-24`, alle Properties `static constexpr`, KEIN Laufzeit-Observer), der **nicht** in die `binary_id` eingeht — sie steht **nicht** in den 19 Kompositions-Slots (`axis_path_serialization.hpp:27-34`; Golden-Beleg: 320 binary_ids, **0** enthalten `simd_ext`/`avx`/`-march`). Die **isa-Organ-Achse** (Datei-Nr. `09`, Kompositions-Slot **T12** „isa") permutiert dagegen die ISA-Strategien (Amd64/Aarch64/…), **geht in die binary_id ein** und trägt den compile-time-gegateten SIMD-Hot-Path (`axis_09_isa_amd64.hpp:84-131`, `#if __AVX512F__/__AVX2__/__x86_64__`) — dessen **numerischer Wert build-invariant** ist, aber dessen **Code-Pfad** die von einer `-m…`-Flag gesetzte Build-ISA wählt. **Heute fließt `-march`/`-mavx` NICHT** in die Tier-Binaries: `make_gpp_compile_fn` (`build_orchestrator.hpp:466-493`) bäckt nur `-std=c++23 -O2 -fPIC -shared -fno-gnu-unique` → Binary faktisch generisch `-O2` (die 09b→Flag-Kopplung `comdare_apply_simd_extension_flags`, `isa_features.cmake:139-184`, trifft nur Test-/Produkt-Targets, **nicht** den CEB-Subprozess-Compile). H-7 fordert verbatim (`LEDGER:418`): „**H-7 wie empfohlen + eine Tier-Binary wird durch eine CEB-System-Achse STATISCH für system-passende Optimierungen kompiliert** (AVX512 + andere Befehlssatzerweiterungen nicht überall vorhanden → speziell passend für optimale Systemausnutzung einkompiliert **ODER** zum Performance-Vergleich NICHT mit einkompiliert → **volle Kontrolle**)." Die **neue Compiler-System-Achse** (Q3) fügt eine dritte, orthogonale Ebene hinzu — *welcher Treiber+Dialekt* die Flags rendert —, sodass die Aufhängung jetzt sauber dreistufig gedacht werden kann: **09b = welche Instruktionen**, **Hardware-System-Achse = welcher Host führt aus**, **Compiler-System-Achse = welcher Treiber baut**. Die Frage ist: von **welcher** Achse kommt der `-march`-**Wert**, und **wo** wird er angewandt?

### (b) Die Optionen (sauber getrennt)

**Option A — `-march`-Quelle an der Build-ISA-Achse 09b (Organ-/Build-Seite).**
Der `-march`/`-mavx`-Wert wird aus der 09b/`simd_extension`-Belegung abgeleitet (analog `simd_flags()`, `permutation_codegen_tool.cpp:43-48`) und an der `CompileFn`-Naht angewandt; die **Hardware-System-Achse bleibt reiner Host-Deskriptor + Mess-Gate** („Binary-ISA ⊆ Host-Capability"). = e18/Bauplan-Default (`DOSSIER:22`, BAUPLAN §7-Q2, Fork 6 „H-7 AVX/ISA **nur Host-Label** (Empf.)").

**Option B — `-march` vollständig an der Hardware-SYSTEM-Achse.**
Die System-Seite steuert das **statische Compile-Target** der Tier-Binaries: die Hardware-System-Achse setzt `-march` direkt (treibt den Bau); 09b bleibt reine **Codegen-Variante** ohne Flag-Wirkung. = wörtliche Lesart von „Tier-Binary wird durch eine CEB-System-Achse STATISCH kompiliert" + KL:226 „Hardware/ISA/AVX … **treibt den Compiler**".

**Option C — Hybrid: System-Achse liefert den WERT, 09b/`CompileFn` ist der ORT, Versionierung NEBEN der binary_id.** *(aus den Reports abgeleitet — Report C Drei-Ebenen-Zerlegung + Report D Widerspruch #4)*
Die Hardware-System-Achse liefert die **„volle Kontrolle"-Entscheidung** (AVX512 einkompilieren **ODER** bewusst weglassen — genau der H-7-Wortlaut); der Wert wird an der **injizierten `CompileFn`** (`make_gpp_compile_fn`, `build_orchestrator.hpp:466`) angewandt (dem laut allen Dossiers „sauberen, Engine-agnostischen Parametrisierungs-Ort", KL:237/F12III:196-197/LEDGER:1701); 09b bleibt binary_id-bestimmend für die *deklarierte* ISA; die tatsächlich gewählte `-march`-Belegung wird als **Build-Provenienz NEBEN der binary_id** versioniert (H-10-Sidecar, neue Metadaten-Version), **nicht IN** der binary_id. Damit treibt die System-Achse (User-H-7), ohne die e18-⟂-Trennung (binary_id-Neutralität) zu brechen.

### (c) Implikationen je Option

**Option A**
1. *Ordner/Serialisierung:* 09b bleibt im tiefen Tier-Binary-Permutationsbaum; Hardware + Compiler sind zwei flache System-Ordner oben (Host→OS→Compiler→…). Serialisierungs-Doktrin exakt getroffen (System flach, Build/Organ tief).
2. *PF2-Matrix:* je (Host,OS,Compiler)-Ordner ein CEB, der darunter alle 09b×Organ-Permutationen baut — keine CEB-Explosion.
3. *golden/binary_id:* **sauber neutral** (09b unverändert, `kCompositionAxisNames` unberührt; 320-Beleg).
4. *Doktrin Organ-vs-System:* **eingehalten** — 09b Organ, Hardware+Compiler System; Flags treffen sich nur an der `CompileFn`-Naht (dem legitimen Merge-Punkt).
5. *INC-2-Naht:* klarer Split (Rahmen INC-1, Version-Bump/AVX10-POD INC-2).
6. *Spannung:* setzt H-7 als **reinen Deskriptor** um — die User-Erweiterung „System-Achse kompiliert STATISCH … volle Kontrolle" wird nur indirekt bedient (09b IST die „system-passende" Wahl).

**Option B**
1. *Ordner/Serialisierung:* Hardware **und** Compiler als zwei flache System-Ordner nebeneinander → optisch „sauberste" Symmetrie; ABER die ISA-emit-Dimension verschwindet aus dem tiefen Baum, obwohl sie emittierten Code ändert.
2. *PF2-Matrix:* Hardware-ISA-**emit** wandert auf System-Level → CEB-Zahl multipliziert um die `-march`-Werte, obwohl `-march` eine reine **Bau**-Variation ist → CEB-Explosion + **Doppel** zur bestehenden 09b-Achse.
3. *golden/binary_id:* **riskant** — zwei verschieden kompilierte Binaries lägen im selben binary_id-Pfad (ununterscheidbar) → Druck, `-march` in die binary_id aufzunehmen → **golden-Bruch-Gefahr**; e18 warnt explizit vor diesem Doppel.
4. *Doktrin:* **verletzt** — die Hardware-System-Achse würde den Bau **treiben** (emit), obwohl e18 sie strikt als Host-Deskriptor/Mess-Gate definiert („berührt NIE binary_id"); kollabiert die e18-„emit vs. host-can"-Dualität.
5. *INC-2-Naht:* verlagert ISA-emit-Semantik **vor** den 4→5-Bump → vermengt INC-1-Rahmen mit der INC-2-Metadaten-Frage.
6. *Compiler-Kombinatorik:* `-march=native` löst je Compiler leicht andere Feature-/`-mtune`-Defaults auf (Quelle des „5 %"-Unterschieds) — spricht **dagegen**, `-march` und Compiler zu falten; sie müssen orthogonal bleiben.

**Option C**
1. *Ordner/Serialisierung:* 09b bleibt tief (deklarierte ISA); die aktive `-march`-Belegung erscheint als **Sidecar-Provenienz** + optional als flacher System-Ordner-Diskriminator — nicht in der binary_id.
2. *PF2-Matrix:* System-Achse wählt je CEB die `-march`-Politik („voll" ODER „weggelassen"); darunter baut ein CEB die 09b×Organ-Permutationen — kein Doppel, weil die *deklarierte* 09b-ISA und die *angewandte* `-march`-Politik getrennte Rollen behalten.
3. *golden/binary_id:* **neutral** (binary_id = Organ-Kompositionspfad, unberührt); die Mess-**Provenienz** wechselt → neue Metadaten-Version (H-10/Q5, LEDGER:1783/1785).
4. *Doktrin:* **eingehalten auf Achsen-Ebene** — die System-Achse **treibt** (User-H-7 erfüllt), berührt aber die binary_id nicht (e18-⟂ gewahrt); der einzige Merge ist die Flag-Konkatenation an der `CompileFn`.
5. *INC-2-Naht:* der `-march`-**Rahmen** (Flag + Sidecar-Text) ist INC-1d; die **Version-Bump-Kopplung** (AVX10-Feld an POD, per-Binary-Schema) ist INC-2 — saubere Trennung bleibt.
6. *AVX512-mit-vs-ohne (H-7 „volle Kontrolle"):* direkt abgebildet — die System-Achse trägt genau die binäre Politik „einkompilieren ODER weglassen"; der Vergleich lebt von der Sidecar-Versionierung, nicht von der binary_id.

### (d) Begründete Empfehlung

**Option C.** Sie ist die einzige, die **beide** autoritativen Vorgaben zugleich erfüllt: die e18-Doktrin „ISA-Organ ⟂ Hardware-System, System berührt nie die binary_id" (`DOSSIER:22`) **und** die User-Erweiterung „eine Tier-Binary wird durch eine CEB-System-Achse STATISCH … kompiliert … volle Kontrolle" (`LEDGER:418`). Option A erfüllt die Doktrin, unterspielt aber die vom User ausdrücklich **über** die Empfehlung hinaus ergänzte Treiber-Rolle (Report D, Widerspruch #3). Option B erfüllt die Treiber-Rolle, bricht aber Doktrin + golden-Neutralität und erzeugt ein 09b-Doppel. Option C legt den **Wert** an die System-Achse (Treiber, „volle Kontrolle"), den **Ort** an die ohnehin dafür vorgesehene `CompileFn`-Naht und die **Unterscheidbarkeit** an die H-10-Provenienz statt an die binary_id — genau die Auflösung, die Report D (Widerspruch #4) als „auflösbar, wenn die `-march`-Wahl NEBEN der binary_id als Build-Provenienz versioniert wird" benennt. **Zusatz (Q2-unabhängig, in allen Optionen zwingend):** `make_gpp_compile_fn` braucht einen Compiler-Dialekt-Selektor, `-fno-gnu-unique` (`build_orchestrator.hpp:479`) MUSS für clang entfernt werden, und `-march=native` ist je Compiler getrennt zu führen (der „5 %"-Vergleich lebt von dieser Trennung).

### (e) Ist Q2 schon entschieden? — NEIN (Report D)

Report D beantwortet die Leitfrage explizit: „**Ist Q2 damit entschieden? NEIN — die Dossiers entscheiden Q2 NICHT.** Sie fixieren nur den **Ort** (injizierte `CompileFn` in `make_gpp_compile_fn`) und die **Kontroll-Semantik** (einkompilieren ODER weglassen), aber NICHT die **konkrete `-march`-Aufhängung** (welcher Wert, aus welcher Achse abgeleitet)." Verschärfend: die Frage wurde **chronologisch später** vom User als **Freigabe-Gate reöffnet** (`LEDGER:1916`, verbatim): „**(Q2 OFFEN — FREIGABE-GATE):** H-7-`-march`-Aufhängung wird per ultracode neu recherchiert und dem User **kontextreich neu vorgelegt**; „derzeit ohne Q2 keine Freigabe" ⇒ **Baustart INC-1 erst nach Q2-Antwort.**" Die Vorlage wird daher als **echte offene Ruling** vorgelegt (nicht als „vermutlich schon entschieden") — mit der obigen begründeten Empfehlung (Option C) als Steuerung.

---

## (4) AKTUALISIERTE INC-1-SEQUENZ (mit Q1/Q3-Anpassungen)

| Inc | Inhalt (Delta ggü. Bauplan) | Ausschneide-Scope | Wartet auf Q2? |
|---|---|---|---|
| **INC-1a** *(ANGEPASST, Q1)* | **Dach `Axis<Derived>` + `AxisConcept` einziehen** (neuer Header `topics/axis.hpp`, semantik-frei, empty base). `CebSystemAxis<Derived>` (neu) + `SystemAxis<Derived>` unters Dach hängen (`: Axis<Derived>`, Concepts refinen `AxisConcept`). | **Stufe 1 (additiv):** Dach + SystemAxis/CebSystemAxis-Anschluss → golden==320 byte-identisch, ABI-4 unberührt. **Stufe 2 (ABI/golden-sensibel, EXPLIZIT markiert):** `AxisBase`→`OrganAxis<Derived>` + 22 `…StrategyBase` umhängen. **Gate-Regel:** hält Stufe 2 golden==320 nicht byte-identisch ODER berührt ABI-4 → **nach INC-2 schieben** (Zwischenlösung: `…StrategyBase` erben zusätzlich `Axis<Derived>`). | nein |
| **INC-1b** | `build_system_axis_levels()` abspalten (unverändert). 19 Organ-Segmente + Reihenfolge UNBERÜHRT. | additiv (Struktur-Abspaltung) | nein |
| **INC-1c** | Scheduling-System-Achse `SchedulingSystemAxis<D> : CebSystemAxis<D>` (unverändert). vtable bleibt DEPRECATED, nicht gelöscht. | additiv (daneben, nicht Ersatz) | nein |
| **INC-1d** *(Q2-GATED)* | Hardware-ISA-System-Achse + **H-7-`-march`-Kopplung** in `make_gpp_compile_fn` (`build_orchestrator.hpp:466/476`). **Ohne Q2-Ruling NICHT starten.** Compiler-Kopplung wandert nach INC-1h. | additiv (Flags berühren Serialisierung nicht) | **JA — der einzige** |
| **INC-1e** | Telemetrie-RAHMEN (unverändert). Organ-Slot T10 UNBERÜHRT (Herauslösung = INC-2). | additiv (nur Verankerung) | nein |
| **INC-1f** | Last/Last-Framework-System-Achse `LoadFrameworkSystemAxis<D>` (unverändert). Workload bleibt dyn. Unter-Achse. | additiv (Label über dyn. Sub-Dim) | nein |
| **INC-1g** | H-10 CEB-System-Achsen-Versionierung (`build_version` `:62`, Sidecar-Text). KEIN POD-Feld/AVX10. | additiv (Sidecar-Text) | nein |
| **INC-1h** *(NEU, Q3)* | **Compiler-System-Achse** `CompilerSystemAxis<D> : CebSystemAxis<D>` (gcc\|clang static-constexpr) + `cxx_compiler()`-Anbindung (`profile_run_facade.cpp:129-132`) + **`-fno-gnu-unique`-Compiler-Gate** (`build_orchestrator.hpp:479`) + Serialisierungs-Ordner (Host→OS→**Compiler**→ISA) + H-10-Sidecar-Feld (`compiler_id`/`_version` per-Binary, in `build_version` kodiert). golden-neutral belegen (`grep -c` Compiler-Token in Golden == 0). | additiv (System-Ordner + Sidecar) | nein (orthogonal zu `-march`) |

**Konsolidierungs-Checkpoint** nach INC-1h: voller super-Sub-Build + golden-Roundtrip==320 (Stufe-2-INC-1a byte-identisch, falls dort gelandet) + ABI-4 (kein Major-Bump) + cf22==0 + Mojibake==0 + beide Remotes ref-gleich.
**Reihenfolge-Hinweis:** das `-fno-gnu-unique`-Compiler-Gate aus INC-1h ist **Voraussetzung** für die clang-Leg des „5 %"-Vergleichs — landet die Vergleichs-Messung von INC-1d unter beiden Compilern, muss INC-1h (bzw. sein Gate-Sub-Schritt) davor grün sein.

**Auf Q2 wartet ausschließlich INC-1d.** Alle übrigen Increments (1a/1b/1c/1e/1f/1g/1h) sind Q2-unabhängig und dürfen vor der Q2-Antwort gebaut werden (goldene/ABI-Gates je Increment bleiben Pflicht).
