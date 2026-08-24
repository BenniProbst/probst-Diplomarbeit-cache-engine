# SOLL-KARTE — Strang "mess-fenster" (#13/T-15b-Umzug + #38b/C-05 Warmup-Paar)

Erhoben von: Sonnet-max-Planungs-Erheber (NUR LESEN, kein Fix), 21.08.2026, fuer die W2-Audit-Fixverify-Sammelstrecke.
Objekt (gebaut, NICHT von mir verifiziert — Zitat aus dem Auftrag): ce `bau/messfenster` @ `3a746090`, Basis ce `66de5c09` / super `a7e8e151` / prt-art `777fff7`.
Strang-Bericht (voll gelesen): `/home/comdare/backups-workflow/20260820-w2-sofortstaffel/mess-fenster-ergebnis.md` (245 Z.).
Wahrheits-Rangfolge (Auftragsvorgabe): Owner-Wort > juengere KON > Wellenplan par.21-23 > par.17-20 > Designplan > W2-ABFOLGE-DESIGN > Strang-Bericht.

--------------------------------------------------------------------------------

## PRUEFLISTE

### P-01 — Retry-Klammer BUILD **und** MESSUNG je 5, NICHT 1+5

**WAS**: Owner verbatim (Ledger `KON37-06`, Z.7439): *"Es heisst ein build oder eine Messung duerfen je 5 Mal scheitern bis wir aufgeben"*. Kondensiert (Z.7444-7445): *"RETRY BUILD und MESSUNG duerfen JE 5 MAL scheitern -> dann aufgeben (die T-15b-Klammer gilt also fuer BEIDE Vorgaenge, je 5 -- nicht 1+5)"*. Wellenplan §19.3 C-06 (Z.2467-2468): *"5/5-Retry-Klammer: Build UND Messung je 5x; 3 Wiederholungen einzeln persistiert (KON37-06) -> #13 T-15b"*. Wellenplan §18.4 Zeile #13 (Z.2250): *"Retry-Klammer um measure_one_binary, je 5 fuer BUILD UND MESSUNG, 3 Werte einzeln"*. W2-ABFOLGE-DESIGN C-2 (Z.184-185): *"Retry-Klammer measure_one_binary je 5x BUILD+MESSUNG, 3 Werte einzeln persistiert"*.
**WIE PRUEFBAR**: `harness/mess_retry_klammer.hpp` (`MessRetryKonfig{max_versuche=5}`, `mit_mess_retry`) klammert `measure_one_binary` am Dispatch (Iterator, Marker `[T-15B-RETRY]`); `BuildConfig::bau_max_versuche=5` in `build_orchestrator.hpp` klammert `provision_core`s `compile_`-Schritt separat (Marker `[T-15B-BAU-KLAMMER]`) — ZWEI eigenstaendige 5er-Klammern, keine gemeinsame 1+5-Zaehlung. Test: `test_t15b_retry_warmup_paar` (Mutation M3 "Stop-bei-Erfolg entfernt" -> `[ERR] Erfolg sofort: Versuche = 5 (erwartet 1)`).
**BEHAUPTET**: JA — Strang-Bericht §2 (Bau vollzogen) + §"Literale" (ctest 511/511) + M3 literal rot dokumentiert.

### P-02 — Erfolg = 3 Wiederholungen je Parameter+Binary, ALLE 3 Werte EINZELN persistiert (KF-10)

**WAS**: KON37-06 (Z.7439-7440): *"eine Messung wird bei Erfolg insgesamt 3 Mal je Parameter und Binary wiederholt und alle 3 Werte EINZELN persistiert"*. Wellenplan §17.4 (Z.2176): *"Erfolg = 3 Wiederholungen je Parameter+Binary, alle 3 einzeln persistiert"*.
**WIE PRUEFBAR**: `LazyRunConfig::n_repeats` Default 3; CSV-Spalte `repetition`; `lazy_extract_repetition` (:746).
**BEHAUPTET**: JA, aber ausdruecklich als **Verify, kein Neubau**: Strang-Bericht Z.44-45 *"'3 Werte EINZELN persistiert' IST GEBAUT (KON37-06 'KF-10 bestaetigt' -- kein neuer Persistenz-Bau noetig, nur Verify)"*. Die W2-ABFOLGE-DESIGN-ABNAHME (Z.191-192, s. ABNAHME-FORMELN) verlangt "3 Einzelwerten ... ausgefuehrt und dokumentiert" — vom Strang als bereits-erfuellter Bestand behandelt, nicht neu gebaut. Audit-relevant: die ABNAHME-Formel selbst unterscheidet nicht zwischen "gebaut" und "verifiziert bereits vorhanden".

### P-03 — Umzug der "5" von der Drift-Achse auf die Binary-Retry-Achse

**WAS**: KON26-04 (Z.9058-9064): *"Commit ce `4cd1ab91` (09.08.) legte die 5 auf `DriftGateConfig::max_reruns` -- die falsche der zwei im Commit selbst dokumentierten Lesarten."* Wurzel-Korrektur KON19-07 (Z.9994-10008, aelteste/urspruengliche Owner-Antwort): *"bis zu 5 Wiederholungen = RETRY des GESAMTEN Messdurchlaufs der CEB eines Tier-Binaries AM PRUEFDOCK, bei FAILED"* vs. *"3 Wiederholungen = die normale success-Messung"* — **zwei verschiedene Mechanismen**; die eigene fruehere Zuordnung (5 auf Drift-`max_reruns`) wird dort vom Lead selbst als *"die falsche der beiden Lesarten"* zurueckgenommen. Wellenplan §19.3 C-08 (Z.2471-2472): *"Die 5 sitzt FALSCH auf der Drift-Achse (ce 4cd1ab91): Umzug + 8-Punkte-Ripple; Arena-Formel muss x5 ZUSAETZLICH decken (KON26-04) -> #13"*.
**WIE PRUEFBAR**: `drift_gated_cell.hpp:120` `max_reruns` Default 5->3; `xml_config_parser` `<drift_gate max_reruns>`-Attribut-Default "5"->"3"; Test-Pins in `test_t15_drift_gate_messschleife.cpp` (:252/:257/:409/:419 lt. Strang-Explore).
**BEHAUPTET**: JA — Strang-Bericht §2: *"drift_gated_cell.hpp: max_reruns 5->3 (KON26-04-Umzug, LAUT dokumentiert)"*; Mutation M5 ("Umzug rueckgaengig") literal rot: `[ERR] Default max_reruns (Mechanismus-3; die 5 ist umgezogen) = 5 (erwartet 3)`.

### P-04 — Der 8-Punkte-Ripple aus KON26-04 (Einzelposten-Pruefung)

**WAS** (KON26-04, Z.9070-9076, woertlich als Liste): *"(1) drift_gated_cell-Kommentar + Default-Rueckbau (OWNER-ENTSCHEID, nicht stillschweigend) (2) iterator :372-383 (3) xml_config_parser (eigenes Attribut fuer den Binary-Retry) (4) planner_mengen_types (NEUER Kostenfaktor) (5) checkpoint_speicher.hpp:119-123: die Arena-Formel ... muss den binary-weiten x5 ZUSAETZLICH decken -- sonst UNTERDIMENSIONIERT (6) profile_run_facade-Uebertragungspunkte (7) Test-Pin umschreiben + neuer Test (8) Register S5-06 datiert korrigieren."*
**WIE PRUEFBAR / BEHAUPTET je Punkt** (Strang-Bericht §2 Datei-Liste):
  1. drift_gated_cell.hpp Kommentar+Rueckbau — BEHAUPTET (siehe P-03).
  2. Iterator :372-383 — BEHAUPTET implizit ueber `LazyRunConfig::mess_retry`/`mess_kaltlauf_debug`-Einbau; nicht als eigene Zeile im Bericht ausgewiesen, in der Datei-Liste "iterator: ..." subsumiert.
  3. xml_config_parser eigenes Attribut — BEHAUPTET: `<binary_retry max_versuche="5"/>` NEUES Element (nicht Wiederverwendung des drift_gate-Attributs).
  4. planner_mengen_types NEUER Kostenfaktor — BEHAUPTET: `t15b_retry_max_versuche` + `paar_faktor` + `arena_gesamt_faktor`.
  5. checkpoint_speicher.hpp Arena-Formel x5 zusaetzlich — BEHAUPTET, s. P-06.
  6. profile_run_facade-Uebertragungspunkte — BEHAUPTET: `profile_run_entry`/`experiment_run_entry` uebernehmen `cfg.mess_retry` aus `tp.binary_retry_*`.
  7. Test-Pin + neuer Test — BEHAUPTET: `test_t15` (6 Pins umgeschrieben) + NEU `test_t15b_retry_warmup_paar` (72 Zusicherungen).
  8. Register S5-06 datiert korrigieren — **NICHT vollzogen, nur ENTWURF**: Strang-Bericht erklaert explizit "REGISTER-KORREKTUR (super, S5-06, ...)" als Entwurfstext fuer den Lead, da super ausserhalb des ce-Worktrees liegt; s. P-16/NICHT-GEFORDERT.

### P-05 — C-07-Begriffs-Kanon praezisieren + CI-Gate ergaenzen

**WAS**: Wellenplan §19.3 C-07 (Z.2469-2470): *"T-15-Luecken: Granularitaet 'ganzen Lauf neu starten' UNDEFINIERT; 'bis zu 5 Wiederholungen' zweideutig; T-15 kein CI-Gate (Z15411-15455) -> #13"*. Strang-Bericht selbst zitiert den C-07-Kanon-Kopf (§1.1, Z.80-83): *"T-15a 'ganzer Lauf neu' = die KAMPAGNE (KON19-06 = ALLES); T-15b 'bis zu 5 Wiederholungen' = 5 Versuche des GESAMTEN Pruefdock-Durchlaufs EINER Tier-Binary; 'T-15 kein CI-Gate' -> die neuen ctest-registrierten Tests SIND das CI-Gate"*.
**WIE PRUEFBAR**: `drift_gated_cell.hpp`-Kopf-Kommentar (C-07-Kanon-Text) + `ctest -N` zeigt den registrierten Test als das faktische CI-Gate (kein YAML-Gate, YAML ist fuer diesen Strang laut Auftrag TABU/#106-only).
**BEHAUPTET**: JA — Strang-Bericht §2: *"drift_gated_cell.hpp: ... + C-07-Kanon im Kopf (T-15a=KAMPAGNE/KON19-06 · T-15b=Binary-Retry · Drift-Rerun=dritte Groesse; CI-Gate=ctest-Registrierung)"*.

### P-06 — Arena-Formel x5 ZUSAETZLICH / D.7-Entscheid (arena_gesamt_faktor)

**WAS**: KON26-04 Punkt 5 (s. P-04); Wellenplan §19.3 C-08 (s. P-03); W2-ABFOLGE-DESIGN C-2 (Z.186-189): *"Arena-Formel x5 ZUSAETZLICH (checkpoint_speicher, Symbol-Anker); ... D.7-Arena-Widerspruch (Faktor 2 vs. bis 18) -- Eigentuemer measure_storage/#13, S-19 druckt beide Lesarten"*.
**WIE PRUEFBAR**: `planner_mengen_types.hpp` Zeile `arena_gesamt_faktor = drift_faktor(12) * paar_faktor(2) * retry(5) = 120` (Default, statt vorher 18); `checkpoint_speicher.hpp` Formel-Doku am Symbol-Anker `kapazitaet_zeilen_rechnen`; `mess_arena.hpp:222-224` Faktor-2-Kommentar korrigiert. Wache `G5h` (Ueberlauf-Wache im Test).
**BEHAUPTET**: JA — Strang-Bericht §2 + eigener Abschnitt "Arena-x5-Zusatzdeckung + S-19-KOPPLUNG": *"Drift-Default-Faktor 12 (3*(3+1)), Paar 2, Retry 5 => arena_gesamt_faktor 120 ... D.7-ENTSCHEID VOLLZOGEN (Eigentuemer measure_storage/#13)"*.
**AUDIT-HINWEIS (Eigentums-Grenze, s. SPANNUNGEN)**: Der Ledger traegt eine JUENGERE (16.08.) Owner-Entscheidung `KON93-02`, die die Arena-KAPAZITAET (in GB, nicht der hier gebaute Zeilen-Multiplikator) auf **6GB fest** setzt und deren BAU-Posten (`E1-E10`, `KON92`) ausdruecklich dem **S-13/#18-Buendel** zuweist. Der Strang hat dies selbst erhoben (Explore-Notiz Z.78-79 zitiert KON92) und die eigene Arbeit als disjunkt davon eingeordnet — die spaetere Staffel1/2-Synthese (20./21.08., juenger als KON92/93-02) bestaetigt diese Abgrenzung (F-09 BEHOBEN ohne Vorbehalt; F-93/STAFFEL2 dedupliziert die Faktor-2-Kommentarkorrektur explizit als "F-08 BEHOBEN messfenster" und weist die NACHBAR-Divergenz "OP-1-Kommentar" bei `mess_arena.hpp:88-91` separat S13-07 zu). Die Grenze ist damit **durch die juengste Schicht bestaetigt**, aber die zugrundeliegende KON93-02-Owner-Entscheidung selbst nennt den Strang nirgends — Audit sollte pruefen, ob "arena_gesamt_faktor=120" (Zeilen-/Wiederholungs-Dimension) und "6GB fest" (Byte-Dimension) tatsaechlich orthogonal sind oder ob S-13 beim Bau von E1-E10 den 120er-Faktor als Eingangsgroesse braucht.

### P-07 — C-11 hart/soft vollstaendig

**WAS**: Owner verbatim `KON28-02` (Z.8816-8822): *"Die Einstellungen der Achsen failen immer hart, bis auf fehlende Messeinrichtungen auf der Mess-Achsen-Kategorie (wie ein fehlendes PMC soft fail). Daher scheitert die Messung bei hartem Fehler fuer die Binary komplett und bei soft Fehler wird sie wie geplant als Warnung in die xlsx mit eingetragen, aber die Binary wird gebaut, die Messung so weit es geht durchgefuehrt."* Formalisiert (Z.8824-8832): HART (Default) -> Retry-Klammer greift (bis 5) -> nach Erschoepfung "failed" in die Zelle, Lauf misst weiter; SOFT (einzige Ausnahme: fehlende PMC-Messeinrichtung) -> Warnung in xlsx, Binary WIRD gebaut, Messung so weit es geht, KEIN Retry. Wellenplan §19.3 C-11 (Z.2479-2480): *"HART/SOFT: Achsen failen IMMER hart; NUR fehlende Messeinrichtung (PMC) soft = Warnung in die xlsx, Binary WIRD gebaut (KON28-02) -> T-15b/#13"*.
**WIE PRUEFBAR**: `mess_durchlauf_hart_gescheitert<Outcome,Status>` (Praedikat: `load_failed>0` ODER irgendeine Zeile `SampleStatus::Failed`) triggert die Retry-Klammer; PMC-Soft-Pfad: `LazyRunResult::mess_warnungen` + Dispatch-Erhebung -> `mappe.schliessen(sysinfo, {}, warn_meta)` -> INFO-Blatt (`ergebnis_mappe_naht.hpp:616-627`, `MappenNaht::schliessen`). Test-Koeder M4 (Soft triggert jede Zeile) muss ROT werden.
**BEHAUPTET**: JA — Strang-Bericht §2 (iterator: `LazyRunResult::mess_warnungen + C-11-Erhebung (make_pmc_source-Probe, GENAU 1 Zeile je Lauf)`; `profile_run_entry`: Warn-Sammlung dedupliziert) + M4 literal rot (`[ERR] SOFT-Koeder: PMC fehlt -> KEIN Trigger (kein Retry)`). Praezisierung im Wiederanlauf-2-Log (Z.126-129): die Warnung kommt **REAL** im INFO-Blatt an (nicht nur als Traeger-Typ ohne Konsument), da `MappenNaht::schliessen` existiert.

### P-08 — Warmup-Paar (#38b/C-05/C-3): ALLE Messpfade, x3 = 6 Laeufe/3 Werte, --debug 1x kalt

**WAS**: Owner verbatim `KON47-04` (Z.6571-6574, 🔴 im Ledger markiert): *"Cache Warmup ist so gebaut, dass immer 3 mal folgendes passiert: Es wird einmal gemessen und verworfen, es wird einmal gemessen und mit warmem cache gespeichert. Das ist Pflicht fuer die Forschung, muss getestet sein, kann bei --debug auf kaltem Cache laufen also nur einmal. SONST IMMER ZWEI MAL."* Wellenplan §18.4 Zeile #38b (Z.2251, 🔴 im Wellenplan markiert): *"Warmup-PAAR durchsetzen: ALLE Messpfade fahren (verwerfen+speichern)x3; Legacy run_observable_perm misst am Objekt KALT ... -> anpassen oder ausbuchen; Tests T-1...T-9"*. W2-ABFOLGE-DESIGN C-3 (Z.193-197): *"ALLE Messpfade (verwerfen+speichern)x3; --debug 1x; Legacy run_observable_perm misst KALT -> anpassen ODER ausbuchen + Tests T-1..T-9"*.
**WIE PRUEFBAR**: `harness/mess_warmup_paar.hpp` (`MessPaarBilanz` + `mess_warmup_paar`: Lauf 1 verworfen, Lauf 2 gespeichert; --debug 1x kalt); `[T-15-KLAMMER]`-Lambda in `measure_under_setting` nutzt `paar_lauf` fuer BEIDE Messpfade (observable+workload). Test-Koeder M0 (nur ein Lauf) + M1 (Lauf-1 gespeichert) + M2 (--debug 2 Laeufe).
**BEHAUPTET**: JA — Strang-Bericht §2 + 3 Koeder literal rot (M0: `[ERR] PAAR: das Skript lief wirklich zweimal = 1 (erwartet 2)` + `[ERR] 6 rohe Laeufe fuer 3 Werte (KON47-04) = 3 (erwartet 6)`; M1: `[ERR] PAAR: gespeichert ist LAUF 2 (Verwerf-Beweis) = 111 (erwartet 222)`; M2: `[ERR] --debug: das Skript lief wirklich nur einmal = 2 (erwartet 1)` + 2 weitere).

### P-09 — Legacy-Pfad run_observable_perm: ANPASSEN ODER AUSBUCHEN

**WAS**: KON47-04 (Z.6588-6590): *"der Legacy-Pfad run_observable_perm misst heute KALT -> anpassen oder ausbuchen"*. Designplan §11 T-12b (Z.669-674, woertlich): *"Legacy-Pfad run_observable_perm misst heute KALT (perm_runner.hpp:207,213). GEZAEHLTE Pflicht: ENTWEDER Paar-Zaehlung 2x3 = 6 Laeufe / 3 Werte auch am Legacy-Pfad (T-11a-Norm, Koeder: kalter Einzel-Lauf, der persistiert, wird ROT) ODER ein Ausbuchungs-Beweis, dass der Pfad von keinem Produktions-Ziel mehr gefahren wird (Nullbefund NUR mit Gegenprobe 'wer ruft ihn?')."*
**WIE PRUEFBAR**: `perm_runner.hpp` `run_observable_perm`-Kopf-Kommentar (Baustein-Rolle: Einzellauf, kalt, Klammer-Pflicht) + Aufrufer-Zensus (Nenner: alle `*.hpp/*.cpp` ausser `build*`): produktiv NUR ueber die `[T-15-KLAMMER]`-Lambda + einen weiteren internen Fallback, beide selbst wieder INNERHALB der Klammer erreicht; `apps/perm_runner/main.cpp` = Behelfs-CLI (deklariert, kein Kampagnenpfad); 8 Testdateien.
**BEHAUPTET**: JA, aber ueber eine **DRITTE Option**, die im Designplan-Wortlaut nicht explizit vorgesehen ist: weder volle Paar-Zaehlung INNERHALB der Funktion selbst noch eine Ausbuchung — sondern eine Kopf-Kommentar-Deklaration ("Baustein-Rolle") plus Aufrufer-Zensus, kombiniert mit der Tatsache, dass jeder produktive Aufrufer bereits von aussen (der `[T-15-KLAMMER]`-Lambda via `mess_warmup_paar`) gepaart wird. Strang-Bericht nennt dies selbst *"ANPASSUNG statt Ausbuchung (KON47-04-Alternative erfuellt)"*. **AUDIT-FRAGE**: erfuellt "Anpassung durch Deklaration+Zensus" den Buchstaben von T-12b (ENTWEDER/ODER), obwohl `run_observable_perm` bei EINEM DIREKTEN Aufruf (z.B. aus einem der 8 Testdateien oder der Behelfs-CLI) weiterhin kalt misst? Der Test-Zensus beweist nur die AUFRUFER-ANZAHL, nicht dass die Funktion selbst warm misst.

### P-10 — T-11a Testpflichten (3 Teile: Paar-Zaehlung, --debug-Zweig, Verwerf-Beweis)

**WAS**: Designplan §11 T-11a (Z.640-643, voll woertlich): *"der Warmup ist ein PAAR (Lauf 1 messen+VERWERFEN, Lauf 2 messen+SPEICHERN), x3 Wiederholungen = 6 Laeufe, 3 persistierte Werte. (1) Paar-Zaehlung 2x3: der Test weist genau 6 Messaufrufe und 3 persistierte Werte nach (T-3 Nenner: die 3 einzeln, nie gemittelt -- KF-10); Koeder: eine Fassung mit nur 3 Laeufen ODER 1 persistiertem Wert wird ROT. (2) --debug-Zweig 1x: unter --debug laeuft es genau einmal, kalter Cache (Verzweigung am RunMethodology-Flag, quer, KON34-05 -- beschleunigt, leitet nie um); Koeder: --debug mit 2 Laeufen wird ROT. (3) Verwerf-Beweis: der Wert aus Lauf 1 (Warmup) erscheint nicht im persistierten Satz; Koeder: eine Fassung, die Lauf 1 speichert, wird ROT (T-4 Gegeneingang). Vorbild two_phase_measure."*
**WIE PRUEFBAR**: 3 dedizierte Wegwerf-Mutationen (T-1/T-11c-Norm).
**BEHAUPTET**: JA — alle 3 Koeder als M0/M2/M1 literal rot dokumentiert (s. P-08).

### P-11 — T-11c Mutationsprotokoll je NEUEM Test

**WAS**: Designplan §3 T-1 + §11 T-11c (Z.647, voll woertlich): *"der Biss jedes neuen Tests wird per protokollierter Wegwerf-Mutation belegt (Rot gesehen, dann zurueckgenommen) -- und die Koeder-LAENGE/-FORM wird geprueft, BEVOR die Mutation zaehlt ... GEZAEHLTE Pflicht je Paket: je neuem Test >=1 Wegwerf-Mutation mit literalem Rot + Gegenprobe-Gruen"*.
**WIE PRUEFBAR**: Literal-rot-Meldungen + Revert + Endstand-Gruenlauf.
**BEHAUPTET**: JA — 6 Mutationen M0-M5 (Retry-Stop M3, Soft-Koeder M4, Umzug-rueckgaengig M5, Paar-Zaehlung M0, Lauf-1-gespeichert M1, --debug-2-Laeufe M2), alle mit literalem `[ERR]`-Text, alle revertiert, Endstand `"== T-15b GRUEN =="` + `ctest 511/511` + `porcelain 0`.

### P-12 — T-7 Registrierung ans CMakeLists-Ende, ctest -N zeigt den Test

**WAS**: Designplan §3 T-7: *"Ein Test existiert erst, wenn er in ctest -N erscheint und sein Binary im Bauweg haengt"*. REGELN dieser Session: *"tests/unit/CMakeLists.txt NUR ans DATEIENDE"*.
**WIE PRUEFBAR**: `tests/unit/CMakeLists.txt`-Dateiende-Block; `ctest -N`.
**BEHAUPTET**: JA — *"Registrierung am DATEIENDE von tests/unit/CMakeLists.txt; ctest -N zeigt Test #511 (T-7)"*. **Cross-Strang-Hinweis (H-1, STAFFEL1-SYNTHESE Z.36-41)**: ALLE 5 ce-Zweige der Staffel haengen ihren Block ans selbe Dateiende an (messfenster +1 Test); beim Landen entsteht derselbe Konfliktort bei jedem Merge nach dem ersten — Endstand-Soll 520 Tests (Basis 510+10). Das ist eine erwartete, bereits dokumentierte Harmonisierungspflicht, kein Fund.

### P-13 — T-11b Kombibau 4-Zellen als Wellen-Abnahme-Norm (NICHT im Strang selbst zu leisten)

**WAS**: Designplan §11 T-11b: *"jede Landung ist erst gruen, wenn {clang, gcc} x {Debug, Release} = 4 Zellen je J-1...J-4 + ctest durchlaufen ... Abnahme-Regel, kein Einzeltest-Posten: sie gehoert in die Wellen-Abnahme jedes Stempel-/Mess-Pakets."* K17-Doktrin (REGELN dieser Session + LEAD-ENTSCHEIDE-Praeambel).
**WIE PRUEFBAR**: 4-Zellen-Kombibau am GEMERGTEN Endstand (nicht am Feature-Branch).
**BEHAUPTET**: Strang liefert nur die gcc-Release-Zelle lokal (`ctest 511/511`) und erklaert explizit: *"Dieses Gate deckt: die gcc-Release-Zelle dieses Zweigs; NICHT gedeckt: clang/Debug-Zellen + T-11b-4-Zellen-Kombibau = Lande-Zug am gemergten Endstand (K17-Regel: CI nie Erstpruefung -- lokale Erstpruefung ist gefahren)"*. Korrekt als OFFEN/Lande-Zug deklariert, kein Fehlbefund.

### P-14 — --debug / Mess-Schalter streng disjunkt (KON34-05) am RunMethodology-Praedikat

**WAS**: Owner-Ableitung `KON34-05` (Z.8393-8395): *"--debug ist CLI-Flag auf der Planer-Shell, orthogonal zu allen vier States, wirkt auf die Auspraegung (max. Threads, Jitter-Pruefer aus), NIE auf Reihenfolge oder Abhaengigkeiten -- darf alles beschleunigen und nichts umleiten."* KON47-04: *"der --debug-Zweig verzweigt am RunMethodology-Flag (quer, KON34-05)"*.
**WIE PRUEFBAR**: `measure_parallelism.hpp` `resolve_mess_kaltlauf_of_mode`/`_debug` am Praedikat `measurement_on && !single_thread`.
**BEHAUPTET**: JA, verdrahtet — ABER mit erheblichem Erreichbarkeits-Caveat, den der Strang selbst offenlegt (Explore §1.1, Z.59-63): *"debug ist AUSGEBAUT (A-05/V-12) -- das Praedikat 'misst UND parallel' (measurement_on && !single_thread) erfuellt heute KEINE Registry-Zeile; Zugang kuenftig --debug-CLI (S-8/W2)"*. D.h. der --debug-1x-Zweig ist gebaut, aber am heutigen Objekt PRODUKTIV NICHT ERREICHBAR, bis das `--debug`-CLI-Flag (Task #22(ii), faehrt MIT S-8) existiert. Kein Fehlbefund, aber eine Bedingung, die das Audit fuer den "gebaut UND live" -Unterschied im Auge behalten sollte.

### P-15 — Register S5-06 Korrektur (super, Lead-only)

**WAS**: KON26-04 Punkt 8 (s. P-04); super-Dokument `docs/sessions/20260809-KONFORMITAETS-REGISTER-teil2-stationen-5-bis-8.md:65` traegt einen ueberholten Befund ("Default max_reruns=3 steht gegen die Owner-Zahl 5").
**WIE PRUEFBAR**: Datei liegt im super-Repo (ausserhalb des ce-Worktrees).
**BEHAUPTET**: NICHT vollzogen, nur als ENTWURF im Strang-Bericht hinterlegt (§"LEDGER-ZEILEN"/"REGISTER-KORREKTUR"): *"der Befund ... ist DATIERT UEBERHOLT durch KON26-04 (die 5 gehoert zum Binary-Retry; Drift-Mechanismus-Default 3 ist der richtige Stand seit 20.08.)"*. STAFFEL1-SYNTHESE F-13 bestaetigt: *"OFFEN (ENTWURF liegt) | Lead traegt Korrektur ein (super-docs)"*. Korrekt so — super ist Lead-only (auch nach den REGELN dieses Erhebungs-Auftrags).

### P-16 — S-19-Zahlen 18->120 Nachzug (Cross-Strang, H-5/F-10)

**WAS**: Strang-Bericht eigener Abschnitt (Z.200-206): *"Die S-19-Simulation ... druckt heute 'drift_worst_arena 18 (D.7-Zweitlesart)' und fuehrt die x5-Klammer 'als Zeile, NICHT multipliziert'. Mit DIESEM Strang gilt: ... arena_gesamt_faktor 120 ... S-19-Zahlen, die 18 als Arena-Worst tragen, sind beim Landen auf 120er-Basis nachzuziehen (Eigentuemer-Entscheid liegt HIER, measure_storage/#13)"*. STAFFEL1-SYNTHESE H-5 (Z.53-57): *"mess-fenster hat D.7 ENTSCHIEDEN ... s19-Bericht/Zeilen tragen noch 'drift_worst_arena 18' ... beim s19-Merge auf 120er-Basis NACHZIEHEN"*; F-10 (Z.115): *"OFFEN -> LANDE-ZUG (Pflicht) | H-5 beim s19-Merge (Eigentuemer measure_storage/#13)"*.
**WIE PRUEFBAR**: s19-Strang-Bericht/-Tests am gemergten Endstand.
**BEHAUPTET**: Korrekt als OFFEN/Cross-Strang-Pflicht deklariert (kein Selbstanspruch auf Erledigung); Lande-Reihenfolge verlangt messfenster VOR s19 (STAFFEL1-SYNTHESE §2.2 Schritt 1+2), damit die 120er-Wahrheit zuerst steht.

### P-17 — build_orchestrator-Diff: 6 mitgereiste Non-ASCII-Altkommentarzeilen (F-14)

**WAS**: REGELN dieser Session (ASCII-only in neuen Zeilen). Strang-Bericht §"OFFENE PUNKTE" (5): *"sechs beim Einruecken mitgereiste NICHT-ASCII-Altkommentar-Zeilen im build_orchestrator-Diff (Bestandstext, byte-inhaltlich unveraendert bis auf 2 umgebrochene >120-Zeilen, dort ASCII-fiziert)"*.
**WIE PRUEFBAR**: `git diff` auf `build_orchestrator.hpp` gegen Basis 66de5c09, Zeilen mit Non-ASCII-Bytes zaehlen.
**BEHAUPTET**: DEKLARIERT als offener Lande-Zug-Sichtungspunkt (F-14 in STAFFEL1-SYNTHESE, 1 von nur 2 "traegerlosen Lande-Zug-Pflichten" neben F-10). Da es sich um BESTANDSTEXT handelt (nicht neu autorisierte Zeilen), ist unklar, ob die "ASCII-only in neuen Zeilen"-TABU hier ueberhaupt greift — Diff-Hygiene misst aber push-lokal ueber den gesamten FF-Bereich, unabhaengig vom Autorschafts-Alter.

### P-18 — clang-format-22 ueber jede geaenderte Lint-Datei

**WAS**: REGELN dieser Session (bindend fuer den Erhebungs-Auftrag; als generelle Objekt-Doktrin auch fuer den gebauten Strang zu erwarten, vgl. GOAL v8/Designplan-Doktrin "Warnungs-Review ZWEIMAL gcc dann clang").
**WIE PRUEFBAR**: `~/.local/bin/clang-format-22 --dry-run` (oder Diff) ueber alle vom Strang geaenderten `.hpp/.cpp`.
**BEHAUPTET**: NICHT EXPLIZIT im Strang-Bericht ausgewiesen (weder als "gefahren" noch als "offen" benannt). Der Strang-Bericht dokumentiert nur `porcelain 0` und den gcc-Release-Kombibau; ein `clang-format`-Lauf wird nirgends erwaehnt. STAFFEL1-SYNTHESE Phase 3 sieht "Warnungs-Review ZWEIMAL (gcc, dann clang)" als **Lande-Zug-Pflicht** am gemergten Endstand vor, was diese Unschaerfe absorbiert — aber am Strang-Objekt selbst ist der Punkt eine ECHTE LUECKE IN DER BERICHTERSTATTUNG, kein bestaetigter Fund.

### P-19 — Ref-Sicherung (push -o ci.skip) + EIN Schreiber je Worktree

**WAS**: REGELN dieser Session; Prozess-Doktrin K5/A1-A5 (W2-ABFOLGE-DESIGN Kopf, Z.15-26).
**WIE PRUEFBAR**: `git log --oneline origin/bau/messfenster` (read-only pruefbar gegen den Hauptklon-Ref).
**BEHAUPTET**: JA — Strang-Bericht §3: *"Branch bau/messfenster @ 3a746090 (Basis 66de5c09; origin per -o ci.skip gesichert, V6)"*; STAFFEL1-SYNTHESE Status-Tafel bestaetigt "origin-Sicherung JA (ci.skip)".

### P-20 — Owner-gated: nichts in diesem Strang owner-gated gebaut

**WAS**: Cross-Check gegen LEAD-ENTSCHEIDE (87 Z. voll gelesen) — keiner der 21 dortigen Punkte benennt #13/T-15b/messfenster als owner-gated blockiert; alle vier zugrundeliegenden KON-Entscheide (KON19-07/KON26-04/KON28-02/KON37-06/KON47-04) sind VOLLSTAENDIG beantwortete Owner-Entscheide, keine offenen Fragen.
**WIE PRUEFBAR**: LEAD-ENTSCHEIDE-Volltext (keine #13-Zeile in der [F]-Warteliste referenziert).
**BEHAUPTET**: JA — Strang-Bericht §3 letzter Satz: *"Owner-gated: NICHTS in diesem Strang owner-gated gebaut; D.7-Entscheid lag per KON26-04 Punkt 5 + C-2-Zeile ('Eigentuemer measure_storage/#13') bei diesem Strang und ist vollzogen, nicht erfunden."*

--------------------------------------------------------------------------------

## ABNAHME-FORMELN (woertlich aus den Quellen)

- **W2-ABFOLGE-DESIGN C-2** (Z.191-192): *"ABNAHME: 5x(Build+Messung) mit 3 Einzelwerten + Arena-Formel-x5 ausgefuehrt und dokumentiert; Soft/Hart gemessen."*
- **W2-ABFOLGE-DESIGN C-3** (Z.196-197): *"ABNAHME: Paar-Zaehlung 2x3, --debug 1x, Verwerf-Beweis getestet."*
- **Designplan T-1** (§3, Z.67): *"ROT ZUERST. Der Test ist am ersten Tag rot, ODER sein Biss ist per protokollierter Wegwerf-Mutation bewiesen (Rot gesehen, dann zurueckgenommen)."*
- **Designplan T-7** (§3, Z.73): *"REGISTRIERUNG IST TEIL DES TESTS. Ein Test existiert erst, wenn er in ctest -N erscheint und sein Binary im Bauweg haengt."*
- **Designplan T-8** (§3, Z.74): *"ATOMARE LANDUNG. Tag-1-Rot lebt im Feature-Branch; auf development landen Test + Minimalbau atomar (Hart-Gruen-Doktrin bleibt intakt)."*
- **Designplan T-11a** (§11, Z.640-643): vollstaendig unter P-10 zitiert (Paar-Zaehlung 2x3 / --debug-Zweig 1x / Verwerf-Beweis, je mit benanntem Koeder).
- **Designplan T-12b** (§12, Z.669-674): *"ENTWEDER Paar-Zaehlung 2x3 = 6 Laeufe / 3 Werte auch am Legacy-Pfad ... ODER ein Ausbuchungs-Beweis, dass der Pfad von keinem Produktions-Ziel mehr gefahren wird (Nullbefund NUR mit Gegenprobe 'wer ruft ihn?')."*
- **KON28-02 -> GOAL-v8-Doktrin-Kopplung** (Ledger Z.8836-8838): *"deckt sich mit der stehenden allow_failure-Doktrin ZELLE=Warnung/JOB=rot und dem PMC-Fallback 5/2/1."* Die GOAL-v8-Tabelle dazu (Z.770-773): *"CSV-Zelle | traegt failed (nicht null), plus Warnung an den Anwender, die Messung wird uebersprungen"* / *"CI-Job | faellt immer hart rot -- nie allow_failure"*. Owner woertlich (GOAL v8, Z.775-776): *"Wenn dann muss ein Fehler sauber mit einer Warnung an den Anwender angezeigt und die Messung uebersprungen werden, aber der CI job failed immer hart."* — bindet C-11s Soft-Pfad: die xlsx-Warnung ersetzt NIE einen harten CI-Job-Fail; C-11-soft betrifft ausschliesslich die CSV/xlsx-Zellenebene.
- **Wellenplan §18.1 Klassen-Regel** (Z.2204-2206): *"NEU AUSGEWIESEN: binary-beruehrender MESS-Code (Arena-Formel, Warmup-Pfad, Harness) ist nicht preimage-FORM-wirksam, aber trigger-gebunden -- nach Mi 26.08. entwertet er den Bau. Er faehrt als (M) im WE-/W2-Fenster VOR dem Trigger."* — d.h. #13/#38b sind Klasse **(M)** (vor Trigger Mi 26.08.), NICHT Klasse (P) (vor F2 Fr 21.08.) — s. NICHT-GEFORDERT.
- **STAFFEL1-SYNTHESE Findings-Bilanz** (Z.113-114/184): F-09 "BEHOBEN (arena_gesamt_faktor 12*2*5=120; D.7 ENTSCHIEDEN; G5h-Wache)"; Gesamtbilanz messfenster-Funde F-06..F-14 (9 Funde): 7 BEHOBEN (F-06,F-07,F-08,F-09,+implizit die drei T-11a-Koeder), 1 TEIL (F-12), 1 DOKUMENTIERT (F-11), 2 OFFEN/Lande-Zug-Pflicht (F-10, F-14), 1 OFFEN-mit-Entwurf (F-13).

--------------------------------------------------------------------------------

## NICHT-GEFORDERT (deklarierte Nachfolge-/Fremd-Zuege — kein Phantom-Fund, wenn hier abwesend)

1. **C-09/T-12a Drift-Gate-Debug-Ausnahme**: LEAD-ENTSCHEIDE Punkt 11 (Z.35-39): *"C-09 startet NICHT parallel, sondern als ANSCHLUSS-Auftrag DIREKT NACH mess-fenster-Rueckkehr (gleicher Worktree, sequentiell). VOR W3 PFLICHT bleibt."* — explizit ein **FOLGE-Auftrag im selben Worktree**, nicht Teil DIESER Lieferung. Wellenplan §19.3 C-09 (Z.2473-2475) + Designplan T-12a (§12, Z.661-667) beschreiben diesen separaten Test/Bau. Audit soll KEIN Fehlen von RunMethodology-Verzweigung im Drift-Gate als Luecke DIESES Stranges werten.
2. **Arena-Bau-Posten E1-E10** (Aggregator Roh->Sheet-Zeile, Folgeblatt statt Wurf, DRAIN-SCHLEIFE, Zwei-Phasen-an-der-Arena, PAAR-Muster AN DER ARENA [E8], measure_storage produktiv): Ledger `KON92` (Z.2444-2447) weist diese explizit dem **S-13/#18-Buendel** zu ("Arena-Posten E1-E10 (KON92) im S-13/#18-Buendel"). Der Strang hat dies selbst als disjunkt erkannt (Explore-Notiz, s. P-06-Audit-Hinweis) — nur die stale Faktor-2-**Kommentarzeile** (mess_arena.hpp:222-224) und die Formel-**Dokumentation** in checkpoint_speicher.hpp gehoeren zu #13.
3. **Arena-Kapazitaet in GB (6GB-fest-Entscheid, KON93-02)** und der zugehoerige Ueberlauf-Mechanismus ("HARTER ABBRUCH statt Weitermessen", mess_arena.hpp:36): Owner-Entscheid 16.08. weist den BAU ebenfalls S-13/E1-E10 zu; Designplan T-12c (§12, Z.676-693) traegt dazu die eigentlichen Testpflichten UND einen expliziten UEBERHOLT-MARKER, der Pflicht (3) an *"s13-Design 20260817-DESIGN-s13-buendel-di25.md S13-05/S13-07"* verweist. T-12c ist damit KEIN messfenster-Pruefposten.
4. **T-12d Full-Join-Schema-Tests (FJ-1..FJ-10)** und **T-12e S-3-Kombibau-Nachweis**: beide Designplan §12, aber fachfremd (S-13-Schema bzw. Task #4/S-3) — nicht Teil von #13/#38b.
5. **--debug-CLI-Flag selbst** (Task #22(ii), "faehrt MIT S-8"): messfenster verdrahtet nur den INTERNEN Resolver (`resolve_mess_kaltlauf_of_mode/_debug`), der auf das Flag REAGIEREN wird — das Flag auf der Planer-Shell selbst zu bauen ist NICHT Teil dieses Stranges (s. P-14-Caveat).
6. **Freeze-Check Fr 21.08. (Klasse P)**: Wellenplan §18.1 stuft #13/#38b explizit als Klasse **(M)** ein (vor Trigger Mi 26.08.), nicht (P) (vor F2 Fr 21.08.). Die Freeze-Check-Deklarations-Tafel §23.2 (voll gelesen) nennt #13/messfenster an KEINER Stelle — korrekt so, das Audit soll hier keinen fehlenden Freeze-Vermerk erwarten.
7. **Register-S5-06-Eintragung selbst** (nur Entwurf-Pflicht dieses Stranges, s. P-15/P-04.8) — die tatsaechliche super-Doku-Aenderung ist Lead-Sache, kein Bau-Delta des ce-Worktrees.
8. **S-19-Zahlen-Nachzug 18->120** (H-5/F-10, s. P-16) — mechanisch am s19-Strang/-Merge zu vollziehen, nicht am messfenster-Objekt selbst.
9. **T-11b 4-Zellen-Kombibau + Floor-/Ratschen-Setzung (H-7)**: ausdruecklich Lande-Zug-Sache am GEMERGTEN Endstand (K17-Doktrin), nicht am Feature-Branch zu leisten.

--------------------------------------------------------------------------------

## SPANNUNGEN (Widersprueche zwischen Quellen — juengere Schicht benannt, nicht glattgezogen)

### S-1 — Eigentums-Konflikt "D.7 Arena-Formel" zwischen #13 (Wellenplan, 13.08.) und S-13/E1-E10 (Ledger KON92/KON93-02, 16.08.)

- **AELTESTE Schicht** (Wellenplan §18.4/§19.3, Stand 13.08.): weist "D.7-Arena-Widerspruch (Faktor 2 vs. bis 18)" UND "Arena-Formel muss x5 ZUSAETZLICH decken" explizit #13/measure_storage zu ("Eigentuemer measure_storage/#13").
- **JUENGERE Schicht** (Ledger `KON92`+`KON93-02`, 16.08., beide NACH dem Wellenplan-Text): (a) `KON93-02` legt die Arena-KAPAZITAET (GB-Dimension) Owner-seitig auf 6GB FEST und weist den zugehoerigen BAU ausdruecklich "in die Arena-Posten E1-E10 (KON92) im S-13/#18-Buendel" zu; (b) `KON92`-Nachtrag benennt DIESELBE Datei-Stelle, die messfenster spaeter aendert ("C7 Faktor-2-Kommentar stale, verdrahtet ist drift_faktor <=18"), als Teil dieser E1-E10-Liste, dort als "S-13-KERNSTUECK" bezeichnet.
- **JUENGSTE Schicht** (STAFFEL1-SYNTHESE/STAFFEL2-SYNTHESE, 20./21.08., juenger als beide obigen): bestaetigt die #13-Eigentuemerschaft fuer GENAU die Zeilen-/Wiederholungs-Formel (arena_gesamt_faktor, F-09 "BEHOBEN") UND die Kommentarkorrektur (F-08 "BEHOBEN messfenster", in STAFFEL2/F-93 als "S1-F-08" dedupliziert), waehrend sie eine NACHBAR-Divergenz an derselben Datei (mess_arena.hpp:88-91, "OP-1-Kommentar" statt "Faktor-2") ausdruecklich OFFEN laesst und dem S13-07-Umbau zuweist ("S13-07-Umbau-Commit mitziehen (H-14)").
- **Bewertung nach Rangfolge-Doktrin** (juengere Schicht gewinnt, aber nicht glattziehen): die JUENGSTE Schicht (Staffel-Synthese) loest den scheinbaren Konflikt zwischen Wellenplan (13.08.) und KON92/93-02 (16.08.) auf, indem sie das Objekt in ZWEI Dimensionen zerlegt — (1) die Zeilen-/Wiederholungs-Multiplikator-Formel (arena_gesamt_faktor, #13-Eigentum) und (2) den GB-Kapazitaets-/Ueberlauf-Mechanismus (E1-E10, S-13-Eigentum). Diese Zerlegung STEHT NIRGENDS EXPLIZIT ALS OWNER-SATZ — sie ist eine Rekonstruktion der Staffel-Synthese-Autoren. Das Audit sollte pruefen, ob der 120er-Faktor bei S-13s spaeterem E1-E10-Bau tatsaechlich als Eingang gebraucht/uebernommen wird (sonst waeren die "120" und die "6GB fest" zwei unabhaengig gerechnete, potenziell inkonsistente Kapazitaetsgroessen).

### S-2 — "KF-10 bestaetigt" als Verify statt Neubau vs. ABNAHME-Wortlaut "ausgefuehrt und dokumentiert"

Die W2-ABFOLGE-DESIGN-ABNAHME fuer C-2 verlangt woertlich *"3 Einzelwerten ... ausgefuehrt und dokumentiert"* (Z.192) — ohne zwischen Neubau und Verify eines Bestands zu unterscheiden. Der Strang deklariert das Kriterium als bereits ERFUELLTEN BESTAND (KF-10, `repetition_plan.hpp`) und liefert dafuer KEINEN neuen Test, nur eine Explore-Feststellung. Das ist wahrscheinlich im Sinne der Quelle (KON37-06 selbst nennt es "KF-10 bestaetigt"), aber die ABNAHME-Formel selbst macht diesen Unterschied nicht explizit — ein AUDIT, das eine STRIKT NEUE, dediziert-fuer-#13-geschriebene 3-Werte-Persistenz-Pruefung erwartet, wuerde hier eine Luecke sehen, wo der Strang (mit Deckung durch KON37-06-Wortlaut) einen bereits gedeckten Bestand sieht.

### S-3 — T-12b "ENTWEDER/ODER" vs. gebaute dritte Option (Anpassung durch Deklaration)

s. P-09: Designplan T-12b nennt zwei disjunkte Wege (volle Paar-Zaehlung AM Legacy-Pfad selbst, ODER Ausbuchung mit Gegenprobe). Der Strang waehlt eine Zwischenform (Kopf-Deklaration + Aufrufer-Zensus), die er selbst als "KON47-04-Alternative erfuellt" bezeichnet — eine Berufung auf den ALLGEMEINEREN KON47-04-Wortlaut ("anpassen ODER ausbuchen"), nicht auf den ENGEREN Designplan-T-12b-Wortlaut ("Paar-Zaehlung auch am Legacy-Pfad" ODER "Ausbuchungsbeweis"). Rangfolge-Doktrin stellt Owner/juengere-KON VOR Designplan — KON47-04 ist aelter als T-12b (der Designplan-Abschnitt praezisiert KON47-04 erst spaeter, §12/16.08. vs. KON47-04/13.08., mithin ist T-12b eigentlich die JUENGERE, praezisierende Schicht) — das Audit sollte den woertlichen T-12b-Text als massgeblicher werten als die freiere KON47-04-Paraphrase des Stranges.

### S-4 — "PMC-Fallback 5/2/1" bleibt unaufgeloest referenziert

KON28-02 und KON45-03 referenzieren beide eine Groesse *"PMC-Fallback 5/2/1"* als Konsistenz-Beleg, ohne sie an dieser Stelle selbst zu definieren. Ob dieser Fallback (vermutlich eine PMC-Verfuegbarkeits-Eskalationsstufe, nicht die T-15b-Retry-5) mit dem hier gebauten C-11-Soft-Pfad kollidiert oder ihn nur bestaetigt, konnte innerhalb der vorgegebenen SOLL-Quellen dieses Auftrags NICHT abschliessend verifiziert werden (die Definitionsstelle liegt ausserhalb der sechs vorgegebenen SOLL-Quellen). Kein Widerspruch am Objekt festgestellt, aber auch nicht positiv ausgeschlossen — als offene Randnotiz gefuehrt, nicht als Fund.

--------------------------------------------------------------------------------

## QUELLEN-ANHANG (fuer Nachvollziehbarkeit, alle mit Zeilennummern oben zitiert)

- W2-ABFOLGE-DESIGN.md: Kopf (Z.1-30), C-2 (Z.184-192), C-3 (Z.193-197), §18.1-Analogon Z.169.
- LEAD-ENTSCHEIDE-zum-w2-design.md: VOLL gelesen (87 Z.), Punkte 11+12+16+18 direkt relevant.
- Wellenplan v2: §17.1 (Z.2144), §17.4 (Z.2174-2178), §17.6 (Z.2189-2191), §18.1 (Z.2200-2206), §18.4 Zeilen #13/#38b (Z.2250-2251), §19.3 Korb C VOLLSTAENDIG (Z.2454-2490), §21.3 (Z.2991-3020), §23.2 Freeze-Check-Tafel (VOLL gelesen, #13 nicht gelistet).
- Designplan-tdd: §3 T-1..T-9 (Z.63-75), §11 T-11a/b/c (Z.640-649), §12 T-12b/T-12c inkl. UEBERHOLT-MARKER (Z.661-693).
- GOAL-v8-Dossier: allow_failure-Doktrin (Z.755-788), T-15a/T-15b-Trennung (Z.589).
- Ledger: KON19-07 (Z.9994-10008, aelteste Wurzel-Korrektur), KON26-04 (Z.9058-9078, Umzugsbauplan), KON28-02 (Z.8814-8838, hart/soft), KON34-05 (Z.8391-8401, --debug disjunkt), KON37-06 (Z.7435-7452, finale 5/3-Formel), KON45-03 (Z.6740-6764, E-Warmup/Fallback-5-2-1-Erwaehnung), KON47-04 (Z.6567-6592, Warmup-Paar-Regel), KON92-Nachtrag (Z.2422-2453, Arena-Ketten-Karte), KON93-02 (Z.2389-2407, 6GB-fest-Entscheid).
- STAFFEL1-SYNTHESE.md: Status-Tafel (Z.14-29), H-1..H-8 (Z.36-67), Lande-Reihenfolge (Z.69-99), F-06..F-14 (Z.111-119).
- STAFFEL2-SYNTHESE.md: H-5-Bestaetigung (Z.102), Lande-Order (Z.118-119), F-93 (Z.183).
- mess-fenster-ergebnis.md: VOLL gelesen (245 Z.).
