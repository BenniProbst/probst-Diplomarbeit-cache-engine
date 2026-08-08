# REGRESSIONEN 08.08.2026 — vollständig, nach Klassen

**Auftrag:** *„Dokumentiere alle Regressionen in einer Session."*
**Stand:** ce `2cb0ea34` · super `2a830103` · beide auch auf GitHub gesichert (33 bzw. 54 Commits)

---

## DIE ERKENNTNIS DES TAGES

Neun der heute gefundenen Defekte gehören **einer einzigen Klasse** an, und sie hat einen Namen, den
ein Agent geprägt hat:

> **„Eine Wache mit unvollständigem Nenner meldet Vollständigkeit und deckt nichts."**

Dazu die Schwester aus derselben Stunde:

> **„Der blinde Köder und die blinde Wache sehen identisch aus."**

Vier Fälle davon standen heute *gleichzeitig* im System, keiner wusste vom anderen. Das ist kein
Zufall mehr, sondern ein Strukturmerkmal — und es gehört in den Gesamtplan, nicht in Einzelposten.

---

## KLASSE A — WACHEN, DIE GRÜN MELDEN, OHNE ZU PRÜFEN

### A1 · `run_all_tests.sh` läuft 13× durch `[NOT FOUND]` und endet mit `exit 0`
`super/Code/tools/run_all_tests.sh:191-194` — `TOTAL_NOT_FOUND` geht **nicht** in den Exit-Code ein.
Sie sucht drei Build-Verzeichnisse, die nicht existieren, und drei Testnamen, die es unter den 428
ce-Tests nicht gibt. **Sie kann bestehen, ohne einen einzigen Test auszuführen.**
**Entlastung:** kein CI-Job ruft sie (0 Treffer in beiden `.gitlab-ci.yml`) — sie war nie verdrahtet.
**Status:** Entfernung beauftragt, sobald `make check` scharf ist (jetzt der Fall).

### A2 · `build:clang` läuft im Normalfall GAR NICHT
Opt-in über `COMDARE_CLANG_MATRIX=="1"`, advisory, mit dem Vermerk *„destabilisiert die Hauptpipeline
NICHT"*. In Pipeline 15326 mit **20 Jobs** taucht er nicht auf. **Jeder clang-Defekt bleibt damit
unsichtbar, bis jemand von Hand nachmisst** — und jede Heilung nur so lange stabil.
**Status:** Umstellung auf unbedingt freigegeben; jetzt tragfähig, da beide clang-Blocker geheilt sind.

### A3 · Eine **Handliste** verschluckte zwei Tests, die in KEINEM Job liefen
`COMDARE_TEST_PREBUILD_TARGET` war handgepflegt — dieselbe Fehlerklasse, die R4 bei den
ctest-Auswahlen bereits einmal beseitigt hatte, **nachgewachsen**. Betroffen:
`f15_compare_cli_smoke` und `test_v41_anatomy_adhoc_autobuilt_load`.
**Zahlen:** alter Weg **429** registrierte Tests, `make check` **431**.
**Status:** geheilt mit der CI-Umstellung auf den GNU-Weg (ce `8945b5bd`).

### A4 · Die cppcheck-Auswertung der Vor-Push-Wache war selbst falsch-grün *anzeigend*
Sie filterte nur auf `: error:`, während cppcheck mit `--enable=warning` läuft und `--error-exitcode=2`
**auch bei einer Warnung** anschlägt. Folge bei einem reinen Warning: **Verdikt korrekt ROT, aber
Verstoß-Liste LEER und Nenner 0** — genau das „grün mit Nenner 0", vor dem der Kopf derselben Datei
warnt.
**Status:** geheilt (ce `2f8aba58`), Köder in beide Richtungen, Nenner nennt jetzt beide Zahlen.

### A5 · Eine grüne Pipeline als Beleg, in der der entscheidende Job übersprungen wurde
Pipeline 15314 war grün — mit **3 statt 14 Jobs**, weil ein Doku-Commit die `changes:`-Gates nicht
auslöst. Ich hätte sie beinahe als Beweis für die Zyklus-Heilung ausgegeben.
**Der echte Beleg:** `build:clang` failed auf `a9a0754c`, success auf `51eebbfe` und `56ffab37`.

### A6 · gitleaks über einen Worktree: „no leaks found" bei **0 gescannten Commits**
Der Worktree hat nur eine `.git`-*Datei*; im Container fehlt das Haupt-Repo. **Vakuumgrün.**
**Status:** mit echtem Klon nachgeholt; Methode seither auf den **Push-Bereich** umgestellt
(`git log -p <remote>..HEAD`) statt geratener Tiefe.

### A7 · Ein Byte-Pin schützte Messdaten, die unter `build/` lagen
`tier150_measurements.csv` war die **einzige getrackte Datei** unter `build/` — force-added, obwohl
`.gitignore:2` das Verzeichnis ausschließt. **Jedes `rm -rf build` löschte getrackte Messdaten.**
**Status:** ins Archiv verschoben (ce `eb96b76a`), `git ls-files build/` liefert jetzt 0.

---

## KLASSE B — ECHTE CODE-DEFEKTE

### B1 · CMake-Zyklus im E-E-Overlay-Glied — **latent**, dann persistent rot
`comdare_overlay_source_hash → …_gen → comdare_vendor_mimalloc → zurück`. Wurzel: `CMakeLists.txt:637`
setzt `link_libraries(comdare::vendor_mimalloc)` als **Verzeichnis**-Kante, `add_subdirectory(tools)`
steht in `:708` — der Codegen **erbte** sie, obwohl sein eigenes CMakeLists nur `Boost::mp11` nennt.
**Latent:** derselbe Commit-Typ war mal rot, mal grün — der Unterschied war nur der Bau-Cache.
**Geheilt an der Wurzel** (ce `52e9f3ba`): der Codegen erbt nicht mehr, seine Schließung ist leer.
Die neue Funktion ist eine **Wache** (`FATAL_ERROR`), **keine Ausnahme** — kein Ziel wird von der
Kante ausgenommen. 656 Kanten / 326 Ziele vorher wie nachher, Diff **rein additiv**.

### B2 · `constexpr std::string` aus einem `string_view` bricht mit clang
`mess_gates_glied.hpp:276`. **Die Wurzel ist EINE Operation**, nicht die Klasse: `std::string s{sv}`
scheitert, alles andere (const-char*-Ctor, `+=`, `append(sv)`, Wachsen über SSO, Vergleich) besteht.
Drei libstdc++-Versionen geprüft, alle brechen; libc++ ist nicht installiert.
**Geheilt** (ce `8d5ba807`): Grammatik ohne Heap, Segment-Tabelle, **gerechnete** Kapazität, 6/6 Köder.

### B3 · CWG 1430 — Pack-Expansion in ein Alias-Template mit Nicht-Pack-Parametern
`container_framework.hpp:117`. 52 Meldungen, **alle dieselbe Zeile**, in genau **zwei** TUs.
clang setzt es strikt durch, GCC nicht. **Nicht** durch den heutigen SF-1-Schnitt verursacht — die
Zeile stand vorher schon dort (belegt über `git show b000ccc6~1`).
**Geheilt** (ce `f7535751`) — **der letzte clang-Blocker**; der offizielle Bauweg ist frei.

### B4 · `ce/.gitignore` trug `Makefile` — der Commit wäre **still unvollständig** geworden
`configure.sh` hätte git gesehen, das Makefile nicht. Der offizielle Bauweg wäre nach `git clone`
kaputt gewesen, **ohne dass es jemand merkt**. Behoben mit `!/Makefile`, Bissprobe in beide Richtungen.

### B5 · `make uninstall` ließ genau **eine** Datei stehen — bei Exit-Code 0
CMake schließt `install_manifest.txt` **ohne Zeilenumbruch** ab; `while IFS= read -r` bricht bei der
letzten Zeile ab, **bevor** der Körper läuft. Isoliert nachgestellt (`printf 'a\nb\nc'`: ohne Schutz
„a b", mit Schutz „a b c"). Behoben mit `|| [ -n "$_f" ]` in **beiden** Makefiles.

### B6 · `pmc_cache_misses_l3` behauptet auf AMD einen Wert, den es nicht gibt — **OFFEN**
`linux_perf_pmc_source.hpp:233-236` öffnet L3 weiter über `PERF_TYPE_HW_CACHE`. Die angekündigte
Umstellung auf den AMD-PMU-Typ (`/sys/bus/event_source/devices/amd_l3/type`) ist **nirgends im Code**
— `amd_l3` hat null Treffer. **Blockiert die Messung.**

---

## KLASSE C — DOKU LÜGT GEGENÜBER DEM CODE

### C1 · Die §75-Kandidatenliste log **zwölf Tage**
Achtzehn Stunden nach der Formulierung wurden Kandidaten unter anderem Namen entfernt (ce `813c3232`,
„V-4 Permutations-Alt-Kanal retired") — **ohne Bezug auf §75, ohne die Liste nachzuziehen**.
`grep -c 813c3232` über den Ledger: **0**.

### C2 · Die Kette ist zerrissen: wer nur den Ledger liest, sieht **74 von 92**
Die Posten (1)–(18) stehen ausschließlich in einem Katalog-Dokument, (25)–(29) ausschließlich in einem
Fahrplan. Drei kollidierende Nummernkreise; „Posten 62" bezeichnet an zwei Stellen zwei verschiedene
Dinge. **Betrifft die Arbeitsweise direkt** — der Ledger ist die Hauptquelle.

### C3 · **Fünf** Flächen erklären sich SELBST für tot und sind es nicht
`scheduling_strategy.hpp` behauptet im Kopf *„0 Konsumenten"*, hat am Ist **zwei**, und
`test_striktheit_axis_dach_guard.cpp:81` pinnt sie per `static_assert`. **Wer der Selbstaussage glaubt,
bricht die Wache.** Als **Auflage 0** eingetragen: *eine Selbstdeklaration ist ein Verdacht, kein Beleg.*

### C4 · `.gitmodules` erklärte einen lebenden Zeiger für tot
Die **Messung** stimmte (0 Treffer in `.gitlab-ci.yml`), die **Schlussfolgerung** nicht: der Pfad ist
ein **Zielort**, kein Verbraucher — und ein Zielort wird von der CI-Datei naturgemäß nicht genannt.

### C5 · **Vierzehn** Posten waren längst erledigt und standen weiter als offen
(71)/(72)/(73)/(74) in ce `0b5ed557`, (20) in `3a88eb88`, (30) in `b8fd9fd2`, X-26 in super `7969a02c`,
dazu `cmake/permutations.cmake` und `COMDARE_apply_simd_flags` aus `813c3232`.

### C6 · Die Zeilen-Anker sind großflächig gewandert — **5 von 5** Stichproben verschoben
`director:281→:392`, `PRUNE-TESTAT :1325→:1511`, `iterator:1790-1791→:2809-2819`, zwei weitere
unverwandt. **Kein Anker darf ungeprüft benutzt werden**; immer über den Bezeichner suchen.

### C7 · Die Liste altert nach OBEN
ASCII-Altbestand 1132 → **1160** · Prosa-Sweep 29 → **54** · `organ_location`-Konsumenten 79 → **97**.
Ein Aufräumpass, den man ans Ende stellt, **wächst während des Wartens**.

---

## KLASSE D — MEINE EIGENEN ARBEITSFEHLER

Vollständig im Audit-Dokument `20260808-SESSION-nachmittag-*`. **Elf Verstöße, neun davon dieselbe
Bewegung: etwas ANGENOMMEN statt GELESEN.**

Ein Diff statt der Verwendung einer Funktion · eine Schnellprobe statt einer Matrix · ein Commit statt
seines Inhalts · eine grüne Pipeline statt ihrer Jobliste · **ein Format statt des benannten** (eine
Stunde `result.csv` statt xlsx, siebenmal gesagt) · eine Zahl statt ihres Nenners (432 ohne „mit
ausgeschlossener PMC-Lane") · eine geschriebene Memory statt ihrer Verankerung im Index.

**Heute noch einer dazu, beim Abarbeiten der Freigaben:** ich hatte die Thesis-Stelle
*„achtzehn Achsen … 2^17"* als **Erklärungslücke** geführt. Am Objekt gelesen steht die Erklärung
**im selben Satz**: *„je Organ-Achse zwei freigeschaltete Vertreter, die Persistenz-Achse auf ihren
In-Memory-Vertreter gepinnt"* — 18 Achsen, eine gepinnt, 17 frei mit je zwei Vertretern. **Kein
Eingriff nötig.** Ich hatte den Satz nicht zu Ende gelesen.

---

## KLASSE E — WAS OFFEN BLEIBT

| Posten | Warum |
|---|---|
| **`pmc_cache_misses_l3`** (B6) | blockiert die Messung; Fundort belegt, Umstellung ungebaut |
| **`Code/tools/` entfernen** | Ersatz (`make check`) ist jetzt scharf, Entfernung beauftragt |
| **`build:clang` unbedingt** | freigegeben, tragfähig seit B3 geheilt |
| **§75-Posten (55)** | am Ist **widerlegt** — der Include steht bei `:115`, `_mm_prefetch` wird real gerufen |
| **6 unbelegte §75-Kandidaten** | ihnen fehlt das **Objekt**, nicht die Messung |
| **abgelaufener PAT** | `/home/comdare/keys/gitlab-pat` → HTTP 401; gültiger nur im Vault |

---

## DIE GEGENMASSNAHMEN, DIE HEUTE ENTSTANDEN SIND

1. **Nenner ausschreiben.** Jede Wache nennt, *wie viele* sie geprüft hat. „Grün mit Nenner 0 ist rot."
2. **Köder erst gegen das Werkzeug, dann gegen die Wache.** Heute zweimal gerettet — mein erster
   cppcheck-Köder biss nicht, und die kanonischen AWS-Beispielschlüssel sind allowlistet.
3. **Push-Bereich statt geratener Tiefe.** `git log -p <remote>..HEAD`, und im stdin-Modus ist
   `--config` Pflicht (die Auto-Erkennung greift dort **nicht**).
4. **Selbstdeklaration ist ein Verdacht.** Vor jedem Entfernen frisch messen.
5. **Idle-Meldung ohne Bericht ist kein Abschluss.** Objektzustand prüfen.
6. **Anker über Bezeichner, nie über Zeilennummer.**
