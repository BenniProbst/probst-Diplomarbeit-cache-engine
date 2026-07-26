## ADVERSARIAL-BEFUND G4b-Schnitt (R1)

Alle Pfade unten sind literal im Code nachgeprueft. CE = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine`, DRV = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/02_messung_driver/main.cpp`.

---

### LENS 1 -- Byte-/golden-Neutralitaet

**TEILWEISE ENTWARNUNG (Stufe 2) + BRUCH (Stufe 1, indirekt ueber die Env-Aktivierung).**

Entwarnung fuer die Stufe-2-Emission: `experiment_plan_director.hpp` hat GENAU EINEN `std::getenv` (Zeile 57 Include, Zeile 695 Aufruf), und der sitzt in `append_forward_var_literal` -- einem `static`-Member von `CiYamlBuilder` (Klasse endet Zeile 758). `TierCiYamlBuilder` (ab 788) und `TierCmakeGraphBuilder` (ab 1300) lesen KEINE Env. `--emit-tier-ci`/`--emit-tier-cmake`-Bytes sind also env-unabhaengig; eine Reservierung daneben aendert sie nicht.

**BRUCH-Szenario (konkret):**
Input: um (d2) ueberhaupt scharf zu bekommen, muss `COMDARE_BESTANDSLOG=true` (+DOC_KEY/OWNER_UUID/MASCHINE) in der Planer-/CEB-Prozess-Env stehen.
Fehlverhalten: `experiment_plan_director.hpp:734-738` brennt diese vier Werte zur Emissionszeit LITERAL in den `ceb:trigger`-`variables:`-Block der **Stufe-1**-YAML. Diese wird in `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/.gitlab-ci.yml:1265` als `"$DRIVER" --dump-ci ... > planer-child-ci.yml` erzeugt. Heute ist `COMDARE_BESTANDSLOG` in der super-CI **nirgends** gesetzt (verifiziert: `grep -rn BESTANDSLOG` ueber alle `.yml`/`.sh` ausserhalb `libs/` liefert nichts) -> der Block entfaellt. Mit G4b-Aktivierung erscheint er -> `planer-child-ci.yml` ist nicht mehr byte-identisch.
Das ist zwar der von G4a gewollte Forward-Mechanismus, aber es widerlegt die Zusage "KEINE Emissions-Byte-Aenderung" fuer die Stufe-1-Strecke, sobald (d2) betrieblich benutzt wird. Die Zusage gilt nur fuer den Code, nicht fuer den Betriebszustand, den (d2) erzwingt.

**Zweiter, schaerferer Bruch (Implementierungsfalle, hoch wahrscheinlich):**
`emit_tier_ci_facade` schreibt die YAML auf `std::cout` (`profile_run_facade.cpp:770`), und die CI leitet `stdout` in das Artefakt um (`experiment_plan_director.hpp:681`). Der bestehende Hausstil an der Injektions-Stelle, die (d1) explizit nennt, ist `std::cout` -- `main.cpp:871`: `std::cout << "[E4] Storage #51 aktiv: ..."`. Wird dieses Muster in (d2) kopiert (`[bestandslog] reserviert ...`), landet die Zeile als erste Zeile der `tier-child-*.yml` -> GitLab `config_error`, leeres failed Grandchild. Pflicht-Auflage: in (d2) **ausschliesslich `std::cerr`**. Der Iterator macht das bereits richtig (`cache_engine_builder_iterator.hpp:993` schreibt nach `cerr`), `artifact_cache.hpp:889` (`log_artefakt_io`) ebenfalls, und `run_argv` (`artifact_cache.hpp:856-859`) leitet mc-stdout in eine Datei -- mc selbst verschmutzt also nichts.

**Test-Regression (Lens 1, hart):** `CiYamlBuilder.NoCiProjectDirInVariablesBlockBothStages` (`tests/unit/thesis_tiere/test_experiment_plan_director.cpp:1175`), `YamlIsByteDeterministic` (:807), `SingleComboCebEmitOmitsMeasurementComboSelectorForByteStability` (:1722) rufen `unset_g4a_forwarded_opt_ins()` NICHT auf (nur :669, :732, :748, :803 tun das). Laeuft der Unit-Test-Job in einer Pipeline, in der `COMDARE_BESTANDSLOG` als Projekt-/Pipeline-Variable gesetzt ist -- genau der Zustand, den (d2) verlangt -- faerbt sich :1175 rot (der isolierte `variables:`-Block enthaelt dann zusaetzliche Zeilen und die Substring-Annahmen verschieben sich).

---

### LENS 2 -- Mess-Synchronitaet §65 / W-Doktrin

**BRUCH, und der schwerste des Pakets. Er sitzt in (d1), nicht in (d2).**

`cache_engine_builder_iterator.hpp:927-929`:
```
bool const bestandslog_active = static_cast<bool>(cfg.bestand_transport.fetch) &&
                                static_cast<bool>(cfg.bestand_transport.store) &&
                                static_cast<bool>(cfg.bestand_key_of) && !cfg.bestand_doc_key.empty();
```
Und `:979-982`:
```
if (bestandslog_active) builds = run_planer_driven_provision(orch, view, indices, cfg, result.build_stats);
else                    builds = orch.provision_all(view, ...);
```

**(2a) Das Gate ist faktisch nur `!doc_key.empty()`.** `make_bestand_transport` (`artifact_cache_transport.hpp:37-53`) belegt **alle vier** `std::function` bedingungslos -- auch auf einer inerten Instanz. Der bestehende Test beweist das: `tests/unit/test_g3_artifact_cache_transport.cpp:47-55` (`BinderPopulatesAllFourVerbs` auf `at::ArtifactCache const cache;` ohne Env). `make_fingerprint_key_fn()` aus (A) ist ebenfalls immer non-null (sie liefert `nullopt` erst *pro Aufruf*). Wenn (d1) den Transport an der von (d1) genannten Stelle injiziert -- `main.cpp:852` `if (!artifact_cache->inert()) { ... }` -- dann haengt `bestandslog_active` allein an einem nicht-leeren `COMDARE_BESTANDSLOG_DOC_KEY` und **nicht** am Gate `COMDARE_BESTANDSLOG=true`. Ein Default-Doc-Key an irgendeiner Stelle kippt das ganze Bauverfahren still um.

**(2b) Der Umschalt-Effekt ist kein Log, sondern ein anderer Bau-Treiber.** `run_planer_driven_provision` (`cache_engine_builder_iterator.hpp:808-876`) macht pro 4096er-Fenster **zwei** `store_reservation` (:837 pro-forma, :869 done). Jedes `store_reservation` (:818-824) ist ein `store_document_merged` = `fetch` + `store` = 4 mc-Prozess-Spawns (`object_fetch` -> `mc_remote_exists` + `mc_pull`; `object_store` -> `mc_cp` + `mc_size_verified`). Diese Phase laeuft **auch im Mess-Modus** (der Bau-Abschnitt ist nicht auf `provision_only` gegated; nur der `AsyncPushPump` ist es, `:953-954`). Bei golden N=2^17 = 32 Fenster -> 64 Dokument-Roundtrips -> ca. 256 synchrone mc-Shellouts mitten in einem Messlauf. Das ist genau die I/O-Contention, die §65/W-Doktrin ausschliesst ("nur MinIO async").

**(2c) Quadratischer Merge.** `bestandslog_lock.hpp:229-237`:
```
out.bestand = a.bestand;
for (auto const& be : b.bestand) {
    auto it = std::find_if(out.bestand.begin(), out.bestand.end(), ...same_eintrag_identity...);
```
O(|a| * |b|). `LagerRunState::flush` (`builder_registration.hpp`) uebergibt als `local.bestand` **alle** frisch registrierten Binaries des Laufs. Ein voller golden-Bau: |b| = 131072, |a| waechst mit -> ~8.6e9 Vergleiche von 128-hex-Strings plus drei weiteren Feldern, single-threaded, im Mess-/Bau-Prozess. Auf der zweiten Maschine (|a| = 131072 vorbestueckt) sind es ~1.7e10. Dazu `emit_document` (`bestandslog_document.hpp:269-338`), das aus 131072 Eintraegen einen ~35-40 MB XML-String baut, ihn in `/tmp` schreibt und per `mc cp` hochlaedt -- pro flush, und `store_document_merged` laedt ihn vorher komplett herunter. Das ist kein Overhead, das ist ein zweiter Arbeitslauf neben der Messung.

**Belastbarer Ausweg:** (d1) muss das Gate explizit an `COMDARE_BESTANDSLOG=="true"` haengen -- exakt nach dem Muster, das `profile_run_entry.hpp:311-316` (`lazy_fingerprint`) und `:325-330` (`variant_gate_sig`) bereits vorleben -- und den Transport bei ausgeschaltetem Gate gar nicht erst binden (nicht nur den Doc-Key leer lassen).

---

### LENS 3 -- Multi-Maschinen

**BRUCH, vier unabhaengige Szenarien.**

**(3a) Lost Update, kein CAS.** `store_document_merged` (`bestandslog_lock.hpp:262-276`) ist ein unatomares read-modify-write ohne Lock am Aufrufer (`run_planer_driven_provision:823` nimmt **kein** `try_acquire_lock`). Zwei Planer auf prod1/prod2 mit `--emit-tier-ci`:
- t0: A `fetch` -> rev 5, B `fetch` -> rev 5
- t1: A `store` rev 6 = {A-plan offen}
- t2: B `store` rev 6 = {B-plan offen} -- S3 last-writer-wins, **A-plan ist weg**

Der Union-Merge schuetzt nur *innerhalb* eines Merge, nicht gegen zwei Merges auf derselben Basis. Damit faellt genau die Garantie, die der Schnitt begruendet (`experiment_plan_director.hpp:1250`: "damit ein zweiter Planer auf einer anderen Maschine nicht dieselbe Strecke doppelt reserviert"). Der Kopf-Kommentar `bestandslog_lock.hpp:12-20` nennt das Restfenster ehrlich und begruendet die Harmlosigkeit mit "(b) Artefakt-Pushes sind idempotent" -- das gilt fuer Binary-Bytes, **nicht** fuer eine Belegungs-Aussage.

**(3b) Advisory ohne Leser.** Der genehmigte Schnitt (d2) registriert + terminiert, prueft aber nirgends auf einen **fremden** offenen `planer_block`. Mit L2 (`id = owner_uuid + "/plan/" + doc_key`) haben prod1 und prod2 verschiedene `owner_uuid` -> verschiedene ids -> `merge_documents` (`:242-249`) behaelt beide -> beide Planer fahren die Strecke. Die Reservierung ist reine Dokumentation, keine Sperre. Wenn das gewollt ist, muss es so heissen; wenn nicht, fehlt der `is_reservation_takeable`-Check (`reservation_lifecycle.hpp:113-119`) vor dem Emit.

**(3c) OWNER_UUID leer -> Kollaps statt Kollision.** Kein Code validiert `bestand_owner_uuid` (verifiziert: nur Deklaration `cache_engine_builder_iterator.hpp:225` und Verwendung `:832`). Fehlt die Var, ist die id auf ALLEN Maschinen identisch (`"/plan/lager/bestand.xml"` bzw. `"/0"`, `"/1"`, ... im I1b-Pfad). `detail::pick_reservierung` (`:200-208`) waehlt dann nach Status-Rang: prod1s `done` ueberschreibt prod2s `offen` -> ein laufender Slice erscheint fertig. Schlimmer im Lock: `parse_lock` (`:104-137`) akzeptiert `owner=` mit leerem Wert (`have_owner` wird gesetzt), und `try_acquire_lock:153` vergleicht `existing->owner_uuid != me.owner_uuid` -> `"" == ""` -> **jede Maschine haelt jeden fremden Lock fuer den eigenen**; `release_lock:173` loescht dann fremde Locks. Wechselseitige Exklusion vollstaendig ausgeschaltet.

**(3d) Voll-Wipe durch Versionsdrift.** `parse_bestandslog` gibt `nullopt` bei **unbekanntem** `typ`/`status`/`genus` zurueck (`bestandslog_document.hpp:353, 379, 390`). `store_document_merged:269` behandelt "remote unlesbar" als `to_write = local` -- der komplette Fremdbestand wird ueberschrieben. G4b (d2) ist der **erste Schreiber** von `typ="planer_block"` in das geteilte Dokument (verifiziert: `make_planer_block_reservation` wird heute nur in Tests aufgerufen; `run_planer_driven_provision:832` schreibt `BatchTyp::tier`). Ein Runner/eine Maschine mit einem CE-Pin **vor** Commit `351855b8` (dem Commit, der `planer_block` einfuehrte) liest das Dokument nicht mehr, haelt es fuer unlesbar und ersetzt es durch seinen Ein-Datensatz-Stand. Ergebnis: gesamter Binary-Bestand aller Maschinen geloescht. Das ist ein Datenverlust-Pfad, den erst (d2) aufmacht.

---

### LENS 4 -- Fehlerpfad / PromiseGuard-Terminalitaet

**BRUCH gegen L1, verifiziert.**

`DRV:315` `int main(...)`. Die einzigen `try`/`catch` im Treiber liegen bei `:379-391` (`--chunk-organ-fingerprint`) und `:813-1077` (E4-Block). Die Zweige `--emit-tier-ci` (`:439-452`) und `--emit-tier-cmake` (`:457-470`) liegen in der argv-Schleife `:319-471` und sind von **keinem** `try` umschlossen.

BRUCH-Szenario: `emit_tier_ci_facade` (bzw. der Director-Walk darunter) wirft -- `std::bad_alloc`, ein Filesystem-Fehler, oder ein `std::runtime_error` aus dem Profil-/Registry-Pfad. Die Exception verlaesst `main` -> `std::terminate`. Der Standard verlangt **kein** Stack-Unwinding vor `terminate`, und libstdc++/GCC unwinden hier nicht. Folge: der `PromiseGuard`-Destruktor (`reservation_lifecycle.hpp:137-145`) feuert nie, `on_abort_` laeuft nicht, die Reservierung bleibt `status=offen` bis die 30-Minuten-pro-forma-Frist (`kProFormaMinutes = 30`, `:33`) abgelaufen ist. Auflage L1 ("Terminalitaet auch im Fehlerpfad") ist damit nicht erfuellt, solange (d2) den Emit-Zweig nicht in ein eigenes `try/catch(...)` legt.

**Entwarnung Teil 2 (Transport-Fehler / Netz weg):** haengen tut der Emit nicht, aber er verzoegert messbar und scheitert still.
- `~PromiseGuard` faengt Ausnahmen aus `on_abort_` (`:139-144`) -- kein `terminate` aus dem dtor. Korrekt.
- `store_document_merged` gibt bei Store-Fehler `nullopt` zurueck; `store_reservation` (`cache_engine_builder_iterator.hpp:823`) verwirft das mit `(void)`. (d2) darf das nicht kopieren, sonst ist eine gescheiterte Reservierung unsichtbar.
- Zeitbudget: `object_store` -> `mc_cp` (`artifact_cache.hpp:690-696`) mit `tries_ = 12`, `sleep_s_ = 5` (`:952-953`). Jeder Versuch: `mc cp` (Cap `mc_push_timeout_s_ = 120`) + `mc_size_verified` (weitere 120s) + 5s Pause. Worst Case pro Store ca. **49 Minuten**. Und: `probe_timeout` (`:575-584`) aktiviert den `timeout`-Wrapper nur, wenn das `timeout`-Binary vorhanden ist -- fehlt es im Runner-Image, gibt es **gar keinen** Wall-Clock-Cap (`:556`: `if (!timeout_available || timeout_s == 0 ...) return argv;`), dann haengt `--emit-tier-ci` an einem TLS-Blackhole tatsaechlich unbegrenzt. (d2) sollte fuer den Emit-Pfad `COMDARE_ARTEFAKT_TRIES=1` setzen.

---

### LENS 5 -- Lock-Semantik §62-N7 (Millisekunden-Regel)

**BRUCH.**

Der heutige I1b-Pfad nimmt gar kein Lock. Sobald (C)/(d2) eine "Reservierungsrunde" mit `try_acquire_lock` einfuehrt, sieht die kritische Sektion so aus:

`try_acquire_lock` (`bestandslog_lock.hpp:149-167`) = fetch + evtl. remove + store + Zweit-Verify-fetch, danach `store_document_merged` (fetch + store des **ganzen** Dokuments), danach `release_lock` (fetch + remove). Das sind ca. 15-25 mc-Prozess-Spawns. Bei einem gewachsenen Bestandslog (~35-40 MB XML, s. Lens 2c) kommen zwei volle Down-/Uploads dazu.

Der harte Bruch: `LockRecord.ttl_s = 30` (`bestandslog_lock.hpp:84`). Die kritische Sektion enthaelt einen `object_store`, dessen Worst Case (12 Retries) ~49 Minuten betraegt -- **drei Groessenordnungen ueber der TTL**. `lock_is_stale` (`:139-141`) erklaert den Lock nach 30 s fuer brechbar, `try_acquire_lock:155-156` bricht ihn dann von jeder anderen Maschine -> zwei Schreiber in derselben Sektion -> exakt das Lost-Update aus 3a, nur jetzt mit dem falschen Gefuehl von Exklusivitaet. Auch im gesunden Fall (~2 s Sektion) ist "Millisekunden" nicht haltbar. Wenn die ETA-Berechnung (`apply_calibration`, `reservation_lifecycle.hpp:86-89`) mit in die Sektion faellt, wird es nicht besser -- die ist zwar rein, aber sie steht zwischen zwei I/O-Bloecken.

Empfehlung fuer den Schnitt: fuer den `planer_block` **kein** Lock nehmen (das Union-Merge-Argument traegt hier genauso wenig und genauso viel wie im I1b-Pfad), oder TTL an das reale Store-Budget koppeln und das Retry-Budget in der Sektion auf 1 kappen.

---

### LENS 6 -- Env-Gate-Neutralitaet / Halb-Zustaende

**BRUCH, drei saubere Halb-Zustaende.**

**(6a) Gate an, Storage nicht scharfgeschaltet -> stille Nullwirkung.** `emit_storage_activation` (`experiment_plan_director.hpp:888-893`, aufgerufen nur `:988` Build-Batch und `:1117` Mess-Batch) wird im `ceb:emit`-Job (`:654-688`) -- genau dem Job, der `--emit-tier-ci` faehrt -- **nicht** emittiert. `comdare_storage_activation.sh` ist aber das, was aus der S3-URL den mc-Alias `prodcache` + `MC_HOST_prodcache` macht. Zwei Faelle:
- Ohne MinIO-Vars: `minio_enabled()` false -> alle vier Verben liefern `false`/`nullopt` (`artifact_cache.hpp:487, 507, 535, 543`) -> `store_document_merged` -> `nullopt` -> (d2) verwirft es -> der Planer glaubt reserviert zu haben, im Store steht nichts. Die Multi-Maschinen-Aussage ist Fiktion.
- Mit MinIO-Vars (Projekt-288-CI-Variablen sind projektweit, also auch im Child/Grandchild sichtbar; `.gitlab-ci.yml:568` dokumentiert `COMDARE_MINIO_ENDPOINT(=S3-URL)`): `minio_enabled()` ist **true**, aber `mc_target` (`artifact_cache.hpp`, `endpoint_ + "/" + bucket_ + "/" + key`) baut `https://host:9000/bucket/key` -- keinen mc-Alias. `MC_HOST_prodcache` ist ungesetzt. Jeder mc-Aufruf scheitert -> 12 Retries a 5 s Pause pro Store, zweimal pro Reservierung -> ca. 2 Minuten stiller Leerlauf pro `--emit-tier-ci`, im Trace nur `[Infra-Fehler: artefakt_io]`-Zeilen auf stderr (`artifact_cache.hpp:889-895`).

**(6b) `COMDARE_BESTANDSLOG=true`, `DOC_KEY` fehlt.** `bestandslog_active` = false (Doc-Key leer), aber `lazy_fingerprint` ist scharf (`profile_run_entry.hpp:311-316` prueft nur `COMDARE_BESTANDSLOG`) -> `.fingerprint`-Sidecars werden geschrieben (`build_orchestrator.hpp:543`). Byte-neutral bleibt es trotzdem: `push_tier_binary` (`artifact_cache.hpp:228-263`) pusht nur `perm.dll`, `perm.dll.algos`, `perm.dll.version` -- `.fingerprint` und `.variant` nie. Objekt-Inventar driftet also nicht. **Entwarnung fuer die Byte-Frage, Halb-Zustand bleibt** (lokale Dateien ohne Konsument).

**(6c) `OWNER_UUID`/`MASCHINE` fehlen** -> siehe 3c. Kein Fallback, keine Pruefung, sondern stille Identitaets-Kollision. (B) muss hier fail-loud sein: Gate an + eine der drei Pflicht-Vars leer => harter Abbruch mit Fehlerklasse, nicht Halb-Aktivierung.

---

### Zusaetzlich: zwei Punkte, die der Schnitt so nicht bauen kann

**(i) L2 kollidiert mit einem gepinnten Test.** `make_planer_block_reservation` (`experiment_plan_director.hpp:1263-1270`) baut `id = owner_uuid + "/" + std::to_string(seq)` aus `(std::string, std::size_t, ...)`. L2 verlangt `owner_uuid + "/plan/" + <doc-Schluessel>`. Aus dieser Signatur ist das nicht herstellbar. Zwei Folgen, beide melde-pflichtig:
- Signatur aendern -> `tests/unit/thesis_tiere/test_experiment_plan_director.cpp:1502` (`EXPECT_EQ(r.id, "6f1c2b3a-.../7") << "id = owner_uuid/seq"`) und `:1517-1519` (Uhrfreiheits-Vergleich) gehen rot.
- Oder der Treiber ruft `bl::make_pro_forma_reservation` direkt -> die G4a-7-Funktion wird toter Code und die im Kommentar `:1252-1257` festgeschriebene Doktrin ("der ce liefert den WERT, der Host fuehrt den Effekt aus") ist gebrochen.

**(ii) Lebensdauer-Falle in (d1).** `make_bestand_transport` haelt eine `const&` auf den Cache (`artifact_cache_transport.hpp:20-24, 37`). An der (d2)-Stelle gibt es noch keine Cache-Instanz -- die entsteht erst bei `main.cpp:840`, tief im E4-Block. `make_bestand_transport(at::ArtifactCache::from_env())` waere die naheliegende Ein-Zeilen-Schreibweise und ergibt vier dangling Lambdas. Der Emit-Zweig braucht eine eigene, benannte, den Guard ueberlebende Instanz.

**Entwarnungen mit Beleg (damit nicht nachgeforscht wird):**
- `(A)` Kontrakt "fehlt/leer => nicht registriert" haelt: `LagerRunState::observe` verwirft leere und nicht-128-hex Keys (`builder_registration.hpp`, `if (key_hex.empty()) return DedupOutcome::no_key;` + `lager_key_from_hex`). Kein Phantom-Leereintrag trotz `key.value_or(std::string{})` an `cache_engine_builder_iterator.hpp:969`.
- Reihenfolge stimmt: `write_fingerprint_sidecar` (`build_orchestrator.hpp:543`) laeuft **vor** `finalize` (`:548`), und `finalize` ruft erst dort `on_binary_done_` (`:399`). Das Sidecar existiert also, wenn `key_of` es liest.
- `id` mit `/` ist emit-sicher: `emit_document` XML-encodet die id (`bestandslog_document.hpp:310-311`).
- mc verschmutzt `stdout` nicht: `run_argv` haengt Kind-`stdout` an eine Datei und dupt `stderr` dorthin (`artifact_cache.hpp:856-859`).

---

**Prioritaet:** Lens 2 (Gate haengt faktisch nur am Doc-Key + quadratischer Merge im Messlauf) > Lens 3d (Voll-Wipe bei Versionsdrift) > Lens 4 (kein try/catch um den Emit-Zweig) > Lens 3a/3c > Lens 5 > Lens 6a > Lens 1.

Selbstcheck: `grep -P '[^\x00-\x7F]'` ueber diese Meldung -- nur `§` (erlaubt); keine `─`/`—`/Emojis.