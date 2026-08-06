# FAHRPLAN HAUPTSTRANG-LANDUNG -- 06.08.2026

Rolle: Lead-Fahrplan (READ-ONLY erhoben, keine Edits, kein Commit, kein Push).
Methode: jede Aussage unten ist am Objekt gemessen, nicht aus Kommentaren, Ledger-Zeilen
oder Agenten-Meldungen abgeleitet. Wo eine Quelle nur behauptet, steht das ausdruecklich da.
ASCII-only ausser in woertlichen Zitaten.

---

## 0. KORREKTUREN AM GEMELDETEN IST (zuerst, weil sie den Plan tragen)

Fuenf Punkte der Bestandsaufnahme sind ueberholt oder waren falsch. Sie aendern die Reihenfolge.

**(K1) super-HEAD ist weitergelaufen.** Gemeldet `b2bd4760`, gemessen `9c858a73`.
Drei neue Commits, alle aus der Gate-Log-Spiegelung:

```
9c858a73 docs(backups): die NB3-Gate-Belege aus der .gitignore-Falle geholt -- 12 von 18 waeren stumm verschluckt worden
c1cdc0da docs(backups): B14-NB4-WIP als Provenienz-Beleg gesichert -- und die Fehldeutung "unautorisierter Fremdeingriff" richtiggestellt
0bda94aa docs(backups): die fehlenden Gate-Belege der T2-A-NB/NB2-Wellen -- aus eigenen Laeufen des Zweit-Reviews
```

`git rev-list --left-right --count origin/development...HEAD` -> `0  3`: **super ist 3 Commits
UNGEPUSHT.** Das ist derzeit der einzige Ort, an dem Arbeit nur lokal liegt.

**(K2) Die gemeldete `main`-Divergenz in super existiert nicht mehr.**
`git ls-remote` gegen beide Remotes liefert fuer `refs/heads/main` zweimal
`030d2c62749d20553fc7e545ebc215e84e6ec78b`. origin und github sind identisch. Der Befund
"origin=9d0f1bad, github=030d2c62" ist ein Messartefakt gegen stale Remote-Tracking-Refs.

**(K3) B14-ce steht nicht bei `16a173f2`, sondern vier Commits weiter bei `4b38d072`.**
Das ist die entscheidende Korrektur -- siehe Abschnitt 2.

**(K4) Die Ledger-Auflage "R4 erst im Slot NACH B14-NB3-ce" ist gegenstandslos.**
Begruendung war eine Ein-Schreiber-Kollision auf `tests/unit/CMakeLists.txt`. Gemessen:

```
b-r4-ci-abdeckung beruehrt:  .gitlab-ci.yml
                             libs/cache_engine/heuristik/measurement_curve_loader.hpp
                             scripts/ci_test_coverage_guard.sh
                             scripts/ci_test_coverage_manifest.sh
                             scripts/ci_yaml_key_guard.sh
                             tools/axis_version_lock/axis_version.lock
```

`tests/unit/CMakeLists.txt` ist **nicht** dabei. Die Kollision gibt es nicht. R4 ist frei.

**(K5) DREI Paket-Spitzen sind auf KEINEM Remote gesichert.** Gemessen gegen
`git ls-remote origin 'refs/heads/rescue/*'` in beiden Repos:

| Spitze | Repo | rescue vorhanden? |
|---|---|---|
| `b14-ce-anteil` **4b38d072** | ce | **NEIN** (nur `16a173f2`, `6a40071f`) |
| `b-r4-ci-abdeckung` **557d8023** | ce | **NEIN** (nur `dcb2f08f`) |
| `b14-golden-kf6` **9934a7e5** | super | **NEIN** (nur `1ba29b63`, `953ce412`, `d8073913`) |

Alle uebrigen Spitzen (T2-A `a9a352bb`, A1 `fdfa68ee`, E18-SNAP `5c4cf900`, Graph `31af5a92`)
sind beidseitig gesichert. Die drei ungesicherten sind genau die zuletzt gebauten -- also die,
in denen die meiste unwiederholbare Arbeit steckt.

---

## 0b. DIE ZWEI BEFUNDE, DIE DIE REIHENFOLGE UEBERHAUPT ERST BESTIMMEN

### (B1) Es gibt KEINE Textkonflikte. Ueberhaupt keine.

Vollstaendige Matrix, gefahren mit `git merge-tree --write-tree` (echter 3-Wege-Merge im
Objektspeicher, kein Baum angefasst):

```
ce, jedes Paket gegen development:        4/4 SAUBER
ce, alle 6 Paarungen untereinander:       6/6 SAUBER
super, jedes Paket gegen development:     3/3 SAUBER
super, alle 3 Paarungen untereinander:    3/3 SAUBER
```

Auch die drei geteilten Dateien mergen sauber:
`tests/unit/CMakeLists.txt` (T2-A + B14-ce + A1), `test_e24_c10_g6_identitaets_bilanz.cpp`
(T2-A + B14-ce), `axis_04_node_type_layout_aware_store.hpp` (B14-ce + A1).

**Konsequenz: die Reihenfolge ist NICHT konfliktgetrieben.** Wer sie mit Konfliktrisiko
begruendet, begruendet sie falsch. Sie ist gate- und fingerprint-getrieben.

### (B2) Ein Gate ist auf `development` bereits ROT -- seit 11 Tagen, unbemerkt.

`tools/axis_version_lock/axis_version.lock` ist ein Content-Digest-Tripwire ueber drei
Heuristik-Header. Gemessen (sha256 der Blobs gegen die Lock-Zeilen):

| Datei | Lock sagt | development ist | |
|---|---|---|---|
| `axis_spline.hpp` | `854cc453...` | `854cc453...` | ok |
| `break_even.hpp` | `c0c05956...` | `c0c05956...` | ok |
| `measurement_curve_loader.hpp` | `274b3a39...` | **`9a5753fc...`** | **DRIFT** |

Bisektion ueber die Historie der Datei:

```
0fdeccff 2026-08-02 DRIFT 9a5753fc1e32   feat(A15/FK-1): Verwerf-Liste um 'nicht_gebaut' erweitert
150b0ede 2026-07-26 DRIFT 94e0fbb3f254   feat(csv): RF-2 D1-Admission-Marker ... Reader verwirft 'gesperrt'
26487fb1 2026-07-19 PASST 274b3a398bff   <- letzter Stand, der zum Lock passt
```

Der Lock wurde zuletzt am 19.07. regeneriert (`e016eccc`). Seither sind **zwei semantische
Aenderungen** am Kurven-Lader vorbeigelaufen -- beide aendern, welche CSV-Zeilen zu Messpunkten
werden -- **ohne** `algo_version`-Bump.

Warum das niemand gemerkt hat, ist ebenfalls am Objekt belegbar. In
`development:.gitlab-ci.yml` steht der Job **zweimal**:

```
339: # -- contract:axis-version-lock (GN-8/O-4 ...): der Heuristik-Header-Tripwire als HARTES CI-Gate. --
343: contract:axis-version-lock:          <- unbedingt, ohne rules
...
502: contract:axis-version-lock:          <- rules: if $COMDARE_AXIS_LOCK_CHECK == "true"
```

YAML: der letzte Schluessel gewinnt. Die zweite, per Default INERT gegatete Fassung hat die
erste **kommentarlos geloescht**. Der Tripwire war seit dem 19.07. faktisch abgeschaltet.

**R4 (`b-r4-ci-abdeckung`) ist das einzige Paket, das das heilt** -- und es heilt beides in
einem Zug: es entfernt die Doppel-Definition, bumpt `AXIS_ALGO_VERSION: 1 -> 2` in der
gedrifteten Datei und regeneriert die Lock-Zeile auf `c9dd1a8e...`. Der Bump-Kommentar im
R4-Diff benennt die Ursache korrekt:

> "die Drift kam also nicht durch, weil sie erlaubt war, sondern weil niemand hinsah."

Gegenprobe gefahren: **kein anderes Paket beruehrt eine der drei gelockten Dateien.** R4 kann
also allein heilen und niemand hinter R4 bricht den Lock erneut.

---

## 1. LANDEREIHENFOLGE

### 1.1 Die harten Zwaenge (bewiesen, nicht angenommen)

- **Z1** Reihenfolge ist nicht konflikt-, sondern gategetrieben (B1).
- **Z2** R4 heilt ein bereits rotes Gate. Bis R4 landet, ist **kein** "gruen" auf
  `development` ein belastbares Gruen -- der Lock-Job laeuft nicht.
- **Z3 (der wichtigste)** **T2-A ist der Fingerprint-Neuanker.** Gemessen:
  `git diff --stat` ueber `libs/cache_engine/include/cache_engine/abi/` zeigt fuer T2-A
  **1126 Zeilen** in `anatomy_fingerprint.hpp` + `toolchain_stamp_glied.hpp`, und die
  Kommentar-Pins nennen den Vorgaenger-Hex `0fe275bd...9fe36` ausdruecklich "historisch"
  (Format 2 -> 3, O-2/C-2). Das ist die sanktionierte Ausnahme von der Dauer-Auflage
  Fingerprint-Neutralitaet, nicht ihr Bruch -- aber es heisst: **jede Tier-Binary, die vor
  T2-A gebaut wird, traegt eine andere Identitaet als danach.**
- **Z4** B14-ce bumpt zusaetzlich `kCebContractCodegenMinor 0 -> 1` (am Objekt in beiden
  Baeumen gegengelesen). Auch das aendert die Binary-Identitaet.
- **Z5** A1 aendert 27 Allokator-Strategien + `axis_04...store.hpp` -- Achsen-Flaeche, also
  ebenfalls im Fingerprint.
- **Z6** super traegt den Submodul-Zeiger auf `7969b399`, ce-`development` steht auf
  `3bbcb8ed`. super ist **drei ce-Commits stale**. Jede ce-Landung braucht danach einen
  super-Zeiger-Bump; B14-supers Fixture-Gates lesen ueber `COMDARE_CACHE_ENGINE_DIR` in
  genau dieses Submodul hinein (`test_fixture_schema_experiment_golden_kern`,
  `test_fixture_sync_experiment_golden`).

**Aus Z3/Z4/Z5 folgt der eigentliche Schnitt, und er ist wichtiger als jede Einzelreihenfolge:**

> R4, T2-A, B14-ce und A1 bilden **einen einzigen Bau-Block, der VOLLSTAENDIG vor dem
> Trigger gelandet sein muss.** Nicht weil sie einander blockieren, sondern weil jedes von
> ihnen die Identitaet der gebauten Binaries aendert. Landet auch nur eines davon nach dem
> Voll-Bau-4, ist der gesamte Bau zu wiederholen.

Innerhalb des Blocks ist die Reihenfolge frei (alle Merges sauber). Sie wird deshalb nach
**Fehler-Zurechenbarkeit** sortiert, nicht nach Abhaengigkeit.

### 1.2 Die Reihenfolge

#### L0 -- SICHERUNG (sofort, kein Gate, kein Review, ~5 min)

1. `rescue/b14-nb4-ce-4b38d072` -> ce, beide Remotes
2. `rescue/r4-ci-557d8023` -> ce, beide Remotes
3. `rescue/b14-nb4-super-9934a7e5` -> super, beide Remotes
4. super `development` pushen (3 ungepushte Gate-Log-Commits, K1)

Offene Vorbedingung: **keine.** Das ist reine Verlustvermeidung und sollte vor allem
anderen laufen. Solange (K5) gilt, haengt die Arbeit von drei Wellen an je einem lokalen
Branch-Zeiger in einem Worktree, in dem teils noch Fremd-Agenten arbeiten.

#### L1 -- R4-CI (ce, `557d8023`) -- ZUERST, UND ALLEIN

Warum zuerst: es ist das einzige Paket, das ein **bereits rotes** Gate heilt (B2). Und es
ist das einzige, dessen Wirkung man nur bei ruhiger Landebahn sauber zurechnen kann: R4
weitet `test:unit` von `-LE contract|pmc` auf `-LE pmc`, faehrt also die **gesamte
contract-Familie erstmals in der test:unit-Bau-Konfiguration**. Das ist nie gemessen worden.
Geht es rot, muss die Ursache eindeutig R4 sein und nicht "irgendwas aus vier Landungen".

Gegenprobe zur Abdeckungs-Wache gefahren: die Wache zieht ihre Gesamtmenge aus der
**Live-Inventur** (`ctest -N`), nicht aus einer Liste. Alle fuenf Tests, die T2-A/B14/A1
neu registrieren, tragen Label-Saetze **ohne** `pmc` und fallen damit unter
`test_unit = -LE pmc`. R4 zuerst zu landen erzeugt also fuer die Nachfolger **keine**
zusaetzliche Bringschuld.

Offene Vorbedingung:
- rescue-Ref fuer `557d8023` (L0)
- **ein echter Pipeline-Lauf.** `ci_test_coverage_guard.sh` und `ci_yaml_key_guard.sh` sind
  neu und in CI noch nie gelaufen. Ohne diesen Lauf ist "R4 ist gruen" eine Behauptung.
- Klaerung mit dem parallel laufenden CI-Versions-Bump-Strang: `557d8023` ist bereits eine
  dritte, nicht gemeldete Folge-Aenderung ueber `dcb2f08f`/`597ecffe` -- der Worktree
  `wt-b-r4-ci` hat einen aktiven Fremd-Schreiber.

#### L2 -- T2-A (ce, `a9a352bb` + laufende Fail-closed-Welle)

Warum hier: der Fingerprint-Neuanker (Z3) ist die groesste Identitaets-Aenderung im Block.
Alles, was danach landet, wird gegen den **neuen** Anker geprueft -- das ist die Ordnung,
die man haben will. Kaeme T2-A zuletzt, waeren alle vorher gefahrenen Gruen-Belege der
anderen Pakete gegen einen Anker erbracht, den es dann nicht mehr gibt.

Offene Vorbedingung:
- **die laufende Fail-closed-Welle muss abgeschlossen sein.** `a9a352bb` ist ein bewegliches
  Ziel; der Parallelstrang schliesst gerade zwei Review-Befunde (Plan-Stempel-Platzhalter
  als Kollisions-Eimer, ignorierte Fehlmengen-Zahl). Vor Abschluss ist jede Landung eine
  Momentaufnahme.
- Codex-Zweit-Verdikt (Dual-Review-Pflicht), Fable-Review liegt als LANDEBEREIT vor.
- L1-Auflagen aus dem Review: Stempel-/RF-Rest, Kommentar-Pin
  "PhasenZaehler.gemessen NIE als Praefix-Front konsumieren", kleine Wache fuer H1/H2.

#### L3 -- B14-ce (ce, `4b38d072`) -- LANDEN, siehe Abschnitt 2

Warum hier: der ABI-Minor-Bump 8.0 -> 8.1 setzt auf dem neuen Fingerprint-Anker auf.
Offene Vorbedingung: siehe Abschnitt 2 (drei Posten, ca. 1 h).

#### L4 -- A1 (ce, `fdfa68ee`)

Warum zuletzt im ce-Block: kleinste Achsen-Flaeche, **groesste Owner-Abhaengigkeit**. A1
haengt an drei Auflagen, die der Bau-Agent selbst formuliert hat und von denen keine am
Objekt pruefbar ist -- eine davon ist eine echte Owner-Frage (Scope).

Offene Vorbedingung:
- **cf22-Lauf auf prod1** (kein clang-format-Binary auf der Bau-Maschine; die Formatierung
  ist derzeit Handarbeit, also Schaetzung)
- **Owner/Review-Zustimmung zur Scope-Ausweitung** (24x `reallocate`-Fix, urspruenglich
  nicht im Auftrag)
- Lens-Bestaetigungs-Pass

Objektlage ist sauber: 0 neu eingefuegte Nicht-ASCII-Zeilen (die 31 Rohdiff-Treffer stammen
ausschliesslich aus dem **Loeschen** zweier Alt-UML-Dateien), 0 TABU, 0 Dateien unter `abi/`.

#### L5 -- SUBMODUL-ZEIGER-BUMP (super) -- EIN Commit fuer den ganzen ce-Block

Nicht vier Bumps, einer. Danach ist super wieder wahrheitsfaehig und B14-supers
Fixture-Gates laufen gegen den gelandeten ce-Stand statt gegen `7969b399`.

#### L6 -- B14-super (super, `9934a7e5`)

Warum nach L5: seine Gates lesen in das Submodul hinein (Z6). Vor dem Bump validieren sie
gegen einen drei Commits alten ce-Stand -- das waere ein Gruen ohne Aussage.

Offene Vorbedingung: rescue-Ref (L0); Voll-Korpus-PDF-Gate; **und der Owner-Entscheid zur
Bau-Matrix** (Abschnitt 5, O-A) -- das ist die eigentliche Frage an diesem Paket, nicht die
Formalien.

#### L7 -- Graph 2D/3D (super, `31af5a92`) + Gate 8 (thesis, `8970465d`)

Kann vor oder nach dem Trigger. Beruehrt ausschliesslich `04_csv_to_latex`,
`05_diagram_generator`, `08_appendix_generator` -- also die **Auswerte**-Seite, die
Messergebnisse konsumiert, nicht die Bau-Seite. Keine Achse, kein ABI, kein Fingerprint.

Offene Vorbedingung -- eine, und sie ist trivial:
**2 neu eingefuegte Nicht-ASCII-Zeichen** (`§`), am Objekt gegengelesen:

```
diagram_generator.cpp:1718  +// unveraendert daneben stehen (KEIN Ersatz -- Plan §4 "nichts faellt weg").
diagram_generator.cpp:1756  +// die Facade bleibt gruen. Das ist der Risikofreiheits-Beleg fuer das Wiring (Plan §3/P1b).
```

Zaehlung `grep '^+' | grep -cP '[^\x00-\x7F]'` -> **2**. Verstoss gegen die bindende
ASCII-only-Leitplanke. Fix: `§` -> `Abschnitt`/`Sec.`. Zwei Zeilen, ein Commit.
Zusaetzlich: Voll-Korpus-PDF-Gate laut Ledger noch ausstehend.

#### L8 -- E18-SNAP: LANDET NICHT

Es liegt ein woertliches, archiviertes Verdikt gegen genau diesen Commit vor
(`docs/sessions/backups/20260806-e18-snap-welle/CODEX-VERDIKT-NB2-5c4cf900-NICHT-LANDEN.md`):

> "NICHT-LANDEN. Die Anforderungen 2-5 sind nicht vollstaendig erfuellt; besonders die
> falsche Remote-Belegakzeptanz, der nicht erzwungene Nachhol-Bau, fail-open Fetch,
> .tmp-False-Positive und die unvollstaendige Recovery-Identitaet sind landeblockierend."

Dazu: der `.gitlab-ci.yml`-Writeback-Patch liegt als `gitlab-ci-delta.patch` **unangewandt**
im Paket. Ohne ihn persistiert das Feature nichts -- das Paket waere gelandet und wirkungslos.
Das ist genau die Klammer, die die Owner-Doktrin verbietet ("inert, kostet ja nichts").
NB3 im P4-Fenster, mit dem Lead-Patch, nach dem Trigger.

---

## 2. B14 -- LANDEN ODER NICHT?

### **URTEIL: LANDEN.** Aber `4b38d072`, nicht `16a173f2`.

Das stehende NICHT-LANDEN ist gegen `16a173f2` geschrieben. Seither liegen vier Commits
darauf, und sie beantworten die Einwaende der Reihe nach. Der erste davon heisst im eigenen
Titel "Landeblocker":

```
4b38d072 fix(abi): die vier UEBERSEHENEN literalen ceb-Pins nachgezogen (B14-NB4)
bfa75431 test(b14): die Wache pinnt ab jetzt auch die VERBRAUCHER-Seite + CMake-Label b14 (B14-NB4)
a402cfbc fix(abi): CEB-Contract-codegen-Minor 8.0 -> 8.1 (B14-NB4)
c1c76c87 fix(measurement): die CLU-Kette bis zum LETZTEN Verbraucher geschlossen (B14-NB4, Landeblocker)
16a173f2 <- der Stand, gegen den das NICHT-LANDEN geschrieben wurde
```

### Die vier Einwaende, am Objekt gegengelesen

**Einwand 1: "aktiver /64-CLU-Konsument bei system_axis:325/336".**
ERLEDIGT. `git show 4b38d072:...measurement/system_axis.hpp`, Zeilen 345-358:

```cpp
std::uint64_t const field_bytes = snapshot->axis_stats[5][2];
std::uint64_t const cache_lines = snapshot->axis_stats[5][3];
std::uint64_t const line_bytes  = snapshot->axis_stats[5][5];
if (cache_lines == 0 || line_bytes == 0) { ... sample.mark_source_unavailable(); return; }
sample.mark_ok((field_bytes * 100u) / (cache_lines * line_bytes));
```

Das Literal ist weg. An den gemeldeten Zeilennummern steht heute der Kommentar
"HIER STAND DAS LITERAL 64, und es war der Landeblocker von B14".

**Einwand 2: "Observer-Seite nicht fail-closed".**
ERLEDIGT und staerker als gefordert: der Guard oben ist fail-closed, und die Vergiftung im
Observer ist **klebrig** -- mischt ein zweiter Produzent eine andere Einheit in denselben
Snapshot, bleibt `line_bytes == 0` bis zum naechsten `reset()`. Es kann nicht am Ende doch
wieder "64" gemeldet werden und die Vermischung verdecken.

**Einwand 3: "Bump-Frage offen".**
ENTSCHIEDEN und am Objekt verifiziert, in beiden Baeumen gegengelesen:

```
4b38d072 : inline constexpr std::uint32_t kCebContractCodegenMinor = 1;
development: inline constexpr std::uint32_t kCebContractCodegenMinor = 0;
```

Zwei sauber getrennte Versionsraeume: der ABI-Minor **wurde** gebumpt (8.0 -> 8.1, weil
`kV3AxisSchema[5][5]` von einem reservierten `nullptr`-Slot auf den benannten Vertrag
`"line_bytes"` wechselt und ein Loader eine Alt-8.0-DLL sonst stillschweigend akzeptiert
haette -- die Heilung waere gebaut und am Messobjekt wirkungslos, wieder eine Klammer).
Die `algo_version` der Layout-Strategie **wurde nicht** gebumpt, weil kein Nicht-64er-Layout
im Bestand existiert und die Werte byte-identisch bleiben. Der Bump-Nachzug war selbst
fehlerhaft (erster Anlauf traf nur den `static_assert`, drei weitere Laufzeit-Pins fielen
erst im ctest-Doppellauf auf) -- das ist in `4b38d072` geschlossen.

**Einwand 4: "das zweite Churn-Leck gehoert ins selbe Gate".**
**NICHT ABSCHLIESSEND BELEGT.** Der Analysebericht bricht an dieser Stelle ab
("Existiert real, ist ab ..."). Das ist der einzige inhaltlich noch offene Punkt.

### Der Auftrag, der B14 landefaehig macht (ohne Rueckfrage ausfuehrbar)

**B14-1 -- Spitze sichern.** `rescue/b14-nb4-ce-4b38d072` und
`rescue/b14-nb4-super-9934a7e5` auf beide Remotes. Ohne Vorbedingung.
**Aufwand: 5 min.**

**B14-2 -- Verdikt gegen den richtigen Commit neu einholen.** Ein Codex-Pass gegen
`4b38d072` (nicht `16a173f2`), mit exakt den vier Einwaenden als Pruefliste und der Auflage,
jeden am Objekt zu quittieren oder zu widerlegen. Das stehende NICHT-LANDEN gegen einen
ueberholten SHA darf nicht als Freigabe umgedeutet werden -- es muss **ersetzt** werden.
**Aufwand: 30-45 min (ein Pass).**

**B14-3 -- Churn-Leck abschliessen.** Den abgebrochenen Befund zu Ende fuehren: entweder im
selben Gate schliessen oder mit benannter Begruendung und Ledger-Eintrag zuruecksetzen.
Nicht offen lassen -- ein halb analysiertes Leck ist die Klammer "faellt heute nicht auf".
**Aufwand: 20-30 min.**

**B14-4 -- Doppellauf am Merge-Ergebnis, nicht am Branch.** Zwei serielle `ctest`-Laeufe auf
dem gemergten Stand, mit **2-Pass-Configure** (configure -> BAU -> configure; ein zweites
Configure vor dem Bau liefert 404 statt 408/409). Gate-Logs als `.txt` sichern oder
`git add -f` -- `.gitignore` enthaelt `*.log`.
**Aufwand: Laufzeit, nicht Denkzeit.**

**Summe bis landefaehig: ca. 1 h Arbeit + eine Pipeline.**

Nicht Teil dieses Auftrags, weil es kein Bau-Posten ist: die Bau-Matrix des golden
(Abschnitt 5, O-A). Die entscheidet der Owner.

---

## 3. DER KRITISCHE PFAD ZUM TRIGGER (Ziel Do 07.08., Abgabe Fr 08.08.)

### MUSS vor dem Trigger fertig sein

| # | Posten | Warum unverschiebbar |
|---|---|---|
| 1 | **L0 Sicherung** | Verlustrisiko, kostet 5 min |
| 2 | **R4** | ohne ihn laeuft der Lock-Job nicht -- "gruen" ist bis dahin bedeutungslos (B2) |
| 3 | **T2-A** | Fingerprint-Neuanker (Z3) + Zaehler-Resume: ohne es kann ein abgebrochener Voll-Bau nicht wieder aufsetzen |
| 4 | **B14-ce** | ABI-Minor 8.0->8.1 -- Identitaet der Binaries |
| 5 | **A1** | 27 Allokator-Strategien + `axis_04` = Achsen-Flaeche im Fingerprint |
| 6 | **B14-super** | die golden-XML **ist** die Trigger-Input-Basis (Owner-KERN A7) |
| 7 | **Submodul-Bump + EIN hart gruener Voll-Lauf** auf dem fertigen Stand | sonst faehrt der Trigger als Blackbox |

Der Grund, warum 3/4/5 nicht "nach dem Trigger" koennen, ist **nicht** Prioritaet, sondern
Arithmetik: jedes aendert die Binary-Identitaet. Nachtraeglich gelandet, ist der Voll-Bau-4
zu wiederholen. Das ist teurer als jede dieser Landungen.

### KANN nach dem Trigger

- **Graph + Gate 8** -- reine Auswerte-Seite, konsumiert Messdaten. Kostet aber nur zwei
  ASCII-Zeichen; wenn ein Slot frei ist, mitnehmen.
- **E18-SNAP** -- NB3 noetig, P4, ausdruecklich kein Blocker des kritischen Pfads.
- **B12 xlsx-Fuellung, B-Rest, Aufraeumpass (9 Kandidaten)**

### Die ehrliche Aussage: was nicht mehr passt

**Der Trigger-Termin Do 07.08. ist mit dem Bau-Block noch haltbar. Die MESSUNG dahinter ist
es nach heutiger Deklaration nicht.**

Am Objekt in `experiment_golden_kern.xml` (B14-super):

```
Zeile 246: <run_options cap="131072" build_version="golden_kern"/>
Zeile 285: line_size 4  x  system 4  x  N 131072  =  2097152 Tier-Binaries.
```

Die deklarierte Matrix ist **2.097.152** Tier-Binaries; die harte `max_binaries`-Kappung
steht bei **131.072**. Selbst die gekappte Zahl ist eine sechsstellige Menge einzeln zu
kompilierender Binaries. Bei den nach OD-7 vorgesehenen 24 heavy-Workern und einer -- hier
ausdruecklich **unbekannten, nicht gemessenen** -- Kompilierzeit je Binary:

```
131072 / 24 =  5462 Binaries je Worker
  bei  5 s/Binary  ->  ca.  7,6 h
  bei 15 s/Binary  ->  ca. 22,8 h
  bei 30 s/Binary  ->  ca. 45,5 h
```

Bei 5 s geht es sich aus. Bei 30 s ist es zwischen Do und Fr **nicht** machbar. Der
Unterschied zwischen "geht" und "geht nicht" haengt an einer Zahl, die niemand gemessen hat.

**Daraus folgt ein Vor-Trigger-Posten, der bisher in keiner Liste steht:**
eine **Kalibrier-Stichprobe** -- z.B. 200 Binaries im Trigger-Modus bauen, Zeit stoppen,
hochrechnen. Kosten: Minuten. Ohne sie ist der Trigger ein Sprung ins Dunkle, und wenn die
Hochrechnung erst Freitag frueh vorliegt, gibt es keine Reaktionszeit mehr.

Die Owner-Doktrin deckt das Rutschen ausdruecklich ab: *"Substanz gewinnt, wir bauen
geradeaus weiter"* -- der Trigger darf auf Do-Nacht/Fr-frueh. Was sie **nicht** deckt, ist
ein Trigger, dessen Laufzeit man nicht kennt. Deshalb: Stichprobe vor Trigger, dann der
Owner-Entscheid ueber die Kappung (O-A).

---

## 4. RISIKEN

**R1 -- Verlust der drei ungesicherten Spitzen. (hoch / trivial behebbar)**
`4b38d072`, `557d8023`, `9934a7e5` existieren nur lokal. In `wt-b-r4-ci` arbeitet
nachweislich ein Fremd-Schreiber (drei nicht gemeldete Folge-Commits). Ein `git reset --hard`
oder ein aufgeraeumter Worktree loescht die Arbeit von zwei Wellen. -> L0, 5 min.

**R2 -- R4s `test:unit`-Weitung geht rot. (mittel)**
`-LE contract|pmc` -> `-LE pmc` faehrt die contract-Familie erstmals in der
test:unit-Konfiguration. Die Begruendung im Manifest ("alle contract:*-Jobs konfigurieren
mit exakt derselben Flag-Zeile") ist plausibel, aber sie ist **eine Behauptung im Kommentar**
-- also genau die Sorte Aussage, die in diesem Baum schon zweimal falsch war. Zusaetzlich
verlaengert sie test:unit spuerbar. Gegenmassnahme: R4 allein landen (L1), damit ein Rot
zurechenbar ist.

**R3 -- der geheilte Lock schlaegt spaeter erneut zu. (niedrig)**
Nach R4 ist der Tripwire scharf. Wer danach `axis_spline.hpp`, `break_even.hpp` oder
`measurement_curve_loader.hpp` anfasst, muss den Lock regenerieren. Gegengeprueft: **kein**
offenes Paket beruehrt diese drei. Das Risiko liegt in der Zukunft, nicht in dieser Landung
-- gehoert aber ins Ledger, sonst waechst es in drei Wochen wieder nach. Genau so ist es
schon zweimal passiert (13.07. 21 Tests, 06.08. 9 Tests).

**R4 -- Fingerprint-Neuanker halbfertig. (hoch, wenn die Reihenfolge bricht)**
Landet T2-A, aber B14-ce oder A1 rutschen hinter den Trigger, ist der Voll-Bau-4
Makulatur. Die vier ce-Pakete sind ein Block; ihn aufzubrechen ist die teuerste
Einzelentscheidung dieses Fahrplans.

**R5 -- Gruen gegen ein stale Submodul. (mittel, still)**
super validiert derzeit gegen ce `7969b399` statt `3bbcb8ed`. B14-supers Fixture-Gates
lesen ueber `COMDARE_CACHE_ENGINE_DIR` hinein. Ein super-Gruen vor dem Zeiger-Bump sagt
nichts ueber den Stand, der wirklich gebaut wird. -> L5 vor L6.

**R6 -- Gate-Logs werden stumm geschluckt. (niedrig, aber schon einmal eingetreten)**
`.gitignore` enthaelt `*.log`. Der Commit `9c858a73` sagt es woertlich: *"12 von 18 waeren
stumm verschluckt worden"*. B14-supers Belege liegen korrekt als `.txt` -- kuenftige
Spiegelungen brauchen `.txt` oder `git add -f`.

**R7 -- 2-Pass-Configure-Falle. (mittel, bereits einmal fehlgedeutet)**
configure -> **BAU** -> configure. Ein zweites Configure **vor** dem Bau registriert die
codegen-abhaengigen Tests nicht und liefert 404 statt 408/409. R4s eigener Guard-Job macht
es korrekt; die Hand-Laeufe muessen es auch tun, sonst prueft man gegen einen zu kleinen
Wahrheitsbegriff und haelt das Ergebnis fuer gruen.

**R8 -- T2-A ist ein bewegliches Ziel. (mittel)**
Der Fail-closed-Umbau laeuft. Jede Landung vor Abschluss friert einen Zwischenstand ein
und erzwingt eine zweite Landung -- bei einem Fingerprint-Neuanker doppelt teuer.

**R9 -- Runner-Kapazitaet ist unbestaetigt. (mittel)**
Memory fuehrt "Ist 3/2", OD-7 fuehrt SOLL "2/2x12 beide Hosts, heavy prod1 24", und das
Handout selbst notiert, der Register-Ist "3/2+16" sei **stale und unverifiziert** gewesen.
Fuer die Trigger-Hochrechnung (Abschnitt 3) ist das der zweite unbekannte Faktor neben der
Kompilierzeit. Live-Check am Host gehoert vor den Trigger.

---

## 5. WAS OFFEN BLEIBT -- und was davon der Owner entscheidet

### Braucht einen OWNER-ENTSCHEID (nicht baubar)

**O-A -- Die Bau-Matrix des golden. Der wichtigste offene Punkt des ganzen Fahrplans.**
Deklariert sind 2.097.152 Tier-Binaries (line_size 4 x system 4 x N 131072), gekappt auf
131.072. Die Frage ist nicht technisch, sondern inhaltlich: **soll die Abgabe-Messung den
vollen KF-6-Vollausbau fahren, oder eine deklariert reduzierte, repraesentative Teilmenge?**
Owner-KERN A4 sagt *"vollstaendig und sorgfaeltig bauen ... es muessen dennoch alle
unterstuetzt sein, sofern von der Hardware freigegeben"* -- das fordert die **Unterstuetzung**
aller line_sizes, nicht zwingend die **Messung** aller Kreuzprodukte. Diese Unterscheidung
ist bisher nirgends entschieden. Sie entscheidet, ob der Trigger in ein Zeitfenster passt.
Vorlage an den Owner mit der Stichprobenzahl aus Abschnitt 3, nicht ohne.

**O-B -- A1-Scope.** Zustimmung zur Ausweitung um den 24x-`reallocate`-Fix. Blockiert L4.

**O-C -- F6** (taktet der Planer selbst / Sec.47-Supersede-Frage) -- laut Ledger weiterhin offen.

**O-D -- O-4** Anhang-A-Reichweite.

**O-E -- Phase 6 selbst.** Bleibt ein ausdruecklicher GO-Stopp. Ohne Freigabe wird nicht
gemessen, unabhaengig davon, wie gruen die Pipeline ist.

### Bau-Posten, die offen bleiben (kein Owner noetig)

- **B14-3** Churn-Leck abschliessen (Abschnitt 2)
- **A1** cf22 auf prod1 + Lens-Pass
- **Graph** 2 ASCII-Zeichen + Voll-Korpus-PDF-Gate
- **E18-SNAP-NB3** inkl. Anwendung des `gitlab-ci-delta.patch` -- ohne ihn persistiert
  nichts, das Feature waere gelandet und inert
- **`axis_inventory.tex`** wird geschrieben, ist in keine `.tex` eingebunden --
  Aufraeumpass-Kandidat Nr. 9, gehoert auf die Klammer-Liste
- **Kalibrier-Stichprobe** fuer die Trigger-Laufzeit (neu, Abschnitt 3)
- **Ledger-Nachtrag**: die Lock-Regel ("wer die drei Heuristik-Header anfasst, regeneriert
  den Lock") festschreiben, sonst waechst R3 in drei Wochen wieder nach

### Zwei Klammern, die dieser Fahrplan ausdruecklich benennt

Nach der Owner-Doktrin (gegen Kostenklammern, fuer maximale Sauberkeit) sind zwei Stellen
Klammern und keine Nebensaechlichkeiten:

1. **E18-SNAPs unangewandter CI-Patch.** "Landet, kostet nichts, ist eh inert" ist genau die
   verbotene Begruendung. Entweder mit Patch landen oder gar nicht.
2. **Der ABI-Minor-Bump in B14.** Haette man ihn weggelassen ("sizeof unveraendert, faellt
   heute keinem auf"), waere die CLU-Heilung gebaut und am Messobjekt wirkungslos gewesen.
   Er ist gesetzt -- das ist die Doktrin korrekt angewandt und sollte als Praezedenz im
   Ledger stehen.

---

## ANHANG -- Objektstand zum Zeitpunkt dieser Erhebung

```
super  development  9c858a73   3 Commits UNGEPUSHT, Baum dirty (2x M Submodul, 1x M Ledger, 2x ??)
       Submodul-Zeiger auf ce: 7969b399   (ce development steht auf 3bbcb8ed -- 3 Commits stale)
       origin/main == github/main == 030d2c62

ce     development  3bbcb8ed   synchron zu beiden Remotes, Baum sauber
       origin/main  == github/main == c837d830

UNGELANDET:
  ce    b-r4-ci-abdeckung    557d8023   (enthaelt dcb2f08f + 597ecffe)   rescue FEHLT
  ce    b2-neuanker-format3  a9a352bb   (T2-A, Welle laeuft)             rescue ok
  ce    b14-ce-anteil        4b38d072   (enthaelt 16a173f2)              rescue FEHLT
  ce    b-a1-wurf-vertrag    fdfa68ee                                    rescue ok
  super b14-golden-kf6       9934a7e5   (enthaelt 1ba29b63)              rescue FEHLT
  super b-graph-2d3d         31af5a92                                    rescue ok
  super b-e18-snap           5c4cf900   NICHT-LANDEN-Verdikt             rescue ok
  thesis wt-b-gate8          8970465d

Merge-Matrix: 16/16 SAUBER (4+6 ce, 3+3 super), gefahren mit git merge-tree --write-tree.
```
