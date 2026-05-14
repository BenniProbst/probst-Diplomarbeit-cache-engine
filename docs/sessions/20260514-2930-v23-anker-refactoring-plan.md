# V23 — Anker (Refactoring-Plan, 2026-05-14, 29:30)

**Vorgaenger:** `20260514-2900-implementierungsverlauf-V19-V22.md`
**Modus:** Recherche-Phase fertig, Plan-Vorlage zur User-Approval

---

## §1 Befund — Bestandsaufnahme cache-engine

**Top-Level-Inventar (27 Ordner):**
- 8 obsolete Build-Verzeichnisse (`build-msvc`, `build-msvc-v8` ... `build-msvc-v19`), ~7 GB, ~7'900 Dateien
- 3 leere Ordner: `build/`, `modules/`, `datasets/`
- `prt_art/` mit 44 Dateien in 14 Subdirs (~80 % Skelett, 20 % echte Header)
- `ext/` mit 22 Sub-Repos (12 Algorithmen P01-P30 + 10 Allokatoren A01-A20), 3'271 Dateien — alle aktiv
- 14 echte Komponenten (cache_engine, experiment, workload_generator, builder, codegen, ...)
- 182 CMakeLists.txt rekursiv

**Top-Probleme:**
1. Build-Verzeichnisse fluten den Root (8 Stueck statt 1)
2. `prt_art/` doppelt vorhanden (cache-engine + prt-art-Repo)
3. `modules/` + `datasets/` geplant, nie gefuellt
4. Kein `CMakePresets.json` → jeder Build legt eigenes Top-Level-Verzeichnis an
5. CoCo-Trie + SOSD Benchmark-Daten noch nicht heruntergeladen

---

## §2 Web-Recherche — C++ Best Practices

**Empfohlenes Layout-Pattern:** PFL (Pitchfork Layout) `libs/<name>/`-Variante, kombiniert mit Modern-CMake project-per-subdirectory.

**Ordner-Konvention:**
| Pfad | Zweck | Aktion |
|---|---|---|
| `build/<preset>/` | Out-of-Source-Builds (alle Presets unter EINEM Top-Level) | NEU via CMakePresets |
| `src/` oder `libs/<name>/src/` | Source + private Header | bleibt |
| `include/` oder `libs/<name>/include/` | Public-API-Header | bleibt |
| `tests/` + `tests/data/` | Tests + kleine Test-Daten | bleibt |
| `tests/fixtures/external/` | downloaded Daten (gitignored) | NEU |
| `ext/` | Vendor-Code (Submodules + FetchContent) | beibehalten |
| `cmake/` | CMake-Module + Helper | bleibt |
| `data/` | Production-Assets (NICHT Test-Daten) | hier nicht relevant |
| `docs/` | Dokumentation | bleibt |
| `tools/` | Dev-Skripte (z.B. fetch_testdata) | NEU |

**CMakePresets-Pattern (Standard moderner Open-Source-Projekte):**
```jsonc
{
  "version": 6,
  "configurePresets": [{
    "name": "msvc-release",
    "binaryDir": "${sourceDir}/build/${presetName}",
    "generator": "Visual Studio 17 2022"
  }]
}
```
+ `.gitignore` mit `/build/` (root-only).

**Vendor-Code:** `ext/` (bestehender Name) bleibt — gleichwertig zu `external/` und `vendor/`. Submodules fuer Forks, FetchContent fuer reine Konsumenten.

**Quellen:** Pitchfork-Spec, Modern CMake Book (Schreiner), CMakePresets(7) Manual, Galowicz Mixed C++ Monorepo, spdlog/fmt Layout-Referenzen.

---

## §3 CoCo-Trie + SOSD Datenquellen

| Korpus | Groesse | Lizenz | URL | Pflicht fuer |
|---|---|---|---|---|
| **SOSD** (books, osm, fb, wiki_ts) | 22.2 GB (Zenodo) / 1.6-6.4 GB einzeln | CC-BY 4.0 | https://zenodo.org/records/15240501 + Dataverse | P05, P06, P11-P20 (Layout-Theorie) |
| **Pizza&Chili** (XML, DNA, Protein) | 1.9 GB | public | https://pizzachili.dcc.uchile.cl/texts/ | P01, P02, P04 (CoCo-Trie) |
| **it-2004.urls** | 247 MB | LAW akademisch (Sign-Up) | https://law.di.unimi.it/webdata/it-2004/ | P04, P07 |
| **english-words/words.txt** | 4 MB | MIT | https://github.com/dwyl/english-words/raw/master/words.txt | Wormhole concbench |
| **CoCo-Trie preprocessed** | n/a | n/a | https://drive.google.com/drive/folders/1x2tCAMyltD-bu1pYc7A9_4DcZJOqElna | P04 (Direct) |
| **YCSB** | 0 (Code-Generator) | n/a | bereits in workload_generator | A-F |

**Empfehlung:** `tools/fetch_testdata.sh` (+ `.bat`) das **on-demand** die Pflicht-Korpus laedt (~30 GB), nicht ins Repo committen, sondern in `tests/fixtures/external/` (gitignored).

---

## §4 prt-art-Subsumption Status (Memory-Direktive Pruefung)

`comdare-cache-engine/prt_art/` enthaelt:
- `include/` (23 Header) — **echter Code**, vermutlich mit `prt_art_search_engine.hpp` etc.
- `allocator/`, `concurrency/`, `legacy_reimpl/`, `memory_layout/`, `nodes/`, `pages/`, `prefetch/`, `traversal/`, `value_handles/` (je 2 Stub-Dateien)

**Vergleich mit `comdare-prt-art`-Repo:** Echtes Repo hat das alles bereits, plus Adapter, Hypothesen-Metriken, etc. — die cache-engine-Variante ist die ALTE Vor-Migrations-Variante.

**Was hier wirklich noch gebraucht wird:**
- `prt_art_config.cmake` (falls vorhanden) — Bridge-Datei fuer cache-engine-Code, der prt_art-API ueber das Algorithm-Baustein-Variant referenziert
- ALLES ANDERE: kann nach `comdare-prt-art`-Repo verschoben (resp. dort ist es schon) und in cache-engine geloescht werden

---

## §5 Drei kritische Entscheidungen vor dem Refactoring

Bevor ich schreibe/loesche/umbenenne, brauche ich User-Approval zu drei
strategischen Fragen — Risiko ist hoch (3 Repos, Submodules, CI):

1. **Layout-Aggressivitaet** — wie tief refactorieren?
2. **prt_art/-Behandlung** — komplett raus oder Stubs erhalten?
3. **Datenquellen-Strategie** — alle laden, manuell, oder lazy-on-demand?

→ siehe AskUserQuestion im naechsten Schritt

---

## §6 Tasks V23.0 - V23.5

| # | Task | Risiko |
|---|---|---|
| V23.0 | V23-Anker | done |
| V23.PLAN | User-Approval einholen | (this) |
| V23.1 | cache-engine Refactoring | **HOCH** (CMake, Submodule, CI) |
| V23.2 | Diplomarbeit test_data_xml/-Verzeichnis | niedrig |
| V23.3 | CoCo-Trie + SOSD Download-Script | niedrig |
| V23.4 | Build+Tests in 3 Repos verifizieren | (CI) |
| V23.5 | V23 Final commits + Doku | (letzter) |
