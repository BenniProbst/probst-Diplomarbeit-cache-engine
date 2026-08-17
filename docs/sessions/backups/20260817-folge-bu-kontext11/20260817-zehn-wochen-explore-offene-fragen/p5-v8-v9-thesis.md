# ZEHN-WOCHEN-EXPLORE — FRAGE P5 (V8/V9 aus dem Thesis-Trailer-Rewrite, KON76)

## (1) VERDIKT: **TEIL-ENTSCHIEDEN** (gemischt — die zwei Posten laufen unterschiedlich)

- **V9 (rescue-Ref w3-thesis-c)** = **ENTSCHIEDEN UND VOLLZOGEN**.
- **V8 (GitHub-PAT-Rotation)** = **TEIL-ENTSCHIEDEN**: das WAS ist Owner-entschieden, der VOLLZUG steht bis zur jüngsten Ledger-Zeile (KON104, 17.08.) weiter aus.

---

## (2) V9 — ENTSCHIEDEN, das Owner-Wort wörtlich

**Fundstelle:** `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:765-768` (KON93-01, Owner 16.08.2026, super-Repo):

> „Zu Frage 2: Ich wollte den Kontext selbst bewerten, aber Loeschen kannst du nach Anzeige dieses Kontextes der zu entscheiden ist, gerne selbst. V9 Zusammenfassung reichte mir ehrlichgesagt, daher volles GO."

„dieses Kontextes" = der KON90-Bericht (`:883-905`, 16.08.): die Einarbeitungs-Prüfung der Seitenlinie war ein **Null-Befund** (313/313 Non-Merge-Commits patch-äquivalent bereits in der heutigen Thesis, 0 fehlend). Das ist exakt das **gegenstands-genaue GO**, das die Remote-Löschungs-Doktrin verlangt (`:3073` „Remote-Loeschung NUR mit explizitem Owner-GO"; `:904` „gegenstands-genaues Loesch-GO fuer refs/rescue/w3-thesis-c") — kein Blanko-GO, sondern an das konkret gezeigte Objekt gebunden.

**Was daraus für den Bau folgte (bereits vollzogen, `:763-781`, KON93-01):** Bundle-Sicherung ZUERST (`8aacc77a`, auf beiden super-Remotes gelandet), DANACH Löschung auf origin UND github (`git push :refs/rescue/w3-thesis-c`, je „[deleted]" literal), Gegenprobe `ls-remote refs/rescue/* origin=0 + github=0`.

**Eigene Gegenprobe (heute, 17.08., READ-ONLY, wie im Auftrag verlangt):** `git ls-remote origin "refs/rescue/*"` und `git ls-remote github "refs/rescue/*"` im Thesis-Klon (`/home/comdare/Projekte/Research/20260931-overleaf-diplomarbeit`) liefern **beide 0 Treffer** — die Löschung hält am lebenden Objekt, heute, unabhängig vom Ledger-Text nachvollzogen. V9 ist damit nicht nur dokumentiert, sondern objektiv verifiziert erledigt.

---

## (3) V8 — TEIL-ENTSCHIEDEN, engster Stand + verengte Restfrage

**Chronologie (alle Fundstellen `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`):**
- `:1466-1475` (KON76-03, 15.08.): V8 aufgeworfen — fehlgeformte `~/.git-credentials`-Zeile auf prod1, Empfehlung: GitHub-Fine-Grained-PAT rotieren, danach 3 github.com-Zeilen bereinigen.
- `:1243-1244` (KON80-01, 16.08.): „V8 GITHUB-PAT: Owner rotiert HEUTE; Handout an Infra-Kanal geschrieben (Cluster-Repo). Store-Bereinigung nach Rotation durch Session." — das WAS ist hier entschieden (JA, rotieren).
- `:959` (KON88, 16.08.): „V8: Owner braucht noch Zeit (Rotation offen)."
- `:803-809` (KON93-03, 16.08., **jüngste Owner-Aussage zu V8 im gesamten Ledger**), wörtlich Z.805: „Bei V8 - ich mach gerade mit dem infra Agenten." — Rotation läuft AUSSERHALB der Session; bis zur Vollzugs-Meldung bleibt `~/.git-credentials` unangetastet.
- Cluster-Repo-Handout `/home/comdare/Projekte/Cluster/docs/sessions/20260816-HANDOUT-github-pat-rotation-credential-store.md:58`: „TEIL A (GitHub-PAT prod1, O1/O2/S1-S3): NICHT ausgefuehrt - wartet auf den Owner." (Teil B desselben Handouts betrifft einen ANDEREN Token, den GitLab-PAT `r20260812` — Kürzel-Falle geprüft und aufgelöst: gleicher Rotationsdatums-Namensraum, zwei verschiedene Gegenstände.)
- **Heutiger Stand (17.08.):** `docs/sessions/20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md:69-70` (Frage A-2, geschrieben 08:27 Uhr): „Der Ledger-Kopf fuehrt in der Rotationsliste heute nur V8 (GitHub-PAT)." — V8 steht damit heute Vormittag noch immer offen auf der Liste.
- Vollständige Durchsicht KON94–KON104 (die zehn jüngsten Konsolidierungen, `:19-758`, inkl. der heutigen Owner-Antwortrunden KON101-104 zu A/B/C/D-Fragen): **0 Treffer** für „V8", „GitHub-PAT", „credential", „rotier*" — keine Vollzugs-Meldung, keine Erwähnung mehr.

**A4-Pausen-Regel deckt V8 NICHT ab.** Quelle `:2657-2659` (KON64-01, 14.08.): „A4 Rotation: AUFGESCHOBEN bis Arbeits-Pause ('Fortschritt geht vor') -- Vormerkliste: 776er, 06.08.-Aera, 4 MinIO-Alt-Svcaccts, Root-Identitaets-Umzug (Rails/Registry), id=98-Turnus." Diese Vormerkliste datiert vom 14.08. — **einen Tag vor V8s Fund** (15.08., KON76) — und führt V8 nicht. Sachlich passt A4 auch nicht: A4 beschreibt passives Aufschieben session-seitiger Rotationen; V8 dagegen ist ein Vorgang, den nur der Owner selbst ausführen kann (GitHub-Web-UI, siehe Handout O1/O2), und der Owner hat wiederholt AKTIVES Engagement erklärt („rotiert HEUTE", „ich mach gerade mit dem infra Agenten") statt Aufschub. A4 = kein Freibrief für V8.

**Downstream blockiert:** Store-Bereinigung (3 `~/.git-credentials`-Zeilen) UND F5 GitLab-Push-Mirroring (`:908-912`, KON89: „NACH der V8-Rotation mit dem NEUEN Token als Mirror-Credential") hängen beide direkt an V8s Vollzugs-Meldung.

**Verengte Restfrage (ein Satz):** Ist der GitHub-Fine-Grained-PAT auf prod1 inzwischen (nach dem 17.08. 08:27 Uhr, dem jüngsten dokumentierten Stand) vom Owner rotiert — kein Dokument im super-, Cluster- oder Thesis-Repo belegt das JA oder NEIN, nur der Owner (bzw. das Handout-Feld „TEIL A") kann diese Lücke schließen.

---

## (4) GEPRÜFT / NICHT GEPRÜFT

**GEPRÜFT:**
- Vollständiger Ledger-Durchlauf super-Repo von KON76 (Ursprung) bis KON104 (jüngste Zeile, 17.08.) — alle 29 dazwischenliegenden KON-Abschnitte auf „V8"/„V9"/„github"/„credential"/„rotier*" durchsucht (Kopfzeilen-Scan + gezielte Volltext-Greps).
- `docs/sessions/20260815-OWNER-VORLAGEN-V1-V7-nachstufen-tag.md` (Original-Fragestellung V8/V9 an den Owner, 15.08.).
- `docs/sessions/20260816-SESSION-UEBERGABE-kontext8-entscheidungs-tag-golden-fenster.md` (Übergabe-Status „V8=wartet").
- `docs/sessions/20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md` (heutige 20-Fragen-Vorlage, Gruppen A-E) + zugehörige Owner-Antworten KON101-104.
- `docs/sessions/20260817-OWNER-VORAB-15-restfragen.md` und `20260817-INFRA-MELDUNG-runner-token-rotation-wartungsfenster.md` — beide auf V8/V9 geprüft, kein Bezug (die Infra-Meldung betrifft die separaten Runner-Registration-Tokens 286/288/289 + `samba-comdare-socks-pw`, NICHT V8).
- Cluster-Repo: `docs/sessions/20260816-HANDOUT-github-pat-rotation-credential-store.md` vollständig gelesen (Teil A = V8, unausgeführt; Teil B = anderer Gegenstand, r20260812-GitLab-PAT, ersatzlos gelöscht — Kürzel-Falle aufgelöst).
- **Live-Objektprobe (READ-ONLY, wie beauftragt):** `git ls-remote origin "refs/rescue/*"` + `git ls-remote github "refs/rescue/*"` im Thesis-Eigenklon — beide 0 Treffer, bestätigt V9-Löschung am lebenden Objekt.
- A4-Pausen-Regel-Ursprung (`:2657-2659`, KON64-01, 14.08.) und Remote-Löschungs-Doktrin-Wortlaut (`:3073`, `:904`) im Ledger verortet und gegen V8/V9 geprüft.

**NICHT GEPRÜFT:**
- Rohe Verbatim-Sammlungen (`tmp/kon64_sammlung.md`, „Sammlung Teil 32") — nicht geöffnet, da der Ledger selbst bereits klar als Owner-Zitat markierte Stellen liefert (Vorrang-Regel: Ledger schlägt Session-Docs).
- GitHub.com selbst / der PAT-Live-Zustand — nicht prüfbar ohne Credentials und außerhalb des Auftragsrahmens (Du änderst NICHTS / keine Secrets anfassen).
- Inhalt von `~/.git-credentials` auf prod1 — bewusst nicht gelesen (Datei trägt laut Befund einen Live-Token; Prüfung hätte Geheimnis-Exposition riskiert und war für die Verdikt-Frage nicht nötig).
- Ob der Owner V8 zwischenzeitlich außerhalb jeder Dokumentation (mündlich, außerhalb der Session) bereits abgeschlossen hat — aus statischen Dokumenten prinzipiell nicht feststellbar; das Verdikt ist ausdrücklich auf „Stand jüngste Ledger-Zeile KON104, 17.08." begrenzt.