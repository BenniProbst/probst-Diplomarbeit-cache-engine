# P11 — CSS-Tree (Cache-Sensitive Search Tree)

**Voller Titel:** Cache Conscious Indexing for Decision-Support in Main Memory
**Autoren:** Jun Rao, Kenneth A. Ross (Columbia University)
**Venue:** VLDB 1999, Edinburgh
**Volltext:** `_text/P11-CSS-RaoRoss1999.txt` (12 Seiten, 58 KB)

## 1. Konzeptionelle Identitaet

CSS-Tree = **pointer-freie Directory-Struktur** ueber sortiertem Array. Knoten in **Cache-Line-Groesse**, Kinder via **Offset-Arithmetik** ohne Pointer.

> "CSS-trees... store a directory structure on top of a sorted array. Nodes in this directory have size matching the cache-line size of the machine. We store the directory in an array and do not store internal-node pointers; child nodes can be found by performing arithmetic on array offsets." (P11:S.1/27-34)

**Klasse:** Statische cache-line-orientierte Indexstruktur fuer **OLAP** (Decision-Support)
**Pflicht-Annahme:** Statische Daten — Updates sind teuer (Rebuild!)

## 2. Strukturelle Bausteine

| Element | Beschreibung |
|---|---|
| **Sorted Array** | Datenanker (Tupel-Identifier oder Werte) |
| **Directory Tree** | Pointer-LOSE Struktur ueber dem Array |
| **Cache-Line-Sized Node** | Knotengroesse = Cache-Line (z.B. 64 B = m Schluessel) |
| **Offset-Arithmetik** | child(node, i) = base + (node_index × m + i) × node_size |
| **Full CSS-Tree vs Level CSS-Tree** | 2 Varianten — Level erlaubt sparse Top-Levels |

Komplexitaet: **O(log_m N)** mit m = Schluessel/Cache-Line.

## 3. Algorithmen

- **Lookup**: Binary search innerhalb Cache-Line-Knoten + Offset-Descend
- **Insert/Delete**: Schwer — typischerweise Rebuild
- **Range Scan**: direkt auf sortiertem Array nach Lokalisierung

## 4. PRT-ART-Bezug

| CSS-Tree-Konzept | PRT-ART-Bezug |
|---|---|
| Cache-Line-Sized Nodes | konzeptionell **eine moegliche Auspraegung** der PRT-ART Custom Cache Page |
| Pointer-FREI via Offset-Arithmetik | inspiriert PRT-ART **Custom Cache Page Layout** |
| Statisch | **GROSSER UNTERSCHIED** zu PRT-ART (Updates Pflicht) |
| OLAP-Annahme | NICHT in PRT-ART (PRT-ART OLTP+OLAP) |

## 5. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **CSS-Tree pointer-free node ↔ SuRF LOUDS-Dense (P10)**: beide vermeiden Pointer in Knoten
- **CSS-Tree Cache-Line-Knoten ↔ Hankins/Patel Knotengroesse-Studie (P13)**: beide untersuchen Cache-Line als Designanker
- **CSS-Tree statische Build-Optimierung ↔ CoCo-trie static (P04)**: beide brauchen Build-Zeit-Optimierung

## 6. Kernanschluss fuer PRT-ART

CSS-Tree ist die **klassische Pflichtabgrenzung** — markiert "passive cache-awareness" maximal. PRT-ART beweist gegenueber CSS-Tree:
1. **Updates moeglich** (CSS-Tree braucht Rebuild)
2. **Adaptive Page-Wahl** (CSS-Tree fix Cache-Line-Groesse)
3. **Plattform-Kalibrierung** (CSS-Tree feste Knotengroesse)

CSS-Tree-Layout-Idee (offset-arithmetik, kein Pointer) bleibt aber als **moegliche Custom-Cache-Page-Variante** in der PRT-ART-Familie verfuegbar.
