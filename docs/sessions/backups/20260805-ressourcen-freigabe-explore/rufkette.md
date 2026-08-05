# LENS ruf-kette — Die geplante REKURSIVE RUF-/TAKT-Kette (nicht nur Bau-Kette)

> READ-ONLY-Erhebung 2026-08-05. Alle Zitate verbatim mit Fundstelle.
> Quellen (KOMPLETT gelesen): MEM = `/home/comdare/.claude/projects/-home-comdare/memory/` —
> `feedback_kette_planer_mess_ceb_system_tier_organ_hybrid.md` + `feedback_recursive_dock_planer_ceb_tier_abi_stable_so.md`
> + `feedback_ceb_drei_modi_arbeitsmodus_hot_tier_switching.md` · LED = super
> `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (§30 :2249-2266, §36 :2326-2338, §37/§37.b :2340-2358,
> §38/§38.b :2360-2378, §40.b :2399/:2403, §42/§42.b :2419-2431, Nachträge vormittag-4 :4021-4027,
> mittag-1 :4029-4033, mittag-4 :4050-4058, mittag-6 :4060-4065) · Kette-Audit super
> `docs/sessions/backups/20260805-planer-ceb-kette-audit/{soll,synthese,ist-ceb}.md` · Topologie-Berichte
> `scratchpad/topologie/{vertraege,heuristik}.md` (vorhanden, eingearbeitet).

---

## 0. Der Kanon-Satz der Ruf-Kette (drei Stufen, verbatim)

**§40.b-PRÄZISIERUNG (User 19.07. spät, LED:2403, verbatim):**
> „Der **Experiment-Planer steuert die Bau-Jobs von CEBs** und die **CEBs steuern Bau-Jobs von Tier-Binaries**." — „Keine Stufe überspringt die andere; die Tier-Job-Emission ist CEB-Hoheit (§37.b-Delegation), nicht Planer-Hoheit."

**§30.6 (User 19.07., LED:2259, verbatim):**
> „**3 bis 4 Binaries in EINER Kette**, die **vom Kopf bis Fuß top-down nacheinander in sequentieller Abhängigkeit, Steuerung und Ausrichtung GENERIERT werden**: Der **Planer bestimmt das Messsystem und kompiliert HART ein effizientes CEB** für dieses Messsystem → der **CEB kompiliert Tier-Binaries** mit den gewünschten Organ-Achsen → und der **CEB kann nach der Auswertung der Messung noch effizientere Heuristik-Hybrid-Tier-Binaries entwickeln, die ihrerseits echte Tier-Binaries delegiert durch CEB entwickeln und laden können** (rekursive Delegation …)."

**F6-ZIELBILD-KERN (Owner 05.08., LED:4062 mittag-6 + MEM feedback_kette:27, verbatim):**
> „**Der Planer taktet zukuenftig selbst, er baut und ruft seine CEBs und diese bauen und rufen die Hybriden (mit anhaengigen Tier-Binaries) oder die Tier-Binaries selbst.** Das ist umfassend geplant, wo ressourcen freigegeben werden (Explore)."

Damit ist die Kette EXPLIZIT eine **RUF-Kette** (bauen UND rufen), nicht nur eine Bau-Kette. Das rekursive Muster: „= dasselbe Dock/ABI-stabile-.so/Vertrags-Muster REKURSIV (Planer→CEB gespiegelt zu CEB→Tier-Binary, geteilte Concepts)" (MEM feedback_recursive_dock:19).

---

## 1. WIE ruft der Planer eine CEB AUF?

### 1.1 Kanon-Mechanik HEUTE-SOLL = JOB-EMISSION (Dynamic-Child-Pipelines), kein Prozess-Start

- **§40.b (LED:2399):** „Planer-Binary läuft als CI-Stufe nach build, liest die Experiment-XML, erkennt die CEB-Eigenschaften und **EMITTIERT die Folge-CI selbst** (GitLab Dynamic-Child-Pipeline: generierte YAML als Artefakt + trigger/include). Kette: **Planer→Child-1 (CEB-Bau je Messsystem/Maschinen-Signatur)→CEB emittiert Child-2 (Tier-Binary-Jobs)** = echte dynamische CI-Jobs, Steuerung im Planer→CEB (nicht in handgeschriebener YAML)." — CiYamlBuilder (Bauplan I3/Fork C).
- **Bare-Metal-Zwilling §40.c (LED:2400):** identischer Bau OHNE CI — CMakeGraphBuilder emittiert `experiment_plan.cmake` mit „echte[n] Treiber-Kommandos je Zelle; ein Bare-Metal-Lauf = cmake-Aufruf des emittierten Plans"; CI-YAML und CMake-Plan „topologie-isomorph (Contract-Test)". [ERLEDIGT-Vermerk LED:2633: W10-A-Refactor + A8(c)-Re-Beweis.]
- **Der „Aufruf" ist also heute die Emission eines Bau-+Lauf-Jobs**, nicht ein dlopen/exec des Planers: Der Planer-Director-Walk (ExperimentPlanDirector, EIN Walk, 6 ConcreteBuilder) emittiert je `<measurement_tooling>`-Combo [a,b,c] eine `ceb:build`-Strecke (synthese.md Glied 3: „Fan-out multipler CEBs je Combo real, measurement_combos_of :1909-1927; leer => [all] = vereinter Tooling-Default §64").
- **Vertragsform am Experiment-Dock (Ebene 1):** Nutzlast hinab = serialisierter unterer B+-Teilbaum als **RANGES je Achse** (§38.1, LED:2363); **Ist-Vertrag = TEXTEMISSION** (emittierter CMake-/YAML-Text + Env), das volle Wire-Format `ExperimentSubtreePayload` ist „Band-C DEFERRED (Task #19)" bewusst markiert (experiment_dock_payload.hpp:57-64, synthese.md Glied 4); .so-ABI = R1-Post-v3-Prüfstrang (Owner mittag-6 R2: „FORMAL BESTAETIGT — Textemission Abgabe-Kette; #35-.so nur Steuerung als erste Nach-Abgabe-Position").
- **IST-Verstoß (Fork-A, Regression R-G3):** der emittierte ceb:build-Job baut stets den GENERISCHEN Treiber (`cmake --build build --target comdare-messung-driver`, director:769-781); [a,b,c]-Differenzierung zur LAUFZEIT per `COMDARE_MEASUREMENT_COMBO` = „exakt die von §30.6 ausgeschlossene Runtime-Konfiguration" (synthese.md Glied 3). Owner-Entscheid mittag-6 R1: **W2-Interim = -D-COMPILE-DEFINE + Stempel-Wirkung** im emittierten Job (Codegen-Zielform als Nach-Abgabe-TODO).

### 1.2 KÜNFTIG (Zielbild F6): Planer RUFT DIREKT und TAKTET SELBST

- Owner mittag-6 R6 (LED:4063): „**DER PLANER TAKTET ZUKUENFTIG SELBST** — er baut und ruft seine CEBs, diese bauen und rufen die Hybriden (mit anhaengigen Tier-Binaries) oder die Tier-Binaries selbst; die **RESSOURCEN-FREIGABE-Planung existiert umfassend im Korpus -> EXPLORE-Pflicht** (Welle gestartet; **resource_group bleibt Ist-Traeger bis zur Planer-Takt-Umsetzung**)."
- MEM feedback_kette:27 (Einordnung): „Die rekursive RUF-Kette (nicht nur Bau-Kette) ist Zielbild: Planer taktet die CEB-Sequenz SELBST (resource_group nur Ist-Traeger bis dahin); Ressourcen-Freigabe-Planung liegt im Korpus (Systemachsen-Freigabe/Pool/Locking) und ist vor W1-Design per Explore zu erheben."
- Ressourcen-Freigabe-Korpus (der Takt-Unterbau): §36-Pool-Modell (Node-bevorzugte System-Achsen-Builds unter LOCKING, `resource_group` je Zelle + MinIO-Dedup als 2. Schicht, LED:2329/2335) · §37/§37.b-Freigabe-Kopplung (System gibt frei, Organ ≤ Zulassung; Freigabe-Auswertung = CEB-LAUFZEIT-Logik an der Bau-Delegations-Naht, LED:2356-2358) · §36.2: „Ein Experiment-Planer kann MULTIPLE CEBs bauen" (LED:2330).
- Vom Owner autorisierter #54-Kern (soll.md 5.6, LED §62-B :3315 verbatim): „der Planer wird aufgerufen, die **CEB per XML-ANWEISUNG zu INSTRUMENTIEREN**, um mit ihr Batches von Tier-Binaries zu bauen und auf Mess-Tauglichkeit zu pruefen"; „die CEB **PIPED ihre Shell-/Status-Ausgaben an den Planer**". Endform per Owner mittag-6 R4 = **dedizierte XML-Anweisungs-Datei, Endform gleich, Position NACH Abgabe**.

---

## 2. WIE ruft die CEB einen Hybrid ODER eine Tier-Binary AUF?

### 2.1 Tier-Binary direkt: kompilieren → dlopen am PRÜF-DOCK → GATE → antreiben

- **Prüf-Dock (Ebene 2, bidirektional, MEM feedback_recursive_dock:13 verbatim):** „Die CEB … hat ihr EIGENES **Prüf-Dock** — ein **bidirektionales** Prüf-Dock zu seinen verschiedenen Arten von Tier-Binary-.so-Interfaces (**CEB treibt an ↔ Tier-Binary meldet Messergebnisse ABI-stabil zurück**). Dort kompiliert die CEB die C++23-ABI-stabilen Tier-Binary-.so-Module."
- **Ruf-Mechanik IST (belegt):** je gebaute DLL `AnatomyModuleLoader::load` → `IObservableTier` (ist-ceb.md:163; alte Welt Phase 4 „dlopen-Load" :28); lazy Kette StaticBinaryView O(K) → AnatomyModuleLoader → RuntimeVariableLoop (synthese.md L1-6). „je Anatomie-Gattung EIN Prüf-Dock … IPruefDock ist KEINE ABI-Grenze (lebt im Builder-Binary); die ABI-Grenze ist das gattungs-eigene Antriebs-Sub-Interface" (ist-ceb.md:210-211).
- **Warte-/Gate-Punkt vor jedem Messen:** „Reihenfolge bindend: **import → GATE → (nur bei pass) messen**" (conformance_gate.hpp:1-9); §62-B: erst Build+Prüf-Batch, „nach Durchlauf erst die Messung" (soll.md 5.4). Antrieb danach per Command-Doktrin (Command-Pattern-Achsen/Mess-Visitor; Live-Nachfolger = compile-time AxisCommand, synthese.md Abweichung 4 — architektur-konforme Fortschreibung).
- **Bau-Delegation (§37.b, LED:2356 verbatim):** „die CEB bestimmt zur Laufzeit aus ihren System-Achsen-Freigaben, was gebaut werden darf, und **delegiert eine Kompilation der Organ-Achsen eines Tier-Binaries** …" — Pfad `BuildOrchestrator::provision_all`/CompileFn IST diese Delegation (LED:2358).

### 2.2 Hybrid-Ruf (Heuristik-Tier mit anhängigen echten Tiers)

- **Andocken:** die Heuristik „**wird SELBST zur Tier-Binary kompiliert** (**dockt am CEB-Pruefdock an**, reicht Befehle an statisch zugewiesene echte Tier-Binaries weiter = **Metaprogrammierungs-Command-Pattern**); … ABI-stabiles Gattungsinterface = als Suchalgorithmus-Huelle verwendbar (‚**virtuelles ganzes Tier-Binary**')" (MEM feedback_ceb_drei_modi:19, verbatim). Kein dritter Dock-Typ: an der Kante CEB↔Hybrid gilt derselbe PRÜF-DOCK-Vertrag (vertraege.md B.3).
- **Form (a)/(b) (MEM feedback_recursive_dock:15):** „(a) heuristisch — mit noch EINER Ebene NACH dem Command-Pattern in einer **compile-time Chain-of-Responsibilities** … oder (b) plain ein Tier-Binary am CEB-Prüf-Dock."
- **Nach unten (Rekursions-Ebene 3):** die Hybrid-Binary trägt selbst **N HYBRID-PRÜF-DOCKS** (N dynamisch einstellbar; Factory-Pattern als Proxy je Dock auf seine plain Tier-Binary, variant-DockArray = definierte Ausnahme NUR dort; Owner-E1 02.08., heuristik.md 1.2/1.3; Design `20260802-hybrid_tier_stufe_soll_design.md`, `hybrid_binary_proxy.hpp` besitzt `AnatomyModuleHandle`, `hybrid_router.hpp` = CT-CoR-Break-Even-Router). XOR-Regel je Kette (LED:2421): Tier-Binary XOR Hybrid („ausgemessene beste, no permutation und static pick").
- **Rekursive Delegation zurück über die CEB:** Hybrid-Tiers „entwickeln und laden" echte Tier-Binaries „**delegiert durch CEB**" (§30.6) — die Kompilation läuft IMMER über die CEB, der Hybrid ruft nur.
- **Arbeitsmodus-Ruf:** CEB „hält relevante Tier-Binaries hot im RAM und **switcht die Tier-Binary … unter der Haube hot auf das ABI-stabile Interface**" (MEM feedback_ceb_drei_modi:15); dasselbe Prüf-Dock heißt dann „**Arbeits-Dock**".

---

## 3. Definierte TAKT-/WARTE-Punkte der Kette

1. **§38.b-Sequenz-Takt (Planer-Ebene, DER Takt-Punkt):** „Es kann nur eine CEB gleichzeitig laufen … **Multiple CEBs laufen sequentiell**" (LED:2373 verbatim); „der §38-Fortschritts-Rück-Kanal liefert dem Planer genau das **Fertig-Signal**, mit dem er die **nächste CEB erst nach Abschluss der vorigen** startet (Sequenzierung über den Rück-Kanal — ohne ihn keine Allein-Lauf-Garantie)" (LED:2376). Abgrenzung: der §35/§36-BAU-Pool bleibt parallel — Sequentialität gilt fürs MESSEN (Debug parallel ohne Garantie, §32-F1/F7).
2. **§38-Fortschritts-Cursor (Permutations-Takt):** hinauf „**sparse immer nur die Achse(n) … die für eine neue Permutation und Erzeugung der nächsten Tier-Binary notwendig sind**" (LED:2364) — Mixed-Radix-Deltas, KEIN Mess-Daten-Rückfluss; IST: ProgressDelta/progress.cursor real, aber „REINER BEOBACHTER … der Sink beobachtet den Cursor, er steuert nichts" (driver main.cpp:1391-1394) — **kein Rück-Leser, keine Planer-Sequenzierung** (Regression R-G4/5, synthese.md Nr. 5).
3. **CI-Ist-Träger des Takts:** globale `resource_group` (ceb-measurement-exclusive; am Objekt `ceb-measure-<host>` an Build- UND Mess-Batch, director:1104/:1239) + `ceb-<slug>`; per Owner mittag-6 R6 ausdrücklich „Ist-Traeger bis zur Planer-Takt-Umsetzung". Bau-Pool-Locking = resource_group je System-Permutations-Zelle (§36).
4. **Prüfstand-Gate (CEB→Tier):** import → GATE → (nur bei pass) messen; erst Build+Prüf-Batch, dann Messung (§62-B); Owner-F5-Doktrin mittag-1: ALLE Tier-Interfaces (MAP-Gattungs-Hülle) testen die REALEN Implementierungen, Deep-Research-Tests NACH dem Compile.
5. **Kompile-Reihenfolge-Wartepunkt:** CEB muss VORHER „**auf deren Observer + Module kompiliert**" sein (System-Konfiguration → Mess-Achsen-heuristische-Konfiguration), erst dann Gattungen bauen+durchmessen (MEM feedback_recursive_dock:16).
6. **Mess-Job-Granulat (§42.b, LED:2429):** „Eine Array-Permutation der HAUPT-Achsen fuer ein Tier-Binary ergibt **EINEN dynamisch angelegten MESS-Job**", der in-Job den Unter-Achsen-Sweep fährt (Compile-Wiederverwendung) und EIN CSV zurückschreibt; Mess-Achsen-Workload-Unter-Achsen permutiert der **Planer zur Laufzeit gegen alle CEBs** (Mess-Beauftragung, kein Bau).
7. **Rückschrieb ist KEIN Takt-Kanal:** CEB schreibt Messwerte SELBST ans XML-Ziel (NICHT übers Experiment-Dock); der Planer LIEST separat rück (Owner F7) — Lese-Pfad, kein Dock-Kanal (vertraege.md B.4).

---

## 4. W5-Relevanz: VOR Abgabe (Rück-Leser) vs. NACH Abgabe (Planer-Takt)

### VOR Abgabe (Fr 08.08.) — W5-Rück-Leser-Design muss tragen:
- **F7 (Owner mittag-1, verbatim):** „Ja klar, er ist eine eigene Binary und die **CEB laeuft eigenstaendig**, wie soll sonst der Planer dem User feedback ueber die zurueckgeschriebenen Messwerte und durch CEB kompilierten Tier-Binaries geben?" → Planer-Rück-Leser JA, als Teil der eigenen Planer-Binary (F1 = HARTES GO Planer-Split VOR Abgabe: „sonst die Binaries aller Stufen nicht korrekt gebaut").
- **Entschiedene W5-Form (Owner mittag-6 R5, alle drei JA):** **status-Subkommando + on-demand + Bestandslog-XML als Aggregat-Quelle**. W5-Kern liegt IN W1 (mittag-4: „status-Aggregator: progress.cursor/result.csv-Stamps/Bestandslog/Testat-Zeilen").
- **Konsequenz fürs Design:** Der Vor-Abgabe-Rück-Leser ist ein **LESE-/Aggregations-Pfad, KEIN Takt-Geber** — er konsumiert progress.cursor (§38-Cursor), result.csv-Stamps, Bestandslog-measurement-XML und Testat-Grammatik ([CEB-TESTAT]/[PRUEF-TESTAT]/[progress]/[heartbeat]) on-demand; die CEB läuft eigenständig weiter; die §38.b-Sequenzierung bleibt bei der resource_group (Owner R6). Damit schließt W5 den §52-B14-Restpunkt (1) „ProgressSink ohne Konsument" auf der LESE-Seite, ohne die Takt-Umsetzung vorzuziehen. Relevante Takt-Punkte fürs W5-Design: Nr. 2 (Cursor-Format Mixed-Radix, done-einmal), Nr. 6 (EIN CSV je Zelle als Lese-Einheit), Nr. 7 (Rückschrieb-Ziele als Quelle, nie Dock).
- Ebenfalls VOR Abgabe: W1 Planer-Split (comdare_experiment_planner; Rück-Leser wandert mit, mittag-4 F2-Antwort) · W2 Combo-Härte (-D-Define+Stempel gegen die Fork-A-Regression) · W3-Schnitt (Post-Compile-Testate der Mess-Interfaces am Dock).

### NACH Abgabe — Planer-Takt-Umsetzung + Restformen:
- **F6-Zielbild = eigentliche RUF-Umsetzung:** Planer taktet SELBST (residenter Takt statt resource_group), „baut und ruft seine CEBs", CEBs „bauen und rufen die Hybriden … oder die Tier-Binaries selbst"; VOR dem W1-Design nur die **Explore-Erhebung der Ressourcen-Freigabe-Planung** (§36/§37-Korpus) — die Umsetzung selbst ist Nach-Abgabe.
- **#54-Endform** (dedizierte XML-Anweisungs-Datei + Status-Pipe an den Planer, R4 Option b „endform gleich", Position nach Abgabe) · **R1/#35 .so-ABI-Schnitt** (nur Steuerung, erste Nach-Abgabe-Position; Vertrag = extern-C+POD+Major-Gate, CSV bleibt Daten-Transport) · **Hybrid-BAU** (Design festgeschrieben, Bau in der Auswertungsphase, Owner-E1 02.08.) · Arbeitsmodus/Hot-Tier-Switching + COMPARE #47 · System-/Mess-Achsen-Join PL-21.

---

## 5. Kompakt-Bild der Ruf-/Takt-Kette

```
Planer [Mess-Achsen; taktet KÜNFTIG selbst (F6); heute: emittiert Child-1-Jobs]
  --(EXPERIMENT-DOCK: hinab Teilbaum-RANGES [Ist: Textemission+Env, W2: -D-Define];
     hinauf §38-Cursor sparse = FERTIG-SIGNAL der §38.b-Sequenz [Ist: kein Rück-Leser])-->
CEB je Messsystem [a,b,c] — NUR EINE messend zugleich, multiple SEQUENTIELL (§38.b; Ist-Träger resource_group)
  --(PRÜF-DOCK bidirektional: kompilieren → dlopen/AnatomyModuleLoader → import→GATE→messen;
     Antrieb Command/AxisCommand ↔ Observer/Messwerte ABI-stabil zurück)-->
  ├── plain Tier-Binary .so [d,e,f][g,h,i]
  └── XOR Hybrid-Heuristik-Tier (optional, eigene Binary, dockt am Prüf-Dock an)
        --(N Hybrid-Prüf-Docks, Factory-Proxy, CT-CoR-Router; Command-Pattern an
           STATISCH zugewiesene echte Tiers; Neubau/Laden delegiert DURCH die CEB)-->
        plain Tier-Binaries
Rückschrieb: CEB SELBST → XML-Ziel (EIN CSV je Zelle) — NIE über die Docks;
Planer-Rück-Leser (W5, vor Abgabe): status-Subkommando on-demand über Bestandslog-XML/cursor/Stamps.
```
