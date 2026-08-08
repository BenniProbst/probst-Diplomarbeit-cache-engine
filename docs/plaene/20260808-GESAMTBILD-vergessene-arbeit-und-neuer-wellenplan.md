# GESAMTBILD 08.08.2026 — was vergessen wurde, was der Owner meint, und der Plan, der daraus folgt

**Stand der Messung:** ce `origin/development` = `15522cdc` · super `f556619c` · thesis `798e946` · cluster `cd7c64d`. Alles unten Zitierte ist am Objekt nachgesehen, nicht aus Berichten übernommen; wo ich einen fremden Befund nur weitergebe, steht es dabei.

**Vorbemerkung zur Zählkreis-Falle:** Ich zitiere im Folgenden **ausschließlich aus der Fahrplan-Reihe A** (`super docs/sessions/20260803-FAHRPLAN-gesamtkette-wellen-phasen.md`, 7 Phasen + Nachträge L1–L22). Jede andere Nummerierung wird als solche benannt. Teil A.2 listet alle Kreise auf, weil genau hier der teuerste Lesefehler entsteht.

---

# TEIL A — WAS VERGESSEN WURDE

## A.1 Postenlage Phase 2 / 3 / 4 (Fahrplan-Reihe A)

Legende: **✅** belegt erledigt · **❓** behauptet, ohne tragfähigen Beleg · **🟠** offen · **⬜** nie begonnen (teils planmäßig).

### Phase 2 — Stempel-/ABI-Abschluss (Fahrplan Z. 13–18 + L4/L14)

| # | Posten | Stand | Beleg |
|---|---|---|---|
| 2.1 | W10 System-ZELLWERTE in die `system_stamp_line` | ✅ | `ce abi/system_cell_values.hpp` (ab3fe4f6); produktiv verdrahtet `profile_facade/profile_run_facade.cpp:712` u. `:1226` (Code, kein Kommentar); Tests `test_w10_c4_zellwert_naht.cpp`, `test_w10_system_cell_values.cpp` |
| 2.2 | E-24 ABI-Major 7 → 8 | ✅ | **selbst nachgesehen:** `abi/anatomy_module_abi_v1_decl.hpp:89` = `#define COMDARE_ANATOMY_ABI_MAJOR 8`; Commit `4f569051` (`%ad` = Tue Aug 4 11:16:54 2026), Merge `19f27223` |
| 2.3 | A8-Kopplung: S1/S3/S4/S5 **vor** dem Anker | ✅ | `de7688b9` · `65a61fcf` · `28261b5a` · `24e07219` — alle topologisch und zeitlich vor `18fbb950` |
| 2.4 | E-24-FENSTER-BAUPLAN (L4) | ✅ | `super docs/sessions/20260803-DOSSIER-e24-fenster-bauplan.md` (579 Z.) |
| 2.5 | M0-Vorstufe `organ_concept.hpp` (L4) | ✅ | `ce anatomy/organ_concept.hpp` + `test_e24_c0/c1_organ_concept*.cpp` |
| 2.6 | Graph-Gattung (Q5) | ⬜ planmäßig | FAHRPLAN:17 wörtlich „Graph-Gattung nach Abgabe (Q5)" |
| 2.7 | A2-SHA512-Skip-Gate — **der Bau** | ✅ | `426aeaef` + `deee6406`, Merge `18fbb950` (Aug 5 12:11:47), Pipeline 14659; `tests/unit/test_a2_sha512_skip_gate.cpp` registriert `tests/unit/CMakeLists.txt:5233` |
| 2.8 | A2-Eichung „**EINMALIG ZULETZT**" | 🟠 **formal gebrochen** | `kFrozenFingerprintV1` (`test_g3_sha512_index.cpp:89`) ist seit dem Anker **fünfmal** gedreht: `f8f811a9 → 17148e5a → 5b18feac → 88f59b9b → d53aebdb` (heutiger Wert selbst gelesen). **Wichtige Entlastung → A.3-#1** |
| 2.9 | TP1-FINAL-Inventur | ❓ **und überholt** | Nur `Ledger:4171` („S6, operativ, KEIN ce-Commit"), gefahren gegen `18fbb950`. Zusage der Wiederholung `Ledger:7178`/`:7195`. Nullbefund über 6 Muster (`TP1_ANKER_OK`, `TP1-Wiederholung`, `erneute TP1`, `TP1-FINAL`, `TP1+4+1`, `Neun-Gates`) in den Abschnitten ab 07.08.; Gegenprobe: `TP1` trifft 29× im selben File |
| 2.10 | L14 leeres Overlay-Glied → Heilung | ✅ am Objekt, 🟠 in der Buchführung | Gebaut `c7158b2b` (E-E, Aug 7 18:41:30); produktive Naht `profile_run_facade.cpp:369`. **Es fehlt der Ledger-Vollzugsvermerk, der die deklarierte Lücke schließt** |
| 2.11 | Doku-Drift am Skip-Gate | 🟠 | `ce builder/build_orchestrator/build_orchestrator.hpp:289–300` behauptet vier Dinge, die alle falsch sind („leeres Overlay-Glied", „Heilung Phase 6", „format=3", „ACHT Glieder"). **Selbst gemessen:** `anatomy_fingerprint.hpp:116` = `fingerprint_format=4`, `:416` = `kAnatomyFingerprintGliedCount = 9` |
| 2.12 | SF-1 (`anatomy/container_framework.hpp:37` → `builder/.../genus_binding_traits.hpp`) | 🟠 | G8-gesperrte ABI-Fläche. Owner 06.08. verbatim: *„SF-1: Vor Abgabe bitte ein eigenes Fenster."* (`Ledger:6918`) — **supersediert** die ältere 05.08.-Zeile „nach Abgabe" (`Ledger:7166`) |

**Verdikt Phase 2:** die drei Bau-Posten sind fertig. Die *Ordnungs*-Zusage ist es nicht. Phase 2 ist als Bauarbeit abgeschlossen, als **Gate offen**.

### Phase 3 — Parallel-Spuren (Fahrplan Z. 20–23 + L4–L15): 16 Posten

| # | Posten | Stand | Beleg |
|---|---|---|---|
| 3.1 | A8-S1 (T17-Messwert-Verlust) | ✅ | `de7688b9`; `abi_adapter.hpp:1102/:1106/:2023/:2027` auf `kV3AxisCount` |
| 3.2 | A8-S3 (E1/Micro-Neuschnitt, CSV-Klasse-C) | ✅ | `65a61fcf` (843fe06c/51d37cd3/3ef96490), Gate 377→380 |
| 3.3 | A8-S4 (Gattungs-Vertrag, Konstitutiv-Matrix 5×18) | ✅ | `28261b5a`, `ce docs/architecture/20260804-a8_s4_*.md` |
| 3.4 | A8-S5 (OS-Call-/std-Container-Scrub, 70 Header) | ✅ | `24e07219`, Gate 403 |
| 3.5 | **A8-S2 (Ebenen-Etikettierung E2/E3 + CSV-Ebenen-Summen)** | ⬜ **und besitzerlos** | `grep 'A8-S2'` über 10 840 Ledger-Zeilen = **0**. Zwei Quellen führen S2 als „A8-Kern, trigger-blockierend", eine sagt „nie vergeben (Sequenz S1→S3)" — **unaufgelöster Widerspruch** |
| 3.6 | A8-S6 (Abschluss/Doku, 17 stale Kommentare) | 🟠 still umgehängt | Aus Phase 3 in den §75-Aufräumpass verschoben (`docs/plaene/20260806-PLAN-f3-f5-r4-aufraeumpass.md:516`, AP-05). Die 17er-Stellenliste ist **selbst unbelegt** |
| 3.7 | A9-S1 xlsx-Vendor (libxlsxwriter 1.2.4 + zlib 1.3.2) | ✅ | `351205f5` (07.08.); `ce ext/io/libxlsxwriter/`, `ext/io/zlib/` mit Provenance |
| 3.8 | A9-S2 Grammatik | ❓ **halb** | `lager_pfad_grammatik.hpp` existiert — stammt aber aus der **A1-LB-Welle** (`5971cb47`, 03.08.) und trägt den A9-Dateinamen-Teil (`blatt_dateiname() :391` + golden-Strings `test_lb0_*:157–190`). **`ergebnis_dateiname.hpp` existiert nicht** (selbst geprüft: `git ls-tree \| grep -i ergebnis_dateiname` = 0), ebenso wenig die 31-Zeichen-Sheet-Wache und `ErgebnisSchreibFehler` |
| 3.9 | **A9-S3/S4/S5 (Writer-Kern, CLI, Erstbeleg)** | ⬜ | **Selbst gemessen:** `git ls-tree -r origin/development \| grep -icE "ergebnis_dateiname\|lager_ablage\|mess_report"` = **0**. Der xlsx-Weg ist heute **reiner Vendor, ohne einen einzigen Schreiber** |
| 3.10 | A7/E-04: E-18 LaTeX-Vorwärtskanal | ✅ inert | `super 347684cb`+`8131a9a2`; `.gitlab-ci.yml:1093` Job `anhang:forward`, `:1115` Opt-in-Rule |
| 3.11 | A7/E-04: Z-05/Z-06/Z-08 | 🟠 | Z-06 **am Objekt widerlegt**: `slice_marker.hpp:69` trägt weiter `marker_fenster(begin,count)`, Include-Block `:22–25` kennt kein `bestandslog/` |
| 3.12 | A7/E-04-P2/P4 Mess-Marker-v2-Zeile | ⬜ | Alle sechs `marker_kopf()`-Aufrufe in `cache_engine_builder_iterator.hpp` tragen `"bau"` oder `"pruef"`; `grep '"mess"'` dort = 0 |
| 3.13 | A14/OS-U4 (Provenienz-Anschluss) + Z-04 | ⬜ | Alle sieben `OS-U4`-Treffer in ce sind **Kommentare**. OS-U3 hat bis heute **null produktive Konsumenten** |
| 3.14 | A15 FK-3/FK-4 (Fehlerklassen Ebene 2) | ✅ | `fcdc77cb`+`f2709599`; `measurement/axis_error_traits.hpp:106–112` |
| 3.15 | A10 HW-Erkennung P4/P5/P6 + prod2-SPD-Beweis | ⬜ | Der Code sagt es selbst: `hardware_probe_factory.hpp:133` („spaeter, P5") und `:403` („In P5 setzt der PLANER die Zelle") |
| 3.16 | A11 ccache-Allowlist-Drop · A12/E-14 NAS-Creds · E-19 Stufe 1 · Thesis C1-Rest | A11 🟠 (Code **widerspricht** dem Plan: `super .gitleaks.toml:25/:29`) · A12 🟠 · **E-19 ✅** (Cluster-Commit `6358e43`) · C1-Rest 🟠 |

**Verdikt Phase 3: NICHT fertig.** 6 von 16 belegt erledigt, 2 teilweise, 8 offen/nie begonnen. Der Ledger sagt es selbst (`:8360-8364`, B9): *„Das Ausfalten ist nachzuholen, bevor Phase 3/4 als erledigt gebucht werden kann."*
**Und:** von den zwölf Landungen des 07.08. berührten **nur zwei** die Fahrplan-Phase-3-Zeile (A9-S1, A15 FK-3/4). Der Rest gehört in andere Phasen oder auf keine Zeile.

### Phase 4 — Beweise + Permutationen (Fahrplan Z. 26–27)

| # | Posten | Stand | Beleg |
|---|---|---|---|
| 4.1 | A3 / Beweise 1–5 | 🟠 | Kein einziger der 4+1-Beweise auf geeichtem Stand erbracht (`Ledger:7202`, B10). `[PRUNE-TESTAT]` = **0 Treffer im gesamten Ledger**, obwohl der Emitter existiert (`super Code/02_messung_driver/main.cpp:967` — **nicht** in ce, wie ein Bericht behauptete) |
| 4.2 | **E-07-Gate Stufe 2** (die zehn `E07_*`-Gate-Zeilen) | ⬜ | Stufe 1 = Definition ist gelandet (`20260803-DOSSIER-e07-gate-definition-*.md`). Die Gate-Zeilen selbst existieren nicht. **Warnung im Ledger `:5372-5378`: der Vermerk „E-07-Lücke GESCHLOSSEN" meint die LANDUNG DES DOSSIERS, nicht die Erfüllung** |
| 4.3 | §61-Dual-Weg-Beleg (bare-metal Durchfahrt) | ⬜ | 0 Durchfahr-Belege seit 27.07. (`Ledger:3269`); drei Suchmuster liefern nur Plan-Stellen |
| 4.4 | **A4 / 12-Perm** | ⬜ | **Selbst gemessen:** `all_axes_golden.profile.xml` trägt `opt_level {O2,O3}` × `simd {no_extension,avx2}` = **4**; sieben Anker in `test_experiment_plan_director.cpp` pinnen `perm_count = 4` (`:180`, `:215`, `:435`, `:658`). Der Begründungs-Kommentar im Profil trägt noch wörtlich „avx512 nicht universell" — die von OE-D am 01.08. **umgekehrte** Doktrin |
| 4.5 | A5 ETA/Kalibrier-Prinzip (F5/F6) | ✅ mit vier Resten | `73f9a56f` (07.08.). Reste laut eigener Paketmeldung (`Ledger:9793-9800`): periodische ETA-Fortschreibung **vom Merge blockiert**, `avg_size`-Konsumenten unangefasst, Baupunkt 6 nicht verdrahtet, **„kein Lauf auf echter Hardware"** |

---

## A.2 Die Wellensysteme — welche Nummernkreise nebeneinander laufen

Ich habe **acht** aktive Zählkreise gefunden. Das ist die teuerste Struktur im ganzen Korpus: der Lead ist hier schon zweimal falsch abgebogen (Korrektur `Ledger:8324-8388`).

| Kreis | Träger | Umfang | Stand |
|---|---|---|---|
| **A — FAHRPLAN-Phasen** | `20260803-FAHRPLAN-*.md` | 7 Phasen + L1–L22 | **maßgeblich**; Phase 1 ✅, Phase 2 Gate offen, Phase 3 6/16, Phase 4 1/5, Phase 5–7 offen |
| **B — §-Reihe** | Ledger `§0`–`§77` | 78 Paragraphen | Kanon-Ebene, wird nie „abgearbeitet"; einzelne superseded (§62-C durch O-A) |
| **C — E1–E4 Experiment-Schichten** | `docs/architektur/16_E1_E4_KONSOLIDIERUNG_DOSSIER.md` + `17_E4_XML_VOLLVISION_ROADMAP.md` | 4 Schichten | Owner-Kanon-Klärung 06.08.: **Doc 16/17 sind der Kanon, Plans-Dateien sind Entwürfe**. Kollidiert namentlich mit E1/E2/E3 der Benchmark-Ebenen (A.3-#8) |
| **D — Katalog A1–A25** | `20260802-KATALOG-offene-strecke-gesamtplan.md` | 25 Posten | teilweise in Reihe A eingespeist; **A25-Kleinposten „ohne Heimat"** ist der Sammelbehälter, aus dem Posten still verschwinden |
| **E — Tagesreihen (A1–A9, T-1…T-19, E-A…E-F, O-A…O-F, R-1…R-3, G-1…G-8, V-1…V-18)** | Ledger-Nachträge 05.–08.08. | je Runde neu | **das gefährlichste System**: Buchstaben werden pro Tag neu vergeben. Neun dokumentierte Kollisionen (`20260807-RECONCILE-43-positionen-disposition.md`) |
| **F — Vor-Trigger-Checkliste B1–B13** | `Ledger:7199-7202` | 13 Pflichten | die einzige Liste, die **trigger-blockierend** ist. B3, B9, B10, B12 offen |
| **G — Wellen W1–W12 + Scheiben S0–S6 je Welle** | diverse | ~40 | **S-Nummern kollidieren über Wellen hinweg**: `5971cb47` heißt „feat(lager): S2/LB-0" und ist die zweite Scheibe der **A1-Lager-Rest**-Welle, nicht A9-S2 (genau daher der Fehlbefund in A.1-#3.8) |
| **H — §75-Aufräumpass-Kandidaten (1)–(63)** | Ledger `:3599 ff.`, fortgeschrieben | 63 | Phase 7; wächst monoton, wird nie geprüft |

**Systeme, die nur einmal genannt und nie wieder angefasst wurden:**
1. **Phase 0.5 Hygiene-Block (L20)** — sechs Posten (Memory-Nachträge, Kopf-Klauseln, Worktree-Abbau, Scratchpad-Sweep, Rest-Stack, 6 Commit-Referenz-Diskrepanzen). Seit 04.08. kein Vollzugsvermerk.
2. **Phase 6.5 Nach-Abgabe-Behälter (L21)** — 15 Posten (E-01/E-03/E-06/E-16/E-17/E-25/E-26, G5, §65-#32, §73.1, §73.5-Q6, §69.9-C-3a, §70.4/§73.3-Q4, f2/f3-Remote-GOs, O-6/OD-1, R1). Einmal angelegt, nie wieder erwähnt — und der Owner hat dazu H.7 gesagt: *„Rest nach Abgabe ebenfalls PFLICHT"*.
3. **L19 Aufräum-Zugänge (25)–(29)** — inkl. FS4/TOCTOU, das eine ausdrückliche Zusage aus `Ledger:3711` ist.
4. **L22 STRUKT-R-Komplett-Quittung** — ein einmaliger Verifikations-Vermerk, den nie jemand geschrieben hat.

---

## A.3 Die vergessenen Posten — nummeriert, gewichtet

**#1 — TP1-FINAL-Inventur auf finalem Stand.** Offen seit 05.08. Untergegangen, weil sie **kein Repo-Artefakt** hat (per Konstruktion: „operativ, kein ce-Commit") — es gibt nichts, was rot werden könnte. Die Zusage steht wörtlich (`Ledger:7178`), die Blockade (L1) ist am 06.08. gefallen, seither 175 Commits und keine Zeile dazu.
**Gewicht: SCHWER, trigger-blockierend.** Der Scope ist seit 06.08. sogar gewachsen (`Ledger:7089`: der E2E-`.rsp`-Beweis gehört in die Wiederholung — für ihn gibt es nicht einmal einen Vorgängerlauf).

**#2 — Die vier plus einen Beweise (B10) und das E-07-Gate Stufe 2.** Offen seit 05.08. Untergegangen, weil „E-07-Lücke GESCHLOSSEN" im Ledger steht und wie ein Vollzug aussieht — es ist die Landung des *Dossiers*. **Gewicht: SCHWER, trigger-blockierend.** Ohne Beweis 1 (Batch-Wiederaufnahme, `built_new==0` im Zweitlauf — 0 Treffer, Gegenprobe `built_new` = 17) ist ein Abbruch nach 800 000 Binaries nicht wiederaufsetzbar.

**#3 — A9-S3/S4/S5: der xlsx-Weg hat keinen Schreiber.** Offen seit 03.08. Untergegangen hinter der sichtbaren Vendor-Landung vom 07.08. (A9-S1) und hinter dem Vermutungssatz `Ledger:9649` *„damit ist A9-S2 **offenbar** erledigt"*. **Gewicht: SCHWER.** Owner-KERN 07.08.: *„Der Standard für die Messung ist xlsx."* Ohne Writer fährt Phase 6 auf CSV — und nach O-B ist die xlsx-Mappe nicht Ausgabe, sondern **Träger des Mess-Profils selbst**.

**#4 — A8-S2 hat keinen Besitzer.** Nie begonnen, Widerspruch seit 06.08. offen. Untergegangen durch einen Aktenwiderspruch, den nie jemand geschliffen hat. **Gewicht: MITTEL-SCHWER** — wenn die Ebenen-Etikettierung E2/E3 fehlt, tragen die CSV-Spalten nach der Messung keine Ebenen-Semantik, und die Nachrüstung ist dann ein Datenbruch.

**#5 — A14/OS-U4.** Nie begonnen seit 03.08. Untergegangen, weil die Vorstufe OS-U3 grün ist und „fertig" aussieht — sie hat aber **null produktive Konsumenten**, planmäßig bis OS-U4. **Gewicht: MITTEL** (Vor-Trigger-Posten B3).

**#6 — A10 P4/P5/P6 + prod2-SPD-Live-Beweis.** Nie begonnen. Untergegangen, weil die *Infra*-Hälfte am 02.08. erledigt wurde und der Posten damit als abgehakt gelesen wurde. **Gewicht: MITTEL** — ohne P5 setzt der Planer die Passungs-Zelle nicht, die Mess-Zeilen tragen Defaults.

**#7 — Die Marker-v2-Zeile der Mess-Phase (E-04-P2/P4) und Z-06.** Nie gebaut bzw. am Objekt widerlegt. Untergegangen im „Rest"-Bündel A7/E-04. **Gewicht: LEICHT-MITTEL.**

**#8 — Die Namenskollision „E1–E4" ⟷ „E1/E2/E3".** Kein Bau-Posten, sondern eine **Lesefalle**: „E4" bedeutet einmal die vierte Experiment-Schicht (Doc 17) und einmal nichts, weil es bei den Benchmark-Ebenen nur drei gibt. Genau daraus entsteht Teil B3. **Gewicht: MITTEL** — kostet Fehlarbeit, keine Substanz.

**#9 — Doku-Drift am Skip-Gate.** Offen seit 07.08. Untergegangen, weil ein Nachtrag vom 06.08. (T2-B/T2-C) daneben steht und die Stelle „gepflegt" aussehen lässt — er heilt aber nur die Glieder [5]/[6]. **Gewicht: LEICHT im Bau, SCHWER in der Folgewirkung** — es ist die erste Stelle, auf die jede künftige Skip-Gate-Suche fällt.

**#10 — SF-1-Fenster.** Ungeplant, unterminiert. Untergegangen, weil zwei Owner-Aussagen gegenläufig sind und die ältere („nach Abgabe") entlastender klingt. **Gewicht: MITTEL, aber terminkritisch** — G8-gesperrte ABI-Fläche darf nur in einem eigenen Fenster angefasst werden.

**#11 — Die Phase-0.5- und Phase-6.5-Behälter (L20/L21).** Einmal angelegt, nie wieder berührt. **Gewicht: LEICHT bis Abgabe, SCHWER danach** — L21 trägt Owner-Wort „PFLICHT".

---

# TEIL B — DIE VIER GEDÄCHTNISLÜCKEN

Der Owner hat recht behalten: **in drei von vier Fällen ist die Planung da, vollständig, und wir haben sie nicht gefunden.** Im vierten Fall ist die gesuchte Zahl neu.

## B1 — Break-Even und die compare-Stufe

**Der Auslöser (Owner 08.08., verbatim):**
> *„Compare Stufe ist noch nicht gebaut und braucht die ultracode break Even Planung über die letzten 6 Wochen, es ist irgendwo definiert."*

**GEFUNDEN — die Definition existiert in vier Schichten.**

**(1) Der Kern, 19.07.2026, §32-F8** (`Ledger:2296-2301`), verbatim:
> *„Die Messungen müssen eine **Spline-Funktion auf jeder Achse** … bereitstellen, um diese Funktionen als **Heuristik-Abschätzung** zu nutzen: bei Eingabe einer Anfrage auf das Interface (klassifizierte Operationen × Workload) **rückwärts die optimale Binary** … zu laden."*
> *Ergänzung Break-Even-Mathematik:* *„Switch-Thresholds = **Schnittpunkte zwischen den f(x)-Spline-Funktionen** der Performance-Modellierungen zweier Algorithmen derselben Achse (Beispiel: Allokatoren für große vs kleine Dateien — Kurven übereinandergelegt ergeben den Break-Even-Punkt)."*

**(2) Die Freigabe, 20.07.2026, §49** (`Ledger:2692`): Option 1 **und** 3 freigegeben (variant nur im Hybrid, limitiert durch die §49-KORREKTUR auf Unter-Prüfdock-Verträge via Abstract Factory; **Array multipler Tier-Binaries an multiplen Docks + Verdrängungs-Strategie**).

**(3) Die drei Benchmark-Ebenen, 06.08.2026** (`Ledger:4580-4606`), Owner verbatim:
> *„das ist als **'break even'** geplant. Es gibt **Schnittpunkte zwischen Parameter-Funktionskurven, die anzeigen, wann ein Algorithmus in einem Parameter über eine Achse als Organ effektiver wird.** Wenn wir das mit **gemischten Micro-Benchmarks über alle Achsen** … und **Macro-Benchmarks** (… **Gesamt-Messprofile timed einer Funktion über die Schritte und checkpoints ihrer Ausführung** …) und **Macro-Benchmarking large scope über die Gesamtheit der Macro-Benchmark charts ALLER für ein Lastprofil aufgerufenen Gattung+Genus Funktionen auf dem Tier-Binary interface**."*

Dazu die Bindung an die Forschungshypothese, ebenfalls verbatim (Termin 1, 30.03.2026): *„**Es gibt keine universell beste lokale Seitendarstellung**; die beste Wahl hängt von lokaler Dichte, Präfixstruktur, Zugriffsmix … ab."* — Break-Even ist die **operative Form von H2**.

**(4) Der Ort, 07.08.2026, B-4-Korrektur** (`Ledger:7336-7343`), Owner verbatim:
> *„Break even lebt nur in der CEB nach Messungs-Schluss und wird dort im RAM über alle Tier-Binary-Messergebnisse ausgewertet, um dann von der CEB auch bei Anforderung durch den Planer in Latex Dokumente, PDF oder xlsx Tabellen nach Zielorte zu gießen (XML bestimmt Verhalten → Feature Pflicht zusammen mit Modi der Cache Engine Debug/Release/etc). Das Verwerfen IST FALSCH, da wird NICHTS gekürzt. Voll-Build."*

**Und es gibt ein 825-Zeilen-Plandokument dazu:** `super docs/plaene/20260806-PLAN-break-even-und-drei-benchmark-ebenen.md` — mit Ist-Stand, Risiken und Bau-Posten. Der Auftrag dazu lautete wörtlich: *„das ist geplant und muss dokumentiert werden."*

**Die compare-Stufe, 07.08.2026, O-A** (`Ledger:7625-7638`), Owner verbatim:
> *„Es bleiben 2 Dinge, aber formal kommt compare als Stufe mit eigenen Optionen (lesend Messwertlager) vor dem release, der auch die Messwerte nachlesen muss, aber dann eine optimale binary produziert."*

Und die Staffelung, gleicher Tag: *„release beinhaltet den vorgeschalteten Modus measure und erweitert ihn, und compare beinhaltet den Modus measure ebenfalls als Basis. Wir können nur das bauen oder vergleichen, was wir schon gemessen haben."* ⇒ **`measure ⊂ compare ⊂ release`**, und `§62-C` (21.07., „NACH dem Release") ist damit **superseded**.

**Was am Objekt fehlt (selbst nachgesehen, `ce origin/development`):**
- Der Enum-Wert **existiert bereits**: `measurement/run_methodology_registry.hpp:58` = `Compare, ///< COMPARE-Lauf -- Stufe VOR release (O-A): liest das Messwertlager, eigene Optionen; Etikett bis D2`. Der Kopfkommentar ist bereits auf O-A nachgezogen. **Zu bauen ist das Verhalten D2, nicht der Wert.**
- Die Break-Even-**Mathematik existiert**: `heuristik/break_even.hpp` (148 Z., Hermite + Bisektion), `heuristik/axis_spline.hpp` (Fritsch-Carlson), `heuristik/measurement_curve_loader.hpp`, `builder/curve_fit/curve_fit.hpp:392`.
- **Sie hat null produktive Konsumenten.** `find_break_even_points` → nur `test_heuristik_spline_break_even.cpp`; `HybridBinarySelector`/`break_even_table` → nur `test_hybrid_spline_selector_scaffold.cpp`. Von 203 Tests fahren **zwei** Break-Even; von 10 Apps **keine**.
- **Der super-Auswertungspfad kennt den Begriff nicht:** `break.{0,2}even|schnittpunkt|intersect|crossover` über `Code/05_diagram_generator`, `08_appendix_generator`, `04_csv_to_latex`, `02_messung_driver` = **0**, Gegenprobe `kurve|curve` in `05_diagram_generator` = 36. **Der Generator legt die Kurven übereinander — niemand schneidet sie.**
- **Zwei divergierende Implementierungen:** `heuristik::BreakEvenPoint` (monotone Hermite, echte Knoten, §75-geschützt) gegen `best_binary::BreakEvenPoint` (**stückweise linear, festes 256-Raster**, self-declared SKELETON, ungeschützt). Ein 256-Raster **überspringt** Schnittpunkte, die das knotenbasierte Gitter garantiert findet.

**Verdikt B1: keine Planungslücke, eine Verdrahtungslücke.** Die Definition ist seit 19.07. da und dreimal präzisiert. Gebaut ist die Mathematik. Ungebaut ist die **Kette**: Mess-CSV → Kurven → Schnitt → Schaltlogik → xlsx/LaTeX. Plus zwei Risiken, die vor dem Bau zu entscheiden sind (Doppel-Implementierung; fehlende Hysterese — `hysterese|flapping|schwing` = 1 unverwandter Treffer, Gegenprobe `verdraeng` trifft mehrfach).

## B2 — AVX-System-Achsen-Konfiguration + Lager-Batches + ETA-Sync prod1/prod2

**Der Auftrag (Owner 08.08.):** prod2 ohne AVX-512 ist *„korrekt und gewollt"*; heraussuchen, wo (a) die System-Achsen-Konfiguration für AVX festgelegt ist, (b) wie prod1/prod2 sich Batches aus dem Lager holen, (c) wie sie den CI-Fortschritt mit der ETA synchronisieren.

**GEFUNDEN — alle drei Teile stehen in EINEM Paragraphen: §62, 21./22.07.2026** (`Ledger:3306-3343`). Das sind exakt die „3 Wochen".

**(a) AVX / System-Achsen — §62-A, Planer-Universalität, verbatim:**
> *„Der PLANER ist ANSPRUCHSLOS: er muss auf JEDER Maschine bauen können und misst alles Verfügbare, was die XML verlangt. … Verlangt die XML Achsen, die physisch als System-Achsen-Algorithmen nicht existieren (**z.B. AVX512-Flags**), schreibt der Planer WARNUNGEN ins Log bzw. auf die spätere CLI-Shell — **kein Vorfilter, keine stille Auslassung**."*
Ergänzt durch das **Symmetrie-Prinzip** (21.07.): *„prod1 baut ALLES, was es kann, und prod2 baut ALLES, was es kann … **Die XML ist für BEIDE Maschinen GLEICH und unterscheidet sich nicht**."*
⇒ Die Owner-Aussage vom 08.08. ist keine neue Ausnahme, sondern der **Regelfall dieses Paragraphen**: 12 Perms im Profil sind korrekt, prod2 fährt davon 8 und **loggt die vier fehlenden als Warnung**.

**(b) Lager-Batches — §62-B, verbatim (22.07.):**
> *„die Batches enthalten STETS **4096 Binaries**, die eine CEB aufnimmt und **MIT ZEITSTEMPEL reserviert**."*
> *„**Gleichverteilungs-Pflicht:** die CEBs benötigen über dieses Dokument ABSPRACHEN, wie sie sich die Batches aufteilen — Binaries, die BEIDE Maschinen verarbeiten können, werden **GLEICHVERTEILT** auf beiden Maschinen kompiliert. Sonst blockt die eine Maschine den Fortschritt komplett."*
> *„Batch-Typen zwischen CEB-Compile und Tier-Binaries werden auf DERSELBEN Maschine NIE GEMISCHT — sie laufen SEQUENTIELL."*
> *Thread-Budget:* **prod1 = 32 Threads / 24 Kerne; prod2 = 24 Threads / 16 Kerne**; *„ALLE Threads dürfen (und sollten) NUR JE EINZELNEN Batch-Compile VOLL ausgeschöpft werden."*
Dazu **§62-B-Präzisierung-2**: **zwei separate Bestände als Factory Pattern** — (a) batch-compile-prüf [Binaries], (b) Messung [Messergebnisse] — *„BEIDE führen ein SEPARATES Bestandslog"*. **Das ist zugleich die Wurzel von B4.**

**(c) ETA-Synchronisation — §62-B, verbatim:**
> *„die CEB berechnet das ETA NICHT über die ersten 10 Compiles, sondern über die **MAXIMALE DAUER eines Mini-Batches, dessen Anzahl der MAXIMALEN CPU-THREAD-ZAHL entspricht**. **ETA-Formel:** Summe aller Zeiten … geteilt durch die Anzahl der Gesamtthreads [ETA = Σ tᵢ / N_threads]. **UNTERGRENZE:** … immer MINDESTENS die maximale Einzel-Zeit eines voll-parallelen Batch-Satzes [ETA ≥ max(tᵢ)]. Für die Kalibrierung werden weiterhin ZUERST **30 MINUTEN pro forma** reserviert."*
> *„**Takeover-Regel:** wird das ETA um **50 % OHNE UPDATE** überschritten, dürfen andere Maschinen davon ausgehen, dass die Pipeline der Maschine GESTORBEN ist, und nehmen die Arbeit auf."*
> *„die ETA-Berechnung wird für **JEDEN compile-Batch-Block WIEDERHOLT**."* · *„Multi-Write-Freigabe … das Schreiben beschränkt sich auf die Eintragung der Reservierung (NUR MILLISEKUNDEN). Der HAUPT-BLOCKER ist die ETA-BERECHNUNG."*

**Verdikt B2: vollständig definiert, seit 21./22.07., in einem einzigen Paragraphen.** Der Code trägt die Mechanik (`BatchReservierung` 4096, `takeover_expired_reservations`, `eta_estimator`, `kTakeoverFactor 1.5`, 30-min-pro-forma) — was fehlt, ist genau das, was A5 selbst gemeldet hat: **der ETA-Zweig hat keinen Produzenten**, die periodische Fortschreibung wird vom Merge verworfen, und die Kampagnen-Projektion hat null Aufrufer, weil `BatchReservierung` kein Perm-Feld trägt. **Und die zweite Lane fehlt physisch:** `ping -c1 -W2 prod2` → *„Name or service not known"* (heute selbst gemessen).

## B3 — Die fünf querschneidenden Mess-Ebenen

**Der Auslöser (Owner 08.08.):** *„Querschneidend gibt es je Micro/Macro/Wallclock-Benchmarking **FÜNF** zu messende Ebenen, die Achsen-Algorithmen, Gattung/Genus-Interfaces und die Gesamtzeit vergleichen."*

**TEILBEFUND — drei Ebenen sind kanonisch definiert, ein vierter Layer auch; die Zahl FÜNF finde ich nirgends.**

**Was belegt ist — die drei Erhebungs-EBENEN** (`Ledger:7781-7782`, 07.08., aus dem Owner-Auftrag O-B):

| Ebene | Gegenstand | Messort | Instrument |
|---|---|---|---|
| **E1 Micro** | EINE Achse über ihr **Achsen**-Interface (nicht Gattungs-Interface) | **in die Tier-Binary einkompiliert** | gemischt: Wallclock **und** PMC |
| **E2 Macro (timed)** | EINE Gattung+Genus-Funktion | CEB-seitig **am Prüfdock** gegen die Tier-Binary | Wallclock + Schritt-Checkpoints |
| **E3 Macro large scope** | EIN Lastprofil = Aggregat ALLER E2-Charts | CEB | aggregiert E2 |

E1 ist als 18-Zeilen-Tabelle **T0…T17** ausgeschrieben (`ce docs/architecture/20260803-a8_f2_benchmarking_schnitt_soll_design.md:187-211`; T6 allocator = allocate/deallocate **reale Ops**, ausdrücklich kein Stats-READ als Zeit-Surrogat).

**Der vierte Layer, Owner verbatim 06.08.** (`Ledger:6806`):
> *„… dabei fehlt mir besonders welche Genus es unter jeder Gattungen gibt, welchen Interface Kern sie nach außen im gemeinsamen Gattungs-Kern teilen, und wie jeweils ihre Mikro-, Makro- und Wallclocktime-Messung eingebunden wird. **Das ist ein vierter Layer der Observer Stufe im Vertrag zwischen CEB und Tier-Binary!**"* — und: *„der Architektur-Kern ist **VERGESSEN und GEPLANT**, aber er ist nicht neu."*

**Die Korrektur davor, Owner verbatim 06.08.** (`Ledger:6780`):
> *„Micro- und Macro-Benchmarking sind FALSCH und entsprechen nicht dem neuesten Stand der Planung im ledger. **Wallclock time wird je Tier-Binary Funktion und über eine Kombination einer Last JEWEILS gemessen.**"*
Der Explore fand die Quelle: `messarchitektur_v5_design.md` (31.05.), **Zwei-Phasen-Op-Schleife** — `save_all → Erstausführung → rollback_all → op-measure`, wallclock-umklammert, Observer gleichzeitig. Genau der Owner-Wortlaut.

**Die Verschärfung, Owner verbatim 07.08. (O-B):**
> *„Na jeder Funktionsaufruf in der Kette aller Aufrufe der CEB über die Lastprofile am Prüfdock gegen die Tier-Binary wird als Macro-Benchmark aufgenommen. … Das Profil wird **je Mess-Layer** aufgezeichnet und in einem **zeitlich orientierten chart** als Profil abgespeichert, der **formal als xlsx Messwerte gilt**. Die Strengere Variante ist es."*

**NULLBEFUND für „fünf" — mit genannten Mustern.** Gesucht über den Ledger (10 840 Z.) und das Break-Even-Plandokument (825 Z.), `/usr/bin/grep -i`:
`"fuenf Ebenen"` = 0 · `"fünf Ebenen"` = 0 · `"FUENF Ebenen"` = 0 · `"5 Mess-Ebenen"` = 0 · `"fuenf Mess"` = 0 · `"vier Ebenen"` = 0.
**Gegenprobe (muss treffen):** `"drei Ebenen"` = 4 Treffer im Ledger, 7 im Plandokument. Die Suche greift.
`E4`/`E5` treffen zwar (18/4) — aber ausschließlich als **E1–E4-Experiment-Schichten** (Doc 16/17), ein anderer Zählkreis (A.2-C).

**Verdikt B3: hier liegt die Lücke bei uns nur zur Hälfte.** Drei Ebenen sind kanonisch, ein vierter Observer-Layer ist Owner-KERN. Eine **fünfte** Ebene ist im gesamten Korpus nicht auffindbar. Zwei Lesarten sind möglich, und ich kann sie nicht auflösen:
- **(i)** 3 Erhebungs-Ebenen + Observer-Layer 4 + **Release-Wallclock als Ebene 5** (die §61-Release-Nachmessung ohne Mess-Einrichtungen — sie ist eine eigene, querschneidende Zeitmessung und steht heute als eigener Posten in Phase 6);
- **(ii)** der Owner zählt die 5 **Genera** (`AnatomyGenus`, `anatomy_base.hpp:98-107`: SearchAlgorithm + Set/Sequence/Adapter/View) als die fünf Ebenen, über die verglichen wird — das passt zu „Achsen-Algorithmen, Gattung/Genus-Interfaces und die Gesamtzeit".
**→ Entscheid D-3 in Teil D.** Bis dahin ist die dokumentierte Zahl DREI, und jede Bau-Aussage mit fünf Ebenen wäre erfunden.

**Zusatzbefund, der hier hängt und schwer wiegt:** die Brücke Profil → xlsx ist **echt offen**. Die A9-Struktur ist eine Zeile-pro-Messergebnis-Tabelle je Unter-Achsen-Permutation, **kein Zeitreihen-Träger**; „Es gibt keine Datenstruktur namens Chart/Diagramm im Mess-Kern"; eine Zeitnahme **innerhalb** eines Funktionsaufrufs existiert heute nicht (0 Treffer über sieben Namensmuster, Gegenprobe `seg_ns` = 326). Die vorhandenen `fill_checkpoints{10,100,1000}` sind **Füllstands**-Stützpunkte, keine Ausführungs-Checkpoints. Der Satz *„formal als xlsx Messwerte"* ist damit eine **neue Festlegung**, die Spalten, Sheets und Zeitachse noch braucht.

## B4 — Der LaTeX-Anhang aus Anwendersicht + die Zwei-Baum-Struktur

**Der Auslöser (Owner 08.08.), sinngemäß aus der Präzisierung:** ein Anwender startet mit der XML ein Experiment und will in **einem** LaTeX-Anhang alle wissenschaftlichen Ergebnisse über **alle Zwischenstufen** automatisiert vorfinden, mitsamt der zu committenden Messartefakte — oder er belässt die Messwerte im Buildsystem. Mehrere Experimente in der XML → mehrere Ausgabe-Anhänge. **Nicht** die Rohwerte, sondern die **Auswertung**: Break-even-Punkte; wann welcher Achsenalgorithmus schneller/günstiger ist; welche Zeiten die Benchmarks in dieser Permutations-Version zeigten. **Kern:** es gibt **eine beste Version** unter den 524 000 je Form von Eingangslast — diese Handvoll landet im Anhang, oder die **besten 5**, sortiert, gefiltert, gegeneinander verglichen.
Und: *„Übrigens speichern wir jetzt Messwerte und Binaries in 2 verschiedenen Bäumen und Wurzeln im neuen Buildsystem Ordner."*

**GEFUNDEN — beides ist definiert, das Zwei-Baum-Modell sogar seit 26.07. und teilweise gebaut.**

**Die zwei Bäume — Owner 26.07.2026, Q-A…Q-F** (`super docs/sessions/backups/20260802-kontext-neugruendung-abend-workflows/00-SYNTHESE-lage-dossier.md:55`), verbatim aus der Synthese:
> *„**Lager-Bäume (Owner 26.07., Q-A..Q-F): ZWEI Realm-Wurzeln** — Messdaten: `[Mess-Kombinatorik]/[System-Rekombination]/[Organ-Gruppe]`; Binaries: `System → Organ → Mess (tiefster Typ)`. **5 Organ-Gruppen-Ordner** (englisch): `01_read_path`, `02_layout`, `03_placement`, `04_execution`, `05_write_path_io`. **xlsx = Default** (eigener Writer …; CSV = Fallback derselben Factory); Unter-Achsen-Variablen in den Dateinamen, Haupt-Achsen als Metadaten/Ordner; nie sich ändernde Spalten weglassen. `complete-heuristik.log` je Knoten; SHA512-Overlay; Truncate-Zustandsmaschine."*
Die Begründung der Zweiteilung: *„Binaries werden über System-Identität gesucht, Messdaten über Mess-Tooling."* Und die Rechtsgrundlage steht schon in **§62-B-Präzisierung-2 (22.07.)**: zwei getrennte Bestände als Factory Pattern, **je eigenes Bestandslog**.

**Und es ist gebaut** (selbst geprüft, `ce origin/development`):
`libs/cache_engine/builder/bestandslog/lager_pfad_grammatik.hpp` · `lager_baum_writer.hpp` · `lager_ziel_strategie.hpp` · `lager_presence.hpp`; Commit `5971cb47` (03.08.) heißt wörtlich *„Pfad-Grammatik-Single-Source + **Baum-Writer beider Realm-Wurzeln**"*; Manager-Entscheid L3 im Fahrplan: *„der LB-Schnitt baut ausschließlich die zwei Realm-Wurzeln der plain-Tier-Welt"* (kein Hybrid-Segment).

⇒ **Die Frage aus Task #50 („ist das dieselbe Sache?") ist mit JA zu beantworten.** Neu am 08.08. ist **nicht die Struktur, sondern die Wurzel**: `/mnt/comdare-buildsystem` (`10.0.20.241:/nfs/Comdare-Buildsystem`). **Heute selbst gemessen: gemountet, 20 T gesamt, 15 T frei, 28 % belegt.** Zu tun ist damit nur noch, die beiden Grammatik-Wurzeln auf diesen Mount zu zeigen — kein Neubau.

**Der LaTeX-Anhang — die Auswertungssicht ist ebenfalls definiert.** Die Kette steht als Bild im Ledger (`:4229`):
> `MESSUNG → FUNKTIONS-SYNTHESE → SCHNITT-KURVEN (break even) → optimale Konfiguration`
und die Rolle, verbatim (`Ledger:4575-4577`): *„Der Hybrid-Adapter braucht **keine Empfehlung**, sondern **die Schnittpunkte**. Sie sagen ihm, bei welchem Last-Kanal er umschaltet. **Die Auswertung produziert eine Schaltlogik, keinen Rat.**"*
Der Ausgabeweg steht in der B-4-Korrektur (07.08.): die CEB gießt *„bei Anforderung durch den Planer in Latex Dokumente, PDF oder xlsx Tabellen **nach Zielorte**"*, und *„XML bestimmt Verhalten"* — genau die „mehrere Experimente → mehrere Anhänge"-Semantik.
Das Trägerwerkzeug existiert: `super tools/latex_anhang` liest **positionsfrei nach Spaltennamen** (deshalb der Owner-Entscheid A8-S3, Spaltennamen bleiben stabil, `measurement_snapshot.hpp:53-58`). Zielfläche: Thesis Anhang A DE+EN, heute 31 gegatete `\InputIfFileExists` je Sprache und 18 harte `\input` bei 18 existierenden Dateien.

**Verdikt B4: keine Planungslücke.** Zwei-Baum-Modell seit 26.07. definiert, seit 03.08. gebaut, Wurzel seit 08.08. da. Der Anhang-Zuschnitt (Break-even, beste je Eingangslast, beste 5) ist die **Anwendersicht auf dieselbe Break-Even-Kette aus B1** — er ist genau so weit, wie B1 weit ist: Mathematik da, Kette nicht.

---

# TEIL C — DER NEUE WELLENPLAN

**Warum der vorgelegte Plan „max-parallel" nicht übernommen wird (0/3 Stimmen), und was von ihm bleibt.**

Seine tragende These — „I-Klasse (`axes/`, `topics/`, `anatomy/`) dreht den Anker, alles andere ist neutral" — ist am Objekt falsch, und ich habe es selbst nachgelesen: `test_g3_sha512_index.cpp:57-73` setzt **alle** Preimage-Glieder als **Literale** (`kOrgan`, `kSystem`, `kMeasure`, `kFrozenToolchain`, `kFrozenBvset`, `kFrozenOverlay`), mit der Begründung im Code: *„seit der Scharfschaltung trägt der DEFAULT des Glieds den Quell-Hash dieses Baums, und ein Anker über den Default wäre **bei jedem Commit rot**."* **Eine Änderung in `axes/` bewegt `kFrozenFingerprintV1` also nicht.** Alle fünf historischen Drehungen waren Mechanik-Ereignisse (Format 3, Format 4/R-3, Flag-Grammatik v2, E-E). Zusätzlich hat der Plan den Overlay-Schnitt zu klein gelesen: `overlay_source_set.hpp` trägt **vier** Kategorien, und System- **und** Mess-Achsen liegen flach unter `include/cache_engine/measurement/` (`:177-193`) — ein Verzeichnis, das der Plan in keiner seiner beiden Klassen nennt.

**Die echte Serialisierung liegt woanders:** nicht am Test-Fixture, sondern am **LIVE-Fingerprint jeder Tier-Binary**. Der bewegt sich bei jeder Quelltext-Änderung im Overlay-Schnitt — und er entwertet **nur dann etwas**, wenn schon gebaut wurde. Heute: 0 materialisierte `.fingerprint`-Sidecars. **Der Freeze gehört also nicht vor die Beweise, sondern unmittelbar vor den ersten 4096er-Batch.** Das verschiebt den kritischen Pfad und gibt zwei Tage frei.

**Übernommen aus „max-parallel"** (Herkunft benannt): die Welle-0-Idee *„messen statt raten"*; die Ein-Datei-Kollisions-Regel für `all_axes_golden.profile.xml`; das gebündelte Owner-Entscheid-Paket; die Nummernkreis-Tabelle; die Doku-Drift-Heilung; die Sidecar-Inventur als Kostengrundlage.
**Übernommen aus den adversarischen Urteilen:** der Fixture-Befund; die vier Overlay-Kategorien; die Mess-Zeit-Rechnung; die Ressourcen-Deckel (eine Lane, 31 G frei auf `/`, 20 G RAM, 2–3 parallele Voll-Builds); `compare` existiert bereits; E-18-Ziel-Branch ist entschieden.
**Neu von mir:** die D-3-Kollision als Wellen-Nullpunkt; B1–B4 als eigener Strang mit eigener Welle; die Trennung „Bau-Menge ≠ Mess-Menge" als Wellen-Gitter.

## Der Nullpunkt: D-3 gegen den Trigger

**Owner 07.08., verbatim** (`Ledger:7343`): *„**Wir bauen nur die 320er die wir auch tatsächlich messen und stellen die golden XML darauf um.**"*
**FAHRPLAN Phase 5** (03.08.): `GN_TOTAL=131072 × 12 Perms = 1.572.864 Binaries`.
Die neuere Owner-Aussage schlägt die ältere Planzeile. Die Zahlen bestätigen sie: die projekteigene Rechnung (`20260807-GESAMTDOSSIER-*:2564-2568`) kommt bei 524 288 Binaries × 216 Mess-Fächern × 0,1094 s auf **~143 Tage einthreadig** — als ausdrückliche **Untergrenze**, mit zwei Lanes gerechnet. Es gibt heute **eine** Lane (`ping prod2` → unbekannt), und bis zum 15.09. sind es **38 Tage**. Bei 1 572 864 wäre der Faktor gegen die Frist rund **11×**.
**Der ganze Plan unten steht deshalb auf D-3.** Alles andere ist Arithmetik gegen die Wand.

---

## Welle 0 — Zahlen und Entscheide (0,5–1 Tag, 5 parallel)

| Paket | Inhalt |
|---|---|
| **0-A Mess-Menge festnageln** | D-3 in Zahlen: welche 320 werden gemessen, welches Fächer-Profil, welche Zellzahl, welche Wanduhr auf **einer** Lane. Liefergegenstand: eine Tabelle, gegen die jede spätere Zahl geprüft wird. Grundlage: `20260807-GESAMTDOSSIER-*:2564-2568` |
| **0-B Live-Fingerprint-Delta** (Idee aus max-parallel W0-P1, korrigiert) | Nicht das Test-Fixture, sondern: **welche Pakete ändern Dateien im Overlay-Schnitt** (`overlay_source_set.hpp:129-201`, **vier** Kategorien, inkl. `include/cache_engine/measurement`)? Liefergegenstand: Paket → berührt Glied [7] JA/NEIN. Entscheidet nur die Reihenfolge **relativ zum ersten Batch**, nicht relativ zu den Beweisen |
| **0-C Sidecar-/Platz-Inventur** | `git ls-files '*.fingerprint'` **und** `find` über den ganzen Baum inkl. `/mnt/comdare-buildsystem`. Fallen-Regel: `grep -v '/build/'` mit **beiden** Schrägstrichen. Dazu: `/` hat heute **31 G frei bei 87 %**, der Runner liegt auf dieser Platte |
| **0-D A8-S2-Widerspruch + Nummernkreis-Tabelle** (max-parallel W0-P3/P10) | Owner-Vorlage mit beiden Zitatseiten; plus die Tabelle „Kürzel → Reihe → Gegenstand" aus A.2, die jeder Folgeauftrag zitieren muss |
| **0-E Owner-Entscheid-Bündel** | **eine** Vorlage, nicht sieben — Inhalt = Teil D |

**Blockiert durch:** nichts. **Warum diese Welle existiert:** ohne 0-A rechnet der ganze Plan mit einer Bau-Menge, die der Owner am 07.08. verworfen hat.
**Abnahme:** eine Mess-Mengen-Tabelle mit Wanduhr auf einer Lane · eine Paket→Glied-[7]-Tabelle · eine literale Sidecar-Zahl mit genannten Suchmustern · eine Kürzel-Tabelle · **eine** Entscheid-Vorlage.

## Welle A — Auswertungs-Kette (der eigentliche Rückstand) — 4 parallel, ab Tag 1

Das ist die Welle, die es im alten Fahrplan **nicht gab**, obwohl B1–B4 sie seit dem 19.07. verlangen.

| Paket | Inhalt | Anker |
|---|---|---|
| **A-1 A9-S2-Rest + S3 Writer-Kern** | `ergebnis_dateiname.hpp` als Single-Source (die Pfad-Hälfte konsumieren, **nie forken** — L5), 31-Zeichen-Sheet-Wache, `ErgebnisSchreibFehler` gegen das fertige A15-Framework; dann `builder/lager_ablage/`: `XlsxErgebnisMappe` (PRIVATE-Link gegen das vendorierte `ext/io/libxlsxwriter`), `CsvErgebnisMappe`, Factory, INFO-Blatt | Soll-Design liegt vollständig: `ce docs/architecture/20260803-a9_xlsx_writer_f3_soll_design.md` |
| **A-2 A9-S4 CLI + S5 Erstbeleg** | `tools/mess_report/`: `comdare_mess_report render\|plan\|version`, header-getriebener CSV-Leser, CoR-Filter. Erstbeleg gegen `super measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv` (Quelle read-only, additiv) | trägt zugleich den §61-Dual-Weg-Beleg für sich selbst |
| **A-3 Break-Even-KETTE** | Die eine offene Naht aus B1: Mess-CSV → `measurement_curve_loader` → `axis_spline` → `break_even` → **Artefakt** (heute existiert kein einziger Serialisierer für `BreakEvenPoint`). **Vorher**: die Doppel-Implementierung entscheiden (Teil D) | `heuristik/break_even.hpp`, `curve_fit.hpp:392`, `best_binary_selector.cpp:455/:520` |
| **A-4 Zwei-Baum-Wurzeln auf den Mount** | `lager_pfad_grammatik.hpp` + `lager_baum_writer.hpp` auf `/mnt/comdare-buildsystem` zeigen lassen, zwei getrennte Bestandslogs (§62-B-Präzisierung-2). **Kein Neubau — die Struktur existiert seit `5971cb47`** | 20 T / 15 T frei, heute verifiziert |

**Blockiert durch:** nichts davon berührt den Overlay-Schnitt (`builder/lager_ablage/`, `tools/`, `apps/` stehen in keinem der vier `kOverlaySourceSet`-Kategorien). **Echte innere Kante:** A-2 braucht A-1 (der Renderer braucht den Writer); A-3 braucht A-1 nur für die *Ausgabe*, nicht für die Rechnung.
**Abnahme:** `comdare_mess_report render` erzeugt aus dem Archiv-Bestand eine xlsx-Mappe im Messwerte-Baum auf dem Mount. Ein `BreakEvenPoint` wird **persistiert**, nicht nur zurückgegeben. Kein Messdatensatz gelöscht.

## Welle B — Identitäts-Fläche und Restbau (5 parallel)

| Paket | Inhalt |
|---|---|
| **B-1 Profil-Fenster** (max-parallel WA-P1) | `all_axes_golden.profile.xml` **in EINEM Paket**: Perm-Menge nach D-3-Entscheid, Begründungs-Kommentar `:180-184` nachziehen (er trägt noch die umgekehrte GN-3-Doktrin), Paper-Kopplung, `drop_tier_level`-Auflösung, die 4er-Anker **laut** brechen (`test_experiment_plan_director.cpp:180/:215/:435/:658`), ≥16 neue Anker, FS1-Testschuld |
| **B-2 A8-S2 Ebenen-Etikettierung** | nur bei Owner-GO aus 0-D. CSV **additiv** um Ebenen-Summen-Spalten + Reader-Toleranz-Test |
| **B-3 A14/OS-U4 + Z-04** | Token-Tripel-Vertrag, OS-Werte in die Mess-Spalten. Berührt `include/cache_engine/measurement` ⇒ **Glied [7]** ⇒ vor dem Batch |
| **B-4 A10 P4/P5/P6 + prod2-SPD-Stufe-2** | der Code verweist an zwei Stellen selbst auf die Lücke (`hardware_probe_factory.hpp:133`, `:403`) |
| **B-5 L3-Asymmetrie-Mechanik** | Owner: *„Messung ist hier PFLICHT und muss durchgesetzt werden"*. prod1 trägt zwei L3-Domänen, 96 MB gegen 32 MB, 8 physische Kerne je Domäne, **dieselbe CPU**. Zu bauen: erkennen → pinnen → getrennt ablegen (`core_class` ist bereits gelandet, 15 Dateien; offen ist die Domänen-Auswertung) |
| **B-6 A7/E-04-Rest** | Z-05/Z-06/Z-08 + die fehlende Mess-Marker-v2-Zeile |
| **B-7 SF-1-Fenster** | **läuft allein, mit Owner-Präsenz.** G8-gesperrte ABI-Fläche |

**Blockiert durch:** Welle 0 (0-B sagt, welches Paket vor den Batch muss). **B-7 seriell**, weil eine gesperrte ABI-Fläche nicht neben sechs Baustellen angefasst wird — und weil der Owner ein eigenes Fenster verlangt hat.
**Abnahme:** ctest voll grün mit **live erhobener** literaler Zahl (heute 428/428 auf `15522cdc`; die vier Differenz-Tests entstehen erst nach Werkzeugbau + Re-Configure — 424 ≠ 428 ist keine Regression, sondern die J-1/J-2-Lehre). Die alten Perm-Anker sind **gebrochen und ersetzt**, nicht toleriert.

## Welle C — Beweise und Neutrales (7 parallel, überlappt B)

| Paket | Inhalt |
|---|---|
| **C-1 Beweis 1** Batch-Wiederaufnahme über 2 Layer | fehlend ist der Zweitlauf `built_new==0` (0 Treffer, Gegenprobe `built_new` = 17). Das Ur-Gate `GN_DECISION=skip` ist doppelt unerfüllbar und der Ersatz vom Owner verworfen |
| **C-2 Beweis 2** Prune-/Hydrations-Testat | Emitter liegt in **super** `Code/02_messung_driver/main.cpp:967`, nicht in ce ⇒ braucht denselben Bare-Metal-Lauf wie C-5. Gate: `verified>0` **und** `pruned>0` |
| **C-3 Beweis 3** Variant-Gate-E2E — **zuerst neu zuschneiden** | seit A2 inert; der Test sagt es selbst. Neuer Anker = **Fingerprint-Mismatch**, nicht `COMDARE_VARIANT_GATE=true` (letzteres wäre laut I-4 eine Regression) |
| **C-4 Beweis 4** Bestandslog-E2E gegen echtes minio | Preflight `mc alias list` — `COMDARE_MINIO_ENDPOINT` ist ein **mc-Alias**, nie eine S3-URL; ein unbekannter Alias schreibt lokal und meldet Erfolg |
| **C-5 E-07-Gate Stufe 2** | die zehn `E07_*`-Gate-Zeilen von null; K1–K5 + N1–N3, GO nur bei allen acht. **Das längste Beweis-Paket** |
| **C-6 §61-Dual-Weg + G6/J-0…J-5** | `comdare_tier_measure_<host>` einmal bare-metal über den CMake-Weg; frisches Build-Dir dokumentiert, N live erhoben |
| **C-7 Doku-/Buchführungs-Heilung** (max-parallel WB-P7) | `build_orchestrator.hpp:289-300` (vier falsche Aussagen) · FAHRPLAN:38 „Overlay-Fenster" als **deprecated-erledigt** markieren (nie streichen) · L14-Vollzugsvermerk · die A8-S6-Stellenliste erst **erheben**, dann heilen |
| **C-8 Thesis-Strang** | C1-Rest (Danksagung/Sperrvermerk zur Freigabe, Lizenz-Matrix, EN-Abstract-Sync), C6, C7. **DE führt, EN zieht nach; Lint nie durch Umformen des deutschen Satzbaus** |

**Blockiert durch:** nichts strukturell — aber **durchsatzbegrenzt** (siehe unten). C-2/C-4/C-5/C-6 belegen alle die eine Maschine bzw. das exklusive Mess-Lock (`resource_group: ceb-measurement-exclusive`).
**Abnahme:** jeder Beweis mit **literaler Ausgabezeile** im Ledger gebucht, nicht als Haken.

## Welle D — Freeze und Trigger (seriell an der Spitze)

| Paket | Inhalt |
|---|---|
| **D-0 (seriell, allein) Anker-Setzung + TP1-FINAL-Wiederholung** | `kFrozenFingerprintV1` einmal setzen, in allen **drei** Spiegeln synchron (`test_g3_sha512_index.cpp:89`, `test_w10_system_cell_values.cpp`, `test_m_w12_stamp_bausteine.cpp`). Dann TP1-FINAL wiederholen: 9 Gates, `TP1_ANKER_OK` literal, `ctest -N`, **plus** der E2E-`.rsp`-Beweis. Ab hier: keine Berührung des Overlay-Schnitts ohne angemeldeten Neuanker |
| **D-1 (seriell) Trigger-Sequenz** | J-Kette (N live) → heavy-Signal → Kalibrierlauf `GN_TOTAL=64` → ETA → Bau nach **D-3-Menge**, 4096er-Meilensteine, Bestandslog AN, Endpoint-Preflight |
| **D-2 (parallel) A5-ETA-Reste** | die vier gemeldeten Reste — **und die Güte-Messung unter echter Bau-Last** (alle bisherigen Zahlen stammen aus Stub-Compiles mit 25-ms-Schlaf). Der Trigger-Lauf ist der erste echte Lauf |
| **D-3 (parallel) Platten-Wache** | prod1 **ist** die lokale Maschine, der Runner liegt auf `/` mit heute 31 G frei. Binaries gehören auf den Mount (Welle A-4), sonst legt der Batch die CI lahm |
| **D-4 (parallel) Welle-A/C-Reste** laufen weiter | der Trigger belegt Rechenzeit, nicht Entwicklerzeit — **solange die Abnahme keine grüne Pipeline verlangt** |

**Blockiert durch:** D-0 durch alles, was Glied [7] berührt (0-B-Tabelle: B-1, B-2, B-3, evtl. B-6). D-1 durch D-0 **und** durch C-1 (ohne Wiederaufnahme-Beweis ist ein Abbruch nach 200 000 Binaries nicht wiederaufsetzbar).
**Abnahme:** ein einmal gesetzter Anker · TP1 literal wiederholt · Kalibrier-ETA mit Zahl · kein toter Env-Var im Lauf · Platte nie unter Schwellwert.

## Welle E — Messung und Auswertung (USER-GO-STOPP)

**E-0 (hartes Gate) E.0 Kern-Mess-Schema** — Fahrplan wörtlich *„PFLICHT vor jeder Messung"*: K4-Naht in den Director, K5 produktiv + Generalisierung, per-Achse-Modi im Abgabeprofil.
**E-1** 320er-Abgabemessung (GO) → Voll-Messung nach D-3-Menge (zweites GO) → Rückschrieb NAS/minio über den WRITE-Token-Pfad. Messdaten **nie** löschen, Backups additiv.
**E-2** Die Mess-Ebenen getrennt liefern: E1 je Achse T0…T17 mit Wallclock **und** PMC; E2 je Gattung+Genus-Funktion am Prüfdock mit Schritt-Checkpoints; E3 als Aggregat — plus das, was Teil-D-Entscheid 3 als vierte/fünfte Ebene ergibt.
**E-3** L3-Asymmetrie-Messung getrennt je Domäne — *„für eine Cache-Engine-Arbeit ein Ergebnis für sich"*.
**E-4** Auswertung ab den **ersten** Batches (nicht am Ende): xlsx-Baum → Spline → Break-Even → LaTeX-Anhang (Auswertung, nicht Rohdaten; beste je Eingangslast, beste 5) → COMPARE/D2 je Maschine → Thesis C5/C2/D-07.

**Blockiert durch:** Welle D. E-0 zusätzlich seriell vor allem. **E-4 ist bewusst so geschnitten, dass es mit den ersten Batches beginnt** — deshalb steht Welle A auf Tag 1 und nicht hier.

## Welle F — Aufräumpass (zuletzt)

§75-Aufräumpass (Kandidaten 1–63), A8-S6-Abschluss, SetDock-Doppelschicht, Nummerierungs-Drift, Schluss-Konsolidierung mit Vollzugsvermerken je SHA/Datei:Zeile. **Messdaten nie löschen; Dokumentation deprecaten, nie streichen.**
**Blockiert durch Welle E — echt:** der Pass entfernt toten Code; läuft er vorher, fällt eine entfernte Fläche erst im Voll-Lauf auf, also zum teuersten Zeitpunkt.

---

## Der kritische Pfad

`0-A (Mess-Menge nach D-3)` → `B-1 (Profil-Fenster)` → `B-7 (SF-1, allein, Owner-Fenster)` → `D-0 (Anker + TP1, seriell)` → `C-5 (E-07-Gate Stufe 2)` → `D-1 (J-Kette → Kalibrier → Bau)` → `E-0 (Kern-Mess-Schema)` → `E-1 (Messung, zwei GOs)` → `E-4 (Auswertung/Anhang/COMPARE)` → `F-1 (Aufräumpass)`

**Zehn Glieder.** Der gesamte Auswertungs-Strang (Welle A: A9-Writer, CLI, Break-Even-Kette, Zwei-Baum-Wurzeln), der Thesis-Strang und die Doku-Heilung stehen **nicht** darauf. Sie sind heute startbar — und sie sind der eigentliche Rückstand.

## Was die Parallelität real begrenzt (nicht der Dateibaum)

1. **Eine Lane.** `ping prod2` → unbekannt. Alle Zeitzahlen im Korpus rechnen mit zwei Maschinen. Der §62-B-Symmetrie-Mechanismus (Gleichverteilung, Takeover) ist gebaut, hat aber niemanden zum Verteilen.
2. **RAM/Platte.** Heute gemessen: 60 G total / 20 G available, Swap 31 G mit 14 G belegt; `/` = 31 G frei bei 87 %. Der projekteigene Deckel (`Ledger:3881`) lautet `-j≤8-10`, max **2 parallele Voll-Builds**, effektiv **3 ce-Worktrees**. Neun gleichzeitige Bau-Stränge sind Fiktion; **4–5 sind real**.
3. **Ein Blech.** Alle super-CI-Jobs tragen `tags:[baremetal]` → nur Runner id=16 = prod1, `concurrent=2`. Während Welle D baut, kann keine andere Welle die Abnahme „Pipeline grün" erbringen. **Konsequenz für den Plan:** Welle-A/C-Pakete, die während D laufen, haben als Abnahme **lokales ctest + rescue-Push**, nicht „Pipeline grün". Das ist bewusst so gesetzt.
4. **Mess-Exklusivität.** `resource_group: "ceb-measurement-exclusive"` + P11-Preflight, 1-threadig. Die Messung ist per Doktrin nicht parallelisierbar — auch nicht auf derselben Maschine.
5. **Owner-Latenz.** Zwei Punkte des kritischen Pfades sind Entscheidungen, keine Arbeit (0-D/A8-S2, B-7/SF-1-Fenster) und zwei sind GO-Stopps (E-1). Der Plan kann sie nicht terminieren; er kann sie nur früh stellen — daher Welle 0.

---

# TEIL D — WAS DER OWNER ENTSCHEIDEN MUSS

Alles Ableitbare habe ich selbst entschieden und unten als **[SETZUNG]** gekennzeichnet. Offen bleiben acht Punkte.

**1 — BAU-MENGE: gilt D-3 gegen die Fahrplan-Phase-5-Zahl?**
Deine Aussage vom 07.08.: *„Wir bauen nur die 320er die wir auch tatsächlich messen und stellen die golden XML darauf um."* Der Fahrplan vom 03.08. sagt `131072 × 12 = 1.572.864`. Unsere eigene Rechnung: schon 524 288 ergeben ~143 Tage einthreadig als **Untergrenze**, mit zwei Lanes gerechnet; wir haben eine Lane und 38 Tage.
**Empfehlung: D-3 gilt, der Fahrplan-Wert wird als historisch markiert.** Der Systembeweis (§33) bleibt über die volle *Bau*-Matrix erhalten, die *Mess*-Menge folgt D-3. Wenn du das anders siehst, kippt der ganze Zeitplan und wir müssen über die Frist reden.

**2 — 12 Perms: welche Menge, und wie geht prod2 damit um?**
Heute stehen 4 im Profil (`O2/O3 × no_extension/avx2`), der Kommentar dort trägt noch die von dir am 01.08. umgekehrte Doktrin. 4 der 12 verlangen AVX-512, das prod2 strukturell nicht hat.
**Empfehlung: 12 setzen, prod2 loggt die vier fehlenden als Warnung** — das ist genau §62-A („kein Vorfilter, keine stille Auslassung") und deckt sich mit deiner Aussage vom 08.08. („korrekt und gewollt"). **[SETZUNG, sofern du nicht widersprichst]**, weil der Paragraph den Fall bereits regelt.

**3 — B3: was ist die fünfte Mess-Ebene?**
Dokumentiert sind drei Erhebungs-Ebenen (E1/E2/E3) plus der vierte Observer-Layer (Gattung/Genus, dein KERN vom 06.08.). Über sechs Suchmuster finde ich keine fünfte; Gegenprobe „drei Ebenen" trifft 11×. Zwei Lesarten: **(i)** Ebene 5 = Release-Wallclock (die Nachmessung ohne Mess-Einrichtungen); **(ii)** die fünf sind die fünf **Genera** (SearchAlgorithm/Set/Sequence/Adapter/View).
**Empfehlung: (i)** — sie fügt sich in die Kette `measure ⊂ compare ⊂ release` und hat schon einen eigenen Fahrplan-Posten. Aber das ist eine Vermutung, keine Ableitung; hier bitte ein Satz von dir.

**4 — Break-Even: welche der zwei Implementierungen ist die eine?**
`heuristik::BreakEvenPoint` (monotone Hermite, echte Knoten, §75-geschützt) gegen `best_binary::BreakEvenPoint` (stückweise linear, **festes 256-Raster**, self-declared SKELETON). Das Raster kann Schnittpunkte überspringen, die das Knotengitter findet. Das SOLL-Design legt den Router auf den ersten fest.
**Empfehlung: `heuristik::` ist der Kanon, der Selector-Zweig wird auf dessen `eval()`-Kontur umgehängt** und der SKELETON-Vermerk gestrichen. Betrifft §75-geschützte Fläche ⇒ dein Wort.

**5 — Schaltstabilität am Break-Even (Hysterese).**
Ein Router, der genau am Schnittpunkt schaltet, flattert bei Last nahe `x_be`. Im ganzen Korpus: `hysterese|hysteresis|flapping|schwing` = 1 unverwandter Treffer (Gegenprobe `verdraeng` trifft mehrfach). §32-F8-2 löst Divergenz über *mehr Binaries*, nicht über Stabilität.
**Empfehlung: Hysterese-Band als Pflicht-Eigenschaft der Schaltlogik aufnehmen** (Bandbreite aus der Mess-Streuung ableiten, nicht raten). Betrifft die Abgabe nur, wenn der Hybrid in die Abgabe soll.

**6 — A8-S2: gebaut oder abgeschrieben?**
Zwei Quellen führen S2 als „A8-Kern, trigger-blockierend", eine sagt „nie vergeben". `grep 'A8-S2'` über den ganzen Ledger = 0.
**Empfehlung: bauen, aber schlank** — nur die CSV-Ebenen-Summen-Spalten additiv, damit die Mess-Zeilen die Ebenen-Semantik tragen. Der Rest (E2/E3-Etikettierung) kann in die Auswertung wandern. **Wenn du „nie vergeben" bestätigst, streichen wir ihn ganz — dann trägt die CSV aber keine Ebenen-Zuordnung, und die Nachrüstung nach der Messung wäre ein Datenbruch.**

**7 — SF-1-Fenster: wann?**
Dein Wort vom 06.08.: *„SF-1: Vor Abgabe bitte ein eigenes Fenster."* — es supersediert die 05.08.-Zeile „nach Abgabe". Die Fläche ist G8-gesperrt, das Fenster braucht dich.
**Empfehlung: ein 2-Stunden-Fenster in der Woche vor dem Trigger**, weil danach jede Berührung einen Neuanker kostet.

**8 — LaTeX-Anlage: in die Abgabe oder danach?**
Anhang A steht bei 31 gegateten und 18 harten Includes je Sprache. Hängt daran: V-04 (Auswertungs-Writer M-8/M-9/M-15) und die vier Heuristik-Kurven-Writer. „In die Abgabe" zieht M-9 sofort hoch.
**Empfehlung: Struktur + M-9 jetzt (Welle A), M-8/M-15 nach echtem Korpus.** Die Struktur ist heute baubar; nur die Zahlen darin kommen aus Welle E.

**[SETZUNGEN, die ich ohne Rückfrage getroffen habe]**
- **A2-Zusage „EINMALIG ZULETZT" wird neu gefasst** als *„einmalig zuletzt **vor dem ersten 4096er-Batch**"* — die alte Fassung war am Test-Fixture gemessen und dort nie erfüllbar; die neue ist am Objekt (Live-Fingerprint) die wirksame.
- **E-18-Ziel-Branch ist nicht offen** — `development` ist am 06.08. gewählt (`Ledger:7100`). Offen ist nur die Scharfschaltung und der unangewandte `gitlab-ci-delta.patch` aus `b-e18-snap`; das ist Arbeit, kein Entscheid.
- **`compare` wird nicht neu eingeführt** — der Enum-Wert existiert (`run_methodology_registry.hpp:58`), gebaut wird nur das Verhalten D2.
- **Die Zwei-Baum-Struktur wird nicht neu entworfen** — sie ist seit 26.07. definiert und seit `5971cb47` gebaut; es werden nur die Wurzeln auf `/mnt/comdare-buildsystem` gezeigt.
- **A11 (ccache-Allowlist-Drop)** bleibt bis zu deinem Widerspruch **so wie er ist** — der Code trägt eine eigene Begründung (Marathon-Scan-Falle 27.07.), und der Plan, ihn zu droppen, ist älter.
- **Abnahme-Regel während des Trigger-Laufs:** lokales ctest + rescue-Push statt „Pipeline grün", weil prod1 dann belegt ist.

---

**Unsicherheiten, offen benannt.** Ich habe **keinen Bau und kein ctest gefahren** (Änderungsverbot, kein warmer Baum) — alle Test-Aussagen sind Registrierungs-Belege aus `tests/unit/CMakeLists.txt` plus im Ledger literal zitierte Ausgaben. · Für B3 kann ich die fünfte Ebene nicht auflösen; meine zwei Lesarten sind Hypothesen. · Die Roh-Transkripte unter `docs/sessions/backups/` habe ich für B1/B2/B4 nur punktuell gegengelesen (die Zitate stammen aus Ledger-Verbatim-Blöcken und den Task-Beschreibungen); ein vollständiger Transkript-Durchgang könnte für B3 noch etwas finden. · Ob die Pipelines 15256/15250 die heutige Spitze `15522cdc` abdecken, habe ich nicht per API geprüft (Cluster read-only).