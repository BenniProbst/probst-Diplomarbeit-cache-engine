---
name: PRT_ART konsumiert CacheEngine, nicht umgekehrt
description: Architektur-Inversion. PRT_ART ist Pruefling (eigenes Repo), CacheEngine ist Werkzeug (Sub-Repo via Pfad-Referenz). Drei Git-Repos pflichtmaessig commit+push.
type: feedback
originSessionId: 3d9bd0e7-eeb3-411a-b116-64eef696e0f6
---
PRT_ART ist der Pruefling, CacheEngine ist das Werkzeug — niemals umgekehrt.

**Why:** User-Hinweis 2026-05-12: "Warum ist jetzt der PRT_ART in der Cache Engine, das ist doch falsch rum." Der PRT_ART ist ein experimentelles neues Konzept, das gegen den Stand der Technik (= Cache Engine) untersucht werden soll. Validierte Methoden des PRT_ART werden spaeter in die CacheEngine gemerged. Final ist PRT_ART nur eine Permutations-Konfiguration aus dem CacheEngine-Stand-der-Technik, kompiliert vom CacheEngineBuilder als Binary.

**How to apply:**
- Repo-Struktur: `Projekte/Research/comdare-prt-art/` (eigenes Repo) + `Projekte/Research/comdare-cache-engine/` (eigenes Repo). PRT_ART **konsumiert** CacheEngine via Pfad-Referenz (`../comdare-cache-engine/`), NICHT andersrum.
- KEINE Inhalte in `comdare-cache-engine/prt_art/` neu anlegen. PRT_ART-Spezifika kommen ausschliesslich nach `comdare-prt-art/`.
- Namespace-Struktur in PRT_ART spiegelt die der CacheEngine (parallele page_structures/, interpreters/, sub-engines/, etc.) — Vorbereitung fuer kuenftigen Merge.
- Drei Git-Repos pflicht-regelmaessig: Diplomarbeit, comdare-cache-engine, comdare-prt-art (commit+push).
- **AUSNAHME zu CLAUDE.md S2683 (User-Direktive 2026-05-12 Abend):** CacheEngine wird als `git submodule` in PRT_ART eingerichtet (analog S2686b "BuildSystem Core in Consumer-Projekten"). Pfad: `external/comdare-cache-engine`. Drei Repos pflicht-regelmaessig commit+push: Diplomarbeit, comdare-cache-engine (FIRST committen, damit Submodule-Pin sauber), comdare-prt-art (LAST).
- GitHub-Remotes: comdare-cache-engine = github.com/BenniProbst/comdare-cache-engine (existiert), comdare-prt-art = github.com/BenniProbst/comdare-prt-art (User legt an).
