# IMPL → INFRA Handover — V111(K8S-PROD-CALICO)→gitlab `.1`-SNI (DNS+FW) + #210-Wurzel (gitlab Zero-Window)

> **Von:** Impl-Agent (cache-engine/Diplomarbeit) · **An:** Infra-Agent · **Datum:** 2026-06-29
> **Kontext:** Beide OPN werden gerade nach prod migriert. opn-1 (`10.0.10.11`) ist derzeit **alleiniger CARP-Master für ALLE 32 VIPs**; opn-2/3/4 (.12/.13/.14) down (Migration). Diese zwei OPNsense-Änderungen bitte **du** im Zuge der Migration übernehmen (konsistent mit dem prod-Soll), dann an mich zur Verifikation freigeben.
> **Quelle der Befunde:** Voll-Diagnose 2026-06-29 (tcpdump prod1 + opn-1 read-only). Memories: `reference_gitlab_runner_210_silent_poll_stall`, `reference_dns_split_horizon_unbound_views_dot1_sni`.

---

## 0. TL;DR — was du tun sollst

1. **(c) talos-prod1-VM (V111) erreicht gitlab nicht** → der `.1`-SNI-DNS-Split-Horizon hat **keinen V111-Eintrag** + V111-Firewall hat **nur Antispoof**. **Fix = V111 in den Unbound-Split-Horizon aufnehmen (gitlab→10.0.111.1) + V111-Firewall (DNS + `.1:443`, V110 spiegeln).** **ABER zuerst** den VM-DNS-Pfad mappen (du hast talos/K8s-Zugang, ich nicht) — er entscheidet, ob der Fix OPNsense-Unbound ODER CoreDNS/Talos-Resolver ist (§3).
2. **#210 (Mess-Pipeline-Blocker) hat eine NEUE, paket-bewiesene Wurzel:** **gitlab-Backend Zero-Window-Backpressure** (gitlab drainiert den Runner-Trace-Upload nicht) — **NICHT** Netz/HAProxy/Firewall. Wurzel = **gitlab-Storage/#207 (prod2-I/O)**. Für dich relevant: HAProxy-/Runner-/Netz-Tuning hilft NICHT; der Hebel ist gitlab-Storage/prod2-I/O (§4).
3. **Handback:** Du machst die OPNsense-Änderung (validiert, reboot-sicher) → gibst an mich frei → ich verifiziere (VM löst gitlab→10.0.111.1, erreicht `.1:443`, Filter-Log-SYN-Sturm von `10.0.111.211` hört auf).

---

## 1. Verifizierter Ist-Stand (alles read-only belegt 2026-06-29)

**CARP/HA:** opn-1 = **MASTER für alle 32 VIPs** (vhid 60/110/111 alle MASTER, advskew 0); opn-2/3/4 **down**; `net.inet.carp.allow=1`. **Kein lebendes Backup** (= Migration läuft). ⟹ jede Änderung trifft den alleinigen Master → **`unbound-checkconf` VOR Reload**, **config.xml-Backup** (liegt: `/conf/config.xml.bak.claude-20260629-143538`), graceful.

**HAProxy (OPNsense 26.1.2, os-haproxy):**
- Frontend `https-in`: `bind *:443` (sockstat bestätigt → deckt **jedes** Gateway-`.1:443` inkl. `10.0.111.1:443` ab → **KEIN neues Frontend nötig**), `mode tcp`, `timeout client 90s`, SNI-ACL `req.ssl_sni -i gitlab.comdare.de` → `use_backend be-gitlab`.
- Backend `be-gitlab` (uuid `57d29fd1-a6de-4dd8-9509-a25bc0aabfe3`): `mode tcp`, `balance source`, `stick on src`, `tuning_timeoutServer 90s`, `customOptions` leer, server `srv-gitlab-220 10.0.40.220:443`.

**DNS-Split-Horizon (Unbound, das konkrete `.1`-SNI-Modell):**
```
local-zone "comdare.de" transparent
local-data "gitlab.comdare.de IN A 10.0.10.1"        # DEFAULT (kein View-Match)
access-control-view 10.0.60.0/24  → build  → local-data gitlab.comdare.de A 10.0.60.1
access-control-view 10.0.40.0/24  → apps   → local-data gitlab.comdare.de A 10.0.40.1
access-control-view 10.0.10.0/24  → mgmt   → local-data gitlab.comdare.de A 10.0.10.1
access-control-view 10.200.2.0/24 → build  → (= 10.0.60.1)
```
Test: `host gitlab.comdare.de 10.0.60.1`→`.60.1`, via `.40.1`→`.40.1`, **via `10.0.111.1`→KEINE Antwort** (V111 hat weder View noch access-control-Eintrag). V110→Default `.10.1`.

**Firewall V111 (`opt24`/`vtnet1_vlan111`, descr `K8S-PROD-CALICO`, VIP `10.0.111.1` vhid111):** NUR Antispoof (`@13 block drop in on ! vtnet1_vlan111 from 10.0.111.0/24 to any`). **Filter-Log-Beweis:** `@28 block` aller SYN `10.0.111.211 → 10.0.60.1:443` (die VM blackholet hier).

**Firewall V110 (dev-Pendant, Vorlage):** DNS (155/170), DHCP (185), carp (200), `block→10.0.60.0/24` (204), `block→10.0.100.0/24` (206), `pass all` (208), ntp (222), mgmt-access (230), bgp (240). → V110 erreicht alles **außer V60/V100**, via Broad-Pass auch das **eigene Gateway `10.0.110.1`**.

**Firewall V60 (funktionierendes gitlab-Muster):** `@244 pass … from (vtnet1_vlan60:network) to 10.0.60.1 port=https`.

---

## 2. Das Soll (User-Entscheid 2026-06-29): `.1`-SNI, KEIN Direkt-Cross-VLAN

BM-/K8s-VLANs sind **per Design** von V60 geblockt (V110 `@204`). Daher erreicht die VM gitlab **nicht** direkt über `10.0.60.1`, sondern über **ihr eigenes Gateway `10.0.111.1` (`.1`-SNI)** — HAProxy `bind *:443` SNI-routet das bereits an `be-gitlab`. Es fehlt nur: (a) DNS, dass V111 gitlab→`10.0.111.1` auflöst, (b) Firewall V111→`10.0.111.1:{443,53}`.

---

## 3. ⚠️ VORBEDINGUNG (bitte ZUERST, du hast den Zugang): VM-DNS-Pfad mappen

Die VM `10.0.111.211` löste gitlab→**`10.0.60.1`** auf (NICHT den Default `.10.1`). D.h. ihre DNS-Anfrage matcht entweder die **`10.200.2.x`-Pod-Quelle (→„build"-View)** ODER läuft über **CoreDNS/Talos-Resolver** statt direkt OPNsense. **Eine V111-Unbound-View greift nur, wenn die VM von einer `10.0.111.x`-Quelle aus fragt.** Bitte klären (talosctl/kubectl — prod1 hat KEIN talosctl):
- `talosctl --nodes 10.0.111.211 get resolvers` (welche nameserver hat der Node?).
- Trifft die Anfrage Unbound mit Quelle `10.0.111.x`, `10.200.2.x` (Pod) oder einem anderen Resolver (CoreDNS→Forward)?
- prod-Pod-CIDR + CoreDNS `comdare.de`-Forward-Ziel.

**Entscheidung:**
- **Fall A — VM/Node fragt OPNsense von `10.0.111.x`:** Fix = OPNsense-Unbound V111-View (§4a).
- **Fall B — Anfrage kommt von `10.200.2.x` (Pod) / läuft über CoreDNS:** Fix gehört (auch) in CoreDNS bzw. eine View für die **prod-Pod-CIDR** → gitlab auf das passende prod-Gateway. (Heute matcht `10.200.2.0/24`→„build"→`.60.1`; prod-Pods müssten auf ein prod-erreichbares `.1` zeigen.)

---

## 4. Die Änderung (reboot-sicher, validiert)

### 4a. Unbound: V111 in den Split-Horizon (nur wenn Fall A / zusätzlich)
Analog zu den bestehenden Views (gleiche Stelle in config.xml/`Custom options`, NICHT hand-`unbound.conf`):
```
access-control-view: 10.0.111.0/24 v111        # + access-control allow fuer 10.0.111.0/24
view:
    name: "v111"
    view-first: yes
    local-zone: "comdare.de" transparent
    local-data: "gitlab.comdare.de A 10.0.111.1"
```
**PFLICHT:** `unbound-checkconf` **vor** jedem Reload (am Backup-losen Master = clusterweites DNS-Risiko). Dann `configctl unbound reload`. Verifizieren: `host gitlab.comdare.de 10.0.111.1` → `10.0.111.1`, und ein bekannter Name (z.B. `host opnsense-1.comdare.de`) löst weiter normal auf (kein DNS-Regress).

### 4b. Firewall: V111 wie V110 spiegeln (+ gitlab `.1`)
V111 trägt aktuell NUR Antispoof. Spiegele V110s Regelsatz auf `vtnet1_vlan111`/`10.0.111.0/24` (DNS, DHCP, carp, ntp, `block→V60`, `block→V100`, Broad-Pass, bgp) — der Broad-Pass deckt `V111→10.0.111.1:{443,53}` ab; sonst minimal die zwei Pässe (`→10.0.111.1:53`, `→10.0.111.1:443`). `configctl filter reload` (pf validiert; bei Fehler bleibt altes Ruleset aktiv = sicher). **`block→10.0.60.0/24` BEIBEHALTEN** (Modell: kein Direkt-Cross-VLAN; gitlab kommt über `.1`-SNI).

### 4c. (NICHT für be-gitlab `timeout tunnel` o.ä.) — siehe §4, das ist NICHT der #210-Fix.

---

## 5. #210 — die echte Wurzel (für dich: gitlab-Storage/#207, nicht Netz)

Paket-bewiesen (tcpdump prod1, Voll-Capture der sterbenden Runner-Verbindung 2026-06-29):
- Der prod1-Runner (19.1.1, seit 06-27) lädt einen großen Job-Trace hoch (FIN `seq 128062` = 128 KB). Das Gegenüber **drosselt mit `win 0` (Zero-Window) auf beiden Seiten** durchgehend → gitlab **liest den Upload nicht ab** → Runner blockt im `write()`, liest selbst nicht → **App-Layer-Deadlock**. Verbindung wird **NICHT** gekappt (kein RST; lebt ~9 min bis Watchdog-Restart).
- HAProxy `mode tcp`-Passthrough → das `win 0` ist die durchgereichte Backpressure vom **gitlab-Backend `10.0.40.220` (V40-Pod)**. ⟹ **Wurzel = gitlab-Storage/Workhorse-I/O → MinIO/Object-Storage → prod2-I/O-Writeback-Stall (#207).**
- **WIDERLEGT (nicht weiterverfolgen):** HAProxy `timeout tunnel` (kein Cut), runner 19.1.1 (schon drauf, stallt weiter), conntrack/Middlebox-Drop (kein Drop, Backpressure), `connection_max_age` 15m→3m (getestet, half nicht, reverted).
- **Mitigation aktiv (NICHT abschalten):** `gitlab-runner-eof-watchdog.timer` restartet den Runner ~alle 10 min. Bleibt an, bis #207 gefixt.
- **Dein Hebel:** gitlab-Pod-Trace/Artifact-Ingestion (Workhorse→MinIO) + #207 prod2-I/O. Runner-/Netz-seitig nicht heilbar (bewiesen).

---

## 6. Handback-Protokoll + Verifikation (nach deiner Freigabe mache ICH)

Nach deiner OPNsense-Änderung (4a+4b) + Freigabe verifiziere ich:
1. `host gitlab.comdare.de` aus V111-Sicht → `10.0.111.1`.
2. VM `10.0.111.211` baut TCP zu `10.0.111.1:443` auf (HAProxy-Log `Connect from 10.0.111.211 … (https-in/TCP)`), SNI-routet zu `be-gitlab`.
3. Filter-Log: **kein** `block … 10.0.111.211 → … :443` mehr (der SYN-Sturm hört auf).
4. (Falls Fall B) gitlab-Erreichbarkeit aus einem prod-Pod.

**Zugang:** prod1 `ssh -i ~/.ssh/cluster root@10.0.10.211` (bash). opn-1 `root@10.0.10.11` (**csh!** POSIX via `ssh … sh -s <<'EOF'`). config.xml-Backup `config.xml.bak.claude-20260629-143538`. cache-engine GitLab-Projekt-ID 286.

**Bitte bei Rückgabe vermerken:** was du an Unbound/Firewall geändert hast (UUIDs/Regel-Labels) + den VM-DNS-Pfad-Befund (Fall A/B), damit ich gezielt verifiziere.
