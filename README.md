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

# At this point you may want to test things - see `hack/nginx.yaml` for a quick test manifest

make add-helm-repos
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
- Crossplane Demo pt 1
  - Create a pod for the workload
  - Create a Service for the workload
  - Create an ingress for the workload
  - Create TLS for the workload
  - Create SLA queries using sloth
  - Create a redis instance using DO crossplane provider
  - Create a postgres instance using DO crossplane provider
- Crossplane Demo pt 2
  - Install config-controller
  - Create a damn org
  - Configure config-controller
  - Create a redis instance for the workload
  - Create a db for the workload
- Crossplane Demo pt 3
  - Does cuelang get us anything special? Can we test our setup better with cuelang? Can we just ues conftest or something similar plus kind/skaffold/tilt?
- Add vault
- Dagger? Is it shit? Can I leverage it to get quick CI with local loop?
- If Dagger is shit, how about earthly?
- If both are shit, i guess...build one?
- Add pomerium
- Deploy kong ingress controller?
- deploy sock shop
- Deploy k6?
- Use sloth to monitor SLOs
- Install rancher
- Add secrets for pulling images from DO image repo
- Add workload: crossplane?
- Whats that one universal controller thing? the write-your-controller-as-yaml thing?
- Add workload: osiris
- Automate generation of kubevela config for argocd, insert into bootstrap process at proper point
# DOING

- Add vela configuration to argocd configmap (see https://www.cncf.io/blog/2020/12/22/argocd-kubevela-gitops-with-developer-centric-experience/)

## DONE
- Add n8n
- Get openebs working for CSI
- simple web service that lets you set the % of time it succeeds/fails
- Add sloth
- Add openebs
- fix cert manager
- Add workload: prometheus
- Add workload: prometheus operator
- add imagepullsecrets
- Add workload: Kubevela
  - Add helm chart repository to argocd lol
  - Create Proxy Chart for kubevela
- add .gitignore
- add bootstrap folder to install gitops operator (argocd) incl. projects
- Add meta-apps folder to hold apps of apps - .e.g. production, etc

## Misc
- Velaux doesnt seem to have any supported installation methods outside `vela addon enable` - ask about this in CNCF slack
