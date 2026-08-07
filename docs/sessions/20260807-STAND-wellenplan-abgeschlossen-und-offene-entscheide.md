# STAND 07.08.2026 mittags — Wellenplan abgeschlossen, zehn Entscheide beim Owner

**Wiederanlauf-Anker für die nächste Session.** Dieses Dokument ist der Erst-Anker: was gelandet
ist, was auf den Owner wartet, und welche Fallen der Tag hinterlassen hat.

---

## 1. Refs (Stand dieses Dokuments)

| Repo | development | Bemerkung |
|---|---|---|
| ce | `ba069e38` | Pipeline 15202 |
| super | `1b6f204f` | Pipeline 15203 |
| thesis | `eaf7fe8` | Pipeline grün |
| cluster | `d7eab98` | unberührt |

Gitlinks in super stehen auf ce `a1d0c201` und **beide** Thesis-Zeiger auf `eaf7fe8`.
Hinweis: der ce-Gitlink hinkt den letzten zwei ce-Commits (`72ac414e`, `ba069e38`) hinterher —
das ist Absicht, er wird nach der grünen Pipeline nachgezogen.

---

## 2. Was heute gelandet ist

### Wellenplan (fünf Wellen, jede in eigenem temporärem Branch, alle Branches gelöscht)

| Welle | Inhalt | Ref |
|---|---|---|
| A | T-9: Min/Max-Katalog als constexpr-Tabelle, speist `break_even` | ce `875a57cd` |
| B | fail-closed Modus-Token · macOS-Off-by-one · Phantom-Felder angenagelt | ce `0c08fa15` |
| E | `resource_group` PMU host-scoped (`pmu-prod1` / `pmu-prod2`) | ce `0c80aa78` |
| C | T-8: Pareto-Front statt Einzelsieger | ce `21560a2e` |
| D | T-10: Workload-Cluster offline (2. Anlauf nach Spend-Limit) | ce `a1d0c201` |

### Nachgezogen

- cppcheck-Fix + `AXIS_ALGO_VERSION` 1→2 + Lock-Regeneration — ce `72ac414e`
- Wachen-Ehrlichkeit (Verdikt nennt die ungeprüften Gates) — ce `ba069e38`
- Talos-Tempus-Korrektur, DE führend, EN nachgezogen — thesis `eaf7fe8`
- Ledger-Nachträge mittag-1 … nachmittag-1 + Welle-D-Rettung — super

### Der schwerste Fund des Tages

**Der `best_binary_selector` hat eine dominierte Binary AUSGELIEFERT** — kein theoretischer
Defekt, sondern der Auslieferungspfad. Bissbeweis mit dem echten CLI am unveränderten Stand:
`bin_tie_loser` (lookup=100, scan=500) wurde versandt, obwohl `bin_true` (lookup=100, scan=200)
sie strikt dominiert. Der Tie-Break „mehr Samples zuerst" deckte das.

---

## 3. WAS AUF DEN OWNER WARTET — zehn Punkte

### 🔴 Rot (blockiert oder gefährdet die Abgabe)

**R-1 · Der Generator dreht die Thesis-Korrektur zurück** (Task #38)
`super/Code/04_csv_to_latex/csv_to_latex.cpp:985-986` emittiert *„L1/L2/L3 + dTLB + Coherence +
Energy = 0 / nicht erhoben"*. Die Thesis trägt die korrigierte Fassung. Der nächste
Generatorlauf ersetzt **richtig durch falsch** — L1/L3/dTLB werden real via `perf_event_open`
erhoben. Ein-Zeilen-Fix, DE führend, danach Byte-Vergleich Generator↔Bestand.

**R-2 · `cpe`-Grammatik** (Task #36, blockiert den Bau)
- (a) Wie trennen wir `e`(experimental) von `e`(efficiency)? *Empfehlung: Trennzeichen*
  `v1.0.0c-pe` — alle 138 Bestands-Literale bleiben gültig.
- (b) Pflicht (= 138 Literale migrieren, EIN Byte-Ereignis) oder optional?
- (c) Welche Buchstaben ins Spezifikations-Alphabet außer `p`/`e`?
Objektbefund: die Ein-Zeichen-Regel ist dreifach ratifiziert (Code, Ledger, **Thesis**), die
Position hinter dem Flag ist durch `e` belegt, `v1.0.0cpe` → Sentinel.

**R-3 · xlsx-Blattform für das Profil**
*Empfehlung: ein Sheet je Mess-Layer*, Zeilen = Checkpoints in Zeitreihenfolge, Zeit als erste
Spalte. Dazu: native Excel-Charts einbetten (libxlsxwriter kann es) oder reichen die Zahlen?
Ohne diesen Entscheid kann der xlsx-Writer nicht gebaut werden.

### 🟡 Gelb (blockiert Folgearbeit)

**G-1 · Sechs STOPP-Gate-Entscheide E-A…E-F** (Task #39)
`docs/plaene/20260806-PLAN-versionierungs-interface-stempel.md` Sec.5, eigene Doktrin: *„STOPP
(generell): ohne Entscheid kein Byte."* Durch DREI Konsolidierungen gefallen, 0 Treffer in
Ledger und beiden Owner-Vorlagen. Blockiert KERN F7=b vollständig.
Lead-Empfehlungen liegen ausgearbeitet vor: `b / ii / b / a / b / a`.

**G-2 · T19 `persistence_target`** hat keine Katalog-Zeile — der BEFUND ist Stand 09.07., die
Achse kam mit ORG-18 dazu. Welle A hat **keine Richtung geraten** (honest-empty +
consteval-Anker). Welche Min/Max-Semantik?

**G-3 · Vier Entscheide aus Welle C (Pareto)**
- Welche gemessenen Spalten kommen als **MAX** ins WIDE-Schema? Die Mechanik ist gebaut, aber
  kein produktives Feld übt sie aus (alle sechs Selector-Metriken sind ns-Latenzen = MIN).
- Die Brücke **CSV-Spalte → Katalog-Zielgrößen-Id** existiert nirgends und wurde nicht erfunden.
- Die **Default-Zielgrößenmenge** („alle wertbaren Metriken") ist eine Setzung des Agenten —
  sauberer wäre die Nennung in der Experiment-XML.
- Bei mehrelementiger Front wird weiterhin **ein** Artefakt versandt. Mehrere würden den
  Versand-Vertrag und die PRT-ART-Konsumption berühren.

**G-4 · Fünf Entscheide aus Welle D (Cluster)**
- Der **k-Wahl-Konsens ist unvollständig**: Gap braucht Zufalls-Referenz *und* Seed, BIC eine
  GMM-Variante. Der Agent baute deshalb bewusst keine Funktion, die „das" k liefert.
- **Linkage-Kriterium** — der Plan sagt nur „agglomerativ", nennt keines.
- **Noise-Schwellwert** der Online-Zuordnung.
- Vier **Skalierungs-Lesarten** (θ / neg% / value\_size / thread\_count), überstimmbar.
- Vier **Datensatz-Features** honest-0, weil `WorkloadProfileAggregate` sie nicht erfasst.

**G-5 · RunMethodology-Enum-Reihenfolge**
`{debug, measure, release, compare}` bildet die Stufenordnung (`measure → compare → release`)
nicht ab. Umstellen wäre ein Stempel-/ABI-Ereignis; ich habe nur eine Nicht-verwechseln-Notiz
gesetzt. Soll der Enum die Ordnung tragen?

**G-6 · Dual-Review-Pflicht**
`LEDGER:4114`: *„Ab sofort: JEDE Bau-Welle VOR Landung Dual-Review Codex+Fable."* Im gesamten
Fenster **null Codex-Aufrufe**, fünf Landungen ohne unabhängigen Review, kein Aussetzungsvermerk.
Gilt die Pflicht weiter, oder ist sie durch die Vor-Push-Wache abgelöst?

**G-7 · `cpe` im Ledger widersprüchlich**
Der Ledger führt den `cpe`-Tag-Einbau als *„Bau, kein Entscheid"*, Task #36 und die Owner-Vorlage
als owner-blockiert. Wer die Ledger-Liste abarbeitet, startet einen stempel-/ABI-relevanten
Einbau ohne Entscheid. Eine Zeile Korrektur genügt.

---

## 4. Offene Bau-Rückstände (kein Entscheid nötig)

- **M-3a**: `branch_misses` real anbinden ODER dauerhaft als honest-0 im Anhang führen
- **§58-REPLAY**
- **V-03/V-05-Reste**: der #162-Zählbeleg (≥8 Rang-1-SOTA-Lebewesen) vor der Messauswertung
- **A15/§55-Reconcile**: 43 von 43 Positionen unsauber, 17 davon noch ungeprüft
- **A14/FF0 Multi-Plattform** (im Alt-Block „Abgabe-Blocker") und **GN-9 Feasibility-Gate**
  (per Definition VOR der Voll-Matrix, ohne Slot)

---

## 5. Fallen, die dieser Tag hinzugefügt hat

Alle im Fallen-Register (`memory/reference_fallen_register_werkzeuge_und_ci.md`):

1. **`grep -v '/build'` FRISST `/builder/`** — immer `/build/` mit beiden Schrägstrichen.
2. **Falscher Checkout**: der Haupt-Checkout eines Submoduls kann auf einem Feature-Branch
   stehen; die Spitze trägt der Landungs-Worktree.
3. **Stale Generator-Binary** → Roundtrip-Test **falsch rot**. Erst `stat -c '%y'` gegen die
   Quellen, dann den Code verdächtigen.
4. **EXCLUDE_FROM_ALL-Targets** (`test_profile_roundtrip`, die `*_registry_gen`) hängen nicht am
   Default-Target — explizit bauen, sonst „Generator-Tool nicht gebaut".
5. **Gates auf ALLE berührten Dateien**, nie auf die gedachte — Liste aus `git diff --name-only`.
6. **Grün mit Nenner 0 ist rot.**
7. **`git -C` auf ein leeres Submodul-Verzeichnis** fällt still aufs Elternrepo zurück und
   liefert dessen SHA.
8. **`update-index --cacheinfo` prüft den SHA nicht** — nimmt jeden 40-stelligen Hex-String an.
   Immer `$(git rev-parse <ref>)`, danach `cat-file -e` als Existenzbeweis.
9. **Vor `worktree remove --force` die ungetrackten Dateien sichern** — ein Agent, der am
   Spend-Limit stirbt, hat nicht committet.
10. **Eine Wache, die „alle Gates" sagt, meint ihre eigenen.** Das Verdikt muss die Lücken nennen.

---

## 6. Pausiertes

**Doppel-Audit** (Fable-5-xhigh + Codex über die letzten 3 Kontexte) — gestoppt auf Owner-Wunsch.
Wiederanlauf: `Workflow({scriptPath: ".../doppel-audit-opus5-3-kontexte-wf_355205a7-f46.js",
resumeFromRunId: "wf_355205a7-f46"})`. Fertige Agenten kommen aus dem Cache.

**Welle-D-Rettung**: `docs/sessions/backups/20260807-welleD-t10-spendlimit-rettung/` — die
geborgene Fassung ist durch den zweiten Anlauf überholt, bleibt aber als Beleg für die
Rettungs-Methode und die Lehre darin.
