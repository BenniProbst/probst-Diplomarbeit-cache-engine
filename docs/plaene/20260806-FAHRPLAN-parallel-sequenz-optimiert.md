# FAHRPLAN 06.08.2026 (Lead-Synthese aus ultracode-Design: aggressiv+sicher konsolidiert)

> Quellen: backups/20260806-fahrplan-design/ (3 Lenses + 2 Entwuerfe) + backups/20260806-e1e4-ueberschneidungen/ (Ist-Abgleich+Karte). Owner-Auflagen frueh-6/-7/-9 bindend. Frist: Trigger Do 07.08., Abgabe Fr 08.08.

## Leitplanken (jede Welle)
1. CPU: max EIN ce-Voll-Gate (-j6 nice, 2-Pass-Configure, Doppellauf 2x seriell) + max EIN super-Slot (-j3 nice); ohne Voll-Gate max zwei -j3.
2. Landebahn: EIN Koordinator (Lead), Landungen streng seriell, jeder Merge genau einmal; vor Landung Merge dev->Branch (nie rebase) + Dual-Review + Voll-Gate + Pipeline hart gruen + Backup + Ledger.
3. TABU bis Buendel-Landung L1: die 3 C-3-Dateien + alle Neuanker-Naht-Dateien.
4. Nichts auslassen; Shortcut=Regression+TODO; P2-P8+A1+B14+Lager-Geruest VOR Messbeginn; Posten 92 vor Abgabe; Phase 6 = USER-GO-STOPP.

## DAG (Ist: zwei Slots belegt)
- **CE-SLOT (laeuft):** T2-Welle wf_996f7155 (Merge 7969b399 + C-3 F1/F4 Zaehler-Resume + per-Perm-Glieder + RT-Realversions-Sonde + NB-3-Haertungen + C-4-Rest) -> Dual-Review -> **L1 Buendel-Landung KOMPLETT** (Lead) -> TP1+4+1 EINMAL -> **P92** (S; validate-2er vs plan-3er) -> **B13** (L; Re-Anker-Pass, Plan fertig) -> **A1-Scheibe** (M; Wurf-Vertrag 64/71-74) -> P2-P8-Bau-Anteil ce.
- **SUPER-SLOT (laeuft):** honest-empty wf_ca7f3d30 -> **B14+KF-6-XML** (S-M; GOLDEN-XML-Abgleich + line_sizes-Vollausbau A4, jederzeit einschiebbar, Re-Check nach L1 als Auflage) -> **E18-SNAP** (Annahme measurement/thesis_compiles/, unwidersprochen=bauen) -> Lager-Kaskaden+xlsx-GERUEST (B12-Geruest VOR Messbeginn; Fuellung waehrend/nach Messung).
- **READ-ONLY (frei, sofort):** P2-P8-Katalog-Klaerung (Katalog-Quelle in A8-S3-Backups lokalisieren + Schema-Delta beziffern) -> speist den P2-P8-Bau.
- **Danach P3:** Trigger (GOLDEN-XML=Input) -> Voll-Bau-4 (Zaehler-Resume-Batches) -> Phase 6 = USER-GO-STOPP.
- **P4-Band nach Trigger:** Graph-Umbau (SOTA-Katalog liegt), B-5-Lebend-Check, B12-Fuellung, B-Rest B2/B3/B4/B8/B9/B11.

## E1-E4-Strang: AUFGELOEST (Owner-GO frueh-16, Ist-Abgleich 06.08.)
6/8 Dossier-Pakete ERLEDIGT/SUPERSEDED (Teil B, G2, #188, #221, #223 binnen 09.-11.07.; #31-Workload heute E4-XML-Alleinweg, Legacy nur Opt-in; XSD-Bedarf in experiment_schema.xsd aufgegangen); #215 = Voll-Bau-4 (P3); Residuen bereits im Board (P92, honest-empty-Familie); measurement-all-Vokabular bleibt korrekt gated (Schritt 13). KEIN eigenstaendiges offenes Dossier-Paket.
