#!/usr/bin/env bash
set -x
export APP_NAME="kong-application"
export CONTAINER_NAME="ucp"

bash ./bash/init-swarm-cluster-using-ucp.bash
bash ./bash/create-application-network.bash

bash ./bash/create-and-run-stateful-db-service.bash
bash ./bash/run-kong-database-migrations.bash
bash ./bash/run-kong-service.bash
bash ./bash/run-dashboard-service.bash

echo "application is ready"
docker service ls
