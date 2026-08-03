# Architektur-Ziele- / Offene-Punkte-Ledger - Diplomarbeit (Thesis-Repo, repo-lokale Sicht)

> **VORRANG: das super-LEDGER (`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`) gewinnt bei Widerspruch;
> dieses Ledger ist die repo-lokale Sicht.**

**Angelegt:** 2026-08-02 | **Basis-Commit:** `2139047` | **Zweck:** repo-lokale Buchfuehrung der
Thesis-Ziele und offenen Punkte (Text, Sprachfassungen, CI-Gates, Abgabe-Artefakte).
**Fortgeschrieben:** 2026-08-03 (E-02-Nachzug: Ist-Anker, C-Nachzuege, Text-Doktrinen-Kanon, T6 -> Abschnitt 7;
Einschuebe nur als Nachzug-Noten, Bestandstext unveraendert).
**AUDIT-PFLICHT:** Jeder Audit-/Inventur-/Goal-Lauf liest ALLE VIER Ledger (super docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md + ce docs/ledger-sections/*.md inkl. goal-v6-luecken-ledger.md + prt-art docs/ledger-sections/*.md + thesis docs/ledger-sections/*.md).
**Vier-Ledger-Doktrin:** super | comdare-cache-engine | comdare-prt-art | thesis/diplomarbeit (diese Datei).
Das Cluster-Ledger liegt in Infra-Hoheit und ist das **5.** Ledger ausserhalb dieser Doktrin.

**Schreibweise:** ASCII-only. **Diese Datei ist eine Arbeitsdatei ausserhalb der LaTeX-Kette** (`.md`,
nicht `.tex`) und damit CI-inert gegenueber den beiden LaTeX-Gates (Beleg s. Abschnitt 3).

**Identitaets-Doktrin (pruefungsrechtlich, bindend fuer dieses Repo):** Jeder Commit hier traegt die
Identitaet `Benjamin-Elias Probst <benjamineliasprobst@gmail.com>` und **keinerlei Agenten-Trailer**
(kein `Co-Authored-By`, keine Werkzeug-Signatur). Das gilt fuer alle Dateien dieses Repos, auch fuer
Arbeitsdateien wie diese.

---

## 0. Nutzungs-Disziplin

1. Nur **repo-lokale** Ziele/offene Punkte. Projekt-Steuerung, Trigger-Sequenz, Mess- und Lager-Strecke
   leben ausschliesslich im super-LEDGER.
2. Kein Punkt gilt als erledigt ohne literalen Beleg (Datei:Zeile, Commit, Build-/CI-Ausgabe).
3. Statusfuehrung der C-Punkte bleibt **super-seitig** (Katalog `docs/sessions/20260802-KATALOG-offene-
   strecke-gesamtplan.md` Abschnitt C); dieses Ledger spiegelt sie repo-lokal und ergaenzt den Ist-Beleg.
4. Bei Widerspruch zum super-LEDGER: super gewinnt; der Widerspruch wird hier vermerkt, nicht einseitig
   aufgeloest.

---

## 1. Sprach-Doktrin: DE fuehrend, EN Zwilling

- **Anker im Repo:** `config/language.tex:3` - "de (Deutsch, primaer) | en (Englisch, sekundaer)";
  Umschaltung ueber genau eine Zeile (`\providecommand{\thesislang}{de}`, `config/language.tex:11`),
  lokal per `build.ps1 -Lang <de|en>`, in der CI per `-usepretex="\def\thesislang{<lang>}"`.
- **Regel:** Die **deutsche Fassung ist die Hauptfassung**; die englische Fassung ist ihr **Zwilling** und
  wird jeder inhaltlichen DE-Aenderung **synchron nachgezogen** (Quell-Kommentar-Korrektur in Commit
  `e89e2f7`: "DE=Hauptfassung/EN=synchron"). Ein Eingriff nur in EN ist eine Regression.
- **Beide Fassungen sind Abgabe-Artefakte** und werden seit CI REV 3 (`fd459cf`) **beide kompiliert**
  (vorher war EN nur gelintet, also CI-seitig unbelegt; chktex ist Linter, kein Compiler).
- **Letzter belegter Umfang:** DE 192 Seiten / EN 184 Seiten, je 0 Warnings, `.blg` 0, chktex ok
  (Commit-Beleg `2139047`).
- **Genus-/Sprachpflege:** Sprachliche Mikro-Fixes sind je Fassung zu pruefen - EN ist teils
  genus-neutral, DE nicht (Beispiel-Praezedenz `20671fe`).

### 1.1 Text-Doktrinen (Kanon, nachgetragen 03.08. - bindend fuer jeden Text-Eingriff)

- **Verweis-Regel sequenziell:** Verweise zeigen nur **RUECKWAERTS** (auf bereits Eingefuehrtes);
  Vorwaerts-Verweise sind eine Regression. Struktur folgt **allgemein -> speziell** (Habich-Restruktur).
- **Aufgabenstellung linear, keine Loesung vorweg:** die Einleitung/Aufgabenstellung nimmt keine
  Loesungsbausteine vorweg; der Kern-Beitrag (Achsen-Library) wird erst an seiner Stelle entwickelt.
- **Nur Owner-Ideen persistieren:** in den Thesis-Text gehen ausschliesslich Ideen/Formulierungen des
  Owners ein; Agenten liefern Handwerk, keine eigenen Forschungs-Claims.
- **Float-Disziplin:** Tabellen-Legenden/Notizen stehen UNTER dem Float (nicht im Fliesstext davor).
- **Fachvokabular:** Design-Space-Vokabular nach Idreos et al.; Baum-Anatomie-Terminologie einheitlich.
- **LaTeX = Primaerquelle:** das Thesis-Design ist Quelle der Implementierung - Impl-Abweichungen werden
  ruckwaerts in den Text NUR ueber den super-gefuehrten Nachzug eingepflegt (kein stiller Text-Drift).

---

## 2. C-Katalog (Abschnitt C des super-Katalogs vom 02.08.) als Ledger-Zeilen

| ID | Punkt | Repo-lokaler Ist-Beleg | Stand |
|---|---|---|---|
| **C1** | Rahmen-Pass: Danksagungs- + Sperrvermerk-Entwuerfe zur Owner-Freigabe, Lizenz-Matrix, EN-Abstract-Sync, F10-Wortfix | Entwuerfe `761cecc` (Sperrvermerk + Lizenz-Matrix DE+EN), Truth-Check-Nachbesserung `33185f0`, EN-Abstract-Sync `e89e2f7`, F10-Wortfix `20671fe`, Owner-Entscheide eingearbeitet `2139047` (ce-Kern duales Lizenzmodell, Marke Comdare, Krause als zweiter Betreuer, Sperrvermerk auf Forschungs-Ausnahme) | im Repo gelandet; **Statusfuehrung super-seitig** (Katalog fuehrt C1 als offen - Abgleich beim naechsten Katalog-Pass) |
| **C2** | K4 "320 Tests" -> 321 + Anhang-B-Stichtagszeile | - | **terminiert**: erst **beim Einfrieren der ce-Linie** nachziehen (sonst sofort stale) |
| **C3** | Rang-3-Framing K5:70 ("Plattformen der Rang-3-Hardware-Arbeiten" -> Produktions-Zielmaschinen + HBM) | - | **Owner-GO liegt vor** (Entscheid 4 vom 02.08.: "Ja bitte schaerfen"); **neue Plattformen** RISC-V, macOS M1 (ARM), macOS x86 kommen hinzu - Thesis-Nachzug jedoch **erst wenn real im Bestand** (Bauplan 02.08.) |
| **C4** | Aufgabenblatt-PDF | `aufgabenstellung/` im Repo | **beim Owner** (nicht agentenseitig loesbar) |
| **C5** | Ergebnis-/Auswertungs-Einspeisung nach Voll-Messung (E-1 breit nachziehen) | - | **gated auf die Messung** (USER-GO-gated); ohne Messdaten kein Text |
| **C6** | Identity-Normalisierung thesis-Gitlink (#375/#377) | - | **bei Infra** |
| **C7** | chktex-Haertung: Lint bleibt gruen, wenn eine `.tex` verschwindet | `.gitlab-ci.yml`: `find . -name "*.tex" ... \| xargs -0 -r chktex ...` - eine geloeschte/nicht auffindbare `.tex` erscheint gar nicht erst in der Liste, der Lint bleibt gruen | **offen (nice-to-have)**; Restrisiko stark reduziert, seit REV 3 **beide** Fassungen kompiliert werden (fehlende `\input`-Datei bricht `latexmk -halt-on-error`) |

Nachzug-Noten 03.08. (Quelle: ce-ABGLEICH `20260803-ABGLEICH-katalog-gesamtplan-ist-stand.md`, Abschnitt B/C):
- **C1:** Sprachpass C1-Rest zusaetzlich gelandet (`a53c5ec`/`e525a5a`/`b1ec837`); ABGLEICH fuehrt
  "C1-Rahmen-Pass: GO liegt, Entwurfs-Stand zu verifizieren" - die Verifikation ist der offene Rest.
- **C2:** Gate-Zahl ist GEWACHSEN - beim Einfrieren jetzt **331** (nicht mehr 321). Konsequenz: die Zahl
  wird beim Ausloesen LIVE aus der ce-CI erhoben, nie vorab in den Text geschrieben.
- **C3:** unveraendert gated auf realen Bestand; der Plattform-Querschnitt (target_isa/OS-Achsen, Runner,
  E-19) laeuft super-seitig.

Erledigt seit 01.08. (super-Katalog, hier nur referenziert): K0-K6-Nachzug, Sprachpass alle Kapitel,
Anhaenge A-F-Konsolidierung, Verweis-/Formel-Pass (0 undefined, DE==EN 525 cites), F15-12900K-Nachzug
(`b224628`), CI REV 3 (`fd459cf`).

---

## 3. CI: die 4 Job-Klasse dieses Repos (Ist, `.gitlab-ci.yml` REV 3)

Drei Job-**Definitionen** ergeben **vier Job-Instanzen** je Pipeline:

| # | Job | Stage | Bedingung | Inhalt |
|---|---|---|---|---|
| 1 | `lint:secrets` | `lint` | immer (hermetisch) | gitleaks via `.lint-secrets` aus `comdare/cluster/ci-templates` (`base-pipeline.yml`) - harter Secrets-Gate |
| 2 | `lint:latex` | `lint` | `$COMDARE_TEXLIVE_AVAILABLE == "true"` | chktex ueber alle `.tex` mit `.chktexrc`, `-n36 -n17`, **ohne** `\|\| true` (REV 2) |
| 3 | `thesis:pdf [de]` | `thesis-pdf` | `$COMDARE_TEXLIVE_AVAILABLE == "true"` | `latexmk -pdf -halt-on-error -jobname=diplomarbeit-de` |
| 4 | `thesis:pdf [en]` | `thesis-pdf` | `$COMDARE_TEXLIVE_AVAILABLE == "true"` | dieselbe Regel mit `THESIS_LANG=en` (`parallel: matrix`) |

Weitere Repo-Randbedingungen: `GIT_SUBMODULE_STRATEGY: none`; Tags `[baremetal]`; TeXLive ist
**Infra-Voraussetzung** (P1c) - ohne `COMDARE_TEXLIVE_AVAILABLE` laufen die LaTeX-Jobs nicht an.
**Overleaf-Kopplung:** die `.gitlab-ci.yml` lebt auf `main`; Overleaf synct eigene datierte Branches.

**CI-Inertheit dieser Datei (Beleg):** `lint:latex` sammelt nur `*.tex`, `thesis:pdf` kompiliert
`diplomarbeit.tex`; eine `.md` unter `docs/ledger-sections/` wird von keinem der beiden Gates gelesen.
Einziger beruehrter Job ist `lint:secrets` (scannt alles) - die Datei enthaelt keine Secrets.

---

## 4. Abgabe-Gates (bindend, Abschnitt 7 Hard-Gate)

Ein Stand gilt nur dann als abgabefaehig belegt, wenn **alle** folgenden Punkte literal erfuellt sind:

1. **0 LaTeX-Fehler** - `latexmk -interaction=nonstopmode -halt-on-error` fuer **beide** Sprachfassungen.
2. **Warnungs-Deckel** - `COMDARE_THESIS_KNOWN_WARNINGS: "1"`: hoechstens **eine** bekannte,
   owner-akzeptierte LaTeX-Warning je Fassung; darueber gilt das Dokument als kaputt.
3. **Literatur sauber** - `.blg` ohne `Repeated entry` und ohne `Warning--` (Bibliographie-Stil `alphadin`).
4. **chktex Exit 0** - mit `.chktexrc`, dokumentierten Suppressions `-n36`/`-n17`; keine Aufweichung
   per `|| true`.
5. **Secrets-Gate gruen** - gitleaks (`lint:secrets`).
6. **Beide PDFs als Artefakt** - `diplomarbeit-de.pdf` und `diplomarbeit-en.pdf`.
7. **Identitaet ohne Trailer** - alle Commits dieses Repos unter Owner-Identitaet, kein Agenten-Trailer
   (s. Kopf).

Zusatz-Bedingungen ausserhalb der CI: Aufgabenblatt-PDF (C4) und die Ergebnis-Einspeisung nach der
Voll-Messung (C5) sind Abgabe-Voraussetzungen, aber **nicht** CI-pruefbar.

---

## 5. Offene Punkte - repo-lokal

- **T1** C7-Haertung: Lint-Gate gegen verschwundene `.tex` absichern (z. B. erwartete Dateiliste oder
  Mindest-Trefferzahl im `find`), damit eine geloeschte Quelle nicht still gruen bleibt. (offen, niedrig)
- **T2** C2-Nachzug (Testzahl + Anhang-B-Stichtag) exakt beim Einfrieren der ce-Linie ausloesen - der
  Ausloeser muss im super-LEDGER terminiert bleiben, damit er nicht vergessen wird. (terminiert)
- **T3** C3-Plattform-Nachzug (RISC-V, macOS M1, macOS x86) erst nach realem Bestand im Cluster
  einarbeiten - vorher waere die Aussage im Text unbelegt. (gated)
- **T4** C6 Gitlink-Identity-Normalisierung liegt bei Infra; Nachfrage-Kanal ueber das super-Projekt.
  (fremd-blockiert)
- **T5** Konsistenz-Pflicht Lizenz-Matrix: Aenderungen an den Lizenz-Staenden der Code-Repos
  (ce = duales Modell, DA-Repo + PRT-ART = Apache-2.0) muessen in der Thesis-Lizenz-Matrix nachgezogen
  werden; einmalige Schluss-Pruefung vor Abgabe. (offen, mittel)
- **T6** [NEU 03.08.] Anhaenge-Realm-Einzel-Gliederungs-LUECKE: Befund-Doc 02.08. weist **8 Stuecke,
  DE+EN** aus (super-Task #6, startfrei). Umsetzung streng nach Sprach-Doktrin Abschnitt 1 (DE fuehrend,
  EN synchron) und Text-Doktrinen 1.1; laeuft PARALLEL zum ce-Hauptstrang (anderes Repo, disjunkt).
  (offen, startfrei)

---

## 6. Quellen (Voll-Pfade)

- super-LEDGER: `probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`
- ce-Ledger: `.../Code/external/comdare-cache-engine/docs/ledger-sections/architektur-ziele-offene-punkte-ledger.md`
  (+ Zusatz-Ledger `goal-v6-luecken-ledger.md` im selben Verzeichnis)
- prt-art-Ledger: `.../Code/external/comdare-prt-art/docs/ledger-sections/architektur-ziele-offene-punkte-ledger.md`
- thesis-Ledger: **diese Datei**
- Katalog Abschnitt C: `.../docs/sessions/20260802-KATALOG-offene-strecke-gesamtplan.md`
- Owner-Entscheide 02.08.: `.../docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md`
- Bauplan 02.08.: `.../docs/sessions/20260802-BAUPLAN-owner-entscheide-synthese-kritischer-pfad.md`
- ce-ABGLEICH 03.08.: `.../Code/external/comdare-cache-engine/docs/sessions/20260803-ABGLEICH-katalog-gesamtplan-ist-stand.md`

---

## 7. Fortschreibung 2026-08-03 (E-02-Nachzug)

> Quellen: super-KATALOG (Abschnitt C) + ce-ABGLEICH 03.08. (Abschnitt B/C + "Neu seit dem KATALOG").
> Rein additiv; Bestandstext oben unveraendert (Ausnahme: Kopf-Zeile "Fortgeschrieben", Nachzug-Noten
> unter der C-Tabelle, Kanon-Abschnitt 1.1, T6, Quellen-Zeile ce-ABGLEICH - alles Zusaetze).

### 7.1 Ist-Anker (verifiziert 03.08., literal per `git rev-parse`)

- Repo-Linie: `main == origin/main == origin/development == b1ec8379` - enthaelt dieses Ledger
  (`0e39e1d`/`a0ba339` Anlage + `13b1b5a` Audit-Pflicht-Kopfsatz) UND den Sprachpass C1-Rest
  (`a53c5ec`/`e525a5a`/`b1ec837`). Der LOKALE `development`-Zeiger im Klon steht stale auf `13b1b5ab`
  (Vorfahr von `b1ec8379`) - reiner Zeiger-Nachzug, kein Inhalts-Delta.
- super-Einhaengung: der Gitlink `thesis/diplomarbeit` im super-Repo steht auf `b1ec8379` - dieses
  Ledger ist damit ueber den super-Klon SICHTBAR (anders als das prt-art-Ledger, dessen Gitlink auf
  dem Vor-E02-Stand `32e8ffa8` steht; Owner-Vorlage V5, gefuehrt im prt-art-Ledger 6.1).
- Arbeitsfront-Einordnung (ce-ABGLEICH): Task #6 (=T6) ist STARTFREI und laeuft parallel zum
  ce-Hauptstrang; C1-Rest = Verifikation des Entwurfs-Stands.

### 7.2 Korrektur-Vermerk (Buchfuehrung)

- ce-ABGLEICH 03.08., Zeile A16, fuehrt E-02 als "VERIFIZIERT NICHT hergestellt (kein prtart-/
  thesis-Ledger)" - fuer DIESES Repo widerlegt: das Ledger existiert committet seit 02.08.
  (`0e39e1d`/`13b1b5a`) und ist in `b1ec8379` (== super-Gitlink) enthalten. Der offene E-02-Rest
  betrifft NUR die prt-art-Gitlink-Sichtbarkeit (V5) und die Korrektur der ABGLEICH-Zeile.

### 7.3 Prozess-Erinnerung fuer jeden Ledger-Touch in diesem Repo

- Commit-Identitaet: `Benjamin-Elias Probst <benjamineliasprobst@gmail.com>`, OHNE jeden Trailer
  (Kopf-Doktrin; pruefungsrechtlich). Commit-Sprache Deutsch, beschreibender Stil, Praefix "Ledger: ..."
  (Praezedenz `13b1b5a`).
- Push zu BEIDEN Remotes (origin=gitlab, github=Sicherung), main-Nachzug je Welle, Pipeline hart gruen
  (die 4 Job-Instanzen aus Abschnitt 3); nie rebase, immer merge.
