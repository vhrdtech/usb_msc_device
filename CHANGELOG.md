# Changelog

## [Unreleased]

### Added

- Repo scaffold: crate skeleton (`no_std`), `just test`/`lint`/`install`/`deploy`, CI (fmt, clippy, tests, typos,
  cargo sort), licence (MIT OR Apache-2.0) (P2628#16oct-1016).
- FEATURES.md with the planned items and ideas of `prj/P2628-logring/design/plan.md`: area `MSC` (MSC-1, MSC-2),
  bound to its P2628 task where one exists (P2628#16oct-1016).
- `just test --changed` runs only the workspace crates changed against main and their dependents (`tpm test changed`, nextest's `rdeps()`); plain `just test` runs everything, as `just test-all` does (tpm ops#22oct-2049).

