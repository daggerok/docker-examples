#!/usr/bin/env bash

echo "create and run global stateful database service"
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
  postgres:9.4-alpine #> /dev/null #2>&1
