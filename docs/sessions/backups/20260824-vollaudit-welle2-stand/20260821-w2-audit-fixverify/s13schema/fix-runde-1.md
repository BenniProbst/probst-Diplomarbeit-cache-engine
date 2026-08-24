# FIX-STUFE (A2.5) RUNDE 1 -- Strang s13schema

Fixer: Fable-max, 22.08.2026. Objekt: ce `bau/s13schema`, Worktree
/home/comdare/wt-ce-s13schema (HEAD vor Fix ad5c6d6645884e204366bf0a918cd73956f4c29c
== Audit-Tip, porcelain 0, selbst gemessen) + super `bau/s13schema`,
/home/comdare/wt-super-s13schema @ 1e92b77e3cbfdee1f8914382765d5fd20067c20a
(porcelain 0, in dieser Runde UNVERAENDERT -- beide Funde sind ce- bzw. Berichts-seitig).

Audit-Grundlage: /home/comdare/backups-workflow/20260821-w2-audit-fixverify/s13schema/audit-runde-1.md
(voll gelesen; 1 ERNST + 1 KLEIN).

NEUER TIP ce: c76d31164d7ffd5ffbb9f776e6839e7fc08114c7 (1 neuer Commit auf ad5c6d66).

--------------------------------------------------------------------------------

## QUITTUNGEN (dreiwertig, je mit EIGENEM Beleg)

### S13A-F1 (ERNST) -- Diff-Hygiene-Wache ROT: 8 Nicht-ASCII-Zusatzzeilen => **BEHOBEN**

**Rot-Beweis VOR Fix (echtes Rot, selbst gefahren am unveraenderten Tip ad5c6d66):**
`sh scripts/ci_diff_ascii_width_guard.sh "66de5c09..HEAD"` -> literal
"DIFF-HYGIENE-WACHE: ROT." mit Nenner "1091 Zusatzzeilen in selbst verfasstem Code
geprueft, davon 8 Nicht-ASCII, davon 0 ueber 120 Spalten", GUARD_RC=1; die 8 gemeldeten
Zeilen exakt die des Audits (experiment_run_entry.hpp:255/:263/:272/:563/:570,
profile_run_entry.hpp:799/:1543/:1549). Log persistiert:
`fixR1-rotbeweis-ascii-wache-vor-fix.log` (dieser Ordner).

**Fix (Commit c76d3116, "fix(s13/diff-hygiene): 8 Nicht-ASCII-Zusatzzeilen
ASCII-fiziert (Audit S13A-F1)", 2 Dateien, 12+/8-):**
1. 4 Kommentar-Zeilen ASCII-fiziert: exp:255 + exp:263 Box-Zeichen U+2500 -> `--`;
   exp:570 U+00D7 -> `x`; prof:1549 U+2014 -> `--`.
2. 2 neue FEHLER-Ausgaben (exp:272, prof:799): U+2192 -> ASCII `->` (nicht
   vertragstragend -- die super-Wache ankert nur "RUN_PROFILE fertig:"/"RUN_EXPERIMENT
   fertig:"-Zeilen, selbst verifiziert an ci/lauf_marker.sh: Anker-index()-Zeilen +
   felder()-Token-Parser, unbekannte Token ignoriert).
3. 2 fertig-Zeilen (exp, prof): PARSE-ANKER-erhaltende Escape-Loesung (Audit-Weg (a)):
   Roh-Pfeil im String-Literal durch die sechs ASCII-Zeichen Backslash-u-2192 ersetzt;
   dazu je 2 ASCII-Kommentarzeilen (Begruendung Escape statt Roh-Byte + Anker-Verweis
   ci/lauf_marker.sh PFEIL_UTF8). Die Escape-Loesung folgt exakt dem Projektmuster der
   Wache selbst (ci/lauf_marker.sh:116-117: "U+2192 aus Bytes -- ein literales Zeichen
   waere ein ASCII-Verstoss. PFEIL_UTF8=$(printf '\342\206\222')", selbst gelesen).
4. clang-format-22 (~/.local/bin/clang-format-22) ueber BEIDE Dateien: RC=0, Diff
   danach unveraendert 12+/8- (kein Umbruch; ColumnLimit 120 eingehalten).

**Byte-Beweis Ausgabe-Identitaet (PARSE-ANKER bleibt, eigener Beleg):**
- Quelltext-Bytes der exp-fertig-Zeile nach Fix (xxd, Z.565): `205c 7532 3139 3220` =
  Leerzeichen + `→` in purem ASCII (5C=Backslash, 75=u).
- Wegwerf-Probe /tmp/s13schema_pfeil_probe2.cpp: String-Literal " → " DIREKT AUS
  DER GEFIXTEN DATEI GESPLEISST (grep -o, keine Encoding-Zwischenschicht), Referenz als
  Zahlen-Array {0x20,0xE2,0x86,0x92,0x20,0}; static_assert byte-weise gleich ->
  g++ -std=c++23 RC=0 UND clang++ -std=c++23 RC=0; Laufzeit-Hexdump beider Binaries
  literal `20 E2 86 92 20`. NEGATIVKONTROLLE: static_assert(sizeof(" -> ") !=
  sizeof(Escape-Literal)) haelt -- der naive ASCII-Ersatz waere ein ANDERER String und
  haette den Anker gebrochen; genau darum Escape-Loesung. Log:
  `fixR1-byte-beweis-pfeil-escape.log`.
- Binaer-Probe am gebauten Artefakt: siehe Abschnitt BAU-TREPPE unten.

**Gruen-Beweis NACH Fix (selbst gefahren am neuen Tip c76d3116):**
`sh scripts/ci_diff_ascii_width_guard.sh "66de5c09..HEAD"` -> literal
"1095 Zusatzzeilen in selbst verfasstem Code geprueft, davon 0 Nicht-ASCII, davon 0
ueber 120 Spalten" + "DIFF-HYGIENE-WACHE: GRUEN.", GUARD_RC=0 (die +4 Zusatzzeilen sind
die 4 neuen ASCII-Kommentarzeilen). Log: `fixR1-ascii-wache-nach-fix-gruen.log`.

**Beide Mengen:** Geprueft = der ZUWACHS des Diffs 66de5c09..c76d3116 (1095 Zeilen, die
Wache selbst dokumentiert ihre Grenze: nicht der Bestand der Dateien -- Bestand traegt
weiterhin geduldete Nicht-ASCII-Zeilen aus der Vor-Wache-Aera, z.B. exp:248, unberuehrt
gelassen). Nicht Gegenstand: das kumulative CI-Gate gegen origin/main (erst am
Lande-Push messbar).

### S13A-F2 (KLEIN) -- Resume-Vertrag-Carve-out ohne Interpretations-Vermerk => **BEHOBEN**

**Eigener Beleg der Grundlage (nicht vom Audit abgeschrieben):** Design-Dokument
selbst nachgeschlagen -- /home/comdare/wt-super-s13schema/docs/plaene/
20260817-DESIGN-s13-buendel-di25.md Z.481-483 traegt woertlich "**Alternative, bewusst
NICHT gewaehlt:** Stamp/Resume auf die Mappe umstellen. ... Als W3-Nachfolgeposten
vermerkt." (sed -n '478,485p', selbst gelesen).

**Fix:** NACHTRAG-Satz an den LEDGER-ENTWURF-Block [S13-03 GEBAUT] des Strang-Berichts
angefuegt (/home/comdare/backups-workflow/20260820-w2-sofortstaffel/
s13-schema-kette-ergebnis.md, im ENTWURF-Block ab Z.145; neue Zeilen direkt nach der
bisherigen S13-03-Zeile "...Mess-Fenster-Punkt (deklariert)."): "NACHTRAG (Fix-Stufe R1,
Fund S13A-F2): der result.csv-Fortbestand ist eine Design-INTERPRETATION von KON32-01
(Betriebszustand, kein Auswerte-Format; Owner-Wortlaut 'ES WIRD NUR PER-BINARY-XLSX
GEBEN') mit OFFENER Owner-Feinabstimmung -- die Alternative (Resume auf die Mappe
umstellen) ist als W3-Nachfolgeposten in 20260817-DESIGN-s13-buendel-di25.md Z.481-483
vermerkt; nicht als glatt erledigt fuehren."

**Grenze (dem Fix-Weg gemaess):** Eintrag in den LEDGER selbst = Lead beim KON120-Zug;
weder Ledger noch Board noch Memory wurden von dieser Stufe geschrieben.

--------------------------------------------------------------------------------

## BAU-TREPPE gcc-Release (Slot-Protokoll, am neuen Tip c76d3116)

- df-Gate: `/dev/nvme0n1p2 251G 207G 32G 87% /` -> 32G frei > 5G. ERFUELLT.
- Slot-Protokoll: alle 3 Slots belegt vorgefunden (slot1-ph89audit.d, slot2.d,
  slot-cifix2) -> 60s-Warteschleife (Deckel 45 min), nach 5 Runden atomarer Claim
  `mkdir .../bauslots/slot1-s13schema.d` (wer-Datei hinein) um 06:41Z. KEIN Bau ohne
  Slot gefahren.
- J-0b: `cmake --preset gcc-release -DCOMDARE_CE_PRUEFLINGE=` -> "Build files have been
  written to: /home/comdare/wt-ce-s13schema/build/gcc-release", J0B_RC=0 (frischer Baum,
  build/ existierte nicht).
- J-1 SIEBEN Werkzeuge (comdare_adhoc_emitter_cli comdare_anatomy_codegen_cli
  comdare_axis_registry_gen comdare_catalog_codegen_cli
  comdare_measurement_axis_registry_gen comdare_overlay_source_hash_gen
  comdare_system_axis_registry_gen): "[53/54] Linking ... comdare-adhoc-emitter",
  J1_RC=0.
- RE-CONFIGURE: identischer Preset-Aufruf, RECONF_RC=0.
- STUFE all: "[2522/2523] Linking CXX executable tests/unit/test_s13_02_zielfilter_vier_faelle",
  ALL_RC=0 (Log: `fixR1-bautreppe-gcc-release.log`).
- STUFE Facade: der Treppen-Name `comdare_facade` existiert in diesem Baum nicht literal
  ("ninja: error: unknown target 'comdare_facade'", FACADE_RC=1 im Treppen-Log) -- der
  reale Facade-Target-Name ist `comdare_profile_run_facade` (STATIC, EXCLUDE_FROM_ALL;
  libs/cache_engine/profile_facade/CMakeLists.txt:82, selbst nachgeschlagen). Explizit
  gebaut: FACADE_REAL_RC=0 (inkl. "[overlay_source_hash_gen] 712 Dateien ... unveraendert").
  BEFUND fuer den Lande-Zug: die Treppen-Formel sollte kuenftig den realen Namen fuehren.
- STUFE comdare_tests: "[8/9] Linking CXX executable tests/unit/test_profile_roundtrip",
  TESTS_RC=0.
- STUFE ctest (voller Lauf, --no-tests=error):
  - Lauf 1 (in der Treppe, 06:45Z): CTEST_RC=0, "Total Test time (real) = 29.55 sec"
    (Bilanzzeile vom tail-8-Mitschnitt abgeschnitten -- deshalb Lauf 3 unten).
  - Lauf 2 (Wiederholung fuer die Bilanzzeile, unter Fremdlast der Nachbar-Slots,
    66.05 sec): "99% tests passed, 1 tests failed out of 513" -- EINZIGER Ausfall
    test_rcu (0.07 sec), Log `fixR1-ctest-voll.log`.
  - test_rcu-Triage (RCU-Nebenlaeufigkeits-Test, von diesem Fix-Diff UNBERUEHRT --
    der Diff traegt nur die 2 profile_facade-Header): 5 isolierte Wiederholungen
    NACHEINANDER je "100% tests passed, 0 tests failed out of 1", RC=0
    (Log `fixR1-test-rcu-wiederholungen.log`) => Last-Flake unter 3 parallelen
    Bau-Slots, kein Objekt-Defekt dieses Strangs. NACHBAR-BEFUND fuer den Lande-Zug/
    K17-Kombibau: test_rcu unter Parallel-Last beobachten (hy-a-Umfeld #103 TSan).
  - Lauf 3 (voller Lauf, Bilanz literal): **"100% tests passed, 0 tests failed out
    of 513"**, CTEST_LAUF3_RC=0, "Total Test time (real) = 29.79 sec"
    (Log `fixR1-ctest-voll-lauf3.log`). Nenner 513 == Audit-Konsistenzrechnung
    (Basis 510 + 3 s13-Tests).
- Binaer-Byte-Probe am gebauten Artefakt (LC_ALL=C): libcomdare_profile_run_facade.a
  traegt die Anker-Byte-Folge 20 E2 86 92 20 in **2** Treffer-Zeilen (RUN_PROFILE- +
  RUN_EXPERIMENT-fertig-Literal), tests/unit/test_s13_02_zielfilter_vier_faelle in **1**;
  "RUN_PROFILE fertig:"-Literal per strings 1x im Testbinary -- die Escape-Quelle
  emittiert die identischen Anker-Bytes bis ins gelinkte Artefakt.
- Slot nach ctest freigegeben: `rm -rf .../slot1-s13schema.d` RC=0 (Gegenprobe: Slot-Dir
  weg, Nachbar-Slots unangetastet).

--------------------------------------------------------------------------------

## REF-SICHERUNG

`git push -o ci.skip origin bau/s13schema` -> literal
"   ad5c6d66..c76d3116  bau/s13schema -> bau/s13schema", PUSH_RC=0; Gegenprobe
`git ls-remote origin refs/heads/bau/s13schema` = c76d31164d7ffd5ffbb9f776e6839e7fc08114c7
(KEINE Pipeline ausgeloest -- ci.skip).

--------------------------------------------------------------------------------

## VOLLZAEHLIGKEITS-GATE

2 Funde im Audit (S13A-F1 ERNST, S13A-F2 KLEIN) -- 2 Quittungen oben, beide BEHOBEN.
Keine weiteren Funde im Audit-Bericht (Abschnitt 3 endet nach F2; Abschnitt 4 =
getragene OFFENE Posten, ausdruecklich KEINE Funde, von dieser Stufe unberuehrt).

## GETRAGENE GRENZEN DIESER FIX-RUNDE (unveraendert aus dem Audit)
- T-11b 4-Zellen-Kombibau, T-8, H-6-Vollzug: Lande-Zug (diese Runde: 1 Zelle
  gcc-Release voll, s. Bau-Treppe).
- Reale CI-Ausfuehrung der Wachen: erst am Lande-Push messbar.
- super bau/s13schema bleibt @ 1e92b77e (LANDE-KOPPLUNG H-6 unveraendert deklariert).

--------------------------------------------------------------------------------

## WIEDERANLAUF-NACHTRAG R1-W (23.08.2026, additiv -- Bericht oben unveraendert)

GRUND: Die erste Inkarnation dieser Fix-Stufe riss nach Bericht-Schreibung ab, ohne ihr
Schema-Ergebnis an den Orchestrator zu uebergeben; dieser Wiederanlauf uebernimmt den
Stand (NIE verworfen) und quittiert mit EIGENEN Nachmessungen am unveraenderten Objekt.

STAND-AUFNAHME (selbst gemessen): ce-Worktree /home/comdare/wt-ce-s13schema HEAD =
c76d31164d7ffd5ffbb9f776e6839e7fc08114c7, porcelain 0; ad5c6d66 ist Vorfahr (merge-base
--is-ancestor: JA-VORFAHR). Origin-Ref selbst: ls-remote = c76d3116... (Ref-Sicherung
steht, kein neuer Push noetig -- kein neuer Commit in diesem Wiederanlauf). super-Worktree
/home/comdare/wt-super-s13schema HEAD = 1e92b77e3cbfdee1f8914382765d5fd20067c20a,
porcelain 0 (unveraendert). Audit-Runde 2 (audit-runde-2.md, 22.08. 06:56, voll gelesen)
hatte beide Quittungen bereits eigenstaendig BESTAETIGT (VERDIKT SITZT).

EIGENE NACHMESSUNGEN DIESES WIEDERANLAUFS (je literal):
1. ROT-Beweis unabhaengig reproduziert am HISTORISCHEN Bereich (nicht aus dem Log
   abgeschrieben): `sh scripts/ci_diff_ascii_width_guard.sh "66de5c09..ad5c6d66"` ->
   exakt die 8 Audit-Zeilen (exp 255/263/272/563/570, prof 799/1543/1549), Nenner
   "1091 Zusatzzeilen ... davon 8 Nicht-ASCII", "DIFF-HYGIENE-WACHE: ROT.", RC=1.
2. GRUEN-Beweis am Tip: `... "66de5c09..HEAD"` -> "1095 Zusatzzeilen in selbst
   verfasstem Code geprueft, davon 0 Nicht-ASCII, davon 0 ueber 120 Spalten",
   "DIFF-HYGIENE-WACHE: GRUEN.", RC=0. Beide Laeufe persistiert:
   `fixR1W-wiederanlauf-ascii-wache-rot-und-gruen.log` (dieser Ordner).
3. clang-format-22 (~/.local/bin/clang-format-22) --dry-run -Werror ueber beide
   Fix-Dateien: FMT_RC=0.
4. PARSE-ANKER-Byte-Beweis EIGENE Compile-Probe (/tmp, danach entfernt): Literal
   `" → "` per grep -o DIREKT aus der gefixten profile_run_entry.hpp gespleisst,
   static_assert byteweise gegen {0x20,0xE2,0x86,0x92,0x20,0x00} + Negativkontrolle
   sizeof(" -> ")!=sizeof(probe): g++ -std=c++23 RC=0 UND clang++ -std=c++23 RC=0,
   Laufzeit-Hexdump beider Binaries literal `20 E2 86 92 20 00`. Quelltext-Probe:
   exp:565 + prof:1545 tragen den Pfeil als sechs ASCII-Bytes `5c 75 32 31 39 32`
   (xxd, selbst); Roh-Pfeil-Byte-Treffer im DATEI-Bestand (17/19 je Datei) liegen
   saemtlich AUSSERHALB des Diff-Zuwachses (Wache-GRUEN deckt den Zuwachs; Bestand
   ist laut Wache-Kopf ausdruecklich nicht ihr Gegenstand, R2 1(f): Bestand sank).
5. F2-Nachtrag selbst gelesen: s13-schema-kette-ergebnis.md traegt "NACHTRAG
   (Fix-Stufe R1, Fund S13A-F2)" ab Z.160 (grep -n literal) mit allen Fix-Weg-
   Elementen; Quell-Verweis selbst nachgeschlagen: 20260817-DESIGN-s13-buendel-di25.md
   Z.481-483 "Alternative, bewusst NICHT gewaehlt: Stamp/Resume auf die Mappe
   umstellen ... Als W3-Nachfolgeposten vermerkt." Ledger/Board/Memory unberuehrt.
6. Kern-Literale aller persistierten fixR1-Logs gegengelesen (grep, je Treffer):
   Rot-Log "davon 8 Nicht-ASCII"+"ROT." · Treppen-Log Kopf "@ c76d3116" + ALL_RC=0/
   TESTS_RC=0/CTEST_RC=0 (+FACADE_RC=1 = dokumentierter Treppen-Formel-Befund) ·
   Lauf3-Log Kopf "Test project .../wt-ce-s13schema/build/gcc-release" + Bilanz
   "100% tests passed, 0 tests failed out of 513" + "Total Test time (real) =
   29.79 sec" · Flake-Log test_rcu ***Failed 0.07 sec (Lauf 2) · rcu-Wiederholungen
   5x "0 tests failed out of 1" · Byte-Log gcc+clang RC=0 + `20 E2 86 92 20`.

BAU-ENTSCHEID DIESES WIEDERANLAUFS (beide Mengen): build/gcc-release des Fixer-Vollbaus
ist inzwischen GERAEUMT (ls: kein Verzeichnis; df 94%, 16G frei > 5G-Gate). KEIN
Re-Vollbau gefahren: der Objektstand ist byte-identisch derselbe HEAD c76d3116, an dem
die volle Treppe + 513/513-Bilanz bereits literal erhoben, persistiert (Beweisort,
gesicherte Kopien) und von Audit R2 eigenstaendig bestaetigt wurden (inkl. eigener
6/6-ctest-Stichprobe am damals stehenden Baum); ein Wiederholungsbau desselben Stands
belastete nur den mit dem laufenden Kombibau geteilten 3er-Slot-Deckel (Aufraeum-Modus
22.08.). GEDECKT durch diesen Wiederanlauf: Wache ROT->GRUEN, Format, Anker-Bytes
(gcc+clang), F2-Text, Log-Gegenlesen, Refs/porcelain. NICHT GEDECKT durch eigenen
Frischlauf: ctest-513er-Neulauf am neu gebauten Baum -- Traeger: K17-Endstand-Kombibau
am GEMERGTEN Lande-Stand (wie von R1/R2 deklariert). LOG-GRENZE (ehrlich): J-0b/J-1/
RECONF/FACADE_REAL-RCs stehen als Literale im Bericht oben (Terminal-Erhebung des
Fixers), im Treppen-Log liegen Kopfstempel + ALL/FACADE/TESTS/CTEST-RCs.

QUITTUNGEN UNVERAENDERT: S13A-F1 BEHOBEN · S13A-F2 BEHOBEN (2/2, Vollzaehligkeits-Gate
gehalten; 0 VERTAGT).
