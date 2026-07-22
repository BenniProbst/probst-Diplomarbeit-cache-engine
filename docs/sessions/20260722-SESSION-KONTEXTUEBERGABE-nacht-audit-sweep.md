# KONTEXTUEBERGABE 2026-07-22 (frueh) — Nach der autonomen Nacht 21./22.07.

> Handover fuer die naechste Session (Kontext endet). Vorgaenger-Handover: docs/sessions/2026-07-20-* + AUTONOM-01/03.
> Lies IMMER zuerst: Ledger §59-§63 (Ende der Datei), dann die 2 Dossiers (unten), dann dieses Doc. Memory lesen (project_62, feedback_autonomie, feedback_dual_weg, Branch-Doktrin, Freeze-Regel).

## 1. HARTE STAENDE (verifiziert, dual gepusht gitlab+github)
- **ce**: development `251cea12` · main `8a3a58c9` (erster §63-Merge). **super**: development `2c7c706` · main `332c54a`. **thesis**: dev==main `ef448e4b` (chktex-Fix). **Cluster**: dev `d124b28`+ (Infra-Strang).
- Working Trees clean (super zeigt nur den bekannten thesis-Gitlink-Streuner ` M thesis/diplomarbeit` — NIE mit-adden, scoped committen!).
- GitHub-Token wurde rotiert — das NEUE liegt im Vault (Sektion ## GitHub, letzter Eintrag); Credential-Store traegt es bereits.

## 2. WAS DIE NACHT GELIEFERT HAT (alles committet, CI-gruen bis inkl. super 569d035; 2c7c706-Welle lief an)
- **§61-Kette komplett** (Vortag): Modus-per-Profil exactly-one, +bt-Compile-Stempel Ende-zu-Ende ((i)+facade), echter Debug-DLL-Pfad -O0 (2b, toolchain-abstrahiert), (j3)-Dual-Compile-EMISSION (2c: Debug-Job=2 Treiber-Aufrufe, Release-Provision in _release_provision), CPUID-Lane-Wache (exit 7), platform-Tag lane@hostname, per-Host-Mess-Gruppen.
- **#46a Minimal-Cache KOMPLETT**: S1 3-Objekt-Push (dll->algos->version-ZULETZT) + Key +ceb/+mtool/+mrg=none (Single-Source cache_key_prefix); S2 pull_tier_binary+pull_tier_prefix (Batch-Hydration am PULL-HOOK, Default aus); S3 bare-metal Storage-Skript (ce scripts/comdare_storage_activation.sh); S2-F1 Host-Wiring (main.cpp, Link-Beweis); mc-Timeout-Wrapper (alle 5 mc-Stellen); Marker-algo_sig + HIT-Mismatch=MISS + **--chunk-organ-fingerprint**-Modus (Wache SCHARF, kreuzvalidiert; cppcheck-try/catch-Fix 332c54a).
- **#45 paralleler Mess-Loop**: collect_ordered-Pool NUR debug (COMDARE_MEASURE_PARALLEL/nproc), measure/release STRIKT 0 (testbewiesen), CSV-deterministisch, per-Worker-pmc.
- **#53 docs-Gate KOMPLETT bewiesen**: (1) docs-only=Minimal-Welle 12047 gruen (nur lint:secrets+thesis:pdf), (2) Gitlink=voll 12034, (3) YAML=voll 12011/12046. DAG-Fix (5x needs optional:true), api-Quelle im Vorspann, ccache-Hygiene, build:clang kombinierte rules (CLANG_MATRIX-Killswitch erhalten; skipped-Faelle=Stage-Folge des thesis-Fails, KEIN Bug).
- **Thesis-Rot behoben**: chktex-13 in Anhang B/E (DE+EN) via API gefixt; thesis main+development auf ef448e4b; Bridge triggert ref=main (!) — deshalb musste main nachgezogen werden.
- **#48 XML-Gate FUNDAMENT (Scheiben 1-5)**: S1 config_a/b/c->deprecated/ (git mv); S2 Wohlgeformtheit 6 Profile + allocators-Doku-Kopf; S3 experiment_golden_kern.xml NEU (super Code/test_data_xml/, KANONISCH AB #48); S4 Parser-Naht machines/axis@pruefling/fulljoin(Phase-3-Bindung)/storage-inert + test_experiment_kern_seam; S5/B+ XSD-Konsolidierung (experiment_schema.xsd=EINZIGES Ziel-Schema v2, id_namespace ECHTE Naht [§59-C 3. Merge-Stempel], SCHEMA.md) — ALLE 3 Instanzen validieren; v1 blieb kompatibel (Bonus). **SCHEIBE 6 (Umhaengung) GEGATED nach 320er+User-GO; User-LOCKERUNG 22.07.: v1-Kompat MUSS NICHT bleiben wenn sie bremst.**
- **runner:sweep-zombies**-Job NEU (super 2c7c706): var-gegateter Waisen-Kill als gitlab-runner je Lane (COMDARE_SWEEP_ZOMBIES=true + SWEEP_TAG=amd|intel via API-Trigger) — [RUN-1]-Workaround selbstbedienbar.
- Dossiers: docs/plaene/20260721-PLAN-46a-53-*.md (V1-V5) + 20260722-PLAN-48-xml-gate-DOSSIER.md (V-a..V-f + S5-B+-Bruchloesung).

## 3. LAUFENDE HINTERGRUND-THREADS (bei Absturz neu aufsetzen!)
- **wf_47b303b0 (wv0k4wl60): NACHT-ABWEICHUNGS-AUDIT** (User-Auftrag!): 4 Lanes (Cache/§61/#48/CI) pruefen Ist gegen Ledger+Dossiers; Klassifikator R(egression)/A(uslegung)/K(onform). ERGEBNIS AUSWERTEN -> R-Liste als Fix-Auftraege an Impl-Agent. Bei Verlust: Workflow-Skript unter workflows/scripts/audit-nacht-abweichungen-*.js, resumeFromRunId wf_47b303b0-bd5.
- **bjsjdy73z: Sweep-Monitor** (Pipelines 12097 amd / 12098 intel bis terminal + prod1-ps-Beleg). Zombie PID 728821 lief 18h+ (Infra reagierte NIE auf Handover 2).
- **Impl-Agent 'Impl-S6-P1' ist TOT** (Abstuerze) — bei Bedarf NEU spawnen (Opus, run_in_background, mit Arbeitsregeln: FREEZE nach Paketmeldung, nie committen, cf22 NUR /home/comdare/tools/clang-format-22.1.8, ASCII, TABU-Wachen, diff-stat-Literalpruefung durch Manager vor add).

## 4. NAECHSTE SCHRITTE (Reihenfolge)
1. Sweep-Ergebnis: beide Lanes SAUBER -> **Debug-Smoke triggern**: POST /projects/288/pipeline ref=development, vars COMDARE_BUILD_GOLDEN_N=true + COMDARE_GN_TOTAL=4 + COMDARE_MEASURE_PROFILE=smoke. Erster Lauf mit #45-Parallel-Messen + Cache-Push (Bucket-Befuellung=prod1-Scharflauf-Beweis) + Dual-Compile. Voll-Monitor auf die dynamische Kette (Vorbild in dieser Session; Pipeline-IDs, nie Kurz-SHA-Suche!).
2. Audit-Verdikt auswerten -> R-Fixes an neu gespawnten Impl-Agenten; A-Liste dem User zeigen.
3. Smoke gruen -> **320er**: m3v2-320-Bau+Messlauf (Interim-Lanes amd=4/intel=8 aus (k); wallclock zuerst; Hochrechnung nach Lane 1; measure-drop LIVE [MD-1 geloest]).
4. S7 (Hybrid+Wallclock-Beweis) -> S8 (PDF 28.07., Anhaenge B/E autonom).
5. Danach §63-Endlauf: #34-#37 (entsperrt), #46b, #47, #54, #49, #51, G-Gruppen — bis leeres Backlog. Durchgeplant->main (FF nach CI-gruen), halb-geplant->development.

## 5. OFFENE USER-PUNKTE (G7)
merge->Stufe2-Frage (§59-Wortlaut vs Ist-Pin merge==Stufe3; S4 konservativ) · allocators-Doku-Status (23) · Zaehl-Pin-Wachstum nach 320er · golden_kern-Master-Ort (Scheibe 6) · E15/E16/#24/#25/#225.

## 6. STOLPERFALLEN DIESER SESSION (nicht wiederholen)
- pipelines?sha= matcht NUR volle SHAs; Monitore auf Pipeline-IDs bauen; Heartbeat+Vollblick-Pflicht.
- GitLab-Trigger source=api: Gate-Vorspann enthaelt jetzt api (volle Welle) — Smoke-Trigger brauchen BUILD_GOLDEN_N=true sonst laeuft planer:delegate nicht.
- Job-Cancel erzeugt Zombie-Driver ([RUN-1]) -> danach IMMER sweep (neuer Job!) + P11 blockt sonst den Host.
- Bridges (trigger:thesis) testen ref=main der Sub-Repos, NICHT den Gitlink.
- Commit-Race: Freeze-Regel strikt; diff-stat literal gegen Report VOR git add; Nachrichten-Lag mit Teammate=Normalfall (Weck-Ping-Muster).
- Board/Monitore/Teammates ueberleben Abstuerze NICHT: Board aus diesem Doc + TaskList-Restore-Muster wiederherstellen.
- ps/pgrep-Selbst-Match ([b]-Trick); $?-nach-Pipe-Falle; kein pkill auf fremde User (Sweep-Job-Weg).

## 7. SICHERHEIT (unveraendert bindend)
PAT via grep aus Vault je Aufruf, NIE printen/committen; Vault=Cluster/keys/CREDENTIALS-VAULT-DEV.md; CA=comdare-gitlab-ca.crt; NIE rebase; Remote-Loeschung nur je-Repo-GO; Doku nie loeschen (Ausnahmen nur per explizitem User-GO wie Alt-Mess-CSVs); Transkripte=Tokens nie committen; kein AskUserQuestion; kein Python in Buildchain; ASCII-Kommentare; Dual-Remote origin=gitlab+github (Token im Vault).
