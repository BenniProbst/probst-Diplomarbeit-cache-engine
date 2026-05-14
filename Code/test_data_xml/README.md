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

## Querverweis

- `docs/sessions/20260514-3000-v23-layout-vorschlag.md` (Layout-Plan)
- `tools/fetch_testdata.sh` (Download-Script, V23.3)
