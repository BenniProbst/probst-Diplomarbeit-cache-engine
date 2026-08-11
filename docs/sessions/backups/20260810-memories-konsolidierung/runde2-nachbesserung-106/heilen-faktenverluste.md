The consolidation is complete and verified at the object.

**Datei:** `/home/comdare/wt-super-landung/docs/plaene/20260810-KONSOLIDIERUNG-unverlinkte-memories.md`

## Zahlen

| Groesse | vorher | nachher |
|---|---|---|
| Zeilen | 1756 (Stand meines ersten Lesens) | **3859** |
| Byte | ~180 KB | **336061** |
| Herkunfts-Tabelle | 57 Zeilen | **106** (Soll erfuellt) |
| Widerspruchs-Bloecke | W-01…W-20 | **W-01…W-33** (13 neu) |
| Fakten-Kennungen | A…P | **+ Q, R, U, V, X, Y** |

**133 neue Fakten:** A-7…A-12 (6) · C-11…C-12 (2) · H-14…H-18 (5) · I-19…I-23 (5) · K-6…K-13 (8) · L-9…L-21 (13) · **Q-1…Q-14** (Kette/Docks) · **R-1…R-15** (Registries/XML/Mess-Schema) · **U-1…U-34** (Lagerhaltung/Bestandslog/Batch) · **V-1…V-16** (Achsen-Neuordnung 26.07.) · **X-1…X-11** (Firmen-Matrix) · **Y-1…Y-4** (Cluster-Netz/Orte). Sechs neue Abschnitte 3.11–3.16; alles Uebrige in die bestehende Ordnung eingefuegt.

Ein anderer Schreiber hat waehrenddessen an denselben Datei gearbeitet (die drei Faktenverluste der ersten Welle) — ich habe jede Einfuegung auf Ueberschriften verankert und vor jedem Schritt neu gelesen; keine Kollision.

## Die Zahl selbst nachgeprueft
`idx` **179** · `beide` **228** · `vorhanden` **286**. `comm -13 idx beide` = **exakt 49**. Abzuege: `MEMORY.md` ist in keiner Liste (deshalb 107→106 bzw. 58→57), `MEMORY-DETAIL.md` **ist** verlinkt. Ergebnis: **284 echte Memories, 178 verlinkt, 106 unverlinkt.** Tabellen-Gegenprobe maschinell: Dateinamen-Spalte gegen die erhobene 106er-Menge `diff`t — **identisch, 0 Abweichungen**. Aufteilung 50/24/32 = 106.

## Die vier staerksten neuen Funde
- **W-21/A-7** — OD-7 im Wortlaut: `heavy: concurrency=1, prod1=24 Worker · normal: BEIDE concurrency=2 x 12 Threads`. Die "1" und die "2" widersprechen sich **nicht**, sie sind zwei Job-Klassen. W-01 war vermischt.
- **W-22/A-8/A-9** — die "24" ist **vier Tage aelter als OD-7**: Owner 22.07. "prod1=32T/24K", 23.07. "AMD worker bitte auf 24 Threads drosseln" mit Messung (amd@32W 19,95 min == amd@24W 19,4 min, aber 20G Swap + OOM-Kills).
- **W-27** — `reference_prod1_comdare_env_setup` hat **kein `modified`-Feld**, mtime **2026-07-05 22:47:41**, und traegt den bwrap-Defekt bereits. Das Bruchfenster ist **04.–05.07.**, nicht "ab 07.07.".
- **W-32** — gemessen: `"…/Diplomarbeit - Datenbanken"` existiert nicht; Gegenprobe `…/docs/termine` existiert. Der "Pflicht-Pre-Read" steht auf totem Praefix.

## Was ich NICHT einordnen konnte
1. **Die Notation "prod1=32T/24K" (W-22).** "32 Threads / 24 Kerne" widerspricht dem Index-Fakt 16K/32T; "32 verfuegbar / 24 fuer Compile" passt zum 23.07.-Befehl, aber schlechter zu "prod2=24T/16K" (i9-14900KS = 24K/32T). Nur am Roh-Transkript des 22.07. aufloesbar — Quellenklasse liegt ausserhalb des Scopes.
2. **Registry-Zahl 2 gegen 3 (W-25).** Meine Aufloesungs-Hypothese (2 = Organ-Registries je Engine, 3 = Achsen-ARTEN, koennten koexistieren als 4 Dateien) ist als AGENTEN-BEHAUPTUNG gekennzeichnet und **nirgends belegt**.
3. **`std::variant`-Vorrang (W-23).** F3 (26.07., "KERN=Gesetz") verbietet es in ALLEN Tier-Typen, E-1 (02.08.) erlaubt es dem Hybrid. Spaeteres Datum gewinnt nach Hausregel — aber beide tragen Owner-Autoritaet; ich habe nicht entschieden.
4. **Der Torso in `reference_ci_runner_ice_cold_cache_instability`.** Das `description:`-Feld bricht mitten im Satz ab (offene Klammer). Was dort stand, ist nicht rekonstruierbar.
5. **`feedback_prt_art_consumes_cache_engine` bricht das Frontmatter-Schema** (`name:` ist ein Satz, Metadaten flach statt unter `metadata:`) — dokumentiert in 5.4, **nicht repariert**: ich aendere keine Quelldateien.
6. **Ungleiche Pruefschaerfe, ausdruecklich in 7.1b vermerkt:** die 57 sind stichprobengeprueft (3 harte + 4 kleine Verluste bei 10 Ziehungen), **die 49 hat kein zweiter Leser geprueft**. Das ist genau die Lage, in der die erste Welle sich fuer vollstaendig hielt und es zu 30 % nicht war.

Alle Zeilen ≤ 120 Byte (geprueft mit `LC_ALL=C`, 0 Verstoesse). Keine `[...]`-Kuerzung in einem Owner-Zitat der zweiten Welle.