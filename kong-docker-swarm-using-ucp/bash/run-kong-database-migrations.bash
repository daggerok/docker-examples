#!/usr/bin/env bash

docker pull kong:0.11.0
echo "run kong-database migration"
docker service create --detach=true \
  --name migrations \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-database" \
  -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
  --network ${APP_NAME} \
  kong:0.11.0 kong migrations -v up

sleep 2
echo "verify migrations logs"
docker service logs migrations
docker service rm migrations
