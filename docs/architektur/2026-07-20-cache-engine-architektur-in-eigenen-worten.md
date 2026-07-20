# Die Cache-Engine-Architektur in eigenen Worten (Stand 2026-07-20)

> Reiche finale Zusammenfassung des Systems, wie ich (Fable, als Architekt) es verstehe — auf Wunsch des Autors als eigenständiges Architektur-Dokument abgelegt. Terminologie durchgängig nach den User-bestätigten Sätzen **§54-T1-T7** (Ledger). Bei Konflikt mit älterem Vokabular gilt dieses Dokument bzw. §54/§55. Kein Ersatz für die Primärquelle (LaTeX-Design + Ledger), sondern eine kohärente Gesamtsicht.

---

## 1. Die Grundidee: eine Experiment-Maschine, kein Cache

Der Name „Cache-Engine" führt in die Irre. Das eigentliche Artefakt dieser Arbeit ist ein **Experiment-System**, und das eigentliche Experiment *ist die XML-Profildefinition*. Der gesamte C++-Apparat ist nur die Maschinerie, die eine XML in messbare Binaries übersetzt und daraus reproduzierbare Messdaten für die Diplomarbeit erzeugt.

Der Permutationsraum aller theoretisch baubaren Tier-Binaries ist astronomisch (Größenordnung 10^14). Er wird **nie voll materialisiert** — man fährt gezielte, XML-definierte Schnitte hindurch. Die zentrale Forschungsleistung ist die **Achsen-Bibliothek**: ein compile-time-permutierbarer Raum aus algorithmischen und System-Eigenschaften, aus dem konkrete Binaries deterministisch erzeugt und gegeneinander vermessen werden.

## 2. Die dreistufige Kette (plus Hybrid)

Das Rückgrat ist eine Kette dreier Binary-Sorten, plus ein viertes, verbindendes Glied:

```
Planer  ─▶  CEB  ─▶  Tier-Binary   (+  Hybrid-Binary)
(Mess)     (System)   (Organ)          (4. Ketten-Glied)
```

- **Planer** — liest die XML, plant *was* gebaut und gemessen wird, und emittiert die untergeordneten Pipelines/Bauplaene. Trägt die **Mess**-Eigenschaften als seine statische Achse.
- **CEB** (Cache-Engine-Builder) — kompiliert die eigentlichen Tier-Binaries und bekommt die **System**-Eigenschaften fest eingebacken.
- **Tier-Binary** — eine konkrete `.so`, ein „Lebewesen" aus **Organen** (den Organ-Achsen). Wird geladen und gemessen.
- **Hybrid-Binary** — das 4. Glied: baut aus realen Messkurven rückwärts die optimalen Algorithmen-Sätze (Break-Even-Auswertung). **Abgabe-Pflicht**; die Break-Even-Auswertung ist und bleibt fester Planbestandteil, weil sie die Hybrid-Tier-Binaries korrekt formt.

## 3. Das durchgehende Prinzip: Haupt vs. Unter (Ketten-Statik, §24)

Ein einziges Prinzip wiederholt sich an *jedem* der drei Vertragspunkte identisch:

- **Haupt-Achse = compile-time-statisch.** Sie wird fest in das Binary einkompiliert; jede Haupt-Wahl erzeugt ein **eigenes** Binary bzw. eine eigene Baustrecke. Sie trägt einen Versionierungs-Stempel.
- **Unter-Achse = dynamisch.** Sie wird an die *nächste* Stufe als Laufzeitparameter **delegiert** — kein eigenes Binary, sondern eine Variable, die zur Laufzeit variiert.

Dasselbe Muster dreimal:

| Vertragspunkt | HAUPT (statisch, eigenes Binary) | UNTER (dynamisch, delegiert) |
|---|---|---|
| **Planer → Mess** | Mess-Tooling {Wallclock / Makro / Micro} | Ablaufmethodik {Debug/Messen/Release} · Workloads/Datasets · measurement_categories · Rückschrieb-Methoden |
| **CEB → System** | statische System-Eigenschaften (ISA/Compiler/Hardware freigegeben) | delegierte System-Eigenschaften |
| **Tier → Organ** | binary_id-bildende Organe | Laufzeit-Ressourcenparameter |

## 4. Achsen sind TYPEN — und „Gattung" ist etwas ganz anderes

Das ist die wichtigste begriffliche Klarstellung (§54-T1):

- **Es gibt KEINE „Achsen-Gattungen".** Achsen sind nach **TYP** organisiert. Es gibt genau drei **Achsen-Typen**: **Organ · System · Mess**.
- **„Gattung" bezeichnet ausschließlich das Tier-Binary-INTERFACE — die Hülle.** Jede Tier-Binary zeigt nach außen, für den Vertrag, immer ein **einheitliches Gattungs-Interface**, das verkörpert, *was* sie ist (ein Suchalgorithmus-Typ, ein Container-Typ, …). Jede Gattung ist ein **einheitliches Basis-Interface**, das per Metaprogrammierung auch für Tier-Typen erweitert werden kann.

Gattung = *Außenschnittstelle* der Binary (SearchAlgorithm/Container/… als Interface-Familien). Achsen-Typ = die *permutierenden Bausteine* dahinter. Diese zwei Ebenen dürfen nie vermischt werden.

## 5. Der Baum ist je Achsen-TYP

Weil die Gattung nur das Interface ist, strukturiert sie den Permutationsraum nicht. Der **Permutations-Baum existiert je Achsen-Typ** (§54-T4): ein Organ-Baum, ein System-Baum, ein Mess-Baum. Innerhalb eines Baums ist jede Achse eine Ebene, jeder Wurzel→Blatt-Pfad eine Konfiguration (Mixed-Radix-Bijektion). `binary_count = ∏ Achsen-Größen`. Der Baum wird nie voll materialisiert; der Planer läuft ihn ab und emittiert nur die gewünschten Schnitte.

## 6. Was wirklich in eine Tier-Binary kompiliert wird (Freigabe-Materialisierung)

Die Freigabe der System-Achsen an die Organ-Achsen ist nicht bloß abstrakt „Raum frei geben", sondern materialisiert (§54-T3):

> **Der einkompilierte Achsen-Satz einer Tier-Binary = die FREIGEGEBENEN System-Achsen ∪ die 17 Organ-Achsen — alle mit Stempel einkompiliert.**

Die `binary_id` ist der **17-Organ-Kern** (die Identität, die eine Tier-Binary von einer anderen unterscheidet). Die freigegebenen System-Achsen sind *zusätzlich* Teil des materialisierten Raums der Binary (gestempelt), gehen aber nicht in die binary_id ein — sie leben im build_version-Sidecar. So bleibt die binary_id host-portabel, während die Binary trotzdem ehrlich trägt, unter welchen freigegebenen System-Eigenschaften sie gebaut wurde.

Das **Freigabe-Prinzip** (Organ ≤ System) lebt bereits im Code, am schönsten am Beispiel Huge Pages: die **Hardware** deklariert die Fähigkeit (`huge_page_capable()` = Raum frei), das **Allokator-Organ** setzt via `AllocPageHint` durch, compile-time-gegated auf die Fähigkeit. Die System-Achse gibt frei, das Organ wählt. Genauso gibt die **ISA** frei, welche Organe überhaupt baubar sind.

## 7. Meta-Meta-Achsen: Command-Pattern-Freigabe und zweischichtige Permutation

Das ist die dynamische Erweiterung des Achsen-Raums (§54-T5/T7):

- Eine **statische Hardware-Haupt-Achse** ist der **Manager** über ein **statisches Achsen-ARRAY**. Jeder Erweiterungshardware-Typ (AVX512 mit seinem komplexen Flag-System, AVX2, später GPU/FPGA/NPU) ist eine **eigene Achse** — eine **Meta-Meta-Achse** unter diesem Manager. „Alles, das kein CPU-Core im herkömmlichen Sinne ist und einen speziellen Befehlssatz braucht", ist eine Hardware-Erweiterung.
- Die Hardware-Haupt-Achse **verwaltet und gibt frei**. Jede Meta-Meta-Achse erteilt dann — **als eigenständige Instanz nach dem Command-Pattern** — Freigaben an die Organ-Achsen.
- **Zweischichtige Kern-Permutation:** die Hardware-Haupt-Achse permutiert nicht nur die *Werte* jeder Meta-Meta-Achse (Schicht 2), sondern auch deren **Existenz (an/aus)** (Schicht 1). Der CEB baut damit Tier-Binaries **mit wechselnden oder ganz fehlenden Hardware-Erweiterungen**. Die Existenz-Wahl ist **compile-time**; die Meta-Meta-Achse bleibt eine **volle, zur compile time ausgerollte Haupt-Achse**.
- **Konsequenz:** die tatsächliche System- *und* Organ-Achsen-**Zahl wächst dynamisch je nach Maschine**, auf der alles läuft. 17 Organe / 6 System-Achsen sind kein fixer Stand, sondern der Kern, der sich host-abhängig erweitert. Die Organ-Seite hat symmetrisch ein analoges Manager-Array + aus einem Fold abgeleitete (nicht hartcodierte) Versionierungs-Stempel für den durch die CEB materialisierten compile-Raum.

## 8. Die Mess-Achsen im Detail

Der Mess-Achsen-Typ folgt exakt der Haupt/Unter-Statik (§47, korrigiert durch §54-T2):

- **HAUPT = Mess-Tooling {Wallclock · Makro-Benchmarks · Micro-Benchmarks über Observer}** — statisch, fest einkompiliert; jede Tooling-Wahl ergibt eine eigene CEB-Strecke und trägt den `kMeasurementAxisVersionLine`-Stempel.
- **UNTER (Planer-gesteuert, delegiert):** Ablaufmethodik {Debug=parallel / Messen=1-Thread / Release=ohne Messsystem} · Workloads/Datasets · **measurement_categories** · **Rückschrieb-Methoden** (alle vom Anwender verlangten Methoden, Ergebnisse zurückzuschreiben).
- Die 16 `measurement_categories` sind **eine Mess-Tooling-Unter-Achse im Planer** — nicht bloß passive CSV-Spalten. Sie *manifestieren* sich als CSV-Spalten und sind binary_id-neutral, aber konzeptionell sind sie eine Planer-Unter-Achse, keine Auffächerungs-Haupt-Achse.

## 9. Die Legenden-Kette: Tier-Build-Array vs. Measurement

Der Planer emittiert eine Child-Pipeline, die sich selbst weiter emittiert. Aus dem Code (`experiment_plan_director.hpp`) präzise (§54-T6):

- **Stufe 1 (Planer, Mess-Achsen-Stufe):** `ceb:build:[a,b,c]` → `ceb:emit:[a,b,c]` (`--emit-tier-ci`) → `ceb:trigger:[a,b,c]`. **[a,b,c] = Mess-Tooling-HAUPT.**
- **Stufe 2 (CEB, System-Achsen-Stufe) — der Tier-Build-Array:** `tier:build:[a,b,c][d,e,f]:chunk<k>`. Das ist **[a,b,c] Mess-HAUPT × [d,e,f] System-HAUPT × chunk<k>** — und der ganze 2^17-Organ-Raum steckt **gebündelt im chunk<k>** (2^17 Einzeljobs wären Rauschen). Die Bau-Legende trägt **nur Haupt-Achsen, kein Organ**.
- **Measurement ist EXTRA** — ein **separater, gegateter Job**, nicht Teil des Tier-Builds: `measure:[a,b,c][d,e,f][g,h,i]`, mit der **dritten Gruppe [g,h,i] = Mess-Unter-Sweep** (Workloads/Datasets/categories/Rückschrieb-Methoden, zur Laufzeit vom Planer permutiert), **`when: manual`**, GN-11/320er-gegatet.

Damit ist die Weitergabe der Achsen-Werte über die Trigger-Grenzen zentral: jede Stufe reicht explizit weiter, was die nächste braucht (z.B. muss `COMDARE_GN_TOTAL` per expliziter Forward-Allowlist durchgereicht werden, sonst baut der Grandchild nur den Default statt 2^17 — ein realer Bug-Fix der Kette).

## 10. Die Anatomie: Lebewesen, Organe und die Gattungen

Eine Tier-Binary ist ein **Lebewesen**, zusammengesetzt aus **Organen** (den Organ-Achsen). Die Messung beobachtet jedes Organ.

- **Gattungen** (Tier-Binary-Interfaces): **SearchAlgorithm** ist voll ausgebaut — 17 Achsen, davon 9 real getriebene Organe, `ObserverAggregate<17>`, acht Schichten (Composition → Anatomy → Observer → PermutationEngine → ABI-Adapter → Prüf-Dock → ExecutionContext → Binding). **Set / Sequence / Adapter / View** sind bisher Skelette (je nur 1 Organ getrieben); ihre Vervollständigung auf SearchAlgorithm-Tiefe ist der letzte, große ABI-Schritt.
- **Cross-Genus-JOIN ist typ-unmöglich** (Gattungen mit ungleichen Achsen kreuzen nicht). Aber **Cross-Genus-Komposition-als-Sub-Organ** ist der erlaubte, neue Weg: über ein gemeinsames **`OrganConcept`** kann SearchAlgorithm ein Set-/Sequence-/Adapter-Organ als *Sub-Organ* mitverwenden (z.B. `index_organization` ← ein Set, `node_type` ← eine Sequence) — CT-statisch, zero-cost, dispatch-frei. So verwendet SearchAlgorithm optimierte Container und Sets gleichermaßen mit, wie deklariert. Genus und ABI bleiben disjunkt, aber gegenseitig nutzbar.
- Der Mess-„Visitor" ist real kein Visitor, sondern ein flacher POD-Pull über `IObservableTier::tier_observe(...)` — ein ABI-stabiles, memcpy-fähiges Schema. Das Haupt-Observer-Interface bleibt statisch (zero-cost).

## 11. Der Beweis-Maßstab: golden

**golden N = 2^17 = 131072** = alle 17 Organ-Achsen gleichzeitig mit je 2 Werten variiert = der **einzige legitime Ganz-System-Beweis** (CRC64-verankert, Anker `0xF1C1F26A1232073B`). **new-golden ist Bau-Pflicht.** golden-320 ist nur eine Byte-Wache (13/17 gepinnt) und dient als Zwischen-Messdatensatz zur Deadline. Der Voll-Messlauf ist mehrtägig und hart USER-GO-gegated; die N-Voll-Messung läuft als Anschlussarbeit.

## 12. Die Metaprogrammierungs-Doktrin

Alles auf dem Hot-Path ist **compile-time**: CRTP + Concepts, **kein vtable, kein Runtime-Switch, kein `std::variant`** — mit einer einzigen, eng begrenzten Ausnahme im Hybrid: `std::variant` dient dort *ausschließlich* als dynamischer Träger für abweichende **Unter-Prüf-Dock-Typen/-Verträge**, eingebunden per **Abstract-Factory-Methode**; die Haupt-Observer-Kommunikation bleibt statisch (`IObservableTier`). Nur benannte Lehrbuch-Patterns; statischer Dispatch; zero-cost. Interne Templates sind erlaubt, aber die äußeren Produkt-Interfaces sind binär-stabil.

## 13. Storage und Caching

Die gebauten Binaries und Sidecars werden inkrementell zwischengespeichert (Voraussetzung für den 2^17-Voll-Lauf), mit Versionierungs-Stempeln im Cache-Key für chirurgische Invalidierung. Die **asynchrone Erstellung/Upload der Binary-Artefakte auf den MinIO-Store ist freigegeben und Pflicht** (Bau-Durchsatz). Der **git-Push und der Mess-Rückschrieb-Sink bleiben dagegen synchron/blockierend** (Storage-Naht-Doktrin: I/O-Contention während der Messung verfälscht Messwerte). Ebene B = dev-MinIO, Ebene C = prod-NFS.

---

## Auf einen Nenner

**Ein XML definiert ein Experiment. Der Planer plant es und emittiert die Kette. Der CEB backt die statischen Haupt-Eigenschaften — freigegebene System-Achsen und Mess-Tooling — in Tier-Binaries ein, deren Identität (binary_id) rein aus den 17 Organ-Achsen entsteht, während die freigegebenen System-Achsen mitkompiliert und gestempelt werden. Die dynamischen Unter-Achsen werden je Stufe an die nächste delegiert. System-Achsen geben den Raum frei, Organe setzen ihn durch; welche freigegeben sind, entscheiden Meta-Meta-Achsen per Command-Pattern je nach Maschine — die Achsen-Zahl wächst dynamisch, compile-time-permutiert in zwei Schichten (Existenz und Wert). „Gattung" ist dabei nie eine Achse, sondern die einheitliche Interface-Hülle, die eine Tier-Binary nach außen trägt; Achsen sind nach Typ (Organ/System/Mess) organisiert, mit je einem eigenen Permutations-Baum. Gebaut wird `tier:build:[a,b,c][d,e,f]:chunk<k>` (Mess-HAUPT × System-HAUPT × gebündelter Organ-chunk); gemessen wird getrennt und gegatet über `measure:[a,b,c][d,e,f][g,h,i]` mit den Mess-Unter-Achsen. Alles compile-time-statisch und zero-cost, bewiesen gegen einen golden-Lauf über alle 17 Organe. Aus den realen Messkurven baut schließlich das Hybrid-Binary rückwärts die optimalen Algorithmen-Sätze — dafür bleibt die Break-Even-Auswertung fester Bestandteil des Plans.**
