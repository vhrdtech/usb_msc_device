# Changelog

## [Unreleased]

### Added

- Repo scaffold: crate skeleton (`no_std`), `just test`/`lint`/`install`/`deploy`, CI (fmt, clippy, tests, typos,
  cargo sort), licence (MIT OR Apache-2.0).
- FEATURES.md with the planned items and ideas from internal design notes: area `MSC` (MSC-1, MSC-2).
- `just test --changed` runs only the workspace crates changed against main and their dependents (nextest's
  `rdeps()`, via internal tooling when available, otherwise the full suite); plain `just test` runs everything,
  as `just test-all` does.

### Changed

- docs: internal references removed.

