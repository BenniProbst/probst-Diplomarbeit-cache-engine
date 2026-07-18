---
name: reference_codex_mcp_prod1_bwrap_shell_broken
description: "Codex-MCP prod1 — bwrap-Sandbox scheitert (AppArmor userns-Restriktion, Wurzelursache bestätigt); WORKAROUND sandbox=danger-full-access funktioniert (CODEX_SHELL_OK verifiziert); sauberer Fix = sudo-AppArmor-Profil"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

Symptom (2026-07-07, Session 46375cdc): Codex-MCP-Shell scheitert in den Sandbox-Modi read-only/workspace-write VOR Ausführung mit `bwrap: loopback: Failed RTM_NEWADDR: Operation not permitted`.

**WURZELURSACHE (bestätigt, ~08:20):** `kernel.apparmor_restrict_unprivileged_userns = 1` (Ubuntu-AppArmor-Restriktion; Kernel 6.17). Manueller Repro identisch: `bwrap --unshare-net --dev-bind / / true` → derselbe Fehler. bubblewrap 0.9.0 installiert; sudo nur mit Passwort (kein NOPASSWD) → System-Fix nur durch den User.

**WORKAROUND (verifiziert, funktioniert):** Codex-MCP mit `sandbox: "danger-full-access"` überspringt bwrap komplett — Shell läuft (`pwd && echo CODex_SHELL_OK` → OK). Damit ist die Erstimplementierungs-Kadenz ([[feedback_codex_implements_from_dossier_claude_corrects]]) wieder möglich. Risiko-Management dabei PFLICHT: cwd auf das Ziel-Repo setzen, Tabus explizit in den Prompt (NIE ~/Projekte/Cluster, NIE keys/, keine Remote-Mutationen), Voll-Review Zeile für Zeile bleibt ([[feedback_codex_outputs_always_full_manual_review]]).

**SAUBERER FIX (User, sudo — empfohlen):** AppArmor-Profil für bwrap anlegen, dann Codex wieder mit workspace-write-Sandbox fahren:
```
sudo tee /etc/apparmor.d/bwrap >/dev/null <<'EOF'
abi <abi/4.0>,
include <tunables/global>
profile bwrap /usr/bin/bwrap flags=(unconfined) {
  userns,
}
EOF
sudo apparmor_parser -r /etc/apparmor.d/bwrap
```
(Alternative, weniger sauber: `sudo sysctl kernel.apparmor_restrict_unprivileged_userns=0` host-weit.) Nach dem Fix: read-only/workspace-write erneut proben und diesen Memory aktualisieren.
