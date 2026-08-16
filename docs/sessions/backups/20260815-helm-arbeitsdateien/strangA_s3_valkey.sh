#!/usr/bin/env bash
# STRANG A / S3: externes Valkey 7.2 im databases-NS (klein, persistent) + Secret-Kopie fuer gitlab-NS
# Idempotent: Passwort nur erzeugen, wenn Secret fehlt; kubectl apply ueberall.
set -u
export KUBECONFIG=/root/.kube/config

echo "=== Keys im Secret gitlab-object-storage (nur Namen) ==="
kubectl get secret gitlab-object-storage -n gitlab -o jsonpath='{.data}' | python3 -c "import sys,json;print(sorted(json.load(sys.stdin).keys()))"
echo "RC_KEYS=$?"

echo "=== Valkey-Auth-Secret (nur anlegen wenn fehlt) ==="
if kubectl get secret gitlab-valkey-auth -n databases >/dev/null 2>&1; then
  echo "SECRET_EXISTS=yes"
else
  echo "SECRET_EXISTS=no -> erzeuge"
  PW=$(openssl rand -hex 20)
  kubectl create secret generic gitlab-valkey-auth -n databases --from-literal=password="$PW"
  echo "RC_SEC_DB=$?"
  kubectl create secret generic gitlab-valkey-auth -n gitlab --from-literal=password="$PW"
  echo "RC_SEC_GL=$?"
  unset PW
fi

echo "=== Manifeste anwenden ==="
cat > /root/strangA-backups/valkey_gitlab.yaml <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: gitlab-valkey-hl
  namespace: databases
  labels:
    app: gitlab-valkey
    app.kubernetes.io/part-of: gitlab
spec:
  clusterIP: None
  selector:
    app: gitlab-valkey
  ports:
  - name: valkey
    port: 6379
    targetPort: 6379
---
apiVersion: v1
kind: Service
metadata:
  name: gitlab-valkey
  namespace: databases
  labels:
    app: gitlab-valkey
    app.kubernetes.io/part-of: gitlab
spec:
  type: ClusterIP
  selector:
    app: gitlab-valkey
  ports:
  - name: valkey
    port: 6379
    targetPort: 6379
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: gitlab-valkey
  namespace: databases
  labels:
    app: gitlab-valkey
    app.kubernetes.io/part-of: gitlab
spec:
  serviceName: gitlab-valkey-hl
  replicas: 1
  selector:
    matchLabels:
      app: gitlab-valkey
  template:
    metadata:
      labels:
        app: gitlab-valkey
        app.kubernetes.io/part-of: gitlab
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 999
        runAsGroup: 999
        fsGroup: 999
      containers:
      - name: valkey
        image: valkey/valkey:7.2.12
        command:
        - sh
        - -c
        - exec valkey-server --appendonly yes --appendfsync everysec --dir /data --requirepass "$VALKEY_PASSWORD"
        env:
        - name: VALKEY_PASSWORD
          valueFrom:
            secretKeyRef:
              name: gitlab-valkey-auth
              key: password
        ports:
        - name: valkey
          containerPort: 6379
        resources:
          requests:
            cpu: 100m
            memory: 256Mi
          limits:
            memory: 1Gi
        readinessProbe:
          exec:
            command:
            - sh
            - -c
            - valkey-cli --no-auth-warning -a "$VALKEY_PASSWORD" ping | grep -q PONG
          initialDelaySeconds: 5
          periodSeconds: 10
        livenessProbe:
          tcpSocket:
            port: 6379
          initialDelaySeconds: 15
          periodSeconds: 20
        volumeMounts:
        - name: data
          mountPath: /data
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      storageClassName: longhorn-database
      resources:
        requests:
          storage: 5Gi
EOF
kubectl apply -f /root/strangA-backups/valkey_gitlab.yaml
echo "RC_APPLY=$?"

echo "=== Warten auf Ready ==="
kubectl rollout status statefulset/gitlab-valkey -n databases --timeout=240s
echo "RC_ROLLOUT=$?"
kubectl get pods -n databases -l app=gitlab-valkey -o wide
kubectl get pvc -n databases -l app=gitlab-valkey
