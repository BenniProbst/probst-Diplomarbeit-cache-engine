# GRUPPE 6 -- GOLDEN-NACHPOSTEN + XORFILTER-LANDEANTEIL (#15-Bump-Buendel)

Erhebung: 17.08.2026 am Objekt, ce development @ 04ac26fa (Baum sauber). Read-only, keine Edits.
Regel eingehalten: jede Fundstelle HEUTE gemessen; Karten-Angaben nur als Behauptung, gegen HEAD geprueft.

## POSTEN (a) -- all_axes_golden.profile.xml '--' + Flag PROFILE_ALLOW_COMMENT_TEXT_DEFECT

BEFUND: BEIDSEITIG ERLEDIGT -- fuer #15 bleibt NULL Bauarbeit, nur Doku-Nachzug.

(a1) Fundstellen HEUTE:
  - '--' in Kommentartext: 0 Treffer. Zwei unabhaengige Proben: PCRE-Suche (Lookaround gegen <!-- und -->)
    leer; sed-Strip aller Delimiter + grep -- '--' leer (EXIT 1). xmllint --noout: VALID.
  - Ehemalige Defekt-Regionen heute mit " - " geheilt: Z.62 "Baseline-Binary - ein No-op-Pass",
    Z.64 "dazu - symmetrisch", Z.207 "je Profil - die golden-Abgabe" (Datei
    libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml).
  - Heilungs-Commit ce 90a31961 (08.08.): 4 XMLs, NUR Kommentar-Inhalte (Beleg im Commit-Text:
    Kommentar-Spannen herausgestrichen -> Resttext byte-identisch), plus NEUE Wache
    scripts/ci_xml_wellformed_guard.sh (CI-Job lint:xml-wellformed, stderr-Riegel, kein Skip-Pfad --
    grep allow/defect/skip im Skript: nur Verbots-Kommentare Z.25/86).
  - Flag im ce-Repo: 0 Treffer UND git log -S ueber alle Branches leer -> existierte im ce NIE.
    GEGENPROBE (Nullbefund-Doktrin): das Flag lebte im SUPER, Code/tests/CMakeLists.txt (B14-NB3-
    Ausnahme, eingefuehrt super 1ba29b63); HEUTE grep -c = 0 (rc=1). ENTFERNT in super 2983e9ba
    "chore(gitlink+xml): ce auf 25fe4fbf -- und die B14-NB3-Ausnahme faellt im SELBEN Commit" --
    exakt die Selbst-Rueckzieh-Verriegelung (Flag AN + roh sauber => RC=1 "Ausnahme obsolet").
(a2) Wachen: keine zu brechen; ci_xml_wellformed_guard deckt Regression. Riegel/Floor/CRC unberuehrt.
(a3) Reihenfolge: entfaellt.
(a4) Entscheide: keine. AUTONOM: Wellenplan Sec.19.1-Zusatz "all_axes_golden ... Flag-Ausnahme
     entfernen (r3 A12)" ist 2x stale (seit 08.08. erledigt) -> im super als erledigt buchen.

## POSTEN (b) -- telemetry-silent: active_telemetry_is_silent() konstant false (Verdrahtungs-Schnitt)

(b1) Fundstellen HEUTE (Auftrags-Zeilen 241-242/533 sind verschoben -- Erhebungsdatum der Karte aelter):
  - Definition: libs/cache_engine/profile_facade/profile_run_facade.cpp:249-251, return false
    (Default Active). Begruendungsblock :239-248, woertlich: ein Durchreichen "haenge +tel=silent ans
    golden-build_version und BRECHE die Byte-Identitaet"; "bewusst golden-BRECHENDER Folge-Schritt
    (eigene Absprache), NICHT Teil der golden-neutralen A9.3".
  - Aufrufer: profile_run_facade.cpp:549-553. REGISTRY-GEGATED: Token nur, wenn "telemetry" in
    ex::build_system_axis_levels() als System-Achse gefuehrt wird; dann parts.telemetry = "silent".
  - Token-Ordnung: system_version_suffix.hpp:58 ("+tel=" zwischen "+target=" und "+bt="), Feld :68.
    Token-Mechanik bereits getestet (inerter Pfad): tests/unit/test_m_w12_stamp_bausteine.cpp:1040.
  - Profile mit silent="true": 11 (alle unter algorithm_profiles/thesis_profiles/, gezaehlt per grep -rl;
    Auftrags-Behauptung ">=10" bestaetigt, heute 11 inkl. all_axes_golden + m3_golden_coverage).
  - NULLBEFUND + GEGENPROBE: KEIN Code liest das XML-Attribut silent (alle "silent"-Code-Treffer sind
    facade:244-253/549-553 + test:1040; kein Parser-/Struct-Feld in profile_facade). Der Schnitt hat
    also ZWEI Enden: (i) Profil-Parser-Feld NEU, (ii) Facade liest Profil statt konstant false.
(b2) Wachen/Anker, die der Schnitt zieht:
  - golden-build_version: alle 11 silent-Profile bekommen "+tel=silent" -> .version-Sidecars,
    Resume-Stamps, build_version-Spalten der Mess-Ausgaben wandern -> NUR im Buendel-Bruch landen.
  - kNewGolden131072Crc64 NICHT betroffen: ids tragen kein tel-Segment (POD/Suffix != binary_id,
    anatomy_module_abi_v1_decl.hpp:230-231 und :273 "binary_id bleibt Organ-only").
  - S-14a-Riegel 718: unberuehrt, solange kein Traeger unter organ_axes/topics/heuristik angefasst wird.
  - Floor 495/491/489 (scripts/ci_test_inventory_floor.txt, EXAKT-Anker avx512f/avx2/basis, BEIDE
    Richtungen Exit 4): nur nachziehen, wenn der Schnitt Tests hinzufuegt/entfernt -- im SELBEN Commit.
(b3) Reihenfolge im Buendel: nach Registry-Stand der telemetry-System-Achse (Gate :551-553), sonst
     emittiert der Schnitt ins Leere; unabhaengig von (c)/(d), aber wegen build_version im EINEN Bruch.
(b4) Entscheide: KEINE offen -- Absprache dokumentiert (facade:247 "eigene Absprache"; r4 A-01 ordnet
     dem Fenster zu). Bau autonom.

## POSTEN (c) -- E-B Stempel-Name + golden-CRC-Re-Anker-Verfahren

(c1) Anker-Fundstellen HEUTE (KARTEN-KORREKTUR r3 D19/L19):
  - LIVE-Anker: kNewGolden131072Crc64 = 0x56F1B721C72DC10E, source_catalog.hpp:191 (Karte sagte :190,
    +1 verschoben). Definition :177-182: CRC-64/ECMA-182 ueber die 131072 golden-binary_ids in
    KANONISCHER StaticBinaryView-Reihenfolge, je id + '\n', OHNE Kommentar-Kopf. r3 A13 AM OBJEKT
    BESTAETIGT: haengt an REGISTRY-Reihenfolge, nicht an XML.
  - 0xF1C1F26A1232073B ist seit RE-ANKER 26.07. (STRUKT-R ORG-18, "Owner-GO fuer den TABU-Wert",
    source_catalog.hpp:183-190 mit LITERALEM Werkzeug-Protokoll inkl. "[MISMATCH]") NUR NOCH Alt-Wert.
    Alt-Wert-Kommentar-Stellen HEUTE: VIER, nicht zwei -- source_catalog.hpp:184+:188,
    sota_catalog.hpp:183, merge_plan.hpp:15, anatomy_fingerprint.hpp:16. Alle vier behaupten
    "golden-CRC 0xF1C1F26A1232073B unberuehrt" -> nach dem Buendel-Bruch doppelt stale;
    Nachtrags-Stellen im Bruch als Historie kennzeichnen/nachziehen.
  - TABU-Pin, den die Karte NICHT fuehrt: tests/unit/test_e24_c10_g6_identitaets_bilanz.cpp:114
    lokale Kopie kCrc64AnkerVorC8 = 0x56F1B721C72DC10E; :239 eq "der CRC64-Anker ist unveraendert
    (TABU-Wert)". Bricht bei JEDEM Re-Anker -> im selben Schnitt bewusst mitheben.
(c2) Neu-Anker-Verfahren + Bissprobe AM OBJEKT:
  - tools/gen_golden_fullpilot/main.cpp:87-99: --crc64 druckt Wert + Abgleich [MATCH]/[MISMATCH]
    gegen den committeten Anker; rc = ok?0:4 (:100, ok = N==131072 UND CRC==Anker); Datei-Modus rc 3.
  - Verfahren (Praezedenz 26.07.): Werkzeug-Output LITERAL in source_catalog.hpp:191 uebernehmen,
    Protokoll-Kommentar erweitern; danach TABU-Pin :114 nachziehen.
  - NUMMERN-KOLLISION notiert: der Datei-Kopf des Werkzeugs nennt den 18-Slot-Satz "ABI-7"
    (main.cpp:110) -- das ist NICHT der Layout-Zaehler kAnatomyVersionLinesLayout (heute 6).
(c3) PRAEZISIERUNG der Karten-Behauptung "E-B bricht golden-CRC" (r4 A-07 / r5 A34):
  - Am Objekt haengt kNewGolden131072Crc64 AUSSCHLIESSLICH an den ids. Ein Stempel-Name im
    emittierten Quelltext aendert KEINE id -> der id-CRC bleibt [MATCH]. DAS ist die Bissprobe nach
    E-B: --crc64 MUSS [MATCH] liefern; ein [MISMATCH] hiesse, der Name ist faelschlich in die
    binary_id gelaufen (Baufehler, nicht Re-Anker-Fall).
  - Den id-CRC brechen im Buendel stattdessen: A-10/S-6 (Segment-/Registry-Reihenfolge), A-09
    FullJoin-Umbenennung (Sec.19.1: "golden-byte-wirksam"), kuenftige Slot-Aenderungen. -> EIN
    Re-Anker fuer das GANZE Buendel, als LETZTER Schritt nach allen id-wirksamen Posten.
  - Was E-B WIRKLICH bricht: die Identitaets-/Layout-Pins (s. c4) + jeden Fingerprint-Bestand;
    die 320er-Wache test_lazy_adhoc_source_gen (a) ist SELBSTKONSISTENZ lazy vs. Katalog-Gen
    (Byte-Vergleich modulo Kopfzeile, KEIN committetes Byte-Fixture) -> symmetrischer Einbau in
    beide Emitter haelt sie gruen. Byte-neutrale Praezedenz existiert: K7b-3 rechnete die SHA-512-
    Zeile INNEN im Makro (decl.hpp:221-224; anatomy_fingerprint.hpp:14-17) -- emittierter Text blieb
    identisch. Ob E-B-Name SICHTBAR in den Text soll, ist Teil der VS-Vorlage (s. c6).
(c4) E-B-Objektstand + ABI-Kopplung (die zwei Nachtrags-Stellen des Auftrags + Umfeld):
  - Preimage HEUTE: 9 Glieder, anatomy_fingerprint.hpp:643-647 static_assert "NEUN Glieder ...
    kAnatomyFingerprintFormat mitbumpen (F7)"; Format-Pin :648-649 auf "fingerprint_format=4" (:116).
    A-01 hebt auf 10 Glieder + Format 5 -> E-B-Name (SHA-256 ueber DASSELBE Preimage, 64 Hex,
    NICHT fingerprint[0:64]) MUSS NACH A-01/A-04 gerechnet werden, sonst Name ueber totem Preimage.
  - POD-Anbau (name_line/name_len o.ae.) = Layout 6->7: kAnatomyVersionLinesLayout=6 decl.hpp:267
    (Historie :258-266), sizeof-Pin 120 static_assert :274-276 (wird 136), align :277,
    GLEICHHEITS-Gates stamp_pod_has_entries :287 (==6) + Loader-Gate :279ff -- alle im selben Bruch.
  - Emissions-Stellen, falls Name in den Text tritt: sota_catalog.hpp:172+:248 (3-arg
    COMDARE_ANATOMY_VERSION_STAMP_M im emittierten src), profile_run_entry.hpp:579 (perm.cpp 2-arg).
  - NULLBEFUND ctsha256 + GEGENPROBE: libs/cache_engine/src/sha512/ enthaelt NUR ctsha512.hpp;
    ctsha256/CtSha256/sha256_digest: 0 Code-Treffer im Repo. Die sha256-Texttreffer sind Memory-
    Referenz (axis_original_code_mixin_base.hpp:5), CI-sha256sum-Kommentar (profile_run_facade.hpp:362)
    und Werkzeug-intern (axis_version_lock). -> consteval-SHA-256-Primitive ist NEUER Baustein.
(c5) Reihenfolge: (1) id-wirksame Posten, (2) Preimage-Form (A-01/A-02/A-04), (3) Layout 6->7 +
     Format 4->5, (4) E-B-Name, (5) EIN Re-Anker (--crc64 LITERAL) + TABU-Pin + Kommentar-Nachzuege,
     (6) Bissproben.
(c6) Entscheide (Owner): E-B = STOPP-Gate VS-B, Owner-Vorlage liegt (537 Z.,
     docs/sessions/20260807-OWNER-VORLAGE-stopp-gates-E-A-bis-E-F.md, Empfehlung "b/ii/a/a/a/a");
     Sec.19.1-Zusatz fuehrt "VS-A..VS-F STOPP-Gates offen". KON80-01 (16.08.) entscheidet V1-V7,
     VS-B NICHT darunter -> E-B-Bau ohne Owner-Antwort VERBOTEN (STOPP-Doktrin), Buendel reserviert
     den Slot. ZWEITER Owner-Punkt: neuer TABU-CRC-Wert braucht Owner-GO (Praezedenz 26.07.,
     source_catalog.hpp:183) -- kann mit dem F2-Freeze-GO gebuendelt werden.

## POSTEN (d) -- XorFilter #70: Offline-Peeling-Umbau (Landeanteil)

(d1) ENTSCHEID GEFALLEN -- Karten-Stand "Owner-Ein-Satz-Vorlage noetig" (Ledger:1163) ist UEBERHOLT:
  KON80-01 (Owner 16.08., woertlich): "V1 XORFILTER = DIREKT (b): Offline-Peeling-Umbau Graf/Lemire
  ('wir machen es gleich richtig, sonst haben wir doppelt arbeit') -> deklariertes golden-Ereignis
  Filter-Zelle, #70 wird BAU-Posten W1." Wellenplan:2211: "#70 | XorFilter-Korrektheit (30/256 FN)
  VOR naechster Messung | (P-nah) | W1". V2 ordnet: "#15-Buendel nach golden-Fenster".
(d2) Fundstellen HEUTE:
  - libs/cache_engine/organ_axes/filter_axis/axis_filter_xor.hpp:39-62 vereinfachte XOR-Konstruktion
    + Posten-78/Owner-A3-Doku-Block (:61-62 nennt die Nachzieh-Pflicht beim Fall der GEPINNT-Zeile);
    insert_key :80-83 (inkrementell = FN-Quelle); algo_version = "1.0.0.c" :118.
  - Vorbild build_from_sorted_keys: exact_prefix_filter_store.hpp:73, louds_sparse_filter_store.hpp:165,
    Concept surf_filter_organ_concept.hpp:32.
  - Zweitbaum topics/filter/axis_filter/axis_filter_xor.hpp: eigener Lock-Eintrag (lock ~:1583);
    GEGENPROBE Konsumenten: einziger Include ist tests/unit/test_v41_axis_filter.cpp; die
    organ_axes-Header ziehen aus topics/ NUR topic_filter_concept.hpp.
  - GEPINNT-Zeile: tests/unit/test_s5_02b_filter_perf_sanity.cpp:276-278, assert
    xorf.axis_stats[kAxisFilter][2] > 0; Umfeld :262-275 (no-FN-Vertrag, neg==0 fuer
    RangeSurf/Bloom/Cuckoo), Kommentar :266-272 nennt Offline-Peeling woertlich als Heilung.
(d3) Welche Anker bricht #70 GENAU:
  1. S-14a axis_version_lock (718 Records, tools/axis_version_lock/axis_version.lock): Eintrag
     "organ 1.0.0.c ... axis_filter_xor.hpp 071663fb..." (lock ~:647) mismatcht -> --check Exit 1
     (Tripwire test_s14_axis_version_lock_tripwire.cpp, Koeder A/B: Heilung NUR mit algo_version-Bump
     X.Y.Z echt groesser + Lock-Regeneration). 718 bleibt 718 (keine neue Datei). Topics-Kopie nur
     bei Beruehrung.
  2. Overlay-Glied [7]: organ_axes/filter_axis ist Schnitt-Eintrag builder/overlay_source_set.hpp:160
     (topics-Andockpfad :161; Lock teilt dieselbe Registry, axis_version_lock.cpp:203) ->
     kOverlaySourceHash aendert sich -> Preimage-Glied [7] (anatomy_fingerprint.hpp:22-24, :157) ->
     JEDER Tier-Fingerprint neu -> gesamter Sidecar-/Skip-Bestand invalid (gewollt). GENAU DAS
     verbietet A-13 ("EISERNE REGEL ... nichts unter axes/ topics/ heuristik/ anfassen") ausserhalb
     des Fensters -> #70 MUSS im Buendel-Bruch landen.
  3. Mess-golden: deklariertes golden-Ereignis "Filter-Zelle" (KON80-01) -- die XorFilter-Messzellen
     aendern Werte; Reichweite lt. Ledger-Vorlage "XorFilter-Zelle".
  4. GEPINNT-Zeile loest aus (kontrolliert): :276-278 im selben Schnitt auf ==0 drehen, :273-275 um
     xorf erweitern, Kommentare test :266-272 + axis_filter_xor.hpp:49-62 nachziehen. Owner-Auflage
     A3 (FN-Ausweisung) gilt fuer ALT-Messwerte weiter, entfaellt nur fuer geheilte Neu-Messung.
  5. NICHT betroffen: kNewGolden131072Crc64 (keine id-Aenderung; Bissprobe --crc64 nach #70 MUSS
     [MATCH] bleiben). Floor 495/491/489 nur bei Testzahl-Aenderung (dann im selben Commit).
(d4) Lande-Reihenfolge im Buendel-Bruch (Antwort auf die Auftragsfrage):
  #70 = W1-BAU-Posten; #15 landet nach dem golden-Fenster (KON80-01 V2). INNERHALB des EINEN Bruchs:
  (1) id-wirksame Posten (S-6/A-09/A-10) -> (2) Quelltext-/Overlay-Posten inkl. #70 (bis dahin
  A-13-gesperrt) + algo_version-Bump -> (3) Layout/Format/Glied-Bumps -> (4) E-B (falls VS-B
  entschieden) -> (5) EINMAL: Lock --write, gen_golden_fullpilot --crc64 LITERAL, TABU-Pin,
  Floor-Nachzug -> (6) Bissproben (Lock --check Exit 0; --crc64 [MATCH]; s5_02b gruen in neuer Form;
  xml-Wache gruen). Geteilte Zaehlwerke am Ende EINMAL live messen, keine Delta-Addition.
(d5) Entscheide: KEINE offen (V1 = DIREKT (b)). Autonom: Bump-Wert fuer algo_version, Lock-Regen,
     Test-Nachzug, Kommentar-Nachzuege.

## QUERSCHNITT: Karten-Korrekturen (Befund traegt Erhebungsdatum, alle HEUTE 17.08. gegen 04ac26fa)
  - r3 A12 / Sec.19.1-Zusatz "Flag entfernen": beidseitig erledigt seit 08.08. (ce 90a31961,
    super 2983e9ba) -> Posten (a) ist reine Buchung.
  - r3 D19/L19: Anker-Wert und Zeilen ueberholt -- live 0x56F1B721C72DC10E @ :191; Alt-Wert an VIER
    Kommentar-Stellen, nicht zwei; TABU-Pin-Test fehlt in der Karte.
  - r4 A-07 / r5 A34 "E-B bricht golden-CRC": am Objekt bricht E-B Layout-/Fingerprint-Pins,
    NICHT den id-CRC; die --crc64-Bissprobe trennt beide Faelle deterministisch.
  - Auftrags-Zeilen profile_run_facade 241-242/533: heute 249-251/549-553.
  - Ledger:1163 "#70-Vorlage noetig": ueberholt durch KON80-01 V1 (16.08.).
