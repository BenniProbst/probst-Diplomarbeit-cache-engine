# KATALOG — Offene Strecke im Gesamtplan (Stand 02.08.2026, vormittags)

> **Auftrag (Owner, 02.08.):** „Bitte sammle aus dem Gesamtplan der letzten 3 Wochen die insgesamt noch offene Strecke und konsolidiere und Katalogisiere sie. Wo stehen wir im Gesamtplan?"
> **Quellen:** Übergabe 20260802 (§2 Paketstrecke), Fahrplan 20260801 (+Addenda), Konsolidierung Gesamtarchitektur 20260801, Dossiers OE-A/C/E 20260801, HW-Erkennungs-Plan 20260727, Thesis-Fakten-Kanon, Ledger, Infra-Handouts 02.08., Inventur-Verifikation (Abschnitt G). Neueste Owner-Aussage verdrängt ältere.

## 0. Standort-Bestimmung

Der Gesamtplan hat drei Phasen: **Konstruktion** (Architektur, Achsen-Kanon, Mess-Maschinerie) → **Voll-Bau-4** (2^17 Organ-Permutationen × System-Perms) → **Voll-Messung + Auswertung + Abgabe**. Wir stehen **am Ende der Konstruktionsphase**: alle Architektur-Entscheide der drei Wochen sind gefallen und verbucht (ORG-18-Neuordnung O-8, HW-Erkennung P1–P3 mit Live-Beweisen, V-4-Retire, OP-9/E-2, alle OE-A–F/F1–F15/E-1–E-10-Fragen geschlossen), die Thesis ist auf den Kanon nachgezogen (K0–K6 + Sprachpass + Voll-Konsolidierung Anhänge/Verweise, main==dev==b224628, CI grün), und das F14-Trigger-Gate ist zu 2/3 erfüllt — offen ist nur das 2h-Ruhefenster (b).
**Vor uns liegt die Pflicht-Paketstrecke (Kategorie A) bis zum autonomen Voll-Bau-4-Trigger, danach Messung nur mit USER-GO. Frist: Freitag 08.08.**

Linien-Ist (alle CI-belegt grün): ce main==dev==2b0a9bd8 (Gate 321, prod2=275) · super main==dev==d6986cb5 (Gitlink auf 2b0a9bd8) · thesis main==dev==b224628 (190/182 Seiten, 0 Fehler, chktex 0).

## A. Trigger-blockierend (Pflicht VOR dem Voll-Bau-4-Trigger; Reihenfolge ≈ kritischer Pfad)

| # | Paket | Inhalt / Herkunft | Stand |
|---|---|---|---|
| A1 | **Lager-Strecke** (F9: „der Voll-Bau-Trigger IST der Baum-Vollausbau") | TP1 Teil A Takeover (G-E1) **FERTIG**; Teil B Präsenz-Filter (G-A2/G-E2) **LÄUFT**; danach Beweise+Paketmeldung TP1; dann Lager-Baum-Vollausbau LB-Schnitt (Baum-Writer, complete-heuristik.log je Knoten, Truncate-Zustandsmaschine, 2 Realm-Bäume Binaries/Messdaten, CEB-Einlagerung), Mess-Genus-Writer (G-E3), Versions-Tag in Lager-Identität (G-E6, OE-C), Dual-ccache-Umschaltung (G-E7) | in Arbeit |
| A2 | **SHA512-only-Skip-Gate** | F7: Skip-Entscheid künftig NUR SHA512-Fingerprint (deckt alle Stempel) | offen |
| A3 | **Beweise 1–5** | Fahrplan-Beweiszuschnitte; B1 als Batch-Wiederaufnahme-Konstruktion (OE-A, Pflicht), B5 zweistufig nach E-07-Prüfung; **+ §61-Dual-Weg-Beleg** (comdare_tier_measure_<host> einmal bare-metal über den CMake-Weg durchfahren — 0 Durchfahr-Belege seit 27.07., MANUAL_RUN.md:146 dokumentiert nur den Weg) | offen |
| A4 | **12-Perm-Paket** | Profil-Edit + ≥16 Test-Anker (beschlossen 27.07.) | offen |
| A5 | **ETA/Kalibrier-Prinzip** | F5: ETA = Prinzip des Kalibrierlaufs; Auswertung je 4096er-Meilenstein (F6) | offen |
| A6 | **OD-10** | NUMA/page-Betriebsdimension | offen |
| A7 | **E-04 + E-18** | LaTeX-Vorwärts-Kanal (§68c-Hauptziel) + Restpunkt E-18 | offen |
| A8 | **Benchmarking-Schnitt** | F2-Modell: Micro = Achse über ihr ACHSEN-Interface; Suchalgorithmus-Interfaces VERWENDEN Achsen-Interfaces; CEB misst 3 Wallclock-Ebenen; Ist ist falsch geschnitten → Impl zieht nach | offen |
| A9 | **xlsx-Writer** | F3: eigener Writer, Fork libxlsxwriter zulässig; xlsx=Default-Auswerteformat, Unter-Achsen im Dateinamen | offen |
| A10 | **HW-Erkennung P4–P6** | P4 CSV-Spalten/Provenienz-Rückschrieb, P5 Passungs-Stempel (Vendor-Familie×OS), P6 Rest-Verdrahtung/Roundtrip (Plan 20260727; P1–P3 gebaut); **+ prod2-Stufe-2-Live-Beweis** (SpdEeprom-Kette auf prod2, seit SPD-Freischaltung #525 entblockt; prod2 liest Bytes 0–127, Kern-Offsets <128 verifiziert) | offen |
| A11 | **Klein-Sammel** | ccache-Allowlist-Drop; gebündelter Ledger-Nachtrag (inkl. 5 veraltete Zeilen + 4 Erledigt-Befunde aus G.0) | offen |
| A12 | **NAS-Creds backup1/backup2 (E-14)** | Zugangs-/Mount-Strecke für die Mess-CSV-Ablage — trigger-nah, stand bis zur Inventur in KEINER Paketliste; neben A1/G-E7 einplanen | offen |
| A13 | **Stempel-REGRESSION (Owner-E2, 02.08.)** | merge-Zeile ENTFERNEN (darf nicht existieren; PRT-ART merge't gegen Organ-Achsen); Meta-Meta-Einträge dynamisch per Metaprogrammierung ans ENDE der jeweiligen Realm-Zeile; 'e'-Versions-Suffix für experimentelle Prüfling-Algorithmen; OP-11-Rückbau; G-E6/SHA512-Gate setzt darauf auf — VOR Voll-Bau (Stempel=Lager-Identität) | offen, Design via ultracode |
| A14 | **OS-Unter-Achsen FINAL DREI (Owner-E3)** | Basis Wiederverwendbarkeit/Zuordbarkeit; ohne sie Neubau aller Binaries bei OS-Erweiterung (RISC-V/macOS kommen heute); A-08/K-04-Definition umsetzen | offen, Design via ultracode |
| A15 | **Fehlerklassen-Framework #29 (Owner-E6)** | Design-Doc 20260717 wiederaufnehmen, auf heutigen Kanon heben, bauen | offen |
| A16 | **E-Pflicht-Bündel (Owner-R7)** | E-24 (Container-Gattung als LETZTER ABI-Schritt → in Gate-Reihenfolge einordnen; **harte Kante aus HY-D2:** E-24 MUSS VOR dem Voll-Bau-4-Trigger liegen — bumpt der Major erst NACH dem Voll-Bau, lädt die Hybrid-Stufe die eingelagerten Binaries nicht mehr (Major-Check im Loader) = Neubau ALLER Binaries, exakt der von Owner-E3 ausgeschlossene Zustand; die Hybrid-Stufe selbst fordert KEINEN eigenen ABI-Schritt) · E-19 (Runner-Fleet-Ist-Soll alle Architekturen + Poll-Jitter 2+rand(0..1)s) · E-02 (Vier-Ledger-Struktur herstellen: prt-art+thesis-Ledger anlegen + Audit-Pflicht) · E-23 (GitLab-API-Suchlauf vor Modul-Migration, G5-Forks F0-F5=A) · E-21 (STACK-Form/LIFO + Verbose-Regel verankern) | offen |
| A17 | **Hybrid-Tier-Stufe: DESIGN (Owner-E1)** | Exakte Designplanung Fable 5 xhigh + ultracode JETZT (Stufe hinter CEB, N ABI-stabile Prüf-Docks dynamisch, Factory-Proxy, std::variant-Ausnahme statisch/runtime-Array, XML-Auswertungsphasen-Konfig); BAU in Auswertungsphase (E) | offen |

## B. Trigger-Sequenz (nach A, autonom bis inkl. Trigger)

1. **J-Ketten-Voll-Lauf** (N=316; nur mit V32_ENABLE=ON) → *[KORREKTUR 03.08., Gegenlese D-01: N ist KEINE eigene Zaehlung, sondern das lebende ctest-Gate — live via ctest -N erheben, Stand 331; V32=ON ist nur CI-Kanon und gated KEINEN Test (Verify-Befund 01.08., FAHRPLAN:42-53)]* →
2. **heavy-Signal an Infra** (runner-mode.sh heavy, SIGHUP-only, beide Hosts) →
3. **Kalibrierlauf** GN_TOTAL=64 (F5-GO liegt vor) → ETA-Ableitung →
4. **Voll-Bau-4-Trigger AUTONOM** (F14-Gate: (a) Auth 200 ✓, (b) 2h ohne scheduler_failure — läuft, Ziel ~09:57Z, ✓-Meldung durch Dauerwache, (c) Baremetal-Bestätigung ✓; degraded=0 nur Komfort). Trigger-Form: POST /projects/288/pipeline, GN_TOTAL=131072, 4096er-JOB-MEILENSTEINE je Maschine (F6), VARIANT_GATE=true, keine toten Vars.
5. **Messung danach NUR mit USER-GO.**

## C. Thesis (vor Abgabe; parallel zum Hauptstrang)

| # | Punkt | Stand |
|---|---|---|
| C1 | Rahmen-Pass: Danksagungs- + Sperrvermerk-ENTWÜRFE zur Owner-Freigabe (F1-Richtung liegt), Lizenz-Matrix (DA+PRT-ART=Apache, ce=GPL+Comdare, Overleaf-Text privat), EN-Abstract-Sync, F10-Wortfix | offen |
| C2 | K4 „320 Tests"→321 + Anhang-B-Stichtagszeile — **beim Einfrieren der ce-Linie** (Sprachpass-Befund) *[NACHTRAG 03.08., D-07: dazu K5 05_evaluation DE:98+EN 'deklariert es vier' nach A4/12-Perm nachziehen; + D-02: 4. Stempel-Zeile in 03/05/06 DE+EN per Owner-E2 abgeschafft -> eigener Thesis-Nachzug-Task]* | terminiert |
| C3 | Rang-3-Framing K5:70 („Plattformen der Rang-3-Hardware-Arbeiten" → Produktions-Zielmaschinen + HBM) — **Owner-Prosa, braucht Owner-Wunsch** | Owner-Frage |
| C4 | Aufgabenblatt-PDF | beim Owner |
| C5 | Ergebnis-/Auswertungs-Einspeisung nach Voll-Messung (E-1: breit nachziehen) | gated auf Messung |
| C6 | Identity-Normalisierung thesis-Gitlink (#375/#377) | bei Infra |
| C7 | chktex-Härtung: exit 0 bei nicht öffenbarer Datei — verschwundene .tex bliebe im Lint-Gate grün (Wachen-Befund 02.08.; Risiko durch EN-Compile-Gate REV3 stark reduziert) | nice-to-have |

Erledigt seit 01.08.: K0–K6-Nachzug, Sprachpass alle Kapitel, Anhänge A–F-Konsolidierung (B auf Code-Ist 02.08., C Glossar +8, D auf ORG-18-Slots + T17, E ADRs), Verweis-/Formel-Pass (0 undefined, DE==EN 525 cites), F15-12900K-Nachzug (b224628), **CI REV3: EN-Fassung wird jetzt kompiliert** (vorher nur gelintet = CI-seitig unbelegt; parallel:matrix de+en, fd459cf).

## D. Infra-abhängig (Fremd-Posten, wir treiben per Handout/Signal)

- ~~SPD-Freischaltung prod2~~ — **ERLEDIGT 02.08.** (#525/K115x): `/sys/bus/i2c/devices/3-005{1,3}/eeprom`, unprivilegiert lesbar, reboot-fest; prod2-Fenster Bytes 0–127 (reicht: alle Parser-Kern-Offsets <128); Treiber heißt **spd5118** (nicht ee1004 — DDR4-Treiber, F13-Benennung korrigiert). Infra-„Decoder-Blocker" entfällt: eigener constexpr-Parser `spd_ddr5_parser.hpp` (P1), kein decode-dimms/spdr nötig — Antwort-Handout 02.08. liegt. **Folge-Punkt bei uns: prod2-Stufe-2-Live-Beweis (SpdEeprom-Kette auf prod2) → in A10/P4–P6 aufgenommen.**
- 1024-Byte-BIOS-Fenster prod2: als NICHT erforderlich zurückgemeldet (owner-gated Reserve).
- heavy-Erstschaltung — wartet auf UNSER Signal (Sequenz B2).
- degraded=0-Signal-Doc — nur noch Komfort (F14-GO); Stand ~10:15: 4 degraded, konvergiert.
- Identity-Normalisierung thesis (#375/#377).
- Marathon-Ursache (nice-to-have, hinter Fenster-Pflichten).

## E. Nach dem Voll-Bau (gated)

0. **KERN-Mess-Schema-Anschluss (§59) — PFLICHT VOR der Messung:** K4-Naht in den Director (per-Achse-Direktiven statt Kreuzprodukt), K5-Renderer produktiv + generische Typauflösung (statt hartcodiertem Einzel-if), merge-Stempel-Zeile real schreiben (statt hart {}) *[SUPERSEDED 03.08., Gegenlese D-03: Owner-E2/Q2 (09:25, NACH diesem Doc) — es gibt KEINE merge-Stempel-Zeile; Merge lebt im Stempel NUR ueber e-Flag + erweiterte Namen; A13-M3/C3 ENTFERNT den merge-Stempel-Code]*, Abgabeprofil um per-Achse-Modi ergänzen (G.3-Befund: Naht greift in der Abgabekette faktisch nicht) · 1. 320er-Abgabemessung (USER-GO) · 2. Voll-Messung 2^17×System-Perms (USER-GO) · 3. Mess-Rückschreibung: erste CSV auf NAS, minio=Binaries/NAS=CSV-Kaskade · 4. Auswertung (xlsx-Lager-Baum, Heuristik-Kurven, LaTeX-Kanal) · 5. Thesis-Ergebnis-Kapitel (C5) · 6. §62-COMPARE-Vollzug (Nach-Trigger-Paket D2, Replay-Vergleich je Maschine) · 7. #48-Scheibe-6 XML-Sync-Gate-Umhängung (gated „nach 320er + USER-GO") · 8. §61-Modi Release-Wallclock-Beweis · 9. #51 tier150-Ersatz (bis 320er-Umstellung blockiert).

## F. Zuletzt: Abschluss-Aufräumpass (§75)

Deprecated Header + toter Code ENTFERNEN (Doku bleibt, nur deprecaten); Kandidaten-Sammlung läuft (Agent), Liste wird fortgeschrieben. Erst NACH allen bekannten Aufgaben.

## G. Inventur-Verifikation der Alt-Punkte (Inventur-Lauf 02.08., read-only, 4 Explore-Stränge; „erledigt" nur bei literalem Beleg)

### G.0 Kopfbefund: 5 Ledger-Zeilen nachweislich veraltet → in A11-Nachtrag
LED:3265 (#45 paralleler Mess-Loop = GEBAUT: measure_parallelism.hpp + parallel_measure_pool.hpp + Iterator-Dispatch, Env COMDARE_MEASURE_PARALLEL) · LED:3468 (#37 PMC-Preflight = GEBAUT, director:1236-1248 + Test, set -e in beiden Profilen) · LED:3424 (measure_out-Verlustnaht = GESCHLOSSEN, clean-exclude + CSV-Artefakt) · LED:3326 („keine geltende experiment_golden.xml" = falsch seit 27.07., experiment_golden_kern.xml KANONISCH) · LED:3235 (Target heißt comdare_tier_measure_<host>, nicht _perm<i>). Plus RF-3 D1-Klasse BetriebssystemFeatureFehlt GEBAUT (axis_error.hpp:50).

### G.1 E-01..E-26-Board: 12 OFFEN · 10 TEILWEISE · 3 ERLEDIGT · 1 SUPERSEDED
**OFFEN:** E-01 (PAT-auf-dev+Cluster-Sync-Pflicht unverankert) · E-02 (Vier-Ledger-Audit; Prämisse teil-falsch: nur 3 Ledger existieren, prt-art/thesis haben keins) · E-04 (=A7) · E-07 (B+-Baum-Steuerungs-Nachweis: Gate-Definition FEHLT) · **E-14 (NAS-Creds backup1/backup2 — trigger-nah, stand in KEINER Paketliste → jetzt A12)** · E-17 (Runtime-Profile CT/RT-Hybrid; workload_matrix.* existiert nicht mehr) · E-18 (=A7) · E-19 (Runner-Fleet-Ist-Soll + Poll-Jitter, 0 Treffer) · E-23/E-25 (GitLab-API-Suchlauf vor Modul-Migration nie erfolgt) · E-24 (Gattung Container als LETZTER ABI-Schritt — fehlt in jeder Gate-Reihenfolge) · E-11 (siehe Eskalation a).
**TEILWEISE:** E-03 (Retry-ohne-Beleg-Kadenz LED:1236 widerspricht LED:774) · E-06 (kein Test gegen gemeinsamen Achsen-Walk) · E-08 (statisch gebaut target_isa_sub_axes.hpp:58/:65; OD-10-Betrieb offen =A6) · E-09 (Alt-ISA-Doppelbestand ohne DEPRECATED-Marker; Cross-Compile-Raum 0 Treffer) · E-10 (Eskalation b) · E-12 (b=Riss, Eskalation c) · E-15 (12 System-Perms entschieden =A4) · E-16 (kein Arbeitspaket Planer-Übernahme Thesis-Profile + Workload-Delegations-Naht) · E-20 (b BRING-Pflicht 0 Treffer) · E-21 (STACK-Form/Verbose-Regel 0 Treffer) · E-26 (Entscheid erledigt via §68b/F7; Lazy-Cache je Submodul unspezifiziert).
**ERLEDIGT:** E-13 (LED:160, 6733e480, Umsetzung projektend-gated) · E-22 (Goal-Matrix LED:151-155) · E-12a/c. **SUPERSEDED:** E-05 (LED:83 V7.2).

### G.2 DREI ESKALATIONEN — Owner-Fragen (Stempel-/Tier-Typ-Semantik, vor O-8-nahem Refactoring klären)
- **(a) E-11 Regelkonflikt:** LED:89 (V7.2) verbietet std::variant in ALLEN Tier-Binary-Typen und kippt still die Owner-Freigabe LED:2656/:2659 (Hybrid-Tier limitiert frei via Abstract Factory). Braucht Ausnahme-Vermerk in V7.2, sonst ist die Owner-Forderung per Ledger-Doktrin gelöscht. (Nicht verwechseln: „Beweis 3 Variant-Gate" = COMDARE_VARIANT_GATE/.variant-Sidecar, NICHT std::variant.)
- **(b) E-10:** OP-11 (Manager 27.07.) schließt Meta-Meta-Einträge aus der Organ-Stempelzeile aus (anatomy_version_stamp.hpp:48-50) — gegenläufig zur Owner-Forderung nr798-B3org; Konflikt im Plan-Doc unbenannt.
- **(c) E-12b IST/SOLL-Riss:** „OS-Unter-Achsen FINAL DREI" bindend (A-08/K-04), gebauter measurement/operating_system_axis.hpp hat NULL Unter-Achsen; OP-10 deklarierte Distribution/Version zu Stempel-VARIABLEN um. Entweder A-08-superseded-Vermerk oder fehlendes Paket.

### G.3 Punkt-Verifikate
- **OD-10:** HALB — statische Einhängung 27.07. (f6a5dc02, NumaNode/PageSubAxis, machine_resolved); Laufzeit-Teil ausdrücklich offen (=A6), kein Owner-Gate mehr. Drei unverwandte NUMA/page-Bedeutungsräume per static_assert abgesichert. **OD-1..OD-9: alle ENTSCHIEDEN** (§69); kein OD-11/12. Namenskollision: separate OD-1..6-Liste des Fehlerklassen-Frameworks (Task #29, PAUSIERT auf User-Freigabe) nicht vermengen.
- **E-04/E-18 (§68c, LED:3514):** E-04 = CI-Live-Fortschritt + generische Interface-Nachtests je Tier-Binary — Substrat da ([TESTAT]-Familie director:1145-1170), Slice-Kanal + Nachtests fehlen. E-18 = LaTeX-Anhang-VORWÄRTS-Kanal je CI (HAUPT-ZIEL) — CI regeneriert .tex nur als Artefakt; es fehlen Push nach anhang/{de,en}/tabellen/, eigenes 289-Write-Token, Post-measure-Rebuild.
- **Post-v3 (§60, LED:3212-3214):** R1 .so-ABI Planer↔CEB OFFEN (Live-Kette läuft über CMake/YAML-TEXT; experiment_dock_payload.hpp:58 selbst DEPRECATED ohne Live-Call-Site) · R2 Driver-Split ANALYSE-BEANTWORTET (PV-2: Delegation, keine Konsolidierung geboten — kein Bau-Task) · R3 Planer-CLI TEILWEISE (f5cf3954 clig.dev-Subcommands; offen: --print-env, --status-Aggregator, %/ETA/JSON-Marker). Begriff „post-v3" ab 27.07. nicht mehr in Gebrauch — Substanz lebt unter neuen Namen.
- **§62 COMPARE:** Registry-Wert vollständig gebaut (42b34354, RunMethodology::Compare + XSD/Parser/Tests) = „Wählbarkeit, nicht Vollzug"; modus-spezifischer Replay-Vergleich = Nach-Trigger-Paket D2; planner/ hat 0 compare-Treffer. CACHE/LOG/CLAIM = laufende Lager-Strecke.
- **KERN-Mess-Schema §59 (replace/merge/fulljoin): golden-neutrale Hälfte FERTIG (K1-K3, K6), die KERN-Naht NICHT angeschlossen:** K4 merge_plan_from_profile() nur vom Unit-Test gerufen; Director :1742 fährt weiter Kreuzprodukt OHNE per-Achse-Direktiven („Fork 4 … HIER NOCH NICHT scharf", sota_catalog.hpp:580-584); K5-Renderer ohne Produktions-Aufrufer + hartcodiert auf EINEN Prüfling/Slot (:150-155); merge-Stempel-Slot existiert (5-Zeilen-Layout, sizeof=136) wird aber produktiv NIE geschrieben (lazy_adhoc_source_gen.hpp:208 hart {}); K7b/K8 „INERT". **Abgabeprofil m3v2 nutzt keine per-Achse-Modi — die Direktiven-Naht greift in der Abgabekette faktisch nicht. → PFLICHT-Paket E.0 (vor Messung).**
- **320er-Abgabemessung:** Definition = Mess-UMFANG (Basis-320 = search_algo×node_type×memory_layout×prefetch = 4×4×5×4, 15 Slots gepinnt; m3v2-320 = +3-Combo-Tooling; wallclock-first, EINE System-Perm O3/no_extension, seriell, 3 Wiederholungen; when:manual USER-GO). Nie gelaufen; per FAHRPLAN:89 NACH Voll-Bau-4 (=E.1). DREI „320" auseinanderhalten: golden-320-Fixture (TABU, Byte-Wache) ≠ new-golden 2^17 ≠ 320er-Abgabemessung; „Gate 320/321" = CI-Testanzahl.

### G.4 §75-Kandidatenliste (IST-verifiziert; Liste fortschreiben)
Bereits entfernt: permutations_runtime_check.hpp, COMDARE_apply_simd_flags, cmake/permutations.cmake, V36.B-Kanal. Kandidaten: (1) LazyRunResult::built_new/built_skip ohne Leser (cache_engine_builder_iterator.hpp:697-698/:1029-1030) · (2) director:281 Stale „17-Achsen-ids" · (3) „17-Organ-Kartesik"-Kommentare all_axes_golden.profile.xml:183 + cacheline_study.profile.xml:142 · (4) --emit-tier-ci-Alias (bewusst bis Emissions-Migration, §77-P8) · (5) test_a9b unregistriert (CMakeLists:3510) · (6) Marker-Doktrin W-2/W-3 (write-only _gn_chunk_markers; async_push_pump.hpp:63-64 YAML-Verweis tot) · (7) 3 deprecated Header: comdare_is_original_macro.hpp:3, plan_legend.hpp:124, experiment_dock_payload.hpp:58 · (8) F8-Alt-Form planer_block_value.hpp:20-26 · (9) COMDARE_VARIANT_GATE + 3 Sidecars (durch Fingerprint-Gate obsolet) · (10) Zeilen-Referenz-Drift director.hpp:868-871, batch_planner.hpp:14/:35 · (11) Copy-Paste Lane-Budget director:1107/:1255 · (12) COMDARE_GN_RANGE ohne Konsument · (13) PRUNE-TESTAT-Drift :1325 · (14) fingerprint_key_source.hpp:37-40 Doku-Drift · (15) declared-Attribut-Abbau · (16) P-C4/G-C6 Doku-Paket · (17) COMDARE_LEGACY_MESSREIHEN (nach V-5c) · (18) Alt-ISA-Doppelbestand axes/simd/axis_09_isa_* + topics/hardware/axis_09_isa/ (E-09, DEPRECATED-Marker fehlt).

### G.5 Unverbuchte Offen-Posten §59–§77 (Einordnung)
Trigger-/abgabe-relevant → verbucht: **E-14 NAS-Creds → A12** · **§61-Dual-Weg-Beleg → A3** · **#48-Scheibe-6 → E** (XML-Sync-Gate-Umhängung, gated „nach 320er + USER-GO"; fixture_sync_check.cmake:3 zeigt aufs Alt-Paar) · **§61-Modi Release-Wallclock-Beweis → E** (Naht da, Deliverable fehlt) · **#51 tier150-Ersatz → E** (bis 320er-Umstellung blockiert). Detail zu A1/G-E6 (OE-C-Versionierung): W12-Quelldaten-Migration ist erst KOSMETISCH („v1"→„v1.0.0" 122× uniform, keine per-Algo-Differenzierung; XML-Registries ohne Versionsfelder) — der G-E6-Bau muss das real einlösen (G-C5-bestätigt). Ehrlich nach-Trigger/post-Abgabe: §65 Tools-Lagerhaltung #32 (POST-ABGABE; ~14G tote gcc-Temps prod1) · §73.1 Ein-Hauptkanal-Konsolidierung (catalog_codegen+anatomy_codegen_runner = Merge-Kandidaten, Dauerzustand) · §73.5 Q6 Angebots-Zuschnitt-Band · §69.9 C-3a-Scharfschaltung (Vorab-GO liegt; Gate=C-3b-Beleg+O-4; 3 Stubs gemeinsam, Kill-Switch, rsp-Diff) · §70.4 RF-4 + §73.3 Q4 (Infra-Kanal) · SECURITY #327 PAT-Rotation (seit 20.07. „dem User vorgelegt", kein Vollzug — Owner-Sicht nötig).

## H. OWNER-Entscheide 02.08. — ALLE BEANTWORTET (Wortlaut: docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md)

1. **E-11 = kein Konflikt:** Hybrid-Tier-Binaries sind eine eigene Stufe HINTER der CEB (mehrere ABI-stabile Prüf-Docks, Factory-Proxy auf Tier-Binaries, std::variant als definierte Ausnahme in wahlweise statischem/Runtime-Array, XML-Konfiguration in der Auswertungsphase). In plain Tier-Binaries bleibt std::variant VERBOTEN. → Design JETZT (Fable xhigh + ultracode, Owner-Auflage), Bau in Auswertungsphase.
2. **E-10 = REGRESSION:** Meta-Meta-Stempeleinträge PFLICHT wie alle Hauptachsen; dynamisch per Metaprogrammierung ANS ENDE der jeweiligen Realm-Zeile; **merge-Zeile darf nicht existieren** (PRT-ART läuft merge gegen Organ-Achsen); experimentelle Prüfling-Algorithmen per **'e'-Versions-Suffix**. Realm-Trennung derzeit defekt → wirkt auf Lagerhaltung. → **A13, trigger-blockierend.**
3. **E-12b = Paket JETZT PFLICHT:** OS-Unter-Achsen (final drei) sind die Basis der Wiederverwendbarkeit/Zuordbarkeit — ohne sie Neubau aller Binaries bei Einführung; heute installiert Infra weitere OS. → **A14, trigger-blockierend.**
4. **C3 = schärfen (GO)**; zusätzlich kommen heute **RISC-V, macOS M1, macOS x86** als Plattformen dazu (Querschnitt: target_isa/OS-Achsen, Runner, E-19).
5. **#327 = nach Messfenster rotieren**; Handout an Infra sofort.
6. **#29 Fehlerklassen-Framework = JETZT mitbauen** → **A15**.
7. **E-24, E-19, E-02, E-23, E-21 = JETZT PFLICHT** → **A16**; Rest (inkl. E-25) nach Abgabe ebenfalls PFLICHT.
8. **Rahmen-Pass = volles GO**; Danksagung Habich bescheiden+diszipliniert, nicht überschwänglich.
9. **E-04 = VOLLAUSBAU vor Trigger** (A7); „ALLES genannte wird voll gebaut."
