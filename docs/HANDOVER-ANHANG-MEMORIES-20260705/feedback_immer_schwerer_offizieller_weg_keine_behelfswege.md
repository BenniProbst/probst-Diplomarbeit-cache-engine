---
name: feedback_immer_schwerer_offizieller_weg_keine_behelfswege
description: "IMMER den schweren offiziellen Weg (CMake/ctest, offizielle Prerequisites) — NIE illegale parallele Behelfswege (Scratch-Skripte, out-of-OneDrive-Staging); retry bis es geht"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 78cf67f8-571e-4fcd-a907-1556dbc5be72
---

**IMMER den schweren offiziellen Weg verwenden — NIE illegale parallele Behelfswege bauen; „versuche es, bis es geht".** (User 2026-06-20)

**Why:** Parallele Behelfswege (eigene Scratch-Compile-`.ps1`-Skripte neben CMake, out-of-OneDrive-Build-Staging, manuelle `cl @rsp`-Aufrufe) erzeugen einen zweiten, nicht-offiziellen Pfad, der vom echten Build divergiert, nicht reproduzierbar im offiziellen Sinn ist und die eigentliche Schwäche (z.B. langsamer/timeoutender CMake-Build, OneDrive-C1083-Lock) nur umgeht statt löst. Das ist genau die „einfachste statt sauberste Weg"-Falle ([[feedback_infra_cleanest_not_easiest]]).

**How to apply:**
- Verifikations-/Pilot-Tests **immer in CMake/ctest registrieren** (offizielle `add_executable`+`add_test`), NIE via gitignored Scratch-Compile-Skript bauen — auch wenn der schwere Build lange dauert/timeoutet: **retry, bis es geht** (Hintergrund-Build mit Geduld, Einzel-Target statt Voll-Suite, längerer Timeout — aber der OFFIZIELLE CMake-Pfad).
- Build-Probleme (OneDrive-C1083-Sync-Lock) durch **Retry am offiziellen Pfad** lösen (der C1083-Retry ist drin), NICHT durch einen out-of-OneDrive-Behelfs-Build-Pfad.
- Offizielle Offline-Prerequisite-Mechanik (Boost.MP11-Muster: `cmake/*_setup.cmake` + `prerequisites/` Auto-Extract + FetchContent) IST der offizielle Weg — die ist erlaubt/erwünscht (kein Behelfsweg).
- Anlass: P5-PMC-Naht-Smoke `m3v2_pmc_smoke` wurde zuerst per Scratch-Skript `build_m3v2_pmc_smoke.ps1` gebaut (Behelfsweg) + P-onedrive-Staging geplant (Behelfsweg) → beides verworfen, offizielle CMake/ctest-Registrierung erzwingen.
