# E-07 — Gate-Definition: B+-Baum-Steuerungs-Nachweis (Beweis B5, zweistufig) — NEUFASSUNG

**Datum:** 03.08.2026 · **Autor:** Design-Agent (Fable xhigh), read-only · **Status:** NEUFASSUNG (ersetzt die Erstfassung vom 02.08., die nur im Workflow-Backup `docs/sessions/backups/20260802-welle3-parallel-workflows/00-welle3-result.json` (result.designs.designs[3], key `E-07-gate-definition-b5-zweistufig`) existierte — nie als Repo-Datei gelandet) · kein Bau, kein Commit (Auftrag read-only)
**Anlass:** Inventur-Befund "E-07: B5-Beweis verlangt eine Gate-Definition, die NIRGENDS existiert" (SYNTHESE Abschn. 5 Nr. 13, `00-SYNTHESE-lage-dossier.md:262`); FAHRPLAN-Zeile B5 "Gate-Definition FEHLT ... OFFEN (2-stufig)".

---

## R. Review-Auflagen-Einloesung (Verdikt der Erstfassung: TRAGFAEHIG MIT AUFLAGE)

- **AUFLAGE ERFUELLT — Re-Anker am kanonischen live ce-Tree:** Die Erstfassung hatte die gesamte Ist-Kartierung auf dem STALE Modules-Klon (`/home/comdare/Projekte/Modules/comdare-cacheengine-all/comdare-cache-engine`, main@c395743e, 17 Slots) verifiziert — Verstoss gegen "Ist live pruefen"/4-Klone-Regel. DIESE Neufassung ist vollstaendig neu verankert am kanonischen ce-Tree `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine`, Branch `development`, Code-Stand **0d7a0d92** (Merge w2d-Transport-Bestandslog, NACH Welle-2d-Landung; Arbeits-HEAD 5c1ac257 = 0d7a0d92 + 2 reine docs-Commits, code-identisch). Alle datei:zeile-Anker unten sind auf dieser Linie am 03.08. literal nachgepruft.
- **Zitat-Korrektur:** Die Erstfassung zitierte die KATALOG-Linien-Angabe als "KATALOG:14" — real ist es **KATALOG:11** ("Linien-Ist ... ce main==dev==2b0a9bd8"). Die dort genannte Linie 2b0a9bd8 ist inzwischen selbst ueberholt: dev steht auf 0d7a0d92 (2d-Landung, CI-Wache lief per ABGLEICH-Doc-Kopf).
- **Welle-2d-Deltas eingearbeitet** (Transport/Bestandslog 0d7a0d92 + Flag-Grammatik 43a1b65a): TP1(B)-Praesenz-Filter als NEUER sanktionierter Teilmengen-Operator (S2/N2/N3), `slice_window_bounds`-Spannen-Form (K4), `mess_pfad_synchron_push` (CX-W1, mengen-neutraler Transport), CX-W6-Organ-Populations-Wachen (N1-Klassifikation), Planer-Version unter Flag-Grammatik (CX-W5).
- **Owner-Entscheide 02./03.08. beruecksichtigt** (`docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md` inkl. aller Nachtraege): A13-Stempel-Regression + Flag-Grammatik (Q3/Q10, Migration @1.0.0c im M3-Fenster), bindende Reihenfolge "2d landen -> Q-M3-GATE -> A13-M3 -> M4 -> OD-10-RT" (Nachtrag ~21:2x UTC), E-24 als LETZTER ABI-Schritt VOR Trigger (A16/HY-D2), Meta-Meta-Achsen gehoeren IMMER zu einem der drei Realms (Entscheid 2), Parallel-GO fuer diese Design-Arbeit (Nachtrag ~19:2x UTC, Punkt b).

**Quellen (alle am 03.08. gelesen und zeilen-verifiziert):**
- `docs/sessions/20260802-KATALOG-offene-strecke-gesamtplan.md:11` (Linien-Ist), `:19` (A3: "B5 zweistufig nach E-07-Pruefung"), `:80` (E-07 "Gate-Definition FEHLT"), `:85` (Verwechslungs-Warnung Variant-Gate vs std::variant)
- `docs/sessions/20260801-FAHRPLAN-vollbau4-beweise-g6-trigger.md:12-18` (4+1-Beweise-Tabelle; `:18` = B5 "OFFEN (2-stufig)")
- `docs/sessions/backups/20260802-kontext-neugruendung-abend-workflows/00-SYNTHESE-lage-dossier.md:232` (GATE 7: "E-07-Gate ist noch UNDEFINIERT"), `:262` (Abschn. 5 Nr. 13)
- `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:98` (V7.4-Gate-Kette 4+1), `:2128-2129` (Par. 24.E / Task #54 = Ursprung), `:2251` (Mess-Achsen-Klasse der lazy Permutationskette), `:2354` (Par. 38), `:2654` + `:3021` (Task #54-Traeger), `:2802/:2834` (T4: Baum je ACHSEN-TYP)
- ce `docs/sessions/20260803-ABGLEICH-katalog-gesamtplan-ist-stand.md:14` (A3 "OFFEN, unveraendert") + Kopf (2d-Landung, dev=0d7a0d92)
- ce-Code-Ist: alle Anker in Abschn. 0 (repo-relativ, Linie 0d7a0d92)
- codex-doppelreview-Backup: 0 Treffer E-07/E07 (kein Zusatz-Befund)

---

## 0. Ist-Kartierung: der Steuerungspfad (read-only am live Tree verifiziert, 0d7a0d92)

Begriffs-Ehrlichkeit vorab: "B+-Baum" ist das historische Etikett; die Struktur ist ein ACHSEN-GESCHICHTETER PRAEFIXBAUM (`libs/cache_engine/builder/experiment_tree/experiment_tree.hpp:1-10`, "BENENNUNGS-EHRLICHKEIT"). Der Gate-Name bleibt "B+-Baum-Steuerungs-Nachweis" (Kanon-Treue); der Beweis prueft die Praefixbaum-Mechanik.

**Kette XML -> Baum -> Ausfuehrung (Organ-Familie):**
1. **XML-Quelle:** `comdare_thesis_profile`/Experiment-XML (Parser KF-1, `xml_config_parser`) + AxisRegistry = `permutation_axes.xml` (`profile_to_tree.hpp:11`, `:25-26`).
2. **Adapter XML->Baum:** `build_axis_levels()` (`profile_to_tree.hpp:39`); Organ-Achsen-Guard `is_organ_composition_axis()` gegen die EINE Namens-Single-Source (`profile_to_tree.hpp:32-37`); struktureller Organ-only-binary_id-Guard im Aufrufer (`profile_to_tree.hpp:104-111`; System-Achsen laufen ueber die CEB-System-Schicht/Sidecars, nie in die binary_id).
3. **Baum:** `ExperimentTree` (`experiment_tree.hpp:341`); statische Ebenen = Binaries, dynamische Ebenen = virtuelle Laufzeit-Schleifen (`experiment_tree.hpp:14-27`), `dynamic_filter()` (`:364`).
4. **Lazy-Enumeration:** `StaticBinaryView` (`experiment_tree.hpp:237`); `operator[](i)` dekodiert mixed-radix genau EINEN Pfad (`:281`), Inverse `flat_index` (`:258-260`), `binary_count()` rein arithmetisch (`:375`).
5. **Pfad-Identitaet (Round-Trip-Garant):** EINE zentrale Pfad-Serialisierung; `kCompositionAxisNames` = **18 Slots inkl. `persistence_target` (T17, STRUKT-R ORG-18)** (`axis_path_serialization.hpp:40-43`; STRUKT-R-Begruendung `:31-39`; BR-1/BR-2/BR-4-Konvention `:2-13`) — Baum-Blatt-`binary_id` == CompositionRegistry-Key == perm_<id>-Benennung. Sidecar-Historie: telemetry raus per INC-2c (`:26-27`), isa raus per INC-2d (`:28-31`).
6. **Fenster/Selektion (sanktionierte Teilmengen-Operatoren):**
   a) `BuildSelection` mit Provenance, "kein stilles Truncaten" (`coverage_selection.hpp:24-25`); `select_full` verweigert statt zu kappen (`:32-37ff`).
   b) GN-Zellen-Filter `COMDARE_GN_OPT`/`COMDARE_GN_SIMD` (`gn_cell_filter.hpp:22`, `:26`, `:35`).
   c) golden-Chunk-Fenster `COMDARE_GOLDEN_N_RANGE="start:count"` -> `golden_range_start/count` (`profile_run_facade.hpp:59-62`).
   d) **NEU (Welle 2d, TP1(B)/G-A2):** Planer-getriebener Praesenz-Filter — `PresenceFn` ist vom Informations- zum BAU-FILTER geworden: bekannte Bestands-Treffer werden VOR dem Bau uebersprungen und als Skips AUSGEWIESEN; ohne Praedikat baut alles = byte-identisch (`bestandslog/planer_driven_build.hpp:11-15`, `filter_window_for_build`; Fenster-Spanne `slice_window_bounds` = (min, max-min+1) `planer_driven_build.hpp:88` + `cache_engine_builder_iterator.hpp:985-988`). Test: `tests/unit/test_tp1_planer_filter_iterator.cpp`.
7. **Der EINE Treiber:** `run_lazy_static_then_dynamic()` (`cache_engine_builder_iterator.hpp:1093/:1099`) — statisch bauen (BuildOrchestrator), DLL laden, dynamisch variieren, messen, `ingest_result_line` zurueck in den sparse Baum (Ketten-Kommentar `:2-21`, ingest `:16/:35`). Mess-Pfad-Transport (Welle 2d, CX-W1): `mess_pfad_synchron_push` (`:908` Definition, `:1835` Aufruf) — mengen-NEUTRAL (Transport, kein Selektions-Operator).

**System-/Mess-Familie:** `topics::AxisKind{organ, system_measurement, system_config}` (`libs/cache_engine/topics/axis.hpp:17-20`); organ-Kommentar traegt "18 Slots; STRUKT-R ORG-18" (`:18`); system_config "beruehrt NIE die binary_id" (`:20`, Q2-Option-C). **NEU seit Lane A/A13-M2:** drei ADDITIVE Meta-Meta-Diskriminatoren `system_meta_meta` (`:31`), `measurement_meta_meta` (`:40`), `organ_meta_meta` (`:49`) — byte-neutral, solange keine Achse sie zurueckgibt; per Owner-Entscheid 2 (02.08.) gehoert jede Meta-Meta IMMER zu einem der drei Realms -> fuer dieses Gate zaehlen Meta-Metas zur S1-S3-Pruefung ihres Realms (kein viertes Familien-Gate). Der Planer-Walk `ExperimentPlanDirector` enumeriert opt x simd x Passes deterministisch; `PlanTextBuilder` = `--dump-plan` mit Contract "2 Laeufe byte-gleich" (`planner/experiment_plan_director.hpp:25-26`; Facade `profile_run_facade.hpp:219/:235`).

**Par.-38-Dock-Naht (Planer-getriebene Fenster):** hinab `ExperimentSubtreePayload` (AxisKind-gefaerbte Achsen-Ranges, R5-Syntax, Byte-Roundtrip-Gate; `planner/experiment_dock_payload.hpp:7-9`, struct `:67`, emit `:138`/parse `:170`) — hinauf `ProgressDelta` (erste Meldung = Voll-Konfiguration, dann mixed-radix-minimale Deltas in StaticBinaryView-Ordnung, genau EIN `done` am Fensterende; `progress_delta.hpp:10-13`, `:30-36`, `compute_progress_deltas :60-61`; Iterator-Naht `cache_engine_builder_iterator.hpp:173-196`, fire_progress/Fertig-Signal `:1313-1326`, fenster-relativer Cursor `fenster_cursor_of :1343`, Feuer-Stellen `:1394/:1450/:1880`).

**Flag-Grammatik-Wachen (Welle 2d, CX-W5/W6 — N1-relevant):** `guard_all_registered_organ_versions` laeuft ueber die ROH-registrierten All*-Listen von "exakt die 18 kCompositionAxisNames-Achsen" (`registry_to_axis_levels.hpp:84-97`, R00..R26 inkl. `R26_persistence_target :115`; Enabled-Seite `T26_persistence_target :81`, bindende Reihenfolge `:162-163`); Planer-Selbst-Stempel unter derselben Politik (`planner/planner_version.hpp:12-25`). Diese Wachen sind eine SANKTIONIERTE, 1:1 aus den Registries ABGELEITETE Zweit-Enumeration (CT-Reflexion) — in der N1-Klassifikation "Single-Source-Ableitung", KEIN Bypass. Tests: `test_reflect_versions_all_registered.cpp`, `test_planner_version_flag_grammatik.cpp`.

**Bestehende Test-Deckung (NICHT der Gate-Beweis):** `tests/unit/test_kf9_experiment_tree.cpp` (Baum-Mechanik), `test_d14c_e2e_pipeline.cpp:1-3` (O(K): 3 aus 1e9-View), `test_experiment_dock_payload.cpp`, `test_progress_delta.cpp`, neu `test_tp1_planer_filter_iterator.cpp`. Diese Tests halten die XML KONSTANT und arbeiten auf Fixtures — per Kanon "gruene Tests zementieren alte Ordnung" beweisen sie NICHT, dass die XML die einzige wirksame Quelle ist.

---

## 1. Gate-Definition E-07: Was heisst "der B+-Baum steuert" (messbar)

**Definition (normativ).** Der Experiment-B+-Baum STEUERT genau dann, wenn fuer JEDE der drei Achsen-Familien (organ / system_config / system_measurement; Meta-Metas zaehlen zu ihrem Realm) gilt:

- **S1 Vollstaendigkeit:** Jede in der XML freigegebene Achsen-Auspraegung erscheint als Baum-Ebene/-Wert, und exakt die vom Baum enumerierte Menge wird gebaut bzw. gemessen — nichts fehlt.
- **S2 Exklusivitaet:** Nichts ausserhalb des Pfades XML -> Baum bestimmt die Menge. Sanktionierte Fenster-/Skip-Mechaniken (BuildSelection, GN-Zellen-Filter, golden_range, Par.-38-Ranges, **TP1(B)-Praesenz-Filter**) sind reine TEILMENGEN-Operatoren auf der Baum-Ordnung — sie koennen die Menge nur verkleinern (bzw. Bau-Arbeit ausweislich ueberspringen), nie Elemente hinzufuegen oder umdefinieren. Kein hartkodierter Bypass, keine zweite Achsen-Quelle.
- **S3 Kausalitaet:** Eine minimale XML-Aenderung erzeugt exakt die VORHERGESAGTE Aenderung der Output-Menge (Differenz-Probe); keine XML-Aenderung erzeugt Determinismus (byte-gleicher Plan, identische id-Menge).

**Messbare Kriterien (jedes mit literaler Ausgabe; kein Haken ohne woertliche Ausgabe):**

| K | Kriterium | Literale Gate-Zeile (Beispiel-Format) |
|---|---|---|
| K1 | Kardinalitaets-Identitaet: Baum-Zaehlung == Plan-Zaehlung == gebaute Artefakte (volles Mini-Fenster) | `E07_TREE_COUNT=<n>` == `E07_PLAN_PERMS=<n>` == `E07_BUILT_COUNT=<n>` |
| K2 | Pfad-Roundtrip: fuer ALLE i im Fenster `view[i].binary_id` == Artefakt-Name == CSV-`binary_id` (Single-Source `axis_path_serialization.hpp:40`, 18 Segmente inkl. `persistence_target=`) | `E07_ID_ROUNDTRIP_MISMATCH=0` |
| K3a | Organ-Differenz-Probe: EIN Achsen-Wert aus der XML entfernt (m -> m-1 Werte) => Count exakt n' = n*(m-1)/m UND 0 gebaute/gemessene ids mit dem entfernten Wert | `E07_ORGAN_DELTA_EXPECTED=<n'>` == `E07_ORGAN_DELTA_ACTUAL=<n'>`; `E07_REMOVED_VALUE_HITS=0` |
| K3b | System-Config-Differenz-Probe: EINE opt/simd-Zelle aus der XML entfernt => Plan-/Bau-Zellen sinken um die vorhergesagte Zahl, binary_id-Menge UNVERAENDERT (beweist Q2-Option-C: system_config beruehrt nie die binary_id, `axis.hpp:20`) | `E07_SYS_CELLS_BEFORE=<a>` / `E07_SYS_CELLS_AFTER=<b>` mit b==Vorhersage; `E07_BINARY_ID_SET_CHANGED=0` |
| K3c | Mess-Achsen-Differenz-Probe: EIN Mess-Modus/Pass aus der XML entfernt => Mess-Zeilen/Pass-Zahl sinkt vorhergesagt, binary_id-Menge unveraendert | `E07_MEASURE_PASSES_BEFORE/AFTER` mit Vorhersage-Match; `E07_BINARY_ID_SET_CHANGED=0` |
| K4 | Fenster-Treue: `COMDARE_GOLDEN_N_RANGE=start:count` baut exakt view[start .. start+count): erste/letzte id == `view[start]`/`view[start+count-1]`; ProgressDelta-Protokoll: erste Meldung Voll-Konfiguration, Cursor-Maximum == count-1, genau EIN `done`. ZUSATZ (Welle 2d): auf dem Planer-Pfad muss `slice_window_bounds` die Index-MENGE voll enthalten (begin=min, count=Spanne) — Spannen-Form dokumentiert Ober-MENGE, der Praesenz-Filter reduziert nur | `E07_WINDOW_FIRST_ID_MATCH=1`, `E07_WINDOW_LAST_ID_MATCH=1`, `E07_PROGRESS_CURSOR_MAX=<count-1>`, `E07_PROGRESS_DONE_COUNT=1` |
| K5 | Determinismus: `--dump-plan` zweimal byte-identisch (bestehender Contract, `experiment_plan_director.hpp:25-26`) UND Wiederholungslauf ohne XML-Aenderung liefert identische id-Menge | `E07_PLAN_BYTE_EQUAL=1`, `E07_RERUN_ID_SET_EQUAL=1` |

**Negativ-Proben (Pflichtteil der Definition — ohne sie ist kein Steuerungs-Claim zulaessig):**

- **N1 Bypass-Suche (statisch, Stufe 1):** Es existiert KEINE produktive Konstruktion von `BinarySpec`/`binary_id` ausserhalb `StaticBinaryView`/`axis_path_serialization.hpp`, und KEINE zweite Achsen-Namensliste neben `kCompositionAxisNames` (BR-1/BR-2/BR-4-Konvention, `axis_path_serialization.hpp:2-13`). Kriterium: vollstaendige Fundstellen-Liste, jede Fundstelle klassifiziert (Single-Source-Ableitung / Test / BEFUND); Liste aus dem Code-Walk abgeleitet, NIE handgepflegt. Literal: `E07_BYPASS_FINDINGS=0` (oder Befundliste). **Bekannte sanktionierte Ableitungs-Stellen (vor-klassifiziert):** CX-W6-All*-Wachen (`registry_to_axis_levels.hpp:84-97` — liest nur `W::algo_version`, keine id-Konstruktion). **Kritische Verdachts-Kandidaten (Pflicht-Pruefpunkte):** die Achsen, die die Komposition VERLASSEN haben — telemetry (INC-2c, H-10-Sidecar) und isa (INC-2d, `+target=`-Sidecar; `axis_path_serialization.hpp:26-31`): ihre Steuerung MUSS nachweislich weiter am XML/Baum-Pfad haengen (Sidecar-Inhalt aus Profil/Registry abgeleitet, nicht hartkodiert).
- **N2 Stale-Artefakt-Probe (dynamisch, Stufe 2):** Ein Artefakt eines aus der XML ENTFERNTEN Werts liegt physisch im dll_dir/Lager. Der Lauf darf es NICHT messen/ingestieren: 0 Mess-Zeilen mit der entfernten id; Resume-/GN-Entscheidung darf es nicht wiederbeleben. **VERSCHAERFUNG (Welle 2d):** auch der TP1(B)-Praesenz-Filter darf die entfernte id nicht wiedereinfuehren — er operiert auf `plan->view_indices` (Baum-abgeleitet), die entfernte id darf dort nie auftauchen; ein Bestands-Treffer AUSSERHALB der Baum-Menge ist toter Bestand, kein Bau-/Mess-Kandidat. Literal: `E07_STALE_ID_MEASURED=0`. (Wo Lager-Hydration aktiv ist, muss die entfernte id in der pruned-Menge auftauchen — Mengen-Gleichheit mit der Baum-Vorhersage, nicht bloss pruned>0; Abgrenzung zu B2 s. Abschn. 3.)
- **N3 Fenster-Teilmengen-Invariante:** Sanktionierte Fenster-/Skip-Envs (inkl. Praesenz-Filter) koennen die id-Menge nur VERKLEINERN: ids(Fenster) Teilmenge von ids(voll), 0 neue ids; Skips werden AUSGEWIESEN (Skip-Zaehler im Log), nie still. Ein NICHT sanktioniertes Fantasie-Env aendert nichts (K5 haelt). Literal: `E07_WINDOW_SUBSET=1`, `E07_WINDOW_NEW_IDS=0`.

**Ungueltigkeits-Regel (Anti-Schein-Gruen, Analog "behalten=alles ist Befund"):** Eine Differenz-Probe, deren erwartetes Delta 0 ist (z. B. Achse mit nur 1 Wert gewaehlt), ist UNGUELTIG und zaehlt nicht als bestanden. Erwartete Werte werden ARITHMETISCH aus der XML-Differenz abgeleitet (Count-Formeln), nie aus Fixture-Strings uebernommen (Kanon: gruene Tests zementieren alte Ordnung).

**GO-Kriterium E-07:** K1-K5 UND N1-N3 saemtlich mit literalen Zeilen erfuellt, je Familie mindestens eine gueltige Differenz-Probe. Jede Abweichung = Befund mit ebenen-richtiger Nachbesserung (kein Weiterreichen).

---

## 2. Zweistufiger B5-Beweiszuschnitt (FAHRPLAN:18 "OFFEN (2-stufig)" eingeloest)

**Stufe B5.a — Wirksamkeits-/Kartierungs-Pruefung (ultracode, read-only, VORGELAGERT):**
Prueft, OB die Steuerung nach Lane A/C/F + ORG-18 + Welle 1-2d wirksam ist, BEVOR der Beweislauf gebaut wird (FAHRPLAN-Zuschnitt: "vorgelagert: ultracode-Pruefung, OB die Steuerung ... wirksam ist; erst danach Kriterium festlegen" — DIESE Definition normiert das Kriterium bereits; Stufe 1 darf Kriterien nur schaerfen/parametrisieren, nicht abschwaechen). **Schritt 1 der Stufe B5.a ist per Review-Auflage der Re-Anker aller datei:zeile-Anker auf der dann aktuellen Trigger-Linie** (diese Neufassung liefert den Stand 0d7a0d92; A13-M3/M4/OD-10-RT/E-24 bewegen die Linie danach noch).
Inhalt:
1. Anker-Kette datei:zeile fuer alle drei Familien auf der AKTUELLEN Linie re-verifizieren: XML-Parser -> `build_axis_levels` -> Baum-Ebenen -> View -> Selektion/Fenster (inkl. TP1(B)-Filter) -> Treiber -> binary_id -> ingest. (Basis: Abschn. 0.)
2. **ORG-18-Wirksamkeits-Check — Stand dieser Neufassung: IN DER SINGLE-SOURCE ANGEKOMMEN.** `kCompositionAxisNames` traegt 18 Slots inkl. `persistence_target` (`axis_path_serialization.hpp:40-43`), Registry-Seite Enabled+All verdrahtet (`registry_to_axis_levels.hpp:81/:115/:162-163`), AxisKind-Kommentar auf 18 (`axis.hpp:18`). RESTFRAGE fuer B5.a: End-to-End-Bestaetigung, dass `persistence_target` als Baum-EBENE aus Profil/Registry expandiert und in realen binary_ids erscheint (Level-Erzeugung + ein realer id-String mit `persistence_target=`-Segment). BEFUND (neu, Stufe-1-Vorgriff): stale "17"-KOMMENTARE in `profile_to_tree.hpp:28` ("der 17 Organ-Kompositions-Achsen") und `:104-108` ("Nur die 17 Organ-...", "17-Slot-Organ-Pfad") — der CODE leitet aus der 18er-Single-Source ab (verhaltens-neutral), die Kommentare sind Drift -> Aufraeumpass-/A11-Kandidat, in B5.a als klassifizierter Befund fuehren.
3. N1-Bypass-Suche vollstaendig fahren (inkl. Sidecar-Kandidaten telemetry/isa, OP-6) + Abdeckungs-Matrix: jede Achse der drei Registries -> Baum-Ebene ODER dokumentierte Sub-Achse/Sidecar mit XML-Herkunfts-Beleg. Nach-2d-Zusatzflaechen: CX-W6-All*-Wachen (vor-klassifiziert: Ableitung), OS-Unter-Achsen (A14: U1-U3 gebaut, produktiv erst mit U4) und die drei Meta-Meta-Diskriminatoren (additiv/inaktiv — Nachweis "keine Achse gibt sie zurueck" genuegt, solange das so bleibt).
4. Verdikt je Familie: WIRKSAM / TEIL-WIRKSAM(Befunde) / UNWIRKSAM. Nur bei WIRKSAM bzw. TEIL-WIRKSAM mit geraeumten Befunden wird Stufe 2 freigegeben.
Ergebnis-Form: Audit-Dossier mit Anker-Tabelle + klassifizierter Fundstellen-Liste. Aufwand: 0,5-1 Agenten-Tag, read-only, golden-neutral, jederzeit parallelisierbar.

**Stufe B5.b — Beweislauf (lokal, golden-neutral):**
Kleiner Probe-Harness (opt-in, eigener out-/dll-Ordner, No-Op-Naehte leer => byte-/golden-neutral) um `profile_run_facade`/`run_lazy_static_then_dynamic` mit einem Mini-Profil (Produkt <= 8 Binaries):
1. Basis-Lauf: K1 + K2 + K5 (Plan-Doppellauf + Wiederholungslauf).
2. Drei Differenz-Proben K3a/K3b/K3c (je Familie eine XML-Kopie mit genau EINER Aenderung; erwartete Deltas arithmetisch vorberechnet und im Log VOR dem Lauf ausgegeben).
3. K4-Fenster-Probe (`COMDARE_GOLDEN_N_RANGE` + ProgressSink im Harness) + N3-Teilmengen-Check; wo der Planer-Pfad aktiv ist, zusaetzlich Praesenz-Filter-Skips als ausgewiesene Teilmenge belegen.
4. N2-Stale-Artefakt-Probe (Artefakt des entfernten Werts vorab ins dll_dir/Lager legen; Praesenz-Filter-Verschaerfung s. N2).
Alle `E07_*`-Zeilen werden woertlich ins Beweis-Protokoll uebernommen (Session-Doc), Rohlogs additiv gesichert. Aufwand: 0,5-1 Tag Bau + < 1 h Laufzeit; Re-Run auf spaeterer Linie < 1 h.

---

## 3. Abgrenzung zu B1-B4 (FAHRPLAN:12-18)

| Beweis | beweist | B5-Abgrenzung |
|---|---|---|
| B1 Resume-Skip (`GN_DECISION=skip`) | WIEDERAUFNAHME-Oekonomie: Gebautes wird uebersprungen | B5-N2 prueft die GEGENRICHTUNG: Nicht-mehr-Konfiguriertes darf NICHT wiederbelebt werden. B1 haelt die XML konstant; B5 variiert sie. Seit 2d gehoert der TP1(B)-Praesenz-Filter zur B1-Familie (Skip-Oekonomie) — B5 prueft nur seine Teilmengen-Invariante. |
| B2 Hydration (`verified>0` UND `pruned>0`) | LAGER-MECHANIK: das Zaehlwerk der Hydration funktioniert | B5-N2 beweist die ENTSCHEIDUNGSQUELLE: die pruned-/verified-MENGE ist exakt die Baum-Vorhersage (Mengen-Gleichheit statt >0-Existenz). B5 darf B2-Maschinerie als Vehikel nutzen, hat aber ein eigenes Kriterium. |
| B3 Variant-Gate-E2E (`COMDARE_VARIANT_GATE=true`) | ZULASSUNGS-Gate je Variante (.variant-Sidecar; NICHT std::variant — Verwechslungs-Warnung KATALOG:85) | B5 beweist die MENGEN-BILDUNG davor: welche Varianten ueberhaupt zur Zulassung anstehen, bestimmt der Baum. |
| B4 Bestandslog-E2E (2 Prozesse, Sektion<Budget) | PROTOKOLL/NEBENLAEUFIGKEIT der Bestandsfuehrung (seit 2d gehaertet: Z-01/GA-02 trunc-Schutz, CX-W3/W8) | Kein Steuerungs-Claim; disjunkt. |
| **B5 (E-07)** | **QUELLEN-AUTORITAET: XML->Baum ist die einzige wirksame Konfigurationsquelle aller drei Achsen-Familien** | Einziger Beweis mit der XML als UNABHAENGIGER VARIABLE (Differenz-Proben S3); B1-B4 sind Mechanik-Beweise bei konstanter XML. |

---

## 4. Aufwand und Einordnung in die Gate-Kette

**Position (V7.4, LEDGER:98):** nach W-13, als "+1" der 4+1 lokalen Beweise, VOR G6/J-Kette, VOR dem Voll-Bau-4-Trigger. E-07/B5 ist damit trigger-blockierend im A3-Paket (KATALOG:19; ABGLEICH:14 "OFFEN, unveraendert").

**Sequenz (aktualisiert um die bindende Owner-Reihenfolge vom 02.08. ~21:2x UTC "2d landen -> Q-M3-GATE -> A13-M3 -> M4 -> OD-10-RT" und die harte E-24-Kante HY-D2 "VOR Trigger"):**
- **Stufe B5.a SOFORT startbar** (read-only; unabhaengig vom A13-M3-Fenster und E-24-ABI-Fenster; liefert frueh Befunde, die M3/E-24 sonst verdecken). Diese Neufassung hat den Anker-Teil fuer 0d7a0d92 bereits vorweggenommen.
- **Stufe B5.b NACH A13-M3 + E-24** (letzter Stempel-/ABI-Schnitt; M3 migriert die Versions-Literale auf die Flag-Grammatik-Form, gerendert `@X.Y.Zc` per Owner-Q10 — ein Stempel-/SHA512-Byte-Ereignis): der Beweis soll die TRIGGER-Linie beweisen, nicht eine Vor-Linie — sonst Wiederholungspflicht. Falls A13-M3/E-24 sich um mehr als das Beweis-Fenster verzoegern: einmal vorlaufen (Frueherkennung) + billiger Pflicht-Re-Run (<1 h) auf der eingefrorenen Trigger-Linie. Sequenz-Entscheid = Vorlage E07-Q1 (Abschn. 7; Default A = danach).

**Aufwand gesamt:** ~1,5-2 Agenten-Tage (B5.a 0,5-1 read-only + B5.b 0,5-1 Bau, Laufzeit < 1 h, Re-Run < 1 h). Golden-neutral in beiden Stufen (opt-in Harness, eigene Ordner, No-Op-Naehte). Kein ABI-Touch, kein golden-Touch, kein CI-Pflicht-Anteil (lokaler Beweis wie B1-B4; CI-Wiederholung optional nach Trigger).

---

## 5. Verankerung (bei Landung dieses Dossiers auszufuehren — hier nur benannt, Auftrag read-only)

- **Ablage-Ziel:** super `docs/sessions/20260803-DOSSIER-e07-gate-definition-b5-zweistufig.md` (Praezedenz: `20260803-DOSSIER-a13-m3-ausfuehrung.md`; Gate-/Beweis-Doktrin gehoert zu KATALOG/FAHRPLAN/SYNTHESE ins super-Repo, nicht in ce docs/architecture — dort liegen Code-Architektur-Designs wie `20260802-hybrid_tier_stufe_soll_design.md`).
- Ledger-Nachtrag: E-07 = DEFINIERT per diesem Dossier; Task #54 (LEDGER:2654/:3021) wird durch B5.a eingeloest, B5.b terminalisiert ihn.
- FAHRPLAN:18 ("Gate-Definition FEHLT") -> Verweis auf dieses Dossier; Kriterium = K1-K5 + N1-N3, GO-Regel Abschn. 1.
- **Supersede-Pflicht nach Landung:** SYNTHESE:232 (GATE 7 fuehrt "E-07-Gate ist noch UNDEFINIERT") und KATALOG:80 ("Gate-Definition FEHLT") sind zu superseden (Doku nur deprecaten/supersede-vermerken, nie loeschen).
- Beweis-Protokolle beider Stufen als neue Session-Docs (Doku-Policy), Rohlogs additiv.

---

## 6. Offene Punkte (OP) — Neufassungs-Stand

- **OP-1 Klon-Drift: ERLEDIGT durch diese Neufassung.** Alle Anker am kanonischen live ce-Tree (development, Code-Stand 0d7a0d92) neu belegt; der Modules-Klon-Stand c395743e ist obsolet. Rest-Pflicht: Schritt-1-Re-Anker in B5.a auf der finalen Trigger-Linie (nach M3/M4/OD-10-RT/E-24).
- **OP-2 ORG-18: TEIL-ERLEDIGT.** In Kompositions-Single-Source (18 Slots, `axis_path_serialization.hpp:40-43`) + Registry-Ebenen (`registry_to_axis_levels.hpp:81/:115/:162-163`) + Wachen (CX-W6) ANGEKOMMEN. Rest = B5.a-End-to-End-Bestaetigung (Baum-Ebene + realer id-String) + NEUER Befund stale "17"-Kommentare `profile_to_tree.hpp:28/:104-108` (verhaltens-neutral, Aufraeumpass/A11).
- **OP-3 Par.-38-Payload-Naht: UNVERAENDERT (am 0d7a0d92-Ist re-verifiziert):** `ExperimentSubtreePayload` hat ausser `test_experiment_dock_payload` keinen Produktions-Konsumenten (Fundstellen: nur Header + Test + CMakeLists). K4 prueft daher die REAL verdrahteten Fenster-Mechaniken (golden_range/GN-Zellen/Planer-Praesenz-Pfad) + ProgressDelta via Harness-Sink; sobald die Payload produktiv verdrahtet ist, ist K4 um eine Payload-Range-Probe zu ergaenzen (ehrlich ausweisen, nicht vorwegnehmen).
- **OP-4 K3c-Abhaengigkeit: UNVERAENDERT.** Die Mess-Achsen-Differenz-Probe haengt an der E.0/KERN-Mess-Schema-Naht (SYNTHESE Nr. 9: KERN-Naht nicht angeschlossen, Director-Kreuzprodukt). Bis E.0 landet: K3c auf die vorhandene Mess-Modi-/Pass-Mechanik zuschneiden und nach E.0 wiederholen.
- **OP-5 Sequenz-Entscheid B5.b:** bleibt als Owner-/Manager-Vorlage E07-Q1 offen (Abschn. 7). Die Owner-Nachtraege vom 02.08. (bindende Reihenfolge 2d->M3->M4->OD-10-RT; E-24 vor Trigger; "ordentlich" statt vorgezogen) STUETZEN Default A (B5.b nach A13-M3+E-24). Task #22 (Vorlage unversendet) besteht fort.
- **OP-6 Sidecar-Kandidaten: UNVERAENDERT PFLICHT.** telemetry (H-10-Sidecar, INC-2c) und isa (`+target=`-Sidecar, INC-2d) haben die binary_id-Komposition verlassen (`axis_path_serialization.hpp:26-31`) — B5.a muss ihre XML/Baum-Herkunft explizit belegen (prominenteste Bypass-Verdachtsklasse).
- **OP-7 Verankerung: WEITERHIN AUSSTEHEND** (dieser Auftrag ist read-only, kein Commit): Ledger-Nachtrag (E-07=DEFINIERT, Task #54 -> B5.a/B5.b), FAHRPLAN:18-Verweis, Supersede von SYNTHESE:232/KATALOG:80 — Ausfuehrung bei Landung per Abschn. 5.
- **OP-8 (NEU) stale "17"-Kommentare** `profile_to_tree.hpp:28` + `:104-108`: Doku-Drift zur 18er-Single-Source; Code korrekt (leitet aus `kCompositionAxisNames` ab). Aufraeumpass-Kandidatenliste fortschreiben; in B5.a als klassifizierter Befund fuehren, kein Blocker.
- **OP-9 (NEU) TP1(B)-Praesenz-Filter-Probe:** Der 2d-Filter (`planer_driven_build.hpp`, `filter_window_for_build`) ist als Teilmengen-Operator in S2/N2/N3 aufgenommen; B5.b muss eine Probe fahren, in der ein Bestands-Treffer ausserhalb der Baum-Menge liegt (darf weder gebaut noch gemessen noch als Skip einer Baum-id gezaehlt werden). Bis dahin gilt der Filter als sanktioniert-mit-Probe-Pflicht.

---

## 7. Owner-/Manager-Vorlage E07-Q1 (verbose per E-21; unversendet, Task #22)

**ID:** E07-Q1 — Sequenz der B5-Stufe b.
**KONTEXT:** Der E-07-Beweislauf (Stufe b) beweist die Steuerung auf einer konkreten ce-Linie; A13-M3 (Stempel-Neuanker + Flag-Grammatik-Migration, gerendert `@X.Y.Zc`) und E-24 (LETZTER ABI-Schritt, HY-D2-Kante VOR Trigger) aendern die Linie danach nicht mehr. Bindende Owner-Reihenfolge 02.08.: 2d landen -> Q-M3-GATE -> M3 -> M4 -> OD-10-RT.
**OPTIONEN:** (A) Stufe b NACH A13-M3+E-24 auf der eingefrorenen Trigger-Linie fahren — ein Lauf, beweist exakt die Trigger-Linie, kein Re-Run noetig. (B) Stufe b SOFORT nach Stufe a vorlaufen lassen (Frueherkennung von Steuerungs-Regressionen) + billiger Pflicht-Re-Run (<1 h, Harness steht) auf der Trigger-Linie.
**EMPFEHLUNG:** A, solange A13-M3/E-24 planmaessig vor dem Beweis-Fenster liegen; B nur bei Verzoegerung um mehr als das Beweis-Fenster (Frist Do 07.08./Fr 08.08. im Blick).
**DEFAULT (wenn keine Antwort):** A. Stufe a (read-only-Audit) ist von diesem Entscheid unabhaengig und sofort startbar.

---

## ANHANG: NUR-KENNTNIS-Kurzmeldung (versandfertig, kein Arbeitsauftrag, keine GO-Anfrage)

E-07-Gate-Definition liegt als Neufassung vor (03.08.2026, am live ce-Stand 0d7a0d92 verankert): "Der B+-Baum steuert" heisst (S1) Vollstaendigkeit, (S2) Exklusivitaet (alle Fenster-/Skip-Mechaniken inkl. des neuen TP1(B)-Praesenz-Filters sind reine Teilmengen-Operatoren), (S3) Kausalitaet (XML-Differenz-Proben mit arithmetisch vorhergesagten Deltas). Messkriterien K1-K5 + Negativ-Proben N1-N3, alle mit literalen `E07_*`-Gate-Zeilen; Proben mit erwartetem Delta 0 sind ungueltig. B5 bleibt zweistufig: Stufe a = read-only-Wirksamkeits-Audit (sofort startbar; ORG-18 ist in der 18-Slot-Single-Source nachweislich angekommen, Restfrage End-to-End + zwei stale "17"-Kommentare als Befund), Stufe b = lokaler Beweislauf (Mini-Profil <= 8 Binaries, golden-neutral), empfohlen NACH A13-M3+E-24 auf der eingefrorenen Trigger-Linie (Vorlage E07-Q1, Default A). B5/E-07 ist trigger-blockierend im A3-Paket; nach Landung sind SYNTHESE:232 und KATALOG:80 ("UNDEFINIERT"/"FEHLT") zu superseden.
