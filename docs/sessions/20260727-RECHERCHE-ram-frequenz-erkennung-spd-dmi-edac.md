# RECHERCHE 27.07.2026 — RAM-Frequenz-Erkennung per OS (Grundlage Task #7 Hardware-Erkennungs-Factory)

> Anlass: Owner-Direktive 27.07. („Hardware-Werte nie statisch; CEB liest zur Laufzeit aus dem OS;
> Klasse mit Factory-Pattern über Systemachsen ISA×OS; OS-Bibliotheken als Hilfen erlaubt").
> Recherche-Agent: Research-HWDetect (lief AUF prod1 — Großteil direkt gemessen, nicht nur belegt;
> 27.07.2026, Kernel 6.17.0-35, Ubuntu 24.04.4, MSI MEG X870E ACE MAX, Ryzen 9950X3D).
> prod2 war nicht erreichbar (kein SSH-Key) — prod2-Aussagen sind Literatur-/Repo-Stand.
> Memory-Anker: feedback_hardware_erkennung_factory_laufzeit_nie_statisch.

## 1. KERNBEFUND

Die tatsächlich KONFIGURIERTE RAM-Frequenz ist unter Linux ohne root NICHT auslesbar. Einzige
Quelle: SMBIOS Type 17 „Configured Memory Speed" — verifiziert root-only
(/sys/firmware/dmi/tables/DMI = -r-------- root root; dmi-sysfs entries/17-* existieren, raw
ebenfalls 0400, Kernel gibt pro Entry alles-oder-nichts frei, Type 17 enthält Seriennummern).
gitlab-runner hat kein sudo (verifiziert). MSR 0600, /dev/mem 0640 root:kmem, PCI-Config
non-root auf 64 Byte begrenzt (MCHBAR damit unerreichbar), debugfs 0700.

ABER: **SPD ist KEIN root-Kanal.** /sys/bus/i2c/devices/1-0051/eeprom und 1-0053/eeprom sind
0444 (world-readable) und wurden als normaler User gelesen (1024 Byte, 82 ms, 5 Läufe bitgleich):
- Byte 2 = 18 → DDR5
- tCKAVGmin (Byte 20/21) = 416 ps → JEDEC-Basis 4800 MT/s
- XMP-3.0-Magic (0x0C 0x4A) bei Byte 640 („Profile 1/2/3 Ultra"), EXPO-Magic bei Byte 832
- Profil-tCK 357 ps → 5600 MT/s (ANGEBOT der Riegel, nicht notwendig aktiv)
- 2 bestückte Slots

SPD liefert unprivilegiert: Typ, JEDEC-Nennwert, Bestückung, XMP/EXPO-Angebot.
SPD liefert NICHT: welches Profil das BIOS aktiviert hat (Ist-Takt).

CI-Relevanz: Runner = Shell-Executor direkt auf dem Host (kein Container-Namespace dazwischen;
Docker auf prod1 nicht installiert) → der SPD-Weg steht CI-Jobs heute offen.

## 2. EDAC: FINAL ERLEDIGT (beide Hosts, beide Richtungen)

- ABI doppelt geprüft (Documentation/ABI/testing/sysfs-devices-edac + drivers/edac/edac_mc_sysfs.c):
  pro DIMM nur size/dev_type/edac_mode/label/location/mem_type/ce_count/ue_count — KEIN Takt,
  KEIN MT/s. (Falle: sdram_scrub_rate ist Scrubbing-Bandbreite in Byte/s, KEINE Frequenz.)
- prod1: mc/ leer; CONFIG_EDAC=y, EDAC_AMD64=m nicht geladen; amd64_edac braucht praktisch ECC
  (Parameter ecc_enable_override belegt das) → modprobe erzeugte wohl nicht einmal mc0.
- prod2/Alder Lake: igen6_edac führt dieselbe Attributmenge (keine Frequenz) und bricht ohne
  In-Band-ECC den Probe ab („In-Band ECC is disabled" → -ENODEV; vorgelagert ibecc_available).
  Consumer-Desktop ohne IBECC ⇒ nie ein mc0.
- Den DDR4/DDR5-TYP liefert SPD unprivilegiert ohnehin ⇒ EDAC restlos entwertet.

## 3. METHODEN-MATRIX (Kondensat)

| Methode | root? | liefert | prod1 (gemessen) | prod2 (Literatur/Repo) |
|---|---|---|---|---|
| SMBIOS T17 Configured Speed | JA | IST-Takt | Datei da, gesperrt | Repo-4800 wurde so erhoben |
| SMBIOS T17 Speed | JA | Nennwert | dito | dito |
| SPD via spd5118-eeprom | NEIN (0444) | Typ+JEDEC+Bestückung+Profil-Angebot | FUNKTIONIERT | RISIKO s. §5 |
| EDAC sysfs | (root für modprobe) | nur Typ/Geometrie | mc/ leer | igen6 ohne IBECC: nie mc0 |
| dmidecode CLI | JA | wie SMBIOS | Permission denied als User | dito |
| lshw non-root | nein | nur Gesamtgröße | verifiziert leer | dito |
| MSR / MCHBAR / ryzen_smu | JA | Ist-Takt, fragil/modellspezifisch | gesperrt | dokumentiert, NICHT empfohlen |

## 4. BIBLIOTHEKEN: KEIN VENDORING

hwinfo (MIT: nur /proc/meminfo, DIMM-TODO im Code), hwloc (BSD-3: MemoryModule ohne
Frequenz-Attribut, zudem „when privileged"), infoware (CC0: Doku schweigt), libcpuid (CPU-only),
fastfetch (C; offener Feature-Request, verweist auf dmidecode). KEINE löst das Problem — alle
kapseln dieselben zwei Quellen (SPD/DMI). Empfehlung: eigener SPD-Byte-Parser (<200 Zeilen C++23,
keine Abhängigkeit; prototypisch mit od+sed belegt). Passt besser zur Vendoring-Doktrin als eine
Fremdbibliothek, die die Kernfrage nicht beantwortet.

## 5. OFFENE PUNKTE / RISIKEN

1. **prod2-SPD-Check (EINZIGER vor dem Design zu klärender Punkt):** Auf Intel registriert
   i2c-i801 die SPD-Geräte; eine 2025er-Patch-Serie (Canonical) unterbindet das bei gesetztem
   BIOS-„SPD Write Disable"-Bit — dann existieren die eeprom-Knoten auf prod2 NICHT.
   Klärung: `ls -l /sys/bus/i2c/devices/*/eeprom` auf prod2 (read-only) → Infra-Handout.
2. **Portabilität:** piix4-SPD-Autoregistrierung erst seit Kernel 2024; prod1 hat
   CONFIG_SENSORS_SPD5118_DETECT nicht gesetzt (Geräte existieren nur, weil der Bustreiber sie
   explizit anlegt). Ältere Kernel der 8er-Docker-Matrix haben den Pfad nicht ⇒ Erkennung darf
   NIE im Bau-Graphen hängen (deckt sich mit machine_identity.hpp:44-49).
3. **prod1-Ist-Takt:** JEDEC 4800 vs. XMP/EXPO-Angebot 5600 — aktives Profil ohne Stufe 1 nicht
   feststellbar; die 0 in target_isa_complex_axis.hpp:191 ist derzeit die EINZIGE ehrliche Angabe.
   (Die „DDR5-5600 CL36" der alten Planungsdoks sind offenbar genau die XMP/EXPO-Profile.)

## 6. EMPFEHLUNG: FALLBACK-KETTE MIT PROVENIENZ

Jedes Ergebnis trägt PROVENIENZ + Erhebungszeitpunkt; die Kette bricht bei der höchsten
erreichbaren Vertrauensstufe, nicht beim ersten Wert:

- **Stufe 1 „configured_measured":** NUR über Infra-Kanal möglich — systemd-Oneshot beim Boot
  schreibt als root `dmidecode --type 17` in eine world-readable Datei, CEB liest sie.
  ES GIBT KEINE ALTERNATIVE. (setcap-Helper mit cap_dac_read_search verworfen: Lesezugriff aufs
  gesamte Dateisystem — Boot-Cache ist das kleinere, protokollierbare Übel.)
- **Stufe 2 „spd_jedec_base":** SPD-EEPROM (Byte 20/21 u.a.). Unprivilegiert, heute baubar,
  keine Infra-Änderung. XMP/EXPO-Angebot als SEPARATES Feld, NIE als Ist-Wert.
- **Stufe 3 „declared_not_measured":** XML-Deklarationswert wie heute.

Stufe 2 darf Stufe 3 nur mit mitwandernder Kennzeichnung verdrängen (sonst steht 4800 in der
CSV, während die Maschine womöglich 5600 fährt — schlimmer als ehrlich deklariert).
PRAKTISCH: BEIDE Stufen bauen, Stufe 2 ZUERST (sofort lieferfähig); Stufe 1 = paralleles
Infra-Ticket. Ohne Stufe 1 bleibt der Ist-Takt strukturell unbeweisbar → CSV weist das aus.

## 7. FACTORY-DESIGN-ECKPUNKTE (ISA×OS)

- OS-Achse COMPILE-TIME (Abstract Factory, statischer Dispatch — CT-Doktrin), da Ziel-OS zur
  Bauzeit feststeht.
- Backend-Kette INNERHALB eines OS = RUNTIME Chain of Responsibility (sysfs-Verfügbarkeit steht
  erst zur Laufzeit fest) — exakt der CoR-Zuschnitt der Heuristik-Messkurven.
- Windows: Win32_PhysicalMemory ConfiguredClockSpeed vs. Speed (MSDN: ConfiguredClockSpeed
  stammt aus demselben SMBIOS-Feld — identische Unterscheidung). macOS: system_profiler
  SPMemoryDataType OHNE konfiguriert/maximal-Unterscheidung → dort dauerhaft nur Stufe-2-Äquivalent.

## 8. ANSCHLUSS AN DEN REPO-IST (abzulösende Stellen)

- machine_identity.hpp:217 (prod2 = 4800)
- system_axis_registry.xml:22 (declared="true" value="4800"; Zeile 17: prod1 declared="false")
- target_isa_complex_axis.hpp:188/:191 (static_assert 4800U / 0U — Wachen auf Hardware-Zahlen
  sind per Owner-Direktive Regression)

**THESIS-EHRLICHKEITSNOTE (übernehmen!):** machine_identity.hpp:192 belegt, dass die statische
4800 bereits per `dmidecode --type 17` erhoben wurde (Configured==Speed). Der statische Wert IST
ein eingefrorenes Stufe-1-Ergebnis. Der Gewinn der Factory ist daher NICHT „statisch → gemessen",
sondern „einmalig von Hand → automatisiert bei jedem Lauf, mit Provenienz und
Erhebungszeitpunkt". Anders formuliert verspräche die Arbeit eine Messung, wo eine
automatisierte Wiedervorlage steht.

## 9. QUELLEN

EDAC: docs.kernel.org/driver-api/edac.html · Documentation/ABI/testing/sysfs-devices-edac ·
drivers/edac/edac_mc_sysfs.c · drivers/edac/igen6_edac.c · cateee.net/lkddb/web-lkddb/EDAC_IGEN6 ·
lkml.iu.edu/hypermail/linux/kernel/2106.1/05860.html
SPD/i2c: docs.kernel.org/hwmon/spd5118.html · lwn.net/Articles/976467 ·
patchew.org/linux/20250528-for-upstream-not-instantiate-spd5118-v1-1-8216e2d38918@canonical.com ·
patchew.org/linux/20240530-piix4-spd-v1-1-9cbf1abebf41@weissschuh.net ·
kernel.org/doc/html/next/i2c/busses/i2c-i801.html · manpages.debian.org decode-dimms(1)
SMBIOS/DMI: DMTF DSP0134 3.5.0 · learn.microsoft.com Win32_PhysicalMemory ·
drivers/firmware/dmi-sysfs.c · access.redhat.com/solutions/7003341 · man7 capabilities(7)
Intel MCHBAR: edc.intel.com 12th-gen datasheet vol.2 (D0:F0 MCHBAR memory controller registers)
Bibliotheken: github lfreist/hwinfo src/linux/ram.cpp · open-mpi/hwloc NEWS · ThePhD/infoware ·
anrieff/libcpuid · fastfetch-cli/fastfetch memory_linux.c · leogx9r/ryzen_smu
