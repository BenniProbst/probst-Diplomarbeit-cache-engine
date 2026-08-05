# NEUANKER-SOLL-SPEZIFIKATION — O-2 Option A (Achsen-Vollstaendigkeits-Neuanker, fingerprint_format=3)

Erstellt 05.08.2026 aus den beiden Lens-Erhebungen (plan-muster.md + objekt-ist.md, beide VOLLSTAENDIG
gelesen; Ist-Stand ce b4110cd0 laut Lens — VOR C-0 HEAD neu feststellen, Lage-Anker nennt 18fbb950).
Regel: NIE RATEN — jedes Glied traegt seinen Plan-Beleg; PLAN-GEDECKT vs. ABLEITUNG ist je Punkt
ehrlich markiert. Pfade relativ zu
`/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine`.

---

## 1. PREIMAGE-SOLL — die vollstaendige Glieder-Liste (Format 3, GliedCount 6 -> 8)

Separator bleibt `'\n'` (OF-M3-1 Option A), Injektivitaet weiter ueber FESTE Glied-Anzahl +
'\n'-Freiheit jedes Glieds (static_assert je neuem Glied). Benannte Positionen werden ergaenzt
(`kAnatomyFingerprintToolchainGlied=5`, `kAnatomyFingerprintBvsetGlied=6`,
`kAnatomyFingerprintOverlayGlied=7`); `kAnatomyFingerprintSystemGlied=2` bleibt stabil
(bestandslog_factory.hpp:62-70 unveraendert adressierbar).

### [0] fingerprint_format=3 — Format-Erstglied (BUMP 2->3)
- Inhalt: Literal `fingerprint_format=3`.
- Quelle: `libs/cache_engine/include/cache_engine/abi/anatomy_fingerprint.hpp:64` (kAnatomyFingerprintFormat).
- Plan-Beleg: F7 FORMAT-VERSION-Regel (KONSOLIDIERT 01.08. :72: "Layout-Evolution mismatcht
  deterministisch statt still zu kollidieren"). Der Glied-Nachtrag IST eine Layout-Evolution.
- **PLAN-GEDECKT.**

### [1] Organ-Zeile — UNVERAENDERT
- Inhalt: 18 Haupt-Achsen `achse=algo@X.Y.Zc` (inkl. 'e'-Flag je experimentellem Pruefling-Algo, E2).
- Quelle: `abi/anatomy_version_stamp.hpp:82-116` (organ_stamp_line, kOrganAxisCount=18).
- Plan-Beleg: ABNAHME-3 "Binary eindeutig" + Q3-Versions-FLAG-Grammatik + A13-M3.
- **PLAN-GEDECKT (bestehend).**

### [2] System-Zeile — UNVERAENDERT
- Inhalt: 3 Haupt-Achsen `code.<zellwert>@1.0.0c` (Familien-Ebene target_isa/operating_system,
  external_utils wertfrei als Hub) + Meta-Meta-Anhang `[simd=code.<token>@1.0.0c]`.
- Quelle: `abi/system_cell_values.hpp` (Schluessel ABSCHLIESSEND {target_isa, operating_system, simd},
  Z.116-122) + `abi/anatomy_version_stamp.hpp:144-161`.
- Plan-Beleg: W10-Dossier + A-15-Grenze (RT-Unter-Achsen NIE im Stempel).
- WICHTIG: cxx/opt/build_type kommen NICHT als Zellwerte hierher (W10-M1: LagerKey-Zelle bleibt
  3-feldig) — sie bekommen das eigene Glied [5]. Kein Byte dieser Zeile aendert sich (kein
  .algos-Ereignis, kein POD-Layout-Bump: AnatomyVersionLines bleibt Layout 6 / sizeof 120).
- **PLAN-GEDECKT (bestehend).**

### [3] Mess-Tooling-Zeile — UNVERAENDERT
- Inhalt: `measurement_tooling=<t>@X.Y.Zc;[load_framework=ycsb@X.Y.Zc]`.
- Quelle: `abi/anatomy_version_stamp.hpp:200-296`.
- Plan-Beleg: §54-T2 (Mess-HAUPT = Tooling, CT je Strecke) + kanonische Stufen-Doktrin mittag-9
  (Mess = DREISTUFIG, erreicht die Tier-Binary als CT-Observer/Ausstattung). Diese Zeile ist die
  CT-eingebaute Mess-AUSSTATTUNG der Tier-Binary — sie ist NICHT der CEB-Schluessel (keine Fusion,
  s. Abschnitt 2).
- **PLAN-GEDECKT (bestehend).**

### [4] Sub-Achsen-Werteset-Segment — UNVERAENDERT
- Inhalt: `sub=cacheline@vN,node_width@vN,alloc_hw@vN` (die 3 globalen Sub-Achsen-CODE-Versionen).
- Quelle: `abi/subaxis_valueset_segment.hpp:44-71`.
- Plan-Beleg: F7-Selbstkritik :103 (explizites Preimage-Glied, sonst stiller Reuse bei Werteset-Bump).
- **PLAN-GEDECKT (bestehend).**

### [5] NEU: TOOLCHAIN-GLIED — die CEB-Laufzeit-HAUPTACHSE Compiler als CT-Glied der Tier-Binary
- Inhalt (Soll):
  - `cxx=<dialekt>-<REAL erkannte Compiler-Version>@<vT>` — REAL erkannte Version statt
    Treiber-Name (G-C4/OE-C; heute `perm_parts.cxx = a.compiler_tag`, profile_run_entry.hpp:906 —
    das ist der Treiber-Tag, MUSS durch RT-Probe an der CEB ersetzt/ergaenzt werden).
  - `opt=<id>{<konkrete Flags je Dialekt>}` — z.B. `opt=O3{-O3}`; die Flags sind per abend-5/F1
    Teil der HAUPT-Achsen-DEFINITION selbst (Registry-Werte-Inhalt system_axis_registry.xml
    Z.94-153, Kopf Z.5-7: "materialisieren als CompileFn-Flags").
  - `atomic128=<id>{<Flags>}` — no_cx16/cx16{-mcx16} (Registry Z.139-150).
  - `ext=<simd-id>` — redundant zu [2]-Meta-Meta, aber F7-(a)-gelistet; Redundanz schadet der
    Injektivitaet nicht und haelt das Glied Suffix-deckungsgleich.
  - `bt=<build_type>` (+bt), `gate=<gate_contribution>` (+gate), `ceb=<ABI-major>.<codegen-minor>`
    (+ceb, Perm-Pfad — heilt Fall C per G-C2), `target=<..>`, `tel=<..>`.
  - Versions-Anker je Toolchain-Achse: NEUE Konstanten (z.B. `kToolchainAxisVersions` fuer
    compiler/opt_level/atomic128, je vX.Y.Zc nach Q3-Grammatik) — Owner-KERN "ALLE Achsen ... mit
    ihrer Versionierung verankert"; heute existiert KEINE Version (system_axis_code_versions.hpp:33-37
    fuehrt compiler nur als UMZUG). NICHT zurueck in kSystemAxisCodeVersions (A3/O-8: compiler ist
    keine System-Haupt-Achse, sondern Unter-Achsen-GRUPPE der Komplex-Achse) — eigener Anker im
    neuen Glied-Header.
- Rendering-Doktrin: aus DERSELBEN Single-Source wie der build_version-Suffix
  (`profile_facade/system_version_suffix.hpp:56-89` SystemVersionSuffixParts/compose +
  Perm-Befuellung `profile_run_entry.hpp:906-931`) + Registry-Flag-Materialisierung. KEINE zweite
  Wahrheit neben dem Suffix — der Suffix bleibt Transport/Provenienz (.version, CSV, Cache-Pfad),
  das Glied wird identitaetswirksam.
- Injektion: per-Perm-Laufzeitwerte -> benannter Traeger-Typ nach K-1-Muster (wie OverlayHash/
  SystemCellValues), injiziert in `anatomy_fingerprint_glieder(...)`; Provider-Naht
  `lazy_adhoc_source_gen.hpp:347-394` + `profile_run_entry.hpp:895-931`.
- Stufen-Konformitaet: exakt Dual-Natur-Register V7.2 (LEDGER:2352) — RT-Unter an der CEB,
  CT-Haupt an der Tier-Binary, "einkompiliert + gestempelt", NICHT binary_id, golden-neutral.
- Plan-Beleg: Inhalts-Menge {cxx REAL, opt, ext, bt, gate, ceb} = **PLAN-GEDECKT** (F7-Spez (a),
  KONSOLIDIERT 01.08. :72); Flags-als-Definitions-Teil = **PLAN-GEDECKT** (abend-5/F1 LEDGER:4204 +
  Registry-Kopf Z.5-7 + Dual-Natur LEDGER:2352 + §62-B Compile-Einstellungs-Stempel).
- **ABLEITUNG (markiert):** (a) Aufnahme von `+target`/`+tel` — F7-(a) nennt sie nicht; Begruendung:
  ABNAHME-3 "Binary eindeutig" verlangt fail-closed ALLE bau-wirksamen Einstellungen; Voll-Rendering
  der EINEN Suffix-Ordnung (kSuffixSegmentOrder) vermeidet einen zweiten Filter-Ort. Falls der Owner
  widerspricht: Segment-Filter an EINER Stelle. (b) Konkretes String-Encoding und Konstanten-Ort
  (neuer Header `abi/toolchain_stamp_glied.hpp` o.ae.). (c) Mechanik der Realversions-Probe
  (RT-Erkennung an der CEB, eingefroren in den CT-Draht der Folgestufe — stufen-doktrin-konform).

### [6] NEU: BVSET-GLIED — Enabled-Mengen-Signatur
- Inhalt: `bvset=<format>;bv=<kBuildVariantDefinitionVersion>;page_type[..];simd_extension[..];general_hardware[..]`
  — die Signatur ueber die REALEN Enabled-Listen (EnabledStrategies-mp_lists aus den
  Achsen-Registries, XML enabled=true -> COMDARE_AXIS_*_ENABLE_*).
- Quelle: `builder/build_variant_set_signature.hpp:127-198` (variant_set_signature) +
  `builder/driver_build_variant_signature.hpp:19,40` (kDriverBuildVariantSignature, CT-verfuegbar).
- Injektion: builder/-Wert wird ins abi/-Glied INJIZIERT (K-1-Muster benannter Typ) — abi/ darf
  nicht in builder/ greifen (Schichtung).
- Konsequenzen (plan-gedeckt): COMDARE_VARIANT_GATE funktional obsolet (F7-(b)); `.variant`-Sidecar
  = reine Provenienz; B10-Variant-Gate-E2E ankert kuenftig auf Fingerprint-Mismatch (seit A2 inert,
  wird durch dieses Glied wieder beweisfaehig, KONSOLIDIERT :72/:108). Deckt zusaetzlich die bisher
  preimage-lose kBuildVariantDefinitionVersion (objekt-ist Tabelle (4)).
- Plan-Beleg: F7-Spez (b) — **PLAN-GEDECKT**; nur die Injektions-Mechanik ist **ABLEITUNG**.

### [7] Overlay-Source-Hash — UNVERAENDERT LEER (Positions-Umzug [5] -> [7])
- Inhalt: leer (Fallback B / OF-M3-2); Dateimengen-Codegen = Phase 6 (L14,
  build_orchestrator.hpp:262-267), bereits ENTSCHIEDEN vertagt — KEIN offener Entscheid fuer O-2.
- Quelle: `abi/anatomy_fingerprint.hpp:74-86` (COMDARE_OVERLAY_SOURCE_HASH default "").
- Plan-Beleg: F7 (d) — **PLAN-GEDECKT (bestehend)**; der Positions-Umzug ans Ende ist **ABLEITUNG**
  (Schwanz-Semantik; durch das Format-Erstglied deterministisch entkoppelt, keine Kollisionsgefahr).

### NICHT im Tier-Preimage (begruendete Ausschluesse)
- `planner_version` (planner_version.hpp:37): Planer = erzeugende Stufe der CEB; OE-C: CEB UND
  Planer je EIGENES Stempelsystem. **PLAN-GEDECKT.**
- RT-Unter-Achsen (os_version/kernel/build, numa/page, scheduling, RAM-Frequenz/CAS/Fabrikation):
  A-15-Verbots-Katalog (system_cell_values.hpp:166-167); Zuordnung via Mess-Spalten/Dateinamen
  (OS-U4). **PLAN-GEDECKT.**
- CEB-Selbst-Stempel `kCebFingerprint` (ceb_version_stamp.hpp:187-189): Log-/--version-Provenienz,
  kein Tier-Preimage; bleibt bewusst zellwert- und toolchainfrei, wird nur Format-3-signaturkonform
  nachgezogen (leere neue Glieder bzw. deleted-overload-Wachen). **PLAN-GEDECKT (bestehend).**

---

## 2. SCHLUESSEL-SCHICHTUNG nach §62-D — TIER vs. CEB vs. MESSWERT (NICHT fusionieren)

Per user-bestaetigter Tabelle LEDGER:3345-3350 + F8 (KONSOLIDIERT :64) + Stempel-Klammer Ebene 0:

1. **TIER-SCHLUESSEL** = SHA512 ueber Glieder [0]-[7] (System [d,e,f] + Organ [g,h,i] +
   CT-Mess-Ausstattung + Werteset + Toolchain + bvset + Overlay). DIE EINE Schluessel-Welt:
   Skip-Gate == .fingerprint == minio-Objekt-Key-Blatt == Bestandslog key_sha512 ==
   Baum-Blatt-Identitaet == ceb_key_sha512-BINDUNG (F7-(a)-Konvergenz; Naehte verifiziert in
   objekt-ist (6): build_orchestrator.hpp:518-529/603, fingerprint_sidecar.hpp:101,
   bestandslog_index.hpp:60-67, bestandslog_factory.hpp:62-75, lager_pfad_grammatik.hpp:15,
   lager_ziel_strategie.hpp:118). LagerKey-Zelle bleibt DANEBEN (nie im Digest), 3-feldig (W10-M1).
2. **CEB-SCHLUESSEL** (getrennt, KEINE id-Fusion): `ceb_legende` ([a,b,c]-Klammer) +
   `ceb_key_sha512` als ZWEI getrennte Felder (F8; bestandslog_document.hpp:200/255/400-402).
   DORTHIN gehoeren `+mtool` (Mess-Tooling-Strecke) und `+mrg` (Rueckschrieb-Methode
   replace/merge/fulljoin) — Planer-Sicht, Mess-Achse [a,b,c].
   **ABLEITUNG (markiert):** F7-(a) nennt +mtool/+mrg im Sammelsatz der Glieder; die
   user-bestaetigte §62-D-Tabelle (hoehere Autoritaet) verortet Mess-Achsen-Replay in der
   CEB-Schicht. Konsequenz-Argument: +mrg aendert kein Byte der Tier-Binary — ein
   Rueckschrieb-Methoden-Wechsel darf Tier-Binaries NICHT invalidieren (§62-D-Trennung);
   das Tooling selbst ist im Tier-Preimage bereits ueber Glied [3] verankert.
3. **MESSWERT-SCHLUESSEL** (dritte Welt, vom Neuanker UNBERUEHRT): voll-permutativ
   [a,b,c][d,e,f][g,h,i] + Maschinen-Hardware-Identitaet (Aequivalenzklasse modulo ungenutzter
   Meta-Metas; RAM/CAS/Fabrikation = Identitaets-/Unter-Merkmale per V7.2, OD-2 vertagt — KEIN
   neues System-Haupt-Glied). CSV/xlsx-Stempel §58. **PLAN-GEDECKT.**
   Binary-Sharing bleibt stempel-gekeyt, Messwert-Replay hardware-identitaets-gekeyt — zwei
   Bestands-Logs je Schluessel-Welt (LEDGER:3338).

---

## 3. BUENDEL-PLAN — Commit-/Wellen-Schnitt Neuanker + F1/F3/F4/F5 (EIN Fenster)

Worktree: `wt-b2-neuanker` (Muster wt-b*-neuanker) von FRISCH festgestelltem ce-HEAD (Lens-Stand
b4110cd0, Lage-Anker nennt 18fbb950 — vor C-0 verifizieren, W1-Wellen-Stand einholen). Landung per
merge (NIE rebase), Push -> Pipeline hart gruen je Commit, granular. ASCII-only + Selbstcheck aus
Diff je Commit. §61-Dual-Weg wo anwendbar.

### C-0 (kein Code): Worktree anlegen, HEAD/Wellen-Lage feststellen, Ledger-Vorlese-Pflicht.

### C-1 — F3 (preimage-neutral, zieht Risiko aus dem Kern-Commit)
- `builder/build_orchestrator/build_orchestrator.hpp`: provision_core raeumt beim Neubau stale
  Sidecars (mind. `.fingerprint` bei leerem expected; konsequent .algos/.variant/.version);
  `write_fingerprint_sidecar` fail-loud im TP1FK1-B2-Muster (Vorbild Z.307-323; heute leer=no-op
  Z.349-353).
- Gate: Unit-Batterie + lokaler VOLLBAU (Falle: lokale Voll-Bau-Luecken = falsches Gruen) +
  Push -> Pipeline gruen.

### C-2 — NEUANKER-KERN (EIN atomarer Commit, Format-Bump + Frozen-Neuanker zusammen)
- Preimage-Kern: `abi/anatomy_fingerprint.hpp` (fingerprint_format=3, GliedCount 8, neue benannte
  Positionen, static_asserts, Budget-Nachweis kAnatomyFingerprintPreimageMax), NEU
  `abi/toolchain_stamp_glied.hpp` (Glied-Renderer + kToolchainAxisVersions, Q3-Grammatik),
  bvset-Injektions-Naht (K-1-Traeger-Typ).
- Zwillinge (ALLE im selben Commit — OF-M3-1-Praezedenz): `profile_facade/lazy_adhoc_source_gen.hpp`
  (lazy_adhoc_fingerprint_for + make_..._from_env um Toolchain/bvset-Injektion),
  `builder/bestandslog/bestandslog_index.hpp`/`bestandslog_factory.hpp` (derive_key ueber die neue
  Glied-Folge; SystemGlied=2 bleibt), `builder/ceb_version_stamp.hpp` (Format-3-konform,
  bewusst leer fuer Toolchain/bvset).
- Provider: `profile_facade/profile_run_entry.hpp` (REAL-Compiler-Versions-Probe G-C4 statt/neben
  compiler_tag; Glied-Befuellung aus der SystemVersionSuffixParts-Single-Source Z.906-931),
  `profile_facade/planner/experiment_plan_director.hpp` (Emission der neuen Werte je Zelle/Perm).
- Tests: NEUER Frozen-Vektor Format 3 (B3-Politik: im SELBEN Commit wie der Bump; Single-Source
  statt Drilling — heute identische Kopien in `tests/unit/test_g3_sha512_index.cpp:45`,
  `test_w10_system_cell_values.cpp`, `test_m_w12_stamp_bausteine.cpp`; Pin-Kommentar
  `test_a2_sha512_skip_gate.cpp:24` drehen); kFrozenFingerprintV1 NICHT loeschen (Historik-/
  Negativ-Zeugnis Format 2 in genau einer TU); Injektivitaets-Negativprobe erweitert (8 Glieder);
  Positions-/'\n'-Freiheits-Beweise fuer Glied [5]/[6]; POD-Wache sizeof(AnatomyVersionLines)==120
  bleibt gruen (kein Layout-7).
- Gate: volle Unit-Batterie + lokaler Vollbau + gezielte TP1-Kernfixtures + Push -> gruen.

### C-3 — F1 + F4 (Konsumenten-Seite; F4 ZWINGEND nach dem Neuanker = EINE Stamp-Invalidierungswelle)
- F1: per-Perm-Unterordner cxx-opt-bt im lokalen Loop (`profile_run_entry.hpp:556`
  cfg.output_dir=a.dll_dir) + bt-/Zellen-Suffix in der Director-Emission
  (`experiment_plan_director.hpp:1236` dll_dir perm<idx>). Nach dem Neuanker skippt nichts mehr
  FALSCH — F1 verhindert das verbleibende Neubau-Ping-Pong geteilter Pfade.
- F4: resume-v5 -> v6: `|fpr=<expected>` additiv im Stamp + Kopplung an `b.skipped` statt nur
  b.ok() (`cache_engine_builder_iterator.hpp:890-897, 935-977, 1815-1822`) — heilt
  "NEUE DLL, ALTE MESSWERTE" (C4).
- Gate: Unit + Resume-E2E-Probe (Neubau => Resume verworfen; Skip => Resume greift) + Push -> gruen.

### C-4 — F5 Kommentar-Drehung (datiert, Doku-Doktrin: drehen statt loeschen)
- `profile_facade/build_type_stamp.hpp:8-11` (wird durch Glied [5] WAHR), 
  `builder/build_variant_sidecar.hpp:10-13` (wird durch Glied [6] WAHR),
  `profile_facade/profile_run_entry.hpp:917-921` (+ceb-im-Preimage-Behauptung — Lens-NEUFUND,
  wird durch Glied [5] wahr, Formulierung auf Glied [5] statt "System-Zeile" drehen),
  `build_orchestrator.hpp:244-289` (F7-/EINE-Welt-Doku auf den 8-Glieder-Satz; L14-Block bleibt,
  Overlay weiter leer).
- Gate: Bau gruen + Push -> gruen.

### Abschluss (nach C-4, EINMAL auf finalem Stand — LEDGER:4205)
- TP1-WIEDERHOLUNG komplett.
- 4+1-Beweise (B10), inkl. Variant-Gate-E2E neu verankert auf Fingerprint-Mismatch.
- Aufraeumpass (Owner-KERN): tote VARIANT_GATE-Vergleichsreste als Kandidaten listen (Entfernen nur
  nach Liste), Kandidaten-Liste fortschreiben.
- Landung: merge in Ziel-Branch (nie rebase), Pipeline hart gruen, Workflow-Backup SOFORT nach
  super backups/; Session-Doc + Ledger-Nachtrag.

### TABU-LISTE (Fenster-invariant)
1. `binary_id`-Welt: Toolchain/bvset NIE in binary_id (Registry binary_id="never", golden-neutral —
   LEDGER:2352). Gilt absolut.
2. Glieder [1]-[3]-ZEILEN-LITERALE unveraendert: kein .algos-Byte-Ereignis, kein
   POD-Layout-Bump (Layout 6, sizeof 120 als Gate-static_assert).
3. `kSystemCellValueKeys` bleibt abschliessend {target_isa, operating_system, simd}; LagerKey-Zelle
   bleibt 3-feldig (W10-M1) — cxx/opt/bt sind GLIED, nie Zellwert.
4. A-15: RT-Unter-Achsen NIE ins Preimage (os_version/kernel/build, numa/page, scheduling, RAM/CAS).
5. Overlay-Glied bleibt LEER — kein Codegen in diesem Fenster (Phase 6/L14).
6. Messdaten/CSV/minio-Objekte: additiv, NIE loeschen; alte Objekte unter alten Keys bleiben liegen.
7. kFrozenFingerprintV1 nicht loeschen (Historik-Zeugnis); neuer Vektor per B3-Politik im
   Bump-Commit.
8. abi/-Grenze: Anfassen ERLAUBT und NOETIG (anatomy_fingerprint.hpp + neuer Glied-Header liegen in
   abi/) — aber KEIN Modul-ABI-Bruch: POD-Layouts, Export-Signaturen, sha512_line-Feldform (128 hex)
   unveraendert; nur Preimage-INHALT und damit Hex-WERTE aendern sich.
9. Kein Landen mitten in einer laufenden Mess-Welle; 286 nie pollen.

---

## 4. RISIKEN

1. **Parallel-Welle W1 (P2) der Bau-Session laeuft auf ce** — heisse Konflikt-Dateien sind exakt
   die Buendel-Dateien (profile_run_entry.hpp, experiment_plan_director.hpp,
   build_orchestrator.hpp, cache_engine_builder_iterator.hpp). Gegenmassnahme: Worktree von frisch
   verifiziertem HEAD (Lens b4110cd0 vs. Lage-Anker 18fbb950 klaeren!), vor jedem Push mergen
   (nie rebase), Landefenster mit der Bau-Session koordinieren (Working-Tree-Freeze-Regeln).
2. **Format-Bump = flottenweiter fail-closed-Neubau**: ALLE bestehenden .fingerprint mismatchen,
   key_sha512-Welt wandert (minio/Bestandslog fuellen sich unter neuen Blaettern; alte Objekte
   bleiben additiv). EIN teurer Voll-Durchlauf — bewusst EINMAL, deshalb EIN Fenster; Zeitfenster
   gegen Frist (Abgabe Fr 08.08., Trigger Do 07.08.) einplanen.
3. **resume-v6** invalidiert alle Mess-Resume-Staende EINMAL — Messwerte/CSV bleiben unberuehrt
   (nur der Resume-Skip entfaellt einmalig).
4. **G-C4-Realversions-Probe** = neue RT-Fehlerflaeche (Parser je Dialekt gcc/clang; 8er-Docker-
   Matrix: je Distro andere Realversion => getrennte Fingerprints — KORREKT per "Binary eindeutig",
   aber Lager-Hit-Rate zwischen Distros sinkt; Sharing bleibt stempel-gekeyt konform §62-D).
5. **Schichtung abi/ <-> builder/**: bvset- und Toolchain-Werte muessen INJIZIERT werden
   (K-1-Muster), kein abi->builder-Include; consteval-Zwillinge (ceb_version_stamp) brauchen
   CT-verfuegbare Werte (kDriverBuildVariantSignature existiert CT; Toolchain-CT-Zwilling pruefen).
6. **Puffer-Budget 4096**: bvset-Signatur (3 Achsen-Klammern) + Toolchain-Glied verlaengern das
   Preimage — Budget-Nachweis + static_assert nachziehen.
7. **Frozen-Drilling**: drei identische Vektor-Kopien + Pin-Kommentar MUESSEN im selben Commit
   gedreht werden (Falle "gruene Tests zementieren alte Ordnung").
8. **Doppel-Wahrheit Glied[5] vs. build_version-Suffix**: beide zwingend aus der EINEN
   SystemVersionSuffixParts-Quelle rendern; Drift-Wache (static_assert/Test Suffix==Glied-Felder).
9. **ABLEITUNGEN koennten Owner-Korrektur erfahren** (+tel/+target im Glied; +mtool/+mrg in der
   CEB-Welt; Glied-Positionen): jeweils an EINER Stelle aenderbar gehalten, im Commit-Text als
   Ableitung mit Beleg deklariert — Korrektur kostet dann einen weiteren Format-Bump NUR falls
   Glied-Inhalte betroffen sind (bewusst in Kauf genommen, fail-closed).
10. **TP1/B10 nur EINMAL auf finalem Stand** — Verlockung, je Commit voll zu beweisen, sprengt das
    Zeitbudget; je Commit nur Gate-Minimum (Unit + Vollbau + Pipeline), Vollbeweis nach C-4
    (LEDGER:4205-Auflage).

---

## 5. OWNER-OFFEN

LEER. Die frueher offenen Punkte sind fuer O-2 saemtlich entschieden oder entschieden-vertagt:
- Overlay-Dateimenge (OF-M3-2/L14): Fallback B bleibt, Heilung Phase 6 — vertagt, kein Blocker.
- OD-2 (RAM/CAS/Fabrikation-Einhaengung): Messwert-Replay-Welt, per V7.2 keine neuen
  System-Haupt-Glieder — beruehrt das Binary-Preimage nicht.
- +tel/+target bzw. +mtool/+mrg-Verortung: per Ableitung aufgeloest (ABNAHME-3 fail-closed bzw.
  user-bestaetigte §62-D-Tabelle); als markierte Ableitungen dokumentiert, an je EINER Stelle
  korrigierbar — kein Gate fuer den Start.
