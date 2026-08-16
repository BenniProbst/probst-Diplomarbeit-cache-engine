# STRANG A: RESTPLAN helm upgrade auf Chart 10.1.4 (NICHT ausgefuehrt am 15.08.)
Stand 2026-08-15 ~03:40Z. S1+S2 GRUEN, S3-Valkey GRUEN + Values-Entwurf liegt vor.

## Warum nicht ausgefuehrt (gemessene Gruende)
1. Pipeline-Fenster: Nach der S2-Entwarnung (03:26Z) starten die wartenden Lande-Pushes der
   Hauptsession (gut-wie-wirst ACK: Push-Strecke wartete nur auf Entwarnung). Das fuer den
   Chart-Major noetige laengere leere Fenster (Migrationen + Redis-Cutover) ist nicht gegeben.
2. gitlab-backup-utility-Backup (Toolbox, Repos+Uploads+DB) hat unbestimmte Dauer (2x Gitaly
   50Gi-Persistenz); "frisch + literal belegt" ist Vorbedingung und braucht ein eigenes Fenster.
3. Redis-Cutover verwirft Sidekiq-Queues/Sessions im alten Subchart-Redis. Ohne Queue-Drain
   (sidekiq quiet -> Queues leer messen) droht Jobverlust. Gehoert in ein geplantes Fenster.
4. Major-Sprung Chart 9.11.8 (GitLab 18.11.7) -> 10.1.4 (GitLab 19.1.4): Upgrade-Path ueber
   den offiziellen Checker verifizieren (18.11 ist letzte 18er-Minor; ob 19.0/19.1 als Stop
   verlangt wird, VOR Ausfuehrung pruefen: https://gitlab-com.gitlab.io/support/toolbox/upgrade-path/
   Ziel "18.11.7 -> 19.1.4"; alternativ Zwischen-Upgrade auf Chart 10.0.x).

## Vorbedingungen (alle literal zu belegen, direkt vor Ausfuehrung)
- [ ] S1/S2/S3-Zustand unveraendert: kubectl get cluster gitlab-pg -n databases
      -> "2 2 Cluster in healthy state"; gitlab-valkey-0 1/1 + AUTH-PONG.
- [ ] Pipeline-Fenster leer + angekuendigt: p_ci_builds running+pending = 0 UND
      Owner/Session-GO fuer ~30-60 min Fenster (Ankuendigung an main wie bei S2).
- [ ] Frisches Voll-Backup: kubectl exec -n gitlab deploy/gitlab-toolbox -c toolbox --
      backup-utility --skip registry   (Ende-Literal "done" + Backup-Tar im Bucket
      gitlab-backups via s3cmd-config belegen). Zusaetzlich pg_dump wie in
      /root/strangA-backups/ (Muster strangA_s2_prep.sh).
- [ ] CNPG-On-Demand-Backup (Backup-CR method plugin) completed (Muster backup_post17.yaml).
- [ ] helm repo update; helm search repo gitlab/gitlab --version 10.1.4 -> Treffer literal.
- [ ] Upgrade-Path-Check (s.o.) dokumentiert.

## Ausfuehrung (seriell)
1. Sidekiq stilllegen + Queues leeren:
   a) kubectl scale deploy -n gitlab gitlab-sidekiq-all-in-1-v2 --replicas=0 erst NACHDEM
      Queues leer: toolbox: gitlab-rails runner "puts Sidekiq::Stats.new.enqueued" -> 0.
2. helm upgrade gitlab gitlab/gitlab --version 10.1.4 -n gitlab \
     -f /root/strangA-backups/VALUES_ENTWURF_chart-10.1.4_extern-valkey_s3cmd.yaml \
     --timeout 30m
   (Werte-Datei ERSETZT die User-Values vollstaendig; kein --reuse-values.)
3. Migrations-Job beobachten: kubectl get jobs -n gitlab | gitlab-migrations-* -> Complete;
   Logs auf "Migrating" Fehler pruefen.
4. Readiness: toolbox curl http://gitlab-webservice-default.gitlab.svc:8181/-/readiness?all=1
   -> alle Checks ok (insb. redis_check gegen Valkey).
5. Funktionsproben: Login (LDAP), Repo-Clone via shell.comdare.local, CI-Testpipeline,
   Registry-Pull. Sidekiq-Queues laufen auf Valkey an (Sidekiq::Stats.new.enqueued sinkt).
6. Altes Subchart-Redis: Pods gitlab-redis-node-* verschwinden mit redis.install=false;
   PVCs redis-data-gitlab-redis-node-* bleiben (ADDITIV BEHALTEN, nicht loeschen -
   Rollback-Reserve bis Owner-GO).
7. GitLab-Pipeline-Abnahme SERIELL je Repo (super, ce, 286/288) nach Doktrin.

## Rollback
- helm rollback gitlab 23 -n gitlab (Revision 23 = Chart 9.11.8) + redis.install-Subchart
  kommt zurueck (PVCs unangetastet). DB: PG-17-Cluster bleibt (GitLab 18.11 unterstuetzt PG 17
  nicht offiziell rueckwaerts? 18.11 lief auf 16; PG-Rollback NICHT noetig, 18.11.7 laeuft
  nachweislich auch gegen PG 17 NICHT verifiziert -> deshalb Rollback-Fenster kurz halten
  und im Zweifel Restore aus backup-utility-Tar + CNPG-Recovery aus gitlab-pg-v17-Pfad).

## S3-Nachtrag (Koordinator-Klaerung 15.08., ~03:45Z)
- KEIN Fremdakteur: Die 03:29:57Z-Objekte stammten aus Fassung 1 des eigenen S3-Skripts
  (vor Resume-Schnitt); die scheinbare Kollision war Eigen-Kollision zweier Fassungen.
- Toter Bestand ENTFERNT (Koordinator-GO, exakt drei, mit Vorher-/Nachher-Nachweis):
  Secret gitlab-valkey-auth (databases), Secret gitlab-valkey-auth (gitlab),
  Service gitlab-valkey-hl (databases). Laufende Kette unangetastet, PONG-Gegenprobe gruen.
- Governing Service gitlab-valkey ist NICHT headless: vom Koordinator AKZEPTIERTER
  dokumentierter Zustand. KEINE StatefulSet-Neuanlage vor dem Chart-10-Upgrade.
