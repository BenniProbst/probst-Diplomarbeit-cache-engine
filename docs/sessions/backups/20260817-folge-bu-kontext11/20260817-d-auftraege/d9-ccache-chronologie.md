# BERICHT D-9: ccache-Allowlist (A11) — Chronologie Plan-Posten vs. Code-Kommentar

## 0. Kurzfassung

Zwei Quellen widersprechen sich normativ: ein Plan-Posten will die `.ccache/`-Allowlist in `.gitleaks.toml` **droppen** (A11), ein Code-Kommentar sagt, sie **MUSS bleiben** (Marathon-Scan-Falle). Die reine Datumsdifferenz der zwei benannten Aussagen ist eindeutig: der **Code-Kommentar ist ÄLTER** (27.07.2026), der **Plan-Posten A11 ist JÜNGER** (02.08.2026, ca. 6 Tage später). Nach der Owner-Regel "die neueste Aussage gewinnt", *strikt auf diese zwei Aussagen angewandt*, gewinnt damit **A11** — nicht der Code.

Das ist die zentrale Korrektur dieses Berichts: **zwei bisherige interne Würdigungen (Ledger N-9, 06.08.; Plandokument GESAMTBILD, 08.08.) haben genau diesen Datumsvergleich verkehrt herum behauptet** ("der Code ist jünger" / "der Plan ist älter") und daraus die gegenteilige Empfehlung abgeleitet ("A11 zurückziehen"). Das ist an den eigenen Commit-Zeitstempeln nachweisbar falsch.

## 1. Herkunft des heutigen Auftrags (GEPRÜFT)

- `docs/sessions/20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md:330-341` (Commit `c926efdc9cf54f64e8ae3815c591378317e7f470`, **2026-08-17T08:42:55+00:00**): Abschnitt "D-9 -- A11: die ccache-Allowlist zurueckziehen?" mit EMPFEHLUNG "A11 zurueckziehen, den Code-Kommentar zur geltenden Wahrheit erklaeren".
- `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:19` Kopf "KONSOLIDIERUNG CIV (KON104) -- 17.08.2026"; `:27` Owner-verbatim: *"D-9: Bitte explore und tief lesen gegen den Plan, die neueste Aussage gewinnt."*; `:51-52` (KON104-02): *"D-9 ccache-ALLOWLIST (A11): EXPLORE + TIEFLESEN gegen den Plan angeordnet -- Chronologie Plan-Posten vs. Code-Kommentar (Marathon-Scan-Schutz); DIE NEUESTE AUSSAGE GEWINNT. Gestartet."* — d.h. der Owner hat die Vorlagen-Empfehlung NICHT einfach übernommen, sondern ausdrücklich eine Chronologie-Prüfung angeordnet.

## 2. Seite CODE — literal datiert (GEPRÜFT, beide Repos)

**super** (`/.gitleaks.toml:24-29`): Commit `d677709439ebd659958dc67c69639d40968a1de0`, **2026-07-27T13:59:41+00:00**, Autor Benjamin-Elias Probst, Betreff *"fix(gitleaks): W0b-HOTFIX - (^|/)\.ccache/ in die super-Allowlist (Marathon-Scan-Falle...)"*. Blame bestätigt: Zeilen 24-29 tragen ausschließlich diesen Commit, bis heute unverändert.
Commit-Text wörtlich: *"Job 335274 (lint:secrets der W2-Welle) lief 24 Minuten ohne Trace-Ausgabe ... der ccache-Store (GB Binaerdaten) wurde mitgescannt."*

**ce** (`Code/external/comdare-cache-engine/.gitleaks.toml:46-50`): Commit `02dcf2308d4142be4506b3bc40b0a41aaa0e812b`, **2026-07-27T16:13:36+00:00**, selber Autor, Betreff *"fix(gitleaks): OP-3 ..."*, spiegelt denselben Eintrag explizit unter Verweis auf `d6777094` in super. `git blame -L 44,51` bestätigt: Zeilen 46-50 tragen ausschließlich diesen Commit. `git log --oneline -- .gitleaks.toml` in ce zeigt genau 3 Commits total, `02dcf230` ist der jüngste — die Datei wurde seit 27.07. nicht mehr angefasst.

Heutiger Stand (Read, ce-HEAD `04ac26fa`, super-Arbeitsbaum sauber, `git status` beide "nothing to commit"): Der Eintrag `'''(^|/)\.ccache/'''` mit der Marathon-Scan-Falle-Begründung **existiert unverändert in beiden Repos**.

Kein noch neuerer Touch: Commit `90979dc319eb2b582f054f6d5fcca6d5d0958a7c` (**2026-08-14T09:10:15+00:00**, "F5 -- Koeder-Prosa-Allowlist") ändert nur einen ANDEREN Allowlist-Block (Köder-Wort-Maskierung für die stdin-Push-Wache) — die `.ccache/`-Zeilen bleiben laut Blame bei `d6777094`/`02dcf230`. Bestätigt per Ledger-Fundstelle `:2275/:2383` (Namenskollision "Allowlist", andere Bedeutung).

## 3. Seite PLAN — literal datiert (GEPRÜFT)

**Ursprung/Vorstufe:** `docs/sessions/20260802-UEBERGABE-kontextende-neugruendung.md:60-61`, Commit `75f9099c8a04d7ad1dd92b8a2251c0fbda0afe0a`, **2026-08-02T08:10:58+00:00**: *"ccache-Allowlist-Drop (base-pipeline.yml + super/.gitleaks.toml)"* — noch ohne das Label "A11".

**Formale Katalogisierung als A11:** `docs/sessions/20260802-KATALOG-offene-strecke-gesamtplan.md:27`, Commit `ee33a3b58644221a53f61e8adec7d2d0428cacda`, **2026-08-02T09:00:11+00:00**: *"A11 | Klein-Sammel | ccache-Allowlist-Drop; gebuendelter Ledger-Nachtrag (...) | offen"*.

`git log -L 27,27` auf diese Datei zeigt: **genau ein Commit** hat diese Zeile je berührt (die Erstellung selbst) — der Status "offen" wurde nie geändert, A11 wurde im Plandokument selbst nie zurückgezogen.

**Damit: Plan-Posten A11 (02.08., 08:10/09:00 UTC) ist ca. 6 Tage JÜNGER als der Code-Kommentar (27.07., 13:59/16:13 UTC).**

## 4. Die spätere Kette — und der Fehler darin (GEPRÜFT)

Drei spätere, jeweils chronologisch neuere Würdigungen desselben Konflikts:

**(a) Ledger N-9**, `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:23513-23533` (Abschnitt-Kopf `:23206` "NACHTRAG 06.08.2026 abend-1"), also **06.08.2026**:
> *"die Marathon-Scan-Begruendung ist am Objekt konkret (Job 335274, 24 min ohne Trace) und **juenger als nichts anderes im Widerspruch**; Empfehlung: A11 zurueckziehen ... -- Owner-Entscheid abwarten, nicht vorwegnehmen."* (`:23530-23533`)

Diese Formulierung behauptet: nichts im Konflikt ist jünger als die Marathon-Begründung — d.h. der Code sei das jüngste Element. **Das ist falsch**: A11 (02.08.) ist jünger als der Code (27.07.). N-9 zitiert beide Daten korrekt im selben Absatz (`:23516` "02.08." / `:23522-23524` "27.07."), zieht daraus aber die falsche Reihenfolge.

**(b) GESAMTBILD-SETZUNG**, `docs/plaene/20260808-GESAMTBILD-vergessene-arbeit-und-neuer-wellenplan.md:416`, Commit `e72025b58a10ebae441b3bf1e8353ba0da8a0ac9`, **2026-08-08T08:10:11+00:00**:
> *"A11 (ccache-Allowlist-Drop) bleibt bis zu deinem Widerspruch so wie er ist -- der Code trägt eine eigene Begründung (Marathon-Scan-Falle 27.07.), und **der Plan, ihn zu droppen, ist älter**."*

Dieselbe Inversion, jetzt noch expliziter falsch formuliert ("älter" statt "jünger"). Status zu diesem Zeitpunkt laut `:53` derselben Datei: A11 🟠 weiterhin offen. Diese SETZUNG wurde nie in den Ledger mit eigener KON-Nummer übernommen (Suche nach "GESAMTBILD" im Ledger trifft nur fremde Bedeutungen, z.B. `:1659` "PMC-GESAMTBILD" — anderer Gegenstand).

**(c) rest_karte_r3.md** (Drift-Konsolidierung von heute), `docs/sessions/backups/20260817-drift-konsolidierung-rohdaten/rest_karte_r3.md:707-712` (D21) und `:791-798` (W-r3-3), **2026-08-17** (selbes Tagesdatum wie die Vorlage): wiederholt "Empfehlung: A11 zurueckziehen", diesmal aber **ohne** die falsche Alters-Behauptung — Begründung nur noch "die Marathon-Begruendung ist am Objekt konkret". W-r3-3 stuft den Fall explizit als *"Plan gegen Code, beide normativ"* unter "WIDERSPRUECHE ... OHNE ERKENNBARE AUFLOESUNG" ein und schließt mit *"Kleiner Owner-Entscheid."* — also weiterhin offen, nicht autonom entschieden.

## 5. Numbering-Circle-Fallen (geprüft und ausgeschlossen)

Wie von Memory ("STEMPEL-SYNTAX ... Explore-Cluster gegen Plan pruefen") gefordert, gegengeprüft: "A11" trifft im Korpus mehrfach unter FREMDER Bedeutung — "A11-Audit" 20.07. (Ledger `:20918-21413`, GN-2-Guard-Thema), "A11-Buendel" 03.08. (Ledger `:22100-22103`, Sammelbegriff für diverse Owner-Entscheide), "r5-A11"/"S13-08-A11(2)" in `docs/plaene/20260817-DESIGN-s13-buendel-di25.md:674/679/704/1322` (eigene Nummerierung aus `rest_karte_r5.md`, Thema Mess-Ebenen-CMake-Flag — NICHTS mit ccache zu tun), sowie "A11" als Adapter-Kennung in der Thesis-Tabelle (Ledger `:27368`). Alle diese wurden ausgeschlossen; die einzigen echten Treffer zur ccache-Allowlist sind die in Abschnitt 3-4 zitierten.

## 6. URTEIL nach Owner-Regel "die neueste Aussage gewinnt"

**Welche Aussage ist jünger?** Der Plan-Posten A11 (`ee33a3b5`, 2026-08-02T09:00:11+00:00) ist eindeutig jünger als der Code-Kommentar (`d6777094`/`02dcf230`, 2026-07-27). Das ist die literal geprüfte, korrigierte Antwort — die zwei einzigen bisherigen Versuche, genau diesen Vergleich zu ziehen (N-9, GESAMTBILD), haben ihn nachweisbar verkehrt herum gerechnet.

**Was folgt daraus, strikt nach der Regel:** Mechanisch angewandt auf genau die zwei benannten Aussagen gewinnt **A11** — die Allowlist-Zeile müsste ausgeführt (gedroppt) werden, nicht der Code-Kommentar.

**Aber:** Zwischen dem 02.08. und heute existiert keine einzige spätere, mit korrekter Chronologie-Begründung geführte Aussage, die A11 bestätigt oder erneut aufgreift, um es AUSZUFÜHREN. Alle vier bisherigen Durchgänge (N-9 06.08., GESAMTBILD 08.08., rest_karte_r3 17.08., heutige Vorlage 17.08. 08:42 UTC) landeten — unabhängig vom fehlerhaften Chronologie-Argument der ersten zwei — bei "A11 zurückziehen", zuletzt gestützt allein auf die unwiderlegte technische Tatsache (Job 335274, 24 Minuten ohne Trace-Ausgabe, gemessen und nie erneut widerlegt). Diese technische Begründung "altert" nicht wie eine Meinung — der `.ccache`-Bestand ist seither eher gewachsen als geschrumpft (kein Beleg im Korpus für eine Verkleinerung), das Risiko eines erneuten Hängers ist nicht entkräftet.

**Empfehlung für die Owner-Entscheidung:** Wegen der offengelegten Rechenfehler in N-9/GESAMTBILD ist "A11 stillschweigend als erledigt betrachten" nicht zulässig — der Fehler entwertet deren Alters-Argument, nicht zwingend deren Ergebnis. Zwei objektiv saubere Wege bleiben, beide bereits im Korpus als einzig akzeptabel benannt (*"Stillschweigendes Verschwinden waere die schlechteste Variante"*, N-9 `:23532`, wortgleich in der heutigen Vorlage `:341`):
- **A11 ausführen** (Allowlist-Zeile in beiden `.gitleaks.toml` entfernen) — dann aber nur NACH einer frischen Gegenprobe, ob der 24-Minuten-Effekt am heutigen `.ccache`-Bestand noch eintritt (Job-335274-Wiederholung), sonst wiederholt sich exakt der Defekt, den der Code-Kommentar dokumentiert.
- **A11 sichtbar zurückziehen** und den Code-Kommentar zur geltenden Wahrheit erklären, mit Marker am Plan-Posten (`KATALOG:27`) — dann aber mit der KORREKTEN Begründung (technische Konkretheit, nicht "der Code ist jünger").

Diese Weiche selbst ist nicht meine Entscheidung — der Korpus hat sie viermal in Folge dem Owner zugewiesen ("Owner-Entscheid abwarten", "Kleiner Owner-Entscheid"), und dabei bleibt es; ich liefere die korrigierte Chronologie, auf deren Basis diese Entscheidung jetzt richtig getroffen werden kann.

## 7. GEPRÜFT / NICHT GEPRÜFT

**GEPRÜFT (am Objekt, mit Commit-SHA + ISO-Zeitstempel):**
- Code-Kommentar-Datierung super (`d6777094`, 2026-07-27T13:59:41+00:00) und ce (`02dcf230`, 2026-07-27T16:13:36+00:00), inkl. Blame-Bestätigung, dass die Zeilen bis heute unverändert sind.
- Plan-Posten-Datierung (`75f9099c`, 2026-08-02T08:10:58+00:00 Vorstufe; `ee33a3b5`, 2026-08-02T09:00:11+00:00 formale A11-Katalogisierung), inkl. `git log -L` Bestätigung, dass die Zeile nie wieder geändert wurde.
- Heutiger Codezustand (ce-HEAD `04ac26fa`, super Arbeitsbaum sauber) — Allowlist-Eintrag existiert unverändert.
- Ledger-N-9-Wortlaut und dessen Selbstwiderspruch (`:23513-23545`, `:23626`, `:23734-23738`).
- GESAMTBILD-SETZUNG-Wortlaut und Commit-Datierung (`e72025b5`, 2026-08-08T08:10:11+00:00).
- rest_karte_r3.md-Wortlaut (D21, W-r3-3).
- Herkunft und Wortlaut der heutigen Vorlage (`c926efdc`, 2026-08-17T08:42:55+00:00) und der Owner-Antwort (KON104-01/-02).
- Vier Numbering-Circle-Fehlalarme identifiziert und als fremde Bedeutung ausgeschlossen.
- Kein Owner-Verbatim-Zitat gefunden, das diesen Konflikt vor heute bereits abschließend entschieden hätte (Ledger-Suche "GESAMTBILD" trifft nur fremde Bedeutungen; kein KON-Eintrag verbucht die 08.08.-SETZUNG).

**NICHT GEPRÜFT:**
- Ob die vier repo-lokalen Ledger (ce/prt-art/thesis/Cluster) oder `docs/audits/` eine weitere, mir nicht aufgefallene Aussage zu diesem exakten Konflikt tragen — meine Suche war auf das super-Ledger, `docs/plaene/`, `docs/sessions/` und die zwei genannten Code-Repos beschränkt, wie im Auftrag vorgegeben.
- Ob eine empirische Neumessung ("läuft gitleaks heute wieder 24 Minuten ohne den Eintrag") je durchgeführt wurde — dafür liefert der Korpus keinen Beleg, weder positiv noch negativ; ich habe keinen Bau/Scan gefahren (Änderungsverbot).
- Rohtranskripte außerhalb der zitierten Dossiers/Karten wurden nicht vollständig durchsucht.