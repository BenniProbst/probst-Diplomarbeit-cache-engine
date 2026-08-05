# PLAN W5-KERN + W3-KERN (05.08.2026) -- status-Subkommando + Mess-Interface-Testate

Basis: ce dev==main==60c7c56a (Gate 405). Ort: /home/comdare/wt-e24, Branch `w5-w3-kern` NEU ab 60c7c56a.
Owner-Entscheide (Ledger mittag-6, VERBATIM persistiert): R5/W5 = status-Subkommando + on-demand +
Bestandslog-XML als Aggregat-Quelle (alle drei JA) · R3/W3 = GO fuer Post-Compile-Testate der
Mess-Interfaces am Dock nach S5-Familien-Muster; Deep-Research-Vollausbau/per-Binary-Vollbeleg/
GTest-Harness-Umbau = strukturierte NACH-Abgabe-Strecke (Owner-Schnitt, SCOPE-GRENZE).
Dauer-Auflage (nachmittag-2): FINGERPRINT-NEUTRALITAET je Commit (abi/ 0 Zeilen, kFrozenFingerprintV1
0fe275bd... in 3 TUs, golden-CRC 0xF1C1F26A1232073B, golden-320 3/3, Roundtrip); golden/XML byte-stabil;
CT-Doktrin; ASCII; cf22 echtes Binary mit Datei-Argumenten; 3-Marker 0; Wortgrenzen-Orakel;
cppcheck-Adjazenz-Falle (KEINE neue Makro-Nutzung in String-Literal-Adjazenz -- lint:static prueft
OHNE CMake-Defines, nachmittag-5-Fallen-Kanon); ctest-N lebendes Gate, je Commit frisches Configure.
Posten 92 / R-G2 (Registry-Kanon-Divergenz validate=2er vs plan=3er): NICHT ANFASSEN (deklarierter
Folge-Posten; W5 liest nur, vereinheitlicht nichts).

Vorlauf-Belege (alle gelesen):
- Ledger grep '05.08.2026' vollstaendig, bes. mittag-4/-6/-7, nachmittag-2/-5, Posten-92-Deklaration (:4102).
- super docs/sessions/backups/20260805-einlese-plan-korpus/synthese.md (W5/W3-SOLL Teil 2) +
  f7-rueck-leser-feedback.md (Quellen-Katalog, Parser-Gesetz) + f5-pruefstand-tests.md (Ist-Deckung 3.3/3.4,
  Delta 4) + 20260805-ressourcen-freigabe-explore/rufkette.md (Takt-Kette, W5-Relevanz Abschn. 4).
- IST am Objekt wt-e24 (Fundstellen unten je Abschnitt).

---

## (a) W5-DESIGN -- `status`-Subkommando in comdare-experiment-planner

### a.1 Andockpunkt und Grammatik

Andockpunkt IST: apps/experiment_planner/main.cpp:352-354 -- der Bauer hat den W5-ANDOCKPUNKT als
Reservierungs-Kommentar im flachen Dispatcher hinterlassen ("haengt sich hier additiv als weiterer
if-Zweig ein"). Genau so bauen: EIN zusaetzlicher `if (a1 == "status")`-Zweig + `help_for("status")` +
eine Zeile in der Uebersicht + Exit-Code-Legende unveraendert.

Grammatik (clig.dev, konsistent zur bestehenden Flag-Form `--comdare-root=DIR` des Treibers):

    comdare-experiment-planner status [<profil>] [--root=<dir>]

- `<profil>`: dieselbe Aufloesung wie ueberall (Argument > COMDARE_THESIS_PROFILE > einkompiliertes
  Default-Profil; resolve_profile unveraendert wiederverwendet). Das Profil liefert das SOLL
  (geplante Combos/Zellen/Fenster) ueber den bestehenden Director-Walk.
- `--root=<dir>`: Wurzel des Mess-Ausgabe-Baums. Default = `Code/measure_out` (das ist der von der
  EIGENEN Emission kanonisierte Pfad, experiment_plan_director.hpp:1331/1342/1406:
  `$CI_PROJECT_DIR/Code/measure_out/<slug>/perm<idx>`), Fallback-Probe `measure_out` (Bare-Metal-Lauf
  aus Code/ heraus). Der aufgeloeste Root wird IMMER in der Kopfzeile ausgegeben -- kein stilles Raten.
- KEIN watch/follow (on-demand, Owner-R5; ein residenter Daemon ist nirgends spezifiziert, f7-Lens 8).
- Exit: 0 = Bericht erstellt (auch wenn Quellen fehlen -- fehlende Quelle ist ein BERICHTS-Inhalt,
  kein Fehler); 1 = Usage; 2 = Konfig-Fehler (kaputtes Profil/Root-Argument). Kein Exit 6: status
  bindet KEINEN planer_block (rein lesend, keine CEB-Compile-Strecke).

Antwort auf Vorlauf-Frage (4), welche Pfade die Binary kennt: Profil (arg/Env/Default),
COMDARE_GOLDEN_N_RANGE, COMDARE_BESTANDSLOG + _DOC_KEY/_OWNER_UUID/_MASCHINE + ArtifactCache::from_env
(minio-Env), COMDARE_BUILD_PARALLEL. Einen measure_out-Root kennt sie NICHT -> `--root` ist die eine
neue, deklarierte Zutat (Flag statt neuer Env-Variable; Default = Emissions-Kanon).

### a.2 Quellen und Leser-WIEDERVERWENDUNG (keine Format-Duplikate)

Vier Quellen (Owner-R5: Bestandslog-XML = Aggregat-Quelle; Rest = Datei-Detail):

1. **progress.cursor** (Fenster-relativer Perm-Cursor, Regression R-G4/5 "konsumentenlos" wird hier
   auf der LESE-Seite geschlossen). Schreiber-IST: super Code/02_messung_driver/main.cpp:1155-1195 --
   Zeilenformen exakt:
   `[progress] perm=<N> axes_changed=<K> <axis>-><variant> ...` und
   `[progress] done perm=<N> window-complete` (done GENAU EINMAL am Fensterende = kuenftiges
   Fertig-Signal der 38.b-Sequenz), Datei additiv unter `<output_dir>/progress.cursor`, wobei
   output_dir = `<root>/<slug>/perm<idx>`. Es existiert KEIN Leser (Vollgrep-Befund f7-Lens 5) ->
   W5 schreibt den ERSTEN und EINZIGEN Parser: `progress_cursor_reader.hpp` (neu, planner/-Welt).
   Ergebnis-POD `CursorStand { last_perm, done_seen, zeilen_gesamt }`. Format-Kopplung ce-Leser vs
   super-Schreiber ist cross-repo -> im Leser-Header als deklarierte Kopplung mit Fundstelle
   dokumentieren + TU pinnt beide Literal-Formen (Risiko R1 unten).
2. **per-Binary result.csv / result.csv.stamp / result.csv.stale** (Mess-Resume-Stand). Format-IST:
   cache_engine_builder_iterator.hpp:871-977 -- Stamp = `lazy_resume_stamp_prefix(...) + "|rows=<N>"`,
   Header-Identitaet gegen `lazy_csv_header()`, .stale = gesicherter Alt-Stand ohne Resume-Anspruch
   (:1699-1703). Lage: `<permdir>/e4_xml/dll/<stem>/result.csv` (bin_dir = b.output.parent_path(),
   :1868; e4_dir = output_dir/"e4_xml", super main.cpp:993). WIEDERVERWENDUNG: `lazy_csv_header()`
   direkt aufrufen (Header-Vergleich); das rows-Schluessel-Literal `"|rows="` wird als EINE benannte
   Konstante `kLazyResumeRowsKey` im Iterator-Header gehoben und von lazy_try_resume_binary UND dem
   Status-Leser benutzt (string-identische Umformung, golden-/emissions-neutral -- KEIN Duplikat des
   Format-Wissens). Der Status-Leser prueft NICHT den Config-Prefix (er kennt die Lauf-Config nicht
   und erfindet keine): er berichtet ehrlich `gemessen` = csv+stamp vorhanden UND Header identisch
   UND Datenzeilen == rows-Wert aus dem Stamp-Schwanz; `stale` = .stale vorhanden; alles andere =
   `offen`/`teilweise` mit Grund.
3. **Bestandslog-XML** (Aggregat-Quelle, Owner-R5): WIEDERVERWENDUNG komplett bestehend --
   `ArtifactCache::from_env().with_object_budget(1, 10)` (dasselbe Budget-Muster wie
   make_planer_block_gate, main.cpp:86-87: unerreichbarer Store haelt kein on-demand-Kommando
   minutenlang auf) + `make_bestand_transport(...).fetch(doc_key)` (artifact_cache_transport.hpp:37-39)
   + `parse_bestandslog(xml)` (bestandslog_document.hpp:417; syntax v4, document_syntax_supported-Gate).
   Gate identisch zum planer_block-Gate NUR LESEND: COMDARE_BESTANDSLOG!=true oder kein minio ->
   `[status] quelle=bestandslog keine Daten (COMDARE_BESTANDSLOG nicht aktiv / Ebene B fehlt)` --
   kein Abbruch, kein Binden, KEINE Reservierung (planer_block wird NICHT angelegt; der fehlende
   planer_block-Reaper [f7-Lens 7] wird dadurch NICHT akut -- deklarierter Nach-Abgabe-Posten).
   Berichtet: doc_revision, Bestand-Eintraege je Genus (binary/measurement), Reservierungen nach
   status offen/done/released, ETA-Felder (leer = "noch nicht geschaetzt" -- ehrlich benennen,
   Sentinel-Doktrin kMarkerUnbelegt).
4. **.fingerprint-Sidecars** (A2-Welt: gebaute Binaries): WIEDERVERWENDUNG
   `read_fingerprint_sidecar(output)` (fingerprint_sidecar.hpp:101-114 -- DIE EINE Lese-Wahrheit,
   Eichung GATE 5). `gebaut` je Zelle = Anzahl `<stem>/perm_*.{so,dll}.fingerprint` mit GUELTIGEM
   Inhalt (nullopt = zaehlt als nicht-gebaut, FAIL-CLOSED-Lesart der Eichung); zusaetzlich
   `sidecar_ungueltig`-Zaehler, damit kaputte Sidecars sichtbar werden statt zu verschwinden.

SOLL-Seite (geplant): `PlanSizeBuilder` (experiment_plan_director.hpp:316-325, ConcreteBuilder der
NUR zaehlt) + `measurement_combos_of` ueber die bestehende Fassade -- der Walk ist deterministisch,
zwei Laeufe byte-gleich; KEIN neuer Walk, KEINE Registry-Kanon-Beruehrung (R-G2 tabu; status nutzt
denselben 3er-Resolve-Pfad wie plan, rein lesend).

Bauort der Substanz: NEUER Header `libs/cache_engine/profile_facade/planner/planner_status_reader.hpp`
(+ ggf. `progress_cursor_reader.hpp` als eigener kleiner Header daneben) -- exakt die W1-Blaupause
(planner_cli_env.hpp-Hoist): Fassaden-Welt, von der App inkludiert, testbar ohne Binary. Der
main.cpp-Zweig bleibt duenner Host (Argument-Parsing + Aufruf + Mantel, Muster run_*_guarded noexcept).
abi_adapter/PODs/Wire werden NICHT beruehrt (W5 = App-/Fassaden-Flaeche, nur LESEN).

### a.3 Ausgabe-Format (kompakte Zell-/Fenster-Bilanz)

Parser-Gesetz uebernommen (LEDGER:3652 / slice_marker.hpp:6-16): Aggregat-Schluessel = TUPEL
(zelle, fenster), NIE Zeilen-Reihenfolge; Layer-Trennung ceb= eigenes Feld, zelle=[d,e,f][g,h,i];
Pflichtfelder entfallen nie, unbelegt = Sentinel "unbelegt". Ausgabe nach stdout (clig.dev: der
Bericht IST die Daten), Diagnose nach stderr. Format:

    [status] planer=<planner_version_stamp> profil=<pfad> root=<aufgeloester-root>
    [status-zelle] ceb=[a,b,c] zelle=[d,e,f][g,h,i] fenster=START:COUNT geplant=N gebaut=B gemessen=M stale=S sidecar_ungueltig=U offen=O
    [status-cursor] ceb=[a,b,c] perm=<idx> letzte_perm=P done=ja|nein zeilen=Z
    [status-bestand] genus=binary|measurement doc_revision=R eintraege=N res_offen=x res_done=y res_released=z
    [status-gesamt] geplant=N gebaut=B gemessen=M stale=S offen=O
    [status] quelle=<name> keine Daten (<grund>)          # je fehlender Quelle GENAU EINE ehrliche Zeile

offen = geplant - gemessen (Bau-Ebene getrennt sichtbar via gebaut). Nichts wird erfunden: jede
Zahl kommt aus genau einer Quelle, jede fehlende Quelle wird benannt (E-04-Ur-Anforderung "wie viele
Rekombinationen noch offen" wird aus fs-Zaehlung + Plan-SOLL beantwortet, nicht aus Heuristik).

### a.4 Takt-Ausbau-Andockpunkte (W5 = VORSTUFE der F6-Planer-Takt-Hoheit)

Design-Leitplanke aus rufkette.md Abschn. 4: die Lese-Pfade SIND die kuenftigen Takt-Kanaele.
Struktur-Schnitt dafuer (alles jetzt schon so bauen, Ausbau rein additiv NACH Abgabe):
1. `progress_cursor_reader` liefert `CursorStand.done_seen` -- exakt das 38.b-Fertig-Signal
   ("naechste CEB erst nach Abschluss der vorigen", LEDGER:2376). Der kuenftige Takt-Loop
   konsumiert DENSELBEN Reader; heute konsumiert ihn nur der Renderer.
2. Aggregat-Struktur `ZellStand` keyed (zelle, fenster) -- dieselbe Schluessel-Welt, auf der der
   Takt-Scheduler spaeter Zellen zuteilt (Marker-v2-Gesetz, kein zweites Keying).
3. Bestandslog-Reservierungs-Sicht (offen/done/ETA) als EIGENE Funktion -- der Ressourcen-
   Freigabe-Input des Takts (36/37-Korpus); Takt haengt sich an die Funktion, nicht an den Renderer.
4. Strikte Schichtung Leser-je-Quelle -> Aggregator -> Renderer: der Takt ersetzt NUR den Renderer
   durch eine Steuer-Schleife. resource_group bleibt Ist-Traeger (Owner-R6), status STEUERT NICHTS.

### a.5 TU + Rauchtest

- TU `test_w5_status_reader.cpp`: Tempdir-Fixtures, die mit den ECHTEN Schreib-Formen erzeugt
  werden (Stamp via lazy_resume_stamp_prefix + kLazyResumeRowsKey; Header via lazy_csv_header();
  Cursor-Zeilen literal in beiden Schreiber-Formen; Bestandslog via emit_document->parse-Roundtrip;
  Sidecar 128-hex + kaputte Varianten). Faelle: voll/teilweise/stale/leer ("keine Daten"),
  rows-Mismatch, Header-Drift, ungueltiger Sidecar. KEIN Netz (Bestandslog nur aus lokalem String).
- Rauchtest LITERAL am gebauten Binary je Gate (Auflage): `comdare-experiment-planner status
  --root=<fixture-dir> <fixture-profil>` -> Ausgabe literal zitieren; plus leerer Root ->
  `keine Daten`-Zeilen + Exit 0 literal; plus `status --help`.

---

## (b) W3 -- Post-Compile-Testate der Mess-Interfaces am Pruef-Dock (F5-Schnitt, Owner-GO R3)

### b.1 Loader-Pfad und Traeger-DLL

dlopen-Pfad wie am Dock: `AnatomyModuleLoader::load` -> `IAnatomyBase*` -> `dynamic_cast` je
Sub-Interface (ABI-Grenze = gattungs-eigenes Antriebs-Sub-Interface + POD, LEDGER:1749). Reihenfolge
bindend eingehalten: import -> GATE (run_conformance_gate) -> erst dann Testate (conformance_gate.hpp:8).
Traeger = BESTEHENDE SHARED-Targets, KEIN neuer DLL-Bau:
- `anatomy_codegen_pilot_wormhole_shared` (echte codegen-Komposition = DIE reale metaprogrammierte
  Kette; Wiring-Muster COMDARE_R5E_PILOT_DLL, tests/unit/CMakeLists.txt:682) und
- `perm_adhoc_buildvariant` (zweiter, andersartiger Vertreter; Muster test_d13, CMakeLists.txt:3809
  `$<TARGET_FILE:...>` als Test-Argument).
Beide sind im Test-Baum MEASUREMENT-ON (Root-CMakeLists.txt:141 add_compile_definitions
COMDARE_MEASUREMENT_ON=1) -> alle messungs-gated Interfaces (abi_adapter.hpp:238-245) sind da;
ein nullptr-dynamic_cast ist im W3-Testat ein FEHLER, kein Skip.

### b.2 Luecken-Liste je Interface (IST-Deckung am GELADENEN Modul verifiziert; Doppelung vermieden)

| Interface (abi_adapter:229-251) | SCHON getestet (geladenes Modul) | LUECKE -> W3-Testat |
|---|---|---|
| IObservableTier (tier_observe-POD-Pull) | test_d13_dll_runtime_measure (Antrieb+observe, adhoc-DLL); test_v41_anatomy_f15_measurement (Snapshot-Pull) | Schema-getriebene Feld-Wache: NUR ueber kV3AxisSchema iterieren (observable_tier.hpp:65-113, nichts hartkodieren); Anti-Leerlauf Vorher/Nachher-Snapshot (Zaehler bewegen sich REAL nach K Ops); tier_reset_statistics-Semantik am geladenen Modul (test_216h2 ist nur suite-seitig) |
| IMeasurableWorkload V1 (run_workload) | f15 Stufe B am geladenen Modul (:196-219) | KEIN eigenes Neu-Testat (Doppelung vermeiden); nur Quer-Konsistenz V1-Rueckgabe > 0 im Ketten-Lauf |
| IMeasurableWorkloadV2 (run_workload_segmented, 4 Achsen) | NUR suite-seitig (test_segment_timer_differentiation u.a.) | Testat am geladenen Modul: batches_measured > 0, Segment-ns der getriebenen Achsen > 0 |
| IMeasurableWorkloadV3 (run_workload_segmented_v2, ALLE 17) | NUR suite-seitig (test_all19_segment_timer, test_seg_coverage) | KERN-Testat: erforschte Invariante EXAKT am geladenen Modul -- `Sum(seg_ns) + seg_framework_ns == seg_run_total_ns` (Identitaet aus test_seg_coverage.cpp:88, LEDGER:855; Invariante UEBERNEHMEN, nicht neu erfinden) |
| IRollbackableTier (memento_all) | NUR suite-seitig (test_cow_memento, test_v5_memento_axis) | save -> mutierende Ops -> rollback -> Zustands-Gleichheit via IDriveableTier-Lookups gegen mitgefuehrtes Oracle; Gegenprobe: OHNE rollback differiert der Zustand (nicht-vakuoser Vergleich) |
| IMigratableTier (tier_migrate_step) | NUR suite-seitig (test_migration_two_tier) | Testat am geladenen Modul: tier_moves REAL > 0 (P4-#123-Doktrin) + funktionale Aequivalenz der Lookups nach Migration |
| IResourceControllableTier (RC-POD) | test_d13 (thread_count-Sweep ueber RC am adhoc-Modul) | Restfelder-Konsum (prefetch/pool_budget/batch/inline_threshold): angewandte Einstellung ist im Snapshot/Verhalten sichtbar; POD-Roundtrip; Anti-Leerlauf |
| IAllocatorProxyTier (immer, non-dagger) | probe_allocator_proxy existiert NUR als REPORT-Probe ohne Assertion (conformance_gate.hpp:42-60); test_ap15_2 suite-seitig | Testat: interface_present + identity_present ASSERTIERT; unter Last bewegen sich die stats_route-Zaehler (Anti-Leerlauf) -- Probe-Funktion WIEDERVERWENDEN, nicht duplizieren |

(IScannableTier/IDriveableTier: durch RF1-RF14 + Ordnungs-Ops des bestehenden Gates am geladenen
Modul gedeckt -- ausserhalb des Owner-Schnitts, kein Neu-Testat.)

### b.3 Neue TU-Struktur (S5-Familien-Muster + Einzigquellen-Kopplung)

1. NEUER additiver Header `libs/cache_engine/builder/pruef_dock/mess_interface_testate.hpp` --
   SIBLING von conformance_gate.hpp (das selbst TABU-additiv bleibt, LEDGER:1265: byte-unberuehrt).
   Je Interface EINE noexcept-Pruef-Funktion im Gate-Stil (Quoten-Ergebnis wie ConformanceResult,
   optionaler FILE*-Report), Eingang = Interface-Referenzen. DAMIT ist die Nach-Abgabe-Integration
   in den CEB-Pruefstand-Batch rein additiv (dieselben Funktionen, gerufen aus measure()/pruef_only)
   -- der W3-Kern legt die Substanz, der Harness-Umbau bleibt Nach-Abgabe (Owner-Schnitt).
2. TU `test_w3_mess_interface_testate_dock.cpp` (Flaechen-TU, messungs-gated Sektion der
   tests/unit/CMakeLists nach Muster :2177 COMDARE_MEASUREMENT_ON=1 usw.): laedt BEIDE Traeger-DLLs,
   faehrt import -> GATE -> alle b.2-Testate. Einzigquellen-Kopplung (S5-05q-Lehre "gruene Tests
   zementieren alte Ordnung"): (i) compile-harter Basen-Pin -- static_assert
   `std::is_base_of_v<Interface, SearchAlgorithmAbiAdapter<RealeKomposition>>` fuer JEDES Interface
   der Liste (die TU-Liste kann nicht stiller von abi_adapter:229-251 abweichen); (ii) am geladenen
   Modul dynamic_cast != nullptr fuer dieselbe Liste (beide Welten gegeneinander gepinnt);
   (iii) Anti-Leerlauf-Pin: jede Quote cases_total > 0 (leere Population macht jede Aussage wahr).
3. TU `test_w3_mess_interface_testate_biss.cpp` (suite-seitig, beidseitiger Biss nach dem
   test_conformance_gate-Muster "6 Broken-Huellen fangen"): je Testat-Funktion mindestens EIN
   Broken-Fake (falsche Segment-Summe; rollback als No-Op; tier_moves==0; Observer-Zaehler
   eingefroren; AllocatorProxy ohne stats-Route) -> die Funktion MUSS rot beissen. Der Biss ist
   billig, weil die Funktionen Interface-Referenzen nehmen (kein DLL-Bau fuer Fakes).
Anti-Leerlauf-Design durchgaengig: Vorher/Nachher-Deltas ueber ECHTE getriebene Ops (Treiber =
IDriveableTier-Op-Sequenz wie im Gate), nie blosse Praesenz-Checks.

SCOPE-GRENZE (Owner-Schnitt, hart): KEIN Deep-Research-Katalog je Achse, KEIN per-Binary-Vollbeleg
aller Achsen-Algorithmen, KEIN GTest-Harness am Dock, KEINE 64-Misch-Abnahme -- alles deklarierte
Nach-Abgabe-Strecke (synthese.md Teil 3 Nr. 7/8).

---

## (c) RISIKEN

1. **Cursor-Format-Kopplung cross-repo** (Schreiber super main.cpp:1185-1194, Leser neu in ce):
   Format-Drift wuerde den Leser stumm leeren. Gegenmittel: Literal-Pins in der W5-TU + deklarierte
   Kopplung mit Fundstelle im Header; Single-Source erst mit #35-.so (Nach-Abgabe) erreichbar.
2. **ctest-N lebendes Gate** (Basis 405): +2 TUs W3, +1 TU W5 verschieben N je Commit. Je Commit
   frisches Configure am Commit-Objekt + 2x voll-ctest SERIELL mit literalem "100% tests passed,
   0 tests failed out of <N>"; CI-Kanon V32=ON beachten (J-Ketten-Referenz).
3. **cppcheck-Adjazenz-Falle** (frisch, 14673): neue TUs/Status-Code nutzen COMDARE_*-Makros
   (R5E_PILOT_DLL etc.) NIE in String-Literal-Adjazenz; bei Pfad-Defines explizite
   std::string-Konkatenation wie im 60c7c56a-Hotfix.
4. **Fingerprint-Neutralitaet trotz Iterator-Beruehrung**: die kLazyResumeRowsKey-Hebung ist die
   EINZIGE Aenderung an bestehender Substanz -- string-identische Umformung, Beweis je Commit:
   abi/ diff 0 Zeilen, Frozen-Vektor 3 TUs, golden-CRC, golden-320 3/3, Roundtrip; W2-Mess-Zeile
   byte-identisch per Konstruktion (keine Emission beruehrt).
5. **Bestandslog on-demand vs. Netz**: from_env ohne minio-Env oder unerreichbar darf status nicht
   haengen -- with_object_budget(1,10) (planer_block-Muster) + "keine Daten"-Zeile; TU rein lokal.
6. **MEASUREMENT-OFF-Konfigurationen**: W3-TUs nur in der messungs-gated CMake-Sektion registrieren
   (sonst dynamic_cast-nullptr-Fehlalarm in Release-only-Baeumen); status ist mess-flag-frei.
7. **planer_block-Reaper-Falle** (f7-Lens 7: akut "sobald der Zweit-Planer-Konsument real wird"):
   bewusst entschaerft -- status bindet KEINEN planer_block (rein lesend); Reaper bleibt benannter
   Nach-Abgabe-Posten, W5 aendert daran nichts.
8. **R-G2/Posten 92**: status geht ueber die bestehende Fassaden-Resolve wie `plan` (3er-Kanon),
   validate bleibt 2er -- Divergenz wird NICHT beruehrt, nicht "nebenbei geheilt".
9. **Frist/Scope-Creep W3**: Biss-Fakes klein halten (je Testat EIN Fake); alles jenseits der
   Mess-Interface-Liste sofort als Nach-Abgabe-TODO notieren statt bauen (Dauer-Regel mittag-6).
10. **wt-e24-Branch-Zustand**: Worktree steht auf hotfix-cppcheck -- vor C1 Branch `w5-w3-kern`
    exakt ab 60c7c56a; build-e24 warm nutzen, -j MAX 8 nice; KEIN Push/Merge (Auftrag).

---

## (d) COMMIT-SCHNITT (3 Commits; Gate je Commit identisch)

- **C1 -- W3-Kern**: pruef_dock/mess_interface_testate.hpp (additiv) + test_w3_mess_interface_
  testate_dock.cpp + test_w3_mess_interface_testate_biss.cpp + CMake-Wiring (messungs-gated Sektion,
  $<TARGET_FILE>-Verdrahtung beider Traeger-DLLs). Kein Produktiv-Pfad beruehrt.
- **C2 -- W5-Lese-Substanz**: planner/planner_status_reader.hpp + planner/progress_cursor_reader.hpp
  (neu) + kLazyResumeRowsKey-Hebung im Iterator-Header (string-identisch) + test_w5_status_reader.cpp
  (Fixtures aus den echten Schreib-Formen, honest-empty-Fall).
- **C3 -- W5-CLI-Andockung**: main.cpp status-Zweig am reservierten Andockpunkt + help_for("status")
  + Uebersicht + MANUAL_RUN-Notiz + literaler status-Rauchtest am gebauten Binary (Fixture-Root,
  leerer Root, --help). (Falls Zeitdruck: C2+C3 zu EINEM Commit faltbar -- Schnittgrenze bleibt
  Substanz vor CLI.)

GATE JE COMMIT (Auftrag, unveraendert): Voll-Bau + 2x voll-ctest SERIELL (frisches Configure am
Commit-Objekt, N literal) + golden 3/3 + Roundtrip + Neutralitaets-Beweise (abi/ 0, Frozen-Vektor
3 TUs, golden-CRC, golden-320) + Freeze + diff-stat + status-Rauchtest literal (ab C2/C3) +
cf22 echtes Binary mit Datei-Argumenten + 3-Marker 0 + Wortgrenzen-Orakel. ASCII durchgaengig.
KEIN Push/Merge; Working-Tree-Freeze nach Paketmeldung.
