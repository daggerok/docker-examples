#!/usr/bin/env bash

export APP_NAME="kong-application"

echo "initialize and run UCP"
docker container run --rm -it --name ucp \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker/ucp:2.2.3 install \
  --admin-username=admin \
  --admin-password=12345678 \
  --swarm-port 3376 \
  --host-address $(ipconfig getifaddr en0) > /dev/null #2>&1

echo "create ${APP_NAME} network"
docker network create -d overlay ${APP_NAME} > /dev/null #2>&1

#echo "initialize registry"
#docker service create --detach=false --name registry --publish 5000:5000 registry:2 > /dev/null #2>&1

echo "create and run global statefull database service"
docker service create --detach=false \
  --name kong-database \
  -p 5432:5432 \
  -e "POSTGRES_USER=kong" \
  -e "POSTGRES_DB=kong" \
  --mode global \
  --health-cmd="pg_isready -U postgres"\
  --health-interval=10s \
  --health-timeout=5s \
  --health-retries=5 \
  --network ${APP_NAME} \
  --mount type=volume,source=postgres-data,destination=/var/lib/postgresql/data,volume-label="type=service",volume-label="name=kong-database" \
  postgres:9.4-alpine > /dev/null #2>&1

echo "run kong migration"
docker service create --detach=true \
  --name migrations \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-database" \
  -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
  --network ${APP_NAME} \
  kong:0.11.0 kong migrations -v up

echo "verify migrations logs"
docker service logs migrations
docker service rm migrations

echo "run stateless services: kong and dashboard"
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
docker service create --detach=false \
  --name dashboard \
  -p 8080:8080 \
  --replicas 1 \
  --network ${APP_NAME} \
  pgbi/kong-dashboard:v2

echo "application is ready"
docker services ls
