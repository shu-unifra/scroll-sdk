# Scroll-stack
This repo host a helm chart which can deploy the scroll-stack. 
It also provides a database and a monitoring stack based on prometheus, loki and grafana.

## Bootstrap
### Get Helm dependencies
Add the bjw-s repo to your helm repo
```bash
helm repo add bjw-s https://bjw-s.github.io/helm-charts
```
Run the following script to get the dependencies of each helm charts
```bash
./helm-bootstrap.sh
```

### Generate the config files
Run this command to generate config.toml file and genesis file
```bash
cd charts/scroll-stack
time docker run --rm -it -v .:/contracts/volume scrolltech/scroll-stack-contracts:gen-configs-e2b87879
```

## Launch scroll-stack
Run this from the `charts/scroll-stack` folder
```bash
helm install scroll-stack . 
```

## Monitoring
### Blockscout
1. Using port-forward : 
Reach blockscout to check transactions 
```bash
kubectl port-forward svc/blockscout 8080:3000
```
Then go to your browser and check `http://localhost:8080/`

2. Using /etc/hosts
If you enabled ingress on your cluster, you can add the following entries
```txt
1.2.3.4    blockscout.local
```
where `1.2.3.4` is the ip of your cluster.
Then go to your browser and check `http://blockscout.devnet/`

### Grafana
1. Using port-forward :
```bash
kubectl port-forward svc/grafana 8081:3000
```
Then go to your browser and check `http://localhost:8081/`

2. Using /etc/hosts
   If you enabled ingress on your cluster, you can add the following entries
```txt
1.2.3.4    grafana.local
```
where `1.2.3.4` is the ip of your cluster.
Then go to your browser and check `http://grafana.devnet/`

## Change the database endpoint
If you don't want to use the postgres database provided in this chart, you can set your own database.
1. Change the values in the value.yaml file :  
```txt
db:
  pg_host: "postgresql"
  pg_user: "postgres"
  pg_password: "qwerty12345"
  pg_port: "5432"
  bridge_history_password: "test1234"
  chain_monitor_password: "test1234"
  event_watcher_password: "test1234"
  gas_oracle_password: "test1234"
  rollup_relayer_password: "test1234"
  rpc_gateway_password: "test1234"
```
Note, the user for each service will be created but is not used yet by the service.
Each service uses the admin account.

2. Change the config.toml file
Provide the correct db string on the DB section.

