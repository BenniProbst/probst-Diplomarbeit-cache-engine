# EICH-WELLEN-PLAN — A2-SHA512-only-Skip-Gate (GATE 5 Teil 1, F7; GENAU-EINMAL-Vorgang)

Erstellt 05.08.2026 (Fable, Planungs-Session, READ-ONLY am Objekt). Bindende Grundlagen KOMPLETT
gelesen: anker/definition.md + anker/ist.md + anker/vollzugs-plan.md (S1-Auftrag), F7-Spez
(SUPER docs/sessions/20260801-KONSOLIDIERT-gesamtarchitektur-lager-batch-eta-sha512.md:72),
super-Ledger-Vorlauf grep -E '0[45]\.08\.2026' (mittag-2/-4/-6 = juengster bindender Stand:
Anker VOR W1, "Nun weiter wie geplant").

Ort/Basis: /home/comdare/wt-e24, Branch `anker-a2-eichung` NEU ab 24e07219
(`git -C /home/comdare/wt-e24 checkout -b anker-a2-eichung 24e07219`).
VERIFIZIERT am Objekt: `24e07219^{tree} == c2bc0e2b^{tree} == 46d94b27` — der wt-e24-Bestand IST
byte-identisch die Basis; alle datei:zeile-Angaben unten sind am Objekt erhoben, nicht zitiert.
Auflagen: build-e24 warm, -j MAX 8, nice; Ein-Agent-Regel wt-e24; KEIN Push/Merge (Lead-Sache);
ASCII-only in neuen Zeilen + Selbstcheck aus dem Diff; cf22 echtes Binary
/home/comdare/tools/cf22/usr/bin/clang-format-22 mit Datei-Argumenten.

---

## 1. OBJEKT-BEFUND (Ist am Stand 24e07219, alle Fundstellen verifiziert)

- **dll_is_current** (libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp:267-292):
  4-Parameter-Form (output, version, algo_sig={}, variant_sig={}); Skip = .version-Gleichheit
  UND (falls gesetzt) .algos-Gleichheit UND (falls gesetzt) .variant-Gleichheit.
  `version.empty() => false` (:270) ist das alte Fail-Closed.
- **Der EINE produktive Call-Site**: bo:508 `dll_is_current(job.output, cfg_.build_version, algos,
  cfg_.build_variant_sig)` in provision_core (A); Skip-Result :509-513 mit Message
  `"übersprungen (Version aktuell)"` (:511; grep: KEIN Konsument dieses Strings ausserhalb bo).
- **Schreibseite** (:574-582, nur bei r.status==0): write_version_sidecar + write_algos_sidecar +
  write_variant_sidecar + write_fingerprint_sidecar(job.output, `fingerprint_ ? fingerprint_(spec.
  binary_id) : ""`). `FingerprintFn` (:175) = binary_id -> 128-hex; Member `fingerprint_` (:623),
  Setter set_fingerprint_provider (:364).
- **Provider-Verdrahtung**: cache_engine_builder_iterator.hpp:1311
  `orch.set_fingerprint_provider(cfg.bestand_fingerprint_fn)`; Facade-Quelle profile_run_entry.hpp:
  381-386 (lazy_fingerprint, GATED auf `COMDARE_BESTANDSLOG=true`, sonst LEER), per-Perm-Zwilling
  :886-900 (na-Zelle => Provider geleert = fail-closed W10-C4), Zuweisung :533/:558.
  Berechnungs-Quelle: make_lazy_adhoc_fingerprint_fn_from_env (lazy_adhoc_source_gen.hpp:315) —
  DIESELBE Funktion speist Skip-expected UND Sidecar-Schreiber (Schluessel-Welt-Identitaet).
- **Sidecar-Suffix-Wahrheit**: fingerprint_sidecar.hpp (fingerprint_sidecar_path:34); Kopf-Kommentar
  :21-24 sagt "kein Skip-Kriterium" — WIRD mit dieser Welle falsch, nachfuehren.
- **Lese-Seite (Lager)**: fingerprint_key_source.hpp make_fingerprint_key_fn (trim AUF-A3 +
  is_hex_128); STALER AUF-A5-Kommentar (Fehlerklassen-Block, Zeilen ~40-43): "push_tier_binary
  schiebt `.fingerprint` NICHT mit, s. KNOWN GAP AUF-A5" — FALSCH seit #13:
  **kOptionalTierSidecars = {perm.dll.algos, perm.dll.fingerprint, perm.dll.variant}**
  (artifact_cache.hpp:92-93), gelesen von push (:382), pull (:440/:451) UND prune (:122) —
  Hydrations-Pfad traegt .fingerprint in BEIDE Richtungen (TU-Ist: test_s2_pull_tier_binary (1)/(8a)/(8b)).
- **K1-Cross-Check**: existiert NUR als Kommentar-Satz bo:265-266 ("OS-Familie aus dem
  .version-Sidecar ... bis das A2-Gate geeicht ist"). Es gibt KEINEN separaten K1-Code — die
  OS-Familie steckt im build_version-String, der Cross-Check WAR die .version-Gleichheit selbst
  (grep os_family/Cross-Check: keine weitere Fundstelle).
- **TABU-Anker verifiziert**: kFrozenFingerprintV1 `0fe275bd...cc9fe36` in GENAU 3 TUs
  (test_g3_sha512_index.cpp:45, test_m_w12_stamp_bausteine.cpp:565,
  test_w10_system_cell_values.cpp:418); COMDARE_OVERLAY_SOURCE_HASH: genau EINE Define-Fundstelle
  (abi/anatomy_fingerprint.hpp:83-86; alle uebrigen Treffer sind Muster-NENNUNGEN in Kommentaren);
  golden-CRC 0xF1C1F26A1232073B nur in Kommentaren + golden-TU-Anker.

## 2. DESIGN-ENTSCHEIDE (D1-D9, je mit Begruendung)

- **D1 — Signatur-Ersatz, kompiliert-hart**:
  `[[nodiscard]] inline bool dll_is_current(std::filesystem::path const& output, std::string const&
  expected_fingerprint)` — ERSETZT die 4-Parameter-Form KOMPLETT (F7 "NUR"), keine Defaults, keine
  Uebergangs-Ueberladung. 3-/4-Argument-Altaufrufe sterben compile-hart (test_g2, test_s2 — beide
  werden in derselben Welle nachgezogen, Abschnitt 5). Semantik:
  1. `expected_fingerprint.empty() => false` (fail-closed: ohne CT-Erwartung nie skippen);
  2. `!exists(output) => false` (DLL fehlt => bauen; ein Sidecar ohne Binary skippt NIE);
  3. Sidecar via D2-Leser: fehlt/leer/nicht-128-hex => false (fail-closed, vollzugs-plan S2(b));
  4. `return *sidecar == expected_fingerprint;` — DER EINE Vergleich.
- **D2 — EINE Lese-Wahrheit**: fingerprint_sidecar.hpp erhaelt
  `[[nodiscard]] inline std::optional<std::string> read_fingerprint_sidecar(path const& output)`
  (Trim AUF-A3 + 128-hex-Wache, exakt die heutige make_fingerprint_key_fn-Semantik inkl.
  Gross/Klein-Hex-Toleranz und ohne Normalisierung). fingerprint_key_source.hpp::
  make_fingerprint_key_fn DELEGIERT an den neuen Leser (byte-identisches Verhalten; die vier
  Fehlerklassen-Faelle bleiben nullopt). Ergebnis: Skip-Gate und Lager-Leser lesen ueber EINE
  Funktion — Schluessel-Welt auch auf der LESE-Seite Code-Konstruktion statt Disziplin. Die
  Include-Richtung bleibt unveraendert (bestandslog -> build_orchestrator/fingerprint_sidecar.hpp
  existiert bereits; bo inkludiert fingerprint_sidecar.hpp bereits, bo:20).
- **D3 — expected ueber DIESELBE Quelle wie der Schreiber, EINMAL je Job**: in provision_core wird
  VOR Schritt (A) `std::string const expected_fp = fingerprint_ ? fingerprint_(spec.binary_id) :
  std::string{};` berechnet; (A) prueft `dll_is_current(job.output, expected_fp)`; die
  Schreibstelle :579-581 verwendet DENSELBEN Wert (`write_fingerprint_sidecar(job.output,
  expected_fp);`) statt neu zu rechnen. Damit ist Skip-Gate == Sidecar-Inhalt == minio-Key ==
  Bestandslog key_sha512 im Code EINE Quelle (F7-Forderung), und der Provider laeuft exakt EINMAL
  je Job (vorher: einmal je Erfolgs-Bau; Mehrkosten = 1 SHA512 je Skip-Kandidat, vernachlaessigbar
  gegen den ersetzten Drei-Datei-Vergleich).
- **D4 — K1-Cross-Check: ENTFERNT (Festschreibung gemaess vollzugs-plan S1)**: K1 war nie eigener
  Code, sondern die .version-Gleichheit selbst (Befund oben). Mit F7 "NUR" darf keine zweite
  Skip-Wirkung bestehen; eine Degradierung zur Diagnose-Zeile je Binary waere ein neues
  Log-Bombardement (2^17 Binaries) fuer eine Wache, deren Gegenstand (Define-Verkabelungsfehler)
  seit W10-C4 im Fingerprint-Glied [2] selbst liegt. ENTSCHIEDEN: K1 faellt ersatzlos mit der
  .version-Skip-Logik; der bo:265-266-Kommentar wird zum Vollzugs-Vermerk nachgefuehrt
  (Aufraeumpass-Doktrin: toter Gate-Code faellt, Doku bleibt).
- **D5 — .version/.algos/.variant bleiben als Schreiber**: write_version_sidecar (Transport-
  Vollstaendigkeits-Marke von push_tier_binary, inkl. der TP1FK1-B2-Fehlerzeile bo:293-314),
  write_algos_sidecar, write_variant_sidecar und die BuildConfig-Felder build_version /
  build_variant_sig bleiben UNBERUEHRT (Provenienz-Legende, F7: "gate-los; Endstatus im
  Paragraf-75-Aufraeumpass"). Auch r.algo_sig (Mess-Resume-Stamp-Naht, iterator:1661) bleibt.
- **D6 — Fail-closed-Konsequenz im Default-Modus, DEKLARIERT**: ohne COMDARE_BESTANDSLOG=true ist
  der Provider leer => expected leer => dll_is_current false => Bau-Resume via Skip ist im
  Default-Modus TOT (ehrlicher Neubau statt Alt-Skip). Owner-gedeckt (F7 Uebergangsregel
  fail-closed, D-05, A-2, KEIN Grandfathering). Der Voll-Bau-4 faehrt per Konstruktion MIT
  Bestandslog (derselbe Opt-in speist bestand_key_of/Rueckschrieb) — die EINE Schluessel-Welt ist
  dort aktiv. Es wird in DIESER Welle NICHT un-gated (minimal-invasiv, G8; ein Immer-an-Provider
  waere eine eigenstaendige Verhaltens-Aenderung aller Laeufe und gehoert, falls gewuenscht, in den
  Paragraf-75-/W-Wellen-Rahmen). Phase-5-Pre-Flight (P11) prueft das Env ohnehin.
- **D7 — Frozen-Vektor NICHT in die neue TU kopieren**: die Wache "kFrozenFingerprintV1
  unveraendert in allen 3 TUs" bleibt exakt 3 Fundstellen scharf. test_a2 nutzt synthetische
  128-hex-Vektoren (Muster test_s2: `std::string(128,'a')` etc.); das Gate ist wert-agnostisch,
  der geeichte Referenz-Vektor bleibt ueber die 3 bestehenden TUs gepinnt.
- **D8 — Skip-Message**: `"übersprungen (Version aktuell)"` (bo:511) wird zu ASCII
  `"uebersprungen (Fingerprint aktuell)"` — grep-belegt konsumentenfrei; golden/CSV-neutral
  (BuildResult.message erreicht keine Mess-Bytes).
- **D9 — abi/ bleibt 0 Zeilen**: der damit stale werdende Kommentar
  abi/anatomy_module_abi_v1_decl.hpp:376 ("Dreifach-String-Gleichheit .version/.algos/.variant")
  wird BEWUSST NICHT angefasst (TABU abi/-Diff == 0). Er ist W10-historische Erzaehlung; Nachzug
  als Kandidat fuer das Owner-/G8-Fenster nach Abgabe im S7-Ledger-Nachtrag notieren.

## 3. AENDERUNGS-PLAN JE DATEI:ZEILE

### Commit 1 — SUBSTANZ: der EINE Vergleich + TU-Nachzug + neue A2-TU

1. `libs/cache_engine/builder/build_orchestrator/fingerprint_sidecar.hpp`
   - :21-24 Kopf-Kommentar nachfuehren: ".fingerprint ist seit der A2-Eichung (GATE 5, F7
     KONSOLIDIERT:72, 05.08.2026) DAS Skip-Kriterium UND der Lager-Index-Schluessel" (Alt-Aussage
     als datierten Historik-Absatz stehen lassen, nie loeschen).
   - NEU nach :36: `read_fingerprint_sidecar(path) -> std::optional<std::string>` + private
     Helfer (is_trimmable/trim/is_hex_128, verlagert aus fingerprint_key_source-detail; Kommentar:
     EINE Lese-Wahrheit fuer Skip-Gate UND bestand_key_of; Fehlerklassen-Katalog uebernehmen).
     Zusatz-Includes: <fstream>, <iterator>, <optional>, <string_view>, <system_error>.
2. `libs/cache_engine/builder/bestandslog/fingerprint_key_source.hpp`
   - detail::is_trimmable/trim_view/is_hex_128 (Zeilen ~62-90) entfallen zugunsten der EINEN
     Lese-Funktion; make_fingerprint_key_fn (:95-110) delegiert:
     `return [](path const& output){ return experiment::read_fingerprint_sidecar(output); };`
   - AUF-A5-Kommentar (Fehlerklassen-Block ~:40-43) NACHFUEHREN: "sidecar_fehlt -- Alt-/Fremd-
     Bestand ohne Anker; seit #13 reist .fingerprint via kOptionalTierSidecars
     (artifact_cache.hpp:92) in Push UND Pull mit — der KNOWN GAP AUF-A5 ist GESCHLOSSEN"
     (Alt-Wortlaut datiert stehen lassen).
   - AUF-A4-Absatz (:22-27) bleibt (die Typ-Unterscheidung Schreib-/Lese-Seite gilt weiter).
3. `libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp`
   - :244-266 Doc-Block von dll_is_current NEU (F7-Form): der EINE Vergleich, fail-closed-Regeln
     (leer-expected / DLL fehlt / Sidecar fehlt/leer/nicht-128-hex), Schluessel-Welt-Satz
     (Skip-Gate == minio-Key == Bestandslog key_sha512), Eich-Vermerk (GATE 5, 05.08.2026, Basis
     24e07219, Referenz kFrozenFingerprintV1 in den 3 Eich-TUs), L14-Hinweis (geeicht MIT leerem
     Overlay-Glied, deklarierte Luecke bis Phase 6). W10-C5-Absatz (:252-264) als Historik
     stehen lassen; :265-266 K1-Satz zum Vollzugs-Vermerk drehen (D4: K1 mit der .version-
     Skip-Logik entfallen, Gegenstand seit W10-C4 im Fingerprint-Glied [2]).
   - :267-292 KOERPER-ERSATZ gemaess D1 (2-Parameter-Form, read_fingerprint_sidecar, EIN Vergleich).
   - :506-513 Call-Site: NEU davor `std::string const expected_fp = fingerprint_ ?
     fingerprint_(spec.binary_id) : std::string{};` (D3, mit Kommentar EINE-Quelle);
     (A)-Kommentar :506-507 nachfuehren; :508 `if (dll_is_current(job.output, expected_fp))`;
     :511 Message per D8.
   - :579-581 `write_fingerprint_sidecar(job.output, expected_fp);` (Wiederverwendung statt
     Zweit-Aufruf; Kommentar "I2 Lager-Anker == Skip-Erwartung, EINE Quelle").
   - :329-334 Sidecar-Kommentar ("kein Skip-Kriterium") nachfuehren analog Punkt 1.
4. `tests/unit/test_a2_sha512_skip_gate.cpp` — NEU (Design Abschnitt 4).
5. `tests/unit/CMakeLists.txt` — Registrierung neben :4741-4748 (Muster test_g2_variant_sidecar:
   add_executable + cxx_std_23 + COMDARE_MCE24_INCLUDES + gtest/gtest_main/Boost::mp11/
   comdare_builder_xml_config_parser + comdare_set_platform_defines + add_test + COMDARE_TEST_TARGETS
   + LABELS "a2;blut") und Kommentar-Nachzug :4738 (die 4.-Param-Matrix-Beschreibung ist Historik).
6. `tests/unit/test_g2_variant_sidecar.cpp` — Nachzug (Abschnitt 5, Fall B1): Abschnitte (3), (4),
   (9) (dll_is_current-Matrix, :239-251, :270-271, :374-392) ENTFALLEN als Code (F7: toter
   Gate-Code faellt; Beweis ankert kuenftig auf Fingerprint-Mismatch — test_a2); Kopf-Kommentar
   :1-14 nachfuehren mit Verweis auf test_a2_sha512_skip_gate.cpp. Serializer-/CT-/Writer-
   Abschnitte (1)(2)(5)(6)(7)(8)(10) bleiben VOLL.
7. `tests/unit/test_s2_pull_tier_binary.cpp` — Nachzug (Fall B2): :136-146 und :207-208 auf die
   Ein-Vergleich-Form: HIT = `ex::dll_is_current(bin_dir/"perm.dll", fpr_v1)` (Hydrations-Skip am
   Transport-Zwilling), MISMATCH = anderes 128-hex => false, (8c) STALE: nach Stale-Clearing kein
   .fingerprint => false (fail-closed statt Provenienz-Vortaeuschung — Aussage bleibt, Anker
   wechselt). Kopf-Kommentar :3-16 nachfuehren.
8. `tests/unit/test_kf16b_build_resilience.cpp` — Nachzug (Fall B3): Resume-Beweise auf die
   Fingerprint-Welt: je Lauf ein deterministischer Test-FingerprintFn (id -> 128-hex, z.B.
   Praefix-kodiert je "Version") via `orch.set_fingerprint_provider(...)`; "v1 Re-Run: 5
   uebersprungen" (:120) skippt via .fingerprint; "v2 => 0" (:125-130) via Provider-Wechsel
   (anderes 128-hex) — Beweis-Intention identisch uebersetzt (F7: "rm .version => eine neu"
   wird "rm .fingerprint"; falls der Fall dort existiert, mit umziehen).
9. `tests/unit/test_w6_parallel_provision.cpp` — :137-138/:159 NUR Kommentar nachfuehren
   ("nie skippen" haengt jetzt am fehlenden Fingerprint-Provider, nicht an leerer build_version;
   `cfg.build_version.clear()` kann als Transport-Marken-Detail bleiben — Verhalten identisch).
10. `tests/unit/test_tp1_planer_filter_iterator.cpp` — :128-129/:202 NUR Kommentar nachfuehren
    (Begruendung "leere build_version" -> "kein Fingerprint-Provider => fail-closed, skippt nie");
    TP1_ANKER_OK-Gate (:734) bleibt UNBERUEHRT gruen (S6-Inventur-Gate).

### Commit 2 — KOMMENTAR-WAHRHEITEN + VOLLZUGS-DEKLARATION (reiner Doku-Diff, 0 Objektcode)

11. `libs/cache_engine/builder/bestandslog/bestandslog_index.hpp` :146-150 — (c)-Absatz auf
    Vollzugs-Form: "A2-Eichung VOLLZOGEN mit der Welle anker-a2-eichung (05.08.2026) auf Basis
    24e07219; Referenz-Vektor kFrozenFingerprintV1 (test_g3_sha512_index.cpp:45, 3 TUs);
    dll_is_current ist seither der EINE Vergleich expected == .fingerprint (F7); FINAL-Inventur
    folgt im selben Anker-Fenster (R15)." (a)/(b) bleiben wortgleich.
12. `libs/cache_engine/builder/artifact_transport/artifact_cache.hpp` — Kommentar-Nachzuege:
    :8 (".version ... die dll_is_current lokal prueft" -> Fingerprint-Satz), :86/:89 ("Organ-Gate/
    Variant-Gate dll_is_current" -> "Provenienz-Legende, gate-los seit A2; Skip haengt am
    .fingerprint"), :113-116 ("dll_is_current traegt sich weiter ueber .version" -> fail-closed-
    Wahrheit: ohne .fingerprint KEIN Skip), :199 ("versions-aktuell" -> "fingerprint-aktuell"),
    :417-421 + :450-456 (die lokale Neubau-Garantie haengt am fehlenden/mismatchenden
    .fingerprint; .version bleibt REMOTE-Vollstaendigkeits-Marke — Owner-sanktioniert via F7
    Beweis-1-Wechsel "rm .version" -> "rm .fingerprint"), :475 (".version/.algos" -> ".fingerprint").
13. `libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp` — Kommentar-
    Nachzuege NUR wo die Alt-Kriterien als LEBENDE Wahrheit stehen: :1236-1241 ("kein/kein
    passendes .version/.algos => Neubau" -> ".fingerprint"), :1329 ("versions-aktuelle" ->
    "fingerprint-aktuelle"), :835/:839/:859-860/:1048-1049/:1145/:1189 nur falls woertlich
    version-gebunden (sonst stehen lassen — "dll_is_current-Resume" bleibt als Name wahr).
14. `libs/cache_engine/builder/build_variant_sidecar.hpp` :9 — "der Orchestrator vergleicht sie
    beim Skip-Check" -> Provenienz-Legende-Satz + Verweis bvset-Glied im Fingerprint-Preimage.
15. `libs/cache_engine/profile_facade/profile_run_entry.hpp` :909-914 — A2-NACHZUG-Absatz im
    E-24-C8-Muster (bo:260-264): der W10-M2-Text bleibt als Historik, darunter der lebende Satz
    "seit A2 vergleicht dll_is_current NUR den .fingerprint; das +ceb-Glied wirkt ueber das
    Preimage". :377-380 Kommentar ("4 Zeilen") NICHT anfassen (separate Alt-Zaehlung, kein
    Skip-Bezug — Scope-Disziplin).
16. `libs/cache_engine/profile_facade/profile_run_facade.cpp` :370/:376 + `profile_facade/
    build_type_stamp.hpp` :4-8 — nur falls die Aussage nach D5 FALSCH wuerde: beide sprechen von
    "kein falsches Skip via dll_is_current" ueber .version-/+opt-Segmente; der Schutz wirkt
    kuenftig ueber das build_version-Glied IM Fingerprint — je ein Halbsatz-Nachzug, sonst nichts.
17. `libs/cache_engine/builder/bestandslog/planer_driven_build.hpp` :8/:42,
    `bestandslog/lager_presence.hpp` :25, `bestandslog/builder_registration.hpp` :696 — KEINE
    Aenderung ("dll_is_current bleibt zweite Verteidigungslinie/lokaler Skip-Arbiter" bleibt wahr).

## 4. TU-DESIGN `tests/unit/test_a2_sha512_skip_gate.cpp` (GTest, Muster test_g2)

Vektoren: `fpA = std::string(128,'a')`, `fpB = std::string(128,'b')` (D7; KEIN kFrozenFingerprintV1-
Duplikat). Temp-Verzeichnisse je Abschnitt. Includes: build_orchestrator.hpp,
build_orchestrator/fingerprint_sidecar.hpp, artifact_transport/artifact_cache.hpp (fuer (e),
Fake-Transport-Muster test_s2), <filesystem>/<fstream>.

- **(a) FAIL-CLOSED ohne Sidecar (BEISST am Alt-Stand)**: perm.dll anlegen, `.version` mit Inhalt
  fpA schreiben (die ALTE Skip-Bedingung waere voll erfuellt), KEIN .fingerprint =>
  `EXPECT_FALSE(dll_is_current(dll, fpA))`. Alt-Stand: .version==fpA => true => TU ROT.
- **(b) SKIP bei Match**: perm.dll + `.fingerprint`==fpA => `EXPECT_TRUE(dll_is_current(dll, fpA))`.
  Zusatz: fpA+"\n" im Sidecar => TRUE (Trim-Welt identisch zu bestand_key_of, AUF-A3).
  (Alt-Stand: kein .version => false => ebenfalls ROT — Zweit-Biss.)
- **(c) NEUBAU bei Mismatch + Form-Wachen**: `.fingerprint`==fpB => FALSE; leerer Sidecar => FALSE;
  127/129 Zeichen => FALSE; Nicht-Hex (128x'z') => FALSE; expected leer => FALSE (auch mit
  vorhandenem, gueltigem Sidecar); Sidecar OHNE perm.dll => FALSE.
- **(d) F7-NUR (DER Biss-Beweis)**: perm.dll + `.version`==fpA + `.algos`/`.variant` beliebig
  gefuellt + `.fingerprint`==fpB => `EXPECT_FALSE(dll_is_current(dll, fpA))` — "die alte
  .version-Logik entscheidet NICHT mehr". Alt-Stand: version-Match + leere Gates => true => ROT.
- **(e) HYDRATIONS-SKIP**: Fake-Store (test_s2-Muster :106-134): remote perm.dll +
  perm.dll.fingerprint==fpA + perm.dll.version; `pull_tier_binary` => hydriert (kOptionalTier-
  Sidecars-Beweis); `EXPECT_TRUE(dll_is_current(bin_dir/"perm.dll", fpA))` — gepullte Binary
  skippt. Gegenprobe: Pull-Satz OHNE .fingerprint => nach Hydration FALSE (Alt-Bestand =>
  Neubau, Uebergangsregel).
- **(f) ORCHESTRATOR-VERDRAHTUNG (sichert bo:508+D3)**: BuildOrchestrator mit Stub-Compile
  (touch perm.dll, Muster test_kf16b) + Test-Provider fp(id): Lauf 1 built==N/skipped==0;
  Lauf 2 (gleicher Provider, gleiches Out-Dir) skipped==N; Lauf 3 (Provider liefert fpB-Welt)
  skipped==0; Lauf 4 OHNE Provider auf demselben Out-Dir (mit gesetzter build_version!)
  skipped==0 — fail-closed am echten Call-Site, .version-Logik tot. (Alt-Stand: Lauf 4 skippte
  via .version => ROT — Dritt-Biss.)

**Biss-Verfahren (TABU/Gate-Pflicht, 02a-HERZ-Vorbild)**: VOR der Landung am Basis-Objekt
24e07219 NUR die TU + CMake-Registrierung aufbringen (z.B. `git stash`-freies Zwei-Datei-Overlay
im Worktree), Ziel `ninja test_a2_sha512_skip_gate` bauen, laufen lassen, LITERALE rote Zeilen
((a)/(d)/(f)-Lauf-4) ins Wellen-Protokoll uebernehmen; Overlay rueckstandsfrei entfernen
(`git checkout -- tests/unit/`), DANN Commit 1 bauen. Achtung ninja-Modul-Scan-Falle: nach dem
Overlay-Wechsel frisches Configure fuer den Gate-Lauf.

## 5. TU-BRUCH-KARTIERUNG (Pflicht (3) — was bricht WODURCH, was bleibt)

| TU | Bruch-Art | Behandlung |
|---|---|---|
| test_g2_variant_sidecar.cpp | COMPILE (3-/4-arg :239-251/:374-392) + SEMANTIK (2-arg :270-271) | B1: Matrix-Abschnitte (3)(4)(9) entfallen (F7-NUR; Ersatz test_a2); Rest bleibt |
| test_s2_pull_tier_binary.cpp | COMPILE (:137-146/:208) | B2: auf Ein-Vergleich-Anker umziehen (Hydrations-HIT/Mismatch/STALE-fail-closed) |
| test_kf16b_build_resilience.cpp | VERHALTEN (Re-Run skipped 5 -> 0 ohne Provider, :120) | B3: Test-FingerprintFn injizieren; Beweis-Intention identisch uebersetzt |
| test_w6_parallel_provision.cpp | KEIN Bruch (nie-skippen bleibt via leerem Provider) | Kommentar :137-138 nachfuehren |
| test_tp1_planer_filter_iterator.cpp | KEIN Bruch (kein bestand_fingerprint_fn gesetzt; fail-closed erhaelt "skippt nie") | Kommentar :128-129/:202 nachfuehren; TP1_ANKER_OK unberuehrt |
| test_f3_lager_key_provider_iterator.cpp | KEIN Bruch (frische Out-Dirs je Lauf; fp_fn-Sidecar-Kette unveraendert; Leser-Delegation D2 byte-identisch) | Lauf beweist zusaetzlich die D2-Delegation |
| test_lazy_resume_binary.cpp | KEIN Bruch (Mess-Resume-Stamp-Welt, kein dll_is_current-Aufruf) | unveraendert |
| test_g3_prune.cpp / test_w11_async_push_pump.cpp | KEIN Bruch (kOptionalTierSidecars unveraendert) | unveraendert |
| test_g3_sha512_index / test_w10_system_cell_values / test_m_w12_stamp_bausteine | KEIN Bruch — MUESSEN am ALTEN Wert 0fe275bd gruen bleiben (TABU-Beweis) | unveraendert |
| thesis_tiere/test_experiment_plan_director.cpp | KEIN Bruch (nur Kommentare :1439/:1464/:2236, Aussagen bleiben wahr) | unveraendert |

Geschlossene Welt: `grep -rn dll_is_current` ueber libs/tests/apps/adapters/benchmarks/modules ist
vollstaendig kartiert (keine Treffer ausserhalb der obigen Liste; apps/adapters/benchmarks/modules: 0).

## 6. COMMIT-SCHNITT + GATES (je Commit identisch zu fahren)

- **Commit 1** (Substanz, Punkte 1-10): compile-gekoppelt, MUSS ein Commit sein (Signatur-Wechsel
  + TU-Nachzug + neue TU). Titel-Vorschlag: `feat(anker-a2): F7 SHA512-only-Skip-Gate -- dll_is_current
  wird der EINE Vergleich expected==.fingerprint (fail-closed; Eichung GATE 5)`.
- **Commit 2** (Kommentar-Wahrheiten + Vollzugs-Deklaration, Punkte 11-16): reiner Kommentar-Diff;
  Wache: Diff enthaelt ausserhalb von Kommentaren/Strings 0 Zeilen (Review-Blick + identisches ctest-N).

GATE JE COMMIT (Auflagen-Satz):
1. Basis einmalig: FRISCHES Configure in build-e24, `ctest -N` => erwartet 403 am Basis-Objekt
   (lebendes Gate: LIVE erheben, Abweichung => STOP); nach Commit 1: N_basis+1 (=404 erwartet).
2. Voll-Bau (nice -n19, -j<=8) + **2x voll-ctest SERIELL am Commit-Objekt** => ZWEIMAL literal
   "100% tests passed, 0 tests failed out of N".
3. golden 3/3 + Roundtrip + XML byte-stabil (bestehende golden-Gates; CRC-TU am alten Wert).
4. TABU-Beweise LITERAL: `git diff 24e07219..HEAD -- libs/cache_engine/include/cache_engine/abi/`
   => leer (0 Zeilen); `grep -c 0fe275bd` in den 3 TUs => je 1, Inhalt byte-gleich;
   golden-CRC 0xF1C1F26A1232073B unveraendert; `grep -rn "#define COMDARE_OVERLAY_SOURCE_HASH"`
   => genau 1 Fundstelle (abi/anatomy_fingerprint.hpp:84).
5. Biss-Beweis (nur Commit 1, VOR der Landung): literale ROT-Zeilen der TU am Alt-Stand (Abschn. 4).
6. 3-Marker-grep in Zeilenanfangs-Form == 0; Wortgrenzen-Orakel (Fallen-Kanon mittag-2) ueber die
   umgezogenen Bezeichner (`\bdll_is_current\b`, `\bversion\b`-Restpruefung im bo-Skip-Block);
   cf22 (echtes Binary, Datei-Argumente) == 0 Befunde; gitleaks clean; ASCII-only-Selbstcheck aus
   dem Diff (Bestand-Umlaute ausserhalb des Diffs bleiben).
7. Freeze + diff-stat je Commit ins Protokoll; danach Working-Tree-Freeze (Paketmeldung).
8. KEIN Trigger, KEIN Lager-Voll-Lauf, KEINE schweren Parallel-Jobs (Job-Sperre gilt bis S7);
   KEIN Push/Merge aus dieser Welle (Lead).

## 7. NICHT-ZIELE (bewusst NICHT Teil der Eich-Welle)

- KEIN Un-Gating des Fingerprint-Providers (D6); KEIN Rueckbau COMDARE_VARIANT_GATE-Env (F7:
  Uebergang, Paragraf-75); KEINE Entfernung der .version/.algos/.variant-Schreiber (D5).
- KEINE Beruehrung abi/ (auch nicht der stale Kommentar anatomy_module_abi_v1_decl.hpp:376 — D9).
- NICHTS am Overlay-Glied (L14: geeicht MIT leerem Glied; COMDARE_OVERLAY_SOURCE_HASH behaelt
  genau EINE Define-Fundstelle — jede zweite im Diff = Abbruch).
- KEIN Umbau des Mess-Resume-Stamps (iterator:1661, algos-Anteil) und des Bestand-Bau-Filters
  (lager_presence/planer_driven_build) — beides bleibt die dokumentierte zweite Skip-Quelle.
- KEINE Registry-/Preimage-/Stempel-Aenderung irgendeiner Art (Fingerprint-Shift-Verbot).

## 8. RISIKEN + GEGENMASSNAHMEN

- **R-A Default-Modus verliert Bau-Resume** (D6): deklarierte, owner-gedeckte fail-closed-Folge;
  Wache: test_a2(f) Lauf 4 macht sie zum BEWIESENEN Verhalten statt zur Ueberraschung; P11 prueft
  COMDARE_BESTANDSLOG im Voll-Bau-Profil. Eskalation nur bei realem CI-Zeit-Schmerz (dann W-Welle).
- **R-B unkartierter 2-arg-Altaufruf bindet still um**: geschlossene grep-Welt (Abschn. 5) + Gate
  2x-voll-ctest + Wortgrenzen-Orakel; einziges bekanntes 2-arg-Paar (:270-271 test_g2) faellt mit B1.
- **R-C Teil-Pull skippt ohne .version-Marke** (dll+fingerprint hydriert, Marke fehlt): sanktionierte
  F7-Semantik (Beweis-1-Wechsel "rm .version" -> "rm .fingerprint"); Kommentar-Nachzug Punkt 12
  macht es zur dokumentierten Wahrheit; die Binary-Identitaet ist durch den Fingerprint bewiesen.
- **R-D Message-/Kommentar-Konsumenten uebersehen**: grep-belegt konsumentenfrei (D8); Gate 2
  faengt Rest.
- **R-E Provider-Kosten je Skip-Kandidat** (1x SHA512 vor jedem Skip): vernachlaessigbar vs.
  Compile; ersetzt 1-3 Datei-Reads durch 1 Read + 1 Hash; bei Schmerz im Voll-Bau: Memoisierung
  je (Perm x id) als Nach-Abgabe-TODO notieren (Dauer-Regel mittag-6).
- **R-F Biss-Logistik verfaelscht die Basis**: Overlay nur tests/unit/-Dateien, Rueckbau per
  `git checkout --`, frisches Configure danach (ninja-Modul-Scan-Falle); Basis-SHA bleibt
  unberuehrt, kein Commit am Alt-Stand.
- **R-G Eichung ueber bewegtem Grund**: S0-Vorflug des Vollzugs-Plans (dev==main==24e07219,
  porcelain leer, keine laufenden Pipelines, "ANKER VOLLZOGEN"-grep == 0) ist VOR dem Branch-
  Anlegen zu fahren; jede Abweichung => STOP.
- **R-H Kommentar-Sweep zu breit** (Commit 2 waechst unkontrolliert): geschlossene Liste Punkte
  11-16; alles Weitere (z.B. iterator-Zaehler-Prosa) NUR bei woertlicher Falschaussage; Rest in
  die Kandidaten-Liste des Abschluss-Aufraeumpasses (Owner-KERN) fortschreiben.
