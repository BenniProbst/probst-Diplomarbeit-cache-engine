# SOLL-KARTE — verify-93 (#93-VERIFY-GRUPPEN A/C/D, C-9)

Erhoben von: Sonnet-max-Planungs-Erheber, 21.08.2026. NUR LESEN — keine Objekt-Verifikation,
kein Fix. Diese Karte beschreibt ausschliesslich die SOLL-/Planungs-Lage; ob die Behauptungen
im Strang-Bericht am Objekt tatsaechlich stimmen, ist Sache des Audits, das diese Karte konsumiert.

**Aufgaben-Identitaet:** verify-93 ist der C-9-Verify-Strang aus TEIL 3 / SLOT [C] WE des
W2-ABFOLGE-DESIGN.md ("S6 Verify: C-9 #93-Gruppen", Zeile 811) — eine **Nachverifikation von
DREI der ACHT Gruppen** des urspruenglichen Task #93 "W1-Vollstaendigkeits-Audit" (Board: completed)
gegen den *inzwischen gelandeten* Stand ce/development 66de5c09 (Tip der #15-Bump-Kette). Referenz
gepruefter Ergebnis-Bericht: `/home/comdare/backups-workflow/20260820-w2-sofortstaffel/verify-93-ergebnis.md`
(279 Zeilen, voll gelesen) + Quittungs-Buendel `verify-93-rohquittungen/` (10 Log-Dateien, 292K,
Objekt-Stichprobe bestaetigt: `ls` liefert exakt 10 Dateien wie behauptet).

---

## PRUEFLISTE

Granularitaet: jede in C-9 genannte Kuerzel-Einheit ist EIN P-Punkt (Memory-Doktrin "Stempel-Kuerzel
immer zerlegen, nie flach"). Wo mehrere Kuerzel per Quellentext explizit DIESELBE Sache sind, ist das
unter "Aequivalenz" vermerkt — das ist NICHT dasselbe wie die 17-Posten-Bilanz des Strang-Berichts
(Abschnitt 9 dort zaehlt bereits dedupliziert; diese Liste zaehlt Anforderungs-EINHEITEN, nicht
Befund-EINHEITEN).

| P-# | WAS gefordert (woertlich, Quelle+Zeile) | WIE am Objekt pruefbar | Strang behauptet geliefert? |
|---|---|---|---|
| **P-01** | Gruppe A / X-9 **N1**: "vl3-N1/N5/N6 aufschluesseln" — clang-Haelfte des Warnungs-Reviews. *W2-ABFOLGE-DESIGN.md:229.* Aequivalent zu "M-6/F-D-DEKLARIERT-Quittung + N1-Deklaration" (:230) — per ergebnis.md 3.4 und STAFFEL1-SYNTHESE.md:188 ("F-45 = N1 = M-6/F-D, eine Sache") EINE einzige Anforderung unter drei Namen. | `~/backups-workflow` nach clang-Warnungs-Review-Artefakten nach 17.08. durchsuchen (Gegenprobe: Kombibau-LOGS zaehlen NICHT als Review); Registerbeschluss Z.816-818 pruefen, ob gruene ctest-clang-Zellen als Ersatz gelten duerfen. | **JA** — ergebnis.md 3.1+3.4: STATUS "OFFEN — DEKLARIERT" (kein Artefakt seit 17.08., gruene Zellen ausdruecklich NICHT als Ersatz akzeptiert), GETRAGEN-Vermerk W2-2/#106. |
| **P-02** | Gruppe A / X-9 **N5** = K10-4-Haelfte "ROT-3": "--debug x plan dump\|ci\|cmake" Testabdeckung der Exit-6-Zweige. *W2-ABFOLGE-DESIGN.md:229 + :233 ("K10-4 ROT-3").* | `git -C $CE grep -n -E "debug.*(dump\|plan ci\|plan cmake)\|plan (dump\|ci\|cmake).*debug" 66de5c09 -- tests/` (Treffer-Zahl); Gegenprobe mit bekanntem String gegenpruefen (Falsch-Null-Wache). Anker: `apps/experiment_planner/main.cpp:155`/`:166` (`if (gate.abbruch) return 6;`). | **JA** — ergebnis.md 3.1: "0 Treffer" + Gegenprobe gefahren (nur Kommentar-Treffer test_experiment_plan_director.cpp:711); STATUS "OFFEN". |
| **P-03** | Gruppe A / X-9 **N6**: stdout-Bytevergleich main.cpp:515 UND main.cpp:717 (mit/ohne `--debug`). *W2-ABFOLGE-DESIGN.md:229.* | `git -C $CE show 66de5c09:apps/experiment_planner/main.cpp` Zeilen 514-515 und 716-719 lesen; Beleg-Commits (79171599, 6cdcf1c9) per `merge-base --is-ancestor` gegen 66de5c09 pruefen; referenzierte Logs `~/backups-workflow/20260819-fixstrecke2-logs/m5_lauf{1,2}.{out,err}` auf Existenz+Groesse pruefen. | **TEILWEISE** — ergebnis.md 3.1: ":515-Haelfte BEHOBEN (GEMESSEN)" mit Byte-Beleg (14892 B, cmp EXIT=0); "--debug-Haelfte OFFEN" (die eigentliche mit/ohne-`--debug`-Messung fehlt noch, getragen W2-1). |
| **P-04** | Gruppe A / K10-4 **_pclose-Haelfte**: `l.rc` ohne `WEXITSTATUS`-Dekodierung. *W2-ABFOLGE-DESIGN.md:229.* | `git -C $CE show 66de5c09:tests/unit/test_vl3_debug_flag_sperre.cpp` Zeilen 80-93 lesen; auf `WIFEXITED`/`WEXITSTATUS` pruefen (POSIX-Zweig) bzw. Direktwert (Windows-Zweig). | **JA** — ergebnis.md 3.2: STATUS "BEHOBEN" mit Zeilenzitat. *Hinweis:* Wellenplan §23.2 (Freeze-Check-Tafel, Zeile 3522-3523) fuehrte diesen Punkt bereits VOR verify-93 als "ENTLASTET AM OBJEKT" — verify-93 bestaetigt eine bereits anderswo erhobene Entlastung, keine Neuentdeckung. |
| **P-05** | Gruppe A / K10-12 **F1** (Floor-Zahlen-Falle 495/494 vs. PRUEFLING 496). *W2-ABFOLGE-DESIGN.md:229-230 ("K10-12 Wstringop-Verbleibsquittung").* | `git -C $CE show 66de5c09:scripts/ci_test_inventory_floor.txt` lesen, Werte je Host-Klasse (avx512f/avx2/basis) mit Beleg-Commit c2da9d1a abgleichen. | **JA** — ergebnis.md 3.3: STATUS "BEHOBEN/ABSORBIERT". *Achtung fuer das Audit:* STAFFEL1-SYNTHESE.md:154/189 vermerkt ausdruecklich "Landung misst NEU (H-7)" — dieser Floor-Wert wird beim W2-Staffel-1-Lande-Zug ohnehin frisch am gemergten Endstand gesetzt; der verify-93-Wert ist ein Zwischenstand, kein Endbeleg. |
| **P-06** | Gruppe A / K10-12 **F2** (-Wstringop-overflow-Vorbestand, kein globales -Werror). *W2-ABFOLGE-DESIGN.md:229-230.* | `git -C $CE show 66de5c09:cmake/compiler_flags.cmake` Zeilen 38-41 lesen; `git -C $CE grep -i stringop 66de5c09` auf Unterdrueckungs-Pragmas im Eigencode pruefen (Fremdcode ext/ ausgenommen). | **JA** — ergebnis.md 3.3: STATUS "OFFEN — GETRAGEN", Traeger = Task #71 (Triage-Sammelposten Leser-Hebungen, Board: pending). |
| **P-07** | Gruppe A / K10-12 **F3** (EXCLUDE_FROM_ALL-Betriebsregel). *W2-ABFOLGE-DESIGN.md:229-230.* | `git -C $CE show 66de5c09:tests/unit/CMakeLists.txt` Zeile 2090 (+1955, 2099, 2126, 2157, 2318) lesen. | **JA** — ergebnis.md 3.3: STATUS "BEHOBEN/DOKUMENTIERT im Baum". |
| **P-08** | Gruppe A / K10-12 **F4** (RCU-Flake, via HY-A F-13). *W2-ABFOLGE-DESIGN.md:229-230.* | `git -C $CE merge-base --is-ancestor f45e995b 66de5c09` (Exit-Code + Ausgabe). | **JA** — ergebnis.md 3.3: STATUS "BEHOBEN", Ancestor-Beweis literal ("JA ancestor"). |
| **P-09** | Gruppe C **X-4**: "RCU-Runde-2-Lens-Deckung ODER Abweichung ausweisen." *W2-ABFOLGE-DESIGN.md:231.* Abnahme-Formel traegt selbst schon das Alternativ-"ODER" — ein reines BEHOBEN/OFFEN ist hier NICHT die volle Formel. | Fundflaeche der Runde 2 (5 Dateien lt. FIXRUNDE2-Log) gegen den Folge-Lens `BU 20260817-hy-a-folge-lens/lens-funde.md` abgleichen; Traeger-Commits (81b9f23e, e3fc1390, f45e995b, a43ea18f, 87fa9473, 7b4464fd) per `git log`/`merge-base` gegen 66de5c09 pruefen; Abnahme-Serien in `FIXRUNDE2-abnahme-endfassung.log` (Buendel-Kopie vorhanden) auf die Zahlen `OHNE_LAST: gruen=20 rot=0` / `SERIE[A/B]: 40/40 gruen` pruefen. | **JA (mit ausgewiesener Abweichung)** — ergebnis.md 4.1: STATUS "BEHOBEN — 1 Abweichung AUSGEWIESEN" (kein eigener Dritt-Lens ueber den Runde-2-Diff selbst gefahren; Rest-Risiko benannt, nicht verschwiegen — das erfuellt die "ODER Abweichung ausweisen"-Klausel woertlich). |
| **P-10** | Gruppe C **X-5**: "rcu-Serien reproduzieren ODER 'nicht persistiert' ausweisen." *W2-ABFOLGE-DESIGN.md:231-232.* Ebenfalls eine ODER-Formel, kein reines BEHOBEN/OFFEN. | Existenz der vier `20260817-BEFUND-rcu-*.log`-Dateien in `~/backups-workflow/20260817-welle-vorlauf-protokolle/hy-a/` pruefen (mtime, Groesse); Literale `SERIE[vor_fix/A]: durchlaeufe=25 gruen=19 rot=6` etc. gegen die Datei-Inhalte gegenlesen; `f45e995b` Ancestor-Beweis. | **JA** — ergebnis.md 4.2: STATUS "BEHOBEN — ROHQUITTUNGEN SIND PERSISTIERT" (die Audit-These "nirgends persistiert" wird als am heutigen Bestand widerlegt bezeichnet; Reproduktion/Bau ausdruecklich NICHT noetig — damit ist NICHT die "reproduzieren"-Haelfte, sondern die "ODER nicht-persistiert-ausweisen"-Haelfte gewaehlt, nur mit umgekehrtem Vorzeichen: gefunden statt nicht-gefunden). Alle 4 Logs + End-Nachmessung zusaetzlich ins 10-Log-Buendel kopiert. |
| **P-11** | Gruppe C **X-12-Messung**: "(Ernte-Frage GESCHLOSSEN; BAU-Haelfte gated [OG-1/OG-6])" — NUR die Laufzeit-Haelfte MESSEN, NICHT bauen. *W2-ABFOLGE-DESIGN.md:232-233.* | CT-/Compose-Seite pruefen (`include/cache_engine/abi/anatomy_fingerprint.hpp` Zeilen ~1602/1623, `hybrid/hybrid_stempel_kette.hpp` :99-101); Laufzeit-Attach-Weg pruefen: `git -C $CE grep -rn -E "name_line\s*=\|set_name\|sha256.*attach\|attach.*sha" 66de5c09 -- libs/cache_engine/hybrid/ libs/cache_engine/builder/pruef_dock/ libs/cache_engine/abi/` (Treffer-Zahl+Art); 3 fail-loud-Wachen in `hybrid_dock_contract.hpp` (:118/:119) benennen. | **JA, als MESSUNG (kein Bau)** — ergebnis.md 4.3: STATUS "MESSUNG VOLLZOGEN — Laufzeit-Befuellung FEHLT WEITERHIN; BAU bleibt owner-gated". Der Bau selbst ist EXPLIZIT NICHT geliefert und war laut C-9-Text auch nicht gefordert (siehe NICHT-GEFORDERT). Owner-Vorlage-Zeile eingetragen: "Laufzeit-Befuellung je Pruefdock-Tier-Binary ... nach C-3a-/#38a2-Entscheid als eigener Board-Task; Hash-Laenge = F2-Punkt". Diese Vorlage steht auch als Punkt 9 in STAFFEL1-SYNTHESE.md:212-213 ("OG-1/OG-6 (verify-93 X-12)") — noch unbeantwortet. |
| **P-12** | Gruppe D **K7a-3**: "BEIDE Anker (abi_adapter.hpp vs. mess_achsen_naht.hpp:477-517) abgleichen **VOR** Gruppe-D-Messung." *W2-ABFOLGE-DESIGN.md:233-234.* Reihenfolge-Pflicht ist Teil der Anforderung, nicht nur der Inhalt. | `git -C $CE show 66de5c09:libs/cache_engine/profile_facade/mess_achsen_naht.hpp` Zeilen 477-520 + `\| grep -n throw` pruefen; `git -C $CE show 66de5c09:libs/cache_engine/anatomy/abi_adapter.hpp` Zeilen 470-495 + throw-Grep pruefen; Ursachen-Kommentar in mess_achsen_naht.hpp:279-286/:336 auf B3/KON37-01/KON34-04-Bezug pruefen. | **JA, UND die Reihenfolge-Pflicht ist strukturell sichtbar erfuellt** — ergebnis.md fuehrt Abschnitt 2 "GRUPPE D ZUERST: K7a-3 Anker-Abgleich (Pflicht VOR Gruppe-D-Messung)" VOR Abschnitt 3 (Gruppe A), Abschnitt 4 (Gruppe C) und dem Gruppe-D-Rest in Abschnitt 5 — die Textreihenfolge im Bericht spiegelt die geforderte Bearbeitungsreihenfolge. STATUS "BEHOBEN" (beide Anker als stale erkannt; neuer Messanker :227-340 + :790 benannt). *Siehe SPANNUNGEN zu einer Praezisierung dieses Befunds.* |
| **P-13** | **T-10/Z-8** g2-Nebenbefund (1): gcc-Release-Warnung `axis_03a_search_algo_interpolation.hpp:256`, namentlich in #93-A aufnehmen. *W2-ABFOLGE-DESIGN.md:235; Wellenplan §22.2 T-10 (Zeile 3301-3305) + §22.4 Z-8 (Zeile 3425).* Wellenplan-Formel woertlich: "GETRAGEN: Wstringop-Verbleib (12.4 -> #93-A [K10-12]). FEHLT: die drei g2-Nebenbefunde nennt keine Quelle. NACHZUG: namentlich in #93-A/W2-2 aufnehmen." | `git -C $CE show 66de5c09:libs/cache_engine/organ_axes/lookup/axis_03a_search_algo_interpolation.hpp` Zeilen 250-262 lesen; letzten Commit auf der Datei pruefen (Behauptung: 5fa37f36, kein Fix seit g2). | **JA** — ergebnis.md 5.1(1): namentlich benannt, STATUS "OFFEN", Traeger W2-2-Warnungs-Runde. |
| **P-14** | **T-10/Z-8** g2-Nebenbefund (2): clang-22-Warnung vendored `gtest-printers.h:524`, namentlich aufnehmen. *Gleiche Quelle wie P-13.* | Live-Literal in `~/backups-workflow/.../BEFUND-rcu-gegenprobe-nach-fix.log` (~Zeile 351) pruefen: `"gtest-printers.h:524:35: warning: implicit conversion from 'char8_t' to 'char32_t' ..."`; `cmake/third_party/googletest-1.15.2.tar.gz` FetchContent + `gtest_setup.cmake` auf SYSTEM-Abschirmung pruefen. | **JA** — ergebnis.md 5.1(2): namentlich benannt, STATUS "OFFEN", Traeger W2-2 (SYSTEM-Include/Isolation, NIE im Fremd-Tarball fixen — das ist eine explizite Leitplanke, keine freie Fix-Wahl). |
| **P-15** | **T-10/Z-8** g2-Nebenbefund (3): 12 Non-ASCII-Altbestandszeilen `axis_variant_version_table.hpp`, namentlich aufnehmen. *Gleiche Quelle wie P-13.* | `git -C $CE merge-base --is-ancestor cb856212 66de5c09`; `git show 66de5c09:...axis_variant_version_table.hpp \| grep -c -P '[^\x00-\x7F]'` (SOLL 0); Gegenprobe mit bekanntem Non-ASCII-Byte (SOLL 1). | **JA** — ergebnis.md 5.1(3): STATUS "BEHOBEN", Ancestor-Beweis + Nachmessung 0 + Gegenprobe 1. |
| **P-16** | **X-2-Nachbuchung**: G3/G4-Literale des k2-Vollbaus sichern+buchen. *W2-ABFOLGE-DESIGN.md:235; Zeile 60: "Nachbuchung der G3/G4-Literale dann in #93-A, [C] C-9. QUELLE K3:TeilB/X-2."* | Output-Dateien `~/backups-workflow/20260819-k2-vollbau-outputs/{bl5ldht9z,bb3upsvgg}.output` auf Existenz+Inhalt pruefen (`CFG_RC=0`/`BUILD_ALL_RC=0`); Nachzug-Ordner `20260820-k2-vollbau-outputs-nachzug/` MANIFEST + `k2_ctest.log` ("100% tests passed... 498") pruefen. | **JA** — ergebnis.md 5.2: STATUS "BEHOBEN — KEINE LUECKE"; zusaetzlich Beleg, dass die Nachbuchung bereits am 19.08. ueber `w93-journal-ENDSTAND.jsonl` vollzogen war (verify-93 bestaetigt nur, erfindet nichts neu). |
| **P-17** | **Prozess-Pflicht NAMENSFALLE**: "N1-N5-N6 (vl3) != N-1..N-6 (Bauplan) beachten." *W2-ABFOLGE-DESIGN.md:236, QUELLE TeilE-Warnung.* Memory-Doktrin deckt sich: "STEMPEL-KUERZEL IMMER ZERLEGEN — Explore-Cluster gegen Plan pruefen." | Struktur des Berichts pruefen: steht die Unterscheidung VOR den ersten Messungen, und wird sie in JEDER Gruppe eingehalten (keine Vermischung mit `N-1`=S-6c/S-21, `N-2`=S-6d etc.)? | **JA** — ergebnis.md Abschnitt 0 "NAMENSFALLE (TeilE-Warnung) — verbindlich fuer diese Datei" steht als eigener Abschnitt VOR Abschnitt 1, mit expliziter Gegenueberstellung beider Zaehlwerke. |
| **P-18** | **Messobjekt-Bindung + Frist**: "am gelandeten Stand" messen (nicht am Audit-Zeitpunkt-Stand), Bilanz in Abschnitt 9, "Quittungen bis Di-25." *W2-ABFOLGE-DESIGN.md:228 ("Quittungen bis Di-25"), :237-239 ("ABNAHME: je Posten am gelandeten Stand ... -> Abschnitt 9").* | Kopfzeile des Berichts auf den benannten Commit pruefen; jeden Messschritt auf `git -C $CE show 66de5c09:...` bzw. `... 66de5c09 -- ...` pruefen (kein anderer SHA); Zeitstempel der Lieferung (Datei-mtime `verify-93-ergebnis.md`: 21.08. 08:39) gegen die Frist Di 25.08. pruefen. | **JA** — Kopf nennt "Messobjekt: ce/development = 66de5c09" explizit als den #15-Bump-Kette-Endpunkt; ALLE Messschritte binden an 66de5c09; Bilanz steht als eigener Abschnitt 9; Lieferung 21.08. liegt vier Tage vor der Di-25-Frist. |

**Wichtig fuer das Audit:** Diese 18 P-Punkte sind Anforderungs-Einheiten aus dem C-9-Text, NICHT
identisch mit der 17-Zeilen-Bilanztabelle in ergebnis.md Abschnitt 9 (die zaehlt bereits
zusammengefasste Befund-Objekte: z. B. fasst sie P-01+P-04 als "M-6+F-D" in einer Zeile, und
K10-12 F1-F4 als vier separate Zeilen). Die Bilanz "10 BEHOBEN/VOLLZOGEN, 7 OFFEN, 0 traegerlos"
bezieht sich NICHT 1:1 auf P-01..P-18 — Doppelzaehlung ist bereits vom Strang selbst
gegengerechnet (P-01≡Teil von M-6/F-D-Zeile, P-02≡Teil der ROT-3-Zeile). Wer die 18 P-Punkte
gegen die 17-Zeilen-Tabelle abgleicht, muss diese Aequivalenzen mitfuehren, sonst entsteht ein
Phantom-Delta.

---

## ABNAHME-FORMELN (woertliche Zitate)

**Haupt-Abnahmeformel (C-9, bindend fuer den gesamten Strang):**
> "ABNAHME: je Posten am gelandeten Stand BEHOBEN/OFFEN gemessen -> Abschnitt 9; Quittungen im
> Freeze-/Di-25-Text." (W2-ABFOLGE-DESIGN.md:237-239)

**Frist:**
> "C-9 #93-VERIFY-GRUPPEN A/C/D (paralleler Verify-Strang, Quittungen bis Di-25)" (W2-ABFOLGE-DESIGN.md:228)

**Alternativ-Formeln innerhalb Gruppe C (verfeinern die Haupt-Formel fuer X-4/X-5/X-12 — kein
reines BEHOBEN/OFFEN, sondern ODER-Klauseln):**
> "X-4 RCU-Runde-2-Lens-Deckung ODER Abweichung ausweisen + X-5 rcu-Serien reproduzieren ODER
> 'nicht persistiert' ausweisen + X-12-Messung (Ernte-Frage GESCHLOSSEN; BAU-Haelfte gated
> [OG-1/OG-6])" (W2-ABFOLGE-DESIGN.md:231-233)

**Reihenfolge-Formel Gruppe D:**
> "Gruppe D: K7a-3 BEIDE Anker (abi_adapter.hpp vs. mess_achsen_naht.hpp:477-517) abgleichen VOR
> Gruppe-D-Messung" (W2-ABFOLGE-DESIGN.md:233-234)

**Uebergeordnete Formel des Ur-Audits #93** (nicht direkt C-9's eigene, aber der Rahmen, aus dem
Gruppe A/C/D stammen — Frist-Dreiteilung als Alternativ-Klassenschema zur einfachen
BEHOBEN/OFFEN-Dichotomie):
> "8 sequentielle Pruefgruppen (...) + Synthese mit Frist-Dreiteilung (offen-vor-F2 /
> gebaut-ungelandet / W2-deklariert / gestrichen-deklariert / unklar)" (Wellenplan §21.2, Zeile
> 2983-2987)

**Designplan-TDD-Massstab, als Qualitaets-Latte auf die EINZELMESSUNGEN angewandt (verify-93
schreibt selbst keine neuen Tests — T-1/T-7/T-8 damit nicht direkt einschlaegig; die folgenden
DREI sind die tragenden Lenses):**
> "T-3 NENNER, FREMD. Jeder Test nennt seine Grundgesamtheit und bezieht sie aus einer anderen
> Quelle als dem Pruefling ... `ASSERT` auf die Zahl VOR der Schleife." (Designplan §3, Zeile 69)
> "T-4 GEGENEINGANG. Zu jeder Zusicherung ein Eingang, bei dem sie nicht gilt." (Zeile 70)
> "T-2 AUSSAGE, NICHT ANWESENHEIT. `find()`, Existenz, Exit 0, 'wirft nicht' sind keine
> Zusicherungen. Wert, Position, Menge, Klasse." (Zeile 68)
Diese drei sind an mehreren Stellen im Bericht sichtbar erfuellt (N5: Grep+Gegenprobe; F4-Non-ASCII:
Grep+Gegenprobe mit bekanntem Byte; K7a-3: Zeilen-genaue throw-Aufzaehlung statt blosser
Existenzaussage) — als Qualitaets-Indiz, nicht als vom Audit blind zu uebernehmende Tatsache.

**GOAL-v8-Doktrinen, die den Gegenstand von verify-93 unmittelbar tragen:**
> "V11 ... Jeder aus Kommentar, Ledger oder Bericht uebernommene Zahlenwert braucht eine eigene
> Ist-Messung, bevor daraus ein Bau-Posten wird." (GOAL v8 §II.2, Zeile 273-274) — die
> Grundbegruendung dafuer, warum K7a-3 (P-12) den alten Register-Anker NICHT einfach uebernehmen
> durfte, sondern am Objekt neu pruefen musste.
> "V1 ... Jede Zahl, jeder SHA und jede Zustandsaussage aus einem Agentenbericht wird vor
> Weitergabe selbst gemessen oder ausdruecklich als ungeprueft gekennzeichnet." (§II.3, Zeile
> 278-280)
> "Der Nenner — nie eine nackte Zahl. ... Der wirksame Fix ist immer derselbe: den Nenner in die
> AUSGABE des Werkzeugs zwingen." (§II.5, Zeile 288-293)
> "`allow_failure: true` ist auf JOB-Ebene VERBOTEN." (GOAL v8, Zeile 763) — traegt die Aussage
> in P-01/ergebnis.md 3.4, dass gruene ctest-clang-Zellen das clang-Warnungs-Review NICHT ersetzen
> (ein gruenes Gate deckt nur seinen eigenen Gegenstand, nie einen anderen).
> "Widersprueche nicht glattrechnen. Beide Seiten zeigen, den Widerspruch benennen." (§II.8, Zeile
> 312) — bindet unmittelbar den SPANNUNGEN-Abschnitt dieser Karte.

**Freeze-Check-Deklarations-Tafel** (Wellenplan §23.2, Zeile 3517-3529) traegt bereits — VOR
verify-93s Lieferung datiert — anerkannte DEKLARIERT-Eintraege, die mit mehreren P-Punkten
sachlich identisch sind:
> "DEKLARIERT-W2 (...): A8/A12 clang-Warnungs-Review (P.20.9+F-D; Quellen-Differenz W2-1 vs
> W2-2/#3 MITFUEHREN) · A9/A11/A13 --debug-Matrix+N5 (M-5-Buendel W2-1) · ... · Wstringop
> (Di-25-Feinplatzierung)."
Das bedeutet: der "OFFEN — DEKLARIERT"-Status, den verify-93 fuer P-01/P-02/P-03/P-06 vergibt, ist
KEINE Erfindung des Strangs, sondern deckt sich mit einem bereits an anderer Stelle im Wellenplan
anerkannten Status-Typ. Ob die Zeile in §23.2 den verify-93-Bericht bereits ZITIERT (Ruecklauf-Pflicht
"Quittungen im Freeze-/Di-25-Text") ist NICHT geprueft — STAFFEL1-SYNTHESE.md Abschnitt 2.2 Phase 4
fuehrt "Ledger-Entwuerfe einpflegen (... verify-93 2 [Bloecke])" noch als AUSSTEHEND (Lead-Aufgabe).
Diese Rueckschreib-Pflicht ist damit zum Zeitpunkt dieser Karte NICHT erfuellt — offener Rest der
Abnahmeformel, kein Fehler des Strangs (Lead-Sache, siehe verify-93-ergebnis.md Abschnitt 10:
"LEDGER-ZEILEN-ENTWURF (NICHT eingetragen — Lead-only)").

---

## NICHT-GEFORDERT (damit das Audit keine Phantom-Funde erzeugt)

1. **Gruppen B, E, F, G, H des Ur-Audits #93 sind NICHT Teil von C-9/verify-93.** Der
   urspruengliche Task #93 lief mit acht sequentiellen Pruefgruppen: "Straenge+VL-3-Fixes |
   Stempel-Strecke S-1..S-7/S-6a-d | HY-A | B-Schalter | #17/g2 | Statistik/Menge D4/D5/##10-19 |
   Designplan-par.4-W1-Testlast | Freeze-Check-Liste par.18.3" (Wellenplan §21.2, Zeile 2983-2986).
   Drei unabhaengige Belegstellen im Wellenplan bestaetigen die Buchstaben-Zuordnung inhaltlich:
   "W1-Audit Gruppe D (#93)" im B3/Schalter-Hoheit-Kontext (Zeile 2981, => **D = B-Schalter**),
   "den Ist-Stand misst #93 Gruppe G" im Designplan-par.4-W1-Testlast-Kontext (Zeile 3101, =>
   **G = Designplan-par.4-W1-Testlast**), "GETRAGEN: die Messung (12.4 -> #93 Gruppe C)" im
   X-12/Hybrid-Kontext (Zeile 3281, => **C = HY-A**). Damit ergibt sich A=Straenge+VL-3-Fixes,
   B=Stempel-Strecke, C=HY-A, D=B-Schalter, E=#17/g2, F=Statistik/Menge, G=Designplan-par.4-W1,
   H=Freeze-Check-Liste — und C-9/verify-93 deckt NUR A, C, D (die Buchstaben passen exakt zu den
   inhaltlichen Themen der verify-93-Gruppen: A=vl3-Straeng-Nachposten, C=RCU/HY-A, D=B3/Schalter).
   **Gruppen B (Stempel-Strecke), E (#17/g2 — bereits per KON17-01/Ledger:105-106 "completed"), F
   (Statistik/Menge), G (Designplan-par.4-W1-Testlast — siehe §23.1 F2-5 "ACHT BAND-A-TESTPOSTEN"),
   H (Freeze-Check-Liste par.18.3 — siehe §23.2 selbst) haben EIGENE, von C-9 UNABHAENGIGE Traeger.**
   Ein Audit, das z. B. nach dem Stempel-Strecke-Stand (Gruppe B) oder dem #17/g2-Stand (Gruppe E)
   in verify-93 sucht, findet zu Recht nichts — das ist keine Luecke von verify-93.
2. **X-12-BAU** (Laufzeit-Befuellung je Pruefdock-Tier-Binary selbst umsetzen) ist ausdruecklich
   NICHT gefordert — die C-9-Formel selbst sagt "BAU-Haelfte gated [OG-1/OG-6]"
   (W2-ABFOLGE-DESIGN.md:233). Der Bau wartet auf einen Owner-Entscheid (C-3a-/#38a2-Familie) und
   ist ein EIGENER, spaeterer Board-Task (vgl. Wellenplan §22.2 T-7, Zeile 3280-3284: "FEHLT: der
   Folge-BAU-Task existiert nicht -- wartet deklariert auf den P4/P5-Owner-Entscheid").
3. **N1/M-6 clang-Warnungs-Review SELBST FAHREN** ist nicht gefordert — nur die DEKLARATION, dass
   er weiterhin aussteht. Der Review-Lauf selbst gehoert zu W2-2/S-12-Dual-CI (Task #106).
4. **N5/K10-4-ROT-3 Test SELBST BAUEN** (die fehlenden `--debug x dump|ci|cmake`-Tests schreiben)
   ist nicht gefordert — nur die Messung/Feststellung der Luecke. Traeger ist Task #101
   (Board-Status zum Zeitpunkt dieser Karte: **completed** — ein Nachfolge-Task hat diesen Teil
   inzwischen aufgegriffen; das ist ausserhalb des Erhebungsauftrags dieser Karte, nicht
   gegenzupruefen).
5. **F2/-Wstringop-overflow HAERTEN** (die Warnkategorie tatsaechlich beheben) ist nicht gefordert
   — die C-9-/§22.2-T-10-Formel verlangt nur "verifiziert und festgeschrieben", der Traeger fuer
   eine etwaige Haertung ist Task #71.
6. **Die beiden restlichen g2-Nebenbefunde (P-13/P-14) SELBST BEHEBEN** ist nicht gefordert — nur
   NAMENTLICHE Aufnahme in #93-A. Der Fix gehoert zur "W2-2-Warnungs-Runde" (Phase 3 des
   Lande-Zugs, siehe STAFFEL1-SYNTHESE.md Zeile 89-93).
7. **Ein eigener Dritt-Lens ueber den RCU-Runde-2-Diff** (P-09/X-4) ist nicht separat gefordert —
   die Formel laesst "ODER Abweichung ausweisen" ausdruecklich als gleichwertige Alternative zu;
   verify-93 hat diese Alternative gezogen (Abweichung benannt statt neuer Lens gefahren).
8. **Kein Bau, kein Worktree, keine axes/topics/heuristik/golden-Beruehrung** — das ergibt sich
   nicht direkt aus C-9's Wortlaut, aber aus dem Aufgaben-Steckbrief dieses Erhebungsauftrags
   ("Kein Bau-Zweig (Doku-/Read-only-Strang)") und wird vom Strang selbst mehrfach bestaetigt
   ("Kein Posten gebaut, kein Worktree, keine YAML/axes/topics/heuristik/golden-Datei beruehrt",
   ergebnis.md Zeile 268). Ein Fund, der verify-93 fuer das FEHLEN eines Branches/einer
   Code-Aenderung ruegen wuerde, verfehlt den Auftrag — siehe aber SPANNUNGEN Punkt 1 zur
   urspruenglichen Slot-Planung.

---

## SPANNUNGEN (nicht glattgezogen, juengere Schicht benannt)

**1. Bau-Slot-Zuteilung (TEIL 3, aeltere Planungs-Schicht) vs. tatsaechliche Read-only-Ausfuehrung
(juengere/finale Schicht).**
Die Slot-Tabelle in TEIL 3 SLOT [C] weist dem Verify-Strang ausdruecklich einen Bau-Slot zu und
zaehlt ihn gegen den Drei-Bauten-Deckel:
> "S6 Verify: C-9 #93-Gruppen (nutzt Bau-Slots! gegen Deckel zaehlen)" (W2-ABFOLGE-DESIGN.md:811)
Dem widerspricht sowohl der Aufgaben-Steckbrief dieses Erhebungsauftrags ("Kein Bau-Zweig
(Doku-/Read-only-Strang)") als auch der Strang-Bericht selbst ("Kein Bau, kein Worktree, kein Slot
(kein Configure/Build in diesem Strang)", ergebnis.md Zeile 33-34, und "Kein Posten gebaut, kein
Worktree", Zeile 268) sowie STAFFEL1-SYNTHESE.md Zeile 21 ("kein Branch/Worktree"). **Diese
Diskrepanz wird NICHT glattgezogen:** die Slot-Planung ging davon aus, dass Gruppe C (X-5
insbesondere) eine Reproduktion der RCU-Serien per Vollbau erfordern koennte ("rcu-Serien
reproduzieren ODER 'nicht persistiert' ausweisen" — "reproduzieren" impliziert Bau-Bedarf). Die
tatsaechliche Ausfuehrung fand die Rohquittungen bereits persistiert vor (P-10/X-5, ergebnis.md
4.2: "Reproduktion (=Bau) damit NICHT noetig") und zog die ODER-Alternative — dadurch entfiel der
angenommene Bau-Bedarf nachtraeglich. Fuer das Audit heisst das: der in TEIL 3 reservierte
Bau-Slot fuer S6 wurde faktisch NICHT verbraucht; ob dieser freie Slot-Platz anderen WE-Straengen
zugutekam, ist aus den hier gelesenen Quellen nicht ersichtlich und waere ggf. gegen die
Slot-Belegungs-Protokolle der anderen S1-Staffel-Straenge zu pruefen (ausserhalb dieser Karte).

**2. K7a-3 / abi_adapter.hpp:476-491 — die C-9-Formulierung setzt einen Anker voraus, den
verify-93 als nie-existent zurueckweist.**
Der C-9-Auftragstext fordert den Abgleich "BEIDE Anker (abi_adapter.hpp vs.
mess_achsen_naht.hpp:477-517)" (W2-ABFOLGE-DESIGN.md:233-234) und setzt damit sprachlich voraus,
dass BEIDE Dateien je einen mit B3/KON37-01 verknuepften Pflicht-Wurf tragen (bzw. trugen) — diese
Lesart stammt aus Wellenplan §21.2/W1-V2: "Owner-Datum 'VOR F2' (KON34-04; KON37-01: der
Tier-Pflicht-Wurf abi_adapter.hpp:476-491 faellt)" (Zeile 2978-2979), was einen aktiven Wurf an
GENAU dieser Datei/Zeile suggeriert. Der verify-93-Bericht widerspricht dem direkt: "Karten-Fehlbuchung
bestaetigt — abi_adapter.hpp:476-491 trug/traegt KEINEN Pflicht-Wurf" (ergebnis.md 2.1, Zeile
50-51) und stuft NUR mess_achsen_naht.hpp als "zum Audit-Zeitpunkt korrekt, aber am gelandeten
Stand UEBERHOLT" ein. **Diese Karte benennt den Widerspruch, loest ihn aber nicht auf** — ob die
juengere verify-93-Messung (Objektbefund, 21.08.) oder die aeltere KON37-01-Ableitung im
Wellenplan-Text (Register-/Planungsschicht, vor 21.08.) inhaltlich Recht hat, muss das Audit am
Objekt selbst (`git log`/`git blame` auf abi_adapter.hpp:470-495 ueber die B3-relevante
Commit-Historie) verifizieren; die Doktrin V11/GOAL-v8 ("jeder aus Kommentar/Ledger uebernommene
Zahlenwert braucht eine eigene Ist-Messung") gibt der juengeren Objekt-Messung im Zweifel den
Vorrang, ersetzt aber keine unabhaengige Nachpruefung. Wichtig: verify-93 selbst behandelt "beide
Anker sind stale" als EIN Befund — die vorliegende Karte zerlegt ihn in zwei separat zu wuerdigende
Teile (Anker 1 war nie real vs. Anker 2 war real-aber-ueberholt), weil sie fuer die
Abnahme-Nachpruefung unterschiedliches Gewicht haben.

**3. ABNAHME-Formel "je Posten ... BEHOBEN/OFFEN" (binaer) vs. tatsaechlich verwendetes,
feineres Vokabular.** Die Haupt-Abnahmeformel (W2-ABFOLGE-DESIGN.md:237) nennt nur zwei Werte;
der Strang-Bericht vergibt tatsaechlich sieben verschiedene Status-Auspraegungen (BEHOBEN,
BEHOBEN/ABSORBIERT, BEHOBEN/DOKUMENTIERT, BEHOBEN/GEBUCHT, OFFEN, OFFEN — DEKLARIERT, OFFEN —
GETRAGEN, MESSUNG VOLLZOGEN). Diese Karte stuft das NICHT als echten Quellen-Widerspruch ein,
weil (a) die Gruppe-C-Unterklauseln selbst schon ODER-Alternativen zur reinen Dichotomie
vorsehen (siehe ABNAHME-FORMELN oben) und (b) der Status "DEKLARIERT" durch die
Freeze-Check-Deklarations-Tafel (Wellenplan §23.2) als eigene, anerkannte Kategorie bereits VOR
verify-93 existierte. Trotzdem: ein Audit, das strikt binaer gegenpruefen wollte ("ist es nun
BEHOBEN oder OFFEN, ja oder nein"), muesste "OFFEN — DEKLARIERT" und "OFFEN — GETRAGEN" beide
der OFFEN-Seite zuschlagen (die Bilanzzeile "10 BEHOBEN/VOLLZOGEN, 7 OFFEN" in ergebnis.md Abschnitt
9 tut das bereits so) — X-12 ("MESSUNG VOLLZOGEN") wird in dieser Bilanz auf die BEHOBEN-Seite
gezaehlt, obwohl der eigentliche Fach-Zustand (Laufzeit-Map leer) inhaltlich eher "OFFEN, aber
owner-gated und damit nicht dem Strang anzulasten" ist. Diese Einordnungsentscheidung des Strangs
(VOLLZOGEN wird zu BEHOBEN gezaehlt) ist plausibel begruendet, aber eine eigene Wertung des
Strangs, keine woertliche Vorgabe der Quelle — das Audit sollte sie nicht unbesehen als
"Quellen-Fakt" uebernehmen.

**4. STAFFEL1-SYNTHESE.md nennt eine Referenz "F-16", die aus keiner der in dieser Karte gelesenen
SOLL-Quellen stammt.** Zeile 240/188 der Synthese fuehrt "F-16/F-46/F-47" bzw. "F-16=F-46/F-47-Verbund"
als denselben N5/N6-Pruefposten — F-46/F-47 sind eigene Nummern der STAFFEL1-SYNTHESE selbst,
F-16 dagegen referenziert offenbar eine AELTERE, in dieser Karte nicht gelesene Fundliste
(vermutlich aus dem Ur-Audit #93 oder dem W1-Vollaudit-Backup, Task #110). Diese Karte kann NICHT
bestaetigen, was F-16 exakt aussagt oder ob es inhaltlich identisch zu N5/N6 ist — nur, dass die
STAFFEL1-SYNTHESE diese Gleichsetzung behauptet. Fuer das Audit: falls F-16 an anderer Stelle
abweichende Details traegt, waere das ein weiterer zu benennender Fund, keiner, der aus den hier
gelesenen SOLL-Quellen ableitbar ist.

---

**Selbstcheck:** Alle in den REGELN genannten SOLL-QUELLEN wurden gelesen: W2-ABFOLGE-DESIGN.md
(C-9-Block Zeile 220-268 + Slot-Tabelle Zeile 800-819 + K3-Register-Summenzeile 843 + Zeile 60/356/388
Querverweise), LEAD-ENTSCHEIDE-zum-w2-design.md (voll, 87 Zeilen), Wellenplan (§18-§23 Kopfzeilen
kartiert, §21.2/§21.5/§22.1/§22.2/§23.1/§23.2 im Volltext gelesen), Designplan-tdd (§0-§12 kartiert,
TDD-Vertrag §3 T-1..T-9 + T-11a-c/T-12a-e im Volltext gelesen), GOAL v8 (§II.1-§II.8 im Volltext,
D3-4/allow_failure-Abschnitt gelesen), Ledger (KON37-01, KON34-04 im Volltext; Grep auf #93/K7a-3/
X-12/RCU/Wstringop), STAFFEL1-SYNTHESE.md (Zeilen 1-100 + 140-259, inkl. F-45..F-60), verify-93-ergebnis.md
(voll, 279 Zeilen). NICHT gelesen (bewusst ausserhalb der vorgegebenen SOLL-QUELLEN-Liste):
karte-register.md (K3) im Volltext — nur ueber Zitate innerhalb der gelesenen Quellen erschlossen;
STAFFEL2-SYNTHESE.md nur per Grep (2 Treffer, beide X-12/OG-1/OG-6-Bezug, in P-11 eingearbeitet).
Kein Objekt-Zugriff auf ce/super/prt-art in dieser Karte (Auftrag: NUR LESEN der Planungsquellen).
