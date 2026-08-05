# ADVERSARIALE BEWERTUNG der 6 Codex-Befunde zur A2-Eichung (C1-C6)

Objekt: ce @ 60c7c56a (READ-ONLY). Grundlagen gelesen: Ledger nachmittag-8/-7/-6/-5/-2,
Eich-Wellen-Plan (backups/20260805-anker-a2-eichung/eich-wellen-plan.md), Anker-Definition
(backups/20260805-anker-planung/definition.md). Alle Fundstellen am Objekt erhoben, nicht zitiert.
Bewertet ADVERSARIAL gegen Codex UND gegen die Manager-Voreinschaetzung (Wunschdenken-Probe).

## Objekt-Fakten (Basis aller Verdikte, am Code gezaehlt)

- Preimage = GENAU 6 Glieder (abi/anatomy_fingerprint.hpp:104,128-132):
  [0] fingerprint_format=2, [1] Organ-Zeile, [2] System-Zeile, [3] Mess-Tooling-Zeile,
  [4] Sub-Achsen-WERTESET-Segment, [5] Overlay (leer, L14).
- W10-Zellwert-Schluessel der System-Zeile sind ABSCHLIESSEND target_isa / operating_system / simd
  (abi/system_cell_values.hpp:112-122). KEIN opt, KEIN cxx, KEIN build_type.
- Das WERTESET-Glied [4] rendert NUR drei Sub-Achsen-VERSIONEN (sub=cacheline@vN,node_width@vN,
  alloc_hw@vN; abi/subaxis_valueset_segment.hpp:44-68). Es traegt KEINE Enabled-MENGEN.
- cxx/opt/bt reisen ausschliesslich im build_version-Suffix (+cxx=/+opt=/[+bt=Debug],
  profile_run_entry.hpp:905-333 der Perm-Schleife) => NUR im .version-Sidecar, das seit der Eichung
  keine Skip-Rolle mehr hat (bo:293-300: dll_is_current = DER EINE Vergleich .fingerprint==expected).
- Zell-Pfad-Trennung: NUR in der EMISSIONS-Welt (director:1187 dll_dir=gn_out/<slug>/<host>/perm<idx>
  je opt x simd-Perm; slug=combo, NICHT build_type). Der LOKALE Multi-Perm-Loop (profile_run_entry:
  opt x simd-Schleife um run_all_passes) teilt EIN cfg.output_dir=a.dll_dir ueber ALLE Perms.
- gn_out persistiert ueber Jobs (director:1042-1049 GIT_CLEAN_FLAGS -e Code/gn_out) — Debug- und
  Measure-/Release-Jobs derselben Combo/Lane/Perm-Nr teilen DENSELBEN dll_dir (slug traegt kein bt).

---

## C1 — expected-Fingerprint ohne build_version/build_variant_sig

**VERDIKT: REAL-NEU (Eich-Regression, HOCH).** Die Manager-Hoffnung "ENTSCHAERFT durch
Zell-Pfad-Disziplin / W10-System-Zeile traegt die Zellwerte" ist am Objekt WIDERLEGT:
die W10-Zellwerte sind nur isa/os/simd; opt/cxx/bt stehen in KEINEM der 6 Glieder.

Konkrete Lauf-Folgen in den Fehler (beide mit COMDARE_BESTANDSLOG=true, sonst kein Skip):

1. **Lokaler Multi-Perm-Lauf (EIN Prozess):** Profil mit <system_axes> opt_levels [O2,O3].
   Perm(O2) baut, schreibt .fingerprint=F (F traegt kein opt). Perm(O3): expected==F (identisch!),
   gleicher Pfad (cfg.output_dir konstant ueber die Schleife) => dll_is_current TRUE => SKIP.
   Die O3-Zelle misst die O2-Binary unter dem O3-Label (row_build_version=+opt=O3; der Resume-Stamp
   differiert => FRISCHE Messung auf der FALSCHEN DLL). Vor der Eichung fing das der
   .version-Vergleich (+opt=O2 != +opt=O3). Dieselbe Klasse: cxx (gcc vs clang).
2. **Debug->Release ueber Job-Grenzen:** Debug-Batch (COMDARE_BUILD_TYPE=Debug, -O0 -g) schreibt
   .fingerprint=F nach gn_out/<slug>/<host>/perm<idx>; spaeterer Measure-Batch derselben Combo/Lane/
   Perm-Nr (persistentes gn_out, slug ohne bt): expected==F => SKIP => es wird die DEBUG-DLL
   gemessen. Genau der Reuse-Fall, den build_type_stamp.hpp:3-5 per +bt=Debug-.version-Trennung
   SCHARF verhindern sollte. Der dortige Kommentar (:8-10) "die build_version steht in dessen
   Preimage" ist FALSCH — die build_version ist KEIN Preimage-Glied (Kommentar-Regression der Welle).

Die CI-Zell-Pfad-Trennung (perm<idx>) deckt NUR opt x simd in der Emissions-Welt; sie deckt weder
den lokalen Multi-Perm-Loop noch die bt-Achse noch cxx. F7s Praemisse "der SHA512 deckt ALLE Stempel
allein" ist fuer die drei .version-only-Stempel +cxx/+opt/+bt am Objekt beweisbar NICHT erfuellt.

**Fix:** zweigleisig.
(a) FINGERPRINT-NEUTRAL (Interim, vor Trigger): Zell-Pfad-Disziplin vervollstaendigen — lokaler
    Multi-Perm-Loop bekommt per-Perm-Unterordner (output_dir/<cxx-opt-bt-zelle>/), die Debug-Welt
    einen eigenen dll_dir in der Emission (bt-Suffix am Pfad). Preimage unberuehrt; F7 "NUR EIN
    Vergleich" bleibt intakt (Pfade waren schon das sanktionierte Zell-Trennmittel).
(b) **OWNER-GATE O-2**: Preimage-Glied-Nachtrag der Bau-Zellen-Identitaet (cxx/opt/bt; ggf. bvset
    im selben Zug, s. C6) = globaler Neuanker. NIE stillschweigend; einzige Form, die die
    F7-Praemisse code-wahr macht.

## C2 — Provider an COMDARE_BESTANDSLOG=true gekoppelt; Default-OFF baut alles neu

**VERDIKT: DEKLARIERT-GEDECKT.** Exakt Eich-Plan D6 + R-A: "ohne COMDARE_BESTANDSLOG=true ...
Bau-Resume via Skip ist im Default-Modus TOT (ehrlicher Neubau statt Alt-Skip). Owner-gedeckt (F7
Uebergangsregel fail-closed, D-05, A-2, KEIN Grandfathering)"; Voll-Bau-4 faehrt per Konstruktion
MIT Bestandslog; P11 prueft das Env; test_a2(f) Lauf 4 macht die Folge zum BEWIESENEN Verhalten.
Codex hatte den Ledger-/Plan-Kontext nicht. Kein Fix; Eskalation nur bei realem CI-Zeit-Schmerz
(deklarierter R-A-Pfad: dann W-Welle).

## C3 — Teilsatz-Skip via pull_tier_prefix ohne .version-Transport-Marke

**VERDIKT: DEKLARIERT-GEDECKT (Eich-Plan R-C).** Durchgespielt am Objekt: Push-Ordnung ist
dll ZUERST, optionale Sidecars MITTE, .version ZULETZT (artifact_cache.hpp:386-424) — d.h. ein
remote sichtbares .fingerprint impliziert eine VOLLSTAENDIG gepushte perm.dll (mc_cp-verifiziert).
pull_tier_prefix (mc mirror, suffix-blind, :494-515) kann also dll+fingerprint OHNE .version
hydrieren; dll_is_current skippt dann. Genau das deklariert R-C als sanktionierte F7-Semantik
("die Binary-Identitaet ist durch den Fingerprint bewiesen") und Kommentar-Punkt 12 der Welle
dokumentiert es (artifact_cache.hpp:427-437). Fail-closed-Restpruefung positiv: fehlt die dll
=> kein Skip; fehlt .fingerprint => kein Skip; ein spaeterer Push des marklosen Satzes WIRFT
sichtbar (TP1FK1-B2, :377-384) => Bestandslog-Ausschluss statt Phantom. Kein Fix.

## C4 — Mess-Resume-Stempel traegt keinen Fingerprint, prueft nicht b.skipped

**VERDIKT: REAL-NEU als Eich-FOLGE (Mess-Schnitt-Fenster-Klasse); der Stempel selbst ist BESTAND.**
Historik-Pruefung (Spezialauftrag): der Resume-Stamp war NIE fingerprint-tragend — resume-v1..v5
(iterator:876-931) fuehren build_version/Tags/algo_sig/Workload/Dims, keinen Fingerprint;
F-B10/TP1FK1-B10 (iterator:1664-1700) betrafen die Bau-FEHLER-Reihenfolge + stale-Invalidierung,
nicht die Fingerprint-Frage. ABER: vor der Eichung existierte kein "Fingerprint-only-Neubau" —
Neubau-Ausloeser waren version/algos(/variant), und version+algos stehen IM Stamp. Die Eichung
oeffnet die neue Klasse "Identitaets-geaenderter Neubau bei gueltigem Alt-Stamp": ein Delta, das
NUR das Preimage bewegt (heute real: Mess-Combo-Wechsel im selben lokalen dll_dir — Glied [3]
bewegt sich, weder build_version noch algo_sig; kuenftig: Werteset-/Overlay-Bewegungen), baut die
DLL neu (b.skipped==false), lazy_try_resume_binary (iterator:1815-1819) uebernimmt trotzdem die
alten Zeilen => NEUE DLL, ALTE MESSWERTE. Der Eich-Plan deklariert nur "KEIN Umbau des
Mess-Resume-Stamps" (Nicht-Ziel Par. 7), NICHT diese Integritaets-Folge.
**Fix (FINGERPRINT-NEUTRAL, klein):** Resume-Anspruch an b.skipped koppeln (nur eine
uebersprungene = identitaets-bewiesene Binary darf resumen; ein frischer Bau entwertet den
Alt-Stand nach dem F-B10-Muster result.csv.stale) UND/ODER `|fpr=<expected_fp>` additiv in den
binary_resume_stamp (Format-Bump-Muster resume-v6 => ehrliche Neu-Messung statt stillem Stale).
Beides beruehrt das Preimage nicht; vor Voll-Bau-4 existiert kein schuetzenswerter Mess-Bestand.

## C5 — stale Sidecar-Anker neben neu kompilierter DLL (leerer Provider / Writer-Fehlschlag)

**VERDIKT: REAL-NEU (Eich-Verschaerfung eines Bestands-Lochs).** Durchgespielt: Lauf 1 (Bestandslog
AN) baut, schreibt .fingerprint=F1. Lauf 2 (Bestandslog AUS, z.B. Default-CI/Debug im selben
persistenten gn_out): expected leer => fail-closed NEUBAU (evtl. mit ANDERER Identitaet, z.B.
anderer Combo); write_fingerprint_sidecar("")=no-op (bo:349-353) => F1 BLEIBT neben der NEUEN DLL
stehen. Lauf 3 (Bestandslog AN, alte Identitaet): expected==F1 => FALSCHER SKIP; und der
Async-Push verteilt den stalen F1-Anker neben der neuen DLL in den Store (kOptionalTierSidecars).
Zweite Zuendung: schlaegt der ofstream-Open des Writers fehl (kein Fehlerpfad, anders als
write_version_sidecar TP1FK1-B2), ueberlebt der Alt-Anker einen Neubau still. pull_tier_binary
raeumt stale Sidecars VOR der Hydration (write-ZULETZT-Disziplin, :455-457) — provision_core tut
es beim NEUBAU nicht: die Disziplin-Luecke, die Codex meint. Lager-seitig (bestand_key_of liest
denselben stalen Anker) bestand das Loch schon VOR der Eichung; die SKIP-Wirkung ist NEU.
**Fix (FINGERPRINT-NEUTRAL):** in provision_core nach erfolgreichem Compile, VOR den Sidecar-
Writes: stale Sidecars entfernen, deren neuer Wert leer ist (mindestens fingerprint_sidecar_path
bei expected_fp.empty(); konsequent analog .algos/.variant/.version) + write_fingerprint_sidecar
fail-loud im TP1FK1-B2-Muster (Schreibfehler => Sidecar entfernen => fail-closed statt stale).

## C6 — build_variant_sidecar:13 behauptet nicht-existentes bvset-Preimage-Glied

**VERDIKT: REAL-NEU (staler/falscher Kommentar aus Eich-Commit 2; substanzielle Deckungsluecke
real, aber opt-in-begrenzt).** Am Objekt gezaehlt: KEIN bvset-Glied im Preimage (6 Glieder, oben);
das Sub-Achsen-WERTESET-Glied [4] deckt NUR die drei Sub-Achsen-VERSIONEN, KEINE Enabled-MENGEN
(Spezialauftrag beantwortet: NEIN, es deckt Enabled-Mengen-Wechsel NICHT). Kette verifiziert:
COMDARE_VARIANT_GATE=true (profile_run_entry:396-399) -> driver_build_variant_signature (bvset-
Mengen-Signatur der CMake-Enabled-Listen) -> BuildConfig.build_variant_sig -> write_variant_sidecar
— und NIEMAND vergleicht mehr (dll_is_current 2-arg). Das Cross-Maschinen-Gate (restringierte
Enable-Menge => Neubau, build_variant_set_signature.hpp:13-16) ist seit der Eichung faktisch
WRITE-ONLY; der in der Welle NEU geschriebene Kommentar (Plan-Punkt 14 traegt den Fehler selbst)
behauptet eine Preimage-Deckung, die nicht existiert. Begrenzung ehrlich: opt-in-Env, und bei
voll-enableten Flotten-Builds (Ist der 8er-Doktrin) ist die Signatur beidseitig identisch = inert.
**Fix:** (a) FINGERPRINT-NEUTRAL sofort: Kommentar auf die Wahrheit drehen ("Enabled-Mengen-Wechsel
ist seit A2 eine DEKLARIERTE Deckungsluecke des Fingerprints; .variant ist reine Provenienz-Legende
bis zum bvset-Preimage-Entscheid") — an :13, an profile_run_entry:388-393 und im test_g2-Kopf.
(b) Enabled-Mengen-Deckung selbst = Preimage-Glied = Teil des **OWNER-GATE O-2** (mit C1 EIN
Entscheid, EIN Neuanker — nie zwei getrennte Shifts).

---

## FIX-PLAN (priorisiert)

1. **C1-Interim (fingerprint-neutral, VOR weiteren Mess-/Multi-Perm-Laeufen):** Zell-Pfad-Trennung
   vervollstaendigen (lokaler opt x simd-Loop per-Perm-Outdirs; Debug-Welt eigener dll_dir in der
   Emission). Umfang: profile_run_entry (make_cfg/Loop) + director-Emission + TU. Kein Preimage-Byte.
2. **O-2 Owner-Vorlage (parallel, NUR Vorlage):** Preimage-Glied-Nachtrag Bau-Zellen-Identitaet
   (cxx/opt/bt) + bvset-Mengen (C6) als EIN gemeinsamer Neuanker-Entscheid; Kosten/Zeitpunkt-Analyse
   (vor Trigger = letzter billiger Moment vs. G8-Freeze) beilegen. KEIN Bau ohne Owner-GO.
3. **C5-Fix (fingerprint-neutral):** stale-Sidecar-Clearing im Neubau-Pfad von provision_core +
   fail-louder Fingerprint-Writer (TP1FK1-B2-Muster). Umfang: bo + test_a2-Erweiterung.
4. **C4-Fix (fingerprint-neutral):** Resume nur bei b.skipped (+ optional |fpr= im Stamp,
   resume-v6-Bump). Umfang: iterator measure_one_binary + Resume-TU.
5. **C6-Kommentar-Fix (fingerprint-neutral, trivial):** drei Kommentar-Stellen auf die deklarierte
   Luecke drehen (Doku-Doktrin: Alt-Text datiert stehen lassen).
6. C2/C3: KEIN Fix (deklariert gedeckt); R-A-Eskalationspfad bleibt notiert.

Alle Fixes unter A3-Dual-Review (Codex+Fable) und mit den Anker-Dauer-Auflagen-Beweisen
(abi/ 0 Zeilen, kFrozenFingerprintV1 3 TUs, golden-CRC, golden-320) zu fahren.

## OWNER-GATES (nur echte)

- **O-2:** Preimage-Glied-Nachtrag (Bau-Zellen-Identitaet cxx/opt/bt aus C1; Enabled-Mengen/bvset
  aus C6 im selben Zug) = globaler Fingerprint-Neuanker ueber den gesamten kuenftigen Bestand +
  erneute TP1-Inventur. Einziges echtes Gate; alles andere ist fingerprint-neutral loesbar.
