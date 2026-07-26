# 20260726-runner-verortung-workflow / zugangsweg (agent a31fde28)

runId: wf_9c896c61-367
agentId: a31fde2829a753c3c
label-Zuordnung: zugangsweg (Prompt-Marker-Deckung 25%)

---

(a) IDENTITY-BACKEND prod1/prod2-SSH = LOKALE UNIX-KONTEN, KEIN AD/SSSD (live belegt auf prod1)
- prod1 = diese Maschine (`hostname`=prod1, Ubuntu 24.04.4). `/etc/nsswitch.conf`: passwd/group/shadow = `files systemd` (kein `sss`).
  `/etc/sssd/` existiert NICHT, `systemctl is-active sssd` = inactive, unit `not-found`, `realm`/realmd nicht installiert.
  => sshd authentifiziert ausschliesslich via PAM `pam_unix` gegen `/etc/shadow`. Kein Realm im Login-Pfad.
- Lokale Konten vorhanden: `admin-management` uid=1000 (NOPASSWD-sudo via `/etc/sudoers.d/90-admin-mgmt`), `comdare` uid=1001 (Gruppe sudo), `gitlab-runner` uid=996, `root`.
- Doku deckungsgleich: prod-Hosts sind per Design NICHT domain-joined — nur pve1/pve2/node3/node4 tragen Computer-Objekte
  (`docs/agent-memories-infra/INFRA-AGENT-MEMORIES-KONSOLIDIERT-20260708.md:8387`; `docs/architecture/AD-IDENTITAET-HAERTUNG-AUDIT.md:103`).
  `realm join PROD.COMDARE.DE` fuer prod1/prod2 ist bis heute nur OFFENE User-Anforderung
  (`docs/sessions/20260531-...-architektur-ziele-offene-punkte-ledger.md:837`, `.../20260624-21-12-003242-K81-59-...:327`).
- Realm-Landschaft nur fuer AD-Dienste relevant: dev = comdare.local, prod = comdare.de (`docs/sessions/2026-07-26-SESSION-ZWISCHENSTAND-PHASE5-ENTSCHEIDE-F1-SYNC.md:3`).

(b) AKTIVER VAULT-EINTRAG fuer admin-management-SSH (nur Label/Fundstelle, kein Wert)
- Es sind ZWEI VERSCHIEDENE ROLLEN mit fast gleichem Namen; das ist die Ursache des "Permission denied":
  1. `***CRED-NAME-REF:comdare-admin-management***` = AD-Tier-1-DOMAENENKONTO (GitLab-LDAP-Login, Roundcube, dcpromo, Alertmanager-SMTP).
     PROD-Realm-Rotation K105-INC 2026-07-15. Doku sagt woertlich, dass dieser Wert vom prod-SSH ABGELEHNT wird:
     `docs/sessions/20260629-14-04-003259-K81-84-...:73` ("...wird vom prod-SSH ABGELEHNT; prod-Login = das 9x-PW").
     => Der von Dir benutzte Eintrag ist per Doku der falsche; er hat auf prod1/prod2 gar keinen Konsumenten.
  2. `prod-admin-mgmt` (auch "prod-admin-management") = OS-/SSH-Passwort des LOKALEN Kontos, prod1+prod2 GETEILT.
     Explizit als "OS-PW prod1/2" gefuehrt: `docs/sessions/2026-07-19-K327d-E-W2-ROTATION-plan-...:23`; Task #159.4.
- Fundstellen dieser Rolle im Vault (Zeilen laut Report, Datei NICHT von mir geoeffnet):
  `keys/CREDENTIALS-VAULT-PROD.md` L261 (§Secret-Rotations-Register, P2) und L413 (§Rotations-Log-Nachtrag #113)
  — belegt in `docs/sessions/2026-07-26-W1-VAULT-ETAPPE2-REPORT.md:67`.
- Beide Zeilen sind seit 2026-07-26 additiv annotiert: Tag `509f3aef` = STALE/deaktiviert (built-in-Konto);
  AKTIV = "admin-management-Tag aus K105-Rotation 2026-07-13" (`.../2026-07-26-W1-VAULT-ETAPPE2-REPORT.md:69`,
  `.../2026-07-26-W1-VAULT-ETAPPE1-REPORT.md:60`, Erstmeldung `.../2026-07-22-IMPL-TO-INFRA-zombie-driver-prod1-stale-pw.md:17-19`).
- Der von Dir genannte "#113-Nachtrag = prod2-ssh" am Vault-Ende ist genau die STALE-Zeile (L413) — nicht benutzen.
- Der in der Offset-Tabelle sichtbare Eintrag mit Rotation 2026-07-13 ist der von der Doku gemeinte AKTIVE Kandidat
  (Datumsgleichheit; dev-seitige pwdLastSet 2026-07-13 vgl. `docs/sessions/2026-07-23-GIGA-SCRUB-INFRA-ROTATION-PLAN.md:174`).
  Da prod1 kein SSSD hat, ist die Realm-Etikette hier irrelevant — es ist ein lokal gesetztes Unix-Passwort mit diesem Wert.
- Vorgeschriebenes Zugriffsverfahren (nie cat/tail/grep auf value-tragende §Rotation-Log-Zeilen):
  feld-gezielte Extraktion per md5-Auswahl in-memory, Datei 0600, Ausgabe nur "MD5_OK", Transport per ssh-stdin-Pipe
  (`docs/sessions/2026-07-17-K108-SESSION-UEBERGABE-GESAMT-schema88-...:74`; `.../2026-07-18-K327b-rotation-marathon-...:26`).

(c) LOCKOUT-POLITIK — auf prod1 KEINE; AD-Lockout ebenfalls 0
- Live prod1: `/etc/security/faillock.conf` enthaelt ausschliesslich Kommentare (keine aktive Direktive);
  `/etc/pam.d/common-auth` fuehrt nur `pam_unix.so nullok` — KEIN pam_faillock, KEIN pam_tally2.
  fail2ban und sshguard: inactive bzw. nicht installiert. `MaxAuthTries` unkonfiguriert (Default 6, wirkt nur pro Verbindung).
  => Fehlversuche sperren das Konto NICHT; Risiko ist nur Log-Rauschen in journald/auth.log.
- AD-Seite (nur falls doch gegen einen DC gebunden wird): `account-lockout-threshold = 0` = KEIN Lockout, Kontroll-Binds
  ausdruecklich als gefahrlos dokumentiert (`docs/sessions/2026-07-23-GIGA-SCRUB-INFRA-ROTATION-PLAN.md:106`).
- Echtes Lockout-Risiko existiert nur bei OPNsense (pf-Tabelle `sshlockout`, ausgeloest durch PW-Auth-Expect-Skripte;
  Flush per `pfctl -t sshlockout -T flush`, `docs/WISSENS-PERSISTENZ-AUS-MEMORY.md:144-146`) und beim ZIH/eduVPN-Konto
  (GATED-USER, Account-Sperre-Risiko, `docs/VPN-ZUGRIFF.md:52`). Beides betrifft prod1/prod2-SSH nicht.

(d) ALTERNATIVE DOKUMENTIERTE WEGE (Reihenfolge = sauber vor Behelf)
1. SCHLUESSEL statt Passwort (kanonisch): `ssh -i ~/.ssh/cluster admin-management@10.0.10.211` / `.212`, dann NOPASSWD-sudo
   (`docs/sessions/20260622-00-00-003228-K81-47-...:34`, `.../20260625-11-24-003245-K81-61-...:94`, `.../20260622-...-003224-K81-43:17`).
   Auf prod1 zusaetzlich root per Key: `/etc/ssh/sshd_config.d/10-rootkey.conf` = `PermitRootLogin prohibit-password`
   (root-Key laut Doku nur auf prod1, `docs/sessions/20260624-14-05-003240-K81-57-...:69`); `ssh -i ~/.ssh/cluster root@10.0.10.211`.
2. LOKAL (prod1 = diese Maschine, kein SSH noetig): aktuelle Session laeuft als `comdare`, Gruppe `sudo`
   => `sudo -i` mit dem comdare@prod1-Passwort. Dieses ist eigenstaendig kanonisiert in §Rotation-Log (K81-62, Zeile 295) und
   in der §Offset-Tabelle indiziert (`docs/sessions/20260708-16-34-003303-K89b-...:27`); `comdare` hat KEIN NOPASSWD-sudo
   (`docs/sessions/2026-07-26-W1-VAULT-ETAPPE2-REPORT.md:126`) und `/etc/sudoers.d/comdare-sweep` ist eine eng gefasste Sweep-Regel.
   Das ist der kuerzeste Weg zu root auf prod1 ohne admin-management.
3. JUMP node7 (Pi5, 10.0.10.207): traegt den cluster-Key und historisch eine base64-PW-Datei fuer den prod2-sshpass-Weg
   (`docs/sessions/20260701-11-07-003268-K81-92-...:74`); `docs/VPN-ZUGRIFF.md:55` fuehrt node7 als Inside-Mgmt-Jump.
4. gitlab-runner-User: kein Login-Weg, sondern Ziel von `sudo -u gitlab-runner ...`/Job-Sweeps (z.B. Zombie-Driver-Kill,
   `docs/sessions/2026-07-22-IMPL-TO-INFRA-zombie-driver-prod1-stale-pw.md:10`); Runner-Ops per `gitlab-runner restart/verify`.
5. Physische/virtuelle Konsole: prod2-Runbook nennt "Pi5/node7 oder lokale Konsole" (`docs/RUNBOOK-prod2-14900KS-stabilitaetstest.md:4`);
   fuer Gaeste `virsh console` / qga (`docs/sessions/2026-07-17-K108-AJ-...:86`). 12_RUNBOOK_PRO_MACHINE.txt und
   08_BUILD_NODES_SETUP.txt enthalten KEINEN prod1/prod2-Zugangsweg (Stand v3, nur pve/odroid bzw. mac/RPi/VisionFive).

SELBSTCHECK: ASCII-only geprueft (grep -P '[^\x00-\x7F]' = 0 Treffer); keine Secret-Werte, keine maskierten Fragmente, nur Rollennamen/md5-Tags aus bestehender Doku; `Cluster/keys/` wurde nicht geoeffnet (Vault-Zeilennummern stammen aus Session-Reports).
