# l2-bootnode

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![AppVersion: v0.1.0](https://img.shields.io/badge/AppVersion-v0.1.0-informational?style=flat-square)

l2-bootnode helm chart

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| scroll-tech | <sebastien@scroll.io> |  |

## Requirements

Kubernetes: `>=1.22.0-0`

| Repository | Name | Version |
|------------|------|---------|
| oci://ghcr.io/scroll-tech/scroll-sdk/helm | common | 1.5.1 |
| oci://ghcr.io/scroll-tech/scroll-sdk/helm | external-secrets-lib | 0.0.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| command[0] | string | `"bash"` |  |
| command[1] | string | `"-c"` |  |
| command[2] | string | `"geth --datadir \"/l2geth/data\" init /l2geth/genesis/genesis.json && echo ${L2GETH_NODEKEY} > /l2geth/data/geth/nodekey && echo \"[Node.P2P] StaticNodes = $L2GETH_PEER_LIST\" > \"/l2geth/config.toml\" && geth --datadir \"/l2geth/data\" --port \"$L2GETH_P2P_PORT\" --syncmode full --networkid \"$CHAIN_ID\" --maxpeers \"$L2GETH_MAX_PEERS\" --netrestrict \"$L2GETH_NETRESTRICT\" --nat \"$L2GETH_NAT\" --bootnodes \"\" --gcmode archive --config \"/l2geth/config.toml\" --cache.noprefetch --verbosity 3 --pprof --pprof.addr \"0.0.0.0\" --pprof.port 6060 $L2GETH_CCC_FLAG --ccc.numworkers \"$L2GETH_CCC_NUMWORKERS\" $METRICS_FLAGS --txpool.globalqueue \"$L2GETH_GLOBAL_QUEUE\" --txpool.accountqueue \"$L2GETH_ACCOUNT_QUEUE\" --txpool.globalslots \"$L2GETH_GLOBAL_SLOTS\" --txpool.accountslots \"$L2GETH_ACCOUNT_SLOTS\" --txpool.pricelimit \"$L2GETH_MIN_GAS_PRICE\" $LOCALS_FLAG --l1.endpoint \"$L2GETH_L1_ENDPOINT\" --l1.confirmations \"$L2GETH_L1_WATCHER_CONFIRMATIONS\" --l1.sync.startblock \"$L2GETH_L1_CONTRACT_DEPLOYMENT_BLOCK\" --miner.gasprice \"$L2GETH_MIN_GAS_PRICE\" --rpc.gascap 0 --gpo.ignoreprice \"$L2GETH_MIN_GAS_PRICE\" --metrics --metrics.expensive $L2GETH_EXTRA_PARAMS"` |  |
| controller.replicas | int | `1` |  |
| controller.strategy | string | `"RollingUpdate"` |  |
| controller.type | string | `"statefulset"` |  |
| defaultProbes.custom | bool | `true` |  |
| defaultProbes.enabled | bool | `false` |  |
| defaultProbes.spec.httpGet.path | string | `"/"` |  |
| defaultProbes.spec.httpGet.port | int | `8545` |  |
| envFrom[0].configMapRef.name | string | `"l2-bootnode-env"` |  |
| env[0].name | string | `"L2GETH_L1_CONTRACT_DEPLOYMENT_BLOCK"` |  |
| env[0].value | string | `"0"` |  |
| env[10].name | string | `"L2GETH_GLOBAL_SLOTS"` |  |
| env[10].value | string | `"40960"` |  |
| env[11].name | string | `"L2GETH_ACCOUNT_SLOTS"` |  |
| env[11].value | string | `"128"` |  |
| env[12].name | string | `"L2GETH_EXTRA_PARAMS"` |  |
| env[12].value | string | `""` |  |
| env[1].name | string | `"L2GETH_L1_WATCHER_CONFIRMATIONS"` |  |
| env[1].value | string | `"0x6"` |  |
| env[2].name | string | `"L2GETH_P2P_PORT"` |  |
| env[2].value | int | `30303` |  |
| env[3].name | string | `"L2GETH_CCC_FLAG"` |  |
| env[3].value | string | `"--ccc"` |  |
| env[4].name | string | `"L2GETH_CCC_NUMWORKERS"` |  |
| env[4].value | string | `"5"` |  |
| env[5].name | string | `"L2GETH_MAX_PEERS"` |  |
| env[5].value | int | `500` |  |
| env[6].name | string | `"VERBOSITY"` |  |
| env[6].value | int | `3` |  |
| env[7].name | string | `"L2GETH_MIN_GAS_PRICE"` |  |
| env[7].value | string | `"1000000"` |  |
| env[8].name | string | `"L2GETH_GLOBAL_QUEUE"` |  |
| env[8].value | string | `"4096"` |  |
| env[9].name | string | `"L2GETH_ACCOUNT_QUEUE"` |  |
| env[9].value | string | `"256"` |  |
| global.fullnameOverride | string | `"l2-bootnode"` |  |
| global.nameOverride | string | `"l2-bootnode"` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"scrolltech/l2geth"` |  |
| image.tag | string | `"scroll-v5.7.25"` |  |
| initContainers.wait-for-l1.command[0] | string | `"/bin/sh"` |  |
| initContainers.wait-for-l1.command[1] | string | `"-c"` |  |
| initContainers.wait-for-l1.command[2] | string | `"/wait-for-l1.sh $L2GETH_L1_ENDPOINT"` |  |
| initContainers.wait-for-l1.envFrom[0].configMapRef.name | string | `"l2-bootnode-env"` |  |
| initContainers.wait-for-l1.image | string | `"scrolltech/scroll-alpine:v0.0.1"` |  |
| initContainers.wait-for-l1.volumeMounts[0].mountPath | string | `"/wait-for-l1.sh"` |  |
| initContainers.wait-for-l1.volumeMounts[0].name | string | `"wait-for-l1-script"` |  |
| initContainers.wait-for-l1.volumeMounts[0].subPath | string | `"wait-for-l1.sh"` |  |
| persistence.data.accessMode | string | `"ReadWriteOnce"` |  |
| persistence.data.enabled | bool | `true` |  |
| persistence.data.mountPath | string | `"/l2geth/data"` |  |
| persistence.data.size | string | `"10Gi"` |  |
| persistence.data.type | string | `"pvc"` |  |
| persistence.env.enabled | bool | `true` |  |
| persistence.env.mountPath | string | `"/config/"` |  |
| persistence.env.name | string | `"l2-bootnode-env"` |  |
| persistence.env.type | string | `"configMap"` |  |
| persistence.genesis.enabled | bool | `true` |  |
| persistence.genesis.mountPath | string | `"/l2geth/genesis/"` |  |
| persistence.genesis.name | string | `"genesis-config"` |  |
| persistence.genesis.type | string | `"configMap"` |  |
| persistence.wait-for-l1-script.defaultMode | string | `"0777"` |  |
| persistence.wait-for-l1-script.enabled | bool | `true` |  |
| persistence.wait-for-l1-script.name | string | `"wait-for-l1-script"` |  |
| persistence.wait-for-l1-script.type | string | `"configMap"` |  |
| probes.liveness.<<.custom | bool | `true` |  |
| probes.liveness.<<.enabled | bool | `false` |  |
| probes.liveness.<<.spec.httpGet.path | string | `"/"` |  |
| probes.liveness.<<.spec.httpGet.port | int | `8545` |  |
| probes.readiness.<<.custom | bool | `true` |  |
| probes.readiness.<<.enabled | bool | `false` |  |
| probes.readiness.<<.spec.httpGet.path | string | `"/"` |  |
| probes.readiness.<<.spec.httpGet.port | int | `8545` |  |
| probes.startup.<<.custom | bool | `true` |  |
| probes.startup.<<.enabled | bool | `false` |  |
| probes.startup.<<.spec.httpGet.path | string | `"/"` |  |
| probes.startup.<<.spec.httpGet.port | int | `8545` |  |
| service.main.enabled | bool | `true` |  |
| service.main.ports.http.enabled | bool | `true` |  |
| service.main.ports.http.port | int | `30303` |  |
| service.main.ports.metrics.enabled | bool | `true` |  |
| service.main.ports.metrics.port | int | `6060` |  |
| service.main.ports.metrics.targetPort | int | `6060` |  |
| serviceMonitor.main.enabled | bool | `true` |  |
| serviceMonitor.main.endpoints[0].interval | string | `"1m"` |  |
| serviceMonitor.main.endpoints[0].path | string | `"/debug/metrics/prometheus"` |  |
| serviceMonitor.main.endpoints[0].port | string | `"metrics"` |  |
| serviceMonitor.main.endpoints[0].scrapeTimeout | string | `"10s"` |  |
| serviceMonitor.main.labels.release | string | `"scroll-sdk"` |  |
| serviceMonitor.main.serviceName | string | `"{{ include \"scroll.common.lib.chart.names.fullname\" $ }}"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
