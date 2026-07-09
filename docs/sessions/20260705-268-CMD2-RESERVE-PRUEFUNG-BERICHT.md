# #268 — CMD-2-Reserve-Prüfung (Bericht) · 2026-07-05

**Auftrag (Ledger §13.3 #268):** Container-Metriken-Bedarf von CMD-2/#252 bestimmen; ≤2 → Reserve `axis_stats[0][6..7]` layout-neutral (sizeof==1416 bleibt); >2 → STOPP + explizite User-Freigabe für den EINEN 4→5-Bump. **NUR Bericht — kein Bump, keine Edits.**
**Methode:** read-only-Kartierung (Explore-Agent, thorough) über POD, abi_adapter-Fill-Pfad, ObservableComposedContainer, Masterplan-cmd-visitor, Memory-Direktive #252, Ledger.

## VERDIKT: RESERVE-REICHT — KEIN 4→5-Bump durch CMD-2 nötig (Confidence hoch)

Unter dem BESCHLOSSENEN Scope (User-Entscheid E2 vom 2026-07-02, Masterplan §5: **Sidecar**, „axis_stats bleibt unangetastet" + Variante (a): ContainerObserver bleibt der echten Container-Gattung reserviert) braucht CMD-2 **0 neue POD-Spalten**. Selbst bei Umdeutung auf harte DLL-Grenzen-Marker wären es **≤2** (z. B. container_op_count + container_bytes_touched) → passt exakt in die verifizierte Reserve `[0][6..7]`. **>2 entsteht NUR bei Umdeutung auf die volle Container-GATTUNG** (13 Achsen inkl. inner_container, Masterplan-Variante (b)) — die #252/E2 explizit ausschließen.

## Belege (Kurzfassung, datei:zeile)

1. **POD-Reserve verifiziert:** `observable_tier.hpp:127-144` — `axis_stats[19][8]` (kV3AxisCount=19 Z.47, kV3FieldCount=8 Z.50); sizeof-Nachrechnung 19·8·8+19·8+4·8+2·8 = **1416** ✓, Version 5 (Z.152-153). T0-Schema `kV3AxisSchema[0]` (Z.67): `{lookup,hit,miss,insert,erase,peak,nullptr,nullptr}` → **[0][6..7] = Reserve**. Laufzeit-Beleg: `abi_adapter.hpp:949-971` nullt alle Slots und schreibt T0 nur r[0..5] → [0][6..7] bleiben 0 = echte layout-neutrale Reserve. (Nebenbefund: T7 nutzt faktisch r[6]/r[7] `abi_adapter.hpp:1069-1070`, Schema-Tabelle dort unvollständig — reiner Doku-Hinweis, für #268 irrelevant.)
2. **CMD-2-Bedarf:** Keine Quelle enumeriert konkrete neue uint64-Spalten. Memory-Direktive #252 (User 02.07.): Container werden IN der SA-Achse mitgemessen und „aufgeschlüsselt"; Masterplan §4: „SA-Store-Anteil wird heute schon über T4/T5/T6 (+T11/T13) gemessen", Attribution = Etikettierung/Aggregation; **§5-E2 (✅ ENTSCHIEDEN): Sidecar, axis_stats unangetastet, ContainerObserver-Gattungs-Reservierung bleibt (Variante a)**.
3. **Ist ContainerObserver:** Gattungs-Kategorie LEER (`axis_observer_classification.hpp:12-14,29`: reserviert für echte Container-Gattung, „Aktuell 0 Einträge"); `ObservableComposedContainer` liefert die 6 SA-Zähler + for_each_record/DEG-1 + store_allocator_statistics-Durchreiche; CMD-2-Attribution existiert im Code noch NICHT (grep 0).
4. **Zählung nicht-host-ableitbarer neuer uint64-Spalten im beschlossenen Scope: 0.** (c1 Zugriffs-Anzahl ≡ Summe axis_stats[0][0,3,4]; c2 Anteil = host-Ratio; c3 Store-Anteil = Host-Aggregation bereits transportierter T4/T5/T6/T11/T13-Spalten; c4 inner_container = Gattung = ausgeschlossen.)

## Offene Klärfrage an den User (blockiert NICHT — beide Lesarten = kein Bump)

**Mechanik-Widerspruch zweier Single-Source-Aussagen:** Masterplan §5-E2 (02.07., „✅ ENTSCHIEDEN") = Host-**Sidecar**, axis_stats unangetastet ↔ Ledger #268/§3-S6 (04./05.07.) = Reserve-Nutzung **[0][6..7]**. Empfehlung: **E2-Sidecar gilt** (jüngere Ledger-Zeilen zitieren die Reserve nur als Obergrenze-Fallback); Reserve [0][6..7] bleibt unbeschrieben, bis ein harter Grenzen-Marker konkret gebraucht wird. Bitte bestätigen oder Reserve-Modell wählen.

**Randbedingung (bindend, aus §13.10-W3):** Falls CMD-2 doch Mess-Pfad/CSV berührt: Änderungen VOR dem #156-Voll-Lauf, 162-Spalten-WIDE strikt additiv, Re-Build-Pflicht aller DLLs.

**Konsequenz für §3-S6/§4:** Der „EINE erlaubte 4→5-Bump" wird von CMD-2 im beschlossenen Scope NICHT konsumiert — er bleibt unverbraucht in Reserve für einen künftigen echten Bedarf (z. B. Container-Gattung nach #215). Kein Bump ohne explizite User-Freigabe (Tabu unverändert).
