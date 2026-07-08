# test_data_xml/ — Diplomarbeit-eigene Testdatensatz-XMLs

**Eingefuehrt:** V23.X1 (2026-05-14)
**Zweck:** Eigener Konfigurations-Slot der Diplomarbeit fuer Testdatensaetze, die ueber die Standard-XML-Configs in `comdare-cache-engine/cache_engine/algorithm_profiles/` und `comdare-cache-engine/cache_engine/builder/example_configs/` hinausgehen.

## Konvention

Pro Datensatz-Spezifikation eine XML-Datei `<name>.test_data.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- Diplomarbeit-eigene Testdatensatz-Spezifikation (V23.X1) -->
<comdare_test_data id="sosd_books_200M" source="SOSD">
  <metadata>
    <name>SOSD books_200M_uint64</name>
    <license>CC-BY 4.0</license>
    <size_bytes>1600000000</size_bytes>
    <source_url>https://dataverse.harvard.edu/.../EATHF7</source_url>
  </metadata>

  <key_value_signature>
    <key_types>std::uint64_t</key_types>
    <value_types>std::uint64_t</value_types>
  </key_value_signature>

  <local_path>tests/fixtures/external/sosd/books_200M_uint64</local_path>
  <fetch_script>tools/fetch_testdata.sh --dataset sosd_books_200M</fetch_script>
</comdare_test_data>
```

## Konsumption

`messung_driver` liest dieses Verzeichnis zusaetzlich zu den
cache-engine-Standard-Configs ein. Damit kann die Diplomarbeit eigene
Datensaetze definieren, die nicht in der cache-engine selbst hinterlegt sind.

## Membership (V23.X1 Initial)

| Datei | Datensatz | Status |
|---|---|---|
| `sosd_books_200M.test_data.xml` | SOSD books_200M_uint64 (1.6 GB) | Spezifikation (Daten via fetch_testdata) |
| `pizzachili_dna.test_data.xml` | Pizza&Chili DNA (404 MB gz) | Spezifikation |
| `english_words.test_data.xml` | english-words/words.txt (4 MB MIT) | Spezifikation |

V23.X2-V23.X4 fuegen die uebrigen Datensaetze hinzu (CoCo-Trie preprocessed,
it-2004.urls, SOSD osm_cellids/fb/wiki_ts, weitere Pizza&Chili-Korpora).

## Membership (#25, 2026-07-08 — 6er-Kanon tab:datasets)

Der kanonische Datensatz-Set ist die Thesis-Tabelle `tab:datasets` (Ledger §13.10-W5 / Gate
G-6v48; der aeltere `Termin 7`-48er-Katalog ist gestrichen). Die 6 Kanon-Datensaetze + 2
Bestands-Extras, je mit Reproduzierbarkeits-Akte (Quelle, Pruefsumme, Zeilenzahl, Vorverarbeitung):

| Datei | Kanon | Akte | Quelle |
|---|---|---|---|
| `url.test_data.xml` | ja | echt `0x888786d54c6fd026` / 5000 Z. | it-2004 (LAW) via CoCo-trie P04 |
| `protein.test_data.xml` | ja | echt `0xd7b59914049ee21a` / 14411 Z. | Pizza&Chili via CoCo-trie P04 |
| `tpcds-id.test_data.xml` | ja | echt `0x1081e3892da8ced6` / 629661 Z. | TPC-DS via CoCo-trie P04 |
| `trec-terms.test_data.xml` | ja | echt `0xccee239019e815a1` / 855665 Z. | TREC via CoCo-trie P04 |
| `pizzachili_dna.test_data.xml` | ja (dna) | echt `0x4024dd781795cdae` / 1866 Z. | Pizza&Chili DNA (Bestand) |
| `xml.test_data.xml` | ja | **honest-0** (Datei nicht lokal) | Pizza&Chili XML via P04 |
| `english_words.test_data.xml` | Extra | echt `0x69e841344f4d0b37` / 466550 Z. | dwyl/english-words (Bestand) |
| `sosd_books_200M.test_data.xml` | Extra | **honest-0** (binaer, nicht lokal) | SOSD (Bestand) |

Die vier echten CoCo-Akten sind gegen die IM ce-Repo COMMITTETEN CoCo-trie-preprocessed
`_no_suffixes_small`-Dateien berechnet (`preprocessing=coco-trie:no_suffixes_small` benennt die
Teilmengen-Vorverarbeitung ehrlich; es sind NICHT die rohen Voll-Korpora) und in CI durch
`test_25_kanon_dataset_akten` (ce) reproduzierbarkeits-verifiziert. `xml`+`sosd` = honest-0: keine
erfundene Pruefsumme, Akte folgt nach fetch. **OFFEN (Folge-Increment):** ein binaerer SOSD-uint64-
Loader (LE 8-Byte-Count + N×uint64) existiert noch nicht — der 6er-Kanon braucht ihn nicht (alle
String-Korpora ueber `string_corpus`); sosd (Bestands-Extra) waere echte Loader-Neuarbeit.

## Querverweis

- `docs/sessions/20260514-3000-v23-layout-vorschlag.md` (Layout-Plan)
- `tools/fetch_testdata.sh` (Download-Script, V23.3)
