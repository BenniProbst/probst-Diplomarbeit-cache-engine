# ADVERSARISCHE PRUEFUNG — 106er-Nenner

Dokument: `/home/comdare/wt-super-landung/docs/plaene/20260810-KONSOLIDIERUNG-unverlinkte-memories.md` (3859 Z. / 336061 B — beide Zahlen der Behauptung am Objekt bestaetigt)

---

## 1. DER NENNER — **HAELT**

Eigene Erhebung, `comm` gegen **nur** `MEMORY.md`:

```
286 /tmp/vorh_noidx.txt          (287 *.md minus MEMORY.md selbst)
106 /tmp/unlinked.txt
--- idx nicht vorhanden (comm -13) ---      (leer)
```

Tabelle gegen Menge, **beide** Richtungen plus Dublettenprobe:

```
unique rows: 106
--- Dubletten ---                            (leer)
--- in Tabelle, NICHT in 106 (comm -13) ---  (leer)
--- in 106, NICHT in Tabelle (comm -23) ---  (leer)
ENDE
NUMMERIERUNG 1..106 LUECKENLOS
--- W-Spalte Verteilung ---   57 1 / 49 2
```

Gegenproben, die die Behauptung **entlasten** — alle exakt:

```
=== Praefix-Verteilung der 106 ===   50 feedback · 24 project · 32 reference
=== Gesamtgroesse der 106 ===        362440 total          (Doku: 362440)
wave2 modified-Feld: 22 ja / 27 nein                       (Doku: 22 / 27)
Wikilink eindeutige Ziele: 103 · tot: 11 · gefunden: 92    (Doku: 103 / 11 / 92)
Bindestrich-`name:` ueber alle 106: 16, davon 1 = prt_art (5.4) -> 15 echte   (Doku: 15)
LC_ALL=C grep -n '.\{121,\}' -> 0 ; max Zeilenlaenge = 120 Byte
```

**Abweichung, die KEINE ist:** ich messe `idx` **180** / `vorhanden` **287**, das Dokument 179/286. Ursache am Objekt gefunden:

```
project_owner_antworten_20260810_pmc_fallback_release.md
-> IST VERLINKT (neu seit Erhebung des Dokuments)
--- Gegenprobe: in unlinked? --- 0
```

Eine Datei kam hinzu **und** wurde verlinkt. 106 bleibt 106. Der Zeit-Vorbehalt in 7.2 beschreibt genau diesen Vorgang korrekt.

---

## 2. DIE DREI GEHEILTEN VERLUSTE — **HAELT**

`grep -F` auf den S-1-Satz liefert **0** — das ist ein **Artefakt des 120-Byte-Umbruchs**, kein Verlust. Gegenprobe:

```
955:  ... **Wir hatten festgelegt, dass
956:  alle Achsen ein einheitliches Interface haben.** Die Gattung->Genus verwendet ...
```

Zeile 949-963 gegen `feedback_gattung_genus_interface_messparameter_achsen.md` Wort fuer Wort verglichen: das Owner-Zitat ist **ungekuerzt und vollstaendig**, inkl. des Schlusssatzes `und verwendet in den Funktionen jeweils die Achsen, um die Funktion abzubilden.` und des Quelltyposs „Suchalgoritmus". D-2a traegt beide „How to apply"-Saetze woertlich.

S-2: `I-6a` (1437), `I-6b` (1447), `I-7a` (1474), `I-7b` (1483) existieren als Fakten, nicht nur als Tabellenzeilen. Quellabgleich:

```
21:ROBUSTE FORM (bewaehrt): (a) Git-Checkout-Ausgaben und Cache-Zeilen hart ausschliessen;
25:Traces gegenproben, die das Suchwort enthalten (Negativfaelle sind der eigentliche Test).
26:Zweite Lehre: Seed-/Neustart-Stummschaltung darf nur ZUSTANDS-Signale unterdruecken,
```

S-3: `N-1a` (3099), `N-4a` (3121), `H-3a` (1234) — je an ihrem Sachort, nicht nur in der Suffix-Notiztabelle. `gitleaks-base.toml` 1x, `3d6cbec` 2x, `13526` 4x.

Zusatz-Entlastung: auch die **OWNER-KORREKTUR** derselben Quelle („Micro- und Macro-Benchmarking sind FALSCH") und die ganze KANON-REKONSTRUKTION sind da (`messarchitektur_v5_design` 1, `tier_save_all` 1, `IMeasurableWorkloadHost` 1, `F6` 9).

---

## 3. DIE STICHPROBE — **FAELLT** (aber die Fehlerklasse hat sich verschoben)

`od -An -N4 -tu4 < /dev/urandom`, Modulo 106. Gezogen **69, 104, 28, 74, 26**; 26 war bereits die Datei der Vorrunde (F-1), ersetzt durch die naechste Ziehung **17**. Weil davon nur **eine** aus der ungeprueften Welle 2 fiel, drei zusaetzliche Ziehungen Modulo 49: **34, 43, 12**. Alle acht vollstaendig gelesen.

| Nr | Datei | Ziel im Doku | Befund |
|---|---|---|---|
| 17 | `feedback_codex_outputs_always_full_manual_review` | C-8 | **vollstaendig**, beide Owner-Zitate woertlich, alle 4 Pflicht-Schritte, Verschaerfung 06.07. |
| 74 | `project_thesis_19_26_22_deferred_until_cluster` | F-5/F-6/F-7 + W-11 + 5.1 + 5.3 | **vollstaendig** inkl. Aufhebung 09.08. und totem `project_active_goal_directive` |
| 28 | `feedback_implementierung_an_opus_delegieren_fable_als_architekt` | B-8 | klein: „Why" (Spend-Limit/Budget) fehlt |
| 104 | `reference_rescue_ref_ist_keine_landung` | I-17 | klein: der ganze Absatz **„WARUM ES DURCHRUTSCHT"** fehlt — „Wer ‚liegt auf origin' prueft, hat eine wahre Antwort auf eine andere Frage" |
| 69 | `project_lager_baeume_xlsx_doktrin` | U-31/U-32 | **Aufzaehlung springt (3) → (5)**; Punkt (4) Dual-ccache fehlt in U-31. Sache selbst ueberlebt in U-30 (Z. 2581) aus der Schwesterdatei |
| 43 | `reference_git_immer_mit_c_pfad_cwd_falle` | I-19 | fast vollstaendig; nur „(Denselben Fehler machte der Manager im cf22-Trockenlauf.)" fehlt |
| 34 | `project_post_v3_anforderungen_so_abi_driver_split_cli` | Q-11/Q-12/Q-13 | **vollstaendig** — R1/R2/R3, ~131.000, F1/F5/F6/F7/F2-F4, Hintergrund-Direktive |
| 12 | `feedback_kette_planer_mess_ceb_system_tier_organ_hybrid` | Q-1..Q-8, W-31 | **substanzieller Verlust — siehe unten** |

### Der Fund (Welle 2, Nr. 12)

Q-1..Q-8 uebertragen die Owner-Entscheide vollstaendig, lassen aber **„Why" und „How to apply" der Quelle komplett aus**. Literale Gegenprobe im Dokument:

```
Fork A                   0
build_all_axis_levels    0
ExperimentTree           0
Audit-P6                 0
R5-Ranges                0
1:1-Abbildung            0
```

Gegenprobe, dass es nicht anderswo steht — Suche ueber **alle 106** Quellen nach denselben Zeichenketten:

```
feedback_kette_planer_mess_ceb_system_tier_organ_hybrid.md
```

Nur diese eine Datei traegt sie, und das Dokument traegt sie nicht. Verloren ist damit:

- **die Fork-A-Entscheidung**: *„Fork A des Planer-Bauplans damit verschärft entschieden: CEB = vom Planer generierte+kompilierte Binary je Messsystem, **nicht nur .so-Grenze**."* — eine Architektur-Festlegung, kein Beiwerk.
- **die Andockpunkte im Code**: `build_all_axis_levels` / `ExperimentTree`, mit dem Vermerk „löst Audit-P6 in neuer Form".
- die 1:1-Abbildung Achsen-Art → Registry (§28) → Binary-Stufe als Begruendung der Zuordnung.

Das verletzt **die Regel, die sich das Dokument in 7.3 selbst gegeben hat** („Eine Abhilfe gehoert zu jedem Befund") — hier ist es die Umsetzungsanweisung zu einem uebernommenen Entscheid.

### Quote

**8 gezogen, 0 mit hartem Faktenverlust** (keine Zahl, kein SHA, kein Datum, kein Owner-Wort fehlt), **1 mit substanziellem Verlust** (Nr. 12), **4 mit kleinem**, **3 vollstaendig**.

Die Vorrunde fand 2/5 bzw. 1/5 **hart**. Diese Runde **0/8 hart** — das ist eine belastbare Verbesserung und eine echte Entlastung fuer die 57. Aber 5/8 tragen weiterhin etwas, und der Rest konzentriert sich sichtbar auf **Begruendungs- und Anwendungsabsaetze** statt auf Fakten. Damit ist die Selbstaussage in 7.1b („es ist damit zu rechnen, dass auch unter den 49 Verluste liegen") **am Objekt bestaetigt**, und das Dokument ist nicht fertig.

---

## 4. DIE KUERZUNGSREGEL — **HAELT**

```
=== [...] ===
1085:  ... [...] Es gibt dutzende Bibliotheken ...
1087:  **Zum "[...]" in diesem Zitat:** es steht **so in der Quelldatei** ...
3737, 3826  (Meta-Diskussion)
=== [ellipsis] ===
961, 3733, 3838, 3839  (alle Meta-Diskussion, kein Zitat)
```

Zeile 1085 gegen `feedback_hardware_erkennung_factory_laufzeit_nie_statisch.md` geprueft: das `[...]` steht **dort, in der Quelle**. Die Schlussworte „um Hardware zu erkennen" sind zurueck. Die spaeteren Owner-Bloecke der Quelle (ERGAENZUNG ~18:05Z, FINALE EINORDNUNG ~18:15Z) sind vollstaendig als F-3/F-4 uebernommen (`goldrichtig` 1, `declared-only` 2, `Blut-Doktrin` 1, `Research-HWDetect` 2).

Zwei **blanke** `...`-Auslassungen in Owner-Zitaten gefunden (Z. 2518, 2790) — beide an der Quelle nachgeschlagen:

```
./project_62_planer_universal_cache_log_claim_compare.md:59: ... "Daher ... die Batches persistent vor dem Lauf zu planen."
./project_achsen_neuordnung_bindende_sortierung_regressionen.md:119: "Die neue Lesart ... erfordert umfassendes refactoring nach den Plaenen."
```

Beide stehen **so in der Quelle**. Keine vom Dokument eingefuehrte Kuerzung gefunden.

---

## 5. DIE AUFFINDBARKEIT — **HAELT**

```
concurrency 25 · gitleaks 10 · PMC 17 · AVX 11 · AVX512 4 · vendoring 3/Vendoring 3
OD-7 18 · bwrap 19 · NUMA 10 · xlsx 23 · PR4100 8 · Hybrid 22 · std::variant 12
longhorn 10 · clang-format 10 · ccache 14 · MEMORY-DETAIL 15
flat_hash_map 0 · Drift-Gate 0
```

Nichtfunde mit Gegenprobe ueber alle 106 Quelldateien:

```
=== flat_hash_map in den 106? ===   (leer)
=== Drift-Gate / driftgate ? ===    (leer)
```

Beide Begriffe kommen in **keiner** der 106 Quellen vor — ihre Abwesenheit ist korrekt, keine Luecke.

---

## RESTBEFUNDE (klein, aber sie stehen falsch da)

1. **Z. 3688, Abschnitt 7.1:** „Alle 57 sind in der Herkunfts-Tabelle vertreten (Abschnitt 6, **Zeilen 1-57**)." — falsch. Die Tabelle ist alphabetisch, beide Wellen sind verschraenkt; Zeile 3 ist bereits Welle 2. Stehengebliebener Satz aus der 57er-Fassung.
2. **U-31** springt in der Aufzaehlung von (3) auf (5).
3. Die Offen-Posten der Vorrunde 2/3 sind **erledigt**: 0 Zeilen ueber 120 Byte; 7.2 sagt jetzt korrekt, dass die 49 enthalten sind; Ueberschrift 6 und 7.4 nennen 106.

## VERDIKT

- Nenner: **HAELT** · geheilte Verluste: **HAELT** · Kuerzungsregel: **HAELT** · Auffindbarkeit: **HAELT**
- Stichprobe: **FAELLT** — kein harter Faktenverlust mehr in 8 Ziehungen, aber ein substanzieller Verlust (Fork-A-Entscheid + Code-Andockpunkte aus `feedback_kette_planer_mess_ceb_system_tier_organ_hybrid.md`) und vier kleine. Das Dokument ist **belastbar in seinen Zahlen und Owner-Zitaten**, aber noch **nicht vollstaendig in Begruendung und Anwendung** — genau in der Welle, die es selbst als ungeprueft ausweist.