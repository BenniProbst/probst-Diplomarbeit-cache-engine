# DOSSIER W10 -- System-ZELLWERTE in die system_stamp_line (BAUPLAN, Phase 2)

> Stand: 2026-08-03 spaetnachts, Planungssession wf_600bc26d (Task #8); REVIEW-NACHBESSERUNG
> 03.08. eingearbeitet (Befunde B1-B5, s. Review-Vermerk unten) -- dabei ALLE Anker erneut live
> nachgelesen. READ-ONLY erhoben; alle
> Code-Anker live verifiziert auf ce development 0b3a0b39f0b471c88af6d2915d0b3a5e58e3bd65
> (nach OD-10-RT; Gate-Zahl der Linie lokal 332). Pfad-Legende: SUPER =
> /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine, CE = SUPER/Code/external/comdare-cache-engine.
>
> AUTORITATIVE DEFINITION (bindend): FAHRPLAN:14 -- "W10: System-ZELLWERTE in die system_stamp_line
> (beendet Skip-nur-gleiche-OS-Familie; deklariertes Byte-Ereignis)." Herkunft: A14-Review-Befund B1
> (CONFIRMED, KERN) -- ohne W10 ist Owner-E3 (Wiederverwendbarkeit/Zuordbarkeit) NICHT eingeloest
> (BAUPLAN 20260802:8). Sequenz bindend: ... -> A1-Lager-Rest -> **W10** -> E-24 (eigenes Fenster,
> A8-Kopplung) -> A2-Eichung ZULETZT (LEDGER:3756/:3770; FAHRPLAN:45-46; L14 FAHRPLAN:58).

## Review-Vermerk (Nachbesserung 03.08. -- Befunde B1-B5 abgearbeitet, je quittiert)

> **REV2-VERMERK (zweite adversariale Runde wf_600bc26d + Lead-Einarbeitung 03.08. spaetnachts):**
> B1/B3/B4/B5 = PASS (je am Objekt verifiziert). B2-REST [CONFIRMED, war blockierend]: Die
> Marker-Praemisse traf am PERM-Pfad nicht -- beide Perm-Schleifen fuellen perm_parts OHNE .ceb
> (profile_run_entry.hpp:851-863; experiment_run_entry.hpp:296-308), das '+ceb='-Glied existierte
> dort gar nicht; der Bump waere genau am Scharfschalt-Pfad unsichtbar geblieben. Vom Lead nach
> REV2-Spezifikation eingearbeitet: C4 verdrahtet perm_parts.ceb in BEIDEN Perm-Schleifen aus der
> EINEN decl-Quelle + cache_key_prefix-Dedupe (artifact_cache.hpp:283-286); Sektionen 1/2/3/4
> pfad-differenziert korrigiert; C4-Orakel(v) laeuft AUSDRUECKLICH am Perm-Pfad (Glied erscheint
> erstmals; Doppel-+ceb-grep == 0). Die Objekt-Belege stammen aus REV2 (dort literal verifiziert).

- **B1 [CONFIRMED, Orakel-Defekt] ABGEARBEITET:** C2-Orakel(ii)/C3-Orakel pinnten den seit
  A13-M3/C3 (bfc98008) HISTORISCHEN Frozen-Vektor 0f0c0eb4...c31b93
  (test_m_w12_stamp_bausteine.cpp:544 woertlich "ist damit historisch; er steht in der
  git-Historie"). Literal-Tausch vollzogen: lebender Anker ist kFrozenFingerprintV1 =
  0fe275bd...cc9fe36 (test_m_w12_stamp_bausteine.cpp:564-566; Zweitmodul
  test_g3_sha512_index.cpp:45). Sektion 2 (C2/C3) und Sektion 3 tragen jetzt das lebende
  Literal; die Kopfzusage "alle Code-Anker live verifiziert" ist damit wieder wahr.
- **B2 [CONFIRMED, Plan-Luecke] ABGEARBEITET:** Stille NICHT-Invalidierung der lokalen zweiten
  Verteidigungslinie (dll_is_current W10-blind: .version/.algos/.variant aendern sich durch C4
  alle nicht; prae-W10-Binaries in gn_out CI-persistent via GIT_CLEAN_FLAGS) GESCHLOSSEN via
  neuem **Manager-Entscheid W10-M2** (Sektion 1): kCebContractCodegenMinor 1 -> 2 im C4-Commit
  nach M4-Muster (LEDGER:3760) -- dll_is_current-sichtbarer Marker '+ceb=7.1' -> '+ceb=7.2',
  neuer Store-Bucket, genau EIN deklarierter Pin-Tausch (R5D_CebContract). Alternative
  gn_out-/Lokal-Purge VERWORFEN (nicht mechanisch: runner-persistente gn_out + 4 Klone -- ein
  Ereignis kann verpasst werden, ein Marker nicht). Sektionen 2 (C4 + Orakel v), 3
  (Wirkkette/Abgrenzung) und 4 (Skip-Wirkung am stalen Lokal-Bestand) nachgezogen.
- **B3 [Drift, non-blocking] ABGEARBEITET:** ALLE LEDGER:xxxx-Anker des Dossiers gegen den
  lebenden Ledger re-verifiziert und neu geankert (+6-Drift durch die nach Dossier-Erstellung
  eingefuegten '[Stand 03.08.]'-Inline-Annotationen). EINE Korrektur gegenueber der
  Review-Liste: der A-15-/OS-U4-Wortlaut ("A-15 -- RT-Unter-Achsen stehen nie im Stempel";
  "Die Instanz-Zuordnung einer Messung laeuft ueber Mess-Spalten/Dateinamen (OS-U4)") steht
  live in LEDGER:3612 (OS-U2-Suffix-Zeile), NICHT :3611 -- am Objekt verifiziert, so geankert.
  C5 re-ankert bei Landung erneut (Anker-Pflicht dort vermerkt).
- **B4 [minor] ABGEARBEITET:** Explizite Fixture-Pin-Auflage an wf_eb0cf566 als bindender Satz
  in Sektion 6 ergaenzt (Baum-Writer-/LB-Tests frieren KEINE prae-W10-Stempel-Zeilen-/
  Fingerprint-Literale ein -- "Gruene Tests zementieren alte Ordnung", 3x real O-8).
- **B5 [Risiko-Notiz, kein Fail] QUITTIERT:** Risiko-Absatz in Sektion 6 ergaenzt (Wandzeit der
  5x-Frischbau-Doppellauf-Kadenz; Basis-Abhaengigkeit von der Lager-Rest-Landung wf_eb0cf566
  samt Merge-Regel). Erwartung 332 -> 333 bestaetigt (M4=331 + OD-10-RT=+1 = 332 heute).
  Schaetzung um den W10-M2-Anteil leicht angehoben; FAHRPLAN-Fenster Phase 2 traegt bis Di 05.08.
- **POSITIV-BILANZ zur Kenntnis genommen:** Mandate (a)/(d)/(f) ohne Aenderungsbedarf bestaetigt
  (Sektionen vollstaendig; Stempel-KERN eingehalten: keine merge-Zeile, Meta-Meta am
  Realm-Zeilen-ENDE, 'e'-Suffix/Flag-Grammatik byte-unberuehrt, A-15-Wache C1f; kein
  POD-Kapazitaetsrisiko fuer 'code.<token>'; E-1-Default (a) traegt; W10-M1 am Objekt
  konsistent; kAllTargetIsaIds ohne riscv64 = E-3-Default (a) kanon-gedeckt).

## 0. Kopf-Vermerke (Supersede + RA/RB-Abgleich)

**0.1 OP-5-SUPERSEDE (hiermit formal verbucht):** Die E24-Dossier-v1-Empfehlung "W10 im M3-Fenster
mitfahren" (backups/20260803-design-nachtraege-final/E24-A16P1-dossier.md:152/:165-167/:269) ist
durch die Ereignisfolge SUPERSEDED: A13-M3 ist OHNE W10-Zellwerte gelandet (LEDGER:3748-3756, C1-C6
ohne Zellwert-Anteil; A13 KOMPLETT LEDGER:3761). W10 ist das eigene Phase-2-Paket der FAHRPLAN-Linie
(Manager-Entscheid V3, LEDGER:3737: getrennte Fenster M3->M4->E-24; OVK:182). Die E24-Neufassung
(E24NEU:33, Option C') fuehrt bereits die getrennte Kette.

**0.2 RA/RB-Widersprueche am Objekt geprueft (read-only, 03.08. spaetnachts):**
- RA zitierte die System-Zeile mit `@1.0.0` (LEDGER:3644 = M2-Stand) vs. RB `@1.0.0c` -- KEIN
  Widerspruch: A13-M3/C4 hat die Flag-Migration vollzogen (system_axis_code_versions.hpp:7-10
  "SEIT A13-M3/C4 ... v1.0.0c ... DEKLARIERTE(s) Byte-Ereignis"). Ist-Golden live verifiziert:
  test_m_w12_stamp_bausteine.cpp:313 `target_isa=code@1.0.0c;operating_system=code@1.0.0c;`
  `external_utils=code@1.0.0c;[simd=code@1.0.0c]` (+ :376 CT-Parser-Probe, :608 EXPECT_EQ am
  Laufzeit-Ist). RB gilt.
- RA-Anker "anatomy_version_stamp.hpp:89-95" (Stand 02.08.) ist auf :118-123 gedriftet -- live
  verifiziert, W10-ANSCHLUSS-Wortlaut unveraendert dort. Test-Pin-Anker ":122-124/:300/:378" sind
  auf :313/:376/:608 gedriftet. Nur Zeilen-Drift, kein Sach-Widerspruch.
- Beide Recherchen stimmen im KERN ueberein: Zeile traegt heute NUR Code-Versionen; CEB-Naht
  (perm_compile) + Compile-Define ist der im Code selbst benannte Anschluss (:121-123).

**0.3 Verifizierte Kern-Mechanik (Grundlage des Schnitts):** Der Emitter schreibt die System-Zeile
als C-STRING-LITERAL in die emittierte Modul-Quelle (adhoc_emitter.hpp:86-130,
`COMDARE_ANATOMY_VERSION_STAMP[_M]("...", "<system>", ...)`); das Makro materialisiert POD +
consteval-SHA512 aus den Literalen (anatomy_module_abi_v1.hpp:133-168, kFP via
anatomy_fingerprint_hex ueber anatomy_fingerprint_glieder). Preimage seit M3 injektiv: 6 feste
Glieder, '\n'-Separator, Glied [2] = System-Zeile (anatomy_fingerprint.hpp:104-123). Der
Lager-Key nutzt DENSELBEN Weg (bestandslog_index.hpp:60 derive_key_from_lines; Laufzeit-Zwilling
lazy_adhoc_fingerprint_for lazy_adhoc_source_gen.hpp:272). Define-Praezedenz existiert exakt fuer
diese Naht: `#ifndef COMDARE_OVERLAY_SOURCE_HASH / #define ... ""` (anatomy_fingerprint.hpp:83-86,
Muster COMDARE_GN_ALGO_SIG). perm_compile = die per-System-Zelle montierte CompileFn
(profile_run_entry.hpp:90 `compile_for_perm(opt_flag, march_flag)`; Naht-Doku
lazy_adhoc_source_gen.hpp:41-49).

## 1. SOLL je System-Achse (Zellwert, Quelle, Provenienz, n/a-Regel)

**GRENZE (bindend, A-15):** NUR Haupt-Achsen-Zellwerte auf FAMILIEN-Ebene. NIE Instanz-/RT-Werte
(os_version/kernel/build, numa/page, RAM-Frequenz/CAS/Fabrikation) -- "RT-Unter-Achsen stehen NIE im
Binary-Stempel" (LEDGER:3612; A14REV:90); Instanz-Zuordnung einer Messung laeuft ueber
Mess-Spalten/Dateinamen (OS-U4, LEDGER:3612 -- beide Wortlaute live in DERSELBEN
OS-U2-Suffix-Zeile verifiziert). Die Wache dafuer wird MECHANISCH (Abschnitt 5).

**PROVENIENZ-LEITER (je Wert, absteigend):**
`configured_measured` (deklariert UND laufzeit-/CT-bestaetigt, Cross-Check bestanden) >
`measured` (nur erhoben/CT-bekannt, keine Deklaration vorhanden) >
`configured` (nur deklariert, nicht bestaetigbar) >
`na` (weder noch). Widerspruch deklariert vs. erhoben = BAU-FEHLER (ehrliche Fehlerklasse,
K4-Split wie OS-U3: Quellen-Zugang=HardwareProbeErrorClass, fehlende Familien-Schnittstelle=
BetriebssystemFeatureFehlt), NIE stiller Vorrang. Die Provenienz-Stufe reist NICHT in der
Stempel-Zeile (sie ist kein Familien-Zellwert), sondern im .version-Sidecar-Umfeld/Bau-Log.

**n/a-STATT-NULL (bindend):** Ein nicht bestimmbarer Zellwert reist als Sentinel-Token `na`
(Zeichenvorrat-konform: alnum + "=@;.+_[]" kennt kein '/' -- deshalb `na`, nicht "n/a"), NIE als
leerer String, NIE als 0 (Anti-Muster: Prod1-RAM ram_frequency_mhz==0/Unbekannt,
target_isa_complex_axis.hpp:127-133 -- genau die Form, die W10 nicht wiederholen darf). Ein `na`
in einem lager-faehigen Bau ist FAIL-CLOSED: kein Lager-Rueckschrieb, klassifizierte Fehler-Zeile
(deckt zugleich die riscv64-Auflage LEDGER:3658 mechanisch: ISA ohne Achsen-Glied => na => kein
Rueckschrieb).

| Achse (Slot) | Zellwert (Familien-Ebene) | Quelle an der CEB-Naht | Provenienz-Soll |
|---|---|---|---|
| `target_isa` (Entry 0, Ebene 0) | ISA-Id des Bau-Ziels: `x86_64` / `arm64` (kAllTargetIsaIds; riscv64 erst nach Achsen-Erweiterung, s. E-3) | CT der Bau-Plattform (platform_detection.cmake COMDARE_ARCH_*; nativer Bau => Host-ISA), durchgereicht von der CEB an perm_compile | `configured_measured`: CT-Ist gegen `<machine>`-Deklaration (resolve_machine_by_properties, O-4a-Tupel) cross-gecheckt; ohne Deklaration `measured` |
| `operating_system` (Entry 1, Ebene 0) | OS-FAMILIE: `linux` / `windows` / `macos` (GENAU DREI, OP-10; CT-Familie) | CT-Familien-Zelle der CEB (os_family_id()-Welt der OS-U3-Probe bzw. Plattform-#if; Factory-Zelle ISA x OS hardware_probe_factory.hpp:503-509) | `configured_measured` (Familie ist CT-beweisbar; `<machine>`-os-Attribute nur ERWARTUNG, LEDGER:3613) |
| `external_utils` (Entry 2, Ebene 0) | KEIN eigener Zellwert (Hub -- sein "Wert" IST die Glieder-Menge; Default aus E-2, Einspruch moeglich) | -- | -- |
| `simd` (Meta-Meta, Ebene 1, `[simd=...]`) | SIMD-Erweiterungs-Zelle des Baus: `no_extension` / `avx2` / `avx512` (Default aus E-2) | DIESELBE Zell-Variable der optxsimd-Schleife, aus der march_flag/ZellKoordinate[f]/.variant-simd_extension kommen -- EINE Quelle, keine zweite Ableitung | `measured` (Zellwahl des Laufs; identisch zur .variant-Signatur, Cross-Check trivial) |

**ZIEL-ZEILE (Default-Format aus E-1, Beispiel prod1):**
`target_isa=code.x86_64@1.0.0c;operating_system=code.linux@1.0.0c;external_utils=code@1.0.0c;[simd=code.avx512@1.0.0c]`
-- Zellwert als hierarchische Namens-Erweiterung des Algorithmus-Markers `code.<token>`. Das ist
HEUTE schon parser-legal ohne jede Grammatik-Aenderung: Owner-Q2-Namens-Toleranz -- "ein '.' VOR dem
'@' ist transparenter Namens-Bestandteil (Achse UND Algorithmus)" (LEDGER:3619/:3642), CT-bewiesen
am Muster 'prt-art.memory.abc@1.0.0'. Achsen-Namen bleiben kanonisch unangetastet (kSystemAxisOrder-
Konsumenten, A14-Guards). Token-Grammatik: `[a-z0-9_]+`, genau ein Zusatz-Glied, klein. Versionsteil
(X.Y.Zc, Flag-Grammatik) bleibt byte-unberuehrt. Meta-Meta-Anhang bleibt am Zeilen-ENDE (Owner-E2);
die Einfuegung geschieht IN den Entries, nicht dahinter.

**ABGRENZUNG WERTESET-GLIED (RA-Luecke geklaert):** Preimage-Glied [4] (`sub=cacheline@vN,...`,
subaxis_valueset_segment.hpp:44-71) traegt Sub-Achsen-CODE-VERSIONEN (F7-VERIFY gegen stillen
Werteset-Bump) -- KEINE Zellwerte. W10 (Zellwerte IN Glied [2], der System-Zeile) und das
Werteset-Glied sind KOMPLEMENTAER, nicht redundant. Keine Beruehrung von Glied [4] in W10.

**MANAGER-ENTSCHEID W10-M1 (hiermit gefaellt, Praezedenz L3/L5-Form):** Die ZellKoordinaten des
LagerKey bleiben DREI-feldig (combo/opt/simd, bestandslog_document.hpp:166-177) -- KEINE
OS-/ISA-Koordinate in der Zelle. Begruendung: Der LagerKey ist das TUPEL (SHA512, Zelle)
(bestandslog_index.hpp:104-110); nach W10 diskriminiert der SHA512 selbst OS-Familie + ISA (+simd)
-- genau die F7-Zusage "der SHA512 deckt die anderen Stempel allein" (LAGE:52). Eine Zell-Erweiterung
waere ein zweites, redundantes Byte-Ereignis im Lager-Schema mitten in der A1-LB-Schnitt-Welle
(Schema-Owner dort, L5). Wird dem A2-Eich-Fenster als deklarierte Entscheidung vorgelegt.

**MANAGER-ENTSCHEID W10-M2 (Review-B2-Nachbesserung, hiermit gefaellt, M4-Praezedenz):** W10-C4
bumpt kCebContractCodegenMinor 1 -> 2 (anatomy_module_abi_v1_decl.hpp:327). BEGRUENDUNG AM
DEKLARIERTEN ZWECK: die dort kodifizierte Bump-Klasse -- "wenn sich eine CEB-UNIVERSELLE
Codegen-Quelle aendert, die ALLE Tier-Binaries betrifft, OHNE das POD-/vtable-ABI zu brechen"
(decl:289-291) -- trifft W10-C4 woertlich, denn perm_compile injiziert ab C4 das Zellwert-Define
in JEDEN Tier-Bau. PROBLEM, DAS ER LOEST (Review-B2, CONFIRMED am Mechanismus): OHNE Marker
bleibt die lokale zweite Verteidigungslinie dll_is_current (build_orchestrator.hpp:251-276,
Dreifach-Sidecar-String-Gleichheit) W10-BLIND -- .version aendert sich nicht (W10 fuegt der
build_version KEIN Segment hinzu, OS-U2-Linie LEDGER:3612), .algos ist Organ-Sig, .variant ist
Zell-/ISA-Mengen-Sig (build_variant_set_signature.hpp:2-16): alle drei Gates passieren. Stale
prae-W10-Binaries in gn_out (CI-persistent via GIT_CLEAN_FLAGS '-e Code/gn_out',
experiment_plan_director.hpp:1013-1021, Literal :1020) wuerden still geskippt und truegen
kS/kFP OHNE Zellwerte -- "beendet Skip-nur-gleiche-OS-Familie" gaelte fuer den Lokal-Bestand
NICHT. WIRKUNG DES MARKERS -- PFAD-DIFFERENZIERT (REV2-B2-Rest, am Objekt CONFIRMED): Am
EINZEL-Pfad traegt die build_version das '+ceb='-Glied BEREITS (system_version_suffix.hpp:39;
profile_run_facade.cpp:398) -- dort wirkt der Bump direkt. Am PERM-Pfad existiert das Glied
HEUTE NICHT: beide Perm-Schleifen fuellen perm_parts OHNE .ceb (profile_run_entry.hpp:851-863;
experiment_run_entry.hpp:296-308), beide Basen lassen system_axes_version_suffix bewusst weg
(profile_run_facade.cpp:536-540 und :1078-1080 'BASIS ohne System-Achsen-Suffix'), und
artifact_cache.hpp:271-272 dokumentiert die Luecke woertlich. Der Perm-Pfad ist aber exakt der
Pfad, an dem C4 das Zellwert-Define scharfschaltet (compile_for_perm nur mit <system_axes>,
profile_run_entry.hpp:784-789) -- OHNE Verdrahtung waere der Minor-Bump dort UNSICHTBAR.
DESHALB VERDRAHTET C4 IM SELBEN COMMIT: (i) perm_parts.ceb = '<ABI-Major>.<kCebContractCodegenMinor>'
in BEIDEN Perm-Schleifen aus der EINEN decl-Quelle; (ii) cache_key_prefix stellt von 'anhaengen'
auf 'konsumieren/dedupe' um (artifact_cache.hpp:283-286 -- sonst Doppel-+ceb im Store-Key).
ERST DAMIT mismatcht jede prae-W10-perm.dll.version => mechanischer Neubau statt Skip, plus
neuer Store-Bucket. KEIN neues Suffix-SEGMENT: das '+ceb='-Glied ist am Einzel-Pfad BESTAND,
am Perm-Pfad wird es via (i) NEU VERDRAHTET (Glied-Klasse existiert, kein Grammatik-Ereignis);
die OS-U2-Linie (kein operating_system-Segment) bleibt byte-unberuehrt; binary_id
und perm.algos bleiben Organ-only-unberuehrt (decl:320-321). VERWORFENE ALTERNATIVE: einmaliger
gn_out-/Lokal-Purge vor dem ersten Post-W10-Lauf -- verworfen, weil nicht mechanisch
(runner-persistente gn_out je CI-Runner + 4 lokale Klone: ein Ereignis kann verpasst werden, ein
Marker nicht; Kanon "sauberste Strategie, nicht einfachste"). FOLGE-PFLICHT: der EINE literale
Pin R5D_CebContract (test_v41_anatomy_module_abi.cpp, decl:323-326) wandert deklariert mit --
exakt der M4-Praezedenz-Pin, kein weiterer Bestands-Pin bewegt sich.

## 2. COMMIT-ZUG (M3-Muster: gestufte Fenster, je Commit ein ORAKEL mit literalen Wachen)

Buendelung nach M3a/M3b-Praezedenz (M3DOSS:98/:160): W10a = C1-C3 golden-/byte-neutral (Naht ohne
Wirkung), W10b = C4 = das EINE deklarierte Byte-Ereignis, C5 = Doku/Ledger. EIN Worktree
(wt-w10, Basis development==0b3a0b39 oder juenger nach Lager-Rest-Landung), kein Push vor
Lande-Review; jeder Commit einzeln revertierbar.

**W10-C1 -- Single-Source `abi/system_cell_values.hpp` (NEU; golden-neutral).**
Inhalt: (a) Token-Grammatik-Wachen (`[a-z0-9_]+`, nie leer, `na`-Sentinel definiert); (b) die
kanonische Wert-Ordnung == kSystemAxisOrder + simd-Glied (Drift-Wache gegen system_axis_order.hpp
und ExternalUtilsHub::meta_metas); (c) `complete_system_stamp_line(zeile, werte)` als
constexpr/consteval-Vervollstaendiger: parst die Zeile ueber die BESTEHENDEN Werkzeuge
(parse_stamp_entries/count_stamp_entries), fuegt `.<token>` hinter den Algorithmus-Namen des
passenden Entries (Ebene 0 fuer die drei Haupt-Achsen, Ebene 1 fuer simd), rendert zurueck;
(d) Define-Naht `#ifndef COMDARE_SYSTEM_CELL_VALUES / #define ... ""` nach dem
COMDARE_OVERLAY_SOURCE_HASH-Muster (anatomy_fingerprint.hpp:83-86); Define-Wertform
`target_isa=<t>;operating_system=<t>;simd=<t>` (achsen-genannt, Vollstaendigkeits-Wache);
(e) leeres Define => IDENTITAET (byte-identische Zeile) -- das ist der golden-neutrale Grundpfad;
(f) A-15-VERBOTS-WACHE: die zulaessigen Schluessel sind ABSCHLIESSEND aufgezaehlt; os_version/
kernel/build/os_family/numa_node/page/scheduling brechen compile-hart (Muster der 9-Fallen-Wache
operating_system_sub_axes.hpp:140-150).
ORAKEL C1: neue TU `test_w10_system_cell_values` -- CT-Positiv-Probe (Beispiel-Vervollstaendigung
literal gepinnt, s. Ziel-Zeile oben), CT-Negativ-Proben (unbekannter Schluessel, Grossbuchstabe,
leerer Token, RT-Unter-Achsen-Schluessel, doppelter Schluessel -- je benannter static_assert-Text),
Identitaets-Probe (leeres Define => EXPECT_EQ byte-identisch). ctest-Namens-Diff GENAU +1;
Doppellauf 2x `100% tests passed ... out of 333`. test_m_w12-Golden :313/:376/:608 UNVERAENDERT
GRUEN OHNE EDIT -- das IST das literale Orakel der Emitter-Blindheit (system_stamp_line() selbst
wird in W10 NIE angefasst).

**W10-C2 -- Makro-Naht in `abi/anatomy_module_abi_v1.hpp` (golden-neutral).**
COMDARE_ANATOMY_VERSION_STAMP_M vervollstaendigt kS consteval ueber complete_system_stamp_line
(system_lit + COMDARE_SYSTEM_CELL_VALUES); kFP rechnet ueber die VERVOLLSTAENDIGTE Zeile; kSE parst
sie. Ohne Define ist alles byte-identisch (Identitaet aus C1e). KEIN POD-/Layout-Anfassen.
ORAKEL C2 (literal): (i) Voll-Bau + golden-Roundtrip: emittierte Modul-Quelle byte-identisch
(Round-Trip-Byte-Wache/CRC-Anker unveraendert -- der Emitter schreibt weiter dasselbe Literal);
(ii) B3-Frozen-Fingerprint-Vektor kFrozenFingerprintV1 = 0fe275bd...cc9fe36
(test_m_w12_stamp_bausteine.cpp:564-566, Zweitmodul test_g3_sha512_index.cpp:45) UNBEWEGT
literal -- NICHT der Alt-Vektor 0f0c0eb4...c31b93, der seit A13-M3/C3 (bfc98008) HISTORISCH ist
(:544 woertlich "ist damit historisch") und in keinem Orakel mehr taugt (Review-B1); (iii) Layout-Pins
unveraendert gruen OHNE EDIT: sizeof==120 (test_m_w12:442), Layout==6 (:446), K-4 `== 6`-Wache
(anatomy_module_abi_v1_decl.hpp:214-223) unangetastet; (iv) NEUE CT-Probe im Test: Makro-Expansion
mit gesetztem Test-Define liefert vervollstaendigte kS-Zeile + ANDEREN kFP als ohne Define
(Fingerprint-Diskriminierung literal bewiesen, Negativ-Probe: gleiches Werte-Set => gleicher kFP).

**W10-C3 -- CEB-Laufzeit-Zwilling (golden-neutral).**
lazy_adhoc_fingerprint_for (lazy_adhoc_source_gen.hpp:272) und der derive_key_from_lines-Aufrufer
(bestandslog_factory.hpp:47/:51) erhalten die Zellwerte als EXPLIZITEN Parameter (benannter Typ
nach K-1-Muster OverlayHash -- KEIN weiterer nackter string_view, Alt-Aufrufe brechen compile-hart
oder Default = leer/Identitaet) und rechnen ueber die vervollstaendigte System-Zeile. Der
consteval-Zwilling builder/ceb_version_stamp.hpp (dritter Ableitungsweg, LEDGER:3645) bleibt
UNBERUEHRT: der CEB-SELBST-Stempel/kCebFingerprint traegt KEINE Tier-Zellwerte (die CEB ist kein
Tier-Binary; ihre Identitaet ist die Code-Identitaet) -- als Kommentar-Wache dort deklariert.
ORAKEL C3 (literal): Zwillings-Gleichheits-Test -- consteval-Makro-kFP (C2-Probe) == Laufzeit-
Zwilling fuer DASSELBE Beispiel-Werte-Set (EXPECT_EQ auf den 128-hex-String; die EINE-Wahrheit-
Doktrin, Drift-Guard-Praezedenz A5CebVersionStamp ceb_version_stamp.hpp:7-13). Leeres Werte-Set
=> byte-identisch zum Vor-W10-Fingerprint (kFrozenFingerprintV1 = 0fe275bd...cc9fe36 als Zeuge,
test_m_w12_stamp_bausteine.cpp:564-566 + test_g3_sha512_index.cpp:45). Doppellauf 2x gruen.

**W10-C4 -- Naht-Scharfschaltung an perm_compile = DAS deklarierte Byte-Ereignis (W10b).**
compile_for_perm/perm_compile (profile_run_entry.hpp:90, optxsimd-Schleife :787/:811) haengt je
Zelle `-DCOMDARE_SYSTEM_CELL_VALUES="target_isa=<isa>;operating_system=<fam>;simd=<simd-id>"` an
die rsp-/Compile-Zeile; Werte-Herkunft wie Abschnitt 1 (EINE Quelle je Wert, keine Zweit-Ableitung);
derselbe Werte-String geht als Parameter in den C3-Zwilling (Lager-Key == einkompilierter
Fingerprint, konstruktiv gleich). FAIL-CLOSED-Wache: `na` in einem lager-faehigen Bau => kein
Rueckschrieb + klassifizierte Zeile. IM SELBEN COMMIT (W10-M2, Review-B2 inkl. REV2-Rest):
kCebContractCodegenMinor 1 -> 2 (decl:327; Bump-Klasse decl:289-291 trifft woertlich) -- der
dll_is_current-sichtbare Marker '+ceb=7.1' -> '+ceb=7.2' + neuer Store-Bucket; PLUS die
PERM-PFAD-VERDRAHTUNG (Sektion 1): perm_parts.ceb aus der EINEN decl-Quelle in BEIDEN
Perm-Schleifen (profile_run_entry.hpp:851-863; experiment_run_entry.hpp:296-308) + cache_key_prefix
auf konsumieren/dedupe (artifact_cache.hpp:283-286); der
R5D_CebContract-Pin (test_v41_anatomy_module_abi.cpp, decl:323-326) wandert als der EINE
deklarierte Pin-Tausch mit. COMMIT-MESSAGE deklariert das Byte-Ereignis (M3-C4-Muster,
M3DOSS:169; Wortlaut Abschnitt 3) INKLUSIVE der W10-M2-Invalidierung (M4-Muster LEDGER:3760).
ORAKEL C4 (literal): (i) rsp-/Command-Zeilen-Diff je Route (no_extension/avx2/avx512) literal im
Test/Log -- das Define erscheint mit den erwarteten Werten (Praezedenz C-3a-Auflage LEDGER:3572);
(ii) realer Probe-Bau EINER Binary: comdare_anatomy_version_lines()->System-Zeile literal ==
Ziel-Zeile (EXPECT_EQ), .fingerprint-Sidecar == CEB-Lager-Key (String-Gleichheit literal);
(iii) Negativ-Probe: zwei Baue gleicher Zelle => gleicher Fingerprint; simulierter
Fremd-Familien-Werte-String => ANDERER Fingerprint (die B1-Kollision linux==macos ist damit
mechanisch tot -- das ist DER W10-Abnahme-Beweis); (iv) kSystemAxisCodeVersions-B6-Asserts
UNVERAENDERT (kein Bump -- Wache system_axis_code_versions.hpp:81-96 bleibt auf v1.0.0c);
(v) W10-M2-Invalidierungs-Orakel (literal, AUSDRUECKLICH AM PERM-PFAD -- REV2-Rest): der
.version-Sidecar-Diff eines Perm-Baus zeigt das '+ceb='-Glied ERSTMALS (vorher: KEIN +ceb im
Perm-Sidecar -- genau die REV2-belegte Luecke; nachher: '+ceb=7.2'); am Einzel-Pfad zeigt der
Diff '+ceb=7.1' -> '+ceb=7.2'; Doppel-+ceb-Negativ-grep ueber den Store-Key == 0 (Dedupe-Beweis,
Praezedenz test_r2_suffix_wachen 'genau EIN +ceb='); ein prae-W10-Artefakt mit altem Sidecar wird
im Bau-Log literal als NEUBAU (nicht Skip) belegt -- dll_is_current-Mismatch bewiesen, nicht
behauptet; R5D_CebContract gruen NACH genau dem einen Pin-Edit (Negativ-Probe: ohne Pin-Edit
rot = Tripwire wirkt).

**W10-C5 -- Doku-/Anker-Vollzug (kommentar-only + Ledger).**
(a) Zweiphasen-Kommentar anatomy_version_stamp.hpp:118-123 auf VOLLZOGEN drehen (Verweis auf
system_cell_values.hpp als neue Single-Source); (b) Beifang K-6-Klasse: stale Kommentar
"(5 Achsen)" am System-Entry-Array (anatomy_module_abi_v1_decl.hpp:187, RB-Befund) auf "3 Haupt +
1 Meta-Meta" richtigstellen; (c) Uebergangsregel-Ende dokumentieren (Abschnitt 4); (d)
Ledger-Nachtrag (Byte-Ereignis-Verbuchung + TP1-Inventur-Signal).
ORAKEL C5: Kommentar-only MECHANISCH bewiesen via -fpreprocessed-Vergleich (M3/C6-Praezedenz
LEDGER:3750); Voll-Bau + Doppellauf unveraendert gruen. ANKER-PFLICHT (Review-B3): alle
LEDGER:xxxx-Anker dieses Dossiers bei der C5-Landung ERNEUT gegen den dann lebenden Ledger
verifizieren und ggf. nachziehen (Drift-Klasse '[Stand ...]'-Inline-Annotationen, 2x real).

## 3. Byte-Ereignis-DEKLARATION (B6-Regel + M3/M4-Praezedenz)

**WIRKKETTE (Pflicht-Wortlaut nach LEDGER:3632):** COMDARE_SYSTEM_CELL_VALUES (perm_compile, je
Zelle) -> vervollstaendigte System-Zeile im Tier-POD -> anatomy_fingerprint_hex Glied [2] ->
**SHA512 aller mit Define gebauten NEUBAUTEN verschiebt sich** -> Lager-/Skip-Identitaet
(Owner-E3). Deklariert in der C4-COMMIT-MESSAGE (M3-Muster M3DOSS:169) UND im Ledger (C5).
**ZWEITE WIRKLINIE (W10-M2, Review-B2 inkl. REV2-Rest):** kCebContractCodegenMinor 1 -> 2
(decl:327) -> Einzel-Pfad: '+ceb=7.1' -> '+ceb=7.2' im bestehenden Glied
(system_version_suffix.hpp:39); Perm-Pfad: das Glied erscheint ERSTMALS via C4-Verdrahtung
(perm_parts.ceb in beiden Perm-Schleifen + Store-Key-Dedupe, Sektion 1/2) -> jede
prae-W10-perm.dll.version mismatcht in
dll_is_current (build_orchestrator.hpp:251-276) -> **stale gn_out-Bestaende werden MECHANISCH neu
gebaut statt still geskippt** + cache_key_prefix zeigt auf einen NEUEN Store-Bucket (deklarierte
WIRKUNG decl:319-322; M4-Praezedenz LEDGER:3760 woertlich "deklarierte EINMALIGE
Bucket-Invalidierung").

**WAS SICH AENDERT / WAS NICHT (Abgrenzung, beabsichtigt -- "BYTE-FOLGE, nicht Nebeneffekt",
M2-Muster anatomy_version_stamp.hpp:131-133):**
- AENDERT SICH: Tier-Binary-Bytes (kS/kFP/kSE), .fingerprint-Sidecar, Lager-Keys aller Neubauten;
  ZUSAETZLICH (W10-M2): jede build_version/.version-Sidecar ('+ceb='-Glied -- Einzel-Pfad 7.1 -> 7.2,
  Perm-Pfad erstmals via C4-Verdrahtung) und der
  Store-Key-Praefix -- die deklarierte einmalige Invalidierung des stalen Lokal-/Store-Bestands.
- AENDERT SICH NICHT: die emittierte Modul-QUELLE (Emitter bleibt system-blind, byte-identisch --
  golden-CRC/Round-Trip-Wache unberuehrt), system_stamp_line() am CEB-Laufzeit-Ist, der
  CEB-Selbst-Fingerprint kCebFingerprint, die bestehenden Test-Pins (test_m_w12-Golden,
  B3-Frozen-Vektor kFrozenFingerprintV1 0fe275bd...cc9fe36, Layout-/K-4-Pins) mit GENAU EINER
  deklarierten W10-M2-Ausnahme: der R5D_CebContract-Literal-Pin (test_v41_anatomy_module_abi.cpp,
  decl:323-326) wandert mit dem Minor 1 -> 2 (exakt der M4-Praezedenz-Pin), kSystemAxisCodeVersions
  (Bump-Verbot respektiert), .algos-/.variant-Sidecars (byte-unberuehrt),
  POD-Layout v6/sizeof 120, das Preimage-FORMAT (fingerprint_format bleibt 2 -- die Glied-ZAHL und
  -ORDNUNG sind unveraendert; es aendert sich nur der INHALT von Glied [2] fuer definierte Baue).
- KEINE Neuanker-Grosswelle noetig (Unterschied zu M3): weil der Identitaets-Pfad ohne Define
  strikt identisch bleibt, frieren nur die NEUEN W10-Proben ein; einzige Bestands-Pin-Bewegung
  ist der oben deklarierte EINE R5D_CebContract-Tausch (W10-M2).

**BESTANDS-AUSSAGE (belegt):** "vor Voll-Bau-4 kein schuetzenswerter Bestand" -- LEDGER:3755
(M3-Verbuchung, woertlich; M2-Original woertlich LEDGER:3648) + anatomy_version_stamp.hpp:133
("vorher existiert kein schuetzenswerter Bestand") + OWNERDOC:68. LAGER-FOLGE (R15, M3DOSS:212):
TP1-Probe-Bestaende nach W10 als ARBEITS-IST neu inventarisieren; FINAL erst nach E-24 (der LETZTE
Shift vor der A2-Eichung). Die R15-Inventur deckt dabei NUR das Bestandslog (PresenceFn) -- das
LOKALE dll_is_current-Gate deckt W10-M2 (Sektion 1/2/4).
Analog M4-Muster (LEDGER:3760): einmalige, DEKLARIERTE Invalidierung, kein Schutzverlust.

## 4. Skip-Wirkung (womit endet "nur gleiche OS-Familie")

**IST (RB, verifiziert):** Die Uebergangsregel ist NIRGENDS im ce-Code enforced -- sie lebt
ausschliesslich deklarativ im super-BAUPLAN (20260802:8) + FAHRPLAN:14; implizite Teil-Deckung nur
ueber Datei-Plattform-Suffix der Loader und die linux-only-Flotte. Die heutige Skip-Naht ist
zweistufig: Lager-PresenceFn (Fingerprint+Zelle, lager_presence.hpp:8/:22-29) + dll_is_current
(Dreifach-Sidecar-String-Gleichheit, build_orchestrator.hpp:244-276). Das A2-SHA512-only-Gate
EXISTIERT NOCH NICHT als Code.

**ENDE DER UEBERGANGSREGEL = W10-C4-LANDUNG:** Ab C4 traegt jeder Neubau OS-Familie + ISA (+simd)
im Fingerprint -- linux-/macos-/riscv-Baue haben BEWEISBAR verschiedene SHA512 (C4-Orakel iii).
FUER DEN STALEN LOKAL-/CI-BESTAND gilt zusaetzlich W10-M2 (Review-B2): prae-W10-Binaries in
gn_out passieren dll_is_current NICHT mehr (Marker-Mismatch: Einzel-Pfad '+ceb=7.1' vs '+ceb=7.2',
Perm-Pfad 'kein +ceb' vs '+ceb=7.2' nach C4-Verdrahtung) -- "beendet
Skip-nur-gleiche-OS-Familie" gilt damit auch am lokalen Gate, nicht nur am Bestandslog (die
R15-Inventur deckt nur die PresenceFn-Seite). Damit ist die Regel fuer Neubauten GEGENSTANDSLOS
und der Alt-Bestand mechanisch invalidiert; ihr formales Ende wird in C5 im Ledger
deklariert (kein Code-Rueckbau noetig, weil nie Code war). Der K1-Cross-Check (Familie aus
.version-Sidecar, A14REV:14) bleibt als ZWEITE Verteidigungslinie bestehen, bis das A2-Gate
geeicht ist -- er kostet nichts und faengt Define-Verkabelungsfehler.

**A2-EICHUNG BLEIBT NACH E-24 (bindend, unveraendert):** EINMALIG ZULETZT nach W10+E-24
(FAHRPLAN:18; LEDGER:3675/:3756/:3770; R15/M3DOSS:212 gegen Doppel-Eichung). L14-Deklarationssatz
gilt: Eichung MIT LEEREM Overlay-Glied (Glied [5] traegt nur Separator+Format-Disziplin) --
deklarierte, nicht stille Luecke (FAHRPLAN:58). W10 aendert daran NICHTS und zieht KEINE
Eich-Handlung vor.

## 5. TABU-/ENFORCE-/K-4-Wachen-Checkliste + Doppellauf-Kadenz (je Commit)

TABU (nur lesen, Diff==0 belegen): golden_fullpilot_320*, permutation_axes.xml,
m3v2_study.profile.xml, system_axis_registry.xml (+ Registry-Roundtrips 7/7 byte-identisch,
EXCLUDE_FROM_ALL-Kanon inkl. comdare_system_axis_registry_gen, LEDGER:3665), CRC-Anker.

WACHEN-PFLICHTEN:
1. ENFORCE=1 SCHARF: keine neuen flaglosen Versions-Literale; W10 fuehrt KEINE neue Version ein
   (Zellwert-Token sind keine Versionen -- CT-Negativ-Probe in C1 beweist, dass der Versionsteil
   byte-unberuehrt bleibt). Falls doch ein Versions-Traeger entsteht: v1.0.0c + Naht-Listen-Eintrag.
2. K-4 `== 6`-Gleichheits-Wache (decl:214-223) + Layout==6 + sizeof==120: UNANGETASTET; Orakel =
   Pins gruen ohne Edit.
3. B6-Doppel-Absicht: kSystemAxisCodeVersions bleibt dreimal v1.0.0c; die drei static_asserts
   (system_axis_code_versions.hpp:81-96) bleiben UNVERAENDERT im Diff (A14-Bump-Verbot: ein Bump
   liesse das Skip-Gate am Bestand vorbeilaufen, A14REV:86/:29).
4. Stempel-KERN (Owner 02.08.): KEINE merge-Zeile (kein Wieder-Einbau); Meta-Meta bleibt am
   Realm-Zeilen-ENDE (Vervollstaendiger fuegt IN Entries ein, CT-Probe: Anhang-Position
   unveraendert); 'e'-Suffix-Semantik unberuehrt; Flag-Grammatik vX.Y.Z+HW-Flag unberuehrt.
5. A-15-Verbots-Wache (C1f): RT-Unter-Achsen-Schluessel brechen compile-hart; bestehende Guards
   test_a14_os_sub_axes_guard.cpp:16/:107, test_os_u3_probe.cpp:223, test_od10_numa_page_probe.cpp:523
   bleiben gruen (erhobene RT-Werte weiterhin NIE in der Zeile -- Familie != Instanz).
6. Grammatik-Haertung bleibt scharf: vervollstaendigte Zeile besteht stamp_line_is_parsable
   (F1-F6-Faelle; CT-Probe in C1); Zeichenvorrat unveraendert (kein neues Zeichen -- '.' ist
   Bestand).
7. Mapping-Reinheit (§66-N3): CT->CT (Define->consteval) und RT->RT (Zell-Variable->Laufzeit-
   Zwilling); KEINE runtime->compile-time-Bruecke ausserhalb der Pre-Build-Define-Naht (exakt die
   sanktionierte COMDARE_GN_ALGO_SIG-Klasse); kein std::variant im Tier-Pfad.
8. Dritter Ableitungsweg: ceb_version_stamp.hpp bleibt symmetrisch (A5CebVersionStamp-Drift-Guard
   gruen); Entscheid "CEB-Selbst-Stempel zellwertfrei" als Kommentar-Wache deklariert (C3).

DOPPELLAUF-KADENZ (je Commit, 2c-INFRA-LEHRE LEDGER:3637 gegen falsches Gruen):
frisches Build-Dir mit ZWEI-PHASEN-Configure (configure -> comdare_limits_generated_source_catalog
-> ninja all -> configure -> ninja all -> 3 EXCLUDE_FROM_ALL-Ziele) -> ctest 2x LITERAL
`100% tests passed, 0 tests failed out of <N>` (Erwartung: 332 -> 333 nach C1, dann stabil;
Namens-Diff je Commit begruendet) -> cf22 dry-run leer -> ASCII-Selbstcheck aus dem DIFF == 0
(nie handgepflegt) -> gitleaks no leaks -> TABU-Diff 0 -> git status --porcelain leer (Freeze
nach Paketmeldung, diff-stat literal). §61-Dual-Weg: Debug-parallel lokal; Review-Kadenz nach
Q-M3-GATE-Praezedenz: Fable-Adversarial-Lens + Truth-Check (Codex-Zweitlens sobald funktionierende
Umgebung -- Z-02/Z-03-Klasse gilt fuer stempel-nahe W10-Commits analog).

## 6. Zeitschaetzung (Frist: Mo 04.08., VOR E-24)

Umfang ist DEUTLICH kleiner als M3 (kein Bestands-Pin-Neuanker ausser dem EINEN deklarierten
R5D_CebContract-Tausch aus W10-M2, 1 neuer Header, 2 Naht-Edits + Minor-Bump, 1 neue TU, Doku):
**W10a (C1-C3) ~3-4h Bau+Proben; W10b (C4 inkl. W10-M2-Bump + realem Probe-Bau) ~2-2.5h;
C5 ~0.5h; Reviews (Adversarial + Truth-Check) + Landung/CI ~1.5-2h => GESAMT ~6.5-9.5h, ein
Arbeitstag Mo 04.08.** Kritischer-Pfad-Puffer: W10 blockiert E-24 (FAHRPLAN:45); die E-24-
Fenster-Bauplan-Session (wf_62f843be, L4) laeuft PARALLEL weiter -- keine Stempel-Kollision, weil
W10 das einzige aktive Stempel-Fenster ist (OWNERDOC:110-Auflage eingehalten: nicht parallel zu
anderer Stempel-Arbeit; Lager-Rest-Welle wf_eb0cf566 beruehrt lager_pfad_grammatik/LB-Schnitt,
NICHT die Stempel-Header -- Datei-Disjunktheit vor Start per diff-Liste belegen).

**FIXTURE-PIN-AUFLAGE AN wf_eb0cf566 (bindend, Review-B4):** Baum-Writer-/LB-Tests der
Lager-Rest-Welle duerfen KEINE prae-W10-Stempel-Zeilen- oder Fingerprint-Literale einfrieren --
Fixtures dort entweder inhalts-transparent ueber derive_key_from_lines/ZellKoordinaten bauen
oder erst NACH W10-C4 in der End-Form pinnen ("Gruene Tests zementieren alte Ordnung", 3x real
in O-8; exakt die Fixture-Ende-Form-Lehre des M3-Neuankers test_m_w12_stamp_bausteine.cpp:550-555).

**RISIKEN (Review-B5, deklariert):** (1) WANDZEIT: 5 Commits x Frischbau-Doppellauf-Kadenz
(Zwei-Phasen-Configure + 2x ninja all + 2x ctest je Commit, Abschnitt 5) ist wandzeit-schwer --
seriell einplanen; laeuft der Tag ueber, traegt das FAHRPLAN-Fenster Phase 2 bis Di 05.08. als
deklarierter Puffer (kein stiller Verzug). (2) BASIS-ABHAENGIGKEIT: die Lager-Rest-Landung
(wf_eb0cf566) ist noch in der Design-Phase; W10 startet notfalls direkt auf 0b3a0b39
(Datei-Disjunktheit belegt) und zieht eine zwischenzeitliche Lager-Rest-Landung VOR dem
Lande-Review per 'git merge' in wt-w10 nach (Kanon: nie rebase, immer merge). (3) TESTZAHL:
Erwartung 332 -> 333 (M4=331 + OD-10-RT=+1 = 332 heute; N ist lebendes ctest-Gate, vor C1 live
erheben, nie hartcodieren).

## 7. Offene Entscheide (NUR echtes NICHT-GEFUNDEN; E-21-VERBOSE, Defaults laufen)

**E-1 -- FORMAT der Zellwert-Ergaenzung.** Kontext: Kein Dokument legt fest, WIE Zellwerte in der
A13-M2-Grammatik (LEDGER:3641) reisen (RA-Luecke, ueberall gesucht). Optionen: (a) hierarchische
Algorithmus-Namens-Erweiterung `code.<wert>` (Q2-Namensraum, parser-legal HEUTE, Achsen-Namen
unangetastet); (b) eigenes Geschwister-Segment je Zellwert (braucht Pseudo-Version -- Grammatik-
Verbiegung); (c) Achsen-Namens-Erweiterung `operating_system.linux=...` (Q2-legal, bricht aber
alle Achsen-Namens-Vergleicher). **Empfehlung + DEFAULT: (a)** -- einzige Form ohne Grammatik-/
Parser-/Wachen-Aenderung; CT-Beweis liegt mit Q2 vor.

**E-2 -- Zellwert-MENGE: external_utils-Haupt-Segment und simd-Meta-Meta.** Kontext: Belegt sind
NUR OS-Familie (B1, A14REV:6) und ISA (LEDGER:3658); ob external_utils/simd Zellwerte erhalten,
sagt keine Quelle (RA-Luecke). Optionen: (a) simd-Glied erhaelt die Zell-Id, external_utils-Haupt-
Segment bleibt wertfrei (Hub ohne eigene Zelle); (b) nur OS+ISA, simd bleibt allein in
Zelle/.variant; (c) auch external_utils-Kunstwert. **Empfehlung + DEFAULT: (a)** -- die simd-Zelle
ist an der Naht ohnehin die Schleifen-Variable; damit deckt der SHA512 alle drei F7-relevanten
Stempel-Dimensionen selbst, und die Fingerprint-Diskriminierung haengt nicht mehr an der
Zell-Koordinate (konsistent mit W10-M1).

**E-3 -- riscv64-Achsen-ERWEITERUNG (kAllTargetIsaIds + riscv64) in W10?** Kontext: LEDGER:3658
haelt die Naht ausdruecklich "festgehalten, NICHT entschieden"; beruehrt Owner-E4-Plattformen
(OWNERDOC:13). Optionen: (a) NICHT in W10 -- nur Verdrahtung bestehender Zellen; riscv64-Auflage
(opt-in-CI, kein Lager-Rueckschrieb) bleibt, mechanisch gedeckt durch die na-fail-closed-Wache;
(b) Erweiterung mitfahren (zusaetzliches Achsen-Werte-Ereignis im selben Fenster). **Empfehlung +
DEFAULT: (a)** -- W10 klein und einwertig halten (Ein-Fenster-Disziplin); (b) waere ein eigenes,
deklarierbares Folge-Ereignis nach E-24.

**E-4 -- target_isa-Komplex-GLIEDER (RAM-Frequenz/CAS/CPU-Fabrikation) im Zellwert-Begriff?**
Kontext: §70.6 bindet die Glieder an die BUILD-Version/build_version-Suffix-Welt; ob sie zum
W10-Zellwert gehoeren, sagt keine Quelle (RA-Luecke); prod1-RAM-Glieder sind zudem undeklariert
(=0/Unbekannt -- n/a-Anti-Muster, A10 HW P4-P6 laeuft Phase 3). Optionen: (a) NICHT W10 --
Familien-Ebene only (ISA-Id), Glieder bleiben build_version-/A10-Thema; (b) Glieder als weitere
Namens-Glieder einziehen. **Empfehlung + DEFAULT: (a)** -- Instanz-nahe Glieder im Stempel
widerspraechen der A-15-Grenz-Logik und wuerden vor A10-P4-P6 zwangslaeufig `na` stempeln.

---
*Erhebungs-Basis: RA (Doku-Strang) + RB (Code-Ist 0b3a0b39) der Planungssession wf_600bc26d;*
*alle datei:zeile-Anker dieses Dossiers am 03.08. spaetnachts live nachgelesen (read-only) und*
*in der Review-Nachbesserung (B1-B5) ERNEUT gegen Code + lebenden Ledger verifiziert.*
*Naechster Schritt nach Owner-/Manager-Sicht: W10-Fenster oeffnen (wt-w10), C1 starten.*
