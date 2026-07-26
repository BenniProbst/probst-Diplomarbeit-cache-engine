PRUEFLISTE — Tatsachen-Behauptungen hinter den Verdikt-Entscheiden (d2-HOLD, N7-Aufschub, P-2 Bestandslog-AUS). Reine Extraktion, keine Bewertung.

## Block I — Kritische Sektion / Lock-Zeitbudget (traegt: N7-Aufschub, E5, 2.4)

**B1 — Kritische Sektion enthaelt `object_store` mit Worst Case ~49 min (12 Retries a 5 s + 2x120 s).**
- Quelle A: 00-verdikt Z.52 — "die kritische Sektion enthaelt einen `object_store` mit Worst Case ~49 min (12 Retries a 5 s + 2x120 s Timeout) -- drei Groessenordnungen ueber der TTL"
- Quelle B: 00-verdikt Z.119 — "`COMDARE_ARTEFAKT_TRIES=1` im Emit-Pfad. Sonst Worst Case ~49 min pro Store (12 Retries a 5 s + 2x120 s); fehlt das `timeout`-Binary im Runner-Image, gibt es gar keinen Wall-Clock-Cap (`artifact_cache.hpp:556`)"
- Quelle C: 05-adversarial Z.87 (Lens 4) — "Zeitbudget: `object_store` -> `mc_cp` (`artifact_cache.hpp:690-696`) mit `tries_ = 12`, `sleep_s_ = 5` (`:952-953`). Jeder Versuch: `mc cp` (Cap `mc_push_timeout_s_ = 120`) + `mc_size_verified` (weitere 120s) + 5s Pause. Worst Case pro Store ca. 49 Minuten."
- Quelle D: 05-adversarial Z.99 (Lens 5) — "Die kritische Sektion enthaelt einen `object_store`, dessen Worst Case (12 Retries) ~49 Minuten betraegt"
- Code-Anker: `artifact_cache.hpp:690-696` (mc_cp), `:952-953` (tries_=12, sleep_s_=5), `mc_push_timeout_s_=120`, `artifact_cache.hpp:575-584` (probe_timeout), `artifact_cache.hpp:556` (`if (!timeout_available || timeout_s == 0 ...) return argv;`)

**B2 — `LockRecord.ttl_s = 30`.**
- Quelle A: 00-verdikt Z.52 — "`LockRecord.ttl_s = 30`"
- Quelle B: 05-adversarial Z.99 — "Der harte Bruch: `LockRecord.ttl_s = 30` (`bestandslog_lock.hpp:84`)."
- Code-Anker: `bestandslog_lock.hpp:84`

**B2a — `lock_is_stale` erklaert den Lock nach 30 s fuer brechbar; `try_acquire_lock` bricht ihn dann von jeder anderen Maschine.**
- Quelle: 05-adversarial Z.99 — "`lock_is_stale` (`:139-141`) erklaert den Lock nach 30 s fuer brechbar, `try_acquire_lock:155-156` bricht ihn dann von jeder anderen Maschine -> zwei Schreiber in derselben Sektion"; 00-verdikt Z.52 "jede andere Maschine erklaert den Lock fuer stale und bricht ihn -> zwei Schreiber in der Sektion"
- Code-Anker: `bestandslog_lock.hpp:139-141`, `:155-156`

**B2b — Die kritische Sektion umfasst ca. 15-25 mc-Prozess-Spawns plus zwei volle Down-/Uploads des Dokuments.**
- Quelle: 05-adversarial Z.97 — "`try_acquire_lock` (`bestandslog_lock.hpp:149-167`) = fetch + evtl. remove + store + Zweit-Verify-fetch, danach `store_document_merged` (fetch + store des ganzen Dokuments), danach `release_lock` (fetch + remove). Das sind ca. 15-25 mc-Prozess-Spawns. Bei einem gewachsenen Bestandslog (~35-40 MB XML, s. Lens 2c) kommen zwei volle Down-/Uploads dazu."
- Code-Anker: `bestandslog_lock.hpp:149-167`, `release_lock:173`, `store_document_merged`

**B2c — Der heutige I1b-Pfad nimmt gar kein Lock; kein Produktionspfad ruft `try_acquire_lock`/`release_lock`, nur Tests.**
- Quelle A: 05-adversarial Z.95 — "Der heutige I1b-Pfad nimmt gar kein Lock."
- Quelle B: 03-ledger D-3, Z.42 — "im Ist ruft kein Produktionspfad diese Funktionen (`bestandslog_lock.hpp:149-175`) auf -- nur Tests"
- Code-Anker: `bestandslog_lock.hpp:149-175`

**B2d — Auch im gesunden Fall (~2 s Sektion) ist "Millisekunden" (N7) nicht haltbar.**
- Quelle: 05-adversarial Z.99 — "Auch im gesunden Fall (~2 s Sektion) ist 'Millisekunden' nicht haltbar."
- Anker: `apply_calibration`, `reservation_lifecycle.hpp:86-89`

**B2e — LEDGER-Vorgabe: Bestandslog wird beim Schreibvorgang gelockt (LED:3225); Multi-Write erst frei "SOBALD fuer das Bestandslog KOMPILIERT wird" (LED:3227); Alternativ-Zweig: ausdruecklicher, im Ledger vermerkter Aufschub nach #46b als KNOWN GAP.**
- Quelle: 03-ledger D-3, Z.42; 00-verdikt Z.53 zitiert den Alternativ-Zweig literal
- Anker: LED:3225, LED:3227, #46b

## Block II — Merge-Komplexitaet / Dokumentgroesse (traegt: P-2)

**B3 — Quadratischer Merge O(|a|*|b|), ~8.6e9 String-Vergleiche bei |b|=131072, ~1.7e10 auf der zweiten Maschine.**
- Quelle A: 00-verdikt Z.181 (P-2 iii) — "quadratischer Merge O(|a|*|b|) (`bestandslog_lock.hpp:229-237`) -- bei |b|=131072 sind das ~8.6e9 String-Vergleiche single-threaded, auf der zweiten Maschine ~1.7e10"
- Quelle B: 05-adversarial Z.45-51 (Lens 2c) — Code-Zitat `out.bestand = a.bestand; for (auto const& be : b.bestand) { auto it = std::find_if(out.bestand.begin(), ...` ; "O(|a| * |b|)"; "Ein voller golden-Bau: |b| = 131072, |a| waechst mit -> ~8.6e9 Vergleiche von 128-hex-Strings plus drei weiteren Feldern, single-threaded, im Mess-/Bau-Prozess. Auf der zweiten Maschine (|a| = 131072 vorbestueckt) sind es ~1.7e10."
- Code-Anker: `bestandslog_lock.hpp:229-237`; `LagerRunState::flush` (`builder_registration.hpp`) uebergibt als `local.bestand` alle frisch registrierten Binaries des Laufs
- Quelle K8: 00-verdikt Z.64 — LEDGER-Bericht erwaehnt den quadratischen Merge nicht

**B4 — ~35-40 MB XML je flush, komplett herunter- und hochgeladen.**
- Quelle A: 00-verdikt Z.181 (P-2 iii) — "dazu ein ~35-40 MB XML-Dokument, das pro flush komplett herunter- und hochgeladen wird"
- Quelle B: 05-adversarial Z.51 — "Dazu `emit_document` (`bestandslog_document.hpp:269-338`), das aus 131072 Eintraegen einen ~35-40 MB XML-String baut, ihn in `/tmp` schreibt und per `mc cp` hochlaedt -- pro flush, und `store_document_merged` laedt ihn vorher komplett herunter."
- Code-Anker: `bestandslog_document.hpp:269-338` (emit_document), `store_document_merged`

## Block III — Bau-Treiber-Umschalt / mc-Shellouts im Messlauf (traegt: P-2, AUF-B3)

**B5 — 2x `store_document_merged` je 4096er-Fenster; bei N=2^17 rund 64 Dokument-Roundtrips / ~256 synchrone mc-Shellouts im Messlauf; der Bau-Abschnitt ist nicht auf `provision_only` gegated, nur der AsyncPushPump.**
- Quelle A: 00-verdikt Z.181 (P-2 ii) — "2x `store_document_merged` je 4096er-Fenster = bei N=2^17 rund 64 Dokument-Roundtrips / ~256 synchrone mc-Shellouts im Messlauf (der Bau-Abschnitt ist nicht auf `provision_only` gegated, nur der AsyncPushPump)"
- Quelle B: 05-adversarial Z.43 (Lens 2b) — "`run_planer_driven_provision` (`cache_engine_builder_iterator.hpp:808-876`) macht pro 4096er-Fenster zwei `store_reservation` (:837 pro-forma, :869 done). Jedes `store_reservation` (:818-824) ist ein `store_document_merged` = `fetch` + `store` = 4 mc-Prozess-Spawns (`object_fetch` -> `mc_remote_exists` + `mc_pull`; `object_store` -> `mc_cp` + `mc_size_verified`). Diese Phase laeuft auch im Mess-Modus (der Bau-Abschnitt ist nicht auf `provision_only` gegated; nur der `AsyncPushPump` ist es, `:953-954`). Bei golden N=2^17 = 32 Fenster -> 64 Dokument-Roundtrips -> ca. 256 synchrone mc-Shellouts mitten in einem Messlauf."
- Quelle C: 00-verdikt Z.145 (W-30 Operative Notizen) — "Nicht kombinieren mit aktivem Bestandslog (siehe P-2): die Provisions-Phase wuerde vor dem Messen ~256 synchrone mc-Shellouts einschieben."
- Code-Anker: `cache_engine_builder_iterator.hpp:808-876`, `:837`, `:869`, `:818-824`, `:953-954`

**B5a — `bestandslog_active` schaltet den Bau von `provision_all` auf `run_planer_driven_provision` — "das ist kein Log, das ist ein anderer Bau-Treiber".**
- Quelle A: 00-verdikt Z.181 (P-2 i) — "(i) `bestandslog_active` schaltet den Bau von `provision_all` auf `run_planer_driven_provision` (`iterator:979-982`) -- das ist kein Log, das ist ein anderer Bau-Treiber"
- Quelle B: 05-adversarial Z.35-39 — Code-Zitat `if (bestandslog_active) builds = run_planer_driven_provision(...); else builds = orch.provision_all(...)`
- Quelle C: 03-ledger B2, Z.13 — "wechselt den Bau von dem EINEN `provision_all` auf `run_planer_driven_provision` (:979-982) + `[bestandslog]`-cerr-Zeile (:994-996) + je Slice fehlschlagende Stores. Das ist KEINE Byte-/Verhaltens-Neutralitaet."
- Code-Anker: `cache_engine_builder_iterator.hpp:979-982`, `:994-996`

**B5b — Gate `bestandslog_active` prueft nur, dass vier `std::function` belegt sind und doc_key nicht leer ist; `make_bestand_transport` belegt sie bedingungslos, auch auf inertem Cache -> Gate haengt faktisch nur an `!doc_key.empty()`.**
- Quelle A: 05-adversarial Z.29-41 (Lens 2a) — Code-Zitat `cache_engine_builder_iterator.hpp:927-929`; "`make_bestand_transport` (`artifact_cache_transport.hpp:37-53`) belegt alle vier `std::function` bedingungslos -- auch auf einer inerten Instanz. Der bestehende Test beweist das: `tests/unit/test_g3_artifact_cache_transport.cpp:47-55` (`BinderPopulatesAllFourVerbs` auf `at::ArtifactCache const cache;` ohne Env)."
- Quelle B: 00-verdikt Z.94 (AUF-B3) — "`bestandslog_active` (`iterator:927-929`) prueft nur, dass vier `std::function` belegt sind, und `make_bestand_transport` belegt sie bedingungslos, auch auf einem inerten Cache (bewiesen: `test_g3_artifact_cache_transport.cpp:47-55`). Ohne Doppel-Gate haengt der Umschalt von `provision_all` auf `run_planer_driven_provision` (`:979-982`) allein an einem nicht-leeren Doc-Key."
- Quelle C: 03-ledger B2, Z.13 — gleiche Behauptung, gleicher Test-Beleg
- Zusatz: 05-adversarial Z.41 — "`make_fingerprint_key_fn()` aus (A) ist ebenfalls immer non-null (sie liefert `nullopt` erst pro Aufruf)"
- Code-Anker: `cache_engine_builder_iterator.hpp:927-929`, `artifact_cache_transport.hpp:37-53`, `test_g3_artifact_cache_transport.cpp:47-55`, Muster `profile_run_entry.hpp:311-316` / `:325-330`

**B10 — `run_planer_driven_provision` = anderer, ungetesteter Bau-Treiber.**
- Quelle: 00-verdikt Z.181 (P-2 i), identisch mit B5a; im Bericht wird "ungetestet" nicht literal behauptet — literal steht "das ist kein Log, das ist ein anderer Bau-Treiber"
- Code-Anker: `cache_engine_builder_iterator.hpp:979-982`, `:808-876`

## Block IV — id / Merge-Monotonie (traegt: E2, D-1)

**B6 — `pick_reservierung` verwirft unter gleicher id ein spaeteres `offen`, wenn bereits `done` vorliegt (Status-Rang offen=0 < released=1 < done=2).**
- Quelle A: 00-verdikt Z.108 (E2) — "semantisch defekt: Merge-Monotonie (`pick_reservierung`, `bestandslog_lock.hpp:190-208`) laesst ein einmal terminales `done` jedes spaetere `offen` unter derselben id verwerfen -- die Reservierung ist genau einmal belegbar"
- Quelle B: 03-ledger D-1, Z.36 — "`detail::pick_reservierung` (bestandslog_lock.hpp:200-208) waehlt bei id-Konflikt den hoeheren Status (`status_rank` :190-197, offen=0 < released=1 < done=2), und `store_document_merged` merged remote gegen lokal (:262-276). Mit L2s STABILER id (`owner_uuid + '/plan/' + doc-key`) heisst das: sobald ein Planer-Lauf seinen Eintrag terminal (done) geschlossen hat, wird JEDER spaetere `offen`-Eintrag unter derselben id beim Merge weggeworfen."
- Quelle C: 00-verdikt Z.50 (K3) — "`pick_reservierung` laesst `done` von prod1 das `offen` von prod2 ueberschreiben"
- Quelle D: 05-adversarial Z.70 (3c) — "`detail::pick_reservierung` (`:200-208`) waehlt dann nach Status-Rang: prod1s `done` ueberschreibt prod2s `offen` -> ein laufender Slice erscheint fertig"
- Code-Anker: `bestandslog_lock.hpp:190-208`, `:200-208`, `status_rank :190-197`, `store_document_merged :262-276`
- Auch als AUF-C2 / Luecke C3 benannt: 00-verdikt Z.100, 03-ledger Z.20

**B6a — L2-id `owner_uuid + "/plan/" + doc_key` ist aus der vorhandenen Helfer-Signatur nicht herstellbar; Signatur ist `owner_uuid + "/" + std::to_string(seq)`.**
- Quelle A: 00-verdikt Z.25-27 (eigene Nachpruefung) — "1264: make_planer_block_reservation(std::string owner_uuid, std::size_t seq, ...) / 1268: std::move(owner_uuid) + '/' + std::to_string(seq), bl::BatchTyp::planer_block, ... (= duenner Wrapper um bl::make_pro_forma_reservation, KEIN eigener Wert-Aufbau)"
- Quelle B: 00-verdikt Z.108 (E2 a) — "mit dem vorhandenen Helfer nicht erzeugbar (Signatur `owner_uuid + '/' + seq`, Zeile 1264-1269 literal)"
- Quelle C: 05-adversarial Z.121-123 (i) — Signaturaenderung faerbt `test_experiment_plan_director.cpp:1502` (`EXPECT_EQ(r.id, "6f1c2b3a-.../7") << "id = owner_uuid/seq"`) und `:1517-1519` rot; Alternative `bl::make_pro_forma_reservation` direkt rufen macht die G4a-7-Funktion zu totem Code und bricht die Doktrin aus Kommentar `:1252-1257`
- Quelle D: 03-ledger C2, Z.19 — `experiment_plan_director.hpp:1263-1270`
- Code-Anker: `experiment_plan_director.hpp:1263-1270`, `test_experiment_plan_director.cpp:1502`, `:1517-1519`, Kommentar `:1252-1257`

**B6b — `make_planer_block_reservation` wird heute nur in Tests aufgerufen; `run_planer_driven_provision:832` schreibt `BatchTyp::tier`. (d2) waere der erste Schreiber von `typ="planer_block"`.**
- Quelle: 05-adversarial Z.72 (3d) — "G4b (d2) ist der erste Schreiber von `typ='planer_block'` in das geteilte Dokument (verifiziert: `make_planer_block_reservation` wird heute nur in Tests aufgerufen; `run_planer_driven_provision:832` schreibt `BatchTyp::tier`)"
- Quelle: 00-verdikt Z.123 — "(d2) ist der erste Schreiber von `typ='planer_block'`"
- Code-Anker: `cache_engine_builder_iterator.hpp:832`

**B6c — `profile_facade` ist im Include-Satz des Test-Targets nicht enthalten -> `make_planer_block_reservation` in dieser TU nicht testbar ohne CMake-Aenderung.**
- Quelle A: 00-verdikt Z.29-31 — "tests/unit/CMakeLists.txt (Target test_g3_artifact_cache_transport) include_directories: libs/cache_engine/builder | .../include | .../src | libs/common (profile_facade NICHT enthalten -- literal bestaetigt)"
- Quelle B: 03-ledger C2, Z.19
- Code-Anker: `tests/unit/CMakeLists.txt` (Target `test_g3_artifact_cache_transport`), Include-Satz `tests/unit/CMakeLists.txt:3995-3999` (03-ledger Z.17)

## Block V — Voll-Wipe / Versionsdrift (traegt: d2-HOLD, P-4)

**B7 — Voll-Wipe: `parse_bestandslog` liefert bei unbekanntem `typ`/`status`/`genus` `nullopt`; `store_document_merged:269` behandelt "remote unlesbar" als `to_write = local`.**
- Quelle A: 00-verdikt Z.123 — "`parse_bestandslog` liefert bei unbekanntem `typ`/`status`/`genus` `nullopt` (`bestandslog_document.hpp:353/379/390`), und `store_document_merged:269` behandelt 'remote unlesbar' als `to_write = local` -> eine Maschine mit CE-Pin vor `351855b8` loescht den gesamten Fremdbestand."
- Quelle B: 05-adversarial Z.72 (3d) — "`parse_bestandslog` gibt `nullopt` bei unbekanntem `typ`/`status`/`genus` zurueck (`bestandslog_document.hpp:353, 379, 390`). `store_document_merged:269` behandelt 'remote unlesbar' als `to_write = local` -- der komplette Fremdbestand wird ueberschrieben. ... Ein Runner/eine Maschine mit einem CE-Pin vor Commit `351855b8` (dem Commit, der `planer_block` einfuehrte) liest das Dokument nicht mehr, haelt es fuer unlesbar und ersetzt es durch seinen Ein-Datensatz-Stand. Ergebnis: gesamter Binary-Bestand aller Maschinen geloescht."
- Quelle C: 00-verdikt Z.185 (P-4) — "CE-Pin-Gleichstand aller Runner/Maschinen (>= `351855b8`) -- oder P-2 (Bestandslog aus) als Ersatz. Sonst offener Voll-Wipe-Pfad, sobald irgendjemand `typ='planer_block'` schreibt."
- Code-Anker: `bestandslog_document.hpp:353`, `:379`, `:390`, `bestandslog_lock.hpp` `store_document_merged:269`, CE-Commit `351855b8`
- K8 (00-verdikt Z.64): LEDGER-Bericht erwaehnt den Voll-Wipe nicht

**B7a — Lost Update ohne CAS: `store_document_merged` (`bestandslog_lock.hpp:262-276`) ist unatomares read-modify-write, `run_planer_driven_provision:823` nimmt kein `try_acquire_lock`.**
- Quelle: 05-adversarial Z.61-66 (3a) — inkl. t0/t1/t2-Szenario "S3 last-writer-wins, A-plan ist weg"; Kopf-Kommentar `bestandslog_lock.hpp:12-20` begruendet Harmlosigkeit mit "(b) Artefakt-Pushes sind idempotent"; Begruendung des Schnitts steht in `experiment_plan_director.hpp:1250`
- Code-Anker: `bestandslog_lock.hpp:262-276`, `:12-20`, `cache_engine_builder_iterator.hpp:823`, `experiment_plan_director.hpp:1250`

## Block VI — Vertragsebene / Anker des planer_block (traegt: E1, d2-HOLD)

**B8 — `planer_block`-Anker `--emit-tier-ci`/`--emit-tier-cmake` ist die Tier-Emission (CEB-Rolle), nicht die CEB-Compile-Strecke; letztere emittieren `--dump-ci`/`--dump-cmake`.**
- Quelle A: 00-verdikt Z.107 (E1) — "LED:3221 blockt eine CEB-Compile-Strecke. `--emit-tier-ci`/`--emit-tier-cmake` sind ausweislich `main.cpp:433-438` die CEB-Rolle, die TIER-Jobs erzeugt; die CEB-Compile-Strecke emittieren `--dump-ci` (`:415`) / `--dump-cmake` (`:426`). Die Tier-Ebene hat ihre Reservierung bereits (`iterator:826-843`). Verstoss gegen die Ebenen-Trennung (LED:3308-3312) und LED:3229."
- Quelle B: 03-ledger D-0, Z.33 — LED:3221 literal zitiert; Director-Kommentar `experiment_plan_director.hpp:1248-1250` ("dass DIESER Planer gleich eine CEB-Compile-Strecke anstoesst"); `main.cpp:433-438` ("der Planer steuert die CEB-Jobs (`--dump-ci`), die CEB steuert die Tier-Jobs (`--emit-tier-ci`)"); Verstoss gegen LED:3308-3312 und LED:3229 (Batch-Typen nie mischen)
- Quelle C (Zusatzargument K9): 00-verdikt Z.66 — "`--emit-tier-ci`/`--emit-tier-cmake` sind ... ebenfalls reine Emissionsbefehle -- sie bauen nichts und messen nichts. Dieselbe Begruendung [wie beim Ausschluss von `--dump-plan`] schliesst (d2) an seinem eigenen Anker aus."
- Code-Anker: `main.cpp:433-438`, `:415`, `:426`, `:439`, `:457`, `--dump-plan :363` (Kopf `:358-362`), `cache_engine_builder_iterator.hpp:826-843`, `experiment_plan_director.hpp:1248-1250`, LED:3221 / 3229 / 3308-3312

**B8a — "fuer diese Version" ist nicht abbildbar: doc_key identifiziert das Bestandslog, nicht die Strecke; `BatchReservierung` hat kein Feld dafuer.**
- Quelle A: 00-verdikt Z.109 (E3) — "LED:3221 blockt fuer eine Version, §62-D gibt der CEB den Replay-Schluessel `[a,b,c]`. Der Doc-Key identifiziert das Bestandslog, nicht die Strecke -> zwei Strecken unter einem doc_key teilen eine Block-id. `BatchReservierung` (`bestandslog_document.hpp:189-203`) hat kein Feld dafuer."
- Quelle B: 03-ledger D-6, Z.53 — LED:3221, §62-D (LED:3243), `bestandslog_document.hpp:189-203`, Praezedenz K7b LED:3290
- Code-Anker: `bestandslog_document.hpp:189-203`

## Block VII — owner_uuid / Maschinen-Identitaet (traegt: E2, K3, AUF-B4)

**B9 — `owner_uuid` wird nirgends gesetzt (0 Treffer); einziger Leser `profile_run_entry.hpp:312`, Forwards `experiment_plan_director.hpp:734-737`.**
- Quelle A: 00-verdikt Z.33-36 (eigene Nachpruefung) — "grep -rn 'COMDARE_BESTANDSLOG' --include=*.yml --include=*.yaml --include=*.sh --include=*.cmake --include=*.xml --include=*.bat ueber das super-Repo -> KEINE AUSGABE (0 Treffer). Einziger Leser: profile_run_entry.hpp:312. Forwards: experiment_plan_director.hpp:734-737. KEIN SETZER EXISTIERT."
- Quelle B: 00-verdikt Z.50 (K3-Aufloesung) — "keine der beiden Annahmen trifft heute zu -- die Variable wird NIRGENDS gesetzt"
- Quelle C: 03-ledger D-7, Z.56 — "`COMDARE_BESTANDSLOG*` wird ausschliesslich vom Director weitergereicht (`experiment_plan_director.hpp:730-738`); `grep` ueber `.gitlab-ci.yml`, `*.sh`, `*.cmake`, `*.xml` in super UND ce: 0 Treffer, d.h. kein Setzer."
- Quelle D: 05-adversarial Z.70 (3c) — "Kein Code validiert `bestand_owner_uuid` (verifiziert: nur Deklaration `cache_engine_builder_iterator.hpp:225` und Verwendung `:832`)."
- Quelle E: 00-verdikt Z.183 (P-3) — "Eigene Nachpruefung: 0 Treffer ueber `*.yml/*.yaml/*.sh/*.cmake/*.xml/*.bat` im super-Repo."
- Code-Anker: `profile_run_entry.hpp:312`, `experiment_plan_director.hpp:730-738` / `:734-737`, `cache_engine_builder_iterator.hpp:225`, `:832`

**B9a — Leerer owner_uuid: `parse_lock` akzeptiert `owner=` mit leerem Wert; `try_acquire_lock:153` vergleicht `"" == ""` -> jede Maschine haelt jeden fremden Lock fuer den eigenen; `release_lock:173` loescht fremde Locks.**
- Quelle A: 05-adversarial Z.70 (3c) — "`parse_lock` (`:104-137`) akzeptiert `owner=` mit leerem Wert (`have_owner` wird gesetzt), und `try_acquire_lock:153` vergleicht `existing->owner_uuid != me.owner_uuid` -> `'' == ''` -> jede Maschine haelt jeden fremden Lock fuer den eigenen; `release_lock:173` loescht dann fremde Locks. Wechselseitige Exklusion vollstaendig ausgeschaltet."
- Quelle B: 00-verdikt Z.50 (K3) — identische Aussage
- Code-Anker: `bestandslog_lock.hpp:104-137`, `:153`, `:173`

**B9b — Widerspruch der Quellberichte zu owner_uuid (K3): LEDGER D-2 nimmt EINE geteilte owner_uuid an (Kollision), ADVERSARIAL 3b nimmt VERSCHIEDENE an (keine Sperre).**
- Quelle A: 00-verdikt Z.49-50 (K3)
- Quelle B: 03-ledger D-2, Z.39 — "`experiment_plan_director.hpp:736` reicht `COMDARE_BESTANDSLOG_OWNER_UUID` literal ueber die zweite Trigger-Grenze (`forward: yaml_variables: true`, :748-750). Alle Lanes/Maschinen eines Plans teilen damit EINE owner_uuid." Verstoss gegen LED:3217 und LED:3208; "Derselbe Defekt steckt bereits im Tier-Pfad (`cache_engine_builder_iterator.hpp:832`)."
- Quelle C: 05-adversarial Z.68 (3b) — "Mit L2 (`id = owner_uuid + '/plan/' + doc_key`) haben prod1 und prod2 verschiedene `owner_uuid` -> verschiedene ids -> `merge_documents` (`:242-249`) behaelt beide -> beide Planer fahren die Strecke. Die Reservierung ist reine Dokumentation, keine Sperre."
- Code-Anker: `experiment_plan_director.hpp:736`, `:748-750`, `bestandslog_lock.hpp:242-249`, `reservation_lifecycle.hpp:113-119`, LED:3217, LED:3208, §66-N3 (LED:3412-3413)

## Block VIII — 30-Minuten-Frist / Terminalitaet (traegt: 2.4, D-4, D-5)

**B11 — Die 30-Minuten-pro-forma-Frist ist im Ist faktisch null: `reserviert_utc` und `pro_forma_bis_utc` bekommen denselben Wert (2x `now_utc_iso()`).**
- Quelle A: 00-verdikt Z.115 — "Der Ist-Analog uebergibt fuer `reserviert_utc` und `pro_forma_bis_utc` denselben Wert (`iterator:834-836`, 2x `now_utc_iso()`) -> `is_pro_forma_expired` ist eine Sekunde spaeter true -> Takeover-Schutz wirkungslos. 'Analog uebernehmen' wuerde den Defekt kopieren."
- Quelle B: 03-ledger D-4, Z.45 — gleiche Aussage, `reservation_lifecycle.hpp:99-101`, LED:3219, LED:3221; "(d2) MUSS `pro_forma_deadline_epoch_s(reserviert, 30)` benutzen"
- Code-Anker: `cache_engine_builder_iterator.hpp:834-836`, `reservation_lifecycle.hpp:99-101`, `pro_forma_deadline_epoch_s` `reservation_lifecycle.hpp:57-60`, `kProFormaMinutes = 30` (`reservation_lifecycle.hpp:33`)

**B12 — Kein `try`/`catch` um die Emit-Zweige: nur `:379-391` und `:813-1077` liegen in einem try; `--emit-tier-ci :439-452` / `--emit-tier-cmake :457-470` nicht -> Exception aus `main` -> `std::terminate` ohne Unwinding -> `~PromiseGuard` feuert nie -> Reservierung bleibt 30 min haengen.**
- Quelle A: 00-verdikt Z.117 — literal
- Quelle B: 05-adversarial Z.80-82 (Lens 4) — "`DRV:315` `int main(...)`. Die einzigen `try`/`catch` im Treiber liegen bei `:379-391` (`--chunk-organ-fingerprint`) und `:813-1077` (E4-Block). Die Zweige `--emit-tier-ci` (`:439-452`) und `--emit-tier-cmake` (`:457-470`) liegen in der argv-Schleife `:319-471` und sind von keinem `try` umschlossen." + "Der Standard verlangt kein Stack-Unwinding vor `terminate`, und libstdc++/GCC unwinden hier nicht."
- Code-Anker: `main.cpp:315`, `:319-471`, `:379-391`, `:439-452`, `:457-470`, `:813-1077`, `reservation_lifecycle.hpp:137-145`

**B12a — L1 "immer terminal" ist zu stark: `_Exit`/`abort`/SIGTERM (CI-Cancel, Pipeline 11519) laufen am Guard vorbei.**
- Quelle A: 00-verdikt Z.117
- Quelle B: 03-ledger D-5, Z.50 — "`PromiseGuard` feuert nur bei Stack-Unwinding. `std::_Exit`/`abort`/SIGTERM (CI-Job-Cancel -- exakt der Fall Pipeline 11519, LED:3305) laufen daran vorbei."
- Anker: LED:3305, LED:3220

**B12b — Code-Falle: `return pf::emit_tier_ci_facade(...)` zerstoert den Guard erst nach Berechnung des Rueckgabewerts; `PromiseGuard::commit()` schreibt nichts, es unterdrueckt nur den Release.**
- Quelle A: 00-verdikt Z.116
- Quelle B: 03-ledger D-5, Z.48-49 — "`PromiseGuard::commit()` (reservation_lifecycle.hpp:137-150) schreibt nichts -- es unterdrueckt nur den Release." Ist-Analog: `iterator:860-871`. LED:3222.
- Code-Anker: `reservation_lifecycle.hpp:137-150`, `cache_engine_builder_iterator.hpp:860-871`

**B13 — Store-Ergebnis wird verworfen: `store_reservation` (`iterator:823`) castet den `nullopt`-Fall auf `(void)`.**
- Quelle A: 00-verdikt Z.120
- Quelle B: 05-adversarial Z.86 — "`store_document_merged` gibt bei Store-Fehler `nullopt` zurueck; `store_reservation` (`cache_engine_builder_iterator.hpp:823`) verwirft das mit `(void)`."
- Code-Anker: `cache_engine_builder_iterator.hpp:823`

**B14 — Lebensdauer-Falle: `make_bestand_transport` haelt `ArtifactCache const&`; an der (d2)-Stelle existiert noch keine Cache-Instanz (entsteht erst `main.cpp:840`).**
- Quelle A: 00-verdikt Z.96 (AUF-B5), Z.118 ("Zweite, benannte `ArtifactCache`-Instanz ... die Emit-Zweige `return`en lange vor `:840`. Praezedenz `main.cpp:779`.")
- Quelle B: 05-adversarial Z.125 (ii) — "`make_bestand_transport` haelt eine `const&` auf den Cache (`artifact_cache_transport.hpp:20-24, 37`). ... `make_bestand_transport(at::ArtifactCache::from_env())` waere die naheliegende Ein-Zeilen-Schreibweise und ergibt vier dangling Lambdas."
- Quelle C: 03-ledger B3, Z.14 — Kopf Z.20-24, `main.cpp:840`
- Code-Anker: `artifact_cache_transport.hpp:20-24`, `:37`, `main.cpp:840`, `:779`

## Block IX — `emit_storage_activation` / Halb-Zustaende (traegt: 2.4, LENS 6)

**B15 — `emit_storage_activation` fehlt im `ceb:emit`-Job; gerufen nur `:988` (Build-Batch) und `:1117` (Mess-Batch).**
- Quelle A: 00-verdikt Z.121 — "`emit_storage_activation` fehlt im `ceb:emit`-Job (`experiment_plan_director.hpp:888-893`, gerufen nur `:988`/`:1117`). Ohne mc-Alias `prodcache` ist die Reservierung dort entweder Fiktion (minio aus) oder ~2 min stiller Leerlauf (minio-Vars gesetzt, Alias fehlt). Ohne Fix ist (d2) im eigenen Job wirkungslos."
- Quelle B: 05-adversarial Z.109-111 (6a) — `experiment_plan_director.hpp:888-893`, Job `:654-688`; Fall 1 ohne MinIO-Vars: `minio_enabled()` false -> alle vier Verben `false`/`nullopt` (`artifact_cache.hpp:487, 507, 535, 543`); Fall 2 mit MinIO-Vars: `mc_target` baut `https://host:9000/bucket/key` statt Alias, `MC_HOST_prodcache` ungesetzt -> 12 Retries a 5 s, zweimal pro Reservierung -> ca. 2 Minuten stiller Leerlauf pro `--emit-tier-ci`, nur `[Infra-Fehler: artefakt_io]` auf stderr (`artifact_cache.hpp:889-895`); `.gitlab-ci.yml:568` dokumentiert `COMDARE_MINIO_ENDPOINT`
- Code-Anker: `experiment_plan_director.hpp:888-893`, `:988`, `:1117`, `:654-688`, `artifact_cache.hpp:487/507/535/543`, `:889-895`, `.gitlab-ci.yml:568`, `comdare_storage_activation.sh`

**B16 — Kein Claim-CHECK, kein Takeover: `is_reservation_takeable`/`is_takeable_by_eta` sind gebaut, getestet und in keinem Produktionspfad gerufen.**
- Quelle A: 00-verdikt Z.122 — "Der Schnitt registriert und terminiert, prueft aber nie ein fremdes offenes `planer_block`. ... 'Reservierung = VERSPRECHEN' (LED:3208) und LED:3220 bleiben Papier."
- Quelle B: 03-ledger (c)1-2, Z.62-63 — "kein Aufrufer prueft das gefetchte Dokument je auf eine FREMDE offene Reservierung"; `reservation_lifecycle.hpp:105-119`; §66-Lager-Gate G3 (LED:3368-3369)
- Quelle C: 05-adversarial Z.68 (3b)
- Code-Anker: `reservation_lifecycle.hpp:105-119`, `:113-119`, LED:3207, LED:3208, LED:3220, LED:3368-3369

## Block X — Env / Byte-Neutralitaet (traegt: P-3, K5, P-2 flankierend)

**B17 — `experiment_plan_director.hpp:734-738` brennt die vier `COMDARE_BESTANDSLOG*`-Werte in den `ceb:trigger`-`variables:`-Block der Stufe-1-YAML -> Bytes aendern sich, sobald die Env gesetzt ist.**
- Quelle A: 00-verdikt Z.55 (K5), Z.183 (P-3 a)
- Quelle B: 05-adversarial Z.15 (Lens 1) — Stufe-1-YAML erzeugt in `.gitlab-ci.yml:1265` via `"$DRIVER" --dump-ci ... > planer-child-ci.yml`; "Heute ist `COMDARE_BESTANDSLOG` in der super-CI nirgends gesetzt ... -> der Block entfaellt. Mit G4b-Aktivierung erscheint er -> `planer-child-ci.yml` ist nicht mehr byte-identisch."
- Code-Anker: `experiment_plan_director.hpp:734-738`, `.gitlab-ci.yml:1265`

**B17a — Stufe-2-Emission ist env-frei: `experiment_plan_director.hpp` hat genau einen `std::getenv` (Z.57 Include, Z.695 Aufruf) in `append_forward_var_literal`, einem static-Member von `CiYamlBuilder` (Klasse endet Z.758); `TierCiYamlBuilder` (ab 788) und `TierCmakeGraphBuilder` (ab 1300) lesen keine Env.**
- Quelle: 05-adversarial Z.11 (Lens 1)
- Quelle B: 00-verdikt Z.55 (K5) — "fuer Stufe 2 stimmt das (verifiziert env-frei)"; CODE-NAEHTE R3: "heute ist der Beweis trivial, weil `bestandslog_active` immer false ist"

**B17b — Drei Director-Tests rufen `unset_g4a_forwarded_opt_ins()` nicht und werden rot, wenn `COMDARE_BESTANDSLOG` als Pipeline-Variable gesetzt ist.**
- Quelle A: 00-verdikt Z.183 (P-3 b) — "`test_experiment_plan_director.cpp:1175`, `:807`, `:1722` rot -- sie rufen `unset_g4a_forwarded_opt_ins()` nicht (nur `:669`, `:732`, `:748`, `:803` tun es)"
- Quelle B: 05-adversarial Z.21 — `CiYamlBuilder.NoCiProjectDirInVariablesBlockBothStages` (`:1175`), `YamlIsByteDeterministic` (`:807`), `SingleComboCebEmitOmitsMeasurementComboSelectorForByteStability` (`:1722`)
- Code-Anker: `tests/unit/thesis_tiere/test_experiment_plan_director.cpp:1175`, `:807`, `:1722`, `:669`, `:732`, `:748`, `:803`

**B18 — Log-Kanal: `emit_tier_ci_facade` schreibt YAML auf `std::cout` (`profile_run_facade.cpp:770`), CI leitet stdout in das Artefakt um (`experiment_plan_director.hpp:681`); Hausstil an der Injektionsstelle ist cout (`main.cpp:871` `[E4]`) -> eine `[bestandslog]`-Zeile auf cout = GitLab `config_error`.**
- Quelle A: 00-verdikt Z.97 (AUF-B6)
- Quelle B: 05-adversarial Z.19 — plus Entwarnungen: Iterator schreibt nach cerr (`cache_engine_builder_iterator.hpp:993`), `log_artefakt_io` (`artifact_cache.hpp:889`) ebenfalls, `run_argv` (`artifact_cache.hpp:856-859`) leitet mc-stdout in eine Datei
- Code-Anker: `profile_run_facade.cpp:770`, `experiment_plan_director.hpp:681`, `main.cpp:871`, `cache_engine_builder_iterator.hpp:993`, `artifact_cache.hpp:856-859`, `:889`

**B19 — Halb-Zustand 6b: `COMDARE_BESTANDSLOG=true` ohne DOC_KEY -> `bestandslog_active` false, aber `lazy_fingerprint` scharf (`profile_run_entry.hpp:311-316` prueft nur `COMDARE_BESTANDSLOG`) -> `.fingerprint`-Sidecars werden geschrieben (`build_orchestrator.hpp:543`); Byte-neutral bleibt es, weil `push_tier_binary` (`artifact_cache.hpp:228-263`) nur `perm.dll`, `perm.dll.algos`, `perm.dll.version` pusht.**
- Quelle: 05-adversarial Z.113 (6b)
- Code-Anker: `profile_run_entry.hpp:311-316`, `build_orchestrator.hpp:543`, `artifact_cache.hpp:228-263`

## Block XI — Schnitt-Umfang / Kompilierbarkeit (traegt: AUF-B1, K2)

**B20 — Der genehmigte 1-Datei-Schnitt (B) kompiliert nicht; die Naht ist dreischichtig, belegt am Praezedenz-Muster `cache_push/cache_pull/measurement_sink`.**
- Quelle A: 00-verdikt Z.16-21 (eigene Nachpruefung) — `profile_run_facade.hpp:35` ProfileRunArgs / `:75-77`; `:111` ExperimentRunArgs / `:140-142`; `profile_run_facade.cpp:559-561` (pa-Pfad), `:907-909` (xa-Pfad)
- Quelle B: 00-verdikt Z.46-47 (K2) — "CODE-NAEHTE hat recht ... Der genehmigte 1-Datei-Schnitt (B) kompiliert nicht."
- Code-Anker: `profile_run_facade.hpp:75-77`, `profile_run_facade.cpp:559-561`, `profile_run_entry.hpp:98-100`, Zuweisung `:458-460`/`:464-466`

**B21 — `grep -c "bestand" libs/cache_engine/profile_facade/experiment_run_entry.hpp -> 0`; xa/ExperimentRunArgs braeuchte zwei weitere ungenehmigte Dateien.**
- Quelle A: 00-verdikt Z.22 (Nachpruefung), Z.93 (AUF-B2)
- Quelle B: 03-ledger B1, Z.12 — `experiment_run_entry.hpp:47-60` nicht im Schnitt; beide Produktionsprofile sind `comdare_thesis_profile` (`all_axes_golden.profile.xml`, `m3_smoke_coverage.profile.xml`) -> pa-Pfad

**B22 — (d1)-Anker `:841-870` ist falsch; `main.cpp:840` = Cache-Bau, `:852` = `if (!artifact_cache->inert())` (Closure-Bau), Injektion literal bei `962-964` (xa) und `1056-1058` (pa).**
- Quelle A: 00-verdikt Z.10-14 (Nachpruefung), Z.43-44 (K1), Z.103 (AUF-D1)
- Quelle B: 03-ledger D, Z.25 — "bei :841-870 werden nur die CLOSURES gebaut; die Injektion in xa/pa steht bei :962-966 und :1056-1060"
- Quelle C: 05-adversarial Z.41 behandelt `main.cpp:852` als Injektionsstelle (der aufgeloeste Widerspruch)
- Code-Anker: `main.cpp:840`, `:852`, `:962-964`, `:1056-1058`

## Block XII — W-30 / Zeitbudget (traegt: P-8, Entscheid 3)

**B23 — `resolve_measure_parallelism` gibt bei `!measurement_on || single_thread` 0 zurueck; der 320er faehrt measure/release, also strikt 1 Thread -> kein #45-Rabatt.**
- Quelle: 00-verdikt Z.141 — "`resolve_measure_parallelism` (`measure_parallelism.hpp:25`) gibt bei `!measurement_on || single_thread` 0 zurueck. Der 320er ist ein BEWEIS-Lauf und faehrt measure/release, also strikt 1 Thread. Der rechnerische Gewinn (nproc=32 -> ~1/32 der Mess-Phase, ca. 11 min statt 6 h) faellt ausschliesslich in der Debug-/Verdrahtungs-Runde an ... parallelisiert werden die Mess-ZELLEN, nicht der Bau ... Skalierung ist pro Mess-Fenster (`builds.size()`), nicht global ueber 320."
- Code-Anker: `measure_parallelism.hpp:25`, `COMDARE_BUILD_PARALLEL`, §61-MODI

**B24 — W-30 ist gebaut: ce-Commit `99a608c2331a7dc71f648d4e910bb4c5f7115937`, 2026-07-21 20:47 UTC, in `development`, `main`, beiden GitHub-Spiegeln; Test `test_45_parallel_measure_loop` EXIT=0; Ledger `:3194` ist stale (aus S6-P1(g) vom 20./21.07., vor dem Commit); R9-Fix in `run_methodology_registry.hpp:50`.**
- Quelle: 00-verdikt Z.131-134
- Code-Anker: `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:3194`, `run_methodology_registry.hpp:50`

## Block XIII — Nebenbefunde, die in die Entscheide einfliessen

**B25 — `.fingerprint` ist nicht Teil des Push/Pull-Objektsatzes (`artifact_cache.hpp:233-262` = perm.dll/.algos/.version); hydrierte Binaries tragen nie einen Fingerprint; LagerKey traegt weder `+cxx` noch `+bt` noch `+ceb` (W-13 F6) -> 3-Stufen-Dedup (LED:3207) maschinenuebergreifend unerfuellt.**
- Quelle A: 00-verdikt Z.90 (AUF-A5)
- Quelle B: 03-ledger A, Z.8 — `artifact_cache.hpp:83`, `:233-262`; `observe()` feuert nur fuer frische, nicht-skipped Bauten (`cache_engine_builder_iterator.hpp:963`)

**B26 — `write_fingerprint_sidecar` schreibt ohne Newline; eine Datei mit `\n` ergibt 129 Zeichen -> `key_from_hex` scheitert -> stiller `no_key`.**
- Quelle A: 00-verdikt Z.88 (AUF-A3)
- Quelle B: 03-ledger A2, Z.7
- Code-Anker: `build_orchestrator.hpp:295-306`, `:298`, `:543`, `builder_registration.hpp:85-87`, `bestandslog_index.hpp:113-117`

**B27 — Typ-Namenskollision: erwartet `std::function<std::optional<std::string>(std::filesystem::path const&)>` (`cache_engine_builder_iterator.hpp:216`), nicht `ex::FingerprintFn` (`build_orchestrator.hpp:174`, string->string).**
- Quelle: 00-verdikt Z.89 (AUF-A4)

**B28 — `fingerprint_sidecar_path` liegt heute in `build_orchestrator.hpp:298-300`; K7 (CODE-NAEHTE R7) behauptet "kein dritter Weg", das Verdikt behauptet, der dritte Weg existiere.**
- Quelle: 00-verdikt Z.61-62 (K7)

**B29 — Reihenfolge-Entwarnung: `write_fingerprint_sidecar` (`build_orchestrator.hpp:543`) laeuft vor `finalize` (`:548`); `finalize` ruft dort erst `on_binary_done_` (`:399`) -> das Sidecar existiert, wenn `key_of` es liest. `id` mit `/` ist emit-sicher (`bestandslog_document.hpp:310-311` XML-encodet).**
- Quelle: 05-adversarial Z.128-131 (Entwarnungen mit Beleg)

**B30 — Prioritaets-Reihung des ADVERSARIAL-Berichts:** Lens 2 (Gate haengt faktisch nur am Doc-Key + quadratischer Merge im Messlauf) > Lens 3d (Voll-Wipe) > Lens 4 (kein try/catch) > Lens 3a/3c > Lens 5 > Lens 6a > Lens 1.
- Quelle: 05-adversarial Z.135

**B31 — K8: Keine der beiden Blocker-Listen ist vollstaendig — LEDGER erwaehnt weder quadratischen Merge noch Voll-Wipe; ADVERSARIAL erwaehnt D-0 gar nicht.**
- Quelle: 00-verdikt Z.64

Gelesene Quelldateien (absolut):
`/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/backups/20260726-g4b-planung-workflow/ergebnisse/00-verdikt-abeddd8c.md`
`/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/backups/20260726-g4b-planung-workflow/ergebnisse/05-adversarial-a01826ad.md`
`/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/backups/20260726-g4b-planung-workflow/ergebnisse/03-ledger-konformitaet-a32ab4df.md`

Selbstcheck: ASCII-only ausser `§` und `·`-freier Text; keine Kastenzeichen, keine Gedankenstriche, keine Emojis. Nur Extraktion, keine Bewertung. Keine Datei geaendert, kein Report-File geschrieben.