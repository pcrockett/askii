#!/usr/bin/env bash
set -Eeuo pipefail

make dist/bin/askii
cargo check --future-incompat-report --release --frozen
