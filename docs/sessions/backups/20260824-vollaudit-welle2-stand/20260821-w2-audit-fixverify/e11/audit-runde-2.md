# AUDIT RUNDE 2 — E-11 / C-12 FEHLERKLASSEN (Explore+Design, Staffel 2)

Auditor: Fable-max (S2-Aufgabe e11, Vollstaendigkeits-Audit VOR der Landung; zweiter Durchgang).
Datum: 2026-08-23 (abends). Objekt: die zwei Deliverables des design-only-Strangs —
- Design:   /home/comdare/backups-workflow/20260820-w2-sofortstaffel/e11-fehlerklassen-design.md (wc -l 278; mtime 2026-08-21 17:59:38 — UNVERAENDERT seit Runde 1)
- Ergebnis: /home/comdare/backups-workflow/20260820-w2-sofortstaffel/e11-fehlerklassen-design-ergebnis.md (wc -l 132; mtime 2026-08-21 18:00:24 — UNVERAENDERT seit Runde 1)

DATEINAMEN-HINWEIS (bewusste Abweichung vom Auftrags-Template): der Auftrag nennt als
Berichtsdatei `e11/audit-runde-1.md`; diese Datei EXISTIERT bereits (22.08. 06:45, 174 Z.,
Verdikt SITZT, 4 KLEIN E11-A1..A4) und ist von der aktualisierten Soll-Karte (Abschnitt VII)
ausdruecklich als abgeschlossene Runde 1 referenziert. Nach der Doku-nie-loeschen-/BU-additiv-
Doktrin wird sie NICHT ueberschrieben; dieser Bericht ist die von der Soll-Karte erwartete
ZWEITE Runde und liegt additiv als `audit-runde-2.md` daneben.

Eingang VOLL gelesen: Soll-Karte (569 Z., Fassung 23.08. 20:14, P-01..P-27 + Abschnitt VII) ·
audit-runde-1.md (174 Z.) · Design (278 Z.) · Ergebnis (132 Z.) · LEAD-ENTSCHEIDE (87 Z. voll).
Fenster wortgleich nachgelesen: W2-ABFOLGE Z.482-484/Z.654/Z.247-250/Z.288-291 · Wellenplan
Z.958-960 (V-8), Z.2479-2494 (C-12 + WIEDERAUFNAHME-MARKER 18.08.), Z.2793 (T-UPD-2),
Z.3012-3014 (##40-Restbau, "vor Sa 29.08."), Z.3588-3590 (L8, "#96 zaehlt gegen") · Designplan
Z.63-76 (T-1..T-9), Z.645-649 (T-11b/T-11c), Z.676 (T-12c ARENA "E11" = fremder Nummernraum) ·
GOAL v8 Z.139-141 (T-1..T-9 bindend, nur V-1..V-7 genannt), II.5/II.6/II.7 (Z.288-308), TEIL-IV-
Kopf (Z.353, fremdes Kapitel), allow_failure-MARKER-Fenster (Z.736-750) · Ledger: Kopf-Schichten
(NACHTRAG-zu-KON120-02 22.08. nachm. > KON121 > KON120-07 > KON120; Ledger-mtime 22.08. 14:09,
KEIN KON122; Kopf-Grep Z.1-200 nach fehlerklass|C-12|T-13|T-14|E-11|axis_error|FK-3|FK-6|
CompoundSystemAxis|golden-Zug = 0 Treffer), Z.16969 (Owner-Direktive 17.07. verbatim), Z.22192
(drei Klassen (a)/(b)/(c) verbatim), Z.22202 (A15/FK-0-Praezisierung), Z.23747-23748 (RF-3
GEBAUT), Z.23795 (SUPERSEDE-VERMERK verbatim) · STAFFEL2-SYNTHESE Z.26 (Status-Tafel e11),
Z.206-208 (F-116..F-118), Z.251 (O-E OG-54), Z.280-292 (5.2 golden-Zug), Z.42-72 (H-9..H-12) ·
STAFFEL1-SYNTHESE: Grep nach e11|E-11|fehlerklass|T-13|T-14|C-12 = 0 Treffer (kein
F-01..F-77-Posten beruehrt diesen Strang).

Objekt-Stand der eigenen Gegenproben (ce-Hauptklon, NUR LESEN — ausschliesslich git show/log/
diff/grep/ls-tree/merge-base/cat-file): origin/development HEAD = **3841d717** (23.08. 13:50,
"fix(ci): CI-16095-Heilung Teil 4") — identisch zur Soll-Karten-Messung, KEINE weitere Drift
seit deren Fassung. Kein e11-Zweig (`git branch -a | grep -iE "e11|fehlerklass"` liefert NUR
`bau/a15-fk3-fk4-fehlerklassen`; `git merge-base --is-ancestor` bestaetigt: Ahne von
origin/development = gelandeter Alt-Zweig 07.08.), kein e11-Worktree (grep ueber
`git worktree list` leer, RC=1). Kein Bau, kein Bau-Slot benoetigt (design-only-Audit).

VERDIKT: **SITZT** (0 ERNST, 0 MILD, 4 KLEIN — davon 3 unveraenderte Runde-1-Wiedervorlagen
und 1 neuer Doku-Punkt; E11-A2 aus Runde 1 ist am Objekt ERLEDIGT, s. Abschnitt 3).

--------------------------------------------------------------------------------
## 1. PUNKT-FUER-PUNKT-TAFEL (P-01..P-27 der Soll-Karten-Fassung 23.08., dreiwertig)

| P | Urteil | Beleg (Literal, eigene Messung dieser Runde) |
|---|--------|-----------------|
| P-01 Explore+Design JETZT, Bau spaeter | **ERFUELLT** | LEAD-ENTSCHEIDE Z.24-27 wortgleich nachgelesen ("E-11 faehrt deshalb JETZT als Explore+Design (Staffel 2), der Bau als eigener golden-Ereignis-Zug danach — nie nebenbei in einer Parallel-Staffel"). Objekt-Beweis heute: kein e11-Branch, kein e11-Worktree (s. Kopf); die 4 geplanten Neubauten fehlen am HEAD (`git cat-file -e` je Datei: `axis_error_traits_sub.hpp`, `axis_error_traits_registry.hpp`, `test_t13_fk3_walk_compound.cpp`, `test_t14_unterachsen_algorithmen.cpp` — alle 4 "fehlt (soll)"). Ergebnis Z.3 + Z.127-129 behaupten exakt das. |
| P-02 Woertlicher Auftragsposten | **ERFUELLT** | W2-ABFOLGE Z.482-484 wortgleich nachgelesen ("**E-11 C-12 FEHLERKLASSEN-PFLICHT** T-13/T-14 (0/18 bzw. 0/121; T-UPD-2: Kollision zugunsten C-12 aufgeloest; VOR W3 PFLICHT). ... ABNAHME: Abdeckung >0/18 und >0/121 gemessen."); Design Z.8-9 zitiert sinn- und zahlengleich. |
| P-03 Owner-Mandat 17.07. | **ERFUELLT** — mit KLEIN-Fund E11-B1 (expliziter (a)/(b)/(c)-Abgleich fehlt in der Design-Prosa) | Ledger Z.16969 verbatim ("Fehlerklassen und Behandlung sind für alle Achsen → Unterachsen → ...") + Z.22192 mit den drei Klassen (a) HW-/Erweiterungs-Fehlen, (b) Compile-Fehler einer Achsen-Kombination, (c) Runtime-Algo-Fehler — beide Stellen dieser Runde wortgleich gelesen. Objekt: `axis_error.hpp:4-5` traegt die Direktive wortgleich (git show am HEAD, Literal oben). Design Z.12-13 zitiert Direktive+Anker. Substanz-Deckung der drei Klassen ist IMPLIZIT vorhanden ((b)=FK-3/Familien-Raeume Config-Realm, (c)=FK-5/FK-6-Ebene, (a)=P3-Bindung `BetriebssystemFeatureFehlt`, RF-3 GEBAUT lt. Ledger Z.23748) — der von der Soll-Karte als Audit-Punkt markierte EXPLIZITE Dreier-Abgleich steht nicht im Design-Text: Fund E11-B1 (KLEIN). |
| P-04 T-UPD-2-Kollisionsaufloesung | **ERFUELLT** | Wellenplan Z.2793 wortgleich ("T-UPD-2 #40-Wellen-Kollision T-13/T-14 aufloesen (W7 vs vor-W3/C-12)") + WIEDERAUFNAHME-MARKER Z.2492-2494 wortgleich ("C-12/T-13/T-14 (Fehlerklassen) bleiben PFLICHT VOR W3 -- die Rutsch-/W7-Vermerke anderswo sind Historie"). Design Z.9 fuehrt die Aufloesung. |
| P-05 Frist VOR W3 / vor Sa 29.08. | **ERFUELLT fuer DIESEN Strang** (Design liegt = Strang-Abnahme lt. LEAD Z.51); Bau-Teil = GETRAGENER OFFENER POSTEN | Wellenplan Z.2481-2482 + Z.3013-3014 wortgleich ("T-13/T-14 (Fehlerklassen!) = C-12-PFLICHT VOR W3 (par.19.3 fuehrt sie schon; vor Sa 29.08.)"). Auftragsgemaesse Pruefung "golden-Zug bereits terminiert/gestartet?": **NEIN, nicht gestartet** (kein bau/e11-*-Zweig, kein Worktree, Neubauten fehlen — Literale P-01) und **ohne eigenes Datum terminiert** (LEAD Staffel-3-Liste Punkt 14 "golden-Zug E-11 (Design liegt dann)" traegt kein Datum). Heute 23.08. ⇒ **6 Kalendertage bis zur Frist Sa 29.08.**; Traeger existiert (LEAD-Liste Punkt 14 + Wellenplan-Marker) — kein neuer Fund, aber Dringlichkeits-Hinweis an die Synthese (Abschnitt 4). |
| P-06 L8-Andockung | **ERFUELLT** | Wellenplan Z.3588-3590 wortgleich ("L8 Hybrid-Parser fail-closed OHNE fehlerklasse=-Traeger ... an T-13/T-14-Fehlerklassen-Posten angedockt ...; #96 zaehlt gegen."). Design 5.5 (P5) liefert die Andockung als Totalabbildung + Meldungsform; Objekt-Gegenprobe s. P-14. |
| P-07 IST-Karte je FK-Ebene gemessen | **ERFUELLT** | V-8-Wortlaut Wellenplan Z.960 nachgelesen. IST-Karte (Design Abschnitt 1, 7 Ebenen-Zeilen mit Datei-Ankern) diese Runde am HEAD 3841d717 NEU gemessen: Direktive `axis_error.hpp:4-5` ✓; FK-3 = 20 Spezialisierungen (`grep -c "^struct AxisErrorTraits<"` = **20**) ✓; Handliste `test_a15_fk3_axis_error_traits.cpp:222` = `check("GENAU 20 Achsen-Familien aufgezaehlt", n == 20u);` (wortgleich) ✓; `FK3_ZAEHLE(`-Treffer 21 = 20 Aufrufe + 1 #define ✓; FK-3-Kopf "bewusst offene Luecke" :77 ✓; FK-4 `kOrganSlotCount = 18` (:67) ✓; FK-5 `error_classes()` in 18 `organ_axes/**_base.hpp` (git grep -l = **18**) ✓; FK-6 `kAllRegisteredOrganVariantCount` CT via `mp::mp_size<AllRegisteredOrganVariantsFlat>` (:167) + `guard_all_registered_organ_error_classes` (:196) + static_assert ==18 (:157) ✓; Uebergangsliste `std::array<std::string_view, 0>{}` (:152) ✓. |
| P-08 Nenner-fremd-Pflicht | **ERFUELLT** | Designplan T-3 Z.69 wortgleich nachgelesen. Design 5.2 ersetzt `n == 20u` durch `n == kGebundeneAchsenFamilienZahl` ("Nenner fremd, aus dem Header"); 5.4 Wache `>= 121` statt `== 121`/`== 126`; Abschnitt 2 "V0-BAUAUFLAGE: ... nie den Nenner 18 im Test hart verdrahten (Nenner-fremd-Regel)". Deckt auch GOAL II.5 ("Nenner in die AUSGABE zwingen" — Druckform `[T-14] <name> = <zahl> / <nenner>`). |
| P-09 Nenner-Korrektur 121→126 als Messung | **ERFUELLT als dokumentierte Messung; die Zahl 126 selbst = Bau-Tag-Literal** (ohne Bau nicht druckbar — auftragsgemaess) | CT-Quelle am HEAD verifiziert: `axis_variant_version_table.hpp:167` `inline constexpr std::size_t kAllRegisteredOrganVariantCount = mp::mp_size<AllRegisteredOrganVariantsFlat>::value;` (nicht hartverdrahtet; daneben :157 static_assert ==18 fuer die FAMILIEN-Liste — Design haelt beide getrennt). Unabhaengige Zweitmessung der 126 existiert weiterhin NICHT in den Plan-Quellen (Soll-Karten-Spannung #4 bleibt getragen); Design deklariert Herkunft ("FK-6-Header, gemessen 09.08.") und plant den Druck am Bau-Tag — genau die richtige Form. |
| P-10 P1 CompoundSystemAxis Nr. 21 | **ERFUELLT (als Bauplan)** — Prosa-Praezisierung E11-A4 weiterhin offen | Objekt am HEAD: `ceb_complex_system_axis.hpp:76-78` = `template <class TargetIsaComplex, class OperatingSystem, class ExternalUtils, class SubAxes> struct CompoundSystemAxis` — **VIER** Template-Parameter (Literal oben); 0 Traits-Eintraege (`grep -c "AxisErrorTraits<CompoundSystemAxis"` in axis_error_traits.hpp = **0**, RC=1). Design 5.1 (Fehlerraum = Union der Glieder-Raeume, domains={D1}, keine neuen Klassen) steht; die 3-Parameter-Kurzform der Prosa (Z.94) ist unveraendert = Fund E11-A4 (Wiedervorlage). |
| P-11 P2 Walk statt Handliste | **ERFUELLT (als Bauplan)** | `axis_error_traits_registry.hpp` existiert NICHT am HEAD (cat-file-Probe, soll) ✓; `kSystemAxisOrder` ist NAMENS-Ordnung mit exakt 3 Eintraegen (`include/cache_engine/abi/system_axis_order.hpp:42-46`: "target_isa", "operating_system", "external_utils" — diese Runde wortgleich gelesen) ⇒ Begruendung "keine walkbare Typ-Registry am Objekt" haelt. Negativ-Probe (Wegwerf-Typ ohne Listen-Eintrag) in 5.2/5.6 ausgeplant. |
| P-12 P3 Unterachsen-Blaetter + Verfeinerungs-Wache | **ERFUELLT (als Bauplan)**, 18-vs-19 korrekt OFFEN | `axis_error_traits_sub.hpp` fehlt (soll) ✓; Kandidat 19 existiert (`git grep -c "struct DefaultSchedulingSystemAxis final"` in system_axes/ = 1 Datei) ✓; `system_axis_order.hpp:21` wortgleich: "scheduling wird Unter-Achse (sub_axis) des target_isa-Komplex-Wrappers (Schritt 6)." ✓; RF-3-Klasse existiert (Ledger Z.23748: "RF-3 ist GEBAUT ... `BetriebssystemFeatureFehlt` in `measurement/axis_error.hpp:50`") ✓. Design verdrahtet den Nenner bewusst NICHT (Ergebnis Z.130-131 "Nenner-Messung 18 vs. 19" als Bau-Vorbedingung). |
| P-13 P4 vier gezaehlte, gedruckte Groessen | **ERFUELLT (als Bauplan)** | Zaehler A-D vollstaendig benannt (Design 5.4) mit Objekt-Ankern am HEAD: A `kAllRegisteredOrganVariantCount` (:167) ✓, C/D `kAlgoFehlerraumUebergangsliste`-Laenge 0 (:152) ✓; Druckform `[T-14] <name> = <zahl> / <nenner>`; `test_t14_unterachsen_algorithmen.cpp` fehlt (soll) ✓. |
| P-14 P5 Hybrid-Status → fehlerklasse= | **ERFUELLT (als Bauplan)** — exakter Enum-Header diese Runde GELESEN (Soll-Karten-Auflage erfuellt, kein Zeilenbereichs-Grep) | `hybrid_dock_contract.hpp:78-127` im Wortlaut: **16 Codes, Werte 0..15 lueckenlos** (`hybrid_status_ok = 0` :80 … `hybrid_status_rt_ct_wert_differiert = 15` :119; von mir einzeln gezaehlt: ok, unbekannter_vertrag, contract_ohne_dock_typ, kein_zielfaehiges_genus, array_voll, slot_leer, xml_nicht_wohlgeformt, unbekanntes_token, max_docks_ungueltig, mehr_docks_als_deckel, max_docks_fehlt, genus_fehlt, bindung_inkonsistent, rt_bindung_unvollstaendig, rt_ct_key_fehlt, rt_ct_wert_differiert = 16); Registry `std::array<int, 16> kAlleHybridStatus{` ab :125 ✓ — Design-Anker ":80-119"/":125" stimmen aufs Zeichen. 5.5-Zuordnung TOTAL: 1 (ok="") + 2 (max_docks_fehlt=10, genus_fehlt=11 → konfiguration_unvollstaendig) + 13 (→ konfiguration_widerspruch) = 16/16; Abnahme-Beispiel "fehlerklasse=konfiguration_unvollstaendig hybrid_status=11" konsistent (11 = genus_fehlt :100-102). `fehlerklasse=`-Traeger am HEAD: git grep = **57 Stellen in 23 Dateien** ⇒ ">40 Stellen" haelt. Parser nutzt die Codes (17 `hybrid_status_`-Treffer in hybrid_config_xml.hpp). Status-Home-Doktrin am Objekt :84-85 ("EINE Status-Heimat"). |
| P-15 T-1 ROT ZUERST | **ERFUELLT als Plan** (vor Bau nicht erfuellbar — korrekt deklariert) | Designplan Z.67 wortgleich; Design 5.6(c) "(T-1: ROT-zuerst per Wegwerf-Mutation im Bau-Protokoll belegen)" + Abschnitt 8 "TUs (je Posten ROT-zuerst)". |
| P-16 T-7 Registrierung | **ERFUELLT als Plan** | Designplan Z.73 wortgleich; Design 5.6 "PFLICHTEN je neuer TU: T-7-Registrierung (CMakeLists-ENDE)". |
| P-17 T-11c Mutations-Protokoll | **ERFUELLT als Plan** | Designplan Z.647-649 wortgleich (inkl. "je neuem Test >=1 Wegwerf-Mutation mit literalem Rot + Gegenprobe-Gruen"); Design Z.204-205 "T-11c-Mutation (je TU eine dokumentierte Wegwerf-Mutation, die sie rot macht)". |
| P-18 T-11b Kombibau-2x2 | **ERFUELLT als Plan** | Designplan Z.645-646 wortgleich; Design Z.205 "Debug+Release-Lauf, gcc+clang" + Abschnitt 6 Punkt 5 ("ctest-Vollzahl Debug+Release, gcc+clang (K17)") + Abschnitt 8 volle Bau-Treppe (J-1 → RE-CONFIGURE → all → Facade → comdare_tests → ctest --no-tests=error) — deckungsgleich mit den Auftrags-REGELN. |
| P-19 CMakeLists NUR ans DATEIENDE | **ERFUELLT als Plan** | Design Z.189 fuehrt die Regel explizit in der 5.6-Ueberschrift. |
| P-20 Golden-Neutralitaets-Beweis (5 Belege) | **ERFUELLT als Plan** | Design Abschnitt 6 traegt alle 5 Beweispflichten (diff-Pfadliste, Overlay-Hash vorher==nachher, Lock byte-identisch, golden_fullpilot_320* byte-identisch + TABU-Gate [6/6], ctest-Vollzahl 2x2). Objekt-Grundlage diese Runde: `builder/overlay_source_set.hpp` existiert am HEAD (cat-file OK); Neubauten liegen in measurement/, hybrid/, tests/unit/ — ausserhalb des Overlay-Schnitts (Runde-1-Detailprobe P-15 dort; Schnittmenge unveraendert, da die Datei im Drift-Diff nicht auftaucht). |
| P-21 TABU-Wahrung WAEHREND des Strangs | **ERFUELLT** | Kein Commit/Branch/Worktree dieses Strangs (Literale P-01) ⇒ axes/topics/heuristik/golden/.gitlab-ci.yml nachweislich unberuehrt. |
| P-22 Supersede-Praezedenz "KEINE Parallelstruktur" fuer jetzt 4 externe Header | **ERFUELLT — diese Runde vom Audit SELBST GEPRUEFT statt uebernommen** | Massstab Ledger Z.23795 wortgleich gelesen ("Das TABU bleibt sinngemaess gewahrt: der Traits-Header bindet **bestehende** Achsen-Typen an die **bestehende** Taxonomie ... er baut keine zweite Fehler-Welt daneben"; ausdruecklich inkl. "externe Vollstaendigkeits-Wache ... K5-Factory-Muster"). Architektur-Pruefung der 2 NEUEN Header: (1) `axis_error_traits_registry.hpp` = CT-Typliste + Walk UEBER die bestehende `AxisErrorTraits`-Bindung — exakt die im Supersede-Vermerk selbst genannte externe Vollstaendigkeits-Wache, keine zweite Fehler-Welt; (2) `axis_error_traits_sub.hpp` = Voll-Spezialisierungen des BESTEHENDEN Primaer-Templates fuer BESTEHENDE Blatt-Typen an die BESTEHENDE Taxonomie (Design 5.3: "KEINE neuen Enum-Werte noetig"; Verfeinerung erhaelt Familien-Boden per V2-Wache; system_axes/ byte-stabil). BEIDE konform. KORREKTUR zur Soll-Karte: das Design zitiert den Supersede-Vermerk sehr wohl (Design Z.138 "exakt das Supersede-Muster Ledger Z.23618: externe Bindung, Achsen-Header unangetastet, golden-neutral"; Ergebnis Z.100-101 ebenso) — nur mit der vor-Drift-Zeilennummer 23618 (heute 23795, Ledger-Kopfwachstum; kein Fund). Offen bleibt allein, dass die TABU-Frage nicht ausdruecklich je NEUEM Header wiederholt wird — durch die hiesige Pruefung materiell geschlossen. |
| P-23 Disjunktheit | **ERFUELLT** | Design Abschnitt 10 (beruehrte Flaechen + Ausschlussliste + "axis_variant_version_table.hpp NUR GELESEN" + Harmonisierungs-Klausel "Zaehlwerke EINMAL live messen, nie Deltas"). Gegenprobe: STAFFEL2 H-9..H-12 (Z.46-72) fuehren KEINE e11-Flaeche; Status-Tafel Z.26 "kein Branch". Der Drift-Diff 66de5c09..3841d717 ueber alle 9 e11-Touchpoints ist LEER (Literal unten, Zusatz d) — kein Parallelstrang hat die Flaeche beruehrt. |
| P-24 Deckung F-116/F-117/F-118 | **ERFUELLT** | STAFFEL2 Z.206-208 wortgleich gelesen: F-116 "DOKUMENTIERT + DESIGN liegt (P1-P5)", F-117 "OFFEN -- DESIGN P5", F-118 "DOKUMENTIERT (entschaerft den golden-Ereignis-Charakter)" — deckungsgleich mit Design Abschnitte 1-3; keine dritte unabhaengige 126-Quelle (Spannung #4 bleibt korrekt getragen). |
| P-25 OG-54 als Owner-Frage ausserhalb | **ERFUELLT** | W2-ABFOLGE Z.654 wortgleich ("OG-54 E-11 Q10.3 eigenes Hybrid-Kennzeichen im System-Stempel-Array? QUELLE K4:TEIL3/3b."); Design Abschnitt 9 erster Punkt ("OWNER-FRAGE, Vorlage-Zeile ... kein Bau"); STAFFEL2 Z.251 konsistent. |
| P-26 ASCII-only in neuen Zeilen | **n/a — korrekt** | Kein Repo-File von diesem Strang angelegt/geaendert (P-01/P-21); die Markdown-Deliverables liegen ausserhalb der Repos (typografische Nicht-ASCII-Zeichen dort von Runde 1 inventarisiert; Regel greift erst am kuenftigen Bau-Code). |
| P-27 Nur-Lesen am Hauptklon | **ERFUELLT — auch fuer DIESE Runde** | Saemtliche Gegenproben dieser Runde ausschliesslich `git log/branch/worktree/diff/show/grep/ls-tree/ls-files/merge-base/cat-file` + `ls/stat/sed/grep` (kein fetch, kein checkout, kein Schreiben; auch kein Bau-Slot gezogen, da kein Vollbau noetig). |

## 2. ZUSATZPRUEFUNGEN

**(a) TDD-Vertrag je neuem Test:** unveraendert zu Runde 1 — der Strang hat auftragsgemaess
KEINE Tests gebaut (die 4 Neubauten fehlen am HEAD, Literal P-01). Fuer die 2 GEPLANTEN TUs sind
T-1 (5.6a/Abschnitt 8), T-3 (alle Nenner fremd: `kGebundeneAchsenFamilienZahl`,
`kAllRegisteredOrganVariantCount`, Registry-Messung 18/19), T-4 (drei Gegeneingaenge: Wegwerf-Typ
ohne Traits, Listen-fremder Traits-Traeger, Wegwerf-Blatt ohne Familien-Boden), T-7
(CMakeLists-ENDE), T-11b (2x2-Matrix) und T-11c (je TU eine Wegwerf-Mutation) vollstaendig als
Pflichten verankert. Kein Delta.

**(b) GOAL-Doktrinen:** allow_failure — kein YAML-Touch (kein Commit existiert); die
JOB-Ebene-Verbots-Doktrin (GOAL-Fenster Z.736-750, MARKER 16./17.08. diese Runde nachgelesen)
ist nicht beruehrt. TABU-Zonen — nachweislich unberuehrt (P-21). Ledger-Verbot — beide
Deliverables schreiben keinen Ledger; Design Z.268 "Ledger schreibt NUR der Lead". ASCII — n/a
(P-26). GOAL-II.5/II.6/II.7 (Nenner in der Ausgabe / Koeder beisst / fail-closed) sind im Design
substanziell gedeckt (Druckformen 5.4, T-11c-Mutationen 5.6, P5-Totalitaets-Wache "jede Zeile von
kAlleHybridStatus hat genau einen Eintrag"). GOAL-TEIL-IV ("DIE FEHLERKLASSE, DIE KEIN SIGNAL
ERZEUGT", Kopf Z.353 gelesen) = fremdes Methodik-Kapitel, korrekt NICHT als E-11-Quelle verwendet.

**(c) Abnahme-Formeln woertlich:** Die Auftrags-Formel "Abdeckung >0/18 und >0/121 gemessen"
(W2-ABFOLGE Z.484) ist durch Design Abschnitt 7 vollstaendig operationalisiert (18/18 bzw. 19/19;
eigene_saetze 1/126 + wirksamer_fehlerraum 126/126 + Registry-Zeile "126 >= 121"; T-13 21/21-Walk
+ Compound-OK; L8 16/16 + gerenderte Beispielmeldung — Kreuzprobe Status 11 diese Runde erneut
konsistent). Die Nenner-Umdeutung 121→126 bleibt sauber als dokumentierte Korrektur mitgefuehrt
(Spannung #4; ">=121"-Wache erhaelt die woertliche Untergrenze). Strang-Abnahme selbst (Formel 6
der Soll-Karte): "Design liegt" — erfuellt, beide Deliverables liegen unveraendert vor.

**(d) Bericht-Behauptungen am Objekt (Stichproben dieser Runde, Zahlen mit Nenner, alle am
HEAD 3841d717):** Drift-Kernprobe `git diff --stat 66de5c09..3841d717` ueber ALLE 9 vom Design
beruehrten/gelesenen Bestandsdateien (axis_error, axis_error_traits, axis_error_traits_organ,
ceb_complex_system_axis, organ_axis_error_classes, dock_error_classification,
axis_variant_version_table, hybrid_dock_contract, hybrid_config_xml) = **LEER** (RC=0, keine
Ausgabe) — die IST-Karte haelt am heutigen HEAD unveraendert, trotz 41 Commits (13 first-parent)
im Bereich · Handliste n==20u BESTAETIGT (wortgleiche Zeile :222) · 20 FK-3-Spezialisierungen
BESTAETIGT (20) · Compound 4 Template-Parameter + 0 Traits BESTAETIGT · kOrganSlotCount=18
BESTAETIGT (:67) · 18/18 error_classes()-Basen BESTAETIGT (git grep -l = 18) · Uebergangsliste
Laenge 0 BESTAETIGT (:152) · 16 Hybrid-Codes 0..15 + Registry array<int,16> BESTAETIGT (exakter
Header-Wortlaut) · fehlerklasse= 57 Stellen / 23 Dateien gegen ">40" BESTAETIGT ·
kSystemAxisOrder 3 Namens-Eintraege BESTAETIGT (:42-46) · DefaultSchedulingSystemAxis existiert
BESTAETIGT · system_axis_order.hpp:21 wortgleich BESTAETIGT · 10-TU-Testbestand des Designs:
alle 10 existieren am HEAD (je cat-file OK) · Alt-Zweig bau/a15-fk3-fk4-fehlerklassen = Ahne von
development BESTAETIGT. Abweichungen: nur die Funde unten.

## 3. FUNDE (nur echte Deltas; E11-A1..A4-Nummern aus Runde 1 fortgefuehrt)

### E11-A1 (KLEIN, WIEDERVORLAGE aus Runde 1 — UNBEHOBEN) — Eskalations-Anker-Zeile falsch: source_catalog.hpp":191" ist real :204
Design Z.225-226 unveraendert ("Bekannte Anker-Orte: kNewGolden131072Crc64 (source_catalog.hpp:191)");
Objekt am HEAD: Definition `profile_facade/source_catalog.hpp:204`
(`inline constexpr std::uint64_t kNewGolden131072Crc64 = 0x56F1B721C72DC10EULL;`), Protokoll-Anker
in Kommentaren :188/:201 (diese Runde neu gemessen, identisch zu Runde 1). Wirkung unveraendert
klein (nur die heute nicht geplante F6-Eskalations-Sektion; Symbol-Grep eindeutig).
**fix_weg:** e11-fehlerklassen-design.md Abschnitt 6 ESKALATION, Z.225: "(source_catalog.hpp:191)"
→ "(profile_facade/source_catalog.hpp:204; Protokoll-Anker :188/:201)" — 1-Zeilen-Edit; Traeger
unveraendert: V0-Gegenlese des golden-Zugs (dort ohnehin Ablese-Pflicht) oder Lead-Doku-Mikro-Edit.

### E11-A3 (KLEIN, WIEDERVORLAGE aus Runde 1 — UNBEHOBEN) — Ergebnis-Inventur 8 statt 10 TUs
Ergebnis Abschnitt 1 (5 TUs) + WIEDERANLAUF-KORREKTUR (+3) = 8; der massgebliche
Design-"Test-Bestand (vollstaendig)" (Design Z.32-35) fuehrt 10 — es fehlen in der
Ergebnis-Inventur `test_a15_fk4_organ_slot_traits.cpp` und `test_hy_a3_hybrid_config_parser.cpp`;
beide existieren am HEAD (cat-file OK, s. Zusatz d). Reine Berichts-Inkonsistenz, kein Bau-Einfluss.
**fix_weg:** e11-fehlerklassen-design-ergebnis.md, KORREKTUR-Absatz (nach Z.65) um den Halbsatz
ergaenzen: "zusaetzlich gehoeren test_a15_fk4_organ_slot_traits.cpp und
test_hy_a3_hybrid_config_parser.cpp zum FK-Testbestand (vollstaendige 10er-Liste: Design
Abschnitt 1)." — 1 Edit; Traeger wie A1.

### E11-A4 (KLEIN, WIEDERVORLAGE aus Runde 1 — UNBEHOBEN) — P1-Prosa-Signatur 3 statt 4 Template-Parameter
Design Z.94 unveraendert (`AxisErrorTraits<CompoundSystemAxis<IsaK, OsA, ExtU>>`); Objekt am HEAD:
VIER Parameter (`TargetIsaComplex, OperatingSystem, ExternalUtils, SubAxes`,
ceb_complex_system_axis.hpp:76-78, Literal in P-10). Risiko unveraendert: eine woertlich
uebernommene 3-Parameter-Teilspezialisierung waere ein STILLER Non-Match gegen die 4-Parameter-
Primaervorlage (Spezialisierung greift nie, kein Compile-Fehler); die geplante T-13-TU wuerde es
fangen, die Prosa sollte es nicht erst dem Test ueberlassen.
**fix_weg:** e11-fehlerklassen-design.md Z.94: Signatur auf
`AxisErrorTraits<CompoundSystemAxis<IsaK, OsA, ExtU, SubAxes>>` praezisieren (vierter Parameter
frei mitgefuehrt) — 1-Zeilen-Edit; zusaetzlich am Bau-Tag in der neuen T-13-TU die
4-Parameter-Form invariant pruefen (Design 5.6(b) deckt das bereits).

### E11-B1 (KLEIN, NEU in Runde 2) — expliziter (a)/(b)/(c)-Owner-Klassen-Abgleich fehlt in der Design-Prosa
Die Owner-Direktive operationalisiert DREI Klassen ((a) Hardware-/Erweiterungs-Fehlen, (b)
Compile-Fehler einer Achsen-Kombination, (c) Runtime-Algo-Fehler — Ledger Z.22192, diese Runde
verbatim gelesen). Das Design deckt alle drei SUBSTANZIELL (b = FK-3-Familien-Raeume/Config-Realm
inkl. P1-Union; c = FK-5/FK-6-Strecke inkl. P4-Messnachweis; a = P3-Bindung
`BetriebssystemFeatureFehlt` an die OS-Subs, RF-3-Klasse existiert), fuehrt die Dreier-Liste aber
nirgends explizit als Abgleich zurueck — die Soll-Karte (P-03) markiert genau das als Audit-Punkt.
Ohne den expliziten Abgleich muss jeder spaetere Pruefer die Zuordnung neu herleiten.
**fix_weg:** e11-fehlerklassen-design.md, Abschnitt 4 (oder Ende Abschnitt 2), DREI Zeilen
ergaenzen: "Owner-Klassen-Abgleich: (a) HW-/Erweiterungs-Fehlen → P3
(`BetriebssystemFeatureFehlt`-Bindung der OS-Subs; Producer C-3a-gebunden, Abschnitt 9); (b)
Compile-Fehler einer Achsen-Kombination → P1/P2 (D1-Config-Realm der Familien-Raeume); (c)
Runtime-Algo-Fehler → P4 (FK-5/FK-6-Messstrecke)." — Doku-Edit im Deliverable; Traeger:
V0-Gegenlese des golden-Zugs oder Lead-Doku-Mikro-Edit (dieselbe Klasse wie E11-A1/A3/A4).

### E11-A2 — am Objekt ERLEDIGT (kein offener Fund mehr; Statuswechsel seit Runde 1 und seit der Soll-Karten-Fassung)
Runde 1 monierte: die von Design Z.81/Ergebnis Z.104 zitierte Quelle
`docs/plaene/20260819-F6-TERMINIERUNG-golden-ereignis-ein-zug-vor-f2.md` existiere im
super-Hauptklon nicht; Traeger-Commit `6fe69057` dort kein gueltiges Objekt ("Bruch-Worktree").
BEFUND DIESER RUNDE: die Datei ist im **ce**-Hauptklon GETRACKT und liegt im Baum von
origin/development — Literale: `git ls-files docs/plaene/ | grep -i F6-TERMINIERUNG` (im ce) =
`docs/plaene/20260819-F6-TERMINIERUNG-golden-ereignis-ein-zug-vor-f2.md`; `git cat-file -e
origin/development:docs/plaene/20260819-F6-...md` = OK; Traeger-Commits `6fe69057` (19.08. 17:08,
"fix(a25-f2): G6/F6 -- Terminierungs-Notiz: golden-Ereignis als EIN Zug VOR F2") + `8cd32a0d`
(ASCII-Nachzug) sind BEIDE per `git merge-base --is-ancestor` bewiesene Ahnen von
origin/development. Der Design-Pfad (ohne Repo-Praefix, in einem ce-bezogenen Design) loest damit
sauber gegen den ce-Baum auf; im super existiert die Datei weiterhin nicht (ls + git ls-files
leer — der 6fe69057 war von je her ein CE-Commit, Runde 1 hatte ihn im super-Objektbestand
gesucht). Der Lead-seitige fix_weg-(2)-Posten aus Runde 1 (F6-Notiz-Landung) ist damit VOLLZOGEN;
der Design-Text braucht KEINE Aenderung. Die Soll-Karten-Aussage (Abschnitt VII), alle vier
Runde-1-Funde seien "weiterhin unbehoben", ist fuer A2 in der Substanz ueberholt (fuer A1/A3/A4
korrekt).

## 4. GETRAGENE OFFENE POSTEN (KEINE neuen Funde — Traeger existiert; fuer die Synthese)
- **golden-Zug E-11 (der eigentliche Bau P1-P5): NICHT GESTARTET, OHNE eigenes Datum.**
  Traeger: LEAD Staffel-3-Liste Punkt 14 + Wellenplan-Marker; Frist-Marken "VOR W3" und
  "vor Sa 29.08." (Wellenplan Z.3014/Z.3589-3590). **Heute 23.08. ⇒ 6 Kalendertage Rest.**
  Dringlichkeits-Hinweis, kein Fund (Auftragslage dieses Strangs war design-only).
- F-116 (Nenner 126 / 18-19 / Handliste / Compound) — DOKUMENTIERT + DESIGN P1-P5; Traeger
  golden-Zug E-11.
- F-117 (L8 fehlerklasse=-Bindung) — OFFEN, DESIGN P5; Traeger golden-Zug E-11; "#96 zaehlt
  gegen" (Wellenplan Z.3590).
- F-118 (golden-Scope-Neutralitaetsbeweis) — DOKUMENTIERT; Traeger Bau-Zug-Beweispflichten.
- OG-54 / Q10.3 — Owner-Vorlage-Zeile (F2-Vorlagen-Fenster), kein Bau.
- Spannung #4 (126 ohne unabhaengige Zweitmessung in Plan-Quellen) — getragen durch die
  Bau-Tag-Druckpflicht (Design 5.4) + ">=121"-Untergrenze.
- Frist-Doppelmarke + datumslose Staffel-3-Platzierung — Terminfuehrung beim Lead/Staffel-3-
  Planer (s. erster Punkt).

## 5. NOTIZEN (kein Fund; Praezisierungen an den EINGANGS-Quellen fuer die Synthese)
- **Soll-Karte "5 dazwischenliegende Commits":** der Drift-Bereich 66de5c09..3841d717 traegt
  real **41 Commits (13 first-parent)**; die 5 in der Soll-Karte genannten SHAs (85a67b08,
  9da4d21d, 6713156b, 3149c8a2, 1d38263b) liegen alle im Bereich (je merge-base-verifiziert),
  sind aber eine Teilmenge. Die MATERIELLE Kernaussage (Diff ueber die 9 e11-Dateien LEER) ist
  davon unberuehrt und wurde von mir unabhaengig bestaetigt.
- **Soll-Karte P-22 "zitiert aber NICHT den Ledger-Supersede-Vermerk selbst":** ungenau — Design
  Z.138 und Ergebnis Z.100-101 zitieren das "Supersede-Muster Ledger Z.23618" ausdruecklich
  (vor-Drift-Zeilennummer des heutigen Z.23795). Der berechtigte Kern (TABU-Frage nicht je neuem
  Header wiederholt) ist durch die P-22-Pruefung dieser Runde materiell geschlossen.
- **Soll-Karte Abschnitt VII zu E11-A2** ("weiterhin unbehoben"): in der Substanz ueberholt —
  s. Fund-Abschnitt E11-A2 (F6-Notiz im ce gelandet); die Karte hatte, wie Runde 1, nur den
  super-Baum geprueft.
- Ledger-Kopf unveraendert seit 22.08. 14:09 (kein KON122); Kopf-Schichten (NACHTRAG-zu-KON120-02,
  KON121, KON120-07, KON120) tragen 0 E-11-relevante Treffer — die juengste einschlaegige
  Ledger-Schicht bleibt die A15/FK-Kette + WIEDERAUFNAHME-MARKER 18.08. (deckt die
  Soll-Karten-Behauptung).
- Ledger-Zeilennummern-Drift der Deliverable-Zitate (22031→16969/22192, 23618→23795 usw.) bleibt
  reines Kopfwachstums-Artefakt; alle Inhalte wortgleich auffindbar (je diese Runde verifiziert).
- Zeilenzahl-Zaehlartefakt (Soll-Karte "133 Z." Ergebnis vs. wc -l 132; letzte Zeile ohne
  Newline) unveraendert aus Runde 1.
- Die "E11"-Kuerzelkollisionen (#1: Arena-Kapazitaet Wellenplan par.19.5/Designplan T-12c Z.676;
  #2: K3-C-12 V-08R, LEAD Punkte 13/16 = GEDECKT betrifft NUR die K3-C-12) wurden diese Runde
  erneut mit Quell-Absatz gefuehrt; kein Phantom-Fund entstanden, unsere K2-C-12 bleibt korrekt
  als OFFEN (Bau aussteht) gefuehrt.

## 6. VERDIKT
**SITZT** — alle 27 Pruefpunkte der aktualisierten Soll-Karte ERFUELLT bzw. korrekt n/a
(P-26); kein ERNST, kein MILD. 4 KLEIN-Funde: E11-A1/A3/A4 (unveraenderte Runde-1-
Wiedervorlagen, Deliverable-mtimes seit 21.08. unangetastet — Behebung gehoert per
Soll-Karten-Einordnung in die V0-Gegenlese des golden-Zugs oder einen Lead-Doku-Mikro-Edit,
NICHT in diesen Nur-Lese-Audit-Strang) + E11-B1 (neu: fehlender expliziter (a)/(b)/(c)-
Owner-Klassen-Abgleich in der Design-Prosa). E11-A2 ist am Objekt ERLEDIGT (F6-Notiz im
ce-Hauptklon gelandet, Ahnenschaft literal bewiesen). Die Landefaehigkeit des design-only-
Strangs ist unveraendert gegeben; der eigentliche golden-Zug-Bau ist NICHT gestartet und traegt
die Frist Sa 29.08. (6 Tage) — Dringlichkeits-Hinweis an Lead/Staffel-3-Planung.
