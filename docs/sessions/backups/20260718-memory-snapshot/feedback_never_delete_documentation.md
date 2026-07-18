---
name: feedback-never-delete-documentation
description: "User-Direktive Diplomarbeit 2026-05-14 — niemals Dokumentation loeschen, immer nur ergaenzen oder als deprecated markieren"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 3d9bd0e7-eeb3-411a-b116-64eef696e0f6
---

Niemals Dokumentation loeschen — auch nicht alte/veraltete Sessions, READMEs, oder PROJECT_LAYER_MAPs.

**Why:** Der Doku-Verlauf ist Teil der Diplomarbeit-Geschichte und Habich-Pruefungs-Material. Frueh-Phasen-Doku (z.B. Pre-Migration-Stand, REV3-Skizzen, Vor-V8-Entscheidungen) zeigt die Lern-/Recherche-Reihenfolge und ist fuer Defense + Habich-Termine wichtig. Auch obsolete Doku ist Beleg.

**How to apply:**
- Verzeichnis-Refactoring: `docs/` ALLER drei Repos NIE umbenennen oder Inhalt loeschen
- Session-Dateien: NIE alte `docs/sessions/*.md` loeschen, auch nicht nach Phasen-Abschluss
- README-Dateien: alte READMEs koennen als `README-V8.md` etc. umbenannt werden, aber nicht geloescht
- Wenn etwas "veraltet" wirkt: als `deprecated/` Marker setzen oder neue Doku ergaenzen, alte stehen lassen
- Bei Doku-Migrationen: nur git mv, nie rm

Verwandte Direktiven:
- [[feedback-session-at-95-percent-context]] (elaborate Session schreiben)
- [[feedback-phase-completeness-discipline]] (jede Phase vollstaendig dokumentiert)
