# PAUSE-HANDOVER 23.07.2026 ~08:45 — Netzwechsel (kalter Resume)

> Absturzfeste Sicherung VOR Netzwerkwechsel (Shell-Cache wird geleert). Vorgaenger-Doku:
> 20260723-SESSION-nacht-ci-reparatur-s4-batch-gn11-belege.md (NACHT-VOLLSTAND, zuerst lesen!)
> + 20260722-SESSION-KONTEXTUEBERGABE-abend-k7b-komplett.md.

## 1. HARTE STAENDE (alle dual gepusht, Divergenz 0/0 manuell geklaert, Working Trees clean)
- **ce** development `9df09f14` (S4 Batch-Emission) · **super** development `2790383` (Nacht-Session-Doc)
  < c706f3e (S4-Gitlink) < 5258f08 (S3) < ff45502 (S2). main NICHT angefasst (Scrub-rewritten 91897d4a beidseitig).
- Kette 2 (S1-S4) KOMPLETT gelandet + CI-hart-gruen (Vollwellen 12516 + 12591 je inkl. ce-Bridge).
- GN-11-Messfaehigkeit KOMPLETT belegt (CI + bare-metal, literal in Nacht-Doc Abschnitt 4).
- Voll-Bau-Vorbedingungen ALLE erfuellt: Runner-Timeout-Cap None; Platz prod1 72G / prod2 149G frei;
  prod2 nproc=24. prod2-SSH: admin-management@10.0.10.212 mit Cluster/keys/cluster-Key FUNKTIONIERT.

## 2. SERVERSEITIG LAUFEND beim Pause-Zeitpunkt (laeuft ohne diese Session weiter)
- **12623 Batch-Struktur-Smoke** (api, c706f3e, RUNNING): erste Live-Emission der neuen
  O(Maschinen)-Struktur (erwartet: planer:delegate klein via m3v2_smoke → Grandchild mit
  tier:build-batch:amd/intel + measure:[all]:batch:<host>, Testat-Grammatik im Log).
  RISIKO: prod1 = amd-Runner — Netzwechsel kann laufende Jobs als runner_failure killen.
- **12272 main-Scrub-Welle** (RUNNING seit gestern 16:24): NUR beobachten, nie eingreifen.
- **Sidekiq-Rest-Abtrag**: bf≈17k/bq≈10k sinkend (ResumeWorker-Cron */1min). Blockwirkungsfrei
  (Middleware-Disable-Flags aktiv). Flags-Ruecknahme faellig bei bf=0 UND bq=0.
- Cron-Backup Desktop */15min laeuft session-unabhaengig.

## 3. RESUME-CHECKLISTE (Reihenfolge)
1. GitLab-Erreichbarkeit (curl API, PAT via grep aus Vault).
2. **12623**: Status + Kette (Bridges rekursiv). Bei runner_failure durch Netzwechsel: Jobs retryen.
   Bei GRUEN: Batch-Struktur im Grandchild-Log SICHTEN (Job-Namen tier:build-batch:amd/intel,
   Kopf [a,b,c]+lane, [BAU]/[PRUEF]-Testate [d,e,f][g,h,i]) → dann Kette 2 = COMPLETED.
3. `ps -C comdare-messung-driver` auf prod1 (Zombie-Check nach Job-Abriss; Sweep NIE bei
   laufenden legitimen Drivern).
4. Task-Board pruefen (TaskList) — bei Verlust: 25-Task-Restore-Liste = Stand dieses Handovers
   Abschnitt 5 + Nacht-Doc; Vorlage der Boards in dieser Session (4 completed + Ketten 2-18 +
   GN-11/PAT/G8/CI-Reparatur).
5. Monitore neu bewaffnen: (a) Sidekiq-Abtrag-Schwellen-Wache (SSH pve1 → kubectl exec redis-node-1
   → LLEN throttled_jobs bf/bq; Meilenstein-Buckets; terminal bf=0&&bq=0 → Flags-Ruecknahme);
   (b) 12623- bzw. Voll-Bau-Wache (Status-only, poll-err-tolerant).
6. Impl-S6-P1 anpingen (SendMessage); bei Nicht-Erreichbarkeit: Neu-Spawn-Rezept Abschnitt 4.
7. **2^17-VOLL-BAU triggern** (nach gruenem 12623 + Sichtung): POST /projects/288/pipeline
   ref=development, variables: COMDARE_BUILD_GOLDEN_N=true (SONST NICHTS — MEASURE_PROFILE
   UNGESETZT => Mess-Batches bleiben when:manual; GN_TOTAL=131072 ist Default) → reine Bau-Batches
   beide Maschinen, ~2 Tage, Fortschritt via [TESTAT]-Zeitstempel im Job-Trace (4096er-Korn),
   Wiederaufnahme nach Abriss: GitLab-Retry desselben Batch-Jobs (Sidecar-Resume skippt Fertiges).

## 4. AGENT Impl-S6-P1 (Opus, Neu-Spawn von 22:45 nach Absturz) — STANDBY
Geliefert diese Nacht: S4 komplett (abgenommen, committet) + bare-metal-Mess-Smoke-Beleg (0:2).
Im Standby geparkt, nichts offen, Working Tree clean. NEU-SPAWN-REZEPT (falls verloren):
Opus, background, Name Impl-S6-P1; Arbeitsregeln: NIE committen (FREEZE+diff-stat, Manager committet),
ASCII (§ erlaubt), cf22 nur /home/comdare/tools/clang-format-22.1.8 --dry-run --Werror==0,
golden-TABU 0xF1C1F26A1232073B literal, offizieller Weg cmake+ctest voll, kein Python, STOPP bei
Widerspruch. Basis ce 9df09f14 / super 2790383. Naechste Auftraege je nach Lage: Batch-Smoke-Befunde
fixen ODER 320er-Vorbereitung.

## 5. BOARD-KURZFASSUNG (25 Tasks; Detail = Board bzw. Nacht-Doc)
completed: S5/S6-Gate · K7b · Kette-1-Sweep · G2-Anti-Phantom (S7 entblockt).
in_progress: **Kette 2** (nur noch 12623-Sichtung offen) · **GN-11** (nur noch Voll-Bau; Trigger-
Rezept oben) · **CI-Reparatur-Reste** (Flags-Ruecknahme bei bf=bq=0; Cron-Persistenz nach
Pod-Restart pruefen; Helm-Values-Merkposten).
pending (Reihenfolge): 320er (Sa/So) → S7 → S8 (Mo 27.07., G8-Anhaenge-Gate davor) · dev→main
(Scrub-Vorsicht) · #46b Lagerhaltung (vor 01.08.) · #47 · #54 · Post-v3 #34→#35→#36→#44→#38→#37 ·
#49 HW-Achsen · #51 tier150 · #48-S6 (gegated) · G-Gruppen+#29-Rest · CI-Wartung (9 Merkposten) ·
Runtime-Beweise R8b/HIT · G7+OD-Weichen · §55-Rest (§63 leeres Backlog) · PAT-Rotation #327 (SOFORT,
mit Konsumenten-Kartierung).

## 6. SICHERHEIT (unveraendert)
PAT nur via grep aus Vault, NIE printen; Vault-PROD nur Blind-Extraktion+md5; NIE rebase, Diffs
IMMER manuell klaeren (Scrub-Rewrites auf BEIDEN mains!); Messdaten/Doku nie loeschen; Transkripte=
Tokens nie committen/kopieren; kein AskUserQuestion; Cluster-Repo nie nach github; Testing/ nie
committen; Sweep nie bei laufenden Drivern; Toolbox-Rails-runner klein halten (OOM Exit 137).
