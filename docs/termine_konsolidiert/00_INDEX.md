# docs/termine_konsolidiert/ — Index

**Stand:** 2026-05-15 (K-G.1)
**Phase:** K-G des Master-Plans `../MASTERPLAN_KONSOLIDIERUNG_TERMINE.md`
**Zweck:** Pro Termin (1-8) ein Master-Snapshot mit Datum + Was-besprochen + Was-entschieden + Wie-implementiert.

---

## Inhalte

| Datei | Termin | Datum | Hauptthema | Office-Dokumente (Original) |
|---|---|---|---|---|
| `01_termin_1.md` | 1 | 2026-03-30 | Architektur-Konzept Erstgespraech (PRT-ART CPU-only Pivot) | 3 .docx |
| `02_termin_2.md` | 2 | 2026-03-30 | Folgegespraech mit Architekturentscheidungen | 3 .docx/.pptx |
| `03_termin_3.md` | 3 | 2026-04-09 | Benchmark- und Datensatzplan | 3 .docx/.pptx |
| `04_termin_4.md` | 4 | 2026-04-12 | Cache-Engine Forschungslandkarte (Initial) + Scope-Freeze | 4 .docx/.pptx |
| `05_termin_5.md` | 5 | 2026-04-12 | Forschungslandkarte vertieft (Folge zu T4) | 4 .docx/.pptx |
| `06_termin_6.md` | 6 | 2026-04-16 | Architektur REV4 + Scope-Freeze final + UML-Vorbereitung | 3 .docx/.pptx |
| `07_termin_7.md` | 7 | 2026-05-08 | UML-Detail (REV5-REV7.6) + Habich-Direktiven + 33-Paper-Cluster | 30+ .md (kein Office-Trio) |
| `08_termin_8.md` | 8 | 2026-05-15 | V12-V31 Stand: 22 Adapter, libs/-Migration, P27 hp-soft, Architekt-Direktive II | 3 .md+.docx/.pptx |

**Total:** 9 Konsolidierungs-Doks (1 INDEX + 8 Termine).

---

## Memory-Direktive beachtet

Original-Termin-Dokumente unter `../termine/{Datum} Termin N/` bleiben **VOLLSTAENDIG**
erhalten. Konsolidierte Termin-Snapshots unter `docs/termine_konsolidiert/`
referenzieren nur (Pfad pro Office-Dokument), kopieren nicht.

---

## Pro-Termin Struktur

Jedes `0N_termin_N.md` enthaelt:

1. **Datum + Stand** — wann fand der Termin statt
2. **Office-Dokumente (Original)** — Liste der .docx/.pptx mit Pfad
3. **Was besprochen wurde** — Hauptthemen + Diskussionspunkte
4. **Was entschieden wurde** — kanonische Beschluesse, mit Verweis auf Architekturentscheidungen F1-F15 oder Habich-Direktiven
5. **Was im Termin ENTSTAND** — Glossar-Versionen, Domaenenmodell-Versionen, Bausteine, Architektur-REVs
6. **Wie implementiert wurde** — V-Sprints, die diesen Termin operationalisierten
7. **Querverweise** — auf docs/architektur/, docs/glossar/, docs/bausteine/, docs/forschungslandkarte/

---

## Querverweise

- Master-Plan: `../MASTERPLAN_KONSOLIDIERUNG_TERMINE.md`
- Termine-INDEX (Original-Verzeichnis): `../termine/INDEX.md`
- Architektur REV-Historie: `../architektur/01_REV_Historie.md`
- Glossar-Versionshistorie: `../glossar/03_versionshistorie.md`
- F1-F15 Architekturentscheidungen: `../bausteine/04_architekturentscheidungen_F1_F15.md`
- Forschungslandkarte: `../forschungslandkarte/`
