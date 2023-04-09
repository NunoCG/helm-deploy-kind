# helm-deploy-kind

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
