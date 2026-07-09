# P33-VAMPIR Nachbau — Blueprint (Synthese aus 5 ultracode-Dissect-Facetten, wf_5fcbf469)

## Kern-Befund (Faithfulness + Concept-Facette, quellenbelegt)
Ein „faithful VAMPIR-Nachbau" ist **notwendig PARTIELL**: von den 5 vorgelegten Konzepten hat **nur EINES**
ein Mechanismus-Zuhause im cache-engine. Der Rest = Scheduling/OS = Fabrikation, wenn nachgebaut.
- **(2) Memory-Type-Virtualization = IN-SCOPE, der einzige echt-baubare Kern** → als **Allokator-Layout-PAAR**.
- (1) NFP {Bandwidth/Latency/Energy/Capacity} = **Vokabular/Descriptor**, kein Organ. **Energy = out-of-scope** (kein Counter).
- (3) Compensation, (5-dyn) laufende Re-Platzierung, Pipeline-Scheduling/Negotiation/OS-Migration = **OUT-OF-SCOPE** (annotieren, NICHT bauen; NICHT auf die migration_policy-Achse umleiten = Direktiven-Verstoß).
- „Micro-Allocators/Memory-Decorators" + „multidimensional" = **grep-verifiziert NICHT in den VAMPIR-Quellen** → abgeleitete cache-engine-Pattern-Begriffe, ehrlich als solche kennzeichnen.
- **is_original=false ZWINGEND** (kein isolierbarer Original-Code; Poster). NICHT mit `TelemetryVampirOtf2` (Namenskollision, anderes Artefakt) verwechseln. Kein DOI/keine Konferenz erfinden (Poster bleibt Poster).

## Realisierung = „Allokator-Layout"-Paar (deckt User-Direktive „VAMPIR ist ein allokator layout")
**A) Allokator `VampirNfpAllocator`** (axis_06, family **A24**, Default-OFF, END-Append AllVendors → golden-neutral):
polymorpher `std::pmr::memory_resource`-Front, der Allokationen an einen gewählten Memory-Tier/Arena routet
(DRAM/HBM/NVRAM), NFP-Descriptor {bandwidth_class, latency_class, capacity} als Arena-Metadatum + optional
statischer NFP-Vektor-Selektor. Reuse **AllocationStatistics**-POD (KEIN ABI-Bump). CRTP `: AllocatorStrategyBase<…>`,
11 static-Properties + sized+aligned allocate/deallocate, KEIN OriginalCodeMixin. 3 Wiring-Punkte (flags.hpp.in +
CMake option OFF + registry AllVendors-Append). Vorlage: `axis_06_allocator_pool_resource.hpp`/`_exgen.hpp`.
**B) Layout `NfpTierPlacedMemoryLayout`** (axis_05, Default-OFF, END-Append AllLayouts → golden-neutral):
realisiert den **derzeit DANGLING Profil-String `NUMA_PINNED`** (ungethuem.profile.xml:19, kein Organ dahinter) als
echtes Layout-Organ; trägt NFP-Tier-Tag (`TierKind` aus cache_recommendation.hpp) + macht den Tier-Stride im Store
physisch real. **ACHTUNG (ABI-adjazent):** braucht neuen `RepresentationKind::tier_placed_stride` + 3 Store-Dispatch-
Stellen in `axis_04_node_type_layout_aware_store.hpp` (record_phys_bytes:91-96 / key_ptr_/value_ptr_:345-378) — sonst
kollabiert die Rep auf 16B-Default (P-MD1-Phantom). Enum-Add „mit Mess-Schema-Owner koordinieren" (Facet-Warnung).
**C) P33-Voll-Profil** zeigt auf beide (`<allocator>VAMPIR_NFP</allocator>` + `<layout>NUMA_PINNED</layout>`),
koexistiert mit dem abstrakten Marker (erweitern, nicht ersetzen). + Out-of-scope-Annotation (s.o.).

## Golden-320-Neutralität (golden_neutral-Facette, verifiziert)
- 320 = `mp_take_c<StaticAxisVariants,N>` First-N je Achse (search 4/node 4/layout 5/prefetch 4, Rest Index-0 gepinnt).
- **Allokator = GEPINNTE Achse (First-1)** → neuer Typ irgendwo AUSSER Index 0, Default-OFF = neutral (P08-OLC-Präzedenz).
- **Layout = VARIIERTE Achse (First-5)** → neuer Typ MUSS ans mp_list-ENDE + Default-OFF (AP-7-SwissTable-Präzedenz), sonst brechen die 320-binary_ids (test_profile_roundtrip rot).
- TABU (nie anfassen): `golden_fullpilot_320_binary_ids.txt`, `gen_golden_fullpilot.cpp`, `permutation_axes.xml`-Enum, `kCompositionAxisNames`(19), AdHocComposition-Arität(==19), `COMDARE_ANATOMY_ABI_MAJOR`(bleibt 4).
- **KORREKTUR (Facet):** P09/PackedBitmap IST in der 320 (layout variiert) — nur im permutation_axes.xml-Enum abwesend. Sauberer „nicht-in-320"-Präzedenzfall = P08/OLC. (Betrifft nur die Doku, nicht mein AP-6-louds-Profil.)

## Scope-Fork (User-Entscheid — die Klarheit, für die der Workflow lief)
- **(A) NUR Allokator jetzt** (`VampirNfpAllocator` A24) — sauber, eindeutig golden-neutral, KEINE Store-/Enum-Änderung, KEIN ABI-Risiko. Layout-Hälfte (NUMA_PINNED realisieren) = koordinierter Folge-Increment.
- **(B) Allokator + Layout-Paar jetzt** — voller „allokator layout", aber Layout-Hälfte = neuer RepresentationKind + Store-Edits (ABI-adjazent, Mess-Schema-Koordination, größer/riskanter).
- Beide + P33-Voll-Profil + Out-of-scope-Annotation. **Empfehlung: (A)** zuerst (golden-neutral sicher), (B) als koordinierten Folgeschritt — es sei denn du willst das Paar in einem Zug.
