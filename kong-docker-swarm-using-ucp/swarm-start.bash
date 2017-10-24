#!/usr/bin/env bash

export APP_NAME="kong-application"
export CONTAINER_NAME="ucp"

SOURCE="${BASH_SOURCE[0]}"
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

bash ${DIR}/bash/init-swarm-cluster-using-ucp.bash
bash ${DIR}/bash/create-application-network.bash

bash ${DIR}/bash/create-and-run-stateful-db-service.bash
bash ${DIR}/bash/run-kong-database-migrations.bash
bash ${DIR}/bash/run-kong-service.bash
bash ${DIR}/bash/run-dashboard-service.bash

echo "application is ready"
docker service ls
