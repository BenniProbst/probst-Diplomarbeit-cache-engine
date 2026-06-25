# User-Entscheidungen 2026-06-25 — 13 Antworten (CI/CD- + Mess-Architektur): Klartext-Anweisung + Formulierung + Konsolidierung

> Erfasst die Antworten des Users auf die 13 offenen Entscheidungspunkte (s. Vorgänger-Doc
> `20260625-CICD-PIPELINE-ARCHITEKTUR-4-MODULE-BASIS-PIPELINE-PRINZIP.md` §11 + Chat).
> **TEIL A** = Klartext (verbindliche TODO-Anweisungs-Erweiterung, wörtlich-treu). **TEIL B** = meine
> Formulierung + konkrete Aktionen. **TEIL C** = konsolidierte Session-TODOs (Antwort 11). **TEIL D** =
> web-recherchierte Gates je Pipeline-Stufe (Antwort 4). **Verbindlich.**

---

## TEIL A — Klartext (verbindliche Anweisungs-Erweiterung, wörtlich-treu)

**A1 — Deploy-Ziel / Artefakte.** Das Deployment der Diplomarbeit enthält nicht nur das Einsetzen einer
Binary bzw. Docker-Container bzw. Pod, um Messungen durchzuführen — diese Messung erzeugt ZUR Pipeline
(thematisch ergänzen) noch **ZUSÄTZLICHE Pipelinestufen**: (1) das **Zurückschreiben der Messergebnisse an
ein (NAS-)Ziel**; (2) je nach Konfiguration der Cache-Engine-Config auch das **Zurückschreiben mindestens
EINER Tier-Binary**, die durch Messung und Permutation als **am schnellsten für ein Speicherinterface als
Gesamt-Algorithmus-Permutation** (3 Mess-Schichten: **SOTA, PRT-ART, kombiniert**) ermittelt wurde — um
wiederum **in einem anderen System als perfekte Plattform-Binary-Release** zu arbeiten. Die Cache-Engine ist
**konzeptionell von UltiHash abgeleitet**, welches in erster Linie eine **Datenbank** ist, die dieselbe
Mess-Optimierung durchführt, um für ihre Gattung die **kleinste Gesamt-Speichergröße** zu finden. Wir zeigen
also hier das **Konzept von UltiHash, OHNE den Code darzulegen**. Ein weiteres Export-Dokument ist die
**Diplomarbeit mit den LaTeX-eingearbeiteten Messwerten und Tabellen** selbst, die ebenfalls als
Pipeline-Schritt als **Kompile gegen den Messwert-Export** durchlaufen muss und ihrerseits die Diplomarbeit
als **PDF** exportiert. → Die Artefakte sind **viele** — mehr als nur Thesis-PDF und ein paar Binaries.

**A2 — macOS-Runner + zusätzliche Matrix-Dimension.** Die macOS-Runner sind **beide physisch verfügbar aber
verkonfiguriert**; der Infra-Agent kümmert sich in den nächsten Tagen darum. Was dem Infra-Agenten noch als
Handout übergeben werden muss: wir haben vor einigen Tagen **Windows-Server-2022-Schlüssel gekauft** und
müssen diese **zusätzlich als bare-metal-Ubuntu-KVM** mit einrichten, um wirklich alles abzudecken.
Weiterhin muss **jede Kombination ISA+OS zusätzlich eine weitere Ebene von Kombinationen mit
bare-metal / docker / k8s** unterstützen, auch im Falle von K8s selbst.

**A3 — Power / AArch64.** Wir erhalten **Power und AArch64 über das ZIH**, was wir infrastruktur-technisch
**zum Schluss** anschließen. Ja, das ist aktuell.

**A4 — Mess-Zuverlässigkeits-Gate.** **Mehr als 5 % Messabweichung bei Wiederholung sind unzuverlässig**; in
einem solchen Fall müssen wir bei **3 aufeinanderfolgenden 2-Phase-Messungen alle 3 nochmal wiederholen** und
das Ereignis **als Warnung loggen**. Ansonsten sind die Gates in der letzten Beschreibung bereits beschrieben;
bitte im Web nach sonst sinnvollen Gates für **jede einzelne Pipeline-Eigenschaft** recherchieren.

**A5 — Infra-Handoff.** Ja — ich (User) leite dem Infra-Agenten das TODO weiter und er merkt es sich, bis er
Zeit hat, es zu bearbeiten.

**A6 — CI/CD-Stellenwert.** Die CI/CD ist eigentlich **das Fundament**, auf dem wir ein ergiebiges Feedback
bei der Entwicklung aufbauen sollten. Der **derzeitige Code übersteht noch keine Wartbarkeit und ist nur
lokal getestet**. Alles sehr gründlich notieren.

**A7 — Reihenfolge.** Wir machen **erst die Pipeline klar und dann den Messlauf voll treiben**.

**A8 — #178 / ch6.** Der Text-Agent scheint das **schon gemacht** zu haben — prüfe das; wenn nicht, ziehe es
nach, **sofern der Diplomarbeit-Text nicht NEUER als der Code ist** und du damit eher den **Code reparieren**
solltest, weil die **Diplomarbeit den Soll-Zustand beschreibt**. Setze das um, aber du bist der
Implementierungs-Agent und kannst es besser gerne **an den Text-Agenten als Handoff per Dokument** übergeben;
ich reihe dann den Pfad in den Text-Agenten als TODO ein.

**A9 — PMC-Auto-Adaption.** Das **Intel-PMC und perf ist erst seit heute verfügbar** und muss laut der
letzten 20 Sessions **noch von dir eingerichtet** werden, sodass **Messwerte und Tabellen sich automatisch an
das Vorhandensein verfügbarer Messtools anpassen** — die Messung wird **immer maximal genau, so genau wie die
ISA+OS+Umgebung es anbietet**.

**A10 — #182 Lücke 1.** Das ist **definitiv ein schwerwiegender Architekturfehler** und es ist **deine
Aufgabe, den korrekten Zustand als Diff zu finden und umzusetzen**. Es gibt dazu einen **Experiment-B+-Baum
als zentrale Steuerung**.

**A11 — Konsolidierung.** Die beiden wichtigsten Aufgaben stehen weiter oben (CI/CD-Fundament + Arch-Fix);
ansonsten die **letzte TODO-Liste zusammensuchen und über den gesamten Inhalt dieser Session konsolidieren**.

**A12 — GitLab-Auth.** Es ist noch Aufgabe des Infra-Agenten, eine **.1-SNI mit gitlab.comdare.de auf VLAN 10**
zu installieren, aber **DNS und HTTPS reicht erstmal**. Eine **VIP auf VLAN 10 wird es NICHT geben**.

**A13 — Secret-Rotation.** Bitte den Infra-Agenten **per Handoff fragen, ob er schon rotiert hat und wie weit**
er damit ist.

---

## TEIL B — Meine Formulierung + konkrete Aktionen

| # | Was es für mich bedeutet | Aktion |
|---|---|---|
| **B1** | Die Deploy/Release-Stufen (9/10) der Diplomarbeit-Pipeline haben **mehrere Artefakt-Klassen**: (a) Mess-CSV/Binär-Export → **NAS-Ziel** (UNC/NFS, Direktive „Messdaten nie löschen" → additiv/versioniert); (b) **beste Tier-Binary** je Speicherinterface (Sieger der SOTA∪PRT-ART∪kombiniert-Permutation) als **eigenständige Plattform-Binary-Release** (= Versprechen #172.1 „beste Binary"); (c) **Thesis-PDF**, kompiliert GEGEN den Messwert-Export. Framing: wir demonstrieren das **UltiHash-Optimierungs-Konzept** (Mess-getriebene Suche nach dem Gattungs-Optimum — dort kleinste Speichergröße, hier schnellste Cache-Permutation) **ohne UltiHash-Code**. | CI/CD-Doc §1/§5.4 + Deploy-Stufen erweitern; „beste-Binary"-Release an #172.1 koppeln; NAS-Writeback als eigene Stufe (Manifest+Prebackup, Stufe 7). |
| **B2** | Die Matrix ist **3-dimensional: ISA × OS × {bare-metal, docker, k8s}** (Laufzeit-Umgebung), je Zelle ein Runner-Profil. Windows-Abdeckung via **Windows-Server-2022 als Gast in bare-metal-Ubuntu-KVM**. macOS-Runner kommen (Infra, nächste Tage). | CI/CD-Doc §4 zur 3D-Matrix erweitern; Infra-Handoff (Win2022-KVM + 3 Umgebungs-Ebenen). |
| **B3** | **Power + AArch64** kommen über **ZIH** (zuletzt angeschlossen) → in der Ziel-Matrix als „via ZIH, am Schluss" führen (nicht „nur dokumentiert"). | §4-Matrix: Power+AArch64 = ZIH-gebunden. |
| **B4** | Chaos/Quality-Gate (Stufe 6/10) konkret: **Wdh-Abweichung > 5 % ⇒ unzuverlässig ⇒ 3 aufeinanderfolgende 2-Phase-Messungen alle 3 wiederholen + Warnung loggen.** Zusätzlich web-recherchierte Gates je Stufe (Teil D). | §3/§8 + Teil D in CI/CD-Doc folden. |
| **B5** | Infra-Handoff schreiben (User leitet weiter, Agent merkt es sich). | Eigenes Doc `…-HANDOFF-infra-universelle-runner.md` (s. #189). |
| **B6** | **CI/CD = oberste Priorität (Fundament).** Der Code ist **noch nicht wartbar + nur lokal getestet** → CI/CD ZUERST (vor Messlauf), liefert das Entwicklungs-Feedback. | #186 auf **P0-Fundament** hochpriorisieren; #179 (Wartbarkeit) verzahnen. |
| **B7** | Reihenfolge fix: **Pipeline klar → DANN Messlauf voll treiben.** | #186 vor #162. |
| **B8** | **Diplomarbeit-Text = Soll.** Wenn ch6 (06_evaluation_methodology) den Stufe→Reihe-Mapping schon ch4-§4.8-konform hat → nur **Code reparieren** (#178-Strukturfix). Wenn Text älter/inkonsistent → trotzdem Code an ch4 §4.8 ziehen + **Text-Agent-Handoff** für die ch6-Konsistenz schreiben (User reiht ein). | ch6 prüfen → #178 Code-Fix + ggf. Text-Handoff (#190). |
| **B9** | **PMC-Auto-Adaption (NEU, von mir):** Capability-Detection je ISA+OS+Umgebung (welche Counter existieren: L1/L2/L3/dTLB/branch/energy …) → Messung+Tabellen passen sich AUTOMATISCH an = „maximal genau, so genau wie verfügbar". L3=0-Befund (AMD-LL-Mapping) ist Teil davon. | Neue Aufgabe #187. |
| **B10** | **#182 Lücke 1 = schwerwiegender Architekturfehler, ZU FIXEN** (nicht nur dokumentiert): T0-Such-Metrik muss über die Speicher-Achsen statt den `search_organ_`-Monolith. Korrekten Zustand als **Diff** finden; zentrale Steuerung = **Experiment-B+-Baum** (PermutationLoop, KF-9/#59). Mess-Semantik-Wechsel ist hier **freigegeben**. | Neue Aufgabe #188 (löst die in #182 zurückgestellte Lücke 1). |
| **B11** | Konsolidierung = Teil C. | s.u. |
| **B12** | **DNS+HTTPS reicht** → mein HTTPS-OAuth-Push-Recipe bleibt. **Keine V10-VIP**; das frühere „SSH-Deploy-Key/CE-DL6b" ist ersetzt durch **.1-SNI gitlab.comdare.de auf V10** (Infra-Aufgabe). | Push-Weg unverändert; Memory/Handoff korrigieren (CE-DL6b → .1-SNI). |
| **B13** | Infra nach Rotations-Status fragen. | In Infra-Handoff (#189). |

---

## TEIL C — Konsolidierte Session-TODOs (Antwort 11) — priorisiert

> Zusammengeführt aus der laufenden TODO-Liste (#1–#186) + allen Beschlüssen DIESER Session. **Erledigt
> diese Session:** #176/#177 (I1), #180/#181 (IDE/Baum), #182 (gate-freier §3.3-Doku-Scope), #183 (AP-CE1),
> #186 dokumentiert. **Neue Reihenfolge (A6/A7: Fundament zuerst):**

### Prio P0 — CI/CD-Fundament (A6/A7, vor Messlauf)
- **#186** CI/CD-4-Modul-Pipelines + 10-Stufen-Prinzip — JETZT hochpriorisiert. Reihenfolge P1a→P1f
  (lint+build+contract-Templates → sanitize → thesis-gate → super-smoke → Infra-Matrix → chaos/deploy/canary).
  Ergänzt um A1 (Deploy-Artefakte), A2 (3D-Matrix+Win2022-KVM), A3 (ZIH-Power/AArch64), A4 (Drift-Gate)+Teil D.
- **#189 (NEU)** Infra-Handoff schreiben: universelle Runner (ISA×OS×{bm/docker/k8s}), Win2022-KVM, macOS-Fix,
  ZIH-Power/AArch64, .1-SNI V10, **Secret-Rotations-Status-Frage (A13)**.

### Prio P1 — Architektur-Fixes (parallel, gate-frei→Code)
- **#188 (NEU, A10)** #182-Lücke-1 Architekturfix: T0-Such-Delegation über Speicher-Achsen statt
  `search_organ_`-Monolith; Diff SOLL⇄IST; zentrale Steuerung Experiment-B+-Baum.
- **#187 (NEU, A9)** PMC-Auto-Adaption: Counter-Capability-Detection je ISA+OS+Umgebung → Messung+Tabellen
  adaptiv (max-genau). Inkl. AMD-L3/LL-Mapping (L3=0-Befund).
- **#178 (A8)** Code-Strukturfix Stufe→Reihe (merge-getrieben, ch4 §4.8) NACH ch6-Prüfung; ggf. **#190 (NEU)**
  Text-Agent-Handoff für ch6-Konsistenz.
- **#179** Wartbarkeits-/Lesbarkeits-Sweep ALLER C++-Dateien (A6: „Code übersteht keine Wartbarkeit") —
  verzahnt mit cache-engine-Ordnungs-Refactoring (CI/CD §5.1).

### Prio P2 — Messlauf (A7: NACH der Pipeline)
- **#162** PRT-ART + ≥8 SOTA + Reihen A/B/C (GROSS) · **#156** M3-Neumessung (jetzt entsperrt) ·
  **#163** SIMD/ISA+Allokator-Varianten + ≥2 Plattformen · **#165** quiesziertes OS + Quality-Flag + Perzentile.

### Prio P3 — Übrige Code-Rückstände
- **#184** AP-CE2 Dataset-Loader-Slot · **#185** io-tpie (TPIE+EM-BFS I/O-Achse) · **#125** P6 lazy-DLL
  Content-Hash · **#19** Allokatoren echt linken · **#10** V42-Infra-Rest.

### Infra-pending (Handoff, ich handle nicht selbst)
- Universelle Runner (#189) · Secret-Rotation (A13) · .1-SNI V10 (A12) · macOS-Fix · ZIH-Anschluss.

---

## TEIL D — Web-recherchierte Gates je Pipeline-Stufe (Antwort 4)

> Quellen §E. Ergänzend zum User-Drift-Gate (>5 % → 3×-Wdh + Warn). **Je Stufe ein Gate, der die nächste sperrt.**

| Stufe | Sinnvolle Gates (web-recherchiert + projektspezifisch) |
|---|---|
| 1 lint | 0 Format-Diffs (clang-format `--dry-run -Werror`); clang-tidy/cppcheck 0 neue Findings; **gitleaks 0 Secrets** (hart); IWYU/cpplint advisory; LaTeX `chktex` 0 Errors. |
| 2 build | Alle ISA×OS×{bm/docker/k8s}-Zellen grün; **0 Compiler-Warnings** (`-Werror` wo möglich); reproduzierbar (Manifest-Hash). |
| 3 sanitize | asan/tsan/**ubsan** je Variante 0 Findings (hart); je ISA+OS separat. |
| 4 contract+config | ABI-Contract-Tests grün; **std::map-Konformitäts-Gatter** grün; Müll-Config ⇒ definierter Fehler (kein Crash) — fuzz/property. |
| 5 integration | E2E-Kette grün; **Coverage ≥ 80 % kritische Logik** (web-Standard); storage/db-Roundtrip grün. |
| 6 chaos | **Drift > 5 % ⇒ 3×-Wdh + Warn (User-Gate)**; Runner-Kill/Netz-Partition-Resilienz; **Flaky-Erkennung** (real-bug vs flaky). |
| 7 manifest+prebackup | Prebackup verifiziert (Hash) VOR Überschreiben; Manifest vollständig (Toolchain+SHAs+ISA/OS+Profil). |
| 8 K8s-Prod-Pod | Image-Scan (SBOM `syft` + Vuln `grype`/`trivy`) **0 kritisch/hoch** (web-Standard); Pod-Readiness. |
| 9 deploy-staging | Staging-Smoke grün; **Performance-Regressions-Gate** (kein signifikanter Slowdown, web-Standard). |
| 10 smoke/canary | **canary-loggate** (Fehlerrate < Schwelle) → **canary-promote**; SLO-Check; später e2e-ui. |

### §E — Quellen
- [Quality Gates in CI/CD: What Should Really Block a Release in 2026 — AgileVerify](https://agileverify.com/quality-gates-in-ci-cd-what-should-really-block-a-release-in-2026/)
- [The Importance of Pipeline Quality Gates — InfoQ](https://www.infoq.com/articles/pipeline-quality-gates/)
- [Setting Up Code Quality Gates in Your CI/CD Pipeline — Propel Code](https://www.propelcode.ai/blog/continuous-integration-code-quality-gates-setup-guide)
- [Building a Production-Ready CI/CD Pipeline: Complete 2026 Guide — Medium](https://medium.com/@krishnafattepurkar/building-a-production-ready-ci-cd-pipeline-the-complete-2026-guide-b3d6a661ecd8)
- [Clang-Tidy / cppcheck / IWYU (Stufe-1-Tools, s. Vorgänger-Doc §10)](https://clang.llvm.org/extra/clang-tidy/)

---

## NACHTRAG — autonome Fortsetzung 2026-06-25 (gate-freie Analyse, verify-before-acting)

- **#190 ERLEDIGT:** ch6 (`06_evaluation_methodology.tex` `sec:series`) ist **bereits ch4-§4.8-konform**
  (Reihe A = Prüfling vs SOTA · B = systematische Variation · C = Merge/Regression alt-neu). Der Text-Agent
  hat es angeglichen → **kein Text-Agent-Handoff nötig**; die Thesis ist konsistenter Soll.
- **#178 TIEFER-BEFUND (→ #162/P2):** der Stufe→Reihe-Fix ist eine **Mess-Architektur-Umstrukturierung**, NICHT
  nur `sota_module_for`. ch4 §4.8: **Reihe C = build-übergreifend = KEINE Stufe-sota_series** → das aktuelle
  3-sota_series-Modell (A=St1, B=St2, C=St3) muss zu **A=St1∪St2 / B=St3 / C-raus-aus-sota_series** umgebaut
  werden, mit RIPPLE durch `test_sota_series_pilot.cpp:115/119/123` + 3 Profile + `messung_driver`
  `MessreiheKind::C`. Gehört per **A7 (Pipeline zuerst)** zu **#162 (P2)** — nicht isoliert überstürzen.
- **#188 DIFF-EINSTIEGSPUNKTE lokalisiert:** zentrale Steuerung = `builder/experiment_tree/experiment_tree.hpp`
  + `perm_runner.hpp`; SOLL-Muster = `axes/lookup/composable/store_traversable_search_algo.hpp` (Weg-A routet
  T0 durch den Store); IST = `abi_adapter.hpp` `fill_observer_v3` (`search_organ_.statistics()` ~:924) +
  `tier_search_routes_through_store()==false` (~:1490). SOLL: Weg-B (Tree/Trie/Hash/k-ary/eytzinger) über
  T4/T5/T6 statt `search_organ_`-Monolith. GROSS → fokussierte Ausführung (frischer Kontext empfohlen).
- **Priorität bestätigt (A6/A7):** CI/CD-Fundament (#186) = **P0 zuerst** · #188-Arch-Fix = P1 ·
  #178 + Mess-Lauf (#162) = P2 (nach der Pipeline).
