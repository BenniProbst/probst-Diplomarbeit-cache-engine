# SESSION-ÜBERGABE 28 — 2026-07-06 abends (comdare@prod1) — Pipeline-Krise gelöst · CMD-1-a+b DONE · 2 NEUE User-Strecken OFFEN

**Pflicht-Einstieg:** Ledger §13.12 (V3) → §12-Einträge 06.07. (chronologisch, unten die neuesten) → DIESE Übergabe → Board (24 Tasks).

## §1 IN-FLIGHT bei Kontext-Ende
- **Beweis-Pipelines** für ce `020e548e` (CMD-1-b) + super `3e7c5c7` (Bump): frisch getriggert, Monitor `bnmqjryvx` (event-basiert, 20 s, neueste Pipeline je Repo/Branch) + Anomalie-Netz `b6v1n7a03` (contacted_at>300 s). Bei Grün: CMD-1-b-Endstatus in Ledger §12, dann CMD-1-c (Dossier §2: Insel-Subsumption I3/I4/I1-I2, präziser Schnitt!).
- **Watchdog aktiv** auf prod1: `comdare-runner-watchdog.timer` (45 s; restartet Runner NUR bei contacted_at>120 s UND ohne Builds) — Sicherheitsnetz für den UNGELÖSTEN Runner-idle-Freeze (Wurzel serverseitig vermutet, s. Task #23/K87b-H18). Runner = 18.9.0 mit apt-hold; GODEBUG-Drop-in liegt (beides Rückbau-Kandidaten nach H18-Beweis).

## §2 NEUE USER-AUFTRÄGE (18:2x, BEIDE OFFEN — „strikt grün, Fehler echt beheben")
1. **thesis lint:latex HART machen (Overleaf-Repo!):** aktuell advisory-failed mit **964 chktex-Warnungen**; Verteilung (Job 213722): W1=284 (Command-Space), W36=251 (Abkürzungs-Spacing), W8=138 (Dash-Länge), W13=105, W12=101, W31=22, W24=20, W11=16, W27=12, Rest 26. USER hat damit die 03.07.-Advisory-Entscheidung UND das „thesis nur lesen"-Tabu für DIESE Strecke supersediert. Plan: mechanische Typografie-Fixes klassenweise (W8-Dashes zuerst — echte Fehler; dann W36/W12/W13-Spacing; W1 zuletzt/policy-Frage), NIE Formulierungen ändern (Provenienz!), vor jedem Edit `git fetch origin && merge` (Overleaf pusht selbst!), Commits OHNE Co-Authored-By (thesis-Regel), kleine Klassen-Commits, chktex lokal gegenprüfen (`chktex` auf prod1 vorhanden), am Ende allow_failure raus (Umschalt-Rezept: thesis/.gitlab-ci.yml lint:latex).
2. **ce test:unit HART machen:** Der Job bricht aktuell im BUILD (kein 58er-Laufzeit-Berg!): `fatal error: paper_a04_mimalloc_is_original.hpp: No such file` = **4c-0b-Wiedergänger** — das vom test:unit-Job gebaute Target fehlt in der statischen Codegen-Konsumenten-Liste (ce CMakeLists ~:1400-1438; Workspace /1/ hat ext/ initialisiert → Gate AN). FIX: ce .gitlab-ci.yml test:unit-Script ansehen (welches Target?) → in Konsumenten-Liste bzw. Codegen-Deps ergänzen → DANN zeigt sich die echte Laufzeit-Fail-Zahl → Fails klassifizieren/fixen (Task #24 liefert zu: test_benchmark_suite-/tmp-Klasse!) → allow_failure raus (#278/Task #8).

## §3 HEUTE ERLEDIGT (Belege in Ledger §12, Voll-Doku K87b im Cluster-Repo)
1. **Pipeline-Krise — 3 unabhängige Wurzeln:** (a) GitLab-Finalisierungs-Stall 5,3 min/Job instanzweit (ConcurrencyLimit-Deferred-Stau 1956 nach DNS-Ausfall 03.–05.07.) → Drain → **3,3 s** (literal); (b) /tmp-Benutzer-Kollisionsklasse → uid-Sweep über 7 super-Test-TUs (916077a+544ae17) → **super test:unit HART grün 103/103 in CI** (8085); (c) Runner-idle-Freeze (tritt bei 19.1.1 UND 18.9.0 auf, kein offener Request — Server-Long-Poll-These) → Watchdog + Montags-Audit #23.
2. **K1-ENDSTATUS erreicht:** alle 4 Repos strikt grün (8085/8088/8086/8074/8075 + Kinder), Voll-Job-Satz inkl. trigger:thesis (Lazy-Rules-Revert 2a34d00 nach User-Korrektur „Fundamentales läuft IMMER; Lazy nur via Caches").
3. **#267 CMD-1-a KOMPLETT** (ce 6e5d16b5 + CI-Verdrahtung 6dd2e34f): AxisCommand/axis_accept_measurement/AxisLimitations; CI-Beweis contract:conformance 6/6 (8084). MeasurementVisitable auskommentiert-GEPARKT (User: kommt mit Visitor-Umbau).
4. **#267 CMD-1-b KOMPLETT** (ce 020e548e, Beweis-Pipeline in-flight): Ein-Speicher `container_algorithm_` (adapter-analoge 3-Wege-Wahl) + Mess-Visitor via axis_accept_measurement. Review-Fänge: Codex' LayoutAware-Wahl verlor das Roadmap-1-in_use (vom Pilot R5B aufgedeckt, NACHDEM meine honest-0-Korrektur die kaschierende in_use=allocated-Kopie entfernte) → flat-Zweig zurück auf ComposedStore + **nicht-konstitutives T6-Mess-Organ `allocator_meter_`** für Hüllen-/Pool-Zweige (Adapter-Muster „+ Mess-Organe"); Zweig-2-Slab-Konvention (allocated==in_use) als Adapter-Spiegel dokumentiert. Literal 5/5 Tests.
5. **#277-Cache-Redesign bewiesen:** per-Tool-citools-Caches (ci-templates 269@d68050d5) — Kette Miss→„Created cache"→Hit literal (lint:secrets 10,7 s); Erst-Lauf-Kosten = GitHub-Downloads (LLVM 5min19s je Projekt, einmalig).
6. **#279 eingereiht** (Task #22, vorletzte Aufgabe): konfigurierbare Mess-Durchführung (Release) vor LaTeX-PDF + Tier-Binary-Build/Test-Sichtbarkeit; normative Quelle = Diplomarbeit-TEXT-Architektur (Selbstaufbau→Messwert-Tabellen ins Haupt-LaTeX).
7. Session-Harvest konsolidiert: Tasks #23 (Montags-Audit H11–H18; WICHTIGSTER: CoreDNS-minio-Eintrag nur LIVE!) + #24 (ce-/tmp + JUnit-Pfad).

## §4 FALLSTRICKE NEU (zusätzlich zu Übergabe 27 §4)
- GitLab-Runner meldet Cache-MISS als „Failed to extract cache" (primary_modified=0001-01-01 = Objekt existiert nicht) — kein Fehler.
- POST /api/v4/jobs/request mit echtem Runner-Token KAPERT Jobs (Phantom!) — Leer-Poll-Tests nur bei instanzweit leerer Queue; Heilung cancel+retry.
- Bei zwei belegten Runner-Slots altert contacted_at LEGITIM (Runner pollt nicht ohne freien Slot) — Detektor-Schwellen entsprechend.
- gtest random_seed()==0 default ⇒ „da_btc_test_0" war ein FESTER Pfad (Teil der /tmp-Klasse).
- ce contract-Jobs fahren Tests NUR über explizite Target+Regex-Listen — ein LABEL allein lässt keinen Test in CI laufen (CMD-1-a-Lektion; contract:conformance erweitert).
- Codex-Fabrikationen können Verhaltensverluste KASCHIEREN (in_use=allocated ließ den Pilot grün wirken) — Ehrlichkeits-Korrektur zuerst, dann zeigt der Test die echte Regression.

## §5 REIHENFOLGE NÄCHSTE SESSION
1. Ist-Verifikation + CMD-1-b-Pipeline-Endstatus (Monitor-Stand lesen; bei Rot: Trace, manuell fixen).
2. §2-Strecke 2 (ce test:unit Codegen-Fix — klein, konkret) → echte Fail-Zahl erheben → Fix-Serie.
3. §2-Strecke 1 (thesis lint:latex) klassenweise.
4. CMD-1-c nach Dossier §2 (Insel-Subsumption; NUR nach CMD-1-b-Grün) → CMD-1-d.
5. Danach V3-Reihenfolge: 265-b → #266 (Q2-GEPARKT-Fallback config-all) → AP-2-neu → … · Montag: Task #23 + #21-Rest + prod2.
