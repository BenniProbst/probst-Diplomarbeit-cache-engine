export const meta = {
  name: 'docdrift-discover',
  description: 'Read-only Erhebung der 114 Doku-Drift-Findings (#9) in 3 Cluster mit datei:zeile + autoritativer Wahrheit — keine Edits',
  phases: [
    { title: 'Discover', detail: '3 Cluster parallel: Zähl-Drift / gelöschte-Behelfsweg-Verweise / PAPER_REFERENCES-Attribution' },
  ],
}

const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'

phase('Discover')
const clusters = [
  {
    key: 'zaehl-drift',
    prompt: `READ-ONLY (keine Edits). Erhebe ALLE konkreten Instanzen von Cluster-2 „Zähl-Drift" der Doku-Drift-Epidemie (Voll-Review Muster E). super=${SUPER}, ce=${CE}. Das sind Doku-/Kommentar-/README-Stellen, deren ZAHL dem Code-Ist widerspricht. Bekannte Beispiele aus dem Review (verifiziere + finde weitere): 15/17/21/22 Search-Algos · 8/9 Concurrency · 4/5 value_handle · 25/26 Allocatoren · 17/19 Anatomy-Slots · „3 Achsen" vs. 7 nodes-Achsen. VORGEHEN je Fund: (a) finde die AUTORITATIVE Ist-Zahl im Code (Registry-Konstante / mp_list-Länge / Enum-Count / static_assert / Verzeichnis-Zählung) mit datei:zeile; (b) finde JEDE Doku-Stelle die eine ANDERE Zahl behauptet, mit datei:zeile + zitiertem Text. Suche breit in: ce libs/*/PAPER_REFERENCES.md, ce+super docs/, READMEs, *.md, Header-Kommentaren, SCHEMA/LEITFADEN-Docs. Liefere eine TABELLE: | Doku-datei:zeile | behauptete Zahl | autoritative Ist-Zahl (code:zeile) | ist es ein compile-time-static_assert-Anker möglich? |. Markiere je Fund KONFIDENZ (objektiv-eindeutig / mehrdeutig-welche-Zahl-autoritativ). Wenn eine „Drift" in Wahrheit korrekt/aspirational ist (die Doku beschreibt bewusst einen SOLL-Zustand), markiere NICHT-DRIFT + Begründung. Ziel: eine abarbeitbare Korrektur-Liste, keine Prosa.`,
  },
  {
    key: 'geloeschte-behelfswege',
    prompt: `READ-ONLY (keine Edits). Erhebe ALLE konkreten Instanzen von Cluster-3 „Verweise auf gelöschte Behelfswege" der Doku-Drift-Epidemie. super=${SUPER}, ce=${CE}, thesis=${SUPER}/Code/... (thesis-Submodul falls vorhanden). Das sind Doku/README/Kommentar-Stellen, die auf DATEIEN verweisen, die es nach der Behelfsweg-Bereinigung (2026-07-11) nicht mehr gibt: run_lazy_150.cpp, *.ps1 (scratch_compile_*, generate_*_appendix.ps1, build_and_run.bat), test_validate_profile.cpp, tier150_axis_grid.cpp, measure_adapter_tiere.cpp, gen_golden_fullpilot.cpp u.a. VORGEHEN je Fund: (a) grep die Referenz in Doku/READMEs/Kommentaren (datei:zeile + zitierter Text); (b) VERIFIZIERE mit 'find'/'ls', dass die referenzierte Datei WIRKLICH nicht mehr existiert (sonst kein Drift). Bekannte Anker: ce tests/unit/thesis_tiere/README.md:3/5, thesis anhang/{de,en}/A_measurements.tex:4, super MANUAL_RUN/SCHEMA/ERWEITERUNGS-LEITFADEN, docs/architektur-Dossiers. Liefere TABELLE: | Doku-datei:zeile | referenzierte gelöschte Datei | existiert noch? (find-Beleg) | empfohlene additive Korrektur (DEPRECATED/SUPERSEDED-Vermerk ODER Verweis auf den Nachfolger, z.B. Code/08_appendix_generator statt *.ps1) |. WICHTIG: NIE Löschung vorschlagen — nur ergänzen/deprecaten (Doku-nie-löschen-Doktrin). Markiere je Fund Konfidenz.`,
  },
  {
    key: 'paper-references-attribution',
    prompt: `READ-ONLY (keine Edits). Erhebe ALLE konkreten Instanzen von Cluster-1 „PAPER_REFERENCES-Attribution-Drift". ce=${CE}. Das sind Attributions-Inkonsistenzen: der Wrapper/Registry wurde korrigiert, aber Shims/family_name-Strings/Profile/PAPER_REFERENCES.md nicht nachgezogen — Lizenzen, Autoren, Venues. Bekannte Beispiele (verifiziere + finde weitere): scalloc/michael/numalloc/starmalloc family_name-Strings · lrmalloc BSD-3 statt MIT · snmalloc-Autoren · Kuehn-DaMoN/Wormhole/Fent-Venue-Namen · M-CE-02 alloc/PAPER_REFERENCES.md:51 (25 vs 26 Zeilen, CrystallineAllocator/A17 fehlt). Suche in ce libs/cache_engine/axes/*/PAPER_REFERENCES.md + den family_name/license/author-Strings in den Adapter-Shims + Registry (axis_*_registry). VORGEHEN je Fund: (a) die falsche Attribution datei:zeile + zitierter Text; (b) die KORREKTE Attribution + Primärquellen-Beleg (Registry/Header/Vendor-LICENSE-Datei datei:zeile). ⚠️ Attribution ist HEIKEL (eine falsch gesetzte Lizenz ist schlimmer als Drift) — markiere je Fund STRENG: BELEGT-KORREKT (Primärquelle im Repo eindeutig) vs. UNSICHER (bräuchte externe Verifikation). Liefere TABELLE: | datei:zeile | falsch | korrekt | Primärquellen-Beleg | BELEGT/UNSICHER |. Rate NICHT bei Lizenzen — bei Unsicherheit UNSICHER.`,
  },
]

const found = await parallel(
  clusters.map((c) => () => agent(c.prompt, { label: `discover:${c.key}`, phase: 'Discover' }).then((t) => ({ cluster: c.key, report: t })))
)

return { found: found.filter(Boolean) }
