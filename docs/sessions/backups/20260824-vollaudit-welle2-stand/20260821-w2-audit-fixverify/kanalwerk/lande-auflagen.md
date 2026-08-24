# LANDE-AUFLAGEN -- Strang kanalwerk (S2 / E-2 / #90 P-A)

Angelegt 23.08.2026 vom Fable-max-KONVERGENZ-PRUEFER (Fix-Verify-Fortsetzung nach Riss).
ADDITIV: `soll-karte.md` und `audit-runde-1.md` wurden NICHT veraendert (BU-additiv-Doktrin);
kein Repo-, Ledger-, Board- oder Memory-Schreiben; ASCII-only.

--------------------------------------------------------------------------------
## 0. STAND UND WARUM KEINE FIX-RUNDE GEFAHREN WURDE

- Juengster Verdikt-Stand = `audit-runde-1.md` Z.142 literal:
  "**SITZT** -- 0 ERNST, 0 MILD, 1 KLEIN (K-01, traegergebunden im S13-07-/docs-Nachzug
  mitziehbar)." Es gibt keine fix-runde-*.md und keine hoehere audit-runde.
- Gegengelesen: `../GEGENLESE-GATE.md` Z.39 fuehrt kanalwerk als
  "audit-runde-1 | SITZT (0/0/1 KLEIN K-01) | SITZT (0/0/1 KLEIN K-01) | OK (T12)".
- Design-only-Strang: "kein Bau-Zweig, kein Worktree, kein Bau-Slot" (audit-runde-1 Z.6;
  soll-karte Z.6). Heute gegengeprueft: `git worktree list | grep -i kanalwerk` = 0 Treffer.
  Es wurde daher KEIN Bau, KEIN ctest und KEIN Bauslot-Marker beruehrt.
- Das Deliverable liegt als Commit 5b5a818f AUF development und ist inzwischen GEPUSHT:
  `git branch -r --contains 5b5a818f` -> `github/development`, `origin/development`;
  `git rev-list --count origin/development..development` -> `0`.
  Damit ist der in audit-runde-1 Z.133-135 getragene Posten H-17 ("Commit liegt lokal auf
  development, origin traegt ihn noch nicht") AM OBJEKT ERLEDIGT -- nachgemessen 23.08.2026.
- Beide verbliebenen KLEINs sind Text-Praezisierungen AN DIESER DATEI auf development.
  Die Strang-Regel dieses Pruefers verbietet Push auf development, und einen kanalwerk-Branch
  gibt es nicht -> Vollzug gehoert in den Lead-docs-Zug (T7-Sammel-Docs-Commit, SYNTHESE-S2 T12).
  Kein Lande-Blocker: beide KLEIN, Sachgehalt in keinem Fall falsch-fuehrend.

Objekt-Stand heute (23.08.2026, nachgemessen):
`wc -l docs/plaene/20260820-DESIGN-90-kanalwerk-arena.md` -> `414`;
`git status --short -- <Datei>` = leer; `git log --oneline -1 -- <Datei>` -> `5b5a818f`
(unveraendert gegenueber audit-runde-1 Abschnitt 0).

--------------------------------------------------------------------------------
## 1. AUFLAGE A-KW-1 (= K-01 aus audit-runde-1 Abschnitt 3) -- KLEIN, OFFEN

Datei: super `docs/plaene/20260820-DESIGN-90-kanalwerk-arena.md`, Abschnitt 1, Z.53-54.

IST (heute literal nachgelesen, unveraendert):
```
  -- verdrahtet ist `kapazitaet_zeilen_rechnen(n_ops, zeilen_je_op, drift_faktor)` mit
  drift_faktor <= 18 (`checkpoint_speicher.hpp:131`; KON92-Delta C7).
```
Befund (audit-runde-1 Z.99-117): Der dritte Parameter heisst am Objekt `sicherheitsfaktor`
(checkpoint_speicher.hpp:132, auch :117); `drift_faktor` ist LEDGER-Vokabular (KON94-02,
Ledger Z.2340); die "18" steht als Herleitung an :120-121, nicht an :131.

SOLL (Wortlaut-Entwurf, unveraendert aus audit-runde-1 Z.114-116 uebernommen):
```
  -- verdrahtet ist `kapazitaet_zeilen_rechnen(..., sicherheitsfaktor)`
  (`checkpoint_speicher.hpp:131-132`; Faktor-Herleitung :120-121; Ledger-Name
  drift_faktor(<=18) KON94-02, ab messfenster-Landung arena_gesamt_faktor=120).
```
Traeger: Lead-docs-Zug (T7-Sammel-Docs-Commit) bzw. mitziehbar im S13-07-Umbau-Commit.
Gegenprobe nach Vollzug: `grep -n "drift_faktor" <Datei>` darf nur noch Z.207 treffen
(dort ist es die S-19-Formel und BLEIBT als Ledger-Vokabular korrekt).

--------------------------------------------------------------------------------
## 2. AUFLAGE A-KW-2 (= KW-A1 aus dem ERSTLAUF) -- KLEIN, OFFEN, IN audit-runde-1 NICHT ERHOBEN

Quelle: `../ERSTLAUF-ENDBERICHT-wpmgr02yo-voll.md` Z.719, Agent "S2-audit:kanalwerk"
(verdikt SITZT), Fund literal:
"KW-A1 / KLEIN / E10-Quellenverweis nennt kontext9, arena_kette_karte.md liegt in kontext8".

Nachweis, dass dieser Fund in dieser Runde nicht erneut erhoben wurde:
`grep -n "KW-A1\|kontext9\|kontext8" soll-karte.md audit-runde-1.md` -> RC=1, 0 Treffer.

Datei/Stelle: super `docs/plaene/20260820-DESIGN-90-kanalwerk-arena.md` Z.303 (E10-Tabellenzeile).
IST (heute literal nachgelesen, unveraendert):
```
| E10 | Rest-Posten der KON92-Liste (im Ledger-Kopf nicht einzeln ausbuchstabiert -- Kern war E4-E9) | Quelle bei Bedarf: arena_kette_karte.md (Folge-BU-2, 20260816-folge-bu-kontext9) |
```
EIGENE OBJEKT-MESSUNG 23.08.2026 (Erstlauf-Beweis reproduziert):
- `find docs/sessions/backups -iname "arena_kette_karte.md"` ->
  genau EIN Treffer: `docs/sessions/backups/20260816-folge-bu-kontext8/arena_kette_karte.md`.
- `ls docs/sessions/backups/20260816-folge-bu-kontext9/` -> `explore_arena6gb_karte.md`,
  `explore_fulljoin_karte.md`, `ledger_gegenlese_karte.md` -- KEIN arena_kette_karte.md.
-> Der Verweis in Z.303 zeigt auf das falsche Folge-BU-Verzeichnis. BESTAETIGT.

SOLL: Ein-Wort-Korrektur in Z.303: `20260816-folge-bu-kontext9` -> `20260816-folge-bu-kontext8`.
Traeger: derselbe Lead-docs-Zug (T7-Sammel-Docs-Commit).
Gegenprobe nach Vollzug: `grep -n "kontext9" <Datei>` -> RC=1 (0 Treffer).

--------------------------------------------------------------------------------
## 3. LABEL-WARNUNG FUER DEN LANDE-ZUG (Vollzaehligkeit der beiden KLEINs)

`../SYNTHESE-S2-AUDIT.md` fuehrt in Z.11 unter dem Label "K-01" den INHALT von KW-A1:
"| kanalwerk | SITZT (0/0/1 KLEIN K-01) | kontext9->kontext8-Quellenverweis; traegergebunden
im S13-07-/docs-Nachzug |"; der Tip in Z.33 nennt nur "kanalwerk K-01 + e11-KLEINs in den
T7-Sammel-Docs-Commit". Der Zaehler "0/0/1" deckt also NUR EINEN der beiden Posten.

AUFLAGE: Der T7-Sammel-Docs-Commit muss BEIDE Textstellen nehmen -- Z.53-54 (A-KW-1) UND
Z.303 (A-KW-2). Beim Vollzug ueber WORTLAUT-ANKER gehen, nicht ueber Zeilennummern
(die Datei kann durch fremde docs-Zuege driften). Beide sind KLEIN, kein Lande-Blocker;
die Warnung dient allein der Vollzaehligkeit (NIE-KUERZEN-Doktrin, Dedup gegenzaehlen).

--------------------------------------------------------------------------------
## 4. NICHT BERUEHRT / UNVERAENDERT GETRAGEN

- F-91 (mess_arena.hpp Weitermessen-Politik) -> S13-05/06/07; F-92 (MEASURESTORAGE-Plan
  UEBERHOLT-Marker) -> Lead-docs-Zug; F-93 (OP-1-Kommentar :88-91) -> S13-07;
  F-94 (Kanalwerk/Kollektor UNGEBAUT, #53-gated) -- alle wie in audit-runde-1 Abschnitt 4,
  Zustand am Objekt heute unveraendert (keine neue Messung noetig, fremde Traeger).
- H-17: ERLEDIGT (Abschnitt 0, origin traegt 5b5a818f).
- Kein axes/ topics/ heuristik/, kein golden/TABU, kein CI-YAML, kein Ledger/Board/Memory
  angefasst; keine Datei in einem Repo geschrieben.

--------------------------------------------------------------------------------
## SELBSTCHECK

Juengster Stand SITZT -> keine Fix-Runde am Objekt gefahren (Regel 2), 0 Commits, 0 Pushes,
0 Bauslots. Zwei offene KLEINs literal am Objekt nachgemessen und mit Wortlaut-SOLL +
Gegenprobe hinterlegt (A-KW-1, A-KW-2); ein Zaehl-/Label-Risiko der Synthese ausgewiesen.
Zwei-Mengen-Klarstellung: geprueft wurde allein der kanalwerk-Rest-Fund-Stand am Design-Doc;
NICHT geprueft sind die fremden Traeger S13-05/06/07, #99/B-5f, I-8-Schema-Zug, Kollektor-Bau.
