---
name: feedback_ultracode_workflow_for_uncertainty_and_absolute_claims
description: "User-Direktive (K84): Bei UNKLARHEITEN / erkannten ABSOLUTEN Behauptungen IMMER einen ultracode-Workflow (Multi-Agent Decision-Research) für die Entscheidungs-Recherche laufen lassen — statt selbst absolut/unsicher zu behaupten oder ad-hoc zu poken. Absolut-Aussagen sind das Trigger-Signal."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 885d4915-6f41-4b18-9770-e729576e9fee
---

**User-Direktive (K84, 2026-07-03):** „Bitte merke dir bei Unklarheiten immer einen ultracode workflow für die Entscheidungs-Recherche laufen zu lassen, sofern du absolute Behauptungen erkennst."

**Regel:**
- **Trigger:** Ich stehe vor einer **Entscheidung/Design-Frage mit Unklarheit** ODER ertappe mich (oder eine Quelle) bei einer **ABSOLUTEN Behauptung** („nur/kein/immer/genau X/unmöglich/keine Brücke") die ich nicht 100% belegen kann.
- **Aktion:** Statt die Behauptung ungeprüft zu setzen oder ad-hoc zu experimentieren → **einen ultracode-Workflow laufen lassen** (Multi-Agent, adversarial verify, Quellen) = Entscheidungs-Recherche, die die Behauptung belegt/widerlegt + die saubere Option bestimmt. DANN erst handeln.
- Absolute Aussagen = **Warnsignal**, dass ich raten könnte → verifizieren, nicht behaupten.

**Konkreter Anlass (K84):** Ich behauptete beim AD-Realm-Rebuild absolut „genau 2 Brücken / kein Cross-Cluster-Bridge" — **falsch** (User: dev hostet definierte langsame Services, von prod zugreifbar). Danach pokte ich comdare.local-DNS/HA ad-hoc mit CoreDNS-Beinahe-Fehler (Corefile-clobber-Risiko). Beides wäre durch vorherige ultracode-Recherche/-Verifikation vermeidbar gewesen.

**How to apply:** Cluster-/keys-/secret-/SSH-/prod-**Ausführung** bleibt bei mir direkt (Delegations-Verbot [[feedback_codex_implements_from_dossier_claude_corrects]]-Kontext) — aber die **Design-/Entscheidungs-RECHERCHE** (allgemeines Wissen, Best-Practice, Verifikation absoluter Behauptungen) läuft via ultracode-Workflow (keine Secrets in Agent-Kontexte). Verwandt: [[feedback_read_plan_thoroughly_before_asking_self_answer]] (erst lesen), [[feedback_never_guess_always_lookup_state_of_art_and_docs]] (raten verboten), [[feedback_no_success_marks_without_literal_output]].
