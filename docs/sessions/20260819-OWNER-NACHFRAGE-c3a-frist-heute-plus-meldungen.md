# OWNER-NACHFRAGE 19.08.2026 -- C-3a (FRIST HEUTE) + INFRA-TERMIN + 2 MELDUNGEN

> Kontext 14, Zug 2 der Neugruendungs-Karte (A2.3a-geprueft: C-3a ist eine NACHFRAGE zur
> bestehenden Vorlage, keine neue Frage; die Meldungen kippen nichts, par.21.6-Tafel).
> Das uebrige F2-Vorlagen-Fenster (P1/P2/P3/P5/P6) kommt wie geplant MIT der #15-Landung.

## 1. C-3a -- ANTWORTFRIST HEUTE Mi 19.08. (einzige offene Owner-FRAGE des Kette-Strangs)

**Gegenstand (Vorlage `136a1798`, #38a1):** der Comp-Gate-Paket-Entscheid -- welche Pakete
tragen die ERSTE `required`-Deklaration der Organ-Pflicht (Tripwire am Objekt:
`simd_build_gate.hpp:272-278`; heute liefert `active_organ_required()` global `{}`,
d. h. ein Disk-Typ stempelt JEDE Binary, auch MemoryOnly -- #38a2-Flaeche).

**Fallregel, hiermit ausdruecklich DEKLARIERT (Wellenplan 18.6(3)):** kommt bis heute Abend
keine Antwort, faellt #38a2 deklariert ins W2-Bump-Buendel mit **Freeze-Nachbuchung** --
kein stiller Verzicht, der Freeze-Check Fr 21.08. bucht dann den deklarierten Fall.
Ein Satz genuegt: **(a)** Paket-Zuschnitt wie in `136a1798` empfohlen -- oder **(b)** 18.6(3).

## 2. INFRA-WARTUNGSFENSTER -- TERMIN-Frage (Rotation MUSS vor Mi 26.08.)

Die Rotation der Registration-Tokens 286/288/289 + D-3-Abschaltung
(`allow_runner_registration_token=false`, dein "Wie empfohlen") braucht ein GESPERRTES
Fenster VOR dem Bau-Trigger Mi 26.08. 06:00. **Das WE 22./23. ist ueberbucht**
(S-19 + T-15b + I-PMC + A-1; Slot-Vorschlag liegt in der K12-Meldung
`20260817-INFRA-MELDUNG-runner-token-rotation-wartungsfenster.md`).
**Frage (ein Satz): welcher Slot?** -- Empfehlung: **Do 21.08. abends nach dem
Freeze-Check** (kein Bau-/Messfenster beruehrt, vor dem Trigger, WE bleibt frei).
Rotation invalidiert registrierte Runner NICHT; Gegenprobe + Runner-Bestandsaufnahme
fahren wir direkt danach.

## 3. MELDUNGEN (Kenntnisnahme, kein Entscheid noetig -- Tafel par.21.6)

- **OV-5(b) prod2:** die damalige Begruendung ("prod2 existiert nicht", rc 2) ist AM OBJEKT
  ueberholt -- prod2 ist seit #60 online (Runner id=17, Gen-2-Kapazitaet 34,4 h gerechnet).
  Dein Textkorrektur-Entscheid BLEIBT; soll die pmc:intel-/P-E-Lane zurueckkommen, genuegt
  EIN Satz -- Bau-Platz W2/W3 existiert.
- **OV-4-Fakt:** die Vollmessung bleibt physikalisch >=143 Tage einthreadig -- der Deckel
  ist Mess-AUSWAHL, keine Feature-Kuerzung (NIE-kuerzen-Ordnung unberuehrt).

## 4. STAND IN EINEM ABSATZ (kein Handlungsbedarf)

Neugruendung K14 vollzogen (Kippen-Ritual 4/4 Dokumente komplett + ultracode-Analyse der
letzten 5 Kontexte, 7/7 Agenten). Das grosse Audit laeuft (Journal waechst, 71 results).
Parallel ab heute: g2/#17-Fertigstellung (Bau-Slot 1) + #95 V-08R-Bau (Bau-Slot 2);
Slot 3 bleibt fuer Fix-Strecke 2 nach dem Audit-Ruecklauf reserviert. Landungen strikt
seriell nach #15 (@ e285d316). F2-Freeze Fr 21.08. haelt nach heutigem Stand.

## 5. NACHTRAG (19.08. vormittags, aus dem Voll-Audit): E12 THESIS-TRAILER-RUECKKEHR (Owner-gated)

Das Voll-Audit fand: die Thesis traegt WIEDER einen Commit mit `Co-Authored-By: Claude Opus 4.8`
im Body — `09cc728` (18.06.), erreichbar von ALLEN Remote-Refs BEIDER Remotes (inkl. main;
vermutlich ueber die Owner-Overleaf-Linie `d2f51ca`/KON77 zurueckgeflossen — der #61-Rewrite vom
15.08. war zum Zeitpunkt sauber, 0/372). Dazu stehen lokale Thesis-Klone stale auf der
Vor-Rewrite-Linie. **Entscheid noetig (kein Handeln ohne GO — Remote-Loeschung):**
(a) erneuter gezielter Rewrite dieses einen Commits (beide Remotes, main-Protection-Zyklus wie
#61) — ODER (b) dokumentierte Ausnahme im Ledger (ein historischer Commit bleibt). Kein
#15-Bezug, keine Frist-Kopplung; die lokalen Klone ziehe ich nach deinem Entscheid nach.
