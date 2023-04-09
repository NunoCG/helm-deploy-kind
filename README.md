# helm-deploy-kind

## Requirements

---

### Docker

Docker is a tool that allows developers, sys-admins etc. to easily deploy their applications in a sandbox (called containers) to run on the host operating system.

To install, please refer to [Install Docker Desktop](https://docs.docker.com/desktop/)

### Kind

[kind](https://kind.sigs.k8s.io) is a tool for running local Kubernetes clusters using Docker container “nodes”.

To install, please refer to [Installation](https://kind.sigs.k8s.io/docs/user/quick-start/#installation) guide.

### Helm

Helm is the package manager for Kubernetes.

To install, please refer to [Installing Helm](https://helm.sh/docs/intro/install/) guide.

### Kubectl

The Kubernetes command-line tool, [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/), allows you to run commands against Kubernetes clusters.

To Install, please refer to this [guide](https://kubernetes.io/docs/tasks/tools/).

### jq

jq is a lightweight and flexible command-line JSON processor.

To Install, please refer to this [guide](https://stedolan.github.io/jq/download/).


- Create a .env file in the root of the project with this values:

```bash
KIND_CLUSTER_NAME=kind
CLOUD_NATIVE_BACKING_SERVICES_REPO_PATH=/Path/To/Helm/Template/Repo
DASHBOARD_BACKING_SERVICES_REPO_PATH=/Path/To/Docker/Images/Repo
SAP_IUSER=i569599
ARTIFACTORY_API_TOKEN=cmVmdGtuOjAxOjE2OTkxMTEwMTQ6bktRbE5JU01BdjBvVzR0cHE0dGpnd0lyRTJo
SBSS_IMG=sbss
SBSS_IMG_TAG=0.0.1
DASHBOARD_API_IMG=bksvc-dashboard-api
DASHBOARD_API_IMG_TAG=1.0.0
DASHBOARD_UI_IMG=bksvc-dashboard-ui
DASHBOARD_UI_IMG_TAG=1.0.0
RELEASE_NAME=dashboard
```
