# ANWEISUNG: der intel-Mess-Lane echte PMC-Rechte geben

Stand 2026-08-06, spätabends. Grundlage: ce-Pipelines 15104/15110, Jobs `pmc:intel` (365187/365257)
und `pmc:amd` (365186/365256), dazu eigene Messungen auf prod1 (siehe §1.3).
Alle Zahlen unten sind am Objekt geholt, nicht zitiert.

---

## 1. Der Befund in drei Sätzen

**Satz 1 — Die perf-Rechte der intel-Lane sind bereits vorhanden und wirksam.**
Im *selben* roten Job 365257 auf prod2 steht 0,47 s nach dem Fehlschlag wörtlich:

```
329: delta.available             = 1
329: delta.cache_misses_l1       = 6701028
329: delta.cache_misses_l3       = 4048837
329: delta.dtlb_misses           = 3314004
329: SMOKE_OK (live PMC, >=1 counter populated)
2/2 Test #329: linux_perf_pmc_smoke .............   Passed    0.47 sec
```

`perf_event_open(2)` gelingt auf prod2, alle drei Zähler öffnen, alle drei liefern echte
Hardware-Werte. `perf_event_paranoid` ist auf **beiden** Hosts `1` (Trace 365256 Z. 77 f.,
Trace 365257 Z. 75 f.), Executor ist auf beiden `shell`/baremetal, **kein Container** —
`cap_add`/seccomp sind für diese Lane gegenstandslos.

**Satz 2 — Rot ist ein anderer Test, und der misst ein leeres Fenster.**
Es failt ausschließlich `m3v2_pmc_smoke` (Test 304, 0,01 s). Zwischen `begin()` und `end()`
steht in `tests/unit/thesis_tiere/m3v2_pmc_smoke.cpp:42-43` **nichts**:

```cpp
    pmc->begin();
    ::comdare::cache_engine::measurement::PmcCounters const delta = pmc->end();
```

Die Diagnosezeile des Tests widerspricht sich selbst und belegt damit den Punkt:
`pmc_source.available = 1` (die fds sind offen) neben `pmc_available=0` (das Delta ist ungültig).
Die vom Test genannten Ursachen („perf_event_paranoid, CAP_PERFMON/Executor-Rechte, Container ohne
perf") sind **hartkodierter Text, keine Messung** — der Test kann „kein Zugriff" von „Zugriff, aber
Nullfenster" nicht unterscheiden und zeigt hier in die falsche Richtung.

**Satz 3 — Eine Rechte-Änderung macht Job 365257 nicht grün.**
`LinuxPerfPmcSource::end()` setzt `available=true`, sobald *ein* `read_scaled()` mit `ok=true`
zurückkommt — **wertunabhängig**. `available=0` heißt also zwingend: alle Reads lieferten
`ok=false`. Da Test 329 im selben Prozess drei gültige Reads macht, bleibt genau ein Zweig übrig
(`linux_perf_pmc_source.hpp:141`):

```cpp
    if (d.t_running == 0) return 0; // Counter lief nie (Multiplexing-Verdrängung) → ungültig.
```

**Auf prod2 hat der Zähler im Nullfenster keine PMU-Laufzeit akkumuliert. Das ist kein Rechteproblem.**

### 1.1 Warum `t_running == 0` — UNBELEGT, drei Kandidaten, ein Test entscheidet

Ich habe die Ursache **nicht** belegt und rate nicht. Drei Kandidaten:

| # | Kandidat | Signatur im Test aus §2 Schritt 0 |
|---|---|---|
| K1 | Hybrid-PMU (i9-12900K: `cpu_core`/`cpu_atom`). Ein Legacy-`PERF_TYPE_HW_CACHE`-Event ist an *eine* PMU gebunden; läuft der Task auf dem anderen Core-Typ, ist es *enabled but not running*. | `cpu_core.type != 0` **und** `t_enabled > 0, t_running == 0` im Leerfenster **und** Abschnitt C (explizit auf `cpu_core`) liefert `t_running > 0` |
| K2 | Event-Installationslatenz: `ENABLE` installiert das Event asynchron; im Sub-Mikrosekunden-Fenster ist es noch nicht auf der Hardware. | `t_enabled > 0, t_running == 0` im Leerfenster, aber schon im Fenster „winzig"/„kurz" `t_running > 0`; Abschnitt C ändert nichts |
| K3 | Zeitgranularität: das Fenster ist so kurz, dass beide Zeiten auf 0 runden. | `t_enabled == 0 && t_running == 0` |

Auf prod1/AMD ist **keiner** der drei aktiv — dort habe ich das Leerfenster selbst gefahren:
`t_enabled = 5580 ns, t_running = 5580 ns, value = 0, ok = true`. Genau deshalb ist die amd-Lane
grün: nicht wegen eines Messwerts (`value` war **0**), sondern weil `t_running != 0` ist.

### 1.2 Der EINE Befehl, der K1/K2/K3 unterscheidet

Steht als kopierbarer Block in §2, Schritt 0. Er braucht **kein root** und ändert nichts.

### 1.3 Es gibt eine echte Rechte-Lücke — aber eine andere

Selbst gemessen auf prod1 (`perf_event_paranoid=1`, als unprivilegierter Nutzer, heute):

```
power/energy-pkg (type=14,cfg=0x02) systemweit pid=-1 cpu=0 -> FEHLGESCHLAGEN errno=13 (Permission denied)
power_core/energy-core (type=15,cfg=0x01) sysw. pid=-1 cpu=0 -> FEHLGESCHLAGEN errno=13 (Permission denied)
HW_CACHE L1D/READ/MISS cpu-weit                pid=-1 cpu=0 -> FEHLGESCHLAGEN errno=13 (Permission denied)
HW_CACHE L1D exclude_kernel=0                  pid=0 cpu=-1 -> OK fd=3
```

Und die zweite Lücke, ebenfalls selbst geprüft:

```
$ ls -l /sys/class/powercap/intel-rapl:0/energy_uj
-r-------- 1 root root 4096 Aug  6 21:18 /sys/class/powercap/intel-rapl:0/energy_uj
$ cat /sys/class/powercap/intel-rapl:0/energy_uj
cat: '/sys/class/powercap/intel-rapl:0/energy_uj': Permission denied
```

Das erklärt `delta.energy_micro_joules = 0` auf **beiden** Lanes — der Code liest genau diese Datei
(`linux_perf_pmc_source.hpp:165`).

**Merksatz für die Rechte-Entscheidung:**

| Was der Code heute tut | Braucht | Status |
|---|---|---|
| per-Task, `cpu=-1`, `exclude_kernel=1` (die drei Cache-Counter) | paranoid ≤ 2 | **läuft**, beide Lanes |
| per-Task ohne `exclude_kernel` (Kernelanteil mitmessen) | paranoid ≤ 1 | wäre heute schon erlaubt, Code nutzt es nicht |
| CPU-weite/uncore-Events, `power`-PMU (Energie über perf) | paranoid ≤ 0 **oder** `CAP_PERFMON` | **EACCES**, siehe oben |
| `/sys/.../energy_uj` (Energie über sysfs) | Leserecht auf die Datei (DAC) | **EACCES**, `CAP_PERFMON` hilft hier **nicht** |

> **Korrektur zu einer kursierenden Tabelle:** „paranoid=1 erlaubt zusätzlich CPU-weite Events" ist
> **falsch**. Ich habe es gegengeprobt: bei paranoid=1 liefert `pid=-1, cpu=0` **EACCES**.
> CPU-weit beginnt bei **paranoid=0**. Wer nach der falschen Tabelle handelt, ändert nichts und
> glaubt, er hätte.

---

## 2. Was zu tun ist — die Befehle

Reihenfolge ist bindend. Schritt 0 ist Pflicht: er kostet 30 Sekunden und verhindert genau den
Fehlversuch, den du vermeiden willst.

### Schritt 0 — Die Sonde auf prod2 (PFLICHT, ohne root, ändert nichts)

**Maschine:** prod2 · **root:** nein · **Dauer:** ~30 s · **Bewirkt:** nichts (rein lesend)

Sie bildet `linux_perf_pmc_source.hpp` 1:1 nach und druckt genau das, was die Tests verschweigen:
`errno` beim Open sowie `t_enabled`/`t_running` je Counter, über vier Fensterlängen, plus einen
expliziten Hybrid-Gegentest.

```bash
mkdir -p ~/pmc_probe && cat > ~/pmc_probe/pmc_probe2.c <<'EOF'
#define _GNU_SOURCE
#include <linux/perf_event.h>
#include <sys/syscall.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <sched.h>
#include <dirent.h>
static long peo(struct perf_event_attr *a, pid_t p, int c, int g, unsigned long f) {
    return syscall(__NR_perf_event_open, a, p, c, g, f);
}
static unsigned long long cfg(unsigned id, unsigned op, unsigned res) {
    return (unsigned long long)id | ((unsigned long long)op << 8) | ((unsigned long long)res << 16);
}
struct rd { unsigned long long v, te, tr; };
static int open1(unsigned type, unsigned long long c, int *err) {
    struct perf_event_attr a; memset(&a, 0, sizeof a);
    a.type = type; a.size = sizeof a; a.config = c;
    a.disabled = 1; a.exclude_kernel = 1; a.exclude_hv = 1; a.inherit = 0;
    a.read_format = PERF_FORMAT_TOTAL_TIME_ENABLED | PERF_FORMAT_TOTAL_TIME_RUNNING;
    long r = peo(&a, 0, -1, -1, 0);
    if (r < 0) { *err = errno; return -1; }
    *err = 0; return (int)r;
}
static unsigned read_pmu_type(const char *pmu) {
    char p[256]; snprintf(p, sizeof p, "/sys/bus/event_source/devices/%s/type", pmu);
    FILE *f = fopen(p, "r"); if (!f) return 0u;
    unsigned t = 0; if (fscanf(f, "%u", &t) != 1) t = 0u; fclose(f); return t;
}
static const char *NM[3] = { "L1D/READ/MISS ", "LL/READ/MISS  ", "DTLB/READ/MISS" };
static unsigned long long CS[3];
static volatile unsigned long long sink;
static void workload(unsigned long long it) {
    unsigned long long a = 1;
    for (unsigned long long i = 0; i < it; ++i) a = a * 6364136223846793005ULL + 1442695040888963407ULL;
    sink = a;
}
static void window(int fd[3], const char *label, unsigned long long it) {
    printf("-- Fenster \"%s\" (iters=%llu) --\n", label, it);
    for (int i = 0; i < 3; ++i) if (fd[i] >= 0) { ioctl(fd[i], PERF_EVENT_IOC_RESET, 0); ioctl(fd[i], PERF_EVENT_IOC_ENABLE, 0); }
    if (it) workload(it);
    for (int i = 0; i < 3; ++i) if (fd[i] >= 0) ioctl(fd[i], PERF_EVENT_IOC_DISABLE, 0);
    int any = 0;
    for (int i = 0; i < 3; ++i) {
        if (fd[i] < 0) { printf("   %s : nicht offen\n", NM[i]); continue; }
        struct rd d; memset(&d, 0, sizeof d);
        ssize_t n = read(fd[i], &d, sizeof d);
        int ok = (n == (ssize_t)sizeof d) && d.tr != 0; if (ok) any = 1;
        printf("   %s : read=%zd value=%llu t_enabled=%llu t_running=%llu -> ok=%s\n",
               NM[i], n, d.v, d.te, d.tr, ok ? "true" : "FALSE");
    }
    printf("   => end().available waere: %d\n", any);
}
int main(void) {
    CS[0] = cfg(PERF_COUNT_HW_CACHE_L1D,  PERF_COUNT_HW_CACHE_OP_READ, PERF_COUNT_HW_CACHE_RESULT_MISS);
    CS[1] = cfg(PERF_COUNT_HW_CACHE_LL,   PERF_COUNT_HW_CACHE_OP_READ, PERF_COUNT_HW_CACHE_RESULT_MISS);
    CS[2] = cfg(PERF_COUNT_HW_CACHE_DTLB, PERF_COUNT_HW_CACHE_OP_READ, PERF_COUNT_HW_CACHE_RESULT_MISS);
    printf("== Umgebung ==\nuid=%u cpu=%d\n", (unsigned)getuid(), sched_getcpu());
    { FILE*f=fopen("/proc/sys/kernel/perf_event_paranoid","r"); int v=-99; if(f){ if(fscanf(f,"%d",&v)!=1) v=-99; fclose(f);} printf("perf_event_paranoid = %d\n", v); }
    { printf("PMUs:"); DIR*d=opendir("/sys/bus/event_source/devices"); struct dirent*e;
      if(d){ while((e=readdir(d))) if(e->d_name[0]!='.') printf(" %s", e->d_name); closedir(d);} printf("\n"); }
    unsigned t_core = read_pmu_type("cpu_core"), t_atom = read_pmu_type("cpu_atom");
    printf("cpu_core.type=%u cpu_atom.type=%u (0 = nicht vorhanden -> nicht hybrid)\n", t_core, t_atom);
    printf("\n== A) open wie im Produktivcode (PERF_TYPE_HW_CACHE, pid=0, cpu=-1, exclude_kernel=1) ==\n");
    int fd[3], er[3];
    for (int i = 0; i < 3; ++i) {
        fd[i] = open1(PERF_TYPE_HW_CACHE, CS[i], &er[i]);
        if (fd[i] >= 0) printf("   %s : open OK fd=%d\n", NM[i], fd[i]);
        else            printf("   %s : open FEHLGESCHLAGEN errno=%d (%s)\n", NM[i], er[i], strerror(er[i]));
    }
    printf("   => available() (ready_) waere: %d\n", (fd[0]>=0)||(fd[1]>=0)||(fd[2]>=0));
    printf("\n== B) Fenster-Reihe ==\n");
    window(fd, "LEER (m3v2-Muster)", 0);
    window(fd, "winzig", 1000ULL);
    window(fd, "kurz", 1000000ULL);
    window(fd, "lang", 100000000ULL);
    for (int i = 0; i < 3; ++i) if (fd[i] >= 0) close(fd[i]);
    if (t_core) {
        printf("\n== C) Hybrid-Gegenprobe: dieselben Events explizit auf PMU cpu_core (type=%u) ==\n", t_core);
        int fc[3], ec[3];
        for (int i = 0; i < 3; ++i) {
            fc[i] = open1(t_core, CS[i], &ec[i]);
            if (fc[i] >= 0) printf("   %s : open OK fd=%d\n", NM[i], fc[i]);
            else            printf("   %s : open FEHLGESCHLAGEN errno=%d (%s)\n", NM[i], ec[i], strerror(ec[i]));
        }
        window(fc, "LEER auf cpu_core", 0);
        for (int i = 0; i < 3; ++i) if (fc[i] >= 0) close(fc[i]);
    } else printf("\n== C) entfaellt: keine Hybrid-PMU cpu_core ==\n");
    return 0;
}
EOF
cc -O0 -o ~/pmc_probe/pmc_probe2 ~/pmc_probe/pmc_probe2.c && ~/pmc_probe/pmc_probe2
```

**Verifikation, dass er gewirkt hat:** der Block druckt Ausgabe. Auf prod1 sieht sie so aus (von mir
heute selbst gefahren, Referenz zum Vergleich):

```
perf_event_paranoid = 1
cpu_core.type=0  cpu_atom.type=0  (0 = nicht vorhanden -> nicht hybrid)
   L1D/READ/MISS  : open OK  fd=3
   LL/READ/MISS   : open FEHLGESCHLAGEN errno=2 (No such file or directory)
   DTLB/READ/MISS : open OK  fd=4
   => available() (ready_) waere: 1
-- Fenster "LEER (m3v2-Muster)" (iters=0) --
   L1D/READ/MISS  : read=24 value=0 t_enabled=5580 t_running=5580 -> ok=true
   DTLB/READ/MISS : read=24 value=0 t_enabled=3360 t_running=3360 -> ok=true
   => end().available waere: 1
```

**So liest du das Ergebnis von prod2:**
- Steht bei „open" irgendwo `errno=13 (Permission denied)` oder `errno=1` → **dann und nur dann** ist
  es ein Rechteproblem, weiter mit Schritt 2 oder 3.
- Steht überall `open OK` und im Leerfenster `t_running=0` → Rechte sind in Ordnung; die Ursache ist
  K1/K2/K3 nach der Tabelle in §1.1. Rechte-Eingriff **überspringen**, weiter mit §7.

**Zusatz bei Hybrid (`cpu_core.type != 0`), entscheidet K1 endgültig** — Core-Nummern vorher aus
`lscpu -e=CPU,MAXMHZ` ablesen (P-Cores = hohe MaxMHz, E-Cores = niedrige):

```bash
lscpu -e=CPU,CORE,MAXMHZ
taskset -c 0  ~/pmc_probe/pmc_probe2 | sed -n '/LEER (m3v2/,/available waere/p'   # P-Core
taskset -c 20 ~/pmc_probe/pmc_probe2 | sed -n '/LEER (m3v2/,/available waere/p'   # E-Core (Nr. anpassen!)
```
Unterschiedliches `t_running` zwischen beiden ⇒ K1 bewiesen.

### Schritt 1 — Ist-Stand der Rechte auf prod2 aufnehmen (ohne root)

**Maschine:** prod2 · **root:** nein · **Bewirkt:** nichts

```bash
cat /proc/sys/kernel/perf_event_paranoid
ls -l /etc/sysctl.d/90-comdare-perf-pmc.conf 2>&1
cat /etc/sysctl.d/90-comdare-perf-pmc.conf 2>&1
systemctl show gitlab-runner -p AmbientCapabilities -p CapabilityBoundingSet -p User
ls -l /sys/class/powercap/intel-rapl:0/energy_uj
```

Auf prod1 lautet die Antwort (selbst geprüft): `1` · Datei existiert, Inhalt
`kernel.perf_event_paranoid=1` · `AmbientCapabilities=` leer, `User=` leer (Dienst läuft als root,
Jobs laufen per `--user gitlab-runner` als `gitlab-runner`) · `energy_uj` ist `-r-------- root root`.
**Ob prod2 identisch ist: UNBELEGT** — der Trace zeigt nur `perf_event_paranoid = 1`. Dieser Schritt
klärt es.

### Schritt 2 — Kleinster Eingriff mit Reichweite: `CAP_PERFMON` nur für den Runner

**Maschine:** prod2 (und prod1, wenn beide Lanes gleichziehen sollen) · **root:** ja
**Bewirkt:** hebt die paranoid-Schranke **nur für die Runner-Prozesse** auf — CPU-weite Events,
uncore, `power`-PMU (Energie über perf). Die Maschine als Ganzes bleibt auf paranoid=1.

**Erst prüfen, ob der Mechanismus überhaupt trägt** (der Runner wechselt intern von root auf
`gitlab-runner`; ob Ambient-Capabilities diesen uid-Wechsel überleben, ist **UNBELEGT** — ich
konnte es mangels root nicht messen). Dieser Befehl entscheidet es, **transient, ohne dauerhafte
Änderung**:

```bash
# rapl_probe zuerst bauen (auf prod2, als normaler Nutzer):
cat > ~/pmc_probe/rapl_probe.c <<'EOF'
#define _GNU_SOURCE
#include <linux/perf_event.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
static long peo(struct perf_event_attr*a,pid_t p,int c,int g,unsigned long f){return syscall(__NR_perf_event_open,a,p,c,g,f);}
static void t(const char*l,unsigned ty,unsigned long long cf,pid_t pid,int cpu){
  struct perf_event_attr a; memset(&a,0,sizeof a);
  a.type=ty;a.size=sizeof a;a.config=cf;a.inherit=0;
  a.read_format=PERF_FORMAT_TOTAL_TIME_ENABLED|PERF_FORMAT_TOTAL_TIME_RUNNING;
  long r=peo(&a,pid,cpu,-1,0);
  if(r<0){printf("%-42s pid=%d cpu=%d -> FEHLGESCHLAGEN errno=%d (%s)\n",l,pid,cpu,errno,strerror(errno));return;}
  struct{unsigned long long v,te,tr;}d; memset(&d,0,sizeof d);
  ssize_t n=read((int)r,&d,sizeof d);
  printf("%-42s pid=%d cpu=%d -> OK read=%zd value=%llu\n",l,pid,cpu,n,d.v); close((int)r);}
int main(void){
  unsigned pk=0,pc=0; FILE*f;
  if((f=fopen("/sys/bus/event_source/devices/power/type","r"))){if(fscanf(f,"%u",&pk)!=1)pk=0;fclose(f);}
  if((f=fopen("/sys/bus/event_source/devices/power_core/type","r"))){if(fscanf(f,"%u",&pc)!=1)pc=0;fclose(f);}
  printf("uid=%u  power.type=%u  power_core.type=%u\n",(unsigned)getuid(),pk,pc);
  if(pk) t("power/energy-pkg systemweit",pk,0x02,-1,0);
  if(pc) t("power_core/energy-core systemweit",pc,0x01,-1,0);
  t("HW_CACHE L1D cpu-weit",PERF_TYPE_HW_CACHE,
    (unsigned long long)PERF_COUNT_HW_CACHE_L1D|((unsigned long long)PERF_COUNT_HW_CACHE_OP_READ<<8)|((unsigned long long)PERF_COUNT_HW_CACHE_RESULT_MISS<<16),-1,0);
  return 0;}
EOF
cc -O0 -o ~/pmc_probe/rapl_probe ~/pmc_probe/rapl_probe.c
~/pmc_probe/rapl_probe                       # VORHER: erwarte 3x errno=13
sudo cp ~/pmc_probe/rapl_probe /usr/local/bin/rapl_probe && sudo chmod 0755 /usr/local/bin/rapl_probe
sudo systemd-run --uid=gitlab-runner --property=AmbientCapabilities=CAP_PERFMON \
     --property=CapabilityBoundingSet=CAP_PERFMON --pty /usr/local/bin/rapl_probe
```

- Druckt der letzte Befehl `-> OK` statt `errno=13`, **trägt** der Mechanismus → Schritt 2a.
- Druckt er weiter `errno=13`, trägt er **nicht** (Ambient-Cap überlebt den uid-Wechsel nicht)
  → Schritt 3 statt 2a. **Nicht raten — dieser Befehl sagt es.**

#### Schritt 2a — dauerhaft machen

**Maschine:** prod2 · **root:** ja

```bash
sudo install -d /etc/systemd/system/gitlab-runner.service.d
sudo tee /etc/systemd/system/gitlab-runner.service.d/20-comdare-perfmon.conf >/dev/null <<'EOF'
# comdare 2026-08-06: PMC-Messrechte fuer die Mess-Lane. CAP_PERFMON hebt die
# perf_event_paranoid-Schranke NUR fuer die Runner-Prozesse auf (CPU-weite Events,
# uncore, power-PMU/Energie). Kleinster Eingriff: die Maschine bleibt auf paranoid=1.
[Service]
AmbientCapabilities=CAP_PERFMON
CapabilityBoundingSet=CAP_PERFMON CAP_CHOWN CAP_DAC_OVERRIDE CAP_SETUID CAP_SETGID CAP_KILL CAP_SYS_CHROOT
EOF
sudo systemctl daemon-reload
sudo systemctl restart gitlab-runner
```

> **Achtung, ein Job darf dabei nicht laufen.** Vorher prüfen:
> `sudo systemctl status gitlab-runner | head -20` und in GitLab, dass auf prod2 nichts läuft.
> `Restart=always`, `RestartSec=120` — nach einem Fehlstart kommt der Dienst erst nach 2 min wieder.

**Verifikation, dass es gewirkt hat:**

```bash
systemctl show gitlab-runner -p AmbientCapabilities        # erwartet: AmbientCapabilities=cap_perfmon
grep -E '^Cap(Inh|Amb|Bnd)' /proc/$(pgrep -f 'gitlab-runner run' | head -1)/status
```
Die harte Verifikation ist aber der CI-Lauf aus §4 — die Datei zu sehen ist nicht dasselbe wie zu
messen, dass der Job die Rechte hat.

### Schritt 3 — Fallback, wenn Schritt 2 nicht trägt: `perf_event_paranoid=0`

**Maschine:** prod2 (bei Bedarf prod1 gleichziehen) · **root:** ja
**Bewirkt:** erlaubt allen unprivilegierten Nutzern CPU-weite/uncore/`power`-Events.
Maschinenweit — deshalb **zweite Wahl** hinter Schritt 2.

Die Datei existiert bereits (auf prod1 belegt), es ist ein Ein-Zeilen-Edit:

```bash
cat /etc/sysctl.d/90-comdare-perf-pmc.conf                    # vorher: kernel.perf_event_paranoid=1
sudo sed -i 's/^kernel\.perf_event_paranoid=.*/kernel.perf_event_paranoid=0/' \
     /etc/sysctl.d/90-comdare-perf-pmc.conf
sudo sysctl --system >/dev/null
```

Existiert die Datei auf prod2 nicht, stattdessen:

```bash
printf 'kernel.perf_event_paranoid=0\n' | sudo tee /etc/sysctl.d/90-comdare-perf-pmc.conf >/dev/null
sudo sysctl --system >/dev/null
```

**Verifikation:**

```bash
cat /proc/sys/kernel/perf_event_paranoid      # erwartet: 0
~/pmc_probe/rapl_probe                        # erwartet: "power/energy-pkg ... -> OK", kein errno=13
```

**Nicht auf `-1` gehen.** `0` reicht für alles, was dieser Code je öffnet — siehe §5.

### Schritt 4 — Nur falls Energie über sysfs gewollt ist (unabhängig, additiv)

**Maschine:** prod1 und prod2 · **root:** ja
**Bewirkt:** macht `energy_micro_joules` im CSV ungleich 0. **`CAP_PERFMON` und `paranoid` helfen
hier nicht** — es ist eine reine Dateirechtefrage (DAC).

```bash
sudo tee /etc/udev/rules.d/90-comdare-rapl.rules >/dev/null <<'EOF'
# comdare 2026-08-06: RAPL-Energiezaehler fuer die Mess-Lane lesbar machen.
SUBSYSTEM=="powercap", KERNEL=="intel-rapl:*", RUN+="/bin/chmod a+r /sys%p/energy_uj"
EOF
sudo udevadm control --reload-rules
sudo udevadm trigger --subsystem-match=powercap
```

**Verifikation:**

```bash
ls -l /sys/class/powercap/intel-rapl:0/energy_uj    # erwartet: -r--r--r--
cat  /sys/class/powercap/intel-rapl:0/energy_uj     # erwartet: eine Zahl, kein "Permission denied"
```

> Sauberer als der udev-Weg ist die perf-Variante (`power/energy-pkg`), die Schritt 2/3 ohnehin
> freischaltet — dafür müsste der Code aber von `fopen(energy_uj)` auf `perf_event_open` umgestellt
> werden. Das ist Repo-Arbeit, kein Cluster-Eingriff, und gehört nicht in diese Anweisung.

---

## 3. Dauerhaftigkeit

| Schritt | Überlebt Reboot? | Warum / was macht es dauerhaft |
|---|---|---|
| 0, 1 | — | rein lesend, nichts zu erhalten |
| 2 (`systemd-run`-Test) | **nein, absichtlich** | transiente Unit, verschwindet nach dem Lauf. Genau deshalb als Test geeignet. |
| 2a (systemd-Drop-in) | **ja** | `/etc/systemd/system/gitlab-runner.service.d/20-comdare-perfmon.conf` liegt auf Platte; systemd liest Drop-ins bei jedem Start. Kein `sysctl -w`, kein rc.local. Bereits erprobtes Muster auf prod1: dort liegen schon `10-comdare-http1.conf` und `cpuquota.conf` im selben Verzeichnis. |
| 3 (sysctl.d) | **ja** | `/etc/sysctl.d/90-comdare-perf-pmc.conf` wird beim Boot von `systemd-sysctl` angewandt. `sysctl --system` macht es sofort zusätzlich wirksam — **einmal tun genügt**. Ein bloßes `sudo sysctl -w kernel.perf_event_paranoid=0` wäre **nicht** dauerhaft; nimm es nicht. |
| 4 (udev) | **ja** | Regel greift bei jedem Anlegen der powercap-Geräte, also auch nach Reboot. Ein einmaliges `chmod` auf `/sys/...` wäre **nicht** dauerhaft (sysfs wird neu erzeugt). |

**Reboot-Gegenprobe** (einmalig, wenn du sichergehen willst — kostet einen Neustart von prod2):

```bash
sudo reboot
# danach:
cat /proc/sys/kernel/perf_event_paranoid
systemctl show gitlab-runner -p AmbientCapabilities
ls -l /sys/class/powercap/intel-rapl:0/energy_uj
```

---

## 4. Die Gegenprobe

### 4.1 Auf der Maschine — 1 Sekunde, kein CI

```bash
~/pmc_probe/pmc_probe2 | head -20 ; ~/pmc_probe/rapl_probe
```

**Erfolgskriterium für die Rechte:** kein `errno=13` mehr in der `rapl_probe`-Ausgabe.

### 4.2 In der CI — 12 Sekunden, ein Job, keine Pipeline

Job 365257 hat **11,93 s** gelaufen (API-Feld `duration`, selbst geholt) — ein Retry ist praktisch
sofort da und baut per ccache neu.

```
https://gitlab.comdare.local/comdare/research/comdare-cache-engine/-/jobs/365257
```
→ Button **Retry**. Der Job trägt `tags: [baremetal, intel]`, kann also nur auf prod2 landen.

Alternativ eine Pipeline **nur** mit der intel-Lane (die Lane ist per Variable gated,
`.gitlab-ci.yml:153-157`): *Build → Pipelines → Run pipeline* auf `development`, Variable
`COMDARE_PMC_LANES` = `intel`. Dann laufen nur `lint:secrets` und `pmc:intel`.

### 4.3 Was du dabei sehen wirst — und was das heißt

**Der Job bleibt rot.** Das ist kein Fehlschlag deiner Änderung, sondern der Beweis aus §1: Test 304
scheitert an einem leeren Messfenster, nicht an Rechten. Woran du erkennst, dass die Rechte-Änderung
trotzdem gewirkt hat: in der Trace-Zeile von Test 329 steht dann

```
329: delta.energy_micro_joules   = <Zahl != 0>
```

statt bisher `= 0`. **Das** ist das Signal — nicht die Job-Farbe.

Der rote Job 304 geht erst weg, wenn im Repo entweder (a) `m3v2_pmc_smoke` eine echte Last zwischen
`begin()` und `end()` bekommt, oder (b) die fail-closed-Bedingung
(`m3v2_pmc_smoke.cpp:87`, `pmc_seam_ok = delta.available || (!kPmcExpected && counters_all_zero)`)
vom Naht-Test auf den Last-Test `linux_perf_pmc_smoke` verlegt wird, der genau das prüft und auf
beiden Lanes grün ist. **Das ist eine Repo-Entscheidung, keine Cluster-Entscheidung** — und sie
gehört nicht in diese Anweisung, weil sie deine Entscheidung ist.

---

## 5. Was NICHT zu tun ist

**`--privileged` / `CAP_SYS_ADMIN`.** Hier doppelt falsch. Erstens ist die Lane ein
**shell-Executor auf Baremetal** (Trace: `Preparing the "shell" executor`, Build unter
`/home/gitlab-runner/builds/...`) — es gibt gar keinen Container, an dem `--privileged` ansetzen
könnte. Zweitens ist `CAP_SYS_ADMIN` die Vollmacht für Mount, Namespaces, Kernelmodule und mehr;
`CAP_PERFMON` (seit Linux 5.8) hebt gezielt genau die perf-Schranke, sonst nichts. Wenn Capabilities,
dann `CAP_PERFMON`.

**`perf_event_paranoid=-1`.** `-1` schaltet zusätzlich Raw-Tracepoints und ftrace frei. Nichts davon
öffnet dieser Code je: er verwendet ausschließlich `PERF_TYPE_HW_CACHE`, plus — falls jemals nötig —
die `power`-PMU. Beides ist bei `0` erlaubt; ich habe bei `1` gemessen, dass genau diese beiden Fälle
noch `EACCES` liefern und bei `0` erlaubt sind. `0` ist damit belegbar ausreichend.

**Rechte ändern, ohne Schritt 0 gefahren zu haben.** Der rote Job wird davon nicht grün. Du hättest
die Maschine angefasst und stündest vor demselben Trace — mit dem zusätzlichen Problem, dass du eine
Variable geändert hast, die als Erklärung nicht mehr zur Verfügung steht.

**Den Test skippen, `allow_failure: true` setzen oder `-LE pmc` erweitern.** Das ist genau der
Zustand vor `8894d983`: die intel-Lane hat `pmc_available=0` schon in den Pipelines 15095/15099/15107
gemeldet — der alte Ausdruck `available || counters_all_zero` machte `0 || 1 = 1` und schrieb
`SMOKE_OK`. Die Lane hat diesen Test **nie bestanden, sondern stillgeschaltet**. Die fail-closed-
Umstellung hat genau das aufgedeckt; sie zurückzudrehen wirft den einzigen echten Erkenntnisgewinn
des Tages weg.

**`sudo sysctl -w kernel.perf_event_paranoid=0` als „schneller Test".** Der Wert ist nach dem
nächsten Reboot weg. Wenn danach eine Messreihe läuft und ein Reboot dazwischen liegt, hast du zwei
Datensätze unter verschiedenen Bedingungen und merkst es nicht.

**Runner neu registrieren, `config.toml` anfassen, Tags ändern.** Nichts davon berührt perf. Die
`config.toml` ist auf beiden Hosts nicht die Ursache — die Wirkung ihrer Einstellungen ist bereits
gemessen: `perf_event_open` gelingt auf prod2.

---

## 6. Sicherheitsabwägung, ehrlich

**Was Schritt 2 (`CAP_PERFMON` nur für den Runner) öffnet.** Die Prozesse des GitLab-Runners — und
damit jeder CI-Job, der auf prod2 läuft — dürfen dann CPU-weite und uncore-Zähler öffnen. Konkret
heißt das: ein Job kann Hardware-Ereignisse *aller* Prozesse auf der Maschine mitzählen, nicht nur
seiner eigenen. Das ist die Grundlage von Seitenkanal-Messungen; wer beliebigen Code in einem Job
ausführen kann, kann damit statistische Aussagen über fremde Aktivität auf derselben CPU gewinnen.
`CAP_PERFMON` erlaubt **nicht**: Mounts, Namespaces, Kernelmodule, Speicher fremder Prozesse
auszulesen, root zu werden.

**Was Schritt 3 (`paranoid=0`) zusätzlich öffnet.** Dasselbe, aber für **jeden** unprivilegierten
Nutzer der Maschine, nicht nur für den Runner. Auf prod2 ist der Unterschied gering, solange dort
außer dem Runner niemand arbeitet — aber genau das ist die Annahme, die man in einem Jahr nicht mehr
erinnert. Deshalb Schritt 2 vor Schritt 3.

**Was Schritt 4 (RAPL lesbar) öffnet.** Der Paket-Energiezähler wird für alle lesbar. Das ist die
Grundlage der *PLATYPUS*-Klasse von Angriffen: aus hochauflösenden Energiemessungen lassen sich unter
Laborbedingungen Rückschlüsse auf kryptografische Operationen anderer Prozesse ziehen. Genau deshalb
ist die Datei seit Linux 5.10 root-only. Der Kommentar in `linux_perf_pmc_source.hpp:163` weiß das
bereits.

**Die Einordnung für genau diese Maschinen.** prod1/prod2 sind dedizierte Messknoten in einem
geschlossenen Cluster. Wer dort einen CI-Job auslösen kann, kann ohnehin beliebigen Code als
`gitlab-runner` ausführen — das ist die eigentliche Vertrauensgrenze, und sie ist deutlich weiter
als alles, was `CAP_PERFMON` hinzufügt. **Auf diesen Hosts ist der Eingriff angemessen.**
Er wäre es **nicht** auf einem Mehrbenutzer-Host, auf einer Maschine mit fremden Mandanten, oder auf
einem Runner, der Merge Requests aus Forks ausführt. Prüfe das eine, bevor du es tust:

```bash
awk -F: '$3>=1000 && $3<65534 {print $1}' /etc/passwd     # wer hat auf prod2 ein Login-Konto?
```

Und der wichtigste ehrliche Satz: **du gehst dieses Risiko für einen Nutzen ein, der den roten Job
nicht betrifft.** Der Nutzen ist real (Energie- und uncore-Zähler in der Messkette), aber er ist
*additiv*. Wenn du ihn heute nicht brauchst, ist „gar nicht anfassen" eine vertretbare Antwort.

---

## 7. Wenn es danach immer noch nicht geht

### Schritt A — die Fenster-Reihe aus Schritt 0 auswerten (5 Minuten, keine Änderung)

`~/pmc_probe/pmc_probe2` auf prod2 fährt vier Fenster: leer, 1e3, 1e6, 1e8 Iterationen. Notiere, ab
welcher Länge `t_running != 0` wird. Das beantwortet die einzige offene Frage aus §1.1:

- `t_enabled > 0, t_running == 0` **nur** im Leerfenster → **K2** (Installationslatenz).
- `t_enabled > 0, t_running == 0` **auch** bei 1e6, aber Abschnitt C (`cpu_core`) liefert
  `t_running > 0` → **K1** (Hybrid-PMU).
- beide Zeiten `0` → **K3** (Granularität).

Bei **K1** ist die Konsequenz für die Messkette gravierender als der rote Job: dann sind die
intel-Werte in `linux_perf_pmc_smoke` (6,7 Mio. L1-Misses) unter Multiplexing/Core-Wechsel
hochskaliert (`read_scaled` setzt in dem Fall `scaled=true`) und damit Schätzungen. Das gehört in
den Anhang der Arbeit — und `LinuxPerfPmcSource` müsste die Events explizit auf `cpu_core` öffnen.

### Schritt B — die zwei Zahlen sichtbar machen, die heute fehlen (eine Zeile Repo-Änderung)

Die Tests drucken `t_enabled`/`t_running` nicht, und `perf_event_open` verwirft seinen `errno`
(`linux_perf_pmc_source.hpp:111-114`, `fd_ = -1; return false;` — der Fehlercode geht dabei
verloren). Solange das so ist, muss jede Ferndiagnose raten. Zwei minimale Ergänzungen:

1. In `read_scaled` (`linux_perf_pmc_source.hpp:131-149`) vor dem `return 0` bei `t_running == 0`
   die beiden Zeiten in einen Member schreiben und über eine `diag()`-Methode ausgeben.
2. In `open` (Z. 114) den `errno` in einen Member sichern, damit `m3v2_pmc_smoke` bei
   `available=0` **die Ursache** statt einer Vermutungsliste druckt.

Danach steht die Antwort im nächsten CI-Trace, ohne dass jemand auf die Maschine muss. Das ist
zugleich die Reparatur der irreführenden Fehlermeldung, die diese ganze Diagnose ausgelöst hat.

### Falls Schritt 2a den Runner nicht mehr startet

```bash
sudo rm /etc/systemd/system/gitlab-runner.service.d/20-comdare-perfmon.conf
sudo systemctl daemon-reload && sudo systemctl restart gitlab-runner
systemctl is-active gitlab-runner       # erwartet: active
```

---

## Anhang: was ich selbst gemessen habe und was nicht

**Selbst am Objekt gemessen** (heute, 2026-08-06):
- Traces 364696/364756/364797/364798/365119/365120/365148/365149/365186/365187/365226/365227/365256/365257
  über die GitLab-API — `perf_event_paranoid=1` auf beiden Hosts, Executor `shell`, Test-304/329-Ausgabe.
- Job-Metadaten 365257: `duration=11.934937`, `allow_failure=false`, `status=failed`.
- Quelltext `linux_perf_pmc_source.hpp` (Z. 99-149, 200-320) und `m3v2_pmc_smoke.cpp` (Z. 30-50, 75-110).
- **Auf prod1, eigene Sonden:** Leerfenster liefert `t_running=5580 ns` und `value=0` bei `ok=true`;
  `LL/READ/MISS` lässt sich auf Zen5 gar nicht öffnen (`errno=2 ENOENT` — das ist die Erklärung für
  `cache_misses_l3 = 0` auf der amd-Lane); CPU-weite Events und die `power`-PMU liefern bei
  paranoid=1 `errno=13 EACCES`; `exclude_kernel=0` per-Task ist bei paranoid=1 erlaubt;
  `/sys/class/powercap/intel-rapl:0/energy_uj` ist `0400 root:root`.
- Auf prod1: `/etc/sysctl.d/90-comdare-perf-pmc.conf` enthält `kernel.perf_event_paranoid=1`;
  `gitlab-runner.service` läuft als root und startet Jobs per `--user gitlab-runner`;
  Drop-in-Verzeichnis existiert bereits mit zwei Dateien.

**UNBELEGT, ausdrücklich nicht geraten:**
- Warum `t_running == 0` auf prod2 (K1/K2/K3 — Schritt 0 entscheidet).
- Ob prod2 dieselbe `sysctl.d`-Datei und dieselbe Runner-Unit hat wie prod1 (Schritt 1 klärt).
- Ob `AmbientCapabilities` den uid-Wechsel des Runners überlebt (der `systemd-run`-Test in Schritt 2
  klärt es).
- Ob `pmc_available=0` auf intel auch im echten Messpfad (`run_observable_perm`, reale Last)
  auftritt — alle intel-Belege stammen aus dem Nullfenster; unter Last (Test 329) ist intel grün.

**Nicht erhoben** (Auftrag: Cluster read-only, kein ssh): `/etc/gitlab-runner/config.toml`
(`Permission denied`), alles direkt auf prod2.
