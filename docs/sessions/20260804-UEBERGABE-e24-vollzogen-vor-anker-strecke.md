# KONTEXTUEBERGABE 04.08. nachmittags -- E-24 VOLLZOGEN, Vor-Anker-Strecke laeuft (reich, bindend)

> **COMPACT-REGEL (Owner, stehend):** Nach JEDEM Compact ZUERST einlesen, in dieser Reihenfolge:
> (1) Memory `feedback_claude_code_arbeitsweise_v2_konsolidiert.md` (v2.1 + B.3-Nachtraege) | (2) DIESES Doc |
> (3) FAHRPLAN `20260803-FAHRPLAN-gesamtkette-wellen-phasen.md` (+L1-L22) | (4) Ledger-NACHTRAEGE 04.08.
> (grep '04.08.2026' -- die Kette morgens bis abend ist die Wahrheit der heutigen Landungen) |
> (5) E-24-Bauplan + W10-Bauplan + Qualitaets-Katalog + Gattungs-Dossier (alle docs/sessions/2026080[34]-DOSSIER-*) |
> (6) OWNER-Doc + Lage-Dossier. Explore-Doktrin: fehlende Entscheidung -> ERST Explore, alles ist entschieden.
> PAT: Blind-Extraktion + RUECKWAERTS-Test bis HTTP 200 (Position rotiert; heute 2x Position 1 = letzte).
> OAuth-401-Klasse: lange Workflows sterben am Token-Ablauf -> resumeFromRunId (cached agents), NIE neu starten.

## 0. OWNER-MODUS

Durchzieh-Order aktiv (Phasen in einem Zug bis Trigger; **Messung Phase 6 = USER-GO-STOPP**). Ultracode AN.
Modelle: Fable=Planung/Design/Review/Synthese, claude-opus-5=Struktur-Bau (Probe+Fallback), Codex defekt ->
Fable-Ersatz-Lens MIT Ledger-Vermerk (heute mehrfach vollzogen). **JOB-SPERRE AKTIV** (Startklar-9, seit
E-24-Landung): KEIN Trigger, KEIN Lager-Voll-Lauf, KEINE schweren Parallel-Jobs bis zum ANKER-Vollzug.

## 1. LINIEN-IST (04.08. ~15:00 UTC; alle FF-Pushes SHA-gepinnt, alle CIs verifiziert gruen)

| Repo | dev == main | Inhalt der Spitze |
|---|---|---|
| ce (286) | **19f27223** | E-24 VOLLZOGEN: MAJOR 8, Magic .A8., '+ceb=8.0', Gate 377 (14468/14469/14471 gruen) |
| super (288) | **4bb3d2ce** | Ledger bis 'E-24 VOLLZOGEN/GATE 4 geschlossen' + alle Dossiers + Backups (14470/14472 gruen) |
| thesis (289) | 29a1700 | unveraendert |
| prtart (287) | c6f0754 | unveraendert |

**HEUTE GELANDET (die volle Kette, je CI-hart + main-FF):** A1-Lager-Rest (Phase 1 KOMPLETT, f40dfb4b) ->
W10-Byte-Ereignis (51c012c5; Zellwerte + W10-M2 '+ceb=7.2' + Perm-Pfad-Verdrahtung) -> A8-S1 T17-Fix
(de7688b9; L6-Beleg-Ordnung) -> E-24 a-Teil C0-C5 (44bcda99; inkl. Lint-ODR-Fix c6559eaf) -> C6-V
Statistics-Huellen (19adba05) -> **E-24 b-Teil C6-C11 (19f27223; 20 Commits: Wire-Promotion + Map-Umbenennung
+ DER MAJOR 7->8 + FK-5 + G5/G6-Beweise + G8-Negativ-Liste)**. Dazu die Planungs-/Analyse-Schicht:
W10-Bauplan, E-24-Fenster-Bauplan (L4), Qualitaets-Parameter-KATALOG (27 Themen), Gattungs-Diskrepanz-Dossier
(C7-1..C7-8), V3b-Owner-Vorlage, 5 Owner-KERN-Nachtraege verbatim. Wir liegen VOR dem Bauplan-Kalender
(E-24-Landung war fuer Di spaet/Mi frueh deklariert -- sie ist Mo nachmittag).

## 2. LAUFENDE ARBEIT (bei Wiederaufnahme ZUERST)

1. **A8-S3-Welle wf_509eca66 LAEUFT** (wt-a8s1, Branch a8-s3 ab 19f27223; Opus-5 + Fable-Review):
   (a) axis_stats[17]-strukturell-0-Fix MIT Beleg-VOR-Fix (fill_observer_v3 liest statistics VOR Timing;
   Wire-Layout 1344 UNBEWEGT -- nur Befuellungs-Reihenfolge); (b) SA-Member-Nachruestung nach Katalog
   Sektion 4 (die 9 fehlenden Slots als reale Member, index_organization zuerst; ehrlich EmptyAxisSnapshot
   ohne statistics) = Owner-KERN observe_axes-ueber-ALLE-Achsen; (c) CSV-Klasse-C host-seitig (peak-END-Append,
   B7-Etiketten-Heilung, pmc_branch_misses, Tail-Perzentile, frag_milli-Ehrlichkeit E9, Legende).
   G8-Negativ-Liste bindend. VERARBEITUNG: Verdikt -> Voll-Kadenz-Landung (rescue beide Remotes, merge --no-ff,
   Tree-/Pruef-Beweis, gitleaks podman 'N commits scanned', Push, CI-Wache VOLL-SHA, main-FF pinnen,
   super-Gitlink+Ledger). Bei 401-Tod: resumeFromRunId 'wf_509eca66-829' (Skript unter
   ~/.claude/projects/-home-comdare-wt-e24-build-e24/46375cdc-*/workflows/scripts/).
2. **STRUKTUR-AUDIT wf_04be888a FERTIG, ABER UNVERARBEITET** (Owner-Order: "Merke dir den letzten Workflow,
   lies ihn bitte erst mit frischem Kontext"). Rohdaten MECHANISCH gesichert:
   `docs/sessions/backups/20260804-struktur-audit/` (ergebnis-roh.json + DOSSIER-unverarbeitet.md).
   MERKER (nur Kopfzeile, NICHT verarbeitet): Verdikt "SCHNITT-FEHLER-VORHANDEN -- genau EINER (SF-1 =
   anatomy/container_framework.hpp:37 -> builder/genus_binding_traits; Heilung=Traits-Split, G8-gesperrt =>
   Owner-Fenster)"; Rest = Schoenheitsfehler Aufraeumpass 39-53; Review TRAGFAEHIG.
   VERARBEITUNG MIT FRISCHEM KONTEXT: Dossier VOLL lesen -> Ledger-Nachtrag -> SF-1 als Owner-Vorlage
   (NICHT still heilen -- G8-Flaeche!) -> Aufraeumpass-Liste 39-53 uebernehmen -> Owner-Bericht.
3. Danach die VOR-ANKER-KETTE (G8 3.2, Reihenfolge bindend): **A8-S4** + **A8-S5** (axes/-Header,
   familienweise <=8 Worker parallel, Datei-Liste IMMER aus grep [~70+, nie die Zahl glauben]; A8-Dossier
   traegt die Scheiben-Schnitte) -> **EIN ANKER-VOLLZUG** (GATE 5 = TP1-Neu-Inventur [2d-gehaerteter
   Bestandslog-Pfad, Arbeits-Ist] + A2-SHA512-only-Skip-Gate-Eichung GENAU EINMAL, L14: MIT leerem
   Overlay-Glied -- deklarierte Luecke). Der Anker beendet die Job-Sperre.

## 3. OFFENE PHASEN/WELLEN NACH DEM ANKER (FAHRPLAN + L1-L22; Kalender neu rechnen)

- **Phase 3 Parallel-Spuren** (nach Anker frei): A9-xlsx (Dossier liegt; konsumiert lager_pfad_grammatik,
  L5 erfuellt) | A7/E-04-Rest (P2/P3/P4 + Z-05/06/08 + E-18) | A14/OS-U4 (+Z-04) + OS-U5 (L12) | A15 FK-3/FK-4 |
  A10 HW P4-P6 + prod2-SPD | A11 + A12 NAS-Creds | E-19 Stufe 1 (Infra) | Thesis C1-Rest/C4/C6/C7 (L15).
- **Phase 4 (Beweise + Permutationen):** A3/Beweise 1-5 (B5 zweistufig nach E-07-Gate-Definition, L10:
  bindet an die EINGEFRORENE Linie nach E-24, Pflicht-Re-Run <1h) + Paragraf-61-Dual-Weg-Beleg | A4/12-Perm
  (O0-O3 x {no_ext,avx2,avx512}, >=16 Anker, 2d-FS1-Messpfad-Test) | A5 ETA/Kalibrier (F5/F6).
- **Phase 5 TRIGGER-SEQUENZ (AUTONOM, Ziel weiterhin Do 07.08. -- Polster vorhanden):** D-10/46er-Eichung
  (L11) -> J-Kette (N=LEBENDES Gate, live erheben; V32=ON nur CI-Kanon) -> heavy-Signal (#519) ->
  Kalibrierlauf GN_TOTAL=64 -> ETA -> **VOLL-BAU-4-TRIGGER** (POST 288: GN_TOTAL=131072 x 12 Perms,
  4096er-Meilensteine, Bestandslog AN, VARIANT_GATE=true, Endpoint-Preflight) MIT dem WOERTLICHEN
  7-Auflagen-Satz LEDGER:98 (PMC-AND hart / COMDARE_MINIO_ENDPOINT=Alias / NAS=PR4100+df-Wache /
  Bestands-Invalidierung / github-PAT NEU aus Vault / main-Nachzug je Welle / keine parallelen schweren Jobs).
- **Phase 6 = USER-GO-STOPP:** E.0 KERN-Mess-Schema PFLICHT vor jeder Messung; dann 320er-Abgabemessung (GO)
  -> Voll-Messung (GO) -> Rueckschrieb -> Auswertung (xlsx-Baum/Spline/Break-Even) -> Hybrid -> COMPARE -> C5.
- **Phase 6.5/7 nach Abgabe:** L21-Behaelter (f2/f3-GOs, 3 Overlay-Festlegungen, #327, O-6/OD-1, E-01..E-26-
  Reste, K5-Template-Parametrisierung, E4/E14-'ohne'-Luecken [golden-Bruch!], Posten-43 axes/topics) +
  Paragraf-75-AUFRAEUMPASS Kandidaten (1)-(53) [Liste im Ledger fortgeschrieben; 39-53 aus dem Struktur-Audit
  NACH dessen Verarbeitung uebernehmen].

## 4. FALLEN-KANON-ERGAENZUNGEN (heute real; zusaetzlich zu da49aac5-Par.4 + PAUSE-Doc-Par.4)

- **OAuth-401 toetet lange Workflows** (2x heute: W10, E-24-Lande-Review) -> IMMER resumeFromRunId; der
  Resume-Review kann schlank ausfallen -> bei Owner-Zweifel MANUELLES Lead-Review am fixierten Objekt
  (Praezedenz: E-24-Zweit-Review, 9 Pruefachsen -- Muster im Ledger-Nachtrag 'abend').
- **Workflows lesen den LEBENDEN Ledger** -> frisch persistierte Owner-KERNe fliessen organisch in laufende
  Nachbesserungs-Runden ein (Katalog-Welle korrigierte sich selbst; Kurskorrektur-Skript-Edit war unnoetig).
- CRC-/Frozen-Vektor-grep-Treffer im Diff koennen ZITIERENDE Doku + PIN-WACHEN sein (G8-Liste,
  kCrc64AnkerVorC8) -- Kontext pruefen, nicht als Anker-Bewegung fehldeuten.
- G5-Reihenfolge: Magic KODIERT den Major -- echtes Altmodul faellt als magic_mismatch(4), NICHT
  abi_major_mismatch(5); beide Schloesser einzeln beweisen.
- Task-Store-Verluste (5x): Uebergabe/Pause-Doc = Wahrheit, Stack neu anlegen (E-21).
- Pi5/node7: KEIN SSH-Passwort existiert (root LOCKED/key-only, Vault DEV:477) -- Zugang via
  keys/id_ed25519_redcomponent_pi5.key bzw. cluster-Key (10.0.10.207). Owner hat sich selbst eingeloggt.

## 5. OFFENE OWNER-PUNKTE (nicht-blockierend; naechster NUR-KENNTNIS-Block sammelt)

V3b-Vorlage liegt (docs/sessions/20260804-OWNER-VORLAGE-v3b-*) + ERGAENZUNGEN: G5-Reihenfolge-Befund,
'+ceb='-Ketten-Korrektur (Basis trug 7.2), FK-8-Etiketten-BELASSEN-Entscheid, E4 (T17-Min/Max-Semantik),
E14 ('ohne'-Luecken T14-None-Filter = golden-Bruch -> nach Abgabe), Platten-GO wt-w10/build-lc.stale-pfad
(2,4GB; Platte war 95%), **SF-1-Heilungs-Fenster (nach Struktur-Audit-Verarbeitung)**, print_version_facade
= deklarierte Luecke (R3/L18). Messung Phase 6 = USER-GO.

## 6. WORKTREE-/UMGEBUNGS-IST

wt-e24 (Branch e24-b, gelandet; build-e24 warm = C10-DLL-Kette gebaut) | wt-a8s1 (Branch a8-s3, AKTIV --
Welle baut, NICHT anfassen) | wt-w10 (gelandet; build-lc warm + build-lc.stale-pfad 2,4GB loeschbar nach GO) |
wt-m3 (Branch lager-rest, gelandet) | 7 Alt-Worktrees (Sammellandungs-Pruefung = Aufraeumpass) |
G5-Fixture /home/comdare/e24-g5-fixture/ (major7-referenz + HERKUNFT.txt) BEHALTEN bis nach C10-Re-Runs |
Scratchpad traegt .patcfg (aktiv) -- bei Pause shredden. Gate-Zahl der ce-Linie: **377**.
