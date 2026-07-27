export const meta = {
  name: 'session-plan-V2-voll-erweitert-planung',
  description: 'Reicher Planungsdurchlauf (Vorbild wf_c8314fe7): korrigiert Fehlannahmen in S1-S9 + erweitert VOLL um alle fehlenden Straenge (ISA/Meta-Meta, NUMA/page_type, Gattung, vergessene Straenge/§50) als parallele Straenge hinter der Zwischen-Abgabe; nichts auslassen',
  phases: [
    { title: 'Analyse', detail: '6 parallele Reader: Korrekturen S1-S9, ISA/Meta-Meta-Strang, NUMA/page_type+ThesisProfile-Schaerfung, Gattung-Strang, vergessene Straenge letzte 2 Tage, BAND/Topologie' },
    { title: 'Synthese', detail: 'Architekt integriert zu vollstaendiger Erweiterung+Korrektur des Session-Plans (append-fertig)' },
  ],
}

const REPO = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = REPO + '/Code/external/comdare-cache-engine'

// --- DERSELBE Planungs-Text wie beim letzten Session-Plan-Workflow (User-Vorgabe) ---
const ROLLE = `Du bist ein C++-Entwickler und Experte auf deinem Gebiet, sowie Software-Architekt, und leitest als Manager die Organisation und Delegation der offenen Arbeit, indem du mit ultracode einen elaboraten sequentiellen Plan fuer die Ausfuehrung entwickelst, der bei disjunkten Arbeiten je sequentiellen Schritt auf moeglichst viele parallele Agenten verteilt wird. Der Plan wird als Session-Plan gespeichert (Impl->Opus-Agenten, Fable=Architekt).`

const COMMON = `${ROLLE}

KONTEXT (Diplomarbeit Cache-Engine). Deadline 28.07.2026 ist NUR eine ZWISCHEN-Abgabe (320er-Messdatensatz + Hybrid-Binary + Thesis-PDF); Zwischen-Meilenstein 24.07. (alles baut, messbar CI+lokal); Voll-Messung new-golden ab 01.08. GRUNDSATZ (User): VOLL planen, NICHTS auslassen, wichtige Straenge priorisieren, so weit kommen wie moeglich.

QUELLEN (selbst lesen):
- Ledger ${REPO}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md — §47 (Mess-Achsen Haupt/Unter), §48 (Single-Source aller offenen Ziele, 8 Straenge), §49 (Hybrid-Break-Even + Korrektur variant-limitiert), §50 (vergessene Features ~40), §51 (B1-B15 + neue Achsen-Konzepte), §52 (Aufloesung der 8 B-Workflows). Ab Zeile 2406.
- Bestehender Session-Plan (Grundlage, Grundsatz bleibt): ${REPO}/docs/plaene/20260720-SESSION-PLAN-ausfuehrung-offene-arbeit.md — Schritte S1-S9. Haus-Stil je Schritt: Ziel, Tabelle (Paket|Kern-Dateien(Owner)|Deliverable|Verifikation), Agenten-Zahl, Koordination, Gate, Blockiert-durch, Risiken.
- Plandocs der letzten 2 Tage: ${REPO}/docs/plaene/2026071[89]-*.md + 20260720-*.md (ls dort).

USER-KLAERUNGEN (bindend fuer diese Planung):
- Q2: ALLE grossen Erweiterungen JETZT voll mitplanen, als PARALLELE weitere Straenge HINTER die Abgabe-Kette angehaengt; keinen Strang auslassen; 28.07. = Zwischen-Abgabe.
- Q3: ISA-Fork-A ADDITIV zuerst (neue Achse neben alter), die Loeschung/der Ausbau der ALT-Version ist PFLICHT-SCHLUSS am Ende des ISA-Strangs (nicht separat vertagt).
- Q4: Gattungs-ABI = EIGENES Fenster DIREKT HINTER dem golden/ABI-Regen-Fenster im SELBEN Strang, als 2 getrennte sequentielle Stufen (Haupt-golden-Fenster -> dann Gattungs-ABI-Fenster), zusammen per Agenten-Delegation.

BINDENDE DIREKTIVEN: CT-only Hot-Path (CRTP+Concept, kein vtable/Runtime-Switch); std::variant nur eng-begrenzt (Hybrid Unter-Pruef-Docks via Abstract-Factory, NICHT Haupt-Observer-Kommunikation); nur benannte Lehrbuch-Patterns; kein Python in Buildchain; ASCII-Code-Kommentare; Doku/Messdaten nie loeschen (nur DEPRECATED); NIE rebase; Remote-Loeschung nur je-Repo-GO; golden N=2^17=131072 CRC64 0xF1C1F26A1232073B binary_id=Organ-only; Haupt=CT-statisch/Unter=an-Folgestufe-delegiert (identisch Planer->Mess/CEB->System/Tier->Organ). Kadenz je Schritt: cf22 + ctest + Mojibake-grep + super-Sub-Build + Dual-Push (origin=gitlab,github) + CI hart-gruen ce+super/prod1+prod2. Planer-Kern (experiment_plan_director.hpp + validate_profile.hpp + xml_config_parser.*) = 1 Owner streng seriell.`

phase('Analyse')

const [korr, isa, numa, gattung, vergessen, topo] = await parallel([
  () => agent(`${COMMON}

DEIN AUFTRAG (R1 — KORREKTUREN): Gehe die bestehenden Schritte S1-S9 durch und liste JEDE Fehlannahme / jeden veralteten Punkt, der durch §52 (8-B-Workflow-Aufloesung) korrigiert werden muss. Bekannte Korrektur-Quellen: B10 (page_type ist KEINE dynamische CPU-Umschaltung und KEINE neue Achse — bereits korrekt zweigeteilt System axis_12 huge_page_capable -> Organ AllocPageHint; nur anerkennen/benennen, Namensfalle axis_01_page_type=Baum-Struktur), B11 (INC-0 DLL-Load ist ERLEDIGT ce 418e4b76, NICHT offen; Rest nur build-i2 stale-rot), B13 (9dim-Fixes 7/7 erledigt; nur 2 Prosa-Drifts), B14 (§38 STRUKTUR erfuellt aber Kettenlauf-Integration offen -> in S5/S-Mess korrekt als 3 Reste verankern statt als 'offen' pauschal), sowie die Ziel-Zahl (§48 nennt teils 437, teils 477 — vereinheitlichen). Pruefe auch, ob S1-A4 (P-KONFORM build-i2) und die Mess-Kette-Zeilen die §52-Befunde korrekt spiegeln. Gib eine praezise KORREKTUR-DELTA-LISTE zurueck (je Punkt: welcher S-Schritt/welche Zeile, alte Annahme, Korrektur), im Markdown.`, { label: 'R1:korrekturen', phase: 'Analyse', effort: 'high' }),

  () => agent(`${COMMON}

DEIN AUFTRAG (R2 — ISA/META-META-STRANG): Entwirf den vollstaendigen neuen Strang fuer B3+B4 (Meta-Meta-Achsen + Hardware-Erweiterungs-Array + ISA-Fork-A als Freigabe-Haupt-Achse + Stempel-System-Erweiterbarkeit). Grundlage §52-B3 (hardware wird Manager ueber statisches mp_list-Achsen-Array via boost::mp11 vendored; jeder Erweiterungstyp=eigene Haupt-Achse=Meta-Meta-Achse; AVX512-Achse mit 13-14 Flag-Subsets als Domaene; 3 CRTP-Ebenen empty/!is_polymorphic; Stempel per Fold aus Array statt hardcoded; Organ-analoges Haupt-Achsen-Array), §51-B4 (ISA per Fork A neu, Freigabe-Haupt-Achse, im Organ-Raum als 1 lokale ISA ausgearbeitet, cross-compile erweiterbar; Stempel als System erweiterbar). Lies ${CE}/libs/cache_engine/topics/hardware/* (extension_hardware_family_axis.hpp, axis_12_general_hardware*, hardware_isa_system_axis.hpp, simd_feature_flag.hpp, machine_simd_signature.hpp), abi/anatomy_version_stamp.hpp (hardcoded array), ceb_system_axis.hpp, simd_sub_axis.hpp, compiler_system_axis.hpp; Plandoc docs/plaene/20260718-inc-2d-vor-deep-research-BAUPLAN-INC-2D-ISA-SYSTEM-ACHSE.md; §40.a-Referenz. WICHTIG Q3: ISA-Fork-A ADDITIV zuerst; der Ausbau/die Loeschung der ALT-Version ist PFLICHT-Schlussstufe am Ende dieses Strangs. Zerlege in disjunkte parallele Agent-Pakete (Manager-CRTP-Typsystem / mp11-Registry+Stempel-Fold / ISA-Fork-A additiv / Organ-analoges Array / Alt-Ausbau-Pflicht-Schluss), je Paket Owner-Dateien konkret + Deliverable + Verifikation. Gib den Strang im Haus-Stil (Ziel, Tabelle, Agenten-Zahl, Koordination, Gate, Blockiert-durch, Risiken) + BAND-Zuordnung zurueck.`, { label: 'R2:isa-metameta', phase: 'Analyse', effort: 'high' }),

  () => agent(`${COMMON}

DEIN AUFTRAG (R3 — NUMA/PAGE_TYPE-STRANG + THESIS-PROFILE-SCHAERFUNG von S4): (a) Entwirf den Strang fuer B8 (7. NUMA/Locking-System-Achse SOFERN compile-statisch erkennbar -> Haupt-Achse, sonst dynamische Unter-Achse unter ISA an Tier-Binary delegiert; User: dynamisch->unter-ISA; verifizieren anhand cpuid/sysfs-Ist) + B10 (page_type: KEIN neuer Bau-Block, nur additiver Anerkennungs-/Benennungs-Schritt der bereits vorhandenen Zweiteilung System axis_12/HW4 -> Organ axis_06 AllocPageHint; cache-awareness-Pflicht FF3; Namensfalle aufloesen). (b) Liefere die S4-SCHAERFUNG durch B9: die geforderten Thesis-Profile (WAS/WIE zu messen) VOLLSTAENDIG als <measurement_tooling>(Haupt)+<run_methodology>(Unter)-Schema-Elemente + Mess-Framework-Unter-Achsen + Workload-Delegation an CEB; Werkzeuge im Planer UND ALLEN Stufen. Lies ${CE}/libs/cache_engine/topics/hardware/axis_12_general_hardware*, axes/alloc/alloc_hw_config.hpp, measurement/system_axis_registry*, measurement/measurement_axis_registry*; suche in docs/ die geforderten Thesis-Mess-Profile (thesis-profil/WAS-WIE, m3v2/all_axes_golden.profile.xml, §9-B9). Gib zurueck: den NUMA/page_type-Strang im Haus-Stil (Ziel, Tabelle, Agenten-Zahl, Gate, Blockiert-durch, Risiken, BAND) UND separat eine konkrete S4-Delta-Liste (welche Schema-Elemente + Werkzeuge je Stufe).`, { label: 'R3:numa-page-thesis', phase: 'Analyse', effort: 'high' }),

  () => agent(`${COMMON}

DEIN AUFTRAG (R4 — GATTUNGS-STRANG, LETZTER ABI-Schritt): Entwirf den vollstaendigen Strang fuer B2 (Gattungs-Vervollstaendigung). Grundlage §52-B2 (5 Genera-Geruest existiert; SearchAlgorithm=9 Organe+ObserverAggregate<17>+8 Schichten; Set/Sequence/Adapter/View=je 1 Organ+flacher POD; gemeinsames OrganConcept fuer Cross-Genus-Komposition-als-Sub-Organ: node_type<-Sequence/Adapter, index_organization<-Set, queuing<-Adapter; Organ-Haupt/Unter je Genus definiert; Cross-Genus-JOIN bleibt type-unmoeglich; Genus+ABI disjunkt/gegenseitig nutzbar). Lies ${CE}/libs/cache_engine/anatomy/* (genus_binding_traits.hpp, set/sequence/view_composition.hpp, observer_aggregate.hpp), container_framework.hpp, die Permutation-Engines + 5 Docks; Ledger §14.1-G-AP15/§12-0708-#29. WICHTIG Q4: Der Gattungs-ABI-Bump ist ein EIGENES Fenster DIREKT HINTER dem golden/ABI-Regen-Fenster im SELBEN Strang, als 2 getrennte sequentielle Stufen (Stufe 1 = Haupt-golden/ABI, Stufe 2 = Gattungs-ABI), zusammen delegiert. Bau-Reihenfolge: OrganConcept zuerst? dann per-Genus 8 Schichten (1 Genus je Agent)? user-gated Genus->Typ-ABI-GO. Zerlege in disjunkte parallele Agent-Pakete (OrganConcept-Owner / je Genus ein Paket / ABI-Bump-Stufe). Gib den Strang im Haus-Stil zurueck (Ziel, Tabelle, Agenten-Zahl, Gate inkl. 2-Stufen-Fenster, Blockiert-durch, Risiken, BAND) + Begruendung 'ABI zuletzt'.`, { label: 'R4:gattung', phase: 'Analyse', effort: 'high' }),

  () => agent(`${COMMON}

DEIN AUFTRAG (R5 — VERGESSENE STRAENGE der letzten 2 Tage + §50): Sichte die Plandocs docs/plaene/2026071[89]-*.md + 20260720-*.md (ls+lies die relevanten) UND §50 (§48-Nachtrag ~40 vergessene Features). Finde alle BLOECKE/WELLEN/STRAENGE, die im bestehenden Session-Plan S1-S9 NICHT abgebildet sind und mitgeplant werden muessen — SOFERN sie sich NICHT mit dem neuesten Plan oder den User-Klaerungen (§47/§49/§51/§52 + Q2/Q3/Q4) widersprechen. Kandidaten u.a.: W7-W9-Wellen, W10-Legenden-Kette (§47-Umbau measurement_combos_of), W11 async-Push/Cluster-Resume, W12-B Stempel-Cache-Key, §38-Rest (B14), §40.b/§40.c dynamische Planer-CI/Bare-Metal, §35/§36 Cluster-parallele System-Achsen-Builds, inkrementeller Tier-Cache (B7), 4->5-Bump-Reste (INC-1..4), Fehlerklassen #29-Rest, M-4/M-8/M-9-Auswertungs-Writer, Storage Ebene-B/C (B5/B6), Migration G5/#274 (B15). Gib eine strukturierte Liste zurueck: je vergessenem Strang -> Kurzname, Quelle (Plandoc/§), wo er in die Kette einzuordnen ist (bestehender S-Schritt erweitern ODER neuer paralleler Strang), Prioritaet/BAND, ob widerspruchsfrei. Markiere explizit alles, was du wegen Widerspruch NICHT uebernimmst.`, { label: 'R5:vergessene-straenge', phase: 'Analyse', effort: 'high' }),

  () => agent(`${COMMON}

DEIN AUFTRAG (R6 — TOPOLOGIE/BAND/PARALLEL-STRAENGE): Entwirf die Gesamt-Topologie unter Q2 (alle grossen Erweiterungen als parallele Straenge HINTER der Abgabe-Kette, nichts auslassen, Abgabe=Zwischenstand). Kern-Abgabe-Kette bleibt S1(P-TOTAL)->S2(Voll-Build/golden)->S3(Resolver)->S4(Mess-Tooling+B9)->S5(Vollzug)->S6(320er,USER-GO)->S7(Hybrid+M4+PDF)->S8(PDF-Abgabe). Danach als PARALLELE nachgelagerte Straenge: ISA/Meta-Meta (R2), NUMA/page_type (R3), Gattung (R4), plus die vergessenen Straenge (R5), plus new-golden-Voll-Messung/W12B/#276/S-7-Deep-Research/Migration. Liefere: (1) eine BAND-Tabelle (BAND-A 24.07. / BAND-B 28.07. / BAND-C ab 01.08. / BAND-D geparkt) mit Zuordnung JEDES Strangs; (2) die Parallel-Strang-Topologie NACH der Abgabe (welche Straenge laufen echt parallel, welche haben Abhaengigkeiten); (3) die Owner-Konflikt-Matrix (welcher neue Strang teilt Dateien mit dem Planer-Kern S1-S5 bzw. system_axis_registry/anatomy_version_stamp/xml_config_parser und braucht Owner-Serialisierung); (4) Prioritaets-Reihenfolge der nachgelagerten Straenge. Lies §48 (Prioritaeten/Deadlines je Zeile) + den Session-Plan (Kritischer-Pfad-Markierung, Owner-Regeln). Gib Markdown zurueck.`, { label: 'R6:topologie-band', phase: 'Analyse', effort: 'high' }),
])

phase('Synthese')

const synthese = await agent(`${COMMON}

Du bist der SOFTWARE-ARCHITEKT und Manager. Sechs Analyse-Reader haben die Erweiterung+Korrektur des Session-Plans vorbereitet. Integriere ALLES zu einem append-fertigen Markdown-Block, der den bestehenden Session-Plan (S1-S9 Grundgeruest bleibt) VOLLSTAENDIG erweitert und korrigiert. Grundsatz: voll planen, nichts auslassen, Abgabe=Zwischenstand, grosse Erweiterungen als parallele Straenge hinter der Abgabe-Kette.

R1 KORREKTUREN:
${korr}

R2 ISA/META-META-STRANG:
${isa}

R3 NUMA/PAGE_TYPE + S4-SCHAERFUNG:
${numa}

R4 GATTUNGS-STRANG:
${gattung}

R5 VERGESSENE STRAENGE:
${vergessen}

R6 TOPOLOGIE/BAND:
${topo}

Erzeuge EXAKT diese Markdown-Struktur (deutsche Umlaute korrekt, KEINE Mojibake, ASCII in Code-Bezeichnern, Haus-Stil der bestehenden S1-S9):

## PLAN-V2-ERWEITERUNG 2026-07-20 (B1-B15 + vergessene Straenge, VOLL) — Grundsatz: voll planen, nichts auslassen, 28.07.=Zwischen-Abgabe

### A. KORREKTUREN an S1-S9 (Fehlannahmen raus)
<die konsolidierte Korrektur-Delta-Liste aus R1 als Bullet-Liste; je Punkt: S-Schritt, alte Annahme -> Korrektur>

### B. SCHAERFUNGEN bestehender Schritte
- **S4-Delta (B9 Thesis-Profile, ON PATH):** <konkrete Schema-Elemente + Werkzeuge je Stufe aus R3>
- **S5-Delta (B14 §38-Reste):** <die 3 Kettenlauf-Integrations-Reste als konkrete S5-Teilaufgaben>
- <weitere Schaerfungen aus R1/R5, die bestehende Schritte betreffen>

### C. NEUE PARALLELE STRAENGE (nach der Abgabe-Kette, voll geplant)
#### S10 — ISA-Fork-A + Meta-Meta-Achsen + Hardware-Manager-Array + Stempel-System-Erweiterbarkeit
<volle Strang-Spezifikation aus R2 im Haus-Stil; Alt-Ausbau als Pflicht-Schlussstufe (Q3)>
#### S11 — 7. System-Achse NUMA/Locking (B8) + page_type-Anerkennung (B10)
<volle Strang-Spezifikation aus R3>
#### S12 — Gattungs-Vervollstaendigung (B2), LETZTER ABI-Schritt, 2-Stufen-ABI-Fenster (Q4)
<volle Strang-Spezifikation aus R4; Gattungs-ABI-Fenster direkt hinter golden/ABI-Fenster, 2 sequentielle Stufen>
#### S13+ — Vergessene Straenge (aus R5)
<je uebernommenem vergessenem Strang eine kompakte Strang-/Erweiterungs-Zeile mit Einordnung + BAND; explizit gelistet, was wegen Widerspruch NICHT uebernommen wird>

### D. GESAMT-TOPOLOGIE + BAND-TABELLE
<die BAND-Tabelle + Parallel-Strang-Topologie + Owner-Konflikt-Matrix + Prioritaets-Reihenfolge aus R6>

### E. AKTUALISIERTE KRITISCHER-PFAD-MARKIERUNG
<1 Absatz: 28.07.-Zwischen-Abgabe-Pfad S1..S8 bleibt Fokus; danach parallele Straenge S10-S13+; neue USER-GO-Gates (ISA-Alt-Ausbau-Pflicht, Gattung Genus->Typ-ABI-GO, 2-Stufen-ABI-Fenster).>

Gib NUR diesen Markdown-Block zurueck (kein Vorwort, keine umschliessenden Code-Fences).`, { label: 'architekt:synthese', phase: 'Synthese', effort: 'max' })

return { synthese }
