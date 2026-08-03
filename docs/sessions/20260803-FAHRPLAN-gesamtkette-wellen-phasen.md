# FAHRPLAN 03.08. nachts — GESAMTE Bau-Kette in Wellen und Phasen (Owner-/btw-Antwort, persistiert)

> Stand: A13 KOMPLETT (M1-M4, ce dev+main ab2c60fd, ENFORCE=1, Contract 7.1), Welle 2d + Thesis-Wellen +
> Design-Dossiers + E-02 gelandet, 11 Entscheide Explore-verifiziert. Frist Fr 08.08., Trigger-Ziel Do 07.08.,
> Messung NUR USER-GO. Quellen: KATALOG (korr.), ABGLEICH (korr.), Ledger-Nachtraege 03.08., Dossiers.

## PHASE 1 — Laufend + Lager (jetzt -> Mo 04.)
- OD-10-RT (LAEUFT, wf_a34d53e2): NUMA/page-RT nach OS-U3-Muster, probe_id v1.0.0c, K4-FK, A-15-neutral -> Landung.
- A1-Lager-Rest (Vorbedingung F3-Testschuld #9): TP1-Neu-Inventur gegen v6 (Arbeits-Ist; FINAL nach W10/E-24, R15),
  LB-Schnitt (Baum-Writer 2 Realm-Wurzeln, complete-heuristik.log, Truncate-ZM, CEB-Einlagerung), G-E3, G-E6
  (Quelldaten seit C4 real X.Y.Zc), G-E7 Dual-ccache, Takeover-Produktions-Aufrufer, N8-B.

## PHASE 2 — Stempel-/ABI-Abschluss (Mo -> Di 05.)
- W10: System-ZELLWERTE in die system_stamp_line (beendet Skip-nur-gleiche-OS-Familie; deklariertes Byte-Ereignis).
- E-24 (EIGENES Fenster nach W10, Option C', Dossier 20260803-e24_...): Major 7->8 = LETZTER ABI-Schritt vor Trigger,
  EIN S12-Fenster, Cross-Genus via OrganConcept; A8-KOPPLUNG: binary-beruehrende A8-Scheiben S1/S3/S4/S5 VOR dem
  Anker-Vollzug; Graph-Gattung nach Abgabe (Q5).
- A2-SHA512-only-Skip-Gate: Eichung EINMALIG ZULETZT nach W10+E-24; danach TP1-FINAL-Inventur.

## PHASE 3 — Parallel-Spuren (Mo-Mi, disjunkt zu Phase 1/2)
A8-Schnitt (Dossier liegt) · A9-xlsx (Dossier liegt) · A7/E-04-Rest (P2/P3/P4 + Z-05/06/08 + E-18) ·
A14/OS-U4 (+Z-04-Tests) · A15 FK-3/FK-4 · A10 HW P4-P6 + prod2-SPD-Beweis · A11 + A12 NAS-Creds ·
E-19 Stufe 1 (Infra) · Thesis C1-Rest, C2 beim Einfrieren, D-07 nach A4.

## PHASE 4 — Beweise + Permutationen (Mi 06.)
A3/Beweise 1-5 (B5 zweistufig nach NEUER E-07-Gate-Definition) + §61-Dual-Weg-Beleg · A4/12-Perm (O0-O3 x
{no_ext,avx2,avx512}, >=16 Anker; darin 2d-FS1-Messpfad-Test) · A5 ETA/Kalibrier-Prinzip (F5/F6).

## PHASE 5 — Trigger-Sequenz (Do 07.08., AUTONOM)
J-Kette (N = lebendes ctest-Gate, LIVE erheben; V32=ON nur CI-Kanon) -> heavy-Signal (#519) -> Kalibrierlauf
GN_TOTAL=64 -> ETA -> VOLL-BAU-4-TRIGGER (POST 288: GN_TOTAL=131072 x 12 Perms = 1.572.864 Binaries,
4096er-Meilensteine, Bestandslog AN, VARIANT_GATE=true, keine toten Vars, Endpoint-Preflight).

## PHASE 6 — Nach Trigger (Fr 08.08.; Messung USER-GO)
E.0 KERN-Mess-Schema = PFLICHT vor jeder Messung (K4-Naht in den Director, K5 produktiv + Generalisierung,
per-Achse-Modi im Abgabeprofil) -> 320er-Abgabemessung (GO) -> Voll-Messung (GO) -> Rueckschrieb (NAS/minio)
-> Auswertung (xlsx-Baum, Spline, Break-Even) -> Hybrid HY-B1a.. -> COMPARE/D2 -> Thesis C5.
Weitere: #48-Scheibe-6, §61-Release-Wallclock, #51, FS2-Haertung, Overlay-Fenster (3 Owner-Festlegungen),
f2/f3-Remote-GOs, #327-Rotation.

## PHASE 7 — ZULETZT
§75-Aufraeumpass: deprecated Header + toter Code ENTFERNEN; Kandidaten (1)-(24) inkl. 7 Waisen-TUs,
stale Haupt-build/, Stamp-Write-Checks, ASCII-Altbestand.

**Kritischer Pfad:** OD-10-RT -> Lager-Rest (F3 zuerst) -> W10 -> E-24 (+A8-Scheiben) -> A2-Eichung ->
Beweise -> 12-Perm -> J-Kette -> heavy -> Kalibrier -> TRIGGER Do 07.08. -> E.0 -> Messung (USER-GO).

---
## NACHTRAG 04.08. frueh — PhasenCheck-Luecken L1-L22 EINGEARBEITET (Bericht: backups/20260803-od10-rt-welle/phasencheck-bericht.md; 14 trigger-relevant)

### Trigger-relevante Ergaenzungen (bindend)
- **PHASE 5 += L1 TRIGGER-AUFLAGEN-SATZ WOERTLICH (LEDGER:98, alle SIEBEN):** PMC-AND hart (Vendor-Zuordnung vorher belegen — I112:204-212!) · COMDARE_MINIO_ENDPOINT = Alias, NIE S3-URL · NAS = PR4100 Cluster_NFS + df-WACHE · Bestands-Invalidierung · github-PAT NEU aus Vault · main-Nachzug je Welle · keine schweren Parallel-Jobs.
- **PHASE 5 += L2 G6/J-0..J-5-Bau-Hygiene:** Alt-Build-Dir=GIFT, Werkzeuge zuerst, Re-Configure, Facade explizit, Test-Zahl N mitmelden (Beleg LEDGER:3631: frisches Dir lieferte 322 statt 326). += L11/D-10: 46er-Differenz-Eichung (lokal 331/332 vs. prod 285, Labels contract|pmc zaehlen) als Phase-5-VORLAUF.
- **PHASE 1 += L3 MANAGER-ENTSCHEID (hiermit gefaellt, K1-konform):** Das Lager reserviert KEIN Hybrid-Segment; die Lager-Identitaet der Hybrid-.so ist ein EIGENER Entscheid im Hybrid-B-Fenster (Auswertungsphase). Bis dahin darf kein Lager-Schema Hybrid-Knoten annehmen — der LB-Schnitt baut ausschliesslich die zwei Realm-Wurzeln der plain-Tier-Welt. (Deckt Dossier-K1-Auflage; Umkehr-Risiko beseitigt.)
- **PHASE 1 += L9:** B2-Kontraktpruefung des REALEN Aufrufers Code/02_messung_driver/main.cpp:1239 gegen den werfenden ArtefaktPushFehler-Kontrakt (Lage-Dossier §3.6.5) — in die Lager-Rest-Welle.
- **PHASE 1/3-KANTE += L5 MANAGER-ENTSCHEID (hiermit gefaellt):** lager_pfad_grammatik.hpp hat EINEN Owner = die A1-LB-Schnitt-Welle (Phase 1). A9-S2 KONSUMIERT die Datei und startet erst nach dem LB-Schnitt-Kern (kein Fork, A9-OP-2).
- **PHASE 2 += L4:** E-24 braucht VOR dem Fenster einen eigenen FENSTER-BAUPLAN (ultracode-Planungssession: Detail-Schnitt je Genus, Commit-Zug, Orakel-Definitionen, FK-ID-Vergabe; erst der liefert die Zeitschaetzung, E24-Dossier:176/OP-7). Die ABI-neutrale M0-Vorstufe (organ_concept.hpp) ist SOFORT parallelisierbar -> Phase 3.
- **PHASE 2 += L14 Deklarationssatz:** Das A2-Skip-Gate wird MIT LEEREM Overlay-Glied (5./6. Preimeage-Glied traegt nur Separator+Format) geeicht und faehrt so durch den Voll-Bau; ABNAHME-3/4-Voll-Soll erfuellt sich erst mit dem Overlay-Fenster (Phase 6) = deklarierte, nicht stille Luecke.
- **PHASE 3 += L6 VORRANG:** A8-S1 VORZIEHEN — bestaetigter T17-Messwert-Verlust (drei <17-Schleifen bei kV3AxisCount=18: abi_adapter.hpp:861/:1687, node_value_measurement.hpp:72-75, DEFEKT CONFIRMED); Laufzeit-Beleg LITERAL VOR dem Fix (A8:414). MUSS vor jeder Messung weg.
- **PHASE 3 += L7 ENTSCHEID (hiermit, aus der Fahrplan-Ordnung):** A8-Scheiben laufen in Phase 3 VOR E-24-Anker (binary-beruehrend S1/S3/S4/S5 = Teil der E-24-A8-Kopplung); OF-A8-2 (E1-Lesart 'CEB orchestriert, Zeitnahme im Tier') gilt per Owner-GO ~17:4x-Defaults als gedeckt — als NUR-KENNTNIS im naechsten Owner-Block. += L12: OS-U5 (Doku/OP-10-Supersede) an OS-U4 anhaengen; Codex-Zweitlens Z-02/Z-03 sobald funktionierende Codex-Umgebung (Merkposten). += L8: E-19-Handout-BRING ins Cluster = SOFORT (siehe Vollzug unten).
- **PHASE 4 += L10:** B5.b bindet an die EINGEFRORENE Trigger-Linie nach M3+E-24, Pflicht-Re-Run <1h, Re-Anker aller datei:zeile-Anker + Probe-Harness (E07-Dossier:89-125).
- **L13 ENTSCHEID (hiermit):** O-6-Kanal-Merge + OD-1-Ratifikation bleiben owner-gegatet; da das SIMD-Gate heute INERT ist und KEINE Scharfschaltung vor dem Trigger geplant ist, ist die KATALOG-G.5-Einstufung nach-Abgabe SACHLICH konsistent — ausdruecklich so verbucht (keine stille Herabstufung mehr; Scharfschaltung ohne O-6 bleibt verboten).

### Nicht trigger-blockierend (verortet)
- **PHASE 3 += L15:** Thesis C4 (Owner) / C6 (Infra #375/#377) / C7 (chktex-Haertung, nice-to-have); Uebergabe-Klausel 'thesis-Gitlink bleibt alt bis Identity-Normalisierung' war durch den 29a1700-Bump faktisch superseded — hiermit AUFGELOEST (der Bump war E-02-/Landungs-gedeckt; Identity-Normalisierung bleibt Infra-Posten C6).
- **L16 prtart-Gitlink:** Vollzug JETZT (unten). **L17 Overleaf-Klon** (~22 Commits zurueck): eigener Sync-Posten nach C6/Identity (4-Klone-Regel; outward-Push bleibt Owner-gated).
- **PHASE 5/6 += L18:** Post-v3 R1 (.so-ABI Planer<->CEB) = nach Abgabe (KATALOG G.3); R3-CLI-Reste (--print-env, --status-Aggregator, ETA/JSON-Marker) an Phase-5-ETA + Phase-6-E-04 anheften.
- **PHASE 7 += L19:** Kandidaten (25) Achsen-Zahl-Banner Nachschlagewerke · (26) Alt-CRC 0xF1C1F26A... in 6 ce-Kommentaren · (27) axis_hierarchy_summary.cmake topics-GLOB · (28) 'drei Modi'-Doku x7 nach COMPARE · (29) FS4/TOCTOU (LEDGER:3711-Zusage, jetzt nummeriert).
- **NEU: PHASE 6.5 NACH-ABGABE-BEHAELTER (L21, Owner H.7 'Rest nach Abgabe ebenfalls PFLICHT'):** E-01, E-03, E-06, E-16, E-17, E-25, E-26 · G5/Matrix-Zergliederung · §65 #32 Tools-Lagerhaltung · §73.1 Ein-Hauptkanal · §73.5 Q6 · §69.9 C-3a (Gate C-3b+O-4) · §70.4 RF-4/§73.3 Q4 · f2/f3-Remote-GOs · O-6/OD-1-Ratifikation · R1.
- **NEU: PHASE 0.5 HYGIENE-BLOCK (L20, GATE-0-Entsprechung; laeuft nebenher, nie auf dem kritischen Pfad):** Memory-Nachtraege 4-Pfad-Ledger-Pflicht (2 Dateien) · Kopf-Klauseln super+ce + 5-Pfad-Audit-Vermerk · Worktree-Aufraeumung (14 gelandete von 21 wt-*) · Scratchpad-Sweep · Rest-Stack-Konsolidierung · 6 Commit-Referenz-Diskrepanzen (gering).
- **L22:** STRUKT-R-Komplett-Quittung (R-A..R-F am Ist system_axis_order.hpp:41-44 + Wachen :102-110) — EINMALIGER Verifikations-Vermerk in die naechste Ledger-Welle.
