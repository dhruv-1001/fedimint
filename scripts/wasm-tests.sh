#!/usr/bin/env bash

set -euo pipefail
export RUST_LOG="${RUST_LOG:-info}"
source ./scripts/build.sh

devimint dev-fed &
echo $! >> $FM_PID_FILE
eval "$(devimint env)"
devimint wait

echo Funding LND gateway e-cash wallet ...
scripts/pegin.sh 20000.0 1 "LND" 

CARGO_BUILD_TARGET_DIR=$CARGO_BUILD_TARGET_DIR/wasm nix develop .#crossWasm -c wasm-pack test --firefox --headless fedimint-wasm-tests
