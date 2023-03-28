#!/usr/bin/env bash

source ./scripts/lib.sh

# wait for bitcoin RPC, lightningd & fedimint block sync
await_bitcoind_ready
await_lightning_node_block_processing | show_verbose_output
await_fedimint_block_sync | show_verbose_output

echo Setting up lightning channel ...
open_channel | show_verbose_output

echo Funding user e-cash wallet ...
scripts/pegin.sh 10000.0 | show_verbose_output

# gatewayd needs a channel or initialization takes 20 seconds longer,
# we wait for channel to open before waiting for it
await_gateway_registered | show_verbose_output

echo Funding gateway e-cash wallet ...
scripts/pegin.sh 20000.0 1 | show_verbose_output

echo Done!
echo
echo "This shell provides the following aliases:"
echo ""
echo "  fedimint-cli   - cli client to interact with the federation"
echo "  lightning-cli  - cli client for Core Lightning"
echo "  lncli          - cli client for LND"
echo "  bitcoin-cli    - cli client for bitcoind"
echo "  gwcli-cln      - cli client for the Core Lightning gateway"
echo "  gwcli-lnd      - cli client for the LND gateway"
echo
echo "Use '--help' on each command for more information"
echo ""
echo "Important tmux key sequences:"
echo ""
echo "  ctrl+b <num>          - switching between panels (num: 1 or 2)"
echo "  ctrl+b :kill-session  - quit tmuxinator"
