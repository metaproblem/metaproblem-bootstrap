# Bootstrappable Cloud Computing Thunderdome

## Setup
You will need to install:
    * `direnv`
    * `k0sctl`
    * `make`

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
- Get nginx-ingress working with metallb - nginx daemonset and get it showing default backend
- Argocd has some reference to a traefik crd that doesn't exist...
- Add terraform folder & scripts for terraform (for building cluster)
depending on use case
- Add workload: crossplane
- Add workload: OAM
- Add workload: cert-manager
- Add workload: osiris
- Add workload: argo workflows/events
- Add workload: earthly/drone
- Add workload: grafana/prometheus

## DONE
- add .gitignore
- add bootstrap folder to install gitops operator (argocd) incl. projects
- Add meta-apps folder to hold apps of apps - .e.g. production, etc
