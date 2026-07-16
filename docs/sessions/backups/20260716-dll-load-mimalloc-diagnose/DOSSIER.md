# Diagnose: DLL-Load-Lücke measured=0 (Vendor-Allokator-Symbole) — Design-Entscheidung (2026-07-16 Nacht)

> Read-only (Opus, `nm`/`git log`). KEINE Datei geändert, kein Fix (echte Plugin-Architektur-Wahl → User-GO). Belege datei:zeile + `nm`-Zitate.

## (A) Root-Cause
Die per Laufzeit-`make_gpp_compile_fn` (`build_orchestrator.hpp:466-489`, rsp = NUR `-std=c++23 -O2 -fPIC -shared -fno-gnu-unique` + defines + includes + source + `-o`, **keine `-l`/Archiv-Zeile**) gebauten Tier-DLLs referenzieren `mi_malloc_aligned`/`mi_free` aus dem mimalloc-Wrapper (`axis_06_allocator_mimalloc.hpp:128/:150`), hart fixiert in den 7 SOTA-Referenz-Kompositionen (`compositions/art_reference.hpp:76` `using allocator = MimallocAllocator;`, analog hot/masstree/surf/start/wormhole/prt_art). Der Host (`02_messung_driver/CMakeLists.txt`, kein `ENABLE_EXPORTS`/`-rdynamic`; Grep=0 im ganzen Baum) exportiert 0 `mi_*`. `AnatomyModuleLoader::load` `dlopen(RTLD_NOW|RTLD_LOCAL)` (`anatomy_module_loader.cpp:40`) erzwingt sofortige Auflösung → `status_load_failed` (`:110-111`).

## (B) Ist-vs-Working-Delta (KEIN Config-Parity)
Zwei DLL-Bau-Mechanismen:
- **WORKING = CMake-In-Process** (`anatomy_codegen.cmake:98` `add_library(SHARED)`, PIC): erbt directory-scope `link_libraries(comdare::vendor_mimalloc)` (`CE/CMakeLists.txt:576-578`) → **self-linkt mimalloc IN die .so**. `nm -D` (16 Module in build-go2/+build-perms-fix/): `mi_malloc_aligned` = **`T` (DEFINIERT)** → dlopen gelingt. std-Allokator-Module haben keine Vendor-Referenz → laden auch.
- **FAILING = Laufzeit-Treiber** (`make_gpp_compile_fn`, injiziert `profile_run_facade.cpp:154/:330`): linkt nichts → `mi_malloc_aligned` = **`U` (undefiniert)** → dlopen scheitert.
Fazit: **kein fehlendes Flag im selben Target** (kein F12i-Fall). Der CI-Mess-Job (`measure:smoke/golden-320`) baut denselben link-losen Pfad → hätte dasselbe Problem. Das „Host-Export"-Modell existiert im Repo NIE. Einziger funktionierender Präzedenzfall = **Self-Link (Option B)**. `measurement/` ist leer (frühere Mess-CSVs = CMake-Test-Artefakte, nicht dlopen-Treiber).

## (C) Optionen (User-GO morgens)
- **Option A — Host exportiert Symbole:** `set_target_properties(messung_driver PROPERTIES ENABLE_EXPORTS ON)` + whole-archive-Zwangslink mimalloc/jemalloc/snmalloc. *Contra:* EINE Allokator-Instanz prozessweit → bricht RAII-Destroy-Vertrag (`loader.hpp:72-75`, Destroy muss im .so-Heap laufen) + **verfälscht die Allokator-Achsen-Messung** (alle Tiers teilen den Host-Allokator statt des gewählten — mess-semantisch heikel, vgl. Fairness).
- **Option B — DLL self-linkt Allokator (EMPFEHLUNG):** `make_gpp_compile_fn` (`build_orchestrator.hpp:466-489`) um die Vendor-Archiv-Pfade auf der Link-Zeile erweitern; Pfade als compile-def gebacken (Muster `profile_facade/CMakeLists.txt:137-138` `COMDARE_FACADE_PERM_INCLUDES`, eingelesen `profile_run_facade.cpp:57-63`), für `libcomdare_vendor_mimalloc.a` (+ jemalloc; snmalloc header-only mit `-mcx16`). *Pro:* pro-DLL eigene Allokator-Instanz = korrekt für Destroy-Vertrag UND faire Allokator-Achsen-Messung; repliziert byte-genau den funktionierenden CMake-Pfad. *Contra:* echte Erweiterung der Kern-Compile-Fn (betrifft ALLE Messungen), berührt ce libs/, braucht den vollen enabled-Allokator-Satz + snmalloc-Belange; mehrstündig zu verifizieren (Treiber-Build + perm-Compile + dlopen-Lauf).

**Empfehlung: Option B** — wahrt Destroy-Vertrag + Mess-Semantik, repliziert den `nm`-belegt funktionierenden CMake-Pfad. Beide = bewusste Plugin-Architektur-/Mess-Modell-Wahl → GO nötig.

## (D) Zero-Cost-Morgen-Check (bestätigt die Lokalisierung, kein Fix)
std-Allokator-DLLs laden bereits (`nm`-belegt: f15/anatomy_multi-std-Module ohne undefinierte Vendor-Referenz). Ein `m3v2_study`-Lauf mit **größerem Cap** (statt cap=1) sollte auf den 320 std-Basis-Binaries schon jetzt `measured>0` liefern; nur die 7 mimalloc-SOTA-`base_tiers` (bei cap=1 zuerst emittiert) scheitern. → Fehler = spezifisch Vendor-Allokator-Kompositionen; Option B schließt genau diese Lücke. golden==320/cf22/Mojibake/TABU unberührt (nur-lesende Session).
