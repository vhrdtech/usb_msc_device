# usb_msc_device: a USB Mass Storage device class for embassy-usb.

default:
    @just --list

# The tests. `just test`: all of them (test-all), the gate run before merging. `just test --changed`: only the
# workspace crates changed against main and the crates that depend on them, what to run before opening a PR
# (uses our internal tooling when available, otherwise falls back to the full suite).
test *flags:
    if [ "{{flags}}" = "--changed" ]; then \
        if command -v tpm >/dev/null 2>&1; then tpm test changed -- cargo nextest run --workspace; \
        else echo "tpm not found; running the full test suite instead" >&2; {{just_executable()}} test-all; fi; \
    else {{just_executable()}} test-all {{flags}}; fi

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

# Bring this checkout up to main
deploy:
    if command -v tpm >/dev/null 2>&1; then tpm repos pull usb_msc_device; else git pull --ff-only; fi
