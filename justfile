# usb_msc_device: a USB Mass Storage device class for embassy-usb.

default:
    @just --list

# Tests (host; a fake Lun, no real USB hardware needed) plus a no_std build check
test:
    cargo test --quiet
    cargo check --target thumbv8m.main-none-eabihf

# Format check, cargo-sort, typos and clippy without warnings
lint:
    cargo fmt --all --check
    cargo sort --check
    typos
    cargo clippy --all-targets -- -D warnings
    cargo clippy --target thumbv8m.main-none-eabihf -- -D warnings

# Library only: nothing to install on this PC
install: test

# Bring this PC up to main
deploy:
    tpm repos pull usb_msc_device
