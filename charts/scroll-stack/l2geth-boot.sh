#!/bin/bash

require () {
  local name="$1"
  local value="${!name}"

  if [ -z "${value}" ]; then
    echo "Configuration error: ${name} not set in env"
    exit 1
  fi
}

# Check genesis
if [ ! -f "/l2geth/genesis/genesis.json" ]; then
    echo "Configuration error: /l2geth/genesis/genesis.json not found"
    exit 1
fi

# Check required envs
require "CHAIN_ID"
require "L2GETH_L1_CONTRACT_DEPLOYMENT_BLOCK"
require "L2GETH_L1_ENDPOINT"
require "L2GETH_L1_WATCHER_CONFIRMATIONS"
require "L2GETH_ROLE"

# Set default values
L2GETH_MAX_PEERS=${L2GETH_MAX_PEERS:-500}
L2GETH_MIN_GAS_PRICE=${L2GETH_MIN_GAS_PRICE:-1000000}
L2GETH_P2P_PORT=${L2GETH_P2P_PORT:-30303}
L2GETH_PPROF_PORT=${L2GETH_PPROF_PORT:-6060}
L2GETH_RPC_HTTP_PORT=${L2GETH_RPC_HTTP_PORT:-8545}
L2GETH_RPC_WS_PORT=${L2GETH_RPC_WS_PORT:-8546}
VERBOSITY=${VERBOSITY:-3}

# Export RUST_LOG for CCC
export RUST_LOG="${L2GETH_CCC_RUST_LOG_LEVEL:-"info"}"
echo "using ccc Rust log level \"$RUST_LOG\""

# Common command options
COMMON_OPTS=(
  --cache.noprefetch
  --datadir "/l2geth/data"
  --gcmode archive
  --gpo.ignoreprice "${L2GETH_MIN_GAS_PRICE}"
  --l1.confirmations "${L2GETH_L1_WATCHER_CONFIRMATIONS}"
  --l1.endpoint "${L2GETH_L1_ENDPOINT}"
  --l1.sync.startblock "${L2GETH_L1_CONTRACT_DEPLOYMENT_BLOCK}"
  --metrics
  --metrics.expensive
  --miner.gasprice "${L2GETH_MIN_GAS_PRICE}"
  --networkid "${CHAIN_ID}"
  --port "${L2GETH_P2P_PORT}"
  --rpc.gascap 0
  --syncmode full
  --txpool.globalqueue 4096
  --txpool.globalslots 40960
  --txpool.pricelimit "${L2GETH_MIN_GAS_PRICE}"
  --verbosity "${VERBOSITY}"
  ${LOCALS_FLAG}
  ${L2GETH_EXTRA_PARAMS}
)

# Role specific options
case "${L2GETH_ROLE}" in
  rpc)
    ROLE_OPTS=(
      --config "/l2geth/config.toml"
      --nodiscover
      --http --http.port "${L2GETH_RPC_HTTP_PORT}" --http.addr "0.0.0.0" --http.vhosts="*" --http.corsdomain '*' --http.api "eth,scroll,net,web3,debug"
      --ws --ws.port "${L2GETH_RPC_WS_PORT}" --ws.addr "0.0.0.0" --ws.api "eth,scroll,net,web3,debug"
      --pprof --pprof.port "${L2GETH_PPROF_PORT}" --pprof.addr "0.0.0.0"
      --gpo.percentile 20 --gpo.blocks 100
      --rollup.verify
    )
    ;;
  bootnode)
    ROLE_OPTS=(
      --config "/l2geth/config.toml"
      --maxpeers "${L2GETH_MAX_PEERS}"
      --pprof --pprof.port "${L2GETH_PPROF_PORT}" --pprof.addr "0.0.0.0"
      --rollup.verify
    )
    ;;
  sequencer)
    ROLE_OPTS=(
      --config "/l2geth/config.toml"
      --nodiscover
      --pprof --pprof.port "${L2GETH_PPROF_PORT}" --pprof.addr "0.0.0.0"
      --unlock "${L2GETH_SIGNER_ADDRESS}" --password "/l2geth/password" --allow-insecure-unlock --mine
    )
    ;;
  *)
    echo "Error: Unknown L2GETH_ROLE value '${L2GETH_ROLE}'"
    exit 1
    ;;
esac

# configure peers
echo "[Node.P2P] StaticNodes = ${L2GETH_PEER_LIST:-"[]"}" > "/l2geth/config.toml"

# configure node p2p identity
if [[ -n "${L2GETH_NODEKEY}" ]]; then
  mkdir -p /l2geth/data/geth
  echo "${L2GETH_NODEKEY}" > /l2geth/data/geth/nodekey
fi

# configure signer node identity
if [ "${L2GETH_ROLE}" == "sequencer" ]; then
    require "L2GETH_KEYSTORE"
    require "L2GETH_PASSWORD"
    require "L2GETH_SIGNER_ADDRESS"
    mkdir -p /l2geth/data/keystore
    echo "${L2GETH_PASSWORD}" > /l2geth/password
    echo "${L2GETH_KEYSTORE}"  > /l2geth/data/keystore/keystore.json
fi

echo
echo "Initializing genesis config"
geth --datadir "/l2geth/data" init "/l2geth/genesis/genesis.json"

echo
echo "Launching l2geth $L2GETH_ROLE node with this command: "
echo "geth \"${COMMON_OPTS[*]}\" \"${ROLE_OPTS[*]}\""
echo
geth "${COMMON_OPTS[@]}" "${ROLE_OPTS[@]}"