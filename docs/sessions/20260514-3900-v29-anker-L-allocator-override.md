# V29 (L) — Anker: ExperimentDriver Allokator-Override (2026-05-14, 39:00)

**Vorgaenger:** `20260514-3800-v28-anker-M-thesis-ch02.md`
**Hauptthema:** L — ExperimentDriver Allokator-Override
**Risiko:** mittel (Code-Aenderung in cache-engine ExperimentDriver)
**Repo:** cache-engine

---

## §1 V29-Phasen

| # | Was |
|---|---|
| V29.A | xml_config_parser AlgorithmProfile.allocator_override Field |
| V29.B | ExperimentDriver Phase 5 honors allocator-Override (analog V19.3) |
| V29.C | Test fuer allocator-Override |
| V29.D | Final commit + Pin-Bump + Doku |

---

## §2 V29-Designentscheidung

V19.3 fuehrte ein: Profile-XML kann optional `<expected_workload>`-Tag
setzen, der die V11.2 traversal-Heuristik ueberschreibt.

V29 fuehrt analog ein: Profile-XML kann optional `<allocator_override>`-Tag
setzen, der die `<axes><allocator>`-Wahl im Profile ueberschreibt.

**Anwendung:** wenn Profile X auf jemalloc als allocator-axis spezifiziert
ist, aber per Default-Mess-Reihe sollten alle Profile auf mimalloc gemessen
werden, kann der Builder per Profile-XML den Override liefern. Das ist
zusaetzlich zu der `<allocator>`-Achse im Profile selbst (die bleibt als
Default fuer den Algorithmus-Idealfall).

```xml
<comdare_algorithm_profile id="art" paper_ref="P01">
  <axes>
    <allocator>MIMALLOC</allocator>  <!-- Profile-Default -->
    ...
  </axes>
  <expected_workload>YCSB_C</expected_workload>
  <allocator_override>jemalloc</allocator_override>  <!-- NEU V29: Override -->
</comdare_algorithm_profile>
```

**Konvention:** Override-Wert ist die Profile-id eines Allokator-Profils
aus `cache_engine/algorithm_profiles/allocators/`.

**Verarbeitung:** ExperimentDriver Phase 5 prueft zuerst
allocator_override; wenn gesetzt, ueberschreibt es die axes/allocator.

---

## §3 Erfolg-Kriterien

- [ ] AlgorithmProfile.allocator_override Field
- [ ] xml_config_parser parst <allocator_override>
- [ ] Phase 5 honored Override
- [ ] +1 Test in test_codegen_from_profile (analog V19.4)
- [ ] cache-engine commit + push + Diplomarbeit Pin-Bump

---

## §4 Status der Profile

Heute (Stand V26): KEINS der 30 SOTA-Profile + 10 Allokator-Profile
hat einen `<allocator_override>`-Tag — V29 fuegt nur die Infrastruktur
hinzu. Tags pro Profile koennen spaeter via separates Update gesetzt
werden (V29-Folgephase, wenn die Mess-Reihe das verlangt).
