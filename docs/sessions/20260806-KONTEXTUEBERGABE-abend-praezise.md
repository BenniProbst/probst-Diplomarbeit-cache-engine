# KONTEXTUEBERGABE 06.08.2026 abend — Session 5a19728e (Lead/Opus 5)

> **ERST-ANKER, in dieser Reihenfolge lesen:**
> 1. **DIESES DOKUMENT** (Repo-Staende + laufende Arbeit + offene Owner-Fragen)
> 2. `docs/ARBEITSWEISE-GESAMT-DOKTRIN.md` — **v3, seit heute die fuehrende Fassung**, Teil V (Verifikations-Doktrin) ist neu und bindend
> 3. `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` — Nachtraege **rueckwaerts**, neueste oben
> 4. Memory `project_owner_kerne_20260806_abend_frist_messkette_ceb` — die Owner-Antworten von heute abend
>
> **ERDUNG (Teil V der Doktrin):** Jede Zahl unten ist am Objekt gemessen. Trotzdem gilt:
> **vor dem Handeln neu messen** — das Repo ist live, mehrere Agenten schreiben parallel.

---

## 1. REPO-STAENDE (gemessen 06.08. ~20:30)

| Repo | `development` | `main` | Bemerkung |
|---|---|---|---|
| **ce** (`Code/external/comdare-cache-engine`) | `b241a272` | `47c4ef1d` | **main hinkt 2 Landungen hinterher** |
| **super** | `77993f6e` | `5534c23c` | **main hinkt hinterher** |
| **thesis** (`20260931-overleaf-diplomarbeit`) | `8e58f691` | `8e58f691` | synchron, beide Remotes |

**super-Gitlinks (committet):** ce = `47c4ef1d` **(veraltet!)** · thesis = `8e58f691` (aktuell).
**super-Arbeitsbaum:** ` M Code/external/comdare-cache-engine` (Zeiger zeigt auf `b241a272`, nicht committet)
+ 3 untrackte Plandokumente + `Code/measure_out_d03/`.

### 🔴 SOFORT-POSTEN: DIE KETTE T-1 IST ZWEIMAL UNVOLLENDET

Die Doktrin (Teil V3) verlangt fuenf serielle Schritte je Landung:
`dev-Push → Pipeline gruen → main-FF → Submodul-Bump → super-Pipeline gruen`

**Offen fuer die letzten zwei ce-Landungen** (`f57801d3` Build-Graph-Kante, `b241a272` LB-6 Stufe 1):
1. **Pipelines nach beiden Pushes NICHT verifiziert** — Projekt **286**, gezielt abrufen, nicht pollen.
2. **ce-`main`-FF fehlt** → `git push origin b241a272<VOLLE-SHA>:refs/heads/main` (+ github), **nie ueber HEAD**.
   ⚠️ Solange `main` hinterherhinkt, **misst die super-Pipeline Code, den niemand mehr faehrt**
   (`super/.gitlab-ci.yml:255/273/291` triggert ce fest auf `branch: main`).
3. **super-Gitlink-Bump** auf den dann gueltigen ce-SHA — eigener Commit, expliziter Pathspec,
   ce-SHA in der Nachricht. **Den thesis-Gitlink NICHT anfassen** (steht korrekt).
4. **super-`main`-FF** + Pipeline **288**.
5. Die 3 untrackten Plandokumente versionieren (heute lagen schon einmal **acht** unversioniert im Baum
   — ein `git clean` haette 4090 Zeilen vernichtet).

---

## 2. WAS HEUTE GELANDET IST (alles auf beiden Remotes)

| Paket | ce-SHA | Inhalt |
|---|---|---|
| T2-A | `86be2420` → `e7aa1244` | Plan-Stempel fail-closed, Formwache `fp_is_hex_128` **in** der Digest-Schleife, Barrieren-Kurzschluss gestrichen, Kostenklammer Glied (1) gefallen |
| B14 | `f577f886` | CLU-Kette bis zum letzten Verbraucher (16 % in allen vier Layouts statt 8/16/33/66) |
| CI-Wachen | `b5e0e4e7` | Abdeckungs-Invariante (407/407) · ASCII-/Breiten-Wache · Schluessel-Wache |
| A1-NB2 | `47c4ef1d` | 4 Sub-Concepts, 2. Versions-Bump v1.0.1c→v1.0.2c fuer 24 Strategien, Pin-Kette **strukturell** umgebaut |
| Build-Graph | `f57801d3` | fehlende `comdare_attach_generated_catalog`-Kante (kalt 100 % Fehlschlag, jetzt deterministisch) |
| LB-6 Stufe 1 | `b241a272` | Zeilen-Ruecklesung aus echten Dateien, mehrzeiliger Stempel, **echte FS-Konkurrenz** |

**super:** B14-super, Graph 2D/3D, sechs+zwei gerettete Plandokumente, Ledger-Nachtraege bis `nachmittag-10`,
**`docs/ARBEITSWEISE-GESAMT-DOKTRIN.md` v3**.
**thesis:** Gate 8 (23 Anhang-A-Abbildungen DE+EN) + vier Abgabe-Verbesserungen
(Alt-Kapitel markiert, Achsen-Inventar eingebunden, Kapitel-5-Praezisierung, Gruppen-Ersatztexte).

**Verifiziert:** ce-Pipeline **15025 gruen 19/19** (411 Tests) · super **15026 gruen 13/13** ·
thesis **15034 gruen** · Thesis baut **DE 202 / EN 192 Seiten**, LaTeX-Warnungen 0, `.blg` 0, alphadin.

---

## 3. DIE OWNER-KERNE VON HEUTE ABEND (bindend)

> **⚠️ FRIST-KORREKTUR: Endtermin ist der 15.09.2026**, mit **woechentlicher Lieferung jeden Freitag**.
> Der 08.08. war ein Zwischenziel. **Jede Priorisierung, die gegen den 08.08. gerechnet wurde, ist falsch.**

1. **Mess-Freigabe:** *"sobald alle Binaries gebaut sind und das erste batch korrekt gemessen werden kann …
   volles GO … sobald ALLE bekannte offene Arbeit aller Phasen und wellen steht"*. **Batch max 4096 fuer
   compile UND Messung.** *"morgen sollten wir schon messen koennen … wenn auch nur das erste batch mit
   4096 Einheiten und danach die 320er XML Einstellung auf der Basis ALLER kompilierter binaries."*
2. **XML-TRENNUNG (Regressionsgefahr):** *"nur weil sie kompiliert werden sollten, heisst es nicht dass sie
   auch gemessen werden muessen, das muss die XML getrennt fuer build und Messung definieren koennen
   sonst regression."* → **Heute existiert die Trennung NUR als Env-Schalter** (`COMDARE_GOLDEN_N_RANGE`,
   `COMDARE_GOLDEN_N_PROVISION_ONLY`) **und als hartkodierte Emitter-Asymmetrie** — **Bau-Posten.**
3. **FORTPFLANZUNG:** *"Wenn eine Messachse sich aendert … DREIPHASIG und ZWEIPHASIG … muss auch die CEB
   und ALLE Binaries fuer die Mess-Achsen-Einstellung neu gebaut werden … Vertrag CEB vs Tier-Binary bzw.
   CEB vs Tier-Hybrid-Binary."* → **Was denselben Neubau erzwingt, gehoert in EINE Welle.**
4. **PMC ist PFLICHT im CEB-Pruefdock:** *"Die Mess-Achse gibt fuer die CEB frei, was ueberhaupt messbar ist
   … PFLICHT, dass das gemessen wird, was gemessen werden kann … MUSS eingebaut und gemessen werden und
   zwar in die CEB fuer deren Pruefdock. NIE abkuerzen, immer mit deep research fixen."*
5. **ObservableTier-Vertrag ist FALSCH implementiert:** *"der Einbau in die CEB und deren Orchestration der
   Konstruktion in die Tier-binaries und Hybrid ist FALSCH … der Vertrag der ObservableTier ist in Gefahr
   und muss auditiert werden gegen die Plan-Definition … DAS IST DIE KERN Achse des Planers und wird nicht
   gestrichen."*
6. **L2/L3/Kohaerenz:** *"gehoert in die Messachse und wird durch die CEB einkompiliert nach Planer
   Freigabe … direkt nachruesten nach Plan. PFLICHT und KERN der ANLAGE."*
   → Die fruehere Empfehlung zur Zurueckhaltung ist **verworfen**.
7. **Fingerprint-Doktrin, uneingeschraenkt:** *"Mess-Achsen + System-Achsen + Organ-Achsen identisch →
   fingerprint fuer identische binary fuer identische Messdaten"* — **Hauptidee des Systems und des Lagers.**
8. **Bestandslog: Pflicht wie im Plan.** *"Rueckfall moeglich mit wiederaufnahme → wertvoll."*
9. **Anhang A: in die Abgabe.** *"Aber erst die Messdaten beheben."*
10. **Sicherheit:** wie empfohlen — Backup-Ref stehen lassen, nach der Abgabe in ein rechtebeschraenktes
    Bundle, dann Remote-Ref loeschen.

---

## 4. DIE ZEIT-BILANZ (gemessen, nicht geschaetzt) — **es geht auf**

Owner-Angabe: *"die grosse Maschine schafft den compile … in 11 Sekunden fuer eine Tier-Binary"*.
**Trifft das 1-Thread-Aequivalent der intel-Lane exakt.** Belegt an einem realen Lauf
(`docs/sessions/20260723-SESSION-mittag-neustart-zug-vollbau4.md:41-45`, Job-Traces 306305/306306):

| Lane | je Slice (4096) | je Binary Wanduhr | je Binary 1-Thread |
|---|---|---|---|
| amd/prod1 @24W | **19,4 min** | 0,284 s | 6,8 s |
| intel/prod2 @24W | **32,25 min** | 0,472 s | **11,3 s** |

- **Erstes Batch morgen: 19,4 min (prod1) / 32,25 min (prod2).** Machbar.
- **Voll-Bau ~34,4 h Wanduhr** (2 Lanes parallel, je 2 Perms x 32 Slices; Engpass intel),
  zzgl. 4 unvermessener PRUEF-Durchlaeufe. **Passt bequem in 40 Tage.**
- **Die geforderte Kalibrier-Stichprobe ist damit ERLEDIGT, bevor sie beauftragt wurde.**

### 🔴 UMFANGS-KORREKTUR (wichtig, wandert seit Tagen falsch durch die Dokumente)

- **`131.072` ist das Fenster JE SYSTEM-PERM**, nicht der Gesamt-Umfang.
- **Der reale Bau-Umfang ist `524.288`** (4 System-Perms: opt {O2,O3} x simd {no_extension,avx2}).
- **`2.097.152`** (`experiment_golden_kern.xml:285`) haengt an einem `line_size`-Faktor 4 in einem
  **XML-Block, den kein Parser liest**, in einer Datei, **die die Pipeline nie anfasst**.
- **Es gibt KEINE Kappung.** `cap="131072"` ist im `comdare_experiment`-Dialekt **nicht geparst** und im
  Thesis-Dialekt **wirkungslos** (cap == Basis-Kardinalitaet). **"gekappt auf 131.072" ist eine
  Fehlbeschreibung.**
- **Batch-Semantik aufgeloest:** "4096 jobs" und "4096 Einheiten" bezeichnen **dasselbe: 4096 BINARIES**
  je Scheibe (`kGnBatchSlice`/`kBuildSliceGrain` = 4096, `BuildJob` = eine Tier-Binary).
  **GitLab-Jobs sind O(Maschinen) = 4** — §62-B (Owner 21.07.): *"NIEMALS Einzel-Jobs je Binary …
  Job-Anzahl = O(konstant), NIE O(Binaries)."*

---

## 5. WAS LAEUFT (Stand Kontext-Ende)

| Workflow / Agent | Gegenstand | Status |
|---|---|---|
| `wjjqbvdb7` | **Mess-Kette Deep Research**: 3-/2-phasige Fortpflanzung · PMC ins Pruefdock · ObservableTier-Audit | laeuft |
| `w9cqubpi0` | **20-seitiges Regressions-Dossier** (Checkheft) → `docs/sessions/20260806-DOSSIER-regressionen-checkheft.md` | laeuft |
| `wmneau5l7` | **Ledger-Nachtrag `abend-1`**: die gesamte verlorene Buchfuehrung | laeuft |
| `codex-t2a-final` | Explore G-E3 Host-Binder + E14 NoFilter (beide **vor Messbeginn**) | laeuft |
| `opus-review-t2a-final` | zuletzt: Thesis-Ehrlichkeit (fertig), super-Abdeckung (Explore) | idle |

**Ergebnisse, die noch nicht ausgewertet sind:** `w76o2kmbd` (5 Scopes zu den Owner-Antworten — Scope 1
ist oben eingearbeitet, **Scopes 2-5 und die Konsolidierung sind UNGELESEN**, Datei
`/tmp/claude-1001/-home-comdare/5a19728e-.../tasks/w76o2kmbd.output`, ~200 KB).

---

## 6. OFFENE OWNER-ENTSCHEIDE

**Beantwortet heute abend** (siehe Abschnitt 3): PMC fixen · Anhang A in die Abgabe · Mess-Tooling-Achse
bleibt · Fingerprint uneingeschraenkt · Bestandslog Pflicht · L2/L3 nachruesten · Sicherheit wie empfohlen.

**NOCH OFFEN:**
1. **Bau-Umfang:** Sind **524.288** gewollt (4 Perms), oder soll auf eine Perm-Teilmenge reduziert werden?
   Der Owner sprach von *"alle Binaries"* — bei 524.288 sind das ~34 h Bau.
2. **`line_size`-Faktor 4** (→ 2.097.152): soll er real werden, oder bleibt der XML-Block tot?
   Bei ~137 h Bau waere er in 40 Tagen machbar, aber er vervierfacht auch die Messung.
3. **A11 ccache-Allowlist-Drop:** geplant am 02.08., **nie gebucht**, und der Code widerspricht —
   `.gitleaks.toml:23-29` traegt den Eintrag mit dem Kommentar *"Dieser Eintrag MUSS hier stehen"*
   (Marathon-Scan-Falle, 27.07.). **Gilt A11 noch, oder ist der Kommentar die juengere Wahrheit?**
4. **A12 / E-14 NAS-Creds** (backup1/backup2, *"trigger-nah"*, Mess-CSV-Ablage): erledigt, verworfen
   oder offen? **0 Treffer in Ledger und Register.**
5. **Doppel-Einbindung der Thesis:** das Repo ist im super **zweimal** eingebunden
   (`thesis/diplomarbeit` **und** `Code/external/20260931-overleaf-diplomarbeit`, dieselbe URL).
   Die CI baut **nur** `thesis/diplomarbeit` (`.gitlab-ci.yml:560`). **Absicht?** Wenn nicht: reduzieren
   (nach der Abgabe, die CI-Pfade haengen daran).
6. **Trigger-Kopplung an `branch: main`:** (a) auf `development` umstellen (widerspricht der
   Gitflow-Doktrin) · (b) **an den Submodul-Gitlink binden** (misst exakt den eingebundenen Stand,
   **Empfehlung**) · (c) bei `main` bleiben und den FF als Verfahren festschreiben.
7. **A10 / HW-Erkennung P4-P6:** in fuenf Session-Docs *"Pflicht vor Trigger"*, danach nie gebucht,
   **und nicht gebaut** (`hardware_probe_factory.hpp:331-333`: *"In P5 setzt der PLANER die Zelle"*).
   **Vor dem Trigger noetig, oder verschoben?**

---

## 7. VOR-MESSBEGINN-POSTEN (offen)

- **PMC ueber die Mess-Achse in die CEB/Pruefdock** (Deep Research laeuft) — **Sperrposten.**
- **`allow_failure: true`** am Voll-Mess-Batch (`experiment_plan_director.hpp:1333`) deckt auch
  **Configure-, Build-, Driver- und Preflight-Fehler** — §66-N2 verlangt *"BEIDE hart"*.
  Die ce-eigenen `pmc:amd`/`pmc:intel` halten die Doktrin korrekt — **erfuellt, wo es nichts kostet,
  verletzt, wo es zaehlt.**
- **G-E3 Host-Binder:** `mess_bestand_doc_key`/`_key_of`/`_versions` haben **0 Konsumenten** —
  der Schreiber (`messwert_registrierung.hpp`) ist toter Code. Vorlage: das Genus-1-Pendant
  `bestand_key_of` ist vollstaendig durchgereicht.
- **E14 NoFilter-Blatt:** Owner *"volles go"*, **0 Treffer im Code**. ⚠️ Das 14-Tage-Register fuehrt es
  faelschlich als "nach Abgabe" — **der Owner-Entscheid ist juenger.**
- **B10-Pruefdurchlauf** (kein Code): Anker auf **Fingerprint-Mismatch**, **NICHT** `COMDARE_VARIANT_GATE`
  einschalten — das waere eine Regression (funktional obsolet per F7-(b)).
- **xlsx-Writer-Geruest:** Owner 05.08.: *"waehrend des Voll-Baus bauen, VOR Messbeginn fertig, UND mit in
  die Abgabe"*. **Kein Code im Repo** — nur ein SOLL-Design-Doc.
- **LB-6 Rest:** Beweis 1 (Batch-Wiederaufnahme) und Beweis 4 (E2E gegen echtes minio, **Infra**).

---

## 8. FALLEN (heute erlebt, alle belegt)

- **`grep` ist in der Agenten-Bash eine Shell-FUNKTION auf ugrep** → `/usr/bin/grep` absolut.
  `grep -v '^\+\+\+'` liefert auf **beiden** Engines eine stille 0.
- **`set -o pipefail` rettet keine Gate-Pipe** — die letzte Stufe endet bei leerer Eingabe harmlos.
- **`.gitignore` enthaelt `*.log`** — Beweis-Logs verschwinden stumm (`git add -f` oder `.txt`).
- **gitleaks:** **immer MIT** `.gitleaks.toml` **UND** ueber den Push-Inhalt (`log -p origin/dev..HEAD`).
  Ohne Config: Fehlalarme auf deutschen Fliesstext. **Niemals einen Worktree mounten.**
- **Codex darf NIEMALS selbst `git` ausfuehren** (haengt bis in den Idle-Timeout, heute 4x).
  Haengt ein Thread: **frischer Thread**, nicht diagnostizieren.
- **Ein Worktree, ein Schreiber.** Heute zweimal beinahe teuer.
- **Idle-Meldung ohne Bericht ist kein Abschluss** — heute fuenfmal; zweimal war der Agent laengst fertig,
  einmal lagen vier Commits ungepusht.
- **Der Ledger waechst live** (heute 5692 → 5840+) — Zitate ueber **Abschnittsnamen** ankern,
  nicht ueber Zeilennummern.
- **Ein Submodul-Zeiger kann RUECKWAERTS zeigen** — heute 78 Commits, Kapitel-Substanz betroffen.
- **Eine rescue-Ref ist keine Landung** — Gate 8 lag auf beiden Remotes und in keinem Zweig.

---

## 9. WENN DU HIER WEITERMACHST — Reihenfolge

1. **Kette T-1 vollenden** (Abschnitt 1) — sie blockiert alles Weitere.
2. **Die 3 untrackten Plandokumente versionieren.**
3. **Scopes 2-5 + Konsolidierung von `w76o2kmbd` auslesen** — ungelesen, ~200 KB.
4. **Die laufenden Workflows einsammeln** (Abschnitt 5), Ergebnisse verbuchen.
5. **Die Owner-Fragen aus Abschnitt 6 stellen** — sie bestimmen den Bau-Umfang.
6. **Dann die Bau-Wellen** nach der Konsolidierung, **gebuendelt nach dem, was denselben Neubau erzwingt.**
