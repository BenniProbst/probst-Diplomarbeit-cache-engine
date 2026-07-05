---
name: KEINE Quick-Fixes — IMMER den saubersten Weg waehlen
description: In der professionellen Umgebung sind Quick-Fixes IMMER der falsche Weg. Bei Versuchung zu Workarounds RUECKFRAGEN stellen statt umsetzen.
type: feedback
---

Quick-Fixes sind IMMER der falsche Weg. Wir arbeiten in einer professionellen Umgebung.

**Why:** Quick-Fixes erzeugen technische Schulden die spaeter teurer zu beheben sind als
die initiale saubere Loesung. Beispiele aus S2683:
- staged-build.py (cmake direkt) statt echtes BuildSystem → kompletter Ansatz war falsch
- .gitmodules statt BuildSystem DependencyManager → musste revertiert werden
- Workaround-Scripts statt Feature-Implementierung → verzoegert echte Loesung

**How to apply:**
- Wenn ein Quick-Fix sinnvoll erscheint → RUECKFRAGE an User stellen
- IMMER den sauberen, architektonisch korrekten Weg waehlen
- Lieber eine Aufgabe als BLOCKED markieren als einen Workaround zu bauen
- Wenn ein Feature fehlt → das Feature implementieren, nicht drumherum arbeiten
- Bei Unsicherheit: mehr RBMM/Docs lesen, nicht raten
