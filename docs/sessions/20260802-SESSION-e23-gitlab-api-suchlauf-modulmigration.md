# E-23 GITLAB-API-VOLL-INVENTAR VOR MODUL-MIGRATION (+E-25 Scan-only) — Stand 2026-08-02

> Paket A16-P4 (BAUPLAN 20260802 Sec.1). Auftrag: Owner-ANKER:109-114 ("erst gitlab fuer die Modulmigration durchsuchen ... arbeite auch hier autonom per API") + ANKER:119-121 (E-25 im SELBEN Lauf). Lauf war STRIKT READ-ONLY: ausschliesslich HTTP GET, keine Write-API, keine Repo-Edits, keine Migration. Die Migration selbst bleibt Projektende (LEDGER G5/#274).
> **E-25-ETIKETT (bindend, Design-Auflage MINOR):** Abschnitt 4 dieses Berichts ist **Scan-only; die E-25-UMSETZUNG bleibt nach Abgabe per R7**. Der Scan JETZT ist durch ANKER:121 gedeckt, die Umsetzung ausdruecklich nicht.

## 0. BETRIEB + PAT-DOKTRIN (Vollzug belegt)
- Blind-Extraktion `grep -hoE 'glpat-[A-Za-z0-9._-]{15,}'` ueber CREDENTIALS-VAULT-DEV.md + CREDENTIALS-VAULT-PROD.md -> **7 Kandidaten** (dedupliziert).
- Rueckwaerts-Test gegen `GET /api/v4/user` bis HTTP 200. Treffer bei **Position 1 von hinten** (Rotation dieses Tages; Position NIE hartcodieren — 26.07. war 2. von hinten, 27.07. mittag 3. von hinten).
- Token wurde nie ausgegeben, nie geloggt, nie in ein Argument geschrieben: ausschliesslich `-K <0600-curl-config>`; CA per `--cacert /home/comdare/Projekte/Cluster/keys/gitlab-ca-ROOTCA-20260621.crt`.
- Config nach Abschluss `shred -u`; Verifikation: `ls: cannot access 'curlrc': No such file or directory`; Sekundaerscan der eigenen Artefakte: **0 Token-Treffer**.
- Scope-Verifikation des Tokens (Nie-raten-Doktrin, gegen die Design-Risiko-8-Falle): `username= root id= 1 is_admin= True state= active` -> Instanz-weiter Lesezugriff, das Inventar ist NICHT durch Sichtbarkeits-Beschraenkung verkuerzt.
- Host: gitlab.comdare.local (kanonisch; .de abgeschaltet), aufgeloest 10.0.10.1.

## 1. S5-PFLICHTFELD: PLAUSIBILITAETS-ANKER (leeres Inventar ausgeschlossen)
Das Design nennt das leere/verkuerzte Inventar als gefaehrlichstes Ergebnis (Risiko 8). Deshalb zuerst die Zaehlwerke, jeweils literal aus HTTP-Response-Headern bzw. Voll-Paginierung:

| Groesse | Wert | Quelle |
|---|---|---|
| **PROJEKT-GESAMTZAHL (inkl. archiviert)** | **390** | `x-total: 390` auf `/projects?per_page=1` |
| Projekte nicht-archiviert | 385 | `x-total: 385` auf `/projects?archived=false` |
| Projekte archiviert | 5 | Differenz, einzeln belegt (Abschnitt 5) |
| **GRUPPEN-GESAMTZAHL** | **109** | `x-total: 109` auf `/groups?all_available=true` |
| Top-Level-Gruppen | 2 | `comdare` (id 3, private), `mirrors` (id 314, public) |
| Projekte ueber `/groups/:id/projects` eingesammelt | 386 | Voll-Paginierung ueber alle 109 Gruppen |
| Projekte in User-Namespaces (keiner Gruppe) | 4 | alle unter `root/` (Infra-Piloten) |

**Gegenprobe (Kreuz-Validierung):** 386 (gruppen-getragen) + 4 (User-Namespace) = **390** = Gesamtzahl. Menge "nur ueber Gruppen, nicht global" = **leer**. Damit ist die Vollstaendigkeit des Inventars zweifach abgesichert; die Auflage "GET /groups (ALLE sichtbaren, Pagination, per_page=100) je Gruppe /groups/:id/projects — nicht nur search=comdare" ist erfuellt (die Suchwort-Variante haette `mirrors/*` und die 4 `root/*` verloren).

**Verteilung (Top-2-Namespace-Ebenen, Summe 390):**
comdare/modules 211 | comdare/products 135 | comdare/research 26 | mirrors 8 | comdare/infrastructure 3 | comdare/cluster 2 | root (User) 4 | comdare/projekte 1.

## 2. S1 — GRUPPEN-VOLLINVENTAR (Struktur-Ist)
- `comdare/modules` traegt **17 Familien** mit zusammen 211 Projekten. **16 davon haben ein Umbrella-Projekt `comdare-<familie>-all`; genau eine nicht: `comdare-cacheengine`** — konsistent zum A7-Namensverbot "comdare-cacheengine-all" (LEDGER 2026-07-07 Antwort B).
- Familien (Projektzahl): network-protocols 77 | encryption 22 | foundation 19 | client 18 | licensing 12 | storage 9 | wrappers 8 | archiving 6 | cacheengine 6 | core 6 | organization 6 | binary-analytics 5 | filestorage 4 | measurement 4 | treecore 4 | external 3 | config 2.
- `comdare/products` (135) bildet die Product-Matrix ab (comdare-db, cd-buildsystem-construct, comdare-web, comdare-steuerrater-a/-b) — Instanzen, keine Spiegel (siehe Abschnitt 5).
- `comdare/research` (26) traegt die vier Diplom-Repos: `probst-diplomarbeit-cache-engine` (288, default **development**), `comdare-cache-engine` (286), `comdare-prt-art` (287), `20260931-overleaf-diplomarbeit` (289) — Querbezug zu A16-P3 (Vier-Ledger).
- `comdare/infrastructure` (3: buildtools 268, ci-smoke 284, builder-images 430), `comdare/cluster` (2: ci-templates 269, comdare-cluster-development 290).
- **0 Projekte ohne default_branch** — es gibt keine leeren/uninitialisierten Karteileichen.

## 3. S2 — MESS-FAMILIE IST vs. SOLL-ZELLEN baseline_0..3 (Tree + README, clientseitiger Depth-Filter)
Gruppe `comdare/modules/comdare-measurement` = id **353**; Untergruppen: `comdare-baseline_0-core` (411), `comdare-baseline_1-instrumentation` (430), `comdare-baseline_2-workloads` (432).

| Soll-Zelle (LEDGER G5) | Ist auf GitLab | Projekt-ID | Befund |
|---|---|---|---|
| baseline_0-core | `.../comdare-baseline_0-core/comdare-metrics` | 76 | EXISTIERT, Transfer #274 Schritt 3 vollzogen |
| baseline_1-instrumentation | `.../comdare-baseline_1-instrumentation/comdare-pmc` | 320 | EXISTIERT, Schritt 5 vollzogen |
| baseline_2-workloads | `.../comdare-baseline_2-workloads/comdare-workloads` | 321 | EXISTIERT, Schritt 7 vollzogen |
| baseline_3-analysis | **existiert nicht** (0 Gruppen mit 'analysis' im full_path) | — | KONFORM zur A-Regel "leere Baseline => kein Ordner", NICHT ein Defekt (LEDGER 07.07.); Anlage = erster Increment aus F4=A |
| Umbrella | `.../comdare-measurement-all` | 300 | EXISTIERT |

**Damit ist die Prueffrage beantwortet: die Struktur-Migration der Mess-Familie ist NICHT halb-fertig liegengeblieben; 3 von 3 befuellbaren Zellen sind angelegt und befuellt.** Es gibt keinen zweiten, konkurrierenden Mess-Baum auf GitLab (`comdare-measurement` unter cacheengine ist ein Tombstone, Abschnitt 5).

### DELTAS (D-1 bis D-5) — vor Migrations-Start zu bereinigen
- **D-1 (bestaetigt, unveraendert offen): Umbrella-README.md:7 ist STALE.** Literal heute: `- 0-core: Mess-Kern: comdare-metrics -- Transfer folgt in #274 Schritt 3.` Der Transfer IST vollzogen (Projekt 76 liegt unter comdare-baseline_0-core). Zeilen 8 und 9 tragen dieselbe Zukunfts-Form ("Schritt 5", "Schritt 7"). Die G5-Dossier-Feststellung von 2026-07-13 gilt am Ist-Stand 2026-08-02 unveraendert; der als erster Increment vorgesehene README-Fix (F0=A) ist noch nicht gelaufen. Zeile 11 (b3-analysis "VORGESEHEN, erst bei echter Befuellung") ist dagegen korrekt und deckt den Ist.
- **D-2 Branch-Doktrin-Drift:** Alle vier Mess-Projekte haben `main` als Default, obwohl LEDGER-Schritt-0 fuer das Umbrella `default-branch development` protokolliert und die GOALV2-Zellen-Konvention (Q5) `development` verlangt. Ein `development`-Branch existiert ueberall, ist aber nirgends Default. `comdare-metrics` (76) traegt zusaetzlich einen Alt-Branch `master`.
- **D-3 (MIGRATIONS-BLOCKER) Divergenz in comdare-metrics (76):** `development` = f7cd5b9c vom **2026-07-19** (`Merge remote-tracking branch 'refs/remotes/github/development'`), `main` = a7c50932 vom **2026-07-07**. Der Default-Branch ist also **12 Tage aelter** als der Arbeits-Branch. Jeder Migrations-/Konsum-Schritt, der (API-typisch) den Default liest, zieht den ALTEN Stand. Umgekehrt beim Umbrella (300): `main` 2026-07-26 ist NEUER als `development` 2026-07-12. Die Branch-Topologie der Familie ist damit uneinheitlich UND in beide Richtungen divergent. **Vor jeder Migration zu entscheiden und zu vereinheitlichen.**
- **D-4 Konventions-Verstoss in der Zelle b0-core:** `comdare-metrics` (76) traegt auf Tiefe 0 eine **`buildsystem.xml`** sowie ein `vendor/`-Verzeichnis. Das G5-Dossier Sec.5 fuehrt "Kein buildsystem.xml in Zellen" als TABU, und das Umbrella-README:19 delegiert buildsystem.xml ausdruecklich an den Buildsystem-Agenten (F1). Die beiden anderen Zellen (320, 321) tragen korrekt keine.
- **D-5 Konventions-Luecke in b1-instrumentation:** `comdare-pmc` (320) hat **kein `cmake/`-Verzeichnis** und damit keine `comdare-pmcConfig.cmake.in`, waehrend 76 (`cmake/comdare-metricsConfig.cmake.in`) und 321 (`cmake/comdare-workloadsConfig.cmake.in`) die Zellen-Norm (INTERFACE + `comdare::`-Alias + Config-Paket) erfuellen. Zusaetzlich fuehrt 320 nur `sessions/.gitkeep` (kein Provenienz-Doc), 321 gar kein `sessions/`.
- **S2-Erhebungs-Hinweis (Review-Auflage):** Der Tree-Scan lief auf dem jeweiligen `default_branch`; fuer Projekt 76 ist das per D-3 der 12 Tage ALTE Stand. D-4/D-5 wurden deshalb auf `development` GEGENGEPRUEFT und halten auf BEIDEN Staenden (Belege `e23-review/tree_dev_76.json` + `tree_dev_320.json`).
- **Abgrenzung (Glob-Deckung):** Das Suchmuster 'JEDES Projekt unter *measurement*' matcht zusaetzlich `comdare/modules/comdare-network-protocols/comdare-baseline_5-interfaces/comdare-network-protocol-administrative-measurement` (id 135). Es wurde BEWUSST nicht als Mess-Zelle gescannt: das Umbrella-README:15 verweist Transport-Messung explizit zu network-protocols Stufe 5 ('NICHT hierher') — dokumentierte Abgrenzung, kein vergessener Mess-Baum.
- Struktur-Bestaetigung ohne Befund: der Umbrella-Tree traegt in den drei Baseline-Ordnern nur `.gitkeep` (die Zell-Inhalte liegen als eigene GitLab-Projekte daneben) — korrekt gemaess dem GitLab-Constraint "Projekte nicht unter Projekten".

## 4. S3 — E-25-SCAN (SCAN-ONLY; Umsetzung nach Abgabe per R7)
Gesucht wurde ueber das VOLLE S1-Inventar (390 Projekte: Pfad + Name + Beschreibung), nicht nur ueber Namensteile.

- **CLIENT: generische Modul-Familie EXISTIERT.** `comdare/modules/comdare-client` (Gruppe 25) mit 18 Projekten: Umbrella `comdare-client-all` (11), `baseline_0-foundation/comdare-client-lib` (31), `baseline_2-core/comdare-client-capi` (32), `baseline_3-protocols` mit 14 Protokoll-Clients (ftp, nfs, smb, sftp, webdav, sql, kafka, ldap, smtp, postgres, iscsi, hadoop, objectstorage, filestorage), `baseline_4-integration/comdare-client-bundle` (44). Dazu `comdare-foundation/baseline_1-core/comdare-client-basics` (74). *Nebenbefund:* der Familie fehlt eine `baseline_1`-Stufe (Nummern-Folge 0,2,3,4) — dokumentarisch, kein Defekt.
- **SERVER: KEINE generische Server-Modul-Familie.** Nur drei domaenen-gebundene Treffer: `comdare-licensing/baseline_2-server/comdare-licensing-server` (80) sowie produktseitig `cd-buildsystem-licensing-server` (255) und `comdare-db-licensing-server` (277).
  **=> Owner-Aussage E-25 ("Es gibt auch server und client generische Module") ist am Ist HALB bestaetigt: client = ja (vollstaendige generische Familie), server = nein (nur Lizenz-Server-Zellen).** Das ist die praezise Reuse-Landschaft; die Doppel-Eigenbau-Gefahr besteht damit fuer Client-Funktionalitaet real, fuer Server-Funktionalitaet gibt es schlicht nichts Generisches wiederzuverwenden.
- **ACTIVEMACHINERY: 1 Treffer** — `comdare/products/cd-buildsystem-construct/layer0-hardware-provisioning/cd-buildsystem-active-machinery` (198). **Falle dokumentiert:** das Projekt heisst `active-machinery` MIT Bindestrich; eine Suche nach dem Owner-Wort "activemachinery" ohne Bindestrich liefert 0 Treffer und haette faelschlich "existiert nicht" ergeben.
- **TEST-SYSTEM: 3 Treffer** — `comdare/modules/comdare-cacheengine/comdare-test-system` (298, siehe Sperrliste), `cd-buildsystem-test-system` (212, aktiv) und (544, ARCHIVIERT 2026-07-28, dedupliziert).
- **AGENT: 0 Treffer.**

## 5. S4 — PSEUDO-SPIEGEL-SPERRLISTE (NICHT-Migrationsziele)
**Hauptbefund (neu und relevant):** Die sechs Pseudo-Spiegel aus #12 (LEDGER 2026-07-04: "die 6 GitHub-only Sub-Submodule unter cache-engine/modules/ ... waren 0/6 legit ... alle 6 GitHub-Remotes geloescht") existieren **auf GitLab unveraendert weiter** — als Gruppe `comdare/modules/comdare-cacheengine` (id 344) mit exakt denselben sechs Namen:

| Projekt | ID | letzte Aktivitaet | Tombstone im README? |
|---|---|---|---|
| comdare/modules/comdare-cacheengine/comdare-build-tools | 293 | 2026-07-07 | **nein** |
| comdare/modules/comdare-cacheengine/comdare-cache-engine-core | 294 | 2026-07-07 | **nein** |
| comdare/modules/comdare-cacheengine/comdare-isa-dispatch | 295 | 2026-07-07 | **nein** |
| comdare/modules/comdare-cacheengine/comdare-measurement | 296 | 2026-07-19 | **ja** (ARCHIV/TOMBSTONE 2026-07-11) |
| comdare/modules/comdare-cacheengine/comdare-search-engine | 297 | 2026-07-07 | **nein** |
| comdare/modules/comdare-cacheengine/comdare-test-system | 298 | 2026-07-07 | **nein** |

- **SPERRE: alle sechs sind NICHT-Migrationsziel.** Die Loeschung von 2026-07-04 betraf nur die GitHub-Seite; die GitLab-Zwillinge blieben stehen. Genau hier haette eine Modul-Migration "nach vorhandener Struktur" die Pseudo-Spiegel-Falle wiederholt.
- 296 traegt bereits den korrekten Tombstone-Kopf und verweist auf die produktiven Zellen (300/76/320/321). **Fuenf von sechs (293/294/295/297/298) tragen KEIN Sperr-Etikett** — empfohlene Folgemassnahme (additiv, doku-only, Doku wird nie geloescht): denselben Tombstone-Kopf nachziehen. **Kein Loeschen** (Remote-Loeschung nur mit explizitem Owner-GO).
- **Zweite Sperrgruppe (neu gefunden):** 5 archivierte Dedup-Zwillinge unter `comdare/products/cd-buildsystem-construct/layer1-foundation` — `cd-buildsystem-logging` (541), `-process-management` (542), `-scheduling-manager` (543), `-test-system` (544), `-licensing-all` (545), jeweils mit Beschreibung "ARCHIVIERT 2026-07-28: dedupliziert nach layer2-abstraction/... (Owner-Regel Zell-Eindeutigkeit)". Ebenfalls NICHT-Migrationsziel; hier ist die Etikettierung bereits sauber.
- **AUSDRUECKLICH KEINE Pseudo-Spiegel (Abgrenzung, damit kein Audit sie faelschlich sperrt):**
  (a) `mirrors/*` (8): benchmark, googletest, nlohmann-json, openxlsx, containerdisks sowie drogon/trantor/jsoncpp (Vendoring-Doktrin, OF-8-Entscheid 11.07. / F15) — legitime Upstream-Mirrors.
  (b) 13 Namens-Doppelungen zwischen `modules` und `products` (comdare-memory, -platform, -simd, -threading, -concurrency, -serialization, -storage, -treecore, -filestorage, -filestorage-api, -objectstorage, -db-licensing, -config) — das ist die Product-Matrix per Doktrin (Products = binaere Instanzen der Module), kein Spiegel.
  (c) **Ausnahme mit offenem Punkt:** `comdare-config` existiert **dreifach** — `modules/comdare-config/baseline_1-core/comdare-config` (155), `modules/comdare-foundation/baseline_1-core/comdare-config` (156) und produktseitig (comdare-db b4). Die beiden MODULES-Adressen sind eine echte Doppel-Zelle und die noch offene G-Q2-Frage "config-Owner: foundation-b1 vs. config-all" (LEDGER-Empfehlung: config-all). Vor einer Migration, die config beruehrt, zu entscheiden.

## 6. S5 — REPO->ZELLE-MAPPING JE G5-FORK F0-F5 = A
Owner-Freigabe: "Ich gebe alle offenen Punkten wie empfohlen frei" = **F0=A, F1=A, F2=A, F3=A, F4=A, F5=A** (ANKER:109-114). Bedeutung: F0=A G5a-Extraktion der 0X-Analyse-Generika + ce-WIE-Rest; F1=A belang-genau (nur ce-freie Generika); F2=A source-only INTERFACE; F3=A bottom-up; F4=A baseline_3-analysis JETZT mit erstem Inhalt anlegen; F5=A eigene Research-Instanziierungs-Zelle.

| Quelle (lokal) | Ziel-Zelle (GitLab) | Ist heute | Fork-Bezug |
|---|---|---|---|
| ce metrics-Generika (Observer/Counter/Gauge/Histogram/HDR) | comdare-measurement/baseline_0-core/comdare-metrics (76) | ANGELEGT + BEFUELLT | F2=A erfuellt (INTERFACE-Zelle) |
| ce pmc_source / linux_perf / windows_pcm | baseline_1-instrumentation/comdare-pmc (320) | ANGELEGT + BEFUELLT | F2=A; D-5 offen (Config-Paket fehlt) |
| ce workload_config / generator / dataset | baseline_2-workloads/comdare-workloads (321) | ANGELEGT + BEFUELLT | F2=A erfuellt |
| **super Code/09_tex_formatter (M09, ce-frei — kanten-aermster Kandidat)** | **baseline_3-analysis/<neu>** | **ZIEL FEHLT** | **F3=A + F4=A: ERSTER Increment** |
| super Code/05_diagram_generator (M05, ce-frei) | baseline_3-analysis/<neu> | ZIEL FEHLT | F3=A (zweiter Schritt) |
| ce latency_stats / HDR-Generika | baseline_3-analysis (bzw. additiv b0-core) | ZIEL FEHLT | F1=A belang-genau |
| ce MeasurementRecord / ThreadArena / measure / axis_registry / IMeasurementSource | baseline_0-core (76), additiv | NICHT migriert | F0=A ce-WIE-Rest |
| ce SystemAxis-Framework-Rumpf | baseline_1-instrumentation (320), additiv | NICHT migriert | F0=A |
| ce dataset_loader-Rest + sample_data-Kern | baseline_2-workloads (321), additiv | NICHT migriert | F0=A |
| Konsum/Instanziierung nach der Extraktion | eigene Research-Instanziierungs-Zelle unter comdare/research | ZIEL FEHLT (Schritt-13-GATED) | F5=A |
| ce-Kern (Planer/CEB/Tier/Search/Build-Tools) | comdare/modules/comdare-cacheengine/* (293-298) | **GESPERRT** | Pseudo-Spiegel, NIE Migrationsziel |
| stale Umbrella-README:7 | comdare-measurement-all (300) | STALE (D-1) | F0=A: README-Fix als Teil des ersten Increments |

**Konkrete Anlage-Bedarfe fuer den ersten Increment (je Remote-Anlage ein eigenes GO noetig, G5-Dossier Sec.5):** (1) Untergruppe `comdare/modules/comdare-measurement/comdare-baseline_3-analysis` unter Gruppe 353; (2) genau EIN Projekt darin (Namensvorschlag `comdare-analysis`, Owner-Bestaetigung noetig — der Name "comdare-measurement-all"-Muster/-all ist hier falsch, und "comdare-cache-engine-all" ist verboten); (3) README:7-9-Korrektur im Umbrella 300. Reihenfolge bottom-up per F3=A.

## 7. STEHENDE GATE-KLAUSEL (in den A11-LEDGER-Nachtrag zu uebernehmen)
**KEIN Modul-Migrations-Schritt ohne (Re-)Validierung dieses Suchlaufs. Maximales Alter des Inventars: 7 Tage vor Migrations-Start.**
- Validierungs-Datum dieses Laufs: **2026-08-02**. Gueltig bis **2026-08-09**.
- Re-Validierung = Wiederholung von S1 (Gesamtzahlen) und S4 (Sperrliste). **Weicht die PROJEKT-GESAMTZAHL um mehr als +/-2 von 390 ab, ist ein VOLLER Neu-Lauf S1-S5 zu fahren, kein Teil-Abgleich.**
- Ein Lauf, der 0 oder auffaellig wenige Projekte liefert, gilt als FEHLGESCHLAGEN (PAT-/Scope-Problem), nie als "keine Kollision" — der Token-Scope ist vorab per `/user` (is_admin/Identitaet) zu belegen.
- Die Migration selbst bleibt Projektende (LEDGER G5/#274); diese Klausel aendert daran nichts, sie sichert nur den Startpunkt ab.

## 8. OFFENE PUNKTE / OWNER-FRAGEN AUS DIESEM LAUF
1. **D-2/D-3 Branch-Doktrin (blockierend fuer Migration):** Default `main` vs. Zellen-Konvention `development`, plus die 12-Tage-Divergenz in comdare-metrics (76). Owner-/Infra-Entscheid noetig: Default auf `development` umstellen und die divergenten Staende zusammenfuehren — oder die Konvention formal auf `main` nachziehen. Bis dahin darf kein Migrations-Schritt automatisiert den Default-Branch lesen.
2. **Sperr-Etikett fuer 293/294/295/297/298:** Nachziehen des Tombstone-Kopfes nach dem Muster von 296 (additiv, Doku nie loeschen). Freigabe erbeten. Kein Loeschen.
3. **Name der b3-analysis-Zelle** (Vorschlag `comdare-analysis`) + Remote-Anlage-GO fuer Gruppe und Projekt.
4. **D-4 buildsystem.xml in comdare-metrics (76):** gehoert per Zellen-TABU nicht dorthin — Klaerung mit dem Buildsystem-Agenten (F1-Hoheit), nicht einseitig entfernen.
5. **G-Q2 config-Owner** bleibt offen und hat auf GitLab eine reale Doppel-Zelle (155 vs. 156) erzeugt.
6. **E-25 Server-Luecke:** Owner-Aussage nennt server UND client als generisch; Ist zeigt nur client generisch. Rueckfrage, ob ein generisches Server-Modul geplant/erwartet war (Scan-only — Umsetzung bleibt nach Abgabe per R7).
7. **Scope-Frage aus dem Design (unbeantwortet, hier nach Empfehlung gefahren):** Der Lauf war **GitLab-only**; die flachen GitHub-Out-of-house-Spiegel wurden NICHT inventarisiert (Design-Empfehlung, da die Migration GitLab-Module betrifft). Falls der Owner die GitHub-Seite mitgezaehlt haben will, ist ein Zusatzlauf noetig.

## 9. LAUF-METHODIK (reproduzierbar)
Alle Aufrufe GET, ueber `curl --cacert <ROOTCA> -K <0600-config>`: `/user` (Scope-Beleg) · `/projects?per_page=1` und `?archived=false` (x-total-Anker) · `/groups?per_page=100&all_available=true` voll paginiert · `/groups/:id/projects?per_page=100&include_subgroups=false` je Gruppe · `/projects?per_page=100` voll paginiert (Gegenprobe) · `/projects/:id/repository/tree?recursive=true` mit clientseitigem Pfad-Tiefen-Filter (Tiefe 0 und 1) fuer 300/76/320/321 sowie 293-298 · `/projects/:id/repository/files/README%2Emd/raw` · `/projects/:id/repository/branches` und `/branches/:name`. Roh-Artefakte (token-frei, Verify 0) liegen DAUERHAFT unter `docs/sessions/backups/20260802-e23-suchlauf-belege/` (`e23/` = Lauf-Rohdaten inkl. hdr_*/ndjson/readmes/trees; `e23-review/` = Review-Re-Verifikation: branches_76/300/320/321.json + user.json zu D-2/D-3 und dem Scope-Beleg, tree_dev_76/320.json zur S2-Gegenpruefung). S2-Erhebung lief auf default_branch; D-4/D-5 wurden im Review auf development GEGENGEPRUEFT und halten auf BEIDEN Staenden (76/development traegt weiterhin buildsystem.xml + vendor/, zusaetzlich build-ct/; 320/development weiterhin ohne cmake/).
