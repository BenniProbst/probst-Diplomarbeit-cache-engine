# AUFTRAG D-5: PLAN-HEBUNG TALOS-ZWEI-REGIME — BEFUND

**Status der Anordnung:** Owner 17.08., KON104-01 (`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:24-26`), verbatim: *"D-5: Bitte wie geplant aufbauen, das muss noch."* — KON104-02 (`LEDGER:41-44`): *"D-5 TALOS-ZWEI-REGIME: UMKEHR der Vorlage-Empfehlung -- NICHT zurueckziehen, sondern 'wie geplant AUFBAUEN, das muss noch'. Plan-Hebungs-Explore gestartet (was genau der Plan definiert); wird eigener Bau-/Infra-Posten vor W4. Bis zum Aufbau bleibt die Thesis-Passage als SOLL mit Luecken-Marker, NICHT als IST."* Dieser Bericht liefert die verlangte Plan-Hebung. Keine Zurücknahme-Empfehlung enthalten — die Owner-Entscheidung steht.

---

## 1. SUCHERGEBNIS — WO DIE TALOS-MESS-PLANUNG STEHT

Treffer je Suchraum (case-insensitive `talos`): Ledger 17 · `docs/plaene/` 28 · `docs/sessions/` ~505 (davon geprüft: alle themennahen, s.u.) · `docs/audits/` 1 · `thesis/` 91 · zusätzlich `docs/termine/`, `docs/infra/`, `docs/architektur/`, `docs/bausteine/`, `docs/glossar/` durchsucht (nicht im Auftrag benannt, aber Fundstellen dorthin verweisen). Die Mess-Planung selbst ist **nicht als eigenständiges technisches Dossier** abgelegt, sondern verteilt über vier Schichten:

1. **Ursprungsspezifikation (Betreuer-Termin, 08.05.2026):** `docs/termine/20260508 Termin 7/Begriffsglossar_v7_FINAL.txt:189-205` (BLOCK AO).
2. **Architektur-Entscheidung (ADR-12):** `thesis/diplomarbeit/anhang/de/E_architecture_decisions.tex:143-154` (+ EN-Pendant `anhang/en/...:144-156`).
3. **Diagnose/Empfehlung (die jetzt umgekehrte "Vorlage"):** `docs/plaene/20260806-DIFF-thesis-soll-gegen-ledger-und-code.md` (durchgehend) + `docs/sessions/20260806-GESAMTDOSSIER-session-architektur-und-befunde.md:2320-2361`.
4. **Owner-Frage + -Antwort (17.08.):** `docs/sessions/20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md:261-275` + `LEDGER:19-80` (KON104).

Ein dediziertes **technisches Bauplan-Dokument** ("wie genau bekommt eine Talos-Pod PMC/MSR-Zugriff") existiert in keinem der durchsuchten Verzeichnisse — das ist der zentrale Befund unter Punkt 4.

---

## 2. FUNDSTELLEN WÖRTLICH

### 2.1 Owner-Anordnung (maßgeblich)
- `LEDGER:24-26`: *"D-5: Bitte wie geplant aufbauen, das muss noch."*
- `LEDGER:41-44`: *"D-5 TALOS-ZWEI-REGIME: UMKEHR der Vorlage-Empfehlung -- NICHT zurueckziehen, sondern 'wie geplant AUFBAUEN, das muss noch'. ... wird eigener Bau-/Infra-Posten vor W4. Bis zum Aufbau bleibt die Thesis-Passage als SOLL mit Luecken-Marker, NICHT als IST."*
- `docs/sessions/20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md:261-275` (die Vorlage, die die Owner-Antwort auslöste): *"D-5 -- F-01: die Talos-Aussage in der Abgabe zuruecknehmen? ... EMPFEHLUNG: Zuruecknehmen ..."* — diese Empfehlung ist die vom Owner umgekehrte.

### 2.2 Ursprungsspezifikation (Betreuer, 08.05.2026)
`docs/termine/20260508 Termin 7/Begriffsglossar_v7_FINAL.txt:189-205` (BLOCK AO — Probst-Antwort an Kuehn):
> *"CLUSTER Kubernetes auf Talos OS (minimalistisch, kein Python; ...) / PRODUCTION-MASCHINEN (zwei, Architekt-Beschluss 2026-05-08) • AMD Ryzen 9 9950X3D2 (Zen 5, ...) 16 Cores/32 Threads ... • Intel Core i9-14900KS (Raptor Lake Refresh) Hybrid-CPU: 8 P-Cores + 16 E-Cores ..."*

Diese zwei Maschinen sind **dieselben**, die heute als prod1/prod2 laufen (i9-14900KS wurde per RMA zu i9-12900K, belegt `docs/infra/I112_RUNNER_FLEET_IST_SOLL_ALLE_ARCHITEKTUREN.md` §3.1). Die "Kubernetes auf Talos OS"-Spezifikation von Anfang an war für **dieselbe Hardware** gedacht, die auch die root-Linux-Messung trägt — nicht für separate Maschinen.

### 2.3 ADR-12, aktueller (bereits korrigierter) Wortlaut
`thesis/diplomarbeit/anhang/de/E_architecture_decisions.tex:143-154`:
> *"ADR-12 --- Mess-Regime-Doppel: immutables Talos und root-Linux ... Entscheidung: Auf den Produktions-Zielmaschinen wird jede Messung unter zwei Betriebssystem-Regimes erhoben: einem immutablen Betriebssystem (Talos) als Produktiv-Spiegel und einem root-Linux mit vollem Hardware-Zähler-Zugriff (perf/MSR). Konsequenz: ... die PMC-Kategorien werden nur unter dem privilegierten Regime erhoben. Vollzugsstand: Die Entscheidung gilt, ist aber erst zur Hälfte eingelöst --- die berichteten Messungen stammen sämtlich vom root-Linux-Regime; der Talos-Spiegel bleibt Anforderung und wird nach der Abgabe erhoben."*

Gleichlautend `thesis/diplomarbeit/kapitel/de/05_evaluation.tex:82-92` und `thesis/diplomarbeit/kapitel/de/01_einleitung.tex:223-225` (EN-Pendants `anhang/en/E_architecture_decisions.tex:144-156`, `kapitel/en/05_evaluation.tex:82-92`, `kapitel/en/01_einleitung.tex:220-227` — direkt gegengelesen, inhaltsgleich).

**Wichtig für den Auftrag:** Die Prämisse "die Thesis behauptet jede Messung unter zwei Regimes" trifft auf den **heutigen** (bereits korrigierten) Text nicht mehr im Präsens-Indikativ-Sinn zu — s. Abschnitt 5.

### 2.4 Wie die "Vorlage-Empfehlung" entstand und wieder umgekehrt wurde (Chronologie am Objekt, `LEDGER`)
1. `LEDGER:23059-23063` (06.08. abend-3, zitiert `docs/plaene/20260806-DIFF-thesis-soll-gegen-ledger-und-code.md:64-83`): *"F-01 Talos ... Null Treffer im Code ... Empfehlung: Aussage zuruecknehmen (unter 1 h) statt bauen (mehrere Tage Infra, Cluster read-only)."*
2. `LEDGER:25637` (07.08. morgen-1, KORRIGIERT die erste Diagnose als "zu scharf"): *"DRITTER WEG = Rollentrennung, nichts streichen. ... Talos ist real ... nur eben Infrastruktur, nicht Mess-OS."* — dieser Zwischenstand wurde **selbst wieder verworfen**.
3. `LEDGER:25869-25873` (06.08. abend-3, §2.6, der tatsächlich gültige Zwischenstand vor der Tempus-Korrektur): *"F-01 TALOS -- keine Falschaussage, sondern uneingeloeste Anforderung. ... Loesung ist Tempus/Status praezisieren -- NICHT streichen, NICHT 'Rollentrennung'."*
4. `LEDGER:26606-26616` (07.08. nachmittag-1, VOLLZOGEN, Thesis-Commit `eaf7fe8`): *"VERGESSENE ARBEIT V2 VOLLZOGEN: die Talos-Tempus-Korrektur ... Jetzt vollzogen an drei Stellen je Sprache: Praesens Passiv -> Sollform + Vollzugsstand ('entworfen, aber nicht vollzogen'; ...). ADR-12 behaelt ihr Entscheidungs-Praesens (ADR-Konvention) und bekommt ein eigenes Feld Vollzugsstand."*
5. `docs/plaene/20260806-DIFF-thesis-soll-gegen-ledger-und-code.md:798-802` (die spätere, weiterhin fortgeschriebene "Empfehlung (b)", die am 06.08. GESCHRIEBEN, aber nie durch einen neuen Owner-Beschluss bestätigt war, bis 17.08. **explizit umgekehrt**): *"O-1 · Talos ... Empfehlung: (b)."* — STALE seit KON104, s.o.
6. `docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md:2512` führt "F-01 Talos zuruecknehmen (r3 D1)" noch als offene Owner-Frage — **dieser Eintrag ist mit KON104 ebenfalls überholt** und sollte im Wellenplan als erledigt/umgekehrt nachgezogen werden (Hinweis, keine Ausführung durch mich).

### 2.5 Datenrealität (von mir direkt nachgemessen)
- `Code/measure_out_d03/e4_xml/measurements.csv` (direkt gelesen): 17 Zeilen (1 Header + 16 Datenzeilen), Spalte 160 `platform` trägt in **allen** 16 Zeilen ausschließlich den Wert `linux-x86_64`. **0 Talos-Messzeilen** — Auftragsprämisse bestätigt.
- `.gitlab-ci.yml` (super-Repo, direkt gelesen): `grep -n "talos"` → **0 Treffer**. Die beiden einzigen Mess-Jobs `measure:smoke` (`.gitlab-ci.yml:1920`) und `measure:golden-320` (`.gitlab-ci.yml:2174`) tragen hart `tags: [prod, baremetal, amd]` (`:1924`, `:2175`) — **einlanig AMD/prod1**, kein `intel`-getaggter Messjob existiert überhaupt (0 Treffer `"prod, baremetal, intel"`). Diese Zeilennummern haben sich seit der DIFF-Erhebung vom 06.08. (`:719`/`:806`) verschoben, der Befund selbst ist unverändert.
- `Code/external/comdare-cache-engine/.gitlab-ci.yml`: `grep -n "talos"` → **0 Treffer**.
- `Code/external/comdare-cache-engine/libs/cache_engine/system_axes/operating_system_axis.hpp` (READ-ONLY-Objekt, direkt gelesen): OS-Achse kennt **genau drei** Familien — `LinuxOperatingSystem`, `WindowsOperatingSystem`, `MacosOperatingSystem` — mit `static_assert(kAllOperatingSystemIds.size() == 3);` und Kommentar: *"Katalog-Anker (OP-10): GENAU DREI Familien. Eine vierte Auspraegung bricht hier compile-time -- ... Erst eine echte vierte FAMILIE (z.B. bsd) waere ein bewusstes CT-Ereignis an dieser Zeile."* Talos kommt in dieser Datei **nicht vor**; ebenso 0 Treffer in `operating_system_sub_axes.hpp` (der `os_version`-Unterachse, wo eine Linux-Distribution wie Talos systematisch hingehören würde).

### 2.6 Infrastruktur-Realität — Talos läuft heute als VM auf denselben Maschinen
- `LEDGER:19168`: *"... VM-Last prod2=50 GB (talos18+win2022/11 je12+opn6+samba2)/~12 GB Runner, prod1=40 GB talos/~20 GB Runner ..."*
- `docs/sessions/20260708-INFRA-an-IMPL-prod-runner-concurrency3-threads10-DONE.md:18`: *"🔴 prod2 = Engpass: 62-GB-Host mit 5 VMs (talos-prod2/opn-2/samba-ad-p2/win11/win2022) + Host-Runner (~12 GB Budget)."*
- `docs/sessions/20260627-SESSION-ENDE-3-CI-WAVES-CODEX-PROD2-ELABORATE-UEBERGABE.md:34`: *"prod2 läuft die prod-K8s-CP-VM 'talos-prod2' (KVM, 40GB/20vCPU, VFIO+raw-NVMe) → Stress-Tests/Reboots = kritisches Manöver ..."*
- `docs/sessions/20260807-OWNER-VORLAGE-alle-offenen-entscheide-und-falschaussagen.md:26-27`: *"Talos ist REAL -- das immutable K8s-OS der CI-/Cluster-Schicht (Runner id15 prod-k8s-talos-runner, Control-Plane talos-prod2)."*
- `docs/infra/I112_RUNNER_FLEET_IST_SOLL_ALLE_ARCHITEKTUREN.md` §3.2: `id=15 | prod-k8s-talos-runner | prod, kubernetes, talos | online, concurrent=3, Pod-Limit cpu=8`.

**Zwischenfazit Punkt 2:** Talos ist **kein separates Blech**, sondern eine KVM-Gast-VM, die auf denselben physischen CPUs (prod1 = 9950X3D, prod2 = 12900K) neben Windows-VMs, OPNsense und Samba läuft, welche auch die root-Linux-Bare-Metal-Messung tragen.

---

## 3. REKONSTRUKTION DES GEPLANTEN AUFBAUS

**Maschinen:** prod1 (AMD Ryzen 9 9950X3D, Host-OS Ubuntu bare-metal, Runner id16 `prod-baremetal-prod1`) und prod2 (Intel Core i9-12900K, Host-OS Ubuntu bare-metal, Runner id17 `prod-baremetal-prod2`) — identisch mit der Betreuer-Spezifikation von 08.05. (BLOCK AO, s. 2.2). Auf **denselben** Hosts läuft je eine Talos-K8s-VM (`talos-prod2` bestätigt für prod2; ~40GB-VM auf prod1 gleicher Herkunft), angebunden an Runner id15 `prod-k8s-talos-runner` (Tags `prod, kubernetes, talos`).

**Runner-Weg heute (root-Linux, das einzige Regime mit Daten):** `shell`-Executor direkt auf dem Bare-Metal-Host — **kein Container**, daher sind `cap_add`/Seccomp dort gegenstandslos; `perf_event_paranoid=1` genügt (`docs/plaene/20260806-ANWEISUNG-pmc-intel-perf-rechte.md:24-26`, direkt gelesen).

**Runner-Weg für eine Talos-Lane (der einzige heute existierende K8s-Pfad):** Runner id15 führt Kubernetes-**Pods** aus, keine Shell-Prozesse auf dem Host. Das ist ein strukturell anderes Ausführungsmodell als die heutige Bare-Metal-Messung.

**Wie PMC/MSR-Zugriff unter Talos zustande kommen müsste — das dokumentierte Maß:** Der durchsuchte Korpus enthält **keine** konkrete technische Beschreibung dieses Mechanismus. Was existiert, ist ausschließlich die Empfehlungs-Ebene:
- `docs/plaene/20260806-DIFF-thesis-soll-gegen-ledger-und-code.md:80`: *"(a) Bauen: Talos-Lane als vierten Baustein der OS-Achse + Runner + Mess-Strang. Realistischer Aufwand: mehrere Tage Infra ..."*
- `docs/sessions/20260806-GESAMTDOSSIER-session-architektur-und-befunde.md:2355`: *"Talos-Lane als vierte Auspraegung der OS-Achse, Runner-Installation auf beiden Produktionsmaschinen, Mess-Strang anschliessen | mehrere Tage Infra ..."*

Kein Fund zu: Talos System Extensions (der reguläre Weg, einem immutable-Talos-Node zusätzliche Kernel-Fähigkeiten mitzugeben), privilegiertem Pod/`hostPID`/`CAP_PERFMON`/`CAP_SYS_ADMIN`, `perf_event_paranoid`-Setzung auf Talos-Node-Ebene, oder einem MSR-Geräteknoten-Pfad (`/dev/cpu/*/msr`) unter Talos. Das nächstliegende Muster im Korpus ist `docs/bausteine/09_f_extra_status.md:90-101` ("Multi-Compiler-Pod auf Talos", GCC/Clang-Versionsvielfalt via Pod) — das ist ein Container-pro-Compiler-Muster, **kein** Muster für privilegierten Hardware-Zähler-Zugriff.

**Von mir zusätzlich rekonstruierter, im Korpus nicht diskutierter Befund (Synthese, keine Fundstelle — explizit als solche markiert):** Weil Talos auf denselben Kernen als KVM-Gast neben vier weiteren VMs läuft (s. 2.6), gibt es zwei strukturell verschiedene Wege, "zwei Regime auf derselben Hardware" umzusetzen, zwischen denen der Korpus nirgends entscheidet:
- **(A) Echtes Bare-Metal-Talos:** Talos als tatsächliches Host-OS auf prod1 und/oder prod2 booten (Reboot-Fenster oder Dual-Boot), verdrängt für die Dauer der Kampagne die heutige Ubuntu-Bare-Metal-Messung auf derselben Maschine. Talos unterstützt "Rolling Reboot" bereits als Konzept (`docs/sessions/20260524-V41-open-todos.md:632`: *"Talos Rolling Reboot (#79) — EPHEMERAL Partition expandieren"*), dort aber für Partitionsverwaltung, nicht für einen Mess-Kampagnen-Fensterwechsel dokumentiert.
- **(B) Virtualisierte Talos-Lane (bestehende `talos-prod2`/`prod1`-VM):** erfordert, dass der Hypervisor (KVM/libvirt) echte Hardware-PMCs an den Gast durchreicht (vPMU-Passthrough). Das einzige dokumentierte Passthrough für `talos-prod2` betrifft NVMe über VFIO (`docs/sessions/20260627-SESSION-ENDE-3-CI-WAVES-CODEX-PROD2-ELABORATE-UEBERGABE.md:34`: *"VFIO+raw-NVMe"*) — **kein** Beleg für CPU-PMU-Passthrough. Zusätzlich teilt sich die VM den Host mit vier weiteren Gästen (Rauschen/Nachbarschafts-Effekt), was der von ADR-12 selbst genannten Absicht ("Produktions-Treue" gegen "Mess-Tiefe" sauber trennen) entgegenläuft.

Diese Entscheidung (A vs. B) ist **nirgends im Korpus getroffen** — sie ist der wichtigste offene Konstruktionspunkt, bevor überhaupt Runner- oder Pod-Manifeste sinnvoll sind.

---

## 4. WAS FEHLT — KARTE FÜR EINEN BAU-SLOT VOR W4

### Infra-Posten (Cluster-Territorium, für diesen Agenten und diesen Korpus read-only)
1. **Architekturentscheid (A) vs. (B)** aus Abschnitt 3 — Voraussetzung für alles Weitere; im Korpus nicht einmal aufgeworfen.
2. Bei (A): ein Kampagnen-Fenster-Mechanismus, der den Talos-Boot auf prod1/prod2 orchestriert, ohne die laufende `concurrent=3`-Bare-Metal-CI/Messung zu kollidieren — nicht vorhanden.
   Bei (B): eine Hypervisor-Änderung an der VM-Definition von `talos-prod2` (und der prod1-Talos-VM) für CPU-PMU-Passthrough — kein Infra-Ticket dazu gefunden.
3. Eine **Talos System Extension** (oder gleichwertiger Mechanismus), die perf-/MSR-Tooling in das immutable OS bringt — kein Manifest, kein `talosctl`-Machine-Config-Patch im Korpus.
4. Ein privilegiertes Pod-/DaemonSet-Manifest mit den für `perf_event_open()`/MSR nötigen Rechten (hostPID, CAP_PERFMON/CAP_SYS_ADMIN, Geräteknoten-Mount, node-seitiges `perf_event_paranoid`) — nicht gefunden; das existierende "Multi-Compiler-Pod"-Muster (`docs/bausteine/09_f_extra_status.md:93-99`) ist der nächstliegende, aber sachfremde Vorläufer.
5. Eine CI-Tag-Verdrahtung für die neue Lane: `id15 prod-k8s-talos-runner` (Tags `prod, kubernetes, talos`) wird heute von **keinem** Mess-Job referenziert (0 Treffer `talos` in beiden `.gitlab-ci.yml`, direkt geprüft) — symmetrisch zu `measure:smoke`/`measure:golden-320` fehlt ein `measure:talos-*`-Job komplett.

### Code-Posten
6. **Architekturfrage OS-Achse:** wird `talos` eine **vierte Familie** auf `OperatingSystemAxis` (bricht bewusst `static_assert(kAllOperatingSystemIds.size() == 3)` in `system_axes/operating_system_axis.hpp`) — oder ein Wert der bestehenden Unterachse `os_version` unter der Familie `linux` (Talos ist Linux-Kernel-basiert; genau dieses Prinzip formuliert die Datei selbst: *"Die Distribution ist ... NIE eine vierte Familie ... die Achse traegt die KLASSEN-Identitaet"*)? Diese Weiche ist **nicht entschieden**; die bisherige lockere Formulierung "Talos-Lane als vierten Baustein der OS-Achse" (DIFF-Dokument) trifft implizit Option A, ohne den eigenen Compile-Time-Anker der Codebasis zu erwähnen.
7. Falls das eigentlich gemeinte Konzept ein **quer liegendes "Mess-Privileg-Regime"** ist (Talos-immutable vs. root-Linux-privilegiert), getrennt von der OS-Familien-Achse: dafür existiert **keine** Code-Entsprechung — 0 Treffer für `measurement_regime`/`privilege_regime`/`os_regime` o.ä. in `libs/`/`apps/` (von mir direkt geprüft).
8. Erst nach Klärung von (6)/(7): neue `platform`-Wertausprägung im CSV-Schema (heute ausschließlich `linux-x86_64`), neuer PMC-Source-Zweig, neue Stempel-Behandlung (die Datei markiert jede vierte Familie ausdrücklich als *"bewusstes CT-Ereignis"* — also golden-/ABI-berührend, kein Nebenbei-Fix).

### Mess-Posten
9. Eine tatsächliche Mess-Kampagne unter der gebauten Talos-Lane — heute 0 Zeilen. Die Thesis-Formulierung *"jede Messung"* (Allquantor) verlangt bei wörtlicher Auslegung volle Parität mit dem root-Linux-Korpus; ohne eigene Scope-Festlegung wandert das Allquantor-Problem nur von "0 Talos-Zeilen" zu "wie viele Talos-Zeilen sind genug" — dazu liegt keine Owner-Festlegung vor.
10. Entscheidung, ob mitlaufende Nachbar-VMs (win11/win2022/opn/samba auf demselben Host) während des Talos-Mess-Fensters pausiert werden müssen (Rausch-Kontrolle) — hängt an Punkt 1.

**Abgrenzung zu bestehenden Postenlisten:** Die Aufgaben #82 (*"I-PMC-2/3 BAUEN vor Abgabe"*) und #83 (*"PMC fail-loud-Paket"*) betreffen die **bestehende** root-Linux-PMC-Lane (Härtung/Fehlerklassen), nicht die Talos-Lane — beide Themen sind benachbart, aber nicht deckungsgleich; keine Vermischung vornehmen.

---

## 5. THESIS-PRÜFUNG — WELCHE SÄTZE WÜRDEN NACH DEM AUFBAU ZU IST

Grep `-i talos` über `thesis/diplomarbeit/kapitel/de/*.tex` (wie im Auftrag verlangt, direkt ausgeführt) findet Treffer in 4 Dateien: `01_einleitung.tex:224-225`, `01_introduction.tex:155-156` (Drift, nicht eingebunden), `05_evaluation.tex:85,92`, `06_evaluation_methodology.tex:126` (Drift, nicht eingebunden, DEPRECATED-Kopf `:1-9`). Zusätzlich `anhang/de/E_architecture_decisions.tex:143,147,153` (ADR-12).

**Wichtige Präzisierung gegenüber der Auftragsprämisse:** Die **eingebundenen** (bindenden) Stellen behaupten **heute bereits nicht** mehr im Präsens-Indikativ, dass die Talos-Messung läuft — sie wurden am 07.08. (Thesis-Commit `eaf7fe8`, `LEDGER:26606-26616`) auf eine ehrliche Soll-/Vollzugsstand-Form umgestellt. Ein Bau macht diese Sätze daher nicht einfach "wahr" — er macht die **Lücken-Halbsätze überflüssig** und verlangt deren Streichung/Umschreibung:

| Stelle | Heutiger Wortlaut (Kernaussage) | Wirkung des Baus |
|---|---|---|
| `anhang/de/E_architecture_decisions.tex:143-151` (ADR-12-Hauptsatz) | *"wird jede Messung unter zwei Betriebssystem-Regimes erhoben"* (ADR-Präsens, bewusst so belassen) | Braucht **keine** Wortlaut-Änderung — ADR-Konvention hält den Entscheidungssatz präsentisch, unabhängig vom Vollzugsstand. |
| `anhang/de/E_architecture_decisions.tex:152-154` ("Vollzugsstand"-Satz) | *"ist aber erst zur Hälfte eingelöst ... der Talos-Spiegel bleibt Anforderung und wird nach der Abgabe erhoben"* | Wird durch den Bau **falsch/stale**, nicht wahr — muss nach erfolgreicher Kampagne auf einen Vollzugs-Satz umgeschrieben werden (z. B. "beide Regime sind eingelöst, N Messzeilen je Regime"). |
| `05_evaluation.tex:90-92` | *"Zum Stand dieser Fassung ist das zweite Regime entworfen, aber nicht vollzogen ... der Talos-Spiegel bleibt als Anforderung bestehen"* | Dieselbe Mechanik: Lücken-Satz muss ersetzt werden, wird durch den Bau nicht automatisch "IST". |
| `01_einleitung.tex:223-225` | *"... sollen dafür unter zwei Betriebssystemen ... vermessen werden --- zur Abgabe liegt das root-Linux-Regime vor, der Talos-Spiegel steht aus"* | Gleiches Muster; "sollen ... werden" und "steht aus" sind nach dem Bau redaktionell zu tilgen. |

**Sätze, die bei Reaktivierung ohne Weiteres als IST-Behauptung stünden (aber laut eigener Doktrin NICHT reaktiviert werden dürfen):**
- `01_introduction.tex:155-156`: *"... werden dafür unter zwei Betriebssystemen (immutables Talos und root-Linux ...) vermessen."* — unkorrigiertes Präsens, da Datei nicht `\include`d.
- `06_evaluation_methodology.tex:124-126`: *"wird jede Messung unter zwei Betriebssystem-Regimes erhoben ..."* — ebenfalls unkorrigiertes Präsens; Datei trägt zusätzlich einen expliziten DEPRECATED-Kopf (`:1-9`, KON77-02, 15.08.: *"NICHT reaktivieren; nie loeschen."*).

Diese zwei Dateien zählen laut Struktur-Doktrin (`diplomarbeit.tex:280-285`, sechs `\include`s) **nicht** als Zusage und sind für die Abgabe irrelevant — sie sollten unabhängig vom Talos-Bau deprecatet bleiben.

**Kein durchsuchter Limitierungs-Punkt (`06_fazit.tex`, `anhang/de/tabellen/le_limitierung.tex`) erwähnt Talos** (`grep -in talos thesis/diplomarbeit/kapitel/de/06_fazit.tex` → 0 Treffer, direkt geprüft) — nach erfolgreichem Bau entfällt diese Lücke gegenstandslos; bis dahin bleibt sie unentlastet.

---

## GEPRÜFT / NICHT GEPRÜFT

**GEPRÜFT (direkt am Objekt, Datei gelesen bzw. Kommando ausgeführt):**
- Alle zitierten Ledger-Stellen (Zeilen via Read-Tool verifiziert).
- `docs/plaene/20260806-DIFF-thesis-soll-gegen-ledger-und-code.md` vollständig gelesen (864 Zeilen).
- `docs/sessions/20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md`, `20260807-OWNER-VORLAGE-alle-offenen-entscheide-und-falschaussagen.md`, `20260807-SESSION-UEBERGABE-alle-fragen-sind-beantwortet.md`, `20260806-GESAMTDOSSIER-session-architektur-und-befunde.md` (relevante Abschnitte), `20260708-INFRA-an-IMPL-...`, `20260627-SESSION-ENDE-3-CI-WAVES-...`, `20260524-V41-open-todos.md` gelesen.
- `docs/audits/20260716-e11-...` (einziger Treffer) gelesen.
- `docs/termine/20260508 Termin 7/Begriffsglossar_v7_FINAL.txt` (BLOCK AO) gelesen.
- `docs/infra/I112_RUNNER_FLEET_...md`, `docs/architektur/23_SYSTEMACHSEN_KONZEPT_...md`, `docs/bausteine/09_f_extra_status.md` gelesen.
- Thesis DE: `01_einleitung.tex`, `01_introduction.tex`, `05_evaluation.tex`, `06_evaluation_methodology.tex`, `06_fazit.tex`, `anhang/de/E_architecture_decisions.tex` direkt gelesen; EN-Pendants per `grep` mit Kontext gegengelesen.
- `Code/measure_out_d03/e4_xml/measurements.csv` direkt gelesen (16/16 Zeilen `linux-x86_64`).
- `.gitlab-ci.yml` (super + ce) direkt auf `talos`-Tags geprüft (0 Treffer beide) und Mess-Job-Tags verifiziert (`measure:smoke`/`measure:golden-320`, beide `[prod, baremetal, amd]`).
- `system_axes/operating_system_axis.hpp` und `operating_system_sub_axes.hpp` (ce, read-only) direkt gelesen/geprüft.

**NICHT GEPRÜFT (außerhalb des mir zugänglichen Korpus oder nicht auffindbar):**
- Das separate **Cluster-Infra-Repo** selbst (nur über Zitate/Kopien in diesem Super-Repo erreichbar, z. B. `docs/infra/`, Ledger-Übernahmen aus `Cluster/docs/sessions/...`) — ich habe keinen direkten Zugriff darauf und konnte daher nicht prüfen, ob dort (außerhalb dieses Korpus) ein detaillierterer Talos-PMC-Bauplan existiert, den die hier durchsuchten Dokumente nicht zitieren.
- Ein etwaiges Talos-System-Extension-Manifest oder privilegiertes Pod-Manifest — mit den mir verfügbaren Suchpfaden **nicht gefunden**; ob so etwas in einem der weiteren ~480 ungeprüften `docs/sessions/`-Treffer (überwiegend Journale/Backups, thematisch als Rauschen einsortiert nach Stichprobenprüfung) verborgen liegt, ist nicht mit Sicherheit auszuschließen, aber nach gezielter Stichwortsuche (System Extension, privileged, hostPID, CAP_SYS_ADMIN/RAWIO, dual-boot, vPMU/Passthrough) unwahrscheinlich.
- Die vPMU-Passthrough-Analyse (Abschnitt 3, Optionen A/B) ist **meine eigene Synthese** aus belegten Einzelfakten, nicht selbst eine Fundstelle — im Text ausdrücklich so gekennzeichnet.
- Aktueller Live-Zustand von `talos-prod2`/prod1-Talos-VM (z. B. ob zwischenzeitlich doch ein PMU-Flag gesetzt wurde) — nur die dokumentierten Stände bis 17.08. eingesehen, keine Live-Cluster-Abfrage (Cluster read-only, außerhalb meines Zugriffs).