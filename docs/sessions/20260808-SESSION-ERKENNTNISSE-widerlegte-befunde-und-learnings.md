# SESSION 08.08.2026 — Widerlegte Befunde und Learnings aus dieser Session und fünf Kontexten

> **Owner-Auftrag, wörtlich:** *„Bitte dokumentiere ALLE Erkenntnisse dieser Session und der letzten
> 5 Kontexte nochmal separat als reiche Session, also Widerlegte Befunde und Learnings"*

---

## ⚠️ WAS AN DIESEM DOKUMENT NICHT BELEGT IST — zuerst, nicht im Kleingedruckten

Dieses Dokument beschreibt Fehlerklassen, die dadurch entstehen, dass Berichte ungeprüft als Belege
genommen werden. **Es wäre selbst ein Fall dieser Klasse, wenn es seine eigene Lage verschwiege.**
Deshalb hier, vor allem anderen:

**(1) Die adversarische Verifikation lief fast nicht.** Der Workflow war so gebaut, dass jeder
widerlegte Befund von einem eigenen Agenten gegen den Strich geprüft wird — nicht ob er stimmt,
sondern ob der *Widerruf* selbst falsch sein könnte. Von **40 Prüfagenten sind 38 am Session-Limit
gescheitert** (`You've hit your session limit`). Ergebnis: **1 Befund bestätigt, 1 gefallen, 9 ohne
prüfbaren Beleg, die übrigen 370 ungeprüft.**

> Die Sammlung ist damit belastbar, das **Verdikt nicht**. Jeder Einzelfall unten trägt seinen Beleg
> (Datei:Zeile, uuid, SHA) und ist nachprüfbar — aber *dass* er nachgeprüft wurde, gilt nur für zwei.
> Wer aus diesem Dokument eine Aussage übernimmt, misst sie selbst nach. Das ist keine Floskel: genau
> diese Unterlassung ist die meistbelegte Klasse im Dokument.

**(2) Der Anfang fehlt.** Die Synthese wurde beim Erzeugen abgeschnitten; das Dokument beginnt mitten
in Abschnitt 3.1. Verloren sind der Kopf, die Zahlenübersicht und der Beginn der ersten Klasse.
Prüfung: die Journal-Fassung (`wf_f39a28a6-0ec`) ist byte-identisch abgeschnitten — es ist kein
Übertragungsfehler beim Abspeichern, sondern das Ausgabelimit des Synthese-Agenten.

**Die Zahlen der Erhebung** (aus dem Workflow-Rückgabewert, nicht geschätzt):
8 von 8 Quellbereichen geliefert · **381 widerlegte Befunde** · **316 Learnings** · **103 Nichtfunde**
· 49 Agenten gestartet, 11 fertig, 38 am Limit gescheitert · 2,45 Mio Agenten-Token · 468 Werkzeugaufrufe.

**Quellen:** beide Session-Transkripte (89 MB und 299 MB), die Session-Dokumente vom 05.–08.08.,
sowie 119 Commits beider Repos von heute.

---

ptSource=typed` — echtes Owner-Wort, kein Agent-Echo): „Du hast ein Verständnis-Problem über die CEB … Die CEB kann beide Messfühler tragen, aber legt die Ergebnisse je PMC getrennt ab. … Die CEB kann alles messen, aber startet einmal die Tier-Binary gepinnt auf einen E-Core und einmal gepinnt auf einen P-Core und misst die Tier-Binary dann mit dem entsprechenden PMC durch. Das ist eine reine Wiederverwendung durch Achsen-Permutation durch die CEB auf einer dafür zuständigen SYSTEM-Achse." Lead-Quittung 22:02:57 (uuid `c4f2053e`): „meine Aussage ‚eine CEB je PMU-Domänen-Satz' war falsch. Ich korrigiere das Memory sofort."

Richtig ist demnach — Merkformel der geprüften Schärfung: **CT getragen (beide Messfühler) — pro Permutation gewählt (einer) — je PMC getrennt abgelegt.** Die CEB bleibt compile-time spezialisiert je Konfiguration/Messsystem (O-083 wurde nicht widerrufen); vervielfacht wird nichts, und zweimal gepinnt gestartet wird die **Tier-Binary**, nicht die CEB. Der Widerruf ist doppelt gedeckt, Owner-Wort und Objekt: `libs/cache_engine/include/cache_engine/measurement/numa_cpu_pin_process_probe.hpp:112-116` schreibt die Korrektur wörtlich in den Code („die CEB, die DIESELBE Tier-Binary einmal auf einen E-Core und einmal auf einen P-Core gepinnt startet"), `:118-122` sichert die A-15-Stempel-Neutralität, und `algo_semver.hpp:208` erzwingt sie strukturell (`core_class` hängt an `target_isa` mit `binary_id="never"` — die Kern-Klasse geht nicht in die Binary-Identität). Korrigierte Fehlerklasse laut Prüfpass: **Bezugsobjekt-Verwechslung — der Owner-Quantor „je Konfiguration" wurde auf „je PMU-Domänen-Satz" umgehängt** und multiplizierte dadurch ein Bau-Artefakt; „Architektur-Missverständnis" ist nicht falsch, benennt aber den Mechanismus nicht. Zwei Abstriche am bestätigten Widerruf: der Zusatz „derselbe Irrtum tauchte am 07.08. 07:27 in D-1 wieder auf" ist **nicht gefunden** (Abschnitt 6.3), und der Satz „die Trennung liegt nicht in der Binary" darf nicht als „kein CT" gelesen werden — das wäre die Gegenregression (Abschnitt 5.2).

**Die weiteren Fälle der Klasse:**

- **Der A-7-Widerruf selbst** importierte A-8-Belege in den A-7-Datensatz — der korrekte Beleg am falschen Gegenstand, angewandt von einer Korrektur. Vollständig in Abschnitt 5.1.
- **Vier Fälle an einem Tag** (Bündel): veraltetes Datum, case-sensitive Suche gegen VERSALIEN, `grep -v '/build'` frisst `/builder/`, und das Muster `DIFF-HYGIENE:` gegen die Verdikt-Zeile `DIFF-HYGIENE-WACHE:` — ROT verschluckt, Pipeline 15110 fiel. Beleg: Ledger `:4705-4707`; Merksatz des Leads: „nicht das Werkzeug war falsch, sondern der Ausschnitt, den es sah."
- **„A1 nicht gelandet"** — Falschbefund, gemessen am lokalen `main` statt an `origin/main`. Beleg: Lead-Fehlerbilanz Punkt 4.
- **„Divergiert"** — Falschbefund, `merge-base` im Submodul-Checkout gerechnet, wo der SHA unbekannt ist. Beleg: Transkript 2026-08-08T11:53:04 (uuid `9df70aa2`).
- **Beide kursierenden Plandokumente** hatten sich am veralteten Separat-Klon `29a1700` statt am Submodul `19e1592` verlesen; O-4-Abschnitt: „die Zahlenbasis war falsch … am richtigen Objekt gemessen."
- **Agent auf Feature-Branch-Checkout**: am ce-Submodul unter `super/Code/external/` gemessen, das auf einem Feature-Branch stand, während die Spitze im Landungs-Worktree lag. Beleg: Memory K10 (`:169-172`).
- **Wachen-Skript maß fremden Baum**: `ci_diff_ascii_width_guard.sh:141-142` leitet die Repo-Wurzel aus dem eigenen Ort ab; aus `cwd=/home/comdare/wt-b14-ce` aufgerufen maß es 12578 statt 1450 Zeilen — der Prüfer lief bei der Verifikation selbst hinein. Beleg: Checkheft N-1 (`:379-391`).
- **Testbilanz zum falschen Quellstand**: die gemessenen „406 von 406" gehörten zu Quellstand `3133f226`, nicht zur Landelinie; die Zahl 409 aus Eingangsberichten wurde deshalb ausdrücklich nicht übernommen. Beleg: Prüfbericht („Nenner-Problem").
- **Remote-Aussage aus lokaler Ref-Kopie**: Beinahe-Befund „GitHub-Sicherung vier Commits zurück" aus `refs/remotes/*` abgeleitet, von der Live-Messung per `git ls-remote` widerlegt. Beleg: Checkheft N-4 (`:417-439`).

### 3.2 Klasse 2 — Die stille Null (der Prüfer lief nicht)

Eine Prüfung, die gar nicht oder nur über einen leeren Bereich lief, liefert dieselbe Null wie ein echter Freispruch. Ohne Nenner ist beides ununterscheidbar; die Null wird als Grün gelesen. Acht Fälle im Material.

- **gitleaks meldete fünfmal „no leaks found" bei 0 commits scanned**, weil `.git` in Worktrees und Submodulen nur ein Zeiger ist; der zweite Vorfall lag keine zwei Stunden nach der Dokumentation des ersten. Belege: Transkript 06.08. 20:41 und 21:21, 07.08. 01:38 und 06:44, 08.08. 11:42; Erstlauf über `wt-b1-e18` (L168).
- **Pipeline 15314 als Beweis der CMake-Zyklus-Heilung** — `build:clang` lief dort gar nicht, weil ein Ledger-Commit die `changes:`-Gates nicht auslöste: 3 statt 14 Jobs. Echter Beleg erst 15306/`a9a0754c` failed → 15309/`51eebbfe` + 15312/`56ffab37` success. Wiederholung 14:35: „lief pmc:intel in 15357 überhaupt — oder ist das wieder ein übersprungener Job?" (uuid `999af397`).
- **ugrep-stille-Null im ASCII-Gate**: `/usr/bin/grep` ist auf prod1 ugrep; `grep -P '[^\x00-\x7F]'` bricht dort mit Syntaxfehler ab, die Pipe liefert 0 — jedes so gemessene Gate meldete rückwirkend falsches Grün. Beleg: L4181/L4206; Memory `reference_ugrep_ascii_gate_stille_null`.
- **cf22-Mojibake-Prüfung meldete 0 bei nicht gelaufenem cf22** — „Mojibake=0 ✓, aber cf22 lief nicht — false positive durch die Pipe" (Lead-Text, Alt-Raum).
- **Der gitleaks-Aufruf maß `tail` statt gitleaks** (`rc=$?` nach Pipe misst das letzte Glied; „-C gibt es dort nicht"). Beleg: uuid `eaa6bf75`, 08.08. 11:42.
- **`grep -r --include=*.hpp` übersprang stumm `perm_runner.hpp`** → Ur-Irrtum B3-2 „#223 Gate fehlt". Beleg: Methodik-Warnung im Audit-Doc (Alt-Raum).
- **„Voll-Bau" war keiner**: Ninja übersprang Targets; der kalte 2-Pass-Configure ergab 404 statt 408 Tests, es fehlten vier namentlich benannte v41-Tests. Beleg: uuid `3d28e5cf`, 07.08. 10:11.
- **Leeres PMC-Messfenster**: `m3v2_pmc_smoke` misst nichts zwischen `begin()` und `end()`; Intel lieferte exakt 0 und fiel, AMD bestand durch 34–53 L1-Misses Syscall-Rauschen (13 Traces: 7/7 AMD nonzero, 6/6 Intel null, deterministisch). Beleg: Task #26; `m3v2_pmc_smoke.cpp:41-43`. Zugleich ein Fall der Klasse 8.

### 3.3 Klasse 3 — Das Verfahren erzeugt den Befund (Artefakt-Klasse)

Das Messverfahren selbst produziert das Signal — einen Phantom-Treffer oder eine Phantom-Null — und der Befund beschreibt das Werkzeug, nicht den Gegenstand. Erste Rückfrage bei jedem überraschenden Ergebnis: kann mein Verfahren das erzeugt haben? Elf Fälle im Material.

- **1133 Phantom-ASCII-Verstöße durch Locale-Artefakte**; `od -c` fand 0 Bytes. Beleg: uuid `eaa6bf75` („die Falle steht in meinem eigenen Register").
- **„Die Ersatztexte fehlen im PDF"** — erzeugt durch PDF-Textextraktion ohne Trenner; sie standen wörtlich drin. Beleg: Memory KLASSE 4 (`:39-46`); uuid `8b779ccd`, 20:00.
- **Kerning-Artefakt und falsch gezählte Kapitelmenge** — zwei weitere der vier KLASSE-4-Fälle; die übrigen zwei (lokaler Branch vs. `origin/main`, Submodul-Richtung) gehören zu Klasse 1 und sind dort möglicherweise mit den Fällen „A1 nicht gelandet"/„divergiert" identisch — im Material doppelt geführt, hier nicht glattgerechnet.
- **„1552 gitleaks-Treffer sind Fehlalarme"** — das Muster deckte `GR1348941` nicht ab; real lagen 390 Runner-Token im Klartext. Beleg: uuid `49ab5f39`, 20:45. (Zur ungeklärten Zahlen-Kollision 776 vs. 390 siehe Abschnitt 6.2.)
- **„13 MAX / 19 MIN"** — real 17/32; **„0 dreiphasig-Treffer"** — real 8, weil VERSALIEN. Beleg: Agent-„KORREKTUR AN DER VORERHEBUNG".
- **`find -newermt` ohne ISO-Timestamp** (auf prod1 ist `find` bfs) erzeugte einen falschen Stille-Alarm auf eine laufende Welle. Beleg: L231.
- **pgrep-Selbstmatch** — zweimal (L466, L17377): falsche Warnung an einen Agenten, in seinem Baum laufe ein fremder Prozess.
- **Stale Generator-Binary → falsches ROT**: ein wiederverwendetes `build/` ließ das Binary vom Vortag stehen; der Roundtrip-Test wurde falsch ROT mit einem Diff, der ausgerechnet die frisch gelandete `core_class`-Zeile zeigte; nach erzwungenem Neubau 421/421 grün. Beleg: Ledger-Nachtrag „WIE DER FEHLBEFUND VERMIEDEN WURDE".
- **Wach-Regex matcht Allerweltswörter**: CiCheck288b klassifizierte Pipeline 13442 falsch, weil `ERROR ... artifact` auch „Uploading artifacts for failed job" matcht und `\berror\b` Commit-Titel wie `feat(error):`. Fix: Anker an `SignatureDoesNotMatch` bzw. Upload/Registry/LFS+403 in den letzten 80 Zeilen; gegen 4 echte Traces getestet. (Alt-Raum.)

### 3.4 Klasse 4 — Der Nullbefund als Positivbefund („fehlt / tot / unverdrahtet")

„X ist nicht verdrahtet / wird von niemandem gelesen / ist tot" ist eine Allaussage mit voller Beweislast — und wurde wiederholt aus einem einzigen Null-Grep gefolgert, ohne die Gegenfrage: wer inkludiert, linkt, ruft, plant X? Neun Fälle im Material.

- **„Die Limits-Entkopplung ist ungebaut"** — vom Lead ungeprüft in Ledger, Kontextübergabe und Task geschrieben und verschärft; erst der Einstieg in den Bau zeigte: vollzogen (`profile_run_entry.hpp:29` inkludiert den generierten Header, `comdare_attach_generated_catalog` hängt an der Bibliothek). Beleg: Ledger-Nachtrag 07.08. abend-4 „WIDERRUF"; Task #40.
- **Fünf Lead-Prämissen „Lücke, die keine war"** (Bündel): „Meine Auftragsprämissen waren häufiger falsch als die Arbeit der Agenten. Fünfmal habe ich eine Lücke behauptet, die keine war — ‚nicht verdrahtet', ‚vergessen', ‚tot', ‚fehlt'." Konkret: die 23 Doku-Akten (alle tragen seit 22.07. den Kopf), beide Restposten, `target_isa.numa_node/page`, `generated/`-Ballast. Beleg: Bilanz-Abschnitt 07.08. nachmittags; Task #41.
- **V-08 „es gibt keine PMC-Quelle"** — tatsächlich werden L1/L3/DTLB/RAPL real via `perf_event_open` erhoben; der Fehlalarm hätte eine korrekte Thesis-Aussage durch eine falsche ersetzt. Beleg: Lead-Fehlerbilanz Punkt 4; `linux_perf_pmc_source.hpp:191-194` (zitiert, nicht am heutigen Stand nachgemessen).
- **„0 Konsumenten = tot"**: die #16-Muster-C-Deprecation von 5 Headern wurde revertiert (ce `804aa3c2`); Owner-Wort: „das meiste sind fehlerhaft umgesetzte Pflicht-Features." (Alt-Raum.)
- **`module_loader.hpp` als toter Code** — der Build-Graph kompiliert ihn über `experiment_runner.cpp`; der grüne baustein-Test war ein False Positive der Tot-These. (Alt-Raum.)
- **„COMDARE_BESTANDSLOG wird nirgends gesetzt"** — das Artefakt ist emittiert, nicht eingecheckt: die Mess-Jobs entstehen erst durch den Plan-Director, der die Variable zur Emissionszeit einbrennt (`experiment_plan_director.hpp:952-955`, vier `append_forward_var_literal`-Aufrufe). Beleg: Checkheft R-4 (`:264`).
- **„Eine Zeichenkette, die nachweislich niemand liest"** — der Leser stand in der Planung; kein grep über `libs/` konnte ihn finden. Beleg: L4052; Checkheft R-3.
- **`.gitmodules:12-40` behauptete den zweiten Thesis-Zeiger als „TOT"** — vom Owner widerlegt. Beleg: Task #55 (super `f507a9af`). Zugleich Klasse 5 (Kommentar als Beleg).
- **„bricht den Build" über nie inkludierte Header**: `abi_v1_to_v2_mapper`/`is_original_macro` — nie inkludiert heißt nie kompiliert; die Begründung war gegenstandslos, auch wenn das Symbol tot ist. Beleg: Verify-Text (Alt-Raum).

### 3.5 Klasse 5 — Der Bericht als Beweis (Echo-Klasse)

Berichte, Kommentare, Commit-Botschaften und Auftragsparameter sind Behauptungen, keine Belege. Wer sie ungeprüft übernimmt, baut eine Echo-Kette: die Zahl kommt zurück und klingt wie eine Bestätigung. Acht Fälle im Material.

- **Häufigste eigene Fehlerklasse des Leads** (Bündel): drei falsche Commit-Zuordnungen, „B14 ist geheilt", „+26 clang-format sind kosmetisch", „die Arbeit baut" — alle aus Agenten-Berichten übernommen. Beleg: Memory `feedback_eigene_arbeitsfehler_lead_berichte_nie_uebernehmen` KLASSE 1.
- **Parameter-Echo**: der Lead schrieb „Basis origin/development = 5060489e" in jeden Bau-Auftrag; ein Agent meldete, gegen genau diese Zahl gemessen zu haben statt gegen die gerechnete merge-base. Beleg: Memory KLASSE 9 (`:141-165`).
- **Re-Anchor-Irrtum** („EIN Symbol, CRC über ids"): Kartierungs-Behauptung ungeprüft in verbindliche Auflagen übernommen. Beleg: `docs/sessions/20260722-SESSION-KONTEXTUEBERGABE-abend-k7b-komplett.md:99-100` („Agent-STOPPs ernst nehmen — zweimal heute Gold wert"). (Alt-Raum.)
- **Codex-Manifest verschwieg Paket B**; separat behauptete ein Bericht „Fall D BLEIBT, KEINE Code-Umformulierung nötig" — `git show b4e6dcd5:Code/02_messung_driver/main.cpp` Zeile 942 trägt `&& artifact_cache->minio_enabled()`, `grep lager_ebene_fehlt` über denselben Stand: 0 Treffer. (Alt-Raum.)
- **„prod2 ist jetzt stabil, wir haben ihn repariert"** — fremdbehaupteter Heilungszustand; Lauf 9100 zeigte `pmc:intel` 345 s hängend in `cmake -B isolated` auf prod2. (Alt-Raum.)
- **Test- und CMake-Kommentare als Beleg**: `test_a8s3_csv_klasse_c.cpp:6` und `tests/unit/CMakeLists.txt:5128` behaupteten „PmcCounters ERHOB branch_misses real" — das Interface fuhr `NullPmcSource` mit `available()=false`; die Spalte wäre konstant 0 in die Messung gegangen. Beleg: Task #8 (M-3a, ce `6a8ab995`).
- **Drei Kommentare am Objekt falsch, der Code hatte recht** — ein KRITISCH-Befund war auf Basis eines Code-Kommentars entlastet worden. Beleg: Checkheft R-20 (`:2450-2460`); Ledger mittag-15.
- **Commit-Botschaft mit falscher Ursache**: `abbf53ef` („ohne needs war der Job stage-blockiert") — empirisch über 4 Wellen widerlegt: `test:unit` startete auch vor OP-2 in jeder Voll-Welle vor `verify:submodules`. Ein wirksamer Fix mit falscher Begründung vergiftet spätere Interpretationen. (Alt-Raum.)

### 3.6 Klasse 6 — Deutung statt Messung

Ein Zustand wird gesehen und gedeutet, statt API, Trace oder Objekt abzufragen. Die Deutung ist billig, klingt plausibel und ersetzt die Messung — bis jemand misst. Sechs Fälle im Material, davon drei Beinahe-Fälle (vor Meldung selbst entschärft).

- **`waiting_for_resource` als „die resource_group wirkt, kein Stau" gedeutet** — der Agent maß live über die API: drei Pipelines standen still, während eine baute; der eigene Fix von einer Stunde zuvor war schlimmer als der Fehler. Lead-Selbstbeschuldigung: „Ich habe interpretiert, er hat gemessen — wörtlich die Figur, die ich heute selbst als V11 in die Doktrin geschrieben habe."
- **„Transient"/ICE-Fluke**: rote Pipeline seit 9053 als g++-13-ICE eingestuft und retriggert — der Retrigger ohne Ursachenbeweis verlängerte den Ausfall um neun Stunden; echte Ursache war ein deterministischer prod2-Hang. Beleg: Owner-Wort 2026-07-09. (Alt-Raum.)
- **OOM-Verdacht bei GitLab-Down-Momenten** — Prometheus entschied in Minuten: 0 Restarts in 4 h, 0 OOMKilled, webservice ~48 % / sidekiq ~20 % der Limits, Nodes 31–45 % frei; echte Ursache ~500 Branch-Anlagen → Pipeline-Sturm. (Alt-Raum.)
- **Beinahe: „Gitlink-Bump NICHT wirksam"** — `HEAD is now at <SHA>` im Submodul-Checkout ist der Zustand VOR dem Update; Gegenbeweis `git submodule status` zeigte `bc5dc37c`, der Fast-Forward-Diff listete exakt sieben ce-Zug-Dateien. Als Falle (p) im Memory verankert. (Alt-Raum.)
- **Beinahe: „9 von 13 Jobs fassen den Schlüssel an"** — Grep-Treffer im CI-Trace stammten aus Commit-Titeln im `get_sources`-Block („HEAD is now at 803b7d71 fix(ma…") und der Submodul-Diff-Stat. Beleg: ZWISCHENMELDUNG 13623, Abschnitt (2). (Alt-Raum.)
- **Beinahe: Rechte-These bei PMC** — `m3v2_pmc_smoke.cpp:123-126` druckte bei `available=0` eine Vermutungsliste (perf_event_paranoid, CAP_PERFMON, Container); Folge: drei Fehldiagnosen und eine beinahe ausgeführte Cluster-Rechte-Änderung, während die wahre Ursache im eigenen Kopfkommentar stand. Beleg: Checkheft R-11 (`:2342-2352`).

### 3.7 Klasse 7 — Das Dokument überlebt den Gegenstand (Stale-Klasse)

Listen, Pläne, Snapshots und Synthesen tragen den Wissensstand ihres Entstehungszeitpunkts und altern, während gearbeitet wird. Wer sie fortschreibt statt gegen das Objekt nachzumessen, macht sie zu aktiven Fehlerquellen. Zehn Fälle im Material.

- **Das Board führte seit dem 07.08. „zehn offene Owner-Entscheide"** — fünf von zehn waren erledigt oder gegenstandslos, drei davon von der laufenden Arbeit miterledigt, ohne dass jemand zur Liste zurückging. Beleg: uuid `a6ecb379`, 08.08. 14:32:59.
- **§75-Befund derselben Klasse**: 133 Kandidaten geführt, 104 offen; „wer nur den Ledger liest, sieht 74 von 92."
- **Ledger-Audit**: „43 von 43 geprüften Positionen nicht sauber erfasst" — der Ledger irrt in beide Richtungen. Beleg: uuid `ad73c34d`, 07.08. 09:37.
- **Dossier 17** (`17_E4_XML_VOLLVISION_ROADMAP.md`) nannte ABI-MAJOR==4 (Ist 8), einen nicht mehr existierenden Andockpunkt `main.cpp:513-521`, `CatalogAxes<4,4,5,4>` statt 18 Achsen, Phase 4 als offen — „Dossier 17 HAT den Irrtum verursacht." Konsequenz: Stale-Block, Vollzugsmarken, Namensraum-Warnung gegen die drei Phase-Zählkreise. Beleg: uuid `678f9e53`, 07.08. 14:37.
- **§14.1 führte G-Q2/G-234V-a/b/G-7b3 als offen** — alle durch spätere Ledger-Zeilen längst aufgelöst (Z.336, Z.302/330, Z.342/334). (Alt-Raum.)
- **Pausen-Nachtrag meldete A-1/A-2/A-3 als ausstehend** — Commit N1 `08076dd2` enthielt sie bereits (`builder_registration.hpp` +47/−9, `test_g3_takeover_sweep.cpp` +53/−1); wirklich offen war nur der 323-Doppellauf. (Alt-Raum.)
- **Das Checkheft alterte selbst**: vier seiner Befunde waren bei Abfassung bereits geheilt, zwei davon 62 bzw. 57 Minuten vorher; fünffache Zeilendrift an einem Tag (40 bis 64 Zeilen). Beleg: Checkheft R-18/K-8 (`:1728-1736`), N-2 (`:395-403`).
- **Synthese-Bericht meldete überholte Thesis-Achsenzahl als Defekt** — V-01 hatte sie eine Stunde später am Objekt entlastet; „Kein Abgabe-Defekt. Der Agent hatte diesen Stand noch nicht" (L3664, Ledger mittag-24).
- **Der LB-0..LB-6-Paketschnitt war buchhalterisch verloren**: 0 Treffer im 14-Tage-Register, weil `docs/sessions/*` nicht zu dessen aufgezählten Quellen gehört; Gegenprobe gegen `9f5ff1d2^` liefert 0. Beleg: Checkheft R-10 (`:355-367`), Ledger `:4470-4474`.
- **Zahlen-Direktiven altern mit der Hardware**: die Concurrency-Doktrin wurde mehrfach revidiert; die Zahl trägt jetzt ihre Revision im Kommentar (`.gitlab-ci.yml:43` verbatim: „CMAKE_BUILD_PARALLEL_LEVEL: \"6\" # User 2026-07-06: 2x6 Kerne bei concurrent=2 (prod1 16C; revidiert 4@8-Kern-cgroup-Aera)"). (Alt-Raum.)

### 3.8 Klasse 8 — Die blinde Wache (Grün ohne Biss-Beweis)

Eine Wache, die die falsche Größe vergleicht, nie die Gelegenheit zum Beißen hatte oder deren Köder untauglich ist, liefert Grün mit Autorität — schlimmer als keine Wache. Hausregel seither: jeder Köder muss erst beißen, bevor eine Wache als gebaut gilt. Acht Fälle im Material.

- **Die Submodul-Wache prüfte Worktree gegen Gitlink statt Gitlink gegen Gitlink** und hätte den Thesis-Drift auch nachträglich nicht gefangen. Beleg: uuid `a3ea7a9e`, 06.08. 21:41; super `3ccbc501`; `ci/thesis_gitlink_parity.sh`.
- **Eine Bissprobe meldete fälschlich GRÜN**, weil der Patch-Suchtext nach clang-format nicht mehr passte — „Nicht die Wache war blind, meine Probe war es." Härtung mit `BOOST_MP11_VERSION=109100`. Beleg: FK-3-Agentenbericht Punkt (b).
- **`contract:axis-version-lock` war 18 Tage faktisch AUS**: YAML-Mappings verwerfen bei doppeltem Schlüssel kommentarlos alles außer der letzten Definition nach Textposition — `7492b2ea` 12:51:55 (INERT, Dateiende) schlug `76b6ef01` 15:42:56 (hartes Gate, weiter oben). Der Tripwire lief in keinem einzigen Lauf. Beleg: Checkheft SW-1 (`:471-476`).
- **Sechs stille Wachen in einer Session** (Bündel): axis-version-lock 18 Tage abwesend, neun Tests in keinem CI-Job (zweiter Durchgang desselben Problems), vierfache blinde PMC-Wache, die Gate-Pipe, `active_telemetry_is_silent()` liefert literal `false`. Beleg: Checkheft Kapitel II (`:451-651`).
- **Untaugliche Köder**: am 07.08. dreimal (`#if 1`, `#if defined(NIE_DEFINIERT)` — cppcheck probiert nirgends definierte Makros gar nicht durch), am 08.08. erneut mit den kanonischen AWS-Doku-Beispielen, die in gitleaks allowgelistet sind; mit zufälligen Schlüsseln schlug dieselbe Methode sofort an (rc=1). Beleg: Memory K13 (`:180-191`); `feedback_gitleaks…:33-38`.
- **Wache im Gegenstand der eigenen Fehlerklasse**: `ci_yaml_key_guard.sh` ist der erste Schritt eines Jobs, den YAML stumm verschlucken kann; `contract:axis-version-lock` misst gegen eine Lock-Datei aus demselben Commit. Einzige Wache des Projekts mit abgelegtem Biss-Beweis: `ci_diff_ascii_width_guard.bissbeweis.txt`. Beleg: Checkheft R-13 (`:2366-2376`).
- **Sollwert-Pinning zementiert**: die neue Wache pinnt 1536/768/384/192 als Soll, während der Verbraucher die alte Einheit rechnet; H1/H2 waren nur durch Bestands-Gates gedeckt, die auch vor dem Fix grün waren. Beleg: Review-Meldung („genau die ‚grüne Tests zementieren alte Ordnung'-Falle").
- **Das m3v2-Fenster** (Klasse 2): ein Test, der auf AMD durch Syscall-Rauschen besteht, hat nie bewiesen, dass er messen kann.

### 3.9 Klasse 9 — Die Korrektur erbt den Fehler

Widerrufe, Heilungen, Migrationen und Entlastungen sind selbst Behauptungen und tragen dieselbe Beweislast — die Korrektur eines Befunds kann exakt in die Klasse fallen, die sie beseitigt. Acht Fälle im Material; die beiden schwersten stehen ausführlich in Abschnitt 5.

- **Der A-7-Widerruf** (Abschnitt 5.1): importierte A-8-Belege, überschärfte „NULL Mal", ließ einen zweiten Produktions-Writer unerwähnt.
- **Der bestätigte CEB-Widerruf** (Abschnitt 5.2): trug einen unbelegten Anhang und eine Pauschale mit Gegenregression-Potenzial.
- **Die ugrep-/GNU-grep-Doppeldiagnose**: erst „/usr/bin/grep ist ugrep", dann „auf einem Host mit echtem GNU grep ist das Verfahren sicher" — beides falsch; kaputt war die mittlere Filterstufe auf beiden Engines aus zwei verschiedenen Gründen. Beleg: uuid `f96b441f`, 06.08. 16:11/16:19 („dabei beide bisherigen Diagnosen widerlegt, meine eingeschlossen"). Entlastung: kein CI-Ergebnis war durch die Falle falsch grün.
- **Die xmllint-Migration** galt als strukturelle Heilung von sechs Befunden — `2c631551` fand elf neue False-Green-Pfade in der Migration selbst; Zusatzregel: „eine Regex-Ersetzung darf keine Regex-Insel hinterlassen" (L3824). Beleg: Checkheft R-14 (`:2382-2388`).
- **Die NB3-Heilung traf neben die Wunde**: `cache_lines_touched` wurde an die Achse gebunden, der einzige aktive Konsument rechnet weiter mit dem Literal 64 im Nenner (Kette `observable:142` → `abi_adapter.hpp:1476` → `system_axis.hpp:336`); unter KF-6 ergäbe das 8/16/33/66 % statt ~16.
- **Der resource_group-Fix war schlimmer als der Fehler** (Klasse 6, waiting_for_resource-Fall) — eine Korrektur, deren Wirkung nie gemessen wurde.
- **Zwei Überkorrektur-Alarme**: nach der Lehre, Entlastungen zu misstrauen, wurde derselbe Fehler in die Gegenrichtung gemacht — zweimal blind gemessen und daraus ein Alarm gebaut, der schärfer war als die Faktenlage. Beleg: Memory KLASSE 6 (`:56-87`): „ich uebernehme das Ergebnis eines Verfahrens, ohne das Verfahren zu pruefen — egal ob es ein fremder Bericht oder mein eigener grep ist."
- **V-03-Entlastung breiter als ihr Beleg**: „nur un-included Dateien" war wörtlich falsch — 26 von 92 Fundstellen stehen in eingebundenen Dateien, darunter zwei Anhänge (`anhang/{de,en}/A_measurements.tex:27,146,147`; `D_building_block_matrix.tex:792,1203`), an der `.fls` des echten Laufs geprüft. Die Sachaussage „kein Abgabe-Defekt" hielt — aber nur, weil jede Stelle als historisch markiert ist. Beleg: Ledger-Abschnitt D).

### 3.10 Klasse 10 — Der Abruf-Fehler (dokumentiert, quittiert, nicht angewendet)

Das Wissen existiert — im Memory, im Fallen-Register, in wiederholten Owner-Worten — und wird im Moment der Arbeit nicht abgerufen. Die Quittung ersetzt den Einbau nicht; die Wiederholung durch den Owner ist selbst das Warnsignal. Sechs Fälle im Material.

- **Talos als „nur CI-Infrastruktur" eingeordnet** und Rollentrennung empfohlen — das Memory belegte wörtlich das Gegenteil. Owner: „Du liegst kritisch Falsch mit deinem Punkt, bitte lies memory." Lead: „Mein Fehler war nicht der Explore, sondern der übersprungene Schritt davor." Beleg: uuid `47511c17`, 08.08. 13:21.
- **CSV statt xlsx**: der Owner hatte siebenmal gesagt, dass CSV nicht verwendet wird; der Lead quittierte jedes Mal und untersuchte trotzdem eine Stunde lang `result.csv`. Beleg: uuid `ccf53bb1`, 08.08. 13:31; L19083 (Task #65); Memory `feedback_xlsx_ist_die_ausgabe_csv_nie_skip_bei_gleicher_binary`.
- **`grep -v '/build'` frisst `/builder/` — dreimal in einer Sitzung**, obwohl die Falle seit Wochen im eigenen Memory stand; dort lag die gesamte reale `sched_setaffinity`-Implementierung. Beleg: Memory KLASSE 6 Punkt 1 (`:72-75`); Task #25 Punkt (3).
- **ASCII-/gitleaks-Fallen erneut betreten**: „die Falle steht in meinem eigenen Register" (uuid `eaa6bf75`) — beide Fallen (rc-nach-Pipe, Locale) waren dokumentiert.
- **pgrep-Selbstmatch „(erneut)"** — bereits L466, wieder L17377.
- **Explore für Dokumentiertes** — Owner-KERN 08.08.: strikt Gedächtnis → Review → Explore → Design → Bauen → Verify; führende Fassung im Repo: super `docs/ARBEITSWEISE-GESAMT-DOKTRIN.md` v3. Beleg: L18955/L19161.

### 3.11 Klasse 11 — Fremde Arbeit im toten Winkel (Zwei-Schreiber-Klasse)

Der Schaden entsteht beim Schreiben, nicht beim Lesen: `--force`, `checkout`, `reset --hard`, `add -A` und Ignoriermuster vernichten oder verschlucken fremde bzw. unfertige Arbeit ohne Diff, ohne Warnung, ohne Exitcode. Sechs geprüfte Fälle im Material, plus ein ungeprüfter Kandidat.

- **`git worktree remove --force` vernichtete 1104 Zeilen ungetrackte Arbeit** eines am Spend-Limit gestorbenen Agenten; aus dem Agenten-Transkript geborgen. Beleg: Lead-Fehlerbilanz Punkt 5; README der Sicherung.
- **Ein `git checkout` löschte eine uncommittete README**; zwei Bisse liefen danach gegen die alte Fassung und sahen fälschlich nach Erfolg aus.
- **`git add -A docs/` veröffentlichte 17 Dateien** mit halbfertigen Stale-Vermerken des parallel arbeitenden Agenten auf origin/development; aufgefallen erst am Diff mit 35 Löschzeilen. Beleg: Memory KLASSE 8 (`:113-139`).
- **Zwei Schreiber auf einem Gegenstand**: beide Hauptklone standen auf Arbeitszweigen, der super-lokale `main` 406 Commits hinter `origin/main`; zweimal wurde in den Arbeitsbranch einer laufenden Welle committet. Beleg: Checkheft VII.5 Gestalt 3 (`:2318-2324`); K-10 (`:1744`).
- **Die Ablage verschluckt ihren eigenen Beleg**: `git add <ignorierte Datei>` schweigt — 78 von 155 Gate-Logs unter `docs/sessions/backups/` liegen in keinem git-Objekt (`*.log`); 25 von 66 Dateien in `Code/measure_out_d03/` sind ignoriert, darunter `measurements.csv` (`*.csv` in super/.gitignore:39). `git clean -fdx` hätte Rohmessdaten vernichtet. Beleg: Checkheft R-17 (`:2414-2424`), eigene Zählung mit `git ls-files`/`git check-ignore`.
- **Spend-Limit-Abriss verhält sich wie Session-Fork**: Commits überleben, Berichte nicht — ein Bau-Agent starb nach Commit `953ce412`, vor der Ergebnis-Meldung. Beleg: L2067.
- *Ungeprüfter Kandidat derselben Klasse*: SF-1-Commit „sauber", aber die Vor-Push-Wache fand zwei reale Verstöße, „die vor dem Committen der NEUEN Dateien unsichtbar waren — git diff sieht untracked Dateien nicht" (ce `b000ccc6`; Abschnitt 6.1).

### 3.12 Einzelfälle (keine Klasse, je ein Vorfall)

- **Mehrdeutiges Owner-Wort verbaut**: K1–K5 im HW-Erkennungs-Plan mussten zurückgerollt werden. Owner 2026-07-27T17:23: „Deine Interpretation meiner Nachricht davor war falsch, bitte K1 bis K5 in 20260727-PLAN-hw-erkennung-zwei-ebenen-factory-stempel.md zurückrollen." Lehre: Lesart vor dem Bauen zurückspiegeln.
- **Duale Achsen einseitig reduziert**: Opus machte NUMA/page_type zu reinen RT-Unter-Achsen und vergaß AVX512; korrekt sind 12 System-Perms = O0–O3 × {no_extension, avx2, avx512}. Owner-Korrektur; verankert: „kein Bau vor fertiger Planung." (Alt-Raum.)
- **Wortwahl als Betriebsrisiko**: „294 Repos migriert" beschrieb eine unangetastete Struktur und löste einen Owner-Notfall aus („Oh gott nein, falsch, zurück"); Auflösung nach Beweisführung: „die wortwahl war es wohl", Verständnis „absolut korrekt". (Alt-Raum.)
- **These trotz Gegenmittel**: H16/H17 zum Runner-Poll-Freeze — Freeze trotz `GODEBUG=http2client=0` (literal in `/proc/PID/environ`), 18.9.0 friert identisch (erster Start-Poll 17:59:21, danach nie wieder) ⇒ die Wurzel liegt serverseitig. Eine These, die ihr Gegenmittel überlebt, ist widerlegt — nicht „noch nicht genug angewendet". (Alt-Raum.)
- **Technisch korrekt, dennoch kein Defekt**: `axis_binding(std::size_t)` ohne Bounds-Check — Verify-Verdikt „FALSE POSITIVE (adversarial verdict)": realer Aufrufraum nur 0 und 8 (`axis_binding_registry.hpp:134-136`). (Alt-Raum.)
- **Fork-Rahmung über tote Kandidaten**: Dossier 16 rahmte „V32 aktivieren vs. `comdare_experiment` erweitern" — beide Optionen waren tot (`comdare_experiment` von nichts konsumiert; `v32_orchestrator.hpp` nie in `main.cpp` inkludiert, `execute_messreihe:81-85` Stub, `COMDARE_V32_ENABLE` No-Op fürs Driver-Binary). (Alt-Raum.)
- **„Fertig"-Signale ohne Erreichbarkeit**: Gate 8 lag auf beiden Remotes mit eigenem grünem CI-Lauf und war in keinem Zweig; 20+ nicht erreichbare rescue-Refs im ce gezählt. Nur `merge-base --is-ancestor <commit> origin/<zweig>` beantwortet die Frage. Beleg: Checkheft R-9 (`:339-351`), Ledger `:4289-4291`.

---

## 4. Die Learnings

99 dokumentierte Lehren nach Geltungsbereich. Format: **Regel** — Anlass; Beleg. Doppelungen zwischen den beiden Neu-Extraktionsläufen sind zusammengeführt und gekennzeichnet.

### 4.1 Werkzeug (18)

Der rote Faden: das Werkzeug tut exakt, was gesagt wurde — nur war das Gesagte nicht das Gemeinte. Engines unterscheiden sich still (ugrep/GNU, BRE/PCRE, bfs/find), Pipes verschlucken Fehler der Mittelglieder, und Muster ohne Positivkontrolle beweisen nichts.

- **W-1 Bei rotem Roundtrip-/Reflexions-Test zuerst das Alter des Generator-Binaries gegen die Quellen prüfen (`stat -c '%y'`); eigene Änderungen wegstashen und neu messen, bevor eine Regression behauptet wird.** — Stale Binary im warmen `build/` erzeugte falsches ROT mit irreführendem Diff; nach Neubau 421/421. Beleg: Ledger-Nachtrag; Fallen-Register (Gegenstück zu `reference_lokale_vollbau_luecken_falsches_gruen`).
- **W-2 Zwei Diagnosen derselben Falle können beide zu kurz greifen; adversarisch prüfen heißt auch: kann der Widerruf falsch sein?** — ugrep-Fall, beide Diagnosen gefallen. Beleg: uuid `f96b441f`.
- **W-3 Ein Suchmuster mit null Treffern ist zuerst ein Verdacht gegen das Muster; Positivkontrolle fahren.** — Vier Fälle (GR1348941/390 Token; PDF-Ersatztext; 13/19 vs 17/32; 0 vs 8 VERSALIEN). Beleg: uuids `49ab5f39`, `8b779ccd`.
- **W-4 `rc=$?` nach einer Pipe misst das letzte Glied; ohne Pipe messen (erst in Datei) oder PIPESTATUS.** — gitleaks maß `tail`; cf22 lief nicht und meldete 0. Belege: Memory K11 (`:174-176`); Lead-Text „false positive durch die Pipe" (Alt-Raum). *(Zusammenführung dreier Einträge.)*
- **W-5 Pfad-Ausschlüsse immer `/build/` mit beiden Schrägstrichen — `grep -v '/build'` und `find -not -path '*/build*'` fressen `builder/`.** — Dreimal in einer Sitzung trotz Register. Beleg: Memory KLASSE 6 Punkt 1; Task #25 (3). *(Zusammenführung zweier Einträge.)*
- **W-6 Locale-Artefakte erzeugen Phantom-Verstöße: `LC_ALL=C` setzen und mit `od -c` gegenprüfen.** — 1133 gemeldete, 0 reale Bytes. Beleg: uuid `eaa6bf75`.
- **W-7 `/usr/bin/grep` ist auf prod1 ugrep; `grep -P` bricht dort ab und die Pipe liefert eine stille 0.** — Rückwirkend falsches Grün aller so gemessenen ASCII-Gates; Zahlen byteweise in Python neu erhoben. Beleg: L4181/L4206.
- **W-8 `\+` ist in GNU-BRE „ein-oder-mehr", kein literales Plus; derselbe Regex spricht auf zwei Engines zwei Sprachen.** — `grep -v '^\+\+\+'` wirft auch `+abc` raus; Live-Reproduktion über x/+/++/+++/+abc/abc: GNU behält genau `x` und `abc`. Beleg: Checkheft SW-4 (`:591-593`).
- **W-9 Eine Pipe, deren mittlere Stufe scheitern kann, trägt den Fehler nicht im Gesamt-Exit; `set -o pipefail` rettet nicht (letzte Stufe endet bei leerer Eingabe selbst mit 1). Jede Stufe einzeln prüfen; fehlendes Werkzeug = FATAL statt stiller Null.** — Der Selbstcheck war eine handgetippte Kette; Heilung: awk-Zustandsmaschine, byteweise ASCII-Erkennung. Beleg: Checkheft SW-4 (`:595`).
- **W-10 Der Köder muss erst beißen: Gegenprobe zählt erst, wenn der eingebaute Fehler nachweislich gemeldet wird; Reihenfolge Köder→Werkzeug, dann Köder→Wache; Köder immer zufällig erzeugen, nie aus Doku abschreiben.** — Dreimal untauglich am 07.08., AWS-Beispiele allowgelistet am 08.08.; mit Zufallsschlüsseln sofort rc=1. Beleg: Memory K13 (`:180-191`).
- **W-11 gitleaks vor dem Push über den exakten Bereich `origin/<branch>..HEAD`, nie mit geratener `--depth`; im stdin-Modus ist `--config` Pflicht.** — Lead: „Das ist Glueck, keine Methode. Die Tiefe raten ist falsch, den Bereich nehmen ist richtig"; fehlendes `--config` erzeugte Fehlalarm auf einen C++-Testnamen. Beleg: Memory `feedback_gitleaks…:11-30`; L4858.
- **W-12 Ein Worktree im gitleaks-Container liefert „0 commits scanned / no leaks found" mit Exit 0; die Zeile „N commits scanned" immer mitlesen.** — Erstlauf über `wt-b1-e18`. Beleg: L168; Memory gitleaks `:31-32`.
- **W-13 Ein Skript bestimmt sein Repo aus dem cwd des Aufrufers (`git rev-parse --show-toplevel`), den Selbst-Ort nur als Fallback; für Worktrees `--stdin` füttern.** — N-1-Fall, 12578 statt 1450 Zeilen. Beleg: Checkheft N-1 (`:379-391`).
- **W-14 Den Vault nie greppen, auch nicht „maskiert"; nur blind per `mapfile`, Selektion über Länge, PAT-Kandidaten rückwärts gegen `/api/v4/user` testen.** — Maskiertes grep gab `samba-comdare-socks-pw` im Klartext aus; gilt als kompromittiert, steht in der Rotationsliste. Beleg: L16651; Memory `reference_vault_dateien_nie_greppen_nur_blind_verarbeiten`.
- **W-15 `find` ist auf prod1 `bfs` (nur ISO-Timestamps bei `-newermt`); `pgrep` matcht die eigene Kommandozeile.** — Falscher Stille-Alarm; falsche Fremdprozess-Warnung. Belege: L231; L466, L17377.
- **W-16 Wach-Regexe an Abbruchbereich und eindeutigen Signaturen ankern, nicht an Allerweltswörtern.** — CiCheck288b/13442-Fall; Fix gegen 4 echte Traces getestet. (Alt-Raum.)
- **W-17 Für Existenz-/Gate-Nachweise Einzeldatei- oder Glob-Grep mit explizitem Pfad; ein Null-Ergebnis aus `grep -r --include` ist kein Beweis.** — `perm_runner.hpp` stumm übersprungen, Ur-Irrtum B3-2. (Alt-Raum.)
- **W-18 Vor jeder zeilenübergreifenden Suche im CI-Trace das Runner-Präfix (ISO-Zeitstempel + Stream-Marker) entfernen und Whitespace normalisieren — sonst rutscht der Zeitstempel der Folgezeile in die Extraktion und die Wache liefert einen Datumsschnipsel statt der Zahl.** — Anlass im übergebenen Material abgeschnitten; Geltungsbereich-Feld ebenfalls (hier unter Werkzeug geführt).

### 4.2 Messung (12)

Der rote Faden: eine Zahl ist erst eine Messung, wenn Nenner, Fenster, Quelle und Bau-Zustand benannt sind — und wenn das Ausbleiben eines Werts vom Wert 0 unterscheidbar ist.

- **M-1 Ein Alarm ist genauso begründungspflichtig wie eine Entlastung; beide brauchen einen Objektbeleg.** — V-08 „keine PMC-Quelle" hätte eine korrekte Thesis-Aussage durch eine falsche ersetzt. Beleg: Lead-Fehlerbilanz Punkt 4; `linux_perf_pmc_source.hpp:191-194` (zitiert).
- **M-2 PMU-Typ immer aus sysfs lesen, nie raten: der Kernel weist einen nicht existenten PMU-Typ nicht ab, sondern fällt still auf einen anderen zurück und liefert Zahlen; fehlt der sysfs-Pfad, wird die Domäne übersprungen statt geöffnet.** — Sonde `(9999<<32)|L1D` öffnete und lieferte wert=1. Beleg: Agent-Bericht B-5; Landung ce `5e163331` (errno-Klassen + PMU-Mechanismus + Uncore-Spalte, 429/429).
- **M-3 Testzahlen nie ohne Nenner weitergeben** — „432" statt „428 mit `-LE pmc`" ist eine Halbwahrheit, die als Fakt weiterwandert. Beleg: Lead-Fehlerbilanz; Prüfbericht zu 406/406@`3133f226`.
- **M-4 Keine Null ohne Nenner: belastbar ist „1448 Zusatzzeilen geprüft, davon 0 Nicht-ASCII, davon 2 über 120 Spalten", nicht „ASCII: 0".** — Bau-Agent meldete 0 über den eigenen Commit; der Gegenprüfer fand 9 Verstöße in 5 anderen Dateien der Gesamtserie; gitleaks-Serie (Klasse 2). Heilung im Werkzeug: `ce/scripts/ci_diff_ascii_width_guard.sh` druckt den Block `NENNER (nie eine nackte Null):`, die Diff-Hygiene-Wache nennt übersprungene Dateien namentlich. Belege: Checkheft R-1; Transkript-Serie 06.–08.08. *(Zusammenführung zweier Einträge.)*
- **M-5 Keine Ursache ohne Messung: eine Fehlermeldung druckt den gemessenen Wert oder den Satz „Ursache nicht erhoben" — nie eine Aufzählung möglicher Ursachen.** — R-11-Fall mit drei Fehldiagnosen und Beinahe-Cluster-Änderung; Heilung `linux_perf_pmc_source.hpp:116-121` sichert errno sofort und druckt `[PMC-DIAG]` mit event/type/config/errno/strerror. Beleg: Checkheft R-11 (`:2342-2352`).
- **M-6 Ein Testfenster muss auf allen Vendoren deutlich über der Rauschgrenze liegen; Rauschgrenze ist kein Bestehen, ein leeres Fenster ist von einer funktionierenden Messung ununterscheidbar.** — AMD 34–53 Misses (Syscall-Overhead) bestand, Intel 0 fiel. Vorbild: `linux_perf_pmc_smoke`, 32 MiB Pointer-Chasing, `kN = 1u << 22`. Beleg: Task #26.
- **M-7 Zur Testzahl gehört der Bau-Zustand: ctest zählt, was CMake zur Configure-Zeit sah; 2-Pass-Pflicht heißt configure → BAU → configure.** — 404 statt 408; genau vier Tests hängen an mindestens vier Configure-Bedingungen (`CMakeLists.txt:1544/:1565/:1082/:1188`). Beleg: L2761; Checkheft R-5.
- **M-8 Lokale Zählungen sind keine Pipeline-Aussagen; eine Mengendifferenz in beide Richtungen prüfen.** — Lokal 331, Pipeline 411: der lokale Baum war teilkonfiguriert. Beleg: Checkheft R-5 (`:287`).
- **M-9 Vor jeder Befundmeldung prüfen, ob das eigene Messverfahren den Befund erzeugt haben könnte — besonders bei Nullen; eine Null ist erst ein Befund, wenn die Gegenprobe zeigt, dass das Verfahren überhaupt findet.** — Vier KLASSE-4-Fälle. Beleg: Memory KLASSE 4 (`:39-46`).
- **M-10 Ein Grep-Treffer im CI-Trace ist kein Verarbeitungs-Nachweis: Commit-Titel im `get_sources`-Block und Submodul-Diff-Stats treffen in fast jedem Job; Klartextstelle lesen.** — CiCheck288f-Beinahe („9 von 13 Jobs"). Beleg: ZWISCHENMELDUNG 13623. (Alt-Raum.)
- **M-11 Fremdbehauptete Heilungszustände (auch vom Owner) mit einem echten Lauf verifizieren, nicht mit einer Statuszeile.** — „prod2 stabil": Lauf 9100 zeigte 345-s-Hänger, während contract/sanitize/pmc:amd auf prod1 grün liefen. (Alt-Raum.)
- **M-12 Relative Deltas nicht durch Vorzeichen-Invertierung umkehren — der Nenner wechselt mit; exakte Abbildung d' = −d/(1+d).** — Am d03-Korpus gegengeprüft: 1.2556/1.0769/1.3765 → −0.5567/−0.5185/−0.5792. Beleg: Nichtfund-Protokoll (Beifang, dort als einziger echter Rechenfehler-Fund geführt).

### 4.3 Architektur (11)

Der rote Faden: Aussagen über Struktur (tot, verdrahtet, geheilt, identisch) verlangen die Analyse des ganzen Graphen — Build-Graph, Aufrufraum, Konsumkette, Preimage — nicht eines Ausschnitts.

- **A-1 Repo-Kommentare sind Behauptungen, keine Belege; wer einen Kommentar liest statt den Code, entlastet fälschlich.** — PmcCounters-/`.gitmodules`-Fälle. Belege: Task #8 (ce `6a8ab995`), Task #55 (super `f507a9af`).
- **A-2 Stiller Rückfall ist verboten: jede Ausweich-Stelle ohne Anzeige ist ein Defekt der Schwere ERROR — der Aufrufer kann sonst nicht unterscheiden, ob ein Wert gemessen oder geraten ist.** — Owner-KERN 06.08. abends, L3-Zähler-Fall; Owner verbatim (L7524/L7718): „Stiller Rueckfall geht fuer uns nicht: Regressionen oder Fehler gehoeren angezeigt, das ist ein weiterer Fall fuer das Anzeigen von error."
- **A-3 Bei generierten Artefakten beweist Abwesenheit im Quell-Repo nichts; erste Rückfrage: eingecheckt oder emittiert?** — COMDARE_BESTANDSLOG-Fall. Beleg: Checkheft R-4 (`:264`).
- **A-4 Eine Migration erbt die Fehlerklasse, die sie beseitigt: jede Aufrufstelle des neuen Werkzeugs einzeln gegen dieselbe Klasse beißen; keine Regex-Insel hinterlassen.** — xmllint-Fall, elf neue Pfade. Beleg: Checkheft R-14; `2c631551`; L3824.
- **A-5 Wer eine Größe an der Quelle korrigiert, zieht die Kette bis zum Verbraucher mit — sonst erzeugt die Heilung anderswo eine neue Falschmessung.** — NB3/Literal-64-Fall. Beleg: `system_axis.hpp:336`; Kette bis `abi_adapter.hpp:1476`.
- **A-6 Grüne Tests zementieren die alte Ordnung — auch umgekehrt: eine Wache, die neue Sollwerte pinnt, macht die neue Einheit „richtig", ohne den widersprechenden Konsumenten mitzuziehen.** — H1/H2-Fall. Beleg: Review-Meldung.
- **A-7 Ein Identitäts-Stempel ist nur so gut wie die Menge seiner Eingänge: welche Größen verändern die Binary, welche stehen im Preimage? Die Differenz ist die Liste der stillen Falsch-Skips.** — `COMDARE_MEASUREMENT_ON` schaltet über `abi_adapter.hpp:393` die Interface-Vererbung (30 Vorkommen), steht aber in 0 Dateien des abi/-Preimage-Baums; die Preimage-Ordnung (`anatomy_fingerprint.hpp:426-438`) führt 8 Glieder, keines ist die Mess-Schaltung. Beleg: Checkheft R-15 (`:2390-2400`).
- **A-8 „0 Konsumenten" ist kein Tot-Beweis: bei Pflicht-Features heißt es „unverdrahtet/unfertig", und der Build-Graph kann einen Header kompilieren, den kein Symbol-Grep findet.** — Deprecation revertiert (ce `804aa3c2`); Owner-Zitat. (Alt-Raum.)
- **A-9 Vor der Rahmung einer Entscheidung prüfen, ob die Kandidaten überhaupt leben — beide können tot sein.** — Dossier-16-Fall. (Alt-Raum.)
- **A-10 Achsen sind oft dual (RT-Unter-Achse an der CEB und CT-Haupt-Achse am Tier-Binary); eine Reduktion auf eine Seite ist ein Architekturfehler, kein Vereinfachungsgewinn.** — NUMA/page_type/AVX512-Fall; korrekt 12 System-Perms. (Alt-Raum.)
- **A-11 Ein Befund an einem nie inkludierten Header kann nicht mit „bricht den Build" begründet werden — nie inkludiert heißt nie kompiliert.** — abi_v1_to_v2_mapper-Fall. (Alt-Raum.)

### 4.4 Prozess (34)

Der rote Faden: zwischen Wissen und Handeln liegen Übergabepunkte — Berichte, Listen, Formulierungen, Sessions — und an jedem kann sich die Aussage vom Objekt lösen. Die Regeln binden sie wieder an.

**Berichte und Prämissen.**

- **P-1 Die gefährlichste Fehlerklasse ist die korrekte Messung über den falschen Gegenstand: sie erzeugt kein Fehlersignal, sondern eine belastbare Zahl, ein grünes Gate und ein reines Gewissen — eine falsche Messung fällt irgendwann auf, diese nie.** — Alle Regressionen der Session hatten diese Gestalt; am selben Tag dreifach bestätigt (Task #25). Belege: Checkheft `:180-184`; Ledger `:4705-4707`. *(Zusammenführung zweier Einträge.)*
- **P-2 Ein Bericht ist Beweismaterial, kein Beweis: jede Zahl, SHA und Zustandsaussage daraus vor Weitergabe selbst messen oder ausdrücklich als ungeprüft kennzeichnen.** — Lead-KLASSE-1-Bündel. Beleg: Memory (originSessionId `5a19728e…`).
- **P-3 Ein Befund „X ist nicht verdrahtet" ist ein Nullbefund und wird erst zur Aussage mit der Gegenfrage: wer inkludiert, linkt, ruft X?** — Limits-Entkopplung; Task #40.
- **P-4 Auftragsprämissen des Leads sind prüfpflichtig — ein Agent, der dem Objekt statt dem Auftrag glaubt, ist wertvoller als einer, der liefert.** — Fünf-Prämissen-Bilanz; Task #41.
- **P-5 Parameter in Aufträgen sind Behauptungen: die Basis benennen, nicht beziffern („rechne die merge-base selbst"); eine zurückgemeldete vorgegebene Zahl ist ein Echo, keine Bestätigung.** — 5060489e-Fall; zweiter Vertreter `16a173f2` statt merge-base `c837d830`. Beleg: Memory KLASSE 9.
- **P-6 Kartierungs-Behauptungen nie ungeprüft in verbindliche Auflagen übernehmen; Agent-STOPPs ernst nehmen.** — Re-Anchor-Fall. (Alt-Raum.)
- **P-7 Interpretieren ist kein Messen: wer einen Zustand sieht und deutet, hat nicht gemessen — API/Trace/Objekt abfragen.** — resource_group-Fall (V11-Figur).
- **P-8 Der schärfere Befund ist nicht der ehrlichere — ehrlich ist der belegte; ein Nullbefund ohne Gegenprobe ist kein Befund, ein Alarm so begründungspflichtig wie eine Entlastung.** — Zwei Überkorrektur-Alarme. Beleg: Memory KLASSE 6.
- **P-9 Eine Entlastung darf nicht breiter formuliert werden als ihr Beleg — die Kurzformel überlebt, der Vorbehalt nicht.** — V-03-Fall (26 von 92).
- **P-10 Eine These, die trotz ihres Gegenmittels weiterbesteht, ist widerlegt — nicht „noch nicht genug angewendet".** — H17/H18. (Alt-Raum.)
- **P-11 Absolute Aussagen sind das Warnsignal für Raten; statt sie zu setzen: ultracode-Workflow, der belegt oder widerlegt.** — K84 „genau 2 Brücken", User-Widerlegung. (Alt-Raum.)
- **P-12 Ein technisch korrekter Befund ist ohne Aufrufraum-Analyse kein Defekt: welche Werte erreichen die Stelle real?** — axis_binding-Fall (0 und 8). (Alt-Raum.)

**Dokumente, Listen, Zeit.**

- **P-13 Eine Liste altert, während gearbeitet wird; sie wird gegen das Objekt nachgemessen, nicht fortgeschrieben.** — Board 5/10; §75 104/133; Ledger-Audit 43/43.
- **P-14 Stale Plandokumente sind aktive Fehlerquellen: deprecaten mit Ist-Tabelle statt löschen.** — Dossier-17-Fall.
- **P-15 Ledger-/Plan-Peripherie verrottet schneller als der Kern; vor jeder „noch offen"-Aussage die Auflösungsstelle suchen.** — §14.1-Fall. (Alt-Raum.)
- **P-16 Ein Pausen-Nachtrag ist ein Snapshot; „AUSSTEHEND" nur gegen `git log`, nicht gegen den eigenen Nachtrag.** — 08076dd2-Fall. (Alt-Raum.)
- **P-17 Synthese-Berichte tragen den Wissensstand ihres Startzeitpunkts; Befunde daraus gegen den jüngsten Ledger-Nachtrag prüfen, bevor sie zur Handlung werden.** — Achsenzahl-Fall (L3664).
- **P-18 Ein Paketschnitt, der nur in einem Session-Dokument steht, existiert für die Ausführung nicht; jede Konsolidierung, die eine Quellenklasse auslässt, weist das in ihrer Methodik aus.** — LB-0..LB-6-Fall (R-10).
- **P-19 Eine Konsolidierung darf ihr Zeitfenster nicht als Grenze setzen, ohne den letzten VOLL-Block davor als Eingang mitzunehmen.** — Die Warnzeile fiel als einzige ihres Absatzes aus der Übertragung. Beleg: L3522 (mittag-17, „Dauer-Regel-Kandidat").
- **P-20 Beleg-Form: Datei:Zeile + Suchbegriff + Zweigkopf + Uhrzeit, bei Zahlen die Zählmethode — reines `Datei:Zeile` altert.** — Fünffache Zeilendrift; Verschärfung N-T: ein Kommentar mit eigenem Messkommando altert schneller als die Messung. Beleg: Checkheft R-18/K-8, N-2.
- **P-21 Eine Zusage über eine Anzahl ist eine Vollständigkeitsaussage: durch die Liste ersetzen — eine Liste altert sichtbar, eine Zahl nicht.** — „Der EINE literale Pin" wurde zu vier; „MEINE 16 Arbeitsfehler" bei 15 Bullets. Beleg: Checkheft R-19; ce `4b38d072`.
- **P-22 Ein Code-Kommentar belegt den Code, nie die Absicht; Doktrin aus Ledger/Session-Log belegen; bedingte Sperren nie ohne ihre Bedingung zitieren.** — R-20-Fall.
- **P-23 Ein Commit darf einer laufenden Verifikation nicht vorgreifen: läuft eine Prüfung, gehört der Vorbehalt in denselben Absatz wie die Behauptung.** — Kontextübergabe vor Verifikation gepusht, Prüfung widerlegte sie; „ein Satz im Chat ist fluechtig, ein gepushtes Dokument wird der Anker der naechsten Session." Beleg: Memory KLASSE 7 (`:89-111`).
- **P-24 Vollständigkeitsaussagen („niemand liest/braucht X") tragen die volle Beweislast: drei Quellen — Code (Aufrufer und deren Aufrufer, libs/ UND tests/ UND Fassade), Tests, Planung.** — Kosten-Klammer-Fall. Beleg: L4052; Checkheft R-3.
- **P-25 Wortwahl in Statusmeldungen ist ein Betriebsrisiko: Meldungen daran messen, was ein Leser daraus schließt.** — „294 Repos migriert". (Alt-Raum.)
- **P-26 Bei mehrdeutigem Owner-Wort die Lesart vor dem Bauen zurückspiegeln — eine Fehlinterpretation kostet einen Rückroll-Pass.** — K1–K5-Fall. (Alt-Raum.)

**Arbeitsfolge, Gedächtnis, Sessions.**

- **P-27 GEDÄCHTNIS ZUERST: strikt Gedächtnis → Review → Explore → Design → Bauen → Verify; ein Explore für Dokumentiertes ist ein Arbeitsfehler; vor jedem Explore beantworten: „Wo habe ich schon nachgesehen, und was stand dort nicht?"** — Talos-Fall; Owner-KERN 08.08.; führende Fassung super `docs/ARBEITSWEISE-GESAMT-DOKTRIN.md` v3. *(Zusammenführung zweier Einträge.)*
- **P-28 Wird eine Aussage wiederholt, ist sie quittiert, aber nicht eingebaut — die Wiederholung ist das Warnsignal; nicht erneut quittieren, sondern prüfen, wo der Arbeitsgegenstand abweicht.** — CSV-7×-Fall (Task #65). *(Zusammenführung zweier Einträge.)*
- **P-29 Jeder Prüfauftrag wird ausdrücklich adversarisch formuliert („widerlege es") — die wertvollsten Befunde entstehen, wenn Prüfer ihre eigenen früheren Aussagen widerlegen.** — TSan-Prüfer stellte die falsche Frage fest; Review-Wertung selbst revidiert. Belege: uuids `b491485e`, `b47d5590`.
- **P-30 Zwei Schreiber auf einem Gegenstand sind eine eigene Fehlerklasse; einzige Gegenmaßnahme ist der Lebend-Check vor dem Schreiben.** — VII.5 Gestalt 3; 406-Commits-Rückstand.
- **P-31 Ein Spend-Limit-Abriss verhält sich wie ein Session-Fork: Commits überleben, Berichte nicht; Wiederanlauf über den Objekt-Ist (Ledger-Volltext + Objekt-Ist + Lebend-Check), nie blind resumen.** — 953ce412-Fall (L2067).
- **P-32 Selbst-entschärfte Beinahe-Fehlbefunde sofort als benannte Falle ins Gedächtnis — sonst tritt der nächste Agent in dieselbe Grube.** — Fallen (p) und (q) verankert. (Alt-Raum.)
- **P-33 Der erweiterte Merksatz: GRÜN ist keine Aussage über den Prüfbereich — und KEIN Grün ist eine Aussage über Zeitpunkt, Prüfer und Gelegenheit zu beißen.** — Drei Gestalten im Nachtrag; „Bei allen drei neuen Gestalten gibt es nichts, was sich nachtraeglich pruefen liesse." Beleg: Checkheft VII.5 (`:2294-2334`).
- **P-34 Disziplin trägt gegen diese Fehlerklassen nicht — Regeln gehören ins Werkzeug, nicht in die Prozedur.** — Sieben der ersten zehn Regeln sind werkzeugverankert; die drei rein disziplinären (R-3, R-6, R-10) sind genau die, die zurückkamen — „alle drei durch Werkzeuge, nicht durch Handgriffe." Beleg: Checkheft I.4 (`:445-447`), II.7 (`:651`).

### 4.5 CI (13)

Der rote Faden: der Gesamtstatus einer Pipeline ist eine Verdichtung, die genau die entscheidende Information wegwirft — welcher Job mit welchem Umfang wann lief und welcher nicht.

- **C-1 Ein grünes Pipeline-Ergebnis ist erst Beleg, wenn der betreffende Job nachweislich lief; Job-Status einzeln nachzählen.** — 15314-Fall (3 statt 14 Jobs); Wiederholungsfrage zu 15357.
- **C-2 Wachen müssen die richtige Größe vergleichen und im selben Lauf belegen, dass ihr Prüfmakro anschlägt.** — Submodul-Wache; blinde Bissprobe (BOOST_MP11-Härtung).
- **C-3 Ninja/CMake überspringen Targets stumm: „Voll-Bau" heißt erzwungener Neubau plus kalter 2-Pass-Configure, sonst ist die Testzahl falsch.** — 404/408-Fall („der erste Durchlauf war falsches Grün").
- **C-4 Ein grünes Gate deckt nur seinen eigenen Gegenstand; eine Freigabe zählt nicht die gelaufenen Gates auf, sondern die NICHT gelaufenen.** — Diff-Hygiene dreimal grün, während `lint:format` 94 Verstöße in 13 Dateien fand; unabhängig bestätigt im zweiten Repo (super `b35aea1b`). Beleg: Checkheft R-6.
- **C-5 Ein Gate-Umfang ist repo-spezifisch: Dateilisten und Zahlen nie über eine Repo-Grenze tragen.** — Derselbe Job: ce 1731 verfolgte C/C++-Dateien, super 59 (~29:1; ce `.gitlab-ci.yml:55` vs. super `:69-70` mit `COMDARE_LINT_EXCLUDE_RE`). Beleg: Checkheft R-7.
- **C-6 Eine gespiegelte Wache ist eine zweite Quelle: ab dem Tag der Spiegelung ist „die Wache sagt grün" keine Aussage mehr, solange nicht gesagt ist, welche.** — super-Scope kennt `.sh`, ce nicht; `--seit-basis` nur im super; eigenhändig gemessen: 18 Zeilen >120 Byte und 21 Nicht-ASCII-Zeilen in 1142 ungewachten Zeilen. Beleg: Checkheft R-16 (`:2402-2412`).
- **C-7 Zwei Prüffragen an jede neue Wache: (1) Kann der Mechanismus, gegen den sie gebaut ist, sie selbst treffen? (2) Hatte sie je Gelegenheit zu beißen — und woran erkenne ich das?** — R-13-Fall.
- **C-8 YAML-Mappings verwerfen bei doppeltem Schlüssel alles außer der letzten Definition nach Textposition — eine spätere Verschärfung kann ab Tag eins gegen eine frühere Abschwächung verlieren.** — 18-Tage-Fall (SW-1).
- **C-9 Eine einmal geprüfte Zusicherung, in eine Konstruktion gegossen, die den Prüfvorgang nicht wiederholen kann, ist eine stille Wache: sie produziert Sicherheit, die es nicht gibt.** — Sechs Fälle einer Session; Wiedererkennungs-Merkmale II.7 (`:643-649`).
- **C-10 „HEAD is now at <SHA>" im Submodul-Checkout ist der Zustand VOR dem Update; Wirksamkeit nur über `git submodule status` im step_script oder den Fast-Forward-Diff.** — Falle (p). (Alt-Raum.)
- **C-11 Ressourcen-Verdachtsdiagnosen (OOM, Speicherdruck) erst nach Metrik-Abfrage melden; Prometheus entscheidet in Minuten, was sonst tagelang als These umläuft.** — GitLab-Down-Fall. (Alt-Raum.)
- **C-12 „Transient" ist keine Diagnose, sondern eine Vermutung; ein Retrigger ohne Ursachenbeweis verlängert den Ausfall.** — Neun-Stunden-Fall; Heilung via echter Diagnose + Kill-Switch. (Alt-Raum.)
- **C-13 Direktiven mit Zahlen altern mit der Hardware; der Kommentar an der Zahl führt die Revision mit, sonst wird die alte Zahl wieder zur Doktrin.** — Concurrency-Fall (`.gitlab-ci.yml:43`). (Alt-Raum.)

### 4.6 Git (11)

Der rote Faden: git beantwortet immer nur die Frage, die man stellt — über den Baum, die Ref-Kopie oder den Branch, auf dem man tatsächlich steht. Die Frage nach dem richtigen Objekt muss vor dem Kommando beantwortet sein.

- **G-1 Vor `git worktree remove --force` die ungetrackten Dateien sichern — ein am Spend-Limit gestorbener Agent hat nicht committet.** — 1104-Zeilen-Fall; README-Löschung mit zwei Bissen gegen die alte Fassung.
- **G-2 Bei zwei Repo-Kopien pro Projekt und zwei Thesis-Zeigern immer prüfen, an welchem Objekt gemessen wird: `origin/<branch>` statt lokalem Branch, Submodul statt Separat-Klon.** — Drei Falschbefunde (Klasse 1). Beleg: uuid `9df70aa2`.
- **G-3 Der Prüfbereich ist Dateimenge UND Commit-Bereich, und der Bereich ist die merge-base; jeder bequeme Referenz-SHA aus dem Gedächtnis ist verdächtig.** — Der enge Bereich verbarg 61 % der Änderung (890 von 1448 Zeilen) und meldete grün, wo die merge-base rot war. Offener Rest: `ce/.gitlab-ci.yml:259-268` wählt außerhalb von MRs `CI_COMMIT_BEFORE_SHA` bzw. `HEAD~1`. Beleg: Checkheft R-2 (`:216-228`).
- **G-4 `git add -A` in einem Baum mit Parallel-Agent ist ein Übergriff auf fremde, unfertige Arbeit; immer die Dateiliste nennen; getrennte Bereiche oder Worktrees für getrennte Schreiber.** — 17-Dateien-Fall.
- **G-5 Nie einen Agenten auf einen Checkout setzen, ohne Branch und Rückstand zu prüfen: `git -C <pfad> rev-parse --abbrev-ref HEAD` UND `merge-base --is-ancestor origin/<branch> HEAD`.** — Feature-Branch-Fall (Memory K10).
- **G-6 Aussagen über einen Remote ausschließlich per `git ls-remote`; `refs/remotes/*` ist eine lokale Kopie unbekannten Alters.** — N-4-Beinahe-Befund mit Abgabe-Relevanz.
- **G-7 Eine rescue-Ref ist keine Landung; kein „Fertig"-Signal (gepusht, gesichert, grün, reviewed) sagt etwas über Erreichbarkeit — das tut nur `merge-base --is-ancestor <commit> origin/<zweig>`.** — Gate-8-Fall; 20+ rescue-Refs.
- **G-8 Landungs-Prüfungen grundsätzlich gegen `origin/<zweig>` nach `git fetch --all --prune`.** — Lokaler ce-`main` auf `2b0a9bd8`, origin auf `47c4ef1d` — „die These dieses Kapitels, angewandt auf sich selbst" (Checkheft N-3).
- **G-9 `git add <ignorierte Datei>` schweigt; Heilung nicht per `git add -f` (der Name löst die Falle wieder aus), sondern per Endung außerhalb jedes Ignoriermusters plus Negations-Regeln für Messdaten-Pfade.** — 78/155- und 25/66-Fall (R-17).
- **G-10 Commit-Kommentare, die eine Ursache behaupten, sind prüfpflichtig; ein wirksamer Fix mit falscher Begründung vergiftet spätere Interpretationen.** — abbf53ef-Fall. (Alt-Raum.)
- **G-11 `git status` und der committete Stand sind die Wahrheit — nicht das Manifest eines Agenten und nicht die eigene Zusage.** — Codex-Paket-A-/Fall-D-Fall (`b4e6dcd5:…main.cpp:942`). (Alt-Raum.)

---

## 5. Die Widerrufe, die selbst fielen

Von den 2 adversarisch geprüften Widerlegungs-Datensätzen fiel 1 in der vorgelegten Fassung; der zweite hielt, trug aber selbst einen unbelegten Anhang. Bei n=2 ist das keine Quote — aber ein Arbeitsauftrag: **Widerrufe unterliegen derselben Beweislast wie Befunde.**

### 5.1 A-7 (`bytes_in_use_peak`): Kern bestätigt, Fassung gefallen

**Was hielt.** Der Kern-Fakt stimmt am Objekt: `measurement_snapshot.hpp:124` (in `/home/comdare/wt-ce-fk/libs/cache_engine/builder/`) füllt `bytes_in_use_peak` aus `axis_stats[6][1]`, also dem END-Wert statt eines Peaks — der Code deklariert die Fehl-Etikettierung seit A8-S3/B7 selbst (Feld-Kommentar Z. 53–59). Auch der Widerruf der Dringlichkeit hielt: der Voll-Lauf-Writer `cache_engine_builder_iterator.hpp` führt keine numerische Spalte dieses Namens; die einzige peak-etikettierte Spalte `alloc_bytes_in_use_peak` (Header Z. 592) wird in Z. 903–911 bedingungslos als `n/a` (SourceUnavailable) gerendert — es existiert dort kein Wert-Pfad. Zeitprüfung gegen die Falle „nachträglich gefixt, als war-schon-immer verkauft": `git log -L 903,912:…` gibt `3ef96490` vom 04.08. 13:46 — der n/a-Block lag **zwei Tage vor** der Behauptung (Transkript-Position 6810, 21:30:06); der Widerruf (6891, 21:37:39) misst den Stand, der zur Zeit der Behauptung schon galt.

**Woran die Fassung fiel.** Drei Defekte, festgestellt am Objekt:

1. **Beleg am falschen Gegenstand — Befund-Vermengung A-7/A-8.** Der Satz „Zwei der vier Fundstellen waren zudem falsch zugeordnet (measure.hpp:38 ist toter Beispielcode)" gehört nicht zu A-7: `measure.hpp` enthält null Vorkommen von „peak" (grep leer, exit 1); Zeile 38 ist `ctx.cache_lines_used += used_bytes / 64;` — eine Literal-64-Stelle, also A-8-Territorium. Das Original nennt für A-7 genau eine Fundstelle (und die stimmt); die Vier-Fundstellen-Liste steht unter der Überschrift „A-8 — das Literal 64". Wird die Fassung so verbucht, ist danach weder A-7 noch A-8 korrekt aktenkundig. Randbefund derselben Art in der ursprünglichen Behauptung: der genannte Fix-Ort `system_axis.hpp:339-346` ist der CLU/line_bytes-Block (wieder A-8); der A-7-Zweig ist MEMORY_FOOTPRINT bei `system_axis.hpp:361-368` — und der ruft bereits `mark_source_unavailable()` mit Begründung.
2. **Überschärfung.** „bytes_in_use_peak kommt im Voll-Lauf-Writer NULL Mal vor" ist wörtlich falsch: der Name kommt dreimal vor (Z. 469/582/592, als Teilzeichenkette von `alloc_bytes_in_use_peak`). Richtig ist „kein Wert-Pfad unter diesem Etikett", nicht „null Vorkommen".
3. **Unvollständige Entlastung.** Ein zweiter Produktions-Writer derselben Spalte blieb unerwähnt: super `Code/03_binary_to_csv/binary_to_csv.cpp:59,66` (16-Spalten-Kanon der Thesis-Diagramm-Kette) — dort harmlos, weil die codegen-erzeugten Modul-Einstiege den ABI-Record nullen (`codegen.cpp:46/206`): strukturelle 0, kein verkleideter Momentanwert. Eine dritte Fehl-Füllung liegt in `experiment_demo.hpp:79` (`= stats.total_bytes_allocated`), aber in einem Demo-Header. Der einzige Pfad, auf dem ein echter Momentanwert unter dem Peak-Namen in eine Auswertung läuft, ist `apps/f15_compare/main.cpp:368/376` → `tools/latex_anhang/main.cpp:90/116` (Pflichtspalte, `stoull`) — **der Thesis-Anhang-Pfad**. Er steht nicht in `.gitlab-ci.yml` (0 Treffer für `f15` wie für `latex_anhang`), aber die Entlastung heißt damit „nicht dringlich", nicht „folgenlos".

**Korrigierte Klassen.** Für A-7 selbst trägt „richtiger-Fakt-falsche-Dringlichkeit"; für den Widerruf braucht es „Beleg-am-falschen-Gegenstand / Befund-Vermengung A-7 mit A-8" sowie, kleiner, „Quantifizierung-zu-scharf". Restposten (klein, nicht vor dem Voll-Lauf): echte Peak-Quelle (Wire-Slot oder periodischer `tier_observe`-Zug) oder die f15/latex_anhang-Spalte ehrlich benennen — nicht: Kommentar anpassen, Namen lassen.

### 5.2 Der bestätigte CEB-Widerruf: zwei Abstriche derselben Gattung

Der Leitfall aus 3.1 hielt der adversarischen Prüfung stand — und zeigte trotzdem, dass auch ein korrekter Widerruf Prüfbedarf hat:

1. **Unbelegter Anhang:** „Derselbe Irrtum tauchte am 07.08. 07:27 in D-1 wieder auf" wurde in keinem der geprüften Transkripte gefunden (weder `5a19728e…` noch `46375cdc…` noch `ee79c7dc`/`99e71b91`/`4abae2c3`); die D-1-Treffer betreffen andere Gegenstände (D-1/D-2 Tooling-Vertrag, D-10/D-11-RT). Der Zusatz ist mit uuid nachzureichen oder zu streichen — er darf den Kern nicht mitziehen (Abschnitt 6.3).
2. **Überschuss-Gefahr der Pauschale:** „die Trennung liegt nicht in der Binary" darf nicht als „die CEB ist überhaupt nicht compile-time spezialisiert" gelesen werden — das widerspräche O-083 (unwiderrufen) und KERN 6 („die CEB traegt zur Compile-Zeit die korrekten Routinen, je OS anders hard compiled"). Wer den Widerruf als „kein CT, also Laufzeit-Konfiguration" liest, baut den Gegenfehler.

Dass ausgerechnet der A-7-Widerruf exakt in die Klasse fiel, die er korrigieren wollte (Beleg am falschen Gegenstand), ist der stärkste Einzelbeleg dieses Dokuments dafür, dass die Fehlerklassen Mechanismen beschreiben, nicht Personen oder Rollen — sie treffen Behauptung, Widerruf und Wache gleichermaßen.

---

## 6. Was offen bleibt

### 6.1 Neun ungeprüfte Befunde aus ce-Commits (08.08.)

Einziger Beleg ist jeweils die Commit-Botschaft — die Selbstauskunft des Bauenden. Kein adversarischer Zweitpass; **nicht als gesicherte Befunde weitergeben.** Tentative Klassenzuordnung in Klammern.

1. **ce `2f6f263a`** — Die Bestands-Meldung bei ausbleibenden Zählerwerten zeigte auf Rechte (perf_event_paranoid, CAP_PERFMON, Container); laut Trace (Job 368144, i9-12900K, HYBRID) gelang das Öffnen (`pmc_source.available=1` bei `delta.available=0`), der Fehlschlag lag im Lesen: `read_scaled()` hatte `if (d.t_running == 0) return 0;` — ein stiller Rückfall ohne ein Wort. (Klasse 6/Deutung; zugleich direkte Instanz des Owner-KERNs „Stiller Rueckfall geht fuer uns nicht".)
2. **ce `3910b9e9`** — Bestandskommentar nannte den leeren `read()` (Multiplexing-Verdrängung) „eine ANDERE, hier unveränderte Fehlerklasse"; laut Commit war es keine andere, sondern ein stiller Rückfall derselben; die Flags sind jetzt eine Lese- statt Öffnungs-Aussage. (Klasse 5/Kommentar.)
3. **ce `39243183`** — Die erste Köder-Batterie meldete bei durchbauendem Nenner „KOEDER BEISST NICHT" — dieselbe Zeile wie bei echtem Fehlschlag; jetzt trägt die Nenner-Zeile „(so soll es sein)", und die Batterien unterscheiden „Nenner bricht" (Batterie kaputt) von „ein Köder beißt nicht mehr" (eine Wache ist weg). (Klasse 8/Wachen-Diagnostik.)
4. **ce `52e9f3ba`** — Der CMake-Zyklus im Overlay-Glied betraf nicht nur den super-Superbuild, sondern auch den dokumentierten ce-standalone-Weg (`-DCOMDARE_PROVISION_VENDOR_ALLOCATORS=ON`, damit auch `-DCOMDARE_BUILD_PERMUTATIONS=ON`); latent, weil ein warmes Bau-Verzeichnis nicht neu generiert — „vor jeder Messung wird aber frisch gebaut". Beide Wege vorher reproduziert (exit 1), nachher Generate exit 0. (Defekt größer als gemeldet.)
5. **ce `cc028e1d`** — C++23 `<stacktrace>` ist auf prod1 verfügbar (GCC 15.3 und clang 22.1, beide libstdc++, `__cpp_lib_stacktrace 202011`) — und trotzdem im Hot-Path ausgeschlossen: `current(1,1)` mit einem Frame kostet 343 ns, das 373-fache von `source_location`; bei 19 Achsen und 38 Checkpoints je Interface-Aufruf wären das 13 µs, mehr als die gemessene Operation. Aufrufer wird beim Auslesen aus eigenem Stack rekonstruiert. (Verfügbar-aber-untragbar.)
6. **ce `e347d313`** — `docs/architektur/` neben `docs/architecture/` war keine Inhalts-Doppelung, sondern eine EN/DE-Namens-Kollision aus einem Bulk-Commit (`b7c725d9`): 43 Dateien gegen genau eine; die eine lebendig (aus dem Umbrella referenziert). Per `git mv` umgezogen, Historie erhalten. (Falsche Diagnose der Dublette.)
7. **ce `b000ccc6`** — Der SF-1-Commit galt lokal als sauber; die Vor-Push-Wache fand zwei reale Verstöße, „die vor dem Committen der NEUEN Dateien unsichtbar waren — git diff sieht untracked Dateien nicht": `container_type_traits.hpp:35` mit U+2500-Trennlinie (ASCII-only verletzt) und 8 Dateien abweichend von `.clang-format`. (Klasse 11/toter Winkel.)
8. **ce `f09751f4`** — „428/428 von Anfang an" stimmte nicht: vorher 424/428 — vier Roundtrip-Tests fehlten, weil die `EXCLUDE_FROM_ALL`-Generatoren separat gebaut werden müssen; zwei Test-TUs hingen unsichtbar transitiv an `genus_binding_traits.hpp` — jetzt explizit. (Klasse 2/stille Null, Bau-Zustand.)
9. **ce `b69e869e`** — Positiv-Beispiel ehrlicher Geltungsbereichs-Nennung: „Ob pmc:intel damit gruen wird, ist NICHT behauptet: das entscheidet das errno auf prod2, und prod2 ist von hier nicht erreichbar." Verifiziert nur, was auf prod1 prüfbar war (cpu-PMU type=4 aus sysfs, vier config-Werte mit gemessenem Ausgang).

### 6.2 Am Objekt unbelegte Posten (vom Checkheft selbst so gekennzeichnet, VII.3)

15 Posten, davon vier im Material benannt — **nicht als Befunde weitergeben**:

- „Die 390 Runner-Token sind nicht rotiert" — **Zahlen-Kollision 776 vs. 390, nie gegeneinander gestellt.** Zwei Quellen, ein Widerspruch; hier nicht glattgerechnet, sondern offen.
- „`PERF_COUNT_HW_CACHE_LL` liefert auf Zen 5 errno=2" — kein prod1-Zugang, nur die strukturelle Hälfte bestätigt.
- Herkunft der Zahl 845/174/18714 — nicht reproduzierbar (das ist „nicht reproduzierbar", nicht „falsch").
- Ob eine der heute gebauten Wachen je in einer echten Pipeline lief — kein CI-Zugang zur Prüfzeit.

### 6.3 Offene Punkte aus den geprüften Datensätzen

- **CEB-Anhang „D-1, 07.08. 07:27"**: nicht gefunden (6 durchsuchte Transkripte); nachreichen mit uuid oder streichen.
- **A-7-Restposten**: echte Peak-Quelle oder ehrliche Spaltenbenennung im f15/latex_anhang-Pfad (Thesis-Anhang, nicht in CI).
- **R-2-Rest**: `ce/.gitlab-ci.yml:259-268` misst außerhalb von MRs gegen `CI_COMMIT_BEFORE_SHA`/`HEAD~1` statt merge-base.
- **Mögliche Doppelzählung** in Klasse 1/Klasse 3: die KLASSE-4-Fälle „lokaler Branch vs. origin" und „Submodul-Richtung" sind möglicherweise identisch mit „A1 nicht gelandet"/„divergiert" — im Material zweifach geführt, hier beides ausgewiesen.

### 6.4 Die Nichtfunde (24 Protokolleinträge, zusammengefasst)

**Methodische Grenzen:** Ausgewertet wurde das 4,3-MB-Text-Korpus (10.579 Nachrichten) der 89-MB-Datei; die 1499 attachment- und 6965 Assistant-Records wurden nicht zeilenweise gelesen, sondern über Suchmuster mit Kontextfenstern (200–3500 Zeichen) erschlossen — ein Learning ohne eines der Suchworte kann übersehen sein. Im Alt-Raum wurden für „entlastet" (38 Treffer), „Irrtum" (36) und „gegenstandslos" (50) nicht alle Treffer eingesehen; der Protokolleintrag dazu ist im Material mitten im Satz abgeschnitten. Datei:Zeile-Anker (z. B. `anatomy_fingerprint.hpp:82-83`, `linux_perf_pmc_source.hpp:191-194`, `.gitmodules:12-40`) sind Zitate aus den Transkripten, keine Aussagen über den heutigen Ist-Zustand.

**Sprachbefunde:** „FEHLBEFUND WIDERRUFEN" existiert im Alt-Transkript nicht (0 Treffer; nur als Task-#40-Titel der laufenden Session); „geirrt" 0 Treffer — das Wortfeld läuft über „Irrtum" (36); „nicht wie behauptet" 0 Treffer im Text-Korpus (der einzige Roh-Treffer ist der Suchauftrag selbst); „zurückgezogen" nur als Dublette bereits erfasster Fälle (12 Roh-Treffer); „Widerruf" im Alt-Raum 4 Treffer, davon 2 echte (Instanz-/Sidekiq-These 01.08. 22:56Z); „widerleg" (563), „Korrektur" (2608), „korrigiert" (2312) sind überwiegend Doktrin-Formeln und Commit-Betreffs, nicht eigenständige Vorfälle — die Ausbeute kam aus den seltenen Mustern. „Nie wieder" (30) und „ab jetzt" (81) markieren keine einzige Fehlerklassen-Regel. Die Formel „blinde Wache" (16 Treffer) stammt ausschließlich von Lead/Agenten, nie vom Owner; der Satz „der blinde Köder und die blinde Wache sehen identisch aus" steht nur im Suchauftrag, die Sache selbst ist belegt (Memory K13: „rc=0 sah aus wie eine blinde Methode, war aber ein blinder Koeder").

**Rollenbefunde:** Es gibt keine Stelle, an der ein Agent den Owner am Objekt widerlegt. Der Owner formuliert im gesamten Transkript keine Werkzeug-Falle selbst — alle Werkzeug-Learnings stammen von Lead oder Agenten; die Owner-KERNe mit Regelcharakter dieser Session sind: „Stiller Rueckfall geht fuer uns nicht" (L7524), „Bitte merke dir alle Behauptungen von dir immer zu ueberpruefen" (owner_typed:74), „NIE abkuerzen, immer mit deep research fixen" (owner_typed:143), „Endtermin 15.09.2026, JEDEN Freitag liefern" (owner_typed:143), „CSV wird NIE verwendet / SKIP bei gleicher Binary" (08.08.). K10–K13 existieren nur als Memory-Text (`feedback_eigene_arbeitsfehler_lead_berichte_nie_uebernehmen.md`, modified 08.08. 13:32), im Transkript nur als Schreibvorgang darauf (L16646/L16647) — Provenienz-Notiz, kein Mangel.

**Übergabelücke:** 213 von 316 Learnings der Sammelstufe haben diese Dokumentationsstufe nicht erreicht (Abschnitt 2). Ihr Fehlen hier ist eine Eigenschaft der Übergabe, nicht der Sache.

---

## 7. Die übergreifende Einsicht

Die elf Klassen haben eine gemeinsame Wurzel: **in jedem Fall hat sich eine Aussage von dem Gegenstand gelöst, über den sie etwas behauptet — und hat ihre Autorität behalten.** Klasse 1 löst die Messung vom Objekt, Klassen 2 und 3 vom Instrument, Klasse 4 von der Beweisrichtung, Klasse 5 von der Provenienz, Klasse 6 von der Messung überhaupt, Klasse 7 vom Zeitpunkt, Klasse 8 die Wache von ihrem eigenen Prüfvermögen, Klasse 9 die Korrektur von ihrer eigenen Beweislast, Klasse 10 das Handeln vom gespeicherten Wissen, Klasse 11 den Schreiber vom zweiten Schreiber. Es ist immer dieselbe Figur in verschiedener Kleidung — das Material benennt sie selbst: die korrekte Messung über den falschen Gegenstand erzeugt „kein Fehlersignal, sondern eine belastbare Zahl, ein grünes Gate und ein reines Gewissen" (Ledger `:4705-4707`).

Dahinter liegt eine Asymmetrie der Signale: **Fehlersignale existieren nur für misslungene Messungen, nie für unterbliebene.** Eine falsche Zahl fällt irgendwann auf; eine fehlende Messung, ein nie gelaufener Job, eine nie beißende Wache sehen aus wie Erfolg — „Bei allen drei neuen Gestalten gibt es nichts, was sich nachtraeglich pruefen liesse" (Checkheft VII.5). Deshalb haben alle wirksamen Gegenmittel dieses Hauses dieselbe Bauform: sie binden die Aussage wieder an Gegenstand, Zeitpunkt und Verfahren. Der Nenner bindet die Zählung („1448 geprüft, davon 0"), die Beleg-Form bindet den Fakt (Datei:Zeile + Suchbegriff + Zweigkopf + Uhrzeit + Zählmethode), der zufällige Köder bindet die Wache an ihr Prüfvermögen, die Liste bindet die Vollständigkeitszusage, der Lebend-Check bindet den Schreiber, „Gedächtnis zuerst" bindet den Explore an das schon Gewusste. Und weil die Klasse kein Fehlersignal erzeugt, trägt Disziplin gegen sie nicht: sieben der ersten zehn Regeln sind heute an Werkzeugen verankert, und die drei rein disziplinären (R-3, R-6, R-10) sind exakt die, die zurückkamen — geheilt wurden auch sie „alle drei durch Werkzeuge, nicht durch Handgriffe" (Checkheft I.4, II.7).

Die Richtungsstatistik zeigt, wie die Korrektur im System fließt: der Owner korrigiert den Lead (CEB, Talos, CSV, K1–K5, „294 Repos") und zweimal sich selbst; Agenten korrigieren den Lead häufig; niemand widerlegt den Owner am Objekt. Das schärfste Instrument war durchweg der adversarische Auftrag: „Die wertvollsten Befunde kamen daraus, dass Prüfer ihre eigenen früheren Aussagen widerlegt haben" (uuids `b491485e`, `b47d5590`). Und dieselbe Prüfung muss die Korrekturen selbst treffen — der Beweis steht in diesem Dokument: von zwei adversarisch geprüften Widerrufen fiel einer in exakt die Klasse, die er korrigieren wollte, und der bestätigte trug einen unbelegten Anhang. Die Klassen beschreiben Mechanismen, nicht Personen; sie gelten für Behauptung, Widerruf und Wache gleichermaßen.

In Owner-Worten ist das die stehende Doktrin dieses Projekts: „Bitte merke dir alle Behauptungen von dir immer zu ueberpruefen" — und für den Code dieselbe Regel als Architekturgesetz: „Stiller Rueckfall geht fuer uns nicht: Regressionen oder Fehler gehoeren angezeigt." Der Rahmen, in dem beides zu leisten ist, bleibt unverändert: Endtermin 15.09.2026, Lieferung jeden Freitag.