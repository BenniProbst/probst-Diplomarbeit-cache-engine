# DOSSIER — NON_GATED-2: Parser-/Gating-Konsolidierung (Roadmap 17 Phase 7)

> Increment nach GO-Freigabe 10.07. (BACKLOG NON_GATED-2, Anspruch dossier16-17-10 code-verifiziert im
> Diff-Workflow wf_d4d9e410). Implementierung: **Claude selbst** (User-Direktive 10.07., Codex abgelöst).
> Wurzeln: super = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`,
> ce = `super/Code/external/comdare-cache-engine` (main `fd8167f4`).
> SOLL-Wortlaut (Roadmap 17 :63): „XmlConfigParser-Vereinheitlichung (2 Reader → 1),
> COMDARE_EXPERIMENT_MODE verdrahten, 4-Datei-Schema bereinigen" — #223-Anteil bereits durch Schicht E3
> erledigt (Ledger §12 :412). Gate laut BACKLOG: „nur Regressions-ctest".

## 0. HARTE VERBOTE
Wie alle Increment-Dossiers §0 (golden/m3v2/PODs/ABI-MAJOR==4/GenusBindingTraits/modules/ext/thesis TABU;
deutsche Kommentare ue/ae/oe; kein Python; kein Runtime-Switch). ZUSÄTZLICH:
- **(a) R2-/W-D-K-Gate nicht vorgreifen:** Die 4-Datei-Erwartung (:72-75) und der `test_data_sets.xml`-Slot
  sind Teil der EXTERN_GATED-Forks — Verhalten der RÜCKGABEWERTE nicht ändern (weiterhin `{}` bei fehlender
  Datei), nur SCHWEIGEN beseitigen (Diagnose) + Legacy-Markierung additiv.
- **(b) Byte-Verhaltens-Gleichheit** für real existierende Eingaben: m3v2-Profil (parse_thesis_profile
  unberührt), SOTA-`.profile.xml`-Akten (parse_profile: Felder identisch — Regressionstest
  test_codegen_from_profile:359-398 deckt `<expected_workload>`), `messreihen.xml` (ids/modes/profile-refs
  identisch).
- **(c) PS1-Wege nicht brechen:** build_run_profile_union.ps1/build_and_measure_150_tiere.ps1 kompilieren
  den Host OHNE Mess-Defines (:35/:123 nur /DWIN32 /D_WINDOWS) — KEIN #error-Gate in Host-Harness-Headern
  (profile_run_entry.hpp & Co.).

## 1. IST (verifiziert, datei:zeile)
- **Reader-Pfad 1 (Regex):** `parse_xml_string` xml_config_parser.cpp:26-44 (genutzt von parse_one:87-97)
  + Regex-Blöcke in parse_profile:112-170 + load_messreihen:172-196.
- **Reader-Pfad 2 (KF-1-DOM):** `parse_document`/XmlNode (xml_reader.hpp) — nur parse_thesis_profile:199-315.
- **Reader 3 (Duplikat):** super `02_messung_driver/main.cpp:186-204` lokales load_messreihen (Regex),
  Aufruf :599 — obwohl die Bibliothek XmlConfigParser::load_messreihen (:172) hat.
- **stille-{}-Falle:** parse_one liefert `{}` bei fehlender Datei (:88) UND bei „kein Tag gematcht" (:96);
  4-Datei-Erwartung :72-75 + Treiber-Usage main.cpp:167-172 nennen Dateien, die in
  `Code/experiment_config/` nicht existieren (dort: config_a/b/c_*.xml + messreihen.xml) — Schema-Mismatch.
  experiment_driver.cpp:96 hat die Falle konsumentenseitig bereits teil-abgefangen (Kommentar).
- **COMDARE_EXPERIMENT_MODE:** CMake-Option ce/CMakeLists.txt:409-414 (SOLL: „ResultAggregator + Mess-Hooks
  in der ExecutionEngine", V8.4) — 0 echte #if-Konsumenten im Code; nur Define-Weitergabe an
  Tier-Kompilate (Facade:69, run_lazy_150:227, test_lazy:76) + Warn-only-#ifndef Treiber main.cpp:515-521.
  Echtes Mess-Gating läuft über COMDARE_MEASUREMENT_ON (abi_adapter.hpp:169/336/823). Historie: Konsument
  bei der Migration auf MEASUREMENT_ON verloren.
- **Konsumenten:** experiment_driver.cpp:101/165/445 (parse/load_sota_profiles), catalog_codegen_tool
  main.cpp:316 (parse_thesis_profile), Tests test_kf1/test_e4_contract/test_codegen_from_profile.

## 2. PAKET A — Reader-Vereinheitlichung (Bibliothek, 2→1)
1. parse_xml_string:26-44 DOM-basiert neu implementieren (parse_document → je Kind-Element mit passendem
   Tag + id-Attribut → PermutationEntry{id, attributes aus Kind-Elementen mit Textinhalt}); Signatur und
   Rückgabe UNVERÄNDERT.
2. parse_profile:112-170 auf DOM: Wurzel `comdare_algorithm_profile` (Attribute id/paper_ref/
   pruefling_type), `<axes>`-Kinder → prof.axes, key_types/expected_workload/übrige Felder aus dem
   Bestands-Regex 1:1 nachziehen (VOLLSTÄNDIGE Feldliste aus :112-170 übernehmen — nichts stumm
   verlieren).
3. load_messreihen:172-196 auf DOM (messreihe-Elemente: id-Attribut, mode-Kind, profile-Kinder).
4. `<regex>`-Include entfernen, wenn danach unbenutzt.

## 3. PAKET B — Duplikat-Reader im Treiber + stille-{}-Falle
1. super main.cpp:186-204 lokales load_messreihen LÖSCHEN, Aufruf :599 auf
   `xml::XmlConfigParser{}.load_messreihen(messreihen_xml)` umstellen (Struktur-Felder abgleichen — lokale
   struct vs. Bibliotheks-`Messreihe`; ggf. Mapping).
2. parse_one: Diagnose statt Schweigen — (a) Datei fehlt: `{}` + stderr `[xml-config] optionale Datei
   fehlt: <pfad> (Legacy-4-Datei-Schema, vgl. R2)`; (b) Datei existiert, aber kein Tag matcht: `{}` +
   stderr-WARNUNG `[xml-config] WARNUNG: <pfad> existiert, lieferte aber 0 Eintraege`. Rückgabe unverändert
   (§0a).
3. Treiber-Usage :167-172 additiv: die 4 Dateien als „(Legacy-Schema; heutige Konfigs: config_a/b/c_*.xml +
   messreihen.xml)" kennzeichnen.

## 4. PAKET C — COMDARE_EXPERIMENT_MODE real verdrahten (compile-time, kein Runtime)
1. **Konsistenz-Guard am dokumentierten SOLL-Ort** (Tier-Binary-Mess-Kette, abi_adapter.hpp Datei-Kopf):
   `#if defined(COMDARE_EXPERIMENT_MODE_ON) && !defined(COMDARE_MEASUREMENT_ON)` → `#error
   "COMDARE_EXPERIMENT_MODE_ON erfordert COMDARE_MEASUREMENT_ON (Mess-Hooks; CMakeLists Option
   COMDARE_EXPERIMENT_MODE)"` — kodiert die dokumentierte Invariante (Experiment-Modus ⇒ Mess-Hooks
   kompiliert), bricht keinen Bestand (alle Setzer setzen beide), macht das Define real konsumiert.
   KEIN #ifndef-Zwang (PS1-Wege, §0c).
2. CMake-Option-Beschreibung :409-414 additiv präzisieren (Konsum-Ort = Guard + Tier-Kompilate; Warnpfad
   Treiber :515).
3. Treiber-Warnung :515-521 bleibt (bereits korrekt).

## 5. PAKET D — Regressions-Gate (Label `parser;e4` — CI-aktiv, NIE `contract`)
NEU `tests/unit/test_parser_konsolidierung.cpp` (Standalone-Muster wie test_kf1):
1. parse_profile-DOM gegen eine echte SOTA-Akte: id/paper_ref/pruefling_type/axes/key_types/
   expected_workload — Feldwerte identisch zur Regex-Referenz (Erwartungswerte literal einfrieren).
2. load_messreihen gegen `Code/experiment_config/messreihen.xml`-Fixture (Kopie als Test-Fixture NICHT
   nötig — Pfad-Arg wie test_limits; falls super-Pfad in ce-Test tabu: Mini-Fixture unter
   tests/unit/fixtures/ NEU anlegen): ids/modes/profile-refs erwartungsgleich.
3. parse_xml_string: wohlgeformtes Mini-XML → Einträge+Attribute; fehlende Datei/leeres Tag → `{}`.
4. Bestands-Regressionen: test_kf1_thesis_profile_parser + test_codegen_from_profile + test_e4_contract
   MÜSSEN unverändert grün (parse_thesis_profile-Pfad unberührt).

## 6. DoD / VERIFIKATION (doppelt-literal, offizieller g++-16-Baum)
ce: Kern-Targets + neuer Test + voller ctest 100%; super: messung_driver baut + Smoke (`--help`/Usage);
PS1-Wege syntaktisch unverändert lauffähig (keine neuen Defines nötig); clang-format-22==0; Mojibake==0;
golden/m3v2 byte-unberührt; git status nur geplante Dateien. Danach EIN adversarialer Review-Workflow
(Kadenz) + Rohdaten-Backup in DIESEN Ordner + granulare Commits beide Remotes + CI strikt grün.
