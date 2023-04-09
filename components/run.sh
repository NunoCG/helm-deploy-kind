#!/bin/sh

set -e

set -a
source ../.env
set +a

#########################################
# SETUP POSTGRESQL DATABASES            #
#########################################
printf -- 'Preparing PostgreSQL Instances \n';
(cd postgresql; ./setup.sh > /dev/null)
printf -- '\033[32m PostgresSQL Instances created \033[0m\n';
