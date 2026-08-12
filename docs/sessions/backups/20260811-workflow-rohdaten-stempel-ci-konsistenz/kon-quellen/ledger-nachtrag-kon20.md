## NACHTRAG 12.08.2026 — KON20: DIE ZWEI WELTEN SIND KARTIERT, DAS REGISTER IST ERSTBEFÜLLT (WF2)

**Der Explore-Auftrag aus KON15-02 ist erfüllt** (9 Agenten, 0 Fehler, jede Kernaussage am Objekt
gegengeprüft). Volltext: `docs/sessions/20260812-WF2-SYNTHESE-zwei-welten-der-glieder-reihenfolge-
und-register-leerer-klassen.md`. **S-6 bleibt gesperrt bis zur Owner-Antwort auf fünf Fragen unten
— aber die Sperre ist jetzt eine Entscheidungs-Sperre, keine Wissens-Sperre mehr.**

---

### KON20-01 — 🔴 DER PRÄZISE GEHALT DER „ZWEI WELTEN": ES SIND DREI ORDNUNGEN AUF EINER EBENE — UND KEINE WACHE DAZWISCHEN

    HASH/SCHLUESSEL-EBENE     EINE WELT. anatomy_fingerprint_glieder() ist "DIE EINE
                              QUELLE"; das Lager rechnet NICHTS nach (uebernimmt den
                              fertigen 128-hex als Blattwert, prueft nur die Form);
                              BinaryKeyPolicy WIRFT bei !=9 Gliedern.
    UNTERACHSEN-EBENE         GEMEINSAME, GEWACHTE QUELLEN. System: kSystemAxisOrder
                              wird von aussen UND vom Lager GELESEN, nicht nachgebildet.
                              Organ: organ_gruppen_ebenen() ist die EINZIGE echte
                              Konversion (T0..T17 -> 5 Lager-Gruppen), compile-time
                              bewiesen 18=18.
    KATEGORIEN-EBENE          HIER liegen die zwei Welten -- genauer DREI Ordnungen:
      aussen                  ORGAN -> SYSTEM -> MEASUREMENT   (11 Belegstellen)
      Lager/Messdaten         MESS -> SYSTEM -> ORGAN          (D-12, CT-erzwungen)
      Lager/Binaries          SYSTEM -> ORGAN -> MESS          (D-12, CT-erzwungen)
                              KEINE gemeinsame Quelle, KEINE Konversion, KEINE WACHE --
                              heute konsistent NUR durch Disziplin und Kopf-Kommentar.

**🔴 Der vom Owner befürchtete verdeckte Bruch sitzt genau auf der Kategorien-Ebene** — nicht in
der Hash-Berechnung. Und: die Außen-IST-Ordnung ist die **einzige Ordnung im Haus, die
„System vor Organ" nicht hält** — beide Lager-Kaskaden halten es.

**Bemerkenswerte Feststellung (keine Deutung):** das SOLL `M,S,O` entspricht exakt der
**Messdaten-Kaskade**, das ältere „System vorn, Organ hinten" der **Binaries-Kaskade**.

---

### KON20-02 — WAS FÜR S-6 FOLGT: EINGRIFFSKARTE UND VERBOTSZONEN

**Die heutige POD-Folge ist in sich konsistent (ja) und dem SOLL entsprechend (nein).** Das SOLL
(`MESS,SYSTEM,ORGAN`, KON6-02 Punkt 4) ist eine **Neuordnung, keine Wiederherstellung** — 0 Treffer
vor dem 10.08. über zehn Wochen.

    EINGRIFF (falls SOLL bestaetigt) an DREI Aussen-Kostenebenen:
      1. Makro-Argumentfolge   anatomy_module_abi_v1.hpp:162/:213      (golden-Bruch)
      2. POD-Feldfolge         anatomy_module_abi_v1_decl.hpp:200-243  (ABI-Bruch;
                               APPEND-ONLY => Umordnung NUR mit Layout-Bump)
      3. Preimage-Glied-Folge  anatomy_fingerprint.hpp:591-603 + Zwillinge/Fixierer
                               (invalidiert alle Fingerprints; VOR F2 -- heute kostenlos)
    Der Lager-Schluessel WANDERT AUTOMATISCH MIT (ordnungsblind) -- dort ist NICHTS zu aendern.

    VERBOTEN: die zwei Lager-Kaskaden samt kOrganGruppen* (Owner 08.08., D-12, CT-erzwungen)
              · kSystemAxisOrder · kCompositionAxisNames · die 5-Gruppen-Konversion
              · die Hash-Mechanik (kein zweiter Preimage-Weg, A13-M3)
              · das orthogonale Messwert-2-Tupel {Fingerprint, Hardware}

**Aufgelöste Nebenpunkte:** „7 vs. 9 Glieder" = kein Widerspruch (9 gesamt, 7 träger-relevant,
davon 4 typ-gepinnt; **die vorderen 3 — organ, system, measurement — sind rohe typgleiche
`string_view` ohne Positions-Pin: eine Vertauschung kompiliert unbemerkt**; der CEB-Pfad übergibt
organ+system ohnehin leer) · KON14-02s Messung war korrekt, nur das pauschale Urteil fehlte den
Lager-Vorbehalt · **Anker-Korrektur: „nur das Lager hat hier eine Ausnahme…" steht in KON6-02
Punkt 4, nicht in KON7** (Inhalt zweifach bestätigt, Anker in KON15-02 und Memory ungenau) ·
ein zweiter, anderer „S-6" (gcc|clang) lebt im Ledger — **vor jeder Posten-Referenz den Gegenstand
prüfen, nie die Nummer** (deckt sich mit der OV-Nummern-Doktrin).

---

### KON20-03 — DIE FÜNF S-6-FRAGEN AN DEN OWNER (bis dahin bleibt S-6 gesperrt)

    1. Gilt SOLL = MESS,SYSTEM,ORGAN fuer ALLE DREI Aussen-Ebenen -- und meint
       #87 die Funktions-/Makro-Argumentfolge, #78 die Zeilen-/POD-Folge?
    2. WELCHER REALM gibt die Preimage-Ordnung vor? Derselbe Fingerprint ist
       Binary-Identitaet (Binaries-Welt, S,O,M) UND Messdaten-Skip-Marke
       (Messdaten-Welt, M,S,O). In keinem Dokument beantwortet.
    3. Soll eine KATEGORIEN-ORDNUNGS-WACHE (Analogon zu organ_gruppen_decken_
       die_komposition) als neuer Posten zu S-6 hinzukommen? (Heute haelt die
       Konsistenz nur Disziplin.)
    4. Transpositions-Sperre fuer die drei rohen string_view-Glieder
       (ordnungsunabhaengig, Ledger-gedeckt KON7-10/4): MIT S-6 oder VORGEZOGEN?
    5. Posten #67 ("4 Familien, 142 Include-Kanten", in S-6 gebuendelt): die
       Zahlen sind laut KON13-08 unbelegt -- streichen, entkoppeln oder belegen?

---

### KON20-04 — DAS REGISTER DER LEEREN KLASSEN: ERSTBEFÜLLUNG (KON15-01)

**Kernbefund: es gibt KEINE EINZIGE unbenannte Hülle.** Jede gefundene ist im Code oder in den
Plänen selbst deklariert (DEFERRED / SKELETT / Stub / `[[deprecated]]` / „bewusst ungesetzt").
**Die Lücken liegen in der Wellen-Zuordnung und Eigentümerschaft, nicht im Verschweigen.**

    Nenner: 1351 Quelldateien gescannt · 164 leere Ruempfe, davon 117 Tag-Dispatch
    · 34 einzeln gelesen · 7 Nur-Ctor/Dtor geprueft · ~1175 kleine Structs teilgeprueft

**Echte Hüllen mit Wellen-Platz (terminiert):** `BreakEvenPoint`-SKELETON → S-15/HY-B, echte
Kurven HY-C · `decision_lambda_trees` → HY-C · `ergebnis:holen`-Job-Skelett → W2/D3-8 (⚠️ Spannung
zu KON16-03 „keine YAML" — vor W2 zu klären).

**🔴 Echte Zuordnungs-Lücken (Owner-Entscheid nötig):**

    K2  P/E-CORE-CLUSTER ohne Wellen-Platz: ICpuCore/ICoreLayout/CoreClass,
        has_hybrid_cores, CPUID-Leaf 0x1A -- Interface ohne EINEN Implementierer,
        Leaf nirgends gelesen, Feld nie gesetzt. §16.3-E17 (16.07.): "deep research
        Pflicht" NICHT eingeloest. KEIN Posten in S-1..S-18/O/HY.
    K4  das mess/-SUBSYSTEM (Steuerkanal, Konfiguration) hat KEINE S-Position --
        S-9/S-10 naheliegend, unbelegt. Zuordnen oder als 19. Position benennen.
    K5  DREI Skelett-Testverzeichnisse (integration, generic_module_tests,
        module_specific_tests) seit 06.07. ohne Eigentuemer -- fuellen, terminieren
        oder deprecaten.
    K3  i_command.hpp: Einordnung weiter offen (Nachfolger AxisCommand steht).
    K1  das Register selbst braucht Ablageort + Pflegeregel (Owner: Doku nur auf
        User-Geheiss) -- die Erstbefuellung liegt in der WF2-Synthese.

**Präzisierung:** `CodegenEngine` ist **keine** Klassen-Hülle — substanziell, 1 Produktionsaufrufer;
quarantänisiert ist nur der prtart-Stub-Pfad. Grenze „NICHT erweitern" (Bauplan 19.07.) bleibt.

---

### KON20-05 — BETRIEBSNOTIZ: DER KÖDER-GENERATOR WAR SELBST DIE FALLE

Die gitleaks-Gegenprobe zu diesem Lauf schlug beim ersten Mal fehl — **der Köder hatte 19 Zeichen**.
Das Standard-Rezept (`head -c 15 /dev/urandom | base64 | tr -dc 'A-Za-z0-9'`) liefert
**nicht-deterministisch 19 oder 20 Zeichen**, je nach `+`/`/`-Anteil im base64. Mit korrektem
20-Zeichen-Köder (40 Input-Bytes) **beißt der Scanner** (`leaks found: 1`), und die Null über die
WF2-Rohdaten (6,02 MB, `no leaks found`) ist gedeckt. → Fallen-Register ergänzt: **Köder-Länge
prüfen, bevor die Gegenprobe zählt.**
