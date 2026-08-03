# E-07 — Gate-Definition: B+-Baum-Steuerungs-Nachweis (Beweis B5, zweistufig)

**Datum:** 02.08.2026 · **Autor:** Design-Agent (Fable xhigh), read-only · **Status:** DEFINITION (owner-faehig), kein Bau, kein Commit
**Anlass:** Inventur-Befund "E-07: B5-Beweis verlangt eine Gate-Definition, die NIRGENDS existiert" (SYNTHESE Abschn. 5 Nr. 13).

**Quellen (gelesen):**
- `docs/sessions/20260802-KATALOG-offene-strecke-gesamtplan.md:19` (A3 Beweise 1-5, "B5 zweistufig nach E-07-Pruefung"), `:80` (E-07 "Gate-Definition FEHLT")
- `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:98` (V7.4-Gate-Reihenfolge: 4+1 lokale Beweise), `:2128-2129` (Par. 24.E / Task #54 = Ursprung von E-07), `:2251` (AxisKind-Faerbung), `:2354-2367` (Par. 38 Teilbaum-Serialisierung + Rueck-Kanal), `:2654`, `:2802/:2834` (T4: Baum je ACHSEN-TYP), `:3021`
- `docs/sessions/backups/20260802-kontext-neugruendung-abend-workflows/00-SYNTHESE-lage-dossier.md:232` (GATE 7), `:262` (Nr. 13)
- `docs/sessions/20260801-FAHRPLAN-vollbau4-beweise-g6-trigger.md:12-18` (Beweis-Tabelle B1-B5; B5 "OFFEN (2-stufig)")
- ce-Code-Ist, read-only kartiert im Klon `/home/comdare/Projekte/Modules/comdare-cacheengine-all/comdare-cache-engine` (Branch `main`, HEAD `c395743e`) — Anker unten repo-relativ. ACHTUNG Klon-Drift: KATALOG:14 nennt ce main==dev==`2b0a9bd8` als CI-belegte Linie; Zeilen-Anker sind vor Stufe 2 auf der Trigger-Linie zu re-verifizieren (Abschn. 6, OP-1).

---

## 0. Ist-Kartierung: der Steuerungspfad (read-only verifiziert)

Begriffs-Ehrlichkeit vorab: "B+-Baum" ist das historische Etikett; die Struktur ist ein ACHSEN-GESCHICHTETER PRAEFIXBAUM (`libs/cache_engine/builder/experiment_tree/experiment_tree.hpp:2-10`). Der Gate-Name bleibt "B+-Baum-Steuerungs-Nachweis" (Kanon-Treue), der Beweis prueft die Praefixbaum-Mechanik.

**Kette XML -> Baum -> Ausfuehrung (Organ-Familie):**
1. **XML-Quelle:** `comdare_thesis_profile`/Experiment-XML (Parser KF-1, `xml_config_parser`) + AxisRegistry = `permutation_axes.xml` (`profile_to_tree.hpp:27`).
2. **Adapter XML->Baum:** `build_axis_levels()` (`profile_to_tree.hpp:41`); Organ-Achsen-Guard `is_organ_composition_axis()` gegen die EINE Namens-Single-Source (`profile_to_tree.hpp:33-38`).
3. **Baum:** `ExperimentTree` (`experiment_tree.hpp:340`), statische Ebenen = Binaries, dynamische Ebenen = virtuelle Laufzeit-Schleifen (`experiment_tree.hpp:15-27`, `dynamic_filter()` `:363`).
4. **Lazy-Enumeration:** `StaticBinaryView` (`experiment_tree.hpp:236`), `operator[](i)` dekodiert mixed-radix genau EINEN Pfad (`:280`), `binary_count()` rein arithmetisch (`:374`).
5. **Pfad-Identitaet (Round-Trip-Garant):** EINE zentrale Pfad-Serialisierung, `kCompositionAxisNames` (17 Slots auf der inspizierten Linie) — Baum-Blatt-`binary_id` == CompositionRegistry-Key == perm_<id>-Benennung (`axis_path_serialization.hpp:2-13`, `:34-38`).
6. **Fenster/Selektion (sanktionierte Teilmengen-Operatoren):** `BuildSelection` mit Provenance, "kein stilles Truncaten" (`coverage_selection.hpp:25-31`; `select_full` verweigert statt zu kappen `:36-49`); GN-Zellen-Filter `COMDARE_GN_OPT/COMDARE_GN_SIMD` (`gn_cell_filter.hpp:22-27`); golden-Chunk-Fenster `COMDARE_GOLDEN_N_RANGE="start:count"` -> `golden_range_start/count` (`profile_run_facade.hpp:40-44`).
7. **Der EINE Treiber:** `run_lazy_static_then_dynamic()` (`cache_engine_builder_iterator.hpp:734/:740`) — statisch bauen (BuildOrchestrator), DLL laden, dynamisch variieren, messen, `ingest_result_line` zurueck in den sparse Baum (`cache_engine_builder_iterator.hpp:2-21`).

**System-/Mess-Familie:** `topics::AxisKind{organ, system_measurement, system_config}` (`libs/cache_engine/topics/axis.hpp:17-22`); system_config "beruehrt NIE die binary_id" (`axis.hpp:20`, Q2-Option-C). Der Planer-Walk `ExperimentPlanDirector` enumeriert opt x simd x Passes deterministisch, `PlanTextBuilder` = `--dump-plan` mit Contract "2 Laeufe byte-gleich" (`experiment_plan_director.hpp:3-30`; `profile_run_facade.hpp:155`).

**Par.-38-Dock-Naht (Planer-getriebene Fenster):** hinab `ExperimentSubtreePayload` (AxisKind-gefaerbte Achsen-Ranges, R5-Syntax, Byte-Roundtrip-Gate; `planner/experiment_dock_payload.hpp:5-16`, `:47-58`, emit `:129`/parse `:161`) — hinauf `ProgressDelta` (erste Meldung = Voll-Konfiguration, dann mixed-radix-minimale Deltas in StaticBinaryView-Ordnung, genau EIN `done` am Fensterende; `progress_delta.hpp:10-13`, `:36-45`; Iterator-Naht `cache_engine_builder_iterator.hpp:169`, `:806-819`, fenster-relativer Cursor `:1057`).

**Bestehende Test-Deckung (NICHT der Gate-Beweis):** `tests/unit/test_kf9_experiment_tree.cpp` (Baum-Mechanik), `test_d14c_e2e_pipeline.cpp:1-3` (O(K): 3 aus 1e9-View), `test_experiment_dock_payload.cpp`, `test_progress_delta.cpp`. Diese Tests halten die XML KONSTANT und arbeiten auf Fixtures — per Kanon "gruene Tests zementieren alte Ordnung" beweisen sie NICHT, dass die XML die einzige wirksame Quelle ist.

---

## 1. Gate-Definition E-07: Was heisst "der B+-Baum steuert" (messbar)

**Definition (normativ).** Der Experiment-B+-Baum STEUERT genau dann, wenn fuer JEDE der drei Achsen-Familien (organ / system_config / system_measurement) gilt:

- **S1 Vollstaendigkeit:** Jede in der XML freigegebene Achsen-Auspraegung erscheint als Baum-Ebene/-Wert, und exakt die vom Baum enumerierte Menge wird gebaut bzw. gemessen — nichts fehlt.
- **S2 Exklusivitaet:** Nichts ausserhalb des Pfades XML -> Baum bestimmt die Menge. Sanktionierte Fenster-Mechaniken (BuildSelection, GN-Zellen-Filter, golden_range, Par.-38-Ranges) sind reine TEILMENGEN-Operatoren auf der Baum-Ordnung — sie koennen die Menge nur verkleinern, nie Elemente hinzufuegen oder umdefinieren. Kein hartkodierter Bypass, keine zweite Achsen-Quelle.
- **S3 Kausalitaet:** Eine minimale XML-Aenderung erzeugt exakt die VORHERGESAGTE Aenderung der Output-Menge (Differenz-Probe); keine XML-Aenderung erzeugt Determinismus (byte-gleicher Plan, identische id-Menge).

**Messbare Kriterien (jedes mit literaler Ausgabe; kein Haken ohne woertliche Ausgabe):**

| K | Kriterium | Literale Gate-Zeile (Beispiel-Format) |
|---|---|---|
| K1 | Kardinalitaets-Identitaet: Baum-Zaehlung == Plan-Zaehlung == gebaute Artefakte (volles Mini-Fenster) | `E07_TREE_COUNT=<n>` == `E07_PLAN_PERMS=<n>` == `E07_BUILT_COUNT=<n>` |
| K2 | Pfad-Roundtrip: fuer ALLE i im Fenster `view[i].binary_id` == Artefakt-Name == CSV-`binary_id` (Single-Source `axis_path_serialization.hpp:34`) | `E07_ID_ROUNDTRIP_MISMATCH=0` |
| K3a | Organ-Differenz-Probe: EIN Achsen-Wert aus der XML entfernt (m -> m-1 Werte) => Count exakt n' = n*(m-1)/m UND 0 gebaute/gemessene ids mit dem entfernten Wert | `E07_ORGAN_DELTA_EXPECTED=<n'>` == `E07_ORGAN_DELTA_ACTUAL=<n'>`; `E07_REMOVED_VALUE_HITS=0` |
| K3b | System-Config-Differenz-Probe: EINE opt/simd-Zelle aus der XML entfernt => Plan-/Bau-Zellen sinken um die vorhergesagte Zahl, binary_id-Menge UNVERAENDERT (beweist Q2-Option-C: system_config beruehrt nie die binary_id, `axis.hpp:20`) | `E07_SYS_CELLS_BEFORE=<a>` / `E07_SYS_CELLS_AFTER=<b>` mit b==Vorhersage; `E07_BINARY_ID_SET_CHANGED=0` |
| K3c | Mess-Achsen-Differenz-Probe: EIN Mess-Modus/Pass aus der XML entfernt => Mess-Zeilen/Pass-Zahl sinkt vorhergesagt, binary_id-Menge unveraendert | `E07_MEASURE_PASSES_BEFORE/AFTER` mit Vorhersage-Match; `E07_BINARY_ID_SET_CHANGED=0` |
| K4 | Fenster-Treue: `COMDARE_GOLDEN_N_RANGE=start:count` baut exakt view[start .. start+count): erste/letzte id == `view[start]`/`view[start+count-1]`; ProgressDelta-Protokoll: erste Meldung Voll-Konfiguration, Cursor-Maximum == count-1, genau EIN `done` | `E07_WINDOW_FIRST_ID_MATCH=1`, `E07_WINDOW_LAST_ID_MATCH=1`, `E07_PROGRESS_CURSOR_MAX=<count-1>`, `E07_PROGRESS_DONE_COUNT=1` |
| K5 | Determinismus: `--dump-plan` zweimal byte-identisch (bestehender Contract, `experiment_plan_director.hpp`) UND Wiederholungslauf ohne XML-Aenderung liefert identische id-Menge | `E07_PLAN_BYTE_EQUAL=1`, `E07_RERUN_ID_SET_EQUAL=1` |

**Negativ-Proben (Pflichtteil der Definition — ohne sie ist kein Steuerungs-Claim zulaessig):**

- **N1 Bypass-Suche (statisch, Stufe 1):** Es existiert KEINE produktive Konstruktion von `BinarySpec`/`binary_id` ausserhalb `StaticBinaryView`/`axis_path_serialization.hpp`, und KEINE zweite Achsen-Namensliste neben `kCompositionAxisNames` (BR-1/BR-2/BR-4-Konvention, `axis_path_serialization.hpp:2-13`). Kriterium: vollstaendige Fundstellen-Liste, jede Fundstelle klassifiziert (Single-Source-Ableitung / Test / BEFUND). Die Liste ist aus dem Code-Walk abzuleiten, NIE handgepflegt. Literal: `E07_BYPASS_FINDINGS=0` (oder Befundliste). **Kritische Verdachts-Kandidaten (Pflicht-Pruefpunkte):** die Achsen, die die Komposition VERLASSEN haben — telemetry (INC-2c, H-10-Sidecar) und isa (INC-2d, `+target=`-Sidecar, `axis_path_serialization.hpp:26-31`): ihre Steuerung MUSS nachweislich weiter am XML/Baum-Pfad haengen (Sidecar-Inhalt aus Profil/Registry abgeleitet, nicht hartkodiert).
- **N2 Stale-Artefakt-Probe (dynamisch, Stufe 2):** Ein Artefakt eines aus der XML ENTFERNTEN Werts liegt physisch im dll_dir/Lager. Der Lauf darf es NICHT messen/ingestieren: 0 Mess-Zeilen mit der entfernten id; Resume/GN-Entscheidung darf es nicht wiederbeleben. Literal: `E07_STALE_ID_MEASURED=0`. (Wo Lager-Hydration aktiv ist, muss die entfernte id in der pruned-Menge auftauchen — Mengen-Gleichheit mit der Baum-Vorhersage, nicht bloss pruned>0; Abgrenzung zu B2 s. Abschn. 3.)
- **N3 Fenster-Teilmengen-Invariante:** Sanktionierte Fenster-Envs koennen die id-Menge nur VERKLEINERN: ids(Fenster) ist Teilmenge von ids(voll), 0 neue ids. Ein NICHT sanktioniertes Fantasie-Env aendert nichts (K5 haelt). Literal: `E07_WINDOW_SUBSET=1`, `E07_WINDOW_NEW_IDS=0`.

**Ungueltigkeits-Regel (Anti-Schein-Gruen, Analog "behalten=alles ist Befund"):** Eine Differenz-Probe, deren erwartetes Delta 0 ist (z. B. Achse mit nur 1 Wert gewaehlt), ist UNGUELTIG und zaehlt nicht als bestanden. Erwartete Werte werden ARITHMETISCH aus der XML-Differenz abgeleitet (Count-Formeln), nie aus Fixture-Strings uebernommen (Kanon: gruene Tests zementieren alte Ordnung).

**GO-Kriterium E-07:** K1-K5 UND N1-N3 saemtlich mit literalen Zeilen erfuellt, je Familie mindestens eine gueltige Differenz-Probe. Jede Abweichung = Befund mit ebenen-richtiger Nachbesserung (kein Weiterreichen).

---

## 2. Zweistufiger B5-Beweiszuschnitt (FAHRPLAN:18 "OFFEN (2-stufig)" eingeloest)

**Stufe B5.a — Wirksamkeits-/Kartierungs-Pruefung (ultracode, read-only, VORGELAGERT):**
Prueft, OB die Steuerung nach Lane A/C/F + ORG-18 ueberhaupt noch wirksam ist, BEVOR der Beweislauf gebaut wird (exakt der FAHRPLAN-Zuschnitt: "vorgelagert: ultracode-Pruefung, OB die Steuerung ... wirksam ist; erst danach Kriterium festlegen" — wobei DIESE Definition das Kriterium bereits normiert; Stufe 1 darf Kriterien nur schaerfen/parametrisieren, nicht abschwaechen).
Inhalt:
1. Anker-Kette datei:zeile fuer alle drei Familien auf der AKTUELLEN Trigger-Linie neu belegen (Klon-Drift-Aufloesung, s. OP-1): XML-Parser -> `build_axis_levels` -> Baum-Ebenen -> View -> Selektion/Fenster -> Treiber -> binary_id -> ingest.
2. **ORG-18-Wirksamkeits-Check (Kernfrage):** Ist die 18. Organ-Achse (persistence_target) in `kCompositionAxisNames`/`registry_to_axis_levels`/`profile_to_tree` angekommen? Auf der inspizierten Linie (`c395743e`) steht die Liste noch auf 17 Slots (`axis_path_serialization.hpp:34`) — auf der Trigger-Linie zu klaeren; Diskrepanz = Stufe-1-Befund, KEIN automatisches NO-GO (Zaehl-Fallen-Kanon beachten).
3. N1-Bypass-Suche vollstaendig fahren (inkl. Sidecar-Kandidaten telemetry/isa) + Abdeckungs-Matrix: jede Achse der drei Registries -> Baum-Ebene ODER dokumentierte Sub-Achse/Sidecar mit XML-Herkunfts-Beleg.
4. Verdikt je Familie: WIRKSAM / TEIL-WIRKSAM(Befunde) / UNWIRKSAM. Nur bei WIRKSAM/TEIL-WIRKSAM-mit-geraeumten-Befunden wird Stufe 2 freigegeben.
Ergebnis-Form: Audit-Dossier mit Anker-Tabelle + klassifizierter Fundstellen-Liste. Aufwand: 0,5-1 Agenten-Tag, read-only, golden-neutral, jederzeit parallelisierbar.

**Stufe B5.b — Beweislauf (lokal, golden-neutral):**
Kleiner Probe-Harness (opt-in, eigener out-/dll-Ordner, No-Op-Naehte leer => byte-/golden-neutral) um `profile_run_facade`/`run_lazy_static_then_dynamic` mit einem Mini-Profil (Produkt <= 8 Binaries):
1. Basis-Lauf: K1 + K2 + K5 (Plan-Doppellauf + Wiederholungslauf).
2. Drei Differenz-Proben K3a/K3b/K3c (je Familie eine XML-Kopie mit genau EINER Aenderung; erwartete Deltas arithmetisch vorberechnet und im Log VOR dem Lauf ausgegeben).
3. K4-Fenster-Probe (`COMDARE_GOLDEN_N_RANGE` + ProgressSink im Harness) + N3-Teilmengen-Check.
4. N2-Stale-Artefakt-Probe (Artefakt des entfernten Werts vorab ins dll_dir legen).
Alle `E07_*`-Zeilen werden woertlich ins Beweis-Protokoll uebernommen (Session-Doc), Rohlogs additiv gesichert. Aufwand: 0,5-1 Tag Bau + < 1 h Laufzeit; Re-Run auf spaeterer Linie < 1 h.

---

## 3. Abgrenzung zu B1-B4 (FAHRPLAN:12-17)

| Beweis | beweist | B5-Abgrenzung |
|---|---|---|
| B1 Resume-Skip (`GN_DECISION=skip`) | WIEDERAUFNAHME-Oekonomie: Gebautes wird uebersprungen | B5-N2 prueft die GEGENRICHTUNG: Nicht-mehr-Konfiguriertes darf NICHT wiederbelebt werden. B1 haelt die XML konstant; B5 variiert sie. |
| B2 Hydration (`verified>0` UND `pruned>0`) | LAGER-MECHANIK: das Zaehlwerk der Hydration funktioniert | B5-N2 beweist die ENTSCHEIDUNGSQUELLE: die pruned-/verified-MENGE ist exakt die Baum-Vorhersage (Mengen-Gleichheit statt >0-Existenz). B5 darf B2-Maschinerie als Vehikel nutzen, hat aber ein eigenes Kriterium. |
| B3 Variant-Gate-E2E (`COMDARE_VARIANT_GATE=true`) | ZULASSUNGS-Gate je Variante (.variant-Sidecar; NICHT std::variant — Verwechslungs-Warnung KATALOG:85) | B5 beweist die MENGEN-BILDUNG davor: welche Varianten ueberhaupt zur Zulassung anstehen, bestimmt der Baum. |
| B4 Bestandslog-E2E (2 Prozesse, Sektion<Budget) | PROTOKOLL/NEBENLAEUFIGKEIT der Bestandsfuehrung | Kein Steuerungs-Claim; disjunkt. |
| **B5 (E-07)** | **QUELLEN-AUTORITAET: XML->Baum ist die einzige wirksame Konfigurationsquelle aller drei Achsen-Familien** | Einziger Beweis mit der XML als UNABHAENGIGER VARIABLE (Differenz-Proben S3); B1-B4 sind Mechanik-Beweise bei konstanter XML. |

---

## 4. Aufwand und Einordnung in die Gate-Kette

**Position (V7.4, LEDGER:98):** nach W-13, als "+1" der 4+1 lokalen Beweise, VOR G6/J-Kette, VOR dem Voll-Bau-4-Trigger. E-07/B5 ist damit trigger-blockierend im A3-Paket (KATALOG:19).

**Sequenz-Empfehlung:**
- **Stufe B5.a SOFORT startbar** (read-only; unabhaengig von A13-Stempel-Fenster und E-24-ABI-Fenster; liefert frueh Befunde, die A13/E-24 sonst verdecken).
- **Stufe B5.b NACH A13-M3 + E-24** (letzter Stempel-/ABI-Schnitt): der Beweis soll die TRIGGER-Linie beweisen, nicht eine Vor-Linie — sonst Wiederholungspflicht. Falls A13/E-24 sich verzoegern: einmal vorlaufen (Frueherkennung) + billiger Pflicht-Re-Run auf der eingefrorenen Trigger-Linie (Harness steht dann). Dieser Sequenz-Punkt ist ein Manager-Entscheid (analog SYNTHESE Widerspruch Nr. 7 zur E-24-Sequenz).

**Aufwand gesamt:** ~1,5-2 Agenten-Tage (B5.a 0,5-1 read-only + B5.b 0,5-1 Bau, Laufzeit < 1 h, Re-Run < 1 h). Golden-neutral in beiden Stufen (opt-in Harness, eigene Ordner, No-Op-Naehte). Kein ABI-Touch, kein golden-Touch, kein CI-Pflicht-Anteil (lokaler Beweis wie B1-B4; CI-Wiederholung optional nach Trigger).

---

## 5. Verankerungs-Vorschlag (nur Definition, kein Bau)

- Ledger-Nachtrag: E-07 = DEFINIERT per diesem Dossier; Task #54 (LEDGER:2654/:3021) wird durch B5.a eingeloest, B5.b terminalisiert ihn.
- FAHRPLAN-Zeile 18: "Gate-Definition FEHLT" -> Verweis auf dieses Dossier; Kriterium = K1-K5 + N1-N3, GO-Regel Abschn. 1.
- Beweis-Protokolle beider Stufen als neue Session-Docs (Doku-Policy), Rohlogs additiv.

---

## 6. Offene Punkte (OP)

- **OP-1 Klon-Drift:** Anker verifiziert auf Modules-Klon `main@c395743e`; KATALOG-Linie ce `2b0a9bd8` (main==dev) ist dort nicht sichtbar. Stufe B5.a MUSS zuerst die kanonische Linie klaeren (`git ls-remote`, 4-Klone-Regel) und alle Zeilen-Anker dort neu belegen.
- **OP-2 ORG-18:** `kCompositionAxisNames` traegt auf der inspizierten Linie 17 Slots; die 18. Organ-Achse (persistence_target, ORG-18/O-8) ist dort nicht in der Kompositions-Liste. Kernfrage der Stufe B5.a — Befund, nicht Vorverurteilung.
- **OP-3 Payload-Naht:** `ExperimentSubtreePayload` hat ausser dem Unit-Test keinen Produktions-Konsumenten (emit/parse-Ebene). K4 prueft daher die REAL verdrahteten Fenster-Mechaniken (golden_range/GN-Zellen) + ProgressDelta via Harness-Sink; sobald die Par.-38-Payload produktiv verdrahtet ist, ist K4 um eine Payload-Range-Probe zu ergaenzen (ehrlich ausweisen, nicht vorwegnehmen).
- **OP-4 K3c-Abhaengigkeit:** Die Mess-Achsen-Differenz-Probe haengt an der E.0/KERN-Mess-Schema-Naht (SYNTHESE Nr. 9: K4-Naht nicht angeschlossen). Bis E.0 landet, wird K3c auf die vorhandene Mess-Modi-/Pass-Mechanik zugeschnitten und nach E.0 wiederholt.
- **OP-5 Sequenz-Entscheid B5.b** vor/nach A13-M3+E-24 (Empfehlung: danach; Manager-Entscheid, Vorlage 2).


---

## ANHANG (aus Backup-JSON): entscheidungs_vorlagen

- NUR-KENNTNIS (kein Arbeitsauftrag, keine GO-Anfrage) — E-07-Gate-Definition liegt vor (02.08.2026): Der Beweis B5 'B+-Baum-Steuerungs-Nachweis' hat jetzt eine praezise, messbare Gate-Definition. Kern: 'Der B+-Baum steuert' heisst (S1) Vollstaendigkeit — jede XML-freigegebene Auspraegung erscheint im Baum und exakt die Baum-Menge wird gebaut/gemessen; (S2) Exklusivitaet — Fenster-Mechaniken (BuildSelection, GN-Zellen, golden_range, Par.-38-Ranges) sind reine Teilmengen-Operatoren, kein Bypass, keine zweite Achsen-Quelle; (S3) Kausalitaet — eine minimale XML-Aenderung erzeugt exakt die vorhergesagte Output-Aenderung, keine Aenderung erzeugt Byte-Determinismus. Messkriterien mit literalen Gate-Zeilen: K1 Kardinalitaets-Identitaet (TREE==PLAN==BUILT), K2 binary_id-Roundtrip (Mismatch=0), K3a/b/c je EINE XML-Differenz-Probe pro Achsen-Familie (Organ: Count-Formel + 0 Treffer des entfernten Werts; System-Config: Zellen-Delta bei UNVERAENDERTER binary_id-Menge = Q2-Option-C-Beleg; Mess: Pass-Delta bei unveraenderter id-Menge), K4 Fenster-Treue (Range baut exakt view[start..start+count), ProgressDelta: Voll-Konfig zuerst, Cursor-Max, genau EIN done), K5 Determinismus (--dump-plan 2x byte-gleich, Re-Run identische id-Menge). Negativ-Proben Pflicht: N1 statische Bypass-Suche (inkl. Sidecar-Kandidaten telemetry/isa), N2 Stale-Artefakt darf nicht wiederbelebt werden (0 Mess-Zeilen der entfernten id), N3 Fenster koennen nur verkleinern (0 neue ids). Proben mit erwartetem Delta 0 sind UNGUELTIG (Anti-Schein-Gruen); erwartete Werte arithmetisch aus der XML-Differenz, nie aus Fixtures. B5 bleibt ZWEISTUFIG wie im Fahrplan: Stufe a = read-only-Wirksamkeits-Audit (ultracode; prueft u. a., ob die 18. Organ-Achse/ORG-18 in der Kompositions-Single-Source der Trigger-Linie angekommen ist — im inspizierten Klon stehen noch 17 Slots) und darf sofort laufen; Stufe b = lokaler Beweislauf (Mini-Profil <=8 Binaries, golden-neutral, ~1 Tag Bau, <1 h Laufzeit), empfohlen NACH A13-M3+E-24 auf der eingefrorenen Trigger-Linie. Abgrenzung: B1-B4 beweisen Mechanik bei konstanter XML (Resume, Hydration-Zaehlwerk, Variant-Zulassung, Bestandslog); B5 ist der einzige Beweis mit der XML als unabhaengiger Variable und belegt die Quellen-Autoritaet des Baums fuer alle drei Achsen-Familien. Einordnung: '+1' der 4+1 lokalen Beweise (V7.4), vor G6/J-Kette, trigger-blockierend im A3-Paket. Vollstaendiges Dossier mit datei:zeile-Ankern liegt beim Manager.
- MANAGER-ENTSCHEIDUNGSVORLAGE E07-Q1 (verbose per E-21) — Sequenz der B5-Stufe b: KONTEXT: Der E-07-Beweislauf (Stufe b) beweist die Steuerung auf einer konkreten ce-Linie; A13-M3 (Stempel-Neuanker) und E-24 (letzter ABI-Schritt) aendern die Linie danach nicht mehr. OPTIONEN: (A) Stufe b NACH A13-M3+E-24 auf der eingefrorenen Trigger-Linie fahren — ein Lauf, beweist exakt die Trigger-Linie, kein Re-Run noetig; (B) Stufe b SOFORT nach Stufe a vorlaufen lassen (Frueherkennung von Steuerungs-Regressionen) + billiger Pflicht-Re-Run (<1 h, Harness steht) auf der Trigger-Linie. EMPFEHLUNG: A, solange A13/E-24 planmaessig vor dem Beweis-Fenster liegen; B nur bei Verzoegerung von A13/E-24 um mehr als das Beweis-Fenster. DEFAULT (wenn keine Antwort): A. Stufe a (read-only-Audit) ist von diesem Entscheid unabhaengig und sofort startbar.

## ANHANG (aus Backup-JSON): offene_punkte

- OP-1 Klon-Drift: Code-Anker wurden auf dem Modules-Klon /home/comdare/Projekte/Modules/comdare-cacheengine-all/comdare-cache-engine (main@c395743e) verifiziert; die KATALOG-Linie ce main==dev==2b0a9bd8 ist dort nicht sichtbar. Stufe B5.a muss zuerst die kanonische Linie klaeren (git ls-remote, 4-Klone-Regel) und alle Zeilen-Anker dort neu belegen.
- OP-2 ORG-18-Wirksamkeit: kCompositionAxisNames (axis_path_serialization.hpp:34) traegt auf der inspizierten Linie 17 Slots — die 18. Organ-Achse persistence_target (ORG-18/O-8) ist dort nicht in der Kompositions-Single-Source. Kernfrage der Stufe B5.a; als Befund behandeln, nicht als Vorverurteilung der neueren Linie.
- OP-3 Par.-38-Payload-Naht: ExperimentSubtreePayload hat ausser test_experiment_dock_payload keinen Produktions-Konsumenten (emit/parse-Ebene). K4 prueft daher die real verdrahteten Fenster-Mechaniken (COMDARE_GOLDEN_N_RANGE, GN-Zellen) + ProgressDelta via Harness-Sink; nach Produktiv-Verdrahtung der Payload ist K4 um eine Payload-Range-Probe zu ergaenzen.
- OP-4 K3c-Abhaengigkeit: Die Mess-Achsen-Differenz-Probe haengt an der E.0/KERN-Mess-Schema-Naht (SYNTHESE Nr. 9: K4-Naht nicht angeschlossen, Director-Kreuzprodukt). Bis E.0 landet: K3c auf die vorhandene Mess-Modi-/Pass-Mechanik zuschneiden und nach E.0 wiederholen.
- OP-5 Sequenz-Entscheid B5.b vor/nach A13-M3+E-24 (Manager-Entscheid, Vorlage E07-Q1; Empfehlung/Default: danach).
- OP-6 Sidecar-Kandidaten: telemetry (H-10-Sidecar, INC-2c) und isa (+target=-Sidecar, INC-2d) haben die binary_id-Komposition verlassen — Stufe B5.a muss ihre XML/Baum-Herkunft explizit belegen (prominenteste Bypass-Verdachtsklasse).
- OP-7 Verankerung: Ledger-Nachtrag (E-07=DEFINIERT, Task #54 -> B5.a/B5.b) und FAHRPLAN:18-Verweis stehen aus — bewusst nicht ausgefuehrt (Auftrag read-only, kein Commit).
