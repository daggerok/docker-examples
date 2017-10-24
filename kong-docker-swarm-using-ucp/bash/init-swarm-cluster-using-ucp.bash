#!/usr/bin/env bash

echo "initialize and run UCP"
docker container run --rm -it --name ${CONTAINER_NAME} \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker/ucp:2.2.3 install \
  --admin-username=admin \
  --admin-password=12345678 \
  --swarm-port 3376 \
  --host-address $(ipconfig getifaddr en0) #> /dev/null #2>&1

echo "create ${APP_NAME} network"
docker network create -d overlay ${APP_NAME} #> /dev/null #2>&1
