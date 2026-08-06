# DELTA-PRUEFUNG: alte A/B/C-Strang-Systeme vs. neue P0-P4-Wellen (06.08.2026, adversarial)

> OWNER-HAUPTFRAGE (verbatim): "die Hauptfrage ist, ob wir aus dem alten A/B/C Strang System etwas
> in den neuen Wellen vergessen haben. Bitte Delta mit Opus 5 max effort very thourough pruefen."
>
> Auftrag: ALT-Menge bilden, NEU-Menge bilden, ALT-minus-NEU je Posten am Objekt pruefen.
> Status-Schluessel: (a) ERLEDIGT-belegt . (b) BEWUSST SUPERSEDED mit benanntem Nachfolger .
> (c) STILL VERSCHWUNDEN = VERGESSEN . (d) UMBENANNT/AUFGEGANGEN (Inhalt geprueft, nicht nur Titel).
> KEIN Commit (Lead committet). ASCII-only.

---

## 0. GESAMTURTEIL VORWEG

**Es ist wenig VERLOREN, aber die Verlustklasse ist systematisch und sie ist genau eine:**
Das heutige Konsolidierungs-Register ist per Konstruktion ein **14-TAGE-Fenster** und beginnt
am **23.07.** (`docs/sessions/20260806-REGISTER-todo-konsolidierung-14-tage.md:1` Titel,
`:7` Methodik: "Ledger 23.-31.07., Ledger 01.-06.08."; die adversariale Gegenpruefung lief
"Ledger 3420-4414 vollstaendig", `:205`). Der letzte **Voll-Konsolidierungs-Block der Vor-Zeit**
ist aber **LEDGER:2829-3060 (Paragraf 55, 20.07.)** -- er liegt VOR dem Fenster und wurde
**nicht** in die neue Systematik ueberfuehrt.

Damit gilt:
- Alles, was zwischen 23.07. und 06.08. mindestens einmal erwaehnt wurde, ist im Register.
- Alles, was seit **21.07. nie wieder** erwaehnt wurde, hat heute **keinen Besitzer** -- unabhaengig
  davon, ob es erledigt, superseded oder offen ist. Fuer den grossen Teil davon laesst sich am
  Objekt ERLEDIGT belegen (siehe Abschnitt 3, Status a) -- die Doku-Luecke ist dort nur kosmetisch.
- Es bleiben **20 Positionen**, bei denen weder Vollzug noch Supersede belegbar ist. **6 davon
  beruehren Trigger oder Abgabe**, 14 gehoeren nach der Abgabe.

**Der Kronzeuge ist eine einzige Ledger-Zeile.** Der Liegengeblieben-Sweep vom 05.08. hat die
Luecke selbst schon gefunden und in ZWEI benachbarte Zeilen geschrieben:

- `LEDGER:4861` = "VOR-TRIGGER-CHECKLISTE (B1-B13 ...)" -> **vollstaendig ins Register uebernommen**
  (Register `:64-75` "Tab. B B1".."Tab. B B14").
- `LEDGER:4862` = "VOR-ABGABE-KLAERUNGEN: A14 FF0-Multi-Plattform 'Abgabe-Blocker, hoch'
  (Paragraf 55:2916) + Anhaenge-B/E-Stubs -- superseded? . **A15 Paragraf-55-Gesamt-Reconcile
  ueberfaellig (letzter Voll-Block 20.07.)**" -> **NICHT im Register** (Volltext-Grep "A14"/"A15"
  im Register: 1 Treffer, und der ist die Namenskollision "OS-U4/A14-Rest", Register `:71`).

Die **B-Liste** wurde also mitgenommen, die **A-Liste derselben Quelle** nicht. Und der Posten,
der genau diese Uebertragung angemahnt hat (A15), ist selbst der prominenteste Verlust.

---

## 1. ALT-MENGE (was gepruefet wurde)

| # | Buchstaben-System | Datum | Quelle (Anker) | In NEU-Menge? |
|---|---|---|---|---|
| ALT-1 | **Straenge A-G** (7 Themenbloecke fuer #253-#275) | 05.07. | `docs/HANDOVER-BEP-ABTEILUNG-20260705.md:34-50`; Board `docs/HANDOVER-ANHANG-TODO-BOARD-20260705.md:5-61`; `LEDGER:1256` | nur mittelbar, ueber Paragraf 55 |
| ALT-2 | **F1-F14 (I)** Modul-Migration | 07.07. | `LEDGER:724`, `:843` | erledigt/disponiert |
| ALT-3 | **G-Stack G1-G8 + G-INFRA** | 16.-19.07. | `LEDGER:207` | G5=#274 offen (s.u.) |
| ALT-4 | **F1-F12 (II)** Entscheidungsrunde 2 | 16.07. | `LEDGER:533` | direktiv befolgt |
| ALT-5 | **F1-F6 / H-1..H-10 (III)** | 17.07. | `LEDGER:519` | gebaut |
| ALT-6 | **B1-B15 + Paragraf-52-Auftraege** | 20.07. | `LEDGER:2753-2795` | aufgeloest |
| ALT-7 | **BAND A/B/C/D/E + S1-S23** | 20.07. | `docs/plaene/20260720-SESSION-PLAN-V2-voll-erweitert-alle-straenge.md:11`, `:402-412` | BAND C/D/E teils unbesetzt |
| ALT-8 | **Paragraf 55 = Konsolidierter Gesamtblock v2** (Single-Source ALLER offenen Punkte, 8 Straenge) | 20.07. | `LEDGER:2829-3060` | **NICHT ins Register ueberfuehrt** |
| ALT-9 | **R1-R3 Post-v3** | 20.07. | `LEDGER:3241-3265` | R3/#35 im Register |
| ALT-10 | **Paragraf 62 #45-#51** (u.a. #47 COMPARE) | 21.07. | `LEDGER:3343`, `:3370` | #47 fehlt |
| ALT-11 | **RF-1..RF-8** | 26.07. | `LEDGER:3578-3582` | RF-1/2/6/7/8 im Register |
| ALT-12 | **Liegengeblieben-Sweep A14-A27 / B1-B13 / C1-C19 / D1-D8** | 05.08. | `docs/sessions/backups/20260805-liegengeblieben-sweep/synthese.md:10-165`; `LEDGER:4861-4862` | **B ja, A/C/D nein** |
| ALT-13 | **Owner-Vorlage A1-A9** | 05.08. | `docs/sessions/20260805-OWNER-VORLAGE-v5-entscheide-und-kenntnis.md:13-225`; Antworten `LEDGER:4812` | beantwortet |

## 2. NEU-MENGE

`docs/sessions/20260806-REGISTER-todo-konsolidierung-14-tage.md` (394 Z., P0/P1/P2/P3/P4 +
VOR-ABGABE + OWNER-FENSTER + PHASE-6 + NACH-ABGABE + ERLEDIGT + SUPERSEDED + 17 adversariale
Befunde B-1..B-17 + Nachtrag 10:45) . `docs/plaene/20260806-FAHRPLAN-parallel-sequenz-optimiert.md:1-20`
(DAG/Slots) . Task-Board (7 Tasks, Stand mittags) . die heutigen Wellen laut `LEDGER:4457-4700`.

---

## 3. DELTA-TABELLE (ALT minus NEU, je Posten am Objekt geprueft)

### 3.1 Status (a) ERLEDIGT-BELEGT -- kein Verlust, nur Vermerk fehlt

| Alt-Posten | Herkunft (Anker) | Beleg am Objekt |
|---|---|---|
| K-5 `best_binary_selector` ABI-Spiegel stale (kAbiMajor=5 vs Host-6, "schreibt falsche Provenienz", HOCH) | `LEDGER:3027` | `Code/external/comdare-cache-engine/libs/cache_engine/builder/best_binary_selector/best_binary_selector.hpp:57` = `kAbiMajor = 8` mit Historien-Kommentar + Paritaets-Test `test_best_binary_selector_parse_rank` (`.hpp:284`) |
| M-4 Code-Anteil (19->17-Nachzug super-Stufen 04/05/08, kSegmentCount 20->17) | `LEDGER:2926` | `Code/05_diagram_generator/diagram_generator.hpp:238` `kSegmentCount = kV3AxisCount + 1`, Zaehl-Literale entfernt (`:23`) |
| AP-10/#244/#269 "5 fehlende Datensatz-Akten" | `LEDGER:2976` | `Code/test_data_xml/` traegt alle 8: english_words, pizzachili_dna, protein, sosd_books_200M, tpcds-id, trec-terms, url, xml |
| #184 Dataset-Loader-Verdrahtung | `LEDGER:2976` | 23 `dataset_source`/`dataset_id`-Treffer; Konsumenten `libs/cache_engine/profile_facade/profile_runner.hpp`, `libs/common/measurement/dataset_loader/include/.../dataset_loader.hpp` |
| #19 Vendor-Allokatoren "echt linken" (jemalloc/tcmalloc/hoard/scalloc) | `LEDGER:2888` | `Code/external/comdare-cache-engine/CMakeLists.txt:56` Option + `:555` `ext/allocator/A05-jemalloc/src/jemalloc.c` |
| 7b-3 SIMD-Gruppen-Match als Primitive IN der isa-Achse | `LEDGER:2876` | `libs/cache_engine/axes/simd/axis_09_isa_amd64.hpp:58-59` (`_mm_cmpeq_epi8`/`_mm_movemask_epi8`). REST: Konsum in `art_trie_node_pool_store.hpp:14` noch bewusst skalar |
| Paragraf-38-Rest (3) `resource_group ceb-measurement-exclusive` am dynamischen `emit_measure_job` | `LEDGER:2879`, `:2914` | per-Host-Form gebaut: `libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:557/565/829/999` (`ceb-measure-<host>`, Paragraf-61-Fortschreibung) |
| RF-3 D1-Klasse `BetriebssystemFeatureFehlt` | `LEDGER:3580` | `libs/cache_engine/measurement/axis_error.hpp:50` + Vollzugs-Vermerk `LEDGER:3581` |
| RF-4 deprecated CI-Fallback-Matrizen archivieren | `LEDGER:3580` | Entscheid ARCHIV, Umsetzung an Infra-Handout delegiert (`.gitlab-ci.yml` = Infra-Gebiet) |
| A21 thesis-Klone 78 Commits hinter origin | `synthese.md:85-87` | `git -C thesis/diplomarbeit log -1` = `29a1700`; 4-Klone-Sync verbucht `LEDGER:4410` (led_late:1350) |
| S7-1..S7-10 Pool-Familien (Strang B) | `HANDOVER-...-20260705.md:38-40` | `LEDGER:622` Serien-Bilanz, alle 10 Familien echt |

### 3.2 Status (b) BEWUSST SUPERSEDED, Nachfolger benannt -- kein Verlust

| Alt-Posten | Herkunft | Nachfolger (Anker) |
|---|---|---|
| Lager-Gate G5 (P-B Pruning lokal->0) | `LEDGER:3481` | **O-3 Loesch-GO**, Register `:338` (Owner-A8, `LEDGER:4394`) |
| #215 CoW-320 / Vorstufe des Voll-Laufs | `TODO-BOARD:30` | **Voll-Bau-4 (P3)**, Register `:49`, Fahrplan `:15` |
| E1-E4-Dossier-Strang (8 Pakete) | `LEDGER:4674` | 6/8 ERLEDIGT/SUPERSEDED, Residuen -> P92 + honest-empty; Fahrplan `:18-19`, Register `:159` |
| Paragraf-66-N3 Mapping-Reinheit, Fable-5-Direktive Paragraf 67, Frist-Prognose 23.07. | `LEDGER:3469/3544` | Register `:168-172` |
| F27/#48 GOLDEN-XML-Kanonik (user-gated seit 16.07.) | `synthese.md:122` | **B14 GOLDEN-XML**, Register `:28` (F27-Eskalation namentlich) |
| Bauplan-IV.2.10 "out-of-scope" V36.B-Kanal | `LEDGER:3583-3586` | RETIRE+MERGE, im Register `:350` als Paragraf-75-Zeile |
| Straenge A/B/C-Organisation der Abteilungs-Uebergabe | `HANDOVER-...:26` | Selbst-Implementierung ab 10.07.; Inhalte einzeln in Paragraf 55 uebernommen |
| GN-9 6-TB-Rechnung | `LEDGER:2927` | **teil**-superseded: Owner-Klarstellung 23.07. (`LEDGER:3443`) -- "die 6-TB-Rechnung bezog sich auf Cluster-Storage, nicht auf lokale Platten". **Das Feasibility-GATE selbst (1-Zellen-Kalibrierungslauf VOR Voll-Matrix) hat KEINEN benannten Nachfolger** -> siehe 3.3/V-06 |

### 3.3 Status (c) STILL VERSCHWUNDEN = **VERGESSEN** (die Antwort auf die Owner-Frage)

Sortiert nach Schwere. "letzte Spur" = letzte Erwaehnung im Ledger (Volltext-Grep ueber
4872 Zeilen); "Register" = Volltext-Grep im heutigen Register.

| ID | Alt-Posten | Herkunft (Anker) | letzte Spur | Schwere | wo er hingehoert |
|---|---|---|---|---|---|
| **V-01** | **A15 Paragraf-55-Gesamt-Reconcile ueberfaellig** -- Meta-Posten, traegt den kompletten Vor-23.07.-Korpus (Coverage-#18, W12-B, Datensatz-Akten, Serialisierungs-4-Straenge, m3v2-Beleg, I-PMC-2/3, CI-2-Pass, measure-drop-XML-Default) | `LEDGER:4862`; Korpus `LEDGER:2829-3060` | 05.08. abend-4 | **HOCH (systemisch)** | VOR-ABGABE, als 1 Reconcile-Pass; Grossteil ist erledigt (3.1) -> billig |
| **V-02** | **A14 FF0-Owner Multi-Plattform-Generalitaet**, im Paragraf-55-Block als **"OFFEN, hoch -- Abgabe-Blocker"** gefuehrt; dazu Anhaenge-B/E-4-Zeilen-Stubs + Mess-Manifest/Provenance (G8-Abgabe-Blocker) | `LEDGER:2916`, `:2940`; Sweep `synthese.md:60-62` | 05.08. abend-4 | **HOCH** | VOR-ABGABE: Status "superseded?" zwingend klaeren (Fr 08.08.) |
| **V-03** | **M-4 Thesis-Text-Anteil**: "neunzehn Achsen"/T-Nummern DE+EN auf den Kanon nachziehen (Code = 18 Organ-Achsen T00-T17, `LEDGER:2846`/`:3083`) | `LEDGER:2926` ("OFFEN, hoch") | 20.07. (Code-Anteil erledigt, Text-Anteil nie) | **HOCH (Abgabe-Inhalt)** | VOR-ABGABE. Ist-Beleg: `thesis/.../de/04_concept_architecture.tex:210/224/236` ("neunzehn Achsen ... T0--T18"), `de/05_implementation.tex:38/74`, `de/01_introduction.tex:107`, `de/06_evaluation_methodology.tex:145` ("11 auf 19 Achsen"), `en/05_implementation.tex:36/70` ("nineteen axes") |
| **V-04** | **M-8 / M-9 / M-15 Auswertungs-Writer**: Achsen-Sensitivitaets-/Varianz-Attributions-Writer (HOCH) . 4 Heuristik-Kurven-Writer (sota_series/sweep_axis/seg_coverage/working_set_curve -> 08-Facade + **Anhang A DE+EN**) . Welch-Konsument als eigene WIDE-Auswertungsstufe | `LEDGER:2923`, `:2924`, `:2925` | 20.07. -- **0 Treffer nach 21.07.** | **HOCH** | P4/Auswertung. Das ist die Heuristik-Grundlage von Kap.5 + Anhang A und die Datenbasis der Hybrid-Spline-Wahl |
| **V-05** | **#162 (>=8 Rang-1-SOTA-Lebewesen, HELD) + PRT-ART-Stub-Quarantaene** (90ns-Konstante/unordered_map in 3 Alt-Pfaden) -- die FF-Gate-Kette AP-2 -> #162 -> #156/M3 | `LEDGER:2915`; Strang C `HANDOVER-...:41` | 20.07. -- **0 Treffer** ("SOTA-Lebewesen", "Stub-Quarant") nach 21.07. | **HOCH (Mess-Echtheit)** | VOR Messbeginn (P2/P3): entweder Vollzug oder ausdrueckliche Herabstufung -- sonst misst der Pruefling gegen Stubs |
| **V-06** | **GN-9 Bloat-/Kalibrierungs-Report als Feasibility-GATE** (1-Zellen-Lauf Range 0:64, t/TU + Bytes/DLL) **VOR** der Voll-Matrix | `LEDGER:2927` | 23.07. nur als Rechen-Klarstellung (`LEDGER:3443`), das Gate nie | **MITTEL-HOCH** | **P3, VOR dem Trigger** -- es ist per Definition ein Vor-Voll-Bau-Gate |
| **V-07** | **#47 COMPARE (4. Modus je Maschine, nach Release)** -- Owner-KERN Paragraf 62-C; in der Paragraf-63-Voll-Freigabe namentlich autonom freigegeben | `LEDGER:3343`, `:3370`; auch Abgabe-Blocker-Zeile `LEDGER:2940` | 21.07. | **MITTEL-HOCH** | Nach Release je Maschine -> P3/PHASE-6-nah; im Register **0 Treffer** |
| **V-08** | **#152 Cache-Misses als Kernmetrik = 0** + I-PMC-2 (L3/branch_misses) + I-PMC-3/#187 PMC-Auto-Adaption + #165 quiesced-OS-Provenienz | `LEDGER:2917`; Board `TODO-BOARD:11` | 20.07. | **MITTEL-HOCH** | Das Register fuehrt nur **E8 = die PMC-Beleg-FORM** (`:56`), nicht die **fehlende Metrik**. Gehoert vor die erste Messauswertung |
| **V-09** | **Nach-Abgabe-Band unvollstaendig uebernommen**: von der 11er-Kette der Sweep-Zeile C.1 fehlen im Register **Hybrid-Bau/Auswertungsphase**, **PL-19/PL-21 Gattungs-Docks je Genus**, **#47** | `synthese.md:113-114`; Paragraf 55 `:2952` (Hybrid = ex-"ABGABE-PFLICHT"), `:2940` (PL-19/21) | 05.08. | **MITTEL** | NACH-ABGABE. Ist-Beleg Hybrid: `libs/cache_engine/hybrid/` enthaelt **nur** `README.md` |
| **V-10** | **L21-Phase-6.5-Behaelter** (Owner H.7 "Rest nach Abgabe PFLICHT"): E-01/03/06/16/17/25/26, G5/Matrix-Zergliederung, Paragraf 73.1 + 73.5-Q6, Paragraf 70.4-RF-4/Q4, O-6/OD-1, #327, K5, Posten 43 | `synthese.md:118-120` | 05.08. | **MITTEL** | NACH-ABGABE. Register traegt nur K5, Posten 43, OD-1; "L21"/"E-01"/"O-6" = **0 Treffer** |
| **V-11** | **#327 PAT-Rotation** (exponierter Vault-PAT) -- im Paragraf-55-Block als "Security SOFORT, deadline-unabhaengig" | `LEDGER:2993`, `:3235` ("Status unklar") | 23.07. | **MITTEL (Security)** | Sofort/Infra-Lane, deadline-unabhaengig |
| **V-12** | **#274 / G5 measurement-all-Modul-Migration** (Strang E; G-Stack-G5; Paragraf-52-B15-GO unter 3 Auflagen, "ans Projektende geparkt") | `LEDGER:3007`, `:3050`; Strang E `HANDOVER-...:45` | 20.07. | **MITTEL** | NACH-ABGABE. **Achtung Namenskollision:** das Register-"G5" (`:53`/`:316`) ist das **Lager-Pruning**-G5, nicht dieses. Der Supersede-Vermerk deckt es NICHT ab |
| **V-13** | **C.3 `rescue/e24-c3-wip-pause` (Cross-Genus-WIP `0bac9fbe`)** -- Sweep-AUFLAGE: "Ref als Quelle im W3-Posten vermerken, **sonst Verlust**" | `synthese.md:116-117` | 05.08. | **MITTEL (akuter Datenverlust)** | Die W3-Zeile im Register (`:344`) nennt die Ref nicht. Beim naechsten Worktree-/Branch-Abbau ist die Vorarbeit weg |
| **V-14** | **A16 Posten-Register-Basis (2)-(18) + (25)-(29) fehlt in der Single-Source** (lebt nur in Session-Docs/Backups) | `synthese.md:67-69` | 05.08. | **MITTEL** | VOR-ABGABE (billig): ohne Rekonstruktion ist "Posten-Register abarbeiten" nach Abgabe nicht ausfuehrbar |
| **V-15** | **A17 ce-Doku-Nachzuege**: Stufen-Doktrin C1 = **aktenkundiger Widerspruch** `hybrid_tier_stufe_soll_design.md:286-288` "[[System],[Organ]]" gegen den organ-freien Mess+System-Stempel-Kanon; C3/K4 superseded ohne Vermerk | `synthese.md:70-74` | 05.08. | **MITTEL** | Naechstes ce-Fenster. Register traegt nur den Teil "Posten 46" (`:129`) |
| **V-16** | **A25-Kleinposten ohne Heimat (8 von 10)**: SubAxisMembership-Folge-Increment target_isa . A9-S2 (freigegeben 04.08., nie gebaut) . A10/E-3 MSVC-/Cross-Fenster . Posten-83-Generalisierung . fill_observer_v3-Umzug + 8/9 SA-Slots . P10-Folge-Sweep . `in_memory_measurement_buffer`-.gitkeep etikettieren . OS-U5-Doku-Vollzug A-08 | `synthese.md:96-101` | 05.08. | **KLEIN-MITTEL** | NACH-ABGABE/Aufraeumpass. Nur G-E3-Host-Binder (Register `:307`) und W-11 Cache-Key (`:344`) haben es aus dieser Liste geschafft |
| **V-17** | **A19 planer_block-Reaper-Folgewelle** (Bedingung "Zweit-Planer-Konsument real" ist durch W1-Split erfuellt; STRITTIG mess-relevant: verfallene Reservierungen ohne Reaper koennten Messlaeufe beruehren) | `synthese.md:79-81`; `LEDGER:3630/:3790` | 05.08. | **KLEIN-MITTEL** | Vor Messbeginn kurz bewerten, sonst NACH-ABGABE |
| **V-18** | **A20 L12 Codex-Zweitlens Z-02/Z-03** ("am dringendsten", Bedingung Codex-Umgebung seit 05.08. erfuellt, nie gequeued) . **A23 E-20 I112-Runner-Fleet-Handout-Push** unbelegt . **A24 Aufraeumpass-Kandidat B-1** (referenzlose `using SearchAlgo`-Aliase `abi_adapter.hpp:440/:545`) fehlt in der 9er-Kandidatenliste (Verstoss gegen Owner-KERN "Kandidaten-Liste fortschreiben") | `synthese.md:82-84`, `:91-92`, `:93-95` | 05.08. | **KLEIN** | A24 -> Aufraeumpass-Liste (Register `:380`) sofort ergaenzen; A20/A23 NACH-ABGABE |
| **V-19** | **D5/D6/D7 STRITTIG-Vermerke** (Posten 30 test_s5-Tempdir . W12-B Cache-Key-Spiegelung . Goldener Coverage-Test #18) -- A15 sollte sie "gleich mit" schliessen | `synthese.md:148-150`; `LEDGER:2919` (#18) | 05.08. | **KLEIN** | VOR-ABGABE, reine Vermerke |
| **V-20** | **Paragraf-55-Restposten ohne Nachfolger** (Sammelzeile, alle NACH-ABGABE): F12iii Telemetrie-aus-binary_id (ABI-Major) `:2873` . F2 native Set-ABI `:2871` . **OF-1 Beschleuniger-Array GPU/FPGA/NPU** (= laut Memory die 6. Systemachse/Q2) + Paragraf 37.2/3 Cross-Compile `:2891` . 3 vertagte Kern-Library-Punkte (OptO*SubAxis-Namensfalle) `:2875` . Paragraf-26-L5 INC-0-Rest build-i2 `:2887` . K-17 snmalloc-"failed"-Zelle `:2889` . **S-7 Deep-Research Locking (OptiQL/ARTSynchronized)** `:2897` + genuin offener Owner-Entscheid `:3050` . #179 Wartbarkeits-Sweep XL `:2893` . #185 io-tpie/EM-BFS `TODO-BOARD:18` . #225 Second-Execution `:3053` . #226 Appendix-Limitierungen `:2946` . #276 3-ISA "allerletzte Aufgabe" `:3006` . #270a P/E-Core, #270b arm64 `:2990/:2999` . #204 sanitize-hart+TSan `:3000` . avx512-Anschluss-Increment `:2996` . #266 config-Owner-Gate `:3004` . #254 OneDrive `:3008` . Paragraf-38-Rest (2) `ExperimentSubtreePayload` real emit/parse ODER deprecaten (Ist: nur `experiment_dock_payload.hpp` + `test_experiment_dock_payload.cpp`, kein Producer) `:2879` . PhasenCheck-5.16-Rest `synthese.md:124` . Datensatz-Katalog 6-vs-48 user-gated `synthese.md:131` | `LEDGER:2829-3060` | 20.07. | **KLEIN (je Einzelposten), MITTEL in Summe** | NACH-ABGABE, als EINE Sammelzeile in das Register mit Verweis auf `LEDGER:2829-3060` |

### 3.4 Status (d) UMBENANNT/AUFGEGANGEN -- Inhalt geprueft, nicht nur der Titel

| Alt-Posten | aufgegangen in | Inhalts-Pruefung |
|---|---|---|
| Paragraf-47-Mess-Tooling-HAUPT-Auffaecherung / "ZWEI getrennte Achsen-Regularien" (`LEDGER:2907`, `:2912`) | **F6** (offene Owner-Frage: "Verwirft 'Micro/Macro FALSCH' auch die Paragraf-47-Mess-Tooling-CT-Achse selbst?") | Inhalt getroffen, aber als **Frage**, nicht als Bau-Posten. F6 ist heute noch offen -- der Bau-Rest darunter hat keine Zeile |
| Fehler-Sichtbarkeit "failed statt null" (`LEDGER:2913`) | **honest-empty** + honest-0-Musterfortsetzung (Register `:380` Kandidat 8) | Inhalt sinngemaess uebernommen (echt-0 vs. nie-ausgefuehrt), Doktrin-Titel jedoch nicht mehr genannt |
| GN-10 Fixture-Single-Source `experiment_golden.xml` (`LEDGER:2886`) | **F3 / Scheibe-6 Weg a** (`docs/plaene/20260806-PLAN-scheibe6-weg-a-fixture-entflechtung.md`) | vollstaendig, Owner-entschieden |
| Voll-per-Host-Messlauf #156/#215/#216 (`LEDGER:2903`) | **Voll-Bau-4 + Phase 6 USER-GO-STOPP** (Register `:49-50`) | Bau-Seite vollstaendig; die **Mess-Qualitaets-Auflagen** der Alt-Zeile (Re-Build ALLER DLLs, Alt-Pilot-CSVs nie mischen, m3v2-Einheitlichkeits-Beleg `:2922`) sind **nicht** mitgezogen -> Teilverlust, siehe V-08-Umfeld |
| B12 (`LEDGER:2905` = N-Paar-Wahl first-2 vs. Max-Kontrast, offener Owner-Entscheid nach Abgabe) | **B12 im Register = xlsx-Lager-Fuellung** (`:69`) | **reine Namenskollision, KEIN Inhaltstransfer.** Der alte B12/F-SPREAD-Entscheid ist ohne Zeile (in V-20 subsumiert) |
| G5 (Register `:53`) | Lager-Pruning | **Namenskollision** zu G5=#274 (V-12) |
| A14 (Register `:71` = OS-U4/A14-Rest) | OS-U4 | **Namenskollision** zu A14=FF0 (V-02) |

---

## 4. PRIORISIERTE VERGESSEN-LISTE (die Antwort auf die Owner-Frage)

**BLOCKIERT TRIGGER (Do 07.08.) -- 2 Posten**

1. **V-06 GN-9 Feasibility-/Kalibrierungs-Gate** -- per Definition VOR der Voll-Matrix; heute
   kein Slot im Fahrplan-DAG. Entweder 1-Zellen-Kalibrierungslauf einschieben oder ausdruecklich
   herabstufen (Shortcut=Regression+TODO).
2. **V-05 PRT-ART-Stub-Quarantaene / #162** -- betrifft die Echtheit dessen, was gemessen wird.
   Muss vor Messbeginn Vollzug ODER deklarierte Herabstufung haben.

**BLOCKIERT ABGABE (Fr 08.08.) -- 4 Posten**

3. **V-03 Thesis-Text "neunzehn Achsen"/T0-T18 (DE+EN)** gegen den Kanon 18 Organ-Achsen
   T00-T17 -- steht in 7 belegten Textstellen im Abgabe-Dokument. Der billigste und
   sichtbarste Fund dieser Pruefung.
4. **V-02 A14 FF0 Multi-Plattform-Generalitaet** (im Alt-Block ausdruecklich "Abgabe-Blocker")
   + Anhaenge-B/E-Stubs + Mess-Manifest/Provenance -- mindestens Status-Klaerung
   ("superseded?") mit Vermerk.
5. **V-01 A15 Paragraf-55-Gesamt-Reconcile** -- EIN Pass, der die 20 Positionen dieses Deltas
   ins Register hebt. Er ist selbst der Grund, warum die anderen fehlen.
6. **V-08 #152 Cache-Misses (Kernmetrik) + I-PMC-2/3** -- sonst wird mit einer als Kernmetrik
   deklarierten Groesse = 0 ausgewertet.

**SOFORT, deadline-unabhaengig -- 2 Posten**

7. **V-11 #327 PAT-Rotation** (Security, exponierter Vault-PAT, "Status unklar" seit 23.07.).
8. **V-13 `rescue/e24-c3-wip-pause` (`0bac9fbe`)** -- Ref jetzt im W3-Posten vermerken, sonst
   geht die Cross-Genus-Vorarbeit beim naechsten Aufraeumen verloren.

**NACH DER ABGABE -- 12 Posten**

9. V-04 M-8/M-9/M-15 Auswertungs-Writer (aber: **Anhang A DE+EN** haengt daran -- wenn Anhang A
   in der Abgabe erscheinen soll, rutscht V-04 in die Abgabe-Klasse; Owner-Entscheid noetig).
10. V-07 #47 COMPARE-Modus. 11. V-09 Hybrid-Bau/Auswertungsphase + PL-19/PL-21.
12. V-10 L21-Phase-6.5-Behaelter. 13. V-12 #274/G5 Modul-Migration.
14. V-14 A16 Posten-Register-Rekonstruktion. 15. V-15 A17 Stufen-Doktrin-C1-Widerspruch.
16. V-16 A25-Kleinposten (8). 17. V-17 A19 planer_block-Reaper.
18. V-18 A20/A23/A24. 19. V-19 D5/D6/D7-Vermerke. 20. V-20 Paragraf-55-Sammelzeile.

---

## 5. WIE VIEL IST WIRKLICH VERLOREN GEGANGEN?

**Quantitativ:** Aus dem Paragraf-55-Block (ca. 140 offene Zeilen, 20.07.) plus Sweep-A-Liste
(14 Posten) plus C-/D-Listen (27 Posten) sind **20 Positionen ohne Vollzugs- oder
Supersede-Beleg** uebrig. Fuer 11 weitere ist der Vollzug am Objekt belegbar (3.1), fuer 8 ist
ein benannter Nachfolger da (3.2), 7 sind inhaltlich aufgegangen (3.4).

**Qualitativ:** Die Substanz der letzten zwei Wochen ist **nicht** verloren -- das
14-Tage-Fenster hat alles Aktive sauber getragen, und die adversariale Direktiven-Pruefung
im Register (B-1..B-17) hat sogar Fehl-Einordnungen korrigiert. Verloren ist die **Bruecke in
die Vor-Zeit**: der Moment, in dem eine Konsolidierung ihr eigenes Fenster als Grenze setzt,
ohne den vorherigen Voll-Block als Eingang mitzunehmen. Genau davor hatte der eigene
Liegengeblieben-Sweep am 05.08. gewarnt (A15) -- und genau diese Warnzeile fiel als einzige
Zeile ihres Absatzes aus der Uebertragung.

**Zwei Mechanik-Befunde, die das Wiederauftreten beguenstigen und deshalb hier festgehalten
gehoeren:**

- **Namenskollisionen loeschen Inhalt still.** Drei Faelle in diesem Delta: G5 (Lager-Pruning
  vs. #274-Modul-Migration), A14 (OS-U4-Rest vs. FF0-Abgabe-Blocker), B12 (xlsx-Fuellung vs.
  N-Paar-Wahl F-SPREAD). In allen drei Faellen sieht ein Grep "Posten ist im Register" -- der
  Inhalt ist es nicht. Das Register benennt Kollisionen bereits selbst (`:186`), aber nur die
  bekannten.
- **Geparkte Posten mit Beleg (Sweep-Kategorie C, 19 Stueck) sind die zweite Verlustklasse.**
  "Geparkt-OK" bedeutet in der Uebertragung faktisch "braucht keine Zeile" -- deshalb fehlen
  C.1-Reste (V-09), C.3 (V-13), C.7/C.14/C.16 (V-20). Owner-Doktrin ist aber: nichts wird
  ersatzlos gestrichen, auch Geparktes braucht eine Zeile mit Wiedervorlage-Anker.

**Empfehlung in einem Satz:** Ein einziger, billiger VOR-ABGABE-Pass (V-01) mit den vier
Abgabe-Posten (V-02, V-03, V-08) und den zwei Sofort-Posten (V-11, V-13) heilt den gesamten
Befund; alles Uebrige gehoert als **eine** additive NACH-ABGABE-Sammelzeile mit Anker
`LEDGER:2829-3060` und `synthese.md:58-136` ins Register.

---

## 6. KONSOLIDIERUNGS-VOLLZUG (V-01/A15)

> OWNER-AUFTRAG verbatim (06.08.): "Bitte konsolidiere die gefundene fehlende Arbeit, sofern sie
> den neuen Plaenen und Aussagen nicht wiederspricht, die neuesten Aussagen gewinnen. Die Planung
> wurde schliesslich mehrfach erweitert und geaendert."
>
> Regel angewandt: NEUESTE gewinnt -- aber "neueste gewinnt" heisst NICHT "alt = ungueltig".
> Wo nichts Neueres widerspricht, bleibt der Posten GUELTIG und wird uebernommen (Regelfall:
> 10 von 20). Quellen-Rangfolge: (a) Owner-Aussagen/Entscheide 05.-06.08. im Ledger,
> (b) docs/plaene/*.md 06.08., (c) Register 20260806-REGISTER-todo-konsolidierung-14-tage.md,
> (d) das Objekt (Code/Tests/CI/Thesis-Repo).
>
> Ziel-Doc der Uebernahmen: `docs/sessions/20260806-REGISTER-todo-konsolidierung-14-tage.md`,
> Abschnitt "NACHTRAG V-01/A15". Ab dort hat jeder uebernommene Posten einen BESITZER.

**BILANZ: 10 UEBERNOMMEN (i) . 4 SUPERSEDED (ii) . 5 BEREITS ERLEDIGT (iii) . 1 OWNER-ENTSCHEID (iv).**

### 6.1 Entscheidungs-Tabelle aller 20 Positionen

| Position | Entscheid | Begruendung + Anker | Ziel-Klasse bzw. Nachfolger |
|---|---|---|---|
| **V-01** A15 Paragraf-55-Reconcile | **(iii) BEREITS ERLEDIGT** | Vollzogen mit genau diesem Pass: 20 Positionen einzeln gegen den heutigen Stand geprueft, Uebernahmen in die Klassen-Tabellen des Registers geschrieben. Anmahnung `LEDGER:4862`/`:4900`; Delta-Verbuchung `LEDGER:4224-4232`. | ERLEDIGT-Register (Register-Nachtrag, ERLEDIGT-Tabelle) |
| **V-02** A14 FF0 + Anhaenge-B/E + Mess-Manifest | **(ii) SUPERSEDED (2 Teile) + (i) UEBERNEHMEN (1 Rest)** | FF0: `kapitel/de/06_fazit.tex:22-33` (EN-Paritaet) beantwortet FF0 explizit multi-plattform ("erst nach den End-to-End-Laeufen je Plattform beziffern"; "auf Hybrid-CPUs und Sapphire-Rapids gegenuebergestellt") -- die Abgabe-Blocker-Lage von `LEDGER:2916` besteht nicht mehr, offen ist nur die Bezifferung. Anhaenge-B/E: keine 4-Zeilen-Stubs mehr (B 257 Z. / E 151 Z. DE, 256/153 EN; Anhaenge-Realm-Welle gelandet 29a1700, `LEDGER:3748`). | FF0 -> P3 Trigger/Voll-Bau-4 + Phase 6 USER-GO-STOPP . Anhaenge -> ERLEDIGT . **Rest Mess-Manifest/Provenance -> VOR-ABGABE** (an E8/Trigger-Checkliste) |
| **V-03** Thesis-Text "neunzehn Achsen" DE+EN | **(iii) BEREITS ERLEDIGT (Abgabe-Dokument) + (i) Rest-Auflage** | `diplomarbeit.tex:280-295` included NUR die 6 Habich-Kapitel + Anhaenge A-F. In JEDER included Datei ist "neunzehn"/"nineteen"/"T0--T18" ausdruecklich als historische Vorstufe markiert ("Zwischenstand Juli 2026"), DE+EN paritaetisch; der Kanon 18/T0--T17 steht literal (`04_implementierung.tex:173`, `06_fazit.tex:35-37`). **Die 7 im Delta zitierten Stellen liegen ALLE in un-included Alt-Kapiteln** (`diplomarbeit.tex:278-279`: "bleiben als Inhalts-Quelle auf der Platte (un-included)"). Damit war die Abgabe-Blocker-Einstufung in Abschn. 3.3/4 ein FALSCH-POSITIV -- hiermit korrigiert. | ERLEDIGT . **Rest: stehende Stufe-3-Umzugs-Auflage -> NACH-ABGABE** |
| **V-04** M-8/M-9/M-15 Auswertungs-Writer | **(iv) OWNER-ENTSCHEID NOETIG** | Neueste Aussagen decken den Posten weder noch loesen sie ihn ab. Kern: Anhang A DE+EN haengt an M-9 (`LEDGER:2924`). Ist-Stand: `anhang/de/A_measurements.tex` ist gefuellt (137 Z.) und kompiliert -- mit den ALT-Messreihen. Frage: sollen Sensitivitaets-/Kurven-/Welch-Writer noch in die Abgabe (dann rutscht V-04 in die Abgabe-Klasse) oder bleibt Anhang A wie er ist? | **OWNER-FENSTER O-4 "Anhang-A-Reichweite"** (Default-Vorschlag: NACH-ABGABE) |
| **V-05** #162 + PRT-ART-Stub-Quarantaene | **(iii) BEREITS ERLEDIGT (Quarantaene) + (i) UEBERNEHMEN (#162)** | Quarantaene VOLLZOGEN am Objekt: Kopf "ALT-PFAD -- NICHT Teil des Mess-Pfads! ... traegt bewusst Stub-/Surrogat-Code -- sie darf NIE in den Mess-Pfad verdrahtet werden" in `comdare-prt-art/.../identity/prt_art_pruefling_factory.hpp:2-6` UND `prt_art_execution_engine_adapter.hpp:6` (AP-2-neu/#236 W4, 07.07.), ce-Gegenbeweis `tests/unit/thesis_tiere/test_ap2_katalog_pfad_stubfrei.cpp`. Die Mess-Echtheits-Gefahr aus Abschn. 4 Punkt 2 besteht damit NICHT. Offen bleibt nur der Zaehl-/Vollzugsbeleg der >=8 Rang-1-SOTA-Lebewesen. | Quarantaene -> ERLEDIGT . **#162 -> P2/P3 vor Messauswertung** (HELD; Vollzug oder deklarierte Herabstufung) |
| **V-06** GN-9 Feasibility-/Kalibrierungs-Gate | **(ii) SUPERSEDED + (i) Rest** | (a) Gate-Begruendung entfaellt: Owner 23.07. "die 6-TB-Rechnung bezog sich auf Cluster-Storage, nicht auf lokale Platten" (`LEDGER:3443`). (b) Messfunktion in die Bestandslog-Maschinerie gewandert: Mini-Batch-ETA statt Vorlauf-Schaetzung (`LEDGER:3325`, `builder/bestandslog/eta_estimator.hpp`) + avg_size als 2. Log-Wert je Batch-Block (`LEDGER:3429`). (c) Platz-Schutz = P3-Zeile Forecast/df-Wache (Register `:54`/`:315`). | Nachfolger: **ETA/avg_size-Bestandslog + Forecast-Platzpflege** . **Rest: "ETA-Erst-Batch-Abnahme" -> P3-Trigger-Checkliste** |
| **V-07** #47 COMPARE (4. Modus je Maschine) | **(i) UEBERNEHMEN** | Nichts Neueres widerspricht. Owner-KERN Paragraf 62-C ist unveraendert gueltig: COMPARE laeuft "erst zum Schluss, NACH dem Release ... je Maschine" aus dem Mess-Replay; `run_methodology` erhaelt den 4. Wert `compare` (`LEDGER:3343`), autonom freigegeben (`LEDGER:3370`). Im Register 0 Treffer. | **NACH-ABGABE**, einzuhaengen in die bindende Kette (Register `:344`) |
| **V-08** #152 Cache-Misses + I-PMC-2/3 + #165 | **(iii) BEREITS ERLEDIGT (Kern) + (i) 2 Reste** | Am Objekt gebaut: `measurement_snapshot.hpp:44-46` (l1/l2/l3), `:77` branch_misses, `:162/:194` CSV-Header; `linux_perf_pmc_source.hpp:191-194` (L1+LL real, L2 ehrlich 0 "kein RAW-Rateversuch"); `windows_pcm_pmc_source.hpp:54-55`; `cache_engine_builder_iterator.hpp:475-480/:750-753` (branch_misses emittiert); `#165-B annotate_quality_flags` (`profile_run_entry.hpp:605-609`, `experiment_run_entry.hpp:244`); PMC-Preflight #37 (Register `:149`). Die Befuerchtung "Kernmetrik = 0" ist am Code widerlegt. | ERLEDIGT . **Rest 1: Anhang-A-Limitierung-1 nach der Messung nachziehen -> VOR-ABGABE** (`anhang/de/A_measurements.tex:11`, EN `:10`) . **Rest 2: I-PMC-3 Zen-5-RAW + system_disturbed-Provenienz -> NACH-ABGABE** (ausdruecklich GETRENNT deklariert, `cache_engine_builder_iterator.hpp:334`) |
| **V-09** Hybrid-Bau + PL-19/PL-21 | **(ii) SUPERSEDED (Etikette) + (i) UEBERNEHMEN (Bau)** | Die Etikette "ABGABE-PFLICHT vor 28.07." (`LEDGER:2952`) ist doppelt abgeloest: Frist neu (Abgabe 08.08.) UND Verortung geaendert -- Hybrid-Tier = eigene Stufe HINTER der CEB (`LEDGER:3529`, Owner-E1) mit "Bau in der Auswertungsphase" (`LEDGER:3602`). Der Bau-Posten selbst hat keinen Nachfolger und bleibt. Ist-Beleg heute verifiziert: `libs/cache_engine/hybrid/` enthaelt NUR `README.md`. | **NACH-ABGABE** (Auswertungsphase); PL-19/PL-21 Gattungs-Docks in derselben Zeile |
| **V-10** L21-Phase-6.5-Behaelter | **(i) UEBERNEHMEN** | Owner H.7 "Rest nach Abgabe PFLICHT" ist unwidersprochen; das Register traegt nur K5, Posten 43, OD-1 einzeln, "L21"/"E-01"/"O-6" = 0 Treffer (`synthese.md:118-120`). | **NACH-ABGABE** (Behaelter-Zeile) |
| **V-11** #327 PAT-Rotation | **(ii) SUPERSEDED (Termin) -- Posten bleibt** | Owner terminiert: "#327 NUR-KENNTNIS (Rotation nach Messfenster, Handout liegt)" (`LEDGER:3727`). Das "Security SOFORT, deadline-unabhaengig" des Alt-Blocks (`LEDGER:2993`) ist damit abgeloest. Nicht gestrichen -- sonst faellt die Rotation nach dem Messfenster erneut aus. | **OWNER-FENSTER**, Termin "nach Messfenster", Infra-Lane (Cluster read-only fuer diese Linie) |
| **V-12** #274/G5 measurement-all-Modul-Migration | **(i) UEBERNEHMEN** | Nichts Neueres widerspricht; GO unter 3 Auflagen steht (`LEDGER:3007`/`:3050`), "ans Projektende geparkt". Der Register-Supersede von G5 betrifft das **Lager-Pruning**-G5 (Register `:53`/`:316` -> O-3) und deckt diesen Posten NICHT ab -- Namenskollision explizit verbucht. | **NACH-ABGABE** (Projektende), mit Kollisions-Vermerk |
| **V-13** rescue/e24-c3-wip-pause (0bac9fbe) | **(iii) BEREITS ERLEDIGT** | Heute am Objekt verifiziert: `refs/rescue/e24-c3-wip-pause = 0bac9fbe83e5c5ae2cabd970cea0b6dd8c0dffe5` auf **beiden** Remotes (origin gitlab.comdare.local UND github). Der Namespace `refs/rescue/*` liegt ausserhalb `refs/heads/*` -> Branch-/Worktree-Abbau kann ihn nicht treffen. Der Sweep-Auflagen-Vermerk ist hiermit erfolgt. | ERLEDIGT-Register; Quellen-Vermerk am W3-Posten (Register `:344`) |
| **V-14** A16 Posten-Register-Basis (2)-(18)/(25)-(29) | **(i) UEBERNEHMEN** | Unwidersprochen und billig; ohne Rekonstruktion ist die bindende Nach-Abgabe-Kette "... -> Posten-Register" (Register `:344`) nicht ausfuehrbar (`synthese.md:67-69`). | **VOR-ABGABE** (billig) |
| **V-15** A17 ce-Doku-Nachzuege / Stufen-Doktrin C1 | **(i) UEBERNEHMEN (Doku-Rest)** | Der Sach-Konflikt ist inzwischen entschieden (3 Realm-Zeilen + Fingerprint-Zeile, vierte Stempel-Zeile abgeschafft -- thesis 00876ea; Owner-KERN Stempel-Regression). OFFEN bleibt der DOKU-Nachzug in `hybrid_tier_stufe_soll_design.md:286-288` ("[[System],[Organ]]") sowie C3/K4-Supersede-Vermerke. Register traegt nur "Posten 46" (`:129`). | **NACH-ABGABE** (naechstes ce-Doku-Fenster) |
| **V-16** A25-Kleinposten (8 ohne Heimat) | **(i) UEBERNEHMEN** | Unwidersprochen; nur G-E3-Host-Binder (Register `:307`) und W-11 Cache-Key (`:344`) sind aus dieser Liste angekommen (`synthese.md:96-101`). Anmerkung: "A9-S2" ist gegen den Register-Vermerk "A8-S2 nie vergeben" (`:171`) zu triangulieren -- andere Nummer, kein Supersede. | **NACH-ABGABE / Aufraeumpass** |
| **V-17** A19 planer_block-Reaper | **(i) UEBERNEHMEN** | Bedingung "Zweit-Planer-Konsument real" durch W1-Split erfuellt; als deklarierte Luecke verbucht (`LEDGER:3790`) mit Folge-Beobachtung (`LEDGER:3630`). Mess-Relevanz strittig -> vor Messbeginn kurz bewerten. | **P2** (Bewertung vor Messbeginn), sonst NACH-ABGABE |
| **V-18** A20 Z-02/Z-03 . A23 . A24 | **(ii) SUPERSEDED (A20) + (i) UEBERNEHMEN (A23/A24)** | A20: Wegwahl entschieden ("Z-02-Wegwahl NUR-KENNTNIS, Weg (i) F6-Grammatik als M3a", `LEDGER:3727`; Z-03 = M3a-Commit C2, `LEDGER:3686`), und der Sonderwunsch "zweite Lens am dringendsten" (`LEDGER:3698`) ist seit mittag-18 stehende DUAL-REVIEW-PFLICHT vor JEDER Landung -> im Regelbetrieb aufgegangen. A23/A24 unwidersprochen offen. | A20 -> SUPERSEDED (Dual-Review-Regelbetrieb) . **A24 -> Aufraeumpass-Kandidat Nr. 10 (sofort)** . A23 -> NACH-ABGABE/Infra |
| **V-19** D5/D6/D7 STRITTIG-Vermerke | **(i) UEBERNEHMEN** | Unwidersprochen, reine Vermerke (Posten-30-Tempdir, W12-B Cache-Key-Spiegelung, #18 Goldener Coverage-Test; `synthese.md:148-150`, `LEDGER:2919`, `LEDGER:2972`). | **VOR-ABGABE** (billig) |
| **V-20** Paragraf-55-Restposten (Sammelzeile) | **(i) UEBERNEHMEN** | Kein Einzelposten hat einen Nachfolger; keiner widerspricht neueren Aussagen. Owner-Doktrin verbietet ersatzloses Streichen -> EINE Sammelzeile mit Anker `LEDGER:2829-3060` + `synthese.md:58-136`, Einzelposten namentlich aufgefuehrt (inkl. B12-alt/F-SPREAD, das sonst in der Namenskollision verschwindet). | **NACH-ABGABE** (Sammelzeile) |

### 6.2 Korrektur an Abschnitt 3/4 dieses Dokuments (Selbstcheck aus dem Objekt)

Drei Einstufungen dieses Delta-Berichts haben der Objekt-Pruefung **nicht** standgehalten und
werden hiermit richtiggestellt -- sie bleiben oben als Historie stehen (Doku nie loeschen):

1. **V-03 war KEIN Abgabe-Blocker.** Die 7 zitierten Textstellen liegen samtlich in
   un-included Alt-Kapiteln (`diplomarbeit.tex:278-279`). Der Fund war ein reiner Grep-Treffer
   ohne Build-Pruefung. Damit entfaellt Punkt 3 der Liste in Abschnitt 4.
2. **V-05 war KEIN Mess-Echtheits-Risiko.** Die Stub-Quarantaene ist seit 07.07. am Objekt
   vollzogen und per ce-Test bewiesen; nur der #162-Zaehlbeleg ist offen. Punkt 2 in Abschnitt 4
   ist entsprechend zu entschaerfen.
3. **V-08 misst NICHT gegen 0.** Cache-Misses L1/L3, branch_misses und quality_flag sind real
   erhoben und emittiert; L2 steht ehrlich auf 0 mit ausdruecklichem Verzicht auf einen
   RAW-Rateversuch. Punkt 6 in Abschnitt 4 reduziert sich auf zwei Reste (Anhang-A-Limitierung,
   Zen-5-RAW/system_disturbed).

**Verbleibende trigger-/abgaberelevante Substanz nach dem Vollzug:** V-02-Rest
(Mess-Manifest/Provenance), V-05-Rest (#162), V-06-Rest (ETA-Erst-Batch-Abnahme), V-08-Rest
(Anhang-A-Limitierung nach der Messung), V-14 und V-19 (beide billig) -- plus der eine
Owner-Entscheid O-4 (Anhang-A-Reichweite / V-04).

### 6.3 Naechste-Schritt-Zeilen fuer die 6+1 kritischen Posten

| # | Posten | WAS genau | WO | WER entscheidet |
|---|---|---|---|---|
| 1 | **V-01 / A15** | ERLEDIGT mit diesem Pass -- verbleibende Handlung: der Lead committet Register-Nachtrag + diesen Abschnitt und setzt eine Ledger-Nachtrag-Zeile "A15 VOLLZOGEN, 10/4/5/1". | super `docs/sessions/20260806-REGISTER-...md` + `...DELTA-...md` + Ledger | Lead (kein Owner-Entscheid) |
| 2 | **V-02-Rest** | Die Zeile "Mess-Manifest/Provenance" in die **P3-Trigger-Checkliste** aufnehmen und mit der bestehenden E8-Zeile zusammenfuehren: Voll-Bau-4 darf nur mit aktivem Provenienz-Log + geklaerter PMC-Beleg-Form starten. FF0-Anteil NICHT nachbauen (superseded). | Register P3-Zeile "Trigger + Voll-Bau-4" (`:313`) + "E8" (`:56`) | Lead setzt, Owner nur bei Herabstufung |
| 3 | **V-03** | KEINE Aenderung im Thesis-Repo. Stattdessen einen Deprecation-Kopf-Vermerk fuer die 8 un-included Alt-Kapitel je Sprache als **NACH-ABGABE**-Zeile fuehren + die Stufe-3-Umzugs-Auflage (bei jedem Abschnitts-Umzug 19 -> 18/T0--T17 mitziehen). Anderes Repo, eigene Welle. | `/home/comdare/Projekte/Research/20260931-overleaf-diplomarbeit` (spaeter); Zeile heute nur im Register | Lead; kein Abgabe-Risiko mehr |
| 4 | **V-05-Rest** | Vor der ersten Messauswertung: den Katalog-Pfad auf **>=8 Rang-1-SOTA-Lebewesen** zaehlen (sota_catalog) und das Ergebnis literal ins Ledger schreiben. Bei <8: ausdrueckliche Herabstufung als Shortcut=Regression+TODO, nicht stillschweigend. | ce `libs/cache_engine/profile_facade/` (sota_catalog); Ausgabe ins Ledger | Lead zaehlt, **Owner entscheidet ueber Herabstufung** |
| 6 | **V-06-Rest** | In die P3-Trigger-Checkliste: **"ETA-Erst-Batch-Abnahme"** -- nach dem ERSTEN Mini-Batch des Voll-Bau-4 werden t/TU und avg_size (Bytes/DLL) aus dem Bestandslog gegen den freien Plattenplatz beider Maschinen gerechnet, BEVOR die Matrix weiterlaeuft. Kein separater 1-Zellen-Vorlauf (superseded). | Register P3 "Trigger + Voll-Bau-4" (`:313`); Traeger `builder/bestandslog/eta_estimator.hpp` | Lead; Owner nur bei Abbruch/Herabstufung |
| 7 | **V-08-Rest** | Nach dem Messlauf: `anhang/de/A_measurements.tex:11-12` und `anhang/en/A_measurements.tex:10-11` ("Cache-Misses L1--L3 derzeit 0/nicht erhoben, vgl. Limitierung 1") DE+EN gegen die neuen PMC-Werte nachziehen -- sonst steht eine widerlegte Limitierung in der Abgabe. L2 bleibt ehrlich 0 (kein RAW-Rateversuch) und ist als solche zu formulieren. | Thesis-Repo `anhang/{de,en}/A_measurements.tex` | Lead nach Vorliegen der Messdaten |
| +1 | **V-11 #327 PAT-Rotation (SECURITY)** | Nicht mehr "sofort": Owner hat auf **nach dem Messfenster** terminiert (`LEDGER:3727`, Handout liegt). Handlung jetzt: Zeile im OWNER-FENSTER mit Termin fuehren + im Handout die Rotations-Schritte (Vault-Kandidaten RUECKWAERTS gegen `/api/v4/user` bis HTTP 200, Position rotiert -- nie hartcodieren) festhalten. Ausfuehrung durch die Infra-Lane; Cluster fuer diese Linie read-only. | Register OWNER-FENSTER; Infra-Handout | **Owner gibt das Rotations-Fenster frei** (nach Messfenster) |

*(Position 5 des urspruenglichen Prioritaeten-Fadens -- V-13 rescue-Ref -- ist erledigt: Ref auf
beiden Remotes verifiziert, Vermerk erfolgt. Deshalb springt die Nummerierung.)*
