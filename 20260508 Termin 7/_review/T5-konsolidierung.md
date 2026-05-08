# Termin 5 — Konsolidierung

**Datum:** 2026-04-12 (Forschungslandkarte) + 2026-04-16 (Ausarbeitung nachgezogen)
**Hauptthema:** **Forschungslandkarte** der Cache-Engine im Kontext trie-basierter Suche · **Wissenschaftliche Position als Control Plane**
**Zustand:** Verortung der Forschungsfrage geschaerft

## Zentrale Texte

- `20260412 Termin 5__20260412_PRT_ART_Forschungslandkarte_Cache_Engine_Termin5_final.docx`
- `20260412 Termin 5__20260416_PRT_ART_Ausarbeitung_Termin5_nachgezogen_final.docx`
- `20260412 Termin 5__20260412_Arbeitsaufstellung_PRT_ART_Termin5_final.docx`

## Geschaerfte Einordnung (Schluessel-Statement!)

> "**PRT-ART ist primaer eine aktive Cache-Engine bzw. Control Plane ueber trie-basierter Suche.** Die Suchstruktur bleibt Mittel zum Zweck. Der wissenschaftliche Mehrwert liegt nicht in einem weiteren Trie als Selbstzweck, sondern in der messgetriebenen Orchestrierung von Seitentypwahl, Layout, Inline-vs-Handle-Ablage, Prefetching und plattformabhaengigen Parametern."

**Konsequenz fuer Domaenenmodell:** Such-Algorithmus-Domaene ist sekundaer — Hauptbeitrag ist Cache-Engine-Domaene.

## 5 Forschungscluster (T5)

| Cluster | Repraesentative Arbeiten | Was die Literatur zeigt | Bedeutung fuer PRT-ART |
|---|---|---|---|
| **Passive cache-aware Layouts** | CSS-tree, CSB+-tree, processor-conscious CSB+, cache-sensitive Binary Trees | Node-Groesse, Kindanordnung, Pointerzahl, Suchschema bestimmen Cache-Miss-Kosten stark | Stuetzt Dense Pages, pointerarme Adressierung, plattform-aware Parameterwahl |
| **Adaptive trieartige Suchstrukturen** | ART, START, HOT, Masstree, B²-tree, CoCo-trie | Lokale Repraesentation, Pfadkompression, multibyte/page-lokale Suchraum-Einengung verbessern Point/Prefix | Stuetzt Seitentypfamilien, Redirects, Praefixkollabierung |
| **Aktives Prefetching + Laufzeitanpassung** | Fractal Prefetching B+-Trees, Dynamic Adaptation, Prefetch-Reliability-Arbeiten | Prefetching kann helfen, ist aber plattform-/Workload-/Zielcache-abhaengig | Stuetzt Kalibrierungsphase + evidenzbasiertes Prefetching |
| **Cache-oblivious Gegenentwurf** | Cache-oblivious B-trees / string B-trees | Suchstrukturen ohne explizite Cache-Parameter modellierbar | **Markiert philosophischen Kontrast** (PRT-ART ist explizit cache-aware!) |
| **Habich-/Dresden-Linie** | TUD Hardware Optimization, VAMPIR, To Stride or Not | Hoher Durchsatz, niedrige Latenz, Access-Pattern-Analyse | Hilft beim Framing in der Sprache der Professur |

## 18 Kern-Quellen (Forschungslandkarte-Tabelle)

Alle in Quellenkatalog erfasst:

| Paper | Katalog-ID | Vorhanden |
|---|---|---|
| Cache-Sensitive Search Trees (Rao/Ross 1999) | A1.1 | ✓ |
| CSB+-Tree (Rao/Ross 2000) | A1.2 | ✓ |
| B-Tree Indexes and CPU Caches (Graefe/Larson 2001) | A1.3 | ✓ (REV3) |
| Fractal Prefetching B+-Trees (Chen 2002) | B1.2 | ✓ |
| Node Size in CCB+ Trees (Hankins/Patel 2003) | A1.4 | ✓ |
| Making CSB+-Trees Processor Conscious (Samuel 2005) | A1.5 | ✓ (Volltext, REV4) |
| Cache-Oblivious B-Trees (Bender 2006) | A1.7 | ✓ |
| Masstree (Mao/Kohler/Morris 2012) | A2.1 | ✓ |
| ART (Leis 2013) | A2.2 | ✓ |
| HOT (Binna 2018) | A2.4 | ✓ |
| START (Fent 2020) | A2.6 | ✓ (REV4) |
| B²-Tree (Schmeisser 2022) | A2.7 | ✓ |
| CoCo-trie (Boffa 2024) | A2.8 | ✓ |
| Dynamic Adaptation Cache Prefetching (Khan 2011) | B1.3 | ✓ |
| Fetch Me If You Can (Mahling 2025) | B1.5 | ✓ |
| Overview Hardware Optim. (Ungethuem 2017) | A3.1 | ✓ |
| VAMPIR (TUD 2023) | A3.2 | ✓ |
| To Stride or Not to Stride (TUD 2025) | A3.3 | ✓ |

## Was die Literatur PRT-ART NICHT liefert (Forschungsluecke)

> "Was noch nicht ueberzeugend als zusammenhaengende Loesung vorliegt, ist eine **getrennte Cache-Control-Plane** ueber trie-basierter Suche, die Seitentypwahl, Layout, Value-Ablage und Prefetching gemeinsam steuert und ihre Regeln an eine konkrete Plattform kalibriert."

## Belastbar behauptbar (T5 explizit)

- PRT-ART kombiniert bekannte Bausteine bewusst zu einer aktiven, messgetriebenen Cache-Orchestrierungsschicht
- Cache-Engine als Meta-Ebene ist neu und wissenschaftlich plausibel als Kernbeitrag
- Dense/Sparse/Redirect/Value-Policy muss plattformbewusst sein, nicht dogmatisch fest

## Vorsichtig zu behandeln (T5 explizit)

- KEINE direkte "Verwaltung" von Hardware-Caches behaupten — nur Beeinflussung via Layout/Access Patterns/Prefetching/Allokation
- KEINE starken Aussagen zur expliziten Programm-/Instruction-Cache-Steuerung
- KEINE universellen Prefetch-Regeln

## Konsequenz fuer T6

> "Vor einer belastbaren Implementationsplanung muessen als Naechstes die Verifikationsarchitekturen, ISA-Pfade, Messwerkzeuge und Kalibrierungsbenchmarks festgezogen werden."
