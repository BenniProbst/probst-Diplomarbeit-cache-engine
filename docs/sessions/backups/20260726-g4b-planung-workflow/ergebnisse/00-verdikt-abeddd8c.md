# VERDIKT G4b + W-30 + W-13 (Synthese aus 5 Pruef-Berichten, 2026-07-26)

**Kurzfassung:** G4b wird **geteilt**. **G4b-1 = (A) + (B) + (C) + (D)(d1): GO unter 16 Auflagen und mit ZWINGENDER Schnitt-Erweiterung von 4 auf 7 Dateien.** **G4b-2 = (D)(d2) planer_block: NO-GO / HOLD** bis 5 KERN-Entscheide des Architekten gefallen sind; (d2) ist in der vorgelegten Form an der falschen Vertragsebene verankert, mit einer nicht baubaren id und einem Datenverlust-Pfad. **W-30: gebaut, aber ohne Wirkung auf die 320er-Dauer.** **W-13: JA, fixen, und zwar als LETZTE Aenderung vor dem Voll-Bau-4-Trigger.**

---

## 0. EIGENE NACHPRUEFUNGEN (zur Aufloesung der Widersprueche, literal)

```
Code/02_messung_driver/main.cpp
 840:  auto const artifact_cache = std::make_shared<at::ArtifactCache>(at::ArtifactCache::from_env());
 852:  if (!artifact_cache->inert()) {
 962:  xa.cache_push       = cache_push;    963: xa.cache_pull  964: xa.measurement_sink
1056:  pa.cache_push       = cache_push;   1057: pa.cache_pull 1058: pa.measurement_sink

libs/cache_engine/profile_facade/profile_run_facade.hpp
  35: struct ProfileRunArgs        75/76/77: cache_push / cache_pull / measurement_sink
 111: struct ExperimentRunArgs    140/141/142: dieselben drei
libs/cache_engine/profile_facade/profile_run_facade.cpp
 559-561: a.cache_push/cache_pull/measurement_sink = args....   (pa-Pfad)
 907-909: dieselben drei                                        (xa-Pfad)
grep -c "bestand" libs/cache_engine/profile_facade/experiment_run_entry.hpp  ->  0

libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp
1264: make_planer_block_reservation(std::string owner_uuid, std::size_t seq, ...)
1268:   std::move(owner_uuid) + "/" + std::to_string(seq), bl::BatchTyp::planer_block, ...
   (= duenner Wrapper um bl::make_pro_forma_reservation, KEIN eigener Wert-Aufbau)

tests/unit/CMakeLists.txt (Target test_g3_artifact_cache_transport)
  include_directories: libs/cache_engine/builder | .../include | .../src | libs/common
  (profile_facade NICHT enthalten -- literal bestaetigt)

grep -rn "COMDARE_BESTANDSLOG" --include=*.yml --include=*.yaml --include=*.sh \
        --include=*.cmake --include=*.xml --include=*.bat  ueber das super-Repo
  ->  KEINE AUSGABE (0 Treffer). Einziger Leser: profile_run_entry.hpp:312.
      Forwards: experiment_plan_director.hpp:734-737. KEIN SETZER EXISTIERT.
```

---

## 1. WIDERSPRUECHE ZWISCHEN DEN BERICHTEN (explizit, mit Aufloesung)

**K1 -- (d1)-Anker.** ADVERSARIAL (Lens 2a) behandelt `main.cpp:852` als die Injektionsstelle. LEDGER und CODE-NAEHTE sagen: `:852-876` baut nur die Closures, injiziert wird bei `:962-...` / `:1056-...`. LEDGER nennt `:962-966`/`:1056-1060`, CODE-NAEHTE `:962-968`/`:1056-1062`.
**Aufloesung (nachgeprueft):** die literalen Zuweisungen stehen auf **962-964 (xa)** und **1056-1058 (pa)**; `:852` ist das `if (!artifact_cache->inert())` des Closure-Baus. Der urspruengliche Schnitt-Anker `:841-870` ist falsch. ADVERSARIALs Lens-2a-Schlussfolgerung (Gate haengt faktisch nur am doc_key) bleibt trotz falscher Zeile **inhaltlich richtig**.

**K2 -- Umfang von (B). Harter Widerspruch.** LEDGER haelt `profile_run_entry.hpp` allein fuer ausreichend und "konform". CODE-NAEHTE R1 nennt es BLOCKER: die Naht ist dreischichtig.
**Aufloesung: CODE-NAEHTE hat recht** -- und zwar mit dem Beleg, den LEDGER selbst als Praezedenz anfuehrt: `cache_push/cache_pull/measurement_sink` existieren in `profile_run_facade.hpp:75-77`, werden in `profile_run_facade.cpp:559-561` kopiert und liegen erst dann in `profile_run_entry.hpp:98-100`. Der genehmigte 1-Datei-Schnitt (B) **kompiliert nicht**. Schnitt-Erweiterung ist Pflicht, nicht Ermessen.

**K3 -- owner_uuid. Diametral entgegengesetzte Annahmen.** LEDGER D-2: alle Maschinen eines Plans teilen EINE owner_uuid (Director reicht sie literal weiter) -> Kollision, zweiter Claim verschwindet. ADVERSARIAL 3b: prod1/prod2 haben VERSCHIEDENE owner_uuid -> verschiedene ids -> keiner blockt den anderen, reine Dokumentation.
**Aufloesung: keine der beiden Annahmen trifft heute zu -- die Variable wird NIRGENDS gesetzt (0 Treffer, s.o.).** Der reale Default ist der dritte und schlimmste Fall (ADVERSARIAL 3c): leerer Wert auf allen Maschinen -> identische id -> `pick_reservierung` laesst `done` von prod1 das `offen` von prod2 ueberschreiben, und `try_acquire_lock` vergleicht `"" == ""`, haelt also jeden fremden Lock fuer den eigenen (`release_lock` loescht dann fremde Locks). Beide Berichte beschreiben Folgezustaende, die erst eintreten, wenn jemand die Variable setzt. **Konsequenz: Maschinen-Identitaet als EIGENES Feld (§66-N3), und leerer Wert => Verweigerung, nicht Degradierung.**

**K4 -- N7-Schreib-Lock. Harter Widerspruch.** LEDGER D-3 macht `try_acquire_lock`/`release_lock` zur Pflicht. ADVERSARIAL Lens 5 zeigt, dass genau das die Lage verschlechtert: `LockRecord.ttl_s = 30`, die kritische Sektion enthaelt einen `object_store` mit Worst Case ~49 min (12 Retries a 5 s + 2x120 s Timeout) -- drei Groessenordnungen ueber der TTL -> jede andere Maschine erklaert den Lock fuer stale und bricht ihn -> zwei Schreiber in der Sektion, jetzt aber mit falschem Exklusivitaets-Gefuehl.
**Aufloesung ueber LEDGERs eigenen Alternativ-Zweig:** "ausdruecklicher, im Ledger vermerkter Aufschub nach #46b -- dann aber als KNOWN GAP melden, nicht stillschweigend." **Empfehlung: Aufschub, dokumentiert.** Ein Lock, dessen TTL das Retry-Budget der Sektion um Faktor ~100 unterschreitet, ist schaedlicher als kein Lock. Falls doch gelockt wird: Retry-Budget in der Sektion hart auf 1 kappen UND TTL an das reale Store-Budget koppeln -- beides KERN, nicht Impl.

**K5 -- Byte-Neutralitaets-Beweis.** LEDGER (c)5(iii) fordert "Emissions-Bytes unveraendert". ADVERSARIAL Lens 1 zeigt: fuer Stufe 2 stimmt das (verifiziert env-frei), fuer **Stufe 1 aendern sich die Bytes zwangslaeufig**, sobald `COMDARE_BESTANDSLOG` gesetzt ist -- der Director brennt die vier Werte in den `ceb:trigger`-`variables:`-Block (`:734-738`). CODE-NAEHTE R3 ergaenzt: heute ist der Beweis trivial, weil `bestandslog_active` immer false ist.
**Aufloesung: zweiteiliger Beweis.** (i) Code-Neutralitaet ohne Env: beide Stufen byte-identisch. (ii) Der Byte-DELTA der Stufe-1-YAML bei gesetzter Env ist ein **vorab genehmigter, dokumentierter Effekt** -- nicht etwas, das im Betrieb entdeckt wird.

**K6 -- `make_planer_block_reservation`. Trilemma, kein echter Widerspruch.** LEDGER C2: aus der Test-TU nicht erreichbar. CODE-NAEHTE R6: id-Form `owner_uuid + "/" + seq` kann L2 nicht erzeugen; Director-Include im Treiber ist teuer/riskant. ADVERSARIAL (i): Signatur aendern => `test_experiment_plan_director.cpp:1502/1517-1519` rot; `bl::make_pro_forma_reservation` direkt rufen => Funktion wird toter Code + Doktrinbruch.
**Aufloesung: es gibt einen vierten Weg, und er ist buildbar** (nachgeprueft: der Director-Helfer ist selbst nur ein 4-Zeilen-Wrapper um `bl::make_pro_forma_reservation`, und `builder/` liegt im Include-Satz des Test-Targets). Siehe AUF-E4. ADVERSARIALs Doktrin-Einwand ist ueberzogen: `bl::` **ist** ce; die Doktrin "ce liefert den Wert, der Host fuehrt den Effekt aus" ist auch dann gewahrt.

**K7 -- Platzierung von (A).** LEDGER A1: eigener Header, der Transport-Binder darf kein lokales `<filesystem>`-IO bekommen. CODE-NAEHTE R7: entweder schweren `build_orchestrator.hpp` ziehen oder das `".fingerprint"`-Suffix duplizieren -- "kein dritter Weg".
**Aufloesung: der dritte Weg existiert** -- `fingerprint_sidecar_path` (heute `build_orchestrator.hpp:298-300`) in einen leichten Header extrahieren, den `build_orchestrator.hpp` inkludiert. Single Source, kein Drift, kein schwerer Include. Kostet 1 neue Datei + 1 Include-Zeile.

**K8 -- gegenseitige blinde Flecken.** LEDGER blockt auf D-0..D-4 und erwaehnt **weder** den quadratischen Merge **noch** den Voll-Wipe. ADVERSARIAL priorisiert Lens 2/3d und erwaehnt **D-0 gar nicht**. Keine der beiden Blocker-Listen ist vollstaendig; **die Vereinigung ist die Blocker-Liste**.

**K9 -- Innere Inkonsistenz des Schnitts selbst.** Der Schnitt begruendet den Ausschluss von `--dump-plan` mit "keine Fernwirkung an einem Inspektionsbefehl" (LEDGER nickt das ab). `--emit-tier-ci`/`--emit-tier-cmake` sind aber **ebenfalls reine Emissionsbefehle** -- sie bauen nichts und messen nichts. Dieselbe Begruendung schliesst (d2) an seinem eigenen Anker aus. Das stuetzt LEDGER D-0 unabhaengig.

---

## 2. G4b -- VERDIKT UND AUFLAGEN

### 2.1 Freigabe-Umfang

| Teil | Verdikt |
|---|---|
| (A) fingerprint-key_of | **GO** unter AUF-A1..A5 (Platzierung geaendert, Schnitt +1 Datei) |
| (B) Host-Verdrahtung | **GO nur als 3-Datei-Schnitt** unter AUF-B1..B6 |
| (C) Test-Erweiterung | **GO** unter AUF-C1..C3; der PFLICHT-Neutralitaetstest ist in dieser TU NICHT fuehrbar |
| (D)(d1) | **GO** unter AUF-D1 + AUF-B2/B3/B5/B6 |
| (D)(d2) planer_block | **NO-GO / HOLD** -- 5 KERN-Entscheide offen, 1 Datenverlust-Pfad |

Schnitt danach: **7 Dateien** (`fingerprint_sidecar.hpp` neu, `build_orchestrator.hpp` +1 Include, `bestandslog/fingerprint_key_source.hpp` neu, `profile_run_facade.hpp`, `profile_run_facade.cpp`, `profile_run_entry.hpp`, `test_g3_artifact_cache_transport.cpp`, `main.cpp`) -- ohne (d2). Das ist eine Schnitt-AENDERUNG und braucht ein ausdrueckliches GO, kein Agenten-Ermessen.

### 2.2 Auflagen -- direkt an den Impl-Agenten weiterreichbar

**AUF-A1** `make_fingerprint_key_fn()` **nicht** in `bestandslog/artifact_cache_transport.hpp`. Diese Datei definiert sich im Kopf (Z.2-13) als die EINE Kante bestandslog->artifact_transport; ein `key_of`, das eine lokale Sidecar-Datei liest, hat mit dem `ArtifactCache` nichts zu tun. Neuer leichter Header unter `libs/cache_engine/builder/bestandslog/`.
**AUF-A2** Drift-Freiheit gegen `".fingerprint"`: `fingerprint_sidecar_path` aus `build_orchestrator.hpp:298-300` in einen leichten Header extrahieren (gleicher Namespace `...builder::experiment`), `build_orchestrator.hpp` inkludiert ihn; der neue key_of-Header inkludiert **nur** diesen. Kein Suffix-Duplikat, kein `<thread>`/`<condition_variable>`/`spawn.h` im Binder.
**AUF-A3** Trim vor Validierung: gelesenen Inhalt von Whitespace/CR/LF befreien, dann exakt 128 hex pruefen, sonst `nullopt`. Grund: `write_fingerprint_sidecar` schreibt ohne Newline; jede fremd erzeugte Datei mit `\n` ergibt 129 Zeichen -> `key_from_hex` scheitert -> stiller `no_key`. Fehlerklasse dokumentieren.
**AUF-A4** Typ ist `std::function<std::optional<std::string>(std::filesystem::path const&)>` (`cache_engine_builder_iterator.hpp:216`), **nicht** `ex::FingerprintFn` (`build_orchestrator.hpp:174`, `string->string`). Namenskollision.
**AUF-A5** In die Paketmeldung als KNOWN GAP (nicht heilen): die maschinenuebergreifende 3-Stufen-Dedup (LED:3207) bleibt aus **zwei unabhaengigen Gruenden** unerfuellt -- (i) `.fingerprint` ist nicht Teil des Push/Pull-Objektsatzes (`artifact_cache.hpp:233-262` = perm.dll/.algos/.version), hydrierte Binaries tragen also nie einen Fingerprint; (ii) der LagerKey traegt weder `+cxx` noch `+bt` noch `+ceb` (W-13 F6), ist also groeber als der Objekt-Store-Schluessel.

**AUF-B1** Schnitt-Erweiterung PFLICHT auf drei Dateien, Muster exakt wie `cache_push/cache_pull/measurement_sink`: Felder in `profile_run_facade.hpp` neben `:75-77`; Durchreiche in `profile_run_facade.cpp` neben `:559-561`; Felder in `profile_run_entry.hpp` neben `:98-100`, Zuweisung neben `:458-460`/`:464-466`.
**AUF-B2** `xa` / `ExperimentRunArgs` / `experiment_run_entry.hpp` **nicht anfassen** (`grep -c bestand` = 0; braeuchte zwei weitere ungenehmigte Dateien). (d1) auf `pa` begrenzen. `xa` in der Paketmeldung **ehrlich als inert** ausweisen -- kein Verschweigen.
**AUF-B3** HARTES DOPPEL-GATE. Transport, `bestand_key_of` und `bestand_doc_key` werden **nur** belegt, wenn `COMDARE_BESTANDSLOG == "true"` (Muster `profile_run_entry.hpp:311-316`) **UND** `!artifact_cache->inert()`. Bei aus: gar nicht binden -- nicht bloss den doc_key leer lassen. Grund: `bestandslog_active` (`iterator:927-929`) prueft nur, dass vier `std::function` belegt sind, und `make_bestand_transport` belegt sie bedingungslos, auch auf einem inerten Cache (bewiesen: `test_g3_artifact_cache_transport.cpp:47-55`). Ohne Doppel-Gate haengt der Umschalt von `provision_all` auf `run_planer_driven_provision` (`:979-982`) allein an einem nicht-leeren Doc-Key.
**AUF-B4** FAIL-LOUD statt Halb-Zustand: Gate an **und** eine der Pflicht-Vars (`_DOC_KEY`, `_OWNER_UUID`, `_MASCHINE`) leer => harter Abbruch mit Fehlerklasse. Gate aus => stumm inert, keine Log-Zeile. (Vereinigt LEDGER D-7 und ADVERSARIAL 6c; die beiden Berichte forderten "inert" bzw. "Abbruch" -- die Trennlinie ist der Gate-Zustand.)
**AUF-B5** Lebensdauer: `make_bestand_transport` haelt `ArtifactCache const&` (Kopf Z.20-24). Nur im Scope des `shared_ptr` aus `main.cpp:840` binden. **Verboten:** `make_bestand_transport(at::ArtifactCache::from_env())` -- vier dangling Lambdas.
**AUF-B6** Log-Kanal: ausschliesslich `std::cerr`. `std::cout` ist im Emissions-Pfad der YAML-Kanal (`profile_run_facade.cpp:770`, Umleitung `experiment_plan_director.hpp:681`); der Hausstil an der Injektionsstelle verleitet dazu (`main.cpp:871` schreibt `[E4]` auf cout). Eine `[bestandslog]`-Zeile auf cout = GitLab `config_error`.

**AUF-C1** Der PFLICHT-Neutralitaetsbeweis ("ohne Env kein Transport, kein Schreibpfad") ist in dieser TU **nicht** fuehrbar -- die Entscheidung liegt in facade/entry/main. Zulaessiger Ersatz: **literaler Lauf-Log ohne Env plus Byte-Diff der Emissionen.** Kein Haken ohne literale Ausgabe. Was die TU beweist ("inerter Cache -> vier ehrliche Fehlschlaege") ist etwas anderes und darf nicht als dieser Beweis verkauft werden.
**AUF-C2** Zusatztests, alle dep-frei moeglich: Sidecar vorhanden / fehlt / leer / **mit `\n`**; Fake-Transport-Runde mit Union-per-id (`bestandslog_lock.hpp:262-276`); **MERGE-Aufloesung ueber Status-Rang** (`:190-208`) -- daran zerbricht L2; `pro_forma_deadline_epoch_s(reserviert, 30)` (`reservation_lifecycle.hpp:57-60`).
**AUF-C3** Keine CMake-Aenderung. Include-Satz literal: `builder`, `include`, `src`, `common` -- `profile_facade` fehlt. Mit AUF-E4 wird der planer_block-Wert **in dieser TU** testbar.

**AUF-D1** Anker korrigiert: Cache-Bau `:840`, Closure-Bau `:852-876` (hinter `if (!artifact_cache->inert())`), **Injektion pa `:1056-1058`**. `:841-870` aus dem Schnitt ist falsch, `:852` ist nicht die Injektionsstelle. `xa :962-964` bleibt unberuehrt (AUF-B2). Zeilennummern vor der Edit erneut literal verifizieren -- die drei Berichte nennen drei leicht abweichende Bereiche.

### 2.3 KERN-Entscheide vor jedem (d2)-Baubeginn (Architekt, nicht Impl)

**E1 -- Vertragsebene des planer_block.** LED:3221 blockt eine **CEB-Compile-Strecke**. `--emit-tier-ci`/`--emit-tier-cmake` sind ausweislich `main.cpp:433-438` die **CEB-Rolle**, die TIER-Jobs erzeugt; die CEB-Compile-Strecke emittieren `--dump-ci` (`:415`) / `--dump-cmake` (`:426`). Die Tier-Ebene hat ihre Reservierung bereits (`iterator:826-843`). Verstoss gegen die Ebenen-Trennung (LED:3308-3312) und LED:3229. Zusatzargument K9. **Entscheid: Anker verschieben oder Typ/Benennung korrigieren.**
**E2 -- id-Identitaet.** L2 (`owner_uuid + "/plan/" + doc_key`) ist (a) mit dem vorhandenen Helfer nicht erzeugbar (Signatur `owner_uuid + "/" + seq`, Zeile 1264-1269 literal) und (b) semantisch defekt: Merge-Monotonie (`pick_reservierung`, `bestandslog_lock.hpp:190-208`) laesst ein einmal terminales `done` jedes spaetere `offen` unter derselben id verwerfen -- die Reservierung ist genau **einmal** belegbar. Zu entscheiden: Run-Diskriminator in der id **plus** Maschinen-Identitaet als **eigenes Feld** (§66-N3, LED:3412-3413) **plus** Retention/Prune terminaler Records -- oder ein dokumentierter Re-Open-Uebergang, den der Merge respektiert.
**E3 -- "fuer diese Version".** LED:3221 blockt fuer eine Version, §62-D gibt der CEB den Replay-Schluessel `[a,b,c]`. Der Doc-Key identifiziert das Bestandslog, nicht die Strecke -> zwei Strecken unter einem doc_key teilen eine Block-id. `BatchReservierung` (`bestandslog_document.hpp:189-203`) hat kein Feld dafuer. POD-Wachstum (golden-Fenster/GO, Praezedenz K7b) oder dokumentiertes Interim.
**E4 -- Bereitstellung des Werts.** Empfehlung: **additive Wert-Funktion in einem LEICHTEN ce-Header unter `builder/bestandslog/`**, die eine explizite id entgegennimmt; `experiment_plan_director.hpp:1264` delegiert kuenftig dorthin. Ergebnis: gepinnte Tests (`test_experiment_plan_director.cpp:1502`, `:1517-1519`) bleiben gruen, kein toter Code, Doktrin gewahrt, im bestehenden Test-Target testbar, und der Treiber inkludiert **nicht** den Director-Header (`profile_run_facade.cpp:1` beansprucht, die einzige umbrella-ziehende TU zu sein).
**E5 -- N7-Lock.** Siehe K4. Empfehlung: dokumentierter Aufschub als KNOWN GAP mit Ledger-Eintrag.

### 2.4 Was (d2) zusaetzlich erfuellen muss, falls er spaeter freigegeben wird

- **30-Minuten-Frist echt setzen:** `pro_forma_deadline_epoch_s(reserviert, 30)`. Der Ist-Analog uebergibt fuer `reserviert_utc` und `pro_forma_bis_utc` **denselben** Wert (`iterator:834-836`, 2x `now_utc_iso()`) -> `is_pro_forma_expired` ist eine Sekunde spaeter true -> Takeover-Schutz wirkungslos. "Analog uebernehmen" wuerde den Defekt kopieren; der Tier-Pfad ist flankierend zu korrigieren.
- **Terminalitaet:** `store(offen)` -> Emission -> `rc==0 ? mark_done + store + commit : Guard laeuft in den Release`. **Code-Falle:** `return pf::emit_tier_ci_facade(...)` zerstoert den Guard erst nach Berechnung des Rueckgabewerts -> rc in eine lokale Variable.
- **`try/catch(...)` um den Emit-Zweig.** `main.cpp:439-452` und `:457-470` liegen in **keinem** try (die einzigen sind `:379-391` und `:813-1077`). Eine Exception aus `main` -> `std::terminate` ohne Unwinding -> `~PromiseGuard` feuert nie -> Reservierung bleibt 30 min haengen. L1 ("immer terminal") ist ohnehin zu stark formuliert: `_Exit`/`abort`/SIGTERM (CI-Cancel, Pipeline 11519) laufen am Guard vorbei; konstruktiv deckt das nur die Takeover-Regel -- die ihrerseits die echte 30-min-Frist voraussetzt.
- **Zweite, benannte `ArtifactCache`-Instanz**, die den Guard ueberlebt; die Emit-Zweige `return`en lange vor `:840`. Praezedenz `main.cpp:779`. Kein Key-Drift (`run_stamp_` betrifft nur `sink_measurement`/`push_chunk_partial_marker`).
- **`COMDARE_ARTEFAKT_TRIES=1` im Emit-Pfad.** Sonst Worst Case ~49 min pro Store (12 Retries a 5 s + 2x120 s); fehlt das `timeout`-Binary im Runner-Image, gibt es **gar keinen** Wall-Clock-Cap (`artifact_cache.hpp:556`).
- **Store-Ergebnis nie verwerfen.** `store_reservation` (`iterator:823`) castet den `nullopt`-Fall auf `(void)`. Eine gescheiterte Reservierung muss sichtbar sein.
- **`emit_storage_activation` fehlt im `ceb:emit`-Job** (`experiment_plan_director.hpp:888-893`, gerufen nur `:988`/`:1117`). Ohne mc-Alias `prodcache` ist die Reservierung dort entweder Fiktion (minio aus) oder ~2 min stiller Leerlauf (minio-Vars gesetzt, Alias fehlt). Ohne Fix ist (d2) im eigenen Job wirkungslos.
- **Kein Claim-CHECK, kein Takeover.** Der Schnitt registriert und terminiert, prueft aber nie ein **fremdes** offenes `planer_block`. `is_reservation_takeable`/`is_takeable_by_eta` sind gebaut, getestet und in keinem Produktionspfad gerufen. "Reservierung = VERSPRECHEN" (LED:3208) und LED:3220 bleiben Papier -- als OFFEN melden, falls G4b auf das §66-Gate G3 angerechnet wird.
- **Voll-Wipe-Pfad schliessen (Vorbedingung, nicht Auflage):** (d2) ist der **erste Schreiber** von `typ="planer_block"`. `parse_bestandslog` liefert bei unbekanntem `typ`/`status`/`genus` `nullopt` (`bestandslog_document.hpp:353/379/390`), und `store_document_merged:269` behandelt "remote unlesbar" als `to_write = local` -> eine Maschine mit CE-Pin vor `351855b8` loescht den gesamten Fremdbestand. **Mindest-Haertung: ein nicht-leeres, aber unparsbares Remote darf NIE ueberschrieben werden -- Abbruch mit Fehlerklasse.**

---

## 3. ENTSCHEID-VORLAGE W-30 (#45 paralleler MESS-Loop)

**Frage:** gebaut oder nicht -- und was folgt daraus fuer die Dauer des 320ers?

**Befund: GEBAUT, JA.** ce `99a608c2331a7dc71f648d4e910bb4c5f7115937`, 2026-07-21 20:47 UTC, enthalten in `development`, `main`, beiden GitHub-Spiegeln. Test `test_45_parallel_measure_loop` ausgefuehrt, EXIT=0, Schlusszeile literal:
`==== #45 paralleler Mess-Loop (collect_ordered/resolve/parse): ALLE OK ====`

**Ledger-Status "OFFEN" ist STALE, nicht falsch gewesen.** `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:3194` stammt aus der S6-P1(g)-Verifikation vom 20./21.07., also **vor** dem Commit. Der R9-Fix wurde im Code vollzogen (`run_methodology_registry.hpp:50`), im Ledger nie nachgezogen. Reiner Doku-Drift, keine Code-Regression. Verwechslungsquelle: `#45` ist dreifach ueberladen (SOSD-uint64-Loader, A2-Neben-Achsen, paralleler Mess-Loop).

**Entscheid (Vorlage zum Abnicken):**
1. `[X]` **GEBAUT bestaetigt.** Kein Bau-Auftrag.
2. `[X]` **Ledger `:3194` additiv nachziehen**, nicht loeschen: Vermerk "SUPERSEDIERT 2026-07-21 durch ce 99a608c2".
3. `[X]` **Konsequenz fuer die 320er-Dauer: KEINE. Zeitbudget unveraendert planen.**

**Begruendung zu 3 (der entscheidende Punkt):** der Pool zieht nur, wenn die effektive Methodik `debug` ist -- `resolve_measure_parallelism` (`measure_parallelism.hpp:25`) gibt bei `!measurement_on || single_thread` **0** zurueck. Der 320er ist ein BEWEIS-Lauf und faehrt measure/release, also strikt 1 Thread. Der rechnerische Gewinn (nproc=32 -> ~1/32 der Mess-Phase, ca. 11 min statt 6 h) faellt **ausschliesslich** in der Debug-/Verdrahtungs-Runde an, und Debug-Zahlen sind nach §61-MODI ausdruecklich keine gueltigen Messwerte. Weiter: parallelisiert werden die Mess-ZELLEN, nicht der Bau; der Bau war ueber `COMDARE_BUILD_PARALLEL` ohnehin in allen Modi parallel und bleibt der limitierende Posten. Skalierung ist zudem pro Mess-Fenster (`builds.size()`), nicht global ueber 320 -- bei Lanes/Chunks unter 32 Zellen ist der Speedup nur die Fenstergroesse.

**Einziger Wallclock-Hebel fuer den Beweis-Lauf bleibt prod1 + prod2 parallel (§61).**

**Operative Notizen fuer die Debug-Runde:** `COMDARE_PLAN_METHODIK_PROFILE` muss gesetzt sein (Override-Naht `profile_run_facade.cpp:470-479` -> `profile_run_entry.hpp:475`), sonst laeuft es sequentiell; Deckel ueber `COMDARE_MEASURE_PARALLEL=<n>`, **nicht** `COMDARE_BUILD_PARALLEL` (falsches Env, wirkungslos aufs Messen). Beleg im Lauf ist die stderr-Zeile `[#45] paralleler Mess-Loop (Debug): pool=N zellen=320 beobachtete-Spitze=M` -- fehlt sie, lief es sequentiell. **Nicht kombinieren mit aktivem Bestandslog** (siehe P-2): die Provisions-Phase wuerde vor dem Messen ~256 synchrone mc-Shellouts einschieben.

---

## 4. ENTSCHEID-VORLAGE W-13 (doppelte Perm-Suffix-Reihenfolge / Cache-Key)

**Frage:** Fix vor Voll-Bau-4 -- ja oder nein?

**EMPFEHLUNG: JA -- und zwar als LETZTE Aenderung vor dem Trigger.**

**Grund 1 (Reihenfolge, nicht Kosmetik -- der eigentlich entscheidende):** der Schnitt gibt der Perm-`.version` erstmals ein `+ceb` (R3) und erzwingt damit **einmalig einen Voll-Neubau aller Form-P-Binaries**. Nach Voll-Bau-4 durchgefuehrt, entwertet er exakt dessen Ergebnis. Davor durchgefuehrt, **ist** dieser Zwangs-Neubau der Voll-Bau-4. Es gibt kein billigeres Fenster -- die Kosten fallen so oder so an, nur einmal umsonst oder einmal nuetzlich.

**Grund 2 (Gueltigkeit des Beweises):** F3 -- Form P traegt kein `+ceb` in der `.version`, ein CEB-ABI-Bump invalidiert den Perm-Pfad **lokal nicht** -> `dll_is_current` (`build_orchestrator.hpp:472`) sagt "aktuell", kein Neubau, waehrend `cache_key_prefix` auf den neuen Contract wandert und `pull_tier_prefix` ins Leere greift. Alte `.so` werden unter neuem Contract gemessen. Betroffen ist `all_axes_golden`, also die golden-N-Reihe selbst.

**Grund 3 (das Vor-Gate validiert heute den falschen Pfad):** `all_axes_golden` deklariert `<system_axes>` -> Form P; die Smoke-Profile deklarieren keine -> Form S mit doppeltem `+ceb`. Der Smoke-Lauf prueft damit heute **nicht** den Key-Pfad des golden-Laufs (F1/F2/F5). Nach dem Schnitt tut er es. F2 ist dabei kein blosser Miss, sondern ein Pull-Fehlschlag **mit** Skip: `[dedup] HIT ... SKIP`, `mc cp --recursive` zieht nur den Marker, PULL_DST leer, Stufe 2 uebersprungen, Mess-Batch findet keine `.so`.

**Schnitt (minimal):** eine neue env-freie Wahrheits-Funktion `profile_facade/system_version_suffix.hpp` mit `build_version_suffix(cxx_tag, opt_id, simd_id, target_isa_id, telemetry_silent)`; Umstellung von (1) `profile_run_entry.hpp:754-757`, (2) `experiment_run_entry.hpp:293-296`, (3) `profile_run_facade.cpp:364-400` (wird zur duennen Resolver-Huelle), (4) `profile_run_facade.cpp:951-953` (dritte Kopie faellt weg), (5) `artifact_cache.hpp:214-218` (`cache_key_prefix` **verliert** das `+ceb`), (6) `.gitlab-ci.yml:877-880` GN_PREFIX als reinen lokalen Verzeichnisnamen kennzeichnen und den Fallback `:896` **hart** fehlschlagen lassen statt still einen dritten Namensraum zu oeffnen.

**ATOMARITAETS-WARNUNG (nicht verhandelbar):** die Punkte 1-4 und Punkt 5 muessen im **selben Commit** landen. Nur 1-4 => `build_version` traegt `+ceb` **und** `cache_key_prefix` haengt ein zweites an => **alle bestehenden Form-P-Objekte, also saemtliche golden-Chunks, werden unerreichbar.** Eine Staffelung ist ausgeschlossen.

**POSITIONS-INVARIANTE:** `+ceb` muss das **letzte** Segment der Suffix-Funktion sein, vor `+mtool`/`+mrg`. Dann gilt `base+P+"+ceb=6.0"+"+mtool=+mrg=none"` == der heutige Key, byte-identisch, auch fuer Debug (`+bt` steht in beiden Faellen vor `+ceb`). Bei jeder anderen Position: Totalverlust der Erreichbarkeit.

**Test-first-Gate:** **T-c** (Golden-String-Wache gegen den heute im Bucket liegenden Form-P-Key) muss **vor** der Umstellung geschrieben und gegen den Ist-Key gruen sein. Erst dann darf umgestellt werden. Dazu **T-a** (Perm-Suffix == Facade-Suffix bei identischen Eingaben) und **T-b** (`count("+ceb=") == 1`, zusaetzlich gegen einen Form-S-Alt-String als Rueckfall-Wache). Diese Kreuz-Wache existiert heute in **keiner** Form -- kein einziger Test vergleicht die beiden Formen.

**Aufwand:** 5 C++-Dateien + 1 YAML umstellen, 3 Test-Dateien anpassen (`test_s1_cache_key_prefix.cpp:33,44,53,61,70`; `test_g3_prune.cpp:206`; `test_g1_binary_version_stamp.cpp:64,98`), 3 neue Wachen. Keine neue Abstraktionsebene, kein ABI-Bruch, keine Messdaten beruehrt. Realistisch **ein Arbeitstag inkl. voller ctest-Runde**, plus das Zwangs-Neubau-Fenster, das ohnehin als Voll-Bau-4 eingeplant ist. Unveraendert gueltig bleiben `test_s2_pull_tier_binary.cpp:94,116,161`, `test_s5_artifact_cache_bounded.cpp:84`, `test_w11_async_push_pump.cpp:57,65,174,232`, `test_g3_prune.cpp:148,171-173`; `test_br1_full22_count.cpp:60-68` bleibt unangetastet.

**Risiko: MITTEL, aber einseitig und abgesichert.** Der einzige scharfe Pfad ist `cache_key_prefix` -- durch T-c vor dem ersten Byte abgedeckt. Nebenwirkungen: **R2** Form-S-Objekte verwaisen (BAU-Artefakte, **keine** Messdaten -- Messdaten-Doktrin nicht beruehrt; additiv liegenlassen, **nicht loeschen**); **R4** Prune findet Alt-Artefakte nicht mehr -> `pruned=0` im PRUNE-TESTAT, konservativ, kein Datenverlust, loest sich mit R3 von selbst; **R5** kein Remote-Loeschvorgang noetig oder vorgeschlagen.

**NEIN-Variante (nur falls das Budget bis Mo 27.07. kippt) -- Betriebs-Auflagen, keine Heilung:** (i) verbindlich feststellen, dass zwischen jetzt und Mess-Ende **kein** `+ceb`-Bump stattfindet (`COMDARE_ANATOMY_ABI_MAJOR`, `kCebContractCodegenMinor`), sonst greift F3 unbemerkt; (ii) den Smoke-golden-Zweig (`COMDARE_GOLDEN_N_PROFILE=m3v2_smoke.profile.xml`, `.gitlab-ci.yml:1250`) mit `COMDARE_STORAGE_CACHE=false` fahren, sonst F2 (Skip mit leerem Pull); (iii) F1/F5/F6 als offene Fehlklassen ins Ledger.

---

## 5. WAS DER ARCHITEKT VOR DEM VOLL-BAU-4-TRIGGER NOCH PRUEFEN MUSS

**P-1 W-13-Entscheid gefallen.** Bei JA: gelandet, T-c zuerst, voller ctest gruen, Positions-Invariante belegt -- **vor** dem Trigger, weil der erzwungene Neubau der Voll-Bau-4 ist.

**P-2 Bestandslog-Politik fuer Voll-Bau-4 formal beschliessen: AUS.** Nicht stillschweigend annehmen. Begruendung: (i) `bestandslog_active` schaltet den Bau von `provision_all` auf `run_planer_driven_provision` (`iterator:979-982`) -- das ist kein Log, das ist ein anderer Bau-Treiber; (ii) 2x `store_document_merged` je 4096er-Fenster = bei N=2^17 rund 64 Dokument-Roundtrips / ~256 synchrone mc-Shellouts **im Messlauf** (der Bau-Abschnitt ist nicht auf `provision_only` gegated, nur der AsyncPushPump); (iii) quadratischer Merge O(|a|*|b|) (`bestandslog_lock.hpp:229-237`) -- bei |b|=131072 sind das ~8.6e9 String-Vergleiche single-threaded, auf der zweiten Maschine ~1.7e10, dazu ein ~35-40 MB XML-Dokument, das pro flush komplett herunter- und hochgeladen wird; (iv) §65 / W-Doktrin ("nur MinIO async").

**P-3 Nachweis, dass `COMDARE_BESTANDSLOG*` nirgends gesetzt ist -- und Setz-Politik festlegen.** Eigene Nachpruefung: 0 Treffer ueber `*.yml/*.yaml/*.sh/*.cmake/*.xml/*.bat` im super-Repo. Wenn spaeter gesetzt: **job-scoped, niemals projektweit.** Sonst (a) aendern sich die Stufe-1-YAML-Bytes (`experiment_plan_director.hpp:734-738` brennt die Werte in den `ceb:trigger`-`variables:`-Block) und (b) werden `test_experiment_plan_director.cpp:1175`, `:807`, `:1722` rot -- sie rufen `unset_g4a_forwarded_opt_ins()` nicht (nur `:669`, `:732`, `:748`, `:803` tun es).

**P-4 CE-Pin-Gleichstand aller Runner/Maschinen (>= `351855b8`)** -- oder P-2 (Bestandslog aus) als Ersatz. Sonst offener Voll-Wipe-Pfad, sobald irgendjemand `typ="planer_block"` schreibt.

**P-5 Beweis-Pflichten der Paketmeldung:** `ctest N/N` literal; Byte-Wachen 296/297 gruen **ohne** golden-Update; literaler Lauf **ohne** Env mit Nachweis "keine `[bestandslog]`-Zeile, Emissions-Bytes unveraendert" (Director-YAML-Pins); `grep -P '[^\x00-\x7F]'` ueber die **neuen** Zeilen.

**P-6 Vor jedem `rm -rf build`: tracked Mess-CSV im build-Verzeichnis pruefen.** W-13-R3 entwertet die 320 vorhandenen `perm.dll.version` unter `Code/build/y/e4_xml/dll/` -- der Zwangs-Neubau darf keine Messdaten mitnehmen.

**P-7 Verbindlich festlegen, welches Profil Voll-Bau-4 faehrt und welches das Vor-Gate.** `all_axes_golden.profile.xml` (mit `<system_axes>`, Form P) ist der Beweis-Lauf. Fuer den Smoke sind **zwei verschiedene** Profile im Umlauf: `m3_smoke_coverage.profile.xml` (aus der Host-Analyse) und `m3v2_smoke.profile.xml` (`.gitlab-ci.yml:1250`, `COMDARE_GOLDEN_N_PROFILE`). Ohne Festlegung validiert das Vor-Gate den falschen Key-Pfad.

**P-8 Mess-Zeitbudget nach W-30 rechnen:** single-thread, kein #45-Rabatt; einziger Hebel prod1 + prod2 parallel. Gegen die Frist Mo 27.07. (2 Tage Bau + 2 Tage Messen) ist das die einzige belastbare Planungsgrundlage.

**P-9 Freigabe-Umfang G4b schriftlich fixieren**, bevor der Impl-Agent startet: **G4b-1 (A, B, C, d1) = GO unter AUF-A1..A5 / B1..B6 / C1..C3 / D1; G4b-2 (d2) = HOLD bis E1..E5.** Ohne diese Fixierung baut der Agent (d2) mit -- und (d2) ist der Teil mit dem Datenverlust-Pfad.

**P-10 Commit-Topologie und Freeze:** (A)+(B)+(C) sind ce-Commits, dazu der **Gitlink-Bump** (im Schnitt nicht genannt), (D) als eigener granularer super-Commit; danach Working-Tree-Freeze vor der Manager-Pruefung.

**P-11 ASCII:** nur **neue** Zeilen ASCII-only. Altbestand nicht aufraeumen (`profile_run_entry.hpp` 137 Nicht-ASCII-Zeilen, `main.cpp` 66, `reservation_lifecycle.hpp` 14 inkl. Box-Drawing `:36/52/81/94/121`) -- kein Fremd-Churn, Doku nie loeschen. Der grep laeuft ueber den **Diff**, nicht ueber die Datei.

**P-12 Nur falls (d2) doch freigegeben wird:** zusaetzlich die komplette Liste aus 2.4 abarbeiten (try/catch, zweite Cache-Instanz, `COMDARE_ARTEFAKT_TRIES=1`, echte 30-min-Frist, rc in lokale Variable, Store-Ergebnis nicht verwerfen, `emit_storage_activation` im `ceb:emit`-Job, Voll-Wipe-Guard).

---

**Selbstcheck:** ASCII-only (nur `§` als zulaessiges Nicht-ASCII; keine Kastenzeichen, keine Gedankenstriche, keine Emojis). Keine Secret-Werte, nur Variablennamen. Keine Datei im Repo geaendert -- ausschliesslich Read/grep zur Aufloesung der Widersprueche K1/K2/K3/K6/K7 und zur Verifikation der Zeilenanker; alle zitierten Ausgaben stammen aus diesen Laeufen. Kein Report-File geschrieben.