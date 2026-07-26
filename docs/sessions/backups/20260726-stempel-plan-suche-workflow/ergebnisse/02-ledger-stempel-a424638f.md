GEFUNDEN. Die Original-Planung des Stempel-/Versionierungs-Schemas liegt wortgenau im Ledger als Kette autoritativer User-Direktiven (2026-07-19 bis -20), NICHT in einem Backup-Workflow. Die heutige Session-Datei ist nur die Q-A-Mitschrift, die selbst auf diese Original-Planung verweist.

QUELLE (alle Zeilen in `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`):

## 1. "je Achsen-Typ -> je Haupt-Achse mit Algorithmus + eindeutiger Version" -> §43 (Z. 2353-2359)
Header Z.2353: "§43 - Einkompilierte string_view-Versionierungs-Stempel je Binary-Stufe (2026-07-19 nachts, User-Direktive)". User-Direktive verbatim (Z.2355):
> "jede Achse den durch sie gewaehlten Algorithmus und daher das gesamte Array an Achsen-Algorithmen und Einstellungen der Haupt-Achsen als string_view in die Tier-Binary zur Versionierung einkompiliert ... Die Tier-Binaries haben ihren string_view-Versionierungs-Stempel ueber die [d,e,f][g,h,i]-Kombination in 2 verschiedenen string_view-Zeilen: eine fuer System-Achsen und eine fuer Organ-Achsen-Algorithmus-Versionen. Jede Achsen-Version (Mess/System/Organ) braucht jeweils auch die Zuordnung der Achsen-Beschreibung und des gewaehlten Algorithmus der Haupt-Achse jeder Kategorie, um die Version zuordnen zu koennen."

Format-Zeile (Z.2359): kSystemAxisVersionLine ([d,e,f]) + kOrganAxisVersionLine ([g,h,i]) + kMeasurementAxisVersionLine ([a,b,c]) — "Nur HAUPT-Achsen (§42.b: Unter-Achsen sind Laufzeit, nie Stempel-Bestandteil)". Das ist exakt die je-Typ->je-Haupt-Achse-Gliederung.

## 2. "keine eigene Version fuer CEB/Tier, nur Planner" -> §43.b + §58-V — BESTAETIGT wortgenau
- §43.b (Z.2362, X.Y.Z-Schema): "Der Experiment-Planer traegt auch einen string_view-Stempel, aber nur ueber die eigene statische Versionierung ... Die Versionierung und Stempel sind X.Y.Z mit X.Y die Feature-Version und Z die Revision des Debuggings ... das gilt fuer jeden Achsen-Algorithmus (alle Typen) einzeln sowie fuer den Experiment-Planer statisch." Einordnung: Planer = Selbst-Version X.Y.Z, "KEINE Achsen-Arrays (der Planer permutiert, er ist keine Permutation)".
- §58-V (Z.3018-3021), Header Z.3014 "§58 - VERSIONIERUNGS-MODELL", ist die autoritativste Bestaetigung:
  - Z.3019: "PLANER: EIN Versions-Stempel X.Y.Z (semver der Planer-Binary)."
  - Z.3020: "CEB: KEINE Gesamt-Versionierung. Ein ARRAY [Xa.Ya.Za, Xb.Yb.Zb, Xc.Yc.Zc] - je einkompilierter Mess-Achse [a,b,c] ein eigenes X.Y.Z pro Algorithmus a, b, c (pro Mess-HAUPT-Algorithmus). Nur HAUPT-Achsen im Stempel."
  - Z.3021: "TIER-BINARY: KEINE Gesamt-Versionierung. ZWEI SEPARATE Array-Versionierungen: eine fuer die System-Achse, eine fuer die Organ-Achse ... Unter-Achsen = dynamische Laufzeit-Parameter fliessen zur Laufzeit durch die Binary hindurch und sind NICHT im Binary-Stempel."

Also: JA, der Ledger bestaetigt woertlich, dass CEB und Tier KEINE eigene (Gesamt-)Version tragen — sie identifizieren sich aus den Haupt-Achsen-Rekombinationen + deren Algorithmus-Versionen; nur der Planer traegt eine eigene X.Y.Z.

## 3. §57-S3 (Z.3007-3010) — Stempel-Schichtung (Zwischenstufe zwischen §43 und §58)
> "CEB-Stempel (Typ + Version) = die Mess-Achse des Planers ... Tier-Binary-Stempel (Typ + Version) = System-Achse x Organ-Achse ... binary_id bleibt Organ-only (17-Organ-Kern) - der Tier-STEMPEL traegt aber System x Organ".

## 4. binary_id traegt KEINE Version -> Engineering-Dossier 2026-07-18 (das aelteste Stueck)
`/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/plaene/20260718-incremental-caching-vor-BAUPLAN-INCREMENTAL-TIER-BINARY-CACHE.md`, User-Direktive verbatim (Z.10-12): "Jedes Binary traegt je Organ-Achse ein Listing: welcher Algorithmus + Algorithmus-Version." Umsetzung Z.51-52: "binary_id traegt nur name() (keine Version) -> binary_id byte-identisch". Das ist die konkrete Implementierungs-Planung ("keine eigene Versionsnummer der Binary").

## 5. Komplex-Achse / Command-Pattern / gemeinsamer komplexer Stempel — nur TEILWEISE vor-geplant
Der rekursive Wrapper mit indirekter Identitaet ueber die gewrappten Haupt-Achsen ist als Konzept in §51-B3/§52-B3 vor-geplant (Ledger Z.2769):
> "extension_hardware wird MANAGER-Haupt-Achse ueber statisches Achsen-ARRAY; jeder Erweiterungstyp = eigene Meta-Meta-Achse ... Freigabe an Organ-Achsen per COMMAND-Pattern ... Organ-Analogon Manager + aus-Fold-abgeleiteter Stempel."
Und §54-Header (Z.2713) nennt explizit "Meta-Meta-Command-Freigabe". Die EXAKTE Formulierung "gemeinsamer komplexer Stempel" / "indirekte Identitaet ueber die gewrappten echten Haupt-Achsen" existiert vor 26.07. jedoch NUR als "aus-Fold-abgeleiteter Stempel" — die praezise Owner-Formulierung ist erst heute (Q-A) festgehalten in:
`/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260726-SESSION-layer-modell-antworten-QA-QF-stempel-doktrin.md` (Z.20-26, 56-57). Diese Datei ist die Q-A-Mitschrift selbst (Z.24: "Owner: 'das ist schon genau geplant' -> ultracode-Suche in backups/sessions beauftragt"), also NICHT die gesuchte Original-Quelle, sondern der Anlass der Suche.

## Erganzung (Ist-Abweichung + spaeteres SHA512)
- §59 (Z.3059) ergaenzt einen DRITTEN Tier-Stempel = Merge-Kombination (zusaetzlich zu System-Array + Organ-Array).
- §62 IST-Abweichung (Z.3288): Stempel sind im Code aktuell EINZEL-Zeilen (kein Array), das CEB-eigene Mess-Array FEHLT, X.Y.Z ist nur Formatter ("v1"->"1.0.0"), Quelldaten flaechendeckend "v1".
- §62-D (Z.3231-3234): spaeterer SHA512-Fingerprint-Stempel (CT, std::map/Factory SHA512->Pfad) UEBER die bestehenden Stempel-String-Arrays fuer effizienten Replay-Lookup.
- §66 (Z.3359-3368): STEMPEL-Finalisierung (K7b-Array-Form) = GATE fuer Voll-Build.

FAZIT: Die Original-Planung, die die Owner-Worte woertlich deckt, ist §43 + §43.b (Z.2353-2362) und §57-§58 (Z.2993-3034) im Ledger — dort steht verbatim "PLANER: EIN Versions-Stempel X.Y.Z / CEB: KEINE Gesamt-Versionierung / TIER-BINARY: KEINE Gesamt-Versionierung ... Nur HAUPT-Achsen im Stempel". Der Komplex-Achsen-Command-Stempel ist konzeptionell in §51-B3/§54 vor-geplant, aber in der von Owner zitierten Praezision erst in der heutigen Q-A-Session fixiert.