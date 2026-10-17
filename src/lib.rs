//! `usb_msc_device`: a USB Mass Storage device class for [embassy-usb](https://github.com/embassy-rs/embassy).
//!
//! Bulk-Only Transport, SCSI transparent command set, several LUNs on one interface (embassy-usb today only has
//! a host-side MSC), an async `Lun` trait, media change / unit attention and write protect. Knows nothing about
//! [logring](https://github.com/vhrdtech/logring) or any other caller. See `AGENTS.md` and `FEATURES.md`; the
//! device class itself lands in R9 (P2628#16oct-1001g).
#![no_std]
