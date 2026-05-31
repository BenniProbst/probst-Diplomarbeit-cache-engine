# docs/architektur/ — Index

> ⚠️ **SUPERSEDED (2026-05-31):** Überholter Planungs-/Architektur-Stand (axis-zentrische Restruktur F.2, Plugin-Prüfling-Modell, DLL-F15-Pipeline, sezierte Organe). IST-treue Single-Source-of-Truth: `comdare-cache-engine/docs/sessions/architektur-ziele-offene-punkte-ledger.md` + `…/20260531-e2e-abnahme-audit-und-entscheidungen.md`. Niemals löschen — nur Banner.

**Stand:** 2026-05-15 (K-C.1)
**Phase:** K-C des Master-Plans `../MASTERPLAN_KONSOLIDIERUNG_TERMINE.md`
**Zweck:** Konsolidierte Architektur-Doku der Diplomarbeit mit REV-Historie + aktueller Master-Stand + Konzepte + UML + ER + Cross-Refs.

---

## Inhalte

| Datei | Inhalt | Quellen (Termin 7) | LOC Original |
|---|---|---|---|
| `01_REV_Historie.md` | REV3 → REV4 → REV5 → REV6 → REV7 → REV7.6 → REV7.7 (V12-V31 Stand) Verlauf | Doks 20-24, 30 | ~3.000 |
| `02_aktueller_master_REV7_7.md` | KONSOLIDIERTER Master-Stand: REV7 + 6 Deltas (25-30) + V12-V31 Code-Stand | Doks 24, 25-30 + Sessions | ~1.700 |
| `03_konzepte_saeule_a.md` | Such-Algorithmen-Konzepte (Saeule A) | Doks 11, 12 | ~1.500 |
| `04_konzepte_saeule_b.md` | Plattform-Modell (Saeule B) | Doc 13 | 631 |
| `05_uml_klassen.md` | Konsolidierte UML-Klassen-Doku (Search Engine, Cache Engine, Measurement, Hardware/ISA, Engine-Choice/Builder, Persistence) | Doks 01-06 | ~1.700 |
| `06_er_modell.md` | Entity-Relationship-Modell (ER) | Doc 07 | 281 |
| `07_cross_reference.md` | Cross-References zwischen Saeulen + Bausteine_Matrix-Achsen ↔ UML-Klassen ↔ ER-Entitaeten | Doc 08 | 129 |
| `08_drawio_export.md` | Drawio-Export-Strategie + Verweis "REV7-drawio noch zu erstellen, Phase K-H" | Doc 09 | 162 |
| `09_taxonomien.md` | Cache-Strategie-Taxonomie + Algorithm-Strategie-Taxonomie konsolidiert | Doks 11, 12 | ~1.500 |

**Total:** 9 Konsolidierungs-Doks aus 24 Quell-Doks (~9.674 Zeilen Original).

---

## Memory-Direktive beachtet

Original-Quellen unter `../termine/20260508 Termin 7/Phase5_UML_Detail/` bleiben **VOLLSTAENDIG**
erhalten (Doks 00-30). Konsolidierte Master-Doks unter `docs/architektur/` referenzieren
nur (Pfad+Zeile), kopieren nicht voll-Inhalt.

---

## REV-Historie (Kurz)

| REV | Datum | Doc | Hauptaenderung |
|---|---|---|---|
| REV3 | 2026-05-10 | Doc 20 | Erste vollstaendige UML-Skizze, 3 Saeulen-Architektur |
| REV4 | 2026-05-10 | Doc 21 | drawio XML-Fix, orthogonale Edges, Konzept/UML-Trennung, Layer-Matrix-Hybrid |
| REV5 | 2026-05-11 | Doc 22 | Termin 1+2+3+4 Doks integriert; 33-Paper-Matching pro Saeule |
| REV5.1 | (intern) | (in REV6) | Web-Recherche Cache Lines + Facade Pattern + Masstree INode/Fanout-Korrektur K02 |
| REV5.2 | (intern) | (in REV6) | State-Pattern + Visitor-Pattern + U09 klassisches UML |
| REV5.3 | (intern) | (in REV6) | K07/K08 Splitting in K07a-d / K08a-d |
| REV6 | 2026-05-11 | Doc 23 | Korrekturen REV5 + Drei-Repo-Architektur |
| REV7 | 2026-05-13 | Doc 24 | Custom Allokation (21 Allokator-Paper) + ABI-stabiles C++23-Modul-Interface |
| REV7.1 | 2026-05-13 | Doc 25 | hybride PrtArtSearchEngine (Vector/Map/Tuple + status_t errno-style) |
| REV7.2 | 2026-05-13 | Doc 26 | legacy_reimpl-Migration |
| REV7.3 | 2026-05-13 | Doc 27 | YCSB-CLI Konzept |
| REV7.4 | 2026-05-13 | Doc 28 | CMake-Pipeline Konzept |
| REV7.5 | 2026-05-13 | Doc 29 | Phase 4-7 Loader Konzept |
| REV7.6 | 2026-05-13 | Doc 30 | Drei-Repo-Layer (Diplomarbeit Code/ als Anwender-Schicht) |
| REV7.7 | 2026-05-15 | (in `02_aktueller_master_REV7_7.md`) | V12-V31 Code-Stand integriert (libs/-Migration, 22 V31-Adapter, NOTICE Architekt-Direktive II, P27 hp-soft) |

Detail siehe `01_REV_Historie.md`.

---

## Querverweise

- Master-Plan: `../MASTERPLAN_KONSOLIDIERUNG_TERMINE.md`
- Glossar (Begriffe + Domaenenmodell): `../glossar/` (K-D)
- Bausteine (85 Bausteine + 25 ADRs): `../bausteine/` (K-E)
- Forschungslandkarte (33 Paper Cluster): `../forschungslandkarte/` (K-F, in Arbeit)
- Termine-Konsolidiert: `../termine_konsolidiert/00_INDEX.md` (K-G, geplant)
- drawio: `../termine/20260508 Termin 7/Phase5_UML_Detail/phase5_uml_detail_REV6.drawio` (REV7 in Phase K-H)
- thesis Manuskript Kapitel 03+04: `../../thesis/chapters/03_architektur.tex` + `04_implementation.tex`
