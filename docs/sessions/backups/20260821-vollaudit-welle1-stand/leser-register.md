# SAMMELSTRECKE: Register 20260818-SESSION-REGRESSIONEN-bump15-codex-audit-review.md

Quelle: docs/sessions/20260818-SESSION-REGRESSIONEN-bump15-codex-audit-review.md (1294 Zeilen)
Gelesen: Z1-1294 von 1294 (VOLLSTAENDIG -- eigene Volllesung Block 1-6 verifiziert Z1-999 gegen Vorstand + ergaenzt Z1000-1294)

| KUERZEL/Name | Klasse | Quelle | Status LAUT QUELLE | Traeger/Task |
|---|---|---|---|---|
| Owner-Auftrag 18.08. Regressionen-Register erstellen (codex zuerst, dann Workflows konsolidieren) | OWNER-ENTSCHEID | Z3-5 | GEGEBEN | Owner |
| #15-Bruch (wt-ce-bump15, bau/bump15-preimage-bruch@67dafa46, 25 Commits auf ce/development 20c111c4) | AUFGABE | Z6-9 | OFFEN (ungelandet) | wt-ce-bump15 |
| Quellen-Stand: 4/4 Codex-Lenses + 36/688 Audit-Verdikte; Abschnitt 5/6 Platzhalter | UNKLAR | Z7-11 | OFFEN (ausstehend) | wf_13b562e7, wf_794b904b |
| Dreiwertige Quittung BEHOBEN/ENTLASTET/VERTAGT je Fund (A2.5-Weg) | OWNER-ENTSCHEID | Z12-13 | GEGEBEN (Verfahrensregel) | Fix-Stufe A2.5 |
| Lage: 3 KRITISCH + ~12 ERNST echte Funde, Bruch landet erst nach voller A2.5-Fix-Runde | UNKLAR | Z17-19 | OFFEN | - |
| B-F2 Preimage-KOLLISION durch stillen Stellen-Verwurf (komposit_key_text) | REGRESSION | Z28-34 (1.1 KRITISCH) | BEHOBEN (Fixstrecke1 18.08., Rot-zuerst: 100000001/200000001->selber Key REAL erzeugt vor Fix, s. Z488-489) | anatomy_fingerprint.hpp:1222-1234, g1-fingerprint 35ab0c46 |
| B-F1 Map-Grammatik nur im optionalen Builder bewacht | REGRESSION | Z35-41 (1.1 KRITISCH) | BEHOBEN (Fixstrecke1, verschaerft durch Fix11: zweite Digest-Kollisionsklasse '1=x;2=y' Ein-/Zweisegment ebenfalls geschlossen) | ebd.:511-531/:806-815/:1262-1291, g1-fingerprint 35ab0c46 |
| A-F1 Proxy-Bindungszustand spaltbar (ziel_binden) | REGRESSION | Z42-47 (1.1 KRITISCH) | BEHOBEN (Fixstrecke1, gekoppelt mit D-F5-Fix: ziel_binden-Nullpaarungs-Gate) | hybrid_binary_proxy.hpp:225-229/:251-264/:278-280, g3-hybrid 9378e463 |
| A-F5 Loader: rohe uint8->Enum-Casts ungeprueft | REGRESSION | Z51-55 (1.2 ERNST) | BEHOBEN (Fixstrecke1 Fix2: genus_bekannt()+ist_abi_sichtbares_genus() als 2 Wertklassen, Gate-Flip-Mutation bewies dlopen-Pfad) | anatomy_module_loader.cpp:179-180/:198, g2-loader cc243c8c |
| A-F4 Leak-Pfad beim Identity-Mismatch | REGRESSION | Z56-58 (1.2 ERNST) | OFFEN | ebd.:199-205, FIX Scope-Guards |
| A-F3 CT-Sperre der Hybrid-Makros umgehbar | REGRESSION | Z59-63 (1.2 ERNST) | OFFEN | hybrid_module_abi_v1.hpp:71-72/:99-104, FIX Ziel einmal constexpr einfrieren |
| B-F3 Identitaetswirksamer leerer Default | REGRESSION | Z64-67 (1.2 ERNST) | OFFEN | anatomy_fingerprint.hpp:970-989/:1164-1174/:1309-1316, FIX Default entfernen |
| B-F4 32-Dock-Deckel unerzwungen | REGRESSION | Z68-70 (1.2 ERNST) | OFFEN | ebd.:1264-1291, FIX size()<=Deckel fail-loud |
| B-F5 Dangling string_view via Temporary | REGRESSION | Z71-74 (1.2 ERNST) | OFFEN | ebd.:1208-1212, FIX sv() const& + sv()&&=delete |
| B-F6 64-Hex-Wache prueft nur Byte 64 | REGRESSION | Z75-76 (1.2 ERNST) | OFFEN | ebd.:1362-1369, FIX alle 64 Bytes pruefen |
| C-F2 Typ-Folge-Wache 18 statt 20 Typen | REGRESSION | Z77-81 (1.2 ERNST) | OFFEN | anatomy_module_abi_v1_decl.hpp:~445, FIX FeldZgr/FeldU64 anhaengen |
| D-F4b Toter Enum-Name im Emissions-Pfad (Verbund2_Hybrid) | REGRESSION | Z82-88 (1.2 ERNST) | OFFEN | merge_plan.hpp:78, sota_catalog.hpp:238/:243, FIX "merge" laut ablehnen |
| D-F5 F8-Roundtrip-Koeder umgeht das Dock | REGRESSION | Z89-93 (1.2 ERNST) | OFFEN | test_hy_f8_reroute.cpp:126-151, FIX Griff ausschliesslich ueber Proxy/Dock |
| D-F6-Rest F8-dlopen-Haelfte 4/6 Symbole, Set-Cast-Ergebnis ignoriert | REGRESSION | Z94-96 (1.2 ERNST) | OFFEN | FIX alle 6 Symbole handle-lokal aufloesen |
| B-F7 BudgetSum==6057-Assert erkennt kompensierende Aenderungen nicht | REGRESSION | Z100-101 (1.3 HINWEIS) | BEHOBEN (Fixstrecke1: 768->767+256->257-Mutation feuerte neue Reihen-Wache) | g1-fingerprint 35ab0c46 |
| A-F6 kDeklarierteRerouteZiele==2-Assert tautologisch | REGRESSION | Z102-103 (1.3 HINWEIS) | OFFEN | FIX geschlossene constexpr-Whitelist |
| D-F2 work_mode-Namen-Anker doppelt gepflegt | REGRESSION | Z104-105 (1.3 HINWEIS) | OFFEN | FIX Single-Source |
| D-F1 resolve_measure_parallelism_of_mode()/"debug"-Exception ohne Tests | REGRESSION | Z106 (1.3 HINWEIS) | OFFEN | - |
| D-F8 test_hy_f8 nutzt std::cout ohne <iostream> | REGRESSION | Z107 (1.3 HINWEIS) | OFFEN | - |
| C-F5+A-F7 Kommentar-Wahrheiten (sizeof 136->152, 4->6 Pflicht-Symbole, View=4/Reroute=5, neun->zwoelf Codes) | REGRESSION | Z108-110 (1.3 HINWEIS) | OFFEN | Kommentare korrigieren |
| B-F8 "leeres 10. Glied waere byte-identisch" ist FALSCH | REGRESSION | Z111-112 (1.3 HINWEIS) | OFFEN | Kommentar-Korrektur |
| B-F9 "nur Vertauschungen uebersetzen nicht mehr" gilt nur S-6b, nicht S-6a | REGRESSION | Z112-113 (1.3 HINWEIS) | OFFEN | Kommentar-Korrektur |
| A-F2 MaxDocks-Vertrag vs. Ein-Ziel-Zustand (Proxy deklariert 1..32, haelt 1 ziel_) | REGRESSION | Z117-121 (Sec.2 Architektur) | OFFEN | hybrid_binary_proxy.hpp:183-193/:258-280, FIX static_assert(MaxDocks==1) |
| C-F4 Abi7-Freeze verwechselbar mit lebendem Minor | REGRESSION | Z122-125 (Sec.2) | VERTAGT (Fixstrecke1 einzige Ausnahme -> W2-Task) | decl.hpp:~780/:784 |
| D-F3 fail-loud-Kette der Verbund-Tokens ("fulljoin" faellt still auf Verbund2_Replace) | REGRESSION | Z126-130 (Sec.2) | OFFEN (bedingt ENTLASTET, in A2.5 zu MESSEN) | merge_plan.hpp:79, validate_profile.hpp:705 |
| C-F3 Layout-6-Probe prueft die ZAHL, nicht das Layout | REGRESSION | Z131-134 (Sec.2) | OFFEN | decl.hpp:~548, FIX eingefrorener Layout-6-Mirror |
| LS2-34 Lock-Regen fehlt in den 25 Commits (Audit KRITISCH) | REGRESSION | Z138-141 (Sec.3 Plan) | OFFEN (Plan deckungsgleich, Regen = Lande-Schritt 3) | axis_version.lock |
| seg1-37 AxisKind-Ordnung NICHT gedreht (Audit KRITISCH) | REGRESSION | Z142-145 (Sec.3) | OFFEN (gedeckt durch KON5-04, ohne GO teurer Preimage-Bruch) | F2-Owner-Vorlage Punkt 1 |
| seg1-04 3 stale E-6-Verweise | REGRESSION | Z146-148 (Sec.3) | OFFEN | hybrid_config_xml.hpp:52-55, hybrid/README.md:33, A2.5-Doku-Fix |
| seg1-40 V-08R nur zur NAME-Haelfte im Bruch (fingerprint_sha leer) | REGRESSION | Z149-151 (Sec.3) | OFFEN (Triage: Buendel-SOLL oder Folgeposten) | planner_version.hpp:78-84 |
| seg1-43 Tooling-ORDNUNG unvalidiert (wallclock/macro/micro haengt an V-13) | REGRESSION | Z152-154 (Sec.3) | OFFEN (Kandidat Vorlagen-Runde) | ceb_tooling_list |
| seg1-44 golden-Nachposten-Spannung (Bruch nur S-6a-Anker, nicht K1/E-B/telemetry) | REGRESSION | Z155-158 (Sec.3) | OFFEN (SPANNUNG AUSGEWIESEN) | Audit-Synthese + ggf. Owner-Satz |
| seg1-45 PMC-Snapshot traegt 1 statt 5 Flags | REGRESSION | Z159-161 (Sec.3) | OFFEN (Triage, #83-Umfeld) | measurement_snapshot.hpp |
| LS2-33 A1-Durchzug 9-vs-18 offen | REGRESSION | Z162-163 (Sec.3) | OFFEN | simd_organ_requirement, bekannter W1-Posten |
| seg4-15 S-16-Regression waechst (ci/tests 13->14, 8656 Zeilen) | REGRESSION | Z164-165 (Sec.3) | OFFEN (Dauerposten W2, KON37-08/S-16) | guard_basis_bissprobe.sh |
| seg3-kon28-01 Ledger-Marker fehlt (§69.6 prod1=24 Worker ohne UEBERHOLT-Vermerk, OD-7:16) | REGRESSION | Z166-167 (Sec.3) | OFFEN (Docs-Zug) | Ledger §69.6 |
| Hinweis: SHA-Zuordnungs-Detail 9f8e2be8-vs-3ba0f7b3 (Ledger) | REGRESSION | Z168-169 (Sec.3 Hinweise) | OFFEN | - |
| Hinweis: super build:clang Kill-Switch when:never + docs-only-changes | REGRESSION | Z168-169 (Sec.3 Hinweise) | OFFEN (D-2-Kandidat, W2-Triage) | - |
| 9x UEBERHOLT sind korrekt (Bruch ueberholt dev-Staende) | UNKLAR | Z170 (Sec.3) | ENTLASTET (Meta-Befund) | - |
| W1-V1 KRITISCH-PLAN: #17/g2-Strang ist UNGELANDET (Commit 1528f6fd nicht Ancestor von 20c111c4) | REGRESSION | Z175-180 (3b) | BEHOBEN/GELANDET (9.0, 19.08.: #17/g2 gelandet+gepusht ba33b9ac; g2-Schlussstueck TERMINAL SUCCESS 20:23Z) | #17/g2, gibt #7/S-19 frei (KON17-01) |
| W1-V2 ERNST-PLAN: B3 Schalter-Hoheits-Umzug ohne Bau-Spur (OWNER-DATUM VOR F2, KON34-04/KON37-01) | REGRESSION | Z181-184 (3b) | OFFEN | abi_adapter.hpp:476-491, W1-Audit Gruppe D |
| Task #93 VOLLES W1-AUDIT (8 sequentielle Pruefgruppen + Synthese) | AUFGABE | Z185-189 (3b) | GEPLANT (Start nach Review-/Audit-Ruecklauf) | workflows/scripts/w1-vollstaendigkeit-wf.js |
| C-F1 "7. Hybrid-Makrostelle fehlt" | REGRESSION | Z193-195 (Sec.4) | ENTLASTET (existiert mit beiden Symbolen) | hybrid_module_abi_v1.hpp:70/:101/:104 |
| D-F7 "Q2-Datei fehlt vollstaendig" | REGRESSION | Z196-197 (Sec.4) | ENTLASTET (existiert, 8039B, Fixture-Tabelle) | tests/unit/test_q2_identitaets_riegel.cpp |
| D-F4a "Emitter rendert MergeStrategy" | REGRESSION | Z198-199 (Sec.4) | ENTLASTET (D-F4b-Haelfte haelt weiter) | sota_catalog.hpp:238/:243 |
| E-1 ERNST (T-4-Klasse): Loader-Codes 9/10 nirgends real ERZEUGT (keine Negativ-Fixture) | REGRESSION | Z207-213 (Sec.5) | BEHOBEN (Fixstrecke1: 4 neue .so-Negativ-Fixtures Luegner->11/ohne-gattung->9/ohne-genus->10/alt-magic->magic_mismatch, echter dlopen-Weg) | test_q2_identitaets_riegel.cpp:127-136, g4-tests 7ccf7002 |
| E-2 MITTEL: measure_parallelism-Randzellen (Env "0"->nproc, Ueberlauf ohne Deckel) | REGRESSION | Z214-217 (Sec.5) | OFFEN (mit D-F1 buendeln) | measure_parallelism.hpp:35-53 |
| E-3 HINWEIS->TRIAGE: zweiter Nenner fehlt in test_validate_profile.cpp:607-626 | REGRESSION | Z218-221 (Sec.5) | OFFEN-TRIAGE (A2.5) | - |
| 5 Stufe-1-ERHEBER zurueck (217 erhobene Stellen, neutral) | AUFGABE | Z201-204 (Sec.5) | GELANDET (zurueckgekehrt, konsolidiert) | wf_13b562e7 |
| Claude-Review Bewerter+Synthese: GESAMT-VERDIKT LANDBAR_MIT_FIXES (5/5 Flaechen konvergieren) | OWNER-ENTSCHEID | Z237-247 (5b) | GELANDET (Verdikt), Fixes OFFEN | wf_13b562e7, 11/11 Agenten 0 Fehler 980k Tokens |
| Synthese: 33 Findings (1 KRITISCH/23 ERNST/9 HINWEIS), Fix-Liste 30 Posten | UNKLAR | Z241-243 (5b) | OFFEN (maschinenlesbar hinterlegt) | review-synthese-w5swesjti.json |
| Synthese-Begruendung: Bruch-Substanz nicht in Frage gestellt (Layout7/Format5/GliedCount10/S-6a/6-Symbole/POD152/Budget/HY-A2+A3/work_mode/V-11R korrekt gebaut) | UNKLAR | Z244-247 (5b) | ENTLASTET (Substanz bestaetigt) | - |
| Fix 3 (NEU) dritte Alt-Fixture pinnt Loader-Reihenfolge (Magic vor Symbol-Lookups) | REGRESSION | Z256-257 (5b Fix-Liste) | BEHOBEN (Fixstrecke1) | - |
| Fix 8 (NEU) Q2-Selbstvergleichs-Tautologie (gattung_of gegen sich selbst geprueft) | REGRESSION | Z261-262 | BEHOBEN (Fixstrecke1: unabhaengige erwartete_gattung-Spalte) | - |
| Fix 11 (verschaerft B-F1) '1=x;2=y' Ein-/Zwei-Segment-Map byte-identisch = zweite Digest-Kollisionsklasse | REGRESSION | Z263-264 | BEHOBEN (Fixstrecke1, s.o. B-F1) | constexpr-Grammatik-Pruefer |
| Fix 12 (NEU) KompositMapGlied-Laengen-Wache fehlt (Laufzeit-Weg waechst unbegrenzt) | REGRESSION | Z265-266 | BEHOBEN (Fixstrecke1) | Budget-Zusage war am Parameter-Eingang unwahr |
| Fix 14 (NEU) Offset-Pins 136/144 fuer name_line/name_len fehlen in Stamp-Tafel | REGRESSION | Z267-268 | BEHOBEN (Fixstrecke1) | - |
| Fix 15+16 (praezisiert D-F3/D-F4b) validate-Gate fuer merge + merge_mode_to_strategy fail-closed | REGRESSION | Z269-271 | BEHOBEN (Fixstrecke1, s.o. D-F3/D-F4b) | Alt-Token 'fulljoin' invertierte still Union->Replace |
| Fix 17 (NEU) debug-Restbestaende in run_methodology_registry-Doku (profile_run_entry:956 empfiehlt woertlich werfenden Fehlerpfad) | REGRESSION | Z272-273 | BEHOBEN (Fixstrecke1) | - |
| Fix 18 (NEU) 3 stale Vor-S-6a-Ordnungs-Saetze (fingerprint:1154/:577/:130) | REGRESSION | Z274-276 | BEHOBEN (Fixstrecke1) | Anleitung fuer falsche vierte Stelle |
| Fix 20 (NEU) lint_layer_includes.sh deckt hybrid/ nicht | REGRESSION | Z277-278 | BEHOBEN (Fixstrecke1) | Kante builder/->hybrid/ war unbewacht |
| Fix 21 clang-release-Vollbau+ctest am Tip VOR Landung PFLICHT (R1 heilt NUR-clang-ab-O2-Fehler) | AUFGABE | Z279-280 | GEGEBEN (Pflicht, erfuellt s. Z496-497) | Landungs-Vorbedingung |
| Fixes 22-30 HINWEISE (Cross-Pins HeuristikAdapter/Reroute-Aritaet, Budget-Prosa maschinell, ~4600->4416, Test-Umbenennung At120->At152, stale Anker, Mengen-Kommentare, Overflow-Gate, (d)-Anker, Klassifikations-Historie) | REGRESSION | Z282-285 | BEHOBEN (Fixstrecke1, Pauschal-Bilanz) | - |
| 9 ENTLASTUNGEN der Synthese (clang-debug-PIE vorbestehend, Lock-Regen=Lande-Schritt, Stempel-Pflicht=golden-Folgezug, TABU-CRC haelt, Kern-Substanz richtig gebaut, (d)-prozessual-gedeckt, Overflow dormant, F8-Delegations-Proben echt, V-11R-K13 vorbildlich) | UNKLAR | Z286-289 | ENTLASTET | - |
| 5c RESUME-BILANZ: 18 heutige Task-Outputs geprueft; 2 unvollstaendige Workflows sind bereits sequentielle Resumes (Audit wf_794b904b als wg7df0h36, Review wf_13b562e7 als w5swesjti); mehrere Vorlaeufe/Doppelstarts identifiziert; KEIN weiterer nicht-doppelter failed Workflow | AUFGABE | Z291-298 (5c) | GEKLAERT | - |
| VOLL-AUDIT-SYNTHESE ENDSTAND (wf_794b904b): 502 ERFUELLT / 74 UEBERHOLT / 85 ABWEICHUNG / 22 FEHLT ueber 688 Zusagen (65/65 Agenten, 0 unverifiziert, >14h sequentiell 18.08. 14:47-19.08. 05:13 + Resume) | UNKLAR | Z300-307 (Sec.6) | ABGESCHLOSSEN | wf_794b904b |
| GESAMTURTEIL: UEBERWIEGEND JA (Soll-Erfuellung TEILWEISE, Doktrin-Treue JA/Verstoesse selbst geheilt, Beweis-Vollstaendigkeit TEILWEISE, Owner-Wort-Treue TEILWEISE/1 Rangfolge-Verstoss); LANDE-FREIGABE LANDBAR_MIT_FIXES (F1-F9), F1/F2/F3=PUSH-SPERREN | OWNER-ENTSCHEID | Z304-307 | GEGEBEN (Verdikt) | - |
| K1=F1 (PUSH-SPERRE) V-01R AxisKind-Dreh+CT-Zuordnung NICHT gebaut, Gegenteil-Entscheid mit doppelt ueberholtem KON5-04 dokumentiert; A2.3a-NEIN-Probe hiermit KORRIGIERT: V-01R gilt | REGRESSION | Z309-316 (Sec.6 KRITISCH) | OFFEN (PUSH-SPERRE) | bauen ODER Owner-Satz VOR Merge + KON119-Revision; = seg1-37/W1-V1-Verwandte |
| K2=F6 golden-gebundene Bauplan-Reste ohne EINEN terminierten Zug (telemetry-silent/B-9 build_version-wirksam, CRC-Anker-Zug B-10.3, Bissprobe B-11.2, A-11-Stempel-Pflicht traegerlos); Task-#15-Zusage '3 golden-Nachposten' unerfuellt; ENTLASTUNG: K1-avx512 korrekt nicht vorgezogen, id-CRC MATCH, seg1-81-NP-19-Falsch-Null | REGRESSION | Z317-322 | OFFEN | EIN golden-Ereignis VOR F2 terminieren, A-11 Task+T-1-Abnahme |
| K3 W1-Push ohne eigene Lande-Gate-Kette (KON114-02, 15971-Rot als Quittung) | REGRESSION | Z323-325 | BEHOBEN (GEHEILT, Lehre verankert), Rest: Pre-Push-Script mechanisieren | gilt auch E13/KON116-01 |
| E1 clang-debug-Kombibau-Viertel OHNE gruenen Volllauf; 'PIE vorbestehend'-Entlastung=V11-Stellvertreter; Verdacht ENABLE_EXPORTS(0d0ad521) link-wirksam -> F2 (PUSH-SPERRE) | REGRESSION | Z327-330 | OFFEN (PUSH-SPERRE) | Basis-Probe am 20c111c4 + Volllauf am Tip |
| E2 Endstand ungedeckt: realer Tip e285d316=30 Commits (Uebergaben nannten 25/32, nie literal gemessen); Hygiene deckt nur bis 67dafa46, ctest bis 19e7951a, 7 A2.5-Commits ungedeckt -> F3 (PUSH-SPERRE) | REGRESSION | Z330-332 | OFFEN (PUSH-SPERRE) | - |
| E3 tragende LastTest.log-Beweisorte im Worktree durch 0-Test-Laeufe zu FALSCH-NULLEN ueberschrieben (Belege nur in .review-tmp/g6_*+jobs-tmp) | REGRESSION | Z332-334 | OFFEN | Beweisorte umschreiben, kuenftig ctest --no-tests=error |
| E4 KON91-02-Paket (Comp-Gate/aggregate_required je COMP, organ_stamp_line, Disk-Suffix) fehlt trotz Buchung 'IM EINEN W1-BUMP-BUENDEL'; CEB-LAGER-REGISTRY-HASH-MAP nirgends -> F4 (deckt sich mit C-3a/#38a2) | REGRESSION | Z334-337 | OFFEN | - |
| E5 NP-23/24 PMC-Snapshot-Flags: POD-Wirksamkeit KLAEREN -> F5 | REGRESSION | Z337-338 | OFFEN | - |
| E6 E-6-Doku 0/3 -> F8 | REGRESSION | Z338 | OFFEN | - |
| E7 V-06-Stempel-Pflicht-Haelfte (A-11) traegerlos -> in F6 | REGRESSION | Z338-339 | OFFEN | - |
| E8 V-08R-SHA-Haelfte = #95 (Bau laeuft, K14) | AUFGABE | Z339 | IN BAU | #95 |
| E9 V-13 = #99 | AUFGABE | Z339 | OFFEN | #99 |
| E10 PMC-fail-loud = #83 (vor Trigger 26.08.) | AUFGABE | Z340 | OFFEN (Frist 26.08.) | #83 |
| E11 TSan-Beleg + F-9 fehlen im Bruch-Anker (F-9=Basis-Altbestand, HY-A2-Traeger) | REGRESSION | Z340-341 | OFFEN | - |
| E12 Thesis-Remote traegt wieder 1 Co-Authored-By-Commit 09cc728 auf ALLEN Refs beider Remotes (vermutlich via Owner-Overleaf-Linie zurueckgeflossen) + lokale Klone stale | REGRESSION | Z341-344 | OFFEN (Owner-gated, Rewrite=Remote-Loeschung), NICHT #15-blockierend | = Z-26/seg1-52-Verwandte |
| E13 W2-Gates nicht am Endstand (KON116-01, 15978-Rot) | REGRESSION | Z344 | BEHOBEN (GEHEILT), Rest in F9 | - |
| FEHLT/ABWEICHUNG-TAFEL P1-P14 spiegeln K1/K2/E4-E12 je seg-Anker | REGRESSION | Z346-347 | OFFEN (Sammelverweis) | - |
| P14 ENTLASTET (bestandslog-Posten korrekt Di-25-faellig, NP-19-Trennung vorhanden) | REGRESSION | Z347 | ENTLASTET | - |
| H1 Root-Duplikat ./system_axis_registry.xml (12285B, Generator-Default out_path=CWD) -> F7 | REGRESSION | Z349-350 | OFFEN | - |
| H2 Abdeckungs-Wache lief WEICH (COMDARE_WACHE_STRIKT ungesetzt) | REGRESSION | Z350-351 | OFFEN (fuer Lande-Gates STRIKT=1 setzen) | - |
| H3 unquittierter Flake test_seg_coverage (03:51 Failed -> 03:52 Passed ohne Commit) | REGRESSION | Z351-352 | OFFEN | Findings-Register + vor Kampagne klaeren |
| H4 K16-Kollisions-Heilung vorbildlich; KON119 mit bump15-a/b/c/d-Namensnennung (F9) | REGRESSION | Z352-353 | ENTLASTET (positiv), F9-Namensnennung OFFEN | - |
| H5 klassifikation.hpp:28 '==5'-Historienzitat (mit F8) | REGRESSION | Z353-354 | OFFEN | - |
| H6 Muster: ALLE Verstoesse Disziplin-, keine Mechanik-Fehler -> Pre-Push-Script (K3/E13) | AUFGABE | Z354-355 | OFFEN | Pre-Push-Script |
| H7 Audit-Anker 67dafa46=23 Commits, realer Tip e285d316=30 -- KON119 fuehrt literalen Endstand | REGRESSION | Z355-356 | OFFEN | KON119 |
| Detail-Tafel: 111 Einzelverdikte (22 FEHLT+89 ABWEICHUNG; Kopfzahl nennt 85 ABWEICHUNG dedupliziert) als Abschnitt 6b am Dateiende | UNKLAR | Z358-359 | VERWEIS (spaeter in Datei) | - |
| KONSEQUENZ Sec.6: Fix-Strecke2 = F1-F9 + Register-11-Zusaetze (T-2 Positions-Beweise, T-10 V-02R-Verkettung, beide NICHT im Audit) + Register-G-L21 (F-9/TSan-Triage); Reihenfolge F1(bauen)+F2/F3 vor Push; F4 haengt an C-3a-Antwort; F6 vor F2 terminieren | AUFGABE | Z361-364 | GEPLANT | - |
| POSITIV bestaetigt (Lens, Abschnitt 7): POD 20 Felder/152@align8 korrekt, designierte Initialisierer MESS/SYSTEM/ORGAN, 6 Makros signaturidentisch, Gate-Grammatik 9 Felder/512 Formen/AUS-Laenge 3+26+8=37, anatomy_name_hex consteval+Terminierung, Budget 32+768+256+256+128+512+1536+128+64+2368+9=6057 nachgerechnet (Reserve 2135/8192) | FEATURE | Z372-377 (Sec.7) | CI-BEWIESEN | Lens-Bestaetigung |
| POSITIV bestaetigt (Lens, Abschnitt 7): Erzeuger MESS/SYSTEM/ORGAN konsistent, Format5/10 Glieder/Komposit[9] gepinnt, K-1-Sperren wirksam, Loader-Returns entladen+destroy vor unload, 6 Exports extern"C", Alt-Major-Fixtures ODR-frei, Admission Groesse6+Hybrid-CT+Cross-Pin korrekt, 3 Verbund-Strategien altsemantik-treu, 4 work_modes nutzen Release, B4-Paare 4/6 direkt geprueft | FEATURE | Z377-382 | CI-BEWIESEN | Lens-Bestaetigung |
| KONSEQUENZ-Kette Sec.8 (18.08. nachmittags): (1) Review+Audit-Synthese abwarten->5b/6, (2) W1-Audit#93 drittes Glied->Abschnitt9, (3) A2.5-Fix-Stufe(Fable max) T-1 je Fund Rekursion bis 0, (4) Landung nach Kontext-13-Rezept(5e0b7f95)+F2-Owner-Vorlagen | AUFGABE | Z384-392 (Sec.8) | GEPLANT | - |
| Task #93 W1-Vollstaendigkeits-Audit KOMPLETT (wf_ca507b8f-Resume, 9/9 Agenten, 19.08. ~21:00) | AUFGABE | Z394-398 (Sec.9) | GELANDET (Resultat vorliegend) | wf_ca507b8f |
| 9.0 GESAMTURTEIL: NEIN auf Posten-/Formel-Ebene, JA auf Strang-Ebene; 4 Straenge+Nachzuege sind Ancestors; #17/g2 gelandet+gepusht (ba33b9ac); 'W1 abgeschlossen' als Vollzaehligkeits-Aussage war falsch | UNKLAR | Z400-402 | GEKLAERT (Widerspruch zu W1-V1 aufgeloest) | - |
| ZAEHLER 9.0: 91 Verdikte roh = 39 ERFUELLT/13 GEBAUT_UNGELANDET(=#15-Bruch)/16 OFFEN_VOR_F2/20 W2-DEKLARIERT/0 GESTRICHEN(einzige Kandidatin D-2-Band-B=Historie)/3 UNKLAR | UNKLAR | Z402-404 | GEZAEHLT | - |
| W1 wird komplett durch: #15-Landung -> Stempel-Nachlande-Zug -> F2-5-Kleinbauten -> ##10b/OV-4-Vorlage -> Freeze-Check-Buchungen | AUFGABE | Z405-407 | GEPLANT | - |
| 9.1(1) #15-LANDUNG einziger Erfuellungsweg fuer B3+13 GEBAUT_UNGELANDET; Voll-Abnahme@79171599 KOMPLETT 4x507/507 | AUFGABE | Z409-411 (9.1) | OFFEN (Voraussetzung erfuellt) | #15 |
| 9.1(2) g2-Schlussstueck 16031-Terminal INZWISCHEN VOLLZOGEN (TERMINAL SUCCESS 20:23Z, #17 completed) | AUFGABE | Z411-412 | BEHOBEN | #17 |
| 9.1(3) KON17-01-Freigabe #7/S-19 wirksam erst mit #15-Landung (S-19 Sa-Mo) | AUFGABE | Z412-413 | OFFEN (abhaengig #15) | #7/S-19 |
| 9.1(4) #102 golden-Zug Do 20.08. (LAEUFT als wf_77867329) | AUFGABE | Z413 | LAEUFT | #102, wf_77867329 |
| 9.1(5) Stempel-Nachlande-Zug F2-2+F2-3 (CEB-system_zeile KON8-03 + S-5-Erbinnen) | AUFGABE | Z413-414 | OFFEN | F2-2/F2-3 |
| 9.1(6) B5/B5-VORPOSTEN (F2-4, Fable max) | AUFGABE | Z414 | OFFEN | F2-4 |
| 9.1(7) LG-SkipCallback (WOERTLICHES F2-Abnahmekriterium) | FEATURE | Z415 | OFFEN | F2 |
| 9.1(8) LG-XlsxAlt (NIE-fallen-Klasse) | FEATURE | Z415 | OFFEN | - |
| 9.1(9) ##10b working_set-8388608-Messpunkt + beide --check-size-Reihen in OV-4-Vorlage | AUFGABE | Z416 | OFFEN | OV-4 |
| 9.1(10) D4f Break-Even-Statusraum-Typ ('jetzt, solange 0 Konsumenten'; OV-6=ja; KEINE W2-Deklaration existiert) | AUFGABE | Z417-418 | OFFEN (bauen oder deklarieren) | - |
| 9.1(11) ##16/##17 an OV-1 (deklarierter Fallback par.7:1002 greift sonst) | AUFGABE | Z418-419 | OFFEN | OV-1 |
| 9.1(12) ##19 LaTeX-/Ranking-Emitter (bei OV-1-Fallback bleibt 'beste je Last/beste 5' unadressiert) | FEATURE | Z419-420 | OFFEN (bauen oder deklarieren) | - |
| 9.1(13) A10/VL-3(c) _pclose: statischer Blick VOLLZOGEN (par.23.2 ENTLASTET 19.08., l.rc=status korrekt), Rest=Deklarations-Buchung kein Bau | REGRESSION | Z421-422 | BEHOBEN (statisch), Rest OFFEN (Deklaration) | - |
| 9.1(14) S-6d/#67 Vier-Familien-Benennung (29 Include-Wanderungen ungebaut) + N-1/N-2 (F2-8) | FEATURE | Z422-424 | OFFEN | F2-8 |
| 9.1(15) F2-6 Umbenennungs-Rest E-Label + Flag-f (platzieren oder deklarieren) | AUFGABE | Z424 | OFFEN | F2-6 |
| 9.1(16) FREEZE-CHECK-Buchungen (B1-18.6(4)-Zahl, #38a2-T-A, N1/N5-DEKLARIERT-Ausweis, F2-7-Teilstuecke) | AUFGABE | Z425-426 | OFFEN | Freeze-Check |
| 9.2 GEBAUT_UNGELANDET (13+1): S-6a, #38d, S-6b-Fortschreibung, S-6c/S-21(94095eda), S-6d-Anteil(V-11R+A-06/A-08), S-5-Bildungs-Haelfte, B3(f4e88786+4cb16334), HY-A2, HY-A3, ABI-Pflicht 6 Symbole(Emitter-Haelfte=#102), HY-ModulGrenze-Testlast, P.20.10-Abnahmeformel(3 Logs), A14/M-5-Messung, clang-debug-Heilung 4x507/507(ersetzt NICHT N1-Warnungs-Review) | FEATURE | Z428-432 (9.2) | GEBAUT (ungelandet, Traeger #15-Bruch) | - |
| 9.3 W2-DEKLARIERT (12 explizit benannt von 20): N1-Warnungs-Review, N5-Matrix(6fdad80c REVERTIERT ca26044e,Selbstkorrektur), A15/Wstringop(praezise W4/W5-RANDSLOT), S-2/G-1, B1(18.6(4)/#24), B4(haengt OF-1), MESS-dreiphasig=#53, D5-5-Rest(#105,Frist29.08.), ##11 measure_selection(#18), 6 F2-5-Randslot-Posten(PM-Naht Falsch-Null korrigiert), D-2-Band-B(nie GESTRICHEN buchen), #38a2(18.6(3)) | AUFGABE | Z434-441 (9.3) | W2-DEKLARIERT | diverse #-Traeger |
| 9.4 ##15-K6 = ERFUELLT NACHGEBUCHT: derive_default_experiment_phases() (grep auto_phase=0 Treffer!), Ledger-Marker :22951 UEBERHOLT, alle 5 K-Posten K1-K4+K6 GEBAUT | REGRESSION | Z443-455 (9.4) | BEHOBEN (ERFUELLT nachgebucht) | - |
| 9.4 LG-LoadWache = W2-RANDSLOT BESTAETIGT (test_e24_c10_g5 prueft NUR Set-Genus; Kontrast test_e24_c10_genus_dll_roundtrip faehrt 4 Genera) | REGRESSION | Z456-460 | OFFEN (bleibt 6+2-Deklaration) | - |
| 9.4 LG-Idempotenz = W2-RANDSLOT PRAEZISIERT AUF EINE ZELLE (5/6 Zellen objektweit gedeckt, fehlt NUR [beide x Wiederholungslauf]) | REGRESSION | Z461-467 | OFFEN (Di-25-Slot) | - |
| 9.5 OWNER-VORLAGE-KANDIDATEN (7, ins F2-Fenster P1-P7): OV-1 Break-Even-Kanon(+##19), OV-4-Deckel(##10b-Messung geliefert), HY-Ebene4a-Entscheid(war Mi19. terminiert), G-1 9/12 Fragen, P5 fingerprint_sha-Form, OF-1(B4 haengt daran,war Mi19. faellig), #38a2/P4-Paket-Entscheid(Tripwire) | AUFGABE | Z469-472 (9.5) | OFFEN (Owner-Vorlage), 2 Fristen bereits verpasst | P1-P7 F2-Fenster |
| 9.6 KONSEQUENZ-DELTA: NEU ohne Traeger (##10b,D4f,##19-Mitfall-Ausweis,S-6d-Benennungs-Entscheid) hiermit getragen; PM-Naht-Falsch-Null korrigiert; A10=Deklaration statt Bau; 3 UNKLAR-Messungen als Mini-Posten vor Freeze-Check | UNKLAR | Z474-478 (9.6) | GEKLAERT | - |
| A2.5-FIX-STRECKE 1 VOLLZOGEN (wf_a1b55606, 7/7 Agenten, 0 Fehler) | AUFGABE | Z480-484 (Sec.10) | GELANDET | wf_a1b55606 |
| BILANZ Fixstrecke1: 42 BEHOBEN, 0 ENTLASTET, 1 VERTAGT (C-F4->W2-Task); Worktree-Tip 67dafa46->19e7951a (6 Commits: g1-fingerprint 35ab0c46, g2-loader cc243c8c, g3-hybrid 9378e463, g4-tests 7ccf7002, g5-semantik cdec6079, abnahme-format 19e7951a) | REGRESSION | Z482-486 | BEHOBEN (42/43, deckt Abschnitt1/2/5 -- Einzel-Zuordnung je Zeile s.o. dort wo explizit belegt) | fixstrecke1-ergebnis-wiq9ihup1.json |
| ABNAHME GRUEN am End-Tip 19e7951a: gcc-release 503/503 | AUFGABE | Z495 | CI-BEWIESEN | - |
| clang-release 503/503 (Fix-21-Pflicht erfuellt, R1/ENABLE_EXPORTS-Zelle gemessen; fruehere 503-vs-502-Differenz war stale EXCLUDE_FROM_ALL-Binary, per Relink geheilt) | REGRESSION | Z496-498 | BEHOBEN/CI-BEWIESEN | - |
| gcc-debug 499/499 (Differenz 4 gemessen erklaert per comm ueber ctest -N) | AUFGABE | Z498 | CI-BEWIESEN | - |
| clang-debug NICHT gefahren (vorbestehender PIE/HDR-Rest, deklariert) | REGRESSION | Z499 | OFFEN (deklariert, nicht behoben) | - |
| Abdeckungs-Wache GUARD_EXIT=0 literal '503 von 503' | AUFGABE | Z499-500 | CI-BEWIESEN | - |
| Floor avx512f 503==Anker | AUFGABE | Z500 | CI-BEWIESEN | - |
| Exit 1 mit 4 versionslosen Traegern LITERAL PROTOKOLLIERT = deklarierter Lande-Schritt | AUFGABE | Z501 | GEPLANT (deklariert) | - |
| Diff-Hygiene GRUEN (5165 Zusatzzeilen, 0 Nicht-ASCII, 0 >120), clang-format-Nachzug 19e7951a, gitleaks clean, TABU-CRC unbewegt, golden-Diff 67dafa46..HEAD=0 Byte | AUFGABE | Z502-505 | CI-BEWIESEN | - |
| VERIFY RUNDE 1: 3 kleine Luecken -> REKURSION RUNDE 2 (wf_b943361e): (1) C-F3 in Synthese-Dedup verloren, (2) 4 Triage-Posten ohne dreiwertige Quittung (seg1-40/43/45,LS2-33), (3) Nachzug-Pflichten (C-F4-W2-Task, seg1-04-super-Haelfte) | REGRESSION | Z507-512 | OFFEN -> Runde 2 | wf_b943361e |
| Verify R1 bestaetigt: ALLE 21 KRITISCH/ERNST-Diffs tragen Anweisung, KEINE neue Code-Regression, Kopplung g3<->g4 konsistent | UNKLAR | Z511-512 | ENTLASTET | - |
| 10b RUNDE 2 VOLLZOGEN+VERIFY: NULL_NEUE_FUNDE, A2.5-REKURSION #15 FORMAL BEENDET (End-Tip e285d316 auf 19e7951a) | AUFGABE | Z514-515 | BEHOBEN/GELANDET | - |
| C-F3 BEHOBEN @ e285d316 (Variante a Kommentar-Ehrlichkeit, 15 ///-Zeilen; Mirror-Variante verworfen) | REGRESSION | Z517-518 | BEHOBEN | ersetzt "OFFEN" Status aus Sec.2 |
| seg1-40 VERTAGT -> Task #95 (V-08R seit KON101 BUENDEL-SOLL, Owner-Form SHA-256/64-Hex kollidiert GEMESSEN mit 128-Hex-S-1-Vertrag) | REGRESSION | Z519-521 | VERTAGT | Task #95 |
| seg1-43 ENTLASTET (deklariert-ungedeckt; V-13 per KON101 BEANTWORTET, offen nur BAU B-5f an 3 Stellen) | REGRESSION | Z521-523 | ENTLASTET | - |
| seg1-45 VERTAGT -> #83 | REGRESSION | Z523-524 | VERTAGT | #83 |
| LS2-33 VERTAGT -> #44-Rest (Bruch beruehrt Flaeche nicht) | REGRESSION | Z523-524 | VERTAGT | #44-Rest |
| seg1-44 ENTLASTET-bestaetigt (Spannung ausgewiesen, Aufloesung Audit-Synthese+Owner) | REGRESSION | Z525 | ENTLASTET-bestaetigt | - |
| Tasks #94 (C-F4-Kapselung W2) + #95 (V-08R) angelegt; super-Doku-Posten (6 stale E-6-Stellen) im KON119-super-Zug verankert | AUFGABE | Z526-527 | GEPLANT | #94, #95 |
| Verify R2 (unabhaengig nachgemessen): NULL_NEUE_FUNDE (C-F3-Fakten geprueft, golden-Diff 19e7951a..e285d316=0 Byte, TABU 0 Diff, clang-format rc=0, ctest m_w12 gruen beide Zellen) | AUFGABE | Z529-532 | ENTLASTET/BEHOBEN | - |
| Prozess-Notiz: Prompt-Interpolation der Quittungen scheiterte erneut am Template-Literal (bekannter Orchestrator-Bug), Verify rekonstruierte aus journal.jsonl | REGRESSION | Z532-534 | ENTLASTET (kein Fund am Gegenstand) | Orchestrator-Bug bekannt |
| Bruch fix-komplett bei e285d316, wartet auf Audit-Ruecklauf -> Fix-Strecke2 -> W1-Audit#93 -> Landung | UNKLAR | Z534-535 | OFFEN | - |
| Owner-Auftrag 19.08. (K14): K13-Session-Log Z68514-69705+K12-Endphase Z67336-68514 VOLLSTAENDIG nachvollziehen, Luecken hier dokumentieren | OWNER-ENTSCHEID | Z539-542 (Sec.11) | GEGEBEN | - |
| 11.0 VERLAUFS-REKONSTRUKTION: K13 (18.08. 09:13-21:24 UTC) diente 5 Zwecken (Owner-Audit 688, Dual-Review, #93 W1-Luecken, Fork, par.21-Konsolidierung); K13 verlor ~5,5h durch 2 Limit-Risse | UNKLAR | Z544-552 | GEKLAERT | - |
| [T-2] Fingerprint-Positions-Beweise :609-627 FORTGESCHRIEBEN statt am Objekt neu bewiesen (bump15-a Z67631 'Prioritaet (iv) OFFEN') | REGRESSION | Z555-559 | OFFEN | Fix-Strecke2: Positions-Beweise am End-Tip e285d316 frisch messen |
| [T-10] V-02R SHA256-Verkettung Hybrid-Pruefdock-Tier-Binaries VERBLEIB UNGEKLAERT (bump15-a Z67560 'KONFLIKT, NICHT GEBAUT', unter EXPLORE-PFLICHT) | REGRESSION | Z560-565 | OFFEN | Fix-Strecke2 + #93-Gruppe C(HY) |
| [T-3] Bewusste Namens-Abweichung ohne Meldung: algorithm_baustein.hpp full_join->axis_cross_product statt verbund_union | REGRESSION | Z568-571 | ENTLASTET (fachlich sauber, nie gemeldet) | Meldungs-Tafel-Punkt |
| [T-5] clang-22-Falle -fassume-unique-vtables: dynamic_cast auf FINAL-Klasse -> vtable-Zeigervergleich, nullptr NUR clang -O2/-O3 | REGRESSION | Z574-580 | BEHOBEN (ENABLE_EXPORTS ON am Test-Target; -fno-assume-unique-vtables erwogen+VERWORFEN) | Fallen-Register T-11c |
| [T-6] Koeder-Reichweiten-Lehre: Koeder B (merge='Stufe2_PrueflingReplace') biss NICHT, weil AUSSERHALB der Pruefmenge lag | REGRESSION | Z581-586 | BEHOBEN (b54311f0: Namens-Naht + Sammel-Test Nenner>=8) | Fallen-Register |
| [T-9] "Q2/Q3 GESTOPPT (K16)" IST AUFGELOEST: bump15-d baute P8 komplett als R2+R0(110->0 Warnungen)+R1(T-5-Fix) | REGRESSION | Z589-593 | BEHOBEN (KEIN offener Faden) | - |
| [T-1] j3/work_mode-Eingang KEINE stille Streichung (Director-Test testet j3-Mechanik state-direkt, S-8-Grenze dokumentiert) | REGRESSION | Z594-598 | ENTLASTET, Rest: Task-#22-Text um j3-Direktor-Test-Haelfte ergaenzt | #22/OD-7 S-8 |
| [T-4] Verbund2_Hybrid BEREITS GEDECKT als D-F4b+Fix15/16 (bump15-c-Abweichung 2 vom Review unabhaengig gefunden+behoben) | REGRESSION | Z599-600 | ENTLASTET | - |
| [T-8] bump15-b-Probe-TUs GESICHERT (name_probe/komposit_probe/maxlen_probe/kp_koeder.cpp aus Job-tmp nach backups-workflow kopiert) | AUFGABE | Z601-603 | BEHOBEN | 20260819-bump15b-probe-tus/ |
| 11.5 KONSEQUENZ-DELTA: Fix-Strecke2 +2 Posten (T-2,T-10) vor Triage-Liste, Meldungs-Tafel +1 (T-3), Fallen-Register +2 Klassen (T-5,T-6); Kette selbst NICHT geaendert | AUFGABE | Z605-608 | GEPLANT | - |
| 6b DETAIL-TAFEL: 114 Verdikt-Objekte -> 111 eindeutige IDs (22 FEHLT: 0 KRIT/18 ERNST/4 HINWEIS; 89 ABWEICHUNG: 4 KRIT/62 ERNST/23 HINWEIS); Synthese-Zaehlung 22/85 dedupte 4 Doppel-IDs schaerfer; Beleg-Zellen bei ~230 Zeichen geschnitten, Volltext in BU-Journal-Kopie | UNKLAR | Z610-620 (Sec.6b) | ABGESCHLOSSEN (Rohliste) | audit-wf794b904b-journal-ENDSTAND.jsonl |
| F-D6 [ERNST] Owner-GO seit 17.08 (KON104-01/02) 'D-6 als ueberholt MARKIEREN' -- Objekt ohne Marker | REGRESSION | Z624 (6b FEHLT) | FEHLT | - |
| F-D7 [ERNST] Owner KON104-01/02-D-7 'Weg1 ehrliche Luecken-Zeile JETZT' -- le_limitierung.tex DE+EN ohne Anhang-A-Luecken-Zeile | REGRESSION | Z625 | FEHLT | - |
| F-E2 [ERNST] bausteine_bewertung/baustein_bewertung = 0 Pflichtformat-Artefakte (Existenz-Suche negativ, beide Schreibweisen) | REGRESSION | Z626 | FEHLT | - |
| LS2-66 [ERNST] harness/perm_runner.hpp nur Zwei-Phasen-Cache-Warmup, keine Paar-Persistenz/Retry-5x/--debug-Zweig | REGRESSION | Z627 | FEHLT | - |
| LS2-78 [HINWEIS] B4-Umbau NICHT vollzogen, static_assert(...==6 Steuerdocks) NICHT entfernt | REGRESSION | Z628 | FEHLT | steuer_dock.hpp:234-235 |
| LSEG8-14 [ERNST] checkpoint_measure hat KEINE Definition im Code (ce+wt), nur Kommentar+SOLL | REGRESSION | Z629 | FEHLT | - |
| LSEG8-17 [ERNST] Konsolidierung nicht vollzogen: axis_spline.hpp monotone kubische Hermite statt B-Spline | REGRESSION | Z630 | FEHLT | letzter Commit 26487fb1 vor 08.08-Entscheid |
| PAU-03 [ERNST] Kein dokumentierter Terminal-Status ('15787' grep trifft nur Pause-Doku selbst) | REGRESSION | Z631 | FEHLT | - |
| SEG5-16 [ERNST] measure_to_latex = 0 Treffer ueber ce/wt/super; csv_to_latex hat Konsumenten | REGRESSION | Z632 | FEHLT | - |
| Z-21 [HINWEIS] Live-API remote_mirrors=0/0 (Projekte 288/286), 3 github.com-Zeilen noch im Store | REGRESSION | Z633 | FEHLT | - |
| seg1-04 [ERNST] 0/3 Nachzuege im 23-Commit-Bruch: hybrid_config_xml.hpp E-6-Verweis unveraendert | REGRESSION | Z634 | FEHLT | (= seg1-04 Sec.3, Status-Fortschreibung) |
| seg1-40 [ERNST] planner_version.hpp:78-84 UNVERAENDERT, fingerprint_sha() leer | REGRESSION | Z635 | FEHLT | (= seg1-40 Sec.3, spaeter VERTAGT->#95 s.10b) |
| seg1-43 [ERNST] KEINE der 3 Stellen validiert Ordnung wallclock/macro/micro | REGRESSION | Z636 | FEHLT | (= seg1-43 Sec.3, spaeter ENTLASTET s.10b) |
| seg1-45 [ERNST] measurement_snapshot.hpp NICHT im Bruch, POD nur pmc_available | REGRESSION | Z637 | FEHLT | (= seg1-45 Sec.3, spaeter VERTAGT->#83) |
| seg1-48 [ERNST] git log 0 Treffer '38a2\|C-3a\|Comp-Gate\|aggregate_required', simd_build_gate.hpp NICHT im Diff | REGRESSION | Z638 | FEHLT | C-3a-Tripwire |
| seg1-67 [ERNST] bump15-Diff beruehrt 0 PMC-Dateien, linux_perf_pmc_smoke.cpp weiter SMOKE_SKIP | REGRESSION | Z639 | FEHLT | - |
| seg3-kon13-04 [ERNST] Drei-Ziele-Struktur NICHT vorhanden: experiment_schema.xsd nur binary_path/csv_path/latex_path+1 storage-Slot | REGRESSION | Z640 | FEHLT | - |
| seg3-kon16-09 [ERNST] Umbenennung Klasse A NICHT vollzogen: batch_planner.hpp type_phase_rank unveraendert | REGRESSION | Z641 | FEHLT | - |
| seg3-kon25-08 [HINWEIS] Emissionsliste ohne Lint-/Release-/Lager-Ablage-Jobs, kein J-1..J-4 | REGRESSION | Z642 | FEHLT | - |
| seg3-kon27-02 [HINWEIS] experiment_schema.xsd KEIN export-Element (dev+wt identisch) | REGRESSION | Z643 | FEHLT | - |
| seg3-kon34-03 [ERNST] steuer_dock.hpp:234 static_assert(...==6) UNVERAENDERT in ce dev UND wt-ce-bump15 | REGRESSION | Z644 | FEHLT | - |
| seg4-12 [ERNST] Code war nie mutiert (bvset_teilmenge.hpp korrekt seit 363f0022), ABER Test-Blindheit besteht | REGRESSION | Z645 | FEHLT | test_bvset_teilmenge.cpp:73 |
| D2-05 [HINWEIS] Lock: 6 heuristik-Header exakt in axis_version.lock, CI-Job hart gated | REGRESSION | Z649 (6b ABWEICHUNG) | ABWEICHUNG | - |
| F-D1 [ERNST] Owner KON104-01/02-D-1 Wohlgeformtheit/Uebergangs-Deklaration -- Objekt-Abweichung (Beleg gekappt) | REGRESSION | Z650 | ABWEICHUNG | - |
| F-D8 [HINWEIS] Praemisse stimmt: axis_optimization_catalog.hpp honest-empty fuer persistence_target (Owner-Entscheid, keine T19-Zeile) | REGRESSION | Z651 | ABWEICHUNG | - |
| F-K2 [ERNST] Lizenz-Unstimmigkeit: NOTICE 'MIT' vs LICENSE_AUDIT_EXT.md 'KEINE LICENSE' (A03-michael-lockfree), identisch in beiden Baeumen | REGRESSION | Z652 | ABWEICHUNG | - |
| F-M1 [ERNST] 20 Fragen stimmen (A-1,A-2,B-1,C-1..3,D-1..10,E-1..4), Aussonderung/Zusammenlegung dokumentiert, BU-Ordner vollstaendig | REGRESSION | Z653 | ABWEICHUNG | - |
| INF-03 [ERNST] allow_runner_registration_token=True (SOLL laut Owner-Entscheid D-3 17.08. 'Wie empfohlen') | REGRESSION | Z654 | ABWEICHUNG | - |
| INF-05 [ERNST] Rotationsliste ohne Nachtrag 'samba-comdare-socks-pw' nach Owner-Entscheid 17.08. | REGRESSION | Z655 | ABWEICHUNG | - |
| K-07 [ERNST] Buendel-Zug LAEUFT: wt-ce-bump15 heute 30 Commits 20c111c4..e285d316 (67dafa46=Ancestor, 23er-Kernstand+7 a25-Fixrunden) | REGRESSION | Z656 | ABWEICHUNG | - |
| LS2-07 [ERNST] Freigabe belegt Ledger B7a/B7b (CEB-LAGER-REGISTRY-HASH-MAP), Bau: S-17/HY-A/B5 | REGRESSION | Z657 | ABWEICHUNG | - |
| LS2-21 [ERNST] Widerlegung bestaetigt: A03-michael-lockfree 4/4 Dateien LGPL-2.1-or-later | REGRESSION | Z658 | ABWEICHUNG | - |
| LS2-33 [ERNST] Kette verdrahtet, ABER Durchzug NICHT erfolgt (simd_organ_requirement.hpp nur 9x kRequiredNone) | REGRESSION | Z659 | ABWEICHUNG | (= LS2-33 Sec.3, spaeter VERTAGT->#44-Rest) |
| LS2-34 [KRITISCH] S-6a-Kern GEBAUT, ABER Riegel-Echtfall-Protokoll ROT->Bump/Regen->GRUEN FEHLT (Lock-Traeger target_isa_c...) | REGRESSION | Z660 | ABWEICHUNG | (= LS2-34 Sec.3) |
| LS2-41 [HINWEIS] pre-secret-scrub-20260802 nirgends, super lokal exakt 3x heads/backup | REGRESSION | Z661 | ABWEICHUNG | - |
| LS2-51 [ERNST] 2 von 4 Pflicht-Posten gebaut (c: mess_ausbeute_wache.sh n/a-Erkennung Felder 4/5/6) | REGRESSION | Z662 | ABWEICHUNG | - |
| LS2-52 [ERNST] Zeiger OK: ARBEITSWEISE-GESAMT-DOKTRIN.md umgezogen, ##58 GEKLAERT | REGRESSION | Z663 | ABWEICHUNG | - |
| LS2-55 [ERNST] Handout liegt: prod1 HEAVY_J 24->16, prod2 unberuehrt, SIGHUP-only | REGRESSION | Z664 | ABWEICHUNG | - |
| LS2-60 [HINWEIS] Doktrin-Praxis belegt: 4 CI-Zellen g++15.3.0/clang22.1.8 | REGRESSION | Z665 | ABWEICHUNG | - |
| LS2-67 [HINWEIS] wt: GliedCount=10, fingerprint_format=5, PreimageMax=8192 gerechnet nicht geraten | REGRESSION | Z666 | ABWEICHUNG | - |
| LS2-68 [ERNST] Mechanismus GEBAUT: OrganMetaMetaAxis CRTP+Concept, Registrierungszeile | REGRESSION | Z667 | ABWEICHUNG | - |
| LS2-88 [HINWEIS] GOAL:10-13 KOPF-NACHTRAG vorhanden, Wellenplan §16/§17, Designplan §10 D-1..D-6 | REGRESSION | Z668 | ABWEICHUNG | - |
| LSEG8-13 [ERNST] Kern gebaut: ergebnis_mappe FASSUNG3 (Owner 08.08.), compare=1 Sheet/Rekombination, MessEbene enum | REGRESSION | Z669 | ABWEICHUNG | - |
| LSEG8-15 [ERNST] Flag GEBAUT: --check-size, planner_mengen_types.hpp Substanz aus builder/measure_storage | REGRESSION | Z670 | ABWEICHUNG | - |
| LSEG8-25 [ERNST] scheduling_strategy.hpp weiter 0 Konsumenten unveraendert (auch bump15-WT) | REGRESSION | Z671 | ABWEICHUNG | - |
| P-08 [HINWEIS] merge-base xorf/f3v/a11 IN dev 20c111c4; g2 9aa9b9df/1528f6fd EXISTS-NOT-IN-development | REGRESSION | Z672 | ABWEICHUNG | (= Z-11/#17-g2-Verwandte) |
| P-10 [HINWEIS] Inventar bestaetigt 21 Ordner (von 18 gewachsen)/53M unter 20260817-folge-bu-kontext11 | REGRESSION | Z673 | ABWEICHUNG | - |
| P-12 [ERNST] worktree list: hy-a/vl12/vl3/k2 stehen ALLE (Owner-Auflage Loeschung-erst-nach-Beleg eingehalten) | REGRESSION | Z674 | ABWEICHUNG | - |
| PAU-10 [ERNST] Dokumentiertes GO erst 15.08. (Ledger KON73 'Schluss-GO Owner: volles GO und volle Fahrt voraus') | REGRESSION | Z675 | ABWEICHUNG | - |
| PAU-13 [ERNST] Koeder-Praxis erfuellt (glpat-26, Ledger 'Koeder biss', rc=1 laenge-26) | REGRESSION | Z676 | ABWEICHUNG | - |
| SEG5-01 [ERNST] Instrument GEBAUT: checkpoint_measure.hpp init(MessMasse)+flush_mess/flush_stapel je Arena getrennt | REGRESSION | Z677 | ABWEICHUNG | - |
| SEG5-02 [ERNST] Visitor GEBAUT: mess_visitor_abi.hpp IMessVisitor+tier_measure_accept (FLAECHE3, KON25-02) | REGRESSION | Z678 | ABWEICHUNG | - |
| SEG5-03 [ERNST] SteuerDock<MK> variadisch, Tag+Zensus, requires BefehlErlaubt; ABER :39-41 zusichert NICHT vollstaendigen Steuerkanal | REGRESSION | Z679 | ABWEICHUNG | - |
| SEG5-06 [HINWEIS] ISA-Trennung im Glied vorhanden: toolchain_stamp_glied.hpp simd-Feld '(+ext=)' | REGRESSION | Z680 | ABWEICHUNG | - |
| SEG5-09 [HINWEIS] Deckel ERFUELLT: hybrid_config_xml.hpp W12-Pflichtangabe max_docks, 0/>32 ungueltig, Deckel 32 inklusiv KON28-03 | REGRESSION | Z681 | ABWEICHUNG | - |
| SEG5-10 [HINWEIS] Kern GEBAUT: hybrid/ 10 Dateien+README, Owner-Auflage woertlich im Test | REGRESSION | Z682 | ABWEICHUNG | - |
| SEG5-12 [ERNST] Loader weiterhin NUR unter Builder-Stufe (ce+wt identisch), CEB-Pruefdock nutzt ihn, hybrid/ bewusst lose | REGRESSION | Z683 | ABWEICHUNG | - |
| SEG5-13 [HINWEIS] Konform gebaut: hybrid_dock_factory Abstract Factory 'einziger Konstruktions-Ort', hybrid_dock_contract 'Kein Loader/dlopen/Proxy/XML-Parser' | REGRESSION | Z684 | ABWEICHUNG | - |
| SEG5-15 [ERNST] Geliefert: golden-Profil writeback_methods csv+xlsx (W0b ##25, beide zugleich), Produktionsaufrufer gelandet | REGRESSION | Z685 | ABWEICHUNG | - |
| SEG5-18 [HINWEIS] Durchstich BEWIESEN: KON56 'F1-LANDUNG IST DURCH', KON57-01 '##25-BEWEIS KOMPLETT TERMINAL', Tasks#11+#30 completed | REGRESSION | Z686 | ABWEICHUNG | - |
| SEG5-24 [ERNST] Bestandslog mess_bestand_key_of/doc_key/maschine ERFUELLT | REGRESSION | Z687 | ABWEICHUNG | - |
| SEG5-30 [ERNST] Haelfte1 erfuellt: run_with_drift_gate produktive Aufrufer (Mess-Schleife run_cell_with_drift_gate) | REGRESSION | Z688 | ABWEICHUNG | - |
| SEG5-32 [ERNST] Paper-EXPERIMENT-XML je Referenz-Paper=0 am Objekt, nur 33 sota/*.profile.xml + 12 thesis_profiles | REGRESSION | Z689 | ABWEICHUNG | - |
| SEG5-36 [ERNST] Zugesagte Korrektur NICHT vollzogen: AF_CORPUS_ROOT weiter 'measurement', Script erklaert es selbst als OFFEN | REGRESSION | Z690 | ABWEICHUNG | - |
| SEG5-37 [ERNST] Teil1 erfuellt (T-1, 09.08.): SystemAchsenEntscheidung faellt einmal, reist mit (Zwilling von compile_for_perm) | REGRESSION | Z691 | ABWEICHUNG | - |
| SEG5-47 [ERNST] measurement_axis_registry.xml (WT wie CE) nur load_framework als measurement_meta_meta, grep hybrid=0 | REGRESSION | Z692 | ABWEICHUNG | - |
| V15-04 [ERNST] 0 golden-Re-Anker-Commits am wt-HEAD e285d316, kNewGolden131072Crc64 byte-identisch zur Basis 20c111c4 | REGRESSION | Z693 | ABWEICHUNG | - |
| V15-07 [ERNST] set_/sequence_/view_/adapter_module_abi_v1.hpp je 0 VERSION_STAMP-Treffer am wt-HEAD | REGRESSION | Z694 | ABWEICHUNG | - |
| V15-08 [ERNST] planner_version.hpp:80-84 unveraendert, fingerprint_sha() leer; Owner-Entscheid seit 17.08 (KON101-01) | REGRESSION | Z695 | ABWEICHUNG | (= seg1-40-Verwandte) |
| V15-10 [ERNST] all_axes_golden.profile.xml <simd> nur no_extension+avx2, avx512 FEHLT, stale Filter-Prosa unveraendert | REGRESSION | Z696 | ABWEICHUNG | K1-Stelle 1, identisch in ce dev |
| V15-15 [ERNST] K2 VOLLZOGEN (ce-Naht-Fixture entflochten, in development gemergt KON109-02); K5+K6 VERBUCHT | REGRESSION | Z697 | ABWEICHUNG | - |
| Z-03 [ERNST] Kern des Buendels DA: f3559e7a Preimage Format4->5, 5c0c3a5e POD Layout6->7, komposit_line | REGRESSION | Z698 | ABWEICHUNG | - |
| Z-04 [ERNST] simd_build_gate.hpp static_assert(...organ_required_union_size()==0, C-3a-TRIPWIRE) NOCH VORHANDEN, NICHT ausgeloest | REGRESSION | Z699 | ABWEICHUNG | (= seg1-48-Verwandte) |
| Z-11 [KRITISCH] #17 GEBAUT aber UNGELANDET: 1528f6fd nur auf Branch bau/g2-semantik, NICHT Ancestor von development | REGRESSION | Z700 | ABWEICHUNG | (= W1-V1, spaeter BEHOBEN/GELANDET 9.0) |
| Z-26 [ERNST] Co-Authored-By-Pruefanker=1 (SOLL 0) ueber HEAD c169fd22: Commit 09cc728 (18.06.) traegt Claude-Opus-Trailer | REGRESSION | Z701 | ABWEICHUNG | (= E12-Verwandte) |
| Z-31 [ERNST] Erfuellt: node5 tot bestaetigt, Sidekiq-HPA behalten (Pipeline 15846), id56 online | REGRESSION | Z702 | ABWEICHUNG | - |
| Z-38 [ERNST] BU-Teil erfuellt: 20260816-folge-bu-kontext8 mit 3 journal.jsonl + staffelungs_karte_49.json + kon64_sammlung.md | REGRESSION | Z703 | ABWEICHUNG | - |
| seg1-26 [ERNST] Wellenplan 20.2/20.9: clang-Warnungs-Review, --debug x plan Exit-6-Zweige, Windows-_pclose statischer Blick, N6-Bytevergleich dokumentiert | REGRESSION | Z704 | ABWEICHUNG | - |
| seg1-37 [KRITISCH] topics/axis.hpp im Bruch UNBERUEHRT, keine CT-Zuordnung | REGRESSION | Z705 | ABWEICHUNG | (= seg1-37 Sec.3 / K1=F1, Status-Fortschreibung) |
| seg1-44 [ERNST] Nur S-6a-Makro-Teil im Bruch (d866bb3d '4 Anker'), K1-avx512 0 Filter-Edits | REGRESSION | Z706 | ABWEICHUNG | (= seg1-44 Sec.3) |
| seg1-46 [HINWEIS] bestandslog_document.hpp kSyntaxVersion=4 (kein 5), Gate unveraendert, last_update_utc=0 Treffer | REGRESSION | Z707 | ABWEICHUNG | - |
| seg1-49 [ERNST] (a) NP-39 bestaetigt gestrichen (deckungsgleich), (b) +tel=silent NICHT verdrahtet | REGRESSION | Z708 | ABWEICHUNG | - |
| seg1-52 [ERNST] Co-Authored-By ueber ALLE Remote-Refs beider Remotes inkl. origin | REGRESSION | Z709 | ABWEICHUNG | (= E12/Z-26-Verwandte) |
| seg1-66 [ERNST] Erfuellt: f45e995b IS Ancestor, TSAN-Grenze-Block exakt+Terminierungs-Praezisierung | REGRESSION | Z710 | ABWEICHUNG | - |
| seg1-71 [ERNST] W18-Austragung NICHT vollzogen: Ledger:22953/22739 §59-MERGE-STEMPEL K7a weiter '(OFFEN, kritisch)' | REGRESSION | Z711 | ABWEICHUNG | - |
| seg1-81 [KRITISCH] Rahmen ERFUELLT: BUENDEL-BAUPLAN-15.md 23 Schritte VL-1..6+B-1..11+N-1..6, Byte-/Hex-/CRC-Anker-Regel | REGRESSION | Z712 | ABWEICHUNG | - |
| seg1-84 [ERNST] Regel bauleitend im Ledger (3 Bedingungen SHA512+Kern-Identitaets-Klasse+Meta-Meta), ABER NICHT eingezogen | REGRESSION | Z713 | ABWEICHUNG | - |
| seg3-kon19-06 [HINWEIS] Die 3 (success-Wiederholung) GEBAUT je Wiederholung eigene Zeile; die 5 = drift_gate_max_reruns | REGRESSION | Z714 | ABWEICHUNG | - |
| seg3-kon21-03 [ERNST] Im Worktree: S-6a VOLL (f3559e7a/5c0c3a5e/d866bb3d, Preimage+POD+Konsumenten) | REGRESSION | Z715 | ABWEICHUNG | - |
| seg3-kon22-01b [HINWEIS] (a) MinIO-Neueinsetzung VOLLZOGEN 14.08. (Cluster-Commit b20492a) | REGRESSION | Z716 | ABWEICHUNG | - |
| seg3-kon22-01c [HINWEIS] 'build:gcc'=0 Treffer (gcc-Bau lebt in test:unit*), ce build:clang UNBEDINGT (08.08. 'UNBEDINGT GESCHALTET') | REGRESSION | Z717 | ABWEICHUNG | - |
| seg3-kon27-03 [ERNST] Erfuellt in 20260811-workflow-rohdaten-stempel-ci-konsistenz/ (kon-quellen/+owner-extrakte/+20+ Dateien) | REGRESSION | Z718 | ABWEICHUNG | - |
| seg3-kon28-01 [ERNST] ERFUELLT-Teile: runner-mode.sh prod1 HEAVY_J=16 (Commit 20ebba5), N-3/N-4 auf 16W neu gerechnet | REGRESSION | Z719 | ABWEICHUNG | (= seg3-kon28-01 Sec.3, Ledger-Marker fehlt weiterhin) |
| seg3-kon30-04 [HINWEIS] Marker gesetzt WF3-Synthese+Gesamturteil, ABER Ledger selbst 0 Treffer 'UEBERHOLT 12.08 KON30-04' | REGRESSION | Z720 | ABWEICHUNG | - |
| seg3-kon32-02 [ERNST] keeper-root-rotation-Eintrag vorhanden Vault Z.683; blinde mapfile-Probe: alle 10+2 Kandidaten HTTP-geprueft | REGRESSION | Z721 | ABWEICHUNG | - |
| seg3-kon34-04 [HINWEIS] B2 seit 15.08 GEBAUT+GELANDET: mess_gates_glied.hpp 'ERLEDIGT DURCH B2', Gate-Grammatik 4 Gates->16 Belegungen | REGRESSION | Z722 | ABWEICHUNG | - |
| seg3-kon8-03 [ERNST] Doktrin-Haelfte am Objekt: ceb_version_stamp.hpp W10-C3-Kommentar-Wache, CEB-Selbst-Stempel zellwertfrei | REGRESSION | Z723 | ABWEICHUNG | - |
| seg3-kon8-11 [HINWEIS] 3 von 4 SHA-Zuordnungen stimmen; 9f8e2be8 ist aber style(e18-snap) statt erwarteter Zuordnung | REGRESSION | Z724 | ABWEICHUNG | (= SHA-Zuordnungs-Hinweis Sec.3) |
| seg4-15 [ERNST] ci/tests/*.sh=14 (SOLL-Stand 11.08.=13), 8656 Zeilen total (war 7967), Wachstum 5->12->13->14 | REGRESSION | Z725 | ABWEICHUNG | (= seg4-15 Sec.3) |
| seg4-30 [ERNST] GEBAUT: P1 Sidecar-Klartext Zeile2=Glied[6] (#59 v2), ABER additiv statt Format-Bump; Invalidierung kam via bump15-Preimage | REGRESSION | Z726 | ABWEICHUNG | - |
| seg4-33 [ERNST] Bestand unveraendert gemessen: file(GLOB)=34 Zeilen/22 Dateien, konsistent zu KON6-07 '32' | REGRESSION | Z727 | ABWEICHUNG | - |
| seg4-58 [ERNST] Frischer super-Vollbau (super@5ca82678,ce@20c111c4): 866 Tests, FAILED-Liste=40=37 NotRun+3 Failed | REGRESSION | Z728 | ABWEICHUNG | test_limits_entkopplung_vorstufe u.a. |
| seg4-59 [ERNST] Thesis-Repo Historie neu geschrieben (branch --contains 19e15920=LEER, Befund 98/366 ueberholt), 376 Commits origin/development, Co-Authored-By-Trailer=1 | REGRESSION | Z729 | ABWEICHUNG | - |
| seg4-62 [HINWEIS] 4 von 5 Teilposten vollzogen (Wache in ce, nicht super): PA-1 GEBAUT ci_test_registrierungs_wache.sh ERREICHBARKEITS-PROBE | REGRESSION | Z730 | ABWEICHUNG | - |
| seg4-70 [HINWEIS] Kern bestaetigt: COMDARE_CE_ENABLE_ORIGINAL_CODE_VALIDATION Default-ON (Anker 550->589), wh.c in Validation-Pfaden | REGRESSION | Z731 | ABWEICHUNG | - |
| seg4-74 [ERNST] Genannter Anker geheilt (KON37-01, Paragraphen-Marke), ABER neue Kommentare verletzen Regel in ce+wt hybrid/heuristik_adapt... | REGRESSION | Z732 | ABWEICHUNG | - |
| seg6-08 [ERNST] Alle 9 TU-Dateien existieren in wt (test_tp1_planer_filter_iterator u.a.) | REGRESSION | Z733 | ABWEICHUNG | - |
| seg6-39 [ERNST] hybrid/ = 11 Dateien (kein README-Stub mehr); wt zusaetzlich hybrid_binary_proxy.hpp+hybrid_module_abi_v1.hpp | REGRESSION | Z734 | ABWEICHUNG | - |
| seg7-17 [HINWEIS] 4 Werte+Registry: run_methodology_registry.hpp enum{Debug,Measure,Release,Compare}, Zusagen-Anker gedriftet | REGRESSION | Z735 | ABWEICHUNG | - |
| seg7-45 [ERNST] axis_centric_namespaces.hpp unveraendert 'ALLE 17 Achsen' (Kopf beansprucht), kanonisch 18 Organ-Achsen (Phantom-Nenner) | REGRESSION | Z736 | ABWEICHUNG | Referenz: reference_organ_achsen_sind_achtzehn_nicht_neunzehn |
| seg7-50 [HINWEIS] DOCKER_OS-Matrix=18 unique=6 Familien x3 (ubuntu/debian/fedora/alpine/opensuse/rocky je 3 Versionen) | REGRESSION | Z737 | ABWEICHUNG | - |
| Owner-Auftrag Sec.12: 10 Transkript-Fenster K5-K13 (16.08.12:28-18.08.21:24, Z59214-69705) + 3 Journal-Gruppen VOLL nachvollziehen; Audit-Verdikte NICHT erneut melden | OWNER-ENTSCHEID | Z739-747 (Sec.12) | GEGEBEN | K14-Synthese |
| 12.0 Leser 10/10 Fenster K5-K13, Summe 10501 gescannte Zeilen, Bereich LUECKENLOS | UNKLAR | Z751-754 | VOLLZAEHLIGKEITS-GATE BESTANDEN | - |
| Journal-Gruppen 3/3: 38 Workflow-Journale 16.-19.08 kartiert (35 FERTIG, 3 live, 0 abgebrochen-ungeerntet, 0 journallos); Backups-Sweep 22+2 Ordner; Ernte-/Output-Gegenproben | AUFGABE | Z755-758 | GEKLAERT | - |
| GEGENZAEHLUNG REGRESSIONEN: 103 Roh-Eintraege -> 80 NEUE nach Dedup (11 im_register, 1 zu 12.1 umklassiert, 11 in 8 Merge-Gruppen M1-M8); kein Roh-Eintrag verworfen | UNKLAR | Z759-765 | GEZAEHLT | - |
| GEGENZAEHLUNG STRAENGE: 40 Roh-Kandidaten -> 33 nach Dedup = 16 GEERNTET/17 REKONSTRUIERBAR/0 VERLOREN (Tafel 12.3); Register-5c-Bilanz bestaetigt | UNKLAR | Z766-768 | BESTAETIGT | Tafel 12.3 |
| 12.1 [T-10 GESCHLOSSEN zur Ernte-Haelfte]: V-02R-Explore-Ernte EXISTIERT (wf_969b3bba 17.08., Ledger KON103-03), NEU-FAHREN ENTFAELLT; Rest: (a) BAU-Haelfte SHA256-Verkettung nicht gebaut, (b) Hash-Laengen-Spannung SHA-256(Owner) vs SHA-512/128(Objekt) | REGRESSION | Z772-782 | TEIL-BEHOBEN (Ernte gefunden), Rest OFFEN | Fix-Strecke2+#93-C; = Fortschreibung von T-10 oben |
| 12.1 [5c-KORREKTUR] w78hb9hii war KEIN verwaister 0-Byte-Doppelstart, sondern AUDIT-Run (Tool-Error Z68280 belegt) | REGRESSION | Z783-785 | KORRIGIERT (kosmetisch) | = Fortschreibung 5c-RESUME-BILANZ |
| 12.1 [6b-TRUNKIERUNG, ERNST] alle 111 Verdikt-Zeilen mechanisch bei ~250 Zeichen abgeschnitten, UNDEKLARIERT; bei seg1-81 fehlt Schritt-zu-Commit-Deckungs-Matrix | REGRESSION | Z786-792 | OFFEN | Sicherung+Reparatur X-16/X-17 |
| 12.1 [W1-V2-ANKER-DISKREPANZ] B3-Pflicht-Wurf sitzt in mess_achsen_naht.hpp:477-517 (:509 throw), NICHT abi_adapter.hpp:476-491 wie 3b/[W1-V2] maass | REGRESSION | Z793-796 | OFFEN (vor #93-Gruppe-D beide Anker abgleichen) | = Korrektur zu W1-V2 oben |
| 12.1 [5c-FORTSCHREIBUNG] journal-Sweep 19.08.: 0 abgebrochene+ungeerntete Runs, kein wf-Verzeichnis ohne journal.jsonl, 3 LIVE-Laeufe bestaetigt per Log-Wachstum | AUFGABE | Z797-799 | BESTAETIGT | - |
| 12.2a [K7b-3] prt-art build:registry-roundtrip NICHT-DETERMINISTISCH (Runner-Slot-Checkout ungepinnt, Schein-Gruen/Schein-Rot) | REGRESSION | Z805-808 (12.2a) | OFFEN | W2-Task (SHA-Pin) |
| 12.2a [K7a-3] = W1-V2-Anker-Diskrepanz (s. 12.1), OFFEN bis #93-D-Abgleich | REGRESSION | Z809 | OFFEN | #93 Gruppe D |
| 12.2a [K10-4] vl3-Restposten ohne Bau: ROT-3 '--debug x plan dump\|ci\|cmake' (Exit6) + Windows-_pclose-Posten ohne WEXITSTATUS | REGRESSION | Z810-812 | OFFEN | #93 Gruppe A |
| 12.2a [K10-12] vl3-Verlustliste F2-Rest: -Wstringop-overflow-VORBESTAND (A-13) ohne Verbleibs-Quittung | REGRESSION | Z813-815 | OFFEN | #93 Gruppe A / Komplex-Fix-Flaeche |
| 12.2a [M-6] clang-Haelfte des WARNUNGS-Reviews (vl3) nie gefahren (Hausregel 2x gcc->clang) | REGRESSION | Z816-818 | OFFEN | W2-2 vertagt (S-12-Dual-CI #3) |
| 12.2a [M-5] Unbelegte Determinismus-Zusicherungen im GELANDETEN Code: main.cpp:717 abgeschwaecht, :515 NIE gemessen | REGRESSION | Z819-822 | OFFEN | W2-1 (Bytevergleich-Messung+--debug-Matrix) |
| 12.2a [K11-5-Rest] tools-3-Format-Altbestand ohne Traeger (axis_registry_gen,gen_golden_fullpilot,p27_bundle_finder clang-format-rot ausserhalb CI-Pruefmenge) | REGRESSION | Z823-825 | OFFEN | W2 |
| 12.2a [M-7] clang-format-22-Umgebungs-Drift lokal-vs-CI UNGEKLAERT (lokal 22.1.8 rot, CI gruen, par.21.6 'CI entscheidet') | REGRESSION | Z826-829 | OFFEN (Workaround committet, Werkzeug-Paritaet offen) | W2 |
| 12.2a [K12-2] Methodik-Override emissionsseitig UNBEOBACHTBAR: alle 4 work_modes Release, measurement_on/single_thread NULL Leser im Emitter | REGRESSION | Z830-834 | OFFEN | S-8/W2-Entscheid (#22, s8_erbstuecke) |
| 12.2a [K7b-5] KON74-04 ohne Superseded-Vermerk auf KON80-01/V3 | REGRESSION | Z835-836 | OFFEN | Docs-Zug |
| 12.2a [JB-4] KON99-03-Inventar-Drift: 11 deklariert, Ordner traegt 14 (3 VL-6-Ergebnis-Karten unsichtbar) | REGRESSION | Z837-838 | OFFEN | Docs-Zug, Folge X-15 |
| 12.2a [JB-2] BU-Spiegel-Luecke kontext11: 8 Dateien (W1-Beweis-Logs) fehlen KOMPLETT im Repo-Spiegel; f45e995b-tsan-Patch nur lokal | REGRESSION | Z839-842 | OFFEN | naechster Folge-BU-Zug |
| 12.2a [JB-3] hy-a-Folge-Lens-Funde GEFIXT+GELANDET aber UNVERBUCHT (wf_750d2441 TRAEGT_MIT_FIXES, Fund1+Fund2) | REGRESSION | Z843-847 | OFFEN (Meldungs-Luecke) | Quittungs-Nachtrag, loest halbe X-4 |
| 12.2a [K9-3] tail-Fallen-Eintrag ZUGESAGT (Lead 17.08. 11:18), NIE GESCHRIEBEN (0 Treffer 'tail' im Fallen-Register) | REGRESSION | Z848-851 | OFFEN | Memory-Zug (mit T-5/T-6) |
| 12.2b [M-1] super 15941+prt-art 15944 ROT, F5-Rename-Ripple (axes/->organ_axes/ ohne prt-art-MASTER-Nachzug) | REGRESSION | Z855-860 (12.2b) | BEHOBEN (7ed4a7e+d11781f+c926efdc, 15945/15946 SUCCESS) | LEHRE unverankert: Rename braucht Master-Nachzug (12.2c) |
| 12.2b [M-2] super-Fixture-Subset-Wache STILL-SKIP nach K2-Rename (CMakeLists:348 zeigte ins Leere) | REGRESSION | Z861-867 | BEHOBEN (f4b01ab3, super 15976 SUCCESS, KON115) | B-1-HAERTUNG Verdrahtungsfehler=FATAL |
| 12.2b [M-3] Floor-Anker-Fehlkalibrierungs-Komplex 16./17.08. (fbe898be FALSCHE Doktrin, 15936 ROT) | REGRESSION | Z868-872 | BEHOBEN (Rueckkalibrierung 04ac26fa, CI 15937 SUCCESS) | KON98/#78 |
| 12.2b [M-4] test_rcu_concurrency-Komplex (Churn-Test prueft Gegenstand nie) | REGRESSION | Z873-877 | BEHOBEN (Umbau Reader-an-Generationen, #80/f45e995b) | - |
| 12.2b [M-8] Audit-WF-Orchestrator-Doppelbug (.then-Crash k.zusagen.map, Fix haette 4 Segmente STILL gefiltert) | REGRESSION | Z878-882 | BEHOBEN (Vollzaehligkeits-Gate 11/11, Endlauf 65/65 688/688) | Quelle NIE-KUERZEN-Memory 18.08. |
| 12.2b [K5-1] Falsch-ROTER ctest auf ungebautem Baum (487/495)+LastTest.log Falsch-Beleg (16.08.) | REGRESSION | Z883-885 | BEHOBEN (Re-Bau+CI-Form 494/494) | KLASSEN-VORLAEUFER von E3 |
| 12.2b [K5-2] prt_art-Piloten-Compile-Bruch (stale Generat referenzierte fehlende Fixture) | REGRESSION | Z886-889 | BEHOBEN (geraeumt, Re-Configure) | scope-treu an #65 |
| 12.2b [K5-3] golden-Nachstufe 3 MUSS-Funde (wf_a0e17d5d, F1 4 Ueberlaengen, F2 131, Push 5fa37f36->15895 FAILED) | REGRESSION | Z890-894 | BEHOBEN (c0b28670) | Branch-Rest s.12.3/X-1 |
| 12.2b [K5-4] Dual-Review golden 3 Stellen (>120,consteval-switch ohne fail-closed,Selbsttest-Luecke) | REGRESSION | Z895-897 | BEHOBEN (d44008c5, 17/18 rot->18/18, 90ee6809 gelandet) | - |
| 12.2b [K5-6] Eigener Buchungsfehler KON93-02 (6GB-Arena ABLOESUNG statt SCHICHTUNG) | REGRESSION | Z898-900 | BEHOBEN (KON94 fe6439ea, E11->S-13-Buendel #18) | - |
| 12.2b [K5-8] TaskCreate in Subagent-Umgebung nicht verfuegbar | REGRESSION | Z901-902 | BEHOBEN (Haupt-Agent ToolSearch, Task#77 direkt) | Werkzeug-Falle 12.2c |
| 12.2b [K6-3] Workflow-Ergebnis-Verluste (Owner-geruegt 'tendierst zu abschneiden') | REGRESSION | Z903-906 | BEHOBEN (journal_extrakt.py, 21/21+17 Dateien, super 4901f808) | verwandt 10b-Template-Literal-Bug |
| 12.2b [K6-4] Rohdaten-Sicherungs-Luecke 7GB-Raeumung (Floor-Rohdaten nur Job-tmp) | REGRESSION | Z907-909 | BEHOBEN (Nachsicherung docs/sessions/backups) | 2. Vorfall T-8-/B.3-Klasse |
| 12.2b [K6-6] Objekt-Luecken WritebackMethod/XSD/Sink (Validierung nur --validate-Pfad, XSD ohne Enum-Wache, publish=0 Treffer, E-18 ce-seitig unimplementiert) | REGRESSION | Z910-914 | OFFEN (als Design-Input in S-13 konsumiert, beim Bau verdrahten oder fail-loud) | S-13 (#18/#57), vgl. X-15 |
| 12.2b [K6-7] Plan-/Karten-Drift-Sammelbefund (Wellenplan-hybrid stale, A43 ohne Xlsx, measurement_sink dreifach gegatet, LagerBaum-Writer ohne Konsument) | REGRESSION | Z915-918 | ENTLASTET (von Strang-Designs konsumiert, =9x-UEBERHOLT-Klasse) | #57 |
| 12.2b [K6-5] CI-Poller-Skript-Defekt (eingebetteter python3-Dump, Syntaxfehler, exit1) | REGRESSION | Z919-920 | BEHOBEN (Dump in ci_jobs_dump.py ausgelagert) | Poller-Werkzeug-Serie 12.2c |
| 12.2b [K7a-2] Wellenplan-Plan-Regression par.19.1 (VS-A..F STOPP-Gates offen = FALSCH, alle 6 entschieden) | REGRESSION | Z921-923 | BEHOBEN (Kopf harmonisiert, Fortschreibungs-Marker Wellenplan Z.2394) | - |
| 12.2b [K7a-4] prt-art-Submodul detached HEAD + development stale (32e8ffa8 hinter 3077e102) | REGRESSION | Z924-925 | BEHOBEN (checkout+ff-only) | Register 6/E12 fuehrte nur Thesis-Klone |
| 12.2b [K7a-5] Poller mit sh statt bash gestartet (mapfile/Bad substitution, exit2) | REGRESSION | Z926-927 | BEHOBEN (bash-Neustart) | trivial |
| 12.2b [K7b-4] curl '--header @file' liest keine Datei | REGRESSION | Z928-929 | BEHOBEN (curl -K Muster, mapfile blind) | Werkzeug-Rezept 12.2c |
| 12.2b [K8-1] s13-Design-Lens 13 Funde (4 MUSS: Arena-Ueberlauf,xlsx-Zeilenlimit,result.csv-Resume-Blindheit) | REGRESSION | Z930-932 | BEHOBEN (dfb8ba09+e9c74abf) | s13-Zusagen im 688-Audit |
| 12.2b [K8-2] HY-A-Dual-Lens F-1..F-11 (Zweig waere CI-rot gewesen) | REGRESSION | Z933-936 | BEHOBEN (c979d1c0+374c1d12, F-11 gcc499/clang498) | HY-A-Zusagen im Audit |
| 12.2b [K8-3] F-12 Eigenfund: latenter CI-VERDECKTER Bau-Bruch (perms-DLL-Ziele vs 'make inventar') | REGRESSION | Z937-939 | BEHOBEN (374c1d12) | - |
| 12.2b [K8-5] K2-Drift: D1 Plan falsch, D3 Gate G7 '~100%' real 63%, Schritt3/R4 gegenstandslos | REGRESSION | Z940-942 | BEHOBEN (44a909c1, #81) | - |
| 12.2b [K8-7]+[K9-12] Arbeitsweise-Verstoss-Serie (2x Owner-Ruege 17.08.: 13 V-Fragen ohne Explore, KON106-08 38 Fragen ohne Vorlauf) | REGRESSION | Z943-948 | BEHOBEN (KON100-Zug, 12-Wochen-Memory-Schaerfung) | Klasse=Audit 'Owner-Wort-Treue TEILWEISE'/H6 |
| 12.2b [K8-9] Platte 2x kritisch (95%/13G, 97%/8G) waehrend Kombibauten | REGRESSION | Z949-950 | BEHOBEN (Raeumung 8G->14G, git-ls-files=0-Beleg) | - |
| 12.2b [K9-2] Lead-Wiederanlauf-Skript doppelt defekt (Bau-Verzeichnis geraten + CTEST_RC=0 Falsch-Null) | REGRESSION | Z951-953 | BEHOBEN (sauber neu gefahren) | 2. E3-Klassen-Vorfall |
| 12.2b [K9-5] VL-2-Feldzahl-Wache (P0960) BLIND fuer Zeiger-Appends (17. Feld char const*) | REGRESSION | Z954-956 | BEHOBEN (typ-agnostische Zaehl-Sonde cd011e60) | Klassen-Naehe C-F2/Fix13/14 |
| 12.2b [K9-7] k2-Lens ERNST: 6 Zeilenbelege XML-Kopfblock +1 daneben, Kommentar-Unwahrheit Byte-Gleichheit | REGRESSION | Z957-960 | BEHOBEN (Lead uebernahm k2-Worktree, gelandet 6a8cdc65) | - |
| 12.2b [K9-8] vl3-Lens ERNST: K9b-Koeder biss nicht (Nadel '8 ' schon von --debug-Hilfeblock erfuellt) | REGRESSION | Z961-963 | BEHOBEN (7bf66ddd->c8d7295e) | T-6-Koeder-Reichweiten-Klasse |
| 12.2b [K9-9] Floor-Erwartungs-Rechenfehler des Leads (496/492/490 widerspruechlich) | REGRESSION | Z964-966 | BEHOBEN (gestoppt 500/496/494 von hy-a-bau) | Auflage: Schalter-Zustand ins Lande-Protokoll |
| 12.2b [K9-10] Doppellauf-Kollision build-vl12 (Lead-Wiederanlauf parallel zu vl12) | REGRESSION | Z967-968 | BEHOBEN (aufgeklaert) | Ein-Schreiber-Klasse |
| 12.2b [K9-13] Auftrags-Karten-Fehler des Leads (3 Teilfehler: '47 in 12' real 42 in 11, 'drei' real VIER Initialisierer, Timestamp-Schein-Differenz) | REGRESSION | Z969-972 | BEHOBEN (korrigiert von vl12-bau) | Falle 12.2c |
| 12.2b [K10-1] HY-A2 KOMPLETT + HY-A3-ACHSE in W1 NIE BEGONNEN (Abnahmeformel :952 unerfuellt) | REGRESSION | Z973-977 | BEHOBEN (KON113, Bau im Bruch nachgeholt) | Ursachen-Klasse: decl.hpp-SPERRE als Erledigung behandelt |
| 12.2b [K10-5] N7-Luecke REAL: add_dependencies fehlte (rc=127 comdare-experiment-planner not found) | REGRESSION | Z978-980 | BEHOBEN (W1-Landung, 2 Kanten) | comdare_tests-PFLICHT-Falle 12.2c |
| 12.2b [K10-6] TSan-Kopfzeilen-Uebertreibung test_rcu_concurrency ('race-frei unter TSan' falsch, atomic_thread_fence unmodellierbar) | REGRESSION | Z981-984 | BEHOBEN (f45e995b TSAN-GRENZE-Block) | E11=anderes Bein, TSan-AUSBAU bleibt offen |
| 12.2b [K10-7] LEAD-FEHLBUCHUNG (Owner-Ruege 20:34): limit-tote Teammates als erledigt gebucht | REGRESSION | Z985-987 | BEHOBEN (Doppel-Audit->KON113) | H6 generisch, Vorfall war unregistriert |
| 12.2b [K10-8] DOPPEL-INKARNATION des Lande-Agenten nach Workflow-Stop/Resume (alte mergte 4 Commits weiter) | REGRESSION | Z988-990 | BEHOBEN (neue erkannte+deduplizierte selbst) | NEUE Ausloese-Mechanik->12.2c |
| 12.2b [K10-9] Koordinations-Widerspruch (vl3-build-Baeume Lead vs Lande-Agent) | REGRESSION | Z991-993 | ENTLASTET (transparent aufgeloest, Verifikation via Kombibau) | - |
| 12.2b [K10-10] Workflow-Synthese-Tod wf_e06c7f73 (synthese:null) + wqxyzoh3q-Output 88KB gekappt | REGRESSION | Z994-996 | BEHOBEN (rekonstruiert aus journal.jsonl, Resume w8tz2815j) | Klasse 'journal=Wahrheit' |
| 12.2b [K10-11] KON107-Poller-FALSCH-NULL (mapfile-Header leere Statuszeilen, beide Hosts 404, real SUCCESS) | REGRESSION | Z997-999 | BEHOBEN (glhdr.curlrc+curl -sk) | 12.2c |
| 12.2b [K10-13] Talos-Plan-Regression: "Debug-Messung OHNE PMC" beruhte auf v1.12-Stand, Owner-Einspruch bestaetigt (v1.13.0 liefert statisches perf+Debug-Container; Cluster faehrt v1.12.4/paranoid=3; v1.14-GA 27.08.=1 Tag nach Trigger) | REGRESSION | Z1000-1003 | BEHOBEN (korrigiert+getrackt #87) | #87, Ueberschneidung D-5-Audit moeglich |
| 12.2b [K10-14] Cluster-Repo-Verlustbestand: 20 helm-1014-Schrittskripte+ci-templates-Gitlink UNCOMMITTED (#73 landete nur Handout), Erst-Push ans falsche Remote | REGRESSION | Z1004-1005 | BEHOBEN (ee2f933) | #73-Nachzug |
| 12.2b [K11-3] Lead-Fehlbuchung+Message-Verlust: Audit-Teammate-Bericht als vollstaendig verbucht quittiert, Erstversand kam nie an (Owner-Ruege) | REGRESSION | Z1006-1008 | BEHOBEN (Nachreichung, dreifach verbucht) | Buchung-ohne-Beleg-Klasse |
| 12.2b [K11-4] Falsches Gruen im CI-Fix-Bau: CTEST_RC=0 bei 496/500, 4 AVX-512-Tests nie gebaut (EXCLUDE_FROM_ALL ohne comdare_-Praefix) | REGRESSION | Z1009-1012 | BEHOBEN (korrekte J-1-Treppe -> 500/500) | zweite EXCLUDE_FROM_ALL-Instanz, vgl. par.10/503-vs-502 |
| 12.2b [K11-5] lint:format-Fix Runde 1 unvollstaendig (CI prueft 1906 Dateien, Fix nur 3 aus Log-Tail -> 15973 erneut rot) | REGRESSION | Z1013-1014 | BEHOBEN (965b121a, 15974 SUCCESS) | Rest s. 12.2a tools-3 |
| 12.2b [K11-9] Inverse Fehlbuchungen: N3 offen-gebucht ohne Gegenstand, #80 in_progress obwohl gelandet, N1/N5/N6 beim toten Steward nirgends persistiert | REGRESSION | Z1015-1017 | BEHOBEN (S-4-Bereinigung im Fenster) | Rest N1/N5/N6-Messung s. X-9 |
| 12.2b [K11-11] Beinahe-Verfaelschung des Floor-Historienblocks durch blinden Replace | REGRESSION | Z1018-1019 | BEHOBEN (am Diff selbst gefangen, praezise nachgezogen) | Werkzeug-Disziplin-Hinweis |
| 12.2b [K11-12] Zwei CI-Poller STUMM gestorben (bxiwgzwli Quoting; b8kgvg39c ohne Ergebniszeile) | REGRESSION | Z1020-1022 | BEHOBEN (je per Direkt-API ersetzt, 15976/15979 SUCCESS) | Poller-Skript-Klasse selbst OFFEN -> 12.2c |
| 12.2b [K12-3] Koeder-(iii)-Nebenfund: test_m_w12:772-775 prueft Format 5 korrekt, Assert-Meldungstext erklaerte veraltet "3->4"/9-Glieder | REGRESSION | Z1023-1025 | BEHOBEN (98f05b04) | Lehre "Koeder-Meldungen LESEN" -> 12.2c |
| 12.2b [K12-4] P9-Neufunde: anatomy_fingerprint.hpp:10-11 Kopf beschrieb eigene Glied-Zahl falsch (seit R-3) + test_m_w12:727 | REGRESSION | Z1026-1028 | BEHOBEN (cd15dd05) | Abgrenzung zu 5b/Fix18 (andere stale Saetze) |
| 12.2b [K12-6] Kumulative Diff-Hygiene fand 4 >120-Zeilen aus Bruch-Commits (alle push-lokalen Vorgaenger-Gates passiert) | REGRESSION | Z1029-1031 | BEHOBEN (5f269555+Fixup) | bestaetigt KON116-Lehre "kumulative Gates ans Wellen-Ende" |
| 12.2b [K12-7] Lead-Fehldiagnose 500-vs-501: Ursache nicht gesetzter Configure-Schalter -DCOMDARE_CE_PRUEFLINGE (CI-Paritaets-Luecke der lokalen J-1-Treppe) | REGRESSION | Z1032-1035 | ENTLASTET (von bump15-a am Objekt widerlegt, Rezept ergaenzt) | J-1-Memory-Nachzug -> 12.2c |
| 12.2b [K12-10] Beleg-Sicherungs-Luecke: 3 bump15-b-Patches (Vorgaenger-Setter, Kollisionsstand, Decorator) weiter NUR im rotierenden Job-tmp | REGRESSION | Z1036-1038 | OFFEN (optionaler B.3-Nachzug mit X-16-BU-Zug) | - |
| 12.2b [K13-2] GitLab-Push-Auth-Transient (HTTP Basic denied, Retry rc=0) | REGRESSION | Z1039-1040 | ENTLASTET (Infra-Hinweis, K11-sauber nachgemessen) | - |
| 12.2b [K13-3] Mini-Verify-Agent-Tod wf_b943361e (API-Abriss ~19:06); Verify-Tod fehlte in 10b | REGRESSION | Z1041-1042 | BEHOBEN (Cache-Resume wrlfi8rec NULL_NEUE_FUNDE 19:15) | - |
| 12.2b [K13-4] Orchestrator-Prompt-Trunkierung wgmt22mio: Schreiber sah nur 23/25 Stellen-Karten-Eintraege | REGRESSION | Z1043-1045 | BEHOBEN (2 rekonstruiert, Verify 72/72) | zweite Instanz Prompt-Verlust-Klasse (neben Template-Literal 10b) -> 12.2c |
| 12.2b [K13-5] Stale Prosa-Referenz decl.hpp:797 zitiert "decl:568-571" (vorbestehend) | REGRESSION | Z1046-1047 | OFFEN (deklarierter Hinweis) | Traeger par.21.6/Doku-Zug |
| 12.2b [K13-7] Wellenplan-par.5-Defizit-Arithmetik zaehlt F-07b als Deckungs-Streichung, obwohl F-07b Owner-KERN-PFLICHT ist | REGRESSION | Z1048-1049 | BEHOBEN (Task #98 + par.5-Marker super 9015a0de) | #98 |
| 12.2b [K13-8] Fork "gab-es-denn": C-13 selektiver Rebuild STILL geloescht seit 27.07. (ce 813c3232, seither Vollflotten-Neubau) + C-14 SKIP-Wache nur T-NEU-11 + F-07b-W7-Verschiebung mit ERFUNDENER Agent-Autorisierung ("Streichkaskade bestaetigt", 0 Owner-Treffer) | REGRESSION | Z1050-1054 | OFFEN | Traeger #97/#98 + Wiederaufnahme-Register 0f569c8b + par.21.0-Beleg-Tafel |
| 12.2b [JB-1] = 6b-Trunkierung-Verweis (s. 12.1) | UNKLAR | Z1055 | VERWIESEN (dort verdiktiert) | Sicherung/Reparatur X-16/X-17 |
| 12.2c-Klasse: tail-Fenster (Fallen-Bezeichnung) | UNKLAR | Z1059 | VERWIESEN (= K9-3 oben) | Fallen-Register-Nachzug |
| 12.2c-Klasse: ctest -N sed-Muster verliert Tests #1-#99 durch Padding (Zaehlbasis "Total Tests: N") | REGRESSION | Z1059-1060 | OFFEN (NEUE Fallen-Klasse, K6-2) | Fallen-Register-Nachzug |
| 12.2c-Klasse: ctest --no-tests=error als Pflicht-Flag (E3-Klasse) | UNKLAR | Z1060 | VERWIESEN (= K5-1/K9-2 oben) | Fallen-Register-Nachzug |
| 12.2c-Klasse: -DCOMDARE_CE_PRUEFLINGE in JEDER lokalen J-1-Treppe | UNKLAR | Z1061 | VERWIESEN (= K12-7 oben) | Fallen-Register-Nachzug |
| 12.2c-Klasse: comdare_tests-Target ist PFLICHT sonst "Not Run"-Falschrot | UNKLAR | Z1061-1062 | VERWIESEN (= K10-5 oben) | Fallen-Register-Nachzug |
| 12.2c-Klasse: Emitter-Timestamp macht sha256-Vergleich zur Schein-Differenz | UNKLAR | Z1062-1063 | VERWIESEN (= K9-13 oben) | Fallen-Register-Nachzug |
| 12.2c-Klasse: Cross-Repo-Rename braucht Master-Nachzug in Geschwister-Repos | UNKLAR | Z1063 | VERWIESEN (= M-1 oben) | Fallen-Register-Nachzug |
| 12.2c-Klasse: Stop/Resume erzeugt Agent-Duplikate | UNKLAR | Z1064 | VERWIESEN (= K10-8 oben) | Fallen-Register-Nachzug |
| 12.2c-Klasse: Koeder-MELDUNGSTEXTE mitlesen | UNKLAR | Z1064-1065 | VERWIESEN (= K12-3 oben) | Fallen-Register-Nachzug |
| 12.2c-Klasse: Poller-Rezepte gebuendelt (kein eingebetteter python3/K6-5, bash statt sh/K7a-5, curl -K statt --header @file/K7b-4, glhdr.curlrc+curl -sk gegen 404-Falsch-Null/K10-11, Poller nie stumm/K11-12) | UNKLAR | Z1065-1067 | VERWIESEN (= K6-5/K7a-5/K7b-4/K10-11/K11-12 oben) | Fallen-Register-Nachzug |
| 12.2c-Klasse: docker auf prod1 ENTFERNT -> gitleaks lokal 8.30.1 (Koeder biss rc=1) | REGRESSION | Z1067 | ENTLASTET (NEUE Fallen-Klasse, K5-7) | Fallen-Register-Nachzug |
| 12.2c-Klasse: TaskCreate fehlt Subagenten -> ToolSearch im Hauptagenten | UNKLAR | Z1068 | VERWIESEN (= K5-8 oben) | Fallen-Register-Nachzug |
| 12.2d [K5-9] 3 Limit-Risse 16.08. (13:14 Monats-Limit wtsautqlp 3/3+Synthese; 15:47 Session-Limit w8oovcd6x 11/15; 21:38 Session-Limit) -- 15 Agenten tot, Luecken ~11h | REGRESSION | Z1072-1074 | BEHOBEN (alle per Resume-Kette geheilt: wsw7bnx76->wxmetyvp5, w5nfwp05x, wt0v91pcx->w3ebg280l) | - |
| 12.2d [K8-10] K8-Tode 17.08.: Kurz-Verify verdict:null am Session-Limit; hy-a-bau 2x Limit+1x 529; vl12/vl3 529 | REGRESSION | Z1075-1077 | BEHOBEN (alle resumed; pgrep-Falle bestaetigt als Ausloeser des M-4-Doppelstarts) | Memory-Eintrag seit 19.08. |
| 12.2d [K9-11] Spend-Riss 17.08. 11:35-15:39 (~4h): vl3/hy-a idle=failed, wf_a2e443f0 12/12 Agenten leer (bericht:null) | REGRESSION | Z1078-1079 | BEHOBEN (nach /login Resume wy7btb713 komplett per Cache-Replay, KON105) | - |
| 12.3 GEERNTET-Tafel (16 Straenge, nur Zaehler+Beleg, keine Aktion): S-13-Design+Lens+Landung(#18,dfb8ba09) · hy-a-bau komplett(#80/#81,a4366cb8 Ancestor) · goal-drift wf_9819fde6(#78,KON97/98) · Buendel-Explore w4uz2itsx(BUENDEL-BAUPLAN-15) · super-Poller d152ba93(via #79) · 15946-Beweis+#79 · KON99+OWNER-VORAB-15(KON101) · ovs13-Explore(KON102) · 19-Fragen-Runde(KON103/104,#82-#86) · wf_7f847de1 F-Fragen(KON105/106,#86/#99) · vl3-Fix-Runde(7bf66ddd Ancestor) · W1-Lande-Strang wf_b5b4ac36(KON114,par.20;Push-vor-Gate=K3 GEHEILT) · audit-hya-vl3-Subagent(KON113) · K10-Schlussauftraege par.20+Uebergabe(Restnotiz #85(A)-Text stale,s.X-3) · super-Zug2 Welle2(KON116,#20/#70;a11-Vorpruefung=Register-G L9) · E-6-Explore(per KON118 Phantom-Nenner ueberholt,Doku-Rest=seg1-04/F8) | AUFGABE | Z1083-1092 | GEERNTET (bestaetigt, keine weitere Aktion) | 12.3-Tafel |
| [X-1] golden-Rest-Refs: origin bau/golden-homes@5fa37f36 (letzte Branch-CI 15895 FAILED) + refs/rescue/golden-fenster-20260817@fbe898be + wt-ce-golden-rettung, beide Refs Ancestor von development (Substanz enthalten, 0 Traeger) | AUFGABE | Z1096-1100 | OFFEN (REKONSTRUIERBAR) | L20-Aufraeum-Block: D12-Muster (Bundle+SHA256+Owner-GO), 15895 ausbuchen |
| [X-2] k2-Vollbau-Abnahme: bg-Outputs bl5ldht9z/bb3upsvgg nie gelesen, zugesagter G3/G4-Endbericht nie gekommen, Outputs noch in /tmp (Rotations-Risiko) | AUFGABE | Z1101-1104 | OFFEN (REKONSTRUIERBAR; k2 selbst gelandet #81) | Outputs sofort nach backups-workflow, G3/G4-Literale in #93 Gruppe Straenge nachbuchen |
| [X-3] Owner-Voll-Lese-Auftraege 17.08.: Morgen-Klasse via #78 gedeckt, Neugruendungs-Haelfte via wf_6c904e28 vollzogen, #85-Text nennt 17:45-Zusaetze nicht | AUFGABE | Z1105-1109 | OFFEN (REKONSTRUIERBAR) | #85-Vollzug: 17:45-Zusaetze abhaken, synthese-p20-roh.json nur als Delta |
| [X-4] HY-A-Zweit-Lens-Deckung: SPANNUNG AUFGELOEST -- Folge-Lens LIEF (wf_750d2441, TRAEGT_MIT_FIXES 2 ERNST, Fixes gelandet s. JB-3); Rekonstruktions-These gilt nur fuer Runde-2-Flaeche (RCU-Umbau nach 21/25-rot) | REGRESSION | Z1110-1115 | GEKLAERT | Quittungs-Nachtrag(JB-3) + #93-C: Runde-2-Flaeche auf Lens-Deckung pruefen |
| [X-5] rcu-Nachmess-Serien (50/30/20 + A/B-Paarlauf): Endquittungen nie angekommen, Rohwerte nirgends persistiert; Zweck objektseitig gedeckt (f45e995b Ancestor, 502/502) | AUFGABE | Z1116-1119 | OFFEN (REKONSTRUIERBAR) | #93-C: am gelandeten Stand reproduzieren ODER "Rohquittungen nicht persistiert" explizit ausweisen |
| [X-6] tail-Fallen-Eintrag = Verweis auf K9-3 | UNKLAR | Z1120 | VERWIESEN | Ein-Zeilen-Nachzug im T-5/T-6-Memory-Zug (11.5) |
| [X-7] wf_cd301f28 Schwester-Sweep K8-K13 (14 started/13 results, lebte 19.08. 07:35); R1-R10 inhaltlich in Abschnitt 12 konsolidiert (R1=M-3,R2=K5-1,R3=K11-1/K3,R4/R6=M-1,R5=K1-Korrektur,R7/R10=T-10/12.1,R8=K8-1,R9=K10-1) | AUFGABE | Z1121-1124 | BEHOBEN (GEKLAERT, keine Doppel-Ernte) | Journal nach B.3 sichern + Endzeile quittieren |
| [X-8] wf_6ce0675e #95 V-08R-Bau: wt-ce-v08r@0f0742aa (b973dd9f->434d24c6->A2.5-R1-Fix), dirty=0, Journal lebt; Branch bau/v08r-fingerprint-sha NUR LOKAL | AUFGABE | Z1125-1129 | OFFEN (REKONSTRUIERBAR) | Branch auf origin sichern; Bau+Verify abschliessen; Form-/Frist-Satz VOR Landung als F2-Vorlagen-Punkt (=10b/seg1-40) |
| [X-9] vl3-Nachposten N1/N5/N6: Quelle doppelt gesichert (audit-ergebnisse-beide-straenge.md), Register 0 Treffer; vl3 gelandet | AUFGABE | Z1130-1132 | OFFEN (REKONSTRUIERBAR) | #93 Gruppe A aus Audit-BU aufschluesseln, je Posten am gelandeten Stand messen -> Abschnitt 9 |
| [X-10] g2/#17-Strang: 1528f6fd NICHT Ancestor, Branch bau/g2-semantik NUR LOKAL (Einzelkopie-Risiko!), wt-ce-g2@9aa9b9df clean, Abschlussbericht gesichert in wf_b5b4ac36-Journal | REGRESSION | Z1133-1138 | OFFEN zum K15-Zeitpunkt (= W1-V1/9.1(2)-Status-Fortschreibung, seither dort BEHOBEN/GELANDET ba33b9ac 20:23Z) | Branch sichern, Bericht ernten, Lande-Kette per [W1-V1] VOR F2 |
| [X-11] Nested-Worktree wf_e22d25ef-71c-7@7f3901fb, dirty=17 (D2-Strang 10.08.), Tip NICHT Ancestor, Eltern-Journal tot seit 10.08.; Nebenbefund 3 weitere nested Baeume wf_5834b706(p2/p3/p6,dirty=0) | AUFGABE | Z1139-1145 | OFFEN (einziger ganz unverbuchter Arbeitsprodukt-Fund des Sweeps) | 17 Aenderungen als Diff-BU sichern, dev-Enthaltensein pruefen (#62-Muster), Liste-C/D-Ausbuchung ODER D2c-Wiederaufnahme |
| [X-12] V-02R Wert-Befuellung (Laufzeit-Haelfte B-8/A-12): Bausteine im Bruch da (P5 9c17765f Compose+3 fail-loud-Wachen, P3/P4 name_line/len+SHA-256, Map landet K-1-leer); Ernte-Frage per 12.1 GESCHLOSSEN | AUFGABE | Z1146-1149 | TEIL-BEHOBEN (Bausteine da), Rest OFFEN (Laufzeit-Befuellung) | nach C-3a-/F4-Entscheid eigener Board-Task; Hash-Laenge=F2-Punkt |
| [X-13] B-8-Folgeposten Gate-Define-Emission + hat()-Paar: Kommentar-Anker bestaetigt (mess_achsen_naht.hpp:593), par.21.1-Liste+Bauplan tragen B-8, aber KEIN Board-Task; K2=F6 deckt B-8 NICHT | AUFGABE | Z1150-1152 | OFFEN | Beim Di-25.-Schnitt (#96) als Task slotten |
| [X-14] Peer-Sessions e1-e4 + idle Subagent: 3 bg-Sessions idle (11d/5d/4d), nie beendet/geerntet; fachliche Deckung wahrscheinlich (#21 completed); Subagent audit-hya-vl3-soll-ist noch adressierbar | AUFGABE | Z1153-1156 | OFFEN | Je Session Ernte-Check gegen #21/Ledger, dann BEENDEN; Betriebszeile im Di-25.-Schnitt |
| [X-15] VL-6b-G6-Buchung NIE VOLLZOGEN: run_options/organ_subaxes XSD-gueltig, aber von parse_experiment_profile/ExperimentProfile/validate IGNORIERT; vl6b-karte.md verlangte woertlich Nachbuchung -- genau das ist NICHT passiert | REGRESSION | Z1157-1162 | OFFEN | Nachtrag in KF-6/S6-Familie bzw. S-13/#18; beim S-13-Bau verdrahten ODER fail-loud (vgl. K6-6) |
| [X-16] Voll-Audit-ENDSTAND ungesichert (SOFORT): wf_794b904b-Journal (1,1MB,170 started/77 results) NUR unter ~/.claude/projects; audit_107_tafel.md NUR im rotierenden jobs-tmp; Repo-BU traegt nur 18.08.-Teilstand; Journal = EINZIGER Traeger der 111 ungekuerzten Verdikte+seg1-81-Matrix | REGRESSION | Z1163-1168 | OFFEN (SOFORT-Sicherung noetig) | Vor Aufraeumen: additiv nach backups-workflow/20260819-audit-endstand-794b904b/, dann Repo-BU-Nachzug; K12-10-Patches im selben Zug |
| [X-17] 23-Schritte-Deckungs-Matrix ohne publizierten Traeger: Volltext nur im Audit-Journal Z.144, 6b-Zeile seg1-81 endet mid-Satz | REGRESSION | Z1169-1173 | OFFEN | Nach X-16 als Register-Nachtrag 6c bzw. Fix-Strecke-2-Eingang publizieren, 6b-Zeile reparieren, Kuerzung deklarieren |
| 12.4 SOFORT (vor jedem Aufraeumen, B.3): X-16 Audit-Journal+107er-Tafel sichern · X-2 k2-Outputs aus /tmp sichern · X-10 bau/g2-semantik + X-8 bau/v08r-fingerprint-sha auf origin sichern · K12-10-Patches mitnehmen | AUFGABE | Z1177-1179 | GEPLANT | SOFORT |
| 12.4 Fix-Strecke 2 erhaelt zusaetzlich: T-10-Praezisierung(12.1) · 6b-Reparatur+23er-Matrix(X-16/X-17) · B3-Anker-Abgleich VOR Gruppe-D-Messung(12.1) · prt-art-Roundtrip-SHA-Pin als W2-Task(K7b-3) · tools-3-Format-Traeger(K11-5) · W2-1/:515-Registeranker(M-5) | AUFGABE | Z1180-1184 | GEPLANT | Fix-Strecke 2 |
| 12.4 #93 erhaelt konkretisierte Pruefposten: Gruppe A(vl3 ROT-3+_pclose K10-4, N1/N5/N6 X-9, F2/Wstringop-Verbleib K10-12, Warnungs-Review-clang M-6/W2-2) · Gruppe C(HY-A-Runde2-Lens X-4, rcu-Serien X-5, V-02R-Bau-Haelfte X-12) · Gruppe D(B3 richtiger Anker 12.1) · Gruppe Straenge(k2-G3/G4-Literale X-2) | AUFGABE | Z1185-1189 | GEPLANT | #93 |
| 12.4 Di-25.-Schnitt (#96) erhaelt: B-8-Task(X-13) · VL-6b-Parser-Befund in S-13/#18(X-15,mit K6-6) · Methodik-Override-Entscheid S-8/#22(K12-2) · Peer-Session-Triage(X-14) · golden-Ref-Ausbuchung(X-1) · Nested-Worktree-Triage(X-11); VORHER vor F2: g2-Landeweg(X-10=W1-V1-Pflicht) | AUFGABE | Z1190-1193 | GEPLANT | #96 |
| 12.4 Docs-/Memory-Zug: KON74-04-Vermerk(K7b-5) · KON99-03-Zaehlwerk(JB-4) · Folge-BU-Spiegel(JB-2) · hy-a-Lens-Quittung(JB-3) · #85-Text-Delta(X-3) · Fallen-Block 12.2c GESCHLOSSEN in T-5/T-6-Memory-Zug (13 Klassen, nicht einzeln verlieren) | AUFGABE | Z1194-1196 | GEPLANT | Docs-/Memory-Zug |
| 13.1 Audit-ENDSTAND-PRAEZISIERUNG (Auflage fuer 6c/X-17): 111er-Tafel(6b) = ZWISCHENSTAND; Audit-ENDSTAND 502 ERFUELLT/74 UEBERHOLT/85 ABWEICHUNG/22 FEHLT/5 NICHT_PRUEFBAR = 107 offene (ueber 688 Zusagen) | UNKLAR | Z1201-1205 (13.1) | ABGESCHLOSSEN (6c uebernimmt Endstand-Zahlen+Volltexte aus BU-Journal @9052a56b) | 6c-Publikation |
| 13.1 4 spaeter entlastete IDs -> ERFUELLT: LS2-33, LS2-41, seg3-kon8-11 | REGRESSION | Z1203-1204 | BEHOBEN (Status-Fortschreibung: waren ABWEICHUNG/VERTAGT, jetzt ERFUELLT) | = Fortschreibung LS2-33/LS2-41/seg3-kon8-11 oben |
| 13.1 1 ID -> UEBERHOLT: LS2-34 | REGRESSION | Z1203-1204 | ENTLASTET (Status-Fortschreibung: war KRITISCH/ABWEICHUNG, jetzt UEBERHOLT) | = Fortschreibung LS2-34 oben |
| 13.2 [F-A] Komplex-Fix-Rolle (v4.3) DEKLARIEREN in KON119/Merge-Botschaft (Fix-Strecke2+L2/L3-Kombibau am zusammengesetzten Stand uebernehmen sie; Pushes je L-Glied juenger) | AUFGABE | Z1207-1209 | OFFEN | KON119/Merge-Botschaft |
| 13.2 [F-B] B3-Bau-Slot -> in Fix-Strecke2 aufgenommen (M1-Messung beide Anker + G5-Bau) | AUFGABE | Z1209-1210 | GEPLANT | Fix-Strecke 2 |
| 13.2 [F-C] B-8 + VL-5/VL-6-Doku beim Di-25.-Schnitt NAMENTLICH gegenzaehlen (nur implizit im Wiederaufnahme-Register) | AUFGABE | Z1210-1211 | OFFEN | Di-25.-Schnitt (#96) |
| 13.2 [F-D] VL-3(a) clang-Warnungs-Review = W2-1-Buchung (Sweep B-6), in #93-A DEKLARIERT ausweisen (sonst Freeze-Check-Falsch-Rot) | REGRESSION | Z1211-1213 | OFFEN | #93-A |
| 13.2 [F-E] B-1-Kern GEBAUT (fixture_schema_subset_check.cmake haertet, CMakeLists:349 -DFIXTURE); Rest: Mutationsprobe ROT-statt-SKIPPED, Kopf-Nachzuege, SCHEMA.md:48 | REGRESSION | Z1213-1214 | TEIL-BEHOBEN (Kern gebaut), Rest OFFEN | L4 |
| 13.2 [F-F] P2/P3-Vorlagen aus par.21.6 AM ORIGINAL bauen | AUFGABE | Z1214-1215 | OFFEN | par.21.6-Nachzug |
| 13.2 [F-G] clang-debug-ENTLASTET-Deklaration beim Freeze-Check mitfuehren; waehrend Fix-Strecke gehoert wt-ce-bump15 dem Workflow (Lead-Session-cwd beachten) | AUFGABE | Z1215-1216 | OFFEN | Freeze-Check |
| 13.3 [L-A] OF-4-PAT-Kette A1->A2->A3 | AUFGABE | Z1219 | BEHOBEN (completed, #54) | #54 |
| 13.3 [L-B] V8 GitHub-PAT-Rotation | AUFGABE | Z1219-1220 | OFFEN | - |
| 13.3 [L-C] V9 rescue-Ref w3-thesis-c (95 Alt-Trailer) | AUFGABE | Z1220 | OFFEN (an E12-Owner-Entscheid gekoppelt) | E12 |
| 13.3 [L-D] node6/id56/id18 (Owner-Klaerung) | AUFGABE | Z1220-1221 | OFFEN | Owner |
| 13.3 [L-E] VL-5(b)-(e) in L4 (+X-17-Gegenprobe) | AUFGABE | Z1221 | OFFEN | L4 |
| 13.3 WARNUNG: N1-N5-N6 (vl3/X-9) != N-1..N-6 (Bauplan via X-17) -- Verwechslungsgefahr, Parallel-Order gilt per Memory | UNKLAR | Z1221-1222 | OFFEN (Warnung) | - |
| 13.4 seg4-58-Detail: snmalloc '-Werror=pedantic' blockt comdare_tests -> 37 Not Run, Eichlinie dort BLIND | REGRESSION | Z1224-1226 | OFFEN | L4-/W2-Posten |
| 13.4 [K-07] #90/#91 nie angeworfen (naechste Parallel-Kandidaten nach dem Rueckweg; #91-Frist Identitaets-Entscheide vor Mi 26.08.) | AUFGABE | Z1228 | OFFEN | #90, #91 |
| 13.4 [P-12] wt-ce-vl12/build-vl12 880M stale | AUFGABE | Z1230 | OFFEN | Aufraeum-Block |
| 13.5 v08r-L3-AUFLAGE: 4-Zellen-Bilanz gilt fuer 434d24c6; Fix-Tip 0f0742aa OHNE dokumentierte Abnahme | AUFGABE | Z1233-1235 | OFFEN | L3 faehrt Kurznachweis an 0f0742aa ODER landet auf 434d24c6+Nachzug (Task-#95-Metadata) |
| 13.6 ENOSPC-Ausgang+Queue-Verfall-Lehre+Pipeline-16020-Heilung | REGRESSION | Z1237-1238 | BEHOBEN (verbucht Uebergabe Abschnitt 10) | - |
| 13.6 g2-ENDSTAND cb856212 (Rest-Kategorien LEERE MENGE; 4/4 Zellen@9aa9b9df; g2-Funde 2-4 vertagt) | UNKLAR | Z1238-1239 | ABGESCHLOSSEN (Kategorien leer), Funde 2-4 VERTAGT | -> L2-Optionen A/B |
| 13.6 Memory-Z.73-Fix | AUFGABE | Z1239 | BEHOBEN (ERLEDIGT) | - |
| 13.6 BU-Ordner GELANDET 9052a56b (Redaktion wf_279c39c0 FREIGEGEBEN 18/18 SAUBER, CI SUCCESS) | AUFGABE | Z1239-1240 | GELANDET/CI-BEWIESEN | - |
| 13.7 FIX-STRECKEN-DECKUNGS-TAFEL: laufender WF wf_46805ad8 traegt F1-F9,T-2,T-10-Bau,L21,B3,tools-3,M-5,18.6(3)-Deklaration; NICHT: 13.1/6c(Lead-docs-Zug),13.2 F-A/F-E/F-F(Lande-Zuege),13.3(Di-25/Owner/L4),13.4(L4/W2/Infra/Di-25),13.5(L3) | AUFGABE | Z1242-1247 | LAEUFT (Scope-Zuweisung; K16-Pflicht: WF-Quittungen gegenpruefen) | wf_46805ad8 |
| 13.8 [A1] F6-TRAEGER BENANNT = Task #102 (Frist Do 20.08.): EIN golden-Zug B-9+A-11+B-10.3+B-11.2; ZWEI Anker-Klassen (TABU 0x56F1B721C72DC10E + Emissions-CRC 0xF1C1F26A1232073B); Lock-Regen gehoert NICHT hinein | AUFGABE | Z1252-1255 | GEPLANT (Frist Do 20.08.) | #102 |
| 13.8 [A2] LANDE-VORBEHALTE L1: (a) Gate-4-Lock-Rot 4 Traeger -> T-B=Lande-Schritt3 (Erst-Versionen+Regen-Commit+pre_push_lande_gates voll gruen) | REGRESSION | Z1256-1257 | OFFEN | T-B, Lande-Schritt 3 |
| 13.8 [A2] (b) T-C: 4 XML-Wohlform-Vorbestandsfehler ('--' im Kommentar: m3_smoke_coverage:170, m3v2_sota_pilot:8, wdk_fairness_example:73, measurement_axis_registry:61) | REGRESSION | Z1257-1259 | OFFEN (im Lande-Zug heilen, sonst ci_xml_wellformed_guard 4/160 rot) | T-C |
| 13.8 [A13] TIP-DELTA-DECKUNG: Abnahme/R2 galten @8cd32a0d, HEAD ist 79171599 (+3 tools-Format-Dateien+1 Kommentarzeile, ausserhalb CI-Pruefmenge) | REGRESSION | Z1260-1262 | OFFEN | vor L1 pre_push_lande_gates.sh am neuen Tip fahren + M-7-Klaerung (#100) |
| 13.8 [A4] KON119-PFLICHTEN: F4/18.6(3)-Deklaration (fixr1_endquittung_fixstrecke2_vollstaendig.md Abschnitt 0) + F-A-Komplex-Fix-Deklaration + T-A Ledger-Buchung C-3a | AUFGABE | Z1263-1265 | OFFEN | KON119 |
| 13.8 [A7] B3-SPEZ-ABWEICHUNG (deklariert, kein Defekt): G5 baute Legenden-Erbe statt m1-vorgesehenem neuem CEB-Stempel-Glied, golden-NEUTRAL; m1-F2-Schutzgedanke lebt als B5-VORPOSTEN in #24 | REGRESSION | Z1266-1270 | ENTLASTET (deklariert) | KON119-Vermerk, #24 |
| 13.8 [A8] NP-23 GEBAUT MIT ZAHL 7 (nicht 5/6): Voll-CSV 25->32 Spalten, 16er-Pipeline-Vertrag unberuehrt, schema_freeze.hpp im selben Commit (78cc75e6) | REGRESSION | Z1271-1272 | BEHOBEN | NP-24-Baupunkt neu benannt |
| 13.8 [A9] F7-WURZEL SCHARF: Generator-Default out_path='system_axis_registry.xml' im CWD | REGRESSION | Z1273-1274 | BEHOBEN (Datei geloescht) | = Fortschreibung H1/F7 |
| 13.8 [A10] PIC-LATENZ: C3-Rot war Zellen-Mischbau (CMAKE_C_COMPILER=cc->gcc-15.3 ohne PIE-Default bei CXX=clang++, prod1-Maschinen-Falle); comdare_hdr_histogram_wrapper einzige Haus-Lib ohne POSITION_INDEPENDENT_CODE ON | REGRESSION | Z1275-1278 | ENTLASTET (Ursache), Rest OFFEN (W2-Mini-Posten PIC-Hausnorm) | 'W2-Slot-Posten Altbestand' entfaellt in alter Form |
| 13.8 [A11] T2-Haertung optional: [0]/[4]-Vertauschung nur Test-TU-gedeckt | AUFGABE | Z1279-1280 | OFFEN (W2-klein) | 2 static_asserts unter anatomy_fingerprint.hpp:1207 |
| 13.8 [A12] -> Task #103 TSan-Vollausbau, eigene Objektklasse (87fa9473 aendert CI-Verhalten mit L1!) | AUFGABE | Z1281 | OFFEN | #103 |
| 13.8 [A5] VERIFY-R1-VOLLTEXT geborgen (nur im Journal): 6 Funde (2 MITTEL/4 NIEDRIG), inkl. Korrektur "F3=Endstand decken" (R1-Kandidat decl.hpp war falsch) | REGRESSION | Z1282-1283 | BEHOBEN (alle in fix-r1) | - |
| 13.8 [A16-A18] Fallen/Betrieb (Memory-Zug): LastTestsFailed.log=Altrest bei gruenem Lauf · CMakeCache-mtime kein Halbschreib-Indiz · Basename-Gleichheit statt Substring (clang++ endet auf g++!) · ctest-Nummern rechtsbuendig · 'ccache 1837 Hits' nie zitieren · ninja-Endzeile [N-1/N] normal · Werkzeug-Targets comdare_adhoc_emitter_cli+comdare_catalog_codegen_cli | REGRESSION | Z1284-1288 | OFFEN (Fallen-Register-Nachzug) | Memory-Zug |
| 13.8 [A19] ZITIERFUNDUS: G1-Dreh wire-/preimage-neutral BELEGT; Ordinale 0-5 blockweise; axis_category_of=NP-02-Andockpunkt; Status-Codes 13-15 in hybrid_dock_contract.hpp; Floor-Endstand 507/503/501; Hygiene 34174 Zusatzzeilen 0/0 | UNKLAR | Z1289-1291 | ABGESCHLOSSEN (Zitierfundus) | - |
| 13.8 COMMIT-TAFEL e285d316..79171599 (20 Commits) + Vollzaehligkeits-Urteil: Eingangsmenge 15/15 GEDECKT, kein Posten still verschwunden | AUFGABE | Z1292-1294 | CI-BEWIESEN (Vollzaehligkeit) | schatz-leser-Bericht + backups-workflow/20260819-fixstrecke2-logs/fixr1_endquittung_*.md |
