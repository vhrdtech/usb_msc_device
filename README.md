# usb_msc_device

A USB Mass Storage device class for [embassy-usb](https://github.com/embassy-rs/embassy): Bulk-Only Transport,
SCSI transparent command set, several LUNs on one interface, an async `Lun` trait, media change (unit attention)
and write protect. `embassy-usb` only has a host-side MSC class today; this is the device side.

```rust
let msc = UsbMscClass::new(&mut builder, [&mut lun0, &mut lun1]);
```

Implement `Lun` for your storage (a block device, a RAM disk, a synthesized read-only volume) and the class
handles the Bulk-Only Transport state machine and SCSI commands.

Built for [logring](https://github.com/vhrdtech/logring)'s two-LUN USB view; usable on its own by anyone who
needs a device-side USB disk on embassy-usb.

See [AGENTS.md](AGENTS.md) for the design, [FEATURES.md](FEATURES.md) for what is implemented and planned, and
[CHANGELOG.md](CHANGELOG.md) for the history.

Licensed under MIT OR Apache-2.0.
