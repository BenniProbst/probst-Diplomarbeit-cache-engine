# OWNER-VORLAGE 13.08.2026 — SAMMELRUNDE VOR DEM KOMPLEX-FIX (Welle 2 komplett zurueck)

> **Anlass:** Owner-Auftrag: alle offenen Rueckfragen und Entscheidungen buendeln, nachdem alle
> Workflows zurueck sind und vollstaendig gelesen wurden. Stand: 9 von 9 Wellen-Workflows
> KOMPLETT (je Bau+Verify+A2.5-Fix), 64 Findings + Pausen-Sorgfalts-Auflage in der Sammelliste,
> Regressions-Gesamtbild (152 Outputs) liegt bereit.
> **WICHTIG: KEINE dieser Fragen blockiert die Drei-Stufen-Landung** (Merges+Harmonisierung ->
> Komplex-Fix -> EIN Push) — sie betreffen Folge-Arbeit. Die Landung ist startbereit und wartet
> nur auf Dein GO. Jede Frage in einem Satz beantwortbar.

---

## BLOCK A — FRISTGEBUNDEN

**A1 · C-3a Comp-Gate-Paket-Entscheid** *(Frist Mi 19.08., Vorlage liegt: 136a1798)*
Frage: Welche Organ-Achse bekommt die ERSTE echte required-Deklaration (aktiviert das gebaute
Comp-Gate; heute alle Mengen leer = inert)? — Ohne Antwort bis Mi zieht die Fallregel 18.6(3)
(#38a2 rutscht ins W2-Bump-Buendel, Freeze-Nachbuchung deklariert).
S-7-Zusatz: die Zulassungs-Bruecke ist jetzt gebaut und nachweisbar inert — Deine Antwort
aktiviert beide Gates in einem Zug.

**A2 · MinIO-Keys neu erzeugen** *(Vorlage liegt: a82078cb Frage 1)*
Frage: Erzeugst Du (oder Infra) neue MinIO-Keys fuer beide Endpunkte? — Blind-Smoke ist ROT
(kein gueltiges Paar im Vault, Koeder-gedeckt); blockiert den MinIO-Rueckschrieb-Systemtest
(W3-Strecke), nicht die Landung.

## BLOCK B — NEUE ENTSCHEIDE AUS WELLE 2

**B1 · F-G1-11: Kind-Stempel-Form (w-Sichtbarkeit)** *(wichtigste G-1-Frage; Review-Hauptfund)*
Dein Wort „CEB gibt wallclock build auf der naechsten Traeger-Stufe frei" macht das
Tier-KOMPILAT w-abhaengig — die vorgeschlagene Slot-Projektion war w-blind (Alias-Klasse).
Drei Optionen, bewusst ohne Default:
  (i) Kinder stempeln den VOLLEN Vertrags-Ausdruck (loest auch den Anordnungs-Verlust),
  (ii) Projektion fuehrt vertragswirksame Fremd-Slot-Instrumente als Kontext mit,
  (iii) w gilt als reines CEB-Selbst-Instrument ohne Tier-Naht (widerspraeche Deinem
        B3-Satz „Die Tier-Gates bleiben" — muesste ausdruecklich widerrufen werden).
Frage: (i), (ii) oder (iii)?

**B2 · G-1 als Ganzes: Profil-Entscheid + Vokabular** *(Design liegt final, 540 Z., reviewt)*
Frage: Bestaetigst Du G-1 als PROFIL der bestehenden v2-Grammatik (EIN Parser; M-1) mit dem
Kurz-Vokabular m / b h t / w ma mi (Kollisions-Erhebung: 0 von 8 im 62er-Katalog)? —
Die uebrigen F-G1-Fragen (Planer-Slot, Vererbung, PMC, Lastsequenz, Anordnung, F-G1-12
Tooling-id) stehen nummeriert im Design; Antworten dort genuegen je in einem Satz.

**B3 · Zielstruktur-Defaults** *(Design liegt final, 199 Z., reviewt; Bau erst WE/nach S-8-Plan)*
Frage: Einspruch gegen die Defaults? — libs/traeger/{planer,ceb,tier,hybrid} als Wurzel ·
heuristik/ -> HYBRID · mess/-Kaskade -> TIER (Naht-Typen -> Querschnitt) · adjazente
Stufen-Kanten. OFFEN als Namens-Detail: „planer" (DE, neu) neben bestehendem
profile_facade/„planner" (EN) — Kollision VOR dem ersten Umzug entscheiden.

**B4 · ##26-Formel: harter M==N-Zweig oder Formel angleichen** *(Widerspruch Wache vs. Plan)*
Die Wache laesst leere CSVs als WARNUNG durch (Dein Sichtbarkeits-KERN), der Plan verlangt
M==N hart. Empfehlung: harten Zweig NUR bei modus=voll (leere Datei im Vollmodus = rot),
Warnung bleibt fuer provision/pruef — erhaelt beide Doktrinen. Frage: so bauen?

**B5 · kVollausbau-Zulassung** *(S-7-Randfrage)*
Der 59-Knoten-Vollausbau ist bewusst NICHT signaturfaehig (T-4-Gegeneingang). Frage: soll das
so bleiben (Empfehlung: ja), oder erwartest Du spaeter Vollausbau-Zulassung (dann additiver
23er-Signatur-Katalog-Ausbau als eigener Posten)?

## BLOCK C — INFRA (Owner-GO oder Infra-Agent)

**C1 · A-3-Token-Rotation** *(Dein GO vom 10.08. ist NICHT vollzogen; KON58-04)*
776 Runner-Registration-Token; die Instanz akzeptiert weiterhin Registration-Tokens.
Frage: Reset JE PROJEKT oder INSTANZWEIT (Infra-Handout folgt dann)?

**C2 · Umbrella-CI strukturell rot** *(seit 06.03.; macOS-/Windows-Jobs ohne Runner)*
Unsere ARBEITSWEISE-Pushes (v4.0–v4.3) koennen dort nie gruen werden; allow_failure ist
verboten. Frage: (a) Runner bereitstellen, (b) Job-Rules auf vorhandene Runner einschraenken,
oder (c) Doku-only-Pipeline fuer docs/-Aenderungen? Empfehlung: (b) als kleinster Schnitt.

**C3 · TeX im gitlab-runner-Job-PATH** *(Kenntnisnahme + ggf. Infra)*
Das PDF-Gate ist jetzt hart on (fail-closed). /usr/local/bin traegt seit 03.07. Symlinks —
der erste scharfe anhang:forward-Lauf beantwortet empirisch, ob der Runner sie sieht; wenn
nicht, ist der Lauf LAUT rot (gewollt) und TeX-in-PATH wird ein Infra-Posten. Kein Entscheid
noetig, nur Kenntnisnahme.

## BLOCK D — KENNTNISNAHMEN + EINE ALTFRAGE

**D1 · Backup-Ref pre-secret-scrub-20260802:** bereits am 10.08. mit Deinem „volles GO"
geloescht (Kette am Roh-Transkript belegt: Vorlage 12:20Z -> GO 12:40Z -> Loeschung 12:43Z ->
Vollscan 776->0). Die MinIO-Vorlage Frage 2 ist damit Kenntnisnahme, keine Frage mehr.

**D2 · E-2 Merge-Stempel:** die 10.08. erbetene „mit mehr Kontext"-Neuvorlage ist
GEGENSTANDSLOS — Dein Owner-E2 vom 02.08. ist am Objekt vollzogen (merge_stamp ersatzlos
entfernt, dreifach belegt). Zwei stale Ledger-Zeilen bekommen Marker.

**D3 · E-4c KON-57/E-26 TEST-SKIP** *(die EINE echte Altfrage des E-Blocks, mit viel Kontext)*
Bau-Seite („Gebaut wird immer, skip ist VERBOTEN") und Lager-Seite (Skip nur fuer gueltigen
Bestand) sind entschieden. OFFEN allein die TEST-Schicht aus Deinem E-26 („Wir kompilieren und
Testen nur Aenderungen neu") gegen „Pipeline hart gruen":
Frage: bleibt VOLL-ctest in jeder Pipeline Pflicht (Empfehlung — heutige Praxis, Kombibau
4 Zellen), oder ist Fingerprint-basierter Test-Skip zulaessig (dann eigener Wachen-Posten)?

**D4 · Landender Riegel-Echtfall:** S-7 lag ausserhalb der Lock-Domaene (Praemisse war stale);
die Wache ist per transienter Echtbaum-Probe kryptographisch bewiesen (ROT->Regen->GRUEN).
Der erste LANDENDE Echtfall ist als Pflichtschritt beim naechsten echten algo_version-Bump
(S-6-Fenster/Bump-Buendel W1) eingeplant. Kenntnisnahme.

---

## WAS NACH DEINEM GO SOFORT LAEUFT (kein Entscheid, Blanko-GO-gedeckt)

DREI-STUFEN-LANDUNG (v4.3/A2.1b): serielle Merges mit Harmonisierung (ce: S-7 178bb1fb +
Wachen 07a60cc7 + p6-Lizenz f6d13dfb + Registry-XML-Regen [F1-Lens N1]; super: F1-Paket
8e9a31d2 + texgate 5363eebb + e21 fe7bb459 + 8 lokale Commits + Designs + Ledger-Nachtrag)
-> KOMPLEX-FIX (ein Fable-5-max-Workflow: Merge-Regressionen + 64-Findings-Liste +
Pausen-Sorgfalt P1-P4 gegen die Original-Auftraege) -> EIN Push je Repo, EINE CI, Gitlink-
Bump + PZW -> F1-ECHTLAUF (Messung + ANHANG_FORWARD, bash-Rezept) -> F1-Endbeleg.
