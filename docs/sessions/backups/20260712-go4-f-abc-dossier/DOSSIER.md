# DOSSIER — GO 4 / Task #8 „Phase 0.2-Rest": Entscheidung F-A / F-B / F-C

> **Datum:** 2026-07-12 · **Auftrag:** Ledger §11-I Punkt 3 (`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:272`):
> „GO 4 FREIGEGEBEN mit Rückfrage-Pflicht — #8 (F-A/F-B/F-C): Dossier erstellen + dem User eine KONKRETE
> Empfehlungs-Rückfrage stellen (‚was soll ich wählen'), DANN umsetzen."
> **Rein lesend erstellt, KEIN Commit.** Basis-Pfad `ce/` = `Code/external/comdare-cache-engine/`.
> Alle datei:zeile-Angaben am Ist-Stand 2026-07-12 verifiziert (grep/read, keine Übernahme ungeprüfter Notizen).

---

## §0 Herkunft der drei Forks (Quellenlage)

Task #8 = der design-gated **Rest von Phase 0.2** („general_hardware/Achse 12 verdrahten"). Die ursprüngliche
Audit-Rahmung („Organe lesen `cache_line_size` aus axis_12") wurde **widerlegt** — Re-Diagnose in
`docs/architektur/21_SESSION_PLAN_TYPSYSTEM_ACHSEN_ENTSCHEIDUNGEN.md:175-197` (§F.1) und im Deep-Research-Backup
`docs/sessions/backups/20260710-phase02-general-hardware-design/BEFUND.md` (Workflow wf_7bba0921, 2 Thesis-Reader +
Synthese + 2 adversariale Kritiker, beide NEEDS-REVISION inkl. golden-BLOCKER).

Die drei geparkten, GO-pflichtigen Design-Forks sind definiert in:
- Doc 21 `:230-233` (Kurzform) und
- BEFUND.md `:42-50` (Langform, wörtlich):
  - **F-A (Scope):** Phase 0.2 als „HW-Cache-Line fließt bereits via Build-Variant → nur Audit-/Doc-21-Fehldiagnose
    korrigieren" behandeln, ODER die neue NUMA/Page→allocator-Verdrahtung jetzt bauen (design-loaded)?
  - **F-B (Feld-Verdrahtung, falls neu gebaut wird):** welche Organe konsumieren welche axis_12-Felder
    (allocator numa/page sicher; node/layout page für dTLB-bewusste Knotengröße fraglich)? Compile-time-gated
    (`numa_capable=false` → NUMA-Pinning wegkompiliert) vs. reine Varianten-Auswahl?
  - **F-C (Mess-Achse, separat):** Werteset-Divergenz Thesis KF-5 `{32,64,128}` vs. Code `{B64,B128,B256}`;
    plus Line-**Größe** vs. Knoten-**Breite-in-Cache-Lines** (FF2: 1 vs. bis zu 16) = vermutlich zwei getrennte
    Unterachsen. Berührt den Thesis-Kern (die unangetastete Permutations-Achse) → separat vom Verdrahtungs-Scope.

**Wichtig fürs Verständnis der Rückfrage:** F-A und F-B sind **eine Entscheidungs-Kette** (F-A="bauen" erzwingt
die F-B-Detailentscheidung), F-C ist ein **davon getrennter** Gegenstand (die Mess-Achse selbst). Die drei
„Varianten" der Rückfrage sind daher: *(F-A) nur Diagnose-Abschluss* · *(F-B) NUMA/Page→allocator jetzt bauen*
· *(F-C) Cacheline-Werteset-Split jetzt bauen*.

---

## §1 Was jede Variante technisch bedeutet

### F-A — Abschluss durch Re-Diagnose (kein Bau)

Phase 0.2 wird als **erledigt-durch-Befund** geschlossen: axis_12 IST bereits korrekt konsumiert — auf
Build-Variant-Ebene, nicht in den Organ-Blättern (Beleg §2.1). Die verbleibende NUMA/Page→allocator-Verdrahtung
bleibt als **design-gated geparkt** (Wiedervorlage, sobald eine Messkampagne die Allocator-Achse tatsächlich
permutiert). Zu tun ist nur Dokumentations-Hygiene: Doc 21 §F/§G-Statuszeile + Ledger-/Task-Eintrag fortschreiben.
- Ändert **keine** Achse, **keine** Wertemenge, **keinen** Code.

### F-B — NUMA/Page→allocator-Verdrahtung jetzt bauen

Die einzige laut Re-Diagnose **legitime, noch fehlende** axis_12-Organ-Konsumption (Doc 21 §F.1 „Folgerung",
`:190-194`): die Felder `numa_capable` / `memory_page_size` / `huge_page_capable` der Plattform-Profile
(`ce/libs/cache_engine/topics/hardware/axis_12_general_hardware/axis_12_general_hardware_x86_64.hpp:33-37`)
fließen als **Compile-Time-Inputs** in die Allokator-Achse (axis_06). Thesis-Motivation (belegt, aber NICHT
wörtlich mandatiert — „design-konsistente Ableitung, unter-spezifiziert", BEFUND.md-Rohdaten Q4):
- `numa_capable` → NUMA-Origin-Policy = Unterachse **AA5** (thesis `anhang/de/D_building_block_matrix.tex:295`)
  mit Variante **NUMAlloc A09** (ebd. `:318ff`; Organ existiert:
  `ce/libs/cache_engine/axes/alloc/axis_06_allocator_numalloc.hpp:38-43`, `kDefaultNumaNode = -1`).
- `memory_page_size`/`huge_page_capable` → Huge-Page-Pools/dTLB-Reach (thesis `kapitel/en/02_fundamentals.tex:50-53`:
  „huge pages (2 MiB/1 GiB) enlarge the TLB reach"; FF3 nennt dTLB-Misses explizit als Messgröße,
  `kapitel/de/01_einleitung.tex:98-104`).
Die dabei zu entscheidenden F-B-Details: (a) **Kanten** — nur allocator, oder auch node/layout (dTLB-bewusste
Knotengröße)? (b) **Mechanismus** — compile-time-gated (`if constexpr (Hw::numa_capable())` → Pinning-Code
wegkompiliert) vs. reine Varianten-Auswahl (NUMAlloc nur bei numa-fähiger Plattform in Enabled-Liste)?
Zum Mechanismus schweigt die Thesis (BEFUND-Rohdaten Q5: „NEIN — kein Präjudiz"; schwacher Lean zu
HW-als-Typ-Profil wegen ISA-Präzedenz + `build_variant_definition<PT,SE,HW>`).

### F-C — Cacheline-Werteset-Split (Mess-Achse, Thesis-Kern)

Zwei Teile:
- **C1 (Werteset-Angleich):** Thesis KF-5 definiert die Cache-Line-Unterachse mit Werten **64 / 128 / 32 Byte**
  („64 Byte (Standard x86-64/ARM64), 128 Byte (Azure, manche Power ISAs) oder 32 Byte (embedded)",
  `thesis/diplomarbeit/anhang/de/D_building_block_matrix.tex:251`). Der Code hat stattdessen
  `{B64, B128, B256}` (`ce/libs/cache_engine/axes/cacheline/cacheline_config.hpp:30`). Divergenz: Code hat
  B256 (existiert real, z.B. s390x), Thesis hat 32 (embedded) — **B32 fehlt im Code**. Sauberste Auflösung =
  **additive Superset-Erweiterung** `{B32, B64, B128, B256}` (nichts ersetzen/löschen; additive Doktrin).
- **C2 (Dimensions-Split):** Die FF2-Teilfrage — „widersprüchliche Literaturbefunde zur optimalen
  Knoten-/Cache-Line-Größe (**eine** Cache-Line bei CSS/CSB⁺ gegenüber bis zu **sechzehn** bei Hankins/Patel)
  bias-frei nachmessen" (`thesis/diplomarbeit/kapitel/de/01_einleitung.tex:94-99`) — meint konzeptionell die
  **Knoten-Breite-in-Cache-Lines** (1..16), eine ANDERE Dimension als die Line-**Größe** (32/64/128/256).
  Der Code kennt heute nur die Line-Größe; die Breite-in-Lines existiert als Knopf **nicht**. C2 = die zwei
  Dimensionen als **zwei getrennte Unterachsen** ausweisen (Line-Größe = bestehende `CacheLineConfig.line_size`;
  Knoten-Breite = NEUE Unterachse, z.B. NTTP `width_in_lines ∈ {1,2,4,8,16}` im Layout-/Node-Kontext),
  ausschließlich in **separaten Profilen** aktiviert.

---

## §2 Ist-Code-Befund (verifiziert, datei:zeile)

### 2.1 Achse 12 (general_hardware) — was ist verdrahtet

| Was | Wo | Status |
|---|---|---|
| Plattform-Profile (Generic/X86_64/Aarch64) mit den 5 Properties `cache_line_size/memory_page_size/simd_width_bits/numa_capable/huge_page_capable` | `ce/libs/cache_engine/topics/hardware/axis_12_general_hardware/axis_12_general_hardware_x86_64.hpp:33-37` (analog `_generic.hpp`, `_aarch64.hpp`) | vorhanden |
| Registry `AllPlatforms`/`EnabledPlatforms` (mp_filter über CMake-Flags) | `.../axis_12_general_hardware_registry.hpp:42,59`; Flags `.../axis_12_general_hardware_flags.hpp.in:21-27` (CMake `CMakeLists.txt:921-930`) | vorhanden |
| Konsum **cache_line + numa** → ABI-POD `BuildVariantDefinitionV1` (`hw_cache_line`, `hw_numa_capable`) | `ce/libs/cache_engine/anatomy/build_variant_definition.hpp:24-26` (POD-Felder), `:63-77` (`build_variant_definition<PT,SE,HW>()` liest `HW::cache_line_size()`/`HW::numa_capable()`) | **verdrahtet** (Build-Variant-Pfad) |
| Konsum als Build-Permutations-Achse (T19 im 26-Achsen-Produkt) | `ce/libs/cache_engine/builder/experiment_tree/registry_to_axis_levels.hpp:74` (`T19_general_hardware`), `:107` (Level-Push), `:114-130` (Gate-1-Produkt) | **verdrahtet** |
| Konsum **memory_page_size / huge_page_capable** — irgendwo | grep über `ce/libs`, `ce/apps`, `ce/modules`: Treffer NUR in den axis_12-Profil-Dateien + Concept (`.../concepts/axis_12_general_hardware_concept.hpp`) | **NIRGENDS konsumiert** (honest-0) |
| Organ-`cache_line_size()` in den Layouts | intrinsische Layout-Semantik (packed_bitmap→8, aos_strict→1), NICHT HW-Deskriptor — Doc 21 §F.1 Punkt 1-2 (`:177-186`); golden-BLOCKER beim Templatisieren der konkreten Klasse `CacheLineAlignedMemoryLayout` in `AllLayouts`-mp_list | **TABU, nicht anfassen** (bereits entschieden) |

### 2.2 Achse 6 (allocator, T6) — NUMA/Page-Anteile

- `NUMAllocAllocator` (AA5/A09) existiert mit explizitem NUMA-Node-Parameter, aber hart `kDefaultNumaNode = -1`
  (kernel-Default) — **kein** axis_12-Bezug: `ce/libs/cache_engine/axes/alloc/axis_06_allocator_numalloc.hpp:42-43`.
- Die CRTP-Basis trägt bereits eine defaulted-NTTP-Unterachse (Präzedenzfall für F-B-Mechanik):
  `ce/libs/cache_engine/axes/alloc/axis_06_allocator_strategy_base.hpp:57-60`
  (`template <typename Derived, CacheLineConfig CacheLineCfg = CacheLineConfig{}>`) — ein zweiter defaulted
  Param (HW-Typ-Profil) wäre quellkompatibel, die **Blätter bleiben konkrete Klassen** → Registry-mp_list unberührt.
- Kein Allocator-Organ liest `memory_page_size`/`huge_page_capable` (grep-Beleg 2.1, letzte Zeile) → F-B wäre
  **Neu-Verdrahtung**, kein Literal-Ersatz.
- Utilization-Stand 0.3a (Kontext): 3 Pool-Stores (BST/btree/surf) treiben axis_06 COW-safe via Memento
  (`ce/libs/cache_engine/axes/lookup/composable/btree_node_pool_store.hpp:18,83`, `surf_fst_map_pool_store.hpp:17,46`);
  Produktions-Flat-Store fädelt `Composition::allocator` (`ce/libs/cache_engine/anatomy/abi_adapter.hpp:2004-2012`).
  0.3b (Differenzierung) = EXTERN_GATED, weil **golden-320 die Allocator-Achse nicht permutiert** (Doc 21 §F `:160-165`).

### 2.3 Cacheline-Unterachse (KF-3/KF-5) — Ist

- Wertraum `3×3×5 = 45`: `ce/libs/cache_engine/axes/cacheline/cacheline_config.hpp:29-32`
  (enum `CacheLineSize {B64,B128,B256}` `:30`), Enumeration `all_configs()` (45) `:92-98`,
  int→enum-Parser (kennt nur 64/128/256) `:110`.
- Per-Organ als defaulted NTTP-Mixin `CacheLineAware<Cfg>` in den Strategie-Basen von node/alloc/lookup/layout/page
  (z.B. `ce/libs/cache_engine/axes/layout/axis_05_memory_layout_strategy_base.hpp:42-49`); Default `{}` = B64/None/None.
- **Binary-id-relevant NUR wenn ein Profil sie aktiviert:** `ce/libs/cache_engine/builder/experiment_tree/profile_to_tree.hpp:53-58`
  (cacheline → statische Sub-Ebenen `cacheline.line_size/alignment/sw_hint`). Aktivierendes Profil:
  `ce/libs/cache_engine/algorithm_profiles/thesis_profiles/cacheline_study.profile.xml:37-49`
  (per_organ="page node traversal allocator", line_sizes 64/128/256 `:38-40` → bis 45⁴ beabsichtigt).
  `base_pilot.profile.xml:19` hat **KEINE** cacheline-Achse.
- Pinnender Test: `ce/tests/unit/test_kf3_cacheline_subaxis.cpp:56-61` (`all_configs().size()==45`, 45 distinkt).
- Knoten-Breite-in-Cache-Lines (FF2, 1..16): **existiert nicht** als Knopf (kein Code-Fundort; die „bis 16 Lines"
  leben nur implizit in Layout-/Node-Konstanten wie `kLineBytes=64`, `layout_aware_store.hpp:64`).

### 2.4 Schutzgüter (TABU-Bezug)

- **Gate-1-Produkt** = 137.594.142.720.000 = Produkt der 26 Enabled-Listen
  (`ce/libs/cache_engine/builder/experiment_tree/registry_to_axis_levels.hpp:114-130`; eingefroren lt.
  `ce/libs/cache_engine/axes/mapping/axis_03m_mapping_registry.hpp:21-26` — Neuschnitt NUR mit explizitem GO).
  Die cacheline-Unterachse ist **NICHT** unter den 26 → ihr Wertraum geht NICHT ins Gate-1-Produkt ein.
- **golden-320:** `ce/tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt` (eingefroren `:1-3`) — die
  binary_ids enthalten **weder** `cacheline.*`-Ebenen **noch** general_hardware; `allocator=std_malloc` in allen 320.
- **ABI:** `BuildVariantDefinitionV1` bleibt bei allen drei Varianten unverändert (v1; `hw_cache_line`/`hw_numa_capable`
  sind schon drin; page/huge NICHT in den POD aufnehmen — Organe läsen den HW-Typ compile-time direkt).

---

## §3 Auswirkungs-Matrix je Variante

| Kriterium | **F-A** (nur Diagnose-Abschluss) | **F-B** (NUMA/Page→allocator bauen) | **F-C** (Werteset-Split bauen) |
|---|---|---|---|
| **Permutationsraum / Gate-1** | unverändert | unverändert (reine Feld-Verdrahtung; keine neue Enabled-Variante, T6/T19-Kardinalität konstant) | Gate-1 unverändert (cacheline ∉ 26-Achsen-Produkt); per-Organ-Raum 45→60 (4×3×5); `cacheline_study`-Raum 45⁴→60⁴ NUR falls ein Profil B32 aufnimmt (separates Profil empfohlen) |
| **golden-320 / ABI** | unberührt | golden-neutral machbar: defaulted HW-Typ-Param auf der Basis (Blätter konkret, mp_list identisch), `std_malloc`-Pfad byte-identisch; ABI-POD unverändert | golden-neutral machbar: **additiv** B32 ergänzen (B256 NICHT ersetzen — sonst brechen `cacheline_study.profile.xml:40` + Parser `:110`); binary_ids ohne cacheline-Ebenen bleiben identisch; `test_kf3`-Pin 45→60 = dokumentierte Test-Fortschreibung (kein golden) |
| **Mess-Aussagekraft (FF0-FF4)** | 0 (verschiebt nur ehrlich) | thesis-motiviert (AA5/NUMAlloc, dTLB/huge-pages, FF0-Plattformen, FF3-dTLB-Misses) — ABER kurzfristig **inert**: golden-320 permutiert allocator nicht (×320 std_malloc), kein aktives Profil fährt NUMALLOC (`cacheline_study.profile.xml:33` nur SYSTEM_MALLOC/JEMALLOC/MIMALLOC); NUMA-Effekt braucht zudem Multi-Socket-HW (P/E-Core/prod2 = HW-gated ~Sep) | **direkt auf den Thesis-Kern**: KF-5-Werteset wird thesis-treu ({32,64,128} ⊂ {32,64,128,256}); C2 macht die FF2-Teilfrage (CSS/CSB⁺ 1 Line vs. Hankins/Patel 16 Lines) ERST messbar — heute existiert der Knopf nicht |
| **TABU-Verträglichkeit** | trivial | mittel: sauber machbar, aber nahe der Mess-Maschinerie (0.3-Lektion: COW-Zwei-Phasen-Messung, Doc 21 §F.2) — während der laufende golden-320-Messlauf (#9916) die Maschinerie aktiv nutzt | gut: additive Enum-Erweiterung + neue Unterachse NUR in separaten Profilen = exakt das im Task geforderte Muster („neue Wertemengen nur in separaten Profilen") |
| **Aufwand** | ~0 (Doku) | mittel-hoch: Neu-Verdrahtung + Feld-Kanten-Design (thesis-under-specified) + Tests + adversarialer Review; Nutzen erst mit späterer Allocator-Permutations-Kampagne | C1 klein (Enum+Parser+Test+neues Profil); C2 mittel (neue NTTP-Unterachse + Mixin-Anschluss + Profil + Doku) — beides klar schneidbar |
| **Metaprog-Strenge** | n/a | streng erfüllbar: HW-als-Typ-Param (ISA-Präzedenz `build_variant_definition<PT,SE,HW>`) + `if constexpr`-Gating = compile-time-only, CRTP+Concept-Guard-konform | streng erfüllbar: NTTP-Enum/NTTP-Unterachse, kein Runtime-Switch (Muster `cacheline_config.hpp`) |

---

## §4 Bewertung und Empfehlung

1. **F-A ist kein echter Gegenspieler, sondern Pflicht-Hygiene:** Die Re-Diagnose ist bereits geschehen und
   dokumentiert (Doc 21 §F.1); der Abschluss (Status fortschreiben, Fork als entschieden markieren) fällt bei
   JEDER Wahl an. F-A **allein** hieße: Task #8 produziert keinerlei Mess-Substanz.
2. **F-B ist thesis-motiviert, aber im Ist-Zustand wirkungslos:** Solange keine Messkampagne die Allocator-Achse
   permutiert (golden-320: `allocator=std_malloc` ×320; aktive Profile ohne NUMALLOC) und kein Multi-Socket-/
   Huge-Page-Messfenster existiert, erzeugt die Verdrahtung **keinen einzigen neuen Messpunkt** — sie wäre
   Architektur-Arbeit auf Vorrat, nahe der Mess-Maschinerie, während #9916 läuft. Dieselbe Klasse Entscheidung
   wurde bei 0.3b bereits als EXTERN_GATED eingestuft (Doc 21 §F `:160-165`) — F-B gehört konsistenterweise in
   dieselbe Schublade, mit dem hier festgehaltenen Bauvorschlag (§1/F-B: HW-als-Typ-Param, nur allocator-Kante,
   compile-time-gated) als vorbereitetem Design.
3. **F-C zahlt direkt auf den Thesis-Kern ein:** Die Cache-Line-Unterachse ist erklärtes KERNTHEMA
   (`cacheline_config.hpp:2`), die FF2-Teilfrage (1-vs-16-Lines-Kontroverse) ist eine wörtliche Forschungsfrage
   der Einleitung — und ihr Mess-Knopf **existiert noch nicht**. Der Werteset-Angleich (C1) beseitigt zudem eine
   dokumentierte Thesis↔Code-Divergenz, bevor die große Messkampagne Werte produziert, die dann nicht zur
   KF-5-Definition passen. Beides ist additiv, golden-/Gate-1-neutral und in separaten Profilen kapselbar.

**Empfehlung: F-C wählen** — geschnitten als (C1) additiver Werteset-Angleich `{B32,B64,B128,B256}` sofort,
(C2) Knoten-Breite-in-Lines als eigene neue Unterachse als direkt anschließender, getrennt reviewter Increment;
**F-A-Doku-Abschluss als Beipack** im selben Zug; **F-B als EXTERN_GATED parken** (Wiedervorlage mit der ersten
Allocator-Permutations-Kampagne bzw. Multi-Socket-HW, Design in diesem Dossier vorentschieden).

---

## §5 Formulierte User-Rückfrage (zur Vorlage)

> **Task #8 (Phase 0.2-Rest) — welche Variante soll ich umsetzen: F-A, F-B oder F-C?**
>
> **F-A (nur Diagnose-Abschluss):** Phase 0.2 wird als erledigt-durch-Befund geschlossen, die
> NUMA/Page→allocator-Verdrahtung bleibt design-gated geparkt. Kostet nichts und ist bei jeder Wahl ohnehin
> fällig — erzeugt aber allein keinerlei neue Mess-Substanz.
>
> **F-B (NUMA/Page→allocator jetzt bauen):** `numa_capable`/`memory_page_size`/`huge_page_capable` fließen
> compile-time-gated (HW-als-Typ-Param, nur allocator-Kante) in die Allokator-Achse. Thesis-motiviert
> (AA5/NUMAlloc, dTLB/huge-pages), golden-neutral machbar — aber kurzfristig wirkungslos, weil keine aktive
> Messstrecke die Allocator-Achse permutiert und der NUMA-Effekt Multi-Socket-Hardware braucht (HW-gated ~Sep).
>
> **F-C (Cacheline-Werteset-Split):** (C1) Werteset additiv an die Thesis angleichen ({32,64,128} der KF-5 ⊂
> neuem {B32,B64,B128,B256}) und (C2) die FF2-Dimension „Knoten-Breite-in-Cache-Lines (1..16)" als eigene,
> neue Unterachse bauen — beides nur in separaten Profilen aktiviert, golden-320 und Gate-1 bleiben unberührt.
> Das macht die wörtliche FF2-Teilfrage (CSS/CSB⁺ 1 Line vs. Hankins/Patel 16 Lines) erstmals messbar.
>
> **Ich empfehle F-C** (C1 sofort, C2 als direkt anschließender eigener Increment), mit F-A-Doku-Abschluss als
> Beipack und F-B als EXTERN_GATED-Parkposition mit vorentschiedenem Design. Begründung: F-C ist die einzige
> Variante, die jetzt direkt auf den Thesis-Kern (KF-5/FF2) einzahlt, ohne die laufende Messstrecke (#9916)
> oder die TABU-Güter zu berühren; F-B produziert im Ist-Zustand keinen einzigen neuen Messpunkt.

---

## Anhang: Quellen-Kurzliste

- Doc 21 §F.1/§F.2/Design-Forks: `docs/architektur/21_SESSION_PLAN_TYPSYSTEM_ACHSEN_ENTSCHEIDUNGEN.md:175-233`
- Phase-0.2-BEFUND (Deep-Research wf_7bba0921): `docs/sessions/backups/20260710-phase02-general-hardware-design/BEFUND.md`
  (+ `rohdaten/journal.jsonl` — Q1-Q5 mit Thesis-Belegen)
- Ledger GO 4: `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:272`; Gate-1-Zahl: ebd. `:172`
- Thesis: `thesis/diplomarbeit/anhang/de/D_building_block_matrix.tex:251` (KF-5 {64,128,32}), `:295/:318ff`
  (AA5/NUMAlloc A09); `kapitel/de/01_einleitung.tex:75-118` (FF0-FF4, FF2-Teilfrage `:94-99`);
  `kapitel/en/02_fundamentals.tex:50-53` (huge pages/dTLB), `:97-104` (Line-Größe = Kompilations-Input)
- ce-Code: siehe §2-Tabellen (alle Pfade unter `Code/external/comdare-cache-engine/`)
