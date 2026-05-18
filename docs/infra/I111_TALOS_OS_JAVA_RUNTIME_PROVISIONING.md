# Infra-Task #111 — Talos OS Java-Runtime Provisioning fuer Production-Test

**Stand:** 2026-05-18 (Pre-flight-Spec)
**Trigger:** Task #111 (INFRA), aus Agent-Verifikation
**Anwender:** User (Talos-OS-Admin)
**Erwarteter Aufwand:** 30-60 Min Talos-Konfiguration + Reboot

> Talos OS ist minimal und enthaelt KEIN Java per Default. Fuer Production-Tests von Java-basierten Workloads (z.B. YCSB-Provider in #109) muss Java explizit provisioniert werden.

---

## §1 Ziel

Java OpenJDK 17 als System-Extension in Talos OS verfuegbar machen — damit Workload-Pods (YCSB, evtl. weitere JVM-basierte Tools) ohne Container-Image-internen JVM laufen koennen (kompakter Container).

**Wichtig:** Talos OS-Direktive (Memory): "Talos OS hat KEIN Python" — analog gilt: KEIN Java per Default. Provisioning erfolgt via Talos-System-Extension oder ueber Container-Image mit eingebettetem JVM.

---

## §2 Zwei Loesungs-Optionen

### §2.1 Option A — Java im Container-Image (Standard, empfohlen)

Vorteil: keine Talos-Aenderung erforderlich. Jeder Pod bringt eigene JVM mit (siehe #109 Debian-Pod-Spec hat OpenJDK 17 im Image).

Nachteil: groessere Container-Images (~200MB pro Pod).

**Entscheidung:** Fuer #109 YCSB-Provider Option A bereits umgesetzt (Dockerfile mit OpenJDK 17).

### §2.2 Option B — Java als Talos-System-Extension

Vorteil: schlanker Container ohne JVM, alle Pods teilen sich Host-JVM.

Nachteil: Talos-Custom-Image-Build erforderlich + Reboot der Nodes.

**Entscheidung:** Fuer Production-Test pruefen ob lohnend (mehrere Pods muessten Java teilen).

---

## §3 Option B Detail-Plan — Talos-System-Extension Java OpenJDK 17

### §3.1 Talos-Image-Customizer

Talos bietet `imager`-Tool fuer Custom-Images mit System-Extensions:

```bash
docker run --rm -i \
  --privileged \
  -v /dev:/dev \
  ghcr.io/siderolabs/imager:v1.7.0 \
  installer \
  --base-installer-image=ghcr.io/siderolabs/installer:v1.7.0 \
  --system-extension-image=ghcr.io/siderolabs/openjdk:17 \
  > talos-openjdk17.tar
```

### §3.2 System-Extension-Manifest

```yaml
# talos-machine-config-patch.yaml
machine:
  install:
    image: ghcr.io/siderolabs/installer:v1.7.0
    extensions:
      - image: ghcr.io/siderolabs/openjdk:17
```

### §3.3 Talos-Apply auf Nodes

```bash
# Pro Node:
talosctl --nodes=192.168.40.10 apply-config \
  --patch @talos-machine-config-patch.yaml

# Reboot erforderlich:
talosctl --nodes=192.168.40.10 reboot
```

### §3.4 Verifikation

```bash
talosctl --nodes=192.168.40.10 read /usr/local/bin/java
# Erwartung: OpenJDK 17 Binary verfuegbar
```

---

## §4 Empfehlung

**Phase 1 (V32+ Sprint):** Option A nutzen (Container mit JVM, kein Talos-Eingriff). Fuer Diplomarbeit-Production-Test ausreichend.

**Phase 2 (Cluster-Optimierung, zukuenftig):** Option B fuer dauerhafte Multi-Pod-JVM-Sharing pruefen, falls Speicher-Footprint kritisch wird.

---

## §5 Akzeptanz-Kriterien

### Option A (umgesetzt via #109)
- [ ] YCSB-Pod laeuft mit eingebetteter JVM
- [ ] Java-Workloads laufen ohne Talos-Aenderung

### Option B (deferred, pruefen ob noetig)
- [ ] Talos-Custom-Image mit OpenJDK 17 gebaut
- [ ] System-Extension auf allen Nodes appliziert
- [ ] Container ohne eigene JVM kann Host-Java nutzen

---

## §6 Risiken

- Talos-System-Extensions sind eine relativ neue Funktion — Stabilitaet pruefen
- Reboot eines Nodes unterbricht laufende Pods (Drain + Cordon erforderlich)
- Bei Memory-Direktive "Talos OS hat KEIN Python": Java-Extension darf nicht durch andere User-Direktiven blockiert sein

---

## §7 Querverweise

- Talos OS Cluster-Architektur Memory: `cluster_system_architecture`
- VLAN 120 VM (Talos Nodes): User-CLAUDE.md
- Cluster-Migration #77: `I77_CLUSTER_MIGRATION_FORTIGATE_GITLAB.md`
- Debian-Pod #109: `I109_DEBIAN_POD_YCSB_DATA_PROVIDER.md` (Option A bereits umgesetzt)
- Talos OS Doku: https://www.talos.dev/v1.7/talos-guides/configuration/system-extensions/

---

**Ende docs/infra/I111_TALOS_OS_JAVA_RUNTIME_PROVISIONING.md (Pre-flight-Spec DONE).**
