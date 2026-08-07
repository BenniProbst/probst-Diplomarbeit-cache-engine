# KONTEXTUEBERGABE 07.08.2026 (vor Compact) -- Konsolidierungs- und Audit-Session

> ERST-ANKER fuer den Wiedereinstieg. Lese-Reihenfolge nach Compact: (1) diese Datei;
> (2) der laufende/fertige Workflow wtdpeiotj -> docs/sessions/20260807-GESAMTDOSSIER-aktuell-jetzt-konsolidiert.md;
> (3) Ledger-Nachtrag morgen-1; (4) MEMORY.md-Index.
> AUTORITAETS-KETTE: Owner-KERN > dieses Dokument > aeltere Session-Docs > Bauplaene > Ist-Code.
> ASCII bis auf Paragraph-Zeichen.

## 0. STAND IN FUENF SAETZEN

1. Der Hauptstrang (Messkette/Bau) ist seit ~01:50 vom OWNER PAUSIERT; diese Session macht
   ausschliesslich KONSOLIDIERUNG + SELBST-AUDIT der Doku-Arbeit.
2. Alle Code-Refs stehen gleichauf und gruen: ce dev=main=54106bc9, thesis dev=main=19e1592,
   cluster dev=d7eab98/main=43b73dff; super development=835686ba, super main=2871fabf
   (main-FF bewusst zurueckgestellt).
3. LAEUFT beim Compact: der Konsolidierungs-Workflow wtdpeiotj baut das neue Gesamt-Dossier
   (Ziel-Datei unten) -- er MUSS nach dem Compact abgeholt, geprueft, committet und gepusht werden.
4. Zwei Owner-Auftraege sind vollzogen: amd_uncore auf prod1 geladen+bootfest; die verlorenen
   lokalen comdare-Passwoerter auf prod1+prod2 rotiert.
5. Das einzige echte offene Bau-Paket ist numa (bewusst pausiert); zwei Mess-Sperrposten (R-3,
   SW-5) sind am Objekt als OFFEN verifiziert und im Ledger verbucht, aber NICHT gebaut (Pause).

## 1. DER LAUFENDE WORKFLOW -- wtdpeiotj (KERN DES WIEDEREINSTIEGS)

**Auftrag (Owner, wortlaut-nah):** ein neues "aktuell-jetzt Gesamt-Dossier" durch sequentielle
Konsolidierung: die neueste Information fuehrt, neuere Aussagen verdraengen alte.

**Verfahren (Fold von ALT nach NEU):**
- GRUNDLAGE (vom Owner bestaetigt) = `docs/sessions/20260726-DOSSIER-session-gesamtstand-kompaktierungs-anker.md`
  (das letzte echte Gesamt-Dossier im Fenster 14.-30.07., "vollstaendiges Session-Gedaechtnis").
- ZIEL-DATEI (der Akkumulator auf Platte, abbruchsicher) =
  `docs/sessions/20260807-GESAMTDOSSIER-aktuell-jetzt-konsolidiert.md` (Start 349 Z., waechst).
- Vorgeschichte < 26.07. (289 Dok, 5 Buendel): per SONNET-5 Explore (max/very-thorough, read-only)
  -- findet, was die Grundlage NICHT traegt. (Owner: "alles was aelter ist machen wir nicht Fable,
  sondern Explore mit Sonnet 5 max effort / very thorough".)
- Fold vorwaerts >= 26.07. (102 Dok, 5 Epochen 26-27jul/01-02aug/03-04aug/05-06aug-a/06-07aug-b):
  FABLE 5 xhigh, STRICT seriell, editiert die Ziel-Datei; neuer verdraengt alt (Altes wird
  "(deprecated ...)"-markiert, nicht geloescht).
- Session-Log zuletzt: 43 woertliche Owner-Aussagen aus session-ab-vorletzter-kompaktierung.jsonl
  als juengste/autoritativste Schicht.
- ZWEI KORREKTUR-LOOPS (Owner-Auflage "mindestens 2"): je Pruef-Agent gegen die Planungsrealitaet
  (Owner-Aussagen im Log) + Korrektur-Agent.
- Redaktion + 2 Verify (Vollstaendigkeit gegen 06.08.-Dossier+Ledger; Anker-Gegenpruefung am Objekt).

**Hilfsdateien (job-tmp, fluechtig -- nur fuer den Workflow):**
`/home/comdare/.claude/jobs/5a19728e/tmp/fold/` (Epochen-Listen fold-*.txt/hist-*.txt +
planungsrealitaet-owner-log.md); Script `/home/comdare/.claude/jobs/5a19728e/tmp/konsolidierung-fold.js`.

**NACH DEM COMPACT ZU TUN:** Ergebnis von wtdpeiotj abholen (Task-Notification oder /workflows).
Die Ziel-Datei lesen, die zwei Verify-Berichte pruefen, dann gitleaks (Elternrepo-Mount!) + commit
+ dual-push aus wt-super-landung. Falls der Workflow beim Compact abbrach: die Ziel-Datei traegt den
letzten seriellen Fold-Stand (abbruchsicher); mit resumeFromRunId wf_e19d0850-9f7 fortsetzbar.

## 2. WAS DIESE SESSION VOLLZOGEN HAT (chronologisch)

1. **Kontextuebergabe dd107862** (Vorgaenger-Anker) geschrieben+gelandet.
2. **amd_uncore auf prod1 geladen+verifiziert+bootfest.** Weg: das LOKALE Konto admin-management
   (uid 1000, Gruppe sudo, `(ALL) NOPASSWD: ALL`); Passwort = Vault-Wert mit md5head 509f3aef
   (im PROD-Vault faelschlich als "stale/built-in" markiert, ist aber der AKTIVE lokale Login).
   Ergebnis: amd_l3 (PMU-type=17) + amd_df/amd_iommu_0/amd_umc_0/1 sichtbar; L3-Gegenprobe
   29.201.698 Events; /etc/modules-load.d/amd-uncore.conf bootfest.
   FOLGE-CODE (offen, Pause): linux_perf_pmc_source.hpp muss L3 ueber den PMU-Typ aus
   /sys/bus/event_source/devices/amd_l3/type oeffnen statt PERF_TYPE_HW_CACHE (Zen5 errno=2);
   Anhang-Hinweis: Uncore zaehlt MASCHINENWEIT, nicht prozesslokal.
3. **Verlorene lokale Passwoerter rotiert** (Owner: "nur verlorene Passwoerter von LOKALEN Konten").
   Diagnose: nur `comdare` (uid 1001) trug je Host ein PW, das nicht im Vault stand; root/
   gitlab-runner/postgres sind gesperrt (kein Unix-PW). prod1+prod2 comdare neu gesetzt+verifiziert
   (uid=1001), Wert value-frei in PROD-Vault (comdare-local-prod1/prod2), Cluster-Repo committet+
   gepusht (d7eab98). Kein pam_faillock auf den Maschinen -> Fehlversuche waren echte Negative.
4. **Workflow-Endberichte gesichert** (32 Stueck: 14 voriger Kontext + 18 diese Session) ->
   docs/sessions/backups/20260807-workflow-endberichte/ (588f5781). Ein Bericht (afea5d5e,
   gitleaks-Vormeldung) wegen Token-Match ausgeschlossen. Rohdaten (61 MB) lokal in
   backups-workflow/ (Token-Risiko, nicht gelandet).
5. **Zwei vergessene Session-Dokus** nachgelandet (470bf63a).
6. **Korrektur-Workflow w41d6x1yq** (7 Agenten): alle Doku-Anker-Fehler korrigiert, jeder Wert am
   ce-HEAD 54106bc9 neu gemessen -> super 835686ba. Wichtigster Fix: allow_failure real
   experiment_plan_director.hpp:1373 (NICHT :1333 -- der falsche Anker war ueber 5 Dokumente
   propagiert). Weiter: seg_ns 308 (nicht 326), swisstable-libs 11 (nicht 5), run_options cap
   praezisiert (wird im thesis_profile-Dialekt geparst), sechs Planungsfragen -> vier dokumentiert.
7. **Konsolidierungs-Workflow wtdpeiotj** gestartet (Abschnitt 1) -- laeuft beim Compact.

## 3. DER SELBST-AUDIT (Verdikte ueber die Opus-4.8-Arbeit, aus dem Gesamt-Dossier wktkhd1cj)

- **Verdikt 1:** 6 von 20 Stichproben im 06.08.-Gesamt-Dossier waren falsch -- ALLE Anker-Fehler
  (kein Sachfehler): Belege zeigten auf falsche Zeilen/Commits. Korrigiert in w41d6x1yq.
- **Verdikt 2 (Transkript-Treue):** kein Owner-Satz erfunden, kein Zeitstempel falsch -- aber
  KERN 1 ("Das schliesst den Kreis") und KERN 12 (ultracode/Fable-5-Auftrag) abgeschnitten, zwei
  Owner-Nachrichten fehlten. Vollspanne (112 Owner-Nachrichten) inzwischen gesichert.
- **Verdikt 3 (NICHT VOLLSTAENDIG):** zwei Mess-Sperrposten galten als geschlossen, sind es NICHT
  (am ce-HEAD 54106bc9 verifiziert):
  - **R-3:** Mess-Defines stehen NICHT im Fingerprint-Preimage (0 Treffer in anatomy_fingerprint.hpp
    + toolchain_stamp_glied.hpp). M-1 hat das NICHT geschlossen -- COMDARE_MEASUREMENT_ON bleibt
    ABI-wirksam ohne im Fingerprint zu stehen -> stiller Falsch-Skip-Risiko; Fix kostenlos solange
    0 .fingerprint-Sidecars, danach 34,4h Neubau-Risiko.
  - **SW-5/E-14:** active_telemetry_is_silent() gibt konstant false, waehrend >=10 Profile
    silent="true" tragen -- golden-beruehrend.
  Beide im Ledger-Nachtrag morgen-1 verbucht, NICHT gebaut (Pause).

## 4. UNGELANDET (zweifach belegt durch zwei Explore-Agenten)

KEIN vergessener ungelandeter COMMIT ausserhalb der bewussten Pause. Konkret:
- **(A) numa-Paket** (bewusst pausiert, wartet auf Teammate-Luecken): ce b1753926
  (b-numa-cpu-pin-process-probe = b-numa-luecken-schliessen, letzterer DIRTY(7)) + super-Haelfte
  `Code/test_data_xml/experiment_schema.xsd` mit `core_class` -- auf KEINEM Zweig, nur Arbeitsbaum,
  als Patch in backups-workflow/20260807-*. BEIDE HAELFTEN ZUSAMMEN LANDEN, erst nach gruener Pipeline.
- **(A) b-e18-snap** super 5c4cf900 -- Verdikt NICHT-LANDEN.
- **(A) super main-FF**: development (835686ba) ist 4 Commits vor main (2871fabf).
- **(B) uncommittetes Arbeitsbaum-Material** (aktiv, kein verwaister Commit): super-Haupt-Worktree
  18 Dateien inkl. uncommittetem Submodul-Bump b241a272->90bca126 (Inhalt schon gelandet); l1_landing
  8 Code-Edits (Scratch im Job-Verzeichnis). Beides in-Arbeit, nicht vergessen.
- Stale-aber-gelandet (kein Handlungsbedarf): b-pmc-errno-diag->22e17f57, b-m2-pmc-invariante->
  8894d983, b-checkheft-nachtrag->38381ac8 u.a. (per git cherry patch-aequivalent nachgewiesen).

## 5. OFFENE OWNER-ENTSCHEIDE (aus den vier Explore-Ergebnissen, im Ledger morgen-1)

- **F-01 Talos:** NICHT streichen, PRAEZISIEREN. Talos ist real (immutables K8s-OS der CI/Cluster-
  Schicht). Unwahr ist nur der Allquantor "jede Messung unter zwei OS-Regimen erhoben" -- erhoben
  wird nur unter root-Linux baremetal auf prod1/prod2; Talos traegt Bau/CI/ccache. Fix = Rollen
  trennen. 3 PDF-Stellen + 4 Drift-Stellen (thesis/diplomarbeit). OWNER-GO zum .tex-Edit offen.
  (minio.comdare.de ist dev-MinIO, im Satz nicht als "cluster PROD" fuehren.)
- **F-02 flat_hash_map:** Owner-Entscheid = Option a (Zusage auf "SwissTable-eigen, API-kompatibel"
  praezisieren).
- **B-3 Core-Achse:** non-kongruent {P|E}x{Single|All}+Ref (Termin-3-Pflicht) vs. {Unpinned|
  PCoresOnly|ECoresOnly|HybridAware} (Code, None!=Unpinned). Welche bindet? + O-C (pe_policy-Default).
- **B-4 Bau-Menge:** offen 524288 vs 1572864 vs 2097152 (Basis 131072). 05_evaluation.tex haengt daran.
- **B-2 sechs Planungsfragen:** vier dokumentiert (F1/F3/F5/F6), offen nur F4 + je 1 Restentscheid
  bei F2/F5.
- **B-5:** O-4 Anhang-A-Reichweite OFFEN (Praemisse "nach Abgabe" durch 15.09.-Termin widerlegt);
  F7 Grundsatz entschieden (Option b Zielform, Option 1 Zwischenstand), Rest offen.

## 6. SICHERUNGEN AUSSERHALB GIT (abbruchsicher, bewusst nicht gelandet)

- backups-workflow/20260807-workflow-rohdaten-5a19728e/ -- 86 Journale, 450 outputs, 84 Skripte (61 MB)
- backups-workflow/20260806-workflow-rohdaten/ -- voriger Kontext (63 Journale, 269 outputs) + endberichte/
- backups-workflow/20260807-session-transkript-vollspanne/ -- session-VOLLSPANNE-ROH.jsonl (112 Owner-Msgs)
- backups-workflow/20260807-korrektur-w41d6x1yq/ -- korrektur.patch
- backups-workflow/20260807-super-hauptklon-uncommitted/, /20260807-numa-luecken-WIP/, /20260807-ungesicherte-arbeit/
- backups-workflow/QUARANTAENE/bnpj776mm.output -- 390 Runner-Token (0600), NIE ins Repo

## 7. FALLEN (in dieser Session real eingetreten)

- Anker-Fehler propagieren: eine falsche Zeile (:1333) stand in 5+ Dokumenten -- am Objekt messen,
  nicht aus Plandocs abschreiben.
- gitleaks im Worktree -> "0 commits scanned" (stille Null): Elternrepo mounten (Hauptklon), Nenner lesen.
- Commit-Message mit `Co-Authored-By` via `-m` + heredoc kann am Quoting scheitern -> Message-Datei (-F).
- ugrep-Alias crasht bei `^\+\+\+` (invalid syntax) -> /usr/bin/grep nutzen.
- rescue-Ref altert, wenn der Branch weiterwandert.
- Ein lokales Gate ist keine Pipeline (git-clang-format prueft Diff, lint:format whole-file).
- Vault: admin-management ist ein LOKALES Konto; der als "stale" markierte md5head 509f3aef ist der
  AKTIVE Login. comdare (uid 1001) sudo-PW war NICHT im Vault (jetzt rotiert+eingetragen).

## 8. ZUGANG (keine Werte)

PAT blind aus Cluster/keys/CREDENTIALS-VAULT-{DEV,PROD}.md (`grep -hoE 'glpat-[A-Za-z0-9._-]{15,}'`),
RUECKWAERTS gegen GET /api/v4/user bis HTTP 200 (Position ROTIERT, nie hartcodieren). CA
Cluster/keys/gitlab-ca-ROOTCA-20260621.crt; Host gitlab.comdare.local; IDs ce 286 / super 288 /
thesis 289 / cluster (eigenes). gitleaks podman docker.io/zricethezav/gitleaks:v8.30.1, Submodule ->
Elternrepo mounten. NIE rebase; git IMMER -C; main-FF nur push origin <VOLLER-SHA>:refs/heads/main.
sudo auf prod1/prod2 via admin-management (NOPASSWD). Werte NIE ausgeben/committen.

## 9. TASK-LISTE / MEMORY

Task-Liste (TaskList) ist der User-sichtbare TODO -- #31 (Hauptstrang pausiert) und #32
(Konsolidierung wtdpeiotj, in_progress) sind die aktiven Anker. MEMORY.md-LAGE-ANKER auf diese
Uebergabe zu setzen.
