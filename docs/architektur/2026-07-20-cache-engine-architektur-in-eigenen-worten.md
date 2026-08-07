# Die Cache-Engine-Architektur in eigenen Worten (Stand 2026-07-20, überarbeitet)

> Reiche finale Gesamtsicht des Systems, wie ich (Fable, als Architekt) es verstehe — auf Wunsch des Autors als eigenständiges Architektur-Dokument abgelegt und nach Abschluss der Konsolidierungs-Workflows **komplett überarbeitet**. Terminologie durchgängig nach den User-bestätigten Sätzen **§54-T1-T7** (Ledger); Auswertungs-Tiefe angereichert aus dem konsolidierten TODO-Block **§55** und der Erinnerungs-Sammlung wiederverwendbarer Konzepte. Bei Konflikt mit älterem Vokabular gilt dieses Dokument bzw. §54/§55. Kein Ersatz für die Primärquelle (LaTeX-Design + Ledger), sondern eine kohärente Gesamtsicht.
>
> **UPDATE-VERWEIS (2026-07-22):** Der Abschnitt **„UPDATE 2026-07-22"** am Ende konsolidiert dieses Dokument mit den seither vom Autor gesetzten Gesetzen **§61 (Modi/Stufen/Dual-Compile/Compile-Stempel)**, **§62 (Multi-Maschinen-Architektur A–H)** und **§63 (Arbeitsmodus)** — auf User-Anweisung in meinen exakten Worten aus der Drei-Zeitschnitte-Beschreibung. Bei Konflikt mit den Abschnitten 1–17 gilt das Update. Status-/Zeitschnitt-Anteile derselben Beschreibung liegen bewusst NICHT hier, sondern in `docs/sessions/20260722-SESSION-STATUS-drei-zeitschnitte.md`.

> ---
>
> ## ⚠️ STAND 2026-08-07: DER CRC64-ANKER IST GEWANDERT -- UND EINE ZUSAGE HIER WURDE GEBROCHEN
>
> **Die Gesamtsicht traegt weiter. Drei Zahlen und zwei Statusaussagen nicht.** Der schaerfste
> Befund betrifft eine Zusage, die dieses Dokument macht. Belege gegen ce `ba069e38` (identisch in
> `ab0b352e`).
>
> ### Der CRC64-Anker
>
> `:123` und `:189` nennen `0xF1C1F26A1232073B` und sagen zu, der ce-only-golden bleibe
> **„byte-identisch"**. **Genau das ist gebrochen worden.** Ist heute:
>
> ```
> kNewGolden131072Crc64 = 0x56F1B721C72DC10E     (profile_facade/source_catalog.hpp:190)
> ```
>
> Der alte Wert steht im Code noch -- als dokumentierter `[MISMATCH]`
> (`source_catalog.hpp:187`), samt Begruendung `:183-188`: der Bruch geschah mit STRUKT-R ORG-18
> unter Owner-GO vom 26.07., als `persistence_target` als 18. Organ-Achse einzog. **Der alte Anker
> ist laut Code „nicht mehr reproduzierbar".** Wer die Zusage `:189` heute liest und gegen den alten
> Wert prueft, meldet einen Regressionsverdacht, wo eine bewusste Entscheidung steht.
>
> ### Die Achsenliste ist unvollstaendig -- es fehlt genau die Achse, die den CRC brach
>
> `:61`, `:63`, `:84`, `:123`, `:213` sprechen von den **„17 Organ-Achsen"**. Ist: **18 Slots**
> (`anatomy/composition_factory.hpp:104`; `builder/experiment_tree/axis_path_serialization.hpp:40`).
> Die Namensliste `:84` endet bei `queuing_q1/q2` -- **`persistence_target` (L17) fehlt vollstaendig**
> (`profile_facade/source_catalog.hpp:120`).
>
> **Die Zahl 2^17 = 131.072 bleibt dennoch korrekt** (`:123`), weil L17 auf K17 = 1 gepinnt ist
> (`source_catalog.hpp:139` und `:130-138`). Nur die Begruendung „17 Achsen je 2" ist es nicht:
> es sind 18 Slots, von denen 17 variieren.
>
> ### Weitere Korrekturen
>
> | Zeile | steht im Dokument | Ist heute | Beleg (ce) |
> |---|---|---|---|
> | `:24` | „**Planer** … Existiert als Executable **noch nicht** — der **groesste offene Bau-Block**" | **VOLLZOGEN.** Eigene Binary, wird gebaut und installiert | `apps/experiment_planner/CMakeLists.txt:13` |
> | `:108` | „**Set / Sequence / Adapter / View** sind bisher **Skelette (je nur 1 Organ getrieben)**; ihre Vervollstaendigung ist der **letzte, grosse ABI-Schritt**" | **Der ABI-Schritt ist gegangen** (E-24 C8, 04.08., MAJOR 7→8). Die vier Gattungen haben eigene benannte Wire-Formen; „je 1 Organ getrieben" stimmt nur noch fuer Set (1), Sequence hat 2, View hat 2 | `abi/anatomy_module_abi_v1_decl.hpp:65`; `anatomy/set_abi_adapter.hpp:84`, `sequence_abi_adapter.hpp:74`, `view_abi_adapter.hpp:65` |
> | `:108` | „**SearchAlgorithm** ist voll ausgebaut — **17 Achsen**" | **18** Organ-Achsen; ausserdem heisst die **Gattung** (Ebene 1) seit E-24 C7-1 **`Map`**, nicht SearchAlgorithm -- das **Genus** (Ebene 2) heisst weiterhin so | `composition_factory.hpp:104`; `anatomy/anatomy_base.hpp:49-57` |
> | `:123` | „golden-320 ist nur eine Byte-Wache (**13/17 gepinnt**)" | **14 von 18** gepinnt (variiert werden search_algo 4, node_type 4, memory_layout 5, prefetch 4). Produkt 320 bleibt korrekt | `source_catalog.hpp:144`, `static_assert :172` |
> | `:99` | „*Ist-Code-Regress:* `plan_legend.hpp:109` emittiert heute noch `[a,b,c][d,e,f]:chunk<k>` — Fix als **GO-pflichtiger TODO**" | **DOPPELT ueberholt.** (1) Der Regress ist geheilt: emittiert wird `tier:build:[d,e,f][g,h,i]:chunk<k>` (`plan_legend.hpp:19`). (2) Die per-chunk-Einzeljobs sind seit §62-B (23.07.) **deprecated** zugunsten je-Host-Batches (`:124-129`) | ebd. |
> | `:92`, `:148` | „*Konformitaets-Residue:* `plan_legend.hpp` faechert `[a,b,c]` **heute noch aus `measurement_categories`** auf — **die einzige echte Residue**" | **GEHEILT.** `[a,b,c]` ist heute die Mess-Tooling-KONFIG; der Header schliesst die alte Auffaecherung ausdruecklich aus | `plan_legend.hpp:86-89`, `:95` |
>
> **ABI-Anker fehlt ganz:** das Dokument argumentiert durchgehend ueber ABI-Stabilitaet
> (`:108` „der letzte, grosse ABI-Schritt"), nennt aber **keine einzige Versionszahl**. Zum
> Nachtragen: ABI-MAJOR **8**, MINOR **0** (`abi/anatomy_module_abi_v1_decl.hpp:89-90`),
> `fingerprint_format=4` (`abi/anatomy_fingerprint.hpp:106`).
>
> **Weiterhin korrekt (nicht anfassen):** `:123` der Wert 2^17 = 131.072 und die Aussage, golden-320
> sei nur eine Byte-Wache · `:48` „`AxisKind = {organ, system_measurement, system_config}` — es gibt
> **keinen `genus`-Enumerator**" (literal bestaetigt, `topics/axis.hpp:17-20`) · `:63` der
> strukturelle Guard, dass nur Organ-Achsen binary_id-Ebenen bilden · `:90` die **16**
> `measurement_categories` · `:165` `pruefling_merge.hpp` / `sota_catalog.hpp` ·
> `:187` die drei Legenden-Formen.
>
> **Ungeprueft:** `:13`, `:181` die Groessenordnungs-Angaben (10^14 / „137 Billionen") -- nicht
> nachgerechnet. `:201` die beiden „neuen" System-Haupt-Achsen RAM-Frequenz und CAS-Latenz sowie
> CPU-Fabrikation (#49) -- Bau-Status nicht geprueft. Beachte dazu: es gibt heute **drei**
> System-Haupt-Achsen (`abi/system_axis_order.hpp:37`).
>
> ---

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
- **CEB** = **`CacheEngineBuilder`** (kanonische Applikations-Bezeichnung, so in allen Dokumenten) — die **Builder-Applikation des Cache-Engine-Mess-Frameworks**, die vom **Anwender (der Diplomarbeit / PRT-ART)** gerufen wird. Sie kompiliert die eigentlichen Tier-Binaries, bekommt die **System**-Eigenschaften fest eingebacken und emittiert selbst die Tier-Stufe.
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

**Zwei Stempel-Ebenen und die Compile/Runtime-Grenze (§57):** Der Planer baut je Mess-Tooling-Wahl eine CEB; die **CEB trägt ihren eigenen Typ+Versions-Stempel = die Mess-Achse** (die Mess-Achse ist an der CEB fest einkompiliert, bis auf die dynamischen Unter-Achsen-Variablen des Planers). An der CEB sind **System-Achse und Organ-Achse noch *runtime*** — die CEB hält sie als Bau-Raum und baut zu *ihrer* Laufzeit die *compile-time* Tier-Binaries. Jede Tier-Binary trägt dann ihren eigenen Typ+Versions-Stempel = **System × Organ**. Es gibt also **zwei Stempel-Ebenen: CEB = Mess, Tier = System × Organ** — während die `binary_id` (die Permutations-Identität) Organ-only bleibt. Präziser (§58): der **Planer** trägt *einen* Stempel `X.Y.Z`; der **CEB**-Stempel ist ein **Array je Mess-Haupt-Algorithmus** `[Xa.Ya.Za, Xb.Yb.Zb, Xc.Yc.Zc]` (keine CEB-Gesamt-Version); die **Tier-Binary** trägt **zwei separate Arrays** — je eines für die System-Achse und die Organ-Achse (keine Gesamt-Version). Alle Binary-Stempel tragen **nur Haupt-Achsen**; die **Unter-Achsen sind dynamische Laufzeit-Parameter**, die durch die Binary hindurchfließen und **nicht gestempelt** werden. Erst die **Mess-CSV** trägt den **voll-permutativen Stempel** — alle Haupt- *und* Unter-Achsen als Kurzform-Legende mit Versionierung je Achse (`Xa[Unter-k, Unter-l, …]`), in CSV-Benennung und Spalten —, der ein Messergebnis (Mess × System × Organ inkl. aller Unter-Achsen) **eindeutig zuordbar** macht. Auch die Chunks sind zweistufig: der **CEB-chunk** bündelt den System-Achsen-Freigabe-*Erlaubnis*-chunk + den Organ-Achsen-*tobecompiled*-chunk; der **Tier-chunk** bündelt den System-Achsen-Freigabe-*Durchführung*-chunk + den Organ-Achsen-chunk (kompiliert).

Das **Freigabe-Prinzip** (Organ ≤ System) lebt bereits im Code, am schönsten am Beispiel Huge Pages: die **Hardware** deklariert die Fähigkeit (`huge_page_capable()` = Raum frei), das **Allokator-Organ** setzt via `AllocPageHint` durch, compile-time-gegated auf die Fähigkeit. Die System-Achse gibt frei, das Organ wählt. Genauso gibt die **ISA** frei, welche Organe überhaupt baubar sind.

> **KORREKTUR-VERWEIS 05.08.2026:** Dieses Bild ("System gibt frei, Organ setzt durch") ist NUR die System-Stufe-1-/Zulaessigkeits-Ebene und bleibt dort korrekt. Die vollstaendige, Owner-abgenommene **Stufen-Doktrin** (Mess=3-stufig dehnbar, System=2-stufig dehnbar, Organ=2-stufig hybrid-unberuehrt, Hybrid=Factory-Facade-Adapter) siehe Vermerk am Freigabe-Gesetz im U-Teil unten bzw. LEDGER Nachtraege 05.08. mittag-9/-10.

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

Der Planer emittiert eine Child-Pipeline, die sich selbst weiter emittiert. Der Vertrag (§54-T6-KORRIGIERT; die drei Legenden-Gruppen sind **[a,b,c] = Mess-Achse · [d,e,f] = System-Achse · [g,h,i] = Organ-Achse**):

- **Stufe 1 (Planer → CEB, Mess-Achsen-Stufe):** `ceb:build:[a,b,c]` → `ceb:emit:[a,b,c]` (`--emit-tier-ci`) → `ceb:trigger:[a,b,c]`. **[a,b,c] = Mess-Achse (Mess-Tooling): sie baut NUR die CEB auf und delegiert sie; die CEB ist die statische Repräsentative der Mess-Achse.**
- **Stufe 2 (CEB → Tier, System-Achsen-Stufe) — der Tier-Build-Array:** `tier:build:[d,e,f][g,h,i]` = **[d,e,f] System-Achse × [g,h,i] Organ-Achse**. Die CEB (mit ihrer statisch mitgegebenen Mess-Repräsentation) baut die Tier-Binaries. **Die Mess-Achse `[a,b,c]` gehört NICHT in die Tier-Build-Legende — sie IST die CEB.** Der `:chunk<k>` bündelt das kombinierte **System-Freigabe-Durchführung × Organ**-Bau-Volumen (§57; nicht rein den Organ-Slot), nie den Mess-Slot. *(Ist-Code-Regress: `plan_legend.hpp:109` emittiert heute noch `[a,b,c][d,e,f]:chunk<k>` statt `[d,e,f][g,h,i]` — Fix als GO-pflichtiger TODO, s. Ledger §56.)*
- **Measurement ist EXTRA** — ein **separater, gegateter Job**: `measure:[a,b,c][d,e,f][g,h,i]` = **Mess × System × Organ, komplett durchgemessen** (`[a,b,c]` = Mess-Repräsentation der CEB, `[d,e,f]` = System, `[g,h,i]` = Organ). **`when: manual`**, GN-11/320er-gegatet. Nur **eine** CEB misst gleichzeitig (Mess-Exklusivität), während der Bau parallel laufen darf. Die Mess-Unter-Achsen {Ablaufmethodik · Workloads/Datasets · categories · Rückschrieb-Methoden} manifestieren sich als CSV-Spalten — sie sind **keine dritte Legenden-Gruppe**.

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

Am Ende steht das Forschungsziel aus §62-H (→ Update-Abschnitt): optimale Binaries für maximal ausgeschöpfte Hardware-Rekombinationen, um das **Cache-Line-Verhalten in allen permutativen Facetten** zu untersuchen — mit Break-Even-Splines je Achse, Hybrid-Tier-Binaries und dem Release-Wallclock-Beweis (beste Release-Binary vs. beste Debug-Overhead-Version vs. schlechteste XML-Variante) als Projekt-Schlussstein.

## 14. Die Metaprogrammierungs-Doktrin

Alles auf dem Hot-Path ist **compile-time**: CRTP + Concepts, **kein vtable, kein Runtime-Switch, kein `std::variant`** — mit einer einzigen, eng begrenzten Ausnahme im Hybrid: `std::variant` dient dort *ausschließlich* als dynamischer Träger für abweichende **Unter-Prüf-Dock-Typen/-Verträge**, eingebunden per **Abstract-Factory-Methode**; die Haupt-Observer-Kommunikation bleibt statisch (`IObservableTier`). Nur benannte Lehrbuch-Patterns; statischer Dispatch; zero-cost. Interne Templates sind erlaubt, aber die äußeren Produkt-Interfaces sind binär-stabil. Fehlerklassen sind Pflicht über alle Achsen → Unter-Achsen → Algorithmen (Compiler-Compiler-Fehler vs. Infra-Fehler disjunkt); der Planer kennt Klassen, statt hart abzubrechen.

## 15. Storage und Caching

Die gebauten Binaries und Sidecars werden inkrementell zwischengespeichert (Voraussetzung für den 2^17-Voll-Lauf), mit Versionierungs-Stempeln im Cache-Key für chirurgische Invalidierung. **Caching-Replay (§58):** Fordert man vom Planer eine Messung an, sucht er zuerst, ob sie (per voll-permutativem CSV-Stempel) schon existiert, und gibt sie als **Replay** zurück; sonst stößt er den ganzen Vorgang an, die fehlenden Messungen zu materialisieren — eine Erweiterung des Lazy-Materialisierungs-Verfahrens mit erweitertem Caching. **Asynchron in `minio.comdare.de`** gespeichert werden die **versionierte Planer-Binary, die CEBs, die Tier-Binaries *und* die CSV-Messergebnisse** (Cache-Kopie, Bau-/Mess-Durchsatz). Der **git-Push und der Mess-Rückschrieb-Sink (nach development) bleiben dagegen synchron/blockierend** (Storage-Naht-Doktrin: I/O-Contention während der Messung verfälscht Messwerte; die MinIO-Kopie ist die asynchrone Cache-Ebene, nicht der synchrone Mess-Sink). Ebene B = dev-MinIO, Ebene C = prod-NFS. Eine Allokator-Messung muss fair und isoliert sein (kein Cross-Arena-/Heap-Crossover — der Grund, warum der Host-Export-Ansatz verworfen wurde und die DLL ihren Allokator selbst linkt).

## 16. Konformitäts-Stand (S0-Audit)

Ein Audit gegen die früher falsch-zusammengezogene Architektur zeigt: die Grundlage ist **weitgehend sauber**. Literal belegt: kein `genus`-Enumerator in `AxisKind` (T1/T4), der Organ-only-Guard für die binary_id greift (T3), die Legende trennt Tier-Build und Measurement sauber (T6). Die Meta-Meta-Command-/Zwei-Schicht-Struktur (T5/T7) ist eine **Lücke, kein Verstoß** (S10-Bauziel). Die einzige echte Residue ist die Mess-Tooling-Auffächerung (T2, `plan_legend.hpp`), die ohnehin als §47/S4-Umbau geplant ist. Der Rest ist Doku-Kommentar-Nachzug (nie löschen, nur additiv).

## 17. Der KERN: die Mess-Schema-Steuerung (§59)

Wenn Abschnitt 1 sagt, das eigentliche Experiment *ist die XML*, dann ist **dieser** Abschnitt der Kern davon: die **Mess-Schema-Steuerung** ist nicht ein Feature unter vielen, sondern das eigentliche Herz der Arbeit (§59; vom Autor als „schon immer Gesetz" bezeichnet, Abweichung = Regression). Sie beantwortet die Frage, *was* eine XML überhaupt in Auftrag geben kann.

**Default ist: alles messen.** Die Whitelist ist der volle Raum — alle Achsen, alle Einstellungen, alle geladenen Prüflinge. Die XML wirkt darauf als **negatives Blacklisting**: sie gibt nur Teilbereiche frei bzw. schränkt ein. Man definiert ein Experiment also nicht, indem man Dinge einschaltet, sondern indem man aus dem Vollen herausschneidet.

**Die drei Mess-Stufen.** Ein Experiment läuft in bis zu drei Stufen, und der Begriff „Prüfling" (ein Fremd-/SOTA-Algorithmus-Satz, z.B. PRT-ART, perspektivisch ein Paper) ist dabei zentral:
1. **CE allein** — die reine Cache-Engine, permutativ über alle freigegebenen Achsen.
2. **Je Prüfling, direkt danach** — Default **`replace`**: die Prüfling-Achsen ersetzen die CE-Achsen komplett (die Sicht „nur der Prüfling"); alternativ **`merge`**: ein CE+Prüfling-Hybrid je Prüfling.
3. **Kombiniert = `fulljoin` je Achse** — der volle Kreuz-Join CE × Prüfling, der nichts verwirft.

**Was die XML im Detail steuert:** die Messmodi (welche Stufen laufen); pro Achse `merge` vs. `replace` (alle oder nur bestimmte Achsen); *welcher* Prüfling (ein Variablenname oder statisch `"CacheEngine"` = der explizite Prüfling `identity="self"`); pro Achse eine Algorithmus-Whitelist; und alternativ das Laden eines **Templates** (eines Research-Gesamtalgorithmus) mit je Achse `restrict`/`extend` — heute als `mode=full`, das benannte `<template>`-Element kommt additiv (post-v3). `extend` ist erlaubt, aber die Obergrenze bleibt das Registry-**Angebot**.

**Der Weg Planer → CEB.** Der Planer parst die XML; die CEB *versteht* sie dann je Achse. Der Trick ist die Ebenen-Trennung: die **Haupt-Achsen sind statisch per Metaprogrammierung in die CEB einkompiliert** — der Interpreter je Haupt-Achse ist fix —, und die **CEB-Laufzeit** (vom Planer orchestriert) treibt daraus den Tier-Emit. Die XML variiert also nicht den Interpreter, sondern nur, welche Schnitte er durch den fest einkompilierten Raum fährt.

**Das ist keine neue Maschine, sondern eine Verallgemeinerung.** Der schöne Befund aus dem CoreSchema-Audit: die 3-Stufen-Merge-Mechanik existiert im Ist-Code bereits compile-time und per-Achse (`pruefling_merge.hpp` `MergeAxis`). Sie ist heute nur **katalog-verdrahtet auf genau einen hart-codierten Prüfling** (`prt_art`) und **einen Slot** (`path_compression`) via `sota_catalog.hpp`. Der KERN generalisiert das auf beliebige Prüflinge, per-Achse, XML-gesteuert — **Umverdrahtung + Schema, kein Neubau.**

**id-Satz, Stempel und Storage.** Jeder Prüfling-Merge bildet einen **eigenen id-Satz**: die Tier-Binaries werden zusammen mit allen Mess-Artefakten dem Prüfling zugeführt und gespeichert; je Merge-/Join-Art entsteht eine eigene Mess-Kategorie, die mit-gecacht wird. Gespeichert wird in einem Unterordner unter root **lokal (Default)** oder per XML in `minio.comdare.de`. Beim Stempel kommt zu den zwei §58-Arrays der Tier-Binary (System-Array, Organ-Array) ein **dritter Tier-Binary-Stempel = die Merge-Kombination** hinzu (Namen + Versionen aller beteiligten Achsen-Algorithmen, Haupt-Achsen-only). Entscheidend für die Verifikation: der ce-only-golden `0xF1C1F26A1232073B` bleibt **byte-identisch** — die Merges sind ein rein additiver id-Satz, der Identitäts-Pfad bleibt byte-gleich.

**Anatomie als Stempel-Vorlage.** Die Anatomie (Abschnitt 10) ist zugleich die **Stempel-Vorlage**: die Rekombination aller Achsen, aus der jede Stufe (Planer/CEB/Tier) ihren stufen-eigenen Achsen-Satz stempelt. Das Mess-Tooling {Wallclock/Makro/Micro} ist dabei eine **Unter-Achse, compile-time fix in CEB und Tier** eingebacken; das scharfe Zusammenschalten mehrerer Tooling-Wahlen (N>1) kommt erst mit dem 320er-Lauf (S6). Und der Prüfling-Begriff trägt weit: perspektivisch ist ein **Paper selbst ein Prüfling** (CE- und PRT-ART-Registry führen dann echte Template-Profile je Paper) — das ist die post-v3-Ausbaustufe der Idee, dass ein Experiment allein durch die XML definiert wird.

**Bau-Weg (§59, K1-K8).** KERN-A {Schema+Parser · XSD · validate · Director/Projektion · Auto-Phasen} ist golden-neutral; KERN-B {Emitter katalog→direktiven-getrieben · Merge-Stempel-POD} liegt im golden-Fenster (POD wächst 56→72, `binary_id`/CRC bleiben unberührt); §58-Array-Umbau + Storage sind Post-Abgabe/Caching. golden-gated ist allein die Verifikation S2/A1.

---

## UPDATE 2026-07-22 — Konsolidierung mit §61/§62/§63 (in meinen exakten Worten)

> Auf User-Anweisung 22.07. exakt übernommen aus meiner Drei-Zeitschnitte-Beschreibung (Architektur-Anteile; die Status-Anteile stehen im Session-Doc). Dieser Abschnitt schreibt die Abschnitte 2, 3, 6, 9, 15 und „Auf einen Nenner" fort.

### U1. Das Fundament, präzisiert (schreibt Abschnitte 2/3/6/9 fort)

Der Name „Cache-Engine" führt in die Irre: Das eigentliche Artefakt ist **das Experiment, und das Experiment ist die XML**. Der gesamte C++-Apparat ist die Maschinerie, die eine XML-Definition in messbare Binaries übersetzt. Der Permutationsraum (~137 Billionen Tier-Binaries) wird nie materialisiert — man fährt gezielte Schnitte.

Die **dreistufige Binary-Kette** bildet die drei Achsen-**Typen** ab (Achsen sind Typen — Mess, System, Organ; „Gattung" bezeichnet dagegen ausschließlich das Tier-Binary-*Interface* wie SearchAlgorithm/Set/Sequence/Adapter/View):

- Der **Planer** trägt die Mess-Achsen `[a,b,c]`. Haupt-Achse ist das **Mess-Tooling** (Wallclock/Makro/Micro — fest einkompiliert), Unter-Achse die **Ablaufmethodik** (Debug/Messung/Release, **plus künftig Compare**). Der Planer baut je Mess-Konfiguration eine CEB und delegiert — die Mess-Achse gehört *nie* in die Tier-Build-Legende.
- Die **CEB (CacheEngineBuilder)** ist das statische Kompilat ihrer Mess-Achse (Stempel = Mess-Array). In ihrem Realm sind System- und Organ-Achse noch *Laufzeit*: Sie hält den Bau-Raum als System-Freigabe-*Erlaubnis* plus Organ-*tobecompiled* und baut zu ihrer Laufzeit die Tier-Binaries.
- Die **Tier-Binary** trägt System `[d,e,f]` und Organ `[g,h,i]` **beide fest einkompiliert, aber als getrennte Dimensionen** mit zwei getrennten Versions-Arrays — plus dem dritten Stempel für die Merge-Kombination (KERN §59) und **seit §61 dem Compile-Einstellungs-Stempel** (`+bt=Debug` als Nicht-Default-Suffix). Legenden: `ceb:build:[a,b,c]` / `tier:build:[d,e,f][g,h,i]:chunk<k>` / `measure:[a,b,c][d,e,f][g,h,i]`.

Quer dazu liegen die unveränderten Gesetze: **Haupt = compile-time, Unter = runtime** an jedem der drei Vertragspunkte; das **Freigabe-Prinzip** (System-Achsen geben Hardware frei, Organ-Achsen setzen sie durch, Organ-Nutzung ≤ System-Freigabe), inklusive **Meta-Meta-Achsen** (das Hardware-Erweiterungs-Array, dessen Existenz die Hardware-Haupt-Achse selbst per zweischichtiger Kern-Permutation an/aus permutiert, Freigabe per Command-Pattern); und der **KERN §59** (XML = negatives Blacklisting, drei Stufen CE-allein → je Prüfling replace/merge → kombiniert-fulljoin, per-Achse-Whitelist, benanntes `<template>`, eigener id-Satz je Prüfling-Merge). Der Beweis-Maßstab bleibt: **golden-320 ist nur Byte-Wache** (CRC64 `0xF1C1F26A1232073B`), der legitime Systembeweis ist die 2^17-Voll-Konfiguration.

> **KORREKTUR-VERWEIS 05.08.2026 (Stufen-Doktrin-Konsolidierung; LEDGER Nachtraege mittag-9/-10, Owner-abgenommen mittag-11):** Das oben als "Freigabe-Prinzip"-Gesetz zitierte "System-Achsen geben Hardware frei, Organ-Achsen setzen sie durch" ist NUR die System-Stufe-1-/Zulaessigkeits-Ebene, nicht DAS Freigabe-Gesetz der Gesamtarchitektur. Kanonische Stufen-Doktrin: **MESS-Achsen = DREISTUFIG DEHNBAR** Planer(Stufe 1: RT-Freigabe) -> CEB(CT-Einbau: Mess-Design + Pruefdock-Konfiguration) -> [Hybrid(CT)] -> Tier(CT: Observer/Ausstattung) · **SYSTEM-Achsen = ZWEISTUFIG DEHNBAR** CEB(RT-Freigabe HW) -> [Hybrid(CT): gibt sich selbst + seinen Tiers die System-Config CT mit] -> Tier(CT) · **ORGAN-Achsen = ZWEISTUFIG, hybrid-unberuehrt**, NUR in Tier-Binaries verbaut (CEB-RT-Freigabe der lazy Permutations-Wahl -> Tier-CT) · **GESETZ:** Stufe 1 IMMER Runtime-Freigabe in der Traeger-Binary, alle Folgestufen Compile-Time-Einbau entlang Planer->CEB->Tier · **HYBRID = Factory-Pattern-Facade-Adapter** (organ-frei, erbt als eingeschobene 4. Stufe ALLE Eigenschaften, reicht Mess- UND System-Eigenschaften CT weiter; traegt Mess+System-Stempel, KEINE Organ-Identitaet — binary_id bleibt Organ-only bei echten Tiers). Die Mess-Achsen GEBEN also ebenfalls frei (das CEB-Mess-Design), nicht nur die System-Achsen.

### U2. §61 — Modi, Stufen, Dual-Compile (NEU gegenüber Abschnitten 3/8)

Die Ablaufmethodik ist zur vollen Modi-Maschine ausgewachsen: **Debug** = Multi-Maschine, je Maschine parallel bauen + parallel messen; **Messung** = Multi-Maschine, parallel bauen + sequentiell messen (sequentiell heißt IMMER nur das Messen, nie der Bau); **Release** = System-Achsen-korrekte Maschine, Auslieferung ohne Mess-Einrichtung (Observer per Metaprogrammierung abschaltbar) plus Wallclock-Beweis. Die Modi bauen **stufenweise** aufeinander auf (Release braucht die volle Messung samt §58-Replay), und **Debug ist Dual-Compile**: parallel cmake-Debug UND cmake-Release, getestet nur mit den Debug-Binaries — nur die Release-Binaries fließen als Reuse-Masse in Messung/Release weiter. Der Reuse-Schlüssel ist der **Compile-Einstellungs-Stempel** (`+bt` trägt den **cmake-Compile-Typ**, nie den Modus — die Namens-Dopplung „Debug" ist bewusst und bleibt). Die **Modus-Wahl geschieht per XML, genau EIN Modus je Call** (`<run_methodology>` exactly-one, Validator hart auf beiden Ausführungspfaden).

### U3. §62 — Wie sie sein soll: die Multi-Maschinen-Architektur (NEU; schreibt Abschnitt 15 fort)

Das Zielbild dreht die Maschinen-Logik um: **Der Planer ist anspruchslos.** Jede Maschine — lokal oder CI, Dutzende — baut denselben Planer und führt ihn gegen die **eine, für alle identische XML** aus. Es gibt keine Runner-Tag-Vorfilterung mehr (die heutigen amd/intel-Lanes sind ausdrücklich Interim); verlangt die XML physisch nicht existente System-Achsen-Algorithmen, schreibt der Planer *Warnungen* statt still zu filtern. Koordiniert wird ausschließlich über den **Cache auf minio.comdare.de**: eine lockbare Sync-Datei (Compile-Log) mit 3-Stufen-Dedup (Planer/CEB/Tier — nichts wird je doppelt gebaut), Batch-Reservierungen als *Versprechen* mit zwingender Release-Pflicht und Fortschritts-Testat je Build (Lease/Timeout für den Absturzfall), und Binary-Sync zwischen allen Maschinen. Symmetrie-Prinzip: prod1 baut und misst alles, was es kann, prod2 ebenso — der live Cache-Sync ist Betriebs-*Voraussetzung*, keine Optimierung.

Die Modi laufen **je Maschine** einzeln, und nach dem Release kommt je Maschine der **vierte Modus COMPARE**, der aus dem Mess-Replay die eigene Sicht mit allen im Cache-Log registrierten Maschinen vergleicht. Die CI ist erst *fertig*, wenn die XML auf jeder vom User gewünschten Maschine exakt für diese Maschine ausgewertet wurde. Replay ist **schichtweise** gekeyt: `[a,b,c]` bestimmt das Replay einer CEB (Planer-Sicht), `[d,e,f]` allein das der Tier-Binaries (CEB-Sicht), Messwerte brauchen `[d,e,f]`×`[g,h,i]` *plus* Hardware-Identität — die eine Äquivalenzklasse modulo ungenutzter Meta-Meta-Achsen ist (GPU/NPU/FPGA zählen nicht zur Kern-Identität, aber einkompilierte Erweiterungen muss die assimilierende Maschine unterstützen). Binary-*Sharing* dagegen ist rein stempel-gekeyt — zwei verschiedene Schlüssel. Dafür kommen zwei **neue statische Haupt-System-Achsen**: RAM-Frequenz + CAS-Latenz (wahre Latenz = CL×2000/MT-Rate) und die exakte CPU-Fabrikation, erhoben per libcpuid/cpu_features/decode-dimms (#49).

Bei ~130.000 Tier-Binaries gilt das **Batch-Job-Prinzip**: Job-Anzahl O(konstant), nie O(Binaries) — der Bau läuft **CEB-intern** als Runtime-Batch, jedes gebaute Tier wird direkt am Prüfdock per **GTest-Prüfstand** auf Interface-Korrektheit getestet (erst Build+Prüf-Batch, dann Messung), die CEB piped den Status an den Planer, und der Planer **instrumentiert** die CEB per XML-Anweisung — das ist der Kern der emit-Vertrags-Kette (#54), die nach der CI-Stabilisierung korrekt aufgebaut wird, flankiert vom .so-ABI-Schnitt statt Textemission (R1/#35) und dem Planer als CLI mit Zustands-Logging (#34).

### U4. Auf einen Nenner (fortgeschrieben 22.07.)

Der Nenner-Absatz unten gilt weiter — mit drei Fortschreibungen: (1) Die Ablaufmethodik ist eine **Vier-Modi-Stufenleiter je Maschine** (Debug-Dual-Compile → Messung → Release → Compare), deren Reuse-Schlüssel der `+bt`-Compile-Stempel ist. (2) Die Maschinen koordinieren sich **nicht über Runner-Tags, sondern über den stempel-gekeyten Cache** (Sync-Datei, Claims, Batch-Jobs, CEB-interner Prüfstand) — eine XML, viele Maschinen, jede aus eigener Sicht, CI fertig erst nach per-Maschine-Auswertung. (3) Replay und Sharing sind **zwei verschiedene Schlüssel** (Hardware-Identität vs. Stempel), und die Hardware-Identität selbst wird über die neuen RAM-/CPU-Fabrikations-Achsen zur messbaren Systemgröße.

---

## Auf einen Nenner

**Ein XML definiert ein Experiment. Der Planer plant es und emittiert die Kette. Der CEB backt die statischen Haupt-Eigenschaften — freigegebene System-Achsen und Mess-Tooling — in Tier-Binaries ein, deren Identität (binary_id) rein aus den 17 Organ-Achsen entsteht, während die freigegebenen System-Achsen mitkompiliert und gestempelt werden. Die dynamischen Unter-Achsen werden je Stufe an die nächste delegiert. System-Achsen geben den Raum frei, Organe setzen ihn durch; welche freigegeben sind, entscheiden Meta-Meta-Achsen per Command-Pattern je nach Maschine — die Achsen-Zahl wächst dynamisch, compile-time-permutiert in zwei Schichten (Existenz und Wert). „Gattung" ist dabei nie eine Achse, sondern die einheitliche Interface-Hülle, die eine Tier-Binary nach außen trägt; Achsen sind nach Typ (Organ/System/Mess) organisiert, mit je einem eigenen Permutations-Baum. Die Mess-Achse baut nur die CEB (`ceb:build:[a,b,c]`) und delegiert sie; die CEB baut die Tier-Binaries über System × Organ (`tier:build:[d,e,f][g,h,i]`); gemessen wird komplett und gegatet über `measure:[a,b,c][d,e,f][g,h,i]` (Mess × System × Organ). Alles compile-time-statisch und zero-cost, bewiesen gegen einen golden-Lauf über alle 17 Organe (2^17), der zugleich eine Stützstelle der Heuristik-Kurven ist. Aus den realen Messkurven — inklusive echt gemessener Paper-/SOTA-Vergleiche — baut schließlich das Hybrid-Binary rückwärts die optimalen Algorithmen-Sätze über Break-Even-Schnittpunkte; dafür bleibt die Break-Even-Auswertung fester Bestandteil des Plans.**
