# PARALLELISIERUNGS-ANALYSE — Disjunkte Pakete der Gesamt-Roadmap 20260719

> 2026-07-19. Ableitung aus `20260719-gesamt-roadmap-ledger-diff-ROADMAP.md` (VOLL gelesen, 275 Zeilen).
> Kriterien (Ledger-Doktrin Spur-S/P): (1) Datei-Disjunktheit über `berührte Fläche`; (2) ABI/POD/god-header
> (`abi_adapter` / `observable_tier` / `anatomy_module_abi` / Module-ABI-Decls) = SERIELLER SPERRBEREICH,
> max 1 offener Increment; (3) golden-berührende Schritte (gn=✗) NIE parallel zueinander (GO-Fenster seriell);
> (4) Single-Owner je geteilter Datei. Dieses Dokument ist additiv; es ändert keine Roadmap-Inhalte.

---

## (0) Paket-Schnitt (Grundlage der Matrix)

Die 60+ Roadmap-Items werden in 10 Arbeitspakete geschnitten, so dass die Flächen-Schnitte INNERHALB
eines Pakets liegen (dort seriell vom Paket-Owner) und ZWISCHEN Paketen leer sind:

| Paket | Inhalt (Roadmap-IDs) | Fläche (Kurzform) | gn |
|---|---|---|---|
| **P1 ce-QW-Code** | K-3, K-5, K-6, K-7, K-10-Renderer, K-13, K-14 | ce `set_composition.hpp`+`test_d9_set.cpp`, `best_binary_selector/*`, `anatomy_module_loader.cpp`, `registry_to_axis_levels.hpp:147-161`, Iterator-n/a-Renderer, `cache_engine_axis_registry.xml`, `test_data_sets.xml` | ✓ |
| **P2 ABI-QW** | K-2 (static_assert 1272) | ce `anatomy/observable_tier.hpp:146` — **Sperrbereich!** | ✓ |
| **P3 super-Build/CI** | K-4 (build-i2-Include-Root), K-12-CI-Kommentar-Anteil (`.gitlab-ci.yml:530/588/612`); später ST-3, M-5, M-6, K-16 | super `Code/CMakeLists.txt`, `Code/cmake/`, super `.gitlab-ci.yml` | ✓ |
| **P4 Planer-Phase-0-super** | PL-0 (NUR super-Teil), PL-4 | super `02_messung_driver/{v32_messreihe_antrieb,v32_orchestrator,main}`, `CMakePresets.json` — **ce-Naht `experiment_run_entry.hpp` in Welle 1 READ-ONLY (Scope-Schnitt!)** | ✓ |
| **P5 golden-N-CE** | GN-1 → GN-2 → GN-5 (Welle 1); GN-9, GN-10, GN-6-Werte (Welle 2) | ce `measurement/{extension_hardware_system_axis,simd_sub_axis}.hpp`, `validate_profile.hpp`, `profile_run_facade.cpp` (opt-g), `source_catalog.hpp`, `catalog_codegen.cmake`-Umfeld, `tests/unit/` (neu), `axis_variant_version_table.hpp` | ✓ |
| **P6 Auswertung/Thesis** | M-4 (super-Code-Teil autonom; Thesis-Haupt-Text-Zahlen = User-GO-pflichtig per Autonomie-Direktive) | super `Code/04,05,08` (`diagram_generator.*`, kSegmentCount→Single-Source); thesis kapitel+anhang DE+EN (GO) | Code ✓ / .tex-Teil GO |
| **P7 Marker/Doku-QW** | ST-6, K-11 (ohne CI-yml-Zeilen), K-15, V8 | `scripts/copy_results_to_nas.sh`, Root-`_*.py`, ce `CMakeLists.txt:550` (NUR Kommentar), OPT-C-Bauplan-Doku, prt-art `PRT_ART_AXES_REUSE_MATRIX.md` | ✓ |
| **P8 Bookkeeping** | BK-1…BK-10 + M1-Morgen-Entscheidungsliste | Ledger, Register, Board, Bauplan-Annotationen, neue Entscheidungs-Doc — KEIN Code | ✓ |
| **P9 Infra (extern)** | ST-1 (PAT-Rotation), ST-2 (P1–P6), ST-4 | Vault, Cluster, GitLab-CI-Vars — Impl-Agenten cluster-read-only | ✓ |
| **P10 SERIELL-Strang (golden/GO)** | GN-7 (rm-GO), GN-3-Fixture-Schritt, GN-4-Rebuild-Fenster, K-9, K-22→M-1 Messlauf, danach K-25/K-26-ABI-7-Fenster, PL-13, M-10 | golden-Fixtures, Mess-CSVs, Messlauf-Fenster, ABI-Decls | ✗ je Definition |

Entscheidungs-Items ohne Code-Fläche (GN-11, O-1…O-14, PL-5-Fork, Forks A–E, K-25, K-27, K-28, ST-5)
laufen ausschließlich über P8 (Morgen-Liste) — sie parallelisieren nicht, sie GATEN.

---

## (A) Parallelisierungs-Matrix

`—`=selbst · `N`=disjunkt, parallel OK · `N*`=disjunkt nach Scope-/Owner-Schnitt (Bedingung in Fußnote) · `J`=Konflikt → seriell/Single-Owner

|      | P1 | P2 | P3 | P4 | P5 | P6 | P7 | P8 | P9 | P10 |
|------|----|----|----|----|----|----|----|----|----|-----|
| **P1** | — | N¹ | N | N | N*² | N | N*³ | N | N | J⁴ |
| **P2** | N¹ | — | N | N | N | N | N | N | N | J⁵ |
| **P3** | N | N | — | N*⁶ | N | N*⁷ | N*⁸ | N | N*⁹ | J¹⁰ |
| **P4** | N | N | N*⁶ | — | N*¹¹ | N | N | N | N | J¹¹ |
| **P5** | N*² | N | N | N*¹¹ | — | N | N | N | N | J¹² |
| **P6** | N | N | N*⁷ | N | N | — | N | N | N | J¹³ |
| **P7** | N*³ | N | N*⁸ | N | N | N | — | N*¹⁴ | N | N |
| **P8** | N | N | N | N | N | N | N*¹⁴ | — | N | N |
| **P9** | N | N | N*⁹ | N | N | N | N | N | — | J¹⁵ |
| **P10** | J⁴ | J⁵ | J¹⁰ | J¹¹ | J¹² | J¹³ | N | N | J¹⁵ | — |

Fußnoten (Gründe):
1. Datei-disjunkt; gleicher Agent empfohlen, damit der ABI-Sperrbereich (K-2) als ERSTER, isolierter Commit geschlossen wird, bevor P1-Fläche geöffnet wird (Kriterium 2: max 1 offener ABI-Increment).
2. Datei-disjunkt, EIN Randfall: falls K-5-Paritäts-Test als NEUE Test-Datei registriert wird, berührt P1 die tests-CMakeLists, die P5 (GN-5-Neuregistrierung) auch braucht → additive Appends, Owner der tests-CMake-Registrierung = P5-Agent; P1 reicht Registrierung dort ein.
3. ce `CMakeLists.txt`: P7 ändert NUR den Kommentar `:550` (K-11/V4); P1 baut keine CMake-Änderung → disjunkt, solange P1 keine Targets anfasst.
4. K-13/K-14 sind golden-neutral, aber P10-GN-7 löscht ggf. getrackte CSVs unter `tests/unit/thesis_tiere/` → kein P1-Commit-Fenster gleichzeitig mit einem GN-7-Lösch-Commit (Repo-weite golden-Fixture-Nachbarschaft, Review-Klarheit).
5. observable_tier = ABI-Sperrbereich; P10 enthält die späteren ABI-Fenster (K-25/K-26 ABI-7, M-12 Record-Schema). K-2 MUSS gelandet und Pipeline-grün sein, bevor irgendein P10-ABI-Fenster öffnet — und umgekehrt.
6. `CMakePresets.json` (P4) vs `Code/CMakeLists.txt`/`Code/cmake/` (P3): verschiedene Dateien, aber beides super-Buildsystem; Include-Root-Fix (K-4) kann Preset-Wirkung haben → Koordination, Merge-Reihenfolge K-4 zuerst.
7. M-4 stellt 04/05/08 auf Single-Source um; falls dafür Include-Pfade/Targets in `Code/CMakeLists.txt` nötig werden, reicht P6 das als Patch an P3 (Single-Owner super-CMake = P3).
8. super `.gitlab-ci.yml`-Kommentarzeilen (K-12 „16 Darstellungs-.tex") gehören zu P3, NICHT zu P7 — der yml-Single-Owner ist P3. P7 fasst kein yml an.
9. ST-3 (Scharfschaltung in super CI) ist P3-Fläche, aber GATED auf P9-DoD — P3 wartet auf literales Infra-DoD, kein Datei-Konflikt.
10. K-16-Hard-Gate-Sweep und M-5/M-6-CI-Ketten sind ✓, aber ihr Aktivierungszeitpunkt hängt am Messlauf-Fenster (CI-Grün=Messung AUS) → nicht gleichzeitig mit einem laufenden M-1-Fenster mergen.
11. HOTSPOT `experiment_run_entry.hpp`: PL-0-ce-Naht (P4), GN-3/GN-4 (P10), PL-11/PL-12 (später), K-12-Breadcrumb `:143`, K-24. Welle-1-Schnitt: P4 arbeitet NUR super-seitig; die ce-Naht wird erst in Welle 2 geöffnet und dann vom golden-N-Owner (P5-Agent) gehalten bzw. explizit übergeben.
12. GN-3 (Fixture-Schritt ✗) gehört zu P10 und konsumiert P5-Vorarbeit (GN-1/GN-2/GN-5 ✓) — Übergabe P5→P10 intern beim selben Agenten, aber der ✗-Schritt läuft NIE parallel zu einem anderen ✗-Schritt.
13. Thesis-Anhang-Regen (M-6/M-10/M-11) ist messlauf-gated (P10-M-1); P6-Welle-1 beschränkt sich auf Code-Umstellung + GO-pflichtige .tex-Zahlen — der Anhang-Teil wartet.
14. Bauplan-Doku: V8 (P7) betrifft den OPT-C-Bauplan; BK-9 (P8) den 20260719-Bauplan — verschiedene Dateien. Bei Überschneidung gewinnt P8 als Doku-Owner.
15. Messlauf (M-1) ist gated auf ST-2/ST-3 (P9) und darf erst nach Infra-DoD; während des mehrtägigen Fensters keine Infra-Umbauten an denselben Ressourcen (nie pollen, Fenster respektieren).

**Kernbefund:** P1–P9 sind nach den genannten Scope-Schnitten paarweise datei-disjunkt.
ALLE Konflikte konzentrieren sich auf (a) P10 (golden/GO-seriell per Doktrin) und
(b) 6 Hotspot-Dateien (siehe C), die per Single-Owner entschärft werden.

---

## (B) Parallel-Wellen

### WELLE 1 — SOFORT gleichzeitig startbar (alles gn=✓, kein User-GO nötig; deckt Roadmap-M0)

| Owner | Paket | Aufgaben | Dateien (exklusiv) |
|---|---|---|---|
| **Agent-A** | P2 dann P1 | ZUERST K-2 (ABI-Sperrbereich, isolierter Commit, einziger offener ABI-Increment) — DANN K-6, K-7, K-5, K-3, K-10-Renderer, K-13, K-14 als 2–3 Sammel-Commits, je golden-neutral ausgewiesen | `observable_tier.hpp`; danach loader/selector/registry_to_axis_levels/set_composition/Iterator/Registry-XML/test_data_sets |
| **Agent-B** | P3 | K-4 build-i2-Include-Root (aktiver hart-grün-Direktiv-Bruch, clean-rebuild-Beleg literal) + K-12-CI-Kommentare; hält danach die super-yml-Ownership für ST-3/M-5/M-6/K-16 | super `Code/CMakeLists.txt`, `Code/cmake/`, super `.gitlab-ci.yml` |
| **Agent-C** | P4 | PL-0 Phase-0-Reconcile NUR super-seitig (Deprecation-Banner fortschreiben, Skelett-Andock-Vorbereitung) + PL-4 XML-mode-Konsum + MEASUREMENT_ON-Preset; ce-Naht read-only lassen | super `02_messung_driver/`, `CMakePresets.json` |
| **Agent-D** | P6 | M-4-Code-Teil: super 04/05/08 auf Single-Source `kV3AxisCount` (kSegmentCount=20-Hartkodierung raus, seg_isa/seg_telemetry) — VOR jeder Lauf-Auswertung; Thesis-„neunzehn-Achsen"-Korrekturen DE+EN als GO-Vorlage vorbereiten (Haupt-Text nicht autonom) | super `Code/04,05,08`; thesis .tex nur als Patch-Vorschlag |
| **Agent-E** | P5 | GN-1 aktiver `extension_hardware`-Knoten → GN-2 Entkopplungs-Guard (§26.6 static_assert) → GN-5 reflect_versions-17-Instanziierungstest; hält Ownership `validate_profile.hpp` + `profile_run_facade.cpp` + `experiment_run_entry.hpp`-ce-Naht | ce `measurement/`, `validate_profile.hpp`, `profile_run_facade.cpp`, `source_catalog.hpp`, tests/unit |
| **Agent-F** | P8 | BK-1…BK-10 (Ledger-SHAs, Board #45/#49, §-Sweeps, Register-Annotationen) + M1-Morgen-Entscheidungsliste als EIN Dokument bündeln (GN-11 zuoberst) | docs/ (Ledger/Register/Board) — kein Code |
| **Agent-G** | P7 | ST-6 NAS-Skript-DEPRECATED, K-11-Marker (V3/V4/V5/V8), K-15 prt-art-SUPERSEDED-Banner — NICHT löschen | scripts/, `_*.py`, ce CMakeLists-Kommentar, prt-art-Doku |
| **Infra-Agent** | P9 | ST-1 PAT-Rotation SOFORT (Security) + ST-2 Handout P1–P6 + ST-4 V60/V80-Klärung; DoD literal | Cluster/Vault/CI-Vars (extern) |

Welle-1-Invarianten: genau EIN offener ABI-Increment (K-2, zuerst geschlossen); KEIN gn=✗-Schritt läuft;
jeder Commit mit golden-Neutralitäts-Ausweis; nach jedem Push Pipeline GRÜN.

### WELLE 2 — nach Welle-1-Landung + M1-User-Entscheiden (Tag 1–4)

| Owner | Aufgaben | Gate |
|---|---|---|
| Agent-E | GN-3 opt×simd-Wiring/Generator-/Test-Umhängung (✓-Anteile); GN-6-Werte fixieren; GN-9 Bloat-Stichprobe; GN-10 Fixture-Single-Source; K-1 Organ-only-Guard (validate_profile/profile_to_tree — gleiche Owner-Fläche) | PL-5-Kanal-Entscheid, O-6-Bestätigung |
| Agent-C | PL-1 Phase-1-I1 Director-Zerlegung + `--dump-plan` + Contract-Test; ce-Naht-Übernahme in Abstimmung mit Agent-E (Hotspot 2); danach I2 opt-in | Forks A–E-GO aus M1 |
| Agent-C oder 2. Planer-Agent | PL-2 CebSystemAxisDrive (Bauplan-Kritik 5: parallel zu Phase 1 machbar) — ABER erst nachdem Agent-Es GN-1-Änderung an `profile_run_facade.cpp` gelandet ist (Hotspot 3) | GN-1 gemerged |
| Agent-B | ST-3 Scharfschaltungs-Probe + E2E-Beleg (mc-cp + curl-PUT literal); M-5-Vorbereitung 2×latexmk | ST-2-Infra-DoD |
| Agent-A | K-23 #54-Beleg-Report (nach K-1, gleiche Fläche gelesen); K-12-Rest-Sweep | K-1 gelandet |
| Agent-D | Thesis-Zahlen-Korrekturen einspielen | User-GO Haupt-Text |
| Agent-F | K-22 befunde-83-Abgleich gegen Register (VOR #46 Pflicht) | — |

### SERIELL-Strang (NIE parallelisieren — ein Schritt nach dem anderen, je eigenes GO-/Fenster)

1. GN-7 rm-CSV-Entscheid vollziehen (nur nach EXPLIZITEM User-GO; Konflikt „Messdaten nie löschen").
2. GN-3-Fixture-/Materialisierungs-Schritt (✗) — einziger offener golden-Schritt seines Fensters.
3. GN-4/E-2 O3-Voll-Rebuild-Fenster (mehrtägig, User-Timing).
4. K-9 ToolchainFehlt-Emitter (✗ Log-Verhalten) — als Einzelschritt zwischen den Fenstern.
5. M-1 Messlauf #46 (mehrtägig, NIE pollen; vorher K-22 + M-4 zwingend; Scope per GN-11) → M-3-DoD-6-Beweis → M-6/M-10-Anhang-Regen (P6/P3 konsumieren).
6. NACH 28.07.: PL-13 System⊃Tier-Baum (✗, eigener Bauplan+GO) → K-25/K-26-ABI-7-Bündel-Fenster (Sperrbereich! zu diesem Zeitpunkt darf KEIN anderer ABI-Increment offen sein) → M-12 Record-Erweiterung (ABI darf brechen, eigenes Fenster) → M-10 golden-N-Vollzug.

---

## (C) Konflikt-Hotspots — geteilte Dateien mit Single-Owner-Zuweisung

| # | Datei | Anfassende Pakete/Items | Regelung |
|---|---|---|---|
| 1 | **super `.gitlab-ci.yml`** | ST-3, M-5, M-6, K-16, K-12-CI, später PL-1-I3 (CiYamlBuilder!) | Single-Owner **Agent-B**. Alle anderen reichen Patches ein. I3 generiert später yml → dann Owner-Übergabe an Planer-Strang explizit im Ledger vermerken. |
| 2 | **ce `profile_facade/experiment_run_entry.hpp`** | PL-0, PL-1, PL-11, PL-12, GN-3, GN-4, K-12(:143), K-24 | Meist-geteilte Code-Datei der Roadmap. Welle 1: NIEMAND schreibt (P4-Scope-Schnitt). Welle 2: Owner **Agent-E** (golden-N M2), danach dokumentierte Übergabe an Planer-Agent (M3/M7). Nie 2 offene Branches auf dieser Datei. |
| 3 | **ce `profile_run_facade.cpp`** | GN-1 (opt-g-Facade), PL-2 (:560-568), PL-5 (:122/258 Pilot-Env) | Owner **Agent-E** in Welle 1; PL-2 erst nach GN-1-Merge (Welle 2); PL-5-Umbau erst nach Fork-E-Entscheid. |
| 4 | **ce `validate_profile.hpp`** | GN-1, K-1, PL-5, PL-6, PL-9, GN-8-Checks | Owner **Agent-E**; K-1 wird von ihm in Welle 2 mitgenommen (gleiche Fläche), PL-6/PL-9 erst nach M1-Entscheiden, seriell beim Owner. |
| 5 | **ABI-Sperrbereich** (`observable_tier.hpp`, `abi_adapter`, `anatomy_module_abi`/Module-ABI-Decls, PL-8-thread_count-Kanal, K-25/K-26, M-12) | K-2 jetzt; PL-8, K-25/K-26, M-12 später | Doktrin: max 1 offener Increment. Welle 1 = NUR K-2. PL-8 nur „falls je gewollt" (dokumentiert gepinnt lassen = Default). ABI-7-Fenster (K-25/K-26) und M-12 je exklusiv, nach Deadline. |
| 6 | **`experiment_schema.xsd` + `xml_config_parser.*`** | PL-5, PL-6, PL-7, PL-10, K-12-Kopf, K-20 | Ein XML-Kanal-Owner (Planer-Agent-C ab Welle 2/3), komplett gated auf Fork-E/PL-5-User-Entscheid. Bis dahin: nur Kommentar-Fix (K-12) erlaubt, durch denselben künftigen Owner. |
| 7 | **ce `cache_engine_builder_iterator.hpp`** | K-10-Renderer, PL-9, PL-11, PL-14 | Welle 1: nur K-10-Renderer (Agent-A). PL-9/PL-11 seriell im Planer-/golden-Strang danach; PL-14 nach 28.07. |
| 8 | **ce tests-CMake-Registrierung** | GN-5 (neuer Unit-Test), evtl. K-5-Paritätstest, GN-8-Tripwire | Owner **Agent-E** (GN-5); Agent-A reicht K-5-Testregistrierung als additiven Append ein; GN-8 nach M1. |
| 9 | **super `Code/CMakeLists.txt` / `Code/cmake/`** | K-4, evtl. M-4-Include-Pfade, build-i2 | Owner **Agent-B**; Agent-D reicht CMake-Bedarfe als Patch ein. |
| 10 | **Ledger/Register/Board (docs/)** | BK-1…BK-10, K-21, BK-Annotationen aus allen Strängen | Owner **Agent-F**. Code-Agenten liefern ihre Ledger-Zeilen als Text an Agent-F statt selbst zu editieren (verhindert 7-Wege-Merge auf dem Ledger). |
| 11 | **thesis .tex DE+EN** | M-4-Zahlen, M-5-Build, M-6/M-7/M-10-Anhang | Owner **Agent-D**; Haupt-Text-Änderungen IMMER als GO-Vorlage (Autonomie-Direktive: nur Messwert-LaTeX+PDF autonom). |
| 12 | **`tests/unit/thesis_tiere/*.csv` + `build/`-Mess-CSV** | GN-7 (rm-GO ausstehend) | NIEMAND berührt sie bis zum expliziten User-GO (Messdaten-nie-löschen-Doktrin; getrackte Mess-CSV vor rm -rf build prüfen). |

---

## (D) Empfehlung: Anzahl paralleler Implementierungs-Agenten

**5 Code-Agenten + 1 Doku/Bookkeeping-Agent + 1 Infra-Agent (extern) = 7 Lanes in Welle 1.**

Begründung:
- Die Roadmap trägt nach Scope-Schnitt genau **5 datei-disjunkte Code-Flächen** (A: ce-QW+ABI-QW · B: super-Build/CI · C: Planer-super · D: Auswertung-04/05/08 · E: golden-N-ce). Ein 6. Code-Agent fände keine disjunkte Fläche mehr — jede weitere Aufgabe landet auf einem der 12 Hotspots oder im GO-gated/seriellen Bereich.
- Bookkeeping (F) und Infra (extern) sind echte Zusatz-Lanes ohne Code-Berührung; Agent-G (Marker-QWs) ist optional und kann von Agent-A oder F miterledigt werden, wenn 7 Lanes zu viel Koordination sind → **Minimal-Setup: 4 Code + 1 Doku + Infra**.
- Ab Welle 2 sinkt die sinnvolle Parallelität auf **3–4 Code-Lanes** (E: golden-N-Rest · C: Planer-I1/PL-2 · B: Storage/CI · A/D: Reste), weil die Hotspots 2/3/4 (experiment_run_entry, profile_run_facade, validate_profile) zusammenwachsen und der SERIELL-Strang (GO-Fenster) beginnt.
- Während eines Messlauf-/Rebuild-Fensters (GN-4, M-1): Code-Parallelität auf golden-neutrale Doku-/Planer-Arbeit beschränken; kein Merge in Mess-berührende Flächen (CI-Grün=Messung-AUS-Doktrin).

Koordinationsregeln (Pflicht): jeder Agent committet NUR in seiner Paket-Fläche; Fremd-Datei-Bedarf → Patch an den Single-Owner; ABI-Bereich meldet Öffnen/Schließen zentral (max 1 offen); jeder Commit weist golden-Neutralität aus; Ledger-Einträge laufen als Text über Agent-F.

---

## (E) KORREKTUR-NACHTRAG (Vollständigkeits-Kritik 2026-07-19, live-grep-verifiziert)

1. **K-7-Sweep-Fläche unvollständig (Fußnote-2-Ergänzung):** Der K-7-Rename `all_axes_binary_count()` → `all_axes_matrix_count()` (P1/Agent-A) hat live-grep-belegte Konsumenten/Kommentar-Loci AUSSERHALB der P1-Fläche: `profile_facade/source_catalog.hpp:137` (Kommentar — **P5/Agent-E-Fläche**, GN-2-Ziel!), `axes/mapping/axis_03m_mapping_registry.hpp:21` (Kommentar) und `tests/unit/test_br1_full22_count.cpp:6/60-67` (echter Konsument). Regelung analog Fußnote 2: Agent-A liefert die source_catalog-Kommentarzeile als Patch an Agent-E (nicht selbst committen); test_br1 gehört zum Rename-Commit von Agent-A.
2. **K-9-Timing vs. Roadmap:** Seriell-Strang Schritt 4 plant K-9 (ToolchainFehlt-Emitter) VOR M-1; die Roadmap listet K-9 unter **M11 (NACH 28.07.)**. Diese ANALYSE ändert per Selbstverpflichtung (Kopfzeile) keine Roadmap-Inhalte → die Vorziehung ist NUR gültig, wenn der M1-Morgen-Entscheid die D1-Sichtbarkeit im #46-Lauf verlangt; Default = Roadmap-M11. (In der Roadmap als F-2 gespiegelt.)
3. **Pfad-Präzisierung P5:** „ce `measurement/`" = `libs/cache_engine/include/cache_engine/measurement/` (Header-Ist, live verifiziert); kein Verzeichnis `libs/cache_engine/measurement/`.
