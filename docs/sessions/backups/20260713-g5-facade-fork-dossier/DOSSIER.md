# G5-DESIGN-FORK — VORLAGE (#274 measurement-all-Migration · Goal-V4 G5 · #10+#18)

> READ-ONLY-Analyse (Agent aa60cac, 2026-07-13). Dies ist die **Vorlage** (das vom Goal geforderte „Umfang+Schnitt
> zuerst als Design-Fork VORLEGEN"), NICHT die Entscheidung/Umsetzung. Belege `datei:zeile`. Kein Code/Remote berührt.
> super = probst-diplomarbeit-cache-engine · ce = super/Code/external/comdare-cache-engine · Umbrella =
> Modules/comdare-measurement-all (GitLab-Projekt 300).

## 0. WICHTIGSTE VORAB-KORREKTUR (Scope-Wahrheit)
Der Goal-Text sagt „metrics-Transfer schritt 3 VERGESSEN seit 2026-07-07" (zitiert `Umbrella/README.md:7`). **Am
Ist-Stand WIDERLEGT:** Schritt 3/5/6/7 sind vollzogen + CI-grün — `comdare-baseline_0-core/comdare-metrics`,
`_1-instrumentation/comdare-pmc` (`26ee7dc`), `_2-workloads/comdare-workloads` (`518ac35`); Beleg Ledger §12
`:505/511/515/517` + Zellen-Git-Logs. Die zitierte `README.md:7` ist ein **stale Umbrella-README** (nach Schritt 3 nie
nachgezogen); die Zellen-README sagt korrekt „Bestandszelle per GitLab-Transfer aus foundation (#274 Schritt 3)".
**⇒ #18 „metrics-Transfer vergessen" ist NICHT die echte Lücke.** Der genuin noch-nicht-getane G5a-Kern:
(1) die super `Code/0X`-Auswertungs-/Report-Stufen (0 % extrahiert), (2) der ce-WIE-Mess-Infra-Rest
(`MeasurementRecord`/`ThreadArena`/`IMeasurementSource`/`SystemAxis`-Framework/`latency_stats`/`dataset_loader`).
Zusatz: super `Code/0X` konsumiert measurement-all heute NICHT (grep=0) — Konsum-Umstellung = Migrations-Schritt 13 (GATED).

## 1. IST (WAS vs WIE). Doktrin (`STRUCTURAL_CORRECTION_diplomarbeit.md:865`): Diplomarbeit=WAS, CacheEngine=WIE.
**1a Bereits migriert (Kopie-Extraktion, ce behält Originale als lebende Quelle):** metrics(b0: IMeasurementObserver/
Counter/Gauge/Histogram/HDR/latency_stats) · pmc(b1: pmc_source/linux_perf/windows_pcm) · workloads(b2: workload_
config/generator/dataset). Konvergenz (ce konsumiert Zelle) = Schritt 13 GATED. Build-Form: `add_library INTERFACE` +
`comdare::<ns>`-Alias (source-only).
**1b super Code/0X (NOCH NICHTS extrahiert)** — Facade `comdare_da_add_library(<n> MODULE)`, 5 Stufen nutzen sie
(M03/04/05/08/09): 01_sample_data(exe, WAS-Helfer) · 02_messung_driver(exe, **WAS-Kern**, HOCH ce-gekoppelt V32Orchestrator)
· 03_binary_to_csv(M03, WIE aber schema-gebunden) · 04_csv_to_latex(M04, WIE aber thesis-schema) · **05_diagram_generator
(M05, WIE, ce-frei → sauberster Kandidat)** · 06_latex_to_pdf(WAS) · 07_tier_binary_report(tier-spezifisch) ·
08_appendix_generator(M08, WAS) · **09_tex_formatter(M09, WIE, thesis-unabh. → sauberer Kandidat)**.
**1c ce-Grenze:** Naht = eingefrorener Observer-POD `ComdareTierObserverSnapshot` (`observable_tier.hpp:130`,
sizeof==1416, `kV3AxisSchema:66`). POD-KORREKTUR: 1416B=Snapshot; `MeasurementRecord`=separates **32B**-Disk-Format
(`measurement_record.hpp:11/24`). **Auslager-Kandidaten (WIE, nicht-ABI):** MeasurementRecord/ThreadArena/measure/
axis_registry · IMeasurementSource · SystemAxis-Framework-Rumpf · latency_stats/HDR · dataset_loader · pmc_source ·
benchmark_suite. **Bleibt ce (ABI/WAS):** WIDE-Schema (LazyMeasuredRow/lazy_csv_header/format_csv_row) · ResultAggregator
· MeasurementCategory-Vokabular · alle Achsen/anatomy/GenusBindingTraits.

## 2. SOLL-Schnitt (INV-2 n→n-1, `MATRIX-GRUNDLAGEN-GOALV2.md:24-27`; Kette workloads→pmc→metrics)
b0-core(metrics)+= MeasurementRecord/ThreadArena/measure/axis_registry/IMeasurementSource · b1(pmc)+= SystemAxis-Rumpf ·
b2(workloads)+= dataset_loader-Rest+sample_data-Kern · **NEU b3-analysis** = latency_stats-Generika + super 05_diagram +
09_tex_formatter (+ evtl. 03/04-Generika). b3-analysis ist per F14-Recherche vorgesehen (`20260706-274-MATRIX-
MIGRATIONSPLAN-ENTWURF.md:52`). Presentation/PDF bleibt außerhalb (super-Auswertung).

## 3. USER-FORKS (Option + Empfehlung + Risiko)
- **F0 SCOPE:** A(empf.) G5a=Extraktion 0X-Analyse-Generika+ce-WIE-Rest (echte Lücke) · B=nur README:7-Fix, G5 „strukturell
  fertig, Rest Schritt-13-gated" · C=voller Monolith-Split sofort. **Empf. A.**
- **F1 GRANULARITÄT:** A(empf.) belang-genau (nur ce-freie Generika) · B ganze Stufe inkl. thesis-Pfade. **Empf. A** (INV-4).
- **F2 FORM:** A(empf.) source-only INTERFACE (wie b0/b1/b2, §9) · B Binary/STATIC. **Empf. A.**
- **F3 REIHENFOLGE:** A(empf.) bottom-up (b3 leer/Interface → 09 → 05 → latency_stats; ce-Additive zuletzt) · B top-down. **Empf. A.**
- **F4 b3-analysis JETZT?** A(empf.) mit erstem Inhalt anlegen (F14-empfohlen) · B später · C in b0 unterbringen. **Empf. A.**
- **F5 KONSUM DANACH:** A(empf.) eigene Research-Instanziierungs-Zelle (§9 „Research=early Products", `Ledger:189`; Schritt-13-GATED)
  · B nackter Direkt-Link (§9-supersediert). **Empf. A.**
- **F6 (optional, Doc-15):** 2D-Matrix M×W — Option A compile-time-Param / B Zell-Explosion / C Familien-Achse; Empf. A; NICHT G5-Kern.

## 4. BLEIBT (nicht migriert)
super WAS: 02_messung_driver/06_latex_to_pdf/08_appendix_generator/experiment_config/01-thesis. ce ABI: WIDE-Schema/
ResultAggregator/1416-POD+kV3AxisSchema/workload_descriptor_v1/MeasurementCategory. ce Messgegenstand (nie): axis_XX/
node_pool_store/anatomy/GenusBindingTraits. Fremd: buildsystem.xml (F1-Agent), TestSystem (F9).

## 5. TABU/RISIKEN
golden_fullpilot_320/ABI-4/.A4./permutation_axes.xml/POD 1416+32/kV3AxisSchema/GenusBindingTraits unantastbar (Erweiterungen
nur golden-neutrale END-Appends Default-OFF). WIDE-Schema Single-Source aus kV3AxisSchema — Auswertung nur LESEN. Pipeline 286/
Monolith unangetastet (Extraktion=KOPIE, Monolith bleibt Quelle bis Schritt 13). Je Increment Provenienz-Artefakt (Repo+SHA+Datum,
Muster #265-a). Doku nie löschen (README:7 nur korrigieren). **Remote-Anlage b3-analysis + Zell-Projekte = je-Repo-GO** (Name
„comdare-cache-engine-all" verboten). GitLab-origin infra-blockiert (G1) → lokal grün + github, origin/CI batch-nachgezogen.
Kein buildsystem.xml in Zellen. Je Modul-Split = eigener Increment, ctest-grün + je-GO + separates Remote.

## Ein-Blick-GO
**F0=A,F1=A,F2=A,F3=A,F4=A,F5=A** („alle wie empfohlen") → erster Increment = README:7-Korrektur + `baseline_3-analysis` mit
`09_tex_formatter` (kanten-ärmster ce-freier Kandidat), je eigenes Remote-GO. **F0=B** → G5 als „strukturell fertig, Konsum
Schritt-13-gated" schließen, keine neue Extraktion.
