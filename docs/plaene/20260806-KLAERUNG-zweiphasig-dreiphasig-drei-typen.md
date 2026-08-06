# ZWEIPHASIG / DREIPHASIG -- welche drei Typen das System hat

**Erhebungsdatum:** 2026-08-06, spaeter Abend (nach Owner-KERN 22:20).
**Anlass:** Owner-KERN vom 06.08. 22:20 ("es gibt 3 Typen in diesem System").
**Status:** KLAERUNG. Ersetzt keine Doktrin; sie ordnet vorhandene Doktrin und korrigiert
eine Beweisfuehrung (Abschnitt 1).
**SSOT:** `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (6735 Zeilen).

**Pfad-Konvention in diesem Dokument.** `super:` =
`/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/`,
`ce:` = `/home/comdare/wt-landung/` (identisch mit
`super:Code/external/comdare-cache-engine/`, geprueftes Arbeits-Working-Tree).
Alle Zaehlungen mit `/usr/bin/grep` (nicht der Shell-Funktion, die auf ugrep umleitet),
Nullbefunde jeweils mit Nenner und Gegenprobe.

---

## 1. Die Frage und warum sie zweimal gestellt wurde

### 1.1 Was der Owner am 06.08. wirklich gesagt hat -- beide Male, unverkuerzt

Alle Plandokumente zitieren den ersten KERN mit Auslassungspunkten. Der **Volltext** steht im
Live-Transkript, `/home/comdare/.claude/projects/-home-comdare/5a19728e-f6e1-4736-a246-e3fda9ac35a1.jsonl:5704`
(`type: user`, `timestamp 2026-08-06T19:37:43.803Z`), Frage 2 woertlich:

> "Frage 2: Bitte fixen und neu messen ist Pflicht. **Wenn eine Messachse sich aendert, dann wirkt
> sich das bei Veraenderung des Messsystems in der CEB bezueglich DREIPHASIG und ZWEIPHASIG (im Plan)
> auf die nachfolgenden Stufen aus** (bitte explore). Dadurch muss bei einem neuen Messsystem auch die
> CEB und ALLE Binaries fuer die Mess-Achsen-Einstellung neu gebaut werden. Bitte beachte dabei den
> Vertrag CEB vs Tier-Binary bzw CEB vs Tier-Hybrid-Binary. Das ist eine Gedaechtnisluecke."

Der zweite KERN, `…5a19728e….jsonl:7256` (`queue-operation/enqueue`, `timestamp
2026-08-06T22:20:04.186Z`):

> "Moment: Die CEB baut die Compile time der Tier-Binaries und fuehrt dann deren Laufzeit aus. Also
> der Kopf der schlange ist Laufzeit und kontrolliert durch den Bau immer die compile time des
> naechsten gliedes und dann die freigegebenen Laufzeit-Eigenschaften dieses Gliedes. Bitte Schau
> nochmal nach ZWEIPHASIG und DREIPHASIG per Explore Agent, **denn es gibt 3 Typen in diesem System**"

**Der erste Satz entscheidet die Vokabel-Frage bereits.** Der Owner benutzt in *einem* Satz
"DREIPHASIG und ZWEIPHASIG (im Plan)" **und** "auf die nachfolgenden **Stufen**". Das ist nicht
Interpretation, das ist seine eigene Syntax: *dreiphasig/zweiphasig* ist sein Wort fuer das, was der
Plan **dreistufig/zweistufig** nennt, und die Wirkrichtung ist "auf die nachfolgenden Stufen".

### 1.2 War die fruehere Antwort richtig, unvollstaendig oder falsch?

**Antwort: die Schlussfolgerung war RICHTIG, die Erhebung UNVOLLSTAENDIG, die tragende
Beweisfuehrung FALSCH.** Im Einzelnen:

Die fruehere Erhebung steht in `super:docs/plaene/20260806-PLAN-messkette-ceb-observabletier.md`,
Abschnitt "(P-1) Die Stufen-Doktrin". Ihre inhaltliche Aussage (Zeilen 114-121) ist korrekt und wird
durch `LEDGER:4082/4083` unabhaengig getragen. Ihr **Beweis** (Zeilen 122-125) lautet woertlich:

> "**Die Vokabel-Kollision, die die Gedaechtnisluecke erzeugt hat:** im gesamten `docs/`-Baum gibt es
> **genau einen** Treffer auf `zweiphasig` und **null** auf `dreiphasig` (`/usr/bin/grep -rn`, ueber
> `docs/`)."

**Nachgemessen, heute, ueber `super:docs/` (Nenner: 3740 Dateien, `/usr/bin/grep -rn -i -I`):**

| Term | gemessen | Behauptung des Plans |
|---|---|---|
| `dreiphasig` (case-insens.) | **8 Zeilen in 5 Dateien** | "null" |
| `zweiphasig` (case-insens.) | **38 Zeilen** | "genau einen" |

Gegenprobe, dass die Suche nicht blind ist: dasselbe Verfahren auf `zweistufig` liefert im Ledger
allein 10 Treffer.

**Zwei unabhaengige Ursachen der falschen Null:**

1. **Gross-/Kleinschreibung.** Der Owner schreibt **`DREIPHASIG`** in Versalien. Ein
   case-sensitives `grep 'dreiphasig'` kann das strukturell nicht sehen. Auf
   `super:docs/sessions/20260806-KONTEXTUEBERGABE-abend-praezise.md` liefert
   `/usr/bin/grep -c 'dreiphasig'` = 0, `/usr/bin/grep -ci 'dreiphasig'` = 1.
   **Das ist eine zweite, von der ugrep-Falle unabhaengige Null-Quelle** und gehoert als
   Dauer-Regel notiert: jede `-phasig`/`-stufig`-Suche im Korpus **muss `-i` tragen**.
2. **Zeitpunkt der Zaehlung.** Die Zaehlung lief, bevor die eigenen Wellen-Artefakte des 06.08.
   gelandet waren.

**Was die fruehere Erhebung trotzdem richtig gesehen hat -- und was hier bestehen bleibt:**
alle 5 Dateien mit `dreiphasig` tragen das Datum **06.08.2026** und sind **Ableitungen der
Owner-Nachricht selbst** (`docs/ARBEITSWEISE-GESAMT-DOKTRIN.md`,
`docs/plaene/20260806-PLAN-messkette-ceb-observabletier.md`,
`docs/sessions/20260806-ANKNUEPFPUNKTE-vorarbeit-je-aufgabe.md`,
`docs/sessions/20260806-KONTEXTUEBERGABE-abend-praezise.md`,
`docs/sessions/backups/20260806-workflow-rohdaten/journals/wf_514dab7d-8a0.journal.jsonl`).
Erkennbar z.B. an `super:docs/ARBEITSWEISE-GESAMT-DOKTRIN.md:363-365`, das die Owner-Klausel
woertlich nachfuehrt:

> "- **Mess-Achsen-Aenderung erzwingt CEB- UND Binary-Neubau** (dreiphasig/zweiphasig) —
>   Vertrag CEB vs Tier-Binary bzw. Tier-Hybrid beachten."

**Vor dem 06.08. gibt es keinen einzigen Plan-Treffer auf `dreiphasig`.** Die Richtung der
frueheren Aussage ("das Vokabular *dreiphasig* existiert im Plan nicht, es heisst dort
*-stufig*") stimmt also. Nur die Zahl stimmt nicht -- und die Zahl war ihr Sicherheitsanker.

**Konsequenz fuer die Aktenlage:** Der in
`super:docs/sessions/20260806-ANKNUEPFPUNKTE-vorarbeit-je-aufgabe.md:1162` gebuchte Widerspruch

> "**F2 (dreiphasig/zweiphasig): zwei Berichte derselben Welle widersprechen sich** — belegt vs.
> *"Welche Lesart gilt, ist UNBELEGT."*"

ist mit diesem Dokument **aufgeloest**: die Lesart ist belegt (Abschnitt 4), die Beweisfuehrung des
einen Berichts war es nicht (Abschnitt 1.2), und der Gegenbericht hatte mit seiner Vorsicht recht,
aber aus dem falschen Grund (Abschnitt 5, Z-7).

---

## 2. DIE SCHLANGE -- die Mechanik, am Code belegt

Der Owner beschreibt: *"der Kopf der schlange ist Laufzeit und kontrolliert durch den Bau immer die
compile time des naechsten gliedes und dann die freigegebenen Laufzeit-Eigenschaften dieses
Gliedes."* Das ist **kein neues Bild** -- es ist die Verallgemeinerung eines Satzes, den er am
20.07. schon gesagt hat, `LEDGER:3095` (§57, "User-Praezisierung, massgeblich, verbatim-treu"):

> "Bei der CEB sind System-Achse und Organ-Achse noch runtime und die Mess-Achse fest einkompiliert
> (bis auf Variablen des Planers ueber dynamische Unter-Achsen); **die CEB baut zu ihrer Laufzeit die
> compile-time Tier-Binaries auf**, welche dann den System-Achse x Organ-Achse Typ+Versions-Stempel
> erhalten. Die CEB hat ihren eigenen Typ+Versions-Stempel ueber die Mess-Achse des Planers."

Und als Gesetz ausformuliert, `LEDGER:3097-3100` (§57 S1 "Compile/Runtime-Grenze je Stufe"):

> "- **Planer:** traegt die Mess-Achse; baut je Mess-Tooling-Wahl EINE CEB.
> - **CEB …:** die **Mess-Achse ist FEST EINKOMPILIERT** … **System-Achse und Organ-Achse sind an der
>   CEB NOCH RUNTIME** — die CEB haelt sie als Bau-Raum. Die CEB **baut zu IHRER LAUFZEIT die
>   COMPILE-TIME Tier-Binaries** (ihre Laufzeit = Bau-Zeit der Tier-Binaries).
> - **Tier-Binary:** compile-time-Artefakt; ein festes (System x Organ)-Kompilat."

### 2.1 Glied 1: der Planer laeuft -- und bestimmt die Compile-Time der CEB

**Er ist eine eigene Binary und wird von keinem Kettenglied gebaut.**
`ce:apps/experiment_planner/main.cpp:2-11`:

> "`apps/experiment_planner/main.cpp -- comdare-experiment-planner: die PLANER-ROLLE als EIGENE Binary (W1).`
> `OWNER-KERN (05.08.2026, F1-HART): "Der Planer ist ZWINGEND eine eigene Binary mit dem
> User-CLI-Interface auf der Shell." … der TRAEGER der Mess-Achsen-STUFE-1-RT-FREIGABE. … Die CEB
> (comdare-messung-driver) ist die Stufe-2-Instanz`"

Gebaut wird er von einem handgeschriebenen CI-Job, `super:.gitlab-ci.yml:1260-1263`:

> "`# W1 (05.08.2026, F1-HART): die DELEGATION ist die PLANER-Rolle -- sie laeuft ab hier ueber die eigene`
> `# ce-Binary comdare-experiment-planner. Der Job baut NUR noch dieses Target: der Treiber (CEB) wird in`
> `# diesem Job gar nicht gebraucht, er wird von den EMITTIERTEN ceb:build-Jobs selbst gebaut (Section 40.b).`
> `- cmake --build build --target comdare_experiment_planner`"

**Er LAEUFT** -- `super:.gitlab-ci.yml:1270`:

> "`"$PLANNER" plan ci "$COMDARE_GOLDEN_N_PROFILE" > "$CI_PROJECT_DIR/planer-child-ci.yml"`"

und zwar rein lesend: `ce:libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:34`:

> "`* REINER Lese-/Enumerations-/Render-Schritt: KEIN DLL-Bau, KEINE Messung, KEIN run_lazy_static_then_dynamic,`"

**Er bestimmt die CT der CEB** -- an **vier** Emissionsstellen derselben Datei
(`experiment_plan_director.hpp`), jeweils als Zeilenpaar `cmake -B` / `cmake --build --target
comdare-messung-driver`: **874/876** (`ceb:build`), **912/914** (`ceb:emit`), **1233** und **1386**
(Tier-Bau- bzw. Mess-Batch je Host-Lane). Zeile 874-876 woertlich:

```
s += "    - cmake -B build -G Ninja -DCOMDARE_V32_ENABLE=ON" + ceb_pmc_compile_define() +
     " -DCMAKE_BUILD_TYPE=Release" + ceb_combo_compile_define(c.legend) + "\n";
s += "    - cmake --build build --target comdare-messung-driver\n";
```

Was da compile-hart eingebaut wird:

- **die Mess-Combo** -- `:262-265`
  `if (ceb_combo_is_full_set(combo_legend)) return " -UCOMDARE_MEASUREMENT_COMBO"; return " \"-DCOMDARE_MEASUREMENT_COMBO=" + combo_legend + "\"";`
- **die PMC-Pflicht** -- `:291` `ceb_pmc_compile_define() { return " -DCOMDARE_ENABLE_PMC=ON"; }`,
  als Invariante formuliert in `:275-277`: "Zu JEDER emittierten `cmake -B build`-Zeile, deren
  FOLGEZEILE den comdare-messung-driver baut, gehoert `-DCOMDARE_ENABLE_PMC=ON`."
- **der Build-Typ** -- `-DCMAKE_BUILD_TYPE=…` aus der aufgeloesten Run-Methodik.

**Er gibt der CEB Laufzeit-Eigenschaften frei** -- Env-Exporte in denselben emittierten Jobs, u.a.
`:1268-1269` (`COMDARE_BUILD_PARALLEL`, "§62-B Lane-Budget … harte Compile-Worker-Zahl statt der
nproc-Heuristik"), `:1279-1281` (`COMDARE_LANE`, mit dem Kommentar "Ohne diese Zeile muesste der
Treiber die Lane raten (Hostname-Heuristik); der emittierende Planer kennt sie und sagt sie"),
`:1440-1442` (`COMDARE_GOLDEN_N_RANGE`), `:1449` (`COMDARE_PLATFORM`).

### 2.2 Glied 2: die CEB laeuft, baut die Tiers und fuehrt sie aus -- in *einer* Binary

**Bau:** `ce:libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp:874-877`:

> "`/// POSIX-CompileFn: realer g++-Subprozess, baut perm_<id>.cpp -> perm_<id>.so (SHARED).`
> `/// Nutzt @rsp und posix_spawnp(argv), also keinen /bin/sh-String; …`"

Vollzug `:915`: `return detail::run_argv_redirected({cxx, "@" + rsp.string()}, log);`

**Was die CEB den Tiers CT mitgibt** --
`ce:libs/cache_engine/profile_facade/profile_run_facade.cpp:273-297`, `perm_mess_defines()`:

```cpp
std::vector<std::string> d = {"-DCOMDARE_ANATOMY_MODULE_BUILD=1", "-DCOMDARE_MEASUREMENT_ON=1",
                              "-DCOMDARE_CE_ENABLE_STATISTICS=1", "-DCOMDARE_EXPERIMENT_MODE_ON=1"};
#ifdef COMDARE_OS_LINUX
    d.emplace_back("-DCOMDARE_OS_LINUX=1");
#endif
…
#ifdef COMDARE_CACHE_LINE_SIZE
    d.emplace_back("-DCOMDARE_CACHE_LINE_SIZE=" + std::to_string(…COMDARE_CACHE_LINE_SIZE));
#endif
```

**Diese `#ifdef`-Konstruktion ist der praeziseste Einzelbeleg fuer das Schlangen-Bild:** die CEB
reicht **ihre eigene, vom Planer bestimmte Compile-Zeit** als Compile-Flag an das naechste Glied
weiter. Was oben CT eingebaut wurde, wird unten CT eingebaut. Der Kommentar `:300-303` benennt die
vier CT-Kanaele: "(1) Mess-/OS-/Arch-Defines (perm_mess_defines), (2) Allokator-ORGAN-Defs
(snmalloc-Vertrag), (3) Compiler-SYSTEM-Flag -mcx16 (atomic128-Achse), (4) external_utils-SIMD
-march."

**Bau UND Ausfuehrung in derselben Funktion** --
`ce:libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:1607-1613`:

> "`/// run_lazy_static_then_dynamic — … (1) Haupt/statisch-Iterator über view+selection →
> BuildOrchestrator (STATISCHE Kompilierung, resumierbar/RAM-gated), (2) je DLL load →
> IObservableTier + IResourceControllableTier, (3) gefiltert-dynamisch-Iterator … → messen → ingest.`"

mit `provision_all(...)` (`:1824`), `AnatomyModuleLoader::load(...)` (`:2376`) und der Messschleife
(`:2423`, `:2471`). `dlopen` selbst:
`ce:libs/cache_engine/builder/anatomy_module_loader/anatomy_module_loader.cpp:40`.

**Dass es *dieselbe* Binary ist:** `super:Code/02_messung_driver/CMakeLists.txt:4,16-18,29-30` linkt
`messung_driver` (OUTPUT_NAME `comdare-messung-driver`) gegen `comdare::profile_run_facade` -- und
genau diese Bibliothek enthaelt sowohl die vier `make_gpp_compile_fn`-Aufrufe (Bau) als auch
`run_lazy_static_then_dynamic` (Bau + Laden + Messen).

**Die Grenze zwischen den beiden Bau-Wegen sagt der Planer selbst** --
`experiment_plan_director.hpp:284-286`:

> "`TIER-NEUTRALITAET: add_compile_definitions(COMDARE_ENABLE_PMC) (ce CMakeLists.txt:77) wirkt auf den
> CMAKE-Teilbaum, also auf den Treiber. Die Tier-.so entsteht ueber einen eigenen g++-Subprozess des
> Treibers (build_orchestrator.hpp) und traegt das Makro NICHT -- Klasse CEB-ONLY, 0 Tier-Binaries.`"

**cmake baut die CEB, die CEB baut per eigenem g++-Subprozess die Tier.** Zwei Bau-Wege, zwei
Glieder.

### 2.3 Glied 3: die Tier laeuft -- und baut nichts

Die Tier-`.so` laeuft nie als eigener Prozess, sondern nur per `dlopen` im Host (2.2). Und sie
startet keinen Compiler.

**Nullbefund mit Nenner und Gegenprobe:** `/usr/bin/grep -rn "posix_spawn\|std::system(\|execvp\|popen("`
ueber `ce:libs/cache_engine/anatomy/` + `ce:libs/cache_engine/axes/` (dem Code, der in die Tier-.so
kompiliert wird) → **0 Treffer bei 399 durchsuchten Dateien**. Gegenprobe: dasselbe Verfahren auf
`ce:libs/cache_engine/builder/` → **24 Treffer**.

### 2.4 Der Hybrid ist heute kein Glied

`ce:libs/cache_engine/hybrid/` enthaelt genau **eine** Datei, `README.md` (3820 Bytes, mtime
06.08. 21:25). `README.md:1` und der Zweck-Kommentar:

> "`# hybrid/ -- RESERVIERTER STUB der Hybrid-Tier-Stufe (KEIN CODE)`
> … `KEIN Header, KEINE Quelle, KEINE CMakeLists, KEIN Build-Anschluss - libs/cache_engine/CMakeLists.txt
> listet seine Unterverzeichnisse einzeln per add_subdirectory (kein GLOB), dieser Ordner ist dort
> NICHT eingetragen und damit build- und byte-neutral.`"

Gegenprobe zur Null: `/usr/bin/grep -n "hybrid" ce:libs/cache_engine/CMakeLists.txt` → 0 Treffer;
dieselbe Datei enthaelt 5 `add_subdirectory`-Zeilen (`builder`, `profile_facade`,
`concurrency_manager`, `subsystems`, `reclamation`), die dasselbe Verfahren findet.

**Ist: dreigliedrig. Soll: dehnbar auf vier.** `README.md:18`: "`**Bau-Zeitpunkt:**
Auswertungsphase. Vorher entsteht hier KEIN Code.`"

---

## 3. DIE DREI TYPEN -- die Antwort

### 3.1 Die kurze Antwort

**Die drei Typen sind die drei Kettenglieder -- Planer, CEB, Tier-Binary -- und zugleich, weil der
Ledger sie 1:1 aneinanderbindet, die drei Achsen-Arten Mess, System, Organ. Das sind nicht zwei
konkurrierende Antworten, sondern zwei Seiten derselben Dreiheit.**

Der Bindungssatz ist Ledger-Doktrin, `LEDGER:2955` (§15.10-D/§24/§47, "bindend, §54-T1-korrigiert"):

> "**System-Achsen getrennt von ORGAN-Achsen** — NICHT "Gattungs-Achsen" (Gattung = einheitliches
> Tier-Binary-Interface, keine Achse; **Achsen sind Achsen-TYPEN {Organ/System/Mess}**); beide
> CT-Haupt+RT-Unter, Planer als 3. Anwendung. **§24-Ketten-Statik identisch an ALLEN 3
> Vertragspunkten** (Haupt=statisch/CT-eingefroren, Unter=dynamisch/delegiert): **Planer→Mess** …,
> **CEB→System**, **Tier→Organ**"

Das ist zugleich die einzige Stelle im Ledger, an der das Wort **"TYPEN"** ueberhaupt an dieser
Dreiheit klebt -- und es klebt dort an den Achsen-Arten, in einem Satz, der sie den drei
Vertragspunkten der Kette zuordnet.

### 3.2 Was der Code sagt -- und er sagt "Phase" an genau diesen drei Objekten

`ce:libs/cache_engine/builder/bestandslog/bestandslog_document.hpp:117-121`:

```cpp
// Batch-Typ einer Reservierung (Testat-Grammatik §62-B, ebenen-richtig):
//   tier         -- Tier-Binary-Bau-Batch ([d,e,f]-Replay-Schluessel)
//   ceb          -- CEB-Binary-Bau ([a,b,c]-Replay-Schluessel)
//   planer_block -- Planer-Vorreservierung vor einem CEB-Compile (30min pro-forma, OHNE ETA, B7)
enum class BatchTyp { tier, ceb, planer_block };
```

`ce:libs/cache_engine/builder/bestandslog/batch_planner.hpp:81-96`:

```cpp
// B13 Batch-Typ-Sequenz-Wache: gueltige Bau-Ordnung planer_block(0) -> ceb(1) -> tier(2). Die
// Phasen-Raenge einer Sequenz muessen NICHT-fallend sein (kein Rueckfall in eine fruehere Phase).
[[nodiscard]] inline int type_phase_rank(BatchTyp t) noexcept { … }
[[nodiscard]] inline bool is_valid_type_sequence(std::span<BatchTyp const> seq) noexcept { … }
```

**Drei Typen, drei Phasen-Raenge, Reihenfolge Planer → CEB → Tier, mit einer Wache gegen den
Rueckfall.** Das ist die Schlange des Owner-KERNs, als C++-Typ kodiert -- und der Bezeichner heisst
`type_phase_rank`. Hier bedeutet "Phase" **nicht** Achsen-Stufe, sondern **Position in der Kette**.

Und auf der Achsen-Seite, `ce:libs/cache_engine/topics/axis.hpp:17-20`:

```cpp
enum class AxisKind : unsigned char {
    organ,              ///< Organ-/Tier-Binary-Achse (permutiert die binary_id, 18 Slots; …)
    system_measurement, ///< Mess-System-Achse ("Blut", host-seitig immer praesent, golden-neutral)
    system_config,      ///< CEB-Konfig-System-Achse (Bau-/Steuer-Parameter, beruehrt NIE die binary_id)
```

mit Owner-Wortlaut im selben Header, `axis.hpp:40-41`:

> "`Der Owner-Wortlaut kennt DREI Realms, zu denen eine Meta-Meta gehoeren kann: "Da eine
> Meta-Meta-Achse immer zu den Mess-Achsen, System-Achsen oder Organ-Achsen gehoert ..."`"

(Die drei weiteren Enumeratoren `system_meta_meta`, `measurement_meta_meta`, `organ_meta_meta` sind
laut `axis.hpp:22-49` rein additiv und heute byte-neutral -- sie sind Meta-Meta-Diskriminatoren
**innerhalb** der drei Realms, keine vierte/fuenfte/sechste Achsen-Art.)

### 3.3 Die Lesarten, die ich geprueft habe -- und wie sie ausgehen

| Kandidat | Beleg | Urteil |
|---|---|---|
| **(A) Achsen-Arten Mess/System/Organ** | `LEDGER:2955` (Wort "TYPEN"), `LEDGER:4082` (3/2/2), `ce:topics/axis.hpp:17-20,40-41` | **BELEGT.** Traegt die Zahlwoerter drei/zwei. |
| **(B) Kettenglieder Planer/CEB/Tier** | `ce:bestandslog_document.hpp:121`, `ce:batch_planner.hpp:83-96` ("Phasen-Raenge"), `LEDGER:3097-3100`, `LEDGER:2955` ("3 Vertragspunkte") | **BELEGT.** Traegt das Wort "Phase". |
| **(C) Drei Bau-/Lauf-Rollen** | Abschnitt 2 (Code) + `LEDGER:3097-3100` | **BELEGT als Mechanik**, aber im Korpus **nirgends als "drei Typen" gezaehlt**. Es ist die Verb-Seite von (B), keine eigene Dreiheit. |
| **(D) Drei Lauf-Phasen bau/pruef/mess** | `ce:experiment_plan_director.hpp:1293,1301` (`phase=bau`), `:1316,1319` (`phase=pruef`), `:1474,1477` (`phase=mess`); `ce:slice_marker.hpp:85,103` | **BELEGT als eigene Dreiheit**, aber sie zaehlt **Arbeitsschritte**, nicht Traeger, und kennt keinen zweiwertigen Gegenpart. Passt nicht auf "ZWEIPHASIG". |

**(A) und (B) sind nicht zwei Antworten.** `LEDGER:2955` bindet sie explizit 1:1: Planer→Mess,
CEB→System, Tier→Organ. Wer (A) sagt, sagt (B) mit; wer (B) sagt, sagt (A) mit. (C) ist ihre
Verb-Formulierung. Damit bleibt genau **eine** echte Alternative uebrig: (D).

### 3.4 Meine Empfehlung -- und wo ich Eindeutigkeit NICHT behaupte

**Empfehlung: (A)≡(B)≡(C) als *eine* Dreiheit dem Owner vorlegen, in der Formulierung von (B),
weil dort *sein* Wort "Typ" und das Wort "Phase" im Code auf denselben drei Objekten sitzen.**

**Was ich nicht behaupten kann:** Es gibt **keinen Owner-Satz, der "3 Typen" definiert**. Nullbefund
mit Nenner: `/usr/bin/grep -n -i "3 Typen\|drei Typen"` ueber den SSOT-Ledger (6735 Zeilen) → 0
Treffer; Gegenprobe: dasselbe Verfahren auf `"Typ"` liefert dort **118** Treffer. Die
Zuordnung in 3.1-3.3 ist ein **begruendeter Schluss aus Satzkontext + Korpus-Bindung**, kein Zitat.
Die naechststaerkste Owner-Verbindung von "3 Typen" zu den Achsen-Arten ist zudem alt und aus einem
anderen Anlass: Owner am 01.08. abends, persistiert in
`super:docs/sessions/backups/20260802-kontext-neugruendung-abend-workflows/ergebnisse/45-1bbd49eb.md:33`:

> "E-1: Thesis ist veraltet und kennt noch nicht mal **die 3 Typen der Mess-Achsen, System-Achsen und
> Organ-Achsen**."

Das ist die einzige mir bekannte Stelle, an der der Owner die Wendung "3 Typen" selbst benutzt --
und dort definiert er sie als Achsen-Arten. **Das ist der staerkste einzelne Anker fuer (A).**

**Restrisiko (D):** wenn der Owner mit "Typ" die drei *Laufarten* derselben CEB gemeint haette
(`provision_only` / `pruef_only` / Vollauf, `ce:profile_facade/profile_run_entry.hpp:213-215`), dann
zeigte "ZWEIPHASIG" ins Leere -- es gibt dazu keinen zweiwertigen Gegenpart. Ich halte (D) fuer
unwahrscheinlich, kann es aber nicht ausschliessen.

---

## 4. Phase gegen Stufe -- sind es zwei Namen fuer dieselbe Sache?

### 4.1 Das Ergebnis der strengen Pruefung

**Fast, aber nicht ganz -- und der Unterschied ist genau der Grund, warum der Owner "3 Typen" sagt
und nicht "3 Stufen".**

**Was identisch ist:** die Zaehl-Achse. Beide zaehlen dieselbe Kette Planer→CEB→Tier. `LEDGER:4082`
(Owner verbatim, 05.08. mittag-9):

> "Das war nur fast richtig: Die Mess-Achsen sind DREISTUFIG Symmetrisch, die Sytem-Achsen sind
> ZWEISTUFIG symmetrisch und die Organ-Achsen sind ZWEISTUFIG symmetrisch, wobei **die erste stufe
> immer Runtime Freigabe und die nachfolgenden Stufen compile time Einbau sind
> Planer->CEB-TierBinaries**. Wenn wir die Hybriden betrachten und sie als vierte Stufe eingeschoben
> sind, erben sie ALLE Eigenschaften vorausgegangener Stufen und geben die Eigenschaften der
> Mess-Achse an ihre Tier-Binaries zur compile Zeit weiter"

Als Gesetz, `LEDGER:4083`:

> "GESETZ: Die ERSTE Stufe ist IMMER Runtime-Freigabe in der Traeger-/Freigabe-Binary, alle
> NACHFOLGENDEN Stufen sind Compile-Time-EINBAU entlang der Kette Planer->CEB->Tier-Binaries."

Owner-abgenommen, `LEDGER:4095` (mittag-11):

> "Jetzt ist alles korrekt, wie du es beschrieben hast … Volles go, jetzt ist alles perfekt von dir
> verstanden hier in der Session"

**Warum Mess DREI und System/Organ ZWEI hat** -- die Frage des Auftrags, Owner-belegt durch
`LEDGER:3095` (§57, 20.07.): an der CEB ist die Mess-Achse **schon compile-time**, System und Organ
sind dort **noch runtime**. Also liegt die RT-Freigabe der Mess-Achse (= ihre Stufe 1) **vor** der
CEB, im Planer; die Stufe 1 von System und Organ **ist** die CEB. **Die Mess-Achse startet ein Glied
frueher -- belegt.**

Daraus folgt die Fortpflanzungs-Asymmetrie, die Owner-KERN (A) benennt: eine **System-**Achsen-
Aenderung baut die Tiers neu, eine **Mess-**Achsen-Aenderung baut **CEB und Tiers** neu.

### 4.2 Wo Phase und Stufe auseinanderfallen: der Hybrid

**Die Stufenzahl ist dehnbar, die Typenzahl nicht.**

- Stufen sind dehnbar: `LEDGER:4082` "als vierte Stufe eingeschoben"; `LEDGER:4090` (kanonische
  Gesamtform mittag-9+mittag-10): "**MESS-Achsen:** Planer(RT-Freigabe) -> CEB(CT) -> [Hybrid(CT)] ->
  Tier(CT) — DEHNBAR. **SYSTEM-Achsen:** CEB(RT-Freigabe) -> [Hybrid(CT) …] -> Tier(CT) — DEHNBAR
  exakt wie Mess. **ORGAN-Achsen:** NUR in den Tier-Binaries VERBAUT … sie BERUEHREN die Hybriden
  NICHT direkt".
- Typen sind es nicht: der Hybrid ist selbst eine Tier-Binary. `LEDGER:4076`: "HYBRID-Ruf: Heuristik
  **SELBST als Tier-Binary** am selben Pruef-Dock (**kein dritter Dock-Typ**) … **Tier-Neubau IMMER
  delegiert durch CEB**". `LEDGER:4090` nennt ihn "Factory-Pattern-Facade-**ADAPTER**", nach aussen
  ein "**virtuelles ganzes Tier-Binary**", organ-frei.

**Damit ist die Owner-Frage beantwortet und die Vokabel-Verwirrung aufgeloest:**

> **STUFE** = wie viele Glieder eine **Achsen-Art** besetzt. Achsen-relativ (3 / 2 / 2), **dehnbar**
> durch Hybrid-Einschub (4 / 3 / 2).
> **PHASE** im Owner-Sinn = **Position in der Kette**, d.h. der **Traeger-Typ**. Fester Bestand der
> Anlage: **3** (Planer / CEB / Tier). Nicht dehnbar.
> Sie zaehlen **dieselbe Kette** -- die Stufe von der Achse aus, die Phase vom Glied aus.

Wer "3 Stufen" sagt, sagt etwas, das mit dem ersten eingeschobenen Hybrid falsch wird. "3 Typen"
bleibt wahr. **Das ist die Praezision, die der Owner mit seinem zweiten KERN nachgeliefert hat.**

Und das ist zugleich der Inhalt der "Gedaechtnisluecke": **zwei** der drei Typen sind zweiphasig, nur
**einer** ist dreiphasig. Wer die Paar-Formel "DREIPHASIG und ZWEIPHASIG" ohne die drei Traeger liest,
ordnet "ZWEIPHASIG" genau einer Sache zu und uebersieht den zweiten Zweiphasigen.

---

## 5. Die konkurrierenden Zaehlungen -- die Kollisionskarte

Damit die Verwechslung nicht ein drittes Mal passiert. Jede Zeile mit Fundstelle und
Geltungsbereich.

| # | Zaehlung | Fundstelle | Geltungsbereich | Owner-Referenz plausibel? |
|---|---|---|---|---|
| **Z-1** | **Achsen-Stufigkeit 3/2/2** | `LEDGER:4082`, `:4083`, `:4089`, `:4090`; abgenommen `:4095` | Achsen-Doktrin, kanonisch | **JA -- primaer.** Einziger Kandidat mit **beiden** Zahlen und Fortpflanzungs-Semantik |
| **Z-2** | **Achsen-TYPEN {Organ/System/Mess}** = 3 Vertragspunkte | `LEDGER:2955` (kanonisch, §54-T1-korrigiert); Vorlaeufer mit derselben "ALLEN 3 Vertragspunkten"-Formel, aber noch alter "Gattungs-Achsen"-Sprache: `LEDGER:2609`, `:2506`; `ce:topics/axis.hpp:17-20,40-41` | Achsen-Taxonomie + §24-Ketten-Statik | **JA -- das Wort "TYPEN" steht in `:2955`** |
| **Z-3** | **Kettenglied-Typen / Rollen** Planer/CEB/Tier | `LEDGER:3097-3100`; `ce:bestandslog_document.hpp:121`; `ce:batch_planner.hpp:83-96` | Bau-Ordnung + Bestandslog-Buchhaltung | **JA -- Code sagt hier "Phase"** |
| **Z-4** | **Dreistufige Legenden-/CI-Kette** `planer:delegate → ceb:build/emit → tier:build` | `LEDGER:2423` (§42 "dreistufige Legenden-Pipeline-Kette"), `:2487`, `:3011`; `super:docs/plaene/20260719-ci-kette-start-zu-gruen-DETAIL.md:250-253` | CI-Projektion von Z-2/Z-3 | mittelbar JA |
| **Z-5** | **Testat-Grammatik: 2 vs. 3 Klammern** | `LEDGER:3417-3419` ("NUR die Mess-Ebene traegt alle drei Klammern") | Testat-/Replay-Grammatik | MOEGLICH -- inhaltlich dieselbe Asymmetrie wie Z-1 |
| **Z-6** | **Drei Bestandslog-Replay-Schluessel** `[a,b,c]` / `[d,e,f]` / `[d,e,f]+[g,h,i]` | `LEDGER:3421` | Replay-/Cache-Schluessel | unwahrscheinlich als Referenz |
| **Z-7** | **Zwei-Phasen-Op-Schleife** (save→warmup→rollback→measure) | `ce:docs/architecture/messarchitektur_v5_design.md:174-183`; `ce:libs/cache_engine/harness/perm_runner.hpp:136` (`two_phase_valid`); `ce:builder/pruef_dock/search_algorithm_dock.hpp:52` | **Messverfahren je Op** -- **HOMONYM, nichts mit der Kette zu tun** | **NEIN.** Es existiert **kein dreiphasiger Gegenpart**: `/usr/bin/grep -rn -i "drei-phasen\|drei phasen\|three_phase\|three-phase\|dreiphasen\|dreiphasig"` ueber den ce-Baum (**Nenner 5502 Dateien**) → **0**. Gegenprobe: `two_phase\|zwei-phasen\|zweiphasig` → **519** |
| **Z-8** | **`<phase merge="Stufe{1,2,3}">`** -- Phase und Stufe literal gleichgesetzt | `ce:profile_facade/validate_profile.hpp:601` (`Stufe1_CeOnly, Stufe2_PrueflingReplace, Stufe3_FullJoin`), `:1078` | Pruefling-Merge der Mess-Schema-XML | NEIN als KERN-Referenz (Merge loest keinen Neubau aus) -- **aber der staerkste Objekt-Beleg dafuer, dass im Projekt "Phase" == "Stufe" gesprochen wird** |
| **Z-9** | **ZWEIPHASIGKEIT des System-Stempels** (W10-Ausrollung) | `ce:include/cache_engine/abi/anatomy_version_stamp.hpp:118-125` ("PHASE 1 (bis W10) … PHASE 2 (seit W10-C4, 04.08.2026)") | zeitliche Ausrollung in zwei Etappen -- **HOMONYM** | NEIN |
| **Z-10** | **Lauf-Phasen `bau` / `pruef` / `mess`** | `ce:experiment_plan_director.hpp:1293,1301,1316,1319,1474,1477`; `ce:slice_marker.hpp:85,103`; Modi `provision_only`/`pruef_only` in `ce:profile_run_entry.hpp:213-215` | Arbeitsschritte eines Laufs | **MOEGLICH, aber schwach** -- kein zweiwertiger Gegenpart |
| **Z-11** | **Tier-Binary = ZWEI Layer** `[d,e,f]` HW / `[g,h,i]` App-Logik | `LEDGER:3420` ("kanonisch bleibt die Zwei-Klammer-Form") | Stempel-/Legenden-Form | NEIN |
| **Z-12** | **System-Haupt-Achse hat DREI Glieder** `target_isa`/`operating_system`/`external_utils` | `LEDGER:2229`, `:3083`, `:3359` | Achsen-**Inhalt** -- Namenskollision "Glieder" | NEIN |
| **Z-13** | **CEB drei Modi** (Arbeits-/Hot-/Tier-Switching) | Memory `feedback_ceb_drei_modi_arbeitsmodus_hot_tier_switching` | Betriebsmodi | NEIN |
| **Z-14** | **siebenphasiger ExperimentDriver** | `super:thesis/diplomarbeit/kapitel/de/04_implementierung.tex:17` u.a. | Alt-Treiber (7, nicht 2/3) | NEIN |

**Die drei Merksaetze, die die Kollision entschaerfen:**

1. **"-phasig" ist im Korpus mehrheitlich ein HOMONYM.** Von allen `-phasig`-Zeilen gehoert die
   Mehrzahl zu Z-7 (Mess-Operation) oder Z-9 (Stempel-Ausrollung) und **nicht** zur Ketten-Sprache.
2. **Der Owner schreibt Schluesselbegriffe in VERSALIEN.** Jede `-phasig`/`-stufig`-Suche **muss
   `-i` tragen**. Ohne `-i` ist sein Wortlaut strukturell unsichtbar (Abschnitt 1.2).
3. **Datei-Reihenfolgen-Falle.** Die *stale* mittag-8-Lesart steht in `LEDGER:4193` -- also **nach**
   mittag-9 (`:4082`) -- ist chronologisch aber **aelter**. `LEDGER:4194` fuehrt den
   SUPERSEDED-Vermerk und warnt woertlich: "**ACHTUNG Datei-Reihenfolge-Falle: dieser Absatz steht in
   der Datei NACH mittag-9/-10, ist aber chronologisch AELTER (mittag-8).**" Wer den Ledger
   sequenziell liest, sieht die falsche Form zuletzt.

**Superseded-Lage / welche Fassung ist juenger:**

| Dokument | Datum | Status |
|---|---|---|
| `LEDGER:4082-4095` (mittag-9/-10/-11) | 05.08. | **KANONISCH, Owner-abgenommen** |
| `LEDGER:4193` (mittag-8, "DREISTUFIG SYMMETRISCH" als Gesamt-Etikett) | 05.08. | **SUPERSEDED** per `LEDGER:4194` |
| `LEDGER:2253`, `:2344`, `:4074` | aelter | additive Korrektur-Verweise auf die kanonische Form |
| `…jsonl:5704` (Owner-KERN A) | 06.08. 19:37 | Owner-Quelle |
| `docs/sessions/20260806-KONTEXTUEBERGABE-abend-praezise.md:78` | 06.08. 20:30 | Nachfuehrung (verkuerzt zitiert) |
| `docs/plaene/20260806-PLAN-messkette-ceb-observabletier.md:93-127` | 06.08. 20:40 | Schluss tragfaehig, **Beweisfuehrung Z.122-125 hiermit korrigiert** |
| `docs/sessions/20260806-ANKNUEPFPUNKTE-vorarbeit-je-aufgabe.md:1162` | 06.08. | buchte den Streit als offen -- **hiermit geschlossen** |
| `…jsonl:7256` (Owner-KERN B, "3 Typen") | 06.08. 22:20 | **juengste Owner-Aussage** -- ergaenzt, widerruft nichts |

---

## 6. Was daraus fuer den laufenden Bau folgt

### 6.1 PMC -- passt exakt ins Schlangen-Bild, und der Code sagt es woertlich

Owner-KERN vom 06.08., `…jsonl:5704`, Frage 3:

> "Es ist PFLICHT, dass das gemessen wird, was gemessen werden kann, aber es ist ja PMC vorhanden,
> also MUSS es auch mit eingebaut und gemessen werden **und zwar in die CEB fuer deren Pruefdock**."

**Das ist Glied 1 → Glied 2, lehrbuchrein**, und es ist gebaut:

- **Planer (RT) bestimmt CEB-CT:** `ce:experiment_plan_director.hpp:291`
  `ceb_pmc_compile_define() { return " -DCOMDARE_ENABLE_PMC=ON"; }`, angehaengt an alle **vier**
  `cmake -B build`-Zeilen (`:874`, `:912`, `:1233`, `:1386`).
- **CEB traegt die OS-Routinen CT:** `COMDARE_ENABLE_PMC` schaltet
  `ce:libs/cache_engine/builder/linux_perf_pmc_source.hpp:42`
  (`#if defined(COMDARE_ENABLE_PMC) && defined(__linux__)` → `perf_event_open`) bzw.
  `ce:libs/cache_engine/builder/windows_pcm_pmc_source.hpp:22` (Intel PCM) scharf; ohne das Makro
  waehlt `ce:libs/cache_engine/builder/pmc_source_factory.hpp:26-32` die `NullPmcSource`.
- **Tier-Binary laeuft ohne das Makro:** `ce:experiment_plan_director.hpp:284-286` -- "Klasse
  CEB-ONLY, **0 Tier-Binaries**". Gegenprobe: `COMDARE_ENABLE_PMC` kommt in
  `ce:libs/cache_engine/anatomy/` und `ce:libs/cache_engine/axes/` nicht vor; alle Fundstellen liegen
  in `builder/`, `harness/`, `profile_facade/planner/`, `apps/f15_compare/` und `CMakeLists.txt:81`.

**Und die Ehrlichkeits-Naht ist ebenfalls gebaut:**
`ce:builder/experiment_tree/cache_engine_builder_iterator.hpp:741`:
"NullPmcSource (COMDARE_ENABLE_PMC=OFF) sind alle Werte 0 und pmc_available=0 (ehrlich "nicht real
gemessen")".

**Bewertung: PMC ist ein Mess-Achsen-Merkmal und verhaelt sich genau dreistufig-asymmetrisch** -- es
wird im Planer entschieden, in die CEB einkompiliert, und laesst die Tiers unberuehrt. Der
Fortpflanzungs-Satz des Owners ("Mess-Achsen-Aenderung erzwingt CEB- UND Binary-Neubau") ist fuer PMC
also **nur zur Haelfte** einschlaegig: der PMC-Schalter allein baut die **CEB** neu, nicht die Tiers.
Was die Tiers mit-neu-baut, sind die Mess-Achsen-Merkmale, die durch `perm_mess_defines()` laufen
(`-DCOMDARE_MEASUREMENT_ON`, `-DCOMDARE_EXPERIMENT_MODE_ON`, Observer-Ausstattung). **Diese Trennung
sollte im Bau-Posten explizit gefuehrt werden** -- sonst baut man bei jeder PMC-Aenderung unnoetig
Tiers neu, oder schlimmer: man baut bei einer Observer-Aenderung die Tiers **nicht** neu.

### 6.2 Pinning -- die Kette aus dem Auftrag ist SOLL, nicht IST

Die im Auftrag skizzierte Kette lautet: *"der Planer prueft die Pinning-Faehigkeit RT und gibt sie
frei, die CEB traegt die OS-Routinen CT, die Tier-Binary laeuft."*

**Der Mittelteil stimmt. Der Kopf fehlt.**

- **CEB traegt die OS-Routinen CT:** `ce:libs/cache_engine/builder/measurement/thread_pinning.hpp`
  -- `class ScopedThreadPin`, plattformgeteilt per `#if defined(_WIN32)` (`SetThreadAffinityMask`) /
  `#elif defined(__linux__)` (`sched_getaffinity`/`sched_setaffinity`). Sie liegt unter `builder/`,
  also **host-/CEB-seitig**, nicht im Tier-Code.
- **Der Planer prueft heute nichts davon.** Nullbefund mit Nenner:
  `/usr/bin/grep -rn -i "pinning\|sched_setaffinity\|pin_thread\|cpu_affinity"` ueber
  `ce:libs/cache_engine/profile_facade/planner/` (**Nenner: 8 Dateien** --
  `experiment_plan_director.hpp`, `plan_legend.hpp`, `planner_cli_env.hpp`,
  `planner_status_reader.hpp`, `planner_status_types.hpp`, `planner_version.hpp`,
  `progress_cursor_reader.hpp`, `experiment_dock_payload.hpp`) → **0 Treffer**. Gegenprobe:
  dasselbe Verfahren auf `"PMC"` in demselben Verzeichnis findet `experiment_plan_director.hpp`.
  Der Planer kennt also PMC, aber kein Pinning.
- **Der einzige Konsument ist ein Auswertungswerkzeug, opt-in und Default aus:**
  `ce:apps/f15_compare/main.cpp:39` -- "`AP-13/#247: opt-in Mess-Thread-Pinning (--pin-core=N),
  host-seitig, Default no-op`"; `:225`
  `auto measurement_pin = pin_core.has_value() ? bld::CorePinPolicy{*pin_core}.pin() : bld::NoPinPolicy{}.pin();`
- **Die Tier-seitige Pinning-Abstraktion ist ein Interface ohne Implementierung:**
  `ce:libs/cache_engine/subsystems/c02_pinning_engine/` enthaelt **genau eine** Datei,
  `i_pinning_engine.hpp` (`class IPinningEngine` mit `recommend`/`apply_pin`, "REV 3 K3.2 generisch").
  Ebenso traegt `ce:include/cache_engine/platform/i_platform_probe.hpp:21` ein Feld
  `preferred_pinning_policy`, aber die Probe wird vom Planer nicht gelesen.

**Bewertung, ehrlich:** Pinning passt **konzeptionell** perfekt ins Schlangen-Bild -- es ist ein
Mess-Achsen-Merkmal (Stufe 1 = RT-Freigabe im Planer: "darf diese Lane pinnen?"; Stufe 2 = CT-Einbau
der OS-Routinen in die CEB; Stufe 3 = die Tier laeuft im gepinnten Thread). **Gebaut ist heute nur
Stufe 2 und ein opt-in-Werkzeug daneben.** Stufe 1 (Planer-RT-Freigabe) und die Verdrahtung an den
Messlauf **existieren nicht**. Das ist ein **Bau-Posten**, kein Befund -- und er ist strukturell
derselbe Posten wie PMC, nur ein Schritt weiter zurueck.

### 6.3 Startet die Mess-Achse wirklich im Planer? -- JA, mit einer Einschraenkung

**Doktrin: ja**, `LEDGER:4082/4083` und `LEDGER:3095` (Abschnitt 4.1).
**Code: ja, an der entscheidenden Naht** -- `ce:apps/experiment_planner/main.cpp:8-11` nennt die
Planer-Binary den "TRAEGER der Mess-Achsen-STUFE-1-RT-FREIGABE"; die Mess-Combo wird an genau den
vier Stellen `ceb_combo_compile_define()` compile-hart in die CEB gegossen (Abschnitt 2.1);
`ce:experiment_plan_director.hpp:34` bestaetigt, dass der Planer selbst nichts baut und nichts misst.

**Einschraenkung, die genannt gehoeren muss:** `ce:experiment_plan_director.hpp` traegt an mehreren
Stellen den Vermerk, der Director sei **opt-in und lauf-pfad-neutral** -- `:39-40`:
"`INERT-by-default: nichts ruft den Director ausser dem opt-in Contract-Test; kein
Lauf-Pfad-Verhalten geaendert (die golden Callees run_profile/run_experiment_profile sind
unberuehrt).`" Der CI-Job `super:.gitlab-ci.yml:1263-1270` ruft die Planer-Binary allerdings real
(`"$PLANNER" plan ci …`). **Das ist kein Widerspruch, sondern die W1-Lage:** die Planer-**Rolle**
laeuft ueber die eigene Binary, aber die *Bibliotheks-interne* Director-Klasse ist gegenueber den
Alt-Lauf-Pfaden inert. Wer den Zustand "Mess-Achse startet im Planer" pruefen will, muss den
**CI-Pfad** pruefen, nicht die Bibliotheks-Aufrufe.

---

## 7. Offene Fragen an den Owner

**F-1 -- Meinst du mit "3 Typen" die Kettenglieder oder die Achsen-Arten?**
*Meine beste Vermutung:* **beides, weil es dasselbe ist** (`LEDGER:2955` bindet Planer→Mess,
CEB→System, Tier→Organ 1:1). *Vorschlag:* wir fuehren die Dreiheit ab jetzt als **eine** Tabelle mit
drei Spalten (Glied | Achsen-Art | Stufigkeit) statt als zwei getrennte Aufzaehlungen. Dann kann die
Verwechslung nicht wiederkehren.

**F-2 -- Ist der Planer fuer dich ein "Erbauer", obwohl er nur emittiert?**
Der Code sagt beides: `experiment_plan_director.hpp:855` nennt ihn "Planer **steuert** CEB-Bau",
`:34` sagt "KEIN DLL-Bau". Wenn "baut" streng "startet einen Compiler" heisst, hat die Kette **nur
ein** wirklich bauendes Glied -- die CEB. *Meine beste Vermutung:* du meinst "baut" im Sinne von
"kontrolliert den Bau" (dein Wort war "kontrolliert **durch den Bau**"). *Vorschlag:* wir schreiben
die Rolle als "**Erbauer durch Emission**" fest, damit die Aussage "jedes Glied baut das naechste"
fuer Glied 1 wahr bleibt, ohne die Tatsache zu verwischen, dass der Compiler-Aufruf dort per CI/CMake
laeuft.

**F-3 -- Zaehlt der Hybrid als vierter Typ oder als vierte Stufe?**
Der Korpus sagt eindeutig **Stufe, nicht Typ** (`LEDGER:4076` "kein dritter Dock-Typ", `LEDGER:4090`
"virtuelles ganzes Tier-Binary"). Dein KERN sagt "ggf. Hybrid als eingeschobenes Glied" -- "Glied"
klingt nach Typ. *Meine beste Vermutung:* du meinst die Stufe. *Vorschlag:* Sprachregelung "Der
Hybrid fuegt eine **Stufe** hinzu, aber **keinen Typ** -- er IST eine Tier-Binary."

**F-4 -- Soll die Pinning-Faehigkeit als Mess-Achsen-Stufe-1 im Planer gebaut werden?**
Heute existiert nur die CEB-seitige `ScopedThreadPin` und ein opt-in `--pin-core` im
Auswertungswerkzeug (6.2). *Meine beste Vermutung:* ja, analog zu PMC, aber **nach der Abgabe** --
fuer die Messungen ab morgen genuegt der harte Ein-Thread-Modus je Lane. *Vorschlag:* als Bau-Posten
notieren, nicht in die laufende Welle ziehen.

**F-5 -- Trennen wir "PMC-Neubau" und "Observer-Neubau" im Fortpflanzungs-Gesetz?**
Dein Satz lautet "Mess-Achsen-Aenderung erzwingt CEB- UND Binary-Neubau". Fuer PMC gilt praezise:
**CEB neu, Tiers unberuehrt** (`experiment_plan_director.hpp:284-286`). *Meine beste Vermutung:* du
meinst das Gesetz als Obergrenze ("im Zweifel beides neu"). *Vorschlag:* wir fuehren im Bestandslog
zwei Klassen -- `CEB-ONLY` und `CEB+TIER` -- damit die Batch-Planung nicht unnoetig 4096 Tiers neu
baut, wenn nur ein CEB-Schalter kippt.

**F-6 -- Ist die Lesart (D) "drei Lauf-Phasen bau/pruef/mess" fuer dich mit im Spiel?**
Sie ist im Code belegt (`phase=bau|pruef|mess`), passt aber nicht auf "ZWEIPHASIG". *Meine beste
Vermutung:* nein, du meinst die Traeger. *Vorschlag:* wir benennen die Testat-Marke kuenftig
`schritt=bau|pruef|mess` statt `phase=`, damit das Wort "Phase" im ganzen System **nur noch** die
Kettenposition bezeichnet. Das ist ein reiner Grammatik-Rename mit CSV-/Marker-Wirkung, also
abstimmungspflichtig.

---

## Anhang: Nullbefunde dieses Dokuments, je mit Nenner und Gegenprobe

| Gesucht | Ergebnis | Nenner / Gegenprobe |
|---|---|---|
| `dreiphasig`/`zweiphasig` im SSOT-Ledger | **0** | Nenner 6735 Zeilen; Gegenprobe `zweistufig` → 10 Treffer |
| Owner-Wortlaut "3 Typen"/"drei Typen" im SSOT-Ledger | **0** | Nenner 6735 Zeilen; Gegenprobe `"Typ"` → **118** Treffer. **Der KERN ist neu und noch nicht im Ledger gebucht.** |
| dreiphasiger Gegenpart zur Zwei-Phasen-Op-Schleife (Z-7) | **0** | Nenner **5502** Dateien im ce-Baum (ohne `.git`); Gegenprobe `two_phase\|zwei-phasen\|zweiphasig` → **519** |
| Compiler-/Prozess-Start im Tier-Code | **0** bei **399** Dateien (`anatomy/`+`axes/`) | Gegenprobe: dasselbe Muster in `builder/` → **24** |
| Hybrid-Code | **0** Dateien ausser `README.md` | Gegenprobe: `libs/cache_engine/CMakeLists.txt` fuehrt 5 `add_subdirectory`, keines davon `hybrid` |
| Pinning im Planer-Verzeichnis | **0** bei **8** Dateien | Gegenprobe: `"PMC"` im selben Verzeichnis → `experiment_plan_director.hpp` |
| `dreiphasig` in `super:docs/` **vor dem 06.08.** | **0** | Nenner 3740 Dateien; alle 8 Treffer liegen in 5 Dateien, alle vom 06.08. und alle Ableitungen der Owner-Nachricht |
