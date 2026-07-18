---
name: feedback_build_matrix_8_docker_distros_full_platform_doctrine
description: "Build-/Plattform-Matrix-Doktrin (User 2026-07-03): 8er-Docker-Distributionsliste INKL. Ubuntu (nicht 7); Docker-Builds auf bare metal UND Talos OS in voller Matrix + mac ARM64/mac x86/RISC-V/Pi5-ARM64 (dort zusätzlich alle Binaries bare metal); x86 unoptimiert=Odroid H4, x86 optimiert=große prod-Runner mit AMD und Intel SEPARAT je HW-/SIMD-Erweiterung"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive (2026-07-03):** Die cache-engine und ALLE Module/Produkte werden in einer **8er-Docker-Distributionsliste inklusive Ubuntu** gebaut (nicht 7 — die 7er-Annahme des CI-Blueprints war falsch).

**Plattform-Matrix:**
1. Docker-Container IMMER auf **bare metal UND Talos OS in voller Matrix** + **mac ARM64, mac x86, RISC-V, Pi5-ARM64**.
2. Auf den exotischen Plattformen (mac ARM64/x86, RISC-V, Pi5) zusätzlich **alle Binaries bare metal**.
3. **x86 ohne Optimierungen → Odroid H4**; **x86 mit Optimierungen → große prod-Runner**, dabei **AMD und Intel SEPARAT für alle HW-Erweiterungen** (ISA/SIMD-Matrix). prod1 = AMD Ryzen 9 9950X3D (`pmc:amd`), prod2 = Intel i9-14900KS (`pmc:intel`).

**Why:** Vollständige Distributionsabdeckung + ISA-Differenzierung (SIMD/ISA-Demo, Runner-BUILD/TEST-Split); unoptimierte x86-Referenz (Odroid H4) als Baseline.

**How to apply:** In CI-Blueprints/Wellenplänen (cache-engine #276/#13/#270b) immer die 8er-Docker-Liste + diese Matrix ansetzen. Relevant für die AUSDRÜCKLICH LETZTE Aufgabe #276 (Voll-Plattform-Matrix als CI-Pflicht) und #13/#270b (3-ISA amd64+arm64). Der ISA-Teil ist toolchain-/infra-gated (Runner-Fleet).

**Herkunft:** konsolidiert aus Infra-Agent-Handover (Cluster `docs/agent-memories-infra/`, cwd `C--WINDOWS-system32`), übernommen 2026-07-08. Verwandt: [[reference_cluster_vlan_tabelle_sni_standard_pattern]], [[feedback_all_projects_dual_remote_github_gitlab]].
