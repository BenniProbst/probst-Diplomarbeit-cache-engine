export const meta = {
  name: 'w1-vollstaendigkeit',
  description: 'W1-Vollstaendigkeits-Audit gegen Wellenplan (Owner-Zweifel 18.08.): jeder W1-Posten am Objekt, sequentiell',
  phases: [
    { title: 'Posten-Pruefung', detail: '8 Gruppen A-H, je ein Agent, strikt nacheinander' },
    { title: 'Synthese', detail: 'W1-Verdikt + Rest-Liste mit Frist-Zuordnung' },
  ],
}

const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'
const WT = '/home/comdare/wt-ce-bump15'
const WP = SUPER + '/docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md'
const DP = SUPER + '/docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-wellen.md'

const KOPF = `W1-VOLLSTAENDIGKEITS-AUDIT 18.08.2026 (Owner: "W1 offiziell abgeschlossen, aber laut Wellenplan bin ich mir nicht sicher"). Repos: ce ${CE} (development @ 20c111c4) · super ${SUPER} · ungelandeter #15-Bruch ${WT} (67dafa46; zaehlt als GEBAUT-ungelandet, NICHT als fehlend). Miss AM OBJEKT (git log/merge-base/grep/Read), nie nur an Doku. VORBEFUNDE (verifizieren, nicht uebernehmen): #17/g2 1528f6fd NICHT Ancestor von 20c111c4; B3-Schalter-Hoheit ohne Bau-Spur. Je Posten EIN Verdikt: ERFUELLT (mit Beleg) / GEBAUT_UNGELANDET (im Bruch-Worktree) / OFFEN_VOR_F2 (Pflicht Fr 21.08.) / OFFEN_W2_DEKLARIERT (mit Quelle der Deklaration) / GESTRICHEN_DEKLARIERT (mit Quelle) / UNKLAR (mit dem, was fehlt). Falsch-Null-Fallen: Umbruch ~95 Z., Case, ae/ä; NIE 'grep -v /build'. Antworte NUR mit dem JSON.`

const SCHEMA = { type:'object', required:['posten'], properties:{ posten:{type:'array', items:{type:'object',
  required:['id','verdikt','beleg'], properties:{
    id:{type:'string'}, verdikt:{type:'string',enum:['ERFUELLT','GEBAUT_UNGELANDET','OFFEN_VOR_F2','OFFEN_W2_DEKLARIERT','GESTRICHEN_DEKLARIERT','UNKLAR']},
    beleg:{type:'string',description:'Kommando/Datei:Zeile literal, kompakt'},
    frist_hinweis:{type:'string'} }}}}}

phase('Posten-Pruefung')
const GRUPPEN = [
  {key:'A-straenge', auftrag:`Die 4 W1-Straenge + Nachzuege: hy-a a4366cb8 · vl12 cd011e60 · vl3 7bf66ddd · k2 7a5ed464 · f45e995b · 316c488f · c3478a9c je merge-base --is-ancestor gegen 20c111c4. Dazu VL-3-Pflicht-Fixes aus P.20.2: (a) clang-WARNUNGS-Review-Durchgang, (b) --debug x plan dump|ci|cmake-Tests (Exit-6-Zweige), (c) Windows-_pclose-Blick — laut P.20.9 nach W2-1/W2-2 getragen: Deklarations-Quelle im Wellenplan zitieren, Ist am Objekt pruefen (existieren die Tests/Reviews?).`},
  {key:'B-stempel', auftrag:`Stempel-Strecke: S-1 (stempel_basis.hpp) · S-2/G-1-Grammatik (Design publiziert 20260813-DESIGN-g1-*; BAU-Stand der dreiphasigen Mess-Grammatik?) · S-3 (flag_menge_ordnung.hpp, 4a89aed5) · S-5 (Compose, im Bruch 9c17765f) · S-6a (Bruch f3559e7a/5c0c3a5e/d866bb3d) · S-6b Transpositions-Sperre (Task #15 sagt 'vorziehbar' — gebaut? grep im Bruch) · S-6c/S-21 Kategorien-Ordnungs-Wache (KON21-03; gebaut?) · S-6d/#67 Benennung (Status? KON96/Korb A A-10 sagt 'explore+schaerfen, behalten') · S-7 (d215b127). Je Posten Objekt-Beleg.`},
  {key:'C-hy-a', auftrag:`HY-A1 (anatomy_base.hpp:89 HeuristikAdapter=3, :169 Reroute=5, gelandet 09.08.) · HY-A2 (Proxy+hybrid_module_abi_v1+test_hy_f8, im Bruch) · HY-A3 (kGenusBuildSlotCounts 5->6 + static_assert + test_e24_c4-Nachzug, im Bruch) · W1-Abnahmeformel Wellenplan :952-Ersatz (P.20.10: size() 5->6 + Paare 4/6 vorher/nachher) — ist die Abnahme im Bruch FAHRBAR dokumentiert (ctest-Ausgaben)?`},
  {key:'D-schalter', auftrag:`Mess-Schalter B1-B5 (Task #24, KON34-04): B2 Gate-Trennung (gelandet im golden-Fenster 04ac26fa — Beleg) · B3 Schalter-Hoheits-Umzug zur CEB (OWNER-DATUM VOR F2, KON34-04/KON37-01: 'Tier-Pflicht-Wurf abi_adapter.hpp:476-491 faellt') — am Objekt: existiert der Wurf noch in ${WT} UND ${CE}? Gibt es B3-Commits? · B5 Stempel-Pflicht je Schalter (nach S-5; Stand?) · B1 XML-Konsum je Stufe (W1-Ende lt. #24; Stand measurement_tooling/Registry-Neubau?). B4 = W2 (nur bestaetigen dass W2-deklariert).`},
  {key:'E-g2', auftrag:`#17/G-2-Semantik: g2-Strang 1528f6fd 'Redundanz-Wache der Flag-Menge als B12-Term (e)' — merge-base gegen 20c111c4 (Vorbefund: NICHT enthalten). Wo lebt der Strang (worktree? branch? git branch -a --contains 1528f6fd in ${CE})? Wie gross ist der Rest laut P.20.3 ('Rest-Kategorien lt. Bericht')? Welche G-2-Kategorien sind in development schon da (grep semantik/G-2 in measurement/)? KON17-01-Folge: #17 schliesst die Stempel-Strecke und gibt #7/S-19 frei — Frist-Einordnung.`},
  {key:'F-statistik-menge', auftrag:`W1-Plan-Posten Statistik/Menge (Wellenplan §3-W1): D4a-f (Degenerations-Kette; gelandet? test_d4*/welch/mwu am Objekt) · D5-2 Median-Kanon · D5-4 delete_p99_ns · D5-5 HDR VERDRAHTEN (R-20 sagt 'vor W4' — Produktions-Konsument heute? grep latency_hdr_histogram-Includes ausserhalb tests/) · ##10/##10b --check-size · ##11 <measure_selection> (R-05: XML-Trennung nach W2/S-13 deklariert?) · ##12 · ##13 G3-aus-STATISTICS (R-09: W2 deklariert) · ##14 Sperrlisten-Wache (S-14a 718 Records — ERFUELLT-Beleg) · ##15 §59-SCHEMA · ##16/##17 (OV-1-Lage) · ##19 LaTeX-Emitter. Je Posten kurzer Objekt-Beleg + ggf. Deklarations-Quelle.`},
  {key:'G-testlast', auftrag:`Designplan §4-W1 Band A (23 Posten, Marker D-2: Band B/W1 62h GESCHLOSSEN GESTRICHEN — nur bestaetigen): MT-L3 Schema-Orakel (PZW-SCHEMA-LITERAL heute? ci/plan_zahlen_wache-Anker) · PK-KanonWert/Kreuztest/KlemmJson · ST-Trio (Welch/MultiCompare/Diskrepanz/Export/CLITestat) · HY-Vertraege (im Bruch — GEBAUT_UNGELANDET) · LG-Kette (HostBinder/SkipCallback/E2Exlsx/WritebackXlsx/XlsxAlt/LoadWache/Idempotenz) · PM-Naht · XL-L2/XL-L4. Je Test: existiert er in ctest (tests/unit-Dateien am Objekt), sonst OFFEN mit Band-Zuordnung.`},
  {key:'H-freeze-check', auftrag:`Der FREEZE-CHECK Fr 21.08. (Wellenplan §18.3 Schlusszeile): 'S-6a-d · S-7 · S-5 · S-3/#17 · ABI-Pflicht · CEB-Stempel · SOLL-Versionierung · HY-A · B1 · B2/B3/B5 · Umbenennung · #38d + #38a2' — je Element EIN Verdikt mit Beleg (Bruch-Worktree zaehlt als GEBAUT_UNGELANDET). Fuer #38a2 (Comp-Gate-Stempel organ_stamp_line je COMP): ist er im Bruch WIRKLICH gebaut (grep organ_stamp_line/active_organ_required in ${WT}) oder nach 18.6(3) gefallen-deklariert? SOLL-Versionierung (KON9-05-Stempelzeile via S-7) und CEB-Stempel: Objekt-Beleg.`},
]
const ergebnisse = []
for (const g of GRUPPEN) {
  const r = await agent(`${KOPF}
GRUPPE ${g.key}: ${g.auftrag}
SOLL-Quellen bei Bedarf nachlesen: Wellenplan ${WP} (§3-W1, §13.3, §18.3, §20) · Designplan ${DP} (§4-W1).`,
    {label:`w1-${g.key}`, phase:'Posten-Pruefung', schema:SCHEMA, effort:'max'}).catch(()=>null)
  if (r) ergebnisse.push({gruppe:g.key, posten:r.posten})
  log(`W1-Pruefung: ${g.key} durch (${ergebnisse.length}/${GRUPPEN.length})`)
}
if (ergebnisse.length < GRUPPEN.length) {
  const da = ergebnisse.map(e=>e.gruppe)
  return { FEHLER:'W1-AUDIT UNVOLLSTAENDIG', fehlend: GRUPPEN.map(g=>g.key).filter(k=>!da.includes(k)), teil: ergebnisse }
}

phase('Synthese')
const alle = ergebnisse.flatMap(e=>e.posten.map(p=>({...p, gruppe:e.gruppe})))
const SYN = await agent(`${KOPF}
SYNTHESE: ${alle.length} W1-Posten-Verdikte aus 8 Gruppen. Faelle das Gesamturteil: WAR "W1 KOMPLETT" KORREKT? (Erwartung aus Vorbefund: NEIN fuer die Formel-/Posten-Ebene, JA fuer die 4 Straenge — praezise trennen.) Liefere: (1) gesamturteil (3-4 Saetze, ehrlich), (2) offen_vor_f2 (die harte Liste — was MUSS bis Fr 21.08., inkl. #17/g2-Landeweg + B3), (3) gebaut_ungelandet (landet mit dem #15-Zug), (4) offen_w2_deklariert (mit Quelle), (5) gestrichen_deklariert, (6) unklar (mit naechster Messung), (7) owner_vorlage_kandidaten (nur was kein Explore loest).
=== VERDIKTE === ${JSON.stringify(alle).slice(0,60000)}`,
  {label:'w1-synthese', phase:'Synthese', schema:{type:'object', required:['gesamturteil','offen_vor_f2','gebaut_ungelandet','offen_w2_deklariert','gestrichen_deklariert','unklar','owner_vorlage_kandidaten'], properties:{
    gesamturteil:{type:'string'}, offen_vor_f2:{type:'array',items:{type:'string'}},
    gebaut_ungelandet:{type:'array',items:{type:'string'}}, offen_w2_deklariert:{type:'array',items:{type:'string'}},
    gestrichen_deklariert:{type:'array',items:{type:'string'}}, unklar:{type:'array',items:{type:'string'}},
    owner_vorlage_kandidaten:{type:'array',items:{type:'string'}}}}, effort:'max'})

return { synthese: SYN, posten_gesamt: alle.length,
  verdikt_zaehler: { erfuellt: alle.filter(p=>p.verdikt==='ERFUELLT').length,
    gebaut_ungelandet: alle.filter(p=>p.verdikt==='GEBAUT_UNGELANDET').length,
    offen_vor_f2: alle.filter(p=>p.verdikt==='OFFEN_VOR_F2').length,
    offen_w2: alle.filter(p=>p.verdikt==='OFFEN_W2_DEKLARIERT').length,
    gestrichen: alle.filter(p=>p.verdikt==='GESTRICHEN_DEKLARIERT').length,
    unklar: alle.filter(p=>p.verdikt==='UNKLAR').length } }
