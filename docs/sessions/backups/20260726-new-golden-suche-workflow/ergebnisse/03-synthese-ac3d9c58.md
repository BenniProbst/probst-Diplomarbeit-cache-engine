ANTWORT (7-Bit-ASCII, "par" = Ledger-Paragraph/Abschnitt)

```
(1) NEW-GOLDEN-ZIELBILD NACH DEM BESCHLOSSENEN UMBAU
Z-1 KARDINALITAET: N BLEIBT 2^17 = 131072. Jede neue Achse landet nach der Q-1-FALL-B-
    Blaupause mit K=1 gepinnt (persistence_target-Praezedenz). Kompositions-Achsen 18 (IST,
    live verifiziert: axis_path_serialization.hpp:40-43 = 18 Namen, ORG-18 gelandet in ce
    774a5d5f + fcd95a44) -> ZIEL 19 mit page_type K18=1. 320er bleibt 320 (Produkt 4*4*5*4
    unveraendert, weil der neue Slot auf 1 steht); golden_320_catalog wird 19-stellig.
Z-2 GENAU EIN NEUANKER ("ABI-8"): kNewGolden131072Crc64 0x56F1B721C72DC10E -> neu, weil jede
    der 131072 ids das Segment "/page_type=..." erhaelt. Reine Segment-Verlaengerung, KEINE
    Raum-Aenderung - identisches Bruch-Muster wie ORG-18. Wert ausschliesslich literaler
    Werkzeug-Output (--crc64), nie gerechnet.
Z-3 BYTE-WACHE BLEIBT (Rang unveraendert niedrig, par33): golden_fullpilot_320_binary_ids.txt
    als je-ABI-Generation NEU materialisierte Wache + ihre 5 Leser (test_profile_roundtrip,
    test_limits_entkopplung_vorstufe, test_wdk_datasets_fairness, test_measurement_categories,
    test_smoke_coverage_profile) + COMDARE_GOLDEN_320_BYTE_GUARD_IDS. Berichts-Regel gilt
    weiter: "320 gruen" = NUR Byte-Neutralitaet, nie Funktions-/Systembeweis.
Z-4 NEU GEANKERT (einmalig, ein Fenster): CRC64 + 320er-Fixture (Kopf "ABI-8 / 19 Slots") +
    kCompositionAxisNames 18->19 + die 4 Slot-Tabellen (source_catalog CatalogAxes/product/
    static_levels/AxisSweep/B-Slots, lazy_adhoc_source_gen:134-153, composition_factory:67) +
    POD-Version/ABI-Major 7->8/Magic .A7.->.A8./CSV-Spalten 169->x/Registry-Zaehler.
Z-5 DEPRECATED (nicht geloescht): Beweis-Anspruch der 320er; TABU-Kuerzel "<4,4,5,4>" (nur
    Produkt-Kurzschrift, Audit-Text :300); Alias _IDS; Alt-Anker 0xF1C1F26A1232073B und
    0x56F1B721C72DC10E als Kommentar-Archiv; _abi{4,5,6,7}.txt = Archiv, nie nachverifiziert.
Z-6 SYSTEM-SEITE BLEIBT ANKER-FREI: Registry fuehrt ALLE System-Achsen mit binary_id="never"
    (system_axis_registry.xml:10/53/98/102/114) -> Lane A/C/F, NUMA/locking, opt_level-
    Permutation, je-HW-Typ-Achsen (= extension_hardware-Meta-Metas) und die Meta-Meta-
    DEFINITION erzeugen KEIN Segment, KEINEN CRC-Wechsel, KEINE 320er-Neumaterialisierung.
Z-7 SYSTEMBEWEIS-ZIELBILD unveraendert par33: N-Guards gruen (static_assert 131072 +
    kNewGolden131072Crc64 + test_reflect_versions_all17) PLUS Voll-Konfig-Bau/Debug-Lauf in
    der CI. Mess-Regime par41/par51-B1 unveraendert: bauen new-golden, messen 320er, new-
    golden-Messung ab 01.08. F-SPREAD first-2 bleibt Haupt-Lauf (INC-G7 nach Abgabe).

(2) EINBAU-REIHENFOLGE (Ziel: EIN Neuanker statt drei)
S-0 VORAB, unabhaengig: _abi7.txt-Einfrierung ist NOCH OFFEN (live: nur _abi{4,5,6} vorhanden,
    aktive Datei = ABI-7, 169226 B, 26.07. 16:18). Sie ist Schritt 1 des Fensters, kein Extra.
S-1 BYTE-NEUTRALE GRUPPE ZUERST (kein Anker, CRC-Guards MUESSEN gruen bleiben):
    Lane A (SYS-TAX R-A..R-E + kSystemAxisOrder - Symbol existiert repo-weit nicht, Neubau) +
    Lane C (IDENT/external_utils-HUB, inert; "external_utils" grept 0x im ce-Baum) + NUMA/
    locking als 7. System-Achse + opt_level-Permutation. Kontroll-Kriterium: bleibt 320er/CRC
    hier ROT, ist das ein DEFEKT (Gegenteil des Achsen-Zuwachs-Falls).
S-2 LANE F SERIELL NACH A (unveraendert): Single-Source build_version_suffix, +ceb letztes
    Segment, T-c-Golden-STRING-Wache zuerst, atomar. Verifiziert byte-neutral ggue. der
    binary_id: build_version_suffix existiert nur im Planer (experiment_plan_director.hpp:149/
    225/1820) und in test_experiment_plan_director.cpp:147/178 ("+opt=O3", "+opt=O2+ext=avx2");
    kein Vorkommen in kCompositionAxisNames/Fixture. Lane F braucht KEINEN CRC-Neuanker.
S-3 DANN GENAU EIN GOLDEN-FENSTER "ABI-8" (alle id-beruehrenden Posten gebuendelt):
    (a) _abi7.txt einfrieren (cp, kein rm) + Alt-CRC ins Kommentar-Archiv :181ff.
    (b) K18-Entscheid VOR Code (O-1) + Slot-Position (O-2).
    (c) page_type verdrahten. NEUER BEFUND: das Material EXISTIERT schon -
        topics/nodes/axis_01_page_type/ mit 6 Varianten (AllPageTypes: DenseByte, ExtendedDense,
        SparsePatricia, Redirect, CustomCache, BPlus), EnabledPageTypes-Filter, PG1-PG3-Unter-
        Achsen, eigener Test test_v41_axis_01_page_type. FEHLT nur: StaticAxisVariants_01 in
        topics/nodes/topic_nodes_config_set.hpp (dort existieren nur _02/_04) + Katalog-Slot
        L18 + Namens-Eintrag. Also KEIN Achsen-Neubau, sondern Verdrahtung - deutlich kleiner
        als die ORG-18-Scheibe.
    (d) regenerieren, nicht rechnen: --crc64 (Anker setzen) dann --golden320 (Fixture);
        MISMATCH zwischen den beiden Laeufen ist der dokumentierte Ablauf.
    (e) 18->19-Konsumenten in EINER Welle ziehen (14 Posten der Anker-Karte) + neuer
        test_page_type nach Vorbild test_org18_persistence_target.cpp:102-113.
    (f) 2-Pass-Verify lokal-first, Fassade comdare_profile_run_facade EXPLIZIT bauen.
S-4 DANACH Voll-Bau-4-Trigger (2^17) + 4 lokale Beweise; danach 320er-Abgabemessung.
S-5 WARUM EIN FENSTER GENUEGT: von allen offenen Posten erreicht NUR page_type die
    Kompositions-id. Wuerde spaeter K18=1->2 aufgeschaltet oder eine weitere Organ-Achse
    beschlossen, waere das ein ZWEITER Anker - deshalb beides jetzt entscheiden und
    mitfahren lassen. Kosten je Anker (ORG-18-Messung): 2 Commits, 14 Dateien, POD/ABI/
    Magic/CSV-Kette, 314/314-Neulauf.

(3) OFFENE PUNKTE
O-1 K18 fuer page_type: 1 (N bleibt 131072, Budget unveraendert) vs 2 (N=2^18=262144,
    ~448 GB/~48 h). EMPFEHLUNG 1, Aufschaltung per Bauplan. KORREKTUR zur Anker-Karte: die
    mp_take_c-Falle greift hier NICHT (6 Varianten, take_c<...,2> well-formed) - das Risiko
    ist die STILLE Verdopplung auf 2^18, nicht ein ill-formed TU. Owner-GO noetig.
O-2 Slot-Position: anhaengen (Slot 18, 320er-Praefixe stabil) vs semantisch zwischen
    memory_layout/allocator. Doktrin-Lage stuetzt Anhaengen: axis_path_serialization.hpp:38-39
    sagt literal, die fachliche Gruppen-Ordnung werde auf der Lager-Baum-/Ordner-Ebene
    realisiert, NICHT in der binary_id-Radix-Folge. Bindende Sortierung (KERN par1) betrifft
    den Verzeichnisbaum -> kein Konflikt, aber owner-bestaetigen.
O-3 ANKER-REPRODUZIERBARKEIT: EnabledPageTypes ist CMake-flag-gefiltert (6x #cmakedefine01,
    CMakeLists.txt:1013-1025). Bei K18=1 haengt das gewaehlte Segment davon ab, welcher Flag
    zuerst aktiv ist -> Default-Flag-Satz muss im Fenster explizit gepinnt+dokumentiert
    werden, sonst ist der CRC konfigurationsabhaengig (gleiche Klasse wie der bekannte
    test_axis_registry_roundtrip-Byte-Drift im super-Baum).
O-4 Wrapper-Frage: StaticAxisVariants_01 mit ObservableNodeType-Transform (wie _04) oder roh
    (wie _02)? Observable-Forward-Doktrin beachten (Concept-Member weiterreichen).
O-5 E-08-Rest: NUMA/locking vs. bestehende Organ-Achse concurrency (L08) - Doppelbelegung
    entscheiden BEVOR Lane A kSystemAxisOrder generiert; ausserdem "compile-statisch erkennbar,
    sonst dynamische Unter-Achse unter target_isa". Zeitpunkt E-08 owner-bestaetigen (D-01
    zieht auf VOR-Trigger).
O-6 E-15: mit welcher opt-Stufe Voll-Bau-4 laeuft und ob Ofast (ieee754_deterministic=false)
    mitpermutiert - Mess-Vergleichbarkeit, anker-neutral.
O-7 par33-Systembeweis bleibt laut LEDGER:2435/2570/2760 OFFEN/TEIL; der Neuanker macht nur
    die Wache wieder wahr. Zusaetzlich fehlt E-04 (CI-Live-Fortschritt + generischer
    Interface-Test je Tier-Binary) - ohne ihn ist der 2^17-Lauf blind.
O-8 CSV-Spalten/Registry-Zaehler-Zielwerte fuer 19 Achsen (169 -> x, Registry 18/83 -> y)
    im selben Fenster festlegen.
O-9 kMaxMaterializableCatalogCardinality=4096 muss nach dem Fenster weiterhin 320 <= 4096 < N
    erfuellen (source_catalog.hpp:204/208-211) - bei K18=2 gilt das ebenfalls, aber der
    Guard-des-Guards-Kommentar nennt dann eine andere Zahl.
```
