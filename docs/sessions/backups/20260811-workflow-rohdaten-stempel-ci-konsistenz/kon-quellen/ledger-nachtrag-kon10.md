## NACHTRAG 11.08.2026 NACHTS — KON10: DER SELBSTKOMPILATIONS-ENTWURF IST GEFUNDEN UND VOLLSTAENDIG

**Owner 11.08.:** *„Es ist also der Mechanismus der **Selbstkompilation aus C++ Binaries heraus**
(nur cmake erlaubt, keine Skripte erlaubt). **Du hattest das schon entworfen.**"*

**Er hatte recht. Der Entwurf existiert vollstaendig, seit dem 19.07.2026, in zwei Dokumenten —
und er traegt JEDE Festlegung dieser Nacht im Kern.** Gefunden ueber den Explore vom 11.08.
(Schnitt 1, Urteil *„VOLLSTAENDIG GEFUNDEN -- mehrfach unabhaengig belegt"*), danach von mir selbst
gegengelesen.

    docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md              253 Zeilen
    docs/plaene/20260719-FINALES-DESIGN-ABSTRACT-kette-baum-registries.md 114 Zeilen

**Warum ich ihn nicht fand:** der Begriff „Selbstkompilation" kommt darin **null**mal vor. Der
Owner hat ihn heute neu gepraegt; entworfen ist die Sache unter **Director/Builder + Command +
Codegen**. *Wer nach dem Wort sucht statt nach der Sache, misst eine korrekte Null und schliesst
falsch.*

---

### KON10-01 — D5 IST DER OWNER-SATZ VON HEUTE, WOERTLICH VORWEGGENOMMEN

**Owner 11.08.:** *„nur bestimmte **concept builds zur Laufzeit eines niederen Traegers** duerfen
den **compile eines hoeheren Traegers** bilden."*

**Design-Satz D5 vom 19.07. (`ABSTRACT:32`), woertlich:**

> „**Stufen-relative CT-Doktrin.** Jede Vorstufe permutiert ihre Achsen **dynamisch** und friert die
> Wahl der Folgestufe als **Compile-time-Draht** ein (**Planer-dynamisch → CEB-CT; CEB-dynamisch →
> Tier-CT**); im gemessenen Hot-Path gibt es weder vtable noch Runtime-Switch noch `std::variant`."

Und **D1** (`ABSTRACT:24`): *„Jede Stufe **erzeugt/kompiliert die naechste**; **nichts wird zur
Laufzeit umgeschaltet**."*

⇒ **Die Filterkette aus KON9-06 ist damit nicht neu zu erfinden, sondern zu BAUEN.** Was der Owner
heute als `mp11`-concept je Phasigkeit praezisiert, ist die Durchsetzungsform fuer D5.

---

### KON10-02 — DIE MINI-PIPELINE JE TRAEGER: D17, FUENF CI-STUFEN

**Owner 11.08.:** *„jede Traeger-Stufe muss unbedingt als **eigene Mini-Pipeline innerhalb der
Haupt-Pipeline** gebaut und getestet werden, also ein **eigenes Binary mit eigenen Beduerfnissen**."*

**Design-Satz D17 (`ABSTRACT:56`), woertlich:**

> „**CI-Kette: 5 Stufen, zwei Modi.** Die eine Pipeline hat 5 Stufen — **St.0** Start/Lint/
> Orchestrate/Bau-Flaeche · **St.1 PLANER (=Mess)** · **St.2 CEB (=System)** · **St.3 TIER
> (=Organ; einzige FERTIGE Stufe; opt. St.3b Hybrid)** · **St.4** Auswertung/Persist — in zwei
> Modi (Gesamtlauf: CI-Gruen = Messung AUS; Messlauf: opt-in, mehrtaegig, nie pollen);
> **groesstes Loch ist der Planer-Kopf (PL-1)**."

Dazu die Bau-Mechanik im BAUPLAN (`:61`): **`CiYamlBuilder` → Child-Pipeline
(`trigger:include:artifact:`)** — einer der beiden ConcreteBuilder emittiert genau diese
Kind-Pipelines. **Die Mini-Pipeline ist also nicht nur gefordert, sie hat schon ihren Erzeuger.**

---

### KON10-03 — DIE ZWEI ABLAGEN SIND ENTWORFEN: D18 + §31-A4

**Owner 11.08.:** *„Die Traeger-Binaries werden auch an der **Wurzel des Buildsystem-Caches
(bereits auf NAS aufgebaut)** gespeichert und wenn sie **Gattung und Genus** haben, unter
**weiteren Kategorien ins Lager** einsortiert."*

**§31-A4 vom 19.07. (`ABSTRACT:110`), User-praezisiert, woertlich:**

> „**CI-Cache** (dev, `minio.comdare.local`) = **NUR Planer-Binary** (statisch, Kopf) ·
> **prod-MinIO** (`…/cache-engine-tier-binaries`) = **ALLE generierten Folge-Stufen-Binaries**
> (CEB je Messsystem + Tier + Hybrid) **+ Systemaufstellungen (Sidecars/Provenienz)**;
> Ebene B entsprechend erweitert."

    CI-CACHE (dev-MinIO)   ->  NUR der Planer -- die einzige STATISCH gebaute Binary
    PROD-MinIO             ->  ALLE GENERIERTEN Folge-Stufen + Sidecars/Provenienz
    LAGER                  ->  davon die mit Gattung UND Genus, unter weiteren Kategorien

**Damit ist auch Rolle (2) des Stempels (KON9-11, „Cache-Schluessel") entworfen** — sie war die
einzige der fuenf ohne Objektbeleg. Der Beleg ist ein PLAN-Beleg, kein Code-Beleg: **entworfen ja,
gebaut nein.**

---

### KON10-04 — DIE PLANER→CEB-NUTZLAST IST DER SERIALISIERTE TEILBAUM (§38)

Beide Dokumente tragen denselben Schluss-Abschnitt, **§38 (19.07.), der frueheren Text revidiert**:

> „(1) Die Planer→CEB-Nutzlast ist der **per Serialisierung uebergebene untere Teilbaum** des
> Experiment-B+-Baums (System-Achsen + freigegebene/regulaere Organ-Achsen als **RANGES je Achse**,
> nicht beliebige Configs) — die CEB permutiert die Ranges **lazy** und delegiert die Kompilation.
> (2) Die CEB liefert dem Planer einen **sparsen Fortschritts-RUECK-KANAL** (Cursor-/Delta-Protokoll
> je Experiment-Permutation […] **Mixed-Radix-konform**). Der Rueck-Kanal ist KEIN
> Mess-Daten-Rueckfluss. Die obere Dock-Grenze ist damit **bidirektional mit asymmetrischer
> Nutzlast** (hinab Teilbaum-Ranges, hinauf Fortschritts-Deltas)."

⇒ **Das deckt KON8 exakt:** *„die Anzeige wird lazy durch die Stufen des Experiment-B+-Baumes
abgebildet, der zwischen Planer und CEB synchronisiert wird."* Der Mechanismus dahinter ist
Ranges-hinab / Cursor-Deltas-hinauf.

---

### KON10-05 — DIE MUSTER STEHEN NAMENTLICH (BAUPLAN §Phase-1)

| Baustein | Muster | Rolle |
|---|---|---|
| XML → `ExperimentPlan` | **Interpreter** | `parse_experiment_profile` + `project_experiment_to_sota_passes`, formalisiert |
| `ExperimentPlanDirector::construct(IPlanBuilder&)` — **EIN** Walk | **Director** | besitzt die Enumeration opt×simd×phase×pass |
| `CMakeGraphBuilder` + `CiYamlBuilder` aus **demselben** Walk | **2× ConcreteBuilder** | Synchronie **strukturell** garantiert: ein Walk, zwei Syntaxen |
| `resolve_selection → emit_build → emit_measure → emit_serialize → emit_copy` | **Template-Method** | invariantes Skelett + Hooks |
| Reduktion in `resolve_selection` | **Chain of Responsibility** | `run_selection_filter_chain` einhaengen |
| `IExperimentDock` + `ExperimentDockRegistry` | **Abstract-Factory** | die Planer↔CEB-Vertragsform |

**Und die gebaute Blaupause fuer die Selbstkompilation:** `cmake/catalog_codegen.cmake:27-37` —
`add_custom_command` + `COMMAND $<TARGET_FILE:comdare_catalog_codegen_cli>` + `DEPENDS <xml>`.
**Eine kompilierte Binary erzeugt zur Configure-/Pre-Build-Zeit Quellcode.** Genau der Mechanismus,
nur CMake, keine Skripte. Er existiert und laeuft — fuer den Katalog-Header.

---

### KON10-06 — WAS DER ENTWURF SELBST ALS OFFEN AUSWEIST

**Der adversariale Kritiker im BAUPLAN (`:220-234`) fand einen BLOCKER, der bis heute steht:**

> „**Projektstruktur-Analyse endet am Submodul**; das offizielle `02_messung_driver` (Super-Repo)
> samt vorhandener Parallel-Enumeration ist ungeprueft. […] `Code/02_messung_driver/
> v32_messreihe_antrieb.hpp:214` — eine **ZWEITE** Funktion namens `run_experiment_profile` […]
> selbst betitelt »der OFFIZIELLE Einstieg«. Der geplante NEUE `ExperimentPlanDirector` wuerde
> damit zur **DRITTEN** Enumerations-/Export-Engine — exakt die v32-Parallel-Engine-Klasse, die
> laut Memory bereits einmal gestoppt wurde."

⇒ **PHASE 0 (super-Repo reconcilen) ist Voraussetzung jedes Baus an dieser Stelle.** Sie war am
19.07. benannt und ist bis heute nicht erledigt.

**Weitere offene Forks aus dem Entwurf (A ist per §30 entschieden):**
* **B** — dritter trivialer `PlanTextBuilder` fuer `--dump-plan`? *(Empfehlung damals: ja)*
* **D** — `ceb_contract_version`-Minor-Bump beim Planer-Emitter? *(kein Bump, solange kein
  universeller Codegen beruehrt — vor Merge verifizieren)*
* **E** — XML-Kanal-Konvergenz: Experiment- gegen Thesis-Profil *(GO noetig)*
* **R1** — Registry-Single-Source: Code=Wahrheit + Generator-Ausbau gegen Registry=Hand-Wahrheit

**Und die Terminlage ist ueberholt:** der Entwurf rechnet gegen den **28.07.**; §31 machte den
Hybrid-Einschub zur *„Abgabe-Pflicht vor 28.07."*. Heute liegt er als **HY-A in W1** (F2, 21.08.).
Die Fork-C-Schnittlinie ist damit **gegenstandslos** und neu zu ziehen.

---

### KON10-07 — WAS DAS FUER DEN STEMPEL-BAU AENDERT

1. **Der Designplan wird kein Neuentwurf, sondern eine ANSCHLUSS-ARBEIT.** Die Muster, die
   Stufen-Zuordnung, die CI-Struktur, die Cache-Topologie und die Dock-Spiegelung stehen seit dem
   19.07. Was fehlt, ist der **Bau** — und die **Durchsetzung** per concept.
2. **Die drei Grammatiken je Phasigkeit (KON9-04) bekommen ihren Ort:** sie sind die Sprache, in der
   D5 („Vorstufe dynamisch → Folgestufe CT") *geprueft* wird. Je Uebergang eine Grammatik.
3. **Die Bump-Pflicht (KON9-11) haengt an D18/§31-A4:** ohne `X.Y.Z`-Bump findet der prod-MinIO-Cache
   die alte Binary und liefert sie aus. Der Cache ist entworfen — **die Wache dagegen nicht**.
4. **PHASE 0 zuerst.** Vor jedem Bau am Planer-Kopf ist das super-Repo zu reconcilen, sonst entsteht
   die dritte Enumerations-Engine. Das ist ein **harter Blocker aus dem Entwurf selbst**, nicht
   meine Zutat.

---

### KON10-08 — METHODISCHER BEFUND: DAS `widerlegt`-FLAG WAR ZU GROB

Der Explore meldete *„23 bestaetigt, 9 widerlegt"*. **Falsch gelesen, und der Fehler ist meiner.**
Alle neun angeblichen Widerlegungen beginnen mit *„Quelle existiert, Zeile stimmt, Zitat woertlich"*
und **bestaetigen** den Befund; das Flag wurde fuer **Praezisierungen** gesetzt (*„ZITAT WOERTLICH?
Fast."* · *„nur Whitespace-Padding geglaettet"*).

> **Ein binaeres `widerlegt`-Flag verliert die Unterscheidung zwischen „falsch" und „fast richtig".**

Haette ich die Zahl uebernommen, waeren **neun gueltige Befunde als gefallen verworfen** worden.
Konsequenz: kuenftige Verify-Schemata tragen einen dritten Zustand `PRAEZISIERT`.

**Zweiter Befund derselben Klasse:** die Zeilenanker des Explores (`Ledger:10617` fuer §40.b) waren
beim Nachschlagen **um rund 444 Zeilen gedriftet** — ich hatte an diesem Abend Nachtraege **oben**
eingefuegt. *Ein Zeilenanker auf eine lebende Datei ist nur mit Commit-Anker gueltig; sonst per
Symbol suchen.*
