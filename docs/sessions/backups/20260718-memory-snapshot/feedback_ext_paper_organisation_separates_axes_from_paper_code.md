---
name: feedback_ext_paper_organisation_separates_axes_from_paper_code
description: "ce Paper + Paper-Code liegen in ext/<topic>/<axis>/paper_<id>_<name>/ (LICENSE/manifest/sha256_locked/README/src), physisch GETRENNT von der eigenen Achsen-Implementierung in libs/cache_engine/topics/<topic>/<axis>/; ext/ = read-only kuratierte Fremd-Kopie, libs/ = eigene Engine — Habich-Compliance/is_original bleibt pro Organ"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive (2026-05-27, verbatim):** „Bitte verschiebe die Paper in der cache engine nach ext Unterordner in die richtigen topics. Untergliedere unter ext/topic auch die Paper nach Achsen. Dort gehören kuratierte Paper Code hin."

**Pflicht-Struktur:**
- `ext/<topic>/<axis>/paper_<id>_<name>/` → externer, read-only kuratierter Paper-Code: `LICENSE`, `manifest.txt` (wrapper_fn↔paper_fn↔src-path), `sha256_locked.txt` (vom is_original_validator), `README.md` (Paper-Ref + Source-URL), optional `MODIFICATIONS.md`, `src/`.
- `libs/cache_engine/topics/<topic>/<axis>/` → EIGENE Achsen-Implementierung (Wrapper `axis_*.hpp`, `*_concept.hpp`, `*_registry.hpp` mp_list, `concepts/`).
- Generierte `is_original.hpp` unter `build/.../generated/topics/<topic>/<axis>/legacy_code/`.

**Why:** Physische Trennung Fremd-Code (ext/, read-only, kuratiert) vs. eigene Engine (libs/) — vermeidet Verwechslung: Wrapper-Änderung berührt KEINEN Original-Paper-Code. Habich-Compliance (is_original-Linking) Pflicht; spiegelt die Forschungsarbeiten-Repo-Struktur.

**How to apply:** Bei NEUEN Achsen mit Paper-Code `paper_<id>_<name>/` direkt unter `ext/<topic>/<axis>/`; `comdare_register_paper_wrapper` mit `LEGACY_DIR = ${_axis_legacy_root}/paper_<id>`; kein `libs/.../legacy_code/`-Ordner mehr.

**Herkunft:** konsolidiert aus Infra-Agent-Handover (Cluster `docs/agent-memories-infra/`, cwd `C--WINDOWS-system32`), übernommen 2026-07-08. **Stand-Hinweis:** konkrete Pfad-/paper_id-Beispiele = Mai-2026-Stand → gegen ce-Repo verifizieren. Trägt [[feedback_vendoring_doctrine_ordered_vendor_faithful_selfcontained]]; verwandt [[feedback_thesis_universelle_baum_anatomie_und_prinzipsuche]].
