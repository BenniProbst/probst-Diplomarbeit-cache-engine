GESAMTBEFUND (vorab)

Der Owner hat in der Sache recht. Das Verdikt ist in seinen MESSUNGEN weitgehend korrekt (ich habe jeden Anker selbst nachgelesen), aber es zieht aus einer Kette echter CODE-DEFEKTE durchgaengig den Schluss "also den PLAN aufschieben/abschalten". Das ist die Umkehrung der KERN=Gesetz-Doktrin. Der zentrale Denkfehler steckt in Block I: das Verdikt misst die Dauer einer Sektion, die der Plan so gar nicht vorsieht, und erklaert dann N7 fuer unhaltbar.

Von 41 geprueften Behauptungen: 17 BESTAETIGT (Fakt korrekt, plan-vertraeglich), 11 LUECKE-IM-VERDIKT, 13 ECHTER-CODE-DEFEKT.

Wichtigster Vorbefund, den ich unabhaengig bestaetige: `bestandslog_active` (ITER:927-929) ist heute IMMER false. `bestand_transport`/`bestand_doc_key`/`bestand_key_of`/`bestand_owner_uuid`/`bestand_maschine`/`bestand_present` werden in `libs/` und `apps/` NIRGENDS zugewiesen (verifiziert: nur `bestand_fingerprint_fn` PRE:458 und `bestand_zelle` PRE:460). `grep -rn "COMDARE_BESTANDSLOG" --include=*.yml --include=*.yaml --include=*.sh --include=*.cmake --include=*.xml --include=*.bat` ueber das Super-Repo: 0 Treffer. Alle Zeitbudget-Aussagen des Verdikts sind daher Aussagen ueber eine HYPOTHETISCHE Verdrahtung, nicht ueber laufenden Code.

=====================================================================
BLOCK I -- LOCK-ZEITBUDGET (traegt den N7-Aufschub). Hier liegt der Bruch.
=====================================================================

B1 (kritische Sektion enthaelt object_store, worst case ~49 min)
KLASSIFIKATION: ECHTER-CODE-DEFEKT (Zahlen bestaetigt, Schlussfolgerung ist der Denkfehler).
Verifiziert: `artifact_cache.hpp:950` `tries_=12`, `:951` `sleep_s_=5`, `:958` `mc_push_timeout_s_=120`. `mc_cp` (:684-698) je Versuch: `mc cp` (Cap 120s) + `mc_size_verified` (`mc stat`, Cap 120s) + 5s Pause. 12*(240)+11*5 = 2935s = 48,9 min. Arithmetik korrekt.
DREI PRAEZISIERUNGEN, die das Verdikt unterschlaegt:
(a) Der 49-min-Pfad verlangt 12x hintereinander: `mc cp` gelingt nahe am Cap UND `mc stat` gelingt nahe am Cap UND meldet eine ABWEICHENDE Groesse. Bei rc!=0 liefert `mc_size_verified` (:737-740) `true` -> Erfolg, Schleife endet. Der realistische Hang-Fall (`mc cp` laeuft in den Cap) ist 12*120+55 = ~25 min. Das CODE-IST-Dossier rechnet mit 25 min und hat damit den plausibleren Wert.
(b) In GENAU der Umgebung, in der das Bestandslog scharf waere, gilt `tries_` nicht 12: `emit_storage_activation` (director:900) exportiert `COMDARE_ARTEFAKT_TRIES="${COMDARE_ARTEFAKT_TRIES:-2}"` unter `COMDARE_STORAGE_CACHE=true`, und `artifact_cache.hpp:166` liest die Variable. Worst case dort: 2*240+5 = 485s = ~8 min. Das Verdikt nennt seinen eigenen Befund B15 nicht mit B1 zusammen.
(c) DER KERN: N7 (LED:3225) definiert das Lock als "die KURZE Schreib-Exklusivitaet am DOKUMENT selbst", N8 (LED:3227) die Reservierungs-Eintragung als "NUR MILLISEKUNDEN". Ein Retry-Loop mit 12 Versuchen a 120s INNERHALB des Locks ist damit ein Verstoss gegen N7, nicht ein Beweis gegen N7. Der Code sagt es selbst: `bestandslog_lock.hpp:144` "EIN Versuch (kein Backoff-Loop; der Aufrufer wiederholt mit Zufalls-Jitter)". Das ist die plan-konforme Bauform -- Lock nehmen, EIN Store-Versuch, Lock freigeben, bei Fehlschlag den GANZEN Zyklus mit Jitter wiederholen. Der Defekt ist, dass dieser Aufrufer nie gebaut wurde und der Transport seinen eigenen 12er-Retry mitbringt.
FIX (Code, nicht Plan): Lock-Pfad mit `tries_=1` / eigenem knappen Budget fahren (das Feld ist schon env-parametrisiert) + Jitter-Backoff-Loop um `try_acquire_lock..release_lock`.

B2 (`LockRecord.ttl_s = 30`)
KLASSIFIKATION: BESTAETIGT (Fakt), plan-vertraeglich.
Verifiziert `bestandslog_lock.hpp:84`. 30 SEKUNDEN Lock-TTL ist keine Plan-Verletzung: die 30 MINUTEN im Plan sind die pro-forma-RESERVIERUNG (LED:3219/3221), nicht die Lock-TTL. Der Ledger nennt keine Lock-Timeout-Zahl (dokumentierte Ledger-Luecke (b)). 30s ist eine legitime Konkretisierung von "kurze Schreib-Exklusivitaet". Der Bruch entsteht erst durch B1.

B2a (`lock_is_stale` nach 30s brechbar, jede Maschine bricht -> zwei Schreiber)
KLASSIFIKATION: BESTAETIGT (Fakt), aber das Verdikt liest den Stale-Bruch als Defekt -- er ist eine PLAN-FORDERUNG.
Verifiziert :139-141 (strikt `>`), :153-156. N7-Konsolidierungs-Anm. (LED:3225): "Eine tote Maschine kann das Dokument also nie dauerhaft sperren". Der Bruch IST das geforderte Verhalten; der Kopfkommentar (:17-18) sagt dasselbe. Schaedlich wird er ausschliesslich wegen B1. Es gibt keine `refresh_lock`/Heartbeat-Funktion -- das ist plan-konform, SOLANGE die Sektion millisekundenkurz ist.

B2b (ca. 15-25 mc-Spawns + zwei volle Down-/Uploads)
KLASSIFIKATION: BESTAETIGT (Zahl plausibel), mit einem Zaehlfehler in der Zuordnung.
Nachgerechnet: `try_acquire_lock` = fetch(2-3) + ggf. remove(2) + store(2+) + Verify-fetch(2-3) = 8-10. `store_document_merged` = fetch(2-3) + store(2+) = 4-5. `release_lock` = fetch(2-3) + remove(2) = 4-5. Summe 16-20, mit Retries mehr. Die Groessenordnung stimmt.
ABER: die LOCK-SEKTION im Sinne von N7 ist nur `store_document_merged` = 4-5 Spawns. Acquire und Release liegen ausserhalb. Das Verdikt rechnet Erwerb und Freigabe in die Sektion und macht sie damit rechnerisch 4x groesser als sie ist.

B2c (kein Produktionspfad ruft try_acquire_lock/release_lock, nur Tests)
KLASSIFIKATION: ECHTER-CODE-DEFEKT.
Verifiziert: `grep` ueber `libs/` + `apps/` liefert fuer beide Funktionen NUR die Definitionszeilen (:149, :170). Jeder reale Schreibvorgang (`store_reservation` ITER:823, `LagerRunState::flush` builder_registration.hpp:137) laeuft UNGELOCKT.
Das ist der direkte Verstoss gegen N7 Satz 1: "das Bestandslog wird beim SCHREIBVORGANG einer Maschine GELOCKT". Das Verdikt nimmt diesen Verstoss als Begruendung, N7 aufzuschieben. Genau der vom Owner benannte Fall: der CODE ist zu fixen.

B2d ("auch im gesunden Fall (~2 s Sektion) ist 'Millisekunden' nicht haltbar")
KLASSIFIKATION: LUECKE-IM-VERDIKT (Denkfehler) + der ~2s-Wert ist selbst ein ECHTER-CODE-DEFEKT.
Denkfehler: N8 sagt woertlich "das Schreiben BESCHRAENKT SICH AUF die Eintragung der Reservierung der Maschine (NUR MILLISEKUNDEN)". Das ist eine Aussage ueber den UMFANG des Schreibens (eine Zeile, nicht die ETA-Rechnung), gestellt gegen den Folgesatz "Der HAUPT-BLOCKER ist die ETA-BERECHNUNG (der einzige laengere Schreib-Lock-Fall)". Der Plan raeumt also selbst einen laengeren Lock-Fall ein und verspricht nirgends Millisekunden-Netz-Roundtrips ueber mc/S3. Das Verdikt liest "Millisekunden" als Wall-Clock-SLA auf einen Voll-Dokument-Roundtrip.
Der Code-Defekt dahinter: `store_reservation` (ITER:818-824) baut fuer EINE Reservierungszeile ein Dokument und ruft `store_document_merged` -> fetch + parse + emit + store des VOLLEN Dokuments. N8 "die Vorgaenge REGISTRIEREN sich dann nur" beschreibt genau das Gegenteil (Registrierung, nicht Voll-Dokument-RMW). Plan-konforme Bauform: ein kleines Sidecar-Objekt je owner/slice, beim Lesen union-gesammelt -> millisekundenkurz und lock-frei.
Nebenbefund: der Anker `apply_calibration reservation_lifecycle.hpp:86-89` traegt nichts zur Sektion bei -- die Funktion ist reine String-Formatierung (`format_seconds` + `to_string`), Nanosekunden.

B2e (Ledger-Vorgabe + Alternativ-Zweig "Aufschub nach #46b als KNOWN GAP")
KLASSIFIKATION: LUECKE-IM-VERDIKT.
Die Zitate LED:3225/3227 sind korrekt wiedergegeben. Der Alternativ-Zweig ist NICHT ledger-gedeckt: §66-G3 (LED:3368-3369) zieht "#46b-Bestandslog-Kern P1-P4" IN das Lager-Gate VOR den Voll-Bau und "supersediert 'vor 01.08.'". LED:3313 macht die Persistenz-Schicht zur "PFLICHT VOR der new-golden-VOLL-MESSUNG". #46b ist das Gate, nicht der Ort, an den man N7 verschiebt. E6/§66-KERN woertlich: "betrachte alles was die Lagerhaltung und Stempel angeht als gate fuer voll build".

=====================================================================
BLOCK II -- MERGE-KOMPLEXITAET
=====================================================================

B3 (quadratischer Merge O(|a|*|b|), ~8,6e9 / ~1,7e10 Vergleiche)
KLASSIFIKATION: ECHTER-CODE-DEFEKT.
Verifiziert `bestandslog_lock.hpp:229-237`: `out.bestand = a.bestand;` dann je `b`-Eintrag `std::find_if` linear mit `same_eintrag_identity` (128-hex-Stringvergleich + 3 Zell-Strings, `bestandslog_document.hpp:178-180`). Reservierungen identisch :242-249. Arithmetik korrekt (131072^2/2 = 8,6e9; 131072^2 = 1,7e10).
Das verletzt eine WOERTLICHE User-Direktive: C2 / LED:3234 "lookup mapping ueber std::map mit SHA512 keys und Binary-/Messwertpfad ... effizient auffindbar" und "ueber ein FACTORY PATTERN wird die Version im ccache schneller ueber SHA-HASHING gefunden". Der `std::map`-Index EXISTIERT (`bestandslog_index.hpp:120 LagerIndex`) und wird im Merge nicht benutzt.
FIX: Merge ueber `LagerIndex` -> O((|a|+|b|) log n). Das ist der Plan, kein Zusatzwunsch. Das Verdikt macht daraus P-2 (Bestandslog AUS) und wirft damit das vom User verfuegte Gate weg.

B4 (~35-40 MB XML je flush, komplett herunter- und hochgeladen)
KLASSIFIKATION: BESTAETIGT (Fakt) und zugleich ECHTER-CODE-DEFEKT gegen N8 + N-13.
Nachgerechnet ueber `emit_document` (`bestandslog_document.hpp:288-304`): je `<eintrag>` 128 hex + Attributnamen/Quotes ~120 + combo/opt/simd + `pfad` (absoluter Ausgabepfad, ITER:969) + `bytes` + `stempel` (volle `algo_sig`) + `done_utc` = 300-500 Byte. 131072 Eintraege = 39-65 MB. Der 35-40-MB-Wert ist die untere Kante.
Plan-Verstoss: N8 (Registrierung statt Voll-Schreibung) und N-13 (LED:3318: RAM-Sammelpuffer max 256 MB, "Rueckschreibung gebuendelt alle paar Dutzend Batch-Compiles", "ZURUECKSTREAMEN ... ueber einen ZWEITEN THREAD"). Der Code macht das Gegenteil: 2 Voll-Roundtrips je 4096er-Fenster fuer Reservierungen, und den Bestand genau EINMAL je Lauf.

=====================================================================
BLOCK III -- BAU-TREIBER-UMSCHALT
=====================================================================

B5 (2x store_document_merged je Fenster, ~64 Roundtrips / ~256 mc-Shellouts im Messlauf; Bau-Abschnitt nicht auf provision_only gegated)
KLASSIFIKATION: ECHTER-CODE-DEFEKT (fehlendes Gate).
Verifiziert: ITER:837 (pro-forma) und ITER:869 (done), `kBuildSliceGrain = 4096` (planer_driven_build.hpp:36, gesetzt ITER:814). `AsyncPushPump` ist auf `cfg.provision_only` gegated (ITER:947), `run_planer_driven_provision` (ITER:979-982) NICHT. Je `store_document_merged` 4 mc-Spawns (object_fetch = mc_remote_exists + mc_pull; object_store = mc_cp + mc_size_verified) -> 8 je Fenster -> 256 bei 32 Fenstern. Arithmetik korrekt.
Plan-Verstoss: LED:3232 haelt die zwei Bestaende (Binaries vs. Messergebnisse) getrennt, LED:3229 verbietet das Mischen der Batch-Typen. Die BINARY-Reservierungsmaschinerie mitten im MESS-Lauf mischt beides.
FIX: `provision_only`-Gate auf den Reservierungs-Pfad (eine Zeile), nicht P-2.

B5a (`bestandslog_active` schaltet provision_all -> run_planer_driven_provision; "das ist kein Log, das ist ein anderer Bau-Treiber")
KLASSIFIKATION: LUECKE-IM-VERDIKT.
Der Umschalt ist real (ITER:979-982, verifiziert). Aber der Treiber IST der Plan: E3/N14 (LED:3324) woertlich "der Start laeuft an, SOBALD das ERSTE Batch zusammengestellt ist ... eine QUEUE von Batch-Slices ... (Producer-Consumer: async Batch-Planer fuellt die Slice-Queue, Compile-Pool konsumiert)". `run_planer_driven_provision` + `SlicePlanner` + `SlicePlanQueue` sind exakt diese Bauform. Das Verdikt behandelt die Erfuellung einer User-Direktive als unerwuenschten Nebeneffekt und leitet daraus die Abschaltung ab.
Substanziell korrekt bleibt: der Umschalt ist NICHT verhaltensneutral. `slice_view_indices` ist reihenfolge-erhaltend (:38-50, konkatenation == Eingabe), aber die Parallelitaet ueberschreitet keine Fenstergrenze mehr (die Nachzuegler von Fenster k laufen leer, bevor k+1 startet), und `agg.peak_concurrency` wird zum Max ueber Fenster statt zum globalen Peak (ITER:853). Der Kommentar ITER:805 "IDENTISCH zu EINEM provision_all" ueberzeichnet damit. Das ist ein kleiner ECHTER-CODE-DEFEKT (Behauptung vs. Verhalten), kein Grund zur Abschaltung.

B5b (Gate prueft nur vier belegte std::function + nicht-leerer doc_key; make_bestand_transport belegt bedingungslos)
KLASSIFIKATION: ECHTER-CODE-DEFEKT (fehlendes Doppel-Gate).
Verifiziert `artifact_cache_transport.hpp:37-53`: alle vier Lambdas werden unbedingt gebunden, auch auf einer inerten Instanz (die Verben melden dann ehrlich nullopt/false). ITER:927-929 prueft nur die Belegung. Also haengt das Gate nach einer Host-Verdrahtung tatsaechlich nur an `!doc_key.empty()`.
Das bricht das Hausmuster: `COMDARE_BESTANDSLOG == "true"` (PRE:311-316) und `COMDARE_VARIANT_GATE` (PRE:452-457) sind explizite Env-Opt-ins, `main.cpp:852` prueft `!artifact_cache->inert()`. Der Bestandslog-Gate hat als einziger weder das eine noch das andere.
FIX: Env-Opt-in + `!cache.inert()` zusaetzlich pruefen.

B10 (run_planer_driven_provision = anderer, ungetesteter Bau-Treiber)
KLASSIFIKATION: BESTAETIGT, mit Praezisierung.
Verifiziert: `tests/unit/test_g3_planer_driven.cpp` hat 7 Tests, aber `grep -c run_planer_driven_provision` darin = 0. Getestet sind nur die reinen Bausteine (`slice_view_indices`, `SlicePlanner`, `SlicePlanQueue`). Die Funktion selbst -- Reservierungs-Lifecycle, PromiseGuard, Kalibrierung, Store-Aufrufe -- hat NULL direkte Abdeckung. "Ungetestet" trifft also fuer die tragende Naht zu, "anderer Bau-Treiber" nicht (s. B5a).

=====================================================================
BLOCK IV -- id / MERGE-MONOTONIE
=====================================================================

B6 (`pick_reservierung` verwirft spaeteres `offen` unter gleicher id, wenn `done` vorliegt)
KLASSIFIKATION: LUECKE-IM-VERDIKT (Fakt bestaetigt, Schluss falsch).
Verifiziert `bestandslog_lock.hpp:190-208`: offen=0 < released=1 < done=2, hoeherer Rang gewinnt.
Das IST plan-konform: LED:3222 "ALLE Reservierungen und ETAs werden im Log nach Fertigstellung eines Batches AUFGEHOBEN und mit 'Done' gekennzeichnet" -- done ist fuer diesen Batch terminal. Der Schaden entsteht nur bei id-WIEDERVERWENDUNG, und die kommt allein aus dem Manager-Vorschlag L2 (`owner_uuid + "/plan/" + doc_key`, stabil ueber Laeufe). Der User-KERN sagt etwas anderes: LED:3221 "eine Reservierung von 30 Minuten FUER DIESE VERSION" -- der Schluessel ist die CEB-VERSION, nicht der doc_key. Eine versionsgeschluesselte id ist je Version natuerlich frisch. Das Verdikt haelt einen Fehler seiner eigenen L2-Auflage fuer einen Fehler von (d2).
Fuer den Tier-Pfad ist die Frage ohnehin gegenstandslos: ids sind `owner_uuid + "/" + slice_seq` (ITER:832) und damit je Maschine disjunkt.

B6a (L2-id aus der Helfer-Signatur nicht herstellbar; Signatur `owner_uuid + "/" + to_string(seq)`)
KLASSIFIKATION: BESTAETIGT (Fakt), LUECKE-IM-VERDIKT als Argument gegen d2.
Verifiziert `experiment_plan_director.hpp:1263-1270` literal, Test `test_experiment_plan_director.cpp:1502` `EXPECT_EQ(r.id, "6f1c2b3a-.../7")`. Der Widerspruch besteht zwischen zwei Manager-Artefakten (L2-Auflage vs. G4a-7-Helfer), nicht zwischen Plan und Code. Aufloesung nach LED:3221: id auf den CEB-Versions-Key stellen -- der `seq`-Parameter kann ihn nicht tragen, also braucht der Helfer einen benannten Parameter. Additive Aenderung, §66-G2 haelt das Bruch-Fenster ausdruecklich offen.

B6b (make_planer_block_reservation nur in Tests; iterator:832 schreibt BatchTyp::tier; d2 waere erster planer_block-Schreiber)
KLASSIFIKATION: BESTAETIGT.
Verifiziert: einziger Nicht-Test-Treffer ist die Definition `experiment_plan_director.hpp:1264`. ITER:832 `bestandslog::BatchTyp::tier`.

B6c (`profile_facade` nicht im Include-Satz des Test-Targets)
KLASSIFIKATION: BESTAETIGT (Fakt), LUECKE-IM-VERDIKT als Blocker.
Verifiziert `tests/unit/CMakeLists.txt:3993-3999`: builder / include / src / common, kein profile_facade. Aber `make_planer_block_reservation` IST bereits getestet, in `tests/unit/thesis_tiere/test_experiment_plan_director.cpp:1500-1520`. Die Funktion hat ein Test-Zuhause; die Aussage betrifft nur eine bestimmte TU. Eine `target_include_directories`-Zeile ist zudem genau der "schwere offizielle Weg", nicht ein Behelfsweg.

=====================================================================
BLOCK V -- VOLL-WIPE
=====================================================================

B7 (parse_bestandslog nullopt bei unbekanntem typ/status/genus; store_document_merged:269 = to_write = local)
KLASSIFIKATION: ECHTER-CODE-DEFEKT. Schwerste bestaetigte Feststellung des ganzen Sets.
Verifiziert `bestandslog_document.hpp:352-353` (genus), `:378-379` (typ), `:389-391` (status) -- jeweils `return std::nullopt` fuer das GANZE Dokument. `bestandslog_lock.hpp:262-276`: bei unlesbarem Remote wird `local` bedingungslos geschrieben. Im Reservierungspfad ist `local` ein Dokument mit EINER Reservierung und LEEREM `bestand`.
Zwei Plan-Verstoesse in einer Funktion:
(1) LED:3216 verlangt "eine EIGENE VERSIONSNUMMER IM HEADER fuer Syntax UND Semantik". Der Code HAT den Vertrag implementiert -- `document_syntax_supported` (`bestandslog_document.hpp:221-223`) -- und ruft ihn NIRGENDS auf (verifiziert: nur Definition + Kommentare + Tests). Der Kommentar :269 "Versionierung schuetzt das Alte" behauptet einen Schutz, den der Code nicht ausfuehrt.
(2) `doc_revision` wird in diesem Zweig NICHT gebumpt (nur im else-Zweig :272), laeuft also rueckwaerts -- gegen die im selben File dreimal behauptete Invariante "doc_revision monoton" (:14, :185, :223).
Zusaetzlich verifiziert: `object_store` (`artifact_cache.hpp:506-530`) ist ein schlichtes ueberschreibendes `mc cp`. Kein versionierter Key, kein Backup, kein Read-back-Verify.
FIX: fail-closed. Unlesbares Remote -> Schreibvorgang ABBRECHEN und melden, nie ueberschreiben. Plus `document_syntax_supported` vor dem Merge rufen. Das Verdikt empfiehlt stattdessen CE-Pin-Gleichstand oder P-2 -- Umgehungen eines Defekts, der einen Fix braucht.

B7a (Lost Update ohne CAS; store_document_merged unatomares RMW; iterator:823 nimmt kein Lock)
KLASSIFIKATION: ECHTER-CODE-DEFEKT gegen N7.
Verifiziert. Das ist woertlich der Zustand, den N7 verbietet. Das Verdikt fuehrt ihn als Grund an, N7 zu verschieben.
Zusatzbefund: der Kopfkommentar (:12-20) begruendet die Harmlosigkeit mit "(b) Artefakt-Pushes sind idempotent". Das Argument deckt doppelte ARBEIT, nicht das LOG. Ein verlorener Reservierungs-Update wird durch idempotente Artefakt-Pushes nicht harmlos. Die Begruendung traegt den Fall nicht, fuer den sie in Anspruch genommen wird.

=====================================================================
BLOCK VI -- VERTRAGSEBENE / ANKER
=====================================================================

B8 (planer_block-Anker --emit-tier-ci ist die CEB-Rolle/Tier-Emission, nicht die CEB-Compile-Strecke)
KLASSIFIKATION: BESTAETIGT. Der staerkste und sauberste Punkt des Verdikts.
Verifiziert `Code/02_messung_driver/main.cpp`: `--dump-ci` :415, `--dump-cmake` :426, `--emit-tier-ci` :439, `--emit-tier-cmake` :457. Director :537-540 / :565-566: "der PLANER steuert die CEB-Jobs (--dump-ci), die CEB steuert die Tier-Jobs (--emit-tier-ci)".
LED:3221 hat als Subjekt den PLANER und als Objekt einen CEB-Compile. Der Job, der einen CEB-Compile ausloest (`ceb:build`), entsteht in der Stufe-1-YAML -- also am `--dump-ci`/`--dump-cmake`-Pfad. Die Tier-Ebene hat ihre Reservierung bereits (ITER:826-843); ein planer_block dort waere eine Doppel-Reservierung und mischt Batch-Typen (LED:3229).
Konsequenz: (d2) ist RE-ZU-ANKERN, nicht zu streichen.

B8a ("fuer diese Version" nicht abbildbar; BatchReservierung hat kein Feld dafuer)
KLASSIFIKATION: ECHTER-CODE-DEFEKT (fehlendes Feld), LUECKE-IM-VERDIKT im Schluss.
Verifiziert `bestandslog_document.hpp:189-203`: id, typ, slice_begin, slice_count, maschine, threads, reserviert_utc, pro_forma_bis_utc, eta_s, avg_size_bytes, status. Kein Versions-Feld.
Das Verdikt schliesst daraus "nicht abbildbar -> HOLD". Der Plan schliesst anders: §66-NACHTRAG-3 (LED:3404-3413) "ALLE Achsen sind IMMER getrennt zu behandeln und zu KLAMMERN (keine Fusion in Signaturen/Schluesseln/Stempeln -- je Achse ihr eigenes Feld/ihre eigene Klammer)". Die Version in die `id` zu quetschen waere also selbst ein Verstoss. Die plan-konforme Antwort ist ein EIGENES Feld plus `kSyntaxVersion`-Bump (heute 2, `bestandslog_document.hpp:74`) -- und §66-G2 erklaert das Cache-Bruch-Fenster ausdruecklich fuer JETZT geoeffnet.

=====================================================================
BLOCK VII -- owner_uuid / MASCHINEN-IDENTITAET
=====================================================================

B9 (owner_uuid wird nirgends gesetzt; einziger Leser PRE:312; Forwards director :734-737)
KLASSIFIKATION: ECHTER-CODE-DEFEKT (tote Verdrahtung), mit einer Praezisierung.
Selbst verifiziert: 0 Treffer ueber alle yml/yaml/sh/cmake/xml/bat im Super-Repo. Praezisierung: PRE:311-316 liest `COMDARE_BESTANDSLOG` (den bool), NICHT `_OWNER_UUID`. Fuer `_OWNER_UUID`, `_DOC_KEY`, `_MASCHINE` gibt es weder Setzer NOCH Leser -- der Director reicht sie nur durch. Die Luecke ist also groesser als das Verdikt sagt.
Plan-Bezug: LED:3208 (Reservierung = Versprechen) und LED:3217 (Gleichverteilungs-Pflicht) verlangen Maschinen-Identitaet im Log.

B9a (leerer owner_uuid: parse_lock akzeptiert `owner=`, "" == "" -> jeder haelt jeden Lock fuer den eigenen; release_lock loescht fremde Locks)
KLASSIFIKATION: ECHTER-CODE-DEFEKT, scharf und billig zu fixen.
Verifiziert: `parse_lock` :114-116 setzt `have_owner = true` auch bei leerem Wert; die Leere wird nie geprueft (:135 prueft nur `have_owner`). `try_acquire_lock:153` `existing->owner_uuid != me.owner_uuid` -> ""!="" ist false -> beide Waechter fallen durch -> Ueberschreiben. `release_lock:173` `==` -> true -> `remove` eines fremden Locks.
Der Kommentar :135 behauptet "owner ist Pflicht -> nie stille Fehlfaerbung" -- genau das setzt der Leer-Wert ausser Kraft. Zweizeiliger Fix in `parse_lock` + `LockOwner`-Konstruktion. Kein Grund, N7 zu verschieben; ein Grund, N7s Implementierung zu reparieren.

B9b (Widerspruch der Berichte: eine geteilte owner_uuid vs. verschiedene)
KLASSIFIKATION: ECHTER-CODE-DEFEKT -- der Code entscheidet den Streit, und die Antwort ist plan-widrig.
Verifiziert `experiment_plan_director.hpp:694-698`: `append_forward_var_literal` liest `std::getenv(name)` in der PLANER-Umgebung und brennt den Wert literal in den `variables:`-Block; `forward: yaml_variables: true` (:748-750) traegt ihn ueber die zweite Trigger-Grenze. Also erhalten ALLE Lanes/Maschinen EINEN owner_uuid -- LEDGER D-2 hat die zutreffende Praemisse.
Und das ist der eigentliche Defekt, den beide Berichte verfehlen: `OWNER_UUID` und `MASCHINE` sind PER-MASCHINEN-Fakten und duerfen ueberhaupt nicht vom Planer geforwarded werden -- sie muessen auf dem Runner abgeleitet werden. Nur `DOC_KEY` ist ein lauf-weiter Fakt und darf reisen. Mit dem heutigen Forward sind prod1 und prod2 im Log nicht unterscheidbar -> Gleichverteilung (LED:3217) und Takeover (LED:3220) sind strukturell unmoeglich.

=====================================================================
BLOCK VIII -- 30-MINUTEN-FRIST / TERMINALITAET
=====================================================================

B11 (pro-forma-Frist faktisch null: reserviert_utc und pro_forma_bis_utc bekommen denselben Wert)
KLASSIFIKATION: ECHTER-CODE-DEFEKT.
Verifiziert ITER:834-836: zweimal `bestandslog::now_utc_iso()`. `pro_forma_deadline_epoch_s` (`reservation_lifecycle.hpp:57-60`) hat 0 Produktions-Aufrufer. `is_pro_forma_expired` (:99-101) `now > bis` -> eine Sekunde spaeter true.
Verstoss gegen LED:3219 ("werden weiterhin ZUERST 30 MINUTEN pro forma reserviert") und gegen LED:3225, das genau diese Reservierung als Obergrenze des Locks setzt.
TIEFERE, von beiden Berichten unbenannte Haelfte: `pro_forma_bis_utc` ist ein ISO-STRING, alle Takeover-Praedikate nehmen EPOCH-SEKUNDEN -- und im gesamten `bestandslog/`-Verzeichnis gibt es keinen ISO->Epoch-Parser (verifiziert: kein `timegm`/`mktime`/`parse_iso`). Selbst ein korrekt geschriebener 30-min-Wert haette heute keinen Leser.

B12 (kein try/catch um die Emit-Zweige -> terminate ohne Unwinding -> ~PromiseGuard feuert nie -> Reservierung 30 min haengen)
KLASSIFIKATION: BESTAETIGT (Fakt), LUECKE-IM-VERDIKT (Blocker-Wertung).
Verifiziert `Code/02_messung_driver/main.cpp`: `try` nur bei :379 und :813; die Zweige :439-452 und :457-470 liegen ungeschuetzt in der argv-Schleife (:319-471).
Aber die Folge "Reservierung bleibt 30 min haengen" ist kein Defekt, sondern der SPEZIFIZIERTE worst case: LED:3219 reserviert bewusst 30 Minuten pro forma, LED:3220 setzt die Takeover-Regel darauf. Das Verdikt bepreist ein Risiko neu, das der Plan bereits eingepreist hat. Der triviale Fix (try/catch, im File zweimal praezedent) ist ohnehin verfuegbar.

B12a (L1 "immer terminal" zu stark: _Exit/abort/SIGTERM laufen am Guard vorbei)
KLASSIFIKATION: BESTAETIGT (Fakt), LUECKE-IM-VERDIKT (Blocker-Wertung).
RAII-Wahrheit, unbestritten. Der Plan hat dafuer die ZWEITE Schicht: LED:3220 Takeover, ausdruecklich mit dem Praezedenzfall Pipeline-11519-Cancel (LED:3305). Die Luecke ist nicht L1, sondern dass die zweite Schicht keinen Aufrufer hat -- siehe B16.

B12b (`return pf::emit_tier_ci_facade(...)` zerstoert den Guard erst nach dem Rueckgabewert; commit() schreibt nichts)
KLASSIFIKATION: LUECKE-IM-VERDIKT (erste Haelfte), BESTAETIGT (zweite Haelfte).
Die Sequenzierung ist richtig beschrieben -- und sie ist das GEWUENSCHTE Verhalten: der Guard deckt den Aufruf ab. Das als "Code-Falle" zu fuehren, kehrt korrektes RAII in einen Mangel um.
Zweite Haelfte korrekt: `commit()` (:148) setzt nur `committed_ = true`. Der terminale Done-Store muss explizit erfolgen -- genau das tut der Tier-Pfad (ITER:868-869 `mark_done` + `store_reservation`).

B13 (Store-Ergebnis verworfen: `(void)store_document_merged` an ITER:823)
KLASSIFIKATION: ECHTER-CODE-DEFEKT.
Verifiziert ITER:823 literal. Zusaetzlich: `LagerRunState::flush` liefert `nullopt` bei Store-Fehler (builder_registration.hpp:138), ITER:993-996 druckt das nur als "(store-fehler)" auf `std::cerr` und faerbt den Exit-Code nicht.
Verstoss gegen LED:3208 ("ZWINGEND: bei Programm-Beendigung IMMER die Reservierung aufheben und den Fortschritt JE BUILD klarstellen") und gegen die stehende Direktive "Kein Erfolgs-Haken ohne Ausgabe" / "Fehler -> sichtbar, misst weiter". Verschaerfend: `flush` swappt `fresh_` VOR dem Store leer (:128-131) -- scheitert der Store, ist der Batch auch aus dem RAM weg, ohne Re-Queue.

B14 (Lebensdauer-Falle: make_bestand_transport haelt ArtifactCache const&; an der d2-Stelle existiert keine Instanz)
KLASSIFIKATION: BESTAETIGT (gueltige Implementierungs-Warnung, kein Plan-Konflikt).
Verifiziert `artifact_cache_transport.hpp:20-24` (Kopf dokumentiert die Anforderung explizit), `:37` `const&`. `main.cpp:840` konstruiert die Instanz, die Emit-Zweige returnen bei :452/:470. Praezedenz fuer die korrekte Form steht bei `main.cpp:779` (`auto const ac = atp::ArtifactCache::from_env();` als benanntes Local). Einzeiler, kein Blocker.

=====================================================================
BLOCK IX -- STORAGE-AKTIVIERUNG / CLAIM-CHECK
=====================================================================

B15 (emit_storage_activation fehlt im ceb:emit-Job; gerufen nur :988 und :1117)
KLASSIFIKATION: BESTAETIGT -- und vom Verdikt UNTERGEWICHTET.
Verifiziert per grep: Definition :888, Aufrufe genau :988 und :1117. Der `ceb:emit`-Job (`emit_ceb_emit_job`, :653-688) ruft sie nicht.
Der vom Verdikt nicht gezogene Schluss: `emit_storage_activation` exportiert auch `COMDARE_ARTEFAKT_TRIES=2` (:900). Damit ist `ceb:emit` der EINZIGE Ort, an dem der 12er-Default ueberhaupt noch greift -- und genau dort will (d2) schreiben. B15 ist die praezise Version dessen, was B1 pauschal behauptet.

B16 (kein Claim-CHECK, kein Takeover: is_reservation_takeable/is_takeable_by_eta gebaut, getestet, nie gerufen)
KLASSIFIKATION: ECHTER-CODE-DEFEKT. Die groesste Plan-Verletzung des Pakets.
Verifiziert: `is_reservation_takeable` (:113) und `is_takeable_by_eta` (:105) haben ausser der internen Nutzung in :118 keinen Aufrufer in `libs/`/`apps/`. Ebenso tot: `window_belongs_to` / `BatchPlanner` (`batch_planner.hpp:52, 91`) -- `run_planer_driven_provision` nutzt `SlicePlanner`, der KEINE rank/n_machines-Aufteilung kennt.
Damit sind drei woertliche User-Regeln reines Papier: LED:3208 (Versprechen, "wer zuerst zugreift, bestimmt den ersten Batch"), LED:3217 (Gleichverteilungs-Pflicht, "Sonst blockt die eine Maschine den Fortschritt komplett"), LED:3220 (+50%-Takeover). Konkret: zwei Maschinen mit derselben Perm bauen heute dieselben Slices DOPPELT.
Das Verdikt stellt das richtig fest -- und empfiehlt dann, das Bestandslog abzuschalten, was garantiert, dass es Papier bleibt.

=====================================================================
BLOCK X -- ENV / BYTE-NEUTRALITAET
=====================================================================

B17 (director :734-738 brennt vier Werte in den ceb:trigger-variables-Block; Bytes aendern sich, sobald die Env gesetzt ist)
KLASSIFIKATION: BESTAETIGT (Fakt), kein Defekt.
Verifiziert :733-737 + `if (!vars.empty())`. `append_forward_var_literal` LAESST die Zeile weg, wenn ungesetzt (:695-696) -> der Default ist byte-identisch; die Bytes aendern sich nur bei bewusster Aktivierung. Das ist das Hausmuster fuer Opt-ins. Die Byte-Wache (§33/320) schuetzt den golden-Pfad, nicht Opt-in-Pfade.
Der echte Defekt an dieser Stelle ist B9b (OWNER_UUID/MASCHINE duerfen gar nicht reisen), nicht die Byte-Aenderung.

B17a (Stufe-2-Emission env-frei; genau ein getenv im Director)
KLASSIFIKATION: BESTAETIGT.
Selbst verifiziert: `grep -c "std::getenv"` = 2, davon einer der Include-Kommentar Z.57; der einzige Aufruf steht in :695 innerhalb `append_forward_var_literal`, einem static-Member von `CiYamlBuilder` (Klasse endet ~:758). `TierCiYamlBuilder` (ab :760/788) und `TierCmakeGraphBuilder` lesen keine Env.

B17b (drei Director-Tests rufen unset_g4a_forwarded_opt_ins() nicht)
KLASSIFIKATION: BESTAETIGT und ECHTER-TEST-DEFEKT.
Verifiziert: Helfer :661; Aufrufe bei :669, :732, :748, :803. Die Tests bei :807 (`YamlIsByteDeterministic`), :1175 (`NoCiProjectDirInVariablesBlockBothStages`), :1722 (`SingleComboCebEmitOmits...`) rufen ihn nicht.
Ein Byte-Determinismus-Test, dessen Ergebnis von der Umgebungs-Env abhaengt, ist kein Determinismus-Test. Fix: Helfer aufrufen oder Fixture. Trivial, kein Blocker.

B18 (Log-Kanal: YAML auf std::cout, CI leitet stdout ins Artefakt; eine [bestandslog]-Zeile auf cout = config_error)
KLASSIFIKATION: BESTAETIGT (gueltige Vorsicht).
Verifiziert director :681 `> "$CI_PROJECT_DIR/tier-child-<slug>.yml"`. Das Haus hat das richtige Muster bereits: ITER:993 schreibt nach `cerr`, `log_artefakt_io` (`artifact_cache.hpp:889-895`) nach `cerr`, `run_argv` leitet mc-stdout in eine Datei.

B19 (Halb-Zustand: COMDARE_BESTANDSLOG=true ohne DOC_KEY -> Sidecars werden geschrieben, bleibt byte-neutral)
KLASSIFIKATION: BESTAETIGT.
Verifiziert PRE:311-316 (prueft nur `COMDARE_BESTANDSLOG`), `build_orchestrator.hpp:543` (`write_fingerprint_sidecar`), `push_tier_binary` (`artifact_cache.hpp:228-263`) pusht exakt `perm.dll`, `perm.dll.algos`, `perm.dll.version`. Damit belegt B19 zugleich den Defekt B25.

=====================================================================
BLOCK XI -- SCHNITT-UMFANG
=====================================================================

B20 (genehmigter 1-Datei-Schnitt kompiliert nicht; Naht ist dreischichtig)
KLASSIFIKATION: BESTAETIGT.
Verifiziert das Praezedenz-Muster: Felder in `profile_run_facade.hpp:75-77` (`cache_push`/`cache_pull`/`measurement_sink`), Spiegelung in `profile_run_entry.hpp:98-100`, Zuweisung in `make_cfg` (PRE:464-466). Ein neues Feld braucht Fassaden-Args + Entry + Treiber. Reine Scoping-Aussage, kein Plan-Konflikt.

B21 (grep -c "bestand" experiment_run_entry.hpp = 0)
KLASSIFIKATION: BESTAETIGT.
Selbst verifiziert: 0. Nuance (steht schon im Extrakt): beide Produktionsprofile sind `comdare_thesis_profile` -> pa-Pfad; xa wird fuer das Gate nicht gebraucht.

B22 ((d1)-Anker :841-870 falsch; :840 Cache-Bau, :852 Closure-Bau, Injektion 962-964 / 1056-1058)
KLASSIFIKATION: BESTAETIGT.
Literal verifiziert: :840 `std::make_shared<at::ArtifactCache>(at::ArtifactCache::from_env())`, :852 `if (!artifact_cache->inert())`, :962-964 `xa.cache_push/cache_pull/measurement_sink`, :1056-1058 dieselben auf `pa`. Korrekte Korrektur eines anderen Berichts.

=====================================================================
BLOCK XII -- W-30 / ZEITBUDGET
=====================================================================

B23 (resolve_measure_parallelism gibt 0 bei !measurement_on || single_thread; 320er faehrt measure/release)
KLASSIFIKATION: BESTAETIGT, plan-konform.
Verifiziert `measure_parallelism.hpp:24-25` literal. Der Code implementiert §61-MODI ("Debug=parallel/Mess=1-Thread") exakt. Die Rechnung des Verdikts stimmt und widerspricht dem Plan nicht.

B24 (W-30 gebaut: ce-Commit 99a608c2..., in development/main/beiden GitHub-Spiegeln; Ledger :3194 stale)
KLASSIFIKATION: BESTAETIGT.
Selbst verifiziert: `git log --oneline -1 99a608c2331a...` = "feat(measure): #45 paralleler MESS-Loop ...". `git branch -a --contains` listet `development`, `main`, `remotes/github/development`, `remotes/github/main`. Ledger Z.3194 ist die Zeile "(b) VORBEHALT ... Es existiert KEIN paralleler MESS-Loop" -- gegenueber dem Commit tatsaechlich stale.

=====================================================================
BLOCK XIII -- NEBENBEFUNDE
=====================================================================

B25 (.fingerprint nicht im Push-Objektsatz; hydrierte Binaries tragen nie einen Fingerprint; LagerKey ohne +cxx/+bt/+ceb)
KLASSIFIKATION: ECHTER-CODE-DEFEKT. Entscheidend fuer den Zweck des ganzen Lagers.
Verifiziert `push_tier_binary` (:228-263): exakt `perm.dll`, `perm.dll.algos`, `perm.dll.version`. `LagerKey` (`bestandslog_index.hpp:95-101`) = (Sha512Key, ZellKoordinaten{combo,opt,simd}) -- kein cxx/bt/ceb.
Folge: eine Maschine, die eine Binary aus minio zieht, hat kein `.fingerprint` daneben -> `bestand_key_of` liefert nullopt -> `DedupOutcome::no_key` -> die Binary ist fuer das Lager unsichtbar. Das Lager kann exakt das nicht deduplizieren, was es hydriert hat. Damit ist der User-Zweck aus C1/LED:3216 ("welche Binaries es im cache schon gibt") maschinenuebergreifend unerfuellt.
FIX: `.fingerprint` (und `.variant`, s.u.) in den Push-Satz.

B26 (write_fingerprint_sidecar ohne Newline; eine Datei mit \n ergibt 129 Zeichen -> stiller no_key)
KLASSIFIKATION: BESTAETIGT (Robustheitsluecke, geringe Schwere).
Verifiziert `build_orchestrator.hpp:302-306` (`f << fingerprint`, kein Newline) und `key_from_hex` (`bestandslog_index.hpp:73-74`, `if (hex.size() != 128) return std::nullopt`). Der Roundtrip funktioniert heute, weil Schreiber und Leser im Haus sind. Er bricht, sobald irgendetwas die Datei anfasst. Fix: trimmender Read in `bestand_key_of`.

B27 (Typ-Kollision: erwartet optional<string>(path const&), nicht ex::FingerprintFn string->string)
KLASSIFIKATION: BESTAETIGT.
Verifiziert ITER:216 `std::function<std::optional<std::string>(std::filesystem::path const&)> bestand_key_of;` gegen `build_orchestrator.hpp` Aufruf `fingerprint_(spec.binary_id)` (string in, string out). Zwei verschieden signierte Funktionstypen mit verwechselbar aehnlicher Rolle.

B28 (fingerprint_sidecar_path in build_orchestrator.hpp:298-300; "dritter Weg")
KLASSIFIKATION: BESTAETIGT (Fakt) + kleiner ARCHITEKTUR-DEFEKT.
Verifiziert: `fingerprint_sidecar_path` steht bei `build_orchestrator.hpp:298-300`. Damit hat der Bestandslog-Leser nur schlechte Optionen: `build_orchestrator.hpp` inkludieren (bricht die eigene Doktrin "nur stdlib + bestandslog_document.hpp", `bestandslog_lock.hpp:22`) oder das Suffix ".fingerprint" duplizieren (bricht Single-Source). Saubere Loesung: den Pfad-Helfer in einen kleinen gemeinsamen Header ziehen.

B29 (Reihenfolge-Entwarnung: Sidecar vor finalize; id mit "/" emit-sicher)
KLASSIFIKATION: BESTAETIGT.
Verifiziert `build_orchestrator.hpp`: `write_fingerprint_sidecar(...)` im `if (r.status == 0)`-Block, danach `finalize(j, std::move(r));`, das erst `on_binary_done_` ruft. `id` laeuft durch `detail::xml_encode` (`bestandslog_document.hpp:310-311`); "/" ist in einem XML-Attributwert legal.

B30 (Prioritaets-Reihung des ADVERSARIAL-Berichts)
KLASSIFIKATION: BESTAETIGT als Wiedergabe; meine Reihung weicht ab.
Nach Plan-Massstab: B16 (kein Takeover, keine Maschinen-Paritaet) und B25 (Fingerprint reist nie) sind die entscheidenden -- sie machen den vom User verfuegten Lager-Zweck unerfuellbar. Danach B7 (Voll-Wipe), B7a/B2c (ungelockte Schreibvorgaenge), B3 (Merge ohne den vom User verlangten std::map-Lookup), B11 (pro-forma null). Lens 1 und 6 sind nachrangig.

B31 (K8: keine der beiden Blocker-Listen ist vollstaendig)
KLASSIFIKATION: BESTAETIGT -- und ich kann die Liste erweitern.

LUECKEN, DIE BEIDE BERICHTE NICHT NENNEN (alle selbst verifiziert):
(L-a) KEINE RESERVIERUNGS-AUFHEBUNG. LED:3222 verlangt "ALLE Reservierungen und ETAs werden im Log nach Fertigstellung AUFGEHOBEN". `merge_documents` (:240-251) fuegt nur hinzu und stuft hoch; nichts entfernt je eine done-Reservierung. Der `reservierungen`-Vektor waechst monoton und unbegrenzt.
(L-b) OWNER_UUID/MASCHINE werden PLAN-WEIT geforwarded (director :694-698 + :748-750). Per-Maschinen-Identitaet ist damit strukturell unmoeglich -> LED:3217/3208 unerfuellbar. Beide Berichte streiten ueber den hypothetischen Fall, statt den Forward zu lesen.
(L-c) `pro_forma_bis_utc` ist ISO-String, alle Takeover-Praedikate nehmen Epoch-Sekunden, und es gibt im ganzen `bestandslog/` KEINEN ISO->Epoch-Parser (verifiziert: kein timegm/mktime/parse_iso). Auch ein korrekt geschriebener 30-min-Wert haette keinen Leser.
(L-d) `.variant`-Sidecar wird ebenfalls nie gepusht (grep in `artifact_cache.hpp`: 0 Treffer). Gleiche Klasse wie B25, das A7-B-Cross-Maschinen-Gate laeuft damit maschinenuebergreifend ins Leere.
(L-e) `document_syntax_supported` existiert und wird nie gerufen, waehrend der Kommentar :269 den Schutz behauptet, den sie leisten wuerde.
(L-f) `reservation_lifecycle.hpp` enthaelt Nicht-ASCII-Kommentarzeichen (Box-Zeichen in den Trennlinien :36, :52, :81, :94, :121) -- Verstoss gegen die ASCII-only-Direktive.

=====================================================================
FAZIT FUER DEN ARCHITEKTEN
=====================================================================

1. Der N7-Aufschub ist NICHT getragen. Seine Traeger B1/B2d/B2e sind: eine Zahl, die nur unter einer plan-widrigen Retry-Platzierung entsteht (und in der scharfen CI durch TRIES=2 ohnehin auf ~8 min faellt), eine Fehllesung von "Millisekunden" als Wall-Clock-SLA statt als Aussage ueber den Schreib-Umfang, und ein Alternativ-Zweig, den §66-G3 gerade nicht hergibt. Der Owner hat recht: die N7-Sektion dauert keine 40 Minuten -- sie ist EIN kleiner Schreibvorgang, und dass der Code sie mit 12x120s Netz-Retries fuellt, ist der zu behebende Defekt.

2. P-2 (Bestandslog AUS) loest keinen einzigen der gefundenen Defekte, sondern konserviert sie und hebelt zugleich das vom User verfuegte Lager-Gate (E6/§66) aus. Die Defekte B3, B5, B5b, B7, B11, B13 sind samt und sonders lokale Code-Fixes.

3. d2-HOLD ist in EINEM Punkt berechtigt und in den uebrigen nicht: B8 (falscher Anker) ist stichhaltig und verlangt Re-Anker auf die `--dump-ci`/`--dump-cmake`-Strecke. B8a verlangt ein eigenes Versions-Feld (additiv, §66-G2-Fenster offen). B6/B6a sind Fehler der Manager-Auflage L2, nicht des Plans -- LED:3221 schluesselt auf die CEB-VERSION, nicht auf den doc_key. B12/B12a/B12b bepreisen Risiken neu, die LED:3219/3220 bereits eingepreist haben.

4. Rangfolge der zu fixenden CODE-Defekte: B7 (Voll-Wipe, Datenverlust) > B16 + fehlende Maschinen-Paritaet (Doppelbau, LED:3217) > B25 + L-d (Fingerprint/Variant reisen nie -> Lager nutzlos) > B2c/B7a (ungelockter Schreibpfad, N7) > B3 (Merge ohne std::map) > B11 + L-c (pro-forma null) > B9a/L-b (Owner-Identitaet) > B5/B5b (fehlende Gates) > B13 (verschluckte Store-Fehler) > L-a (keine Aufhebung) > B17b/L-f.

Geprueft gegen (absolute Pfade):
/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/builder/bestandslog/{bestandslog_lock,reservation_lifecycle,planer_driven_build,builder_registration,bestandslog_document,bestandslog_index,eta_estimator,artifact_cache_transport,batch_planner,bestandslog_factory}.hpp
/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp
/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/builder/artifact_transport/artifact_cache.hpp
/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp
/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/profile_facade/{profile_run_entry,profile_run_facade}.hpp
/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp
/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/tests/unit/CMakeLists.txt
/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/tests/unit/{test_g3_planer_driven.cpp,thesis_tiere/test_experiment_plan_director.cpp}
/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/02_messung_driver/main.cpp
/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md

Selbstcheck: `grep -P '[^\x00-\x7F]'` ueber diese Meldung: nur `§` (erlaubt). Keine Gedankenstriche, keine Box-Zeichen, keine Pfeile, keine Emojis. Keine Datei geaendert, kein Report-File geschrieben.