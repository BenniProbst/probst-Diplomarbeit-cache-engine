# LAGE-DOSSIER DIPLOMARBEIT CACHE-ENGINE
Synthese aus 4 Architektur-Voll-Lesungen (34 Dokumente), 5 neuesten Sessions je Repo, Ledger (3424 Z.) + Masterplan + Board, sowie 30 Transkript-Chunks (06.07. bis 26.07.2026).
Stichtag: **2026-07-26**. Adressat: Architekt/Manager-Session.

Pfad-Kuerzel:
`SUPER` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`
`CE` = `SUPER/Code/external/comdare-cache-engine`
`LEDGER` = `SUPER/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`
Alle `datei:zeile` in Teil 2 sind relativ zu `CE/libs/cache_engine/` bzw. explizit ausgewiesen.

---

## 0. KOPF: STAND IN DREI SAETZEN

1. Das **Lager-/Stempel-Gate (§66)** ist faktisch komplett (G1, G2-Stempel A1-A7, B1-B7, I1/I1b/I1c, G5, I2, Folge-A, Folge-B, G4a, Fix A); es fehlt **G4b** und der **Final-Smoke-Beleg auf ce `5795fae2`**.
2. Danach faellt das Gate fuer **Voll-Bau-4 (new-golden N=2^17)**, der **noch nie abgeschlossen** wurde; die **320er-Messung** ist der Abgabe-Datensatz.
3. Der kritische Pfad zur Zwischen-Abgabe **Mo 27.07.** ist damit sehr eng; der User hat Verzug ausdruecklich fuer begruendbar erklaert und **Gruendlichkeit vor Termin** gesetzt.

Fristen (bindend, LEDGER §41/§66 + Memory `project_frist_montag_2707_zeitbudget_bau_messen`):
- **Mo 27.07.** ZWISCHEN-Abgabe (nicht End-Abgabe). S8-PDF-Endgate.
- **Di 28.07.** governing Deadline-Anker V6.6/F12(i): CI **und** standalone messfaehig, cmake+C++23 auf EINER Maschine; 320er-Abgabe-Messdatensatz; Hybrid-Binary Abgabe-Pflicht; Anhaenge A/B/E + CRC64.
- **ab 01.08.** new-golden VOLL-MESSUNG (Anschlussarbeit, mehrtaegig).
- **~Sep 2026** prod2 (i9-14900KS) zurueck aus RMA -> P/E-Core-Messungen (#270a).
- Write-Token Projekt 288 laeuft **2026-10-09** ab (Rotation einplanen).

Rollen: Fable = Architekt/Manager (Abnahme literal, Integration, Commits). Opus-4.8-Agenten = Implementierung. prt-art = Pruefling, CE = Werkzeug/Framework, SUPER = Anwender/Definition, thesis = Overleaf-gekoppelt.

---

## 1. BINDENDE USER-DIREKTIVEN (dedupliziert, mit Quelle)

### 1.1 Autoritaets- und Lesereihenfolge

| # | Direktive | Quelle |
|---|---|---|
| A1 | **Der Ledger ist Single-Source und schlaegt bei Widerspruch alle Session-Docs.** Neuere Fakten schlagen aeltere; In-place-Update erlaubt (Historie via git). | LEDGER §0; Direktive 20.07. |
| A2 | **§55 = Single-Source aller offenen Punkte** (loest §48 ab, §48 bleibt Historie). **§54-T1..T7 = bindende Terminologie.** | LEDGER §55, §54 |
| A3 | **Die User-KERN-Beschreibung war SCHON IMMER Gesetz.** Weicht der Plan ab, ist das eine **Regression**, kein Neuentscheid. | Memory `feedback_user_kern_beschreibung_ist_immer_gesetz_abweichung_ist_regression`; §59 |
| A4 | Lesereihenfolge faktisch "neueste Sektion zuerst" (§66 -> §65 -> §64 -> ...). Sessions rueckwaerts (neueste = heute), Plaene nicht. | Memory `feedback_sessions_read_newest_first_both_repos` |
| A5 | **Vor jeder Aufgabe** ultracode-Planungssession ueber Ledger + ALLE Plandocs; **nach jeder Aufgabe** adversariale Konformitaets-Pruefung. | Memory `feedback_vor_und_nach_jeder_aufgabe_ultracode_plus_autonomie_scope`, `feedback_per_paket_ultracode_planung_vor_ausfuehrung`; LEDGER §24.D |
| A6 | **Bei scheinbar offener Entscheidung: erst Ledger + alle Plandocs erschoepfend lesen.** Nur wenn unauffindbar -> Rueckfrage **und pausieren**. | Memory `feedback_open_decision_first_reread_ledger_and_plandocs` |
| A7 | Zu Kontext-Beginn thema-scharf per ultracode alle Direktiven/Learnings/Umgebungsvariablen laden (nicht das ganze Memory - physisch unmoeglich). | Direktive 18.07. |
| A8 | Bei **Infra** immer zuerst ultracode ueber alle Cluster-Sessions; **Schritt 0: Cluster-git von gitlab pullen** (stale Klon hat schon Fehlentscheide erzeugt). | Memory `feedback_infra_always_ultracode_over_sessions_first` |

### 1.2 Prozess

| # | Direktive | Quelle |
|---|---|---|
| P1 | **Nie raten.** Ist live pruefen; stale Doku = Verdacht, nicht Wahrheit. **Kein Erfolgs-Haken ohne literale Tool-Ausgabe.** | Memories `feedback_never_guess_...`, `feedback_goal_hook_thorough_read_in_never_guess`, `feedback_no_success_marks_without_literal_output` |
| P2 | **Keine Quick-Fixes, keine Behelfswege.** Immer der schwerere offizielle Weg (CMake/ctest/CI). Sauberste, nicht einfachste Strategie. | `feedback_no_quick_fixes`, `feedback_immer_schwerer_offizieller_weg_keine_behelfswege`, `feedback_infra_cleanest_not_easiest` |
| P3 | **NUR EIN offizielles XML-getriebenes Programm.** Behelfswege finden, aufraeumen, tilgen. | `feedback_only_one_official_xml_driven_program_no_behelfswege` |
| P4 | **Increments architekturkonform, nicht nur gruen.** "Gruen-um-jeden-Preis" ist Schein-Umsetzung. | `feedback_increments_architekturkonform_nicht_nur_gruen` |
| P5 | **Task-Zuweisung ist KEIN Start-Signal.** Gates strikt respektieren; Gegenvorschlag vor Ausfuehrung. | `feedback_task_assignment_not_start_signal_respect_gates_propose_first` |
| P6 | **Working-Tree-Freeze nach jeder Paketmeldung**; Manager prueft `git diff --stat` literal vor `add`. Nie `git add -A`, immer granular. | `feedback_agent_working_tree_freeze_nach_paketmeldung` |
| P7 | **ASCII-only Kommentare + Selbstcheck-Zeile je Paketmeldung** (`grep -P '[^\x00-\x7F]'`, § erlaubt, kein Gedankenstrich/Box-Drawing). | `feedback_ascii_only_comments_and_selfcheck_line` |
| P8 | **Doku nie loeschen**, nur Banner/deprecaten/additiv annotieren. Gilt fuer `docs/`, nicht fuer redundante Source-Klone. | `feedback_never_delete_documentation` |
| P9 | **Messdaten nie loeschen.** Loeschung nur bei punktuellem je-Fall-GO (so geschehen 21.07. fuer 3 Alt-CSVs; `tier150_measurements.csv` bewusst ausgenommen). Backups additiv, nie `rm`. | `feedback_messdaten_nie_loeschen_abi_darf_brechen`, `feedback_raw_data_backups_additive_never_delete` |
| P10 | **NIE rebase, IMMER merge.** Vor Push fetch+merge; **Diffs ab sofort immer manuell klaeren**, kein `--ff-only`-Blindflug. main bleibt Vorfahr von development. | `feedback_nie_rebase_immer_merge`, `feedback_gitflow_branch_doktrin_...`; Direktive 22.07. |
| P11 | Remote-/Branch-Anlage und -Loeschung **nur je-Repo-GO**. Branches nur loeschen wenn gemerged. | `feedback_remote_deletion_requires_explicit_user_authorization` |
| P12 | **Dual-Remote: origin = gitlab (Fokus), github = flache Out-of-House-Sicherung.** GitHub-Struktur nicht nachziehen. | `feedback_all_projects_dual_remote_github_gitlab`, `feedback_github_flache_out_of_house_sicherung_fokus_gitlab` |
| P13 | **NIE AskUserQuestion** (crasht die Session). Forks als Klartext + ExitPlanMode. | `feedback_never_use_askuserquestion_crashes_session` |
| P14 | **Session-Transkripte enthalten Live-Tokens -> nie committen.** Vault nur Blind-Extraktion in Variablen, nie `cat`/`tail`/printen. | `reference_session_transkripte_enthalten_live_tokens_nie_committen`; Vorfaelle 10.07./20.07./23.07. |
| P15 | **`backups/` enthaelt ausschliesslich Workflow-Rohdaten.** Sessions/Plaene/Audits/Kartierungen in eigene `docs/`-Kategorien; Namensschema `<datum-thema>-<basename>.md`. | `feedback_backups_only_workflow_rawdata_never_sessions_plans`; Voll-Konsolidierung 18.07. |
| P16 | **Ab 20.07.: bestehende Doku nicht mehr anfassen.** Fortschritt nur in NEUEN Session-Docs; Ledger nur bei User-Technik. | `feedback_doku_policy_neue_session_docs_ledger_nur_user_technik` |
| P17 | **Kein Python in der Buildchain.** CMake + sh/bat. | `feedback_no_python_in_buildchain` |
| P18 | **Implementierung an Opus-4.8-Agenten delegieren; Fable = Architekt/Manager.** (Codex abgeloest seit 10.07.) | `feedback_implementierung_an_opus_delegieren_fable_als_architekt`, `feedback_selbst_implementieren_ab_20260710_codex_abgeloest` |
| P19 | **Autonomie-Modus (§63):** Plan autonom durchziehen, auch nachts, bis kein Backlog erkennbar. Stopp **nur** bei nicht-autonom-aufloesbaren Entscheidungen. Durchgeplant -> main, halbfertig -> development. | `feedback_autonomie_modus_plan_autonom_durchziehen`; LEDGER §63 |
| P20 | **Zyklusende: alle Shells und Monitore beenden, nie dangling.** Monitore duerfen nie stumm haengen (Vollblick + Heartbeat). | `feedback_goal_driven_autonomie_shells_monitore_beenden`, `feedback_monitore_duerfen_nie_stumm_haengen_vollblick_heartbeat` |
| P21 | **Waehrend einer Kette entdeckte Pflicht-Restpunkte werden IN der Kette abgeschlossen, nicht geparkt.** Aufschreiben ersetzt Durchziehen nicht. | Direktive 23.07., SUPER `2173ecd` |
| P22 | **Gesamte Pipeline immer hart gruen** (ce+super, prod1+prod2, kein `allow_failure`). Ausnahme: befristete Rot-Periode war per §45 nur bis zur W10-Abnahme zulaessig. | `feedback_gesamte_pipeline_immer_hart_gruen`; LEDGER §45 |
| P23 | Verifikations-Kadenz je Increment (literal): ctest + golden-Roundtrip + CRC64-Anker + clang-format-22.1.8 `--dry-run --Werror`==0 + Mojibake-grep==0 + **super-Sub-Build PFLICHT** + beide Remotes + CI hart gruen. | LEDGER §0-Kadenz; `reference_thesis_build_check_blg_alphadin` |
| P24 | **Bei Infra-Problemen: Handover an den Infra-Agenten ins Cluster-Repo** (dort liest er), committen+pushen. | Direktive 23.07. |
| P25 | **Giga-Scrub NICHT per eigener PAT-/Heuristik-Suche**, sondern nach dem Cluster-dokumentierten Verfahren + Rueckschreibe-Report an den Infra-Agenten. | Direktive 26.07. (Board #9) |

### 1.3 Architektur (Metaprogrammierung, Achsen, Kette)

| # | Direktive | Quelle |
|---|---|---|
| M1 | **Hot-Path compile-time-only:** CRTP + Concept-Guard, **keine vtable, kein Runtime-Switch, keine Runtime-Registrierung.** Concept-Verletzung MUSS den Build brechen. | `feedback_no_runtime_switch`, `feedback_compile_time_only_no_runtime`, `feedback_crtp_concept_guard_mix_pattern` |
| M2 | **CT->RT-Degradierung ist zurueckzukorrigieren.** | `feedback_metaprogrammierung_compile_time_zwingend_durchsetzen` |
| M3 | **§66-N3 MAPPING-REINHEIT:** `std::variant` fuer statische Haupt-Achsen **strikt verboten** (RT-Variable auf CT-Ziel = Bloat). Nur **CT->CT** und **RT->RT**. Verschiedene RT-Unter-Achsen-Varianten auf dieselbe CT-Haupt-Achse sind erlaubt. **Einzige eng limitierte Ausnahme:** Hybrid-Tier als dynamischer Traeger abweichender **Unter**-Pruefdock-Vertraege via Abstract Factory. | `feedback_no_std_variant_static_axes_bloat`; LEDGER §23, §49-Korrektur, §66-N3 |
| M4 | **Alle Achsen immer getrennt behandeln und klammern** - keine Fusion in Signaturen/Schluesseln/Stempeln. | §66-N3 Punkt 4 |
| M5 | **Nur benannte Lehrbuch-Design-Patterns** (GoF), zero-cost. | `feedback_lehrbuch_design_patterns_only_zero_cost_metaprog` |
| M6 | **Keine Achse ist optional.** Nicht zutreffend = konkreter Durchreich-Algorithmus (`NoBuffer`/`NonePrefetch`/`None`), nie Weglassen. | Doc 14 Kopf-Banner; Doc 12 §Korrektur 03.06. |
| M7 | **§54-T1: "Gattung" bezeichnet ausschliesslich das Tier-Binary-INTERFACE** (SearchAlgorithm/Container/Graph), **NIE eine Achse.** Achsen sind nach **TYP** organisiert: `AxisKind = {organ, system_measurement, system_config}`. | LEDGER §54-T1 |
| M8 | **§54-T4: Permutations-Baum existiert je Achsen-TYP** (Organ-/System-/Mess-Baum), nicht je Gattung. | LEDGER §54-T4 |
| M9 | **§54-T3: binary_id = 17-Organ-Kern.** System-Achsen leben im `build_version`-Sidecar. Einkompilierter Satz = freigegebene System-Achsen ∪ 17 Organ-Achsen, alle gestempelt. | LEDGER §54-T3 |
| M10 | **§54-T5/T7 Meta-Meta-Achsen:** statische Hardware-Haupt-Achse ist **Manager** ueber ein statisches Achsen-ARRAY; Freigabe per **Command-Pattern**; **zweischichtige Kern-Permutation** (Existenz an/aus + Wert), Existenz-Wahl compile-time. Achsen-Zahl waechst dynamisch je Maschine. | LEDGER §54-T5/T7 |
| M11 | **§37 Freigabe-Prinzip:** System-Achsen **geben frei**, Organ-Achsen **setzen durch**; Organ-Nutzung <= System-Freigabe. Gilt fuer ALLE System-Achsen (SIMD = Pilot). Nur statische System-**Haupt**-Achsen geben frei; dynamische Unter-Achsen werden zur Laufzeit durchgereicht. | LEDGER §37, §37.b |
| M12 | **§24 Haupt/Unter:** Haupt-Achse = compile-time-statisch (eigenes Binary + Stempel), Unter-Achse = dynamisch, an die naechste Stufe delegiert. Die dynamischen Einstellungen der vorhergehenden Stufe sind oft die CT-Draehte der naechsten. | LEDGER §24 |
| M13 | **§18/§30 Layer-Trennung:** System-Haupt-Achsen `[d,e,f]` und Organ-Haupt-Achsen `[g,h,i]` werden **NIE verschmolzen** - auch nicht in der CEB-Laufzeit (aeussere System-Schleife, inneres Organ-Fenster; getrennte Buckets/Loops/Schluessel). | Direktive 23.07., SUPER `cf616d2` |
| M14 | **§56 Legenden-Vertrag (autoritativ):** `ceb:build:[a,b,c]` (Mess-Achse baut nur die CEB und delegiert) / `tier:build:[d,e,f][g,h,i]:chunk<k>` (System x Organ) / `measure:[a,b,c][d,e,f][g,h,i]`. `[a,b,c]` gehoert **nicht** in die Tier-Build-Legende. | LEDGER §56 |
| M15 | **§57 Realms:** CEB-Realm = Mess-Achse fest einkompiliert, System+Organ noch runtime. Tier-Realm = System UND Organ beide einkompiliert, als **getrennte** Dimensionen. Chunk zweistufig (CEB: Freigabe-Erlaubnis + tobecompiled; Tier: Freigabe-Durchfuehrung + kompiliert). | LEDGER §57 |
| M16 | **§30 Kette:** Planer = Mess-Achsen, CEB = System-Achsen, Tier-Binary = Organ-Achsen, Hybrid = 4. Glied. **Rekursive Dock-Topologie**, ABI-stabile `.so`. | `feedback_kette_planer_mess_ceb_system_tier_organ_hybrid`, `feedback_recursive_dock_planer_ceb_tier_abi_stable_so` |
| M17 | **§38 Dock-Direktionalitaet:** Experiment-Dock (Planer->CEB) urspruenglich eindimensional, **revidiert**: sparser Fortschritts-Rueckkanal (nur Achsen-Deltas der lazy Materialisierung) hinauf; Pruef-Dock (CEB<->Tier) bidirektional. Planer uebergibt **serialisierte Teilbaeume mit Ranges**, nicht beliebige Configs. Ergebnis-Rueckschrieb laeuft **nicht** ueber das Experiment-Dock. | LEDGER §38 |
| M18 | **§38.b Mess-Exklusivitaet:** nur EINE CEB misst gleichzeitig **pro Maschine**; multiple CEBs sequentiell; Bau bleibt parallel. | LEDGER §38.b, §62-C |
| M19 | **§27 Registry = ANGEBOT, Anwender-XML = ANZEIGE** (`.pom`-Modell), Planer = **Resolver/Linker**. Unregistrierte Referenz = harter Validierungsfehler. Kein Parallel-Validator. | `feedback_registry_angebot_anwender_xml_pom_resolver_planer`; LEDGER §27 |
| M20 | **§28 DREI art-spezifische Registries** (Organ / System / Mess), je im eigenen Modul als XML. Haupt-Achse traegt optionale, meist dynamische Unter-Achsen. | LEDGER §28 |
| M21 | **§58 Stempel-Modell:** Planer = EINE `X.Y.Z` + ISA/OS. CEB = **Array** je einkompilierter Mess-Haupt-Achse (keine Gesamt-Version). Tier = **ZWEI separate Arrays** (System / Organ) + **dritter Merge-Stempel**. Nur Haupt-Achsen gestempelt; Unter-Achsen fliessen ungestempelt durch. Erst die **Mess-CSV** traegt den voll-permutativen Stempel (Haupt + Unter, mit Version je Achse). X.Y = Feature, Z = Debug-Revision, **je Achsen-Algorithmus einzeln**. | LEDGER §58, §43, §43.b |
| M22 | **§58-REPLAY:** Der Planer sucht zuerst, ob die Messung schon existiert, und gibt sie als Replay zurueck; sonst materialisiert er das Fehlende (Erweiterung der lazy Materialisierung). | LEDGER §58 |
| M23 | **§59 KERN-Mess-Schema:** **Default = ALLES messen; die XML wirkt als negatives Blacklisting.** Drei Stufen: (1) CE allein, (2) je Pruefling Default `replace` (alternativ `merge` = CE+Pruefling-Hybrid), (3) kombiniert `fulljoin`. XML steuert Messmodi, per-Achse merge/replace, welcher Pruefling (`identity="self"` = "CacheEngine"), per-Achse Algorithmus-Whitelist, `<template>` mit `restrict`/`extend` (Obergrenze = Registry-Angebot). **Keine neue Maschine, sondern Verallgemeinerung** von `pruefling_merge.hpp::MergeAxis`. **Je Pruefling-Merge eigener id-Satz**; dritter Tier-Stempel = die Merge-Kombination; ce-only-golden bleibt byte-identisch (Merges rein additiv). | `project_planer_mess_schema_kern_pruefling_replace_merge_fulljoin`; LEDGER §59 |
| M24 | **§64 Mess-Tooling VEREINT als Default:** ohne XML-Aussage sind alle 3 Verfahren (Wallclock/Makro/Micro) **gemeinsam** in EINER CEB per Metaprogrammierung; das Pruef-Dock nimmt alle 3 gemischt ab. Getrennte oder Teilmengen-Messung nur per XML. Getrennt-Entwicklung war eine **Regression**. | `feedback_mess_tooling_default_vereint_eine_ceb`; LEDGER §64 |
| M25 | **§47 Mess-Achsen-Schichtung:** **Mess-Tooling = HAUPT-Achse** {wallclock, makro, micro}; **Debug/Messen/Release = UNTER-Achse** (Ablaufmethodik); `measurement_categories` **und** Rueckschrieb-Methoden = Mess-Tooling-**UNTER**-Achsen im Planer. Wallclock ist CEB-seitig; Makro/Micro muessen CEB **und** Tier-Binary ueber das Pruefdock unterstuetzen. | LEDGER §47, §54-T2; Direktive 22.07. |
| M26 | **§61 Modi (stufenweise aufeinander aufbauend):** Debug = multi-Maschine, je Maschine parallel bauen+messen; Messung = parallel bauen, **sequentiell messen**; Release = ohne einkompilierte Mess-Einrichtung + Wallclock-Beweis; **COMPARE = 4. Modus** (§62-C). **Exactly-one** Modus je XML/CI-Call, Validator hart auf **beiden** Ausfuehrungspfaden. Debug = **Dual-Compile** (cmake-Debug UND -Release parallel, getestet nur Debug, nur Release fliesst weiter). Reuse-Schluessel `+bt` = cmake-Compile-Typ, **nie** der Modus. | LEDGER §61, §61-MODI, §61-STUFEN |
| M27 | **§61 Dual-Weg-Pflicht:** ALLE Funktionen muessen ueber GitLab-CI **und** lokal (cmake+Shell) laufen; der Planer generiert aus **derselben XML** CI-Code oder cmake-Code. Grune Pipeline <=> gruene lokale Tests. | LEDGER §61 |
| M28 | **§62-B Batch-Job-Prinzip:** Job-Anzahl **O(Maschinen), NIE O(Binaries)**. 130k Einzel-Jobs untersagt. Batch = 4096 Binaries, **CEB-intern** (nicht ueber Shell), GTest-Pruefstand am Pruefdock **vor** der Messung, Status-Pipe an den Planer. | LEDGER §62-B; Direktive 23.07. |
| M29 | **§62-A Planer-Universalitaet:** keine Runner-Tag-Vorfilterung; der Planer misst alles Verfuegbare und schreibt bei fehlenden physischen Achsen **Warnungen**, statt still zu filtern. Runner-Lanes = **Interim**. | LEDGER §62-A |
| M30 | **§62-B Cache-Log-Claim:** lockbares, versioniertes **Bestandslog** (XML) im MinIO-Cache; 3-Stufen-Dedup (Planer/CEB/Tier); Batch-Reservierung mit Zeitstempel als **Versprechen mit Release-Pflicht** + Fortschritts-Testat; ETA ueber max-Threads-Mini-Batch (Summe der Zeiten / Gesamtthreads, Untergrenze = max Einzelzeit); ETA-Ueberschreitung um 50% ohne Update = **Takeover**; pro-forma 30 min Reservierung; Schreib-Lock nur bei ETA-Berechnung; **live Cache-Sync = Betriebs-Voraussetzung, keine Optimierung**. Zwei getrennte Bestaende (Binaries / Messergebnisse) je mit eigener Strategy (Factory-Pattern). | LEDGER §62-B + Nachtraege |
| M31 | **§62-D Replay-Schichtung:** CEB-Binary <- `[a,b,c]`; Tier-Binary <- `[d,e,f]` **allein**; Messwerte <- `[d,e,f]` **und** `[g,h,i]` **plus Hardware-Kern-Identitaet**. **Binary-Sharing per Stempel, Replay per Hardware-Identitaet = zwei verschiedene Schluessel.** Identitaet = Aequivalenzklasse modulo ungenutzter Meta-Meta-Achsen. | LEDGER §62-D |
| M32 | **§65 Storage-Doktrin:** Binaries -> MinIO Ebene B; Messwerte -> git `measurement/<YYYYMMDD-HHMMSS>/` **und** measure-drop/NFS `Cluster_NFS/cache-engine-experiment`; **lokaler Fussabdruck der Baumaschine gegen null**. **git-Push und Mess-Rueckschrieb-Sink bleiben synchron; nur MinIO async** (I/O-Contention verfaelscht Messwerte). | LEDGER §65, §53-W11 |
| M33 | **Serialisierung:** System-Achsen **flach als Ordnerstruktur**; Tier-Achsen + CSV als **tiefer serialisierter Permutationsbaum**; statische und System-Achsen NICHT als Spalten (Ordner + Datei-Beschriftung); **nur dynamische Unter-Achsen als CSV-Spalten**. | `feedback_serialization_flat_systemaxis_folders_deep_tier_tree_dynamic_only_columns` |
| M34 | **Gattungen schneiden sich nicht, duerfen sich aber gegenseitig verwenden.** Set = eigenes Genus mit eigener ABI und nur teilweise wiederverwendeten Observern. Cross-Genus-**Join** typ-unmoeglich; Cross-Genus-**Komposition als Sub-Organ** ueber ein gemeinsames `OrganConcept` erlaubt. | `feedback_gattung_own_genus_own_abi_nonintersecting_mutually_usable` |
| M35 | **Fehlerklassen sind PFLICHT** ueber alle Achsen -> Unter-Achsen -> Algorithmen; der Planer kennt Klassen, statt hart abzubrechen. | `feedback_fehlerklassen_pflicht_alle_achsen_unterachsen_algorithmen` |
| M36 | **Vendoring-Doktrin:** vendor -> faithful -> self-contained. DLL linkt ihren Allokator selbst (Host-Export-Ansatz verworfen). | `feedback_vendoring_doctrine_ordered_vendor_faithful_selfcontained` |
| M37 | **Habich-Compliance:** Original-Code mit Original-Compiler bauen und **linken**, eigene Implementierung nur als Fallback; per-Function `is_original` nur true bei vorliegendem Original (Luecke = false). SHA256-Locking = Provenienz-Fundament. | Doc 13:27-34, :1179-1180, :1257-1258 |
| M38 | **Lizenz-Direktive II:** durch das Zerschneiden entsteht je Permutations-Achse ein neues Werk - alle Lizenztypen freigegeben; bei Repos ohne Lizenz nur Autor-Nennung. Firma "BEP Venture UG" bleibt in Rechtstexten, Marke = Comdare. | Doc 02:190-197; Direktive 08.07. |
| M39 | **Comdare-Matrix in Stein:** Umbrella -> Baseline (Layer, referenziert nur n->n-1) -> Modul (Zelle). Module = metaprogrammierungs-offener Source; Products/Research fuehren je eine eigene Instanziierungs-Matrix mit Binary-Interfaces. **Umbrella trackt alles ausser den Baseline-Zellen-Inhalten.** **G5/Modul-Zergliederung erst ganz am Projektende.** | `feedback_baseline_system_in_stein_gemeisselt_layering`, `feedback_umbrella_soll_struktur_...`; §52-Teil-1-F2 |
| M40 | **buildsystem.xml hands-off** (eigener Agent); parallel mit CMake+CI direkt entwickeln. | `feedback_buildsystem_xml_hands_off_parallel_ci_cmake` |
| M41 | **PRT-ART wird NIE hart verdrahtet** - Einbindung ausschliesslich per Metaprogrammierung/XML (`PrueflingSlot`, CT-Substitution in **genau EINE** Achse). PRT-ART bleibt separater Pruefling und wandert **nicht** in die CEB. | `feedback_prt_art_consumes_cache_engine`; LEDGER §52-B2 |
| M42 | **CEB = zentrales Experiment-Framework**, nimmt Framework-Tools und Diplomarbeit-Generatoren (Excel/PDF) als Library auf. Tool-Kartierung aller 4 Repos -> zentrale Konsolidierung (spaeteres TODO, #32/§65b). | Direktive 13.07.; LEDGER §65b |

### 1.4 Messung / Ehrlichkeit

| # | Direktive | Quelle |
|---|---|---|
| E1 | **honest-0 vor Phantom**; **honest-100%** - kein Faken, kein Weg-Nullen. Ein falscher Wert ist schlimmer als eine ehrliche 0. | LEDGER §18, §33; Direktive 13.07. |
| E2 | **Fehler nie als Nullen:** scheitert ein Achsen-Algorithmus, steht in der CSV-Zelle **"failed"** (nicht null) plus ein aggregierter Log neben der CSV mit dem Experiment-Fortschritt. Die Messung laeuft weiter. | `feedback_measurement_failure_visibility_csv_failed_not_null_plus_log` |
| E3 | **Zwei-Phasen-Op-Schleife PFLICHT:** save -> op(warmup, kalt) -> rollback -> op(measure). Jeder Messblock 3x wiederholt (XML-konfigurierbar); **n_repeats >= 3**. Es gibt **keine** zweite Gesamtausfuehrung. | LEDGER §16-A.3, §52-Frage-D (#225) |
| E4 | **Achsen-Vergleich gegen `std::map` entscheidet die Achsen-Guete, NICHT die Latenz.** | Doc 16 A.4 |
| E5 | **Effekte werden erforscht, nicht erfunden.** Min/Max-Optimierungs-Semantik je Achse per Deep Research. Ziel = mehrdimensionale statische Heuristik-Kurven. | LEDGER §18; Direktive 09.07. |
| E6 | **§33 Beweis-Doktrin:** golden-320 ist **KEIN** Systembeweis (13/17 Achsen gepinnt, nur Byte-Wache). Legitimer Beweis = **new-golden Voll-Konfiguration N=2^17**, CRC64-Anker. | `feedback_new_golden_all_axes_xml_gt320`; LEDGER §33 |
| E7 | **§41/GN-11:** Bau = new-golden (Pflicht), Messung = 320er (Zwischenergebnis), N-Messung ab 01.08. | LEDGER §41 |
| E8 | **§66-N2 PMC-Pflicht je DEKLARIERTER Lane:** `COMDARE_PMC_LANES` (Default "amd intel") = AND auf Comdare, beide Jobs hart; Fremd-Cluster ueberschreibt (XOR-Verfuegbarkeit) -> verschiffbar. Eine deklarierte, aber tote Maschine blockiert bewusst. | LEDGER §66-N2 |
| E9 | **Paper-/SOTA-Algorithmen muessen real gemessen werden**, nie als Spiegel; der Paper-Vergleich geht vor. | Doc 20:57; LEDGER §55 |
| E10 | **DATA-gated Messlaeufe nie aktiv pollen.** | `feedback_prod_ci_measurement_multiday_experiment` |
| E11 | **CI-Gesamtlauf = Diplomarbeit-Pipeline mit ABGESCHALTETER Messung** (sonst alles an); trennt CI-Gruen vom wissenschaftlichen Messlauf. | `feedback_ci_gesamtlauf_ist_messung_abgeschaltet_pdf_kompiliert` |
| E12 | **Rueckschreibung:** jeder Messwert-Stand in `measurement/<YYYYMMDD-HHMMSS>/`, per **merge** (nie rebase) auf development. | `project_mess_ergebnis_rueckschreibung_pipeline_persistiert` |
| E13 | **Debug darf mit allen CPU-Threads parallel messen**, solange wir nur aufbauen; echte Messung = 1 Thread. Gattungs-Threading kommt aus den Tier-Binary-Settings. | LEDGER §61 |

### 1.5 TABU (Aenderung nur im koordinierten GO-Fenster)

`permutation_axes.xml` (read-only Legacy-Katalog) · `golden_fullpilot_320_binary_ids.txt` bzw. `golden_320_catalog` (Byte-Wache) · **`kNewGolden131072Crc64 = 0xF1C1F26A1232073B`** · Observer-POD `sizeof` (aktuell **1272**) · **ABI-Major (aktuell 6, Magic `.A6.`)** · `GenusBindingTraits` · Registry-`mp_list` · `kV3AxisSchema` / `kCompositionAxisNames` · conformance-Oracle.
Alte Fixtures `_abi4`/`_abi5` additiv eingefroren, nie loeschen.
Quelle: LEDGER §0-TABU, §22, `feedback_alt_golden_darf_brechen_erst_additiv_dann_aufraeumen_unter_absprache` (der User hat den Bruch der **alt**-golden-320 explizit erlaubt - erst additiv, dann aufraeumen, nur unter Absprache).

### 1.6 Infra / Security

- **§39 Cluster ist fuer die Impl reserviert**; Infrastruktur darf autonom mit Vault-Schluesseln eingerichtet werden. Einziger Blocker sei die Implementierung.
- **Cluster-Repo ist von jedem Scrub-Scope ausgenommen** (Vault-Heimat, gitlab-lokal, kein github).
- Cross-VLAN immer ueber die lokale `.1`-CARP-VIP + SNI-Passthrough (`reference_cluster_vlan_tabelle_sni_standard_pattern`).
- **Desktop Plain-Backup** (untracked, cron 15 min, token-frei, Transkripte ausgeschlossen) gegen History-Rewrite-Verluste.
- **Kein Vault-Dump, keine halbmaskierten Prints** - nur Blind-Extraktion in Variablen + md5-Vergleich.

---

## 2. ARCHITEKTUR-VERTRAEGE UND INVARIANTEN (mit `datei:zeile`)

> Alle Zeilenangaben sind der letzte in den Quellen belegte Stand. **Vor Verwendung live gegenpruefen** (P1) - die Codebasis hat sich zwischen INC-2c, INC-2d und dem Lager-Gate mehrfach verschoben.

### 2.1 Achsen-Taxonomie (Wurzeln und Kinder)

| Vertrag | Anker |
|---|---|
| `AxisKind = {organ, system_measurement, system_config}` - **kein `genus`-Enumerator** | `topics/axis.hpp:17-20` |
| Dach `Axis<Derived>` + `AxisConcept`, Layer Supertype, empty base, Guard `is_empty && !is_polymorphic` | `topics/axis.hpp` |
| Organ-Dach `OrganAxis` (alle 17 Kompositions-Achsen haengen darunter) | `topics/organ_axis.hpp` |
| Mess-Wurzel ("Blut") `SystemAxis<Derived>` + `SystemAxisConcept` | `include/cache_engine/measurement/system_axis.hpp:147-190` |
| CEB-Konfig-Wurzel `CebSystemAxis<Derived>` | `measurement/ceb_system_axis.hpp` |
| Organ-Vertrag: `axis_tag`/`family_id`/`name()`/`enabled` + `topics::AxisBase` (`get_compiler()`, `is_original_module()`), validiert per `AxisBaseConcept` | `topics/axis_base.hpp:52-79`, `:90-94` |
| 3-Ebenen-Modell: Gattung (3 Interfaces) -> Genus (5) -> Organ-Achse -> Sub-Achse | `anatomy/anatomy_base.hpp:30-109`, `:39-80` |
| Genus-Bindung, Slot-Zahlen (nach INC-2d **17/11/13/9/5**) | `anatomy/genus_binding_traits.hpp` |
| `algo_version` je Organ-Varianten-Klasse Concept-erzwungen; universeller Backstop | `builder/experiment_tree/axis_variant_version_table.hpp:56` |
| Klassifikation Observer-Achsen (telemetry+isa = `DefinitionOnly`) | `axis_observer_classification.hpp:58`, `:60` |
| Mess-Tooling-Registry `MeasurementTooling{WallClock,Macro,Micro}`, `kMeasurementToolingCount=3` | `measurement_tooling_registry.hpp` |
| SIMD: Flag-Katalog (23 Einzel-Flags, cpuinfo-Id **und** gcc/clang-Flag hart getrennt), Maschinen-Signatur, Organ-Sinnhaftigkeit, Build-Gate (State-Pattern) | `measurement/simd_feature_flag.hpp`, `machine_simd_signature.hpp`, `measurement/simd_organ_sensibility.hpp`, `simd_build_gate.hpp`, `simd_organ_requirement.hpp`; `simd_sub_axis.hpp:107` |
| Fehlerklassen `CompilerCompilerErrorClass`, `SampleStatus{Ok,NotApplicable,SourceUnavailable,Failed}`, `InfraErrorClass` | `axis_error.hpp` |

### 2.2 binary_id, golden, Serialisierung

| Vertrag | Anker |
|---|---|
| `kCompositionAxisNames` = **17** Namen; **der serialisierte Achsenpfad IST die binary_id** (name()-basiert, nicht mangled) | `builder/experiment_tree/axis_path_serialization.hpp:30-34`, `:44-60` |
| `static_assert(sizeof...(Vs) == 17)` in `AdHocComposition` | `anatomy/composition_factory.hpp` |
| **Organ-only-Guard:** nur die 17 Organ-Achsen erzeugen binary_id-Level (strukturell, nicht Autor-Konvention) | `builder/experiment_tree/profile_to_tree.hpp:82`, `:95-96` (`is_organ_composition_axis`) |
| Autoritative `is_static`-Single-Source der Achsen-Dimensionen | `profile_to_tree.hpp:75-87` |
| `FullSourceCatalog = CatalogAxes<2,...,2> = 2^17 = 131072`; `kNewGolden131072Crc64` | `builder/profile_facade/source_catalog.hpp:83-113`, `:168` |
| `golden_320_catalog` = alte 320er-Semantik, jetzt Byte-Wache; `CatalogAxes<4,4,5,4>` | `source_catalog.hpp` + `golden_fullpilot_320_binary_ids.txt` |
| Lazy Per-Index-Emitter (Mixed-Radix, O(17) je Binary, kein `mp_product`) + Chunk-Fenster `COMDARE_GOLDEN_N_RANGE` | `lazy_adhoc_source_gen.hpp` |
| Anti-Materialisierungs-Guard (`kMaxMaterializableCatalogCardinality`) | GN-2, `source_catalog.hpp` |

### 2.3 ABI / PODs / Loader

| Vertrag | Anker |
|---|---|
| **ABI-Major = 6**, Magic `.A6.`; 4 Pflicht-Symbole; Major-Match + Minor<=; `comdare_destroy_anatomy` **VOR** `dlclose` (gleicher Heap); `dlopen(RTLD_NOW\|RTLD_LOCAL)`; Magic vor Version | `abi/anatomy_module_abi_v1_decl.hpp`, `builder/anatomy_module_loader/*`; Host-Spiegel `best_binary_selector.hpp:49`, `:51` |
| Observer-POD `ComdareTierObserverSnapshot`: **sizeof == 1272**, alignof 8, `axis_stats[17][8]` + `seg_ns[17]`, Version **7**, standard_layout + trivially_copyable | `include/cache_engine/abi/observable_tier.hpp:152`; `kV3AxisSchema` = Single-Source Schreiber<->CSV |
| Stempel-POD `AnatomyVersionLines`: gewachsen 40 -> 56 -> 72 -> 88 -> **136**, Layout 1 -> ... -> **5**; drei `{ptr,count}`-Entry-Arrays; `stamp_pod_has_entries`-Loader-Gate; Sentinel | `abi/anatomy_module_abi_v1_decl.hpp:133-134` ff. |
| Stempel-Erzeugung: `compose_organ_stamp_line`, `system_stamp_line`, `measurement_stamp_line` (+Overload fuer Mengen), `merge_stamp_line`, `anatomy_fingerprint_hex` (consteval SHA-512) | `abi/anatomy_version_stamp.hpp`; `ctsha512` |
| CEB-Stempel + Drift-Guard (`kCebMeasurementStamp == measurement_stamp_line_full_set()`) | `ceb_version_stamp.hpp` |
| Settings-POD `ComdareResourceControlV1` (6x uint64, Sentinel 0 = Default); Caps 64/64/1 GiB/4096/256 | `abi/resource_controllable_tier.hpp:34-40`; Caps `anatomy/abi_adapter.hpp:226-230` |
| **Pruef-Dock ist KEINE ABI-Grenze** (lebt im Builder, 1 vtable, nicht Hot-Path). ABI-Grenze = gattungs-eigenes Antriebs-Sub-Interface + flacher POD. Bindende Reihenfolge **import -> GATE -> messen**; `accepts` matcht ueber die im Modul deklarierte Gattung, nie ueber Dateinamen | `pruef_dock.hpp:74-79`; `conformance_gate.hpp:8` |
| Konformitaets-Gate real durchgesetzt (RF1-RF14 + 2000 Zufalls-Ops gegen `std::map`-Oracle) | `harness/perm_runner.hpp:130-164` (nach #45-Stufe-2 aus `builder/experiment_tree/` verschoben) |
| `IDriveableSubject` + `IResourceControllableTier` **immer** einkompiliert; `IObservableSubject` nur bei `COMDARE_MEASUREMENT_ON`; `dynamic_cast` genau 1x kalt je Modul | TIER-Doc §4.4 |
| Build-Typ-Stempel `+bt` (verhindert, dass `dll_is_current` eine Debug-DLL als Release reused) | `build_type_stamp.hpp`; Nahtstellen `profile_run_entry.hpp:650`, `experiment_run_entry.hpp:293`, `profile_run_facade.cpp:355` |
| Mengen-Signatur ueber die drei Enabled-Typlisten (consteval Zwei-Pass), je Achse separat geklammert | `build_variant_set_signature.hpp`, `driver_build_variant_signature.hpp` |

### 2.4 Emission / Legenden / Planer

| Vertrag | Anker |
|---|---|
| Legenden-Single-Source; `tier_build_job(perm, organ, chunk)`; `measurement_tooling_combo` = HAUPT, `measurement_combo` = UNTER-Kategorien-Formatter, DRY-Helper `canonical_combo` | `builder/experiment_tree/plan_legend.hpp:18-19`, `:73`, `:89`, `:97`, `:103`, `:109-116`, `:128` |
| Dreistufiger Director-Walk: Stufe 1 emittiert nur `ceb:build/emit/trigger`; `end_perm` leer; Stufe 2 (`TierCiYamlBuilder`) emittiert Tier-Batches + Mess-Job; `--emit-tier-ci`/`--emit-tier-cmake` als Delegation | `experiment_plan_director.hpp:455-462`, `:463-469`, `:483-565`, `:529`, `:643-649`, `:1067-1088` |
| Combo-Selektor + Trichotomie (leer = Identitaet / Slug = Subset / Miss = leer) | `experiment_plan_director.hpp:1236`, `select_measurement_combo` |
| `COMDARE_GN_TOTAL` Konsument; Chunk-Fenster-Zerlegung (disjunkte Teilfenster je Job) | `experiment_plan_director.hpp:668` |
| **Klassen-Regel: keine `$CI_PROJECT_DIR`-Werte in emittierten Child-`variables:`** (GitLab vorexpandiert; Grandchild bekommt leer) - Contract-Test wacht | Director-Kommentar + Contract-Test |
| **Emissionszeit-Literale statt `X: "$X"`** (Selbstreferenz = GitLab `circular variable reference`, Child bleibt leer) | `append_forward_var_literal` |
| Profil-Basename dynamisch (`profile_path.filename()`), Fallback `all_axes_golden.profile.xml` | `PlanHeader::profile_basename`; `emit_child_submodule_prolog` |
| Methodik-Profil-Selektor `COMDARE_PLAN_METHODIK_PROFILE` + Basename-Aufloesung gegen `thesis_profiles/` | `resolve_methodik_profile_path` (Facade) |
| CoR-Filterkette (GoF), aktiviert an 4 Seams | `builder/experiment_tree/selection_filter_chain.hpp:87`; `resolve_selection` |
| Fortschritts-Rueckkanal (§38) | `builder/experiment_tree/progress_delta.hpp`; `ExperimentSubtreePayload` (DEPRECATED, Wire-Format = #19) |

### 2.5 Bau / Cache / Storage

| Vertrag | Anker |
|---|---|
| `CompileFn`-Naht (injizierte Compile-Funktion, Orchestrator **achsen-blind**) | `builder/build_orchestrator.hpp:115` |
| `make_gpp_compile_fn` schreibt `.rsp`; `opt_flag`-Parameter; `-fno-gnu-unique` (gcc-only, clang-Dialekt-Gate) | `build_orchestrator.hpp:466-489`, `:476`, `:479` |
| **Der Orchestrator schreibt die Binary NIE selbst** (`r.status = compile_(job)` extern; `-o` in der `.rsp`); Invariante: `job.output` existiert unmittelbar nach compile - Basis von `dll_is_current`, Push-Pump, Sidecar-Schreibern | `build_orchestrator.hpp:510`, `:750` |
| **`dll_is_current` ist der EINE Skip-Arbiter** (Sidecars `.version` / `.algos` / `.variant`, `+bt`-scharf) | `build_orchestrator.hpp` |
| DLL self-linkt ihren Allokator (INC-0 Option B): `link_libs`-Kanal + `COMDARE_FACADE_PERM_LINK_LIBS`; Archiv-Emit zwingend **zwischen** Source und `-o` | `build_orchestrator.hpp`, Facade-Bake |
| Objekt-Key ausschliesslich in `cache_key_prefix`: `build_version + "+ceb=<major>.<minor>" + "+mtool=<combo>" + "+mrg=none"`; `--print-cache-key` als Paritaets-Naht; YAML nutzt `GN_CACHE_KEY` | `builder/artifact_cache.hpp`; Treiber-Dispatch |
| Push-Reihenfolge: `perm.dll` ZUERST, `.version` ZULETZT (Vollstaendigkeits-Marke); Fehler -> `InfraErrorClass::ArtefaktIo` loggen, lokale Kopie behalten, **weiter messen** | `artifact_cache.hpp` |
| Timeouts: `curl_put` mit `--connect-timeout/--max-time` VOR `-K`; Env-Gates `COMDARE_ARTEFAKT_{CONNECT_TIMEOUT_S,MAX_TIME_S,TRIES,RETRY_SLEEP_S}` | `artifact_cache.hpp:221-224`, `:94-102` |
| Pull = **Batch-Hydrierung** vor `provision_all` (`mc mirror`, inkrementell/resumierbar), nie per-Binary | `pull_tier_binary`, `pull_tier_prefix` |
| Pruning: `prune_verdict` loescht nur bei bewiesenem Remote-Spiegel (`.version` existiert + byte-gleich + Groesse gleich); `prunable_artifacts` = **nur** {perm.dll, .dll.version, .dll.algos}; **niemals** result.csv/measure_out/prune.log; nicht-fatal | `artifact_cache.hpp`, `verify_remote_then_prune`, `COMDARE_PRUNE_ONLY` |
| Async-Push: dedizierter Push-Thread + Queue (**nicht** push-in-worker); `close()` = Drain+join **vor** dem Whole-Chunk-Marker; Mess-Modus strikt synchron | `async_push_pump.hpp`, `set_on_binary_done` |
| RAM-Spool 256 MB / 12er-Trigger; `SpoolWriter<Backend>` als CT-Strategy (io_uring / Windows IoRing bzw. IOCP / portabler write-Thread); vendored liburing-2.6 | `builder/bestandslog/`, `ext/io/liburing/` |
| Bestandslog: XML mit eigener Header-Version, Lock/Union-Merge, `LagerKey` + **ZellKoordinaten** (combo/opt/simd als **getrennte** Felder, Eindeutigkeit ueber Tupel), `LagerIndex` (SHA512 -> Pfad), `PromiseGuard` (RAII, Release-Pflicht), ETA/avg_size, +50%-Takeover, Slice-Queue | `builder/bestandslog/*` |
| Iterator: `run_lazy_static_then_dynamic`; Lager-Load vor Hydration; `observe()` thread-sicher je Binary; Ein-Merge-`flush()`; Observer-Emittent | `cache_engine_builder_iterator.hpp:243-253`, `:668-819`, `:963` |
| System-Achsen-Reflektion abgespalten | `builder/experiment_tree/registry_to_axis_levels.hpp:81` (`build_all_axis_levels`), `:112` (`build_system_axis_levels`) |
| Provenienz/H-10: `system_axes_version_suffix`, Sidecar-Kette `+ext=+cxx=+opt=+ceb=<maj>.<min>[+target=]`, `.variant`- und `.fingerprint`-Sidecars | `builder/profile_facade/profile_run_facade.cpp:172`, `:340-350`; `organ_fingerprint.hpp` |

### 2.6 Validierung / Resolver / Merge

| Vertrag | Anker |
|---|---|
| Validator: Workload-ids gegen `known_workload_ids`; `op_types` hart gegen XSD-Enum OP-1..OP-6 (leer = Fehler); **exactly-one** `run_methodology` (auch auf dem tp-Pfad); per-Engine-Registry-Aufloesung aus statischen CMake-Pfaden | `builder/profile_facade/validate_profile.hpp:102`, `:321-334`, `:373-405`, `:726-757`; `validate_experiment_profile_facade` |
| Resolver (minimal-3-tief): `ClassifiedReject`, `ResolverReport`, `resolve_axis_refs_against_trio`; Rejects `V-CATEGORY` / `V-UNREG-AXIS`; `resolved`-Flag trennt "lief, 0 Rejects" von INERT | `validate_profile.hpp:629`, `:637`, `:646`, `:684`, `:691` |
| RegistryTrio = **17 / 5 / 16** (Organ / System / Mess) | `read_axis_registry_trio`; `profile_run_facade.cpp:593` |
| Parser als ce-Modul (kein tinyxml2, kein Regex), `parse_system_axes` (compiler/opt_level, extension_hardware/simd, atomic128, target_isa) | `libs/common/serialization/xml_config_parser/*`; `xml_config_parser.cpp:362-368`, `:401`, `:441-442` |
| Merge: `MergeStrategy{Stufe1_CeOnly, Stufe2_PrueflingReplace, Stufe3_FullJoin}` + `MergeAxis<S,Default,Slots...>`, **kein `std::variant`**, Genus-Guard `assert_pruefling_slot_genus` | `anatomy/pruefling_merge.hpp:99-124`, `:130-134`, `:137-158`; `permutation_strategy_concept.hpp:10-11` |
| Live-Interpreter der Stufen (heute **katalog-verdrahtet** auf EINEN Pruefling/EINEN Slot) | `builder/profile_facade/sota_catalog.hpp:105`, `:159`, `:162-243`, `:175`, `:182` (`sota_module_for`, `render_sota_module_source`) |
| Hybrid-Mathematik: Fritsch-Carlson-monotoner Spline (Default), `spline_intersections`, `PiecewiseCurve`/`BreakEvenPoint`/`SelectionObjective`(Strategy)/`HybridBinarySelector` | `curve_fit.hpp:129`, `:137`, `:155`, `:280`, `:321`, `:392`; `decision_lambda_trees.hpp:42`, `:67`, `:105` |

### 2.7 Harte Invarianten (Kurzliste zum Gegenpruefen)

1. **Anatomy-ABI ⊥ Observer/Subject-Schnittstelle** - Aufbau und Messung orthogonal, verbunden nur im AbiAdapter (`idriveable_tier.hpp:6`, `observable_tier.hpp:22`).
2. **binary_id enthaelt ausschliesslich die 17 Organ-Achsen**, name()-basiert; System-/Compile-/Shape-Achsen sind binary_id-orthogonal.
3. **golden-CRC64 `0xF1C1F26A1232073B` bleibt ueber alle Increments literal unveraendert** (laeuft ueber die binary_id-STRINGS, nicht DLL-Bytes).
4. **Der Emitter ist system-blind** (W4-B-Invariante): der Zell-Walk loest `simd_id` -> `-march`-**String**, nicht -> Achsen-Typ.
5. **Der Director ist ein reiner, byte-deterministischer Text-Emitter** - kein IO in `construct()`.
6. **Cross-Genus-Join ist typmathematisch unmoeglich**; 5 getrennte Anatomien/Compositions/Observer/PermutationEngines.
7. **Zwei-Phasen-COW-Messung:** das Such-Organ wird kopiert -> Stores muessen compile-time copy-konstruierbar sein und `restore_statistics(statistics())` als Memento fuehren (`abi_adapter.hpp:2176`).
8. **Die `*_scan`-Kerne sind bewusst strided Mess-Kerne** - ihr Zugriffsmuster IST das Achsen-Signal; SIMD-isieren wuerde es korrumpieren (Freeze-Guard `tests/unit/test_striktheit_scan_kernel_purity.cpp`).
9. **`cache_line_size()` ist intrinsische Layout-Semantik**, kein HW-Deskriptor - aus `axis_12` gespeist wuerde sie das Layout zerstoeren.
10. **Registry-Baustein-Name == `Wrapper::name()` == Serialize-Schluessel**, exakt, 0 Kollisionen ueber alle Achsen; Codegen bindet ueber `Enabled*`/`StaticAxisVariants*`, **nie** ueber `All*` (sonst `"(disabled)"`-Namen -> Byte-Roundtrip bricht).

---

## 3. EXAKTER IMPLEMENTIERUNGS-STAND

### 3.1 Zahlen-Kanon (autoritativ, Registry-XML = Ist)

| Groesse | Wert |
|---|---|
| Organ-Achsen (binary_id) | **17**, T0..T16 |
| System-Konfig-Haupt-Achsen | **7** (Scheduling, Hardware/ISA, Telemetrie, Last/Frameworks, Compiler, Erweiterungshardware, **TargetIsa**) + 3 Wurzeln |
| Gattung Ebene-1 / Genus Ebene-2 | 3 / 5 (Slots **17-11-13-9-5**) |
| Mess-Dimensionen / Mess-Kategorien / Mess-Tooling | 3 / **16** / **3** |
| Observer-POD | `sizeof == 1272`, Version **7**, `axis_stats[17][8]` |
| ABI | **Major 6**, Magic `.A6.` |
| Stempel-POD `AnatomyVersionLines` | **sizeof 136**, Layout **5** |
| Strategien gesamt | **123** |
| golden (Beweis) | **N = 2^17 = 131072**, CRC64 `0xF1C1F26A1232073B` |
| golden (Byte-Wache) | `golden_320_catalog`, 320 ids, `CatalogAxes<4,4,5,4>` |
| Voll-Bau-Volumen | 4 System-Perms x 2^17 = **524288 DLLs**, ~224 GB roh / ~56 GB je Zelle |
| ctest ce | zuletzt **315/315** (nach Folge-A) |

### 3.2 Commit-Kette (23.07. bis 26.07., in Reihenfolge)

**Kette 2 / §62-B (Batch-Emission) - abgeschlossen:**
`ce 091aca87` (S1 ProgressHeartbeat) -> `ce 7d9b4b55` (S3 `COMDARE_PRUEF_ONLY`) -> `ce 9df09f14` (S4 Batch-Emission O(Maschinen), `kGnBatchSlice=4096`, K-Budgets amd=24/intel=16, 49 Planner-Tests) -> `ce f41fb1af` (Basename-Durchreiche) -> `ce 44f55821` (Zirkularitaets-Fix) -> `ce 5990e53b` (Facade-Basename-Haertung).
CI-Belege: **Vollwellen 12516 und 12591 hart gruen**; Struktur-Smoke **12667** und Final-Smoke **12684** SUCCESS.

**Lager-Gate §66, Lane A (G2-Stempel):**
`dd48327f` (A1: 120 Literale `v1`->`v1.0.0`, eingefrorener Fingerprint-Testvektor) -> `79f24f6a` (A2: Single-Source System+Tooling X.Y.Z) -> `0918b697` (A3: Entry-POD 48B + consteval-Parser) -> **`ad11140d` (A4: POD 88->136, Layout 5, `_MERGE`-Arrays = bewusster ABI-Bruch)** -> `f2063357` (A5: CEB-Mess-Array + SHA512 mit Drift-Guard) -> `53c97072` (A6: AVX10-Feld) -> `730ebae9` (A7: `.variant`-Sidecar).

**Lane B (Lagerhaltung):**
`351855b8` (B1 Bestandslog-Dokument) -> B2 (Lock/Union-Merge) -> `93b20855` (B3 Factory + SHA512-Index; **Naht-Beweis: Lager-Key == Anatomy-Fingerprint**) -> `87cd73a2` (B4 Lifecycle/ETA/Takeover) -> `f8c38ff3` (B5 Batch-Planer/Slice-Queue) -> `be250512` (B6 RAM-Spool 256 MB + Writer-Strategy) -> `ed174638` (B7 io_uring gegen vendored liburing-2.6) -> `1e23b9be` (I1) -> `2ad563f0` (I1b) -> `27455b4e` (I1c) -> `f7fa30ef` (G5 Pruning-Kern).

**Danach:**
`ce d8ead0a8` (I2 `.fingerprint`-Sidecar, drift-bewiesen) -> `ce bbd5915a` (Vendor-Fix liburing-Header; **Pipeline 12783 SUCCESS** = gesamter Lager-Gate-Stand CI-hart-gruen) -> `ce f6144859` (Folge-B Mengen-Signatur) -> `ce bb35074d` (Folge-A Objekt-per-Key-API + LagerKey/ZellKoordinaten, ctest 315/315) -> `ce f3a6e68d` (G4a Director-Scheibe, 8 Punkte) -> **`ce 5795fae2` (Fix A Prune-Praefix) = LETZTER Commit**.

**super:** `c706f3e` -> ... -> `e374516` -> `6006fbab` + Folge-Commit. Thesis-Submodul `ef448e4b`.
**main == development auf BEIDEN Remotes** (Stand 26.07.).

**Scrub-Zwischenfall (24.07.):** Fremd-Agent hat super redigiert und force-gepusht (main `91897d4`->`a6af540`, development `4494b35`->`d6c06ef`, 4 Tags). Lokal hart auf `d6c06ef8` ausgerichtet; **§66-NACHTRAG-3 war beim Absturz uncommitted und fehlte im Scrub-Stand -> aus dem lokalen Tree restauriert.** ce vom Scrub unberuehrt.

### 3.3 Was funktional gelandet ist

- **INC-0** DLL-Load Option B (`nm -D`: `mi_*` = `T`), damit ueberhaupt `measured>0`.
- **INC-1a..1h** Achsen-Dach, System-Achsen-Abspaltung, Scheduling/Hardware/Extension/Load/Compiler-System-Achsen, H-10-Provenienz.
- **INC-2a..2d** Prueft-Dock scharf, ABI 4->5->6, Telemetrie aus binary_id (19->18), isa herausgeloest (18->17), `TargetIsaSystemAxis`.
- **INC-2c.opt a..k** Optimierungs-Unterachse unter der Compiler-Haupt-Achse, `.rsp`-`opt_flag`, `+opt=`-Sidecar.
- **F-SIMD** symmetrisch (`SimdSubAxis` unter `extension_hardware`), Flag-Katalog, Build-Gate (State-Pattern, heute inert).
- **KERN-A/B (S4)** Schema/Parser/validate/Director + Emitter-Merge-Stempel; benanntes `<template>`-Element.
- **S5** Planner + Driver (`progress_sink`, `run_methodology` verdrahtet, rebuild+measure im Mess-Job).
- **S6-P1** §64-Phase-1 (3 Tooling-Combos -> 1 `[all]`), Methodik-Profil-Schnitt, Debug-Dual-Compile (j3), `+bt`-Stempel, CPUID-Lane-Wache (exit 7), Host-Lanes `ceb-measure-<host>`.
- **#45** paralleler Mess-Loop (`collect_ordered`, `resolve_measure_parallelism`) - **Status widerspruechlich, s. 5.4**.
- **#46a/#53** Cache-Push/Pull, Key-Haertung, docs-only-CI-Gate, ccache-Hygiene.
- **#48 S1-S5** Deprecated-Moves, `experiment_golden_kern.xml` (v2), Parser/Validator-Naht (machines, `axis@pruefling`, `fulljoin`, storage inert), XSD-v2-Konsolidierung.
- **Lager-Gate** komplett bis G4a + Fix A (s.o.).
- **GN-11-Messfaehigkeit erbracht:** (a) CI ueber 12516/12591; (b) **bare-metal prod1 end-to-end**: 8 `perm.dll`, K7b-Stempel `m3v2+ext=no_extension+cxx=g++-16+opt=O3+ceb=6.0`, PRUEF 8/8 ohne Neubau, Messung 1-Thread -> **16 echte Mess-Zeilen**.
- **CI-Server-Reparatur (23.07. Nacht):** Sidekiq-ConcurrencyLimit-Deferred-Queues geleert (6,4 Mio+ Cron-Drainer-Jobs), fehlender `ConcurrencyLimit::ResumeWorker`-Cron registriert; Push-Pipelines laufen wieder.
- **Thesis:** Anhang B (Code-Struktur) und E (ADR-1..12) DE+EN generiert, latexmk gruen - **aber s. 5.4**.

### 3.4 Was in Bau / eingefroren ist

- **G4b** (naechste Scheibe): Agent **Impl-S6-P2 im FREEZE, NICHT gestartet.** Auftrag steht in HANDOVER-5 §2. Zwei Manager-Entscheide liegen vor:
  - Lifecycle **L1+L2 genehmigt** (PromiseGuard-Terminalitaet + stabile id `owner_uuid + "/plan/" + doc`).
  - **Entscheid R1: G4b geweitet auf das Paket Host-Verdrahtung**, weil die Bestandslog-Host-Verdrahtung **nirgends existiert** (`bestandslog_active` in Produktion immer false).
  - `--dump-plan` bleibt strikt nebenwirkungsfrei; Reservierung haengt an `--emit-tier-ci`/`--emit-tier-cmake`.
- **Giga-Scrub (Board #9):** Werkzeuge bereit (233 kuratierte Regeln in `/home/comdare/.scrub-rules-diplom.txt`, chmod 600, md5-verifiziert; `git-filter-repo` unter `~/.local/bin/`). **Ungelesen: `2026-07-22-GIGA-SCRUB-FP-WHITELIST.md`** - erster Schritt beim Resume, VOR jedem Scrub-Lauf. **Rueckschreibe-Report an den Infra-Agenten ist PFLICHT und noch nicht geschrieben.**

### 3.5 Was nachweislich NICHT existiert

- **Voll-Bau 2^17 wurde NIE abgeschlossen** (Verify-GN11: einziger Trigger, Pipeline 11519, wurde gecancelt; Teilstand verloren). Alle vorliegenden Belege stammen von kleinem N.
- **320er-Voll-Messlauf** nie durchgefahren (nur Smokes und Teilmengen).
- **Experiment-Planer als bedienbare 3. Anwendung**: Director + Builders existieren, aber **keine CLI** (`run <xml>`, `--status`, %/ETA/Resume-Anzeige, JSON-Marker fehlen; `--help` beschreibt Alt-Schema; ~16 Env-Vars ohne CLI-Aequivalent). = **#34/R3**.
- **.so-ABI-Vertrag Planer<->CEB**: heute Textemission. = **#35/R1** (die Auskunft "bewusst verworfen" war falsch; es ist DEFERRED und per §30 sogar Ziel-Design).
- **COMPARE-Modus** (#47) ungebaut.
- **Hybrid-Binary** (S7, Abgabe-Pflicht): nur Spline-/Break-Even-Scaffold; kein Hot-Swap, kein Dock-Array mit Verdraengung.
- **Mess-Tooling-Fanout N>1** nicht scharf (Sequenz D1 -> D2 -> D4 -> golden-Topologie-GO).
- **`sota_module_for`** ist weiterhin **katalog-verdrahtet auf EINEN Pruefling (prt_art) und EINEN Slot (path_compression)**; `phase.pruefling` wird geparst, aber nicht konsumiert; `"CacheEngine"`-Identitaet und Template-Load fehlen (= K5-Rest des §59-KERN).
- **Registry-seitige `algo_version`-Pflege**: Quelldaten flaechendeckend `v1.0.0` (A1 hat nur das Format gehoben); echte X.Y.Z-Semantik je Algorithmus offen (Band C).
- **`std::variant`-Altinsel** (`algorithm_baustein.hpp` / `baustein_variants.hpp` / `resolve_baustein.hpp`, REV 7.6) existiert weiter als latente, quarantaenisierte Insel (Task #52); Guard `HotPathIsVariantFree` verhindert die Ausbreitung.

---

## 4. OFFENE ARBEIT IN GATE-REIHENFOLGE

### GATE 0 - Final-Smoke (blockiert alles)
**Die Pipeline auf ce `5795fae2` ist der autoritative Final-Smoke.** ID beim Resume via API ermitteln (Projekte 286 **und** 288 dual-pollen). Kriterium: **GESAMTE Pipeline hart gruen**, kein `allow_failure`.
Grund fuer die Pflicht: G4a aendert die emittierte YAML unbedingt an vier Stellen (Storage-Source, PMC-Preflight, Prune-Block, Artefakt-Glob).

### GATE 1 - G4b (Impl-S6-P2 aus dem FREEZE)
Host-Verdrahtung Bestandslog (R1) + `planer_block`-Reservierung mit L1+L2. Ohne das bleibt `bestandslog_active` in Produktion false, d.h. die gesamte Lagerhaltung ist gebaut, aber nicht angeschlossen.

### GATE 2 - Drei lokale Beweise (Board #5)
1. **Resume-Skip**: `GN_DECISION=skip` literal im Log.
2. **Hydration-Smoke** mit **`verified>0` UND `pruned>0`** (durch Fix A erst jetzt sinnvoll pruefbar; "behalten = alles" ist ein Befund, kein gruen).
3. **Variant-Gate-E2E** (provision-only mit/ohne Gate + Voll-Skip).

### GATE 3 - Giga-Scrub (Board #9, Fenster-Empfehlung: hier)
Reihenfolge: FP-Whitelist lesen -> Exclusion-Check (Cluster TABU) -> bare-Clone -> Bundle-Backup -> maskierte Pre-Metriken -> `filter-repo` (`--replace-text/--replace-message/--prune-empty never`, `--invert-paths` fuer Meta-Pollution) -> hartes Verify (Commit-Count, Ref-Menge inkl. Tags, Leak=0 inkl. Messages, Messdaten-Checksummen, Scanner = python3-re, **nie** stummes `grep -P -f`) -> Force-Push gitlab (Keeper-API DELETE -> push -> reprotect, trap-gesichert) -> github -> Adoption prod1+node7 -> GitLab Repository-Cleanup + Blob-404-Verify -> Ledger -> **Rueckschreibe-Report an Infra (gitlab-only, PFLICHT)**.
Begruendung fuer das Fenster: "nicht mittendrin" - Agenten pausiert, kein Batch, Voll-Bau laeuft danach auf der finalen Linie.

### GATE 4 - Voll-Bau-4 (new-golden 2^17)
Trigger-Rezept: `POST /projects/288/pipeline`, `ref=development`, **nur** `COMDARE_BUILD_GOLDEN_N=true` (`GN_TOTAL=131072` ist Default; `MEASURE_PROFILE` ungesetzt lassen -> Mess-Batches bleiben `when:manual`; `COMDARE_STATIC_MATRIX_FALLBACK` NICHT setzen). Worker **24/24**.
Bindende Abnahme-Kriterien: Bau-Testate je Slice mit **ebenen-richtiger Grammatik** · Binary-Zaehlung gegen Katalog + Pruef-Bilanz je Perm · **CI-HIT/Skip-Beweis mit `GN_DECISION=skip` im Log + Skip-Zaehlung** (ohne diesen Beleg gilt die Resume-Schicht als NICHT bewiesen, auch bei gruenem Lauf) · Cron-Wache ohne FEHLT-Alarm.
Betriebsauflagen: keine schweren parallelen CI-Jobs (OOM-Erfahrung 23.07.); Platten-Wache; Job-`timeout` 30 h (Pilot-Wert 2 h war ein akuter Fund).

### GATE 5 - 320er-Messlauf (Abgabe-Datensatz)
`when: manual` + **USER-GO**. Ein-CEB-Mess-Exklusivitaet pro Maschine, prod1 und prod2 parallel. Wallclock-first, dann volle 3-Tooling-Matrix.

### GATE 6 - S7 Hybrid + M-4 + PDF-Kette
Hybrid-Binary (Break-Even ueber Spline-Schnittpunkte, drei Mechaniken) = **Abgabe-Pflicht**; M-4 = 19->17-Nachzug in den Auswertungs-Stufen; CSV -> LaTeX -> PDF.

### GATE 7 - G8 Anhaenge (Abgabe-Blocker)
Anhang A (braucht Messlauf), Anhang B + E (aktuell 4-Zeilen-Stubs bzw. generiert - Status widerspruechlich, s. 5.4), CRC64-Anhang, #193 hand-bedienbar.

### GATE 8 - S8 PDF DE+EN
**END-GATE Mo 27.07.**

### GATE 9 - development -> main
Vorsicht: beide `main` sind vom PAT-Scrub rewritten; **github-super traegt weiterhin den unredigierten Stand** (Force nur mit je-Repo-GO).

### GATE 10 - Phase 4: erweiterte Lagerhaltung vor 01.08.
#46b Vollausbau (Claims/Lease/Timeout), §65-Vollzug (lokaler Fussabdruck -> 0), #32/§65b Tools-Lagerhaltung, #51 tier150-Ersatz.

### GATE 11 - Band C / §63-Endlauf bis leeres Backlog
Post-v3 in freigegebener Reihenfolge: **#34 CLI -> #35 .so-Schnitt (R1/R2) -> #36 #19-Resolver + CoR -> #44 Paper-Template-Profile -> #38 K7b/K8 -> #37 F-SPREAD** -> gate-getrieben (A16-Pinning, A17-NUMA, A13-Locking) -> **PV-9 Deprecated-Kuration** (laufend).
Dazu: #47 COMPARE · #48 XML-Aufraeum-Gate + golden-XML neu · #49 RAM-/CPU-Fabrikations-System-Achsen (libcpuid / cpu_features / decode-dimms) · #53 CI-Wartung · #54 CEB-interner Batch + GTest-Pruefstand + Status-Pipe · S10 ISA-Fork-A + Meta-Meta + Stempel-Fold · S11 NUMA/page_type · **S12 Gattungs-Vervollstaendigung (letzter ABI-Schritt)** · S-7 Upgradeable-Locking · #276 3-ISA-CI = **ALLERLETZTE Aufgabe**.

### Ab 01.08.
new-golden VOLL-MESSUNG.

---

## 5. WIDERSPRUECHE UND LUECKEN (explizit, ungeglaettet)

### 5.1 Zahlen- und Nummern-Drift

| ID | Widerspruch | Aufloesung / Restrisiko |
|---|---|---|
| W-1 | **Achsen-Zahl 19 vs 18 vs 17.** Doc 14, 16, 17, 18, 19, Dossier 23, TIER-Doc, KONSTRUKTIONSLOGIK fuehren **19**; NW1 (INC-2c) **18**; INC-2d-Nachtrag + Registry-XML **17**. | Autoritativ = **17**. Stale-Anker, die noch "19" sagen: `ceb_system_axis.hpp:7-8`, LEDGER 1668/1679, `genus_binding_traits.hpp:42/12`, `anatomy_base.hpp:169`, `br4_load.cpp:69` (`organ_count()==19`, IAnatomyBase-ABI = eigener Begriff), `test_obs_phaseB_pilot.cpp:6`. **Immer Registry-XML als Ist nehmen.** |
| W-2 | **Slot-Shift.** Jede `T<n>`-Referenz aus Docs 13-23 ist um -1 (isa) bzw. -2 (telemetry+isa) verschoben. Zusaetzlich sind **axes26-T-Nummern != Slot-T-Nummern**. | Jede T-Referenz aus Altdokumenten **vor Gebrauch umrechnen**. Ein `T19` existiert in keiner Zaehlung. |
| W-3 | **Stale `k*SlotCount`-Konstanten** (set=15/seq=11/view=7/adapter=13, Diff jetzt +2) + aktiver stale `static_assert` in `test_d9_set.cpp:38`. | Teils per K-3/G8-Sweep (Welle 1) gefixt. **Restpruefung offen** (Audit L4/G8). Belastbar ist NUR struct-internes `slot_count` + `axis_names().size()`. |
| W-4 | **`all_axes_binary_count()`** multiplizierte System-Achsen (`T10_telemetry`, `T12_isa`) mit -> irrefuehrender Name. | Rename `all_axes_matrix_count` per K-7 (Welle 1) gelandet - **Vollzug verifizieren**. |
| W-5 | **`SimdSubAxis::parent_axis_label() == "extension_hardware"`** zeigte auf einen verwaisten Knoten (flache `ExtensionHardwareSystemAxis` DEPRECATED). | GN-1 hat einen aktiven `ExtensionHardwareFamilyAxis` gebaut. **Audit G2/E-4 formal noch offen** - gegenpruefen. |
| W-6 | **Drei bis vier inkompatible ID-Systeme** fuer "dieselben" Achsen (string-IDs T00-T17, numerisch 1-14 + 15.1-15.5, Legacy-GROSS-Aliasse, dazu die 11-Bausteine-Achsen aus Doc 02/07). | Kanonisch = **string-IDs**. Numerische IDs + GROSS-Aliasse speisen **nichts**. Achsen-Nummern aus Doc 02/07 sind mit nichts im heutigen Code kompatibel. |
| W-7 | **Ledger-Nummernraum-Kollision (O-13):** Session-Task-`#N` (07-20 ff.) vs. Alt-Ledger-`#N` (1-279). | Nummern **immer mit §-Anker** lesen. |
| W-8 | **Permutationsraum-Literalzahl 137.594.142.720.000** (Doc 16 als Gate-1-Sollwert). | Flag-Snapshot vom 02.06.; gueltig ist nur die Produkt-Identitaet. **Nie als Gate hartkodieren.** |

### 5.2 Doku vs. Code (aktive Drifts)

| ID | Widerspruch | Status |
|---|---|---|
| W-9 | **`plan_legend.hpp:69/:73`** bildete den `[a,b,c]`-HAUPT-Slot aus `measurement_categories` statt aus dem Mess-Tooling (T2-Residue); **`:109-111`** emittierte `tier:build:[a,b,c][d,e,f]` (T6-Verstoss). | Beides in **S0.5** gefixt. **ABER:** `docs/architektur/2026-07-20-...in-eigenen-worten.md:90`/`:97` fuehrt beides noch als offenen Ist-Regress. **Doku-Nachzug faellig.** |
| W-10 | **`build_system_axis_levels()` hatte repo-weit 0 Aufrufer** -> telemetry-, page_type- und simd_extension-Wahl landeten in KEINEM Sidecar; Provenienz lief real nur ueber `system_axes_version_suffix`. | Per W9 (H-10-Sidecar-Aufrufer) teil-gefixt. **Vollstaendigkeit vor dem Messlauf verifizieren** - das war explizit als "vor Messlauf zwingend" markiert. |
| W-11 | **`static_assert(sizeof(ComdareTierObserverSnapshot)==1272)` fehlte** (nur Kommentar). | Per K-2 (Welle 1) gelandet. Nach den POD-Wachstumsschritten (A3/A4) **Konsistenz gegenpruefen**. |
| W-12 | **Fix A deckte auf:** `verify_remote_then_prune` bildete den Remote-Praefix aus dem nackten `build_version` ("m3v2"), gepusht wird aber suffigiert -> **Prune war garantiert wirkungslos** (`pruned=0`, nicht-fatal, unauffaellig). | Gefixt (`prune_key_base` liest die lokale `perm.dll.version`). Analoge Praefix-Divergenzen sind eine **Fehlerklasse**, kein Einzelfall - der R8b-Befund war identisch (`GN_PREFIX` != `cache_key_prefix`, Pull strukturell leer). |
| W-13 | **Doppelte Perm-Suffix-Reihenfolge:** perm-loop `+cxx+opt+ext` vs. `system_axes_version_suffix` `+ext+cxx+opt` - zwei intern konsistente, untereinander divergente `build_version`. | Offener Single-Source-Aufraeum-Kandidat. **Hohe Cache-Key-Relevanz.** |
| W-14 | **Cross-Constraints der queuing-Achsen** (Q-EPOCH+F-EAGER, Q-COW+F-ADAPTIVE, Q-NONE nur F-LAZY) sind dokumentiert, aber **nicht enforced**. | Der Permutationsraum enthaelt damit bekannt-invalide Kombinationen. Implementierung via `mp_filter` vorgesehen, nicht gebaut. |
| W-15 | **`contract`-Label-Luecke:** eine ce-Welle war gruen, obwohl ein Test-Pin gebrochen war - beide Tests tragen das `contract`-Label, das die ce-CI-Testauswahl (`-LE contract\|pmc`) ausschliesst. | CI-Wartungs-Merkposten. **Wachen-Luecke, real erlebt.** |

### 5.3 Doku vs. Doku (nicht nachgezogene Supersessionen)

| ID | Widerspruch |
|---|---|
| W-16 | **§54-T6 war im Ledger SELBST falsch** und propagierte in §55 (14 Anker) und v3.1. Korrigiert per **§56**; v3.1 wurde geloescht (User-Ausnahme), v3.2 neu erstellt. Restliche Zitate in Doku sind teils legitime "so-war-es-falsch"-Belege - **nicht blind ersetzen**. |
| W-17 | **Mess-Kategorien:** Basis-Tabellen (Dossier 23:108-112, NW:189-191, Doc 16:124/151) sagen "16 Kategorien = Haupt-Achsen"; §47/§54-T2 korrigiert auf **UNTER**-Achse. Die Basis-Tabellen wurden **nicht** nachgezogen. |
| W-18 | **§64 VEREINT** supersediert die §47/§54-Lesart "je Tooling-Wahl eine eigene CEB, N->N Pipelines". Die SEPARAT-Stellen sind teils nicht als supersediert markiert. |
| W-19 | **§38 Rueckkanal:** aeltere Dokumente (KONSTRUKTIONSLOGIK Nachtrag Z.374-377) fuehren "Experiment-Dock eindimensional, kein Rueckkanal". §38 hat das explizit revidiert. |
| W-20 | **CMake-per-Permutation vs. CEB-Laufzeit-Orchestrierung:** Doc 14 §17.3/§45/§47/§48.5/§51 beschreiben eine vollstaendig gelieferte, getestete CMake-Pipeline; Nachtrag R4 erklaert sie fuer abgeloest. **Beide Pfade existieren real**; der doktrin-konforme war lange der kaputte (kein Link-Kanal) - per INC-0 Option B gefixt, Default-Backend per GO-2 auf `cpp`. |
| W-21 | **Anatomie ohne Container-Ops** (Doc 14 §17.2/§24 verbieten `insert/lookup/erase/clear` ausdruecklich) vs. **ABI/R6.B** mit genau diesen Symbolen und internem `std::map` im `SearchAlgorithmAbiAdapter`. Formal ueber die Adapter-Schicht aufloesbar, aber **die Grenze ist nicht sauber gezogen**. |
| W-22 | **Workload-Konfiguration:** Doc 14 §53 = C++-`WorkloadConfig` mit 4 hart kodierten Profilen; Doc 15 §0/§2 = **E4-XML + E1-Laufzeit**, YCSB A/C/E x 6er-Dataset-Kanon. Autoritativ = Doc 15 + §59. |
| W-23 | **Statistik-Doktrin:** Doc 14 nennt durchgaengig **Welch-t-Test**; Doc 15:57 nennt fuer `baseline_3-analysis` **Mann-Whitney-U / Holm / Cliff's delta**. Nirgends abgeglichen. Ist-Code: Welch + Holm-FWER (`f15_compare`). |
| W-24 | **golden-320 als Beweis** (Docs 16-19 fuehren `golden-Roundtrip==320` als DAS Abnahme-Gate) vs. **§33** ("nur Byte-Wache, 13/17 gepinnt; nur 2^17 ist Beweis"). Gate-Semantik bleibt, Beweis-Semantik ist entzogen. Wer Docs 16-19 liest, **ueberschaetzt die Aussagekraft von 320**. |
| W-25 | **Superseded-Banner inkonsistent:** Docs 03/04/06/09 (und 02/07) tragen ihn, **01_REV_Historie.md und 08_drawio_export.md desselben Jahrgangs und derselben Begriffswelt nicht** - obwohl Doc 16:19 das gesamte REV7.7-Vokabular als Bruchlinie-1/SUPERSEDED einstuft. |
| W-26 | **`00_INDEX.md` ist stale:** listet nur 01-09, kennt 10-23 nicht; sein SUPERSEDED-Banner (31.05.) ist **aelter** als 14/15/23 -> formal unentscheidbar, ob er fuer sie gilt. Thesis-Pfadschema im Index ist tot. |
| W-27 | **"Erstimplementierung immer Codex"** (Docs 16/18/19, Ledger) vs. "selbst implementieren ab 10.07." vs. "Impl an Opus delegieren ab 19.07.". Die drei Dossiers sind an dieser Stelle **datiert-stale**. |
| W-28 | **Set-Gattung:** F1a (Vokabular) gelandet; **F1b (Ebene-1-Promotion) braucht ABI/golden-GO** und ist NICHT vollzogen. Das F12III-Dossier beschreibt einen **Plan**, der leicht als Ist missgelesen wird (Ebene-1 = 3, nicht 4). |
| W-29 | **`ExperimentSubtreePayload`** ist DEPRECATED (Wire-Format = #19-voller-Resolver, Band-C), existiert aber weiter als Struktur+Test. Der §38-Serialisierungs-Vertrag ist damit **strukturell vorbereitet, nicht wirksam**. |

### 5.4 Behauptet vs. real (beide Richtungen)

| ID | Befund |
|---|---|
| W-30 | **#45 paralleler Mess-Loop:** in einer Session als gelandet gemeldet (`ce 99a608c2`, ctest 294/294), im Ledger/Board zugleich als **"OFFEN, Debug-parallel MESSEN existiert NICHT (§61-b)"** gefuehrt. **Echter, ungeklaerter Widerspruch - vor dem Messlauf aufloesen** (betrifft die Debug-Dauer direkt). |
| W-31 | **Thesis-Anhaenge B und E:** einerseits generiert und latexmk-gruen (`61f2557`, `66cf85c`, DE 220/EN 212 bzw. 188/177 Zeilen), andererseits im Ledger als **4-Zeilen-Stubs trotz DONE-Vermerk (AP-B4/AP-B5)** und als G8-Abgabe-Blocker gefuehrt. **Ist-Stand literal pruefen.** |
| W-32 | **K-5 ABI-Spiegel** (`best_binary_selector`) war laut §50:2633 und §52-D6 stale - **war aber bereits am 19.07. gefixt** (`kAbiMajor=6`, `.A6.`). Die Ledger-Eintraege sind **selbst stale**. |
| W-33 | **#1 Organ-only-Guard** und **9dim-Fixes 7/7** waren im Plan als offen gefuehrt, aber bereits erledigt. |
| W-34 | **`§26-L5` "build-i2 Include-Root-Gap"** ist eine Fehldeutung: es war reine **Build-Tree-Staleness** (die 17 nicht-existenten `-I` sind symmetrisch/harmlos). Ledger umdeuten. |
| W-35 | **#266 config-Owner-Gate** wurde in §48 faelschlich als erledigt gefuehrt; §55 korrigiert -> **offen**. Ebenso #262/7b-3. |
| W-36 | **Vier Ledger-"gate-frei saturiert"-Meldungen** waren Ueber-Behauptungen; ein Voll-Audit fand jeweils echte non-gated Slices. **Klasse: declare-victory-by-reclassification.** |
| W-37 | **§38-Dock**: Struktur erfuellt (`ce d7d35c36`), aber **3 Kettenlauf-Reste offen** (ProgressSink ohne Konsumenten, Payload nur Struktur+Test, `resource_group` am dynamischen Mess-Job). |
| W-38 | **§47-Notiz "`kMeasurementAxisVersionLine` fehlt"** ist ueberholt - `measurement_line` (W12-A3) und `merge_line` (K7a) existieren real. |
| W-39 | **Der Voll-Bau war nie erfolgreich** - eine Welle war "gruen", baute aber nur `TOTAL=16` statt 131072 (Variable an beiden Trigger-Grenzen verschluckt). **Muster: "gruen aber inhaltlich leer".** Deshalb ist der `GN_DECISION`-Beleg ein hartes Abnahme-Kriterium. |

### 5.5 Betriebs- und Kapazitaets-Luecken

| ID | Befund |
|---|---|
| W-40 | **ccache deckt nur den Treiber-Bau, NICHT die 131072 DLLs** (literal verifiziert). Wiederaufnahme nach Abbruch muss der Batch selbst koennen -> das ist genau, warum das Lager-Gate vorgezogen wurde. |
| W-41 | **Plattenplatz:** ~56 GB DLL-Masse je Zelle, ~224 GB fuer 4 Perms; prod1 zuletzt 109 G frei. **Retention-/Auslagerungs-Konzept fehlt.** §65 fordert lokalen Fussabdruck gegen null - der ehrliche Ist-Forecast lag bei ~58-65 G. |
| W-42 | **Ebene-B-Push ist in den Director-emittierten Batch-Jobs inert** (Aktivierung/MinIO-Vars nur in handgeschriebenen super-Jobs). = G4a-Punkt, jetzt gebaut - **Wirksamkeit ist Teil von Gate 2**. |
| W-43 | **Zombie-Driver nach Job-Cancel** (mehrfach, bis 18 h, 97 % CPU): GitLab-Cancel toetet nur den Shell-Wrapper. Dauerfix (Cancel-`trap` mit `trap -` zuerst) und `runner:sweep-zombies` existieren; **P11-Exklusivitaets-Wache bricht korrekt ab**, kostet aber einen Lauf. |
| W-44 | **OOM beim Parallel-Bau:** prod1 60 G RAM, unter 32 Workern nur 12 G available + 20 G Swap -> Bau ist **RAM-gebunden, nicht CPU-gebunden**. T-Werte deshalb amd 32->24. Waehrend des Voll-Baus keine schweren parallelen CI-Jobs. |
| W-45 | **Runner-Contention:** ein mehrtaegiger Mess-Job haelt einen von zwei prod1-Slots. Mess-Exklusivitaet ist pro Maschine, Bau parallel - aber die CI-Kapazitaet halbiert sich. |
| W-46 | **ResumeWorker-Cron liegt nur in Redis** -> nach Pod-Restart weg. Helm-Values/`gitlab.yml`-Persistenz = offener Infra-Merkposten. Ohne ihn erzeugen Pushes wieder keine Pipelines. |
| W-47 | **`measure-drop` war zweimal tot** (nginx-Stale-Config ohne TLS-Listener; NFS-PV auf tote NAS-IP). Ohne Timeout-Wrapper kostete das >30 h Retry-Wartezeit hochgerechnet. Timeouts sind jetzt gebaut. |

### 5.6 Ungeloeste User-Gates / Entscheidungen

| ID | Offen |
|---|---|
| G-a | **F1b Set-Ebene-1-Promotion** + F2 native Set-ABI: braucht ABI/golden-GO; gehoert in den **einen** koordinierten Bump (S12, letzter ABI-Schritt). |
| G-b | **#37 Scheduling als 27. Organ-Achse** (A+B, Prioritaet A): Design vorlegen, dann **pausieren bis User-Klarheit**; bricht golden/kV3AxisSchema/POD/ABI. |
| G-c | **#48 Scheibe 6** (Umhaengung auf die KERN-XML-Welt): gegated auf nach-320er + User-GO. |
| G-d | **T2-N>1-Scharfschaltung**: Sequenz D1 -> D2 -> D4 -> golden-Topologie-GO. |
| G-e | **G7-Restpunkte**: E13 (#37-3-Achsen deprecaten), E15 (C2/GH200), E16 (Tilgungs-Tasks), #24/#25 (User-Textstellen), #225-Rest. |
| G-f | **github privat vs. oeffentlich**; **github-super Force** (je-Repo-GO); Branch-Renames development->dev / main->prod (bewusst nach Voll-Bau-4). |
| G-g | **#23-Rest**: Alt-PAT-Revoke; Grundsatzfrage **eigener Nicht-root-GitLab-User** (heute existieren nur `root` und ein Projekt-Bot). |
| G-h | **prt-art telemetry-Demo-Slot (K-28)** - offene Entscheidung, bewusst nicht geraten. |
| G-i | **`page_type`-Heimat** (Organ / System / registry-los) und cacheline_study-Kanonizitaet (E-1/E-2/E-3). |
| G-j | **#270a P/E-Core** (HW-gated bis prod2-RMA), **#270b arm64** (node7-Freeze), **#273-T2 gcc-15.3-Pin** (nicht installiert). |

---

## 6. UNMITTELBAR NAECHSTE SCHRITTE

Reihenfolge bindend. Jeder Schritt beginnt mit einer **ultracode-Planung ueber Ledger + alle Plandocs** (A5) und endet mit **adversarialer Konformitaets-Pruefung** und der Verifikations-Kadenz (P23).

1. **Pipeline-ID der `5795fae2`-Welle via API ermitteln und Status literal feststellen** (Projekte 286 und 288 dual-pollen; kein Kurz-SHA-Query, `?sha=` braucht 40 Zeichen). Kriterium: gesamte Pipeline hart gruen. **Kein Erfolgs-Haken ohne literale Ausgabe.**
2. **Bei gruen: G4b starten** (Impl-S6-P2 aus dem FREEZE) mit dem Auftrag aus HANDOVER-5 §2, geweitet um R1 (Host-Verdrahtung Bestandslog) und L1+L2. Bei Kontextverlust Neu-Spawn mit exakt diesem Auftrag. Working-Tree-Freeze + diff-stat-Pruefung vor jedem `add`.
3. **Parallel (read-only, blockiert nichts): `2026-07-22-GIGA-SCRUB-FP-WHITELIST.md` lesen** und daraus das verfahrenskonforme Phase-B-Programm auf der aktuellen Linie ableiten. Fenster-Vorschlag an den User: **nach G4b + Smoke, VOR Voll-Bau-4**.
4. **Rueckschreibe-Report an den Infra-Agenten** ins Cluster-Repo schreiben (gitlab-only) - PFLICHT und ueberfaellig. Darin buendeln: ResumeWorker-Cron-Persistenz (W-46), Runner-Cancel-Prozessgruppen-Hygiene (W-43), PAT-Rotation #327 Rest (G-g), prod1-Runner-Version (P12).
5. **Nach G4b: die drei lokalen Beweise** (Gate 2). Insbesondere der Hydration-Smoke mit `verified>0` **und** `pruned>0` - Fix A macht ihn erst jetzt aussagefaehig.
6. **Ledger-Nachzug in EINEM Commit** (User-Technik, daher zulaessig): die "stale-als-erledigt"/"stale-als-offen"-Liste aus 5.4 aufloesen - **#45 (W-30), Anhaenge B/E (W-31), K-5 (W-32), #1-Guard (W-33), §26-L5 (W-34), #266 (W-35), §47-Notiz (W-38)** - plus die Doku-Drifts W-9 (in-eigenen-Worten :90/:97) und W-17/W-18 als additive Supersessions-Marker.
7. **Voll-Bau-4 triggern** (Gate 4) mit dem verifizierten Rezept, 24/24 Worker, Wachen (Platte, Cron, Heartbeat) armiert, keine parallelen schweren CI-Jobs.
8. **Wachen/Monitore bewerten**, verwaiste beenden (Zyklusende-Doktrin P20); die aus HANDOVER-5 genannten Watcher-IDs sind nach den Abstuerzen zu pruefen.

**Zwei Punkte, die der Architekt vor Gate 4 aktiv entscheiden sollte:**
- **W-30 (#45 paralleler Mess-Loop)** - ist der Debug-Parallel-Modus real gebaut oder nicht? Davon haengt die Mess-Dauer-Schaetzung fuer den 320er ab.
- **W-13 (doppelte Perm-Suffix-Reihenfolge)** - zwei divergente `build_version`-Formen sind eine latente Cache-Key-Fehlklasse derselben Familie wie W-12/R8b. Vor einem 524288-DLL-Lauf lieber einmal single-source ziehen als hinterher 224 GB neu bauen.

---

Selbstcheck: Dieses Dossier enthaelt keine Secret-Werte (keine Tokens, PATs, Passwoerter, Keys - auch keine Fragmente); genannt werden ausschliesslich Variablennamen, Vault-Pfade, Projekt-/Runner-IDs und Commit-SHAs. Zeichensatz ASCII bis auf zulaessiges `§`; keine Gedankenstrich- oder Box-Drawing-Zeichen. Alle sechs geforderten Abschnitte sind besetzt; Widersprueche sind mit W-IDs benannt und nicht geglaettet.