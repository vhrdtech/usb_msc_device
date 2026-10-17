# Working on usb_msc_device

Guidance for AI agents and contributors. Read this before changing code.

## What this is

`usb_msc_device` is a USB Mass Storage device class for
[embassy-usb](https://github.com/embassy-rs/embassy): Bulk-Only Transport, SCSI transparent command set, several
LUNs on one interface, an async `Lun` trait, media change (unit attention) and write protect. `embassy-usb` only
ships a host-side MSC today; there is no device-side class for it, so this fills that gap as its own repo, not
tied to any one caller. First user: [logring](https://github.com/vhrdtech/logring)'s two-LUN USB view (the real
exFAT volume passthrough and a synthesized read-only log tree), but this crate knows nothing about logring,
exFAT or logs — only SCSI/MSC.

Sibling repos (tpm project P2628; design: `prj/P2628-logring/design/plan.md` in the tpm folder, not here):
[`logring`](https://github.com/vhrdtech/logring), [`exfat_lite`](https://github.com/vhrdtech/exfat_lite).

**Other people's project**: this might later be offered to `embassy` as an `embassy-usb` device class. Until the
person decides to open that PR, nothing here is pushed, proposed or discussed on embassy's repo or forums
(tpm CLAUDE.md "Other people's projects") — it stays its own repo, usable standalone via `path`/git dependency.

## FEATURES.md is the source of truth

[FEATURES.md](FEATURES.md) lists every feature with its status, every known bug, and what is planned, area `MSC`.

- **Name IDs with a short slug when talking to the user**: `MSC-1 bulk-only-class`, never a bare `MSC-1`. Commit
  messages, CHANGELOG and code `TODO`s keep the bare ID.
- **New IDs**: `tpm work claim MSC` prints the next free one. Never renumber or reuse IDs.
- Status ✅ verified against a real host OS mount; 🧪 unit-tested against a fake host/transport only; 📋 planned
  with a P2628 task; 💡 an idea, not filed as a task yet.

## CHANGELOG.md records every change

Every change a user would notice gets an entry under `## [Unreleased]` in the same commit (`### Added`,
`### Changed`, `### Fixed`, `### Removed`), short and user-facing, with the feature ID in parentheses. Pure
refactors and typo fixes don't need one.

## Layout

Single crate at the repo root (`src/`), `no_std`, built on `embassy-usb`'s class trait:

- the Bulk-Only Transport state machine (CBW/CSW, data stage, stall/reset recovery);
- SCSI transparent command set: `INQUIRY`, `READ CAPACITY`, `READ`/`WRITE` (10), `TEST UNIT READY`,
  `REQUEST SENSE`, `PREVENT ALLOW MEDIUM REMOVAL`, `MODE SENSE` (write-protect bit);
- several LUNs on one interface (`GET_MAX_LUN`), addressed by the CBW's LUN field, not extra descriptors;
- an async `Lun` trait a caller implements per logical unit (block read/write, capacity, write-protect, media
  present), so the storage backend (a real exFAT passthrough, a synthesized read-only tree, a RAM disk for
  tests) is the caller's choice;
- media change / unit attention: a LUN can tell the host its content changed (SCSI unit attention sense), for a
  caller that regenerates a virtual volume on demand.

SCSI commands and CBWs arrive from the host — untrusted input: every command is validated (length, LUN range,
LBA range against the LUN's reported capacity) before touching the `Lun` trait; malformed or out-of-range
requests get a sense code back, never a panic or an out-of-bounds access.

## Commands

```sh
just test    # cargo test (host, a fake Lun and a fake USB transport) + a no_std build check
just lint    # fmt --check, clippy -D warnings (host and no_std)
just install # library only: nothing to install on this PC
just deploy  # bring this PC up to main
```

Real host behaviour (Linux/Windows/macOS mounting, media-change handling, timing under real USB) needs real
hardware (rePort) and those OSes — a person's step or a hardware test session, recorded in FEATURES.md with what
was actually checked versus only exercised against a fake transport.

## Dependencies

Pure Rust only; `embassy-usb` is the one real dependency once the device class lands (R9); nothing else without
a reason in the commit. Check new dependencies with `cargo tree` for `-sys` crates.

## Code conventions

- Errors/sense codes: typed, no panics on anything that comes from the host or from a `Lun` implementation
  returning an error.
- The device class stays usable without any particular storage backend: no exFAT, no logring types here.

## Tests

- The Bulk-Only Transport state machine and SCSI command parsing: unit tests against recorded/crafted CBWs, a
  fake `Lun`, no real USB hardware.
- A fuzz target for CBW parsing (SCSI commands are untrusted input).
- A bug fix starts with a failing test when the bug can be reproduced in one.

## Commits

Conventional Commits with a scope: `feat(bot): ...` (bulk-only transport), `fix(scsi): ...`, scopes `bot`,
`scsi`, `lun`, `build`. Short imperative summary, blank line, body with what and why; reference feature IDs.

Commit on your own initiative on a session branch (`tpm work new SLUG usb_msc_device`), each finished step one
commit with FEATURES.md and CHANGELOG.md updated in it. When the work is done and the user agrees, `tpm land`
puts it on main.

## Versions

Landing bumps the version, not each work commit (tpm CLAUDE.md "Landing bumps the version"): session commits add
CHANGELOG entries under `[Unreleased]` without bumping. This repo's version is its next crates.io release
(`bump = "at-publish"` in tpm's repos.toml): `tpm land` never bumps or tags it on its own; `tpm release
usb_msc_device` does, once there is something to publish.
