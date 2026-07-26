# 20260726-rueckfragen-selbst-aufloesung-workflow / A-test-skip (agent ad244237)

runId: wf_bb5d71e9-fdb
agentId: ad24423730db3361d
label-Zuordnung: A-test-skip (Prompt-Marker-Deckung 100%)

---

PUNKT A - TEST-SKIP: AUFGELOEST. Hypothese BESTAETIGT, mit einer Praezisierung.
(Zitate transliteriert ae/oe/ue wegen ASCII-Pflicht; jsonl-Zeilen = Anker im Backup.)

== 1. CHRONOLOGIE DER OWNER-AUSSAGEN (alles 982-Backup + Ledger) ==
(a) 06.07. ~13:5x, verlauf-01.txt:359 (regulaere User-Msg, daher kein jsonl-Anker in den
    ergaenzung-Dateien): "Bezueglich der pipeline faellt auf, dass die unit tests noch eine
    manuelle Aktion sind, aber die direktive ist strikt gruen, also auch nichts auslassen.
    Ohne Tests wissen wir nicht, ob alle Komponenten weiterhin funktionieren."
(b) 06.07. 14:08:27, verlauf-queued-ergaenzung-01.txt:35 / jsonl:1623 = nr26 (Lazy, Test-Skip).
    Also: nr26 ist ~15 min JUENGER als (a) - Rekursivitaet allein entscheidet hier nicht.
(c) 06.07. ABENDS, SELBER TAG, LEDGER:589 - "USER-KORREKTUR abends, bindend - #277-Lazy-
    Definition PRAEZISIERT; supersediert die rules-basierte Auslegung von 5648774". Wortlaut:
    "Die Fehler muessen behoben werden, nicht der Test geloescht" ... "#277 (nur Aenderungen neu
    kompilieren/testen) realisiert sich AUSSCHLIESSLICH ueber Caches (ccache, per-Tool-citools,
    kuenftig Tier-Binary-Resume), NIE ueber Job-/Trigger-Skips." FIX: Revert super 2a34d00
    (alle 5 rules-Blocke raus). => Das ist die spaeteste Aussage DES TAGES und sie liest nr26
    selbst als Cache-Ebene, nicht als Test-Ebene. Anlass war genau ein Skip-Schaden
    (trigger:thesis entfiel, weil der Submodul-Pointer unveraendert war).
(d) 17.07. 18:18:17, jsonl:50288: "Bitte merke dir, dass die gesamte pipeline IMMER hart gruen
    sein muss." (neueste Owner-Aussage zur GATE-Ebene)
(e) 18.07. 19:17:40, jsonl:55451: Cache-Strategie-Auftrag - "wie die zu kompilierenden CEB und
    Tier-Binaries gecached werden koennen und dass die CI erkennt, ob eine Organ-Achse sich
    bezueglich eines Achsen-Algorithmus geaendert hat, sodass nur BINARIES im Baum neu gebaut
    werden ... Eine Aenderung auf der CEB ... fuehrt zur vollstaendigen Rekompilation."
    Kein Wort ueber Tests. Reine Bau-Artefakt-Ebene.
(f) 18.07. 19:52:49, jsonl:55545: Ablage-Orte (CEB-/Tier-Compiles per NFS auf prod-HDDs, Rest
    gitlab-cache auf dev) - wieder nur Artefakte.
(g) 21.07., LEDGER:3270 (§63-GO-STEMPEL): "alle Punkte bis hierhin freigegeben. Volles autonomes
    GO" - deckt explizit Dossier #46a+#53 inkl. Verdikt "development-docs-Gate".
(h) 23.07. 12:02:37, jsonl:76257: Tools zusaetzlich in die minio-Lagerhaltung/ccache.
Weitere Owner-Treffer zu lazy (jsonl:28392 "was ist run lazy?", jsonl:55453 "Experiment Baum hat
schon lazy Materialisierung") betreffen Planer/Experiment-Baum-Materialisierung, nicht Tests.
Ergebnis der Suche: NACH 06.07. gibt es KEINE Owner-Aussage, die einen Test-Skip fordert.

== 2. IST-CI (Skip-Mechaniken heute, .gitlab-ci.yml) ==
- Test-Gate HART: :230-243 "User-Direktive 06.07.: strikt gruen = Tests NIE manual/auslassen ->
  automatisch + HART (kein allow_failure)"; test:unit = ctest -L da_unit, kein allow_failure.
- Genau EIN autorisierter Job-Skip: .code-rules :119-131 = docs-only-Allowlist. main laeuft
  IMMER voll; Code/**, Code/external/* (Gitlink-Bump), thesis-Gitlink, .gitmodules, .gitlab-ci.yml
  triggern. Selbst-Doktrin :117-118: "'gesamte Pipeline hart gruen' bezieht sich auf den CODE-
  Stand - ein docs-only-Commit aendert keinen Code, der Beweis der Vorwelle bleibt gueltig
  (Skip != gelb)". lint:secrets ist ungegatet, immer (:205-211).
- Trigger-Gates :251-262/:270/:289 tragen jeweils den Gitlink-Pfad => "nie faelschlich
  uebersprungen" - die 06.07.-Regression (c) ist konstruktiv verbaut.
- Bau-Ebene: GN_DECISION=skip (:902, :939-947, :984) heisst NICHT "Test uebersprungen", sondern
  "bereits im Cluster gebaut -> Warm-Cache PULL statt Neubau"; feine Invalidierung per
  dll_is_current/algo_sig (:913, :924, :952, :1007) = genau (e). Teil-Pull -> nur Fehlende neu.
- Verbleibende allow_failure sind Mess-/opt-in-Bahnen, nicht Test-Gates (:1339 320er-Ergebnis-
  Holen when:manual+allow_failure); Ledger CI-6 (:281) erlaubt allow_failure/manual nur als
  Probelauf einer NEUEN Stage bis zum ersten gruenen Beweis (ce test:unit advisory, :233).

== 3. AUFLOESUNG ==
Zwei Ebenen, kein Widerspruch:
- BAU-Ebene (lazy erlaubt und Pflicht): Binary-/Objekt-Reuse mit Beweis - ccache, per-Tool-
  citools-Caches, minio-Lagerhaltung/NFS, GN_DECISION-Dedup, dll_is_current/algo_sig je
  Organ-Achsen-Algorithmus-Version. CEB-Aenderung => Voll-Rekompilation. Quelle: (c),(e),(f),(h).
- GATE-Ebene (hart, kein Skip): Tests werden nie manual, nie allow_failure, nie weggegatet;
  Voll-ctest je Welle bleibt. Quelle: (a),(c),(d) + CI :230-243.
- EINZIGE autorisierte Ausnahme, spaeter erteilt: docs-only-Welle auf Nicht-main-Branches
  (#53-Gate, GO (g)). Kriterium ist "kein Code veraendert", NICHT "Modul unveraendert" -
  Gitlink-Bumps gelten ausdruecklich als Code. Das ist kein Test-Skip nach nr26-Lesart.
Damit gilt der Test-Skip aus nr26 NICHT mehr - er wurde am 06.07. vom Owner selbst auf die
Cache-Ebene umdefiniert und danach nie wieder gefordert.

== 4. WAS DIE QUELLEN NICHT ENTSCHEIDEN (explizit) ==
Der in E-26 formulierte Rest bleibt offen und ist NICHT aus den 982 Records belegbar:
docs/sessions/20260726-SESSION-wahrheits-anker-voll-abgleich-982-E01-E26.md:123-128 stellt die
Frage "Skip mit Fingerprint-Beweis erlaubt, oder Voll-ctest bleibt Pflicht?" - naemlich fuer den
Fall CODE hat sich geaendert, aber ein Fingerprint beweist, dass eine bestimmte Test-Teilmenge
nicht betroffen ist. Dazu existiert keine Owner-Aussage. Bis zu einem Entscheid gilt der
Default aus (d): Voll-ctest. W6 (doc:139) ist damit auf diesen Sonderfall zu schrumpfen, nicht
mehr als Grundsatz-Widerspruch zu fuehren.
Ebenfalls nicht quellenbelegt: dass (g) bewusst als Ausnahme zu (c) erteilt wurde - der GO
deckt "#53 inkl. development-docs-Gate" pauschal, eine explizite Owner-Abwaegung gegen das
"NIE ueber Job-Skips" aus (c) steht nirgends. Bewertung: Erlaubnis vorhanden, aber duenn belegt.

Selbstcheck: grep -P '[^\x00-\x7F]' auf diese Antwort = 0 Treffer (ASCII-only, § nicht verwendet).
