# UMSETZUNGS-DOSSIER #48 — XML-Gate: Aufraeumen + experiment_golden_kern NEU (2026-07-22 nacht)

> ultracode-Planungs-Workflow wf_ac9ffc27-d0c (3 Inventar-Agenten + Synthese, 484k Tokens).
> MANAGER-VERDIKTE zu den USER-GATES (a)-(f) — abgeleitet aus stehenden Gesetzen, transparent, Einspruch moeglich:
> V-a: Fork ④ = JA, drittes Token `fulljoin` mit Phase-3-Bindung (§59-A unterscheidet Stufe-2-Hybrid und Stufe-3-FullJoin WOERTLICH; User-KERN=Gesetz, Vermischung waere Regression).
> V-b: Maschinen-Schluessel = Kern-Identitaet (cpu_fabrication+ram_pair), hostname NUR Hint (§62-D/E-Gesetz); Traeger NUR comdare_experiment v2, Thesis-Kanal bleibt Interim-Legacy-Traeger der Abgabe-Kette.
> V-c: Storage-Slot JETZT deklarieren, INERT (§62-F verlangt die SYNTAX von Grund auf; §59-E-Timing betrifft nur den KONSUM).
> V-d: axis@pruefling = JA in #48 (Syntax+validate; §59-C/D); Emitter-Konsum bleibt S5/Post.
> V-e: prt-art = NICHT im Scope (je-Repo-GO-Doktrin), nur Vormerkliste.
> V-f: config_a/b/c deprecated/-Verschiebung OHNE je-Datei-GO = JA (git mv, kein rm; 0 Konsumenten belegt; Doku-nie-loeschen gewahrt).
> OFFENE USER-PUNKTE (nicht blockierend, in G7 gesammelt): allocators-Doku-Status, Zaehl-Pin-Wachstum nach 320er, Scheibe-6-Master-Ort (F27-Nachfolge), Legacy-Strang-Ausbau (P6/#229-geparkt).
> AUSFUEHRUNGS-FREIGABE: Scheiben 1-5 = Nacht-faehig (additiv-daneben, Abgabe-Kette byte-unberuehrt); Scheibe 6 = gegated nach 320er + User-GO.

UMSETZUNGS-DOSSIER PAKET #48 — XML-Gate (Aufraeumen + experiment_golden NEU auf KERN-Fundament)
Grundprinzip: ADDITIV-DANEBEN. Die 28.07.-Abgabe-Kette bleibt byte-unberuehrt; die neue KERN-Welt entsteht parallel, Umhaengung ist eine eigene, nach-320er-gegatete Scheibe.

========================================
(1) SCHEIBEN-SCHNITT (6 Scheiben, strikt sequenziell, je Scheibe eigener Commit-Satz + gruene Pipeline)
========================================

SCHEIBE 1 — Tote Altlasten deprecaten (nur super-Repo; NIE rm)
- `Code/experiment_config/deprecated/` anlegen; `config_a_prt_art_vs_sota.xml`, `config_b_cache_engine_perms.xml`, `config_c_merge_alt_neu.xml` per `git mv` dorthin + Kopf-Vermerk (DEPRECATED-Datum, Provenienz REV7.6, "supersedes: §59-KERN-Schema; R-C-Semantik lebt in Stufe1+Stufe3 der 3-Phasen-golden"). Damit ist die Wurzel-Tag-Kollision `comdare_experiment` (Alt vs. INC-C) faktisch entschaerft, ohne Loeschung.
- `messreihen.xml` + Legacy-Pfad (COMDARE_LEGACY_MESSREIHEN, main.cpp:183/1000/1003, Code/CMakeLists.txt:399-403): NICHT in Scheibe 1. GEPARKT hinter P6/#229-Vorbehalt (erst wenn E4-XML-Subsumtion der 3 Messreihen im golden-320-Volllauf bestaetigt). Falls User-GO frueher: Verschiebung NUR im selben Commit mit CMake-Anpassung des release_measure-Targets, sonst Target-Bruch.
- prt-art-Kandidaten (`permutation_axes_extension.xml`, `prtart_pruefling.profile.xml`): nur VORMERK-Liste in Session-Doc; Ausfuehrung erst nach explizitem je-Repo-GO (Doktrin). `prtart_pruefling` vorher als Quell-Material fuer die Pruefling-Akte der neuen golden sichten.
- Verifikation: super `test:unit` gruen, `release_measure`-Target konfiguriert weiter (messreihen.xml unangetastet), grep bestaetigt 0 Code-Referenzen auf verschobene Dateinamen.

SCHEIBE 2 — Lebende, NICHT abgabe-gepinnte Configs saeubern (Wohlgeformtheit + Deklarations-Hygiene)
- Kommentar-Doppelbindestrich-Fix (xmllint-wohlgeformt machen) NUR in: `cacheline_study`, `fb_numa_page_study`, `ff2_node_width_study`, `m3_golden_coverage`, `m3v2_sota_pilot`, `wdk_fairness_example` (alle inhalts-, nicht byte-gepinnt; Kommentare aendern keine Parse-Erwartung). EXPLIZIT NICHT: `all_axes_golden`, `m3_smoke_coverage`, `m3v2_study`, `messreihen.xml` (Abgabe-Kette/byte-frozen/geparkt).
- `allocators/*.profile.xml` (23): Kopf-Kommentar "DOKU-AKTE — kein Code-Leser; Allocator-Wahl = CT-Adapter (Statischer-Dispatch-Doktrin)" ergaenzen. Kein Move, kein Rename (Zaehl-Pin 23, P7). Formaler Doku-Status = Gegenvorschlag; finaler Deprecation-Entscheid user-gated (Doku-nie-loeschen).
- `permutation_axes.xml`: NICHTS (TABU T1/E12) — auch kein Kommentar.
- Verifikation: ce `contract:profile_coverage` + alle thesis_tiere-Unit-Gates gruen; xmllint ueber die 6 gefixten Dateien = 0 Fehler.

SCHEIBE 3 — experiment_golden NEU (KERN-Fundament, ADDITIV)
- Neue Datei `Code/test_data_xml/experiment_golden_kern.xml` (neuer Dateiname! Alte golden + ce-Kopie + Sync-Gate bleiben unveraendert stehen — Interim-GO-①-sicher). Wurzel `comdare_experiment version="2"` → sauberer Schema-Schnitt gegen INC-C-v1 UND Alt-REV7.6.
- Inhalt = Struktur-Entwurf aus (2): §59-KERN vollstaendig (pruefling je Achse, merge_mode inkl. fulljoin-Entscheid, template mode=full, negatives Blacklisting, run_methodology exactly-one, eigener id-Satz/3. Merge-Stempel) + §62 (Maschinen-Menge, compare-Reserve) + Storage-Slot (inert deklariert, Konsum K7b/K8 post-Abgabe).
- Achsen-Voll-Abdeckung 1:1 aus `all_axes_golden.profile.xml` uebernehmen (17 Achsen, A9-Unterachsen-Block, system_axes, measurement_tooling-Trio, writeback-Trio); Workloads ycsb_a..f; Datasets url/english_words/sosd_books_200M per akte_ref.
- STETS-GEPFLEGT-Pflicht: Datei bekommt Kopf-Block "KANONISCH AB #48; jede Schema-Evolution zuerst hier".
- Verifikation in dieser Scheibe nur xmllint-wohlgeformt (Parser-Naht kommt in Scheibe 4); kein bestehender Test darf die Datei schon lesen.

SCHEIBE 4 — Minimal-Parser-/Validator-Naht (Syntax-Traeger, KEIN Director-Konsum)
- XSD + PODs + parse + validate fuer die neuen Elemente, exakt an den identifizierten Andock-Punkten:
  a) `<machines>` neben `<system_axes>` (XSD:37-Nachbar); POD in ExperimentProfile; parse analog parse_system_axes; validate: Identitaets-Schluessel wohlgeformt.
  b) `pruefling`-Attribut an `<axes_default_lookup><axis>` (XSD:191-199 + ExperimentAxisDefault + validate: Wert ∈ lebewesen ∪ kCacheEngineSelfMarkers; Fallback = Phasen-Identitaet merge_plan.hpp:55-62).
  c) merge-Token-Satz gemaess Fork-④-Entscheid (s. Risiken; Default-Vorschlag: drittes Token `fulljoin` + validate-Check "nur in Phase-3-Bindung"). merge_plan.hpp:46-49-Projektion nachziehen.
  d) `<storage>` unter `<output>` (backend local|minio + endpoint): parse+validate, Konsum = 0 (inert, dokumentiert).
  e) run_methodology: 4. Registry-Eintrag `compare` gehoert zu #47, NICHT hierher — in #48 nur XSD-Doku-Kommentar als Reserve. exactly-one bleibt beidkanalig hart (ist schon: validate:480-486/1126-1132).
- Neue Unit-Tests gegen `experiment_golden_kern.xml` (eigene Testdatei, additiv; KEINE Aenderung an test_experiment_parser/projection/plan_director-Pins).
- Verifikation: ce-CI komplett gruen inkl. contract:profile_coverage (alte Pins unberuehrt), neue Tests gruen.

SCHEIBE 5 — Schema/XSD-Konsolidierung
- `experiment_schema.xsd` = EINZIGES Ziel-Schema (juengster Stand KERN-A S4 als Basis): v2-Root, Blacklisting-Semantik als Doku-Annotation ("ungenannte Achse = volle Registry-Liste"), run_methodology fuer v2 exactly-one (minOccurs=1), machines/storage/axis@pruefling/fulljoin formalisiert, compare in RunMethodologyType-Kommentar reserviert. version-Attribut Pflicht.
- `messreihe_v32_schema.xsd` + `messreihe_v32_schema_example.xml`: DEPRECATED-Kopf-Kommentar ("Legacy-Fixture, BEHALTEN per INC-D; kein Ziel-Traeger — neue Felder NUR in experiment_schema.xsd"), nicht verschieben (8 bzw. 5 Test-Referenzen).
- SCHEMA.md nachziehen (Traeger-Landkarte: comdare_experiment v2 = Ziel; comdare_thesis_profile = Interim-Traeger der Abgabe-Kette).
- Verifikation: xmllint --schema gegen experiment_golden_kern.xml lokal (Einmal-Verifikation, kein CI-Gate noetig); alle Pipelines gruen.

SCHEIBE 6 — Umhaengung (GEGATET: erst NACH dem 28.07.-320er + User-GO)
- Tests (4 Suiten P5) + Fixture-Sync-Paar + XSD-Referenzen von alter golden auf `experiment_golden_kern.xml` umziehen; alte golden (beide Kopien) nach deprecated/ bzw. mit DEPRECATED-Kopf; Sync-Gate abloesen (E7-Single-Source/Bruecke I7, Master-Ort-Entscheid = offene F27-Nachfrage). NICHT Teil des #48-Gates vor den Code-Paketen — #34-#37 duerfen nach Scheibe 5 starten.

========================================
(2) STRUKTUR-ENTWURF experiment_golden_kern.xml
========================================

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- KANONISCH AB #48. §59-KERN + §62. STETS pflegen: Schema-Evolution zuerst hier. -->
<comdare_experiment version="2" id="diplomarbeit_golden_kern"
    xsi:noNamespaceSchemaLocation="experiment_schema.xsd">

  <!-- Fork ⑤: mode="full" = Voll-Whitelist-Basis aus Registry (ANGEBOT);
       ref = benannter Paper-Template (post-v3); restrict via allowed_variants unten. -->
  <template mode="full"/>

  <!-- §62-C/D/E: Maschinen-MENGE = CI-Fertig-Gate-Kriterium, KEINE Zustaendigkeits-
       Aufteilung. EINE XML fuer beide Maschinen (Symmetrie-Regel). Identitaet zweistufig:
       Kern = CPU-Fabrikation + RAM-Paar; hostname nur Hint. -->
  <machines>
    <machine id="prod1" cpu_fabrication="amd_zen4_avx512" ram_pair="ddr5_2x32" hostname_hint="prod1"/>
    <machine id="prod2" cpu_fabrication="intel_avx2"      ram_pair="ddr4_2x32" hostname_hint="prod2"/>
  </machines>

  <!-- exactly-one je CALL (Modus = Call-Parameter, NIE Binary-Stempel).
       Werte: debug|measure|release; 'compare' = #47-Reserve (liest Mess-Replay
       der registrierten Maschinen nach release). -->
  <run_methodology><method value="measure"/></run_methodology>

  <!-- Registry=ANGEBOT; ids tragen Wurzel-engine-Erwartung (K7-Generisierung = post-v3). -->
  <engines>
    <engine id="ee_ce"  registry="cache_engine_axis_registry.xml"/>
    <engine id="ee_prt" registry="prt_art_axis_registry.xml"/>
  </engines>

  <!-- §59-A: optional; leer => derive_default_experiment_phases() (3 Default-Stufen).
       pruefling-Attribut je Phase; id_namespace = eigener id-Satz / 3. Merge-Stempel
       (§59-C: Merges sind ADDITIV, CRC-131072-Satz bleibt unberuehrt). -->
  <phases>
    <phase name="Stufe1_CeOnly"/>
    <phase name="Stufe2_PrueflingReplace" pruefling="ee_prt" id_namespace="merge_prt_v1"/>
    <phase name="Stufe3_FullJoin"         pruefling="ee_prt" id_namespace="join_prt_v1"/>
  </phases>

  <!-- Negatives Blacklisting: reines LIMIT — ungenannte Achse = VOLLE Registry-Liste
       ("alles messen" = Default). merge: replace(Default)|merge(CE+Pruefling-Hybrid,
       nur Override)|fulljoin(NUR Phase-3-Bindung; validate erzwingt).
       pruefling: von welchem Pruefling je Achse; "self" = CacheEngine (Fork ③). -->
  <axes_default_lookup>
    <axis ref="search_algo"      pruefling="ee_prt" merge="replace"
          allowed_variants="binary_search,linear_search"/>
    <axis ref="path_compression" pruefling="ee_prt" merge="merge"/>
    <!-- alle uebrigen Achsen absichtlich UNGENANNT = Voll-Sweep -->
  </axes_default_lookup>

  <system_axes> <!-- 1:1 aus all_axes_golden (Compiler-Achse + dyn. Unterachsen, A9-Block) --> </system_axes>
  <workloads>ycsb_a..ycsb_f</workloads>
  <datasets>
    <dataset akte_ref="test_data_xml/url.test_data.xml"/>
    <dataset akte_ref="test_data_xml/english_words.test_data.xml"/>
    <dataset akte_ref="test_data_xml/sosd_books_200M.test_data.xml"/>
  </datasets>
  <measurement_framework name="ycsb"/>
  <measurement_tooling> <!-- Einzel-Combos wie golden: {wallclock},{...},{...} --> </measurement_tooling>
  <writeback_methods>   <!-- volles Trio: csv, binary, latex --> </writeback_methods>

  <output>
    <!-- §59-C-Slot, in #48 INERT (Konsum K7b/K8 post-Abgabe): -->
    <storage backend="local"/> <!-- alternativ: backend="minio" endpoint="minio.comdare.de" -->
    <csv_path .../> <binary_path .../> <latex_path .../>
  </output>

  <identity marker="CacheEngine"/>
</comdare_experiment>
```

========================================
(3) PIN-/KONSUMENTEN-MATRIX (was bricht wo; Lockstep-Pflicht)
========================================

| Datei/Familie | Pins/Konsumenten | Betroffene Scheibe | Lockstep-Pflicht |
|---|---|---|---|
| m3v2_study.profile.xml | test_profile_roundtrip (320 ids positionsident., Literal-Pins), Driver-Default (02_messung_driver/CMakeLists:24-27), TABU-Wachen in 4 Tests, ce contract:profile_coverage | KEINE (frozen) | — (jede Byte-Aenderung = Abgabe-Lauf misst anderes) |
| m3_smoke_coverage.profile.xml | test_smoke_coverage_profile (Zaehl-Pins 7/17/21/21/2/1), super-CI :608 | KEINE (frozen) | — |
| all_axes_golden.profile.xml | super-CI :808/884/917-921/963/1179, Emitter :464, plan_director-Test (17 Achsen), GN_ALGO_SIG/minio-Marker | KEINE (frozen); dient S3 nur als Lese-Referenz | — |
| 4 Registry-XMLs (ce/system/measurement/prt) | Byte-Roundtrip-Gates (registry_roundtrip.cmake, prt-art CI :79-88), Driver-Compile-Defs | KEINE | Aenderung NUR via Generator + Mit-Commit |
| experiment_golden.xml (Paar) | Fixture-Sync (fixture_sync_check.cmake:32-45), 4 Test-Suiten (P5: 2 engines/3 Phasen/6 variants/5 Kategorien/19 Passes), Compile-Defs tests/unit/CMakeLists:2679ff | S6 (gegated) | Master+Kopie+Provenienz in EINEM Commit-Paar; einseitige Loeschung => stiller SKIP (F33/F66-Falle) |
| config_a/b/c | 0 Konsumenten (Parser-Kommentar bestaetigt) | S1 | keiner; grep-Nachweis in Commit |
| messreihen.xml | Code/CMakeLists:403 (release_measure), Legacy-Gate main.cpp:1003 | GEPARKT | CMake im selben Commit; P6/#229-Nachweis vorher |
| 6 nicht-frozen thesis_profiles | Inhalts-Pins: kf1 (cacheline base_tiers art), ff2/fb (argv+Sub-Ebenen), test_validate_profile (e) (m3v2_sota_pilot), wdk+measurement_categories (Literal-Stempel-String) | S2 (nur Kommentare) | Kommentar-only = kein Pin betroffen; ctest-Nachlauf Pflicht |
| sota/*.xml (33) + sota_h2_scores | Zaehl-Pin ==P1..P33, art/masstree Regex-frozen, H2-Akte 1:1-Pin (Tool-generiert) | KEINE | Add/Remove verboten bis nach 320er; H2-Akte nie von Hand |
| allocators/*.xml (23) | Zaehl-Pin ==A1..A23 (Verzeichnis-Scan) | S2 (nur Kopf-Kommentar) | kein Move/Rename/Delete |
| load_profiles/*.xml (21) | workloads==21-Pin (smoke), discover_load_profiles, golden-Referenzen | KEINE | — |
| *.test_data.xml (8 Akten) | CRC-Dreifach-Anker (Akte+Testkonstanten+akte_ref) | KEINE (S3 referenziert nur) | — |
| experiment_schema.xsd | kein CI-Gate (nur Kontrakt-Referenz fuer validate_profile) | S4+S5 | validate_profile.hpp-Spiegel (OpTypeType :569/891) synchron halten |
| messreihe_v32_schema.xsd/_example.xml | 8+5 Test-Referenzen 02_messung_driver | S5 (nur DEPRECATED-Kopf) | nicht verschieben |
| Emissions-Legenden (chunk-Jobnamen, search_algo/cache_traversal/mapping, O2/O3, no_extension/avx2) | plan_director-Byte-Pins :479-501/676-697/900-912 | KEINE | keine Namens-Umbenennung in Registries/Profilen |

========================================
(4) TABU-LISTE (NIE anfassen in #48)
========================================
1. `permutation_axes.xml` (E12: hart TABU read-only — auch kein Kommentar/Format).
2. `golden_fullpilot_320_binary_ids.txt` (Byte-Wache, Doppel-Anker CRC64).
3. m3v2_study / m3_smoke_coverage / all_axes_golden .profile.xml (Abgabe-Kette, Interim-GO ①).
4. Die 4 Registry-XMLs von Hand (nur Generator-Weg).
5. altes experiment_golden.xml-PAAR + fixture_sync-Gate (bis Scheibe 6/GO).
6. Alle 8 *.test_data.xml-Akten (Messdaten-nie-loeschen).
7. kNewGolden131072Crc64 + FullSourceCatalog (CRC haengt am C++-Katalog, NICHT an XML — weder falsche Schonung noch falsche Kuehnheit).
8. sota/-Bestand inkl. art/masstree (Regex-frozen) + sota_h2_scores.xml.
9. Vendor-XMLs (userspace-rcu extras/abi), .idea/, thesis/_archiv_entwurf1/.
10. Emissions-Legenden-Namen (Achsen-/Varianten-/Perm-Bezeichner in emittierter YAML/CMake).
11. prt_art_axis_registry.xml (Master + ce-Kopie) — der klassische Aufraeum-Unfall waere die Verwechslung mit den 2 toten Nachbarn im selben Ordner.

========================================
(5) RISIKEN + GEGENMASSNAHMEN
========================================
- R1 Abgabe-Bruch durch In-Place-Rewrite: Gegenmassnahme = additiver Dateiname + v2-Root; CI-Diff-Check je Scheibe, dass keine TABU-Datei im diff-stat auftaucht (Working-Tree-Freeze-Doktrin).
- R2 Fork-④-Semantik-Drift (merge vs fulljoin per Achse): USER-GATE vor Scheibe 4. Gegenvorschlag: drittes Token `fulljoin` mit Phase-3-Bindungs-Check (trennt §59-A(2)-Hybrid sauber von A(3)); Alternative (dokumentierter Ist-Entscheid merge→Stufe3) nur bei explizitem User-OK — User-KERN-Wortlaut unterscheidet beide, Abweichung = Regression.
- R3 Maschinen-Schluessel falsch geschnitten (hostname statt Kern-Identitaet): Entwurf traegt cpu_fabrication+ram_pair als Pflicht, hostname nur Hint; validate prueft Schluessel, nicht Namen. Offen (User): Andockt die Menge auch im Thesis-Kanal? Vorschlag: NUR comdare_experiment v2 (Fork ②), Thesis-Kanal bleibt Interim-Legacy-Traeger.
- R4 Instanz-lose KERN-Syntax = ungetestete Syntax: Scheibe 4 liefert Parser-Naht + eigene Tests GEGEN die neue golden im selben Paket — kein Element ohne Test-Beleg (bekannte template-No-Op nicht wiederholen).
- R5 Stiller Fixture-Sync-SKIP bei einseitiger Loeschung: in #48 wird keine Seite geloescht; Scheibe 6 loest Gate + beide Kopien atomar ab.
- R6 messreihen.xml-Entfernung bricht release_measure: geparkt; Ausbau nur Commit-atomar mit CMake + P6/#229-Nachweis.
- R7 Doku-nie-loeschen-Verstoss: ausschliesslich `git mv` nach deprecated/ + Kopf-Vermerk; rm braeuchte je-Datei-User-GO (GO-③-Praezedenz) — wird nicht beantragt.
- R8 Zaehl-Pin-Bruch durch "Aufraeum-Adds": #48 fuegt KEINE Dateien in gezaehlte Verzeichnisse (sota/allocators/load_profiles/thesis_profiles) hinzu; die neue golden liegt in test_data_xml/.
- R9 XSD-Drift unbewacht (kein CI-Gate): Scheibe 5 ergaenzt lokalen xmllint-Nachweis im Commit-Text; ein optionales ctest-xmllint-Gate ist Gegenvorschlag fuer post-#48 (nicht Pflicht, xmllint ggf. nicht auf Runnern).

========================================
(6) BEWUSST NICHT IN #48
========================================
- compare-Modus-Implementierung (Registry+Enum+3 static_assert-Bloecke+Director) = Paket #47; #48 reserviert nur die Syntax dokumentarisch.
- Director-/Emitter-Konsum der neuen Elemente (machines statt measure_host_lane, template-mode-full-Durchgriff, Storage-Backend, K5/S5-Emitter-Generalisierung beliebiger (Achse,Pruefling)-Slots, generischer Engine-Kanal fuer dritte Pruefling-Repos) = Code-Pakete #34-#37/S5 bzw. K7b/K8 post-Abgabe.
- Umhaengung der Tests/CI auf die neue golden + Abloesung Sync-Gate/Kopien-Kette (Scheibe 6, nach 320er + User-GO; Master-Ort super vs. ce = offene F27-Nachfrage).
- Legacy-Strang-Ausbau (messreihen.xml, COMDARE_LEGACY_MESSREIHEN, v32-Testkette) — geparkt hinter E4-Subsumtions-Nachweis.
- prt-art-Repo-Aenderungen (nur Vormerkliste; je-Repo-GO).
- Jede Aenderung an Mess-CSVs/Build-Dirs (vor rm -rf build: getrackte Mess-CSV pruefen) und an tier150_measurements.csv (GO ③).
- .idea/, Vendor-XMLs, Thesis-Archiv.

USER-GATES vor Start (Gegenvorschlag jeweils enthalten, Zuweisung ≠ Start-Signal): (a) Fork ④ fulljoin-Token [Vorschlag: ja, drittes Token]; (b) Maschinen-Schluessel-Form [Vorschlag: Kern-Identitaet, hostname=Hint] + Traeger nur comdare_experiment v2; (c) Storage-Slot inert jetzt [Vorschlag: ja, §62-F schlaegt §59-E-Timing fuer die SYNTAX]; (d) axis@pruefling in #48 [Vorschlag: ja, Syntax+validate; Emitter-Konsum S5]; (e) prt-art-Scope [Vorschlag: nein, nur Vormerkung]; (f) config_a/b/c deprecated/-Verschiebung ohne je-Datei-GO [Vorschlag: ja, da kein rm].


## OFFENE FRAGEN DER ANALYSE (triagiert, s. Verdikte + G7)

- F27 (user-gated) bleibt offen: Welche experiment_golden.xml-Kopie war kanonisch? Per §62-F irrelevant fuer den Neubau (beide verworfen, neue from scratch) — aber zu klaeren ist, WANN Sync-Gate (fixture_sync_check.cmake) + beide Kopien abgeloest werden (E7-Single-Source/Bruecke I7).
- Darf der komplette Legacy-Strang (config_a/b/c + messreihen.xml + COMDARE_LEGACY_MESSREIHEN-Pfad + CMake release_measure-Verdrahtung Code/CMakeLists.txt:399-403) entfernt werden? P6/#229-Vorbehalt: erst wenn die E4-XML-Subsumtion der 3 Messreihen im golden-320-Voll-Lauf bestaetigt ist.
- allocators/*.profile.xml (23 Akten, comdare_allocator_profile): kein Code-Leser gefunden — bewusste Doku-Akten oder vergessener Ausbau? Vor Deprecation User-Entscheid (Doku-nie-loeschen-Direktive).
- permutation_axes.xml: nur Kommentar-/TABU-Referenzen gefunden, kein Laufzeit-Load — bitte bestaetigen, dass auch der super-seitige ExperimentDriver (Full-Mode) die Datei nicht doch indirekt liest, bevor sie deprecatet wird.
- KEIN einziges Bestands-XML traegt Blacklisting oder merge_mode als Element; <template> existiert NUR im XSD (KERN-A S4, minOccurs=0) und run_methodology ist im XSD optional statt exactly-one — das §59-KERN-Schema muss vollstaendig neu entstehen; experiment_schema.xsd (Stand 20.07.) ist der beste Ausgangspunkt.
- 9 aktive/teilaktive XMLs sind strikt NICHT wohlgeformt (Doppel-Bindestrich in Kommentaren; xmllint-Fehler): messreihen.xml + 8 thesis_profiles (all_axes_golden, cacheline_study, fb_numa_page_study, ff2_node_width_study, m3_golden_coverage, m3_smoke_coverage, m3v2_sota_pilot, wdk_fairness_example) — nur der tolerante ce-DOM-Parser liest sie; beim Neubau standardkonform anlegen.
- Kompressionshinweis: die drei homogenen Familien sota/ (33), allocators/ (23), load_profiles/ (21) sind als je EIN Familien-Befund mit vollstaendiger Dateiliste erfasst; alle uebrigen Dateien einzeln.
- Fork-④-Auslegung: Bleibt per-Achse merge='merge' bewusst als Stufe3_FullJoin materialisiert (merge_plan.hpp:46-49), oder braucht das #48-Syntax-Gate ein drittes per-Achse-Token 'fulljoin' mit Phase-3-Bindung, um §59-A(2)-Hybrid und A(3)-FullJoin zu trennen? (User-KERN-Wortlaut unterscheidet beide.)
- Maschinen-Mengen-Syntax (#48): Soll die Deklaration hostname-basiert sein oder direkt den zweistufigen §62-D/E-Identitaets-Schluessel (Kern-Identitaet CPU-Fabrikation + RAM-Paar, modulo Meta-Meta-Achsen) tragen? Und dockt sie NUR im comdare_experiment (Fork ②) oder auch im Thesis-Kanal an (die 8 A9-Profile leben ausschliesslich dort)?
- Traeger-Konvergenz: Die 8 A9-Profile nutzen comdare_thesis_profile, KERN-A-Elemente (template/merge_mode/identity/phases-Ableitung) existieren nur im comdare_experiment-Kanal — fuehrt das #48-Gate beide Kanaele zusammen oder bleibt der Thesis-Kanal ein Legacy-Traeger mit A9-Teilmenge?
- Storage-Syntax-Timing: §59-E ordnet K7b/K8 (Storage lokal/minio) der Post-Abgabe zu, §62-F verlangt aber die XML-Syntax JETZT von Grund auf — soll die neue golden-XML den Storage-Slot bereits deklarieren (inert), oder bleibt er bewusst aus der #48-Syntax draussen?
- Per-Achse-Pruefling-Attribut: Fuer Multi-Pruefling-Profile (jedes Paper = eigener Pruefling mit eigenem id-Satz, §59-C/D) fehlt das pruefling-Attribut an <axes_default_lookup><axis> — ist das Teil des #48-Syntax-Gates oder erst des S5-Emitter-Pakets?
- Kanonizitaets-Entscheid fuer die NEUE experiment_golden.xml (#48): neuer Dateiname additiv neben der alten (empfohlen, Interim-GO-①-sicher) ODER In-Place-Ersetzung mit Lockstep in 4 Test-Suiten + Fixture-Sync-Paar? Und: wird der kuenftige Master im super (Code/test_data_xml/) oder im ce-Repo gefuehrt (F27 sagt: derzeit KEINER kanonisch; E7-Single-Source waere der Anlass, die Kopie-Kette ganz abzuloesen)?
- Gilt Doku-nie-loeschen formal auch fuer tote XML-Configs? Praezedenzen sagen ja (messreihe_v32 'BEHALTEN', Tools 'deprecaten nie loeschen'), GO ③ zeigt aber, dass der User punktuell rm freigeben kann — braucht es fuer config_a/b/c ein explizites je-Datei-GO oder reicht deprecated/-Verschiebung ohne Rueckfrage?
- Duerfen die zaehlungs-exakten Coverage-Pins (sota==33, allocators==23, workloads==21, axis_sweeps==17) im Zuge der Aufraeumung mitwachsen, falls #48 neue Profile/Registrierungen hinzufuegt — oder ist jede Zahl bis nach dem 320er eingefroren (EXPECT_EQ bricht auch bei ADDITIVEN Ergaenzungen)?
- Scope-Klaerung: umfasst #48 auch das prt-art-Repo (prtart_pruefling.profile.xml / permutation_axes_extension.xml) oder strikt nur super + ce? (Je-Repo-GO-Doktrin.)
- Soll die neue #48-Syntax (Maschinen-Menge je §62-C, run_methodology inkl. 4. Wert compare) in die bestehende experiment_schema.xsd einfliessen oder als neues Schema-Dokument entstehen (die XSD wird von keinem CI-Gate validiert — xmllint war nur Einmal-Verifikation, d.h. Schema-Drift bliebe derzeit unbewacht)?
