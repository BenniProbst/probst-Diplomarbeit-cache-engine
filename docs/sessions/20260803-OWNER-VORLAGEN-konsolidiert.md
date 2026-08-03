# OWNER-VORLAGEN KONSOLIDIERT (03.08.2026) — E-21-VERBOSE, gebündelter Block

> **Zweck:** EIN Dokument mit ALLEN offenen Owner-Vorlagen/-Fragen der laufenden Strecke, je Vorlage in
> E-21-VERBOSE-Form (ID + Kontext + Optionen + Empfehlung + Default) plus „laufender Default" und „was ein
> Veto ändern würde". Dedupliziert gegen bereits Entschiedenes (§B). **Defaults laufen — Einspruch jederzeit;
> KEINE Vorlage blockiert die Arbeit, außer wo ausdrücklich „vor M3-Start" steht (OF-M3-1/OF-M3-2/DV-3-Fenster-Logik).**
>
> **Quellen (alle am Ist gegengeprüft 03.08.):** `docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md` ·
> `docs/sessions/20260802-PAUSE-abbruchsicher-welle2d-auslaufend.md` §5 · `docs/sessions/20260802-PAUSE-abend-abbruchsicher-wellen-neugruendung.md` §4 ·
> `docs/sessions/20260803-DOSSIER-a13-m3-ausfuehrung.md` §6 · `docs/sessions/backups/20260803-*/` (bau-transport-rest.json,
> review-transport-nachbessern.json, truthcheck-nachbesserung-landebereit.json, flag-review-landebereit.json, audit-verdikt.md) ·
> `docs/sessions/20260802-KATALOG-offene-strecke-gesamtplan.md` · Lage-Dossier `backups/20260802-kontext-neugruendung-abend-workflows/00-SYNTHESE-lage-dossier.md`
> (§5.7/§5.19/§5.20/GATE 9/Konflikt 7) · ce `docs/sessions/20260803-ABGLEICH-katalog-gesamtplan-ist-stand.md` ·
> ce `docs/architecture/20260802-hybrid_tier_stufe_soll_design.md` §10 · E-23-Session-Doc · Ledger (read-only gelesen).
>
> **Ist-Anker bei Erstellung:** ce dev lokal `5c1ac257` (Welle 2d GEMERGT: `43a1b65a` Flag + `0d7a0d92` Transport; CI-Wache lief laut
> ABGLEICH-Doc) · super HEAD `927ffd82` (ce-Gitlink noch `7150cc51`, prtart-Gitlink `32e8ffa8`, thesis-Gitlink `b1ec8379`) ·
> `Code/measure_out_d03/` weiterhin untracked.

---

## A. OFFENE VORLAGEN (11 Stück, nach Dringlichkeit)

### A.1 OF-M3-1 — Fingerprint-Preimage härten (Trenner) oder deklariertes Restrisiko?

- **ID:** OF-M3-1 · **Dringlichkeit: VOR M3-Start** (M3 = das EINE Neuanker-Fenster; danach kostet dieselbe Härtung einen ZWEITEN globalen Neuanker über 1.572.864 Binaries). · **Herkunft:** Gesamt-Audit GA-01 [BLOCK] 03.08., am Ist bestätigt (M3-Dossier §1k/§6/§8.1).
- **Kontext:** Der SHA512-Fingerprint — Fundament des SHA512-only-Skip-Gates (F7/GATE 5: „der deckt die anderen Stempel allein") — entsteht heute als reine Byte-Konkatenation von fünf variabel langen Feldern OHNE Trenner/Längenpräfix (`abi/anatomy_fingerprint.hpp:69-79`; Laufzeit-Zwilling `pf/lazy_adhoc_source_gen.hpp:268-275`; Lager-Key-Konsument `bld/bestandslog/bestandslog_index.hpp:99-104`). Literal demonstrierte Kollisionen: `fp("","",X,"") == fp(X,"","","") == fp("",X,"","")` sowie die Ein-Zeichen-Grenzverschiebung `fp("...@1.0.0;","...") == fp("...@1.0.0",";...")` — byte-VERSCHIEDENE Zeilen-Sätze, identischer SHA512. Der LagerKey fängt Zell-übergreifende Kollisionen über die Zell-Koordinaten; INNERHALB einer Zelle bleibt die Mehrdeutigkeit, und die Reachability wächst mit E.0-Merge-Stempeln und Overlay-Scharfschaltung. Keine Injektivitäts-Probe existiert (4 Test-Aufrufe, alle Positiv-Belege; `test_m_w12:814` NUTZT den Kollaps sogar).
- **Option A — Härtung IM M3-Fenster:** Domain-Separator `'\n'` (kommt im Stempel-Zeichenvorrat `=@;.+_[]`+alnum beweisbar nie vor) zwischen ALLE Preimage-Glieder, in allen VIER Rechen-Stellen im SELBEN C3-Commit (Makro-Innenseite, lazy_adhoc_fingerprint_for, bestandslog_index/derive_key, ceb_version_stamp) + neue Injektivitäts-Negativprobe (die drei Demo-Kollisionen müssen VERSCHIEDENE Fingerprints liefern). Aufwand marginal: C3 baut ohnehin alle vier Zwillinge in EINEM Commit um, der Frozen-Testvektor wird ohnehin neu geankert. Risiko: keines über das Fenster hinaus (derselbe eine Neuanker, dieselbe TP1-Neu-Inventarisierung).
- **Option B — bewusstes deklariertes Restrisiko:** Nichts ändern; Nicht-Injektivität als Klausel in Ledger + F7/Gate-Definition („Fingerprint deckt die Zeilen nur für kanonisch gerenderte Sätze"). Aufwand: nur Doku. Risiko: „SHA512-only-Skip" ist formal nicht beweisbar; jede spätere Härtung = zweiter globaler Neuanker + TP1-Neu-Inventarisierung über den vollen Bestand.
- **Empfehlung + laufender DEFAULT: Option A.** Gleicher Preis jetzt, hoher Preis später; die Injektivität ist genau die Eigenschaft, auf der das alleinige Skip-Kriterium ruht. Der C3-Commit-Plan hat A bereits eingeplant (M3-Dossier §3-C3(v)).
- **Was ein Veto (=B) ändern würde:** §3-C3(v) entfällt ersatzlos; die Restrisiko-Klausel geht in den Lande-Ledger-Text + in die A2-Gate-Definition; die Injektivitäts-Probe entfällt; jede spätere Härtung wird als eigenes globales Neuanker-Ereignis budgetiert.

### A.2 OF-M3-2 — Overlay-Definition (S8) im M3-Fenster oder deklarierter zweiter Neuanker?

- **ID:** OF-M3-2 · **Dringlichkeit: vor M3-Start beantworten** (gleiche Termin-Kosten-Logik wie OF-M3-1). · **Herkunft:** M3-Dossier §6 (hochgestuft aus dem früheren DV-2, weil Lage-Dossier **GATE 9** die „S8-Overlay-Definition (3 Owner-Festlegungen)" ausdrücklich „im Golden-Neuanker-Fenster" verortet — ein Default „nach Abgabe" hätte diese Plan-Aussage still superseded; Widersprüche zwischen Plan-Dokumenten werden vorgelegt, nicht per Default wegentschieden).
- **Kontext:** `anatomy_fingerprint.hpp:37-55` — die Overlay-Naht ist GEBAUT (5. Preimage-Glied, `COMDARE_OVERLAY_SOURCE_HASH`-Define, heute ehrlich leer `""`), der Pre-Build-Codegen fehlt (0 Treffer), die DATEIMENGEN-Definition ist ausdrücklich Owner-vorbehalten (`:49-51`): (1) Verzeichnis-Schnitt, (2) Sortier-Ordnung, (3) Hash je Datei vs. Konkatenation = die „3 Owner-Festlegungen". **Termin-Kosten:** das Scharfschalten des Overlay-Glieds ändert JEDEN Fingerprint (leer→gefüllt, unabhängig von OF-M3-1) — nach Voll-Bau-4 ein ZWEITER globaler Neuanker + erneute TP1-Inventarisierung.
- **Option A — im M3-Fenster (GATE-9-konform):** Owner trifft die 3 Festlegungen; schlanker Pre-Build-Codegen nach dem EXISTIERENDEN Muster `COMDARE_GN_ALGO_SIG` (die Naht verlangt genau das, `:40-43`) reicht den Hash als Define herein; Scharfschaltung im selben C3-Neuanker. Aufwand: nur der Codegen. Risiko: Zusatz-Umfang im vollen Fenster (Trigger Do 07.08.).
- **Option B — bewusst NICHT im Fenster:** `COMDARE_OVERLAY_SOURCE_HASH` bleibt `""`; Kosten-Ausweis in Ledger + Gate-Klausel („Overlay-Scharfschaltung = zweiter globaler Neuanker") + vom Owner ratifizierter Supersede-Vermerk zu GATE 9. Aufwand: nur Doku. Risiko: der zweite Neuanker wird nach dem Trigger real teuer.
- **Empfehlung + laufender DEFAULT: Option A, KONDITIONIERT** — Bedingung: die 3 Owner-Festlegungen liegen bis M3-Start vor. **Fallback-Automatik (kein stiller Ausfall):** treffen sie nicht rechtzeitig ein, läuft B — mit explizitem GATE-9-Supersede-Vermerk in der Owner-Vorlage und Kosten-Ausweis im Lande-Ledger-Text.
- **Was ein Veto ändern würde:** Bei aktivem „B sofort" entfällt die Warte-Kondition (M3 startet ohne Overlay-Anteil, Supersede-Vermerk zu GATE 9 wird zur Ratifikation vorgelegt). Bei „A zwingend" OHNE rechtzeitige 3 Festlegungen würde M3 warten — das kollidiert mit der Trigger-Frist Do 07.08. und wäre neu vorzulegen.

### A.3 DV-3 — „v0"-Kurzform-Sentinel im rohen .algos-Signatur-Pfad (Fenster-Logik; = Code-Seite von CX-W13/V4-Teil c)

- **ID:** DV-3 · **Dringlichkeit:** Default läuft; relevant NUR falls der Owner den Rückbau will — dann gehört er ins M3-Fenster (C4). · **Herkunft:** CX-W13 (Codex-Wellen-Review, „owner-vorlagewürdig"), M3-Dossier §3-Abgrenzung + §6-DV-3.
- **Kontext:** Der ROHE .algos-Signatur-Pfad emittiert für versionslose Einträge das Kurzform-Sentinel `"v0"` (`axis_variant_version_table.hpp`, Dossier-Stand fc47c5d9 `:181-185`; Ist 5c1ac257 `:236-240` mit Klartext-Kommentar „HIER bleibt die Kurzform v0 stehen. Dieser Zweig ist die ROHE .algos-Signatur"; gerendert dreistellig byte-neutral `@0.0.0` `:270`). Die Q3-Flag-Grammatik VERBIETET Kurzformen — dieser Zweig ist die eine dokumentierte, bewusste Ausnahme im Sidecar-ROH-Pfad.
- **Option (a) — Zweig bleibt UNANGETASTET** (bewusst dokumentierter Sentinel; gerendert ist alles dreistellig).
- **Option (b) — Rückbau `"v0"` → `"v0.0.0"` im Sidecar-Pfad:** ist ein .algos-Sidecar-BYTE-Ereignis (Skip-/Rebuild-Kaskade) und wird dann in **C4** gebündelt (dasselbe Sidecar-Byte-Ereignis wie die Literal-Migration — Ein-Fenster-Logik). Nach dem Fenster kostet derselbe Rückbau eine EIGENE Sidecar-Kaskade.
- **Empfehlung + laufender DEFAULT: (a)** — mit (b) als vorbereitetem Bündelungs-Platz in C4 (M3-Dossier Startklar-Checkliste Punkt 2 fragt die V4-Antwort explizit ab).
- **Was ein Veto (=b) ändern würde:** C4 wächst um den Sidecar-Rückbau + Test-Pins; Antwort MUSS vor M3-Start vorliegen, sonst läuft (a) und (b) wird nach dem Fenster teuer.

### A.4 CX-W2-Wire-Bump — mengen-genaue Slice-Identität = syntax_version-Bump des Bestandslog-Dokuments?

- **ID:** CX-W2-WIRE · **Dringlichkeit:** Default läuft (gebaut, gelandet in 2d-Merge `0d7a0d92`); Owner-Entscheid nur nötig, wenn die mengen-genaue Form gewollt ist. · **Herkunft:** Welle-2d-Bau (`bau-transport-rest.json` offene_punkte: „OWNER-VORLAGE (CX-W2, gemeldet statt genommen)"), Review VERIFIZIERT (review-transport-nachbessern.json Punkt 3), Code-Kommentar `builder/bestandslog/planer_driven_build.hpp:79-82`.
- **Kontext:** Die Slice-Identität wurde als `(front, size)` geschrieben und war für lücken-behaftete Fenster verlustbehaftet (gappy {0,2} → Intervall {0,1}; fremde Selektion {0,1} enteignete den Claim, Index 2 baute niemand — CX-W2 BLOCK). Gebaut ist die konservativ-korrekte **Spannen-Form** `slice_window_bounds = (min, max-min+1)` OHNE jede Draht-Änderung: das Intervall UMFASST die reale Menge, `scope_covers_slice` bejaht Deckung nur bei Voll-Deckung ⇒ NIE fälschlich released. Für die im Betrieb geschnittenen dichten 4096er-Slices byte-identisch zum Ist. **Bewusst offene Gegenrichtung:** ein Lauf mit der IDENTISCHEN gappy Selektion kann sein eigenes Fenster nicht reapen (die Spanne deckt er nicht) — der Claim läuft dann in die pro-forma-Frist (30 min) und wird regulär übernommen. Eine MENGEN-genaue Reservierung (löst auch die Gegenrichtung) braucht ein zusätzliches Draht-Feld im Bestandslog-Dokument und damit einen **syntax_version-Bump** (heute 3, `bestandslog_document.hpp`) — Wire-/Stempel-Fenster = Owner-Entscheid, bewusst NICHT genommen.
- **Option (a) — Spannen-Form bleibt (kein Bump):** korrekt-konservativ, Betrieb byte-identisch; einzige Kosten = pro-forma-Frist-Umweg im nie auftretenden gappy Eigen-Reap-Fall; Abweichung meldet eine geflushte warn-Zeile (Nie-stumm).
- **Option (b) — mengen-genaue Index-MENGE im Wire:** neues Draht-Feld + syntax_version 3→4; alle Leser/Schreiber + Kompatibilitäts-Entscheid Alt-Dokumente; wäre KEIN reiner Bugfix mehr, sondern ein Wire-Fenster (sinnvoll dann gebündelt mit einem ohnehin fälligen Bestandslog-Wire-Ereignis, nicht solo).
- **Empfehlung + laufender DEFAULT: (a).** Der Betrieb schneidet dichte Slices; (b) kauft für einen heute nicht auftretenden Fall ein Wire-Ereignis vor dem Trigger.
- **Was ein Veto (=b) ändern würde:** eigenes Wire-Fenster einplanen (Bump + Migrations-/Kompat-Regel für bestehende Dokumente + Test-Serie); Termin-Empfehlung dann NACH Trigger bzw. gebündelt mit einem sowieso nötigen Bestandslog-Schema-Ereignis.

### A.5 FUNDSTELLE-B — Mess-Pfad-Stamp-Restrisiko: Umsortierung (fail-closed) oder deklarierte laute Hand-Räumung?

- **ID:** FB-UMSORT · **Dringlichkeit:** Default läuft (gebaut, in 2d-Nachbesserung gelandet); Veto wäre ein bewusster Sicherheits-Trade-off-Wechsel. · **Herkunft:** Welle-2d-Nachbesserung Worker-Punkt 2, Truth-Check LANDEBEREIT (`truthcheck-nachbesserung-landebereit.json` Befund 2 + offene_punkte_bewertung (2)); Geschwister-Kontext review-transport-nachbessern.json „NICHT-BLOCKIEREND / FOLGE-KANDIDAT" (`iterator:1755`, jetzt gefixt als Z-01/GA-02-Klasse).
- **Kontext:** Im MESS-Pfad (`cache_engine_builder_iterator.hpp:1802-1821`, Stand Worktree/2d): schlägt das Entfernen von `result.csv.stamp` fehl, wird das JETZT laut gemeldet (klassifizierte, geflushte `[Infra-Fehler: artefakt_io]`-Zeile mit Hand-Räumungs-Pflicht) — aber die frischen Messzeilen werden GESCHRIEBEN (keine Umsortierung auf fail-closed). **Restrisiko (im Code selbst dokumentiert `:1802-1805`):** ein liegengebliebener Alt-Stamp kann bei ZUFÄLLIG gleichem Konfig-Präfix UND gleicher Zeilenzahl einen unzertifizierbaren Frisch-Stand dem Folgelauf als Resume zertifizieren. Erreichbar NUR nach der lauten Fehler-Zeile; vorbestehende Risikoklasse, vom Commit von lautlos auf sichtbar gehoben. **Warum NICHT umsortiert wurde (Review-verifizierte Abwägung):** fail-closed hätte bei Stamp-Entfern-Fehler die ALTE stale `result.csv` im Transport gelassen — `measurement_sink` (`:1837-1841`) prüft nur `exists(rcsv)` und würde sie als measure-drop DIESES Laufs labeln, `mess_pfad_synchron_push` (`:1835`) den Alt-Zustand pushen = das SCHLIMMERE Stale-als-frisch-Transportrisiko. Asymmetrie zum Bau-Zweig ist prinzipiell: dort ersetzt nur ein Marker echte Daten (Verlust), hier ersetzen frische echte Messzeilen einer real gebauten Binary einen überholten Stand (replace-Semantik).
- **Option (a) — Ist-Stand behalten:** laute klassifizierte Meldung + Hand-Räumungs-Pflicht + deklariertes Restrisiko (Truth-Check: „strikte Verbesserung, kein Blocker", KLEIN).
- **Option (b) — fail-closed-Umsortierung:** kein Frisch-Write unter nicht invalidierbarer Marke — erkauft mit dem oben belegten Stale-als-frisch-Transportrisiko; vom Review explizit als die schlechtere Richtung bewertet.
- **Option (c) — Zusatz-Härtung statt Umsortierung (Folge-Welle):** Präfix+rows-Vergleich um eine Frische-/Nonce-Komponente im Stamp erweitern (macht die Zufalls-Kollision unmöglich) — kein Fenster-Zwang, Kandidaten-Liste.
- **Empfehlung + laufender DEFAULT: (a)**, mit (c) als Folge-Kandidat auf der Aufräum-/Härtungs-Liste (zusammen mit der bereits notierten Mess-Pfad-Testlücke `:1812` und dem Stamp-Write-flush/good-Check `:1790`).
- **Was ein Veto (=b) ändern würde:** Umbau des Mess-Fehler-Zweigs + neue Testfälle + AUSDRÜCKLICHE Owner-Abnahme des dann eingekauften Stale-als-frisch-Risikos am measurement_sink (das wäre eine Verschlechterung der Daten-Wahrheit und würde von uns mit Gegenempfehlung neu vorgelegt).

### A.6 V3 — E-24-Fenster-Sequenz (Bündelung mit A13-M3 oder eigenes Fenster?)

- **ID:** V3 · **Dringlichkeit:** Entscheid muss VOR dem M3-Bau-Start fallen, weil er den M3-Fenster-Zuschnitt bestimmt; Default läuft. · **Herkunft:** Lage-Dossier §5.7/Konflikt 7 + GATE 4 (HY-D2-Merksatz), PAUSE-abend §4-V3, M3-Dossier §3-Einordnung (F6) + Risiko R15.
- **Kontext:** E-24 (Container-Gattung, Cross-Genus-Komposition via OrganConcept) ist der **LETZTE ABI-Schritt VOR dem Voll-Bau-4-Trigger** — harte Kante aus HY-D2: bumpt der Major erst NACH dem Voll-Bau, lädt die Hybrid-Stufe die eingelagerten Binaries nicht mehr (Major-Check im Loader) = Neubau ALLER Binaries, exakt der von Owner-E3 ausgeschlossene Zustand. Offen ist die SEQUENZ: E-24 mit dem A13-M3-Neuanker in EIN Fenster bündeln (Ein-Fenster-Doktrin: ein Byte-/Neuanker-Ereignis) oder als eigenes Fenster NACH M3+W10 fahren (zwei getrennte Ereignisse, aber kleinere, beherrschbare Fenster vor der Frist). Kanonische Reihenfolge laut Bauplan/Lage-Dossier: A13(M3/M4) → W10-Zellwerte → E-24 → **A2-Gate-Eichung EINMALIG ZULETZT** (GATE 5: „einmalige Eichung nach A13/E-24" — die Eichung passiert in BEIDEN Optionen genau einmal, nach dem letzten Shift).
- **Option (a) — Bündeln (E-24 in das M3-Fenster):** ein einziges Neuanker-/ABI-Ereignis, eine TP1-Inventur; ABER das M3-Fenster wächst erheblich (E-24 ist ein eigenes S12-ABI-Paket) — Frist-Risiko vor Do 07.08.; die ältere Empfehlung (PAUSE-abend, vor dem M3-Dossier v4) lautete so.
- **Option (b) — Getrennte Fenster (M3 jetzt, E-24 nach W10 als eigener letzter ABI-Schritt):** M3 bleibt wie im auditierten Dossier beauftragt (C1-C5 unverändert); W10 und E-24 sind ohnehin zwei WEITERE Byte-/ABI-Ereignisse nach M3 — der „eine Neuanker"-Anspruch gilt fürs STEMPEL-System (M3), E-24 ist ein ABI-Major-Ereignis anderer Klasse; A2 wird erst nach W10+E-24 geeicht, die FINALE TP1-Inventur zählt erst nach dem letzten Shift (R15-Entschärfung).
- **Empfehlung + laufender DEFAULT: (b).** Das audit-geprüfte M3-Dossier v4 plant M3 OHNE E-24-Bündelung; fällt der Entscheid auf (a), wächst das Fenster um das E-24-Paket, OHNE dass sich C1-C5 ändern (explizit so vorbereitet). (b) hält den kritischen Pfad vor Do 07.08. schneidbar und vermeidet ein Monster-Fenster; der Doktrin-Kern (A2 nur EINMAL eichen, E-24 zwingend VOR Trigger) ist in beiden Optionen gewahrt.
- **Was ein Veto (=a) ändern würde:** M3-Fenster wächst um das komplette E-24-Paket (A16-P1-Design als Vorbedingung in den M3-Vorlauf gezogen); Zeitplan bis Do 07.08. müsste neu gerechnet und ggf. neu vorgelegt werden.

### A.7 V4 — Q&A-Reste + E-23-GOs + CX-W13 + Hybrid-Stempel-Kennzeichen (Sammel-Vorlage, 8 Teilpunkte)

- **ID:** V4 · **Dringlichkeit:** überwiegend NUR-KENNTNIS/Quittung; einzig (c) hat Fenster-Logik (= DV-3) und (f1) ist Migrations-Blocker der (nach-Abgabe-)Modul-Migration. · **Herkunft:** Lage-Dossier §5.20, PAUSE-abend §4-V4, E-23-Session-Doc, Hybrid-Design-Doc §10.

**(a) Flag-Grammatik-Randform `vX.Y.Ze` (e OHNE Hardware-Flag) = Sentinel — Bestätigung erbeten.**
Kontext: Owner-Q3 definiert „Hardware-Flag zuerst, dann optional e". Implementiert (A13-M1b, CX-W6-Review bestätigt): `v1.0.0e` ist grammatisch unparsbar/Sentinel — „'e' nur NACH HW-Flag zulässig, bricht so oder so" (CT-Wache, Negativ-Probe reproduziert). Laufender Default: Sentinel/hart. Veto (e allein zulässig) = Grammatik-Änderung + Parser/Wachen/Migration — würde als eigenes Paket neu vorgelegt.

**(b) `os_declaration_source`-Attributname — Quittung erbeten.**
Kontext: `<machine os_declaration_source=..>` ist die Herkunfts-Notiz der drei deklarierten OS-Unter-Achsen-Werte im ERWARTUNGS-Kanal (`xml_config_parser.hpp:386`; Ledger-Nachtrag A14/OS-U2: Erwartung, nicht Werte-Quelle — Werte werden je Lauf erhoben). Laufender Default: Name bleibt. Veto = Rename im XSD+Parser (klein, vor OS-U4 am billigsten).

**(c) CX-W13 „v0"-Kurzform im .algos-ROH-Pfad** — siehe **A.3 DV-3** (dieselbe Sache; dort die Fenster-Logik). Laufender Default: (a) unangetastet.

**(d) Hybrid-Stempel-Kennzeichen (Frage 3 des Hybrid-Design-Docs, NICHT Teil von Q6):**
Kontext: bekommt die Hybrid-Binary im System-Stempel-Array ein EIGENES Kennzeichen (hybrid-Flag/Version) oder bleibt die Hybrid-Natur ausschließlich im Sidecar-Manifest? (`hybrid_tier_stufe_soll_design.md:432-434`; „klein, nach A13 entscheidbar; hängt an K1 = Lager-Identität der Hybrid-.so — solange K1 offen, darf KEIN Lager-Schema Hybrid-Knoten annehmen"). Laufender Default: Sidecar-only, KEIN Stempel-Kennzeichen (golden-neutral; Dock-Bestückung = Sidecar, nie binary_id); Entscheid wird erst mit K1 zur Auswertungsphase/Hybrid-Bau bindend. Veto (eigenes Stempel-Kennzeichen) = Stempel-Byte-Ereignis für Hybrid-Artefakte → müsste in ein deklariertes Fenster (nicht M3; Hybrid-Bau ist Auswertungsphase).

**(e) Hybrid-Randfragen 4+5 aus dem Design-Doc (NUR-KENNTNIS mit Default):**
(4) Verdrängungs-Heuristik-Shortlist (LRU/LFU/ARC/GDSF/cost-aware, §49-Recherche) — Default: Zeitpunkt Auswertungsphase (HY-B2); Veto = vorziehen. (5) Plattform-Querschnitt RISC-V/macOS: `platform_suffix()` des Loaders kennt `.dylib` bereits — Default: bestehende Loader-Fläche reicht, Hybrid-Stufe wird doku-seitig in die E-19-Plattform-Matrix aufgenommen; Veto = expliziter Hybrid-Plattform-Ausbau jetzt.

**(f) E-23-GOs (drei Freigaben aus dem GitLab-API-Suchlauf; read-only erhoben, KEINE Remote-Änderung erfolgt):**
**(f1) D-2/D-3-Branch-Doktrin [MIGRATIONS-BLOCKER]:** alle vier Mess-Projekte haben Default `main`, Konvention (GOALV2-Q5/LEDGER Schritt-0) verlangt `development`; `comdare-metrics` (76) ist zusätzlich 12 Tage divergent (development f7cd5b9c 19.07. vs main a7c50932 07.07.) — jeder API-typische Default-Branch-Read zöge den ALTEN Stand. Optionen: Default überall auf `development` umstellen + Divergenz per merge (nie rebase) auflösen — ODER Konvention formal auf `main` nachziehen. Empfehlung + Default: Erstere; bis zum Entscheid liest KEIN automatisierter Migrations-Schritt den Default-Branch (so bereits verankert). Veto (=main-Konvention) = Ledger-/Doku-Nachzug der Konvention.
**(f2) Sperr-Etiketten 293-298:** 296 trägt den Tombstone-Kopf bereits; 293/294/295/297/298 fehlen. Empfehlung + Default: denselben Kopf additiv nachziehen (doku-only, KEIN Löschen — Remote-Löschung nur mit explizitem Owner-GO). Freigabe erbeten; Veto = stehen lassen wie ist.
**(f3) b3-analysis-Zelle:** Namens-Vorschlag `comdare-analysis` + Remote-Anlage-GO für Gruppe und Projekt. Default: NICHTS wird angelegt bis GO (Remote-Neuanlage = Owner-Gate). Veto/Alternative = anderer Name oder Verzicht.

**(g) `ceb_legende`-Mengenform bei 0/>1 Kombinationen — Präzisierung erbeten.**
Kontext: `ceb_legende` trägt die `[a,b,c]`-Mess-Kombinatorik der emittierenden CEB-Strecke (`bestandslog_document.hpp:43/:78/:224`; leer = nicht gemeldet). Offen ist die kanonische Form, wenn die Strecke 0 bzw. MEHR ALS EINE Kombination fährt (Hybrid-/Tooling-Mengen): Attribut leer lassen (0) und Mengen-Schreibweise `[[a,b,c],[d,e,f]]` (>1) — analog zur Stempel-Doktrin `[[d,e,f],[g,h,i]]Tier` — oder je Kombination eine eigene Zeile. Laufender Default: Ist-Verhalten (genau eine Kombination je Eintrag; leer = nicht gemeldet) bleibt, bis der >1-Fall real gebaut wird (Hybrid = Auswertungsphase). Veto/Festlegung jetzt = kostenfreie Doku-Festlegung, die der Hybrid-Bau später einlöst (KEIN Wire-Ereignis heute).

**(h) Owner-Bestätigung Ein-Gattung-Hybrid + MaxN=8:** bereits per Owner-GO ~17:4x (Q6-Default) ENTSCHIEDEN — hier nur als Quittungs-Hinweis gelistet, siehe §B.

### A.8 V5 — prtart-Gitlink in super: `32e8ffa8` → `c4735d2` nachziehen oder bewusst alt?

- **ID:** V5 · **Dringlichkeit:** niedrig, aber jede Inventur stolpert darüber; 4-Klone-Regel (inkl. Overleaf-Klon) berührt. · **Herkunft:** Lage-Dossier §5.19, PAUSE-abend §4-V5, ZWISCHENSTAND §7.
- **Kontext (Ist verifiziert 03.08.):** super trägt den prtart-Gitlink auf `32e8ffa8` (`git ls-files -s` literal), prtart selbst steht auf main==dev==`c4735d2` (E-02-Ledger + LICENSE Apache + Review-Fixup — alles kanon-tragende Inhalte). `32e8ffa8` ist zugleich der prt-art-Anker der „Finalen Linie" nach Infra-Scrub 26.07. (Memory/Lage-Dossier) — daher die ehrliche Frage: bewusster Pin oder schlicht nie gebumpt (Vor-E02)?
- **Option (a) — Nachziehen auf `c4735d2`:** im nächsten regulären super-Gitlink-Fenster (mit ce-/thesis-Bumps bündeln, EIN Commit, CI-begleitet); bringt Apache-LICENSE + prtart-Ledger in die super-Sicht; 4-Klone-Regel wieder deckungsgleich.
- **Option (b) — bewusst alt lassen:** dann PFLICHT: dokumentierter Pin-Vermerk (Ledger + Kommentar), sonst meldet jede künftige Inventur denselben „Drift".
- **Empfehlung: (a).** **Laufender Default bis zur Antwort: Gitlink bleibt UNANGETASTET** (kein stiller Bump — Gitlink-Bumps laufen nur als Teil dokumentierter Lande-Sequenzen).
- **Was ein Veto (=b) ändern würde:** nur Doku (Pin-Vermerk); die prtart-Inhalte blieben aus super-Sicht auf Vor-E02-Stand — E-02-Vollzug (Vier-Ledger-Struktur) wäre aus super-Sicht weiterhin unsichtbar, was die A16/E-02-Abnahme berührt.

### A.9 V6 — `Code/measure_out_d03/` (untracked Messdaten in super): Disposition

- **ID:** V6 · **Dringlichkeit:** niedrig; reine Hygiene-/Sichtbarkeits-Frage, Messdaten-Doktrin gilt ohnehin. · **Herkunft:** Lage-Dossier §5.23 (dort Nr. 23/„§5.22-23"-Block), PAUSE-abend §4-V6.
- **Kontext (Ist verifiziert 03.08.):** `Code/measure_out_d03/` liegt weiterhin untracked im super-Working-Tree (`?? Code/measure_out_d03/`). Es sind Messdaten (nie löschen — Doktrin). Die KANONISCHEN Kopien derselben Daten liegen getrackt unter `measurement/20260726-164259-d03/`.
- **Option (a) — behalten-untracked (nichts tun):** die `??`-Zeile bleibt als sichtbare Erinnerung in `git status`; kein Byte bewegt sich; Null-Risiko.
- **Option (b) — `.gitignore`-Eintrag:** status wird sauber; Risiko: der Ordner verschwindet aus jeder Sichtbarkeit und ein späterer Aufräum-Reflex könnte ihn für entbehrlich halten (die Doktrin schützt ihn, aber Sichtbarkeit ist die bessere Wache).
- **Option (c) — zusätzlich tracken/committen:** Duplikat zur kanonischen `measurement/`-Ablage — widerspricht der Ein-Ablage-Ordnung; nicht empfohlen.
- **Empfehlung + laufender DEFAULT: (a)** behalten-untracked; bei Gelegenheit ein README-Einzeiler IM Ordner („Archiv-Duplikat; kanonisch: measurement/20260726-164259-d03/"), der ist additiv und doku-konform.
- **Was ein Veto ändern würde:** (b) = eine .gitignore-Zeile (Lead-Commit); (c) = Commit der Rohdaten als bewusste Zweit-Ablage — bitte nur mit ausdrücklicher Begründung.

### A.10 #327 — PAT-Rotation: Status (NUR-KENNTNIS; Entscheid liegt vor, Vollzug terminiert)

- **ID:** #327-STATUS · **Art: NUR-KENNTNIS** (kein neuer Entscheid nötig; gelistet, weil §G.5/Ledger den Punkt seit 20.07. als „dem User vorgelegt" führte). · **Herkunft:** Owner-E5 02.08. („Bitte nach Messfenster rotieren und bitte handout an infra"), KATALOG H.5, ABGLEICH-Doc D-Zeile.
- **Stand:** ENTSCHIEDEN: Rotation NACH dem Messfenster; das Infra-Handout ist RAUS (PAUSE-mittagsstand 02.08.: „Handouts ... PAT-Rotation-nach-Messfenster gepusht"). Vollzug liegt bei Infra nach Messfenster-Ende; bis dahin bleibt der exponierte Vault-PAT bewusst aktiv (Rotation vorher bräche den API-Zugang der laufenden Orchestrierung — genau deshalb der Owner-Termin).
- **Laufender Default:** warten bis Messfenster-Ende, dann Rotations-Signal an Infra; NACH der Rotation gilt unsere PAT-FALLE-Doktrin (Kandidaten RÜCKWÄRTS gegen die API testen bis HTTP 200; Position im Vault rotiert, nie hartcodieren).
- **Was ein Veto ändern würde:** „sofort rotieren" = geplanter API-Ausfall unserer CI-/Inventur-Automatik bis zur Neu-Extraktion — machbar, aber nur koordiniert mit einem ruhigen Fenster; bitte dann explizit anweisen.

### A.11 Z-02-Wegwahl — Klammer-Grammatik-Härtung: nur zur Kenntnis (Lead-/Review-Entscheid, KEIN Owner-Gate)

- **ID:** Z02-INFO · **Art: NUR-KENNTNIS** (im M3-Dossier ausdrücklich als „Lead-/Review-Entscheid, kein Owner-Gate" klassifiziert; hier gelistet, damit der Block vollständig ist und ein Owner-Einspruch JETZT noch billig wäre).
- **Kontext:** Gruppen-Grenzen-Kollision der Klammer-Grammatik (`];[` vs `;` in der Gruppe ⇒ identisches Entry-Array). Default = Weg (i) Grammatik-Verschärfung F6 als M3a-Commit C2b (CT-only, byte-neutral, Q1-konform: die Klammer-ANZAHL kodiert die Ebene, nicht die Gruppen-Partitionierung). Alternative (ii) = Gruppen-Bits in die Entry-POD-reserved-Bits → POD-Semantik-Ereignis, dann zwingend C3.
- **Veto-Wirkung:** (ii) verschöbe den Punkt ins C3-Byte-Fenster und verbrauchte reserved-Bits — nur auf ausdrücklichen Wunsch.

---

## B. DEDUPLIZIERT: BEREITS ENTSCHIEDEN / ERLEDIGT (nicht mehr vorlegen)

| Alt-ID | Gegenstand | Status + Beleg |
|---|---|---|
| **V1 (F-B10)** | result.csv bei Bau-Fehler | ERLEDIGT in 2b: Default (b) `result.csv.stale` GEBAUT + gelandet (Ledger :3644, Commits 1d5530c0+46d8b112) |
| **V2 (F-WAISEN)** | 8 unregistrierte Test-TUs | ERLEDIGT in 2b: Default (b) — halbordnung-TU gefixt+registriert (327-Testzahl), Rest auf Aufräumpass-Liste (Ledger :3634/:3637) |
| **Q-M3-GATE** | Review-Gate vor M3 | ENTSCHIEDEN (Owner ~21:2x, „wie empfohlen"): (a) Codex auf funktionierender Umgebung, sonst (b) Fable-xhigh-Adversarial MIT Ledger-Vermerk; (c) Verschiebung ausgeschlossen |
| **Q1/Q2/Q3/Q10** | Klammer-Form / e+Namens-Muster / Flag-Grammatik / v-Präfix-Rendering | ENTSCHIEDEN (Owner-Nachträge ~12:1x/~17:0x/~19:5x im OWNER-Doc; M1b/M2 gebaut; gerendert bleibt `@X.Y.Zc`) |
| **Q4-Q9-Defaults** | CSV-Token, E-24-ein-Fenster-Rahmen, Ein-Gattung-Hybrid+MaxN=8, PRUEF-TESTAT, RT-Erhebung, thesis-Ledger | FREIGEGEBEN per Owner-GO ~17:4x („volles Go für ALLE geplante offene Arbeit wie vorgegeben") — Abweichungen von Empfehlungen würden erneut vorgelegt |
| **Hybrid Q6-Teile (Kardinalität, MaxN)** | Ein Hybrid je Gattung; Default-MaxN=8 | ENTSCHIEDEN via Q6-GO; im Design-Doc §10 als ENTSCHIEDEN geführt (CX-W7-Doku-Nachzug fc47c5d9, in 2d-Landung enthalten). OFFEN bleibt NUR das Stempel-Kennzeichen → V4(d) |
| **DV-1 (merge-Code sofort raus)** | Entfernung statt Deprecation in C3 | Default (a) läuft, im OWNER-GO-Rahmen gedeckt (Owner-E2 „darf nicht existieren" ist eine Existenz-Aussage); kein neuer Vorlage-Bedarf |
| **C3-Rang-3-Framing** | K5-„Plattformen der Rang-3-Hardware-Arbeiten" schärfen | ERLEDIGT: Owner-E4-GO erteilt; K5-Text steht am Ist auf „eigene Produktions-Zielmaschinen (Ryzen 9 9950X3D, Intel Core i9-12900K) sowie eine HBM-Plattform" (kapitel/de+en/05, gelandet 33185f0/b1ec837; Alt-Formulierung 0 grep-Treffer). REST ist KEINE Owner-Frage: RISC-V/macOS-Nachzug in die Thesis erst „wenn real im Bestand" (Owner-E4-Auslegung) — gated, getrackt im Plattform-Querschnitt |
| **Q8 (OS-U3 Laufzeit-Lesart)** | statisch vs. Laufzeit-Erhebung | NUR-KENNTNIS war zugestellt, kein Einspruch; VOLLZOGEN in der Laufzeit-Lesart (Ledger :3650) |
| **Fundstelle-B-Geschwister `iterator:1755`** | Mess-Pfad remove mit wiederverwendetem ec | GEFIXT als Z-01/GA-02-Klasse (2f12e874, Truth-Check verifiziert (b)) — nicht mehr offen |

---

## C. EINFÜGE-FERTIGE LEDGER-TEXTE (Lead-only; ich editiere das Ledger NICHT)

**Ziel-Ort:** `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` — ANS DATEIENDE, d. h. direkt NACH Zeile 3652
(letzte Zeile des Blocks „NACHTRAG 02.08.2026 spätabends (Welle 3 OS-U3 gelandet ...)"), als NEUER Abschnitt:

```markdown
## NACHTRAG 03.08.2026 (Owner-Vorlagen-Block konsolidiert; Defaults laufen, Einspruch jederzeit)

- OWNER-VORLAGEN KONSOLIDIERT (11 offene, E-21-verbose): OF-M3-1 Preimage-Trenner (DEFAULT A: '\n'-Separator im C3-Commit + Injektivitäts-Negativprobe), OF-M3-2 Overlay/GATE-9 (DEFAULT A konditioniert; ohne 3 Owner-Festlegungen bis M3-Start läuft B mit GATE-9-Supersede-Vermerk), DV-3 v0-Sidecar-Sentinel (DEFAULT unangetastet; Rückbau nur via V4-Antwort, dann C4-gebündelt), CX-W2-Wire (DEFAULT Spannen-Form OHNE syntax_version-Bump; mengen-genaue Slice-Identität = Owner-Wire-Fenster), Fundstelle-B (DEFAULT laute artefakt_io-Meldung + Hand-Räumung statt fail-closed-Umsortierung — Review-belegt die sicherere Richtung), V3 E-24-Sequenz (DEFAULT getrennte Fenster M3→W10→E-24, A2-Eichung EINMALIG zuletzt; Bündelung wäre C1-C5-neutral möglich), V4-Sammel (vX.Y.Ze-Sentinel bestätigen, os_declaration_source quittieren, Hybrid-Stempel-Kennzeichen DEFAULT Sidecar-only, E-23-GOs: D-2/D-3-Branch-Doktrin [Migrations-Blocker], Sperr-Etiketten 293-298, b3-analysis-Anlage, ceb_legende-Mengenform), V5 prtart-Gitlink (DEFAULT unangetastet; Empfehlung Bump auf c4735d2 im nächsten Gitlink-Fenster), V6 measure_out_d03 (DEFAULT behalten-untracked), #327 NUR-KENNTNIS (Rotation nach Messfenster, Handout liegt), Z-02-Wegwahl NUR-KENNTNIS (Weg (i) F6-Grammatik als M3a). Volltext: Scratchpad-Paket owner-vorlagen-konsolidiert.md des Nachzugs-Pakets; nach Versand als Session-Doc committen.
- DEDUPE-VERMERK: V1/V2 sind in Welle 2b VOLLZOGEN (result.csv.stale; Waisen-TU halbordnung), Q-M3-GATE + Q1/Q2/Q3/Q10 + Q4-Q9-Defaults + Hybrid-Q6 (Ein-Gattung, MaxN=8) sind Owner-entschieden, C3-Rang-3-Framing ist am Thesis-Ist gelandet (Zielmaschinen+HBM-Form, b1ec837) — diese Punkte werden NICHT erneut vorgelegt.
```

**Hinweis Ziel-Zeile:** „nach :3652" gilt für den gelesenen Stand; falls der Lead zwischenzeitlich Nachträge angehängt hat, sinngemäß ans aktuelle Dateiende (die NACHTRAG-Blöcke sind chronologisch additiv).

---

## D. VERSANDFERTIGE KURZFASSUNG FÜR DEN OWNER (eine Nachricht, ARBEITSAUFTRAG-frei, NUR Entscheid-Bedarf)

> **Owner-Vorlagen-Block (Defaults laufen; nur bei Veto antworten — Nummern reichen):**
> 1. **OF-M3-1** Fingerprint-Trenner im M3-Fenster (Default: JA, '\n'-Härtung — sonst ist das SHA512-Skip-Gate formal nicht beweisbar; später = zweiter globaler Neuanker über 1,57 Mio Binaries).
> 2. **OF-M3-2** Overlay-Dateimenge: deine 3 Festlegungen (Verzeichnis-Schnitt, Sortier-Ordnung, Hash-je-Datei-vs-Konkatenation) BIS M3-Start = wir schalten im selben Fenster scharf; sonst läuft Option B (leer lassen + dokumentierter zweiter-Neuanker-Kostenausweis).
> 3. **DV-3/CX-W13** „v0"-Sentinel im rohen .algos-Pfad: Default bleibt stehen; willst du den Rückbau auf „v0.0.0", sag es VOR M3 (dann bündeln wir es in den Migrations-Commit, danach kostet es eine eigene Sidecar-Kaskade).
> 4. **CX-W2** Slice-Identität: Default = konservative Spannen-Form ohne Wire-Bump (Betrieb byte-identisch). Mengen-genaue Form nur auf deinen Wunsch (= syntax_version-Bump-Fenster).
> 5. **Fundstelle B** (Mess-Pfad-Stamp): Default = laute Fehler-Zeile + Hand-Räumung statt fail-closed (fail-closed hätte das schlimmere Stale-als-frisch-Transportrisiko).
> 6. **V3** E-24-Sequenz: Default = eigenes Fenster NACH M3+W10 (A2-Eichung einmalig zuletzt); Bündelung mit M3 möglich, macht das Fenster vor Do 07.08. groß.
> 7. **V4** Quittungen: (a) `vX.Y.Ze` ohne HW-Flag bleibt Sentinel; (b) Attributname `os_declaration_source` ok?; (d) Hybrid-Natur NUR im Sidecar, kein Stempel-Kennzeichen (Default); (g) `ceb_legende` bei >1 Kombinationen als `[[..],[..]]`-Mengenform, bei 0 leer — ok?
> 8. **E-23-GOs:** (f1) Default-Branch der Mess-Zellen auf `development` umstellen + comdare-metrics-Divergenz per merge auflösen (GO?); (f2) Tombstone-Kopf auf 293/294/295/297/298 nachziehen (GO?); (f3) b3-analysis-Zelle als `comdare-analysis` remote anlegen (GO?).
> 9. **V5** super-prtart-Gitlink: auf `c4735d2` nachziehen (Empfehlung) oder bewusst auf `32e8ffa8` gepinnt lassen?
> 10. **V6** `Code/measure_out_d03/`: bleibt untracked liegen (Default) — ok?
> 11. **#327** NUR-KENNTNIS: PAT-Rotation nach Messfenster ist bei Infra beauftragt (Handout liegt); Vollzug folgt nach Messfenster-Ende.

---
## NACHTRAG 03.08. nachmittags — Explore-Konsolidierung: dieses Doc ist WEITGEHEND GEGENSTANDSLOS

Owner-KERN 03.08. + 4 Explore-Berichte (backups/20260803-entscheide-explore/): Fast alle 11 Punkte waren
bereits entschieden/gedeckt — Voll-Verdikte im Ledger-NACHTRAG (Explore-Konsolidierung). REST-OFFEN:
NUR A.7-f2 (Tombstone-Koepfe, je-Repo-GO, nach Abgabe), A.7-f3 (comdare-analysis-Anlage-GO + Name,
nach Abgabe) und die 3 Overlay-Festlegungen (nicht-blockierend). Punkt 6 (V3) war ein Manager-Entscheid
und ist GEFAELLT (getrennte Fenster + A8-Kopplung); Punkt 8-f1-Empfehlung ZURUECKGEZOGEN (lief gegen
die Gitflow-Doktrin 07.07. — Default bleibt main, Aufloesung per merge).
