---
name: feedback_no_whole_tier_axes_genus_configurator
description: "KRITISCHE Anatomie-Ordnung — eine Achse (axis_NN) enthält NUR Organe, NIE ein ganzes Tier; ganze Tiere leben unter ihrer Gattung als Konfigurator (Composition über die Organ-Achsen); JEDES Tier (auch Paper-/Original-Tiere) MUSS seziert werden; ein unseziertes Tier ist NICHT im System. Zusatz: in jeder Tier-Binary müssen ALLE Achsen aktiv getrieben UND gemessen werden (per-Achsen-Timing, kein n/a)."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive (2026-05-29, verbatim-tragend):** „Unser Ziel war es immer, Tiere in Organe zu sezieren und die Organe als Achsen abzulegen; der CacheEngineBuilder metaprogrammiert äquivalente Achsen-Kompositionen zur exakten Wiederherstellung eines Tieres aus seinen Organen. Es darf also nie monolithische Tiere geben … KEINE Achsen zuzulassen, die ganze Tiere abbilden. Wir organisieren ganze Tiere unter ihre Gattung und haben dort einen Konfigurator … bestehend aus allen (teilweise optional verwendeten) Achsen der Organe." — „JEDES Tier — auch Original-Tiere (OriginalArt/Hot/Start/Wormhole/Surf) — zu sezieren."

**Konsequenzen (Pflicht):**
- Eine Achse `axis_NN` enthält NUR Organe (Sub-Aufgaben), NIEMALS ein ganzes Tier (kompletter Algorithmus) — auch nicht übergangsweise.
- Ganze Tiere leben unter ihrer Gattung (SearchAlgorithm/Set/Sequence/Adapter/View) als `Composition`/`AdHocComposition`-Konfigurator über die Organ-Achsen (manche optional genutzt).
- Ein noch nicht seziertes Tier steht AUSSERHALB des Systems (kein Achsen-Wert), bis es seziert ist. KEIN Tier ist von der Sezierung ausgenommen.
- **Mess-Zusatz (User 2026-06-04):** In JEDER Tier-Binary müssen ALLE Achsen der Tier-Unterklasse nicht nur strukturell präsent, sondern aktiv **getrieben + gemessen** sein (per-Achsen-Timing über alle Achsen, für SearchAlgorithm alle 19; nicht nur eine Teilmenge). „n/a"/passive Compile-Zeit-Deskriptor-Achsen ohne Laufzeit-Zeitscheibe sind als Endzustand NICHT akzeptabel — notfalls eine minimale Durchreich-Operation ergänzen.

**Why:** Genau das ist der Kern-Beitrag (Achsen-Library): Forscher tauschen EIN Organ, ohne den Rest neu zu bauen — ein ganzes Tier als Achse macht das unmöglich (nicht permutierbar).

**Herkunft:** konsolidiert aus Infra-Agent-Handover (Cluster `docs/agent-memories-infra/`, cwd `C--WINDOWS-system32`), übernommen 2026-07-08. **Stand-Hinweis:** Detailstände der Doku-14/24-Verweise und der axis_03a-Sezierung sind Mai-2026-Stand (inzwischen via S7/234-V teils vollzogen) — der Ordnungs-KERN gilt; Ist-Stand gegen ce-Repo verifizieren. Verwandt: [[reference_thesis_core_contribution_axis_library]], [[feedback_command_pattern_achsen_mess_visitor_container_in_sa]], [[feedback_no_runtime_switch]].
