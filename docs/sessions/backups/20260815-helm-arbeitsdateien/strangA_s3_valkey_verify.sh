#!/usr/bin/env bash
# STRANG A / S3: Valkey haerten + Funktions- und Persistenz-Beweis
set -u
export KUBECONFIG=/root/.kube/config

echo "=== SecurityContext-Haertung (PodSecurity-Warnung beheben) ==="
kubectl patch statefulset gitlab-valkey -n databases --type strategic -p '{
  "spec": {"template": {"spec": {
    "securityContext": {"runAsNonRoot": true, "runAsUser": 999, "runAsGroup": 999, "fsGroup": 999,
      "seccompProfile": {"type": "RuntimeDefault"}},
    "containers": [{"name": "valkey",
      "securityContext": {"allowPrivilegeEscalation": false, "capabilities": {"drop": ["ALL"]}}}]
  }}}
}'
echo "RC_HARDEN=$?"
kubectl rollout status statefulset/gitlab-valkey -n databases --timeout=180s
echo "RC_ROLLOUT1=$?"

echo "=== PVC-Beleg ==="
kubectl get pvc data-gitlab-valkey-0 -n databases
echo "RC_PVC=$?"

echo "=== Funktionsprobe SET/GET (Auth via REDISCLI_AUTH) ==="
kubectl exec -n databases gitlab-valkey-0 -- sh -c 'REDISCLI_AUTH="$(cat /etc/valkey-auth/password)" valkey-cli set strangA_probe pg17-vorstrecke-20260815'
echo "RC_SET=$?"
kubectl exec -n databases gitlab-valkey-0 -- sh -c 'REDISCLI_AUTH="$(cat /etc/valkey-auth/password)" valkey-cli get strangA_probe'
echo "RC_GET=$?"

echo "=== Version literal ==="
kubectl exec -n databases gitlab-valkey-0 -- sh -c 'REDISCLI_AUTH="$(cat /etc/valkey-auth/password)" valkey-cli info server' | head -6
echo "RC_INFO=${PIPESTATUS[0]}"

echo "=== Persistenz-Beweis: Pod loeschen, Wert muss ueberleben ==="
kubectl delete pod gitlab-valkey-0 -n databases
echo "RC_DELPOD=$?"
kubectl rollout status statefulset/gitlab-valkey -n databases --timeout=180s
echo "RC_ROLLOUT2=$?"
kubectl exec -n databases gitlab-valkey-0 -- sh -c 'REDISCLI_AUTH="$(cat /etc/valkey-auth/password)" valkey-cli get strangA_probe'
echo "RC_GET2=$?"

echo "=== NOAUTH-Gegenprobe (ohne Passwort muss es scheitern) ==="
kubectl exec -n databases gitlab-valkey-0 -- valkey-cli get strangA_probe
echo "RC_NOAUTH=$? (erwartet !=0 oder NOAUTH-Fehlertext)"
