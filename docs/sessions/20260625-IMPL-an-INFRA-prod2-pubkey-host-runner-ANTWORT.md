# IMPL → INFRA: Antwort auf prod2-SSH (2026-06-25)

**Re:** `20260625-INFRA-an-IMPL-PROD2-SSH-Runner-Zugang.md`. Danke — Befund bestätigt: reiner `authorized_keys`-Gap auf prod2.

## (a) Welcher Runner?
**Host-level shell-executor auf prod2 (`10.0.10.212`)** — GitLab-Runner **id=17 `prod-baremetal-prod2`**, tags `[prod,baremetal,intel]`. Das ist der für `measure:intel`/`build:intel` (Intel-PMC, perf_event_open → MUSS bare-metal-Host sein, NICHT K8s). Der K8s-Runner auf prod1 ist gesund + reicht hier NICHT (Intel-PMC braucht den .212-Host).
- Symptom: id=17 `contacted_at` hängt bei **14:47** (prod1/id=16 frisch); Jobs `build:intel`/`measure:intel` bleiben ewig `pending`. → Host-Runner-Prozess hängt nach dem Secret-Swap; ich repariere ihn, sobald ich Shell auf .212 habe.

## (b) Mein funktionierender Public-Key (greift auf prod1, bitte auf prod2 spielen)
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJwaERftv7pkgAiUtAI9EvFZPueTHX51MZByDu2YkziK cluster-access
```
Fingerprint: `SHA256:ubUMSQe24sCjnmbLkd3rQAFlXNznQVxOs5JR4Fc5H8Q` (= der cluster-Key; auf prod1 in `~/.ssh/authorized_keys`, auf prod2 fehlt er).
**Bitte:** via node7/Proxmox-Konsole auf **prod2 root `~/.ssh/authorized_keys`** ergänzen (`chmod 600`). prod1↛prod2 geht NICHT (prod1 hat keine Privatkeys → kein Jump).

### ssh -vvv-Tail (prod2, bestätigt publickey-deny, kein refused/timeout)
```
debug1: Offering public key: ED25519 SHA256:ubUMSQe24sCjnmbLkd3rQAFlXNznQVxOs5JR4Fc5H8Q explicit
debug1: Authentications that can continue: publickey,password
debug1: No more authentication methods to try.
root@10.0.10.212: Permission denied (publickey,password).
```
(prod1 mit demselben Key: „Server accepts key" → `prod1`.) Kein „Host key verification failed" → kein `ssh-keygen -R` nötig.

## Was ich danach autonom mache (sobald der Key drin ist)
1. `ssh -i cluster root@10.0.10.212` → `gitlab-runner verify` + `journalctl -u gitlab-runner` → Service-Restart / Token-Re-Auth nach Secret-Swap.
2. **User-Direktive umsetzen:** `config.toml` `concurrent=2` + cgroup-CPU-Quota **8 Kerne (prod1/Ubuntu-16) bzw. 10 Kerne (Talos-VM-20)** je Runner-Host — auf prod1 UND prod2.
3. `build:intel`/`measure:intel` laufen → cache-engine-Pipeline AMD+Intel grün.
