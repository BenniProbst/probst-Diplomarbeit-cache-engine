# P01-ART — Status

**Paper:** Adaptive Radix Tree (Leis 2013) + OLC-Variante
**Status:** CLONED
**Verzeichnis:** `Forschungsarbeiten/code/P01-ART/`

## Klon-/Implementierungs-Hinweis

- **Repository:** https://github.com/laurynas-biveinis/unodb
- **Klon-Verzeichnis:** `unodb/`
- **Original-Compiler:** C++17+
- **Klon-Datum:** 2026-05-04
- **Klon-Befehl:** `git clone --depth 1 https://github.com/laurynas-biveinis/unodb`

### Habich-Direktive (F-EXTRA-1)
Originalcode wird EXAKT KOPIERT uebernommen. Anbindung ueber Adapter-Pattern in
`comdare-cache-engine/adapters/P01-ART/`. Compiler-Layering: Originalcode-Bausteine
mit `C++17+` kompiliert, statisch in C++23-Modul-Wrapper gelinkt.

### Naechste Schritte (Phase 4.B)
1. Lizenz pruefen (`unodb/LICENSE` oder vergleichbar)
2. Code-Struktur-Analyse: Welche Source-Files sind die Bausteine?
3. Adapter-Skelett in `comdare-cache-engine/adapters/P01-ART/`
4. Compiler-Provisioning verifizieren (`C++17+` verfuegbar?)

