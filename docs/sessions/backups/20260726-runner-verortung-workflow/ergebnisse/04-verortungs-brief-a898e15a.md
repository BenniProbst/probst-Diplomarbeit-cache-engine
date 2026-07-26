# 20260726-runner-verortung-workflow / verortungs-brief (agent a898e15a)

runId: wf_9c896c61-367
agentId: a898e15a019edb7f5
label-Zuordnung: verortungs-brief (Prompt-Marker-Deckung 20%)

---

VERORTUNGS-BRIEF: Runner-Modi prod1/prod2 (Normal 3/2 + max 12 Threads | Voll-Bau/Messung 1 + phys. Kerne)

1) IST-STAND
- LIVE prod1 (read-only, jetzt): hostname=prod1, nproc=32, RAM total 60G / available ~27G, SWAP used ~17.5G.
  Unit `gitlab-runner` active, MainPID 3607759 (uptime 9h37m), Cmdline: `/usr/bin/gitlab-runner run --config
  /etc/gitlab-runner/config.toml --working-directory /home/gitlab-runner --service gitlab-runner --user gitlab-runner`
  => Manager laeuft als ROOT, Job-Shells als gitlab-runner. Der Doku-Widerspruch (root vs gitlab-runner) ist damit
  aufgeloest: beide Aussagen stimmen auf verschiedenen Ebenen; SIGHUP-Ziel ist der root-Manager.
- LIVE `systemctl show gitlab-runner`: ExecReload ist LEER (bestaetigt: Reload NUR per SIGHUP), KillMode=control-group
  (=> Zombie-Driver-Ursache bleibt der Cancel-Pfad, nicht die Unit).
- /etc/gitlab-runner/ ist fuer User comdare NICHT lesbar (Permission denied) => der Ist-Wert `concurrent` ist LIVE
  UNGEPRUEFT. Doku-Lage widerspruechlich: File=3 (Referenz 17.07.), Memory-Direktive=2, prod-Revision=1,
  Mess-Doktrin + User-Auflage 26.07. = 1 und GEWOLLT ("bei CI-Staus NICHT an der concurrency drehen").
- Host ist NICHT im Ruhezustand: zum Checkzeitpunkt 0 Runner-Job-Shells und 0 Compiler, Sekunden davor lief
  `clang++-22 -O3` unter User comdare (lokaler Bare-Metal-Bau, Code/build-i2, anderer Agent). Swap 17.5G belegt.
- Thread-Quellen (literal): statische CI `CMAKE_BUILD_PARALLEL_LEVEL: "6"` in allen drei .gitlab-ci.yml
  (super:96, ce:47, prt-art:37); Gruppen-Variable comdare (id=3, scope *) laut Infra-Doku = 10 => KONKURRENZ, der
  effektive Wert ist ungeklaert. Dynamische Planer-Jobs exportieren LITERAL 24 fuer amd UND intel
  (`libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:415`, Export :1005-1006/:1091/:1153),
  test-gepinnt in `tests/unit/thesis_tiere/test_experiment_plan_director.cpp:1345,1348,1350`.
- Effektive Compile-Threads = concurrent x Level. Budget-Doktrin LED:3230: prod1 32 Threads/24 Kerne,
  prod2 24 Threads/16 Kerne. Empirie W-44: prod1 32 Worker => ~20G Swap-Thrashing, daher Drossel auf 24.

2) UMSETZUNG (geordnet; Werte abgeleitet, nicht geraten)
S0 GO+Fenster: User-GO fuer Moduswechsel einholen (kollidiert mit Auflage 26.07.) und Fenster waehlen, in dem
   KEIN Voll-Bau/Mess-Lauf und kein lokaler Bare-Metal-Bau laeuft (jetzt ist ein solcher aktiv).
S1 Zugang: auf prod1 lokal `sudo -i` (comdare, Gruppe sudo, KEIN NOPASSWD) oder kanonisch
   `ssh -i ~/.ssh/cluster admin-management@10.0.10.211` bzw. `.212` (NOPASSWD-sudo). Vault-Rolle fuer OS-PW =
   `prod-admin-mgmt`, AKTIV ist der Tag aus der K105-Rotation 2026-07-13; die Zeile mit Tag 509f3aef ist STALE.
   Kein Lockout-Risiko auf prod1 (kein pam_faillock/fail2ban), nur Log-Rauschen.
S2 Werte-Ableitung (Deckel 12 ist Obergrenze, nicht Sollwert): Level = floor(Budget/concurrency), max 12
   => prod1 32/3 = 10, prod2 24/2 = 12. Ein EINZIGER globaler Level=10 erfuellt beide (prod1 3x10=30<=32,
   prod2 2x10=20<=24) und bleibt <=12 => EMPFEHLUNG Normal-Modus: prod1 concurrent=3, prod2 concurrent=2, Level=10.
   NIE 3x12=36 (>32) setzen - das war der Fehler vom 08.07. (prod2 ICE/OOM).
S3 Modus 2 (Voll-Bau/Messung): prod1+prod2 `concurrent=1`; die "physische Kerne"-Grenze ist im Mess-/Bau-Pfad
   BEREITS realisiert durch den Planer-Literal 24 (director:415) - KEIN Code-Eingriff. Statische CI bleibt in
   Modus 2 auf Level 6 (User-Deckel 25.06., LED:3172, von §61 nicht aufgehoben).
S4 Skript (sh, kein Python): NEU `/home/comdare/Projekte/Cluster/scripts/prod-runner-mode.sh`, committen im
   Infra-Repo Cluster (origin gitlab.comdare.local comdare/cluster/comdare-cluster-development, HEAD 185bb91),
   Stil wie `scripts/prod-runner-toolchain-setup.sh` (`#!/usr/bin/env bash`, `set -euo pipefail`, idempotent).
   Aufruf: `sudo bash prod-runner-mode.sh {normal|measure} [--dry-run] [--force]`. Ablauf hart in dieser Reihenfolge:
   (1) root-Check + Host-Map (`hostname`): prod1 normal=3, prod2 normal=2, measure=1 fuer beide; unbekannter Host => exit 2.
   (2) Ruhe-Gate: `pgrep -u gitlab-runner -f '/builds/'`, `pgrep -f 'comdare-messung-driver'`, `pgrep -x cc1plus`,
       `pgrep -f 'clang\+\+-2'` - jeder Treffer => Abbruch (KB-039 Regel 2: nur bei builds=0), nur `--force` uebergeht.
   (3) Backup ZUERST: `cp -a /etc/gitlab-runner/config.toml /etc/gitlab-runner/config.toml.bak-mode-$MODE-$(date +%Y%m%d)`.
   (4) Feldgezielter Edit NUR der globalen `concurrent`-Zeile oberhalb des ersten `[[runners]]` (awk-Rewrite in
       Temp-Datei mit 0600, dann `mv`); niemals `cat`/`tail`/`grep -v` auf die Datei ausgeben (cache.s3-SecretKey!).
       Ausgabe ausschliesslich `concurrent=<neu>`.
   (5) Reload: `kill -HUP "$(systemctl show -p MainPID --value gitlab-runner)"` - `systemctl restart` ist VERBOTEN.
   (6) Marker+Audit (Forderung "erkennbar/protokolliert"): `printf '%s\n' "$MODE" > /etc/gitlab-runner/.comdare-mode`
       und Append-Zeile Datum/Host/Modus/Werte in `/var/log/comdare/runner-mode.log`.
   (7) Verifikation aufrufen (Abschnitt 5) und bei Fehlschlag Backup zurueckspielen + erneut SIGHUP.
S5 Gruppen-/YAML-Variable ist NICHT Teil des Host-Skripts: `CMAKE_BUILD_PARALLEL_LEVEL` liegt in GitLab (Gruppe
   comdare id=3) und/oder in den drei .gitlab-ci.yml. Erst die effektive Quelle klaeren (O3), dann DORT 6->10 fuer
   Normal-Modus setzen; die andere Quelle angleichen, damit kein stiller Override entsteht.
S6 Doku: Supersede-Notiz in den Ledger (§61-Anker LED:3172 + LED:718/720) und neues Session-Doc unter
   `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/`, damit Level 10 im Normal-Modus
   nicht als Regression gegen den 6er-Deckel gelesen wird. prod1/prod2 synchron halten oder Divergenz begruenden.

3) CONSTRAINTS / FALLEN (einzuhalten)
- Kein `systemctl restart` (drainet Jobs, erzeugt Driver-Waisen, P8/Job 280514); nur SIGHUP, `concurrent` wird
  bei SIGHUP neu gelesen. Unit hat kein ExecReload (live bestaetigt).
- Secret-Disziplin: config.toml traegt den cache.s3-SecretKey; zwei dokumentierte Leaks. Nur feldgezielt.
- Fremd-Bundles `install-runner.sh`/`register-runner.sh` NIE ausfuehren (zerstoeren id16/id17).
- Tags nur additiv; DB-Tags (x86_64 + AVX512-Subflags) sind NICHT im File - Re-Register wuerde sie resetten (RUNN-23).
- Doktrin-Kollisionen: §62-B LED:3230 "ein Batch nutzt die Maschine exklusiv-voll" => concurrency>1 ist waehrend
  Batch-Compile/Messung verboten; §38.b/LED:2307 Mess-Exklusivitaet haengt am MODUS, nicht an resource_group
  (Fremd-Jobs laufen sonst daneben und verfaelschen Wall-Clock). Multi-Maschinen-Pflicht LED:3168 bleibt: keine
  globale resource_group als Serialisierungsmittel. O(Maschinen)-Gesetz LED:3213: keine zusaetzlichen Chunk-Jobs.
- RAM ist der Engpass, nicht CPU: prod1 swap 17.5G belegt, earlyoom auf prod1 INAKTIV/auf prod2 AKTIV; prod2
  62G mit 5 VMs (~12G Runner-Budget) und RMA/NVMe-gegated. Waehrend Voll-Bau-4 (>=30h) keine schweren Parallel-Jobs.
- `$(nproc)` ist verboten (LED:3172) - alle Werte literal. Eine prod2-Absenkung auf 16 waere ein test-gepinnter
  Code-Eingriff (test:1350 verbietet Literal "16"), kein Config-Dreh.
- Versions-Skew prod1 18.9.0 (apt-mark hold) vs prod2 19.1.1: Umschaltung aendert das nicht; RUNN-24 nicht mitziehen.
- `contacted_at` ist Redis-gecacht (20-40 min stale = normal) - kein Verifikationsbeleg.

4) OFFENE PUNKTE FUER DEN MANAGER
O1 GO-Pflicht: Auflage 26.07. sagt explizit "concurrency nicht drehen"; der Auftrag hebt sie fuer den Normal-Modus
   auf. Braucht literales User-GO im Session-Doc, sonst Regression gegen eine bestehende Direktive.
O2 Ist-Wert unbekannt: File=3/Memory=2/Revision=1/Live=? plus offenes Issue #295/DIPL-37. Vor dem Edit auf einen
   Ausgangswert einigen und Live+File beide messen (K90-Drift).
O3 Effektive Level-Quelle: Gruppen-Variable (Doku 10) vs .gitlab-ci.yml (literal 6) - Praezedenz nicht geraten,
   sondern aus einem echten Job-Log ablesen. Danach entscheiden, ob 10 in der Gruppe oder in den yml gesetzt wird.
O4 "Physische Kerne" ist ambivalent: Hardware prod1 = 16C/32T, prod2 = 24C/32T; Ledger LED:3230 sagt prod1 24 Kerne,
   prod2 16 Kerne; Code sagt 24/24. Vorschlag: Modus 2 = concurrent=1 + Planer-Literal 24 unveraendert. Bestaetigen.
O5 Zugangsweg: kein Blocker, aber Passwort-Beschaffung noetig (comdare-sudo lokal ODER cluster-Key als
   admin-management). Wer fuehrt aus - Infra-Agent mit Vault-Zugriff oder Manager interaktiv?
O6 prod2 ist per Doku nur Doku-Ist (nicht live geprueft, RMA-gegated) - vor dem Edit dort `gitlab-runner verify`.
O7 Wer schaltet zurueck? Ein automatischer Heuristik-Schalter ist untersagt (R8) - Modus 2 muss vor jedem Voll-Bau
   bewusst gesetzt werden; Vorschlag: verpflichtender S4-Aufruf als erster Schritt jeder Voll-Bau-Checkliste.

5) VERIFIKATION (literal, als root auf dem jeweiligen Host)
- Vorher/Nachher File-Wert (feldgezielt, kein cat):
  `awk '/^\[\[runners\]\]/{exit} /^[[:space:]]*concurrent[[:space:]]*=/{print FNR": "$0}' /etc/gitlab-runner/config.toml`
- Ruhe-Nachweis: `pgrep -u gitlab-runner -f '/builds/' ; pgrep -f comdare-messung-driver ; pgrep -x cc1plus` (alle leer)
- Reload: `kill -HUP "$(systemctl show -p MainPID --value gitlab-runner)"`
- Live-Wert/Ladebeleg: `journalctl -u gitlab-runner --since "2 min ago" | grep -E "Configuration loaded|max_builds"`
- Registrierung: `gitlab-runner verify` (Erwartung: "is valid", `prod-baremetal-prod1` bzw. `-prod2`)
- Unit gesund: `systemctl is-active gitlab-runner` (=active), `systemctl show gitlab-runner -p MainPID -p ExecReload`
- Backup existiert: `ls -l /etc/gitlab-runner/config.toml.bak-mode-*`
- Modus-Marker: `cat /etc/gitlab-runner/.comdare-mode ; tail -3 /var/log/comdare/runner-mode.log`
- Effektiver Level im Job: aus dem Job-Log-Abschnitt "Variables"/`echo "$CMAKE_BUILD_PARALLEL_LEVEL"` eines
  frischen Testjobs auf beiden Tags (amd/intel) - erst dieser Beleg schliesst O3.
- RAM-Gegenprobe nach erstem Normal-Modus-Lauf: `free -m` (available) + `grep -c '[c]c1plus\|[c]lang' <(ps -eo args)`
  gegen Budget 30 (prod1) / 20 (prod2); Ueberschreitung => sofort Modus 2.

SELBSTCHECK: ASCII-only geprueft (grep -P '[^\x00-\x7F]' = 0 Treffer); keine Secret-Werte/Fragmente, nur Rollennamen
und Fundstellen; Cluster/keys/ nicht geoeffnet; nichts geaendert (nur read-only Live-Checks auf prod1).
