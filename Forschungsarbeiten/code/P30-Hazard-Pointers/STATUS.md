# P30-Hazard-Pointers — Status

**Paper:** Lightweight Hazard Pointers (Folly als Referenz)
**Status:** CLONED
**Verzeichnis:** `Forschungsarbeiten/code/P30-Hazard-Pointers/`

## Klon-/Implementierungs-Hinweis

- **Repository:** https://github.com/huangjiahua/haz_ptr
- **Klon-Verzeichnis:** `haz_ptr/`
- **Original-Compiler:** C++17+
- **Klon-Datum:** 2026-05-04
- **Klon-Befehl:** `git clone --depth 1 https://github.com/huangjiahua/haz_ptr`

### Habich-Direktive (F-EXTRA-1)
Originalcode wird EXAKT KOPIERT uebernommen. Anbindung ueber Adapter-Pattern in
`comdare-cache-engine/adapters/P30-Hazard-Pointers/`. Compiler-Layering: Originalcode-Bausteine
mit `C++17+` kompiliert, statisch in C++23-Modul-Wrapper gelinkt.

### Naechste Schritte (Phase 4.B)
1. Lizenz pruefen (`haz_ptr/LICENSE` oder vergleichbar)
2. Code-Struktur-Analyse: Welche Source-Files sind die Bausteine?
3. Adapter-Skelett in `comdare-cache-engine/adapters/P30-Hazard-Pointers/`
4. Compiler-Provisioning verifizieren (`C++17+` verfuegbar?)

