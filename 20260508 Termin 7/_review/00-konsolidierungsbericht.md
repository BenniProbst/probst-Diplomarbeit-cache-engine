# Konsolidierungsbericht Termine 1-6

**Stand:** 2026-05-04 · **Termin 7** · **Phase 3.A**
**Zweck:** Roter Faden ueber alle 6 Termine, mit Cross-Referenz zum konsolidierten Quellenkatalog (REV4) und Identifikation der zentralen Designentscheidungen.

---

## Roter Faden — Themenentwicklung Termin 1 → 6

| Termin | Datum | Hauptbeitrag | Zustand |
|---|---|---|---|
| T1 | 2026-03-30 | PRT-ART Idee einfuehren · Trie-Huelle + Redirect-Knoten + lokale Seitenfamilie · Bausteine aus Literatur ableiten | Skizze offen |
| T2 | 2026-04-05 | **Kernarchitektur einfrieren**: ValueHandle, 5 Seitentypen, Invarianten I1-I6 · **Cache-Engine als Meta-Ebene** zum ersten Mal explizit | Architektur-Freeze v1 |
| T3 | 2026-04-09 | Benchmark + Datensatzplan + Baselines + Fairnessregeln · Plattformmatrix lokal+ZIH | Mess-Plan v1 |
| T4 | 2026-04-12 | **Scope-Freeze v2** · Grosse Forschungsdokumentation (70 Referenzen) · Cache-Engine als aktiver Kernbeitrag schaerfen | Cache-Engine-Position |
| T5 | 2026-04-12+16 | **Forschungslandkarte** (18 zentrale Quellen) · PRT-ART als Control Plane positionieren · Forschungsluecke schaerfen | Wissenschaftliche Verortung |
| T6 | 2026-04-16 | **Plattformmatrix** (RISC-V/Arm/x86/ZIH) · 3 Cache-Engine-Modi (passiv/Warm-up/online) · Messstack je Plattform | Verifikationsstrategie |

---

## Domaenen-Trennung im roten Faden

**Beobachtung wichtig:** Die Trennung "Such-Algorithmen vs Cache-Engine" wird erst ab **Termin 2** explizit. Davor (T1) ist die Trie-Architektur noch ein einziger monolithischer Vorschlag.

| Termin | Such-Algorithmus-Domaene | Cache-Engine-Domaene |
|---|---|---|
| T1 | Trie-Huelle, Redirect, Seitenfamilie, ValueHandle (implizit) | (noch nicht getrennt) |
| T2 | Bestaetigt + ValueHandle::Inline/External/ChainRef | **Erste explizite Trennung als "zweite Steuerlogik"** |
| T3 | Common-Denominator-Modus (Such-Logik allein) | Native-Modus (mit Cache-Engine-Tricks) — fuer faire Messung |
| T4 | (stabil) | **Aktive Cache-Engine** als Hauptbeitrag — Aktive vs Passive Cache-Awareness |
| T5 | (stabil) | "Control Plane ueber trie-basierter Suche" — wissenschaftliche Verortung |
| T6 | (stabil) | Verifikationsstrategie ueber Plattform-Extreme |

---

## Konvergierte Designentscheidungen (Stand T6)

### Such-Algorithmen-Domaene — eingefroren in T2:

1. **Globale Trie-Huelle** mit CoCo-trie-artigen Redirect-Knoten fuer eindeutige Restpfade
2. **5 lokale Seitentypen** (Familie, Auswahl per Cache-Engine):
   - Redirect-Page (CoCo-trie / klassische Pfadkompression)
   - Dense-Byte-Page (ART)
   - Extended Dense Page (START)
   - Sparse Patricia Page (HOT)
   - PRT-Custom-Cache-Page (B²-tree + CSS/CSB+ Schnitt)
3. **Terminale Knoten** (statt terminaler Blaetter): tragen ein ValueHandle
4. **Hot/Cold-Split**: Navigation klein und heiss; Payload extern
5. **ValueHandle**: `Inline` (kleine Werte), `External` (Standardpfad), `ChainRef` (vertagt)
6. **Ordnungsmodi (3 Achsen)**: unsorted / local-sorted / lex-mode

### Cache-Engine-Domaene — eingefroren in T2 + T4 + T6:

1. **Logisch getrennt** von Trie-Engine (Termin 2)
2. **Eingaben**: lokale Dichte, Praefixentropie, erwartete Cache-Lines/Pages, Key/Value-Groesse, ISA-/Hardwareprofil
3. **Entscheidungen**: Seitentyp, Alignment, lokale Ordnung, Inline-vs-Pointer-Value, Reorganisation
4. **Aktivitaetsstufen (T6 Modus 1-3)**:
   - Modus 1: passiv/statisch — feste Seitentypen ohne Plattformkalibrierung
   - Modus 2: Warm-up-kalibriert — einmalige Mikrobenchmarks
   - Modus 3: online adaptiv — laufende Rekalibrierung
5. **Telemetrie-Mechanik** (T4): Probability Sketches/Read Counters in Page-Headern
6. **Online-Relocation** (T4): block-/page-weise Umkopier-Strategien

---

## Zentrale Hypothesen (verstreut ueber T1-T5)

| ID | Aus | Hypothese |
|---|---|---|
| H1 | T1 | PRT-ART gewinnt nicht ueber asymptotische Neuheit, sondern ueber bessere CLU/LLC/dTLB/Branch-Profile |
| H2 | T1 | Es gibt KEINE universell beste lokale Seitendarstellung; haengt von Dichte/Workload/CPU ab |
| H3 | T1 | Pflicht-Operationen sind Exact/Prefix Lookup + Prefix Enumeration; nicht Range-Scans |
| H4 | T1 | Ordnungsmodus ist nicht universell optimal; tradeoffs Punkt vs Range |
| H5 | T4 | Aktive Cache-Awareness ueberlegen passiver, plattformbewusst |
| H6 | T5 | Forschungsbeitrag liegt in der getrennten Cache-Control-Plane, nicht im weiteren Trie |

---

## Detail-Konsolidierungen

Pro Termin ein Markdown:
- [`T1-konsolidierung.md`](./T1-konsolidierung.md)
- [`T2-konsolidierung.md`](./T2-konsolidierung.md)
- [`T3-konsolidierung.md`](./T3-konsolidierung.md)
- [`T4-konsolidierung.md`](./T4-konsolidierung.md)
- [`T5-konsolidierung.md`](./T5-konsolidierung.md)
- [`T6-konsolidierung.md`](./T6-konsolidierung.md)

---

## Schnittstelle zu Phase 3.B / 3.C / 3.D (Bearbeitungskern)

Was Phase 3.A liefert: Termine inhaltlich vollstaendig erfasst und mit verfuegbaren Papern verknuepft.

Was die Phasen 3.B/3.C/3.D bekommen muessen:
- **Phase 3.B**: Pro Paper (alle 31 vorhandenen) Eigenschaften extrahieren — Datenstruktur, Knotentyp, Operationen, Komplexitaet, Concurrency, Cache-Annahmen.
- **Phase 3.C** (KERN): Begriffsglossar finalisieren — pro Konzept eine eindeutige PRT-ART-Bezeichnung, Synonyme aus N Papern, funktionale Identitaet.
- **Phase 3.D**: Domaenenmodell finalisieren — Modul-Aufstellung Such-Algorithmen-Domaene + Cache-Engine-Domaene + ihre Schnittstelle.
