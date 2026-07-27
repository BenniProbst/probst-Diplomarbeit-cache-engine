# PLAN 27.07.2026 — Hardware-Erkennung ZWEI-EBENEN: Planer-RT wählt CT-Plattform, CEB trägt Familien-Erkennung + ISA×OS-Passungs-Stempel (Task #7)

> AUTORITÄT: Owner-KERN 27.07. („Hardware-Werte nie statisch; CEB liest zur Laufzeit; Klasse mit
> Factory-Pattern über Systemachsen ISA×OS") + Owner-PRÄZISIERUNG 27.07. später (verbatim-nah):
> Die CEB-System-Achsen sind statisch einkompilierte Haupt-Achsen ⇒ die VEREINFACHTE Erkennung
> für die Einkompilation einer detaillierten CT-Erkennung für ISA(vendor)×OS findet durch den
> PLANER zu DESSEN Laufzeit statt, um den CEB-Bau auf eine Plattform und deren Erkennung
> auszurichten; die CEB bringt eine Erkennungs-Software für einen GRÖSSEREN CPU-Bereich mit und
> wird um die STEMPEL der System-Achsen ISA×OS erweitert, für die sie passt (bisher nur die
> gesamte Mess-Achsen-Klammer aus dem Planer).
> QUELLEN: Recherche-Doc 20260727-RECHERCHE-ram-frequenz-erkennung-spd-dmi-edac.md ·
> ultracode-Workflow hw-factory-design-plan (7 Agenten: Kartierung + 3 Design-Perspektiven +
> 3 adversariale Reviews, alle „tragfähig-mit-auflagen"; Journal wf_edc83047-744) ·
> Explore-Kartierung Planer-/Stempel-/Dock-Naht (Map-PlanerStempel).

## 1. IST-BEFUND (kartiert, datei:zeile; ce-Root = Code/external/comdare-cache-engine)

**Owner-Aussage „CEB trägt nur die Mess-Klammer" stimmt im Kern exakt:** Die CEB-Binary trägt
ausschließlich kCebMeasurementStamp (load_framework+tooling, ceb_version_stamp.hpp:129-131);
ihr SHA-512-Fingerprint hat organ-, SYSTEM- und merge-Slot buchstäblich LEER (:135-137 —
zweites Argument ""). Präzisierung 1: Die Zeile ist das Angebot in VOLLMENGE (consteval aus
den Registries), die Planer-Wahl (COMDARE_MEASUREMENT_COMBO) landet nur in der TIER-Binary
(anatomy_version_stamp.hpp:203-222), nie in der CEB. Präzisierung 2: target_isa/operating_system
stehen in der Tier-System-Zeile nur als Achsen-NAMEN mit Code-Version (:96-109) — WERTE
(„x86_64", „linux") führt niemand; Passung ist heute nicht prüfbar.

**Planer-Seite:** Die einzige „Plattform-Entscheidung" ist eine String-Heuristik über simd_id
(measure_host_lane, experiment_plan_director.hpp:466-473; Host-Zuordnung nur im Kommentar
:456-465). Die echte CPUID-Erkennung existiert vollständig und unprivilegiert
(machine_identity.hpp:261-298 live_core_cpu_id + :240 live_hostname), wird aber nur als
nicht-gerenderte Annotation (:170/:1904) und als SIMD-Gate-Fallback benutzt. Die
C-3c-KLASSEN-Zulassung ist INERT: set_active_machine_declaration (simd_build_gate.hpp:234)
hat 0 Produktions-Aufrufer (dokumentiert profile_run_entry.hpp:220-225). CebCompoundSystemAxis
+ TargetIsaComplexAxis haben außer eigenen asserts + Registry-Gen KEINEN Konsumenten.

**Dock-Naht:** anatomy_module_loader.cpp:105-155 prüft Magic + host_compatible_with (:143),
aber das optionale 5. ABI-Symbol comdare_anatomy_version_lines (AnatomyVersionLines-POD,
Layout 5, sizeof==136, abi_v1_decl.hpp:153-197) wird beim Laden NIE gelesen — die Stempel
reisen mit, niemand fasst sie an. Statuscode 9 (platform_mismatch) wäre rein additiv.

**Statischer RAM-Wert:** EINE Quelle kDeclaredMachines (machine_identity.hpp:144/:217,
prod2=4800 mit dmidecode-Provenienz :192 = eingefrorenes Stufe-1-Ergebnis), reflektiert via
Registry-Gen (tools/system_axis_registry_gen/main.cpp:321-341) in system_axis_registry.xml:17/:22
(declared-Attribut), byte-bewacht durch test_system_axis_registry_roundtrip (FATAL bei Drift,
Handedit verboten). CT-Zahlen-Pins target_isa_complex_axis.hpp:188 (==4800U) / :191 (==0U);
Ehrlichkeits-Anker-Block :171-200 mit has_all_members_declared (:102/:197).

## 2. ZIEL-ARCHITEKTUR (Zwei-Ebenen + Stempel, review-bereinigt)

**EBENE 1 — PLANER (Laufzeit des Planers):** Vereinfachte Plattform-Erkennung ISA-Vendor×OS
per vorhandener CPUID-Erkennung (live_core_cpu_id) + CT-OS-Konstante. Andock-Punkt:
profile_run_facade.cpp:841-849 (Director-Konstruktion; graceful-Fallback-Muster wie das
Registry-Lesen davor). Wirkung: (a) ersetzt die measure_host_lane-String-Heuristik durch
identifizierte Maschine/Klasse (resolve/identify_machine), (b) macht die inerte C-3c-Zulassung
produktiv (erster Produktions-Aufrufer von set_active_machine_declaration), (c) richtet den
CEB-BAU aus: Wahl der CT-Plattform-Spezialisierung (welche Familien-Erkennung einkompiliert
wird) + Emission der Passungs-Werte als Compile-Defines in die CEB-/Tier-Bau-Zeilen (der in
anatomy_version_stamp.hpp:89-95 wörtlich vorgemerkte W10-Anschluss — Emitter bleibt system-blind).
Aufnahme in den PlanHeader (director.hpp:123-155).

**EBENE 2 — CEB (Laufzeit der CEB):** Einkompilierte Erkennungs-Software für die
PLATTFORM-FAMILIE (größerer CPU-Bereich, nicht exakte Maschine). Struktur:
- CT: Factory über die OS-Achse als Template-Spezialisierung (statischer Dispatch, CRTP+Concept,
  kein Runtime-Achsen-Switch, kein std::variant). GoF-Etikett ehrlich halten: mit nur einem
  Produkt ist es Factory Method; Abstract Factory erst mit zweitem Produkt derselben Familie
  (CAS-/Bestückungs-Erhebung aus demselben SPD-Leser) — Etikett entsprechend wählen (E-6).
- RT: Erhebungs-Kette je OS als GoF-CoR (Vorbild selection_filter_chain.hpp:49, cold-path):
  BootCacheDmi (Stufe 1 configured_measured) → SpdEeprom (Stufe 2 spd_jedec_base, eigener
  DDR5-Parser <200 Zeilen, reine span-Funktion, kein Vendoring) → Declared (Stufe 3 Terminal
  über resolve_machine_by_properties, Schlüssel wird NIE umgeschrieben). Ketten-Verdrahtung
  CT als Typliste (std::tuple — heterogene Handler-Typen; std::array unmöglich, Review-Auflage),
  Traversierung RT; Konstruktion lazy an der CEB-Freigabe-Naht (neben live_hostname/
  identify_machine), EINMAL je Prozess (call_once; Mess-Doktrin: 1 Prozess je Lauf), NIE
  Statik-Init-IO, NIE Bau-Graph, NIE Hot-Path.
- Ergebnis: RamFrequencyReading{mts, provenance, collected_at, spd_typ, xmp_offer_mts SEPARAT,
  degradations_pfad} + verify_declared_ram-Verdikt (Match/NurDeklariert/NichtErhoben/
  Abweichung/EtikettWiderspruch — benanntes Urteil nach O-4-Vorbild verify_declared_cpu).

**PASSUNGS-STEMPEL (neu, statisches Haupt-Achsen-Datum — KEIN Laufzeitwert):** Die CEB-Binary
trägt einkompiliert die ISA×OS-Zell-WERTE ihres Gültigkeitsbereichs (z.B.
target_isa=x86_64-amd-zen-familie; operating_system=linux) an drei Orten:
(a) ceb_version_stamp.hpp:129-137 — zweites consteval-Segment; der leere System-Slot des
Fingerprints ist exakt dafür frei; (b) Tier-Seite über den vorgemerkten W10-Anschluss
(Compile-Define, Emitter bleibt system-blind); (c) ABI: append-only POD-Feld in
AnatomyVersionLines (Layout 5→6, sizeof 136→152 — etabliertes Wachstums-Muster, ABER
ABI-Ereignis ⇒ E-1). DOCK-PRÜFUNG: Loader liest das (bisher nie gelesene) 5. Symbol und
prüft Passung zwischen anatomy_module_loader.cpp:145 und :148; neuer Statuscode 9
status_platform_mismatch (additiv). Section-43-Invariante bleibt: gemessene WERTE (RAM-MHz)
kommen NIE in Stempel/binary_id — der Passungs-Stempel ist die CT-Plattform-KLASSE, kein Messwert.

## 3. BINDENDER AUFLAGEN-KATALOG (aus den 3 adversarialen Reviews konsolidiert)

A1. :188 (==4800U) fällt und wird zu Präsenz-Anker !=0U + Laufzeit-verify_declared_ram;
    :191 (prod1==0U) BLEIBT (pinnt die Abwesenheits-MARKE, keine Hardware-Zahl); :194-200
    (CAS/has_all_members_declared) bleiben bis CAS-Entscheid (E-5). Alle drei Ersatz-Schichten
    (Zustands-Asserts + Roundtrip-Byte-Gate + Laufzeit-Verdikt) im SELBEN Paket — nie ein
    Zwischenstand ohne alle drei.
A2. Provenienz-Reinheit: Registry-XML erhält NUR Deklarations-Stufen (Generator probt NIE,
    bleibt maschinen-unabhängig byte-stabil); prod2-4800 wird NICHT als configured_measured
    emittiert — der eingefrorene Stufe-1-Ursprung wird als source_id-Notiz konserviert
    (z.B. declaration_source="dmidecode 2026-07"), nicht als Stufe. Laufzeit-Stufen 1/2
    erscheinen ausschließlich in CSV+Log, nie in XML/Stempel/binary_id.
A3. verify_declared_ram erhält eine Provenienz-Gleichheitsregel: spd_jedec_base wird nie
    gegen einen configured-Ursprung als „Match/Abweichung" geurteilt (ungleiche Größen);
    Vergleich nur stufen-kompatibel, sonst NurDeklariert-artige Ausweisung.
A4. ProbeStatus unterscheidet QuelleFehlt von QuelleKORRUPT: korrupte vorhandene Quelle
    (SPD-Müll, halbe Boot-Cache-Datei) degradiert NICHT still — eigenes Fehler-Etikett im
    Degradations-Pfad + Log. Fehlerklassen als EIGENE Domäne (ErrorDomain::HardwareProbe,
    Muster InfraErrorClass) — die D1-Count==5-Wache (machine_identity.hpp:433) wird NICHT
    berührt (RF-3-Kollisionslehre).
A5. BootCacheDmi mit boot_id-Frische-Wache (stale Datei ⇒ Durchfallen, nie configured
    ausweisen). SICHERHEIT: Boot-Cache-Format wird auf benötigte Felder GEFILTERT
    (Typ/Speed/Configured Speed/Slot) — ein roher dmidecode-T17-Dump würde DIMM-Seriennummern
    world-readable exponieren (der Grund der Kernel-Sperre!). Infra-Handout-NACHTRAG nötig.
A6. declared-Attribut der XML nicht blind ersetzen: Konsumenten-Inventar VOR dem Umbau
    (Planer/Resolver, test_experiment_kern_seam); notfalls declared + provenance additiv.
A7. CSV: additive End-Spalten (Vorbild pmc_available + #171-Muster), Spaltennamen
    provenienz-ehrlich (KEIN „effective"); XMP/EXPO-Angebot hat keinen API-Pfad, der es als
    frequency zurückgibt; Einheiten-Naht dokumentieren (Feld heißt _mhz, trägt MT/s —
    Bestands-Falle machine_identity.hpp:59). na_tokens-Regel: nicht erhoben ⇒ n/a-Token,
    nie 0-Zahl in der Wert-Spalte. Führung durchs KERN-Mess-Schema (replace/merge/fulljoin).
A8. Windows/macOS: Linux-first; Windows-WMI-Backend wird NICHT ungetestet ausgeliefert
    (ehrliches Nicht-Implementiert-Durchfallen auf Stufe 3); macOS declared-only als bewusste,
    dokumentierte Entscheidung (system_profiler wäre Prozess-Aufruf — Doktrin-Verbot).
A9. Test-Doktrin (3× real bei O-8): Fixtures/Erwartungen aus kDeclaredMachines/Generator
    ABLEITEN, nie handkopieren; auch den dritten Ableitungsweg testen (Roundtrip, CSV-Spalten,
    Stempel-Neutralität); Pfad-Injektion für Backends (CI testet decline-Pfade + eingespielte
    Puffer, nie Live-Hardware-Werte); prod2-Erwartung bis Infra-Check = benannter Stufe-3-Fall.
A10. Golden-Neutralität strukturell: RamFrequencyReading wird von keiner Stempel-/Achsen-API
    akzeptiert (Typ-Schnitt); collected_at nie in byte-gegateten Artefakten; target_isa bleibt
    binary_id=never (RF-6); TABU-Anker (CRC 0x56F1B721C72DC10E, 320er, permutation_axes.xml,
    ABI-7) unberührt.

## 4. PAKET-SEQUENZ (je Paket ein Impl-Auftrag, granulare Commits, Zwei-Gate-Beweise)

P1 (additiv, golden-neutral): Provenienz-Vokabular + RamFrequencyReading + Fehler-Domäne
   HardwareProbe (axis_error.hpp additiv, beide Drift-Wachen-Richtungen, Token-Disjunktheit
   gegen ALLE bestehenden Zell-Vokabeln) + SPD-DDR5-Parser mit Fixture-Tests (prod1-Dump,
   truncated, korrupt, DDR4, XMP/EXPO ±).
P2: RT-Kette + OS-Factory + acquire an der CEB-Freigabe-Naht (Pfad-Injektion, Docker-Fall =
   leerer Baum → Stufe 3); verify_declared_ram + Verdikt.
P3 (EIN atomarer Commit, Roundtrip-FATAL): DeclaredMachine + declaration_source/provenance-
   Emission im Generator + XML-Regenerat + Anker-Migration :171-200 (A1) + Konsumenten-Inventar
   (A6) + Fixture-Mitzug (A9).
P4: CSV-Rückschrieb additiv (A7) + Konsumenten-Prüfung (04_csv_to_latex, xlsx, report_exporter).
P5 (PASSUNGS-STEMPEL, nach E-1): Planer-Erkennung an facade:841 (C-3c produktiv, Heuristik-
   Ablösung, PlanHeader) + CEB-System-Segment (Fingerprint-Slot 2) + W10-Compile-Define +
   POD-Feld Layout 6 + Loader-Lesung + status 9 + Dock-Test.
P6: Stufe-1-Anbindung nach Infra-Kontrakt (gefiltertes Format + boot_id); bis dahin fällt die
   Kette ehrlich auf 2/3 durch — kein Blocker für P1-P5.

## 5. OFFENE OWNER-ENTSCHEIDE (E-1..E-8)

E-1 ABI-POD-Erweiterung AnatomyVersionLines Layout 5→6 (+Passungs-Feld, sizeof 136→152,
    append-only): ABI-Ereignis — GO nötig (ABI-7-Tabu-Nähe; Muster 4× etabliert). EMPFEHLUNG: GO.
E-2 ddr4_2x32→ddr5-Schlüssel-Fix (halbe Identität; XML+Reflektion+Stempel gleichzeitig):
    eigenes kleines Paket VOR Messbeginn; bis dahin EtikettWiderspruch = benannter
    NICHT-Fehler-Zustand (Log+CSV, keine Dispatch-Wirkung). EMPFEHLUNG: GO als P3-Nachbar.
E-3 Registry-XML: declared ERSETZEN durch provenance vs. BEIDE additiv. EMPFEHLUNG: additiv
    (A6-Konsumenten-Schutz), Ablösung im §75-Pass.
E-4 Fehlerklasse für RAM-Drift: HardwareErweiterungFehlt dehnen (dokumentierte Präzedenz
    verify_declared_cpu) vs. sechste Klasse (zieht Count-Wachen). EMPFEHLUNG: eigene
    HardwareProbe-DOMÄNE (A4) + Drift auf bestehende Klasse mit dokumentierter Dehnung.
E-5 CAS-Latenz (SPD tAAmin) im Erstausbau miterheben (kippt :194/:197-Anker) vs. Folge-Paket.
    EMPFEHLUNG: Folge-Paket (Erstausbau schlank halten).
E-6 GoF-Etikett: Factory Method jetzt (ehrlich, 1 Produkt) vs. Abstract Factory mit CAS als
    zweitem Produkt. EMPFEHLUNG: Abstract Factory + CAS/Bestückung als zweites Produkt in P5/E-5.
E-7 Passungs-Bereich-Granularität des Stempels: exakte Maschine vs. Familien-Klasse
    (Owner-KERN sagt „größerer Bereich an CPUs"). EMPFEHLUNG: Familien-Klasse (z.B.
    x86_64-amd-zen/x86_64-intel-core) + Maschinen-Tupel als Zusatzzeile.
E-8 prod2-SPD-Ausgang (Infra-Check läuft): entscheidet nur Test-Erwartung, nicht Struktur.

## 6. VERIFIKATION

Je Paket: Zwei-Gate (ce-standalone 317+n Doppellauf ungekürzt; CI-Zwilling baut), cf22-Selbst-
check des Agenten (~/tools/cf22/usr/bin/clang-format-22, literale leere Ausgabe) + Manager-
Abnahme, ASCII sed-Form, Roundtrip-Byte-Gate wo XML berührt, golden-Neutralität literal
(Tabu-grep leer), Fixture-Ableitungs-Nachweis (A9). P5 zusätzlich: Dock-Negativ-Test (Binary
mit fremdem Passungs-Stempel ⇒ status 9, nie stiller Lauf).

*Erstellt aus ultracode-Planungssession (7 Workflow-Agenten + Explore-Kartierung + Recherche).
Rohdaten: Workflow-Journal wf_edc83047-744; Extrakt im Session-Scratchpad. Nächster Schritt:
Owner-Entscheide E-1..E-7, dann P1-Beauftragung (voraussichtlich Impl-CE-6de).*

---
## NACHTRAG ~17:45Z — OWNER-FREIGABE

Owner 27.07. (~17:45Z, verbatim): "Alle Punkte korrekt und wie empfohlen freigegeben, volles GO"
=> E-1 GO (ABI-POD Layout 5->6 append-only) · E-2 GO (ddr4->ddr5-Schluessel-Fix als eigenes
Paket, P3-Nachbar, VOR Messbeginn) · E-3 additiv (declared+provenance; Abloesung erst §75) ·
E-4 eigene HardwareProbe-Domaene + dokumentierte Dehnung der Drift-Klasse · E-5 CAS =
Folge-Paket · E-6 Abstract Factory (CAS/Bestueckung = zweites Produkt) · E-7 Familien-Klasse
+ Maschinen-Tupel-Zusatzzeile. E-8 bleibt Infra-gated (nur Test-Erwartung).
Ausfuehrung: P1 beauftragt (Impl-CE-6de) am 27.07. ~17:45Z.

## NACHTRAG 2 ~17:50Z — OWNER-ERGAENZUNG: Planer kennt die ISA×OS-KOMPLEX-HAUPTACHSE

Owner (verbatim-nah): "Der Planer muss zumindest die ISA x OS Komplex-Hauptachse KENNEN, um
per Metaprogrammierung eine passende feingranulare Hardware-Erkennung und passende OS-Handles
dafuer mitzugeben bzw. je ISA x OS einzukompilieren (beachte ALLE vorhandenen ISA und
dokumentierten OS)."

BINDENDE KONSEQUENZEN (praezisiert Ebene 1 + P2/P5):
K1. Der PLANER wird erster echter KONSUMENT von TargetIsaComplexAxis + OS-Achse (heute:
    0 Konsumenten ausser asserts/Registry-Gen — Kartierungs-Befund). Seine Laufzeit-Erkennung
    ist bewusst GROB (Owner-Schaerfung 2. Fassung: "grob erkennen"): sie mappt den Host nur
    auf eine ZELLE der CT-Matrix ISA×OS und waehlt darueber per Metaprogrammierung die
    einzukompilierende feingranulare Erkennung + OS-Handles. ARBEITSTEILUNG (Owner verbatim):
    "Die feingranulare Erkennung liegt bei der CEB" — der Planer erhebt selbst KEINE
    Feinwerte (kein SPD, kein Boot-Cache; nur CPUID-Vendor/Familie + CT-OS-Konstante),
    die gesamte Detail-Erhebung (Provenienz-Kette, RAM-Werte) ist CEB-Laufzeit.
K2. Die Factory-WAHL spannt BEIDE Achsen im Typ: Spezialisierung ueber (IsaComplexTyp ×
    OsTyp) — nicht OS-only mit ISA als Methoden-Parameter (loest die Review-Auflage
    "GoF nur halb im Typ" im Owner-Sinn auf).
K3. TOTALITAET ueber den GANZEN deklarierten Raum: kAllTargetIsaComplexIds (alle vorhandenen
    ISA-Komplexe) × kAllOperatingSystemIds (alle dokumentierten OS, Registry linux/windows/
    macos). CT-Totalitaets-Wache: JEDE Zelle hat eine definierte Spezialisierung; nicht
    implementierte Zellen (z.B. macOS) = EHRLICHE declared-only-Spezialisierung mit
    benanntem Nicht-implementiert-Durchfallen — nie eine fehlende Spezialisierung, nie
    stilles Verhalten (Auflage A8 wird damit zur Matrix-Pflicht).
K4. "OS-Handles" = die OS-gebundenen Zugriffs-Bausteine (sysfs-/Datei-Pfade, kuenftig
    WMI-Handle) als CT-Typ-Bausteine der jeweiligen Zelle — der Planer gibt sie via
    Achsen-Zellwahl mit, die CEB erhaelt sie einkompiliert (kein Laufzeit-OS-Switch).
K5. Wachstums-Regel: Neue ISA-Komplexe/OS-Eintraege in den Registries ziehen per
    Totalitaets-Wache SOFORT eine bewusste Zellen-Entscheidung nach (Compile-Bruch statt
    stiller Luecke).
