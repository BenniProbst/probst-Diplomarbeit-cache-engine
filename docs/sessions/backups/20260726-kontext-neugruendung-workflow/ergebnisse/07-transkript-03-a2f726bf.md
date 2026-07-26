# TK_03 — Chronologische Extraktion (Chunk 3/30, Manager-Session Diplomarbeit, 07.–08.07.2026)

Umfang: 1703 Zeilen, vollständig gelesen. Beginnt mit Compact-Wiederaufnahme nach Übergabe 30, endet mitten im Wiedereinstieg nach Übergabe 32 (Ledger+Memory-Vollread-Bericht des Explore-Agenten). Zwei `/compact`-Schnitte innerhalb des Chunks (Z.100, Z.807/1508), zwei Modellwechsel (Fable 5 → Limit → Opus 4.8).

---

## (a) USER-DIREKTIVEN chronologisch (wörtlich wo bindend)

| # | Wortlaut / Kern | Bindung |
|---|---|---|
| D1 | „Bitte fahre mit offener Arbeit aus der letzten Session fort" (nach /compact mit Arg: „Bitte merke dir alle TODOs, den aktuellen Aufgabenbereich und Verlauf, sowie -stack und alle Learnings … Lies alle Memory vollständig ein und das gesamte ledger.") | Wiedereinstiegs-Pflichtprogramm |
| D2 | „Ok, aber wenn es main, master und development gibt, dann müssen diese ja auch konsolidiert werden." | Drei-Branch-Repos vollständig konsolidieren |
| D3 | **Matrix-Terminologie-Korrektur (bindend):** „Du sagtest gerade, dadd baseline_6 eine Familie wäre, aber in meinen Augen sind das Software Layer nach Matrix Struktur. Per definition referenzieren sie nur nach dem nächst-niedrigeren baseline. Es gibt umbrella, darunter baselines und darunter Module in einer multidimensionalen Matrix, eingeteilt in Modul Metaprogrammieurng und Product Interfaces" | Umbrella → Baseline(Layer, n→n-1) → Modul(Zelle) |
| D4 | **Fehler-Katch:** „Alle eben als leer beschriebenen repos sind nicht leer und haben hunderte commits nur auf development, sie müssen auf main gemerged werden" | Skript-Bug-Auslöser |
| D5 | „Bitte ziehe du github nach. github ist aufgrund der fehlenden Gruppenstruktur dort nur als Backup geeignet, es sei denn du kannst diese dort auch nahziehen - derzeit ist github unsortiert und flach." | GO für GitHub-FF comdare-db |
| D6 | **„Nein, dann ist github eine flache out of house Sicherung, mehr nicht, lass github dann strukturell so und wir verbleiben beim Fokus auf gitlab"** | Memory `feedback_github_flache_out_of_house_sicherung_fokus_gitlab` |
| D7 | „Die pipeline ist echt gescheitert, bitte behebe den Fehler auf der infra" | Infra-Auftrag 1 |
| D8 | **Naming-Regression:** „Bitte notiere auch das Wort ‚redcomponent' neben ‚bep' als Struktur Regression. Wir heißen jetzt als Marke Comdare und laufen unter der Firma ‚BEP Venture UG'" | Marke=Comdare; Firma bleibt in Rechtstexten |
| D9 | „Nun die letzte Regression könnte einen vollen Speicher bedeuten und jetzt kann ich die jobs nicht mehr auf gitlab anzeigen lassen" / „gitlab ist down, ich schätze oom . bitte untersuche das" | Infra-Auftrag 2 |
| D10 | „Wie weit ist der sweep" (3×, zunehmend ungeduldig) + „Wie lang ist die job queue?" | Fortschritts-Transparenz |
| D11 | **Struktur-Regression:** „zur Zeit der Entwicklung der ‚Klone' gab es nur Opus 4.1 und es war nie die Absicht clone zu erzeugen, weil ja jedes Projekt die bestehenden Module mit seinen eigenen separaten repos-Instanzmodulen anbieten muss. Das ist eine Struktur Regression, bitte notiere sie" | → Task #32 |
| D12 | „Ich gebe den schritt frei, GO" (Migrationsplan Schritt 3 metrics-Transfer) | Remote-GO |
| D13 | „Versuch es nochmal ansonsten behebe den Fehler autonom anstelle des infra Agenten" | Autonomie-Freigabe Infra (temporär) |
| D14 | **VLAN/SNI:** „Bitte lies in der cluster Dokumentation dazu die gesamte VLAN Tabelle und SNI als Standard pattern ein. Dann muss VLAN 16 per SNI auch auf VLAN 90 zugreifen können, weil das dev cluster minio hostet für gitlab. Das minio für production liegt auf VLAN 91" | Memory `reference_cluster_vlan_tabelle_sni_standard_pattern` |
| D15 | „Und es spricht minio über das development cluster?" | Kontrollfrage → Härtebeweis gefordert |
| D16 | Umbrella-SOLL: „Wir sehen jetzt, dass jeder Inhalt einer baseline mit seinen Modulen nicht gitignored ist, sondern falsch mit committet wurde… Jeder umbrella trackt alles außer die baseline Inhalte, die durch CMake hot dependenty frisch gecloned werden (später Buildsystem Automation)" | Memory Umbrella-SOLL |
| D17 | „Bitte dokumentiere alle offenen TODOs der gesamten Session ins Ledger und in den Sichtbaren TODO Bereich, bevor sie verloren gehen, die Regressionen häufen sich mittlerweile. Dann machen wir zuerst die Regestry fix und dann die Gruppenstruktur ordentlich" | Reihenfolge #33 → #34 |
| D18 | **Products-Regeln + GO:** „schaue ich jetzt in die products sind sie das äquivalent zu einem Umbrella der *-all Modules und dafür gelten die selben Regeln. Die Benennung eines neuen Instanziierungs-Modules eines Products ist in seiner Baseline einfach ‚comdare-db-fingerprints' etwa, wenn die comdare-db das Modul comdare-fingerprints verwendet… Produkte können multiple Baselines derselben Layer Stufe N aus verschiedenen Modul umbrella flach in ihrem eigenen umbrella anordnen. **Ich gebe das GO für ALLE Punkte 1,2,3**" | Sammel-GO 21 Zellen-Repos |
| D19 | **VOLL-GO:** „Wir haben alles nun perfekt geplant, ich gebe vollständiges GO für alle offenen TODOs im ledger und auf der sichtbaren TODO Liste, sowie die 4 aufgelisteten Punkte, bitte ziehe das autonom durch" | Autonomie-Modus |
| D20 | **Codex-Erstimpl.:** „Bitte merke dir für das Programmieren von Code, dass du die Erstimplementierung immer zuerst mit codex durchführst, bitte installiere das mcp plugin dafür, falls es noch fehlt." | Memory bekräftigt |
| D21 | **Codex-Migration:** „Bitte merke dir auch, dass codex auch gut in Code migration ist, solange man die Aufgaben- und Umgebungsbeschreibung elaboriert. Nutze es auch hier in erster Instanz dafür und kontrolliere und korrigiere danach manuell, **nachdem du selbst die Struktur vorbereitet hast**" | 3-Teilung: Struktur ich → Codex → Voll-Review |
| D22 | „Bitte konsolidiere alle Memories, die wir seit Anbeginn in dieser Abteilung gesammelt haben mit den gesicherten Memories aus der alten Abteilung und sichere diese ebenfalls als Backup von heute, falls wir wieder in die andere Abteilung wechseln sollten" | 3 Abteilungen + Backup |
| D23 | „Also solange der Kontext noch reicht, sieht bezüglich der fehlenden Pipelines Ruhm anders aus. 8797 und 8830 zeigen schon schwere Fehler" | User-Katch Artefakt-500 |
| D24 | „Bitte nenne mir das /goal das ich letztens gesetzt hatte im exakten Text (ohne Rechtschreibfehler)" → danach `/goal` neu gesetzt (bereinigte Fassung) | Goal-V3-Stop-Hook aktiv |
| D25 | „Bitte scanne den Gesamten session Verlauf, wo wir bezüglich der Verkettung von den letzten Fixes ursprünglich stehengeblieben waren und notiere die fehlenden TODOs… Wir mussten bald ein Dutzend Male Aufgaben weiter aufschieben" | → Aufschiebe-Audit, Tasks #41–#44 |
| D26 | „Der Kontext endet jetzt, bitte elaborate Kontextübergabe mit allen TODOs, aktueller Prozess und Direktiven" | → Übergabe 31 |
| D27 | „Bitte commit und push über alle repos die jetzt noch dreckig sind" | Dirty-Sweep |
| D28 | „…sichere zusätzlich das aktuelle ledger als Backup in die memory backups der Diplomarbeit, damit wir später mit Fable 5 das Diff bewerten können. Leider sind meine Aufgaben so komplex, dass es Opus 4.8 überfordern könnte, dennoch wollen wir mit Opus 4.8 fortfahren." | Ledger-Backup 20260708 |
| D29 | **Struktur-Korrektur:** „Bitte lies die Struktur im ledger nochmal genau nach. Es gibt auch server und client generische Module. Und korrigiere das handover" | HO-B-Irrtum |
| D30 | **NEUE DIREKTIVE:** „Bitte merke dir, dich zu jedem auftretenden goal hook gründlich einzulesen, um nie zu raten und immer zu verifizieren" | Memory `feedback_goal_hook_thorough_read_in_never_guess` |
| D31 | „Was ist extern blockiert?" | Blocker-Kategorisierung A–D |
| D32 | „Bitte lege eine Pause ein" (2×) | Pause schlägt Stop-Hook |
| D33 | **GROSSES GO:** „Ich gebe #27,#32,#29,#25 frei, GO. Aber bitte vorher gründlich einlesen. Infra macht der Infra Agent, hier bist du nicht gefragt. Ich gebe auch Punkt C komplett frei mit allen Aufgaben dort. Du bist der Implementierungsagent, also sind die Aufgaben #38,#14,#276 und #31 F7 + die #156/#215/#216-HELD-Kette alle deine." | Ziel-Freigabe |
| D34 | **Scope-Korrektur:** „Ich hatte den scope nicht geändert, nur die Ziele freigegeben" | Infra-Tasks bleiben pending (nicht completed) |
| D35 | „Bitte fahre mit offener Arbeit fort" / „Bitte fahre mit Arbeit aus der letzten Session fort" | hebt „Kontext endet" auf |

---

## (b) ARCHITEKTUR-/SCOPE-ENTSCHEIDUNGEN mit Begründung

1. **Matrix-Terminologie in Stein** (D3): Familie = `comdare-<x>` mit Umbrella `-all`; Baseline = Software-Layer, referenziert nur n→n-1; Modul = Zelle. Trennung generische Module (metaprogrammierungs-offener Source) vs. Product-Interfaces (binary-instanziiert). Begründung: Layering-Doktrin, keine Cross-Layer-Referenzen.
2. **GitHub = flache Out-of-House-Sicherung** (D6). Begründung des Assistenten (vom User bestätigt): GitHub kennt keine verschachtelten Namespaces, nur `Owner/Repo`; alle 3 Näherungen (Präfix-Konvention / Org je Familie / Topics) sind Kompromisse mit Massen-Renames. Struktur-Wahrheit = lokale Ordner-Matrix + GitLab-Gruppen.
3. **GitFlow-Fleet-Doktrin (Endzustand je Repo):** main = Default + protected + Vereinigung/neuester Stand; development ≥ main; master nur mit Beweis löschen (`compare(from=master,to=main)==0` SUBSET **oder** STALE `+Nc/0z`), immer vorher Backup-Ref `refs/backup/master-20260707` + verify-404; Konflikt/unrelated histories ⇒ behalten → später `archive/…`-Rename statt Löschung (verlustfrei).
4. **Dreistufige Konsolidierung** statt Einzellauf: Stufe 1 Voll-Lauf (main anlegen/default/protect, beweisgeführte master-Räumung) → Stufe 2 MR-Vereinigungsphase (dev→main bei veraltetem main; bei echtem master-Unique zusätzlich master→main und main→development zur Invarianten-Wiederherstellung) → Stufe 3 idempotenter Zweitlauf.
5. **Umbrella-SOLL** (D16): Umbrella trackt alles **außer** Baseline-Zellen-Inhalte (CMake-Hot-Dependency-Klone). `.gitignore` `/comdare-*/` (+ familienspezifisch, z.B. `*-wrapper/`, `/comdare-protocol-*/`), EXISTS-Slots im Aggregator.
6. **Products = Umbrella-Äquivalent** (D18): Gruppe + `<x>/<x>`-Umbrella; Instanziierungs-Benennung `comdare-db-fingerprints` (Produkt-Präfix + konsumiertes Modul); kopierte Baselines; multiple Baselines derselben Stufe N verschiedener Modul-Familien dürfen flach nebeneinander liegen.
7. **GitLab-Gruppen = Ordner-SOLL** (#34-Spiegelplan): Familien-Gruppe → Umbrella-Projekt + Baseline-**Untergruppen mit exakten Ordnernamen** → Zellen-Projekte; Tranchen A(encryption Muster) → B(15 Familien) → C(network-protocols) → D(Products) + H(db-Namens-Drift `baseline-2-core`→`comdare-baseline_2-core`, separate Hoheits-Abstimmung). Research + mirrors unangetastet. Mechanik: idempotent, 2s-Drossel, 500er-Backoff, Transfers triggern keine Pipelines, Redirects halten Klone funktionsfähig, Rollback = Rück-Transfer.
8. **VLAN/SNI-Standard-Pattern** (D14, bindend): Cross-VLAN **immer** über lokale `.1`-CARP-VIP (OPN-HAProxy TCP-SNI-Passthrough, 12 reboot-feste Regeln). V16 (prod-K8s/Pods, VIP 10.0.16.1) → SNI → V90 (dev-DB/dev-MinIO, hostet GitLab-Buckets). prod-MinIO auf V91 strikt separat via eigenem Hostnamen und eigener ACL. Fehler des Alt-Umbaus war der direkte Pod→V90-Eintrag **am SNI-Hop vorbei**.
9. **Codex-Kadenz 3-teilig** (D20/D21): (1) Claude bereitet Ziel-Struktur vor, (2) Codex als Erstinstanz aus elaboriertem Dossier (danger-full-access wg. bwrap/AppArmor, cwd-Pinning, gpt-5.5, reasoning xhigh, approval never, Tabus im Prompt), (3) Claude reviewt Zeile für Zeile + korrigiert manuell. Reine Konfig-/Kopier-Edits und Fehler-Korrekturen **ohne** Codex.
10. **Zellen-Norm:** INTERFACE-Target + `comdare::<ns>`-Alias, `include/comdare/<ns>/`, README mit Herkunft+SHA, LICENSE, ce-`.clang-format` (gegen LLVM-Default-Falle), **kein** buildsystem.xml (F1), gtest via lokalem Tarball in `prerequisites/`, schlanke Zellen-CI.
11. **#27 Option B statt axis_09b-Slot:** Kartierung bewies, dass „axis_09b" **kein** Composition-Slot ist (19-Achsen-Tupel hat nur `C::isa`) und SwissTable heute rein skalar ist (7b-3 = Neubau). Option B = SIMD-Gruppen-Match als static-Methode der ISA-Strategie über bestehenden `C::isa`-Slot; golden/ABI-neutral, weil die 16-Byte-Gruppe inhärent 128 bit ist.
12. **#29 additiv statt Umstrukturierung:** Container-Gattung ist **bereits vollständig gebaut** (Ebene 1 `AnatomyGattung::Container`; Ebene 2 Genus Adapter/Set/Sequence/View mit divergenten Achsen-Sätzen 13/15/11/7, alle 5/5 gebunden). AP-15-Plan („Typen unter Container") widerspricht dem Ist. Lösung: additiver `comdare::container`-Kopf-Framework-Header über die 4 Genus — Enum/Anatomien/golden unberührt; tiefe Genus→Typ-Umstrukturierung bleibt User-Gate (ABI/golden).
13. **#11/#266 evidenzbasiert aufgelöst:** P1 comdare-config **nicht** vendorn (0 echte ce-Konsumenten; die einzige Referenz `comdare::configuration_permutation` ist ce-intern; externes Modul = Runtime-Config-System ≠ ce compile-time-Bedarf), P3 memory nicht vendorn (Präzedenz 07.07.), P4 metrics gated bis #215. Kriterium: „erst Konsum-Bedarf, dann Zelle".
14. **Scope-Klarstellung** (D33/D34): Implementierungs-Agent = #27/#29/#25/#32/#38/#20/#13/#28/#31 F7/#14/#276/HELD-Kette #156/#215/#216. Infra-Agent = #21/#23/#36/#40 — diese bleiben **pending**, nicht completed.

---

## (c) PAKETMELDUNGEN / ABNAHMEN / COMMITS

**#274 Schritt 2 — Fleet-Branch-Konsolidierung (vollzogen):**
- Endstand literal: 297 Projekte = **286 konform · 6 Sichtungsfälle · 5 mirrors**, 0 Fehler. **240 master** beweisgeführt entfernt (je Backup-Ref + verify-404). **23 Vereinigungs-MRs** konfliktfrei (3× master→main, 20× development→main; ci-templates lag 42 Commits, client-lib 63 zurück).
- 6 Behalten-Fälle: foundation memory +854z / threading +1227z / concurrency +1489z / serialization +1668z (redcomponent-Alt-Initial, unrelated histories) + comdare-db storage +164z / filestorage +167z (echte Merge-Konflikte).
- Später **#35**: alle 6 verlustfrei nach `archive/…` archiviert → **Fleet 100 % master-frei**.
- GitHub-Parität comdare-db: FF `d5b6cb7..44aa7bc`.

**Ledger-Commit-Serie (super, jeweils beide Remotes):** `45fe443` → `77ea416` → `84a5371` → `4e83a65` → `46d9192` → `c36d5e0` → `0bd335a` → `2e540af` → `5214d11` → `583cd97` → `4378129` → `0a6ec18` → `34612c7` → `ac84f2e` → `2071703` → `bad9cf7` → `1cf72d3` → `7bbd94b` → `2b88a6a` → `7ab68d1` → `b651647`.

**Weitere Pakete:**
| Paket | Ergebnis / Belege |
|---|---|
| #33 Umbrella-Tracking-Bereinigung | Phase A: 21/21 Zellen als eigenständige Repos (13 neu, u.a. 8× `comdare-db-client-*`, `comdare-db-licensing` id 319, `comdare-tax`, 5 Sprach-Wrapper, `comdare-external-tests`, `steuerrater-b-core`, `web-core`); Phase B: 11 Umbrellas, 163 Index-Einträge entfernt (inkl. 59 Gitlinks network-protocols); Phase C Re-Audit **19/19 = 0 Voll-Inhalte, 0 Gitlinks, ignore=ja** |
| #34 Gruppenstruktur | Tranchen A–H: **66 Baseline-Untergruppen, ~160 Transfers**, 8 Namens-Drift-Renames, db-Angleichung 7/7; Verify 15/17 Familien nur-Umbrella, 311 Projekte konstant; origin-Nachzug **236/236** |
| #37 Registry | gesund verifiziert |
| Schritt 3 metrics | `comdare-metrics` (76) → `comdare/modules/comdare-measurement`; lokal nach `measurement-all/comdare-baseline_0-core/`; foundation-all `f0c2658`, measurement-all `ad8df1f` |
| Schritt 4 | Scratch-Kopie `Research/_ce-scratch-split-20260707` fixiert auf `d6d0744a` (195 MB, kein Remote) |
| Schritt 5 pmc | Projekt **320** (Untergruppe 430), main `26ee7dc5`; 4 Header 521 Z. faithful; ctest 4/4; CI **8854 = success** |
| Schritt 6 metrics+HDR (+#42) | `LatencyHdrHistogram` auf vendored HdrHistogram_c (CC0) + `latency_stats`; ctest **280/280**; CI **8880+8881 = success**; Commits `7e027d1`, `a7c5093` |
| Schritt 7 workloads | Projekt **321** (Untergruppe 432); 6/8 normalisierte Diffs leer; ctest 5/5; CI **8886+8887 = success** |
| #26 234-V-b [KERN] | ce `fd767073` + super `f535e0c`; CI **super 8899 + ce 8900 + ce 8898 = success**; Ledger `0e00f59` |
| #43 Handover-Dok | `docs/sessions/20260708-HANDOVER-foundation-db-buildsystem-owner-alt-ci-strukturbefunde.md`, 6 HO-Punkte; Commit `bad9cf7` (nach HO-B-Korrektur) |
| #44 prt-art-Sync | Research-Klon FF auf `faa4e76` |
| #29 Schritt 1 | `container_framework.hpp` + `test_29_container_framework.cpp`; ce `8ffc9c0c`, super `2b610aa`, Ledger `7ab68d1`; CI **super 8926 + ce 8924/8925 = success** |
| #27 7b-3 Option B | ce `9f60216f` (main+dev), super `94695b2`; ctest 4/4; CI beim Chunk-Ende: **ce 8934 (main) + 8935 (dev) = success**, super 8936/8940 noch running |
| Dirty-Sweep | network-protocols `4079995`, organization-all `588609c`, wrappers-all `2bb715a`, Scratch-README `6d1d496c` (lokal) |
| ci-templates | Runner-Retry `acd05ec`; cppcheck-Ignore v1 `ffd0af3` → v2 `0755b72` → v3 `2352bcf` |
| Übergaben | 31 = `0a6ec18` (`20260707-SESSION-UEBERGABE-31-voll-go-strecke-infra-fixes-schritt5-pmc.md`); 32 = `b651647` (`20260708-SESSION-UEBERGABE-32-opus48-goalv3-strecke-234vb-migration-container-swiss.md`); Spiegelplan `c36d5e0` |
| Memory-Konsolidierung | 76 Dateien identisch in 3 Abteilungen (`-home-comdare`, `-home-comdare-Projekte`, `-root`); Backups `~/.claude/memory-backups/20260707/` (3 Vorher-Stände + Konsolidat 106 KiB) und `20260708/` (Ledger-Snapshot `…-opus48-2071703.md` + Manifest, SHA256 verifiziert) |

**Grüne Beweis-Anker der Serie:** 8775-Retry, 8780, 8789, 8841, 8837, 8854, 8867/8868/8872, 8876, 8880/8881, 8886/8887, 8888, 8899/8900/8898, 8924/8925/8926, 8934/8935.

---

## (d) FEHLER + FIXES

1. **„Leere Repos"-Fehldeutung** (User-Katch D4): API-500-Störphasen wurden von `paginate()` als leere Liste interpretiert. Fix: `api()` mit 5xx/429-Backoff, `paginate()` liefert `None` bei Fehler, „leer" nur bei `empty_repo==true`. 25 Repos im Zweitlauf nachkonsolidiert; **nicht-destruktiv** (kein Repo verändert).
2. **Pipeline-Sturm (selbstverursacht):** ~500 Branch-Anlagen triggerten hunderte Alt-CI-Pipelines → GitLab-Überlast, leere Jobs-Ansicht. Cancel-Sweep gedrosselt (0,3 s): **64 aktiv gecancelt + ~163 bereits terminal**. Lehre bindend im Ledger: „Massen-Branch-Operationen künftig trigger-bewusst (ci.skip / Trigger-Verhalten vorher prüfen)".
3. **OOM-Verdacht (D9) widerlegt:** Prometheus-Evidenz 0 Restarts/4h, 0 OOMKilled, webservice ~48 %/sidekiq ~20 % der Limits, Nodes 31–45 % frei. Ursache = Lastüberlastung, nicht Speicher.
4. **Transiente TLS-/API-Abbrüche (D7):** GnuTLS -110 beim Runner-Fetch, RemoteDisconnected — nur in Lastphasen, danach 40/40 sauber. Struktureller Fix: Runner-Retry-Variablen `GET_SOURCES/ARTIFACT_DOWNLOAD/RESTORE_CACHE/EXECUTOR_JOB_SECTION_ATTEMPTS = 3` (`acd05ec`, fleet-weit).
5. **Transfer-HTTP-500 (5× reproduziert):** Request-Id → webservice-Log `Faraday::TimeoutError` beim Registry-Tag-Check → Registry-Log „S3: retrying … context canceled" → **CoreDNS-Host-Override zeigte auf die tote V90-LB-IP `10.0.90.224`**, aus Pods per VLAN-Isolation unerreichbar (Fehleinbau vor ~9 Tagen). Registry war **9 Tage ohne Storage**. Fix: Override → `10.0.16.1` (Backup der ConfigMap doppelt), CoreDNS-Reload, Registry-Rolling-Restart → Transfer **200**. Zwischenverdacht „registry.gitlab.svc" war ein grep-Fragment-Artefakt (Lehre: `grep -o` matcht mitten im Wort).
6. **Folgefehler Artefakt-Upload-500** (User-Katch D23): `:9000`-Endpoint des Object-Stores lebte nur auf der toten Alt-LB; der CoreDNS-Fix heilte `:443`, brach `:9000` (`SSL wrong version number` in Rails-Exception). Fix: `gitlab-object-storage`-Secret auf SNI-443-Hostnamen; Rollout-Stau (Pod exit 137 + Pending durch required-Anti-Affinity 4-auf-4) durch gezieltes Räumen der Alt-Pods gelöst. Beweis: TLS-SANs `*.databases.svc.cluster.local` = dev-Cluster-MinIO; E2E 8837/8841. **Lehre: beim VIP-Umbiegen ALLE Port-Pfade des Namens prüfen (:443 ≠ :9000).**
7. **cppcheck-Template-Saga (3-stufig):** `-i modules` matchte per Substring auch den **absoluten Workspace-Pfad** → unter `comdare/modules/…` wurde alles ignoriert (pmc 8849) → v1 `./`-Anker (`ffd0af3`) → `.citools`-Selbst-Scan (8851) → hartes `-i ./.citools` (`0755b72`) → super 8856 rot (nested `Code/external`-Abdeckung verloren, 1775 Vendor-Findings) → **v3 find-Expansion nackter Namen auf real existierende Verzeichnisse** (`2352bcf`).
8. **v3-Push-Leerlauf:** Shell startete im falschen cwd („Shell cwd was reset") → FileNotFoundError, Commit/Push liefen nie, die „Beweis"-Pipelines testeten das ALTE Template. Fix: Wiederholung mit explizitem absolutem Pfad. **Lehre: nach cwd-Reset Pfade absolut.**
9. **Format-Falle:** Zelle ohne `.clang-format` prüfte gegen LLVM-Default → ce-`.clang-format` kopieren.
10. **Listen-Extrapolation:** 9. licensing-Zelle „sql" existierte nicht; korrekt war `comdare-baseline_1-integration/comdare-db-licensing`. **Lehre: gekappte Audit-Listen nie extrapolieren.**
11. **HO-B-Struktur-Irrtum** (User-Katch D29): Behauptung „`comdare-db-client-*` in licensing-all fehlplatziert" war falsch — licensing-README führt sie explizit als „Base client modules"; Umbrella-SOLL nennt licensing als kanonisches `client/`+`server/`-Beispiel. Korrektur in Handover-Text+Tabelle, Ledger und Tasks #38/#43 **vor** dem Commit. → Auslöser für Direktive D30.
12. **Scope-Über-Interpretation** (User-Katch D34): Infra-Tasks #21/#23/#40/#36 nach dem GO als „completed" markiert. Fix: zurück auf pending, Label „[Infra-Agent-Domäne, nicht meine]".
13. **#27 Codex-Scope-Creep:** Codex änderte 5 **unautorisierte** Dateien für „0 Warnungen" — `abi_adapter.hpp` (ABI-Kern, `SearchAlgo`→`LocalSearchAlgo` gegen -Wshadow), 2× axis_08, 3 Bestandstests (dangling-else-Klammern). Alle per `git checkout --` revertiert; nur der 13-Datei-#27-Kern blieb. Golden-kritischer `SwissTableOrgan`-Default-Alias unverändert; SIMD opt-in via `SwissTableOrganSimd<Isa>`.
14. **234-V-b Warn-Suppression:** Codex wickelte den Umbrella-Include in `-Wshadow`/`-Wunused-but-set-variable`-Pragmas. Empirisch widerlegt: 234-V-a (CI-grün) erzeugt **exakt dieselben 5 Warnungen** aus `cmake/compiler_flags.cmake:25` — vorbestehender Engine-Lärm, CI gatet ihn nicht. Suppression entfernt.
15. **Codex-MCP Verbindungsabbruch** (Schritt 7): Baum-Check zeigte keine halben Edits → identisches Dossier erneut gefahren.
16. **Commit-Message-Quoting:** Anführungszeichen brachen die Shell → `git commit -F <messagefile>`.
17. **Monitor-Hänger (Sweep-CI):** 3 Umbrella-Pipelines >1,9 h — Befund: sie nutzen die **alte v7.0.x-66-Job-Alt-Matrix** (riscv/macos/windows-docker auf nicht-existenten Runnern) = vorbestehender **#38/HO-A-Defekt**, nicht durch die `.gitignore`-Edits verursacht. Monitor beendet, Evidenz in #43/#38 protokolliert, bewusst **kein** Ad-hoc-Fix (Flickenteppich).
18. **prod2 hart down** („No route to host", samt Windows-Runner-VMs) — remote nicht heilbar → #36 physisch. Cluster-Key „error in libcrypto" → CRLF-Bereinigung.
19. **comdare-db-Dirtiness fehlcharakterisiert** (Selbstkorrektur): keine uncommittete Fremdarbeit — Leaf-Repos sauber, `ahead=0`, gepusht („ci: deploy v7.0.3 — S2671"); dirty war nur der Umbrella-Submodul-Pin-Bump = koordinierter Owner-Rollout in der #33/#43-Handover-Zone. Pins **nicht** gebumpt.
20. **Pipeline-Statusrätsel:** 8775 „failed" trotz 13/13 grüner Jobs → Fehler kam aus einer Kind-Bridge; Bridge-Retry + Status-Recalc-Anomalie dokumentiert. `?sha=`-API matcht keine Präfixe → immer volle SHAs/Pipeline-IDs.

---

## (e) OFFENE FÄDEN AM CHUNK-ENDE

**In-Flight (unmittelbarer Prüfpunkt):**
- **#27-CI:** ce `9f60216f` **8934 (main) + 8935 (development) = success** ✅; **super 8936 (`94695b2`) + 8940 (`b651647`) noch running** — warten auf getriggerte ce-Downstreams 8937/8942 (Umbrella→Zelle, kein Stuck; thesis+prt-art-Downstreams grün). `build:clang` steht auf `created` und ist per §14.8 **manual+advisory**, blockt also nicht. Background-Monitor armiert. Ledger-Grün-Nachtrag ausstehend.
- **#25-Vorbereitung läuft:** Kartierungs-Agent (Datensatz-Landschaft) + Explore-Agent (Ledger+Memories) angestoßen; Explore-Bericht bereits eingetroffen (letzte Zeilen des Chunks).

**#25 Datensatz-Akten — tragende ungelöste Frage:** 6er-Kanon-Akten-Format verstanden (5-Feld-Manifest `id/source_path/checksum=fnv1a64/line_count/preprocessing`; 3 Bestands-Specs in `Code/test_data_xml/`: sosd_books_200M, pizzachili_dna, english_words). **Diskrepanz:** README-Plan (CoCo-Trie, it-2004.urls, SOSD osm/fb/wiki_ts) vs. W5-Liste (url/protein/xml/tpcds-id/trec-terms) — muss gegen die kanonische Thesis-`tab:datasets` aufgelöst werden (**G-6v48 offen**). `DATASETS_SCHEMA.md:40` verweist noch auf den gestrichenen „Termin 7"-Katalog = STALE. Korpora url/protein/trec-terms lokal vorhanden; tpcds-id/xml unklar. **Prüfsummen-Fabrikation verboten.**

**GO'd, aber nicht erledigt (alle beim Implementierungs-Agenten):**
- **#29 Rest:** (a) tiefe Genus→Typ-Umstrukturierung nur mit ABI/golden-GO; (b) AP-15 (2) Sequence-Planungsdoc + (3) weitere std-Container-Typen.
- **#32** Struktur-Regression: Instanz-Repos, config-Duplikat 155/156, Naming-Sweep redcomponent/bep→Comdare (**„BEP Venture UG" in Rechtstexten erhalten**); Remote-Ops je Repo.
- **#38** Alt-Matrix-CI fleet-weit auf schlanke Zellen-CI umstellen (metrics-Muster, HO-A) — bleibt zugleich Owner-Aufgabe.
- **Punkt C:** #20 gcc-15.3-Pin (Code/CI-Teil; Installation=Infra) · #13 3-ISA-arm64 (node7) · #28 P/E-Core-Auto.
- **#31 F7** Mess-Frameworks × Workloads-Matrix.
- **#156/#215/#216-HELD-Kette** (golden-320-Neubau) — **sensibelster Strang, nur mit frischem Kontext + Voll-Review**.
- **#14/#276** Voll-Plattform-Matrix — **ausdrücklich zuletzt**.

**Nicht meins (Infra-Agent, offen):** #21 Runner-Cache→dev-MinIO · #23 K87b · #36 prod2 physisch (halbe Baremetal-Kapazität fehlt) · #40 root-master-Token-**Rotation (dringend)** + CARP-vhid-91-Split-Brain.

**Noch echt offene Gates (§14.1):** G-6v48 (6 vs. 48 Datensätze) · G-270a P/E-Core-Auto · G-AP15 Set/Sequence-Gattungs-Folge · G-274 Migrationsschritte **8–15 gated** · G-268 künftiger ABI-Bump (hartes Tabu). Stale/gegenstandslos: G-Q2, G-234V-a/b, G-7b3.

**§13.10-Lücken (leicht zu übersehen):** 234-V-Materialisierung · Baum-Pruning ohne Cross-Familie-Constraint · S7-Serienplan „9 vs. 10 Familien" · L-Semantik-Doku fehlt autoritativ · 7b-3-Kopplungs-Mechanismus · ungesichtete Quellen Doc 29/Thesis-S7 · m3v2-Artefakt-Neu-Build · PRT-ART „3 Hauptmessmethoden" · „4 Schichten" nicht user-fixiert.

**Meta-Zustand am Chunk-Ende:** Goal-V3-Stop-Hook aktiv und feuerte ~12× erfolglos (Kritikpunkte: ~14 pending Tasks; „Goal-V3 nie als Ganzes gelesen"). Der Assistent hat **Goal-V3 §13.12 (Z.497–537) daraufhin vollständig wörtlich gelesen** (KONTEXT-PFLICHT, ARBEITSREIHENFOLGE (1)–(7), ENTSCHEIDUNGS-DEFAULTS E-A..E-E/CMD-2, KADENZ 1–13, HARTE TABUS, ESKALATION, STOP-BEDINGUNG, Matrix-Goal-Ergänzung mit 5 Voll-Pfaden, 7 BLOCKER, 27 Geschlossene). Endstände: super `b651647`, ce `9f60216f` (main+development), prt-art `faa4e76`; alle Arbeitsbäume sauber. Die im Ledger notierte STOP-BEDINGUNG (nur noch gated/HELD → Handover schreiben, sauber stoppen) kollidiert wiederholt mit der Hook-Formulierung „alle sichtbaren TODOs".