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

**GA-07-Abgleich (Gesamt-Audit 03.08., auf 7150cc51):** Der Audit misst **194** flaglose `"v1.0.0"`-Literale (164 libs/tools/apps + 30 tests) — **deckungsgleich mit meiner unabhängigen Zählung 194 auf fc47c5d9** (fc47c5d9 = 7150cc51 + reiner Doku-Commit CX-W7). Die in Bauplan/Ledger geführte Größe „122(+7)" ist damit doppelt belegt STALE (~59% zu klein — Aufwands-Schätzung des Fensters entsprechend anheben; Zahl in Ledger/Bauplan nachziehen = Lead-Aufgabe). Zusätzlich vom Audit: **24 bereits migrierte `v1.0.0c`-Treffer** in libs/tools (M1b-Vorgriffe/Wachen-Proben). Feinheit zur Flag-Review-Angabe „122 algo_version-Literale unter libs": am Ist sind es **123 Literale in 122 Dateien** — `axis_03a_search_algo_k_ary.hpp` trägt ZWEI echte Varianten-Structs mit je einem Literal (`:100`, `:364`); der grep zählt, nicht die Datei-Liste.

| Klasse | Fundort | Zählung fc47c5d9 |
|---|---|---|
| (a) Organ-Varianten `algo_version="v1.0.0"` | 122 Achsen-Header (topics/queuing + axes/*) | **123 Literale in 122 Dateien** (die alte „122" ist überholt; `axis_03a_search_algo_k_ary.hpp` trägt ZWEI: `:100` und `:364`) |
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
- **C2 — Naht-/Wachen-Vervollständigung (GA-05/Z-10/Z-03):** (i) `algo_semver.hpp`-Naht-Liste um die kOsProbeVersion-Klasse ergänzen — Buchstabe am gelandeten Ist vergeben ((e) ist nach 2d durch planner_version belegt, §1h); (ii) die BINDENDE Erhebung um den generischen Wachen-grep erweitern (`ce_owned_version_satisfies_cpu_enforce|ce_owned_version_is_wellformed` — liefert die Klasse vollständig, §1h); (iii) **Z-03-Wachen-Fix**: `meta_meta_version_wohlgeformt`/`meta_meta_version_cpu_pflicht` auf die B12-Single-Source umstellen + `"v1.0.0ce"`-Negativ-Probe (ZWINGEND vor C4, §1l).
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

**Abgrenzung — NICHT M3:** M4 = CEB-Contract-Minor 0→1 (`g1_ceb_contract_version`, `decl:273-279`) + Voll-Verifikation + KATALOG-E.0-merge-Unterpunkt-Supersede; danach OD-10-RT. TP1-Neu-Inventarisierung (§1i) = Nach-Lande-Schritt der Lager-Strecke. Ledger-/Session-Doc-Texte zur Landung = Lead.

---

## 4. Test-/Wachen-Plan

**SOLLEN hart brechen (Beweis des Bruchs, im jeweiligen Commit aufgelöst):**
- sizeof-136-Assert (decl:213) und Layout-5-Pins (test_m_w12:432/:744) — C3.
- Jeder Alt-Aufruf `anatomy_fingerprint_hex(sv, sv, sv, sv)` via deleted overload: Makro, ceb_version_stamp, test_m_w12:522 — C3 (das IST der K-1-Beweis; die Negativ-Probe „alter Aufruf bricht benannt" einmal literal führen und revertieren, Muster A13-M1-golden-Schutz).
- B3-Frozen-static_assert (test_m_w12:523-526) + beide g3-EXPECTs — C3-Neuanker.
- Bei ENFORCE=1: jede flaglose ce-Version bricht benannt an den 4 Registry-Wachen + Meta-Meta + os_probe (C4; CX-W6 liefert vorher die AllStrategies-Deckung — auch DEAKTIVIERTE Varianten bewacht).
**NEUE Gleichheits-Wachen:** `stamp_pod_has_entries == 6` + CT-Negativ-Probe (v5 ⇒ false); Layout==6/sizeof==120-Pins; „genau ein HW-Flag"-Wache (M1b, `algo_semver.hpp:441ff`) wird durch ENFORCE erstmals bestands-wirksam.
**NEUE Proben aus den Review-Befunden 03.08.:** (i) bei OF-M3-1=A: Injektivitäts-/Separator-Probe — die drei GA-01-Demo-Kollisionen (`fp("","",X,"")` vs. `fp(X,"","","")` vs. `fp("",X,"","")` und die Ein-Zeichen-Grenzverschiebung) liefern VERSCHIEDENE Fingerprints (existiert heute nicht, GA-01: „4 Test-Aufrufe, alle Positiv-Belege"); (ii) Z-03: `axis_code_version = "v1.0.0ce"` an einer ce-eigenen Meta-Meta bricht BEIDE Wachen (heute passiert es beide — Compile-Beweis im Audit); (iii) Z-02: die Kollisionsform `];[`-Geschwister-Gruppen bricht als F6 (Positiv-Assert `:349` dreht); (iv) Z-09: `"a=x@1.0.0cg"`-Fehlform bricht statt auf 0.0.0 zu kollabieren (Probe `:458-465` dreht).
**MÜSSEN grün bleiben (TABU-Belege):** `test_limits` (CRC64 `0x56F1B721C72DC10E`), `test_system_axis_registry_roundtrip` (byte-identisch; EXCLUDE_FROM_ALL-Kanon beachten, Ledger :3652 Punkt 4), golden_fullpilot_320-Namenslisten, 327/331er-Suite im Doppellauf mit erklärtem Namens-Diff (KEIN unerklärter Ab-/Zugang — Lehre „grüne Tests zementieren alte Ordnung": aktiv nach DRITTEN Ableitungswegen der Stempel-Zeilen suchen; bekannter Zwilling: `bld/ceb_version_stamp.hpp` ist der O-8-Schritt-12-„dritte Ableitungsweg" und zieht per ceb_flag_len automatisch mit).

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

**Rollback:** vor M3 `refs/rescue/pre-m3-<sha>` auf gitlab+github (Remote-Löschung nur mit Owner-GO); jeder C-Commit einzeln revertierbar (granular); Frozen-Alt-Werte bleiben in der Git-Historie; TABU-Dateien unberührt ⇒ Rollback ist reiner git-revert ohne Daten-Verlust; Mess-CSV-Bestände additiv (nie löschen).

---

## 6. Owner-Fragen

**EINE echte Owner-Frage (NEU 03.08., aus Gesamt-Audit GA-01 BLOCK):**

### OF-M3-1 — Fingerprint-Preimage härten (Trenner) oder deklariertes Restrisiko?

- **ID:** OF-M3-1 · **Dringlichkeit:** Entscheidung VOR M3-Start (Termin-Argument: M3 ist das EINE Neuanker-Fenster; danach kostet dieselbe Härtung einen ZWEITEN globalen Neuanker über 1.572.864 Binaries).
- **Kontext:** Der SHA512-Fingerprint — dein SHA512-Gate-Fundament („der deckt die anderen Stempel allein, das war der Sinn des SHA512") — entsteht heute als Konkatenation der Stempel-Zeilen OHNE Trenner. Zwei VERSCHIEDENE Zeilen-Sätze können denselben Fingerprint ergeben (bewiesene Kollisions-Demo: die Feldgrenzen sind verschiebbar). Der Lager-Schlüssel fängt einen Teil über die Zell-Koordinaten ab; innerhalb einer Zelle bleibt die Mehrdeutigkeit. Praktisch heute schwer erreichbar, wächst aber mit dem Overlay-Hash-Anschluss.
- **Option A — Härtung IM M3-Fenster:** Trennzeichen (`'\n'`, kommt in Stempel-Zeilen beweisbar nie vor) zwischen alle Fingerprint-Glieder, in allen vier Rechen-Stellen gleichzeitig, plus neue Kollisions-Negativprobe. Aufwand: marginal — alle vier Stellen werden in M3 ohnehin im selben Commit umgebaut, der Frozen-Testvektor wird ohnehin neu geankert. Risiko: keines über das M3-Fenster hinaus (derselbe eine Neuanker).
- **Option B — bewusstes deklariertes Restrisiko:** Nichts ändern; die Nicht-Injektivität als Klausel in Ledger + F7/Gate-Definition schreiben („Fingerprint deckt die Zeilen nur für kanonisch gerenderte Sätze"). Aufwand: nur Doku. Risiko: die Zusage „SHA512-only-Skip" ist formal nicht beweisbar; jede spätere Härtung = zweiter globaler Neuanker + TP1-Neu-Inventarisierung über den vollen Bestand.
- **Empfehlung + DEFAULT: Option A.** Begründung: gleicher Preis jetzt, hoher Preis später; die Injektivität ist genau die Eigenschaft, auf der das alleinige Skip-Kriterium für 1.572.864 Binaries ruht. Der C3-Commit-Plan hat A bereits eingeplant; bei B entfällt §3-C3(v) ersatzlos und die Ledger-Klausel kommt in den Lande-Text.

**Sonst keine gate-blockierenden Fragen.** Q1/Q2/Q3/Q10 + Q-M3-GATE sind entschieden; das Owner-GO ~17:4x deckt dokumentierte Defaults. Zwei Default-Vermerke (laufen ohne Antwort, Einspruch jederzeit):

- **DV-1 (Kontext:** Owner-E2 „Merge Zeile kann daher nicht existieren" vs. Aufräumpass-Doktrin „deprecated Code am ENDE entfernen"**)** — Optionen: (a) merge-Stempel-Code (merge_stamp_line, _MERGE-Makro, Emitter-Zweige) SOFORT in C3 entfernen; (b) nur deaktivieren/deprecaten, Entfernung im Abschluss-Aufräumpass. **Empfehlung + Default: (a)** — „darf nicht existieren" ist eine Existenz-Aussage; stehender toter Stempel-Code wäre ein dritter Ableitungsweg in Wartestellung (O-8-Lehre). Die Merge-DURCHFÜHRUNG (merge_plan.hpp) bleibt unberührt (Q2).
- **DV-2 (Kontext:** `anatomy_fingerprint.hpp:49-51` — die Overlay-DATEIMENGE ist ausdrücklich Owner-vorbehalten**)** — M3 führt NUR den OverlayHash-TYP ein (Signatur-Härtung), `COMDARE_OVERLAY_SOURCE_HASH` bleibt `""`. Optionen: (a) so lassen (Overlay-Definition nach Abgabe/eigener Entscheid); (b) im M3-Fenster mit definieren. **Empfehlung + Default: (a)** — keine zweite Identitäts-Entscheidung ins ohnehin volle Fenster ziehen; die Naht ist gebaut und an EINER Stelle.

---

## 7. Startklar-Checkliste (Kurzform für den M3-Worker)

1. 2d gelandet? dev-SHA notieren, §2-greps NEU laufen lassen (planner_version!, Naht-Klassen-Buchstaben am Ist).
2. **OF-M3-1 (GA-01) beim Owner geklärt?** Default A ist eingeplant; bei B entfällt C3(v), Ledger-Klausel in den Lande-Text.
3. Q-M3-GATE bestanden? (a) Codex extern (bwrap-Ausfall auf prod1 zweifach reproduziert) / (b) Fable-Adversarial + Ledger-Vermerk.
4. rescue-Refs auf beide Remotes.
5. C1→C2→C2b (M3a) → C3→C4→C5 (M3b), je Commit: Voll-Bau 2-Phasen + Doppellauf + Namens-Diff + cf22 + ASCII + gitleaks + TABU-Diff-Check. C2 (Z-03-Fix) ist harte Vorbedingung von C4.
6. Landung: Push→CI hart grün (prod-Referenz beachten), main-FF (SHA PINNEN, nie rev-parse HEAD), super-Gitlink-Bump + Ledger-Texte (inkl. GA-07-Zahlen-Nachzug „122+7 → 194/Ist-grep" in Bauplan/Ledger).
7. Danach: M4 (Contract-Minor 0→1 + E.0-Supersede) → TP1-Neu-Inventarisierung (Lager-Strecke) → OD-10-RT.
8. NICHT M3, separat verfolgt (Kenntnis aus dem Audit, hier nur zur Abgrenzung): GA-02/Z-01 (result.csv.stale-rename ungeprüft — Transport-/Bestandslog-Welle, verschärft CX-W4), GA-03/GA-04 (= CX-W1/W2, Gegenstand der laufenden 2d), GA-08 (ASCII-Altbestand → LED-75-Aufräumpass).
