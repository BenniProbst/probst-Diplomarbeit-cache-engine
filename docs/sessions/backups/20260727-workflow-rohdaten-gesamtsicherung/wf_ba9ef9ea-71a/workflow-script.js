export const meta = {
  name: 'od-gegenlese-v4-kartierung',
  description: 'Explore-Gegenlese der bereits getroffenen Bauplan-Gate-Entscheide + OD-9-Auseinanderhaltung + V4-Kartierung (load_framework=Mess-Realm, target_isa-Komplex, telemetry)',
  phases: [
    { title: 'Erhebung', detail: '3 parallele Fable-xhigh-Straenge' },
    { title: 'Synthese', detail: 'TEIL-IV-Entwurf + Restfragen' },
  ],
}

const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const COMMON = `Du bist ein Fable-5-xhigh-Erhebungs-Agent der Diplomarbeit-Session (26.07.2026, abends).
Repo super = ${SUPER}; ce = super/Code/external/comdare-cache-engine (HEAD a3644cb8).
BINDENDE REGELN: NUR lesen/grep, KEINE Datei-Aenderungen, KEINE Commits. ASCII-only-Meldung (nur Paragraph-Zeichen erlaubt). Jede Behauptung mit Quelle datei:zeile bzw. jsonl:zeile. Owner-Zitate transliteriert-verbatim. Kein Haken ohne literale Ausgabe. NIE Token/Secrets in die Meldung. Das Haupt-Transkript /home/comdare/.claude/projects/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489.jsonl darfst du gezielt GREPPEN (python3 -c mit re/json je Zeile ist als Scanner sanktioniert), aber NIE in Dateien kopieren (enthaelt Live-Tokens).
KONTEXT-KANON (neuester Stand, Ledger §69 + docs/sessions/20260726-SESSION-od-antworten-load-framework-mess-realm-target-isa-komplex.md): load_framework = MESS-Meta-Meta-HAUPT-Achse am Planer (NICHT external_utils-Hub); target_isa = Komplex-Achse in sich (feste Glieder RAM-Frequenz+CAS+CPU-Fabrikation); telemetry zweigeteilt (Mess-RT-Unter + System-CT-Haupt); System-Haupt = GENAU DREI Komplex-Glieder; golden-neutral ratifiziert (N=2^17, CRC64 0x56F1B721C72DC10E).`

phase('Erhebung')
const [gates, od9, v4] = await parallel([
  () => agent(`${COMMON}

AUFGABE STRANG A (Gate-Entscheide finden + gegenlesen): Der Owner sagt, die Entscheide zu den Bauplan-Gates sind BEREITS GETROFFEN und sollen ausfindig gemacht + gezielt gegengelesen werden. Suche fuer JEDES der folgenden Gates den Owner-Wortlaut in den Quellen und liefere Fundstelle + transliteriertes Zitat + Verdikt (ENTSCHIEDEN mit Inhalt X / WIRKLICH OFFEN):
- O-1r: Eltern-Achse der compiler-GRUPPE (compiler+opt_level+atomic128) - wo haengt die Gruppe? (Hinweis: OD-2 sagt jetzt target_isa=Komplex-in-sich; die Gruppe koennte dort oder an der grossen Komplex-Achse haengen.)
- O-2: XSD-Revision + Parser fuer target_isa-Unter-Achsen (numa_node/page) bauen ODER 'Registry-only, Konsument vertagt'?
- O-3: CSV-Sichtbarkeit gesperrter Perms - zusaetzlicher D1-Marker-Datensatz ja/nein (Inventar-Zeile B ist bindend)?
- O-4: Maschinen-Identifikation fuer active_machine_signature (COMDARE_MACHINE_ID + cpuid-Fallback?)
- O-5: hugetlbfs-Fehlerklasse compile-seitig (BetriebssystemFeatureFehlt) ODER nur runtime SourceUnavailable/Failed?
- O-6: CI-Fallback-Matrizen (.gitlab-ci.yml:1048/:1053/:1073) auf 12 Perms mitziehen ODER nur planer:delegate?
- O-9: V36.B-Codegen-CMake Gate-Hook einbauen ODER dauerhaft out-of-scope?
QUELLEN (in dieser Reihenfolge): (1) super docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (§§37/46/62/64/66/69 + V7-Block), (2) super docs/sessions/20260726-*.md (alle heutigen Session-Docs), (3) super docs/sessions/backups/20260726-session-plaintext-verlauf/verlauf-*.txt (Owner-Nachrichten; queued_command-Ergaenzungs-Dateien beachten), (4) das jsonl gezielt (grep nach Schluesselwoertern wie 'Ofast', 'avx512', 'hugetlb', 'huge page', 'machine_id', 'Maschinen', 'CSV', 'failed', 'Matrix', 'Registry-only', 'XSD', 'compiler', 'opt_level'). MELDUNG: je Gate ein Block (Fundstelle(n), Zitat, Verdikt, Konfidenz); am Ende Liste der Gates OHNE Fund (ehrlich als WIRKLICH OFFEN melden, nichts erfinden). Selbstcheck-Zeile.`, { label: 'gates-explore', phase: 'Erhebung', effort: 'xhigh' }),

  () => agent(`${COMMON}

AUFGABE STRANG B (OD-9 auseinanderhalten): Der Owner wuenschte am Mittag (jsonl:79891, Q-0): 'Ich akzeptiere V2 Byte-Schnitt, volles GO. Ich wuensche mir dennoch V3 direkt mit rein, die Maschinen verkraften den Voll-Bau durch vorangegangene Optimierungen jetzt besser.' Dieses ALT-'V3' bezog sich auf den STRUKT-R-Byte-Schnitt (V2/V3-Mengen der STRUKT-R-Welle - was genau die V3-MENGE dort war, ist zu erheben: Memory project_achsen_neuordnung sagt 'ORG-18+Suffix (V3-Menge) fest drin'). Der Owner sagt HEUTE ABEND (OD-9): 'Bauplan V3 liegt im session Backup und deckt deinen Vorschlaeg vollstaendig ab, bitte ultracode um das auseinanderzuhalten und zieh es durch, volles GO.'
LIEFERE: (1) Rekonstruktion der Alt-V3-MENGE (STRUKT-R-Kontext: was gehoerte zum 'V3 direkt mit rein'-Umfang? Quellen: jsonl um :79891 herum gezielt greppen, verlauf-31/32, docs/sessions/20260726-SESSION-achsen-neuordnung-*.md, Memory-Erwaehnungen, Dossier 2470f667); (2) ABDECKUNGS-MATRIX: je Element der Alt-V3-Menge die Stelle im Bauplan-v3-Doc (${SUPER}/docs/sessions/20260726-BAUPLAN-V2-lane-a-sys-tax-lane-c-hub-ADVERSARIAL.md, TEIL I+II+III) bzw. im Ist-Code (schon gelandet, z.B. ORG-18 = ce 774a5d5f/fcd95a44, Suffix = Lane F), die es abdeckt; (3) VERDIKT: vollstaendig abgedeckt ja/nein; Restpunkte explizit. MELDUNG kompakt, jede Zeile mit Beleg. Selbstcheck-Zeile.`, { label: 'od9-auseinanderhaltung', phase: 'Erhebung', effort: 'xhigh' }),

  () => agent(`${COMMON}

AUFGABE STRANG C (V4-KARTIERUNG K1-K5): Kartiere ALLE Stellen, die von den drei Neuerungen beruehrt sind, mit LIVE datei:zeile (an ce a3644cb8 / super HEAD lesen, nichts aus dem Gedaechtnis):
K1 load_framework -> MESS-REALM: (a) alle Doc-Stellen, die 'load_framework = erste Meta-Meta unter external_utils-Hub' tragen (Bauplan-Doc TEIL I+II, Ledger inkl. der heutigen Vermerke aus Commit 0661a6f3, Konsolidierungs-Anker ab4642c1 - nur BENENNEN mit Zeile, nicht aendern); (b) Code-Stellen: ce include/cache_engine/measurement/system_axis_registry.xml:114-117 (load_framework-Top-Level), load_framework_system_axis.hpp (sub_axis workload), measurement_tooling_registry.hpp, abi/system_axis_code_versions.hpp (5er-Tabelle), abi/system_axis_order.hpp, anatomy_version_stamp.hpp (Stempel-Zeile), Suffix-Emitter; (c) WOHIN im Mess-Realm zieht die Einhaengung um - finde die Mess-/Planer-Registry-Struktur (measurement_tooling_registry.hpp? experiment_plan_director? Planer-Version?) und schlage den konkreten Ziel-Ort + Stempel-Traeger (Mess-Zeile) vor, mit Beleg warum dort.
K2 C-1-Zuschnitt: was aendert sich am geplanten hardware_meta_meta_axis.hpp (nur System-Meta-Metas) und entfaellt die D2.5-Abhaengigkeit A3->C-1 wirklich (pruefe, ob die XML-Einhaengung von load_framework unter den Hub der EINZIGE Grund der Abhaengigkeit war - Bauplan TEIL II D2.5/D3.1)?
K4 target_isa=Komplex-in-sich: welche Bauplan-/Code-Stellen brauchen den Wrapper-Typ (A3-Paket, ceb_complex_system_axis-Entwurf im LaneC-Scratchpad scratchpad-Verweis nur benennen, target_isa_system_axis.hpp, Stempel-Identitaets-Zeile, Registry-XML target_isa-Block :98-101)? Wie werden RAM-Frequenz/CAS/CPU-Fabrikation als feste Glieder repraesentiert (Vorschlag mit Muster-Beleg, z.B. analog machine_signatures oder als feste Identitaets-Konstanten)?
K5 telemetry zweigeteilt: Ist-Stellen (registry_to_axis_levels.hpp telemetry-Level, profile_run_facade.cpp +tel=silent :401, test_br1_full22_count.cpp:69-71, Q-13-Doc-Stellen) - was bleibt, was wird Dual-Natur-Register-Zeile?
MELDUNG: je K-Punkt eine Stellen-Tabelle (datei:zeile -> was dort steht -> was V4 daraus macht) + am Ende: konkrete TEIL-IV-Textbausteine (Paket-Umformulierungen) + Liste ECHTER Restfragen an den Owner (nur was Quellen+Code nicht hergeben). Selbstcheck-Zeile.`, { label: 'v4-kartierung', phase: 'Erhebung', effort: 'xhigh' }),
])

phase('Synthese')
const synthese = await agent(`Du bist der Fable-5-xhigh-Synthese-Agent. Konsolidiere die drei Erhebungs-Ergebnisse zu EINEM abschliessenden Bericht (ASCII-only, nur Paragraph-Zeichen erlaubt, keine Datei-Schreibvorgaenge):

=== STRANG A (Gate-Entscheide) ===
${typeof gates === 'string' ? gates : JSON.stringify(gates)}

=== STRANG B (OD-9) ===
${typeof od9 === 'string' ? od9 : JSON.stringify(od9)}

=== STRANG C (V4-Kartierung) ===
${typeof v4 === 'string' ? v4 : JSON.stringify(v4)}

LIEFERE: (1) GATE-REGISTER final: je O-1r/O-2/O-3/O-4/O-5/O-6/O-9 das Verdikt ENTSCHIEDEN(Inhalt+Beleg)/OFFEN - Widersprueche zwischen Straengen aufloesen (neueste Owner-Aussage gewinnt), nichts erfinden; (2) OD-9-Verdikt (Abdeckung + Restpunkte); (3) TEIL-IV-ENTWURF als fertiger Markdown-Text (Kopf + praezisierte Paket-Texte K1-K5 + aktualisierte Abhaengigkeiten/Sperrmengen + Gate-Register + naechste Bau-Schritte in Reihenfolge) - direkt anhaengbar ans Bauplan-Doc; (4) RESTFRAGEN an den Owner (nur echte, mit Begruendung warum unaufloesbar). Selbstcheck-Zeile (ASCII-Bestaetigung, Quellen-Vollstaendigkeit).`, { label: 'synthese-teil-iv', phase: 'Synthese', effort: 'xhigh' })

return { gates, od9, v4, synthese }