# 20260726-lane-a-grundlagen-workflow / arch-doktrin (agent aa20afc7)

runId: wf_17636316-4e6
agentId: aa20afc7c9527de49
label-Zuordnung: arch-doktrin (Prompt-Marker-Deckung 29%)

---

ROOT = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/
S-LAY = docs/sessions/20260726-SESSION-layer-modell-antworten-QA-QF-stempel-doktrin.md
S-ACH = docs/sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md
Q3    = docs/sessions/backups/20260726-explore-q3-klammerung/REPORT-hinweis.md
HO6   = docs/sessions/20260726-SESSION-HANDOVER-6-lagerwelle-komplett-abnahmen-struktr.md
LAY00 = docs/sessions/backups/20260726-layer-modell-erhebung-workflow/ergebnisse/00-layer-modell-a728ca2b.md
BAU   = docs/sessions/backups/20260726-strukt-r-planung-workflow/ergebnisse/00-bauplan-a67e501b.md
CE    = Code/external/comdare-cache-engine/

== (a) DIE 10 BINDENDEN ARCHITEKTUR-SAETZE ==

1. Haupt-Achse = CT-statisch, Unter-Achse = RT-dynamisch, STUFEN-RELATIV (dyn. Einstellung der
   Vorstufe = CT-Draht der Folgestufe). LAY00:12-20 (Belege LED:2031/2040), S-ACH:48-52.
   Owner-Haerte 26.07. schlaegt das Doku-"in der Regel" (LAY00:26).
2. KEINE runtime->compile-time-Bruecken; erlaubt sind nur ct->ct und rt->rt Abbildungen, sowie
   mehrere RT-Varianten auf dieselbe CT-Haupt-Achse. LAY00:24 (LED:3404-3409, KERN).
3. ALLE Achsen sind IMMER getrennt zu behandeln und zu KLAMMERN - keine Fusion in Signaturen,
   Schluesseln, Stempeln; je Achse ihr eigenes Feld/ihre eigene Klammer. LAY00:78 (LED:3412-3413).
   Buendelung = Verhalten, Klammerung = Repraesentation (LAY00:76-79 + S-LAY:20-26).
4. DREI-STUFIGE (real 4-Ebenen-) KLAMMER-HIERARCHIE, Typ-Klammern sind die oberste, strikt
   getrennte Struktur: Ebene0 Binary-Klammer, Ebene1 Typ-Klammer, Ebene2 Komplex-Klammer,
   Ebene3 Haupt-Achsen-Klammer. Q3:25-49. NIE typ-uebergreifend klammern: Q3:57-59.
5. Unter->Haupt-Klammerung ist in den BINARIES NICHT PRAESENT, nur META-INFO in den xlsx.
   S-LAY:13-14, Q3:14-19, Q3:54-56 (RT-Unter nie im Binary-Stempel).
6. Binaries (CEB, Tier) haben KEINE eigene Versionsnummer - nur der PLANNER hat eine; Identitaet
   = Haupt-Achsen-Rekombination + Algorithmus-Version je Haupt-Achse. S-LAY:17-19, Q3:47-49.
7. Meta-Meta-Achsen SIND volle CT-Haupt-Achsen mit EIGENEN RT-Unter-Achsen (keine Descriptor-
   Daten); Existenz-Wahl ist compile-time. S-LAY:53, LAY00:58-70 (LED:2730, ARCH20:75).
8. Komplex-Haupt-Achse = generischer REKURSIVER Command-Pattern-Wrapper; Identitaet nur INDIREKT
   ueber die gewrappten Glieder; EIN gemeinsamer Stempel je Komplex-Klammer. S-LAY:20-23, 56-57.
   Rekursions-Tiefe formal unbegrenzt, kein festes 3. Level. S-LAY:40-42.
9. Bindende Ordnungs-Kette (Doku-Verstoss = Regression): (1) MESS-TOOLING -> (2) target_isa ->
   (3) operating_system -> (4) extension_hardware -> (5) ORGAN T00-T16 -> letztes Haupt-Blatt ->
   3 Unter-Ebenen Mess-Unter -> System-Unter -> Organ-Unter. S-ACH:11-14.
10. Identitaet ist NUR AUFWAERTS kompatibel (Basis = CPU-only; alle Teil-Identitaeten mit
    kleinerer Hardware-Verwendung gueltig); ALLE Hardware-Erweiterungen (SIMD/GPU/FPGA/NPU)
    in DERSELBEN Haupt-Achse; extension_hardware = offizieller Command-Pattern-HUB, seine
    Identitaet IST exakt die Konfiguration seiner Meta-Metas. S-ACH:35-46, LAY00:72-74.

== (b) LANE-A-BEAUFTRAGUNGS-PAKET (SYS-TAX, R-A..R-D) ==

WORTGENAU EINZUHALTENDE DOKTRIN-PUNKTE (Implementierer darf hiervon nicht abweichen):

D-1 Klammer-Hierarchie (Q3:29-49), 1:1 in Stempel-Renderer und Suffix-Segmente:
    Ebene0 BINARY: aeussere Klammer ueber die Typ-Klammern, komma-getrennt, NIE verschmolzen.
           Tier = [[d,e,f],[g,h,i]] · CEB = [[a,b,c]] · Mess-CSV = [[a,b,c],[d,e,f],[g,h,i]]
    Ebene1 TYP: je Achsen-Typ eigene Klammer; System [d,e,f] und Organ [g,h,i] bleiben im
           Tier-Stempel ZWEI separate Zeilen/Arrays, nur von Ebene0 umschlossen.
    Ebene2 KOMPLEX: nur INNERHALB einer Typ-Klammer, rekursiv, EIN gemeinsamer Stempel-Block:
           [d,e,f] = [ complex[ [target_isa@X.Y.Z] [os@X.Y.Z]
                                [external_utils[ [avx512@X.Y.Z] [gpu@X.Y.Z] ... ]] ] ]
    Ebene3 HAUPT: je Haupt-Achse eigene Klammer + gewaehlter Algorithmus + eindeutige X.Y.Z.
D-2 Stempel-Doktrin (S-LAY:15-19, 60-62; Q3:51-56):
    - Gliederung je ACHSEN-TYP -> je HAUPT-Achse -> ein Algorithmus + EINDEUTIGE Version.
    - Stempel-Inhalt stufen-relativ: NUR die in DIESER Binary CT-einkompilierten Haupt-Achsen.
    - RT-Unter-Achsen (scheduling, 4 OS-Werte, opt_level/atomic128 auf RT-Stufe) NIE im Stempel.
    - Voll-Klammer Xa[Unter-k,...] NUR im Mess-CSV/xlsx (Name + Spalten + Info-Sheet).
    - KEINE Gesamt-Version fuer CEB/Tier. Komplex-Achse: EIN Stempel, Glieder behalten Klammer.
D-3 Layer-Modell-Korrekturen, die den Bauplan-Stand ueberschreiben:
    D1 (LAY00:121-122): OS NICHT flach bauen. BAU:100 ("NEU operating_system_system_axis.hpp
       + 4 Unter-Achsen") ist als FLACHE Achse REGRESSIV -> OS ist Komplex-Glied (S-LAY:28-33).
    D3 (LAY00:127-128): `std::span<MetaMetaDescriptor const> meta_metas()` (BAU:54/:163,
       SYSWELT:191) ist VERBOTEN - Meta-Metas sind volle Haupt-Achsen-TYPEN mit eigenen
       RT-Unter-Achsen und eigenem Stempel, keine Daten-Descriptoren. S-LAY:53.
    D4 (LAY00:130-131): CebSubAxis DARF NICHT `static_assert(CebSystemAxisConcept<ParentAxis>)`
       tragen (BAU:99) und AxisKind darf NICHT genau einen Wert `system_meta_meta` als festes
       3. Level bekommen -> offene Tiefe, EIN Concept fuer alle Achsen, Unter-Achse = Voll-Achse.
       S-LAY:54-55.
    D5 (LAY00:133-134): KEIN hartkodiertes Sammel-Label "build_target_complex" (SYSWELT:190) ->
       generischer rekursiver Huellen-Mechanismus; Label-Fusion kollidiert mit LED:3412. S-LAY:56.
D-4 external_utils-Rename (S-LAY:28-33, 58): ext_hw/extension_hardware -> `external_utils` =
    Plug + MANAGER der Meta-Meta-Achsen (generalisierter Command-Pattern-Hub). Mitglieder:
    externe Hardware, AVX/SIMD (R-F: Meta-Metas, HO6:43), UND das MESS-FRAMEWORK (stets ERSTER
    Einbaukandidat). OS = 4. Glied der EINEN Komplex-Achse: target_isa x os x external_utils x
    MetaMetas (Variante i). Ist-Scope des Renames: 26 Dateien unter CE (grep
    extension_hardware|ExtensionHardware|ext_hw), inkl. system_axis_registry.xml:53-55 (dort
    auch die DEPRECATED-Insel-Ausschluss-Notiz :8 - NICHT anfassen).
D-5 kSystemAxisOrder (BAU:A-II): NEU `CE libs/cache_engine/include/cache_engine/abi/
    system_axis_order.hpp` mit `constexpr kSystemAxisOrder` = Kette aus S-ACH:11-14; darauf
    umstellen: `abi/system_axis_code_versions.hpp:27-38` (heute kSystemAxisCodeCount=5 und die
    Liste compiler/extension_hardware/target_isa/scheduling/load_framework - genau die 5, von
    denen R-B compiler+scheduling degradiert und R-C load_framework zur Meta-Meta macht) sowie
    `anatomy_version_stamp.hpp:64-79 system_stamp_line()`; Generator
    `tools/system_axis_registry_gen/main.cpp` 5 Handbloecke (:164,215,244,258,284) -> Iteration.
D-6 Weitere bindende Lane-A-Details aus BAU:96-118: R-B scheduling -> Sub-Achse unter
    target_isa; R-D compiler verliert Haupt-Status, SubAxisGroup<compiler,opt_level,atomic128>
    untrennbar, die 4 parent-static_asserts (validate_profile.hpp:421-422,971-972,
    compiler_atomic_sub_axis.hpp:98, optimization_level_sub_axis.hpp:145) UMHAENGEN statt
    streichen (sonst GN-1-Verwaisung); R-C load_framework -> Meta-Meta, aber
    `sub_axis_label()=="workload"` (load_framework_system_axis.hpp:29) UNANGETASTET;
    A-V Resolver `resolve_axis_refs_against_trio:748-799` muss Unter-Achsen-Namen mitaufloesen,
    sonst harte Rejects; MUSS gruen bleiben: test_br1_full22_count.cpp:60-65, und
    operating_system gehoert NICHT in registry_to_axis_levels.hpp:113-122.
D-7 Bewusst gebrochene + im SELBEN Commit neu zu ankernde Wachen (BAU:120-128):
    test_system_axis_registry_roundtrip (Byte-Diff==0, XML mitregenerieren),
    test_m_w12_stamp_bausteine.cpp:105-109,261,267-269,338 (literale Stempelzeile,
    ";load_framework=code@1.0.0"), system_axis_count()==5u in test_validate_profile.cpp:289 +
    test_experiment_plan_director.cpp:112-113,308, test_striktheit_axis_dach_guard.cpp (alle
    parent-Strings; DEPRECATED-Insel :87-88 NICHT anfassen).
D-8 Randbedingungen: CUSTOM_COMPILE ist CLI-FEATURE, KEIN 5. Modus (HO6:40-41 - S-ACH:22-26
    ist an dieser Stelle ueberholt); COMPARE = 4. Registry-Eintrag; Spalten-Sparregel
    (S-LAY:37-38) gehoert in den Writer, nicht in Lane A; persistence_target = Lane B/ORG-18;
    Lane A ist byte-relevant fuer jede Tier-Binary nur gemeinsam mit dem B-ABI-Bruch (BAU:126).
    Reihenfolge: Lane A vor Lane F (W-13/Suffix), F seriell nach A und G4b-1 (HO6:64-66).

== (c) VOR LANE-A-START ZU KLAERENDE LUECKEN ==

L1 OS-Einbau-Widerspruch: HO6:36-38 sagt "OS = KOMPLEX-HAUPT-ACHSE (CT), seine 4 Werte = RT-
   Unter-Achsen"; S-LAY:28-33 (Q-B) sagt "OS = 4. GLIED der EINEN Komplex-Achse". Ist OS
   Glied oder selbst Komplex-Huelle? Entscheidet Typ-Signatur + Stempel-Zeile. Owner-Bestaetigung.
L2 OS-Unter-Achsen CT/RT: S-LAY:34-36 "ERSTMAL STATISCH (deklarativ)" vs HO6:37 "4 Werte = RT-
   Unter-Achsen" vs LAY00:171 (Q-C: gemessene Host-Fakten, nicht setzbar) vs Verbot der
   runtime->CT-Bruecke (Punkt 2). Statisch-deklariert + CT = genau die verbotene Bruecke.
   Klaerung: RT-Provenienz-Spalten (nur CSV/Metadaten) - ja/nein.
L3 external_utils vs Ordnungs-Kette: S-ACH:11-14 (bindend!) nennt Position (4)
   `extension_hardware`; S-LAY:31 benennt sie zu `external_utils` um. Wird der Ordnungs-Name
   (und damit kSystemAxisOrder, XML-id, Suffix-Segment +ext) mit umbenannt? Migrations-Alias
   fuer Alt-Profile/Alt-CSV? Betrifft 26 Dateien + generierte XML.
L4 load_framework vs Mess-Framework: R-C (S-ACH:22-26) "load_framework stets die ERSTE
   Meta-Meta-Achse"; Q-B (S-LAY:31-32) "MESS-FRAMEWORK stets ERSTER Einbaukandidat". Zwei
   verschiedene erste Meta-Metas oder dieselbe Achse? Reihenfolge im variadischen Array ist
   stempel-byte-relevant.
L5 Neue Zahl + neue literale Stempel-Zeile: kSystemAxisCodeCount (heute 5) und
   system_axis_count()==5u muessen auf einen ENTSCHIEDENEN Wert gehen. Enthaelt die flache
   Stempelzeile die Komplex-Klammer (dann kein einfaches Semikolon-Format mehr) oder nur die
   Glieder? Wer traegt die Version des Komplex-Blocks (S-LAY:22 "EIN gemeinsamer Stempel")?
   Ohne Entscheid kann A-II/A-VI nicht byte-genau geankert werden.
L6 Generisches Komplex-Label (D5): XML `parent="..."` und Registry-ids brauchen einen String.
   Welche generische Benennungs-Regel (z.B. abgeleitet aus den Gliedern) ersetzt
   "build_target_complex"? Betrifft die byte-gewachte generierte Registry-XML.
L7 Vokabular fuer offene Tiefe (D4/D11): AxisKind hat heute nur organ/system_measurement/
   system_config, XML kennt nur stage="ct"|"runtime". Welches Vokabular traegt beliebig tiefe
   Rekursion (Meta-Meta-Meta, S-LAY:40-42) ohne festes Level? Muss VOR A-I.1 fixiert sein.
L8 Scope-Schnitt A-IV: BAU:107 markiert Parser/PODs/XSD als DEFERRABLE (BAU §6). Entscheid, ob
   Lane A mit oder ohne A-IV beauftragt wird (ohne A-IV bleiben Alt-Profile mit
   scheduling/compiler-Refs ein Risiko, s. A-V).
L9 Persistenz-Riss (LAY00:157-158): es gibt KEINEN Ledger-Paragraphen fuer den 26.07.; §67
   "LAYER-MODELL DER HAUPT-ACHSEN" fehlt. Vor Lane A anlegen, sonst ist die Lane-A-Grundlage
   nur in Session-Docs/Memories - Kompaktierungs-Risiko.
L10 Vorbedingung aus HO6:54-56: Lane A soll erst NACH Erhebungen + Owner-Sicht starten; Lane C
   (IDENT) inert/byte-neutral parallel. Freigabe-Status der Owner-Sicht ist im Handover nicht
   als erteilt vermerkt - vor Beauftragung pruefen.

SELBSTCHECK: read-only, keine Datei geschrieben. Alle 4 Zieldokumente vollstaendig gelesen
(62/118/59/95 Zeilen) plus LAY00 (D1-D13) und BAU:90-140 als Lane-A-Detailquelle; Ist-Code
system_axis_code_versions.hpp und ext_hw-Fundstellen live geprueft. ASCII-only.
