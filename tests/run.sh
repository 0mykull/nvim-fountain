#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
export NVIM_FOUNTAIN_ROOT="$ROOT"
exec nvim --headless --clean -u "$ROOT/tests/init.lua"
