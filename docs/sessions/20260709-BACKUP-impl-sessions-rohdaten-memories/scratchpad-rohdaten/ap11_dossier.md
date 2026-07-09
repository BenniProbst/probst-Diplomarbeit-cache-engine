# DOSSIER AP-11/#245 — Lastprofil-Katalog LP01-LP14 rückverfolgbar machen: `lp_id`-Attribut + Tag + Test (KEINE Attrappen, ABI-4, golden-neutral)

> **Für Codex** (`--sandbox workspace-write`, gpt-5.5, xhigh). EIN Agent. Repo-Wurzel = `--cd` (comdare-cache-engine).
> **NICHT committen, KEINE git-Operationen.** Basis = fresh-context-Kartierung (Explore a603790a), alle Zeilen belegt.
> **EHRLICHKEIT (kritisch):** KEINE degenerierten/duplizierten Profil-Dateien anlegen. Die „6 fehlenden lp_" sind unter dem
> uint64-Op-Modell Attrappen (LP02≡LP01, LP13≡LP04, LP03/LP07 out-of-scope) oder Duplikate (LP05=ycsb_c, LP06=coco_p04_neg*).
> AP-11 = **Katalogisierung/Rückverfolgbarkeit** (14/14 als `lp_id`-Tag) + ehrliche Dokumentation der bewussten Absenzen —
> NICHT Zuwachs von Mess-Workloads. Rein host-seitig; golden-320-binary_id/ABI-POD/permutation_axes UNBERÜHRT.

## 1. Auftrag
Additives Root-Attribut `lp_id="LPxx"` je Lastprofil-XML (Katalog-Nummer aus Doc 32, getrennt von der bestehenden deskriptiven
`id`), Parser/Writer minimal erweitern, ALLE realen Katalogdateien taggen, ein Vollständigkeits-/Katalogtreue-Test, die 4 bewusst
absenten LP-IDs dokumentieren. KEINE neuen Profil-Dateien.

## 2. VERIFIZIERTER Ist-Zustand (nutze GENAU diese Belege)
- **Katalog Doc 32:** `docs/architecture/32_lastprofil_katalog_und_paper_bias.md:12-25` (LP01-LP14, op-mix/dist/neg je Zeile). LP06 = neg-Sweep ×5; `:33` „21 XML, davon 5 coco_p04_neg = LP06-Sweep"; `:65-73` LP07 out-of-scope (uint64), LP03 value_len deferred, LP12/13 threads → concurrency-Dim.
- **Parser:** `libs/cache_engine/builder/workload_driver/load_profile_parser.hpp` — `LoadProfile`-Struct `:31-38` (hat `id`, `paper_ref`, KEIN Katalog-Feld); `:79` `lp.id = root->attr("id")`; `:80` paper_ref; `has_attr`/`attr`-Helfer (abwesend → `""`, rückwärtskompatibel); `discover_load_profiles(dir)` `:118-131`.
- **Writer:** `libs/cache_engine/builder/workload_driver/load_profile_writer.hpp` — `LoadProfileXmlBuilder` mit Settern (id/paper_ref/pretty_name/records/…), KEIN `lp_id` → beim Round-Trip ginge das Attribut sonst verloren.
- **Schema:** `libs/cache_engine/algorithm_profiles/load_profiles/SCHEMA.md:11-16` (`id` = Workload-Achsen-Wert, `paper_ref`, `schema_version`).
- **KEIN `lp_id` heute** (grep `lp_id|LP0` in load_profiles/ = 0).

## 3. Die verifizierte LP-ID → Datei-Zuordnung (aus der Kartierung — nutze EXAKT diese)
Tagge diese 14 Dateien mit `lp_id` (Root-Attribut, op_mix/Inhalt SONST UNVERÄNDERT):
| Datei | `lp_id` |
|---|---|
| `lp_bulk_insert.xml` | LP01 |
| `lp_read_uniform.xml` | LP04 |
| `lp_range_scan.xml` | LP08 |
| `lp_balanced_5050.xml` | LP09 |
| `lp_delete_heavy.xml` | LP10 |
| `lp_mixed_oltp.xml` | LP11 |
| `lp_concurrent_rmw.xml` | LP12 |
| `lp_dynamic_trace.xml` | LP14 |
| `ycsb_c.xml` (=Katalog static-read-zipfian) | LP05 |
| `coco_p04_neg0/25/50/75/100.xml` (5×, =LP06-neg-Sweep) | LP06 |
**Abgedeckte LP-IDs = {01,04,05,06,08,09,10,11,12,14} (10 distinkt).**
**Bewusst ABSENT (dokumentieren, NICHT anlegen):** LP02 (seq/rand≡LP01), LP03 (value_len, deferred), LP07 (real-corpus, out-of-scope uint64), LP13 (threads≡LP04, in concurrency gefaltet).

## 4. Soll (der Increment)
(a) **Parser:** in `LoadProfile` (`:31-38`) Feld `std::string catalog_lp_id;`; nach `:79` `lp.catalog_lp_id = root->attr("lp_id");` (abwesend → "" = ok).
(b) **Writer:** `LoadProfileXmlBuilder` Setter `catalog_lp_id(...)` + Emit des `lp_id`-Attributs am Root (nur wenn nicht leer) → Round-Trip erhält es.
(c) **14 XMLs taggen:** Root-Element je Datei um `lp_id="LPxx"` ergänzen (Tabelle §3). **NUR das Attribut** — op_mix/key_dist/neg/records unverändert (mess-neutral).
(d) **SCHEMA.md:** `lp_id`-Attribut dokumentieren (Katalog-Nummer LP01-LP14 aus Doc 32, optional, additiv) + eine kurze Absenz-Tabelle (LP02/03/07/13 = bewusst gefaltet/out-of-scope, mit Doc-32-Verweis).
(e) **Test** (erweitere `libs/cache_engine/builder/workload_driver/test_load_profile_writer.cpp` — bekommt das reale load_profiles/-Verzeichnis bereits als Fixture-Arg — ODER neuer `tests/unit/test_ap11_lp_catalog.cpp`): (1) `discover_load_profiles` + parse: die 10 abgedeckten LP-IDs sind präsent + **eindeutig** (LP06 = 5 Dateien, sonst 1); (2) keine Datei mit unbekannter LP-ID; (3) op-mix je getaggter Datei katalogtreu gegen Doc 32 (Regressionsschutz, vgl. coco-neg50-Bug); (4) die 4 Absenzen sind bewusst (assert dokumentiert / nicht als Fehler). CMake-Registrierung falls neuer Test.

## 5. HARTE Auflagen (Verstoß = Abbruch)
1. **KEINE Attrappen/Duplikate:** keine neuen Profil-Dateien für LP02/03/05/06/07/13 (LP05/06 existieren als ycsb_c/coco). Ehrlichkeit > Katalog-Kosmetik.
2. **Mess-neutral:** NUR das additive `lp_id`-Attribut; op_mix/key_distribution/neg%/records/`id`/`paper_ref` der Bestandsdateien UNVERÄNDERT (die `id`/`workload`-CSV-Spalte bleibt gleich → keine Mess-Verschiebung).
3. **ABI/golden-neutral:** NICHT anfassen `golden_fullpilot_320_binary_ids.txt`, `permutation_axes`, `source_catalog.hpp`, ABI-POD (`observable_tier.hpp`/`ComdareTierObserverSnapshot`), `COMDARE_ANATOMY_ABI_MAJOR` (4), `WorkloadConfig`-Struct/`KeyDistribution`-enum (nur Werte via XML). Lastprofile = dynamische Achse 2, fließen NICHT in binary_id.
4. Kein `git`. Kein `$null` stagen.

## 6. Verifikation (PFLICHT — Codex, literal)
- Baue+laufe den Test (bzw. `test_load_profile_writer`) lokal → literal `[ PASSED ]` (10 LP-IDs präsent+eindeutig, op-mix katalogtreu, Round-Trip erhält lp_id).
- Bestätige: `COMDARE_ANATOMY_ABI_MAJOR`==4; golden/permutation_axes/ABI-POD unberührt; op_mix der 14 Dateien byte-unverändert außer dem neuen Attribut.
- `git status --short`: NUR load_profiles/*.xml (14, nur lp_id-Attribut) + load_profile_parser.hpp + load_profile_writer.hpp + SCHEMA.md + der Test (+ ggf. tests/unit/CMakeLists.txt).

## 7. Ausgabe an Claude
(a) Diffs (Parser/Writer/Test + Beispiel-XML-Diff); (b) Bestätigung KEINE neuen Profildateien, op_mix unverändert, ABI-4/golden-neutral; (c) literal `[ PASSED ]`; (d) Absenz-Doku (LP02/03/07/13) zitiert; (e) Hinweis build_version-Bump vor Neumessung (Resume-Stamp deckt XML-Inhalt nicht) — als Notiz, NICHT umsetzen.
