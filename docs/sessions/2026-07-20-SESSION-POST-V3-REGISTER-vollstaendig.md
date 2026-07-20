# POST-v3-REGISTER — vollstaendige Konsolidierung (2026-07-20 spaet)

> User-Frage: „Hast du Ledger und Sessions auch weiterhin nach Post-v3-Tasks durchsucht?" — Antwort:
> der Vergessene-TODOs-Sweep hatte die [C]-Gruppe vollstaendig erhoben; getaskt waren nur die 4
> Audit-Straenge. DIESES Doc ist das konsolidierte Gesamt-Register (Sweep-[C] + Ledger-Nachlese-Grep
> + deprecated-Audit + §58/§59/§60). Task-Board: Umbrella-Tasks #34-#43. Reihenfolge INNERHALB der
> Gruppen folgt den bestehenden Gates; Gruppe G4 (#34-37) ist die vom User freigegebene Kern-Sequenz.

## G1 — §58/§59-Caching/Storage-Folge (Caching-Phase, nach Abgabe)
- **K7b §58-STEMPEL-Array-Umbau** (Planer X.Y.Z / CEB-Array je Mess-Algo / Tier 2 Arrays; reformatiert Stempel-String -> eigenes golden-Fenster; fuer Merge-Stempel NICHT noetig).
- **§58-CSV-STEMPEL** (voll-permutativ Haupt+Unter, Kurzform-Legende mit Versionierung in Naming+Spalten) — Voraussetzung Caching-Replay.
- **§58-REPLAY** (Planer sucht per CSV-Stempel, replayed statt misst; Erweiterung Lazy-Materialisierung; Ledger §59-C praezisiert).
- **K8/§58-MINIO + §59-STORAGE** (async minio.comdare.de fuer Planer-Binary+CEB+Tier+CSV; eigener id-Satz je Merge/Join-Art als eigene Mess-Kategorie mit-gecached; lokal Default; artifact_cache No-Op-Naht verdrahten; Ebene B dev-MinIO V90 / Ebene C prod-NFS V91; §24.G/§31-A4/§51-B5-B6 Storage-Routing).
- **S13 STRANG-CACHE** (inkrementeller CEB/Tier-Cache: perm.algos-Sidecar, Concept-version()-Disziplin (B7-Rest!), ceb_contract_version, axis_version.lock-Tripwire; Sidecar golden-neutral vorziehbar).
- **S14 W12-B** (Stempel-Cache-Key cache_key_prefix + YAML GN_PREFIX + dll_is_current; Infra #56/#72-gated).
- **S15 GN-9-Bloat-Report** (1-Zellen-Lauf -> 6-TB-Feasibility-Gate VOR Voll-Matrix — gehoert VOR die 01.08.-Materialisierung!).

## G2 — Struktur-Straenge (Band-B/C/E, je eigenes Paket)
- **S10 STRANG-META**: ISA-Fork-A additiv + Meta-Meta-Achsen + Hardware-Manager-mp11-Array + Stempel-Fold-Erweiterbarkeit; Stufe 1+2 golden-neutral (Band-B-Slack-faehig), **Stufe 3 Alt-Ausbau = GO-gated ABI-Fenster** (Pflicht-Schluss).
- **S11 STRANG-SYSAXIS**: 7. System-Achse NUMA/Locking als RT-Unter-Achse unter target_isa (B8) + page_type-Anerkennung/Benennung (B10, §52-B10-aufgeloest); **N3/N4 = Band-A/B-faehig** (FF3-cache-awareness, binary_id-neutral, mess-validitaets-relevant!).
- **S12 STRANG-GATTUNG** (Band-E, LETZTER ABI-Schritt): S12.1 OrganConcept-Substrat -> S12.2 per-Genus 8-Schichten-Paritaet (Set/Sequence/Adapter/View) -> S12.3 Genus->Typ-ABI 2-Stufen-Fenster (Q4, user-gated).
- **#33 9dim-Dach-Rehang** + constexpr-Freigabe-Gate (Design-Fork SystemAxis<Derived,Kind> vs. 2 Uniter).
- **A7/#28 W8/§40.a Flag-Signatur-Modell** (Band-B hoch, koord. S10; Feinflag-Anreicherung => perm_suffix-Nachzug-Pflicht, sonst Sidecar-Drift).
- **234-V Shape-Materialisierung** (Option A per-Source-Emission + binary_id-Shape-Segment; User-GO liegt, Bau geparkt) + **S7-Serie S7-2..9** + Cross-Familie-Pruning (§13.10).
- **F2 native Set-ABI**; **F12iii Telemetrie-aus-binary_id** (= ABI-MAJOR-Bruch, NIE ins Abgabe-Fenster); **Telemetry-Profil-Verdrahtung** (wuerde +tel=silent an golden-build_version haengen = golden-brechend, eigene Absprache).

## G3 — Mess-Kampagne ab 01.08. (Band-C)
- **2^17-VOLL-Materialisierung** (real 524288 DLLs = 4 Perms x 2^17, ~24h/~224GB; Reife-Check 20.07.: NACH S6-Tooling-Scharfschaltung + Storage-Cache/Resume-Verifikation + GN-9-Bloat-Gate; Trigger COMDARE_BUILD_GOLDEN_N=true voll).
- **new-golden VOLL-MESSUNG** mehrtaegig/1-Thread (§33 = einziger legitimer Systembeweis; NIE pollen; Pipeline-286-Regime) + N-Paare (§52-B12).
- **F-SPREAD Max-Kontrast (#37, GO)** zur Kampagne.
- **S16 STRANG-AUSWERTUNG**: M-8 Sensitivitaet, M-9 4 Heuristik-Kurven-Writer, M-15/E2 Welch (eigene Stufe), PL-12 CEB-XML-Rueckschrieb.
- **PMC-Vertiefung** #152 Cache-Misses explizit, I-PMC-2 (L3+branch_misses), I-PMC-3/#187, #165 (daten-/hw-gated).
- **#156/#215/#162-HELD-Kette** (Voll-perm-Messlauf-Familie — durch new-golden-Regime abgeloest pruefen, sonst schliessen).

## G4 — Freigegebene Post-v3-Kern-Sequenz (User-GO 20.07., Tasks #34-37)
1. CLI-Haertung (R3) -> 2. Fork-A-.so-Schnitt (R1-Steuerung) -> 3. #19-Resolver + CoR -> 4. F-SPREAD. (Ledger §60-Nachtrag.)

## G5 — Cleanup/Bookkeeping/Migration (Band-D/Projektende)
- **S20**: §23.D variant-Insel-Triade DEPRECATED-Banner vervollstaendigen + test_abi_interface auf Achsen-Wahl; §32-F4-Rename; Gattungs-Docks PL-19/21.
- **Sofort-Hygiene (naechster Integrations-Pass)**: module_loader.hpp:36 Deprecation-Banner + 2 stale „ersetzt"-Kommentare (profile_run_facade.cpp:703, experiment_run_entry.hpp:102) auf PL-0-Stand.
- **S21 Bookkeeping-Sammelzeile**; **S22 B15 Modul-Migration A1/A5/A7** (je-Repo-GO, A5-Master-Loeschung = Remote-Loesch-GO-Pflicht).
- **§30 Sys/Mess-Achsen-Algorithmus-Join** (geparkt, niedrig).

## G6 — Infra/extern (deadline-unabhaengig bzw. Projektende)
- **Infra-Handover-Paket** #189/#199-210/#231/#272 (universelle Runner ISAxOS, k8s-deploy) — beim Infra-Agenten (Cluster-Handover 20.07. geschrieben; PAT-#327 dort).
- **Runner-Freeze #270b** (node7-rpi5-arm64); **G5/#274 measurement-all-Migration**; **sanitize-hart + TSan #204/#278**; **C2/GH200-ARM** (§8, Miet-Antrag laeuft!); **§13.9-A2 config-Owner-Gate** (blockt #266); **§44.6 Marker-SKIP-Livebeweis**.
- **STRANG-INFRA-END**: avx512-Ketten-Anschluss -> **#276 3-ISA-Teilmatrix als HARTE CI-Pflicht = AUSDRUECKLICH ALLERLETZTE Aufgabe** vor der STOP-Pruefung (User-Anordnung, nie supersediert).
- **STRANG-DEEP**: S-7 Deep-Research (Locking echt in Suchalgo+Container, Observer echt; OptiQL/ARTSynchronized) — nach Opus-Research (A13-Audit-Verdikt).

## G7 — Offene USER-Entscheidungen (gesammelt, nicht dringend)
- **F27**: welche experiment_golden.xml kanonisch (super-Master vs. ce-Kopie; Sync-Bridge gruen).
- **§26-USER-GO-Forks-Register-D Sammelfrage** (u.a. O-1 rm Mess-CSVs = KONFLIKT mit Messdaten-nie-loeschen -> Empfehlung ablehnen; E-2; weitere Forks).
- **E13** #37-3-Achsen deprecaten+Provenienz (Empf. Option 1); **E15** C2/GH200-§8-Zeile; **E16** Tilgungs-Tasks; **E14-Branch-Loesch-GOs** (je-Repo); **E11-B/C** (vertagt, User-OK); **#24/#25 User-Text** (User schreibt); **#225 Second-Execution** (nur Diskussion).

## Abgleich Task-Board
#34-37 (G4) + #28 (A7) + #33 (9dim) existieren; NEU: #38 (G1) #39 (G2-Rest) #40 (G3) #41 (G5) #42 (G6-Merkposten) #43 (G7-Sammelvorlage). Die Abgabe-Kette #15-#18 bleibt der kritische Pfad.
