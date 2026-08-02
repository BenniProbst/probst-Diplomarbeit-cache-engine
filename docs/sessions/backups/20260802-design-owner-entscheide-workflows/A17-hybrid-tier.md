# A17-hybrid-tier

## REVIEW: NACHBESSERN
Owner-Treue: Keine materielle Abweichung vom Owner-Wortlaut gefunden. Abgleich gegen docs/sessions/20260802-OWNER-entscheide-...md:7 (verbatim) Punkt fuer Punkt: (1) 'eine weitere Stufe hinter der CEB' = Design Abschnitt 0/3 identisch. (2) 'mehrere Pruef-docks ... ABI stabile Pruefdocks ... zahlenmaessig dynamisch' = N-Dock-Array mit dynamischer Belegung in beiden Policies; die Auslegung 'ABI-Stabilitaet = bestehende Anatomy-ABI-7, Dock selbst keine ABI-Grenze' ist durch pruef_dock.hpp:10-14 kanon-gedeckt. (3) 'Proxy Verwendung ihrer Tier-Binaries als Factory Pattern' = HybridBinaryProxy + HybridDockFactory; der Split in Abstract Factory (Docks) + Proxy (Binaries) ist durch die Owner-eigene Section-49-KORREKTUR (LEDGER:2663 'per Abstract-Factory-Methode gelesen und verarbeitet') woertlich gedeckt. (4) 'in der Regel als Ausnahmen std::variant ... genau dafuer braucht es std::variant in einem wahlweise statischen oder runtime array' = HybridDockVariant im DockSlot, Static-/Runtime-Policy. Die zusaetzliche Verschaerfung 'std::visit nur an Umschaltpunkten, Hot-Path variant-frei' steht NICHT in Owner-E1, ist aber die bindende Owner-KORREKTUR Section 49 (Haupt-Kommunikation = statisches IObservableTier) — kanon-gedeckt, kein Widerspruch; ebenso die Lesart, dass Option-1-variant (LEDGER:2666) durch die KORREKTUR verengt ist ('NOCH ENGER ... NICHT fuer Break-Even-Algo-Swapping'). (5) 'in den plain Tier-Binaries ist das verboten' = Verbots-Kante 3 + V7.2-Vermerk identisch. (6) 'Zwischenloesung ... XML Konfiguration auf Wunsch des anwenders in der Auswertungsphase' = jetzt NUR Kommentar-Reserve (kein Vorziehen), scharf erst HY-B3 — exakt. (7) 'Designplanung JETZT ... Bau in der Auswertungsphase' = Paketschnitt HY-D1/D2 jetzt, HY-B1..B4 Auswertungsphase. Der V7.2-Praezisierungs-Text spiegelt Owners 'Das ist kein Konflikt' als 'kein Konflikt, zwei Geltungsbereiche' wortlaut-treu. Einzige unbelegte Owner-Zuschreibung: die Ein-Gattung-Empfehlung stammt aus der Memory-Doktrin (feedback_ceb_drei_modi ERWEITERUNG: 'uebernimmt per Metaprogrammierung DIE Gattung ihrer Tier-Binaries' — verifiziert vorhanden), nicht aus E1 selbst; das Design markiert sie korrekt als offene Owner-Frage.
Befunde:
- B1 (MITTEL, Vollstaendigkeit): Lager-/binary_id-Identitaet der Hybrid-Binary SELBST ungeklaert. Das Design regelt nur die Dock-Bestueckung (Sidecar, nie binary_id — korrekt golden-neutral), aber die Hybrid-.so hat keine Organ-Permutations-binary_id und damit keinen definierten Slot im Binaries-Realm-Baum; Punkt 4.5 nennt binary_id->Pfad-Lookup nur fuer plain Tiers, offene Frage 3 deckt nur das Stempel-Kennzeichen, nicht die Lager-Einlagerung/Identitaet der Hybrid-Binary. Vor A13-/Lager-Freeze muss das Design sagen: eigene Hybrid-Identitaetsform im Lager ODER explizit 'Hybrid wird nicht eingelagert'.
- B2 (MITTEL, Kanon/Layering): Builder-Code in der Tier-Binary ist nicht als Schichten-Entscheid benannt. HybridBinaryProxy haelt anatomy_loader::AnatomyModuleHandle und builder::pruef_dock::SearchAlgorithmDrive; AnatomyModuleLoader::load/unload sind in der Builder-Lib definiert (anatomy_module_loader.hpp:126/:152 deklariert, .cpp-definiert) — die Hybrid-Tier-.so muesste CEB-/Builder-Code linken. Das kollidiert mit der stehenden Doktrin-Zeile pruef_dock.hpp:10 ('lebt nur im Builder-Binary') und der CEB-superset-Tier-Schichtung (LEDGER 18.1.2). Fehlender Migrationsschritt: Loader/Drive-Typen in eine stufen-neutrale Lib extrahieren ODER die Doktrin-Kommentare additiv praezisieren — muss in HY-B1 explizit stehen.
- B3 (KLEIN, Ist-Befund falsch): 'builder/decision_lambda_trees/ (einziger CoR-Treffer im Code)' stimmt nicht. Reale GoF-CoR-Implementierungen existieren zusaetzlich in builder/experiment_tree/selection_filter_chain.hpp:2/:48, include/cache_engine/measurement/ram_probe_chain.hpp:4 und include/cache_engine/measurement/axis_error.hpp:18/:196 — relevant, weil HY-B2 eine CT-CoR bauen will und Wiederverwendungs-Kandidaten uebersehen sind.
- B4 (KLEIN, Vollstaendigkeit): Das Verhaeltnis der Hybrid-Stufe zur 'Heuristik-Optimierungs-Achse als EIGENE SYSTEMACHSE' (LEDGER:187(e); Memory feedback_ceb_drei_modi ERWEITERUNG 10.07.) wird nirgends adressiert, obwohl das Design LEDGER:187 selbst zitiert. Unter V7.2 (genau DREI System-Glieder) ist unklar, ob Owner-E1 ('eigene Stufe HINTER der CEB') das Systemachsen-Framing supersedet — ohne einen Satz dazu entsteht derselbe schlafende Regelkonflikt-Typ wie E-11.
- B5 (KLEIN, Vollstaendigkeit): Die Snapshot-Aggregation ('aggregiert Sub-Tier-Observer-Snapshots zu ihrem EINEN POD') ist semantisch nicht trivial — ComdareTierObserverSnapshot hat festes axis_stats[18][8]-Layout, Docks koennen Tiers unterschiedlicher Organ-Kompositionen tragen (Summe vs. Aktiv-Binary-Passthrough, Provenienz-Verlust). Als offener Design-Entscheid markieren, nicht als implizit geloest.
- B6 (KLEIN, Frist): Kein F8-Minimal-DoD-Fallback in der Paketreihenfolge. Section 32-F8 (LEDGER:2265) setzt Hybrid-DoD = minimale Baseline + Spline-Heuristik = ABGABE-PFLICHT; HY-B1..B4 (L+M+M+L) nennt keinen minimalen Pfad, falls die Auswertungsphase schrumpft (Frist 27.07. bereits gerissen). Reihenfolge so schneiden, dass ein ctest-bewiesener Minimal-Hybrid (1 Dock, standard-Vertrag, ohne Eviction/XML) zuerst landet.
- B7 (NITS, keine Substanz): AnatomyGenus-Enum liegt bei anatomy_base.hpp:80-86 (Design sagt :78-84); XSD-Root-Sequenz spannt :22-73 (Design :22-66, Elemente enden :66 — vertretbar); run_methodology_registry.hpp liegt unter include/cache_engine/measurement/ (Design nennt keinen Pfad); Section-49-Zitate liegen bei LEDGER:2653-2663 (Design :2656/:2659/:2663 — trifft die Kernzeilen). Alle uebrigen datei:zeile-Belege (pruef_dock.hpp:10-14/:36-41/:57-80/:78-79, pruef_dock_registry.hpp:22-47, search_algorithm_dock.hpp:26-61/:65-70/:77-86, pruef_dock_sequencer.hpp:47, abi_decl :62/:66, loader :72-75/:76-133/:139-160, observable_tier:185/:193, LEDGER:80/:89/:187/:490/:1692-1698/:2230/:3250/:3345ff/:3489/:3558(=Section 75), break_even.hpp:1-24, XSD:60-62, dock_payload:58, pruefling_merge:1-16, beide Registry-XMLs, experiment_golden_kern.xml, hybrid-grep=0, COMDARE_DEFINE_ANATOMY_MODULE, validate_profile.hpp, Katalog A16/E-24/E-11-Eskalation) VERIFIZIERT KORREKT.
Korrekturen:
- K1 (zu B1): Ins SOLL-Design (Abschnitt 4, A13-Stempel-Schnittstelle) einen Absatz 'Hybrid-Lager-Identitaet' ergaenzen: entweder definierte Einlagerungsform der Hybrid-.so im Binaries-Realm (eigener Identitaets-Schluessel, z.B. Stempel-SHA512 statt Organ-binary_id) ODER explizite Aussage 'Hybrid-.so wird nicht eingelagert, ist Auswertungs-Artefakt der CEB' — und als zusaetzliche offene Owner-/A13-Frage aufnehmen.
- K2 (zu B2): In Abschnitt 1 (Ownership) und Paket HY-B1 den Schichten-Entscheid ausformulieren: AnatomyModuleLoader + Drive-Buendel-Typen werden fuer die Hybrid-Stufe in eine stufen-neutrale Lib gezogen (oder: Hybrid linkt bewusst die Builder-Loader-Lib, mit additiver Praezisierung der Doktrin-Kommentare pruef_dock.hpp:10-14). Ohne diesen Schritt ist 'AnatomyModuleLoader-Wiederverwendung' kein vollstaendiger Migrationsplan.
- K3 (zu B3): Ist-Kartierung Punkt 5 korrigieren: CoR-Substrat = decision_lambda_trees + selection_filter_chain.hpp (GoF-CoR, experiment_tree) + ram_probe_chain.hpp + axis_error.hpp; selection_filter_chain als Wiederverwendungs-Kandidat fuer den HY-B2-Router pruefen.
- K4 (zu B4): In den V7.2-Praezisierungs-Vermerk (HY-D1) einen Satz aufnehmen: Owner-E1 definiert die Hybrid-Natur als STUFE hinter der CEB; das aeltere Framing 'Heuristik-Optimierungs-Achse als eigene Systemachse' (LEDGER:187(e)) ist damit eingeordnet/supersedet BZW. als Rest-Klaerung mit Owner-Frage markieren — nicht stillschweigend uebergehen.
- K5 (zu B5): In HY-B4 die Aggregations-Semantik als benannten offenen Entscheid fuehren (Summe ueber Docks vs. Aktiv-Dock-Passthrough + Sidecar-Provenienz) und einen Konformitaets-Test dafuer vorsehen.
- K6 (zu B6): Paketreihenfolge um den F8-Minimal-DoD-Anker ergaenzen: HY-B1-Minimalschnitt (1 Standard-Dock, delegierter Bau, ctest-Beweis) als erster Auswertungsphasen-Meilenstein VOR Router/Eviction/XML-Vollausbau; deckt Section 32-F8 ABGABE-PFLICHT auch bei Zeitdruck.
- K7 (zu B7): Zeilen-Nits still korrigieren (anatomy_base :80-86, XSD :22-73, voller Registry-Pfad include/cache_engine/measurement/run_methodology_registry.hpp).

## PAKETE
- [S/TRIGGER] HY-D1 V7.2-Praezisierung + E-11-Aufloesung (Ledger/Doku additiv): Additiver Vermerk unter LEDGER:89 (+Spiegel an LEDGER:3489) mit dem V7.2-Praezisierungs-Text (Verbots-Scope = plain Tier-Binaries; Hybrid = definierte Ausnahme unter §49-KORREKTUR-Bedingungen); Verweis auf Owner-Doc 20260802; Katalog-A17-Fortschreibung. Loest den dokumentierten E-11-Regelkonflikt (Katalog G.2a) auf, bevor O-8-nahe Refactorings ihn zementieren.
- [S/TRIGGER] HY-D2 Schnittstellen-Freihaltung + Architektur-Doc: Design-Doc nach ce docs/architecture/ (dieses SOLL, additiv); Verzeichnis-Stub libs/cache_engine/hybrid/; XSD-Kommentar-Reserve <hybrid_tier> in experiment_schema.xsd (COMPARE-Muster, byte-neutral fuer alle Bestands-XMLs); Freeze-Vermerk heuristik/-API + IPruefDock::measure in der §75-Kandidatenliste (Nicht-Kandidaten); Merksatz E-24-Sequenz (letzter ABI-Schritt VOR Voll-Bau-4) im Gate-Reihenfolge-Eintrag von A16 verankern.
- [L] HY-B1 Dock-Array + Abstract Factory + Binary-Proxy (Kern): hybrid_dock_contract.hpp (Descriptor + constexpr contract-Registry), hybrid_pruef_dock.hpp (Standard + Vertrags-Alternativen), hybrid_dock_factory.hpp (Abstract Factory, einziger variant-Konstruktions-Ort), hybrid_dock_array.hpp (Static-/Runtime-Policy), hybrid_binary_proxy.hpp (Loader-Wiederverwendung, Attach-Zeit-Monomorphisierung, destroy-vor-dlclose). Unit-Tests inkl. Hot-Path-variant-frei-Nachweis. BAU: Auswertungsphase, nach E-24.
- [M] HY-B2 Break-Even-Router + Verdraengungs-Strategie: hybrid_router.hpp (CT-Chain-of-Responsibility ueber BreakEvenPoint-Listen aus heuristik/break_even.hpp; Quiesce-Umschaltpunkte); hybrid_eviction.hpp (CT-Strategy; Shortlist LRU/LFU/ARC/cost-aware nach der §49-beauftragten Web-Recherche der Speicher-Heuristiken); Anschluss measurement_curve_loader an den Messdaten-Realm des Lagers. BAU: Auswertungsphase.
- [M] HY-B3 XML-Konfiguration scharf (Auswertungsphase): XSD-Typ HybridTierType aus der Kommentar-Reserve heben; hybrid_config_xml.hpp-Parser (common-DOM); validate_profile-Naht (contract-/strategy-Token gegen constexpr-Registries); Fixture-Erweiterung experiment_golden_kern (super-Referenz + ce-Spiegel, Sync-Gate-konform, TABUs unberuehrt). BAU: Auswertungsphase.
- [L] HY-B4 Hybrid-als-Tier-Export + CEB-Messung + Arbeitsmodus-Anschluss: hybrid_tier_module.cpp (COMDARE_DEFINE_ANATOMY_MODULE-Export der SearchAlgorithm-Huelle; Snapshot-Aggregation ueber Sub-Tiers); Messung der Hybrid-Binary am CEB-Pruef-Dock (§64 gemischt); delegierter Bau-Kanal Hybrid->CEB (Anforderungs-Manifest binary_id-Liste); Release-Schritt: Mess-Observer per Metaprogrammierung abschaltbar (LEDGER:3250) + Wallclock-Beweis. BAU: Auswertungsphase, letztes Hybrid-Paket.

## RISIKEN
- variant-Leak in den Hot-Path: wird std::visit pro Operation statt pro Umschaltpunkt gerufen, ist die §49-KORREKTUR verletzt (Haupt-Kommunikation muss statisch bleiben). Gegenmassnahme ist Teil des Designs (Attach-Zeit-Monomorphisierung + gecachter IObservableTier*) und MUSS in HY-B1 durch einen Konformitaets-Test abgesichert werden.
- ABI-Major-Drift: bumpt E-24 (Container-Gattung) den Major NACH dem Voll-Bau-4 (Binaries dann Major 7), koennte eine auf dem neuen Major gebaute Hybrid-Stufe die eingelagerten plain Binaries nicht laden (anatomy_module_loader Major-Check) -> Neubau aller Binaries, exakt das, was Owner-E3-Logik verbietet. Deshalb MUSS E-24 als letzter ABI-Schritt VOR dem Voll-Bau-4-Trigger liegen (A16-Einordnung ist dafuer der Hebel).
- Verschachteltes dlopen: die Hybrid-.so laedt selbst N Sub-.so (dlopen aus einem dlopen-Modul). Legal, aber Entlade-Reihenfolge, RTLD-Flags und static-TLS-Budget bei vielen gleichzeitig gehaltenen Modulen sind auf beiden Prod-Maschinen (+ kuenftig macOS .dylib/RISC-V) in HY-B1 empirisch zu belegen, nicht anzunehmen.
- A13-Stempel-Regression aendert das Stempel-Layout (merge-Zeile faellt, Meta-Meta ans Realm-Ende): das Hybrid-Sidecar-Manifest-Format darf erst NACH gelandetem A13 fixiert werden, sonst traegt es die defekte 5-Zeilen-Identitaet weiter.
- Eviction versus laufende Operationen: Verdraengung eines Docks waehrend einer In-Flight-Op waere UB an der ABI-Grenze; das Quiesce-Punkt-Design (Umschalt nur am Op-Rand) muss im Router hart durchgesetzt und getestet werden (Arbeitsmodus-Hot-Switch-Doktrin LEDGER:187).
- Lager-API-Drift: die parallel laufende Lager-Strecke (A1) definiert die binary_id->Pfad- und CSV-Lookup-Flaechen; aendert sie diese nach dem Hybrid-Design-Freeze, braucht HY-B2 eine Anpassungsschleife. Schnittstelle ist benannt, aber nicht vertraglich eingefroren.
- Genus-Erweiterung: das Design fixiert die SearchAlgorithm-Huelle nach oben; kommen nach E-24 Container-Gattungs-Hybride, braucht es je Gattung eine eigene Hybrid-Huelle (kein Umbau, aber Mehraufwand — im Design als 'ein Hybrid je Gattung' angelegt, siehe offene Frage 1).

## OFFENE FRAGEN
- Gattungs-Kardinalitaet: EIN Hybrid-Binary je Gattung (Empfehlung; Memory-Doktrin 'uebernimmt per Metaprogrammierung DIE Gattung ihrer Tier-Binaries') — oder darf ein Hybrid-Binary Docks GEMISCHTER Gattungen tragen? Owner-Bestaetigung der Ein-Gattung-Lesart erbeten.
- CT-Kapazitaet der statischen Dock-Array-Policy: Default-MaxN (Vorschlag 8, per XML max_docks -> Compile-Define beim delegierten Hybrid-Bau) — Owner-Wert oder frei?
- Stempel-Detail: bekommt die Hybrid-Binary im System-Stempel-Array ein eigenes Kennzeichen (z.B. hybrid-Flag/Version) oder bleibt die Hybrid-Natur ausschliesslich im Sidecar-Manifest? (klein, nach A13 entscheidbar)
- Verdraengungs-Heuristik-Shortlist: die §49-beauftragte Web-Recherche der Speicher-Heuristiken (LRU/LFU/ARC/GDSF/cost-aware) ist noch offen — Zeitpunkt Auswertungsphase (HY-B2) bestaetigen oder vorziehen?
- Plattform-Querschnitt E4 (RISC-V, macOS M1/x86 kommen heute): platform_suffix() des Loaders kennt .dylib bereits — reicht die bestehende Loader-Flaeche, oder will der Owner die Hybrid-Stufe explizit in die neue Plattform-Matrix (E-19-Soll) aufgenommen sehen?

## IST-BEFUND
## Ist-Kartierung (alle Pfade relativ zu ce = Code/external/comdare-cache-engine bzw. LEDGER = docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md im super-Repo)

**1. Owner-Spec (Gesetz):** docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md:7 (verbatim Entscheid 1) + :27-31 (Manager-Auslegung E1). Kernpunkte: eigene Stufe HINTER der CEB; mehrere ABI-stabile Pruef-Docks; Factory Pattern als Proxy auf ihre Tier-Binaries; std::variant als Ausnahme in wahlweise statischem ODER Runtime-Array (Dock-Anzahl dynamisch); Zwischenloesung statische Pruef-Docks vs. austauschbare plain Tier-Binaries je Pruefdock = XML-Konfiguration in der AUSWERTUNGSPHASE; in plain Tier-Binaries bleibt std::variant VERBOTEN.

**2. Bestehende Pruef-Dock-Welt (CEB-Ebene, wiederverwendbar):**
- ce libs/cache_engine/builder/pruef_dock/pruef_dock.hpp:57-80 `IPruefDock` (dock_genus/dock_name/accepts/measure); :36-41 errno-Status; :10-14 Doktrin: IPruefDock ist KEINE ABI-Grenze (lebt nur im Builder-Binary); ABI-Grenze = gattungs-eigenes Antriebs-Sub-Interface (IObservableTier) + POD-Snapshot.
- pruef_dock_registry.hpp:22-47 `PruefDockRegistry` (vector<unique_ptr<IPruefDock>>, EIN Dock je Gattung, select_for per im-Modul-deklarierter Gattung).
- search_algorithm_dock.hpp:26-61 konkretes Dock (Konformitaets-Gate vor Messung :50, Zwei-Phasen-Treiber :55-58); :65-70 `SearchAlgorithmDrive` (obs/ctrl/rbk/scn-Buendel); :77-86 `acquire_search_algorithm_drive` (dynamic_cast EINMALIG, nicht pro Op).
- pruef_dock_sequencer.hpp:47 `measure_genus_sequential` (Default sequentiell-pro-Gattung).

**3. ABI-/Loader-Flaeche (die stabile Naht nach unten UND oben):**
- ce libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp:62 `COMDARE_ANATOMY_ABI_MAJOR 7`, :66 Magic `.A7.`; 4 Pflicht-Symbole (create/destroy/version/magic); Observer-POD 1344 (Version 8, LEDGER:80 V7.1-Anker).
- builder/anatomy_module_loader/anatomy_module_loader.hpp:76-133 `AnatomyModuleHandle` (RAII move-only, destroy-vor-dlclose-Ordnung :72-75); :139-160 `AnatomyModuleLoader::load/load_all` (7-Schritt-Validierung inkl. Major-Check).
- anatomy/observable_tier.hpp:185 `IObservableTier : IDriveableTier` (tier_observe :193) = die statische Haupt-Kommunikation.
- anatomy/anatomy_base.hpp:78-84 `AnatomyGenus` {SearchAlgorithm, Set, Sequence, Adapter, View}.

**4. Doktrin-Anker im Ledger:**
- LEDGER:490 + :1692-1698 REKURSIVE Dock-/ABI-stabile-.so-Architektur (Ebene 1 Planer-Dock eindimensional, Ebene 2 CEB-Pruef-Dock bidirektional; Tier-Binaries (a) heuristisch mit CT-Chain-of-Responsibility NACH dem Command-Pattern oder (b) plain). Befund :1698: ein benannter "Planer-Dock" existiert im Code NOCH NICHT.
- LEDGER:187 CEB-Ziel = 4 Modi (Mess -> Auswertung -> Arbeitsmodus [Tier-Binaries hot im RAM, Hot-Switch an ABI-Grenze] -> Hybrid = ZIEL der Diplomarbeit); LEDGER:2230 rekursive Delegation (Hybrid-Tiere lassen echte Tier-Binaries delegiert durch CEB entwickeln/laden).
- LEDGER:2265-2270 §32-F8 (Spline-Heuristik, 3 Break-Even-Optionen, Break-Even = Spline-Schnittpunkte); LEDGER:2656/2659 §49 (Option 1+3 freigegeben; Dock-Array mit Verdraengung + Verdraengungs-Strategie, Speicher-Heuristiken web-recherchieren); LEDGER:2663 §49-KORREKTUR (variant NUR als Traeger abweichender Unter-Pruef-Dock-Typen/-Vertraege via Abstract-Factory-Methode; Haupt-Kommunikation = statisches IObservableTier).
- LEDGER:89 V7.2-Satz "std::variant nur in der CEB geduldet, in ALLEN Tier-Binary-Typen verboten" + LEDGER:3489 (Vermerk gleicher Aussage) = der E-11-Regelkonflikt (Katalog G.2a), den Owner-E1 jetzt aufloest.
- LEDGER:3250 Release-Ziel: Mess-Observer per Metaprogrammierung ABSCHALTBAR fuer die finale Auslieferung (Hybrid-Satz + Unter-Binaries).
- §64 (LEDGER ~3345ff): Pruef-Dock nimmt alle 3 Mess-Features {wallclock, macro, micro} GEMISCHT ab (Default vereint).

**5. Heuristik-Substrat (bereits gebaut, Router-Speisung):** ce libs/cache_engine/heuristik/{axis_spline.hpp, break_even.hpp, measurement_curve_loader.hpp} — break_even.hpp:1-24 Schnittpunkt-Finder zweier AxisSpline derselben Organ-Achse (W3-C, Strategy-Pattern, Bisektion); builder/best_binary_selector/ + builder/decision_lambda_trees/ (einziger CoR-Treffer im Code).

**6. XML-/Schema-Flaeche:** Code/test_data_xml/experiment_schema.xsd:22-66 Root-Sequenz von `comdare_experiment` (metadata/execution_engines/machines/lebewesen/phases/axes_default_lookup/system_axes/workloads/.../run_methodology/output); :60 zeigt das etablierte Reserve-Muster (COMPARE lebte erst als XSD-Kommentar-Reserve, dann als Typ — run_methodology_registry.hpp:7-10). ce tests/unit/thesis_tiere/experiment_golden_kern.xml = KERN-Fixture-Spiegel. Registries: libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml, tests/unit/thesis_tiere/prt_art_axis_registry.xml.

**7. PRT-ART-Anbindung:** anatomy/pruefling_merge.hpp:1-16 PrueflingSlot-Pattern + 3 kompositionale Joins (Stufe1 CE-only / Stufe2 Replace / Stufe3 FullJoin); Owner-E2: PRT-ART laeuft merge GEGEN die Organ-Achsen (Stempel-Regression A13, separates Paket).

**8. Kein Hybrid-Code existiert:** grep HybridTier/hybrid_tier in ce libs = 0 produktive Treffer (nur decision_lambda_trees.hpp erwaehnt CoR). Die Hybrid-Stufe ist reines Design-Neuland — konsistent mit "Bau in Auswertungsphase".

**9. Planer-Dock-Payload:** profile_facade/planner/experiment_dock_payload.hpp:58 DEPRECATED (Live-Kette laeuft ueber emittierten CMake/YAML-TEXT; POD bleibt als Referenz-Serialisierung) — relevant als Muster fuer das spaetere Hybrid-Manifest-Wire-Format, keine Live-Abhaengigkeit.

## DESIGN-VOLLTEXT
## SOLL-Design Hybrid-Tier-Stufe (Owner-E1, Fable-xhigh-Designplanung)

### 0. Einordnung in die rekursive Dock-Kette (Rekursions-Ebene 3)
Die Kette wird um GENAU EINE Rekursions-Ebene nach demselben Muster verlaengert (LEDGER:490-Doktrin, gespiegelt):
- Ebene 1: Planer-Dock (Planer -> CEB, eindimensional).
- Ebene 2: CEB-Pruef-Dock (CEB <-> Tier-Binary, bidirektional, ABI-7).
- **Ebene 3 (NEU): Hybrid-Pruef-Docks (Hybrid-Tier-Binary <-> plain Tier-Binaries, bidirektional)** — N Docks statt einem, N dynamisch.
Nach OBEN ist die Hybrid-Tier-Binary selbst ein gewoehnliches Tier-Modul am CEB-Pruef-Dock: sie exportiert die 4 Pflicht-Symbole (anatomy_module_abi_v1_decl.hpp:62/:66) und liefert IAnatomyBase + IObservableTier als "virtuelles ganzes Tier-Binary" (SearchAlgorithm-Huelle, Memory-Doktrin feedback_ceb_drei_modi ERWEITERUNG). Nach UNTEN spricht jedes ihrer Docks seine plain Tier-Binary ueber EXAKT dieselbe Anatomy-ABI (AnatomyModuleLoader-Wiederverwendung). **Folge: die Hybrid-Stufe braucht KEINEN eigenen ABI-Schritt** — beide Grenzen sind die bestehende versionierte ABI. Das ist der wichtigste Freihalte-Entscheid (siehe §5).

### 1. Architektur: Klassen/Header-Schnitt, Ownership, Lebenszyklus
Neues Stufen-Verzeichnis (Namespace `comdare::cache_engine::hybrid`), Verzeichnis JETZT als Stub + Design-Doc reserviert, Bau in Auswertungsphase:
```
ce libs/cache_engine/hybrid/
  hybrid_dock_contract.hpp        // DockContractDescriptor (POD) + HybridDockContract-Concept + contract-Registry (constexpr, analog run_methodology_registry.hpp)
  hybrid_pruef_dock.hpp           // StandardHybridDock + je abweichendem Vertrag ein Alternativ-Dock-Typ (Rollback/Scan/ResourceControl)
  hybrid_dock_factory.hpp         // Abstract Factory (§49-KORREKTUR): Descriptor -> emplaced variant-Alternative; EINZIGER Konstruktions-Ort der Alternativen
  hybrid_dock_array.hpp           // DockArray<Policy>: statisch ODER runtime (Owner-Wahlfreiheit)
  hybrid_binary_proxy.hpp         // HybridBinaryProxy: Factory-Proxy je Dock auf seine plain Tier-Binary (besitzt AnatomyModuleHandle)
  hybrid_eviction.hpp             // Verdraengungs-Strategie (CT-Strategy, §49 Dock-Array-Verdraengung)
  hybrid_router.hpp               // Break-Even-Router (speist sich aus heuristik/break_even.hpp + measurement_curve_loader.hpp)
  hybrid_config_xml.hpp           // Parser der <hybrid_tier>-XML-Sektion (common-DOM xml_reader, NUR EIN XML-Programm)
  hybrid_tier_module.cpp          // die Hybrid-Tier-Binary: COMDARE_DEFINE_ANATOMY_MODULE-Export der SearchAlgorithm-Huelle
```
**Signaturen-Skizze (Kern):**
```cpp
namespace comdare::cache_engine::hybrid {

// (a) Vertrags-Deskriptor — aus XML gelesen, von der Abstract Factory verarbeitet (POD, trivially_copyable).
struct DockContractDescriptor {
    std::uint8_t contract_id;      // Index in die constexpr contract-Registry ("standard"/"rollback"/"scan"/"resource_control")
    anatomy::AnatomyGenus genus;   // Gattung der andockbaren plain Tiers
    // + Vertrags-Parameter (z.B. two_phase, range_scan) — additiv erweiterbar
};

// (b) DIE eine erlaubte variant-Stelle der Gesamt-Architektur ausserhalb der CEB (Owner-E1 + §49-KORREKTUR):
using HybridDockVariant = std::variant<StandardHybridDock, RollbackContractDock,
                                       ScanContractDock, ResourceControlDock /* additiv je neuem Vertrag */>;

struct DockSlot {
    HybridDockVariant       dock;   // variant NUR hier: Traeger der Dock-Typ-/Vertrags-Varianz
    HybridBinaryProxy       proxy;  // KEIN variant: RAII-Besitz der plain Tier-Binary dieses Docks
    DockContractDescriptor  desc;
};

// (c) Dock-Array wahlweise statisch/runtime (Owner: "wahlweise statisches oder runtime array"):
template <std::size_t MaxN> struct StaticDockArrayPolicy  { using storage = std::array<std::optional<DockSlot>, MaxN>; };
struct RuntimeDockArrayPolicy { using storage = std::vector<DockSlot>; };
template <class Policy> class DockArray {  // Policy per XML gewaehlt; Belegung IMMER dynamisch
    [[nodiscard]] int attach(DockContractDescriptor const&, std::filesystem::path const& so); // Factory + Loader, errno-Stil
    void detach(std::size_t slot) noexcept;      // Proxy-release: destroy_anatomy -> dlclose
    template <class EvictionStrategy> std::size_t evict_for(EvictionStrategy&, std::size_t bytes_needed);
    [[nodiscard]] std::size_t size() const noexcept;  // dynamisch in BEIDEN Policies (statisch = nur CT-KAPAZITAET)
};

// (d) Factory-Proxy (GoF Proxy + Factory Method; Owner: "Proxy Verwendung ihrer Tier-Binaries als Factory Pattern"):
class HybridBinaryProxy {
    [[nodiscard]] int acquire(std::filesystem::path const& so);  // AnatomyModuleLoader::load + EINMALIGES Drive-Buendel-Probing
    void release() noexcept;                                     // destroy-vor-dlclose (anatomy_module_loader.hpp:72-75-Ordnung)
    [[nodiscard]] anatomy::IObservableTier* obs() const noexcept; // gecachter statischer Antrieb — Hot-Path variant- und cast-frei
private:
    anatomy_loader::AnatomyModuleHandle handle_;   // RAII, move-only
    builder::pruef_dock::SearchAlgorithmDrive drive_; // dynamic_cast NUR bei acquire (search_algorithm_dock.hpp:77-86-Muster)
};

// (e) Abstract Factory (§49-KORREKTUR woertlich: "per Abstract-Factory-Methode gelesen und verarbeitet"):
class HybridDockFactory {
    [[nodiscard]] static int make_dock(DockContractDescriptor const&, HybridDockVariant& out);
};
} // namespace
```
**std::variant-Einsatz EXAKT begrenzt (Verbots-/Erlaubnis-Kante):**
1. ERLAUBT: genau `HybridDockVariant` innerhalb `DockSlot` im Dock-Array der Hybrid-Tier-Binary — der Traeger dafuer, dass N ABI-stabile Pruef-Docks ZAHLENMAESSIG dynamisch variieren und TYPLICH abweichende Vertraege tragen koennen (Owner-Wortlaut "genau dafuer braucht es std::variant").
2. `std::visit` NUR zu Konfigurations-/Umschalt-Zeitpunkten (attach/detach/Break-Even-Umschaltpunkt des Routers). Nach dem visit wird der monomorphisierte Antrieb (IObservableTier* + Drive-Buendel) im Slot GECACHED — der Op-Hot-Path ist variant-frei und cast-frei (§49-KORREKTUR: Haupt-Kommunikation = statisches IObservableTier, zero-cost, §9-Doktrin).
3. VERBOTEN bleibt variant: in jeder plain Tier-Binary (uneingeschraenkt), in der Haupt-Observer-Kommunikation, als Achsen-Traeger (V7.2 "variadisches Array, KEIN std::variant" fuer Meta-Metas bleibt unberuehrt), und im Planer.
4. In der CEB bleibt variant GEDULDET (LEDGER:3489, unveraendert).

**Ownership/Lebenszyklus (rekursives RAII, spiegelt AnatomyModuleHandle):**
- Die CEB besitzt den vollen Lebenszyklus der Hybrid-Binary (Konfiguration + Compile + Messung am CEB-Pruef-Dock — pruef_dock.hpp:7-8-Doktrin unveraendert).
- In der Hybrid-Binary: die per comdare_create_anatomy erzeugte Instanz besitzt das DockArray -> DockSlot besitzt Proxy -> Proxy besitzt AnatomyModuleHandle. Zerstoerung: Router-Quiesce -> DockArray-clear (je Slot destroy_anatomy -> dlclose) -> Hybrid-Instanz-destroy -> CEB dlclosed die Hybrid-.so. Kein Slot wird waehrend einer laufenden Op verdraengt (Quiesce-Punkt am Op-Rand; Arbeitsmodus-Hot-Switch an der bewussten ABI-Grenze, LEDGER:187).
- Delegierter Bau (LEDGER:2230): die Hybrid-Stufe kompiliert NIE selbst; sie fordert plain Tier-Binaries per Anforderungs-Manifest (binary_id-Liste) bei der CEB an; die CEB baut/holt aus dem Lager und liefert .so-Pfade zurueck.

**Break-Even-Router (F8/§49):** hybrid_router.hpp konsumiert AxisSpline-Kurven (heuristik/measurement_curve_loader.hpp) und BreakEvenPoint-Listen (heuristik/break_even.hpp) und bildet daraus die CT-Chain-of-Responsibility der Heuristik-Ebene (LEDGER:490 Form (a): "noch eine Ebene NACH dem Command-Pattern in einer compile-time Chain-of-Responsibilities"). Option 1 (§49: heuristik-erkannte Algorithmen DERSELBEN Achse direkt einkompiliert) bleibt eine BAU-Option der Hybrid-Binary selbst (CEB kompiliert die Kandidaten-Algorithmen statisch hinein; Auswahl via CT-CoR, KEIN variant dafuer — §49-KORREKTUR verbietet variant fuer Break-Even-Algo-Swapping der Messkommunikation). Option 3 = das Dock-Array + Eviction dieses Designs.

### 2. XML-Schema-Entwurf (Auswertungsphasen-Konfiguration, Anwender waehlt Docks/Tier-Zuordnung)
Additives optionales Element in Code/test_data_xml/experiment_schema.xsd unter der comdare_experiment-Root-Sequenz (nach `<run_methodology>` xsd:62, vor `<measurement_framework>`; minOccurs=0 => alle Bestands-XMLs valide, golden-neutral):
```xml
<hybrid_tier enabled="true" genus="SearchAlgorithm">
  <dock_array storage="static|runtime" max_docks="8"/>   <!-- storage=static: CT-KAPAZITAET max_docks (Belegung dynamisch); runtime: unbegrenzt -->
  <eviction strategy="lru|lfu|arc|cost_aware" ram_budget_mb="4096"/>  <!-- §49-Verdraengungs-Strategie; Heuristik-Shortlist nach Web-Recherche -->
  <docks>
    <dock id="d0" contract="standard">                   <!-- contract-Token aus der constexpr contract-Registry; waehlt die variant-Alternative via Abstract Factory -->
      <tier_binary select="binary_id" value="..."/>      <!-- statische Zuordnung: explizite plain-Tier-binary_id aus dem Lager -->
    </dock>
    <dock id="d1" contract="rollback">
      <tier_binary select="heuristic"/>                  <!-- austauschbar: Router waehlt/swappt per Break-Even aus dem Lager -->
    </dock>
  </docks>
  <router><break_even source="measurement_store" curves="axis_splines"/></router>
</hybrid_tier>
```
Die Owner-"Zwischenloesung" bildet sich exakt ab: `<dock contract=...>` = die STATISCHE Seite (Dock-Typ je Slot steht nach Konfiguration fest), `<tier_binary select=...>` = die AUSTAUSCHBARE Seite (plain Binary je Pruefdock swappbar unter Eviction). Validierung additiv in profile_facade/validate_profile.hpp; contract-/strategy-Token kommen NUR aus constexpr-Registries (Registry=ANGEBOT-Doktrin, kein Runtime-Switch). JETZT wird nur die XSD-KOMMENTAR-RESERVE eingetragen (etabliertes COMPARE-Muster, experiment_schema.xsd:60 / run_methodology_registry.hpp:7-10); der Typ kommt mit HY-B3 in der Auswertungsphase.

### 3. Abgrenzung CEB vs. Hybrid-Stufe
CEB BLEIBT: Kompilation+System+Scheduling der Binary-Basics (V7.2); Bau ALLER Binaries inkl. der Hybrid-Binary und der delegiert angeforderten plain Tiers; Experiment-XML-/Registry-Parsing; PruefDockRegistry (EIN Dock je Gattung) + Sequencer + Konformitaets-Gate; Messung + CSV/Rueckschrieb (die Hybrid-Binary wird am CEB-Pruef-Dock wie jedes Tier gemessen, §64-Gemischt-Abnahme unveraendert); variant geduldet.
HYBRID-STUFE WIRD: eigene Stufe HINTER der CEB; haelt DockArray (N Docks, dynamisch) + Factory-Proxies + Break-Even-Router + Eviction; delegiert Bau-Wuensche an die CEB; aggregiert Sub-Tier-Observer-Snapshots Hybrid-intern zu ihrem EINEN nach oben gemeldeten POD; schreibt NIE selbst CSV (Ergebnis-Rueckschrieb bleibt CEB-Aufgabe nach Planer-Bestimmung).

**V7.2-Praezisierungs-Text (additiver Ledger-Vermerk unter LEDGER:89, Vorschlag):**
> [Stand 02.08. -> Owner-E1, docs/sessions/20260802-OWNER-entscheide-...md]: Der Satz "std::variant ... in ALLEN Tier-Binary-Typen verboten" ist PRAEZISIERT: Verbots-Scope = alle PLAIN Tier-Binaries (dort uneingeschraenkt, keine Ausnahme). Die HYBRID-Tier-Binary ist eine eigene Stufe HINTER der CEB und die EINE definierte Ausnahme: std::variant dort AUSSCHLIESSLICH als Traeger der Dock-Typ-/Vertrags-Varianz ihrer N ABI-stabilen Pruef-Docks, in einem wahlweise statischen oder Runtime-Dock-Array (Dock-Anzahl dynamisch einstellbar), gelesen+verarbeitet durch die Abstract-Factory-Methode (§49-KORREKTUR bleibt bindend). NICHT freigegeben bleibt variant fuer die Haupt-Kommunikation zu den Tier-Binary-Observern (statisches IObservableTier, zero-cost) und fuer jeden plain-Tier-/Planer-Code; CEB-Duldung unveraendert. Damit ist der E-11-Regelkonflikt (LEDGER:89 vs. LEDGER:2656/2659) AUFGELOEST — kein Konflikt, zwei Geltungsbereiche.

### 4. Bau-Zeitpunkt Auswertungsphase — JETZT freizuhaltende Schnittstellen (kein Rebuild der 2^17 Binaries)
1. **ABI-Nulllast (hart):** Die Hybrid-Stufe fordert KEINEN neuen vtable-Slot, KEIN POD-Feld, KEINE ABI-Aenderung — alles Benoetigte (tier_insert/lookup/erase/observe/reset, memento_all, scan, resource-control) existiert als Sub-Interface der ABI-7-Flaeche. Verifiziert machbar am Ist (observable_tier.hpp:185ff, search_algorithm_dock.hpp:65-86).
2. **E-24-Sequenz:** Container-Gattung = LETZTER ABI-Schritt und MUSS VOR dem Voll-Bau-4-Trigger in der Gate-Reihenfolge liegen (A16) — die Hybrid-Stufe erbt den finalen Major und laedt die Voll-Bau-Binaries ohne Neubau. KEIN eigener Hybrid-ABI-Schritt wird eingeplant.
3. **XSD-Kommentar-Reserve `<hybrid_tier>`** jetzt eintragen (COMPARE-Muster) — kein Parser-Zwang, aber der Platz in der Root-Sequenz ist benannt.
4. **A13-Stempel-Schnittstelle:** Hybrid-Identitaet = normale Tier-Stempel-Form ([[System],[Organ]] + SHA512-Zeile) der Hybrid-Binary; die Dock-Bestueckung ist RUNTIME-Konfiguration -> Sidecar-Manifest, NIE binary_id (golden-neutral). Von A13 wird nur gebraucht, dass die 'e'-Versions-Grammatik generisch je Achsen-Algorithmus gilt (ist sie per Owner-E2).
5. **Lager-Strecken-Schnittstelle (parallel, NUR benannt, nicht mitgeplant):** Hybrid konsumiert (a) Binaries-Realm: Lookup binary_id -> .so-Pfad + SHA512-Identitaet; (b) Messdaten-Realm: CSV/Kurven-Lookup je binary_id fuer measurement_curve_loader. Beides ist exakt die Bestandslog-/Baum-API der laufenden Lager-Strecke — keine Hybrid-Sonderknoten noetig.
6. **heuristik/-API-Freeze:** axis_spline.hpp/break_even.hpp/measurement_curve_loader.hpp im §75-Aufraeumpass NICHT umbenennen/entfernen (Router-Speisung).
7. **IPruefDock::measure-Vertrag stabil halten** (pruef_dock.hpp:78-79) — die Hybrid-Binary haengt als normales Modul daran.
8. **Verzeichnis-/Namespace-Reservierung** ce libs/cache_engine/hybrid/ (Design-Doc-Stub), damit kein anderes Paket den Namen belegt.

### 5. Migrationsschritte (Reihenfolge)
JETZT (vor Trigger, golden-/byte-neutral bis auf Doku+XSD-Kommentar): (M1) V7.2-Praezisierung + E-11-Aufloesung im Ledger, additiv; (M2) Design-Doc nach ce docs/architecture/ (dieses SOLL als Architektur-Dokument, additiv) + Verzeichnis-Stub; (M3) XSD-Kommentar-Reserve; (M4) Freeze-Vermerke (heuristik/, IPruefDock) in die §75-Kandidatenliste als NICHT-Kandidaten.
AUSWERTUNGSPHASE (nach Voll-Bau-4 + Voll-Messung, nach E-24): (M5) HY-B1 Kern (DockArray+Factory+Proxy); (M6) HY-B2 Router+Eviction (inkl. Web-Recherche Verdraengungs-Heuristiken, §49-Auftrag); (M7) HY-B3 XML scharf (XSD-Typ+Parser+validate); (M8) HY-B4 Hybrid-als-Tier-Export + CEB-Messung des Hybrids + Arbeitsmodus-Anschluss + Release-Observer-Abschaltung (LEDGER:3250). Jeder Schritt mit der stehenden Kadenz (ultracode-Planung -> Impl -> adversariale Pruefung -> CI-gruen).
