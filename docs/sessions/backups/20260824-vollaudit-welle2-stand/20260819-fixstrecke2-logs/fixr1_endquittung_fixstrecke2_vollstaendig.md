# END-QUITTUNG FIX-STRECKE 2 (A2.5, #15-Bump-Bruch) -- VOLLSTAENDIGE FASSUNG

Nachtrag Fix R1, persistiert 19.08.2026. Ersetzt die trunkiert uebermittelte Quittungskette des Verify-R1-Auftrags.
Worktree /home/comdare/wt-ce-bump15, Branch bau/bump15-preimage-bruch.
Basis e285d316 (= Tip Vorstrecke r2, 30 Commits auf ce/development 20c111c4; rev-list --count 20c111c4..e285d316 = 30).
Strecken-Tip 8cd32a0d (18 Commits, alle Praefix fix(a25-f2)). KEINE Pushes, KEINE Landung erfolgt.

## 0. DEKLARATION (F4 / C-3a)

#38a2 -> W2-Bump-Buendel mit Freeze-Nachbuchung, deklariert 19.08.

Der Wellenplan traegt bislang die aeltere Fassung (#38a2 Bump-Buendel, Fallregel 18.6(3), Timing-Deklaration)
ohne W2-/19.08.-Nachbuchung; die Zeile oben IST die Nachbuchung und ist mit diesem Dokument erstmals persistiert
(Rot-Beleg der Fehlstelle: fixr1_fund1_rot_c3a_nirgends.log -- '38a2|18.6|C-3a' im Log-Verzeichnis 0 Treffer,
'deklariert 19' repo-weit 0 Treffer, Timeline 'deklariert 19' 0 Treffer). Ledger-Buchung: Task-Vorschlag T-A
(Abschnitt 5).

## 1. EINGANGSMENGE + VERBLEIB JE POSTEN (Vollzaehligkeits-Gate)

Eingangsmenge laut Session-Timeline 19.08. (woertlich, at=2026-08-19T07:28:32Z und 12:05:30Z):
"F1-F9 (mit F1=V-01R-Bau, F2-Rezept aus den g2-Logs, F3-Hygiene-Haelfte schon gruen) + T-2 + T-10-Bau-Haelfte
(Ernte-Haelfte per 12.1 geschlossen) + L21 + die 12.4-Zusaetze" + Sweep-Funde.

F3-AUSWEIS (Heilung Verify-R1-Fund 2). Definition woertlich (Timeline 19.08.):
"F3: Endstand decken -- der reale Tip ist e285d316 mit 30 Commits (die Uebergaben nannten 25/32, nie literal
gemessen); Hygiene + Volllauf muessen bis zum Tip reichen."
VERBLEIB F3 = ENTLASTET mit Messung, beide Haelften:
  (a) Hygiene-Haelfte: hygiene_kumulativ_e114cabd_HEAD.log endet 'DIFF-HYGIENE-WACHE: GRUEN.';
      e114cabd ist Vorfahr von 20c111c4 (merge-base --is-ancestor EXIT=0), der Bereich deckt also
      20c111c4..HEAD und damit die vollen 30 Bruch-Commits bis zum realen Tip MIT.
  (b) Volllauf-Haelfte: 4-Zellen-Abnahme am Tip 8cd32a0d -- fixstrecke2_c1..c4_master.log, alle vier
      'DONE_CELL{1,2,3,4}_RC_CTEST=0' (gcc-debug, gcc-release, clang-debug, clang-release), jede Zelle
      mit CRC-Zeile '191:inline constexpr std::uint64_t kNewGolden131072Crc64 = 0x56F1B721C72DC10EULL;'.
ABGRENZUNG: Der Verify-Kandidat 'F3 = C-F3 (Ehrlichkeits-Doku K-4-Zahlproben, decl.hpp)' ist ein Posten der
VORSTRECKE r2 (Basis-Commit e285d316 selbst), nicht der F3 der f2-Eingangsmenge. Der Commit-grep-Treffer
04e9bd4f enthaelt nur 'A-F3' (A2.5-Block-Name). Beleg: fixr1_fund2_register_f3_definition.log.

Uebrige Posten der Eingangsmenge -> Abschnitt 2 (F1=G1, F7/F8/NP=G2, A-03=G3, F-9/L21+M-1/M-2=G4, B3=G5,
F9-Gates/F6=G6, T-2=m2, F2-Basis+Tip=m3+4-Zellen). NICHTS still verschwunden.

## 2. QUITTUNGSKETTE JE GRUPPE (dreiwertig, mit literalen Kommando-Ausgaben)

### m2 (T-2) -- BEHOBEN
- Positionsbeweis: m2-t2-positionsbeweis-einzeltest-gcc-release.log endet
  '[==========] 4 tests from 1 test suite ran. (0 ms total)' / '[  PASSED  ] 4 tests.'
  (Suite MW12StampBausteine, inkl. GA01FingerprintPreimageIsInjective + FrozenFingerprintTestVector).
- ctest-Registrierung: m2-t2-ctest-registrierung-gcc-release.log traegt Labels 'blut = 0.00 sec*proc (1 test)'
  und 'm = 0.00 sec*proc (1 test)'.
- TABU-CRC-Test: m2-t2-tabu-crc-test260.log: '1/1 Test #260: test_e24_c10_g6_identitaets_bilanz ... Passed'.

### m3 (F2-Basis) -- ENTLASTET mit Messung
Basisprobe auf 20c111c4 (m3_basisprobe_master.log): 'M3_START 2026-08-19T13:20:09Z HEAD_SOLL=20c111c4',
Hash bestaetigt 20c111c44f35af5e49a0f9e3fe7bc79a8bdb06b7; alle Phasen RC=0 (CONF/ALL1/TOOLS/RECONF/ALL2/
FACADE/CTESTS_TARGET/CTEST); 'Total Test time (real) = 79.52 sec'; 'DONE_M3_RC_CTEST=0'.
F2-Tip-Haelfte: 4-Zellen-Abnahme am Tip (siehe F3(b) oben) -- BEHOBEN.

### G1 (F1 = V-01R AxisKind-Dreh; Commits 94095eda, e34666fa, bbfd12f1) -- BEHOBEN
- T-1 Rot Ordnungswache vor Dreh (g1_rot_ordnungswache_vor_dreh.log): 'static assertion failed: V-01R/KON101
  (Owner 17.08.: definitiv mit drehen): die AxisKind-Enumeratoren stehen NICHT in der Kategorien-Ordnung
  MESS, SYSTEM, ORGAN.' EXIT=1. Gruen nach Dreh (g1_gruen_nach_dreh.log): EXIT=0.
- T-1 Rot Kategorien-Koeder K13 (g1_rot_kategorie_koeder_k13.log): zwei static_asserts rot, EXIT=1;
  Koeder-Ruecknahme Zeilen 12-13: 'diff zur Sicherung: leer' / 'g++ -fsyntax-only EXIT=0'.
- T-1 Rot Naht-Koeder (g1_rot_naht_koeder_ycsb.log): 'KOEDER: Ycsb (measurement_meta_meta) als SYSTEM
  deklariert -- muss rot sein' EXIT=1.
- ctest Runde 1 (g1_ctest_voll.log): '99% tests passed, 1 tests failed out of 504' (#298
  test_striktheit_axis_dach_guard Failed; dort steht auch das Literal '500/504 Test #344:
  test_axis_kind_kategorien_zuordnung ... Passed'). Fix e34666fa (Dach-Guard-Ordinal-Pins), dann
  Runde 2 (g1_ctest_voll_rund2.log) und Endstand nach Format (g1_ctest_endstand_nach_format.log):
  je '100% tests passed, 0 tests failed out of 504'. Clang-Gegenprobe: g1_clang_gegenprobe.log.
- P2-BELEG KORRIGIERT (Verify-R1-Fund 4) -> Abschnitt 3b. P7-BELEG KORRIGIERT (Fund 3) -> Abschnitt 3a.

### G2 (NP-23/NP-24, F7, F8-Rest, M-5; Commits 78cc75e6, d232ee0f, 298c4334) -- BEHOBEN (ein Posten ENTLASTET)
- NP-23 T-1 Rot (g2_np23_t1_rot_vorher.log): 'error: const struct ...ComdareMeasurementSnapshotV1 has no
  member named branch_misses_source_available' / 'BAU_PIPESTATUS=1'. Gegenprobe gruen
  (g2_np23_gegenprobe_gruen.log): '100% tests passed, 0 tests failed out of 20'. Voll:
  g2_np23_ctest_voll_gcc_release.log '100% tests passed, 0 tests failed out of 504';
  Kombibau gcc+clang Release je '100% tests passed, 0 tests failed out of 504'.
- F7 (Root-Duplikat system_axis_registry.xml) T-1: kanonische Wache rot (g2_f7_t1_kanonisch_rot.log:
  '428 - test_system_axis_registry_roundtrip (Failed)'), Root-Mutation an der ALTEN Pruefung still-gruen
  (g2_f7_t1_rootmutation_stillgruen.log: '100% tests passed ... out of 1' -- Beleg der Luecke),
  Gegenprobe nach Loeschung (g2_f7_gegenprobe_nach_loeschung.log): '100% tests passed ... out of 1'.
  NEBENBEFUND DEKLARIERT (vorbestehend): 'ci_xml_wellformed_guard: FAILED -- 4 von 160 getrackten
  XML-Dateien sind nicht wohlgeformt.' -> Lande-Zug, Task-Vorschlag T-C.
- F8-Rest (stale E-6-Satz): Teststellen-Vorher-Beleg g2_f8_teststelle_vorher.log; Commit 298c4334.
- M-5/tools-3 -- ENTLASTET mit Messung (g2_tools3_m5_messung.log): 3 Datei(en) unformatiert, aber
  'ausserhalb der Pruefmenge' (ce-CI 15974 SUCCESS, lint:format gruen); 'Traeger angelegt: Task #100
  (tools-3), Task #101 (W2-1)'.

### G3 (A-03 Stempel-Kette; Commits 4c6fa16b, 72cc7df2, 06bcbba3) -- BEHOBEN
- T-1 vier Wegwerf-Mutationen, alle literal rot: m1 Lesung-Praefix (Bau bricht: 'Error 2'),
  m2 Stempel-von-Null (gezielter Testlauf), m3 Invariante invertiert ('Which is: 15'),
  m4 Status-Name fehlt (Bau bricht: 'Error 2') -- g3_rot_m1..m4-Logs.
- Gruen: g3_gruen_test_isoliert.log '1/1 Test #196: test_hy_a2_stempel_kette ... Passed';
  g3_gruen_ctest_voll.log '100% tests passed, 0 tests failed out of 505'.

### G4 (F-9/L21 attach + M-1/M-2 Fence-Naht; Commits 1f0a7f81, 87fa9473) -- BEHOBEN
- F-9 T-1 Rot (g4_f9_t1_rot_linker_vor_fix.log): 'undefined reference to comdare::cache_engine::hybrid::
  DockArray<...RuntimeDockArrayPolicy>::attach(...DockContractDescriptor const&)' / 'collect2: error: ld
  returned 1 exit status'. Gegenprobe (g4_f9_gegenprobe_gruen.log): '[  PASSED  ] 2 tests.' plus
  Einstiegs-Matrix 'e1_factory_zuerst: SYNTAX-GRUEN / e2_attach_direkt: SYNTAX-GRUEN /
  e3_beide_wie_bisher: SYNTAX-GRUEN'.
- M-1/M-2 T-1 Rot TSan (g4_m2_t1_rot_bruecke_relaxed_tsan.log): 'WARNING: ThreadSanitizer: data race
  (pid=1368486)'; Vorher-Warnlage g4_m2_vorher_wtsan_warnung.log. Gegenprobe gruen
  (g4_m2_gegenprobe_gruen_tsan.log): '100% tests passed, 0 tests failed out of 4'.
- TABU: g4_tabu_vorher/nach_gruppe_a/nach_gruppe_b alle byte-identisch zur g1-Referenz (cmp EXIT=0).

### G5 (B3 Schalter-Hoheit/wallclock-Erbe; Commits f4e88786, 4cb16334) -- BEHOBEN
- T-1 Koeder Rot vorher (g5_b3_t1_koeder_rot_vorher.log, Zeile 105): '== Fehler: 9 =='.
- Mutation A Mengen-Erbe (g5_b3_t1_mutation_a_mengen_erbe_rot.log, Zeile 138): '== Fehler: 6 ==' mit
  'M1-EXIT=1'; Gegenprobe im selben Log: '== Fehler: 0 ==' / 'B3CT-EXIT=0'.
- Mutation B resolve-Durchleitung (g5_b3_t1_mutation_b_resolve_durchleitung_rot.log): '== Fehler: 5 ==' /
  'B3CT-EXIT=1'.
- Voll: g5_ctest_voll_gcc_release.log und g5_ctest_voll_clang_release.log je
  '100% tests passed, 0 tests failed out of 507' (Floor-Nachzug 507/503/501 im Commit 4cb16334).

### G6 (F9 Pre-Push-Gates + F6-Terminierung; Commits 7b4464fd, 04e9bd4f, 3b2fda12, 6fe69057, 8cd32a0d) -- BEHOBEN
- Script scripts/pre_push_lande_gates.sh (26116 Bytes, sechs Gates, fail-fast, Nenner je Gate).
- T-1-Gate-Paare mit literalem Rot persistiert (g6_t1_gate{1,2,3a,3b,4,5,6}_*):
  'ROT am GATE [1/6] DIFF-HYGIENE -- Verstoesse im kumulativen Diff (Liste oben)',
  'ROT am GATE [2/6] CLANG-FORMAT -- Format-Abweichungen in der CI-Vollmenge (Liste oben)',
  'ABBRUCH -- Koeder-Laenge 25 != 26 -- der Selbstbiss traefe nicht die gitlab-pat-Regel' (3a),
  'ROT am GATE [3/6] GITLEAKS -- Echt-Scan meldet Funde im Bereich (oben, redacted)' (3b),
  'ROT am GATE [4/6] AXIS-VERSION-LOCK -- Digest-Drift ohne Version-Bump',
  'ROT am GATE [5/6] FLOOR-SCANNER -- Inventur 507 UNTER Anker 508 -- 1 Test(s) verschwunden',
  'ROT am GATE [6/6] TABU-CRC-PROBE -- TABU-Datei(en) bewegt (oben) -- STOPP, NIE regenerieren';
  je Gate Gegenprobe gruen (g6_t1_gate*_gruen*.log, g6_erstlauf_*_gruen.log).
- Erstlauf am Ist-Stand: Gates diff/format/gitleaks/floor/tabu GRUEN; Gate 4 lock ROT -> deklarierter
  Landungs-Vorbehalt, Abschnitt 4. Basis-Gegenprobe: g6_t1_gate4_lock_gruen_20c111c4.log endet
  'axis_version_lock: GRUEN bestand konsistent -- 718 Dateien ... deckt 712 von 712 Overlay-Quellen'.
- F6-Terminierungs-Notiz: docs/plaene/20260819-F6-TERMINIERUNG-golden-ereignis-ein-zug-vor-f2.md (+54).
- Voll: g6_kombibau_all_tests_ctest507.log '100% tests passed, 0 tests failed out of 507';
  Diff-Hygiene-T-1 an der 122er-Kante: g6_diffhygiene_rot_122er_kante.log (rot) -> 04e9bd4f (gruen).

## 3. AKTEN-KORREKTUREN (Verify-R1-Funde 3 und 4)

### 3a. G1-P7-Beleg KORRIGIERT (war: 'g1_tabu_vorher.txt == g1_tabu_nachher.txt, diff leer')
Der Satz war woertlich FALSCH: 798 vs. 643 Bytes; diff ist NICHT leer -- im Nachher fehlen die zwei
source_catalog-Ankerzeilen ('188:// anchor ... [MISMATCH]' und '191:inline constexpr ... 0x56F1B721C72DC10EULL;');
nur die 5 sha256-Zeilen sind identisch. Beleg: fixr1_fund3_rot_beleg_diff_nicht_leer.log (diff EXIT=1).
SUBSTANZ UNBERUEHRT (Messung, fixr1_fund3_gruen_substanz.log): frische Probe im g1-Format ist byte-identisch
zu g1_tabu_vorher.txt (cmp EXIT=0); g6_tabu_final, g2_tabu_nachher, g3-Paar, g4-Trio, g6_nach_gruppe ebenso;
g5-Paar (1041 B) und m3-Paar (721 B) je in sich identisch; CRC-Zeile 191 live unbewegt.

### 3b. G1-P2-Beleg KORRIGIERT (war: Zitat 'IDENTISCH-ZUR-SICHERUNG')
Das Zitat war eine Paraphrase und stand in keinem persistierten Log (fixr1_fund4_rot_literal_fehlt.log,
grep EXIT=1). Korrekt und persistiert ist (K13-Log Zeilen 12-13): 'diff zur Sicherung: leer' /
'g++ -fsyntax-only EXIT=0'; Verstaerkung: Commit 94095eda aendert genau 1 Datei
(libs/cache_engine/topics/axis.hpp, 168+/22-), Endstand 504/504. Nachtrag: fixr1_fund4_nachtrag_beleg.log.

## 4. LANDUNGS-VORBEHALT (kein Verstoss der Fix-Strecke; VERTAGT an den Lande-Zug)

Gate 4 axis_version_lock ist am Ist-Stand ROT -- live reproduziert 19.08. 18:12 UTC
(fixr1_fund6_lock_rot_iststand_live.log, EXIT=1, 'NENNER: Tool-Exit 1, 4 ROT-Befund(e), 6 BESTAND-Zeile(n).'):
'Digest geaendert OHNE gueltigen Version-Bump' fuer libs/cache_engine/anatomy/anatomy_base.hpp,
libs/cache_engine/anatomy/observable_tier.hpp, libs/cache_engine/anatomy/pruefling_merge.hpp,
libs/cache_engine/system_axes/target_isa_complex_axis.hpp. Gegen Basis 20c111c4 ist das Gate GRUEN
(g6_t1_gate4_lock_gruen_20c111c4.log). Dazu vorbestehender Nebenbefund ci_xml_wellformed_guard 4/160
(deklariert in G2/F7). BEIDE gehoeren in den Lande-Zug (Lock-Pflege = Harmonisierungs-Schritt der Landung),
sonst CI-Rot beim main-FF. Diese Fix-Strecke hat NICHT gelandet und die Lock-Datei NICHT angefasst.

## 5. TASK-VORSCHLAEGE

- T-A (Docs-Zug): Ledger-Buchung der C-3a-Deklaration aus Abschnitt 0 ('#38a2 -> W2-Bump-Buendel mit
  Freeze-Nachbuchung, deklariert 19.08.') + Wellenplan-Nachtrag der W2-/19.08.-Fassung.
- T-B (Lande-Zug, VOR main-FF): axis_version_lock pflegen -- Version-Bump + bewusster Lock-Regen-Commit
  (--write) fuer die 4 Header aus Abschnitt 4; danach sh scripts/pre_push_lande_gates.sh komplett gruen.
- T-C (Lande-Zug): ci_xml_wellformed_guard-Befund 4/160 beheben (4 nicht wohlgeformte getrackte XML).

## 6. TABU-SCHLUSSSTAND + LOG-REGISTER FIX R1

TABU-CRC 0x56F1B721C72DC10E UNBEWEGT (source_catalog.hpp Zeile 191, live); golden_fullpilot_320* und
permutation_axes.xml unberuehrt: git diff --stat e285d316..HEAD ueber die 5 TABU-Pfade leer
(golden_diff_e285d316_HEAD.log, 'STAT_RC=0 (leere Ausgabe = unberuehrt)'); frische sha256-Probe
byte-identisch zur g1-Referenz. Schlusswache: fixr1_tabu_wache_final.log.

Fix-R1-Logs (alle in diesem Verzeichnis): fixr1_fund1_rot_c3a_nirgends.log,
fixr1_fund2_rot_f3_ohne_ausweis.log, fixr1_fund2_rot_register_nachsuche.log,
fixr1_fund2_register_f3_definition.log, fixr1_fund3_rot_beleg_diff_nicht_leer.log,
fixr1_fund3_gruen_substanz.log, fixr1_fund4_rot_literal_fehlt.log, fixr1_fund4_nachtrag_beleg.log,
fixr1_fund5_rot_keine_endquittung.log, fixr1_fund6_lock_rot_iststand_live.log, fixr1_tabu_frisch.txt,
fixr1_fund1_gruen_c3a_persistiert.log, fixr1_fund2_gruen_f3_ausgewiesen.log,
fixr1_fund5_gruen_kette_gebuendelt.log, fixr1_tabu_wache_final.log.

ENDE DER QUITTUNGSKETTE. Diese Datei ist die gebuendelte, vollstaendige End-Quittung der Fix-Strecke 2.
