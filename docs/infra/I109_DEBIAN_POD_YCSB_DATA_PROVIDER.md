# Infra-Task #109 — Debian-Pod als YCSB-Daten-Provider auf Development-Cluster

**Stand:** 2026-05-18 (Pre-flight-Spec)
**Trigger:** Task #109 (INFRA), OPEN-3 Erweiterung
**Anwender:** User (K8s-Cluster-Admin)
**Erwarteter Aufwand:** 1-2 Stunden K8s-Arbeit

> YCSB-Daten-Generator-Pod auf K8s. Liefert pro Messreihen-Run frische YCSB-Workload-A bis -F Datasets fuer den `messung_driver`.

---

## §1 Ziel

Debian-basierter K8s-Pod, der YCSB-Workload-Daten generiert und ueber HTTP/NFS dem `messung_driver` zur Verfuegung stellt — anstelle lokaler Sample-Daten-Generierung pro Lauf.

**Vorteile:**
- Deterministische Daten (gleicher Seed → gleiche Daten)
- Schnellere Lauf-Vorbereitung (Pod waermt im Hintergrund vor)
- Cluster-Multi-Tenancy (gleiche Daten fuer mehrere Diplomanden)

---

## §2 Pod-Spezifikation

### §2.1 Dockerfile

```dockerfile
FROM debian:12-slim

ARG YCSB_VERSION=0.17.0

RUN apt-get update && apt-get install -y \
    openjdk-17-jre-headless \
    wget \
    curl \
    nfs-common \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN wget https://github.com/brianfrankcooper/YCSB/releases/download/${YCSB_VERSION}/ycsb-${YCSB_VERSION}.tar.gz \
    && tar xzf ycsb-${YCSB_VERSION}.tar.gz \
    && mv ycsb-${YCSB_VERSION} ycsb \
    && rm ycsb-${YCSB_VERSION}.tar.gz

WORKDIR /workloads
COPY workloads-spec/ ./

WORKDIR /opt/ycsb
EXPOSE 8080
CMD ["python3", "-m", "http.server", "8080", "--directory", "/workloads-generated"]
```

### §2.2 Kubernetes-Manifest (Deployment + Service + PVC)

```yaml
# ycsb-data-provider.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ycsb-data-pvc
  namespace: diplomarbeit
spec:
  accessModes: [ReadWriteMany]
  storageClassName: longhorn-rwx
  resources:
    requests:
      storage: 50Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ycsb-data-provider
  namespace: diplomarbeit
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ycsb-data-provider
  template:
    metadata:
      labels:
        app: ycsb-data-provider
    spec:
      containers:
        - name: ycsb
          image: comdare/ycsb-data-provider:0.17.0
          ports:
            - containerPort: 8080
          volumeMounts:
            - mountPath: /workloads-generated
              name: ycsb-data
          resources:
            requests:
              memory: "4Gi"
              cpu: "2"
            limits:
              memory: "8Gi"
              cpu: "4"
          env:
            - name: YCSB_RECORD_COUNT
              value: "100000000"  # 100M records
            - name: YCSB_OPERATION_COUNT
              value: "10000000"   # 10M ops per workload
            - name: YCSB_SEED
              value: "42"          # Determinismus
      volumes:
        - name: ycsb-data
          persistentVolumeClaim:
            claimName: ycsb-data-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: ycsb-data-provider
  namespace: diplomarbeit
spec:
  selector:
    app: ycsb-data-provider
  ports:
    - port: 8080
      targetPort: 8080
  type: ClusterIP
```

### §2.3 Init-Job (einmal pro Pod-Start)

```yaml
# ycsb-data-init.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: ycsb-data-init
  namespace: diplomarbeit
spec:
  template:
    spec:
      containers:
        - name: init
          image: comdare/ycsb-data-provider:0.17.0
          command:
            - /bin/bash
            - -c
            - |
              cd /opt/ycsb
              for workload in workloada workloadb workloadc workloadd workloade workloadf; do
                  echo "=== Generating $workload ==="
                  ./bin/ycsb.sh load basic -P workloads/$workload \
                      -p recordcount=$YCSB_RECORD_COUNT \
                      -p insertorder=ordered \
                      -p insertseed=$YCSB_SEED \
                      > /workloads-generated/$workload-load.txt

                  ./bin/ycsb.sh run basic -P workloads/$workload \
                      -p recordcount=$YCSB_RECORD_COUNT \
                      -p operationcount=$YCSB_OPERATION_COUNT \
                      -p insertseed=$YCSB_SEED \
                      > /workloads-generated/$workload-run.txt
              done
          volumeMounts:
            - mountPath: /workloads-generated
              name: ycsb-data
      restartPolicy: OnFailure
      volumes:
        - name: ycsb-data
          persistentVolumeClaim:
            claimName: ycsb-data-pvc
```

---

## §3 messung_driver Integration

### §3.1 XML-Config-Erweiterung

```xml
<!-- test_data_xml/config_a_prt_art_vs_sota.xml -->
<dataset_source>
    <type>http</type>
    <url>http://ycsb-data-provider.diplomarbeit.svc.cluster.local:8080</url>
    <workloads>
        <workload>workloada</workload>
        <workload>workloadb</workload>
        <workload>workloadc</workload>
        <workload>workloadd</workload>
        <workload>workloade</workload>
        <workload>workloadf</workload>
    </workloads>
</dataset_source>
```

### §3.2 C++ HTTP-Client im messung_driver

```cpp
// Code/messung_driver/src/dataset_loader.cpp (V32+)
class HttpYcsbDatasetLoader {
public:
    void load_workload(std::string_view workload_name) {
        auto url = "http://ycsb-data-provider:8080/" +
                   std::string{workload_name} + "-run.txt";
        // ... HTTP-GET + parse YCSB-Trace ...
    }
};
```

---

## §4 Akzeptanz-Kriterien

- [ ] Pod `ycsb-data-provider` Running in `diplomarbeit` Namespace
- [ ] Init-Job hat 6 Workloads generiert (workloada-f, load+run je 12 Files)
- [ ] HTTP-GET `http://ycsb-data-provider:8080/workloada-load.txt` liefert YCSB-Trace
- [ ] PVC `ycsb-data-pvc` zeigt korrekte Belegung (ca. 30-50 GB)
- [ ] messung_driver kann ueber HTTP-Loader Workload abrufen

---

## §5 Determinismus + Reproducibility

- `YCSB_SEED=42` garantiert: gleicher Pod → gleiche Daten
- PVC ist persistent → Daten ueberleben Pod-Restart
- Bei Image-Update (neue YCSB-Version): Init-Job neu starten + alte Daten loeschen

---

## §6 Querverweise

- YCSB-Generator-CLI (lokal): `Code/sample_data_generator/` (V190 C1)
- Cluster-VLANs: VLAN 40 APPS (Pod-IP-Range), VLAN 80 BACKUP (Longhorn-Storage)
- Bausteine-Matrix YCSB-Mapping: `docs/bausteine/03_cross_paper_konzeptmatrix.md` §6
- Datasets-Spezifikation Original: `docs/termine/20260508 Termin 7/Datasets_Spezifikation.txt`

---

**Ende docs/infra/I109_DEBIAN_POD_YCSB_DATA_PROVIDER.md (Pre-flight-Spec DONE).**
