# WELLENPLAN-SOLL-IST (Owner-Order 22.08., Punkt 1) — Stand 22.08.2026

Erhoben von: Subagent des Lande-Zug-Workflows (read-only; KEIN Merge/Bau/Push).
Quellen VOLL gelesen: Wellenplan 20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md
(3627/3627 Z., 12 Portionen) · Ledger-Kopf KON118-KON121 (erste 400 Z.) ·
SYNTHESE-S1-AUDIT.md + SYNTHESE-S2-AUDIT.md (~/backups-workflow/20260821-w2-audit-fixverify/)
· Task-Board #1-#131 (Live-Listing der Session).

## 0. MESSBASIS (heute selbst gemessen, merge-base/ls-remote, 22.08.)

    ce   dev  = f729b93a (lokal == origin; CI 16088 SUCCESS; Floor 524/520/518)
    super dev = 93542880 (Gitlink dirty = normal vor Bump)
    prt-art   REMOTE dev = 777fff7 (ls-remote origin) — der HAUPTKLON-Submodul-Stand
              d11781fa ist STALE (4 Commits zurueck, 18.08.); Briefing-Falle bestaetigt:
              nie gegen den eingefrorenen Store pruefen. VOR Phase 3 fetchen.
    Lande-Zweig lande/w2-s1s2 @ 61d5d139 (wt-ce-lande, porcelain leer):
              enthaelt BEREITS s19 a1b348ae + messfenster 3a746090 (Ancestor-Beweis) auf
              Basis dev f729b93a (Ancestor-Beweis).
    pinduo-Klon /home/comdare/wt-prt-pinduo: bau/pinduo @ 25bbf2e basiert AUF 777fff7
              (Ancestor-Beweis), ist NICHT in dev; B14 3710ac4c ebenfalls NICHT in dev.

Legende Status:
  G       = GELANDET (Objekt-Beleg: Ancestor-Messung heute und/oder Ledger-Kopf-CI)
  NZL-G   = NOCH ZU LANDEN, GEBAUT (Traeger = Branch/Worktree/Entwurf existiert)
  NZL-F   = NOCH ZU LANDEN, Bau/Design FEHLT (nie gebaut bzw. nur Vorstufe)
  U       = GESTRICHEN/UEBERHOLT (Marker am Ort; Wiederaufnahme-Order par.21 beachtet:
            nichts ausgebucht — U gilt NUR fuer Posten mit Marker/Owner-Deckung)
  C       = Kategorie C: bleibt per Owner-Wort nach Abgabe (par.21.6; zaehlt als offen)

"heute gemessen" = git merge-base --is-ancestor am 22.08. durch diesen Agenten.

---

## 1. W-1 / W0a / W0b (Sa 08.08.–Di 18.08., F1) — TAFEL

| Posten | Status | Beleg | Traeger |
|---|---|---|---|
| ##01–##03 + ##04/##05 (W-1-Landung, Bauweg literal) | G | §13.1 "W-1 ABGESCHLOSSEN"; 427→431/0→53 protokolliert | — |
| D1+D1a+D1d (Bauweg-Wahrheit) | G | W-1-Paket, Koeder-Rotlaeufe protokolliert (§6/W-1) | — |
| D1c Abdeckungs-Wache (Kern) | G | W0a; #14 15751-Klasse; Vollform s.u. NZL-F | — |
| D1e/D1f/D1g | G | W0a; D1g GEMESSEN An-9 (super 41b20a16) | — |
| D2 + D2-G2 + D2-G3 + D2-G6 | G | W0a-Bogen (§4) | — |
| D2-G4 Abnahme ##06 korrigiert | G | Marker "ERLEDIGT 09.08." + Skript + Allowlist | — |
| D2-G5 Host-Klassen-Bericht + Gegenorakel | G | Marker "GEBAUT"; 4/2-namentlich (Fussnote) | — |
| D2-G1 30 gtest-Faelle sichtbar | G | ce ca6d8af1 heute gemessen ANCESTOR dev | — |
| D5-1 Perzentil-Kanon | G | W0a-Lokalspur; Freeze-Check 23.2 ERFUELLT (PK-Kanon) | — |
| ##06/##07 (korrigierte Form) | G | W0a; Job test:abnahme06-zusicherung | — |
| ##08-A Schema-Freeze Stufe 1 (+NP-23 25→32) | G | schema_freeze.hpp, Ledger:4079; NP-23 78cc75e6 | — |
| D3-7 Lauf-Marker (Kern) | G | 028684ac in development (F1-KERN) | — |
| D3-1 mess_ausbeute_wache | G | 7444d8c0; Marker-Haelfte via D3-7 | — |
| D3-2 | G | 7444d8c0; Bissprobe F10 | — |
| D3-3 persist zaehlt Zeilen (Kern) | G | 4e0b7e0d; persist_sammler.sh:305 | — |
| D3-4+D3-5 Inhalts-Gate lebender Mess-Job (OV-16) | G | ce a558e87c Test #278 — heute gemessen ANCESTOR | — |
| ##20+D3-6 anhang-Selektor beide Formen (OV-17) | G | super 6d2e3dce — heute gemessen ANCESTOR; ##20-B Doku zu | — |
| D3-8 Frische-Wache | G | W0b; Durchstich-Beleg "4 Wachen OK" (#41) | — |
| ##22 persist um *.xlsx | G | W0b | — |
| ##23 NAHT inkl. R1-Profile | G | F1-KERN "ERLEDIGT"; R1 zu via #56/Z5 (11 Profile, 0 xlsx-blind) | — |
| ##25 DURCHSTICH = F1-Lieferung | G | KON63: Messung 377503, PDF 204 S., E-18-SNAP; CI 15764/15798 | — |
| ##26 korrigierte Formel | G | W0b | — |
| ##27–##31 Nachlauf (Register/lint/parity) | G | #43: 8 W0b-/PZW-Jobs 377423–377434 success | — |
| ##21 Haelfte 1 (aktiv-Zeile/bestandslog) | G | LAG-P1 gelandet (§4-21-Zeile) | — |

## 2. W1 (17.–21.08., F2 = FREEZE) — TAFEL

| Posten | Status | Beleg | Traeger |
|---|---|---|---|
| D4a–D4d Statistik-Degeneration + success | G | Freeze-Check 23.2 ERFUELLT ST-Trio; #93 completed | — |
| D4e/D4f (f15-Summenzeile, BE-Statustyp) | G | #93-W1-Audit completed; KEINE Einzelquittung im Ledger-Kopf — Vermerk | — |
| D5-2/D5-3/D5-4 (Median-Kanon, Disposition, delete_p99) | G | 23.2 ERFUELLT PK-Kanon/Kreuz/DeleteP99; D5-3 Marker 09.08. | — |
| ##12 configure --enable=no | G | B15 in #111 → via #113/ee8abb86 heute gemessen ANCESTOR | — |
| ##14 Sperrlisten-/Freeze-Gate | G | S-14a-Riegel #33/#35/#36; Lock-Regen = Lande-Schritt (KON119) | — |
| ##15-Kern §59-SCHEMA | G | im #15-/golden-Umfeld; EMITTER/TEMPLATE-Haelfte s.u. NZL-F | — |
| HY-A1 (Gattung 4 / Genus 6) | G | KON118: anatomy_base.hpp:89/:169, 18.08. literal bestaetigt | — |
| HY-A2/HY-A3 (Ersatzformel kGenusBuildSlotCounts 5→6) | G | par.21.0(4) im #15-Bruch nachgebaut; #15 gelandet (66de5c09 ANCESTOR heute) | — |
| S-1 Stempel-Basisklasse | G | #30: Merge 99de5b30, CI 15759 | — |
| S-3 Ordnungs-Relation (Aktivierung) | G | #4; Freeze-Check ERFUELLT | — |
| S-4 Filter-Concepts | G | implizit: #93-F2-Offenliste (23.1) fuehrt S-4 NICHT als offen; kein Einzelbeleg — Vermerk | — |
| S-5 Factory/Composite + F2-3-Erbinnen | G | Nachlande c2da9d1a heute gemessen ANCESTOR (F2-3 Tier-/Hybrid-Erbinnen) | — |
| S-6a–d Preimage-Ordnung | G | im #15; PZW live (KON119-07) | — |
| S-7 Achsen-Algo-HW-Stempel | G | #4-Folge; Freeze-Check ERFUELLT | — |
| S-14a NULL-Bump-Riegel (##34-Wache) | G | #33/#35/#36 gelandet; Exit-3-Regen-Mechanik | — |
| S-18 Homes + Waechter | G | #16: ce 04ac26fa heute gemessen ANCESTOR, CI 15937 | — |
| S-21/N-1 + N-2 (S-6c Zwei-Welten-Wache, S-6d-Deklaration) | G | Nachlande c2da9d1a (KON119-01) heute gemessen ANCESTOR | — |
| B2 Gate-Trennung | G | #16 golden-Fenster | — |
| B3 Schalter-Hoheit | G | 23.2 GEBAUT_UNGELANDET → mit #15 gelandet; Spez-Abweichung DEKLARIERT (KON119-02), m1-Schutzgedanke = B5-Vorposten in #24 | — |
| #38d Preimage-Budget | G | 23.2 "Budget 8192 GERECHNET, Summe 6057" → mit #15 | — |
| F2-2 CEB-system_zeile (KON8-03 NUR-ANZEIGE) | G | Nachlande c2da9d1a (KON119-01) | — |
| #17/G-2-Semantik (Stempel-Strecken-Schluss) | G | ba33b9ac heute gemessen ANCESTOR; W1-V1 zu, CI 16031 (KON119-02) | — |
| #15 BUMP-BUENDEL komplett | G | Kette 196a621a→66de5c09, CI 16042/16044/16045/16049; super 588a461d heute gemessen ANCESTOR, CI 16052 | — |
| #16 golden-Fenster | G | CI 15937; super d152ba93 PZW 5/5 | — |
| #95 V-08R Planer-SHA | G | 4cc3aa0f heute gemessen ANCESTOR, CI 16045; KON120-06(4): 64-hex korrekt | — |
| #102 F6-golden-Ereignis (5. Einfrieren, Format 6) | G | KON119-02 FROZEN-ANKER; TABU-CRC 0x56F1B721C72DC10E MATCH | — |
| F2-Freeze-Check + Vorlagen-Fenster FINAL | G | vorlagen-fenster 3e9ec644/8aae5cd2 (#108) | — |
| #93 W1-Vollstaendigkeits-Audit | G | Board completed; Befunde in par.23 verbucht | — |
| #104 prt-art-Roundtrip-Pin | G | prt-art REMOTE dev = 777fff7 (heute ls-remote); CI 16048 9/9 | — |
| #111/#113 W1-Luecken ce-Haelfte (B01–B16) | G | ee8abb86 heute gemessen ANCESTOR; Heilungskette → f729b93a CI 16088 | — |
| #117-Riegel variant-Hauswache (Test #519) | G | e0126fad + Merge 9c74f553 heute gemessen ANCESTOR; CI 16088 | — |
| #110 W1-Vollaudit-Beweis-BU | G | docs/sessions/backups/20260821-vollaudit-welle1-stand/ @ 86f4fc1e | — |

## 3. W2-LANDE-ZUG #131 — GEBAUTE, NOCH ZU LANDENDE TIPS (NZL-G)

Alle NICHT-Ancestor-Aussagen heute gemessen (ce gegen f729b93a, super gegen 93542880,
prt-art gegen REMOTE 777fff7).

| Posten | Status | Beleg | Traeger |
|---|---|---|---|
| s19 (#7-Mechanik, Simulation) | NZL-G | a1b348ae ANCESTOR von 61d5d139, NICHT in dev | lande/w2-s1s2 (Merge 1/10 GEFAHREN) |
| messfenster (#13 T-15b + #38b Warmup-Paar) | NZL-G | 3a746090 ANCESTOR von 61d5d139, NICHT in dev | lande/w2-s1s2 (Merge 2/10 GEFAHREN) |
| s8kopf (S-8-Kopf-Anteil) | NZL-G | 41ee8780 NICHT-ANC; S1-Audit SITZT | bau/s8kopf + wt-ce-s8kopf (Merge 3/10) |
| s13schema ce | NZL-G | c76d3116 NICHT-ANC; S1-Audit SITZT (r2 2/2) | bau/s13schema + wt-ce-s13schema (4/10) |
| pmcpaket (#82/#83 I-PMC-2/3 + fail-loud) | NZL-G | 1d38263b NICHT-ANC; r2 2 VERTAGT → T6/T8b | bau/pmcpaket + wt-ce-pmcpaket (5/10) |
| vollzug91 (V91-Beweissicherung) | NZL-G | 6713156b NICHT-ANC; SITZT 0/0/2 | bau/vollzug91 + wt-ce-vollzug91 (6/10) |
| ph89 (#89 P-H 33 Paper→Prueflinge) | NZL-G | 2809e4d4 NICHT-ANC; SITZT 0/0/1 | bau/ph89 + wt-ce-ph89 (7/10) |
| trigfix (E07-Pruefer, ersetze()-Haertung) | NZL-G | 0f900dcf NICHT-ANC; SITZT 0/0/3 | bau/trigfix + wt-ce-trigfix (8/10) |
| skip97 (#97 C-13+C-14, Leer-Zellen-Wache) | NZL-G | 1c9f58a5 NICHT-ANC (T11: NICHT 100c32d2) | bau/skip97 + wt-ce-skip97 (9/10) |
| kampvor ce (Kampagnen-Vorstaffel, 24× ERFUELLT) | NZL-G | 1e1bc199 NICHT-ANC; P-25/P-26 = Lande-Auflage T12 | bau/kampvor + wt-ce-kampvor (10/10) |
| super s13schema (LANDE-KOPPLUNG mit ce-s13!) | NZL-G | 1e92b77e NICHT-ANC super-dev | bau/s13schema + wt-super-s13schema (H-6) |
| super cidual (#106 R1 Kill-Switch + R2 Drosseln) | NZL-G | 223ab518 NICHT-ANC | bau/cidual + wt-super-cidual |
| super vorlagenfenster-Fix (T1-Harmonisierung mit 8ed8b268) | NZL-G | a6fa04da NICHT-ANC; Lead-Fix 8ed8b268 IST ANCESTOR (heute gemessen) → T1/G5-Rezept gilt | fix/vorlagenfenster-r1 + wt-super-vorlagenfix |
| super w1luecken (B11 skip_anker + B14-super-xmllint; #113-Rest) | NZL-G | 8edc34a0 NICHT-ANC | bau/w1luecken-super + wt-super-w1luecken |
| super kampvor (#38c-REST: n/a-Zaehler frische_wache+persist_sammler) | NZL-G | 025e0c42 NICHT-ANC — NEU IN DER TAFEL (Briefing nannte nur ce-Tip; S2-Phase-4 nennt kampvor(super)) | bau/kampvor(super) + wt-super-kampvor |
| prt-art pinduo (#107, T9-Fixup vollzogen) | NZL-G | 25bbf2e NICHT-ANC gegen 777fff7; basiert AUF 777fff7 (beides heute gemessen) | wt-prt-pinduo bau/pinduo (Phase 3, ZUERST) |
| prt-art B14 (w1luecken-prtart) | NZL-G | 3710ac4c NICHT-ANC; Konflikt zugunsten D-10a (Rezept #107) | wt-prt-pinduo bau/w1luecken-prtart (nach pinduo) |
| ce o2-standard (E-7: O2 Default, O3 unter Warnung) | NZL-G | fa48a551 NICHT-ANC; == origin (#117) | bau/o2-standard + wt-ce-o2std |
| super Gitlink-Bump ATOMAR + PZW + KON122-Ledger | NZL-G | S2-Phase-4/5; PZW-Nenner LIVE zaehlen | #131-Zug Phase 4/5 (+T6 NP-34-Patch, T8b pmc-Ledger) |
| #19 main-FF beider Repos (Schlussglied) | NZL-G | entblockt seit #31; KON120-07(3) | #131-Schlussglied; Rest: F-13-Scope-Antwort (#126) + Diff-Hygiene push-lokal |
| Docs-Pflichtblock: T2/AB-02 (Par.59-W18-Austragung, VOR Mi 26.!) + T3/T4/T5/T7/T8b/T8c/T10/T10b/T12/T13 + G2-V93-Textfixe (PFLICHT vor Freeze-Uebernahme) + G4/G6/G7-Korrekturen | NZL-G | Entwuerfe WORTFERTIG (ablock/lande-auflagen.md, pmcpaket/fix-runde-1.md, a19/, a-block-docs Abschn. 2/4.8/4.10) | #131-docs-Zug + Lead-only-Ledger |
| OV-16/OV-17-Buchung + par.24-Wellenplan-Nachtrag + Kleinst-Fix anhang_forward_core.sh:250 | NZL-G | Bau GELANDET (heute gemessen, s. Abschn. 1); Buchung fehlt; par.24-Entwurf WORTFERTIG (d10-liegengebliebenes.md Abschn. 5) | naechster docs-Zug (KON121/4) |
| #122 SITZT-KLEIN-Paket (KW-A1, cidual-A1, trigfix-KLEIN-1, ph89-A-1, pmcpaket-AUD-1, s8kopf S8A-01/02, pinduo-A2/A3) | NZL-G | Board #122-Liste; G6-Korrektur (IDs S8A-01/02) | T7-Sammel-docs-Commit im Zug |

Pflicht-Auflagen des Zugs (aus Synthesen, unveraendert): T9 (pinduo-A1 ist VOLLZOGEN per
#107-Nachbuchung — Branch-CI-Beweis bleibt Lande-Bedingung) · G8/H5 volle 7er-J-1-Liste
LITERAL + reales Target comdare_profile_run_facade · H-7 Endstand-Nenner EINMAL live ·
K17-Endstand-Kombibau {gcc,clang}×{Release,Debug} VOR dem Push · G2-V93-A1-Textfix VOR
Freeze-/F-45-Uebernahme · T12 P-25/P-26-ci.skip-Nachpruefung per glhdr.curlrc.

## 4. W2-BAU-PFLICHTEN VOR TRIGGER Mi 26. 06:00 (NZL-F, sofern nicht anders belegt)

| Posten | Status | Beleg | Traeger |
|---|---|---|---|
| #18 S-13-Buendel (Export-Element, Ziel-Filter, per-Binary-xlsx; FJ-1..10 + E1-E11) | NZL-F | Design liegt (s13-Design 20260817); U-1-ROT-Auflage J-1-Rezeptfix VOR Bau | Di-25-Slot; Design-Dok + #48/#57-Buendel |
| #57 Lager-Vollausbau (1)–(6) + S-17 LagerBaumWriter verdrahten | NZL-F | B-08/B-09/R-02/R-03; 0 kaskade-Aufrufer (14.7/B-5) | Di-25 mit #18 |
| #48 XML-Publikations-Sektion (4 Klassen) | NZL-F | Karte liegt (wf_5ba07e0d) | Design mit S-13/#18 |
| #3/S-12 vier Mini-Pipelinen (Emission, B-17) + #106 Raenge 3–10 (K-1..K-13) | NZL-F | Vorbau 731b5655 BEREITS in dev (KON78-03); R1/R2 = cidual (s. NZL-G) | Di-25; eigene Straenge |
| S-8/S-9/S-10/S-11-Traegerbau (T-NEU-6, W2-KOPF; deckt B-01/B-04/B-14/B-16 + R-01 Planer-Split) | NZL-F | s8kopf traegt nur den Kopf-TU-Anteil | W2-Kopf-Posten nach s8kopf-Landung |
| B1/F2-1 Registry-NEUBAU <measurement_tooling>+Stufen-Dimension | NZL-F | 23.1 F2-1: 18.6(4)-Fall deklariert → W2-Anfang VOR Trigger | #24/B1 (KON37-02-Spez liegt) |
| B4 System-B-Anschluss (checkpoint_measure; Owner-GO B4 22.08.) | NZL-F | KON120-02 B4-JA; F2-4-Kopplung | #24/B4 + #120; FB20-K-1-Nachschaerfung (T-9/Z-7) |
| B5 Stempel-Pflicht je Schalter + B5-VORPOSTEN (Zwillings-Wache CEB==Tier-Zeile) | NZL-F | F2-4; KON119-02 B3-Spez-Vermerk | #24/B5 (KON64-Anteil nach P4 = Doppel-JA klar) |
| #38a2 Comp-Gate-Stempel | NZL-F | KON121-Explore B1: NIE GEBAUT (150+ Refs vollhistorisch); BAU-Rezept 7 Schritte | #120/B1-Rezept; gekoppelt an #86/ORG-19 |
| #86 ORG-19-IO anlegen+einbinden | NZL-F | Owner-GO 17.08.; KON120-07(4): OHNE Traeger benannt | Buendel-Strang nach D-08-Rueckkehr (mit #38a2) |
| #7/S-19-ECHTLAUF (Kampagnen-XMLs, ggf. --fremde-lane=intel, GN-9-Werte) + C-03-Deckel-Rechnung + O1–O4-F2-Zeilen | NZL-F | Mechanik NZL-G (s19); Lauf + Deckel VOR ##51 | nach s19-Landung; #7 |
| ##47 GN-9-Kalibrierlauf in O2-Zielform | NZL-F | KON120-01: A1-GO MIT variant-Tier-Audit; O2-Drehung = E-7 zuerst | nach o2-Landung; variant-audit-a1 laeuft |
| #114 B10-Beweislauf E-07-Gate (R-12) | NZL-F (laeuft) | Pruefer steht (trigfix 0f900dcf) | Agent p12-b10-beweislauf; vor Trigger |
| R-04 LB-4/5/6-Baum-Vollausbau · R-13 zwei unwahre Messgroessen | NZL-F | par.19.7 (P-Klasse, vor 26.08.) | Di-25-Schnitt/#96 |
| C-01 VOLLBAU-GATE-Vorlage + C-02 HEAVY-Signal-Sendung | NZL-F | par.19.3; T-NEU-9/T-NEU-10 | vor/zum Trigger; Infra (#60-Umfeld) |
| ##35 Resume-Beweis · ##36 T-15+D4-Verdrahtung · ##37–##39/##41 | NZL-F | W2-Mo-Slots (§4); ##34-Wache bereits G (S-14a) | W2-Mo |
| ##46 Anker 3 Spiegel · ##48 §66+Platten-Budget · ##41b Kaskade | NZL-F | W2-Di (§4) | W2-Di |
| ##49 BAU-TRIGGER Mi 26. 06:00 · ##50 Zweitlauf · ##51 USER-GO-VORLAGE = F3 | NZL-F | §3-W2; Kipp-Punkt-Regel K-4 | W2 Mi–Fr |
| D-08 Emitter-Integrations-DESIGN (L1–L7, "Steuerung→Compile") | NZL-F | KON121(2) D-08: Explore fertig, Fable-Designplanung folgt; Entscheid vor Mi 26. | p4-d08-entscheid (Agent laeuft) |
| #91-Vollzug: v3-Entwurf landen (docs/plaene) + E-1/E-2/E-4/E-5/E-6 festschreiben | NZL-F | #91 in_progress; Entwurf liegt (350 Z.) | Di-25-Zug; Frist Mi 26. |
| #120 B-Block: B1-Tripwire-Reparatur + B3-Rest/B5-VOLLNACHZUG + B4-GO + B5-golden-Zug (telemetry-silent + B-10 + B-7 + Kampagnen-Bump) | NZL-F | Owner-GOs 22.08. (KON120-02/KON121) | #120; je frei werdendem Bauslot |
| golden-Folgezug B-7-Stempel-Haelfte/E-B/A-11-Emitter + B-10-Anker-Faelligkeit | NZL-F | par.21.1-Folgezuege; V-03R-Budget UNVERBRAUCHT | #120/B5-golden-GO |
| #99 B-5f Tooling-Ordnungs-Validierung (3 Stellen) | NZL-F | par.21.4 (Traeger-Luecke geschlossen) | Di-25 |
| #94 Abi7-Kapselung (C-F4) + decl.hpp:797 | NZL-F | par.21.4 | W2 |
| #103 TSan-Vollausbau (M-2 fence-Naht) | NZL-F | P.20.9 M-2 | HY-A2-Umfeld |
| #105 NP-24 + Miniposten-Trio A9/A10/A11 + X-12/V-02R + D5-5-HDR-VERDRAHTUNG (Frist vor Sa 29.!) | NZL-F | T-3/T-4/T-7/T-12; HDR 0 Produktions-Konsumenten | Di-25; Traeger-KANDIDAT ce-Branch bau/d55-hdr (Alt-Stand, Inventur prueft) |
| #124 B-8 Gate-Define-Emission + hat()-Paar (X-13/A-12) | NZL-F | Di-25-Slot | #124 |
| #125 C-09 Drift-Gate-Debug-Ausnahme | NZL-F | par.19.3 C-09; H-12 (nach messfenster-Merge) | #125; vor W3 |
| #127 Dauerrote Achse-06/CRC (3 Tests + fixture-Klasse) | NZL-F | KON119-06 deklariert; H-26 | #127; vor Sa 29. |
| #97-REST Ausweis-Host-Verdrahtung | NZL-F | Board #97 | nach skip97-Landung |
| T-13/T-14 Fehlerklassen = C-12-PFLICHT (0/18 bzw. 0/121) + T-07/T-08 (vor Trigger falls mengen-wirksam) | NZL-F | par.19.3/par.21.3 (##40-Reste) | Di-25/#96; L8-Hybrid-Parser-fehlerklasse andocken |
| ##15-EMITTER/TEMPLATE-Haelfte | NZL-F | Wiederaufnahme par.21.3 (W2-Slot) | Di-25/#96 |
| ##21-Haelfte 2: object_stat gegen Store | NZL-F | §6/##56-Haertung "benannt, aber unerledigt" | Traeger-KANDIDAT super-Branch bau/lagp1-object-stat (Inventur prueft); ##56-Abnahme W3 |
| D3-7b pruef_only-Modus | NZL-F | F1-KERN-Restposten | Traeger-KANDIDAT ce rettung/bau/d3-7b-pruef-only-bilanz (Inventur prueft) |
| D3-3b Leerzeilen-Zaehlung (3 Dateien EIN Commit) | NZL-F | F1-KERN-Restposten | #38c-Umfeld/Di-25 |
| ##20-B-Restbau (COPIED_LIST-Zeile; Runner-git ≥2.25 pruefen) | NZL-F | Fussnote ##20-B "GEMESSEN, NICHT GEBAUT" | Kleinrest W2 |
| ##11 <measure_selection> + R-05 XML-Trennung BAU/MESS | NZL-F | R-05 (Owner "sonst regression") | Traeger-KANDIDAT ce bau/measure-selection-xsd (Inventur prueft); S-13-XSD |
| ##13 G3-Split (R-09: G3 aus STATISTICS-Gate) | NZL-F | par.19.7 R-09 (heute max 2 CEBs) | W2 |
| ##16/##17 Break-Even-Kanon → D-04-Neuform | NZL-F | KON120-02 D-04 VOLLES GO alle Familien (ersetzt OV-1-Fork) | #129-Design (nach Lande-Zug) + R-21 W4-Vorb. |
| ##19 LaTeX-Auswertungs-Emitter | NZL-F | keine Einzelquittung im Ledger-Kopf gefunden — Vermerk | ##60-Umfeld W4 |
| ##09-Rest amd_l3-Wertfuellung (CAP_PERFMON) | NZL-F | B-5-Spalte gebaut (pmcpaket NZL-G); Fuellung = Infra | #87 Talos-Lane v1.13.x |
| ##42–##45 Abgabe-Vorlauf (FF-Matrix, .ps1/.py-Abloesung, C5-Geruest, Thesis-Spur) | NZL-F | keine Einzelquittung im Ledger-Kopf — Vermerk | ##59/##60/#121-Umfeld |
| S-2/G-1-Grammatik-BAU + G-1-Ruecklauf zur W2-Tabelle (D-05-PFLICHT) | NZL-F | 23.2 "benannte Leerstelle"; KON120-02 D-05 | #53 (in_progress) + p3-g1-restfragen |
| F2-6 Umbenennungs-Rest (E-Label-Karte, Flag-f-Kollision FPGA/AVX-512) | NZL-F | 23.1 F2-6 | W2-Slot |
| S-14-VOLLAUSROLLUNG (nach Homes) | NZL-F | T-NEU-5 (Strecke P.41) | W2 |
| ##31-Vollform + D1c-Vollausbau (Rueckfallstufen ungezogen) | NZL-F | par.21-Marker: W2-W-Posten | W2 |
| #74 Repo-Rollen-Umbau (15 CE-Kandidaten) | NZL-F | W-G-Karte liegt | #74 W2/W |
| #71 Triage-Sammel + #69 (750-vs-1310, prod2-TeX) + #28-Inventur-Beginn (Startzahl 14 Skripte, T-11/Z-9) | NZL-F | Board | W2/W |
| #40 NE-Nachimplementierung (38 Posten) | NZL-F | Board #40 | W0b-W1-Label, offen |
| #128 Soll-Ist W2 gegen Designplan/GOAL (H-28/H-29) | NZL-F | Board; DIESES Dokument = Wellenplan-Haelfte | nach Landung |

## 5. WIEDERAUFNAHME-BESTAND (par.21.3 — NIE ausbuchen; Sammelposten, alle offen)

| Posten | Status | Beleg | Traeger |
|---|---|---|---|
| Band B/W1: 22 Posten, 62 h | NZL-F | par.21.3 (Platzierung W2-Randslots Mo/Di + WE) | #96 Feinplatzierung Di 25. |
| Band-B-Rest: 37 Posten, ~104,5 h | NZL-F | par.21.3 (W3-Batch-Pausen [lok] + W4) | #96 |
| Band C: 5 Posten, 13 h (WinPCM W2/W4 · AmdL3 #87 · MT-L8/PM-PAPI/AG W4) | NZL-F | par.21.3 (Begruendungen ueberholt, fahrbar) | #96/#87 |
| 14 Alt-W7-Posten par.13.3 (#29-Rest #30 #32 #34 #42 #44 #48 #50 #63 #64 #69 #71 #72 #26) + P/E-Core + #38a3-IO + par.75 + Record-and-Replay + PV-1 | NZL-F | par.21.3 (W4/W5-Randslots, GEZAEHLT) | #96 Di-25 |
| #96 Feinplatzierungs-Schnitt selbst + Z-1..Z-15-Zugaenge (par.22.4) | NZL-F | par.21.4/22.4 | #96, Di 25. |
| ##24/A9-S5a (W4) | NZL-F | par.21-Marker (Rutsch aufgehoben) | W4 |

## 6. W3 / W4 / W5 (technisch nach Trigger; Owner-Order 20.08.: Etiketten = SPAETESTE Frist)

| Posten | Status | Beleg | Traeger |
|---|---|---|---|
| ##52 Vor-Gate + 2 GOs · ##53 320er+Teilmatrix · HY-B · ##54 · ##55 (+T12b CCD-Semantik) · ##56 (+object_stat-Haelfte) | NZL-F | §3-W3; OV-15-GOs bis Sa 29. 06:00 | W3; H2/T12b in ##55-Zeile |
| #123 HY-B-Stempel-Export (nach P5 + A-11/#102) | NZL-F | 22.2 T-8 | #123 |
| ##57 Break-Even (D4f-Statusraum, D-04-Form) · HY-C Router · ##58/##58b (Soll ZUR LAUFZEIT, 28 UNBELEGT) · ##59 FF0–FF4 · ##60 C5 + #98-Diagramme (2D/3D SOTA) · ##61 · P-1 Praesens-Wache 3/3 | NZL-F | §3-W4; #98 (F-07b Owner-KERN) | W4 |
| ##62 W5-Sicherung + Abgabe Di 15.09. | NZL-F | §3-W5 | W5 |
| T-3-Ripple: XML→PDF-Vollautomatik + Lager-Skip + manueller Reset (~Sa 12.09., echte Messung) | NZL-F | §17.4/18.5 | W2/W3-Voraussetzungsposten |
| #121 C3-Thesis-Absatz-Pipeline + #130 (16 ungetragene Kommentar-Auftraege) + #77 | NZL-F | Vorspann KOMPLETT (P10); wartet auf Owner-Restkommentare | #121/#130/#77 |
| #129 D-04 Mathe-Command-Pattern-Design (Definitions-Sprache, Lager-Ablage) | NZL-F | KON120-02 D-04 VOLLES GO; Design-Skelett liegt | #129 nach Lande-Zug |
| #53 PMC-Schwester + Lastsequenz-Design (Owner-Vorlage je Achse) | NZL-F | in_progress | #53 |
| S-20 Sync-Kanal CEB↔Hybrid (Owner: Autonomie-Stufe SPAETER) | NZL-F | KON36/D-01: S-20 ungebaut | W3+/HY-Folge |
| S-16 Shell→GTest Dauerposten | NZL-F | #28; seg4-15: 14 Skripte | #28 |
| U-2 prod1-Platten-Raeumung root-seitig + L7 Talos-Kernel-Fixes + Infra-Fenster (OF-4-Kette, node6/id56/id18, U-2-root) | NZL-F | 22.1 U-2, 23.5 L7; KON120-05 | Owner/Infra-Fenster (#84/#87) |
| Owner-Restfragen R1–R8 (KON121) + G-1-Restfragen nach Audit-Terminal | NZL-F | KON121(3) | Owner-Fenster; p3-g1-restfragen |

## 7. KATEGORIE C — bleibt per Owner-Wort (par.21.6; NICHT eigenmaechtig kippbar)

| Posten | Status | Beleg |
|---|---|---|
| OV-14 Paper-Kopplung → nach Abgabe | C | Owner-Wort 17.08. + LEDGER:11128 |
| W7/#88 Monolith-Split (+P-B/P-K) | C | Owner-B3 "beim Aufraeumen" |
| C-1 Workflow-Journal-Agent-Labels | C | 22.5 (nur per Owner-Satz) |

Stehende Owner-Entscheide (keine Arbeitsposten, nur Vermerk): OV-4 Vollmessung→Deckel ·
OV-5(b) prod2→Textkorrektur (transparent gemeldet: prod2 seit #60 online — EIN Owner-Satz
holt die Lane zurueck).

## 8. GESTRICHEN/UEBERHOLT (Marker am Ort; par.21 gewahrt — nur mit Marker/Owner-Deckung)

| Posten | Marker/Beleg |
|---|---|
| D1b CI-Prebuild-Eintrag | F1-KERN "STREICHEN, nicht bauen"; Restposten Stage-Topologie = eigener Schnitt (Traeger-Kandidat ce bau/ci-stage-topologie, Inventur prueft) |
| ##08-B "lazy Header-Emission" | F1-KERN "NIE bauen" (Namens-Missverstaendnis) |
| ##06-Alt-Formel (v1:578) | Fussnote D2-G4 "UEBERHOLT, bleibt stehen" |
| HY-A3 "Registry 22→23" | P.20.10/KON118 Phantom-Nenner; Marker an :697/:857/:952; Ersatz 5→6 GEBAUT+GELANDET |
| O-2 (Hybrid-Wirkung auf Organ) | §15.1 GESTRICHEN an 6 Stellen (KON8-12/KON13) |
| O-6/O-7/O-8 + B-2-Nesting-Blocker | KON16-03 KEINE YAML → gegenstandslos |
| OV-10 als 6er-/Nenner-Frage | KON39-Marker; Anordnung neu als KON37-03 |
| "CEB-Reihe 5→6→12" | §16.3-Marker: Nenner ist 32 (KON25-03) |
| R-4 (Pruefdock "gerade Anzahl" allgemein) | Owner KON30-04 "streiche ueberall"; gilt nur noch CEBs |
| Streichkaskade §7 als Instrument | par.21.0 stillgelegt (Limit = pausieren, nie reduzieren) |
| W7 als Endlager | par.21.0 (nur noch Owner-entschiedene Posten) |
| F-07b-W7-Verschiebung | UEBERHOLT-Marker ff64fe0e (erfundene Autorisierung); Bau = #98 |
| ##34 "Magic 4→5" | 09.08.-Korrektur: unbereinigter Textrest; Budget verbraucht (8→9 d4c0b49c) |
| ##58-Nenner "28" | Fussnote ##58-NENNER: UNBELEGT (real 10/12); Wache misst Soll zur Laufzeit |
| Hermite-Ratifikationsvorschlag 21.08. | KON121(2) D-04: UEBERHOLT (nicht vollzogen) |
| 18.6(3)-Deklaration C-3a/#38a2 | KON120-06(1): Doppel-JA uebersehen → Fallweg ersetzt durch BAU-Pflicht (#38a2 = KON91-02-Weg) |
| Ledger-Fussende-Zeile "D3-4+D3-5 (OV-16) / ##20+D3-6 (OV-17) ungetragen" (:32272) | KON121(2) D-10: beide seit 09.08. GEBAUT — heute Ancestor-gemessen (a558e87c, 6d2e3dce) |
| measure:smoke-Wiederbelebung | §7: faellt (bleibt deprecated; lebender Weg = CEB-emittiert) |
| §14-Blocker-Kette (O-1 blockiert S-2/S-3; "Do 14.08.") | §15/§16: Grammatik existiert, O-3 beantwortet, Frist = Freitag |
| seg1-04 sechs stale E-6-Stellen im Hybrid-Bauplan | KON119-07: 6 datierte UEBERHOLT-Marker ADDITIV gesetzt |
| KON119-02/T-A-Buchung "C-3a-Frist verstrich → 18.6(3)" | KON120-06(1): korrigiert (Doppel-JA galt) |

## 9. ZAEHLUNG (Nenner = Zeilen der Tafeln 1–8)

    GELANDET (G)                : 56   (Tafel 1: 24 · Tafel 2: 32; je Tafel maschinell
                                        gezaehlt am 22.08., grep-Protokoll Session-Log)
    NOCH ZU LANDEN gesamt       : 94
      davon GEBAUT (NZL-G)      : 23   (Tafel 3)
      davon FEHLT/Bau offen     : 68   (Tafel 4: 50 · Tafel 5: 6 · Tafel 6: 12)
      davon Kategorie C (Owner) : 3    (Tafel 7)
    GESTRICHEN/UEBERHOLT (U)    : 21   (Tafel 8)

    Posten-Nenner dieser Tafel gesamt: 171 Zeilen (Aggregations-Ebene = Wellen-/Paket-
    Posten; Sammelzeilen wie "Band B 22 Posten" zaehlen als EINE Zeile — die inneren
    Zahlen stehen in der Zeile).

## 10. RESTPOSTEN / BEFUNDE AN DEN LEAD (Board/Memory = Lead-only)

1. prt-art-HAUPTKLON-Submodul STALE: lokal dev d11781fa, echter Remote 777fff7
   (4 Commits). VOR Phase 3 fetchen; #104 ist am REMOTE gelandet (Beleg ls-remote heute).
2. NEU IN DIE LANDE-LISTE: super-kampvor @ 025e0c42 (bau/kampvor super,
   "#38c-Rest n/a-Zaehler frische_wache+persist_sammler") — NICHT-ANC gegen super-dev,
   im Briefing nicht als Ziel genannt, S2-Synthese Phase 4 nennt kampvor(super).
3. INVENTUR-DIMENSION (Phase 2, Owner-Wort "mehr landbare Ziele"): ce 177 lokale
   Branches, super 68, wt-prt-pinduo 8. Auffaellige Traeger-KANDIDATEN fuer offene
   Wellenplan-Posten (Stand ungeprueft, Inventur muss Ueberholt-Status messen):
   bau/d55-hdr (D5-5!), bau/lagp1-object-stat (##21-H2!), rettung/bau/d3-7b-pruef-only-
   bilanz (D3-7b!), bau/measure-selection-xsd (##11!), bau/ci-stage-topologie (D1b-Rest),
   bau/stempel-nachlande-f2 (e9d035f6 = bereits gelandeter A2.5-Fix?), golden-rettung,
   wip/luecken-stufe2-pause-1308 (T-NEU-13), b-graph-2d3d (super, #98-Kandidat!).
4. D4e/D4f, ##19, ##42–##45, S-4: KEINE Einzelquittung im Ledger-Kopf gefunden; Deckung
   nur ueber #93-completed bzw. 23.1-Nichtnennung. Empfehlung: im #128-Soll-Ist (nach
   Landung) je einen Objekt-Blick nachziehen.
5. Owner-Frist-Anker im Zug: AB-02/T2 docs VOR Mi 26. 06:00 (Trigger-Fehlbau-Risiko
   W18) · G2-V93-Textfix VOR Freeze-/F-45-Uebernahme · HDR-Bau vor Sa 29. · #91/D-08-
   Entscheide vor Mi 26.
