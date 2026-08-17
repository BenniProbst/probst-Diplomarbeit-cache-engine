# TALOS K-b EXPLORE — "neuerer Artikel" GEFUNDEN (17.08.2026, Agent talos-artikel-explore)

## VERDIKT
K1 = "What's New in Talos 1.13.0" / Release v1.13.0 vom 27.04.2026 ist der gemeinte
neuere Artikel (der Korpus zitiert woertlich den v1.12-Vorgaenger:
docs.siderolabs.com/talos/v1.12/getting-started/whats-new-in-talos,
Cluster/docs/sessions/20260218-...-upgrade-planung-version-audit.md:491).

## KANDIDATEN
- K1 (27.04.2026, TRAGEND): Changelog "feat: build and package perf binary" — perf wird
  fuer den Talos-Kernel gebaut, statisches Binary im Debugging-Container; NEU: "run and
  attach to the privileged debug container with a user-provided container image";
  Kernel 6.18.24, Powercap/Intel RAPL, irq time accounting.
- K2 (07.11.2025): Issue siderolabs/talos#12164 (@smira) + PR siderolabs/pkgs#1384 —
  Vorgeschichte (perf haengt an konkreter Kernel-Config).
- K3: Talos Process-Capabilities-Doku v1.13 — gesperrt sind NUR CAP_SYS_MODULE +
  CAP_SYS_BOOT; CAP_PERFMON und CAP_SYS_ADMIN NICHT gesperrt; machine.sysctls kann
  kernel.perf_event_paranoid setzen -> CE-DL2-Rezept in Talos abbildbar.
- K4: KVM mediated vPMU (tip/perf/core, Dez. 2025) — Richtungssignal, nicht tragend
  (Gast-vPMU mit -cpu host laeuft ohnehin seit Jahren).

## WIRKUNG AUF DEN BAUZUSCHNITT (KON108-K(b) "ohne PMC" TEIL-GEKIPPT)
Alte Streichungs-Begruendung UEBERHOLT: "Talos ist immutable ... kein PMC-Tooling/
Treiber (Intel-PCM/msr/PAPI/perf) installierbar" (Cluster K81-37 §Z2, 22.06.) gilt
seit 27.04.2026 nicht mehr.

ABER harte Grenze bleibt, an anderer Stelle (Host live gemessen, prod1):
  model: AMD Ryzen 9 9950X3D · perf_event_paranoid=1
  PMUs: cpu amd_df amd_l3 amd_umc_0 amd_umc_1 ibs_fetch ibs_op msr power
  nmi_watchdog=1
Nur die Core-PMU ("cpu") ueberlebt KVM. Uncore (amd_l3/df/umc), RAPL (power), IBS
werden NICHT durchgereicht — talos-versions-unabhaengig. nmi_watchdog=1 raubt dem
Gast einen Counter.

## KORRIGIERTER ZUSCHNITT (Empfehlung des Explores, als neue Kenntnisnahme b')
Talos = Debug-Messung auf der id15-Lane MIT Core-PMC (Cycles/Instructions/
L1-L2-Misses/LLC-misses als Core-Event); Uncore-/RAPL-/IBS-Zaehler bleiben der
Bare-Metal-Lane vorbehalten; weiterhin Debug-Klasse (VM-Rauschen, reduziertes
Counter-Budget). VORAUSSETZUNGEN: (1) Talos-Upgrade v1.12.4 -> v1.13.x (bringt
perf-Binary + privilegierten Debug-Container) — INFRA-EINGRIFF, Vertraeglichkeit
K8s v1.35/Longhorn/Calico v3.31.3/KubeVirt UNGEPRUEFT; (2) machine.sysctls
kernel.perf_event_paranoid<=1; (3) CAP_PERFMON am Job-Pod; (4) nmi_watchdog=0 am
Host vor jeder Talos-Messung. Zugabe (Reproduzierbarkeits-Knoepfe aus der
v1.13-Performance-Tuning-Doku): cpufreq.default_governor=performance,
amd_pstate=active, mitigations=off, iommu.passthrough=1.

## NICHT GEPRUEFT (vom Agenten offen deklariert)
1. Inhalt /etc/libvirt/qemu/talos-prod1.xml (0600, permission denied) — host-passthrough
   nur dokumentarisch (K81-35/37/38/40 fuenffach), <pmu state='on'/> offen.
2. Gast-seitiger PMU-Zustand in der Talos-VM.
3. Upgrade-Pfad-Vertraeglichkeit v1.12.4 -> v1.13.x.
4. Image-Name des perf-Containers.
5. Doku-Widerspruch: ZIELARCHITEKTUR-UND-ROADMAP-v9.1.md:25 "Talos Bare-Metal" vs.
   K81-Umkehr "Ubuntu-Bare-Metal + Talos-VM" (talos-prod1.xml stuetzt VM-Lesart).

## KORPUS-TEIL (Zweitbericht desselben Auftrags, Subagent)
Kein externer Artikel im Korpus; wichtigster interner Fund: Owner-Widerruf 08.08.
13:21 ("Die erste Diagnose war ZU SCHARF. Talos ist REAL ... FALSCH ist nur der
Allquantor jede Messung"; "Du liegst kritisch Falsch mit deinem Punkt, bitte lies
memory") — Rollentrennung ist die geltende Fassung, Verkuerzung "Talos spielt keine
Rolle" verboten.

# NACHTRAG WEB-TEIL 2 (vollstaendig, 18:49)

## SELBSTKORREKTUR des Agenten
"enable Powercap and Intel RAPL" gehoert zu v1.12.0 (22.12.2025), NICHT v1.13.

## W2 = HAERTESTER EINZELBELEG (neuer Kandidat neben W1)
Doku-Seite talos/v1.13/troubleshooting/talosctl-debug — existiert in v1.12 NICHT.
Debug-Container laeuft: privileged JA, Host-PID JA, Host-Network JA, Host-FS unter
/host, Host-Devices unter /dev. Aufruf: talosctl debug <image|tar>. Cave: Doku
demonstriert pwru, nennt perf nicht — Verbindung ueber die Changelog-Zeile gedeckt.

## W6 — vPMU-POSTEN KIPPT VOLLSTAENDIG (Auftrags-Irrtum korrigiert)
Talos-Node auf prod1 ist eine LIBVIRT/KVM-VM (talos-prod1.xml), NICHT KubeVirt
(das laeuft INNERHALB des Clusters). libvirt-Semantik: "If cpu_mode=host-passthrough
then it [PMU] will be enabled." -> vPMU ist mit dem dokumentierten host-passthrough
per DEFAULT AN — nie ein Bauposten gewesen. W7 (linux-kvm.org): -cpu host genuegt;
nmi_watchdog am Host reduziert Gast-Counter (live: =1 auf prod1 -> auf 0 vor Messung).

## EXTENSIONS-KATALOG: NULLBEFUND = BESTAETIGUNG DES WEGS
Keine perf-/profiling-/debug-Extension; Sidero loest perf bewusst als
Debug-Container-Image. Der d5-Posten "System Extension" war der falsche Ansatz.

## ZWEI WARNSIGNALE
1. kernel.perf_event_paranoid-Ist-Wert in Talos v1.12+ UNBEKANNT (KSPP-sysctls seit
   v1.12 verschaerft, Doku listet Werte nicht; Drittanbieter zeigt "3" als
   SELBSTSETZ-Empfehlung, kein Default-Beleg). EINZIGE verbliebene echte Unbekannte.
   Klaerung: talosctl read /proc/sys/kernel/perf_event_paranoid --nodes <ip>.
   Setz-Mechanismus machine.sysctls bestaetigt.
2. v1.14.0 GA GEPLANT 27.08.2026 (EINEN TAG NACH DEM BAU-TRIGGER) mit sandboxd
   (PID-/Mount-Namespace-Isolation fuer Runtime/kubelet/Pods) — PID-Isolation stoert
   perf-Profiling (abgeleitet, nicht belegt). EMPFEHLUNG: v1.13.x, den v1.14-Sprung
   bis NACH der Kampagne zurueckstellen.

## RELEASE-TABELLE
v1.12.0 22.12.2025 (Kernel 6.18.1, KSPP-sysctls, RAPL) · v1.12.4 = Live-Stand
(6.18.9) · v1.13.0 27.04.2026 (6.18.24, perf-Binary + Debug-Container, irq time
accounting) · v1.14.0-rc.1 14.08.2026 (6.18.44, sandboxd, GA 27.08.).

## BILANZ DER DREI GESTRICHENEN d5-POSTEN
System Extension: gestrichen, aber aus falschem Grund (Debug-Container-Image ist der
Weg) · Privilegierte Pods: KIPPT (talosctl debug privileged+Host-PID; CAP_PERFMON
frei) · vPMU: KIPPT (libvirt-Default bei host-passthrough).

# LIVE-MESSUNG AM OBJEKT (Lead, 18:52 — die letzte Unbekannte ist ZU)
talosctl read /proc/sys/kernel/perf_event_paranoid --nodes 10.0.110.183 -> "3" (rc=0)
talosctl version: Tag v1.12.4 (bestaetigt Live-Stand)
Zugang: ssh pve1 (10.0.10.201), Kontext redcomponent-k8s, Endpoint 10.0.10.181.
FOLGE: Warnsignal 1 BESTAETIGT — der Talos-KSPP-Default ist restriktiv (3 = kein
unprivilegiertes perf). Zwei Wege im Zuschnitt: (a) talosctl-debug-Container ist
PRIVILEGED -> funktioniert auch bei paranoid=3; (b) fuer normale Job-Pods mit nur
CAP_PERFMON ist die machine.sysctls-Lockerung auf <=1 PFLICHT (bei 3 reicht
CAP_PERFMON nicht). Beide Wege je nach Mess-Job-Form.
