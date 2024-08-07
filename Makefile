bootstrap:
		bash helm-bootstrap.sh
		bash create-env-files.sh
		cd charts/scroll-stack && time docker run --rm -it -v .:/contracts/volume jayjayjayjay/scroll-stack-contracts:gen-configs-gastoken-v0.0.3

install:
		helm install scroll-stack charts/scroll-stack

deploy-contracts:
		cd charts/scroll-stack && time docker run --rm -it -v .:/contracts/volume -v ./broadcast:/contracts/broadcast  --env-file ./configs/contracts.env --network host jayjayjayjay/scroll-stack-contracts:deploy-gastoken-v0.0.3

reload-env-files:
		bash create-env-files.sh

uninstall:
		helm uninstall scroll-stack

upgrade:
		helm upgrade scroll-stack charts/scroll-stack