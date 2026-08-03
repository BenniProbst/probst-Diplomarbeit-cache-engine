# DOSSIER -- E-24-FENSTER-BAUPLAN (ultracode-Planungssession, L4-Pflicht)

> ZWECK: Bindender Bauplan fuer das E-24-Container-Gattungs-ABI-Fenster (GATE 4) -- der LETZTE ABI-Schritt
> vor dem Voll-Bau-4-Trigger. Liefert die von E24-Dossier:176/OP-7 + FAHRPLAN:57 (L4) geforderten Stuecke:
> Detail-Schnitt je Genus, Commit-Zug, Orakel-Definitionen, FK-ID-Vergabe, Migrationsliste, Bau-Slot +
> belastbare Zeitschaetzung. Struktur nach dem M3-Dossier-Muster (docs/sessions/20260803-DOSSIER-a13-m3-ausfuehrung.md).
>
> BASIS-SHA (live verifiziert 04.08. frueh): ce development == 0b3a0b39f0b471c88af6d2915d0b3a5e58e3bd65,
> porcelain leer. A13 KOMPLETT (M1..M4), ENFORCE=1 scharf, Contract 7.1 (LEDGER:3754-3755); OD-10-RT gelandet
> (LEDGER:3761); lokale Gate-Zahl der Linie 332 (LEDGER:3761 -- lebendes Gate, VOR Baustart LIVE neu erheben).
>
> HARTE VORBEDINGUNGEN (Reihenfolge bindend, LEDGER:3750/:3764 + FAHRPLAN:13-18):
> A1-Lager-Rest -> W10 -> [DIESES FENSTER] -> A8-S3/S4/S5-Rest -> EIN ANKER-VOLLZUG (TP1-Neu-Inventur +
> A2-SHA512-Eichung = GATE 5, L14) -> Trigger-Sequenz Do 07.08. Die ABI-neutrale M0-Vorstufe (C0) ist
> SOFORT parallelisierbar (FAHRPLAN:57). A8-S1 hat VORRANG und laeuft VOR jeder Messung (FAHRPLAN:59, L6).
>
> REVIEW-VERMERK (adversariales Fable-Review wf_62f843be, Verdikt TRAGFAEHIG; Befunde B1-B6 eingearbeitet
> 03.08. spaetnachts durch den Lead): B1 Slot-Pin-Zeilen container_framework.hpp auf :93-:96 korrigiert |
> B2 genus_binding_traits.hpp-Primaertemplate :31-32 | B3 ALLE LEDGER:NNNN-Zitate dieses Dossiers sind auf
> den super-Stand d9ddd29e GEPINNT (`git -C super show d9ddd29e:docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`);
> ab super-HEAD 94d82dc1 liegen sie +6 Zeilen tiefer (Kopf-Klausel-Commit) | B4 Startklar-Punkt 3 auf
> "S1 GELANDET vor b-Teil-Start" verschaerft | B5 Zeitschaetzung arithmetisch ehrlich (31-33,5 h) +
> Phase-4-Verdraengung benannt | B6 Auftrags-Pfadfehler betraf nur den Review-Auftrag, nicht das Dossier.
>
> QUELLEN: E24-DOSSIER = ce docs/architecture/20260803-e24_container_gattungs_abi_dossier.md (v2, 352 Z.).
> A8-DOSSIER = ce docs/architecture/20260803-a8_f2_benchmarking_schnitt_soll_design.md. LEDGER =
> super docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md. FAHRPLAN = super docs/sessions/
> 20260803-FAHRPLAN-gesamtkette-wellen-phasen.md. A15-DESIGN = super docs/sessions/backups/
> 20260802-design-owner-entscheide-workflows/A15-fehlerklassen.md. Owner-Wortlaute: E24-DOSSIER:25
> (ANKER:115-118), OWNER-Doc:19/:74-76 (Q5-GO ~17:4x), LEDGER:1576-1581 (F1b = MAJOR, UNVERHANDELBAR).

---

## Paragraf 0 -- Entscheids-Grundlage (nichts neu erfunden, alles belegt)

- SCOPE: E-24 = Vervollstaendigung der Gattungen SearchAlgorithm + Container als LETZTER ABI-Schritt
  (E24-DOSSIER:25, Owner-Wortlaut). EIN S12-Fenster ohne stillen Split; Cross-Genus-Komposition GEHOERT
  HINEIN; jeder Verschiebe-Wunsch = Owner-Entscheid (E24-DOSSIER:262, Auflage 2). Graph-Gattung NACH
  Abgabe (Q5 via Owner-GO ~17:4x, OWNER-Doc:74-76; E24-DOSSIER:163-164: Enumerator anatomy_base.hpp:43
  `Graph = 2` UNANGETASTET -- am Ist verifiziert).
- SEQUENZ: MANAGER-ENTSCHEID GEFAELLT -- getrennte Fenster M3->M4->E-24 (Option C') mit A8-Kopplung
  (LEDGER:3731); Kette E24-DOSSIER:231-233. HY-D2-Kante: Fenster ZWINGEND VOR dem Trigger, sonst lehnt
  der Loader-Major-Check (anatomy_module_loader.hpp:149 "5. Major-Version match" -- am Ist verifiziert
  :145-152) alle eingelagerten Binaries ab = Neubau ALLER Binaries, von Owner-E3 ausgeschlossen
  (E24-DOSSIER:27).
- IDENTITAETS-EBENEN (E24-DOSSIER:178-185, nicht vermengen): A13 = STEMPEL (gelandet), W10 = STEMPEL-
  Zellwerte (vor E-24), E-24 = ABI-/LAGER-KEY (+ceb=), A8 = SHA512-FINGERPRINT der Tier-Binaries.

---

## Paragraf 1 -- Fundstellen-Inventur + DETAIL-SCHNITT JE GENUS (Pflicht-Inhalt 1)

### 1.0 Ist-Anker (alle 04.08. am HEAD 0b3a0b39 live verifiziert)

| Flaeche | Ist (datei:zeile) |
|---|---|
| ABI-Major/Minor | abi/anatomy_module_abi_v1_decl.hpp:62 `#define COMDARE_ANATOMY_ABI_MAJOR 7`, :63 MINOR 0 |
| Magic | decl:66 `0x434F4D444141372EULL` ("COMDA*A7*") |
| CEB-Contract | decl:327 `kCebContractCodegenMinor = 1` (M4), :332 `kCebContractVersion{MAJOR, Minor}` = 7.1 |
| Store-Key-Naht | artifact_cache.hpp:284-288 `cache_key_prefix` = build_version + "+ceb=" + MAJOR + "." + Minor + "+mtool=..." |
| Loader-Wache | anatomy_module_loader.hpp:145-152 (7-Schritt-Validierung, Schritt 5 Major-match); destroy-vor-dlclose :70-75 |
| Pin-Test | test_v41_anatomy_module_abi.cpp:60 `major == 7`, :82 `kCebContractCodegenMinor == 1`, :95 Layout-6-Tripwire |
| Gattungs-Enum | anatomy_base.hpp:40-44 (SearchAlgorithm=0/Container=1/Graph=2); Genus-Enum :78ff; F1b-Verweis-Kommentar :72-77 ("SEPARATE ... ABI-Schritt F1b (NICHT hier)" -- wird mit diesem Fenster wahr, Kommentar-Nachzug C11) |
| Kopf-Framework-Keim | container_framework.hpp:15-25 (Re-Export + STALE "Version 4->5"; Ist 7->8 per LEDGER:3731); :85-95 self-proving asserts type_count==4, Slots 11/13/9/5 |
| Genus-Traits (Wachen-Klasse) | genus_binding_traits.hpp:31-32 Primaertemplate undefiniert; :36-40 Q-8-TABU persistence_target ("Wer das aendert, braucht einen neuen Owner-Entscheid"); Spezialisierungen :42 SA / :67 Adapter / :93 Set / :120 Sequence / :145 View |
| Cross-Genus-Sperre | set_abi_adapter.hpp:18-21 static_assert "Cross-Genus-Adapter sind type-system-mathematisch unmoeglich" (bleibt BESTEHEN) |
| OrganConcept | EXISTIERT NICHT (grep 0 Treffer; nur unverwandtes EytzingerTraversalOrganConcept; E24-DOSSIER:102 bestaetigt) |
| Engines | search_algorithm_permutation_engine.hpp:185 `for_each_abi_adapter` (EINZIGER Traeger, grep-belegt); set_/sequence_/view_permutation_engine.hpp existieren OHNE for_each_abi_adapter; adapter_permutation_engine.hpp EXISTIERT NICHT |
| Dock-Vertrag | pruef_dock.hpp:36-48 dock_status_* (ok=0/no_anatomy=1/wrong_genus=2/subinterface_missing=3/conformance_failed=4); :74-79 V5-Konformitaets-Gate-VERTRAG (HY-D2-Freeze) |
| Dock-Registry | pruef_dock_registry.hpp:4-5 STALE "Set/Sequence/Adapter/View kommen mit V42" (am Ist verifiziert); einziger produktiver Registrierer apps/f15_compare/main.cpp:220 `reg.register_dock(...SearchAlgorithmDock...)` (am Ist verifiziert :218-222) |
| Observer | observer_aggregate.hpp:2 STALE "17-Achsen-Snapshot", :77-79 "17 named Snapshot-Members" (am Ist verifiziert) |
| T17-Defekt (A8-S1) | abi_adapter.hpp:861 + :1687 `for (int i = 0; i < 17; ++i)`; node_value_measurement.hpp:72 `t < 17` -- ALLE DREI am Ist UNVERAENDERT vorhanden: A8-S1 ist NICHT gelandet |
| axes-Bestand (A8-S5) | 340 .hpp unter libs/cache_engine/axes/, davon 70 mit std-Container-/OS-Call-Treffern (eigener grep 04.08.; die "54" in E24-DOSSIER:189 ist STALE -- Zaehlungs-Doktrin M3-Dossier:120 "Bindend sind die grep-Kommandos, nicht die Zahlen") |
| ENFORCE | 12 Wirkstellen (R3-Erhebung), Pflicht-Durchlaufpunkte fuer neue Genus-Listen: abi/system_axis_code_versions.hpp:120-124 + axis_variant_version_table.hpp:95-109 (ENFORCE-Zweig ueber alle registrierten algo_version-Literale) |

### 1.1 Detail-Schnitt SET (13 Slots -- groesstes Genus)

- Slot-Liste (am Ist, genus_binding_traits.hpp:106-112): search_algo, cache_traversal, path_compression,
  node_type, memory_layout, allocator, prefetch, concurrency, serialization, index_organization,
  io_dispatch, migration_policy, filter. Slot-Pin container_framework.hpp:94 `slot_count == 13`.
- Liefergegenstaende (E24-DOSSIER:151-152 (a)-(f)): (a) reale Organ-Member + observe-Verdrahtung in der
  Set-Anatomie; (b) SetObserverAggregate<13> per-Achse statt flachem Hand-POD (Wire-POD append-only bzw.
  V2 NUR im Fenster -- Commit C6); (c) for_each_abi_adapter in set_permutation_engine.hpp (C2);
  (d) SetDock produktionsreif: IPruefDock-Impl + DLL-Pfad ueber denselben Loader + Konformitaets-Orakel
  + Registry (C4); (e) SetExecutionContext (C3); (f) FK-7/FK-8-Anbindung (C5, Paragraf 6).
- F2 native Set-ABI-V2: append-only extract/merge/set-ops auf ISetTier/SetObserverSnapshotV1
  (E24-DOSSIER:156, LEDGER:1580) -- Commit C6, NIE als vtable-Anhang (Auflage 5: neues Sub-Interface +
  1x kalter dynamic_cast).
- KONFORMITAETS-ORAKEL (OP-2-ENTSCHEID, hiermit): **std::set<K>** -- direkte Ordnungs-Analogie zum
  SA-std::map-Gate (pruef_dock.hpp:78 V5-Vertrag); Kandidatenliste E24-DOSSIER:268/:297.
- Cross-Genus-Beitrag: `index_organization <- Set` als Sub-Organ via OrganConcept (E24-DOSSIER:160).

### 1.2 Detail-Schnitt SEQUENCE (9 Slots)

- Slot-Liste (genus_binding_traits.hpp:133-137): memory_layout, allocator, prefetch, concurrency,
  serialization, value_handle, io_dispatch, migration_policy, growth_policy. Pin :95 `== 9`.
- Liefergegenstaende (a)-(f) analog 1.1: SequenceObserverAggregate<9>, for_each_abi_adapter in
  sequence_permutation_engine.hpp, SequenceDock, SequenceExecutionContext, FK-Anbindung.
- KONFORMITAETS-ORAKEL (OP-2-ENTSCHEID): **std::deque<V>** -- indexed-V-Semantik mit Wachstum an beiden
  Enden deckt growth_policy/value_handle ehrlicher als std::vector (kein Realloc-Artefakt im Orakel).
- Cross-Genus-Beitrag: `node_type <- Sequence` (mit Adapter) als Sub-Organ.

### 1.3 Detail-Schnitt ADAPTER (11 Slots)

- Slot-Liste (genus_binding_traits.hpp:81-85): search_algo, cache_traversal, memory_layout, allocator,
  prefetch, concurrency, serialization, value_handle, io_dispatch, migration_policy, inner_container.
  Pin :93 `== 11`.
- Liefergegenstaende (a)-(f) analog: AdapterObserverAggregate<11>, AdapterDock, AdapterExecutionContext.
- OP-3-ENTSCHEID (hiermit): **NEUE eigene `anatomy/adapter_permutation_engine.hpp`** nach dem
  Geschwister-Muster (set_/sequence_/view_permutation_engine.hpp existieren als per-Genus-Engines,
  am Ist belegt; der generische anatomy_permutation_driver.hpp bleibt Treiber-Ebene). Begruendung: die
  Engine-pro-Genus-Struktur IST der gebaute Kanon; eine Sonderloesung fuer Adapter waere die stille
  Wiedereinfuehrung eines Ganz-Tier-Achsen-Konfigurators (Memory-Kanon: keine Ganz-Tier-Achsen).
  for_each_abi_adapter kommt in ALLE VIER Container-Engines (C2).
- KONFORMITAETS-ORAKEL (OP-2-ENTSCHEID): **ZWEI benannte Orakel** -- **std::stack<V>** (LIFO) und
  **std::queue<V>** (FIFO), gewaehlt per inner_container-Belegung der Permutation; ein einzelnes Orakel
  wuerde die Adapter-Richtungs-Semantik unpruefbar lassen. (conformance-Bestand nur ERWEITERN, nie
  aendern -- E24-DOSSIER:267 Auflage 7.)
- Cross-Genus-Beitrag: `queuing <- Adapter` und `node_type <- Adapter` (mit Sequence).

### 1.4 Detail-Schnitt VIEW (5 Slots)

- Slot-Liste (genus_binding_traits.hpp:158-161): memory_layout, value_handle, extent_policy,
  layout_policy, accessor_policy. Pin :95 `== 5`.
- Liefergegenstaende (a)-(f) analog: ViewObserverAggregate<5>, for_each_abi_adapter in
  view_permutation_engine.hpp, ViewDock, ViewExecutionContext.
- KONFORMITAETS-ORAKEL (OP-2-ENTSCHEID): **std::span<V>**-basierte Referenz-Sicht (non-owning; extent
  statisch/dynamisch deckt extent_policy) -- die einzige std-Klasse der Kandidatenliste mit ehrlicher
  View-Semantik.

### 1.5 SearchAlgorithm (Vervollstaendigungs-Anteil)

- SA ist der VERIFIZIERTE Spezialfall (genus_binding_traits.hpp:36-40); im Fenster: SA erfuellt
  OrganConcept (static_assert-Matrix G2), SA-Anatomie nimmt via OrganConcept generisch ein Genus-Organ
  als Sub-Organ auf (Cross-Genus, E24-DOSSIER:149/:160), _abi7-Freezes + Major-Umzug wie alle.
  Der 18-Slot-SA-Pfad (kCompositionAxisNames) ist TABU (E24-DOSSIER:168) -- SA bekommt KEINE neuen Slots.

### 1.6 S12.3 Ziel-Topologie -- BENANNTER FENSTER-ENTSCHEID (hiermit): OPTION A

- Option A = Genera bleiben, die GATTUNG wird ABI-Flaeche (comdare::container-Kopf-Framework ueber dem
  bestehenden type_traits-Re-Export, container_framework.hpp:60-80); Option B = Set/Sequence als Typen
  unter Container umbauen (E24-DOSSIER:154; container_framework.hpp:17-19; LEDGER:2858).
- ENTSCHEID: **OPTION A.** Begruendung am Objekt: (1) die TABU-Liste friert die Anatomie-Enum-Reihenfolge
  ein (E24-DOSSIER:168/:267 -- Option B muesste den AnatomyGenus-Raum umstrukturieren); (2) Q-8 haelt die
  Genera disjunkt (genus_binding_traits.hpp:36-40 -- Option B zoege eine Vereinheitlichungs-Debatte, die
  einen NEUEN Owner-Entscheid braeuchte); (3) die self-proving asserts (container_framework.hpp:85-95)
  und ALLE per-Genus-Engines/-Adapter/-Docks bauen auf dem Genus-Schnitt auf -- Option A liefert die
  Owner-geforderte Ebene-1-Promotion (Gattung ABI-sichtbar, LEDGER:1576-1581) OHNE die Wachen-Klassen zu
  brechen. Der MAJOR bleibt derselbe (die Promotion IST der Major, E24-DOSSIER:154). Meldung als
  NUR-KENNTNIS im V3b-Block (OP-8), kein Owner-Gate (GATE 4 = Manager-Entscheid, LEDGER:3731).

### 1.7 NICHT im Fenster (E24-DOSSIER:162-168)

Graph (nach Abgabe, Q5; Enumerator unangetastet) / Stempel-Semantik (A13-Territorium, KEIN zweiter
Stempel-Bruch) / Hybrid-Bau (Auswertungsphase; erbt Major automatisch; Hybrid-K1 bleibt E-24-NEUTRAL,
OP-11 + FAHRPLAN:54 L3: Lager reserviert KEIN Hybrid-Segment) / A8-S2/S6 (host-/doku-only, kanten-frei).

---

## Paragraf 2 -- Migrationsliste + TABU-Pruefung (Pflicht-Inhalt "Migrationsliste")

Zaehlungs-Doktrin (M3-Dossier:120): bindend sind die grep-Kommandos, nicht die Zahlen.

### 2.1 Migrationsliste des Major-Bumps (EDIT-Stellen -- bewusst klein)

1. decl:62 `COMDARE_ANATOMY_ABI_MAJOR 7 -> 8` (der Owner-MAJOR).
2. decl:66 Magic `0x434F4D444141372E -> 0x434F4D444141382E` (".A7." -> ".A8."; Historien-Kanon decl:39-59:
   jeder Major bewegte die Magic).
3. decl:327 `kCebContractCodegenMinor 1 -> 0` (RESET-ENTSCHEID, Paragraf 5.1) + Vollzugs-Absatz
   decl:297-326 fortschreiben (WARUM Major; Muster M4).
4. Pin-Test test_v41_anatomy_module_abi.cpp:60 (`major == 7` -> `== 8`) + :82 (`Minor == 1` -> `== 0`)
   + :91-92 EXPECT -- im SELBEN Commit (der Pin IST die Absichts-Wache).
5. `_abi7`-Freezes ADDITIV einfrieren (analog `_abi4/5/6`, decl:47/:53; G5-Pflicht E24-DOSSIER:287).
6. KEINE Edits noetig (Ableitungs-Beweis): die 5 Modul-Makro-Header leiten Version+Magic ab
   (anatomy_module_abi_v1.hpp:97-99, set_/sequence_/view_/adapter_module_abi_v1.hpp -- R3 verifiziert);
   Konsumenten-Tests leiten `+ceb=` aus der Konstante ab (test_s1_cache_key_prefix.cpp:33,
   test_s5_artifact_cache_bounded.cpp:92); test_g1_binary_version_stamp.cpp nutzt bewusst wertfreie
   Fixtures "+ceb=6.0" (Ordnungs-Test) -- bleibt. Suffix-Wachen test_r2_suffix_wachen.cpp:104-119
   (genau EIN +ceb=; Ordnung cxx<opt<ext<ceb) bleiben unveraendert gueltig.
7. Loader-Referenz-/Doku-Nachzuege + `+ceb=`-Erwartungs-Grep als Pflicht-Kommando im C8-Review:
   `grep -rn "+ceb=" libs/ tests/ apps/` -- jede Fundstelle klassifizieren (Konstante-abgeleitet /
   wertfreies Fixture / Doku), NICHTS blind editieren.
8. Kommentar-Driften mitziehen (Paragraf-75-tauglich, OP-9): container_framework.hpp:20-25 ("4->5" ->
   Historien-Vermerk "heute 7->8"), pruef_dock_registry.hpp:4-5 ("kommen mit V42" -> gebaut),
   observer_aggregate.hpp:2/:77-79 ("17" -> 18/kV3AxisCount), anatomy_base.hpp:72-77 (F1b "NICHT hier"
   -> vollzogen), decl:330 Zeilen-Drift "decl:124-127" -> Ist :276-279 (R3-Querbefund).

### 2.2 TABU-Pruefung (je 0-Treffer-Beleg im C11-Abschluss-Review literal zu fuehren)

TABU-Flaechen (E24-DOSSIER:168/:267): kCompositionAxisNames/18-Slot-SA-Pfad / persistence_target-
Disjunktheit Q-8 (genus_binding_traits.hpp:36-40) / golden_fullpilot_320-Byte-Wache / permutation_axes.xml
/ m3v2_study.profile.xml / CRC64-Anker 0x56F1B721C72DC10E / Anatomie-Enum-Reihenfolge (kein Append/
Reorder; Graph bleibt =2). Pflicht-Kommando je Commit: TABU-Pfade NICHT im `git diff --stat` (Freeze-
Doktrin, diff-stat literal). GenusBindingTraits DARF im Fenster beruehrt werden, aber NUR fuer die hier
gelisteten Aenderungen (E24-DOSSIER:168 letzte Klausel) -- persistence_target-Zeilen bleiben byte-gleich.

---

## Paragraf 3 -- COMMIT-ZUG C0..C11 + ZEITSCHAETZUNG (Pflicht-Inhalte 2 + 8)

Muster M3-Dossier Paragraf 3: Vorlauf ohne Commit; Teil "a" = ABI-/byte-neutrale Commits einzeln gruen
(parallelisierbar auf disjunkten Datei-Schnitten, Landung SERIELL durch EINEN Merge-Schreiber, Arbeits-
teilung v2.1/Auflage 12); Teil "b" = die ABI-Ereignis-Serie strikt seriell in EINEM Worktree.

### 3.0 VORLAUF V (kein Commit; ~0,5 h)

- rescue-Refs `refs/rescue/pre-e24-<basis-sha>` auf BEIDE Remotes; frischer Worktree wt-e24;
  2-Phasen-Configure-Kanon (LEDGER:3631: configure -> comdare_limits_generated_source_catalog ->
  ninja all -> configure 2. Pass -> ninja all -> 3 EXCLUDE_FROM_ALL-Ziele inkl.
  comdare_system_axis_registry_gen -> ctest).
- Basis-ctest-N LIVE erheben (lebendes Gate; KEINE feste Zahl aus diesem Dossier -- Ist der Linie 332).
- A8-DISPOSITIONS-CHECK LITERAL (Auflage 17/OP-14, E24-DOSSIER:277/:309): Ist 04.08. = KEINE A8-Scheibe
  gelandet (drei <17-Schleifen am HEAD vorhanden, Paragraf 1.0). Zuweisungs-Ergebnis s. 3.3.
- ENFORCE-Preflight (`COMDARE_VERSION_HW_FLAG_ENFORCE` Default 1, algo_semver.hpp:172-173) + TABU-grep.
- W10-STARTBEDINGUNG NOTIEREN: Teil "a" (C0-C5) darf VOR/PARALLEL zu W10 laufen (disjunkte Flaechen);
  Teil "b" (C6-C11) startet ERST NACH W10-Landung (Paragraf 5.3).

### 3.1 Teil "a" -- ABI-neutral, einzeln gruen, parallelisierbar (nach C0 bis zu 5 disjunkte Worker)

- **C0 -- M0-Vorstufe (SOFORT, auch vor W10; ~2 h):** NEUER Header `anatomy/organ_concept.hpp` mit NUR
  beweisbaren static_asserts (SA erfuellt OrganConcept; die 4 ContainerType-Genera erfuellen die
  statistics/value_type-Teilmenge); Luecken der 4 duennen Genera als Kommentar-/Dossier-Abschnitt, NICHT
  als brechender Assert (E24-DOSSIER:170-172). Gate G1: ctest-N Namens-Diff leer bzw. exakt die neue
  Test-TU, golden-320 gruen, Registry-sha identisch, 0 Byte-Ereignis ausserhalb neuer Header/Tests.
- **C1 -- OrganConcept-Vollausbau (~3 h):** gemeinsame Op-Schnittstelle + ObservableAxis-/statistics-
  Forwarding (Memory-Kanon: Observable-Wrapper MUSS Concept-Member forwarden), CRTP+Concept, CT-statisch/
  zero-cost/dispatch-frei (E24-DOSSIER:149); Negativ-Probe als Compile-Fehler-Fixture. Gate G2.
- **C2 -- Permutation-Engines (~3 h):** `for_each_abi_adapter` in set_/sequence_/view_permutation_engine
  nach dem SA-Muster (search_algorithm_permutation_engine.hpp:174-185) + NEUE
  adapter_permutation_engine.hpp (OP-3-Entscheid 1.3); je Engine eine Test-TU (Auflage 13: neue TUs
  REGISTRIEREN, Waisen-TU-Lehre).
- **C3 -- Produktionstiefe der 4 Genus-Anatomien (~6 h; groesste a-Flaeche, je Genus ein Worker moeglich):**
  reale Organ-Member + observe-Verdrahtung (Haupt=Struktur gehalten, Unter=Verhalten delegiert,
  LEDGER:2771) + `XxxExecutionContext` je Genus. KEINE Beruehrung von abi_adapter.hpp/Wire-PODs
  (die sind Teil "b").
- **C4 -- Docks in-process produktionsreif (~5 h):** SetDock/SequenceDock/AdapterDock/ViewDock als
  IPruefDock-Impls (V5-Vertrag pruef_dock.hpp:74-79: import -> GATE -> messen); Konformitaets-Orakel je
  Genus (Entscheide 1.1-1.4); Registry-Ausweitung nach Muster f15_compare/main.cpp:220; stale
  V42-Kommentar pruef_dock_registry.hpp:4-5 nachziehen. Neue Dock-Versionen in Q3-Grammatik vX.Y.Zc
  (ENFORCE=1 bricht sonst compile-hart).
- **C5 -- FK-7/FK-8-Anbindung host-seitig (~2,5 h):** Paragraf 6; Enum-Erweiterungen ADDITIV am Ende +
  Count-Wachen im SELBEN Commit (FK-c, E24-DOSSIER:210).

### 3.2 Teil "b" -- die ABI-Ereignis-Serie (seriell, EIN Worktree, W10 gelandet)

- **C6 -- Wire-/Sub-Interface-Ereignis (~4 h):** `XxxObserverAggregate<N>` per-Achse statt flacher
  Hand-PODs (Wire-PODs append-only bzw. V2 NUR HIER); neue Sub-Interfaces NIE als vtable-Anhang (neues
  Sub-Interface + 1x kalter dynamic_cast, Auflage 5; Vererbungsreihenfolge eingefroren); F2 native
  Set-ABI-V2 append-only extract/merge/set-ops (E24-DOSSIER:156). VOR C8: ein Major-7-Referenzmodul
  bauen und als Fixture AUFHEBEN (G5-Beweismittel).
- **C7 -- S12.3 Option-A-Promotion + Kopf-Framework (~3 h):** Ebene-1-Gattung ABI-sichtbar,
  comdare::container-Kopf-Framework (Entscheid 1.6); container_framework-Asserts fortschreiben.
- **C8 -- DER MAJOR (~2 h):** Migrationsliste 2.1 Punkte 1-5 in EINEM Commit (Major 8 + Magic .A8. +
  Minor-Reset 0 + Pin-Neufassung + Vollzugs-Absatz + _abi7-Freezes). Wirkung = Paragraf 5.1.
- **C9 -- FK-5-Vollzug (~3 h; binary-beruehrend, ABI-frei; GETRENNTER Commit "Fehlerraum" vs.
  "Versionsraum", Praezedenz A15-DESIGN OF-2):** `error_classes()`-Pflicht an den je-Achse-CRTP-Basen
  (19 Stellen, K2-Muster axis_io_strategy_base.hpp:15-21; NICHT an den StaticAxisVariants_*-Aliasen,
  NICHT 129 Einzeldateien) + Deklarationen je Varianten-Typ. BEGRUENDUNG DES SLOTS (Bauplan-Zuweisung,
  schliesst die R4-Luecke): die Zusage "FK-5 faehrt im M3-Fenster mit" (LEDGER:3689/:3693) ist VERFALLEN
  -- die M3-Kette C1-C6 (LEDGER:3744) enthaelt kein FK-5, am Ist 0 Code-/Log-Treffer (eigener grep 04.08.);
  FK-5 fasst dieselben in Tier-Binaries einkompilierten axes/-Basen an -> binary-beruehrend -> MUSS
  analog K-a VOR dem EINEN Anker-Vollzug liegen, sonst zweites Neuanker-Ereignis. Lead-Ratifikation mit
  dem Fenster-GO (Paragraf 9).
- **C10 -- Roundtrip- und Bilanz-Beweise (~3 h):** je Genus DLL-Roundtrip (bauen -> laden 7-Schritt ->
  messen -> CSV); wrong_genus-/Konformitaets-Negativ-Proben (dock_status 2/4); select_for ueber alle 5
  Gattungen + measure_genus_sequential-Mischlauf; G5: Major-7-Altmodul (C6-Fixture) wird ABGELEHNT
  (Loader-Fehler literal), Major-8-Roundtrip gruen, Magic-Wechsel belegt, --version-Beleg; G6-Teil:
  +ceb=-Diff literal, Stempel-Preimage-UNVERAENDERT-Beweis (OverlayHash identisch fuer Referenz-SA-Binary),
  CRC64 unveraendert.
- **C11 -- G8-Fenster-Abschluss (~1,5 h):** Negativ-Liste "ABI-/Fingerprint-beruehrende Flaechen -- bis
  nach Abgabe gesperrt" (Enums, PODs, Modul-Makros, Loader-Vertrag, Dock-Vertrag, abi_adapter.hpp,
  axes/-Header) + explizite Ausnahme-Klasse A8-S2/S6 + Commit-Hash-Nachweis aller binary-beruehrenden
  A8-Scheiben (K-d/K-a; sind S3/S4/S5 zu diesem Zeitpunkt noch offen, stehen sie EXPLIZIT als
  vor-Anker-Pflicht drin -- sonst FEHLER) + Ledger-Zeile "E-24 vollzogen" (OP-10-Vollzug) + Kommentar-
  Nachzuege 2.1 Punkt 8 + Doku (OP-13: Thesis-Nachzug PL-19/PL-21 nur MELDEN, nicht selbst texten).

### 3.3 A8-Einsortierung relativ zum Zug (K-a..K-e, E24-DOSSIER:196-201; Disposition am Ist)

- **A8-S1 (T17-Fix) SOFORT und VOR dem Fenster-b-Teil**, eigener Worker/eigene Scheibe mit A8-Grund-
  kadenz -- NICHT Teil dieses Commit-Zugs; Startklar-Punkt in Paragraf 8. PFLICHT-REIHENFOLGE: Laufzeit-
  Beleg LITERAL VOR dem Fix (CSV-Spalte seg persistence_target == 0 bei aktiver Messung; A8-DOSSIER:414-415,
  FAHRPLAN:59). Ist 04.08.: NICHT gelandet (Paragraf 1.0).
- **A8-S3/S4/S5 NACH der Fenster-Landung, VOR dem Anker-Vollzug** (C'-Kette E24-DOSSIER:232). S3
  serialisiert hinter dem Fenster (beide fassen abi_adapter.hpp an -- Ein-Schreiber-Regel); S5
  familienweise parallel (<=8 Bau-Worker, 5 Organ-Gruppen-Scheiben, Datei-Liste IMMER aus grep -- Ist 70
  von 340); S4 parallel. Sub-Interface-/POD-Bedarf aus S3/S4: NUR vor/im Fenster -- entsteht er SPAETER,
  gilt STOPP + Manager (K-b; nach C11 greift G8 ausnahmslos).
- **A8-S2/S6 kanten-frei** (host-/doku-only), duerfen nach dem Anker laufen; bleiben trigger-blockierend
  als A8-Kern (A8-DOSSIER:346-349).
- **DANN EIN ANKER-VOLLZUG:** TP1-Proben-Neu-Inventarisierung ueber den 2d-gehaerteten Bestandslog-Pfad
  + A2-SHA512-Eichung (GATE 5) -- GENAU EINMAL (E24-DOSSIER:185/:232). Zwischen E-24-Landung und Anker:
  KEIN Trigger, KEIN Lager-Voll-Einlagerungslauf, keine schweren Parallel-Jobs (E24-DOSSIER:233).

### 3.4 ZEITSCHAETZUNG (OP-7-Liefergegenstand; ehrlich, mit Parallelisierungs-Annahme)

| Posten | seriell | Anmerkung |
|---|---|---|
| V Vorlauf | 0,5 h | rescue/Worktree/Basis-N/A8-Dispo |
| C0 M0 | 2 h | sofort, parallel zu W10 |
| C1-C5 (a-Teil) | 19,5 h | parallelisierbar auf bis zu 5 Worker; kritischer Pfad C3 = 6 h |
| C6-C11 (b-Teil) | 16,5 h | strikt seriell, nach W10 |
| Reviews/Kadenz je Commit | 8-10 h | Doppellauf + Dual-Review (Codex, Fallback Fable-Adversarial MIT Ledger-Vermerk, Auflage 11) |
| **SUMME seriell** | **~47 h** | |
| **Kritischer Pfad parallelisiert** | **~31-33,5 h** | V+C0 (2,5) + a-Teil-Pfad (6) + b-Teil (16,5) + Review-Pfad (6-8) = arithmetische Summe; jede niedrigere Zahl braucht eine BENANNTE Ueberlappungs-Annahme (Review-B5) |

Danach (NICHT Teil des Fensters, aber des Slots): A8-S3/S4/S5 ~10-16 h (S5 familienweise parallel;
die verbindliche je-Familie-Schaetzung bleibt A8-Pflicht VOR Trigger-Terminierung, A8-DOSSIER:420-421)
+ Anker-Vollzug (TP1-Inventur + A2-Eichung) ~3-5 h.

**BAU-SLOT (Kalender):** C0 SOFORT (04.08. vormittag, parallel zu A1-Lager-Rest/W10) / a-Teil Mo 04.08.
/ b-Teil ab W10-Landung (Ziel Mo abend/Di frueh) -> E-24-LANDUNG Di 05.08. spaet bis Mi 06.08. frueh /
A8-S3/S4/S5 Mi 06.08. / ANKER-VOLLZUG Mi 06.08. spaet. **Do 07.08. (Trigger) haelt NUR mit dieser
aggressiven Parallelisierung (Owner-8er-Freigabe 03.08.); Reserve Fr 08.08. ist einzuplanen und wird
hiermit DEKLARIERT (E24-DOSSIER:302/:338). Scope-Reduktion ist per Owner-R9 KEINE Option.**

**PHASE-4-VERDRAENGUNG (Review-B5, hiermit BENANNT statt still):** Rutscht die E-24-Landung auf Mi 06.08.
frueh, verdraengen A8-S3/S4/S5 (Mi) + Anker-Vollzug (Mi spaet) die FAHRPLAN-Phase-4-Posten (Beweise 1-5 +
12-Perm, FAHRPLAN:25-27) aus dem Mi-Fenster -- verschaerft durch die Job-Sperre (keine schweren Parallel-Jobs
zwischen E-24-Landung und Anker, 3.3/8.9) und L10 (B5.b bindet an die EINGEFRORENE Linie NACH E-24 +
Pflicht-Re-Run <1h). Folge: Phase 4 rueckt auf Do 07.08. vormittag VOR die Trigger-Sequenz (beide teilen
den Do), oder die deklarierte Fr-Reserve greift. Diese Kompression ist Teil der Trigger-Terminierung und
wird beim Fenster-GO gegen den Ist-Fortschritt neu gerechnet.

---

## Paragraf 4 -- ORAKEL-DEFINITIONEN JE COMMIT + Wachen-Plan (Pflicht-Inhalte 3 + 9)

Vier Orakel-Klassen nach M3-Muster (M3-Dossier:181-190). Kein Haken ohne literale Ausgabe.

### 4.1 Klasse I -- SOLLEN hart brechen (Bruch literal fuehren, dann revertieren)

| Commit | Probe |
|---|---|
| C1 | Nicht-Organ-Typ am OrganConcept = Compile-Fehler-Fixture (G2-Negativ-Probe, Text literal sichern) |
| C4 | Dock-Version OHNE HW-Flag ("v1.0.0") = compile-hart an ENFORCE-Wache (axis_variant_version_table.hpp:95-109 bzw. ce_owned_version_satisfies_cpu_enforce) |
| C8 | Pin-Test v41:60/:82 bricht bei Major/Minor-Drehung OHNE Pin-Neufassung (VOR dem Pin-Edit einmal literal zeigen) |
| C9 | Achsen-Basis OHNE error_classes() = compile-hart (FK-5-Concept-Wache; Mutations-Gegenprobe wie L6-PRODUCER-Muster LEDGER:3658) |
| C10 | Major-7-Altmodul: Loader lehnt ab, Fehlertext literal (G5); wrong_genus-Modul an fremdem Dock: dock_status==2 literal; kaputtes Modul am Orakel: dock_status==4 literal |

### 4.2 Klasse II -- NEUE Gleichheits-/Struktur-Wachen (im jeweiligen Commit)

| Commit | Wache |
|---|---|
| C0/C1 | static_assert-Matrix 5 Genera x Concept-Teilmengen; Forwarding-Beweis (Wrapper forwardet statistics/value_type) |
| C2 | je Engine: for_each_abi_adapter-Materialisierungs-Zaehlung == Slot-Permutations-Soll des Genus |
| C3 | je Genus: Organ-Member-Praesenz-Asserts gegen axis_names()-Liste (Slot-Zahl 13/9/11/5 gepinnt, container_framework.hpp:93-96 bleibt gruen) |
| C5 | FK-Count-Wachen (kCompilerCompilerErrorClassCount u. a.) im SELBEN Commit wie die Enum-Erweiterung; Token-Disjunktheits-Wache (axis_error.hpp:184-194-Muster) |
| C6 | Wire-POD-V2: sizeof-/Layout-Pins + append-only-Beweis (alte Felder byte-identisch an alter Position) |
| C7 | Kopf-Framework: type_count==4-Assert bleibt; Gattungs-Sichtbarkeits-Assert neu |
| C8 | kCebContractVersion.major == COMDARE_ANATOMY_ABI_MAJOR (besteht, v41:93) + neuer Minor-Pin == 0 |
| C11 | G8-Negativ-Listen-Datei + scheduling-Abgangs-Wache in abi/system_axis_order.hpp unveraendert (E24-DOSSIER:130/:290) |

### 4.3 Klasse III -- NEUE Proben aus Befunden

- test_reflect_versions_all_registered.cpp MUSS die neuen Genus-/Dock-Eintraege mitpruefen (Flag-
  Grammatik-Naht, E24-DOSSIER:125/:266 Auflage 6; Q3 vX.Y.Z+c, Kurzform verboten, gerendert praefixfrei
  @X.Y.Zc per Q10).
- test_genus_binding.cpp + test_abi_adapter_g3_batch2.cpp FORTSCHREIBEN statt umgehen (Auflage 13,
  E24-DOSSIER:273); Lehre "gruene Tests zementieren alte Ordnung": je Increment ein fixture-unabhaengiger
  Ableitungsweg-Test.
- G3-FK-Beweis: je Fehlerpfad stabiles Etikett im Log UND "failed"-CSV-Zelle literal, NIE stille 0/null
  (E24-DOSSIER:285; D2-Doktrin).
- G4: Kompositions-Unit-Tests node_type<-Sequence/Adapter, index_organization<-Set, queuing<-Adapter
  (Observer-Werte real getrieben) + JOIN-Unmoeglichkeits-Asserts bestehen UNVERAENDERT (set_abi_adapter.hpp:18-21).

### 4.4 Klasse IV -- MUESSEN gruen bleiben / TABU-Belege (JEDER Commit)

golden-320-Byte-Wache / CRC64-Anker 0x56F1B721C72DC10E unveraendert / Registry-Roundtrips byte-identisch
(system_axis_registry.xml sha) / test_limits-CRC-Anker / TABU-Pfade nicht im diff-stat / V5-Konformitaets-
Gate-VERTRAG und IPruefDock::measure-Signatur UNVERAENDERT (HY-D2-Freeze, E24-DOSSIER:269) /
destroy-vor-dlclose-Ordnung (loader:70-75) / Q-8-persistence_target-Zeilen byte-gleich.

### 4.5 DOPPELLAUF-KADENZ je Commit (Pflicht-Inhalt 9; M3-Dossier:171)

Voll-Bau 2-Phasen-Configure -> 2x ctest mit N beziffert (Basis-Zahl NACH Vorwelle LIVE erhoben; Namens-
Diff je Commit ERKLAERT) -> golden-320 gruen -> Registry-Roundtrip byte-identisch -> cf22 leer -> ASCII-
Selbstcheck AUS DEM DIFF (nie handgepflegt) -> gitleaks 0 -> TABU-Diff 0 -> Working-Tree-Freeze +
diff-stat literal. Landung: super-Sub-Build gruen, CI beide Hosts hart gruen (Pipelines-API nur mit
VOLL-SHA abfragen; /jobs zeigt keine Bridges -- Memory-Fallen), main-FF mit GEPINNTEM Voll-SHA auf BEIDE
Remotes, ce-Gitlink-Bump. Dual-Review je Scheibe: primaer Codex-Zweitreview, Fallback Fable-xhigh-
Adversarial MIT ausdruecklichem Ledger-Vermerk (Auflage 11; Praezedenz LEDGER:3683-3689).

### 4.6 ENFORCE-CHECKLISTE (scharf seit M3/C4, LEDGER:3744)

JEDE neue ce-eigene Version des Fensters (Dock-Versionen, Genus-Listen-Eintraege, axis_code_version,
etwaige probe_ids) traegt vX.Y.Z + HW-Flag c (CPU-only-Flotte: alles endet "c"; "e" NUR Pruefling und
fuer ce-Registry-Varianten compile-verboten, LEDGER:3611). Pflicht-Durchlaufpunkte:
system_axis_code_versions.hpp:120-124 + axis_variant_version_table.hpp:95-109. A8-Worker fassen KEINE
Versions-Literale an (A8-Auflage 4).

---

## Paragraf 5 -- Identitaets-Folge, Store-Key/Bucket, W10-Naht, L14 (Pflicht-Inhalte 5 + 6 + 7)

### 5.1 Store-Key-/Bucket-Folge des Major-Bumps -- ENTSCHEID: `+ceb=8.0` (Minor-Reset im C8-Commit)

- MECHANIK (am Ist): cache_key_prefix haengt "+ceb=" + MAJOR + "." + kCebContractCodegenMinor an
  (artifact_cache.hpp:284-288; CACHE-scoped, bewusst NICHT in kSuffixSegmentOrder :279-283). Ein Major-
  Bump allein ergaebe automatisch "+ceb=8.1", denn es existiert KEIN Reset-Mechanismus (R3-Befund, am
  Ist bestaetigt: decl:327 ist handgepflegt).
- ENTSCHEID (Bauplan-Ebene, im C8-Commit): **kCebContractCodegenMinor 1 -> 0** => zweiter Shift
  **7.1 -> 8.0**. BEGRUENDUNG: der codegen-Minor zaehlt Vertrags-Erweiterungen INNERHALB eines Majors
  (Vollzugs-Absatz decl:297-326 begruendet die 1 ausschliesslich mit dem A13-Fenster unter Major 7);
  ein "8.1" ohne je existierende 8.0-Basis waere eine Versions-Luege. Der literale Pin (v41:82) bricht
  bei der Drehung und erzwingt die Absicht im SELBEN Commit -- genau dafuer wurde er gebaut. ABWEICHUNGS-
  VERMERK: E24-DOSSIER:182/:230 rechnet "7.1 -> 8.1" -- das ist die Fortschreibung OHNE Reset-Entscheid;
  dieser Bauplan ist der designierte Ort des Entscheids (R3-Luecke). Meldung im V3b-NUR-KENNTNIS-Block.
- WIRKUNG (deklariert, analog M4 LEDGER:3754): jede build_version aendert sich ("+ceb=7.1" -> "+ceb=8.0",
  Naht profile_run_facade.cpp:397-399 + system_version_suffix.hpp:39/:47) -> jede perm.dll.version
  mismatcht in dll_is_current (build_orchestrator.hpp:251/:492) -> Neubau kuenftiger Binaries +
  cache_key_prefix zeigt auf NEUEN Objekt-Store-Key-Namensraum = **deklarierte EINMALIGE Bucket-
  Invalidierung vor Voll-Bau-4**. Akzeptiert: vor Voll-Bau-4 existiert kein schuetzenswerter Voll-Bestand
  (E24-DOSSIER:223/:240); nur TP1-Proben betroffen, deren Inventur laeuft ohnehin am Fenster-Ende.
- GOLDEN-BILANZ (SAUBER AUSWEISEN, nicht behaupten -- E24-DOSSIER:184): binary_id (18-Organ-Pfad),
  CRC64-Anker und golden-320-Wache UNVERAENDERT; Neuanker NUR _abi7-Freezes, Loader-Referenzen,
  +ceb=-Erwartungen, TP1-Inventur. Loader-Backstop decl:276-279 haelt Bau-Skip + Lade-Akzeptanz
  konsistent (decl:329-331).

### 5.2 G6-Identitaets-Bilanz (Beweisliste, C10/C11)

+ceb=-Diff literal (beide Shifts der C'-Kette dokumentiert: 7.0->7.1 [M4, gelandet] und 7.1->8.0 [C8]) /
Stempel-Preimage-UNVERAENDERT-Beweis (OverlayHash identisch fuer ein Referenz-SA-Binary ohne Code-
Aenderung) / CRC64 unveraendert / TP1-Inventur EINMAL nach Fenster + A8-binary-Scheiben /
A2-Eichung erst danach (GATE 5). (E24-DOSSIER:288.)

### 5.3 W10-Naht (Pflicht-Inhalt 6): W10 kommt VOR dem b-Teil

- WAS W10 UEBERGIBT: System-ZELLWERTE in die system_stamp_line -- beendet den Uebergangszustand
  "Skip nur innerhalb gleicher OS-Familie"; deklariertes Byte-Ereignis auf der STEMPEL-Ebene
  (FAHRPLAN:14; 00-SYNTHESE:52 F7-Auflage). W10-Bauplan = eigene Session wf_600bc26d (laeuft).
- DREI harte Kopplungen (M3-Dossier:175 + E24-DOSSIER:165/:288): (1) E-24 fuehrt KEINEN zweiten
  Stempel-Bruch ein und LIEST die A13/W10-Stempel-Welt nur -- der G6-Preimage-UNVERAENDERT-Beweis muss
  gegen die NACH-W10-Welt ankern, sonst beweist er das Falsche => **b-Teil (C6-C11) startet erst nach
  W10-Landung**; a-Teil (C0-C5) ist stempel-frei und darf parallel laufen. (2) TP1-Inventur ist FINAL
  erst nach dem LETZTEN Shift vor A2 (W10/E-24) -- einmal am Anker-Vollzug, nicht doppelt (R15).
  (3) A2-Eichung erst nach W10+E-24, sonst doppelte Eichung.

### 5.4 L14-Deklaration (Pflicht-Inhalt 7)

Die A2-SHA512-Eichung laeuft EINMALIG ZULETZT nach W10+E-24+A8-binary-Scheiben (GATE 5) und wird MIT
LEEREM Overlay-Glied geeicht (5./6. Preimage-Glied traegt nur Separator+Format; Naht seit M3/C3 layout-
bruch-frei vorbereitet, LEDGER:3744/:3748). ABNAHME-3/4-Voll-Soll erfuellt sich erst mit dem Overlay-
Fenster (Phase 6) = **deklarierte, nicht stille Luecke** (FAHRPLAN:58, L14). Die 3 Overlay-Owner-
Festlegungen existieren NIRGENDS (echtes NICHT-GEFUNDEN, LEDGER:3731) -- nicht-blockierend.

---

## Paragraf 6 -- FK-ID-VERGABE (Pflicht-Inhalt 4; gegen den GELANDETEN Stand, kein Parallel-Erfinden)

### 6.1 Gelandeter/definierter FK-Stand (live erhoben 04.08.)

| ID | Inhalt | Status |
|---|---|---|
| FK-0 | Hygiene+Wahrheit (RF-3-Guard-Registrierung) | VOLLZOGEN (ce 14f63636+62f0e32c, LEDGER:3615) |
| FK-1 | nicht_gebaut-Marker D1/D2-Naehte | VOLLZOGEN (Welle 2a) |
| FK-2 | SampleStatus fail-safe | VOLLZOGEN (Welle 2a) |
| FK-3 | AxisErrorTraits System/Mess/Meta-Meta | OFFEN (Phase 3, FAHRPLAN:22; measurement/ traegt am Ist NUR axis_error.hpp -- kein axis_error_traits.hpp, eigener ls 04.08.) |
| FK-4 | ORG-18 Organ-Achsen-Ebene | OFFEN (Phase 3) |
| FK-5 | Algorithmen-Ebene, error_classes() an CRTP-Basen (19 Stellen) | **NICHT VOLLZOGEN** trotz Plan-Zusage "im M3-Fenster" (LEDGER:3689/:3693) -- 0 Code-/git-log-Treffer (eigener grep 04.08.); Slot hiermit = **C9 dieses Fensters** (3.2) |
| FK-6 | Schnittstellen-Vermerke (kein Bau) | DEFINIERT im A15-DESIGN (A15-fehlerklassen.md:35: "[S] FK-6 Schnittstellen-Vermerke (kein Bau)") |

**KORREKTUR gegen R4:** die Behauptung "naechste freie numerische FK-ID = FK-6 (0 Treffer)" ist am
Objekt WIDERLEGT -- FK-6 ist im A15-Design belegt (grep 04.08.: A15-fehlerklassen.md:35 + Welle-2a-
Backups referenzieren "Schnittstelle FK-6(3)"). Vergabe-Regel eingehalten: IDs am gelandeten/
definierten Ist vergeben, NIE aus einem Bericht abschreiben (M3-Dossier:89 + R13-Praezedenz).

### 6.2 NEU vergeben fuer das E-24-Fenster (E24-DOSSIER:203-212, Auflage 16)

- **FK-7 -- Dock-Fehlerpfad-Klassifizierung (D2-Seite; deckt FK-a):** die rohen dock_status_*-Ints
  (pruef_dock.hpp:36-48) bleiben ABI-nahe TRANSPORTFORM (kein V5-Freeze-Bruch); die KLASSIFIZIERUNG
  geschieht CEB-seitig: wrong_genus/subinterface_missing/conformance_failed/Lade-Fehler -> D2-Abbildung,
  CSV-Zelle "failed" + klassifiziertes Log mit stabilem Etikett, NIE stille 0/null. Traeger: additive
  Erweiterung der bestehenden axis_error.hpp-Familie + Mapping-Helfer am Dock-Aufrufer. Commit C5;
  Beweis G3-FK (4.3).
- **FK-8 -- Genus-Baupfad-D1-Meldung (deckt FK-b):** neue Container-Genus-Baupfade melden in D1
  (CompilerCompilerErrorClass/BuildCellStatus); Enum-Erweiterungen ADDITIV am ENDE + Count-Wachen im
  SELBEN Commit (FK-c). Commit C5.
- FK-d (G3 um FK-Beweis erweitert) ist KEINE eigene ID, sondern Gate-Erweiterung (4.3).
- Owner-Autoritaet: E6 "Fehlerklassen bitte jetzt mit bauen" + Direktive 17.07. "fuer alle Achsen ->
  Unterachsen -> Algorithmen Pflicht" (axis_error.hpp:2-14; E24-DOSSIER:205).

---

## Paragraf 7 -- Risiken + Rollback

- **R1 (SCHWER) -- Anker-Doppelung:** landet irgendeine binary-beruehrende Flaeche (A8-S3/S4/S5, FK-5,
  Fenster-Nachzuegler) NACH dem Anker-Vollzug, ist die Ein-Anker-Bilanz falsch (zweites Neuanker-
  Ereignis; nach Voll-Bau-4 = Neubau ~1,57 Mio Binaries, Owner-E3-Verstoss). GEGENMASSNAHME: G8-Nachweis
  mit Commit-Hashes literal (C11) + Anker-Vollzug erst nach explizitem Manager-Check der K-a-Liste.
- **R2 -- abi_adapter.hpp-Schreib-Kollision:** A8-S1/S3 und Fenster-b-Teil fassen dieselbe Datei an.
  GEGENMASSNAHME: strikte Serialisierung S1 -> Fenster -> S3 (3.3); Working-Tree-Freeze-Doktrin;
  je Scheibe eigener Worktree, Landung seriell.
- **R3 -- W10-Vorgriff:** startet C6-C11 vor W10-Landung, ankert G6 gegen die falsche Stempel-Welt.
  GEGENMASSNAHME: harte Startbedingung 5.3 in der Startklar-Checkliste.
- **R4 -- Wire-POD-Fehler:** ein nicht-append-only-Feld in den ObserverAggregate-V2-Layouts bricht
  Alt-Leser still. GEGENMASSNAHME: sizeof-/Offset-Pins + append-only-Beweis je POD (4.2/C6); Vererbungs-
  reihenfolge eingefroren (Auflage 5).
- **R5 -- ENFORCE-Bruch spaet entdeckt:** neue Versionen ohne c-Flag brechen erst im Voll-Bau.
  GEGENMASSNAHME: ENFORCE-Preflight in V + Klasse-I-Probe in C4.
- **R6 -- Testzahl-Drift:** feste N aus Dossiers sind LUEGEN-anfaellig (Praezedenz 322-vs-326).
  GEGENMASSNAHME: N ist lebendes Gate, je Commit LIVE erheben + Namens-Diff erklaeren (4.5).
- **R7 -- Orakel-Zementierung:** die neuen Genus-Orakel duerfen den conformance-Bestand nur ERWEITERN
  (Auflage 7); ein "angepasstes" SA-Gate waere ein stiller Vertragsbruch. GEGENMASSNAHME: Klasse-IV-
  Belege je Commit.
- **R8 -- Zeit:** b-Teil unter Zeitdruck verleitet zum stillen Split (Verschieben von Cross-Genus/F2 =
  VERBOTEN, Auflage 2). GEGENMASSNAHME: Verschiebe-Wunsch ist IMMER Owner-Entscheid; Reserve Fr 08.08.
  ist deklariert (3.4).
- **ROLLBACK:** je Commit einzeln revertierbar (granulare Serie); rescue-Refs pre-e24 auf beiden
  Remotes; der Major-Commit C8 ist der Point-of-no-return der Lager-Key-Ebene -- bis C8 ist alles
  golden-/ABI-neutral rueckbaubar, nach C8 gilt: Rueckbau = erneuter +ceb=-Shift (billig VOR Voll-Bau-4,
  aber als Ereignis zu deklarieren).

---

## Paragraf 8 -- STARTKLAR-CHECKLISTE (vor C6/b-Teil; C0 ist sofort frei)

1. [ ] A1-Lager-Rest gelandet (LEDGER:3764-Reihenfolge; F3-Testschuld war Vorbedingung).
2. [ ] W10 GELANDET: Pipeline hart gruen + main-FF gepinnt (5.3; a-Teil davon unabhaengig).
3. [ ] A8-S1 GELANDET vor b-Teil-Start (strikte Serialisierung S1 -> Fenster-b -> S3; S1 und b-Teil fassen
   beide abi_adapter.hpp an -- Ein-Schreiber-Regel), mit Laufzeit-Beleg-VOR-Fix literal (3.3; L6; K-a/G8
   verlangen die S1-Landung mit Commit-Hash-Nachweis VOR dem Anker, C11 prueft das hart).
4. [ ] A8-Dispositions-Check aktualisiert (welche von S3/S4/S5 evtl. schon parallel liefen) -- Ergebnis
       in den C11-G8-Nachweis uebernehmen (K-d).
5. [ ] Basis-ctest-N live erhoben + notiert; 2-Phasen-Configure-Kanon im Worktree verifiziert.
6. [ ] rescue-Refs auf BEIDEN Remotes; EIN Merge-Schreiber benannt; Worker-Matrix v2.1 zugewiesen
       (Bauplan/Review=Fable xhigh; Geruest=Opus 5; schwere Logik=Codex mit dokumentiertem Fallback;
       Doku=Opus 4.8 -- Auflage 12).
7. [ ] Major-7-Referenz-DLL als G5-Fixture gebaut und beiseitegelegt (VOR C8).
8. [ ] V3b-NUR-KENNTNIS-Block an den Owner vorbereitet (Inhalt: Q5-Graph-Quittung, Major-Vollzug,
       Option-A-Entscheid, +ceb=8.0-Reset, A8-Slot je Scheibe [K-e], FK-5-Slot-Zuweisung, OF-A8-2-
       Deckung) -- Versand im naechsten Owner-Block, kein Gate (LEDGER:3731/:3718).
9. [ ] Zwischen Fenster-Landung und Anker-Vollzug: Job-Sperre kommuniziert (kein Trigger, kein
       Lager-Voll-Lauf, keine schweren Parallel-Jobs -- E24-DOSSIER:233).

---

## Paragraf 9 -- OFFENE ENTSCHEIDE (Pflicht-Inhalt 10; NUR echtes NICHT-GEFUNDEN) + OP-Abgleich

**Echte NICHT-GEFUNDEN-Punkte (in keiner Bestands-Quelle entschieden/belegt):**
1. Die 3 Overlay-Owner-Festlegungen (Verzeichnis-Schnitt, Sortier-Ordnung, Hash je Datei vs.
   Konkatenation) -- von der Explore-Konsolidierung ausdruecklich als echtes NICHT-GEFUNDEN bestaetigt
   (LEDGER:3731); NICHT-blockierend (L14, Overlay-Fenster Phase 6).
2. Versand-Beleg des V3b-/OF-A8-2-NUR-KENNTNIS-Owner-Blocks -- nirgends auffindbar (A8-DOSSIER:414-417:
   "EV-Vorlagen ... nie versendet"; R2-Luecke). Entscheide sind gedeckt (GO ~17:4x + L7), die
   MELDEPFLICHT ist offen -> Startklar-Punkt 8.
3. B-6-Laufzeit-Beleg (CSV seg persistence_target == 0 bei aktiver Messung) -- existiert noch nirgends;
   S1-Pflichtteil VOR dem Fix (A8-DOSSIER:414-415, FAHRPLAN:59). Kein E-24-Blocker, aber Anker-Kette.
4. S5-Aufwandsschaetzung je Organ-Gruppen-Familie auf 70-Dateien-Basis -- nicht gefunden (A8-DOSSIER:
   420-421); Pflicht VOR der Trigger-Terminierung; hier nur grob mitgeschaetzt (3.4).
5. Formale LEDGER-A11-Verankerungszeile "E-24 GATE 4 + S12-Fenster + G8-Negativ-Liste" (OP-10) --
   existiert nicht (Grep-Befund R1, materiell gedeckt LEDGER:3731/:3750/:3764); Vollzug = C11-Ledger-
   Zeile + Lead-Nachtrag. Ebenso offen: A11-Sammelpaket B-1..B-7 des A8-Dossiers (R2-Luecke).
6. FK-5-Slot-RATIFIKATION: die Plan-Zusage "im M3-Fenster" ist verfallen, ein Ersatz-Slot existiert in
   KEINER Quelle (FAHRPLAN:22 nennt nur FK-3/FK-4) -- dieser Bauplan weist C9 zu (3.2); Lead/Manager
   ratifiziert die Zuweisung mit dem Fenster-GO.

**Im Bauplan ENTSCHIEDEN (keine offenen Punkte mehr, Meldung via V3b):** OP-2 Orakel je Genus (1.1-1.4)
/ OP-3 Adapter-Engine (1.3) / S12.3 Option A (1.6) / +ceb=8.0-Minor-Reset (5.1) / FK-7/FK-8-Vergabe
(6.2) / A8-Slot-Zuordnung (3.3) / Bau-Slot + Zeitschaetzung (3.4, schliesst OP-7).

**OP-Register-Abgleich (E24-DOSSIER:294-309):** OP-1 aufgeloest (Scheduling-CT gelandet; C11 bestaetigt
Rest per scheduling-Abgangs-Wache) / OP-4-Rest: Haupt-Messtreiber Registry vs. Direkt-Aufrufe -- im
Fenster an C4/C10 zu klaeren (einziger produktiver register_dock-Aufrufer ist f15_compare:220, am Ist
verifiziert) / OP-5 faktisch superseded (M3 landete ohne W10; W10 eigener Schritt) / OP-6
gegenstandslos (M4 gelandet) / OP-9 stale Kommentare -> C11 / OP-11 Hybrid-K1 E-24-neutral (L3-gedeckt)
/ OP-12 Test-Basis -> 4.3 / OP-13 Thesis-Nachzug melden -> C11 / OP-14 Dispositions-Erhebung -> V/3.3
vollzogen (Ist: KEINE A8-Scheibe gelandet); die ABGLEICH-Reihung "A8/A9 nach A2" ist fuer binary-
beruehrende A8-Teile durch L7/K-a korrigiert (FAHRPLAN:60).

---

## Paragraf 10 -- Kanon-Klammer

READ-ONLY-Planung: dieses Dossier aendert keinen Code. Der Bau folgt der Voll-Kadenz (4.5), der
Auflagen-Liste 1-17 (E24-DOSSIER:259-277), den TABUs (2.2) und der Ein-Fenster-Doktrin (EIN S12-Fenster,
kein stiller Split). Jede Abweichung vom hier gelisteten Fenster-Inhalt braucht einen Owner-Entscheid.
Nach C11 gilt G8: KEIN ABI-/POD-/Fingerprint-Touch bis zur Abgabe (Ausnahme-Klasse A8-S2/S6 host-/doku-
only). E-24 = GATE 4; der EINE Anker-Vollzug (TP1 + A2) = GATE 5 -- GENAU EINMAL, danach nur noch
fingerprint-neutrale Arbeit bis zum Trigger.
