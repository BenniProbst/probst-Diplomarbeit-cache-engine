# Randbestand-Audit der 4 Alt-Refs (#66, 15.08.2026)

Sammel-Audit vor der origin-Loeschung. Basis: origin/development @ 334b67b0 (KON72).
Bundle: `randbestand-4refs.bundle` (sha256 nebenan) traegt ALLE 4 Tips mit Basis
^origin/development; `git bundle verify` OK, list-heads = 4/4 mit den Soll-SHAs.
Restore: Klon mit development vorhanden -> `git fetch <bundle> <ref>:<ziel>`.

## Bestandslage vor Loeschung (ls-remote, Nenner)

- origin: 2 von 4 vorhanden (b-checkheft-nachtrag 74c1e780,
  b-ci-rueckschrieb-beide-zeiger 18a0bdf3). landung/gitlink-aebc4f2c-OBSOLET und
  wip/luecken-stufe2-pause-1308 existieren auf origin NICHT (nur lokal).
- github: 0 von 4.
- backup/pre-*-Refs: auf origin nicht vorhanden (Muster-ls-remote leer) — nichts
  angefasst.
- Lokal: alle 4 als Branches vorhanden; sie BLEIBEN lokal stehen.

## Urteile (je 1 Satz mit Beleg)

1. `b-checkheft-nachtrag` @ 74c1e780 (06.08., "docs(ledger): A-7/A-8 ENTKRAEFTET
   ... REGEL-ZEILE 17", 1 ahead / 530 behind): ENTHALTEN — `git cherry
   origin/development` meldet `-` (patch-aequivalent in dev gelandet, 23
   Ledger-Zeilen), Loeschung verlustfrei.
2. `b-ci-rueckschrieb-beide-zeiger` @ 18a0bdf3 (06.08., "ci(thesis): Rueckschrieb
   bumpt BEIDE Thesis-Gitlinks + Paritaets-Wache", 1 ahead / 532 behind):
   DOPPELT GESICHERT — `git cherry` meldet `-` (patch-aequivalent in dev) UND
   ls-remote zeigt `18a0bdf3... refs/heads/rescue/thesis-gitlink-paritaet-20260810`
   = SHA-IDENTISCH, der Commit bleibt dort woertlich erhalten; Loeschung des
   Branch-Namens verlustfrei. (Der Hauptklon wurde VORHER von diesem Branch auf
   development umgeparkt; sein ungesicherter Arbeitsstand liegt als NUR-lokaler
   Commit 87d70adf auf dem lokalen Branch.)
3. `landung/gitlink-aebc4f2c-OBSOLET` @ e4c1488d (09.08., "chore(vendoring):
   Gitlink ce 2eb310ae -> aebc4f2c + PZW-Anker -- nach dem main-FF", 1 ahead /
   242 behind, cherry `+`): NICHT patch-enthalten, aber UEBERHOLT — devs
   ce-Gitlink steht heute auf 0817c7bf (juengere atomare Bumps der Lande-Zuege),
   der aebc4f2c-Stand ist damit gegenstandslos; Branch-Name deklariert selbst
   OBSOLET; Bundle sichert, Loeschung vertretbar.
4. `wip/luecken-stufe2-pause-1308` @ 6b89fce5 (13.08., "PAUSE-Sicherung Stufe 2
   ... UNGEPRUEFT ... Resume: wf_046aab6c-928", 1 ahead / 70 behind, cherry `+`):
   KERN ENTHALTEN, REST UNGEPRUEFT-WIP — das 7858-Zeilen-Backup 01-wtk6lmhln.json
   liegt blob-identisch (0b8cad13) an GLEICHER Stelle in dev plus Zweitkopie
   (20260814-regressions-gesamtbild/), einzig verbleibend sind 21 Diff-Zeilen
   ungeprueftes Wachen-WIP (anker_wache/tests_registrierung_wache) und ein
   5-Zeilen-Header-Stub minio_blind_smoke_v2.sh (durch #10-Vollzug ueberholt);
   beides traegt das Bundle, das Resume-Journal wf_046aab6c-928 ist zusaetzlich
   in der Folge-BU 20260815-folge-bu-kontext7 gesichert; Loeschung vertretbar.

## Vollzug

- Loeschung auf origin: nur die 2 dort existierenden Refs; Gegenprobe ls-remote
  SOLL 0 von 4 Treffern. github: nichts zu loeschen (0 von 4).
