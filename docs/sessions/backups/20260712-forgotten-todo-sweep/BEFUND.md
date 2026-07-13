# Forgotten-TODO-Sweep — BEFUND

Datum: 2026-07-12
Scope: Vergessene, unerledigte und im Goal-V4 / Ledger ungetrackte TODOs der Diplomarbeit (Cache-Engine).
Methode: Multi-Modalitaeten-Sweep (Ledger + Dossiers + Plan + Code-Marker-grep + Voll-Review-Bericht), Kandidaten gegen Ist-Stand (Quellcode, Working-Tree, gebautes PDF) verifiziert. Bereits getrackte und nachweislich erledigte Items ausgeschlossen.

---

## 1. Executive Summary

### Modalitaeten (Sweep-Durchlaeufe)

| # | Modalitaet | Kern-Datenquelle | Nutzbar |
|---|-----------|------------------|---------|
| 1 | Ledger-Vollesung | DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (1053 Z. / 456 KB) + §12-Log 309-797 + §13/§14 | ja |
| 2 | Dossier-/Anhang-Verifikation | Architektur-Dossiers 16-22, permutations.cmake, anhang/{de,en}/*.tex, diplomarbeit.tex | ja |
| 3 | Plan-Nachlauf | noble-shimmying-fairy.md (Phasen 0-6), E4-XML-Verdrahtung | ja |
| 4 | (degeneriert) | "test" — kein Befund | nein |
| 5 | Code-Marker-grep | TODO/FIXME/HACK/XXX/BUG/STUB/placeholder ueber super 01-09 + ce libs/apps + prt-art (~40 Treffer einzeln geprueft) | ja |
| 6 | Voll-Review-Abgleich | docs/sessions/backups/20260712-full-line-review/REVIEW-BERICHT.md (379 Z.) | ja |

- Modalitaeten gesamt: 6 (davon 1 degeneriert/leer → 5 produktiv).
- Kandidaten (grober Roh-Pool, Modalitaet 5 dominierend): ~40 Code-Marker + Ledger-/Dossier-/Working-Tree-Kandidaten, jeweils einzeln in Kontext geprueft.
- Bestaetigt (nach Verifikation, Duplikat- und Erledigt-Ausschluss): 4.

### Bestaetigte Items — je Stufe und Schwere

| Goal-V4-Stufe | major | minor | Summe |
|---------------|:-----:|:-----:|:-----:|
| G3 | 1 | 0 | 1 |
| NEU (ungefasst) | 2 | 1 | 3 |
| **Gesamt** | **3** | **1** | **4** |

Keine bestaetigten Items in G1, G2, G4-G8 oder in bereits gated Stufen. Der ganz ueberwiegende Rest des Projekts ist ausserordentlich lueckenlos getrackt (§12 disponiert Katalog #253-#276 item-belegt); genuin vergessene, ungetrackte Items sind rar. Bewusst wurden 4 belegte statt weiche Kandidaten aufgenommen.

---

## 2. Bestaetigte vergessene TODOs (gruppiert nach Goal-V4-Stufe)

### G3 — Guard-/Ehrlichkeits-Semantik der Achsen (1 Item)

**G3-F1 — Ungeguardeter uint16-Narrow-Cast im Mapping-Observer-Seitenpfad** — Schwere: **major**

- Quelle: `Ledger:323` (07-03): *"Geflaggt (out-of-scope, Follow-up): ungeguardeter uint16-Narrow-Cast im Mapping-Observer-Seitenpfad, abi_adapter.hpp:762/831, slot_index_type=uint16"*.
- Evidence: Ledger:323 flaggt den Cast zweimal explizit als out-of-scope Follow-up; ein Nachzug ist im Log/Board nirgends verzeichnet. `map_organ_.register_slot(static_cast<slot_index_type>(key))` mit `key=uint64` und `slot_index_type=uint16` truncatet fuer `key >= 65536` still — ohne Guard, ohne ehrliche Ablehnung.
- Warum G3: Es ist exakt die Fehlklasse, die 217-2a fuer `Container::max_fanout` an der Wurzel bereits geloest hat (ehrlicher Guard statt stiller Trunkierung). Der Seitenpfad wurde davon ausgenommen und nie nachgezogen — inhaltlich also eine offene Facette der bereits in G3 verankerten Guard-/Ehrlichkeits-Doktrin.
- Empfohlene Einordnung: Als Nachtrag unter G3 fuehren (Guard bzw. ehrliche Ablehnung fuer `abi_adapter.hpp:762/831`), nicht als neue Stufe.

### NEU — im Goal-V4 aktuell NICHT gefasste Stufen/Facetten (3 Items)

**NEU-1 — Anhang B "Code-Struktur" ist ein 4-Zeilen-Stub** — Schwere: **major**

- Quelle: `thesis/diplomarbeit/anhang/en/B_code_structure.tex:1-4` (nur `\chapter` + `% PROJECT_LAYER_MAP excerpts …`); `anhang/de/B_code_structure.tex:3` `% TODO(DE): Uebersetzung`.
- Evidence: Working-Tree beider Sprachvarianten = 4/4-Zeilen-Stub (EN nur Kommentar-Skizze, DE nur TODO). Der im Ledger als AP-B4 fertig beschriebene Inhalt (reale Verzeichnisbaeume/Komponenten-Tabellen der 3 Repos, 125 Pfade) fehlt; der gebaute PDF liefert einen leeren Anhang B.
- Warum NEU (nicht G8): G8 deckt ausschliesslich Messwerte/Anhang A ab, nicht Code-Struktur/Anhang B. Diese Abgabe-Blocker-Facette ist in keiner G-Stufe gefasst.
- Empfohlene Einordnung: Als eigene Abgabe-Blocker-Stufe (Anhaenge B/E) neben G8 aufnehmen.

**NEU-2 — Anhang E "Architekturentscheidungen" (ADR) ist ein 4-Zeilen-Stub** — Schwere: **major**

- Quelle: `thesis/diplomarbeit/anhang/en/E_architecture_decisions.tex:1-3` (nur `\chapter` + `% Architecture Decision Records F1--F15 …`); `anhang/de/E_architecture_decisions.tex:3` `% TODO(DE): Uebersetzung`.
- Evidence: Working-Tree beider Varianten = 4/4-Zeilen-Stub (EN 2 Kommentarzeilen auf die Quelle, DE nur TODO). Der als AP-B5 fertig protokollierte Inhalt (12 ADRs mit Kontext/Entscheidung/Konsequenz/Beleg) fehlt; TOC zeigt Kapitel E ab S.131 ohne jede Sektion, direkt gefolgt von F ab S.133.
- Warum NEU: Gleiche Luecke wie NEU-1; in keiner G-Stufe gefasst.
- Empfohlene Einordnung: Zusammen mit NEU-1 in die Abgabe-Blocker-Stufe Anhaenge B/E.

**NEU-3 — `binary_blob_writer.hpp`: CRC64-Footer fehlt (Platzhalter 0) + Format-Bruch CRC64 vs. 4B** — Schwere: **minor**

- Quelle: `Code/external/comdare-cache-engine/libs/test_infra/benchmark_suite/include/comdare/benchmark_suite/binary_blob_writer.hpp:8` (Layout "footer: CRC64 4B") + `:49` ("placeholder CRC = 0; Phase 7 ergaenzt echte CRC64").
- Evidence: `:50` schreibt konstant `write_u32(out, 0)`; die als "Phase 7" geplante echte CRC64-Pruefsumme fehlt bis heute. Zusaetzlich latenter Format-Bruch: Header-Layout dokumentiert "CRC64 4B", geschrieben/reserviert werden aber nur 4 Byte (u32) = CRC32-Breite, nicht CRC64 (8B). Jede Integritaetspruefung eines Blobs liest 0 und der Typ passt nicht zur Spezifikation.
- Warum NEU: Betrifft die Mess-Infrastruktur (benchmark_suite), keine G-Stufe erfasst es. Kein Abgabe-Blocker (Messbetrieb funktioniert), aber offener geplanter Rest ("Phase 7") + Spezifikations-Inkonsistenz.
- Empfohlene Einordnung: Als low-prio Infrastruktur-Nachtrag; Format-Kommentar (`CRC64 4B`) mindestens konsistent machen (entweder echte CRC64/8B oder Doku auf CRC32/4B korrigieren).

---

## 3. Nachtrags-Vorschlaege fuer Goal-V4 / Ledger

Konkrete Formulierungen, je Stufe einzuhaengen:

### G3 (bestehende Stufe erweitern)

> **G3-Nachtrag (07-12 Sweep):** uint16-Narrow-Cast im Mapping-Observer-Seitenpfad (`abi_adapter.hpp:762/831`, `slot_index_type=uint16`) ehrlich guarden — analog 217-2a fuer `Container::max_fanout`. Aktuell (Ledger:323, 07-03) als out-of-scope geflaggt und nie nachgezogen: `key >= 65536` truncatet still statt ehrlicher Ablehnung. Schwere major.

### NEU-Stufe "GX — Abgabe-Blocker Anhaenge B/E" (neu anlegen, neben G8)

> **GX (neu, 07-12 Sweep) — Anhaenge B & E ausschreiben:**
> - Anhang B "Code-Struktur" (AP-B4): reale Verzeichnisbaeume + Komponenten-Tabellen der 3 Repos (125 Pfade) statt 4-Zeilen-Stub (`anhang/{en,de}/B_code_structure.tex`). DE-Uebersetzung. Schwere major.
> - Anhang E "Architekturentscheidungen" (AP-B5): 12 ADRs (Kontext/Entscheidung/Konsequenz/Beleg) statt 4-Zeilen-Stub (`anhang/{en,de}/E_architecture_decisions.tex`). DE-Uebersetzung. Schwere major.
> - Verifikation: gebauter PDF fuellt Kapitel B und E (aktuell leer: E ab S.131 ohne Sektion, direkt F ab S.133).
>
> Abgrenzung: G8 deckt nur Messwerte/Anhang A — B/E sind separat und ungetrackt.

### NEU (Infrastruktur-Nachtrag, low prio; Ledger-§12-Katalog)

> **07-12 Sweep — benchmark_suite binary_blob_writer CRC64:** echte CRC64-Footer-Pruefsumme implementieren (aktuell `:50` `write_u32(out,0)` Platzhalter, "Phase 7" nie umgesetzt) ODER Layout-Doku `:8` "CRC64 4B" auf tatsaechliche 4B/CRC32-Breite korrigieren (Format-Inkonsistenz CRC64 vs. u32). Schwere minor.

---

## 4. Coverage-Nachweis

- **Ledger:** DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md vollstaendig gelesen (1053 Z. / 456 KB, in Chunks): §0 Goal+V4, §1-§11, §11-G/H/I, §12-Log komplett (Z.309-797, reverse-chron 07-12 bis 07-03; 10 Folge-Increment-Marker einzeln quergeprueft), §13 Nacht-Audit + Katalog + W1-W5, §14 Gate-Sammlung 07-07.
- **Dossiers:** Architektur-Dossiers 17/20/21/22 vollstaendig, 16/18/19 per gezieltem grep.
- **Plan:** noble-shimmying-fairy.md (Phasen 0/0.5/1/2/3/4/5/6); STANDARDPROZESS, WORKFLOW-4layer, session-ende-9.
- **Ist-Stand-Verifikation:** permutations.cmake; anhang/{de,en}/*.tex; diplomarbeit.tex `\include`-Zeilen; ce `abi_adapter.hpp`, `sota_catalog.hpp`, `swiss_group_probe_traversal_organ.hpp` vs `axis_hash_probe_shape`-Modul, `best_binary_selector`, `profile_facade`, `dataset_loader`, driver `main.cpp`; `binary_blob_writer.hpp`; git log; measurement/.
- **Code-Marker-grep:** TODO|FIXME|HACK|XXX|BUG|not implemented|STUB|Platzhalter|placeholder ueber super 01-09 + ce libs/apps + prt-art src/include (build/ext/tests-fixtures ausgeschlossen): ~40 Treffer je einzeln in Kontext geprueft.
- **Review-Abgleich:** Voll-Review-Bericht 20260712 (docs/sessions/backups/20260712-full-line-review/REVIEW-BERICHT.md, 379 Z.) komplett.

### Ausgeschlossen (getrackt oder erledigt — nicht "vergessen")

- **Bereits getrackt:** Task-Board #1-7; Goal-V4 G1-G8; Voll-Review 368; AP-Text-Agent-Marker #171/#172/#175/#182 (via §11-C, #235-#249); §12-Katalog #253-#276 (item-belegt).
- **Nachweislich erledigt:** 234-V, 7b-3, Datasets 25/45, AP-4-Stufe3, 221, CMD-2, 224; AP-4 nach Code-Check verworfen (6 per-Host FullJoin-Kompositionen real gebaut).
- **Als NICHT-vergessen widerlegt:** V17-Codegen (8 `*_body.hpp.template` + `codegen.cpp:92-111` voll implementiert, README-"TODO" stale); P5/P6 Single-XML (`run_lazy_150.cpp` + alle `*.ps1` geloescht, `main.cpp:535/591` E4-XML = Alleinweg, Legacy nur gated opt-in); #266 config/memory-Vendoring (`:459/:505` aufgeloest, Task #11 done); STRUCTURAL_CORRECTION V6/V7/V9/V10 (stale, durch Umbau erledigt); thesis-anhang-wiring-READY (via GO-1 #24 committet); ce-interne Juni-Ledger (goal-v6/20260618-OFFENE-TODOS superseded/V42-gated).

### Grenzen des Sweeps

- Nur Working-Tree + committete Artefakte + Ledger; keine externen Systeme.
- Modalitaet 4 ("test") lieferte keinen Befund (degeneriert).
- Bewusste Praezisions-Praeferenz: 4 belegte Items statt weicher/spekulativer Kandidaten. Projekt ist ausserordentlich lueckenlos getrackt.
