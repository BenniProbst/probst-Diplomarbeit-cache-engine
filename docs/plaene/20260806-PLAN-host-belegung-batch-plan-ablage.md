# PLAN: Host-Belegung der Batch-Plan-Ablage (`pa.batch_plan_datei`) -- die F4-Ebene scharf machen

Stand 06.08.2026, nachmittags. Verfasst als VORARBEIT des Opus-Zweit-Reviews, **read-only am
Code**; gebaut wird erst nach der T2-A-Landung. ASCII-only ausser in woertlichen Zitaten.

**DER SKANDAL IN EINEM SATZ:** Die gesamte Ebene 1 des Lager-Inventar-Batch-Caches ist gebaut,
gruen, viermal reviewt -- und im Trigger-Lauf **wirkungslos**, weil der Host das eine Feld nicht
belegt, das sie einschaltet. Am Objekt geprueft: `grep -rn "batch_plan_datei"` ueber super
`Code/` = **0 Treffer**. Genau die Auspraegung, gegen die die Owner-Doktrin steht ("entschieden
GEGEN Kostenklammern") -- eine Faehigkeit, die niemand ausloest, und niemand merkt es, weil
alles gruen ist.

---

## 1. DIE SPEZIFIKATION (Quellen woertlich, juengste Fassung ist Kanon)

**(1a) Der Gruendungssatz -- Owner, 05.08. abend-10** (zitiert in Ledger-Nachtrag mittag-16):

> "Der Store muss zurueckrollen koennen und ohne grosse Verluste resumen... ueber einen Zaehler
> realisieren, welches Binary kompiliert und dann auch in einem zweiten separaten Durchlauf
> gemessen wurde, sofern die Binary Reihenfolge und der Faecher fuer das Batch klar und
> persistiert geplant sind. Freigabe."

**(1b) Der Auftrag zur Host-Belegung -- Ledger mittag-16, Abschnitt A, "DELTA nach
Abhaengigkeit":**

> "(1) L1-Landung des Buendels; (2) F7-Entscheid (Owner: Option b entschieden -> mit dem
> Versionierungs-Interface gebuendelt); (3) super-Host-Belegung von pa.batch_plan_datei
> (Spezifikation liegt fertig vor); (4) Indexfolge-Bindung des Zaehlers (laufende T2-A-NB) --
> ohne sie kann ein persistierter Plan ueber Segmente hinweg nicht SICHER wiedererkannt werden.
> NICHTS muss neu KONZIPIERT werden."

**BEFUND ZUR "FERTIGEN SPEZIFIKATION":** Sie ist **kein eigenes Dokument**. Es gibt in
`docs/plaene/` keine Datei dazu (geprueft: 0 Treffer auf `batch_plan_datei` ausser im
Versionierungs-Interface-Plan). Die Spezifikation IST die Summe aus (1a), (1c) und dem Kontrakt
im Code (`profile_run_entry.hpp:148-149`: "ProfileRunArgs::batch_plan_datei (Fassade) -> DIESES
Feld -> LazyRunConfig::batch_plan_datei; KEIN Gate auf dieser Ebene"). Der Satz "Spezifikation
liegt fertig vor" ist inhaltlich richtig -- die Kette ist vollstaendig entworfen --, aber er
verweist auf **kein auffindbares Dokument**. Dieser Plan schliesst die Luecke.

**(1c) Die Pass-Ueberschreibungs-Frage F7 -- Ledger mittag-9, "BEFUND A":**

> "GROESSER als gemeldet: nicht 18 Paesse, sondern DREI multiplizierende Schleifen um make_cfg
> (opt x simd-Perms x Selektions-Paesse x SOTA-Reihen) = am all_axes_golden bis zu **156
> Ueberschreibungen je Lauf**. KLEINER: der working_set_sweep multipliziert NICHT (Task #31
> kollabiert n_sweep im provision_only-Lauf auf 1 -- und genau dieser Modus ist der einzige, in
> dem der Plan-Resume ueberhaupt greift). FOLGE: Der Plan-Resume traegt nur bei EINEM Pass in
> ALLEN DREI Dimensionen zugleich."

mit den drei Optionen (mittag-9): **(1)** Status quo + dokumentierte Grenze -- "F4-Resume im
Voll-Bau wirkungslos sobald >1 Pass faehrt, kein Datenverlust, fail-closed, null Risiko vor
Abgabe"; **(2)** stempel-abgeleiteter Name im Iterator (`batch_plan_datei` wird PRAEFIX statt
Pfad) -- "einzig driftfreie Quelle"; **(3)** Pass-Index-Suffix -- "billig, aber FALSCH fuer die
reale Dimensionalitaet".

**(1d) Der Owner-Entscheid F7 -- Ledger mittag-10, VERBATIM:**

> "Bitte Option b: Wir hatten einen komplexen Stempel mit allen Achsen-Kategorien festgelegt mit
> jeweils versionierten Achsen-Algorithmen und zum Schluss ein SHA Hash als fingerprint. Wir
> erzeugen eine Funktion, die zur compile time auch den Namen der Funktion aus dieser
> Rekombination in die binary schreibt und durch ein eigenes Interface der Stempel-Versionierung
> an jeder Planer/CEB/Tier-Binary anbietet. Dies soll ein gesondertes Versionierungs-Interface
> sein."

und die Staffelung ebenda:

> "Bis das Interface steht, bleibt der Zwischenstand Option 1 (dokumentierte Grenze,
> fail-closed) -- das ist KEIN Widerspruch, sondern die Staffelung."

sowie die Termin-Einordnung ebenda:

> "ERWARTUNG (ehrlich, im Auftrag so formuliert): NICHTS davon ist vor der Abgabe Fr 08.08.
> realistisch -- der Plan ist fuer danach; der Agent soll den kleinsten sinnvollen ERSTEN
> Schritt benennen."

**AUFLOESUNG DER SCHEINBAREN WIDERSPRUECHE (wichtig, weil zwei Nachtraege gegenlaeufig klingen):**
`F7 = Option b` (mittag-10) und `Option 1 bis Abgabe` (mittag-9/-10) widersprechen einander
NICHT. "Option b" ist die ZIELFORM des Namens (stempel-abgeleitet, aus dem gesonderten
Versionierungs-Interface); "Option 1" ist der ZWISCHENSTAND bis dieses Interface existiert. Die
Host-Belegung selbst ist von beiden unabhaengig -- sie schaltet die Ebene ein, egal welcher
Namensweg gilt.

---

## 2. DER EINGRIFFSPUNKT (am Objekt bestimmt)

### 2.1 `batch_plan_datei` -- die Kette ist VOLLSTAENDIG, es fehlt nur das letzte Glied

Belegt durch `grep`:

| Glied | Datei | Stand |
|---|---|---|
| `LazyRunConfig::batch_plan_datei` | `cache_engine_builder_iterator.hpp:243` | **da** |
| `make_cfg` legt es auf die cfg | `profile_run_entry.hpp:659` | **da** |
| `ProfileRunArgs::batch_plan_datei` | `profile_run_entry.hpp:182` | **da** |
| Fassade reicht durch | `profile_run_facade.cpp:731` | **da** |
| `RunProfileArgs::batch_plan_datei` | `profile_run_facade.hpp:128` | **da** |
| **Host belegt es** | super `Code/02_messung_driver/main.cpp` | **FEHLT (0 Treffer)** |

**DIE STELLE:** `main.cpp`, im `pa.*`-Zuweisungsblock unmittelbar bei den fuenf
Bestandslog-Traegern (heute ~Z. 1338-1345: `pa.bestand_cache` / `pa.bestand_key_of` /
`pa.bestand_doc_key` / `pa.bestand_owner_uuid` / `pa.bestand_maschine`). Dort gehoert sie hin,
weil die Plan-Ablage nur unter `planer_driven_active` wirkt -- und das verlangt
`bestandslog_active` UND `provision_only`.

**DER WEG: ENV-VAR, nicht XML.** Begruendung aus dem Bestand, nicht erfunden -- alle
Nachbar-Traeger dieser Naht kommen so herein: `COMDARE_BESTANDSLOG` + `_DOC_KEY` + `_OWNER_UUID`
+ `_MASCHINE` (main.cpp:1119-1149), `COMDARE_GOLDEN_N_RANGE`, `COMDARE_GOLDEN_N_PROVISION_ONLY`,
`COMDARE_GN_OPT`/`_SIMD`, `COMDARE_BUILD_PARALLEL`, `COMDARE_E4_CAP`. Die Plan-Ablage ist eine
**Betriebs-/Ablage-Koordinate der Maschine**, keine Experiment-Eigenschaft -- genau wie doc_key
und Maschinenname. Sie gehoert damit NICHT in die Experiment-XML: das XML beschreibt, WAS
gemessen wird, die Env, WO diese Maschine ihre Buchhaltung ablegt. (Die Doktrin "NUR EIN
offizielles XML-Programm" ist davon unberuehrt -- sie betrifft den Experiment-Antrieb, nicht die
Ablage-Koordinaten, die schon heute samt und sonders per Env kommen.)

**VORSCHLAG:** `COMDARE_BATCH_PLAN_DATEI` (Pfad; leer/ungesetzt => wie heute inert). Muster
`env_trimmed(...)` wie die Nachbarn, plus EINE `[E4]`-Zeile auf `std::cout`, die den Pfad nennt
-- damit im Job-Log steht, ob die Ebene scharf ist. **Kein neues Gate**: der Iterator gated
selbst (`PlanPersistenz::aktiv()`), und seit der NB3-Welle zusaetzlich fail-closed ohne Anker.

### 2.2 `batch_plan_korn` -- hier fehlt die KETTE, nicht nur das letzte Glied

`grep` ueber `libs/` + `apps/`: **kein einziger Produzent ausser Tests.** Es gibt
- **kein** `ProfileRunArgs`-Feld,
- **kein** `RunProfileArgs`-Feld,
- **kein** XML-Element,
- nur `LazyRunConfig::batch_plan_korn` (`cache_engine_builder_iterator.hpp:258`) und
  `plan_slice_korn(cfg)` (`:1125`), die `0 -> kBuildSliceGrain` aufloest.

Der T2-A-NB2-Commit sagt das selbst ehrlich ("die Kette endet an LazyRunConfig ... das Korn wird
erst dann eine Host-Frage, wenn die Plan-Ablage selbst eine ist"). **Genau dieser Moment ist
jetzt.** ABER: das Korn ist ein Wert, den Bau- und Mess-Lauf IDENTISCH fuehren muessen, sonst
divergieren die Stempel (das war Befund 5 der NB2-Welle). Ein per-Env gesetztes Korn, das im
Mess-Lauf vergessen wird, baut genau die Divergenz wieder ein, die gerade geheilt wurde.

**EMPFEHLUNG: `batch_plan_korn` in DIESER Welle NICHT verdrahten.** Der Default (4096,
`kBuildSliceGrain`) ist die einzige produktiv erprobte Koernung; ein zweiter Freiheitsgrad ohne
zwingende Kopplung beider Laeufe ist ein Risiko ohne Nutzen. Wenn er kommt, dann als **Teil
desselben Stempels** (das Korn steht bereits im `|korn=`-Glied) und mit einer Wache, die den
Mess-Lauf gegen ein abweichendes Korn fail-loud stellt. -> eigener Posten, nach der Abgabe.

---

## 3. DIE FOLGEN DES SCHARFSTELLENS (gemessen, nicht vermutet)

Mit der Belegung werden **alle** heute gebauten Wachen zugleich scharf. Der Reihe nach:

### 3.1 Die Fingerprint-Formwache -- macht sie die Ebene DAUERHAFT inert? **NEIN. Gemessen.**

Das war die Kernsorge des Auftrags. Der produktive Provider liefert planmaessig Leerwerte, wenn
eine `binary_id` nicht materialisierbar ist (`lazy_adhoc_source_gen.hpp:367`; die zwei Ursachen
stehen in `lazy_adhoc_macro_args_for:178` "Achse fehlt im binary_id" und `:186` "Wert nicht
enabled"). Waeren solche Atome in der realen Selektion, bliebe die Ablage nach der neuen
Formwache **immer** inert -- formal scharf, faktisch aus.

**EIGENE MESSUNG** (Sonde gegen die echten Fixture-ids, Enable-Menge dieses Baums):

    binary_ids gepruefte Menge : 320
    gueltige 128-hex           : 320
    LEER (nicht materialisierbar): 0
    formwidrig                 : 0
    => Formwache wuerde die Plan-Ablage DURCHLASSEN (Ebene wirksam)

**GEGENPROBE, damit die Null nicht blind ist** -- dieselbe Sonde gegen die drei Alt-ABI-Formen
derselben Fixture (`_abi4` / `_abi5` / `_abi6`): jeweils **320 von 320 LEER**. Die Wache greift
also scharf und die Messung ist aussagekraeftig.

**EHRLICHE GRENZE:** gemessen ist die **golden-320-Fixture**, nicht die produktive
**2^17**-Selektion -- eine `golden_fullpilot_131072_binary_ids.txt` existiert im Repo nicht
(golden-gegated, nur zur Laufzeit erzeugt). Der Mechanismus ist derselbe (Achsen-Namen +
Enable-Menge), das Ergebnis darum stark indikativ, aber nicht bewiesen. **AUFLAGE:** beim ersten
scharfen Lauf die `[bestandslog] plan-ablage INERT`-Zeile im Job-Log gezielt suchen -- steht sie
da, hat die Formwache zugeschlagen und die Selektion enthaelt nicht-materialisierbare Atome.

### 3.2 Die Praefix-Abschneidung an `offen > 0` -- der eigentliche Verhaltens-Sprung

Sobald sie gebaut ist, endet das Praefix am ersten Fach, das der frische Lager-Scan als nicht
gedeckt meldet. **Wichtiger Nebeneffekt, der VOR dem Scharfstellen verstanden sein muss:** ist
die `PresenceFn` nicht gebunden, meldet `filter_window_for_build` JEDES Fenster als voll offen
-- die Abschneidung faellt dann auf 0 und der Plan-Resume ist komplett aus. Die `PresenceFn`
wird nur gebunden, wenn `bestandslog_active` UND `cfg.bestand_fingerprint_fn` gesetzt sind
(`cache_engine_builder_iterator.hpp:1633`). Fuer den scharfen Lauf heisst das: **ohne
Fingerprint-Provider kein Plan-Resume** -- was richtig ist (der Leitsatz verlangt es), aber im
Log erkennbar sein muss, sonst sucht jemand den Cache-Effekt an der falschen Stelle.

### 3.3 F7: die Belegung allein macht die Ebene NICHT wirksam -- das ist der eigentliche Blocker

Nach (1c) ueberschreiben bis zu **156 Paesse** dieselbe Datei; jeder Pass traegt einen anderen
Stempel, also invalidiert jede Ueberschreibung die vorige -- fail-closed, kein Datenverlust,
aber **wirkungslos, sobald mehr als ein Pass faehrt**.

**AM OBJEKT ENTSCHAERFT (Befund dieses Plans):** im produktiven Chunk-Bau ist die Pass-Zahl
kleiner als 156, moeglicherweise 1. Die drei Multiplikatoren sind
`profile_run_entry.hpp:903` (opt-Perms), `:919` (simd-Perms), `:817` (Selektions-Paesse), `:826`
(SOTA-Reihen). Davon werden im Trigger-Lauf zwei bereits ausgeschaltet:
- **opt x simd** kollabiert auf EINE Zelle durch den GN-Zellen-Filter (`COMDARE_GN_OPT` /
  `COMDARE_GN_SIMD`, main.cpp:1315-1320; `gn_cell_opt_allowed`/`gn_cell_simd_allowed`) -- die
  CI-Matrix exportiert je Cluster-Zelle genau eine Kombination.
- **SOTA** entfaellt bei `COMDARE_RUN_SOTA=0` (main.cpp; `pa.run_sota_series=false`).
Bleiben die **Selektions-Paesse** (`:817`).

#### 3.3.1 DIE ZAHL IST GEMESSEN: **18**, nicht 1 -- und Option 1 traegt damit NICHT

**NACHGETRAGEN 06.08. nachmittags. Kein Trockenlauf noetig: die Zahl ist STATISCH bestimmbar,
also ohne Bau und ohne jede Beruehrung des Mess-GO-Stopps.** Die Pass-Liste ist eine reine
Funktion ueber das Profil:

    profile_runner.hpp:283-291 -- profile_sweep_passes(tp, requested_axis)
      requested_axis nicht leer -> genau {requested_axis}
      requested_axis leer       -> {""} (Basis-Pass, immer zuerst) + JE <axis_sweep> ein Pass

Der E4-Treiber setzt `sweep_axis` **nie** (im Header ausdruecklich vermerkt: "der E4-Treiber
setzt sweep_axis nie"), also gilt immer der zweite Zweig. Die Zahl ist damit
`1 + Zahl der <axis_sweep>-Elemente im Profil`. Ausgezaehlt an den realen Profilen
(`grep -c "<axis_sweep "`):

| Profil | `<axis_sweep>` | Selektions-Paesse | `<sota_series>` |
|---|---|---|---|
| `all_axes_golden.profile.xml` | 17 | **18** | 21 |
| `m3_golden_coverage.profile.xml` | 17 | **18** | 21 |
| `m3_smoke_coverage.profile.xml` | 17 | **18** | 21 |
| `m3v2_study.profile.xml` | 8 | **9** | 21 |
| `m3v2_sota_pilot.profile.xml` | 8 | **9** | 3 |
| `m3v2_smoke.profile.xml` | 2 | **3** | 3 |

Das deckt sich exakt mit der Ledger-Rechnung aus mittag-9 ("2 opt x 2 simd = 4 Perms mal
(1 Basis + 17 `<axis_sweep>` + 21 `<sota_series>`)") -- die 156 sind damit unabhaengig
bestaetigt, und der verbleibende Faktor ist beziffert.

**DER VERSCHAERFENDE BEFUND (nicht im Auftrag, am Objekt gefunden): der teure Pass ist der
ERSTE, und genau sein Plan wird ueberschrieben.** Zwei Fundstellen zusammen:
- `profile_run_entry.hpp:762` (im `run_selection_pass`): das Chunk-Fenster gilt **nur** fuer den
  Basis-Pass -- `if (a.golden_range_count > 0 && pass_axis.empty())`. Die 2^17-Arbeit, fuer die
  die ganze Ebene gebaut wurde, haengt also am Pass mit leerer Achse.
- `profile_sweep_passes` stellt den Basis-Pass **immer zuerst** ("" wird als erstes eingefuegt).
Folge: im Chunk-Bau schreibt Pass 1 den Plan ueber das 2^17-Fenster -- und die 17 folgenden
Sweep-Paesse ueberschreiben dieselbe Datei mit ihren eigenen Stempeln. Beim Folgelauf findet der
Basis-Pass seinen Plan **garantiert nicht mehr**. Option 1 ist damit nicht bloss "begrenzt
wirksam", sondern **fuer genau den Teil wirkungslos, fuer den die Ebene existiert.**

**LAESST SICH DIE ZAHL LEGITIM AUF 1 BRINGEN? NEIN.** Mechanisch ginge es (`a.sweep_axis`
setzen -> genau ein Pass), fachlich nicht: jeder Sweep-Pass baut in `run_selection_pass` einen
EIGENEN Baum mit eigener `sweep_view` (`profile_run_entry.hpp:721-730`) und damit **andere
binary_ids** als der Basis-Pass. Die Paesse sind keine Wiederholung derselben Arbeit, sondern
verschiedene Mess-Substanz; sie wegzuschalten hiesse, die deklarierten `<axis_sweep>`-Reihen
nicht zu bauen. Genau dieser Zustand war schon einmal ein Befund (GO-5 B.1: "die im Profil
deklarierten `<axis_sweeps>` blieben im offiziellen XML-Weg UNGEFAHREN") und wurde absichtlich
geheilt -- ihn rueckgaengig zu machen, um eine Cache-Ebene wirksam zu bekommen, waere die
Umkehrung von Zweck und Mittel.

**KONSEQUENZ FUER DEN TERMIN-ENTSCHEID (Abschnitt 5.1):** Die Bedingung, unter der ich das
Scharfstellen vor der Abgabe empfohlen hatte ("nur wenn die Pass-Zahl 1 ergibt"), ist **NICHT
erfuellt**. Sie ist 18. **REVIDIERTE EMPFEHLUNG: die Host-Belegung NICHT vor der Abgabe scharf
stellen.** Sie waere korrekt gebaut und trotzdem wirkungslos -- eine neue scharfe Naht im
Trigger-Lauf ohne Gegenwert. Der Nutzen entsteht erst mit der Option-2-Form (`batch_plan_datei`
als PRAEFIX statt Pfad, je Pass eine eigene Datei), und die haengt laut Owner-Entscheid am
gesonderten Versionierungs-Interface -- also nach der Abgabe. **Die Belegung und Option 2
gehoeren damit in DIESELBE Welle**, nicht nacheinander.

### 3.4 Was NICHT passiert (Entwarnungen, am Objekt geprueft)

- **Kein golden-Risiko:** die Plan-Ablage beruehrt kein Fingerprint-Preimage. Der Plan-Stempel
  KONSUMIERT Fingerprints, er geht nicht in sie ein (im NB2-Commit ausdruecklich festgehalten;
  Frozen-Vektor `17148e5a...ce89374` von mir am HEAD nachgemessen und unveraendert).
- **Keine Mess-Beeinflussung:** die Ebene haengt an `provision_only`; der Mess-Lauf liest nur
  und schreibt hoechstens die Mess-Front.
- **Kein Multi-Writer-Problem mehr:** die Ablage ist seit T2-A/F4-NB prozess-eindeutig
  (`tmp_marke` = pid + Nanosekunden + atomarer Zaehler), 8 Schreiber x 8 Runden belegt.

---

## 4. DER BAU-AUFTRAG (ohne Rueckfrage ausfuehrbar)

**VORBEDINGUNGEN (alle drei, sonst nicht starten):** (i) die T2-A-Serie ist gelandet; (ii) der
Fail-closed-Patch inkl. der zwei Codex-Auflagen ist durch die Gegenpruefung; (iii) der
Pass-Zahl-Beleg aus 3.3 liegt vor.

**SCHRITT 1 -- Host-Belegung (super, `Code/02_messung_driver/main.cpp`)**
- STELLE: im `pa.*`-Block bei den fuenf Bestandslog-Traegern (heute ~Z. 1338-1345), unmittelbar
  nach `pa.bestand_maschine`.
- CODE: `pa.batch_plan_datei = env_trimmed("COMDARE_BATCH_PLAN_DATEI");` -- Muster der Nachbarn,
  kein neues Gate.
- ZEILE: eine `[E4]`-Ausgabe auf `std::cout`, die den Pfad nennt, wenn er belegt ist, und
  ausdruecklich sagt, dass die Ebene damit scharf ist (Vorbild: die `[E4] INC-G6`-Zeilen). Bei
  leerem Wert SCHWEIGEN (byte-identisch zum Ist).
- KOMMENTAR: dass die Wirkung zusaetzlich an `bestandslog_active` UND `provision_only` haengt
  (`planer_driven_active`), damit niemand die Var setzt und sich ueber Stille wundert.

**SCHRITT 2 -- Beleg, dass die Ebene wirklich scharf wird**
Ein Test auf super-Seite gibt es fuer `main.cpp` nicht (kein Test-Harness fuer den Treiber). Der
Beleg ist deshalb ein **Trockenlauf mit literalem Log-Auszug**, abgelegt im Gate-Spiegel:
- (a) OHNE die Var: die Zeile fehlt, und im ce-Log erscheint keine `plan-`Zeile -> Ist-Verhalten.
- (b) MIT der Var auf einem Wegwerf-Pfad: `[E4]`-Zeile da, danach im selben Lauf entweder
  `[bestandslog] plan-resume: ...` / der Zaehler-Schrieb ODER die `plan-ablage INERT`-Zeile mit
  Begruendung. **Beides ist ein gueltiger Beleg** -- INERT mit Grund ist das erwartete Ergebnis,
  wenn der Lauf keinen Fingerprint-Anker fuehrt.
- (c) Nach dem Lauf: die Plan-Datei und `<plan>.zaehler` existieren und tragen den
  `batchplan-v3|...`-Stempel (literal ins Gate-Protokoll).

**SCHRITT 3 -- BISS (die Zusage, die sonst niemand prueft)**
Zwei Laeufe hintereinander auf demselben Pfad, kleines Fenster (`COMDARE_GOLDEN_N_RANGE` mit
count klein genug fuer einen Slot): Lauf 1 baut, Lauf 2 muss **0 bauen** und die geerbten Atome
buchen (`plan_skip=` in der `[BILANZ-TESTAT]`-Zeile > 0). Das ist der einzige Beleg, der zeigt,
dass die Ebene nicht nur eingeschaltet, sondern WIRKSAM ist. Ohne diesen Biss ist die Welle
nicht abgenommen.

**NICHT IN DIESER WELLE:** `batch_plan_korn` (s. 2.2) -- eigener Posten nach der Abgabe.

---

## 5. WAS OWNER-ENTSCHEID IST UND NICHT BAU

1. **Soll die Ebene VOR der Abgabe (Fr 08.08.) scharf werden?** Der Kanon ist gespalten:
   mittag-16 fuehrt die Host-Belegung als Delta-Punkt 3, vormittag-41 nennt sie "VOR Trigger
   noetig" -- mittag-10 sagt dagegen ueber das Versionierungs-Interface "NICHTS davon ist vor
   der Abgabe realistisch". **Das ist kein Widerspruch** (2.1 vs. Namensform), aber die
   Terminfrage bleibt offen. **MEINE EMPFEHLUNG, REVIDIERT NACH DER MESSUNG IN 3.3.1: NEIN --
   nicht vor der Abgabe.** Die Bedingung meiner urspruenglichen Ja-Empfehlung war "nur wenn die
   Pass-Zahl 1 ergibt"; sie ist **18**. Die Belegung waere korrekt gebaut und trotzdem
   wirkungslos, weil der Basis-Pass (der die 2^17-Arbeit traegt) als erster laeuft und seinen
   Plan von 17 folgenden Sweep-Paessen ueberschrieben bekommt. Eine neue scharfe Naht im
   Trigger-Lauf ohne Gegenwert ist Risiko ohne Nutzen. **Belegung und Option 2 gehoeren in
   DIESELBE Welle, nach der Abgabe.** (Die urspruengliche Fassung dieser Empfehlung bleibt oben
   stehen, damit nachvollziehbar ist, woran sie sich entschieden hat.)
2. **Wo liegt die Plan-Datei?** Vorschlag: neben dem Bestandslog-Ausgabebaum, PRO
   Cluster-Zelle getrennt (der GN-Zellen-Filter macht jede Zelle zu einem eigenen Bau-Strom;
   eine gemeinsame Datei ueber Zellen hinweg waere die 156-Ueberschreibungs-Falle in klein).
   **Owner-Entscheid**, weil es eine Betriebs-/Ablage-Frage ist und die Cluster-Sichtbarkeit
   betrifft.
3. **F7 Option 1 vs. Option 2 -- Termin.** Option b ist entschieden (mittag-10), der
   Zwischenstand Option 1 ebenfalls. Offen ist nur, ob Option 2 (Praefix statt Pfad) als
   Zwischenschritt VOR dem Versionierungs-Interface kommt. **Meine Einordnung: nein** -- der
   Owner hat die driftfreie Quelle ausdruecklich an das Interface gebunden; ein
   Zwischenschritt-Name waere eine zweite Ableitung und damit genau die Drift, gegen die F4
   gebaut ist.
4. **Env-Var oder XML?** Ich schlage Env vor (2.1, mit Begruendung aus dem Bestand). Wenn der
   Owner die Ablage-Koordinaten grundsaetzlich im XML sehen will, ist das ein
   Architektur-Entscheid mit Folgen weit ueber diese Welle hinaus (dann muessten doc_key,
   Maschinenname und die GN-Koordinaten mitwandern) -- **nicht hier entscheiden.**

---

## 6. BELEGE DIESES PLANS

Alles read-only am Objekt erhoben, Stand ce `a9a352bb` / super `d938c577`:
- `grep -rn "batch_plan_datei"` ueber super `Code/` -> 0 Treffer (die Kernaussage).
- Kette `batch_plan_datei` vollstaendig bis `RunProfileArgs` (Tabelle 2.1, je Datei:Zeile).
- `batch_plan_korn`: kein Produzent ausser Tests (`grep` ueber `libs/`+`apps/`+`tests/`).
- Formwachen-Messung 320/320 gueltig, Gegenprobe abi4/5/6 je 320/320 leer (Sonde
  `review-sonde-*`/`inert.cpp`, Ausgaben im Gate-Spiegel
  `20260806-neuanker-t2a-nb2-gates-a9a352bb/`).
- Die zwei Leerwert-Ursachen literal: `lazy_adhoc_macro_args_for:178` und `:186`.
- GN-Zellen-Filter und `run_sota_series` als Pass-Reduzierer: `main.cpp:1315-1320` bzw.
  `profile_run_entry.hpp:826`.
- **NACHGETRAGEN 06.08. nachmittags, damit nicht mehr unbelegt (3.3.1):** die Selektions-Pass-Zahl
  ist **18** (`1 + 17 <axis_sweep>` am `all_axes_golden.profile.xml`), statisch bestimmt aus
  `profile_sweep_passes` (profile_runner.hpp:283-291) plus `grep -c "<axis_sweep "` ueber die
  sechs realen Thesis-Profile -- **ohne Bau, ohne Lauf, ohne Beruehrung des Mess-GO-Stopps.**
  Dazu der verschaerfende Fund, dass der Basis-Pass (Traeger der 2^17-Arbeit, gegated per
  `golden_range_count > 0 && pass_axis.empty()`) IMMER ZUERST laeuft und seinen Plan garantiert
  ueberschrieben bekommt.
- **UNBELEGT und als solches gekennzeichnet:** die Formwachen-Lage ueber die volle
  2^17-Selektion (3.1) -- die id-Liste existiert im Repo nicht; gemessen ist die 320er-Fixture
  mit Gegenprobe.
