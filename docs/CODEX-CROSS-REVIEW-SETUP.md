# Codex als Cross-Provider-Review-Tool in Claude Code (Setup, 2026-06-27)

> **Ziel:** OpenAI Codex als zweite, unabhängige Review-Instanz in Claude Code verfügbar machen (Cross-Model-Review → reduziert Single-Model-Bias/Sycophancy: ein OpenAI-Modell prüft Claude-geschriebenen Code).
> **Wichtigster Befund:** Es gibt **kein separates „Plugin"**. Codex wird als **MCP-Server** registriert — Codex hat dafür den Subbefehl **`codex mcp-server`** („Run Codex itself as an MCP server over stdio"). Claude Code = MCP-Client → ruft Codex als Tool.

## Schritt 1 — Codex CLI installieren (läuft NATIV auf Windows, kein WSL2 nötig)
```powershell
npm install -g @openai/codex
# Alternativen: standalone-Installer (macOS/Linux) `curl -fsSL https://chatgpt.com/codex/install.sh | sh`; oder Homebrew
codex --version   # prüfen, dass es auf dem PATH ist (npm global bin)
```
Voraussetzung: Node.js/npm vorhanden. (Windows-Hinweis OpenAI: Codex läuft in der PowerShell-Sandbox nativ; WSL2 nur bei Bedarf eines Linux-Environments.)

## Schritt 2 — Codex authentifizieren
```powershell
codex login          # ChatGPT/OpenAI-Account-Login (einfachster Weg)
# ODER per API-Key (der MCP-Server liest die Env beim Start):
$env:OPENAI_API_KEY = "sk-..."   # vor dem Claude-Code-Start setzen (NICHT in ein Repo committen!)
```

## Schritt 3 — Codex als MCP-Server in Claude Code registrieren
```powershell
claude mcp add --scope user --transport stdio codex -- codex mcp-server
claude mcp list      # 'codex' sollte erscheinen
```
- `--scope user` = global über alle Projekte (Alternative: `--scope project` schreibt eine `.mcp.json` ins Repo zum Teilen — enthält nur den Befehl, kein Secret).
- `--transport stdio` = lokaler Prozess (Codex läuft als Kindprozess, beendet sich, wenn der Client schließt).
- **Danach Claude Code neu starten** (oder `/mcp` → reconnect), damit die Codex-Tools geladen werden. Dann kann ich (Claude) Codex aufrufen, z. B. „review diese Datei mit codex".

## ⚠️ COMDARE-Sicherheits-Caveats (wichtig)
- **Datenabfluss:** Codex sendet Code/Kontext an **OpenAI** (externer Dienst). → **NUR auf den eigenen Code-Repos** nutzen (cache-engine/prt-art/thesis/super). **NIEMALS im Cluster-Repo** (`Projekte/Cluster`) oder in Verzeichnissen mit Keys/Secrets/`machines/`/`keys/` — das wäre Credential-/Kunden-Daten-Exposition (CLAUDE.md). Codex respektiert `.gitignore`/Sandbox, aber der Review-Scope ist bewusst zu wählen.
- **Read-only Review:** Codex im Review-/Vorschlags-Modus laufen lassen (keine Auto-Edits am Code) — Codex schlägt vor, Claude/Du setzt um. (Codex-Approval-Modi: read-only/auto.)
- **Kosten:** Codex-Reviews verbrauchen OpenAI-Tokens (eigenes Konto/Abo).

## Nutzung danach (durch mich, Claude Code)
Nach der Registrierung erscheint das Codex-MCP-Tool. Ich kann es gezielt für **Zweit-Review** einsetzen: „lass Codex die cache-engine-ABI-Header gegenlesen", „Codex-Bug-Hunt auf perm_runner". Besonders stark laut Quellen für: Code-Review, Architektur-Sanity, Bug-Hunting, komplexe Logik — schwächer für Frontend/UI.

## Quellen
- OpenAI Codex MCP (Client-Seite): https://developers.openai.com/codex/mcp
- OpenAI Codex CLI (Install/Windows/Auth): https://developers.openai.com/codex/cli + /codex/cli/reference (`codex mcp-server`)
- Claude Code MCP-Doku: https://code.claude.com/docs/en/mcp
- Anleitung „Codex inside Claude Code": https://www.claudefluent.com/guides/codex-inside-claude-code
- Hintergrund Cross-Provider-Review: https://www.mindstudio.ai/blog/openai-codex-plugin-claude-code-cross-provider-review
- Community-Wrapper (Alternative zum nativen `codex mcp-server`): https://github.com/tuannvm/codex-mcp-server
