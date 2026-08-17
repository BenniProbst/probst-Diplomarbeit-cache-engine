# SOLL-IST-AUDIT HY-A / VL-3 — VOLLBERICHT (Teammate audit-hya-vl3-soll-ist, 17.08. ~21:05)
# + LEAD-KLAERUNG (dreiwertig, direkt im Anschluss)

MESSORT: ce @ 6cdcf1c9, read-only.

## (1) BAU-BUCHUNGS-FEHLER [Lead-Verdikt: TEIL-BESTAETIGT/TEIL-KORRIGIERT]
Auditor: Strang-lokale Bilanzen als Landungs-Beleg gebucht; "Wiederanlauf fand nie statt";
Push trotz fehlender Kombibau-Bilanz (A2.1a uebersprungen).
LEAD-KLAERUNG AM OBJEKT: Die Steward-Kombibau-Logs EXISTIEREN (/tmp/ct_w1_{gcc,clang}-{rel,dbg}.log,
20:28-20:37, + rotprobe/gruenprobe des T-1-Belegs) — alle 4 literal "100% tests passed, 0 tests
failed out of 499"; jetzt gesichert unter kombibau-logs-steward/ (BU dieses Ordners). Der Satz
"nie stattgefunden" ist damit WIDERLEGT (Auditor sah nur ~/wt-ce-*/build-protokolle/, nicht /tmp).
ABER DER KERN HAELT: Die LANDE-GATE-KETTE (clang-format mit CI-Formel + Diff-Hygiene-Wache +
axis-version-lock-Check) lief vor dem Push NICHT — der Kombibau deckt Bau+ctest, NICHT die Wachen.
CI-15971-Rot ist die Quittung. Fehler-Ort: der LEAD (Push auf "LANDEBEREIT: JA" ohne eigene
Gate-Kette), nicht der Steward (sein NICHT-GEPRUEFT-Block nannte die CI ehrlich).
ZWEITER FEHLER BESTAETIGT: kein Verbund-SOLL-Abgleich vor der Landung (HY-A2/Registry blieben
als "gelandet" stehen).

## (2) CI-15971-WURZELN [Lead: BESTAETIGT, Heilung gefahren]
A lint:format: 3 Dateien aus 3 Straengen — fehlende Stufe im Strang-Rezept (kein Einzelversehen).
B1 pruef_dock.hpp 27x Nicht-ASCII = ALTBESTAND V41-Aera; k2 (9d366502) zog die Datei nur in den
   push-lokalen Messbereich (bekanntes Diff-Hygiene-Muster). Heilung = Voll-Transliteration
   (Alt-Schuld-Posten, NICHT k2 anlasten). CAVE: hybrid/hybrid_pruef_dock.hpp ist eine ANDERE
   Datei mit 0 Nicht-ASCII.
B2/B3 >120-Zeilen hybrid_config_xml/test_hy_a3: HY-A3-Bau; Ur-Auftrag trug die 120er-Auflage
   nicht (Auftrags-Luecke, keine Ungehorsamkeit).
C axis-version-lock: 44a909c1 (k2) aenderte GENAU EINE Kommentarzeile (Fixture-Namens-Nachzug).
   Auditor-Empfehlung: NICHT bumpen, Kommentar zuruecknehmen (preimage-Sorge vor F2).
   LEAD-ENTSCHEID DAGEGEN, mit Begruendung: (i) der Quelltext-Digest ist mit 44a909c1 BEREITS
   GEPUSHT — das Register muss folgen, sonst Dauer-Rot; ein Revert waere ein ZWEITER
   Digest-Wechsel und wuerde die nach dem Weg-a-Umbau KORREKTE Fixture-Doku wieder entfernen;
   (ii) --write ist digest-only (kein Literal-Bump, A-14 gewahrt); (iii) Flotten-Doktrin:
   Identitaets-Umbauten sind bis 26.08. kostenlos, es existiert kein invalidierter Bestand.

## (3) NICHT GEBAUTE ZIELE [Lead: BESTAETIGT — Traeger gesetzt]
3a NIE BEGONNEN: hybrid_binary_proxy + hybrid_tier_module.cpp (4 ABI-Symbole) — 0 Treffer im
   Baum, nur Prosa (README:17-18 selbst-deklariert "NICHT gebaut", K2-gebunden);
   test_hy_a1_dock_contract.cpp:24-27 warnt selbst "KEIN Reroute-Beweis".
   URSACHE: Lead-AUFTRAGS-VERENGUNG auf "GENAU EIN Standard-Dock" — Proxy/.so/2 Reroute-Ziele
   wurden nie beauftragt; der Agent arbeitete korrekt. → #15/HY-A2 (decl-Slot).
   Registry-Achse 22->23: unbaubar, KEINE der vier Registries steht auf 22 (Ledger Z.13725) —
   E-6-Explore muss ZUERST die Ziel-Registry benennen. → #15/E-6.
   Hybrid-Fehlerklassen: 0 fehlerklasse=-Traeger in hybrid/ (Idiom-Gegenprobe 3 Module) —
   Parser-Kopf :55 deklariert die Luecke selbst. → HY-A2-Umfeld.
3b EXCLUDE_FROM_ALL-Sichtbarkeitsfalle: test_hy_a1_reroute_gate_negativ (:2152) +
   test_hy_a1_contract_token_negativ (:2227) — korrekt registriert, der Test IST der Bau
   (add_test ruft cmake --build), im all-Bau unsichtbar. Abnahme-Regel: ctest MUSS voll laufen.
3c F-9 Sichtbarkeits-Sentinel: vertagt auf HY-A2, mit HY-A2=null ohne Traeger. → #15-Umfeld.

## (4) VL-3 SECHS RESTPOSTEN [Lead: BESTAETIGT]
Alle 6 aus dem Lens-NICHT-GEPRUEFT-Block, keiner im Ur-Auftrag: (1) clang-Warnungs-Review =
HAUS-DAUERREGEL, PFLICHT (0 clang-Treffer im vl3-Protokoll; Gegenprobe: hy-a-clang22-Log
existiert) · (2) CI-Verdrahtung coverage-guard UNGEPRUEFT · (3) Allowlist vermutlich
gegenstandslos (Test liegt IM Bauweg; Beweis fehlt) · (4) Windows-_pclose statisch OFFEN ·
(5) --debug x dump|ci|cmake strukturell gedeckt (Strip vor Dispatch :645-686), testlich offen ·
(6) stdout-Bytevergleich = gebuchter W2-Posten (6cdcf1c9). Siebter (add_dependencies) BEHOBEN
316c488f.

## (5) STILL-VERLUST-LISTE + TSAN [Lead: TSan-Widerspruch ENTSCHAERFT]
1-3 (rot): HY-A2 komplett · Registry-Achse · Verbund-Kombibau — Punkte 1+2 getraegert (#15),
Punkt 3 durch Steward-Logs + CI-Nachweis gedeckt. 4-6 (gelb): VL-3-clang-Review + 5 Restposten +
F-9/Fehlerklassen — getraegert (W2 + #15-Umfeld). 7 TSan-Widerspruch: sanitize:tsan lief in
CI 15971 am VERBUND-Stand SUCCESS (Job 381041) — der Endstand ist belegt; die historische
"5/5"-Aussage KON109-02 bleibt als Strang-lokal markiert.

KERNSATZ (Auditor, bestaetigt): Von HY-A1/HY-A2/HY-A3+VL-3 sind HY-A1 und der Parser-Teil von
HY-A3 fertig; HY-A2 = 0%, Registry-Haelfte HY-A3 = 0%; VL-3 funktional komplett mit 6
unbewiesenen Flaechen. Geliefert 2 von 4 Teilstuecken der HY-A-Schaetzung.

QUELLEN: siehe Teammate-Bericht (Wellenplan Z.697/855-857/952/982/2146/2182 · Ledger Z.13725 u.a.
· Ur-Auftraege Transkript-Offsets 332517940/347556717 · lens-/uebergabe-BUs · CMakeLists:2152/2227
· axis_version.lock:1391).
