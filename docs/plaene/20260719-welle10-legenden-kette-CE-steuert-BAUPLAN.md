# W10 — Die dreistufige Legenden-Kette: CE erhaelt die XML und steuert ALLES (§42-Bauplan, 19.07. nachts)

> Quelle: Ledger §42 (User-Direktive verbatim) + §40.b-Praezisierung + §30-Kette. Ersetzt die STEUERUNGS-Rolle der
> statischen W4-Matrix (die bleibt uebergangsweise als gated Fallback und laeuft als 11509-Artefakt-Lieferant).

## Ziel-Topologie (exakt nach User-Spezifikation)

```
super-CI (statisch-minimal, NUR Delegation + Ergebnis-Holen):
  planer:delegate            -> baut Treiber, uebergibt ANWENDER-XML an die CE, legt Child-1-YAML (CE-emittiert) ab, triggert
  ergebnis:holen             -> sammelt Mess-/Bau-Ergebnisse (persist:measurements-Grundlage, CE-lib-Delegation)

Child-1 (CE-emittiert, Planer-Rolle — MESS-ACHSEN-Stufe):
  je Mess-Achsen-Kombination [a,b,c]:
    "ceb:build:[a,b,c]"      -> baut die CEB fuer diesen CEB-Typ (Messsystem)
    "ceb:emit:[a,b,c]"       -> die GEBAUTE CEB emittiert selbst Child-2 aus ihren einkompilierten System-Achsen-Freigaben (§37.b)
    "ceb:trigger:[a,b,c]"    -> Grandchild-Trigger

Child-2 (CEB-emittiert, je CEB — SYSTEM-ACHSEN-Stufe des FREIGEGEBENEN Raums):
  je freigegebene System-Perm [d,e,f]:
    "tier:build:[a,b,c][d,e,f]:chunk<k>" -> CEB-Raum permutiert System[d,e,f] x Organ[g,h,i] und baut die Tier-Binaries;
       Legende je BINARY = [d,e,f,g,h,i] im Artefakt-Pfad (bestehende binary_id-Pfad-Serialisierung axis=value);
       Job-Ebene buendelt als Chunk (2^17 Einzel-Jobs waeren keine Legende, sondern Rauschen)
  XOR (gated, nach 320er-Messung):
    "hybrid:pick:[d,e,f,g,h,i]"          -> Hybrid-Heuristik-Tier-Binary: static pick der AUSGEMESSENEN besten, KEINE Permutation
```

## Kern-Korrekturen gegenueber W7-Stand
1. **Mess-Achsen-Stufe existiert nicht -> einziehen:** Der Director-Walk beginnt kuenftig bei den MESS-Achsen aus der
   Anwender-XML (Mess-Registry-Parse existiert; Auswahl/Kombinatorik der XML = die [a,b,c]-Enumeration). `GN_MSYS="default"`
   wird durch die ECHTE Legende ersetzt (heute typisch EINE Kombination -> eine CEB — aber deklariert, nicht Platzhalter).
2. **Legenden-Namen:** Alle emittierten Job-/Pipeline-Namen tragen die Achsen-Arrays `[...]` (kurz, deterministisch,
   YAML-gequotet). Chunk-Jobs: Legende + Range.
3. **Stufe-2-Emission ist CEB-Hoheit:** `ceb:emit` ruft die gebaute Binary in der CEB-ROLLE (`--emit-tier-ci`), die NUR aus
   den einkompilierten Freigaben emittiert — nicht der Planer (§40.b-Praezisierung: Planer steuert CEB-Jobs, CEB steuert
   Tier-Jobs). Heute traegt EINE Binary beide Rollen (Fork A/C offen) — die Rollen-Trennung laeuft ueber getrennte
   CLI-Modi + getrennte Emissions-Sichten (ehrlich im Header dokumentiert, kein Schein-Split).
4. **super-CI schrumpft auf Delegation+Holen:** planer:delegate ersetzt die statische Matrix als Steuerung; die W4-Matrix
   bekommt ein DEPRECATED-Gate (COMDARE_STATIC_MATRIX_FALLBACK, Default aus nach W10-Abnahme) — nie loeschen, Pilot-Historie.
5. **Lokal identisch (§42: 'das Konzept der lokalen Compile damit auch'):** Der CMake-Pfad wird DREISTUFIG analog emittiert
   (CE emittiert plan-1 Mess->CEB; die gebaute CEB emittiert plan-2 System->Tier); MANUAL_RUN.md wird nachgezogen.
   super/Bare-Metal ruft nur die Einstiegs-Emission auf.

## Arbeitspakete
- **W10-A (ce, Director/Builder-Strang):** Mess-Achsen-Ebene in den Walk (XML-getrieben), Legenden-Namensschema
  (eine Formatierungs-Single-Source fuer [..]-Arrays), CiYaml-/CMakeGraph-Builder auf Stufe-1-Emission umstellen,
  NEU: CEB-Rollen-Emission `--emit-tier-ci`/`--emit-tier-cmake` (Stufe-2-Sicht aus Freigaben). Contract-Tests:
  Topologie 3-stufig, Legenden-Determinismus, Stufe-2 enthaelt NUR freigegebene System-Perms.
- **W10-B (super):** planer:delegate + ergebnis:holen; statische Matrix hinter Fallback-Gate; Lint beider Ebenen.
- **W10-C (lokal):** MANUAL_RUN.md-Nachzug + Bare-Metal-Beweis der dreistufigen Kette (kleines Fenster).

## Gates / Neutralitaet
Alle Emissionen deterministisch + GitLab-linted; statische Matrix bleibt bis zur W10-Abnahme funktional (Fallback);
binary_id/golden unberuehrt; Hybrid-Pfad bleibt GN-11/320er-gated. Abnahme §41-Meilenstein erfolgt gegen DIESE Kette.
