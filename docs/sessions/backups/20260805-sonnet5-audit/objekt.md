# OBJEKT-VERIFIKATIONS-LENS Sonnet-Landungen (05.08.2026, abend)

READ-ONLY-Audit am Repo/API/Session-Store. Prueffelder: Ledger-Nachtraege nachmittag-1..9,
super-Commits afa6842e/432a130c/69dd9fb7/409757b0/947afe78/48093a6d/887d57b5/8baa7082,
ce-Landungen 18fbb950/3bf03b01/60c7c56a. Jede Behauptung mit literalem Kommando + Ausgabe.

Repos:
- ce    = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine
- super = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine

---

## (1) rescue-Refs — KONFORM (beide Remotes, beide Repos)

`git -C <ce> ls-remote origin 'refs/rescue/*'` UND `... github ...` enthalten BEIDE:
```
deee64066b116c51e199dfb32aa91feaa316f3a0  refs/rescue/anker-a2-deee6406
0bee08bfa0ebb7dc2953aca9f3b76cf0919e35b0  refs/rescue/w1-planer-split-0bee08bf
```
`git -C <super> ls-remote origin|github 'refs/rescue/*'` enthaelt BEIDE:
```
5046c39bbaa6e59bf86df0e8c4ffed0b5e6a98a2  refs/rescue/w1-super-5046c39b
```

## (2) tree-identisch + Merge-Form — KONFORM

```
git -C <ce> rev-parse 18fbb950^{tree} deee6406^{tree}
  be5080b4ce29c6685b1b590d824f57317b5dee84   (2x identisch)
git -C <ce> rev-parse 3bf03b01^{tree} 0bee08bf^{tree}
  127ee8018bd043962cd2bcf08b82037ac406928b   (2x identisch)
git -C <super> rev-parse 409757b0^{tree} 5046c39b^{tree}
  2f3d0c6464031d202d5a5c79463045e33e13a5fd   (2x identisch)
```
Merge-Struktur (echtes --no-ff, 2 Eltern):
```
18fbb950 Eltern: 24e07219 deee6406
3bf03b01 Eltern: 18fbb950 0bee08bf
409757b0 Eltern: 432a130c 5046c39b
```
main-FF-ERGEBNIS: `git -C <ce> rev-parse origin/main origin/development github/main github/development`
=> 4x `60c7c56ad7e072e700301f56564f189b02f4f157`. super: `merge-base --is-ancestor 8baa7082 origin/main` => JA;
super main==development (aktuell 603f15f4, enthaelt die gesamte Kette). Gitlinks:
`git -C <super> ls-tree afa6842e Code/external/comdare-cache-engine` => 160000 18fbb950...;
`... 409757b0 ...` => 160000 60c7c56a... KONFORM.
NIE-rebase: alle Landungen als Merge-Commits mit 2 Eltern belegt.

## (3) CI-Beweise am VOLL-SHA — KONFORM

PAT-Check `GET /api/v4/user` => HTTP 200. Projekt 286 (ce):
```
GET /projects/286/pipelines/14659 =>
  sha=18fbb950a83e2c15f7a24a66125bfefe2975a280 status=success ref=development (12:12-12:16Z)
GET /projects/286/pipelines/14674 =>
  sha=60c7c56ad7e072e700301f56564f189b02f4f157 status=success ref=development (14:12-14:15Z)
GET /projects/286/pipelines/14673 => sha=3bf03b01... status=failed
  (deckt die Ledger-Angabe "CI-ROT 14673 lint:static -> Hotfix 60c7c56a" — ehrlich deklariert)
```
Jobs 14659/14674: alle 17 Jobs success, nur `is_original:relock` manual (Kanon). Projekt 288 (super):
```
GET /projects/288/pipelines?sha=8baa70829eb8997db7b6b2bee1e5902c3cb074a0 =>
  14699 success main / 14698 success development
```

## (4) TABU-/Fingerprint-Beweise nachgefahren — KONFORM

```
git -C <ce> diff 24e07219..18fbb950 -- libs/cache_engine/include/cache_engine/abi/ | wc -l  => 0
git -C <ce> diff 24e07219..60c7c56a -- libs/cache_engine/include/cache_engine/abi/ | wc -l  => 0
git -C <ce> grep -l "0fe275bd" 60c7c56a  => GENAU 3 TUs:
  tests/unit/test_g3_sha512_index.cpp / test_m_w12_stamp_bausteine.cpp / test_w10_system_cell_values.cpp
golden-CRC F1C1F26A1232073B: 5 Traeger-Dateien an 60c7c56a (adhoc_emitter.hpp, abi/anatomy_fingerprint.hpp,
  merge_plan.hpp, sota_catalog.hpp, source_catalog.hpp) — je Datei diff 24e07219..60c7c56a => 0 Zeilen;
  identische Traeger-Menge bereits an 24e07219.
git -C <ce> diff 24e07219..18fbb950 -- '*.xml' | wc -l  => 0   (ebenso ..60c7c56a => 0)
```
L14/Overlay: `git grep COMDARE_OVERLAY_SOURCE_HASH 18fbb950` => 9 Zeilen in 7 Dateien, davon GENAU EINE
funktionale Definitions-Stelle (abi/anatomy_fingerprint.hpp:83-86 #ifndef/#define/kOverlaySourceHash);
die uebrigen 8 sind Kommentar-Erwaehnungen ("Muster COMDARE_..."). Die Ledger-Formel "genau EINE Fundstelle"
gilt in der funktionalen Lesart — Praezisions-Caveat, kein Verstoss.
Konfliktmarker-Wache (3-Marker, Zeilenanfangs-Form) heute nachgefahren:
`git grep -l -E '^(<<<<<<< |======= *$|>>>>>>> )'` an 18fbb950/3bf03b01/60c7c56a/409757b0 => je 0 Dateien.

## (5) Gate-Zahlen — KONFORM (405 literal reproduziert; Wachstum exakt die 2 neuen TUs)

```
cd /home/comdare/wt-w2fix/build-w2fix-gate && ctest -N | tail -1  => Total Tests: 405
cd /home/comdare/wt-w2fix/build-w2fix      && ctest -N | tail -1  => Total Tests: 405
```
(wt-w2fix = Branch w2-codex-fixes @ e3fc1b98, 3 Commits ueber 60c7c56a, KEINE neuen TUs => 405 gilt fuer 60c7c56a.)
Registrierungs-Diffs:
- 24e07219..18fbb950: add_executable/add_test `test_a2_sha512_skip_gate` NEU (Datei @18fbb950 existiert,
  @24e07219 nicht) => 403->404.
- 18fbb950..3bf03b01: add_executable/add_test `test_w2_combo_ct_stamp` NEU => 404->405.
Genau die 2 behaupteten TUs, keine weitere Registrierung.
EINORDNUNG CI: test:unit-Traces (Jobs 361122/361293) zeigen "100% tests passed, 0 tests failed out of 357"
bzw. "... out of 362" — CI faehrt eine Label-Teilmenge (Mess-Kanon CI-Gruen=Messung AUS); KEIN Widerspruch,
aber die literalen 404/405-Doppellaeufe sind NUR lokal attestiert (s. nicht_pruefbar).

## (6) Ledger-Verbatim-Proben — KONFORM (alle 4 Bloecke EXAKT; roh/-Fenster war dafuer UNGEEIGNET)

Das Schwester-Lens-Fenster roh/fenster_105250_105614.jsonl enthaelt die 4 Owner-Bloecke NUR als Read-Echo
des Ledgers selbst (Zeile 194, toolUseResult.file.filePath = DIPLOMARBEIT-...-LEDGER.md, 16:03Z) — eine
Verbatim-Pruefung dagegen waere ZIRKULAER. Direkt am Session-Store verifiziert
(Sonnet-Session /home/comdare/.claude/projects/-home-comdare/b15ade0e-c0d2-4959-8fbb-95f6c0bddf45.jsonl):
- nachmittag-1 ("Der Atlas sieht jetzt gut aus...") ORIGINAL user-Message 12:16:08Z — EXAKT VERBATIM
  (ASCII-normalisiert ae/oe/ue, 1439 Zeichen).
- nachmittag-3 ("OK, aber es soll doch entweder CSV xor xlsx...") als queued prompt (attachment.prompt,
  12:26:43Z) — IDENTISCH.
- nachmittag-4 ("Ja, gehe davon aus, dass du den Atlas IMMER...") als queued prompt (12:27:25Z) — IDENTISCH.
- nachmittag-6 ("Hattest du eigentlich zuletzt die Claude Code Arbeitsweise...") ORIGINAL user-Message
  14:51:04Z — EXAKT VERBATIM (174 Zeichen).
E-21-Vollpersistenz inkl. queued_command.prompt-Falle ERFUELLT. (Der 5. VERBATIM-Block des Fensters,
mittag-11 "Jetzt ist alles korrekt...", liegt im roh/-Fenster als echte user-Message vor — prae-Sonnet.)

## (7) Workflow-Backups — KONFORM

super docs/sessions/backups/:
- 20260805-anker-a2-eichung/  = eich-wellen-plan.md + ergebnis-roh.json — verbucht in afa6842e
  (zusammen mit Session-Doc 20260805-SESSION-anker-vollzug-gate5.md + Gitlink 18fbb950 + Ledger).
- 20260805-w1-planer-split/   = w1-plan.md + ergebnis-roh.json + nachbesserung-roh.json — verbucht in 69dd9fb7.
- 20260805-a2-codex-bewertung/ = bewertung.md + ergebnis-roh.json — verbucht in 8baa7082.
- 20260805-atlas-runde5/      = korpus.md + review.md + ergebnis-roh.json — verbucht in 432a130c.
- 20260805-w5-w3-kern/        = plan.md + ergebnis-roh.json — inzwischen git-getrackt (war lt. nachmittag-10
  "unverbucht" — ehrlich deklariert, Nachbuchung erfolgt).
Je Welle Roh+Plan vorhanden.

## (8) Atlas REV 4/5 — KONFORM

docs/architektur/05b_uml_klassenatlas_20260805.html (mtime 05.08. 12:59 = 432a130c) + .md:
- REV-Vermerke: MD traegt "Korrektur-Vermerk ... REV 2", "REV 4 vereint drei Owner-Reviews" (Z.47, inkl.
  Klammer-Sektion #klammer + L4-Neugenerierung 0 lose Knoten) und "## REV-5-Vermerk (05.08.2026, ...)"
  (per `git show 432a130c` als Zugang belegt). HTML traegt "Owner-Review Runde 5 verbatim (LEDGER:4114-4118,
  nachmittag-1)".
- Klammer-Sektion: 30 Treffer "klammer", woertlich "Achsen-Arten-Klammer Mess/System/Organ" — VORHANDEN.
- Zukunfts-Sektion: "Zukunfts-Phasen (SOLL nach Plan)" — VORHANDEN (20 Treffer "zukunft"), inkl.
  Rueckschreibe-Kette XML->CSV->xlsx, XOR-Strategy (xlsx=Default, Serialisierer-FEHLT=46b), UNGEDECKT-Badges
  (12 Treffer), Hinweis-Regeln-Entwurf (Posten 91).

## Weitere nachgefahrene Behauptungen

- TP1-FINAL-Inventur: alle 9 benannten TUs existieren an 18fbb950; Marker TP1_ANKER_OK in
  test_tp1_planer_filter_iterator.cpp — Traeger real (der 9/9-Lauf selbst ist attestiert, s.u.).
- Keine stillen Entscheide: O-2 als markierter Owner-Gate-Task + Ledger-Vorlage; R-G2-Abweichung deklariert
  (Posten 92, Commit 69dd9fb7); W2-Offenposten (W-11, Codegen-Zielform) deklariert. KONFORM.
- Die 8 super-Commits existieren mit konsistenter Chronologie 12:20Z..15:27Z und decken die Nachtraege 1:1.

## BEFUNDE (Abweichungen/Risiken)

- B-1 (Audit-Input, nicht Sonnet): Das roh/-Fenster der Schwester-Lens enthaelt die Sonnet-Phase-Owner-
  Nachrichten NICHT als Originale — nur als Ledger-Read-Echo. Jede Verbatim-Pruefung allein auf diesem
  Fenster waere zirkulaer. Ausgleich hier: Direktpruefung am Session-Store b15ade0e (alle 4 EXAKT).
- B-2 (Praezisions-Caveat): "COMDARE_OVERLAY_SOURCE_HASH genau EINE Fundstelle" stimmt nur in der
  funktionalen Lesart (1 #define-Naht); literaler grep = 9 Zeilen (8 Kommentare). Empfehlung: Formel in
  kuenftigen Gate-Texten als "genau EINE Definitions-Naht" fuehren.
- B-3 (Literalitaets-Luecke CI vs lokal): Die Gate-Zahlen 404/405 existieren in KEINEM CI-Artefakt
  (test:unit-Teilmenge 357/362); die Doppellauf-Literalausgaben liegen nur in Commit-/Ledger-Attestierung.
  Gegenwarts-Reproduktion 405 via ctest -N gelungen; Restrisiko gering, aber die "2x seriell am
  Commit-Objekt"-Ausfuehrung selbst ist historisch nicht objektbeweisbar.
- B-4 (klein): super-Merge 409757b0 hat KEINE eigene Pipeline am Merge-SHA; die CI-Wache lief am
  Folge-Head 8baa7082 (14698/14699 success, enthaelt 409757b0) — im Ledger als "CI-Wache ... folgen"
  angekuendigt, also deklariert; strenge Voll-Kadenz-Lesart "Wache am Merge-VOLL-SHA" nur transitiv erfuellt.

## NICHT PRUEFBAR am Objekt (nur attestiert)

- Doppellaeufe 2x404/2x405 seriell mit frischem Configure AM COMMIT-OBJEKT (historische Ausfuehrung).
- golden-320 3/3, Roundtrip 4/4, Byte-Aequivalenz Alt-Treiber vs Planer-Binary ueber 6 Kanaele diff 0.
- Lead-cf22 voller Diff (kein clang-format 22.1.8 auf dieser Maschine im PATH) und gitleaks-podman-Laeufe
  (2/clean bzw. 4/clean) — Re-Ausfuehrung unterblieb (read-only-Budget); Umfeld-Evidenz konsistent.
- Prozess-Form des main-FF (gepinnter SHA statt rev-parse HEAD) — nur das ERGEBNIS (alle Heads korrekt)
  ist beweisbar.

## GESAMTURTEIL

Alle 8 Prueffelder am Objekt BESTANDEN; keine einzige Sonnet-Behauptung widerlegt. Zwei Praezisions-
Caveats (B-2, B-4), eine Literalitaets-Luecke (B-3, klassenbedingt: lokale Gates hinterlassen keine
CI-Artefakte) und ein Audit-Input-Mangel der Schwester-Lens (B-1, hier ausgeglichen).
