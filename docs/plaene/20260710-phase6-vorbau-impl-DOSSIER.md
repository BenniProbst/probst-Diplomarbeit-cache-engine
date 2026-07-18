# DOSSIER — DATEN_GATED-Vorbauten: Mess-System-Phase-6-Registry + IMeasurementSource + E4′-Kurven-Fit-Skeleton

> Increment nach GO-Freigabe (BACKLOG DATEN_GATED, Ansprüche dossier16-17-09 + E4′-Kurven-Fit, beide
> code-verifiziert im Diff-Workflow wf_d4d9e410). Implementierung: **Claude selbst**.
> Wurzeln: ce = `super/Code/external/comdare-cache-engine` (main `90653f02`).
> **Scope = NUR die vorbaubaren Anteile:** Interface + Registry + Skeleton. NICHT in diesem Increment
> (explizit gated/verwiesen): perm_runner-/Prüf-Dock-Umbau (E1-Verweis Ledger :418, M2-Anspruch),
> `<measurement_categories>`-XML (gated #156), PMC-Vollpfad (HELD #215), realer Kurven-FIT (datengetrieben).

## 0. HARTE VERBOTE
Wie alle Increment-Dossiers §0 (golden/m3v2/PODs sizeof/ABI-MAJOR==4/GenusBindingTraits/modules/ext/thesis
TABU; ue/ae/oe; kein Python; kein Runtime-Switch im Hot-Path; honest-0/honest-empty statt Phantom-Werte).
ZUSÄTZLICH: (a) `IPmcSource`/`pmc_source.hpp` bleibt UNBERÜHRT (Bestands-Konsumenten!) — die Brücke ist ein
ADAPTER (GoF), kein Umbau; (b) `system_axis.hpp` bleibt UNBERÜHRT (M-Contract eingefroren); (c) das
Kurven-Skeleton liefert NIEMALS erfundene Fit-Werte — ohne Daten ist der Status explizit `NoData`.

## 1. IST (verifiziert)
- `IMeasurementSource` = 0 Code-Treffer; Design-Quelle EXISTIERT: ce
  `docs/sessions/20260531-mess-abstraktion-cross-platform-architektur-plan.md:81-135` (Header-Pfad,
  MeasuredEvent(10)/SourceStatus(6)/MeasurementSourceCaps/Vollsignatur, WallClockSource = explizit
  degraded Fallback, Vendor-Matrix). `IPmcSource` (builder/pmc_source.hpp, 50 Z.) = schmale
  Bestands-Familie (begin/end→PmcCounters, NullPmcSource, factory).
- `MeasurementAxisRegistry` = repo-weit 0. M-Wurzel: `measurement/system_axis.hpp` (CRTP + consteval
  Regime-Misch-Verbot + regime_of über 16 `MeasurementCategory` aus measurement_category.hpp:9-26);
  Layering-Kante measurement→builder existiert dort bereits (pmc_source.hpp-Include).
- E4′: `builder/cacheline_policy/cacheline_policy_selector.hpp` + Objectives-BEFUND
  (`backups/20260709-pareto-objectives-t6-t18-t5/`) = Fundament; CSV→Kurven→Schätzer-Stufe existiert nicht.

## 2. PAKET A — `i_measurement_source.hpp` (NEU, Pfad aus der Design-Quelle)
`include/cache_engine/measurement/i_measurement_source.hpp`, WÖRTLICH nach Plan §2.2:
`MeasuredEvent` (10, vendor-neutral) · `SourceStatus` (6, errno-style) · `MeasurementSourceCaps`
(max_concurrent_events/has_energy/needs_admin/hybrid_core_aware/event_supported[10]) ·
`IMeasurementSource` (vendor_id/capabilities/open(span<MeasuredEvent>)/begin/end/
read_delta(PmcCounters*)/close — Abweichung zur Skizze: read_delta-Ziel ist der BESTANDS-POD
`builder::PmcCounters` statt ComdareMeasurementSnapshotV1, weil die 6+1-HW-Spalten dort leben und der
Snapshot-POD ABI-heilig ist; im Header dokumentieren). Dazu:
- `WallClockSource` final: immer Available, alle HW-Deltas 0 + `available=false` im PmcCounters
  (EXPLIZIT degraded — heutiges Verhalten, ehrlich benannt).
- `PmcSourceAdapter` final (GoF-Adapter): wickelt ein `builder::IPmcSource&` in das neue Interface
  (open→Available wenn source.available(), read_delta→source-Delta).

## 3. PAKET B — `measurement_axis_registry.hpp` (NEU, compile-time, kein Runtime-Switch)
`include/cache_engine/measurement/measurement_axis_registry.hpp`:
- `constexpr std::array<MeasurementAxisInfo, 16> kMeasurementAxisRegistry` — je Kategorie:
  `category`, `name` (string_view, exakt die Enum-Namen), `regime` (aus regime_of — Single-Source,
  nicht dupliziert).
- `static_assert`-Gates: 16 Einträge, lückenlos aufsteigend (Index==Kategorie-Wert), Regime-Konsistenz
  je Eintrag gegen `regime_of` (consteval-Schleife).
- `template <class Visitor> constexpr void for_each_measurement_axis(Visitor&&)` — compile-time-Iteration
  (Metaprogrammierungs-Interface für E4-Reporting/Prüf-Dock-Folge-Increment).
- `constexpr MeasurementAxisInfo const& axis_info(MeasurementCategory)` — constexpr-Lookup.

## 4. PAKET C — E4′-Kurven-Fit-SKELETON (NEU, honest-empty)
`libs/cache_engine/builder/curve_fit/curve_fit.hpp` (header-only, C++23):
- `CurvePoint` {x_working_set_bytes, y_value, sample_count} · `MeasurementCurve`
  {MeasurementCategory, axis_name, points (aufsteigend x)}.
- `enum class FitStatus { NoData, InsufficientPoints, Ok }` + `struct FitResult`
  {status, a,b (Modell y=a*log2(x)+b), residual_rms} — Fit-Modellwahl folgt dem Objectives-BEFUND
  (Kurven über Working-Set-Größe; log-Achse Cache-Hierarchie).
- `fit_log_linear(MeasurementCurve const&) -> FitResult`: <2 Punkte ⇒ NoData/InsufficientPoints
  (NIE Phantom); ≥2 ⇒ kleinste Quadrate über (log2 x, y) — reine, testbare Mathematik ohne Daten-Annahme.
- `parse_wide_csv_column(istream&, spalte) -> MeasurementCurve`: liest den WIDE-CSV-Header der
  E1-Strecke (Spaltenname exakt), fehlende Spalte ⇒ leere Kurve (Status NoData beim Fit) + Diagnose.
  KEINE Datei-Pfad-Annahmen (Aufrufer liefert Stream) — der reale Fit bleibt datengetrieben (#156).

## 5. PAKET D — Beweis-Tests (Label `m;phase6` — CI-aktiv, NIE contract)
NEU `tests/unit/test_phase6_vorbau.cpp` (Standalone-Muster): (1) Registry: 16/lückenlos/Regime==regime_of
für ALLE Kategorien + for_each zählt 16; (2) WallClockSource: Contract (open→Available, read_delta ⇒
available==false, alle HW 0); (3) PmcSourceAdapter um NullPmcSource: open ⇒ DriverMissing-Klasse
(available()==false ⇒ SourceStatus::DriverMissing), read_delta ehrlich leer; (4) fit_log_linear:
0/1 Punkt ⇒ NoData/InsufficientPoints; synthetische 4-Punkte-log-Gerade ⇒ Ok + a/b auf 1e-9 genau +
residual≈0; (5) parse_wide_csv_column: Mini-CSV-String (echter Header-Ausschnitt) ⇒ Kurve; fehlende
Spalte ⇒ leer.

## 6. DoD (doppelt-literal, offizieller g++-16-Baum)
Neuer Test + voller ctest 100%; clang-format-22==0; Mojibake==0; git status NUR neue Dateien +
tests/unit/CMakeLists.txt; system_axis.hpp/pmc_source.hpp/PODs byte-unberührt. Danach Review-Workflow
(Kadenz) + Rohdaten-Backup hierher + granulare Commits beide Remotes + CI strikt grün.
