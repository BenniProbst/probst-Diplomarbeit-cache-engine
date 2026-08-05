# LENS plan-muster — Das PRAEZISE geplante Haupt-vs-Unter-Achsen-Muster (Erhebung verbatim, read-only)

> Erhebung 05.08.2026 fuer O-2 = Option A (Achsen-Vollstaendigkeits-Neuanker). Owner-KERN abend-5/F1
> verbatim: LEDGER:4204. Alle Fundstellen live am Ist verifiziert (ce HEAD b4110cd0, super Ledger
> docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md, 4229 Zeilen).
> Pfad-Legende: LEDGER = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md ·
> CE = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine ·
> MEM = /home/comdare/.claude/projects/-home-comdare/memory · SESS = super docs/sessions.

---

## 0. Der Owner-KERN, den dieses Muster einloesen muss (abend-5/F1, VERBATIM)

LEDGER:4204 (NACHTRAG 05.08.2026 abend-5):

> "Faktisch ist es so, dass per Plan und Dokumentation ja die System-Achsen und Organ-Achsen auf der
> CEB die Freigaben fuer den compile der Organ-Achsen auf den Tier-Binaries geben, was unweigerlich
> dazu fuehrt, dass ALLE Laufzeit Hauptachsen wie Compiler auf der CEB, zwangsweise compile time
> Hauptachsen auf der entstehenden Tier-Binary sein muessen. Dein Verstaendnis bezueglich
> ueberspringen ist korrekt. Diesbezueglich muessen ALLE Achsen nach Plan vollstaendig sein und auch
> im Fingerprint mit ihrer Versionierung verankert sein. Wir hatten dazu ein praezises Muster von
> Haupt-Achse vs Unter-Achse geplant und die Flags des Compilers werden in der Tier-Binary (das ist
> dokumentiert) statisch verbaut, sind also in der Compiler Haupt-Achse ein Teil der Haupt-Achsen
> Definition selbst zur Laufzeit der CEB und compile time einer Tier-Binary. Daher Option A jetzt
> und ultracode zum nachsuchen."

Entscheid-Konsequenz (LEDGER:4205): O-2 = OPTION A JETZT, NICHT als C1+C6-Minimalform, sondern als
ACHSEN-VOLLSTAENDIGKEITS-Neuanker: ALLE Achsen mit VERSIONIERUNG im Fingerprint; CEB-Laufzeit-
HAUPTACHSEN (z.B. Compiler INKL. Flags als Teil der Haupt-Achsen-Definition) = zwangsweise
CT-Hauptachsen der Tier-Binary; gebuendelt mit A2-Fixen F1/F3/F4/F5; danach TP1-Wiederholung +
4+1-Beweise (B10) EINMAL auf finalem Stand.

---

## 1. Das Grund-Muster: Haupt=CT-statisch / Unter=RT-dynamisch + STUFEN-RELATIVITAET

### 1.1 Ur-Direktive (User 18.07., woertlich — LEDGER:2105, §24-Kopf)

> "Weiterer Hinweis zu Haupt-Achsen: sie sollten in der Regel statische Einstellungen beinhalten die
> zur compile time gesetzt und fest verdrahtet sind, hingegen haben Unter-Achsen in der Regel runtime
> Eigenschaften innerhalb des Programmes. Weil wir aber eine Kette Experiment-Planer -> CEB ->
> Tier-Binary laufen, sind die dynamischen Einstellungen der vorhergehenden Stufe, oft die zu
> uebernehmenden compile Time Draehte der gebauten nachfolgenden Stufe."

### 1.2 §24.C ACHSEN-KETTEN-STATIK (LEDGER:2113, Verfeinerung zu §21.B/§23)

- Haupt-Achsen = i.d.R. statische, zur compile time fest verdrahtete Einstellungen; Unter-Achsen =
  i.d.R. Runtime-Eigenschaften im laufenden Programm.
- ABER: "statisch/dynamisch ist STUFEN-RELATIV: was der Planer zur Laufzeit AUS der XML permutiert
  (dynamisch), friert der CEB beim Bau der Tier-Binary zu einer Compile-Konstante ein (monomorph,
  EIN Algorithmus, kein std::variant/visit im Objektcode — deckt §23). Die CompileFn/SourceGenFn-
  Naehte SIND diese 'dynamisch-Vorstufe -> statisch-Folgestufe'-Bruecke."
- Loest die scheinbare Spannung opt_level-als-Unter-Achse (§21.B, Planer-dynamisch) vs.
  compile-time-eingebacken (§23, Tier-Binary-statisch): "beides stimmt, auf verschiedenen Stufen."

### 1.3 Memory-Kanon (MEM/feedback_haupt_achse_static_unter_achse_runtime_chain_ct_wiring.md, KOMPLETT)

Kern (Z.10): Haupt-Achsen = i.d.R. statisch/CT fest verdrahtet; Unter-Achsen = i.d.R. RT-Eigenschaften;
ABER Kette Planer->CEB->Tier: "die dynamischen (Runtime-)Einstellungen der VORHERGEHENDEN Stufe sind
oft die zu uebernehmenden compile-time-Draehte der gebauten NACHFOLGENDEN Stufe."
How-to-apply (Z.14-18): (1) Ebenen-relativ denken (Planer-dynamisch / CEB-compile-time /
Tier-Binary-eingefroren); (2) Haupt-Achse praegt Binary-Identitaet/Gattung, Unter-Achse = RT-
Auspraegung "bis die Folgestufe sie einfriert"; (3) Uebergabe-Muster = CompileFn/SourceGenFn-Naehte;
(4) §23-Konsequenz: in der GEBAUTEN Stufe monomorph einkompiliert, die "Runtime-Freiheit" der
Unter-Achse gehoert in die ERZEUGENDE Stufe (Planer-XML-Permutation), NICHT in den Objektcode.

### 1.4 §28 — DREI Achsen-Art-Registries + Haupt-statisch/Unter-dynamisch (LEDGER:2223-2231, 19.07.)

User-Direktive verbatim-treu (LEDGER:2225): "Bezueglich der Achsen-Registries traegt immer eine
Haupt-Achse (statisch im Ziel-Binary) auch optionale Unter-Achsen-Einstellungen (meist dynamisch im
Ziel-Binary). Jede der 3 Achsen-Arten braucht ihre EIGENE Registry in IHREM Modul per XML."
Haupt-/Unter-Semantik im Angebot (LEDGER:2227): "Haupt-Achse = CT-statisch einkompiliert (binary_id
bei Organ; build_version/Sidecar bei System); ihre Unter-Achsen-Einstellungen = meist dynamisch im
Ziel-Binary (RC-POD/DynamicDims/Runtime-Werte)"; Layer-Modell 10.07.: "statische Achse = strikter
Layer, darunter dynamische Achsen-Nodes bis zur naechsten statischen Einhaengung."
[Stand 26.07. -> V7.2] (LEDGER:2229): System-Angebot = GENAU DREI Glieder der EINEN Komplex-Haupt-
Achse target_isa/operating_system/external_utils; "compiler+opt_level+atomic128 = untrennbare
Unter-Achsen-GRUPPE; SIMD = Meta-Meta unter dem external_utils-Hub; scheduling = Unter-Achse von
target_isa."
§54-T2/§47-Nachtrag (LEDGER:2231): auch Mess-Registry Haupt/Unter geteilt — HAUPT = Mess-Tooling
{Wallclock/Makro/Micro-Observer} (statisch/CT, je Wahl eigene CEB-Strecke ceb:build:[a,b,c],
Stempel §43); UNTER (Planer-gesteuert) = Ablaufmethodik/Workloads/16 measurement_categories/
Rueckschrieb-Methoden — manifestieren sich als CSV-Spalten, sind aber echtes Registry-Angebot.

### 1.5 §30 — Stufen-Zuordnung der Binary-Kette (LEDGER:2249-2268, 19.07.)

User-Entscheid Punkt 5 (LEDGER:2260): "Planer = Mess-Achsen · CEB = System-Achsen · Tier-Binaries =
Organ-Achsen + Hybrid-Einschub"; Punkt 6: 3-4 Binaries in EINER Kette, top-down sequentiell
GENERIERT; Registry-Speisung (LEDGER:2264): Mess-Registry->Planer · System-Registry->CEB ·
Organ-Registry(+prt)->Tier. CT-Doktrin ueber die Stufen (LEDGER:2266): "jede Vorstufe friert die
Wahl der Folgestufe als CT-Draht ein (stufen-relativ)."
WICHTIG — KORREKTUR-VERWEIS 05.08. (LEDGER:2253, Owner-abgenommen mittag-11): die Ein-Binary-
Zuordnung des §30 ist die STUFE-1-TRAEGER-Zuordnung (wo die RT-Freigabe jeder Achsen-Art sitzt) und
durch die kanonische DEHNBARE Stufen-Doktrin (mittag-9/-10) praezisiert.

### 1.6 KANONISCHE STUFEN-DOKTRIN (Owner-abgenommen; die juengste Praezisierung des Musters)

mittag-9 OWNER-VERBATIM (LEDGER:4082):
> "Das war nur fast richtig: Die Mess-Achsen sind DREISTUFIG Symmetrisch, die Sytem-Achsen sind
> ZWEISTUFIG symmetrisch und die Organ-Achsen sind ZWEISTUFIG symmetrisch, wobei die erste stufe
> immer Runtime Freigabe und die nachfolgenden Stufen compile time Einbau sind
> Planer->CEB-TierBinaries . Wenn wir die Hybriden betrachten und sie als vierte Stufe eingeschoben
> sind, erben sie ALLE Eigenschaften vorausgegangener Stufen und geben die Eigenschaften der
> Mess-Achse an ihre Tier-Binaries zur compile Zeit weiter"

mittag-10 OWNER-VERBATIM (LEDGER:4089):
> "Die System-Achse ist exakt wie die Messachse dehnbar stufig gegen die eingeschobenen Hybriden und
> die Hybriden geben sich selbst und ihren Tier-Binaries die System-Achsen-config per compile time
> mit. Die Organ-Achsen sind eigentlich nur in den Tier-binaries verbaut und beruehren die Hybriden
> nicht direkt, da die Hybriden ein factory pattern - facade - Adapter sind"

KANONISCHE GESAMT-FORM (LEDGER:4090, mittag-9+10 vereint; Abnahme mittag-11 LEDGER:4095 "Jetzt ist
alles korrekt ... Volles go"):
- MESS-Achsen: Planer(RT-Freigabe) -> CEB(CT: Mess-Design inkl. Pruefdock-Konfiguration) ->
  [Hybrid(CT)] -> Tier(CT: Observer/Ausstattung) — DREISTUFIG DEHNBAR.
- SYSTEM-Achsen: CEB(RT-Freigabe HW) -> [Hybrid(CT): gibt sich SELBST + seinen Tiers die
  System-Config per Compile-Time mit] -> Tier(CT) — ZWEISTUFIG DEHNBAR exakt wie Mess.
- ORGAN-Achsen: NUR in Tier-Binaries VERBAUT (CEB-RT-Freigabe der Permutations-Wahl ->
  Tier-CT-Einbau); beruehren Hybride NICHT direkt (Hybrid = Factory-Pattern-Facade-ADAPTER,
  organ-frei, delegiert per Command an echte Organ-Tiers).
- GESETZ: "Die ERSTE Stufe ist IMMER Runtime-Freigabe in der Traeger-/Freigabe-Binary, alle
  NACHFOLGENDEN Stufen sind Compile-Time-EINBAU entlang der Kette Planer->CEB->Tier-Binaries."
- HYBRID-VERERBUNGS-GESETZ (LEDGER:4084): Hybrid als 4. Stufe ERBT ALLES, reicht Mess+System CT
  weiter; traegt Mess- UND System-Stempel-Zeilen, KEINE Organ-Permutations-Identitaet (LEDGER:4091
  Konsequenz c — "binary_id bleibt Organ-only bei echten Tiers").

### 1.7 §37/§37.b — Freigabe-Prinzip + DUAL-NATUR-Register (LEDGER:2342-2356, 19.07. + V7.2-Vermerk)

- §37 Punkt 4 (verbatim-treu, LEDGER:2349): "Die Freigabe betrifft NUR statische System-HAUPT-Achsen
  — NICHT die dynamischen System-UNTER-Achsen, die (wie etwa Threads) als Runtime-Variable an die
  Tier-Binaries als Direkt-Einstellung fuer eine Messung durchgereicht werden."
- V7.2-WARNVERMERK (LEDGER:2352) — die dokumentierte DUAL-NATUR-Liste (RT-Unter an der Vorstufe UND
  CT-Haupt an der Folgestufe): "NUMA/locking + page_type (CEB unter target_isa -> Tier) ·
  compiler-Gruppe (CEB -> Tier) · Mess-Tooling/load_framework (Planer -> CEB) · SIMD/AVX
  (external_utils gibt frei -> Tier). CT-Haupt am Tier = einkompiliert + gestempelt im System-Array,
  NICHT binary_id-Segment -> golden-neutral." — Das IST die dokumentierte Form des abend-5-KERNs
  ("Laufzeit-Hauptachse der CEB = zwangsweise CT-Hauptachse der Tier-Binary") fuer die
  compiler-Gruppe.
- §37.b (LEDGER:2354-2356): CEB bestimmt ZUR LAUFZEIT aus ihren System-Achsen-Freigaben, was gebaut
  werden darf, und delegiert die Kompilation (BuildOrchestrator::provision_all/CompileFn =
  Delegations-Naht); Zulaessigkeits-Filter (Organ <= System-Freigabe) sitzt an der
  CEB-Bau-Delegations-Naht. KORREKTUR-VERWEIS mittag-11 (LEDGER:2344): §37 beschreibt NUR die
  System-Stufe-1-RT-Freigabe; vollstaendige Semantik = kanonische Stufen-Doktrin 1.6.

---

## 2. Die COMPILER-HAUPTACHSE: Flags als Teil der HAUPT-Achsen-DEFINITION

### 2.1 Memory-Kanon (MEM/project_compiler_systemachse_traegt_dynamische_xml_unterachsen.md, KOMPLETT)

- User-Ruling 17.07.: Compiler-System-Haupt-Achse (gcc|clang) = "TRAEGERIN dynamischer Unterachsen
  je Compiler: Optimierungsstufe (O0..Ofast), Flags und Commands (je Compiler VERSCHIEDEN) werden
  als Unterachsen darunter verwahrt und permutiert". Opt-Level ist KEINE Geschwister-Achse.
- PRINZIP F3: "In einem dynamischen, XML-getriebenen System existiert 'global' NICHT" — alles per
  XML konfigurierbare Achse mit XML-konfigurierbaren Unterachsen.
- OF-1/2/3 (17.07.): parallele Unterachsen opt_level (voll {O0..Ofast}) · flags/cflags · commands ·
  CPU-Erweiterungen (SIMD/AVX als Fold-in; GPU/FPGA-Array separat). OF-2: NICHTS gepinnt, CEB-
  Default=Ofast, per XML ueberschreibbar. OF-3: commands + flags/cflags als parallele Unterachsen
  unter derselben Compiler-Haupt-Achse.

### 2.2 system_axis_registry.xml — der Ist-Stand der dokumentierten Definition (CE/libs/cache_engine/include/cache_engine/measurement/system_axis_registry.xml)

- Kopf-Kommentar Z.5-7 (DIE Fundstelle der CT/RT-Semantik + Flag-Materialisierung):
  > "Haupt-Achse=CT-statisch (stage=ct, in die CEB/Tier-Binary einkompiliert); Unter-Achse=dynamisch
  > (stage=runtime, vom Planer permutiert). Q2/K2: opt_level/simd/atomic128 materialisieren als
  > CompileFn-Flags (build_version-Suffix), NIE als Laufzeit-Typ-Switch und NIE in der binary_id."
- Toolchain-Gruppe (Z.94-153): `system_complex_axis id="build_target_complex"` (Command-Pattern-
  Wrapper der DREI Haupt-Achsen target_isa/operating_system/external_utils, "KEINE vierte
  Haupt-Achse", Z.95-97) traegt `sub_axis_group id="build_toolchain"` mit compiler{gcc,clang}
  (stage="ct", Z.109-111: driver g++-16/clang++-22, supports_fno_gnu_unique) + opt_level
  (stage="runtime", 5 Optionen O0..Ofast, je Option KONKRETE FLAGS je Dialekt, z.B. Z.128-132
  O3: gpp="-O3"/clang="-O3"/msvc="/O2"; Ofast ieee754_deterministic="false") + atomic128
  (stage="runtime", no_cx16/cx16 mit Flag "-mcx16", Z.139-150). Kommentar Z.102-105: die Gruppe
  "beschreibt den BAU aus der Rekombination aller drei Achsen (O-1r) ... opt_level und atomic128
  haengen unveraendert an compiler."
- SIMD-Unterachse + simd_feature_catalog (Z.51-92): je Option/Feature die exakten Compiler-Flags
  (-mavx2, -mavx512f, ... 23 Flags mit tier-Zuordnung avx512/avx256/companion/scalar) + Maschinen-
  Signaturen (Z.154-201). => Die FLAGS stehen als WERTE-INHALT DER ACHSEN-DEFINITION in der
  System-Art-Registry — genau die "dokumentierte" Definition, auf die sich abend-5/F1 beruft.

### 2.3 "statisch verbaut" — Fundstellen-Befund (EHRLICH)

Die woertliche Formulierung "statisch verbaut" existiert im Plan-Korpus NUR im abend-5-Owner-Zitat
selbst (LEDGER:4204; grep ueber super docs/ + ce docs/ + libs: einzige weitere Treffer sind
Workflow-Rohdaten-Backups). Die SACHLICHE Dokumentation, auf die der Owner verweist, ist mehrfach da:
1. Registry-Kopf Z.5-7 (2.2): opt_level/simd/atomic128 => CompileFn-Flags, in die CEB/Tier-Binary
   einkompiliert, build_version-Suffix, nie binary_id.
2. Dual-Natur-Register V7.2 (LEDGER:2352): compiler-Gruppe = RT-Unter an der CEB UND CT-Haupt an der
   Tier-Binary, "einkompiliert + gestempelt im System-Array".
3. §62-B (LEDGER:3363, Klammer-Vermerk): "Cache-Schluessel = Stempel inkl.
   Compile-Einstellungs-Stempel §61-STUFEN."
4. build_version-Suffix-Kette am Ist: Suffix `+ext+cxx+opt+ceb[+target]` (Achsen-Nachschlagewerk
   INC2D-DELTA, LEDGER:2246 Punkt 8) bzw. heute `+cxx/+opt/+ext/+bt/+gate/+ceb`
   (CE .../builder/system_version_suffix.hpp:39 via W10-Dossier; F7-Spez Glied (a), SESS/20260801-
   KONSOLIDIERT-...md:72).
5. §32-F1/Q2/K2-Linie (LEDGER:93, §0-GOAL-V7-Anhang): "opt permutiert O0/O1/O2/O3 x simd ... System-
   Config binary_id='never' -> alles im Suffix/Sidecar, golden-neutral."
FAZIT: "Flags = Teil der Compiler-HAUPT-Achsen-Definition (RT auf der CEB, CT in der Tier-Binary)"
ist dokumentiert (Registry + Dual-Natur-Register + Suffix-Kette); der Neuanker muss diese
dokumentierte Definition nun ins FINGERPRINT-Preimage heben (heute fehlend, s. 3.4).

### 2.4 Versions-FLAG-Grammatik (Owner Q3-final 02.08., verbatim)

SESS/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md:62:
> "Die Kurzform ist verboten, Versionierungen sind einheitlich und immer 3-Stellig und beginnen mit
> 'v'. Das 'e' ist eine Flag und kann spaeter gegen andere Falgs wie 'g' fuer GPU, 'c' fuer CPU,
> 'f' fuer FPGA und 'n' fuer NPU code erweitert werden. Wir produzieren nur CPU code, daher muessen
> alle Versionen mit 'c' oder 'ce' enden. Bitte halte das so fest"
Auslegung (:65-69): IMMER vX.Y.Z + genau ein Hardware-Flag (c/g/f/n), optional 'e' danach;
Kurzform-Sentinel; CT-Wache "genau ein Hardware-Flag, im CPU-Scope 'c'" (A13-M1b). Vollzogen in
A13-M3/C4 (alle Literale v1.0.0c, ENFORCE=1; gerendert praefixfrei `@1.0.0c` per Q10). Memory:
MEM/feedback_versions_flag_grammatik_dreistellig_hw_flag.md.

### 2.5 Stempel-Regression-KERN (Owner E2 02.08.; MEM/feedback_stempel_regression_keine_merge_zeile_meta_meta_realm_ende.md)

Meta-Meta-Stempeleintraege PFLICHT wie alle Hauptachsen, dynamisch per Metaprogrammierung ANS ENDE
der bestehenden Realm-Zeile; die merge-Zeile darf NICHT existieren (PRT-ART laeuft merge GEGEN die
Organ-Achsen); 'e'-Suffix je experimentellem Pruefling-Achsen-Algorithmus; das Ist-5-Zeilen-Layout
(organ/system/measurement/merge/sha512) war defekt. => Umgesetzt in A13-M2/M3 (merge-Zeile entfernt,
POD 136->120, Layout 6). E3: die drei OS-Unter-Achsen (os_version/kernel/build) JETZT Pflicht —
als RT-Unter-Achsen NIE im Binary-Stempel (A-15), Zuordnung ueber Mess-Spalten/Dateinamen (OS-U4).

---

## 3. FINGERPRINT-VERSIONIERUNGS-VERANKERUNG (K7b/F7 + A13-M3 + W10 + §62-D)

### 3.1 K7b/SHA512-Konsolidierung + F7-Spez KOMPLETT (SESS/20260801-KONSOLIDIERT-gesamtarchitektur-lager-batch-eta-sha512.md)

- :42 (Stempel/SHA512): constexpr/consteval SHA512 UEBER die String-Arrays der Stempel-Zeilen,
  "alle Stempel-Haupt-Achsen MIT VERSION + HASH ALLER OVERLAY-SOURCE-DATEIEN; eigene Stempel-Zeile;
  nie zur Laufzeit berechnet"; CEB stempelt Tier-Binaries, Planer die Mess-Achsen der CEBs; OE-C:
  CEB UND Planer je EIGENES Stempelsystem.
- :44 (Invalidierungs-SOLL, OE-C): "Version-Bump EINER Haupt-Achse => Neubau ALLER Binaries, die
  sie beinhalten"; der Fingerprint ist die Universal-Klammer — jede Versions-/Quell-Aenderung
  verschiebt ihn.
- :46-47 (F7): Skip-Pruefung NUR gegen die SHA512-Validierung ("das war der Sinn des SHA512");
  verdraengt dll_is_current-Dreifach-Stringvergleich .version/.algos/.variant UND G-C1
  "viertes Gate, opt-in".
- :72 (F7-SPEZ, PREIMAGE-VOLLSTAENDIGKEITS-PFLICHT — die Plan-Glieder-Liste):
  (a) "build_version-Glieder inkl. +cxx (REAL erkannte Compiler-Version statt Treiber-Name,
      G-C4/OE-C), +opt/+ext/+bt/+gate UND +ceb auf dem Perm-Pfad (G-C2 — heilt Fall C) sowie
      +mtool/+mrg" — fingerprint_key_source wird die EINE Schluessel-Quelle: "Skip-Gate == minio-Key
      == Bestandslog key_sha512 == Baum-Blatt-Identitaet == ceb_key_sha512-Bindung";
  (b) "Variant-/Treiber-Enable-Menge (bvset-Signatur) als Preimage-Glied — deckt
      page_type/general_hardware"; COMDARE_VARIANT_GATE damit funktional obsolet;
  (c) System-Achsen-Code/build_version + Mess-/Framework-Versionen (heilt Faelle D/E) — per
      Selbstkritik :104 UEBERZEICHNET: bereits im Preimage (system_stamp_line/kSystemAxisCodeVersions,
      measurement_stamp_line tooling@X.Y.Z); real nur RF-6/70.6-Umstellung code_version->build_version;
  (d) Overlay-Source-Hashes (Pre-Build-Codegen -> consteval; heute leer, Dateimenge = Owner-Entscheid,
      :106).
  FORMAT-VERSION: "das Preimage-Layout traegt eine eigene fingerprint_format-Kennung als erstes
  Glied — Layout-Evolution mismatcht deterministisch statt still zu kollidieren."
  UEBERGANGS-REGEL: kein .fingerprint => FAIL-CLOSED Neubau (D-05/A-2, kein Grandfathering).
- :103 (schwerster Kritik-Befund, ins Soll uebernommen): das Sub-Achsen-WERTESET-Segment
  (sub=cacheline@vN,node_width@vN,alloc_hw@vN) fehlte in (a)-(d) — als explizites Preimage-Glied
  aufnehmen (Organ-Zeile traegt den Sub-Schwanz ausdruecklich NICHT; sonst wuerde ein Werteset-Bump
  unter NUR-SHA512 still reused).

### 3.2 Owner-ABNAHME-3+4 "Binary eindeutig" (26.07.) — die Wurzel der Verankerungs-Pflicht

MEM/project_bestandslog_abnahmen_baum_heuristik_stempel.md Punkt 3: "ALLE Stempel-Hauptachsen werden
als String in der Binary mit ihrer VERSION und dem HASH ALLER SOURCE-CODE-DATEIEN IM OVERLAY als
String gehasht -> zusaetzlicher SHA512-Fingerprint als weitere Stempel-Zeile (nie zur Laufzeit
berechnet; **Binary eindeutig**). CEB macht das fuer Tier-Binaries; der Planer (etwas kleiner) fuer
die Mess-Achsen der CEBs." — Ledger-Verdikt-Beleg LEDGER:3741: "OF-M3-1 = ENTSCHIEDEN via
Owner-ABNAHME-3 (26.07., 'Binary eindeutig') + F7 (01.08.) — Option A [Injektivitaets-Haertung] ist
die einzige KERN-konforme Form, UND sie war unvollstaendig: die F7-Konsolidierung
(20260801-KONSOLIDIERT-...md:72/:103) legt fingerprint_format-ERSTGLIED + Sub-Achsen-WERTESET-Segment
als Preimage-Glieder fest -> in C3 NACHGEZOGEN."
Ur-Quelle §62-B-Praezisierung-2 (LEDGER:3339-3340, User 22.07.): constexpr-Versionierungsinterface
je CEB/Tier-Binary, SHA512 ueber die String-Arrays der Stempel-Zeilen, CT berechnet; std::map-Lookup
SHA512 -> Pfad (Lookup-Infrastruktur, kein Hot-Path-Dispatch).

### 3.3 A13-M3/C3 — Preimage-Glieder-HISTORIE (SESS/20260803-DOSSIER-a13-m3-ausfuehrung.md + Ist)

- Format 1 (historisch, bis A13-M2): concat(organ + system + measurement + merge + overlay) OHNE
  Trenner (CE .../abi/anatomy_fingerprint.hpp:62; Dossier §1c: alte Signatur
  anatomy_fingerprint_hex(organ, system, measurement, merge, overlay=default) — inkl. der
  dokumentierten "ceb_version_stamp-Falle", Dossier :45).
- GA-01 [BLOCK] (Dossier :101-105): Preimage nicht injektiv (Konkatenation ohne Trenner;
  Demo-Kollisionen fp("","",X,"")==fp(X,"","","")). OF-M3-1 = Option A: Domain-Separator '\n'
  (ausserhalb des Stempel-Zeichenvorrats) zwischen ALLEN Gliedern, in allen 4 Zwillingen (Makro,
  lazy_adhoc_fingerprint_for, bestandslog_index/derive_key_from_lines, ceb_version_stamp) +
  Injektivitaets-Negativprobe — im EINEN C3-Commit mit Frozen-Neuanker.
- Format 2 (A13-M3, GELANDET — Ist CE .../abi/anatomy_fingerprint.hpp:64 "fingerprint_format=2",
  :105-123, 6 Glieder fest, '\n'-getrennt):
  [0] fingerprint_format-Kennung (F7-ERSTGLIED) · [1] Organ-Zeile (18 Haupt-Achsen, achse=algo@X.Y.Zc)
  · [2] System-Zeile (3 Haupt-Achsen + Meta-Meta-Klammer-Anhang) · [3] Mess-Tooling-Zeile (Haupt-Wahl
  + load_framework-Anhang) · [4] Sub-Achsen-Werteset-Segment (subaxis_valueset_segment.hpp:44-71,
  "sub=cacheline@vN,node_width@vN,alloc_hw@vN"; nie leer, '\n'-frei per static_assert) · [5]
  Overlay-Source-Hash (HEUTE LEER — OF-M3-2 Fallback B, Overlay-Dateimenge = offener Owner-Entscheid,
  anatomy_fingerprint.hpp:74-83).
  Single-Source anatomy_fingerprint_glieder(...) (:130-134) + benannte Position
  kAnatomyFingerprintSystemGlied=2 (W10-C3) + OverlayHash-Typ mit deleted overload (K-1).
- C4: Literal-Migration v1.0.0 -> v1.0.0c + ENFORCE=1 (ein Commit, deklariertes .algos-Byte-Ereignis).

### 3.4 W10-System-Zellwerte — was die System-Zeile HEUTE traegt / was FEHLT (SESS/20260803-DOSSIER-w10-system-zellwerte-bauplan.md + Ist)

- SOLL/Ist nach W10 (GELANDET; CE .../abi/system_cell_values.hpp = Single-Source der Zellwert-
  Grammatik; anatomy_version_stamp.hpp:125-134 "code -> code.<token>"): Ziel-Zeile (Dossier :131-132)
  `target_isa=code.x86_64@1.0.0c;operating_system=code.linux@1.0.0c;external_utils=code@1.0.0c;[simd=code.avx512@1.0.0c]`
  — Zellwerte NUR auf FAMILIEN-Ebene: target_isa-ISA-Id (x86_64/arm64), OS-FAMILIE (linux/windows/
  macos, GENAU DREI), external_utils OHNE eigenen Zellwert (Hub — sein Wert IST die Glieder-Menge),
  simd-Meta-Meta-Zelle (no_extension/avx2/avx512). Provenienz-Leiter configured_measured > measured >
  configured > na; na = FAIL-CLOSED, nie 0/leer.
- GRENZE A-15 (Dossier :101-105, LEDGER:3612): "RT-Unter-Achsen stehen NIE im Binary-Stempel"
  (os_version/kernel/build, numa/page, RAM-Frequenz/CAS/Fabrikation) — Instanz-Zuordnung ueber
  Mess-Spalten/Dateinamen (OS-U4).
- Was die System-Zeile per Plan NICHT traegt und wo es stattdessen wohnt: cxx/opt/build_type reisen
  im build_version-SUFFIX (+cxx+opt+ext+bt+gate+ceb; Einzel-Pfad Bestand system_version_suffix.hpp:39,
  Perm-Pfad '+ceb=' seit W10-M2 verdrahtet), bvset in der .variant-Signatur
  (build_variant_set_signature.hpp) — BEIDE heute NICHT im 6-Glieder-Preimage.
- => DIE OFFENE LUECKE (A2-Eichung-Nachreview, LEDGER:4115; Bewertung nachmittag-9 LEDGER:4127):
  C1 [HOCH, REAL] "Preimage ohne cxx/opt/build_type -> Combo-Wechsel im selben output_dir kann
  falsch skippen"; C6 [MITTEL, REAL] "kein bvset-Preimage-Glied". O-2 Option A = genau diese
  Vollformen JETZT als Achsen-Vollstaendigkeits-Neuanker (gebuendelt mit F1/F3/F4/F5), exakt die
  F7-Spez-Glieder (a)+(b) aus 3.1. Werteset-Glied [4] ist KOMPLEMENTAER (Sub-Achsen-CODE-Versionen,
  keine Zellwerte — Dossier :141-144); W10-M1: LagerKey-Zelle bleibt 3-feldig (combo/opt/simd),
  der SHA512 selbst diskriminiert OS/ISA(+simd).

### 3.5 Replay-Schluessel-Schichtung §62-D (User-bestaetigte Tabelle, LEDGER:3345-3350)

"Je Vertrags-Schicht ein EIGENER Replay-Schluessel; das #46-Cache-Log fuehrt alle drei getrennt:"

| Artefakt | Replay-Befugnis bestimmt durch | Sicht |
|---|---|---|
| CEB-Binary | Mess-Achse [a,b,c] | Planer |
| Tier-Binary | System-Achsen [d,e,f] ALLEIN | CEB[d,e,f][g,h,i] |
| Messwerte | [d,e,f] UND [g,h,i] GEMEINSAM + Maschinen-Hardware-Identitaet | messende Maschine |

- Hardware-Identitaet (Messwert-Replay): CPU-Typ/Fabrikation + RAM-Frequenz/CAS —
  AEQUIVALENZKLASSE MODULO UNGENUTZTER META-META-ACHSEN; zweistufiger Schluessel (Kern-Identitaet +
  bedingte Stempel-Anforderungen). Per V7.2 (LEDGER:3359): KEINE neuen System-HAUPT-Glieder —
  RAM/CAS/Fabrikation = Identitaets-/Unter-Merkmale (Einhaengung = offene Owner-Frage OD-2).
- BINARY-SHARING: "Sharing ist stempel-gekeyt, Messwert-Replay hardware-identitaets-gekeyt (zwei
  verschiedene Schluessel)." Zwei Bestands-Logs je Schluessel-Welt (LEDGER:3338).
- Glieder-Zuordnung per Plan (F7-Konvergenz, 3.1a): der EINE fingerprint_key_source-Schluessel
  traegt fuer die Tier-Binary [d,e,f]-System + [g,h,i]-Organ + Werteset + Overlay + Toolchain-Glieder
  (+cxx/+opt/+bt/+gate/+ceb) + bvset; die CEB-Identitaet keyt ueber ceb_legende=[a,b,c]-Klammer +
  ceb_key_sha512 (F8, KONSOLIDIERT:64 — ZWEI GETRENNTE Felder, keine id-Fusion); Messwerte keyen
  voll-permutativ [a,b,c][d,e,f][g,h,i] + Hardware-Identitaet (CSV/xlsx-Stempel §58).
- Stempel-Klammer-Form (Ebene 0, Owner 26.07., MEM/project_bestandslog_abnahmen... :24-26):
  CEB=[[a,b,c]]CEB · Tier=[[d,e,f],[g,h,i]]Tier-Binary · Mess=[[a,b,c],[d,e,f],[g,h,i]];
  Klammer-Anzahl kodiert die Ebene; RT-Unter-Achsen nie im Binary-Stempel, Haupt[Unter]-Voll-Klammer
  nur Mess-CSV/xlsx.

---

## 4. Synthese fuer den O-2-Neuanker (was "ALLE Achsen vollstaendig + versioniert im Fingerprint" konkret heisst)

1. JEDE Achsen-Art hat ihre Stempel-Zeile mit Algo@X.Y.Z+HW-Flag je HAUPT-Achse (Organ 18 · System 3
   + Meta-Meta-Anhang · Mess-Tooling + load_framework-Anhang) — vorhanden (Glieder [1]-[3]).
2. Das Preimage traegt zusaetzlich fingerprint_format-ERSTGLIED [0], Werteset-Glied [4], Overlay [5]
   (leer bis Owner-Mengen-Entscheid) — vorhanden seit A13-M3/C3.
3. FEHLEND (= der Neuanker-Inhalt, F7-Spez (a)+(b) / A2-C1+C6-Vollform): die CEB-LAUFZEIT-
   Toolchain-HAUPTACHSEN-Definition als CT-Glieder der Tier-Binary — REAL erkannte Compiler-Version
   (+cxx statt Treiber-Name), opt_level, build_type (+bt), +gate, +ceb (Perm-Pfad), +mtool/+mrg,
   SOWIE die bvset-Enable-Mengen-Signatur. Die FLAGS des Compilers (opt/simd/atomic128/march-
   Materialisierung, Registry 2.2) gehoeren per abend-5/F1 zur HAUPT-Achsen-DEFINITION selbst und
   muessen damit fingerprint-wirksam werden — nicht nur build_version-Suffix/Sidecar.
4. Stufen-Konformitaet: die Verankerung folgt der kanonischen Stufen-Doktrin (1.6) — Stufe-1-RT-
   Freigabe (CEB) wird als CT-Einbau der Folgestufe (Tier) gestempelt+gehasht; Hybrid traegt
   Mess+System-Stempel, nie Organ-Identitaet; binary_id bleibt Organ-only/golden-neutral
   (Registry binary_id="never", LEDGER:2352).
5. Danach: TP1-Wiederholung + 4+1-Beweise/B10 EINMAL auf finalem Stand (LEDGER:4205; B10 abend-4:
   Variant-Gate-E2E ankert kuenftig auf Fingerprint-Mismatch, KONSOLIDIERT:72/:108).
