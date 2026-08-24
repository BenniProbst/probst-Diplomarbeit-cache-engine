# AUDIT RUNDE 1 — Strang pmcpaket (#82 I-PMC-2/3 + #83 PMC-fail-loud)

Auditor: Fable-max-AUDITOR (W2-Audit-Fix-Verify, 22.08.2026). Objekt: ce `bau/pmcpaket` @ **1d38263b**
(Basis/merge-base 66de5c09, per `git merge-base` bestaetigt). Alle Objekt-Messungen NUR LESEND am
ce-Hauptklon (`git show`/`git diff`/Wache-Script) bzw. am sauberen Strang-Worktree
`/home/comdare/wt-ce-pmcpaket` (HEAD==1d38263b, porcelain 0; nur `--dry-run`-Proben, 0 Schreibzugriffe).
Soll-Karte (24 Punkte) VOLL gelesen; Strang-Bericht (283 Z.) VOLL gelesen; LEAD-ENTSCHEIDE (87 Z.) VOLL
gelesen; W2D-C-4/E-1-Bloecke, S1/S2-Synthesen (pmc-relevante Teile), Ledger-Fenster KON103-01/-02 +
KON106-04 im Original gehoben.

## DECKUNGS-ERKLAERUNG (EIN gruenes Gate deckt nur seinen Gegenstand — BEIDE Mengen)

**Von diesem Audit SELBST reproduziert (Literal-Belege unten):** Branch-Diff-Inhalt aller 16 Dateien am
Tip; Commit-Body inkl. Trailer; Push-Stand origin; TABU-Gegenprobe; offizielle Diff-Hygiene-Wache
(ASCII/120) ueber 66de5c09..1d38263b; clang-format-22-Dry-Run ueber alle 15 Code-Dateien; Include-
Richtungs-Messung; static_assert-Zaehlung; Hunk-Zonen-Vermessung der Harmonisierungs-Flaechen H-3/H-10;
Ledger-Wortlaute.
**NICHT von diesem Audit reproduziert (Traeger = Strang-Bericht-Literale + Lande-Zug):** Compile-/ctest-
Gruenheit am Branch-Tip (SB: Zweitlauf `100% tests passed, 0 tests failed out of 512`, CTEST_RC=0;
`ctest -N` Tests #511/#512; Director-Binary 88/88), die historischen Rot-zuerst-Laeufe T-A/T-B und die
beiden T-11c-Mutations-Rot-Laeufe, die Live-Sonden (host_biss=3/4; l2=8234162/coh=270641), die
perf-stat-Kreuzproben. Grund: Bau am Einzel-Branch wuerde nur die gcc-Release-Zelle wiederholen, die der
Strang bereits literal belegt hat; T-11b/K17 (4 Zellen) greift per Doktrin am GEMERGTEN Endstand und ist
Lande-Zug-Pflicht (Soll-Karte P-16 weist den Audit ausdruecklich an, die 3 fehlenden Zellen NICHT dem
Strang anzulasten). Alle datei-seitigen Voraussetzungen dieser Behauptungen wurden am Objekt verifiziert
und sind konsistent (kein Widerspruch gefunden; eine Zahl wich guenstig ab, s. Fund A-2).

## PUNKT-FUER-PUNKT-TAFEL (P-01..P-24, dreiwertig)

### A) #83 PMC-FAIL-LOUD (C-1, KON103)

**P-01 — C-1(a) Invariante der dynamischen Kette: ERFUELLT (Bestand, am Tip verifiziert).**
`git show 1d38263b:...experiment_plan_director.hpp | grep -n ceb_pmc_compile_define` liefert exakt die
gemeldeten Stellen: Definition :359, clang-Zwilling :423, Emissionen :1086/:1132/:1470/:1667 (4+1).
Wache `expect_pmc_invariant` inkl. Gegenrichtung ("ein Host ohne PMU darf KEIN Flag bekommen") am Tip
:3030-3040. Vor-Strang-Bau (06./10.08.) — vom Strang korrekt nur verifiziert, deckungsgleich mit F-35
(r3-Karte stale).

**P-02 — C-1(b) Preflight scheitert statt skippt: ERFUELLT (Diff-Literal).**
Director-Diff @@1685: `if (header_.pmc_befund.lage == PmcLage::Unbrauchbar)` emittiert
`[PMC-TESTAT] ... pmc=FEHLER grund=pmc_quelle_nicht_gebaut ...` + `exit 1`; der Zweig steht VOR
`export COMDARE_GOLDEN_N_RANGE` (= vor jeder Messung). else-Zweig: Smokes + `ctest -L pmc
--no-tests=error` + `pmc=ok` unveraendert. Test `PmcFailLoud.UnbrauchbarerBefundLaesstDenPreflight-
ScheiternStattSkippen` am Tip (TEST-Makro :3196-Region) prueft BEIDE Richtungen (brauchbar: pmc=ok +
KEIN FEHLER-Testat; unbrauchbar: KEIN pmc=ok + FEHLER-Testat + `\n      exit 1\n` NACH dem Testat im
selben Block). Rot-zuerst-Literal: SB Z.185-187 (historisch, s. Deckungs-Erklaerung).

**P-03 — C-1(c) Ergebnis-Seite HART: ERFUELLT (Diff-Literal).**
Iterator-Diff @@1012: `} else if (row.pmc.available && !source_available) {` wird
`} else if (!source_available) {` — das available-Gate ist gefallen; jede Zelle ohne per-Feld-Flag
rendert `cem::sample_status_token(SourceUnavailable)` ("n/a"), echte Zahlen (auch echte 0) bleiben
Zahlen. Pin-Umschrieb test_a8s3 W10: `tr("W10 PMC-off-Zeile traegt Token statt stiller 0 ...", l3_off == na)`
+ NEU W10b `av_off == "0"` (pmc_available bleibt "0" = Teil-Lauf-Kennzeichnung). Bau-Seite unberuehrt
(kein CMake-/Options-Wechsel im Diff) = soft gemaess KON28-02/WP:2479-2480/WP:2176.

**P-04 — C-1(c)-Warnung Drei-Wege (KON106-04/NP-31): ERFUELLT (neue Datei am Tip, 186 Z.).**
`builder/pmc_startup_pruefung.hpp` traegt die vier Lagen (`NormalfallMitQuelle`, `NormalfallOhnePmc`,
`TeilLaufQuelleOhneZugriff`, `VorhandenNichtVerwendet`), genau ZWEI Warnungen, Warnzeile mit Nenner
`host_biss=<gebissen>/<geprueft>` gegen die EINE Liste `measurement::kPmcEvents` (V-1: beide Mengen).
Immer uebersetzt (kein COMDARE_ENABLE_PMC-Guard, Henne-Ei-Begruendung im Kopf). Einbau dreifach am Objekt:
(1) `run_planer_driven_provision` collect_ordered-Vorfeld (EINMAL je Lauf, VOR erster Zelle; Iterator-Diff
@@3198), (2) `linux_perf_pmc_smoke.cpp` Skip-Zweig (:167ff, `return 0` bleibt), (3) `m3v2_pmc_smoke.cpp`
`if (!kPmcExpected)`-Block vor dem Verdikt. Fehler-Weg wohnt korrekt in der Emission (P-02), stiller
Normalfall bleibt still (leere Warnzeile). NP-31-Lesart "WARN-Log ODER CSV-Flag": vom Audit GEPRUEFT und
BESTAETIGT — der Ledger-Wortlaut KON106-04 :1289 nennt "(WARN-Log/CSV-Flag)" als Beschreibung des EINEN
neuen Bausteins, keine Doppel-Pflicht; die Zeilen-Kennzeichnung existiert bereits (pmc_available=0 +
Tokens, P-03), die Warnung ist Lauf-Eigenschaft. Kein Widerspruch.
Anmerkung (kein Fund): in m3v2 feuert der Gegeneingang in ALLEN `!kPmcExpected`-Faellen (auch vor einem
etwaigen SMOKE_FAIL), nicht nur im engen Skip-Fall — konservativ-harmlos (eine Warnzeile mehr, Exit
unveraendert).

**P-05 — errno=2 wird FEHLER, nie Messwert: ERFUELLT (Bestand, am Tip verifiziert).**
`pmc_counter_outcome.hpp` am Tip: `static_assert(classify_pmc_open_errno(ENOENT) ==
PmcCounterOutcome::EventNichtVorhanden, ...)` (:174) + `static_assert(pmc_outcome_cell(
PmcCounterOutcome::EventNichtVorhanden) == std::string_view{"n/a"})` (:198). Vor-Strang-Bau (B-5,
08.08.) — Strang verifizierte korrekt, kein Neubau noetig.

**P-06 — "Stille Nullen gibt es bei Messung nicht" (GOAL8 II.7 + allow_failure-Tabelle): ERFUELLT.**
Diff-weit 5 Treffer `allow_failure` — ALLE fuenf sind Kommentare bzw. die verschaerfte Test-Zusicherung
`EXPECT_EQ(count_occurrences(tb_ohne.text(), "allow_failure"), 0u)` (Diff-Zeilen 747/1229/1251/1252/1298);
KEIN emittiertes allow_failure, keine .gitlab-ci.yml im Diff (name-status: 16 Dateien, 0 YAML). Der Job
faellt ueber `exit 1` hart rot = GOAL8:763-776 Tabellenzeile woertlich; die Zellen-Seite traegt Token
statt stiller Werte (P-03) = GOAL8:305-308 fail-closed.

### B) #82 I-PMC-2/3 (C-2, "volles Programm")

**P-07 — volles Programm, sechs Felder referenzierbar: ERFUELLT.**
Am Tip: l1d/dtlb (Bestand, kPmcEvents), branch_misses (kPmcEventIndexBranch, M-3a Bestand), L3 generisch
LL + `c_l3_uncore_` amd_l3-Uncore-Spalte (B-5 Bestand), L2+coherence NEU via `c_l2_`/`c_coherence_` aus
dem Katalog (Diff @@494-533: Katalog-Aufloesung via `probe_cpuid()`, open/reset/enable/disable/read_scaled,
per-Feld-Flags `cache_misses_l2_source_available`/`coherence_invalidations_source_available`, `any` zaehlt
— per-Task-Prueflings-Werte, anders als der Uncore), energy best-effort RAPL (Bestand im read-Pfad).
Zuschneide-Ablehnung respektiert: nichts entfernt, alles additiv.

**P-08 — Zen-5-RAW-Ausgang geschlossen: ERFUELLT (Datei-Literal + SB-Kreuzproben-Literale).**
NEU `measurement/pmc_raw_event_katalog.hpp` (116 Z.): Zen 5 = (AuthenticAMD, family 26), `l2 =
PERF_TYPE_RAW 0x964` (l2_cache_req_stat.ic_dc_miss_in_l2), `coherence = PERF_TYPE_RAW 0x1443`
(ls_dmnd_fills_from_sys.remote_cache); Kreuzprobe (r964==17.314.023==benannt; r1443==21.503==benannt) und
AMD-config-Layout (event bits 0-7, umask bits 8-15: 0x964=(0x09<<8)|0x64; 0x1443=(0x14<<8)|0x43) im Kopf
offengelegt; Semantik-Offenlegung beider Spalten (Demand-L2-Miss IC+DC; Demand-Fills aus fremdem CCX,
"kein woertlicher Invalidierungszaehler im amdzen5-Satz") steht woertlich im Kopf — Anhangs-tauglich.
Family-statt-Modell-Begruendung + Planer-Probe-Abgrenzung (Katalog geht NICHT in die Lage-Entscheidung
ein) dokumentiert; Spiegel-Absatz in `pmc_event_set.hpp` (+7 Z.) und Ueberholt-Vermerk in
`pmc_source.hpp` nachgezogen. Live-Sonden-Werte: SB-Literale (s. Deckungs-Erklaerung).

**P-09 — fremde Modelle fail-closed: ERFUELLT; Zahlen-Delta zum Bericht (s. Fund A-2).**
Alle Nicht-Zen5-Schluessel liefern `{}` (vorhanden=false); Nicht-Linux strukturell leer. Am Objekt
gezaehlt: `grep -c 'static_assert('` = **7** (vier positive Zen5-Pins + drei Negativ-Pins family 25 /
GenuineIntel / leer) — SB Z.175 und Board #82 sagen "6 static_asserts". Test T-D prueft zusaetzlich
family 27, GenuineIntel-26 (Vendor gehoert zum Schluessel) und "authenticamd" (keine stille
Normalisierung). Intel bewusst leer (NIE raten; OV-5(b)/DP:79/WP:3121) — deckungsgleich mit
NICHT-GEFORDERT Nr. 5.

**P-10 — NP-34 csv_to_latex "in DENSELBEN Zug": LUECKE (deklariert, getragen als F-40) + Traeger-Drift
(NEUER Fund A-1).** Der Strang hat die super-Datei nicht angefasst (richtig: ausserhalb des ce-Worktrees;
Diff enthaelt 0 super-Pfade) und den Punkt offen deklariert (SB Z.274-275). Der Ledger-Wortlaut KON106-04
:1300-1302 ("in DENSELBEN Zug buendeln, damit Textaussage und Messvermoegen nie auseinanderlaufen") ist
damit am Branch NICHT woertlich erfuellt — das war qua Worktree-Zuschnitt unvermeidlich und ist getragen.
ABER: die S1-SYNTHESE :249 parkt F-40 unter "**Folgepakete**" (= nach der Landung) — landet pmcpaket
(ce-Merge + super-Gitlink-Bump) ohne die Umschrift im SELBEN super-Zug, laufen Text ("L2 + Coherence
strukturell 0") und Messvermoegen (Zen-5-real) exakt auseinander. Das ist Fund A-1 (MILD, Fix im
Lande-Plan, kein ce-Code).

**P-11 — NP-30 vier Wachen "werden scharf": TEIL-ERFUELLT 3/4 + W1 deklariert offen (getragen F-41;
Audit-Urteil zu S-1 unten).** Am Tip verifiziert: W2 `m3v2_pmc_smoke.cpp` pmc_seam_ok-Verdikt
(einkompiliert+available=0 => FAIL; Rest-Skip nur `!kPmcExpected && counters_all_zero`, jetzt SPRECHEND
via Gegeneingang), W3 `linux_perf_pmc_smoke.cpp` :155-166 einkompiliert+available=0 = SMOKE_FAIL exit 1,
Skip nur `!kPmcExpected` (jetzt sprechend), W4 = P-01. W1 `CMakeLists.txt` :112-121: Vendor-leer bleibt
`message(WARNING ...)` mit woertlicher Begruendung im Code ("Ein FATAL hier machte die Super-Pipeline
sofort hart rot ... DER FLIP AUF FATAL GEHOERT IN DASSELBE FENSTER WIE DER SUPER-NACHZUG (Folgepaket)"
+ "NACH dem Super-Nachzug wird diese Warnung ein FATAL_ERROR.").

### C) TDD-VERTRAG (DP par.3)

**P-12 — T-1 rot zuerst: ERFUELLT (SB-Literale; Objekt-Konsistenz geprueft).** T-A- und T-B-Rot-Literale
stehen im SB (Z.185-189: `test_experiment_plan_director.cpp:3188: Failure ... s.find("pmc=ok")` bzw.
`a8s3_rc=1` + `[ERR] W10 ...`); am Tip liegen die Tests in der finalen Gruen-Form; die Zeilennummer 3188
des Rot-Laufs ist mit dem Tip-Stand (TEST :3196 nach +36 Zeilen KeinAllowFailure-Verschaerfung weiter
oben) arithmetisch konsistent. T-C/T-D tragen zusaetzlich T-11c-Mutationen (P-17). DP:67 verlangt Rot
ODER Mutations-Beleg — je neuem Test liegt mindestens eines literal vor.

**P-13 — T-3 Nenner fremd: ERFUELLT (Objekt-Literal).** T-D rechnet die Kodierungen UNABHAENGIG nach:
eigene `amd_raw_config(event, umask) = (umask << 8) | (event & 0xFF)` aus dem sysfs-Format-Layout,
"Bewusst eine EIGENE Implementierung, keine Weiterleitung" (test_pmc_raw_event_katalog.cpp :26-30) —
fremdes Orakel gegen den Katalog. T-C bezieht seinen Nenner aus `measurement::kPmcEventCount` (die EINE
Liste, nicht der Pruefling): "waechst die Liste, waechst dieser Test mit". PmcFailLoud traegt die
T-3-Gegenrichtung explizit (brauchbarer Befund als Vorbedingungs-Anker `ASSERT_NE ... [PMC-PREFLIGHT]`).

**P-14 — T-6 Schwesterstelle: ERFUELLT (Objekt-Literal).** Probe-Kern-Umzug nach
`measurement/pmc_event_biss.hpp` (106 Z., Koeder wortgleich verschoben), `pmc_host_probe.hpp` delegiert
("NUR NOCH EINE WEITERLEITUNG ... ABSCHRIFT SCHLAEGT LOESCHUNG", Muster pmc_cache_cfg) — Include-Richtung
am Tip GEMESSEN: `#include`-Zeilen builder/ -> profile_facade/ = **0** (Behauptung "5:0" auf
Include-Ebene bestaetigt: 0 zurueck). `c_l2_`/`c_coherence_` in derselben Semantikklasse wie
l1d/dtlb/branch (per-Task, exclude_kernel), ausdruecklich gegen den system-weiten Uncore abgegrenzt
(`any` ja vs. nein). Beide Smokes erhielten dieselbe Gegeneingangs-Anbindung (Schwesterpaar).

**P-15 — T-7 Registrierung + Dateiende-TABU: ERFUELLT (Datei-Ebene); ctest-N-Zahl = SB-Literal.**
CMakeLists-Diff: EIN Anhang-Block ab alter EOF-Zeile 7574 (nur `+`-Zeilen, nichts verschoben); zwei
`comdare_add_test`-Bloecke mit Include-Dirs und Labels `fail_loud;startup_pruefung;gegeneingang;wachen;
koeder` bzw. `fail_loud;raw_katalog;kreuzprobe` — 0x 'pmc'-Substring, Begruendung (`ctest -LE pmc` ist
Regex, F-43) im Block dokumentiert; die -LE-pmc-Stellen existieren am Tip (tests/unit/CMakeLists.txt
:3797-Region "Die Auswahl von test:unit ist '-LE pmc'"). `ctest -N` #511/#512 (Total 512): SB-Literal;
am Merge-Endstand zaehlt T-7 ohnehin neu (H-9, Endstand-Soll 520 = S1:37 "+10").

**P-16 — T-11b 4-Zellen-Kombibau: ERFUELLT als Strang-Pflicht (1 Zelle literal) + korrekt delegiert.**
gcc-Release 512/512 (SB-Literal, CTEST_RC=0); die restlichen 3 Zellen sind als OFFENER PUNKT #1 an den
Lande-Zug deklariert — exakt K17-Doktrin ("jeder Lande-Merge traegt VOR Push den 4-Zellen-Kombibau";
T-11b greift am GEMERGTEN Endstand). KEINE Strang-Luecke (Soll-Karten-Weisung befolgt).

**P-17 — T-11c Mutationen: ERFUELLT (SB-Literale + Objekt-Gegenprobe).** T-C: Warn-Weg stillgelegt ->
`[ FAILED ] PmcStartupPruefung.VorhandenAberNichtVerwendetWarnt` -> revert -> PASSED 4. T-D: Configs
vertauscht + 2 Header-static_asserts still -> `[ FAILED ] PmcRawEventKatalog.Zen5TraegtDieKreuz-
geprobtenKodierungen` (die FREMDE Nachrechnung beisst) -> revert -> PASSED 2. Objekt-Gegenprobe des
Audits: `git diff 66de5c09..1d38263b | grep -in 'WEGWERF|TODO|FIXME|XXX'` = 1 Treffer, und der ist das
Prosa-Wort "Wegwerf-Quelle" im Iterator-Kommentar (kein Marker) — "0 WEGWERF-Marker verbleiben" haelt.

### D) PROZESS-/BAU-GATES

**P-18 — TABU: ERFUELLT (vom Audit reproduziert).** `git diff --name-only 66de5c09..1d38263b | grep -E
'golden_fullpilot|permutation_axes|m3v2_study|axes/|topics/|heuristik/|\.gitlab-ci\.yml|registry.*\.xml'`
=> 0 Treffer, `TABU_GREP_RC=1`. 16 Dateien, alle libs/ + tests/unit/.

**P-19 — Format + Diff-Hygiene: ERFUELLT (vom Audit reproduziert).**
(a) `~/.local/bin/clang-format-22 --dry-run -Werror` ueber alle 15 Code-Dateien des Diffs (Zaehl-Schleife):
`FORMAT_FAILS=0 von 15`. (b) Offizielle Wache am Bereich: `sh scripts/ci_diff_ascii_width_guard.sh
66de5c09..1d38263b` => "927 Zusatzzeilen ... geprueft, davon 0 Nicht-ASCII, davon 0 ueber 120 Spalten.
927 Zusatzzeilen insgesamt im Diff; 0 davon uebersprungen. ... DIFF-HYGIENE-WACHE: GRUEN." GUARD_RC=0.
(927 = exakt die diffstat-Zusatzzeilen; Nenner deckungsgleich.)

**P-20 — Vollbau-Treppe + ctest-Bilanz: ERFUELLT per SB-Literal (Objekt-konsistent).** Treppe inkl.
leerer J-1-registry_gen-Schleife dokumentiert; Erstlauf 99% (510/512) mit ZWEI Ripple-Rots, beide als
Folge des EIGENEN Baus identifiziert und am Objekt nachvollziehbar behoben: (1) KeinAllowFailure+G4a
bauten mit Default-Director (=Unbrauchbar, fail-closed) und pruefen seit #83 einen leeren Gegenstand —
Fix am Tip sichtbar (inline `amd_befund` je Test, KeinAllowFailure ZUSAETZLICH verschaerft:
Unbrauchbar-Emission traegt 0 allow_failure + >0 pmc=FEHLER); (2) Anker-Ratsche: Katalog-Kopf verweist
am Tip auf die WORTMARKE (B-5-Kanon "verschiedene Semantik unter derselben Ueberschrift", "AnkerWache"),
kein roher Ledger-Zeilenanker im Diff. Zweitlauf `100% ... 512` = SB-Literal (s. Deckungs-Erklaerung).

**P-21 — Trailer + ci.skip-Push: ERFUELLT (vom Audit reproduziert).** `git log -1 --format=%B 1d38263b`
endet literal mit `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>`. `git ls-remote origin
refs/heads/bau/pmcpaket` => `1d38263b017ff8aa3126650a41b208b0c8795a90` (Ref auf origin gesichert). 16
Dateien = 11 M + 5 A (name-status gezaehlt, deckungsgleich mit SB "11 geaendert/5 neu").

### E) LANDE-KOPPLUNG

**P-22 — H-3 Iterator-Zonen: ERFUELLT + vom Audit VERTIEFT (Hunk-Vermessung).** pmcpaket beruehrt
@@50 (Include), @@1012 (pmc_zelle), @@3198 (collect_ordered-Vorfeld); messfenster @@37/@@391/@@1262/
@@2174/@@3024/@@3203; s13schema @@70/@@89/@@266/@@3093/@@3157. Einzige Naehe: pmcpaket fuegt VOR
`ProgressHeartbeat measure_hb` ein (alte Z. ~3204), messfenster aendert INNERHALB des collect_ordered-
Lambdas (alte Z. 3206-3207) und haengt seinen C-11-Block NACH `measure_hb.done()` an — zeilendisjunkt,
Auto-Merge zu erwarten; s13-Hunks liegen komplett woanders. SEMANTIK (Spannung S-5, soweit ohne Merge
pruefbar): messfenster-C-11 warnt bei FEHLENDER Einrichtung (available()==false, xlsx-INFO-Blatt, eigener
Kanal), pmcpaket-Gegeneingang unterscheidet zusaetzlich per Host-Koeder (vorhanden-nicht-verwendet vs.
ohnehin-nichts-lieferbar, stderr-Kanal, Nenner host_biss=x/y) — verschiedene Bedingungen, beide mit
eigenem Nenner, KEIN Widerspruch; im PMC-off-auf-faehigem-Host-Fall feuern beide (komplementaer).
Endstand-Gegenprobe bleibt Lande-Zug (H-3-Marker-Wachen).

**P-23 — H-10 kampvor NACH pmcpaket: ERFUELLT als dokumentierte Randbedingung.** Vom Audit vermessen:
kampvor-Director-Hunks @@776/@@1499/@@1524/@@1712 vs. pmcpaket @@1685-1701 — textuell disjunkt (naechste
Naehe 1701 vs. 1712); Testdatei: kampvor haengt ans DATEIENDE (@@4137+94) an, pmcpaket fuegt mittig ein
— kein Text-Konflikt zu erwarten; die ZWINGENDE Reihenfolge ist semantisch (Testat-Kontrakt, S2:51-56)
und im Lande-Reihenfolge-Plan getragen (S2:121 "pmcpaket ... Director-Flaeche VOR kampvor").

**P-24 — E-1 "vor Trigger gelandet": OFFEN, KEIN Strang-Defekt.** Branch LANDEREIF, nicht gemergt
(Board #82/#83 pending; Lande-Zug = eigener Zug nach Design TEIL 3, S1-Phase-1-Schritt-4: messfenster ->
s19 -> s13schema -> **pmcpaket** -> s8kopf). Frist Mi 26.08. 06:00 zum Audit-Zeitpunkt (22.08.) nicht
erreicht. Von den Code-Pflichten getrennt gefuehrt, wie von der Soll-Karte verlangt.

## ZUSATZPRUEFUNGEN

**(a) TDD-Vertrag je neuem Test:** T-A: T-1-Rot literal (SB), T-3-Gegenrichtung im Test, T-7 via
Bestands-Binary (test_experiment_plan_director war registriert). T-B: T-1-Rot literal (SB), Pin-Umschrieb
+ neues W10b. T-C: 4 Tests, T-11c-Mutation literal (SB), T-3-Nenner kPmcEventCount, T-7 am Dateiende,
T-4-Gegeneingang doppelt (BeisstNie im einkompilierten Zweig beweist "Host wird dort NICHT gefragt";
Real-Strategie-Test pinnt die Invariante statt einer host-abhaengigen Lage). T-D: 2 Tests, T-11c-Mutation
literal (SB), fremde Nachrechnung als Orakel, T-7 am Dateiende, Negativ-Schluessel in JEDER Richtung.
**(b) GOAL-Doktrinen:** ASCII 927/927 clean (Wache-Literal); allow_failure 0 emittiert (5/5 Treffer
Kommentar/Assert); TABU 0 Treffer; Ledger/Board/Memory vom Strang NICHT geschrieben (Diff enthaelt 0
docs/-Dateien; Ledger-Zeilen nur als ENTWURF im Bericht — Lead-only respektiert); golden byte-stabil
(kein golden-Pfad im Diff; SB-Gegenprobe golden_fullpilot 0x "pmc" plausibel, da nur Binary-ID-Listen).
**(c) Abnahme-Formeln woertlich:** C-4 "I-PMC-2/3 gebaut" = ERFUELLT am Objekt (P-07/P-08/P-09; I-PMC-2
war Bestand, I-PMC-3 neu). E-1 "fail-loud-Paket gebaut" = ERFUELLT (P-01..P-06); ", vor Trigger
gelandet" = OFFEN bis zum Lande-Zug (P-24, fristgerecht offen). K1:29/:30 deckungsgleich.
**(d) Bericht-Behauptungen gegen das Objekt (Stichproben, Zahlen mit Nenner):** 16 Dateien (11M+5A) —
stimmt; 927 Zusatzzeilen — stimmt (Wache-Nenner); 4+1 Emissionsstellen — stimmt; Include-Richtung 0
rueckwaerts — stimmt; Labels ohne pmc — stimmt; Trailer — stimmt; ci.skip-Push-Ref — stimmt;
"6 static_asserts" — **weicht ab: 7 am Objekt** (guenstige Richtung; Fund A-2); "0 WEGWERF-Marker" —
stimmt; W1-WARNING-Wortlaut — stimmt.

## FUNDE

**A-1 (MILD) — NP-34-Kopplung ist im Lande-Plan als "Folgepaket" geparkt statt in DENSELBEN Zug
gebunden.** LEDGER KON106-04 :1300-1302 verlangt woertlich, den csv_to_latex-Kernmetrik-Caveat "in
DENSELBEN Zug" wie I-PMC-2/3 zu buendeln, "damit Textaussage und Messvermoegen nie auseinanderlaufen";
S1-SYNTHESE :249 fuehrt F-40 unter "Folgepakete" (= NACH der Landung). Landet pmcpaket ohne die
Umschrift im selben super-Zug, ist der verbotene Auseinanderlauf exakt eingetreten (super behauptet
"strukturell 0", ce misst real). KEIN Defekt des Strang-Codes (super ausserhalb des ce-Worktrees; vom
Strang korrekt deklariert). fix_weg: Lande-Zug-Plan haerten — der super-Zug, der den ce-Gitlink ueber
pmcpaket bumpt, traegt IM SELBEN Commit-Zug die Umschrift `super Code/04_csv_to_latex/csv_to_latex.cpp
:986-999` von "L2 + Coherence strukturell 0" auf "modell-gebunden real (Zen 5, PERF_TYPE_RAW
0x964/0x1443), sonst n/a" (Quelle: Katalog-Kopf pmc_raw_event_katalog.hpp); F-40 in der
Lande-Reihenfolge von "Folgepakete" in die super-Lande-Phase umhaengen.

**A-2 (KLEIN) — Zahl "6 static_asserts" im Bericht/Board, Objekt traegt 7.**
`git show 1d38263b:libs/.../pmc_raw_event_katalog.hpp | grep -c 'static_assert('` = 7 (4 positive
Zen5-Pins + 3 Negativ-Pins). SB Z.175 und Board-#82-Text sagen 6. Richtung guenstig (mehr Pins als
behauptet), aber Zahlen reisen in KON120. fix_weg: beim KON120-Ledger-Zug (Lead) die Zahl in der
#82-Ledger-Zeile/Board-Text auf "7 static_asserts" korrigieren; kein Code-Fix.

## GETRAGENE OFFENE POSTEN (F-01..F-123 — KEINE neuen Funde, nur gelistet)

- **F-39** Intel-RAW-Lanes ehrlich n/a; Eintrag erst nach Intel-Host-Kreuzprobe (Muster+Assert-Form steht).
- **F-40** NP-34 csv_to_latex (super) OFFEN — s. Fund A-1 fuer die Traeger-Platzierung.
- **F-41** W1 CMakeLists Vendor-leer WARNING, FATAL-Flip = Folgepaket super-Nachzug-Fenster (Board #83 REST).
- **F-42** amd_l3-Uncore-Wertfuellung braucht CAP_PERFMON/paranoid<=0 (Infra-Posten).
- Lande-Zug-Pflichten: T-11b-4-Zellen-Kombibau am Merge-Stand (K17) · H-3/H-9/H-10-Harmonisierung ·
  E-1-Landung vor Mi 26.08. 06:00 · optional super-CI-Sichtbarkeits-Grep (kein Muss, S1:235-236) ·
  Thesis-Anhang Zen-5-Spalten-Semantik (Lead-Nachzug, S1:254).

## SPANNUNGS-URTEILE (von der Soll-Karte angefordert)

**S-1 (W1 nicht geflippt):** KEIN neuer Fund. Begruendung: (i) das Owner-VERBATIM KON103-01 nennt die
vier Wachen nicht — "werden scharf" ist die Konsequenzen-Zeile der Session auf einer nachweislich stalen
Faktenlage (3/4 waren am 17.08. bereits scharf, F-35); (ii) die JUENGERE KON106-04 (Rangfolge: juengere
KON) fasst NP-30 als Fundstellen-Uebernahme, nicht als 4/4-Vollzugsbefehl; (iii) ein Flip jetzt braeche
die super-Pipeline hart rot (zwei Altaufrufer ohne Vendor) und kollidierte mit der Owner-Doktrin
"Pipeline immer hart gruen" — der Flip braucht den exklusiven super-YAML-Schreiber (LEAD-ENTSCHEIDE:
YAML-Zug Staffel 3/Lande-Folge); (iv) der Flip ist im Code selbst als Folgepaket mit Fenster verdrahtet
("NACH dem Super-Nachzug wird diese Warnung ein FATAL_ERROR") und auf Board #83 REST getragen. Eine
Restluecke gegen den nackten KON103-02-Wortlaut BESTEHT (W1 warnt, beisst aber nicht fatal) und bleibt
als F-41 korrekt offen gefuehrt — sie darf beim super-Nachzug nicht verfallen.
**S-2 (NP-34):** s. Fund A-1 — Wortlaut nicht woertlich erfuellt, Traeger existiert, Platzierung im
Lande-Plan ist zu haerten.
**S-3 (E-1 zweite Haelfte):** korrekt offen, fristgerecht, Lande-Zug-Sache (P-24).
**S-4 (Harmonisierung einseitig):** durch Hunk-Vermessung beider Nachbarzweige entschaerft (P-22/P-23):
keine Text-Kollisionen zu erwarten, Reihenfolge-Auflagen getragen; Endstand-Beweis bleibt Lande-Zug.
**S-5 (zwei Warnpfade):** fachlich KOMPLEMENTAER, nicht widerspruechlich (P-22): verschiedene
Bedingungen (Einrichtung-fehlt vs. Host-koennte), verschiedene Kanaele (xlsx-INFO vs. stderr-Log), je
eigener Nenner. Deckungs-Gegenprobe am gemergten Endstand bleibt Pflicht des Lande-Zugs.

## VERDIKT

**FIXES_NOETIG** — 0 ERNST, 1 MILD (A-1: NP-34-Kopplung in den Lande-/super-Zug binden, reiner
Plan-/Traeger-Fix, kein Code-Delta an bau/pmcpaket), 1 KLEIN (A-2: Zahl 6->7 im KON120-Zug). Der
Branch-Inhalt selbst ist vollstaendig gegen KON103 C-1(a/b/c)+Warnung, KON106-04 Drei-Wege, C-2 volles
Programm inkl. geschlossenem Zen-5-RAW-Ausgang, TDD-Vertrag und Session-Gates — am Objekt belegt;
LANDEREIF-Status wird bestaetigt, die Landung traegt die dokumentierten Pflichten (K17-Kombibau,
H-3/H-9/H-10, F-40-Kopplung, Frist 26.08. 06:00).

Ende audit-runde-1 pmcpaket. 24/24 Punkte geprueft: 20 ERFUELLT, 1 TEIL-ERFUELLT (P-11, getragen),
1 LUECKE-deklariert (P-10, getragen + Fund A-1), 2 OFFEN-fristgerecht/Lande-Zug (P-16-Restzellen im
Rahmen der Doktrin, P-24). Keine Bericht-Behauptung ausser der static_assert-Zahl wich am Objekt ab.
