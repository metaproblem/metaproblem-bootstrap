.PHONY: bootstrap
bootstrap: ## bootstrap the current cluster with workloads
	script/bootstrap.sh

.PHONY: argo-password
argo-password: ## Get the initial password for argocd
	k8sec list -n argocd | grep initial | awk '{print $$4}'

.PHONY: update-argocd-password
update-argo-password: ## Update argo admin password
	script/update-argocd-password.sh

.PHONY: argo-add-config-repo
argo-add-config-repo:
	 argocd repo add git@github.com:metaproblem/metaproblem-bootstrap --ssh-private-key-path ~/.ssh/id_rsa_metaproblem_k0s

.PHONY: add-cluster-config
add-cluster-config: ## Get the cluster config from CLUSTER_HOST and splice it into our config
	python script/get_kubeconfig.py

.PHONY: reset-nodes
reset-nodes:
	cssh root@{node1,node2,node3} -a "iptables --flush && iptables -tnat --flush && reboot now"

.PHONY: configure-traefik
configure-traefik: ## Copy traefik-config.yaml to CLUSTER_HOST - assumes root user
	scp templates/traefik-config.yaml root@${CLUSTER_HOST}:/var/lib/rancher/k3s/server/manifests/traefik-config.yaml

.PHONY: add-do-token-secret
add-do-token-secret: ## Add the DigitalOcean token used by External dns
	k8sec set do-token DO_TOKEN=$$DO_TOKEN -n default

add-helm-repos:
	argocd repo add https://charts.kubevela.net/core --type helm --name kubevela
	argocd repo add https://openebs.github.io/charts --type helm --name openebs

make-image-secret:
	./script/create-image-pull-secret.sh
	# TODO HACK - this is skeezy - we should have this specified on workloads
	kubectl patch sa default -n $NAMESPACE -p '"imagePullSecrets": [{"name": "registry-credentials" }]'

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
