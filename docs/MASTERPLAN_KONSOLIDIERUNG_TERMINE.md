# Master-Plan: Konsolidierung der Termin-Dokumente in `docs/`

**Status:** ANKER-DOKUMENT (zu Beginn jeder Konsolidierungs-Session lesen!)
**Erstellt:** 2026-05-15 (Termin 8 Vorbereitung)
**Verantwortlich:** Diplomarbeits-Author (Pruefling), unterstuetzt durch Code-Agent
**Zweck:** Vollstaendige, strukturierte Konsolidierung aller Termin-1- bis Termin-7-
Dokumente (und kuenftiger Termin-8+) in stabile, allgemein verwendbare
Diplomarbeit-Dokumentation unter `docs/` — mit Quellenangaben, Versions-
Konsolidierung (z.B. Begriffsglossar v2-v7 → v7 als Master) und Cross-References.

---

## §0 Pflicht-Lese-Liste fuer JEDE Konsolidierungs-Session

Jede neue Session, die diesen Master-Plan ausfuehrt, muss zuerst LESEN:

1. **Dieses Dokument** (`docs/MASTERPLAN_KONSOLIDIERUNG_TERMINE.md`) — Plan + Stand
2. `docs/termine/INDEX.md` — Termin-Inventar mit Datierungen
3. `docs/termine/20260508 Termin 7/HABICH_TERMIN7_ZUSAMMENFASSUNG_*.md`
4. `docs/termine/20260508 Termin 7/HABICH_TERMIN8_VORBEREITUNG_*.md`
5. `docs/termine/20260508 Termin 7/REVIEW_PLAN_6_TAGE.md`
6. `docs/termine/20260508 Termin 7/Phase5_UML_Detail/00_README.md` (UML-Index)
7. `docs/termine/20260508 Termin 7/Phase5_UML_Detail/24_architektur_skizze_REV7_2026_05_13.md`
8. **Letzte 3 Session-Doks** aus `docs/sessions/` (chronologisch absteigend)
9. `MEMORY.md` (in `~/.claude/...memory/`) — fuer aktive Direktiven

---

## §1 Konsolidierungs-Phasen (10 Phasen, ueber mehrere Sessions)

### Phase K-A — TERMIN 8 SOFORT-VORBEREITUNG (Prio 1, heute)

**Ziel:** Termin-8 abdeckende Dokumente in `docs/termine/20260515 Termin 8/`.

**Schritte:**
- K-A.1: Master-Plan dokumentieren (DIESES Dokument)
- K-A.2: ChatGPT-Dateien archivieren in `_archive_chatgpt/` (DONE)
- K-A.3: `Arbeitsplan_Termin8.md` schreiben (Was wurde V12-V31 gemacht, wie gehts weiter)
- K-A.4: `Arbeitsergebnis_Termin8.md` schreiben (Konkrete Resultate, Pin-Kette,
  Adapter-Inhalte, P27-Code-Eingang, libs/-Migration, NOTICE Architekt-Direktive II)
- K-A.5: `Praesentation_Termin8.md` schreiben (Slide-Skelett: Agenda, Was-fertig,
  Diskussionspunkte, Naechster Termin)
- K-A.6: `HABICH_TERMIN8_VORBEREITUNG_2026_05_14.md` um V15-V31 NACHTRAG erweitern
- K-A.7: `HABICH_TERMIN7_ZUSAMMENFASSUNG_2026_05_13.md` um V12-V31 NACHTRAG erweitern
- K-A.8: pandoc-Konvertierung der 3 Termin-8-md zu .docx/.pptx
- K-A.9: Commit + Push

**Kritisch:** Termin ist heute (2026-05-15)! K-A muss vor Termin abgeschlossen sein.

---

### Phase K-B — INDEX + TERMINE-VERZEICHNIS

**Ziel:** Sauberes Top-Level-Inhaltsverzeichnis fuer `docs/termine/`.

**Schritte:**
- K-B.1: `docs/termine/INDEX.md` aktualisieren mit Termin 8
- K-B.2: Pro Termin 1-7: Mini-Snapshot in INDEX (Datum, Hauptthema, Schluesseldokumente)
- K-B.3: Master-Tag-Liste (welche Konzepte wurden in welchem Termin eingefuehrt)

---

### Phase K-C — DOCS/ARCHITEKTUR/ aus Termin-7-Phase5_UML_Detail

**Ziel:** REV-Skizzen, UML, Konzepte aus `Phase5_UML_Detail/` extrahieren in
`docs/architektur/`.

**Quelldokumente** (volle Tieflektuere mit hoechster Praezision PFLICHT):

| Doc | Datei | Inhalt |
|---|---|---|
| 00 | `00_README.md` | Index der Phase5-Dokumente |
| 01-06 | `01_uml_search_engine.md`-`06_uml_persistence.md` | Initial-UML pro Saeule |
| 07 | `07_er_model.md` | Entity-Relationship-Modell |
| 08 | `08_cross_reference.md` | Cross-References zwischen Saeulen |
| 09 | `09_drawio_export.md` | Drawio-Export-Strategie |
| 10 | `10_korrektur_architektur_skizze_2026_05_09.md` | Erste Korrekturen |
| 11 | `11_cache_strategy_taxonomie.md` | Cache-Strategien-Taxonomie |
| 12 | `12_algorithmus_strategie_taxonomie.md` | Algorithm-Strategien |
| 13 | `13_saeule_b_plattform_modell_konkretisierung.md` | Plattform-Modell |
| 20 | `20_architektur_skizze_REV3_2026_05_10.md` | REV3 |
| 21 | `21_architektur_skizze_REV4_2026_05_10.md` | REV4 |
| 22 | `22_architektur_skizze_REV5_2026_05_11.md` | REV5 |
| 23 | `23_architektur_skizze_REV6_2026_05_11.md` | REV6 |
| 24 | `24_architektur_skizze_REV7_2026_05_13.md` | **REV7 (aktueller Master)** |
| 25 | `25_architektur_delta_hybrid_search_engine_2026_05_13.md` | Delta hybrid SE |
| 26 | `26_architektur_delta_legacy_reimpl_2026_05_13.md` | Delta legacy_reimpl |
| 27 | `27_architektur_delta_ycsb_cli_2026_05_13.md` | Delta YCSB CLI |
| 28 | `28_architektur_delta_cmake_pipeline_2026_05_13.md` | Delta CMake-Pipeline |
| 29 | `29_architektur_delta_phase4_7_loader_2026_05_13.md` | Delta Phase 4-7 Loader |
| 30 | `30_architektur_delta_REV7_6_drei_repo_layer_2026_05_13.md` | REV 7.6 |

**Output:**
- `docs/architektur/00_INDEX.md` (Architektur-Index)
- `docs/architektur/01_REV_Historie.md` (REV3 → REV7.7 Verlauf)
- `docs/architektur/02_aktueller_master_REV7_7.md` (Konsolidierter Master, integriert REV7 + Deltas 25-30 + V12-V31-Stand)
- `docs/architektur/03_konzepte/` (Saeule A/B, Visitor, Hybrid-Command, Plattform-Modell)
- `docs/architektur/04_uml/` (Klassendiagramme)
- `docs/architektur/05_er_modell.md`
- `docs/architektur/06_cross_reference.md`
- `docs/architektur/07_drawio_export.md`

**Wichtig:** ALLE Quelldokumente bleiben unter `docs/termine/...` — nichts loeschen
(Memory-Direktive). Extraktion = NEUE Dateien, die auf Quellen verweisen.

---

### Phase K-D — DOCS/GLOSSAR/ aus Begriffsglossar v2-v7

**Ziel:** Konsolidiertes Begriffsglossar als Master-Doku.

**Quelldokumente:**
- `docs/termine/20260508 Termin 7/Begriffsglossar_v2_FINAL.txt` bis `Begriffsglossar_v7_FINAL.txt`
- `Domaenenmodell_PRT_ART.txt` bis `Domaenenmodell_PRT_ART_v4_DELTA.txt`

**Output:**
- `docs/glossar/00_INDEX.md`
- `docs/glossar/01_begriffsglossar_v7_master.md` (v7-Inhalt + Versions-Historie als Tabelle)
- `docs/glossar/02_domaenenmodell_v4_master.md`
- `docs/glossar/03_versionshistorie.md` (was wurde v2→v3, v3→v4, ... ersetzt/geaendert)

---

### Phase K-E — DOCS/BAUSTEINE/

**Ziel:** Bausteine-Matrix + Allokator-Matrix + Cross-Paper-Konzeptmatrix konsolidiert.

**Quelldokumente:**
- `docs/termine/20260508 Termin 7/Bausteine_Matrix.txt`
- `docs/termine/20260508 Termin 7/Allokator_Matrix.txt`
- `docs/termine/20260508 Termin 7/Cross_Paper_Konzeptmatrix.txt`
- `docs/termine/20260508 Termin 7/Eigenschaften_Suchalgorithmen.txt`
- `docs/termine/20260508 Termin 7/Architekturentscheidungen_F1_F15.txt`
- `docs/termine/20260508 Termin 7/Flag_System.txt`

**Output:**
- `docs/bausteine/00_INDEX.md`
- `docs/bausteine/01_bausteine_matrix.md` (in Markdown statt .txt)
- `docs/bausteine/02_allokator_matrix.md`
- `docs/bausteine/03_cross_paper_konzeptmatrix.md`
- `docs/bausteine/04_architekturentscheidungen_F1_F15.md`
- `docs/bausteine/05_flag_system.md`
- `docs/bausteine/06_eigenschaften_suchalgorithmen.md`

---

### Phase K-F — DOCS/FORSCHUNGSLANDKARTE/

**Ziel:** 33-Paper-Cluster + Algorithm-Strategien konsolidiert.

**Quelldokumente:**
- `docs/termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions/cluster_A_trie.md` bis `cluster_F_*`
- `docs/termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions_allocators/A01-*.md` bis `A23-*.md`
- `docs/termine/20260508 Termin 7/Phase5_UML_Detail/_rev5_extractions/`
- `docs/termine/20260508 Termin 7/Phase5_UML_Detail/_rev6_extractions/`
- `docs/termine/20260508 Termin 7/Quellen_Gesamtkatalog.txt`
- `docs/termine/20260508 Termin 7/SLUB_Download_Liste.md`

**Output:**
- `docs/forschungslandkarte/00_INDEX.md`
- `docs/forschungslandkarte/01_quellen_gesamtkatalog.md` (33 Paper P01-P33 + 23 Allokator A01-A23)
- `docs/forschungslandkarte/02_cluster_A_trie.md`
- `docs/forschungslandkarte/03_cluster_B_hybrid_bplus.md`
- `docs/forschungslandkarte/04_cluster_C_layout_theorie.md`
- `docs/forschungslandkarte/05_cluster_D_prefetching_1.md`
- `docs/forschungslandkarte/06_cluster_E_prefetching_telemetry.md`
- `docs/forschungslandkarte/07_cluster_F_sync_tud_habich.md`
- `docs/forschungslandkarte/08_allokator_cluster_AC1_AC5.md`

---

### Phase K-G — TERMIN 1-7 KONSOLIDIERUNG (Volle Tieflektuere ALLER Dokumente)

**Ziel:** Pro Termin (1-7) ein Master-Snapshot mit Stand zu diesem Datum.

**Quelldokumente** (vollstaendig):
- `docs/termine/20260330 Termin 1/` (komplette Lektuere)
- `docs/termine/20260330 Termin 2/`
- `docs/termine/20260409 Termin 3/`
- `docs/termine/20260412 Termin 4/`
- `docs/termine/20260412 Termin 5/`
- `docs/termine/20260416 Termin 6/`
- `docs/termine/20260508 Termin 7/` (alle ~60 Dokumente)

**Output:**
- `docs/termine_konsolidiert/00_INDEX.md`
- `docs/termine_konsolidiert/01_termin_1.md` (Datum + Was-besprochen + Was-entschieden + Wie-implementiert)
- `docs/termine_konsolidiert/02_termin_2.md`
- ... (pro Termin)
- `docs/termine_konsolidiert/07_termin_7.md`
- `docs/termine_konsolidiert/08_termin_8.md` (heute)

**Memory-Direktive:** ORIGINAL-Dokumente in `docs/termine/` bleiben **VOLLSTAENDIG**
erhalten — Konsolidierung in NEUE Dateien.

---

### Phase K-H — DRAWIO REV7 (REV6 erweitern + neuer Master-Tab)

**Ziel:** `phase5_uml_detail_REV7.drawio` mit allen Tabs erweitert.

**Quelldokumente fuer Update:**
- Basis: `docs/termine/20260508 Termin 7/Phase5_UML_Detail/phase5_uml_detail_REV6.drawio`
- Inhaltliche Updates: alle Dokumente 24-30 (REV7 + 6 Deltas)
- V12-V31 Code-Stand (3 Repos)

**Tab-fuer-Tab-Update PFLICHT:**
1. Tab 01: Search Engine — V12-V13 Container-API + status_t hinzufuegen
2. Tab K01-K05: Konzepte — REV7-Aktualisierungen
3. Tab MX1: Layer-vs-Matrix Strategie — Update
4. Tab U01-U06: UML-Klassen — V12-V31 Klassen-Updates
5. NEU Tab REV7-Master: Drei-Repo-Architektur Uebersicht
6. NEU Tab Adapter-Familie: 22 V31-Adapter
7. NEU Tab P27-Bundles: hp_soft + HierarchicalBundlePrefetcher
8. NEU Tab libs/-Layout: V30-Konsolidierung

**Output:**
- `docs/termine/20260508 Termin 7/Phase5_UML_Detail/phase5_uml_detail_REV7.drawio`
  (REV6 als Basis, alle Tabs aktualisiert + 4 neue Tabs)

---

### Phase K-I — KOMPLETT-CHECK + CROSS-REFERENCES

**Ziel:** Alle docs/* Verzeichnisse cross-referenziert + Diplomarbeit-Manuskript
(`thesis/`) auf konsolidierte Doks zeigend.

**Schritte:**
- K-I.1: `docs/INDEX.md` als Top-Level-Index aller docs/-Unterordner
- K-I.2: Pro thesis/chapter pruefen, ob Querverweise auf docs/* existieren
- K-I.3: Sessions-Doks auf konsolidierte Doks verweisen lassen
- K-I.4: Memory-Datei `feedback_documentation_master_paths.md` aktualisieren

---

### Phase K-J — TERMIN-7-DOKUMENTE FORTFUEHREN AUF V31-STAND

**Ziel:** Die drei Termin-7-Dokumente (Arbeitsplan, Ergebnis, Vortrag) inhaltlich
auf den V31-Stand uebertragen, damit sie als saubere Vorlage fuer Termin 8 dienen.

**Achtung:** Die ORIGINALE in `docs/termine/20260508 Termin 7/` bleiben — neue
Versionen kommen unter `docs/termine/20260515 Termin 8/`.

**Schritte:**
- K-J.1: `docs/termine/20260515 Termin 8/Arbeitsplan_Termin8.md` (siehe K-A.3)
- K-J.2: `docs/termine/20260515 Termin 8/Arbeitsergebnis_Termin8.md` (K-A.4)
- K-J.3: `docs/termine/20260515 Termin 8/Praesentation_Termin8.md` (K-A.5)
- K-J.4: `docs/termine/20260515 Termin 8/Sprechpunkte_Termin8.md` (zusaetzlich)

---

## §2 Reihenfolge + Abhaengigkeiten

```
K-A (heute, vor Termin 8)
  └→ Termin 8 stattfinden lassen
      └→ K-B (INDEX-Refresh)
          └→ K-C (Architektur)  ─┐
          └→ K-D (Glossar)       ├→ K-G (Termin-Konsolidierung)
          └→ K-E (Bausteine)     │   └→ K-I (Cross-Refs + INDEX)
          └→ K-F (Forschung)    ─┘
              └→ K-H (drawio REV7)
                  └→ K-J (Termin-7-Dokumente fortfuehren)
```

---

## §3 Erfolgskriterien pro Phase

| Phase | Kriterium |
|---|---|
| K-A | 3 Termin-8-Dokumente + .docx/.pptx existieren, gepusht |
| K-B | INDEX.md hat alle 8 Termine + Tag-Liste |
| K-C | docs/architektur/ mit 7 Master-Dokumenten + INDEX |
| K-D | docs/glossar/ mit konsolidiertem v7-Master + Versionshistorie |
| K-E | docs/bausteine/ mit 6 Markdown-Dokumenten |
| K-F | docs/forschungslandkarte/ mit allen 33 Paper + Allokatoren |
| K-G | docs/termine_konsolidiert/ mit 1 .md pro Termin |
| K-H | phase5_uml_detail_REV7.drawio mit allen Tabs aktualisiert |
| K-I | docs/INDEX.md fertig, alle Doks cross-referenziert |
| K-J | Termin-8-Sprechpunkte + Vorlage fuer Termin 9 |

---

## §4 Geschaetzte Dauer

| Phase | Dauer (Tage) | Kontextverbrauch |
|---|---|---|
| K-A | 0.5 | mittel |
| K-B | 0.25 | gering |
| K-C | 2 | sehr hoch (24 Quelldokumente) |
| K-D | 1 | hoch (12 Quelldokumente) |
| K-E | 0.5 | mittel (6 Quelldokumente) |
| K-F | 1.5 | hoch (alle paper extractions) |
| K-G | 3 | sehr hoch (alle 7 Termine) |
| K-H | 1.5 | sehr hoch (drawio XML, alle Tabs) |
| K-I | 0.5 | mittel |
| K-J | 0.5 | gering |
| **Gesamt** | **~11 Tage** | mehrere Sessions noetig |

---

## §5 Memory-Verankerung

Pflicht: Bei JEDER neuen Konsolidierungs-Session zuerst dieses Dokument lesen.
In `MEMORY.md` einen Verweis auf diesen Master-Plan ergaenzen.

Eintrag in MEMORY.md:
```
### Konsolidierungs-Master-Plan (Diplomarbeit 2026-05-15)
- → [docs/MASTERPLAN_KONSOLIDIERUNG_TERMINE.md](Diplomarbeit/docs/MASTERPLAN_KONSOLIDIERUNG_TERMINE.md)
- 10 Phasen K-A bis K-J ueber ~11 Tage
- Pflicht-Lese-Liste in §0
- Original-Termine bleiben — Konsolidierung in NEUE Verzeichnisse
```

---

## §6 Anti-Pattern (was NICHT tun)

- **NICHT:** Original-Termin-Dokumente loeschen oder umbenennen (Memory-Direktive!)
- **NICHT:** REV6.drawio loeschen — als historisches Backup behalten
- **NICHT:** Begriffsglossar v2-v6 loeschen — Versionshistorie wichtig
- **NICHT:** ChatGPT-Office-Dateien als Vorlage uebernehmen (sind in `_archive_chatgpt/`)
- **NICHT:** Phasen K-B...K-J vor K-A starten (Termin 8 ist heute, Prio 1)
- **NICHT:** drawio-Tabs ohne Doc-24-30-Lektuere updaten (Praezision!)

---

## §7 Querverweise

- Aktueller Termin-7-Stand: `docs/termine/20260508 Termin 7/`
- Aktueller Termin-8-Ordner: `docs/termine/20260515 Termin 8/`
- Letzte Sessions-Doks: `docs/sessions/20260514-44*` (V31-Final)
- Manuskript-Wrapper: `thesis/main.tex`
- Memory: `~/.claude/.../memory/MEMORY.md`
