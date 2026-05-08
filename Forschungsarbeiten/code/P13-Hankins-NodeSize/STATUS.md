# P13-Hankins-NodeSize — Status

**Paper:** Pre-Github (2003); Re-Implementation noetig
**Status:** LEGACY_REIMPL
**Verzeichnis:** `Forschungsarbeiten/code/P13-Hankins-NodeSize/`

## Klon-/Implementierungs-Hinweis

- **Status:** Kein oeffentliches Repository verfuegbar
- **Original-Compiler:** GCC 3.x
- **Strategie:** Re-Implementation in PRT-ART (NICHT als Originalcode markiert)

### Re-Implementation-Plan (Phase 4.B / Phase 5)
1. Original-Paper-Pseudocode in `prt_art/legacy_reimpl/P13-Hankins-NodeSize/` extrahieren
2. C++23-Implementation des Algorithmus
3. Code-Review mit Habich vor Integration
4. Adapter zu Bausteine-Concept-Interface

### Wichtig (Habich-Direktive)
Diese Re-Implementation ist KEIN "Originalcode" im Sinne der Habich-Direktive.
Sie ist eine **PRT-ART-eigene Implementation** des im Paper beschriebenen
Algorithmus. Im Bausteine-Module-Identifier wird sie als
`legacy_reimpl_p13-hankins-nodesize` markiert (statt `ext_p13-hankins-nodesize`).

