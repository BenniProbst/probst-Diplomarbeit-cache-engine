#!/usr/bin/env bash
# STRANG A / S3-Cleanup v1 (Koordinator-GO 15.08.): GENAU drei ungenutzte Objekte loeschen,
# sonst NICHTS. Laufende Kette (StatefulSet gitlab-valkey, Service gitlab-valkey,
# Secret gitlab-valkey-password x2, PVC) bleibt unangetastet.
# Versioniert (v1) statt Ueberschreiben - Prozess-Lehre 3.
set -u
export KUBECONFIG=/root/.kube/config

echo "=== VORHER: Nichtnutzung nachweisen ==="
echo "-- StatefulSet referenziert Secret:"
kubectl get statefulset gitlab-valkey -n databases -o jsonpath='{.spec.template.spec.volumes[0].secret.secretName}'
echo
echo "-- StatefulSet governing serviceName:"
kubectl get statefulset gitlab-valkey -n databases -o jsonpath='{.spec.serviceName}'
echo
echo "-- Ziel-Objekte existieren:"
kubectl get secret gitlab-valkey-auth -n databases -o name
kubectl get secret gitlab-valkey-auth -n gitlab -o name
kubectl get svc gitlab-valkey-hl -n databases -o name
echo "RC_PRE=$?"

echo "=== LOESCHUNG (exakt drei) ==="
kubectl delete secret gitlab-valkey-auth -n databases
echo "RC_DEL1=$?"
kubectl delete secret gitlab-valkey-auth -n gitlab
echo "RC_DEL2=$?"
kubectl delete svc gitlab-valkey-hl -n databases
echo "RC_DEL3=$?"

echo "=== NACHHER: drei weg, laufende Kette steht ==="
kubectl get secret gitlab-valkey-auth -n databases 2>&1 | head -1
kubectl get secret gitlab-valkey-auth -n gitlab 2>&1 | head -1
kubectl get svc gitlab-valkey-hl -n databases 2>&1 | head -1
kubectl get statefulset gitlab-valkey -n databases
kubectl get pods -n databases -l app=gitlab-valkey
kubectl get svc gitlab-valkey -n databases
kubectl get secret gitlab-valkey-password -n databases -o name
kubectl get secret gitlab-valkey-password -n gitlab -o name
kubectl get pvc data-gitlab-valkey-0 -n databases --no-headers
echo "RC_POST=$?"
echo "=== Funktions-Gegenprobe nach Loeschung ==="
kubectl exec -n databases gitlab-valkey-0 -- sh -c 'valkey-cli --no-auth-warning -a "$(cat /etc/valkey-auth/password)" ping'
echo "RC_PING=$?"
