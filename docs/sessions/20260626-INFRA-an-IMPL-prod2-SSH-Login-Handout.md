# INFRA → IMPL-AGENT: prod2-SSH-Login — Handout (2026-06-26, FREIGESCHALTET)

**Von:** Infra-Agent · **An:** Implementierungsagent · **Betreff:** Login auf **prod2** ist jetzt offen (#97 gelöst)

## ✅ Status: prod2-SSH ist EINSATZBEREIT
Der **cluster-access-Key** wurde auf prod2 eingetragen (für **root** und **admin-management**) und **key-basiert verifiziert** (2026-06-26): `root@prod2` und `admin-management@prod2 (uid 1000, sudo)` antworten mit `hostname=prod2`.

## Einloggen
```bash
ssh -i ~/.ssh/cluster root@10.0.10.212            # wie prod1 (root, key-basiert)
# oder unprivilegiert + sudo:
ssh -i ~/.ssh/cluster admin-management@10.0.10.212 # uid 1000, hat sudo
```
- **Endpoint:** `prod2 = 10.0.10.212` (VLAN 10). Erreichbar vom **Admin-VPN** (Laptop) oder einem **V10-Host** (z.B. node7 10.0.10.207).
- **Key:** `~/.ssh/cluster` (Laptop) bzw. `keys/`-Vault (cluster-access ED25519 `SHA256:ubUMSQe24…H8Q`) — derselbe Key wie für prod1/node3/node4/pve1/pve2/node7.
- **prod2-Hostkey beim ersten Connect verifizieren:** ED25519 `SHA256:Uo4TUGxqWtuRpOggqaIClp5V811CKXd5t/eTUwKgonw`.

## Bei Re-Clone / neuem Host fehlt der Key?
Der öffentliche cluster-access-Key (falls erneut einzutragen):
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJwaERftv7pkgAiUtAI9EvFZPueTHX51MZByDu2YkziK cluster-access
```
→ in `~/.ssh/authorized_keys` (admin-management) bzw. `/root/.ssh/authorized_keys` (root) anhängen.

## Brauchst du prod2-SSH überhaupt?
- **K8s-CI: meist NEIN** — der prod-K8s-GitLab-Runner läuft gesund auf prod1; Jobs via `kubectl --kubeconfig /home/node7/.kube/config-prod-v32 -n gitlab-runner …` (von node7).
- **prod2-SSH nur für Host-Level:** TeX-Toolchain (#63), perf-Rechte `perf_event_paranoid<=1` (#82), `measure:intel`.
- ⚠️ **`measure:intel` + Toolchain (#63) sind aktuell durch die prod2-HW-Instabilität (i9-14900KS, #56) blockiert** — prod2 sackte 2026-06-25 ab (Kubelet), kam erst nach User-Neustart zurück (etcd wieder 3/3). Login geht, aber der Mess-Strang wartet auf den HW-Fix.

## Hinweis (Security)
Der Zugang ist key-basiert (cluster-access). Das lokale Root-/admin-management-Passwort war nur zur Einmal-Freischaltung nötig und wird rotiert/durch den Samba-AD-Join der prod-Nodes (#109) abgelöst — nicht für Routine-Logins verwenden. Tracking: #97 (gelöst), #113 (PW-Rotation).
