# DIPLOM -> INFRA (2026-08-05): Write-Token auf Projekt 289 fuer den E-18-Anhang-Vorwaerts-Kanal

**Kanal:** E-20 -- **Dringlichkeit:** GATE fuer den Lebend-Check von Bau-Paket B1/E-18 (Owner: "HAUPT-ZIEL
des Gesamt-Systems"). **Die Landung des Codes ist NICHT blockiert** -- der CI-Job ist inert-by-default;
ohne dieses Token laesst sich nur der Lebend-Check nicht fahren.

## Kontext in einem Absatz

Der neue super-CI-Job `anhang:forward` (Stage `persist`) schreibt die aus echten Messwerten
regenerierten LaTeX-Anhang-Tabellen `anhang/{de,en}/tabellen/*.tex` **vorwaerts** in das
Thesis-Repo (**Projekt 289**, `20260931-overleaf-diplomarbeit`) und zieht danach den super-Gitlink
nach. Das ist die Gegenrichtung zum bestehenden `persist:measurements` (Rueckwaerts-Kanal, schreibt
mit dem 288-Token nach `measurement/`). Das vorhandene 288-Token (PAT id=54) ist **auf 288
ausgestellt** und hat auf 289 kein Schreibrecht -- Least-Privilege je Projekt, also braucht der
Vorwaerts-Kanal ein **eigenes** Credential.

## BRING-Liste (3 Punkte)

### 1. Project-Access-Token AUF PROJEKT 289
| Feld | Wert |
|------|------|
| Projekt | 289 `20260931-overleaf-diplomarbeit` |
| Name | `writeback-thesis-anhang` |
| Scope | **`write_repository` -- NUR dieser** (kein `api`, kein `read_registry`) |
| Rolle | `Developer` |
| Ablauf | ca. 90 Tage |

Sicherheits-Spiegel des bestehenden 288-Tokens (PAT id=54, `write_repository`-only, Bot-Login
enthaelt `_bot_`).

### 2. CI/CD-Variablen AUF PROJEKT 288 (nicht auf 289)
| Variable | Wert | Flags |
|----------|------|-------|
| `COMDARE_THESIS_WRITEBACK_USER` | Bot-Benutzername des Tokens aus (1) | protected |
| `COMDARE_THESIS_WRITEBACK_TOKEN` | Token-Wert aus (1) | **masked + hidden + protected** |

Der Job bricht **laut** ab (exit 1 mit benannter Fehlermeldung), wenn eine der beiden Variablen fehlt --
es gibt kein stilles Gruen.

### 3. Branch-Protection auf 289 pruefen
`development` muss den Push eines **Developer**-Bots erlauben (gleiches Modell wie 288). Ist die
Protection strenger, scheitert der Job mit HTTP 403 und der Retry-Zyklus laeuft leer -- bitte den
Ist-Zustand zurueckmelden, auch wenn nichts geaendert werden muss.

## Was der Job mit dem Token tut (Umfang, damit die Rechte pruefbar sind)

- `git clone --branch development` von 289 in ein Job-lokales Verzeichnis;
- schreibt **ausschliesslich** `anhang/<de|en>/tabellen/<name>.tex` (Whitelist, Namens-Wache);
- **loescht nie** etwas, schreibt **nie** ausserhalb von `tabellen/` (die Owner-Prosa in `kapitel/`
  ist strukturell disjunkt);
- committet **nur bei Byte-Delta** und **nur**, wenn die Thesis-PDF mit dem neuen Stand baut;
- `git push` nach `development` **ohne** `-o ci.skip` -- die 289-Pipeline (lint + thesis-pdf de/en) ist
  der gewollte Post-measure-Rebuild; 289 triggert 288 nicht zurueck, also kein Loop;
- bei non-ff: `fetch` + **MERGE** (kein rebase), max. 5 Versuche, **kein** `--force`.

Credentials erscheinen nur als Variablen-Referenz in der Remote-URL (kein `set -x`, kein
`git remote -v`-Echo) -- dieselbe Handhabung wie in `persist:measurements`.

## Rueckmeldung erbeten

1. Token angelegt (Name/Scope/Rolle/Ablauf bestaetigen -- **nicht** den Token-Wert im Kanal posten);
2. beide CI-Variablen auf 288 gesetzt (mit Flags);
3. Ist-Zustand der 289-Branch-Protection fuer `development`.
