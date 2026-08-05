# LEDGER-LENS: Liegengebliebene Aufgaben (READ-ONLY-Durchforstung, 05.08.2026)

Quelle: `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (4188 Zeilen, Stand ce 60c7c56a / super 603f15f4).
Methode: (1) Voll-Lektuere der NACHTRAG-Region 3599-4188 + §66-§77 + §0-GOAL-V7 (Z.82-127) + §55-Gesamtblock (Z.2829-3063); (2) grep-Sweeps ueber alle Offen-Marker, Posten-Nummern (1)-(92), D-Deltas, E-01..E-26, Phasen/P11/J/L-Referenzen; (3) Abgleich gegen den IST-ANKER (alles dort als laufend/erledigt/geplant Gefuehrte ist NICHT als Fund gelistet).

IST-ANKER-Deckung (NICHT Funde): A8-S5 komplett inkl. Phase B, ANKER GATE 5 (Job-Sperre beendet), W1 Planer-Split + W2-Minimalhaerte, Dual-Review-Welle (w2-codex-fixes + w5-w3-kern), Sonnet-5-Audit, A2-Fix-Welle F1/F3/F4/F5 (queued), OWNER-GATE O-2, Phasen 3-5 -> Trigger Do 07.08. -> Phase 6 USER-GO, Nach-Abgabe-Band (R3-Rest, #35-.so, #54-Endform, W3-Vollausbau, W2-Codegen-Zielform, K1-K4, Posten-Register-Abarbeitung, Hybrid-Bau, Tools-Lager #32, PL-21, COMPARE #47).

---

## A. VOR-TRIGGER-/VOR-MESSUNG-PFLICHTEN, die im aktuellen Reststrecken-Plan NICHT auftauchen (hoechste Relevanz)

**A1. E-18 LaTeX-Anhang-VORWAERTS-Kanal je CI — NIE GEBAUT.** LEDGER:3554 (§68c) definiert E-18 als benanntes BAU-PAKET "VOR DEM VOLL-BAU-4-TRIGGER" und als "HAUPT-ZIEL des Gesamt-Systems" (auch LEDGER:105, V7.4 Vor-Trigger-Deltas). Im gesamten NACHTRAG-Strom (02.08.-05.08.) existiert KEIN Bau-/Lande-Vermerk zu E-18; die thesis-"Anhaenge-Realm-Welle" (LEDGER:3748) ist thesis-seitige Struktur, nicht der CI-Vorwaerts-Kanal. E-18 fehlt im IST-ANKER (weder laufend noch geplant noch nach Abgabe). => Groesster einzelner liegengebliebener Posten vor dem Trigger Do 07.08.

**A2. E-04-VOLLAUSBAU (A7-Rest) vor Trigger — offen, Owner-gedeckt (R9).** E-04-P1 ist gelandet (LEDGER:3656-3660); der Rest ist explizit "vor Trigger" verortet: Z-05/Z-06/Z-08 -> "A7-Rest-Welle, vor Trigger" (LEDGER:3719), "E-04-VOLLAUSBAU vor Trigger, Owner-R9" + "Mess-Phase hat noch KEINE Marker-v2-Zeile (E-04-P2/P4-Scope, ausdruecklich zuordnen)" (LEDGER:3690). Kein Bau-Vermerk seither; die R3-CLI-Reste wurden auf "Phase-5-ETA/Phase-6-E-04" gelegt (LEDGER:3861), die Z-05/06/08-Fixes und die Mess-Marker-Zeile haben aber keine sichtbare Heimat im aktuellen Board.

**A3. OS-U4 (A14-Rest) — offen; OS-U3 hat 0 produktive Konsumenten.** LEDGER:3723 (GA-10/OS-U4-EINGANGSMARKE: "Diese Zeile verhindert die Fehl-Lesart 'HW-/OS-Erhebung erledigt'"; "GATE 2 zu 1/3 abgearbeitet, der Anschluss IST OS-U4") + LEDGER:3719 (Z-04-Testluecken -> "A14/OS-U4-Testpflichtteil, vor Trigger"). Kein OS-U4-Bau-Vermerk. Ebenso OS-U5 (Session-Doc + Ledger-Vollzug A-08): ausdruecklich "NICHT Teil dieses Pakets" (LEDGER:3618), nie nachgeholt. OS-Werte in Mess-Spalten/Dateinamen (OS-U4-Kern, LEDGER:3616) fehlen damit vor der Messung.

**A4. A4 "12-Perm-Paket" + FS1-Testschuld — offen, "spaetestens vor Messung".** LEDGER:3721: FS1 (Mess-Pfad-stamp_bleibt-Zweig iterator:1812 ungetestet) ist dem Paket A4 zugeordnet ("dort entsteht das Test-DLL-Substrat ohnehin"), Frist "spaetestens vor Messung". A4 taucht danach nie wieder auf (einziger Treffer "12-Perm": 3721). FS2 wird durch die queued A2-Fix-Welle (F4, resume-v6 mit |fpr=) nur TEILWEISE gedeckt (LEDGER:4124); die Inhalts-Anker-Haertung/das E.0-Paket "vor Messung" (LEDGER:3721) ist nirgends eingeplant.

**A5. Mess-Schnitt-Fenster (T6-Einsammel-Naht + Doppelzaehlungs-Regel) — beauftragt, terminlos.** Owner-Entscheid Posten-68 = Option B STRIKT (LEDGER:3928-3931) erzeugt KONSEQUENZ-PFLICHT (a): "Einsammel-Naht + DOPPELZAEHLUNGS-REGEL im Mess-Schnitt-Fenster VOR Messbeginn". Zulieferer liegen bereit (search_allocator_statistics-Naehte 01c, buffer_allocator_statistics 05q LEDGER:4004, Posten 76 "Input fuer die T6-Einsammel-Naht" LEDGER:3946, A2-Zusatz-Substanz LEDGER:4043). Das Fenster selbst steht in KEINEM Plan-Glied der Reststrecke (P2/P3) und nicht im Nach-Abgabe-Band.

**A6. Mess-Interpretations-Entscheide VOR Messbeginn — Posten 74, 77, 78 offen.** (74) OOM-Roh-Route layout_aware append_slot ungeprueft, "gleiche Entscheid-Klasse wie (64), VOR Messbeginn" (LEDGER:3946 — 64 wurde gehaertet, 74 NICHT); (77) kReal16-Suffix-Kollaps + (78) XorFilter 30/256 ECHTE FALSE NEGATIVES, "VOR Messbeginn entscheiden" (LEDGER:3959). Keine Heimat im Board; das "Posten-Register nach Abgabe" deckt ihre Vor-Messung-Frist nicht.

**A7. D-10/L11-Referenz-Eichung + J-Hygiene L2 — nie vollzogen, nur in der Trigger-Sequenz-Referenz.** LEDGER:3734 (D-10: 46er-Differenz lokale ctest vs. CI test:unit einmal belegen; "vor M3-Landung nuetzlich" — M3 landete OHNE sie, LEDGER:3752) und LEDGER:3774 ("TRIGGER-SEQUENZ (7-Auflagen-Satz LEDGER:98, J-Hygiene L2, D-10-Eichung L11)"). Beide leben nur in dieser einen Kette; das aktuelle Board (P3 "Phasen 3-5") nennt sie nicht namentlich. ZUSATZ-FALLE: der Verweis "LEDGER:98" ist GEDRIFTET — der 7-Auflagen-Satz steht heute in LEDGER:104 (V7.4), Zeile 98 traegt inzwischen den Hybrid-Design-Verweis.

**A8. P11 (Phase-5-Pre-Flight) — NIE konsolidiert definiert, sammelt verstreute Pflichten.** P11 traegt inzwischen mindestens: pgrep-Preflight Mess-Exklusivitaet (LEDGER:2914), Env-Pruefung COMDARE_BESTANDSLOG (LEDGER:4130, 4166), Nachhol-Naht der entfallenen physischen Ebene-B-Enumeration (LEDGER:4165). Es existiert kein P11-Checklisten-Dokument/Ledger-Absatz, der diese Pflichten buendelt — Verlustrisiko am Trigger-Tag.

**A9. V7.4 "4+1 lokale Beweise" muessen auf dem GEEICHTEN Stand neu erbracht werden; Variant-Gate-E2E kollidiert mit C6-Befund.** V7.4 (LEDGER:104) verlangt vor dem Trigger: Resume-Skip GN_DECISION, Hydration verified>0+pruned>0, Variant-Gate-E2E, Bestandslog-E2E gegen minio, B+-Baum-Steuerungs-Nachweis, danach G6 (J-0..J-5). Seit der A2-Eichung (SHA512-only-Skip-Gate, LEDGER:4164) sind Alt-Belege dieser Klasse entwertet; zudem ist COMDARE_VARIANT_GATE "seit A2 write-only" (C6-Befund, LEDGER:4123) — der Variant-Gate-E2E-Beweis ist damit aktuell inert und haengt am offenen O-2. Kein Neubeweis-Posten im Board.

**A10. §66-Lager-Gate G1-G5: G5 (und Teile von G1) ohne Vollzugs- oder Supersede-Vermerk.** §66 (LEDGER:3476-3481): G2 (Stempel #36) via A13 M1-M4 vollzogen; G3 (#46b Bestandslog) via Lager-Gate/A1 vollzogen; G4 P-C measure_out-Verlustnaht GESCHLOSSEN (LEDGER:3463) und #37-Preflight GEBAUT (LEDGER:3506); ABER **G5 "P-B Pruning lokal->0 mit verify_remote_then_prune"** hat KEINEN Vollzug (einzige Treffer 3454-3465/3481; Push-/Drop-Aktivierung + lokal->0-Rueckbau brauchen "User-GO je", LEDGER:3465) und wurde durch die Anker-Feststellung "Alt-Bestaende bleiben ADDITIV liegen" (LEDGER:4165) nur faktisch, nie ausdruecklich supersediert; **G1 "B/C/D+amd24 landen (#27)"** hat ebenfalls keinen Lande-Vermerk (amd24 kommt nach 3476 nur noch als Thread-Budget in 4074 vor). O-3 (Loesch-GO) bleibt als drittes Owner-Gate offen (LEDGER:4185), steht aber nicht im Board.

---

## B. OFFENE OWNER-GATES/-VORLAGEN ausserhalb von O-2 (nicht im IST-ANKER)

- **SF-1-Heilungs-Fenster** (einzige anatomy->builder-Aufwaertskante; "OWNER-FENSTER, NIEMALS still heilen", LEDGER:3866, 3869) — offen, ungeplant.
- **Katalog P2-P8 CSV-Schema-Ereignisse**: "Fenster-Zuordnung Owner/Manager (V4 Par.5)" (LEDGER:3875) — Vorlage V4 war NUR-KENNTNIS; Zuordnung nie entschieden.
- **Peak-Quelle** (Wire-Slot Klasse B vs. Zeitreihen-Zuege) — "Entscheid offen, Spalte 'n/a'-vorbereitet" (LEDGER:3875).
- **XML-Rueckfrage-Kandidaten K1-K4** — "VERBOSE im naechsten Owner-Block" (LEDGER:3982, 3990); die folgenden Owner-Bloecke (mittag-1/-6) behandelten nur die Kette-Rueckfragen; K1-K4 wurden nie vorgelegt.
- **Posten-60-Terminierung** (SortedArrayKeySet = benannte REGRESSION nach Owner-Definition): "im naechsten NUR-KENNTNIS-Block vorlegen" (LEDGER:3931) — nicht vorgelegt.
- **FK-8-CSV-Etiketten NUR-KENNTNIS** (LEDGER:3848), **V3b-Ergaenzung G5-Reihenfolge/'+ceb='-Korrektur** (LEDGER:3861), **E4/E14-NUR-KENNTNIS-Block** (T17-Min/Max, 'ohne'-Luecken T14/T16/C-A, LEDGER:3833), **/tmp/comdare_test_1001-Loesch-Frage** (16119 Eintraege, LEDGER:3936) — alle "naechster Owner-Block", keiner belegbar versandt.
- **3 Overlay-Festlegungen (S8/L14)** — nicht-blockierende Owner-Frage fuers spaetere Fenster (LEDGER:3741, 3790, 4162); deklariert, aber ohne Wiedervorlage-Traeger.
- **F27 experiment_golden.xml-Kanonik / #48 GOLDEN-XML NEU** — "user-gated seit 16.07., Sync-Gate haelt" (LEDGER:3869, 3361) — seit 3 Wochen ohne Bewegung.
- **f2/f3-Remote-GOs** (comdare-analysis-Anlage) — "NACH Abgabe terminiert" (LEDGER:3741-3742), als einzige echte REST-OFFEN-Owner-Punkte des Explore-Passes; im Nach-Abgabe-Band nicht namentlich gelistet.

## C. "Naechstes ce-Fenster"-Nachzuege, deren Fenster laengst vorbeikamen (liegengeblieben)

- **Posten 46: G8-Par.1.2-Dateitabelle fortschreiben** — "Lead-Doku-Nachzug im naechsten ce-Fenster NACH der A8-S3-Landung" (LEDGER:3868). Seit A8-S3 (04.08.) gab es >10 ce-Fenster; kein Vollzug.
- **Genus-Erst-Instanziierungs-Regel-Anker in der S4-Matrix-Doku** — "naechstes ce-Doku-Fenster, mit Posten 46" (LEDGER:3899). Nicht vollzogen.
- **Stufen-Doktrin: ce-Doc-NACHZIEH-LISTE** (u.a. hybrid_tier_stufe_soll_design.md) — "fuer das naechste ce-Fenster" (LEDGER:4096); W1/W2/A2-Fenster kamen ohne den Nachzug.
- **E-20-BRING-Pflicht** (I112-Runner-Fleet-Handout): "erst nach Lead-Push ins Cluster-Repo erfuellt; die Vorfassung darf NICHT mehr gepusht werden" (LEDGER:3662) — kein spaeterer Push-Beleg im Ledger.

## D. Kleinere offene Folgeschulden ohne Heimat

- **planer_block-Reaper**: "Folgewelle, sobald der Zweit-Planer-Konsument (profile_run_facade.hpp:248) real wird" (LEDGER:3630, 3790). Mit dem W1-Planer-Binary-Split (LEDGER:4144-4150) ist die Bedingung potenziell eingetreten — die Folgewelle ist nirgends eingeplant.
- **SubAxisMembership-FOLGE-INCREMENT**: Uebernahme der B7-Wurzel fuer die target_isa-Unter-Achsen (numa_node/page/scheduling) mit Byte-Neutralitaets-Nachweis — "nicht Teil 2c" (LEDGER:3639); OD-10-RT baute nur die RT-Probes, nicht die Membership-Wurzel.
- **G-E3-Host-Binder**: 3 Iterator-cfg-Felder mess_bestand_* mit 0 Konsumenten — "eigenes Fenster" (LEDGER:3790).
- **W-11 Cache-Key-Einfaltung** der W2-Combo: "DEKLARIERT OFFEN (nicht stillschweigend)" (LEDGER:4147) — weder im O-2-Paket noch im Nach-Abgabe-Band namentlich; beruehrt die EINE-Schluessel-Welt-Doktrin.
- **A9-S2**: am 04.08. "FREI" gemeldet (LEDGER:3791), danach nie gestartet/gelandet.
- **A10/E-3-Fenster** (MSVC-Escaping + Cross-Bau-Haelfte, LEDGER:3804) — offen, ohne Band-Zuordnung.
- **Posten-83-Generalisierung** (ALLE Familien-Gate-Universen an kOrganGruppen-Quelle koppeln; 05q loeste nur Familie 05) (LEDGER:3999, 4007).
- **fill_observer_v3-Quellen-Umzug auf Anatomie** (Katalog-P1 zweite Haelfte, werte-aendernd, "bewusst nicht in S3, offen") + **8/9 SA-Slots ohne produktive Belegung** (LEDGER:3875).
- **P10-Folge-Sweep** (Substitutions-Feinaufloesung + E12 Statik-Properties, "nebenlaeufig", LEDGER:3830, 3833) — nie gestartet.
- **builder/in_memory_measurement_buffer/ leerer .gitkeep** — "etikettieren oder fuellen" (LEDGER:4029).
- **PhasenCheck-5.16-Rest** (6 Commit-Referenz-Diskrepanzen, "REST nach Phase 7", LEDGER:3781) — geparkt ohne Register-Eintrag.
- **Infra-Posten**: test_s5-Blackhole-PUT-Flake (LEDGER:3804); durable builds_dir/cache_dir-Umzug + periodischer Cleaner + Legacy-S3-Flag-Test (Infra-Lane, LEDGER:3893) — Infra-Territorium, aber ohne Wiedervorlage-Anker im Diplom-Board.

## E. POSTEN-REGISTER-REKONSTRUKTION (Aufraeumpass-Kandidatenliste §75, "Posten 1-92")

Start: §75-Kandidaten-STARTLISTE unnummeriert (LEDGER:3601: V36.B-Dateien, permutations_runtime_check.hpp, COMDARE_apply_simd_flags, cmake/permutations.cmake, _IDS-Alias, historisierte Auflagen, COMDARE_LEGACY_MESSREIHEN nach V-5c) + NICHT-KANDIDATEN-Schutzliste (LEDGER:3602).

Im Ledger belegte Nummern und Status:
- (1) built_skip — ENTSCHAERFT (3659).
- **(2)-(18): FEHLEN IM LEDGER KOMPLETT** (grep 0 Treffer als Listenposten) — die Register-Basis lebt offenbar nur in Session-Docs/Backups; die "Liste-fortschreiben-Doktrin LEDGER:3584"-Referenz ist zudem GEDRIFTET (Zeile 3584 traegt heute §71-Text). => Das Register ist aus der Single-Source NICHT vollstaendig rekonstruierbar.
- (19) stale build/ mit 17-Achsen-Codegen [Achtung getrackte Mess-CSV] (3712) — offen.
- (20) Stamp-Write ohne flush/good =FS3 (3713) — offen. (21) Mess-Pfad-Testluecke =FS1 -> A4 vor Messung (3714) — offen. (22) Bestands-ASCII-Sweep 1132 Dateien (3715) — offen.
- (23) (void)-ohne-try Takeover (3735) — offen. (24) FreeRamFn-Fundstelle (3735) — offen.
- **(25)-(29): FEHLEN IM LEDGER** (wie 2-18).
- (30) test_s5-Tempdir (3790) — durch [69]-Haertung wohl entschaerft, kein Vermerk. (31) Presence-Asymmetrie (3790) — offen.
- (32)/(37) SlotCount-13-vs-11 (3798, 3861) — offen. (33)-(36), (38) (3825, 3861) — offen; (36) 29 K1-Prosa-Stellen.
- (39)-(53) Struktur-Audit (3868) — offen; (43) eigenes Owner-Fenster NACH Abgabe; (46) LIEGENGEBLIEBEN (s. C); (50) nach V-5c.
- (54) stale Zeilen-Anker abi_adapter (3904) — offen.
- (55)-(63) Kartierung (3911) — offen; (62)=KF-6 mit SCHARFER Warnung kLbufBytes-OOB bei line_size>64 (3939) — MUSS im KF-6-Fenster mitbewegt werden.
- (64) ERLEDIGT, (65) MIT-ERLEDIGT, (69)/(70) ERLEDIGT (Haertungs-Welle, 3936).
- (66) offen. (67) nach Abgabe/Owner-Vorlage. (68) ENTSCHIEDEN (Option B strikt, 3931) — Konsequenz-Pflichten OFFEN (s. A5). 
- (71)-(76) offen (3938, 3946); (74) VOR Messbeginn. (77)/(78) offen, VOR Messbeginn (3959).
- (79) offen; (80) ERLEDIGT via h81-Aufklaerung (3961, 3974). (81)=K2 nach Abgabe (3969). (82) GEHEILT bei 01c-3-Landung (3989, 3995).
- (83)-(86) offen (3999); (87)-(89) offen/Kenntnis (4044); (90) Auswertungsphase (4091); (91) Hinweis-Regeln-Verfeinerung offen (4173); (92) R-G2 Registry-Kanon-Divergenz offen (4148).

Kern-Befund: Das Nach-Abgabe-Band "Posten-Register-Abarbeitung" deckt NICHT die Posten mit frueherer Frist — (74), (77), (78), (62/KF-6-Warnung), (21/FS1), (68-Konsequenzen) sind VOR Messbeginn faellig; (19) vergiftet jeden lokalen Haupt-build-Lauf schon jetzt.

## F. AELTERE §-RESTSTRECKEN (§55-Gesamtblock v2, Stand 20.07.) ohne spaeteren Erledigt-/Supersede-Vermerk

Relevante weiterhin als OFFEN gefuehrte Punkte, die im NACHTRAG-Strom nie wieder auftauchen:
- **FF0-Owner Multi-Plattform-Generalitaet fehlt explizit — als "Abgabe-Blocker, hoch" gefuehrt** (LEDGER:2916; auch 2940 G8-Anhaenge-Block: Anhaenge B/E-Stubs + Mess-Manifest/Provenance). Bei Abgabe Fr 08.08. der kritischste Alt-Posten.
- Goldener Coverage-Test #18 (2919) — evtl. durch Voll-Bau-4 subsumiert, nie vermerkt.
- S-7 Deep-Research Locking (GEPARKT, 2560ff) · m3v2-Neu-Build-Beleg (2587) · I-PMC-2/3 (2576) · W12-B Cache-Key-Spiegelung (2619; durch A2-Eichung vermutlich subsumiert, kein Vermerk) · Datensatz-Akten 5/8 fehlen + 6-vs-48 user-gated (2622) · Serialisierungs-Umsetzung 4 Neu-Bau-Straenge (2624) · measure-drop-XML-Default (2623) · INC-5/INC-6 infra-delegiert (2597) · CI-2-Pass-Haertung (2631) · Mess->PDF-Rueckschrieb E2E (2594/2941, an Messlauf gebunden — Phase 6, ok als gated).
- Hinweis: §55 ist der LETZTE Voll-Konsolidierungs-Block; seither wurde kein Gesamt-Reconcile gegen ihn gefahren (nur punktuelle "-> ERLEDIGT"-Anmerkungen).

## G. CHUNK-DELTA D-01..D-17 (26.07.) + 982er-ANKER-AUFLAGEN

- D-01/-02/-03/-05/-06/-07/-08/-10/-12/-13/-14/-15-Kerne: verarbeitet/gebaut (Belege: 3506 #37, 104 D-03 "bereits erbracht", 3786 S2-Realm-Writer + S5 2.4-(8), Anker-Invalidierung 4165).
- **D-04 zweite Haelfte ("lokaler Fussabdruck gegen null") = §66-G5-Pruning — offen** (s. A10).
- **D-09 on/off-Token in Ordner-/Metadaten-Namen** (hinter load_framework) — in der lager_pfad_grammatik-Landung (3786) nicht als geprueft vermerkt; unbestaetigt.
- **D-11 Schreibweisen-Bestaetigung "extermal/external_utils"** — Ein-Zeiler-Bestaetigung nie verbucht (Rename faktisch gelandet, formale Bestaetigung fehlt; niedrig).
- **D-16: existiert im Memory-Digest NICHT (Sprung D-15 -> D-17) und im Ledger NIE** — Inhalt nur im Workflow-Output wshvhykd7; Verbleib ungeklaert.
- Q-1-Praezisierungs-Rueckfrage (Achse/Baustein-Trennung "nicht literal") — im Memory als offen markiert; beruehrt K4 (enabled=false-Sichtbarkeit, 3990).
- 982er-Anker E-01..E-26: Ledger fuehrt nur "u.a." (105) — E-02/E-19/E-21/E-23/E-24 vollzogen, **E-04 teilweise (s. A2), E-18 offen (s. A1)**; ein Voll-Status aller 26 Deltas wurde im Ledger nie nachgehalten (nur im Session-Doc `20260726-SESSION-wahrheits-anker-voll-abgleich-982-E01-E26.md`).

## H. PHASEN-3-5-INHALT (Frage 4 des Auftrags)

Der Arbeitsinhalt der Phasen 3-5 ist im Ledger NICHT als eigener Abschnitt definiert; er ergibt sich nur aus (a) V7.4-Gate-Kette LEDGER:104 (4+1 lokale Beweise -> G6 J-0..J-5 -> Trigger mit 7 Auflagen), (b) der Trigger-Sequenz-Zeile LEDGER:3774 (7-Auflagen-Satz [Drift: "LEDGER:98" -> real :104], J-Hygiene L2, D-10-Eichung L11), (c) verstreuten L-/Phase-Referenzen aufs externe Lage-Dossier (L2/L4/L5/L6/L9/L11/L14/L18/L20/L22; Phase-5-ETA 3861, Phase-5-Pre-Flight P11 4165, Phase 6.5 3833, Phase 7 3781). Das Lage-Dossier selbst ist teils stale (GATE-9-Zitierfehler korrigiert 3758; 3.6.4 stale 3781). => Die Phasen-3-5-Vorarbeiten aus A1-A9 haengen an Referenzen, die im aktuellen Board (P3 = "Phasen 3-5" als Blackbox) nicht ausgefaltet sind — genau die Klasse, in der Posten verloren gehen.

---

## PRIORISIERTE KURZLISTE (fuer den Owner-/Manager-Blick)

1. E-18 Vorwaerts-Kanal (Vor-Trigger-Bau-Paket, HAUPT-ZIEL) — nie gebaut. [A1]
2. E-04-Vollausbau/A7-Rest inkl. Mess-Marker-v2 (vor Trigger, Owner-R9). [A2]
3. OS-U4 (+OS-U5-Doku) — OS-Erhebung hat 0 produktive Konsumenten. [A3]
4. Mess-Schnitt-Fenster (T6-Einsammlung + Doppelzaehlungs-Regel) vor Messbeginn. [A5]
5. Posten 74/77/78 + KF-6/kLbufBytes-Warnung — Entscheide vor Messbeginn. [A6, E]
6. 4+1-Beweise + G6 auf geeichtem Stand; Variant-Gate-E2E derzeit inert (O-2-Kopplung). [A9]
7. D-10/L11-Eichung + P11-Konsolidierung + LEDGER:98-Zeilendrift heilen. [A7, A8]
8. §66-G5-Pruning/O-3 + G1-amd24: Vollzug oder ausdrueckliches Supersede. [A10]
9. FF0-Owner (Abgabe-Blocker aus §55) — Status klaeren vor Fr 08.08. [F]
10. Posten-Register-Basis (2-18, 25-29) in die Single-Source holen; Owner-Block-Rueckstau (K1-K4, Posten 60, P2-P8, Peak-Quelle, SF-1, /tmp-Loeschung) buendeln. [E, B]
