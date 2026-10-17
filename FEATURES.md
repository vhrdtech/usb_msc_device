# Features

Single source of truth for what usb_msc_device does and what is planned (see [AGENTS.md](AGENTS.md)).

Status: ✅ done, 🧪 tested against a fake host/transport only, 📋 planned (with a P2628 task), 💡 idea, not filed
as a task yet.

## USB MSC class (`MSC`)

- 📋 **MSC-1 bulk-only-class**: MSC Bulk-Only Transport device class on embassy-usb, two LUNs on one interface
  (`GET_MAX_LUN`, addressed by the CBW's LUN field), an async `Lun` trait, unit attention / media change, write
  protect; SCSI from the host is untrusted (bounded parsing, sense codes instead of panics). Needs `logring`'s
  LOG-3 and VIEW-1 to exercise both LUNs end to end; rePort for the OS tests (Linux/Windows/macOS mounting).
  P2628#16oct-1001g. Plan: `prj/P2628-logring/design/plan.md` R9.
- 💡 **MSC-2 embassy-offer**: offer this crate to `embassy` as an `embassy-usb` device class. Other project's
  repo (tpm CLAUDE.md "Other people's projects"): prepared for the person's review when it comes up, never
  pushed, proposed or discussed on embassy's repo on this crate's own initiative.
