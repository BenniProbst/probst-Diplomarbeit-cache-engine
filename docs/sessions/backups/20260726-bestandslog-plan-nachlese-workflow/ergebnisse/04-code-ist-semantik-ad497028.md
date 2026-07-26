**Basispfad (BASE):** `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/`
Dateien: `builder/bestandslog/*.hpp`, `builder/experiment_tree/cache_engine_builder_iterator.hpp` (= ITER), `builder/artifact_transport/artifact_cache.hpp` (= AC), `profile_facade/profile_run_entry.hpp` (= PRE).

## 0. Vorbefund, der alle anderen Antworten faerbt: der Pfad ist heute TOT

`bestandslog_active` (ITER:927-929) verlangt `bestand_transport.fetch` **und** `.store` **und** `bestand_key_of` **und** nicht-leeren `bestand_doc_key`. Die Fassade `make_cfg` (PRE:434-469) belegt aus der ganzen Bestandslog-Feldgruppe **nur** `bestand_fingerprint_fn` (PRE:458) und `bestand_zelle` (PRE:460). `bestand_transport`, `bestand_doc_key`, `bestand_key_of`, `bestand_owner_uuid`, `bestand_maschine`, `bestand_present` werden **nirgends** in `libs/` oder `apps/` zugewiesen (verifiziert per grep ueber alle `.hpp/.cpp`). `make_bestand_transport` (`bestandslog/artifact_cache_transport.hpp:37`) hat **null** Produktions-Aufrufer (nur `tests/unit/test_g3_artifact_cache_transport.cpp:49,60,74`). Der Planer exportiert `COMDARE_BESTANDSLOG_DOC_KEY/_OWNER_UUID/_MASCHINE` in die Job-Env (`profile_facade/planner/experiment_plan_director.hpp:735-737`), **gelesen werden sie von niemandem**; `COMDARE_BESTANDSLOG` schaltet ausschliesslich das `.fingerprint`-Sidecar frei (PRE:311-316).

Folge: `run_planer_driven_provision`, Reservierungen, Dedup, Lager-Load und Flush laufen im ausgelieferten Binary **nie**. Alles Folgende ist die Semantik, die scharf wuerde, sobald der Host die 4 Felder belegt.

## 1. try_acquire_lock..release_lock: umschliesst heute GAR NICHTS

`try_acquire_lock` (`bestandslog_lock.hpp:149-167`) und `release_lock` (:170-175) haben **keinen einzigen Produktions-Aufrufer** — nur `tests/unit/test_g3_bestandslog_lock.cpp:113,120,122,129,131,138,140,143,158,287,296`. **Jeder** reale Schreibvorgang (`store_reservation` ITER:823, `LagerRunState::flush` `builder_registration.hpp:137`) ruft `store_document_merged` **ungelockt**.

Kosten, falls der Lock verdrahtet wuerde (jedes Verb = ein `mc`-Shellout, AC:486-537):
- `try_acquire_lock`: `fetch` (:151) + ggf. `remove` (:156) + `store` (:161) + Zweit-Verify-`fetch` (:163) = **3-4 Netz-Roundtrips**.
- `release_lock`: `fetch` (:171) + `remove` (:173) = **2 Roundtrips**.
- Das Testat-Muster (Test:287-296) klammert damit `store_document_merged` = weitere `fetch`+`store` (`bestandslog_lock.hpp:265,274) → **7-8 mc-Prozesse pro Dokument-Schreibung**, alle Netz, alle innerhalb des Lock-Fensters. Der Lock umschliesst also **nicht nur** den Dokument-Schreibvorgang, sondern die kompletten object_store-Roundtrips.

**Retries liegen UNTER dem Lock, nicht darum herum.** Es gibt keinen Backoff-Loop um `try_acquire_lock` (Kommentar `bestandslog_lock.hpp:144` "der Aufrufer wiederholt mit Zufalls-Jitter" — der Aufrufer existiert nicht; kein `jitter`/`backoff`/`retry` im ganzen `bestandslog/`-Verzeichnis). Die Retries sitzen im Transport: `mc_cp` 12 Versuche a 5 s Pause (AC:690-695, `tries_=12`, `sleep_s_=5`, AC:950-951), `mc_pull` 2 Versuche a 1 s (AC:722-726), Wall-Clock-Caps `mc_push_timeout_s_=120` / `mc_pull_timeout_s_=20` (AC:958-961).
**Harte Konsequenz:** ein `store` im gehaltenen Lock kann bis zu 12*(120+5) ~ 25 Minuten blockieren — bei `ttl_s=30` ist der Lock **garantiert stale**, waehrend sein Halter noch schreibt. Der Lock ist damit selbst bei Verdrahtung nicht nur "nicht korrektheitstragend" (ehrlicher Kopfkommentar :10-20), sondern strukturell wirkungslos.

## 2. LockRecord.ttl_s + Stale-Break

- Default `ttl_s = 30` (Sekunden), `bestandslog_lock.hpp:84`. Kein Konstanten-Symbol, kein Env-Gate; der Wert kommt als Parameter `ttl_s` von aussen (:150) — alle Testaufrufe uebergeben 30.
- `lock_is_stale` (:139-141): `(now_s - r.ts_epoch_s) > ttl_s`, **strikt groesser** (bei exakt 30 s noch frisch).
- Break-Logik (:153-158): fremd **und** frisch → `return false`. Fremd **und** stale → `t.remove(lock_key)` (:156), danach faellt der Code durch und ueberschreibt (:160-161).
- **Unparsebarer Lock** → `parse_lock` liefert nullopt (:135, `owner=` ist Pflicht) → der `if`-Zweig wird uebersprungen und der Lock **kommentarlos ueberschrieben** (:158 "als brechbar behandeln"), ohne `remove`.
- **Keine Lease-Erneuerung**: `ts_epoch_s` wird nur beim Erwerb gesetzt (:160). Es gibt keine `refresh_lock`/Heartbeat-Funktion. Ein Halter, der laenger als 30 s arbeitet (siehe 1.), verliert seinen Lock ohne es zu merken; `release_lock` loescht dann brav den **fremden** Lock nicht (:173) — er laeuft ins Leere.

## 3. Union-Merge: real O(|a|*|b|) Vektor-Scan, KEINE Map

`merge_documents` (`bestandslog_lock.hpp:217-254`):
- `out.bestand = a.bestand` (:229), dann je Eintrag aus `b` ein `std::find_if` **linearer Scan** ueber `out.bestand` (:231-232) mit `same_eintrag_identity` = 128-Zeichen-Hex-Stringvergleich + 3 Zell-Strings (`bestandslog_document.hpp:178-180`). → **O(|a| * |b|) Stringvergleiche**, danach `std::sort` (:238).
- `reservierungen` identisch: `find_if` linear (:243-244), dann `sort` (:250-251).
- Der `std::map`-Index existiert (`bestandslog_index.hpp:120 LagerIndex`), wird im Merge aber **nicht** benutzt — nur im In-Memory-`Bestand<Policy>` (`bestandslog_factory.hpp:124`) und `LagerRunState::lager_` (`builder_registration.hpp:157`).

**Dokumentgroesse-Treiber** je `<eintrag>` (Emitter `bestandslog_document.hpp:288-304`): `key_sha512` 128 Zeichen + `combo`/`opt`/`simd` + **`pfad` = `b.output.string()`, der absolute Ausgabepfad** (ITER:969) + `bytes` + **`stempel` = `b.algo_sig`**, die volle Organ-Signatur (ITER:969) + `done_utc`. Realistisch 300-500 Byte/Zeile. Bei golden N=2^17 = 131072 Binaries **pro Zelle** → **~40-65 MB EIN XML-Dokument**, und der Index traegt laut Kopfkommentar (`builder_registration.hpp:65`) ALLE Zellen → x |combo x opt x simd|.

**Der Kostenhammer:** `store_reservation` (ITER:818-824) baut ein Dokument mit **einer** Reservierung und **null** Bestand-Eintraegen, ruft aber `store_document_merged` → `fetch` des VOLLEN Remote-Dokuments (mc pull), `parse_bestandslog` des vollen Dokuments, `emit_document` des vollen Dokuments, `store` des vollen Dokuments (mc cp). Das passiert **2x pro 4096er-Fenster** (:837 und :869). Bei 131072 Binaries = 32 Fenster = 64 Voll-Dokument-Roundtrips a bis zu 65 MB, nur um Reservierungszeilen zu setzen.

## 4. Reservierungs-Lebenszyklus: pro-forma ist kaputt, ETA ist kein ETA, Takeover ist tot

- **pro-forma 30 min**: `kProFormaMinutes = 30` (`reservation_lifecycle.hpp:33`), Berechnung in `pro_forma_deadline_epoch_s` (:57-60). **Diese Funktion wird in Produktion NIE gerufen** (nur `tests/unit/test_g3_reservation_lifecycle.cpp:32-33`). ITER:835-836 uebergibt `bestandslog::now_utc_iso()` fuer `reserviert_utc` **UND** fuer `pro_forma_bis_utc` — die 30-Minuten-Frist wird nirgends addiert. Das Feld `pro_forma_bis_utc` traegt also **die Reservierungszeit selbst**; jeder Takeover-Pruefer saehe die Reservierung im selben Moment als abgelaufen (`is_pro_forma_expired`, :99-101, `now > bis`).
- **ETA-Ersatz**: `apply_calibration` (:86-89) wird an ITER:867 gerufen — **nach** dem Bau des Slices, mit `EtaResult{wall_s, average_size_bytes(sizes)}`, wobei `wall_s` die **gemessene** Wall-Clock des bereits fertigen Slices ist (ITER:845,849,866). Unmittelbar danach `mark_done` (:868) und ein Store (:869). `eta_s` ist damit **keine Prognose, sondern ein Nachlauf-Protokoll**; auf einer **offenen** Reservierung steht nie eine ETA. Die echten Prognose-Funktionen `estimate_eta_s` / `project_slice_eta_s` / `calibrate_block` (`eta_estimator.hpp:32,57,66`) haben **null** Produktions-Aufrufer. Eine Mini-Batch-Kalibrierung existiert nicht.
- **Takeover-Funktionen**: `is_pro_forma_expired` (:99), `is_takeable_by_eta` (:105, Faktor `kTakeoverFactor=1.5` :34), `is_reservation_takeable` (:113-119). **Kein einziger Produktions-Aufrufer** (nur `test_g3_reservation_lifecycle.cpp:34-93`). Niemand liest die Reservierungsliste, niemand uebernimmt je etwas. Ebenso tot: die Maschinen-Paritaet `window_belongs_to` / `BatchPlanner` (`batch_planner.hpp:52,91-130`) — `run_planer_driven_provision` nutzt `SlicePlanner` (`planer_driven_build.hpp:102-139`), der **keine rank/n_machines-Aufteilung** kennt. Zwei Maschinen mit derselben Perm bauen deshalb dieselben Slices doppelt.
- **PromiseGuard** (`reservation_lifecycle.hpp:126-155`): angelegt ITER:839-842, `commit()` ITER:870. Der Lambda faengt `res` **by value** zum Zeitpunkt des pro-forma-Zustands ab (`guard.emplace([&store_reservation, res]() mutable`) — eine spaetere `apply_calibration` auf `res` sieht der Guard nicht. Er feuert nur bei Exception (der Normalpfad committet immer, wenn `reserve` true) und macht dann im Stack-Unwinding einen `fetch`+`store` Netz-Roundtrip.
- Zusaetzlich: `slice_begin` wird als `plan->view_indices.front()` gesetzt (ITER:834), also als **view-Index**, nicht als Fenster-Offset — konsistent nur, weil `slice_view_indices` reihenfolge-erhaltend slict (`planer_driven_build.hpp:40-50`).

## 5. pick_reservierung-Monotonie

`status_rank`: `offen=0, released=1, done=2` (`bestandslog_lock.hpp:190-197`). `pick_reservierung` (:200-208) nimmt den hoeheren Rang; bei Gleichstand die mit gefuellter `eta_s` (:206), sonst stabil `a`.

- **done gewinnt immer** gegen offen und released — monoton in Richtung Fertigstellung, korrekt.
- **released gewinnt gegen offen** (Rang 1 > 0). Das ist die riskante Kante: ein PromiseGuard-Release ueberschreibt eine Reservierung, die eine andere Maschine unter derselben id inzwischen neu geoeffnet haette. Praktisch harmlos, weil ids `owner_uuid + "/" + slice_seq` sind (ITER:832) und damit **per Maschine disjunkt** — es gibt nie einen echten Cross-Maschinen-id-Konflikt, die Konfliktaufloesung laeuft nur gegen die eigene aeltere Zeile.
- `a` ist im Aufruf `merge_documents(*remote, local)` (:267) **das REMOTE-Dokument**. Bei Rang-Gleichstand und beidseitig gefuellter `eta_s` gewinnt also Remote gegen Lokal.
- `pick_eintrag` (:210-213): `b.done_utc > a.done_utc ? b : a`. `done_utc` hat **Sekunden-Aufloesung** (`builder_registration.hpp:46`, `%Y-%m-%dT%H:%M:%SZ`) → bei Gleichstand gewinnt Remote; da die Identitaet (sha+Zelle) ohnehin gleich ist, kostet das nur den lokalen `pfad`/`bytes`-Wert.

## 6. Parser-Strenge und der Voll-Wipe-Pfad

**parse_bestandslog** (`bestandslog_document.hpp:345-397`): fail-closed bei unbekannten Enums — unbekanntes/fehlendes `genus` → nullopt (:352-353), unbekanntes `typ` → nullopt (:378-379), unbekannter `status` → nullopt (:389-391). **Eine einzige fehlerhafte `<batch>`-Zeile vernichtet das Parse-Ergebnis des GESAMTEN Inventars.** Dagegen: unbekannte *Attribute* werden still ignoriert, fehlende Attribute liefern leere Strings, nicht-numerische `bytes`/`slice_begin` werden von `parse_u64` still zu 0 (:248-252) — kein Fehler.
`document_syntax_supported` (:221-223) wird **nie** aufgerufen (nur Tests `test_g3_bestandslog_document.cpp:92-271`): weder `LagerRunState::load` (`builder_registration.hpp:66-74`) noch `store_document_merged` pruefen die Grammatik-Version. Ein v3-Dokument wird also gelesen, mit v2-Feldwissen gemergt und mit `syntax_version = max(a,b) = 3` (`bestandslog_lock.hpp:220`) zurueckgeschrieben — **stiller Feldverlust unter beibehaltenem hohem Versionsstempel**.

**Der Voll-Wipe ist real.** `store_document_merged` (`bestandslog_lock.hpp:262-276`):
```
if (auto raw = t.fetch(doc_key)) {
    if (auto remote = parse_bestandslog(*raw)) to_write = merge_documents(*remote, local);
    else to_write = local;              // Z269 -- remote unlesbar -> lokalen Stand setzen
} else { to_write = local; to_write.doc_revision = local.doc_revision + 1; }
if (!t.store(doc_key, emit_document(to_write))) return std::nullopt;   // Z274
```
Bei unlesbarem Remote (ein truncierter mc-Pull, ein halbgeschriebenes Objekt, **eine einzige unbekannte `status`-Zeile**) wird `local` **bedingungslos** ueber das Remote geschrieben. Im Reservierungspfad ist `local` das an ITER:819-822 frisch konstruierte Dokument mit **einer Reservierung und leerem `bestand`** → das gesamte Inventar (bis zu 131072 Eintraege) ist in einem `mc cp` weg. Zusaetzlich wird in diesem Zweig `doc_revision` **nicht** gebumpt (das passiert nur in der else-Branch :272), das lokale Dokument hat `doc_revision = 0` → **die Revision laeuft rueckwaerts**. Der Kommentar ":269 Versionierung schuetzt das Alte" ist durch **nichts** gedeckt: `object_store` (AC:506-530) ist ein schlichtes ueberschreibendes `mc cp`, es gibt keinen versionierten Key, kein Backup, kein Read-back-Verify, und minio-Object-Versioning wird nirgends konfiguriert.

## 7. Flush-Punkte im Bau-Pfad; Mess-Pfad hat keinen Schreiber

**Bau-Pfad, zwei getrennte Kadenzen:**
1. **Reservierungen: je 4096er-Fenster, 2 Voll-Dokument-Schreibungen** — ITER:837 (pro-forma) und ITER:869 (done+Kalibrierung), Korn `kBuildSliceGrain = 4096` (`planer_driven_build.hpp:36`, gesetzt ITER:814).
2. **Bestand: genau EINMAL pro `run_lazy_static_then_dynamic`-Aufruf**, ITER:992-997 → `lager.flush` (`builder_registration.hpp:125-140`), **nach** allen Slices, **nicht** je Fenster und **nicht** je Binary. Je Binary laeuft nur `lager.observe` (ITER:969) in den In-Memory-`fresh_`-Vektor (`builder_registration.hpp:100,158`).

Das ist der Haltbarkeits-Bruch: stirbt der Prozess nach 30 von 32 Fenstern, liegen **alle** Reservierungszeilen im Store, aber **kein einziger** Bestand-Eintrag — der naechste Lauf sieht ein leeres Lager und baut alles neu. Verschaerfend: `flush` swappt `fresh_` **vor** dem Store leer (`:128-131`); scheitert der Store (`:138 return nullopt`), ist der Batch auch aus dem RAM verschwunden — kein Re-Queue, kein Retry. Die Diagnose ITER:994-996 meldet das nur als `(store-fehler)` auf `std::cerr`, der Rueckgabewert wird nicht ausgewertet und faerbt den Exit-Code nicht.
Kadenz-Hinweis: `flush` laeuft pro Iterator-Aufruf, also je Pass (Basis + SOTA) und je opt-x-simd-Perm erneut; im `provision_only` ist der N-Sweep auf 1 kollabiert (PRE:373-377).

**Mess-Pfad: kein Bestandslog-Schreiber.** `Genus::measurement`, `make_messwert_bestand`, `MesswertKeyPolicy` (`bestandslog_factory.hpp:59-68,129`) haben **null** Produktions-Aufrufer — nur `tests/unit/test_g3_sha512_index.cpp:138-143` und `test_g3_bestandslog_document.cpp:121-285`. Der Mess-Loop nutzt an der Per-Binary-Naht ausschliesslich `cfg.cache_push` und `cfg.measurement_sink` (ITER:1252-1259), zwei voellig getrennte Wege (mc bzw. curl-Drop, AC Ebene B/C). "Bestand 2 = Messwerte" ist heute reine Serialisierungs- und Factory-Schicht ohne Produzent und ohne Konsument.

---
Selbstcheck: `grep -P '[^\x00-\x7F]'` ueber diese Meldung: nur `§` (erlaubt) und `~`/`x` als ASCII-Ersatz fuer Multiplikation; keine Gedankenstriche, keine Box-Zeichen.