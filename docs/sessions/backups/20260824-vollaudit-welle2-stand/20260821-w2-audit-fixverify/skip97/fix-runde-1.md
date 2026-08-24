# FIX RUNDE 1 -- skip97 (#97/E-12: C-13 Skip-Oekonomie + C-14 Bestandslog-SKIP-Wache)

Fix-Stufe: Fable-max (A2.5, Runde 1). Datum: 2026-08-22.
Objekt: ce `bau/skip97` -- Worktree `/home/comdare/wt-ce-skip97` (per `git worktree list` gefunden),
HEAD bei Uebernahme `100c32d2a98d2cc7698e2ecd353f1b10b2d0e56a` == Audit-Tip, `git status --porcelain`
0 Zeilen (kein fremder dirty-Stand; nichts verworfen), `build/` nicht vorhanden.
NEUER TIP nach Fix: **`1c9f58a5`** (voll `1c9f58a503f4281006948fa0dbcbe05ede215c25`), Parent 100c32d2,
3 Dateien, `187 insertions(+)`, Trailer-Schlusszeile exakt
`Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>`.
Ref-Sicherung: `git push -o ci.skip origin bau/skip97` -> literal `100c32d2..1c9f58a5`;
Gegenprobe `git ls-remote origin refs/heads/bau/skip97` = `1c9f58a503f4281006948fa0dbcbe05ede215c25`.

Eingang: Audit-Bericht audit-runde-1.md (312 Z., VOLL gelesen) + eigene Objekt-Erhebungen (alle
Belege unten selbst erhoben, nicht vom Audit abgeschrieben).

## 1. QUITTUNGEN (dreiwertig, je mit EIGENEM Beleg)

### S97-F1 (MILD) -- T-6-Schwester: unbewachte Mess-Presence-Naht => **BEHOBEN** (Weg 2, kleiner Bau)

**Eigene Befund-Reproduktion (unabhaengig vom Audit):**
- Strang-Bericht skip-oekonomie-97-ergebnis.md Z.151-152 (T-Vertrags-Zeile) zaehlt woertlich
  "T-1 ROT zuerst ..., Nenner fremd (beide Tests), Gegeneingang (beide), T-7-Registrierung
  Dateiende, T-11c 3 Wegwerf-Mutationen einzeln ROT" -- **T-6 fehlt** in der Aufzaehlung
  (selbst gelesen).
- Schwester am Objekt selbst verifiziert: `MesswertRunState::lager_contains` sass bei Uebernahme
  auf messwert_registrierung.hpp:121, Docstring woertlich "Lesender Zugriff fuer eine
  Mess-Presence-Naht (war diese Zelle schon gemessen?)", OHNE Leer-Zellen-Wache (Code gelesen:
  direkt `lager_key_from_hex(key_hex, zelle)` -- leer-vs-leer matcht, `LagerKey`-Vergleich).
- 0 Produktions-Aufrufer selbst gemessen: `git grep lager_contains` ueber libs/apps/tools ohne
  die vier bestandslog-Header liefert ausschliesslich Kommentar-Zeilen der BINARY-Seite
  (planer_driven_build.hpp:53, cache_engine_builder_iterator.hpp:305/2315/2320,
  profile_run_entry.hpp:943); `git grep "mess_lager\.lager_contains"` = 0 Zeilen Ausgabe.
  Kein lebender Defekt -- aber GOAL VI.4 (SKIP "fuer Messdaten UND Binaries") + Designplan-T-6
  ("beide Genera") machen die Naht doktrinaer und die Luecke zur Pflicht (Memory:
  LUECKE = BEHEBUNG PFLICHT).

**Fix (Weg 2 des Audits -- gewaehlt, weil nur er einen T-1-beweisbaren Objekt-Fix liefert;
Weg-1-Kartenanteil zusaetzlich in Abschnitt 4):**
1. NEU `tests/unit/test_c14_messwert_presence_wache.cpp` (157 Z.) -- Spiegel von
   test_c14_lager_presence_wache auf `Genus::measurement`: (a) Koeder kollabierter
   Leer-Zellen-Bestand + leere Lauf-Zelle, (b) Gegeneingang, (c) Tupel-Schaerfe beide
   Richtungen, (d) Nenner fremd (testlokale `keys`-Liste). T-11c-Koeder-Form: Vorbedingungen
   `ASSERT_EQ(st.lager_size(), 3)` + 3x `ASSERT_EQ(st.observe(..., kZelleLeer, ...),
   MesswertOutcome::lager_hit)` -- observe ist der rohe, unbewachte Index-Weg dieses Genus und
   beweist, dass das Leer-Tupel im Index MATCHT (der Koeder KANN beissen; bleibt auch NACH dem
   Fix gueltig, weil die Wache nur lager_contains deckt).
2. **T-1 ECHTES ROT ZUERST** am unbewachten Stand (staerkste Form, kein Wegwerf-Mutant noetig):
   Log `fix1-schwester-c14m-ROT.log` -- literal `[  FAILED  ]
   C14MesswertPresenceWache.KoederKollabierterLeerZellenBestandSkipptNie` mit **3x**
   "leere Lauf-Zelle begruendete einen Mess-SKIP fuer Kennung 0/1/2" (grep -c = 3), im SELBEN
   Lauf `[       OK ] ...GegeneingangBelegteZelleBleibtTreffer` und `[       OK ]
   ...TupelSchaerfeBeideRichtungen` (nur leer-vs-leer biss -- exakt die Signatur des
   Binary-C-14-ROT-Laufs), `1 FAILED TEST`, `0% tests passed, 1 tests failed out of 1`,
   `CTEST RC=8`.
3. Wache eingezogen: messwert_registrierung.hpp, jetzt Z.135 (Funktion Z.134):
   `if (zelle.empty()) return false; // C-14-Schwester: leere Lauf-Zelle ist NIE ein Beleg (s. oben)`
   VOR `lager_key_from_hex`, + 14 Kopf-Kommentar-Zeilen inkl. Platzierungs-Abwaegung und
   Marke der KON3-06-Klasse (KEIN Ledger-Zeilenverweis; Anker-Ratsche #500 am Endstand gruen,
   s.u.).
4. GRUEN: `fix1-schwester-c14m-GRUEN.log` -- literal `100% tests passed, 0 tests failed out
   of 1`, `CTEST RC=0`.
5. T-7: CMakeLists-Block ans DATEIENDE (tests/unit/CMakeLists.txt Z.7611-7626 = letzte Zeile
   7626; comdare_add_test + Include-/Link-Satz wie test_c14_lager_presence_wache).
6. clang-format-22 (`Ubuntu clang-format version 22.1.8`) ueber beide Lint-Dateien: 0
   Umformatierungen (Diff-Stat vor/nach identisch). ASCII: ganzer Patch 0 Treffer, +Zeilen 0
   Treffer (`git show 1c9f58a5 | grep -cP '[^\x00-\x7F]'` = 0).
7. Endstand-Vollbau: **513/513 ctest RC=0** (Abschnitt 2), neuer Test literal
   `513/513 Test #513: test_c14_messwert_presence_wache ... Passed`.

### S97-F2 (KLEIN) -- J-1-Treppe im Strang-Bericht mit 6 statt 7 Werkzeugen => **BEHOBEN** (korrektes Sieben-Protokoll liegt jetzt am Objekt-Strang)

**Eigene Befund-Reproduktion:** Strang-Bericht Z.104-106 selbst gelesen -- die J-1-Liste nennt
genau 6 Werkzeuge, `comdare_overlay_source_hash_gen` fehlt. Mitigation ebenfalls selbst
verifiziert: Original-Endstand-Log Z.2-3 literal "[1/660] comdare E-E: Overlay-Quell-Hash ...
[overlay_source_hash_gen] 712 Dateien, 3420405 Bytes, ... (unveraendert)" -- der 7. Generator
lief im Vollbau; kein falsches Gruen in jenem Lauf (ctest dort 512/512).

**Behebung durch diese Runde:** Der Protokoll-Mangel ist geheilt -- diese Fix-Runde fuhr die
J-1-Treppe am Objekt MIT ALLEN SIEBEN WerkzeUGEN ausgeschrieben und protokolliert sie hier
literal: `cmake --build build/gcc-release --target comdare_adhoc_emitter_cli
comdare_anatomy_codegen_cli comdare_axis_registry_gen comdare_catalog_codegen_cli
comdare_measurement_axis_registry_gen comdare_overlay_source_hash_gen
comdare_system_axis_registry_gen` -> **J-1 RC=0** (Log `fix1-j1-werkzeuge.log`, 54 Targets).
Damit existiert fuer den Strang skip97 ein vollstaendiges Sieben-Protokoll mit Beweis-Log.
Der K17-Lande-Zug faehrt die Sieben-Treppe am Merge-Endstand ohnehin als REGELN-Pflicht
(kein offener Rest DIESES Fundes; Lande-Vermerk-ENTWURF in Abschnitt 5).

### S97-F3 (KLEIN) -- Lauf-1-Rot (Anker-Ratsche) ohne gesicherte Log-Kopie => **ENTLASTET** (Rot-Zustand ist Geschichte; Objekt-Beweis dreifach EIGENSTAENDIG erhoben)

**Eigene Belege (nicht vom Audit abgeschrieben):**
- (a) Marke literal selbst gegriffen: test_c14_lager_presence_wache.cpp:3 traegt
  "(KON3-06, Messung 09.08.2026)".
- (b) `git show 100c32d2 | grep -c '^+.*Ledger[[:space:]]*:[[:space:]]*[0-9]'` = **0** Treffer
  (das exakte Muster des Ratschen-Tests, selbst am Erkenner test_anker_marke_statt_ledgerzeile.cpp
  nachgelesen: Wort + optionaler Leerraum + ':' + optionaler Leerraum + Ziffer).
- (c) Frischer, EIGENER Lauf dieser Runde: `500/513 Test #500:
  test_anker_marke_statt_ledgerzeile ... Passed` (fix1-endstand.log:3569) -- die Ratsche ist
  auch ueber die NEUEN Dateien dieser Runde gruen.
- Zusatz-Gegenprobe am gesicherten Original-Log: skip97-endstand.log Z.1014 "500/512 ...
  Passed", Z.1040 "100% tests passed, 0 tests failed out of 512", Z.1297 "ENDSTAND-ENDE RC=0".
- Beweis-Ordner selbst gezaehlt: exakt 10 Dateien unter skip-oekonomie-97-beweise/ (alle Namen
  gelistet); ein Lauf-1-Rot-Log ist nicht darunter -- der Audit-Befund stimmt, der Rot-Zustand
  ist aber Geschichte und ohne Nachstellen (das der Audit-Fix-Weg ausdruecklich ausschliesst)
  nicht reproduzierbar. Kein behebbarer Defekt am Objekt.

**Prozess-Vollzug in DIESER Runde:** alle Rot-Laeufe dieser Runde sind als Kopie persistiert
(fix1-schwester-c14m-ROT.log), keine Neben-Rot-Luecke wiederholt. Prozess-Notiz-ENTWURF fuer
kuenftige Straenge in Abschnitt 5.

**Vollzaehligkeits-Gate: 3/3 Fund-IDs quittiert (F1 BEHOBEN, F2 BEHOBEN, F3 ENTLASTET; 0 VERTAGT).**

## 2. BAU-PROTOKOLL (Slot-Doktrin + Treppe, alle RCs literal)

- Slot: atomar `mkdir ~/.claude/jobs/5a19728e/tmp/bauslots/slot1-skip97-fix1.d` -> "SLOT=1
  genommen" (wer-Datei geschrieben); df-Gate: `/dev/nvme0n1p2 ... 31G frei` (>5G). Nach ctest
  per `rm -rf` freigegeben ("SLOT1 FREIGEGEBEN", 2 fremde Slots verblieben belegt).
- J-0b: `cmake --preset gcc-release -DCOMDARE_CE_PRUEFLINGE=` -> RC=0 (fix1-j0b-configure.log).
- J-1: SIEBEN Werkzeuge (Liste in Abschnitt 1/F2) -> RC=0 (fix1-j1-werkzeuge.log).
- RE-CONFIGURE: RC=0 (fix1-reconfigure.log).
- ROT (vor Wache): Bau des neuen Targets RC=0, `ctest -R '^test_c14_messwert_presence_wache$'`
  -> RC=8, 1 FAILED (fix1-schwester-c14m-ROT.log).
- Wache + clang-format-22 (0 abweichend), dann GRUEN: RC=0 (fix1-schwester-c14m-GRUEN.log).
- Vollbau (fix1-endstand.log): `all` -> **ALL RC=0** (2513 Targets) -> Facade -> `comdare_tests`
  -> **TESTS-TARGET RC=0** -> `ctest --no-tests=error` -> literal
  **"100% tests passed, 0 tests failed out of 513"**, **CTEST-VOLL RC=0** (Z.3597/3855).
  Schluessel-Zeilen: #500 Passed (Z.3569), #511 test_c14_lager_presence_wache Passed,
  #512 test_c13_selektiver_rebuild Passed, #513 test_c14_messwert_presence_wache Passed.
- FACADE-KLAERUNG (Treppen-Abweichung, deklariert): `ninja: error: unknown target
  'comdare_facade'` (FACADE RC=1) -- ein Target dieses NAMENS existiert im ce-Baum nicht;
  `ninja -t targets` weist als reales Facade-Target `comdare_profile_run_facade`
  (libs/cache_engine/profile_facade, Teil von `all` und damit vom ALL-RC=0 bereits gedeckt).
  Expliziter Nachbau: **FACADE-REAL RC=0** (Log-Nachtrag). Auch das Original-Strang-Endstand-Log
  enthaelt keinen comdare_facade-Schritt (grep leer) -- der REGELN-Name ist an diesem Objekt
  ein Alias-Geist; Treppe sachlich vollstaendig erfuellt.

## 3. PLATZIERUNGS-ABWAEGUNG (vom Auftrag geforderter Abschnitt)

Die Binary-Seite (C-14, gelandet in 100c32d2) bewacht BEWUSST die NAHT `make_lager_presence`
und NICHT das rohe `LagerRunState::lager_contains` -- der dortige Koeder-Test ASSERTet das rohe
Tupel (`ASSERT_TRUE(st.lager_contains(hexkey('x'), kZelleLeer))` 3x, test_c14:115-117): das rohe
Tupel-Verhalten ist dort VERTRAGLICH sichtbar und muss erhalten bleiben. Im MESS-Genus liegt der
Fall anders: `MesswertRunState::lager_contains` ist laut eigenem Docstring AUSSCHLIESSLICH der
"Lesende Zugriff fuer eine Mess-Presence-Naht" -- die Funktion IST die (kuenftige) Naht, einen
zweiten Konsumenten des rohen Tupels ueber sie gibt es nicht (0 Aufrufer, eigene Messung oben).
Die Wache direkt an ihr ist deshalb die exakte Entsprechung der Binary-Platzierung ("an der
Naht, an der der SKIP begruendet wird"), nicht deren Bruch. Der rohe Index-Weg dieses Genus
bleibt `observe()` (unveraendert; lager_hit-Dedup ueber das unbewachte Tupel) -- er dient dem
neuen Koeder als Beiss-Vorbedingung und ist der verbleibende Karten-Posten (Abschnitt 4). Wer
kuenftig die strenge Struktur-Symmetrie (Wache erst in einer separaten Naht-Funktion) will,
verschiebt die eine Zeile beim Verdrahten der Naht -- der Test bindet an das VERHALTEN
(lager_contains(hex, leer) == false), nicht an die Platzierung.

## 4. T-6-SCHWESTER-KARTE (Weg-1-Anteil; ENTWURF fuer Findings-Register/Lande-Zug -- Lead-only-Schreibung beachtet)

Deklarierte Schwesterstellen der KON3-06-Klasse (Stand 1c9f58a5):
1. `messwert_registrierung.hpp:134` MesswertRunState::lager_contains -- **BEWACHT** (diese
   Runde, Z.135; Beweis test_c14_messwert_presence_wache, ROT->GRUEN).
2. `lager_presence.hpp` make_lager_presence (Binary-Genus) -- BEWACHT (100c32d2, #97-Kern).
3. **OFFEN, F-106-analog, derselbe Traeger "Folge-Zug Planer-/Orchestrierungs-Seite":**
   observe-Schreiber-Duo `cache_engine_builder_iterator.hpp:2303` (lager.observe mit
   cfg.bestand_zelle) und `:3186` (mess_lager.observe mit cfg.bestand_zelle) registrieren bei
   leerer Lauf-Zelle weiterhin Leer-Zellen-Eintraege (perpetuieren den kollabierten Bestand;
   nach C-14 + Schwester fuer BEIDE Skip-/Presence-Pfade inert, im Mess-Genus dedupliziert
   observe verschiedene Matrix-Zellen unter derselben leeren Kennung). KEINE Skip-Entscheidung
   -- kein Bau in dieser Runde; beim Verdrahten der Mess-Presence-Naht ist die Schreiber-Frage
   mit zu entscheiden. ENTWURF Registerzeile: "F-1xx [OFFEN] observe-Leer-Zellen-Schreiber
   beide Genera (iterator:2303/:3186) -- Traeger: Folge-Zug Planer-/Orchestrierungs-Seite
   (mit F-106); Wache/Politik beim Naht-Verdrahten, Schwester-Karte fix-runde-1.md skip97."

ENTWURF Ledger-Zeile (fuer KON-Zug an der Landung, Lead): "S97-F1 BEHOBEN via Weg 2:
Mess-Genus-Schwester der C-14-Wache gebaut (ce 1c9f58a5, messwert_registrierung.hpp:135 +
test #513, echtes T-1-Rot 2026-08-22, Endstand 513/513); observe-Duo als OFFEN-Posten an
F-106-Traeger deklariert."

## 5. VERMERK-ENTWUERFE FUER DEN K17-LANDE-ZUG

- J-1-SIEBEN-PFLICHT (aus S97-F2): am Merge-Endstand die J-1-Treppe mit allen SIEBEN Werkzeugen
  fahren und die Liste im Lande-Protokoll AUSSCHREIBEN (comdare_adhoc_emitter_cli,
  comdare_anatomy_codegen_cli, comdare_axis_registry_gen, comdare_catalog_codegen_cli,
  comdare_measurement_axis_registry_gen, comdare_overlay_source_hash_gen,
  comdare_system_axis_registry_gen). CAVE dieser Runde: das Treppen-Target "comdare_facade"
  existiert im ce-Baum nicht -- reales Target `comdare_profile_run_facade` (in `all` enthalten).
- Prozess-Notiz (aus S97-F3): AUCH Neben-Rots (Ratschen-/Hygiene-Laeufe) als Log-Kopie in den
  Beweis-Ordner sichern, nicht nur T-1-/T-11c-Rots.
- ctest-Endstand-Soll des Zweigs ist mit dieser Runde **513** (vorher 512); die
  H-7-Floor-/Nenner-Rechnung des Lande-Zugs den +1 mitzaehlen (Zaehlwerke EINMAL live).
- H-9-Lande-Zeile fuer skip97 lautet jetzt: `bau/skip97 @ 1c9f58a5` (nicht mehr 100c32d2).

## 6. BEWEIS-DATEIEN DIESER RUNDE (gesicherte Kopien, /home/comdare/backups-workflow/20260821-w2-audit-fixverify/skip97/)

| Datei | Inhalt (Kern-Literal) |
|---|---|
| fix1-j0b-configure.log | J-0b RC=0 |
| fix1-j1-werkzeuge.log | J-1 SIEBEN Werkzeuge RC=0 (54 Targets) |
| fix1-reconfigure.log | RE-CONFIGURE RC=0 |
| fix1-schwester-c14m-ROT.log | Koeder FAILED 3x "Kennung 0/1/2", Gegeneingang+TupelSchaerfe OK, CTEST RC=8 |
| fix1-schwester-c14m-GRUEN.log | 100% tests passed, 0 failed out of 1, CTEST RC=0 |
| fix1-endstand.log | ALL RC=0 · TESTS-TARGET RC=0 · "100% tests passed, 0 tests failed out of 513" · CTEST-VOLL RC=0 · FACADE-Klaerung + FACADE-REAL RC=0 · #500/#511/#512/#513 Passed |

## 7. MENGEN-DEKLARATION (EIN GRUENES GATE deckt nur seinen Gegenstand)

Alle Gruen-Aussagen dieser Runde gelten der Menge "Einzelzweig bau/skip97 @ 1c9f58a5,
gcc-Release, 513 ctest-Faelle, 3 Fix-Diff-Dateien (+187)". NICHT gedeckt und ausdruecklich beim
Lande-Zug: gemergter Endstand (W2-Gesamt-Soll), 4-Zellen-Kombibau gcc+clang x Release+Debug,
CI-Lauf (Push erfolgte mit ci.skip per Order), V-5-DUAL-WEG. TABU-Gate dieser Runde: 3
Diff-Dateien liegen unter libs/cache_engine/builder/bestandslog/ + tests/unit/ -- nichts unter
axes/ topics/ heuristik/, keine golden-Datei, kein .gitlab-ci.yml; CMakeLists-Aenderung NUR am
DATEIENDE (Z.7611-7626 von 7626).
