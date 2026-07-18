---
name: project_ap15_container_gattung_comdare_container_sequence_plan
description: "AP-15-Folgeplan (User 07.07.) — (1) container-Gattung zu comdare::container generalisieren (gleiche Achsen), (2) Gattung Sequence NUR planen, Typ Sequence (std::vector-aequiv.) UNTER den Containern implementieren, (3) linked list + uebrige std-Container = Container-TYPEN, keine eigenen Gattungen"
metadata: 
  node_type: memory
  type: project
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

User-Konkretisierung G-AP15 (2026-07-07): Reihenfolge der Gattungs-Arbeit nach der map-Gattung:

1. **ZUERST:** die container-Gattung in eine **comdare::container**-Gattung umwandeln — allgemein, enthaelt **exakt die bisherigen Container-Achsen**.
2. **DANN:** die Gattung **Sequence NUR in der Planung** anlegen; der **TYP Sequence (aequivalent zu std::vector)** wird real **UNTER den Containern** durchgefuehrt.
3. Unter der Container-Gattung gibt es weitere Tier-TYPEN (linked list + die uebrigen C++23-std-Container), die noch geplant werden muessen — sie sind **KEINE eigenen Gattungen**, da sie Elemente speichern und freigeben koennen (sehr aehnlich → **gleiches Interface**).

**Why:** Legt die Gattungs-Taxonomie fest (Gattung = Interface-Familie, nicht Datenstruktur-Detail) und die Arbeitsreihenfolge; verhindert versehentliche Gattungs-Inflation.

**How to apply:** Task-#29-Strecke: erst comdare::container-Generalisierung (eigener Kadenz-Increment, ce-Repo), dann Sequence-Planungsdokument, dann vector-aequivalenter Container-Typ. Conformance-Oracle/golden bleiben unberuehrt; Gattungs-Interfaces getestet je [[feedback_achsen_thema_modul_framework_metaprogramming_interface]].
