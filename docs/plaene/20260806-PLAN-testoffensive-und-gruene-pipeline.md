# TESTPLAN UND PIPELINE-FAHRPLAN -- Weg zum ersten beweiskraeftigen Voll-Lauf

Stand: 2026-08-06 abends. Abgabe Fr 08.08., Trigger-Ziel Do 07.08.
Rolle: Lead-Synthese, READ-ONLY. Dieses Dokument ist der einzige Schreibvorgang.

---

## 0. PRUEFBEREICH DIESES DOKUMENTS (Dateimenge UND Commit-Bereich)

Jede Aussage unten ist an einem dieser Staende gemessen, nicht aus den
Eingangsberichten uebernommen. Die Eingangsberichte sind an einem
**ueberholten** Stand entstanden (ce `b6d87c08` = Seitenzweig
`b2-neuanker-format3`, super `7a26b754`); seither ist das L1-Buendel gelandet.
Ich habe deshalb **jeden** Posten an der echten Landelinie neu geprueft.

| Gegenstand | Wert (selbst gemessen) |
|---|---|
| super Arbeitskopie | `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine` |
| super HEAD | `b35aea1b` (Branch `development`) |
| super HEAD vs `origin/development` | identisch, **0 unpushed** |
| super `origin/main` | `030d2c62` |
| super `main..development` / `development..main` | **93 / 0** -> Fast-Forward moeglich |
| ce Landelinie | `origin/development` = `b5e0e4e7` |
| ce `origin/main` | `c837d830` |
| ce `main..development` / `development..main` | **48 / 0** -> Fast-Forward moeglich |
| super Submodul-Pin (committed) | `7969b399` -- Vorfahr von ce/main UND ce/development |
| Pin -> ce/development | **51 Commits** dahinter |
| Pin -> ce/main | **3 Commits** dahinter |
| super Submodul-Arbeitskopie | **DRECKIG: 13 geaenderte Dateien, +98/-92** |

Werkzeug-Disziplin: Gates ueber `/usr/bin/grep` absolut; Skript-Exitcodes
einzeln gelesen, nicht ueber eine Pipe geschluckt.

---

## 1. DIE EINE ENTSCHEIDENDE FRAGE: WUERDE DIE PIPELINE NACH DER LANDUNG GRUEN?

### Die ehrliche Antwort zuerst

**Die Frage ist heute falsch gestellt -- und das ist der wichtigste Befund
dieses Dokuments.** Der dominierende Blocker ist nicht, dass die Pipeline rot
waere. Er ist, dass die Pipeline **die fragliche Arbeit gar nicht anfasst**.

`super/.gitlab-ci.yml:242-255` triggert das ce-Projekt fest auf
`branch: main` (drei Vorkommen: Zeilen 255, 273, 291). ce/main steht auf
`c837d830` und ist **48 Commits** hinter `development`. Der gesamte heutige
Zug -- T2-A, B14, die R4-CI-Invariante, die Abdeckungs-Wache -- liegt auf
`development` und wird von keinem Trigger-Lauf beruehrt.

**Ein gruener Lauf von heute frueh war also ein gruener Lauf ueber Code, den
niemand mehr faehrt.** Das ist genau die Fehlerklasse, gegen die dieses
Projekt seit Wochen arbeitet: ein Haken ohne Pruefbereich. Bevor irgendein
Test gebaut wird, muss der Pruefbereich der Pipeline selbst geheilt werden.

### Beweis, dass der Unterschied real ist

Ich habe die Schluessel-Wache aus `scripts/ci_yaml_key_guard.sh` gegen beide
YAML-Staende laufen lassen. Woertliche Ausgabe:

```
PRUEFLING: /tmp/ci_main.yml          (= ce origin/main c837d830)
  Top-Level-Schluessel-Zeilen : 30
  davon verschiedene Namen    : 29
  DOPPELT: 'contract:axis-version-lock'
    /tmp/ci_main.yml:343   <- VERWORFEN (steht da, wirkt aber nicht)
    /tmp/ci_main.yml:502   <- GEWINNT (diese Fassung laeuft)
SCHLUESSEL-WACHE: ROT.
EXIT=1
```

```
PRUEFLING: /tmp/ci_dev.yml           (= ce origin/development b5e0e4e7)
  Top-Level-Schluessel-Zeilen : 30
  davon verschiedene Namen    : 30
SCHLUESSEL-WACHE: GRUEN -- jeder Top-Level-Schluessel genau einmal definiert.
EXIT=0
```

Der Heuristik-Tripwire ist auf `development` geheilt (`597ecffe`, `557d8023`
sind gelandet) und auf `main`, dem real getriggerten Branch, **weiter tot**.
Das ist keine Prognose, das sind zwei Exitcodes.

### Was nach der Landung ROT werden wuerde -- getrennt nach Code und Infrastruktur

| # | Was | Code/Infra | Belegstatus |
|---|---|---|---|
| R1 | **Nichts bekannt Rotes im ce-Code** -- aber auch **nichts Gemessenes**. Es hat seit den Merges von heute Nachmittag **keinen** Voll-Lauf ueber `b5e0e4e7` gegeben. | Code, **UNGEMESSEN** | s.u., Nenner-Problem |
| R2 | `xmllint` auf den baremetal-Runnern **unbelegt**. 5 super-Tests (Label `da_unit`, laufen in `test:unit`) brechen mit `FATAL_ERROR`, wenn es fehlt. | **Infra** | Datei-eigener Kommentar, verbatim unten |
| R3 | `pmc:amd` / `pmc:intel` brauchen `perf_event_open` auf beiden Vendor-Lanes | **Infra**, aber `rules`-gegated auf `COMDARE_PMC_LANES` -> im Normallauf nicht instanziiert | `.pmc`-Template |
| R4 | `build:arm64-smoke` braucht node7-rpi5 | **Infra**, opt-in + `allow_failure: true` -> **kein Blocker** | `.gitlab-ci.yml:521` |
| R5 | `measure:*` / `persist:*` (mehrtaegig) | **Infra + Zeit**, bewusst opt-in ueber `COMDARE_RUN_MEASURE` -> **kein Blocker** im Normalbetrieb | -- |
| R6 | **Dreckige Submodul-Arbeitskopie** (13 Dateien, +98/-92) -- ein Submodul-Bump aus diesem Zustand pinnt entweder ungetesteten Code oder verliert Arbeit | **Prozess** | `git status --porcelain` im Submodul |

**Zu R2, der einzige harte Infra-Posten, praezisiert:** Der `FATAL_ERROR`
sitzt in `comdare_xml_require_tool` (`Code/tests/xml_canonical_utils.cmake:82-90`).
Die fuenf betroffenen Tests werden per `add_test(... COMMAND ${CMAKE_COMMAND} -P ...)`
im **Skript-Modus** registriert (`Code/tests/CMakeLists.txt:209-214`) -- der Abbruch
faellt also zur **Testlaufzeit**, nicht beim Configure des Hauptprojekts.
Konsequenz, die den Blocker entschaerft: fehlendes `xmllint` faerbt **5 Tests**
rot, es reisst **nicht** den Bau ab. Der Kommentar der Datei sagt selbst
(verbatim):

> "xmllint ist bis heute in KEINEM CI-Job dieses Repos aufgerufen worden
> ... Die Praesenz auf den baremetal-Runnern ist damit NICHT belegt,
> sondern eine Annahme -- vor dem Scharfschalten in CI ist sie zu pruefen
> (Infra-Auflage)."

Lokal ist `/usr/bin/xmllint` vorhanden (libxml 20914). Das sagt **nichts**
ueber prod1/prod2. Cluster ist per Doktrin read-only -> Owner/Infra-Posten,
kein Testposten.

### Das Nenner-Problem bei R1 -- offen benannt

Ich habe die Abdeckungs-Wache **real** laufen lassen, nicht zitiert.
Woertliche Ausgabe:

```
BILANZ: 406 von 406 registrierten Tests werden von einem fahrenden Job ausgefuehrt.
PARTITIONS-BELEG:
  ohne Label 'pmc' (test:unit)        : 404
  mit  Label 'pmc' (pmc:amd/intel)    : 2
  Summe                               : 406  ==  Inventur 406
ABDECKUNGS-WACHE: GRUEN -- kein Test ohne fahrenden Job.
EXIT=0
```

**Aber der Bezugsstand ist NICHT die Landelinie.** Der benutzte Bau-Baum
(`/home/comdare/wt-b-r4-ci/build-r4`, konfiguriert 2026-08-06 13:08) gehoert
zu Quellstand `3133f226` -- einem Vorfahren von `development`, aber **vor**
den T2-A- und B14-Merges. Die Zahl **406 gilt fuer `3133f226`**, nicht fuer
`b5e0e4e7`. Die in den Eingangsberichten genannte 409 habe ich **nicht**
nachgemessen und uebernehme sie nicht. Was bewiesen ist: **der Mechanismus
der Wache greift und ist gruen**; was offen ist: **die Zahl an der
Landelinie**. Das ist der erste Messpunkt des Fahrplans.

### Fazit Punkt 1

Nein, die Pipeline waere nach der Landung nicht automatisch gruen -- aber
die Gruende sind, nach Gewicht sortiert:

1. **Prozess/Landung (schwerste, vollstaendig in eigener Hand):** der
   getriggerte Branch traegt die Arbeit nicht. Zwei Fast-Forwards heilen das.
2. **Ungemessenheit (Code):** es gibt keinen Voll-Lauf ueber `b5e0e4e7`.
   Das ist keine bekannte Roetung, sondern eine fehlende Messung -- und
   genau deshalb muss der Lauf frueh kommen, nicht spaet.
3. **Infrastruktur (`xmllint`):** ein einziger, scharf umrissener Posten
   mit 5 betroffenen Tests. Eine Pipeline, die daran rot ist, ist kein
   Testproblem -- sie ist ein Paketproblem auf zwei Runnern.

---

## 2. TESTPLAN

### Vorbemerkung: was ich aus der Codex-Liste STREICHE, und warum

Der Owner will Beweiskraft, nicht Menge. Vier der fuenf Codex-Top-Prioritaeten
sind **bereits gebaut** -- sie noch einmal zu planen waere Beschaeftigung und
haette den Bericht falsch gemacht:

| Codex-Posten | Status am Objekt | Beleg |
|---|---|---|
| #1 Duplicate-Key-Wache | **GEBAUT** | `scripts/ci_yaml_key_guard.sh` (193 Zeilen), von mir beidseitig laufen lassen: ROT auf main-YAML, GRUEN auf dev-YAML |
| #2 CTest-Routing-Wache | **GEBAUT** | `scripts/ci_test_coverage_guard.sh` + `ci_test_coverage_manifest.sh`, Job `test:coverage-guard` (`.gitlab-ci.yml:230`), live gruen |
| #4 "17 Waisen in eine aktive Lane" | **ERLEDIGT** | Manifest `CE_COV_MODE_test_unit="-LE"` / `CE_COV_PATT_test_unit='pmc'` -- der `contract`-Ausschluss ist weg (`dcb2f08f`). Die Waisen-Menge ist damit leer, bewiesen durch die 406/406-Bilanz. |
| Tautologie `test_r2_suffix_wachen.cpp:77-78` | real, aber **kosmetisch** | dieselbe Datei prueft spaeter schaerfer (Codex raeumt das selbst ein). Kein Beweiszuwachs vor der Abgabe -> **(iii)** |

Ebenfalls gestrichen aus dem Vor-Abgabe-Fenster, weil der Aufwand die
verbleibende Zeit sprengt und kein Messergebnis daran haengt: libabigail-
ABI-Baseline, echter XLSX-Roundtrip, 1,57-Mio-Kardinalitaets-Invariante,
Property-/Fuzz-Tests, Lager-Crashmatrix. Alle nach **(iii)**.

---

### (i) TESTS, DIE VOR DEM ERSTEN VOLL-LAUF EXISTIEREN MUESSEN

Kriterium fuer diesen Abschnitt, streng: **ohne diesen Test beweist ein
gruener Lauf nichts.** Nur drei Posten erfuellen es.

---

**T-i-1 -- Bissbeweis fuer die XXE-/Entity-Sperre**

* **Was er beweist:** dass die B14-NB5-Entity-Sperre eine Datei mit `DOCTYPE`
  wirklich ablehnt -- und dass eine harmlose Datei ohne `DOCTYPE` weiter
  durchgeht (Doppelprobe, sonst beweist der Test nur "irgendwas ist rot").
* **Warum er in (i) gehoert -- der schwerste Einzelbefund dieses Dokuments:**
  Die Sperre ist **gelandet, ohne dass ein einziger Test sie festhaelt.**
  Gemessen, mit Nenner: `grep -ln 'DOCTYPE|ENTITY|xxe|XXE'` ueber
  `tests/` auf ce/`development` = **0 Dateien**. Im super gibt es **kein**
  `add_test` mit `doctype|entity|xxe` und **keine** `*bissbeweis*`-Datei fuer
  diese Wache (die einzige im Baum gehoert der Breiten-Wache). Ein gruener
  Lauf sagt heute ueber die Sicherheitswirkung dieser Sperre **nichts** --
  er ist mit und ohne wirksame Sperre identisch gruen.
* **Wo:** `Code/tests/` (super), als `cmake -P`-Test in der Familie der
  bestehenden Fixture-Wachen -- gleiche Bauart wie
  `test_fixture_schema_experiment_golden`.
* **Welcher Biss macht ihn rot:** `comdare_xml_open` auf eine Fixture mit
  `<!DOCTYPE r [<!ENTITY x SYSTEM "file:///...">]>` ansetzen und ein
  Nicht-`FATAL` als Fehlschlag werten; Gegenprobe mit derselben Datei ohne
  `DOCTYPE` muss gruen bleiben.
* **Umfang:** ~1-2 h. Zwei Fixtures + ein `cmake -P`-Skript.
* Faltet Codex' Posten `test_config_durability.cpp:105-122` (das `SUCCEED()`,
  das nur "kein Crash" beweist) mit ein -- als **eine** Probe statt zwei.

---

**T-i-2 -- Mutationsprobe fuer `contract:axis-version-lock`**

* **Was er beweist:** dass der Heuristik-Tripwire **beisst**: Drift am
  Kurven-Lader ohne Versions-Bump -> ROT; Bump + Lock-Regen -> GRUEN;
  erneute Drift -> wieder ROT.
* **Warum in (i):** Der Tripwire war drei Wochen faktisch aus und hat dabei
  **nachweislich real** zwei Semantik-Aenderungen durchgelassen (dokumentiert
  in `docs/sessions/20260806-FAHRPLAN-hauptstrang-landung.md:95-113`). Die
  Doppel-Definition ist geheilt -- aber dass die *ueberlebende* Definition
  tatsaechlich beisst, ist **nicht** gepruefte Substanz. Ein gruener
  `contract:axis-version-lock` ist bis dahin von einem inerten Job nicht zu
  unterscheiden. Genau diese Ununterscheidbarkeit war der Urschaden.
* **Wo:** ce, `tools/axis_version_lock/` + ein Test in `tests/unit/`, Label
  so gesetzt, dass die Abdeckungs-Wache ihn erfasst.
* **Biss:** ein Byte in `measurement_curve_loader.hpp` aendern, ohne
  `AXIS_ALGO_VERSION` zu bumpen -> Lock muss ROT melden.
* **Umfang:** ~1-3 h.

---

**T-i-3 -- Abdeckungs-Wache an der Landelinie nachmessen (kein neuer Test,
eine fehlende Messung)**

* **Was er beweist:** den **Nenner**. Solange die 406/406-Bilanz zu
  `3133f226` gehoert und nicht zu `b5e0e4e7`, ist die Abdeckungs-Aussage fuer
  den aktuellen Stand unbelegt -- und alle T2-A-/B14-Tests koennten
  ungedeckt sein, ohne dass es auffiele.
* **Wo:** kein Code. Ein 2-Pass-Configure auf `b5e0e4e7` + Lauf von
  `scripts/ci_test_coverage_guard.sh`.
* **Biss:** Exit != 0 oder eine Bilanz-Zeile, deren beide Zahlen abweichen.
* **Umfang:** ~30-60 min (dominiert vom Configure), **kein** Schreibvorgang.
* **Dies ist der erste auszufuehrende Posten des ganzen Plans.**

---

### (ii) TESTS GEGEN DIE WIEDERKEHRENDEN FEHLERKLASSEN

Diese haben kein Vor-dem-Lauf-Argument, aber sie decken Klassen, die in
diesem Projekt **mehrfach** zugeschlagen haben.

---

**T-ii-1 -- PMC-Flag-Vertrag der Voll-Mess-Emission**
*Fehlerklasse: die Naht, die niemand faehrt.*

* **Beweis am Objekt (an der Landelinie `b5e0e4e7` neu gezaehlt):**
  `experiment_plan_director.hpp` enthaelt `COMDARE_ENABLE_PMC` **0 mal**
  (`grep -c` = 0). Die vier Emissionszeilen stehen auf **841, 877, 1194,
  1342** und lauten samt `-DCOMDARE_V32_ENABLE=ON`, aber **ohne** PMC-Flag.
  `CMakeLists.txt:67` setzt den Default auf `OFF`. Der Preflight
  (`tests/unit/thesis_tiere/m3v2_pmc_smoke.cpp:71`) wertet mit
  `pmc_seam_ok = delta.available || counters_all_zero` den Ausfall als
  Erfolg. Dazu `allow_failure: true` auf demselben Batch (Zeile **1373**).
  **Drei hintereinandergeschaltete Wachen, keine loest aus.**
* **Was der Test beweist:** dass das erzeugte CI-YAML des Voll-Mess-Pfads das
  PMC-Flag traegt.
* **Biss:** Flag aus der Emission entfernen -> Test rot.
* **Umfang:** ~1 h (der Emissions-Test-Harnisch existiert:
  `test_experiment_plan_director.cpp`).
* **Achtung, Reihenfolge:** Der Test pinnt einen Vertrag, der heute
  **verletzt** ist. Er ist erst sinnvoll, **nachdem** der Owner entschieden
  hat (O-A unten) -- sonst baut man ein rotes Gate in eine Pipeline, die
  gruen werden soll.

---

**T-ii-2 -- Fingerprint-Kreuzprobe Schreib-/Lesepfad**
*Fehlerklasse: zwei Seiten derselben Form, getrennt getestet, nie gegeneinander.*

* **Was er beweist:** dass der Schreiber genau die Form erzeugt, die der
  Leser akzeptiert -- statt dass beide Seiten je gegen ihre eigene Konstante
  gruen sind.
* **Wo:** ce `tests/unit/`, bestehende Harnische wiederverwendbar.
* **Biss:** Form auf der Schreibseite aendern (Laenge, Gross-/Kleinschreibung)
  -> Leser muss ablehnen.
* **Umfang:** ~2-4 h.

---

**T-ii-3 -- `bestandslog_active` an den Fingerprint binden**
*Fehlerklasse: Gate prueft Existenz statt Identitaet.*

* **Beweis am Objekt (`b5e0e4e7`, `cache_engine_builder_iterator.hpp` ~1657):**
  die Bedingung lautet verbatim `cfg.bestand_transport.fetch && ...store &&
  ...bestand_key_of && !cfg.bestand_doc_key.empty()` --
  `cfg.bestand_fingerprint_fn` kommt **nicht** vor.
* **Warum das jetzt Gewicht hat:** K-01 ist **widerlegt** (Ledger 4286 ff.).
  `experiment_plan_director.hpp:952-955` reicht `COMDARE_BESTANDSLOG` per
  `append_forward_var_literal` in das erzeugte CI-YAML durch, belegt durch
  `test_experiment_plan_director.cpp:845-860`. Die Ebene ist damit
  **erreichbar, nicht theoretisch**. Der Posten faellt aus "totes Holz" in
  "laeuft still falsch, sobald jemand opt-in setzt".
* **Umfang:** ~2 h. **Einordnung: nur, wenn der Messlauf mit
  `COMDARE_BESTANDSLOG` faehrt** -- das ist Owner-Frage O-C, nicht am Repo
  entscheidbar. Sonst nach (iii).

---

### (iii) WUNSCHLISTE DANACH (nach der Abgabe)

Ohne Umfangsschaetzung, weil sie das Fenster ohnehin nicht treffen:
Planer->CEB->Tier-Wertidentitaet durch die geladene `.so`;
echte ABI-Baseline alt-gegen-neu (libabigail) statt Same-Build-Selbst-
konsistenz; vollstaendige Stempelgrammatik samt Injektivitaet; exaktes
18-Achsen-Manifest (Name + Reihenfolge + Eindeutigkeit, nicht nur Anzahl);
Lager-Crash-Atomizitaet an jeder Schreibgrenze; XLSX-Roundtrip;
1,57-Mio-Kardinalitaet; Spool-Barriere deterministisch (Latch statt racy
Backend); CLU-Erwartungstabelle mit **eigenem** Nenner statt derselben `64`
wie der Prueflings-Code (`test_clu_per_layout.cpp:108-110`);
Separator-Mismatch in `test_phase6_vorbau.cpp:41-52` (Fixture Komma, Code
Semikolon); Tautologie `test_r2_suffix_wachen.cpp:77-78`.

---

## 3. DIE KOSTENKLAMMER-POSTEN, EINSORTIERT

Alle Posten von mir an der **Landelinie `b5e0e4e7`** nachgeprueft, nicht am
Stand der Anklageschrift. Kein Posten wurde durch den Stellungswechsel
entlastet -- zwei haben sich aber **verschoben**.

| Posten | Status an `b5e0e4e7` | Einordnung |
|---|---|---|
| **K-03 / KK-6 Axis-Lock doppelt** | **auf `development` GEHEILT** (1 Vorkommen, Z. 447), auf `main` weiter doppelt (Z. 343 + 502) | **VOR Abgabe -- aber Landung, nicht Bau.** Der Fix existiert; er muss nur auf den getriggerten Branch. Bissprobe = T-i-2. |
| **K-01 BESTANDSLOG-Wurzel** | **WIDERLEGT** (Ledger 4286 ff., Durchreichung Z. 952-955) | erledigt; hebt aber KK-4/K-06/K-07 von "tot" auf "still falsch bei opt-in" |
| **KK-1 / K-02 PMC-Flag fehlt** | **BESTAETIGT**: 0 Treffer, Emission Z. 841/877/1194/1342 | **VOR Abgabe -- Owner-Entscheid O-A.** Kein Kostenposten: hieran haengt, ob die 131.072-Zellen-Matrix Cache-Zaehler misst oder Nullen. Das ist die Beweisbasis der Arbeit. |
| **K-02b `allow_failure: true`** Z. 1373 | **BESTAETIGT** | **VOR Abgabe -- Owner-Entscheid O-B** (mit O-A zusammen entscheiden) |
| **KK-4 `bestandslog_active` ohne Fingerprint** | **BESTAETIGT** (~Z. 1657) | **VOR Abgabe nur, wenn der Messlauf opt-in faehrt** (O-C); sonst danach. Test = T-ii-3 |
| **K-06 doppeltes Fingerprint-Leeren**, **K-07 `kPlanOhneAnker`** (`planer_driven_build.hpp` ~297, bestaetigt) | Code-Existenz gesichert | **abhaengig von O-C**, gleiche Klammer wie KK-4 |
| **K-04 234-V-b Shaped-Emission** | **BESTAETIGT**: Konsumenten = die 2 Definitionsdateien + `test_234_va_*` / `test_234_vb_*`. **Kein** Aufrufer im Produktivpfad | **NACH Abgabe.** Fertige, nie angeschlossene Arbeit -- kein Messergebnis haengt daran |
| **K-05 `target_isa.numa_node` / `.page`** | **BESTAETIGT, staerker als behauptet**: repo-weit **nur die 2 Schreibstellen** des Parsers (`xml_config_parser.cpp:130,132`), **null** Leser. Gegenprobe: die Hauptachse `target_isa.isa` hat sehr wohl Konsumenten | **NACH Abgabe (Code) -- VOR Abgabe (eine Doku-Zeile).** Eine Profil-XML mit dieser Unterachse taeuscht heute Wirkung vor. Das muss benannt sein, auch wenn der Anschluss wartet |
| Duplicate-Key-Klasse | **gebaut** | **durch die Testoffensive ohnehin abgedeckt** (`ci_yaml_key_guard.sh`, Teil von `test:coverage-guard`) |
| Waisen-Test-Klasse | **gebaut** | **ohnehin abgedeckt** (`ci_test_coverage_guard.sh` + Manifest) |

**Owner-Doktrin-Abgleich, offen gesagt:** Gegen Kostenklammern entschieden
heisst nicht, alles heute zu bauen. Die Grenze ist **gemessen**. K-04 und
K-05 sind ausgelassene *Faehigkeiten* mit klarer Kante und ohne Messwirkung
-- sie duerfen warten, **benannt**. KK-1 (PMC) darf **nicht** warten: er ist
keine ausgelassene Faehigkeit, sondern eine stumme Entwertung der Messung.

---

## 4. DER FAHRPLAN ZUM GRUENEN LAUF

### Schritt 0 -- Blocker aufloesen (sofort, vor allem anderen)

Die super-Submodul-Arbeitskopie ist dreckig: **13 Dateien, +98/-92**, u.a.
`system_version_suffix.hpp`, `toolchain_stamp_naht.hpp`, `batch_planner.hpp`,
`profile_run_facade.cpp` und 5 Tests. Aus diesem Zustand darf **kein** Bump
entstehen -- er wuerde entweder ungetesteten Code pinnen oder Arbeit
verlieren. Entscheiden: landen oder auf `rescue/` parken. **Kein
Fortschritt vor dieser Entscheidung.**

### Schritt 1 -- Nenner holen (T-i-3)

2-Pass-Configure auf `b5e0e4e7`, `ci_test_coverage_guard.sh` laufen lassen.
Liefert die Abdeckungszahl der Landelinie. Billig, kein Schreibvorgang,
hoechster Informationsgewinn pro Minute. **Erster Posten ueberhaupt.**

### Schritt 2 -- ce: `development` -> `main` (Fast-Forward)

48 Commits, `development..main` = 0, also sauberer FF. Doktrin-konform
(main autoritativ, development voraus). **Dieser Schritt allein aendert
mehr an der Aussagekraft der Pipeline als jeder einzelne neue Test** -- er
bringt die Abdeckungs-Wache, die Schluessel-Wache und den geheilten
Axis-Lock auf den Branch, den der Trigger faehrt.

### Schritt 3 -- super: Submodul-Bump als **eigener** Commit

Pin `7969b399` -> neuer ce/main-Kopf. Eigener Commit (Doktrin). Der
`changes:`-Block (`.gitlab-ci.yml:247-250`) listet
`Code/external/comdare-cache-engine` -- der Bump feuert den Trigger also
selbst.

### Schritt 4 -- ERSTER ECHTER LAUF (auf super/`development`)

Erst hier ist ein Lauf sinnvoll: ab jetzt testet er den Code, der gemeint
ist. Bewusst auf `development`, damit ein rotes Ergebnis `main` nicht
verschmutzt.

**Reihenfolge, in der Jobs gruen sein muessen (billig+aussagekraeftig zuerst):**

1. `lint:secrets` -- Pflichtjob jeder Welle, Vorbedingung von allem
2. **ce `test:coverage-guard`** -- enthaelt die Schluessel-Wache und die
   Diff-Hygiene-Wache, braucht keinen Voll-Bau. **Der wertvollste erste
   Job:** faellt er, sind alle nachfolgenden Gruen-Meldungen wertlos
3. `verify:submodules` (super) -- Gitlink-Determinismus nach dem Bump
4. ce `contract:*`-Familie inkl. `contract:axis-version-lock`
5. ce `test:unit`
6. super `test:unit` -- **hier faellt R2 (`xmllint`) auf, falls er faellt**
7. ce `sanitize:asan-ubsan`, `sanitize:tsan` -- langsam, zuletzt
8. super `thesis:pdf`

### Schritt 5 -- Nachziehen, dann super `development` -> `main`

Erst nach gruenem Lauf.

### Was bis Do 07.08. realistisch ist -- Ehrlichkeit vor Optimismus

**Realistisch:**
* Schritte 0-4 vollstaendig. Die Landung ist Mechanik, kein Bau.
* T-i-3 (Nenner) -- heute Abend.
* T-i-1 (XXE-Bissbeweis, ~1-2 h) und T-i-2 (Axis-Lock-Mutation, ~1-3 h).
* T-ii-1 (PMC-Flag-Vertrag, ~1 h) **sofern O-A frueh entschieden ist**.

**Wahrscheinlich, nicht sicher:**
* T-ii-2 (Fingerprint-Kreuzprobe, 2-4 h) -- haengt daran, wie viel Zeit der
  erste Lauf frisst.
* Voll gruener Lauf **beider** Repos inkl. Sanitizer. `sanitize:tsan` ist
  erfahrungsgemaess die lange Stange; ein Cold-Cache-ICE-Retry kostet einen
  weiteren Umlauf.

**NICHT realistisch, klar gesagt:**
* **Neuvalidierung von Messergebnissen** nach einem PMC-Flag-Fix. Das Flag
  zu setzen ist eine Zeile; die 131.072-Zellen-Matrix damit neu zu fahren
  ist ein mehrtaegiger Lauf. Wenn O-A auf "fixen" faellt, faellt die
  Entscheidung ueber die Messung mit -- nicht danach.
* `xmllint` auf prod1/prod2 selbst zu installieren (Cluster read-only).
* T-ii-3, wenn O-C nicht frueh beantwortet ist.
* Alles aus (iii).

**Der eine Satz, falls die Zeit knapper wird als geplant:** Schritte 0-4
schlagen jeden neuen Test. Ein gruener Lauf ueber den **richtigen** Code
ohne die drei neuen Wachen ist mehr wert als drei neue Wachen ueber Code,
den der Trigger nicht anfasst.

---

## 5. WAS EINEN OWNER-ENTSCHEID BRAUCHT (statt Bau)

| ID | Frage | Warum nicht am Repo entscheidbar | Empfehlung |
|---|---|---|---|
| **O-A** | **PMC-Flag im Voll-Mess-Pfad: fixen und neu messen, oder ohne Zaehler messen und die Grenze in der Arbeit benennen?** | Haengt am Messfenster bis Fr 08.08., nicht am Code | **Schwerster offener Posten.** Entscheiden, **bevor** Phase 6 startet -- danach ist es irreversibel |
| **O-B** | `allow_failure: true` (Z. 1373) auf dem Mess-Batch: bleibt (langer Lauf soll die Welle nicht killen) oder wird hart? | Betriebsentscheid | mit O-A zusammen |
| **O-C** | Faehrt der Trigger-Lauf mit gesetztem `COMDARE_BESTANDSLOG`? | Runner-Env / GitLab-Projektvariablen / Aufrufskript **ausserhalb** des Repos -- vom Repo aus nicht entscheidbar (so auch das Ledger) | beantwortet zugleich KK-4/K-06/K-07 und T-ii-3 |
| **O-D** | `xmllint` auf prod1/prod2: nachinstallieren (braucht Cluster-Schreibrecht, Doktrin sagt read-only) **oder** die 5 Fixture-Wachen fuer den Abgabe-Lauf herausnehmen? | Infra-Zugriff | Nachinstallieren ist ein Paket (`libxml2-utils`); Herausnehmen waere ein stiller Skip und widerspraeche der SKIP-DISZIPLIN der Datei |
| **O-E** | `target_isa.numa_node` / `.page`: vor der Abgabe anschliessen, oder als *declared-inert* in der Arbeit ausweisen? | Scope der Diplomarbeit | Ausweisen. Der Code-Anschluss ist nach der Abgabe billig; eine unbenannte Schein-Achse ist es nie |
| **O-F** | 234-V-b Shaped-Emission: anschliessen oder als fertig-aber-unverdrahtet dokumentieren? | Scope | dokumentieren, nach der Abgabe anschliessen |
| **O-G** | Fast-Forward `development` -> `main` in **beiden** Repos jetzt freigegeben? | Gitflow-Doktrin: main autoritativ | **Blockiert Schritt 2 und 3 und damit den gesamten Fahrplan.** Zuerst beantworten |
| **O-H** | Die 13 dreckigen Submodul-Dateien: landen oder auf `rescue/` parken? | unbekannter Ursprung (abgebrochene Welle) | **Blockiert Schritt 0** |

**O-G und O-H sind die zwei Entscheide, ohne die heute Abend nichts weitergeht.**

---

## ANHANG: Belegprotokoll (was ich selbst ausgefuehrt habe)

* `git -C ... rev-parse` / `rev-list --count` / `merge-base --is-ancestor` fuer
  alle Topologie-Zahlen in Abschnitt 0
* `sh scripts/ci_yaml_key_guard.sh` gegen ce/main-YAML (**EXIT=1**) und
  ce/development-YAML (**EXIT=0**)
* `sh scripts/ci_test_coverage_guard.sh /home/comdare/wt-b-r4-ci/build-r4`
  (**EXIT=0**, 406/406, Partition 404+2)
* `ctest --test-dir ... -N` (Total Tests: 406) und `CMakeCache.txt`-Lesung
  zur Bestimmung des Quellstands des Bau-Baums
* `git grep` auf `origin/development` (nicht auf der Arbeitskopie) fuer:
  `COMDARE_ENABLE_PMC`, `allow_failure`, `emit_adhoc_modules_shaped`,
  `build_pilot_source_map_shaped`, `target_isa.numa_node|target_isa.page`,
  `COMDARE_BESTANDSLOG`, `AXIS_ALGO_VERSION`, `DOCTYPE|ENTITY|xxe|XXE`
* Direkte Lesung von `xml_canonical_utils.cmake:76-95`,
  `Code/tests/CMakeLists.txt:206-238`, `cache_engine_builder_iterator.hpp:~1650-1670`,
  `planer_driven_build.hpp:~290-305`, Ledger 4286-4330

**Nicht selbst verifiziert und daher nicht als Beleg verwendet:** die Zahl
409 aus den Eingangsberichten; die Behauptung, `measure:golden-320` trage
das PMC-Flag korrekt; alle Codex-Aussagen zu Dateien, die ich nicht selbst
geoeffnet habe.
