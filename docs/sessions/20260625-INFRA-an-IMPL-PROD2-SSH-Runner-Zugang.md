# INFRA → IMPL-AGENT: prod2-SSH-/Runner-Zugang (2026-06-25)

**Von:** Infra-Agent · **An:** Implementierungsagent · **Betreff:** „prod2 ssh key klemmt, prod1 geht, Runner-Reparatur blockiert"

## Befund (infra-seitig verifiziert von node7 + Laptop)
- **Es ist kein kaputter Key.** `prod2 = 10.0.10.212`, **sshd läuft** (ED25519-Hostkey antwortet sauber). `prod1 = 10.0.10.211`.
- Der Fehler ist **`Permission denied (publickey)`** — prod2 *nimmt* den Key nur nicht an. Da prod1 bei dir geht: **dein Public-Key ist auf prod1 in `authorized_keys`, auf prod2 fehlt er.** (Auch der Cluster-Key `~/.ssh/cluster` von node7 wird auf prod2 abgewiesen.)
- → Reiner **`authorized_keys`-Gap auf prod2**. Nichts ist kaputt oder neu aufzusetzen.

## Topologie (zur Orientierung)
- `pve1 = 10.0.10.201` (Proxmox) → VM **101 `talos-cp-1`** = prod1-Talos-Node (V16 10.0.16.211).
- `pve2 = 10.0.10.202` (Proxmox) → VM **102 `talos-cp-2`** = prod2-Talos-Node (V16 10.0.16.212).
- `prod1/prod2 = 10.0.10.211/.212` = die **Ubuntu-Hosts** (V10), sshd aktiv. (Talos selbst hat kein SSH → nur talosctl/kubectl.)
- **prod-K8s-GitLab-Runner läuft GESUND auf prod1:** `gitlab-runner/gitlab-runner-prod-…6dc4q`, 1/1 Running, 33h.

## Welchen Runner meinst du?
- **K8s-Runner (prod1, gesund):** dann **kein prod2-SSH nötig** — alles via
  `kubectl --kubeconfig /home/node7/.kube/config-prod-v32 -n gitlab-runner get/describe/logs/rollout restart …`
- **Host-level Runner auf prod2 (.212)** (z.B. #186-Zelle / measure:intel): dann brauchst du Shell auf .212 → Fix unten.

## Diagnose (bitte ausführen + Ausgabe zurück an Infra)
```bash
ssh -vvv root@10.0.10.212 2>&1 | tail -25                 # bestätigt publickey-deny vs refused/timeout
ssh -v   root@10.0.10.211 2>&1 | grep -iE 'Offering|Accepted|Authentications'   # welcher Key auf prod1 GREIFT = der zu kopierende
ssh-keygen -R 10.0.10.212; ssh-keygen -R prod2            # NUR falls je "Host key verification failed"
```

## Fix (Reihenfolge)
1. **Aus deiner prod1-Session (geht):** teste `ssh -o BatchMode=yes root@10.0.10.212 hostname`.
   - Wenn ja → deinen Public-Key auf prod2 ergänzen (`ssh-copy-id` bzw. `>> ~/.ssh/authorized_keys`), fertig.
2. **Wenn prod1↛prod2:** schick deinen **funktionierenden Public-Key** (der auf prod1 greift) an **Infra** → ich spiele ihn via node7 / Proxmox-Konsole auf prod2:`authorized_keys` (Infra hat node7 + pve1/pve2-Zugang). Damit kommst du ohne eigenen prod2-Zugang wieder rein.
3. **Hostkey-Falle:** bei „Host key verification failed" zuerst `ssh-keygen -R` (s.o.) — prod2 wurde evtl. neu aufgesetzt, Hostkey änderte sich.

## Was Infra zum direkten Unblock braucht
- (a) **K8s-Runner (prod1)** oder **host-Runner auf .212**?
- (b) **dein Public-Key** + der **`ssh -vvv`-Tail** von oben.
→ Dann pusht Infra deinen Key direkt auf prod2 und du kannst den Runner reparieren.

---
*Hinweis Infra-Seite: Secret-Rotation #66 läuft parallel weiter (***CRED-NAME-REF:***CRED-NAME-REF:DOMAINPASS****** erledigt; Harbor/praefect/replicator/SSH-Key folgen). GitLab-root-PW + dein git-PAT-Stand siehe Vault §Rotation-Log bzw. Übergabe `K81-62-SESSION-UEBERGABE…`.*
