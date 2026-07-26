# HANDOVER-5 (26.07.2026) — Lager-Gate faktisch KOMPLETT + Giga-Scrub-Verfahren geladen

> Kontext-Ende auf User-Anweisung ("reiche Kontextuebergabe, Kontext endet"). Frist: Mo 27.07.
> = ZWISCHEN-Abgabe (Gruendlichkeit vor Termin, Verzug begruendbar); Voll-Messung 2^17 ab 01.08.
> Rollen: Fable = Architekt/Manager (Abnahme literal), Opus-Agenten implementieren.

## 1. CODE-STAND (alle dual gepusht, main==development auf BEIDEN Remotes)

ce-Kette seit Vendor-Fix: bbd5915a -> f6144859 (Folge-B Mengen-Signatur) -> bb35074d (Folge-A
Objekt-API+LagerKey/ZellKoordinaten) -> f3a6e68d (G4a Director-Scheibe, 8 Punkte) -> **5795fae2
(Fix A Prune-Praefix, LETZTER Commit)**. super: 6006fbab (Gitlink G4a) + Folge-Commit (Gitlink
5795fae2 + dieses Handover). Thesis-Submodul external/20260931-overleaf-diplomarbeit @ ef448e4b.

Pipelines: 12913 (f6144859) SUCCESS terminal · 12914 (bb35074d) lief (Watcher bu8j44fbm) ·
12923 (f3a6e68d Final-Smoke) Ausgang bei Kontext-Ende unbekannt — **SUPERSEDED: die Pipeline
auf 5795fae2 ist der neue autoritative Final-Smoke** (ID beim Resume via API /projects/288
ermitteln; Gruen-Kriterium unveraendert: GESAMTE Pipeline hart gruen).

**Fix A (Kern):** verify_remote_then_prune bildete den Remote-Praefix aus dem nackten
build_version-Parameter ("m3v2"), gepusht wird aber suffigiert (profile_run_entry.hpp:754-758
"+cxx=..+opt=..+ext=..") -> Prune war GARANTIERT wirkungslos (pruned=0, nicht-fatal, unauffaellig).
Fix: prune_key_base liest die LOKALE perm.dll.version neben dem Artefakt (dieselbe Lesung dient
dem Byte-Provenienz-Vergleich); Parameter nur noch Fallback ohne Sidecar; bewusst KEIN Trim
(Zweitwahrheit-Verbot). Beweis: Temp-Revert -> 2 Wachen ROT, Fix -> gruen; ctest 315/315;
Byte-Wachen 296/297 unveraendert gruen (golden-CRC nie aktualisiert).

## 2. NAECHSTE SCHEIBE G4b (Agent steht bereit, NICHT gestartet)

Impl-S6-P2 ist im Working-Tree-FREEZE (Paketmeldung quittiert, Fix A gelandet) und wartet auf:
(a) Smoke-Gruen der 5795fae2-Pipeline, (b) Lifecycle-Wahl. **ENTSCHIEDEN: L1+L2 GENEHMIGT** —
L1 PromiseGuard-Terminalitaet (planer_block-Eintrag wird IMMER terminal geschlossen, auch im
Fehlerpfad) + L2 stabile id (owner_uuid + "/plan/" + doc-Schluessel; kein Wachstum des
Bestandslog-Dokuments um ewig offene Zeilen je Planer-Lauf).

**ZWEI G4b-VORPRUEFUNGS-BEFUNDE (Agent) + MANAGER-ENTSCHEID:**
- Befund 1: --dump-plan (main.cpp:358-363) ist dokumentiert REIN-LESEND (baut nichts, misst
  nichts, exit 0) — dort eine Store-Reservierung zu schreiben gaebe einem Inspektionsbefehl
  Fernwirkung. ENTSCHEID: Reservierung haengt an --emit-tier-ci / --emit-tier-cmake (die Walks,
  die real in einen CEB-Compile muenden); --dump-plan bleibt strikt nebenwirkungsfrei.
- Befund 2: Die Bestandslog-HOST-Verdrahtung existiert nirgends (bestand_doc_key=/transport=/
  key_of=/owner_uuid=/maschine= -> 0 Treffer; bestandslog_active in Produktion IMMER false).
  planer_block allein waere verifizierbar korrekt und trotzdem wirkungslos (Prune-Muster).
  ENTSCHEID: R1 — G4b GEWEITET auf das Paket Host-Verdrahtung (make_bestand_transport aus
  ArtifactCache, key_of via .fingerprint-Sidecar aus I2, doc_key/owner_uuid/maschine aus den
  in G4a geforwardeten Env-Vars) + planer_block-Reservierung mit L1+L2. Bausteine liegen fertig.
Start weiterhin GATED auf Smoke-Gruen der 5795fae2-Pipeline (Task-Zuweisung != Start-Signal).
Falls der Agent den Kontext-Bruch nicht ueberlebt: Neu-Spawn mit exakt diesem Auftrag.

## 3. DANACH: VOLL-BAU-4-TRIGGER (Board #5)

Voraussetzungen (Reihenfolge): Smoke gruen -> G4b gelandet -> DREI Beweise lokal: (1) Resume-
Skip-Beweis (GN_DECISION), (2) Hydration-Smoke mit **verified>0 UND pruned>0** (durch Fix A
jetzt erst sinnvoll pruefbar; behalten=alles bleibt ein Befund, kein gruen), (3) Variant-Gate-
E2E. Rezept: POST /projects/288/pipeline ref=development NUR COMDARE_BUILD_GOLDEN_N=true;
24/24 Worker (amd auf 24 gedrosselt); df-Wachen + Cron-Wache neu armieren. golden N=2^17.

## 4. GIGA-SCRUB (Board #9, aktiver User-Auftrag — Verfahrens-Pflicht)

User-Korrektur (bindend): NICHT per eigener PAT-/Heuristik-Suche scrubben, sondern nach dem
Cluster-dokumentierten Verfahren + Rueckschreiben an den Infra-Agenten ins Cluster-Repo.

**Gelesen:** Cluster docs/sessions/2026-07-22-GIGA-SCRUB-AUSFUEHRUNGS-DOSSIER.md (202 Z., B-
Pipeline 10 Schritte, Welle-4-Protokoll, Zustandsmaschine INVENTORIED..DONE) · 2026-07-25-
DIPLOM-PHASEA-SYNCFIRST.md · 2026-07-23-KALTSTART-RESUME-STATE.md · 2026-07-26-VOLLDELEGATION
(Diplom-Agent macht ALLES selbst; Infra fasst die 4 Repos nicht mehr an; Sync via Doku+Owner).
**NOCH NICHT GELESEN: 2026-07-22-GIGA-SCRUB-FP-WHITELIST.md (161 Z.) — ERSTER Schritt beim
Resume, VOR jedem Scrub-Lauf.**

**Werkzeuge bereit (dieser Session-Beitrag):** kuratierte 233 Regeln (126 Wert + 78 Namen +
6 Token-Regex + 23 Privkey) blind von node7 geholt -> **/home/comdare/.scrub-rules-diplom.txt**
(chmod 600, md5 2ae0ce0e8a1af561936cd1d879ba06a9 == beide node7-Kopien; Inhalt NIE printen/
committen). git-filter-repo: ~/.local/bin/git-filter-repo (prod1).

**Phase-B-Programm (auf der AKTUELLEN Linie — die adoptierte d6c06ef-Nachfolge-Linie IST laut
PHASEA-Doc inhaltlich der Redaktions-Zielzustand; NICHT aus dem Superset neu scrubben):**
je Repo (BASE zuerst planen, Submodule meist Verify-only): (1) Exclusion-Check (Cluster TABU)
-> (2) frischer bare-Clone von gitlab -> (3) Backup git bundle --all persistent (prod1
~/scrub-backups/, chmod 700; Bundles /home/comdare/prescrub-bundles-2026-07-25/ + backup1 NIE
loeschen) + ls-remote-Snapshot beider Remotes -> (4) Pre-Metriken maskiert (NIE printen) ->
(5) git-filter-repo --replace-text RULES --replace-message RULES --prune-empty never --force
PLUS --invert-paths fuer Meta-Pollution: docs/sessions/backups/*/memory-vollexport/,
docs/memory-snapshots/*, wf-*-token*-Dateien (traegt u.a. die schindler-Reste; 2 weitere
schindler-Treffer sind Forschungsdaten-FPs -> Whitelist!) -> (6) HARTES Verify: Commit-Count
identisch, Ref-Menge inkl. Tags identisch, Leak=0 inkl. Messages, Tree-Diff nur REDACTED,
Messdaten-Checksummen unveraendert, AKIA-Regex NIE auf Forschungsarbeiten/** (dokumentierte
FP-Klasse), Scanner = python3-re (sanktioniert), nie stummes grep -P -f -> (7) Force-Push
gitlab (protected main+development: Keeper-API DELETE -> push -> reprotect, trap-gesichert)
-> (8) Force-Push github -> (9) Adoption prod1+node7 (backup-Ref, reset --hard, Verify;
Laptop 99bffb97 -> Owner-Fenster noetig, von prod1 kein Zugang) -> (10) GitLab Repository-
Cleanup (Rails/Web-UI) + Blob-404-Verify -> Ledger. DANACH **Rueckschreibe-Report an den
Infra-Agenten ins Cluster-Repo (gitlab-only, PFLICHT, noch NICHT geschrieben)**.

**FENSTER-EMPFEHLUNG (Dossier §5.2 "nicht mittendrin"):** nach G4b + Smoke, VOR dem Voll-Bau-
4-Trigger — Agenten pausieren, kein Batch laeuft, der Voll-Bau laeuft danach auf der finalen
Linie. Post-Gate-Punkte: Branch-Renames development->dev / main->prod + Apache-Metadaten;
Thesis github/main-Divergenz per MERGE (nie rebase); Thesis-Repo = Remote-only-Rewrite +
Submodul-Pointer-Sync. Offene Owner-Frage: github privat (#187) vs oeffentlich.

## 5. WACHEN / AGENTEN / BOARD

- Watcher bllzyf3vl (12923, redundant nach 5795fae2) · bu8j44fbm (12914) · Cron-Wache
  bpuwq6fyp — beim Resume ALLE neu bewerten und Verwaiste beenden (Zyklusende-Doktrin).
- Agent Impl-S6-P2: FREEZE, G4b-Standby (Auftrag in §2 vollstaendig festgehalten).
- Board (9 Tasks): #4 in_progress (nur noch Smoke-Bestaetigung offen) · #5 Trigger (§3) ·
  #6 Abgabe-Kette (320er USER-GO/manual -> S7 -> G8 -> S8 PDF) · #7 Phase-4 vor 01.08.
  (§65-Vollzug lokal->0-Rueckbau, #54, #47, Runtime-Beweise, Sidecar-Spool-1b-Merkposten) ·
  #8 Band-C (POST-v3, #49, #51, #48-S6, W12, CI-Wartung, Tools-Lager §65b) · #9 Giga-Scrub (§4).

## 6. INVARIANTEN-KOMPAKT (Details: Memory + SECURITY-Block der Vorsession)

Cluster-Repo TABU (nie scrubben/redigieren/github) · Vault nur Blind-Extraktion · NIE rebase ·
Remote-Force nur je-Repo-GO · Messdaten/Doku nie loeschen · Transkripte nie committen · kein
AskUserQuestion · ASCII-Kommentare (§ ok) + Selbstcheck-Zeile je Paketmeldung · Working-Tree-
Freeze nach Paketmeldung · kein Erfolgs-Haken ohne literale Ausgabe · Dual-Remote origin=gitlab.
