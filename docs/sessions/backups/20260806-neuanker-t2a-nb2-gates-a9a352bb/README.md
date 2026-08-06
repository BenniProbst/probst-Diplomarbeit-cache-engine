# T2-A NB + NB2 -- Gate-Belege des OPUS-ZWEIT-REVIEWS (HEAD a9a352bb)

Angelegt am 2026-08-06 (nachmittags) durch den adversarialen Zweit-Review der T2-A-Serie.
Alle Zahlen in diesem Ordner stammen aus **eigenen Laeufen des Reviews**, nicht aus dem
Bau-Bericht.

Zur ASCII-Doktrin, praezise: die vom Review **verfassten** Dateien (diese README, die drei
`.txt`-Belege, die drei `.cpp`-Sonden) sind ASCII-only -- nachgemessen, 0 Bytes > 0x7F. Die
**Roh-Logs** sind es nicht: `conf1/conf2.log` (1441 Bytes) und `make1.log` (4758 Bytes) tragen
die Unicode-Trennlinien von CMake bzw. make. Das ist unveraendertes Werkzeug-Ausgabe-Material
und **byte-gleich zur Vorwelle** (`20260806-neuanker-teil2/gates/t2a-gesamt-configure1.log`
und `-vollbau.log` haben exakt dieselben Zahlen). Die Doktrin greift fuer Code und Kommentare,
nicht fuer mitgeschnittene Fremd-Ausgaben -- der Punkt steht hier, damit niemand die Zahl fuer
einen Befund haelt.

## Warum es diesen Ordner gibt

Der Spiegel `20260806-neuanker-teil2/gates/` enthaelt die Gate-Logs der T2-A-Serie **nur bis
zum Stand `3a42bf90`** -- alle Dateien dort tragen den Zeitstempel 11:32, und ihre ctest-Logs
sagen literal `out of 408`. Fuer die beiden Folge-Wellen lag **kein einziges Log** im Spiegel:

* **NB-Welle** `511671c9 .. 6c300e68` (Indexfolge-Digest v2, Multi-Writer-tmp, `|fpr=`-Haertung,
  Provider-Einmal-Lesen, F1-Spiegel)
* **NB2-Welle** `3a88eb88` und `a9a352bb` (Push-Drain-Barriere, Mess-Front als Praefix,
  `plan_bau_digest`, Korn-Quelle, Status-Leser gegen die Format-Generation)

Der Zweit-Review hat die fehlenden Belege beim Nachmessen ohnehin erzeugt; sie liegen hiermit
im Spiegel. Die Zahlen des Bau-Berichts waren dabei **richtig** -- es fehlte die Ablage, nicht
die Substanz.

## ACHTUNG: VERWECHSLUNGSGEFAHR

Es gibt einen zweiten Ordner mit sehr aehnlichem Namen:

    docs/sessions/backups/20260806-neuanker-nb2/

**Der gehoert NICHT zu dieser Welle.** Er stammt von 06:34 desselben Tages und belegt die
**C-7/NB2**-Welle der Neuanker-Format-3-Linie gegen den Vor-Stand `77095354` -- ein anderes
Objekt, eine andere Fragestellung (Toolchain-Glied `[5]`, `tc=1;cxx=gcc:g++-16@1.0.0c`), eine
andere ctest-Bezugsgroesse (`out of 405`). Wer T2-A-NB2 sucht, ist **hier** richtig; das
Unterscheidungsmerkmal ist der HEAD im Ordnernamen (`a9a352bb`).

## Objekt und Umfang

| | |
|---|---|
| Worktree | `/home/comdare/wt-b2-neuanker` |
| Branch | `b2-neuanker-format3` |
| HEAD | `a9a352bb8b62eece20b19fc25a38667d1f100c40` |
| Gesamtserie | `a6a6875b..a9a352bb` = 12 Commits |
| Working Tree beim Messen | sauber (`git status --porcelain` leer) |
| Bau-Baum | `build/nb2-gate`, alle Laeufe `nice -n 10`, ctest **seriell** (ohne `-j`) |
| Sicherung | `rescue/t2a-nb2-komplett-a9a352bb` auf **beiden** Remotes |

## Welches Log was belegt

| Datei | Belegt |
|---|---|
| `gates/conf1.log`, `gates/conf2.log` | 2-Pass-Configure, je `CONF*_RC=0` (letzte Zeile) |
| `gates/make1.log` | Voll-Bau `make -j 8` (all), 0 Zeilen `error:`, `MAKE_RC=0` |
| `gates/make2.log` | Zusatz-Target `comdare_tests`, 0 Zeilen `error:`, `MAKE2_RC=0` |
| `gates/ctest1.log`, `gates/ctest2.log` | **zwei serielle ctest-Laeufe, je `100% tests passed, 0 tests failed out of 409`** |
| `gates/tsan.log` | dieselbe Nebenlaeufigkeits-Sonde unter ThreadSanitizer: **0 Warnungen, exit 0** |
| `gates/SONDEN-AUSGABEN.txt` | die Ausgaben aller vier Sonden literal (Frozen-Vektor, Digest-Bindung, Push-Barriere, `offen`-Befund) |
| `gates/DOPPELLAUF-LITERALE-T2A-NB2-ZWEITREVIEW.txt` | die Kennzahlen gebuendelt, im Format der uebrigen Wellen |
| `gates/T2A-NB2-STOP-GATE-TABU-FROZEN-ZWEITREVIEW.txt` | Frozen-Fixtures blob-identisch, TABU 0/0, ASCII 0, Spalten-Gate je Commit |
| `gates/frozen-sonde.cpp` | Quelle der Frozen-Nachmessung (uebernommen aus der Vorwelle, unveraendert) |
| `gates/review-sonde-digest-und-pump.cpp` | Quelle: `plan_bau_digest`-Bindung + `AsyncPushPump::drain` (8 Pruefpunkte) |
| `gates/review-sonde-offen-ignoriert.cpp` | Quelle: Beweis, dass der Plan-Resume `PlanFach::offen` ignoriert |

**Bewusst NICHT abgelegt:** die kompilierten Sonden-Binaries (`sonde`, `probe`, `probe_tsan`,
`probe2`, zusammen ~1,1 MB). Sie sind aus den drei `.cpp` reproduzierbar -- die Include-Pfade
stehen in `20260806-neuanker-teil2/gates/incdirs.txt`, mit `/build/gate/` -> `/build/nb2-gate/`
ersetzt. Uebersetzt wurde mit `g++-15 -std=c++23` (`-O1 -pthread`, fuer TSAN zusaetzlich
`-g -fsanitize=thread`).

**Credential-Pruefung vor der Ablage:** alle Logs gegen `glpat-`/`gldt-`/`AKIA...`/`ghp_`/
`github_pat_`/`xox*`/PEM-Header und gegen `password|secret|token|credential|MINIO_|AWS_SECRET|_KEY=`
geprueft -- **0 Treffer**. Kein Log schuettet Umgebungsvariablen aus; enthalten sind nur
Compiler-Kommandos, Testnamen und Pfade unter `/home/comdare/`.

## Kernzahlen

    2-Pass-Configure   : CONF1_RC=0 / CONF2_RC=0
    Voll-Bau           : 0 "error:" (all) / 0 "error:" (comdare_tests)
    ctest Lauf 1       : 100% tests passed, 0 tests failed out of 409
    ctest Lauf 2       : 100% tests passed, 0 tests failed out of 409
    Label golden|roundtrip : 12/12
    Frozen-Preimage    : 560 Bytes
    Frozen-Digest (RT) : 17148e5a4d0f4a2d96e1f5ad97dc4c727b99fce6e38bd6e337fb6dbf0e4461f9
                         b7fd37fbba76414be4718ad2180deecbb14387293935a8eff1469cef8ce89374
    Frozen-Fixtures    : alle drei blob-identisch ueber die GANZE Serie
    TABU (Dateien/Werte): 0 / 0
    Nicht-ASCII        : 0 (bei 3310 Zusatzzeilen)
    ThreadSanitizer    : 0 Warnungen

`409` statt der `408` des alten Spiegels: die NB-Welle hat **eine** neue TU beigetragen
(`test_t2a_f4_facade_plan_durchreichung`). Der Frozen-Vektor wurde **nicht** aus dem Test
uebernommen, sondern ueber den Laufzeit-Weg gegen die Header des HEAD-Baums neu uebersetzt.

## Bekannte Abweichung: Spalten-Gate

Die Gesamtserie haelt die Zusage "Zeilen > 120 Spalten: 0" **nicht vollstaendig**. Es sind
**zwei** Zeilen, beide aus `faa525d7` (dem ersten Commit der Serie), beide in
`libs/cache_engine/profile_facade/profile_run_entry.hpp`:

* `:989` -- 131 Zeichen (`? a.compile_for_perm(opt_flag, march_flag, perm_zellwerte, perm_toolchain_glied)`)
* `:1080` -- 122 Zeichen (`perm_bau_je_zelle ? ...compose_system_version_suffix(perm_parts)`)

`ColumnLimit: 120` steht in `.clang-format:9`. **Alle elf spaeteren Commits sind sauber**, ihre
je eigenen "0"-Zusagen stimmen also; unvollstaendig ist nur die Zusage ueber den Gesamtbereich.
Kosmetisch, nicht verhaltensrelevant -- hier festgehalten, damit der Posten nicht verloren geht.
Geheilt wird er an anderer Stelle.

## Mess-Falle, die hier zugeschlagen hat

`/usr/bin/grep` ist auf diesem Host **ugrep**. Das verbreitete Muster

    git diff ... | grep '^+' | grep -v '^\+\+\+' | grep -P '[^\x00-\x7F]'

bricht dort mit `ugrep: error: error at position 5 ... invalid syntax` ab -- und die Kette liefert
danach eine **stille 0**, also ein falsches Gruen fuer jedes ASCII-Gate, das so gemessen wird.
Die Zahlen in diesem Ordner sind deshalb byteweise in Python erhoben (mit der Zahl der
Zusatzzeilen als Bezugsgroesse, damit eine leere Messung sofort auffaellt). Wer Gate-Zahlen aus
einer grep-Kette meldet, sollte auf diesem Host `stderr` mitlesen.
