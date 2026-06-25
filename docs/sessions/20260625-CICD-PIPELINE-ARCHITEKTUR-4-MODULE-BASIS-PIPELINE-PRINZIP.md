# CI/CD-Pipeline-Architektur: 4 wiederverwendbare Modul-Pipelines + professionelles Basis-Pipeline-Prinzip

> **Quelle:** User-Direktive 2026-06-25 (wörtlich erfasst). **Rolle:** Implementierungs-Agent (Code) +
> Handoff-Vorbereitung an den **Infrastruktur-Agenten** (universelle GitLab-Runner). **Status:** EPIC, neu,
> priorisiert (s. §9). **Bezug:** ersetzt/erweitert die bisherigen Einzel-`.gitlab-ci.yml` (REV8) zu einem
> kohärenten 4-Modul-Pipeline-System. **Single-Source dieses Prinzips** = dieses Dokument.

---

## 0. Auftrag in einem Satz

Jedes der **vier** COMDARE-Diplomarbeit-Module wird als **eigenständiges, wiederverwendbares Modul mit
eigener Pipeline** ausgebaut; die **Diplomarbeit** (Super-Repo) wird die **Haupt-Pipeline**, die die drei
anderen als Git-Submodule synchron nachzieht; und **jede** dieser Pipelines folgt — wo umsetzbar — dem
**professionellen 10-Stufen-Basis-Pipeline-Prinzip** (§3) über die **ISA+OS-Matrix** der letzten 10 Tage (§4).

---

## 1. Die vier Module und ihre Pipelines

| Modul | Repo | Rolle | Eigene Pipeline | Submodul von |
|---|---|---|---|---|
| **Diplomarbeit (super)** | `probst-Diplomarbeit-cache-engine` | **Haupt-Pipeline** / Mess-Orchestrator (`messung_driver`) | JA (orchestriert + zieht 3 Submodule synchron) | — |
| **Cache-Engine** | `comdare-cache-engine` | Achsen-Bausteine-Bibliothek + Builder | JA (eigenständig baubar+testbar) | super |
| **PRT-ART** | `comdare-prt-art` | Prüfling (Standalone-Lebewesen) | JA (eigenständig, Prod = cache-engine-frei) | super |
| **Diplomarbeit-Overleaf-Text** | `20260931-overleaf-diplomarbeit` | LaTeX-Thesis | JA (LaTeX-Build-Gate) | super |

**Grundsatz „wiederverwendbares Modul":** jede Pipeline ist self-contained (eigene `.gitlab-ci.yml`,
eigene Stages, eigene Artefakte) und über `trigger`/`include` (GitLab CI `include:project`) als Baustein in
die Haupt-Pipeline einbindbar — KEINE Copy-Paste-Duplikation der Stage-Logik. Gemeinsame Stage-Templates
leben in der `Cluster`-Gruppe (`comdare/cluster/ci-templates`, s. Memory `gitlab-setup`) und werden per
`include: { project: 'comdare/cluster/ci-templates', file: '/base-pipeline.yml' }` wiederverwendet.

---

## 2. Abhängigkeitsrichtung (KRITISCH) — und wie sie den Test-Endless-Loop aushebelt

> Das ist der heikelste Punkt. Die Richtung ist **asymmetrisch** je nach Anwendungsfall:

### 2.1 Produktion / Anwendungsfall
- **Cache-Engine → PRT-ART** (Compile-Time, **Metaprogrammierung**): im Mess-/Anwendungsfall **bindet die
  Cache-Engine den PRT-ART als Prüfling ein** — über die `optional_prt_art_impl`-Slots je Achse +
  CMake-Liste `COMDARE_CE_PRUEFLINGE` (`axes/axis_centric_namespaces.hpp:145-172`). Der PRT-ART liefert
  seine per-Achse-Spezialisierungen; die Cache-Engine zieht sie compile-time ein.
- **PRT-ART Produktion = cache-engine-FREI:** der PRT-ART-Produktionscode ist ein **eigenständiger
  Prüfling** und hängt NICHT von der Cache-Engine ab.

### 2.2 Test
- **PRT-ART → Cache-Engine (NUR Test):** dem PRT-ART ist es **ausschließlich zum Testen** gestattet, die
  Cache-Engine als Abhängigkeit zu laden (um seine Achsen-Organe gegen das Framework zu prüfen).
- **Cache-Engine → PRT-ART (Test-Kandidat):** die Cache-Engine **darf den PRT-ART als Test-Kandidaten
  laden** (um den Prüfling-Lade-Pfad / die Drei-Stufen-Prüfung zu testen) — UND verwendet ihn in
  Produktions-Abhängigkeit (§2.1).

### 2.3 Der Endless-Loop und sein Bruch
Wären **beide** Richtungen Produktions-Abhängigkeiten, entstünde ein zirkulärer Build (Endless-Loop:
cache-engine braucht prt-art braucht cache-engine …). **Aufgehebelt** wird er, weil:
1. Die **Produktions**-Kante ist **einseitig**: `cache-engine → prt-art` (Meta-Programmierung). Der
   PRT-ART-Prod-Build hat **keine** cache-engine-Kante → kein Zyklus im Produktions-Graph.
2. Die **Test**-Kanten (`prt-art → cache-engine`, `cache-engine → prt-art`) sind **isoliert in der
   Test-Stage** und nutzen **bereits gebaute Artefakte** (kein Bau-Zyklus): die cache-engine-Test-Stage
   lädt das prt-art-**Artefakt** als Kandidat; die prt-art-Test-Stage lädt das cache-engine-**Artefakt**.
3. Konkret in GitLab CI: `needs:`-Artefakt-Konsum statt Quell-Submodul-Rekursion in der Test-Stage;
   `GIT_SUBMODULE_STRATEGY: none` im Prod-Build des jeweils anderen.

```
 PRODUKTION (einseitig, kein Zyklus):     TEST (isoliert, Artefakt-basiert, kein Bau-Zyklus):
   cache-engine ──embed(meta)──▶ prt-art    cache-engine.test ──lädt Artefakt──▶ prt-art (Kandidat)
   prt-art(prod) = standalone                prt-art.test     ──lädt Artefakt──▶ cache-engine (Framework)
```

**Akzeptanz §2:** prt-art baut+testet **ohne** cache-engine-Quell-Submodul im Prod-Pfad; die zirkuläre
Test-Kante läuft nur gegen vorgebaute Artefakte; `cache-engine` embeddet prt-art real per `COMDARE_CE_PRUEFLINGE`.

---

## 3. Das professionelle Basis-Pipeline-Prinzip (10 Stufen) — User-Standard

> „Für mich als professionellen Entwickler besteht eine Basis-Pipeline IMMER, wenn umsetzbar, mindestens aus
> diesen Stufen." Je Modul wird umgesetzt, **was anwendbar ist** (z.B. Thesis-Text hat kein asan).

| # | Stufe | Zweck | Werkzeuge (web-recherchiert + ergänzt) |
|---|---|---|---|
| **1** | **lint** | Format + statische Hygiene + Secrets | `clang-format`, `clang-tidy`, `cppcheck` (0-FP-Ziel), `cpplint`, **`gitleaks`** (Secrets), include-what-you-use (`iwyu`)/`lwyu`, `codespell` (Tippfehler), `shellcheck` (sh), `yamllint`+`markdownlint`, `cmake-lint`/`cmake-format`, **REUSE/SPDX**-Lizenzcheck, **`semgrep`**/GitLab-SAST, `commitlint` (Conventional Commits). Für Thesis-Text: **`chktex`/`lacheck`** (LaTeX-Lint). Bündel-Option: `cpp-linter`. |
| **2** | **build** | Kompilieren auf **allen ISA+OS-Rekombinationen** (§4) | CMake-Preset je Target; Matrix-Jobs `[baremetal, <isa>, <os>]`; C++23. |
| **3** | **sanitize** | **asan + tsan** (+ ubsan empfohlen) — **je ISA+OS separat einzeln einkompiliert und getestet** | je Variante eigener Build (`-fsanitize=address` / `=thread` / `=undefined`); KEINE gemischten Builds; je ISA+OS eine eigene Sanitizer-Binary + Lauf. |
| **4** | **contract fixtures + bullshit-config-durability** | Vertrags-Tests (ABI-Contract, `std::map`-Konformitäts-Gatter) + **Robustheit gegen Müll-Configs** | Contract-Fixtures (z.B. `test_abi_interface`, ABI-v1-PODs); fuzz-/property-basierte XML-Profil-Robustheit (kaputte/unsinnige `comdare_thesis_profile`-Configs dürfen NICHT crashen → ehrlicher Fehler). |
| **5** | **integration tests** | storage/db + **e2e** | Storage-/DB-Integration (CNPG/MinIO/Redis-Anbindung wo relevant); E2E der Mess-Kette `messung_driver → .bin → csv → tex → pdf`. |
| **6** | **chaos engineering** | gezielte Störung + Selbstheilung | **Diplomarbeit-spezifisch:** Unterbrechung bei **Erkennung von starkem Mess-Drift** + **Wiederholung der Messung** (Drift-Detektor → abort+rerun; vgl. Resume #139 + Quality-Flag #165). Allgemein: Runner-Kill/Netz-Partition-Resilienz. |
| **7** | **manifest + prebackup** | Reproduzierbarkeit + Datenschutz | Build-/Mess-**Manifest** (Toolchain, Commit-SHAs aller Submodule, ISA/OS, Profil-Hash) + **Prebackup** alter Messungen UND Einstellungen VOR Überschreiben (Direktive „Messdaten NIE löschen" → additive/versioniert). |
| **8** | **K8s-Migration als Produktions-Pod** | Containerisierung | bei Migration: Mess-/Build-Last als **Produktions-Pod** im prod-Cluster (KubeVirt/Talos-Runner-VMs, s. §4) statt nur Bare-Metal-Shell. |
| **9** | **deploy staging** | Vorstufe vor Produktion | Staging-Deploy (Artefakte/Images → Staging-Registry/-Namespace) vor Prod-Promotion. |
| **10** | **smoke / canary** | finale Absicherung | **canary-loggate** (Log-Gate auf Fehlerrate) → **canary-promote**; später (wenn vorhanden) **e2e-ui**. |

**Web-Recherche-Verdikt (Stufe 1):** der Standard-C++-Kasten = clang-format/clang-tidy/cppcheck/cpplint +
gitleaks + IWYU; sinnvolle Erweiterungen darüber hinaus = codespell, shellcheck, yamllint/markdownlint,
cmake-lint, REUSE/SPDX, semgrep/CodeQL, SBOM (`syft`) + Vuln-Scan (`grype`/`trivy`), commitlint. Quellen §10.

---

## 4. ISA+OS-Matrix (letzten 10 Tage geplant) + Infra-Handoff

Der **gesamte Diplomarbeit-Test** muss auf dem Niveau der **Plattformen, ISA und OS** laufen, die in den
letzten 10 Tagen geplant+dokumentiert wurden. **Ist-Stand der Runner** (GitLab, admin-Sicht 2026-06-25):

| Runner | Beschreibung | ISA | OS | Status |
|---|---|---|---|---|
| prod-baremetal-prod1 (id 16) | AMD Ryzen 9 9950X3D | x86-64 (Zen5) | Linux (Ubuntu 6.8) | **online** |
| prod-baremetal-prod2 (id 17) | Intel i9-14900KS | x86-64 (Hybrid) | Linux | **online** |
| node5-macintel-x86_64 (id 2) | Mac Intel | x86-64 | macOS | stale |
| node6-macarm-arm64 (id 3) | Mac ARM | AArch64 | macOS | stale |
| node7-rpi5-arm64 (id 4) | Raspberry Pi 5 | AArch64 | Linux | stale |
| node8-visionfive-riscv64 (id 5) | VisionFive | RISC-V 64 | Linux | stale |
| Windows-Runner-VMs (KubeVirt/Talos) | je AMD+Intel pro prod-Host | x86-64 | Windows | geplant (Lizenzen im Vault) |

**Ziel-Matrix (Soll, aus Thesis-ISA-Achse T12 x86-64/AArch64/Power/RISC-V + #163 Hybrid+Sapphire Rapids):**
`{x86-64-AMD, x86-64-Intel-Hybrid, x86-64-SapphireRapids, AArch64, RISC-V, (Power optional)} × {Linux, Windows, macOS}`.

> ⚠️ **INFRA-HANDOFF (Pflicht):** Der Infrastruktur-Agent muss die zusätzlichen GitLab-Runner **universell**
> einrichten — die stale ARM/RISC-V/macOS-Runner reaktivieren, die Windows-KubeVirt-Runner provisionieren,
> und je Runner die Toolchain (CMake/Ninja/Compiler/Sanitizer/perf-Rechte wie CE-DL2) + Tags
> `[baremetal,<isa>,<os>]` setzen. **Ohne universelle Runner ist die Matrix nicht fahrbar.** Dieses Doc +
> §4-Tabelle = die Handoff-Grundlage. (Bezug: cluster-Sessions der letzten 10 Tage; Runner-Cache MinIO
> `gitlab-runner-cache` bereits aktiv.)

---

## 5. Pro-Modul-Pipeline-Spezifikation (was jede der 4 Pipelines konkret braucht)

### 5.1 Cache-Engine (`comdare-cache-engine`)
- **Ordnungs-Refactoring (umfassend, GROSS):** die Repo-Struktur aufräumen (libs/apps/tests/modules/ext
  konsolidieren; tote `modules/*`-Spiegel; Namespace-/Datei-Ordnung) — Voraussetzung für eine wartbare
  Pipeline. **Verzahnt mit #179 (Wartbarkeits-Sweep).**
- **Tests:** Unit (GTest) + Contract (ABI) + die Drei-Stufen-Prüfung. **Darf PRT-ART als Test-Kandidat
  laden** (Prüfling-Slot) und nutzt ihn in Prod-Abhängigkeit (§2).
- Stages: lint → build(Matrix) → sanitize(asan/tsan je Variante) → contract+config-durability → integration.

### 5.2 PRT-ART (`comdare-prt-art`)
- **Standalone-Prod-Build** (KEINE cache-engine-Quelle im Prod-Pfad).
- **Test-Stage** darf cache-engine-**Artefakt** laden (test-only).
- Stages: lint → build(Matrix) → sanitize → contract → (test gegen cache-engine-Artefakt).

### 5.3 Diplomarbeit-Overleaf-Text (`20260931-overleaf-diplomarbeit`)
- **LaTeX-Build-Gate (§7):** `latexmk` baut DE+EN; **0 Fehler, ≤1 bekannte Warning**, sonst „kaputt".
- Lint: `chktex`/`lacheck` + `.blg`/`Repeated-entry`-Check (Lehre aus Thesis-Übergabe 3).
- Stages: lint(chktex) → build(latexmk DE+EN) → gate(0 err, ≤1 warn).

### 5.4 Diplomarbeit / Super (Haupt-Pipeline)
- **Zieht PRT-ART + Cache-Engine + Thesis-Text als Submodule synchron** (`GIT_SUBMODULE_STRATEGY: recursive`,
  relative air-gap-URLs — bereits in `.gitmodules`).
- **Orchestriert** die 3 Modul-Pipelines (`trigger`/`include`) + die End-zu-End-Mess-Kette.
- **Pipeline-Test (§6):** minimaler Permutations-Durchlauf.

---

## 6. Diplomarbeit-Pipeline-Test (minimaler Permutations-Durchlauf)

Die Haupt-Pipeline wird getestet, indem eine **einfache Achsen-Permutation von MAXIMAL 1–2 Varianten je
Achse** gewählt und durchlaufen wird (Smoke-Permutation): ein Profil-XML mit ≤2 Konkretisierungen je der
19 Achsen → der `messung_driver` läuft die Mess-Kette `bin → csv → tex → pdf` einmal durch. Beleg = grüne
E2E ohne Voll-Permutationsraum (10^14). Vorlage: `m3v2_smoke.profile.xml` (bereits ≤3 Reihen). **Ziel:** der
Smoke beweist die GESAMTE Kette real, ohne die Mess-Last zu fahren.

---

## 7. Thesis-Text-Build-Gate (hart)

Der Overleaf-Text **baut einfach** und darf **keine Fehler** und **maximal eine Warning** auslösen, die der
User kennt — sonst gilt das Dokument als **unordentlich und kaputt**. Umsetzung: latexmk-Job parst `.log`
(`Error`/`Fatal`) + zählt Warnings; **fail** bei ≥1 Fehler ODER ≥2 Warnings; die EINE bekannte Warning wird
als allowlist-Eintrag dokumentiert (aktuell: die `\headheight`-/Build-SIMD-Kurzmarke, s. Übergabe 3 `afc677c`).
Zusätzlich `.blg`-`Repeated-entry`-Check (BibTeX crasht nicht, `.log` bleibt trügerisch sauber).

---

## 8. Chaos-Engineering für die Messung (Stufe 6, Diplomarbeit-Kern)

Während des Mess-Laufs: ein **Mess-Drift-Detektor** überwacht die Streuung (Median/Perzentile, vgl. ch3
§3.x Statistik-Triade). Bei **starkem Drift** (z.B. Median-Sprung > Schwelle, hohe Varianz, thermal/Noise) →
**Unterbrechung** des betroffenen Tiers + **Wiederholung der Messung** (Resume-Mechanik #139, Quality-Flag
#165, quiesziertes OS AP-M1). So bleibt die Messung wissenschaftlich belastbar statt driftverseucht.

---

## 9. Priorisierung + Einreihung in die TODOs

**Einordnung:** Dies ist ein **EPIC (P1)**, das die langfristige „Diplomarbeit = Haupt-Pipeline"-Vision
trägt. Es ist **teilweise gate-frei** (die Basis-Pipelines lint+build+sanitize+contract je Modul können
sofort gebaut werden) und **teilweise infra-gated** (ISA+OS-Matrix-Runner, K8s-Prod-Pod, deploy-staging,
canary). **Sinnvolle Priorität:**
1. **Parallel zum thesis-kritischen Mess-Lauf** (#156/#162, jetzt entsperrt) — die Basis-Pipelines stützen
   dessen Reproduzierbarkeit (Manifest/Prebackup Stufe 7 + Chaos Stufe 6 sind sogar Mess-Voraussetzung).
2. **Reihenfolge der Umsetzung (gate-frei zuerst):**
   - (P1a) Pro-Modul **lint + build(lokal/2-ISA) + contract** als wiederverwendbare Templates (`ci-templates`).
   - (P1b) **sanitize** (asan/tsan) je vorhandenem Runner.
   - (P1c) **Thesis-Text-Gate** (§7) — klein, hoher Wert.
   - (P1d) **Super-Smoke-Permutation** (§6).
   - (P1e) **Infra-Handoff** → universelle ISA+OS-Matrix-Runner (§4) → dann Matrix-build/sanitize.
   - (P1f) chaos/manifest/prebackup → K8s-Prod-Pod → deploy-staging → canary (nach Infra).
3. **Verhältnis zu bestehenden TODOs:** baut auf der REV8-CI auf; verzahnt mit #179 (cache-engine
   Ordnungs-Refactoring), #156/#162 (Mess-Lauf), CE-DL-Infra-Items. **Dieses Doc = Referenz; der TODO-
   Listeneintrag verweist hierauf.**

---

## 10. Web-Recherche-Quellen (Stufe-1-Werkzeuge)

- [Clang-Tidy — Extra Clang Tools](https://clang.llvm.org/extra/clang-tidy/)
- [Use the Tools Available · C++ Best Practices](https://lefticus.gitbooks.io/cpp-best-practices/content/02-Use_the_Tools_Available.html)
- [awesome-static-analysis (curated linters/SAST)](https://github.com/VahidN/awesome-static-analysis)
- [Static checks with CMake/CDash (iwyu, clang-tidy, lwyu, cpplint, cppcheck) — Kitware](https://www.kitware.com/static-checks-with-cmake-cdash-iwyu-clang-tidy-lwyu-cpplint-and-cppcheck/)
- [cpp-linter (clang-format/clang-tidy CI bundle)](https://github.com/cpp-linter)
- [Setting up linters in GitLab CI for C++ — L. Cimon](https://medium.com/@Lucas_C/setting-up-linters-in-gitlab-ci-for-c-and-groovy-jenkins-code-7a1eb502fdb6)

---

## 11. Offene Fragen an den User (vor Voll-Umsetzung zu klären)
1. **Deploy-Ziel:** Was ist das „Produktions"-Artefakt der Diplomarbeit-Pipeline im Deploy/Canary-Sinn —
   das Thesis-PDF? Die „beste Binary" (#172.1, beste-Permutation-Auslieferung)? Beides?
2. **macOS-Runner:** sind die stale Mac-Runner (node5/node6) noch physisch verfügbar oder durch
   KubeVirt/Cloud zu ersetzen? (Beeinflusst die OS-Matrix-Vollständigkeit.)
3. **Power-ISA:** in der Ziel-Matrix führen (Thesis T12 nennt Power) oder als „dokumentiert, nicht
   gebaut" (kein Runner)?
4. **canary-promote-Kriterium:** welche Metrik/Schwelle gilt als „promote-fähig" (Mess-Stabilität? PDF-Gate?)?
