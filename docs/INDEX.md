# docs/ — Top-Level Index

**Stand:** 2026-05-15 (K-I.1)
**Zweck:** Top-Level-Inhaltsverzeichnis aller `docs/`-Unterordner.

---

## §1 Pflicht-Pre-Read

Vor jeder neuen Session zuerst:
1. `MASTERPLAN_KONSOLIDIERUNG_TERMINE.md` (10-Phasen-Plan K-A bis K-J)
2. `termine/INDEX.md` (Termin-Verzeichnis 1-8 mit Vor-Termin-Vorbereitungs-Doku)
3. `~/.claude/.../memory/MEMORY.md` (aktive Direktiven)
4. Letzte 3 Session-Doks aus `sessions/` (chronologisch absteigend)

---

## §2 Verzeichnisstruktur

| Verzeichnis | Status | Phase | Inhalt | Anzahl Doks |
|---|---|---|---|---|
| `MASTERPLAN_KONSOLIDIERUNG_TERMINE.md` | ✅ | K-A | 10-Phasen-Konsolidierungs-Plan | 1 |
| `NAMING_CONVENTIONS.md` | ✅ (V12.5) | (vor K-A) | Naming-Konventionen | 1 |
| `anleitung_messwerte_erzeugen.md` | ✅ (2026-06-03) | — | Kommandozeilen-Anleitung: echte Messwerte aus cache-engine-Tieren erzeugen (Sicht Mess-Anhang) | 1 |
| `glossar/` | ✅ | K-D | Begriffsglossar v7 + Domaenenmodell v4 + Versionshistorie | 4 |
| `bausteine/` | ✅ | K-E | Bausteine + Allokator + Cross-Paper + F1-F15 + Flag-System + Eigenschaften | 7 |
| `architektur/` | ⏳ in Arbeit | K-C | REV-Historie + REV7.7-Master + UML + ER + Cross-Refs + Taxonomien | 0/10 |
| `forschungslandkarte/` | ⏳ in Arbeit | K-F | Quellen-Gesamt + 6 SOTA-Cluster + Allokator-Cluster | 0/9 |
| `termine_konsolidiert/` | ⏳ in Arbeit | K-G | INDEX + 1 Doku pro Termin 1-8 | 0/9 |
| `termine/` | ✅ (refresh K-B) | K-B | Original-Termin-Verzeichnisse 1-8 + INDEX | 8 Termine + INDEX |
| `sessions/` | ✅ (laufend) | (kein K) | V8-V31 Anker + Final + Fortschrittsdokumentationen | ~80 |

---

## §3 Master-Doks pro Phase (was ist DONE)

### K-A (Termin-8-Vorbereitung) — DONE ✅
- `termine/20260515 Termin 8/Arbeitsplan_Termin8.md` + `.docx`
- `termine/20260515 Termin 8/Arbeitsergebnis_Termin8.md` + `.docx`
- `termine/20260515 Termin 8/Praesentation_Termin8.md` + `.pptx`
- `termine/20260515 Termin 8/_archive_chatgpt/` (3 archivierte Versuche)
- NACHTRAG-Sektionen in `termine/20260508 Termin 7/HABICH_TERMIN7_*.md` und `HABICH_TERMIN8_*.md`

### K-B (INDEX-Refresh) — DONE ✅
- `termine/INDEX.md` mit 8 Terminen + Tag-Liste pro Termin

### K-D (Glossar) — DONE ✅
- `glossar/00_INDEX.md`
- `glossar/01_begriffsglossar_v7_master.md` (~161 KANON-Begriffe)
- `glossar/02_domaenenmodell_v4_master.md`
- `glossar/03_versionshistorie.md`

### K-E (Bausteine) — DONE ✅
- `bausteine/00_INDEX.md`
- `bausteine/01_bausteine_matrix.md` (85 Bausteine, 11 Achsen)
- `bausteine/02_allokator_matrix.md` (23 Allokatoren, 7 Achsen, 5 Cluster)
- `bausteine/03_cross_paper_konzeptmatrix.md` (18 Konzepte ueber 33 Paper)
- `bausteine/04_architekturentscheidungen_F1_F15.md` (25 ADRs)
- `bausteine/05_flag_system.md` (9-Bank Permutations-ID)
- `bausteine/06_eigenschaften_suchalgorithmen.md` (23 Algorithmen)

### K-J (Termin-7-Trio) — DONE ✅
- `termine/20260508 Termin 7/Arbeitsplan_Termin7.md` + `.docx`
- `termine/20260508 Termin 7/Arbeitsergebnis_Termin7.md` + `.docx`
- `termine/20260508 Termin 7/Praesentation_Termin7.md` + `.pptx`

---

## §4 Pending Phasen (zur kuenftigen Bearbeitung)

### K-C (Architektur) — pending
24 Quelldokumente in `termine/20260508 Termin 7/Phase5_UML_Detail/`
→ konsolidiert in `architektur/00_INDEX.md` bis `09_taxonomien.md` (10 Doks).

### K-F (Forschungslandkarte) — pending
33 Paper-Cluster + 23 Allokator-Cluster
→ konsolidiert in `forschungslandkarte/00_INDEX.md` bis `08_allokator_cluster_AC1_AC5.md` (9 Doks).

### K-G (Termine-Konsolidiert) — pending
ALLE 7 Termin-Verzeichnisse vollstaendige Tieflektuere
→ konsolidiert in `termine_konsolidiert/00_INDEX.md` bis `08_termin_8.md` (9 Doks).

### K-H (drawio REV7) — pending
REV6 als Basis erweitern + 4 NEUE Tabs (REV7-Master, Adapter-Familie, P27-Bundles, libs/-Layout)
→ `termine/20260508 Termin 7/Phase5_UML_Detail/phase5_uml_detail_REV7.drawio`.

### K-I (Cross-Refs) — TEILWEISE done (dieses INDEX = K-I.1)
Restliche Sub-Tasks K-I.2 (thesis-Refs), K-I.3 (Sessions-Refs), K-I.4 (Memory) — in Arbeit.

---

## §5 Code-Repos (Drei-Repo-Architektur)

| Repo | Pfad | Rolle | HEAD (Stand 2026-05-15) |
|---|---|---|---|
| Diplomarbeit (Anwender) | `.` (dieser Ordner) | WAS + Auswertung | `0f7b4d2` (K-D + K-E + K-B + K-J committed) |
| comdare-cache-engine | `Code/external/comdare-cache-engine/` | WIE + Werkzeuge | `16176ee` (V31.F) |
| comdare-prt-art | `Code/external/comdare-prt-art/` | Pruefling | `1a36ab4` (V31.F Pin) |

---

## §6 Querverweise

- **Master-Plan:** `MASTERPLAN_KONSOLIDIERUNG_TERMINE.md`
- **Memory-Direktiven** (im User-Profil): `~/.claude/.../memory/MEMORY.md`
- **Manuskript:** `../thesis/main.pdf` (24 Seiten, V31.I-Update)
- **Code (Diplomarbeit-Wrapper):** `../Code/`
- **Forschungs-PDFs:** `../Forschungsarbeiten/`
