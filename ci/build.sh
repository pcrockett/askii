#!/usr/bin/env bash
set -Eeuo pipefail

cargo clippy
make dist/bin/askii
