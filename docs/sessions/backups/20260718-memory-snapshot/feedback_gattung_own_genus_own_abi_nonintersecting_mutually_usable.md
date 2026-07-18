---
name: feedback_gattung_own_genus_own_abi_nonintersecting_mutually_usable
description: "Gattung = eigenes Genus + eigene ABI + nur teilweise wiederverwendete Observer; Gattungen schneiden sich NICHT, dürfen sich aber gegenseitig VERWENDEN; Set = eigenes Genus (nicht Sub-Typ von Sequence)"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

Gattungs-Prinzip (User 2026-07-16, verfeinert Frage B/E18):

- Jede Gattung = **eigenes Genus mit EIGENER ABI**.
- Observer nur **TEILWEISE** wiederverwendet (nicht alle Observer geteilt).
- Gattungen dürfen sich **untereinander NICHT SCHNEIDEN** — jede stellt eine distinkte Außen-Hülle dar, keine Überlappung/Verschmelzung.
- aber sie dürfen sich **gegenseitig VERWENDEN** (Komposition/Nutzung über Genera hinweg ist erlaubt, ohne zu schneiden); sie verbinden Achsen, die sich nicht in die Quere kommen, bzw. wiederverwenden Achsen unter unterschiedlichen Kernalgorithmen + Interfaces.
- **Set** ist entsprechend ein **eigenes Genus mit eigener ABI** (NICHT ein Sub-Typ von Sequence, obwohl konzeptuell sehr ähnlich); nur teilweise wiederverwendete Observer. Bestand: **map / container (=vector = Sequence) / Set** = getrennte Gattungen.

**Why:** bestimmt, wie neue Gattungen (Set) gebaut werden — eigene ABI + eigene GenusBindingTraits, non-intersecting, aber mutual-use; berührt ABI/golden → Design-vorlegen-Gate vor Bau.

**How to apply:** Set-Bau = neues Genus + eigene ABI + eigene GenusBindingTraits + teil-wiederverwendete Observer; keine Verschmelzung mit Sequence, aber gegenseitige Verwendung erlaubt; deep research C++ std Set-Standard. Siehe [[project_ap15_container_gattung_comdare_container_sequence_plan]], [[feedback_command_pattern_achsen_mess_visitor_container_in_sa]], [[feedback_no_whole_tier_axes_genus_configurator]].

**ENTSCHEID F1/F2/F3 (User 2026-07-16, Design-Gate):** Befund: Set ist im Code BEREITS eigenes Genus (~90%: eigene ABI `ISetTier`/`SetObserverSnapshotV1`, eigene `GenusBindingTraits<Set>`, `SetComposition`), aber als Ebene-2-Genus UNTER der Container-Gattung modelliert (Ebene-1 nur SearchAlgorithm/Container/Graph). **F1a = TUN** (Vokabular/Doku versöhnen: User-„Gattung" ≡ Code-„Genus", golden-neutral). **F1b = ABI/golden-GO GEWÄHRT** — die Gattungen auf **Ebene-1 promovieren** (map/container=Sequence/Set = getrennte Ebene-1-Gattungen), **„die Gattungen und deren Durchsetzung ist UNVERHANDELBAR"** (architektonisch echt erzwungen, nicht nur Vokabular). Das bricht bewusst die „in Stein"-`AnatomyGattung`-Enum + `container_framework::type_count` + `gattung==Container`-static_asserts + golden/ABI → **MAJOR-Änderung, Design VOR golden/ABI-Änderung vorlegen** (auch mit GO), koordiniert mit dem reservierten 4→5-ABI-Bump ([[feedback_no_runtime_switch]]/#37-Scheduling) + der F12(iii)-ABI-Grenzen-Session (= das entparkte #29). **F2/F3 = wie empfohlen NACH gründlicher Doku-Recherche:** native Set-ABI additiv (ordered/unordered/flat, `extract`/`merge`, Mengen-Ops via V2-POD append-only) + ordering/multiplicity als Achsen-Werte (end-append, Default=Ist).
