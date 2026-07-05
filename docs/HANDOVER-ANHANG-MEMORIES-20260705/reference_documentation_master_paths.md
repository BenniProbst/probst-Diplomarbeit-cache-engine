---
name: reference-documentation-master-paths
description: Diplomarbeit 2026-05-15 — Pfade zu allen konsolidierten Master-Doks unter docs/ (K-A bis K-J)
metadata: 
  node_type: memory
  type: reference
  originSessionId: 3d9bd0e7-eeb3-411a-b116-64eef696e0f6
---

Konsolidierte Master-Doks der Diplomarbeit unter `Diplomarbeit - Datenbanken/docs/`.
Pflicht-Pre-Read fuer alle kuenftigen Sessions zur Diplomarbeit.

**Top-Level:**
- `docs/INDEX.md` — Top-Level Inhaltsverzeichnis (K-I.1)
- `docs/MASTERPLAN_KONSOLIDIERUNG_TERMINE.md` — 10-Phasen-Plan K-A bis K-J
- `docs/NAMING_CONVENTIONS.md` (V12.5)

**Glossar (K-D, DONE):**
- `docs/glossar/00_INDEX.md`
- `docs/glossar/01_begriffsglossar_v7_master.md` (~161 KANON-Begriffe)
- `docs/glossar/02_domaenenmodell_v4_master.md`
- `docs/glossar/03_versionshistorie.md`

**Bausteine (K-E, DONE):**
- `docs/bausteine/00_INDEX.md`
- `docs/bausteine/01_bausteine_matrix.md` (85 Bausteine, 11 Achsen)
- `docs/bausteine/02_allokator_matrix.md` (23 Allokatoren, 7 Achsen, 5 Cluster)
- `docs/bausteine/03_cross_paper_konzeptmatrix.md` (18 Konzepte ueber 33 Paper)
- `docs/bausteine/04_architekturentscheidungen_F1_F15.md` (25 ADRs)
- `docs/bausteine/05_flag_system.md` (9-Bank)
- `docs/bausteine/06_eigenschaften_suchalgorithmen.md` (23 Algorithmen)

**Architektur (K-C, pending):**
- `docs/architektur/00_INDEX.md` (geplant)
- `docs/architektur/01_REV_Historie.md` (geplant)
- `docs/architektur/02_aktueller_master_REV7_7.md` (geplant)
- (siehe Master-Plan §1 Phase K-C fuer komplette Liste)

**Forschungslandkarte (K-F, pending):**
- `docs/forschungslandkarte/00_INDEX.md` (geplant)
- `docs/forschungslandkarte/01_quellen_gesamtkatalog.md` (33 Paper P01-P33 + 23 Allokator A01-A23 mit Vollangaben)
- (siehe Master-Plan §1 Phase K-F fuer komplette Liste)

**Termine-Konsolidiert (K-G, pending):**
- `docs/termine_konsolidiert/00_INDEX.md` (geplant)
- `docs/termine_konsolidiert/01_termin_1.md` bis `08_termin_8.md` (geplant)

**Termine-Original (K-B, refresh DONE):**
- `docs/termine/INDEX.md` (8 Termine + Office-Dokumente-Liste + Tag-Liste pro Termin)
- `docs/termine/20260330 Termin 1/` bis `docs/termine/20260515 Termin 8/`

**Sessions:**
- `docs/sessions/` mit V8-V31 Anker + Final + Fortschrittsdokumentationen

**Konfliktregel pro Phase:** spaetere Version gewinnt
- Begriffsglossar: v7 > v6 > v5 > v4 > v3
- Domaenenmodell: v4 KORREKTUR > v3 Original
- Architektur: REV7.7 > REV7.6 > REV7 > REV6 > REV5 > REV4 > REV3

**Memory-Direktive "niemals Doku loeschen":** Original-Quellen unter
`docs/termine/...` bleiben unveraendert. Konsolidierte Master-Doks unter
`docs/glossar/`, `docs/bausteine/`, `docs/architektur/` etc. referenzieren
nur (Pfad+Zeile), kopieren nicht voll-Inhalt.

**Verwandte Memory-Direktiven:**
- [[reference-konsolidierungs-masterplan]] (Phasen-Beschreibung K-A bis K-J)
- [[feedback-never-delete-documentation]] (Doku bleibt erhalten)
