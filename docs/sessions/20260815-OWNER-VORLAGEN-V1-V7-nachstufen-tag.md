# OWNER-VORLAGEN V1-V9 (15.08.2026, Nachstufen-Tag)

> Ein-Satz-Entscheide im Gesamtzusammenhang. Nichts davon blockiert die
> laufende Arbeit ausser V2 (S-6-Bau) und V7 (W4-Diagramm-Formen). Quellen je
> Vorlage im Text; Primaerquellen: Ledger KON74-KON76, Sammlung Teile 26-31
> (Folge-BU folgt), Karte tmp/staffelungs_karte_49.json (wf_ec5b9516).
> NACHTRAG 15.08. abends: V8+V9 aus dem #61-Rewrite ergaenzt.

## V1 -- XorFilter (#70): Ruling re-bestaetigen ODER Umbau (vor der naechsten Messreihe)

IST: Defekt REPRODUZIERT -- 30/256 False Negatives, bit-exakt, kein
Verfallsdatum; Reichweite auf die XorFilter-Zelle beschraenkt (W-F,
wf_a2f3387c). Dein Ruling P78 "behalten" + Doku-Pflicht bei JEDER
Messwert-Verwendung (inkl. Thesis/Messbild) steht.

ENTSCHEID: (a) Ruling re-bestaetigen -> ich baue die FN-Ausweisungs-Pflicht
fest in Thesis/Messbild ein; ODER (b) Umbau auf echte Offline-Peeling-
Konstruktion (Graf/Lemire, Build aus vollem Key-Satz analog
build_from_sorted_keys) -> loest die GEPINNT-Zeile (neg==0) kontrolliert aus.

## V2 -- S-6-Klarstellung (#15): ist S-6 baubar? (blockiert S-6b)

IST: Alle Quellen zeigen S-6 seit KON21-03 (12.08.) ENTSPERRT; die
Explore-Pflicht aus KON15-02 gilt als erfuellt (KON20/WF2-Synthese). Der
einzige Gegensatz -- KON60-04 "bleibt UNERFUELLT" (14.08.) -- traegt kein
Owner-Zitat und referenziert die Entsperrung nicht (W-E1: vermutlich stale).

ENTSCHEID: Ein-Satz-Bestaetigung, dass S-6 baubar ist -> S-6b geht sofort in
den Bau; das Bump-Buendel (ABI-Layout 6->7: S-6a-POD + Hybrid-Komposit-Zeile
KON45-01; Format 4->5) faehrt als EIN Bruch zusammen mit #38a2/#38d.

## V3 -- xlsx-Sheet-Namen (V-A9-6, Geschmacksfrage)

IST: Excel begrenzt Sheet-Namen auf 31 Zeichen ohne Sonderzeichen; ein Sheet
je gewaehlter Unter-Achsen-Permutation (Owner-KERN 26.07.).

ENTSCHEID: (A, Default) deterministische Kurzcodes S001..Snnn in bindender
Sortierung Mess-Unter -> System-Unter -> Organ-Unter + Klartext-Legende im
INFO-Sheet; ODER (B) gekuerzte sprechende Namen (kollisionsanfaelliger,
31-Zeichen-Limit erzwingt Abkuerzungs-Schema).

## V4 -- OF-4 konkret (#54): Aktivierung des Rotations-Turnus

IST: Der 30d-Turnus ist GEBAUT und CI-bewiesen (Cluster-Repo, Pipeline 15866
SUCCESS), Schedule id=1 steht A4-konform auf active=false. KERNBEFUND: die
288-Variable traegt den Project-Bot-PAT id=54 (NUR write_repository) --
Blind-Probe /self = HTTP 401: er kann sich NICHT selbst rotieren.

ENTSCHEID (die beim Bau zugesagte Ein-Satz-Rueckbestaetigung): Darf ich
(A1) einen neuen api-scope-Token fuer 288 anlegen, der id=54 abloest,
(A2) ihn als masked Variable ROTATE_TOKEN ans Cluster-Repo 290 haengen und
(A3) den Schedule aktivieren (PUT active=true)? Bis dahin bleibt der Turnus
dormant; A4-Doktrin (Rotation erst bei Pause) bleibt gewahrt -- der Turnus
feuert erst am naechsten Monatsersten 04:00 UTC.

## V5 -- Sidekiq-HPA (aus #73): Values-Frage

IST: Das 10.1.4-Chart legte einen NEUEN Sidekiq-HPA an (Alter 93m vs. 171d
des frueheren; Handout 20260815-HANDOUT-helm-1014-vollzug.md).

ENTSCHEID: HPA behalten (Chart-Default) ODER in den Values auf feste
Replicas pinnen?

## V6 -- Flotten-Handgriffe (Handout C1-C5, nur du kannst sie ausfuehren)

(1) node6 (macOS, lebt): Remote-Login freischalten (Handout C1-C5);
(2) node5 (macOS): physischer Blick (0/4 Proben tot);
(3) Runner id56: Herkunft klaeren; (4) Runner id18: Duplikat entscheiden.

## V7 -- Mess/System in der Auswertung (#49-Karte C1; blockiert W4-Formen)

IST (WIDERSPRUCH UNGELOEST): Dein Wort 06.08. (Ledger:21419): "Geschnitten
wird ueber ZWEI Dimensionen ... (a) Parameter verschiedener Achsen (Organ /
System / Mess) (b) Parameter der Gattungs-/Genus-Funktionsinterfaces" --
Mess/System ausdruecklich als Schnitt-Dimension der Break-Even-Kurven.
DANEBEN der C9-Befund (Nichtfund mit Gegenprobe, KON64-04): Mess-/System-
Achsen haben KEINE eigene Statistik-/Diagrammform; die Statistik lebt an den
ORGAN-Diagrammen (Mess bestimmt CSV-Spalten, System multipliziert die
Permutationsmatrix).

VEREINBARKEITS-LESART (plausibel, aber unbequellt): Mess/System sind
SCHNITT-/GRUPPIERUNGS-PARAMETER der Break-Even-Kurven (jede Kurve wird je
System-Permutation und je Mess-Tooling getrennt gerechnet/gruppiert), aber
die DIAGRAMM-FORM (Heatmap/2D/3D je Achse) haengt ausschliesslich an Organ.

ENTSCHEID: Lesart bestaetigen ODER korrigieren -- vor der Festlegung der
W4-Auswertungs-Formen (Staffelungs-Design, #49-Rest).

## V8 -- SECURITY (aus #61): GitHub-PAT rotieren + Credential-Store bereinigen

IST: ~/.git-credentials traegt eine FEHLGEFORMTE Zeile mit einem GitHub-
Fine-Grained-PAT im USERNAME-Feld; der Wert wurde bei der Push-Fehlerdiagnose
des Rewrites EINMAL im lokalen Agent-Transkript sichtbar (nicht committet;
Transkripte sind tabu und bleiben lokal). Die tote 'x-access-token'-Erstzeile
war zudem die Ursache des 401-Push-Fehlschlags. Der Store bleibt bis zu
deiner Rotation UNANGETASTET, weil die funktionierende super->GitHub-Kette
darueber laeuft.

ENTSCHEID/HANDGRIFF: (1) Diesen GitHub-Fine-Grained-PAT auf github.com
rotieren; (2) danach GO fuer mich, die drei github.com-Zeilen des Stores zu
bereinigen (tote Zeile raus, gueltige Zeile sauber).

## V9 -- Rescue-Ref mit Alt-Trailern (aus #61): belassen oder gleichbehandeln

IST: refs/rescue/w3-thesis-c = b1ec8379 (Seitenlinie 02.08., 337 Commits,
95 Trailer-Zeilen) liegt auf BEIDEN Thesis-Remotes AUSSERHALB von heads/
tags und wurde vom Rewrite nach Backups-additiv-Doktrin bewusst NICHT
erfasst. Solange er steht, bleiben dort Alt-Commits mit Co-Authored-By-
Trailern erreichbar (die Haupt-Historie ist sauber: 0/372).

ENTSCHEID: (a) belassen (Backup-Charakter, Trailer nur in der Seitenlinie)
ODER (b) gleichbehandeln: Bundle-Sicherung + filter-repo + Force-Update des
Refs bzw. Loeschung nach Bundle (braucht dein gegenstands-genaues GO).

## V10 -- 19. Achse vs ORG-18-Kanon (aus #67, dein Commit d2f51ca 14.08.)

IST: Dein Beitraege-Umbau sagt woertlich: "eine optionale neuzehnte Achse
existiert nur, wenn man IO auf eine Festplatte aktiviert und in den
Algorithmus-Entwurf mit einbindet." Der Code-Kanon fuehrt SEIT der
Achtzehner-Korrektur genau 18 Organ-Achsen (T17 persistence_target ist der
18. Slot, In-Memory-gepinnt); die Thesis traegt jetzt deine Fassung
(Rangfolge OWNER > PLAN, Merge statt Verdraengung).

ENTSCHEID: Ist die 19. Achse (a) ein ZUKUENFTIGES Optional (Kanon bleibt 18,
Text beschreibt die Erweiterungsstelle — dann ist NICHTS zu bauen) ODER
(b) ein SOLL fuer den Abgabe-Stand (dann braucht es einen eigenen Design-
Strang am Achsen-Modell, golden-Fenster-nah, NIE beilaeufig)?

## Zur Kenntnis (kein Entscheid noetig)

- Talos-Node-CA-Trust gegen registry.comdare.local ist defekt (x509,
  Pipeline 15865 literal) -- geht als eigener Infra-Posten in die Kette;
  #54-Workaround: explizites Image docker.io/alpine/k8s.
- 06_evaluation_methodology.tex ist seit 02.08. NICHT in die Thesis
  eingebunden (nur Teil-Uebernahme in Kapitel 5) -- wird im Thesis-Sync
  (#67) mit behandelt.
- Wellenplan-Zeile F-07b ("Tabellen statt Diagramme") war ueberholt und
  traegt jetzt einen UEBERHOLT-Marker (ff64fe0e); Diagramme sind Pflicht.
