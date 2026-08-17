## VERDIKT: ENTSCHIEDEN

Die "vermeintliche Owner-Frage" E-2 ist keine echte Owner-Entscheidung. Beide Vorbedingungen aus der Aufgabenstellung sind erfüllt: das Format ist betreuer-definiert, UND das Anlegen ist bereits als Bauposten eingeplant. Die Entscheidungsgewalt liegt dabei bei zwei unterschiedlichen, aber beide bereits vorliegenden Quellen — nicht bei einer neuen Owner-Antwort.

### 1) Das Format — woertlich, Betreuer-Auflage, nicht Owner-Ermessen

**Fundstelle:** `docs/termine/20260508 Termin 7/Habich_Feedback_2026_05_08.txt:46-82` (Abschnitt "H2 — Code-Qualitaets-Bewertung pro Bausteine-Quelle"), **Datum 2026-05-08** (Termin 7, ~14 Wochen alt, aeltestes Feedback-Protokoll im Korpus).

Woertlich das Pflichtformat (Z.63-79):
```
Pro Bausteine-Quelle eine `BAUSTEIN_BEWERTUNG.md` mit folgender Struktur:
  # Bausteine-Bewertung — <Paper-ID> <Baustein-Name>
  **Quelle-Repo:** `ext/<paper>/<repo>/<file>:lines`
  **Quelle-Commit:** <hash>
  **Ziel:** `adapters/<paper>/<adapter_file>:funktion`
  **Code-Qualitaet vor Zerstueckelung:** ★ ★ ★ ☆ ☆ (kommentiert)
  **Aenderungen:** keine | minimale | substantielle (mit Liste)
  **Vergleichbarkeit-Bewertung:** vollstaendig | naheliegend | gefaehrdet
  **Habich-Sign-Off:** ausstehend | erteilt am YYYY-MM-DD
```
Erweitert laut Text ausdruecklich Task #80 (STRUKTUR_NOTIZ.md pro Repo). **Namens-Hinweis:** Original ist Singular `BAUSTEIN_BEWERTUNG.md` (pro Quelle je eine Datei); Wellenplan/Fragenbuendel schreiben spaeter Plural `BAUSTEINE_BEWERTUNG.md` — inhaltlich dieselbe Sache, kleine Namensdrift, fuer den Bau die Original-Singular-Form verbindlich.

Diese Auflage ist im Gap-Analyse-Dokument nochmals destilliert: `docs/plaene/20260806-KANON-termine-plan-soll-gegen-ist.md:362` (06.08.2026, Tabelle §2.11 "Betreuer-Auflagen H1-H6"). **Entscheidend:** derselbe Autor listet in §7 "Offene Fragen an den Owner" (Z.829-874, sieben Fragen O-1..O-7) dieses Thema NICHT — er selbst stufte es also am 06.08. bereits nicht als owner-entscheidungsbeduerftig ein, sondern rein als fehlendes Artefakt (§3.1 "Das Diff — was fehlt").

### 2) Das Anlegen ist bereits als Bauposten geplant

**Fundstelle:** `docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md:2543` (08.08.2026), §19.7 "UR-LEDGER-RUECKKEHRER":
```
| R-26 | BAUSTEINE_BEWERTUNG.md + Habich-Sign-Off je SOTA-Quelle | E4 F2 | W | Owner+W4 |
```
Seit 9 Tagen vor der heutigen Frage steht der Bau bereits auf der Liste, Zielwelle **W4**. Das Klassen-Tag "W" (Vergleich mit Nachbarposten R-32/R-33/R-34/R-37) bedeutet hier: die Format-Frage selbst ist NICHT offen — offen ist nur die mechanische Owner-Handlung "Sign-Off bei Habich einholen", die zwangslaeufig ein Mensch, kein Agent, erledigen muss.

### 3) Ist-Stand bestaetigt (eigene Gegenprobe)

- `find … -iname "*BAUSTEINE?_BEWERTUNG*"` = 0 Treffer im gesamten Repo.
- `grep "BAUSTEINE_BEWERTUNG\|Sign-Off\|Habich-Sign"` im 30597-Zeilen-Ledger = 0 Treffer.
- 13 `STRUKTUR_NOTIZ.md` je Bausteine-Quelle existieren bereits (`Forschungsarbeiten/code/STRUKTUR_NOTIZ_UEBERSICHT.md:22-40`, Stand 09.05.2026) mit Repo/LOC/Compiler/Lizenz/Adapter-Status — genau der Vorbestand, den H2 laut eigenem Text erweitert. Damit ist "ich fuelle es aus dem vorhandenen Adapter-Bestand" sachlich gedeckt.
- `docs/bausteine/00_INDEX.md:58-61` zaehlt 12 SOTA-Adapter + 10 Allokator-Adapter = 22 aktive Adapter — die "mindestens 8" aus der Frage ist die konservative Teilmenge.

### 4) Was daraus fuer den Bau folgt

- Je Bausteine-Quelle eine `BAUSTEIN_BEWERTUNG.md` im exakten Habich-Format anlegen (Quelle-Repo+Zeilen+Commit-Hash → Ziel-Adapter+Funktion → Sterne-Bewertung → Aenderungen → Vergleichbarkeits-Bewertung → Sign-Off-Feld).
- Aus vorhandenem `STRUKTUR_NOTIZ.md`-Bestand befuellen (Repo/Adapter-Status liegt teils schon vor; Commit-Hash und Sterne-Bewertung fehlen dort noch und muessen ergaenzt werden).
- Sign-Off-Feld je Datei auf **"ausstehend"** setzen — nicht autonom auf "erteilt" setzen; das ist laut Format selbst ausdruecklich ein Betreuer-Feld.
- Das tatsaechliche Einholen der Unterschriften bleibt separate, spaetere Owner-Handlung — kein Bauauftrag.
- Einzige tatsaechlich unentschiedene Nebenfrage (Timing, nicht Format/Ob): laut Wellenplan ist W4 die Zielwelle, laut Task-Spiegel der Session laeuft aktuell W1 — ob vorgezogen wird, ist keine Format-Frage und nicht Gegenstand von E-2.

Die heutige Vorlage selbst (`docs/sessions/20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md:396-417`, 17.08.2026 08:27) traegt dieselbe Faktenlage und empfiehlt bereits wortgleich zum obigen Schluss ("Ja — ich lege das Format an … Sign-Off bleibt auf 'ausstehend'"); laut Kopfzeile der Vorlage (Z.8) gilt eine Empfehlung ohnehin als angenommen, wenn keine abweichende Antwort kommt.

## GEPRUEFT
docs/termine/20260508 Termin 7/Habich_Feedback_2026_05_08.txt (Z.1-105) · docs/termine/INDEX.md · docs/plaene/20260806-KANON-termine-plan-soll-gegen-ist.md (§2.11, §3, §7 vollstaendig) · docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md (§19.7 komplett, R-01..R-38) · docs/plaene/20260808-GOAL-V8-DOSSIER-alle-wellen-am-stueck-bis-abgabe.md (grep) · docs/plaene/20260810-KONSOLIDIERUNG-unverlinkte-memories.md (grep) · docs/sessions/20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md (E-2 vollstaendig, Z.396-417) · docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (Volltext-grep auf BAUSTEINE_BEWERTUNG/Sign-Off/Habich-Sign/R-26/Baseline) · docs/bausteine/00_INDEX.md + 01-09 Dateiliste · Forschungsarbeiten/code/STRUKTUR_NOTIZ_UEBERSICHT.md · Repo-weite Dateisuche nach BAUSTEIN(E)_BEWERTUNG.

## NICHT GEPRUEFT
docs/sessions/backups/ Rohtranskripte zum Ur-Ledger-Fund "E4 F2" (Herkunfts-Explore-Karte des R-26-Postens) — nicht noetig, da Format+Bauplan bereits am Objekt (Habich-Text + Wellenplan) direkt belegt sind, nicht nur ueber die Explore-Karte · docs/audits/ · ce-Adapter-Quellcode selbst (adapters/*, ext/*) auf tatsaechliche Commit-Hashes — relevant erst beim Bau, nicht fuer das Verdikt · docs/sessions/20260817-OWNER-VORAB-15-restfragen.md und 20260817-INFRA-MELDUNG-*.md (andere Themen, kein Bezug zu E-2 laut Betreff).