# Design-Vorlagen: E18 Gattung-Ebene-1-Promotion + H-1 Hardware-Systemachse (2026-07-16, Design-Gate)

> Read-only Design (Opus). VORGELEGT vor Bau (golden/ABI-Berührung). Volle Belege in den Task-Outputs; hier die entscheidungsreife Zusammenfassung + die Morgen-Forks.

## E18 — Gattung-Ebene-1-Promotion + native Set-ABI

**KERN-BEFUND (beruhigend): die Ebene-1-Promotion ist golden-320-ERHALTEND, BEWIESEN.** Der `binary_id` = `serialize_composition_path` baut den String rein aus den 19 SearchAlgorithm-Kompositions-Achsennamen (`axis_path_serialization.hpp:30-60`, `kCompositionAxisNames`) — weder `AnatomyGattung` noch `AnatomyGenus` gehen ein; `grep gattung|genus|set` über `golden_fullpilot_320_binary_ids.txt` = **0 Treffer**. `CatalogAxes<4,4,5,4>` variiert nur SA-Achsen. ⇒ Die Promotion ändert KEINEN golden-320-String, KEINE Messdaten; keine Regenerierung.

**F1a (sofort baubar, golden-neutral):** Doku/Kommentar-Versöhnung „User-*Gattung* ≡ Code-*Genus*" — `anatomy_base.hpp:56-73` (Doc an `AnatomyGenus`: Set ist bereits eigenes Genus mit eigener ABI `ISetTier`), `container_framework.hpp:11-17` (#29 als entparkt kennzeichnen, Zeile nicht löschen), Doc 37 §1-2. Kein static_assert/Enum berührt, CI grün.

**F1b (ABI-Contract-Bruch, GOLDEN-erhaltend — VORGELEGT):**
- `AnatomyGattung` additiv: `SearchAlgorithm=0`(=map), `Container=1`(=Sequence-Familie, re-skopiert), `Graph=2`, **`Set=3` NEU angehängt** (kein Reshuffle). `AnatomyGenus` bleibt **byte-identisch** (kritisch: `genus()` liefert Werte über ABI, Prüf-Dock sortiert danach).
- Semantischer Bruch nur in `gattung_of()` (`Set→Gattung::Set`), `container_framework` (`type_count 4→3`, `!ContainerType<Set>`, static_asserts), `GenusBindingTraits<Set>.gattung`, `test_29_container_framework.cpp` (Compile-Gate). **Der Compiler erzwingt `Set∉Container` = die „unverhandelbare Durchsetzung".**
- golden-320 UNVERÄNDERT (Beweis oben), keine Regenerierung, Messdaten intakt.

**F2 (native Set-ABI, additiv):** `extract/merge/union/intersect/difference` als vtable-Slots am ENDE von `ISetTier`; `SetObserverSnapshotV2` = V1 + hinten angehängte Felder (P-MD3-Append-Muster, `observable_tier.hpp:142`). vtable-Append = ABI-brechend → reitet auf 4→5-Bump. **F3 (ordering/multiplicity als Set-Achsen, end-append, Default=Ist):** `set_ordering{unordered(Ist)/ordered/flat}` + `set_multiplicity{unique(Ist)/multi}` — Set-Achsen (nicht in den 19 SA-Namen, Set hat kein golden-320) → golden-frei; Folge-Increment nach F1b.

**Koordinierter ABI-Schritt:** F1b (Grenzkosten ~0, POD-1416 unberührt) + F2 (Set-V2) reiten auf DEMSELBEN Anatomy-ABI-Major **4→5**, den #37-Scheduling ohnehin auslöst (dessen Achse berührt vermutlich `kV3AxisCount 19→20`/1416-POD = echter Layout-Bruch) — EIN Rebuild statt zwei, NACH der F12(iii)-ABI-Grenzen-Session. Reihenfolge: F1a jetzt → F12(iii) fixiert Grenzen → EIN 4→5-Bump {#37-POD, F1b-Enum/gattung_of/container_framework, F2-Set-V2} → BuildVersion-Neubau → golden-320 unverändert → F3 Folge.

## H-1 — Hardware-Systemachse (statische Haupt- vs. dynamische Unter-Achsen)

**Abgrenzung (Kern): ISA-Organ-Achse ⟂ Hardware-System-Achse — kein Doppel.** `axis_09`/`axis_09b_simd_extension` (compile-time BUILD-Permutation, `flag_suffix "AMD64"`, `comdare_apply_simd_extension_flags`, **binary_id-bestimmend**) = *welche Instruktionen COMPILIERT werden* (tiefer Permutationsbaum). Hardware-System-Achse (Blut, `system_axis.hpp:147-190`) = beschreibt den **HOST, der die Binary AUSFÜHRT**, berührt NIE binary_id/golden/POD/ABI. Semantisch dual: **emit** (Build) vs. **host-can + measured-on** (Provenienz+Laufzeit). Die Kopplung „Binary-ISA ⊆ Host-Capability" ist das **Mess-Gate**.

**Statische HAUPT-Achse → Ordner/Label:** isa_base, simd_capability (AVX/AVX2/**AVX-512-Subsets b/ AVX10-Version**, aus `probe_cpuid` mit OS-Gate), cache_line, usable_simd_width, is_hybrid-Fakt, uarch. **Dynamische UNTER-Achsen → CSV-Spalten:** `pe_policy`+`ran_on_core_type` (CPUID.1AH→sysfs cpu_core/cpu_atom→hwloc; Aktuator `ScopedThreadPin` cold-start), NUMA, Multithreading, optional Governor/Prefetcher (observe-only auf Cluster). Default → 1 Pass, golden-neutral, kein Hot-Path-vtable.

## MORGEN-FORKS (E18 + H-1, gebündelt)

**E18:** (1) **koordinierter EINER 4→5-Bump** bestätigen (F1b + F2 + #37, nach F12iii)? (2) golden-erhaltender Weg genügt der „in-Stein-Durchbrechung" (Durchsetzung real via Compiler, ohne golden-Zerstörung)? (3) Adapter/View unter Container lassen (Empf.) vs. auch Ebene-1? (4) ein Kopf-Framework je Ebene-1-Gattung (container/set/…)?
**H-1:** (5) **H-6** HardwareSystemAxis als Deskriptor-**Schwesterwurzel** (Label+Spalten, Empf.) vs. Zwang in den Kategorie-Sampler? (6) H-7 AVX/ISA nur Host-Label (Empf.) · H-8 Governor/Prefetcher observe-only (Empf.) · H-9 physical/logical_cores via sysfs befüllen · H-10 AVX10-Versionsfeld statt Einzel-Flags (SOTA-Richtung).
