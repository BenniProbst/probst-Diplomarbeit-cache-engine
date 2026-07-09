# DOSSIER AP-5 / #239 — Full-Sampled-Modus (deterministisches 1:1000-Sampling, seed- UND toolchain-stabil, ABI-NEUTRAL)

> **Für Codex** (`--sandbox workspace-write`, `model_reasoning_effort=xhigh`, Plugin AUS).
> Arbeite **DIREKT als EIN Agent** — KEINE Sub-Agenten, KEIN Orchestrator, KEINE collab-Route.
> Setze §6 vollständig um, halte §4 **strikt** ein, verifiziere §7 lokal (Kommandos + **literale**
> Ergebnisse). **NICHT committen, KEINE git-Operationen, KEIN `git add`** — nur Dateien editieren.
> Claude reviewt danach JEDE Datei manuell und committet selbst. Wenn eine Auflage aus §4 nicht
> erfüllbar ist: NICHTS raten — STOPP + Rückmeldung in §8.

---

## 1. Auftrag (eine Zeile)
Füge dem CacheEngineBuilder einen dritten Messreihen-Modus **`FullSampled`** hinzu: er enumeriert den
vollen Full-Raum, behält aber pro Permutation **deterministisch** nur 1 von `sample_rate` (Default 1000)
Kandidaten — die Auswahl ist **reproduzierbar über Läufe UND über Toolchains/OS** (Windows-MSVC ≡ ZIH-Linux-g++).

## 2. Fachliche Substanz (WARUM)
Der Full-Modus enumeriert das kartesische Produkt aller Achsen-Permutationen (kombinatorisch riesig) plus
den SOTA-Profil-Auto-Pickup. `FullSampled` erlaubt eine **repräsentative, exakt reproduzierbare Teilmenge**
(z.B. 1:1000) — für Vorab-/Skalierungsläufe ohne die vollen Kombinatorik-Kosten. **Kernanforderung:** dieselbe
Teilmenge bei gleichem `(rate, seed)` — nicht nur über Wiederholungen auf DERSELBEN Maschine, sondern auch,
wenn der Windows-Build eine Kandidatenliste erzeugt und der ZIH-Linux-Build sie reproduzieren/fortsetzen soll.
Deshalb darf der Sampling-Schlüssel **NICHT** von `std::hash` abhängen (implementierungsdefiniert, s. §4.1).

## 3. Scope-Abgrenzung (HART)
- **IN (AP-5):** neuer `FullSampled`-Enum-Wert + `sample_rate`/`sample_seed`-Felder + deterministisches,
  toolchain-stabiles keep-Prädikat (neuer Header) + Guard in **BEIDEN** Enumerationsströmen + CLI-Flags +
  Determinismus-/Rate-/Stabilitäts-Test.
- **OUT (im Code als `// AP-5-Follow:` markieren, NICHT umsetzen):** stratifiziertes/gewichtetes Sampling
  (Modulo kann kleine Achsen unterrepräsentieren — `select_one_wise`/coverage bleibt separat); Sampling-Raten-
  Optimierung; Mess-Ausführung selbst; Änderung der bestehenden Modul-Fingerprints (`d.fingerprint`/`prof_fp`).

## 4. HARTE Auflagen (Verstoß = Abbruch; Claude verwirft)
1. **TOOLCHAIN-STABILER SAMPLING-KEY — die zentrale Auflage.** Der keep-Entscheid MUSS aus einem **fixen
   Byte-Hash** der Permutations-`id` (reine Integer-Arithmetik über die Bytes, z.B. FNV-1a-64) gebildet
   werden, gefolgt von einer splitmix64-Mischung vor dem Modulo. **VERBOTEN als Sampling-Key:**
   `std::hash<...>`, `d.fingerprint`, `prof_fp` (alle drei nutzen `std::hash`, das über Compiler/STL/OS
   variiert → nicht reproduzierbar). Der bestehende `d.fingerprint`/`prof_fp` (= Modul-**Identität**) bleibt
   **unverändert** — nur der SAMPLING-Entscheid nutzt den neuen stabilen Key.
2. **DETERMINISTISCH + SEED-STABIL:** keine `std::rand`/`std::random_device`/Zeit/Reihenfolge-Abhängigkeit.
   Gleiches `(id, rate, seed)` ⇒ gleicher bool, immer. Reine Funktion.
3. **ABI-NEUTRAL:** `COMDARE_ANATOMY_ABI_MAJOR` bleibt **4** (Tier-Modul-ABI — nicht anfassen). Auch der
   Enumerations-ABI (`COMDARE_ABI_VERSION`, `include/cache_engine/abi/module_abi_v1.hpp:17`) bleibt
   unverändert. Reine host-seitige Descriptor-Verwerfung VOR Codegen. `ExperimentDriverOptions` ist ein
   Host-Struct (enthält `std::filesystem::path`) — kein serialisierter POD; additive Felder sind neutral.
4. **NICHT-INVASIV:** `Defined` und (ungesampeltes) `Full` verhalten sich **exakt unverändert**. `FullSampled`
   ist rein additiv (neuer Enum-Wert + je ein Guard-Zweig). Der bestehende `test_experiment_driver_v13`
   MUSS grün bleiben (insb. `MessreihenMode_DefaultIsFull`).
5. **KEIN verzerrender Fallback:** wenn die gesampelte Menge **leer** ist (kleines ∏ × hohe Rate), NICHT
   heimlich „mindestens 1" erzwingen (das verfälscht die Verteilung). Stattdessen **ehrliche Warnung** nach
   `stderr`/verbose („sample_rate=N übersteigt Population=M → 0 Kandidaten; kleinere --sample-rate wählen").
6. **TABU:** `modules/**`, `ext/**`, golden-/Registry-`mp_list`, `golden_fullpilot_320_binary_ids.txt`,
   Codegen-ABI-Structs, alle Mess-PODs. Kein `git`.
7. **Stil:** `comdare::*`, C++23; Konstanten benannt (kein Magic-Literal ohne `constexpr`-Konstante);
   numerisches CLI-Parsing via `std::from_chars` (kein throw); umgebenden Code-Stil spiegeln.

## 5. Kartierung (file:line — von Claude verifiziert, Pfade relativ zu `libs/cache_engine/builder/`)
- **5.1 Enum + Optionen:** `experiment_driver/experiment_driver.hpp:54`
  `enum class MessreihenMode { Defined, Full } messreihen_mode = MessreihenMode::Full;`
  (`sota_profile_filter` folgt auf `:55`). Default MUSS `Full` bleiben.
- **5.2 Strom 1 (Kartesik):** `permutation_loop/permutation_loop.cpp:7-29` — 4-fach-Schleife;
  `PermutationDescriptor d` mit `d.id` (`:17`, = `ce.id+":"+sa.id+":"+al.id+":"+tds.id`) und
  `d.fingerprint` (`:18` = `compute_fingerprint(...)`); **`result.push_back(std::move(d));` `:23` = Einhäng-Punkt.**
- **5.3 `compute_fingerprint`:** `permutation_loop.cpp:31-44` nutzt `std::hash<std::string_view>` (`:33`) →
  **implementierungsdefiniert** (die Falle aus §4.1). Header-Deklaration: `permutation_loop.hpp:28-29`.
- **5.4 Strom 2 (SOTA-Profile, Phase 2):** `experiment_driver/experiment_driver.cpp:154-163` —
  `for (auto const& prof : profiles)`; `prof_fp = std::hash<std::string>{}(prof.id) ^ 0xC0FFEE02ull` (`:156`,
  = Modul-Identität, unangetastet lassen). Verbose-Mode-Print `:146-152` (aktuell nur `Full`/`Defined`).
  Defined-Filter (`messreihen_mode == Defined`) steht davor `:133-143` — für `FullSampled` NICHT relevant.
- **5.5 Aufrufer Strom 1:** `experiment_driver.cpp:91-92` `loop::PermutationLoop pl; out_descriptors = pl.enumerate(cfg);`
  (**einziger** `enumerate`-Aufrufer — per Grep bestätigt; verifiziere trotzdem selbst mit
  `grep -rn '\.enumerate(' libs tests apps`).
- **5.6 splitmix64-Vorlage (NICHT wiederverwendbar, `static`):** `workload_driver/workload_generator.cpp:116-121`
  `splitmix64_scramble_` — Konstanten `0x9E3779B97F4A7C15`, `0xBF58476D1CE4E5B9`, `0x94D049BB133111EB`,
  Shifts 30/27/31 EXAKT übernehmen (in den neuen Header, eigene Funktion).
- **5.7 CLI:** `apps/cache_engine_builder/main.cpp:87-102` (else-if-Kette; Muster `--comdare-root=` `:95-96`
  via `a.rfind("--x=",0)==0` + `a.substr(...)`). Mode wird aktuell NIE per CLI gesetzt (Default `Full`).
  `print_usage(std::ostream&)` `:~50-62` + Mode-Print `:108-110`.
- **5.8 Test-Registrierung:** `tests/unit/CMakeLists.txt` — Muster `comdare_add_test(<name>)` (z.B.
  `test_experiment_driver_v13`, `test_permutation_flags`). Test-Vorlage: `tests/unit/test_experiment_driver_v13.cpp`.

## 6. Soll-Umsetzung (konkret)

### 6.1 NEU: `libs/cache_engine/builder/permutation_loop/permutation_sampling.hpp`
```cpp
#pragma once
// AP-5/#239 — deterministisches, toolchain-STABILES 1:sample_rate-Sampling fuer den FullSampled-Modus.
// Bewusst KEIN std::hash: dessen Ergebnis ist implementierungsdefiniert (variiert ueber Compiler/STL/OS)
// -> die gesampelte Menge waere NICHT reproduzierbar zwischen Windows-MSVC und ZIH-Linux-g++.
#include <cstdint>
#include <string_view>

namespace comdare::builder::loop {

// FNV-1a-64 ueber die rohen Bytes der id — reine Integer-Arithmetik, identisch auf jeder Toolchain.
[[nodiscard]] constexpr std::uint64_t stable_id_hash(std::string_view id) noexcept {
    std::uint64_t h = 0xCBF29CE484222325ULL;               // FNV-1a offset basis
    for (char c : id) {
        h ^= static_cast<std::uint64_t>(static_cast<unsigned char>(c));
        h *= 0x100000001B3ULL;                             // FNV prime
    }
    return h;
}

// splitmix64-Finalizer (Steele/Lea) — dekorreliert die niederwertigen Bits vor dem Modulo.
[[nodiscard]] constexpr std::uint64_t splitmix64_mix(std::uint64_t x) noexcept {
    x += 0x9E3779B97F4A7C15ULL;
    x = (x ^ (x >> 30)) * 0xBF58476D1CE4E5B9ULL;
    x = (x ^ (x >> 27)) * 0x94D049BB133111EBULL;
    return x ^ (x >> 31);
}

// Deterministischer 1:sample_rate keep-Entscheid, seed-parametrisiert, reproduzierbar ueber Laeufe UND Maschinen.
// sample_rate <= 1 behaelt ALLES (Sampling deaktiviert) -> Defined/Full unveraendert.
[[nodiscard]] constexpr bool sample_keep(std::string_view id,
                                         std::uint32_t sample_rate,
                                         std::uint64_t sample_seed) noexcept {
    if (sample_rate <= 1u) return true;
    return (splitmix64_mix(stable_id_hash(id) ^ sample_seed) % sample_rate) == 0u;
}

} // namespace comdare::builder::loop
```

### 6.2 `experiment_driver.hpp` — Enum erweitern + Felder (`:54-55`)
```cpp
    enum class MessreihenMode { Defined, Full, FullSampled } messreihen_mode = MessreihenMode::Full;
    std::vector<std::string> sota_profile_filter; // optional: nur diese Profile (Defined-Mode)

    // REV 7.6 AP-5/#239 — FullSampled: deterministische 1:sample_rate-Teilmenge des Full-Raums,
    // seed- und toolchain-stabil (s. permutation_sampling.hpp). Nur wirksam bei messreihen_mode==FullSampled.
    std::uint32_t sample_rate = 1000; // 1:1000 Default; <=1 deaktiviert Sampling
    std::uint64_t sample_seed = 0;    // reproduzierbare Variation der Teilmenge
```
(`#include <cstdint>` sicherstellen — vermutlich transitiv vorhanden; sonst additiv.)

### 6.3 `permutation_loop.hpp` — enumerate() um Default-Sampling-Parameter erweitern (`:26`)
```cpp
    // sample_rate==0/1 => keine Filterung (Defined/Full unveraendert). >=2 => deterministisches 1:sample_rate.
    [[nodiscard]] std::vector<PermutationDescriptor>
    enumerate(xml::CacheEngineConfig const& cfg,
              std::uint32_t sample_rate = 0,
              std::uint64_t sample_seed = 0) const;
```
Bewusst KEIN `MessreihenMode`-Parameter (das waere eine Layer-Inversion — `permutation_loop` liegt UNTER
`experiment_driver`). Die untere Schicht kennt nur „rate/seed".

### 6.4 `permutation_loop.cpp` — Signatur + Guard vor push_back
- `#include "permutation_sampling.hpp"` ergänzen.
- Signatur von `enumerate` an den Header angleichen (die zwei Parameter).
- **Vor `:23`** (`result.push_back(std::move(d));`) einfügen:
```cpp
                    if (sample_rate >= 2u && !sample_keep(d.id, sample_rate, sample_seed)) continue;
                    result.push_back(std::move(d));
```
`result.reserve(...)` bleibt (Obergrenze — harmlos bei Sampling).

### 6.5 `experiment_driver.cpp` — Strom 1 verdrahten (`:91-94`)
```cpp
        loop::PermutationLoop pl;
        std::uint32_t const sample_rate =
            (opts_.messreihen_mode == ExperimentDriverOptions::MessreihenMode::FullSampled) ? opts_.sample_rate : 0u;
        out_descriptors = pl.enumerate(cfg, sample_rate, opts_.sample_seed);

        if (opts_.verbose) {
            std::cout << "  Enumerated " << out_descriptors.size() << " permutations";
            if (sample_rate >= 2u) std::cout << " (FullSampled 1:" << sample_rate << ", seed=" << opts_.sample_seed << ")";
            std::cout << ".\n";
        }
        if (sample_rate >= 2u && out_descriptors.empty()) {
            std::cerr << "[Phase 1] WARN: FullSampled 1:" << sample_rate
                      << " ergab 0 Kandidaten (Population zu klein) — kleinere --sample-rate waehlen.\n";
        }
```

### 6.6 `experiment_driver.cpp` — Strom 2 verdrahten (SOTA-Profile `:154`)
- `#include "permutation_loop/permutation_sampling.hpp"` ergänzen (Pfad relativ prüfen; `permutation_loop.hpp`
  wird bereits inkludiert — denselben Include-Stil nutzen).
- In der Profil-Schleife, als **erste** Anweisung im Body:
```cpp
            for (auto const& prof : profiles) {
                if (opts_.messreihen_mode == ExperimentDriverOptions::MessreihenMode::FullSampled &&
                    !loop::sample_keep(prof.id, opts_.sample_rate, opts_.sample_seed)) {
                    continue; // AP-5: deterministisch aus dem Full-Raum verworfen (Identitaet prof_fp unangetastet)
                }
                std::uint64_t prof_fp = std::hash<std::string>{}(prof.id) ^ 0xC0FFEE02ull; // UNVERAENDERT
                ...
```
- Verbose-Mode-String (`:149`) auf 3 Modi erweitern (klein): `Full`→"full", `FullSampled`→"full-sampled", sonst "defined".

### 6.7 `apps/cache_engine_builder/main.cpp` — CLI (in die else-if-Kette `:87-101`, VOR dem `else`-Fehlerzweig)
```cpp
        else if (a.rfind("--mode=", 0) == 0) {
            std::string_view m = a.substr(7);
            using MM = comdare::builder::ExperimentDriverOptions::MessreihenMode;
            if (m == "defined")            opts.messreihen_mode = MM::Defined;
            else if (m == "full")          opts.messreihen_mode = MM::Full;
            else if (m == "full-sampled")  opts.messreihen_mode = MM::FullSampled;
            else { std::cerr << "Unknown --mode: " << m << " (defined|full|full-sampled)\n"; return 1; }
        } else if (a.rfind("--sample-rate=", 0) == 0) {
            std::string_view v = a.substr(14);
            std::uint32_t r{};
            auto [p, ec] = std::from_chars(v.data(), v.data() + v.size(), r);
            if (ec != std::errc{} || p != v.data() + v.size()) { std::cerr << "Bad --sample-rate: " << v << "\n"; return 1; }
            opts.sample_rate = r;
        } else if (a.rfind("--sample-seed=", 0) == 0) {
            std::string_view v = a.substr(14);
            std::uint64_t s{};
            auto [p, ec] = std::from_chars(v.data(), v.data() + v.size(), s);
            if (ec != std::errc{} || p != v.data() + v.size()) { std::cerr << "Bad --sample-seed: " << v << "\n"; return 1; }
            opts.sample_seed = s;
        }
```
- `#include <charconv>` ergänzen.
- `print_usage(std::ostream&)`: 3 Zeilen dokumentieren (`--mode=<defined|full|full-sampled>`,
  `--sample-rate=<N>` „(FullSampled, Default 1000)", `--sample-seed=<N>`).
- Mode-Print (`:108-110`): `messreihen_mode` mit ausgeben (defined/full/full-sampled + bei full-sampled die rate/seed).

### 6.8 NEU: `tests/unit/test_permutation_sampling.cpp` + `comdare_add_test(test_permutation_sampling)` in `tests/unit/CMakeLists.txt`
Reine-Funktions-Tests auf `sample_keep`/`stable_id_hash` (kein Build der Engine nötig):
- **Compile-time-Stabilitaets-Lock (golden):** `static_assert(stable_id_hash("") == 0xCBF29CE484222325ULL);`
  (leere id ⇒ exakt der FNV-Offset-Basis; rock-solid). Zusätzlich 1-2 weitere feste ids mit ihrem literal
  berechneten Hash als `static_assert` (Codex berechnet die Werte selbst und trägt sie ein) — bricht, falls
  jemand auf `std::hash` umstellt.
- **RateOneOrZeroKeepsAll:** `sample_keep(id,0,s)==true` und `sample_keep(id,1,s)==true` für mehrere ids/seeds.
- **Deterministic:** 100 000 synthetische ids (`"perm_"+i`), keep-Menge mit `(1000, seed=7)` sammeln, ZWEITER
  Durchlauf → **identische Menge** (Set-/Count-Gleichheit).
- **RateApprox:** kept-Anteil ≈ 1/1000 über 100 000 (großzügige Toleranz, z.B. `20 < kept < 500`).
- **SeedSensitivity:** keep-Menge(seed=7) ≠ keep-Menge(seed=42), aber jede in sich reproduzierbar.
- (optional) **BothStreamsShareKey:** derselbe id-String liefert in beiden Nutzungen denselben keep-Wert.

## 7. Verifikation (PFLICHT — Codex, Kommandos + literale Ergebnisse)
Build-Dir existiert bereits (MSVC/VS2022). cmake unter `/c/Program Files/CMake/bin/`.
1. **Konfigurieren/Bauen** des neuen Tests + des bestehenden Treiber-Tests (Release):
   `cmake --build <build> --config Release --target test_permutation_sampling test_experiment_driver_v13`
   → Exit-Status literal zeigen.
2. **Neuer Test:** `ctest --test-dir <build> -C Release -R permutation_sampling --output-on-failure`
   — falls ctest den Namen nicht matcht (bekannte Falle), die gebaute `.exe` **direkt** ausführen und die
   `[  PASSED  ]`-Zeile literal zeigen.
3. **Nicht-Regression:** `test_experiment_driver_v13` läuft grün (insb. `MessreihenMode_DefaultIsFull`).
4. **Optional-Smoke (nur wenn schnell):** Builder `--enumerate-only --mode=full-sampled --sample-rate=1000`
   gegen `libs/cache_engine/builder/example_configs` → 2× identische „Enumerated N"-Zahl.
5. **KEIN Commit, KEINE git-Operation.** Wenn ein Build-Target-Name abweicht: den realen Namen berichten.

## 8. Ausgabe an Claude (strukturiert)
(a) geänderte + neue Dateien (Liste, je Datei was); (b) das keep-Prädikat wörtlich + welcher stabile Key
(Bestätigung: KEIN `std::hash`, `d.fingerprint`/`prof_fp` unverändert); (c) ABI-Neutralität + Nicht-Invasivität
(Defined/Full unverändert, MAJOR 4); (d) CLI-Beispielaufruf; (e) Build-/Test-Ergebnisse **literal** (Exit +
`[ PASSED ]`); (f) die berechneten golden `static_assert`-Werte; (g) offene AP-5-Follow-ups (stratifiziert/gewichtet).
