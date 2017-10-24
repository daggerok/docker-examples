#!/usr/bin/env bash

echo "run stateless dashboard service"
docker service create --detach=false \
  --name dashboard \
  -p 8080:8080 \
  --replicas 1 \
  --network ${APP_NAME} \
  pgbi/kong-dashboard:v2
sleep 2
