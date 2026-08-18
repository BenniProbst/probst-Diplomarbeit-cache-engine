# FINDINGS-SAMMELLISTE #15-BRUCH (A2.1b-Pflicht: jede Finding-Zeile sofort hierher)
# Stand: 18.08. nach Lens-C-Ernte + 36 Audit-Verdikten. Konsumiert von der A2.5-FIX-Stufe.
# Dreiwertig quittieren: BEHOBEN (Rot-zuerst) / ENTLASTET (Messung) / VERTAGT (Grund+Platz+Task).

## CODEX LENS C (POD/Makros/Gates) — Roh-Verdikt NICHT_LANDBAR; nach F1-Entlastung effektiv LANDBAR_MIT_FIXES
- [C-F1] BLOCKER "7. Hybrid-Makrostelle fehlt" — **ENTLASTET 18.08. (Lead, V1)**: Scope-Artefakt des
  l1c-Zuschnitts; hybrid_module_abi_v1.hpp:70 COMDARE_DEFINE_HYBRID_MODULE traegt beide Symbole,
  :101 gattung_of((ZielGenusExpr)), :104 genus=(ZielGenusExpr) = Ziel-Genus (Weg C). Deckt Lens A.
- [C-F2] HOCH decl.hpp:~445 Typ-Folge-Wache: 18 Typen statt 20 — name_line(FeldZgr)/name_len(FeldU64)
  fehlen am Ende => Wache blind fuer Typwechsel der 2 Append-Felder; Kommentare "18 Argumente"/"19. Feld"
  (:435) mitziehen auf 20/21. Indiz am Objekt: :392 FeldZahl=20, :435 sagt 18. → A2.5 PRUEFEN+FIXEN.
- [C-F3] MITTEL decl.hpp:~548 stamp_pod_layout_probe(6u) baut KEIN Layout-6 (nur Versionszahl 6 am
  20-Feld-Layout) — K-4-Klasse: prueft Zahl, nicht Offsets. Fix-Optionen: Layout-6-Mirror (sizeof==120,
  offsetof-Vergleiche) ODER Probe ehrlich als Nur-Zahlen-Beweis dokumentieren. → A2.5.
- [C-F4] MITTEL decl.hpp:~780/784 kCebContractCodegenMinor==kCebContractCodegenMinorAbi7==2, beide
  oeffentlich+typgleich — Verwechslungsrisiko wird erst beim naechsten Live-Bump still falsch.
  Fix-Vorschlag: Abi7-Tupel kapseln/Verwendung technisch begrenzen. → A2.5 (ggf. VERTAGT mit Task).
- [C-F5] NIEDRIG 2 stale Kommentare: "sizeof 136" (decl:314-Umfeld) + "4 Loader-Pflicht-Symbole"
  (real 6). → A2.5 FIXEN (trivial).
- Lens-C-BESTAETIGUNGEN (positiv, fuer die Landung zitierfaehig): POD 20 Felder, 8+9x16=152 @align 8;
  designierte Initialisierer vollstaendig + MESS,SYSTEM,ORGAN; 6 sichtbare Makros signatur-identisch,
  Fortsetzungszeilen nach 120-Normierung intakt; Gate-Grammatik 3-fach synchron auf 9 Felder,
  1u<<9=512, AUS-Laenge 3+26+8=37 nachgerechnet.

## AUDIT-VERDIKTE (36 von 688; Rest laeuft sequentiell) — Substanz der 6 Nicht-ERFUELLT
- [A-LS2-34] KRITISCH: Lock-Regen fehlt in den 25 Commits (target_isa_complex_axis.hpp geaendert
  765ee421, Lock traegt alten Digest 8e2de63f vs. real adc0c0e0) — DECKUNGSGLEICH mit deklariertem
  Lande-Schritt (Lock-Regen am ENDSTAND, KON116). → In Lande-Kette Schritt 3; KEIN Worktree-Fix vorab
  noetig (Regen gehoert an den Merge-Endstand).
- [A-seg1-37] KRITISCH: AxisKind-Ordnung NICHT gedreht, Gegenteil-Entscheid in
  anatomy_fingerprint.hpp:891-914 dokumentiert — GEDECKT durch KON5-04 (Owner-VORLAGE, nie festgelegt)
  → F2-Owner-Vorlage Punkt 1, kein stiller Fix.
- [A-seg1-04] ERNST: 3 stale E-6-Verweise (hybrid_config_xml.hpp:52-55 "KEIN REGISTRY-EINTRAG (22->23)
  ... offene Owner-Frage E-6", hybrid/README.md:33, super-Konformitaet) — ueberholt durch KON118.
  → A2.5 FIXEN (Doku-Wahrheit im Code; kGenusBuildSlotCounts 5->6 IST gebaut).
- [A-seg1-40] ERNST: planner_version.hpp fingerprint_sha() weiter leer (V-08R nur NAME-Haelfte im
  Bruch) → A2.5-TRIAGE: Buendel-SOLL oder deklarierter Folgeposten? (B-6-Split pruefen.)
- [A-seg1-43] ERNST: ceb_tooling_list validiert wallclock/macro/micro-ORDNUNG nicht — haengt an V-13
  (Owner-Scheibe unbeantwortet) → TRIAGE: vermutlich deklariert-ungedeckt; ggf. Vorlagen-Punkt.
- [A-seg1-45] ERNST: measurement_snapshot.hpp nur pmc_available, 5 Quell-Flags nicht uebernommen —
  #83-Umfeld (PMC fail-loud, eigener pending Task) → TRIAGE: nicht Kern-Buendel.
- [A-seg1-44] ERNST: golden-Nachposten — nur S-6a-Anker im Bruch; K1-avx512/E-B/telemetry-silent NICHT
  → TRIAGE gegen Task-#15-Text ("3 golden-Nachposten") vs. Uebergabe ("E-B/A-11 = golden-Folgezug,
  V-03R-Budget frei"). Synthese entscheidet; Spannung NICHT glattrechnen.
- [A-LS2-33] ERNST: simd_organ_requirement 9 Zeilen kRequiredNone vs. Registry 18 — bekannter
  A1-Durchzug-Posten (18 Achsen, W1) → TRIAGE: kein Bruch-Regress, aber W1-Frist beachten.
- [A-seg4-15] ERNST: ci/tests/*.sh 13->14 gewachsen (guard_basis_bissprobe.sh) — S-16-Dauerposten/W2.
- [A-seg3-kon28-01] ERNST: Ledger:23340 §69.6 "prod1=24 Worker" ohne UEBERHOLT-Marker → docs-Zug.
- [A-seg3-kon8-11+kon22-01c] HINWEIS: SHA-Zuordnung 9f8e2be8 vs. 3ba0f7b3 (Ledger-Detail) ·
  super build:clang Kill-Switch when:never + docs-only changes (D-2-Kandidat) → docs-/W2-Triage.

## CODEX LENS D (Semantik-Kern) — Roh-Verdikt NICHT_LANDBAR; nach Objekt-Triage 2 Scope-Artefakte, 4 echte Posten
- [D-F7] "Q2-Datei fehlt vollstaendig" — **ENTLASTET (Lead, V1)**: test_q2_identitaets_riegel.cpp
  existiert (8039 B), Fixture-Tabelle prueft EXAKTE Stati (:111 alt_major7 -> status_magic_mismatch,
  nicht !=ok), "RIEGEL OK"-Ausgaben :96. Scope-Artefakt des l2a-Zuschnitts.
- [D-F4a] "Emitter rendert MergeStrategy" — **ENTLASTET**: sota_catalog.hpp:238/:243 rendert
  pf::PrueflingVerbundStrategy:: (umgestellt). ABER [D-F4b] ERNST HAELT: merge_mode_to_strategy
  ("merge")=>String "Verbund2_Hybrid" (merge_plan.hpp:78), Enum kennt NUR Verbund1/2_Replace/3_Union
  => Emission des merge-Pfads erzeugte UNGUELTIGES C++; Kommentar :69-73 deklariert es als dormant,
  aber OHNE fail-loud-Riegel vor der Emission. → A2.5: Emission fuer "merge" gezielt LAUT ablehnen
  (oder Enum-Wert materialisieren — dormant-Deklaration allein traegt nicht, LUECKE=PFLICHT).
- [D-F3] HOCH->TRIAGE: "fulljoin" faellt in merge_plan.hpp:79 still auf Verbund2_Replace; Validator
  kennt {"replace","merge","union"} (validate_profile.hpp:705) + union-Phase-3-Regel :1157 —
  ENTLASTET, WENN der Validator unbekannte Tokens hart ablehnt (Q1-Wache is_bekannter_verbund_
  strategie_name pruefen); sonst fail-loud-Fix in merge_plan. → A2.5 misst den Ablehnpfad.
- [D-F5] ERNST HAELT (T-2/T-4-Klasse): test_hy_f8_reroute.cpp:126-151 bindet `antrieb = &ziel`
  DIREKT — der Roundtrip-Koeder umgeht die Dock-Weiterleitung; kaputtes Dock bliebe gruen.
  → A2.5: Antrieb ueber den Proxy-/Dock-Griff beziehen, Koeder durchs Dock fahren.
- [D-F6] TEIL: dlopen-Haelfte belegt 4 Symbole; der 6-Symbol-Beleg lebt im Q2-Test — A2.5 prueft,
  ob JE Modul alle 6 handle-lokal aufgeloest werden + Set-Modul-Cast-Ergebnis ungeprueft bleibt
  (Codex-Punkt haelt fuer die F8-Haelfte). → A2.5 nachziehen (Set-Proxy-Typ pruefen).
- [D-F1] MITTEL: resolve_measure_parallelism_of_mode()/debug-Exception ohne Tests. → A2.5-Triage.
- [D-F2] MITTEL: work_mode-Namen-Anker doppelt gepflegt, Fehlertext nennt Release vor Compare.
  → A2.5 (klein).
- [D-F8] NIEDRIG: test_hy_f8 nutzt std::cout ohne <iostream>. → A2.5 (trivial).
- Lens-D-BESTAETIGUNGEN: 3 implementierte Verbund-Strategien altsemantik-treu; 4 work_modes nutzen
  Release; Token-Weg bewahrt Gate/Env/nproc-Fallback; B4-Werte 4/6 direkt geprueft.

## CODEX LENS A (Loader/Hybrid) — NICHT_LANDBAR, 7 Findings (der schaerfste Lens; A2.5-Kernmaterial)
- [A-F1] KRITISCH hybrid_binary_proxy.hpp:225-229/:251-264/:278-280: ziel_binden() nimmt ZWEI
  unabhaengige Zeiger ohne gepaarte Nullheit/Objektidentitaet/Genus-Pruefung (basis->genus()==ZielGenus)
  — antrieb und ziel_ koennen auf VERSCHIEDENE Objekte zeigen; genus() kann nach dem Loader-Gate auf
  FunctionInterfaceReroute wechseln. Fix: EIN typisierter Binding-Handle ODER Nullheit+Identitaet+
  Genus-Check atomar vor jeder Mutation. → A2.5 PFLICHT.
- [A-F2] ERNST ebd. :183-193/:258-280: MaxDocks 1..32, aber EIN globales ziel_ — zweiter Slot
  verdreht Lifecycle/genus(); Slot-Loesen loescht ziel_ fremder Slots. Fix Minimal-Schnitt:
  static_assert(MaxDocks==1); Mehrfach-Docks = slotbezogene Basiszeiger (HY-B/W3-Design). → A2.5.
- [A-F3] ERNST hybrid_module_abi_v1.hpp:71-72/:99-104: ZielGenusExpr wird ZWEIMAL ausgewertet
  (Template-Arg + Laufzeit) — kontextabhaengiger Ausdruck (is_constant_evaluated) umgeht die
  CT-Sperre (Loader faengt es nur als Status 11). Fix: Ziel EINMAL als constexpr AnatomyGenus
  einfrieren, beide Exports daraus ableiten. → A2.5.
- [A-F4] ERNST anatomy_module_loader.cpp:199-205: werfendes Logging (dll_path.string()) VOR
  pfn_destroy/native_unload — Exception leakt Instanz+Handle. Fix: Scope-Guards ab Erwerb,
  Diagnose erst nach Cleanup. → A2.5.
- [A-F5] ERNST ebd. :179-180/:198: rohe uint8->Enum-Casts ungeprueft — ein Modul, das konsistent
  Genus 5 (Reroute) meldet, PASSIERT den Riegel, obwohl Genus 5 nie ABI-sichtbar sein darf; unbekannte
  Bytes erreichen gattung_of(). Fix: Rohwert-Whitelist der 5 ABI-sichtbaren Ziel-Genera VOR dem Cast,
  sonst status_identity_mismatch + unload. → A2.5 PFLICHT.
- [A-F6] HINWEIS proxy :86-121: kDeklarierteRerouteZiele==2-Assert tautologisch; Fix: geschlossene
  constexpr-Whitelist {SearchAlgorithm, Set}, Praedikat+Anzahl daraus. → A2.5 (klein).
- [A-F7] HINWEIS Doku-Nachzuege: loader.cpp:211 "4 Pflicht-Symbole"->6 · hybrid_module_abi_v1.hpp
  :7-10/:52-56 "vier"->6 · genus_build_admission.hpp:68/:90 "View=4"/"alle FUENF"->Reroute=5/sechs ·
  Bestandszeile "neun Codes"->zwoelf (0..11). → A2.5 (mit [C-F5] buendeln).
- Lens-A-BESTAETIGUNGEN: alle neuen Returns entladen korrekt, destroy VOR unload; virtuelle Flaeche
  vollstaendig delegiert, kein eigener Lifecycle-Zustand; 6 Exports extern "C" + Visibility korrekt;
  Alt-Major-Fixtures isolieren Magic/Major getrennt, kein ODR-Problem; Admission nutzt Hybrid-CT-
  Konstante, Groesse 6 + Cross-Pin korrekt.

## CODEX LENS B (Fingerprint/Name) — NICHT_LANDBAR, 9 Findings (2 KRITISCH identitaets-wirksam!)
- [B-F1] KRITISCH anatomy_fingerprint.hpp:511-531/:806-815/:1262-1291: Map-Grammatik-Wachen (64
  Lowerhex, kanonische Keys, Ordnung, Duplikate, ;/=-Position) gelten NUR im optionalen Builder —
  der produktive Weg (COMDARE_HYBRID_KOMPOSIT_GLIED / direkte KompositMapGlied{sv}) prueft nur die
  allgemeine Glied-Grammatik => nichtkanonische/mehrdeutige Maps moeglich. Fix: EIN gemeinsamer
  constexpr-Parser fuer den finalen String, im Carrier UND als static_assert auf dem Define
  (leer ODER <=32 Segmente, Key 1-8 Dezimal ohne fuehrende Nullen, genau ein '=', Wert exakt
  64 Lowerhex, ';' nur zwischen Segmenten, Keys streng steigend eindeutig). → A2.5 PFLICHT.
- [B-F2] KRITISCH ebd. :1222-1234: komposit_key_text() verwirft Stellen >8 STILL (100000000 und
  200000000 -> beide "00000000"); Ordnungswache vergleicht Original-IDs => KOLLISION unerkannt,
  ZWEI verschiedene Kompositionen koennen DASSELBE Preimage bekommen (Identitaets-GAU-Klasse).
  Fix: fail-loud bei rest>0 nach 8 Stellen bzw. stufen_id<=99'999'999 erzwingen + gekoppelten
  Nachweis des 32-Dock-Arguments. → A2.5 PFLICHT.
- [B-F3] ERNST ebd. :970-989/:1164-1174/:1309-1316: MessGatesGlied{""}-Default an allen 3 APIs,
  obwohl Kommentar den Default-Weg verbietet — TU-Gates (nie leer, identitaetswirksam) still
  auslassbar; die 3-Param-Proben nutzen genau diesen Weg. Fix: leeren Default entfernen, TU-Wert
  explizit verlangen (Overload-Schnitt wegen Default-Argument-Regeln). → A2.5.
- [B-F4] ERNST ebd. :1264-1291: Builder erzwingt 32-Dock-Deckel NICHT (33 Beitraege = 2233 B passen
  in 2368-B-Puffer). Fix: beitraege.size()<=Deckel fail-loud VOR der Schleife + im Map-Parser. → A2.5.
- [B-F5] ERNST ebd. :1208-1212: sv() auf Temporary erlaubt => dangling string_view trotz
  geloeschtem Carrier-Ctor. Fix: sv() const& + sv()&&=delete. → A2.5.
- [B-F6] ERNST ebd. :1362-1369: "64 Hex + Nullterminierung"-Wache prueft nur Arraygroesse+Byte 64,
  nicht [0..63] auf Lowerhex/eingebettete NULs. Fix: alle 64 Nutzbytes [0-9a-f] pruefen. → A2.5.
- [B-F7] HINWEIS ebd. :748-766: BudgetSum==6057 erkennt kompensierende Aenderungen NICHT (Kommentar
  behauptet es). Fix: 10 Einzel-Summanden einzeln pinnen (Array-Vergleich). → A2.5 (klein).
- [B-F8] HINWEIS ebd. :148-154: Begruendung "leeres 10. Glied byte-identisch ohne Bump" ist falsch
  (9. Separator kommt dazu); Format-5-Rechtfertigung bleibt (Umsortierung+Schema). Kommentar-Fix. → A2.5.
- [B-F9] HINWEIS ebd. :954-966: "nur Vertauschungen uebersetzen nicht mehr" gilt nur fuer S-6b,
  nicht S-6a (Mess/Organ wechseln [1]/[3]). Kommentar praezisieren. → A2.5.
- Lens-B-BESTAETIGUNGEN: anatomy_name_hex WIRKLICH consteval + Terminierung garantiert; Budget-
  Rechnung 32+768+256+256+128+512+1536+128+64+2368+9=6057 nachgerechnet (Reserve 2135); Erzeuger
  konsistent MESS,SYSTEM,ORGAN; Format 5/10 Glieder/Position [9] schluessig gepinnt; aeussere
  '\n'-Wache erfasst Glied 10; K-1-Sperren wirksam.

## AUS DEN 5 REVIEW-ERHEBERN (Stufe 1, zurueckgekehrt; 217 Stellen gescannt) — 3 NEUE Posten
- [E-1] ERNST (T-4): Loader-Codes 9/10 werden nirgends real ERZEUGT — Q2 prueft nur die
  NAME-Zuordnung; keine Negativ-Fixture ohne gattung-/genus-Symbol existiert. Fix: 2 Fixtures
  (nur-gattung-fehlt / nur-genus-fehlt) mit exakter Status-Erwartung. → A2.5.
- [E-2] MITTEL (mit D-F1): measure_parallelism.hpp:35-53 — Env "0"->nproc still (v>0-Kante) +
  Ziffern-Akkumulation ohne Bereichsdeckel. → A2.5.
- [E-3] HINWEIS-TRIAGE: test_validate_profile.cpp:607-626 — zweiter Nenner fehlt (leeres
  load_profiles/ => known leer => workloads-Zweig ungeprueft, stille-Null-Klasse). → A2.5-Triage.
- VERSTAERKUNGEN: B-F1 belegt mit Erheber-Wahrheitstafel ('12=abc;44=xy'->true, 'a==b'->true,
  ';x=1'->true) · D-F6-Rest woertlich (Set-Cast ausgefuehrt, nicht gemessen) · D-F3: {merge leer}
  = dokumentierte Default-Semantik, Triage nur fuer unbekannte Tokens.
- RESUME-BILANZ 15:05: KEIN weiterer nicht-doppelter failed Workflow/Agent (18 Task-Outputs
  geprueft; w78hb9hii = verwaister 0-Byte-Doppelstart des Review-Runs; Details Register 5c).

## OFFEN (Rueckkehrer ausstehend)
- Audit-Synthese (wg7df0h36, sequentiell ueber 652 Rest-Zusagen) — laeuft.
- Review-Bewerter 1-5 + Synthese (w5swesjti) — laeuft.
