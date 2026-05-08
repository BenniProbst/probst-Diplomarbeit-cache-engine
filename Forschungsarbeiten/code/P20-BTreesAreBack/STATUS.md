# P20-BTreesAreBack — Status

**Paper:** Adaptive B-Tree (Mueller 2025)
**Status:** CLONED
**Verzeichnis:** `Forschungsarbeiten/code/P20-BTreesAreBack/`

## Klon-/Implementierungs-Hinweis

- **Repository:** https://github.com/leanstore/leanstore
- **Klon-Verzeichnis:** `leanstore/`
- **Original-Compiler:** GCC 13+
- **Klon-Datum:** 2026-05-04
- **Klon-Befehl:** `git clone --depth 1 https://github.com/leanstore/leanstore`

### Habich-Direktive (F-EXTRA-1)
Originalcode wird EXAKT KOPIERT uebernommen. Anbindung ueber Adapter-Pattern in
`comdare-cache-engine/adapters/P20-BTreesAreBack/`. Compiler-Layering: Originalcode-Bausteine
mit `GCC 13+` kompiliert, statisch in C++23-Modul-Wrapper gelinkt.

### Naechste Schritte (Phase 4.B)
1. Lizenz pruefen (`leanstore/LICENSE` oder vergleichbar)
2. Code-Struktur-Analyse: Welche Source-Files sind die Bausteine?
3. Adapter-Skelett in `comdare-cache-engine/adapters/P20-BTreesAreBack/`
4. Compiler-Provisioning verifizieren (`GCC 13+` verfuegbar?)

