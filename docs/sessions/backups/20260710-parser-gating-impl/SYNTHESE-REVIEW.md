# SYNTHESE — Adversarialer Review „Parser-/Gating-Konsolidierung Phase 7" (wf_8508f98c-56e)

> NON_GATED-2 (BACKLOG, Anspruch dossier16-17-10). Erstimplementierung: **Claude selbst** (erste nach der
> Codex-Ablösung 10.07.). Rohdaten: `rohdaten-review/`. Dossier: `DOSSIER.md` (dieser Ordner).
> 13 Agenten (3 Finder × 2-Lens-Verify), 890k Tokens, 330 Tool-Calls.
> Verdikt: **10 Kandidaten, 10 CONFIRMED** — alle empirisch reproduziert, alle VOR Commit gefixt.

## Was gebaut wurde (IST nach Fixes)

1. **2→1 Reader:** parse_one/parse_profile/load_messreihen laufen über den KF-1-DOM (rekursive Helfer
   collect_named/find_first_named/parse_entries_dom); das Regex-Skelett parse_xml_string ist entfernt,
   `<regex>` aus Bibliothek UND Treiber verschwunden. Der Treiber-Duplikat-Reader (main.cpp:186-204) ist
   durch den Bibliotheks-Aufruf ersetzt (MessreihenSpec-Mapping via mode_to_string).
2. **stille-{}-Falle:** parse_one diagnostiziert jetzt (fehlende Datei = dokumentiert-optional mit
   R2-Hinweis; existierende-aber-leere Datei = stderr-WARNUNG); Rückgabewerte unverändert (R2-Gate).
   Treiber-Usage kennzeichnet das 4-Datei-Schema additiv als Legacy.
3. **COMDARE_EXPERIMENT_MODE real verdrahtet:** wert-basierter compile-time-Guard in abi_adapter.hpp
   (EXPERIMENT ⇒ MESSUNG, je Tier-Kompilat) + configure-time-FATAL_ERROR bei kontradiktorischem
   Configure + ehrlicher Options-Docstring + Fehlalarm-Warnblock im Treiber ersetzt.
4. **Regressions-Gate** test_parser_konsolidierung (Label parser;e4, ctest-registriert): art.profile.xml
   + masstree.key_types (dekodiert, eingefroren) + fremde-Wurzel-Sentinel + Overrides + messreihen +
   parse_one-Fälle.

## Review-Verdikt: 10 CONFIRMED → 10 Fixes (alle vor Commit)

| # | Sev | Fund (empirisch) | Fix |
|---|-----|------------------|-----|
| 1+8 | major | DOM dekodiert XML-Entities — masstree.key_types nicht byte-gleich zur Regex-Referenz (einzige Akte mit Entities; landet in generierten C++-KOMMENTAREN via codegen.cpp:133) | **Bewusste Korrektur statt Re-Encode:** Regex transportierte XML-Escapes roh in C++-Kommentare; dekodierter Wert ist der wahre Typ. Dokumentiert im Code + im Test EINGEFROREN (kein stiller Drift) |
| 2 | minor | Root-Fallback lieferte für 51 committete Nicht-Algorithm-Akten scheinbar gültige Profile (id-Sentinel gebrochen) | Fallback entfernt: fremde Wurzel ⇒ leeres Profil (id=="" bleibt Sentinel); Testfall ergänzt |
| 3 | minor | Bibliotheks-load_messreihen parst config_a/b/c jetzt als Obermenge (alte Bibliotheks-Regex: 0 Reihen) — aber diff-frei zur produktiven TREIBER-Regex auf allen 165 Akten | Dokumentierender Kommentar (Verhaltens-Referenz = Treiber-Regex, die einzig produktive) |
| 4 | major | Options-Docstring re-behauptete „Aktiviert ResultAggregator + Mess-Hooks" — Option ist verhaltens-inert (Hooks hängen an MEASUREMENT_MODE) | Ehrlicher Docstring: Option = Experiment-Marker + Invariante; aktiviert selbst nichts |
| 5 | major | Treiber-Warnblock = Fehlalarm in JEDEM super-Build (Host erhält das Define nie: directory-scoped/PRIVATE), Rat unbefolgbar, #else toter Code mit falscher Aussage | Block ersetzt durch ehrliche Statuszeile + Erklär-Kommentar (Mess-Hooks leben in Tier-DLL-Kompilaten; Guard erzwingt Invariante dort) |
| 6 | minor | Guard defined-basiert: MEASUREMENT_ON=0 passierte (stiller Nulllauf!), EXPERIMENT_MODE_ON=0 feuerte fälschlich | Wert-basiert (`#if A && !B`); 5-Fälle-Beweis literal: aus/FEUERT/FEUERT/aus/aus |
| 7 | minor | Kontradiktorischer Configure (EXPERIMENT=ON, MEASUREMENT=OFF) brach erst mid-build als #error-Sturm | configure-time `message(FATAL_ERROR)` nach dem Bestands-Muster RELEASE⇒!MEASUREMENT |
| 9 | minor | Regressions-Gate fror nur die entity-freie Akte ein — der einzig divergente Fall ungetestet | masstree.key_types (dekodiert) + Sentinel-Fall in den Test aufgenommen |
| 10 | minor | Stale Treiber-Kommentar referenzierte entferntes `<regex>` | Kommentar additiv präzisiert |

## End-Beweise (literal, offizieller g++-16-Baum)

- Guard-5-Fälle: `[KEINE]→kein #error · [EXP=1]→#error · [EXP=1,MEAS=0]→#error · [EXP=0]→kein · [EXP=1,MEAS=1]→kein`
- configure-time: `COMDARE_EXPERIMENT_MODE=ON erfordert COMDARE_MEASUREMENT_MODE=ON` (FATAL_ERROR)
- ce voller ctest: **„100% tests passed, 0 tests failed out of 198"** (inkl. test_parser_konsolidierung)
- super: `messung_driver` baut; Usage-Smoke zeigt Legacy-Kennzeichnung; `<regex>`-frei
- clang-format-22 == 0; Mojibake == 0; golden/m3v2/parse_thesis_profile-Pfad byte-unberührt.

## Einordnung

Der 10/10-CONFIRMED-Lauf bestätigt die Kadenz-These: Verhaltens-Konsolidierungen alter toleranter Parser
sind Drift-Minenfelder — die Finder fanden mit Dual-Binary-Diffs über alle 165 realen Akten exakt die eine
Entity-Akte und die 51 Sentinel-Fälle. Die masstree-Entscheidung (Korrektur statt Bug-Erhalt) ist bewusst,
dokumentiert und eingefroren; sie ändert generierte Artefakt-KOMMENTARE künftiger Läufe (kein ID-/
Fingerprint-Drift, keine Messdaten berührt).
