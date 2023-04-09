#!/bin/sh

set -e

set -a
source ../.env
set +a

#########################################
# CREATE KUBERNETES CLUSTER             #
#########################################
printf -- "Setting Up Kubernetes Cluster: '$KIND_CLUSTER_NAME' \n";
if [[ "$(docker ps -q -f name="$KIND_CLUSTER_NAME" 2> /dev/null)" == "" ]]; then
    kind create cluster --config=config.yaml
    printf -- '\033[32m Cluster created successfully \033[0m\n';
else
    echo Cluster "'$KIND_CLUSTER_NAME'" already created.
fi

#########################################
# INSTALL AN INGRESS CONTROLLER (NGINX) #
#########################################
printf -- 'Installing NGINX Ingress Controller \n';
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml > /dev/null

kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=120s > /dev/null
printf -- '\033[32m Ingress Controller Installed \033[0m\n';