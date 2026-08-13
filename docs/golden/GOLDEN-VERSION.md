# GOLDEN-VERSION -- DER ANKER DER GOLDEN-DATENBASIS (Registry, Erstausgabe)

> **Angelegt:** 2026-08-13 (A2.5-Fix-Stufe, Posten NE-13 [STR-10], Schwere BLOCKER) ;
> **Konsument:** Task #16 "golden festschreiben -> Homes MESS/SYSTEM + S-18-Waechter" --
> dieses Dokument IST die festgeschriebene golden-Datenbasis-Version, an der sich jede
> spaetere Umgliederung misst. ;
> **Owner-Deckung:** KON27-01, Owner verbatim 12.08.2026 (ASCII-Transliteration wie im
> Ledger-Kopf KON58-01): *"Wir beginnen aber zuerst mit einer gueltigen golden Version."*
> **Pflege-Regel:** Aenderungen NUR additiv (neue Version = neuer Abschnitt OBEN, alte
> Abschnitte bleiben stehen -- Doku-Deprecation, nie Loeschung).

## 1. WARUM DIESES DOKUMENT EXISTIERT (die Stellvertreter-Korrektur)

KON58-01 verbuchte die Lock-Baseline `a8465ef3` ("golden-Baseline auf 158 Traeger
festgeschrieben"). Das ist ein STELLVERTRETER: `a8465ef3` friert den ACHSEN-LOCK ein
(158, seit Fixup 3: 718 `<Pfad,Digest>`-Records der Organ-/Heuristik-Traeger), nicht die
golden-DATENBASIS. Die Datenbasis, gegen die golden-Neutralitaet gemessen wird, sind die
vier `golden_fullpilot_320*`-Fixtures im ce. Beide Anker sind noetig und verschieden:

    ACHSEN-LOCK  (a8465ef3, S-14a-Riegel)   bewacht Traeger-DRIFT (Digest je Header)
    GOLDEN-DATEN (dieses Dokument)          bewacht die 320er-ID-BASIS (Fixtures selbst)

## 2. GOLDEN-VERSION G-2026-07-26 (Erhebung 13.08.2026, geltende Basis)

Gemessen am super-Gitlink `f23c18e2` (ce, super-HEAD `a82078cb` vom 13.08.2026); jede
Zahl am Objekt erhoben (`git show <gitlink>:<pfad>` -- bewusst NICHT die Arbeitskopie,
PZW-CE-SHA-Lehre). Nenner je Datei: 320 id-Zeilen + Kommentar-/Leerzeilen = Gesamt.

Flache Records (ein Feld je Zeile, alle Pfade relativ ce `tests/unit/thesis_tiere/`):

    FIXTURE golden_fullpilot_320_binary_ids.txt
      ids=320  zeilen_gesamt=326  letzter_commit=774a5d5f  datum=2026-07-26
      sha256=65e35415323f1f73439ec698ce9b4f0fbae26e7206ee2b08f9864c5449eb410a
    FIXTURE golden_fullpilot_320_binary_ids_abi4.txt
      ids=320  zeilen_gesamt=323  letzter_commit=14c6eaae  datum=2026-07-17
      sha256=665db1661eba5db16050454a9f5178fc9fcc794aa6b8efb8257124bfd8bc5fd9
    FIXTURE golden_fullpilot_320_binary_ids_abi5.txt
      ids=320  zeilen_gesamt=325  letzter_commit=5c5dbb8c  datum=2026-07-18
      sha256=3e11f402df381e10da8e46690bd81ac4d3649973c0c0da1fcdaedf1163a92d4c
    FIXTURE golden_fullpilot_320_binary_ids_abi6.txt
      ids=320  zeilen_gesamt=327  letzter_commit=774a5d5f  datum=2026-07-26
      sha256=82ce616884358d2d12e3af2a8ff82b7138815723e5e06b76a8c01a6803babb0f

**Versions-Name G-2026-07-26** = Datum des juengsten fixture-beruehrenden ce-Commits
(`774a5d5f`); seither 0 Aenderungen an den vier Dateien (4 von 4 unveraendert bis zum
Gitlink `f23c18e2`).

**Struktur-Anker (Quelle der 320, unabhaengig von den Fixtures -- T-3 fremder Nenner):**
ce `libs/cache_engine/profile_facade/source_catalog.hpp:145`
`golden_320_catalog = CatalogAxes<4,1,1,1,4,5,1,4, 1...>` (4*4*5*4 = 320) und `:173`
`static_assert(catalog_axis_product<golden_320_catalog>() == 320u, ...)`.

**Erhalts-Gate (wie golden-Neutralitaet gemessen wird):**
`git diff --exit-code -- tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids*.txt`
RC=0 + static_assert `== 320` unveraendert (Form aus `20260806-PLAN-golden-update-fenster.md`
A6/TABU-1; Hart-TABU seit Ledger `:153`).

## 3. WAS DIESES DOKUMENT NICHT DECKT (beide Mengen benannt)

* NICHT gedeckt: das Mess-golden `experiment_golden`/`kNewGolden131072Crc64` (2^17-Raum,
  CRC64-Anker) -- eigener Gegenstand mit eigenem Update-Fenster-Plan (siehe
  `docs/plaene/20260806-PLAN-golden-update-fenster.md`); Alt-golden darf brechen
  (Memory-Doktrin), die 320er-Basis hier NICHT.
* NICHT gedeckt: der Achsen-Lock (a8465ef3/718 Records) -- der hat sein eigenes Werkzeug
  (S-14a-Riegel v2/v3, KON58-01) und seinen eigenen CI-Job.
* Gedeckt sind GENAU die vier Fixture-Dateien oben (4 von 4 mit sha256).

## 4. BESTANDS-BEFUND (A2.2, vor Anlage gemessen 13.08.2026)

`/usr/bin/grep -rni "golden.*version|GOLDEN_VERSION"` ueber `ci/`, `scripts/`,
`docs/plaene`: 0 existierende Registry/Konsum-Datei (Treffer nur Prosa in Plaenen und
die zwei CI-Mess-Jobs `measure:smoke`/`measure:golden-320`, die die Fixtures via ce
referenzieren, keine Versions-Registry). `docs/golden/` existierte nicht. Diese Datei
ist damit Erstanlage, keine Zweitfassung.
