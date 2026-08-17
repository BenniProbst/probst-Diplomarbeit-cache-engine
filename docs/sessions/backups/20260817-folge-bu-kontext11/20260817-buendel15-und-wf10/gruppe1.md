# BUMP-BUENDEL #15 -- GRUPPE 1: FORMAT/LAYOUT/GLIED-KERN
Erhebung: 2026-08-17 gegen ce development @ 04ac26fa (read-only, alle Zeilen HEUTE gemessen).
Repo: Code/external/comdare-cache-engine. Pfade unten repo-relativ. Karten-Zitate (r3/r4/r5,
Wellenplan) tragen ihr eigenes Erhebungsdatum -- Abweichungen sind unten als DELTA ausgewiesen.

## 0 IST-STAND DER KERN-KONSTANTEN (gemessen, nicht abgeschrieben)

anatomy_fingerprint.hpp (libs/cache_engine/include/cache_engine/abi/, 783 Z.):
- :68   kAnatomyFingerprintPreimageMax = 4096
- :82   kAnatomyFingerprintSeparator = '\n'
- :116  kAnatomyFingerprintFormat = "fingerprint_format=4"
- :157  kOverlaySourceHash (aus COMDARE_OVERLAY_SOURCE_HASH, generierter Header, hartes #include :30)
- :288  concept GliedSterbenderString; Traeger: OverlayHash :290-301, ToolchainGlied :359-370,
        BvsetGlied :372-383, MessGatesGlied :398-411 (K-1-Typen, Konstruktor-Wache, Rvalue-delete)
- :416  kAnatomyFingerprintGliedCount = 9
- :425  SystemGlied=2; :434-436 Toolchain=5, Bvset=6, Overlay=7; :447 MessGates=8
- :464-472 Glied-Budgets: Format 32, Organ 768, System 256, Mess 256, Valueset 128
        (= kSubAxisValuesetSegmentMax, subaxis_valueset_segment.hpp:39), Toolchain 512,
        Bvset 1536, Overlay 128, MessGates 64
- :474-478 kAnatomyFingerprintBudgetSum = 3688 (Summe + 8 Separatoren); Luft zu 4096 = 408 Byte
- :593-605 anatomy_fingerprint_glieder(): DIE EINE Quelle der Folge; Rueckgabe fest 9 (:603-604).
        Wellenplan-A-04 zitiert ":601" -- HEUTE ist :601 die require-overlay-Zeile (Datei gewachsen)
- :735-751 anatomy_fingerprint_hex consteval, Puffer PreimageBytesSenke<4096> :742
- :767-780 K-1-Sperre der Alt-Aritaet; Fehlertext ZAEHLT die Schwanz-Slots namentlich auf

anatomy_module_abi_v1_decl.hpp (513 Z.):
- :109/:110 COMDARE_ANATOMY_ABI_MAJOR 9 / MINOR 0; :114 MAGIC "COMDA.A9." (NICHT Teil des Buendels;
  "Layout 6->7" meint das POD-Layout, nicht den ABI-Major)
- :179-188 AnatomyStampEntryV1; :192-194 sizeof==48 + alignof==8
- :201-244 AnatomyVersionLines: 16 Felder, Reihenfolge organ->system->measurement->sha512->3 Arrays;
  :231-232 Leser-Doktrin "NUR bei stamp_layout_version == 6"
- :267  kAnatomyVersionLinesLayout = 6
- :274-277 sizeof(AnatomyVersionLines)==120 + alignof==8
- :286-288 stamp_pod_has_entries: GLEICHHEIT ==6 (K-4)
- :293-295 detail::stamp_pod_layout_probe (16 positionale Initialisierer)
- :301-307 CT-Proben: 6=true, 5=false, 7=false ("Layout 7 ... unbekannt -- Gleichheit, nicht
  Ordnung") -- das ist das im Wellenplan Z.2001 zitierte "decl.hpp:293-Verbot"; HEUTE :306-307
- :502  kCebContractCodegenMinor = 1; :511 kCebContractVersion{9,1}

anatomy_module_abi_v1.hpp: :163-205 COMDARE_ANATOMY_VERSION_STAMP_M materialisiert POD +
Fingerprint IM Makro (4 Traeger explizit + kMessGatesTuGlied); :213 2-arg-Form -> _M(o,s,"")
(der Perm-Pfad-Zweig mit leerer measurement_line). Emittiert wird NUR der Makro-CALL ->
golden-CRC 0xF1C1F26A1232073B haengt am CALL, nicht an Header-Innerei.

Flag-Budget-Konstanten -- KORREKTUR ZUM AUFTRAG: sie wohnen NICHT in flag_grammar_catalog.hpp
(Gegenprobe: dort nur Katalog 62 Eintraege :176 + 14 Reserve :373, kein kMaxFlag*), sondern in
measurement/algo_semver.hpp:
- :419 kMaxFlagTokenLen=16; :439 kMaxFlagNodes=96 (Vollausbau am Katalog = 58, :1251/:1257);
  :444 kMaxFlagDepth=4; :446-448 Grund-Asserts; :538 kMaxSemVerComponentDigits=6
- :726 kMaxRenderedFlagTailLen = 96*(16+2)+4 = 1732; :730 kMaxRenderedAlgoSemVerLen = 3*6+2+1732 = 1752

## 1 POSTEN A-01: 10. STEMPEL-GLIED (HYBRID-MAP-ZEILE), GliedCount 9->10, Format 4->5, Layout 6->7

(a) NULLBEFUND MIT GEGENPROBE: es existiert HEUTE kein Hybrid-Glied. Voll-Lektuere beider Header:
kein Feld/Glied "hybrid*" in anatomy_fingerprint.hpp noch AnatomyVersionLines; grep hybrid_map/
MapZeile/synthese_key ueber libs+tests = 0 Code-Treffer. Die Hybrid-Substanz liegt in
libs/cache_engine/hybrid/ (4 Header): heuristik_adapter_synthese_matrix.hpp :95
kHybridNodeObergrenzeDefault=32 (Owner 12.08., KON28-03: 32 loest 8 ab, PROGRAMM-Deckel,
willkuerlich, != Mess-Nenner), :99 kHybridRestTiefeDefault=1, :139 stufen_id()=Layer*Nodes+Node,
:220-238 static_asserts pinnen die 32er-Formel.
(b) Wachen, die bei 9->10 + 4->5 mitziehen (alle compile-hart gekoppelt, EIN Edit):
  anatomy_fingerprint.hpp :643-646 (Count==9 + F7-Bump-Pflicht), :647-648 (Format==...=4),
  :633-635 (Overlay==Count-2 -- BRICHT beim Anhaengen: Regel-Text+Assert umformulieren),
  :636-637 (MessGates==Count-1), :638-642 (aufsteigend), :609-627 (Positions-Beweise),
  Signaturen glieder()/hex() :593-605/:735-751 + neuer Traeger-Typ + K-1-Sperren-Text :767-780.
  Tier traegt "" -> Wache require_injizierter_glied_wert laesst leer zu (leer==Identitaet wie
  Toolchain/Bvset/Overlay; die Nie-Leer-Doktrin :532-535 gilt NUR fuer MessGates -- nicht kopieren).
  Test-/Hex-Pins (SELBER Change): test_m_w12_stamp_bausteine.cpp :757 (Format-static_assert),
  :2201/:2378-2380 (Arrays folgen Count automatisch); test_r3_mess_gates_spiegel.cpp :137-138
  (Format=4, NEUN); test_lb1_knoten_heuristik_log.cpp :667-673; test_e24_c10_g6_identitaets_
  bilanz.cpp :178-180 (Format/9/System=2) + Leer-Digest-Hex-Pins; test_g3_sha512_index.cpp :89-90
  kFrozenFingerprintV1 ("Alle drei Fundstellen dieses EINEN Vektors im SELBEN Commit gedreht"),
  :96 frozen_lines folgt Count; test_d4_ceb_schluessel_wahl.cpp Hex-Pins (kCebFingerprint bewegt
  sich DEKLARIERT: Historie ceb_version_stamp.hpp :110-112, Muster des R-3-Bumps); test_w10_
  system_cell_values.cpp Hex-Pins. Frozen-Hex-Traeger gesamt (grep): test_e24_c10_g6, test_w10,
  test_m_w12, test_d4, test_g3 + ceb_version_stamp.hpp.
  bestandslog_factory.hpp :66/:84 folgen Count symbolisch; :87 Fehltext "Format 3: acht" = stale,
  mitziehen. Stale-Kommentare: mess_achsen_naht.hpp :186 ("= 8"), build_orchestrator.hpp :339
  ("ACHT Glieder"; :402 sagt korrekt 9), ceb_version_stamp.hpp :71.
  ceb_version_stamp.hpp: kCebFingerprint rechnet ueber hex() (:592-598) -> bewegt sich beim
  Format-Bump zwingend mit; CEB reicht neue Glieder NICHT (3-arg-Form bleibt, Glied leer).
(c) Bau-Reihenfolge: Budget (A-02) VOR oder MIT dem Glied; Glied+Count+Format+Positionen+Asserts
  in anatomy_fingerprint.hpp sind EIN unteilbarer Edit (Asserts koppeln sie); POD/Layout (unten)
  im SELBEN Commit, sonst zwei Invalidierungswellen.
(d) OFFEN (Owner, A-03-Anteil): Byte-GRAMMATIK der Hybrid-Map-Zeile (Synthese-Key existiert
  nicht; Map-VALUE = Tier-SHA statt Voll-Stempel, KON47-02) -- ohne sie ist das Glied-Budget
  nur schaetzbar. OFFEN (autonom vertretbar, R-3-Praezedenz anhaengen): Schwanz-Position [9].

## 2 POSTEN A-02: PREIMAGE-BUDGET (kAnatomyFingerprintPreimageMax=4096)

(a) :68 = 4096; BudgetSum HEUTE 3688 -> Luft 408 Byte. Hybrid-Map-Zeile mit 32 Docks
(kHybridNodeObergrenzeDefault=32, s.o.) x (Tier-SHA 128 hex + Key/Trenner ~17) >= ~4,6 KB:
sprengt die Luft UND die 4096 allein -- Wellenplan-A-02 am Objekt bestaetigt.
Auftrags-Rechnung 18 Achsen x voll deklarierter Flag-Tail (GRAMMATIK-Obergrenze, nicht Ist):
Organ-Zeile worst = 546 (laengste reale binary_id) + 18*(1+kMaxRenderedAlgoSemVerLen 1752)
= ~32,1 KB >> OrganMax 768 >> 4096; real geuebt ist Tiefe 1 / Tail "c{p.e}" (58-Knoten-Vollausbau
waere CT-legal). Zweites Budget: sha512-Body-Deckel 50 KB (src/sha512/ctsha512.hpp:164-166) --
32,1 KB laege noch darunter, 8-16 KB PreimageMax erst recht.
(b) Wachen: :480-483 (BudgetSum<=PreimageMax, zieht automatisch), je-Glied-Asserts :487-502
(neues Glied braucht eigene Max-Konstante + Zeile), consteval-Puffer :742 folgt der Konstante.
(c) Reihenfolge: Konstante+Beleg heben BEVOR das 10. Glied eingehaengt wird (sonst bricht der
Budget-Assert mitten im Edit). (d) AUTONOM nach Haus-Muster (Ist-basiertes Budget MIT Beleg,
Header verlangt es woertlich :59-67); OFFEN dahinter: ob PreimageMax kuenftig die
Grammatik-Obergrenze (33 KB) statt Ist tragen soll -- Owner-Frage, beruehrt A-04-Philosophie.

## 3 POSTEN LAYOUT 6->7 + S-6a-POD (anatomy_module_abi_v1_decl.hpp)

(a) Fundstellen s. Abschnitt 0. S-6a (Wellenplan Z.2001): Umstellung MESS,SYSTEM,ORGAN an allen
drei Aussen-Ebenen Makro/POD/Preimage; POD-Seite = Feld-Reihung in AnatomyVersionLines (:201-244).
"decl.hpp:293-Verbot" = HEUTE :306-307 (Probe 7=false).
(b) Wachen/Mitzieher bei 6->7:
  decl.hpp: :267 Layout=7; :274-276 sizeof-Pin (120 -> 136 bei EINEM neuen {ptr,len}-Paar;
  reine S-6a-Umsortierung liesse 120 stehen, verschiebt nur Offsets); :286-288 ==7;
  :301-307 Proben NEU: 7=true, 6=false (K-4-Lehre: Layout 6 hat ANDERE Offsets!), 5=false,
  8=false; :231-232 Leser-Doktrin-Text; Probe-Konstruktor :294 (Aritaet waechst).
  Makro anatomy_module_abi_v1.hpp :187-205 (POD-Initializer). Loader-Seite mess_konsistenz_
  gate.hpp :56 (Doku "!= 6"), :113/:142 (symbolisch), :240-241 (Funktions-Call, zieht selbst),
  :346; anatomy_module_loader.hpp :142 (Doku).
  Tests: test_v41_anatomy_module_abi.cpp :126-128 static_assert Layout==6 GEKOPPELT an den
  kCebContractCodegenMinor-Entscheid ("wer das Layout bumpt, entscheidet im SELBEN Commit");
  test_m_w12_stamp_bausteine.cpp :673-681 (==6), :703-705 (Proben 5/6/7), :1296-1304
  (POD-Literal 16-feldrig + ==6); test_d2_mess_konsistenz_gate.cpp :82-96 mach_pod (16
  positionale Initialisierer) + :149/:170/:226/:237/:274; test_w10_system_cell_values.cpp
  :330-332; test_r3_mess_gate_fingerprint_biss.cpp :131-134 (symbolisch, zieht selbst).
  FALLE (am Objekt geprueft, Regel "erst laute Compile-Fehler"): (i) neue Felder ans POD-ENDE
  machen 16er-Aggregat-Inits NICHT laut -- Restfelder werden value-initialisiert (nullptr!),
  bricht die ""-Doktrin STILL an decl:294 / test_d2:82 / test_m_w12:1296; (ii) die S-6a-
  UMSORTIERUNG tauscht gleichtypige {char const*,uint64}-Felder -- positionale Inits kompilieren
  weiter und vertauschen Werte STILL. Vor dem Verschieben laute Bruchstelle schaffen
  (Feld-UMBENENNUNG + designierte Initialisierer an den drei Literal-Stellen, oder Traeger-Typen).
(c) Reihenfolge: Layout-Bump NUR im selben Commit wie Format-Bump (ein Bruch, Wellenplan 19.1);
kCebContractCodegenMinor-Entscheid im SELBEN Commit (test_v41-Pin); danach Konsumenten+Tests.
(d) OFFEN (Owner, = A-04): ob die POD-/Preimage-ORDNUNG wirklich auf MESS,SYSTEM,ORGAN dreht
oder Folge bleibt und nur Glieder/Felder hinzukommen. ACHTUNG golden: die MAKRO-Ebene von S-6a
(Argument-Reihenfolge des emittierten CALLs) braeche golden-CRC 0xF1C1F26A1232073B -- POD- und
Preimage-Ebene allein sind golden-neutral (Fingerprint materialisiert in der Expansion,
anatomy_fingerprint.hpp:14-17, adhoc_emitter.hpp:104). Grenzziehung gehoert VOR den Bruch.
AUTONOM nach Praezedenz A13-M4/W10-M2/B14-NB4: Minor-Bump 1->2 unter Major 9 als deklarierte
Bucket-Invalidierung (Fingerprint bewegt sich durch Format 5 ohnehin flottenweit).

## 4 POSTEN A-07: E-1-HEURISTIK-REKURSIONS-FELDER (Tiefe + Stufen-IDs) -> #38a2

(a) NULLBEFUND MIT GEGENPROBE: im Preimage/POD existiert KEIN Rekursions-/Stufen-Feld
(Voll-Lektuere beider Header; grep RekursionsTiefe/stufen_id ueber abi+builder = 0). Die
CT-Mechanik EXISTIERT in hybrid/heuristik_adapter_synthese_matrix.hpp: :14 "Heuristik-
Funktions-Stufen-IDs im Stempel ablesbar" (Ziel-Prosa), :99 kHybridRestTiefeDefault=1
("Tiefe bei 1 belassen, muss aber funktionieren"), :139 stufen_id(), :220-238 Formel-Pins.
(b) Bricht dieselben Format-/Layout-Wachen wie A-01, KEINE zusaetzlichen: die Felder muessen in
den EINEN 4->5/6->7-Bruch (sonst Format 5->6 gleich hinterher). Heuristik-Kategorie des
S-14a-Riegels (6 Marker-Dateien libs/cache_engine/heuristik/, AXIS_ALGO_VERSION 1/2/2/1/1/2)
wird NUR beruehrt, falls die Umsetzung diese Header anfasst -> Marker-Bump + Lock-Regen Exit 3.
(c) VOR dem Bruch die FELD-FORM festlegen (sonst unplanbar). (d) OFFEN (Owner): eigenes Glied
vs. Felder IN der Hybrid-Map-Zeile vs. POD-Felder; Owner-Anker Z15504 sagt nur "als
Stempel-Felder". Tiefe heute konstant 1 -- reicht ein Feld je Stufe (IDs nach 32er-Formel)?

## 5 WACHEN-/GOLDEN-BILANZ DES GESAMT-BUENDELS (Gruppe-1-Sicht)

S-14a-Riegel (718 Records): tools/axis_version_lock/axis_version_lock.cpp :76 (712 Overlay-
Quellen: organ 640, system 16, mess 1, tier_substanz 55 + heuristik 6); Lock tools/axis_version_
lock/axis_version.lock (v3, 2181 Zeilen); CI contract:axis-version-lock .gitlab-ci.yml:788-852;
ctest test_s14_axis_version_lock_tripwire; Inventar-Bezug test_t6_wachen_inventar.cpp :302-303.
GEGENPROBE: die Gruppe-1-Kerndateien (include/cache_engine/abi/*) stehen NICHT im Lock (grep
anatomy_fingerprint/anatomy_module_abi im Lock = 0) -- der Kern-Bruch loest den Riegel NICHT aus.
Er feuert erst, wenn das Buendel anatomy/ (tier_substanz, z.B. abi_adapter.hpp bei A-12/B3),
organ_axes/, topics/ oder heuristik/ anfasst -- deckt sich mit A-13 (EISERNE REGEL: nichts unter
axes/topics/heuristik, Overlay-Glied [7] hasht Quelltext).
ci_test_inventory_floor.txt (scripts/): avx512f 495, avx2 491, basis 489 -- EXAKT-Anker; jede im
Buendel neu registrierte/entfernte ctest-Registrierung zieht ALLE DREI Sprossen im SELBEN Change
(ci_test_coverage_guard.sh, Exit 4 in BEIDE Richtungen).
golden: CRC 0xF1C1F26A1232073B + kNewGolden131072Crc64 byte-neutral, SOLANGE der emittierte
Makro-CALL (2/3-arg) unveraendert bleibt (Beleg-Kette anatomy_fingerprint.hpp:14-17,
anatomy_module_abi_v1.hpp GOLDEN-NEUTRAL, adhoc_emitter.hpp:104). binary_id unberuehrt (kein
neues Organ-Segment in Gruppe 1). Ausnahme s. Abschnitt 3(d): S-6a-MAKRO-Ebene.
.fingerprint-Sidecars: Format 5 laesst JEDEN Tier-Bestand mismatchen (fail-closed Neubau) --
gewollte, EINMALIGE Welle; Kostenlage vor Voll-Bau pruefen (B14-NB4-Absatz decl:483-486).

## 6 DELTA KARTEN/PLAENE GEGEN HEAD (Erhebungsdatum-Doktrin)

- Wellenplan A-04 ":601" -> heute :593-605 (Folge) / :643-646 (Count-Pin). r4 zitiert ":106/:369"
  -> heute :116/:416. Wellenplan Z.2001 "decl.hpp:293" -> heute :306-307.
- Zusatzliste "kCebFingerprint rendert ANGEBOT (r3 A1)": an HEAD GEHEILT -- M-1/D-4 06.08.,
  ceb_version_stamp.hpp :8-10, :607-608 rendert die WAHL (kCebCtLegend). Posten nicht mehr offen.
- Zusatzliste "COMDARE_MEASUREMENT_ON ohne Preimage-Glied (r3 A3)": an HEAD GEHEILT -- R-3
  MessGatesGlied [8], Feld m spiegelt COMDARE_MEASUREMENT_ON (test_r3_mess_gates_spiegel
  :130-132). r3-A2-Kern (Glied [3] deklariert, Bau ignoriert; perm_mess_defines hart =1) bleibt
  als eigener Posten ausserhalb Gruppe 1.
- r4 A-06 BESTAETIGT: 20260806-PLAN-versionierungs-interface-stempel.md rechnet mit Format 3 /
  8 Gliedern (Plan Z.29, Z.337 "fingerprint_format; ///< 3", Z.540, Z.562-563); die dort
  geplante Wache nutzt kStampKategorieCount -- existiert NIRGENDS im Repo (grep = 0, Gegenprobe:
  kein Aufrufer/Includer). Bei Wiederaufnahme gegen Format 5 / 10 Glieder rechnen, im selben
  Bruch mitziehen.
- Auftragstext "kMaxFlag* aus flag_grammar_catalog.hpp": FALSCHE DATEI -- Konstanten wohnen in
  measurement/algo_semver.hpp :419/:439/:444 (Gegenprobe s. Abschnitt 0).

## 7 BAU-REIHENFOLGE INNERHALB DES BUENDELS (Gruppe-1-Zwaenge, kondensiert)

1. Owner-Entscheide VOR dem ersten Byte: A-04 (Folge/AxisKind topics/axis.hpp:17-50, 6 Werte:
   organ, system_measurement, system_config, system_meta_meta, measurement_meta_meta,
   organ_meta_meta), A-03-Grammatik (Hybrid-Map-Zeile), A-07-Feldform, S-6a-Makro-Grenze.
2. A-02 Budget heben (neue Glied-Max-Konstante + Beleg + PreimageMax).
3. anatomy_fingerprint.hpp EIN Edit: Traeger + Count=10 + Format=5 + Positionen + alle Asserts
   + Sperren-Text; im SELBEN Commit decl.hpp Layout=7 (+S-6a-POD falls entschieden) + sizeof-Pin
   + ==7 + Proben (6=false!) + kCebContractCodegenMinor-Entscheid + Makro-POD/hex-Aufruf.
4. Laute-Bruch-Vorstufe fuer POD-Aenderung (Umbenennung/designierte Inits) VOR dem Verschieben.
5. Konsumenten/Stale-Texte + ALLE Test-Pins (Abschnitte 1b/3b) + Hex-Pins NEU messen im SELBEN
   Change; ctest Debug UND Release; Floor-Sprossen nur bei Registrierungs-Aenderung.
