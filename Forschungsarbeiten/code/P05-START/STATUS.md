# P05-START — Status

**Paper:** Self-Tuning ART (Fent 2020)
**Status:** CLONED
**Verzeichnis:** `Forschungsarbeiten/code/P05-START/`

## Klon-/Implementierungs-Hinweis

- **Repository:** https://github.com/jungmair/START
- **Klon-Verzeichnis:** `START/`
- **Original-Compiler:** GCC 7+
- **Klon-Datum:** 2026-05-04
- **Klon-Befehl:** `git clone --depth 1 https://github.com/jungmair/START`

### Habich-Direktive (F-EXTRA-1)
Originalcode wird EXAKT KOPIERT uebernommen. Anbindung ueber Adapter-Pattern in
`comdare-cache-engine/adapters/P05-START/`. Compiler-Layering: Originalcode-Bausteine
mit `GCC 7+` kompiliert, statisch in C++23-Modul-Wrapper gelinkt.

### Naechste Schritte (Phase 4.B)
1. Lizenz pruefen (`START/LICENSE` oder vergleichbar)
2. Code-Struktur-Analyse: Welche Source-Files sind die Bausteine?
3. Adapter-Skelett in `comdare-cache-engine/adapters/P05-START/`
4. Compiler-Provisioning verifizieren (`GCC 7+` verfuegbar?)

