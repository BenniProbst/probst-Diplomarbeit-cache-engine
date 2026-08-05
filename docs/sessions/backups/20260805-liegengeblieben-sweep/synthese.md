# SYNTHESE Liegengebliebenen-Sweep (dedupliziert, kategorisiert) — 05.08.2026 abends

Basis: ledger.md + docs.md + betrieb.md (alle drei vollstaendig gelesen), gegen IST-ANKER
(ce=60c7c56a, super=603f15f4, Welle wf_1a78cffa + Audit wf_e0b496e0 laufend).
Kategorien: A=echt liegengeblieben (Dringlichkeit in Klammern), B=Teilmenge von A mit
Trigger-/Mess-Blockade, C=geparkt mit Beleg, D=unverbucht erledigt. STRITTIG = ehrlich markiert.

---

## B. VOR-TRIGGER-PFLICHT (Teilmenge von A; blockiert Do-07.08.-Trigger oder Messung)

B1. **E-18 LaTeX-Anhang-VORWAERTS-Kanal je CI** — benanntes Bau-Paket VOR Voll-Bau-4-Trigger,
    "HAUPT-ZIEL des Gesamt-Systems"; nie gebaut, fehlt im IST-Anker komplett. Groesster Einzelposten.
    [LEDGER:3554 (§68c), :105]
B2. **E-04-Vollausbau/A7-Rest** (Z-05/Z-06/Z-08 + Mess-Phase-Marker-v2 E-04-P2/P4; Owner-R9 "vor
    Trigger") ohne Welle/Heimat; nur CLI-/ETA-Teil auf Phase 5/6 gelegt. STRITTIG-Zusatz: rescue/
    w2b-E04-P1 (daf5190e) traegt 2 ECHTE ungelandete Patches (92ad8357 Emissions-Seite Slice-Kanal +
    63406ce3 Director-Test-Migration), obwohl Ledger E-04-P1 als gelandet fuehrt — superseded vs
    nachziehen VOR der A7-Rest-Welle klaeren. [LEDGER:3690/:3719/:3656-3660; betrieb B-5]
B3. **OS-U4 (A14-Rest) + Z-04-Testpflichtteil** — OS-U3 hat 0 produktive Konsumenten (GA-10-Marke
    warnt vor Fehl-Lesart "erledigt"); OS-Werte fehlen vor Messung in Mess-Spalten/Dateinamen.
    [LEDGER:3616/:3719/:3723]
B4. **A4 "12-Perm-Paket" + FS1-Testschuld** (Mess-Pfad stamp_bleibt iterator:1812, "spaetestens vor
    Messung") + FS2-Inhalts-Anker/E.0-Rest (queued F4 deckt nur teilweise). A4 nach Zuordnung 03.08.
    nie wieder aufgetaucht. [LEDGER:3721/:4124]
B5. **Mess-Schnitt-Fenster: T6-Einsammel-Naht + Doppelzaehlungs-Regel** — Owner-Entscheid Posten-68
    Option B strikt erzeugt Konsequenz-PFLICHT (a) VOR Messbeginn; Zulieferer liegen bereit, das
    Fenster steht in keinem Glied der Reststrecke. [LEDGER:3928-3931; Zulieferer :3946/:4004/:4043]
B6. **Mess-Interpretations-Entscheide Posten 74/77/78** (OOM-Roh-Route; kReal16-Kollaps; XorFilter
    30/256 ECHTE FALSE NEGATIVES) — Frist "VOR Messbeginn entscheiden"; Nach-Abgabe-Band
    "Posten-Register" deckt die Frist NICHT. Dazu Posten-62/KF-6-Warnung kLbufBytes-OOB bei
    line_size>64 (muss im KF-6-Fenster mitbewegt werden). [LEDGER:3946/:3959/:3939]
B7. **V4-Owner-Vorlage/NUR-KENNTNIS-Block NIE UEBERGEBEN** — Traeger der Vor-Messbeginn-Entscheide
    (77/78) + K1-K4, Posten-60-Terminierung, SF-1-GO, Platten-GO 2,4G, /tmp/comdare_test_1001-
    Loeschfrage (16119 Eintraege), P2-P8/Peak-Quelle, V3b-Ergaenzung, FK-8, E4/E14, R-G2/(92).
    Kein Versand-Beleg, kein Task. [docs Fund 1; 20260804-OWNER-VORLAGE-v4-...md; LEDGER:3982/:3990/:3931]
B8. **D-10/L11-Referenz-Eichung** (46er ctest-vs-CI-Differenz belegen) + **J-Hygiene L2** — nie
    vollzogen; leben nur in Trigger-Sequenz-Zeile 3774, deren Verweis "LEDGER:98" GEDRIFTET ist
    (real :104). Drift heilen. [LEDGER:3734/:3774/:104]
B9. **P11 Phase-5-Pre-Flight nirgends konsolidiert** — verstreute Pflichten: pgrep-Mess-Exklusivitaet
    (:2914), COMDARE_BESTANDSLOG-Env-Check (:4166), Nachhol-Naht der entfallenen Ebene-B-Enumeration
    (:4165). Meta: Phasen 3-5 sind im Board Blackbox (nur V7.4-Kette + 3774 + teils stale
    Lage-Dossier-L-Posten) — exakt die Verlust-Klasse. Checkliste anlegen. [LEDGER:2914/:4165/:4166]
B10. **V7.4 "4+1 lokale Beweise" + G6 (J-0..J-5) auf GEEICHTEM SHA512-Stand NEU erbringen** —
    Alt-Belege durch A2-Eichung entwertet; Variant-Gate-E2E seit A2 INERT (VARIANT_GATE write-only,
    C6-Befund), haengt am offenen O-2. Kein Neubeweis-Posten im Board. [LEDGER:104/:4123/:4164]
B11. **Posten 19: stale build/ mit 17-Achsen-Codegen** vergiftet jeden lokalen Haupt-build-Lauf =
    Substrat der 4+1-Beweise; Achtung getrackte Mess-CSV im build/. [LEDGER:3712; Memory-Falle]
B12. **xlsx-Default-Writer (#46b/A9)** — Serialisierer FEHLT (Atlas-R5 bestaetigt); Owner-KERN
    CSV XOR xlsx mit xlsx=DEFAULT; Bau-Posten-Einordnung nie verbucht. Ohne ihn faehrt die Messung
    (Phase-6-Rueckschrieb) gegen den Owner-KERN auf CSV. Heimat: Phase-3-Spur A9 (Dossier liegt).
    [Ledger:4157-4160; atlas-runde5/korpus.md:66 + review.md:51]
B13. **L18-Teilmenge (--print-env, %/ETA-, JSON-Marker)** — per FAHRPLAN+Ledger:3861 an Phase-5-ETA/
    Phase-6-E-04 geheftet (Owner R7 "Reihenfolge beibehalten"); IST-Anker fuehrt R3-Rest pauschal
    nach Abgabe => ETA-Teil ungeplant. Aufnehmen ODER bewusst herabstufen und deklarieren.
    [FAHRPLAN L18; LEDGER:3861]

## A. ECHT LIEGENGEBLIEBEN — Rest (vor-Abgabe / unkritisch)

A14. **FF0-Owner Multi-Plattform-Generalitaet** — im §55-Block als "Abgabe-Blocker, hoch" gefuehrt +
    Anhaenge-B/E-Stubs + Mess-Manifest/Provenance. STRITTIG: evtl. laengst superseded, aber KEIN
    Vermerk — Status zwingend vor Fr 08.08. klaeren. (vor-Abgabe) [LEDGER:2916/:2940]
A15. **§55-Gesamt-Reconcile ueberfaellig** (letzter Voll-Konsolidierungs-Block 20.07., seither kein
    Reconcile): Coverage-#18, W12-B, Datensatz-Akten 5/8, Serialisierungs-4-Straenge, m3v2-Beleg,
    I-PMC-2/3, CI-2-Pass, measure-drop-XML-Default — teils vermutlich subsumiert (s. D), Vermerke
    fehlen. (vor-Abgabe) [LEDGER:2829-3063]
A16. **Posten-Register-Basis (2)-(18) + (25)-(29) fehlt in der Single-Source** (nur Session-Docs/
    Backups); Doktrin-Referenz LEDGER:3584 zeilen-gedriftet. Register ins Ledger rekonstruieren,
    sonst ist "Posten-Register-Abarbeitung" nach Abgabe nicht ausfuehrbar. (vor-Abgabe) [ledger.md E]
A17. **ce-Doku-Nachzuege trotz mehrfacher ce-Fenster nie vollzogen**: Stufen-Doktrin C1-C4 — C1 =
    aktenkundiger WIDERSPRUCH hybrid_tier_stufe_soll_design.md:286-288 "[[System],[Organ]]" gegen
    organ-freien Mess+System-Stempel-Kanon; C3/K4 superseded ohne Vermerk (s. D4); dazu Posten 46
    (G8-Par.1.2-Dateitabelle) + S4-Matrix-Regel-Anker (Genus-Erst-Instanziierung). Naechstes
    ce-Fenster (A2-Fix-Welle) nutzen. (vor-Abgabe) [docs Fund 2; LEDGER:3868/:3899/:4096]
A18. **§66-Lager-Gate G5 + G1**: G5 "P-B Pruning lokal->0" ohne Vollzug/Supersede (STRITTIG: faktisch
    supersediert durch "Alt-Bestaende bleiben ADDITIV" :4165 — nie ausdruecklich); O-3 Loesch-GO =
    drittes offenes Owner-Gate, fehlt im Board; G1 "B/C/D+amd24 landen (#27)" ohne Lande-Vermerk.
    Vollzug ODER ausdrueckliches Supersede verbuchen. (vor-Abgabe) [LEDGER:3465/:3476-3481/:4185; =D-04-Haelfte]
A19. **planer_block-Reaper-Folgewelle** — Bedingung "Zweit-Planer-Konsument real" durch W1-Planer-
    Split erfuellt; Folgewelle nirgends. (vor-Abgabe; STRITTIG ob mess-relevant: verfallene
    Reservierungen ohne Reaper koennten Messlaeufe beruehren) [LEDGER:3630/:3790; docs Fund 3]
A20. **L12 Codex-Zweitlens Z-02/Z-03** (identitaets-/stempel-nah, "am dringendsten") — Bedingung
    funktionierende Codex-Umgebung seit Live-Probe nachmittag-6 ERFUELLT, nie gequeued. (vor-Abgabe)
    [LEDGER:3698; docs Fund 4]
A21. **thesis-Klone beide 78 Commits hinter origin** (lokal ef448e4b 21.07., origin 29a1700d 03.08.;
    ~2 Wochen kein fetch; beide clean => FF-faehig) + **super-thesis-Gitlink-Bump offen** (pinnt
    21.07.). 4-Klone-Doktrin; thesis = Abgabe-Dokument. (vor-Abgabe) [betrieb B-1/B-2]
A22. **Chunk-Delta-Reste**: D-16 Verbleib ungeklaert (weder Memory-Digest noch Ledger; nur
    Workflow-Output wshvhykd7); D-09 on/off-Token in Lager-Pfaden unbestaetigt; Q-1-Rueckfrage offen
    (beruehrt K4); E-01..E-26-Vollstatus im Ledger nie nachgehalten. (vor-Abgabe) [ledger.md G]
A23. **E-20-BRING-Pflicht**: I112-Runner-Fleet-Handout — Lead-Push ins Cluster-Repo unbelegt,
    Vorfassung push-gesperrt. (vor-Abgabe; STRITTIG ob Push extern schon erfolgte) [LEDGER:3662]
A24. **Aufraeumpass-Kandidat B-1** (referenzlose "using SearchAlgo"-Aliase abi_adapter.hpp:440/:545)
    NICHT ins Kandidaten-Register fortgeschrieben — Verstoss gegen Owner-KERN "Kandidaten-Liste
    fortschreiben"; Aliase stehen am ce-Ist. (vor-Abgabe, nur Register-Eintrag) [phase-b-treiber/ergebnis-roh.json:99]
A25. **Kleinposten ohne Heimat/Band** (Heimat zuweisen genuegt): SubAxisMembership-Folge-Increment
    target_isa (:3639), G-E3-Host-Binder (:3790), W-11 Cache-Key-Einfaltung (:4147, EINE-Schluessel-
    Welt-Doktrin, deklariert offen aber ohne Band), A9-S2 (freigegeben 04.08., nie gebaut), A10/E-3
    MSVC/Cross-Fenster (:3804), Posten-83-Generalisierung (:3999), fill_observer_v3-Umzug + 8/9
    SA-Slots (:3875), P10-Folge-Sweep (:3830), in_memory_measurement_buffer-.gitkeep etikettieren
    (:4029), OS-U5-Doku-Vollzug A-08 (:3618). (unkritisch)
A26. **Betriebs-Hygiene** (alles nach Wellen-Landung): MEMORY stale (Headline 13:00-Stand; Anker-Doc
    nennt super=69dd9fb7/wf_7953bc4d statt 603f15f4/wf_1a78cffa+wf_e0b496e0; Absturz+Audit-Auftrag
    fehlen) [B-7]; toter 05b-Kopf-Artefakt-Link 61235adf->61359d31 (1 Zeile) [B-8]; lokale
    main-Zeiger super/ce/prt-art FF [B-3]; 8 Worktrees+Alt-Branches abraeumen + worktree prune +
    L20-Liste fortschreiben [B-4, s. D1]; L17-Overleaf-Sync-Posten-Traeger neu anlegen [docs Fund 8].
    (unkritisch) [betrieb.md]
A27. **Infra-Posten ohne Wiedervorlage-Anker im Diplom-Board**: test_s5-Blackhole-PUT-Flake (:3804);
    durable builds_dir/cache_dir-Umzug + Cleaner + Legacy-S3-Flag-Test (:3893). (unkritisch, Infra-Lane)

## C. GEPARKT-OK (bewusst, MIT Beleg) — Zaehlung: 19

1. IST-Anker-Nach-Abgabe-Band (R3-Rest, #35-.so, #54-Option-b, W3-Vollausbau, W2-Codegen-Zielform,
   K1-K4-Abarbeitung, Posten-Register, Hybrid-Bau/Auswertungsphase, #32, PL-21, #47) — Owner-gedeckt [IST-Anker].
2. SF-1-Heilungs-Fenster Default (b) nach Abgabe [Ledger:3863-3869; V4] — GO-Frage gehoert in B7.
3. rescue/e24-c3-wip-pause (Cross-Genus-WIP 0bac9fbe) — gedeckt durch "W3-Vollausbau nach Abgabe";
   AUFLAGE: Ref als Quelle im W3-Posten vermerken, sonst Verlust [betrieb B-6; IST-Anker].
4. L21-Phase-6.5-Behaelter (E-01/03/06/16/17/25/26, G5/Matrix-Zergliederung, §73.1/§73.5-Q6/§69.9-
   C-3a/§70.4-RF-4/Q4, O-6/OD-1, #327, K5, Posten-43) — Owner H.7 "Rest nach Abgabe PFLICHT";
   Quelle bleibt FAHRPLAN/Uebergabe 04.08. §3 [docs Fund 10].
5. f2/f3-Remote-GOs "NACH Abgabe terminiert" [LEDGER:3741-3742].
6. F27/#48 GOLDEN-XML-Kanonik user-gated seit 16.07., "Sync-Gate haelt" [LEDGER:3869/:3361] —
   Wiedervorlage empfohlen (3 Wochen ohne Bewegung).
7. PhasenCheck-5.16-Rest (6 Commit-Referenz-Diskrepanzen) "REST nach Phase 7" [LEDGER:3781] —
   §75-Aufraeumpass/Phase 7 im Board namentlich verankern (docs Fund 9).
8.-12. Posten 43 (Owner-Fenster nach Abgabe, :3868) · 67 (nach Abgabe/Owner-Vorlage) · 81=K2 (:3969) ·
   90 (Auswertungsphase, :4091) · 50 (nach V-5c).
13. Mess->PDF-Rueckschrieb-E2E an Messlauf gebunden = Phase 6 [LEDGER:2594/:2941].
14. S-7 Deep-Research-Locking GEPARKT [LEDGER:2560ff].
15. INC-5/INC-6 infra-delegiert [LEDGER:2597].
16. Datensatz 6-vs-48 user-gated [LEDGER:2622].
17. R6 "Planer taktet selbst" = Nach-Abgabe-TODO per Owner mittag-6 [Ledger:4067/:4077] — nur
   Namensnennung im Board fehlt (docs Fund 11).
18. 3 Overlay-Festlegungen (S8/L14) deklariert nicht-blockierend fuers spaetere Fenster
   [LEDGER:3741/:3790/:4162] — Wiedervorlage-Traeger via B7-Buendel.
19. backup/pre-rescrub-2026-07-25 bleibt (additiv-Doktrin) [betrieb §2].

## D. UNVERBUCHT ERLEDIGT (real erledigt, nur Doku/Task fehlt)

D1. **L20-NEIN-Liste STALE**: 5 der 7 Worktrees (wt-w2-A13-M1b, wt-w2-FK-1/2, wt-w2c-TP1FK1-Fixes,
    wt-w2c-Wachen-Fixes) tragen laut git cherry NULL echte Patches (alle patch-aequivalent in dev);
    wt-w2-E02-* existiert nicht mehr; wt-a8s1/wt-m3/wt-w10 HEAD-in-dev. => 8 Worktrees nur noch
    abraeumen (Einzelpruefung IST erbracht), L20-Liste fortschreiben. [betrieb B-4]
D2. rescue/w2c-tp1fk1-fixes + rescue/w2c-wachen-fixes patch-aequivalent gelandet (harmlos). [betrieb §3]
D3. D-11 extermal/external_utils-Rename faktisch gelandet; nur formale Ein-Zeiler-Bestaetigung fehlt. [ledger.md G]
D4. K4-Frage (=C3 der Nachzieh-Liste) laengst entschieden/superseded (Owner mittag-11); Vermerk fehlt
    an Design-Doc:443-444 + hybrid/README.md:54-56. [docs Fund 2]
D5. STRITTIG: Posten 30 (test_s5-Tempdir) durch [69]-Haertung wohl entschaerft — kein Vermerk. [LEDGER:3790/:3936]
D6. STRITTIG: W12-B Cache-Key-Spiegelung vermutlich durch A2-Eichung subsumiert — kein Vermerk. [LEDGER:2619]
D7. STRITTIG: Goldener Coverage-Test #18 evtl. durch Voll-Bau-4 subsumiert — kein Vermerk. [LEDGER:2919]
D8. §52-B14-Restpunkt (1) "Planer-Konsument des Cursors" durch W5-Kern gedeckt
    (planner/progress_cursor_reader.hpp; Welle in Dual-Review = IST-Anker) — nach Landung Ledger-Vermerk. [docs Positiv]

---

## EMPFOHLENE REIHENFOLGE (Manager-Blick)

1. SOFORT (naechster Owner-Kontakt): B7 V4-Uebergabe (traegt B6-Entscheide 77/78 + O-3 + K1-K4 + Posten-60).
2. VOR TRIGGER Do 07.08.: B1 E-18 · B2 E-04-Rest (+B-5-Klaerung) · B3 OS-U4 · B4 A4/FS1 ·
   B5 T6-Schnitt-Fenster · B9 P11-Checkliste (+B8 D-10/L2 + B11 build/-Hygiene) · B10 4+1-Neubeweise
   (nach O-2) · B12 xlsx-Writer (Phase-3-Spur A9) · B13 L18-ETA-Entscheid.
3. VOR ABGABE Fr 08.08.: A14 FF0-Klaerung · A21 thesis-Sync · A16 Register-Rekonstruktion ·
   A17 C1-Widerspruch · A15 §55-Reconcile (erledigt D5-D7 gleich mit).
4. NACH WELLEN-LANDUNG (unkritisch): A24-A27, D1-D4-Verbuchung, Memory-Nachtrag.
