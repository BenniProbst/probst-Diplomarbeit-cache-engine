# probst-diplomarbeit-cache-engine

Umbrella-Repositorium der Diplomarbeit **"Active Cache-Aware Hardware Adaptation:
Cache Engine for Trie-Based Index Structures"** (Benjamin-Elias Probst,
Technische Universitaet Dresden, 2026). Es enthaelt den Anwender-Code der
Messkette, die Planungs- und Sitzungsdokumentation, die vendorierte
Forschungsliteratur und bindet die Comdare Cache Engine, PRT-ART und das
Thesis-Manuskript als Submodule ein.

*English summary:* umbrella repository of the diploma thesis named above. The
repository's own code is Apache-2.0; the embedded Comdare Cache Engine and
PRT-ART are source-available under the Comdare Research License 1.0 (free for
research at an institution, separate written license for business and for
individual use, Apache-2.0 from the Change Date 2031-08-10). See `LICENSE`,
`NOTICE`, `REUSE.toml` and `LICENSES/`.

## Aufbau

| Pfad | Inhalt |
|---|---|
| `Code/` | Anwender-Schicht: Messtreiber, CSV/LaTeX-Pipeline, CI-Wachen (`Code/README.md`) |
| `Code/external/comdare-cache-engine` | Submodul: Comdare Cache Engine (Framework-Modul) |
| `Code/external/comdare-prt-art` | Submodul: PRT-ART (experimenteller Pruefling) |
| `thesis/diplomarbeit` | Submodul: Thesis-Manuskript (LaTeX, Baupfad der CI) |
| `Code/external/20260931-overleaf-diplomarbeit` | Zweite Einbindung des Manuskripts: statischer Fundort der Anhaenge |
| `docs/` | Ledger, Plaene, Sitzungen, Architektur (`docs/INDEX.md`) |
| `Forschungsarbeiten/` | Literatur und vendorierter Forschungscode (unveraendert, wird nicht gebaut) |
| `ci/`, `scripts/` | CI-Wachen und Hilfsskripte |

## Bauen und pruefen

```sh
git submodule update --init Code/external/comdare-cache-engine Code/external/comdare-prt-art
./configure.sh            # GNU-Bauweg; konfiguriert Code/ nach build/
make                      # bauen
make check                # Google Tests (Label da_unit), einschliesslich der CI-Wachen
```

Details: `MANUAL_RUN.md`, `Code/USAGE.md`, `docs/ENTWICKLER-IDE-EINSTIEG.md`.
Lebender Projektstand: Kopf von `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`
(juengster KON-Eintrag).

## Lizenz

- Eigencode: Apache License 2.0 (`LICENSE`, mit Abschnitt GELTUNGSBEREICH; `NOTICE`).
- Comdare Cache Engine und PRT-ART: Comdare Research License 1.0
  (`LICENSES/LicenseRef-Comdare-Research-1.0.txt`, byte-gleiche Kopie der
  Submodul-LICENSE; Rechteinhaber BEP Venture UG (haftungsbeschraenkt), Marke Comdare).
- Thesis-Repositorium (Submodule `thesis/diplomarbeit` und
  `Code/external/20260931-overleaf-diplomarbeit`): CC BY 4.0, Urheberrecht bei
  Benjamin-Elias Probst (`LICENSES/CC-BY-4.0.txt`, byte-gleiche Kopie der
  Submodul-Fassung, bewacht per NOTICE-Zeile `WACHE: LIZENZTEXT`; Owner-Entscheid
  07.09.2026, Lizenz-/Vertragszug #179, Punkt 8). Nutzungsrechte-Vertrag Urheber ->
  BEP Venture UG (oeffentliche Fassung): `docs/recht/`.
- Entwuerfe, Kompilat-Schnappschuesse vor dem 07.09.2026 und Pruefungsunterlagen:
  Urheberrecht bei Benjamin-Elias Probst
  (`LICENSES/LicenseRef-Diplomarbeit-Copyright-Only.txt`; bis 07.09.2026 galt das
  auch fuer die Thesis selbst).
- Vendorierter Forschungscode und Literatur: je eigene Lizenz oder keine
  (`NOTICE`, `REUSE.toml`, `LICENSES/`).

Die Zuordnung je Pfad steht in `REUSE.toml` (REUSE-Spezifikation 3.3) und ist
maschinell bewacht: `Code/tests/unit/test_ci_wache_lizenz_konsistenz.cpp` paart
`NOTICE` gegen `.gitmodules` und den Arbeitsbaum und prueft die Lizenztext-Kopie
Byte fuer Byte gegen das Submodul. Pruefung der REUSE-Konformitaet: `reuse lint`
an der Wurzel.

## Mitwirken, Sicherheit, Zitieren

`CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`, `CHANGELOG.md`, `CITATION.cff`.
