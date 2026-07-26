# QUELLE 3 — Plandocs/Architektur: Erhebung des LAYER-Modells der Haupt-Achsen (19.–26.07.)

## 0. Methodik + Fundlage

Durchsucht: `docs/architektur/` (33 .md, `grep -icE 'komplex.?haupt|meta.?meta|rekursiv|layer'`), `docs/sessions/backups/20260726-strukt-r-planung-workflow/ergebnisse/` (4 .md), `docs/sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md`.

**Harter Negativ-Befund (literal):** Der Begriff **`Komplex-Haupt-Achse` kommt in `docs/architektur/` NULL Mal vor** — in allen 33 Dateien 0 Treffer (`grep -rniE 'komplex[- ]?haupt' *.md`). Er existiert im gesamten Repo an genau **8 Stellen**, alle vom **26.07.**, alle in den beiden anderen Quellen (Session-Doc + `strukt-r`-Backup). Ebenso: `Meta-Meta-Achse` existiert in `docs/architektur/` nur in **EINER** Datei (`2026-07-20-cache-engine-architektur-in-eigenen-worten.md`, 8 Treffer). **`Rekursivität` der Haupt-Achsen-Struktur ist als Begriff NIRGENDS dokumentiert** (0 Treffer in beiden Quellen für `rekursiv` im Achsen-Kontext; die 2 Repo-Treffer im Zeitfenster betreffen GitLab-Bridges, `sessions/20260722-…netzwechsel.md:26`, `sessions/20260723-…netzwechsel-2.md:27`).

Datierung: Die einzige Architektur-Datei mit Meta-Meta-Modell trägt Inhalts-Stand **20.07.** (mtime 26.07. 05:42 = Scrub/Identity-Pass). Das autoritative **Layer**-Dokument (`21_…`) trägt Inhalts-Stand **10.07.** (mtime 18.07.) — also **vor** dem Zeitfenster. **Im Zeitfenster 19.–26.07. wurde in `docs/architektur/` KEIN neues Layer-Dokument angelegt.**

---

## 1. Komplex-Haupt-Achse (Schichtung/Buendelung, Command-Pattern)

### 1a. Der Ursprungs-Satz (Owner-KERN, wortgenau)

`docs/sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md:27-34`:

> - **R-D compiler ist faelschlich Haupt-Achse** — real separate UNTER-Achse, welche die
>   fixe Permutations-Rekombination target_isa x extension_hardware x Meta-Meta-Achsen
>   (ohne load_framework) als **KOMPLEX-HAUPT-ACHSE nach dem Command-Pattern** annimmt
>   (ein Compiler ist fuer diese Rekombination immer passend ausgelegt/verfuegbar; alle 3
>   sind Haupt-Achsen, verhalten sich aber wie EINE — Haupt-Achsen bekommen Schichtungen
>   in derselben Kategorie). compiler + opt_level + atomic128 = **UNTER-ACHSEN-GRUPPE**
>   (untrennbar: nur bestimmte Compiler bieten bestimmte Handles; der Compiler ist aus
>   CEB-Sicht ein zur Laufzeit austauschbares Programm).

Das ist die **einzige** Stelle im Repo, die das Layer-Prinzip generalisiert ausspricht: **„Haupt-Achsen bekommen Schichtungen in derselben Kategorie"** — und **„alle 3 sind Haupt-Achsen, verhalten sich aber wie EINE"**.

### 1b. Die Konstruktions-Kartierung (mein Backup)

`docs/sessions/backups/20260726-strukt-r-planung-workflow/ergebnisse/01-system-welt-a51c70a7.md:190`:

> 2. **Komplex-Haupt-Achse (R-D):** neu `ceb_complex_system_axis.hpp` — Command-Pattern nach dem VORBILD, das im Repo bereits benannt ist: `CE/libs/cache_engine/builder/commands/axis_library_registry.hpp` (Command-Achsen-Registry). Form: `template <class TargetIsa, class ExtHw, class... MetaMetas> struct CompoundSystemAxis` mit `axis_label()` (ein NEUER Name, z.B. `"build_target_complex"`), das `do_axis_label()` der 3 Teile weiter exponiert (Session §2 R-D: "alle 3 sind Haupt-Achsen, verhalten sich aber wie EINE"). Die Unter-Achsen-Gruppe `compiler+opt_level+atomic128` als `template <class... SubAxes> struct SubAxisGroup` mit `group_label()`.

`01-system-welt-a51c70a7.md:178`:
> 2. Die Komplex-Haupt-Achse braucht ein LABEL (heute existiert keins). Alle `parent="..."`-Strings der Gruppe zeigen darauf.

`00-bauplan-a67e501b.md:102` (Stufe A-I.4):
> **R-D** NEU `ceb_complex_system_axis.hpp` (Command-Pattern, Vorbild `builder/commands/axis_library_registry.hpp`): `CompoundSystemAxis<TargetIsa, ExtHw, MetaMetas...>` + `SubAxisGroup<compiler, opt_level, atomic128>`; `compiler` verliert Haupt-Status

`03-modus-suffix-welt-a288b88b.md:127`:
> R-B: `scheduling` = Unter-Achse von `target_isa`. R-D: `compiler+opt_level+atomic128` = Unter-Achsen-GRUPPE der Komplex-Haupt-Achse `target_isa x ext_hw x MetaMetas`. R-C: `load_framework` = 1. Meta-Meta (hinter allem, vor dem variadischen HW-Meta-Meta-Array).

### 1c. Das nächstliegende Architektur-Vorbild (ohne den Begriff)

`docs/architektur/2026-07-20-cache-engine-architektur-in-eigenen-worten.md:73`:
> Eine **statische Hardware-Haupt-Achse** ist der **Manager** über ein **statisches Achsen-ARRAY**.

Das ist strukturell dieselbe Bündelung (eine Haupt-Achse, die Haupt-Achsen führt) — aber **nur für Hardware**, nicht als allgemeines Layer-Gesetz formuliert, und nicht „verhält sich wie EINE".

---

## 2. REKURSIVITAET der Haupt-Achsen-Struktur

**Als Begriff nicht dokumentiert.** Die nächstliegenden wortgenauen Belege — beide im **Layer-Dokument `21_…`, Stand 10.07., also VOR dem Zeitfenster**:

`docs/architektur/21_SESSION_PLAN_TYPSYSTEM_ACHSEN_ENTSCHEIDUNGEN.md:16-20` (A.1):

> 1. **Der Experiment-Baum ist ein B+-Baum, LAYER-sortiert:** jede Achse = ein Layer. Eine **statische
>    (compile-time) Achse** bildet einen strikten Layer; darunter folgen **dynamische Achsen-Nodes**, bis wieder
>    eine statische Achsen-Konfiguration eingehängt ist. Der **SPREAD** einer Node = alle Variationen EINER
>    Achse — ENTWEDER statische compile-time-Algorithmen ODER dynamische Wert-Änderungen. **Die beiden fallen
>    NIE zusammen** (pro Node-Spread genau eine Sorte).

Das „**bis wieder eine statische Achsen-Konfiguration eingehängt ist**" ist die einzige dokumentierte Form von Rekursivität: **Alternation static → dynamic → static**, unbegrenzt tief. Es ist NICHT als „Haupt-Achse enthält Haupt-Achse" formuliert.

`21_…:26-28` (A.4):
> 4. **Decorator über das Visitor-Objekt:** loggt beim rekursiven Durchgang durch die Achsen-Schichten den
>    State der Tier-Binary-Wahl (ein Stack). Compile-time legt die statischen Instanzen fest und ermittelt
>    effektiv nur die dynamischen.

`21_…:10`:
> Es ersetzt das „orthogonal compile/dynamic"-Bild aus Doc 20 §I durch das korrigierte **Layer-/Haupt-Unter-Achsen-Modell**.

Bestätigt in `20_HEURISTIK_MESSKURVEN_TYPSYSTEM_UND_FILTERKETTE.md:144`:
> **SUPERSEDIERT/PRÄZISIERT (2026-07-10):** Das „orthogonal compile/dynamic"-Bild aus §I ist durch das autoritative **Layer-/Haupt-Unter-Achsen-Modell** in `21_SESSION_PLAN_TYPSYSTEM_ACHSEN_ENTSCHEIDUNGEN.md` ersetzt

und `21_…:236`:
> das `tree<...>`-Typsystem als Layer-B+-Baum bauen (Haupt-/Unter-Achsen als Layer, Wurzel=System-Achsen mit Visitor+Strategy, …)

---

## 3. Meta-Meta-Achsen ALS Haupt-Achsen (CT-statisch) mit EIGENEN Unter-Achsen

### 3a. „ALS Haupt-Achse, CT-statisch" — wortgenau belegt

`docs/architektur/2026-07-20-cache-engine-architektur-in-eigenen-worten.md:69-78`, Abschnitt-Titel: **„## 7. Meta-Meta-Achsen: Command-Pattern-Freigabe und zweischichtige Permutation"** (Herleitung: „§54-T5/T7"):

`:73`:
> - Eine **statische Hardware-Haupt-Achse** ist der **Manager** über ein **statisches Achsen-ARRAY**. Jeder Erweiterungshardware-Typ (AVX512 mit seinem komplexen Flag-System, AVX2, später GPU/FPGA/NPU) ist eine **eigene Achse** — eine **Meta-Meta-Achse** unter diesem Manager. „Alles, das kein CPU-Core im herkömmlichen Sinne ist und einen speziellen Befehlssatz braucht", ist eine Hardware-Erweiterung.

`:74`:
> - Die Hardware-Haupt-Achse **verwaltet und gibt frei**. Jede Meta-Meta-Achse erteilt dann — **als eigenständige Instanz nach dem Command-Pattern** — Freigaben an die Organ-Achsen.

`:75` — **das ist der Kern-Satz zu (3)**:
> - **Zweischichtige Kern-Permutation:** die Hardware-Haupt-Achse permutiert nicht nur die *Werte* jeder Meta-Meta-Achse (Schicht 2), sondern auch deren **Existenz (an/aus)** (Schicht 1). Der CEB baut damit Tier-Binaries **mit wechselnden oder ganz fehlenden Hardware-Erweiterungen**. Die Existenz-Wahl ist **compile-time**; die Meta-Meta-Achse bleibt eine **volle, zur compile time ausgerollte Haupt-Achse**.

`:76`:
> - **Konsequenz:** die tatsächliche System- *und* Organ-Achsen-**Zahl wächst dynamisch je nach Maschine**, auf der alles läuft. 17 Organe / 6 System-Achsen sind kein fixer Stand, sondern der Kern, der sich host-abhängig erweitert. Die Organ-Seite hat symmetrisch ein analoges Manager-Array + aus einem Fold abgeleitete (nicht hartcodierte) Versionierungs-Stempel für den durch die CEB materialisierten compile-Raum.

`:78` (Stand-Vermerk):
> *Stand:* heute existiert erst EIN Familien-Knoten (SIMD); er ist CT/vtable-frei/binary_id-neutral und damit zielarchitektur-kompatibel. Das volle Manager-Array ist ein Bau-Ziel — eine **Lücke, kein Verstoß**.

Wiederholt in `:187` (UPDATE 2026-07-22, U1):
> inklusive **Meta-Meta-Achsen** (das Hardware-Erweiterungs-Array, dessen Existenz die Hardware-Haupt-Achse selbst per zweischichtiger Kern-Permutation an/aus permutiert, Freigabe per Command-Pattern)

und `:209` („Auf einen Nenner"):
> welche freigegeben sind, entscheiden Meta-Meta-Achsen per Command-Pattern je nach Maschine — die Achsen-Zahl wächst dynamisch, compile-time-permutiert in zwei Schichten (Existenz und Wert).

Konformitäts-Stand `:146`:
> Die Meta-Meta-Command-/Zwei-Schicht-Struktur (T5/T7) ist eine **Lücke, kein Verstoß** (S10-Bauziel).

### 3b. „mit EIGENEN Unter-Achsen" — NICHT explizit dokumentiert, aber zweifach implizit belegt

**Keine Stelle in `docs/architektur/` sagt literal, dass eine Meta-Meta-Achse eigene Unter-Achsen trägt.** Belegt ist nur das allgemeine Rekursions-Axiom + zwei Ist-Fundstellen:

Axiom, `21_…:29-31` (A.5):
> 5. **EIN Concept für alle Achsen — Haupt-Achse + Unter-Achse:** eine Unter-Achse ist eine **VOLL-Achse**, die
>    unter der compile-time-Haupt-Achse ausgeführt wird. Der frühere „Laufzeit-Skalar" (RC-POD-Feld) ist in
>    Wahrheit eine **Unter-Achse**.

(⇒ „volle, zur compile time ausgerollte Haupt-Achse" `:75` + „EIN Concept für alle Achsen" `21_…:29` ergeben zusammen die vom Owner benannte Struktur — sie ist aber **nirgends zusammengeschrieben**.)

Ist-Belege, dass Meta-Metas heute schon Unter-Achsen führen:
- `01-system-welt-a51c70a7.md:21` — `extension_hardware` (der HUB): „`:49` `sub_axis_label()==family_id()`, `:66` `SimdExtensionHardwareFamily`" → **R-E: -> Command-Pattern-HUB**
- `01-system-welt-a51c70a7.md:24` — `load_framework`: „`:29` `sub_axis_label()=="workload"` (hartkodiert!)" → **R-C: -> 1. Meta-Meta** ⇒ die 1. Meta-Meta trägt heute bereits eine Unter-Achse (`workload`).
- `00-bauplan-a67e501b.md:103`: „**R-C** `load_framework` -> `AxisKind::system_meta_meta`, 1. Meta-Meta; `sub_axis_label()=="workload"` (`load_framework_system_axis.hpp:29`) bleibt UNANGETASTET"

Der Owner-KERN dazu, `SESSION…:35-46` (R-E):
> Die Meta-Meta-Haupt-Achsen auf dem variadischen Array hinter load_framework (Metaprogrammierung OHNE std::variant) sind FESTE Bestandteile der Maschinen-Identitaet. […] **extension_hardware = offizieller Command-Pattern-HUB** der Hardware-Meta-Meta-Haupt-Achsen; seine Identitaet IST exakt deren Konfiguration.

**Ist-Blocker (literal):** `01-system-welt-a51c70a7.md:10`:
> `topics::AxisKind` | `CE/libs/cache_engine/topics/axis.hpp:17-21` | NUR 3 Werte: `organ`, `system_measurement`, `system_config`. **Kein `meta_meta`** -> R-C/R-E haben heute KEINEN Diskriminator.

und `:11`: „`topics::Axis<Derived>` | `topics/axis.hpp:26-30` | **Layer-Supertype**, empty, CRTP" — der einzige Ort, an dem der Ist-Code das Wort Layer trägt.

---

## 4. CT/RT als das EINZIGE Haupt/Unter-Kriterium

**Dokumentiert — aber nirgends mit dem Wort „einziges Kriterium".**

`2026-07-20-…-eigenen-worten.md:31-36`, Abschnitt-Titel **„## 3. Das durchgehende Prinzip: Haupt vs. Unter (Ketten-Statik, §24)"**:

`:33`:
> Ein einziges Prinzip wiederholt sich an *jedem* der drei Vertragspunkte identisch:

`:35-36`:
> - **Haupt-Achse = compile-time-statisch.** Sie wird fest in das Binary einkompiliert; jede Haupt-Wahl erzeugt ein **eigenes** Binary bzw. eine eigene Baustrecke. Sie trägt einen Versionierungs-Stempel.
> - **Unter-Achse = dynamisch.** Sie wird an die *nächste* Stufe als Laufzeitparameter **delegiert** — kein eigenes Binary, sondern eine Variable, die zur Laufzeit variiert.

`:187` (U1, Gesetzes-Status):
> Quer dazu liegen die unveränderten Gesetze: **Haupt = compile-time, Unter = runtime** an jedem der drei Vertragspunkte

`:65`:
> Alle Binary-Stempel tragen **nur Haupt-Achsen**; die **Unter-Achsen sind dynamische Laufzeit-Parameter**, die durch die Binary hindurchfließen und **nicht gestempelt** werden.

Disjunktions-Härte, `21_…:19-20`:
> ENTWEDER statische compile-time-Algorithmen ODER dynamische Wert-Änderungen. **Die beiden fallen NIE zusammen** (pro Node-Spread genau eine Sorte).

Stufen-Relativität (Owner-KERN 26.07.), `SESSION…:48-52`, Abschnitt **„## 3. DUAL-NATUR (Haupt/Unter ist stufen-relativ)"**:
> load_framework und Mess-Tooling sind LAUFZEIT-Unterachsen auf dem PLANER und
> COMPILE-TIME-Haupt-Achsen auf der CEB (bestaetigt die §24-Regel: dynamische Einstellungen
> der Vorstufe = CT-Draehte der naechsten Stufe).

**Gegen-Befund im Ist-Code (das eigentliche Problem):** `01-system-welt-a51c70a7.md:45`, RISS 1:
> **RISS 1 (fundamental): Es gibt KEINE `CebSubAxis`-Wurzel.** Haupt/Unter unterscheidet sich ausschliesslich durch die Anwesenheit eines `parent_axis_label()`-Members — ein reiner Konventions-String, nicht typisiert. R-B/R-D sind daher NICHT als Typ-Umhaengung ausdruckbar, sondern nur als String-Aenderung + Generator-Umbau. Fuer R-B/R-D/R-C/R-E braucht es zuerst eine echte Schicht-Taxonomie (`CebSubAxis<Derived, Parent>` mit `parent_axis()`-TYP statt String, plus `AxisKind::system_meta_meta`).

`01-system-welt-a51c70a7.md:63`, RISS 2:
> `stage="ct"|"runtime"` ist die EINZIGE Schicht-Information in der XML; ein 3. Level (Meta-Meta) hat kein Vokabular.

⇒ CT/RT ist als **Gesetz** dokumentiert, im Ist-Code aber **nicht** das Kriterium (dort: Anwesenheit eines Strings). Das ist der literal benannte BLOCKER.

---

## 5. Wie `operating_system` hineinpasst — der DELTA zur Owner-Korrektur

### 5a. Wortgenau dokumentierter Ist-Plan: OS = FLACHE, einzelne System-Haupt-Achse

`SESSION…:9-14` (§1 BINDENDE ACHSEN-SORTIERUNG):
> Verzeichnisbaum-/Ordnungs-Kette: (1) MESS-TOOLING (Mess-Haupt-Achse; measurement_category
> = ihre Unter-Achsen) -> (2) target_isa -> (3) operating_system (NEU) -> (4)
> extension_hardware -> (5) ORGAN-Achsen (T00-T16, unveraendert) -> letztes Haupt-Blatt ->
> 3 Unter-Ebenen: Mess-Unter -> System-Unter -> Organ-Unter.

`SESSION…:18-19` (R-A):
> - **R-A operating_system fehlt** als System-Haupt-Achse. NEU bauen; Unter-Achsen:
>   os_version, kernel, build, update_zustand.

`00-bauplan-a67e501b.md:100` (A-I.2):
> **R-A** NEU `operating_system_system_axis.hpp` (CRTP nach Vorbild `machine_simd_signature.hpp:31-48`) + 4 Unter-Achsen `os_version/kernel/build/update_zustand` (Vorbild `optimization_level_sub_axis.hpp`)

`01-system-welt-a51c70a7.md:204`:
> **Empfehlung R-A (Naht-Vorschlag, nicht ausgefuehrt):** `operating_system` folgt dem `machine_simd_signature`-Muster exakt: eine CT-deklarative `OperatingSystemSystemAxis`-CRTP-Wurzel (`operating_system_system_axis.hpp`) mit Auspraegungen je real gemessener Maschine, deren Unter-Achsen `os_version/kernel/build/update_zustand` als `CebSubAxis`-Familien haengen (Vorbild `optimization_level_sub_axis.hpp`).

POD-Form, `01-system-welt-a51c70a7.md:117` (RISS 7):
> neuen POD `OperatingSystemAxisSel{os_version, kernel, build, update_zustand}`

### 5b. Der DELTA: OS war NICHT Teil der Komplex-Haupt-Achse

- R-D definiert den Komplex **explizit ohne OS**: „target_isa x extension_hardware x Meta-Meta-Achsen (ohne load_framework)" (`SESSION…:28-29`). `operating_system` fehlt in dieser Aufzählung.
- Ebenso im Bauplan-Typ: `CompoundSystemAxis<TargetIsa, ExtHw, MetaMetas...>` (`00-bauplan…:102`, `01-system-welt…:190`) — **kein `Os`-Template-Parameter**.
- Q-3-Vorschlagsraum behandelt OS als **Peer-Haupt-Achse neben** dem Komplex, `00-bauplan-a67e501b.md:221`:
  > **S1 flach/intern:** Stempel-Tabelle = `{target_isa, operating_system, extension_hardware, load_framework}` (Count 5 -> 4), Komplex-Achse und alle Unter-Achsen unsichtbar.
  > **S2 geschachtelt, Komplex intern (EMPFEHLUNG):** 4 Haupt-Zeilen + explizite Unter-Zeilen in Klammer-Notation (`target_isa[scheduling]`, `extension_hardware`, `<gruppe>[compiler,opt_level,atomic128]`), Komplex-Achse bleibt CEB-intern.
- Suffix-Sicht ebenso flach, `03-modus-suffix-welt-a288b88b.md:134` / `:195`:
  > `+os=<...>                  (3) operating_system     NEU, weglassbar wenn nicht deklariert`
  > (T-c) Ordnungs-Wache — `+target` vor `+os` vor `+ext` vor `+cxx` vor `+opt` vor `+a128` vor `+bt` vor `+ceb`

**Einzige Stelle, die OS in die Haupt-Legende zieht** (interner Widerspruch meines eigenen Backups), `01-system-welt-a51c70a7.md:139` (RISS 8):
> Nach R-D wird `opt_level` Teil einer Gruppe UNTER der Komplex-Haupt-Achse, und die Haupt-Legende muss target_isa x os x ext_hw x MetaMetas tragen.

Hier steht `os` **im** Komplex-Produkt — inkonsistent zu R-D `:28-29` und zum Typ `CompoundSystemAxis<TargetIsa, ExtHw, MetaMetas...>`.

### 5c. Präzise Diagnose des Verständnis-Bruchs

Die Owner-Korrektur sagt „**Das OS ist keine Unter-Achse, sondern eine Komplex-Haupt-Achse**". Erhoben in Quelle 3:

1. **OS wurde NIE als Unter-Achse geführt** — 0 Fundstellen. Es wurde durchgängig als *System-Haupt-Achse* geführt (`SESSION…:18`, `00-bauplan…:100`, `01-system-welt…:204`).
2. **Was falsch war: OS wurde als FLACHE, einfache Haupt-Achse geführt** — eine CRTP-Wurzel mit 4 daran hängenden `CebSubAxis`-Familien — **nicht als Komplex-Haupt-Achse mit eigener Schichtung/Command-Pattern-Bündelung**. Der Komplex-Mechanismus wurde als **Einzelfall-Konstrukt für R-D** interpretiert (ein Typ, `ceb_complex_system_axis.hpp`, dessen Existenzgrund es ist, die `SubAxisGroup<compiler, opt_level, atomic128>` aufzunehmen), **nicht als generisches Layer-Gesetz aller Haupt-Achsen**. Der Satz, der es zum Gesetz macht, steht wortgenau da und wurde nicht als solches gelesen: „**Haupt-Achsen bekommen Schichtungen in derselben Kategorie**" (`SESSION…:31-32`).
3. **Meta-Meta-Achsen wurden als Kind-Ebene UNTER dem HUB modelliert, nicht als Haupt-Achsen mit eigenen Unter-Achsen.** Die Bauplan-Form ist `std::span<MetaMetaDescriptor const> meta_metas()` (`00-bauplan…:54`, `:163`; `01-system-welt…:191`) — ein **Descriptor-Span**, also Daten, keine vollen Haupt-Achsen-Typen mit eigener Unter-Achsen-Schicht. Dokumentiert gefordert war aber: „die Meta-Meta-Achse bleibt eine **volle, zur compile time ausgerollte Haupt-Achse**" (`…eigenen-worten.md:75`).
4. **Rekursivität fehlt komplett.** Die geplante Schicht-Taxonomie ist **genau 2-stufig**: `CebSubAxis<Derived, ParentAxis>` mit `static_assert(CebSystemAxisConcept<ParentAxis>)` (`01-system-welt…:189`, `00-bauplan…:99`) — das Prädikat erzwingt, dass der Parent eine **System-Haupt-Achse** ist, und schließt damit strukturell aus, dass eine Unter-Achse selbst Unter-Achsen trägt oder eine Meta-Meta-Achse Parent sein kann. Kein Konstrukt in Quelle 3 ist rekursiv; `AxisKind` sollte um **genau einen** Wert `system_meta_meta` wachsen (`:189`, `00-bauplan…:99`) = ein **festes 3. Level**, nicht offene Tiefe. Vgl. `01-system-welt…:63`: „ein 3. Level (Meta-Meta) hat kein Vokabular."

---

## 6. Was Quelle 3 für die Korrektur NICHT liefert (Erfindungs-Verbot beachtet)

- Keine Stelle definiert, **welche Haupt-Achsen** außer target_isa/ext_hw/MetaMetas Komplex-Achsen sein dürfen oder wie tief geschichtet werden darf.
- Keine Stelle nennt `operating_system` als Komplex-Haupt-Achse.
- Keine Stelle definiert Rekursions-Tiefe, Abbruch-Bedingung oder ein rekursives Concept für Haupt-Achsen.
- Keine Stelle sagt, ob eine Meta-Meta-Achse **selbst** eine Komplex-Haupt-Achse sein kann.
- Offen (mein eigener Bauplan hat es als Owner-Frage stehen): `00-bauplan-a67e501b.md:219` Q-2b — ob `update_zustand` CT-deklarierbar ist: „Als CT-Achse ist er strukturell luegen-anfaellig. Soll er (i) CT-Achse mit Grob-Klassen (z.B. `frozen`/`rolling`) sein, (ii) reine Laufzeit-Provenienz (keine Achse), oder (iii) Achse mit genau einem Baustein `unknown` als Platzhalter?" — Wenn OS eine **Komplex-Haupt-Achse mit 4 RT-Unter-Achsen** ist, wird Q-2b nach dem CT/RT-Kriterium (§4) automatisch beantwortet: alle 4 sind **RT-Unter-Achsen**, also Laufzeit — die Frage „CT-deklarierbar?" war schon falsch gestellt.
- `Q-3` (`00-bauplan…:221`) blockiert `A-II` und ist mit der Korrektur **hinfällig in seiner Formulierung**: alle drei Varianten S1/S2/S3 setzen die Komplex-Achse als *ein* CEB-internes Konstrukt neben 4 flachen Haupt-Zeilen voraus.

---

## 7. Relevante Dateipfade (absolut)

- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/architektur/2026-07-20-cache-engine-architektur-in-eigenen-worten.md` (§7 = einzige Meta-Meta-Quelle; Z. 31-36, 65, 69-78, 146, 161, 183-187, 209)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/architektur/21_SESSION_PLAN_TYPSYSTEM_ACHSEN_ENTSCHEIDUNGEN.md` (autoritatives **Layer-/Haupt-Unter-Achsen-Modell**; Z. 10, 16-20, 26-31, 50, 236)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/architektur/20_HEURISTIK_MESSKURVEN_TYPSYSTEM_UND_FILTERKETTE.md:144` (Supersedierungs-Vermerk auf 21_)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md` (Owner-KERN; §1 Z.9-14, §2 Z.18-46, §3 Z.48-52)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/backups/20260726-strukt-r-planung-workflow/ergebnisse/01-system-welt-a51c70a7.md` (Ist-Kartierung; Z. 10-11, 21-24, 45, 63, 96, 117, 139, 178, 185, 189-191, 204, 210)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/backups/20260726-strukt-r-planung-workflow/ergebnisse/00-bauplan-a67e501b.md` (Z. 34, 54, 99-103, 161-164, 217-221, 243)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/backups/20260726-strukt-r-planung-workflow/ergebnisse/03-modus-suffix-welt-a288b88b.md` (Z. 121, 126-127, 134, 168-169, 174, 195, 231)

**Selbstcheck ASCII:** Zitate enthalten die Original-Sonderzeichen der Quellen (ä/ö/ü/„"/—/→/∪/⊥/∏) — diese Meldung ist ein Erhebungs-Report, kein Quellcode-Kommentar; keine Datei wurde geschrieben oder geaendert.