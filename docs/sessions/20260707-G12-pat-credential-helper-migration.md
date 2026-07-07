# G12 — PAT-Migration Remote-URLs → git-Credential-Helper (2026-07-07, User-GO)

**Auftrag (Migrationsplan §5 G12, User-GO 07.07. „Sicherheits-GO VOR Transfers"):** oauth2-/GitHub-PATs aus den lokalen git-Remote-URLs entfernen und in den Credential-Helper überführen — betrifft alle Checkouts auf prod1 (super/ce eingeschlossen). KEINE Secrets in diesem Dokument (redigiert per Disziplin).

## Ausführung (~08:2x)

1. **Global:** `credential.helper store` + **`credential.useHttpPath true`** (zwingend: die GitLab-Projekt-Token unterscheiden sich je Repo — ohne Pfad-Schlüssel kollidierten sie am Host-Key).
2. **Migration (Skript, additiv/merge, nie clobbern):** Scan `~/Projekte` (keys/ ausgenommen) → je Token-Remote: Credential-Zeile (URL-encodiert) nach `~/.git-credentials` (0600), Remote-URL tokenlos. GitHub-PAT-als-Username-Form → `BenniProbst:<PAT>`-Eintrag (PAT-als-Passwort, GitHub-dokumentiert).
3. **Ergebnis:** **294 Repos gescannt · 296 Remotes umgestellt · 295 neue Credential-Einträge.**
4. **Nachzügler:** `super/.git/config` trug 3 Submodul-Sektions-URLs mit Token (von `submodule init` materialisiert; keine Remotes) → `git submodule sync --recursive` (schreibt aus den RELATIVEN .gitmodules-URLs neu, Basis = tokenloses origin).

## Beweise (literal)

- `ls-remote` über den Helper: **8/8 OK** (super origin+github, ce origin+github, prt-art, thesis, Cluster, foundation-all).
- **Rest-Grep über ALLE `.git/config` + `.git/modules/*/config` unter ~/Projekte: 0 Treffer** (glpat-|github_pat_|oauth2:).
- Neues API-/Monitor-Muster verifiziert: `git credential fill` (protocol+host+path) → PRIVATE-TOKEN-Call **HTTP 200** auf /projects/288 (Token nie geechot, nur Länge/Status geloggt).
- `~/.git-credentials` Rechte **0600**; Submodul-Status nach sync intakt (ce=02e4df36, prt-art=faa4e76, thesis=35b7d54).

## Folgen für Tooling/Kadenz

- Pipeline-Monitore/Push-Skripte extrahieren Tokens NICHT mehr aus Remote-URLs, sondern per `git credential fill` (Pfad-genau). Laufende Monitore (Token beim Start gebunden) unberührt.
- `git remote -v` ist ab jetzt secret-frei (Log-/Prozesslisten-Leck geschlossen).
- Rotation künftig an EINER Stelle (`~/.git-credentials`); Vault-Nachtrag der lebenden Tokens bleibt der bestehende K88-/§13.11-Posten (WCM-Befund).

## Rollback

Kein destruktiver Schritt: Remote-URLs sind deterministisch aus `~/.git-credentials`-Einträgen rekonstruierbar (Zeilen tragen Host+Pfad); .gitmodules unverändert (relative URLs).
