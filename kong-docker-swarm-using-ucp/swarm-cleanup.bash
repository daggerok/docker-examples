#!/usr/bin/env bash

export APP_NAME="kong-application"
export CONTAINER_NAME="ucp"

echo "cleanup"
docker service rm kong-database kong dashboard "$CONTAINER_NAME-agent"
docker network rm ${APP_NAME}
docker swarm leave --force
docker container rm -f -v \
  "$CONTAINER_NAME-controller" \
  "$CONTAINER_NAME-auth-api" \
  "$CONTAINER_NAME-metrics" \
  "$CONTAINER_NAME-swarm-manager" \
  "$CONTAINER_NAME-auth-worker" \
  "$CONTAINER_NAME-auth-store" \
  "$CONTAINER_NAME-kv" \
  "$CONTAINER_NAME-cluster-root-ca" \
  "$CONTAINER_NAME-client-root-ca" \
  "$CONTAINER_NAME-proxy"
docker rm -f -v ucp-reconcile
docker system prune -af --volumes
