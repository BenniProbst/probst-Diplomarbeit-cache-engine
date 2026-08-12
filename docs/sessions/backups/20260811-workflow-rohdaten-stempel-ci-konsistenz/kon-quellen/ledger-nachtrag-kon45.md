## NACHTRAG 12.08.2026 — KON45: DREI EXPLORES GELANDET — DER HYBRID-STEMPEL TRÄGT (EIN BUDGET-BRUCH), FESTPLATTEN-IO = TYP + COMP-GATE, E-WARMUP IST VORLAGEREIF

**Protokoll: beauftragt als KON43 — KON43/KON44 sind im lebenden Ledger inzwischen vergeben,
der Nachtrag trägt KON45. HEILUNG: der erste E-WARMUP-Agent starb am Kontext-Überlauf;
Neustart ZWEIGETEILT (Schnitt 1 = Roh-Transkripte, Schnitt 2 = Code+Docs-IST) mit
Kontext-Disziplin, alle Teile Fable 5 max (KON38). Alles Explore statt Owner-Frage (KON41-05).**

### KON45-01 — HYBRID-STEMPEL-PRÜFUNG (KON41-04 „dennoch prüfen"): TRÄGT — MIT BUDGET-BRUCH UND ZWEI DESIGN-ENTSCHEIDEN

    (1) Das Owner-Modell "letzte Zeile = SHA ueber die Zeilen darueber" ist heute strikt
        KLEINER als das Preimage: kFP rechnet consteval ueber die 9-GLIED-FOLGE [0]format
        [1]organ [2]system [3]mess [4]valueset [5]toolchain [6]bvset [7]overlay [8]messgates
        (anatomy_module_abi_v1.hpp:171-176 · anatomy_fingerprint.hpp:435-446); Glieder 0+4-8
        stehen NICHT im POD. Ein "Genus-Glied" EXISTIERT NICHT (Genus = Lager-Wurzelebene).
    (2) EINHAENGUNG, Empfehlung (a): 10. GLIED fuer ALLE Binaries (Tier traegt ""), Format-
        Bump 4->5, GliedCount 9->10 — bricht KONTROLLIERT (Wache anatomy_fingerprint.hpp:641),
        BinaryKeyPolicy zieht ueber die Konstante mit (bestandslog_factory.hpp:84-88; ":87
        'acht'" ist Text-stale). VERWORFEN (b) hybrid-eigene Folge = zweite Ordnungs-Quelle.
    (3) POD: "vorletzte Zeile" ist Render-Semantik; physisch komposit_line/len APPEND-ONLY
        ans POD-Ende (Praezedenz measurement_line W12-A3), Layout 6->7 (Gleichheits-Wache
        anatomy_module_abi_v1_decl.hpp:273-275, CT-Negativ-Probe :293-294) — mit dem bereits
        geplanten WE-Layout-Bump in EINEN Bump falten (KON5-04: ein Bruch statt zwei).
    (4) SPANNUNG KON7-04 AUFGELOEST: CT-Komposit-Zeile = BAU-ZEIT-Belegung (Identitaet/
        Lager/Skip, KON9-03) · angeschlossene() = RT-IST der Einrichtung (KON21-01);
        Invariante RT-Menge ⊆ CT-Map; KON9-02-Anteile 2+3 bleiben REINE Laufzeitanfrage,
        NIE eingebrannt — CT/RT wie CEB (KON8-03); KON7-05-Terminierung bleibt Soll.
    (5) 🔴 BUDGET-BRUCH: 32 belegte Docks x (Key+128hex+Trenner) ≈ >4,5 KB sprengen ALLEIN
        kAnatomyFingerprintPreimageMax=4096 (anatomy_fingerprint.hpp:68, Wache :478) =>
        Puffer+Budget-Konstanten heben, Pflicht-Edit MIT Budget-Beleg. Map-VALUE deshalb
        Tier-sha512_line (128-hex), NICHT Voll-Stempel (32x~2KB≈64KB > 50KB-Budget; der
        Tier-SHA deckt per F7 alle Tier-Zeilen allein).
    (6) KEYS EXISTIEREN NICHT: synthese_matrix.hpp traegt nur Zell-ADRESSEN (stufen_id
        :120-127; Inhalte = HY-A2 + Auflage K5); strategie_name()-Literale ("Reroute<View>",
        heuristik_adapter_strategy.hpp:62-64,218) verletzen den Glied-Zeichenvorrat
        (anatomy_fingerprint.hpp:185-189) => eigene Key-Grammatik, bis HY-A2 adressbasiert.
    (7) LAGER: KEINE Kollision — der Writer nimmt den fertigen 128-hex entgegen, rechnet
        nichts nach (lager_baum_writer.hpp:50-55); Hybrid seit K1 regulaer (:57-62).

    BAU (HY-A/S-5/B5): Zeile entsteht am Hybrid-Stempel-Makro-Expansionsort (Analogon _M);
    die Map INJIZIERT die CEB-Bau-Naht je Hybrid-Bau (Muster COMDARE_SYSTEM_CELL_VALUES;
    Tier vor Hybrid sequentiell, KON9-03); Traeger = benannter Typ KompositMapGlied
    (K-1-Muster), Konkatenation Dock-Index AUFSTEIGEND. BRAUCHT: HY-A2-Keys (B3/B4) ·
    Format+Layout-Bump GEBUENDELT VOR F2/26.08. (Sidecar-Bestand 0, "nie eine Flotte
    gebaut" = heute kostenlos) · Budget-Anhebung. S-5: die Komposit-Zeile IST der
    Composite-Fall der Stempel-Strecke (Erbin verschaerft). B5: Stufen-Schalter weiter
    durch die EINE Aufloesung ins Mess-Glied [3]; Komposit-Zeile GETRENNT (eigenes Glied).
    VORLAGE (1 Satz, bei ##51): Map-VALUE als Tier-SHA-Zeile statt woertlich "Stempel
    values" — F7 deckt es, das Preimage-Budget erzwingt es; Empfehlung JA.

### KON45-02 — FESTPLATTEN-IO (OF-4 als Bestands-Explore): ADDITIVER TYP JA — DIE COMP-GATE-SCHICHT FEHLT IN ALLEN DREI REALMS

    VERDIKT: additiver OrganMetaMetaAxis-Typ NOETIG — und er allein loest "je Tier-Binary
    = je Gattung+Genus" NICHT: es fehlt eine Comp-bewusste GATE-SCHICHT, die in KEINEM
    der drei Meta-Meta-Realms existiert (auch SIMD nicht).
    (1) BESTAND OHNE NEUEN TYP: NEIN. simd_organ_requirement.hpp:31-50 ist KEINE Achse
        (Name->Flags-Tabelle, beruehrt OrganMetaMetas nie); meta_meta_admission.hpp:48-49
        haertet auf is_system_meta_meta_axis (hardware_meta_meta_axis.hpp:102f);
        admit_organ_on_machine NUR aus Tests gerufen (3 Zeilen) — KEIN Produktionspfad.
    (2) 🔴 ES FEHLT SELEKTION JE COMP, nicht Inhalt: organ_stamp_line<Comp>() ruft den
        Meta-Meta-Suffix OHNE Comp (anatomy_version_stamp.hpp:196) — ein Disk-Typ
        stempelte JEDE Binary, auch MemoryOnly. Der Code nennt die Luecke selbst:
        active_organ_required() global/leer (simd_build_gate.hpp:263), Tripwire :272-278
        verlangt Owner-Paket-Entscheid VOR der ersten required-Deklaration.
    (3) 26.07./T17 UNANGETASTET: Hauptachse MemoryOnly/DiskWriteback bleibt Slot 18/18
        (anatomy_version_stamp.hpp:168; EnabledTargets 1-elementig, axis_persistence_
        target_registry.hpp:31-33, Q-1/Fall B); has_device_writeback_path()==false
        UNBEDINGT (axis_persistence_target_disk_writeback.hpp:67,102-104) => die
        Meta-Meta traegt heute PROVENIENZ/Stempel, keine echte Admission.
    BAU: Schnitt KLEIN = 1 Datei ~15-40 Z. (Vorbild external_utils_family_axis.hpp:96-106)
    + 1 Zeile abi::OrganMetaMetas (anatomy_version_stamp.hpp:51); ADDITIV, T12/T17 bleiben
    (Additiv-Doktrin, deckt KON26-01). NICHT klein: Comp-Gate = EIGENER Bauauftrag.
    VORLAGE (1 Satz, Bestaetigung vor Bau): neuer Organ-Meta-Meta-Typ zunaechst NUR mit
    Provenienz-/Stempel-Semantik (Admission gegenstandslos ohne Geraete-Pfad), Comp-Gate
    als eigener Posten — Empfehlung JA.

### KON45-03 — E-WARMUP (KON37-06 #27, BEIDE SCHNITTE VEREINT): OP-EBENE FESTGELEGT UND GEBAUT — OFFEN IST NUR DER ZELL-WARMUP

    OWNER-WORTE (Schnitt 1; Korpora A=46375cdc/B=5a19728e, alle Funde origin.kind=human):
      · ZWEI PHASEN JE OPERATION, KEIN Gesamt-Warmup-Lauf: ausfuehren (aufwaermen) ->
        zurueckrollen -> warm wiederholen; je Messblock 3 Wiederholungen, XML-konfigurierbar
        (A:44304, 16.07., "ich wiederhole mich"; aelteste Aussage A:42762; Korpus beginnt
        erst 06.07. — Wochen 1-4,5 der "10 Wochen" fehlen darin).
      · STABILITAETS-GATE: >5% innerhalb der 3 Warm-Wiederholungen => Gesamtlauf-Neustart
        (fremder Verbraucher), bis 5 Versuche (B:20048) · Replay MIT warmem Cache (B:17389)
        · Retry ≠ Mess-Wiederholung, Fallback 5/2/1 (B:43879 · B:34035) · 3 Erfolgswerte
        ALLE EINZELN persistiert (B:45371 = KON37-06-Ausloeser).
      · "ERSTE ITERATION VERWERFEN" EXISTIERT NICHT als Regel (0 Treffer; 1872 human-
        Zeilen gegen 20+ Anker inkl. Encoding-Fallen) — das Verwerfen IST die Warmup-Phase.
    CODE+DOCS-IST (Schnitt 2): Op-Warmup PFLICHT-dokumentiert (20260719-ci-kette-start-zu-
    gruen-DETAIL.md:158-161 u.a.) und GEBAUT: two_phase_measure save -> Warmup (verworfen)
    -> rollback -> Messung (tier_observe_trace_abi.hpp:100-141; ohne exakten Rollback
    two_phase_valid=false, perm_runner.hpp:142-143) · Segment-Warmup-Batches verworfen
    (abi_adapter.hpp:706,1107,2025) · KF-10 fuehrt GENAU reps=3, ALLE persistiert
    (repetition_plan.hpp:28,35-41) · Drift-Gate 3er-Gruppe/max_reruns=5, behaelt LETZTE
    Probe (drift_gated_cell.hpp:42-47,100,120; produktiv cache_engine_builder_iterator
    .hpp:2948) · Legacy run_observable_perm misst KALT (perm_runner.hpp:207,213).
    🔴 LUECKE: der PROZESS-KALTE ERSTLAUF je (Binary x Zelle) landet ungeschuetzt in
    Wiederholung 0 — Beleg ~2x teurer (checkpoint_measure_soll_design.md:198-200;
    Gegenbefund Op-Ebene 18.06. vor Drift-Gate: kein Leak, AUSWERTUNG…cowfix-v1.md
    :100-101); kalter Erstwert treibt die Gruppen-Drift ueber 5% => Fehl-Reruns (bis 5).
    EINORDNUNG: ein VORGESCHALTETER, NICHT persistierter Zell-Warmup beruehrt die 3-einzeln-
    Doktrin NICHT (KF-10 regelt Persistenz, nicht Konditionierung); VERBOTEN waere nur
    "verwirf Wiederholung 0 der 3". Memory ice_cold_cache = CI-BUILD-Cache, NICHT Messung.
    VORLAGE (1 Satz): Soll vor der ERSTEN persistierten Probe je (Binary x Setting)-Zelle
    EIN kompletter, NICHT persistierter Warmup-Durchlauf laufen — Empfehlung JA (Code
    waermt nur je Op/Batch, Erstlauf ~2x teurer, senkt Drift-Fehl-Reruns, die 3 KF-10-
    Werte bleiben einzeln persistiert).
**Vollzug:** #27 = Explore FERTIG, Vorlage steht · die DREI Ein-Satz-Vorlagen gebuendelt in
die Fragen-Runde nach WF10 (KON44-Fahrplan) · Glied-(a) und Key-Grammatik = Design-Entscheide
im HY-A-Design (KON41-05, kein Owner noetig) · Rohdaten der drei Explores im Backup.
