# BEFUND 02.08.2026 ~20:0x — Thesis-Anhaenge: Realm-Einzel-Gliederung NICHT VOLLZOGEN + vergessene Arbeit

> Explore-Agent „VergesseneArbeit" (very thorough) auf Owner-Auftrag ~19:4x („…insbesondere hatte ich
> angefordert, dass nicht nur die Kapitel der Diplomarbeit angepasst werden sollten, sondern auch die
> Anhaenge, ist das vollumfassend auch in bezug auf die einzel-Gliederung aller Achsen-Kategorien erfolgt?").
> Bericht in 3 Teilen; hier konsolidiert und VERBATIM in den tragenden Teilen. Quellen-Abdeckung: alle 38
> Transkript-Chunks (781 Owner-Nachrichten extrahiert+gefiltert), 48 Leser-Extrakte, 14 Session-Docs
> rueckwaerts (5 gelesen), Thesis-Ist beide Sprachzellen komplett, alle 3 Achsen-Registries als Zaehl-Quelle.
> ZAEHL-METHODIK: LaTeX maskiert Unterstriche (`target\_isa`, teils `\allowbreak{}`) — Trefferzahlen NUR
> nach Normalisierung `sed 's/\\allowbreak{}//g; s/\\_/_/g'` valide; ohne sie ueberall falsche Nullen.

## 1. VERDIKT: NICHT VOLLZOGEN (Organ-Haelfte ja, Realm-Haelfte nein)

- **Organ-Realm 18/18 vollstaendig** im Anhang (T0–T17, DE und EN exakt symmetrisch — identische
  Sektionsfolge und Trefferzahlen; einzige Kleinigkeit: T17 ohne „Statische Sub-Achsen"-Block).
- **System-Realm 1/3:** nur `target_isa` hat eine Sektion (ohne ihre Unter-Achsen); `operating_system`
  und `external_utils` FEHLEN (letzteres nur als Alt-Sektion „Build-SIMD" unter ueberholter Nomenklatur
  `axis_09b_simd_extension`).
- **Mess-Realm 0/3:** `measurement_category`/`collector`/`load_framework` fehlen; stattdessen konserviert
  eine Sammel-Sektion „Telemetrie und Messinstrumentierung" den alten T10-Inhalt.
- **System-Unter-Achsen 0/11:** `target_isa_complex`, `scheduling`, `numa_node`, `page`, `os_version`,
  `kernel`, `build`, `simd`, `compiler`, `opt_level`, `atomic128` — KEINE im Anhang; `page` steht noch
  als eigenstaendige Alt-Sektion „Build-PG".
- **Meta-Meta-Achse: 0 Treffer** in allen 6 Anhaengen (DE+EN), ebenso fehlt die A13-Flag-Grammatik.
- Sektion „Build-HW" fuehrt eine im Ist nicht mehr bau-treibende Achse (Registry: DEPRECATED-Insel bzw.
  HOST-Deskriptor).
- generate-Skripte (`generate_measurement_appendix.ps1`, `generate_wide_appendix.ps1`): nicht lauffaehig
  (Windows-Pfade, 16-Spalten-Annahme vs. real 175, cowfix-v1-Stand 18.06.); C++23-Ersatz
  `Code/08_appendix_generator/` existiert, traegt aber DIESELBE Achsen-Luecke (kennt nur
  memory_layout/node_type/prefetch/search_algo).

## 2. Owner-Anforderungs-Wortlaute (Fundstellen)

- **02.08. frueh (~07:40), tk_37.txt:1271:** „…Weiterhin wurden nur die Kapitel der Diplomarbeit
  korrigiert, aber die Diagramme, Vergleiche, Anhaenge und Tabellen jenseits des volltextes muessen auch
  alle voll gegen den Kontext und den Code konsolidiert werden. Dazu gehoert eine Pruefung der
  Sinnhaftigkeit aller Verweise und Referenzen und Tabellen und Formeln, die sich auch durch die
  Modernisierung der Code Implementierung veraendert haben."
- **01.08. abends, tk_36.txt:2215 (E-1/E-2):** „Thesis ist veraltet und kennt noch nicht mal die 3 Typen
  der Mess-Achsen, System-Achsen und Organ-Achsen. … Neu ist, dass wir die Zerlegung der
  Achsen-Kategorien vorgenommen hatten. Thesis ist mehrere Wochen veraltet."
- Aelterer Strang (tk_10.txt:640 + tk_13.txt:258, CI-generierte Anhaenge als „Haupt-Ziel des
  Gesamt-Systems") ist weitgehend eingeloest (08_appendix_generator), ABER mit derselben Achsen-Luecke.

## 3. Warum durchgerutscht (Beleg-Kette)

Der 01.08.-Anhaenge-Pass war als ZAHLEN-/Stichtags-Pass zugeschnitten (20260801-PAUSE:140: „NUR NOCH
Anhaenge-Pass (… anhang-E-19er-Zaehlung ADR-2/ADR-4, Anhang-B-Stichtag 11.07., Anhang-D-ORG-18, …)")
und wurde exakt so geliefert (thesis 41b1663/1527a6b/b03ef14/e6eb2e8/ca4e18c/0cf4c3d); der KATALOG:55
verbuchte „Anhaenge A–F-Konsolidierung" als erledigt. Die REALM-Einzel-Gliederung stand nie in einem
Auftrag, Katalog, Bauplan oder Ledger — echte vergessene Arbeit, nicht bloss unerledigte.
SCOPE-ABGRENZUNG: Sie liegt NICHT im Scope des laufenden Thesis-Sprachpass-Workers (C1/C3/C7).

## 4. FIX-PAKET „ANHANG-REALM" (8 Stuecke, DE+EN identisch) — eingeplant als eigene Thesis-Welle

1. `operating_system`-Sektion mit den FINAL-DREI Unter-Achsen os_version/kernel/build + Bausteine
   linux/windows/macos (Owner-E3).
2. `external_utils` als System-Haupt-Achse statt Alt-„Build-SIMD"; Unter-Achse `simd` +
   23-Flag-`simd_feature_catalog`.
3. `build_target_complex` + `build_toolchain` (compiler -> opt_level, atomic128) inkl. der Aussage
   „ausdruecklich KEINE vierte Haupt-Achse".
4. Die vier `target_isa`-Unter-Achsen (`target_isa_complex`, `scheduling`, `numa_node`, `page`;
   `page` aus Alt-„Build-PG" herueberziehen).
5. Drei Mess-Realm-Sektionen: `measurement_category` (16, mit Regime-Zuordnung), `collector` (3),
   `load_framework` als META-META-Achse; + die 6 `dynamic_dims`.
6. „Build-HW" auf Ist-Status deprecaten (nicht loeschen).
7. Anhang-D-Intro erweitern (rahmt bisher NUR den Organ-Realm).
8. Beide `.ps1` deprecaten/ueberfuehren auf `Code/08_appendix_generator`; Generator um fehlende
   14 Organ- + alle System-/Mess-Achsen erweitern (Generator-Teil = ce/super-Seite, eigener Schritt).

## 5. Weitere vergessene Arbeit (2 Punkte)

- **(a) VORTRAG (nach Abgabe; Owner 01.08., tk_36.txt:2215 E-9):** „Denn spaeter muss ein Vortrag
  ausgearbeitet werden, der auf dieser Basis des technischen Hintergrundes fusst und sich erst danach
  ueber die Forschungsfragen dem Thema widmet" — stand in KEINEM Katalog/Bauplan/Ledger. JETZT getrackt:
  Memory + Ledger-Merkposten via Task #16.
- **(b) Tote .ps1-Orchestratoren:** vom C++23-Generator abgeloest, liegen aber unveraendert im
  Thesis-Repo und werden in `anhang/de/tabellen/*_diagram.tex` als Provenienz genannt — auf die
  Paragraph-75-Aufraeum-Kandidatenliste (via Task #16). Owner-Wortlaut 10.07. (tk_10.txt): „…was durch
  eine sinnvolle C++23 Anwendung ersetzt werden kann, notiere es als weiteres TODO, bitte kein python…".

Geprueft und bereits getrackt (NICHT vergessen): PMC-XOR-Filter, F2-Benchmark-Schnitt, Paragraph-61-Dual-Weg,
xlsx-Writer, Goetz/Maven-Praezedenz (eingearbeitet: 5 bib-Eintraege + 2 Fundstellen Kapitel 02).
