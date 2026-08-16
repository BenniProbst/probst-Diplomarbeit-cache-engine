# ARENA-KETTEN-KARTE — Messung -> Arena -> Drain -> sequentielle Blaetter

Konsolidierung der 3 wf-arena-Sweeps (Arena-Kette / Waermer+Rollback / Persistier-Kette), Fable max.
Alle tragenden Datei:Zeile-Anker am 16.08. am Objekt NACHVERIFIZIERT (nicht blind aus den Sweeps uebernommen).
Wurzeln: super = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine · ce = super/Code/external/comdare-cache-engine.
ZEILENDRIFT-WARNUNG: die Sweep-Zeilennummern des super-Ledgers sind um ~+83 gedriftet (Sweeps: KON88=Z.19 -> real Z.102). Diese Karte traegt die AKTUELLEN, verifizierten Nummern.

---

## 0. KETTEN-BILD

SOLL (P2-Owner-Kern, KON88, Ledger:118-127; Owner-Verbatim kon64_sammlung.md:1411-1422):

```
Mess-Aufruf:  save_all -> KALTER Aufruf -> rollback_all -> WARMER Aufruf
                   |____________________________________________|
                                    v
              EINE Zeile je Mess-Aufruf (Warm-Werte + KALT-DIFF +/-x je Spalte/Feld)
                                    v
              MESS-ARENA (RAM = EINZIGES hartes Limit)
                                    v  (nachgelagert, nie synchron)
              xlsx-Drain: Blatt -> voll? -> naechstes sequentielles Folge-Blatt -> ... bis Arena leer
```

IST: ZWEI unverbundene Welten, KEINE davon ist die SOLL-Kette:

```
LIVE:     Op -> two_phase_measure (Kaltwert wird VERWORFEN) -> vector-push_back (Messfenster!)
             -> lazy_csv_header-Zeile (keine Kalt-Spalte) -> ergebnis_mappe_naht SYNCHRON in Writer
             -> Fassung 3: 2 Zeilen je Aufruf (In/Out) -> HARD-ABORT bei 1.048.576 Zeilen
DORMANT:  checkpoint<E,R> -> MessArena+StapelArena (0 Produktionsaufrufer, kein Drain, kein Writer-Anschluss)
```

---

## A. IST AM OBJEKT (gebaut, mit Datei:Zeile) — 21 Posten

### A-Live-Messpfad (Zwei-Phasen/Waermer)
- **A1 two_phase_measure** (save->Warmup->rollback->Messung, je Op): ce libs/cache_engine/builder/anatomy_commands/tier_observe_trace_abi.hpp:133-141; Verwerf-Zeile :137 `(void)timed_op(); // Phase 1: Warmup (verworfen)`; Aufrufstellen :248/:269/:286. **Der Kalt-Rohwert entsteht heute bereits und wird explizit weggeworfen** — die einzige Stelle, an der KON88s Kalt-Diff-Quellwert existiert.
- **A2 rollback_is_empirically_exact** (empirische Exaktheits-Probe vor Zwei-Phasen-Freigabe): tier_observe_trace_abi.hpp:112-131 (Audit-Luecke „prueft nur rb!=nullptr" geschlossen).
- **A3 perm_runner-Verdrahtung**: PermResult.two_phase_valid harness/perm_runner.hpp:142 (false = KEINE stille Kalt-Messung als gueltig, Gate-Fail nullt :176); rb_exact-Gate + Weiterreichen des Rollback-Handles im Lastprofil-Pfad (Sweep 2: :302-330).
- **A4 Segment-Warmup-Batch OHNE Rollback** (4 Stellen, Pfad B/18-Achsen): ce libs/cache_engine/anatomy/abi_adapter.hpp:706, :792, :1107, :2025 — je „Warmup (verworfen)", grober als A1, kein save/rollback. (:792 war im Ledger bislang unerwaehnt.)
- **A5 run_observable_perm misst KALT** (Legacy-Pfad, kein Rollback-Parameter, Zeitnahme direkt nach tier_clear): perm_runner.hpp:196-220 — unveraendert seit KON45/47-Feststellung.
- **A6 Drift-Gate** (produktiv): harness/drift_gated_cell.hpp:100 reps=3, :120 max_reruns=5, :128 behaelt die ZULETZT gemessene Probe (:220); Aufrufer builder/experiment_tree/cache_engine_builder_iterator.hpp:2938-2967. Andere Achse als KF-10-Wiederholung.
- **A7 AbiFillLevelSnapshot** (Live-Ablage der Zwei-Phasen-Werte): tier_observe_trace_abi.hpp:60-68 `std::vector<int64> read_ns/write_ns/delete_ns`, push_back IM Messfenster (:254 u.a.) — verstoesst gegen die Arena-Doktrin „keine Allokation im Messfenster", die den Arenen-Bau motiviert hat.
- **A8 lazy_csv_header** (~150-Spalten-Wire-Schema inkl. two_phase_valid-Spalte): cache_engine_builder_iterator.hpp:555-620 — KEINE Kalt-/Diff-Spalte (0 Treffer „kalt"/„diff").

### A-Live-Persistierung (xlsx/csv)
- **A9 ergebnis_mappe** Abstract-Factory/Strategy/Interfaces: ce libs/cache_engine/builder/lager_ablage/ergebnis_mappe.hpp — ErgebnisMappenFactory::oeffne :631-643, Format xlsx|csv :76, IErgebnisMappe/IErgebnisBlatt :367-415; + xlsx_ergebnis_writer.cpp.
- **A10 Fassung-3-Profilblatt**: mess_ebene_blatt() ergebnis_mappe.hpp:140-236 — 8 Spalten (Prozess, Thread, Mess-Ebene, Ziel, Aufrufer, Checkpoint, Zeitpunkt, Messwerte*) :167-172, **2 Zeilen je Aufruf** (Checkpoint::In/Out) :157-165/:217-226.
- **A11 Hard-Abort-Doktrin im Code** (Fassung 2): class ErgebnisSchreibFehler :246ff, kXlsxZeilenlimit = 1'048'576 :340, xlsx_zeile_erlaubt :347-351, zeile() „kann ErgebnisSchreibFehler{Zeilenlimit} werfen ... statt still zu truncaten" :374-376. KEINE Fortsetzungsblatt-Logik im Writer (0 Treffer).
- **A12 ergebnis_mappe_naht (A9-S5, LIVE)** — die tatsaechliche Persistier-Naht: ce libs/cache_engine/profile_facade/ergebnis_mappe_naht.hpp — Factory::oeffne :449 (xlsx-Stamm) / :465 (csv-Kind), Mappen-Member :712/:716; eingebunden via profile_facade/profile_run_entry.hpp. Schreibt jede Zeile SYNCHRON aus der Mess-Schleife, OHNE jede Arena (Sweep-3-Kernbefund). Damit ist die 09.08.-Aussage „lager_ablage hat 0 Produktions-Targets" inzwischen ueberholt — Produktion existiert, aber am Arena-Konzept VORBEI.
- **A13 Datei-Namens-Grammatik** (xlsx-Blattdatei als letztes Lager-Ketten-Glied, sparse `<datum>-<zeit>[_kvkette]`): lager_pfad_grammatik.hpp:398-436, consteval-getestet (Ledger KON87 :141-144 „DATEI-Haelfte BEREITS GEBAUT").

### A-Dormante Arenen (measure_storage — gebaut, unit-getestet, 0 Produktionsaufrufer)
- **A14 MessArena** (nur ANHAENGEN, monoton, Auswertung zum Schluss): ce libs/cache_engine/builder/measure_storage/mess_arena.hpp (313 Z.) — Ueberlauf-Politik :36-38 „ZAEHLEN, MELDEN, WEITERMESSEN" (NIE Abbruch), kUeberlaufSlot :213/:266, Kapazitaet FIX per mmap (mess_speicher_kanon.hpp:100-137), anhaengen() nicht-atomar; 32-Byte-POD-Zeile MessCheckpointZeile mit EINEM Messwert-Feld.
- **A15 StapelArena** (LIFO, Mess-Ebenen-/Modul-Stack fuer checkpoint_measure): stapel_arena.hpp (277 Z.).
- **A16 CheckpointSpeicher** (beide Arenen in EINEM Objekt, compile-hart cacheline-getrennt) + kapazitaet_zeilen_rechnen (ueberlaufsicher): checkpoint_speicher.hpp:51-70, :131-138; Drift-Faktor-Kommentar „bis zu 18" :121.
- **A17 CheckpointMeasure<MK>**: checkpoint_measure.hpp — init/reserve VOR dem Fenster :223-226; checkpoint<E,R> haengt je Aufruf GENAU 1 Zeile an (:253), Ein->stapel.hinauf :267, Aus->stapel.herunter :269; EIN speicher_-Member :314 (keine Pro-Thread-Instanzen).
- **A18 mess_naht SpannWache** (RAII: geklammerter Aufruf = 2 Arena-Zeilen In+Out) + Steuerdocks: ce libs/cache_engine/mess/mess_naht.hpp:171-188, steuer_dock.hpp, konfiguration.hpp.
  0-Aufrufer-Beleg (vierfach): Eigenaussage checkpoint_measure.hpp:16-18; planner_mengen_types.hpp:31-32 „in KEINE Mess-Schleife verdrahtet"; measure_storage/ und mess/ OHNE CMakeLists, nicht in builder/CMakeLists.txt:19-46, nur tests/unit (CMakeLists.txt:6443ff, „standalone"); git log: 4 Commits 09./15.08., keine Verdrahtung.

### A-Planer/Kapazitaet
- **A19 mengen_rechnen/check-size**: ce libs/cache_engine/profile_facade/planner/planner_mengen_types.hpp — drift_faktor_rechnen(reps,max_reruns) :193-201 (Vorgabe 3/5 => bis 18), verdrahtet :321-322 als dritter Parameter der Kapazitaetsformel; Deckelurteil{KeinDeckel,Haelt,Gerissen,Unbestimmbar} :93-98, fail-closed bei zeilen_je_op==0; CLI --max-bytes = Deckel der Arena EINES Mess-Prozesses (apps/experiment_planner/main.cpp:534).
- **A20 Arena-Bemessung je MESS-PROZESS** (groesste Kombination, ODER ueber aktive Ebenen, kein Mittelwert): profile_facade/profile_run_facade.cpp:1514-1517.

### A-Nachbarn/Fallen (gebaut, aber NICHT die Kette)
- **A21 Verwechsler**: ThreadArena/InMemoryMeasurementBuffer (include/cache_engine/measurement/thread_arena.hpp:13, in_memory_measurement_buffer.hpp:44-92) — vector-Member, vom Design ausdruecklich als Nicht-Vorlage gebrandmarkt; repetition_plan.hpp (KF-10, experiment_tree/repetition_plan.hpp:17-41) — Orphan, einziger Aufrufer die eigene Testdatei; „Arena" in ext/allocator/* + ext/queuing/* = allocator-interne Arenen der SUT-Achsen, anderer Gegenstand.

---

## B. GEPLANT (dokumentiert, noch nicht gebaut) — 8 Posten

- **B1 KON88-P2-Drain-Kette komplett** (Arena zuerst -> xlsx nachgelagert -> sequentielle Folge-Blaetter bis Arena leer -> RAM einziges hartes Limit): Ledger:118-127; Owner-Verbatim kon64_sammlung.md:1411-1422. 0 % Code.
- **B2 Kalt-Diff-Felder + EINE Zeile je Mess-Aufruf**: Ledger:118-120 (je Spalte relativer +/-x-Diff des kalten gegen den warmen Aufruf im Feld der warmen Zeile). Kein Feld existiert (A8, A10-Gegenprobe: 0 Treffer „kalt" in lager_ablage und lazy_csv_header).
- **B3 Fortsetzungsblatt-Namensreserve** `.2`/`.3` (max Name + `.99` = 26 <= 31): design_sheet_hierarchie_v3.md:172 („nur falls P2 mit Fortsetzungsblatt beantwortet wird" — Bedingung durch KON88 JETZT erfuellt), :296-300. Nicht implementiert; Achtung: die Sheet-EBNF darunter ist durch KON88-P1 TEIL-UEBERHOLT (Hierarchie -> Filesystem, Ledger:104-117), die Fortsetzungs-MECHANIK ist „in der Sache bestaetigt" (Ledger:126-127), ihre Namensform muss unter P1 neu hergeleitet werden.
- **B4 P4 Export-Anschluss** MeasureStorage -> IErgebnisMappe/ErgebnisMappenFactory: super docs/plaene/20260809-MEASURESTORAGE-design-und-deep-research.md:212, :281 (2-3 Tage). Die dortige Klammer „heute 0 Produktions-Targets" ist Stand 09.08. und seit A12 (Naht) stale — der P4-KERN (MeasureStorage als Konsument) bleibt offen.
- **B5 P2/P3 checkpoint_measure-Anschluss + Aggregation** (Roh-Arena-Zeilen -> Auswertung): deep-research.md:277-279, „blockiert durch OE-3".
- **B6 Pro-Thread-MessLog** unter prozessweitem Sammler + fetch_add(relaxed) fuer Debug=parallel: deep-research.md:182. Gebaut ist EINE globale Instanz mit nicht-atomarem Append (A14/A17).
- **B7 KON47-04 PAAR-Muster** (je Wiederholung Lauf1 verwerfen + Lauf2 speichern, x3 = 6 Laeufe/3 Werte; --debug 1x kalt) + Testfamilie T-1..T-9 (Paar-Zaehlung 2x3, --debug-Zweig 1x, Verwerf-Beweis): Ledger:4125-4147 (ersetzt KON45-03-Zell-Warmup-Vorlage :4134); Durchsetzung auch :3268-3270. 0 Code-Treffer (Sweep-2-Gegenprobe), run_observable_perm unveraendert kalt.
- **B8 wf-arena-Explore** (10 Wochen, Sonnet 5 max very thorough, „die geplante+dokumentierte Arena-Ablage-Kette heben"): Ledger:124-126, gestartet, noch kein Backup-Ordner — die 3 Sweeps + diese Karte sind die erste Bearbeitung.

---

## C. DELTA ZUM P2-OWNER-KERN — was widerspricht, was fehlt

P2-Kern in 4 Bestandteilen (Ledger:118-127 = kodifiziert; kon64_sammlung.md:1411-1422 = Owner-Verbatim):
(i) EINE Zeile je Mess-Aufruf · (ii) Kalt-Diff +/-x je Spalte im Feld der warmen Zeile · (iii) Arena-first, xlsx nachgelagert, sequentielle Folge-Blaetter bis Arena leer · (iv) einziges hartes Limit = RAM der Mess-Arena.

- **C1 [zu i — WIDERSPRICHT]** Fassung 3 schreibt 2 Ausgabezeilen je Aufruf (Checkpoint::In/Out): ergebnis_mappe.hpp:157-165/:217-226. Die Arena-ROH-Ebene (2 Zeilen In+Out je geklammertem Aufruf, checkpoint_measure.hpp:253/:267/:269) ist eine ANDERE Granularitaet und bleibt: 2 Zeitstempel bleiben noetig, nur die AUSGABE fasst sie zu 1 Zeile zusammen — diese Roh->Sheet-Aggregation existiert NIRGENDS (B5).
- **C2 [zu ii — FEHLT]** Der Kalt-Rohwert wird an der einzigen Entstehungsstelle VERWORFEN: `(void)timed_op()` tier_observe_trace_abi.hpp:137. Verbuchen statt Verwerfen + Diff-Rechnung + Feldschema fehlen komplett (kein Kalt-/Diff-Feld in lazy_csv_header :555-620 noch lager_ablage, 0 Treffer).
- **C3 [zu ii — WIDERSPRICHT]** Zwei Messpfade koennen prinzipiell KEINEN Kalt-Diff liefern: run_observable_perm misst kalt ohne Waermer/Rollback (perm_runner.hpp:196-220), und die 4 Segment-Warmup-Batches verwerfen ohne Rollback (abi_adapter.hpp:706/:792/:1107/:2025) — anpassen oder ausbuchen (deckt sich mit KON47-04-Auftrag).
- **C4 [zu iii — WIDERSPRICHT]** Der LIVE-Pfad ist das Gegenteil von Arena-first: ergebnis_mappe_naht (A12) persistiert synchron aus der Mess-Schleife OHNE Arena; die Zwei-Phasen-Werte liegen in std::vector mit push_back IM Messfenster (A7) statt in einer Arena. „Messwerte liegen ZUERST in Arenen" ist heute an keiner Stelle wahr.
- **C5 [zu iii — WIDERSPRICHT+FEHLT]** Hard-Abort statt Folge-Blatt: kXlsxZeilenlimit=1'048'576 + ErgebnisSchreibFehler{Zeilenlimit}-Wurf (ergebnis_mappe.hpp:340/:374-376) = GEGENTEIL der Vorgabe; Fortsetzungs-Reserve `.2` nur EBNF-Plan (B3), 0 Writer-Code; die Drain-Schleife Arena->Blatt_n->Blatt_{n+1} existiert nicht — Arena und Writer kennen einander nicht (Scope-Grenze ergebnis_mappe.hpp:175-195; einzige AusleseErgebnis-Verwender = measure_storage selbst + Tests).
- **C6 [zu iv — WIDERSPRICHT (Politik, unaufgeloest)]** Die gebaute Arena bricht NIE ab: fixe mmap-Kapazitaet, Ueberlauf wird gezaehlt+gemeldet+weitergemessen (mess_arena.hpp:36-38/:213/:266). Owner: „Der harte Abbruch kann also nur am RAM Limit sterben, wenn die Mess-Arena voll ist" (kon64:1420-1422) — impliziert wachsendes ODER hart-sterbendes Modell. Drei Politiken moeglich (fest+zaehlen / fest+Abbruch / wachsend bis RAM): Owner-/Design-Entscheid noetig, hier NICHT aufgeloest.
- **C7 [zu iv — UNEINHEITLICH]** RAM-Bemessung: Kommentar „Sicherheitsfaktor 2" (mess_arena.hpp:224; Ursprung deep-research.md:186) vs. verdrahteter drift_faktor bis 18 (checkpoint_speicher.hpp:121, planner :193-201/:321-322). Der Rechenweg nutzt 18; der Faktor-2-Text ist stale (inkl. gedrifteter Querverweise, planner_mengen_types.hpp:25 zitiert „checkpoint_speicher.hpp:77-80", real :121).
- **C8 [zu iii+iv — FEHLT (Formatfrage)]** Die existierende Arena-Zeile ist 32-Byte-POD mit EINEM Messwert-Feld (MessCheckpointZeile, gebaut fuer checkpoint_measure-Tracing) — strukturell zu schmal fuer die ~150-Spalten-PermResult-Zeile + Kalt-Diff-Felder. „Messwerte ZUERST in Arenen" kann sich NICHT unveraendert auf das bestehende Arena-Paar stuetzen: erweitern oder zweites Arena-Paar fuer Tier-Perf-Zeilen = Kernfrage von wf-arena.

---

## D. UEBERHOLT-Stellen (mit Fundort)

- **D1 ErgebnisSchreibFehler{zeilenlimit}-Doktrin (Fassung 2, 02.-03.08.)** — Fundorte der alten Doktrin: Ledger:28830ff (Fassung-2-Absatz, A9-Dossier); CODE LEBT NOCH ergebnis_mappe.hpp:246/:340/:374-376; zuletzt als „geltende Doktrin" zitiert design_sheet_hierarchie_v3.md:296-300. UEBERHOLT durch KON88 P2 „Harter Abbruch am Excel-Limit ist SYSTEMFREMD" (Ledger:121-124). Die UEBRIGEN Fassung-2-Klauseln (31-Zeichen-Sheetnamen-Wache, Dateiname-Grammatik, CSV-Fallback ueber dieselbe Factory) gelten fort.
- **D2 KON87 „8-Spalten-Profilschema (2 Zeilen je Aufruf)"** — Ledger:150-152. Die 2-Zeilen-Annahme durch KON88 KORRIGIERT (Ledger:127). CAVE (Sweep-2 #12, eigene Einordnung dort markiert): KON87 vermengte vermutlich das checkpoint_measure-In/Out-Schema (Instrumentierungs-Gleis) mit der Tier-Mess-Zeile; die In/Out-ROHEBENE der Arena bleibt bestehen, korrigiert ist die AUSGABE.
- **D3 KON87-P2-„OFFEN"-Frage** (harter Fehler ODER Fortsetzungsblatt `.2`?) — Ledger:162-165. BEANTWORTET durch KON88: Fortsetzungsblatt, „in der Sache bestaetigt" (Ledger:121-127).
- **D4 S001..Snnn-Sheetnamen (Fassung 2)** — ENTFAELLT per V-A9-6 (Ledger:149-150; design_sheet_hierarchie_v3.md:9 „Holzweg"); zusaetzlich KON88-P1: Hierarchie lebt im FILESYSTEM, Sheet-EBNF teil-ueberholt (Ledger:104-117). Verwandte, ANDERE Ueberholung als P2 — nicht vermengen.
- **D5 KON45-03-Zell-Warmup-Vorlage** („ein vorgeschalteter Warmup-Lauf") — Ledger:4298ff; ERSETZT durch KON47-04-PAAR-Muster (Ledger:4125-4147, explizit :4134 „ersetzt die KON45-03-Zell-Warmup-Vorlage"). Bau-/Testposten daraus NICHT gelandet (B7).
- **D6 „Sicherheitsfaktor 2"-Kommentartext** — mess_arena.hpp:224 (+ stale Querverweis planner_mengen_types.hpp:25) — vom verdrahteten drift_faktor (bis 18) ueberholt; nur noch Kommentar, kein Rechenweg (C7).

---

## E. BAU-POSTEN-LISTE fuer S-13/#18 (Landung Di 25.08., Buendel mit #48/#57)

Reihenfolge = Abhaengigkeitsordnung. E1 ist Entwurfs-Vorstufe (wf-arena), E2-E10 Bau.

- **E1 [ENTWURF ZUERST — Kern wf-arena]** Arena-Zeilenformat entscheiden: bestehendes 32-Byte-Paar erweitern ODER zweites Arena-Paar fuer die breite Tier-Perf-Zeile (~150 Spalten + Kalt-Diff) (C8). Dazu RAM-Politik-Vorlage an Owner: fest+zaehlen vs. fest+Abbruch vs. wachsend-bis-RAM (C6) — Ein-Satz-Vorlage, blockiert E6/E7 nicht komplett, wohl aber das Ueberlauf-Verhalten.
- **E2 Kaltwert verbuchen statt verwerfen**: two_phase_measure Phase-1-Rueckgabe einfangen (tier_observe_trace_abi.hpp:137), Ablage warm+kalt je Op (Feld statt `(void)`).
- **E3 Kalt-Diff-Schema bauen**: je Spalte relativer +/-x-Diff in der warmen Zeile; lazy_csv_header (iterator :555-620) + Blattschema additiv erweitern (Feld traegt Warm-Wert + Kalt-Diff; Formatfrage im Design klaeren).
- **E4 EINE Zeile je Mess-Aufruf auf AUSGABE-Ebene**: Fassung-3-In/Out-Paar (ergebnis_mappe.hpp:157-165/:217-226) zu 1 Zeile zusammenfassen; Aggregator Roh-Arena-Zeilen -> Sheet-Zeile bauen (B5; OE-3-Blockade pruefen). Roh-Ebene In+Out NICHT anfassen (C1).
- **E5 Hard-Abort ersetzen durch Fortsetzungsblatt**: Zeilenlimit-Wurf im zeile()-Pfad (ergebnis_mappe.hpp:374-376) -> deterministisches Folge-Blatt (Namens-Glied `.2`.., Reserve 26 Zeichen, design_v3:172); Namensform unter KON88-P1-Sheet-Ordnung neu herleiten (B3). Test: Limit-Ueberschreitung erzeugt Folgeblatt, KEIN Wurf; RAM bleibt einziges hartes Limit.
- **E6 Drain-Schleife bauen**: Arena -> sequentielle Blaetter bis Arena leer (Arena-first, xlsx nachgelagert); MeasureStorage als Konsument von IErgebnisMappe (P4, deep-research:212/:281); die synchrone Naht (A12) auf nachgelagerten Drain umstellen — S-13/#18-Kernstueck (heilt zusammen mit Export-Element+Ziel-Filter den unbedingten measurement_sink-Kanal, KON32-01).
- **E7 Zwei-Phasen-System an die Arena anschliessen**: AbiFillLevelSnapshot-vector-push_back im Messfenster (A7) durch Arena-Ablage ersetzen — hebt den Verstoss gegen die Allokations-Doktrin und verbindet die zwei bislang unverbundenen Welten (Voraussetzung fuer E2/E3 im Live-Pfad).
- **E8 KON47-04-PAAR-Muster landen** (B7): je Wiederholung Paar (verwerfen+speichern) x3, --debug 1x kalt; run_observable_perm anpassen ODER ausbuchen (C3, inkl. der 4 Segment-Warmups pruefen); Tests T-1..T-9 (Paar-Zaehlung 2x3, --debug-Zweig 1x, Verwerf-Beweis). [Anschluss an Task #38b Warmup-Paar W2 Sa/So.]
- **E9 measure_storage produktiv verdrahten**: CMake-Aufnahme (eigene CMakeLists + builder/CMakeLists.txt), checkpoint_measure in die Mess-Schleife (heute 0 Aufrufer, A18-Beleg); Threading-Entscheid dazu: eine Instanz nicht-atomar festschreiben (golden 1-Thread) ODER Pro-Thread-MessLog + fetch_add bauen (B6) — LAUTE Compile-Meldung vor Verschiebung gemaess Haus-Regel.
- **E10 Stale-Texte bereinigen** (mit E1-Entscheid): Faktor-2-Kommentar mess_arena.hpp:224, gedriftete Querverweise planner_mengen_types.hpp:25 (D6) — Doku deprecaten, nie loeschen.

---

## F. Rand-Anmerkungen

- Sweep 3 wurde in der Uebergabe MITTEN im letzten Abschnitt abgeschnitten (Frage „eine oder zwei 2-Zeilen-Doktrinen" offen zitiert); der Kernbefund, die Fassung-2-Identifikation und das Owner-Verbatim sind vollstaendig enthalten und hier verbaut. Die abgeschnittene Restfrage ist durch Sweep-2 #12 + D2 abgedeckt.
- Begriffshygiene: „Cache-Waermer" (Substantiv) = Ledger-Verdichtung; Owner-Rohtext sagt nur „kalter Aufruf". Der Code nennt ZUSAETZLICH den Fallback OHNE Warmup „Kalt-Messung" (rb==nullptr) — zwei verschiedene „kalt"-Bedeutungen, bei Bau und Tests trennen. „ice_cold_cache"/ccache = CI-BUILD-Cache, nie Messung.
- „Fallback 5/2/1" = PMC-Hardware-Counter-Fallback, NICHT die Warmup-/Drift-Retry-Kette (die 5 dort ist DriftGateConfig::max_reruns) — nicht konflationieren.
