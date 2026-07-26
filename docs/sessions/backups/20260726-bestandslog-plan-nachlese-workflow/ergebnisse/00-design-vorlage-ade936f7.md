# DESIGN-VORLAGE ZUR USER-ABNAHME -- Bau 26.07.2026 (Lager-Gate, Bestandslog AN)

Stand: ce @ 5795fae2 (development, Working-Tree sauber ausser `Testing/`), super @ Gitlink 5795fae2.
Belege: Datei:Zeile literal nachgelesen; Ledger-Zeilen = `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`.
Nichts unten ist gebaut. ABNAHME-PUNKTE sind mit `[ABNAHME-n]` markiert.

---

## (1) N7-LOCK-SOLL

### 1.1 SOLL nach Plan (woertlich)

LED:3225 (§62-B, SCHREIB-LOCK-SEMANTIK, User 22.07. Praezisierung-3):
> "das Bestandslog wird beim SCHREIBVORGANG einer Maschine GELOCKT -- z.B. auch, wenn das ETA
> errechnet werden soll. Das Lock fuer das Schreiben eines Bestandslogs endet SPAETESTENS mit der
> ersten pro-forma-30-Minuten-Reservierung."
> [Konsolidierungs-Anm.] "das LOCK ist die KURZE Schreib-Exklusivitaet am Dokument selbst
> (Obergrenze = bis die Initial-Reservierung im Log steht) ... Eine tote Maschine kann das Dokument
> also nie dauerhaft sperren -- nach der 30-min-pro-forma-Grenze schuetzt nur noch die
> Reservierungs-/Takeover-Mechanik."

LED:3227 (N8, Multi-Write):
> "SOBALD fuer das Bestandslog KOMPILIERT wird, ist das Bestandslog MULTI-WRITE freigegeben -- die
> Vorgaenge REGISTRIEREN sich dann nur; das Schreiben beschraenkt sich auf die Eintragung der
> Reservierung der Maschine (NUR MILLISEKUNDEN). Der HAUPT-BLOCKER ist die ETA-BERECHNUNG (der
> einzige laengere Schreib-Lock-Fall)."

Daraus die drei geforderten Groessen:

**(a) WAS das Lock deckt.** GENAU EINEN Schreibvorgang am Bestandslog-DOKUMENT, d.h. genau einen
fetch-merge-store-Zyklus (`store_document_merged`, bestandslog_lock.hpp:262-276). Namentlich
eingeschlossen ist der ETA-Schreibvorgang ("z.B. auch, wenn das ETA errechnet werden soll").
NICHT gedeckt: Compile, Presence-/Miss-Scan, Batch-Planung, Artefakt-Push (`push_tier_binary`),
Lock-Erwerb und Lock-Freigabe selbst. N8 "der EINZIGE laengere Schreib-Lock-Fall" sagt explizit,
dass auch die Registrierungen Schreib-Lock-Faelle sind -- nur kurze.

**(b) DAUER.** Zwei getrennte Zahlen:
- Ziel-Dauer der Registrierungs-Schreibung: "NUR MILLISEKUNDEN" (LED:3227). Das ist eine Aussage
  ueber den UMFANG (eine Zeile, keine Voll-Rechnung), nicht ein Wall-Clock-SLA auf einen S3-Roundtrip.
- Harte Obergrenze: "endet SPAETESTENS mit der ersten pro-forma-30-Minuten-Reservierung"
  (LED:3225). Sobald die Initial-Reservierung im Log steht, MUSS das Lock weg sein.
- **PLAN SCHWEIGT** zur Lock-TTL-Zahl und zur Retry-/Jitter-Politik. Das ist eine dokumentierte
  Ledger-Luecke, keine Code-Freiheit -> `[ABNAHME-1]` unten.

**(c) ENDE-BEDINGUNG.** Drei Wege, alle plan-belegt:
1. Normalfall: nach dem einen Store -> `release_lock` (bestandslog_lock.hpp:170-175).
2. Obergrenze: Initial-Reservierung steht -> Lock ist fachlich beendet (LED:3225).
3. Tote Maschine: ttl-Bruch durch JEDE Maschine (LED:3225 "kann das Dokument also nie dauerhaft
   sperren"); danach traegt nur noch Reservierung/Takeover (LED:3220). Der Stale-Bruch in
   bestandslog_lock.hpp:139-141/:153-156 ist damit PLAN-FORDERUNG, kein Defekt.

**Abgeleitete Invariante (Folge aus (b)+(c)3, im Plan nicht ausgeschrieben):**
`Sektions-Wall-Clock-Budget < ttl_s`. Wird sie verletzt, bricht eine zweite Maschine den Lock,
waehrend der erste Schreiber noch schreibt -> zwei Schreiber -> genau der Zustand, den N7 verbietet.
Diese Ungleichung ist der eigentliche Bau-Auftrag, nicht "Lock ja/nein".

### 1.2 IST-Abweichungen im Code (je mit Fix-Schnitt)

**N7-D1 -- Kein Produktions-Aufrufer.** `try_acquire_lock` (bestandslog_lock.hpp:149) und
`release_lock` (:170) haben ausser den Definitionszeilen KEINEN Treffer in `libs/`/`apps/`. Alle
drei realen Schreibstellen laufen UNGELOCKT:
`cache_engine_builder_iterator.hpp:823` (`(void)store_document_merged(...)` je Reservierung),
`:869` (Done-Store), `builder_registration.hpp:137` (`LagerRunState::flush`).
Direkter Verstoss gegen LED:3225 Satz 1.
Schnitt: NEUE Funktion `with_document_lock(t, doc_key, me, ttl_s, now_fn, fn)` in
bestandslog_lock.hpp nach :175 (Acquire -> Frist-Wache -> fn -> Release, EIN Versuch je Zyklus,
Jitter-Backoff um den GANZEN Zyklus -- exakt die Bauform, die der Kopfkommentar :144 selbst
vorschreibt: "EIN Versuch (kein Backoff-Loop; der Aufrufer wiederholt mit Zufalls-Jitter)").
Danach die drei Schreibstellen darauf umhaengen.
Aufwand: Helfer + Tests 2,5 Ah; drei Aufruf-Stellen + Tests 2,0 Ah.

**N7-D2 -- Netz-Retries LIEGEN in der Sektion.** `object_store` (artifact_cache.hpp:506-530) ruft
`mc_cp` (:690-698) mit `tries_=12` (:950), `sleep_s_=5` (:951), `mc_push_timeout_s_=120` (:958);
je Versuch `mc cp` (Cap 120s) + `mc_size_verified` (:733-749, `mc stat`, Cap 120s).
`object_fetch` (:486-502) = `mc_remote_exists` (Cap 20s) + `mc_pull` (`pull_tries_=2`, Cap 20s,
1s Pause) -> worst 61s.
Worst-case-Sektion heute:
- Default (TRIES=12): 61 + (12*240 + 11*5) = 2996 s = **~50 min**
- Mit `COMDARE_ARTEFAKT_TRIES=2` (was `emit_storage_activation` setzt, director:900): 61 + 485 = **~9 min**
- Mit TRIES=1 und Default-Caps: 61 + 240 = **~5 min**
Alle drei > `ttl_s = 30` (bestandslog_lock.hpp:84). Die Invariante aus 1.1 ist in JEDER heutigen
Konfiguration verletzt.
Schnitt (minimal, eine Datei): neue Methode
`[[nodiscard]] ArtifactCache with_object_budget(std::size_t tries, std::size_t timeout_s) const;`
in artifact_cache.hpp neben :504 (Kopie + `tries_`/`mc_push_timeout_s_`/`pull_tries_`/
`mc_pull_timeout_s_` setzen, ~8 Zeilen). Der Host baut daraus die ZWEITE, knapp budgetierte
Instanz und bindet NUR den Bestandslog-Transport daran (`make_bestand_transport`,
artifact_cache_transport.hpp:37). Kein zweiter Transport-Weg, kein Runtime-Switch.
Vorschlag-Zahlen: tries=1, cap=10 s -> Sektion worst = 10 (stat) + 10 (pull) + 10 (cp) + 10 (stat-verify)
= **40 s**. Damit ttl_s=30 immer noch zu klein -> `[ABNAHME-1]`.
Aufwand: 1,0 Ah inkl. Test.

**N7-D3 -- ttl-Zahl.** `LockRecord::ttl_s = 30` (bestandslog_lock.hpp:84). Der Ledger nennt keine
Zahl. 30 s ist bei einem 40-MB-Dokument (siehe N7-D4) und 40 s Worst-Budget zu knapp.
Schnitt: Default auf 90 s, `ttl_s` bleibt Parameter von `try_acquire_lock` (:150) -- keine
Signatur-Aenderung. Zusaetzlich Frist-Wache IM Helfer: vor dem Store `now - acquired > ttl/2`
pruefen -> dann NICHT schreiben, Lock freigeben, Zyklus mit Jitter wiederholen (verhindert das
Schreiben unter einem bereits gebrochenen Lock).
Aufwand: 0,5 Ah (im Helfer aus N7-D1 enthalten).

**N7-D4 -- Voll-Dokument-RMW fuer eine Zeile.** `store_reservation`
(cache_engine_builder_iterator.hpp:818-824) baut fuer EINE Reservierung ein Dokument und ruft
`store_document_merged` -> fetch + parse + merge + emit + store des VOLLEN Dokuments. Bei 131072
`<eintrag>`-Zeilen a 300-500 Byte (emit_document, bestandslog_document.hpp:285-305) sind das
39-65 MB pro Schreibvorgang. Das ist genau das Gegenteil von LED:3227 "die Vorgaenge REGISTRIEREN
sich dann nur".
Schnitt A (heute, minimal): Sektion bleibt Voll-RMW, aber Budget+ttl nach D2/D3 -> plan-VERTRAEGLICH,
nicht plan-IDENTISCH. Aufwand 0 (in D2/D3 enthalten).
Schnitt B (plan-nah, NICHT heute): per-Owner-Sidecar-Objekt je Registrierung, Union beim Lesen ->
lock-frei und wirklich millisekundenkurz. Aufwand 1,5-2 Agenten-Tage inkl. Leser/Merge/Tests.
`[ABNAHME-2]`.

**N7-D5 -- Leerer owner_uuid hebelt beide Waechter aus.** `parse_lock` (:104-137) setzt
`have_owner = true` auch bei leerem Wert (:114-116); :135 prueft nur die Anwesenheit des Keys.
Folge: `try_acquire_lock:153` `"" != ""` ist false -> fremder frischer Lock wird ueberschrieben;
`release_lock:173` `"" == ""` ist true -> fremder Lock wird geloescht. Der Kommentar :135 ("owner
ist Pflicht -> nie stille Fehlfaerbung") ist damit unwahr.
Schnitt: in `parse_lock` `if (!have_owner || r.owner_uuid.empty()) return std::nullopt;` (:135) plus
Fail-Closed beim `LockOwner`-Bau im Host (leerer uuid => Bestandslog bleibt AUS).
Aufwand: 0,5 Ah inkl. 2 Tests.

### 1.3 Ehrliche Aufwands-Schaetzung N7

| Schnitt | Datei | Ah |
|---|---|---|
| D1 Helfer `with_document_lock` + Tests | bestandslog_lock.hpp (+Test) | 2,5 |
| D1 drei Schreibstellen umhaengen | iterator.hpp:823/:869, builder_registration.hpp:137 | 2,0 |
| D2 `with_object_budget` | artifact_cache.hpp:504 | 1,0 |
| D3 ttl + Frist-Wache | bestandslog_lock.hpp:84 (+Helfer) | 0,5 |
| D5 owner-Pflicht | bestandslog_lock.hpp:135 | 0,5 |
| **Summe Variante A** | | **6,5 Ah** = ca. 1 Agenten-Tag |
| Variante B (Sidecar-Registrierung, N8-identisch) | neu | +12-16 Ah |

Ehrlichkeits-Vorbehalt: ctest deckt nur den Fake-Transport (In-Memory-Map). Der Beweis, dass die
Sektion unter ttl bleibt, ist NUR ueber einen realen minio-Smoke auf prod1 zu fuehren (2 Prozesse,
gleicher doc_key, gemessene Sektions-Dauer). Das ist +1,0 Ah und ist Teil der Abnahme, nicht
optional -- sonst waere es ein Erfolgs-Haken ohne literale Ausgabe.

---

## (2) E1-E5: ANTWORTEN AUS DEM PLAN

### E1 -- planer_block: Vertragsebene / Anker

**PLAN-ANTWORT: Planer-Strecke (`--dump-ci` / `--dump-cmake`), NICHT `--emit-tier-ci`.**
Beleg LED:3221: *"ein Planer blockt einen Compile einer CEB DIREKT im Log ohne ETA mit einer
Reservierung von 30 Minuten fuer diese Version."* Subjekt = PLANER, Objekt = CEB-Compile.
Beleg LED:3223: *"die Reservierungen decken compile+pruef der CEB ... UND den Compile der CEB
durch den Planer ab -- als STRATEGY PATTERN fuer das Caching."*
Rollen-Zuordnung im Code literal: main.cpp:437 *"der Planer steuert die CEB-Jobs (--dump-ci), die
CEB steuert die Tier-Jobs (--emit-tier-ci)"*; Flags: `--dump-ci` main.cpp:415, `--dump-cmake` :426,
`--emit-tier-ci` :439, `--emit-tier-cmake` :457.
Der Job, der real einen CEB-Compile ausloest (`ceb:build`), entsteht in der Stufe-1-YAML, also am
`--dump-ci`-Pfad; `--emit-tier-ci` emittiert Tier-Jobs, deren Reservierung bereits existiert
(iterator:826-843, `BatchTyp::tier`). Ein planer_block dort waere Doppel-Reservierung und mischt
Batch-Typen (LED:3229).
**Praezisierung (Plan nennt Rollen, nicht CLI-Flags):** die Abbildung Rolle -> Flag ist Code-Fakt
(main.cpp:437), nicht Ledger-Text. Sie ist eindeutig, aber sie ist eine Ableitung.
**Betriebs-Konsequenz, heute unerfuellt:** `--dump-ci` laeuft in `planer:delegate`
(super `.gitlab-ci.yml:1228-1272`, Aufruf :1265). Dieser Job referenziert `.storage_cache_activation`
(:570) NICHT -> `ArtifactCache::from_env()` ist dort INERT -> ein planer_block waere dort heute
wirkungslos. Siehe (3) Punkt 8.
Der Manager-Entscheid der Vorsession ("Reservierung haengt an --emit-tier-ci/--emit-tier-cmake",
Handover-5 §2 Befund 1) ist damit **plan-widrig und zu revidieren**. `--dump-plan` bleibt
nebenwirkungsfrei -- das war korrekt.

### E2 -- id-Semantik, Maschinen-Feld, Re-Open, Retention

**E2.a id-Semantik.** **PLAN SCHWEIGT zur Zusammensetzung der `id`.** Der Plan sagt WOFUER
reserviert wird (LED:3221 "fuer diese Version"), nicht WIE der Record-Schluessel gebildet wird.
Zwei plan-seitige Randbedingungen gelten:
- LED:3412-3413 (§66-N3, KERN=Gesetz): *"ALLE Achsen sind IMMER getrennt zu behandeln und zu
  KLAMMERN (keine Fusion in Signaturen/Schluesseln/Stempeln -- je Achse ihr eigenes Feld/ihre eigene
  Klammer)."* -> die Version DARF NICHT in die `id` gequetscht werden.
- LED:3224: *"der ccache-Bestand wird NEU INVENTARISIERT, wenn das Log geloescht wird ODER Planer
  und CEB durch Code-Aenderung in einer neuen Version ersetzt werden muessen."*
=> Die Manager-Auflage L2 (`owner_uuid + "/plan/" + doc_key`, Handover-5 §2) ist **nicht
plan-gedeckt**: `doc_key` ist der Log-Objektschluessel, nicht die CEB-Version; die id waere ueber
alle Laeufe DERSELBEN Version stabil und wuerde mit `pick_reservierung`
(bestandslog_lock.hpp:200-208, done schlaegt offen) einen neuen `offen`-Eintrag verwerfen.
**Owner-Entscheid noetig** `[ABNAHME-3]`.

**E2.b Maschinen-Feld.** **PLAN-ANTWORT: PFLICHT, und PER MASCHINE abzuleiten.**
LED:3217: *"die CEBs benoetigen ueber dieses Dokument ABSPRACHEN, wie sie sich die Batches
aufteilen ... Sonst blockt die eine Maschine den Fortschritt komplett."*
LED:3208: Reservierung = Versprechen, *"wer zuerst zugreift, bestimmt den ersten Batch"*.
LED:3230: Thread-Budget je Maschine (prod1 32/24, prod2 24/16).
Das POD hat die Felder: `maschine` (bestandslog_document.hpp:194), `threads` (:195).
**Ist-Verstoss:** `experiment_plan_director.hpp:736-737` brennt `COMDARE_BESTANDSLOG_OWNER_UUID`
und `_MASCHINE` per `append_forward_var_literal` (:694-698, liest `std::getenv` in der
PLANER-Umgebung) LITERAL in den `variables:`-Block und traegt sie via `forward: yaml_variables:
true` (:748-750) ueber die zweite Trigger-Grenze. Alle Lanes bekommen damit DENSELBEN Wert ->
prod1 und prod2 sind im Log nicht unterscheidbar -> LED:3217 und LED:3220 strukturell unerfuellbar.
Nur `_DOC_KEY` ist ein lauf-weiter Fakt und darf reisen.

**E2.c Re-Open.** LED:3222: *"ALLE Reservierungen und ETAs werden im Log nach Fertigstellung eines
Batches AUFGEHOBEN und mit 'Done' gekennzeichnet."* -> done ist fuer DIESEN Batch terminal.
Ob eine `done`-id spaeter wieder `offen` werden darf: **PLAN SCHWEIGT -- Owner-Entscheid noetig.**
(Im Tier-Pfad ist die Frage gegenstandslos: ids sind `owner_uuid + "/" + slice_seq`,
iterator:832, also je Maschine und je Lauf disjunkt.)

**E2.d Retention.** Zwei Teil-Antworten:
- Dokument-Ebene: LED:3224 gibt die GC-Grenze -- Neu-Inventarisierung bei geloeschtem Log oder
  neuer Planer-/CEB-Version.
- Record-Ebene (werden `done`-Records physisch entfernt oder nur gestempelt?): das Wort
  "AUFGEHOBEN" traegt beide Lesarten. `merge_documents` (bestandslog_lock.hpp:240-251) entfernt
  nie etwas. **PLAN SCHWEIGT -- Owner-Entscheid noetig** `[ABNAHME-3]`.
  Groessenordnung heute: 32 Slices x 2 Maschinen x ~200 Byte = ca. 13 KB je Voll-Lauf, also fuer
  Voll-Bau-4 unkritisch.

### E3 -- Strecken-Feld / POD

**PLAN-ANTWORT: eigenes Feld, kein id-Anhaengsel, mit Syntax-Bump.**
LED:3221 verlangt die Bindung "fuer diese Version"; LED:3412-3413 verbietet die Fusion in
Schluessel. `BatchReservierung` (bestandslog_document.hpp:189-203) hat heute KEIN Versions-Feld.
Plan-konform: neues Attribut am `<batch>`-Element + `kSyntaxVersion` 2 -> 3
(bestandslog_document.hpp:74). Das Bruch-Fenster ist ausdruecklich offen: LED:3367-3368 (§66-G2)
*"STEMPEL-Finalisierung = bewusstes Cache-Bruch-Fenster JETZT ... supersediert die 'vor
01.08.'-Parkung"*.
`slice_begin = slice_count = 0` fuer planer_block ist konsistent mit "ohne ETA ... blockt einen
Compile" (LED:3221) -- so heute in `make_planer_block_reservation`
(experiment_plan_director.hpp:1263-1270) umgesetzt.

**WAS in das Feld gehoert: PLAN SCHWEIGT -- Owner-Entscheid noetig.** Der Plan bietet zwei
gleichwertige CEB-Identitaeten an, ohne zu waehlen:
- LED:3312: *"[a,b,c] -> CEB-Binary-Replay"* (die Mess-Achsen-Klammer der CEB), und
- LED:3233: *"jede CEB und jedes Tier-Binary erhaelt ein SEPARATES Versionierungsinterface als
  CONSTEXPR-Funktion, das einen SHA512 ... bildet"* + LED:3234 (std::map-Lookup SHA512 -> Pfad).
Empfehlung (nicht Plan): BEIDE als getrennte Attribute (`ceb_legende` + `ceb_key_sha512`) -- das ist
die einzige Form, die LED:3413 "je Achse ihr eigenes Feld" nicht verletzt und den Lookup aus
LED:3234 bedient. `[ABNAHME-4]`

Nebenbefund zum Helfer: `make_planer_block_reservation(owner_uuid, seq, ...)`
(experiment_plan_director.hpp:1264, Test `test_experiment_plan_director.cpp:1502` erwartet
`"6f1c2b3a-.../7"`) kann die Version nicht tragen -- ein benannter Parameter kommt additiv dazu.

### E4 -- Wert-Funktion

**PLAN-ANTWORT: Doppel-CEB-Compile-Vermeidung plus Takeover-Faehigkeit.**
LED:3207: *"3-Stufen-Dedup: bereits gebaute Planer, CEB oder Tier-Binaries werden NIE erneut
gebaut."*
LED:3208: Reservierung = *"VERSPRECHEN ... wer zuerst zugreift, bestimmt den ersten Batch"*.
LED:3220: *"wird das ETA um 50% OHNE UPDATE ueberschritten, duerfen andere Maschinen davon
ausgehen, dass die Pipeline der Maschine GESTORBEN ist, und nehmen stattdessen die Arbeit auf,
die noch offen und nicht im Log als Bestand verzeichnet ist."*
LED:3305 nennt den bezahlten Preis: *"Wiederaufnahme ohne Totalverlust (Lehre Pipeline 11519:
gecancelt = Teilstand VERLOREN)"*.
Der Wert entsteht also erst mit einem LESER. Ohne Claim-Check ist ein planer_block eine
Schreibuebung -- exakt das Muster, das Fix A beim Prune schon einmal aufgedeckt hat.

**PLAN SCHWEIGT -- Owner-Entscheid noetig:** ob die fertige CEB-Binary zusaetzlich als
`<eintrag>` im Binary-Bestand landet (und wer sie in den Store pusht). LED:3207 und LED:3233/3234
implizieren es, LED:3232 ordnet die Bestaende zu, aber es gibt keinen Satz, der die
CEB-Einlagerung anordnet, und keinen CEB-Push im Code (`push_tier_binary`,
artifact_cache.hpp:228-263, pusht nur Tier-Artefakte). `[ABNAHME-5]`

### E5 -- Lock fuer den planer_block-Schreibvorgang

**PLAN-ANTWORT: EIN kurzer, gelockter Schreibvorgang; Lock endet mit der Eintragung.**
Der planer_block IST die "erste pro-forma-30-Minuten-Reservierung" aus LED:3225 -- genau der
Punkt, an dem das Lock spaetestens endet. Umfang nach LED:3227: "die Eintragung der Reservierung
der Maschine (NUR MILLISEKUNDEN)". Vollstaendige Semantik siehe Abschnitt (1).

**PLAN SCHWEIGT -- Owner-Entscheid noetig** `[ABNAHME-1]`:
- Lock-TTL-Zahl (Ledger nennt keine).
- Verhalten, wenn der Lock nicht zu bekommen ist. Der planer_block sitzt auf `--dump-ci`, das
  rein-lesend und byte-deterministisch sein MUSS (super :1265 leitet stdout in ein Artefakt;
  Byte-Wachen §33/320). Drei Optionen: (i) N Jitter-Versuche, dann OHNE Block emittieren +
  `[bestandslog] warn`-Zeile auf stderr (Emission gruen), (ii) Job hart rot, (iii) Block
  nachtraeglich im ceb:build-Job. Empfehlung: (i) -- "Fehler sichtbar, misst/baut weiter".
- Log-Kanal: JEDE Bestandslog-Zeile aus `--dump-ci`/`--emit-*` MUSS auf `stderr` (director:681
  und super :1265 leiten stdout ins YAML-Artefakt; eine Zeile auf stdout = `config_error`).
  Hausmuster liegt vor: iterator:993 (`std::cerr`), `log_artefakt_io` (artifact_cache.hpp).

---

## (3) BESTANDSLOG-AN-ERTUECHTIGUNG fuer Voll-Bau-4 (Option B, User-Order)

Vorbedingung, die alles rahmt: `bestandslog_active` (iterator:927-929) ist heute IMMER false.
`grep -rn "COMDARE_BESTANDSLOG" --include=*.yml --include=*.yaml --include=*.sh --include=*.cmake
--include=*.xml --include=*.bat` ueber das Super-Repo: **0 Treffer** (selbst verifiziert). In
main.cpp werden `xa`/`pa` nur mit `cache_push/cache_pull/measurement_sink/partial_marker_sink/
progress_sink` belegt (:962-968, :1056-1062); kein `bestand_*`-Feld ausser
`bestand_fingerprint_fn` (profile_run_entry.hpp:458) und `bestand_zelle` (:460).
Option B heisst deshalb: **erst verdrahten, dann ertuechtigen** -- die Liste unten ist die
Ertuechtigung, G4b-1 ist die Verdrahtung.

Priorisiert. "vor Trigger" = vor dem Voll-Bau-4-POST auf Projekt 288.

| # | Punkt | vor Trigger | Grund | Schnitt (datei:zeile) | Ah |
|---|---|---|---|---|---|
| 1 | **Voll-Wipe-Guard (B7)** | **JA** | Einziger Punkt mit DATENVERLUST: unlesbares Remote -> `to_write = local` -> ein Dokument mit EINER Reservierung und LEEREM `bestand` ueberschreibt den ganzen Lagerbestand. `object_store` ist ueberschreibendes `mc cp` ohne Versionierung/Backup. Ein 2-Tage-Lauf kann so seinen kompletten Log verlieren. | bestandslog_lock.hpp:262-276: bei `parse_bestandslog`-nullopt **nicht schreiben**, `nullopt` zurueck + `[bestandslog] FEHLER`-Zeile auf `cerr`. Zusaetzlich `document_syntax_supported` (bestandslog_document.hpp:221-223) VOR dem Merge rufen -- die Funktion existiert und hat heute 0 Produktions-Aufrufer, waehrend Kommentar :269 ihren Schutz behauptet. `doc_revision`-Bump in BEIDE Zweige. | 1,5 |
| 2 | **Maschinen-Identitaet (B9b / L-b / B9a)** | **JA** | Ohne sie ist jede Log-Zeile anonym: LED:3217 (Gleichverteilung) und LED:3220 (Takeover) sind unerfuellbar, und der Lock aus (1) waere wirkungslos (jeder haelt jeden Lock fuer den eigenen). Billig und irreversibel-wichtig, weil der 2-Tage-Log sonst unbrauchbar ist. | (a) `experiment_plan_director.hpp:736-737`: die zwei `append_forward_var_literal`-Zeilen fuer `_OWNER_UUID` und `_MASCHINE` ENTFERNEN (nur `_DOC_KEY` und `COMDARE_BESTANDSLOG` reisen). (b) Ableitung auf dem Runner in `emit_storage_activation` (:888-902): `COMDARE_BESTANDSLOG_MASCHINE="${COMDARE_BESTANDSLOG_MASCHINE:-$(hostname)}"`, `_OWNER_UUID="${_OWNER_UUID:-$CI_JOB_ID@$(hostname)}"`. (c) `bestandslog_lock.hpp:135`: leeren owner ablehnen. (d) Director-Tests: Forward-Zaehlungen anpassen. | 3,0 |
| 3 | **`emit_storage_activation` in `ceb:emit` (B15)** | **JA** | Definition :888, Aufrufe NUR :988 und :1117 -- `emit_ceb_emit_job` (:654-688) ruft sie nicht. Damit ist `ceb:emit` der einzige Job, in dem der 12er-TRIES-Default noch greift, und zugleich der Job, der `--emit-tier-ci` faehrt. Ohne den Aufruf ist dort auch Push/Pull inert. | `experiment_plan_director.hpp`: `emit_storage_activation(s);` nach :673 (`DRIVER=...`) einfuegen; Test, der Vorkommen zaehlt, von 2 auf 3. | 0,5 |
| 4 | **`planer:delegate` scharfschalten (NEU, aus E1)** | **JA** (falls planer_block gebaut wird) | `--dump-ci` laeuft in super `.gitlab-ci.yml:1228-1272` OHNE `.storage_cache_activation` (:570) und ohne `COMDARE_BESTANDSLOG*`. Der planer_block waere sonst garantiert wirkungslos -- dasselbe Muster wie Fix A beim Prune. Der Job liegt im HANDGESCHRIEBENEN super-YAML, dem einzigen wachenlosen Fleck -> mit besonderer Sorgfalt. | `.gitlab-ci.yml` in `planer:delegate.script` vor :1256 `- !reference [.storage_cache_activation, script]`; `COMDARE_BESTANDSLOG*` in `variables:` (:1231-1233) bzw. als Pipeline-Var. Ausgabe-Kanal: alle Bestandslog-Zeilen nach `stderr` (:1265 leitet stdout ins Artefakt). | 1,0 |
| 5 | **Doppel-Gate + Env-Opt-in (B5b)** | **JA** | `make_bestand_transport` (artifact_cache_transport.hpp:37-53) belegt alle vier Lambdas BEDINGUNGSLOS, auch auf einer inerten Instanz. `bestandslog_active` (iterator:927-929) prueft nur die Belegung -> haengt faktisch nur an `!doc_key.empty()`. Das bricht das Hausmuster (profile_run_entry.hpp:311-316 Env-Opt-in; main.cpp:852 `!inert()`). | Host-seitig in G4b-1: `bestand_*` NUR belegen, wenn `COMDARE_BESTANDSLOG=="true"` UND `!artifact_cache->inert()` UND owner_uuid nicht leer. Kein Iterator-Eingriff noetig. | 0,5 |
| 6 | **`provision_only`-Gate auf den Reservierungs-Pfad (B5)** | **JA** | `AsyncPushPump` ist auf `cfg.provision_only` gegated (iterator:947), `run_planer_driven_provision` (:979-982) NICHT. Im MESS-Lauf ergaeben 32 Fenster x 2 Stores x 4 mc-Spawns = 256 Shellouts mitten in der 1-Thread-Messung -- Verstoss gegen LED:3229 (Batch-Typen nie mischen) und gegen die Mess-Exklusivitaet. | iterator:979: `if (bestandslog_active && cfg.provision_only)`. Eine Zeile + ein Test. | 0,5 |
| 7 | **Store-Ergebnis auswerten (B13)** | **JA** | `(void)store_document_merged(...)` (iterator:823) verwirft das Ergebnis; `flush` liefert `nullopt` (builder_registration.hpp:138) und iterator:993-996 druckt nur "(store-fehler)" ohne Exit-Code-Faerbung. Verschaerfend: `flush` swappt `fresh_` VOR dem Store leer (:128-131) -> bei Store-Fehler ist der Batch auch aus dem RAM weg, ohne Re-Queue. Verstoesst gegen LED:3208 ("Fortschritt JE BUILD klarstellen") und gegen "Kein Erfolgs-Haken ohne Ausgabe". | iterator:818-824 Rueckgabe pruefen, `[bestandslog] FEHLER`-Testat; builder_registration.hpp:128-131 `fresh_` erst NACH erfolgreichem Store leeren (bei Fehler zurueckgeben). | 1,5 |
| 8 | **Echte 30-min-Frist (B11)** | **JA** | iterator:834-836 setzt `reserviert_utc` und `pro_forma_bis_utc` auf denselben `now_utc_iso()` -> die Frist ist eine Sekunde spaeter abgelaufen. `pro_forma_deadline_epoch_s` (reservation_lifecycle.hpp:57-60) hat 0 Produktions-Aufrufer. Das Log wuerde 2 Tage lang eine Unwahrheit schreiben (LED:3219 verlangt 30 Minuten) -- und die Zeilen sind der Rohstoff der 01.08.-Kampagne. | iterator:836: `now_utc_iso_at(pro_forma_deadline_epoch_s(now_epoch, kProFormaMinutes))`; kleiner Epoch->ISO-Helfer neben `now_utc_iso`. **Ohne** Leser-Seite (siehe #10). | 1,0 |
| 9 | **`try/catch` um die Emit-Zweige (B12/L1)** | **JA (billig)** | `try` existiert in main.cpp nur bei :379 und :813; die Zweige :415-421, :426-432, :439-452, :457-470 liegen ungeschuetzt in der argv-Schleife. Ohne Unwinding feuert `~PromiseGuard` nie. **Kein Datenverlust** -- LED:3219/3220 haben den Fall eingepreist (30 min pro forma, dann Takeover). Wird nur mitgenommen, weil es 0,5 Ah kostet und im File zweimal Praezedenz hat. Zusatz: die `ArtifactCache`-Instanz im Emit-Zweig MUSS ein benanntes Local sein (artifact_cache_transport.hpp:20-24 Lebensdauer-Auflage; Praezedenz main.cpp:779). | main.cpp: Rumpf der vier Zweige in `try { ... } catch (std::exception const& e) { std::cerr << ...; return 6; }`. | 0,5 |
| 10 | **Claim-Check / Takeover-Verdrahtung (B16)** | **NEIN** (Empfehlung) -- **Owner-Entscheid** | Groesste Plan-Verletzung: `is_reservation_takeable` (reservation_lifecycle.hpp:113), `is_takeable_by_eta` (:105), `window_belongs_to`/`BatchPlanner` (batch_planner.hpp:52/:91) sind gebaut, getestet und haben NULL Aufrufer -> zwei Maschinen bauen dieselben Slices doppelt. ABER: (a) LED:3313 sagt fuer genau diese Phase *"die 2-Maschinen-GN-11-Phase traegt sich ueber Lane-Partition + .version-Sidecar-Resume + GitLab-Retry"*, und macht die Persistenz-Schicht zur Pflicht *"VOR der new-golden-VOLL-MESSUNG ab 01.08."*; (b) es fehlt zusaetzlich der ISO->Epoch-Parser (`pro_forma_bis_utc` ist ISO-String, alle Praedikate nehmen Epoch; im ganzen `bestandslog/` kein `timegm`/`mktime`/`parse_iso`); (c) `run_planer_driven_provision` hat 0 direkte Tests (`grep -c` in `test_g3_planer_driven.cpp` = 0) -- ein FILTERNDER Claim-Check dort ist die riskanteste denkbare Aenderung kurz vor einem 2-Tage-Lauf. **Konflikt, den ich nicht aufloesen kann:** LED:3369 (§66-G3) zieht *"#46b-Bestandslog-Kern P1-P4"* IN das Gate vor den Voll-Bau; was P1-P4 genau sind, steht nirgends im Ledger (LED:3303 verweist nur auf "deckungsgleich mit §62-B P1-P4"). **PLAN SCHWEIGT -- Owner-Entscheid noetig** `[ABNAHME-6]`. | Falls JA: ISO->Epoch-Parser (reservation_lifecycle.hpp) + Claim-Reader im Planer/Iterator + `BatchPlanner`-Verdrahtung + Tests. | 10-12 |
| 11 | **N7-Lock (Abschnitt 1, Variante A)** | **JA, wenn Option B gilt** | Mit Bestandslog AN schreiben prod1 und prod2 in DASSELBE Dokument (LED:3211 Symmetrie: gleiche XML fuer beide). Ohne Lock ist `store_document_merged` ein unatomares RMW -> Lost Update. Folgeschaden: die Registrierungen einer Maschine verschwinden -> Neu-Inventarisierung -> Doppelbau. Kein Binary-Verlust (die liegen in minio), aber der Gate-Zweck faellt. Kostet 1 Tag und ist die einzige Massnahme, die LED:3225 ueberhaupt erfuellt. | siehe 1.2/1.3 | 6,5 |
| 12 | **Merge ueber `LagerIndex` (B3)** | **JA (schwach), mit Lock zwingend** | `merge_documents` (bestandslog_lock.hpp:229-237/:242-249) ist O(\|a\|*\|b\|) mit `std::find_if` + 128-hex-Stringvergleich: bei 2^17 sind das 8,6e9 Vergleiche -> Zehner-Sekunden INNERHALB der Lock-Sektion, was die Invariante aus 1.1 allein schon sprengt. Zudem woertliche User-Direktive LED:3234: *"Lookup ueber std::map mit SHA512-Keys -> Binary-/Messwertpfad effizient auffindbar"*. Der Index existiert (`LagerIndex`, bestandslog_index.hpp:120) und wird im Merge nicht benutzt. | bestandslog_lock.hpp:229-249: `std::map<LagerKey,...>` aus `a.bestand` bauen, `b` dagegen mergen, danach ausgeben (die Sortierung faellt ab). O((n+m) log n). | 2,0 |
| 13 | **`.fingerprint` + `.variant` in den Push-Satz (B25 / L-d)** | **JA** | `push_tier_binary` (artifact_cache.hpp:228-263) pusht exakt `perm.dll`, `perm.dll.algos`, `perm.dll.version`. Eine hydrierte Binary hat also nie ein `.fingerprint` daneben -> `bestand_key_of` liefert nullopt -> `DedupOutcome::no_key` -> sie ist fuer das Lager UNSICHTBAR. Das Lager kann exakt das nicht inventarisieren, was es hydriert hat; der User-Zweck aus LED:3216 ("welche Binaries es im cache schon gibt") bleibt maschinenuebergreifend unerfuellt. Der Bau bleibt korrekt (dll_is_current traegt sich ueber `.version`), aber der 2-Tage-Log waere loechrig -- und den Lauf wiederholt man nicht. **Sorgfalt:** die `.version`-Marke muss LETZTES Objekt bleiben (:257-263) -> `.fingerprint`/`.variant` VOR ihr einreihen; die Pull-Seite (`pull_tier_binary`, ab :266) spiegelbildlich. | artifact_cache.hpp:249-256 Muster kopieren (2 optionale Objekte), Pull-Seite spiegeln, Byte-/Reihenfolge-Tests. | 3,0 |
| 14 | **Mess-Realm-Schreiber (`Genus::measurement`)** | **NEIN** | Voll-Bau-4 ist ein BAU-Lauf (`provision_only`); ein Mess-Bestand entsteht dort nicht. LED:3232 fordert den zweiten Bestand, LED:3313 datiert die volle Persistenz auf "PFLICHT VOR der new-golden-VOLL-MESSUNG ab 01.08." -- das ist die richtige Heimat. Vorher gebaut waere es totes Gewicht im Voll-Bau-Pfad. | -- (Paket vor 01.08.) | 6-8 |
| 15 | Kleinkram: L-f ASCII-Verstoss (reservation_lifecycle.hpp:36/:52/:81/:94/:121 Box-Zeichen), B26 (`write_fingerprint_sidecar` ohne Newline, build_orchestrator.hpp:302-306, vs. `key_from_hex` 128-Zeichen-Pflicht bestandslog_index.hpp:73-74 -> trimmender Read), B17b (Director-Tests :807/:1175/:1722 rufen `unset_g4a_forwarded_opt_ins()` :661 nicht -> ein Byte-Determinismus-Test, dessen Ergebnis von der Umgebungs-Env abhaengt) | **L-f + B17b JA** (stehende Direktiven, 0,5 Ah zusammen); B26 JA (0,3 Ah) | ASCII ist Direktive; B17b macht eine Byte-Wache ehrlich, was vor einem Voll-Bau zaehlt | wie genannt | 0,8 |

**Summe "JA vor Trigger" ohne #10: 22,3 Ah** (ohne #11 Lock: 15,8 Ah). Auf 4 Lanes ca. 6-7 h
Wall-Clock plus Integration, ctest und lokale Beweise.

**Nicht in der Liste, bewusst:** B6/B6a (id-Semantik) -- das ist `[ABNAHME-3]`, kein Fix.
B10 (kein Direkt-Test von `run_planer_driven_provision`) -- wird durch #6/#7/#8 ohnehin
angefasst; ein Direkt-Test der Funktion gehoert in dieselben Pakete (je +0,5 Ah, eingerechnet).

---

## (4) BAU-REIHENFOLGE HEUTE

### 4.0 Gate vor allem

Nichts startet vor **Smoke-Gruen der Pipeline auf ce 5795fae2** (Handover-5 §2: "Start weiterhin
GATED auf Smoke-Gruen ... Task-Zuweisung != Start-Signal"). Pipeline-ID via API auf Projekt 288
ermitteln; Kriterium unveraendert: GESAMTE Pipeline hart gruen. Parallel dazu: verwaiste Watcher
(bllzyf3vl, bu8j44fbm, bpuwq6fyp) bewerten und beenden (Zyklusende-Doktrin).

### 4.1 Lanes (Datei-disjunkt geschnitten)

| Lane | Agent | Paket | EXKLUSIVE Dateien |
|---|---|---|---|
| **A** | Impl-S6-P2 (steht im Freeze, gebrieft) | **G4b-1**: Host-Verdrahtung (`make_bestand_transport` aus einer knapp budgetierten `ArtifactCache`-Instanz, `key_of` via `.fingerprint`, doc_key/owner/maschine aus Env) + planer_block **auf `--dump-ci`/`--dump-cmake`** (E1-Revision!) + Doppel-Gate (#5) + try/catch (#9) + Director-Punkte #2a/#3 | `Code/02_messung_driver/main.cpp`, `profile_run_entry.hpp`, `profile_run_facade.hpp`, `profile_facade/planner/experiment_plan_director.hpp`, `tests/unit/thesis_tiere/test_experiment_plan_director.cpp` |
| **B** | Impl-G3-P3 | **Doc/Lock-Kern**: Wipe-Guard (#1) + owner-Pflicht (#2c) + Merge-Index (#12) + Lock-Helfer `with_document_lock` inkl. ttl/Frist-Wache (#11 Teil 1) | `bestandslog/bestandslog_lock.hpp`, `bestandslog/bestandslog_document.hpp`, `bestandslog/reservation_lifecycle.hpp` (auch L-f), `tests/unit/test_g3_*.cpp` |
| **C** | neu spawnen | **Transport**: `with_object_budget` (#11 Teil 2) + `.fingerprint`/`.variant` Push UND Pull (#13) + B26-Trim | `builder/artifact_transport/artifact_cache.hpp`, `builder/build_orchestrator/build_orchestrator.hpp` (nur die Sidecar-Newline), zugehoerige Tests |
| **D** | neu spawnen | **super-YAML**: `planer:delegate` scharfschalten (#4). **Anderes Repo** -> vollstaendig disjunkt | `probst-diplomarbeit-cache-engine/.gitlab-ci.yml` |
| **E** | nach B frei | **Iterator-Gates**: provision_only-Gate (#6), Store-rc (#7), 30-min-Frist (#8), Lock an die drei Schreibstellen (#11 Teil 3) | `experiment_tree/cache_engine_builder_iterator.hpp`, `bestandslog/builder_registration.hpp`, `tests/unit/test_g3_planer_driven.cpp` |

### 4.2 Was SERIELL laufen muss (Datei-Ueberlapp)

1. **`tests/unit/CMakeLists.txt` -- Manager-only.** Jede Lane, die ein Test-Target braucht, meldet
   den Block; Fable traegt ihn ein. Vier Agenten im SELBEN Working-Tree an derselben Datei ist ein
   garantierter Konflikt. (Beispiel-Block: :3993-4000.) Alternative, falls bevorzugt: je Lane ein
   `git worktree` -- dann faellt die Serialisierung weg, kostet aber Integrations-Merges.
2. **`artifact_cache.hpp` -> nur Lane C.** Lane B BRAUCHT `with_object_budget`, darf die Datei aber
   nicht anfassen. Auflage: die Signatur wird VOR dem Start festgeschrieben
   (`[[nodiscard]] ArtifactCache with_object_budget(std::size_t tries, std::size_t timeout_s) const`);
   C liefert sie als ERSTEN Teilschritt, B/A bauen dagegen.
3. **`experiment_plan_director.hpp` -> nur Lane A.** Die #2a-Forward-Entfernung und der
   #3-`emit_storage_activation`-Aufruf wandern deshalb IN Lane A, obwohl sie thematisch zu D
   gehoeren.
4. **Lane E startet erst, wenn B den Lock-Helfer gemeldet hat** (Signatur-Abhaengigkeit an drei
   Aufrufstellen). Bis dahin kann E die drei rein lokalen Punkte (#6/#7/#8) vorziehen -- das ist
   dieselbe Datei, also EIN Agent, zwei Teilschritte.
5. **Working-Tree-Freeze nach jeder Paketmeldung** (stehende Direktive): Agent friert ein, Fable
   prueft `git diff --stat` literal, committet, gibt frei. Ohne das kollidieren A und B ueber den
   Index, auch bei disjunkten Dateien.

### 4.3 Ablauf heute

```
T0  Smoke-Gruen 5795fae2 feststellen (API, Projekt 288)        [BLOCKIEREND]
T0  Watcher aufraeumen
T1  Start A, B, C, D parallel   (4 Lanes, disjunkte Dateien)
T2  C meldet Teilschritt 1 (with_object_budget)  -> A/B unblocked fuer Budget-Nutzung
T3  B meldet Lock-Helfer                          -> E starten
T4  A, B, C, D, E melden Pakete; Fable committet je Paket, CMakeLists-Bloecke zentral
T5  LOKAL, seriell, EIN Lauf:
      ctest gesamt hart gruen (Referenz zuletzt 315/315) + Byte-Wachen (296/297) unveraendert
      Beweis 1: Resume-Skip (GN_DECISION)
      Beweis 2: Hydration-Smoke mit verified>0 UND pruned>0
      Beweis 3: Variant-Gate-E2E
      Beweis 4 (NEU, wegen Option B): Bestandslog-E2E gegen minio -- 2 Prozesse, gleicher doc_key,
               gemessene Lock-Sektions-Dauer, Beleg "Sektion < ttl", Log nach dem Lauf lesbar
T6  Push (dual), CI hart gruen abwarten
T7  Voll-Bau-4-Trigger: POST /projects/288/pipeline ref=development, COMDARE_BUILD_GOLDEN_N=true
      + COMDARE_STORAGE_CACHE=true + COMDARE_BESTANDSLOG=true + _DOC_KEY
      (OWNER_UUID/MASCHINE NICHT setzen -- die leitet der Runner ab, siehe #2)
      24/24 Worker; df-Wachen + Cron-Wache neu armieren
```

**Giga-Scrub-Fenster** (Board #9, Dossier §5.2 "nicht mittendrin") bleibt wie geplant: nach T6,
VOR T7 -- danach laeuft der Voll-Bau auf der finalen Linie. Wenn heute beides nicht passt, hat
T7 Vorrang (Frist), und das Scrub-Fenster wird auf die naechste Ruhephase gelegt.

---

## ABNAHME-PUNKTE (Owner-Entscheid noetig, Bau blockiert bis dahin nur an den genannten Stellen)

- **[ABNAHME-1] Lock-Parameter.** Ledger nennt keine Lock-TTL. Vorschlag: `ttl_s = 90`,
  Lock-Pfad-Budget `tries=1, cap=10s` (Worst-Sektion 40 s), 5 Jitter-Zyklen (0,5-3 s), danach
  Aufgabe des Schreibversuchs mit `[bestandslog] FEHLER`-Zeile. Und: was passiert, wenn
  `--dump-ci` den Lock nicht bekommt? Empfehlung (i) ohne Block emittieren + Warnzeile auf stderr.
- **[ABNAHME-2] N8-Bauform.** Heute Variante A (Voll-Dokument-RMW unter kurzem Lock, plan-vertraeglich)
  oder Variante B (per-Owner-Sidecar-Registrierung, plan-identisch, +1,5-2 Tage, nicht heute)?
  Empfehlung: A heute, B als Paket vor 01.08.
- **[ABNAHME-3] planer_block-`id` und Retention.** Wie wird die id gebildet (Manager-Auflage L2
  `owner_uuid + "/plan/" + doc_key` ist nicht plan-gedeckt -- Kollisionsgefahr mit
  `pick_reservierung`)? Darf eine `done`-id je wieder `offen` werden? Werden `done`-Records
  physisch entfernt oder nur gestempelt?
- **[ABNAHME-4] Versions-Feld.** Was traegt "fuer diese Version" (LED:3221): die
  `[a,b,c]`-CEB-Legende (LED:3312), der CEB-SHA512-Fingerprint (LED:3233/3234) oder beide als
  getrennte Attribute? Empfehlung: beide getrennt (LED:3413 "je Achse ihr eigenes Feld"), dazu
  `kSyntaxVersion` 2 -> 3 im offenen §66-G2-Bruch-Fenster.
- **[ABNAHME-5] CEB-Einlagerung.** Wird die fertige CEB-Binary als `<eintrag>` im Binary-Bestand
  gefuehrt und in den Store gepusht? Plan impliziert es (LED:3207/3233/3234), ordnet es nirgends
  an; es gibt heute keinen CEB-Push.
- **[ABNAHME-6] Gate-Umfang.** Zaehlt Claim-Check/Takeover zum "#46b-Bestandslog-Kern P1-P4"
  (LED:3369, dann VOR Voll-Bau-4) oder zur "vollen Persistenz-Schicht" (LED:3313, dann vor
  01.08., und die 2-Maschinen-Phase traegt sich bis dahin ueber Lane-Partition)? P1-P4 sind im
  Ledger nirgends aufgezaehlt. Meine Empfehlung: vor 01.08., mit eigenem Test-Paket -- ein
  filternder Claim-Check in einer heute untesteten Funktion kurz vor einem 2-Tage-Lauf ist das
  groesste vermeidbare Risiko des Tages.

Zusaetzlich zur Kenntnisnahme (kein Entscheid, aber eine Revision): der Vorsessions-Entscheid
"planer_block haengt an `--emit-tier-ci`/`--emit-tier-cmake`" (Handover-5 §2, Befund 1) ist nach
LED:3221 + LED:3223 + main.cpp:437 **falsch geankert** und wird in dieser Vorlage auf
`--dump-ci`/`--dump-cmake` korrigiert. `--dump-plan` bleibt strikt nebenwirkungsfrei.

Selbstcheck: `grep -P '[^\x00-\x7F]'` ueber diese Meldung: nur `§` (erlaubt). Keine
Gedankenstriche, keine Box-Zeichen, keine Unicode-Pfeile, keine Emojis. Keine Datei geaendert,
kein Report-File geschrieben, keine Secrets.