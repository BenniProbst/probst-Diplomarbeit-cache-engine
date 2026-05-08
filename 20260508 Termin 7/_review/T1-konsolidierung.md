# Termin 1 — Konsolidierung

**Datum:** 2026-03-30 (Skizze 29.03.2026 + START/CoCo nachgezogen)
**Hauptthema:** Erste vollstaendige PRT-ART-Skizze nach Literatur-Recherche
**Zustand:** Skizze offen — Architektur noch nicht eingefroren

## Zentrale Texte

- `20260330 Termin 1__20260330 PRT_ART_Technische_Skizze_Habich_termin1_START_CoCo_sort_compact.docx`
- `20260330 Termin 1__20260330 Literatur_und_Arbeitsplanung_PRT_ART_Termin1_START_CoCo_sort_compact.docx`
- (Vorlauf-Exposes im Hauptordner: 20260309, 20260312, 20260321, 20260323, 20260326, 20260328, 20260329)

## Kernaussagen Termin 1

**Neuheitsanspruch:** PRT-ART ist KEINE neue Datenstruktur, sondern eine **gezielte Kombination komplementaerer Prinzipien** aus existierenden Strukturen. Wissenschaftliche Relevanz entsteht durch experimentelle Klaerung, wann diese Kombination auf moderner CPU-Hardware gegenueber Baselines gewinnt.

**Primaere Hypothese (H1):** PRT-ART gewinnt ueber bessere Mikroarchitektur-Eigenschaften (CLU, LLC-/dTLB-Misses, Branch-Kosten, kleine heisse Suchpfade) — NICHT ueber asymptotische Neuheit.

## Architektur-Bausteine (noch offen)

| Baustein | Inspiration | Rolle |
|---|---|---|
| Globale Trie-Huelle | (eigene Konstruktion) | Ordnungserhaltend, praefixorientiert |
| Redirect-Knoten | CoCo-trie | Komprimierte eindeutige Restpfade |
| Dense Byte Page | ART (Node256) | Direkte Byte-Adressierung |
| Dense Multi-Byte Page | START | Mehrbyteige lokale Seiten, Hoehenreduktion |
| Sparse Patricia Page | HOT | Diskriminierende Bits, hohe Fanouts in sparse Teilraeumen |
| Custom Cache Page | CSS-tree + CSB+-tree + B²-tree | Cache-line-bewusstes Layout |
| Subbaumgrenzen / Fences | Masstree | Layer-Regeln, Boundary-Handling |
| Externe Payload-Ablage | (eigene Designentscheidung) | Hot/Cold-Split, Value-Referenzen |

## Erwaehnte Quellen — Cross-Referenz

| Erwaehnt als | Im Katalog | PDF vorhanden |
|---|---|---|
| Belazzougui et al. CoCo-trie | A2.8 (Boffa et al. 2024) | ✓ — KORREKTUR: Boffa, nicht Belazzougui |
| Leis/Kemper/Neumann ART | A2.2 | ✓ |
| Fent et al. START | A2.6 | ✓ |
| Binna et al. HOT | A2.4 | ✓ |
| Mao/Kohler/Morris Masstree | A2.1 | ✓ |
| Rao/Ross CSS-tree | A1.1 | ✓ |
| Rao/Ross CSB+-tree | A1.2 | ✓ |
| Schmeisser et al. B²-tree | A2.7 | ✓ |
| Samuel/Pedersen/Bonnet Processor-Conscious CSB+ | A1.5 | ✓ (Volltext, REV4) |
| Saikkonen/Soisalon-Soininen 2016 | A1.9 | ✓ |
| YCSB | C.11 (Tool) | n/a |
| Intel Advisor | C.1 (Tool) | n/a |
| TUD Hardware Optimizations (Ungethuem 2017) | A3.1 | ✓ |
| TUD To Stride or Not to Stride | A3.3 | ✓ |
| VAMPIR (TUD) | A3.2 | ✓ (SPP2377-Kickoff) |
| SOSD | C.13 (Tool) | n/a |

**Status:** Alle in T1 erwaehnten Quellen sind im Korpus.

## Was T1 noch NICHT entschieden hat

- Welche Seitentypen werden tatsaechlich Pflicht (vs optional) ✗
- Numerische Schwellwerte fuer Seitentyp-Wahl ✗
- API-Endformulierung der Ordnungsmodi ✗
- Konkrete Cache-Engine-Mechanik ✗ (existiert in T1 noch nicht als eigene Schicht)
- Inline-Value-Politik ✗

## Uebergang zu T2

T2 muss einfrieren: lokale Seitentypenfamilie, ValueHandle-Politik, Invarianten, Risiken/Gegenmassnahmen, Datensatz/Workload-Skizze.
