# REGRESSIONEN-REGISTER #15-BUMP-BRUCH -- 18.08.2026 (LEBENDES DOKUMENT, wird je Workflow-Ruecklauf fortgeschrieben)

> Owner-Auftrag 18.08. (verbatim): "bitte erstelle jetzt ein session Dokument ueber gefundene Plan,
> Architektur und Code Regressionen, beginne mit den codex regressionen und dann konsolidiere die
> workflows hinzu sobald sie zurueck kommen."
> GEGENSTAND: der ungelandete #15-Bruch (wt-ce-bump15, bau/bump15-preimage-bruch @ 67dafa46,
> 25 Commits auf ce/development 20c111c4). QUELLEN-STAND dieser Fassung: 4/4 Codex-Lenses
> (gpt-5.6-sol, reasoning ultra, je Lauf-Header belegt; Outputs ~/.claude/jobs/5a19728e/tmp/
> codex-lens/lens{A..D}_out.txt) + 36/688 Audit-Verdikte (verif-1..3). AUSSTEHEND (Abschnitte 5/6
> als Platzhalter): Claude-Review-Bewerter+Synthese (wf_13b562e7) · Voll-Audit-Synthese
> (wf_794b904b, sequentiell ueber 652 Rest-Zusagen).
> Jeder Fund traegt seinen A2.5-Weg; dreiwertige Quittung (BEHOBEN/ENTLASTET/VERTAGT) folgt in der
> Fix-Stufe. Arbeitskopie der Rohliste: ~/.claude/jobs/5a19728e/tmp/findings_sammelliste_bump15.md.

## 0. LAGE IN DREI SAETZEN

Die vier Codex-Lenses (erste erfolgreiche Codex-Laeufe nach 7 bwrap-Toden; Plan B = Diff-Volltext
im Prompt) liefern 3 KRITISCH + ~12 ERNST echte Funde -- der Bruch landet erst nach einer vollen
A2.5-Fix-Runde. Die zwei schaersten Funde treffen die IDENTITAETS-Kernidee des Stempels
(Preimage-Kollision moeglich, Map-Grammatik am Produktionsweg unbewacht) -- genau die Klasse,
fuer die der Dual-Review gebaut ist. Drei Codex-"Blocker" waren Scope-Artefakte des
Diff-Zuschnitts und sind am Objekt ENTLASTET (transparent in Abschnitt 4).

## 1. CODE-REGRESSIONEN (Defekte im gebauten Bruch-Code; Codex-Lenses A-D)

### 1.1 KRITISCH -- Identitaets-Klasse (Fingerprint/Preimage)

- **[B-F2] Preimage-KOLLISION durch stillen Stellen-Verwurf** -- anatomy_fingerprint.hpp:1222-1234:
  `komposit_key_text()` verwirft Dezimalstellen oberhalb der achten STILL (IDs 100000000 und
  200000000 werden beide zu "00000000"); die Ordnungswache vergleicht die ORIGINAL-IDs und sieht
  die Kollision nicht. ZWEI verschiedene Hybrid-Kompositionen koennen DASSELBE Preimage erhalten --
  bricht die Fingerprint-Doktrin (Stempel = Identitaet/Cache-/Lager-Schluessel/Skip-Marke; ein
  Lager-SKIP wuerde die falsche Binary fuer gueltig halten). FIX: fail-loud bei Rest nach 8 Stellen
  bzw. stufen_id<=99'999'999 erzwingen; das 32-Dock-Argument braucht einen GEKOPPELTEN Nachweis.
- **[B-F1] Map-Grammatik nur im optionalen Builder bewacht** -- ebd. :511-531/:806-815/:1262-1291:
  Der produktive Weg (COMDARE_HYBRID_KOMPOSIT_GLIED / direkte KompositMapGlied{string_view}) prueft
  NUR die allgemeine Glied-Grammatik -- exakt-64-Lowerhex, kanonische Schluessel, strenge Ordnung,
  Duplikate, ';'/'='-Positionen werden dort NICHT erzwungen => nichtkanonische/mehrdeutige Maps
  moeglich. FIX: EIN gemeinsamer constexpr-Parser fuer den finalen String, im Carrier UND als
  static_assert auf dem Define (leer ODER <=32 Segmente, Key 1-8 Dezimal ohne fuehrende Nullen,
  genau ein '=', Wert exakt 64 Lowerhex, ';' nur zwischen Segmenten, Keys streng steigend).
- **[A-F1] Proxy-Bindungszustand spaltbar** -- hybrid_binary_proxy.hpp:225-229/:251-264/:278-280:
  `ziel_binden()` uebernimmt ZWEI unabhaengige Zeiger ohne gepaarte Nullheit, Objektidentitaet
  oder `basis->genus()==ZielGenus`-Pruefung -- Operationspfad (antrieb) und Lifecycle/Identitaet
  (ziel_) koennen auf VERSCHIEDENE Objekte zeigen; nach dem Loader-Gate kann genus() sogar den
  Reroute-Wert liefern. FIX: EIN typisierter Binding-Handle, aus dem beide Sichten entstehen;
  alternativ Nullheit+Most-Derived-Identitaet+Ziel-Genus atomar vor jeder Mutation.

### 1.2 ERNST

- **[A-F5] Loader: rohe uint8->Enum-Casts ungeprueft** -- anatomy_module_loader.cpp:179-180/:198:
  ein Modul, das konsistent Genus 5 (FunctionInterfaceReroute) meldet, PASSIERT den
  Konsistenz-Riegel, obwohl Genus 5 nie ABI-sichtbar sein darf; unbekannte Bytewerte erreichen
  gattung_of(). FIX: Whitelist der 5 ABI-sichtbaren Ziel-Genera VOR dem Cast, sonst
  status_identity_mismatch + native_unload.
- **[A-F4] Leak-Pfad beim Identity-Mismatch** -- ebd. :199-205: potenziell werfendes Logging
  (dll_path.string()) VOR pfn_destroy()/native_unload() -- bei Exception lecken Instanz+Handle.
  FIX: Scope-Guards ab Erwerb (destroy vor unload beim Unwinding), Diagnose nach dem Cleanup.
- **[A-F3] CT-Sperre der Hybrid-Makros umgehbar** -- hybrid_module_abi_v1.hpp:71-72/:99-104:
  ZielGenusExpr wird ZWEIMAL ausgewertet (Template-Argument + Laufzeitkontext) -- ein
  kontextabhaengiger Ausdruck (is_constant_evaluated) besteht die CT-Sperre als SearchAlgorithm
  und exportiert View; der Loader faengt das erst als Status 11. FIX: Ziel EINMAL als constexpr
  AnatomyGenus einfrieren, Typ und beide Exports daraus ableiten.
- **[B-F3] Identitaetswirksamer leerer Default** -- anatomy_fingerprint.hpp:970-989/:1164-1174/
  :1309-1316: alle 3 APIs tragen MessGatesGlied{""} als Default, obwohl der eigene Kommentar den
  Default-Weg verbietet; die nie-leeren TU-Gates sind still auslassbar, die 3-Param-Proben nutzen
  genau diesen Weg. FIX: leeren Default entfernen, TU-Wert explizit verlangen (Overload-Schnitt).
- **[B-F4] 32-Dock-Deckel unerzwungen** -- ebd. :1264-1291: 33 Beitraege (2233 B) passen in den
  2368-B-Puffer; die Puffergrenze beweist den Deckel NICHT. FIX: size()<=Deckel fail-loud vor der
  Schleife + im Map-Parser.
- **[B-F5] Dangling string_view via Temporary** -- ebd. :1208-1212: `hybrid_komposit_map_bilden(...)
  .sv()` auf dem Temporary erlaubt -- gespeicherter KompositMapGlied haelt nach Vollausdrucks-Ende
  einen dangling View (der geloeschte Carrier-Ctor sieht nur den fertigen View). FIX: sv() const& +
  sv()&& = delete.
- **[B-F6] 64-Hex-Wache prueft nur Byte 64** -- ebd. :1362-1369: Arraygroesse+Terminator geprueft,
  Bytes [0..63] weder auf Lowerhex noch eingebettete NULs. FIX: alle 64 Nutzbytes [0-9a-f] pruefen.
- **[C-F2] Typ-Folge-Wache 18 statt 20 Typen** -- anatomy_module_abi_v1_decl.hpp:~445: die Wache
  behauptet 20 Felder, prueft 18 Typen -- name_line(FeldZgr)/name_len(FeldU64) fehlen am Ende =>
  Typwechsel der 2 Append-Felder unentdeckt (verkuerzte Aggregatinitialisierung bleibt gruen);
  Objekt-Indiz: :392 FeldZahl=20 gegen :435 "18 Argumente". FIX: FeldZgr,FeldU64 anhaengen,
  Kommentare 18/19 -> 20/21.
- **[D-F4b] Toter Enum-Name im Emissions-Pfad** -- merge_plan.hpp:78 liefert String
  "Verbund2_Hybrid"; das Enum PrueflingVerbundStrategy kennt NUR Verbund1_CeOnly/Verbund2_Replace/
  Verbund3_Union; sota_catalog.hpp:238/:243 rendert `pf::PrueflingVerbundStrategy::<strategy>` --
  eine Emission des "merge"-Pfads erzeugte UNGUELTIGES C++. Kommentar merge_plan:69-73 deklariert
  den Pfad als dormant, traegt aber KEINEN fail-loud-Riegel vor der Emission. FIX: "merge" an der
  Emissions-Stelle LAUT ablehnen (oder Enum-Wert materialisieren) -- dormant-Prosa allein ist
  keine Wache (LUECKE=PFLICHT).
- **[D-F5] F8-Roundtrip-Koeder umgeht das Dock** -- test_hy_f8_reroute.cpp:126-151:
  `cea::IDriveableTier* antrieb = &ziel;` bindet DIREKT am Fixture vorbei am Dock --
  tier_insert/tier_lookup pruefen die Dock-Weiterleitung nicht; eine kaputte funktionale
  Weiterleitung bliebe gruen (T-2/T-4-Klasse). FIX: Antrieb ausschliesslich ueber den vom
  Proxy/Dock gelieferten Griff beziehen und den Koeder hindurch fahren.
- **[D-F6-Rest] F8-dlopen-Haelfte belegt 4 der 6 Symbole; Set-Modul-Cast-Ergebnis ignoriert**
  (der 6-Symbol-Beleg lebt im Q2-Test; fuer die F8-Haelfte gilt Codex' Punkt) -- FIX: je Modul
  alle 6 Symbole handle-lokal aufloesen+aufrufen; Set-Proxy-Typ und Standard-Dock pruefen.

### 1.3 HINWEIS (Code)

- **[B-F7]** BudgetSum==6057-Assert erkennt kompensierende Aenderungen nicht (Kommentar behauptet
  es) -- 10 Einzel-Summanden einzeln pinnen (Array-Vergleich).
- **[A-F6]** kDeklarierteRerouteZiele==2-Assert tautologisch -- geschlossene constexpr-Whitelist
  {SearchAlgorithm, Set}, Praedikat+Anzahl daraus ableiten.
- **[D-F2]** work_mode-Namen-Anker doppelt gepflegt (Registry + Literal-Liste), Fehlertext nennt
  Release vor Compare -- Single-Source herstellen.
- **[D-F1]** resolve_measure_parallelism_of_mode()/volle "debug"-Exception ohne Tests.
- **[D-F8]** test_hy_f8 nutzt std::cout ohne <iostream>.
- **[C-F5]+[A-F7] Kommentar-Wahrheiten:** "sizeof 136"->152 (decl:314-Umfeld) · "4 Pflicht-
  Symbole"->6 (loader.cpp:211 + hybrid_module_abi_v1.hpp:7-10/:52-56) · genus_build_admission
  :68/:90 "View=4"/"alle FUENF" -> Reroute=5/sechs · "neun Codes" -> zwoelf (0..11) ·
  [B-F8] "leeres 10. Glied waere ohne Bump byte-identisch" ist falsch (9. Separator kommt dazu;
  Format-5-Begruendung bleibt via Umsortierung+Schema) · [B-F9] "nur Vertauschungen uebersetzen
  nicht mehr" gilt nur fuer S-6b, nicht S-6a (Mess/Organ wechseln [1]/[3]).

## 2. ARCHITEKTUR-REGRESSIONEN/-SPANNUNGEN

- **[A-F2] MaxDocks-Vertrag vs. Ein-Ziel-Zustand** -- hybrid_binary_proxy.hpp:183-193/:258-280:
  Der Proxy DEKLARIERT 1..32 Docks, haelt aber EIN globales ziel_ -- beim zweiten Slot delegieren
  Lifecycle und genus() an das zuletzt gebundene Ziel; Slot-Loesen loescht ziel_ fremder Slots.
  Architektur-Entscheid des Minimal-Schnitts EHRLICH machen: static_assert(MaxDocks==1) JETZT;
  slotbezogene Basiszeiger + explizite Routing-Regel = HY-B/W3-Design (nicht still halb).
- **[C-F4] Abi7-Freeze verwechselbar mit lebendem Minor** -- decl.hpp:~780/:784: beide oeffentlich,
  typgleich, aktuell wertgleich 2 -- ein Konsument kann den Freeze-Wert ziehen; unsichtbar bis zum
  naechsten Live-Bump. Kapselung als unteilbares Abi7-Tupel bzw. technische Begrenzung auf
  Freeze-/Ablehnungstests.
- **[D-F3] fail-loud-Kette der Verbund-Tokens** -- merge_plan.hpp:79 laesst UNBEKANNTE Tokens
  (inkl. Alt-Token "fulljoin") still auf Verbund2_Replace fallen. ENTLASTET, WENN der Validator
  davor hart ablehnt (kExperimentAxisMergeModes {"replace","merge","union"} @
  validate_profile.hpp:705 + Q1-Wache is_bekannter_verbund_strategie_name) -- der Ablehnpfad ist
  in der A2.5 zu MESSEN (Koeder "fulljoin" muss VOR merge_plan sterben), sonst Tiefen-Fix dort.
- **[C-F3] Layout-6-Probe prueft die ZAHL, nicht das Layout** -- decl.hpp:~548:
  stamp_pod_layout_probe(6u) baut das 20-Feld-Layout mit Versionszahl 6 (K-4-Klasse: Gleichheits-
  wache numerisch bewiesen, Offsets-Differenz NICHT). Entweder eingefrorener Layout-6-Mirror
  (sizeof==120 + offsetof-Vergleiche) oder Probe EHRLICH als Nur-Zahlen-Beweis dokumentieren.

## 3. PLAN-REGRESSIONEN (Soll-Ist; 36/688 Audit-Verdikte, Rest laeuft)

- **[LS2-34, Audit KRITISCH] Lock-Regen fehlt in den 25 Commits** -- target_isa_complex_axis.hpp
  geaendert (765ee421), axis_version.lock traegt den ALTEN Digest. DECKUNGSGLEICH mit dem
  deklarierten Lande-Schritt (KON116: Lock-Regen am ENDSTAND der Welle) -- Plan haelt, der Beleg
  ist jetzt am Objekt; der Regen ist Schritt 3 der Lande-Kette, KEIN Vorab-Worktree-Fix.
- **[seg1-37, Audit KRITISCH] AxisKind-Ordnung NICHT gedreht** -- topics/axis.hpp unberuehrt;
  anatomy_fingerprint.hpp:891-914 dokumentiert den Gegenteil-Entscheid. GEDECKT durch KON5-04
  (AxisKind war immer Owner-VORLAGE, nie festgelegt) => F2-Owner-Vorlage Punkt 1; ohne GO kostet
  die spaetere Drehung einen weiteren Preimage-Bruch.
- **[seg1-04, ERNST] 3 stale E-6-Verweise** -- hybrid_config_xml.hpp:52-55 + hybrid/README.md:33
  (+ super-Konformitaetszeile) behaupten weiter "offene Owner-Frage E-6 / Registry 22->23" --
  ueberholt durch KON118 (Phantom-Nenner; kGenusBuildSlotCounts 5->6 IST gebaut). A2.5-Doku-Fix.
- **[seg1-40, ERNST] V-08R nur zur NAME-Haelfte im Bruch** -- planner_version.hpp:78-84:
  fingerprint_sha() weiter leer (kFingerprintShaBewusstLeer=true). Triage: Buendel-SOLL oder
  deklarierter Folgeposten (B-6-Split) -- Audit-Synthese entscheidet, nicht glattrechnen.
- **[seg1-43, ERNST] Tooling-ORDNUNG unvalidiert** -- ceb_tooling_list wirft nur bei unbekannter
  id/Deckel/leer; die wallclock/macro/micro-Ordnung haengt am OFFENEN V-13 (Owner-Scheibe) =>
  vermutlich deklariert-ungedeckt; Kandidat fuer die Vorlagen-Runde, kein stiller Bau.
- **[seg1-44, ERNST] golden-Nachposten-Spannung** -- nur der S-6a-Anker-Teil ist im Bruch;
  K1-avx512-Filter, E-B-CRC, telemetry-silent NICHT. Task-#15-Text sagt "3 golden-Nachposten im
  Bruch", die Kontext-13-Uebergabe deklariert "E-B/A-11 = golden-gebundener FOLGEZUG (V-03R-Budget
  frei)". SPANNUNG AUSGEWIESEN -- Aufloesung durch Audit-Synthese + ggf. Owner-Satz.
- **[seg1-45, ERNST] PMC-Snapshot traegt 1 statt 5 Flags** -- measurement_snapshot.hpp nur
  pmc_available; die 5 Quell-Flags nicht uebernommen. Gehoert zum #83-Umfeld (PMC fail-loud,
  eigener Task, "im Bruch-Umfeld") -- Triage: nicht Kern-Buendel, Frist beachten.
- **[LS2-33, ERNST] A1-Durchzug 9-vs-18 offen** -- simd_organ_requirement 9x kRequiredNone gegen
  Registry 18; Kette verdrahtet, Durchzug fehlt (bekannter W1-Posten "A1-Durchzug 18 Achsen").
- **[seg4-15, ERNST] S-16-Regression waechst** -- ci/tests/*.sh 13->14 (guard_basis_bissprobe.sh),
  8656 Zeilen; Eindeutigkeits-Riegel weiter NUR Shell. Dauerposten W2 (KON37-08/S-16).
- **[seg3-kon28-01, ERNST] Ledger-Marker fehlt** -- Ledger §69.6 "prod1=24 Worker" ohne
  UEBERHOLT-Vermerk (OD-7: 16). Docs-Zug.
- **HINWEISE:** SHA-Zuordnungs-Detail 9f8e2be8-vs-3ba0f7b3 (Ledger) · super build:clang
  Kill-Switch when:never + docs-only-changes (D-2-Kandidat, W2-Triage).
- **9x UEBERHOLT** sind korrekt (der Bruch ueberholt dev-Staende -- Soll-Karten waren aelter).

### 3b. W1-VOLLSTAENDIGKEITS-VORBEFUND (Owner-Zweifel 18.08. "W1 offiziell abgeschlossen -- stimmt
### das vollstaendig?"; 2 Objekt-Messungen VOR dem vollen W1-Audit, Task #93)

- **[W1-V1] KRITISCH-PLAN: #17/g2-Strang ist UNGELANDET** -- Commit 1528f6fd ("feat(measurement):
  #17 G-2-Semantik -- Redundanz-Wache der Flag-Menge als B12-Term (e)") ist NICHT Ancestor von
  ce/development 20c111c4 (merge-base-Beweis 18.08. ~15:15). P.20.1 "Welle 1 KOMPLETT" galt nur
  der Landung der 4 STRAENGE (hy-a/vl12/vl3/k2); P.20.3 fuehrte g2 als ERSTES Glied der
  Welle-2-Lande-Liste, die KON116-Landung nennt aber nur xorf+f3v+a11. #17 schliesst die
  Stempel-Strecke und gibt #7/S-19 frei (KON17-01) => Lande-/Fertigstellungs-Pflicht VOR F2.
- **[W1-V2] ERNST-PLAN: B3 Schalter-Hoheits-Umzug ohne Bau-Spur** -- OWNER-DATUM "VOR F2"
  (KON34-04; KON37-01: der Tier-Pflicht-Wurf abi_adapter.hpp:476-491 faellt): im Bruch-Worktree
  keine B3-Aenderung an abi_adapter.hpp (Treffer dort sind B14-Altbestand). Praezise Bau-Stands-
  Messung + Frist-Einordnung = W1-Audit Gruppe D.
- **VOLLES W1-AUDIT ANGESETZT (Task #93):** 8 sequentielle Pruefgruppen (Straenge+VL-3-Fixes ·
  Stempel-Strecke S-1..S-7/S-6a-d · HY-A · B-Schalter · #17/g2 · Statistik/Menge D4/D5/##10-19 ·
  Designplan-§4-W1-Testlast · Freeze-Check-Liste §18.3) + Synthese mit Frist-Dreiteilung --
  Script workflows/scripts/w1-vollstaendigkeit-wf.js, Start NACH Review- und Audit-Ruecklauf
  (Limit-Doktrin). Ergebnis wird Abschnitt 9 dieses Registers.

## 4. ENTLASTETE CODEX-BLOCKER (Scope-Artefakte des Flaechen-Zuschnitts; am Objekt gemessen)

- **[C-F1]** "7. Hybrid-Makrostelle fehlt" -- hybrid_module_abi_v1.hpp:70 EXISTIERT mit beiden
  Symbolen (:101 gattung_of((ZielGenusExpr)), :104 genus=Ziel-Genus, Weg C) -- die Datei liegt in
  der Lens-A-Flaeche, nicht im l1c-Diff.
- **[D-F7]** "Q2-Datei fehlt vollstaendig" -- tests/unit/test_q2_identitaets_riegel.cpp existiert
  (8039 B), Fixture-Tabelle prueft EXAKTE Stati (:111 alt_major7 -> status_magic_mismatch).
- **[D-F4a]** "Emitter rendert MergeStrategy" -- sota_catalog.hpp:238/:243 rendert bereits
  PrueflingVerbundStrategy (nur die D-F4b-Haelfte haelt, s. 1.2).

## 5. CLAUDE-REVIEW wf_13b562e7 -- 5a VORAB KONSOLIDIERT: die 5 Stufe-1-ERHEBER (zurueckgekehrt)

Die 5 Erheber (217 erhobene Stellen, neutral ohne Urteil) sind zurueck und wurden per
Stichwort-Scan (16 befund-verdaechtige Zustandsnotizen) gegen Abschnitt 1-3 konsolidiert.
NEU in die Liste (fehlten):

- **[E-1] ERNST (T-4-Klasse): Loader-Codes 9/10 werden nirgends real ERZEUGT** --
  test_q2_identitaets_riegel.cpp:127-136 prueft die NAME-Zuordnung von status 9/10/11; grep ueber
  tests/+libs/: die einzigen Vorkommen von status_gattung_symbol_missing/status_genus_symbol_missing
  sind die Loader-Definition selbst -- es existiert KEINE Negativ-Fixture (Modul OHNE
  gattung-/genus-Symbol), die Code 9 bzw. 10 tatsaechlich ausloest. Der neue Fehlerpfad ist
  ungefahren. FIX: 2 Negativ-Fixtures (nur-gattung-fehlt / nur-genus-fehlt) mit EXAKTER
  Status-Erwartung. -> A2.5.
- **[E-2] MITTEL (mit D-F1 buendeln): measure_parallelism-Randzellen** --
  measure_parallelism.hpp:35-53: Env "0" -> nproc (die v>0-Kante schluckt die explizite 0 still)
  und Ziffern-Akkumulation v=v*10+d OHNE Bereichsdeckel (Ueberlauf-Kandidat bei absurden Werten).
  FIX: "0" als expliziten Fehler ODER dokumentierte Semantik + Bereichs-Deckel; Tests je Zelle.
- **[E-3] HINWEIS->TRIAGE: zweiter Nenner fehlt in test_validate_profile.cpp:607-626** -- der
  Profil-Nenner deckt die stille Null des Verzeichnisses (<8 -> rot), aber bei leerem/verfehltem
  load_profiles/ bliebe `known` leer und der <workloads>-Zweig unprueft -- stille-Null-Klasse
  im Test selbst. -> A2.5-Triage.

OBJEKT-VERSTAERKUNGEN bestehender Funde (kein neuer Posten, Beleg-Zellen):
- **zu [B-F1]:** Erheber-Wahrheitstafel anatomy_fingerprint.hpp:237-250 belegt am Objekt:
  `'12=abc;44=xy' -> true` (Wert-Laenge/Hex ungeprueft), `'a==b' -> true`, `';x=1' -> true`
  (fuehrendes Semikolon passiert) -- exakt die unbewachte produktive Grammatik; :230-234 erlaubt
  ';'/'=' an JEDER Position des injizierten Vorrats.
- **zu [D-F6-Rest]:** Erheber tests:308-313 benennt die unbelegte Zelle woertlich: der
  Set-.so-Cast (nullptr-Ergebnis) wird ausgefuehrt, aber nicht gemessen.
- **zu [D-F3]:** validate_profile.hpp:294-330-Zellen: {merge leer -> ungeprueft/ok} ist die
  dokumentierte Default-Semantik (""=>Verbund2_Replace) -- die Triage prueft nur noch den
  unbekannte-Token-Ablehnpfad (Koeder "fulljoin").
- Neutral bestaetigt: Loader-Fruehreturns sauber (kein destroy noetig vor create) · decl-Pin-
  Arbeitsteilung (Designatoren/Sonde/Typ-Folge/sizeof/Gleichheits-Gate) dokumentiert · 2-arg-
  Kurzform (system, organ) mit ""-Mess-Zeile = DEKLARIERTER golden-Bruch (Lande-Notiz).

### 5b. BEWERTER + SYNTHESE ZURUECK (18.08. ~15:20; 11/11 Agenten, 0 Fehler, 980k Tokens)

**GESAMT-VERDIKT: LANDBAR_MIT_FIXES** — alle 5 Flaechen-Verdikte konvergieren unabhaengig
(loader-hybrid, fingerprint-name, pod-makros-gates, semantik-kern, tests: je LANDBAR_MIT_FIXES).
33 Findings (1 KRITISCH / 23 ERNST / 9 HINWEIS), Synthese-Fix-Liste **30 Posten**
(maschinenlesbar: ~/backups-workflow/20260818-bump15-review-audit/review-synthese-w5swesjti.json;
die Synthese hat selbst gegen die Codex-Funde DEDUPLIZIERT und Kopplungen benannt).
Kern-Begruendung: kein Fund stellt die BRUCH-SUBSTANZ in Frage (Layout 7/Format 5/GliedCount 10/
S-6a/6-Symbole+Riegel/POD 152/Budget/HY-A2+A3/work_mode/V-11R von allen Flaechen als richtig
gebaut befunden); der eine KRITISCH ist eine BEWEIS-Luecke (K13 am Kern), kein nachgewiesener
Produktionsdefekt.

**Die tragenden NEUEN/PRAEZISIERTEN Posten der 30er-Fix-Liste (Delta zu Abschnitt 1-2):**
- **KRITISCH (deckt E-1, praezisiert):** Der namensgebende Identitaets-Riegel wird von KEINEM Test
  AUSGELOEST — 3 Negativ-Fixtures als echte .so-Targets bauen (Luegner-Modul -> 11, ohne-gattung ->
  9, ohne-genus -> 10), durch den ECHTEN dlopen-Weg, mit destroy-vor-dlclose-Zaehler.
- **Fix 2 (praezisiert A-F5, Objekt-verifiziert):** gattung_of:206 defaultet unbekannte Bytes
  STILL auf Container => ZWEI Wertklassen noetig: genus_bekannt() (weist Byte 250 ab) +
  ist_abi_sichtbares_genus() (weist die verbotene 5 ab); eine allein genuegt NICHT.
- **Fix 3 (NEU):** dritte Alt-Fixture (Alt-Magic OHNE Identitaets-Symbole) pinnt die
  Loader-Reihenfolge (Magic VOR Symbol-Lookups).
- **Fix 5 (praezisiert D-F5, Objekt):** der F8-Test bindet real `(slot, nullptr, &ziel)` — der
  ANTRIEB ist nullptr gebunden, Roundtrip laeuft ueber lokalen Stack-Zeiger; toter ASSERT :134.
  Fix koppelt ZWINGEND mit dem ziel_binden-Nullpaarungs-Gate (sonst roter Zwischenstand).
- **Fix 8 (NEU):** Q2-Selbstvergleichs-Tautologie — gattung_of wird gegen sich selbst geprueft;
  unabhaengige erwartete_gattung-Spalte in die Fixture-Tabelle.
- **Fix 11 (verschaerft B-F1):** '1=x;2=y' ist als Ein- UND Zwei-Segment-Map byte-identisch =
  ZWEITE Digest-Kollisionsklasse (neben der Key-Trunkierung) => constexpr-Grammatik-Pruefer.
- **Fix 12 (NEU):** KompositMapGlied-Laengen-Wache — der Laufzeit-Weg waechst heute unbegrenzt,
  die Budget-Zusage ist am Parameter-Eingang unwahr.
- **Fix 14 (NEU):** Offset-Pins 136/144 fuer name_line/name_len in der Stamp-Tafel (die einzige
  Wache gegen gleichtypigen Feld-Tausch deckt die 2 neuen Felder nicht).
- **Fix 15+16 (praezisiert D-F3/D-F4b):** validate-Gate fuer "merge" (Verbund2_Hybrid nicht
  materialisiert) + merge_mode_to_strategy fail-closed (der Rest-Kollektor invertiert heute still
  die Semantik-Klasse von Alt-Token "fulljoin": Union -> Replace).
- **Fix 17 (NEU):** debug-Restbestaende in run_methodology_registry-Doku; profile_run_entry:956
  empfiehlt woertlich den WERFENDEN Fehlerpfad als Beispiel.
- **Fix 18 (NEU, nicht kosmetisch):** 3 stale Vor-S-6a-Ordnungs-Saetze (fingerprint:1154/:577/
  :130) — die 2-/3-arg-Ebene nimmt rohe Literale, der stale Satz ist die ANLEITUNG, nach der eine
  vierte Stelle falsch gebaut wuerde.
- **Fix 20 (NEU):** lint_layer_includes.sh deckt hybrid/ nicht — die Wache, mit der der Kommentar
  die neue Kante builder/->hybrid/ begruendet, existiert fuer diese Kante nicht.
- **Fix 21 (bestaetigt Rest):** clang-release-Vollbau+ctest am Tip VOR der Landung ist PFLICHT
  (R1 heilt einen NUR-clang-ab-O2-Fehler; genau diese Zelle ist am Tip ungemessen).
- Fix 13 (=C-F2 Typ-Folge 18->20) · Fix 6 (=A-F2 MaxDocks-static_assert) · Fix 7 (=D-F6 Set-Cast-
  else-EXPECT) · Fix 9 (=B-F2 Bereichs-Wurf) · Fix 10 (=B-F4 Deckel-Wurf) · Fixes 22-30 HINWEISE
  (Cross-Pins HeuristikAdapter/Reroute-Aritaet, Budget-Prosa maschinell, ~4600->4416,
  Test-Umbenennung At120->At152, stale Anker, Mengen-Kommentare, Overflow-Gate, (d)-Anker,
  Klassifikations-Historie).
- **9 ENTLASTUNGEN der Synthese** (deklarierte Reste bestaetigt): clang-debug-PIE vorbestehend ·
  Lock-Regen=Lande-Schritt · Stempel-Pflicht=golden-Folgezug · TABU-CRC haelt · Kern-Substanz
  richtig gebaut · (d)-prozessual-gedeckt · Overflow dormant · F8-Delegations-Proben echt ·
  V-11R-K13 vorbildlich.

### 5c. RESUME-BILANZ "failed/unvollstaendig" dieses Kontexts (Owner-Frage, gemessen 18.08. ~15:05)

18 heutige Task-Outputs geprueft: die 2 unvollstaendigen Workflows laufen BEREITS als sequentielle
Resumes (Audit wf_794b904b als wg7df0h36 · Review wf_13b562e7 als w5swesjti); w4nd6h751/wr7d5euhg/
wvphu5hjz/whrw9nqai sind Vorlaeufe DERSELBEN zwei Runs (doppelt, kein Neustart); w78hb9hii =
verwaister 0-Byte-Doppelstart des Review-Runs 04:52 (gleiche Run-ID, tot, kein Resume noetig);
4 MCP-Codex-Tasks durch Plan-B-CLI ersetzt und KOMPLETT; uebrige = abgeschlossene Bash-Tasks
(Ergebnisse konsumiert). ES GIBT KEINEN weiteren nicht-doppelten failed Workflow/Agenten.

## 6. [NACHTRAG AUSSTEHEND] VOLL-AUDIT-SYNTHESE (wf_794b904b, 688 Zusagen)

Wird nach Ruecklauf hier konsolidiert (Gesamturteil je Dimension, FEHLT/ABWEICHUNG-Liste
vollstaendig, Lande-Freigabe-Urteil); die 36 Fruehverdikte aus Abschnitt 3 werden dann gegen die
Vollmenge abgeglichen.

## 7. POSITIV-BESTAETIGUNGEN DER LENSES (fuer die Lande-Begruendung zitierfaehig)

POD 20 Felder / 8+9x16=152 @align 8 korrekt · designierte Initialisierer vollstaendig in
MESS,SYSTEM,ORGAN · 6 sichtbare Makros signatur-identisch, Fortsetzungszeilen nach der
120-Normierung intakt · Gate-Grammatik dreifach synchron auf 9 Felder (512 Formen, AUS-Laenge
3+26+8=37 nachgerechnet) · anatomy_name_hex WIRKLICH consteval + Terminierung garantiert ·
Budget-Rechnung 32+768+256+256+128+512+1536+128+64+2368+9=6057 unabhaengig nachgerechnet
(Reserve 2135 zu 8192) · Erzeuger konsistent MESS,SYSTEM,ORGAN; Format 5 / 10 Glieder /
Komposit [9] schluessig gepinnt · K-1-Sperren wirksam · Loader: alle neuen Returns entladen,
destroy VOR unload; 6 Exports extern "C" korrekt · Alt-Major-Fixtures isolieren Magic/Major
getrennt, kein ODR-Problem · Admission: Groesse 6 + Hybrid-CT-Konstante + Cross-Pin korrekt ·
3 implementierte Verbund-Strategien altsemantik-treu · 4 work_modes nutzen Release · B4-Paare
4/6 direkt geprueft.

## 8. KONSEQUENZ (Kette, Stand 18.08. nachmittags)

(1) Review-Synthese + Audit-Synthese abwarten (laufen sequentiell) -> Abschnitte 5b/6 nachziehen.
(2) **W1-VOLLSTAENDIGKEITS-AUDIT (#93)** als drittes Glied fahren (Owner-Erweiterung 18.08.;
    Vorbefunde 3b) -> Abschnitt 9.
(3) A2.5-FIX-STUFE (Fable max) im Worktree mit der GESAMTEN Fund-Liste (Abschnitte 1-3b + 5-6 + 9):
    T-1 je Fund, dreiwertige Quittung, Rekursion bis 0 neue Funde -- inkl. der W1-Rest-Posten,
    die vor F2 gehoeren (#17/g2-Landeweg, B3-Einordnung).
(4) Landung nach dem Rezept der Kontext-13-Uebergabe (5e0b7f95, Abschnitt 4) + F2-Owner-Vorlagen.

## 9. [NACHTRAG AUSSTEHEND] W1-VOLLSTAENDIGKEITS-AUDIT (Task #93)

Wird nach dem Lauf hier konsolidiert (Gesamturteil "war W1 KOMPLETT korrekt?" + Frist-Dreiteilung
offen-vor-F2 / gebaut-ungelandet / W2-deklariert / gestrichen-deklariert / unklar).
