# 20260726-rueckfragen-selbst-aufloesung-workflow / E-lane-c-blocker (agent af9eea0e)

runId: wf_bb5d71e9-fdb
agentId: af9eea0ec6e4f9f55
label-Zuordnung: E-lane-c-blocker (Prompt-Marker-Deckung 100%)

---

PUNKT E - LANE-C-BLOCKER-ANALYSE (Verdikt: GESPALTEN, nicht "volles GO")

QUELLEN: BAU = docs/sessions/backups/20260726-strukt-r-planung-workflow/ergebnisse/00-bauplan-a67e501b.md
S-LAY = docs/sessions/20260726-SESSION-layer-modell-antworten-QA-QF-stempel-doktrin.md
WA = docs/sessions/20260726-SESSION-wahrheits-anker-voll-abgleich-982-E01-E26.md
CE = Code/external/comdare-cache-engine/

== 0. BEFUND IN EINEM SATZ ==
Der Bauplan stellt Lane C als P0-parallel und "byte-neutral, INERT" aus (BAU:34, BAU:63,
BAU:168) - aber der vom Owner in Lane C hineingelegte RENAME ext_hw->external_utils steht dort
NICHT drin. Lane C laut BAU ist blockerfrei; Lane C laut Owner-Auftrag ist es NICHT.

== 1. DATEI-UEBERLAPP-MATRIX (Rename-Scope 26 Dateien CE-weit, grep-belegt) ==
| Datei (CE-relativ) | ext_hw-Treffer | Besitzer laut BAU | Blocker? |
|---|---|---|---|
| include/cache_engine/abi/system_axis_code_versions.hpp | 2 | **A** (A-II, BAU:104) | JA |
| include/cache_engine/measurement/system_axis_registry.xml:53-55 | 4 | **A** (A-III, BAU:105) | JA |
| tools/system_axis_registry_gen/main.cpp | 8 | **A** (A-III) | JA |
| profile_facade/validate_profile.hpp | 11 | **A** (A-V, BAU:107) | JA |
| libs/common/.../xml_config_parser.hpp | 8 | **A** (A-IV, BAU:106) | JA |
| libs/common/.../xml_config_parser.cpp | 7 | **A** (A-IV) | JA |
| tests: test_striktheit_axis_dach_guard, test_m_w12_stamp_bausteine, test_kf1_thesis_profile_parser, thesis_tiere/test_experiment_parser | je >=1 | **A** (A-VI, BAU:32/108) | JA |
| include/cache_engine/measurement/extension_hardware_system_axis.hpp | 17 | **NIEMAND** - in A-Liste NICHT, in C-Liste NICHT | LUECKE |
| profile_facade/profile_run_facade.cpp, profile_run_entry.hpp, experiment_run_entry.hpp | je >=1 | **G4b-1-SPERR-MENGE** / Lane F (BAU:26,36) | JA (ggue F) |
| profile_facade/planner/experiment_plan_director.hpp | 1 | Lane E (BAU:37) | nachrangig |
| extension_hardware_family_axis.hpp, simd_sub_axis.hpp | 24 / 1 | **C** (BAU:34) | nein |
| Profil-XMLs + thesis_tiere/experiment_golden*.xml, test_genus_organ_binding | je >=1 | Lane B (BAU:44) | **NEIN - B ist gelandet** |

Lane-B-Status live geprueft: `git log --oneline -3` = dc8e1dc7 / fcd95a44 (17->18-Konsumenten)
/ 774a5d5f (ORG-18 persistence_target). Working tree clean (nur `?? Testing/`).
**=> Von Lane B geht KEIN Blocker mehr aus; alle B/C-Beruehrungsdateien sind gemergt.**

== 2. LOGISCHE ABHAENGIGKEITEN ==
L1 Braucht der Hub kSystemAxisOrder? **NEIN als Typ.** Der Komplex-Wrapper
   `CompoundSystemAxis<TargetIsa, ExtHw, MetaMetas...>` (A-I.4, BAU:102) konsumiert den Hub,
   nicht umgekehrt - bottom-up ist C vor A baubar.
L2 Braucht der Hub die OS-Komplex-Achse? **NEIN.** OS ist 4. Glied derselben Klammer
   (S-LAY:29-31), beruehrt den Hub-Typ nicht.
L3 **HARTER BLOCKER - der A<->C-Vertrag ist ungueltig.** BAU:54-55 nennt V1
   (`std::span<MetaMetaDescriptor const> meta_metas()` + `subsumes(A,B)`) als "A<->C Einzige
   Kopplung"; C-3 baut ihn (BAU:163). D3 des Layer-Modells VERBIETET genau diese Signatur:
   Meta-Metas sind volle CT-Haupt-Achsen-TYPEN mit eigenen RT-Unter-Achsen, keine
   Descriptor-Daten (S-LAY:53, S-LAY:32-34 "KONSEQUENZEN FUER STRUKT-R (Lane A/C Neuschnitt)").
   Der Vertrag muss vor JEDEM C-Start neu geschnitten werden - sonst baut C gegen eine
   verworfene API.
L4 **Die Byte-Neutralitaets-Praemisse faellt mit dem Rename.** `system_stamp_line()` rendert
   `kSystemAxisCodeVersions[i].axis` literal (anatomy_version_stamp.hpp:76-79, live gelesen);
   Eintrag [1] ist `{"extension_hardware","v1.0.0"}`. Rename = Stempel-Bytes = byte-relevant
   fuer JEDE Tier-Binary (BAU:120, lazy_adhoc_source_gen.hpp:199-201). Damit ist der Rename
   NICHT die inerte P0-Arbeit, als die BAU:87/:168 Lane C freigibt.
L5 C-4 gibt die A-Abhaengigkeit selbst zu: "Patch an A's Generator main.cpp:298-316" (BAU:164).
L6 Prozess-Auflage: `test_system_axis_registry_roundtrip` erzwingt Byte-Diff==0 gegen die
   generierte XML (BAU:116). C kann die XML nicht regenerieren, weil der Generator A gehoert
   => Rename durch C = roter Bau in A-Gebiet.

== 3. VERDIKT ==
**Lane C ist zu spalten - "volles GO" gilt nur fuer die Typ-Haelfte.**

C-parallel (GO, mit Sperrmengen): C-1 Meta-Meta-Typ-Familie, C-2 Halbordnung/`subsumes`,
C-3 Hub-Mechanik IN `extension_hardware_family_axis.hpp`, C-5 Tests (unregistriert).
  Sperrmenge fuer C: die 6 A-Dateien aus §1 (code_versions, registry.xml, registry_gen/main.cpp,
  validate_profile.hpp, xml_config_parser.{hpp,cpp}) + die 4 A-Tests + die 8 G4b-1-Sperr-Dateien
  + `extension_hardware_system_axis.hpp` (DEPRECATED-Insel, registry.xml:8 "NICHT anfassen").
  Auflagen: alter Name bleibt in dieser Phase stehen (Hub-Mechanik ist namensunabhaengig);
  `active_machine_signature()` bleibt Stub `{}` (BAU:168); ZellKoordinaten nur additiv (C-3).

C-seriell NACH A (KEIN GO jetzt): der Rename ext_hw->external_utils (D-4) und C-4
  Generator-Reflexion. Begruendung: 100% der Rename-Anker liegen in A-Besitz oder in der
  G4b-1-Sperr-Menge, der Rename ist stempel-byte-relevant (L4), und die XML-Roundtrip-Wache
  laesst ihn nur im selben Commit wie die Generator-Aenderung zu (L6). Nach A-II/A-III/A-V/A-VI
  ist es ein einziger mechanischer Durchzug statt eines 3-Wege-Konflikts.

Vorbedingung fuer BEIDE Haelften: V1-Neuschnitt gemaess D3 (L3) - vor dem ersten C-Commit.

== 4. WO DIE QUELLEN NICHT ENTSCHEIDEN (explizit, nicht geraten) ==
(a) **Wem der Rename gehoert, sagen die Quellen nicht eindeutig.** Das Lane-A-Beauftragungs-
    Paket fuehrt ihn als D-4 (Lane-A-Doktrinpunkt, Quelle:
    docs/sessions/backups/20260726-session-plaintext-verlauf/verlauf-queued-ergaenzung-06.txt),
    der Owner-Auftrag legt ihn in Lane C, der Bauplan nennt ihn in KEINER Lane. Dossier:305
    fuehrt zusaetzlich einen "external_utils-Rename-Restweg" in **Band C nach dem Trigger**.
    Drei Zuordnungen, keine juengste-gewinnt-Aufloesung moeglich -> Owner/Manager-Schnitt.
(b) WA:64 (E-12c): D-11 Schreibweise `external_utils` war UNBEANTWORTET; erst F1 (Owner ~16:40,
    memory project_achsen_neuordnung) entscheidet sie final. Das ist geklaert, aber juenger
    als der Bauplan - der Bauplan kennt den Rename deshalb nicht.
(c) `extension_hardware_system_axis.hpp` (17 Treffer) hat keinen Lane-Besitzer. Ob die
    DEPRECATED-Insel mitumbenannt wird oder byte-stabil bleibt, sagt keine Quelle.
(d) WA:129 (W1) haelt fest: neueste Aussage = "scharf VOR Trigger, GATED". Das Gate ist genau
    diese Analyse; sie schliesst mit "nicht blockerfrei" -> die Bedingung "Sonst volles GO"
    ist NICHT erfuellt.

SELBSTCHECK: ASCII-only ausser `§`-freiem Text (0 Nicht-ASCII-Zeichen im Bericht). Read-only:
keine Repo-Datei geaendert (nur ls/sed/grep/git log/git status). Alle datei:zeile aus eigener
Live-Lesung bzw. literalem grep-Output; Lane-B-Landung mit `git log`-Ausgabe belegt; keine Zahl
geraten. Kein Erfolgs-Haken ohne literale Ausgabe.
