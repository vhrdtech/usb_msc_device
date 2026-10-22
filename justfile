# usb_msc_device: a USB Mass Storage device class for embassy-usb.

default:
    @just --list

# The tests. `just test`: all of them (test-all), the run of the `tpm land` gate. `just test --changed`: only the
# workspace crates changed against main and the crates that depend on them (tpm test changed), what a session runs
# before tpm work ready.
test *flags:
    if [ "{{flags}}" = "--changed" ]; then tpm test changed -- cargo nextest run --workspace; else {{just_executable()}} test-all {{flags}}; fi

# Tests (host; a fake Lun, no real USB hardware needed) plus a no_std build check
test-all:
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
