# Bootstrappable Cloud Computing Thunderdome
How we bootstrap our cloud. We use DigitalOcean for DNS. Other than that, this should be fairly generic.

## Setup
You will need to install:
    * `direnv`
    * `argocd` CLI
    * `k0sctl`
    * `make`
    * `k8sec`

Look at `.envrc.example` and using it as a guide, fill out `.envrc` with the relevant values. Then:


```
k0sctl apply
k0sctl kubeconfig > ~/.kube/config # THIS OVERWRITES YOUR CONFIG

make bootstrap
make argo-password # Returns the admin argo password

# In a second terminal or backgrounded...
kubectl port-forward service/argocd-server 8080:8080

argocd login localhost:8080
make argo-add-config-repo # Add your repository to argocd via Make target
make add-do-token-secret # Add your DO_TOKEN to the env for external DNS
```

## Project Anatomy

```
├── bootstrap.sh -> Install argocd, create projects and self-manage argocd
├── meta-apps -> App of apps, one per environment
├── production
├── README.md
├── script -> Scripts, duh
├── staging
├── test -> Local test environment
└── workloads
    └── argocd
        └── install.yaml
```


## TODO
- Rework cert-manager installation - shits borked
- Add workload: Kubevela
- Add workload: prometheus/grafana
- Drone for CI? Or n8n?
- Add secrets for pulling images from DO image repo
- Add workload: n8n
- Add workload: crossplane
- Add workload: OAM
- Add workload: osiris
- Add workload: earthly/drone


## DONE
- add .gitignore
- add bootstrap folder to install gitops operator (argocd) incl. projects
- Add meta-apps folder to hold apps of apps - .e.g. production, etc
