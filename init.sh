#!/bin/sh
REPO_PATH="$( cd "$( dirname "$0" )" && pwd )"

set -e

set -a 
source ./.env
set +a

RED='\033[0;31m'
NO_COLOR='\033[0m'

#########################################
# VERIFYING PARAMS                      #
#########################################
if [ [-z ${DASHBOARD_BACKING_SERVICES_REPO_PATH-x} ] && [ -z ${CLOUD_NATIVE_BACKING_SERVICES_REPO_PATH-x} ]];then
    printf -- "[${RED}X${NO_COLOR}] You need to define the 'DASHBOARD_BACKING_SERVICES_REPO_PATH' and 'CLOUD_NATIVE_BACKING_SERVICES_REPO_PATH' environment variables in the .env file \n";
    exit 1
fi

if ! [[ -d "$DASHBOARD_BACKING_SERVICES_REPO_PATH/.git" && -d "$CLOUD_NATIVE_BACKING_SERVICES_REPO_PATH/.git" ]];then
    printf -- "[${RED}X${NO_COLOR}] Define a correct repo path \n";
    exit 1
fi

#########################################
# BUILD DOCKER IMAGES                   #
#########################################
printf -- 'Building Docker Images...\n';

if [[ "$(docker images -q $SBSS_IMG:$SBSS_IMG_TAG 2> /dev/null)" == "" ]]; then
    printf -- "'$SBSS_IMG:$SBSS_IMG_TAG' is not present locally. \n";
    printf -- 'Building SBSS docker image...\n';
    (cd $CLOUD_NATIVE_BACKING_SERVICES_REPO_PATH; docker build --build-arg user=$SAP_IUSER --build-arg password=$ARTIFACTORY_API_TOKEN -f ./build/docker/sbss/Dockerfile -t $SBSS_IMG:$SBSS_IMG_TAG . > /dev/null)
else
    printf -- "'$SBSS_IMG:$SBSS_IMG_TAG' image is already present locally \n";
fi
printf -- '\033[32m Completed \033[0m\n';

if [[ "$(docker images -q $DASHBOARD_API_IMG:$DASHBOARD_API_IMG_TAG 2> /dev/null)" == "" ]]; then
    printf -- "'$DASHBOARD_API_IMG:$DASHBOARD_API_IMG_TAG' is not present locally. \n";
    printf -- 'Building dashboard api docker image...\n';
    (cd $DASHBOARD_BACKING_SERVICES_REPO_PATH/dashboard-api; docker build -f Dockerfile -t $DASHBOARD_API_IMG:$DASHBOARD_API_IMG_TAG . > /dev/null)
else
    printf -- "'$DASHBOARD_API_IMG:$DASHBOARD_API_IMG_TAG' image is already present locally \n";
fi

if [[ "$(docker images -q $DASHBOARD_UI_IMG:$DASHBOARD_UI_IMG_TAG 2> /dev/null)" == "" ]]; then
    printf -- "'$DASHBOARD_UI_IMG:$DASHBOARD_UI_IMG_TAG' is not present locally. \n";
    printf -- 'Building dashboard ui docker image...\n';
    (cd $DASHBOARD_BACKING_SERVICES_REPO_PATH/dashboard-ui; docker build -f Dockerfile -t $DASHBOARD_UI_IMG:$DASHBOARD_UI_IMG_TAG . > /dev/null)
else
    printf -- "'$DASHBOARD_UI_IMG:$DASHBOARD_UI_IMG_TAG' image is already present locally \n";
fi
printf -- '\033[32m Completed \033[0m\n';

#########################################
# PREPARE INFRASTRUCTURE                #
#########################################
printf -- 'Preparing Infrastructure \n';
(cd infrastructure; ./run.sh)

#########################################
# DEPLOY COMPONENTS                     #
#########################################
printf -- 'Deploying Components \n';
(cd components; ./run.sh)

#########################################
# LOAD DOCKER IMAGES TO CLUSTER         #
#########################################
printf -- 'Loading Docker Images to Kubernetes Cluster...\n';
printf -- 'Loading SBSS docker image...\n';
kind load docker-image $SBSS_IMG:$SBSS_IMG_TAG --nodes kind-worker,kind-worker2
printf -- 'Loading dashboard api docker image...\n';
kind load docker-image $DASHBOARD_API_IMG:$DASHBOARD_API_IMG_TAG --nodes kind-worker,kind-worker2
printf -- 'Loading dashboard ui docker image...\n';
kind load docker-image $DASHBOARD_UI_IMG:$DASHBOARD_UI_IMG_TAG --nodes kind-worker,kind-worker2
printf -- '\033[32m Completed \033[0m\n';

#########################################
# DEPLOY HELM CHART                     #
#########################################
printf -- 'Deploying Dashboard...\n';
helm upgrade --install --wait --timeout 60s $RELEASE_NAME -f $REPO_PATH/helm-charts/dashboard-charts/values.yaml $CLOUD_NATIVE_BACKING_SERVICES_REPO_PATH/lattice/dashboard-charts --debug
printf -- '\033[32m Completed \033[0m\n';

printf -- "===============================\n| Infrastructure is completed |\n===============================";
