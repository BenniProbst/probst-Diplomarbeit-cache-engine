# ABGLEICH: KATALOG-Gesamtplan (02.08.) gegen Ist-Stand 03.08. vormittags

> Owner-Auftrag 03.08.: Gesamt-Plan-Dossier in den Kontext kippen und aktuellen Stand pruefen.
> Basis: docs/sessions/20260802-KATALOG-offene-strecke-gesamtplan.md (A1-A17/B/C/D/E/F/G/H).
> Seither gefahrene Wellen: W1, 2a, 2b, 2c, OS-U3, Thesis-C, 2d (Landung laeuft, ce dev=0d7a0d92
> gepusht, CI-Wache aktiv) + Codex-/Fable-Reviews (Z-01..Z-12, GA-01..GA-13) + M3-Dossier v4 + Audit.

## A-Strecke (trigger-blockierend) — Stand je Paket

| # | Stand 03.08. | Detail |
|---|---|---|
| A1 Lager | IN ARBEIT | TP1 Teil B/FAIL-Nachbesserung lief 02.08. (Stand NICHT in dieser Session verifiziert); LB-Schnitt, G-E3, G-E6, G-E7 offen; TP1-Neu-Inventar nach M3 (Dossier §1i) |
| A2 SHA512-Gate | OFFEN, an M3 gekoppelt | GA-01/OF-M3-1 (Preimage-Trenner) ist die Vorarbeit; Gate-Bau nach M3 |
| A3 Beweise 1-5 + Dual-Weg | OFFEN | unveraendert |
| A4 12-Perm | OFFEN | unveraendert |
| A5 ETA/Kalibrier-Prinzip | OFFEN | CX-W8 war nur die Bestandslog-ETA-Wache, nicht das Kalibrier-Prinzip |
| A6 OD-10 | OFFEN, eingeplant | = OD-10-RT, Reihenfolge 2d->M3->M4->OD-10-RT |
| A7 E-04+E-18 | TEIL | E04-P1 in 2b GEBAUT; Zweitpass-Nachbesserungen Z-05/Z-06/Z-08 offen; E-18 offen |
| A8 Benchmarking-Schnitt | OFFEN | Design-Dossier = Task #4 |
| A9 xlsx-Writer | OFFEN | Design-Dossier = Task #4 |
| A10 HW P4-P6 + prod2-Beweis | OFFEN | unveraendert |
| A11 Klein-Sammel | OFFEN | Task #5 (Ledger-Nachtrag gewachsen: +Wellen+Reviews+GA-07-Zahlen) |
| A12 NAS-Creds E-14 | OFFEN | Infra-nah |
| A13 Stempel-REGRESSION | M1+M1b+M2 FERTIG; M3 STARTKLAR | Dossier v4 (8edda5eb) audit-geprueft; Gate: 2d-Landung + Q-M3-GATE; 3 Owner-Defaults OF-M3-1/OF-M3-2/DV-3; M4 danach |
| A14 OS-Unter-Achsen | U1/U2/U3 FERTIG; U4 OFFEN | GA-10: OS-U3 gebaut+getestet, produktiv erst mit OS-U4 |
| A15 FK-Framework #29 | FK-0/1/2 FERTIG | FK-5 faehrt im M3-Fenster mit (Audit-F1, Dossier R14); Rest-FK-Stufen offen |
| A16 E-Buendel | E-23 OK, E-21 OK; E-02/E-19/E-24 OFFEN | E-02 VERIFIZIERT NICHT hergestellt (kein prtart-/thesis-Ledger); E-19: i112-Fleet-Handout an Infra liegt (02.08.); E-24 = KRITISCHE ABI-KANTE VOR Trigger (HY-D2) |
| A17 Hybrid-Design | DESIGN FERTIG | hybrid_tier_stufe_soll_design.md + CX-W7 (fc47c5d9, in 2d-Landung enthalten); BAU planmaessig Auswertungsphase |

## B/C/D/E/F — Kurzstatus

- B Trigger-Sequenz: F14-Gate KOMPLETT (Mittags-Anker 02.08.); J-Kette/heavy/Kalibrier/Trigger warten auf A-Strecke.
- C Thesis: Sprachpass+K-Nachzug+Verweise FERTIG (b1ec837); NEU SEIT KATALOG: Anhaenge-Realm-Einzel-Gliederungs-LUECKE
  (Befund-Doc 02.08., 8 Stuecke DE+EN) = Task #6, startfrei. C1-Rahmen-Pass: GO liegt, Entwurfs-Stand zu verifizieren.
  C2 terminiert (Gate-Zahl bei Einfrieren: jetzt 331). C3 GO erteilt (+RISC-V/macOS M1/x86 Querschnitt offen: target_isa/OS/E-19).
- D Infra: SPD erledigt; heavy wartet auf unser Signal; #327 PAT-Rotation nach Messfenster (Handout liegt).
- E Nach-Bau: unveraendert gated; E.0 KERN-Mess-Schema = PFLICHT vor jeder Messung.
- F Aufraeumpass: Kandidatenliste waechst (heute +: stale Haupt-build/ 17-Achsen-Codegen regenerieren; Stamp-Write
  flush/good-Check :1790; W2d-Folgeschulden Mess-Pfad-Testluecke).

## Neu seit dem KATALOG (dort nicht enthalten)

1. Review-Befund-Bestand: Z-01..Z-12 + GA-01..GA-13 (2 BLOCK in 2d gefixt; GA-01 -> OF-M3-1; Triage = Task #8).
2. M3-Ausfuehrungs-Dossier v4 + Gruendlichkeitsaudit (GRUENDLICH nach F1-F6-Nachtrag).
3. Owner-Vorlagen-Stapel V3-V6 + OF-M3-1/OF-M3-2/DV-3 + CX-W2-Wire-Bump + Fundstelle-B-Umsortierung.
4. Arbeitsweise-Ruege 03.08. (B.3-Nachtrag, Workflow-Kanal-Pflicht).

## Kritischer Pfad bis Trigger (Ziel Do 07.08., Frist Fr 08.08.)

2d-Landung (CI laeuft) -> Q-M3-GATE -> A13-M3 (+FK-5) -> M4 -> OD-10-RT (A6) -> A1-Rest (Lager) ->
E-24 (ABI-Kante, VOR Trigger!) -> A2-Eichung (EINMALIG ZULETZT, Lage-Dossier GATE 5) -> A3 -> A4 -> A5 -> A7-Rest -> A8/A9 -> A10 ->
A11/A12 -> B1-B4 (J-Kette -> heavy -> Kalibrier -> Trigger). Parallel: Task #6 Thesis-Anhaenge + C1-Rest.
MANAGER-EINSCHAETZUNG: A3-A10 sind substanzielle Pakete; ohne aggressive Parallelisierung disjunkter
Wellen (nach 2d-Landung) ist Do 07.08. eng. Prioritaet: kritischer Pfad zuerst, Design-Dossiers (#4)
parallel als Fable-Breite, Thesis-Anhaenge (#6) parallel (anderes Repo).
