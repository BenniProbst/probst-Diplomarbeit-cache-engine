# LENS anker-ist-bestand — IST-Erhebung vor dem ANKER-Vollzug (05.08.2026, READ-ONLY)

Erhoben am Objekt (ce-Repo, super-Repo, Worktrees, GitLab-API read-only) + Ledger. KEINE Pipeline angestossen, KEIN Schreibzugriff auf Repos.

## 1. TP1-Probe-Bestaende: wo sie liegen, was offen ist

### 1.1 Ablage-Ebenen (Storage #51, super .gitlab-ci.yml:573-614)
- **Ebene A (ccache):** minio.comdare.de:9000/**buildsystem-cache** (runners.cache; super .gitlab-ci.yml:53). Objektwaerme, nicht Anker-relevant.
- **Ebene B (Tier-Binary-Cache, MinIO):** eigener Bucket `COMDARE_MINIO_BUCKET` (GETRENNT vom buildsystem-cache), mc-Alias `prodcache` via `MC_HOST_prodcache` (Creds nur CI-Var-Store). Objekt-Keys: `cache_key_prefix(build_version)/<stem>/perm.dll` + Sidecars `.version`/`.algos` + `_gn_chunk_markers/<range>.part<k>.done` (artifact_cache.hpp:6, :182-200, :209-276). **Hier liegen die TP1-Probe-Bestaende.**
- **Ebene C (measure-drop):** HTTPS-PUT `COMDARE_MEASUREMENT_DROP_URL` + Token (Mess-CSV-Drop), inert ohne CI-Vars.
- **Lokal:** einziges Mess-Out ist `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/measure_out_d03/` (Inhalt: `e4_xml/` + `progress.cursor`; Owner-Default V6 = behalten-untracked, Ledger:3723). KEINE `gn_out`/`measure_out`-Verzeichnisse in super sonst oder in einem der 12 Worktrees gefunden (find ueber super + wt-e24/wt-w10/wt-m3/wt-a8s1 leer).
- **Bestandslog-XMLe:** existieren NICHT als lokale Dateien — das Bestandslog ist ein versioniertes, gelocktes XML-OBJEKT im MinIO-Lager (Ledger:3318); Baum-Pfad == minio-Objekt-Praefix == Verortung des key_sha512-Blatts (lager_pfad_grammatik.hpp:15 LB-0); je Knoten zusaetzlich `complete-heuristik.log` (knoten_heuristik_log.hpp). Lokale Enumeration der Ebene B ist auf dieser Maschine NICHT moeglich: `mc alias list` kennt nur die Defaults gcs/local/play, kein comdare-Alias.

### 1.2 Offene Inventur-Signale im Ledger (grep-Treffer + Umfeld)
- **Ledger:3648** (A13-M2, [8]): Fingerprint-Global-Shift vollzogen; "parallel entstandene TP1-Probe-Bestaende sind nach M3 neu zu inventarisieren". B3-Frozen-Testvektor 0f0c0eb4...c31b93 ausdruecklich NICHT betroffen (historisch, s. 2.3).
- **Ledger:3755** (v6-Shift): "TP1-Probe-Bestaende sind gegen v6-Fingerprints NEU zu inventarisieren (Arbeits-Ist jetzt; FINAL erst nach W10/E-24, R15)".
- **Ledger:3805** (W10-Byte-Ereignis): COMDARE_SYSTEM_CELL_VALUES -> System-Zeile -> Fingerprint-Glied [2]; ZWEITE Wirklinie kCebContractCodegenMinor 1->2 ('+ceb=7.1'->'+ceb=7.2', PERM-Pfad traegt Glied erstmals) -> prae-W10-Bestaende mismatchen in dll_is_current -> Neubau + NEUER Store-Bucket. "TP1-ARBEITS-INVENTUR-SIGNAL: Probe-Bestaende nach diesem Shift neu inventarisieren (Arbeits-Ist; FINAL nach E-24, R15)". NICHT bewegt: kFrozenFingerprintV1, Layout v6/POD 120, binary_id Organ-only.
- **Ledger:3856** (JOB-SPERRE Startklar-9, AKTIV): bis ANKER-VOLLZUG (GATE 5 = **TP1-Neu-Inventur + A2-SHA512-Eichung, GENAU EINMAL**) kein Trigger, kein Lager-Voll-Lauf, keine schweren Parallel-Jobs. Vor-Anker-Pflicht A8-S3 -> A8-S4/S5 ist per Phase B (24e07219) abgearbeitet.
- Reihenfolge bindend (Ledger:3756/3770, korrigiert :3675): M3 -> W10 -> E-24 -> **A2-Eichung ZULETZT** (einmalig; "alles andere waere ein Doppel-Neuanker").

## 2. Fingerprint-/Stempel-Stand am Objekt (ce @ 24e07219)

### 2.1 anatomy_fingerprint.hpp (libs/cache_engine/include/cache_engine/abi/)
- Preimage-Ordnung Format 2 (A13-M3): EINE Quelle `anatomy_fingerprint_glieder()` (:128-132), 6 Glieder fest (`kAnatomyFingerprintGliedCount=6`, :104): [0] `fingerprint_format=2` (:64), [1] Organ-Zeile, [2] System-Zeile (`kAnatomyFingerprintSystemGlied=2`, :113, static_assert :136), [3] Mess-Zeile, [4] Sub-Achsen-Werteset-Segment, [5] Overlay-Source-Hash.
- **Injektivitaet (GA-01-Fix):** Separator `'\n'` (:55), beweisbar kollisionsfrei (Zeichenvorrat alnum+"=@;.+_[]"), feste Glied-Anzahl -> eindeutige Zerlegung. merge-Zeile ENTFALLEN (Owner-E2); Alt-4-string_view-Aufruf compile-hart gesperrt (K-1-Sperre :190-199, OverlayHash explicit :97-101).
- **Overlay-Glied [5] ist REAL leer/nur Separator:** `COMDARE_OVERLAY_SOURCE_HASH` defaultet auf `""` (:83-86); Header selbst deklariert "HEUTE LEER, UND ZWAR EHRLICH: der Codegen existiert noch nicht (0 Treffer)" (:74-77); OF-M3-2 = Fallback B (:80-82). Ein leeres Glied traegt ausser seinem Separator nichts bei, die Feldgrenze bleibt erhalten (:156-157). Kein Codegen setzt das Define (grep bestaetigt: einzige Fundstelle ist der Header-Default).

### 2.2 anatomy_version_stamp.hpp (abi/, 306 Zeilen)
- Organ-Zeile 18 Eintraege (A8.2/OP-11, :57, :103-107); Meta-Meta-Anhang-Mechanismus gebaut, heute leer -> Organ-Zeile byte-identisch (:42-45, :73, :112).
- System-Zeile: GENAU 3 Haupt-Achsen + System-Meta-Meta-Klammer "[simd=...]" (:137-149); W10 vervollstaendigt sie um Zellwerte ("code" -> "code.<token>") am gerenderten Ende (:125-127) — genau das Glied [2] des Fingerprints.
- Die SHA512-Zeile selbst materialisiert INNEN im COMDARE_ANATOMY_VERSION_STAMP*-Makro (anatomy_fingerprint.hpp:9-11), emittierter Quelltext byte-identisch, golden-CRC 0xF1C1F26A1232073B unberuehrt.

### 2.3 Frozen-Testvektor / B3
- Aktuell eingefroren: `kFrozenFingerprintV1 = 0fe275bd...cc9fe36` (tests/unit/test_g3_sha512_index.cpp:45-46; identisch in test_w10_system_cell_values.cpp:418 und test_m_w12_stamp_bausteine.cpp:565). Der Test zieht die Glied-Folge aus der EINEN Quelle `anatomy_fingerprint_glieder` (kein zweites Ordnungs-Pinning) und beweist BinaryKeyPolicy::derive_key == derive_key_from_lines == A1-Fingerprint.
- Der aeltere B3-Hex `0f0c0eb4...c31b93` (A1, 23.07.) ist HISTORISCH (test_m_w12_stamp_bausteine.cpp:544: "steht in der git-Historie"); Ledger:3648 nennt ihn unbewegt — das bezieht sich auf den Nicht-Eingriff des M2-Merges, der lebende Vektor ist seither regulaer auf 0fe275bd nachgezogen (W10-Deklaration Ledger:3805 fuehrt ihn als NICHT bewegt).

### 2.4 bestandslog_index.hpp (builder/bestandslog/)
- `LagerKey = {Sha512Key sha, ZellKoordinaten zelle}` (:104-110), Ableitung fail-closed via `key_from_hex` -> nullopt bei Nicht-128-hex (:114-126); `LagerIndex = std::map<LagerKey, BestandEintrag>` (:154).
- **TP1-ARBEITS-INVENTUR-DEKLARATION im Code** (:129-151, S5-Testat): (a) vor Voll-Bau-4 KEIN schuetzenswerter Bestand; (b) v5-Aera-TP1-Probe-Bestaende gegen v6-Fingerprints INVALID, Regel FAIL-CLOSED (Alt-Key -> Lookup-Miss -> NEUBAU), KEIN Grandfathering/keine Alt-Key-Uebersetzung; (c) FINAL-Inventur erst nach W10+E-24 (R15), diese Welle eicht KEINE konkreten Digest-Werte, nur FORM (128 Klein-Hex); **A2-Eichung EINMALIG ZULETZT (FAHRPLAN:18)**.

## 3. Gate-Basis, Pipelines, Worktrees

### 3.1 ce-Repo (/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine)
- development == origin/development == origin/main == **24e07219** (Merge phase-b-treiber, Commit-Titel traegt "Gate 403"). Working Tree sauber (porcelain leer). **ABWEICHUNG klein:** der LOKALE Branch-Ref `main` steht stale auf 2b0a9bd8 (Gate 321), ist aber Vorfahr von development — die Aussage dev==main==24e07219 gilt am REMOTE exakt, lokal fehlt nur der main-FF-Nachzug.
- super-Repo: development == origin/development == origin/main == 7cb9cffb (Ledger mittag-4/-5); Gitlink ce -> 24e07219 (Commit 319e80bd). Lokaler main ebenfalls stale (9d0f1bad).

### 3.2 CI (GitLab-API read-only via aktives .patcfg, /api/v4/user = 200)
- **KEINE laufende Pipeline** (status=running leer fuer Projekt 286 und 288). Nichts angestossen.
- ce (286): letzte Pipelines ALLE success, zuoberst 14638 + 14636 (main, 24e07219), 14634 (push main), 14633 (push development, 24e07219).
- super (288): 14640 (main, 7cb9cffb) + 14639 (development) success.
- **Befund:** super hat EINE stale PENDING-Pipeline **#14190** (development, sha 8cb51663, erstellt 01.08. 22:12, seither pending) — Altlast/haengender Scheduler-Eintrag, kein aktiver Lauf; nicht angefasst.

### 3.3 Worktree-Bestand (/home/comdare/wt-*)
- **wt-e24: FREI** — Branch phase-b-treiber @ c2bc0e2b, porcelain 0, Branch ist in development GEMERGT (`branch --merged` bestaetigt). Als Flaeche fuer den Anker nutzbar.
- Weitere: wt-a8s1 (haertung-64-69-70), wt-w10 (s5-02b-filter), wt-m3 (detached HEAD), wt-landcheck (kein status-Output), plus die 7 dokumentierten NEIN-Faelle des L20-Sweeps (wt-w2-A13-M1b, wt-w2c-TP1FK1-Fixes, wt-w2c-Wachen-Fixes, wt-w2-E02-prtart, wt-w2-E02-thesis, wt-w2-FK-1, wt-w2-FK-2; Einzelpruefung vor Entfernung, Ledger:3777).

## 4. Existierende Skripte/TUs/CI-Jobs fuer Inventur/Eichung

- **Es gibt KEIN dediziertes Inventur- oder Eichungs-Skript und KEINEN CI-Job** in beiden .gitlab-ci.yml (grep -i inventur/eichung: nur Zufalls-Woerter "Wiederholungs-Abweichung" ce:437, "Weiterreichung" super:1014). Der Anker ist als EINMALIGE Handlung deklariert, nicht als stehende Automatik.
- **Code-Mechanik, auf der die Neu-Inventur ruht:**
  - `bestandslog_index.hpp:129-151` — die Arbeits-Inventur-Deklaration (fail-closed Lookup = implizite Inventur: jeder v5-Key verfehlt, Neubau).
  - `knoten_heuristik_log.hpp` — per-Knoten-Inventur-Zustandsmaschine: Crash-Marke `inventur_laeuft=0|1` (:150, :183), zweistufiger Truncate (:36), Neuaufnahme loescht Marke (:386), `inventur_laeuft=1` beim Laden -> `unvollstaendig` (:684).
  - `lager_pfad_grammatik.hpp` — LB-0 Pfad==Objekt-Praefix, `pfad_praefix_passt` TP1-F1-Grenzen (:459-513).
  - `artifact_cache_transport.hpp`, `fingerprint_key_source.hpp`, `bestandslog_lock.hpp`, `lager_ziel_strategie.hpp`, `registrierungs_sidecar.hpp` (builder/bestandslog/) — Transport/Lock/Sidecar-Naht.
- **Eich-TUs (Digest-Anker):** `tests/unit/test_g3_sha512_index.cpp` (Frozen-Vektor + BinaryKeyPolicy==Fingerprint), `test_w10_system_cell_values.cpp`, `test_m_w12_stamp_bausteine.cpp`; Bestandslog-Dokument/Lock: `test_g3_bestandslog_document.cpp`, `test_g3_bestandslog_lock.cpp`; Iterator/Resume-Strecke: `test_tp1_planer_filter_iterator.cpp`, `test_lazy_resume_binary.cpp`, `test_fk1_nicht_gebaut_marker.cpp`.
- **CI-Aktivierungs-Naht** (fuer einen spaeteren Lager-Lauf, NICHT der Anker selbst): super `.storage_cache_activation` (.gitlab-ci.yml:583-614, INERT-by-default via COMDARE_STORAGE_CACHE) + Mess-Pre-Flight P11 (:620-641).
- super Code/tools traegt nur Testdaten-/Matrix-Skripte (cross_compiler_matrix.sh, fetch_testdata.*, run_all_tests.*) — nichts Inventur-artiges.

## 5. Konsequenz fuer die Eichung (IST, keine Empfehlung)
Der Anker (GATE 5) eicht ueber: (i) einen Bestand, der laut Code-Deklaration und Ledger VOR Voll-Bau-4 nicht schuetzenswert und gegen v6 ohnehin fail-closed-invalid ist; (ii) den lebenden Frozen-Vektor 0fe275bd (Format-2-Preimage, Overlay-Glied leer, Glied [2] = System-Zeile mit W10-Zellwert-Naht); (iii) eine Basis ce 24e07219 == remote dev == remote main, CI hart gruen, keine laufenden Jobs, wt-e24 frei. Werkzeug fuer die Inventur existiert als Code-Naht (fail-closed Lookup + Knoten-Log), NICHT als fertiges Skript/CI-Job.
