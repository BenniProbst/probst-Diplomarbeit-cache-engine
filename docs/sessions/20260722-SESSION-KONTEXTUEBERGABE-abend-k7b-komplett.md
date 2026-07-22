# KONTEXTUEBERGABE 22.07.2026 (Abend, ~20:50) — K7b komplett, Smoke gruen, vor Batch-Emission

> Handover fuer die naechste Session (User kompaktiert manuell). Vorgaenger: 20260722-SESSION-
> KONTEXTUEBERGABE-nacht-audit-sweep.md (frueh) + PAUSE-HANDOVER-netzwechsel.md (inkl. KORREKTUR-
> NACHTRAG!) + REIHENFOLGE-UPDATE-praezisierungen.md. Lies IMMER zuerst: Ledger §59-§64 (Datei-Ende),
> dann dieses Doc. ERSTE PFLICHT-AKTION der naechsten Session: Abschnitt 3 (TODO-RESTORE) als
> sichtbare Task-Liste anlegen (User-Direktive!).

## 1. HARTE STAENDE (alle dual gepusht gitlab+github; Divergenzen IMMER manuell klaeren — Standing-Regel)
- **ce**: development `5aaee411` (K7b-2 = K7b KOMPLETT) · main `8a3a58c9`. Kette heute (Auszug):
  bceefa8d(K7b-1) d89dd103(K7b-3) 9b246b18(Crash-WIP) 62de1b8c(K7b-4) 04ea315f(WIP-aufloes-Merge) 5aaee411(K7b-2).
- **super**: development `ab112fe` (Gitlink 5aaee411) · main `332c54a`. Juengste: c94e48b(K7b-4-Anteil)
  fb2fe7a(Handover-KORREKTUR) ab112fe(Bump). ACHTUNG: die Zwischen-Instanz hat die fruehe Tages-Historie
  mit NEUEN SHAs umgebaut (Inhalt vollstaendig; 99bffb9=Ist-Verstoss etc.) — SHA-Referenzen aus fruehen
  Docs koennen abweichen, Inhalt gilt.
- **thesis**: `ef448e4b` UEBERALL synchron (lokal+gitlab+github) — der ewige Gitlink-Streuner ist SEIT HEUTE
  GESCHICHTE (FF-Sync 20:35). **prt-art**: 01e8b7dd synchron (Klon+Submodule). **Cluster**: 88c1183+
  (Keys bleiben gitlab-only).
- **Desktop-Plain-Backup**: ~/Desktop/DIPLOMARBEIT-PLAIN-BACKUP/ + Cron */15min (token-frei, Transkripte
  exkludiert; Memory reference_desktop_plain_backup_diplomarbeit) — Schutz vor laufenden PAT-Scrub-Rewrites.

## 2. HEUTIGER GESAMT-ERTRAG (chronologisch komprimiert, alles committet)
1. **Nacht-Audit R1-R9 KOMPLETT** (P1 12115 gruen / P2 12120 gruen / P3 R6-Stufe2_Hybrid / R7+Pin /
   R8a --print-cache-key / R8b YAML-GN_CACHE_KEY: Warm-Pull traf ce-Pushes vorher NIE). B4-Auflage erfuellt.
2. **Methodik-Schnitt S1-4** (COMDARE_PLAN_METHODIK_PROFILE = Profil-SELEKTOR, Basename+Prolog-Re-Derive,
   KLASSEN-Regel-konform): Bau-Katalog != Methodik-Profil entkoppelt.
3. **§64 komplett als Gesetz** (Vereinigungs-Default alle 3 Verfahren in EINER CEB, Mengen-Stempel X.Y.Z je
   Tag, Schichten-Zuordnung wallclock=CEB / macro+micro=CEB+Tier via Pruefdock, Fundstellen-Beleg,
   Versionierungs-Klaerung §58-V) + **Phase 1** (Profil-Combos 3->1, ce ab245e84).
4. **VEREINTER DEBUG-SMOKE = S5-GATE ERFUELLT, Kette HART GRUEN** (12160/12168 success): EINE [all]-Lane,
   CMAKE_BUILD_TYPE=Debug profil-getrieben, (j3)-Dual-Compile LIVE im Log, +bt=Debug-Stempel, paralleles
   Messen (399% CPU/5 Worker, RAM-gedrosselt). Befund: Mess-UMFANG kam noch aus all_axes_golden (17
   Sweeps) -> 6h-Grind -> Umfangs-Selektor = Teil Batch-Emission; Log-Flush fehlt (6h stumm) = Pflicht-Fix.
5. **K7b KOMPLETT (ccache-Gate, User-Pflicht-Vorzug)**: K7b-1 consteval-SHA512 + K7b-3 Fingerprint-POD
   (72->88, layout 4, golden-neutral) + K7b-4 G1-Selbst-Stempel --version (B6 erfuellt; Crash-WIP sauber
   per -s-ours aufgeloest) + K7b-2 Mengen-Provenienz (unset==[all]==Vollmenge via from_env; Variante A,
   additive Ueberladung; Director+Cache-Key unberuehrt). **KEIN Re-Anchor: die fruehere Auflage war
   FALSCH** (kNewGolden131072Crc64 == 0xF1C1F26A-Anker, EIN Symbol; CRC ueber binary_ids; Stempel
   id-neutral) — Agent-STOPP korrigierte es, Handover-KORREKTUR fb2fe7a versiegelt die Fehlerquelle.
6. **§62-B massiv praezisiert** (User): P1 Bestandsdokument/4096er-Batches/ETA/Takeover + ETA-KORREKTUR
   (Mini-Batch=max-Threads; ETA=Summe(t_i/N)>=max(t_i)) + P2 ZWEI Bestaende als Factory Pattern +
   SHA512-constexpr-Stempel + P3 Schreib-Lock<=30min + P4 Multi-Write/Batch-Typen-Sequenz/Thread-Budget
   (prod1=32T/24K, prod2=24T/16K) + IST-VERSTOSS Einzel-Jobs (Batch-Emissions-Auftrag).
7. **Zombie-Saga geloest**: [RUN-1]-Waisen (PPID=1, Runner-Handle weg) + Sweep-Deadlock diagnostiziert
   (Diag-Pipeline-Agent, read-only); Option B (Sweep-Wellen auf reinen Sweep-Job ausgeduennt) griff:
   Cancel-Timeout -> Slots frei -> Sweeps 12342/12343 pending. Monitor b8uw6evsi zaehlt Driver.
8. **Standing-Regeln NEU**: Diffs IMMER manuell klaeren (fetch+rev-list+inhaltliche Sichtung vor jedem
   Push; Scrub laeuft) + Desktop-Plain-Backup-Cron + Arbeit ohnehin auf development.

## 3. TODO-RESTORE-LISTE (ERSTE AKTION naechste Session: als sichtbare Tasks anlegen!)
ERLEDIGT-Marker (2, als completed anlegen):
- [x] S5/S6-GATE: vereinter Debug-Smoke KOMPLETT GRUEN + alle Beweise (Details Abschnitt 2.4).
- [x] K7b KOMPLETT 1/2/3/4 (ce 5aaee411, super ab112fe; Details 2.5).
OFFENE KETTE (Reihenfolge = Abarbeitung):
- [ ] 1. **Sweep-Ausgang verifizieren**: Sweeps 12342/12343 gruen + ps -C comdare-messung-driver == 0 auf
      prod1 (3 Waisen: 1676468/2200524/+1); bei Fehlschlag: root-Kill via User/Infra (comdare darf nicht).
- [ ] 2. **[BATCH-EMISSION]** (§62-B-Ist-Verstoss, Ledger 99bffb9; VOR 320er): TierCiYamlBuilder -> je
      Maschine EIN Build+Pruef-Batch-Job (CEB iteriert intern Perms x Chunks, GTest-Pruefstand je Tier,
      Log-Legende [d,e,f][g,h,i] je Schritt + Fortschritts-Testat) + EIN Mess-Batch-Job; O(Maschinen).
      + Log-Flush-Fix (zeilengepuffert + Heartbeat; 6h-stumm-Befund) + SMOKE-UMFANGS-SELEKTOR (Smoke
      misst kleines Programm statt all_axes-17-Sweeps). Agenten-Kartierung VOR Bau.
- [ ] 3. **320er** m3v2-320: VEREINTE [all]-Lane, versionierungs-zuordenbare Binaries (K7b-Stempel),
      wallclock-first, Interim-Host-Lanes GO(1), Hochrechnung nach Lane 1.
- [ ] 4. **S7**: Hybrid-Binary (§49-Optionen) + M-4-Auswertung + Mess->PDF-Rueckschrieb + Release-
      Wallclock-Beweis. -> [ ] 5. **S8**: Thesis-PDF DE+EN (END-GATE 28.07.).
- [ ] 6. **dev->main-MERGE** der durchgeplanten Tages-Staende (Branch-Regel; alles liegt nur auf development).
- [ ] 7. **#46b Bestandslog-System** (§62-B P1-P4 KOMPLETT umsetzen: XML-Bestandslog mit Header-Version,
      Lock/Multi-Write, 4096er-Batches+Zeitstempel, ETA-Formel, +50%-Takeover, Done-Semantik,
      Gleichverteilungs-Pflicht, ZWEI Bestaende Factory + SHA512-std::map-Lookup). K7b-Vorbedingung ERFUELLT.
- [ ] 8. **#47 COMPARE** (4. run_methodology; nach S7+Replay+#46b).
- [ ] 9. **#54 emit-Vertrags-Kette** (CEB-interner Pruefstand-Batch + Status-Pipe + Planer-Instrumentierung;
      baut auf Batch-Emission auf).
- [ ] 10. **#34-#37 POST-v3-Kern**: Planer-CLI -> .so-Schnitt -> Resolver+CoR -> F-SPREAD.
- [ ] 11. **#49 Hardware-Achsen**: RAM-Freq+CAS + CPU-Fabrikation (libcpuid/cpu_features/decode-dimms);
      liefert §62-E-Identitaets-Werte.
- [ ] 12. **#51 tier150-Ersatz** (nach 320er: Kurven-Loader umstellen, dann loeschen).
- [ ] 13. **#48-Scheibe-6** XML-Umhaengung (GEGATED: nach 320er + User-GO; v1 darf brechen; C5/C6-Auflagen).
- [ ] 14. **#38-#44 G-Gruppen + PV-4 + W12-Quelldaten** (echte X.Y.Z je Algo statt v1; Band-C) + SHA512-
      Zeile war K7b-3 (fertig).
- [ ] 15. **CI-WARTUNG** (Sammel): contract-Label-Luecke ce-CI (12111-Befund) · prt-art-Geschwister-
      Checkout-Race (Klon je Job/Lock) · Suffix-Reihenfolge perm-loop vs system_axes_version_suffix
      (Single-Source) · ~14min-Treiber-Bau je Mess-Job (Artefakt-Reuse) · xmllint '--'-Kommentare ·
      Testing/-gitignore.
- [ ] 16. **2 RUNTIME-BEWEISE**: R8b-Key-Gleichheit (Matrix-Opt-in-Lauf) + R1/R2-HIT GN_DECISION=skip
      (naechste golden-Bau-Welle).
- [ ] 17. **G7-User-Punkte** (allocators-Doku, Zaehl-Pin-Wachstum, golden_kern-Master-Ort, E15/E16/#24/#25/#225).

## 4. LAUFENDE THREADS (bei Absturz neu aufsetzen)
- **Monitor b8uw6evsi**: canceling->canceled ERLEDIGT; verfolgt Sweep-Jobs 297915(amd)/297932(intel) bis
  terminal + Driver-Zaehler (Ziel 0). Bei Verlust: Status via API + ps pruefen.
- **Impl-S6-P1** (Opus, Neu-Spawn von 19:55): IDLE nach K7b-2-Lieferung; Arbeitsregeln im PAUSE-HANDOVER
  Abschnitt 4 (MIT Korrektur-Nachtrag!). NAECHSTER AUFTRAG: Batch-Emissions-KARTIERUNG (read-only:
  emit_measure_job/TierCiYamlBuilder-Naht, Batch-Loop-Ort im Treiber, Pruefstand-Minimalform, Umfangs-
  Selektor-Naht) -> Schnitt-Vorschlag -> mein GO -> Bau.
- **Cron-Backup */15** laeuft session-unabhaengig.
- Diag-Pipeline + Explore-Agenten: Auftraege abgeschlossen.

## 5. STOLPERFALLEN HEUTE (nicht wiederholen)
- Kartierungs-Behauptungen von Agenten NICHT ungeprueft in Auflagen uebernehmen (Re-Anchor-Irrtum: EIN
  Symbol, CRC ueber ids). Agent-STOPPs ernst nehmen — zweimal heute Gold wert.
- Sweep-Job NIE triggern, solange legitime Driver laufen (pkill trifft alle); Sweep-Wellen sind VOLLE
  api-Wellen -> sofort auf den Sweep-Job ausduennen (Option B) oder rules haerten (Merkposten).
- Job-Cancel bei PPID=1-Waisen loest erst der GitLab-Hard-Timeout (~15min); canceling haelt den Slot.
- Transkript-Dateien tragen LIVE-TOKENS (Backup exkludiert sie; nie kopieren/committen).
- Vault-Zeilen nie halbmaskiert printen (2 Fragment-Leaks heute -> nur noch blind-Extraktion + md5).
- Admin-SSH: Handover-md5 509f3aef ist STALE (deaktiviertes Konto) — kein Brute-Force, Infra fragen.
- gitlab-Trigger source=api = VOLLE Welle; COMDARE_MEASURE_PROFILE=smoke noetig fuer Methodik-Zweig.

## 6. SICHERHEIT (unveraendert bindend)
PAT via grep aus Vault je Aufruf, NIE printen/committen; Vault=Cluster/keys/CREDENTIALS-VAULT-DEV.md
(+PROD nur blind-Extraktion); CA=comdare-gitlab-ca.crt; NIE rebase, Diffs MANUELL klaeren; Remote-
Loeschung nur je-Repo-GO; Messdaten/Doku nie loeschen (Ausnahmen nur explizites User-GO); Transkripte=
Tokens nie committen; kein AskUserQuestion; kein Python in Buildchain; ASCII-Code-Kommentare (§ erlaubt);
Dual-Remote origin=gitlab.comdare.local+github; cf22 NUR /home/comdare/tools/clang-format-22.1.8;
Cluster-Repo nie nach github.
