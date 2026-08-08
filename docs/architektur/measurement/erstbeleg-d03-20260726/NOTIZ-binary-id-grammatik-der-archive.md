# NOTIZ: binary_id-Grammatik der hier liegenden Mess-Archive

> Additiver Vermerk, angelegt 2026-08-06 im Zuge von B14/KF-6. **Es wurde keine
> Messdatei veraendert, verschoben oder geloescht** (Doktrin: Messdaten sind
> additiv, nie destruktiv). Diese Notiz existiert, damit ein spaeterer Vergleich
> alt gegen neu nicht still falsch wird.

## Ist-Stand der Archive

`20260726-164259-d03-strukt-r-erstbeleg/measurements.csv` (und die Dateien unter
`per_binary/`) tragen `binary_id`-Pfade mit **18 Segmenten**, in der kanonischen
`kCompositionAxisNames`-Reihenfolge:

```
search_algo / cache_traversal / mapping / path_compression / node_type /
memory_layout / allocator / prefetch / concurrency / serialization /
value_handle / index_organization / io_dispatch / migration_policy /
filter / queuing_q1 / queuing_q2 / persistence_target
```

Ein `cacheline`-Segment kommt **nicht** vor.

## Was sich mit KF-6 aendert

Mit dem KF-6-Vollausbau deklariert die Trigger-Input-Basis
`Code/test_data_xml/experiment_golden_kern.xml` die per-Organ-Unterachse
`cacheline` mit allen vier Line-Groessen (32/64/128/256). Eine deklarierte
Sub-Dimension wird beim Konsum eine **statische** Ebene
(`profile_to_tree.hpp`, `is_static=true`) und **geht damit in die `binary_id`
ein**. Neue Laeufe tragen also ein zusaetzliches Segment
(`cacheline.line_size=<n>`), und der Tier-Binary-Raum waechst um den Faktor 4
(bezogen auf den golden-Organraum 2^17: 4 x 131072 = 524288).

Praktische Folge fuer die Auswertung:

- **Kein Zeilen-Join alt gegen neu ueber die rohe `binary_id`.** Die Zeichenkette
  ist nicht mehr dieselbe, auch wenn die 18 Organ-Achsen identisch belegt sind.
  Der Vergleich muss ueber die 18 Organ-Segmente projizieren und das
  `cacheline`-Segment gesondert behandeln.
- Die Archiv-Zeilen entsprechen dem Achsen-Default der Unterachse
  (`CacheLineConfig{}` = B64, `kDefaultLineBytes == 64`) -- sie sind damit den
  kuenftigen `cacheline.line_size=64`-Zeilen semantisch am naechsten, aber nicht
  automatisch gleich (die Achse war beim Erstbeleg schlicht nicht angebunden).
- **Erwartete Nicht-Differenzierung** (Deep-Research A4, Abschnitt 4.5 Punkt 5):
  an einer Scan-Stelle mit Record-Groesse 48 gilt `round_up(48,32) = 64`, d.h.
  `line_size` 32 und 64 laufen dort auf denselben effektiven Stride hinaus
  (Aequivalenzklassen `{32,64} -> 64`, `128 -> 128`, `256 -> 256`). Das ist
  erwartetes Verhalten und **keine** Regression.

## Offen (nicht in diesem Paket)

Der Lese-/Konsum-Kanal fuer `<organ_subaxes>` liegt in `comdare-cache-engine`
(Parser, Validator, Codegen-NTTP) und ist als Auflage dokumentiert; bis dahin ist
die Deklaration wirkungslos und die Archive bleiben vergleichbar wie bisher.
