# SESSION-RESUME 24.08.2026 ~07:30 UTC — Kontingent zurueck, 4 Straenge laufen

Owner-Ordern (24.08. frueh, verbatim-Kerne): "credits sind wieder frisch, bitte
resume alle Agenten und Workflows die noch nicht fertig sind" + Rueckfragen-
Umbau: "auf eine Fable 5 max synthese nur ein Batch von 10 Agenten ... in einer
weiteren Synthese Stufe je Synthese der Vorstufe diese sequentiell gegen
AELTERE Staende vergleichen, weil neuere Informationen, Fragen wie Antworten,
immer den alten schlaegt ... gesammelter neuer Ledger mit filtrierten Owner-
Antworten ohne Worte und Wiederworte ... zum Schluss nur die Fragen uebrig,
die sich aus Kontexten, altem und neuem Ledger nicht beantworten lassen" +
"Die Batch Kondensate sind ja schon fertig, wir koennen sie wiederverwenden" +
kurzes Innehalten + "Bitte fahre fort wie gehabt".

## 1. GESTARTETE STRAENGE (alle Fable 5 max)

| Task | Run | Gegenstand | Stand 07:28 UTC |
|---|---|---|---|
| wmebq6e17 | wf_08c04723-3c0 | W2-ABSCHLUSS-ZUG (#139) Design->Fix->Verify | 3 started/0 results; Design via WIEDERANLAUF auf ARBEITSSTAND.md (R1 fertig, setzt bei R2 an) |
| wpgs23ghr | wf_b546634b-3f5 | LANDE-ZUG Z01-Z27 | 82/16; Z01-Z11 Cache, Z12 findet b3dc3e93 vor (K17-Kombibau+Gates+Push), dann Z13ff |
| w0ipc4ui2 | wf_c37fb077-ef7 | RUECKFRAGEN-SYNTHESE NEU 2-stufig | 12/0 = alle 12 Stufe-1-Batches parallel |
| wuvwuakuf | wf_98cabd77-2a9 | W2-AUDIT Fix-Verify (Rest: ph89 + Synthesen + Gate) | soeben resumed; 118 Schritte aus Cache |

## 2. RUECKFRAGEN-NEUBAU wf_c37fb077 (ersetzt die ueberforderte Ein-Synthese)

Der alte Lauf wf_bce0efd4 bleibt GESTOPPT (Owner 23.08.: "Synthese voellig
ueberfordert"); seine 116 fertigen Opus-Tieflese-Kondensate (~/backups-workflow/
20260823-rueckfragen-vollbild/fenster/, 116 <ID>.md + <ID>-owner-vierquellen.md)
werden WIEDERVERWENDET (Owner-Order) — kein Leser laeuft neu.
Architektur NEU: (Stufe 1) 12 chronologische Batches a max. 10 Fenster
(B01..A61, 06.07.-23.08.; Chronologie aus KARTE.md nach Fenster-Startzeit
sortiert, Lead-verifiziert: 116/116 Dateien vorhanden, fenster-chronologie.json
im Beweisort) -> je EINE Fable-max-Synthese -> Kondensat S1-01..S1-12 unter
~/backups-workflow/20260824-rueckfragen-synthese2/stufe1/ (Sektionen A Owner-
Antworten [neu schlaegt alt batch-intern] / B offene Fragen / C Bestand).
(Stufe 2) SEQUENTIELLER FOLD alt->neu, 12 Schritte: KONSOLIDAT.md wird je
Schritt als vollstaendige neue Fassung geschrieben + Versionskopie je Schritt
(Riss-Schutz); Merge-Regeln: neu ersetzt alt vollstaendig, alte Frage + neue
Antwort -> abgeraeumt, neue Frage + alte Antwort -> direkt beantwortet, keine
Wiederworte. (Finale) Rest-Fragen gezielt gegen ALTEN Ledger (32387 Z., nur
grep+sed, READ-ONLY) und Konsolidat pruefen -> NEUER-LEDGER-konsolidiert-
owner-antworten.md (Sektion 1 geltende Antworten / 2 vorlagefertige Rest-
Fragen / 3 Bestand).

## 3. W2-AUDIT-RESUME-PATCHES (vor Start gesetzt, Script wf_98cabd77)

(a) ph89-DELEGATION: Fix-Stufe baut bei s.key==='ph89' NICHTS selbst — Funde
werden gegen den W2-Abschluss-Zug-Branch bau/w2-abschluss-fixes quittiert
(BEHOBEN mit Commit-Beleg / VERTAGT mit Platz #139) — Ein-Schreiber-Schutz,
kein Doppelbau (R-C-Dedup-Entscheid aus der Pause-Doku: EIN Weg, hier Weg
W2-Abschluss-Zug). (b) ZWEITFASSUNGS-SCHUTZ: SYNTHESE-S1/S2 + GEGENLESE-GATE
vom 23.08. (wf_f3f75b60) werden NIE ueberschrieben — nur additiver DRITT-
ABGLEICH bei Deltas, sonst Rueckgabe DECKT. Cache-Wirkung: nur ph89-Fix- und
Synthese-/Gate-Prompts aendern sich; alle 118 fertigen Schritte bleiben Hits.

## 4. RANDNOTIZEN

- Board-Tools (TaskCreate/Update) aktuell nicht verfuegbar (MCP getrennt) —
  #139-Fortschreibung + evtl. neue Traeger werden NACHGEHOLT, sobald die
  Tools zurueck sind; bis dahin traegt diese Doku.
- ce dev LOKAL b3dc3e93 ungepusht (bewusst): Push kommt aus Lande-Zug-Z12
  nach K17-Kombibau + Gates 6/6 + gitleaks.
- Peers o2-umbau + cifix-vl3-debug: idle/angehalten, unveraendert.

## 5. NACHTRAG ~07:40: Owner-Frage "welche Workflows fehlen/nicht zu Ende gefuehrt"

Vollerhebung ALLER Journale seit 21.08. (22 Runs) + Lebendproben:
LAUFEND (4/4, keiner fehlt): wf_08c04723 W2-ABSCHLUSS = der vermisste
Regressions-Fixer — LEBT (Design-Agent-Transkript 1.26 MB + ARBEITSSTAND.md
7993 B, beide mtime 07:35; Fix-Agenten erscheinen erst NACH der Design-Phase,
daher noch nicht sichtbar) · wf_b546634b Lande-Zug — Z12 faehrt LIVE den
K17-Kombibau (cmake build-dbg -j24, PPID-Kette kombibau-z12-o2std.sh,
Slot2-Claim 21:06Z) · wf_98cabd77 W2-Audit 159/119 waechst · wf_c37fb077
Rueckfragen-2-stufig 12/2 waechst.
GEWOLLT OFFEN (1): wf_bce0efd4 alte Rueckfragen-Synthese 168/117 — Owner-
gestoppt 23.08., ERSETZT durch wf_c37fb077 (116 Kondensate wiederverwendet).
TERMINAL+VERBUCHT (4 der letzten beiden Kontexte): wf_c745729a 9/6 ·
wf_f3f75b60 37/30 · wf_23486ee9 20/10 · wf_bc7303ab 15/13 — Journal-
Differenzen = Riss-NEUSTARTS derselben Schritte (jeder Start zaehlt), kein
offenes Werk; Ergebnisse je voll gelesen+verbucht (Doku 23.08. Abschn. 3/7/8).
AELTER (21.-22.08., 13 Runs): in der Limit-Pruefung 23.08. terminal befundet.
FAZIT: KEIN fehlender Workflow; Differenzmenge LEER.

## 6. NACHTRAG ~08:00: 5/5-Volllesung + 🔴 SONNET-FALLBACK ERKANNT UND GEHEILT

Owner-Order: letzte 5 Sessions/Uebergaben voll einlesen + Referenz-Frage +
"Design immer mit Fable 5 max". VOLLZUG: NACHVERBUCHUNG 328/328 + K30 135/135
neu gelesen; RESUME 81 + PAUSE-2148 83 + REKONSTRUKTION 226 in diesem Fenster
selbst verfasst (Volltext praesent) = 5/5.
ANTWORT: JA — die Referenz ("kleinere Regressionen aus der Gesamt-Landung
verbucht") meint die Posten aus NACHVERBUCHUNG 7a (#135-Workaround-Register) +
9d (ph89 FUND-1/2/3) + 7c (GG2-1/2) + 9c-K (Z11-Restposten); Traeger = W2-
ABSCHLUSS-ZUG wf_08c04723 (#139, Owner-Order 23.08. spaet "ALLE auch kleine
Regressionen ... als Pflicht fuer W2-Abschluss" + "Fixes direkt fahren").

🔴 BEFUND (Owner-Hinweis bestaetigt): Die 07:23-Resumes starteten VOR dem
Owner-/login — Credits-Klemme loeste den AUTOMATISCHEN Modell-Fallback aus:
W2-Abschluss-DESIGNER a01d16b3 fiel nach 3 Fable-Records auf Sonnet 5 (154
Records, 2 Fallback-Marker) und lieferte sein Design-Result (13897 B) als
SONNET — ordnungswidrig (STEMPEL-STRECKE=FABLE-MAX + explizite Design-Order);
der Fix-Fahrer a08d04605b (selbst Fable) lief bereits auf dem Sonnet-Design.
Lande-Zug-Z12-Agent a70a1039e1 ebenso gefallen (4 Fable -> 497 Sonnet, fuhr
den K17-Kombibau auf Sonnet). W2-Audit + Rueckfragen-2stufig (nach /login
gespawnt): rein Fable, nicht betroffen.
HEILUNG: beide Tasks gestoppt (wmebq6e17/wpgs23ghr) -> Design-Prompt-Patch
FABLE-MAX-NEUFAHRT (Cache-Invalidierung; Sonnet-Vorarbeit = 3 additive Commits
fc804971/6400f6dc/0c6ee745 [par.27-Tafel/Designplan/Marker] + ARBEITSSTAND-
Protokoll bleibt ERHALTEN, wird aber vom Fable-Designer selbst voll gegen-
gelesen: eigene 4/4-Kipps, Zeile-fuer-Zeile-Pruefung, additive Korrekturen,
FABLE-MAX-ABNAHME-Commit; Fix+Verify laufen durch die design-Interpolation
automatisch neu) -> Resume beider: wui6xlur8 (W2-Abschluss) + ws7vr0qyt
(Lande-Zug; Z12 ohne result -> laeuft neu, build-dbg inkrementell fortsetzbar).
MODELL-WACHE: neuer Designer a7797062 = 3x claude-fable-5 (0 sonnet) ✅;
Lande-Zug-Agent acc4a569 frisch (Wache folgt). NEBENBEFUND: laufender Bau
PID 1821386 gehoert gitlab-runner (CI-Job) — unangetastet.
LEHRE (Memory-Kandidat nach Wache-2): Workflow-Resumes NIE vor bestaetigt
frischen Credentials/Credits starten; nach jedem Resume MODELL-WACHE am
Agent-Transkript (grep '"model"'), denn der Harness-Fallback ist still+sticky.

## 7. NACHTRAG ~08:25: 🔴 ZWEITER STILLER MODELL-FALL (Fable->Opus) — RECHERCHIERT + GEHEILT

Owner-Meldung: "Fable 5 trotz verfuegbarem Kontingent auf Opus 5 zurueckgefallen,
bitte recherchiere im Web und pruefe das."

MESSUNG AM OBJEKT: Haupt-Session + alle 4 Workflow-Straenge fielen ~07:59:57Z
STUMM von claude-fable-5 auf claude-opus-5 (Transkript-model-Records; KEINE
Fehlermeldung in den Agenten — die 'spend limit'-grep-Treffer waren zitierte
Doku-Inhalte). Nach Owner-/login + /model (08:14) lief die Haupt-Session ab
08:14:29 wieder fable-5; neue Spawns ebenfalls (a04dae 16/16 fable). Die VOR
08:14 gestarteten Agenten blieben sticky auf Opus. KONTAMINIERT (Opus-Anteile):
3 Results im Journal-Cache (W2-Abschluss-DESIGNER 67f/67o · W2-Audit-SYNTHESE-S1
16f/142o · Rueckfragen-FOLD-2 8f/6o) + 3 laufende Agenten (Lande-Zug-Z12
42f/96o · SYNTHESE-S2 17f/110o · FOLD-3 0f/27o). SAUBER: ph89-Fix (85f), alle
12 Stufe-1-Batches, Fold-1, alle Alt-Cache-Schritte.

WEB-RECHERCHE (Kern):
(1) OFFIZIELLE MECHANIK (code.claude.com/docs/model-config): Fable 5 kann je
Plan auf usage credits billen; interaktiv kommt ein CONSENT-PROMPT. In
Background-Sessions/Teammates haelt Claude Code den Prompt fuer dialogExpiry
(5 min Default) — antwortet niemand, wird der Turn OHNE die Anfrage beendet
bzw. mid-session AUF DEM DEFAULT-MODELL (Opus) FORTGESETZT; headless (-p/SDK)
billt ohne zu fragen. Nach "continue on Fable using usage credits" wird die
Wahl GESPEICHERT und der Prompt kommt nie wieder — genau das leistete das
Owner-/model 08:14 ("Draws from usage credits"). Billing-Fehler triggern NIE
die fallbackModel-Chain (nur Overload/Server-Fehler); der Credits-Pfad ist
der Consent-Pfad. Sticky: "After a fallback, the session continues on the
fallback model. To return, run /model."
(2) BEKANNTER BUG anthropics/claude-code#79337: seit 20.07. (Fable standard
auf Max) prueft der Entitlement-Check das Modell-Alias mit literalem
[1m]-Suffix -> Max-Entitlement matcht nie -> "Fable 5 requires usage credits"
+ SILENT DOWNGRADE zu Opus TROTZ verfuegbarem Kontingent (<50% weekly). Issue
geschlossen, Alias-Aufloesungsdefekt-Klasse; Workaround: kein [1m]-Suffix im
gespeicherten model-Wert.
(3) Releasebot: Fix fuer den First-Time-Credits-Prompt, der unter Remote
Control nach 60 s ohne Antwort AUTOMATISCH das Fallback-Modell waehlte.
(4) Abzugrenzen: content-basierter Safety-Fallback (Bio->Opus 5, Cyber->
Opus 4.8) — hier NICHT der Fall (kein classifier-Notice im Transkript).

DIAGNOSE: Unser 07:59:57-Fall = Consent-/Entitlement-Klasse (2)/(1): Die
Workflow-Subagenten (Background, niemand am Terminal) liefen in den Credits-
Consent -> Turn still auf Opus fortgesetzt; sticky bis Stop. Das Owner-/model
mit gespeicherter Credits-Wahl heilt die SPAWN-Seite; laufende Agenten heilt
nur Stop+Neufahrt.

HEILUNG (Muster von heute frueh, 3. Anwendung): alle 4 Tasks gestoppt
(bau-sicher: 0 eigene Bauten; der laufende build gehoerte gitlab-runner) ->
4 GEZIELTE Cache-Invalidierungen: (P1) Designer-Prompt NEUFAHRT-3 · (P2)
Lande-Zug z12neu-Zusatz (b3dc3e93 NICHT neu mergen, Teil-Bauten inkrementell,
ctest frisch, Slot-Claim neu) · (P3) W2-Audit S1/S2/Gate-Neufahrt-Vermerke
(Opus-Vorlauf verworfen, additive Opus-Abschnitte adversarisch pruefen) ·
(P4) Fold-2..12-Neufahrt (Fold-1 + 12 Batches bleiben Cache) -> alle 4
resumed: w52g5xvgc (W2-Abschluss) · wd3iiuv9g (Lande-Zug) · wry7wqnzt
(W2-Audit) · w3kdnx320 (Rueckfragen). MODELL-WACHE: erster Neuspawn
(W2-Audit a5407b69) = fable-5; Rest sekundenfrisch, Wache laeuft mit.
