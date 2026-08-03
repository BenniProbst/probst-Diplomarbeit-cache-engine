# A13-M3 AUSFÜHRUNGS-DOSSIER (03.08.2026, Planung READ-ONLY — dritter Anlauf, frisch erhoben)

> **Zweck:** M3 ist das EINE irreversible Neuanker-Fenster des Stempel-/Versions-Systems. Dieses Dossier macht M3 ohne Sucharbeit startklar: Fundstellen, Zählung, Commit-Plan, Wachen, Risiken.
> **Basis-Stand der Inventur:** ce `fc47c5d9` auf `development` (lokal, verifiziert per `git -C ... rev-parse HEAD`). Ergänzend gezählt: Welle-2d-Flag-Worktree `/home/comdare/wt-w2d-Flag-Grammatik` @ `3dfb65ad` (CX-W5/W6 gebaut, ungelandet).
> **Harte Vorbedingungen (Owner-Entscheid ~21:2x UTC 02.08.):** (1) Welle 2d GELANDET (CX-W5/W6 = Migrations-Naht-Fläche; **CX-W6 AllStrategies-Deckung ist logische Vorbedingung für ENFORCE=1**; CX-W1/W2/W4 Transport). (2) **Q-M3-GATE**: primär (a) Codex-Zweitreview auf funktionierender Umgebung (nicht prod1, bwrap defekt), sonst (b) Fable-xhigh-Adversarial-Review MIT ausdrücklichem Ledger-Vermerk. Verschiebung (c) ausgeschlossen (Trigger Do 07.08.).
> **Quellen:** BAUPLAN 02.08. (K-1/K-3/K-4/K-6, §1-A13), OWNER-Entscheide 02.08. (E2, Q1/Q2/Q3/Q10, Nachträge), PAUSE-Doc §4 Punkt 3, LEDGER-A13-Blöcke (:3602–:3652), Code-Ist wie unten je Fundstelle. **NACHTRAG 03.08. (eingearbeitet):** Review-Neulauf-Befunde aus `super docs/sessions/backups/20260803-resume-halbzeit-flag-review-gesamt-audit/` — Gesamt-Audit GA-01/GA-05/GA-06/GA-07 (fable-adversarial auf 7150cc51), Wellen-Zweitpass Z-02/Z-03/Z-09/Z-10, Flag-Review LANDEBEREIT (CX-W5/W6 geschlossen, 331/331). Alle übernommenen Befunde am Ist gegengeprüft.

---

## 1. Fundstellen-Inventur je Soll-Punkt

Wurzel-Kürzel: `ce = Code/external/comdare-cache-engine`, `abi = ce/libs/cache_engine/include/cache_engine/abi`, `meas = ce/libs/cache_engine/include/cache_engine/measurement`, `pf = ce/libs/cache_engine/profile_facade`, `bld = ce/libs/cache_engine/builder`.

### (a) merge-Zeile ENTFERNEN (Owner-E2: „Merge Zeile kann daher nicht existieren")

Vorab-Klarstellung: **Meta-Meta ans Realm-Zeilen-Ende ist BEREITS M2-vollzogen** (Ledger [5]/[6]: load_framework als Klammer-Anhang am Mess-Zeilen-Ende in `abi::measurement_stamp_line` + consteval-Zwilling `bld/ceb_version_stamp.hpp:130-153`; Organ-Meta-Meta-Anhang `abi/anatomy_version_stamp.hpp:111-114`). M3-Rest von (a) ist ausschließlich die merge-Zeilen-Entfernung.

| Fundstelle | Ist-Zitat (kurz) | M3-Wirkung |
|---|---|---|
| `abi/anatomy_module_abi_v1_decl.hpp:175-176` | `char const* merge_line; ... std::uint64_t merge_len;` | POD-Felder RAUS |
| `abi/anatomy_module_abi_v1_decl.hpp:168-174` | K7a-Kommentar „der DRITTE Tier-Binary-Stempel = Merge-Kombination" | Kommentar-Block raus (K-6) |
| `abi/anatomy_module_abi_v1.hpp:129-167` | `COMDARE_ANATOMY_VERSION_STAMP_MERGE(organ_lit, system_lit, measurement_lit, merge_lit)`; `kG[] = merge_lit` (:135), POD-Init-Slots :156-157, Fingerprint-Call :136-137 | _MERGE-Form ENTFÄLLT; `_M` (:172-173) wird die Vollform; 2-arg (:182) leitet weiter |
| `abi/anatomy_version_stamp.hpp:287-330` | `merge_stamp_line(strategy, pruefling, merged_axes)` = kMergeAxisVersionLine-Renderer | ENTFERNEN — kein produktiver Aufrufer in libs (grep-belegt: nur Definition + Tests + Emitter-Parameter) |
| `bld/codegen/adhoc_emitter.hpp:86ff` | `render_adhoc_module_source(..., merge_stamp, measurement_stamp)`; 4-arg-_MERGE-Zweig :131-143 | merge_stamp-Parameter + _MERGE-Zweig raus; 2/3-arg-Fallunterscheidung bleibt |
| `pf/sota_catalog.hpp:113-125` | `render_sota_module_source(fq_type, header, merge_line = {})`; :123 emittiert `COMDARE_ANATOMY_VERSION_STAMP_MERGE("", "", "", "<merge>")` | merge_line-Parameter raus; siehe (d) |
| `pf/sota_catalog.hpp:165ff` | `render_directive_merge_module_source(..., merge_line = {})` | dito |
| `pf/lazy_adhoc_source_gen.hpp:208` | `render_adhoc_module_source(0, macro_args, organ, system, /*merge_stamp=*/{}, measurement_stamp)` | Aufruf-Anpassung |
| `pf/lazy_adhoc_source_gen.hpp:253-263` | `lazy_adhoc_fingerprint_for` — „Preimage = concat(organ+system+measurement+merge)... merge=""" | Laufzeit-Zwilling: merge fällt aus dem Preimage, siehe (c) |
| `bld/bestandslog/bestandslog_index.hpp:9-10, 48-49` | „append organ; system; measurement; merge -> identisch zu abi::anatomy_fingerprint_hex" | Lager-Key-Zwilling: Preimage-Ordnung mitziehen, siehe (c) |
| `pf/merge_plan.hpp` | merge_mode_to_strategy etc. | **BLEIBT** — Owner-Q2: die Merge-Strategie WIRD durchgeführt, lebt im Stempel nur über 'e' + erweiterte Namen. Nur Stempel-Bezüge/Kommentare (K-6) ändern |
| Tests | `tests/unit/test_m_w12_stamp_bausteine.cpp` (10 merge-Stellen, POD-Init :724-741 mit `"" , 0u`-merge-Slot), `tests/unit/thesis_tiere/test_merge_plan_directive.cpp` (9), `tests/unit/test_g3_sha512_index.cpp:37` (`kMerge`) | Pins im SELBEN Commit nachziehen (§68c-Kommit-Regel) |

### (b) POD `AnatomyVersionLines` 136→120 Bytes, Layout 5→6, K-4-Gleichheits-Wache

- `abi/anatomy_module_abi_v1_decl.hpp:153-197` — struct; merge_line/merge_len (:175-176) raus ⇒ 18→16 Felder, **sizeof 136→120** (−16 = 1 Zeiger + 1 uint64).
- `:206` — `inline constexpr std::uint32_t kAnatomyVersionLinesLayout = 5;` ⇒ **6** (+ Doku-Zeile „5 -> 6: merge_line/merge_len ENTFERNT — ERSTER Feld-Entfall, kein Append").
- `:213-215` — `static_assert(sizeof(AnatomyVersionLines) == 136, ...)` ⇒ 120.
- `:221-223` — `stamp_pod_has_entries` = `return v.stamp_layout_version >= 5;` ⇒ **K-4: GLEICHHEITS-Wache `== 6`**. Begründung (tragend): der Feld-ENTFALL verschiebt die Offsets von `sha512_line`/`organ_entries`/... um −16; ein `>=`-Prädikat würde ein v6-POD mit v5-Offsets lesen (bzw. umgekehrt) — genau der Fehler, den Append-only bisher ausschloss. Konsumenten-Ist: nur Definition + `test_m_w12:743` (extern: super/prtart je 0 Treffer, grep-belegt 03.08.).
- Test-Pins: `test_m_w12:432` (`EXPECT_EQ(kAnatomyVersionLinesLayout, 5u)`), `:744` (`EXPECT_EQ(v.stamp_layout_version, 5u)`), POD-Aggregat-Init `:724-741` (18→16 Initialisierer).
- Entry-POD `AnatomyStampEntryV1` (48 Byte) und die reserved-Bit-Belegung (Bit 0 'e', Bits 1-2 HW-Flag mit c==0-Default, Bits 3-5 Meta-Ebene; `abi/anatomy_stamp_entries.hpp:86-149`) bleiben UNVERÄNDERT.

### (c) `anatomy_fingerprint_hex` HART brechend via OverlayHash-Typ (K-1)

- `abi/anatomy_fingerprint.hpp:66-85` — Ist-Signatur: `anatomy_fingerprint_hex(organ, system, measurement, merge, overlay_source_hash = kOverlaySourceHash)` — 4 positionale `string_view` + Default-5. Preimage-Ordnung `:74-78` (append organ/system/measurement/merge/overlay).
- **Die Falle** (Bauplan „ceb_version_stamp.hpp:136-Falle"; Ist heute `bld/ceb_version_stamp.hpp:165-167`): `kCebFingerprintArray = anatomy_fingerprint_hex("", "", kCebMeasurementStamp, "")`. Würde M3 die Signatur naiv auf `(organ, system, measurement, overlay=default)` verkürzen, bliebe dieser 4-arg-Aufruf GÜLTIG — das vierte `""` rutschte still von merge auf overlay. Kompiliert, Semantik verschoben, niemand merkt es.
- **K-1-Bauform:** neuer benannter Typ `abi::OverlayHash` (explicit-Konstruktor um `string_view`; Single-Source neben `kOverlaySourceHash` `:52-55`), neue Signatur `anatomy_fingerprint_hex(organ, system, measurement, OverlayHash)`, PLUS **deleted overload** der alten 4/5-`string_view`-Form mit benanntem Fehlertext („merge-Zeile existiert nicht mehr (Owner-E2); 4. Argument ist der OverlayHash-TYP"). Jeder Alt-Aufruf bricht compile-hart mit Ansage.
- **Zwillinge, die im SELBEN Commit auf die neue Preimage-Ordnung `concat(organ+system+measurement+overlay)` ziehen MÜSSEN** (sonst Lager-Key-Drift, `bestandslog_index.hpp:15`):
  1. Makro-Innenseite `abi/anatomy_module_abi_v1.hpp:136-137`;
  2. Laufzeit-Zwilling `pf/lazy_adhoc_source_gen.hpp:253-263` (`lazy_adhoc_fingerprint_for`);
  3. Lager-Key `bld/bestandslog/bestandslog_index.hpp:54` (`derive_key_from_lines(span<string_view const>)` — heute 4 Zeilen via `frozen_lines()`; künftig 3 Zeilen + Overlay-Glied) + `BinaryKeyPolicy::derive_key`;
  4. CEB-Selbst-Fingerprint `bld/ceb_version_stamp.hpp:165-167` (kCebFingerprint shiftet — erwartetes Byte-Ereignis, nur Log-Kopf/--version).
- `COMDARE_OVERLAY_SOURCE_HASH` bleibt `""` — M3 entscheidet NICHT die Overlay-Dateimenge (Owner-vorbehalten, `anatomy_fingerprint.hpp:49-51`); der Typ ist reine Signatur-Härtung.

### (d) SOTA `render_sota_module_source` erzeugt VOLLE Stempel-Zeilen (K-3)

- Ist: `pf/sota_catalog.hpp:113-125` — SOTA-/PRT-ART-Module werden OHNE organ/system/measurement-Stempel emittiert (nur `COMDARE_DEFINE_ANATOMY_MODULE`, optional `_MERGE("","","",merge)` :123). Produktions-Aufrufer `:334`, `:475`, `:526` — alle 2-arg. ⇒ SOTA-Binaries sind fürs SHA512-Skip-Gate identitätslos (Bauplan K-3: „sonst bleiben SOTA-Binaries identitätslos fürs Gate").
- Soll: `render_sota_module_source` (und `render_directive_merge_module_source` `:165ff`) emittieren die VOLLEN Zeilen (organ/system/measurement) über dieselben Kompositions-Quellen wie der adhoc-Pfad (`compose_organ_stamp_line`/`system_stamp_line`/`measurement_stamp_line` — „beide Emitter-Pfade reichen denselben compose... durch", adhoc_emitter.hpp:97). merge-Parameter entfällt per (a).
- Golden-Abgrenzung: die SOTA-Quelltext-Änderung berührt den CRC-Anker NICHT (der rechnet über die 131072 Katalog-binary_ids, s. §2-TABU); SOTA-Binary-Bytes ändern sich — im M3-Fenster ohnehin Global-Shift.

### (e) Migration ALLER v1.0.0-Literale → v1.0.0c + ENFORCE=1 im SELBEN Commit

- ENFORCE-Schalter: `meas/algo_semver.hpp:108-110` (`#define COMDARE_VERSION_HW_FLAG_ENFORCE 0`). Kommentar `:68-73` verlangt wörtlich: Define auf ON **im selben Commit** wie der Literal-Zug („wer die Migration ohne das Define landet, laesst die Pflicht undurchgesetzt").
- Naht-Liste `:74-107` mit Klassen (a)-(d) und **bindenden grep-Kommandos** (Doktrin: aus Diff/grep ableiten, nie handgepflegt). Zählung: siehe §2.
- Gated-Wachen-Träger (brechen beim Scharfschalten mit; grep `COMDARE_VERSION_HW_FLAG_ENFORCE` = 9 Dateien): `axis_variant_version_table.hpp`, `system_axis_code_versions.hpp`, `measurement_tooling_registry.hpp`, `measurement_framework_registry.hpp`, `external_utils_family_axis.hpp`, `operating_system_probe.hpp`, `hardware_meta_meta_axis.hpp`, `algo_semver.hpp`, `test_m_w12_stamp_bausteine.cpp`.
- B6-Doppel-Absicht: `system_axis_code_versions.hpp:79/:84/:90` — die drei static_asserts auf `"v1.0.0"` gehen im SELBEN Commit auf `"v1.0.0c"` (Ledger :3619).
- Q10 (Owner ~19:5x): 'v'-Präfix NUR im Roh-Literal; **gerendert bleibt präfixfrei** — der M3-Neuanker rendert `@1.0.0c`.
- .algos-Sidecar: `compose_algo_signature` serialisiert `W::algo_version` VERBATIM (Naht-Klasse (c), algo_semver.hpp:86-88) ⇒ die Migration ist AUCH ein Sidecar-Byte-Ereignis (Skip-/Rebuild-Kaskade) — im EINEN Fenster deklariert.

### (f) B3-Frozen-Vektor-Neuanker (0f0c0eb4...c31b93)

- Pin-Stellen (BEIDE in EINEM Commit — Lane-B-Drift-Verbot, im Code selbst kodifiziert):
  - `tests/unit/test_g3_sha512_index.cpp:34-43` — `kOrgan/kSystem/kMeasure/kMerge` + `kFrozenFingerprintV1` + `frozen_lines()` (array 4→3 Zeilen + Overlay-Glied);
  - `tests/unit/test_m_w12_stamp_bausteine.cpp:511-530` — derselbe Vektor mit static_assert-Anker; Kommentar `:30-33` (g3) sagt wörtlich: „NEU EINZUFRIEREN ist er mit A13-M3, wenn die merge-ZEILE ersatzlos entfaellt ... Neuanker gehoert in EINEN Commit mit test_m_w12".
- **Beim Neuanker MIT zu erledigen** (Fixture-Zementierungs-Lehre, im test_m_w12-Kommentar `:507-510` bereits notiert): die Literale modernisieren — `kSystem` trägt `compiler=code@1.0.0` (seit O-8 abgeschaffte System-Achse), `kMeasure` `wallclock@1.0.0` ohne Achsen-Präfix. **Empfehlung: Fixtures beim Neuanker gleich in der END-Form einfrieren (moderne Achsen + `@1.0.0c`)** — sonst entstünde durch die Literal-Migration (e) ein ZWEITER Neuanker im selben Fenster.
- Neuer Hex-Wert wird NICHT vorausberechnet: beim Bau aus dem literalen Compiler-/Test-Output einfrieren (Kein-✓-ohne-Ausgabe-Doktrin).

### (g) K-6-Kommentar-Sweep (per grep, nicht per Hand)

Sweep-Kommando (Kandidaten-Erhebung am Migrations-Ende; 0 Rest-Treffer = fertig):
```
grep -rn "merge_line\|merge_len\|merge_stamp\|organ+system+measurement+merge\|vier Stempel\|4 Stempel\|VIER String\|sizeof 136\|(136 auf\|Layout 5\|5-Zeilen" ce/libs ce/tests --include=*.hpp --include=*.cpp
```
Heutige Kandidaten-Dateien (grep-Ist 03.08.): `anatomy_module_abi_v1_decl.hpp`, `anatomy_module_abi_v1.hpp`, `anatomy_fingerprint.hpp`, `anatomy_version_stamp.hpp:304`, `adhoc_emitter.hpp:106`, `sota_catalog.hpp:133`, `merge_plan.hpp:15`, `lazy_adhoc_source_gen.hpp`, `bestandslog_index.hpp:9/:48`, `bestandslog_factory.hpp`, `bestandslog_document.hpp`, `ce/libs/cache_engine/src/sha512/ctsha512.hpp` (+ `test_ctsha512.cpp:7-8` „6. Stempel-Zeile ... organ+system+measurement+merge"), `test_m_w12_stamp_bausteine.cpp`, `test_merge_plan_directive.cpp`. Zusätzlich stale werdende Aussagen: `algo_semver.hpp:359` („heutiger Stand ALLER Algos" — nach Migration falsch), `:383`, `axis_variant_version_table.hpp:50/:85/:96`, `system_axis_code_versions.hpp:7/:26/:39`, Registry-Kommentare (`measurement_tooling_registry.hpp:40/:102-103`, `measurement_framework_registry.hpp:37`), `anatomy_version_stamp.hpp:142/:211`.

### (h) kOsProbeVersion-3 (OS-U3, Commit `d115e4cc`) + Naht-Listen-Nachzug (GA-05 MITTEL / Z-10 KLEIN — Review 03.08., am Ist bestätigt)

- `meas/operating_system_probe.hpp:115` — `inline constexpr std::string_view kOsProbeVersion = "v1.0.0";` (EIN Literal, drei probe_ids `os_probe.<fam>@v1.0.0` via `:177/:202/:227`). Gated ENFORCE-Wache vorhanden (`:292-302`, bricht beim Scharfschalten mit — Z-10: „MECHANISCH GESICHERT", anders als CX-W5 vor dem Fix); Naht-Kommentar `:35-37` vorhanden.
- **BEFUND (GA-05/Z-10, deckungsgleich mit eigener Erhebung):** Die ZENTRALE Naht-Liste `algo_semver.hpp:74-107` führt die Klasse nicht, und **KEINES der drei als BINDEND deklarierten Erhebungs-Kommandos findet sie** ((a) greppt drei namentlich genannte Dateien, (d) greppt `axis_code_version *=`, der Absicherungs-grep greppt `meta_meta_version_cpu_pflicht` — kOsProbeVersion fällt durch alle drei). Die „nie handgepflegt"-Selbst-Erhebung ist damit nachweislich unvollständig. M3 muss (i) `kOsProbeVersion` → `"v1.0.0c"` migrieren, (ii) die Naht-Liste um die Klasse ergänzen, (iii) **die bindende Erhebung auf den generischen Wachen-grep umstellen**, der die Klasse VOLLSTÄNDIG liefert (GA-05-Vorschlag, am Ist 5 Produktions-Träger): `grep -rn 'ce_owned_version_satisfies_cpu_enforce\|ce_owned_version_is_wellformed' libs tests tools apps` (axis_variant_version_table.hpp:103, system_axis_code_versions.hpp:107, operating_system_probe.hpp:276, measurement_framework_registry.hpp:59, measurement_tooling_registry.hpp:65).
- **Klassen-Buchstaben-Kollision (verifiziert):** Der 2d-Flag-Cluster (`3dfb65ad`, CX-W5) hat im Worktree BEREITS eine Klasse **(e) = PLANER-SELBST-Version** in `algo_semver.hpp:108` angelegt (Flag-Review: „Naht-Klasse (e) ... nur ///-Kommentar"). Nach der 2d-Landung ist (e) vergeben — kOsProbeVersion wird der NÄCHSTE freie Buchstabe (voraussichtlich (f)); Buchstaben am gelandeten Ist vergeben, nicht aus diesem Dossier abschreiben.
- Beachte: die probe_id ist Teil der Provenienz-Kette (OS-U4-Token-Tripel) — die Migration ist ein deklariertes probe_id-Byte-Ereignis, kein Stempel-Ereignis (A-15-Neutralität der Probe bleibt).

### (i) TP1-Lager-Neu-Inventarisierung (NACH der M3-Landung)

- Ledger [8] / Bauplan §0: der Fingerprint-Global-Shift (M2 vollzogen, M3 vollendet) entwertet parallel entstandene TP1-Probe-Bestände (minio) — Schnittstelle S2 an die Lager-Strecke ist gemeldet. Operativer Nach-Lande-Schritt, KEIN ce-Commit: Bestände gegen die neuen v6-Fingerprints/Lager-Keys neu inventarisieren; Alt-Bestände nach Backup-Doktrin additiv stehen lassen (Messdaten/Rohdaten nie löschen).

### (j) Zweiteilung M3a/M3b mit sauberem Commit-Schnitt

- Quellen-Einordnung (ehrlich): Der Bauplan-Wortlaut „M3a A13-frei sofort / M3b Stempel-Konsum nach A13-Lese-API" steht im A7-Strang (E-04-P2). Für A13-M3 selbst wird der Schnitt als COMMIT-Disziplin übernommen (Auftrags-Vorgabe): **M3a = Anteile ohne Layout-/Preimage-Wirkung** (vorbereitend, einzeln grün), **M3b = das EINE Byte-Ereignis** (Neuanker). Koordinations-Folge: E-04-P2-M3b (Stempel-Konsum) startet erst NACH A13-M3 (v6-Lese-API steht).
- Konkreter Schnitt: siehe §3.

### (k) GA-01 [BLOCK, NEU 03.08.]: Fingerprint-Preimage ist NICHT injektiv — Entscheidungs-Punkt fürs M3-Fenster

- **Befund (am Ist bestätigt, Kollisions-Demo im Audit-JSON):** Das Preimage entsteht als reine Byte-Konkatenation von fünf variabel langen Feldern OHNE Trenner/Längenpräfix (`abi/anatomy_fingerprint.hpp:69-79` append-Lambda; Laufzeit-Zwilling `pf/lazy_adhoc_source_gen.hpp:268-275` `preimage += ...`; Konsument `bld/bestandslog/bestandslog_index.hpp:99-104` LagerKey.sha). Jede Feldgrenzen-Verschiebung ergibt dasselbe Preimage — literal demonstriert: `fp("","",X,"") == fp(X,"","","") == fp("",X,"","")` und die Ein-Zeichen-Grenzverschiebung `fp("...@1.0.0;","...") == fp("...@1.0.0",";...")`. Damit ist „der Fingerprint deckt alle Zeilen" (F7/GATE-5-Fundament des SHA512-only-Skip-Gates) nicht beweisbar. Blast-Radius heute begrenzt (LagerKey ist Tupel {sha, ZellKoordinaten}; Zell-übergreifende Kollisionen fängt die Koordinate) — INNERHALB einer Zelle bleibt die Grenzen-Mehrdeutigkeit, und die Reachability wächst mit Overlay-Scharfschaltung. Keine Injektivitäts-/Separator-Probe existiert (4 Test-Aufrufe, alle Positiv-Belege; `test_m_w12:814` NUTZT den Kollaps sogar).
- **Termin-Logik (der Grund für BLOCK):** Eine Trenner-/Längenpräfix-Härtung IST ein globales Fingerprint-Ereignis. M3 ist per Bauplan das EINE Neuanker-Fenster — nach dem Trigger kostet dieselbe Härtung einen ZWEITEN globalen Neuanker über 1.572.864 Binaries. Die Entscheidung muss VOR dem M3-Bau fallen: **Owner-Frage OF-M3-1 (§6)**.
- **Bauform bei Härtung (Option A):** Domain-Separator zwischen ALLEN Preimage-Gliedern, Zeichen außerhalb des Stempel-Zeichenvorrats (`=@;.+_[]`+alnum ⇒ `'\n'` ist beweisbar kollisionsfrei) — oder Längenpräfix je Glied. Fällt in C3 (dort werden ohnehin alle 4 Zwillinge in EINEM Commit umgebaut, K-1; Frozen-Neuanker ohnehin fällig ⇒ Mehraufwand marginal). Der `bestandslog_index.hpp:48-49`-Kommentar („Kein zweiter Delimiter, sonst driftet der Lager-Key") dreht sich mit um. NEUE Pflicht-Probe: Injektivitäts-/Separator-Negativprobe (die drei Demo-Kollisionen müssen VERSCHIEDENE Fingerprints liefern).

### (l) A13-M2-Nachbesserungen aus dem Zweitpass: Fenster-Einordnung Z-02 / Z-03 / Z-09 (+ GA-06-Beifang)

Alle drei sind **byte-neutral für die kanonischen Renderer-Zeilen** (CT-Parser-/Wachen-Ebene, kein Fingerprint-Ereignis) ⇒ formal A13-frei = M3a-fähig. Einordnung nach Dringlichkeit relativ zum Fenster:

- **Z-03 [MITTEL] — MUSS VOR C4 (ENFORCE=1):** Die Meta-Meta-Versions-Wachen (`meas/hardware_meta_meta_axis.hpp:129-140`) umgehen die B12-Single-Source: `meta_meta_version_wohlgeformt` prüft experimental gar nicht, `meta_meta_version_cpu_pflicht` ruft `version_satisfies_cpu_only_policy` statt `ce_owned_version_satisfies_cpu_enforce` ⇒ `axis_code_version = "v1.0.0ce"` an einer ce-EIGENEN Meta-Meta passiert ALLE Wachen (Compile-Beweis im Audit) und reiste als Prüfling-Experiment durch Lager/SHA512-Gate. Fix: beide Zwillinge auf die B12-Single-Source (`ce_owned_version_is_wellformed` / `ce_owned_version_satisfies_cpu_enforce`) umstellen + Negativ-Probe `"v1.0.0ce"` bricht. C4 verlässt sich auf die gated Deckung ALLER Klassen — ohne Z-03-Fix schaltet ENFORCE eine löchrige Wache scharf. ⇒ **M3a-Commit, zwingend vor C4.**
- **Z-02 [MITTEL] — SPÄTESTENS IM FENSTER (vor dem SHA512-Gate-Aufsatz):** Gruppen-Grenzen-Kollision der Klammer-Grammatik (`abi/anatomy_stamp_entries.hpp:196-252`): `a=b@1.0.0;[c=d@1.0.0];[e=f@1.0.0]` und `a=b@1.0.0;[c=d@1.0.0;e=f@1.0.0]` (byte-VERSCHIEDEN, beide als gültig zugesichert `:349`) liefern IDENTISCHE (Text, Ebene)-Entry-Arrays — die M2-Verlustfreiheits-Zusage gilt nur für den kanonischen Renderer-Fall. Emitter-seitig heute unerreichbar, aber die Grammatik ist die EINE Wahrheit für die kommenden POD-Konsumenten (SHA512-Gate/G-E6/A2 NACH M3). Zwei Wege: (i) **Grammatik-Verschärfung F6** — Geschwister-Gruppen-Folge `];[` auf gleicher Ebene als Fehlform (kanonische Ein-Gruppen-Form je Anhang-Position erzwingen; der Renderer erzeugt ohnehin genau EINE Gruppe je Realm-Ende) — CT-only, dreht den Positiv-Assert `:349`; (ii) Gruppen-Zugehörigkeit in die Entry-POD-reserved-Bits — POD-Semantik-Ereignis, dann zwingend C3. **Empfehlung: (i) als M3a-Commit** (Q1-konform: die Klammer-ANZAHL kodiert die Ebene, nicht die Gruppen-Partitionierung; Lead-/Review-Entscheid, kein Owner-Gate).
- **Z-09 [KLEIN] — im Fenster sinnvoll, gleicher Header:** Entry-Parser fail-open (`anatomy_stamp_entries.hpp:254-289`): fehlendes `=`/`@` und ungültiger Flag-Schwanz fallen still auf leere Felder/`@0.0.0` (Probe `:458-465` schreibt es fest) — zwei byte-verschiedene Defekt-Formen kollabieren im POD, entgegen der Strenge-Zusage `:60-61`. Fix: entry-seitig hart brechen (kanonische Renderer-Zeilen sind wohlgeformt, flaglos wie mit `c` — byte-neutral); die Fest-Schreib-Probe dreht auf Fehlform-Probe. ⇒ **M3a-Commit, Bündelung mit Z-02 (gleicher Header).**
- **GA-06 [KLEIN, Beifang, gleicher Header]:** `scan_stamp_segments` ist `constexpr` (nicht `consteval`) und wirft nackte `char const*` (`:197` + throws) — ein künftiger Laufzeit-Aufrufer entkäme jedem `catch(std::exception const&)`. Ein-Zeichen-Fix `consteval` (heute beide Aufrufer consteval, Null-Byte-Wirkung); dieselbe Form `meas/system_axis.hpp:125`. In den Z-02/Z-09-Commit aufnehmen.

---

## 2. Migrations-Zählung am Ist (fc47c5d9) + TABU

**Bindend sind die grep-Kommandos, nicht die Zahlen** (algo_semver.hpp:76-79-Doktrin; die 2d-Landung verschiebt die Zahlen belegt, s.u.). Erhebungs-Kommandos für den Migrations-Commit:
```
grep -rn 'algo_version *= *"v1\.0\.0"' ce --include=*.hpp --include=*.cpp        # Klasse (a) Organ
grep -n  '"v[0-9]' abi/system_axis_code_versions.hpp meas/measurement_tooling_registry.hpp meas/measurement_framework_registry.hpp
grep -rn 'axis_code_version *=' ce/libs ce/tests ce/tools ce/apps --include=*.hpp --include=*.cpp   # Klasse (d)
grep -rn 'ce_owned_version_satisfies_cpu_enforce\|ce_owned_version_is_wellformed' ce/libs ce/tests ce/tools ce/apps   # GA-05: VOLLSTAENDIGE Klassen-Erhebung ueber die Wachen-Traeger (faengt kOsProbeVersion + planner_version)
grep -rn '"v1\.0\.0"' ce --include=*.hpp --include=*.cpp                          # Voll-Sweep roh
grep -rn '@1\.0\.0[^c0-9]' ce --include=*.hpp --include=*.cpp                     # gerenderte Pins/Fixtures
```

**GA-07-Abgleich (Gesamt-Audit 03.08., auf 7150cc51):** Der Audit misst **194** flaglose `"v1.0.0"`-Literale (164 libs/tools/apps + 30 tests) — **deckungsgleich mit meiner unabhängigen Zählung 194 auf fc47c5d9** (fc47c5d9 = 7150cc51 + reiner Doku-Commit CX-W7). Die in Bauplan/Ledger geführte Größe „122(+7)" ist damit doppelt belegt STALE als GESAMT-Maß (~59% zu klein — Aufwands-Schätzung des Fensters entsprechend anheben; Zahl in Ledger/Bauplan nachziehen = Lead-Aufgabe). **Zahlen-Präzisierung (Gründlichkeits-Audit + eigene Nachmessung 03.08.):** Klasse (a) = **122 Literale in 121 Dateien** (mein früherer Wert „123 in 122" zählte das Test-Fixture `test_m_w12:39` mit — Scope-Fehler, korrigiert; k_ary-Doppel bestätigt). Bereits migrierte `v1.0.0c`-Treffer: **37 in libs+tools / 50 gesamt** (eigene Messung; die GA-07-Teilzahl „24" ist nicht reproduzierbar — nicht tragend). ALLE Zahlen sind Momentaufnahmen; bindend bleiben die Kommandos.

| Klasse | Fundort | Zählung fc47c5d9 |
|---|---|---|
| (a) Organ-Varianten `algo_version="v1.0.0"` | Achsen-Header (topics/queuing + axes/*) | **122 Literale in 121 Dateien** (KORRIGIERT nach Gründlichkeits-Audit, selbst nachgemessen: der lockere grep liefert 123 Treffer in 122 Dateien, davon ist EINER das test-lokale Fixture-Literal `test_m_w12_stamp_bausteine.cpp:39` — das gehört in die Test-Rohstring-Zeile unten, nicht in Klasse (a). Das k_ary-Doppel `:100`/`:364` ist real) |
| (a') „7 Nicht-Organ" | `system_axis_code_versions.hpp:53-55` (3) + `measurement_tooling_registry.hpp:47-49` (3) + `measurement_framework_registry.hpp:45` (1) | **7** + 3 B6-Asserts (`:79/:84/:90`, selber Commit) |
| (d) Meta-Meta `axis_code_version` | `external_utils_family_axis.hpp:105` (gated GESICHERT); UNGESICHERT: `test_meta_meta_halbordnung.cpp:65/:72/:80`, `test_striktheit_axis_dach_guard.cpp:189` | **5** (1 + 4 Test-lokale) |
| (e) OS-Probe | `operating_system_probe.hpp:115` `kOsProbeVersion` | **1** (gated gesichert; Naht-Listen-Eintrag FEHLT noch, s. §1h) |
| (f) NEU nach 2d-Landung | Flag-Worktree-Delta (207−194=+13 Treffer `"v1.0.0"`): `pf/planner/planner_version.hpp` (+5, CX-W5 Planer-Selbst-Version unter Q10/Q3), `test_planner_version_flag_grammatik.cpp` (+5), `test_reflect_versions_all_registered.cpp` (+2, CX-W6), `test_m_w12` (+1) | **nach Landung NEU greppen** — planner_version ist eine ZUSÄTZLICHE Roh-Literal-Quelle |
| Test-/Proben-Rohstrings `"v1.0.0"` | `test_m_w12` (23), `algo_semver.hpp` (17 CT-Proben), `test_reflect_versions_all17` (2), `test_os_u3_probe` (1), Rest Kommentare | Gesamt-Sweep fc47c5d9: **194 Treffer** — davon migrieren die ECHTEN Literale; CT-Proben, die gezielt die flaglose ÜBERGANGS-Form belegen (z. B. `algo_semver.hpp:496/:517/:533`), bleiben als Parser-Semantik-Proben wahr, nur BESTANDS-Behauptungs-Kommentare (`:359` „heutiger Stand ALLER Algos") fallen unter K-6 |
| Gerenderte Pins `@1.0.0` (ohne c) | `test_m_w12` (71), `abi/anatomy_stamp_entries.hpp` (31 CT-Proben im Header), `test_lazy_adhoc_source_gen` (21), `test_g3_sha512_index` (3), `test_resthygiene2_organ_fingerprint` (2), `test_g3_prune` (1), + je 1-2 in `ctsha512.hpp`, `lazy_adhoc_source_gen.hpp`, `ceb_version_stamp.hpp`, `anatomy_version_stamp.hpp`, `algo_semver.hpp`, `external_utils_family_axis.hpp` | **136 Treffer** — Pins/Fixtures ziehen im SELBEN Commit wie die Emissions-Änderung auf `@1.0.0c` (§68c-Regel) |

**TABU-Prüfung (alle grep-belegt 0 Treffer auf `1.0.0` — die Migration berührt sie textuell NICHT):**
- `tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids{,_abi4,_abi5,_abi6}.txt` — 0 (binary_ids sind Organ-only, versionsfrei; decl:212 „binary_id bleibt Organ-only").
- `libs/cache_engine/algorithm_profiles/permutation_axes.xml` — 0.
- `libs/cache_engine/algorithm_profiles/thesis_profiles/m3v2_study.profile.xml` — 0.
- `meas/system_axis_registry.xml` — 0; **byte-stabil Pflicht** (Roundtrip-Gate, sha256 10f8c14d..., Ledger B7) — der Registry-Generator emittiert keine Versionen.
- **CRC-Anker `0x56F1B721C72DC10E`** (`pf/source_catalog.hpp:190`, Kontext :176-189): CRC64 über die 131072 golden-binary_ids — versionsfrei ⇒ M3 DARF und WIRD ihn nicht bewegen; `test_limits` bleibt der lebende TABU-Beleg. (Der Alt-Wert `0xF1C1F26A1232073B` in Kommentaren ist der historische ABI-6/17-Slot-Anker — reine Doku, K-6-neutral.)

---

## 3. Commit-Plan M3a/M3b (Reihenfolge; jeder Commit einzeln grün, granular, kein `git add -A`)

**Vorlauf (kein Commit):** 2d gelandet + Q-M3-GATE bestanden (Ledger-Vermerk bei Option b) · rescue-Refs setzen: `refs/rescue/pre-m3-<dev-SHA>` auf BEIDE Remotes (Muster cx-w7) · Basis = ce development NACH 2d-Landung, Migrations-greps NEU laufen lassen (§2-Kommandos) · Worktree frisch, 2-Phasen-Configure-Kanon (Ledger 2c-INFRA-LEHRE) für hartes Grün.

**M3a (A13-frei, vorbereitend):**
- **C1 — SOTA-K-3-Vorstufe:** `render_sota_module_source`/`render_directive_merge_module_source` + Aufrufer (`sota_catalog.hpp:334/:475/:526`) reichen die VOLLEN organ/system/measurement-Zeilen über die BESTEHENDE 4-arg-_MERGE-Form durch (merge unverändert). Kompositions-Quellen = dieselben `compose_*`-Funktionen wie der adhoc-Pfad. SOTA-Emissions-Pins im selben Commit. Deklariertes SOTA-Byte-Ereignis; CRC-Anker unberührt.
- **C2 — Naht-/Wachen-Vervollständigung (GA-05/Z-10/Z-03/Z-07):** (i) `algo_semver.hpp`-Naht-Liste um die kOsProbeVersion-Klasse ergänzen — Buchstabe am gelandeten Ist vergeben ((e) ist nach 2d durch planner_version belegt, §1h); (ii) die BINDENDE Erhebung um den generischen Wachen-grep erweitern (`ce_owned_version_satisfies_cpu_enforce|ce_owned_version_is_wellformed` — liefert die Klasse vollständig, §1h); (iii) **Z-03-Wachen-Fix**: `meta_meta_version_wohlgeformt`/`meta_meta_version_cpu_pflicht` auf die B12-Single-Source umstellen + `"v1.0.0ce"`-Negativ-Probe (ZWINGEND vor C4, §1l); (iv) **Z-07 nachhaltige Klassen-Schließung**: die Meta-Meta-Versions-Wache zusätzlich an den RENDERER-ENGPASS verankern (`meta_meta_stamp_suffix_from_members`/compose-Pfad) statt nur opt-in am Definitionsort — damit läuft JEDE je gerenderte Meta-Meta (auch künftige und die 4 heute test-lokalen, ungesicherten `axis_code_version`-Träger aus `test_meta_meta_halbordnung.cpp:65/:72/:80` + `test_striktheit_axis_dach_guard.cpp:189`) automatisch durch die Single-Source-Wache; eine neue Meta-Meta ohne Wachen-Zwilling kann dann nicht mehr still am Engpass vorbei stempeln.
- **C2b — Parser-Härtung (Z-02/Z-09/GA-06, ein Header):** `anatomy_stamp_entries.hpp`: F6-Grammatik-Verschärfung gegen die Gruppen-Grenzen-Kollision (Ein-Gruppen-Form je Ebene; Positiv-Assert `:349` dreht), entry-seitiges Hart-Brechen statt fail-open (Probe `:458-465` dreht auf Fehlform), `consteval` statt `constexpr` an `scan_stamp_segments:197` (+ `system_axis.hpp:125`). Byte-neutral für alle kanonischen Renderer-Zeilen — Voll-Bau + Doppellauf belegen es.

**M3b (das EINE Byte-Ereignis; seriell im Fenster):**
- **C3 — Layout-Bruch v6 + K-1 + K-4 + Frozen-Neuanker (EIN Commit):**
  (i) decl: merge-Felder raus, Layout=6, sizeof-Assert 120, `stamp_pod_has_entries` → `== 6` (+ CT-Negativ-Probe: Wert 5 ⇒ false);
  (ii) Makro-Familie: `_MERGE` entfällt, `_M` = Vollform, 2-arg leitet weiter; Makro-Innen-Fingerprint auf neue Signatur;
  (iii) K-1: `abi::OverlayHash`-Typ + neue Signatur + deleted overload (benannter Fehlertext); ALLE Zwillinge im selben Commit: Makro, `lazy_adhoc_fingerprint_for`, `bestandslog_index` (`derive_key_from_lines` 3 Zeilen + Overlay), `ceb_version_stamp.hpp:165-167`;
  (iv) `merge_stamp_line` + Emitter-merge-Parameter + _MERGE-Zweige entfernen (adhoc_emitter, sota_catalog, lazy_adhoc_source_gen); Owner-E2 „darf nicht existieren" ⇒ sofortige Entfernung, kein Deprecation-Stub (Default-Vermerk DV-1, §6);
  (v) **bei OF-M3-1 = Option A (Default):** Preimage-Trenner-Härtung GLEICH MIT — Domain-Separator `'\n'` (außerhalb des Stempel-Zeichenvorrats) zwischen allen Gliedern, in ALLEN 4 Zwillingen + Injektivitäts-Negativprobe (§1k) — derselbe Commit, denn es ist dasselbe Fingerprint-Ereignis und derselbe Frozen-Neuanker;
  (vi) B3-Frozen-Neuanker in test_g3_sha512_index + test_m_w12 (Lane-B-EIN-Commit-Regel), Fixtures dabei in END-Form (moderne Achsen + `@1.0.0c`) ⇒ genau EIN Neuanker im Fenster;
  (vii) alle POD-/Layout-/merge-Test-Pins.
- **C4 — Literal-Migration + ENFORCE=1 (EIN Commit, Owner-Auflage):** alle Klassen (a)/(a')/(d)/(e)/(+f) per §2-greps auf `v1.0.0c`; 3 B6-Asserts mit; gerenderte Pins `@1.0.0`→`@1.0.0c` (136er-Sweep inkl. `anatomy_stamp_entries.hpp`-CT-Proben); `COMDARE_VERSION_HW_FLAG_ENFORCE` → `1`; .algos-Sidecar-Byte-Ereignis in der Commit-Message deklariert. Gerenderte Form bleibt präfixfrei `@1.0.0c` (Q10).
- **C5 — Q2-CT-Wache + K-6-Sweep:** (i) Design-Invariante Owner-Q2: byte-verschiedene Merge-Binaries nie namensgleiche Organ-Segmente — CT-Wache an der Merge-Namens-Naht (MergeAxis/`merge_plan.hpp`; erweiterte hierarchische Namen `prt-art.memory.abc@1.0.0c` sind seit M1 parser-gedeckt); (ii) K-6-Kommentar-Sweep per §1g-grep bis 0 Rest-Treffer.
- **Verifikation je Commit + am Ende:** Voll-Bau 2-Phasen, Doppellauf ctest (Basis-Zahl NACH 2d-Landung neu erheben: fc47c5d9=327, Flag-Cluster meldete 331; Namens-Diff je Commit), `test_limits`-CRC-Anker grün, Registry-Roundtrip byte-identisch, cf22 leer, ASCII-Selbstcheck aus dem Diff, gitleaks, TABU-Pfade nicht im Diff.

**Koordination FK-5 (F1, Bauplan A15-K9 „FK-5 fährt im A13-Fenster mit — gleiche Wrapper, getrennte Commits"):** FK-5 (Fehlerklassen-Erzwingung an den CRTP-Basen je Achse, 19 Stellen, NICHT 129 Einzeldateien) läuft im SELBEN Fenster wie C3/C4, aber als GETRENNTE Commits und SERIELL zum Migrations-Commit — Konfliktfläche sind dieselben Achsen-/Wrapper-Header, die C4 an 121 Dateien anfasst (Literal-Zeile vs. CRTP-Basis = disjunkte Hunks, aber gleiche Dateien: NIE parallel in getrennten Worktrees, Reihenfolge C4 → FK-5 oder FK-5 → C4 explizit festlegen, 3-way vermeiden). FK-5-Inhalt selbst ist NICHT Teil dieses Dossiers (A15-Strang); hier nur die Fenster-/Datei-Koordination. → Risiko R14.

**Einordnung W10/E-24 (F6, Bauplan-Sequenz + Lage-Dossier GATE 3-5 / Konflikt 7):** Der kritische Pfad lautet A13(M3/M4) → **W10-Zellwerte** (system_stamp_line bekommt System-Zellwerte = WEITERES Stempel-Byte-Ereignis) → **E-24** (Container-Gattungs-ABI-Fenster, „letzter ABI-Schritt vor dem Trigger") → **A2-Gate-Eichung EINMALIG ZULETZT** (Lage-Dossier :209/GATE 5: „einmalige Eichung nach A13/E-24"). M3 ist also NICHT die letzte Fingerprint-/ABI-Bewegung vor der Eichung — das A2-Gate darf erst nach W10+E-24 geeicht werden, sonst doppelte Eichung. Lage-Dossier-**Konflikt 7** (offen, Manager-Entscheid): ob E-24 mit M3 gebündelt wird oder ein eigenes Fenster bekommt (zwei getrennte Fenster = zwei Neuanker-Ereignisse, gegen die Ein-Fenster-Doktrin). **Dieses Dossier plant M3 OHNE E-24-Bündelung** (M3-Scope wie beauftragt); fällt der Manager-Entscheid auf Bündelung, wächst das Fenster um das E-24-Paket, ohne dass sich C1-C5 ändern. Folge für §1i: die TP1-Inventur nach M3 liefert den v6-Ist für die Lager-Strecke, die FINALE Inventur zählt aber erst nach dem LETZTEN Shift vor A2 (W10/E-24) — zweifach budgetieren oder final erst danach. → Risiko R15.

**Abgrenzung — NICHT M3:** M4 = CEB-Contract-Minor 0→1 (`g1_ceb_contract_version`, `decl:273-279`) + Voll-Verifikation + KATALOG-E.0-merge-Unterpunkt-Supersede; danach OD-10-RT. TP1-Neu-Inventarisierung (§1i) = Nach-Lande-Schritt der Lager-Strecke (Finalisierung s. W10/E-24-Einordnung oben). Ledger-/Session-Doc-Texte zur Landung = Lead. **CX-W13/V4 „v0"-Signatur-Token (F3):** der ROHE .algos-Signatur-Pfad emittiert für versionslose Einträge das Kurzform-Sentinel `"v0"` (`axis_variant_version_table.hpp:181-185`, dreistellig gerendert byte-neutral `@0.0.0` `:202/:215`) — Owner-Vorlage V4 ist offen. Gleiche Ein-Fenster-Logik: ENTSCHEIDET der Owner den Rückbau `"v0"`→`"v0.0.0"` im Sidecar-Pfad, ist das ein .algos-Byte-Ereignis und gehört in **C4** (dasselbe Sidecar-Byte-Ereignis wie die Literal-Migration); ohne V4-Antwort vor M3-Start bleibt der Zweig UNANGETASTET (Default-Vermerk DV-3, §6) — nach dem Fenster kostet er eine eigene Sidecar-Kaskade.

---

## 4. Test-/Wachen-Plan

**SOLLEN hart brechen (Beweis des Bruchs, im jeweiligen Commit aufgelöst):**
- sizeof-136-Assert (decl:213) und Layout-5-Pins (test_m_w12:432/:744) — C3.
- Jeder Alt-Aufruf `anatomy_fingerprint_hex(sv, sv, sv, sv)` via deleted overload: Makro, ceb_version_stamp, test_m_w12:522 — C3 (das IST der K-1-Beweis; die Negativ-Probe „alter Aufruf bricht benannt" einmal literal führen und revertieren, Muster A13-M1-golden-Schutz).
- B3-Frozen-static_assert (test_m_w12:523-526) + beide g3-EXPECTs — C3-Neuanker.
- Bei ENFORCE=1: jede flaglose ce-Version bricht benannt an den 4 Registry-Wachen + Meta-Meta + os_probe (C4; CX-W6 liefert vorher die AllStrategies-Deckung — auch DEAKTIVIERTE Varianten bewacht).
**NEUE Gleichheits-Wachen:** `stamp_pod_has_entries == 6` + CT-Negativ-Probe (v5 ⇒ false); Layout==6/sizeof==120-Pins; „genau ein HW-Flag"-Wache (M1b, `algo_semver.hpp:441ff`) wird durch ENFORCE erstmals bestands-wirksam.
**NEUE Proben aus den Review-Befunden 03.08.:** (i) bei OF-M3-1=A: Injektivitäts-/Separator-Probe — die drei GA-01-Demo-Kollisionen (`fp("","",X,"")` vs. `fp(X,"","","")` vs. `fp("",X,"","")` und die Ein-Zeichen-Grenzverschiebung) liefern VERSCHIEDENE Fingerprints (existiert heute nicht, GA-01: „4 Test-Aufrufe, alle Positiv-Belege"); (ii) Z-03: `axis_code_version = "v1.0.0ce"` an einer ce-eigenen Meta-Meta bricht BEIDE Wachen (heute passiert es beide — Compile-Beweis im Audit); (iii) Z-02: die Kollisionsform `];[`-Geschwister-Gruppen bricht als F6 (Positiv-Assert `:349` dreht); (iv) Z-09: `"a=x@1.0.0cg"`-Fehlform bricht statt auf 0.0.0 zu kollabieren (Probe `:458-465` dreht).
**MÜSSEN grün bleiben (TABU-Belege):** `test_limits` (CRC64 `0x56F1B721C72DC10E`), `test_system_axis_registry_roundtrip` (byte-identisch; EXCLUDE_FROM_ALL-Kanon beachten, Ledger :3652 Punkt 4), golden_fullpilot_320-Namenslisten, die volle Suite im Doppellauf mit erklärtem Namens-Diff (Basis-Testzahl: KEINE feste Zahl aus diesem Dossier verwenden — die dokumentierten Werte 327 (fc47c5d9), 329 (2d-Basis lt. Flag-Review) und 331 (Flag-Worktree) sind Momentaufnahmen verschiedener Stände; die EINE Wahrheit ist „nach der 2d-Landung per `ctest -N` neu erheben und jeden Zu-/Abgang je Commit im Namens-Diff erklären") (KEIN unerklärter Ab-/Zugang — Lehre „grüne Tests zementieren alte Ordnung": aktiv nach DRITTEN Ableitungswegen der Stempel-Zeilen suchen; bekannter Zwilling: `bld/ceb_version_stamp.hpp` ist der O-8-Schritt-12-„dritte Ableitungsweg" und zieht per ceb_flag_len automatisch mit).

---

## 5. Risiken + Rollback-Anker

| # | Risiko | Entschärfung |
|---|---|---|
| R1 | Offset-Shift v6: ein übersehener `>=5`-Leser liest v6-PODs falsch | K-4-Gleichheits-Wache; Konsumenten-grep belegt: nur decl+test; super/prtart 0 Treffer (03.08.); grep im M3-Review wiederholen |
| R2 | Doppel-Neuanker (Frozen-Vektor erst merge-los, dann c-Migration) | C3 friert Fixtures in END-Form ein (§1f) — EIN Neuanker |
| R3 | Zählung veraltet durch 2d-Landung (+13 belegt, planner_version NEU) | bindende greps §2 NACH Landung; Zahlen sind Momentaufnahmen |
| R4 | 4-arg-Fingerprint-Falle (merge→overlay-Rutsch) | K-1 deleted overload + OverlayHash-Typ (§1c) |
| R5 | kOsProbeVersion fehlt in der zentralen Naht-Liste | C2 ergänzt Klasse (e) VOR der Migration (§1h-Befund) |
| R6 | Lager-Key-Drift (bestandslog vs. consteval-Fingerprint) | alle 4 Zwillinge in EINEM Commit C3; bestandslog_index-Kommentar `:15` ist die Wache-Begründung |
| R7 | .algos-Sidecar-Kaskade unterschätzt | im C4-Commit deklariert; vor Voll-Bau-4 kein schützenswerter Bestand (Ledger [8]) |
| R8 | CX-W2-Wire-syntax_version-Bump (Owner-Vorlage offen) | M3 fasst die Wire-Welt nicht an; falls die 2d-Landung einen Bump bringt, ist er M3-orthogonal (Stempel≠Wire) |
| R9 | Codex-Gate nicht verfügbar | Owner-entschieden: Option (b) Fable-Adversarial MIT Ledger-Vermerk |
| R10 | SOTA-Zeilen-Emission (C1) verändert ungeplant Katalog-Pfade | C1-Diff strikt auf sota_catalog+Tests; golden-CRC-Test + 320er-Namensliste als Beleg |
| R11 | GA-01 bleibt unentschieden bis in den Trigger — spätere Härtung = zweiter globaler Neuanker über 1.572.864 Binaries | OF-M3-1 VOR M3-Start klären (§6); Default A ist im C3-Commit-Plan bereits eingeplant, Option B kostet nur die Ledger-/F7-Klausel |
| R12 | ENFORCE=1 (C4) schaltet mit Z-03 eine löchrige Meta-Meta-Wache scharf — `v1.0.0ce` an ce-eigener Achse bliebe durchlässig | C2 (Z-03-Fix) ist harte Vorbedingung von C4; Reihenfolge im Plan fixiert |
| R13 | Naht-Klassen-Buchstaben kollidieren nach 2d ((e) = planner_version bereits vergeben, 3dfb65ad) | Buchstaben am gelandeten Ist vergeben; C2 pflegt die Liste, bevor C4 migriert |
| R14 | FK-5 fährt im selben Fenster auf denselben Achsen-/Wrapper-Dateien wie C4 (121 Header) — paralleler Worktree-Bau erzwingt 3-way-Merges auf der Migrations-Fläche | Bauplan A15-K9-Auflage strikt: getrennte Commits, SERIELL, Reihenfolge explizit festlegen (§3-Koordinationszeile); nie zwei Worker gleichzeitig auf den Achsen-Headern |
| R15 | Fenster-Koordination W10/E-24: nach M3 folgen zwei WEITERE Byte-/ABI-Ereignisse vor der A2-Eichung; verfrühte Gate-Eichung oder verfrüht-finale TP1-Inventur müsste doppelt neu geankert werden; E-24-Bündelungs-Frage offen (Lage-Dossier-Konflikt 7) | §3-Einordnungszeile: A2 erst nach W10+E-24 eichen (GATE-5-Wortlaut „einmalige Eichung"); TP1-Inventur nach M3 als Arbeits-Ist, FINAL erst nach letztem Shift; Konflikt 7 = Manager-Entscheid, dieses Dossier plant ohne Bündelung |

**Rollback:** vor M3 `refs/rescue/pre-m3-<sha>` auf gitlab+github (Remote-Löschung nur mit Owner-GO); jeder C-Commit einzeln revertierbar (granular); Frozen-Alt-Werte bleiben in der Git-Historie; TABU-Dateien unberührt ⇒ Rollback ist reiner git-revert ohne Daten-Verlust; Mess-CSV-Bestände additiv (nie löschen).

---

## 6. Owner-Fragen

**EINE echte Owner-Frage (NEU 03.08., aus Gesamt-Audit GA-01 BLOCK):**

### OF-M3-1 — Fingerprint-Preimage härten (Trenner) oder deklariertes Restrisiko?

- **ID:** OF-M3-1 · **Dringlichkeit:** Entscheidung VOR M3-Start (Termin-Argument: M3 ist das EINE Neuanker-Fenster; danach kostet dieselbe Härtung einen ZWEITEN globalen Neuanker über 1.572.864 Binaries). · **Beleg:** GA-01 [BLOCK] mit literaler Kollisions-Demonstration in `super docs/sessions/backups/20260803-resume-halbzeit-flag-review-gesamt-audit/gesamt-audit-fable-adversarial.json` (verifikations_beleg zu GA-01); am Ist gegengeprüft (§1k).
- **Kontext:** Der SHA512-Fingerprint — dein SHA512-Gate-Fundament („der deckt die anderen Stempel allein, das war der Sinn des SHA512") — entsteht heute als Konkatenation der Stempel-Zeilen OHNE Trenner. Zwei VERSCHIEDENE Zeilen-Sätze können denselben Fingerprint ergeben (bewiesene Kollisions-Demo: die Feldgrenzen sind verschiebbar). Der Lager-Schlüssel fängt einen Teil über die Zell-Koordinaten ab; innerhalb einer Zelle bleibt die Mehrdeutigkeit. Praktisch heute schwer erreichbar, wächst aber mit dem Overlay-Hash-Anschluss.
- **Option A — Härtung IM M3-Fenster:** Trennzeichen (`'\n'`, kommt in Stempel-Zeilen beweisbar nie vor) zwischen alle Fingerprint-Glieder, in allen vier Rechen-Stellen gleichzeitig, plus neue Kollisions-Negativprobe. Aufwand: marginal — alle vier Stellen werden in M3 ohnehin im selben Commit umgebaut, der Frozen-Testvektor wird ohnehin neu geankert. Risiko: keines über das M3-Fenster hinaus (derselbe eine Neuanker).
- **Option B — bewusstes deklariertes Restrisiko:** Nichts ändern; die Nicht-Injektivität als Klausel in Ledger + F7/Gate-Definition schreiben („Fingerprint deckt die Zeilen nur für kanonisch gerenderte Sätze"). Aufwand: nur Doku. Risiko: die Zusage „SHA512-only-Skip" ist formal nicht beweisbar; jede spätere Härtung = zweiter globaler Neuanker + TP1-Neu-Inventarisierung über den vollen Bestand.
- **Empfehlung + DEFAULT: Option A.** Begründung: gleicher Preis jetzt, hoher Preis später; die Injektivität ist genau die Eigenschaft, auf der das alleinige Skip-Kriterium für 1.572.864 Binaries ruht. Der C3-Commit-Plan hat A bereits eingeplant; bei B entfällt §3-C3(v) ersatzlos und die Ledger-Klausel kommt in den Lande-Text.

### OF-M3-2 — Overlay-Definition (S8) im M3-Fenster oder deklarierter zweiter Neuanker? (F2-Nachtrag; hochgestuft aus dem früheren DV-2)

- **ID:** OF-M3-2 · **Dringlichkeit:** vor M3-Start beantworten. · **Warum hochgestuft statt Default-Vermerk (begründete Wahl):** Das Lage-Dossier **GATE 9** verortet die „S8-Overlay-Definition (3 Owner-Festlegungen)" ausdrücklich **„im Golden-Neuanker-Fenster"** — mein früherer DV-2-Default „nach Abgabe" hätte diese Plan-Aussage per Default superseded; Widersprüche zwischen Plan-Dokumenten werden dem Owner vorgelegt, nicht per Default wegentschieden. Zudem gilt dieselbe Termin-Kosten-Logik wie bei OF-M3-1.
- **Kontext:** `anatomy_fingerprint.hpp:37-55` — die Overlay-Naht ist GEBAUT (5. Preimage-Glied, `COMDARE_OVERLAY_SOURCE_HASH`-Define, heute ehrlich leer), der Pre-Build-Codegen fehlt (0 Treffer), und die DATEIMENGEN-Definition ist ausdrücklich Owner-vorbehalten (`:49-51`: Verzeichnis-Schnitt, Sortier-Ordnung, Hash je Datei vs. Konkatenation = die „3 Owner-Festlegungen" aus GATE 9). **Termin-Kosten:** Das Scharfschalten des Overlay-Glieds ändert JEDEN Fingerprint (auch mit leerem→gefülltem Glied, unabhängig von OF-M3-1) — nach Voll-Bau-4 ist das ein ZWEITER globaler Neuanker über den vollen Bestand + erneute TP1-Inventarisierung.
- **Option A — im M3-Fenster (GATE-9-konform):** Owner trifft die 3 Festlegungen; ein schlanker Pre-Build-Codegen nach dem EXISTIERENDEN Muster `COMDARE_GN_ALGO_SIG` (die Naht verlangt genau das, `:40-43`) reicht den Hash als Define herein; Scharfschaltung im selben C3-Neuanker. Aufwand: nur der Codegen (Naht + Muster existieren); Risiko: Zusatz-Umfang im vollen Fenster (Trigger Do 07.08.).
- **Option B — bewusst NICHT im Fenster:** `COMDARE_OVERLAY_SOURCE_HASH` bleibt `""`; deklarierter Kosten-Ausweis in Ledger + Gate-Klausel („Overlay-Scharfschaltung = zweiter globaler Neuanker") + vom Owner ratifizierter Supersede-Vermerk zu GATE 9. Aufwand: nur Doku; Risiko: der zweite Neuanker wird nach dem Trigger real teuer.
- **Empfehlung + DEFAULT: Option A, KONDITIONIERT** — sie ist planungs-konform (GATE 9) und die Naht macht sie billig. Bedingung: die 3 Owner-Festlegungen liegen bis M3-Start vor. **Fallback-Automatik, kein stiller Ausfall:** treffen sie nicht rechtzeitig ein, läuft B — mit explizitem GATE-9-Supersede-Vermerk in der Owner-Vorlage und dem Kosten-Ausweis im Lande-Ledger-Text.

**Sonst keine gate-blockierenden Fragen.** Q1/Q2/Q3/Q10 + Q-M3-GATE sind entschieden; das Owner-GO ~17:4x deckt dokumentierte Defaults. Zwei Default-Vermerke (laufen ohne Antwort, Einspruch jederzeit):

- **DV-1 (Kontext:** Owner-E2 „Merge Zeile kann daher nicht existieren" vs. Aufräumpass-Doktrin „deprecated Code am ENDE entfernen"**)** — Optionen: (a) merge-Stempel-Code (merge_stamp_line, _MERGE-Makro, Emitter-Zweige) SOFORT in C3 entfernen; (b) nur deaktivieren/deprecaten, Entfernung im Abschluss-Aufräumpass. **Empfehlung + Default: (a)** — „darf nicht existieren" ist eine Existenz-Aussage; stehender toter Stempel-Code wäre ein dritter Ableitungsweg in Wartestellung (O-8-Lehre). Die Merge-DURCHFÜHRUNG (merge_plan.hpp) bleibt unberührt (Q2).
- **DV-3 (F3-Nachtrag; Kontext:** CX-W13/Owner-Vorlage V4 — das `"v0"`-Kurzform-Sentinel im ROHEN .algos-Signatur-Pfad, `axis_variant_version_table.hpp:181-185`**)** — Optionen: (a) ohne V4-Antwort vor M3-Start bleibt der Zweig UNANGETASTET (er ist bewusst dokumentierter Sentinel, gerendert byte-neutral `@0.0.0`); (b) will der Owner per V4 den Rückbau `"v0"`→`"v0.0.0"` im Sidecar, ist das ein .algos-Byte-Ereignis und wird in **C4** gebündelt (Ein-Fenster-Logik — nach dem Fenster kostet es eine eigene Sidecar-Kaskade). **Default: (a)**, mit (b) als vorbereiteter Bündelungs-Platz in C4.

---

## 7. Startklar-Checkliste (Kurzform für den M3-Worker)

1. 2d gelandet? dev-SHA notieren, §2-greps NEU laufen lassen (planner_version!, Naht-Klassen-Buchstaben am Ist).
2. **OF-M3-1 (GA-01) beim Owner geklärt?** Default A ist eingeplant; bei B entfällt C3(v), Ledger-Klausel in den Lande-Text. **OF-M3-2 (Overlay/GATE 9) geklärt?** Default A konditioniert — ohne die 3 Owner-Festlegungen bis M3-Start läuft B mit GATE-9-Supersede-Vermerk. **V4-Antwort (v0-Token) da?** Falls Rückbau gewollt → in C4 bündeln (DV-3).
3. Q-M3-GATE bestanden? (a) Codex extern (bwrap-Ausfall auf prod1 zweifach reproduziert) / (b) Fable-Adversarial + Ledger-Vermerk.
4. rescue-Refs auf beide Remotes.
5. C1→C2→C2b (M3a) → C3→C4→C5 (M3b), je Commit: Voll-Bau 2-Phasen + Doppellauf + Namens-Diff + cf22 + ASCII + gitleaks + TABU-Diff-Check. C2 (Z-03-Fix) ist harte Vorbedingung von C4.
6. Landung: Push→CI hart grün (prod-Referenz beachten), main-FF (SHA PINNEN, nie rev-parse HEAD), super-Gitlink-Bump + Ledger-Texte (inkl. GA-07-Zahlen-Nachzug „122+7 → 194/Ist-grep" in Bauplan/Ledger).
7. Danach: M4 (Contract-Minor 0→1 + E.0-Supersede) → TP1-Neu-Inventarisierung (Lager-Strecke) → OD-10-RT.
8. NICHT M3, separat verfolgt (Kenntnis aus dem Audit, hier nur zur Abgrenzung): GA-02/Z-01 (result.csv.stale-rename ungeprüft — Transport-/Bestandslog-Welle, verschärft CX-W4), GA-03/GA-04 (= CX-W1/W2, Gegenstand der laufenden 2d), GA-08 (ASCII-Altbestand → LED-75-Aufräumpass).

---

## 8. NACHTRAG Review-Befunde 03.08. — GA-01 + Zuordnung der A13-M2-Nachbesserungen (konsolidiert)

> Manager-Auftrag 03.08.; Belege: `super docs/sessions/backups/20260803-resume-halbzeit-flag-review-gesamt-audit/` (gesamt-audit-fable-adversarial.json = GA-01..GA-13; wellen-zweitpass.json = Z-01..Z-12; flag-review-landebereit.json = CX-W5/W6 LANDEBEREIT). Dieser Abschnitt KONSOLIDIERT; die Detail-Inventur steht in §1h (GA-05/Z-10), §1k (GA-01), §1l (Z-02/Z-03/Z-09/GA-06), die Owner-Frage in §6 (OF-M3-1), die Risiken in §5 (R11–R13). Alle übernommenen Befunde wurden am Code-Ist gegengeprüft, nicht abgeschrieben.

### 8.1 GA-01 [BLOCK, NEU] — Fingerprint-Preimage nicht injektiv

- **Ist (bestätigt):** `abi/anatomy_fingerprint.hpp:69-79` konkateniert die 5 Preimage-Glieder (organ/system/measurement/merge/overlay) OHNE Trenner/Längenpräfix (append-Lambda); Laufzeit-Zwilling `pf/lazy_adhoc_source_gen.hpp:268-275` (`preimage += ...`) identisch; Konsument `bld/bestandslog/bestandslog_index.hpp:99-104` (LagerKey.sha). Kollisions-Demo im Audit-JSON: `fp("","",X,"") == fp(X,"","","") == fp("",X,"","")` sowie die Ein-Zeichen-Grenzverschiebung zwischen organ|system — byte-verschiedene Zeilen-Sätze, identischer SHA512. Keine Injektivitäts-Probe im Baum (4 Test-Aufrufe, alle Positiv-Belege; `test_m_w12:814` nutzt den Kollaps sogar).
- **Fenster-Logik:** Eine Trenner-/Längenpräfix-Härtung ist ein GLOBALES Fingerprint-Ereignis. C3 (Layout v6 + K-1-Signaturwechsel + B3-Frozen-Neuanker) ist ohnehin DER eine Neuanker und baut ohnehin alle vier Rechen-Stellen in EINEM Commit um ⇒ wenn die Härtung kommt, gehört sie in **C3(v)** — sie ist dort im Plan bereits als Default eingehängt.
- **Entscheidung = Owner-Frage OF-M3-1 (§6, VERBOSE):** Option A = Härtung in C3 mitnehmen (Aufwand: dieselben 4 Dateien, die C3 sowieso anfasst, + 1 neue Injektivitäts-Negativprobe; Risiko: keines über das Fenster hinaus — derselbe eine Neuanker, dieselbe TP1-Neu-Inventarisierung). Option B = deklariertes Restrisiko (Aufwand: nur Ledger-/F7-Klausel; Begründung der Vertretbarkeit: LagerKey ist Tupel {sha, ZellKoordinaten}, Zell-übergreifende Kollisionen fängt die Koordinate; Reachability heute klein — merge-Slot produktiv leer, 18 Organ-Namen fix — wächst aber mit E.0-Merge-Stempeln und Overlay-Scharfschaltung; jede spätere Härtung = ZWEITER globaler Neuanker über 1.572.864 Binaries). **Empfehlung + DEFAULT: Option A** — gleicher Preis jetzt, hoher Preis später; die Injektivität ist die Eigenschaft, auf der das SHA512-only-Skip-Gate (GATE 5) ruht.

### 8.2 Zuordnung der A13-M2-Nachbesserungen (Zweitpass) zu Commits

| Befund | Kern (Ist bestätigt) | Zuordnung | Begründung |
|---|---|---|---|
| **Z-03** [MITTEL] Meta-Meta-Wache umgeht B12-Single-Source; `"v1.0.0ce"` passiert ungated UND gated (`hardware_meta_meta_axis.hpp:129-140`) | Wachen-Fix auf `ce_owned_version_is_wellformed`/`ce_owned_version_satisfies_cpu_enforce` + `"v1.0.0ce"`-Negativ-Probe | **M3-Fenster, Commit C2 (M3a) — ZWINGEND VOR C4** | ENFORCE=1 (C4) schaltet die gated Wachen als Migrations-Vollständigkeits-Beweis scharf; mit der Lücke wäre der Beweis löchrig (eine ce-eigene Achse könnte als Prüfling-Experiment durch Lager/SHA512-Gate reisen). Byte-neutral am Bestand (flaglos „v1.0.0" besteht beide Formen) — darum M3a-fähig, aber wegen der C4-Kopplung INS Fenster, nicht davor als eigene Welle |
| **Z-02** [MITTEL] Klammer-Grammatik kollidiert an Gruppen-GRENZEN: `];[` vs. `;` in der Gruppe ⇒ identisches Entry-Array samt Ebenen (`anatomy_stamp_entries.hpp:196-252`, Positiv-Assert `:349`) | Empfehlung Weg (i): Grammatik-Verschärfung F6 — Geschwister-Gruppen-Folge auf gleicher Ebene wird Fehlform (kanonische Ein-Gruppen-Form; der Renderer erzeugt ohnehin genau eine Gruppe je Realm-Ende) | **M3-Fenster, Commit C2b (M3a)** | Grammatik-/Parser-berührend = die EINE Wahrheit für die POD-Konsumenten des SHA512-Gates, das direkt NACH M3 aufsetzt — vor dem Gate muss die Verlustfreiheits-Zusage echt sein. Weg (i) ist CT-only und byte-neutral (kanonische Renderer-Zeilen unverändert) ⇒ M3a. NUR falls stattdessen Weg (ii) gewählt wird (Gruppen-Zugehörigkeit in Entry-POD-reserved-Bits), wandert der Punkt nach **C3** (POD-Semantik-Ereignis). Lead-/Review-Entscheid, kein Owner-Gate (Q1-konform: Klammer-ANZAHL kodiert die Ebene, nicht die Gruppen-Partitionierung) |
| **Z-09** [KLEIN] Entry-Parser fail-open: fehlendes `=`/`@`, ungültiger Flag-Schwanz ⇒ stiller 0.0.0-Kollaps statt Hart-Bruch (`:254-289`, festgeschrieben `:458-465`) | Entry-seitiges Hart-Brechen; Fest-Schreib-Probe dreht auf Fehlform-Probe | **M3-Fenster, Commit C2b (M3a), gebündelt mit Z-02** | Gleicher Header, gleiche Klasse (POD-Identitäts-Kollision eine Grammatik-Ebene tiefer als F4/F4b); byte-neutral, weil alle kanonischen Zeilen wohlgeformt sind (flaglos wie `c`-Form). Der A13-M3-Neuanker macht den POD zur Lager-Identität — danach gilt „nie still falsch reisen" auch entry-seitig |
| **GA-06** [KLEIN, Beifang] `scan_stamp_segments` constexpr statt consteval, wirft nackte `char const*` (`:197`; auch `system_axis.hpp:125`) | Ein-Zeichen-Fix `consteval` | **C2b (Beifang)** | Gleicher Header, Null-Byte-Wirkung (beide Aufrufer heute consteval); schließt die Laufzeit-Tür, bevor die Gate-Konsumenten kommen |

**Abgrenzung (KEIN M3):** GA-02/Z-01 (stale-rename ungeprüft → Transport-/Bestandslog-Welle, verschärft CX-W4) · GA-03/GA-04 = CX-W1/W2 (Gegenstand der laufenden Welle 2d) · GA-08 (ASCII-Altbestand → LED-75-Aufräumpass) · GA-07 ist keine Code-Änderung, sondern der Zahlen-Nachzug in Bauplan/Ledger (Lead, §2).

### 8.3 Nachträge aus dem Gründlichkeits-Audit v4 (F1-F6 eingearbeitet; hier nur F5-Detail)

**Z-11 [INFO] — deklarierter AUSLEGUNGS-Vermerk (F5):** `append_meta_meta_suffix` verwirft den Meta-Meta-Anhang STILL, wenn die Realm-Zeile leer ist (`abi/meta_meta_stamp_suffix.hpp:159-163` — „lässt leere Zeile wie leeren Anhang byte-identisch"). Owner-E2 erklärt Meta-Meta-Stempeleinträge zur PFLICHT „wie alle Hauptachsen"; die Auslegung „leere Realm-Zeile ⇒ Anhang entfällt" ist **nirgends Owner-dokumentiert** — sie ist eine Implementierungs-Entscheidung. Am heutigen Ist konsequenzlos: der einzige reale Leer-Fall ist die Mess-Zeile ohne einkompiliertes Tooling, und dort entsteht der load_framework-Anhang konsistent ebenfalls nicht (`bld/ceb_version_stamp.hpp:134` erzeugt ihn nur bei nicht-leerer Tooling-Menge — beide Ableitungswege verhalten sich gleich, kein Drift). FESTHALTUNG: (i) der K-6-Sweep (C5) kodifiziert die Auslegung als benannten Kommentar an der Stelle („AUSLEGUNG, nicht Owner-Wortlaut: leere Realm-Zeile trägt keinen Anhang — beide Zwillinge konsistent"); (ii) sobald je eine Meta-Meta an einer real LEEREN Realm-Zeile hängen soll (z. B. eine Mess-Meta-Meta ohne Tooling-Wahl), ist das eine Owner-Frage, KEIN stiller Default. Kein Fenster-Zwang, keine Byte-Wirkung.

**Erledigungs-Nachweis v4:** F1 → §3-FK-5-Koordinationszeile + R14 · F2 → OF-M3-2 (§6, hochgestuft aus DV-2, mit GATE-9-Zitat + Kosten-Ausweis + benanntem Widerspruch) · F3 → §3-Abgrenzungs-Zeile + DV-3 (§6) · F4 → C2(iv) Renderer-Engpass-Wache (§3) · F5 → dieser Vermerk · F6 → §3-W10/E-24-Einordnung + R15 · KORREKTUR → §2 (Klasse (a) = 122 in 121, Test-Fixture ausgegliedert; v1.0.0c = 37/50 eigene Messung; Testzahl-Referenzen vereinheitlicht in §4).
