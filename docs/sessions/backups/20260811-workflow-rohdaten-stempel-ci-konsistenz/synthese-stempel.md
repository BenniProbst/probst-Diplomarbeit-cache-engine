# SYNTHESE — ERKENNTNIS-LISTE FÜR DEN LEDGER-NACHTRAG

## 0. META-BEFUND VORWEG: DIE EINGANGSDATEN SIND TEILWEISE ÜBERHOLT

**Selbst nachgemessen, nicht aus Bericht.** Die gelieferten Nichtfunde beruhen auf einem Ledger mit 20.430 Zeilen und „KON9 = 0 Treffer". Der Ledger `/home/comdare/wt-super-landung/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` hat **heute 20.973 Zeilen** und enthält bereits **zwei** neuere Nachträge, die ein paralleler Agent während dieser Erhebung geschrieben hat:

| Nachtrag | Zeilen | Punkte | deckt Auftrags-Block |
|---|---|---|---|
| KON10 — „DER SELBSTKOMPILATIONS-ENTWURF IST GEFUNDEN UND VOLLSTAENDIG" | 19–193 | KON10-01…08 | (a) |
| KON9 — „DIE STEMPEL-ARCHITEKTUR, KONSOLIDIERT GEGEN KON7/KON8" | 194–561 | KON9-01…12 | (b) (c) (d) (e) |

Namentlich vorhanden: KON9-01 (ORT/ZEIT sind zwei Ordnungen), KON9-03 (Multiplexer), KON9-04 (drei Grammatiken nach Phasigkeit), KON9-05 (Ordnungs-Relation über Flag-Mengen), KON9-06 (Filterkette = Selbstkompilations-Mechanismus), KON9-07 (Owner-Auftrag Interface-Arten), KON9-11 (Stempel als Cache-Schlüssel), KON9-12 (was offen bleibt).

**Konsequenz für den Lead:** Der Nachtrag darf nicht als Erstschrift gebaut werden, sondern als **Ergänzung/Korrektur gegen KON9 und KON10**. Die Blöcke (a)–(e) sind dort im Kern gelandet; **neu und ungedeckt sind vor allem Block (f), die Widersprüche W-1…W-4 und die Entlastungen.**

Token-Nachmessung im heutigen Ledger (`/usr/bin/grep -ci`, Nenner 20.973 Zeilen): `Selbstkompil` 8 · `Multiplexer` 2 · `VIERPHASIG` 2 · `Stecksystem` 1 · `Verteiler` 1 · `Handlanger` 1 · `Parameterfunktion` 2 · `mp11` 23 · `add_custom_command` 1 · `Interface-Art` 1 · `dreiphasig` 24. **Alle waren in den Eingangsdaten als 0 gemeldet.**

---

## (a) SELBSTKOMPILATION — DER MECHANISMUS, DEN DER OWNER ALS „SCHON ENTWORFEN" BEZEICHNET

### WAS GILT

**Grundgleichung, ältester verifizierter Beleg (19.07.2026, drei Wochen vor dem 11.08.-Anker):**
> „Richtig, aber kleine Korrektur: Der Experiment-Planer steuert die Bau-Jobs von CEBs und die CEBs steuern Bau-jobs von Tier-Binaries."
`/home/comdare/.claude/projects/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489.jsonl:60943` (type=queue-operation, 2026-07-19T16:08:16.022Z) — OWNER-WORT, **neu**.

**Strikte Erzeugungskette + Director-Rolle (09.08.2026):**
> „Und es war ja auch nur C++ und cmake erlaubt, es gibt ja keine skripte. Der Planer fordert auch in der Testsituation dummy commands als director von der CEB an. Ohne Planer gibt es keine CEBs, keine Tier-Binaries ohne CEBs, keine Hybrid-Binaries ohne Tier-Binaries."
`memory/project_vier_binary_typen_ceb_traegt_alles_acht_behelfs_clis.md:19-24` — OWNER-WORT, **neu**.

**Der 11.08.-Auslösersatz, in korrigierter, vollständiger Fassung** (das Eingangs-Zitat war still gekürzt, siehe E-1):
> „Es ist also der Mechanismus der Selbstkompilation aus C++ Binaries heraus (nur cmake erlaubt, keine Skripte erlaubt, **siehe letzter Kontext und auch sonst**). Du hattest das schon entworfen."
`5a19728e-f6e1-4736-a246-e3fda9ac35a1.jsonl:42174`, 2026-08-11T17:41:20.756Z.

### IST-STAND

- **Die gebaute Blaupause existiert und ist im Plan namentlich als VORBILD benannt:** `add_custom_command` ruft die fertig kompilierte Codegen-Binary über `$<TARGET_FILE:comdare_catalog_codegen_cli>` auf, `DEPENDS` bindet Target + XML, `VERBATIM` schließt die Shell aus — `Code/external/comdare-cache-engine/cmake/catalog_codegen.cmake:52-60` (heute; im BAUPLAN vom 19.07. noch als `:27-37` adressiert — reine Zeilendrift durch einen am 06.08. eingefügten Kommentarblock).
- Der Planer ist **bereits eine eigene Binary**: `ce apps/experiment_planner` → `comdare-experiment-planner` (Owner-KERN 05.08. erfüllt).
- Beide Klone identisch: `wt-ce-warn-libs` und `wt-super-landung/Code/external/comdare-cache-engine` stehen auf **670483c084293c2fa7f6fb7c72dcc3a8192e0b48**, `git status --porcelain` = 0 Zeilen (selbst nachgemessen).

### WAS FEHLT

- **Der KERNSATZ-VERSTOSS in Glied 3** (aus Bericht, nicht nachgemessen): `ceb:build` baut laut Audit vom 05.08. weiterhin den **generischen** Treiber und differenziert `[a,b,c]` erst **zur Laufzeit** über eine Environment-Variable `COMDARE_MEASUREMENT_COMBO` — genau die von §30.6/Fork A ausgeschlossene Runtime-Konfiguration, „durch KEINEN Deferred-Posten gedeckt" (Ledger:12242).
- **Die Gegenrichtung, heute selbst nachgemessen** (Nenner explizit): `wt-super-landung` enthält **145 `.sh`-Dateien mit 27.003 Zeilen** (ohne `build/`, `.git/`, `external/`). Davon eigener Baum: `ci/` 18 · `ci/tests/` 14 · `scripts/` 10 = **42 Dateien**; der Rest liegt überwiegend in Fremd-Repos unter `Forschungsarbeiten/code/` (userspace-rcu 12+3, SuRF, HOT …) und in Session-Backups — **kein eigener Verstoß, aber der im Memory geführte Nenner „60 Dateien / 20.030 Zeilen" ist ein anderer Ausschnitt und nicht mit dieser Zahl vergleichbar.**
- **Die stehende Regression wächst messbar:** `ci/tests/*.sh` = **14 Dateien / 8.528 Zeilen** (heute selbst gemessen) gegen **13 Dateien / 7.967 Zeilen** in KON6-05 vom selben Tag. **+1 Datei, +561 Zeilen innerhalb eines Tages.** Das ist der harte Beleg für Aufgabe #89.

---

## (b) DREI GRAMMATIKEN JE PHASIGKEIT + ORDNUNGS-RELATION ÜBER FLAG-MENGEN

### WAS GILT

**Owner-Festlegung 11.08. abends:**
> „Bitte zu (A) zwei Grammatiken für DREIPHASIG und VIERPHASIG und eine Grammatik für ZWEIPHASIG."
`5a19728e-….jsonl`, type=user/typed, 2026-08-11T17:41:20.756Z — OWNER-WORT, **neu**. Im Ledger gelandet als KON9-04 (Zeile 291).

**Teilmengen-Relation ist allgemeingültig, und daraus folgt ein Hardware-Stempel:**
> „Aber genau das ist richtig und muss festgehalten werden. Es gilt für den gesamten Satz an Hardware, den ein Rechner fahren kann. […] ergibt sich, dass die gewählten Achsen-Algorithmen auch einen Hardware-Spezifikations-Stempel mit Versionsnummer X.Y.Z mit voller System-Achsen-Syntax und Semantik unterstützen müssen."
`5a19728e-….jsonl`, queue-operation, 2026-08-11T17:45:03.381Z — OWNER-WORT, **neu**. Ledger: KON9-05 (Zeile 312).

**Der Hybrid-Einschub erzeugt einen eigenen, sich fortpflanzenden vierphasigen Vertragskomplex:**
> „Frage 1: ja korrekt und weiterhin bestimmt es durch den Einschub der Hybrid-Träger-Stufe auch deren VIERPHASIGEN Vertragskomplex, der sich hier fortpflanzt."
`5a19728e-….jsonl`, 2026-08-11T16:20:58.236Z — OWNER-WORT, **neu**.

**Vorläufer vier Stunden früher (nicht neu, = KON7-08 / Ledger:549-551):** jede Stempel-Klasse je Achsen-Typ erbt von **einer** gemeinsamen Basis-Syntax, mit eigenen Erweiterungen in der Klammerung.

### IST-STAND (am Code-Objekt, Stand 670483c0)

- **Die Lücke, die der Owner schließen will, ist im Code namentlich benannt und per `static_assert` bewiesen:** `libs/cache_engine/include/cache_engine/measurement/algo_semver.hpp:1525-1528` — „ABHAENGIGKEITEN ZWISCHEN FLAGS. `'1.0.0.c.x512{vl}'` ohne `'f'` geht durch, obwohl alle AVX-512-Subsets auf avx512f gegated sind […] eine Voraussetzungs-Wache ist ein eigener Schritt mit eigener Semantik-Frage (fordert das Flag die Voraussetzung, oder impliziert es sie?)"; Beweis-`static_assert` bei `:1533`.
- **`Subset` ist heute nur ein Klassifikationswert, keine Relation:** `flag_grammar_catalog.hpp:118-127` — `BreitenSubset = 3`, `MedienSubset = 7` als `FlagTokenKind`-Werte. Keine Ordnungs-/Dominanzfunktion über Kompositionen wie `x512{f.vl}` ⊂ `x512{f.vl.bw}`.
- **Andockstelle vorbereitet, nicht angeschlossen:** „S2-KATALOG-ANDOCKSTELLE" seit 07.08.2026 unverändert in `algo_semver.hpp:73`.
- **Keine Vererbungshierarchie:** fünf lose Stempel-Strukturen ohne gemeinsame Basis (`StampSegment` :205, `StampLineLiteral` :444 in `anatomy_stamp_entries.hpp` · `CompletedSystemStampLine` `system_cell_values.hpp:364` · `ToolchainStampParts` `toolchain_stamp_glied.hpp:282` · `AnatomyStampEntryV1` `anatomy_module_abi_v1_decl.hpp:178`) — Messung vom **10.08.**, also **vor** der Owner-Forderung vom 11.08. 13:41; sie ist die Datengrundlage, nicht die Antwort.

### WAS FEHLT

- Eine Ordnungsfunktion für die **algo_semver-Flag-Grammatik**. Gegenprobe: die analoge Funktion existiert real für die **BVSET**-Grammatik (`bvset_ist_teilmenge`, `builder/bvset_teilmenge.hpp`, 187 Zeilen) — die Bauform ist also bekannt, nur nicht auf Flags angewandt.
- Eine **vierte Klammer-Gruppe** für die vierphasige Mess-Testat-Zeile. Nachweis: `[a,b,c][d,e,f][g,h,i][` = 0 Treffer im ce-Baum; die Drei-Klammer-Form ist belegt (`plan_legend.hpp:142`, `bestandslog_document.hpp:117-121`).

---

## (c) FILTERKETTE ALS mp11-CONCEPT + CEB-LAUFZEIT-HARDWARE-ANALYSE

### WAS GILT

**Owner 11.08. 17:41, Antwort auf die Assistant-Frage (B) „Wo sitzt die Filterkette?":**
> „Zu (B): Die Filterkette ist ein C++23 concept zur compile time von mp11 und zur Laufzeit wird auf der CEB (explore über 10 Wochen) die hardware analysiert und gegen die Organ-Achsen freigegeben."

**Fortsetzung desselben Turns:**
> „Die Filterkette ist also ein concept für einen Vertrag einer freigebenden Seite gegen ein compile time Ziel je Phasigkeit, wobei nur bestimmte concept builds zur Laufzeit eines niederen Trägers den compile eines höheren Trägers bilden dürfen."

Beides `5a19728e-….jsonl:42174`, 2026-08-11T17:41:20.756Z — OWNER-WORT, **neu**. Ledger: KON9-06 (Zeile 347).

**Bereits vor dem Dialog vorhanden (nicht neu, KON8-03, Ledger:684):** die CEB hat **zwei** System-Anzeigen — compile-time (in den Stempel) und Laufzeit/RAM „was die Hardware KANN" (in die Freigabe, **nicht** in den Stempel).

### IST-STAND (selbst nachgemessen, Stand 670483c0)

- **C++-Standard:** `ce:CMakeLists.txt:16` = `set(CMAKE_CXX_STANDARD 23)`, Kommentar `:14` „Hauptcompiler IMMER C++23".
- **Eigene C++-Concepts: 339 Deklarationen in 229 Dateien** — Filter: `*.hpp,*.cpp,*.h,*.cc,*.ipp`, ohne `ext/`, `build/`, `boost_mp11/`. (Die im Bericht genannten 321/228 sind ein Vorstand; siehe Widerspruch W-2.)
- **mp11 ist vendorter Teilbaum, kein Voll-Boost:** `cmake/boost_mp11_setup.cmake:7` „Boost.MP11 ist header-only (standalone seit Boost 1.66)"; eingebunden über `CMakeLists.txt:551` `include(boost_mp11_setup)`; Fallback-Kaskade vendored → Archiv → FetchContent auf Tag `boost-1.91.0`.
- **mp11-Nutzung, mit beiden Nennern selbst gemessen:** **350 Fundstellen in 169 Dateien** (nur Quellcode, obiger Filter) bzw. **726 Fundstellen in 204 Dateien** (alle Dateitypen, gleicher Verzeichnisausschluss).
- **Die heute aktive Laufzeit-Hardware-Analyse in der CEB existiert:** `profile_run_entry.hpp:335-340`, Funktion `system_axis_host_supports_simd` — `__builtin_cpu_supports("avx2")` / `("avx512f")`, echte Runtime-CPUID-Abfrage, kein Compile-Zeit-Define. `run_profile` ist der deklarierte CEB-Eintrittspunkt.
- **Die geplante Vervollständigung ist NICHT gebaut** — der Code sagt es selbst, `profile_run_entry.hpp:314-317`: „WARUM DIE HOST-PROBE BLEIBT: sie ist der ehrliche Fallback fuer den Zustand 'es ist gar keine Maschine deklariert' — heute der Normalfall, weil die CEB `set_active_machine_declaration` noch nicht ruft (**0 Produktions-Aufrufer**)." Gegenprobe: derselbe Aufruf trifft **6×** in `tests/unit/test_c3a_gate_scharfschaltung.cpp` + **1×** in `test_o4_machine_identity.cpp` — die Suche greift, der Produktionsaufruf fehlt wirklich.

### WAS FEHLT

- **Die Filterkette in der vom Owner beschriebenen Form existiert nicht.** Der Landungs-Commit der real gebauten Filterkette (11.07.2026, `076b71cf`) heißt: „feat(builder): E4′ §C — CoR-Filterkette (GoF) im CEB: Auswertung→Generierung-Feedback-Kante" — **keine** Concept- oder mp11-Zuschreibung im Titel.
- **Ein generalisiertes Laufzeit-„Anzeige"-Objekt über GPU/FPGA/NPU gibt es nicht** — nur die einachsige SIMD-Grobroute. Gegenprobe: `detect_gpu|gpu_available|fpga_available|npu_available|discover_*` = 0 Treffer in ce (rc=1), während „reserviert, nicht produziert" **7×** trifft (`flag_grammar_catalog.hpp:183-185`, `algo_semver.hpp:1318`, `measurement_framework_registry.hpp:67`, `measurement_tooling_registry.hpp:73`, `system_axis_code_versions.hpp:118`).
- **Kein `concept`-Bezeichner spannt zwei Träger-Stufen im Namen** (Ceb+Tier, Planer+Ceb) — 0 Treffer. Gegenprobe: `CacheEngineBuilder` trifft 79 eigene ce-Dateien, `CEB` als Wortgrenze 178 Dateien.

---

## (d) HYBRID ALS TRANSPARENTER MULTIPLEXER — ORT UND ZEIT GETRENNT

**Alle fünf Zitate stammen aus EINEM Owner-Turn** (`5a19728e-….jsonl`, uuid `a5044cc2-ac37-4e4f-9c5a-1e80fe63c6fa`, 2026-08-11T17:41:20Z), die Präzisierung vier Minuten später. Ledger: KON9-01 (ORT/ZEIT) und KON9-03 (Multiplexer).

### WAS GILT — WESEN (zeitneutral)

> „Der Hybrid ist in all seinen Lebenslagen transparent und ein steuerbarer Multiplexer-Handlanger der CEB (die nur EIN Prüfdock hat), um virtuell gesteuert zu bestimmten Zuständen verschiedene Tier-Binaries schalten zu können."

### WAS GILT — ORT

> „Hybrid setzt also selbst die CEB Freigaben um und reicht sie dann weiter durch, sodass hybrid nur die Tier-Binaries andocken kann, zu deren Spezifikations-Teilmenge es selbst gebaut wurde."

> „die CEB baut das Hybrid und jede Tier-Binary gleichrangig auf, das Hybrid kann nicht bauen, sondern nur Tier-Binaries messen die schon gebaut sind […] Daher sind Hybrid und Tier-binary gleich auf und das Hybrid ein unabhängiges Stecksystem, das Tier-Binaries als \"Verteiler-Dose\" halten kann."

> „Hybrid kann stärkere oder schwächere Hardware Optimierungen als seine Tier-Binaries fahren und umgekehrt, beide sind unabhängig, aber das Hybrid muss passend zu den Genus-Interfaces seiner Tier-Binaries gebaut werden und das ist alles was zählt."

**ORT-Bestätigung unabhängig vom frischen Zitat (PLAN, nicht neu):** `ce docs/architecture/20260802-hybrid_tier_stufe_soll_design.md:55-59` verortet den Hybrid als Rekursions-Ebene 3 der Dock-Kette zwischen CEB-Prüf-Dock (Ebene 2) und den plain Tier-Binaries — exakt die Position, die der Owner als „wie gehabt" bestätigt.

### WAS GILT — ZEIT

> „Das hybrid wird also nach den Tier-Binaries und der Einzelmessung erzeugt als zu den Tier-Binaries gleichwertiges Einschub-Konstrukt."

**Präzisierung 17:45:59.187Z, ORT gegen ZEIT ausdrücklich getrennt:**
> „Doch der Hybrid wird bei den Trägern vor das Tier-Binary eingefügt wie gehabt, aber zeitlich erst nach dem einzel-Messungs-Durchlauf der Tier-binaries erzeugt und dann eingeschoben angewendet."

### IST-STAND

- **`DockSlot` existiert nur als Markdown-Codeblock**, nicht als C++-Typ: `soll_design.md:133-137` beschreibt POD aus `HybridDockVariant dock` (die einzige erlaubte `std::variant`-Stelle außerhalb der CEB), `HybridBinaryProxy proxy`, `DockContractDescriptor desc`. Im ce-Code = 0 Treffer als `struct`/`class`; einzige Fundstelle ist ein Kommentar in `heuristik_adapter_strategy.hpp:38`. Gegenprobe: `class IPruefDock` trifft **1×** — die Suche greift.
- **Acht der neun geplanten Hybrid-Dateien fehlen vollständig** (`hybrid_dock_contract.hpp`, `hybrid_pruef_dock.hpp`, `hybrid_dock_factory.hpp`, `hybrid_dock_array.hpp`, `hybrid_binary_proxy.hpp`, `hybrid_eviction.hpp`, `hybrid_router.hpp`, `hybrid_config_xml.hpp`, `hybrid_tier_module.cpp`) = 0 Treffer je Dateiname. Gegenprobe: `heuristik_adapter_gate.hpp` = **1** Treffer.
- **HY-A1 ist gelandet, HY-A2/A3/B1/B2 nicht:** `HY-A1` als Commit-Message = 3 Treffer in `git log --all`; `HY-A2`/`HY-A3`/`HY-B1`/`HY-B2` = 0 Treffer über 228 Branches.
- **`angeschlossene()`** ist das siebte der sieben Fläche-2-Interfaces, **nur beim Hybrid**, und mechanisch ein **Laufzeit-Sammler** über die Dock-Registrierung — nicht `constexpr` wie die anderen sechs (Ledger KON7-04). „Zwei verschiedene Mechanismen hinter derselben ABI-Fläche — das ist beim Bau zu trennen."

### WAS FEHLT

- Der Break-Even-Router. Das Plandokument warnt selbst (`docs/plaene/20260806-PLAN-messkurven-synthese-und-hybrid-binary.md:246-248`): „Ohne Auswertung hat der Router keine Umschaltschwelle — die Hybrid-Binary degeneriert zu einem Multiplexer ohne Kriterium." **Bemerkenswert: das ist der Begriff „Multiplexer" fünf Tage vor dem Owner-Gebrauch — dort aber als Warnung vor unvollständiger Bau-Reihenfolge, nicht als Architektur-Zusage.**
- K1 (Lager-Identität der Hybrid-`.so`) und K2 (Loader-Schichten-Zuordnung) müssen **vor dem ersten Linken** fallen; K5 (Snapshot-Aggregations-Semantik) ist ausdrücklich unentschieden; K4 gilt als erledigt.

---

## (e) INTERFACE-ARTEN UND PUNKTE FÜR VERSIONIERUNG

### WAS GILT

**Der Owner-Auftrag, vollständig im Rohtranskript** (`5a19728e-….jsonl:42213`, role=user, 2026-08-11T17:46:30.870Z) — mit einem vorausgehenden Satz, der in der Aufgabenstellung fehlte:
> „Und aus dem Fakt, dass eine Organ-Achse die Hardware eines Rechners nutzen KANN, aber nicht alles nutzen MUSS, ergibt sich, dass die gewählten Achsen-Algorithmen auch einen Hardware-Spezifikations-Stempel mit Versionsnummer X.Y.Z mit voller System-Achsen-Syntax und Semantik unterstützen müssen. Dazu explore zu den verschiedenenen Interface Arten und Punkten für Versionierung bitte."

Ledger: KON9-07 (Zeile 382).

### IST-STAND (selbst nachgemessen)

- **21 konkrete `I*`-Interface-Klassen in 18 Dateien** allein unter `libs/cache_engine/anatomy/` (`/usr/bin/grep -rn "^class I[A-Z]" anatomy/*.hpp`) — Genus-Tier-Verträge und Sub-/Capability-Interfaces zusammen.
- **Gattung (Ebene 1) hat VIER Werte, nicht drei** — heute selbst am Objekt gelesen: `anatomy_base.hpp:60` `Map = 0`, `:61` `Container = 1`, `:62` `Graph = 2` (Stub), **`:89` `HeuristikAdapter = 3`**. `gattung_name()` hat vier switch-Fälle. Eingebracht durch Commit `ea275c96` (09.08.2026, „HY-A1: Gattung HEURISTIK-ADAPTER anlegen"), Vorfahre von HEAD.
- **Genus (Ebene 2) hat sechs Werte, einer davon ABI-unsichtbar** — `anatomy_base.hpp:169` (**nicht 170**, dort steht die schließende `};`): `FunctionInterfaceReroute = 5 ///< Reroute-Genus der Gattung HeuristikAdapter -- NIE von genus()`. Der Zahl-erzeugende Mechanismus liegt aber **in einer anderen Datei**: `hybrid/heuristik_adapter_klassifikation.hpp:210-221` (`ist_abi_sichtbares_genus()`, `abi_sichtbare_genus_anzahl()`) mit `static_assert(kPruefDockPflichtigeGenusAnzahl == 5, …)` bei `:234-238`.
- **Zwei-Schichten-Bauform an der WURZEL, aber ausdrücklich NICHT an den Achsen:** `execution_engine_base.hpp:9-11` „Zwei-Schichten-Architektur (analog AnatomyBase Teil 4): 1. `ExecutionEngineConcept` — Compile-Time C++23 Concept (Static Dispatch) 2. `IExecutionEngine` — Virtual Interface (Runtime ABI für Module-Loader R5.E)". Auf Ebene 3 gilt das Gegenteil: `organ_concept.hpp:33-35` „C++23-Concept + CRTP-Wachen-Basis nach dem Repo-Goldstandard … CT-statisch, zero-cost, dispatch-frei — **keine vtable, kein Runtime-Switch**". Grund (Doku 14, Z.1111-1112): das virtuelle Interface existiert für den `dlopen`/ABI-Grenzübertritt; Achsen überqueren diese Grenze nicht einzeln.
- **Sieben Fläche-2-Verantwortlichkeiten sind im Ledger SOLL-zerlegt** (KON7-04, Ledger:456-464): `version_xyz()` nur Planer · `mess_zeile()` CEB·Tier·Hybrid · `system_zeile()` CEB·Tier·Hybrid · `organ_zeile()` Tier·Hybrid · `fingerprint_sha()` alle vier · `gesamt_stempel()` alle vier · `angeschlossene()` NUR Hybrid, Laufzeit. **Am Objekt leben sie in vier der fünf bekannten Dateien, mit vier verschiedenen Namensschemata und ohne gemeinsame Basisklasse** (aus Bericht, nicht nachgemessen).
- **Meta-Meta-Achsen:** Organ-Meta-Meta-Typliste ist **leer**; bei System existiert genau **eine** Familie (SIMD) — `ce abi/anatomy_version_stamp.hpp:42-46`; vom Owner als „zu recherchieren" markiert (KON8-12).

### WAS FEHLT

- Die vollständige Liste der Interface-**Arten** mit je zugeordnetem Versionierungs-**Punkt**. Der Auftrag ist gestellt (KON9-07), nicht beantwortet.
- `IExecutionEngine` ist im Ledger als eigene Interface-Art nicht diskutiert (0 Treffer als exakter Bezeichner; Gegenprobe `IPruefDock` = 8 Treffer im Ledger).

---

## (f) SONSTIGE NEUE OWNER-FESTLEGUNGEN DIESES KONTEXTES (NICHT IN KON6…KON8-12)

Alle sechs aus dem älteren Rohtranskript `46375cdc-821a-4bf9-93d4-fe0a5687f489.jsonl`, alle OWNER-WORT, alle als **neu** markiert. **Das ist der ungedeckteste Teil des Auftrags** — er ist in keinem der Nachträge KON6…KON10 erkennbar verarbeitet.

| # | Datum | Zeile | Owner-Wort |
|---|---|---|---|
| f-1 | 08.07.2026 19:55:39 | :17252 | „Die runtime Profile müssen ein hybrid aus compile time und runtime werden, um dem Experiment Baum zu entsprechen (Hinweis am Rande)" |
| f-2 | 10.07.2026 08:04:48 | :22326 | „Nennen wir also die Phase nach dem Arbeitsmodus am besten Hybrid-Modus (hybrider Arbeitsmodus und Messung wall clock time + makro/micro benchmarks per command pattern)" — **Genesis des Begriffs „Hybrid"** |
| f-3 | 10.07.2026 17:06:14 | :23760 | „Die Auswertungen ergeben automatisch eine Filterkette und das Design Pattern der Chained Responseabilities. Dieses sollte strikt im Bereich der CacheEngineBuilder für die Kontrolle der Tier-Binary Generierung umgesetzt werden." — **Genesis der Filterkette, drei Wochen vor dem 11.08.-Anker** |
| f-4 | 10.07.2026 21:17:10 | :24438 | „Dazu gib es eine weitere \"Dimension\" im Baum bezüglich der Abläufe, die wir genannt haben, die über bauen, messen, auswerten und Hybridmodus ein Builder Pattern über ein state pattern liefern." |
| f-5 | 16.07.2026 17:54:13 | :43141 | „Da per Plan die Systemachsen in der CacheEngineBuilder liegen (und dort hinein kompiliert werden), liegen die anderen Achsen VON der CacheEngineBuilder EINKOPILIERT IN den Tier-Binaries." — **Grundverdrahtung System vs. Organ** |
| f-6 | 17.07.2026 08:11:30 | :45022 | „H-10: Ja genau, vor allem gilt die statische Kompilation einer CacheEngineBuilder oder Tier-Binary als IMMER zu versionieren und in Metadaten für dieses Binary daneben zu dokumentieren." — **Versionierungspflicht als Owner-Regel, älter als jede KON-Nummer** |

**f-3 ist der wichtigste Einzelbefund dieses Blocks:** er datiert die Filterkette auf den 10.07. und benennt sie als CoR im CEB zur **Kontrolle der Tier-Binary-Generierung** — inhaltlich exakt die Rolle, die der Owner am 11.08. als „Mechanismus der Selbstkompilation" beschreibt. Damit ist das „Du hattest das schon entworfen" für die **Rolle** belegt, für die **mp11/concept-Bauform** dagegen nicht.

---

## 3. WIDERSPRÜCHE — NICHT GEGLÄTTET

**W-1 — Organ und der Hybrid-Einschub, zwei Aussagen derselben Nacht.**
KON7-03 (Ledger:437-438): „Durch den Hybrid dehnen sich die Ketten auf 4 / 3 / 2; **Organ bleibt hybrid-unberührt**."
Agent-Zuordnung unmittelbar nach der Owner-Antwort (`.claude/jobs/5a19728e/tmp/owner-antworten-20260811-nacht-ABC.md`, 17:42:50.975Z): „DREIPHASIG (Mess ohne Hybrid; **System/Organ MIT Hybrid**) → eigene Grammatik."
Beide vom 11.08. Wenn Organ hybrid-unberührt bleibt, kann es kein „System/Organ MIT Hybrid" geben. **Ungeklärt, muss vor jeder Umsetzung fallen.** (Die Zuordnung ist AGENT-BEHAUPTUNG, das KON7-03-Zitat PLAN — keine der beiden ist Owner-Wort.)

**W-2 — Concept-Zahl: 321/228 (Bericht) gegen 339/229 (heute selbst gemessen).**
Die Differenz ist **exakt aufgeklärt**: 18 `concept`-Deklarationen in `tests/unit/test_a8s3_sa_organ_member_vollstaendigkeit.cpp:65-82`, eingebracht durch Commit `51d37cd3` vom **04.08.2026**. 339−18 = 321, 229−1 = 228. **Die Bericht-Zahl ist ein Stand von vor dem 04.08., dem zitierten Commit 670483c0 (11.08.) fälschlich zugeschrieben.**

**W-3 — mp11-Zahl: 687/186 (Bericht) gegen 350/169 bzw. 726/204 (heute selbst gemessen).**
Keine der beiden Bericht-Zahlen reproduziert sich mit einem der beiden naheliegenden Filter. **Die Zahl ist nur mit explizit genanntem Filter zitierbar** — der Bericht nennt keinen. Empfehlung für den Nachtrag: **350 Fundstellen in 169 Quellcode-Dateien**, Filter mitschreiben.

**W-4 — Gattungs-Zahl: „exakt drei" gegen VIER am Objekt.**
Der Befund beschreibt korrekt den Stand **bis 08.08.**; Owner GO-3 vom 08.08. (Ledger:2488) und Commit `ea275c96` vom 09.08. machen daraus vier. Die Datei sagt es selbst (`anatomy_base.hpp:67`): „Der Kopf-Kommentar oben sagte 'NUR 3' — das war der Stand bis heute und bleibt als Historie lesbar; **die lebende Zahl ist VIER**."

**W-5 — Selbstkompilations-Doktrin gegen gebauten CEB-Pfad.**
SOLL (Fork A geschlossen): „Der Planer bestimmt das Messsystem und kompiliert HART ein effizientes CEB je Messsystem … **kein Runtime-Konfigurieren**." IST laut Audit 05.08.: `ceb:build` baut den generischen Treiber, `[a,b,c]` zur Laufzeit per Environment-Variable. *(aus Bericht, nicht nachgemessen)*

**W-6 — Rechenfehler in einer weitergegebenen Zahl.**
`memory/reference_versionierung_soll_je_stufe_owner_orientierung_20260810.md:85-88` nennt „153 `static constexpr algo_version` … (96× 1.0.0.c, 2× 1.0.1.c, 24× 1.0.2.c)". **96+2+24 = 122, nicht 153.** Die Zahl trägt einen internen Widerspruch und darf nicht weitergereicht werden.

**W-7 — Zeilenanker sind instabil.**
KON8-04 wurde als `:165-168` zitiert; der Wortlaut steht heute bei **`:706`** (im Zwischenstand bei `:531`). Der Ledger wird von mehreren Agenten gleichzeitig beschrieben. **Anker im Nachtrag über die KON-Kennung setzen, nie über absolute Zeilennummern.** Gleiches gilt für `algo_semver.hpp` und `catalog_codegen.cmake` (`:27-37` → `:52-60` durch einen am 06.08. eingefügten Kommentarblock).

---

## 4. ENTLASTUNGEN — GEFALLENE BEFUNDE, DIE BAU-ARBEIT SPAREN

Elf Befunde sind in der Gegenprobe gefallen. **Neun davon sind reine Zitat-/Anker-Mängel bei intakter Substanz** — das ist die wichtigste Nachricht: es ist nichts neu zu bauen, es ist zu korrigieren.

| # | Entlastung | Was dennoch gilt |
|---|---|---|
| **E-1** | Das 17:41-Owner-Zitat war **still gekürzt**: die Klammer endet im Original mit „, siehe letzter Kontext und auch sonst" — ohne Auslassungszeichen weggelassen. | Stelle, Zeitstempel (`:42174`, 17:41:20.756Z) und Kontext (Antwort auf Frage B) sind bestätigt; kein Widerruf in den folgenden 13 Minuten (`:42183-42292`). |
| **E-2** | KON-34 ist **nicht** „die doktrinäre Wurzel mit Datum vor allen anderen Funden": im selben Batch tragen KON-30/31/33 **25.06.2026**, KON-08 sogar **05.05.2026**. Die Quelle räumt zudem selbst ein: Gegenprobe `g++15.3` = 0, `GNU 15.3` = 0 — der Wortlaut ist im Rohkorpus nicht auffindbar, das Nachbar-Label „FEHLT, MIT VORBEHALT" fehlt bei KON-34 trotz gleichem 0-Treffer-Befund. | Die **maßgebliche** Fassung der Regel ist KON6-05 (Ledger:762-764, „Die Festlegung steht seit dem 09.08."), ohne Vorbehalt und mit Präzisierung vom 10.08. **Für den Nachtrag KON6-05 zitieren, nicht KON-34.** |
| **E-3** | Der Planer-Kommentar `apps/experiment_planner/main.cpp:4-6` enthält **zwei getrennt in Anführungszeichen gesetzte** Owner-Aussagen (vormittag: „zwingend eigene Binary"; mittag, Antwort auf eine Zeitpunkt-Frage: „Definitiv vor Abgabe…"), verbunden durch das redaktionelle Label „Begruendung des Owners:". Die Zuschreibung „Voraussetzung für die Selbstkompilationskette, nicht Kosmetik" steht **nicht** im Code (0 Treffer für beide Begriffe projektweit). | Der Owner-Wille selbst ist **vierfach unabhängig** belegt (Ledger vormittag-4 + mittag-1, Ernte-Journal D-67, Session-Backup `20260805-w1-planer-split`) und **erfüllt**: `apps/experiment_planner` → `comdare-experiment-planner`. Kein Bauauftrag. |
| **E-4** | Das `add_custom_command`-Zitat aus `catalog_codegen.cmake` unterschlägt unmarkiert eine ganze `COMMENT`-Klausel (Zeile 59). | Substanz **stärker** als behauptet: der BAUPLAN nennt diesen Block wörtlich „Codegen-Naht-**VORBILD**" als Blaupause für `comdare_experiment_planner`. Mechanik (reines CMake, `VERBATIM`, keine Shell) am Objekt bestätigt. |
| **E-5** | Die Concept-Zahl 321/228 ist ein Stand von vor dem 04.08. (siehe W-2). | `set(CMAKE_CXX_STANDARD 23)` bei `CMakeLists.txt:16` und der Kommentar bei `:14` sind **exakt** bestätigt. Korrekte heutige Zahl: **339/229**. |
| **E-6** | `selection_filter_chain.hpp` ist **nicht** „das einzige Code-Objekt mit dem Wort Filterkette + CoR" — es enthält das Wort gar nicht (nur „Filter-Kette", `:104`). | Es gibt **drei** CoR-Substrate: `dynamic_axis_filter.hpp:2` (trägt „Filterkette" wörtlich, virtuell), `selection_filter_chain.hpp` (virtuell), `ram_probe_chain.hpp:161` (**concept-basiert**, `:483` „Kein virtual: die CoR ist hier statisch verdrahtet"). **Die concept-basierte CoR-Bauform existiert im Repo bereits** — das verkürzt den Weg zu KON9-06 erheblich. |
| **E-7** | KON8-04 wurde mit falscher Zeile zitiert (siehe W-7). | Der **Wortlaut** ist zeichengenau bestätigt; nur der Anker war falsch. |
| **E-8** | Die Zwei-Schichten-Bauform (Concept + virtuelles Interface) gilt **nicht** für „JEDE Anatomie-Ebene". Auf Ebene 3 gilt ausdrücklich das Gegenteil, mehrfach repliziert und im Code als „Repo-Goldstandard" bezeichnet. | Für die **Wurzel** (ExecutionEngine, AnatomyBase) ist sie belegt, mit klarem Grund: `dlopen`/ABI-Grenze. **Achsen brauchen kein virtuelles Interface — das spart Bau-Arbeit an 18 Organ-Achsen.** |
| **E-9** | `IExecutionEngine` ist **keine neue** Interface-Art: erste Erwähnung 13.05., Code 26./27.05. (`f7d156d7`, `74748864`), eigenes Architektur-Kapitel (Doku 14 §33-§40), Reaffirmation im Gesamtdossier vom 07.08. — 235 Dateien / 760 Zeilen unter `super/docs/`. | Einziger echter Nichtfund: `MEMORY-DETAIL.md` = 0 Treffer. **Das ist eine Index-Lücke, kein Neufund** — und damit ein Doku-Auftrag, kein Explore-Auftrag. |
| **E-10** | „Gattung = exakt drei Werte" ist überholt (siehe W-4). | „Graph ist Stub" (`:62`) gilt unverändert. |
| **E-11** | `FunctionInterfaceReroute` steht auf Zeile **169**, nicht 170 (170 = `};`, aus Commit `1262a9ba5` vom 26.05.). Die Behauptung „das ist der exakte Mechanismus hinter fünf ABI-sichtbar" trägt diese Stelle nicht. | Sechs Genus-Werte und das `genus()`-Verbot sind bestätigt (`:169` + Kommentarblock `:292-313`). Der zählende Mechanismus liegt in `heuristik_adapter_klassifikation.hpp:210-221` + `static_assert` `:234-238`. |

---

## 5. NICHTFUNDE MIT GEGENPROBE

### 5a. WEITERHIN GÜLTIG (am Code-Objekt, von der Ledger-Bewegung unberührt)

| Nichtfund | Gegenprobe (Werkzeug greift) |
|---|---|
| Keine Ordnungs-/Teilmengenfunktion für die algo_semver-Flag-Grammatik: `teilmenge\|domin\|ordnungsrelation\|hoeher` = 0 in `flag_grammar_catalog.hpp` (755 Zeilen, 115 `static_assert`) | dieselbe Funktionsklasse existiert real für BVSET: `bvset_ist_teilmenge`, `builder/bvset_teilmenge.hpp`, 187 Zeilen = 1 Treffer |
| Keine vierte Klammer-Gruppe: `[a,b,c][d,e,f][g,h,i][` = 0 im ce-Baum | Drei-Klammer-Form mehrfach belegt: `plan_legend.hpp:142`, `bestandslog_document.hpp:117-121` |
| Keine GPU/FPGA/NPU-Laufzeiterkennung: `detect_gpu\|gpu_available\|fpga_available\|npu_available\|discover_*` = 0 in ce (rc=1) | „reserviert, nicht produziert" = 7 Treffer an 5 benannten Stellen |
| `set_active_machine_declaration(` als Produktionsaufruf = 0 außerhalb `tests/` | derselbe Aufruf = 6× in `test_c3a_gate_scharfschaltung.cpp` + 1× in `test_o4_machine_identity.cpp` |
| Kein `concept`-Bezeichner spannt zwei Träger-Stufen im Namen = 0 | `CacheEngineBuilder` = 79 eigene ce-Dateien, `CEB` (Wortgrenze) = 178 Dateien |
| `mp11` in `simd_build_gate.hpp` (dem funktional nächstliegenden Objekt) = 0 | `mp11` in 169 anderen Quellcode-Dateien (350 Fundstellen) |
| Acht der neun geplanten Hybrid-Dock-Dateien = 0 Treffer je Dateiname | `heuristik_adapter_gate.hpp` = 1 Treffer (`find`) |
| `DockSlot` als echter C++-Typ = 0 (nur Kommentar `heuristik_adapter_strategy.hpp:38`) | `class IPruefDock` = 1 Treffer |
| `HY-A2`/`HY-A3`/`HY-B1`/`HY-B2` als Commit/Branch = 0 über 228 Branches | `HY-A1` als Commit-Message = 3 Treffer |
| Keine „Fläche 3" in beiden großen Sessions = 0 (inkl. Encoding-Varianten) | „Fläche 1" = 11×, „Fläche 2" = 32× in derselben Datei |
| „Lebenslagen" in `46375cdc-…` = 0 | dasselbe Wort = 8× in `5a19728e-…` |

### 5b. DURCH DIE LEDGER-BEWEGUNG ÜBERHOLT — NICHT MEHR ALS NICHTFUND FÜHREN

Alle folgenden waren als „0 Treffer im Ledger" gemeldet und sind **heute belegt** (Nenner 20.973 Zeilen): `KON9` (12 Abschnitte, Zeile 194-561) · `Multiplexer` 2 · `Verteiler` 1 · `Stecksystem` 1 · `Handlanger` 1 · `Parameterfunktion` 2 · `VIERPHASIG` 2 · `Selbstkompil` 8 · `add_custom_command` 1 · `mp11` 23.
**Gegenprobe, dass die Bewegung echt und nicht ein Suchartefakt ist:** `dreiphasig` ist von 21 auf 24 gestiegen, die Datei von 20.430 auf 20.973 Zeilen, und die Abschnittsköpfe KON10-01…08 / KON9-01…12 sind namentlich auslesbar.

### 5c. NICHTFUND OHNE VERWERTBARE GEGENPROBE — ALS SOLCHER AUSWEISEN

Fundstellen im Workflow-Rohergebnis-Korpus (`/tmp/claude-1001/-home-comdare/*/tasks/*.output`) zu `system_axis_host_supports_simd`/Filterkette: eine Datei existierte kurzzeitig und war beim Nachlesen durch parallele Agenten-Aufräumung entfernt. **Keine zitierfähige Fundstelle; dieser Korpus ist flüchtig und darf nicht als Beleg dienen.**

---

## 6. DREITEILUNG

### BAU-AUFTRAG (entschieden, Weg klar, nur zu bauen)

1. **Voraussetzungs-Wache für Flag-Abhängigkeiten** in `algo_semver.hpp` — die Lücke ist im Code benannt (`:1525-1528`) und per `static_assert` bewiesen (`:1533`), die Andockstelle steht seit 07.08. (`:73`). Vorbild liegt vor: `bvset_ist_teilmenge` (`builder/bvset_teilmenge.hpp`, 187 Zeilen).
2. **Gemeinsame Stempel-Basisklasse**, von der je Achsen-Typ geerbt wird (Owner 11.08. 13:41, KON7-08). Heute fünf lose Strukturen ohne Basis, vier Namensschemata.
3. **`set_active_machine_declaration` in der CEB tatsächlich rufen** — heute 0 Produktions-Aufrufer, der rohe CPUID-Fallback ist laut Code-Kommentar „der Normalfall".
4. **Filterkette als concept bauen, nicht erfinden.** KON9-06 sagt es bereits; und `ram_probe_chain.hpp:161` zeigt, dass die concept-basierte CoR-Bauform im Repo existiert (`:483` „Kein virtual"). Der Weg ist: bestehende CoR-Substrate auf diese Form ziehen.
5. **Vierte Klammer-Gruppe** in der Testat-Grammatik für die vierphasige Mess-Zeile (0 Treffer heute).
6. **`ceb:build` von der Environment-Variablen-Laufzeitwahl auf harte Kompilation je Messsystem umstellen** — Verstoß gegen den Kernsatz, „durch KEINEN Deferred-Posten gedeckt" *(aus Bericht, nicht nachgemessen; vor dem Bau am Objekt gegenprüfen)*.
7. **`ci/tests/*.sh` → Google Tests.** Heute selbst gemessen: **14 Dateien / 8.528 Zeilen**, gegen 13/7.967 in KON6-05 vom selben Tag. **Die Regression wächst.**

### OWNER-ENTSCHEID (nicht durch einen Explore auflösbar)

1. **W-1: Wirkt der Hybrid-Einschub auf Organ oder nicht?** KON7-03 sagt „Organ bleibt hybrid-unberührt", die Grammatik-Zuordnung setzt „System/Organ MIT Hybrid" als dreiphasig. Zwei Aussagen derselben Nacht, beide nicht Owner-Wort. **Ohne diesen Entscheid ist die Grammatik-Zahl nicht schneidbar.**
2. **Semantik der Voraussetzungs-Wache:** „fordert das Flag die Voraussetzung, oder impliziert es sie?" — der Code stellt die Frage selbst (`algo_semver.hpp:1527-1528`) und beantwortet sie nicht.
3. **K1 (Lager-Identität der Hybrid-`.so`) und K2 (Loader-Schichten-Zuordnung)** müssen vor dem ersten Linken fallen; **K5** (Snapshot-Aggregations-Semantik) ist ausdrücklich unentschieden.
4. **Meta-Meta-Achsen von System und Organ** — vom Owner selbst als „zu recherchieren" markiert; am Objekt: Organ-Liste leer, System hat genau eine Familie (SIMD).

### DOKU (Nachtrag/Korrektur, kein Bau)

1. **Block (f): sechs Owner-Festlegungen vom 08.–17.07.** in den Ledger holen — insbesondere **f-3** (Filterkette-Genesis 10.07., beantwortet „Du hattest das schon entworfen" für die Rolle) und **f-6** (H-10 Versionierungspflicht, älter als jede KON-Nummer).
2. **Die elf Entlastungen E-1…E-11 als eigenen Abschnitt schreiben.** Neun davon sind Zitat-/Anker-Korrekturen bei intakter Substanz — sie sparen Bau-Arbeit und verhindern, dass ein Fehlzitat weiterwandert.
3. **Vier Zahlen korrigieren, mit Nenner:** Concepts **339/229** (nicht 321/228) · mp11 **350/169 Quellcode** (nicht 687/186, Filter mitschreiben) · Gattung **VIER** (nicht drei) · Genus-Reroute **Zeile 169** (nicht 170).
4. **W-6: die 153-Zahl aus dem 10.08.-Memory zurückziehen** — 96+2+24 = 122, interner Rechenfehler.
5. **W-7 als Arbeitsregel festhalten:** Ledger-Anker über KON-Kennungen, nie über absolute Zeilennummern — die Datei wird von mehreren Agenten gleichzeitig beschrieben (20.430 → 20.973 Zeilen während dieser einen Erhebung).
6. **`IExecutionEngine` in `MEMORY-DETAIL.md` nachtragen** (heute 0 Treffer dort, 235 Dateien in `super/docs/`) — die Index-Lücke hat einen Neufund vorgetäuscht.
7. **Der Nachtrag ist gegen KON9 und KON10 zu schneiden, nicht als Erstschrift** — beide sind bereits im Ledger.