# Cross-Refs auf konsolidierte Doks (K-I.3)

**Stand:** 2026-05-15 (K-I.3 — Sessions-Cross-Refs)
**Zweck:** Zentrale Querverweis-Tabelle: alle alten sessions/-Doks zeigen ueber dieses File auf die neuen konsolidierten Master-Doks.

**Memory-Direktive beachtet:** Original-Sessions-Doks bleiben **VOLLSTAENDIG** unveraendert. Dieses File ist nur eine Cross-Ref-Tabelle, kein Replacement.

---

## §0 Pflicht-Pre-Read fuer Sessions

Wer eine alte Session liest und sich orientieren will, sollte **zusaetzlich** lesen:

| Konsolidierungs-Doku | Wenn relevant fuer Session-Thema |
|---|---|
| `../INDEX.md` | Top-Level — IMMER zuerst |
| `../MASTERPLAN_KONSOLIDIERUNG_TERMINE.md` | Konsolidierungs-Phasen K-A bis K-J |
| `../glossar/01_begriffsglossar_v7_master.md` | Wenn Begriffe unklar sind (~161 KANON-Begriffe) |
| `../glossar/02_domaenenmodell_v4_master.md` | Wenn Domaene/Pruefling-Verhaeltnis unklar |
| `../architektur/02_aktueller_master_REV7_7.md` | Wenn Architektur-Bezug unklar |
| `../bausteine/04_architekturentscheidungen_F1_F15.md` | Wenn ADR-Bezug unklar (25 ADRs) |
| `../forschungslandkarte/01_quellen_gesamtkatalog.md` | Wenn Paper-Bezug unklar (56 Paper) |
| `../termine_konsolidiert/0N_termin_N.md` | Wenn Termin-N-Bezug unklar (8 Termine) |

---

## §1 Mapping pro Session-Thema → Konsolidierte Doks

### 1.1 Sessions zur Architektur (REV-Iterationen, UML, ER)

| Session-Pattern | Konsolidiert in |
|---|---|
| `*architektur*`, `*REV*`, `*uml*`, `*er_model*` | `../architektur/01_REV_Historie.md` (REV3→REV7.7) |
| `*REV7*`, `*REV7_6*`, `*REV7_7*` | `../architektur/02_aktueller_master_REV7_7.md` |
| `*saeule_a*`, `*such_strategie*`, `*algorithmus_strategie*` | `../architektur/03_konzepte_saeule_a.md` |
| `*saeule_b*`, `*plattform_modell*`, `*cache_strategie*` | `../architektur/04_konzepte_saeule_b.md` |
| `*uml_klassen*`, `*uml_search_engine*`, `*uml_cache_engine*` | `../architektur/05_uml_klassen.md` |
| `*er_model*`, `*entitaet*`, `*beziehung*` | `../architektur/06_er_modell.md` |
| `*cross_reference*`, `*cross_paper*` | `../architektur/07_cross_reference.md` |
| `*drawio*`, `*phase5_uml*` | `../architektur/08_drawio_export.md` |
| `*taxonomie*`, `*hybrid*command*` | `../architektur/09_taxonomien.md` |

### 1.2 Sessions zum Glossar/Domaenenmodell

| Session-Pattern | Konsolidiert in |
|---|---|
| `*begriffsglossar*`, `*v3*`, `*v4*`, `*v5*`, `*v6*`, `*v7*` | `../glossar/01_begriffsglossar_v7_master.md` |
| `*domaenenmodell*`, `*domain_model*` | `../glossar/02_domaenenmodell_v4_master.md` |
| `*versionshistorie*`, `*v1_to_v7*` | `../glossar/03_versionshistorie.md` |

### 1.3 Sessions zu Bausteinen / Architekturentscheidungen

| Session-Pattern | Konsolidiert in |
|---|---|
| `*bausteine_matrix*`, `*85_bausteine*`, `*11_achsen*` | `../bausteine/01_bausteine_matrix.md` |
| `*allokator_matrix*`, `*23_allokatoren*`, `*7_achsen*` | `../bausteine/02_allokator_matrix.md` |
| `*cross_paper_konzept*`, `*18_konzepte*` | `../bausteine/03_cross_paper_konzeptmatrix.md` |
| `*architekturentscheidungen*`, `*F1*`, `*F15*`, `*F-EXTRA*`, `*ADR*` | `../bausteine/04_architekturentscheidungen_F1_F15.md` |
| `*flag_system*`, `*9_bank*`, `*permutation_id*` | `../bausteine/05_flag_system.md` |
| `*eigenschaften*`, `*23_algorithmen*`, `*kategorien_A_D*` | `../bausteine/06_eigenschaften_suchalgorithmen.md` |

### 1.4 Sessions zur Forschungslandkarte (33 SOTA + 23 Allokator)

| Session-Pattern | Konsolidiert in |
|---|---|
| `*quellen_gesamtkatalog*`, `*56_paper*`, `*sota_korpus*` | `../forschungslandkarte/01_quellen_gesamtkatalog.md` |
| `*P01_ART*`, `*P02_HOT*`, `*P04_CoCo*`, `*P05_START*`, `*cluster_A*` | `../forschungslandkarte/02_cluster_A_trie.md` |
| `*P03_Masstree*`, `*P06_B2*`, `*P07_Wormhole*`, `*P11*P12*`, `*cluster_B*` | `../forschungslandkarte/03_cluster_B_hybrid_bplus.md` |
| `*P10_SuRF*`, `*P13_*`, `*P14_*`, `*P15_*`, `*cluster_C*` | `../forschungslandkarte/04_cluster_C_layout_theorie.md` |
| `*P16_*`, `*P17_*`, `*P18_*`, `*P19_*`, `*cluster_D*` | `../forschungslandkarte/05_cluster_D_prefetching_1.md` |
| `*P20_*`, `*P22_*`, `*P24_*`, `*P25_*`, `*P27_hp*`, `*cluster_E*` | `../forschungslandkarte/06_cluster_E_prefetching_telemetry.md` |
| `*P26_*`, `*P28_*`, `*P29_RCU*`, `*P30_Hazard*`, `*P31*P32*P33*`, `*Habich*Rang3*`, `*cluster_F*` | `../forschungslandkarte/07_cluster_F_sync_tud_habich.md` |
| `*A01*A23*`, `*allokator_cluster*`, `*AC1*AC5*` | `../forschungslandkarte/08_allokator_cluster_AC1_AC5.md` |

### 1.5 Sessions zu Terminen 1-8

| Session-Pattern | Konsolidiert in |
|---|---|
| `*termin_1*`, `*20260330*Termin*1*` | `../termine_konsolidiert/01_termin_1.md` |
| `*termin_2*`, `*20260330*Termin*2*` | `../termine_konsolidiert/02_termin_2.md` |
| `*termin_3*`, `*20260409*` | `../termine_konsolidiert/03_termin_3.md` |
| `*termin_4*`, `*20260412*Termin*4*` | `../termine_konsolidiert/04_termin_4.md` |
| `*termin_5*`, `*20260412*Termin*5*` | `../termine_konsolidiert/05_termin_5.md` |
| `*termin_6*`, `*20260416*` | `../termine_konsolidiert/06_termin_6.md` |
| `*termin_7*`, `*20260508*`, `*habich_termin7*`, `*REV7*` | `../termine_konsolidiert/07_termin_7.md` |
| `*termin_8*`, `*20260515*`, `*habich_termin8*`, `*K-A*` | `../termine_konsolidiert/08_termin_8.md` |

### 1.6 Sessions zu V-Sprints (V8-V31)

| V-Sprint | Sessions | Konsolidiert in |
|---|---|---|
| V8-V11 | `20260513-3*-V8*`, `20260513-3*-V9*`, `20260513-3*-V10*`, `20260513-3*-V11*` | `../termine_konsolidiert/07_termin_7.md` §5 |
| V12-V14 | `20260514-3*-V12*`, `20260514-3*-V13*`, `20260514-3*-V14*` | (selbe) |
| V15-V18 | `20260514-3*-V15*` bis `V18*` | (selbe) |
| V19-V22 | `20260514-3*-V19*` bis `V22*` (Profile-Stack + Mess-Pipeline) | `../termine_konsolidiert/08_termin_8.md` §5 |
| V23-V24 | `20260514-3*-V23*`, `V24*` (libs/-Refactoring) | (selbe) |
| V25-V29 | `20260514-3*-V25*` bis `V29*` (Allokator-Profile) | (selbe) |
| V30 | `20260514-4000-v30*`, `20260514-4300-v30-final*` | (selbe) |
| V31 | `20260514-4100-v31*`, `20260514-4400-v31-final*`, `20260514-4500-habich*`, `20260514-4600-fortschritt*` | (selbe) |

### 1.7 Sessions zur Konsolidierungs-Sprint (K-A bis K-G heute)

| Session | Konsolidiert in |
|---|---|
| `20260515-4700-K-A-bis-K-G-konsolidierungssprint-finale-bilanz.md` | (diese Session selbst — Master-Bilanz) |

---

## §2 Pro-Repo-Cross-Refs

| Repo | Sessions-Verzeichnis | Konsolidiert in |
|---|---|---|
| `Diplomarbeit/Code/` (dieses Repo) | `docs/sessions/` | docs/* (alle) |
| `comdare-cache-engine` | `docs/sessions/` (im cache-engine Repo) | (eigene Doku, querverweisbar via `../../../Diplomarbeit/docs/`) |
| `comdare-prt-art` | `docs/sessions/` (im prt-art Repo) | (analog) |

---

## §3 Wartung dieser Cross-Ref-Tabelle

Wenn eine **NEUE** konsolidierte Doku unter `docs/architektur/`, `docs/glossar/`, `docs/bausteine/`, `docs/forschungslandkarte/` oder `docs/termine_konsolidiert/` hinzukommt, soll sie hier in §1 mit Pattern eingetragen werden.

Wenn eine **NEUE** Session-Klasse hinzukommt (z.B. neue V-Sprint-Familie), bitte in §1.6 ergaenzen.

---

## §4 Querverweise (Top-Level)

- `../INDEX.md` — Top-Level-Inhaltsverzeichnis
- `../MASTERPLAN_KONSOLIDIERUNG_TERMINE.md` — Master-Plan K-A bis K-J
- `../termine/INDEX.md` — Original-Termin-Index (refresh in K-B)
- `../termine_konsolidiert/00_INDEX.md` — Konsolidierter Termin-Index (K-G)
