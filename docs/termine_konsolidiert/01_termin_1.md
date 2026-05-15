# Termin 1 — 2026-03-30

**Stand:** 2026-05-15 (K-G.2)
**Hauptthema:** Architektur-Konzept Erstgespraech (PRT-ART CPU-only Pivot)
**Office-Dokumente:** 3 (alle in `../termine/20260330 Termin 1/`)

---

## §1 Office-Dokumente (Original)

| Datei | Inhalt |
|---|---|
| `20260326 Expose_Diplomarbeit_PRT_ART_CPU_only_Habich_HOT_cacheline_final.docx` | Initial-Expose (Pivot von suchnahe Operatoren zu PRT-ART CPU-only) |
| `20260330 Literatur_und_Arbeitsplanung_PRT_ART_Termin1_START_CoCo_sort_compact.docx` | Literatur + Arbeitsplan (START + CoCo + sort_compact) |
| `20260330 PRT_ART_Technische_Skizze_Habich_termin1_START_CoCo_sort_compact.docx` | Technische Skizze (HOT + cacheline-Awareness) |

---

## §2 Was besprochen wurde

- **Pivot:** Von "suchnahe Operatoren" zu "PRT-ART CPU-only" (Cache-Engine fuer Trie-basierte Indizes)
- **CPU-only:** Keine GPU-Beschleunigung — Fokus auf CPU-Cache-Hierarchie
- **Habich-Zusatz:** HOT (P02) + cacheline-Awareness (Cache-Line-Granularitaet)
- **START + CoCo + sort_compact:** Konsolidierte Bausteine-Familien als Diskussionsgrundlage

---

## §3 Was entschieden wurde

- PRT-ART als Diplomarbeit-Thema verankert
- 33-Paper-Korpus skizziert (P01 ART + P02 HOT + P05 START + P04 CoCo etc.)
- HOT als Habich-Zusatz-Schwerpunkt

---

## §4 Was im Termin ENTSTAND

| Artefakt | Stand |
|---|---|
| Begriffsglossar | Domaenenmodell-Vorstufe (v1, 496 Z) |
| Domaenenmodell | v1 (623 Z) |
| Quellen-Skizze | Initial-Liste der 33 SOTA-Paper |

---

## §5 Wie implementiert wurde (Bezug zu V-Sprints)

V1-V11 (siehe `HABICH_TERMIN7_ZUSAMMENFASSUNG_2026_05_13.md`):
- V1: cache-engine Library + E2E "Demo pipeline OK"
- V2: Diplomarbeit/Code/ Submodule init
- ...

---

## §6 Querverweise

- Original-Termin-Verzeichnis: `../termine/20260330 Termin 1/`
- Termin-2 Folgegespraech: `02_termin_2.md`
- Quellen-Gesamtkatalog: `../forschungslandkarte/01_quellen_gesamtkatalog.md`
- Begriffsglossar Vorstufe: `../glossar/01_begriffsglossar_v7_master.md` (siehe Tabelle Versions-Stack v1)
- Domaenenmodell v1: `../glossar/02_domaenenmodell_v4_master.md` (siehe Tabelle Versions-Stack v1)
