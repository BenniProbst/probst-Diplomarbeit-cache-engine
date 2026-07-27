export const meta = {
  name: 'session-plan-schaerfung-b-praezisierung',
  description: 'Schaerft+erweitert den Session-Plan (S1-S9) um die B1-B15-Praezisierungen: Meta-Meta-Achsen/ISA-Fork-A (S10), NUMA/page_type (S11), Gattungs-Vervollstaendigung (S12) + Delta zu S1/S4/S7',
  phases: [
    { title: 'Analyse', detail: '4 parallele Reader: ISA-Fork-A/Meta-Meta-Platzierung, Gattung-B2-Sequenz, Thesis-Profile-B9/NUMA-B8/page_type-B10, BAND/Kritischer-Pfad' },
    { title: 'Synthese', detail: 'Architekt integriert zu S10-S12 + Schaerfungs-Deltas, append-fertig' },
  ],
}

const REPO = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = REPO + '/Code/external/comdare-cache-engine'

const COMMON = `
KONTEXT (Diplomarbeit Cache-Engine, Deadline 28.07.2026, Zwischen 24.07., Voll-Messung ab 01.08.):
- Ledger: ${REPO}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md — lies §47/§48/§49/§50/§51/§52 (ab Zeile 2406). §48 = Single-Source der offenen Ziele (8 Straenge). §52 = Aufloesung der 8 B-Workflows (B2/B3/B10/B11/B12/B13/B14/B15).
- Aktueller Session-Plan (ZU ERWEITERN, NICHT ersetzen): ${REPO}/docs/plaene/20260720-SESSION-PLAN-ausfuehrung-offene-arbeit.md — Schritte S1-S9. Struktur je Schritt: Ziel, Agent-Pakete-Tabelle (Paket|Kern-Dateien(Owner)|Deliverable|Verifikation), Agenten-Zahl, Koordination, Gate, Blockiert-durch. Planer-Kern (experiment_plan_director.hpp + validate_profile.hpp + xml_config_parser.*) = 1 Owner streng seriell ueber S1->S5.
- Kritischer Pfad zur 28.07.: S1(P-TOTAL forward-fix)->S2(Voll-Build 2^17/new-golden, EIN ABI/golden-Fenster)->S3(Resolver)->S4(Mess-Tooling-Schema)->S5(Mess-Vollzug)->S6(320er-Lauf,USER-GO)->S7(Hybrid+M4+PDF-Rueckschrieb)->S8(PDF-Abgabe).
- BINDENDE Direktiven: Impl->Opus-Agenten (Fable=Architekt); CT-only Hot-Path (CRTP+Concept, kein vtable/Runtime-Switch/std::variant ausser eng-begrenzt); nur benannte Lehrbuch-Patterns; kein Python in Buildchain; ASCII-Code-Kommentare; Doku/Messdaten nie loeschen (nur DEPRECATED); NIE rebase; Remote-Loeschung nur je-Repo-GO; golden N=2^17=131072 CRC64 0xF1C1F26A1232073B binary_id=Organ-only; Genus+ABI disjunkt/gegenseitig nutzbar; Haupt=CT-statisch/Unter=an-Folgestufe-delegiert (identisch an allen 3 Vertragspunkten Planer->Mess/CEB->System/Tier->Organ).
- Je Schritt Kadenz: cf22 clang-format-22 + ctest + Mojibake-grep + super-Sub-Build + Dual-Push (origin=gitlab,github) + CI hart-gruen ce+super/prod1+prod2.
`

const STEP_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['band', 'kritischer_pfad', 'position_in_kette', 'agent_pakete', 'gates', 'blockiert_durch', 'risiken', 'begruendung'],
  properties: {
    band: { type: 'string', description: 'BAND-A(24.07.)/BAND-B(28.07.)/BAND-C(ab01.08.)/BAND-D(geparkt) mit 1 Satz Begruendung' },
    kritischer_pfad: { type: 'boolean', description: 'liegt dieser Block auf dem 28.07.-Abgabe-Pfad?' },
    position_in_kette: { type: 'string', description: 'wo relativ zu S1-S8 einzuordnen (vor/nach welchem Schritt, warum), ohne die Abgabe-Kette zu stoeren' },
    agent_pakete: {
      type: 'array',
      items: {
        type: 'object', additionalProperties: false,
        required: ['paket', 'kern_dateien_owner', 'deliverable', 'verifikation'],
        properties: {
          paket: { type: 'string' },
          kern_dateien_owner: { type: 'string', description: 'konkrete Dateien datei:zeile wo moeglich, mit Owner-Rolle' },
          deliverable: { type: 'string' },
          verifikation: { type: 'string' },
        },
      },
    },
    gates: { type: 'string', description: 'USER-GO-Gates + Kadenz-Gate + evtl. ABI/golden-Fenster' },
    blockiert_durch: { type: 'string' },
    risiken: { type: 'string', description: 'Risiken + Fallback' },
    begruendung: { type: 'string', description: 'architektonische Begruendung der Platzierung/Zerlegung' },
  },
}

phase('Analyse')

const [r_isa, r_gattung, r_thesis, r_band] = await parallel([
  () => agent(`${COMMON}
DEINE ANALYSE (R1) — S10: Meta-Meta-Achsen + Hardware-Erweiterungs-Array + ISA-Fork-A (Freigabe-Haupt-Achsen) + Stempel-System-Erweiterbarkeit.
Grundlage: §52-B3 (Meta-Meta-Achsen: 'hardware' wird Manager ueber statisches Achsen-ARRAY via boost::mp11 mp_list/mp_for_each; jeder Erweiterungstyp=eigene Haupt-Achse=Meta-Meta-Achse; AVX512-Achse mit 13-14 Flag-Subsets als Domaene; Organ-analoges Haupt-Achsen-Array + Fold-abgeleitete Stempel), §51-B4 (ISA per Fork A neu bauen, alte ausbauen; Freigabe-Haupt-Achse fuer durchfuehrbare Organ-Achsen; im Organ-Raum als 1 lokale ISA ausgearbeitet, cross-compile erweiterbar; Stempel als System erweiterbar).
Lies: ${CE}/libs/cache_engine/topics/hardware/ (extension_hardware_family_axis.hpp, axis_12_general_hardware, hardware_isa_system_axis.hpp), simd_feature_flag.hpp, machine_simd_signature.hpp, abi/anatomy_version_stamp.hpp (:68 hardcoded array), ceb_system_axis.hpp, simd_sub_axis.hpp, compiler_system_axis.hpp; das Plandoc docs/plaene/20260718-inc-2d-vor-deep-research-BAUPLAN-INC-2D-ISA-SYSTEM-ACHSE.md; §40.a-Referenz docs/architektur/*simd-flag*.
Entscheide: Ist ISA-Fork-A additiv (neu neben alt, alt spaeter unter Absprache ausbauen — MEMORY 'Alt-golden darf brechen; erst additiv') und damit NICHT im S2-golden-Fenster zwingend, oder muss es rein? Welche BAND? Zerlege in disjunkte Agent-Pakete (Manager-CRTP-Typsystem / mp11-Verdrahtung Registry+Stempel-Fold / ISA-Fork-A additiv / Organ-analoges Array). Owner-Dateien konkret. Gib das STEP_SCHEMA fuer S10 zurueck.`, { label: 'R1:isa-metameta', phase: 'Analyse', schema: STEP_SCHEMA, effort: 'high' }),

  () => agent(`${COMMON}
DEINE ANALYSE (R2) — S12: Gattungs-Vervollstaendigung (B2), LETZTER ABI-Schritt, eigene Planung.
Grundlage: §52-B2 (5 Genera-Geruest existiert parallel; SearchAlgorithm=9 Organe+ObserverAggregate<17>+8 Schichten; Set/Sequence/Adapter/View=je 1 Organ+flacher POD; gemeinsames OrganConcept fuer Cross-Genus-Komposition-als-Sub-Organ: node_type<-Sequence/Adapter, index_organization<-Set, queuing<-Adapter; Organ-Haupt/Unter je Genus definiert; Cross-Genus-JOIN bleibt type-unmoeglich).
Lies: ${CE}/libs/cache_engine/anatomy/ (genus_binding_traits.hpp, anatomy_base.hpp, set_composition.hpp/sequence_composition.hpp/view_composition.hpp, observer_aggregate.hpp), container_framework.hpp (§29), die Permutation-Engines, die 5 Docks; Ledger §14.1-G-AP15/§12-0708-#29.
Entscheide: exakte Bau-Reihenfolge (OrganConcept zuerst? dann per-Genus 8 Schichten? dann ABI-Bump?), disjunkte Agent-Pakete (1 Genus je Agent? OrganConcept-Owner separat?), warum ABI-Schritt ZULETZT (nach der Abgabe-Kette), BAND (vermutlich BAND-C/D, user-gated ABI). Owner-Dateien konkret. Beruecksichtige: user-gated Genus->Typ-ABI-GO (Option A/B), EIN ABI/golden-Regen-Fenster. Gib das STEP_SCHEMA fuer S12 zurueck.`, { label: 'R2:gattung', phase: 'Analyse', schema: STEP_SCHEMA, effort: 'high' }),

  () => agent(`${COMMON}
DEINE ANALYSE (R3) — S11 (NUMA-B8 + page_type-B10) UND die S4-Schaerfung durch B9 (Thesis-Profile vollstaendig).
Grundlage: §52-B10 (page_type bereits korrekt zweigeteilt: RAUM=System axis_12/HW4 huge_page_capable, DURCHSETZUNG=Organ axis_06 AllocPageHint capability-gegated; KEINE neue Verortung, nur anerkennen/benennen; Namensfalle axis_01_page_type=Baum-Struktur; cache-awareness-Pflicht FF3). §51-B8 (7. NUMA/Locking-System-Achse SOFERN compile-statisch erkennbar->Haupt, sonst dynamische Unter-Achse unter ISA an Tier-Binary delegiert; User: dynamisch->unter-ISA; per ultracode verifizieren). §51-B9 (Thesis-Profile WAS/WIE vollstaendig uebernehmen -> <measurement_tooling>-Unter-Achsen fuer Mess-Frameworks + Workload-Delegation an CEB, per XML-Schema; Werkzeuge im Planer + ALLEN Stufen).
Lies: ${CE}/libs/cache_engine/topics/hardware/axis_12_general_hardware*, axes/alloc/alloc_hw_config.hpp, hardware_isa_system_axis.hpp, measurement/system_axis_registry*, das S4-Ziel im Session-Plan (measurement_combos_of/plan_legend.hpp/xml_config_parser); die geforderten Thesis-Mess-Profile (suche docs/ nach thesis-profil/mess-profil/WAS-WIE-Anforderungen, m3v2/all_axes_golden.profile.xml, §9-B9).
Entscheide: (a) NUMA — reicht die IST-cpuid/sysfs-Info fuer compile-statische Erkennung oder dynamisch? konkrete Verortung. (b) page_type — welcher additive Anerkennungs-/Benennungs-Schritt (kein neuer Bau-Block). (c) B9 — welche konkreten Thesis-Profil-Anforderungen muessen als <measurement_tooling>/<run_methodology>-Schema-Elemente + Werkzeuge in S4 einfliessen (SCHAERFUNG von S4, nicht neuer Schritt). Gib das STEP_SCHEMA zurueck (S11), plus im Feld begruendung die konkrete S4-Schaerfungs-Delta-Liste fuer B9.`, { label: 'R3:numa-page-thesis', phase: 'Analyse', schema: STEP_SCHEMA, effort: 'high' }),

  () => agent(`${COMMON}
DEINE ANALYSE (R4) — BAND-Zuordnung + Kritischer-Pfad-Integritaet + Reihenfolge S10/S11/S12 relativ zu S1-S8.
Die Abgabe-Kette S1->S8 (28.07.) DARF NICHT gestoert werden. Die B-Praezisierungen sind groesstenteils architektur-vertiefend. Entscheide fuer JEDEN B-Punkt (B1/B2/B3/B4/B7/B8/B9/B10/B15) die BAND-Zuordnung und ob er auf dem 28.07.-Pfad liegt:
- B1 new-golden-Pflicht (schon in S2), B7 inkrementeller Cache (Voraussetzung N=2^17, meist BAND-C), B9 Thesis-Profile (schaerft S4, ON PATH), B10 page_type (additiv, minor), B4 ISA-Fork-A (system-axis, additiv?), B3 Meta-Meta (architektur), B8 NUMA (verifizieren), B2 Gattung (ABI ZULETZT), B15 Migration (geparkt).
Kernfrage: Welche neuen Schritte sind BAND-C/D (nach Abgabe) und welche muessen VOR 28.07.? Wie fuegen sich S10/S11/S12 ein, ohne Planer-Kern-Owner-Stau auf dem kritischen Pfad zu erzeugen (Planer-Kern ist Engpass S1->S5)? Wo teilt S10/S11 sich Dateien mit S1-S5 (system_axis_registry, anatomy_version_stamp, xml_config_parser) und braucht Owner-Serialisierung?
Lies Ledger §48 (Prioritaeten/Deadlines je Zeile) + den Session-Plan (Kritischer-Pfad-Markierung, Owner-Regeln). Gib das STEP_SCHEMA zurueck, wobei du im Feld position_in_kette die GESAMTE Einordnungs-Reihenfolge S1..S12 als Kette darstellst und in agent_pakete die Owner-Konflikt-Matrix (welcher neue Schritt kollidiert mit welchem S1-S5-Owner) auflistest.`, { label: 'R4:band-kritpfad', phase: 'Analyse', schema: STEP_SCHEMA, effort: 'high' }),
])

phase('Synthese')

const synthese = await agent(`${COMMON}

Du bist der SOFTWARE-ARCHITEKT. Vier Analyse-Reader haben die Platzierung/Sequenzierung der B-Praezisierungen untersucht. Integriere zu einem append-fertigen Markdown-Block, der den bestehenden Session-Plan ERWEITERT (S1-S9 bleiben; du haengst S10-S12 an + lieferst praezise Schaerfungs-Deltas zu S1/S4/S7).

R1 (ISA/Meta-Meta, S10): ${JSON.stringify(r_isa)}

R2 (Gattung, S12): ${JSON.stringify(r_gattung)}

R3 (NUMA/page_type/Thesis-Profile, S11+S4-Delta): ${JSON.stringify(r_thesis)}

R4 (BAND/Kritischer-Pfad/Reihenfolge): ${JSON.stringify(r_band)}

Erzeuge EXAKT dieses Markdown (deutsche Umlaute korrekt, KEINE Mojibake, ASCII in Code-Bezeichnern), im Stil der bestehenden S1-S9 (Tabellen Paket|Kern-Dateien(Owner)|Deliverable|Verifikation, Agenten-Zahl, Koordination, Gate, Blockiert-durch):

## PLAN-SCHAERFUNG 2026-07-20 (B1-B15-Praezisierung) — Erweiterung S10-S12 + Deltas

### Einordnung in die Kette (S1..S12)
<1 Absatz: die gesamte Reihenfolge, welche neuen Schritte BAND-C/D nach der Abgabe liegen, warum die Abgabe-Kette S1-S8 unberuehrt bleibt, Owner-Konflikt-Matrix kurz.>

### Schaerfungs-Deltas zu bestehenden Schritten
- **S1-Delta:** <falls Stempel-System-Erweiterbarkeit B4 den kMeasurementAxisVersionLine/Stempel-Bau in S1 beruehrt>
- **S4-Delta (B9 Thesis-Profile, ON PATH):** <konkrete <measurement_tooling>/<run_methodology>-Schema-Elemente + Werkzeuge-in-allen-Stufen aus R3; das ist eine VERSCHAERFUNG von S4, kein neuer Schritt>
- **S7-Delta:** <falls Meta-Meta/Organ-analoges-Array die Hybrid-Architektur beruehrt; sonst 'keine'>

### S10 — Meta-Meta-Achsen + Hardware-Manager-Array + ISA-Fork-A + Stempel-System-Erweiterbarkeit (BAND aus R1/R4)
<volle Schritt-Spezifikation aus r_isa: Ziel, Tabelle, Agenten-Zahl, Koordination, Gate, Blockiert-durch, Risiken>

### S11 — 7. System-Achse NUMA/Locking-Verortung (B8) + page_type-Anerkennung (B10) (BAND aus R3/R4)
<volle Schritt-Spezifikation aus r_thesis (S11-Teil): Ziel, Tabelle, Agenten-Zahl, Gate, Blockiert-durch, Risiken; page_type = additiver Anerkennungs-/Benennungs-Schritt, kein neuer Bau-Block>

### S12 — Gattungs-Vervollstaendigung (B2), LETZTER ABI-Schritt (BAND aus R2/R4)
<volle Schritt-Spezifikation aus r_gattung: OrganConcept-Reihenfolge, per-Genus-Pakete, warum ABI zuletzt, user-gated, Tabelle, Agenten-Zahl, Gate, Blockiert-durch, Risiken>

### Aktualisierte Kritischer-Pfad-Markierung
<1 Absatz: der 28.07.-Pfad bleibt S1/A1->S2->S3->S4(+B9-Delta)->S5->S6->S7->S8; S10/S11/S12 als BAND-C/D nachgelagert bzw. additiv; welche USER-GO-Gates neu (ISA-Fork-A-Ausbau der Alt-Version unter Absprache; Gattung Genus->Typ-ABI-GO).>

Gib NUR diesen Markdown-Block zurueck (kein Vorwort, keine Code-Fences drumherum).`, { label: 'architekt:synthese', phase: 'Synthese', effort: 'high' })

return { synthese, band_summary: { isa: r_isa.band, gattung: r_gattung.band, numa_page: r_thesis.band, kritpfad: r_band.position_in_kette } }
