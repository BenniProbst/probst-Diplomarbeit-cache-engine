# DESIGN #91 -- UNIFIKATIONS-DESIGNPLAN "GEMEINSAME MODUL-STEUERUNG DER CEB" (M0-M14)

Datum: Do 20.08.2026 frueh (K16-Restweg, Owner-GO autonom). Auftrag: Task #91 (KON113-03; Quelle
Teil 2+3 der Gesamtkonsolidierung = KON112-Anlage, wf_fab57002). READ-ONLY-Design, kein Code.
KON108-02-Auftrag: die drei parallelen Designplaene (heuristik/ + builder/curve_fit+
decision_lambda_trees + best_binary_selector-Haelfte-B) sind EIN STACK AUS 3 KOMPONENTEN; die
Unifikation verlangt eine GEMEINSAME MODUL-STEUERUNG DER CEB. Die Par.75-Sperre faellt erst MIT
diesem Design (KON108-02/KON109-01) -- Abschnitt 7 vollzieht das foermlich.

>> [20.08.v2] ENDFASSUNG v2: die 4 Lens-Fixes + Stand-Marker sind eingearbeitet (Ein-Lens-
>> Review "TRAEGT_MIT_FIXES", k91-lens-endergebnis-wuelpz3ay + L1-Landung). Markerform: alle
>> Zeilen ">> [20.08.v2 ...]" und "[E 20.08., ...]" sind datierte Fortschreibungen AM ORT;
>> kein Originalwort ist geloescht, alte Zahlen bleiben daneben lesbar. Landung nach
>> docs/plaene macht der Lead.

STAND-MARKER-BLOCK (20.08.2026 abends; Quelle: Lens-Verdikt + L1-Landung; Anker stichproben-
weise am ce-Baum super-Submodul, dev 196a621a, NACHGEMESSEN, read-only):
- S1 LANDUNG: dev = 196a621a (development). #15-Bruch GELANDET via Merge ea7df79b "Preimage-
  Bruch KOMPLETT (Format 6, Layout 7, GliedCount 11)"; L1-Serie ba33b9ac -> 196a621a =
  64 Commits (62 Zweig-Commits + Merge + T-B Lock-Regen; heute gezaehlt). Damit ist die
  #7/S-19-Freigabe WIRKSAM (Wellenplan 23.0) und Slot W2-A startbar. Der MESSSTAND des
  Kerntexts (ba33b9ac, "FIX-KOMPLETT UNGELANDET") ist Mess-Historie vom 20.08. frueh.
- S2 I-4 VOLLZOGEN (heute nachgemessen): kAnatomyVersionLinesLayout = 7
  (anatomy_module_abi_v1_decl.hpp:320); kAnatomyFingerprintFormat = "fingerprint_format=6"
  (anatomy_fingerprint.hpp:188); kAnatomyFingerprintGliedCount = 11 (:854; build_version-
  Glied [10]); Budget 6186 (static_assert :952; Fortschreibungs-Absatz :89-91 sauber
  gepflegt). Die Kerntext-Zahlen "Layout 6->7 + Format 4->5 + 10. Glied" waren KON118-
  Rezept-Stand; die Voll-Abnahme (#102/B-9) erweiterte den Bruch um +1 Glied/+1 Format
  (Commits 24f549d0 B-9, 792b61e3 Testnachzug; d4-Vollmengen-Pin Format 6 = 0660a06d,
  T-C XML-Wohlform = af0f251a).
- S3 I-6 VOLLZOGEN (nachgemessen): kWorkModeCount = 4 + kWorkModeRegistry REAL GEBAUT
  (include/cache_engine/measurement/run_methodology_registry.hpp:72/:110/:128) -- nicht
  mehr nur Kommentar-Spur.
- S4 I-3 VOLLZOGEN im #15-Umfeld (Klasse-A-Pfad; nachgemessen): XSD traegt Verbund1_CeOnly/
  Verbund2_Replace/Verbund3_Union (experiment_schema.xsd:253-255; fulljoin = 0,
  Stufe1_CeOnly = 0, Token "union" da); sota_catalog.hpp :648/:652/:656 traegt
  derived_verbund1_ce_only/_2_replace/_3_union, derived_stufe* = 0 Treffer; golden-Regen
  im Landungszug. Klasse A zaehlt real DREI VOLLZOGENE Entscheide.
- S5 W2-F-POSTEN "#102 F6 (Do 20.!)": GEFAHREN (golden-102-Zug in der Landung) und per
  Fix 3 NACHKLASSIFIZIERT als I-4+#102/B-9-Fortschreibung (Marker in Abschnitten 4 und 8).
- S6 M9-DRIFT-WACHE AUFGELOEST: hybrid/README.md:38 ("static_assert ... == 6") stimmt mit
  dem Code ueberein (genus_build_admission.hpp:81 = std::array<std::size_t,6>, :190 =
  static_assert size()==6; Zeilendrift 65->81 / 171->190) -- kein Doku-Nachzug faellig.
- S7 NEUE DOKU-DRIFTS nach der Landung (Nachlande-/W2-Doku-Posten, analog README-Wache;
  heute literal nachgemessen): ceb_version_stamp.hpp:71 "GliedCount = 10 seit S-6a/
  KON45-01" (ist 11) | mess_achsen_naht.hpp:186 "heute sind es ZEHN" (ist elf) |
  bestandslog_factory.hpp:87 Laufzeit-Meldung "S-6a/KON45-01 Format 5: zehn" (ist Format 6:
  elf; Verhalten korrekt, Prosa alt) | build_orchestrator.hpp:409 "kAnatomyFingerprint-
  GliedCount bleibt 9" (liest sich als lebende Invariante).
- S8 L2-FENSTERLAGE: das B-2-Fenster ist gefahren; der Stufe2_Hybrid-Namensvorschlag ist
  regelkonform am M12-Sammelzug-Fenster (W2-B) nachreichbar -- keine Owner-Frage (A2.3a-
  Probe unveraendert negativ).
- S9 M12-SAMMELZUG-REST LEBT: publish/markier/ranking/pfadangabe = 0 am XSD (heute
  gemessen) -- der W2-B-Zug bleibt voll bestehen, nur der B-2-Teil ist vollzogen.
- Zeilen-Drifts ohne Sachaenderung (V14-Regel, Anker = Ueberschriften/Bezeichner):
  genus_build_admission 65->81 / 171->190; sota_catalog derive_default_experiment_phases
  :625/:634 -> :635/:644.
- FIX-INDEX (Lens): Fix 1 = Zaehlwerk abgewiesene Kandidaten (Marker in 0(4), 6, 10) |
  Fix 2 = I-2/I-5-Etiketten (Marker in 0(2), 3/M2, 3/M14, 4/B, 4/C, 10) | Fix 3 =
  I-4+#102/B-9-Nachklassifikation (Marker in 4/A, 8/W2-B, 8/W2-F) | Fix 4 = dieser Block
  + Ort-Marker in MESSSTAND/FRISTEN/GATE.

MESSSTAND (heute am Objekt gegengeprueft, nicht uebernommen):
- ce-Haupt-Klon via super-Submodul: `Code/external/comdare-cache-engine`, dev **ba33b9ac**
  (= #17/g2-Landung, Baum-CI 16029 SUCCESS; `git submodule status` heute geprueft). NICHT
  wt-ce-bump15 -- der #15-Bruch (79171599) ist FIX-KOMPLETT UNGELANDET, Voll-Abnahme laeuft
  (Wellenplan 23.0).
  >> [20.08.v2, S1] UEBERHOLT durch die L1-Landung: dev heute 196a621a, #15 GELANDET
  >> (Merge ea7df79b, L1-Serie 64 Commits); "FIX-KOMPLETT UNGELANDET / Voll-Abnahme laeuft"
  >> war der Stand 20.08. frueh und bleibt als Mess-Historie stehen.
- Ledger-Kopf = KON118 (18.08. frueh); danach nur Wellenplan-Paragraphen 21-23.5 (K15/K16),
  keine juengere KON.
- Quelle M0-M14: `docs/sessions/backups/20260817-folge-bu-kontext11/
  20260817-gesamtkonsolidierung-15-kontexte/teil2-unifikations-designplan-skizze.md`
  (+ teil3-task-posten-liste.md, synthese-volltext.md, kon112_ledger_teil.md) -- VOLL gelesen.
- CAVE Zeilenlagen: die Task-Referenz "Z14784-14853" (6 Steuerdocks) liegt heute bei ~16902ff;
  Anker sind die Abschnittsueberschriften (V14-Regel), hier: Ledger-Abschnitt "09.08.2026
  (abends) -- DIE LUECKE IST DOPPELT: auch der STEUERKANAL Planer<->CEB fehlt (Owner)".

FRISTEN-GERUEST (Wellenplan 18.3/18.4): F2 Fr 21.08. = IDENTITAETS-FREEZE (Preimage-/ABI-Layout;
\#15 landet als LETZTER Preimage-Schritt davor) | Bau-TRIGGER Mi 26.08. 06:00 = Vollbau/Flotte
(Korb C; Kampagne Sa 29.08.) | W2 Sa 22.-Di 25.08. (Landung Di 25.) | W4 07.-11.09.
"Identitaets-Umbauten heute kostenlos, ab 26.08. teuer" (KON34-04-Linie; NIE-EINE-FLOTTE-GEBAUT):
ab dem Trigger materialisieren Stempel/Preimages/Schluessel massenhaft in Binaries und Lager --
jede spaetere Aenderung an ihnen invalidiert Flotte und Bestaende.

>> [20.08.v2, S1] Der Satz "#15 landet als LETZTER Preimage-Schritt davor" ist VOLLZOGEN --
>> #15 ist gelandet (ea7df79b); der FREEZE-CHECK Fr 21.08. bleibt der naechste Gate-Schritt.

---

## 0. ERGEBNIS-KERN (Bilanz)

1. **15 Module M0-M14 voll gelesen und je am Objekt gemessen.** DREI Ist-Abweichungen zur
   Skizze: (a) M0 ist nicht "NICHT GEBAUT" -- die CT-Dock-Maschinerie existiert
   (`mess/steuer_dock.hpp`), es fehlt der BETRIEB; (b) M1-Deckungstest ist GEBAUT+GELANDET
   (f3v, KON116); (c) M8-std-only-Spiegelung ist per Ledger-KON111 GEFALLEN -> Selector-MERGE
   in Komponente 3 (die Skizzen-Owner-Frage 1 ist BEANTWORTET und faellt aus der Liste).
2. **8 Identitaets-Entscheide vor dem Trigger** (I-1..I-8, Abschnitt 4) -- davon 3 bereits
   owner-/KON-entschieden und NUR ZU LANDEN (#15-Buendel), 3 in W2 zu ENTSCHEIDEN+BAUEN,
   2 nur FESTZUSCHREIBEN (Bau spaeter).
   >> [20.08.v2, Fix 2 + S1] Arithmetik fortgeschrieben: 3 VOLLZOGEN/GELANDET (Klasse A,
   >> S1-S4) + 2 in W2 ENTSCHEIDEN+BAUEN (I-1, I-5) + 3 nur FESTSCHREIBEN (I-2, I-7, I-8).
   >> Die alte Lesart "3+3+2" zaehlte I-2 in Klasse B -- Umklassifizierung mit Begruendung
   >> in Abschnitt 4 am I-2-Eintrag.
3. **Alles Uebrige ist nach-Trigger baubar** ohne Identitaetskosten (Abschnitt 5, je Punkt
   begruendet).
4. **Owner-Vorlage: KEINE NEUE FRAGE.** Zwei Kandidaten bestehen die A2.3a-NEIN-Probe, beide
   werden in BESTEHENDE Vorlagen eingereiht (#71-Zeile; R-2-Namens-SCHEMA erst bei Bedarf).
   Acht Kandidaten scheitern an der Probe = Owner-Wort liegt (Abschnitt 6).
   >> [20.08.v2, Fix 1] Exakt gegengezaehlt: ELF abgewiesene Kandidaten in ZEHN Punkten
   >> (ein Punkt buendelt L2 + D1). Etiketten in Abschnitt 6: 8x OWNER/KON-WORT LIEGT,
   >> 2x DESIGN-VORSCHLAG AM FENSTER GENUEGT, 1x ROUTING/NICHT-DOPPELN. Die alte Zahl
   >> "Acht" bleibt lesbar und deckt genau die 8 Owner-/KON-Wort-Faelle.
5. **Par.75-Sperre faellt** mit der Modul-Karte in Abschnitt 2: die drei Komponenten sind EIN
   Stack, kein Deprecate-Wettbewerb; physische Verschiebungen bleiben eigene Par.75-Zuege
   (W7/#88), jetzt mit explizitem Ziel (Abschnitt 7).
6. **W2-Bau-Slots-Skizze** in Abschnitt 8 (deckungsgleich mit Wellenplan 18.4/19.2 + F2-Liste
   23.1; Kapazitaets-CAVE 20.7(2) offen ausgewiesen, NIE-KUERZEN-konform).

---

## 1. LEITSAETZE (bindend fuer alle 15 Module)

Aus der Owner-Runde KON108-112 + Ledger-KON111 (std-only-Runde):
- EIN Stack aus 3 Komponenten; die CEB entscheidet STETS die Tier-Binary-Wahl, AUCH fuer
  Hybride (Ledger-KON111-01c).
- Messgeraet = checkpoint_measure ueber w/ma/mi; Kanal-Hierarchie Achse->Genus->w/PROFILER
  (KON110-01/-02).
- Flaeche 3 ist JE NAHT zielverschieden; Steuer-Naht (XML) und Mess-Naht (sparse binary)
  verschmelzen NIE (KON110-01, KON112-02).
- curve_fit-Auswertung NUR auf der CEB zur Laufzeit; volle CEB = DIE Auswerte-Instanz,
  abwaertskompatibel zu Serien-CEBs (KON110-04).
- Performance durch Abstraktion: Kurvenmodelle komponierbar, verify-sweep waehlt je
  Teilbereich, Default-Toleranz +-3% je Parameter (KON110-01).
- GESAMMELT-Regel unverletzlich: Release/Sendungen nur vor/nach der Gesamt-Messung, nie
  waehrend (Steuerkanal-KERN 09.08.).
- Default-Doktrin: constexpr-Defaults, XML ueberschreibt (Korb B-15). XML = WAS/WO/WANN,
  NIE WIE (R-2).
- Emissions-Doktrin: KEINE YAML, zentrales C++23-Bau-Modul, Rakete rueckwaerts, Abschluss =
  Lager-Fund (KON16-18/25; Korb B-17).
- CEB-Auswertungs-Beschleunigung: std::variant ERLAUBT nur in der CEB-Mess-Auswertungs-Zone,
  HW-Detection + SIMD-Einheiten-Reservierung, Planer-NOTIFICATION in bestehender
  Nachrichtenklasse -- KEIN neuer Kanal (Ledger-KON111-02).
- Repo-Rollen: ce = Framework, super = Einstieg; Doku deprecaten, nie loeschen.

---

## 2. DIE GEMEINSAME MODUL-STEUERUNG DER CEB (das Unifikations-Design)

### 2.1 Vier Ringe um EINEN Dispatcher

Die Modul-Steuerung ist der ceb-Traeger-Kern (Skeleton liegt: `libs/traeger/ceb/`, Merge
0817c7bf, heute CMake+README = Einstiegspunkt). Sie ORCHESTRIERT die bestehenden Bauteile,
sie verschiebt sie NICHT (physische Umzuege = Par.75-Zuege, Abschnitt 7):

    PLANER (traeger/planner; S-19-Sim, deterministisch)
      | Steuer-Naht: gefilterte XML-Fragmente hinab, {stop_ram_oob, stop_user_kill};
      | Deltas/Status/Trace hinauf, GENAU EINE OOB = Fertig-Signal; Sync-Barriere
      v
    [R1 STEUER-RING]  M0 Steuerdocks (mess/steuer_dock.hpp, CT-Faltung) + Betrieb (P2)
      v dispatcht
    CEB-MODUL-STEUERUNG (traeger/ceb; EIN Dispatcher, vier Ringe)
      |-- [R2 MESS-RING]     M1 Mess-Naht (IMessVisitor, sparse binary) + M2 Kanalwerk
      |                      (checkpoint_measure -> Kanal-Tags -> Arenen -> Flush an
      |                      Hol-Punkten) ; M3 Serien-Takt vom Planer
      |-- [R3 AUSWERTE-RING] KOMPONENTE 1 = M4 Funktions-Synthese (measurement_curve_loader
      |                      + M5 Kurvenmodell-Factory) -> KOMPONENTE 2 = M7 curve_fit
      |                      (M6-Gewichtungs-Default + XML-Override) -> KOMPONENTE 3 =
      |                      M8 best_binary_selector-B (GEMERGT, Ledger-KON111);
      |                      Substrat: Beschleunigungs-Schicht (variant-Dispatch, SIMD-
      |                      Reservierung, HW-Detection; NUR diese Zone)
      |-- [R4 LAGER-RING]    M10 Bestandslog-Factory Bestand 1-4 + M11 Batch-Pipeline
      |                      (bauen->messen->compare->release, GESAMMELT)
      v
    KONSUMENTEN: M9 Hybrid-Laufzeit (traeger/hybrid, W4) laedt CEB-vorbereitete Artefakte;
    M14 Planer-Ranking-Report; super-Werkzeuge lesen NUR NOCH Lager-Ergebnisse (KON111).
    FUNDAMENT (quer): M12 XML-Grammatik + M13 Begriffs-Alias-Registry (CT).

### 2.2 Der eine Steuerpfad (Konsumkette KON109-01, praezisiert)

XML -> Planer prueft/plant (S-19; profile_ref-Fehlziel = harter Fehler "ERROR", R-4) ->
Steuerdock (nur existierende Befehle, CT-gefaltet) -> Modul-Steuerung dispatcht:
(1) BAUEN (Emissions-Doktrin; Bau-Ende = Lager-Fund Bestand 1) -> (2) MESSEN (M3-Serien;
M2-Kanalwerk fuellt Arenen; Flush -> Bestand 2) -> (3) AUSWERTEN auf der VOLLEN CEB
(M4->M5-Batches -> Bestand 3; M7-Bereichs-Linie; M8-Wahl + Wechselkosten) -> (4) COMPARE ->
(5) RELEASE GESAMMELT (M6-XML-Kriterium nach allen 3 Komponentenstufen; Typ-4-Loesung ->
Bestand 4). Der Hybrid wendet zur Laufzeit die vorbereiteten Profile/Schwellen an und MISST
die Wechsel-Penalty GEGEN -- er entscheidet die Wahl nicht neu.

### 2.3 Selbstkompilations-Anschluss (3/4 -> 4/4)

Bausteine am Objekt: Director (`profile_facade/planner/experiment_plan_director.hpp`) ·
Builder (`builder/bestandslog/planer_driven_build.hpp`, Plan-Stempel-Digest via ctsha512) ·
AxisCommand (`topics/axis_command_base.hpp`). FEHLT: Steuerung->Compile. TRAEGER: exakt
\#24/B4 (Korb B-20: "System B ... B4 = 9 Kern + 8 Ripple = 'Steuerung -> Compile'", W2-Tabelle
18.4: Typliste = statische Anordnungs-Freigabe, anzahl==6 faellt). Damit schliesst die
Modul-Steuerung den Kreis Planer-emittiert-PROZESS ohne YAML.

---

## 3. M0-M14 IM EINZELNEN: SOLL (Quelle) / IST (heute am Objekt) / DELTA / IDENTITAETS-KLASSE

Notation Identitaets-Klasse: [ID/#15] = identitaetswirksam, liegt im #15-Buendel (nur landen) ·
[ID/W2] = identitaetswirksam, vor Trigger entscheiden+bauen · [ID/FIX] = vor Trigger nur
festschreiben · [RT] = nach Trigger baubar ohne Identitaetskosten.

**M0 STEUER-NAHT Planer<->CEB (S-10).** SOLL: gefilterte XML-Fragmente + {stop_ram_oob,
stop_user_kill} -> Deltas/Status/Trace + OOB-Fertig-Signal; Sync-Barriere. IST: CT-Dock-
Maschinerie GEBAUT: `mess/steuer_dock.hpp` ("DER STEUERKANAL PLANER -> CEB: die SECHS
STEUERDOCKS", Befehle=Typen/GoF-Command, Angebot = Faltung aus einkompilierten Instrumenten,
static_assert genau 6 = Nenner im Code; Kopf: Typestate-Fenster, fd-Kanarie, Rechtsakte
Freigabe/Durchsetzung = "Paket P2 ausdruecklich NICHT hier") + `mess/konfiguration.hpp`.
Betriebs-Konzepte am Objekt 0 Dateien (grep stream_out|stummschalt|sync_barriere|
fertig_signal|out_of_band|prioritaetsklasse = 0; Gegenprobe KON112-02 bestaetigt). DELTA zur
Skizze: "NICHT GEBAUT" ist zu grob -- CT-Rahmen liegt (System-B-Umfeld), BETRIEB fehlt.
KLASSE: [RT] Betrieb (reines Laufzeitprotokoll, NIE Mess-Rohdaten, keine Stempel-/Preimage-
Beruehrung; KON50-01). Der statische 6er-Nenner faellt mit #24/B4 in W2 (Plananker KON37-03/
KON34-04-B4) -- CT-Wandel im dormanten Subsystem, KEIN Stempel-/golden-Byte. TRAEGER:
S-10-Rahmen (KON50-03), Korb B-01..B-04/B-14, #24/B4; W2-Design / W3-Bau-Rest ("M0 unabhaengig,
aber vor der Voll-Messkampagne").

**M1 MESS-NAHT CEB<->Tier (Flaeche 3).** SOLL: Signalfunktion -> sparse-binary Messwerte-Stream
nach Flush (Hol-Punkte, Arenen). IST: ABI GEBAUT -- IMessVisitor in 5 Dateien
(`anatomy/mess_visitor_abi.hpp`, `anatomy/observable_tier.hpp`, `anatomy/abi_adapter.hpp`,
`builder/pruef_dock/genus_mess_naht.hpp`, `include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp`);
Deckungs-Test `tests/unit/test_flaeche3_deckung_ceb_aus_tier_an.cpp` GEBAUT+GELANDET (f3v,
KON116-01, CI 15979 SUCCESS). DELTA: der Skizzen-Traeger #20 ist GELANDET; offen bleibt nur
die Doku-Auflage "Vereinigung INTRA-Naht, ZWEI Vertragsformen NIE verschmelzen" (KON112-02)
als #20-Marker. KLASSE: [RT] -- ABI eingefroren (decl.hpp-Aenderungen nur im #15-Slot,
Fessel P3-vor-P5); ORG-19 store()/load() ist ADDITIVE Genus-Erweiterung (Hardware-additiv-
Doktrin) mit AUFLAGE eigener Genus-Kanal im M2-Kanalwerk (#86, KON112-01).

**M2 checkpoint_measure-KANALWERK (P-A/#90).** SOLL: Genus-Kaskade/MK + E(A)-Registrierung
(FJ-2) + Ebenen-Flags/CEB-Gates (C-13.3, EIN Mechanismus) -> Kanal-getaggte Roh-Traces in die
Mess-Arena; Klammer-Default innerste; Arena-Auswertung fuehrt innere Kanal-Klammern auf
aeussere zusammen (C-9-Erweiterung); w-PROFILER buendelt uebers Last-Profil. IST: Arenen
GEBAUT (`builder/measure_storage/checkpoint_measure.hpp`, `mess_arena.hpp`, `stapel_arena.hpp`;
Kaskade `mess/genus_kaskade.hpp`, Naht `mess/mess_naht.hpp`); KANALWERK 0 Treffer (kanal_baum|
kanalwerk|channel_tree = 0). POLITIK-BEFUND am Objekt: `mess_arena.hpp:36` "GEBAUT: ZAEHLEN,
MELDEN, WEITERMESSEN" + UeberlaufBefund/DATENVERLUST-Zeile (:134ff) -- steht gegen KON93/94
harten Abbruch; T-NEU-1-Verdikt: Arena-Ueberlauf-Semantik OWNER>PLAN -> Politik-Nachzug ist
\#90-Pflichtteil, KEINE Owner-Frage. KLASSE: [ID/FIX] fuer das KANAL-ID-/TAG-SCHEMA (I-2:
Tags gehen in persistierte Bestand-2/3-Records und in die xlsx-Legenden; V-13 fixiert die
einzig erlaubte Reihenfolge wallclock/macro/micro) · [RT] fuer den Kollektor-BAU (nach
12W-Explore, #90-Designplan, #53-Strang). TRAEGER: #90 [W1->vor Trigger fuer das DESIGN],
dann #53.

>> [20.08.v2, Fix 2] Etikett BESTAETIGT: [ID/FIX] fuer I-2 ist richtig (= Klasse C, vor
>> Trigger nur festschreiben; Kollektor-Bau nach Trigger). Falsch war die Klasse-B-Fuehrung
>> in Abschnitt 4 -- dort umklassifiziert, Begruendung am I-2-Eintrag.

**M3 CEB-SERIEN-FAHRPLAN (Planer).** SOLL: XML + S-19-Permutationsrechnung -> Serien-CEBs
(Messfuehler-Latenz-Differenz) + kalibrierte Rohwerte. IST: Doktrin 08.08. dokumentiert
(MESSKETTE-Abschnitte); Ableitung `profile_facade/sota_catalog.hpp:625/:634` derive_default_
experiment_phases emittiert UNBEDINGT alle 3 Stufen (:675); ORDNUNGS-Subsystem mess/ traegt
heute 6 Dateien (genus_kaskade, konfiguration, mess_naht, pilot_achsen, pilot_suche_impl,
steuer_dock), AUSWAHL-Subsystem measurement_tooling_registry in 14 Dateien -- beide inert
(System B dormant, KON34). Nenner-Doktrin: Mess-Permutation DYNAMISCH >32, NUR S-19 rechnet
(Owner 15.08.); Zahlen-Historie 6/24/32/12 bleibt Historie. DELTA: keiner zur Skizze.
KLASSE: [RT] -- die Mess-Ebenen-Beschaltung einer Serien-CEB steckt bereits im MESS-Teil des
Stempels (S-6a, im #15); die Serien-POSITION ist kein Stempel-Feld (Messwerte tragen
machine_id/platform-Provenienz, V-10b). S-19 selbst laeuft W2 Sa-Mo VOR dem Trigger und
produziert die B-4-Zahl (#7-Freigabe wird mit #15-Landung wirksam, Wellenplan 23.0);
Serien-Smoke = W3. TRAEGER: #7/S-19, #24/B4, W3.

**M4 KOMPONENTE 1 -- Funktions-Synthese (measurement_curve_loader).** SOLL: Messwert-Tabellen
(RAM, max Threads, Schwelle offen) + M5 + Tracing-Vorgeschichte (Zustands-Dimension) ->
Synthese-Funktionen je Parameterklasse x Tier x Zustand ALS BATCHES in Lager-Typ 3; auf der
VOLLEN CEB (abwaertskompatibel). IST: `heuristik/measurement_curve_loader.hpp` EXISTIERT
(Owner-KERN KON109-01: "der korrekte Einstiegspunkt fuer die Funktions-Synthese");
Batch-/Lager-Anbindung FEHLT (Bestand 3 existiert nicht, s. M10). KLASSE: [RT] fuer den Bau --
UNTER ZWEI VOR-TRIGGER-BEDINGUNGEN: I-1 (Bestand-3-Schluessel) und I-8 (Record-Feldbestand:
Kanal-Tag + Zustands-Dimension + machine_id in Bestand 2/3, sonst kann die Kampagnen-Messung
die Spalten nicht tragen und M4 sie nicht konsumieren). RAM-Verarbeitung ueber maximale
Thread-Zahl: T-vs-T-4 in #71-Vorlage (Abschnitt 6).

**M5 KURVENMODELL-FACTORY.** SOLL: Rohpunkte -> (auch mathematisch KOMPONIERTE) Modell-
Instanzen + Guetemass; verify-sweep waehlt je Teilbereich; Default-Toleranz +-3% je Parameter;
KEIN Bloat auf Kleinst-Messpunkte; subsumiert AxisSpline/PiecewiseCurve. IST: AxisSpline
(`heuristik/axis_spline.hpp`, Konsument measurement_curve_loader) + PiecewiseCurve
(`builder/best_binary_selector/best_binary_selector.{hpp,cpp}`, `builder/decision_lambda_trees/
decision_lambda_trees.hpp`). DELTA ZUR SKIZZE: die "(std-only-Frage offen)" ist GESCHLOSSEN --
Ledger-KON111: Spiegelung faellt ersatzlos, die PiecewiseCurve-Zweitschrift verschwindet mit
dem Selector-Merge; die Factory ist Engine-intern frei (std::variant in der Auswerte-Zone
erlaubt). KLASSE: [RT]; +-3%-Default als constexpr + XML-Override (Default-Doktrin) -- reine
Auswerte-Semantik, kein Stempel/Preimage. Bau-Reihenfolge: M5-INTERFACE vor M4-Vollausbau.

**M6 PARAMETER-FILTER-REGISTRY (#88/P-B).** SOLL: Deep-Research alt (09.07.) + NEU ->
Filter-Katalog (Filter 1 = kuerzeste Gesamtzeit, impact-sortiert), Gewichtungs-DEFAULT an M7,
XML-waehlbares Release-Kriterium (nach allen 3 Komponentenstufen) an Planer/#49. IST: Registry
EXISTIERT NICHT; Vorbild-Katalog `heuristik/axis_optimization_catalog.hpp` mit
kAxisObjectiveCount=45 (:101) + kCatalogAxisCount=19 (:99); die 4 grep-Treffer
"filter_registry|parameter_filter" sind die ORGAN-Such-Filter-Achse (topics/filter/...,
axis_filter_registry) = falscher Freund, NICHT die Sache. Owner hat T-9 als Quelle VERNEINT
(parallele Registry). KLASSE: [RT] -- Katalog-Inhalt ist additiv; das XML-Kriterium-TOKEN
faehrt im M12-Sammelzug (W2). TRAEGER: #88 (Katalog-Skelett W2; neuer Deep-Research gebuendelt
mit SIMD-Research, Ledger-KON111-02d).

**M7 KOMPONENTE 2 -- curve_fit (auf CEB).** SOLL: Typ-3-Bestaende + M6-Default + XML-Override
-> EINE Bereichs-Linie (Ranking-Parameter-Bewertungs-Schnitte) je Last-Profil; erkennt
Optimal-Bereiche (ANZAHL = Dock-Zahl der kleinen Hybride, P-C). IST: `builder/curve_fit/
curve_fit.hpp` EXISTIERT (Alt-Designplan); Bereichs-Linie/Typ-3-Konsum FEHLEN. KLASSE: [RT] --
Laufzeit-Auswertung auf der CEB. RAM-KONTEXT 3 (KON112-04c: dritter RAM-Kontext ohne
dokumentierte Schwelle) -- DESIGN-ENTSCHEID HIER (keine Owner-Frage, Default-Doktrin):
constexpr Warn-Schwelle `auswerte_ram_warn` (Startwert 6 GB analog KON51/52-Politik) +
XML-Override; Ueberlauf-Verhalten = BATCHEN/SPILLEN nach N2-256-MB-Muster, NIE Abbruch
(Auswerte-Kontext ist keine Mess-Reinheit; die Arena-Abbruch-Politik KON93/94 gilt dort NICHT).

**M8 KOMPONENTE 3 -- best_binary_selector-B.** SOLL (fortgeschrieben per Ledger-KON111):
Bereichs-Linie -> Binary-Wahl je Last + Wechselkosten-Abwaegung (Anti-Flattern);
Release-Vorschlag; **MERGE in die CEB-Modul-Steuerung** -- die std-only-Zweitschrift der
Break-Even-Mathematik FAELLT ersatzlos; super-Konsumenten lesen NUR NOCH Lager-Ergebnisse
(Typ 3/4); die CEB entscheidet STETS, auch fuer Hybride. IST: `builder/best_binary_selector/
best_binary_selector.{hpp,cpp}` traegt die ALT-Doktrin (CSV-Leser, Pareto-Front, GoF Strategy/
Builder/Repository); die KON111-UEBERHOLT-Marker (Kopf-Doktrin + decision_lambda_trees.hpp:10-11
+ Ledger-REV-DATA-12) sind am Objekt NOCH NICHT gesetzt (grep KON111|UEBERHOLT = 0) ->
Marker-Nachzug gehoert in den Merge-Zug. KLASSE: [RT] -- Merge ist Struktur ohne Stempel-/
Preimage-Beruehrung; Alt-Datei DEPRECATEN NIE LOESCHEN; der D2c-Umbau (Sieger je Eingangslast)
zieht in den Merge um. TRAEGER: Selector-Merge-Paket (P-I, Ledger-KON111-02-BAU-FOLGEN a).

**M9 HYBRID-LAUFZEIT (HY-C).** SOLL: M7/M8-Artefakte + Typ-4-Loesungen + XML-init-Profile
(P-D) -> Optimal-Bereichs-Binaries in statisch dimensionierte Docks (P-C, Dock-Zahl = Anzahl
Optimal-Bereiche, <=32 Deckel, KEIN Auffuellen); MISST Wechsel-Penalty zur Laufzeit GEGEN;
Lookahead ueber ma x w-Wahrscheinlichkeiten. IST (Identitaets-Seite, heute literal):
`anatomy/anatomy_base.hpp:89` HeuristikAdapter=3 + `:169` FunctionInterfaceReroute=5 (HY-A1
VOLLZOGEN); `hybrid/heuristik_adapter_klassifikation.hpp:79/:84` kAlleGattungen[4] /
kAlleGenera[6] (Einzelquelle); OFFEN am dev: `builder/experiment_tree/genus_build_admission.hpp:65`
kGenusBuildSlotCounts = std::array<std::size_t,**5**> + `:171` static_assert(size()==**5**)
-> 5->6 ist der reale HY-A3-Rest im #15 (KON118; "22->23" war Phantom-Nenner). DRIFT-WACHE:
`hybrid/README.md:38` dokumentiert bereits "static_assert ... == 6" (Vorgriff auf den Bruch;
loest sich mit der #15-Landung, sonst Doku-Nachzug faellig). KLASSE: [ID/#15] fuer
kGenusBuildSlotCounts/decl-Slot/Ebenen-Wrap (V-04R) -- NUR LANDEN; [RT] fuer den gesamten
HY-C-Laufzeitbau (W4; P-C/P-D; #49-Staffelungs-Design VORHER, nach V7-Antwort).

>> [20.08.v2, S1/S6] [ID/#15]-Teil GELANDET: kGenusBuildSlotCounts 5->6 vollzogen
>> (genus_build_admission.hpp:81 array<std::size_t,6> + :190 static_assert size()==6;
>> Zeilendrift 65->81 / 171->190). DRIFT-WACHE AUFGELOEST: hybrid/README.md:38 stimmt mit
>> dem Code ueberein -- kein Doku-Nachzug faellig.

**M10 LAGER-BESTAND 3+4 (#57/P-E).** SOLL: Factory-Erweiterung Par.62-B; Schluessel
machine_id x Stempel/Fingerprint x XML-C14N; Batch-Schreibweg N2-Muster; Ergaenzungs-/
Invalidierungs-Regel (Kernbestand bleibt); Verbund1-Skip je machine_id (R-3+V-10b). IST:
Factory-VORFORM GEBAUT: `builder/bestandslog/bestandslog_document.hpp:9-10` "binary --
Bestand 1 / measurement -- Bestand 2 (Par.62-B Factory Pattern)"; SHA-512-Linie ctsha512
(`planer_driven_build.hpp:27/:32/:243` -- "keine zweite Hash-Wahrheit"); KANONISCHE FORMEN
BESTAND (Bestands-Pflicht erfuellt, kein Neubau): `profile_facade/planner/plan_legend.hpp:75`
canonical_combo (dedupliziert+sortiert = Reihenfolge-unabhaengige Identitaet) +
`builder/bestandslog/planer_block_value.hpp` ceb_key_sha512 (:38/:59); machine_id in 14
Header-Dateien. Bestand 3/4 FEHLEN; Bestandslog NICHT scharf (Korb B-09:
mess_bestandslog_active=false + Planer-Forward-Restliste). KLASSE: **[ID/W2] = I-1, der
Kern-Identitaets-Entscheid dieses Plans** (Begruendung Abschnitt 4). TRAEGER: #57(7)-(9) im
Di-25-Buendel; Export-Beruehrung #18 (Verbund1-Skip-Sichtbarkeit).

**M11 BATCH-PIPELINE-AUSDEHNUNG.** SOLL: 15-Stationen-Kette + Auswerte-Batches;
bauen->messen->compare->release WOERTLICH; GESAMMELT-Regel; volle CEB liest Staende der
Serien-CEBs. IST: work_mode-Ordinal-Dreh {Build=0, Measure=1, Compare=2, Release=3} =
Owner V-12 (KON101), faehrt als A-05 im #15-Bruch (kWorkModeCount=4, Besitzer Planer);
am dev nur Kommentar-Spur (`profile_facade/mess_achsen_naht.hpp:25`). KLASSE: [ID/#15] fuer
A-05 (nur landen); [RT] fuer die Ausdehnung selbst (Prozess-Stationen, keine Identitaet).

>> [20.08.v2, S3] A-05/I-6 GELANDET und REAL GEBAUT: kWorkModeCount=4 + kWorkModeRegistry
>> (run_methodology_registry.hpp:72/:110/:128) -- "am dev nur Kommentar-Spur" ist ueberholt.

**M12 XML-GRAMMATIK-SAMMELZUG (mit #18/#48/#57(6)).** SOLL: publish-Sektion · Verbund-phases
(B-2, bruch-gebunden) · Filter-Kriterium · Hybrid-Strategie-Profile · Markierungs-Grammatik ·
externe-Pruefling-Pfadangabe (#65-Naht) · profile_ref-ERROR (R-4). IST am XSD
(`Code/test_data_xml/experiment_schema.xsd`): PhasesType traegt Stufe1_CeOnly (:253),
Achsen-Tokens {replace,merge,fulljoin} (:333-335); "Verbund" = 0; publish = 0; markier/
ranking/pfadangabe = 0 -- ALLE Sammelzug-Elemente offen. KLASSE: **[ID/W2-oder-#15-Umfeld] =
I-3 NUR fuer B-2** (golden-byte-wirksam; Namen owner-fix per V-11R: PrueflingVerbundStrategy
mit Verbund1_CeOnly/Verbund2_Replace/Verbund3_Union, Token "union" statt "fulljoin"; SCOPE
L5 = BEIDE Ebenen + derived_stufe*-Namen + golden-Regen; NP-15-Wortlaut-Abgleich L3 ZWINGEND
davor; Stufe2_Hybrid-Name L2 als Design-Vorschlag am selben Fenster) · [RT] fuer ALLE
uebrigen Elemente (ADDITIVE Grammatik bricht keine bestehenden C14N-Hashes: neue Elemente
erscheinen nur in neuen XMLs; geplanter Slot bleibt der EINE W2-Zug Di 25.).

>> [20.08.v2, S4/S9] I-3/B-2 VOLLZOGEN im #15-Umfeld: das XSD traegt heute Verbund1_CeOnly/
>> Verbund2_Replace/Verbund3_Union (:253-255; "union" da, fulljoin=0, Stufe1_CeOnly=0);
>> sota_catalog:648-656 derived_verbund1_ce_only/_2_replace/_3_union; golden-Regen gefahren.
>> Der SAMMELZUG-REST (publish, Filter-Kriterium, Hybrid-Profile, Markierung, Pfadangabe,
>> profile_ref-ERROR) bleibt offen und faehrt W2-B; L2-Namensvorschlag dort nachreichbar (S8).

**M13 BEGRIFFS-ALIAS-REGISTRY (R-2).** SOLL: CT-Header; Erst-Eintraege node4, w/ma/mi-Aliasse,
Verbund-Uebergang; Uebersetzen=CT-Fehler; Adapter=Paper-Ausnahme. IST: EXISTIERT NICHT
(find *alias*/*konformitaet* in libs = 0). KLASSE: [ID/FIX] = I-7 als NAMING-STABILISATOR:
Rangfolge-Entscheid DIESES Designs: Registry-Alias VOR Rename-Praxis -- kuenftige Begriffs-
Kollisionen werden per CT-Alias deklariert statt umbenannt; AUSNAHME: owner-gesetzte Renames
(V-11R) vollziehen wie entschieden, die Registry traegt den Uebergang als Alias-Eintrag.
Das Namens-SCHEMA (was ein Ding IST) bleibt separater Owner-Entscheid (KON112-09) -- Vorlage
erst an der ersten NEU-Benennung. Bau: W2-SKELETT ZUERST (Bau-Reihenfolge: Begriffe +
Kanal-IDs sind Fundament fuer alles Messende).

**M14 PLANER-RANKING-AUSGABE (P-H-Haelfte).** SOLL: Markierungen + M6-Kriterien + Lager-Stand
-> Experiment-Ende-Report je markierte Achse x Parameter (default ALLE) mit Ranking-Position;
iterative Tweak-Runden. IST: 0 ranking-Treffer in `profile_facade/planner/` und
`apps/experiment_planner/` -- NICHT GEBAUT; Grammatik fehlt (s. M12). KLASSE: [RT] fuer den
Report (reine Ausgabe; xlsx bleibt DIE Ausgabe, der Report ergaenzt, ersetzt nie);
[ID/FIX] = I-5 fuer die STEMPEL-"FARBEN" der Paper-Prueflinge (D1-Harmonisierung: die neuen
Pruefling-Achswerte erscheinen als ACHSEN-TOKENS im Stempel, KEINE Merge-Zeile -- KON112-08);
Traeger #89 (P-H, W2, gebuendelt #18/S-13).

>> [20.08.v2, Fix 2] ETIKETT KORRIGIERT: I-5 ist [ID/W2] (Klasse B, entscheiden+bauen) --
>> Slot W2-C BAUT real (#89, Stempel-Farben als Achsen-Tokens). Das alte Etikett "[ID/FIX]"
>> in der Zeile darueber bleibt lesbar, gilt aber nicht mehr.

---

## 4. IDENTITAETS-ENTSCHEIDE VOR DEM TRIGGER (Mi 26.08. 06:00) -- TRENNSCHARF

Massstab je Punkt: wirkt er auf (a) Stempel-Tokens/Glieder, (b) Fingerprint-/Preimage-Bytes,
(c) Lager-Schluessel/persistierte Record-Schemata, (d) golden-Bytes, (e) ABI-Symbole/Layout,
oder (f) Namen, die in (a)-(e) einfliessen? Nur dann VOR Trigger; sonst nach Trigger.

**KLASSE A -- entschieden, NUR LANDEN (#15-Buendel = letzter Preimage-Schritt vor F2 Fr 21.08.;
FIX-KOMPLETT @ 79171599, Voll-Abnahme laeuft):**

>> [20.08.v2, S1] KLASSE A IST GELANDET: Merge ea7df79b, L1-Serie 64 Commits; "FIX-KOMPLETT
>> @ 79171599, Voll-Abnahme laeuft" ist Historie. Alle drei A-Entscheide VOLLZOGEN (S2-S4).

- **I-4 HY-A2/A3-Rest + Preimage-Layout**: kGenusBuildSlotCounts 5->6 + static_assert +
  Wachen-Nachzug (KON118-Rezept; Dock-Registry bleibt designfest 5, Reroute-Genus nicht
  ABI-sichtbar); HY-A2 decl-Slot (Map-Zeile, RT<=CT, V-04R Ebenen-Wrap); Layout 6->7 +
  Format 4->5 + 10. Glied + #38d-Budget + #38a2. Begruendung: (a)(b)(e) direkt; jeder Tag
  nach dem Trigger multipliziert die Kosten mit der Flottengroesse.
  >> [20.08.v2, Fix 3 -- I-4 + #102/B-9-FORTSCHREIBUNG, VOLLZOGEN] Endstand der Landung:
  >> build_version-Glied [10], fingerprint_format 6, GliedCount 11, Budget 6186 (Layout 7
  >> unveraendert). Die Zeile "Layout 6->7 + Format 4->5 + 10. Glied" oben war KON118-
  >> Rezept-Stand; die Voll-Abnahme #102/B-9 erweiterte den Bruch um +1 Glied/+1 Format
  >> (24f549d0 + Testnachzug 792b61e3; d4-Pin 0660a06d), gelandet im #15-Zug ea7df79b.
  >> Das #102/F6-golden-Ereignis war nach Massstab (b)(d) identitaetswirksam und wird HIER
  >> gefuehrt, nicht als W2-F-Randslot (Marker dort). Anker nachgemessen: decl:320 = 7,
  >> anatomy_fingerprint.hpp:188 = Format 6, :854 = 11, :952 = 6186 (Absatz :89-91).
- **I-6 work_mode-Ordinale** {Build=0,Measure=1,Compare=2,Release=3} (Owner V-12; A-05).
  Begruendung: (b)(c) -- Ordinale stehen in Registry-Zeilen/Records.
  >> [20.08.v2, S3] VOLLZOGEN: Registry real gebaut (run_methodology_registry.hpp:72/
  >> :110/:128); die Ordinale stehen im Code, nicht mehr nur im #15-Plan.
- **I-3-VOLLZUGSTEIL B-2-Verbund-Umbenennung**, sofern sie im #15-Umfeld faehrt (Teil-3-Vermerk:
  Bruchfenster-Kandidat im #15-Umfeld ODER eigenes Fenster VOR Trigger): Namen owner-fix
  (V-11R), golden-byte-wirksam (d)+(f); L3 NP-15-Abgleich ZWINGEND davor; L5-Scope beide
  Ebenen + derived_stufe* + golden-Regen; L2 Stufe2_Hybrid-Name als Vorschlag am Fenster.
  >> [20.08.v2, S4] VOLLZOGEN im #15-Umfeld -- der "sofern"-Vorbehalt hat sich zugunsten
  >> des Klasse-A-Pfads aufgeloest (XSD:253-255, sota_catalog:648-656, golden-Regen).
  >> L2-Vorschlag am M12-Sammelzug-Fenster nachreichbar (S8).

**KLASSE B -- in W2 ENTSCHEIDEN + BAUEN (Landung Di 25.08., vor Trigger):**
- **I-1 Typ-3/4-Lager-SCHLUESSEL (M10, der Kernentscheid)**: Bestand 3 = machine_id x
  Voll-Stempel(+Fingerprint) x Mess-Ebenen-/Kanal-Referenz; Bestand 4 = XML-C14N-Hash x
  machine_id x Bestands-/Stempel-Referenzen; C14N-Verfahren = FORTSCHREIBUNG der bestehenden
  kanonischen Formen (canonical_combo + ceb_key_sha512 + ctsha512-Digest -- EINE Hash-Wahrheit,
  SHA-512-Linie; kein neues Verfahren einfuehren); Invalidierungs-Regel: Ergaenzung ja,
  Kernbestand bleibt (Owner-Wort KON110-04); Verbund1-Skip prueft Vollstaendigkeit JE
  machine_id, NIE global (L4, V-10b: Bau-SKIP ja / Mess-SKIP nein). Begruendung: (c) pur --
  ab Trigger fuellt die Flotte Bestand 1/2 unter diesen Schluesseln; ein spaeterer
  Schluessel-Wechsel re-keyed das Lager. TRAEGER: #57(7)-(9) + #18-Export.
- **I-5 Stempel-"FARBEN" der Paper-Prueflinge (M14/#89)**: Mechanik-Entscheid = ACHSEN-TOKENS
  im Stempel (keine Merge-Zeile; D1-Harmonisierung nach LANDUNG-HARMONISIERT-Regel; CT-ERROR-
  Pflicht der neuen Achsen nach A13-M3-Muster). Begruendung: (a)(f) -- Prueflings-Stempel der
  Flotte muessen die Tokens von Anfang tragen, sonst zweite Stempel-Generation. TRAEGER: #89.
- **I-2-TEIL Kanal-ID-SCHEMA (M2/#90-Design)**: Kanal-Adresse = Registry-konforme Tokens
  entlang Achse->Genus->w/PROFILER; Reihenfolge-Kanon wallclock/macro/micro (V-13, jede
  andere Permutation = Wurf); compare/macro/micro == w/ma/mi via M13-Alias (kein Rename).
  Begruendung: (c)(f) -- Tags/Legenden persistieren in Bestand 2/3 und xlsx. Das #90-Design
  steht [W1->vor Trigger] im Teil 3; der KOLLEKTOR-Bau bleibt nach-Trigger.
  >> [20.08.v2, Fix 2 -- UMKLASSIFIZIERUNG: I-2 zaehlt ab jetzt zu KLASSE C.] Gewaehlt ist
  >> die Variante, die den I-2-Text UNVERAENDERT wahr macht: (i) der Text selbst sagt
  >> "das #90-Design steht [W1->vor Trigger] ... der KOLLEKTOR-Bau bleibt nach-Trigger" =
  >> woertlich die C-Definition (vor Trigger nur FESTSCHREIBEN, Bau danach); (ii) Slot W2-D
  >> nennt den Traeger woertlich "I-2-Festschreibung"; (iii) das Abschnitt-3-Etikett
  >> [ID/FIX] fuer M2 bleibt damit ohne Eingriff wahr. Die Alternative (Klasse-B-Definition
  >> aufweichen auf "entscheiden + Schema-Festschreibung im W2-Zug, Bau ggf. danach") haette
  >> ZWEI Definitionen angefasst und die B/C-Trennschaerfe verwischt. Der Eintrag bleibt
  >> AM ORT lesbar, ZAEHLT aber in Klasse C; Arithmetik nachgezogen in 0(2) und Abschnitt
  >> 10: B-Klasse = 2 (I-1, I-5), C-Klasse = 3 (I-2, I-7, I-8).

**KLASSE C -- VOR Trigger nur FESTSCHREIBEN (Bau danach):**

>> [20.08.v2, Fix 2] I-2 zaehlt seit der Umklassifizierung HIER (Text steht unverschoben
>> am alten Ort in der B-Liste, s. Marker dort); C-Klasse damit: I-2, I-7, I-8.

- **I-7 Alias-vor-Rename-Rangfolge (M13)**: hiermit im Design festgeschrieben; W2-Skelett
  reicht als Traeger; kein Byte-Ereignis. Begruendung: (f) praeventiv -- verhindert kuenftige
  Naming-Identitaets-Ereignisse.
- **I-8 Record-FELDBESTAND Bestand 2/3 (M4-Kopplung)**: Mess-Records tragen ab Kampagne
  Kanal-Tag, Zustands-Dimension (Tracing-Vorgeschichte), machine_id/platform-Tag. Spaetestens
  VOR der Kampagne Sa 29.08. wirksam, empfohlen im W2-Schema-Zug mit I-1. Begruendung: (c) --
  fehlende Spalten in der Kampagne sind nicht nachtraeglich erhebbar (Messdaten bleiben,
  ABI darf brechen -- aber Messdaten ohne Spalte bleiben ohne Spalte).

**NICHT identitaetswirksam (Beleg der Trennschaerfe, Auswahl):** M0-Betriebsprotokoll
(nie persistiert, NIE Mess-Rohdaten) · M7-Bereichs-Linie (RAM-Ergebnis, Lager erst als
Bestand-3-Batch UNTER I-1) · M14-Report (Ausgabe) · M6-Kataloginhalt (additiv) ·
Beschleunigungs-Schicht (RT-Dispatch) · M12-additive Grammatik (bricht keine bestehenden
Hashes) · Steuerdock-6er-static_assert (dormant, faellt per #24/B4 -- CT-Wandel ohne
Stempel-/golden-Byte).

---

## 5. NACH-TRIGGER BAUBAR (je Punkt mit Begruendung)

- **M0-BETRIEB** (Transport, Typestate-Fenster, fd-Kanarie, Rechtsakte Freigabe/Durchsetzung,
  OOB-Fertig, Sync-Barriere, Stummschaltung, Prioritaets-Queues): Laufzeitprotokoll ohne
  Persistenz; W3-Bau-Rest vor der Voll-Messkampagne (Skizze), identitaetsfrei.
- **M2-KOLLEKTOR-BAU** (Kanalwerk, Klammer-Zusammenfuehrung C-9-Erweiterung, C-13.3-Gates,
  Arena-Politik-Nachzug auf KON93/94): IDs stehen per I-2; Rest ist RT-Mechanik im
  \#53/#90-Strang nach 12W-Explore.
- **M3-SERIEN-SMOKE + Fahrplan-Restbau** (W3): S-19-Zahlen liegen dann; Stempel traegt die
  Beschaltung bereits.
- **M4-BAU** (Loader-Ausbau, All-vs-All-Synthese, Batch-Erzeugung): konsumiert I-1/I-8;
  Rechenwerk selbst identitaetsfrei.
- **M5-FACTORY** (Komposition, verify-sweep, Guetemass, +-3%-constexpr+XML): Auswerte-
  Semantik; std-only-Zwang entfallen (Ledger-KON111).
- **M6-VOLLAUSBAU** (Katalog-Fuellung, neuer Deep-Research, Impact-Sortierung): additiv;
  Skelett W2, Inhalt frei nachziehbar.
- **M7-BAU** (Bereichs-Linie, Optimal-Bereichs-Erkennung, RAM-Kontext-3-Politik wie
  Abschnitt 3/M7): RT auf der CEB.
- **M8-SELECTOR-MERGE** (Alt-Werkzeug -> Komponente 3; super-Leser auf Lager; UEBERHOLT-
  Marker-Nachzug; deprecaten nie loeschen): Struktur ohne Stempel-/Preimage-Beruehrung.
- **M9/HY-C** (W4: Dock-Laden, Wechsel-Penalty-Gegenmessung, Lookahead, XML-init-Profile;
  \#49-Staffelung VORHER nach V7-Antwort): Identitaetsteile liegen komplett im #15 (I-4).
- **M10-MECHANIK** (N2-Batch-Schreibweg, Invalidierungs-Implementierung, Verbund1-Skip-Logik
  je machine_id): Schluessel stehen per I-1; Schreibweg ist Prozess.
- **M11-AUSDEHNUNG** (Auswerte-Batches in der 15-Stationen-Kette, GESAMMELT): Prozess;
  A-05-Ordinale landen mit #15.
- **M12-ADDITIVE GRAMMATIK** (publish, Filter-Kriterium, Hybrid-Profile, Markierung,
  externe-Pfadangabe, profile_ref-ERROR): additive XSD-Elemente; geplant W2 Di 25., notfalls
  nach Trigger ohne Identitaetskosten nachziehbar.
- **M13-FUELLUNG** ueber die Erst-Eintraege hinaus: CT-only.
- **M14-REPORT-BAU**: reine Planer-Ausgabe am Experiment-Ende.
- **BESCHLEUNIGUNGS-SCHICHT** (Ledger-KON111-02: variant-Dispatch, HW-Detection,
  SIMD-Reservierungs-Slots, Planer-Notification in bestehender Nachrichtenklasse): RT-Zone,
  Kopplung an Drei-Bereiche-Concurrency floor((T-4)/4)x4 ce-intern.

---

## 6. OWNER-VORLAGE-KANDIDATEN (A2.3a-NEIN-Probe je Punkt; geprueft gegen KON101/KON110/
## KON111/KON112/KON117/KON118)

**BESTANDEN (vorlegen, aber in BESTEHENDE Vorlagen einreihen -- keine neue Frage):**
1. **#71-Zeile: Auswerte-Phase Thread-Zahl T vs T-4** (F7-Planer-Reserve). Probe: KON73-02
   kennt fuer die Auswerte-Phase keinen Bereich; KON110-04 sagt nur "maximale Thread-Zahl";
   Ledger-KON111-02 nennt floor((T-4)/4)x4 nur ce-intern -- KEIN Owner-Wort zur Reserve-Frage.
   EIN Satz in die bestehende #71-concurrency-Vorlage (Teil 3 hat das bereits geroutet --
   nicht doppeln, nur vollziehen).
2. **R-2-Namens-SCHEMA** (was ein Ding IST): KON112-09 haelt es ausdruecklich als separaten
   Owner-Entscheid offen; KEIN KON-Wort zum Schema selbst. NICHT triggerkritisch (I-7 macht
   Renames zur Ausnahme) -- Vorlage ERST an der ersten Neu-Benennung, nicht jetzt.

**NICHT BESTANDEN (Owner-/KON-Wort liegt ODER Design-Vorschlag am Fenster genuegt):**

>> [20.08.v2, Fix 1 -- ZAEHLWERK] ZEHN Punkte, ELF Kandidaten (der L2+D1-Punkt buendelt
>> ZWEI). Etikett je Punkt in der "[E 20.08., ...]"-Zeile darunter; Summe: OWNER/KON-WORT
>> LIEGT = 8 (K1-K8), DESIGN-VORSCHLAG AM FENSTER GENUEGT = 2 (K9, K10), ROUTING/NICHT-
>> DOPPELN = 1 (K11); 8+2+1 = 11. Harmonisiert mit 0(4) und Abschnitt 10.

- std-only-Spiegelung: BEANTWORTET (Ledger-KON111: "Spiegelung faellt ... mit Komponente 3
  zu mergen") -- die Skizzen-Frage 1 ist zu STREICHEN, nicht zu stellen.
  [E 20.08., K1: OWNER/KON-WORT LIEGT -- Ledger-KON111.]
- Typ-3/4-Schluessel-Bestandteile: Owner-Wort liegt (KON110-04 machine_id/Einmal-je-Maschine/
  "Kernbestand bleibt"; KON101 V-09R/V-10b) -- Rest ist Design (I-1).
  [E 20.08., K2: OWNER/KON-WORT LIEGT -- KON110-04 + KON101 V-09R/V-10b.]
- B-2-Namen: V-11R "Vorschlag angenommen. Genau so." -- nur Scope/Zeitpunkt sind Design (I-3).
  [E 20.08., K3: OWNER/KON-WORT LIEGT -- V-11R; inzwischen sogar VOLLZOGEN (S4).]
- mess/-S-Position: KON117 VOLLZOGEN (S-22).
  [E 20.08., K4: OWNER/KON-WORT LIEGT -- KON117, S-22 vollzogen.]
- Dock-Deckel/kleine Hybride: KON110-03 RF-C beantwortet (Deckel 32, kein Auffuellen).
  [E 20.08., K5: OWNER/KON-WORT LIEGT -- KON110-03 RF-C.]
- 6-Steuerdock-Nenner vs dynamisch: Plananker KON37-03/KON34-04-B4 ("anzahl==6 faellt",
  W2-Tabelle) + Dauerregel S-19-Nenner -- kein Owner-Bedarf; die alte KON29-06-R-1-Frage ist
  durch die Subset-Form (B-19: Anordnungs-Freigabe je Stufe Subset {W,Ma,Mi}) ueberholt.
  [E 20.08., K6: OWNER/KON-WORT LIEGT -- KON37-03/KON34-04-B4 + S-19-Dauerregel.]
- Arena-Ueberlauf-Politik: KON93/94 Owner-hart (harter Abbruch); T-NEU-1: OWNER>PLAN --
  mess_arena-WEITERMESSEN ist NACHZUG-Pflicht im #90-Zug, keine Frage.
  [E 20.08., K7: OWNER/KON-WORT LIEGT -- KON93/94 Owner-hart; Nachzug-Pflicht im #90-Zug.]
- RAM-Schwelle Auswerte-Kontext: KON112-04c legt den Entscheid INS DESIGN -- hier gefaellt
  (M7: constexpr-Default + XML-Override, Batchen statt Abbruch).
  [E 20.08., K8: OWNER/KON-WORT LIEGT -- KON112-04c routet den Entscheid INS DESIGN.]
- Stufe2_Hybrid-Verbund-Name (L2) und D1-"Farben"-Aufloesung: DESIGN-Vorschlaege am
  jeweiligen Fenster (Skizze selbst hat die NEIN-Probe dafuer negativ beschieden).
  [E 20.08., K9+K10: DESIGN-VORSCHLAG AM FENSTER GENUEGT -- ZWEI Kandidaten: L2-Name (am
  M12-Sammelzug-Fenster W2-B nachreichbar, S8) und D1-Farben (am I-5/#89-Fenster, W2-C).]
- KON118-Ein-Satz (Phantom-Nenner/#15): liegt bereits in der #15-Meldung -- nicht doppeln.
  [E 20.08., K11: ROUTING/NICHT-DOPPELN -- liegt bereits in der #15-Meldung.]

---

## 7. PAR.75-SPERRE: WAS FAELLT, WAS BLEIBT

Die Sperre (Ledger: "Bis dahin waehlt KEIN Aufraeumpass implizit (Par.75-Sperre)"; KON108-02/
KON109-01: "bleibt bis zum Unifikations-Design") verhinderte, dass Struktur-/Aufraeumzuege
implizit EINEN der drei parallelen Designplaene zum Kanon erklaeren oder Traeger verschieben.
MIT DIESEM DESIGN GILT:
1. Die drei Komponenten sind EIN Stack unter der CEB-Modul-Steuerung (Abschnitt 2) --
   es gibt KEINE Deprecate-Wahl mehr; die einzige beschlossene Entfernung ist die
   std-only-ZWEITSCHRIFT im Selector (Owner, Ledger-KON111; Alt-Datei deprecaten, nie
   loeschen).
2. Par.75-KANDIDATEN, die heuristik/, builder/curve_fit, decision_lambda_trees,
   best_binary_selector, measure_storage, bestandslog oder mess/ beruehren, pruefen ab jetzt
   gegen die Ring-Karte 2.1 (Ziel-Traeger planner/ceb/tier/hybrid) -- explizit, je eigener
   Zug, ERST LAUTE COMPILE-FEHLER, DANN VERSCHIEBEN.
3. Der volle Monolith-Split bleibt per Owner-Wort W7/#88 ("beim Aufraeumen") -- die Sperre
   faellt fuer die WAHL, nicht fuer den Zeitplan der Umzuege.

---

## 8. BAU-SLOTS-SKIZZE W2 (Sa 22.-Di 25.08., Landung Di 25.; Vorstaffel WE 22./23.)

GATE davor (W1-Rest, Do 20.-Fr 21.08., hier nur benannt): #15-Voll-Abnahme -> Lande-Kette
(par.21.1) -> #15-NACHLANDESCHRITT (F2-2 system_zeile + F2-3 S-5-Erbinnen + F2-8 N-1/N-2) ->
FREEZE-CHECK Fr 21.08. mit Deklarations-Tafel 23.2. #7/S-19-Freigabe wird mit der
\#15-Landung wirksam.

>> [20.08.v2, S1] GATE-KERN DURCHSCHRITTEN: #15-Voll-Abnahme + Lande-Kette GEFAHREN
>> (Merge ea7df79b; T-B Lock-Regen 196a621a); die #7/S-19-Freigabe ist WIRKSAM = W2-A
>> startbar. Nachlandeschritt-/Freeze-Check-Stand ist hier nicht neu vermessen (nicht
>> Lens-Gegenstand); der FREEZE-CHECK-Termin Fr 21.08. mit Tafel 23.2 steht unveraendert.

- **SLOT W2-A (Sa 22.-Mo 24., Klasse M, Mess-Fenster):** S-19/#7 Planungs-Simulation
  (produziert die B-4-Zahl = Bau-Nenner des Triggers; M3-Kern) · #13/T-15b Retry-Klammer ·
  \#38b Warmup-PAAR. [Skizze W2 + Wellenplan 18.4]
- **SLOT W2-B (Sa-Di, P/M, Di-25-Buendel = Korb B):** M10-SCHEMA = I-1-Vollzug (#57(7)-(9):
  Bestand 3+4, Schluessel, Invalidierung, N2-Schreibweg, Verbund1-Skip je machine_id) +
  M12-GRAMMATIK-SAMMELZUG in EINEM Zug (#18/#48/#57(6): publish, Filter-Kriterium,
  Hybrid-Profile, Markierung, externe-Pfadangabe, profile_ref-ERROR; I-3/B-2 nur falls
  nicht schon im #15-Umfeld vollzogen -- dann HIER mit L3-Abgleich + golden-Regen) +
  \#18/S-13-Export (Verbund1-Skip-Sichtbarkeit; ROT-Auflage s13:1384 beachten). I-8-Felder
  fahren im selben Schema-Zug.
  >> [20.08.v2, Fix 3/S4] Der Konditionalzweig "I-3/B-2 nur falls nicht schon im #15-Umfeld
  >> vollzogen -- dann HIER mit L3-Abgleich + golden-Regen" ist GEGENSTANDSLOS: I-3/B-2 IST
  >> im #15-Umfeld vollzogen (XSD:253-255, sota_catalog:648-656, golden-Regen 0660a06d/
  >> af0f251a). Der M12-REST des Buendels bleibt voll bestehen (S9); der L2-Namensvorschlag
  >> Stufe2_Hybrid ist an DIESEM Fenster regelkonform nachreichbar (S8).
- **SLOT W2-C (W, eigener Bau-Agent):** #89 P-H Paper->Prueflinge + Ledger-#44/PV-4:
  Gesamt-Klassen-Ladung, I-5-Stempel-Farben (Achsen-Tokens, D1-Harmonisierung),
  P08/P09/P33-Umbau (L6), M14-Ranking-GRAMMATIK (Report-Bau spaeter). [Teil 3 #89]
- **SLOT W2-D (W, Design/CT):** M13-SKELETT (CT-Header + Erst-Eintraege node4,
  w/ma/mi-Aliasse, Verbund-Uebergang; I-7 in Kraft) · M6-KATALOG-SKELETT (#88) ·
  \#90/P-A-Designplan-ABSCHLUSS nach 12W-Explore (I-2-Festschreibung; Arena-Politik-Nachzug
  als Bauauftrag markiert). M13-Skelett + M2-Design ZUERST in der Slot-Reihenfolge
  (Bau-Reihenfolge der Skizze: Begriffe + Kanal-IDs sind Fundament).
- **SLOT W2-E (M, System/CI):** #24/B4 System-B-Umstellung ("Steuerung -> Compile",
  anzahl==6 faellt; schliesst Selbstkompilation 4/4) · #3 S-12-CI-Geruest (Emissions-Doktrin
  B-17) · F2-1/B1 Registry-NEUBAU als deklarierter 18.6(4)-Fall am W2-ANFANG vor Trigger.
- **SLOT W2-F (Randslots, gezaehlt):** F2-5-Fallposten (8 Band-A-Testposten ~33h,
  Feinplatzierung Di 25. via #96) · #102 F6 (Do 20.!) · clang-Warnungs-Review-Buendel
  (Tafel 23.2) · #19 main-FF nach #31 · #22(ii)/--debug-CLI mit S-8.
  >> [20.08.v2, Fix 3] "#102 F6 (Do 20.!)" ist GEFAHREN (golden-102-Zug in der Landung)
  >> und NACHKLASSIFIZIERT: das Ereignis war nach Massstab (b)(d) identitaetswirksam
  >> (build_version-Glied [10], fingerprint_format 6, Budget 6186) und wird als
  >> I-4+#102/B-9-Fortschreibung in Abschnitt 4 gefuehrt, nicht als blosser Randslot;
  >> real VOR F2 gelandet, kein Schaden entstanden.
- **DANACH:** W3 = M0-Betriebs-Rest + M3-Serien-Smoke (Generalprobe; Kampagne Sa 29.08.);
  W4 = M9/HY-C (P-C/P-D; #49-Design vorher). 
- **KAPAZITAETS-CAVE (offen ausgewiesen, NIE KUERZEN):** 20.7(2) -- WE 22./23. ist ueberbucht
  (S-19 + T-15b + I-PMC + A-1 + evtl. Talos); Owner-Terminfrage liegt bereits im
  Vorlagen-Fenster. Bei Riss: pausieren/sequentialisieren nach 18.6-Fallordnung mit Zahl im
  Protokoll -- NIE reduzieren; Fall-Posten behalten den Platz (21.0).

## 9. BAU-REIHENFOLGE (Abhaengigkeit, fortgeschrieben aus der Skizze)

M13-Skelett + M2-DESIGN (#90) zuerst -> M10-SCHEMA (I-1/I-8) vor M4 -> M5-Interface vor
M4-Vollausbau -> M6-Katalog-Skelett vor M7 -> M7 -> M8-MERGE (statt Alt-Selector-B-Ausbau;
UEBERHOLT-Marker im selben Zug) -> M9 (W4). M12 sammelt ALLE Grammatik-Elemente in EINEM
W2-Zug (B-2-Sonderweg s. I-3). M3 haengt an S-19 (#7). M0-Betrieb unabhaengig, aber vor der
Voll-Messkampagne; #24/B4 vorher (Nenner-Fall + Steuerung->Compile). Beschleunigungs-Schicht
vor M7-VOLLAUSBAU (variant-Zone ist deren Substrat), nach M4-Erstbetrieb.

## 10. VOLLZAEHLIGKEITS-GATES (Dedup-Gegenzaehlung)

15 Module M0-M14: alle 15 in Abschnitt 3 behandelt (M0,M1,...,M14 -- gezaehlt 15/15).
8 Identitaets-Punkte I-1..I-8: A-Klasse 3 (I-3-Vollzug, I-4, I-6) + B-Klasse 3 (I-1, I-2,
I-5) + C-Klasse 2 (I-7, I-8) = 8/8. Owner-Zeilen: 2 bestanden + 9 abgewiesene Kandidaten
dokumentiert. Objekt-Fundstellen: ueber 30 Datei-/Zeilen-Anker, alle heute am dev ba33b9ac
bzw. XSD gemessen (keine uebernommenen Behauptungen; 3 Skizzen-Abweichungen ausgewiesen).

>> [20.08.v2, Fix 1+2] GATES FORTGESCHRIEBEN: 8 Identitaets-Punkte = A-Klasse 3 VOLLZOGEN
>> (I-3, I-4+#102/B-9, I-6) + B-Klasse 2 (I-1, I-5) + C-Klasse 3 (I-2, I-7, I-8) = 8/8;
>> die alte Lesart "B 3 / C 2" oben bleibt lesbar (Fix 2). Owner-Zeilen: 2 bestanden +
>> ELF abgewiesene Kandidaten in ZEHN Punkten (8x Owner-/KON-Wort K1-K8, 2x Fenster-
>> Vorschlag K9-K10, 1x Routing K11); die alten Zahlen "Acht"/"9" bleiben lesbar --
>> die Differenz erklaert sich aus der Zaehlart (Punkte vs. Kandidaten) und der L2+D1-
>> Buendelung (Fix 1). Objekt-Anker: die ba33b9ac-Messungen bleiben Historie; die
>> Stand-Marker-Anker S1-S9 sind am dev 196a621a nachgemessen (20.08. abends).

Quellen-Karte: Teil 2+3 + synthese-volltext + kon112_ledger_teil (BU-Ordner) · Ledger
KON101/108/109/110/111/112/113-118 · Wellenplan 16.2/18.3-18.6/19.1-19.4/20.1-20.7/21/23 ·
Owner-Verbatim-BU 20260817-owner-antworten-rf-r-runde.

SELBSTCHECK: ASCII-only; Zeilenlagen als verschieblich markiert; kein Code geschrieben;
keine Task-/Board-Mutation; Messungen read-only am Haupt-Klon (NICHT wt-ce-bump15).

SELBSTCHECK v2 (20.08. abends): ASCII-only; alle NEUEN Zeilen <= 100 Zeichen (eine 101er-
Originalzeile in M1 ist unveraendert uebernommen -- nichts aendern schlaegt Formatzwang);
NICHTS geloescht -- nur datierte ">>"-/"[E ...]"-Marker AM ORT, alte Zahlen bleiben daneben
lesbar; Original-Gliederung 0-10 unveraendert; Stand-Anker stichprobenweise am ce-Baum
super-Submodul dev 196a621a nachgemessen (read-only, keine Code-/Task-/Board-Mutation);
Ausgabe NUR diese v2-Datei, Landung nach docs/plaene macht der Lead.
