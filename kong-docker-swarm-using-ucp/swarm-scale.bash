#!/usr/bin/env bash

export APP_NAME="kong-application"
export CONTAINER_NAME="ucp"

echo "scale out"
docker service scale --detach=false kong=3
docker service scale --detach=false dashboard=2
docker services ls
