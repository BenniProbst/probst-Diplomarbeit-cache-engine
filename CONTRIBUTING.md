# Contributing

Umbrella repository of a diploma thesis (Technische Universitaet Dresden, 2026).
The code is developed by Benjamin-Elias Probst; the rights in the repository's
own code are held by BEP Venture UG (haftungsbeschraenkt), trademark Comdare.
Contributions are welcome as issues and pull requests. The thesis text itself
(`thesis/diplomarbeit`) is a personal examination work and is not open to
contributions.

## Development Setup
- C++23, CMake 3.20+; GCC and Clang are both built in CI (dual-compiler rule).
- `git submodule update --init Code/external/comdare-cache-engine Code/external/comdare-prt-art`
- `./configure.sh && make && make check` (GNU build path; details in `MANUAL_RUN.md`).

## Branches & Commits
- `development` is the integration branch, `main` the stable branch (Gitflow).
- Topic branches: `bau/<topic>`; merges are `--no-ff`; history is never rebased.
- Commit messages: imperative subject line, body explains WHY; ASCII-only.
- Decisions are booked in `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`
  (numbered KON entries, newest at the top); session protocols under `docs/sessions/`.

## Tests & Style
- `ctest` (label `da_unit`) must be green, in Debug and in Release.
- Google Test only; shell probes are not tests.
- ASCII-only source and documentation, lines <= 120 bytes (`.clang-format`, ColumnLimit 120).
- Every CI guard under `Code/ci_wachen/` is built red-first: prove that the guard
  bites before you heal the tree, and keep the literal red output in the test's header.
- Never mark something as verified without the literal tool output.

## Licensing of Contributions
- Own code: Apache-2.0 (`LICENSE`, `NOTICE`).
- Every file needs REUSE-compliant licensing information (REUSE Specification 3.3):
  an SPDX header in the file or an entry in `REUSE.toml`. Run `reuse lint` at the
  repository root (for example `pipx run reuse lint` or `uvx --from reuse reuse lint`)
  before pushing.
- Third-party material: add its license text to `LICENSES/`, its path to
  `REUSE.toml` and its attribution to `NOTICE`; the guard
  `test_ci_wache_lizenz_konsistenz` fails otherwise. Never change the license of
  vendored code.
- By submitting a contribution you confirm that you have the right to license it
  under Apache-2.0 and that you do so.

## Pull Request Checklist
- [ ] README/docs updated; ledger entry added if a decision changes
- [ ] Tests added or adjusted, red-first proven
- [ ] `CHANGELOG.md` updated if user-visible
- [ ] `reuse lint` green; secret scan (`.gitleaks.toml`) green
- [ ] CI pipeline green (GitLab and the GitHub mirror)
