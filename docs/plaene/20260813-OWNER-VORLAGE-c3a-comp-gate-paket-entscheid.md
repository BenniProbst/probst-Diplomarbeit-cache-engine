# OWNER-VORLAGE C-3a -- Comp-Gate-Paket-Entscheid (#38a2)

**Datum:** 13.08.2026 (A2.5-Fix-Stufe, Arbeitsweise v4.0) | **Frist fuer die Antwort: Mi 19.08.2026 (Kippkante)** | **Traeger:** #38a2 (Wellenplan 18.4/18.6) | KON45-02 | KON47-03

## DIE FRAGE (ein Satz)

Darf die erste echte required-Deklaration (Comp-Gate-Schicht, Festplatten-IO-Meta-Meta) den C-3a-Tripwire ausloesen und ihn durch die echte Gate-Pruefung ersetzen -- als eigenes Paket im W1-Bump-Buendel?

## RECHERCHE-WEG (am Objekt gelesen, nicht abgeschrieben)

* Objekt: ce `libs/cache_engine/include/cache_engine/measurement/simd_build_gate.hpp:258-278`, gelesen 13.08.2026 im super-Baum (`Code/external/comdare-cache-engine`); Deklarations-Katalog `simd_organ_requirement.hpp` (9 Eintraege, heute ALLE mit leerer required-Menge -- genau darum haelt der Tripwire noch).
* `active_organ_required()` ist Hook 1/3 der Fassaden-Naht und liefert heute hart `{}`. Der Kommentar am Hook, woertlich:

  > "Die Fassaden-Naht kennt KEINEN Organ-Kontext (sie sieht nur opt_flag + march_flag), der per-Binary genaue Weg liegt allein im Orchestrator (aggregate_required_for_axes ueber spec.axes). Dieser Hook ist deshalb die VEREINIGUNG ueber alle Organ-Klassen. Sie ist heute nachweislich LEER -- und solange sie leer ist, IST {} exakt die Vereinigung. Der Tripwire darunter erzwingt, dass diese Gleichung gilt."

* Der Tripwire selbst: `static_assert(detail::organ_required_union_size() == 0, ...)` (Zeilen 272-278). Seine Meldung, woertlich und ungekuerzt:

  > "C-3a-TRIPWIRE: ein Organ deklariert jetzt required-Flags, damit ist active_organ_required() als leere Vereinigung FALSCH. Die globalen Hooks sind eine VEREINIGUNG ueber alle Organ-Klassen -- jede Binary bekaeme die Flags, auch die, die das Organ gar nicht nutzt. Per-Binary-Genauigkeit noetig: der Orchestrator-Weg (build_orchestrator.hpp aggregate_required_for_axes, Bauplan D3.4 UNBERUEHRT) braucht VOR der ersten required-Deklaration einen eigenen Owner-Paket-Entscheid."

* Wirkung heute: die ERSTE echte required-Deklaration macht den Bau compile-hart ROT -- gewollt, bis dieser Entscheid vorliegt. Bis dahin ist das Gate NotApplicable/inert und byte-/golden-neutral (Header-Kopf simd_build_gate.hpp:9-13; pruef_dock und admit_organ_on_machine stehen fertig bereit).
* Plan-Anker: Wellenplan 18.4 #38a2 ("Comp-Gate-STEMPEL-ANTEIL: organ_stamp_line waehlt den Meta-Meta-Suffix JE COMP ... am Objekt: active_organ_required()=={}", Blocker "Owner-Paket-Entscheid (Tripwire)") | 18.6 Kapazitaet (~1-2 Tage, SCHAETZUNG; KON45-02 nennt das Comp-Gate "EIGENER Bauauftrag") | Fallregel 18.6(3) | FREEZE-CHECK Fr 21.08. fuehrt "#38d + #38a2 (oder deklarierter Fall nach 18.6(3))" | KON47-03 "voll bauen wenn an der Reihe".
* Fehlstand, den der Bau heilt: heute stempelt ein Disk-Typ JEDE Binary, auch MemoryOnly -- organ_stamp_line waehlt den Meta-Meta-Suffix noch nicht JE COMP.

## EMPFEHLUNG

**JA** -- Tripwire ausloesen und ersetzen, als EIGENES Paket im EINEN W1-Bump-Buendel zusammen mit Format 4->5 + Layout 6->7 + Budget-Konstanten (#38d): KON45-01/3 "ein Bruch statt zwei". Der Ersatz ist NICHT die Rueckkehr zur globalen Vereinigung, sondern der im Tripwire selbst benannte Orchestrator-Weg (aggregate_required_for_axes, per-Binary genau; Bauplan D3.4 unberuehrt). Das Gate wurde genau dafuer gebaut und ist bis zur Deklaration nachweislich inert.

## WAS DER ENTSCHEID FREISCHALTET

* Comp-Gate-VOLLBAU (KON45-02 "EIGENER Bauauftrag"; KON47-03 "voll bauen wenn an der Reihe"): erste echte required-Deklaration + echte per-Binary-Gate-Pruefung statt Tripwire.
* #38a2-Stempel-Anteil: organ_stamp_line JE COMP -- MemoryOnly-Binaries tragen keinen Disk-Suffix mehr.
* Das W1-Bump-Buendel bleibt EIN gebuendelter Bruch (#15 / #38d / #38a2 zusammen); vor F2/26.08. ist der Umbau kostenlos (es wurde nie eine Flotte gebaut, Hardware-Erweiterung ist additiv).

## FRIST UND FALLREGEL

* **Frist: Mi 19.08.2026.** Wellen-Design 13.08.: #38a2 liegt in W1 MIT der Auflage "Vorlage sofort raus, Antwort bis Mi 19.08.".
* **Fallregel (wenn bis dahin KEINE Antwort kommt):** #38a2 faellt per Fallregel 18.6(3) ins **W2-Bump-Buendel**; die Freeze-Nachbuchung wird DEKLARIERT, der FREEZE-CHECK Fr 21.08. bucht den deklarierten Fall. Kosten ehrlich: der Bump-Bruch wandert hinter den Freeze, bleibt aber der EINE gebuendelte Bruch [KON45-01/3]; der Tripwire bleibt bis dahin stehen und haelt jede required-Deklaration compile-hart auf.
