# P25-Mahling-FillBuffer — Status

**Paper:** Prefetch Microbenchmarks (Mahling 2025)
**Status:** CLONED
**Verzeichnis:** `Forschungsarbeiten/code/P25-Mahling-FillBuffer/`

## Klon-/Implementierungs-Hinweis

- **Repository:** https://github.com/hpides/prefetching
- **Klon-Verzeichnis:** `prefetching/`
- **Original-Compiler:** GCC 11+
- **Klon-Datum:** 2026-05-04
- **Klon-Befehl:** `git clone --depth 1 https://github.com/hpides/prefetching`

### Habich-Direktive (F-EXTRA-1)
Originalcode wird EXAKT KOPIERT uebernommen. Anbindung ueber Adapter-Pattern in
`comdare-cache-engine/adapters/P25-Mahling-FillBuffer/`. Compiler-Layering: Originalcode-Bausteine
mit `GCC 11+` kompiliert, statisch in C++23-Modul-Wrapper gelinkt.

### Naechste Schritte (Phase 4.B)
1. Lizenz pruefen (`prefetching/LICENSE` oder vergleichbar)
2. Code-Struktur-Analyse: Welche Source-Files sind die Bausteine?
3. Adapter-Skelett in `comdare-cache-engine/adapters/P25-Mahling-FillBuffer/`
4. Compiler-Provisioning verifizieren (`GCC 11+` verfuegbar?)

