SYNTHESE-BERICHT V4 — KONSOLIDIERUNG STRAENGE A/B/C (26.07.2026 abends)

Methode: reine Synthese der drei vorgelegten Erhebungs-Meldungen. Alle datei:zeile-Anker sind aus den Straengen uebernommen (dort live verifiziert an ce a3644cb8 / super ec12ad57); nichts neu erhoben, nichts erfunden. Konflikt-Regel angewandt: neueste Owner-Aussage gewinnt.

================================================================
(1) GATE-REGISTER FINAL
================================================================

O-1r (Eltern-Achse der compiler-GRUPPE) — ENTSCHIEDEN, Konfidenz HOCH.
Inhalt: compiler+opt_level+atomic128 = Unter-Achsen-GRUPPE an der EINEN aeusseren System-Komplex-Haupt-Achse (Command-Pattern-Wrapper der Rekombination der DREI Haupt-Achsen), NICHT an target_isa allein und NICHT eigene Haupt-Achse. Belege: verlauf-31.txt:1249 + :1281 (Owner verbatim); Gegenlese OD-2 jsonl:82844 (OD:53-58, LED:3521). Konflikt-Aufloesung Glieder-Nennung: verlauf-31 nennt "target_isa x extension_hardware x Meta-Metas (ohne load_framework)", OD-2 (neuer, 26.07. abends) nennt "target_isa x operating_system x ..."; mit KONS:89 (O-1=DREI entschieden) ist die Komplex-Achse die Rekombination ALLER DREI Haupt-Achsen {target_isa, operating_system, external_utils}; extension_hardware faehrt als System-Meta-Meta (C-1-Menge) mit, nicht als eigenes Haupt-Glied. Korrektur am Bauplan: V2:240-241 ("im KERN nicht benannt") ist zu eng — verlauf-31:1249 benennt die Eltern literal. Konsequenz: SubAxisGroup<compiler,opt_level,atomic128> haengt am AEUSSEREN Wrapper (Paket IV.2.7); die target_isa-eigenen Unter-Achsen bleiben scheduling/numa_node/page (LED:3521).

O-2 (XSD-Revision + Parser fuer target_isa-Unter-Achsen) — ENTSCHIEDEN (Substanz): BAUEN, Konfidenz HOCH.
Inhalt: XSD-Revision (experiment_schema.xsd:328-347) + Parser-Erweiterung (xml_config_parser.cpp:112-117) sind zu bauen; OD-2 (jsonl:82844) hebt die A4-Festlegung vom 20.07. ("target_isa hat KEINE Unter-Achse") auf; ALLES-in-XML-Doktrin (verlauf-18.txt:421) + Delegations-Semantik NUMA/page (verlauf-23.txt:1769) + OD-10-Freigabe "NUMA/page-Umbau VOR Voll-Bau-4" (LED:3525). Ehrlichkeits-Vermerk: ein literaler Satz "revidiere die XSD" existiert nicht, die Substanz ist mehrfach owner-fixiert. Konsequenz: BLOCKER-4 (V2:160-162) AUFGEHOBEN; Paket IV.2.2 baubar.

O-3 (CSV-Sichtbarkeit gesperrter Perms) — ZWEITEILIG: Sichtbarkeits-Pflicht ENTSCHIEDEN (HOCH); enger Punkt Zusatz-D1-CSV-Marker WIRKLICH OFFEN.
Entschieden: failed statt null + Log (verlauf-16.txt:723) und Bestands-Zaehlung complete-heuristik.log (verlauf-queued-ergaenzung-06.txt:102) decken die bindende Inventar-Zeile B (V2:47). Offen: ob die D1-ZULASSUNGS-Sperre (Perm auf Maschine nicht baubar) einen ZUSAETZLICHEN CSV-Datensatz erhaelt — kein Owner-Wortlaut in beide Richtungen (failed-Doktrin betrifft wortlautlich D2-Scheitern). Auflage fuer beide Formen: eigener D1-Token, NIE sample_status_token (axis_error.hpp:55/:79). -> RF-2.

O-4 (Maschinen-Identifikation) — ENTSCHIEDEN, Konfidenz HOCH.
Inhalt: Laufzeit-Hostname identifiziert die MASCHINE; CPU-Gleichheit/Fabrikation per externem Tool (Owner nimmt externe Abhaengigkeit in Kauf, verlauf-27.txt:523): PRIMAER libcpuid/cpuid_tool, Fallback google/cpu_features (--json), RAM-Seite decode-dimms + dmidecode -t memory; normalisierte Kern-Kennung (vendor, brand_string, family, model, stepping). Owner-ratifiziert via Pauschal-GO 21.07. (LED:3321/3327). Korrektur am Bauplan: "COMDARE_MACHINE_ID-Env + cpuid-Fallback" (V2:132) ist AGENT-ERFINDUNG und wird GESTRICHEN. Konsequenz: Paket IV.2.6; liefert die Erkennungs-Werkzeuge fuer die target_isa-Komplex-Glieder (RAM-Frequenz/CAS/CPU-Fabrikation), beantwortet aber NICHT deren Repraesentation (-> RF-6).

O-5 (hugetlbfs-Fehlerklasse) — ZWEITEILIG: Fehlerklassen-Pflicht ENTSCHIEDEN (HOCH); enger Punkt compile-seitiger Enum-Bump WIRKLICH OFFEN.
Entschieden: deklarierte Fehlerklasse + Behandlung je Achse/Unter-Achse/Algorithmus ist Pflicht (verlauf-18.txt:825). Richtung (doktrin-vereinbar, nicht owner-literal): runtime-only SourceUnavailable/Failed + failed-CSV+Log genuegt, solange kein CT-Konsument existiert (page = dynamische RT-Unter-Achse verlauf-23:1769; RT-Durchreiche LED:2316; MAP_HUGETLB nur Kommentar V2:63). Korrektur: "Owner bestaetigt" in V2:246 ist eine AUSSTEHENDE Bestaetigung, kein Beleg. Additiver D1-Enum-Bump (BetriebssystemFeatureFehlt, Count 4->5) nirgends entschieden. -> RF-3.

O-6 (CI-Fallback-Matrizen) — ZWEITEILIG: Autoritaets-Frage ENTSCHIEDEN (MITTEL-HOCH); enger Punkt Matrizen-Zeilen mitziehen WIRKLICH OFFEN, Richtung: NICHT mitziehen.
Entschieden: EINZIGE Steuerung = XML -> Planer -> CEB -> Tier-Binaries (planer:delegate); die statische Matrix ist owner-seitig zum PILOT degradiert (verlauf-22.txt:1264 = LED:2365; verlauf-27.txt:591/:333), im Ist DEPRECATED + Default-AUS (.gitlab-ci.yml:1040-1082). Kein Owner-Satz "Matrizen mitziehen"; ein Mitzug wuerde den Pilot pflegen und widersprae­che der Ein-Weg-Doktrin. Konflikt-Aufloesung: K-09/Board-#4 "CI-Matrizen-Nachzug: TODO" (KONS:50/:90) ist AGENT-Konsolidierung ohne Owner-Beleg -> wird auf "KEIN Nachzug (Richtung); Owner-Bestaetigung Loeschen-vs-Stehenlassen ausstehend" umgestellt. -> RF-4.

O-9 (V36.B-Codegen-CMake Gate-Hook) — WIRKLICH OFFEN (kein Owner-Wortlaut trotz Voll-Grep ueber Ledger, alle 20260726-Docs, verlauf-01..32+queued, jsonl); doktrin-abgeleitete Richtung: DAUERHAFT OUT-OF-SCOPE, Ableitungs-Konfidenz HOCH.
Ableitung: (a) GO-2 = Byte-Identitaets-Vertrag des Codegen-Kanals (LED:458/540) — ein Hook braeche ihn; (b) Ein-Gate-Doktrin: Zulaessigkeits-Filter GENAU in der Fassade, NICHT im Emitter (profile_run_entry.hpp:773; simd_build_gate.hpp:149-152); (c) owner-ratifizierte C-3a-Auflagen (LED:3535) nennen keinen Codegen-Hook. -> RF-5 (formale Bestaetigung).

Zusammenfassung: voll owner-belegt ENTSCHIEDEN: O-1r, O-2, O-4. Doktrin-Kern entschieden + enger Restpunkt offen: O-3, O-5, O-6. Wirklich offen (nur Ableitung): O-9.

================================================================
(2) OD-9-VERDIKT
================================================================

VERDIKT: JA — "Bauplan V3 deckt den Vorschlag vollstaendig ab" ist auf Mengen-Ebene BESTAETIGT; auf Detail-Ebene bleiben DREI Restpunkte, die als Auflagen ins O-8-Fenster gehoben werden.

Begriffs-Trennung (Kern): Alt-"V3" (Mittag, Q-0) = UMFANGS-VARIANTE "nur ORG-18+Suffix (B+F)" (ALTPLAN a67e501b:205-206) und TEILMENGE von V2; "Bauplan V3" (Abend, OD-9) = DOKUMENT-VERSION (BAUPLAN:3-4). Namensgleichheit zufaellig, kein inhaltlicher Konflikt. Der Mittag-Wunsch "V3 direkt mit rein" (jsonl:79891) war durch die V2-Annahme mengen-logisch erfuellt (MEM-ACH:26; Gegenprobe chunk-32:115).

Abdeckung: Lane B (B-1..B-15) IM CODE GELANDET (ce 774a5d5f + fcd95a44 + abef03ce; Ist-Belege ABI-7, POD 1344, 169/160-Reader, K17-Raum 131072, Registry 18 Achsen, golden-Neuanker kNewGolden131072Crc64 = 0x56F1B721C72DC10E mit Owner-GO, source_catalog.hpp:182-190). Lane F VOLLSTAENDIG ALS PLAN-PAKET getragen (P8/A5-Fenster, BAUPLAN:79/:100-101/:110/:213-216/:227); Segment-Menge per neueren Owner-Entscheiden superseded und in v3 neu definiert (D2.5/K1/K4). Fenster-Gating (O-8) widerspricht dem Mittag-Wunsch nicht (Menge vs Reihenfolge).

RESTPUNKTE (leben nur im ALTPLAN, der NICHT superseded ist; in v3 nicht restated):
- R1: GN_PREFIX-Haertung .gitlab-ci.yml:877-880 + Fallback :896 hart fehlschlagen (ALTPLAN:176; 0 Treffer "GN_PREFIX" im BAUPLAN).
- R2: NEU-Wachen T-a (Perm-Suffix==Facade-Suffix), T-b (count("+ceb=")==1), T-c (Segment-Ordnungs-Wache, NEU formuliert auf die DREI-Achsen-Ordnung per D2.5/K1/K4) (ALTPLAN:177).
- R3: Traeger-Datei profile_facade/system_version_suffix.hpp als Single-Source anlegen/verdrahten (ALTPLAN:109/:176; v3 nennt nur die Funktion).
DURCHZIEH-BESCHLUSS: R1-R3 als drei Auflage-Zeilen in den Agent-5-Fenster-Auftrag (siehe TEIL IV, IV.2.12).

================================================================
(3) TEIL-IV-ENTWURF (direkt anhaengbar ans Bauplan-Doc)
================================================================
=== TEIL-IV-ENTWURF ANFANG ===

## TEIL IV — V4-DELTA UND GATE-SCHLIESSUNG (26.07.2026 abends, Synthese Straenge A/B/C)

Geltung: TEIL IV praezisiert TEIL I-III; bei Widerspruch gilt TEIL IV. Der STRUKT-R-ALTPLAN (backups/20260726-strukt-r-planung-workflow/ergebnisse/00-bauplan-a67e501b.md) bleibt fuer Lane-F-Detailauflagen gueltig (NICHT superseded); R1-R3 sind hierher gehoben. Anker: Live-Erhebung an ce a3644cb8 (working tree clean) / super ec12ad57. Doku-Kanon: superseded Stellen werden VERMERKT, nie geloescht.

### IV.1 Gate-Register (final)

| Gate | Verdikt | Inhalt / Richtung | Kern-Beleg |
|---|---|---|---|
| O-1r | ENTSCHIEDEN | compiler+opt_level+atomic128 = Unter-Achsen-GRUPPE an der EINEN aeusseren System-Komplex-Haupt-Achse (Rekombination der DREI Haupt-Achsen), nicht an target_isa allein | verlauf-31:1249/:1281; OD-2 jsonl:82844; KONS:89 |
| O-2 | ENTSCHIEDEN: BAUEN | XSD-Revision + Parser fuer target_isa-Unter-Achsen; hebt A4-Festlegung 20.07. auf; BLOCKER-4 aufgehoben | OD-2; verlauf-18:421; verlauf-23:1769; OD-10 LED:3525 |
| O-3 | Doktrin ENTSCHIEDEN / eng OFFEN | failed+Log+complete-heuristik.log Pflicht; Zusatz-D1-CSV-Marker ja/nein offen (falls ja: eigener D1-Token, nie sample_status_token) | verlauf-16:723; verlauf-queued-erg-06:102; axis_error.hpp:55/:79 |
| O-4 | ENTSCHIEDEN | Hostname = Maschine; CPU/RAM-Fakten per Tool-Probe (libcpuid/cpuid_tool, Fallback cpu_features; decode-dimms + dmidecode); COMDARE_MACHINE_ID-Env (V2:132) GESTRICHEN (Agent-Erfindung) | verlauf-27:523; LED:3321/:3327 |
| O-5 | Doktrin ENTSCHIEDEN / eng OFFEN | Fehlerklasse+Behandlung Pflicht; Richtung runtime-only (SourceUnavailable/Failed + failed-CSV+Log); D1-Enum-Bump offen; V2:246 "Owner bestaetigt" = AUSSTEHEND | verlauf-18:825; verlauf-23:1769; LED:2316 |
| O-6 | Autoritaet ENTSCHIEDEN / eng OFFEN | Steuerung NUR planer:delegate; Matrix = Pilot, DEPRECATED+Default-AUS; Richtung: KEIN Matrizen-Nachzug; K-09/Board-#4 (KONS:50/:90) = Agent-Vermerk ohne Owner-Beleg, umgestellt | verlauf-22:1264; verlauf-27:591/:333; .gitlab-ci.yml:1040-1082 |
| O-9 | OFFEN (Richtung: OUT-OF-SCOPE) | Kein Codegen-CMake-Gate-Hook: GO-2-Byte-Vertrag + Ein-Gate-Doktrin + C-3a ohne Hook; formale Owner-Bestaetigung ausstehend | LED:458/:540; profile_run_entry.hpp:773; LED:3535 |

### IV.2 Paket-Texte (ersetzen die benannten TEIL-I/II-Stellen)

IV.2.1 A3' (ersetzt D2.5-Schluss + D3.1 Zeile 1): A3 setzt kSystemAxisOrder {target_isa, operating_system, external_utils}, kCount 5->3. load_framework verlaesst die System-Welt ERSATZLOS: system_axis_registry.xml:114-117 + Generator-Block tools/system_axis_registry_gen/main.cpp:284-296 raus, stdout :334 "5" -> "3". KEINE Abhaengigkeit A3->C-1 (einziger benannter Grund war die Hub-Einhaengung, superseded per §69.1; Gegenprobe: grep hardware_meta_meta = 0 Treffer). NEUE Auflage: im SELBEN Commit measurement_axis_registry_gen (main.cpp:35 include, :172-173 source="system:load_framework") auf "measurement:load_framework" umstellen — die Mess-XML darf nie auf eine geloeschte System-Achse zeigen. Stempel-Arithmetik-KORREKTUR: "Stempel -3/+2" (alt D2.5) ist rechnerisch falsch; korrekt sind GENAU DREI Segmente (-4/+2 bei raus/rein-Zaehlung bzw. -3/+1 bei In-Place-Rename). Drift-Vermerke: Stolperdraht system_axis_order.hpp jetzt :93-94 (BP nannte :91-92); LED-Warnvermerk jetzt :1706 (BP/§69.1 nannten :1698).

IV.2.2 A3'-target_isa-Komplex (K4, O-2 entschieden): A3 beginnt mit dem inneren Komplex-Wrapper TargetIsaComplexAxis (CRTP; feste constexpr-Glieder ram_frequency/cas_latency/cpu_fabrication je benannter Auspraegung; Muster fixed_enum_tuple system_axis_registry.xml:104-112 + MachineSimdSignature machine_simd_signature.hpp:31-48; Owner-Wortlaut "feste Rekombination ... statisch" LED:3521 schliesst RT-Unter-Achsen-Loesung aus). scheduling (heute Top-Level :102-113), numa_node, page haengen als sub_axis am Wrapper (parent="target_isa", D2.6-Namen unveraendert). XSD experiment_schema.xsd:328-347 + Parser xml_config_parser.cpp:112-117 werden GEBAUT (O-2; BLOCKER-4 aufgehoben). Glieder-WERTE und Suffix-Wirkung erst nach RF-6/RF-7.

IV.2.3 C-1': hardware_meta_meta_axis.hpp mit AUSSCHLIESSLICH System-Meta-Metas (SIMD/AVX, externe HW, GPU/FPGA/NPU-Familien); load_framework wird NICHT instanziiert. Byte-neutral, SOFORT baubar (OD-6-GO, TEIL III E3.2). Kommentar-Nachzuege byte-neutral im gleichen oder Folge-Paket: topics/axis.hpp:21-26 (Hub-Halbsatz raus), system_axis_order.hpp:19-21 (N2-Ziel-Text auf "verlaesst die Ordnung Richtung MESS-Realm (Planer-Meta-Meta)"), load_framework_system_axis.hpp:1-8 (Realm-Klassifikation), profile_run_facade.cpp:369-370 ("Last" ist keine System-Achse mehr).

IV.2.4 Mess-Stempel-Migration (K3; GEGATET auf RF-1): load_framework=v1.0.0 migriert aus kSystemAxisCodeVersions:37 als version-Feld in die Mess-Framework-Registry (Muster MeasurementToolingInfo.version, measurement_tooling_registry.hpp:38-39; verhindert Doppel-Quelle zur CRTP-Achse) und wird als Segment der kMeasurementAxisVersionLine (anatomy_version_stamp.hpp:94-124) stempelbar. Belegkette pro Ort: Haupt-Wahl-Prinzip measurement_tooling_registry.hpp:10-11; Planer-Stempel scheidet aus (planner_version.hpp:4-7); CSV-Legende kein Versions-Traeger (R9). Segment-Emission = O-8-Fenster (aendert kCebMeasurementStamp/kCebFingerprint ceb_version_stamp.hpp:90-98 + test_m_w12:343-344); bis RF-1-GO INERT in der Registry. Invarianten-Text anatomy_version_stamp.hpp:89-91 praezisieren: Framework-WAHL = Mess-Haupt (stempelbar), workload-WERTE = RT-Unter (nie gestempelt). Einhaengungs-Ziel der Achse: measurement_axis_registry.xml als TOP-LEVEL-Block (analog measurement_category :7 / collector :26), dim workload :46 mit source="measurement:load_framework".

IV.2.5 telemetry zweigeteilt (K5): Dual-Natur-Register (LED:86/:2319) + Bauplan erhalten die Zeile "telemetry: Mess-RT-Unter im Tooling + System-CT-Haupt (pmc, IObservableTier)". System-Seite bleibt UNVERAENDERT als owner-gedeckter DAUERZUSTAND (registry_to_axis_levels.hpp:123; +tel=silent profile_run_facade.cpp:396-401; Wache test_br1_full22_count.cpp:61-71 bleibt gruen). ABGRENZUNG: die 5er-Menge in build_system_axis_levels ist NICHT kSystemAxisOrder — A3 (5->3) beruehrt diese Funktion nicht. Mess-RT-Unter-dim additiv in measurement_axis_registry.xml/dynamic_dims anlegen (Muster workload :46), golden-neutral; Charakter (Provenienz-dim vs Sweep) nach RF-8.

IV.2.6 Maschinen-Identifikation (O-4): V2:132 wird ERSETZT durch: Laufzeit-Hostname = Maschinen-Identitaet; CPU-Gleichheit/Fabrikation per Tool-Probe libcpuid/cpuid_tool (primaer) / google cpu_features --json (Fallback); RAM-Frequenz/CAS per decode-dimms + dmidecode -t memory; normalisierte Kern-Kennung (vendor, brand_string, family, model, stepping). Keine Env-Var (nirgends owner-gefordert). Diese Tool-Probe ist der Erkennungs-Kanal fuer die IV.2.2-Glieder.

IV.2.7 compiler-Gruppe (O-1r): Die Unter-Achsen-Gruppe compiler+opt_level+atomic128 haengt an der EINEN aeusseren System-Komplex-Haupt-Achse (Command-Pattern-Wrapper der Rekombination target_isa x operating_system x external_utils inkl. Meta-Metas, ohne load_framework), NICHT an target_isa. V2:240-241 wird entsprechend korrigiert. Draft-Skizze CompoundSystemAxis + SubAxisGroup (a51c70a7:190, a67e501b:102) bleibt Muster: SubAxisGroup am AEUSSEREN Wrapper, TargetIsaComplexAxis (IV.2.2) rekursiv eine Ebene tiefer (LED:3521 "rekursiv gewrappt").

IV.2.8 hugetlbfs (O-5-Richtung): D2.7 bleibt runtime-only (SourceUnavailable/Failed + failed-CSV + Log); der compile-seitige D1-Enum-Bump (BetriebssystemFeatureFehlt, Count 4->5) wird NUR nach RF-3-GO gebaut. V2:246 wird von "Owner bestaetigt" auf "Owner-Bestaetigung AUSSTEHEND (RF-3)" korrigiert.

IV.2.9 CI-Autoritaet (O-6): planer:delegate ist die EINZIGE Steuerung; die statischen Matrizen .gitlab-ci.yml:1048/:1053/:1073 werden NICHT mitgezogen (Pilot, DEPRECATED, Default-AUS). K-09/Board-#4 (KONS:50/:90) wird umgestellt auf "KEIN Nachzug (Richtung); Owner-Entscheid Loeschen-vs-Stehenlassen ausstehend (RF-4)".

IV.2.10 Codegen (O-9): V36.B-Codegen-CMake bleibt gate-frei unter dem #25-B-Byte-Vertrag; KEIN Gate-Hook (Ein-Gate-Doktrin profile_run_entry.hpp:773; GO-2 LED:458/540; C-3a-Auflagen LED:3535 ohne Hook). Status: dauerhaft out-of-scope, vorbehaltlich formaler Owner-Bestaetigung (RF-5).

IV.2.11 D1-Sichtbarkeit (O-3): Sichtbarkeits-Pflicht (failed statt null + Log; complete-heuristik.log-Zaehlung) ist bindend umzusetzen (Variante B, V2:47). Ein ZUSAETZLICHER CSV-Datensatz fuer D1-zulassungs-gesperrte Perms wird erst nach RF-2-GO gebaut; falls ja, mit EIGENEM D1-Token (nie sample_status_token, axis_error.hpp:55/:79).

IV.2.12 Lane-F-Auflagen R1-R3 (OD-9-Restpunkte, in den Agent-5/O-8-Fenster-Auftrag):
- R1: GN_PREFIX-Haertung .gitlab-ci.yml:877-880; Fallback :896 hart fehlschlagen (ALTPLAN:176).
- R2: NEU-Wachen T-a (Perm-Suffix==Facade-Suffix), T-b (count("+ceb=")==1), T-c Segment-Ordnungs-Wache — T-c NEU formuliert auf die DREI-Achsen-Ordnung (D2.5/K1/K4) (ALTPLAN:177).
- R3: Traeger-Datei profile_facade/system_version_suffix.hpp als EINZIGE Suffix-Quelle anlegen und verdrahten (ALTPLAN:109/:176).

### IV.3 Abhaengigkeiten / Sperrmengen (Delta zu D3/D4)

ENTFAELLT: A3->C-1 (BP:195-196, :222; D4 :234 "nach C-1" gestrichen). ERLEDIGT: BLOCKER-3 (BP:156-159; Mess-Realm statt Hub). AUFGEHOBEN: BLOCKER-4 (BP:160-162; O-2 entschieden). BLEIBT: O-8-Fenster-Sperre fuer alle Byte-Ereignisse (TEIL III E1).
NEU (atomare Kopplung): A3 <-> tools/measurement_axis_registry_gen/main.cpp (:35/:172-173) im selben Commit.
A3-Sperrmenge (erweitert): system_axis_registry.xml, system_axis_registry_gen/main.cpp, system_axis_code_versions.hpp, system_axis_order.hpp, anatomy_version_stamp.hpp, load_framework_system_axis.hpp, target_isa_system_axis.hpp (Wrapper), measurement_axis_registry.xml + Generator, measurement_framework_registry.hpp, test_experiment_plan_director.cpp:113-114, test_striktheit_axis_dach_guard.cpp:17/:117, test_m_w12-Golden-Strings.
Lane-F-Sperrmenge (erweitert um R1-R3): profile_run_facade.cpp:371-405/:1077-1084, artifact_cache.hpp:245-249, NEU system_version_suffix.hpp, .gitlab-ci.yml:877-896, Suffix-Test-Familien + NEU-Wachen T-a/T-b/T-c.

### IV.4 Bau-Reihenfolge (naechste Schritte)

1. SOFORT (byte-neutral, kein Gate): C-1' (IV.2.3) inkl. Kommentar-Nachzuege; telemetry-Mess-dim additiv (IV.2.5); version-Feld-Vorbereitung measurement_framework_registry.hpp INERT (IV.2.4); Doc-Vermerk-Schicht (IV.6); Bauplan-Korrekturen V2:132/:240-241/:246 + K-09-Umstellung.
2. SOFORT (golden-neutral, O-2 entschieden): XSD-Revision experiment_schema.xsd:328-347 + Parser-Erweiterung xml_config_parser.cpp:112-117 (additiv, noch ohne XML-Konsument).
3. RF-1..RF-3 beim Owner einholen (VOR Fenster-GO, damit die byte-tragenden Entscheide im EINEN Fenster mitfahren — P8-Doktrin).
4. O-8-FENSTER (nach Fenster-GO, das EINE Byte-Fenster): A2 / A3 (IV.2.1 + IV.2.2 Wrapper + atomarer Registry-Umzug + C-3c-Patch) / A8.2-3 / Lane F inkl. R1-R3 (IV.2.12) / Golden-String-Neuanker (test_m_w12, test_g1/s1 u.a. per D2.10-Checkliste) / Mess-Stempel-Segment (IV.2.4, nur mit RF-1-GO).
5. NACH FENSTER, VOR VOLL-BAU-4: NUMA/page-Umbau als RT-Unter-Achsen am Wrapper (OD-10-Freigabe LED:3525).
6. Voll-Bau-4 + golden-Regen; Pipeline hart gruen.

### IV.5 Restfragen an den Owner + ausstehende GOs

RF-1 (Stempel-Traeger-GO, F3): Ort fuer das load_framework-Versions-Segment = kMeasurementAxisVersionLine (Belegkette IV.2.4)? Inkl. Segment-Reihenfolge relativ zu measurement_tooling (byte-tragend). Zusatz: eigener AxisKind-Diskriminator measurement_meta_meta (additiv) oder Umbenennung von system_meta_meta? — Unaufloesbar, weil D2.5:199 einen BENANNTEN Owner-Punkt verlangt ("nicht raten").
RF-2 (O-3 eng): Zusaetzlicher CSV-Datensatz fuer D1-zulassungs-gesperrte Perms ja/nein? — Unaufloesbar: failed-Doktrin (verlauf-16:723) betrifft wortlautlich D2-Scheitern; fuer D1 existiert kein Owner-Wortlaut in beide Richtungen.
RF-3 (O-5 eng): Compile-seitiger D1-Enum-Bump BetriebssystemFeatureFehlt (Count 4->5) ja/nein, oder runtime-only endgueltig? — Unaufloesbar: nirgends literal entschieden; beide Formen doktrin-vereinbar.
RF-4 (O-6 eng): Deprecated-Matrizen :1048/:1053/:1073 LOESCHEN oder deprecated stehen lassen? (Mitziehen ist per Doktrin ausgeschlossen.) — Unaufloesbar: kein Owner-Satz zum Verbleib des Pilots.
RF-5 (O-9): Bestaetigung "Codegen-CMake dauerhaft out-of-scope, kein Gate-Hook"? — Unaufloesbar: kein Owner-Wortlaut trotz Voll-Grep; nur Ableitung (IV.2.10).
RF-6 (F1, durch O-4 verengt): target_isa-Glieder-WERTE (RAM-Frequenz/CAS/CPU-Fabrikation): je MASCHINE deklariert (machine_signatures-Muster, per O-4-Tool-Probe verifiziert) oder freie benannte Auspraegungs-Familie? Einheiten/Normalisierung? Wirkung auf build_version-Suffix/Sidecar oder NUR Stempel-Identitaet? — Unaufloesbar: keine Quelle nennt Werte, Einheiten oder Suffix-Wirkung; O-4 fixiert nur die Erkennungs-Tools.
RF-7 (F2): Stempel-Klammerung der Komplex-Achsen: EINE Zeile (target_isa=code@X.Y.Z) oder je festes Glied eigene Klammer (LED:3412 "je Achse ihre eigene Klammer" vs O-1r "verhalten sich wie EINE")? Gleiches fuer die aeussere System-Komplex-Achse. — Unaufloesbar: beide Owner-Aussagen koexistieren ohne Aufloesungs-Satz.
RF-8 (F4): telemetry-Mess-Seite: reine Provenienz-/CSV-dim (beobachtet, nicht permutiert) oder echte Sweep-Unter-Achse (Planer permutiert Active/Silent)? — Unaufloesbar: LED:3523 klassifiziert die Dual-Natur, nicht den Sweep-Charakter.
AUSSTEHENDES GO: O-8-Fenster-GO (TEIL III E1) — Fenster-Inhalt jetzt inkl. R1-R3 und (nach RF-1) Mess-Stempel-Segment.

### IV.6 Doc-Vermerk-Schicht (nur Vermerke, nie Loeschung)

Hub-Halbsatz superseded vermerken an: LED:84, :91+:93, :1704+:1706 (Drift +8 zu "1698"), :2782, :2791 (GLOBAL-KLAUSEL LED:3519); ANKER:19-20 (A-04/A-05), :61/:76/:78/:83/:88/:90 (Umzugs-Paket -> Mess-Realm-Ziel); BP:6-7/:38/:129/:156-159/:189-191. LED:3509 (§68a): Vermerk load_framework-Verortung in der Mess-Tooling-Gruppe VOR target_isa. telemetry-Zeile ergaenzen: LED:86 + :2319; Q-13-Doc-Stellen (DOSSIER:262, HANDOVER-6:42-43, MEM-ACH:32) Praezisierungs-Vermerk per LED:3523.

=== TEIL-IV-ENTWURF ENDE ===

================================================================
(4) RESTFRAGEN AN DEN OWNER (Kurzliste; Volltext in TEIL IV, IV.5)
================================================================
- RF-1: Stempel-Ort load_framework-Segment = kMeasurementAxisVersionLine + Segment-Reihenfolge + AxisKind-Diskriminator (D2.5:199 verlangt benannten Owner-Punkt).
- RF-2: Zusatz-D1-CSV-Datensatz fuer zulassungs-gesperrte Perms ja/nein (kein Owner-Wortlaut fuer D1; failed-Doktrin deckt nur D2).
- RF-3: D1-Enum-Bump compile-seitig ja/nein vs runtime-only endgueltig (nirgends literal entschieden).
- RF-4: Deprecated-CI-Matrizen loeschen oder stehen lassen (Mitziehen doktrin-ausgeschlossen; Verbleib ungeregelt).
- RF-5: Formale Bestaetigung O-9 out-of-scope (nur Ableitung vorhanden).
- RF-6: target_isa-Glieder-Werte: Herkunft/Repraesentation/Einheiten/Suffix-Wirkung (keine Quelle nennt sie; O-4 fixiert nur Tools).
- RF-7: Klammerung Komplex-Achsen: eine Zeile vs je Glied (LED:3412 vs "wie EINE" unaufgeloest).
- RF-8: telemetry-Mess-dim: Provenienz vs Sweep (Dual-Natur klassifiziert, Sweep-Charakter nicht).
- Ausstehendes GO: O-8-Fenster-GO; RF-1..RF-3 VOR Fenster-GO einholen.

SELBSTCHECK: Reine Synthese der drei vorgelegten Strang-Meldungen — 0 Datei-Schreibvorgaenge, 0 Commits, 0 neue Erhebungen; alle datei:zeile/jsonl-Anker unveraendert aus Straengen A/B/C uebernommen (dort per Selbstcheck live verifiziert), als solche gekennzeichnet, NICHTS erfunden; Konflikt-Aufloesungen explizit benannt (O-1r-Glieder via KONS:89+OD-2, K-09 als Agent-Vermerk, V2:132/:240-241/:246-Korrekturen); Owner-Zitate nur referenziert, nicht veraendert; keine Tokens/Secrets; keine Haken-Marken; ASCII-only bis auf das erlaubte Paragraph-Zeichen; Quellen-Vollstaendigkeit: alle sieben Gates, alle OD-9-Punkte (inkl. R1-R3) und alle K1-K5-Bausteine (T1-T5) sind im Register bzw. TEIL-IV-Entwurf abgebildet.