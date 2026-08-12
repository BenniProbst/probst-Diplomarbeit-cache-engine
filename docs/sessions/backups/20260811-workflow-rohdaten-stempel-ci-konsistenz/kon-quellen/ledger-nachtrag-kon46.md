## NACHTRAG 12.08.2026 — KON46: DIE LANDUNGEN SIND DURCH, DAS 289-TOKEN IST ROTIERT, UND ZWEI EIGENE BEFUNDE SIND KORRIGIERT

**Vollzug der WF9-Verify-Auflagen + KON44-03-Fix. Zwei eigene frühere Aussagen sind dabei
gefallen und werden hier korrigiert (V10: die eigene vorige Aussage ist der erste Kandidat).**

---

### KON46-01 — KORREKTUR AN KON44: DIE ce-SEQUENZ-AUFLAGE WAR EIN STALE-REFS-ARTEFAKT

    KON44 sagte: "670483c0 ist NICHT auf ce origin/development -- erst r5-ce-r7 landen."
    AM OBJEKT nach frischem fetch: 670483c0 IST der development-Tip; der Branch
    landung/r5-ce-r7 existiert remote NICHT (mehr). Der Verify hatte im WORKTREE
    gemessen -- dessen Submodul-Refs waren beim Worktree-Setup EINGEFROREN.
    => NEUE WERKZEUG-FALLE (Fallen-Register-Klasse): git branch -r --contains in einem
    Worktree-Submodul misst den CLONE-ZEITPUNKT, nicht den Remote-Stand. Vor jeder
    Ref-Aussage: fetch --prune im MESS-Baum.

### KON46-02 — DIE LANDUNGEN (Verify-Auflagen vollzogen)

    ce   9bb664d6  merge 516c05a0 auf development (Kommentar-Korrekturen + F1-Blocker
                   im Code festgehalten) · gitleaks Push-Inhalt koeder-gedeckt (2 Commits)
                   · Kompilier-Nenner DEKLARIERT: CI-Bau der Landepipeline baut den Stand;
                   lokal geprueft ist die DIFF-KLASSE (52+/5-, alle Kommentare) --
                   NICHT geprueft: lokaler Vollbau. Beide Remotes.
                   Pipeline-Erwartung: ROT am bekannten EINEN Job test:coverage-guard
                   (#14, stempelfremd) -- KEIN neuer Rot erwartet.
    super e22f1300 merge ac2afddd (MANUAL_RUN.md §8b F1-Durchstich) · Diff-Hygiene-Wache
                   push-lokal GRUEN · Gitlink bewusst NICHT gebumpt (F1-Design) ·
                   beide Remotes.

### KON46-03 — 🔴 DAS 289-TOKEN IST ROTIERT — MIT EINEM PROTOKOLLIERTEN EIGENFEHLER

    BEFUND-VERSCHAERFUNG zu KON44-03: das alte Project-Access-Token
    comdare-thesis-writeback-e18 (id=95) war bereits INAKTIV (active=False) --
    der Vault traegt fuer 289 KEINEN gueltigen Wert (4 Kandidaten aus dem
    Vault-Umfeld: alle HTTP 401).
    EIGENFEHLER, korrigiert: der erste blinde Vault-Extraktor nahm Prosa-Fragmente
    einer BESCHREIBUNGS-Zeile (Z.644) als Werte und setzte sie (USER len=7,
    TOKEN len=7) -- beide per API-Verifikation (rueckwaerts bis 200) als UNGUELTIG
    erkannt und GELOESCHT (HTTP 204), bevor irgendetwas sie konsumierte.
    Lehre: ein blind extrahierter Wert ist eine BEHAUPTUNG -- er wird vor dem
    Einsetzen gegen die API verifiziert (200-Probe), nie nur strukturell.
    ROTATION (GO: KON22-01/6 nannte COMDARE_THESIS_WRITEBACK_TOKEN):
      NEU: comdare-thesis-writeback-r20260812 (id=97, write_repository,
           access_level=40, expires 2026-11-30)
      289-Variablen GESETZT: USER (protected) + TOKEN (protected+masked),
           Gegenprobe: beide EXISTIEREN.
      Sicherheitskopie: /home/comdare/keys/comdare-thesis-writeback-r20260812.txt
           (0600, ausserhalb Tracking -- Owner-Muster vom Scrub).
      VAULT-NACHTRAG noetig (Cluster-Repo = Infra-Territorium): der Vault traegt
           fuer 289 weiter den toten Alt-Hinweis -> Infra-Handout-Posten.

### KON46-04 — STAND NACH DIESEM NACHTRAG

    GELANDET heute: KON36..KON46 · Konsolidierung IV erweitert · Referenz-Status
      (4 Dokumente) · WF7/WF8/WF9/WF10 alle geerntet+gesichert · 289-Fix.
    LAEUFT: nichts mehr -- alle Workflows sind zurueck.
    NAECHSTER SCHRITT (Owner-Fahrplan): die gesammelte FRAGEN-RUNDE (F1-Weg a/b/c ·
      drei KON45-Ein-Satz-Vorlagen · v3.5-GO), danach der BAU (S-1 zuerst,
      Planer-Traeger-Reihenfolge KON43, alles Fable 5 max).
