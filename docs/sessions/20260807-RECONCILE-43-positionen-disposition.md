# RECONCILE 07.08.2026 — Disposition aller 43 Positionen des Vollständigkeits-Audits

**Quelle:** `docs/sessions/20260807-AUDIT-ledger-vollstaendigkeit-43-positionen.json`
(`.result.funde[0..42]`, erhoben 07.08. ~09:40). Die Id `#n` in diesem Dokument ist der
1-basierte Index dieses Arrays (`#1` = `funde[0]`).

**Mess-Stand dieser Disposition (selbst ausgerechnet, nicht aus Text übernommen):**

| Gegenstand | Stand | Bemerkung |
|---|---|---|
| super `wt-super-landung` | `development` @ **`c26f8a77`** (07.08. 16:33) | == `origin/development` |
| Ledger (lebend) | **9619 Zeilen** | zur Audit-Zeit 7723 · +1896 Zeilen seither |
| ce `origin/development` | **`5788dc12`** (07.08. 16:27) | via `git -C /home/comdare/wt-landung rev-parse origin/development` |
| thesis `origin/development` | **`eaf7fe8`** | im Klon `20260931-overleaf-diplomarbeit` |
| prt-art | `development` @ **`c6f07540`** | |

> **Alle Ledger-Zeilennummern in diesem Dokument beziehen sich auf den 9619-Zeilen-Stand.**
> Die Zeilennummern des Audits gelten für den 7248-/7723-Zeilen-Stand und sind für alles
> ab Zeile 7250 verschoben oder gegenstandslos.

> **Titel sind verbatim aus dem JSON** und daher in dessen ASCII-Transliteration
> („Ueberfuehrung", „faellig"). Der eigene Fließtext ist orthografisch korrekt.

> **Ich disponiere, ich entscheide nicht.** Wo eine Owner-Entscheidung fehlt, steht sie als
> Frage — nicht als Ergebnis.

---

## 1. BILANZ

### 1.1 Die Zahlen

| Disposition | Anzahl | Ids |
|---|---:|---|
| **VOLLZOGEN** (mit Code-/Commit-Beleg) | **5** | #2, #10, #24, #34, #37 |
| **SUPERSEDED** (mit Nachfolger + Fundstelle) | **5** | #3, #4, #7, #23, #25 |
| **DUPLIKAT VON** | **7** | #19, #21, #26, #35, #36, #40, #41 |
| **OWNER-FRAGE** | **5** | #6, #12, #13, #27, #31 |
| **OFFEN** (konkret benannter Rest) | **19** | #1, #5, #8, #9, #11, #14, #15, #16, #17, #18, #28, #29, #30, #32, #33, #38, #39, #42, #43 |
| **NICHT ENTSCHEIDBAR** | **2** | #20, #22 |
| **Summe** | **43** | |

**43 Meldungen = 36 unikate Posten** (7 Doppelmeldungen). Der reale Posten schrumpft weiter:
von den 36 sind **5 belegt vollzogen** und **5 durch einen benannten Nachfolger abgelöst** —
**26 unikate Posten tragen noch Arbeit**, davon 5 reine Owner-Entscheidungen.

### 1.2 Die Duplikat-Paare (nachgemessen — es sind SIEBEN, nicht fünf)

| Paar | Gegenstand | Behalten | Streichen |
|---|---|---|---|
| 1 | A15 / §55-Gesamt-Reconcile | **#1** | #19 |
| 2 | FF0 / A14 Multi-Plattform + Anhänge B/E | **#3** | #26 |
| 3 | #327 Vault-PAT-Rotation | **#6** | #21 |
| 4 | A11 ccache-Allowlist-Drop | **#12** | #40 |
| 5 | A12 / E-14 NAS-Creds | **#13** | #41 |
| 6 | A10 HW-Erkennung P4-P6 | **#14** | #36 |
| 7 | Stale Hauptcheckout / Owner-Pfad | **#18** | #35 |

**Die Vortriage nannte vier Paare (+ eine Quasi-Gleichung). Drei Paare fehlten dort:**
#1↔#19 (A15), #14↔#36 (A10), #18↔#35 (Pfad/Checkouts). Die `diff`-Bilanz des Audits selbst
nennt dieselben sieben („A15, #327, FF0, A10, A11, A12, Pfad/Checkouts") — die Vortriage
hat also gegenüber der eigenen Quelle verloren, nicht gegenüber dem Ledger.

**Zur fünften Vortriage-Annahme:** „#7 O-A Matrix-Umfang ist inhaltlich dasselbe wie D-2
Bau-Menge" — **bestätigt in der Sache, aber es ist kein Duplikat innerhalb der 43** (D-2 ist
keine der 43 Positionen). #7 ist deshalb SUPERSEDED, nicht DUPLIKAT. Zusätzlich: **`O-A` ist
selbst ein kollidierendes Kürzel** — das `O-A` vom 07.08. (LEDGER:7625) ist die
MODI-SEQUENZ-Entscheidung `compare` vor `release`, ein völlig anderer Posten.

### 1.3 Was sich beim Nachmessen geändert hat

**Zehn der 43 Positionen tragen eine andere Disposition, als ihr Audit-Status behauptete.**
Die fünf härtesten:

1. **#24 (D-4 kCebFingerprint-Injektivität) ist VOLLZOGEN** — Commit `62a5b6f7` (06.08. 22:01).
   Der Audit führte ihn als WIDERSPRUCH, die eigene `diff`-Bilanz des Audits als offene Lücke
   L-6 („am Objekt prüfen … Dossier mildert nur, heilt aber nichts"). Am Objekt ist er geheilt
   **und zusätzlich gegen die ODR-Falle abgesichert**.
2. **#37 (T-9 Min/Max-Katalog) ist VOLLZOGEN** — ce `875a57cd` / Arbeits-Commit `5f21305a`
   (07.08. 11:04), fünf Stunden **nach** der Audit-Erhebung.
3. **#2 (branch_misses) ist VOLLZOGEN** — M-3a, ce `6a8ab995`; `PERF_COUNT_HW_BRANCH_MISSES`
   wird real geöffnet und zugewiesen.
4. **#34 (F-01 Talos) ist VOLLZOGEN** — thesis `eaf7fe8`. Der vom Audit als BLOCKIEREND
   eingestufte Dreifach-Widerspruch wurde zugunsten der **jüngeren** Anweisung aufgelöst
   und ausgeführt.
5. **#3 (Anhänge B/E „nur 4-Zeilen-Stubs")** — am Objekt widerlegt: **B = 257/256 Zeilen,
   E = 156/158 Zeilen** (DE/EN, thesis `origin/development`).

Weiter geändert: **#4** (GN-9 superseded), **#7** (O-A → D-3 entschieden), **#10**
(Frist-Korrektur belegt vollzogen), **#16** (DEG-3 ist dreifach im Ledger gebucht — nur die
Code-Lücke ist echt), **#25** (Scheibe-6/F3 bindend sequenziert).

**Gegenüber der Vortriage:** Duplikat-Paare **5 → 7**; Owner-Fragen **11 → 5**; die drei
belegten Baugebiete stimmen (#2, #9, #37) — aber **zwei davon sind bereits gelandet**,
nur #9 trägt noch echten Rest.

---

## 2. VOLLZOGEN (5)

### #2 — `#152 Cache-Misses als Kernmetrik + I-PMC-2 (L3+branch_misses) + I-PMC-3 PMC-Auto-Adaption: im Nachfolge-Task als erledigt gefuehrt, am Objekt widerlegt (branch_misses wird von keiner PMC-Quelle real geschrieben)`
**VOLLZOGEN** — mit benanntem Rest.
**Beleg (Code, Ref `origin/development` = `5788dc12`):**
`libs/cache_engine/builder/linux_perf_pmc_source.hpp:247`
`branch_ok_ = c_branch_.open(PERF_TYPE_HARDWARE, PERF_COUNT_HW_BRANCH_MISSES, "branch_misses");`
· `:304` `c.branch_misses_source_available = branch_ok_;` · `:338` `c.branch_misses = v;`.
Landung M-3a, ce `6a8ab995` (LEDGER:9284 ff., mit Bissbeweis: Regression simuliert →
`SMOKE_FAIL … EXIT=1`, danach zurückgesetzt → `SMOKE_OK`).
**Rest, ausdrücklich nicht miterledigt:** I-PMC-3 (L2 + `coherence_invalidations`) bleibt
honest-0 mit Begründung im Code; `pmc_cache_misses_l3` scheitert auf prod1 real mit
`errno=2` (Task #28, Handout I113 P-6). *Baugebiet belegt* (`Bau-PMC-Ehrlichkeit`,
`Verify-PMC-Ehrlichkeit`) — ich habe nur gelesen, nichts angefasst.

### #10 — `N-1: Frist-Korrektur Endtermin 15.09.2026 (woechentliche Freitagslieferung, 'ordnet ALLES') hat im Ledger selbst nach der einmaligen Buchung keine Fortsetzung`
**VOLLZOGEN.**
**Beleg:** LEDGER:8924-8928 (abend-9, T-E) — geprüft wurden `.gitlab-ci.yml` **beider** Repos,
beide READMEs und **alle** Thesis-`.tex`: **null Stellen rechnen gegen den 08.08.** Die
verbleibenden Fundstellen korrigieren den 08.08. selbst (`:4873`, `:8358`) oder sind datierte
`20260806-PLAN-*`-Dokumente. Eigene Gegenprobe: `15.09` hat im lebenden Ledger **10 Treffer,
davon 3 in den Abschnitten ab 7250** (im Audit-Stand: 0 ab 7250).
Task #23 bleibt als Erinnerung offen — die Substanz ist verifiziert.

### #24 — `D-4-ID-Kollision: 'kCebFingerprint bricht Owner-KERN F6 auf CEB-Ebene' (06.08. abend-3) hat keinen erkennbaren Aufloesungs-Status mehr, seit D-4 am 07.08. neu belegt wurde`
**VOLLZOGEN** — der schärfste Umschlag dieser Disposition.
**Beleg (Commit):** `62a5b6f7` · 2026-08-06 22:01 · *„feat(m1/d-4): der CEB-Schluessel rendert
die WAHL, nicht das ANGEBOT"* — Vorfahr von `origin/development`.
**Beleg (Code):** `libs/cache_engine/builder/ceb_version_stamp.hpp:26-28` — *„AB HIER: die
Zeile wird aus der EINKOMPILIERTEN Combo-Legende gerendert … BYTE-IDENTISCH zum
Vor-D-4-Stand"*; `:456` `kCebMeasurementStampArrayFor<kCebCtLegend>`; zusätzlich die
ODR-Wache `:179-180` (`#ifndef COMDARE_MEASUREMENT_COMBO_CT_WIRED` → `#error`), die den
stillen Linker-Verstoß in einen lauten Übersetzungsfehler verwandelt.
Der Kopf dokumentiert die alte Messung (vier Combos, ein `sha512`) als **Vorher-Stand**.
**Rest:** nur die ID-Kollision — `D-4` bezeichnet seit 07.08. `allow_failure` (siehe #8).
Vorschlag: die alte Kette als `D-4-ALT-FPRINT` **abschließen**, nicht wiedereröffnen.

### #34 — `F-01/Talos-Reparaturanweisung widerspricht sich selbst am selben Tag (Rollentrennung vs. NICHT-Rollentrennung)`
**VOLLZOGEN.**
**Beleg:** LEDGER:8225-8235 (nachmittag-1) — *„VERGESSENE ARBEIT V2 VOLLZOGEN: die
Talos-Tempus-Korrektur (thesis `eaf7fe8`)"*: drei Stellen je Sprache, Präsens Passiv →
Sollform + Vollzugsstand; ADR-12 behält ihr Entscheidungs-Präsens und bekommt ein eigenes
Feld **Vollzugsstand**; chktex 0 Warnungen auf allen sechs berührten Dateien; DE 204 / EN 194
Seiten. Gegenprobe: `eaf7fe8` ist im Thesis-Klon `origin/development`.
Aufgelöst wurde zugunsten der **jüngeren** Anweisung (LEDGER:7492, mittag-2: *„Tempus/Status
präzisieren — NICHT streichen, NICHT ‚Rollentrennung'"*).
**Dokumentarischer Rest:** die zwei überholten Stellen (LEDGER:7256 und DOSSIER:3368-3371)
tragen **keinen** Supersede-Vermerk — wer dort zuerst liest, führt die falsche Fassung aus.

### #37 — `T-9 Min/Max-Katalog in break_even.hpp: Ledger selbst nennt 'hoechste Prioritaet', Dossier fuehrt den Posten im niedrig priorisierten Sammeltopf`
**VOLLZOGEN.**
**Beleg (Commit):** `5f21305a` · 2026-08-07 11:04 · *„feat(heuristik): T-9 — der
Min/Max-Katalog speist den Break-Even-Vergleich"*; Merge ce `875a57cd` (LEDGER:8052 ff.).
**Beleg (Code, `origin/development`):** neu `libs/cache_engine/heuristik/axis_optimization_catalog.hpp`;
`heuristik/break_even.hpp:107` `template <OptimizationDirection Dir = OptimizationDirection::Minimize, …>`
und `:91` `if constexpr (Dir == OptimizationDirection::Minimize)` — statischer Dispatch, kein
Laufzeit-Zweig; Test `tests/unit/test_heuristik_spline_break_even.cpp:287`
`static_assert(h::leading_direction(h::CatalogAxis::PathCompression) == h::OptimizationDirection::Maximize);`.
Drei Bissbeweise literal im Ledger (Alt-Stand → 3 FAILED; Pareto-Frage → `static_assert`;
unbekannte Zielgröße → consteval-Fehler statt stillem MIN-Default).
*Baugebiet belegt* (`Bau-S2-Katalogwache`) — nur gelesen.
**Dokumentarischer Rest:** die Dossier-Landkarte §17.9 führt T-9 weiterhin im T4-Sammeltopf.

---

## 3. SUPERSEDED (5)

### #3 — `FF0-Owner Multi-Plattform-Generalitaet (expliziter Abgabe-Blocker) + Anhaenge-B/E-Stubs + Mess-Manifest/Provenance`
**SUPERSEDED** — in zwei von drei Teilen; der dritte ist ungeprüft.
**(a) Anhänge B/E: am Objekt widerlegt.** Gemessen am Ref thesis `origin/development`
(nicht am Arbeitsbaum, siehe #42): `anhang/de/B_code_structure.tex` **257** Zeilen,
`anhang/en/…` **256**; `anhang/de/E_architecture_decisions.tex` **156**, `anhang/en/…` **158**.
Die Behauptung „nur 4-Zeilen-Stubs" (Ursprung §55, 20.07.) gilt nicht mehr.
**(b) FF0-Multi-Plattform:** inhaltlich gedeckt durch die Plattform-Matrix (mittag-2 Sec. 2.5),
den Owner-Entscheid O-C = 21 Images (mittag-3) und den Pilot-Entscheid prod1+prod2.
**Es fehlt die Brücken-Zeile Alt-Id → neue Entscheide** — `FF0` hat im lebenden Ledger genau
**1 Treffer ab Zeile 7250** (LEDGER:7883), und der ist das Audit-Protokoll selbst.
**(c) Mess-Manifest/Provenance: ungeprüft** — siehe Abschnitt 7.

### #4 — `GN-9 Bloat-/Kalibrierungs-Report (1-Zellen-Kalibrierungslauf) als Feasibility-Gate VOR der 2^17-Voll-Matrix`
**SUPERSEDED** durch die ETA-Erst-Batch-Abnahme.
**Beleg:** `docs/sessions/20260807-GESAMTDOSSIER-aktuell-jetzt-konsolidiert.md:3340` —
*„GN-9-Gate superseded durch ETA-Erst-Batch-Abnahme in der P3-Trigger-Checkliste"*; die
Größen t/TU + Bytes/DLL liefert der erste 4096er-Batch (R-6).
**Widerspruch, der bleibt:** LEDGER:7885 (mittag-4) führt GN-9 noch als *„hat bis heute keinen
Slot im Fahrplan"* — das ist das Protokoll des Audit-Berichts, nicht eine neuere Feststellung.
Die Disposition lebt nur im Dossier; eine Ledger-Zeile fehlt.

### #7 — `O-A: Owner-Entscheid ueber Bau-/Mess-Matrix-Umfang (524.288 vs. 2.097.152 Binaries, KEINE Kappung) fehlt seit seiner einzigen Buchung`
**SUPERSEDED** durch **D-3** — mit einem präzisierten Rest, der Owner-Sache ist.
**Beleg (Entscheid):** LEDGER:7342-7343 und :7503-7504, Owner verbatim: *„Wir bauen nur die
320er die wir auch tatsaechlich messen und stellen die golden XML darauf um."* ⇒ Bau-Menge
folgt der Mess-Menge.
**Beleg (Präzisierung):** LEDGER:8908-8922 (abend-9, T-D) — `source_catalog.hpp:139,169`:
2^17 = 131.072 ist das **Organ-Fenster je System-Permutation**, nicht der Gesamt-Umfang;
`all_axes_golden.profile.xml:189-198` deklariert **vier** System-Perms ⇒ realer Ist-Umfang
**524.288**. Der „Faktor 16" kam aus drei vermischten Ebenen.
**Rest (Owner):** welche System-Perm-Menge, und fällt `line_size` mit hinein — **fällig vor
der Voll-Messung, nicht vor dem ersten Batch** (Task #21).
**Falle:** `O-A` ist doppelt belegt (siehe 1.2).

### #23 — `Namenskollision 'R-2': E-18-Ziel-Branch-Frage (06.08.) und XML-Trennung/4096er-Slicing (07.08. mittag-2) teilen sich dieselbe Kurz-ID ohne Verweis`
**SUPERSEDED** — die ältere Kette ist entschieden, nur der Namensraum ist unmarkiert.
**Beleg:** LEDGER:7100 (NACHTRAG 06.08. frueh-6, also **später** als frueh-5 mit der offenen
Frage bei :7114): *„E-1 (289-Ziel-Branch): (a) development GEWAEHLT."* Das deckt sich mit dem
Code: `.gitlab-ci.yml:1115` `if: '$COMDARE_ANHANG_FORWARD == "true" && $CI_COMMIT_BRANCH == "development"'`.
Die jüngere Bedeutung (XML-Trennung + 4096er-Slicing) steht bei LEDGER:7572.
**Rest:** rein dokumentarisch — keine der beiden Stellen verweist auf die andere. Vorschlag
der Klarheit halber: `R2-ZIELBRANCH` (erledigt) vs. `R-2-XML` (offen, siehe #15).

### #25 — `Scheibe-6/F3: Owner-Entscheid 'Weg a (ce-Umbenennung) vs. Weg b (dauerhaft)' bleibt seit 06.08. offen und fehlt in den 07.08.-Abschnitten`
**SUPERSEDED** durch eine bindende Sequenzierung.
**Beleg:** DOSSIER:2706-2716 — B14/NB3 → Weg a → F5; das Rename selbst **nach** der Abgabe.
Bestätigt in Task #7 („F3/Weg a fällig, aber nach der Abgabe").
**Rest:** `Scheibe-6` hat 0 Treffer im Ledger ab Zeile 7250 — die Sequenz lebt nur im Dossier.
**Falle:** `F3` ist selbst doppelt vergeben — DOSSIER:1690: *„ebenso doppeln ‚F3'
(01.08. xlsx-Writer vs 06.08. Scheibe-6-Fixture)"*.

---

## 4. DUPLIKAT VON (7)

| Id | Titel (verbatim, gekürzt) | Duplikat von |
|---|---|---|
| **#19** | `A15/§55-Gesamt-Reconcile ('V-01'): die Massnahme gegen verlorene Alt-Posten ist selbst zweimal verlorengegangen und fehlt auch in mittag-2` | **#1** |
| **#21** | `V-11/#327 PAT-Rotation (Security, exponierter Vault-PAT): widerspruechlicher Status …, fehlt in den 07.08.-Abschnitten` | **#6** |
| **#26** | `V-02 A14 FF0-Multi-Plattform ('Abgabe-Blocker, hoch'): eigene 'superseded?'-Frage nie beantwortet, Posten fehlt in 07.08.` | **#3** |
| **#35** | `Hauptcheckouts (super + ce) stehen JETZT noch auf Feature-Zweigen — der im Audit-Auftrag genannte Ledger-Pfad ist dadurch veraltet` | **#18** |
| **#36** | `A10 / HW-Erkennung P4-P6 (Provenienz-Spalten): als T2 (vor Voll-Messung) gefuehrt, im Dossier auf T4 (danach) herabgestuft …` | **#14** |
| **#40** | `A11 / ccache-Allowlist-Drop: Owner-Entscheid seit 06.08. angefordert, aus der Vollkonsolidierung gefallen` | **#12** |
| **#41** | `A12/E-14 NAS-Creds: Dossier behauptet '0 Treffer in Ledger+Register' — fuer den Ledger-Teil widerlegt …` | **#13** |

**Begründung je Paar in einem Satz:** identischer Gegenstand, verschiedene Erhebungswelle —
die jeweils zweite Meldung nennt zusätzlich nur, dass der Posten in den 07.08.-Abschnitten
fehlt, was bei der ersten bereits Bestandteil des Befunds ist. Bei **#41** ist der
Zusatzgehalt sachlich richtig und wird in #13 mitgeführt: die Dossier-Formulierung
„0 Treffer in Ledger+Register" ist für den Ledger-Teil falsch (`A12` hat dort Treffer),
für das Register richtig.

---

## 5. OWNER-FRAGE (5)

### #6 — `#327 Vault-PAT-Rotation (exponierter Personal-Access-Token) — Sicherheitsposten mit widerspruechlichem Status (03.08. 'final entschieden/aufgeschoben' vs. 06.08. 'Status unklar, SOFORT')`
**OWNER-FRAGE:** *Gilt die Terminierung „Rotation nach dem Messfenster" (E5, 03.08.) angesichts
der Fristverschiebung auf 15.09. weiter — und liegt #327 beim Infra-Agenten oder weiterhin
bei der Diplomarbeitslinie?*
**Beleg für den Stand:** DOSSIER:3343 — *„#327 PAT-Rotation Owner-terminiert ‚nach
Messfenster'"*, DOSSIER:1572 nennt denselben E5-Entscheid. Die Klasse „Rotationen, Keys,
Infra-Probleme" ist am 06.08. verbatim abgegeben worden (`docs/infra/I113_RUNNER_TOKEN_ROTATION_UND_INFRA_RESTPOSTEN.md`,
Owner: *„Das ist nicht mehr dein Problem."*).
**Der Grund, warum die Frage bleibt — nachgemessen:** #327 hat **keine eigene Zeile in I113**.
Gesucht mit `grep -n -i '327\|vault\|PAT'` über alle 238 Zeilen: drei Treffer, davon zwei
generisch (Vorprüfungs-Hinweis :77, Zugangs-Hinweis :167); die Übergabe-Tabelle führt
P-1..P-6 ohne #327. Die Abgabe der Klasse ist also erfolgt, der Einzelposten ist nicht
mitgereist.

### #12 — `A11 (ccache-Allowlist-Drop) — Owner-Entscheid steht aus, obwohl Plan und Code sich nachweislich widersprechen`
**OWNER-FRAGE:** *Gilt der A11-Plan (Eintrag aus `.gitleaks.toml` entfernen) oder der
Code-Kommentar (Eintrag MUSS bleiben)?*
**Beleg am Objekt — beide Dateien tragen den Eintrag heute:**
super `.gitleaks.toml:25,29` (`'''(^|/)\.ccache/'''`) und ce `origin/development`
`.gitleaks.toml:47,50`. Der A11-Plan ist also **nicht** ausgeführt; faktisch gilt der
Kommentar. Ledger: `A11` erscheint ab Zeile 7250 nur noch in Aufzählungen offener Posten
(:8339, :8781), nie mit Entscheid.
*Die Lead-Empfehlung (A11 zurückziehen) liegt seit 06.08. vor; ich nehme sie nicht vorweg.*

### #13 — `A12 / E-14: NAS-Creds backup1/backup2 — offene Owner-Frage ('gilt A12 noch?') seit Buchung nicht weiterverfolgt`
**OWNER-FRAGE:** *Gilt A12 noch, ist es erledigt, oder ist es verworfen?*
**Beleg:** LEDGER:5166-5167 — *„OFFENE OWNER-FRAGE (unveraendert) … Es liegt kein Beleg fuer
eine Erledigung vor."* Keine spätere Owner-Aussage berührt NAS-Credentials.
**Suchweg (wegen der Kollisionsgefahr ausgeschrieben):** `A12` liefert im lebenden Ledger 37
Treffer, davon 2 ab Zeile 7250 (:8339, :8781, beide in Listen offener Posten). Ein großer
Teil der übrigen Treffer ist der golden-CRC-Anker `0xF1C1F26A1232073B`, der die Zeichenfolge
`A12` enthält — Nullbefund-Falle in beide Richtungen.

### #27 — `prt-art M3: E-24-Container-Gattungs-Zuordnung fuer PRT-ART-Pruefling-Slots — ABI-Fenster laut super-Ledger bereits geschlossen`
**OWNER-FRAGE:** *War die Nicht-Zuordnung von Container-Genus-Slots an die prt-art-Achsen beim
E-24-Schnitt bewusst — oder ist sie im Gedränge der Landung übersehen worden?*
**Beleg am Objekt (prt-art `development` @ `c6f07540`):** `docs/ledger-sections/architektur-ziele-offene-punkte-ledger.md:167-180`
führt M3 unverändert als „offen, gated" mit eigener Fristwarnung („E-24 MUSS VOR dem
Voll-Bau-4-Trigger liegen"). Registry `prt_art/algorithm_profiles/prt_art_axis_registry.xml`
hat 5 Achsen, keine Container-Gattung.
**Beleg, dass das Fenster zu ist:** LEDGER:8404 — `anatomy_module_abi_v1_decl.hpp:89`
`#define COMDARE_ANATOMY_ABI_MAJOR 8` (inzwischen Minor 0→1).

### #31 — `prt-art M2 (a/b/c): PRT-ART-Mess-Anbindung — Ergebnis-Weg, Versions-Attribut, golden_wired-Soll-Zustand nicht im super-Ledger entschieden`
**OWNER-FRAGE (M2c):** *Ist `golden_wired="false"` für 4 der 5 prt-art-Achsen der Soll-Zustand
für die Auswertung?* — M2a/M2b sind demgegenüber Bauposten, keine Entscheidungen.
**Beleg am Objekt:** `prt_art/algorithm_profiles/prt_art_axis_registry.xml:12,15,18,21` tragen
`golden_wired="false"`, `:24` (`path_compression_patricia`) trägt `"true"`. Der Kopf derselben
Datei (`:6-7`) erklärt das als beabsichtigte Slot-Demonstration — das **entlastet die
Registry, entscheidet aber nicht den Auswertungs-Umfang**, und genau den verlangt der
prt-art-Ledger „im super-LEDGER".
**Gegenprobe super-Ledger:** `golden_wired` = 5 Treffer, alle im ce-Kontext, **0 ab Zeile 7250**.

---

## 6. OFFEN (19)

### #1 — `A15 / §55-Gesamt-Reconcile: die Ueberfuehrung des letzten Voll-Konsolidierungsblocks (§55, 20.07.) ins laufende System ist selbst nicht sauber abgeschlossen …`
**OFFEN — es fehlt genau eine Sache: die Ledger-Zeile.**
**Was existiert:** die V-01..V-20-Disposition ist **vollzogen** und steht in
DOSSIER:3330-3345 (§17.8) — *„10 UEBERNOMMEN / 4 SUPERSEDED / 5 BEREITS ERLEDIGT /
1 OWNER-ENTSCHEID"*, mit benannten Ausgängen (V-03 falsch-positiv, V-05 am Objekt vollzogen,
V-06 → GN-9 superseded, V-11 → #327 terminiert, V-07/V-09/V-10/V-12/V-20 → nach Abgabe).
**Was fehlt:** `wf_abbabbb4` hat im lebenden Ledger **1 Treffer insgesamt, 0 ab Zeile 7250**;
`§55` **0 ab 7250**. Der Ledger registriert den Audit selbst (LEDGER:7877-7886, mittag-4
Abschnitt D) mit der Zeile *„Volle Liste: `tmp/wisfvjd8z.output`, zu ueberfuehren"* — also
als **anerkannt offen**, nicht als vergessen.
**Nicht ausgewiesen sind die Einzel-Dispositionen von V-02 und V-13..V-19.**
*Dieses Dokument ist die Disposition; die Ledger-Zeile schreibt der Lead.*

### #5 — `Achsen-Sensitivitaetsanalyse-Writer (M-8), vier Heuristik-Kurven-Writer (M-9), Welch-Konsument (M-15) — Anhang A DE+EN haengt an dieser Kette`
**OFFEN** — mit widerlegter Prämisse.
**Prämisse widerlegt:** Anhang A ist in der Abgabe (Owner 06.08. abends, DOSSIER:2602-2606)
und trägt am Ref thesis `origin/development` **290 Zeilen** mit einer eigenen
*„ERSATZTEXT-REGEL (2026-08-06 GEAENDERT, honest-100%)"* (`anhang/de/A_measurements.tex:79`).
Anhang A hängt also **nicht** an M-8/M-15.
**Offen bleibt:** M-9 (vier Heuristik-Kurven-Writer verdrahten) jetzt; M-8/M-15 nach echtem
Korpus. **Kein Ledger-Träger:** `M-8`, `M-9`, `M-15`, `Sensitivit` haben im lebenden Ledger
je **0 Treffer ab Zeile 7250**.

### #8 — `KK-5/P-1: allow_failure: true auf Job-Ebene (nicht auf Zell-Ebene) des generierten Voll-Mess-Batches — Messvaliditaets-Luecke seit Buchung nicht weiterverfolgt`
**OFFEN — am Objekt unverändert bestätigt.**
**Beleg:** `libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:1394`
(Ref `origin/development`): `s += "  allow_failure: true\n";` — die Zeile steht **nach** dem
`rules:`-Block (er endet zwei Zeilen darüber mit `- when: manual`), gilt also für den
gesamten Job.
**Getrackt** als D-4 (LEDGER:7570 ff.) — mit der ID-Kollision aus #24.
**Zeilendrift, die bei jeder Prüfung kostet:** Ledger und Audit nennen `:1332-1333` bzw.
`:1373`; real ist `:1394`.

### #9 — `PMC-/Hybrid-Architektur-Bauposten B-1..B-10 … ohne Statusverfolgung nach der Buchung — zusaetzlich Namenskollision mit einer unabhaengigen 'B1-B13'-Checkliste`
**OFFEN — teils erledigt, mit benanntem Rest.** *Baugebiet belegt; ich habe nur Belege gelesen.*
- **Vollzogen:** numa/`core_class`-Paket, ce `aa223961` (LEDGER:7401). Der Begriff `cpu_atom`
  hat im lebenden Ledger **9 Treffer, davon 4 ab Zeile 7250** — im Audit-Stand waren es 0.
- **B-5 (ehrlicher `pmc_cache_misses_l3`-Status statt stiller 0):** substanziell durch M-3a
  abgedeckt — LEDGER:9317-9325 zeigt eine **echte** CSV-Zeile mit `pmc_available='1'` **und**
  `l3='n/a'` nebeneinander, also genau die vorher fehlende Unterscheidung.
- **Echt offen: B-6** (RAW-Events je Mikroarchitektur) — Handout I113 P-6: die `amd_l3`-Uncore-PMU
  ist auf prod1 nicht geladen, `errno=2`.
- **B-3** (getrennte Ablage je PMU-Domäne im CSV-/Lager-Schema): von mir **nicht** am Objekt
  nachgemessen (Baugebiet).
**Namenskollision bestätigt:** `B-1` bezeichnet im selben Dokument auch das
E-18-Vorwärtskanal-Paket.

### #11 — `E-07/B10-Abnahmekriterien (K1-K5, N1-N3 mit literalen Gate-Zeilen) nur einmalig ausgeschrieben …`
**OFFEN (dokumentarisch) — der Befund hält exakt.**
**Gemessen, je Token über 9619 Ledger- und 3704 Dossier-Zeilen:**
`E07_TREE_COUNT` · `E07_ID_ROUNDTRIP_MISMATCH` · `E07_BYPASS_FINDINGS` ·
`E07_STALE_ID_MEASURED` · `E07_WINDOW_SUBSET` — **je 1 Treffer im Ledger (LEDGER:5368-5371),
je 0 im Dossier.**
Das Dossier trägt bei `:2231-2249` (§15.9) die vollständige **normative** Gate-Definition und
verweist auf *„ALLE mit literalen E07_*-Gate-Zeilen"* — **ohne sie zu reproduzieren**. Das ist
der M4-Mechanismus (Stellvertreterbuchung) in Reinform, ein zweites Mal auf derselben Position.

### #14 — `A10: HW-Erkennung P4-P6 (CSV-Provenienz-Spalten, Mess-Stempel-Segment) — als T2-Punkt (vor Vollmessung faellig) seit Buchung nicht weiterverfolgt`
**OFFEN — am Objekt bestätigt, mit ungeklärtem Fenster.**
**Beleg (Ref `origin/development`):**
`libs/cache_engine/include/cache_engine/measurement/hardware_probe_factory.hpp:133`
*„Etikett fuer Log und (spaeter, P5) das Mess-Stempel-Segment"* · `:403` *„Heute stehen hier
die Defaults der Achsen (linux + prod1-Klasse) — beweglich, kein Pin. In P5 …"*. Nicht gebaut.
**Der Fensterkonflikt ist echt und unaufgelöst:** LEDGER:5244 bucht **T2** („vor der
Voll-Messung"), DOSSIER:3402-3403 legt denselben Posten in den **T4**-Absatz („danach") —
bei gleichzeitiger eigener Anmerkung „fünfmal Pflicht vor Trigger". Ledger ab Zeile 7250:
`A10` erscheint nur in Listen offener Posten (:8339, :8987).

### #15 — `N-6: XML-Trennung Bau-Menge/Mess-Menge fehlt (vom Owner als Regression benannt) — als T2-Bauposten seit Buchung nicht wieder aufgegriffen`
**OFFEN — Substanz am Objekt bestätigt, aber im Register vorhanden.**
**Beleg (Ref `origin/development`):** die Trennung lebt weiterhin **ausschließlich** als
Env-Schalter `COMDARE_GOLDEN_N_PROVISION_ONLY` — `experiment_plan_director.hpp:1308, :1472,
:1762, :1819` und `profile_facade/profile_run_facade.hpp:61`. Keine XML-seitige Trennung.
**Getrackt** als **R-2** (LEDGER:7572, Fenster T1 „vor dem ersten 4096er-Batch") — die
Audit-Aussage „FEHLT_GANZ" trifft die Buchführung nicht, nur den Bau.

### #16 — `DEG-3: Masstree-Referenzimplementierung composed_masstree_search.hpp hat weiterhin 0x for_each_record — der Walk fehlt trotz eingetretener Nachzieh-Bedingung`
**OFFEN — Code-Lücke bestätigt, Buchführungs-Vorwurf widerlegt.**
**Beleg mit Positiv-Kontrolle** (Ref `origin/development`, Verzeichnis
`libs/cache_engine/axes/lookup/composable/`):

| Datei | `for_each_record` |
|---|---:|
| `composed_masstree_search.hpp` | **0** |
| `composed_art_trie_search.hpp` … `composed_wormhole_search.hpp` (11 Geschwister) | je 1 (`composed_tree_search.hpp`: 2) |

Die Datei existiert (`git ls-tree` bestätigt) — es ist kein Nullbefund durch fehlende Datei.
**Widerlegt:** „nirgends verbucht". Der Ledger führt DEG-3 **dreifach** (Z. 5387/5540/5552),
und sagt das bei :8430 selbst.

### #17 — `REV-CXX/REV-DATA/REV-CI/REV-TEX: 30 Review-TODOs mit P0-Teilmenge 'vor jeder wissenschaftlichen Vollmessung' — Einzelansprueche nirgends im Register nachgehalten`
**OFFEN — getrackt, aber nur an einer Stelle.**
**Beleg:** DOSSIER:1125-1132 (§12.7) führt die Menge als **„P-1 DRINGENDST"** im
Verifikations-Backlog und nennt die kritischen Einzelposten namentlich (REV-CXX-01
use-after-free; REV-DATA-01/02 `two_phase_valid`; REV-DATA-08 Zyklen als ns, ~Faktor 3;
REV-DATA-13 Welch ohne Multiplizitätskorrektur; REV-CI-01).
**Gegenprobe:** `REV-CXX` und `REV-TEX` haben im lebenden Ledger **je 0 Treffer ab Zeile 7250**.
Die Einzelansprüche sind weiterhin nicht gegen Ist-Code/CI geprüft.

### #18 — `Pfad-Diskrepanz: Owner-Pfad zeigt auf stale Checkout statt auf die aktuelle Landungs-Worktree wt-super-landung`
**OFFEN — live nachgemessen, die Lücke ist GRÖSSER geworden.**

| | Branch | Ref | Ledger-Zeilen |
|---|---|---|---|
| `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine` | `b-ci-rueckschrieb-beide-zeiger` | `18a0bdf3` | **7248** |
| dessen `Code/external/comdare-cache-engine` | `b-m2-pmc-invariante` | `90bca126` | — |
| `/home/comdare/wt-super-landung` | `development` | `c26f8a77` | **9619** |

Der Abstand betrug zur Audit-Zeit 367 Zeilen (7248 vs. 7615) und beträgt jetzt **2371**.
**Dieser Pfad hat heute nachweislich Fehldiagnosen erzeugt** — LEDGER:7894-7896 protokolliert
genau das („der Lead hat am FALSCHEN Checkout gemessen").

### #28 — `thesis C1-Rest: Verifikation der Rahmen-Pass-Entwuerfe (Danksagung/Sperrvermerk/Lizenz-Matrix/EN-Abstract-Sync/F10) nirgends im super-Ledger nachvollzogen`
**OFFEN — belegter Nullbefund.**
**Suchweg:** `/usr/bin/grep -c` über alle **9619** Ledger-Zeilen:
`761cecc` = 0 · `Sperrvermerk` = 0 · `Danksagung` = 0 · `Lizenz-Matrix` = 0.
Im Dossier (3704 Z.): `761cecc` = 0, `Lizenz-Matrix` = 1 (`:1869`, anderer Kontext).
**Positiv-Kontrolle:** `prt-art` = 111 Treffer im Ledger — die Suche greift.
**Anspruch:** der thesis-Ledger delegiert ausdrücklich (`:70`): *„im Repo gelandet;
Statusfuehrung super-seitig"*, und `:79-80`: *„die Verifikation ist der offene Rest."*

### #29 — `thesis T5: Cross-Repo-Lizenz-Matrix-Konsistenzpruefung vor Abgabe — kein Treffer im super-Ledger`
**OFFEN — der formale Posten fehlt, die Substanz ist heute unter anderem Namen aufgetaucht.**
**Substanz:** LEDGER:8987-8998 (abend-10) trägt drei Abweichungen Thesis ↔ Akte —
`michael_lockfree` (LGPL-2.1-or-later vs. BSD-3) · `tcmalloc` (Apache-2.0 vs. BSD-3) ·
`lrmalloc` (MIT vs. BSD-3); Task #42 führt sie. Das ist genau der Gegenstand von T5(c).
**Formal fehlt er trotzdem:** `Lizenz-Matrix` = 0 Treffer im Ledger. Ein Leser, der T5 sucht,
findet nichts — er findet die Sache nur, wenn er nach Allokator-Namen sucht.

### #30 — `prt-art M1: LICENSE-Historie + SPDX-Header-Abdeckung (28/68) — kein Treffer im super-Ledger`
**OFFEN — heute am Objekt nachgezählt, unverändert.**
**Beleg:** `find prt_art -name '*.hpp' -o -name '*.cpp'` = **68**;
`grep -rl 'SPDX-License-Identifier'` darüber = **28**. Also **28/68**, identisch zum
02.08.-Stand. `LICENSE` wurde durch `7f6c703` (2026-08-02 10:10) angelegt; das Repo besteht
seit 12.05.
**Gegenprobe super-Ledger:** `SPDX` = **0 Treffer** über 9619 Zeilen.
Teil (a) (rückwirkende Geltung / Copyright-Halter) ist Owner-Territorium und hängt mit #29
zusammen.

### #32 — `1 verbliebene gtest_discover-Insel in builder/commands (Test-Discovery-Restpunkt) — kein Treffer im super-Ledger`
**OFFEN — am Objekt bestätigt.**
**Beleg (Ref `origin/development`):** `libs/cache_engine/builder/commands/tests/CMakeLists.txt:35-37`
— `if(COMMAND gtest_discover_tests)` / `gtest_discover_tests(test_commands DISCOVERY_TIMEOUT 30)`
/ `gtest_discover_tests(test_engine_adapters DISCOVERY_TIMEOUT 30)`.
Vorlage für die Umstellung liegt in `cmake/gtest_setup.cmake:56-57` (dort ist begründet,
**warum nicht** `gtest_discover_tests`).
**Gegenprobe super-Ledger:** `gtest_discover` = 0 Treffer.

### #33 — `B4.1 MinGW-Build durch ESET blockiert — nie geschlossen, nie im super-Ledger referenziert`
**OFFEN (dokumentarisch) — Nullbefund belegt, inklusive der Suchfalle.**
**Beleg:** ce `docs/ledger-sections/architektur-ziele-offene-punkte-ledger.md:210` —
`| **B4.1** | MinGW-Build | blocked-external | open | ESET blockiert Binaries | User: ESET-Ausnahme |`,
**ohne** `[NACHTRAG]`-Vermerk, anders als praktisch alle Nachbarzeilen.
**Suchfalle ausgeschrieben:** `grep -c 'ESET'` über den super-Ledger liefert **26** — davon
sind **null** echt: die Treffer stecken in `UMGESETZT` (7), `GESETZ` (10), `GESETZT` (2),
`WERTESET` (4), `AUFGESETZT` (2), `DURCHGESETZT` (1), `RESET` (1). `grep -cw 'ESET'` = **0**.
`MinGW` = 0. Ein naiver Zähler hätte den Posten hier für gebucht gehalten.
**Vermutung, nicht Befund:** die Messkette läuft über prod1/Cluster, MinGW ist vermutlich
gegenstandslos — das zu **erklären** ist die offene Handlung, nicht es zu bauen.

### #38 — `V-8: Tag w2b-E04-P1 (2 Patches) — Fold-Behauptung widerspricht Git-Befund, seit der Vollkonsolidierung nicht mehr erwaehnt`
**OFFEN — heute am Git-Objekt nachgemessen, Befund unverändert.**
**Beleg:** `git cherry origin/development w2b-E04-P1-prefold-daf5190e` (in `/home/comdare/wt-landung`):
```
+ 92ad835766f1e6101a03ab909a258e7e8194aa3f
+ 63406ce366ec271939cddd78390d00601e780216
- daf5190e981f149efa0206de724c12e2b8d1a252
```
Zwei Patches tragen weiterhin `+` = **nicht** in `development` enthalten. Die Fold-Behauptung
(LEDGER:3656: „zur Falte 037300a6 vereinigt") bleibt damit widerlegt.
`w2b` und `E-04-P1` haben im lebenden Ledger **je 0 Treffer ab Zeile 7250**.
**Entscheid fällig:** nachziehen oder als superseded deklarieren.

### #39 — `V-6: B12/xlsx-Writer — zwei bereits erkannte falsche Entlastungszeilen im Ledger stehen unveraendert weiter`
**OFFEN — beide Zeilen heute im lebenden Ledger wörtlich wiedergefunden, ohne Korrektur.**
**Beleg 1, LEDGER:7016** (verbatim): *„xlsx-Writer braucht KEINE Aenderung (WIDE-Schema
fliesst automatisch); B12 keine Voraussetzung."*
**Beleg 2, LEDGER:7096** (verbatim): *„… P4 waehrend/nach Messung: … B12-xlsx-Fuellung …"*
**Kein Korrektur-Vermerk** auf beiden Zeilen (`grep -c 'ERLEDIGT-STALE\|KORREKTUR\|ueberholt'`
auf genau diesen zwei Zeilen = 0). Beide Zeilennummern gelten unverändert, weil das Wachstum
des Ledgers ab Zeile 7250 angehängt wurde.
**Gegenbeleg zur Sache:** DOSSIER §17.8 — *„V-6 B12-xlsx-Writer EXISTIERT NICHT (0 Treffer in
1583 libs/-Dateien, Gegenprobe csv=102; nur das Design-Doc)"*; bestätigt in
`20260807-ABSCHLUSS-…md` §T-F („R-3: kein xlsx-Writer, nur Design-Doc").

### #42 — `V-9: Lokaler Thesis-Klon (20260931-overleaf-diplomarbeit) — Fetch inzwischen live nachgeholt, Fast-Forward auf lokalem main fehlt noch`
**OFFEN — live nachgemessen, und das Ziel hat sich verschoben.**
**Beleg (`/home/comdare/Projekte/Research/20260931-overleaf-diplomarbeit`, 07.08. nachmittags):**
`FETCH_HEAD` 07.08. 15:33 · `git cat-file -e 19e1592` = FOUND · `eaf7fe8` = FOUND ·
lokal `main` = **`29a1700`** · `origin/main` = **`8197a2c0`** · `origin/development` = **`eaf7fe8`** ·
`git merge-base --is-ancestor main origin/development` = **wahr**.
Der lokale `main` hängt also nicht nur hinter `development`, sondern hinter `origin/main`.
**Neu gegenüber dem Audit:** das FF-Ziel heißt nicht mehr `19e1592`, sondern `eaf7fe8`.
**Dieser stale Klon hat mich in dieser Sitzung selbst einmal falsch lesen lassen:** im
Arbeitsbaum hat `anhang/de/A_measurements.tex` 137 Zeilen und sagt *„Cache-Misses L1–L3
derzeit 0/nicht erhoben"*; am Ref `origin/development` sind es **290 Zeilen** mit der neuen
Ersatztext-Regel. Wer den Baum liest statt den Ref, bucht eine überholte Aussage.

### #43 — `V-7: b-e18-snap korrekt geparkt, aber ohne die vom Auftrag selbst geforderte Register-Zeile/Wiedervorlage-Anker — aus der Vollkonsolidierung gefallen`
**OFFEN — mit einer Kürzel-Kollision, die den Befund erst erklärt.**
**Gemessen im 14-Tage-Register (`20260806-REGISTER-todo-konsolidierung-14-tage.md`):**
`b-e18-snap` = **0** · `e18snap` = **0** · `E18-SNAP` = **3** (Z. 67, 285, 324).
Die drei Treffer betreffen das **Feature-Paket E18-SNAP** (datierte Snapshot-Ordner je
Kanal-Lauf), nicht den geparkten **Branch `b-e18-snap`** mit seinem stehenden
NICHT-LANDEN-Verdikt. Zwei verschiedene Gegenstände unter fast identischem Namen.
**Was existiert:** DOSSIER:3312 („geparkt mit Wiedervorlage-Anker: NB3 im P4-Fenster") und
LEDGER:8167, wo das Veto als Grund zitiert wird, den Merge **nicht** auszuführen.
**Was fehlt:** eine Registerzeile für den Branch.

---

## 7. NICHT ENTSCHEIDBAR (2)

### #20 — `B-6-Restliste (O-1/PMC, O-3/F6, O-4/F8, O-B, O-PMC-2, N-1..N-3, R-6, E-1..E-5, E11) fehlt in der 'Vollkonsolidierung' mittag-2`
**NICHT ENTSCHEIDBAR** für die Einzelposten — die zitierte Quelle ist verschoben.
**Womit ich gesucht habe:** `docs/sessions/20260806-UEBERBLICK-workflow-ergebnisse.md`
(94.248 B, mtime 07.08. 02:17), Zeilen 300-340 gelesen — dort steht **nicht mehr** die
B-6-Restliste, sondern die Abschnitte **G / H / I** (Sicherungs-, Buchführungs- und
Struktur-Posten). Die Zeilenangabe `:304-337` des Audits ist gegenstandslos.
Inhaltlich ist Abschnitt **H-1** derselben Datei („18 Positionen wirklich verloren: KK-5/P-1,
O-A + Kalibrier-Stichprobe, A10, A11, A12/E-14, E-07-Kriterien K1-K5/N1-N3, DEG-3 …") die
**Quelle vieler dieser 43 Positionen** — die Liste ist also fortgeschrieben worden, nur
anders geschnitten.
**Nicht ermittelt:** Einzel-Dispositionen für O-1/PMC, O-3/F6, O-4/F8, O-PMC-2, N-2, N-3,
E-1..E-5, E11. Belegt geklärt sind aus der Liste nur R-3 (geschlossen, LEDGER:7402/:7567) und
N-1 (siehe #10).

### #22 — `E-18 anhang:forward ('Owner-Dekret: HAUPT-ZIEL des Gesamt-Systems'): im Code gelandet, Aktivierungsstatus verschwindet komplett aus den 07.08.-Abschnitten`
**NICHT ENTSCHEIDBAR** für den Aktivierungsstatus — er ist von hier aus nicht messbar.
**Was ich belegen kann (super `.gitlab-ci.yml`, Arbeitsverzeichnis):** der Job existiert
(`:1093`), ist **inert by default** (`:1115` `if: '$COMDARE_ANHANG_FORWARD == "true" &&
$CI_COMMIT_BRANCH == "development"'`) und hat einen zweiten Riegel im Skript (`:1120-1121`).
**Was ich belegen kann (Entscheid):** die Ziel-Branch-Frage (das ältere „R2") ist
**entschieden** — LEDGER:7100: *„E-1 (289-Ziel-Branch): (a) development GEWAEHLT."*
**Was ich nicht feststellen kann:** ob `COMDARE_ANHANG_FORWARD` auf Projekt 288 gesetzt ist.
Das ist eine CI-Projektvariable; ich habe keinen Cluster-/API-Zugriff und die Linie ist für
diese Session read-only. `E-18` und `anhang:forward` haben im Ledger **0 Treffer ab Zeile 7250** —
der Aktivierungsstand ist also auch dort nicht dokumentiert.

---

## 8. WAS ICH NICHT KLÄREN KONNTE

1. **Mess-Manifest / Provenance (dritter Teil von #3).** Ich habe die Anhänge B/E gemessen und
   die FF0-Deckung belegt, aber **nicht** ermittelt, wo das Mess-Manifest lebt und ob es die
   Pflichtspalten + Fingerprint-Provenienz trägt. Kein Suchlauf gefahren — ungeprüft.
2. **Die Einzelposten der B-6-Restliste (#20).** Siehe dort: Quelle verschoben, neun bis elf
   Kurz-Ids ohne ermittelten Status.
3. **`COMDARE_ANHANG_FORWARD` auf Projekt 288 (#22).** Nicht messbar ohne Cluster-Zugriff.
4. **B-3 aus dem PMC-Paket (#9)** — getrennte PMU-Domänen-Ablage im CSV-/Lager-Schema. Das
   liegt im aktuell belegten Baugebiet; ich habe bewusst nicht am Code gemessen, um einem
   arbeitenden Agenten nicht in einen wandernden Stand hineinzumessen. **Status ungeprüft.**
5. **Ob die V-13..V-19-Einzeldispositionen irgendwo existieren (#1).** Ich habe den Dossier-
   Abschnitt §17.8 gelesen; er nennt Bilanz und „wichtigste Ausgänge", aber nicht jede der
   20 Positionen. Ob die vollständige Aufstellung in `docs/sessions/20260806-DELTA-abc-straenge-vs-neue-wellen.md`
   steht, habe ich **nicht** nachgesehen.
6. **Die Zeilen 5387/5540/5552 (DEG-3, #16)** habe ich nicht einzeln gelesen — ich habe die
   Dreifachbuchung aus LEDGER:8430 übernommen, wo der Ledger sie selbst nennt. Das ist ein
   **Ledger-Zitat, kein eigener Beleg**; die Code-Lücke dagegen habe ich selbst gemessen.

---

## 9. WAS MIR DABEI AUFGEFALLEN IST

### 9.1 Zwei A15 — die Kollision aus dem Auftrag ist am Objekt belegt
`A15` bezeichnet im Korpus **zwei** Posten. LEDGER:8339 (abend-1, aus
`docs/sessions/20260803-FAHRPLAN-gesamtkette-wellen-phasen.md:7-42`) listet als
Fahrplan-Phase 3: *„A9-xlsx, A7/E-04-Rest, A14/OS-U4, **A15 FK-3/FK-4**, A10 HW, A11+A12,
E-19, Thesis C1"* — das ist das **Fehlerklassen-Framework**. Der `A15` dieses Reconciles
(LEDGER:7878-7882) ist der **§55-Gesamt-Reconcile**. Von den drei `A15`-Treffern ab Zeile
7250 gehört einer zum jeweils anderen Posten. Wer `grep A15` fährt, landet in 33 % der Fälle
falsch.

### 9.2 Die Kürzel-Kollisionen sind kein Randphänomen, sie sind der Verlustmechanismus
Belegt in diesem Durchgang, **zusätzlich** zu den vom Dossier schon benannten:

| Kürzel | Bedeutung A | Bedeutung B | Beleg |
|---|---|---|---|
| `A15` | §55-Gesamt-Reconcile | Fehlerklassen FK-3/FK-4 | LEDGER:7878 vs. :8339 |
| `O-A` | Bau-/Mess-Matrix-Umfang (06.08.) | MODI-SEQUENZ `compare` vor `release` (07.08.) | #7 vs. LEDGER:7625 |
| `D-4` | `kCebFingerprint`-Injektivität | `allow_failure` am Voll-Mess-Batch | #24 vs. #8 |
| `R-2` | E-18-Ziel-Branch | XML-Trennung + 4096er-Slicing | LEDGER:7114 vs. :7572 |
| `F3` | xlsx-Writer (01.08.) | Scheibe-6-Fixture (06.08.) | DOSSIER:1690 |
| `E18-SNAP` | Feature-Paket (Snapshot-Ordner) | Branch `b-e18-snap` (geparkt, Veto) | Register :67 vs. #43 |
| `P-1` | KK-5 `allow_failure` | 30 Review-TODOs im Verifikations-Backlog | #8 vs. DOSSIER:1126 |
| `T-n` | Achsen T0-T18 / Themen T-8..T-10 / Fenster T1-T4 | — | LEDGER:8367-8369 |
| `B-1` | PMC-Bauposten | E-18-Vorwärtskanal | #9 |

**Der Ledger warnt bei :8367-8372 selbst davor** („Wer eine dieser Marken liest, muss zuerst
den Namensraum bestimmen") — und produziert im selben Dokument weiter neue Kollisionen.
Ein Vorschlag, den ich nicht entscheide, sondern nur nenne: **jede neue Kurz-Id bekommt ein
Datums- oder Bereichspräfix** (`D4-0806-FPRINT`, `O-A-0806-MATRIX`). Das kostet acht Zeichen
und entwertet keinen Bestand.

### 9.3 Der Ledger irrt heute nachweislich in **beide** Richtungen
- **Erledigtes als offen:** LEDGER:7885 führt GN-9 als „hat bis heute keinen Slot", während
  DOSSIER:3340 ihn als superseded disponiert. LEDGER:7883 führt A14/FF0 als ungelöst,
  während die Anhänge B/E am Objekt keine Stubs mehr sind.
- **Offenes als erledigt:** LEDGER:7016 entlastet einen xlsx-Writer, der nicht existiert —
  wörtlich unverändert, ohne Korrekturvermerk (#39).
Beide Richtungen entstehen aus derselben Quelle: **eine Behauptung wurde protokolliert,
statt sie zu prüfen.** Deshalb trägt jede VOLLZOGEN-Zeile oben eine Commit-SHA oder eine
Code-Zeile, nie einen Ledger-Satz.

### 9.4 Zeilennummern altern schneller als Aussagen
Drei Fälle in diesem Durchgang:
- `experiment_plan_director.hpp`: Ledger sagt `:1332-1333`, Audit sagt `:1373`, real `:1394` (#8).
- `UEBERBLICK:304-337` trägt heute anderen Inhalt (#20).
- Die gesamte Audit-Zeilenlage ab LEDGER:7250 ist um bis zu 1896 Zeilen verschoben.
**Was hält:** Datei + Symbol/Zitat. **Was nicht hält:** Datei + Zeile. In den Belegen oben
steht deshalb, wo möglich, der Wortlaut oder der Bezeichner mit dazu.

### 9.5 Die Suchfallen, die in diesem Durchgang wirklich zugebissen haben
- **`grep 'ESET'` liefert 26 Treffer, `grep -w 'ESET'` liefert 0.** Alle 26 stecken in
  `UMGESETZT`/`GESETZ`/`GESETZT`/`WERTESET`/`AUFGESETZT`/`DURCHGESETZT`/`RESET`. Ein Zähler
  ohne Wortgrenze hätte #33 für gebucht erklärt.
- **`A12` kollidiert mit dem golden-CRC-Anker `0xF1C1F26A1232073B`** — dieselbe Falle in
  Gegenrichtung: sie erzeugt Treffer, wo keine sind (#13).
- **Der stale Thesis-Klon** hat mir eine überholte Anhang-A-Fassung geliefert; erst die
  Messung am Ref `origin/development` gab den heutigen Stand (#42). Die Regel aus dem
  Fallen-Register („vor jeder Messung Checkout **und** Branch feststellen") gilt für Klone
  genauso wie für Submodule.
- **Positiv-Kontrolle rettet den Nullbefund:** bei #16 war „0 Treffer" erst eine Aussage,
  nachdem die elf Geschwisterdateien je einen Treffer lieferten; bei #28 erst, nachdem
  `prt-art` 111 Treffer lieferte.

### 9.6 Der Audit hat sich selbst überholt — und das ist der eigentliche Befund
Fünf der 43 Positionen sind **zwischen Erhebung (09:40) und heute Abend gelandet**: T-9 um
11:04, M-3a am Abend, die Talos-Korrektur am Nachmittag, D-4 schon am Vorabend, die
Frist-Verifikation in abend-9. Ein Audit gegen einen Ledger, der stündlich wächst, produziert
zwangsläufig Fehlbefunde — nicht aus Nachlässigkeit, sondern **aus Bauart**.
Die praktische Folge für den nächsten Durchgang: **jeder Audit-Bericht braucht seinen
Erhebungs-Ref im Kopf** (Ledger-Zeilenzahl + Commit-SHAs aller vier Repos), damit ein Leser
sofort sieht, gegen welchen Stand er gilt. Dieses Dokument trägt ihn oben.

### 9.7 Eine Beobachtung zum Zuschnitt, keine Empfehlung
Die **26 unikaten Posten mit Restarbeit** (5 OWNER-FRAGE + 19 OFFEN + 2 NICHT ENTSCHEIDBAR)
zerfallen sauber in drei Klassen:
- **6 rein dokumentarisch, je eine Zeile:** #1 (Ledger-Zeile zur V-Disposition), #11
  (Kriterien wörtlich hineinkopieren), #29 (T5 formal buchen), #33 (B4.1 als obsolet
  markieren), #43 (Registerzeile für `b-e18-snap`) — und #17 zumindest für die Registerzeile.
- **13 mit am Objekt gemessener Substanz:** #5, #8, #9, #14, #15, #16, #18, #28, #30, #32,
  #38, #39, #42.
- **5 Owner-Entscheidungen** und **2 nicht entscheidbare**.

Dazu kommen **vier Brücken-Zeilen** für die SUPERSEDED-Posten (#3, #4, #23, #25) — sie
zählen nicht zum Rest, aber ohne sie fallen dieselben vier bei der nächsten Konsolidierung
erneut als „fehlt ganz" an. Genau das ist im vorliegenden Audit dreimal passiert.
