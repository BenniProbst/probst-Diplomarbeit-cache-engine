# LESER 10 von 12 -- Extraktion (Batch: Index i % 12 == 9 der gb_dateiliste.json)

Quelle: /home/comdare/.claude/jobs/5a19728e/tmp/regressions-gesamtbild/
Datum der Extraktion: 2026-08-14 (F1-Tag)

## Batch-Dateiliste (Index in gb_dateiliste.json, Name, Groesse Bytes)

| Idx | Datei           | Bytes  | Inhalt (summary-Kurzform) |
|-----|-----------------|--------|---------------------------|
|   9 | wo8yyv72t.json  | 199969 | Research+Design-Flow checkpoint_measure (CT-vollstaendige Mess-Steuerzeile), 34 Einwaende/16 tragend, Endfassung 96908 Z. |
|  21 | w50k74cln.json  | 128366 | Audit Lead-Arbeit gegen ARBEITSWEISE-GESAMT-DOKTRIN, 136 Regeln erfasst, 100 geprueft, 52 Verletzungen |
|  33 | wssynj4q3.json  |  93703 | Fable 5 xhigh: 6 Kontexte auf Fragen/Owner-Antworten verbatim, 360 Owner-Nachrichten, 79 Paare, 11 offen, 33 Direktiven |
|  45 | wb8p02wqu.json  |  74476 | Planer-CLI --check-size mit CEB-Kommunikation, Paper-als-XML, 41 Luecken, Synthese 41710 Z. |
|  57 | w20ado9k1.json  |  57377 | Audit Diplomarbeit gegen Code-Ist, 19 Befunde veraltet, Textnachzug, Review landebereit |
|  69 | w1pm0nio7.json  |  42441 | #21: E-1..E-4-Vollzug + A-1-Vorlagetext, Explore/Bau/Verify, 9 offene Punkte |
|  81 | wj9s9vcmp.json  |  32634 | Zweiter Lens (Fable, adversarisch) ueber S-14a-Riegel: 3 Achsen, je TRAEGT_MIT_FIXES |
|  93 | ww231ccuy.json  |  27635 | P2-P8-Katalog (B5, G-E3, Lager+xlsx, E14, Posten 89) + P3-Trigger-Reste |
| 105 | wsmsmgp8o.json  |  19940 | B14-NB3: Codex-BLOCKER an CMake-Wachen (super) + ce-Nachbesserung |
| 117 | wnru437uo.json  |  13656 | LUECKE: transiente Build-Graph-Race unter -j32 (generated_source_catalog.hpp) |
| 129 | w5u7xpiiz.json  |   9499 | B14-NB4 VOLL: ce-CLU-Blocker + alle super-Befunde beider Lenses |
| 141 | wbd3zs3qy.json  |   6175 | B14-Kleinst-Nachbesserung: 2 Fable-Review-Restpunkte in wt-b14-golden |

Hinweis: Die Extraktion folgt dem vorgegebenen Format. Nummerierung je Quelldatei fortlaufend.

---
# QUELLE 1: wo8yyv72t.json (Research+Design checkpoint_measure, 10 Agenten, 1.585.667 Tokens)

Kontext: Research (5 Aspekte, 118 Befunde) + Design + Adversarisch (34 Einwaende, 16 tragend) + Endfassung (96908 Zeichen).
Gegenstand: CT-vollstaendige Mess-Steuerzeile checkpoint_measure mit virtuellen Thread-Slots und append-only Log.

### [wo8yyv72t] 1
GEGENSTAND: Sechs Bau-Regeln R-A1..R-A6 fuer den Append-Log (Slot je virtuellem Thread ohne Atomik im Hot-Path; Padding via static_assert auf hardware_destructive_interference_size; Satzgroesse 16 B Ziel 8 B; nicht-temporale Stores; -ftls-model=initial-exec je Checkpoint-TU; Zeitquelle rdtsc = 96 Prozent der Checkpoint-Kosten).
ORT: Research-Aspekt append-log (31 Befunde); Bezug ce docs/architecture/20260808-checkpoint_measure_soll_design.md
SOLL/FIX: verbatim u.a.: "EIN SLOT JE VIRTUELLEM THREAD, KEINE ATOMIK IM HOT-PATH" (pro-Thread-Slot 7,05-7,21 ns flach 1..16 Threads vs. gemeinsamer Puffer relaxed fetch_add 487,7 ns = Faktor 69); "static_assert(sizeof(Slot) == std::hardware_destructive_interference_size)" + Wache auf unterschiedliche addr>>6-Werte; "-ftls-model=initial-exec FUER JEDE UEBERSETZUNGSEINHEIT MIT CHECKPOINTS ... als CMake-Eigenschaft an das Checkpoint-Interface-Target, nicht als Kommentar" (3,02 ns statt 0,38 ns sonst, ~100 ns je Interface-Aufruf bei 38 Checkpoints).
STATUS LT. QUELLE: Empfehlung (Design-Input), nicht gebaut
ABHAENGIGKEIT/FLAECHE: R-A4 (NT-Stores) wird von Einwand-Posten 12/13 (unten) frontal widerlegt; R-A6-Uhrfrage ist Owner-Frage

### [wo8yyv72t] 2
GEGENSTAND: Offene Punkte des append-log-Aspekts (9 Stueck, 0-8 von 9).
ORT: Research append-log, KEY offen
SOLL/FIX: (0) Messumgebung unsauber: prod1 unter Last ~50 Agenten, erster bench_mt-Lauf verfaelscht (28,15 statt 7,21 ns bei 8 Threads); Zahlen tragen nur RANGFOLGE, absolute Aussagen gehoeren in die CEB-Maschinerie. (1) ARM/RISC-V ungemessen, kein Cross-Compiler auf prod1; RISC-V hat KEINE movnt-Entsprechung im Basis-ISA = echte Portabilitaetsluecke fuer R-A4. (2) Keine veroeffentlichten ns-Zahlen fuer ETW/Perfetto/eBPF/aktuelles LTTng-UST; LTTng-Zahlen 119-314 ns sind von 2009/Kernel und duerfen nicht als heutige Userspace-Kosten zitiert werden. (3) NT-Store unter schreiblastigem Opfer UNGEMESSEN (wichtigste offene Gegenprobe vor Einbau R-A4). (4) constinit-Waechter-Ersparnis UNGEMESSEN, nicht als Bau-Regel erhoben. (5) -Winterference-size konnte nicht ausgeloest werden; beim Bau nachpruefen. (6) "2,5 ns Aufschlag je nicht eingebettetem Checkpoint" ist Differenz zweier Aufbauten, keine Direktmessung. (7) Ob MICRO-Ebene eine Uhr braucht = OWNER-Frage (beruehrt Soll-Design offene Punkte 3 und 6). (8) Mikrobenchmarks ersetzen den CEB-Differenz-Nachweis NICHT; der braucht Trennung von G3 aus dem STATISTICS-Gate, die laut mess_achsen_naht.hpp:81-95 heute nicht existiert.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: G3-Gate-Trennung (mess_achsen_naht.hpp:81-95); Owner-Frage Uhr auf micro

### [wo8yyv72t] 3
GEGENSTAND: Thread-Slot-Empfehlung: constinit thread_local uint32_t GENAU EINMAL in gemeinsamer beim Start gelinkter Mess-Bibliothek definieren, Tier-Binaries nur extern-Deklaration, alles mit -ftls-model=initial-exec.
ORT: Research-Aspekt thread-slots (13 Befunde)
SOLL/FIX: verbatim: "den Slot als `constinit thread_local std::uint32_t` GENAU EINMAL in einer beim Start gelinkten gemeinsamen Mess-Bibliothek definieren, in allen Tier-Binaries nur als `extern constinit thread_local` deklarieren, und diese Bibliothek UND die Tier-Binaries mit `-ftls-model=initial-exec` uebersetzen." BAU-AUFLAGE: Tier-Binaries duerfen KEINE eigenen thread_local-Daten anlegen (statischer TLS-Vorrat prozessweit ~1665 Byte; 7. dlopen-.so mit eigenem IE-TLS bricht mit "cannot allocate memory in static TLS block"); Checkpoint-Ringpuffer hinter Zeiger oder prozessweite ueber Slot indizierte Tabelle. Ueberlauf: KEIN Wrap-around; Etiketten `slot_ueberzaehliger_thread` und `slot_kein_slot` in Form von organ_axis_error_classes.hpp (string_view).
STATUS LT. QUELLE: Empfehlung, nicht gebaut
ABHAENGIGKEIT/FLAECHE: setzt gemeinsame beim Start gelinkte Bibliothek voraus (Existenz im Repo NICHT erhoben, offene Repo-Frage); Thread-Unterachse muss Obergrenze als NTTP herausgeben (axis_08_concurrency_observable.hpp:85 deckelt heute zur LAUFZEIT auf 64)

### [wo8yyv72t] 4
GEGENSTAND: Offene Punkte des thread-slots-Aspekts (9 Stueck, 0-8 von 9).
ORT: Research thread-slots, KEY offen
SOLL/FIX: (0) 1665-Byte-TLS-Vorrat glibc-2.39-spezifisch, 8er-Docker-Matrix NICHT durchgemessen. (1) musl nicht geprueft (behandelt initial-exec unter dlopen anders). (2) RISC-V TLS-ABI (tp-Register) ungeprueft. (3) Existenz einer gemeinsamen, beim Start gelinkten Bibliothek gegen die alle Tier-Binaries linken: NICHT im Repo erhoben; ohne sie faellt Null-Vorrat-Eigenschaft weg, 7-Binaries-Deckel wird real. (4) Ladeart der Tier-Binaries (RTLD_LOCAL/GLOBAL, dlmopen) nicht geprueft. (5) Compile-time-Obergrenze der Thread-Unterachse existiert heute nicht als NTTP, nur Laufzeit-Deckel 64 (axis_08:85). (6) Nur das LESEN der Slot-Nummer gemessen, Gesamtkosten eines Checkpoints nicht. (7) Nebenlaeufigkeit/false sharing der Slot-indizierten Puffertabelle weder gemessen noch ausgeschlossen. (8) Zwei unaufgeklaerte Ausreisser (8,187/61,529 ns).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Achsen-Definition (axis_08); CEB-Link-Struktur

### [wo8yyv72t] 5
GEGENSTAND: CT-Deskriptor-Empfehlung: ein struct CheckpointSite je Aufrufstelle via Makro COMDARE_CHECKPOINT(LEVEL, TAG); Achsen-Parameter als geteilter mp11-Deskriptor via Zwei-Pass-Senken; Linker-Sektion comdare_ckpt; 8-Byte-Log-Eintrag mit site_id = COMDARE_CKPT_TU_BASE + __COUNTER__.
ORT: Research-Aspekt ct-deskriptor (21 Befunde); Muster: build_variant_set_signature.hpp:118-127, :283-285; COMDARE_ANATOMY_VERSION_STAMP_M; mess_gates_glied.hpp:39-51
SOLL/FIX: verbatim-Kerne: Makro ist Pflicht "weil beide NTTP-Wege am Objekt tot sind (source_location nicht strukturell; String-Literal-Zeiger kein Template-Argument)"; Emitter "gehoert neben build_variant_set_signature.hpp ... und er soll dieselben Namens- und Zeichenvorrat-Wachen (COMDARE_BVSET_NAME_WACHE / _PAAR_WACHE) erben, sonst entsteht ein zweiter, ungewachter Signatur-Kanal"; fehlender Define COMDARE_CKPT_TU_BASE muss mit #error brechen; dlopen-Regeln: (a) jede Tier-Binary exportiert comdare_ckpt_table() (Muster comdare_anatomy_version_lines), (b) Loader MUSS Tabelle VOR dlclose ernten (anatomy_module_loader.cpp:86-87 nullt VOR dem Entladen, Ernte an dieselbe Stelle); Mess-Ebene NIE ueber inline-Entitaet mit externer Bindung reichen, sondern am Makro-Expansionsort (Haus-Regel mess_gates_glied.hpp:39-51); InMemoryMeasurementBuffer darf NICHT Grundlage sein (nimmt Mutex + map je append, allokiert via push_back -- R2/R3 frontal verletzt), Slot-Puffer neu bauen, Bestandspuffer bekommt Kommentar der die Diskrepanz benennt.
STATUS LT. QUELLE: Empfehlung, nicht gebaut
ABHAENGIGKEIT/FLAECHE: Fingerprint-Frage (Posten 6, item 6); C-13 Punkt 1/3; G3

### [wo8yyv72t] 6
GEGENSTAND: Offene Punkte des ct-deskriptor-Aspekts (9 Stueck, 0-8 von 9).
ORT: Research ct-deskriptor, KEY offen
SOLL/FIX: (0) CT-Obergrenze Thread-Slots nicht belegt; thread_count ist Laufzeit-Feld (wt-ce-fk/libs/cache_engine/anatomy/resource_controllable_tier.hpp:35, builder/algorithm_resource_control.hpp:49); Herkunft des CT-Maximalwerts (Registry/CMake/XML) NICHT feststellbar. (1) C-13 Punkt 1 (TU mit zwei Mess-Ebenen?) am Objekt nicht entscheidbar, da noch keine Checkpoints existieren. (2) Sektions-Tabelle ausserhalb ELF/GNU-ld UNGEPRUEFT (Mach-O/PE; reale Windows/macOS-Pfade existieren im Baum). (3) Ob ce-Bau --gc-sections/-ffunction-sections/LTO fuehrt: grep ueber CMakeLists.txt und cmake/*.cmake = NULL Treffer; Unterverzeichnisse nicht durchgesehen. (4) Archiv-Luecke belegt (nicht referenziertes .o in .a fehlt in Tabelle); praktische Reichweite in ce ungeprueft; Sektion ist NICHT die richtige Quelle fuer eine Vollstaendigkeits-Wache. (5) Anker-Kadenz fuer 32-Bit-Zeit-Delta (Wrap ~1,4 s bei 3 GHz) nicht ausgelegt. (6) Ob COMDARE_CKPT_TU_BASE/Modul-Kennung IDENTITAETS-wirksam (Fingerprint-Preimage wie neuntes Glied mess-gates) = Architektur-/Owner-Frage, beruehrt anatomy_fingerprint.hpp. (7) Overhead-Nachweis via CEB-Differenz blockiert: mess_achsen_naht.hpp:81-95, G2/G3 teilen EIN Gate, von 6 CEB-Varianten hoechstens 2 herstellbar. (8) Alle Latenzzahlen warme Ad-hoc-Werte, tragen nur Rangfolge.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: anatomy_fingerprint.hpp; G3-Folgepaket; Owner-Frage Identitaetswirksamkeit

### [wo8yyv72t] 7
GEGENSTAND: Aufloesungs-Algorithmus (ein Vorwaertsdurchlauf O(n) je Slot, LIFO-Stapel je Ebene, Befunde als Nebenprodukt, k-Wege-Merge, Zeitbasis-Anker, Additivitaet der Gattungs-Ebene 35=10+25) mit Korrektheitsbeweis; zwei erzwungene Bau-Entscheide: (A) "naechsthoehere Ebene" MUSS ueber die AKTIVEN Ebenen laufen, nicht stur L-1; (B) Zeile ZEIGT auf Span-Satz statt Kopie (Taint einpassig).
ORT: Research-Aspekt aufloesung (23 Befunde)
SOLL/FIX: Waisen-OUT-Zeilen werden GESCHRIEBEN, nie verworfen; Ueberlaufzaehler je Slot ist "das einzige, was Ueberlauf und echte N-6-Regression auseinanderhaelt", MUSS je Slot gefuehrt und in Befundliste gefuehrt werden; Slot-Wiederverwendung MUSS verboten werden; Tie-Break-Schluessel (t_geklemmt, slot_id, pos_im_slot) = strenge Totalordnung, byte-stabil (Golden-Doktrin); Anker-TRIPEL an Lauf-Anfang und -Ende; rdtscp NICHT (14,2 statt 7,3 ns), stattdessen pruefen+klemmen (STEMPEL_INVERSION als Befund).
STATUS LT. QUELLE: Empfehlung; ABER von Einwaenden 4-6 (Doppelabzug Geschwister/Schachtelung, ungepruefte OUT-Paarung, nicht aufgeloester Ebenen-Sprung) als fehlerhaft belegt
ABHAENGIGKEIT/FLAECHE: Einwaende-Posten 15-17 unten; seg_framework_ns-Gegenueberstellung

### [wo8yyv72t] 8
GEGENSTAND: seg_framework_ns liefert eine ANDERE Groesse als der geplante Gattungs-Rest (andere Klammer, andere innere Menge, anderes Instrument: praktisch vollstaendig 36x steady_clock::now je Batch, mit rdtsc fiele derselbe Rest um Faktor 2,5; andere Koernung; stille Klemme statt lauter Meldung).
ORT: abi_adapter.hpp fill_segment_timing_v3; Vergleich im Research-Aspekt aufloesung (e)
SOLL/FIX: In jede Gegenueberstellung gehoert der Instrument-Boden, "sonst vergleicht man Messgeraete und nennt es Architektur"; stille Klemme (run_total > total) ? ... : 0 wird am neuen Ort LAUT gemeldet (STEMPEL_INVERSION).
STATUS LT. QUELLE: nur-hinweis (Design-Input)
ABHAENGIGKEIT/FLAECHE: C-13.2-Entscheid (Gattungs-Ebene): aufloesung sagt EIGENE VIERTE Ebene zwischen macro und micro; ebenen-flags-Aspekt sagt GATTUNG IST KEINE VIERTE EBENE (Ledger:2804,:6808,:7781) -- WIDERSPRUCH zwischen zwei Research-Aspekten derselben Quelle

### [wo8yyv72t] 9
GEGENSTAND: Offene Punkte des aufloesung-Aspekts (8 Stueck, 0-7 von 8).
ORT: Research aufloesung, KEY offen
SOLL/FIX: (0) KEIN abgelegter Messdatensatz traegt seg_framework_ns (0 Treffer ueber alle CSVs, auch Archiv 20260606-fullpilot-320 mit 134 Spalten); Wert nur LIVE via test_a8s1_t17_vollzaehligkeit an EINER Komposition erhoben; ob 1,8-1,9 Prozent typisch: NICHT belegt. (1) Anteil rng/Schleife/Branch nur nach oben beschraenkt. (2) Zahlen aus anker_probe.cpp Abschnitt (C) sind zu VERWERFEN (Wettlauf in Barriere; erst rendezvous2.cpp belastbar). (3) Fremdlast: nur min-basierte Werte belastbar. (4) TSC-Aussagen nur prod1/Zen5; prod2 (Intel) eigenstaendig belegen, nicht uebertragen; Suspend/Resume und VM ungeprueft. (5) Ob JEDER micro-Aufruf ueber ein Gattungs-Interface vermittelt wird: NICHT am Objekt festgestellt; Additivitaet 35=10+25 nur am Prototyp belegt. (6) Ueberlauf-Strategie (juengste verwerfen vs. aelteste ueberschreiben) NICHT entschieden -- legt fest, welche Anomalie der Ueberlauf erzeugt; ohne Zaehler nicht von echter N-6-Regression unterscheidbar. (7) O(n)-Speicher der Aufloesung; haengt an offener Kapazitaetsfrage (Soll-Design Offenpunkt 4, --check-size); stroemende Variante nicht ausgearbeitet.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: --check-size (Quelle wb8p02wqu behandelt genau das); Owner-Entscheid Ueberlauf-Strategie

### [wo8yyv72t] 10
GEGENSTAND: ebenen-flags-Aspekt: Vorgabe "CMake-Flags kompilieren die Mess-Ebene ein" ist fuer compare erfuellbar, fuer macro/micro am Objekt UNMOEGLICH (eine TU traegt beide Ebenen, 786 Deps, abi_adapter.hpp UND 171 Achsen-Header; TU wird von g++-Subprozess mit EINEM Define-Vektor gebaut, nicht von CMake).
ORT: Research-Aspekt ebenen-flags (30 Befunde)
SOLL/FIX: verbatim-Kerne: (1) "DIE EBENE STEHT AM AUFRUF, nicht an der Datei ... checkpoint_measure<Ebene::Micro, Tag::IN>(...)" -- beantwortet Soll-Design-Offenpunkt 2 mit NEIN und schliesst ihn. (2) CMake setzt genau EINE Sache: OB eine Ebene einkompiliert wird; Kanal resolve_live_measurement_combo_legend -> mess_achsen_defines -> perm_mess_defines -> g++ -D; "Kein zweiter Mechanismus daneben"; kuenftiges G3-Gate haengt sein #if daran (Naht :112-114). (3) Traeger: reine INTERFACE-Bibliothek nach Muster comdare_measurement_combo_ct (profile_facade/CMakeLists.txt:160-167); AUFLAGE: kein target_link_libraries auf dem Traeger; ZWEITE AUFLAGE: niemals neues link_libraries() im Verzeichnis-Scope der Wurzel (Ursache des geheilten Zyklus). (4) GATTUNG IST KEINE VIERTE EBENE (Gegenstand von macro, Ledger:2804/:6808/:7781); Gattungs-Anteil = Subtraktion beim Auslesen. (5) checkpoint_measure kann VOR G3 gebaut werden, ABER G3-Paket muss tests/unit/test_a8s4_release_pfad_neutralitaet.cpp:166-168 im selben Commit mitziehen (drei zulaessige Gate-Formen hart im Quelltext; viertes Makro faerbt Release-Neutralitaets-Wache rot).
STATUS LT. QUELLE: Empfehlung, nicht gebaut
ABHAENGIGKEIT/FLAECHE: WIDERSPRUCH zu aufloesung-Aspekt bei C-13.2 (vierte Ebene ja/nein) -- muss der Designer aufloesen; G3-Folgepaket; Einwand 7 (AktivMaske) unten

### [wo8yyv72t] 11
GEGENSTAND: Offene Punkte des ebenen-flags-Aspekts (7 Stueck, 0-6 von 7); darunter ein selbst benannter WIDERSPRUCH.
ORT: Research ebenen-flags, KEY offen
SOLL/FIX: (0) WIDERSPRUCH Owner-Frage: LEDGER:7781 nennt als Messort der macro-Ebene "CEB-seitig, auf dem Pruefdock, gegen die Tier-Binary"; der Code hat die macro-Instrumente IN der Tier-Binary einkompiliert (run_workload abi_adapter.hpp:589-1123, fill_segment_timing_v3 :1784-2057). Entscheidung bestimmt, ob macro-Checkpoints im CEB-Target oder in der Tier-TU liegen und ob die TU-Kollision {macro,gattung,micro} oder nur {gattung,micro} ist. (1) Owner-Zahl "3! = 6 Permutationen" aus dem Code nicht herleitbar: Registry hat 3 Toolings (measurement_tooling_registry.hpp:46-49) = 7 nichtleere Teilmengen, nicht 6; heute genau EINE combo ([all]). (2) Realer ce/super-Baum NICHT konfiguriert; "zieht keine neuen Kanten" nur an nachgebauter Probe belegt; cmake-Generate des geheilten super-Baums mit Ebenen-Traeger steht aus. (3) Heilung 52e9f3ba nur als im Worktree-HEAD enthalten belegt, echter super-Superbuild nicht nachgemessen. (4) Slot-Obergrenze zur CMake-Zeit bekannt? nicht untersucht. (5) tests/unit/CMakeLists.txt:1478-1481 baut mind. ein comdare_anatomy_perm_*-Modul ALS CMake-Target -- fuer diese gilt "CMake baut keine Tier-Binaries" NICHT. (6) canonical_combo (plan_legend.hpp:90-92) nicht aufgeschlagen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Owner-Frage Messort macro; CEB-Varianten-Zaehlung (6 vs. 7)

### [wo8yyv72t] 12
GEGENSTAND: TRAGENDER EINWAND (latenz #1): Der TSC auf prod1 zaehlt in 43er-Spruengen (100-MHz-Referenztakt hochskaliert); effektive Aufloesung eines Stempelpaares 43 Ticks = 10,0 ns; die Mikro-Ebene (2-20 ns je Achsen-Operation) ist mit dieser Zeitquelle GRUNDSAETZLICH nicht aufloesbar; die im Entwurf genannte "Messaufloesung ~0,15 ns" ist eine Schleifenmittel-Aufloesung, auf die Einzelspanne um Faktor 43 falsch uebertragen; entwertet auch den Gattungs-Anteil (19 Kindspannen mit je +-10 ns Quantisierungsfehler subtrahiert).
ORT: ZyklusZaehler::jetzt() / __rdtsc() -- Zeitquelle jedes Checkpoints (Signatur Abschnitt 6; Kostentabelle hot_path_kosten Posten 6/7); Messungen /tmp/skep/korn.cpp, korn2.cpp
STATUS LT. QUELLE: offen (tragender Einwand gegen den Entwurf)
ABHAENGIGKEIT/FLAECHE: R-A6; Owner-Frage "braucht micro eine Uhr" wird hierdurch dringlich

### [wo8yyv72t] 13
GEGENSTAND: TRAGENDER EINWAND (latenz #2): rdtsc ohne lfence/rdtscp ist nicht serialisierend; ungefenced ist eingeschlossene Arbeit unsichtbar (Kettenlaengen 0..16 identisch Median 42 Ticks); Heilung kostet: lfence-Klammer 14,68 ns, rdtscp 13,74 ns; unter echtem L1-Schreib-Opfer: ungefenced -0,88 ns (voellig verdeckt), geordnet 15,32 ns und +125,1 Prozent Verfaelschung. Entwurf benennt die Alternative "BILLIG UND UNVERORTET oder VERORTET UND UEBER BUDGET" nirgends; Owner-Vorgabe "wir koennen Latenzen nicht in der Messung dulden" in der korrekten Variante um Faktor 2 verletzt.
ORT: ZyklusZaehler::jetzt() -- bewusst ohne lfence/rdtscp; Messungen /tmp/skep/ordnung.cpp, zeit.cpp, nt2.cpp
STATUS LT. QUELLE: offen (tragender Einwand)
ABHAENGIGKEIT/FLAECHE: STEMPEL_INVERSION-Klemme behandelt systematischen Normalfall als Anomalie

### [wo8yyv72t] 14
GEGENSTAND: TRAGENDER EINWAND (latenz #3): Der NT-Store-Befund "+44,4 Prozent normal vs. +2,1 Prozent movntdq" REPRODUZIERT NICHT -- Gegenprobe unter bestmoeglichen Bedingungen fuer die These: NORMAL-Store -0,7/+1,1/+0,3 Prozent, NT-Store +0,4/+3,4/+2,0 Prozent (NT auf allen drei Kernen schlechter); Dichte-Sweep innerhalb +-1 Prozentpunkt mit wechselndem Vorzeichen; schreiblastiges Opfer: normal +14,8, NT +16,4 Prozent. Der Befund ist der einzige empirische Traeger der NT-Wahl (an ihm haengen sfence, Ausrichtungs-Zusage, StandardAblage, RISC-V-Luecke).
ORT: StromAblage / _mm_stream_si128 als StandardAblage (Entwurf Abschnitt 6); Messungen /tmp/skep/nt3.cpp, dichte.cpp, nt.cpp
STATUS LT. QUELLE: offen (tragender Einwand; widerlegt R-A4)
ABHAENGIGKEIT/FLAECHE: R-A4; Posten 15 (DRAM-Band)

### [wo8yyv72t] 15
GEGENSTAND: TRAGENDER EINWAND (latenz #4): NT-Stores umgehen L1/L2/L3 und landen im Hauptspeicher; bei 16 Slots frisst allein der Messfuehler 46 Prozent des gesamten Schreibbands (30,89 von 66,8 GB/s Dach); bei COMDARE_CKPT_SLOTS=64 liegt die Log-Schreiblast rechnerisch UEBER dem Dach. Der Entwurf bilanziert die vermiedene L1-Stoerung, nicht die erzeugte DRAM-Last.
ORT: StromAblage-Begruendung (Abschnitt 6, begruendung Punkt 6); Messungen /tmp/skep/band.cpp, dach.cpp
STATUS LT. QUELLE: offen (tragender Einwand)
ABHAENGIGKEIT/FLAECHE: R-A4/NT-Wahl; Slot-Anzahl-Entscheid

### [wo8yyv72t] 16
GEGENSTAND: TRAGENDER EINWAND (korrektheit #1): Der Korrektheitsbeweis verwechselt "gleiche Ebene" mit "Geschwister" -- alle micro-Spannen unter einer macro-Spanne bekommen dieselbe Mutter; geschachtelte Zeit wird doppelt/dreifach abgezogen; rest(macro) wird NEGATIV; weder Klemme noch Fehlerklasse vorhanden. Am Objekt strukturell: composed_art_trie_search.hpp:41 ruft insert_into<Pool> (Achse 03a in Achse 04), Zeile 39 haengt allocator_type (Achse 06) darunter -- drei micro-Ebenen ineinander in EINEM Interface-Aufruf.
ORT: aufloesung PHASE 3 + Korrektheitsbeweis ("Nichtnegativitaet ist nach der Klemmung ein SATZ"); wt-ce-fk/libs/cache_engine/axes/lookup/composable/composed_art_trie_search.hpp:39-41
STATUS LT. QUELLE: offen (tragender Einwand; Subtraktions-Rechnung des Gattungs-Anteils rechnet falsch)
ABHAENGIGKEIT/FLAECHE: C-13.2; Posten 8/10 (Gattungs-Ebene ja/nein)

### [wo8yyv72t] 17
GEGENSTAND: TRAGENDER EINWAND (korrektheit #2): OUT-Paarung wird nie gegen site(e) geprueft; fehlt EIN OUT (Exception/early return), poppt das naechste OUT den Falschen; Befund meldet die korrekt zurueckgekehrte Funktion als offen, die abgebrochene gilt als geschlossen; Taint markiert exakt die falsche Menge. Am Objekt: abi_adapter.hpp:695,:788,:1118,:2056 catch(...) genau in den macro-instrumentierten Funktionen; throw in 11 Achsen-Headern; Spezifikation verbietet RAII ("EINE Funktion, zwei Zeilen") -- kein Schutz.
ORT: aufloesung PHASE 1 Zweig OUT: j := stapel[L].pop() ohne Site-Abgleich; wt-ce-fk/libs/cache_engine/anatomy/abi_adapter.hpp:695/:788/:1118/:2056
STATUS LT. QUELLE: offen (tragender Einwand)
ABHAENGIGKEIT/FLAECHE: Befund-/Taint-Semantik der Aufloesung

### [wo8yyv72t] 18
GEGENSTAND: TRAGENDER EINWAND (korrektheit #3): Ebenen-Sprung wird gemeldet aber nicht aufgeloest -- vorgaenger(L) liefert genau eine Ebene, Kette laeuft nicht weiter; micro unter offener compare-Spanne (ohne macro) landet als Wurzel-Spanne, Schachtelung verloren, Dauer fehlt in jeder kinder_summe. Prosa (Chain of Responsibility "bis eine aktive Ebene zustaendig ist") und Pseudocode sind nicht dasselbe Verfahren. abi_adapter.hpp:1100 benennt selbst Code "ausserhalb jedes gemessenen Fensters".
ORT: aufloesung PHASE 1: SONST WENN ein aktives k < V nicht leer: melde ckpt_ebenen_sprung -- aufrufer bleibt WURZEL
STATUS LT. QUELLE: offen (tragender Einwand)
ABHAENGIGKEIT/FLAECHE: Aufloesungs-Algorithmus (Posten 7)

### [wo8yyv72t] 19
GEGENSTAND: TRAGENDER EINWAND (korrektheit #4): Die AktivMaske hat drei unvertraegliche Bedeutungen (TU-abhaengig compile-time; laufzeit-global beim Auslesen; via dlopen/dlclose sogar ZEITABHAENGIG) und die Aufloesung braucht eine vierte; CEB (compare) und Tier-.so (macro+micro) beziehen Defines aus VERSCHIEDENEN Kanaelen; der Entwurf sagt nirgends, welche Maske der Leser nimmt; die gezeigte CMake-Naht kennt nur EINE globale Cache-Variable -- AKTIV in der CMake-Haelfte konstant 7, if-constexpr-Elision greift dort nie.
ORT: signatur (AktivMaske) vs. aufloesung EINGABE vs. cmake (A2, COMDARE_CKPT_AKTIV_MASKE); anatomy_module_loader.cpp:40/:49
STATUS LT. QUELLE: offen (tragender Einwand)
ABHAENGIGKEIT/FLAECHE: Ebenen-Flags-Kanal (Posten 10); Leser-Seite der Aufloesung

### [wo8yyv72t] 20
GEGENSTAND: TRAGENDER EINWAND (korrektheit #5): t_slot-Definition und Anfangswert kommen im Entwurf nicht vor; naheliegender Wert 0 ist ein GUELTIGER Slot -- jeder Fluss ohne Slot-Vergabe schreibt in denselben Log wie der Besitzer von Slot 0 (zwei Schreiber auf nicht-atomarem schreib_index; verschraenkte IN/OUT-Sequenzen, Phase 1 poppt quer ueber Threads). Threads entstehen auch ohne Beginn-Code: Allokator-Hintergrundthreads (alloc=Snmalloc@2), Threads aus dlopen-Modulen, Fremdpools.
ORT: signatur Sektion 5: extern constinit thread_local std::uint32_t t_slot
STATUS LT. QUELLE: offen (tragender Einwand)
ABHAENGIGKEIT/FLAECHE: Slot-Vergabe-Design; kSlotMuell-Initialisierung

### [wo8yyv72t] 21
GEGENSTAND: TRAGENDER EINWAND (korrektheit #6): Modul-Epochen-Satz bricht zweifach: (a) Loader schreibt aus EINEM Thread in ALLE Slot-Puffer waehrend deren Besitzer laufen = Mehrschreiber-Datenrennen auf nicht-atomarem schreib_index; (b) der 16-Byte-Satz hat kein Feld fuer "kein Checkpoint" -- Epochen-Satz wird von Phase 1 als normaler Eintrag gepusht/gepoppt und korrumpiert den Ebenen-Stapel.
ORT: eintrag_layout, "Modul-Epoche: ... Der Loader schreibt bei dlopen/dlclose einen EPOCHEN-SATZ in jeden Slot-Puffer"; anatomy_module_loader.cpp:40/:49
STATUS LT. QUELLE: offen (tragender Einwand)
ABHAENGIGKEIT/FLAECHE: dlopen-Regeln (Posten 5); Ein-Schreiber-Invariante

### [wo8yyv72t] 22
GEGENSTAND: TRAGENDER EINWAND (korrektheit #7): Slot-Wiederverwendung ist weder ausgeschlossen noch ausgelegt, obwohl Threads real staendig wechseln: parallel_measure_pool.hpp:58-61 legt bei JEDEM collect_ordered frischen vector<std::thread> an -- weit mehr Thread-Identitaeten als Slots je Lauf. Beide Auswege falsch: (1) keine Wiederverwendung -> ab (SLOTS+1)-tem Thread alles im Muell-Slot Kapazitaet 0 unsichtbar + Datenrennen auf ++b.verworfen; (2) Wiederverwendung -> Thread B erbt Log von A, veraltete offene Spanne wird Vater fremder Eintraege; join()-Sichtbarkeits-Begruendung fuer Wiederverwendung nicht gefuehrt.
ORT: signatur Sektion 5 (feste Slot-Tabelle, kSlotMuell Kapazitaet 0) + offene_entscheide #2; wt-ce-fk/libs/cache_engine/builder/experiment_tree/parallel_measure_pool.hpp:58-61
STATUS LT. QUELLE: offen (tragender Einwand)
ABHAENGIGKEIT/FLAECHE: Slot-Vergabe/Lebenszyklus; Ueberlauf-Zaehler-Integritaet

### [wo8yyv72t] 23
GEGENSTAND: TRAGENDER EINWAND (doktrin #1): `inline constexpr` fuer TU-abhaengige ABI-tragende Werte (kCheckpointSlots, kCkptLine) ist WOERTLICH die vom Haus verbotene Form (mess_gates_glied.hpp:39-49: TU-abhaengige Werte "duerfen NIEMALS ... Teil einer Entitaet mit EXTERNER Bindung werden ... Der Verstoss waere still (IFNDR)"); Abweichung = falsche Adressrechnung + Schreiben ausserhalb der Tabelle zur Laufzeit.
ORT: Entwurf Signatur Abschnitt 5; libs/cache_engine/include/cache_engine/abi/mess_gates_glied.hpp:39-49
STATUS LT. QUELLE: behoben in Endfassung (E-23: constexpr OHNE inline + Link-Wache extern "C" char comdare_ckpt_abi_s<N>_l<L> + g_ckpt_slots als unvollstaendiger Array-Typ; ABER Link-Wache [UNGEPRUEFT], nie gebissen)
ABHAENGIGKEIT/FLAECHE: Bissprobe der ABI-Link-Wache = Pflicht beim Bau

### [wo8yyv72t] 24
GEGENSTAND: TRAGENDER EINWAND (doktrin #2): Die neun frei erfundenen kCkptErr*-Etiketten sind exakt die Parallelstruktur, die organ_axis_error_classes.hpp:19-21 ausschliesst (Etiketten muessen aus dem EINEN bestehenden Raum stammen; axis_error.hpp:77-84 hat 4 Werte); es fehlte error_classes()-Statik, Concept, Ctor-Assert, Cross-Layer-Wache-TU, D1/D2-Realm-Zuordnung; static_assert(size()>=1) kann konstruktiv nicht feuern.
ORT: Entwurf Signatur Abschnitt 2 Fehlerklassen; libs/cache_engine/topics/organ_axis_error_classes.hpp:19-21; axis_error.hpp:77-84
STATUS LT. QUELLE: behoben in Endfassung (E-24: par. 8 neu, alle 15 Befunde auf D1 CompilerCompilerErrorClass bzw. D2 SampleStatus abgebildet, FK-5-Durchsetzung, Fehlerraum in eigener Datei checkpoint_error_classes.hpp NICHT im Hot-Path-Header)
ABHAENGIGKEIT/FLAECHE: FK-5-Muster; test_e24_c9_fk5_fehlerraum.cpp

### [wo8yyv72t] 25
GEGENSTAND: TRAGENDER EINWAND (doktrin #3): constinit thread_local uint32_t t_slot ohne Initialisierer = 0 = gueltiger Slot 0, nicht kSlotMuell; Datenrennen auf nicht-atomarem schreib_index; auch mit korrektem Default: ++b.verworfen im geteilten Muell-Slot ist nicht-atomarer Zaehler mit verlorenen Updates.
ORT: Entwurf Signatur Abschnitt 5
STATUS LT. QUELLE: behoben in Endfassung (E-14/E-25: Definition ausgeschrieben `constinit thread_local std::uint32_t t_slot = kSlotMuell;`; verworfen im Muell-Slot als std::atomic mit relaxed fetch_add; ckpt_kein_slot = harter Befund)
ABHAENGIGKEIT/FLAECHE: -

### [wo8yyv72t] 26
GEGENSTAND: TRAGENDER EINWAND (doktrin #4): Der ganze Thread-Nummer-Teil (Slot-Vergabe/-Freigabe/Obergrenzen-Pruefung) war NICHT ausgearbeitet, obwohl der Owner ihn als "der neueste Schub, hier besonders sorgfaeltig ausarbeiten" bezeichnete; CEB faehrt Faden-Pool ueber Permutationen (cache_engine_builder_iterator.hpp:2656-2657) -- ohne Slot-Lebenszyklus liegen zwei Fluesse hintereinander in EINEM append-Puffer, LIFO paart quer.
ORT: Entwurf Signatur Abschnitt 5; libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:2656-2657
STATUS LT. QUELLE: behoben in Endfassung (E-16/E-26: eigener par. 5 mit SlotHalter RAII, Freiliste ueber atomares Bitfeld, META-Trennsatz mit global monotoner Abschnittsnummer, Versiegelung auf schreibendem Kern, Erschoepfung -> ckpt_slot_ueberzaehlig; Log-Identitaet = (slot, abschnitt); Eindeutigkeits-Beweis gefuehrt)
ABHAENGIGKEIT/FLAECHE: blockiert durch Offene Entscheide 2+3 (Slot-Zahl-Quelle, gemeinsame Bibliothek)

### [wo8yyv72t] 27
GEGENSTAND: TRAGENDER EINWAND (doktrin #5): site_id ueber Modulgrenzen nicht eindeutig (CMake-Basis je Ziel ab 0; perm_mess_defines je PERMUTATION nicht je TU; 1 DLL = 1 TU laut BUILD-MODELL-1DLL-1TU-KLARSTELLUNG.md -- alle Tier-Binaries vergeben dieselben site_ids; 16-Byte-Satz hat kein Modul-Feld).
ORT: Entwurf cmake (B)/(C); docs/architecture/BUILD-MODELL-1DLL-1TU-KLARSTELLUNG.md:15; anatomy_module_loader.cpp:40/:49
STATUS LT. QUELLE: behoben in Endfassung (E-27/E-18: stelle zerfaellt in modul:12 | lokal:15 = 4096 Module je Lauf, 32768 Aufrufstellen je TU; CEB vergibt Modul-ID je Permutation als Teil von COMDARE_CKPT_TU_BASIS via .rsp; ckpt_modul_raum_erschoepft als D1-Befund)
ABHAENGIGKEIT/FLAECHE: CEB-.rsp-Schreibweg

### [wo8yyv72t] 28
GEGENSTAND: ENDFASSUNG -- die vier schwersten Aenderungen gegenueber dem Entwurf: (A) Uhr wird Strategie je Ebene (roh/geordnet/keine) aus CMake; (B) NormalAblage statt StromAblage als Vorgabe (NT-Befund reproduziert nicht); (C) rest=spanne-kinder_summe wird Pruefsatz mit zwei Elternfeldern (eltern_ebene fuer Spezifikations-Spalte, eltern_direkt fuer Arithmetik) + Fehlerklasse ckpt_rest_negativ; (D) Slot-Vergabe ausgearbeitet (par. 5).
ORT: Endfassung (96908 Z.), Status "Spezifikation ausgearbeitet, gegen drei Skeptiker-Durchgaenge gehaertet, NOCH NICHT GEBAUT"; supersedet ce docs/architecture/20260808-checkpoint_measure_soll_design.md
SOLL/FIX: Endfassung ist das zu landende Design-Dokument; Hot-Path-Header ohne axis_error.hpp/topics-Kante; Ebenen-Nummerierung mit Luecken (Compare=0, Macro=2, Micro=4, Wert 3 fuer Gattung reserviert, Feldbreite 3 Bit); Eintrag 16 Byte, stelle modul:12|lokal:15; Kapazitaets- UND Bandbreiten-Rechnung als Pflichtposten fuer --check-size (608 Byte je Interface-Aufruf; bei Owner-Batch 4096: 2,38 MiB je Thread).
STATUS LT. QUELLE: Design fertig, NICHT gebaut
ABHAENGIGKEIT/FLAECHE: --check-size (Quelle wb8p02wqu); Ledger C-1..C-13, N-1..N-7

### [wo8yyv72t] 29
GEGENSTAND: ENDFASSUNG par. 11 -- ZWOELF OFFENE ENTSCHEIDE FUER DEN OWNER (drei des Entwurfs durch Skepsis entschieden: NT-Store -> NormalAblage; Ueberlauf -> juengste verwerfen; Puffer-Ausrichtung -> Testat beim Einhaengen).
ORT: Endfassung par. 11
SOLL/FIX: (1) ZEITQUELLE JE EBENE: Vorgabe spezifikationstreu (Uhr ueberall); empfohlene Fassung falls Owner freigibt: "compare + macro = GeordneteZeit, micro = KeineZeit"; Abweichung von der Spezifikation ("die Systemzeit") waere Regression, daher Vorlage. (2) CT-Obergrenze der Thread-Slots EXISTIERT HEUTE NICHT (axis_08:85 Laufzeit-Klemme auf 64; grep kMaxThread|MAX_THREADS|max_threads ueber libs/ = 0 Treffer) -- BLOCKIERT DEN BAU VON par. 5. (3) Existiert eine gemeinsame beim Start gelinkte Bibliothek? [UNGEPRUEFT] -- ohne sie bricht der Lauf ab der siebten Tier-Binary; dlmopen nicht erhoben. (4) Prozess-Ende ohne Auslesen: Mechanismus fuer ckpt_nie_ausgelesen nicht entschieden (atexit-Haken kollidiert mit Versiegelung am Faden-Ende). (5) Ist die Maske identitaets-wirksam (COMDARE_CKPT_TU_BASIS/_EBENE/_AKTIV/_UHR/_UHR_GEORDNET ins Fingerprint-Preimage)? beruehrt anatomy_fingerprint.hpp, Owner-KERN F6 Injektivitaet. (6) Abweichung von "EIN prozessweiter Log" (N Slot-Logs, Gesamtordnung offline) = vorlagepflichtig; Faktor 69 dafuer, 70,2 Prozent gesetzte (nicht gemessene) Ordnung dagegen; Zaehler-only-Variante NIE gemessen -- falls Owner echte prozessweite Ordnung will, ist DIESE Messung die erste Aufgabe. (7) WIDERSPRUCH Messort macro (Ledger:7781 "CEB-seitig" vs. Code: in Tier-Binary einkompiliert) -- Loesung traegt in beiden Faellen, Frage bleibt. (8) Owner-Musterzuordnung "Thread = Visitor ueber die Mess-Ebenen" nicht eingeloest [UNGEPRUEFT]. (9) "Sechs CEB-Varianten" aus dem Code nicht herleitbar (3 Toolings = 7 nichtleere Teilmengen; heute EINE combo [all]). (10) GeordneteZeit auf ARM (isb;mrs cntvct_el0) und RISC-V (fence;rdtime) UNGEPRUEFT; aktuelle Fassung faellt still auf RohZeit zurueck -- ausdruecklich benannte stille Luecke. (11) Overhead-Nachweis via CEB-Differenz bleibt blockiert bis G3 aus dem STATISTICS-Gate geloest ist. (12) InMemoryMeasurementBuffer verletzt R2/R3 frontal (in_memory_measurement_buffer.hpp:77-85: lock_guard + map-Lookup je Aufruf, push_back) -- Kommentar oder Deprecation zu entscheiden (Doku-Doktrin: nie loeschen, deprecaten).
STATUS LT. QUELLE: offen (Owner-Vorlage)
ABHAENGIGKEIT/FLAECHE: Entscheide 2+3 blockieren par. 5 (Kern der Thread-Nummer) -- einzige Bau-Blocker laut par. 13

### [wo8yyv72t] 30
GEGENSTAND: ENDFASSUNG par. 13 -- Liste der 9 ungeprueften Punkte dieser Fassung.
ORT: Endfassung par. 13
SOLL/FIX: (1) ABI-Link-Wache (par. 2.3) als Mechanismus nicht gebissen. (2) Existenz gemeinsamer beim Start gelinkter Mess-Bibliothek. (3) dlmopen-Verwendung. (4) ARM/RISC-V vollstaendig (Zeitquelle, Ordnungsform, Cache-Line, Ablage). (5) Wiedereintritt macro-in-micro im Bestand (E-21). (6) Zaehler-only-Variante eines prozessweiten Logs. (7) besuche(EbeneTag<L>)-Kontext ohne Hot-Path-Instruktion. (8) stroemende Auswertung mit beschraenktem Fenster (Auswerte-Speicher heute O(n)). (9) NT-Grundbefund bis Neuerhebung nicht nachvollziehbar. Schlusssatz verbatim: "Nichts davon blockiert das Schreiben des Codes ausser Punkt 2 und offener Entscheid 2 (die Slot-Zahl). Diese beiden blockieren par. 5 und damit den Kern der Thread-Nummer."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Bau-Freigabe checkpoint_measure haengt an Entscheid 2 (Slot-Zahl-Quelle) und Bibliotheks-Frage

### [wo8yyv72t] 31
GEGENSTAND: ENDFASSUNG par. 12 -- Disposition aller 34 Einwaende (16 tragend eingearbeitet/widerlegt, 12 wichtige, 6 Randnotizen); jede Zeile nennt die Korrektur (Details siehe Posten 12-27); zusaetzlich E-12 (vorgaenger_offen() laeuft absteigend ueber alle praesenten k < L, WURZEL nur wenn wirklich keine hoehere Ebene offen), E-13 (COMDARE_CKPT_AKTIV pro TU nur fuer if-constexpr-Elision; EbenenPraesenz beim Auslesen aus geernteter Deskriptor-Sektion je Modul, kein Define; CMake-Naht setzt per Ziel comdare_ckpt_ziel(...)), E-15 (Loader bekommt EIGENEN Slot; tag waechst auf 2 Bit mit META; Phase 1 nicht-stapelwirksamer Meta-Zweig), E-11 (Paarungswache site(e) gegen site(spitze), ckpt_paar_bruch, Abwicklung bis passende site), E-17 (unbekannte Ziele brechen Uebersetzung mit #error statt still zu nullen; Ankerprobe verwirft bei identischen Ankern), E-29 (COMDARE_CKPT_LINE bekommt #error statt stillem Default 64).
ORT: Endfassung par. 12
STATUS LT. QUELLE: eingearbeitet (im Design; nichts gebaut)
ABHAENGIGKEIT/FLAECHE: -

# QUELLE 2: w50k74cln.json (Audit Lead-Arbeit 08.08. gegen ARBEITSWEISE-GESAMT-DOKTRIN.md v3, 8 Agenten, 1.281.081 Tokens)

Kontext: 136 Regeln erfasst, 100 geprueft; Urteile: 35 verletzt, 17 teilweise, 40 eingehalten, 6 n/a, 2 nicht pruefbar; auf eindeutige Regeln ~28 verletzte (52 = Urteils-, nicht Regelzahl). Pruefgegenstand: /home/comdare/wt-super-landung/docs/ARBEITSWEISE-GESAMT-DOKTRIN.md (400 Z., v3 vom 06.08.). Gesamturteil verbatim: "jede einzelne Verifikation, die der Lead heute geleistet hat, kam nach der Aussage statt davor."

### [w50k74cln] 1
GEGENSTAND: DUAL-REVIEW-Pflicht (A2, Owner 05.08.) verletzt: 0 Codex-Aufrufe am 08.08., kein Review-Agent unter 14 Agent-Starts; KEINE der 19 Landungen sah einen Lens (ce eb96b76a ca3c5d8b cc028e1d 2f8aba58 dbf91657; super f507a9af a64cda17 48c5c37d 3326ac7a f94345c8 c0aaa3bf 60dbf9dc ea30605a 743b93da 54701890 51c59d9e 56ffab37 a9a0754c e7e86963).
ORT: Lead-Transkript 5a19728e-f6e1-4736-a246-e3fda9ac35a1.jsonl; betroffene SHAs oben
SOLL/FIX: M2: Klassentabelle in B.3 (Code/Skript/CMake/CI -> zwei Lenses Pflicht; .md/Ledger -> kein Lens; Gitlink-Bump -> M1 statt Lens) + Vor-Push-Wache verlangt .review-beleg mit zwei Lens-IDs fuer jeden Push mit Nicht-.md-Dateien, sonst exit 1; plus L5 (Klassentabelle in A2, Owner-Freigabe noetig).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: L5-Doktrin-Aenderung braucht Owner-Freigabe; scripts/vor_push_alle_wachen.sh

### [w50k74cln] 2
GEGENSTAND: Landekette Glied 2 verletzt -- Gitlink-Bump 51c59d9e wurde 31 Sekunden nach ce-Push ca3c5d8b gepusht, ce-Pipeline #15300 lief noch und wurde NIE abgefragt; Ergebnis: super #15301 failed (Jobs integration:smoke, test:unit, visibility:tier-binaries, analyse:thesis-data, build:clang; Trace: "Cyclic dependencies are allowed only among static libraries. CMake Generate step failed."); super/development 11:52-12:35 rot; wirksamster Einzelbefund des Tages.
ORT: super 51c59d9e; ce ca3c5d8b; GitLab #15300/#15301/#15306/#15312
SOLL/FIX: M1: scripts/gitlink_bump_gate.sh -- verweigert Gitlink-Bump solange nicht (a) Pipeline der Kind-SHA status=success, (b) merge-base --is-ancestor <alt> <neu> rc=0, (c) Jobliste enthaelt build:clang=success; sonst exit 1; eingehaengt in vor_push_alle_wachen.sh (super), greift sobald Diff Code/external/comdare-cache-engine beruehrt; Koeder: Bump auf SHA mit running-Pipeline muss rot melden.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Zwei-Gate-Modell B.3 Z348 (zweites Gate = super-Sub-Build wurde nie gefahren; Defekt nur im Umbrella-Bau sichtbar)

### [w50k74cln] 3
GEGENSTAND: main-FF (Landekette Glied 3) fehlt vollstaendig: 0 von 19 Landungen sind Vorfahren von origin/main; Rueckstand ce 84, super 93 Commits; origin/main-Spitzen ce 85847715 (07.08.), super 5ed70229 (07.08.); mindestens vier als abgeschlossen+CI-gruen gemeldete Pakete main-faellig (Task #57/dbf91657, #62/8d5ba807, #53/61730ff4, #54/eb96b76a).
ORT: beide Repos, origin/main vs. origin/development
SOLL/FIX: L6 (Owner-Freigabe): "main-FF wird faellig, sobald ein Paket als abgeschlossen gemeldet ist (Owner-Meldung, Ledger-Abschluss oder gruene Zweit-Repo-Pipeline). Zwischen Paketen ist dev voraus der Normalzustand."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Gitflow-Doktrin (dev voraus = Normalzustand) -- Abgrenzungskriterium fehlte im Dokument; DIFF-HYGIENE-Wache vor jedem main-FF (Memory)

### [w50k74cln] 4
GEGENSTAND: R4 (kein Push waehrend abhaengiger Pipeline, seriell je Ref) mehrfach verletzt: 37-49 Ref-Updates am Tag, 16 Paare unter 5 min Abstand, vier unter 90 s; zwei rote Pipelines (#15294, #15306) entstanden und wurden erst nach weiteren Pushes bemerkt; nach rotem #15294 wurde 2 min spaeter erneut gepusht, nach rotem #15301 dreimal weiter.
ORT: super/development reflog; .gitlab-ci.yml Z23 (jeder Branch-Push erzeugt Pipeline)
SOLL/FIX: M7: Push-Wrapper fragt letzte Pipeline des Ziel-Refs ab, verweigert bei status in (created,pending,running); zusaetzlich flock je Repo (eine Landung je Repo); L9: R4-Auslegung ("seriell je Ref; dev+main-Wellen desselben geprueften SHA parallel zulaessig") aus dem Ledger nach A3 ziehen mit Klarstellung, dass mehrere Pushes auf DENSELBEN Ref nicht gedeckt sind (Owner-Freigabe).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: A1-Bahn-Obergrenze (6 Schreib-Bahnen gleichzeitig auf ce/development, 31 ce-dev-Commits an einem Tag, fehlgeschlagener Push 12:33:59, 7 Merge-Vorlauf-Commits)

### [w50k74cln] 5
GEGENSTAND: gitleaks-Pflichten mehrfach verletzt: (a) 27 von 37 Pushes ohne gitleaks; (b) Worktree-Mount-Vakuum-Gruen am Objekt eingetreten (11:42:25: "0 commits scanned ... no leaks found", Push 48c5c37d ging 95 s spaeter raus); (c) Push-INHALT-Scan (git log -p <remote>..HEAD) 0 von 49 Pushes; (d) rc=$? nach Pipe mass tail statt gitleaks (RC_GITLEAKS=0 trotz "FTL unknown shorthand flag: C"); (e) --depth 3 statt Bereich = Zufalls-Deckung. Kontext: am selben Tag Vault-PAT in curlrc geschrieben + Infra-Handout "Vault-Klartextwert ins Transkript geraten, Rotation faellig" (super 30458580).
ORT: Lead-Transkript 11:42-13:26; betroffener Push 48c5c37d
SOLL/FIX: M5: scripts/gitleaks_vor_push.sh -- (a) frischer Klon nie Worktree-Mount, (b) Bereich per merge-base bestimmen, (c) BEIDE Scans (Repo + git log -p <remote>..HEAD), (d) Zusicherung N commits scanned == Commits im Bereich, Abbruch bei N==0 oder N != Bereich, (e) jede Pipe-Stufe ueber PIPESTATUS; fest in vor_push_alle_wachen.sh; Koeder: synthetisches Secret + Worktree-Pfad muss mit "Worktree, kein Klon" abbrechen. L10 (Owner-Freigabe): "Der Lauf ist erst gueltig, wenn die Zahl gescannter Commits der Zahl der Commits im gemessenen Bereich entspricht. --depth ist keine Bereichsangabe."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: K11-Register (rc nach Pipe); gitleaks-Koeder-Regel (Memory: Koeder muss aus einer Regel der Config stammen)

### [w50k74cln] 6
GEGENSTAND: rescue-Refs auf BEIDE Remotes vor Landung: 0 rescue-Refs fuer 19 Landungen auf 0 von 4 Remote-Endpunkten; Bestandsluecke: super refs/rescue/w1-super-einheit2-5714f94b existiert auf origin, fehlt auf github (4 vs. 3).
ORT: ls-remote origin/github beider Repos, refs/rescue/*
SOLL/FIX: M8: Push-Wrapper pusht IMMER zusaetzlich refs/rescue/<paket>-<sha> auf BEIDE Remotes vor dem eigentlichen Push; Koeder: ls-remote muss neuen Ref auf beiden Endpunkten zeigen.
STATUS LT. QUELLE: offen (inkl. bestehender Paritaets-Luecke w1-super-einheit2-5714f94b)
ABHAENGIGKEIT/FLAECHE: Dual-Remote-Doktrin

### [w50k74cln] 7
GEGENSTAND: SSOT-Ledger-Nachtraege RUECKWAERTS verletzt: alle 7 Ledger-Landungen des Tages per cat >> am DATEIENDE (Hunk-Koepfe @@ -11395 .. -11965; Datei 12002 Zeilen bei 54701890).
ORT: super docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md; SHAs 3326ac7a f94345c8 c0aaa3bf 60dbf9dc ea30605a 743b93da 54701890
SOLL/FIX: M10: scripts/ledger_nachtrag.sh fuegt NACH DEM KOPF ein statt cat >>; Wache: Ledger-Diff mit Hunk-Kopf jenseits Zeile 200 -> rot; L8 (B.3-Praezisierung, KEINE Owner-Freigabe noetig da additiv): "Nachtraege werden per scripts/ledger_nachtrag.sh nach dem Kopf eingefuegt; cat >> auf den Ledger ist verboten."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Anlass des Audits (Nichtfinden aktueller Staende)

### [w50k74cln] 8
GEGENSTAND: V1 (Agenten-Zahl = Behauptung) verletzt: Commit e7e86963 behauptet "Beide verifiziert, 432/432 ctest, Wachen gruen" ohne eigenen ctest-Lauf ueber 61730ff4; erste eigene Pruefung 33 min NACH Landung ergab dritte unabgeglichene Zahl (303 Registrierungstreffer); Marker "aus Bericht, nicht nachgemessen" fehlte in allen eigenen Owner-Meldungen des Tages (0x gesetzt); Gegenfall f556619c (Weitergabe ungeprueft, Messung danach) und Positivfall 01aee9b9 (fing 2 von 3 falschen Agenten-Befunden).
ORT: ce e7e86963 (Commit-Text, dauerhaft in Historie); super f556619c, 01aee9b9
SOLL/FIX: M9: commit-msg-Wache verweigert Nachrichten mit Testzahl-Muster (\d+/\d+) oder "verifiziert" ohne "gemessen: <kommando>" ODER "aus Bericht, nicht nachgemessen"; .git/hooks/commit-msg beide Worktrees, mitversioniert scripts/hooks/; Koeder: e7e86963-Text nachstellen -> abgelehnt. Plus L7 neue Regel V11 Belegzeile (Owner-Freigabe): "Jeder Zustandssatz ... traegt die Kommandoausgabe ... im selben Block ... Eine Messung, die nach der Aussage erfolgt, ist eine Korrektur, kein Beleg."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: 432-vs-428-vs-303-Diskrepanz ungeklaert

### [w50k74cln] 9
GEGENSTAND: "gruen" gemeldet bevor Jobliste gelesen (V6.6): Pipeline 15314 als Beweis der Zyklus-Heilung gemeldet, dabei 3 Jobs, build:clang NICHT GELAUFEN (docs-only); Wiederholung sofort bei 15317; ausserdem "beide Repos gruen" gemeldet waehrend ce-Pipeline 15315 noch running (kein Erfolgs-Endstatus im Transkript).
ORT: Transkript Z18584/18592/18625; Pipelines 15314/15315/15317 vs. 15312 (14 Jobs, build:clang success)
SOLL/FIX: M6: scripts/pipeline_urteil.sh <projekt> <sha> druckt "N Jobs, davon success/failed/skipped/manual; tragende Jobs: build:clang=<status>, test:unit=<status>", rc!=0 sobald tragender Job nicht success; Sprachregel: das Wort "gruen" nur mit dieser Ausgabe darunter; Koeder: #15314 -> rot (3 Jobs), #15312 -> gruen (14 Jobs).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Memory "EIN GRUENES GATE deckt nur seinen Gegenstand"

### [w50k74cln] 10
GEGENSTAND: Sequenz Gedaechtnis->Review->Explore verletzt: Agents Stale-Mechanik (13:15:20) und Doktrin-Historie (13:16:08) gestartet VOR der Gedaechtnis-Abfrage (13:16:58); Doktrin-Historie FRAGE 1 war vollstaendig in feedback_messdaten_nie_loeschen_abi_darf_brechen.md beantwortet (cowfix-v1, 120.960 Zeilen, Owner "Um gottes willen nein", 19.06.; punktuelle Aufhebung User 21.07., Ledger par. 62); Owner-Auftrag "lies bitte memory" lag 5h51m zurueck.
ORT: Lead-Transkript; memory/feedback_messdaten_nie_loeschen_abi_darf_brechen.md
SOLL/FIX: M3: (a) Pflichtfeld GEDAECHTNIS-BEFUND: in jedem Agenten-/Workflow-Start mit memory/<datei>:<zeile> ODER woertlich "GEDAECHTNIS GEPRUEFT, KEIN TREFFER: <suchmuster>"; (b) scripts/gedaechtnis_grep.sh <thema> durchsucht in EINEM Aufruf MEMORY-Index + memory/*.md + Ledger + letzte 5 Session-Dokumente; Positiv-Kontrolle vor jedem Einsatz. Plus L1 (Owner-Freigabe): neuer Abschnitt A2.0 REIHENFOLGE; L2 (Owner-Freigabe): V2.1(a)-Korrektur "Der Ledger-/Planungsstand ist VOR dem Auftrag vom Lead zu erheben und dem Agenten als Befund mitzugeben".
STATUS LT. QUELLE: offen; Audit-Feststellung: "Der Anlassfall ist zur Haelfte eine Vertragsluecke" (Sequenz steht NICHT in der Doktrin; V2.1(a) schreibt das Gegenteil vor)
ABHAENGIGKEIT/FLAECHE: Doktrin-Aenderungen L1/L2 = Owner-Freigabe

### [w50k74cln] 11
GEGENSTAND: Modell-Matrix-Verletzungen: (a) Workflow-Kanal: 114 von 114 Workflow-Agenten auf claude-opus-5, kein einziger Sonnet-Explore; 4 von 6 Skripten ohne model:, 97 von 114 Agenten allein ueber defaultModel besetzt; "very thorough" 0x in Workflow-Skripten; (b) zwei ausdrueckliche Bau-Auftraege auf Sonnet (SF1-bau -> ce f09751f4; A9-S3-xlsx-writer -> ce 60e03d66/61730ff4, vererbte Fehlbesetzung an 4 Unter-Agenten); (c) 4 von 14 Top-Level-Starts ohne model-Feld; (d) effort in Synthese-/Urteils-Phasen 'high' statt 'max'; (e) Owner bekam "Fable 5 xhigh" bestaetigt, real lief Opus (wf_38e6beaa-71e defaultModel claude-opus-5) -- Widerspruch zur 06.08.-Ansage nie benannt.
ORT: Workflow-Skripte wf_*.json; Agent-Aufruf-JSONs
SOLL/FIX: M4: docs/vorlagen/ultracode-workflow.js mit Selbstcheck am Skriptkopf (Explore-Muster ohne model:'sonnet'+effort:'max'+'very thorough' -> Abbruch; Bau-Muster ohne model:'opus'+effort:'xhigh' -> Abbruch; defaultModel auf ungueltigen Wert). M12(b): "Jede Abweichung von einer Owner-Formulierung wird im selben Satz benannt". Plus L3 (Owner-Freigabe): effort nur ueber Workflow-Tool setzbar -- Top-Level-Agent-Start auf Erhebungen ohne Effort-Anforderung beschraenken; L4 (Owner-Freigabe): defaultModel darf keinen gueltigen Arbeitswert tragen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: HINWEIS AUF STALE-STAND: Memory 12.08./13.08. ordnet inzwischen FABLE 5 MAX ueberall an -- Modell-Matrix-Details dieses Audits (08.08.) sind durch Owner-Order ueberholt, die MECHANISMEN (M4, L3, L4) bleiben gueltig
ABHAENGIGKEIT/FLAECHE 2: Audit konnte effort der 14 Top-Level-Agenten NICHT messen (Agent-Werkzeug kennt kein effort-Feld)

### [w50k74cln] 12
GEGENSTAND: Weitere Einzelverstoesse: (a) fremde Worktrees geraeumt (git clean -xfd auf wt-b14-golden, wt-landung, wt-lb6, wt-b-r4-ci, wt-ce-basis-gegenprobe, wt-b-honest-empty) ohne vorheriges status+log+Meldung (Reihenfolge invertiert, log --oneline -1 kam nie vor); (b) Lead-Selbst-Edit einer Gate-Praedikat-Aenderung (2f8aba58 vor_push_alle_wachen.sh 23+/3-) statt Agent; (c) Vorwaerts-Beweis ae1eee49 gegen falschen Ausgangs-SHA gefuehrt (alter Gitlink war 15522cdc, nicht b000ccc6 -- Messung korrekt, falsche Frage; 15522cdc war Spitze des Fremd-Worktrees wt-ce-s2 bau/a1-m64-medien-basis); (d) V6.5: 428/428 nicht gegen definierten Bau-Zustand verankert; (e) V7.3: Zwei-Block-Beleg (Bestand gruen unter Mutation) fuer cppcheck-Biss nicht gefuehrt; (f) V5: falsche Ausschlussliste an Agent (Ursache rc=$? nach Pipe); (g) A2: Klassifikation an Explore-Agent delegiert (Stale-Mechanik: "Bevor ich Rueckfragen stelle, muss ich WISSEN, was daran haengt. Das ist dein Auftrag."); (h) Breadth statt Tiefe: 9 Workflows + 14 Agenten auf disjunkten Themen, nur 1 von 9 Workflows auf dem fristkritischen Pfad (Task #63 A9-S4 = Engpass zur Auswertung).
ORT: div. (siehe Einzelbelege im Audit)
SOLL/FIX: M11: scripts/worktree_fremd.sh <pfad> (druckt status --porcelain, log --oneline -1, Branch, mtime des Eigentuemer-Transkripts, beendet sich; Aenderung = zweiter expliziter Aufruf; nacktes git -C <fremd> clean verboten). M12(a): jeder Workflow-Start traegt PFAD: kritisch|nebenstrang + Task-Nummer.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Worktree-Doktrin; Frist F1/15.09.

### [w50k74cln] 13
GEGENSTAND: Offener Posten der Erhebung selbst: Push-Nenner ungeklaert (eine Linse 37 Ref-Updates, andere 49 = 37 super + 12 ce); naechste Handlung benannt: git -C <repo> reflog show origin/development --date=iso | /usr/bin/grep 2026-08-08 | wc -l je Repo in einem Lauf; fehlt = einheitliche Push-Definition (Ref-Update vs. Kommandoaufruf). Ausserdem NICHT nachgemessen: bekannte Tagesfehler 7 ("melden statt bauen"-Klausel, vom Owner gestrichen) und 8 (Workflow trotz "warte erst") -- beide pruefbar (Klauseltext gegen A/V-Pflicht; Zeitstempel Owner-Nachricht gegen Workflow-Start).
ORT: Audit-Abschnitt Erhebung
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [w50k74cln] 14
GEGENSTAND: Gegenmassnahmen-Katalog M1-M12 mit Umsetzungs-Reihenfolge und Doktrin-Luecken L1-L10 (8 davon Owner-Freigabe-pflichtig, L8 additiv ohne Freigabe).
ORT: Audit Abschnitte 5+6
SOLL/FIX: Reihenfolge der Umsetzung verbatim: "M1 -> M6 -> M5 -> M2 -> M3 -> M7/M8 -> Rest. M1 und M6 zusammen verhindern beide Schadensfaelle des Tages (A1 und A3) und kosten zusammen zwei kleine Skripte." Auslegungsprinzip verbatim: "jede Massnahme muss vergessbar sein, ohne dass es schiefgeht." Jede neue Wache braucht nach V7.1 einen eigenen Biss (Koeder-Spalte je M). Schlussbefund verbatim: "Die vier Fehler 2, 4, 5, 6 sind keine neuen Fehler, sondern Wiederholungen bereits kodifizierter Klassen ... nicht fehlendes Wissen, sondern eine Doktrin, die erst nach der Handlung gelesen wird."
STATUS LT. QUELLE: offen (Massnahmen vorgeschlagen, nichts gebaut)
ABHAENGIGKEIT/FLAECHE: L1-L7, L9, L10 = Owner-Freigabe; M1/M2/M5/M6/M9/M10-Wachen = Bau-Kandidaten fuer Komplex-Fix

# QUELLE 3: wssynj4q3.json (Gesamt-Dossier Owner-Fragen/-Antworten, Stand 08.08. 07:30; 6 Agenten, 702.597 Tokens)

Kontext: 4 Quellen, 360 Owner-Nachrichten (331 im Dossier-Korpus aus 18 Kontext-Fenstern), 58 Lead-Fragen (7 unbeantwortet), 79 Paare, 11 offen, 14 doppelt gestellt, 33 Direktiven. Dossier 72379 Z.

### [wssynj4q3] 1
GEGENSTAND: OFFEN 5.1: D-2 BAU-MENGE -- haerteste offene Frage (Task #21): fuenf konkurrierende Zahlen 524.288 / 1.572.864 / 2.097.152 / cap-131.072 / 917.504 (statische tier-Ebene); dreimal gestellt (06.08. 19:35, 07.08. 07:27, 07.08. 17:58), NIE beantwortet (Owner beantwortete D-1, B-4, D-3, O-C -- D-2 fiel durch). D-3-Antwort ("Wir bauen nur die 320er die wir auch tatsaechlch messen") BEGRENZT die Menge, beziffert sie nicht.
ORT: Dossier 5.1; Task #21
STATUS LT. QUELLE: offen (Owner-Frage)
ABHAENGIGKEIT/FLAECHE: golden-XML-Umfang, Batch-Planung 4096, Zeitbudget bis 15.09.; gekoppelt an 5.2 (Faktor 7)

### [wssynj4q3] 2
GEGENSTAND: OFFEN 5.2: Welcher Baum-Pfad gilt fuer den Voll-Bau -- build_axis_levels (mit tier-Ebene, Faktor 7) oder build_profile_basis_levels (ohne, wie 320er-Lauf)? Owner 08.08. 07:17: "Bitte mit mehr Kontext fragen"; Lead lieferte Kontext 07:23; Antwort steht aus.
ORT: Dossier 5.2
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: D-2 (5.1)

### [wssynj4q3] 3
GEGENSTAND: OFFEN 5.3: Paper-Kopplung bauen? (Task #49) -- Lead 08.08. 07:03: "Die ehrliche Zahl ist heute 0, nicht 132 ... Soll ich ihn bauen? Das waere ein eigenes Paket." Owner-Antwort behandelte stattdessen die LaTeX-Anlage; Owner-Aussage 07.08. 18:17 beschreibt Sollzustand, gibt KEIN Bau-GO.
ORT: Dossier 5.3; Task #49
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: XML-Achsen haengen von Paper-Algorithmen ab (Owner 07.08. 18:17)

### [wssynj4q3] 4
GEGENSTAND: OFFEN 5.4: Sperrvermerk vs. LGPL-Repo-Text (A03/michael_lockfree, Task #42) -- LGPL-Code wird nicht gelinkt, liegt aber als Repo-Text im Baum, per git clone erreichbar; Owner zweimal "Bitte mehr Kontext"; Lead hat Kontext nie in geforderter Form nachgeliefert. NICHT zu verwechseln mit "F3: Bitte korrigiere die Lizenz wie beschrieben" (eigene Lizenzdatei).
ORT: Dossier 5.4; Task #42
STATUS LT. QUELLE: offen (Bringschuld Lead)
ABHAENGIGKEIT/FLAECHE: Lizenz-Paket (ce bau/p6-lizenz-umsetzung landereif -- Abgleich noetig ob A03-Frage dort behandelt)

### [wssynj4q3] 5
GEGENSTAND: OFFEN 5.5: ZWEI OFFENE OWNER-FRAGEN AN DEN LEAD: (a) "Was meinst du mit mehrelementige Front?" (07.08. 12:19) -- nie beantwortet; abhaengig: wird bei mehrelementiger Pareto-Front weiterhin EIN Artefakt versandt (Versand-Vertrag, PRT-ART-Konsumption)? (b) "(das ist doch jetzt unter der Container Gattung oder???)" (07.08. 06:57, flat_hash_map) -- nie beantwortet. Dossier: "die peinlichste Kategorie: nicht der Owner schuldet die Antwort, sondern der Lead."
ORT: Dossier 5.5
STATUS LT. QUELLE: offen (Lead schuldet Antwort)
ABHAENGIGKEIT/FLAECHE: Versand-Vertrag; flat_hash_map-Einordnung (Memory: Gattung-Map, nicht Container)

### [wssynj4q3] 6
GEGENSTAND: OFFEN 5.6: O-D Break-Even-Schwellen compile-time oder runtime? Gestellt 07.08. 09:07, in keiner der beiden folgenden Owner-Antworten adressiert -- "die einzige Frage der Runde, die durchfiel, ohne dass es auffiel". "Break even lebt nur in der CEB ... im RAM" fiel VOR der Frage und beantwortet die Compile-Time-Variante nicht, insbesondere nicht im Verhaeltnis zur Hybrid-Organ-Achse (Heuristik "zu beginn der Messung (initialisierung) am Pruefdock" uebermittelt).
ORT: Dossier 5.6
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Hybrid-Organ-Achse; CEB-Auswertung

### [wssynj4q3] 7
GEGENSTAND: OFFEN 5.7: Welle D (Cluster) drei Unterpunkte ohne Setzung: (a) k-Wahl-Konsens (Gap braucht Zufalls-Referenz UND Seed, BIC eine GMM-Variante), (b) Linkage-Kriterium (Plan sagt nur "agglomerativ"), (c) Noise-Schwellwert der Online-Zuordnung. Owner: "Noise ist geplant, Explore bitte. Nochmal mit mehr Kontext fragen." -- beides nie nachgeholt.
ORT: Dossier 5.7
STATUS LT. QUELLE: offen (Bringschuld Lead: Kontext + Explore)
ABHAENGIGKEIT/FLAECHE: Welle D Auswertung

### [wssynj4q3] 8
GEGENSTAND: OFFEN 5.8: Bruecke CSV-Spalte -> Katalog-Zielgroessen-ID "existiert nirgends"; Owner antwortete nur zum Whitelisting-Prinzip, nicht zur Bruecke. Quelle bricht an der Stelle ab -- vor Owner-Nachfrage ist der Rest des Extrakts zu heben.
ORT: Dossier 5.8 + Unsicherheit 1.6
STATUS LT. QUELLE: offen (mit benannter Rest-Unsicherheit)
ABHAENGIGKEIT/FLAECHE: WIDE-Schema; XML-Whitelisting

### [wssynj4q3] 9
GEGENSTAND: OFFEN 5.9/5.10: Runde 07.08. 17:58 Q1/Q2/Q3/Q5 ohne Antwort (Q2 = Bau-Menge); ferner 5 UNKLARE (kein hartes offen): B-Block E-5/E-6/E-7/E-10 (01.08., "gilt bei Nicht-Widerspruch"), Q8-Pflichtmeldung OS-U3 (02.08.), CX-W2-Wire-Bump (OV-2D-1), die 11 Owner-Vorlagen vom 03.08. (per Explore zu pruefen; V3/E-24 und 6 von 8 V4-Punkten gedeckt), Prioritaeten-Reihenfolge 06.08. AUFGELOEST entgegen Roh-Extrakt: Runde 07.08. 01:10 (F-01 Talos, F-02 flat_hash_map) IST beantwortet (06.57:10).
ORT: Dossier 5.9/5.10
STATUS LT. QUELLE: offen bzw. unklar
ABHAENGIGKEIT/FLAECHE: -

### [wssynj4q3] 10
GEGENSTAND: OFFEN (aus offen-Liste item 7): Der weite NFS-Export -- Buildsystem-Export steht auf `*` statt `10.0.20.0/24`, damit auch fuer V60-Runner erreichbar; Isolationsbegruendung des measure-drop-Filterpods greift dort nicht. Lead: "Ob der weite Export so gewollt ist, weisst nur du." Unbeantwortet.
ORT: NFS backup1.comdare.de Export-Konfiguration
STATUS LT. QUELLE: offen (Owner-Frage, Sicherheitsrelevanz)
ABHAENGIGKEIT/FLAECHE: Lagerhaltung nfs://backup1.comdare.de/nfs/Comdare-Buildsystem (14 TB, Volume_2)

### [wssynj4q3] 11
GEGENSTAND: OFFEN (aus offen-Liste item 8): Owner-Frage an den Lead unbeantwortet: "Wenn alle Workflows dann durch sind, geht es mit dem Strang der Implementierung weiter bis Phase 6 bzw. ist Phasensystem A/B/C... schon abgeschlossen? Wo stehen wir insgesamt?" (08.08. 07:24). Lead raeumte ein: Ledger fuehrt "Phase B" 16x und "Phase A" 4x ohne sauber definiertes A/B/C-System.
ORT: Dossier offen item 8; Ledger
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Phasensystem-Definition im Ledger

### [wssynj4q3] 12
GEGENSTAND: METHODEN-WARNUNGEN DER EXTRAKTION (fuer jede kuenftige Transkript-Extraktion bindend): (a) ~40 Owner-Nachrichten kamen ueber attachment.type=="queued_command" bzw. {"type":"queue-operation","operation":"enqueue"} OHNE promptSource/origin.kind -- die Memory-Regel "queued_command.prompt existiert seit 06.08. NICHT MEHR" ist FALSCH (belegt 07.08. 18:17:24, 18:53:08, 19:01:17); darunter die gesamte F-01/F-02-Plattform-Matrix, der D-1/B-4/D-3/O-C-Block, "Es ist IMMER alles geplant", die F2/F3/F4-Antwort. Jede kuenftige Extraktion muss BEIDE Pfade lesen. (b) Kanonischer Owner-Marker uebersieht promptSource=="suggestion_accepted" mit origin.kind=="human" (5 Faelle, 4 im August: "Welle 1 laufen lassen", 2x "Zieh durch", "Pause einlegen") und eine typed-Nachricht ohne origin-Feld -- wer den Marker benutzt, muss suggestion_accepted mitziehen. (c) Datenschaden 06.08. 05:44:05: E-3-Text unwiederbringlich (Terminal-Maus-Escapes); gueltig ist Fassung 05:49. (d) Im ASSISTENTEN-Teil von Datei A liegt ein demaskierter Vault-Wert (samba-comdare-socks-pw) -- Konto gehoert rotiert; Owner delegierte 08.08. 07:17 an Infra.
ORT: Dossier Abschnitt 1 "Wo die Extraktion unsicher ist"; Transkripte 5a19728e-*.jsonl / 46375cdc-*.jsonl
STATUS LT. QUELLE: teilweise (Extraktor-Union in Memory bereits als DREI PFADE notiert; Rotation offen/delegiert)
ABHAENGIGKEIT/FLAECHE: Memory-Eintrag reference_transkript_extraktor_zwei_pfade.md; Vault-Rotation

### [wssynj4q3] 13
GEGENSTAND: 33 OWNER-DIREKTIVEN konsolidiert (2.1 Doktrin / 2.2 Teilsystem / 2.3 Einzelfall) -- design-tragende Verbatim-Kerne u.a.: Frist "15.09.2026 ... JEDEN Freitag neue Ergebnisse"; Reproduzierbarkeits-KERN "Mess-Achsen+System-Achsen+Organ-Achsen identisch -> fingerprint fuer identische binary fuer identische Messdaten" uneingeschraenkt; Universal-Invalidierung (neue Haupt-Achsen-Algorithmus-Version => alle betroffenen Binaries updaten); Mess-Achse aendert => CEB+ALLE Binaries neu; Batch max 4096 fuer compile UND Messung; PMC Pflicht in CEB-Pruefdock; EINE CEB, zwei gepinnte Starts (P/E-Core); Pinning Pflicht auf Hybrid-Architekturen, Ausnahme-Einzelfall "warn: no pinned locality on hybrid architecture"; Error=fehlende grundlegende Systemeigenschaft, Fatal=Kabel/Verbindung/Speicherverlust/Lager-Inkonsistenz; Break-Even lebt NUR in der CEB nach Messungs-Schluss im RAM; Modus-Staffelung measure c= compare c= release, compare = eigene Stufe (lesend Messwertlager) vor release; Stempel: Punkt-Trennung, c{p.e} ({p} Default), x512.f.vl.bw.dq, Flag-Kodierung Hash, Fingerprint SHA256 (SHA512 nach 4 min ueberholt), kein v-Praefix, Hybrid kapselt volle Tier-Stempel in [] mit XOR-Fingerprint, alte Stempel-Wege KOMPLETT ersetzen; Versionierungs-Interface gesondert an Planer/CEB/Tier-Binary (Option b); Lager: nfs://backup1.comdare.de/nfs/Comdare-Buildsystem, 14 TB, ZWEI Baeume (Messwerte/Binaries) mit eigenen Wurzeln (PR4100/8TB-Ansage UEBERHOLT); xlsx ist default, kein CSV-Lager; XML ist Whitelisting; XML trennt build und Messung; LaTeX-Anlage Pflicht (XML-Zielordner, CI-Einbindung, Variablen + schaltende Textbausteine, EIN Anhang/EIN Dokument, Inhalt = Auswertung/Break-even/beste 5, nicht Rohmesswerte); Plattform: prod1+prod2 Pilot bare metal, 7 OS x 3 Versionen Docker (Debug-Messung "OS support builds"), macOS/RISC-V/Pi5 nach Abgabe, ZIH wird trotzdem vollzogen; Lizenz: restriktivste mit Einblick+Compile+Linken, kein gewerblicher Verkauf, Doppellizenz freie Forschung, alle 3 Repos; Thesis-Eigentum Benjamin-Elias Probst privat, CacheEngine BEP Venture UG (Marke Comdare); DE fuehrt; querschneidend 5 Mess-Ebenen (explore); "NIE RATEN, IMMER LESEN".
ORT: Dossier Abschnitt 2 (vollstaendige Tabellen) + 6 (Verstaendnis-Geruest)
STATUS LT. QUELLE: Direktiven gueltig; Umsetzungsstand nicht Gegenstand des Dossiers
ABHAENGIGKEIT/FLAECHE: Abgleich mit KON-Ledger-Staenden (Dossier ist Stand 08.08.; spaetere KON-Stufen koennen einzelne Punkte praezisiert haben, z.B. MESS-NENNER 32, CEB-Reihe 5-6-12)

### [wssynj4q3] 14
GEGENSTAND: 14 DOPPELT GESTELLTE FRAGEN (Owner musste wiederholen): compare-Stellung 3x; Break-Even 2x voll ausformuliert; xlsx als Mess-Format 3x; Stempel Planer/CEB 2x korrigiert + 1 Kontrollfrage; ZWEIPHASIG/DREIPHASIG 2x zum Nachlesen; PMC-Architektur Hybrid 2 Anlaeufe in 7 min; Lager/Bestandslog 2x als "irrsinnig" zurueckgewiesen; Fehlerklassen 4x nachgeschaerft; Thesis-als-Anforderung 3x; Workflow-Backups 4x angeordnet (+2 Kontrollfragen); "Kippe Workflow-Ergebnisse in den Kontext" 2x in 20 min; "Deutsch fuehrt" 2x binnen einer Minute; Frist 15.09. einmal gesetzt dann vom Lead ignoriert (Task #23 Frist-Korrektur); Speicherort Messdaten 2x (einzige durch echte Messung gedeckte Wiederholung: PR4100 hatte 10,1T statt 16). Muster verbatim: "der Lead hat den Session-Log/Plan nicht gelesen, bevor er gefragt hat, und hat statt einer Recherche eine Empfehlung vorgelegt" -- in vier Faellen war die Empfehlung sachlich falsch.
ORT: Dossier Abschnitt 4
STATUS LT. QUELLE: nur-hinweis (Arbeitsweise-Befund; deckt sich mit w50k74cln-Audit)
ABHAENGIGKEIT/FLAECHE: Arbeitsweise-Regeln (Gedaechtnis zuerst)

# QUELLE 4: wb8p02wqu.json (Planer-CLI --check-size + Mess-Kette 3 Stufen/6 CEBs + Break-Even-Konsolidierung; 21 Agenten, 3.339.953 Tokens)

Kontext: Gedaechtnis 4/4 Straenge fanden die Planung (41 Kern-Stellen); Ist-Stand 41 Luecken; 3 Entwuerfe bewertet (vertrag-erst 0/3, ct-rein 1/3, betrieb-erst 2/3 Stimmen -> empfohlen). Synthese = Bericht an den Owner 08.08.

### [wb8p02wqu] 1
GEGENSTAND: Paper-als-XML: Auftrag existiert seit 3 Monaten in 4 Etappen (13./14.05. STRUCTURAL_CORRECTION_diplomarbeit.md:102; 27.05. ce docs/architecture/17_paper_kartografie_r7_6.md:9-13; 08.06. 32_lastprofil_katalog_und_paper_bias.md:3-6; 20.07. Ledger:3212 U-8-(3)). Gebaut: 33 SOTA-Profile P01-P33, 23 Allokator-Profile A01-A23 mit Gate test_profile_coverage, 21 Lastprofile (5 paper-spezifisch), 21x PAPER_REFERENCES.md, vendorter Original-Code (17 ext-Baeume, 12 ext/traversal, 22 Adapter mit paper_id()). VIER LUECKEN: (1) KEIN einziges Experiment-XML je Paper (sota-Wurzel comdare_algorithm_profile != comdare_experiment; comdare_experiment nur 2 Dateien in ce); (2) profile_ref wird geparst (xml_config_parser.cpp:284) und NIE dereferenziert (profile_to_tree.hpp:49 nimmt nur t.id); (3) drop_tier_level (profile_runner.hpp:117) zieht tier-Ebene im produktiven Lauf ab -- 7 base_tiers erzeugen keine Binaries; (4) zwei Vokabulare ohne Naht (SPARSE_NODE4_ART in abi/baustein_variants.hpp:99-103 vs. node4 in Kompositions-Registry).
ORT: ce origin/development; Fundstellen wie genannt
SOLL/FIX: Stufe 3 (Paper-XML als lauffaehiges Experiment) bauen; seit 20.07. als "post-v3" geparkt (Ledger:3185 [par.59-TEMPLATE] OFFEN, mittel); Owner hatte GO gesagt, Ledger hat vertagt. Detail-Fragen = Entscheid D-4.
STATUS LT. QUELLE: offen (Stufe 1+2 fertig, Stufe 3 nicht gebaut)
ABHAENGIGKEIT/FLAECHE: D-4 (Wurzel + Deckungsgrad); Full-Join (Posten 3)

### [wb8p02wqu] 2
GEGENSTAND: XML-Kanal Bau-Menge getrennt von Mess-Menge EXISTIERT NICHT: experiment_golden_kern.xml:270 sagt selbst "Diese XML deklariert also die BAU-Menge, der Planer die MESS-Menge"; laufzeitseitig nur provision_only + golden_range_start/count (profile_run_entry.hpp:209-213) = Fenster, keine Deklaration; Posten N-6/T2 im Ledger (:5054-5056) ungebaut. WIDERSPRUCH D-5: Owner 07.08. (Ledger:7342) "Wir bauen nur die 320er die wir auch tatsaechlich messen" vs. Owner 08.08. "groesseren Satz bauen, nur einen Teil messen" -- Lead liest 08.08. als geltend, bittet um Bestaetigung.
ORT: super Code/test_data_xml/experiment_golden_kern.xml:270; ce profile_run_entry.hpp:209-213; Ledger:2411-2416 (19.07. par.41 GN-11), :5037-5038, :7342
STATUS LT. QUELLE: offen (Bau + Owner-Entscheid D-5)
ABHAENGIGKEIT/FLAECHE: mess_selektion=fehlt -> rc 3 in --check-size (Posten 6); D-2-Baumenge (wssynj4q3 Posten 1)

### [wb8p02wqu] 3
GEGENSTAND: Full Join je Achse ueber alle Paper NICHT gebaut; Stufe3_FullJoin im Code ist ein ANDERER Join (CacheEngine u. PRT-ART-Pruefling, pruefling_merge.hpp); Owner-Kern-Idee (Ledger:10935ff, 08.08.): "sequentiell JEDE Achse einzeln durch-permutieren, ob nicht die Algorithmen der Anderen Paper in dieser Achse besser gewesen waeren" = Geschwister-Vergleichs-Ordnung; mechanische Form existiert ohne Paper-Bezug: source_catalog.hpp:322-323 (je vertiefte Achse ein Sweep-Katalog, Baseline + genau EINE vertiefte Slot-Liste) -- fehlt nur Baseline aus Paper-XML.
ORT: ce pruefling_merge.hpp; source_catalog.hpp:322-323; all_axes_golden.profile.xml:102-108
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Posten 1 (Paper-XML ist Voraussetzung)

### [wb8p02wqu] 4
GEGENSTAND: --check-size: KEIN frueherer Auftrag existiert (Nullbefund 5 Muster, Gegenprobe emit-tier-ci -> 109 Dateien); Lesart: "wie geplant" bezieht sich auf die geplante XML-Form. Wiederverwendbarer Bestand: PlanSizeBuilder (experiment_plan_director.hpp:417, einziger Aufrufer Startgate profile_run_facade.cpp:1061 fragt nur leer ja/nein); ECHTE LUECKE im Zaehlwerk: PlanHeader::profile_value_count ist SUMME der value-Eintraege (:165-166) -- aus Summe folgt keine Permutationszahl, es fehlt genau ein Produkt je Achse; projiziere_kampagne/kampagnen_zeile (eta_kalibrierung.hpp:297/:350) fertig und BIS HEUTE OHNE AUFRUFER.
ORT: ce experiment_plan_director.hpp:417/:165-166; eta_kalibrierung.hpp:297/:350
STATUS LT. QUELLE: offen (Entwurf liegt vor, Posten 6)
ABHAENGIGKEIT/FLAECHE: -

### [wb8p02wqu] 5
GEGENSTAND: MESS-KETTE IST-STAND -- schwerster Befund: Messfehler-Herausrechnung nirgends gebaut, nirgends geplant, heute NICHT baubar. (i) Auffaecherungs-Maschinerie scharf (measurement_combos_of, ceb_combo_compile_define, --measurement-combo). (ii) Nichts erzeugt die 6er-Menge; golden deklariert genau EINE Combo, nennt die frueheren 3 Ein-Tool-Combos die F-3-Regression (all_axes_golden.profile.xml:220-226). (iii) Nur ZWEI unterscheidbare Kompilat-Zustaende: G1 an COMDare_MEASUREMENT_ON; G2 (Observer) und G3 (Feinkorn) teilen EIN Gate COMDARE_CE_ENABLE_STATISTICS (mess_achsen_naht.hpp Ueberschrift verbatim "EHRLICHE GRENZE DIESER SCHEIBE -- macro UND micro SIND HEUTE NICHT TRENNBAR"); wallclock nicht ausbaubar (G1 von jedem Tooling gezogen) -> von 6 CEBs maximal 2 herstellbar. (iv) Differenz-Arithmetik existiert nirgends (Nullbefund 3 Muster, Gegenprobe measurement_combo -> 27 Dateien); telemetry_mode.hpp:34 ist Snapshot-Differenz IM selben Lauf, nicht zwischen Bauten. Stufen-Tabelle: Stufe 1 (Micro) -- G3 fill_segment_timing_v3 misst etwas anderes (synthetische Ops, aufsummierte Dauern, keine Zeitpunkte); Stufe 2 (Macro) -- ungebaut, alle vier Einsammler schreiben seg_ns hart -1 (set_tier_v2.hpp:136, sequence_tier_v2.hpp:125, adapter_tier_v2.hpp:118, view_tier_v2.hpp:96); Stufe 3 -- G1 run_workload nur Batch-Gesamtzeit. Zusatzbefunde: "Checkpoint" im Code = Fuellstands-Checkpoint (genus_tier_observe_trace_abi.hpp:61/:97/:140) NICHT im Produktionspfad; KEINE Wallclock (nur steady_clock; system_clock genau 2x ausserhalb Messung); Parameter und Zeit aus verschiedenen Fenstern (abi_adapter.hpp:2071-2095).
ORT: wie genannt
SOLL/FIX: D-2-Paket: (a) G3 aus CE_ENABLE_STATISTICS herausloesen in eigenes Makro (beruehrt abi_adapter.hpp Hot-Path + A8-S4-Praeprozessor-Wache, die genau zwei Gate-Makros kennt); (b) Combos ohne wallclock zulassen. Owner-Freigabe noetig (D-2), Arithmetik-Frage D-3 (2^3=8 vs. Leave-one-out 4/5 vs. 3!=6 vs. 2^3-2=6 -- "Welche der beiden Mengen meinst du?").
STATUS LT. QUELLE: offen (blockiert; Owner-Entscheide D-2/D-3)
ABHAENGIGKEIT/FLAECHE: checkpoint_measure-Design (wo8yyv72t) haengt am selben G3-Gate; test_a8s4_release_pfad_neutralitaet.cpp:166-168 muss im selben Commit mitziehen

### [wb8p02wqu] 6
GEGENSTAND: --check-size EMPFOHLENER ENTWURF (betrieb-erst, 2/3 Stimmen): tragender Gedanke "der Planer rechnet die MENGE, die CEB(s) liefern die RATE"; alle drei Vor-Entwuerfe fielen an der leeren Naht durch (Planer und CEB linken dieselbe Bibliothek comdare::profile_run_facade -- Werte, die der Planer selbst sieht, ueber eine Prozessgrenze zu reichen simuliert die Forderung nur).
ORT: Entwurf par. 4
SOLL/FIX: Aufruf `cache_engine --check-size "FILE"`; ALLES Weitere in XML-Block <check_size> (ceb build_if_missing/dir, kalibrierung modus bestandslog|mini_batch|keine batch=24, ziel_dateisystem) [SETZUNG aus F3-Ruling Ledger:2033 + B-4]; Ausgabe stdout key=value deterministisch, ungedeckte Zahl = n/a NIE 0, unvollstaendige Projektion >=; Exit-Codes: 0 vollstaendig+gedeckt, 1 Usage, 2 Konfig, 3 Bericht steht aber KEINE FREIGABE (Kernzahl n/a, ueberlauf, reicht=nein, mess_selektion=fehlt), 5 unbekannte Wurzel, 6 Bestandslog-Gate, 8 CEB fehlt und nicht baubar; CEB-Befragung ueber experiment_dock_payload.hpp (deklarierter par.38-Dock-Vertrag, heute [DEPRECATED S5-P4] weil ohne Live-Call-Site -- check-size IST die erste) + TEIL 3 CebSizeAnswer im selben Header/Dialekt/Roundtrip-Gate; Transport `comdare-messung-driver ceb probe-size <profil>` (derselbe Kanal wie experiment_plan_director.hpp:479); CEB antwortet NUR Exklusives: Kompilat-Identitaet (COMDARE_MEASUREMENT_COMBO_CT, -march, ceb_contract_version, ceb_key_sha512), Zeit je Messpunkt (Bestandslog oder Mini-Batch unter eigener Instrumentierung), Hardware-Erhebung aus measurement/hardware_probe_factory.hpp (heute NULL Produktiv-Konsumenten). KORREKTUR eines Vor-Entwurfs: hardware_probe_factory liefert KEIN cacheline_bytes und KEINE Thread-Zahl -- realer Kanal: platform_probe/cpuid_probe.hpp:174 + sysfs_cache_probe.hpp:74, zusammengefuehrt cpuid_platform_probe.hpp:48-49. Rechnung: PlanHeader + profile_axis_cardinalities (byte-neutral, gefuellt an experiment_plan_director.hpp:2113); neuer PlanVolumeBuilder neben PlanSizeBuilder am selben Walk (construct_plan_into, profile_run_facade.cpp:985), Ueberlauf -> "ueberlauf" nie gewickelte Zahl; bau_binaries = organ_produkt x system_perms x mess_kombis; die 16 measurement_categories gehen NICHT ein (CSV-Spalten par.54-T2, kein CEB-Faecher -- Faktor-16-Fehler); Dauer via projiziere_kampagne (KampagnenPosten MUSS maschine als Gruppierungsschluessel tragen); Platz via std::filesystem::space (prod1 ist der GitLab-Runner, volles / legt CI lahm); Wandzeit mit lane_build_parallelism=24, nicht nproc. Bau-Schritte S1-S10 mit literalen Abnahmen (S1 byte-identische Emission; S2 Produkt == catalog_axis_product<golden_320_catalog>() == 320; S4 emit(parse(emit(a)))==emit(a); S8 zwei Laeufe byte-gleich; S10 Overhead-Zeile = erster Mess-Overhead-Nachweis). HUERDE: messung_driver ist super-Target, in ce kein add_executable -- ce-Standalone rc 8 mit klarer Meldung.
STATUS LT. QUELLE: offen (Design fertig, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: S10 verbindet check-size mit der Mess-Kette (nur 2 von 6 Varianten baubar bis D-2-Paket); N-6/T2-XML-Kanal (Posten 2)

### [wb8p02wqu] 7
GEGENSTAND: BREAK-EVEN: DREI Code-Orte statt zwei (heuristik/ Engine; builder/curve_fit/ E4'-Vorbau; builder/best_binary_selector/ self-contained), curve_fit traegt bereits KOPIE der Fritsch-Carlson-Mathematik aus heuristik/ (curve_fit.hpp:277) -- Doppelung heute dreifach. Owner hat Wahlfrage beantwortet (Ledger:10979): "Wir brauchen nur eine konsolidierte Implementierung, bitte fuehre beide zusammen und nach meiner Beschreibung zum Ziel." Beide sind Skelette ohne Produktionsaufrufer (break_even.hpp nur von test inkludiert; find_break_evens nur aus test_hybrid_spline_selector_scaffold.cpp). A hat Richtungs-Semantik aus Katalog (AXIS_ALGO_VERSION: 2, T-9: vorher fuer 15 von 19 Achsen-Zeilen FALSCH herum) + realen CSV-Lader beider Dialekte; B hat Kandidaten-/Selektor-Interface + modell-agnostischen Finder, aber pauschal "kleiner = besser". VIER DELTAS zur Owner-Beschreibung, alle in beiden fehlend: (1) B-Spline B=3 nirgends (Nullbefund 6 Muster; vorhandene sind interpolierende Hermite/natuerliche Splines -- Neubau, nicht Umbau); (2) String-Serialisierung + Parser nirgends (Nullbefund 8 Muster) -- "ohne serialisierbare Funktion gibt es nichts zu giessen ausser Punkten" (braucht B-4: Break-Even im RAM -> LaTeX/PDF/xlsx); (3) Abszisse: beide x = Last/Working-Set, Owner beschreibt ZEITachse eines Laufs (Checkpoints) -- schaerfster Unterschied, Entscheid D-6 (Vermutung: beides gestaffelt, Break-Even = Schnittpunkt der LASTkurven); (4) Basis f(0) = erster Messwert nirgends. Datenquelle der Owner-Kurve existiert nicht (CSV ohne Checkpoint-/Zeitstempel-Spalte) -- Reihenfolge-Abhaengigkeit: erst Checkpoints + Wallclock, dann B-Spline.
ORT: ce libs/cache_engine/heuristik/axis_spline.hpp (261 Z.), break_even.hpp (197 Z.), builder/curve_fit/curve_fit.hpp (537 Z.), builder/best_binary_selector/*
STATUS LT. QUELLE: offen (Owner-GO zur Konsolidierung liegt vor; D-6/D-7 offen)
ABHAENGIGKEIT/FLAECHE: checkpoint_measure (wo8yyv72t) liefert die fehlende Datenquelle; D-6 Abszisse, D-7 interpolierend vs. approximierend (methodischer Unterschied, muss in die Thesis)

### [wb8p02wqu] 8
GEGENSTAND: OFFENE OWNER-ENTSCHEIDE D-1..D-7 des Berichts: D-1 Name der Binary (cache_engine vs. comdare-experiment-planner; Neigung: Name lassen, sonst wackeln Stempel+Pipelines); D-2 Freigabe 6-CEB-Bau-Paket (G3-Herausloesung + Combos ohne wallclock); D-3 WELCHE 6 (Arithmetik geht nicht auf: 2^3=8, Leave-one-out 4/5, 3!=6, 2^3-2=6); D-4 Paper-XML Wurzel + pinnt ein Paper ALLE Achsen (1 Binary) oder nur spezifizierte (Teilbaum + Full Join -- aendert Mengenrechnung um Groessenordnungen); D-5 Bau=Mess (07.08.) vs. Bau>Mess (08.08.); D-6 Break-Even-Abszisse Zeit vs. Last vs. beides gestaffelt; D-7 B-Spline interpolierend oder approximierend.
ORT: Bericht par. 5
STATUS LT. QUELLE: offen (Owner-Vorlage)
ABHAENGIGKEIT/FLAECHE: Memory OWNER-ANTWORTEN 10.08. beantwortet Teile (PMC=Meta-Meta-Achse, CEB-Reihe 5->6->12 W-3, Binary-Zahl NUR von der Planungs-Simulation) -- Designer muss D-1..D-7 gegen die 10.08.-Antworten und KON-Stufen abgleichen, bevor er sie als offen fuehrt

### [wb8p02wqu] 9
GEGENSTAND: NICHT GEKLAERT (5 Punkte): (1) prt-art-Repo liegt nicht als Worktree -- eigene Template-/Registry-Fuehrung ungeprueft; Pruefling hat in ce KEINE eigene Akte (all_axes_golden.profile.xml:24 zeigt auf ../sota/art.profile.xml). (2) Ob experiment_driver.cpp (Auto-Pickup sota, REV 7.6) noch am offiziellen Messpfad haengt -- Aufrufkette nicht zu Ende verfolgt. (3) run-Haelfte der CEB (super Code/02_messung_driver/main.cpp ~Z.560-1467) ungelesen -- aendert ggf. Umfang von S5. (4) Ob im Lager/Bestandslog Laufzeit-Daten je MESSUNG liegen (Bau-Rate belegt Ledger:2459 "~73 DLLs/min je Zelle"; Mess-Rate mit 3 Mustern nicht gefunden). (5) Zahlen bewusst nicht nachgerechnet (Owner hat pauschales Nachrechnen untersagt; erste Zahl soll aus dem Programm kommen).
ORT: Bericht par. 6
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: S5-Umfang; Dauer-Haelfte von --check-size

# QUELLE 5: w20ado9k1.json (Audit Diplomarbeit gegen Code-Ist + Textnachzug, Owner-GO O-4; 5 Agenten, 994.157 Tokens)

Kontext: 19 Audit-Befunde, alle THESIS_VERALTET; Bau + Review; verdict GRUEN, landebereit=True. Code-Referenz ce aa223961.

### [w20ado9k1] 1
GEGENSTAND: PMC-Befundgruppe (Audit-Befunde 1,2,3,5,6,7,8,9,11): Thesis behauptet "PMC fehlt/NullPmcSource/PAPI ausstehend/Energie nicht verdrahtet" -- Code-Ist: LinuxPerfPmcSource oeffnet L1D/LL(L3)/dTLB REAL via perf_event_open(2) ohne Vendor-Lib (linux_perf_pmc_source.hpp:209-214); COMDARE_ENABLE_PMC seit F9 (16.07.) fuer jeden offiziellen Mess-Lauf Pflicht (Invariante I-PMC-1, experiment_plan_director.hpp:262-277); Default OFF nur wegen test:unit; L2+Coherence strukturell ohne portablen Linux-Counter (pmc_source.hpp:28-31); L3 auf AMD Zen5 ENOENT/EINVAL-gefaehrdet (linux_perf_pmc_source.hpp:276-280); Energy best-effort RAPL verdrahtet (:173-196,:313-332), oft ohne Root-/Zonen-Leserecht leer; PAPI nur optionaler Sekundaerpfad; ehrliches n/a statt 0 seit Fix 5c102e05 (07.08.); reale Werte seit 25.06. bewiesen (Job 189916 cache_misses_l1=4190096).
ORT: thesis anhang/{de,en}/tabellen/le_limitierung.tex:20/21/30; A_measurements.tex:12-13/:285; kapitel 03:1050-1057/:1065; 05_evaluation.tex:95; 06_fazit.tex:157-165
STATUS LT. QUELLE: behoben@aa97bffc (Textnachzug, DE+EN paritaetisch)
ABHAENGIGKEIT/FLAECHE: Regression 2 (AUTO-GENERATED-Rueckfall, Posten 5)

### [w20ado9k1] 2
GEGENSTAND: Achsen-Befundgruppe (Befund 4): "15 gepinnte Achsen" + Liste mit telemetry und isa ist veraltet -- Registry (cache_engine_axis_registry.xml:9-125) fuehrt exakt 18 Kompositions-Achsen T00-T17; isa seit INC-2d (Commit 2b9e70c5, 18.07.) target_isa-System-Achse; telemetry seit INC-2c ausserhalb der binary_id-Komposition; persistence_target seit 774a5d5f (26.07.) 18. Organ-Achse (T17); korrekt: 14 gepinnte + 4 variable = 18. le_limitierung.tex zuletzt 06.07. geaendert -- VOR beiden Umbauten.
ORT: le_limitierung.tex:21 (DE+EN)
STATUS LT. QUELLE: behoben@aa97bffc
ABHAENGIGKEIT/FLAECHE: Memory "18 ORGAN-ACHSEN" bestaetigt

### [w20ado9k1] 3
GEGENSTAND: Modus-Befundgruppe (Befunde 10,11,12 + Zusatzfund): Thesis nennt drei Ablauf-Methodiken/Auslieferungsvarianten -- Code fuehrt VIER: RunMethodology{Debug,Measure,Release,Compare}, kRunMethodologyCount=4, static_assert (run_methodology_registry.hpp:37-45,78); Compare seit 42b34354 XML-waehlbares Registry-Mitglied, Bau-/Mess-Semantik bewusst release-gleich (Vollzug Paket D2). ZUSATZFUND des Bauers (nicht in Audit-Liste): kapitel 04:52-54 zweite "DREI Auslieferungsvarianten"-Stelle -- ohne Fix interner Widerspruch ADR-9(vier) vs. Kap.4(drei).
ORT: kapitel 03:996-997; 04_implementierung.tex:493-496 + :52-54; anhang E_architecture_decisions.tex:109,112-116 (ADR-9)
STATUS LT. QUELLE: behoben@aa97bffc
ABHAENGIGKEIT/FLAECHE: Regression 1 (Anhang D, Posten 5)

### [w20ado9k1] 4
GEGENSTAND: Gattungs-Rename-Befundgruppe (Befunde 13-18): Ebene-1-Name SearchAlgorithm -> Map (enum AnatomyGattung{Map,Container,Graph}, Rename-Commit ce 80f5eae3, 04.08., + 4ce77d0c + fa7f8476); Genus SearchAlgorithm (Ebene 2) bleibt; Thesis-Stellen (fig:three-levels, fig:genera, Glossar mit INTERNEM Widerspruch, Hash-Gegenprobe, Kap.4-TikZ) trugen alte Ebene-1-Bezeichnung.
ORT: kapitel 03:727-774/:395; 04:196-216; anhang C_glossary.tex:50-56
STATUS LT. QUELLE: behoben@aa97bffc (EN nutzt Glossar-Terminologie: Ebene 1 = genus, Ebene 2 = tier subclass)
ABHAENGIGKEIT/FLAECHE: Memory GATTUNG+GENUS-Interface-Hierarchie

### [w20ado9k1] 5
GEGENSTAND: BAU-STAND + DREI REVIEW-REGRESSIONEN: Branch b-thesis-o4-nachzug (Worktree /home/comdare/wt-thesis-nachzug, aus development 19e1592 des thesis-Submoduls), Commit aa97bffc42689d2d778fdd47dd7dc6717373835c "docs(thesis): O-4 Textnachzug an den Code-Ist (DE+EN paritaetisch)", 16 Dateien +94/-62, KEIN Co-Authored-By-Trailer; NICHT GEPUSHT, KEIN UPSTREAM, KEIN MERGE. PDF baut: DE 204 S./936170 B., EN 194 S., 0 ^!-Fehler, alphadin.bst/alpha.bst, 0 undefinierte Refs. DE/EN-Paritaet dreifach belegt (8 Paare hunk-gleich 2/2/2/2/9/5/1/1). Review: audit_eingehalten/paritaet/keine_neue_falschaussage/landebereit alle True. REGRESSIONEN: (1) MITTEL anhang/{de,en}/D_building_block_matrix.tex:1269 "die DREI Mess-Modi ... existieren noch nicht als Typen" -- Zahl drei widerspricht nun vier Varianten; Typ-Existenz-Behauptung gegen run_methodology_registry.hpp ohnehin fraglich; bewusst stehengelassen ("im Zweifel auslassen und melden"), braucht eigene Pruefung der Reflexions-/W2-B-Semantik. (2) MITTEL le_limitierung.tex Kopf "AUTO-GENERATED durch csv_to_latex::write_limitations_longtable" -- korrigierte Zeilen 1/2/11 werden bei naechster Generator-Ausfuehrung STILL zurueckgesetzt; Nachzug MUSS im Generator (ce-Repo) gespiegelt werden, sonst kehrt die Falschaussage zurueck. (3) NIEDRIG "Regelfall seit Linux 5.10" verschaerft Code-Kommentar "oft" -- Nuance. AUSSERDEM GEMELDET: kapitel/{de,en}/01-08-Altbestand (nicht via diplomarbeit.tex eingebunden) traegt weiter "SearchAlgorithm-Gattung" -- bewusst nicht angefasst.
ORT: /home/comdare/wt-thesis-nachzug @ aa97bffc; Generator im ce-Repo (csv_to_latex::write_limitations_longtable)
SOLL/FIX: (a) Branch pushen/landen (landebereit=True); (b) Folgeauftrag Generator-Spiegelung ce; (c) Anhang-D-Pruefung
STATUS LT. QUELLE: teilweise (Bau fertig+landebereit, Landung offen; 2 Folgeauftraege offen)
ABHAENGIGKEIT/FLAECHE: LANDEREIF-KANDIDAT AUSSERHALB DER BEKANNTEN BRANCH-LISTE -- Designer muss verifizieren, ob wt-thesis-nachzug/aa97bffc inzwischen gelandet oder verwaist ist; Generator-Spiegelung beruehrt ce (Repo-Grenze)

# QUELLE 6: w1pm0nio7.json (#21: E-1..E-4-Vollzug + A-1-Vorlagetext, Worktree wt-super-e21; 3 Agenten, 493.875 Tokens)

Kontext: Explore/Bau/Verify; Branch bau/e21-vollzug-a1 (= bekannter landereifer super-Branch), Basis a103e518 = origin/development, 3 Commits, KEIN Push. Verify: "QUITTUNG BESTAETIGT, EIN KLEINFUND DIREKT BEHOBEN."

### [w1pm0nio7] 1
GEGENSTAND: E-Block-Bilanz der 10.08.-Vorlage (Z. 35872/35912 Rohtranskript): E-1 (OV-4 Mess-Deckel) SCHON_ERLEDIGT via KON40-03 + KON41-01 Generalproben-Doktrin -- Rest = UEBERHOLT-Marker an KON2-36 (:9050) + OV-4-Deckel-RECHNUNG als W2-Posten (mit S-19-Zahlen VOR GO-Vorlage ##51); E-2 (Merge-Stempel-Selbstwiderspruch) am Objekt vollzogen (Owner-E2 02.08. gewann; DV-1/A13-M3 entfernte merge_stamp-Code ERSATZLOS: adhoc_emitter.hpp:110, anatomy_version_stamp.hpp:392; merge_plan.hpp = Durchfuehrung lebt) -- Rest = UEBERHOLT-Marker an zwei stale Zeilen :18006 ([Par.59-MERGE-STEMPEL] OFFEN, hoch) und :18219 (DRITTER Merge-Stempel K7a GELANDET), Widerspruch real; E-3 (W-6 vier lokale Klone) SCHON_ERLEDIGT via KON37-07/F-F (Zielzustand unter Konsolidierungspflicht, Ordnung -> #88) -- W-6-Gate GEFALLEN macht #21 KOMPLETT abschliessbar; E-4a (KON-12 T-5 n=1 statt 3) SOLL erledigt via KON37-06/F-H (je 5 Fehlversuche Build UND Messung, 3 Erfolgs-Werte EINZELN persistiert, nie gemittelt), Bestand gedeckt via KON41-01 T-3-Reset -- Rest = Kennzeichnungs-Zeile "Altbestand n=1 = ohne Drift-Aussage (Generalprobe)"; E-4b (KON-20 concurrency/OD-7) erledigt via KON26-05/KON28-01/KON58-03 -- operativer Livecheck 16-vs-24 = #22(i)/Infra.
ORT: super Ledger @ a103e518; ce @ 5f3f26a5; Rohtranskript 5a19728e Z. 35872/35912
STATUS LT. QUELLE: SCHON_ERLEDIGT bis auf Marker (Lead-only) und E-4c
ABHAENGIGKEIT/FLAECHE: Ledger-Nachtrag (Posten 3); WARNUNG: mind. 5 kollidierende E-Serien im Korpus -- IMMER Gegenstand pruefen, nie Nummer (Klasse L-8/OV-Nummern)

### [w1pm0nio7] 2
GEGENSTAND: E-4c KON-57/E-26 TEST-SCHICHT = EINZIGER OFFENER OWNER-REST des E-Blocks: Bau-Seite entschieden (D-2 10.08. "Gebaut wird immer, skip ist VERBOTEN", KON22-01/8 + KON55-01 auch lokal) und Lager-Seite entschieden (KON41-01 "Das Lager faehrt skip sobald es voll ist"; KON53/54 nur GUELTIGER Bestand); OFFEN allein: Voll-ctest Pflicht (Debug UND Release) oder Test-Skip mit Fingerprint-Beweis?
ORT: Ledger KON-57 :10051, KON-01 :9362-9371 (einzige belegte Ausnahme); Frage formuliert in wt-super-e21 docs/plaene/20260813-OWNER-VORLAGE-a1-backup-ref-aktionen.md Teil III
SOLL/FIX: verbatim Empfehlungs-Formulierung fuer die naechste Owner-Vorlage: "Empfehlung: CI immer Voll-ctest, Fingerprint-Skip nur lokal ohne Beweiskraft, KON-01 bleibt einzige Ausnahme."
STATUS LT. QUELLE: offen (Owner-Frage noetig, "mit viel Kontext" formuliert)
ABHAENGIGKEIT/FLAECHE: naechste Owner-Vorlage; Skip-Doktrin

### [w1pm0nio7] 3
GEGENSTAND: Bau-Ergebnis + offene Lead-Handlungen: Commits f1b05256cd343686eabf65566fd860dd6416d73a (A-1-Vorlage-Dokument, 286 Z., 10 Pflichtfelder inkl. NEU Feld 5 Unwiederbringlichkeit, Feld 6 Scan-Nenner + --log-opts=--all, Feld 9 Verbuchung im selben Zug), bd02e7ab8fdaf7e6b5267b253c862580fdeaecc0 (additiver NACHTRAG an 20260813-OWNER-VORLAGE-minio-keys-und-backup-ref.md: Frage 2 auf Kenntnisnahme umgestellt), fe7bb45925e418ac19771e814af522e17118d0ac (Verify-Fix: falscher Zitat-Anker "github ist sauber" ~Z.35934 -> real Anlage-Aera Z.4845; Sachaussage wahr, gedeckt durch Z.36039 "GitHub war nie betroffen"). OFFEN (Lead-only): (a) Ledger-Nachtrag aus ledger_vorschlag committen (KON59-Vorschlag; Nummern-Vergabe beim Lead; Anker ueber KON-Kennung/Wortlaut, Zeilenanker-Drift im Fall E-2 konkret belegt); (b) Lead-Entscheid E-2 (woertliche Neuvorlage GEGENSTANDSLOS werten -- Empfehlung -- oder als Kenntnisnahme aufnehmen); (c) Dateinamens-Divergenz (FORM-Name befolgt vs. Lead-Schrittfolge nannte anderen -- Empfehlung: FORM-Name bleibt); (d) Frage 2 ggf. umschreiben falls Vorlage noch nicht beim Owner (Original als UEBERHOLT kennzeichnen, nie loeschen); (e) Zweig seriell landen, Worktree erst nach gruen+Merge+Submodul-Branch-Pruefung loeschen.
ORT: /home/comdare/wt-super-e21, bau/e21-vollzug-a1, ahead 3, kein Push
STATUS LT. QUELLE: Bau ERLEDIGT+verifiziert; Landung + Ledger-Nachtrag offen
ABHAENGIGKEIT/FLAECHE: Landung seriell mit P9; #21 damit ABGESCHLOSSEN buchbar (Wellenkonsolidierung :188)

### [w1pm0nio7] 4
GEGENSTAND: A-3-ROTATION NICHT VOLLZOGEN (echter Sicherheits-Rest): Owner-GO "A-3: volles go." (Z. 35912) fuer Rotation der 776 Runner-Registration-Token; KON58-04: Instanz akzeptiert Registration-Tokens weiterhin (allow_runner_registration_token=true); Reset-Weg (je Projekt vs. instanzweit) = Owner-/Infra-Entscheid. A-2 (7 Variablen) ist rotiert (Task #70, KON22-01/6). Klon-Sweep (Token-Hygiene) mit A-3-Rotation buendeln.
ORT: GitLab-Instanz; #10-/Infra-Strang
STATUS LT. QUELLE: offen (gehoert #10/Infra, nicht #21)
ABHAENGIGKEIT/FLAECHE: MinIO-Key-Haelfte von #10 ebenfalls OFFEN (blockiert MinIO-Systemtest); CI-Smoke-Terminierung (KON58-04 Befund 1, ruhiges Ein-Blech-Fenster) hier nicht geprueft

### [w1pm0nio7] 5
GEGENSTAND: NEUE FUNDE des Verify: (1) ce-Modules-Store des HAUPT-super-Baums (/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/.git/modules/Code/external/comdare-cache-engine) ist STALE -- origin/development=f23c18e2, Objekt 5f3f26a5 FEHLT dort, waehrend super-Gitlink (f6829547, in origin/development) 5f3f26a5 pinnt; wer im Haupt-Baum development auscheckt und submodule update ohne Fetch faehrt, laeuft auf fehlenden Commit (wt-super-landung-Store ist aktuell). (2) Bestand der fremden minio-Vorlage Z.1-56 traegt non-ASCII (Em-Dashes, Mittelpunkte) -- Lead-Entscheid ob normalisieren. (3) FALLEN-REGISTER-KANDIDAT: "gitleaks git folgt nur HEAD -- Vollscan braucht --log-opts=--all, sonst stille Teil-Deckung" (Selbstkorrektur 10.08., ~Z.36024); ob das Register die Klasse traegt: nicht verifiziert. (4) E-SERIEN-KOLLISIONS-Warnzeile in den Ledger (mind. 5 Serien E-*).
ORT: wie genannt
STATUS LT. QUELLE: offen (Meldung an Lead)
ABHAENGIGKEIT/FLAECHE: Haupt-Baum-Submodul-Hygiene; Fallen-Register

# QUELLE 7: wj9s9vcmp.json (Zweiter Lens Fable adversarisch ueber den S-14a-Riegel axis_version_lock; 3 Achsen parallel; 404.180 Tokens)

Kontext: Objekt = tools/axis_version_lock/axis_version_lock.cpp (627 Z., Stand 13.08. 06:56:07, sha256 a9f1ad9e45f1183e...) + test_s14_axis_version_lock_tripwire.cpp + Lock 158 Records (6 heuristik + 152 organ, 30 digest-only) im Worktree /home/comdare/wt-ce-golden-s14a. Alle drei Achsen: TRAEGT_MIT_FIXES. Bezug Memory: "Riegel 718 Records" (KON58) vs. hier 158 Records -- Designer muss Standdifferenz klaeren.

### [wj9s9vcmp] 1
GEGENSTAND: ERNST (discovery #1): version_of nimmt das ERSTE algo_version-Literal je Datei; axis_03a_search_algo_k_ary.hpp traegt ZWEI unabhaengige Variantenfamilien mit je eigenem Literal (KArySearchAlgoCore :90 -> Literal :141; KAryPerKCore :508 -> :573, Varianten K2/K4/K8/K16/KN mit eigenen Cache-Schluesseln) -- zweites Literal fuer die Wache unsichtbar. Biss: Bump des falschen Literals -> Gate GRUEN, K-Varianten behalten alten Stempel bei geaendertem Algorithmus -> Cache-Treffer liefert altes Artefakt ("schneller UND falsch"); Spiegelbild: korrekter Bump nur bei :573 erzeugt falsches ROT und trainiert den --write-Regen-Reflex.
ORT: tools/axis_version_lock/axis_version_lock.cpp:309 (+:35,:227); axes/lookup/axis_03a_search_algo_k_ary.hpp:141/:573
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Mehr-Varianten-je-Datei-Faelle; Tool-Kopf :67-68 + Test :36-38 benennen die Grenze selbst

### [wj9s9vcmp] 2
GEGENSTAND: ERNST (urteil #1 = test_ci #1, live gefahren): Bump-gruener Pfad erzwingt keinen Lock-Regen -- nach Bump-Commit OHNE --write prueft JEDER weitere Inhalts-Drift unter der einmal gebumpten Version GRUEN (Probe 3: Edit 1 mit Bump -> Exit 0; Edit 2 neuer Inhalt ohne Bump -> Exit 0 "OK Digest geaendert MIT Version-Bump"). CI-Job contract:axis-version-lock (.gitlab-ci.yml:804-806) faehrt NUR --check; Regen-HINWEIS steht auf stdout eines gruenen Jobs; Koeder B prueft nur den Ein-Schritt-Fall. Fenster offen fuer die ganze Flotte bis zum naechsten --write; Stempel = Cache-/Lager-Schluessel -> "schneller UND falsch".
ORT: axis_version_lock.cpp:563 (+ test :264 Schritt 8)
SOLL/FIX: verbatim: "Digest-Drift trotz Bump ebenfalls ROT melden ('Bump erkannt, Lock-Regen fehlt' -- ein Bump-Commit wird gruen, indem er den Lock im selben Commit regeneriert; dann trifft --check den Digest-gleich-Zweig), plus Testschritt: nach Bump-Gruen zweite Drift => muss ROT."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: CI-Job-Definition; ctest-Koeder-Erweiterung

### [wj9s9vcmp] 3
GEGENSTAND: ERNST (test_ci #2): heuristik-ROT-Pfad testseitig unbewiesen -- Koeder A waehlt explizit organ, B-G laufen am synthetischen organ-Traeger; KEIN Test faehrt "heuristik-Drift ohne Marker-Bump => Exit 1" oder "Marker-Bump => Exit 0". Die 6 heuristik-Dateien sind exakt die Kategorie, deren stiller Drei-Wochen-Ausfall der Anlass fuer S-14a war. Tool selbst ist korrekt (am Eigenbau gefahren: axis_spline.hpp Drift ohne Marker-Bump => Exit 1; Marker 1->2 => Exit 0) -- nur der BEWEIS fehlt.
ORT: tests/unit/test_s14_axis_version_lock_tripwire.cpp:233
SOLL/FIX: "ein Koeder-Paar an einer heuristik-Kopie (Drift ohne Bump => 1, Marker-Bump => 0), analog Schritt 7/8"
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: angekuendigtes Einhaengen der SYSTEM-/MESS-Detail-Klassen (Tool-Kopf Z.18-22)

### [wj9s9vcmp] 4
GEGENSTAND: HINWEIS-Sammlung Discovery-Achse (Funde 2-7): (a) Discovery filtert exakt auf .hpp -- Traeger mit anderer Endung (.h/.ipp/.hxx) unsichtbar ab Tag 1, Grenze deklariert (:25,:28) aber unerzwungen; heute 0 Instanzen. (b) recursive_directory_iterator ohne follow_directory_symlink -- Verzeichnis-Symlink unter Home macht neue Traeger dahinter dauerhaft stumm (relevant bei S-6/#16-Umgliederung); heute keine Symlinks. (c) Ungefangene filesystem_error bei unlesbarem UNTERVERZEICHNIS -> SIGABRT statt deklariertem Exit 2 (Koeder F/F2 decken nur Datei-chmod; live gefahren Probe 7, Exit 134); ctest prueft exit_code==2, WIFEXITED bei Signal -1 -> nicht von Tool-Crash unterscheidbar. (d) heuristik version_of: EIN find ueber Rohbytes, kommentar-/string-blind -- Prosa-Zitat der Marker-Syntax MIT Doppelpunkt+Zahl VOR dem echten Marker stellt die Version (heute alle 6 Marker auf Zeile 2). (e) organ-Scanner kennt keine Digit-Separatoren: einzelnes ' oeffnet char_lit; Bestand uebt den Stil aus (axis_q2_queuing_adaptive_lsm.hpp:105 1'000'000.0, heute NACH dem Literal :66 -- rueckt so ein Token vor das Literal, wird der Traeger still digest-only '-'); Fix: im code-Zustand ' nach Ziffer/Identifikator nicht als char_lit-Beginn werten -- oder Leerstelle im Kopf benennen wie Raw-Strings. (f) gelockte SEMANTIK lebt teilweise in Helfern AUSSERHALB der Homes (csv_cell_reader.hpp:16-19 aus measurement_curve_loader.hpp extrahiert) -- semantische Aenderung am Helfer ohne Traeger-Anfassen laesst Wache stumm; Scope-Deklaration :18-22 nennt nur fehlende SYSTEM/MESS-Homes, nicht diese Klasse.
ORT: axis_version_lock.cpp:139/:202/:138/:201/:151/:286-289/:229-231; csv_cell_reader.hpp:16-19
STATUS LT. QUELLE: offen (alle HINWEIS; Owner-Dauerregel 13.08.: LUECKE = BEHEBUNG IST IMMER PFLICHT -- kein "HINWEIS-statt-ERNST")
ABHAENGIGKEIT/FLAECHE: S-6-Umgliederung; Helfer-Scope-Frage

### [wj9s9vcmp] 5
GEGENSTAND: HINWEIS-Sammlung Urteils-Achse (Funde 2-5, live gefahren): (a) Digest-Gleichheit ueberspringt jede weitere Pruefung -- Probe 5: --write ueber Datei mit algo_version="kaputt" liefert rc=1 und schreibt das Lock TROTZDEM (committet -> --check dauerhaft GRUEN); Probe 6: Lock-Versions-Spalte manipuliert bei intaktem Digest -> gruen, anschliessender Drift ohne Bump -> Exit 0 "MIT Version-Bump". Fix gratis: soll.version==ist.version bei Digest-Gleichheit abgleichen (ist.version bereits berechnet). (b) Kein Mindest-Nenner: leere Homes -> --check Exit 0 "GRUEN bestand konsistent -- 0 Dateien" (Probe 4); Anker heuristik==6/organ>=120 leben NUR im ctest (tests/unit/CMakeLists.txt:1943) = ANDERER CI-Job als das contract-Gate; Boden (Exit!=0 bei 0 Traegern je Kategorie) noetig -- Datei-Kopf kuendigt #16-Umgliederung selbst an. (c) Flags nehmen am bump_ok nicht teil (Flag-only-Wechsel = ROT, Probe 2) -- nirgends dokumentiert, obwohl algo_semver.hpp:61-63 Flags zur Stempel-IDENTITAET erklaert; Wort "(lexikographisch)" laedt zur String-Lesart ein, Vergleich ist numerisch je uint32 (Probe 1: 1.9.0 -> 1.10.0 gueltig); erster realer Flag-only-Bump wird als Wache-Defekt gelesen werden -> Satz-Ergaenzung an bump_ok. (d) Koeder-F-Beweis prueft nur contains(slurp(lock), kSynthRel) statt Byteidentitaet des Locks vor/nach (eine Zeile macht den Beweis dicht).
ORT: axis_version_lock.cpp:557/:594/:321; test :336
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: contract-Gate vs. ctest-Job-Trennung

### [wj9s9vcmp] 6
GEGENSTAND: NICHT-GEPRUEFT-Deckung des Lens (fuer den Designer als Restrisiko-Liste): Tool nicht ueber offiziellen CMake/Ninja-Weg gebaut (g++-Direktbau in Job-tmp; J-1..J-4-Vollbau-Weg nicht gefahren); ctest-TU nicht kompiliert/ausgefuehrt; CI-Job nicht live; 158er-Vollstaendigkeit gegen golden-grep-Baseline nicht unabhaengig nachgezaehlt; sha256/ctsha.hpp + algo_semver-Grammatik als gegeben; TOCTOU discovery-vs-digest (Datei zweimal gelesen) im Worktree mit parallelem Bau-Agent nicht untersucht; strtoull-Saettigung ohne ERANGE (:173-177) nicht gefahren; Windows/CRLF nicht geprueft; 30 digest-only-Eintraege nicht einzeln gegengehalten; Stand nach ~07:09 (paralleler Bau-Agent) ausserhalb des gelesenen Stands.
ORT: Lens nicht_geprueft-Listen aller drei Achsen
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Abgleich mit Stand des Bau-Agenten (bau/s7-algo-hardware-stempel bzw. Riegel-Stand KON58 "718 Records" -- Diskrepanz 158 vs. 718 klaeren)

# QUELLE 8: ww231ccuy.json (P2-P8-Katalog + P3-Trigger-Reste, Stand 06.08. ~14:52; 2 Agenten, 448.074 Tokens)

Kontext: Ledger rueckwaerts ab Z.4202 + Register 20260806-REGISTER-todo-konsolidierung-14-tage.md + Code ce development=e7aa1244. WARNUNG: Stand 06.08. -- mehrere Posten sind durch spaetere Arbeit (xlsx-Writer A9-S3 am 08.08., B14-Landungen, KON-Stufen) moeglicherweise ueberholt; Teil b selbst korrigiert Teil a an mehreren Stellen. Teil b = Plan-Doc docs/plaene/20260806-PLAN-katalogposten-p2p8-und-trigger-reste.md (729 Z., damals NICHT committet).

### [ww231ccuy] 1
GEGENSTAND: B5 Mess-Schnitt-Fenster (T6-Einsammel-Naht + Doppelzaehlungs-Regel, Posten-68 Option B strikt): P2-Pflicht, keine Bau-Spur im Quellcode (nur Doku-Referenz architektur-ziele-offene-punkte-ledger.md:41). Namenskollision dokumentiert: B5 (Mess-Schnitt) != B-5-Lebend-Check (P4).
ORT: ce; Ledger Z.5696
STATUS LT. QUELLE: offen (K-1; "nicht vor Trigger leistbar")
ABHAENGIGKEIT/FLAECHE: T6-Naht gekoppelt an Posten 89; CI-YAML-Flaeche

### [ww231ccuy] 2
GEGENSTAND: G-E3 Host-Binder: 3 Iterator-cfg-Felder mess_bestand_doc_key/mess_bestand_key_of/mess_bestand_versions haben 0 Konsumenten (selbst nachgemessen: grep ueber libs tests = 0 Zuweisungen); Schreiber existiert seit dcbaa728 (messwert_registrierung.hpp, verdrahtet cache_engine_builder_iterator.hpp:1667-1669/1871/2565-2571) aber ist toter Code ("alle leer => nichts geschieht"); Genus-1-Pendant bestand_key_of ist dagegen durchgereicht (profile_run_facade.cpp:723 -> profile_run_entry.hpp:650).
ORT: ce cache_engine_builder_iterator.hpp; bestandslog/messwert_registrierung.hpp
STATUS LT. QUELLE: offen (K-2, real offen, blockiert produktive Messwert-Lagerhaltung)
ABHAENGIGKEIT/FLAECHE: EIN-SCHREIBER-KONFLIKT: dieselbe Datei wie B14/KF-6 (kLbufBytes) und T2-A

### [ww231ccuy] 3
GEGENSTAND: xlsx-Geruest: Owner "B12 xlsx-Writer: waehrend des Voll-Baus bauen, VOR Messbeginn fertig, UND mit in die Abgabe"; am 06.08. NUR Soll-Design (20260803-a9_xlsx_writer_f3_soll_design.md), kein Code; Teil b eskaliert: Soll-Design verlangt zwei zu vendorende Bibliotheken (ext/io/zlib, ext/io/libxlsxwriter) + Writer/CLI/Tests/CI -- "Der Satz muss zurueckgemeldet werden."
ORT: ce docs/architecture/20260803-a9_xlsx_writer_f3_soll_design.md
STATUS LT. QUELLE: offen am 06.08. (K-3b) -- STALE-VERDACHT: A9-S3-xlsx-Writer wurde am 08.08. gebaut/gelandet (ce 60e03d66/61730ff4, Quelle w50k74cln); Designer muss Ist-Stand pruefen
ABHAENGIGKEIT/FLAECHE: Owner-Frage 3 (faellt "xlsx mit in die Abgabe"?); Memory: xlsx IST DIE AUSGABE

### [ww231ccuy] 4
GEGENSTAND: E14 NoFilter-Blatt = Identitaet: Owner-GO vormittag-22 ("E14/Nofilter volles go - die Eingabe ist einfach die ausgabe") zog E14 von NACH-ABGABE auf P2-Bau vor -- Register stale; grep NoFilter ueber libs tests = 0 Treffer, gar nicht gebaut trotz GO. Registry-Erweiterung bricht golden-320 -> Kollision mit golden-XML-Stand (B14).
ORT: ce; Ledger Z.5410/:5415
STATUS LT. QUELLE: offen (K-4; "vor Trigger nur um den Preis eines golden-Neuankers")
ABHAENGIGKEIT/FLAECHE: Owner-Frage 1 (E14 vor Trigger mit golden-Neuanker oder danach?); T17-Min/Max bleibt andere Terminklasse

### [ww231ccuy] 5
GEGENSTAND: Posten 89 T6-Rebound-Leaf-Einpreisung: seit Phase B materialisiert fremde T6-Wahl den Rebound-Leaf statt der Fassade -> Allokationszahlen steigen exakt um den Organ-Anteil; "MUSS beim ERSTEN Vergleich gegen Alt-Mess-CSV eingepreist werden (sonst Falsch-Regressions-Lesung)"; kein Code-Fund fuer Einpreisung -- reine Auswerte-Auflage.
ORT: ce abi_adapter.hpp:2415-2427 (Rebound-Leaf-Konzept); Ledger Register-Nachtrag Z.376
STATUS LT. QUELLE: offen (K-5, Checklisten-Zeile, Minuten)
ABHAENGIGKEIT/FLAECHE: wirkt auf JEDEN Mess-Vergleich gegen Alt-CSV

### [ww231ccuy] 6
GEGENSTAND: P2-P8-Katalog-Bau (33 neue stat_-CSV-Spalten ueber 14/18 Themen in 7 Posten): Kartierung fertig (dateidisjunkt zu T2-A, additiv, kein ABI-Bruch), Bau NULL begonnen (observable_tier.hpp:62-104 kV3AxisSchema traegt nullptr an Ziel-Slots, kV3FieldCount=8/kV3AxisCount=18 unveraendert). Teil-b-Korrektur: Blocker-Aussage "haengt an B14-ce (BLOCKIERT 16a173f2 [CLU-Konsument])" ist UEBERHOLT -- B14-ce liegt als f577f886 in e7aa1244; P2-P8 ist ENTBLOCKT.
ORT: ce observable_tier.hpp:62-104; Ledger Z.5504-5509
STATUS LT. QUELLE: offen (K-6; ABI-tragend, sperrt die einzige ABI-Spur -- nicht vor Trigger)
ABHAENGIGKEIT/FLAECHE: observable_tier.hpp + abi_adapter.hpp = ABI-Sperre; Owner-Frage 2 (welche P2-Posten duerfen hinter Messbeginn rutschen?)

### [ww231ccuy] 7
GEGENSTAND: Ebene-B-Push (G4/P-A): MinIO-Push gebaut aber INERT ueber COMDARE_STORAGE_CACHE (0 Zuweisungen im Repo) -- kein Bau-Posten, Checklisten-/Variablen-Zeile. NEUER RISS (K-7b, in keiner Liste): artifact_cache.hpp:232-281 from_env() liest den Schalter NICHT, der False-Zweig raeumt Endpoint/Bucket nicht ab -> "INERT" ist nicht hart garantiert (~1h Fix). P-C measure_out ERLEDIGT (experiment_plan_director.hpp:1015-1020/1379-1386).
ORT: ce artifact_cache.hpp:232-281; experiment_plan_director.hpp
STATUS LT. QUELLE: teilweise (P-C erledigt; P-A-Scharfschaltung + K-7-Riss offen)
ABHAENGIGKEIT/FLAECHE: Owner-Frage 4 (Trigger-Lauf mit gesetztem COMDARE_STORAGE_CACHE + MinIO-Variablen? vom Repo aus nicht entscheidbar); .gitlab-ci.yml-Flaeche

### [ww231ccuy] 8
GEGENSTAND: G1 Lager-Gate (#27 B/C/D + amd24) = ECHTER BEFUND VERLORENER BUCHFUEHRUNG: seit 23.07. kein Schliessbeleg in vier Ledgern; Teil b loest die Kennung auf (20260723-SESSION-mittag-neustart-zug-vollbau4.md:117 + Ledger :4074: B/C/D = gn_out-Persistenz Teil B/Cancel-trap/K-Label; amd24 = Thread-Budget prod2 24T); "muss vor dem Trigger entweder explizit geschlossen oder bewusst als 'in G2/G3 aufgegangen' deklariert werden".
ORT: super docs/sessions/20260723-*; Ledger :3474-3476/:4074
STATUS LT. QUELLE: offen (S-4: -> OD-7 + Trigger-Checklisten-Zeile)
ABHAENGIGKEIT/FLAECHE: Lager-Gate-Komplex

### [ww231ccuy] 9
GEGENSTAND: E8 PMC-Beleg-Form wird vom VIEL SCHAERFEREN PMC-Sperrposten ueberholt: -DCOMDARE_ENABLE_PMC=ON haengt nur an ZWEI Job-Namen statt an einer Vollstaendigkeits-Invariante; die dynamische Kette emittiert es an KEINER der vier Stellen (experiment_plan_director.hpp:841/877/1194/1342); PMC-Preflight #37 hat Exit-0-Honest-Skip, der "lauter 0-Zaehler" durchwinkt; ohne Flag gibt es auf Linux GAR KEINE PMC-Quelle (Header-Guard #if defined(COMDARE_ENABLE_PMC) && defined(__linux__)). Explizit Owner-Entscheid vor Phase 6 (Register-Nachtrag Z.4416-4419, drei Teile). Neuvalidierung nach PMC-Fix: Flag = eine Zeile, 131.072-Zellen-Matrix = mehrtaegig.
ORT: ce experiment_plan_director.hpp:841/877/1194/1342; Ledger Z.4506-4532/4347-4396
STATUS LT. QUELLE: offen (S-3: E8 wird Unterzeile des PMC-Owner-Entscheids)
ABHAENGIGKEIT/FLAECHE: heisseste Datei experiment_plan_director.hpp (Kollision G-E3/G1/Ebene-B-Push/K-9); Abgleich mit w20ado9k1 (PMC seit F9 Pflicht + I-PMC-1-Invariante -- moeglicherweise inzwischen geheilt, Designer prueft)

### [ww231ccuy] 10
GEGENSTAND: OD-7 Runner-Zahlen: HEAVY bereits konform (prod1 24 -- ACHTUNG: Memory 13.08. sagt prod1 = 16 Kerne/32 Threads, KON28-01 HEAVY_J 24->16; dieser 06.08.-Stand ist UEBERHOLT), NORMAL weicht ab (runner-mode.sh:43-44 NORMAL_CC=4/NORMAL_J=4, Soll 2x12); Register-Widerspruch "3/2+16" war selbst STALE. OD-7-Chronologie: NORMAL-Abweichung stammt aus Owner-Hinweis 27.07. (0d7c577), von Owner-Wiederholung 06.08. ueberholt -- "beide Aussagen gehoeren in dieselbe Zeile, sonst liest man Missachtung, wo eine Ueberholung stattfand."
ORT: Cluster/scripts/runner-mode.sh:43-44; Handout 20260806-HANDOUT-od7-runner-direktive-infra.md
STATUS LT. QUELLE: teilweise (an Infra delegiert; Livecheck offen = #22(i) laut w1pm0nio7)
ABHAENGIGKEIT/FLAECHE: KON58-03/KON28-01/KON26-05 (spaeterer Stand); Voll-Bau-4-Trigger

### [ww231ccuy] 11
GEGENSTAND: O-3 Loesch-GO: Owner hat GO NACH dem Register erteilt (Ledger Z.5221 verbatim: "O-3: Das Loeschen ist freigegeben, sofern alte Version commitet und gepusht.") -- Register-Status "OFFEN (by design)" stale; Gate-Zustand = "GO ERTEILT (bedingt, Vollzug aussteht)".
ORT: Ledger Z.5221/:527
STATUS LT. QUELLE: teilweise (GO erteilt, Vollzug ausstehend)
ABHAENGIGKEIT/FLAECHE: Lager-Pruning verify_remote_then_prune

### [ww231ccuy] 12
GEGENSTAND: Weitere Teil-b-Befunde: (a) S-2 Lager-Kaskaden ERLEDIGT (lager_pfad_grammatik.hpp 574 Z., lager_baum_writer.hpp 610 Z., Beweise test_lb0) -- nur xlsx-Geruest bleibt; (b) KORREKTUR am juengsten Ledger-Eintrag nachmittag-10 F ("Beweise reichen nur bis LB-1"): test_lb0_lager_pfad_grammatik.cpp traegt 33 Makros = 16 Lb0 + 11 Lb2 + 6 Lb3 inkl. Lb3Einlagerung-Test :542 -- Beweise reichen bis LB-3, tragen nur nicht den erwarteten Dateinamen; (c) S-1 KF-6 NTTP-Codegen aus Trigger-Band gestrichen: golden-<organ_subaxes>-Block ist inert (0 Treffer im ce-Parser, XML sagt es selbst :299-303) -> nach Abgabe; (d) Methodik-Vorbehalt: beide Codex-Threads mit bwrap-Fehler (Permission denied) -- Negativ-Aussagen formal unbelegt, tragende Null-Befunde selbst per /usr/bin/grep nachgemessen (deckt sich mit Memory CODEX-LENS-Regel); (e) Disjunktheit: gleichzeitig fahrbar K-2/K-9/K-13/K-1; echte Ein-Schreiber-Flaechen experiment_plan_director.hpp und .gitlab-ci.yml.
ORT: wie genannt
STATUS LT. QUELLE: gemischt (siehe je Teilpunkt)
ABHAENGIGKEIT/FLAECHE: Vier Owner-Fragen des Plan-Docs (E14/P2-Rutsch/xlsx-Abgabe/COMDARE_STORAGE_CACHE)

# QUELLE 9: wsmsmgp8o.json (B14-NB3: CMake-Wachen-Heilung super + ce-Nachbesserung scan_field_sum; 2 Agenten, 640.594 Tokens; Stand 06.08.)

### [wsmsmgp8o] 1
GEGENSTAND: super-Teil B14-NB3 abgeschlossen: Selbstbau-XML-Regex-Parser ERSATZLOS durch xmllint ersetzt (alle 6 Codex-Befunde eine Wurzel: CMake-Regex ohne Lexikalzustand); netto -192 Zeilen; neue gemeinsame Basis Code/tests/xml_canonical_utils.cmake; alle 6 Befunde reproduziert-JA mit Biss-Paaren (ALT 0 -> NEU 1 je Defekt; Kontrolle 1->1); vier NB2-Bisse brechen nicht; Gates: fixture_sync 5/5, da_unit -j3 und -j1 je 151/151, xmllint 4/4, ASCII 0, TABU 0. Commit 1ba29b63 auf b14-golden-kf6, kein Push.
ORT: /home/comdare/wt-b14-golden Code/tests/{xml_canonical_utils.cmake,fixture_schema_subset_check.cmake,golden_n_consistency_check.cmake,CMakeLists.txt}
STATUS LT. QUELLE: behoben@1ba29b63 (Landung damals offen)
ABHAENGIGKEIT/FLAECHE: NB2-Zusage "kein xmllint-Zwang" zurueckgenommen -- xmllint jetzt Pflicht-Dependency (FATAL, kein Skip)

### [wsmsmgp8o] 2
GEGENSTAND: ZUSATZBEFUND: all_axes_golden.profile.xml ist KEIN wohlgeformtes XML -- `--` in drei Kommentaren (Z. 62/64/207), libxml2 lehnt komplett ab; alte Wache lief darauf gruen; Defekt nur im Kommentar-TEXT. Datei gehoert ce -> nicht angefasst; stattdessen PROFILE_ALLOW_COMMENT_TEXT_DEFECT=ON beidseitig verriegelt und selbst-zurueckziehend (Flag AN + roh sauber -> RC=1 "Ausnahme obsolet, entfernen").
ORT: ce all_axes_golden.profile.xml:62/64/207; super Code/tests/CMakeLists.txt (Flag)
SOLL/FIX: ce-AUFLAGE verbatim: "`--` beseitigen, dann Flag entfernen (die Wache erzwingt das dann selbst)."
STATUS LT. QUELLE: offen (ce-Auflage; in w5u7xpiiz/NB4 weiterhin unveraendert wegen Ein-Schreiber-Regel)
ABHAENGIGKEIT/FLAECHE: Ein-Schreiber je Worktree; golden-XML (TABU-Umfeld)

### [wsmsmgp8o] 3
GEGENSTAND: INFRA-AUFLAGE: xmllint-Praesenz auf den baremetal-Runnern ist NICHT belegt, sondern Annahme (grep ueber .gitlab-ci.yml + ci/ + Code/ = keine Fundstelle ausser Kommentaren); Auftrags-Praemisse "xmllint bereits im Einsatz" trifft nicht zu.
ORT: CI-Runner prod1/prod2
STATUS LT. QUELLE: offen (vor Scharfschalten in CI; in w5u7xpiiz weiterhin unbelegt)
ABHAENGIGKEIT/FLAECHE: Infra cluster-read-only

### [wsmsmgp8o] 4
GEGENSTAND: ce-Teil B14-NB3: Lead-Befund A (scan_field_sum-Mess-Validitaetsloch) reproduziert + geheilt -- Alt-Rumpf las bei vier Line-Belegungen (32/64/128/256) immer Stride 64; Heilung: Line aus cacheline_subaxis_line_bytes() der CRTP-Basis, bewusst NICHT ueber line_bytes_of<> (dessen Fallback-Stufe 3 fiele still auf 64); Anti-Divergenz-static_assert; Formel nach detail::padded_aos_field_sum ausgelagert (line als Parameter, sonst bei 32/128/256 nicht testbar -- Biss: Literal 64 zurueck -> 6 Fehler). BUMP-ENTSCHEID: KEIN algo_version-Bump, mit Beweis-TU (VORHER==NACHHER fuer alle 8 record_size-Werte; heute existiert kein Nicht-64er-Layout -- gebumpt wird erst, wenn eine Variante wirklich andere Line traegt). Wrapper-Audit: genau EINE Huellen-Vorlage ObservableMemoryLayout; Gegenmittel als static_assert(CacheLineLineBytesAware<L>) in detail::layout_scan_stride_bytes (Bau-Regel statt gepflegter Liste). Leck C-iii: Layout-Scan-Puffer bei werfendem Allokator in allen 3 Pfaden geleckt -> detail::ScanBufferGuard (RAII), 4/4 gruen. Alignment bei line=32 GEWOLLT (B32 real messen; max(line,64) waere das Literal durch die Hintertuer). ZUSATZ-BEFUND geheilt: ObservableMemoryLayout::observe_scan trug kLineBytes=64 -- cache_lines_touched (Messgroesse -> CSV) haette permutiert in 64ern gezaehlt; permutiert jetzt 1536/768/384/192. Commits 0680eff1, 1fe3f6a9, 0ae12811, 16a173f2 auf b14-ce-anteil; Gates: 2-Pass-Configure, ctest 2x 410/410, golden 5/5, FROZEN-Zeuge 0fe275bd... unveraendert; kein Push.
ORT: /home/comdare/wt-b14-ce libs/cache_engine/axes/layout/axis_05_memory_layout_{cache_line_aligned,observable}.hpp; anatomy/abi_adapter.hpp; tests
STATUS LT. QUELLE: behoben@16a173f2 (Landung damals offen)
ABHAENGIGKEIT/FLAECHE: 16a173f2 war laut ww231ccuy zeitweise als "[CLU-Konsument]-BLOCKIERT" gefuehrt -- Fortsetzung in w5u7xpiiz (NB4)

### [wsmsmgp8o] 5
GEGENSTAND: OFFENER POSTEN (bewusst NICHT geheilt, Entscheid noetig): Zweites Leck derselben Klasse im Churn-Segment aller drei Pfade -- wirft alloc.allocate bei j>0, lecken blocks[0..j-1] (Freigabe-Schleife laeuft erst nach der Alloc-Schleife); reproduzierbar. Nicht geheilt, weil die Reparatur INNERHALB des gemessenen T6-Fensters liegt: "das ist eine Mess-Entscheidung, keine Bau-Entscheidung."
ORT: ce abi_adapter.hpp Churn-Segment (alle 3 run_workload-Pfade)
STATUS LT. QUELLE: offen (in w5u7xpiiz bestaetigt offen; Begruendung dort auf "bewusst zurueckgestellt, Kosten-Nutzen" umgeschrieben, leckfreie Fassung ohne Fenster-Eingriff skizziert 512 KiB gegen 4 MiB)
ABHAENGIGKEIT/FLAECHE: T6-Mess-Fenster; Owner-/Mess-Entscheid

# QUELLE 10: wnru437uo.json (Build-Graph-Race unter -j32: generated_source_catalog.hpp; 1 Agent, 191.093 Tokens; Stand 06.08.)

### [wnru437uo] 1
GEGENSTAND: LUECKE: fehlende add_dependencies-Kante -- tests/unit/CMakeLists.txt:3431-3454 legt test_experiment_plan_director an, ohne comdare_attach_generated_catalog() zu rufen; TU zieht generated_source_catalog.hpp dreistufig (test_experiment_plan_director.cpp:23 -> experiment_plan_director.hpp:46 -> profile_run_entry.hpp:29); Include-Dir kommt via PUBLIC-Include trotzdem an -> Header "auffindbar, aber nicht geordnet" = Race statt lauter Bruch. Reproduktion: kalt 3/3 (100 Prozent) Fehlschlaege, isoliert 1/1, warm 0/20. Vorbefund Ledger:3641 (02.08.) -- seit 4 Tagen offen. Katalog-Klasse: 1 Luecke von 5 Konsumenten (die 4 anderen haben die Kante); fuenfter Attach-Ruf :4483 auf test_w2_combo_ct_stamp harmlos redundant (Ziel konsumiert Header nicht).
ORT: ce tests/unit/CMakeLists.txt nach Z.3454; cmake/catalog_codegen.cmake:48-60
SOLL/FIX: verbatim Minimalkorrektur EINE Zeile: "comdare_attach_generated_catalog(test_experiment_plan_director)" direkt nach Zeile 3454; Verfuegbarkeit belegt (include :684 vor add_subdirectory :692). Struktur-Haertung empfohlen: Header in eigenen Include-Root ${PROJECT_BINARY_DIR}/generated_catalog/ + INTERFACE-Ziel, das Include-Dir UND Ordnungskante zusammen traegt (add_dependencies auf INTERFACE-Lib propagiert nachweislich, Mikro-Projekt-Beleg). BISS: B1 Graph-Assertion (grep build.ninja auf Order-Depends-Zeile), B2 Ordnungs-Beweis isoliert (Codegen-Zeile MUSS vor Scanning-Zeile), B3 Regressions-Biss 3x kalt (heute 0/3, muss 3/3 gruen; Skript /home/comdare/raceaudit/coldloop.sh).
STATUS LT. QUELLE: offen (Bau-Anweisung ohne Rueckfrage ausfuehrbar; Dringlichkeit MITTEL, kein Mess-Risiko)
ABHAENGIGKEIT/FLAECHE: CI-Gruen ist GELIEHEN: test:unit wird durch COMDARE_TEST_PREBUILD_TARGET "comdare_anatomy_codegen_cli comdare_profile_run_facade" maskiert (kam 26.07. aus anderem Grund/G4a) -- "Das Gruen beweist die Kante also nicht -- es verdeckt sie"; Prebuild-Kuerzung braeche test:unit auf jedem kalten Runner

### [wnru437uo] 2
GEGENSTAND: Nebenbefunde: (a) is_original-Klasse (13 comdare_paper_*_codegen + Umbrella): Kante flaechendeckend ueber drei Mechanismen, ABER vollstaendige per-TU-Gegenpruefung NICHT geleistet -> UNBELEGT (empirisch brach kalt nie an is_original). (b) 4 von 406 comdare_tests-Zielen aus ninja all NICHT erreichbar (test_profile_roundtrip + 3 Registry-Gen-Tools, alle EXCLUDE_FROM_ALL; Gen-Tools nur als String-Argument $<TARGET_FILE:...> referenziert = prinzipiell keine Abhaengigkeit; CI gedeckt via COMDARE_TEST_BUILD_TARGET comdare_tests; nur ninja all + ctest nicht) -- Doku-/Handbuch-Befund, keine Race. (c) Cold-ICE: KEIN Zusammenhang belegbar, Vermutung zu verwerfen (andere Signatur; Wurzel laut reference_ci_runner_ice_cold_cache_instability behoben). (d) Super-Baum: kein Build-Zeit-Codegen, keine Katalog-Konsumenten.
ORT: ce tests/unit/CMakeLists.txt:1527-1592/:4698/:4728/:4743; Memory-Referenz
STATUS LT. QUELLE: teilweise/nur-hinweis
ABHAENGIGKEIT/FLAECHE: Memory VOLLBAU-LUECKEN J-1..J-4 (Werkzeuge zuerst, RE-CONFIGURE)

# QUELLE 11: w5u7xpiiz.json (B14-NB4 VOLL: ce-CLU-Blocker + ALLE super-Befunde beider Lenses; 1 Agent, 455.929 Tokens; Stand 06.08.)

### [w5u7xpiiz] 1
GEGENSTAND: WIP-Uebernahme mit 3 im WIP gefundenen echten Defekten: (1) Vergiftung nicht klebrig (note_line_unit_ setzte Einheit je Beitrag neu -- Folge (64,128,64) meldete am Ende wieder 64; geheilt mit stickem Flag, nur reset() hebt auf, Biss G); (2) stiller Fallback: neue 5-Argument-Signatur liess Organe mit Alt-Form lautlos in observe_scan-Pfad fallen -- compile-harte Sperre + Negativ-Probe D-2; (3) ueberzogene Kommentar-Zusage observe_real_footprint ("vergleicht WIRKLICH") -- Reichweite ehrlich benannt. CLU-Heilung Weg (ii): kV3AxisSchema[5][5] war reservierter nullptr-Slot (T2-Praezedenz [2][6] indirect_steps), sizeof==1344 unveraendert, KEIN ABI-Major-Bump, additiv genau eine CSV-Spalte -- ausgewiesen als additive Beruehrung eines TABU-gelisteten Artefakts. Pflicht-Biss: CLU invariant 16 Prozent ueber B32/B64/B128/B256 (ALT: 8/16/33/66); je Fall cache_lines*line_bytes==49152; ohne Einheit -> source-unavailable, Wert 0.
ORT: /home/comdare/wt-b14-ce (b14-ce-anteil ab 16a173f2): Commits c1c76c87, a402cfbc, bfa75431, 4b38d072
STATUS LT. QUELLE: behoben (Commits lokal, NICHT gepusht)
ABHAENGIGKEIT/FLAECHE: TABU-Beruehrung + codegen-Minor-Bump = zwei Lead-Entscheide (Posten 3)

### [w5u7xpiiz] 2
GEGENSTAND: EIGENER ZUSATZ-BEFUND (tragend): ohne Hebel waere die CLU-Heilung am Messobjekt wirkungslos -- dll_is_current vergleicht nur .fingerprint, der sich durch den Commit nicht bewegt -> vor NB4 gebaute Major-8-DLL wird still geskippt, schreibt nichts in [5][5], Host meldet CLU fuer den ganzen Lauf n/a (wortgleich W10-M2-Begruendung). Fix: kCebContractCodegenMinor 8.0 -> 8.1 (keine Versions-Luege, 8.0-Basis existiert). Kosten ehrlich: einmalige Bucket-Invalidierung -- "vertretbar solange der Voll-Bau aussteht; existiert zur Landung ein schuetzenswerter Bestand, ist das ein Owner-Entscheid (Ort im Decl-Header benannt)."
ORT: ce Decl-Header (kCebContractCodegenMinor); Commit a402cfbc
STATUS LT. QUELLE: behoben@a402cfbc; Owner-Entscheid bedingt offen (falls schuetzenswerter Bestand zur Landung existiert)
ABHAENGIGKEIT/FLAECHE: Lager/Bucket-Invalidierung; Memory "Invalidieren=Ziel"

### [w5u7xpiiz] 3
GEGENSTAND: super-Befunde B1-B11 beider Lenses geheilt (Ausnahme-Lexer quote-bewusst B1; XPath an Wurzel gebunden B2; stderr an allen 4 Aufrufen fail-closed auch bei RC 0, keine Musterliste B3; Skip-Marker interpolationsfrei verankert B4; Duplikate beidseitig abgelehnt B5; B6 dialekt-differenziert; 2^17-Behauptung: Kanon wirklich geprueft -DEXPECTED_N=131072 B7; Tool-Pruefung zuerst B8; MASTER Pflicht B9; B10 Teil 1 Newline; B11 "Double hyphen within comment" muss auf stderr stehen). B6-KORREKTUR der Vorlage: active/active_axes NUR im thesis_profile-Dialekt raum-wirksam (profile_to_tree.hpp:65,81); im comdare_experiment-Dialekt ist active INERT (XSD: "NIEMAND wertet es aus") -- Achse dort herauszurechnen waere selbst ein neuer Defekt; stattdessen beidseitiger Stolperdraht mit dialekt-eigener Begruendung. Commits super 2c631551 + 9934a7e5 auf b14-golden-kf6 ab 1ba29b63. Gates: ce ctest 2x410/410 + golden 5/5 + ctest -L b14 2/2 (Label-Fix literal belegt); super fixture_sync 5/5, da_unit 151/151 (j3+j1), xmllint 4/4, echte Traeger: 18 Achsen, Produkt 131072 = cap = Kanon; FROZEN 0fe275bd... unveraendert, 17148e5a 0 Treffer; clang-format STEHT AUS (nicht vorhanden) -- "ehrlich, nicht gruen gemeldet".
ORT: /home/comdare/wt-b14-golden + /home/comdare/wt-b14-ce
STATUS LT. QUELLE: behoben (lokal, nicht gepusht)
ABHAENGIGKEIT/FLAECHE: -

### [w5u7xpiiz] 4
GEGENSTAND: NICHT GEHEILT (4 Posten) + 2 Lead-Entscheide: (1) B10 Teil 2 Basis-URI der Scratch-Kopie (relative externe Pfade loesen gegen SCRATCH_DIR auf; B3-Riegel faengt die Wirkung, URI-Frage offen -- Posten). (2) Zweites Churn-Leck ce (bewusst zurueckgestellt, Mess-Entscheidung). (3) ce-Auflage all_axes_golden.profile.xml `--` in 3 Kommentaren unveraendert (Ein-Schreiber-Regel). (4) xmllint auf CI-Runnern weiterhin unbelegt (Infra). LEAD-ENTSCHEIDE: codegen-Minor-Bump (Bucket-Invalidierung -- frei solange kein Voll-Bestand) und additive kV3AxisSchema-Beruehrung (Praezedenz vorhanden, sizeof-neutral, aber TABU-gelistet).
ORT: wie genannt
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: identisch mit wsmsmgp8o Posten 2/3/5

# QUELLE 12: wbd3zs3qy.json (B14-Kleinst-Nachbesserung: 2 Fable-Review-Restpunkte wt-b14-golden; 1 Agent, 78.805 Tokens; Stand 06.08.)

### [wbd3zs3qy] 1
GEGENSTAND: Fixup d8073913 auf b14-golden-kf6 (ab HEAD 6558c4ae): F1 falsche golden-320-Aussage korrigiert -- Datei behauptete "17 Faktoren" und "persistence_target kommt in jenem Katalog gar nicht vor"; lebende Quelle source_catalog.hpp:144: golden_320_catalog = CatalogAxes<4,1,1,1,4,5,1,4,1,1,1,1,1,1,1,1,1,1> = 18 Faktoren inkl. persistence_target (K=1, Q-10b), cache_engine_axis_registry.xml:126 golden_wired="true"; stale Zweitquelle tools/axis_registry_gen/main.cpp:45-49 in der XML ausdruecklich als NICHT MASSGEBLICH gekennzeichnet (selbst aber NICHT korrigiert -- liegt in ce, Ein-Schreiber-Regel). Produkt bleibt 320.
ORT: /home/comdare/wt-b14-golden Code/test_data_xml/experiment_golden_kern.xml (+32/-4, nur Kommentartext); ce tools/axis_registry_gen/main.cpp:45-49 (stale, offen)
STATUS LT. QUELLE: behoben@d8073913 (XML-Seite); ce-Kommentar-Nachzug offen
ABHAENGIGKEIT/FLAECHE: Ein-Schreiber-Regel; Bau-Matrix byte-identisch (line_size-Faktor 4, 4 x 2^17 = 524288)

### [wbd3zs3qy] 2
GEGENSTAND: F2 Auflage (D) vervollstaendigt -- Luecke war GROESSER als gemeldet: Review meldete eine fehlende Zeile 606; am Ist traegt abi_adapter.hpp DREI strukturgleiche Pfade mit je DREI 64-Literalen (run_workload 462/464/528; _segmented 562/563/606; _segmented_v2 693/694/913 -- Pfad fehlte ganz); alle identisch kRecords=16384, kRecordSize=48, kLbufBytes=kRecords*64. Auflage (D) existierte nur in der Commit-Message von 6558c4ae (keine committete Auflagen-Doku) -- steht jetzt dauerhaft im Baum in der XML, deren line_size=256-Deklaration den Ueberlauf scharf stellt; neue Message supersediert den (D)-Block explizit. F3: korrigierte Zahl (16384-1)*256+4 = 4194052 mitgefuehrt; Faktor-4-Overrun-Schluss unveraendert.
ORT: ce anatomy/abi_adapter.hpp:462/464/528/562/563/606/693/694/913 (Zeilenanker in der XML dokumentiert)
STATUS LT. QUELLE: behoben@d8073913 (Dokumentation der Auflage); die 64-Literale selbst = ce-Auflage (D), Vollzug in B14-ce-Strang
ABHAENGIGKEIT/FLAECHE: Gates nach Commit: fixture_sync 4/4, da_unit 115/115, xmllint 4/4, ASCII 0, TABU 0; 3 Commits unpushed. NICHT angefasst (bewusst): F4-Notizen (12 vs. 15 TEST()-Faelle, (B)-Formulierung) und stale ce-Kommentar

---
# BILANZ LESER 10

12 von 12 Batch-Dateien vollstaendig gelesen (Struktur-Survey + Result-Dumps + gezielte Vollpassagen; grosse Spezifikations-/Audit-Texte ueber Header-Navigation vollstaendig auf Fund-tragende Abschnitte ausgelesen). 109 Extraktions-Posten (gezaehlt: grep -c '^### \[' = 109). Groesste Konflikt-/Stale-Hinweise fuer den Designer: (1) B14-/P2P8-/OD-7-Quellen sind Stand 06.08., mehrfach durch spaetere KON-Stufen ueberholt (explizit markiert); (2) wj9s9vcmp prueft Riegel-Stand 158 Records vs. KON58 "718 Records"; (3) w20ado9k1-Thesis-Branch b-thesis-o4-nachzug/aa97bffc ist landebereit aber ausserhalb der bekannten Branch-Liste; (4) wb8p02wqu-Entscheide D-1..D-7 teilweise durch Owner-Antworten 10.08. beantwortet -- Abgleich Pflicht; (5) checkpoint_measure-Endfassung (wo8yyv72t) nennt als einzige Bau-Blocker Entscheid 2 (Slot-Zahl-Quelle) + gemeinsame Mess-Bibliothek.

SELBSTCHECK: Diese Datei ist ASCII-only (geprueft per LC_ALL=C grep -P '[^\x00-\x7F]' = 0 Treffer); alle Posten tragen GEGENSTAND/ORT/STATUS; keine Platzhalter-Abschnitte.
