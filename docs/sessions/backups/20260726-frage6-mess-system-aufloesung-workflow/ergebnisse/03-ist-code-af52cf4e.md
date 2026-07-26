# 20260726-frage6-mess-system-aufloesung-workflow / ist-code (agent af52cf4e)

runId: wf_3ed15f5c-7d7
agentId: af52cf4e26d1f2a83
label-Zuordnung: ist-code (Prompt-Marker-Deckung 67%)

---

IST-CODE (Stand 2026-07-26), alle Pfade relativ zu
`/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine`

A) REGISTRIES -- beide liegen im MESS-Modul (nicht in algorithm_profiles/)
- Der im Auftrag genannte Pfad `libs/cache_engine/algorithm_profiles/system_axis_registry.xml` EXISTIERT NICHT.
  Ist-Orte: `libs/cache_engine/include/cache_engine/measurement/system_axis_registry.xml` und
  `.../measurement/measurement_axis_registry.xml` (beide generiert, "NICHT von Hand editieren",
  system_axis_registry.xml:1-4 / measurement_axis_registry.xml:1-4, Ledger §28/§30 "Angebot").
- system_axis_registry.xml, 5 HAUPT-Achsen in DIESER Datei-Reihenfolge:
  compiler:10, extension_hardware:53, target_isa:98, scheduling:102, load_framework:114.
  Alle: `category="system_config" axis_kind="system_config" binary_id="never" stage="ct"`.
  Unter-Achsen: compiler->opt_level:13 (5 Optionen, stage=runtime) + atomic128:40 (2);
  extension_hardware->simd:55 (3); scheduling->scheduling_dims:104 (stage=**ct**, kind=fixed_enum_tuple,
  5 sub_dim:107-111); load_framework->workload:116 (runtime, option_source=user_load_profile_akten).
  **target_isa hat KEINE Unter-Achse** -- R-B (scheduling als Unter-Achse von target_isa) ist im Code
  NICHT vorhanden: scheduling ist heute eine eigenstaendige HAUPT-Achse auf Position 4.
  AUSSCHLUSS-Kommentar :8-9: extension_hardware_system_axis.hpp = DEPRECATED-Insel,
  hardware_isa_system_axis.hpp = HOST-Deskriptor, "treibt NICHT den Bau".
- Kein Symbol/Token `kSystemAxisOrder`, `external_utils` oder eine `os`-Achse existiert irgendwo in
  libs/ oder tools/ (grep leer). Position-1-Mess und os/external_utils sind bisher REIN konzeptionell.
- Mess-Seite zweigeteilt: measurement_axis_registry.xml Achse `measurement_category`:7 (16 Bausteine,
  :8-23) + Achse `collector`:25 (3) -- beide binary_id="never", "Werte = CSV-Spalten" (:5-6).
  Die HAUPT-Mess-Achse steht in `measurement/measurement_tooling_registry.hpp`:
  enum MeasurementTooling{WallClock,Macro,Micro} (Zeilen 27-31), kMeasurementToolingCount=3 (:34),
  kMeasurementToolingRegistry ids "wallclock"/"macro"/"micro" (:44-48), Index==Enum static_assert-gesichert.

B) kSystemAxisCodeVersions (include/cache_engine/abi/system_axis_code_versions.hpp)
- kSystemAxisCodeCount = 5 (:28); Liste :33-37 in der Reihenfolge
  compiler / extension_hardware / target_isa / scheduling / load_framework, je "v1.0.0".
- Selbst-Deklaration :30-31: "Reihenfolge == kanonische System-Stempel-Ordnung (Section 43, W12-A-1)".
  Also identisch zur XML-Datei-Reihenfolge (A). KEIN Mess-Eintrag, KEIN Organ-Eintrag, kein os/ext_utils.
- static_assert :49-50 haelt nur "5 Eintraege, axis/version nie leer" -- die REIHENFOLGE ist nirgends
  compile-time gegen die XML oder gegen eine zweite Liste gegatet (Drift-Luecke).

C) Zweiter, ANDERER 5er-Satz: registry_to_axis_levels.hpp::build_system_axis_levels() :117-126
- Liefert 5 Levels: page_type, simd_extension, general_hardware, telemetry, isa (:120-124) --
  reflektiert aus den ORGAN-Registries (axes26-Aliase T17/T18/T19/T10/T12, :69-71/:61/:63).
- Das ist eine voellig andere Menge als B). Doku-Begruendung :110-116 (INC-2c telemetry, INC-2d isa).
- Einziger echter Produktions-Konsument: der telemetry-Gate in system_axes_version_suffix
  (profile_run_facade.cpp:398-401) -- explizit als "Anti-Drift"-Beleg kommentiert.
- Organ-Seite: append_organ_core_axis_levels 15 Achsen :92-108; Tail :131-139 mit BINDENDER Reihenfolge
  queuing_q1, queuing_q2, persistence_target(ORG-18), dann 4 Shapes (:128-130 erklaert die Bindung).

D) plan_legend.hpp (profile_facade/planner/) -- die Legenden-/Namens-Ordnung
- Vertrag :18-20: Stufe1 "ceb:build:[a,b,c]", Stufe2 "tier:build:[d,e,f][g,h,i]:chunk<k>",
  Stufe3 "measure:[a,b,c][d,e,f][g,h,i]".
- [a,b,c] = MESS-TOOLING-Combo, Single-Source kMeasurementToolingRegistry (:86-92); die 16 Kategorien
  sind ausdruecklich NICHT die Auffaecherung (:94-100).
- [d,e,f] = `system_perm(opt_id, simd_id)` :103-105 -- nur ZWEI Tokens (opt x simd), obwohl die
  System-Registry 5 Haupt-Achsen fuehrt. os/external_utils/scheduling stehen in KEINER Legende.
- [g,h,i] = organ_reference() :110-115, die ersten 3 aus ex::kCompositionAxisNames (kOrganReferenceAxisCount=3, :44).
- Ordnung im Job-Namen: MESS zuerst. ceb_build/emit/trigger tragen NUR [a,b,c] (:120-122);
  tier_build_job mit [d,e,f][g,h,i] ist ENTFERNT/DEPRECATED (:124-130, §62-B-Batch-Emission);
  heute tier_batch_build_job(host) :145 (Mess-Identitaet steht im Batch-KOPF, nicht im Namen) und
  measure_batch_job(combo, host) :146-147 -> combo (Mess) vor host.
  Kommentar :141-144 kodiert die Trennung explizit: BAU-/PRUEF-Testate tragen je Schritt nur
  zelle=[d,e,f][g,h,i], "System- und Organ-Layer NIE verschmolzen"; NUR MESS-Testate tragen alle drei
  Klammern. Das ist im Code die zweistufige Sicht: Mess = aeussere Benennungs-/Ordnungs-Klammer,
  System/Organ = innere Bau-Koordinaten.

E) Suffix-/Stempel-Ordnung -- DREI verschiedene, im Code dokumentierte Reihenfolgen (W-13-Kern)
- system_axes_version_suffix(), profile_facade/profile_run_facade.cpp:371-407 (TU-lokal, `namespace {}`):
  Reihenfolge literal `+ext=` `+cxx=` `+opt=` (:378-380), dann `+ceb=<ABI_MAJOR>.<CodegenMinor>` (:385-386),
  dann bedingt `+target=` nur wenn Ziel != x86_64 (:389-391), dann bedingt `+tel=silent` (:397-402),
  dann `+bt=Debug` via tlz::build_type_version_suffix() (:405).
- Perm-Loop-Reihenfolge, profile_run_entry.hpp:780-781: `+cxx` `+opt` `+ext`(nur wenn != no_extension) `+bt`.
- print_cache_key_facade, profile_run_facade.cpp:1095-1097 spiegelt die Perm-Loop-Reihenfolge; der
  Kommentar :1080-1083 stellt fest: "system_axes_version_suffix nutzt eine ANDERE Reihenfolge
  (+ext+cxx+opt) -- fuer die GN-Cluster-Zellen und die YAML-GN_PREFIX ist die perm-loop-Reihenfolge
  AUTORITATIV". Zwei konkurrierende Ordnungen sind also heute bewusst koexistent.
- Wo Mess den Build-Key beruehrt: ArtifactCache::cache_key_prefix, builder/artifact_transport/
  artifact_cache.hpp:245-248 -> `<build_version>+ceb=<maj>.<min>+mtool=<combo>+mrg=none`.
  Mess (`+mtool`) steht hier am ENDE, nicht an Position 1; `+mrg=none` ist das reservierte
  Merge-Stempel-Segment (:243-244, #37/K6a). Begruendung :188-189: die Combo wirkt NICHT auf die
  Perm-build_version, deshalb separates Key-Segment gegen Kollision.
- Vier GETRENNTE Stempel-Zeilen in include/cache_engine/abi/anatomy_version_stamp.hpp:
  organ_stamp_line 17 Eintraege :42-60; system_stamp_line iteriert kSystemAxisCodeVersions, Marker
  "code" :71-81; measurement_stamp_line(tooling) 1 Eintrag :94-104, Mengen-Form :112, Vollmenge :130,
  aus Combo-Legende :143-161. §43-Invariante :89-93: NUR die Mess-HAUPT-Achse wird gestempelt,
  run_methodology/Workloads NIE. Mess- und System-Zeile werden nirgends fusioniert.
- system_stamp_line traegt heute NUR Code-Versionen, nicht die Zellwerte (:64-70: Emitter ist
  "system-blind", W4-B-Invariante; Zellwerte leben im .version-Sidecar).

F) Lager (builder/bestandslog/bestandslog_document.hpp) -- heute FLACH, nicht kaskadiert
- Top-Split = GENUS: EIN XML je Genus `binary` | `measurement` (:5-10, Attribut genus :33).
  Das ist im Ist-Code die einzige realisierte "Mess-vor-Bau"-Ordnungsebene.
- Zell-Koordinaten als GETRENNTE Attribute in fester Emitter-Reihenfolge
  `key_sha512, combo, opt, simd, pfad, bytes, stempel, done_utc` (Grammatik :36-37, Emitter :313-316) --
  combo (Mess) steht direkt hinter dem Hash, also VOR opt/simd. Eindeutigkeit = TUPEL
  (key_sha512, combo, opt, simd) (:26-27, Vergleich :200-201), explizit "KEINE String-Konkatenation
  als Schluessel-Fusion" (:27, §66-N3).
- Das `stempel`-Attribut fuehrt nur `[d,e,f][g,h,i]+bt=Release` (:38) -- die Mess-Klammer [a,b,c]
  steht NICHT im Stempel, sondern im eigenen combo-Feld (BuildZelle::combo, :166 "[d] Mess-/Tool-
  Kombination (COMDARE_MEASUREMENT_COMBO)"). Keine Verzeichnis-Kaskade, keine Ordner-Baeume: die
  Ordnung ist Attribut-Ordnung innerhalb eines flachen `<bestand>`.

G) BEFUND ZUR FRAGE (nur was der Code belegt)
- Zwei Ebenen sind im Code bereits real getrennt: (1) Mess steht als AEUSSERSTE Benennungs-/
  Ordnungsklammer (plan_legend Stufe1/3, bestandslog genus + combo-Feld vor opt/simd, +mtool-Key-Segment),
  (2) die System-STEUERUNG kennt Mess nicht (system_perm = opt x simd, system_stamp_line = 5 Code-
  Versionen, Bau-Testate ohne [a,b,c]). Ein Widerspruch ist im Ist-Code nicht kodiert.
- kSystemAxisCodeVersions enthaelt heute KEIN Mess-Element -- Mess-Position-1 ist dort nicht abgebildet
  und war es nie; die Mess-Version lebt separat in measurement_tooling_registry.hpp.
- OFFENE Ist-Luecken gegenueber der Frage: kein kSystemAxisOrder-Symbol; keine os-/external_utils-Achse;
  scheduling ist HAUPT-Achse, nicht Unter-Achse von target_isa; zwei disjunkte 5er-Saetze (B vs C);
  zwei konkurrierende Suffix-Reihenfolgen (E); Lager flach statt kaskadiert (F).
