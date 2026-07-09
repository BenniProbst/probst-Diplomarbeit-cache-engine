# DOSSIER AP-4 / #238 — Messreihe B (Stufe-3-Full-Join) echt per-Host statt Masstree-Einzelkopie (ABI-NEUTRAL)

> **Für Codex** (`--sandbox workspace-write`, `model_reasoning_effort=xhigh`).
> Arbeite **DIREKT als EIN Agent** — KEINE Sub-Agenten/Orchestrator/collab. Setze §6 vollständig um,
> halte §4 strikt ein, verifiziere §7 lokal (Kommandos + **literale** Ergebnisse). **NICHT committen,
> KEINE git-Operationen, KEIN `git add`** — nur Dateien editieren; Claude reviewt + committet selbst.
> Wenn eine Auflage nicht erfüllbar ist: NICHTS raten — STOPP + Rückmeldung in §8.

## 1. Auftrag (eine Zeile)
Reihe B (Messreihe, Stufe3_FullJoin) liefert aktuell für ALLE 7 Lebewesen dieselbe hartkodierte
`MasstreePrtStufe3FullJoinComposition` (Kollaps auf 1 Modul). Baue B als **per-Host-Full-Join**: je
SOTA-Host eine distinkte `<Host>PrtStufe3FullJoinComposition` mit eigener binary_id.

## 2. Fachliche Substanz (WARUM)
FF3 (PRT-ART vs. SOTA) verlangt, dass Messreihe B **jeden SOTA-Host mit dem PRT-ART-path_compression-Organ
gejoint** misst — nicht einen einzigen Masstree-Repräsentanten für alle. Heute geben `sota_module_for`
(`sota_catalog.hpp:160-165`) alle B-Zeilen dieselbe `MasstreePrtStufe3FullJoinComposition` zurück; zusätzlich
faltet `build_sota_source_map`s `emplace` (first-wins) die identischen binary_ids still zusammen → B = 1 Modul.
SOLL: 6 reale distinkte B-Module (die 6 SOTA-Hosts × PRT-Organ), analog wie Reihe A per-Lebewesen aufgebaut ist.

## 3. Scope-Abgrenzung (HART)
- **IN (AP-4):** (a) 5 NEUE per-Host-Stufe3-Kompositionen (Art/Hot/Surf/Start/Wormhole) neben der bestehenden
  Masstree via generischem `HostPrtMergeComposition<Host, Stufe3PathCompressionOrgan>`; (b) `sota_module_for`
  Stufe3-Zweig auf per-`lebewesen`-Lookup umstellen; (c) stale „Reihe B/C"-Kommentare korrigieren (#178:
  Stufe2→A, Stufe3→B); (d) Distinktheits-Test erweitern. Header-only, host-seitig, compile-time.
- **OUT (im Code als `// AP-4-Follow:` markieren, NICHT umsetzen):** der per-Host-VOLL-MESSLAUF (DLLs bauen +
  messen) = #162-HELD; Materialisierung BEIDER Union-Punkte (`mp_back` bleibt der 1-Punkt-Repräsentant);
  Stufe2-Reihe-A-Parallelfall (`HotPrtStufe2ReplaceComposition` ist auch host-hartkodiert — separater Task,
  NUR flaggen); Reihe C.

## 4. HARTE Auflagen (Verstoß = Abbruch; Claude verwirft)
1. **prt_art-als-Stufe3-Host = ehrlich `nullopt`.** Der FullJoin(Host-Default-PC ∪ PRT-PC) ist für den
   Prüfling-als-Host degeneriert (prt_art ist bereits in Reihe A/Stufe1 isoliert gemessen). `sota_module_for("Stufe3_FullJoin", "prt_art")` → `std::nullopt` (bestehendes Muster für nicht-baubare Paare,
   `sota_catalog.hpp:139-141` „ehrlich → leere Quelle"). **NIEMALS** prt_art-Stufe3 auf PrtArtComposition
   mappen (das dupliziert Reihe A unter B-Label = unehrlich). Ergebnis: **6 reale B-Module**, nicht 7.
2. **KEINE Fake-Distinktheit:** distinkte binary_ids MÜSSEN auf distinkte reale Kompositionen zeigen (je Host
   eigene `HostPrtMergeComposition<XComposition, …>`), NICHT 6× dieselbe mit umbenanntem Label.
3. **ABI-NEUTRAL:** `COMDARE_ANATOMY_ABI_MAJOR` bleibt **4** (`include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp:43` NICHT anfassen). Keine POD-/extern-C-/Codegen-Struct-Änderung. Reine host-seitige, header-only
   Kompositions-/Katalog-Typen; `render_sota_module_source` bleibt unverändert.
4. **NICHT-INVASIV:** Reihe A (Stufe1) + der Stufe2-Zweig bleiben **exakt unverändert** (nur additiv Stufe3).
   Die bestehende `MasstreePrtStufe3FullJoinComposition` bleibt erhalten (masstree-Host-Variante der 6).
5. **Compile-Ehrlichkeit:** falls ein Host+PRT-Join NICHT kompiliert (z.B. Achsen-Inkompatibilität), diesen
   Host ehrlich auf `nullopt` + `// AP-4-Follow:`-Kommentar setzen (NICHT erzwingen/casten) und in §8 melden.
   Mindestens die bereits bewährte Masstree + ≥1 weiterer Host MÜSSEN real kompilieren (Beleg gegen Kollaps).
6. **TABU:** `tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt` (nicht anfassen — B liegt im
   disjunkten `sota_tier=`-Namensraum, darf die `search_algo=`-golden-320 nicht driften); `known_compositions_list.hpp` (nur LESEN/iterieren, `static_assert(...==11)`-Count NICHT ändern); `modules/**`, `ext/**`,
   Registry-mp_list, alle Mess-PODs/ABI-Header. Kein `git`.
7. **Stil:** `comdare::cache_engine::compositions::*`, C++23; `COMDARE_DEFINE_COMPOSITION_LOCATION` je neue
   Komposition (wie die bestehenden); umgebenden Code exakt spiegeln.

## 5. Kartierung (file:line — von Claude verifiziert)
- **5.1 Profil (Wahrheit der 7×3):** `libs/cache_engine/algorithm_profiles/thesis_profiles/m3v2_study.profile.xml:100-120` — 21 `<sota_series>`; Stufe3/id=B (`:114-120`) = 7 Lebewesen **prt_art, art, hot, masstree, surf, start, wormhole**.
- **5.2 Stufe→Reihe (#178, Single-Source):** `sota_catalog.hpp:74-79` `stufe_to_reihe` (Stufe1→A, Stufe2→A, Stufe3→B). `MergeStrategy`-Enum: `libs/cache_engine/anatomy/pruefling_merge.hpp:130-134` (als String durchs Profil).
- **5.3 DEFEKT (die Kernstelle):** `sota_catalog.hpp:160-165` — Stufe3-Zweig gibt für JEDES `lebewesen` dieselbe
  `MasstreePrtStufe3FullJoinComposition` zurück (nur `lebewesen+"+prt(St3)"`-Textfeld variiert; binary_id/composition identisch). Kollaps-Folgestellen: `build_sota_source_map` `sota_catalog.hpp:172-179` (`by_id.emplace`, first-wins).
- **5.4 A-Vorlage (das zu spiegelnde Muster):** `sota_catalog.hpp:111-132` `build_sota_series_a_modules` — iteriert
  `cmp::KnownReferenceCompositions` (`mp_for_each`, `:129`); die 6 SOTA-`short_name` sind exakt
  `art/hot/wormhole/surf/masstree/start` (`:123`); prt_art separat (`:114`).
- **5.5 Generischer Baustein (EXISTIERT):** `libs/cache_engine/compositions/prt_art_merge_reference.hpp:76-101`
  `template <class Host, class MergedPathCompression> struct HostPrtMergeComposition` — forwardet alle 18 Host-
  Achsen, ersetzt nur `path_compression = MergedPathCompression`. `Stufe3PathCompressionOrgan` (global, `:68` =
  `mp_back<Stufe3MergedPC>` = PrtArtPathCompressionOrgan) ist HOST-UNABHÄNGIG.
- **5.6 Bestehende Instanziierungen:** `prt_art_merge_reference.hpp:104-108` `HotPrtStufe2ReplaceComposition`
  (Stufe2); `:110-114` `MasstreePrtStufe3FullJoinComposition` (Stufe3, die einzige). Includes `:18-21` = prt_art/art/hot/masstree — **surf/start/wormhole FEHLEN**.
- **5.7 STALE Kommentare (mitkorrigieren):** `prt_art_merge_reference.hpp:5-10` (Reihe B=Stufe2 / Reihe C=Stufe3 —
  OLD; #178: Stufe2→A, Stufe3→B), `:103` („Reihe B (Stufe2…)" → „Reihe A"), `:110` („Reihe C (Stufe3…)" → „Reihe B").
- **5.8 Genus-Guard:** `prt_art_merge_reference.hpp:118-128` (`assert_pruefling_slot_genus` deckt den PRT-Slot ab —
  die neuen Kompositionen nutzen denselben `Stufe3PathCompressionOrgan`, also gedeckt).
- **5.9 Test-Vorlage:** `tests/unit/thesis_tiere/test_sota_series_pilot.cpp:129-133` (Stufe→Reihe-Tabelle),
  `:146-152` (`sota_module_for`), `:165-173` (Distinktheits-Gate, aktuell 3 Stufen-IDs). Build (NICHT ctest):
  `tests/unit/thesis_tiere/build_sota_pilot.ps1` (Begründung `README.md:44-49`).

## 6. Soll-Umsetzung (konkret)

### 6.1 `prt_art_merge_reference.hpp` — 5 neue per-Host-Stufe3-Kompositionen
- Includes ergänzen (`:18-21`-Block): `surf_reference.hpp`, `start_reference.hpp`, `wormhole_reference.hpp`
  (Header-Namen selbst verifizieren — analog `masstree_reference.hpp`; falls ein Name abweicht: den realen nehmen).
- Nach `MasstreePrtStufe3FullJoinComposition` (`:115`) die 5 Geschwister ergänzen (Muster identisch):
```cpp
/// Reihe B (Stufe3_FullJoin): ART-Host, path_compression = Pruefling-Repraesentant der Union (non-redundant).
struct ArtPrtStufe3FullJoinComposition : HostPrtMergeComposition<ArtComposition, Stufe3PathCompressionOrgan> {
    static constexpr std::string_view name = "ArtPrtStufe3FullJoinComposition";
    COMDARE_DEFINE_COMPOSITION_LOCATION("::comdare::cache_engine::compositions::ArtPrtStufe3FullJoinComposition",
                                        "compositions/prt_art_merge_reference.hpp");
};
// … analog: HotPrtStufe3FullJoinComposition<HotComposition>, SurfPrtStufe3FullJoinComposition<SurfComposition>,
//           StartPrtStufe3FullJoinComposition<StartComposition>, WormholePrtStufe3FullJoinComposition<WormholeComposition>
```
- Optional Hygiene: je neue Komposition `static_assert(IsComposition<…>)` (das im Repo verwendete Concept — prüfe
  `composition_concept.hpp`), analog falls die bestehenden es tun; sonst weglassen.
- Stale Kommentare korrigieren (§5.7): `:5-10` Reihen-Legende auf #178 (Stufe1+2→A, Stufe3→B; Reihe C build-
  übergreifend), `:103` „Reihe B (Stufe2…)"→„Reihe A (Stufe2…)", `:110`+neue „Reihe B (Stufe3…)".

### 6.2 `sota_catalog.hpp` — Stufe3-Zweig per-Host (`:160-165` ersetzen)
```cpp
    if (merge == "Stufe3_FullJoin") {
        // AP-4/#238: per-Host-FullJoin (analog build_sota_series_a_modules) — je SOTA-Host eine distinkte
        // <Host>PrtStufe3FullJoinComposition. prt_art-als-Host ist degeneriert (prt_art ist in Reihe A/Stufe1
        // bereits isoliert) → nullopt (ehrlich, keine Reihe-A-Duplikation unter B-Label).
        struct B { std::string_view type; std::string_view name; };
        auto pick = [&](std::string const& l) -> std::optional<B> {
            if (l == "art")      return B{"::comdare::cache_engine::compositions::ArtPrtStufe3FullJoinComposition",      cmp::ArtPrtStufe3FullJoinComposition::name};
            if (l == "hot")      return B{"::comdare::cache_engine::compositions::HotPrtStufe3FullJoinComposition",      cmp::HotPrtStufe3FullJoinComposition::name};
            if (l == "masstree") return B{"::comdare::cache_engine::compositions::MasstreePrtStufe3FullJoinComposition", cmp::MasstreePrtStufe3FullJoinComposition::name};
            if (l == "surf")     return B{"::comdare::cache_engine::compositions::SurfPrtStufe3FullJoinComposition",     cmp::SurfPrtStufe3FullJoinComposition::name};
            if (l == "start")    return B{"::comdare::cache_engine::compositions::StartPrtStufe3FullJoinComposition",    cmp::StartPrtStufe3FullJoinComposition::name};
            if (l == "wormhole") return B{"::comdare::cache_engine::compositions::WormholePrtStufe3FullJoinComposition", cmp::WormholePrtStufe3FullJoinComposition::name};
            return std::nullopt; // prt_art (degeneriert) + unbekannte
        };
        if (auto b = pick(lebewesen))
            return SotaModule{lebewesen + "+prt(St3)", sota_binary_id(reihe, std::string{b->name}),
                              std::string{b->type}, "compositions/prt_art_merge_reference.hpp"};
        return std::nullopt;
    }
```
(Falls ein Host in 6.1 nicht kompiliert → dessen `pick`-Zeile auf `nullopt` + `// AP-4-Follow:`.)

### 6.3 `test_sota_series_pilot.cpp` — Distinktheit auf 6 B-Hosts
- Erweitere das Gate (`:165-173`): sammle für alle Stufe3-Lebewesen der 6 SOTA-Hosts die `sota_module_for(...)->binary_id`
  → **6 Einträge, paarweise DISTINKT** (heute: alle identisch → belegt den Defekt) und jede ≠ dem A-Modul-binary_id
  desselben Hosts. Assert `sota_module_for("Stufe3_FullJoin","prt_art") == nullopt`. Optional: `composition_type`
  je Host ≠ Masstree für die 5 Nicht-Masstree-Hosts (Beleg per-Host statt kollabiert).

## 7. Verifikation (PFLICHT — Codex, Kommandos + literale Ergebnisse)
- Baue+laufe den Pilot: `pwsh -File tests/unit/thesis_tiere/build_sota_pilot.ps1` (oder das reale Build-Skript
  laut `README.md:44-49`) → Exit-Status literal; `test_sota_series_pilot` **[ PASSED ]** literal.
- Falls das .ps1 einen anderen Namen/Parameter hat: den realen zeigen + nutzen. Falls der Voll-Build zu schwer/
  gelockt ist (OneDrive): den EINEN Test-TU + seine Header isoliert per `cl`/`cmake`-Target kompilieren, sodass
  die 6 Kompositionen + der Distinktheits-Test real durchlaufen; das Kommando + Ergebnis literal zeigen.
- Belege: (a) 6 distinkte B-binary_ids literal ausgegeben; (b) prt_art-Stufe3 == nullopt; (c) welche Hosts
  real kompilieren (falls einer nicht → gemeldet). **KEIN Commit.**

## 8. Ausgabe an Claude (strukturiert)
(a) geänderte+neue Symbole (Liste, je Host was); (b) Bestätigung: 6 distinkte reale Kompositionen (kein Fake-
Label), prt_art→nullopt; (c) ABI-Neutralität (MAJOR 4, kein POD/extern-C/golden-320); (d) Nicht-Invasivität
(Reihe A + Stufe2 unverändert); (e) Build-/Test-Ergebnisse **literal** (Exit + `[ PASSED ]` + die 6 IDs); (f)
welche Hosts kompilieren / etwaige nullopt-Follow-ups; (g) korrigierte stale Kommentare (Liste).
