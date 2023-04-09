#!/bin/sh

#########################################
# LOAD DOCKER IMAGE TO CLUSTER          #
#########################################
printf -- 'Pull postgres docker image...\n';
docker pull -q postgres:14-alpine
printf -- '\033[32m Completed \033[0m\n';
printf -- 'Loading dashboard-postgres docker image...\n';
kind load docker-image postgres:14-alpine --nodes kind-worker,kind-worker2 -q
printf -- '\033[32m Completed \033[0m\n';

#########################################
# SETUP POSTGRES                        #
#########################################
kubectl create -f shared-services-ns.yml

kubectl create -f shared-svc-accnt.yml

kubectl apply -f deployment.yml

kubectl wait --namespace shared-services --for=condition=ready pod --selector=app=postgresql-db --timeout=120s > /dev/null