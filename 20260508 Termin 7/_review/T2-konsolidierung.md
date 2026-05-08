# Termin 2 — Konsolidierung

**Datum:** 2026-04-05
**Hauptthema:** Architektur einfrieren · **Cache-Engine als zweite Steuerlogik** zum ersten Mal explizit getrennt
**Zustand:** Architektur-Freeze v1

## Zentrale Texte

- `20260330 Termin 2__20260405_Arbeitsaufstellung_PRT_ART_Termin2_final.docx`
- `20260330 Termin 2__20260405_PRT_ART_Architekturentscheidungen_Termin2_final.docx`

## Eingefrorener Kernentwurf

| Eingefroren | Detail |
|---|---|
| Globale Form | Ordnungserhaltende Trie-Huelle mit CoCo-trie-artigen Redirect-Knoten |
| Lokale Suchseiten | **5er-Familie**: Dense-Byte-Page, Extended Dense Page, Sparse Patricia Page, Redirect-Page, PRT-Custom-Cache-Page |
| Terminale Semantik | Terminale **Knoten** (NICHT terminale Blaetter), tragen ein ValueHandle |
| Payload | Hot/Cold-Split, kleine Werte optional inline |

## ValueHandle (3 Varianten)

| Typ | Wann | Begruendung |
|---|---|---|
| `ValueHandle::Inline` | Kleine Werte | Spart eine Pointer-Indirektion bei Mitlesen aus derselben Cache-Line |
| `ValueHandle::External` | Standardpfad fuer groessere Werte | Terminaler Knoten haelt nur Pointer/Handle |
| `ValueHandle::ChainRef` | Value-Dedup, Verkettung | **Vertagt** — nicht Kern von T2 |

## Cache-Engine als zweite Steuerlogik (NEU IN T2!)

> "Die Cache-Engine ist logisch von der Trie-Engine getrennt. Sie ist keine neue Query-Engine, sondern ein lokales Entscheidungswerk, das Seitentyp, Ausrichtung und Handle-Strategie auswaehlt. Damit wird Cache-Awareness explizit statt implizit."

| Eingaben | Entscheidungen |
|---|---|
| Lokale Dichte und Fanout | Seitentyp |
| Praefixentropie / gemeinsame Restpfade | Alignment |
| Erwartete beruehrte Cache-Lines/Pages pro Lookup | Lokale Ordnung |
| Key- und Value-Groesse + Inline-Eignung | Inline-vs-Pointer-Value |
| ISA-/Hardwareprofil (AVX2, optional AVX-512) | Reorganisation von Node-Gruppen |

**Status T2:** Konkretes Kostenmodell-Geruest — numerische Schwellwerte erst T3.

## Invarianten I1-I6

| ID | Invariante |
|---|---|
| I1 | Jeder Lookup traversiert ausschliesslich Navigationsknoten bis zu einem terminalen Knoten oder Miss |
| I2 | Ein terminaler Knoten besitzt genau **ein** ValueHandle; Payload standardmaessig extern, optional inline |
| I3 | Redirect-Knoten komprimieren eindeutige Restpfade, ersetzen aber keine echte Mehrfachverzweigung |
| I4 | Lokale Seitencodierung darf variieren, solange die Ordnungsrelation der rohen Byte-Keys nicht verletzt wird |
| I5 | Seitentyp-Umschaltungen sind **explizite Policy-Entscheidungen**; feste universelle Schwellwerte werden nicht behauptet |
| I6 | Concurrency bleibt im Kernumfang auf spaetere Erweiterung begrenzt; T2 fokussiert Single-Thread und Read-Scaling-Vorbereitung |

## Risiken und Gegenmassnahmen

| Risiko | Gegenmassnahme |
|---|---|
| Framework-Explosion | Kern auf 5 Seitentypen + ValueHandle + Ordnungsmodus + Cache-Engine begrenzen |
| Architekturabhaengigkeit | Hardwareprofile statt universeller Konstanten |
| Zu komplexe Cache-Engine | T2 nur Entscheidungsgeruest; numerische Kalibrierung auf T3 verschieben |
| Inline-Value-Fehlannahmen | Inline nur als messbare Policy, nicht als Default |
| Concurrency-Scope | Multi-Writer NICHT im Kernumfang |

## Was T3 beantworten muss

- Pflicht-Datenmengen, Praefixentropien, Key-Laengen
- Welche Baselines tatsaechlich implementiert: ART, HOT, eine cache-sensitive B+-Variante, eine einfache B+/Hash-Referenz
- Wie wird die Cache-Engine kalibriert: perf, Intel Advisor MAP/Roofline, gezielte Mikrobenchmarks je Seitentyp?
- Fairnessregeln fuer Inline-Werte, lokale Ordnung, hardwareabhaengige ISA-Pfade
