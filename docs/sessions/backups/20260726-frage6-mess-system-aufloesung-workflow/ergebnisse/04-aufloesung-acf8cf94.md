# 20260726-frage6-mess-system-aufloesung-workflow / aufloesung (agent acf8cf94)

runId: wf_3ed15f5c-7d7
agentId: acf8cf94bd01fa4cc
label-Zuordnung: aufloesung (Prompt-Marker-Deckung 0%)

---

(1) DAS AUFGELOESTE REGELWERK -- ZWEI EBENEN, KEIN WIDERSPRUCH

R1. Es gibt genau ZWEI unabhaengige Ebenen: (a) ORDNUNGS-/BENENNUNGS-Ebene = Rang eines Achsen-TYPS in
    Verzeichnisbaum, Legende, Datei-/Job-Name; (b) STEUER-/VERANTWORTUNGS-Ebene = welche Stufe (Planer /
    CEB / Tier) eine Achse besitzt, kompiliert und keyt. Beleg: LED:2186 (Sec.30) "EIN Baum mit
    AxisKind-gefaerbten Ebenen + Filter-/Zerlege-Operation je Achsen-Art"; O3 "Formal sind die Mess-Achsen
    auch System-Achsen, werden aber getrennt gehandelt."
R2. Die Owner-Sortierung O15 (Mess-Tooling an Position 1) ist AUSSCHLIESSLICH Ebene (a): sie sagt selbst
    "erste Ebene der Haupt-Achsen an der Wurzel des VERZEICHNISBAUMES", "bindend fuer die ANORDNUNG UND
    STRUKTURIERUNG", "verstoesse ... gelten IN DOKUMENTATION als Regressionen". Kein Wort ueber Besitz.
R3. BEWEIS, dass Position 1 keine Steuer-Hierarchie sein KANN: O16 stellt denselben Typ zweimal
    verschieden ein -- Messdaten-Baum: Mess an der Wurzel; Binaries-Lager: "System-Achse als Wurzel ...
    Mess-Achse ... als LETZTER UND TIEFSTER Haupt-Achsen-Typ". Eine Eigentums-Hierarchie kann nicht
    baumabhaengig kippen; eine Lager-Ordnung darf es. Damit ist die Frage owner-seitig entschieden.
R4. F6/O20 ist AUSSCHLIESSLICH Ebene (b) und ist keine Neuerung, sondern O6/LED:2179 (Sec.30) verbatim:
    Planer = Mess-Achsen, CEB = System-Achsen, Tier = Organ-Achsen; LED:2183 "Mess-Registry->Planer .
    System-Registry->CEB . Organ-Registry(+prt)->Tier". "alles andere ist veraltet" trifft O2/nr703
    (System steuert Mess) -> E-05/W4 sind GESCHLOSSEN, nicht offen.
R5. Praezise Formel je Stufe (LED:3063, Sec.59-D): "Jede Stufe stempelt aus derselben Anatomy-Vorlage ihren
    STUFEN-EIGENEN Achsen-Satz". Folge: jede Stufen-Liste enthaelt genau ihren Typ-Satz und NICHTS Fremdes;
    die Ordnungs-Ebene darf umsortieren, nie fusionieren (LED:3412, Sec.66-N3: je Achse eigene Klammer).
R6. SCHEDULING haengt in F6 auf der SYSTEM-Seite (Realm), aber nach O15 nur noch als UNTER-Achse von
    target_isa ("weil die CPU alle Daten auf einer Maschine managed"). Beide Saetze sind vereinbar: F6
    nennt den REALM (CEB, nicht Planer -- LED:1663 "Scheduling = SYSTEM-Achse, unter der die CEB gebaut
    wird"), O15 den RANG. Rang-Degradierung Haupt->Unter ist ledger-konform (LED:2266 Sec.37.4).
R7. Konsequenz der Rang-Regel: Unter-Achsen erscheinen NIE in Stempel, Binary-Name oder Verzeichnis-Rang
    (LED:2347 Sec.42.b; LED:3021 Sec.58-V "Nur HAUPT-Achsen im Stempel"; O19-QA "fuer die Unter-Achsen
    nicht praesent, sondern nur als Meta-Info in den xlsx"). scheduling verlaesst damit die Stempel-Liste,
    ohne den System-Realm zu verlassen. scheduling_dims (heute stage="ct") wird Dim-Satz DIESER Unter-Achse
    -- erlaubt, da CT-unter-CT; verboten waere nur eine runtime->CT-Bruecke (LED:3409).
R8. MESS wirkt bis ins Tier, ist dort aber keine Achse: LED:3293-3295 / O13 (CEB richtet die Mess-
    Einrichtung des Prueflings "nach der Planer Mess-Achse" aus) -- durchgereichter statischer Draht.
    Deshalb ordnungs-relevant (aeussere Klammer) und steuer-fremd (nicht im Tier-Stempel, LED:3009/3010).
R9. Die drei Replay-/Lager-SCHLUESSEL bleiben disjunkt und begrenzen jede Kaskade: [a,b,c] -> CEB-Binary;
    [d,e,f] ALLEIN -> Tier-Binary; [d,e,f]+[g,h,i]+Maschinen-HW -> Messwert (LED:3243-3245, LED:3312, O12).
R10. Batch-Grammatik ist die kanonische Umsetzung beider Ebenen zugleich: Mess-Klammer EINMAL im Batch-/
    CEB-KOPF (Wurzel/Position 1), pro Schritt nur zelle=[d,e,f][g,h,i] (Steuerung) -- LED:3308-3310;
    im Code identisch kommentiert in plan_legend.hpp:141-144.

(2) kSystemAxisOrder -- EXAKTE SPEZIFIKATION FUER LANE A

Semantik: kSystemAxisOrder ist die EINE kanonische Ordnung der System-HAUPT-Achsen (Ebene a) fuer alles,
was System-seitig ordnet: system_stamp_line, Suffix-Emitter, Registry-Kopf, Binaries-Lager-Kaskade.
Es ist KEINE Achsen-Menge des Planers und keine Gesamt-Achsen-Liste.

Inhalt und Reihenfolge (5 Eintraege, O15-Sequenz zuerst, danach die von O15 nicht umsortierten
Bau-Treiber in bestehender Registry-Ordnung -- keine erfundene Sortierung):
  0 target_isa         (Unter: isa-Bausteine; NEU scheduling -> traegt scheduling_dims, 5 sub_dim)
  1 operating_system   (NEU, R-A-Regression O15; Unter: os_version, kernel, build, update_state)
  2 external_utils     (Umbenennung von extension_hardware, O19-QB; Hub der Meta-Meta-Achsen:
                        Mess-FRAMEWORK als erster Einbaukandidat, externe HW, AVX; Unter: simd)
  3 compiler           (Unter: opt_level, atomic128)
  4 load_framework     (Unter: workload; CT-Haupt auf der CEB, runtime-Unter auf dem Planer -- O16)
kSystemAxisCodeCount bleibt 5 (scheduling raus, operating_system rein). Ist-Code
libs/cache_engine/include/cache_engine/abi/system_axis_code_versions.hpp:33-37 fuehrt heute
compiler/extension_hardware/target_isa/scheduling/load_framework -> Reihenfolge UND Inhalt sind gegen
O15/O19 regressiv und in Lane A zu ersetzen; system_axis_registry.xml (Datei-Reihenfolge 10/53/98/102/114)
identisch nachzuziehen. Stempel-/ABI-Bruch ist zulaessig (Alt-golden darf brechen).

NICHT hinein (harte Ausschlussliste):
  - measurement_tooling, measurement_category, collector, telemetry -> Planer-Satz (LED:2183, O18, O19-QB;
    Mess-Version lebt separat in measurement/measurement_tooling_registry.hpp:27-48).
  - alle Organ-Achsen (17 + persistence_target) -> Tier-Satz.
  - ALLE Unter-Achsen, insbesondere scheduling, opt_level, simd, atomic128, workload, os_version/kernel.
  - Maschinen-/Host-Identitaet (lane=<host>) -> nur im Messwert-Schluessel, nie System-Achse.
  - die Deprecated-Inseln extension_hardware_system_axis.hpp und hardware_isa_system_axis.hpp
    (system_axis_registry.xml:8-9 "treibt NICHT den Bau").
Gate-Pflicht: ein compile-time static_assert, dass Suffix-Emitter-Reihenfolge == kSystemAxisOrder ==
XML-Kopf-Reihenfolge (heute nur "5 Eintraege nicht leer", system_axis_code_versions.hpp:49-50 -> Drift).

(3) FOLGE FUER W-13 / LANE-F-SUFFIX UND DIE LAGER-BAUM-KASKADEN

W-13 Suffix (eine einzige autoritative Ordnung, Ebene a, ebenen-rein, keine Fusion):
  Skelett = kSystemAxisOrder; jede Unter-Achse reiht DIREKT hinter ihrer Haupt-Achse (Draht-Folge):
  +target=[+sched=] +os= +ext=[+simd=] +cxx=[+opt=] +lf=[+wl=]  dann  +ceb=<maj>.<min>  dann +bt=
  Bedingte Emission bleibt (target nur != x86_64, tel-Gate, siehe profile_run_facade.cpp:371-407).
  Die heute konkurrierenden Ordnungen (system_axes_version_suffix "+ext+cxx+opt" vs. perm-loop
  profile_run_entry.hpp:780-781 "+cxx+opt+ext", Kommentar :1080-1083) sind in Lane F auf DIESE eine
  Ordnung zu vereinen; die perm-loop bleibt der Koerper, system_axes_version_suffix delegiert.
  MESS im Binary-Key bleibt am ENDE: ArtifactCache::cache_key_prefix (artifact_cache.hpp:245-248)
  "...+ceb=...+mtool=<combo>+mrg=none" ist O16-KONFORM und darf NICHT auf Position 1 gezogen werden.
  Stempel-Zeilen bleiben vier getrennte (anatomy_version_stamp.hpp): Tier = System-Array dann Organ-Array
  dann Merge (LED:3021/3059), CEB = Mess-Zeile allein (LED:2359), niemals verschmolzen.
Lager-Kaskaden, ZWEI Realm-Wurzeln (LED:3331):
  Realm B Binaries (ccache/minio): System(kSystemAxisOrder) -> Organ -> MESS als letzte, tiefste Ebene
    (O16 wortlich). CEB-Binaries haengen in den BLAETTERN der System-Knoten am Uebergang zu Organ (O17).
  Realm C Messdaten (PR4100 Cluster_NFS): MESS-Tooling-Haupt an der Wurzel (Position 1) -> System
    (kSystemAxisOrder) -> Organ; Blatt = xlsx (Default, Info-Sheet) + CSV-Fallback. measurement_category
    und alle Unter-Achsen stehen NUR im Dateinamen/Info-Sheet, nie als Ordner-Ebene (LED:3022: die
    Benennung ist der einzige voll-permutative Ort).
  Ebenen sind typ-rein zu bilden (LED:2721 Sec.54-T4); Schluessel bleiben getrennt (R9).
  Bestandslog: genus-Split binary|measurement bleibt; combo bleibt EIGENES Attribut vor opt/simd
    (bestandslog_document.hpp:36-37/313-316) -- Attribut-Reihenfolge ist Grammatik, KEIN Verzeichnis-Rang,
    daher kein Konflikt mit "Mess tief" in Realm B.
Doku-Nachtrag: 20260726-SESSION-wahrheits-anker-voll-abgleich-982-E01-E26.md:34-36 (E-05) und :135-136 (W4)
  auf "durch F6 (26.07. 16:16) aufgeloest" setzen.

(4) KEINE RESTFRAGE.

Selbstcheck: ASCII-only geprueft (kein Nicht-ASCII, keine Umlaute, kein Paragraph-Zeichen); 96 Zeilen;
Code-Fakten literal verifiziert via sed/grep (system_axis_code_versions.hpp:28-50,
system_axis_registry.xml:10-116, grep kSystemAxisOrder/external_utils = 0 Treffer).
