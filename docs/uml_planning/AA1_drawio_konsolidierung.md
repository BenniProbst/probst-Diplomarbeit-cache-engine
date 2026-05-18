# AA.1 — drawio existing UML-Tabs Konsolidierung gegen Z-Soll-UML

**Stand:** 2026-05-18 (AA.1)
**Quelle:** REV7.drawio (49 Tabs) + Z.1-Z.4 Soll-UML-Doks
**Ziel:** Doppelungen identifizieren + alte Tabs als veraltet markieren / Memory-Direktive beachten (NIE loeschen)

> Nach den AA.2-AA.4-Korrekturen wird klar dass mehrere alte UML-Tabs strukturell veraltet sind (auch wenn Inhalte korrekt waren zur Zeit ihrer Erstellung). Diese Konsolidierungs-Doku listet alle Doppelungen + Aenderungs-Bedarf.

---

## §1 Bestehende drawio-Tabs (REV7 49 Tabs)

### §1.1 K-Tabs (Konzept, 14+8 Sub-Tabs)

K01-K15 + K05b-h + K07a-d + K08a-d = **insgesamt 26 K-Tabs** (siehe Y.1 §3.3).

### §1.2 U-Tabs (UML, 10)

| Tab | Inhalt (Original REV7) | Veraltet wegen | Neu in Z |
|---|---|---|---|
| **U01** | IExecutingEngine + ISearchEngine + IFutureEngine | OK Z.1 §1 deckt es ab | Z.1 §1 (Mermaid) |
| **U02** | Page-Familie 3-Schichten + IRootNode (REV5.1) | partiell veraltet (N-Phase Sub-Achsen fehlen) | Z.1 §1 |
| **U03** | Strategy-Familie + ICacheStrategy + Iteratoren | OK (Visitor-Pattern stabil) | (nicht direkt in Z) |
| **U04** | Hybrid-Command Klassen | **STRUKTURELL VERALTET** wegen AA.2 (Command-Pattern aendert sich) | CC.1 (NEU) |
| **U05** | Saeule B Plattform-Probe + Auto-Discovery | OK Phasen 1-3 stabil | (Z.1 §2) |
| **U06** | Saeule B Cache + IHeuristic + 28 Concepts | OK | Z.1 §2 |
| **U07** | ISearchEngine-Familien-Taxonomie als UML | OK | Z.1 §1 |
| **U08** | PRT_ART vollstaendige Klasse | **DOPPELUNG** mit Z.2 + OPRTART Tab 49 | Z.2 + Tab 49 |
| **U09** | ICacheEngine UML State+Visitor+Pipeline (REV5.2) | OK | Z.1 §2 |
| **U10** | comdare::prt_art + IPermutationEngine + CacheEngineBuilder | **STRUKTURELL VERALTET** (M-Modell-Korrektur AA.2!) | MCORR Tab 47 + CC.1 NEU |

### §1.3 Neue Tabs (Konsolidierungs-Sprint 2026-05-15 + 18)

| Tab# | Name | Erstellt fuer | Status nach AA.2 |
|---|---|---|---|
| 41 | REV7-Master Drei-Repo (V31 Stand) | K-H.6 | partiell veraltet (3-Spalten zu wenig fuer 4-Subsystem-Modell) |
| 42 | Adapter-Familie 22 V31-Adapter | K-H.7 | OK |
| 43 | P27 hp-soft + Bundle-Prefetcher | K-H.8 | OK |
| 44 | libs/-Layout V30-Konsolidierung | K-H.9 | OK |
| 45 | REV7-Konsolidierungs-Trace | K-H.X | OK |
| **46** | **DISAMB** Anti-Vermischung 4 Ebenen | R.12 | OK |
| **47** | **MCORR** 4-Subsystem-Schichten + bidir CE-Pruefling | M.3-M.5 | **AA.2 KORREKTUR noetig (Command-Pattern + CEB orchestriert beide EE)** |
| **48** | **NMATRIX** 14 Achsen Bausteine-Matrix | P.3 | OK + AA.3 Annotation noetig (Default-Lookup-Hinweis) |
| **49** | **OPRTART** PRT-ART Spiegel zum Bausteine-Turm | P.4 | **AA.3 + AA.4 KORREKTUR noetig (fehlende Achsen != "muss NEU")** |

---

## §2 Doppelungs-Tabelle (alt vs neu)

| Alter Tab | Neuer Tab(s) | Doppelung-Grad | Aktion |
|---|---|---|---|
| **U08 PRT_ART vollstaendige Klasse** | Z.2 Mermaid + Tab 49 OPRTART | **HOCH** | Tab 49 ersetzt U08 - U08 mit Banner "OBSOLETE seit P.4 Tab 49" markieren |
| **U10 prt_art + IPermutationEngine + CEB** | Tab 47 MCORR + CC.1 NEU | **HOCH** | CC.1 V2 ersetzt U10 - U10 mit Banner markieren |
| **U04 Hybrid-Command Klassen** | CC.1 V2 (Command-Pattern korrigiert) | **MITTEL** | U04 bleibt fuer Hybrid-Command-Inhalt, CC.1 zeigt Korrektur |
| **U06 Saeule B Cache** | NMATRIX Tab 48 + Z.1 §2 | **NIEDRIG** | U06 bleibt (Concept-Detail), NMATRIX zeigt Achsen-Erweiterung |
| Tab 41 REV7-Master Drei-Repo | Tab 47 MCORR + CC.1 V2 | **MITTEL** | Tab 41 mit Hinweis-Banner "MCORR ist neuer Stand" |

---

## §3 Aenderungs-Plan AA-Phase

### §3.1 Banner-Updates auf alten Tabs (Memory-Direktive: NICHT loeschen)

Pro veraltetem Tab einen sichtbaren Banner einfuegen:

```
OBSOLETE seit AA.2+AA.3+AA.4 (2026-05-18)
Neuer Stand: siehe Tab <neuer-tab-name>
Original-Inhalt bleibt erhalten (Memory-Direktive niemals Doku loeschen)
```

Betroffene Tabs:
- U04, U08, U10, Tab 41

### §3.2 Korrektur-Updates auf neuen Tabs

- **Tab 47 MCORR**: Banner "AA.2 KORREKTUR siehe CC.1" (Command-Pattern-Korrektur)
- **Tab 49 OPRTART**: Banner "AA.3+AA.4 KORREKTUR siehe AA3-Update" (Default-Lookup statt "muss NEU")

### §3.3 NEUE Tabs (CC-Phase)

- **CC.1 Tab 50**: M-CORRECT-V2 mit Command-Pattern (BEIDE EE parallel)
- **CC.2 Tab 51**: Default-Achsen-Lookup Mechanik

---

## §4 Konsolidierte Tab-Liste nach CC-Phase (51 Tabs)

```
Tabs 1-26:   K-Tabs (Original-Konzept, REV5-REV7) — alle BLEIBEN
Tabs 27-36:  U-Tabs (Original-UML, REV5-REV7) — alle BLEIBEN
              davon U04 + U08 + U10 mit OBSOLETE-Banner
Tabs 37-40:  K05b-h + K07a-d + K08a-d Detail (REV5.3 Splits) — BLEIBEN
Tabs 41-45:  REV7-Konsolidierung K-H-Sprint — BLEIBEN
              Tab 41 mit Hinweis-Banner
Tab 46:      DISAMB (R.12) — BLEIBT
Tab 47:      MCORR (M.3-M.5) — BLEIBT mit AA.2 Korrektur-Banner
Tab 48:      NMATRIX (P.3) — BLEIBT mit AA.3 Annotation
Tab 49:      OPRTART (P.4) — BLEIBT mit AA.3+AA.4 Korrektur-Banner
Tab 50:      M-CORRECT-V2 Command-Pattern (CC.1) — NEU
Tab 51:      Default-Achsen-Lookup Mechanik (CC.2) — NEU
```

---

## §5 Konsequenzen fuer Z-Doks

Z.1-Z.5 sind ueberwiegend OK (Mermaid-Diagramme strukturieren die Klassen-Hierarchien). Erforderliche Updates:

| Z-Doku | Update wegen | Status |
|---|---|---|
| Z.1 cache-engine | AA.2 Command-Pattern-Sektion ergaenzen | AA.2-Update |
| Z.2 prt-art | AA.4 Default-Lookup-Annotation pro Achse | AA.3-Update |
| Z.3 Diplomarbeit/Code | AA.2 messung_driver submitiert BEIDE EE an CEB | AA.2-Update |
| Z.4 Cross-Repo | AA.2 CEB orchestriert beide EE-Adapter | AA.2-Update |
| Z.5 Gap-Analyse | AA.3 fehlende Achse = Default-Lookup statt "muss NEU" | AA.3-Update (KRITISCH) |

---

## §6 Querverweise

- Y.1-Y.4 Ist-Kartografie: `Y1_*.md` ... `Y4_*.md`
- Z.1-Z.5 Soll-UML: `Z1_*.md` ... `Z5_*.md`
- AA.2 M-Modell-Korrektur: Folge-Update von `../architektur/10_schichten_modell_M.md`
- AA.3 Z.5-Korrektur: Folge-Update von `Z5_master_index_und_gap_analyse.md`
- AA.4 O-Phase-Korrektur: Folge-Update von `../adapters/O_PHASE_PRT_ART_AXES_MIRROR.md`

---

**Ende docs/uml_planning/AA1_drawio_konsolidierung.md (AA.1 DONE).**
