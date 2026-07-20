# Die Cache-Engine-Architektur in eigenen Worten (Stand 2026-07-20, überarbeitet)

> Reiche finale Gesamtsicht des Systems, wie ich (Fable, als Architekt) es verstehe — auf Wunsch des Autors als eigenständiges Architektur-Dokument abgelegt und nach Abschluss der Konsolidierungs-Workflows **komplett überarbeitet**. Terminologie durchgängig nach den User-bestätigten Sätzen **§54-T1-T7** (Ledger); Auswertungs-Tiefe angereichert aus dem konsolidierten TODO-Block **§55** und der Erinnerungs-Sammlung wiederverwendbarer Konzepte. Bei Konflikt mit älterem Vokabular gilt dieses Dokument bzw. §54/§55. Kein Ersatz für die Primärquelle (LaTeX-Design + Ledger), sondern eine kohärente Gesamtsicht.

---

## 1. Die Grundidee: eine Experiment-Maschine, kein Cache

Der Name „Cache-Engine" führt in die Irre. Das eigentliche Artefakt dieser Arbeit ist ein **Experiment-System**, und das eigentliche Experiment *ist die XML-Profildefinition*. Der gesamte C++-Apparat ist nur die Maschinerie, die eine XML in messbare Binaries übersetzt und daraus reproduzierbare Messdaten erzeugt.

Der Permutationsraum aller theoretisch baubaren Tier-Binaries ist astronomisch (Größenordnung 10^14). Er wird **nie voll materialisiert** — man fährt gezielte, XML-definierte Schnitte hindurch. Die zentrale Forschungsleistung ist die **Achsen-Bibliothek**: ein compile-time-permutierbarer Raum aus algorithmischen und System-Eigenschaften, aus dem konkrete Binaries deterministisch erzeugt und gegeneinander vermessen werden. Das Idealziel (#229): ein Experiment lässt sich **allein durch Ändern der XML** definieren.

## 2. Die dreistufige Kette (plus Hybrid)

Das Rückgrat ist eine Kette dreier Binary-Sorten, plus ein viertes, verbindendes Glied:

```
Planer  ─▶  CEB  ─▶  Tier-Binary   (+  Hybrid-Binary)
(Mess)     (System)   (Organ)          (4. Ketten-Glied)
```

- **Planer** — liest die XML, plant *was* gebaut und gemessen wird, und emittiert die untergeordneten Pipelines/Bauplaene (CI-YAML *und* lokaler Bare-Metal-CMake-Pfad, topologie-isomorph). Trägt die **Mess**-Eigenschaften als seine statische Achse. Existiert als Executable noch nicht — der größte offene Bau-Block.
- **CEB** (Cache-Engine-Builder) — kompiliert die eigentlichen Tier-Binaries und bekommt die **System**-Eigenschaften fest eingebacken. Emittiert selbst die Tier-Stufe.
- **Tier-Binary** — eine konkrete `.so`, ein „Lebewesen" aus **Organen** (den Organ-Achsen). Wird geladen und gemessen.
- **Hybrid-Binary** — das 4. Glied: baut aus realen Messkurven rückwärts die optimalen Algorithmen-Sätze (Break-Even-Auswertung). **Abgabe-Pflicht**; die Break-Even-Auswertung ist und bleibt fester Planbestandteil, weil sie die Hybrid-Tier-Binaries korrekt formt.

Alle drei bis vier Binaries werden in EINER Kette top-down sequentiell generiert und kompiliert: der Planer kompiliert je Messsystem eine CEB, jede CEB kompiliert ihre Tier-Binaries, daraus entsteht das Hybrid.

## 3. Das durchgehende Prinzip: Haupt vs. Unter (Ketten-Statik, §24)

Ein einziges Prinzip wiederholt sich an *jedem* der drei Vertragspunkte identisch:

- **Haupt-Achse = compile-time-statisch.** Sie wird fest in das Binary einkompiliert; jede Haupt-Wahl erzeugt ein **eigenes** Binary bzw. eine eigene Baustrecke. Sie trägt einen Versionierungs-Stempel.
- **Unter-Achse = dynamisch.** Sie wird an die *nächste* Stufe als Laufzeitparameter **delegiert** — kein eigenes Binary, sondern eine Variable, die zur Laufzeit variiert.

| Vertragspunkt | HAUPT (statisch, eigenes Binary) | UNTER (dynamisch, delegiert) |
|---|---|---|
| **Planer → Mess** | Mess-Tooling {Wallclock / Makro / Micro} | Ablaufmethodik {Debug/Messen/Release} · Workloads/Datasets · measurement_categories · Rückschrieb-Methoden |
| **CEB → System** | statische System-Eigenschaften (ISA/Compiler/Hardware freigegeben) | delegierte System-Eigenschaften (NUMA/Locking, P/E-Core, page_type) |
| **Tier → Organ** | binary_id-bildende Organe | Laufzeit-Ressourcenparameter (Lastprofil, Seed) |

## 4. Achsen sind TYPEN — und „Gattung" ist etwas ganz anderes

Die wichtigste begriffliche Klarstellung (§54-T1):

- **Es gibt KEINE „Achsen-Gattungen".** Achsen sind nach **TYP** organisiert. Es gibt genau drei **Achsen-Typen**: **Organ · System · Mess**. (Der Code führt sie als `AxisKind = {organ, system_measurement, system_config}` — es gibt keinen `genus`-Enumerator; das ist im Ist-Code literal bestätigt.)
- **„Gattung" bezeichnet ausschließlich das Tier-Binary-INTERFACE — die Hülle.** Jede Tier-Binary zeigt nach außen, für den Vertrag, immer ein **einheitliches Gattungs-Interface**, das verkörpert, *was* sie ist (ein Suchalgorithmus-Typ, ein Container-Typ, …). Jede Gattung ist ein **einheitliches Basis-Interface**, das per Metaprogrammierung auch für Tier-Typen erweitert werden kann.

Gattung = *Außenschnittstelle* der Binary (SearchAlgorithm/Container/… als Interface-Familien). Achsen-Typ = die *permutierenden Bausteine* dahinter. Diese zwei Ebenen dürfen nie vermischt werden.

## 5. Der Baum ist je Achsen-TYP

Weil die Gattung nur das Interface ist, strukturiert sie den Permutationsraum nicht. Der **Permutations-Baum existiert je Achsen-Typ** (§54-T4): ein Organ-Baum, ein System-Baum, ein Mess-Baum. Innerhalb eines Baums ist jede Achse eine Ebene, jeder Wurzel→Blatt-Pfad eine Konfiguration (Mixed-Radix-Bijektion). `binary_count = ∏ Achsen-Größen`. Der Baum wird nie voll materialisiert; der Planer läuft ihn ab (lazy Per-Index-Emitter) und emittiert nur die gewünschten Schnitte. Der Baum-Kern ist bereits gattungs-agnostisch — die Zerlege-Achse ist `AxisKind`, nicht die Gattung.

## 6. Was wirklich in eine Tier-Binary kompiliert wird (Freigabe-Materialisierung)

Die Freigabe der System-Achsen an die Organ-Achsen ist nicht bloß abstrakt „Raum frei geben", sondern materialisiert (§54-T3):

> **Der einkompilierte Achsen-Satz einer Tier-Binary = die FREIGEGEBENEN System-Achsen ∪ die 17 Organ-Achsen — alle mit Stempel einkompiliert.**

Die `binary_id` ist der **17-Organ-Kern** (die Identität, die eine Tier-Binary von einer anderen unterscheidet). Die freigegebenen System-Achsen sind *zusätzlich* Teil des materialisierten Raums der Binary (gestempelt), gehen aber nicht in die binary_id ein — sie leben im build_version-Sidecar. So bleibt die binary_id host-portabel, während die Binary trotzdem ehrlich trägt, unter welchen freigegebenen System-Eigenschaften sie gebaut wurde. Im Ist-Code setzt ein struktureller Guard (`profile_to_tree.hpp`) genau das durch: nur die 17 Organ-Achsen bilden binary_id-Ebenen; System-Achsen wandern in die System-Achsen-Schicht/den Sidecar.

Das **Freigabe-Prinzip** (Organ ≤ System) lebt bereits im Code, am schönsten am Beispiel Huge Pages: die **Hardware** deklariert die Fähigkeit (`huge_page_capable()` = Raum frei), das **Allokator-Organ** setzt via `AllocPageHint` durch, compile-time-gegated auf die Fähigkeit. Die System-Achse gibt frei, das Organ wählt. Genauso gibt die **ISA** frei, welche Organe überhaupt baubar sind.

## 7. Meta-Meta-Achsen: Command-Pattern-Freigabe und zweischichtige Permutation

Das ist die dynamische Erweiterung des Achsen-Raums (§54-T5/T7):

- Eine **statische Hardware-Haupt-Achse** ist der **Manager** über ein **statisches Achsen-ARRAY**. Jeder Erweiterungshardware-Typ (AVX512 mit seinem komplexen Flag-System, AVX2, später GPU/FPGA/NPU) ist eine **eigene Achse** — eine **Meta-Meta-Achse** unter diesem Manager. „Alles, das kein CPU-Core im herkömmlichen Sinne ist und einen speziellen Befehlssatz braucht", ist eine Hardware-Erweiterung.
- Die Hardware-Haupt-Achse **verwaltet und gibt frei**. Jede Meta-Meta-Achse erteilt dann — **als eigenständige Instanz nach dem Command-Pattern** — Freigaben an die Organ-Achsen.
- **Zweischichtige Kern-Permutation:** die Hardware-Haupt-Achse permutiert nicht nur die *Werte* jeder Meta-Meta-Achse (Schicht 2), sondern auch deren **Existenz (an/aus)** (Schicht 1). Der CEB baut damit Tier-Binaries **mit wechselnden oder ganz fehlenden Hardware-Erweiterungen**. Die Existenz-Wahl ist **compile-time**; die Meta-Meta-Achse bleibt eine **volle, zur compile time ausgerollte Haupt-Achse**.
- **Konsequenz:** die tatsächliche System- *und* Organ-Achsen-**Zahl wächst dynamisch je nach Maschine**, auf der alles läuft. 17 Organe / 6 System-Achsen sind kein fixer Stand, sondern der Kern, der sich host-abhängig erweitert. Die Organ-Seite hat symmetrisch ein analoges Manager-Array + aus einem Fold abgeleitete (nicht hartcodierte) Versionierungs-Stempel für den durch die CEB materialisierten compile-Raum.

*Stand:* heute existiert erst EIN Familien-Knoten (SIMD); er ist CT/vtable-frei/binary_id-neutral und damit zielarchitektur-kompatibel. Das volle Manager-Array ist ein Bau-Ziel — eine **Lücke, kein Verstoß**.

## 8. Die drei Achsen-Typen im Detail

**Organ-Achsen (17 im Kern).** Die algorithmischen Bausteine (search_algo, cache_traversal, mapping, path_compression, node_type, memory_layout, allocator, prefetch, concurrency, serialization, value_handle, index_organization, io_dispatch, migration_policy, filter, queuing_q1/q2). Sie bilden die binary_id. Manche tragen **dynamische Organ-Unter-Achsen**, die zur Laufzeit an die Tier-Binary delegiert werden — z.B. NUMA-Node-Bindung, Cacheline-Line-Größe (Mess-Kontrast, getrennt von der Knoten-Breite FF2 1–16, die eine echte Organ-Achse ist).

**System-Achsen (6, dynamisch wachsend).** Die **Freigabe-Haupt-Achsen**: **ISA · Compiler · Hardware**, plus die geplante NUMA/Locking-Achse. Sie geben den Raum frei, in dem Organe durchführbar sind. ISA wird per Fork A neu gebaut (Freigabe-Haupt-Achse für durchführbare Organe, cross-compile-erweiterbar). Der Compiler trägt Sub-Achsen (opt_level -O2/-O3/Ofast als Sidecar-Permutation, `atomic128`/cx16). NUMA/Locking und P/E-Core-Hetero sind auf modernen Systemen **dynamische System-Unter-Achsen** (an die Tier-Binary als Laufzeit-Variable delegiert), nicht compile-statische Haupt-Achsen. page_type ist eine Allokations-Zeit-Eigenschaft, die bereits korrekt zweigeteilt ist (RAUM = System-Fähigkeit / DURCHSETZUNG = Allokator-Organ) — keine neue Achse.

**Mess-Achsen.** Der Mess-Typ folgt exakt der Haupt/Unter-Statik (§47, korrigiert durch §54-T2):
- **HAUPT = Mess-Tooling {Wallclock · Makro-Benchmarks · Micro-Benchmarks über Observer}** — statisch, fest einkompiliert; jede Tooling-Wahl ergibt eine eigene CEB-Strecke und trägt den `kMeasurementAxisVersionLine`-Stempel. Der Tooling-Slot wird über einen **compile-time Mess-Visitor** über die Achsen realisiert (Concept-Form, `if constexpr(ObservableAxis)`-gegated, zero-cost — kein AxisCommand-Konjunkt, das `observe_all` bräche).
- **UNTER (Planer-gesteuert, delegiert):** Ablaufmethodik {Debug=parallel / Messen=1-Thread / Release=ohne Messsystem} · Workloads/Datasets · **measurement_categories** · **Rückschrieb-Methoden**. Die 16 `measurement_categories` sind eine **Mess-Tooling-Unter-Achse im Planer** — sie *manifestieren* sich als CSV-Spalten und sind binary_id-neutral, aber konzeptionell sind sie eine Planer-Unter-Achse, keine Auffächerungs-Haupt-Achse.

*Konformitäts-Residue (S0-Audit):* im Ist-Code fächert `plan_legend.hpp` den `[a,b,c]`-HAUPT-Slot heute noch aus `measurement_categories` auf statt aus dem Tooling — genau die „falsch zusammengezogene" Stelle. Das ist der eine echte, schon eingeplante Umbau (§47/S4).

## 9. Die Legenden-Kette: Tier-Build-Array vs. Measurement

Der Planer emittiert eine Child-Pipeline, die sich selbst weiter emittiert. Aus dem Code (`experiment_plan_director.hpp` / `plan_legend.hpp`) präzise (§54-T6, im Ist-Code sauber getrennt):

- **Stufe 1 (Planer, Mess-Achsen-Stufe):** `ceb:build:[a,b,c]` → `ceb:emit:[a,b,c]` (`--emit-tier-ci`) → `ceb:trigger:[a,b,c]`. **[a,b,c] = Mess-Tooling-HAUPT.**
- **Stufe 2 (CEB, System-Achsen-Stufe) — der Tier-Build-Array:** `tier:build:[a,b,c][d,e,f]:chunk<k>`. Das ist **[a,b,c] Mess-HAUPT × [d,e,f] System-HAUPT × chunk<k>** — und der ganze 2^17-Organ-Raum steckt **gebündelt im chunk<k>** (2^17 Einzeljobs wären Rauschen). Die Bau-Legende trägt **nur Haupt-Achsen, kein Organ**.
- **Measurement ist EXTRA** — ein **separater, gegateter Job**, nicht Teil des Tier-Builds: `measure:[a,b,c][d,e,f][g,h,i]`, mit der **dritten Gruppe [g,h,i] = Mess-Unter-Sweep** (Workloads/Datasets/categories/Rückschrieb-Methoden, zur Laufzeit vom Planer permutiert), **`when: manual`**, GN-11/320er-gegatet. Nur **eine** CEB misst gleichzeitig (Mess-Exklusivität), während der Bau parallel laufen darf.

Die Weitergabe der Achsen-Werte über die Trigger-Grenzen ist zentral: jede Stufe reicht explizit weiter, was die nächste braucht (z.B. `COMDARE_GN_TOTAL` per expliziter Forward-Allowlist, sonst baut der Grandchild nur den Default statt 2^17).

## 10. Die Anatomie: Lebewesen, Organe und die Gattungen

Eine Tier-Binary ist ein **Lebewesen**, zusammengesetzt aus **Organen** (den Organ-Achsen). Die Messung beobachtet jedes Organ.

- **Gattungen** (Tier-Binary-Interfaces): **SearchAlgorithm** ist voll ausgebaut — 17 Achsen, davon 9 real getriebene Organe, `ObserverAggregate<17>`, acht Schichten (Composition → Anatomy → Observer → PermutationEngine → ABI-Adapter → Prüf-Dock → ExecutionContext → Binding). **Set / Sequence / Adapter / View** sind bisher Skelette (je nur 1 Organ getrieben); ihre Vervollständigung auf SearchAlgorithm-Tiefe ist der letzte, große ABI-Schritt.
- **Cross-Genus-JOIN ist typ-unmöglich** (Gattungen mit ungleichen Achsen kreuzen nicht). Aber **Cross-Genus-Komposition-als-Sub-Organ** ist der erlaubte, neue Weg: über ein gemeinsames **`OrganConcept`** kann SearchAlgorithm ein Set-/Sequence-/Adapter-Organ als *Sub-Organ* mitverwenden (z.B. `index_organization` ← ein Set, `node_type` ← eine Sequence). So verwendet SearchAlgorithm optimierte Container und Sets gleichermaßen mit, wie deklariert. Genus und ABI bleiben disjunkt, aber gegenseitig nutzbar.
- Der Mess-„Visitor" ist real kein Visitor, sondern ein flacher POD-Pull über `IObservableTier::tier_observe(...)` — ein ABI-stabiles, memcpy-fähiges Schema. Das Haupt-Observer-Interface bleibt statisch (zero-cost).
- Eine echte, offene Achse ist **Locking/Concurrency** (S-7): sie muss in Suchalgorithmen- *und* Container-Gattung real verwendet und in allen Gattungen über echte Observer ermittelt werden (kein Phantom-Enumerator; nur `Upgradeable` shared→exclusive ist real). Das ist Deep-Research-Arbeit (separat, nach Planungs-Abschluss).

## 11. Die Messung selbst: Dimensionen, Pfade und Auswertungs-Views

Gemessen wird in mehreren Dimensionen: **Lebewesen-Wall-Clock** (Latenz über Füllstand), **Per-Achsen-Observer** (`observe_all()` je Organ) und der **Achsen-Vergleich gegen eine Referenz** (entscheidet die Achsen-Güte, nicht die reine Latenz). Zwei Pfade über dieselbe Binary: die isolierte Achse (Pfad A) und das composite Lebewesen (Pfad B). Fehler werden nie als Nullen abgeschaltet — eine Fehl-Zelle trägt „failed" plus Log.

Drei orthogonale Profile bleiben getrennt: **BUILD** (welche Binaries, compile-time) ⊥ **LASTPROFIL** (YCSB/Seed, runtime host) ⊥ **COMPILE-RELEASE** (Debug/Messen/Release). Build ⊥ Last ist ein kartesisches Kreuz: eine Binary × N Lastprofile ohne Rekompilation.

Die Auswertung sind **zwei Views auf denselben serialisierten Baum** (nicht eine vierte Stufe): **View 1** = Referenz-vs-Prüfling je Stufe (Compiler/ISA/OS sind reine Gruppierungs-Schlüssel, nie Teil der Identität); **View 2** = Build-über-Build-Regression (Welch-t-Test / Holm-Korrektur). Die binary_id-Reinheit ist dabei tragend: Tags/Compiler/ISA/OS erscheinen nur als Ordner/Sidecar/Spalten, nie in der Identität. Ein Planer-Skelett für den XML→CSV/TikZ-Durchlauf (parse→validate→run→Auswertung) existiert bereits und wird als offizielle Phase-0 reaktiviert statt neu gebaut.

## 12. Der Beweis-Maßstab: golden und die Heuristik-Kurven

**golden N = 2^17 = 131072** = alle 17 Organ-Achsen gleichzeitig mit je 2 Werten variiert = der **einzige legitime Ganz-System-Beweis** (CRC64-verankert, Anker `0xF1C1F26A1232073B`). **new-golden ist Bau-Pflicht.** golden-320 ist nur eine Byte-Wache (13/17 gepinnt) und dient als Zwischen-Messdatensatz zur Deadline sowie als Alt-Referenz-Anker neben dem 2^17-Anker.

*Welche 2 Werte je Achse?* Der Haupt-Lauf nimmt die ersten zwei (fixture-verankert); als optionaler, GO-pflichtiger Fork existiert die **Max-Kontrast-Selektion** (die zwei am weitesten auseinanderliegenden Werte) — sie liefert die maximale Wirkungs-Spannweite und damit die besten Stützstellen für die **Heuristik-Kurven**. 2^17 ist dabei nur einer von vier Sweep-Stützpunkten {2^14, 2^17, 2^20, 2^23}, über die die Heuristik-Kurven kalibriert werden. Der Voll-Messlauf ist mehrtägig und hart USER-GO-gegated.

## 13. Das Hybrid-Binary und die Break-Even-Auswertung

Aus den realen Messkurven baut das **Hybrid-Binary** (4. Ketten-Glied, Abgabe-Pflicht) rückwärts die optimalen Algorithmen-Sätze: es passt je Achse eine Spline-Funktion an die Messstützstellen an und wählt per **Break-Even** (den Schnittpunkten der Kurven) den jeweils besten Algorithmus. Drei Break-Even-Mechaniken sind vorgesehen:
1. **Option 1 (limitiert):** heuristik-erkannte Algorithmen als `std::variant` *direkt in dieselbe* Hybrid-Tier-Binary — aber **nur** als dynamischer Träger für abweichende Unter-Prüf-Dock-Verträge, eingebunden per Abstract-Factory; die Haupt-Observer-Kommunikation bleibt statisch.
2. **Option 2 (Zwischenform):** ganze Tier-Binaries hot ans Dock — reaktivierbar, falls 1/3 bei komplexen Multi-Break-Even-Übergängen nicht ausreichen.
3. **Option 3:** ein Array multipler Tier-Binaries an multiplen Docks mit einer Memory-**Verdrängungs-Strategie** (Speicher-Heuristiken).

Für eine ehrliche Auswertung gilt: **Paper-/SOTA-Algorithmen müssen real gemessen werden** (nie als Spiegel geführt); eine Alt-vs-new-Referenzkurve darf nicht vorschnell getilgt werden (Vergleichsbasis für Break-Even). Ein `objective_tag` + Pareto-Front kann die Break-Even-Bildung steuern. Die Selektion, *welche* (Hybrid-)Tier-Binaries gebaut werden, läuft über eine benannte Chain-of-Responsibility-Filterkette auf dem Resolver (Registry-ANGEBOT gegen Anwender-XML).

## 14. Die Metaprogrammierungs-Doktrin

Alles auf dem Hot-Path ist **compile-time**: CRTP + Concepts, **kein vtable, kein Runtime-Switch, kein `std::variant`** — mit einer einzigen, eng begrenzten Ausnahme im Hybrid: `std::variant` dient dort *ausschließlich* als dynamischer Träger für abweichende **Unter-Prüf-Dock-Typen/-Verträge**, eingebunden per **Abstract-Factory-Methode**; die Haupt-Observer-Kommunikation bleibt statisch (`IObservableTier`). Nur benannte Lehrbuch-Patterns; statischer Dispatch; zero-cost. Interne Templates sind erlaubt, aber die äußeren Produkt-Interfaces sind binär-stabil. Fehlerklassen sind Pflicht über alle Achsen → Unter-Achsen → Algorithmen (Compiler-Compiler-Fehler vs. Infra-Fehler disjunkt); der Planer kennt Klassen, statt hart abzubrechen.

## 15. Storage und Caching

Die gebauten Binaries und Sidecars werden inkrementell zwischengespeichert (Voraussetzung für den 2^17-Voll-Lauf), mit Versionierungs-Stempeln im Cache-Key für chirurgische Invalidierung. Die **asynchrone Erstellung/Upload der Binary-Artefakte auf den MinIO-Store ist freigegeben und Pflicht** (Bau-Durchsatz). Der **git-Push und der Mess-Rückschrieb-Sink bleiben dagegen synchron/blockierend** (Storage-Naht-Doktrin: I/O-Contention während der Messung verfälscht Messwerte). Ebene B = dev-MinIO, Ebene C = prod-NFS. Eine Allokator-Messung muss fair und isoliert sein (kein Cross-Arena-/Heap-Crossover — der Grund, warum der Host-Export-Ansatz verworfen wurde und die DLL ihren Allokator selbst linkt).

## 16. Konformitäts-Stand (S0-Audit)

Ein Audit gegen die früher falsch-zusammengezogene Architektur zeigt: die Grundlage ist **weitgehend sauber**. Literal belegt: kein `genus`-Enumerator in `AxisKind` (T1/T4), der Organ-only-Guard für die binary_id greift (T3), die Legende trennt Tier-Build und Measurement sauber (T6). Die Meta-Meta-Command-/Zwei-Schicht-Struktur (T5/T7) ist eine **Lücke, kein Verstoß** (S10-Bauziel). Die einzige echte Residue ist die Mess-Tooling-Auffächerung (T2, `plan_legend.hpp`), die ohnehin als §47/S4-Umbau geplant ist. Der Rest ist Doku-Kommentar-Nachzug (nie löschen, nur additiv).

---

## Auf einen Nenner

**Ein XML definiert ein Experiment. Der Planer plant es und emittiert die Kette. Der CEB backt die statischen Haupt-Eigenschaften — freigegebene System-Achsen und Mess-Tooling — in Tier-Binaries ein, deren Identität (binary_id) rein aus den 17 Organ-Achsen entsteht, während die freigegebenen System-Achsen mitkompiliert und gestempelt werden. Die dynamischen Unter-Achsen werden je Stufe an die nächste delegiert. System-Achsen geben den Raum frei, Organe setzen ihn durch; welche freigegeben sind, entscheiden Meta-Meta-Achsen per Command-Pattern je nach Maschine — die Achsen-Zahl wächst dynamisch, compile-time-permutiert in zwei Schichten (Existenz und Wert). „Gattung" ist dabei nie eine Achse, sondern die einheitliche Interface-Hülle, die eine Tier-Binary nach außen trägt; Achsen sind nach Typ (Organ/System/Mess) organisiert, mit je einem eigenen Permutations-Baum. Gebaut wird `tier:build:[a,b,c][d,e,f]:chunk<k>` (Mess-HAUPT × System-HAUPT × gebündelter Organ-chunk); gemessen wird getrennt und gegatet über `measure:[a,b,c][d,e,f][g,h,i]` mit den Mess-Unter-Achsen. Alles compile-time-statisch und zero-cost, bewiesen gegen einen golden-Lauf über alle 17 Organe (2^17), der zugleich eine Stützstelle der Heuristik-Kurven ist. Aus den realen Messkurven — inklusive echt gemessener Paper-/SOTA-Vergleiche — baut schließlich das Hybrid-Binary rückwärts die optimalen Algorithmen-Sätze über Break-Even-Schnittpunkte; dafür bleibt die Break-Even-Auswertung fester Bestandteil des Plans.**
