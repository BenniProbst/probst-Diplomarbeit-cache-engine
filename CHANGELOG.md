# Changelog -- probst-diplomarbeit-cache-engine

This repository cuts no versioned releases before the thesis submission
(2026-09-15). Its authoritative change record is the decision ledger
`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`: every landing is booked there
as a numbered KON entry, newest first at the top of the file (KON128 as of
2026-08-25). Session protocols live under `docs/sessions/`, plans under
`docs/plaene/`. This file only points at that chain and lists user-visible
changes of the repository layout.

The format follows Keep a Changelog; dates are ISO (YYYY-MM-DD).

## [Unreleased]

### Added
- 2026-08-25 (A5 / D3a, D4): REUSE 3.3 layout -- `REUSE.toml`, `LICENSES/` with
  the byte-identical copy of the Comdare Research License 1.0 of the
  cache-engine submodule; NOTICE grammar `WACHE: LIZENZTEXT <datei> BYTEGLEICH
  <quelle>` and assurance (8) of the guard `test_ci_wache_lizenz_konsistenz`
  (copy must be byte-equal to its source); community health files (`README.md`,
  `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`, `CITATION.cff`, this file).

### Changed
- 2026-08-25: `LICENSE` section GELTUNGSBEREICH gained point 4 (license texts
  under `LICENSES/`, REUSE.toml); `NOTICE` gained the section "LIZENZTEXTE UNTER
  LICENSES/ UND DIE REUSE.toml".

## History
- Up to KON128 (2026-08-25): see the ledger. The KON chain (KON1 ... KON128) is
  the changelog of this project; nothing is recorded here that is not booked there.
