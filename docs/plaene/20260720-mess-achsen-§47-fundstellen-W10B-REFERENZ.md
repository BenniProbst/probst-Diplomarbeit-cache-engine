# §47-Mess-Achsen-Fundstellen — W10-B-Impl-Referenz (Explore-Erhebung 2026-07-20)

> §47-Klärung: Mess-HAUPT = **Mess-Tooling** {Wallclock · Makro · Micro-über-Observer} (statisch/CT → CEB-Strecke [a,b,c] + kMeasurementAxisVersionLine-Stempel). Mess-UNTER = **Ablaufmethodik** {Debug · Messen · Release} (dynamisch, an CEB delegiert) + **Workloads/Datasets**. Die 16 `<measurement_categories>` = CSV-Spalten (binary_id-neutral), NICHT Auffächerungs-Achse.

## [WIDERSPRICHT] — aktive Korrektur beim W10-B-Umbau (Code fächert [a,b,c] falsch über die 16 Kategorien auf)
- `Code/external/comdare-cache-engine/libs/cache_engine/profile_facade/planner/plan_legend.hpp:69-83` — `measurement_combo()` leitet [a,b,c] aus `<measurement_categories>` ab → muss aus Mess-Tooling kommen. **KERN-Umbaustelle.**
- `.../planner/experiment_plan_director.hpp:83-92` — `PlanMeasurementCombo` „waehlt Mess-Achsen [a,b,c] aus `<measurement_categories>`". Umbauen auf Tooling.
- `.../planner/experiment_plan_director.hpp:953-965` — `measurement_combos_of(measurement_categories)` gibt genau 1 Combo → muss über N Tooling-Konfigs → N CEB-Strecken auffächern. **KERN-Umbaustelle (W10-B).**

## [NACHZIEHEN] — Schema-Elemente fehlen komplett (repo-weit 0 Treffer auf `measurement_tooling|run_methodology`)
- `libs/common/serialization/xml_config_parser/xml_config_parser.cpp:362-368,441-442` (+ `.hpp:253-263,330-332`) — parst NUR `<measurement_categories>`; NEU: `<measurement_tooling>`(Haupt) + `<run_methodology>`(Unter: debug|measure|release).
- `libs/cache_engine/profile_facade/validate_profile.hpp:41-43,302-311` — categories-Prüfung OK; Validierung für tooling/methodology ergänzen.
- Registry: `measurement/measurement_axis_registry.hpp` = korrekt die CSV-Spalten-Registry (16); die Tooling-HAUPT-Registry (Wallclock/Makro/Micro) muss NEU angelegt werden (§28: Mess-Modul-Registry).
- Beispiel-Profile (all_axes_golden.profile.xml u.a.): `<measurement_tooling>` + `<run_methodology>` ergänzen.

## [WIDERSPRICHT] — Architektur-Docs mit alter Zuordnung (additiver §47-Korrektur-Vermerk nötig)
- `docs/architektur/23_SYSTEMACHSEN_KONZEPT_WIEDERHERSTELLUNG_DOSSIER.md:108,110,187-188` — „Hauptachsen = 16 Mess-Kategorien" / „Mess hat KEINE Unter-Achsen". Direkt §47-widersprechend.
- `docs/architektur/16_E1_E4_KONSOLIDIERUNG_DOSSIER.md:124,151` — „Wallclock/Makro/Micro = E4-Auswertung/Spalten-Projektion" (nach §47: das ist das Tooling = Bau-Auffächerung).

## [NACHZIEHEN] — Ledger/Plandocs additive §47-Vermerke
- Ledger §28 (2148-2152) Mess-Registry-Inhalt · §42.b (2345,2347) Mess-HAUPT als Tooling benennen · §43 (2357) [a,b,c]=Tooling-Wahl präzisieren · §29 (2175,2181).
- Plandocs: 20260716-experiment-planer-codegen-DOSSIER:16,21 (`<measurement mode>` → run_methodology) · gesamtkonzept-DOSSIER:12 · archiv-KAPSELN:119,127,148,175 · inc2-BAUPLAN:168 · achsen-nachschlagewerk (beide) Mess-Achsen-Sektion.

## Bereits §47-konform (nur bestätigen, NICHT anfassen)
Ledger §47 + §32-F1/F7-Inline + :480 (categories=Spalten) · welle10-BAUPLAN NACHTRAG §47 (+W10-B-Auftrag) · xml-featurespace-KATALOG:66 · measurement_axis_registry.hpp (Inhalt) · validate_profile categories-Prüfung.
