# AUDIT RUNDE 1 — Strang "mess-fenster" (#13/T-15b + #38b/C-05)

Auditor: Fable-max-AUDITOR (Vollstaendigkeits-Audit VOR der Landung, Owner-Order 21.08.).
Datum der Pruefung: 22.08.2026 (Beginn 21.08.-Auftrag).
Objekt: ce `bau/messfenster` @ `3a746090` (Basis `66de5c09`; merge-base literal
`66de5c0972290ec1ae3d219988ecc207d8f5de6b` == Basis, 1 Commit, 20 Dateien, +1281/-184).
Origin-Ref (read-only gemessen): `git ls-remote origin refs/heads/bau/messfenster` ->
`3a746090ae6abb95ae9c1bce498e1cf54d81f1f3` (Ref-Sicherung STEHT).
Modus: NUR LESEN am ce-Hauptklon (git show/diff gegen Refs); KEIN Bau-Slot gezogen (kein Vollbau
noetig — Audit prueft Diff + Datei-Stand + rechnerische Gegenproben; Gruen-Literale des Strangs
werden als Berichts-Literale gefuehrt, ihre Nachpruefung ist per K17 ohnehin Endstand-Pflicht).
Eingang: soll-karte.md (VOLL, P-01..P-20) + mess-fenster-ergebnis.md (VOLL, 245 Z.) +
STAFFEL1-SYNTHESE (F-01..F-77) + STAFFEL2-SYNTHESE (F-78..F-123) + LEAD-ENTSCHEIDE (87 Z. VOLL) +
W2-ABFOLGE-DESIGN C-2/C-3-Block + Wellenplan-/Designplan-/GOAL-Zitate der Soll-Karte.

VERDIKT: **FIXES_NOETIG** (0 ERNST · 1 MILD · 1 KLEIN). Substanz des Strangs haelt der
Punkt-fuer-Punkt-Pruefung stand — beide Funde betreffen den GRUEN-BEWEIS bzw. die
Berichts-Vollstaendigkeit, nicht die gebaute Mechanik.

--------------------------------------------------------------------------------

## 1. PUNKT-FUER-PUNKT-TAFEL (P-01..P-20, dreiwertig)

### P-01 — Retry-Klammer BUILD und MESSUNG je 5, NICHT 1+5 — **ERFUELLT**
- `harness/mess_retry_klammer.hpp` (NEU, am Tip gelesen): `struct MessRetryKonfig { std::uint32_t
  max_versuche = 5; }` + `mit_mess_retry` (Schleife `for v=1..budget`, `if (!hart_gescheitert(...))
  return` = Stop bei Erfolg; `out.erschoepft = true` + laute `[t15b-retry] ... Budget erschoepft`-
  Meldung; 0->1-Normalisierung `versuche_mindestens_einer()`).
- Mess-Seite: Iterator-Dispatch klammert `measure_one_binary` zwischen `// [T-15B-RETRY]` und
  `// [T-15B-RETRY-ENDE]` mit `mit_mess_retry(cfg.mess_retry, ...)` (Diff-Hunk @@ -3203,12
  +3248,50 @@).
- Bau-Seite: `build_orchestrator.hpp` `BuildConfig::bau_max_versuche = 5` (eigenes Feld) +
  `[T-15B-BAU-KLAMMER]`-Schleife um Quelle-schreiben + `compile_` (`bau_budget = cfg_.bau_max_
  versuche == 0u ? 1u : ...`), `dauer_s = bau_dauer_summe` (SUMME), `message += " (t15b: N
  Versuche)"` nur bei >1; `dll_is_current`-Skip (A) und Gate-Ablehnungen (-4) liegen VOR der
  Klammer.
- ZWEI getrennte Budgets DERSELBEN Groesse, EINE Quelle: Iterator `bcfg.bau_max_versuche =
  cfg.mess_retry.max_versuche` (Diff-Hunk @@ -2174,6 +2202,9 @@). Keine 1+5-Zaehlung.
- M3-Rot ("Erfolg sofort: Versuche = 5 (erwartet 1)") = Berichts-Literal; der Test-Abschnitt (1)
  traegt exakt die Zusicherung, die M3 bricht (`eq("Erfolg sofort: Versuche", sofort.versuche, 1)`).

### P-02 — 3 Wiederholungen je Parameter+Binary EINZELN persistiert (KF-10) — **ERFUELLT (Verify, kein Neubau — deckungsgleich mit KON37-06 "KF-10 bestaetigt")**
- Am Tip gemessen: `cache_engine_builder_iterator.hpp:127` `std::uint32_t n_repeats = 3;` ·
  `:766` `lazy_extract_repetition` · `:825` `zelle_sep(lazy_extract_repetition(row.setting_label))`.
- S-2-Spannung der Soll-Karte (ABNAHME "ausgefuehrt und dokumentiert" vs. Verify): KON37-06 selbst
  nennt es "KF-10 bestaetigt" — Owner-/KON-Schicht rangiert vor der ABNAHME-Formel-Lesart; die
  3-Werte-Zaehlung ist zudem im NEUEN Test real gefahren (Abschnitt 3b: "3 Drift-Proben (Werte)" +
  "6 rohe Laeufe fuer 3 Werte (KON47-04)"). Kein Fund.

### P-03 — Umzug der 5 Drift-Achse -> Binary-Retry-Achse — **ERFUELLT**
- `drift_gated_cell.hpp`: `std::uint32_t max_reruns = 3;` mit LAUTEM Umzugs-Kommentar
  ("DEFAULT-RUECKBAU 5 -> 3 (KON26-04, OWNER-ENTSCHEIDEN, 2026-08-20 vollzogen -- LAUT, nicht
  still)"), Register-S5-06 "DATIERT UEBERHOLT" benannt.
- `xml_config_parser.cpp`: Attr-Default `dg->attr("max_reruns", "3")` (vorher "5") mit
  KON26-04-Kommentar; `xml_config_parser.hpp` Feld-Default `drift_gate_max_reruns = 3`.
- Pins: test_t15 Abschnitt (6) umgeschrieben — `eq("Default max_reruns (Mechanismus-3; die 5 ist
  umgezogen)", d.max_reruns, 3)` + `eq("LazyRunConfig max_reruns", ..., 3)` + NEU
  `eq("MessRetryKonfig::max_versuche (Owner-Zahl 5, umgezogen)", rk.max_versuche, 5)` +
  `eq("LazyRunConfig::mess_retry traegt dieselbe 5", ..., 5)` + Paar-Pflicht-Pin.
- Die XML-Pins des Alt-Tests bei :400ff (am Tip gelesen) nutzen EXPLIZITE Nicht-Default-Werte
  (`reps="4" threshold_permille="37" max_reruns="7"`) — vom Attr-Default-Umzug unberuehrt, korrekt
  unveraendert; der Attr-Default-3-Beweis liegt im NEUEN Test (Abschnitt 5, Profil OHNE
  max_reruns-Attribut -> 3). M5-Rot = Berichts-Literal, Pin dazu am Objekt vorhanden.

### P-04 — 8-Punkte-Ripple KON26-04 — **ERFUELLT (7/8 am Objekt; Punkt 8 auftragsgemaess ENTWURF)**
1. drift_gated_cell Kommentar+Rueckbau: ERFUELLT (s. P-03/P-05).
2. Iterator :372-383 (Stand 4cd1ab91) = LazyRunConfig-Region: ERFUELLT — Diff-Hunk @@ -391,10
   +397,24 @@ traegt Drift-Doku-Anpassung + NEU `MessRetryKonfig mess_retry{}` +
   `bool mess_kaltlauf_debug = false` mit SELBSTCHECK-Abgrenzung (nicht max_reruns/n_repeats).
3. xml_config_parser eigenes Attribut: ERFUELLT — NEUES Element `<binary_retry max_versuche="5"/>`
   (`root->child("binary_retry")`, declared-Muster, `< 1 => return std::nullopt` = Profil
   unlesbar), NICHT am drift_gate.
4. planner_mengen_types NEUER Kostenfaktor: ERFUELLT — `MengenEingang::t15b_max_versuche = 5` +
   `t15b_aus_xml`; MessMengenSicht: `paar_faktor`, `t15b_retry_faktor`, `arena_gesamt_faktor`;
   Faktor-Zeilen `fak("paar_faktor", ...)` / `fak("t15b_retry_max_versuche", ...)` /
   `fak("arena_gesamt_faktor", ... "Vorgabewerte 12*2*5=120 (D.7-Entscheid KON26-04 ...)")`;
   `mul_sicher`-Ueberlauf-Wache VOR der Multiplikation; Schlusszeile `check_size ...
   paar_faktor=... t15b_retry=... arena_gesamt_faktor=...`.
5. checkpoint_speicher Arena-Formel x5 ZUSAETZLICH: ERFUELLT (s. P-06).
6. profile_run_facade-Uebertragungspunkte: ERFUELLT — `profile_run_entry.hpp`: `if
   (tp.binary_retry_declared) cfg.mess_retry.max_versuche = ...` + `cfg.mess_kaltlauf_debug =
   ex::resolve_mess_kaltlauf_debug(...)`; `experiment_run_entry.hpp`: Spiegel (Kaltlauf-Resolver;
   Experiment-Root traegt kein binary_retry -> Owner-Default 5, dokumentiert);
   `profile_run_facade.cpp` `collect_mess_menge_facade`: XML-Lage + Rueckfall
   `ex::MessRetryKonfig{}.max_versuche` ("keine zweite Wahrheit").
7. Test-Pin umschreiben + neuer Test: ERFUELLT — test_t15 (6) neu; NEU
   `test_t15b_retry_warmup_paar.cpp` (472 Z., voll gelesen; 72 Zusicherungen — s. Abschnitt 2(d)).
8. Register S5-06 datiert korrigieren: AUFTRAGSGEMAESS NUR ENTWURF (super = Lead-only; Entwurf im
   Strang-Bericht Z.219-221; F-13 traegt es OFFEN-mit-Entwurf). Kein Fund.

### P-05 — C-07-Begriffs-Kanon + CI-Gate — **ERFUELLT**
- `drift_gated_cell.hpp`-Kopf: neuer C-07-BEGRIFFS-KANON-Block (T-15a = KAMPAGNE/KON19-06;
  T-15b = 5 Versuche des GESAMTEN Pruefdock-Durchlaufs EINER Tier-Binary; Drift-Rerun = dritte
  Groesse) — die fruehere "Undefiniertheit von 'ganzer Lauf'" ausdruecklich GESCHLOSSEN.
- CI-Gate-Satz woertlich im Kopf: "die ctest-Registrierung von test_t15_drift_gate_messschleife +
  test_t15b_retry_warmup_paar IST das Gate -- jede CI-Testzelle faehrt ctest; ein eigener
  YAML-Job waere eine zweite Wahrheit." Derselbe Kanon im Kopf von mess_retry_klammer.hpp.
  YAML unberuehrt (TABU eingehalten, s. Abschnitt 2(b)).

### P-06 — Arena-Formel x5 ZUSAETZLICH / D.7-Entscheid — **ERFUELLT**
- `planner_mengen_types.hpp`: `arena_gesamt_faktor = drift_faktor * paar_faktor *
  t15b_retry_faktor` (Default 12*2*5 = 120; `drift_faktor_rechnen(3,3) = 3*(3+1) = 12`,
  MengenEingang-Default `drift_max_reruns = 3`); Kapazitaet rechnet
  `kapazitaet_zeilen_rechnen(e.n_ops, s.zeilen_je_op, s.arena_gesamt_faktor)`;
  D.7-HISTORIE+ENTSCHEID im Kopf ("DER BESTANDS-WIDERSPRUCH (D.7) IST ENTSCHIEDEN (20.08.2026)");
  Punkt-4-Berichtstext umgeschrieben ("bestands-widerspruch (D.7) ENTSCHIEDEN 20.08.2026").
- `checkpoint_speicher.hpp` Formel-Doku am Symbol-Anker `kapazitaet_zeilen_rechnen`: drei
  Vervielfacher einzeln benannt, KON26-04 "muss diesen binary-weiten x5 ZUSAETZLICH decken,
  sonst ist sie unterdimensioniert (KON26-04 woertlich)"; "12 * 2 * 5 = 120 Durchlaeufe je Zelle".
- `mess_arena.hpp:222ff`: Faktor-2-Kommentar KORRIGIERT ("KORRIGIERT 20.08.2026 (D.7-Entscheid,
  KON92 C7): hier stand '* 2 (Sicherheitsfaktor 2)' -- eine STALE Fruehfassung ...").
- `ops_gesamt` traegt `* paar_faktor`, NICHT `* retry` — Kommentar begruendet (Fehlerpfad, keine
  Erwartungs-Groesse). G5h-Wache: test_check_size neuer Block (`drift_max_reruns = 2^62-1` ->
  `s.ueberlauf` + Grund "drift_faktor * paar_faktor").
- **Antwort auf die Soll-Karte-Audit-Frage (S-1: 120er-Faktor vs. 6GB-fest orthogonal?)**:
  NICHT orthogonal, sondern sauber GEKOPPELT ueber die Byte-Rechnung `zeilen * 32 B`:
  Voll-Katalog-Beispiel am Objekt: 131072 Ops x 40 Zeilen/Op x 32 B = 167.772.160 B (160 MiB)
  x 120 (Default) = 20.132.659.200 B = **18,75 GiB**, x 180 (check_size-Eingang 18*2*5) =
  28,12 GiB — beide UEBER dem 6-GB-fest-Deckel (KON93-02). Das Objekt liefert dafuer den
  ehrlichen Schnittstellen-Mechanismus (Deckel-Urteil GERISSEN, G1-Beweis am neuen Orakel
  230399 < 230400); die Aufloesung (Folgeblatt/DRAIN statt Wurf) ist per KON92 den Arena-Posten
  E1-E10 im S-13/#18-Buendel zugewiesen. S-13 BRAUCHT den 120er-Faktor als Eingangsgroesse
  (er bestimmt die Ueberlauf-Frequenz des 6-GB-Fensters) — der Traeger existiert (E1-E10 +
  H-5/F-10-Zahlen-Nachzug), die Zahl 18,75 GiB @ Default-120 gehoert als Rohdatum an S-13.
  KEIN Fund (Traeger dokumentiert), aber Synthese-Rohdatum.

### P-07 — C-11 hart/soft vollstaendig — **ERFUELLT**
- Trigger-Praedikat `mess_durchlauf_hart_gescheitert<Outcome,Status>`: `oc.load_failed > 0` ODER
  `row.sample_status == failed_status` — liest NIE ein Verfuegbarkeits-Flag (Kommentar +
  Soft-Koeder-Zusicherung "SOFT-Koeder: PMC fehlt -> KEIN Trigger (kein Retry)" im Test,
  Zwilling traegt `pmc_available` als Deko-Feld, das das Praedikat nicht lesen darf).
- Soft-Kanal REAL bis in die xlsx: Iterator erhebt nach dem Mess-Fenster GENAU EINE Warnzeile je
  Lauf (`make_pmc_source()`-Probe, `available()`; `result.mess_warnungen.push_back("[C-11 soft]
  PMC-Messeinrichtung fehlt ...")`); `profile_run_entry` sammelt DEDUPLIZIERT ueber Paesse und
  reicht `warn_meta` (KonstantenMeta `mess_warnung_N`) in `mappe.schliessen(sysinfo, {},
  warn_meta)` -> INFO-Blatt. Test-Wachen (7b) pruefen BEIDE Glieder der Kette
  (`result.mess_warnungen.push_back` + `mappe.schliessen(sysinfo, {}, warn_meta)`).
- M4-Rot = Berichts-Literal; die Zusicherung dazu steht am Objekt (Abschnitt 2).
- GOAL-Kopplung eingehalten: nur CSV-/xlsx-Zellen-Ebene; kein CI-Job-Verhalten beruehrt, kein
  allow_failure (YAML nicht im Diff).

### P-08 — Warmup-Paar ALLE Messpfade, x3 = 6 Laeufe/3 Werte, --debug 1x kalt — **ERFUELLT**
- `harness/mess_warmup_paar.hpp` (NEU): `mess_warmup_paar(kaltlauf_debug, messlauf)` — debug:
  genau EIN Lauf; sonst `(void)messlauf();` (Lauf 1 echt verworfen, keiner Variablen zugefuehrt) +
  Lauf 2 als payload; `MessPaarBilanz{payload, laeufe, verworfen}` als Beweis-Traeger.
- ALLE Messpfade: die `[T-15-KLAMMER]`-Lambda in `run_cell_with_drift_gate` fuehrt
  `mess_warmup_paar(cfg.mess_kaltlauf_debug, ...)` um die EINE Stelle, durch die observable- UND
  workload-Pfad laufen (`workload_id.empty() ? run_observable_perm : run_workload_perm` liegt IM
  Paar-Lambda; Marker unveraendert in der Klammer). Test-Wache (7a): `mess_warmup_paar(` genau 1x
  im Iterator, kein `measure_one_binary(`-Aufruf ausserhalb der Retry-Marker.
- 6/3-Zahl real gefahren: Test 3b (`reps=3` stabil -> `zelle.messungen == 3` + `rohe == 6`);
  Gate-aus-Gegeneingang (1 Wert/2 Laeufe) + debug-Gegeneingang (1 roher Lauf). Abschnitt 4:
  Retry x Paar x Drift = 12 rohe Laeufe (2 Versuche x 3 Proben x 2).
- M0/M1/M2-Rots = Berichts-Literale; die brechenden Zusicherungen stehen woertlich am Objekt
  ("PAAR: das Skript lief wirklich zweimal", "PAAR: gespeichert ist LAUF 2 (Verwerf-Beweis)",
  "--debug: das Skript lief wirklich nur einmal", "6 rohe Laeufe fuer 3 Werte (KON47-04)").

### P-09 — Legacy run_observable_perm: ANPASSEN ODER AUSBUCHEN — **ERFUELLT (via KON47-04 "anpassen"; S-3-Spannung dokumentiert, kein Fund)**
- Gebaut: Kopf-Kommentar `perm_runner.hpp` "BAUSTEIN-ROLLE (C-05/KON47-04, 20.08.2026): diese
  Funktion ist der EINZELLAUF ... Die Warm-Pflicht liegt beim produktiven Aufrufer ... Es gibt
  damit KEINEN zweiten produktiven Kaltpfad; wer hier einen neuen Aufrufer ergaenzt, uebernimmt
  die Paar-Pflicht (Test: test_t15b_retry_warmup_paar, Quellen-Wache)." + Behelfs-CLI
  `apps/perm_runner/main.cpp` DEKLARIERT kalt/kein Kampagnenpfad.
- Die Gegenprobe "wer ruft ihn?" ist NICHT nur Prosa, sondern EINE BEISSENDE WACHE: Test (7d)
  `eq("perm_runner.hpp: run_observable_perm( genau 2x (Definition + Fallback)", ..., 2)` — ein
  DRITTES Vorkommen (neuer Kaltpfad) wird ROT.
- Wuerdigung der S-3-Spannung (T-12b ENTWEDER/ODER): Die Paar-Zaehlung INNERHALB von
  run_observable_perm waere am Objekt FALSCH gewesen — der Workload-Pfad (run_workload_perm ohne
  Fallback) liefe dann weiter kalt; die eine Klammer-Stelle in measure_under_setting ist der
  einzige Punkt, der BEIDE Pfade paart (KON47-04 "ALLE Messpfade"). Der T-12b-Koeder-Norm
  ("kalter Einzel-Lauf, der persistiert, wird ROT") ist am Produktionspfad erfuellt (M0 +
  Wachen 7a/7d). Rangfolge Owner/KON47-04 ("anpassen ODER ausbuchen") > Designplan-T-12b-
  Buchstabe. Rest-Wahrheit ehrlich benannt: DIREKTAUFRUFE (8 Testdateien + Behelfs-CLI) messen
  weiterhin kalt — deklariert, kein Produktions-Ziel, von der Zensus-Wache =2 festgehalten.

### P-10 — T-11a Testpflichten (Paar-Zaehlung / --debug-Zweig / Verwerf-Beweis) — **ERFUELLT**
- (1) Paar-Zaehlung 2x3: Abschnitt 3 (2 Laeufe/1 verworfen/Skript lief zweimal) + 3b (6 rohe
  Laeufe fuer 3 Werte, T-3-Nenner: KON-Text-Zahlen, nie gemittelt) — Koeder M0 rot (Literal im
  Bericht, inkl. beider [ERR]-Zeilen).
- (2) --debug-Zweig 1x: Abschnitt 3 (--debug 4 Zusicherungen) + 3b (--debug + Gate aus: genau 1
  roher Lauf) + Abschnitt 6 Resolver-Zusicherungen — Koeder M2 rot.
- (3) Verwerf-Beweis: `paar.payload == 222` (Lauf-1-Wert 111 unterscheidbar; T-4-Gegeneingang) —
  Koeder M1 rot ("gespeichert ist LAUF 2 (Verwerf-Beweis) = 111 (erwartet 222)").
- Vorbild two_phase_measure: Abgrenzung im mess_warmup_paar-Kopf dokumentiert (OP-Ebene KON45-03
  vs. Zell-Ebene dieses Paars).

### P-11 — T-11c Mutationsprotokoll — **ERFUELLT (Literal-Protokoll im Bericht; Koeder-Formen vorab benannt)**
- 6 Wegwerf-Mutationen M0-M5 mit literalen [ERR]-Zeilen im Strang-Bericht, alle revertiert,
  Endstand "== T-15b GRUEN ==" + ctest 511/511 + porcelain 0 (Berichts-Literale).
- Am Objekt: der Test-Kopf traegt das T-11c-PROTOKOLL (M1-M4 mit Abschnitts-Zuordnung) — die
  Koeder-FORM war VOR der Mutation benannt (T-11c-Norm); M0 (Paar-Zaehlung, Nachtrag einzeln)
  und M5 (Umzugs-Pin, test_t15) sind im Bericht einzeln literal dokumentiert. Jede
  Mutations-Behauptung hat ihre brechende Zusicherung nachweisbar am Objekt (oben je Punkt).
- Grenze ehrlich benannt: Rot-Laeufe sind fluechtige Ereignisse — Literale liegen im
  Strang-Bericht (dem vereinbarten Traeger), nicht als persistierte Logs. Kein Delta zum
  ueblichen Staffel-Standard (alle 18 Straenge fuehren Mutations-Rots so).

### P-12 — T-7 Registrierung ans CMakeLists-DATEIENDE — **ERFUELLT**
- `tests/unit/CMakeLists.txt`-Diff: EIN Block ans Dateiende (nach test_s6c...-Block), Tail-Probe
  am Tip bestaetigt: die letzten Zeilen der Datei SIND der t15b-Block (`add_executable` ...
  `add_test(NAME test_t15b_retry_warmup_paar ...)` ... `set_tests_properties(... LABELS
  "t15b;c05;retry;warmup-paar;messfenster;standalone;koeder")`). Kein Label mit
  'pmc'-Substring (F-43-Falle vermieden). "ctest -N zeigt #511" = Berichts-Literal; strukturelle
  Registrierung am Objekt verifiziert; H-1-Harmonisierung (alle Straenge ans selbe Dateiende) =
  getragener Lande-Zug-Posten, kein Fund.

### P-13 — T-11b 4-Zellen-Kombibau — **ERFUELLT als Deklaration (Lande-Zug-Norm, nicht Strang-Pflicht)**
- Strang deklariert BEIDE Mengen korrekt: gcc-Release-Zelle gedeckt; clang/Debug + 4-Zellen-
  Kombibau = Lande-Zug am gemergten Endstand (K17: CI nie Erstpruefung). Getragen (H-7/Phase 3
  der Lande-Reihenfolge). Kein Fund. (Siehe aber Fund A-1 zur J-1-Werkzeugliste desselben
  Gruen-Beweises.)

### P-14 — --debug streng disjunkt am RunMethodology-Praedikat (KON34-05) — **ERFUELLT (mit deklariertem Erreichbarkeits-Caveat)**
- `measure_parallelism.hpp`: `resolve_mess_kaltlauf_of_mode(m) = m.measurement_on &&
  !m.single_thread` + Token-Fassung `resolve_mess_kaltlauf_debug` (dieselbe EINE
  Registry-Nachschlage-Stelle, fail-closed).
- Am Objekt nachgemessen: `kWorkModeRegistry` traegt GENAU 4 Eintraege (build/measure/compare/
  release; `run_methodology_registry.hpp`), KEINER erfuellt das Praedikat (measure ist
  single_thread=true) => produktiv IMMER Paar-Pflicht; Test Abschnitt 6 prueft alle 4
  Registry-Zeilen + die kuenftige Injektion (WorkModeInfo{Measure, true, false} -> true) + den
  Gegeneingang (misst, aber 1-Thread -> false). --debug-CLI selbst = NICHT-GEFORDERT #5
  (Task #22(ii)/S-8). Beschleunigt/leitet nie um: der Schalter aendert nur Laufzahl, nie den
  Mess-Aufruf (Kommentar im Iterator + unveraenderte Argumente im Diff sichtbar).

### P-15 — Register S5-06 (super, Lead-only) — **ERFUELLT als ENTWURF (auftragsgemaess)**
- Entwurfstext im Strang-Bericht Z.219-221; super nicht angefasst (Diff enthaelt 0 super-/docs-
  Pfade). F-13 traegt OFFEN-mit-Entwurf. Kein Fund.

### P-16 — S-19-Zahlen 18->120 Nachzug — **ERFUELLT als deklarierte Cross-Strang-Pflicht**
- Eigener Abschnitt im Strang-Bericht (Z.200-206) + H-5/F-10 (LANDE-ZUG Pflicht, Eigentuemer
  measure_storage/#13); Lande-Reihenfolge messfenster (Schritt 1) VOR s19 (Schritt 2) in BEIDEN
  Synthesen. Getragen, kein Fund.

### P-17 — 6 Non-ASCII-Altkommentar-Zeilen im build_orchestrator-Diff — **ERFUELLT (deklariert; am Objekt nachgemessen, Zahlen praezisiert)**
- Nachmessung (BEIDE Mengen): Minus-Seite des build_orchestrator-Diffs traegt EXAKT **6**
  Non-ASCII-Zeilen (die "sechs mitgereisten" des Berichts, literal gelistet: die
  `[Infra-Fehler:…]`-Zeile mit Ellipse + 4 "NACH-Pruefung-Fix"-Kommentarzeilen mit
  Prüfung/—/zusätzlich/fälschlich/Rüge + die `§1`-Sidecar-Zeile); Plus-Seite traegt **5**
  (die >120-Umbruch-Zeile `[Infra-Fehler:...]` wurde dabei ASCII-fiziert — deckt die
  Berichts-Aussage "2 umgebrochene >120-Zeilen, dort ASCII-fiziert" fuer die Ellipsen-Zeile;
  die uebrigen 5 reisen byte-inhaltlich unveraendert re-eingerueckt). Alle 5 Plus-Zeilen sind
  BESTANDSTEXT (nur Einrueckung durch die Klammer-Schleife geaendert), 0 Non-ASCII in neu
  autorisierten Zeilen aller 20 Dateien (gesamter Diff gemessen: 5 Treffer, alle
  build_orchestrator). F-14 traegt die Lande-Zug-Sichtung. Kein neuer Fund; diese Messung ist
  das Rohdatum fuer die F-14-Sichtung.

### P-18 — clang-format-22 ueber jede geaenderte Lint-Datei — **ERFUELLT in der SUBSTANZ (vom Auditor nachgemessen); Berichts-Luecke = Fund A-2 (KLEIN)**
- Eigene Messung: alle 19 geaenderten .hpp/.cpp am Tip extrahiert, `~/.local/bin/clang-format-22
  --dry-run` (Ubuntu clang-format version 22.1.8) mit der Repo-.clang-format @ Tip:
  **0 von 19 Dateien mit Abweichung**. Die Formatierungs-Doktrin ist am Objekt erfuellt.
- Der Strang-Bericht erwaehnt einen Format-Lauf NIRGENDS (weder gefahren noch offen) — das ist
  eine Berichts-/Beweis-Luecke (Fund A-2, KLEIN), keine Objekt-Luecke.

### P-19 — Ref-Sicherung + EIN Schreiber — **ERFUELLT**
- `git ls-remote origin refs/heads/bau/messfenster` = `3a746090ae6a...` (Literal oben) — die
  Ref-Sicherung STEHT. Das `-o ci.skip`-Flag des historischen Pushes ist am Objekt nicht
  rueckwirkend messbar (NICHT-PRUEFBAR als Einzelaussage; kein Widerspruchsindiz — keine
  Branch-Pipeline im Berichtsumfeld erwaehnt, Doktrin-konform). Genau 1 Commit auf dem Branch
  (Basis..Tip), Autor/Committer "Claude Fable 5 <noreply@anthropic.com>", Trailer
  `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>` im Commit-Text vorhanden.

### P-20 — Nichts owner-gated gebaut — **ERFUELLT**
- LEAD-ENTSCHEIDE (87 Z. voll gelesen): kein Punkt benennt #13/T-15b/messfenster als gated;
  Punkt 11 bestaetigt im Gegenteil die C-08-Zuweisung an DIESEN Strang und verlegt C-09 als
  ANSCHLUSS-Auftrag NACH mess-fenster (NICHT-GEFORDERT #1 — am Diff bestaetigt:
  drift_detector.hpp NICHT beruehrt, keine RunMethodology-Verzweigung im Drift-Gate gebaut).
- D.7-Entscheid: per KON26-04 Punkt 5 + C-2-Zeile ("Eigentuemer measure_storage/#13") gedeckt,
  am Objekt vollzogen, nicht erfunden. Die 4 KON-Grundlagen (KON19-07/26-04/28-02/37-06/47-04)
  sind beantwortete Owner-Entscheide.

--------------------------------------------------------------------------------

## 2. ZUSATZ-PRUEFUNGEN (a)-(d)

### (a) TDD-Vertrag je neuem Test
- T-1 (Rot zuerst/Mutations-Beweis): 6 Wegwerf-Mutationen M0-M5 mit literalen Rots (Berichts-
  Literale; brechende Zusicherungen je Mutation am Objekt verifiziert). ERFUELLT.
- T-3 (Nenner fremd): test_check_size-Orakel VON HAND (GNU bc, ausserhalb) neu gerechnet und
  eingefroren — am Objekt verifiziert: A 7200/230400/17694720 · B 17694.72/0.2048 · H 320 MiB /
  28800 MiB / "Faktor ... exakt 90 (180/2)" + historischer 160-MiB-Anker als arena/paar ·
  G1/G2 230399/230400 · G4 204.8 Tage · G7 3600 · G9b 115200 — ALLE Berichts-Zahlen stimmen
  literal mit dem Diff ueberein. t15b-Zaehlungen tragen KON-Text-Nenner (2/6/12), kein
  Selbst-Orakel. ERFUELLT.
- T-4 (Gegeneingang): Verwerf-Beweis (Lauf-1-Wert 111 unterscheidbar), Gate-aus-/debug-
  Gegeneingaenge, kaputtes XML (max_versuche=0 -> unlesbar), SourceUnavailable-ZEILE ohne
  Zaehler -> kein Zeilen-Trigger, G-Reihe inkl. NEU G5h (Gesamt-Faktor-Ueberlauf mit praezisem
  2^62-1-Eingang, Wache-Identitaets-Pruefung am Grund-Text). ERFUELLT.
- T-7 (Registrierung): DATEIENDE-Block + add_test + COMDARE_TEST_TARGETS-Property am Objekt;
  ctest -N = Berichts-Literal. ERFUELLT.
- T-8 (atomar): Test + Minimalbau in EINEM Commit auf dem Feature-Branch. ERFUELLT.
- T-11c: s. P-11. ERFUELLT.

### (b) GOAL-/Prozess-Doktrinen
- TABU-Zonen: Datei-Liste des Diffs (20 Pfade, vollstaendig gesichtet) beruehrt WEDER axes/ NOCH
  topics/ NOCH heuristik/ NOCH golden-Dateien NOCH .gitlab-ci.yml. EINGEHALTEN.
- Ledger/Board/Memory: 0 docs/-Pfade im Diff; Register-Korrektur nur als ENTWURF. EINGEHALTEN.
- allow_failure: kein YAML im Diff; C-11-soft betrifft ausschliesslich CSV-/xlsx-Zellen-Ebene
  (Warnung ins INFO-Blatt), keine Job-Semantik. EINGEHALTEN.
- ASCII-only in neuen Zeilen: 5 Non-ASCII-Plus-Zeilen, ALLE re-eingerueckter BESTANDSTEXT im
  build_orchestrator (P-17, deklariert als F-14); 0 in neu autorisierten Zeilen. EINGEHALTEN
  (mit getragener F-14-Sichtungspflicht).
- Messdaten/golden byte-stabil: nicht beruehrt; "Build-Verzeichnis entfernt (git ls-files
  build/ = 0 UND find *.csv/*.xlsx = 0)" = Berichts-Literal, plausibel (Diff traegt keine
  build-/CSV-Pfade).
- Commit-Hygiene: Trailer vorhanden; Commit-Text stimmt inhaltlich mit dem Objekt ueberein
  (stichprobenweise gegengelesen, u.a. "72 Zusicherungen", "Pins 3/3+Owner-5-Umzug",
  "G5h-Ueberlauf-Wache", "Faktor 90/120/180-Rechnung").

### (c) Abnahme-Formeln woertlich
- C-2 "5x(Build+Messung) mit 3 Einzelwerten + Arena-Formel-x5 ausgefuehrt und dokumentiert;
  Soft/Hart gemessen": Build-Klammer (P-01) + Mess-Klammer (P-01) + KF-10-3-Werte (P-02,
  KON37-06-gedeckt als Verify + real gefahrene 3er-Zaehlung in 3b) + Arena-x5 (P-06, in
  Kapazitaet MULTIPLIZIERT + G5h + 12-Laeufe-Multiplikations-Test) + Soft/Hart per Testabschnitt
  2 + M4/M3 GEMESSEN (im ctest-Lauf ausgefuehrt). **ERFUELLT.**
- C-3 "Paar-Zaehlung 2x3, --debug 1x, Verwerf-Beweis getestet": Abschnitte 3/3b + M0/M2/M1.
  **ERFUELLT.**
- T-12b (Designplan): dritte Bau-Form, nach Rangfolge durch KON47-04 gedeckt; Koeder-Norm am
  Produktionspfad erfuellt; Rest ehrlich deklariert (P-09). **ERFUELLT mit dokumentierter
  S-3-Spannung.**

### (d) Bericht-Behauptungen am Objekt (Stichproben mit Nenner)
- "72 Zusicherungen": ARITHMETISCH BESTAETIGT — statische Zaehlung des Testcodes ergibt 68
  tr()/eq()-Aufrufe + 4 Registry-Schleifen-Zusicherungen (kWorkModeRegistry hat exakt 4
  Eintraege) = **72**. STIMMT.
- "MessRetryKonfig{max_versuche=5}" / "max_reruns 5->3" / "Attr-Default '5'->'3'" /
  "<binary_retry> eigenes Element, <1 => Profil unlesbar" / "GENAU 1 Zeile je Lauf" /
  "dauer_s=SUMME, message nennt Versuche, Budget-1-Pfad zeilen-identisch" /
  "dll_is_current-Skip + Gate-Ablehnungen NIE wiederholt" / "arena_gesamt_faktor 12*2*5=120" /
  "ops_gesamt x paar, NICHT x retry" / "Zensus-Wache genau 2" — ALLE am Diff/Tip literal
  verifiziert. STIMMEN.
- "sechs ... NICHT-ASCII-Altkommentar-Zeilen": Minus-Seite exakt 6, Plus-Seite 5 (P-17) — die
  Berichtszahl bezeichnet die mitgereisten BESTANDS-Zeilen korrekt. STIMMT (praezisiert).
- "ctest 511/511" (Basis 510 + 1 neue TU): konsistent mit Synthese-Nenner (S1: messfenster +1);
  die exakte 511 == 510+1 zeigt zugleich, dass KEINE bedingte Registrierung ausfiel
  (H-1-Fallenklasse). Als Berichts-Literal gefuehrt; frischer Lauf = Lande-Zug (K17).
- "J-1 6 Werkzeuge rc=0": **HAELT NICHT gegen die heutige Treppen-Doktrin** -> Fund A-1 (MILD),
  s.u. (Am Tip UND an der Basis existieren alle SIEBEN Doktrin-Werkzeuge; u.a.
  comdare_adhoc_emitter_cli in CMakeLists.txt:1665 @ 66de5c09.)

--------------------------------------------------------------------------------

## 3. FUNDE

### A-1 (MILD) — Gruen-Beweis faehrt J-1 mit "6 Werkzeuge" statt der doktrinalen SIEBEN; Werkzeug-Liste nicht benannt
- BELEG: mess-fenster-ergebnis.md Z.186 + Z.232 literal "J-1 6 Werkzeuge rc=0". Die geltende
  Bau-Treppe (Memory-Doktrin "VOLLBAU-LUECKEN = FALSCHES GRUEN" + Audit-REGELN dieser Strecke)
  nennt SIEBEN J-1-Werkzeuge (comdare_adhoc_emitter_cli, comdare_anatomy_codegen_cli,
  comdare_axis_registry_gen, comdare_catalog_codegen_cli, comdare_measurement_axis_registry_gen,
  comdare_overlay_source_hash_gen, comdare_system_axis_registry_gen). Alle sieben existieren an
  der Strang-BASIS 66de5c09 (Beleg: comdare_adhoc_emitter_cli @ 66de5c09:CMakeLists.txt:1665;
  je Werkzeug >=1 CMake-Treffer am Tip). Der Bericht nennt WEDER die sechs gebauten Namen NOCH
  das fehlende siebte — das gruene Gate deckt damit eine unbenannte Teilmenge (Doktrin: BEIDE
  Mengen nennen).
- SCHADENS-EINGRENZUNG (gemessen): `--target all` (2515 Schritte) + RE-CONFIGURE + ctest folgten;
  die Testzahl 511 == Basis 510 + exakt 1 zeigt, dass KEINE bedingte Registrierung ausfiel —
  das Objekt selbst traegt keinen beobachteten Schaden. Der Fund betrifft den BEWEIS, nicht die
  Mechanik.
- FIX_WEG: (1) Im Lande-Zug-Kombibau am gemergten Endstand (K17, ohnehin Pflicht — Phase 3/4 der
  Synthese-Reihenfolge) die J-1-Stufe EXPLIZIT mit allen SIEBEN Werkzeugen fahren
  (`cmake --build ... --target comdare_adhoc_emitter_cli comdare_anatomy_codegen_cli
  comdare_axis_registry_gen comdare_catalog_codegen_cli comdare_measurement_axis_registry_gen
  comdare_overlay_source_hash_gen comdare_system_axis_registry_gen`), dann RE-CONFIGURE ->
  Vollbau -> ctest; die Werkzeug-LISTE literal ins Lande-Protokoll. (2) Berichts-Nachtrag im
  Strang-Ergebnis (eine Zeile: welche 6 gefahren wurden bzw. Verweis auf den 7er-Endstand-Lauf) —
  Datei /home/comdare/backups-workflow/20260820-w2-sofortstaffel/mess-fenster-ergebnis.md,
  Abschnitt "Literale". Kein Code-Delta am Branch noetig.

### A-2 (KLEIN) — clang-format-22-Lauf im Strang-Bericht nicht ausgewiesen (Substanz am Objekt in Ordnung)
- BELEG: mess-fenster-ergebnis.md erwaehnt keinen Format-Lauf (0 Treffer "clang-format" im
  Bericht); die REGELN der Strecke verlangen clang-format-22 ueber jede geaenderte Lint-Datei.
  Eigene Nachmessung am Objekt: `~/.local/bin/clang-format-22 --dry-run` (22.1.8) ueber alle
  19 geaenderten .hpp/.cpp am Tip mit der Repo-.clang-format = **0 Abweichungen (0/19)** — die
  Substanz haelt, nur der Beweis fehlt im Bericht.
- FIX_WEG: Eine Beleg-Zeile in mess-fenster-ergebnis.md (Abschnitt "Literale") nachtragen:
  "clang-format-22 dry-run 0/19 Abweichungen (Audit-Nachmessung 22.08.)" ODER den Format-Stand
  im Lande-Zug-Protokoll (Phase 3, Warnungs-Review-Fenster) mitfuehren. Kein Code-Delta.

--------------------------------------------------------------------------------

## 4. GETRAGENE OFFENE POSTEN (KEINE neuen Funde — Traeger existiert, hier nur gelistet)

- F-10/H-5: S-19-Zahlen 18->120 beim s19-Merge nachziehen (Lande-Zug-Pflicht, Schritt 2).
- F-13: Register-S5-06-Korrektur einpflegen (super, Lead; Entwurf liegt im Strang-Bericht).
- F-14: Non-ASCII-Altzeilen-Sichtung im Lande-Zug (Diff-Hygiene push-lokal; Rohdatum dieses
  Audits: 6 Bestand-/5 Plus-Zeilen, alle build_orchestrator, literal gelistet in Abschnitt P-17).
- F-12: INFO-Blatt-Konsumenten-Posten S5-05 (bleibt bei seinem Traeger; C-11 ist jetzt realer
  Konsument).
- H-1..H-4: CMakeLists-Dateiende + Entry-/Iterator-/Parser-Harmonisierung beim seriellen Merge
  (messfenster = Schritt 1, setzt den Basisvertrag).
- T-11b/K17: 4-Zellen-Kombibau + voller ctest + Floor/Ratschen EINMAL am gemergten Endstand
  (H-7; dort Fund A-1-Fixweg mit abdecken).
- C-09 (Drift-Gate-Debug-Ausnahme): ANSCHLUSS-Auftrag nach Rueckkehr (LEAD-ENTSCHEIDE Punkt 11),
  am Objekt korrekt NICHT enthalten.
- Ledger-Zeilen-ENTWURF (Strang-Bericht §"LEDGER-ZEILEN") an KON120-Zug (Lead).
- S-13-Kopplung (P-06-Rohdatum fuer E1-E10): Default-120-Bedarf 18,75 GiB > 6-GB-fest —
  Folgeblatt-/DRAIN-Mechanik braucht den arena_gesamt_faktor als Eingang (Traeger KON92/E1-E10,
  S-13/#18-Buendel).

## 5. NICHT-PRUEFBAR (mit Grund)

- Historische Rot-Laeufe der Mutationen M0-M5 und die ctest-/Configure-RCs: fluechtige
  Lauf-Ereignisse, keine persistierten Logs im Berichtsordner — als Berichts-Literale gefuehrt;
  jede zugehoerige Zusicherung/Struktur am Objekt gegenverifiziert (Abschnitte P-01..P-11);
  endgueltige Frisch-Beweise = K17-Endstand (getragen).
- Das `-o ci.skip`-Flag des Original-Pushes: nicht rueckwirkend messbar; die Ref-Sicherung
  selbst ist ls-remote-bewiesen (P-19).

## 6. SELBSTCHECK DES AUDITS

Soll-Karte P-01..P-20 vollstaendig abgearbeitet (20/20, dreiwertig); alle 20 Diff-Dateien
gesichtet (16 im Volltext-Diff, 4 Tests inkl. 472-Z.-Neutest voll); Zusatzpruefungen (a)-(d)
gefahren; eigene Messungen: merge-base, ls-remote, Non-ASCII-Zaehlung (+5/-6), clang-format-22
0/19, Registry-4-Zaehlung, 72er-Arithmetik, 7-Werkzeuge-Existenz, Koppel-Rechnung 18,75 GiB.
Ledger/Board/Memory NICHT geschrieben; Vault nicht beruehrt; Hauptklon NUR gelesen; kein
Bau-Slot gezogen; /tmp-Arbeitskopien unter /tmp/audit-messfenster-fmt (wegwerfbar).
