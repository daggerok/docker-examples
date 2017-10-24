#!/usr/bin/env bash

echo "run stateless kong service"
docker service create --detach=false \
  --name kong \
  -p 8000:8000 \
  -p 8001:8001 \
  -p 8443:8443 \
  -p 8444:8444 \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-database" \
  -e "KONG_PG_DATABASE=kong" \
  --replicas 1 \
  --health-cmd="curl -I -s -L http://127.0.0.1:8000 || exit 1"\
  --health-interval=10s \
  --health-timeout=5s \
  --health-retries=5 \
  --network ${APP_NAME} \
  --mount type=volume,source=kong-data,destination=/usr/local/kong,volume-label="type=service",volume-label="name=kong" \
  kong:0.11.0
