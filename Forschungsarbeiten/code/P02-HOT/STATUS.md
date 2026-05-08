# P02-HOT — Status

**Paper:** Height Optimized Trie (Binna 2018)
**Status:** CLONED
**Verzeichnis:** `Forschungsarbeiten/code/P02-HOT/`

## Klon-/Implementierungs-Hinweis

- **Repository:** https://github.com/speedskater/hot
- **Klon-Verzeichnis:** `hot/`
- **Original-Compiler:** GCC 5+ (BMI2/AVX2)
- **Klon-Datum:** 2026-05-04
- **Klon-Befehl:** `git clone --depth 1 https://github.com/speedskater/hot`

### Habich-Direktive (F-EXTRA-1)
Originalcode wird EXAKT KOPIERT uebernommen. Anbindung ueber Adapter-Pattern in
`comdare-cache-engine/adapters/P02-HOT/`. Compiler-Layering: Originalcode-Bausteine
mit `GCC 5+ (BMI2/AVX2)` kompiliert, statisch in C++23-Modul-Wrapper gelinkt.

### Naechste Schritte (Phase 4.B)
1. Lizenz pruefen (`hot/LICENSE` oder vergleichbar)
2. Code-Struktur-Analyse: Welche Source-Files sind die Bausteine?
3. Adapter-Skelett in `comdare-cache-engine/adapters/P02-HOT/`
4. Compiler-Provisioning verifizieren (`GCC 5+ (BMI2/AVX2)` verfuegbar?)

