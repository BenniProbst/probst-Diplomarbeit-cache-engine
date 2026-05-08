# P29-RCU-McKenney — Status

**Paper:** liburcu RCU-Implementation (McKenney 2001)
**Status:** CLONED
**Verzeichnis:** `Forschungsarbeiten/code/P29-RCU-McKenney/`

## Klon-/Implementierungs-Hinweis

- **Repository:** https://github.com/urcu/userspace-rcu
- **Klon-Verzeichnis:** `userspace-rcu/`
- **Original-Compiler:** GCC 4+
- **Klon-Datum:** 2026-05-04
- **Klon-Befehl:** `git clone --depth 1 https://github.com/urcu/userspace-rcu`

### Habich-Direktive (F-EXTRA-1)
Originalcode wird EXAKT KOPIERT uebernommen. Anbindung ueber Adapter-Pattern in
`comdare-cache-engine/adapters/P29-RCU-McKenney/`. Compiler-Layering: Originalcode-Bausteine
mit `GCC 4+` kompiliert, statisch in C++23-Modul-Wrapper gelinkt.

### Naechste Schritte (Phase 4.B)
1. Lizenz pruefen (`userspace-rcu/LICENSE` oder vergleichbar)
2. Code-Struktur-Analyse: Welche Source-Files sind die Bausteine?
3. Adapter-Skelett in `comdare-cache-engine/adapters/P29-RCU-McKenney/`
4. Compiler-Provisioning verifizieren (`GCC 4+` verfuegbar?)

