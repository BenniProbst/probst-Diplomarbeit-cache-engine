# FORM (c) -- DEFINE-FLAECHEN-MASKIERUNG (Lead-Entscheid 23.08., Traeger offen: Z10 oder cifix-vl3-debug)

GEGENSTAND (383091-Erstlauf, Kopie Z10/ci16095/test-unit-debug-383091.log, Hunks @@ -54/-65/-104):
Die YAML-cmake-Zeilen kippen per ANWESENHEIT der zwei PMC-Defines mit der Lage
(unbrauchbar 0/4 -> keine Tokens; amd/intel -> " -DCOMDARE_ENABLE_PMC=ON -DCOMDARE_PMC_VENDOR=<id>").
Quelle: ceb_pmc_compile_define(), experiment_plan_director.hpp:359-361 (Unbrauchbar: leer, Z.350);
6 Emissionsstellen (Z.423/1103/1149/1487/1720 + clang-Zwilling), ALLE in Zeilenform
"    - cmake -B build... -DCOMDARE_V32_ENABLE=ON<define>...". Hunk @@ -65 traegt KEINE
begleitende "# PMC-BEFUND"-Zeile -> Form (b) allein deckt NIE.

SPEZIFIKATION Form (c) in tests/unit/support/pmc_stdout_maskierung.hpp (EIN Helfer, additiv):
- PmcMaskiert erhaelt drittes Feld: std::size_t pmc_define_tokens{}; ///< entfernte Define-Paare
- Je Zeile: wenn der Inhalt nach optionalem ' '/'\t'-Einzug mit "- cmake " beginnt, entferne
  JEDES Vorkommen der EXAKTEN Teilstrings
    " -DCOMDARE_ENABLE_PMC=ON -DCOMDARE_PMC_VENDOR=amd"
    " -DCOMDARE_ENABLE_PMC=ON -DCOMDARE_PMC_VENDOR=intel"
  (fuehrendes Leerzeichen gehoert zum Token: Z.361 emittiert es; Entfernen laesst die Zeile
  in der Unbrauchbar-Form zurueck => beidseitig identisch) und zaehle je Fund ++pmc_define_tokens.
- LEAD-LEITPLANKE: KEIN beidseitiger Pflicht-Vergleich des Define-Zaehlers in den Verwendern
  (die Anwesenheits-Asymmetrie ist die LEGITIME Folge des Lage-Kipps); der Zaehler dient der
  K13-Bissprobe und der Diagnose-Ausgabe. Formen (a)/(b) behalten ihren strengen Anzahl-Nenner.
- Vendor-ids amd|intel sind die pmc_vendor_registry-ids (vendor_id(), pmc_host_probe.hpp) --
  Kommentar mit Quelle setzen; KEIN Regex noetig (zwei exakte Literale).

TEST (test_vl3_debug_stdout_bytegleich.cpp, additiv):
- Kopf-Doku: dritte Flaeche benennen (383091 @@ -54/-65/-104; Anwesenheits-Kipp, deshalb ohne
  starren Nenner -- woertlich die Lead-Begruendung).
- K13-BISSPROBE beidseitig ausdehnen: (i) kuenstliche Divergenz AUSSERHALB der drei Klassen
  (z. B. ein geaendertes Byte in einer stages:-Zeile) muss ROT bleiben (rc+Text literal
  sichern); (ii) kuenstliche EINSEITIGE Define-Anwesenheit (Token in eine "- cmake "-Zeile
  der einen Seite injiziert) muss nach Maskierung GRUEN vergleichen -- beweist, dass Form (c)
  genau den Kipp deckt und nichts weiter.

COMMIT-TEXT: Ursachen-Klasse Lage-Kipp + 383091-Hunk-Referenz + Lead-Entscheid Weg (a) +
Leitplanken-Zitat; Beweis-Logs als Kopien in den Beweisordner des Traegers.
DANACH: K17/T-11b-Kombibau am NEUEN Endstand wiederholen (der laufende deckt nur b6698eaf).
