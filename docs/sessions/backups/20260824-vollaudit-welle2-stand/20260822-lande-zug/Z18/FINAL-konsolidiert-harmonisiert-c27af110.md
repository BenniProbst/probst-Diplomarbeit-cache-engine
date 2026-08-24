# F2-VORLAGEN-FENSTER — FINAL (konsolidiert; R6-Vorlage an den Owner, Fr 21.08.2026)

Lead-Konsolidierung 21.08.2026 aus ZWEI Straengen (A2.3a-Strang-Dopplungs-Probe gefahren):
- QUELLE 1: ~/backups-workflow/20260820-w2-sofortstaffel/F2-VORLAGEN-FENSTER-ENTWURF.md
  (Strang vorlagen-fenster/B-4, 481 Z.: V-01..V-20 + Z-01..Z-03 + ENTSCHIEDEN E-1..E-10 +
  Gegenlese-Protokoll + Ledger-ENTWUERFE A/B/C) — GILT VOLLSTAENDIG, wird hier NICHT dupliziert.
- QUELLE 2: ~/backups-workflow/20260821-w1-luecken/BAULISTE.md Teil C (KernExplore W1-Luecken,
  G01–G22 owner-gated Vorlage-Zeilen).

## DOPPLUNGS-PROTOKOLL (je G-Zeile: Dopplung mit V-Fenster ODER Delta)

DOPPLUNGEN (im ENTWURF bereits vollstaendig gefuehrt, KEINE zweite Zeile):
G03=V-05 (P5) · G04=V-04 (P4/C-3a) · G06=V-01 (P1) · G07=V-02 (P2) · G08=V-03 (P3) ·
G09=V-06 (P6) · G10=V-07 (P7) · G12=E-9+V-10/O4 (OV-4 prozedural entschieden) ·
G19=V-16 (E12-Thesis) · G21 = das Freeze-Check-Testat selbst (Protokoll liegt bei, s.u.).

DELTAS (nur in der BAULISTE; hiermit ins Fenster gehoben — D-01..D-12; VF-A1-Nachzug 22.08.:
D-12 per 8aae5cd2 nachgetragen, Zaehler hier nachgezogen):

### D-01 · HY-Ebene4a / 4.-Ebenen-Entscheid (G01; OV-3-Nachfassung) [ENTSCHEID]
„Der 4.-Ebenen-Entscheid (hybrid-lokal vs. globales Glied; OV-3-Empfehlung hybrid-lokal)
war Mi 19.08. terminiert und ist UEBERFAELLIG — Entscheid erbeten; danach HY-Ebene4a-Testbau
(Designplan [A W1 12h(a)-Anteil])."

### D-02 · type_phase_rank-Rename (G02; R73/A-06) [ENTSCHEID: GO]
„batch_planner.hpp:94 type_phase_rank ist ORT-Vokabular-widrig; Rename NICHT preimage-/
golden-wirksam (builder-interne inline-Funktion), faellt aber unter I-7/R-2 (Renames nur mit
Owner-GO) — GO fuer z.B. type_stufen_rank erbeten."

### D-03 · B5-Zug-Freigabe + B3-CEB-Glied-Nachzug (G05; ergaenzt V-13-Datum) [ENTSCHEID]
„B5 (Stempel-Pflicht je Schalter, KON38 Fable max) ist per F2-4 deklariert; Vorbedingung
F2-3 ist GEBAUT (279d9344) — Freigabe des B5-Zuges (Traeger #24) inkl. B3-Nachzug
(wallclock@Version als echtes CEB-Stempel-Glied statt Legenden-Erbe) erbeten; Auflagenkatalog
liegt (NP-01/02/03/07/17/18 + KON45-01(5)-Budget-Neurechnung)."

### D-04 · Break-Even-Buendel OV-1 + OV-6 + D4f (G11) [ENTSCHEID, EIN Satz]
„OV-1 (B=3-B-Spline neu vs. Hermite ratifizieren; axis_spline.hpp fuehrt Hermite) + OV-6
(BE-Definition; Fallregel: nicht bis F2 konsolidiert -> Break-Even faellt aus dem W1-Scope)
+ D4f-Statusraum (bauen solange 0 Konsumenten ODER W2 deklarieren): EIN Entscheid erbeten."

### D-05 · G-1-Restfragen 9/12 + S-18-DREIPHASIG-mess (G13) [ENTSCHEID]
„G-1-Restfragen (9 von 12 offen) — darunter Task#16-Luecke2: mess_form_ist_dreiphasig-
Formwache ist owner-gestuft (Stufe B/C) — Ruecklauf erbeten (W2-Tabelle)."

### D-06 · ce-Standalone-SCHEMA-Bein (G14; Task#16-Luecke4) [ENTSCHEID]
„Die ce-Standalone-CI faehrt das SCHEMA-Bein halb (Skip) — genuegt das? Ja/Nein erbeten."

### D-07 · OF-1-Rest-Fork cp/ce-Klammerformen (G15) [ENTSCHEID]
„Flag-Grammatik v2, Rest-Fork F1: sind cp/ce die Klammerformen c{p}/c{e}? Entscheid erbeten
(W2-Tabelle; Dauerregel Stempel-Kuerzel-Zerlegung haengt daran)."

### D-08 · V-06 Stempel-Pflicht-Weite (G16; NICHT die Fenster-Nummer V-06!) [ENTSCHEID]
„V-06-Lesart A (comdare_anatomy_version_lines PFLICHT + Emitter-Integration, GEWEITET) vs.
2 Symbole — Lesart-Entscheid erbeten; R2(b)-Haelfte liegt im golden-Regen-Schnitt."

### D-09 · G-5 run_methodology-Enum-Ordnung (G17; V-12 der Rest-Vorlage 17.08.) [ENTSCHEID]
„RunMethodology-Enum-Ordnung (work_mode-Umfeld, Stempel-/ABI-Ereignis) — echte Owner-Frage
aus 20260817-OWNER-VORAB-15-restfragen.md; Antwort erbeten."

### D-10 · OV-16 + OV-17 (G18; W0b-D3-Blocker) [ENTSCHEID x2]
„OV-16 (allow_failure am CEB-emittierten Mess-Job entfernen — Empfehlung ja, Owner-Wort
09.08. traegt sie bereits sinngemaess) + OV-17 (result.csv-Konvention: Archiv-Artefakt,
Muster erweitern?) — beide Fristen Mi 12.08. verstrichen; sie blockieren die D3-4/D3-6-
Nachzuege (Flaeche super/ci -> Lande-Zug). Entscheide erbeten."

### D-11 · Sammel: K2-P/E-Core-Platz + Alt-Owner-Posten (G20+G22) [KENNTNISNAHME/DISPOSITION]
„(a) ICpuCore/CoreClass/CPUID-0x1A ohne Wellen-Posten — Platz-Entscheid erbeten.
(b) Alt-Sammel zur Disposition: PA-3 (3 PRT-ART-Quelldateien) · ETA-avg_size_bytes ungenutzt ·
'G13'-Kuerzel unzuordenbar · 2 unbenannte Owner-GOs (Roh-Transkript Z36292/Z42737) ·
K-5-Dateien mit Teammate-Berichten trotz Owner-only · OD1-OD4 (§68d, seit 26.07.)."

### D-12 · R-1/OV-10 Steuerdock-Zahl (Synthese-Dedup-Pruefung, s8-Strang F-17) [ENTSCHEID]
„Der S-8-Traegerbau hat SECHS Steuerdocks gebaut (C-6-Mandat/B-14, steuerdock.hpp); die aeltere
OV-10-Lesart sagte ‚max. 4 erreichbar' — Bestaetigung der SECHS erbeten (genau EINE Code-Stelle,
Registry-Aufzaehlung; Wortlaut-Vorlage in traegerbau-s8-ergebnis.md §6.3)."

## SOFORT-ZEILEN (aus dem ENTWURF, unveraendert dringend)
1. V-04: C-3a-Nachfassung d8b27633 (haertester Blocker, Frist 19.08. verstrichen).
2. V-14: U-2 root-Platten-Raeumung prod1 UEBERFAELLIG (Objekt 21.08.: 31G frei/88 %,
   /tmp/comdare ~8G gitlab-runner-eigen) — VOR den WE-Vollbau-Wellen Sa 22.08.
3. V-18: Infra-Fenster-TERMIN (Paket: Rotation 286/288/289 „SOFORT" + INF-03/05 + U-2 +
   V8-Rotation + node6-Handgriff) — vor Mi 26.08.
4. V-10/O4: GN-9-1-Zellen-Kalibrierlauf VOR dem S-19-Sa-Lauf 22.08. (sonst deklarierte
   Herabstufung; Zeit-Deckel bleibt fail-closed unbestimmbar).

## ABNAHME
B-4 erfuellt: das Fenster (ENTWURF V-01..V-20 + Z-01..Z-03 + DIESE 12 Deltas) liegt der
Landung bei; ENTSCHIEDEN-Tabelle E-1..E-10 verhindert Bereits-Entschiedenes (A2.3a).
Freeze-Check-Protokoll: docs/sessions/20260821-F2-FREEZE-CHECK-PROTOKOLL.md (Schwester-Dokument).
