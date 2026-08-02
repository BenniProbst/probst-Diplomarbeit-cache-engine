# Codex-Adversarial-Review (gpt-5.6-sol ultra, 02.08. ~19:4x) — TP1 + Welle 1 + Welle 2a (Basis 7603453b)
Verdikt: 5x BLOCKIEREND, 6x MITTEL, 2x KLEIN. Statisch gegen 7603453b (bwrap-Sandbox auf prod1 defekt — bekannte Falle; kein Testlauf durch Codex).
B1 (TP1, BLOCK): Takeover released fremde Claims ohne Selection-/BatchTyp-Kopplung — Arbeit kann liegen bleiben; kein typ-Filter im Sweep. iterator:1043-1047 verwirft Ergebnis; Test simuliert Uebernahme via manuellem observe.
B2 (TP1, BLOCK): Realer CachePush (artifact_cache.hpp:271-307) wirft NICHT (log+return) -> failed_dirs() leer -> B-1-Fix greift nur bei werfenden Lambdas; Bestandslog vertraut unbestaetigtem Push. Transport-Fehler muss sichtbar werden (bool/throw).
B3 (TP1, MITTEL): epoch_from_utc_iso normalisiert unmoegliche Daten (29.02./31.04.) statt abzulehnen; parse_seconds ignoriert Endzeiger ('1junk'->1.0). Fail-closed-Haertung + Negativtests.
B4 (TP1, MITTEL): Vor-Lock-Kandidaten werden unter Lock nicht revalidiert -> 'uebernommen'-Zaehlung/Testat kann Nicht-Uebernahme loggen (done gewinnt korrekt im Merge).
B5 (TP1, KLEIN): provision_only fire_progress nutzt geschrumpften builds-Index j statt Fenster-Index -> Cursor-Kompression nach Lager-Skips.
B6 (W1, BLOCK): OS-Versions-Bump-Wache ist NUR Kommentar; einziger Anker ist der test_m_w12-Golden-String (dritter Weg vorhanden, aber indirekt). Expliziter static_assert ==v1.0.0 (Bump erfordert bewusste Doppel-Aenderung).
B7 (W1, MITTEL): FINAL-DREI-Wache tautologisch (array<...,3>) + Generator hartkodiert 3 Aufrufe statt Liste zu iterieren -> vierte Unterachse waere unbewacht emittierbar.
B8 (W1, MITTEL): Hybrid-Design-Doc fuehrt Q6-Punkte als offen, die der Owner-GO ~17:4x als Defaults freigab (eine Gattung, MaxN=8, 187(e) superseded) — Doc nachziehen (Lead).
B9 (W2a, BLOCK, OWNER-FRAGE): Stempel rendern historisch OHNE 'v' (@1.0.0); Owner-Q3 sagt 'beginnen mit v'. Gilt das v auch fuer die GERENDERTE Stempel-Form (@v1.0.0c) oder nur fuer die ROH-Literale (vX.Y.Zc im Code, Render praefix-frei wie bisher)? Entscheidet die Byte-Form ALLER Stempel im M3-Neuanker -> Q10 an Owner, blockiert NUR die M3-Migration.
B10 (W2a, BLOCK): Default-Resume verdraengt nicht_gebaut-Marker durch stale Erfolgs-CSV (Resume-Check vor !b.ok(); Fehlerzweige invalidieren per-Binary-CSV/Stamp nicht).
B11 (W2a, MITTEL): take_uint ohne Ueberlauf-/Leading-Zero-Wache -> Alias-Identitaeten (v4294967297.0.0c == v1.0.0c im Stempel, .algos roh verschieden).
B12 (W2a, MITTEL): Nicht-Organ-Registry-Wachen pruefen nicht 'parsbar' und nicht '!experimental' -> junk faellt still auf @0.0.0; v1.0.0ce passiert ENFORCE (ce-nie-e fehlt dort).
B13 (W2a, KLEIN): FK-1-Reader-Negativtest beweist nur Listen-Mitgliedschaft (strikter Nichtnumerik-Pfad verwirft ohnehin).
POSITIV: Flag-Parser-Kanten sauber (cc/ec/e/Gross/@/WS/Leer verworfen), Bit-Kodierung kollisionsfrei, Q2-Punktnamen ok, F1/F2-Fixes korrekt, FK-2 vollstaendig, kein ungeplanter Byte-Shift heute.
B9-AUFLOESUNG (Owner-Q10, ~19:5x): Option A — v nur im Roh-Literal, Render bleibt praefixfrei (@X.Y.Zc). KEIN Fix noetig; M1b-Stand korrekt.
