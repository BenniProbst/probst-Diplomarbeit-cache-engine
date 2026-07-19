# FINALES DESIGN-ABSTRACT — Binary-Kette · Gesamtbaum · Registries · Anwender-XML · Resolver (Stand 2026-07-19)

## (K) Kopf

**Zweck:** Das EINE rueckfragen-taugliche Dokument zum konsolidierten Gesamt-Design nach Ledger §27–§30. Der User vergewissert das Design per Rueckfragen gegen die nummerierten DESIGN-SAETZE (D), bestaetigt/korrigiert die ANNAHMEN (A) und entscheidet die OFFENEN FORKS (F). Jeder D-Satz traegt seine Quelle; nichts hier ersetzt Ledger oder Plandokumente — es verdichtet sie.

**Quellen (autoritativ):** Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` §27 (Registry=ANGEBOT / Anwender-XML=ANZEIGE, .pom-Modell) · §28 (DREI Achsen-Art-Registries je Modul; Haupt-statisch/Unter-dynamisch) · §29 (Gesamt-Planungs-Fold, 8 Dokumente) · §30 (Achsen-Art-Stufen-Zuordnung der Binary-Kette, gefaerbter Gesamtbaum, Join-Modi — ABSTRACT FUER DEN BAU) — plus die 8 §29-Dokumente (alle in `docs/plaene/` bzw. `docs/architektur/`, alle am 19.07. um „## KONSOLIDIERUNG §30"-Abschnitte harmonisiert, soweit betroffen):

1. `20260719-gesamt-roadmap-ledger-diff-ROADMAP.md` (+§30-Konsolidierung: PL-19/PL-20/PL-21)
2. `20260719-xml-featurespace-topdown-KATALOG.md`
3. `20260719-parallelisierung-disjunkte-pakete-ANALYSE.md`
4. `20260719-new-golden-voll-xml-mock-ENTWURF.md` (+§30-Faerbungs-Tabelle je XML-Sektion)
5. `20260719-ci-kette-start-zu-gruen-DETAIL.md` (+§30-Stufen-Zuordnungs-Tabelle)
6. `20260719-registry-angebot-anwender-xml-resolver-STUFE.md` (+§30-Konsolidierung: 3-je-Art, R5=Mess-Modi)
7. `20260719-archiv-workflow-kontext-KAPSELN.md`
8. `docs/architektur/20260719-achsen-nachschlagewerk-INC2D-DELTA-NACHTRAG.md`

Dazu: `20260719-planer-ceb-tier-topdown-BAUPLAN.md` (+§30-Konsolidierung: Phase-2-Korrektur, Fork A entschieden, Hybrid-Phase).

---

## (D) DESIGN-SAETZE

**D1 — Kette aus 3–4 generierten Binaries.** Die Experiment-Ausfuehrung ist EINE Kette aus 3 bis 4 Binaries — Planer → CEB → Tier-Binaries (+ optionaler Hybrid-Einschub) —, die vom Kopf bis Fuss top-down nacheinander in sequentieller Abhaengigkeit, Steuerung und Ausrichtung GENERIERT werden. Jede Stufe erzeugt/kompiliert die naechste; nichts wird zur Laufzeit umgeschaltet. *(Quelle: §30.5/6)*

**D2 — Achsen-Art-Stufen-Zuordnung (revidiert frueherer Zuordnungen).** Planer = MESS-Achsen · CEB = SYSTEM-Achsen · Tier-Binaries = ORGAN-Achsen. Die Mess-Achsen-Permutation (16 Kategorien, Kollektoren, DynamicDims, Workload-Achse) wandert von der CEB in den PLANER; die CEB kompiliert die Tier-Binaries mit den gewuenschten Organ-Achsen. *(Quelle: §30.5)*

**D3 — Harte CEB-Kompilation je Messsystem (Fork A verschaerft entschieden).** Der Planer bestimmt das Messsystem und kompiliert HART ein effizientes CEB fuer genau dieses Messsystem — die CEB ist damit nicht nur eine .so-/Vertragsgrenze, sondern eine vom Planer GENERIERTE+kompilierte Binary je Messsystem. Bauplan-Fork A ist geschlossen; die Spiegel-Tabelle (4 Symbole/Magic-Gate/Loader/host_compatible_with) ist Ziel-Design. *(Quelle: §30.6 + Fold; BAUPLAN-KONSOLIDIERUNG Pkt. 3)*

**D4 — Hybrid-Rekursion (optionales 4. Kettenglied).** Die CEB kann nach der Auswertung der Messung noch effizientere Heuristik-Hybrid-Tier-Binaries entwickeln, die ihrerseits echte Tier-Binaries — delegiert durch die CEB — entwickeln und laden (rekursive Delegation). Knuepft an CEB-Arbeitsmodus (Dossier 19) und Heuristik-Messkurven-Typsystem (architektur/20) an; spaeteres Increment. *(Quelle: §30.6)* **→ NACHTRAG §31 (User 2026-07-19): „spaeteres Increment" REVIDIERT — der Hybrid-Einschub ist ABGABE-PFLICHT vor 28.07. („das ist mit Pflicht"); siehe Abschnitt (N).**

**D5 — Stufen-relative CT-Doktrin.** Jede Vorstufe permutiert ihre Achsen dynamisch und friert die Wahl der Folgestufe als Compile-time-Draht ein (Planer-dynamisch → CEB-CT; CEB-dynamisch → Tier-CT); im gemessenen Hot-Path gibt es weder vtable noch Runtime-Switch noch std::variant. *(Quelle: feedback_haupt_achse_static_unter_achse_runtime_chain_ct_wiring; feedback_no_std_variant_static_axes_bloat; §30-Fold)*

**D6 — EIN gefaerbter Gesamt-B+-Baum.** Alle Achsen aller drei Arten ergeben EINEN einzigen Experiment-B+-Baum, dessen Nodes je Achsen-Art GEFAERBT und filterbar sind (Faerbungs-Traeger existiert: `AxisKind{organ, system_measurement, system_config}`, `topics/axis.hpp:17-20`); der Baum wird in Achsen-Art-Teilbaeume ZERLEGT und je Stufe permutiert. *(Quelle: §30.4)*

**D7 — Lazy Staffelung der Zerlegung.** Die lazy Permutationskette wird in Achsen-Arten gestaffelt: Mess-Teilbaum→Planer-Permutation · System-Teilbaum→CEB-Kompilation · Organ-Teilbaum→binary_id (wie bisher); der Umbau (`build_all_axis_levels`/`ExperimentTree` → gefaerbte Ebenen + Zerlege-Operation) loest zugleich Audit-P6/PL-13 — EINE Baustelle, eigener Bauplan+GO, nicht golden-neutral. *(Quelle: §30-Fold; ROADMAP PL-19)*

**D8 — DREI Achsen-Art-Registries je Modul, 1:1 auf die Stufen.** Jede der 3 Achsen-Arten hat ihre EIGENE XML-Registry in IHREM Modul: Organ-Registry (ce, + prt_art als Prueflings-Organ-Angebot) · System-Registry (NEU, measurement-Modul: 6/7 CEB-System-Achsen + Unter-Achsen) · Mess-Registry (NEU, Mess-Modul: 16 Kategorien, Kollektoren, DynamicDims, Workload-Achse) — und speist exakt ihre Stufe: Mess-Reg→Planer · System-Reg→CEB · Organ-Reg(+prt)→Tier. Pfade statisch per CMake-Interface-Define. *(Quelle: §28 + §30-Fold)*

**D9 — Registry = ANGEBOTS-MANIFEST (Schema v2), aus dem Code GENERIERT.** Die Registry ist das vollstaendige, parsbare ANGEBOT dessen, was die CacheEngine compilieren/permutieren KANN — schema="2" additiv zu v1: `algo_version` je Baustein, `<flags>`/`flag_map` (Deklaration; Aufloesung bleibt CompileFn, NIE binary_id), `<sub_axis>` mit `<options>` XOR `<range>`, `materialization="ct_variant|runtime_param"` aus Code-Reflektion, `binary_id="organ|never"`. Wahrheitsquelle bleibt der Code (Enabled*-mp_lists + Wrapper-constexpr); die Generatoren emittieren, der Byte-Diff-Contract-Test bewacht (Fork R1, Empfehlung Option 1). *(Quelle: §27; STUFE §3.A + K2)*

**D10 — Anwender-XML = deklarative ANZEIGE (.pom-Semantik).** Die Anwender-XML ZEIGT AN, welche Experimente/Achsen/Einstellungen/Flags/Unter-Achsen/Ablaeufe+Ranges durchzufuehren sind, und darf AUSSCHLIESSLICH Registriertes per Koordinate referenzieren (engine:axis / baustein-name, byte-genau; Freitext-Flags verboten); Zwei-Schichten-Semantik: `axes_default_lookup` = dependencyManagement (Default/Limit), per-Phase-`<axes>` = dependencies (konkrete Wahl). *(Quelle: §27; STUFE §3.B)*

**D11 — Unter-Achsen-Vollsupport, Haupt-statisch/Unter-dynamisch.** Eine Haupt-Achse (CT-statisch im Ziel-Binary) traegt optionale Unter-Achsen-Einstellungen (meist dynamisch im Ziel-Binary, stufen-relativ); das Angebot deklariert Unter-Achsen auf Achsen- UND Baustein-Ebene, die Anwender-XML kann beide selektieren (Variant-Ebene ueberschreibt Achsen-Ebene); je Unter-Achse weist `materialization` aus, ob sie CT-Variante (eigene binary_id, z.B. per-K) oder Laufzeit-Parameter ist. *(Quelle: §28; STUFE K2/K5)*

**D12 — Mess-Modi = XML-Steuerbefehle je Achse ODER Gesamtexperiment.** Die Mess-Modi des Systems sind Steuerbefehle in der XML, die JE ACHSE oder PER GESAMTEXPERIMENT eine enumerierte Range ODER bestimmte (benannte) Algorithmus-Bezeichnungen je Achse auflisten und permutiert durchtesten; das ist die praezisierte Fork-R5-Range-Syntax (minimal: `<values>` + `<range min max scale>`, plus Gesamtexperiment-Geltungsbereich). *(Quelle: §30.3; STUFE-KONSOLIDIERUNG Pkt. 4)*

**D13 — Resolver = Link-Phase, fail-loud, Fehlerklassen ⊂ D1.** Der Resolver laeuft zur Planer-/Configure-Zeit als 4-Stufen-Pipeline (Interpreter-Parse → Repository/Flyweight-Angebots-Aufbau ueber ALLE drei Registries → Symbol-Resolution jeder Referenz → `LinkedExperimentPlan`); jede unregistrierte/unaufloesbare Referenz ist ein harter, klassifizierter Fehler (V-UNREG-*/V-SCHEMA-PIN/V-RANGE/V-CATEGORY/…), und alle E-RES-Klassen docken als Sub-Codes an das BESTEHENDE Fehlerklassen-Framework `axis_error.hpp` an (E-RES-V/I ⊂ D1 `KonfigXmlParse`; E-RES-C = D1 HW/CompileKombination + D2 `SampleStatus::Failed` als CSV-„failed"-Zelle + Log, Harness misst weiter) — keine dritte Taxonomie, kein Parallel-Validator (Ausbau von `validate_experiment_profile`/`read_axis_registry`). *(Quelle: §27; STUFE §3.C + K3)*

**D14 — Join-Modi: Organ JETZT, System/Mess spaeter.** Organ-Achsen sind per Pruefling erweiterbar und mergen ihre Algorithmen nach den einstellbaren Join-Modi des Experiments = die 3 dokumentierten MergeStrategy-Stufen `Stufe1_CeOnly`/`Stufe2_PrueflingReplace`/`Stufe3_FullJoin` (existieren); System- und Mess-Achsen unterstuetzen den Achsen-Algorithmus-Join ebenfalls, dessen Implementierung wird aber zwecks Ergebnisse+Abgabe nach hinten geschoben — als getrackte spaetere Increments (ROADMAP PL-21), nie still fallen gelassen. *(Quelle: §30.1/2 + Fold)*

**D15 — Dock-Muster: 4 Invarianten, unten bidirektional, oben eindimensional.** Das Planer↔CEB-Dock spiegelt das reale, test-bewiesene CEB↔Tier-Dock ueber dessen vier Invarianten — (i) benanntes Vertrags-Interface + Abstract-Factory-Registry (IPruefDock/PruefDockRegistry ↔ IExperimentDock/ExperimentDockRegistry), (ii) 4 extern-C-Pflichtsymbole + Magic/Major-Gate an der .so-Grenze, (iii) Loader nach identischer Blaupause + `host_compatible_with`, (iv) POD-Antriebs-Buendel (standard_layout+trivially_copyable) — mit zwei Unterschieden: unten BIDIREKTIONAL (Tier meldet den Observer-Snapshot-POD zurueck), oben EINDIMENSIONAL (kein Rueckkanal; die CEB schreibt Messwerte selbst ans Ziel), und die Nutzlast oben ist per §30 die Messsystem-Wahl (harte CEB-Kompilation), waehrend `CebSystemAxisDrive` die System-Nutzlast der CEB→Tier-Stufe bleibt. *(Quelle: BAUPLAN Spiegel-Tabelle + KONSOLIDIERUNG §30; feedback_recursive_dock_planer_ceb_tier_abi_stable_so)*

**D16 — golden-N: Referenz ≠ Materialisierung.** Das neue golden ist die all-axes-Referenz N = 2^17 = 131.072 (17 Organ-Achsen × je genau 2 kanonische Werte), verankert als lazy Compile+Test-Anker (`static_assert(catalog_axis_product==131072)` + CRC64 `kNewGolden131072Crc64`, id-Datei bewusst NICHT im git) — strikt ENTKOPPELT vom klein bleibenden materialisierten Bau-Katalog (320); golden-320 bleibt TABU-Alias/Snapshot, Voll-Materialisierung/Voll-Messung ist gestaffelt und Storage-/Cache-gated. *(Quelle: feedback_new_golden_all_axes_xml_gt320; ENTWURF §C/D; ROADMAP B2)*

**D17 — CI-Kette: 5 Stufen, zwei Modi.** Die eine Pipeline hat 5 Stufen — St.0 Start/Lint/Orchestrate/Build-Flaeche · St.1 PLANER (=Mess) · St.2 CEB (=System) · St.3 TIER (=Organ; einzige FERTIGE Stufe; opt. St.3b Hybrid) · St.4 Auswertung/Persist — in zwei Modi (Gesamtlauf: CI-Gruen=Messung AUS; Messlauf: opt-in, mehrtaegig, nie pollen); groesstes Loch ist der Planer-Kopf (PL-1), Kettenende (Copy-Back .tex→Thesis, M-6) noch offen, gesamte Pipeline IMMER hart gruen, Verifikation immer Projekte 286+288. *(Quelle: CI-DETAIL + KONSOLIDIERUNG §30)*

**D18 — Storage: Ebene B+C scharfschaltbar.** Zwei-Cache-Storage ist CE-seitig fertig und INERT-by-default: Ebene B = minio-Tier-Binary-Cache (mc-Push, synchron im 1-Thread-Loop, Sidecar-Reihenfolge dll→version) und Ebene C = measure-drop HTTPS-PUT (User-Entscheid A, kein POSIX-Mount); Infra P1–P3 sind done, die Smoke-Pipeline 11365 lief mit `COMDARE_STORAGE_CACHE=true` — Rest = literale E2E-Belege + Politik-Entscheide (ST-5); der inkrementelle Tier-Binary-Cache per `algo_version` ist golden-N-Voraussetzung. *(Quelle: ROADMAP B3 + §30-Nachtrag; feedback_incremental_tier_binary_caching; Auftrags-Faktenstand 19.07.)* **→ NACHTRAG §31 (Storage-Stufen-Zuordnung, User-praezisiert):** CI-Cache (dev-MinIO `minio.comdare.local`, GitLab-Runner-Cache) haelt NUR den Experiment-Planer als statisch gebaute Binary (Kopf); prod-MinIO (`https://minio.prod.comdare.de`, Bucket `cache-engine-tier-binaries`) haelt ALLE dynamisch GENERIERTEN Folge-Stufen-Binaries (CEB je Messsystem + Tier-Binaries + Hybrid) + deren Systemaufstellungen (Sidecars/Provenienz) — Ebene B erweitert sich von „Tier-Binaries" auf „alle generierten Folge-Stufen".

---

## (A) ANNAHMEN (von mir getroffen — bitte je bestaetigen/korrigieren)

**A1 — Faerbungs-Traeger = bestehendes `AxisKind`.** Die §30-Faerbung nutzt exakt das existierende `AxisKind{organ, system_measurement, system_config}` (`topics/axis.hpp:17-20`) — „Mess-Achse" = `system_measurement`, „System-Achse" = `system_config`; KEINE neue Enum, keine vierte Farbe (Hybrid ist Ketten-Glied, keine Achsen-Art). **→ §31 [BESTÄTIGT+]:** AxisKind = Basis und wird wiederverwendet, „aber der Code ist veraltet und der Plan eilt korrekt voraus" — fuer Faerbung/Zerlegung des Gesamtbaums auszubauen.

**A2 — Hybrid-Binary = NACH Abgabe.** Der optionale Hybrid-Einschub (D4) ist ein spaeteres Increment nach Ergebnisse/Abgabe (Mess-Daten-gated, M10-Umfeld) und wird jetzt nur als Ketten-/Phasen-Position verankert, nicht gebaut. **→ §31 [REVIDIERT — SCOPE-ÄNDERUNG]:** NICHT nach Abgabe — da Fuss + Tier-Binary-Permutation vollstaendig stehen, ist der Hybrid-Einschub **Abgabekriterium/PFLICHT vor 28.07.**; Roadmap-Meilensteine nachziehen (Hybrid aus M7+/PL-20 in den Vor-Deadline-Scope).

**A3 — CEB-Generierung = Configure-/Pre-Build-Zeit-Codegen.** „Der Planer kompiliert HART ein CEB je Messsystem" heisst: Codegen+Kompilation zur Configure-/Pre-Build-Zeit (Blaupause `catalog_codegen.cmake`/CMakeGraphBuilder-Pfad), NICHT Laufzeit-Kompilation im Mess-Hot-Path; „je Messsystem" = je Mess-Achsen-Konfigurationspunkt des Planers EIN CEB-Bau, mit inkrementellem Skip analog `dll_is_current` (Sidecar-Provenienz).

**A4 — Mess-Achsen-Permutation im Planer aendert die CSV-Matrix-Semantik nicht.** Mess-Achsen bleiben Spalten-/Sidecar-/Matrix-Dimensionen und fliessen NIE in binary_id; golden binary_ids bleiben unberuehrt — es verschiebt sich nur, WELCHE Stufe die Mess-Dimension enumeriert (Planer statt CEB).

**A5 — opt×simd bleibt SYSTEM-Nutzlast.** Die heutige host-seitige opt×simd-Doppelschleife (`experiment_run_entry.hpp:257-289`) ist SYSTEM-Achsen-Permutation und gehoert damit zur CEB-Stufe (wird zur CEB-Generierungs-/Kompilations-Nutzlast); sie ist NICHT die Mess-Achsen-Permutation, die in den Planer wandert (Mess = Kategorien/DynamicDims/Workload).

**A6 — DREI Registries entstehen durch SPLIT des v2-Entwurfs.** Die im Resolver-STUFE-Dokument als Kategorien 2+3 EINER Datei entworfenen Bloecke werden eigene Registry-Dateien in ihren Modulen; Schema/Elemente identisch, nur Traegerdatei+Modul wechseln; der Resolver linkt gegen alle drei (+prt) Angebote.

**A7 — Ein Leser, N Dateien.** `read_axis_registry`/`RegistryContents` werden auf die 3(+prt) Registry-Dateien erweitert (kein zweiter Parser); je neue Registry ein eigenes statisches CMake-Define analog `COMDARE_CE_AXIS_REGISTRY_PATH`/`COMDARE_PRT_AXIS_REGISTRY_PATH`.

**A8 — Join-Modi-Steuerung ueber das bestehende `merge`-Attribut.** Die „einstellbaren Join-Modi des Experiments" laufen ueber das existierende MergeStrategy-Attribut der Phasen (Stufe1/2/3) — kein neues XML-Element; System-/Mess-Join bekommt spaeter analoge, additive Attribute.

**A9 — PL-13 geht in PL-19 auf.** Der System⊃Tier-Baum-Umbau (Audit-P6/PL-13) und der §30-Gesamtbaum-Bauauftrag sind EINE Baustelle (gefaerbter Baum + Zerlege-Operation), eigener Bauplan + GO, nicht golden-neutral, nach 28.07.

**A10 — Planer bleibt INERT bis Phasen-GO.** Alle Ketten-/Resolver-Increments bleiben opt-in (`-DCOMDARE_EXPERIMENT_XML=`), golden-Neutralitaet je Schritt ausgewiesen; Bau jeder Phase erst nach expliziter User-Freigabe (Vor-Deadline-Scope = Fork C).

**A11 — Registry-Regen-Akutfall ist erledigt.** Der K1-Befund (stale 18-Achsen-Registry, roter contract-Job) wurde per FIX-VERBUND ce `a9c433d0` + super `339cc9f` geschlossen (§29); M1/I0 startet auf dem regenerierten 17-Achsen-Stand.

---

## (F) OFFENE FORKS (je 1 Zeile + Empfehlung)

| Fork | Frage | Empfehlung |
|---|---|---|
| **GN-11** | #46-Deadline-Messlauf gegen golden-320/kuratierten Satz ODER golden-N (10-Tage-Lauf vs 9-Tage-Deadline) — WICHTIGSTE Entscheidung | 320/kuratiert (+Smoke) vor 28.07.; golden-N-Vollzug gestaffelt danach (Referenz-Anker steht bereits) |
| **F-SPREAD** | permute_axes-Wertepaare: first-2 (Fixture-verankert) vs Max-Kontrast-Spread auf 13/17 Achsen | first-2 JETZT behalten (CRC64-Fixture gelandet, N unabhaengig); Spread als INC-G7 nach Entscheid |
| **R1** | Registry-Single-Source: Code=Wahrheit+Generator-Ausbau vs Registry=Hand-Wahrheit | Option 1 (Code=Wahrheit; Hand-Pflege driftet nachweislich); GO VOR I0-Baubeginn |
| **R5** | Range-Syntax-Umfang der §30-Mess-Modi (je Achse ODER Gesamtexperiment) | MINIMAL (`<values>` + `<range min max scale>`) + Gesamtexperiment-Geltungsbereich; Erweiterungen additiv spaeter |
| **R6** | Schema-v2-Fenster: v1 unbefristet lesbar (deprecated) vs hartes Abschalt-Fenster | v1 unbefristet lesbar, nur deprecated (Formate-nie-loeschen); Abschaltung nur mit eigenem GO |
| **O-1** | rm getrackter Mess-CSVs (tier150/adapter) — Konflikt „Messdaten nie loeschen" | bis Messlauf zurueckstellen; nur mit explizitem je-Datei-GO |
| **B–E-Reste (Bauplan; A ist per §30 ENTSCHIEDEN)** | B: 3. `PlanTextBuilder` fuer `--dump-plan`? · C: Deadline-Schnittlinie · D: `ceb_contract_version`-Minor-Bump beim Planer-Emitter? · E: XML-Kanal-Konvergenz Experiment- vs ThesisProfile | B: ja (sauberer Contract-Test) · C: I0+I1+I2+Phase-2-Wiring vor 28.07., Rest danach · D: kein Bump solange kein universeller Codegen beruehrt (vor Merge verifizieren) · E: Experiment-Kanal als das EINE Ziel, ThesisProfile als referenzierter Mess-Detail-Traeger (GO noetig) |
| *(nachrangig)* R2/R3/R4 | per-Phase-`<axes>` ja/nein · prt-Sichtbarkeit hart in Stufe2/3 · Pin-Strenge schema-Nummer vs Content-Hash | ja (Zwei-Schichten-.pom) · hart (V-CATEGORY) · schema-Nummer (Hash invalidiert bei jeder Regen) |

---

## (N) NACHTRAG — LEDGER §31 (2026-07-19, User-Antworten NACH Abfassung dieses Abstracts; autoritativ)

> §31 beantwortet einen Teil der (A)-Annahmen und praezisiert Storage. Achtung Zaehlung: die §31-Nummern folgen der muendlich gestellten Frageliste, NICHT 1:1 der (A)-Liste dieses Dokuments — Mapping unten explizit.

1. **§31-A1 ≙ Abstract-A1 [BESTÄTIGT+]:** `AxisKind` = Basis, wird wiederverwendet; „Code ist veraltet, der Plan eilt korrekt voraus" → fuer Faerbung/Zerlegung auszubauen.
2. **§31-A2 ≙ Abstract-A2/D4 [REVIDIERT — SCOPE-ÄNDERUNG]:** Hybrid-Einschub (4. Ketten-Glied) = **ABGABE-PFLICHT vor 28.07.** („das ist mit Pflicht"), NICHT nach Abgabe; Roadmap: Hybrid aus M7+/PL-20 in den Vor-Deadline-Scope ziehen.
3. **§31-A3 ≙ Abstract-A4 [UNBEANTWORTET]:** „Mess-Matrix bleibt CSV-Dimension, Planer waehlt das einkompilierte Messsystem" blieb ohne User-Antwort — steht weiterhin als dokumentierte ANNAHME (A4), nichts entschieden.
4. **§31-A4 ≙ Abstract-D18 [BESTÄTIGT + PRÄZISIERT — Storage-Stufen-Zuordnung]:** CI-Cache (dev, `minio.comdare.local`) = NUR Planer-Binary (statisch, Kopf) · prod-MinIO (`https://minio.prod.comdare.de`, `cache-engine-tier-binaries`) = ALLE generierten Folge-Stufen-Binaries (CEB je Messsystem + Tier + Hybrid) + Systemaufstellungen (Sidecars/Provenienz); Ebene B entsprechend erweitert.
5. **VOLLES GO (§31):** Bau-Freigabe fuer Welle-1-Pakete (golden-neutral) + Planer-Strang nach konsolidiertem Bauplan — Abstract-A10 gilt fortan in dieser Form; GO-pflichtige Forks (GN-11/F-SPREAD/R1/O-1 …) bleiben EINZELN offen. Uebrige Annahmen (A3, A5–A9, A11) unveraendert Annahmen bzw. Faktenstand.
