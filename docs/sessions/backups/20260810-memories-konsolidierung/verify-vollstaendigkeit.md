Verification complete. Compiling the report.

---

# ADVERSARISCHE PRUEFUNG — ERGEBNIS

## 1. DER NENNER — **HAELT**

Selbst gezaehlt, nicht dem Bericht geglaubt. Extraktion nur aus dem Zeilenbereich der Tabelle (1616–1684), `comm` in beide Richtungen:

```
57 /tmp/sec6.txt          (Tabellenzeilen)
57 /tmp/src_list.txt      (unverlinkt.txt)
=== fehlt in Sektion6 ===   (leer)
=== extra in Sektion6 ===   (leer)
=== dupes ===              (leer)
```

Alle 57 Dateien existieren auch physisch (Schleife ueber `unverlinkt.txt`, kein `MISSING:`). **Kein Nenner-Defekt.**

Nebenbefund (Verweis, nicht Nenner): Zeile 46 lenkt falsch — „**Abschnitt 5** ist die Gegenprobe: alle 57 Dateinamen". Die Herkunfts-Tabelle ist Abschnitt **6**; Abschnitt 5 ist „Verweis-Befunde".

## 2. DIE STICHPROBE — **FAELLT**

Auswahl per `/dev/urandom` (5 verschiedene Ziehungen):

```
feedback_gattung_genus_interface_messparameter_achsen.md
reference_gruene_tests_zementieren_alte_ordnung.md
reference_ci_trace_parsing_commit_titel_falle.md
feedback_codex_uncertain_fallback_to_ultracode.md
feedback_comdare_db_and_buildsystem_separate_ledgers.md
```

**Drei vollstaendig — Entlastung.** `feedback_codex_uncertain_fallback_to_ultracode` (C-9, inkl. §7-STOPP, 04.07.), `feedback_comdare_db_and_buildsystem_separate_ledgers` (K-2, inkl. `BenniProbst/comdare-db`, `Layer1-Foundation/…/BUILDSYSTEM-LEDGER.md`, T-01 bis T-61, `YYYYMMDD-HH-MM-NNNNNN-*.md`, Umzugsregel) und `reference_gruene_tests_zementieren_alte_ordnung` (I-16, inkl. `:64/:98`, `+cxx=`, `kSystem`, `compose_system_version_suffix`, `ceb_measurement_stamp_array()`, `builder/ceb_version_stamp.hpp`) tragen jeden harten Fakt.

**Zwei verlieren Fakten:**

### Befund S-1 — zwei Owner-Saetze hinter einem „[…]" verschwunden
Datei: `feedback_gattung_genus_interface_messparameter_achsen.md`, Fakt D-2. Das Dokument kuerzt das Owner-Zitat mit „[…]" und laesst dabei fallen:

1. „**Wir hatten festgelegt, dass alle Achsen ein einheitliches Interface haben.**"
2. „…und **verwendet in den Funktionen jeweils die Achsen, um die Funktion abzubilden**." (Quelle „How to apply": „Achsen sind die Bausteine der Funktions-Implementierung. Einheitliches Achsen-Interface bleibt.")

Gegenprobe: `einheitlich` = **1** Treffer im ganzen Dokument (Zeile 701, E-6 Versionsgrammatik, unverwandt). `abzubilden`/`ueber die Achsen ab`/`Bausteine` = **0** in dieser Bedeutung. Gegenprobe gegen stille Null: `Achsen` = **39** Treffer. Das ist OWNER-WORT, und es ist der einzige Satz, der das einheitliche Achsen-Interface an dieses KERN-Zitat bindet.

### Befund S-2 — die Abhilfe fehlt, nur das Problem steht da
Datei: `reference_ci_trace_parsing_commit_titel_falle.md`. I-6 nennt die Falle, aber die in der Quelle ausdruecklich als „ROBUSTE FORM (bewaehrt)" gefuehrte Gegenmassnahme (a)–(d) fehlt vollstaendig:

- (b) echter Abbruch-Kontext verlangen: `Configuring incomplete` = **0**, `CMake Error` = **0**, `FATAL_ERROR` = **0**
- (c) im Abbruchbereich am Trace-ENDE suchen, letzte ~80 Zeilen: `80 Zeilen` = **0**, `Trace-Ende` = 1 (Zeile 844, anderer Gegenstand)
- (d) gegen echte GRUENE Traces gegenproben: `Negativfaelle` = **0**

Ebenfalls verloren aus derselben Datei:
- **Die zweite Lehre:** „Seed-/Neustart-Stummschaltung darf nur ZUSTANDS-Signale unterdruecken, nie BEFUND-Pruefungen — sonst hakt der Seed rote Jobs ungesehen ab." Gegenprobe: `seed` case-insensitive = **1** Treffer (Zeile 631, YCSB-seed im Messmodell), `stumm` = **0**.
- **PAT-Position:** „PAT-Position 1. von hinten (7 Kandidaten) — Rotation weiter bestaetigt" (NACHTRAG 02.08.). Gegenprobe: `PAT` = 6 Treffer, keiner davon; `Kandidaten` = 3 Treffer, keiner davon. Relevant, weil der Index eigens „PAT RUECKWAERTS bis HTTP 200" fuehrt.
- **Pipeline 13526** (Empirie zu Falle (o), „13526 vs. 13561/13570") = **0**; 13570 und 13561 sind da. Ebenso fehlt die Unterscheidung „bei `test:unit` war die Herleitung falsch, bei `build:clang` stimmte sie" und die Regel „Wirksamkeit an `started_at` belegen, nicht am YAML" (`started_at` = **0**).
- **`Test #260`** = **0** (Substanz — 317er-Gate, `test_experiment_plan_director`, Zwei-Gate-Modell — ist vorhanden; nur die Nummer fehlt). Geringfuegig.

### Befund S-3 — ausserhalb der Stichprobe gefunden (ueber Pruefpunkt 5)
`project_20260727_vormittag_o8_fenster_lage.md` nennt dreimal `gitleaks`, das Dokument **null** Mal. Verloren ist ein Pfad-Fakt: „zentrale gitleaks-Basis (`ci-templates/gitleaks/gitleaks-base.toml` + Heredoc-Materialisierung, **Praezedenz projekteigene toml > Basis**, geloggt)" sowie der Infra-Posten „P9 gitleaks-0-Bytes". Gegenprobe: `toml` = 6 Treffer, alle Codex-`config.toml`; `ci-templates` = 4 Treffer, keiner der gitleaks-Basis.

## 3. DIE UEBERHOLTEN — **HAELT**

Beide Seiten sind da, an mehr als den geforderten zwei Beispielen:

- **W-20** fuehrt die Testzahlen als Reihe mit Ersetzungsregel: `275/271` (vor 01.08.) → **`276/272`** (`52bcbc76`, Pipelines 14127/14129) → `277` (`408242f3`+) → **`280`** (`7603453b`) und `144 | super | … (alter Wert 141 UEBERHOLT)`.
- **W-17** traegt den Bruch beidseitig: „**Alt:** docs-only-main = 13 Jobs / 0 Bridges" gegen „**Neu (KORREKTUR 02.08.)** … 13/1 … Gitlink(thesis)-main = 13/2 … prt-art (287) = 6/0".
- Ebenso W-01 (2 → 3 → 3/2 → 1 → 4/4 → 2/2) und W-03 (19 gegen 18).

Die Doktrin steht auch explizit im Kopf: „Ueberholtes steht drin, als ueberholt gekennzeichnet — es wird nicht weggelassen."

## 4. DIE WIDERSPRUECHE — **HAELT** (geprueft: W-01, W-03)

**W-01** am Objekt gegengelesen. Das Zitat ist wortgleich in der Quelle:
```
project_20260726_nach_trigger_alle_baender_abarbeiten.md:18:
1. **Runner-concurrency=1** … um die Messung nicht zu stoeren — Pipelines queuen
   seriell; das ist gewollt, kein Defekt. Bei CI-Staus NICHT an der concurrency drehen.
```
Der bisher unbekannte Zwischenwert ebenfalls belegt:
```
project_diplomarbeit_stand_20260712_freigaben_pipeline.md:20:
- Infra-Handover geschrieben (V80-Filterpod write-only + prod1-concurrency 2→3)
```
Echter Widerspruch, korrekt klassifiziert (OWNER-WORT vs. AGENTEN-BEHAUPTUNG, Primaerbeleg als ausstehend markiert).

*Eine Praezisierungs-Anmerkung, kein Widerlegen:* das Dokument schreibt „Der Owner hat 1 … ausdruecklich **angeordnet**". Der Wortlaut ist beschreibend („das **ist** gewollt"), nicht anordnend; anordnend ist nur der zweite Satz („NICHT an der concurrency drehen"). Da beide Hosts laut verlinkter Referenz zu dem Zeitpunkt schon auf 3/2 liefen, ist die schaerfere Lesart: der Owner hat einen Zustand gebilligt, den es nicht gab. Das macht den Befund nicht kleiner, aber die Handlung („Umsetzung fand nie statt") sollte als „Owner-Annahme war schon damals faktisch falsch" gefasst werden.

**W-03** am Objekt gegengelesen. Quelle traegt die 19 wortgleich:
```
project_diplomarbeit_stand_20260717_volles_go_bau_roadmap.md:16:
- **INC-1:** … als gemeinsame Schicht ÜBER den 19 Organ-Achsen; heute flach
```
Geltende Annahme belegt: `reference_organ_achsen_sind_achtzehn_nicht_neunzehn.md` — „Registry listet **18**", „`organ_count()==18`", „KEIN 19. Composition-Slot". Echter Zahlenkonflikt, kein Ebenen-Missverstaendnis (sagt die Quelle selbst).

*Veraltetes „Zu tun":* das Dokument schreibt „das Korrektur-Datum 19 → 18 belegen (in den 57 nicht enthalten)". Das Datum steht in der Datei, die es selbst zitiert: „GESCHLOSSEN **09.08.2026** am Objekt". Dieser Posten loest Arbeit aus, die schon erledigt ist.

## 5. DIE AUFFINDBARKEIT — **HAELT mit einer Ausnahme**

```
concurrency    16      Runner    25      Hybrid   16
PMC            21      xlsx       7      Gattung  14
Vendoring       0      vendor     7      Ledger   34
gitleaks        0
```

- **`Vendoring` = 0 ist entlastet.** Gegenprobe: `vendor` = 7 Treffer im Dokument gegen 7 Quelldateien mit `vendor`; die Substanz ist da (`COMDARE_VENDOR_SNMALLOC`, „vendored ce-Unit-Tests nicht im `all`-Ziel", „CPUID-Vendor/Familie", `comdare::vendor_mimalloc`). Das Wort in der Grossschreibung fehlt, der Fakt nicht.
- **`gitleaks` = 0 ist ein echter Fund** → Befund S-3 oben. Drei Nennungen in einer Quelldatei, keine im Dokument.

## ZUSATZ: die Kopf-Behauptung selbst nachgezaehlt — **BESTAETIGT**

Nicht beauftragt, aber billig und tragend:

```
MEMORY.md:  79 Zeilen, 17274 Byte, mtime Aug 10 07:50
Memories gesamt (ohne MEMORY.md):  285
verlinkte Ziele:                   179
unverlinkt:                        106      ← Bericht sagt 106
von den 57 zwischenzeitlich verlinkt: 0     ← Bericht sagt 0
tote Links im Index:                  0
```

(Meine erste Zaehlung ergab 108 — das war mein eigener Extraktions-Defekt: die Regex `[a-z0-9_]` verfehlt `…lokal_O0_…` und `MEMORY-DETAIL`. Mit `[A-Za-z0-9_.-]` faellt sie auf 106.)

Die fuenf namentlich genannten, aus dem Index gefallenen Ziele — alle bestaetigt, Datei existiert, Index-Eintrag weg:

```
project_lager_baeume_xlsx_doktrin                            live-Index:0  Datei:JA
feedback_recursive_dock_planer_ceb_tier_abi_stable_so        live-Index:0  Datei:JA
feedback_standardprozess_research_zu_product_matrix_3d       live-Index:0  Datei:JA
project_cache_engine_research_vs_cacheengine_all_split_todo  live-Index:0  Datei:JA
project_62_planer_universal_cache_log_claim_compare          live-Index:0  Datei:JA
```

---

## URTEIL

| Pruefpunkt | Ergebnis |
|---|---|
| 1 Nenner | **HAELT** — 57/57, `comm` beidseitig leer |
| 2 Stichprobe | **FAELLT** — 3 von 5 sauber, 2 mit Faktenverlust (S-1, S-2) |
| 3 Ueberholte | **HAELT** — beide Seiten, an vier Beispielen |
| 4 Widersprueche | **HAELT** — W-01 und W-03 am Objekt wortgleich bestaetigt |
| 5 Auffindbarkeit | **HAELT bis auf `gitleaks`** (S-3) |

Das Dokument ist im Kern belastbar: der Nenner stimmt, die Widersprueche sind echt, die Historie ist zweiseitig gefuehrt, und die Kopf-Behauptung 106/285 haelt der unabhaengigen Nachzaehlung stand. **Was faellt, ist nicht die Struktur, sondern die Vollstaendigkeit im Detail:** die verlorenen Fakten sind durchweg die *Abhilfe*-Haelfte (die robuste Form gegen die Trace-Falle), *Betriebs*-Wissen (PAT-Position, gitleaks-Basispfad) und **zwei Owner-Saetze, die eine Ellipse verschluckt hat** — S-1 ist der schwerste Befund, weil OWNER-WORT die hoechste Herkunftsklasse des Dokuments ist und ausgerechnet dort gekuerzt wurde.

Ich habe nichts am Dokument geaendert.